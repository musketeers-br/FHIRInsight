Class dc.FHIRInsight.Core Extends %RegisteredObject
{

ClassMethod Execute(pFHIRinput As %String) [ Language = python ]
{
    import os
    import requests
    import json
    import iris
    from dotenv import load_dotenv
    from typing import List, Union

    from langchain.chains import LLMChain
    from langchain_core.prompts import PromptTemplate, ChatPromptTemplate
    from langchain.tools.render import render_text_description
    from langchain.schema import AgentAction, AgentFinish
    from langchain.tools import Tool, tool
    from langchain.agents import AgentExecutor, create_react_agent

    from langchain.globals import set_verbose, set_debug
    from langchain_core.exceptions import OutputParserException
    from langchain.output_parsers import StructuredOutputParser
    from langchain.output_parsers.openai_functions import JsonOutputFunctionsParser
    from langchain.agents.output_parsers import ReActSingleInputOutputParser
    set_verbose(False)  # Disable verbose output to reduce noise

    load_dotenv()

    def get_llm():
        """Returns the appropriate chat model based on AI_ENGINE selection."""
        
        ai_engine = os.getenv("AI_ENGINE")
        api_key = os.getenv("API_KEY")
        model_name = os.getenv("LLM_MODEL_NAME")
        
        if ai_engine == "openai":
            iris.cls("dc.FHIRInsight.Utils").CheckOpenAi()
            os.environ["OPENAI_API_KEY"] = api_key
            from langchain_openai import ChatOpenAI
            return ChatOpenAI(model=model_name, api_key=api_key)

        if ai_engine in ["azureopenai", "azure_openai"]:
            iris.cls("dc.FHIRInsight.Utils").CheckOpenAi()
            azure_endpoint = os.getenv("AZURE_ENDPOINT")
            azure_api_version= os.getenv("API_VERSION")
            if not azure_endpoint:
                raise ValueError("Azure OpenAI requires AZURE_ENDPOINT in .env")
            os.environ["AZURE_OPENAI_API_KEY"] = api_key
            os.environ["AZURE_OPENAI_ENDPOINT"] = azure_endpoint

            from langchain_openai import AzureChatOpenAI
            return AzureChatOpenAI(
                openai_api_version=azure_api_version,
                azure_endpoint=azure_endpoint,
                api_key=api_key,
                model_name=model_name,
                temperature=0
            )

        if ai_engine in ["anthropic", "claude"]:
            iris.cls("dc.FHIRInsight.Utils").CheckAnthropic()
            os.environ["ANTHROPIC_API_KEY"] = api_key
            return ChatAnthropic(model=model_name, api_key=api_key)

        if ai_engine == "gemini":
            iris.cls("dc.FHIRInsight.Utils").CheckGoogleAI()
            os.environ["GOOGLE_API_KEY"] = api_key
            return GoogleGenerativeAI(google_api_key=api_key, model= model_name)
        
        if ai_engine == "ollama":
            iris.cls("dc.FHIRInsight.Utils").CheckOllama()
            from langchain_ollama.llms import OllamaLLM
            return OllamaLLM(model=model_name)
        return None

    try:

        # Define tools with proper error handling
        @tool
        def duckduckgo_searcher(query: str, max_results: int = 5) -> list:
            """Search the web for information using DuckDuckGo.
            
            Args:
                query: The search query string
                max_results: Maximum number of results to return (default: 5)
                
            Returns:
                List of search results with title, link, and snippet
            """
            if not isinstance(query, str) or not query.strip():
                return {"error": "Invalid or empty query"}
            
            try:
                results = json.loads(iris.cls(__name__).DuckDuckGo(query, max_results))
                return results
            except Exception as e:
                return {"error": f"Search failed: {str(e)}"}


        # Define tools list
        tools = [
            Tool(
                name="duckduckgo_searcher",
                func=duckduckgo_searcher,
                description="Search the web for information using DuckDuckGo"
            )
        ]

        def find_tool_by_name(tools: List[Tool], tool_name: str) -> Tool:
            for tool in tools:
                if tool.name == tool_name:
                    return tool
            raise ValueError(f"Tool with name {tool_name} not found")

        # Initialize LLM 
        llm = get_llm()

        template = """
        You are a proficient medical analyst with extensive experience in interpreting blood test results and 
        using internet resources to provide comprehensive health recommendations. 
        You have access to {tools} for sourcing additional information.

        Please generate a detailed medical analysis and health recommendation report using the provided 
        FHIR JSON data for a patient's blood test results. 
        
        IMPORTANT: You MUST follow this EXACT format for your reasoning process:

        ```
        Thought: <your reasoning about what to do next>
        Action: <MUST be one of these tools: {tool_names}>
        Action Input: <input for the tool>
        Observation: <result from the tool>
        ... (this Thought/Action/Action Input/Observation can repeat)
        Thought: <your final reasoning>
        Final Answer: <your detailed narrative health report>
        ```
        
        {agent_scratchpad}

        **Analysis Requirements:**

        Your Final Answer MUST be a detailed narrative report with the following sections:

        **1. Summary of Key Health Indicators:**
        - Provide specific test values with their reference ranges (e.g., "Fasting Glucose: 130 mg/dL (normal range: 70-99 mg/dL)")
        - Highlight abnormalities in glucose, Hemoglobin A1c levels, and any other noteworthy values

        **2. Disease and Condition Identification:**
        - Assess the test results to identify potential indicators for: Anemia, Allergies, Infections, Diabetes, Liver Disease, Kidney Disease, 
            Thyroid Disorders, Heart Disease, Blood Clotting Disorders, Autoimmune Diseases, Nutritional Deficiencies, 
            Cancer, HIV/AIDS, Hormonal Imbalances, Bone Disorders
        - Clearly state if there is insufficient data to assess certain conditions

        **3. Health Recommendations:**
        - Provide detailed medical management recommendations:
            - Consultation needs with specific healthcare providers
        - Include comprehensive nutritional and lifestyle recommendations:
            - Specific dietary guidelines with examples
            - Follow-up care and screening recommendations
        - For each condition identified, include:
            - Condition name
            - Detailed recommendations
            - Source URL for medical information

        Format your report as a detailed narrative with clear section headers, bullet points for readability, 
        and professional medical terminology suitable for healthcare workers. Include specific values, reference ranges, 
        and detailed explanations throughout.
        """

        # Import the necessary agent components
        from langchain.agents import create_react_agent
        from langchain_core.messages import AIMessage, HumanMessage
        from langchain.agents.format_scratchpad import format_to_openai_function_messages
        
        # Create a proper ReAct agent with the correct prompt template
        prompt = ChatPromptTemplate.from_template(template)
        
        # Configure LLM with stricter formatting requirements
        if hasattr(llm, "model_kwargs"):
            llm.model_kwargs.update({"response_format": {"type": "text"}})
        
        # Create a proper ReAct agent with structured output format
        agent = create_react_agent(
            llm=llm,
            tools=tools,
            prompt=prompt.partial(
                tools=render_text_description(tools),
                tool_names=", ".join([t.name for t in tools])
            )
        )
        
        # Create an agent executor with max iterations limit and error handling
        agent_executor = AgentExecutor(
            agent=agent,
            tools=tools,
            verbose=True,
            handle_parsing_errors=True,
            max_iterations=8,  # Limit the number of iterations to prevent excessive resource usage
            early_stopping_method="force",  # Force stop after max_iterations
            return_intermediate_steps=False  # Don't include intermediate steps in the output
        )
        
        # Execute the agent with the FHIR input and handle potential errors
        try:
            result = agent_executor.invoke(
                {
                    "input": pFHIRinput
                }
            )
        except OutputParserException as e:
            # If parsing fails, extract the final answer directly
            if hasattr(e, 'llm_output') and isinstance(e.llm_output, str):
                if "Final Answer:" in e.llm_output:
                    final_answer = e.llm_output.split("Final Answer:")[1].strip()
                    return json.dumps({"insight_report": final_answer})
            return json.dumps({"error": "Failed to parse agent output", "details": str(e)})
        
        # Return the output from the agent execution
        return result.get("output", json.dumps({"error": "No output generated by agent"}))

    except json.JSONDecodeError as e:
        return json.dumps({"error": f"Error parsing company info JSON: {str(e)}"})
    except ValueError as e:
        return json.dumps({"error": f"Validation error: {str(e)}"})
    except Exception as e:
        return json.dumps({"error": f"Unexpected error: {str(e)}"})
}

ClassMethod DuckDuckGo(query As %String, maxResults As %Integer = 5) [ Language = python ]
{
    import json
    from duckduckgo_search import DDGS
    
    try:
        with DDGS() as ddgs:
            results = list(ddgs.text(query, max_results=maxResults))
            return json.dumps(results)
    except Exception as e:
        return json.dumps({"error": f"DuckDuckGo search error: {str(e)}"})
}

}
