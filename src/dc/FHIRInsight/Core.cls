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
    set_verbose(True)

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
        def get_company_info(company_url: str) -> dict:
            """
                Fetch detailed information about a company from LinkedIn, 
                including phone, headline, domain, and size.
            """
            if not isinstance(company_url, str):
                return {"error": "Invalid URL type"}
            return iris.cls(__name__).LinkedInCompanyExtactor(company_url)

        def searcher_by_sector(company_sector: str, region: str = "br") -> list:
            """Search companies by sector in LinkedIn"""
            if not isinstance(company_sector, str):
                return []
            find_by = f"empresas {company_sector} linkedin"
            return iris.cls(__name__).SearcherTool(find_by, region)


        # Define tools list
        tools = [
            Tool(
                name="searcher_by_sector",
                func=searcher_by_sector,
                description="Search companies by sector in LinkedIn"
            ),
            Tool(
                name="get_company_info",
                func=get_company_info,
                description="Fetch detailed and precise information about a company from LinkedIn, including phone, website, headline, domain, and size."
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
    
    Use EXACTLY the following format:

    ```
    Thought: I need to analyze the Input and determine the next step
    Action: the action to be taken, must be one of [{tool_names}]
    Action Input: [tool input]
    Observation: [tool output]
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: now I know the final answer
    Final Answer: [Detailed JSON array with analysis and recommendations]
    ```

    {agent_scratchpad}

    **Analysis Requirements:**

    **1. Summary of Key Health Indicators:**
    - Identify and summarize significant health indicators from the blood test data.
    - Highlight abnormalities in glucose and Hemoglobin A1c levels, and any other noteworthy values.

    **2. Disease and Condition Identification:**
    - Assess the test results to identify potential indicators for:
        - Anemia
        - Allergies
        - Infections
        - Diabetes
        - Liver Disease
        - Kidney Disease
        - Thyroid Disorders
        - Heart Disease
        - Blood Clotting Disorders
        - Autoimmune Diseases
        - Nutritional Deficiencies
        - Cancer
        - HIV/AIDS
        - Hormonal Imbalances
        - Bone Disorders

    **3. Health Recommendations:**
    - Provide medically intensive recommendations based on analysis and insights gained from DuckDuckGoSearch.
    - Include specific nutritional and lifestyle advice to potentially aid in managing identified conditions.
    - Always include URLs for the sources of information used.

    Ensure that the final output is suitable for medical professionals and healthcare workers, with detailed insights and professional terminology.
        """

        # Import the necessary agent components
        from langchain.agents import create_react_agent
        from langchain_core.messages import AIMessage, HumanMessage
        from langchain.agents.format_scratchpad import format_to_openai_function_messages
        
        # Create a proper ReAct agent with the correct prompt template
        prompt = ChatPromptTemplate.from_template(template)
        
        # Create a proper ReAct agent
        agent = create_react_agent(
            llm=llm,
            tools=tools,
            prompt=prompt.partial(
                tools=render_text_description(tools),
                tool_names=", ".join([t.name for t in tools])
            )
        )
        
        # Create an agent executor
        agent_executor = AgentExecutor(
            agent=agent,
            tools=tools,
            verbose=True,
            handle_parsing_errors=True
        )
        
        # Execute the agent with the FHIR input
        result = agent_executor.invoke(
            {
                "input": pFHIRinput
            }
        )
        
        # Return the output from the agent execution
        return result.get("output", json.dumps({"error": "No output generated by agent"}))


    except json.JSONDecodeError as e:
        return json.dumps({"error": f"Error parsing company info JSON: {str(e)}"})
    except ValueError as e:
        return json.dumps({"error": f"Validation error: {str(e)}"})
    except Exception as e:
        return json.dumps({"error": f"Unexpected error: {str(e)}"})
}

}
