Class dc.FHIRInsight.Retrieve Extends %RegisteredObject
{

ClassMethod RetrieveAnswer(input As %String, pModel As %String = "") As %String [ Language = python ]
{
    import os
    import json
    import iris
    from dotenv import load_dotenv
    from langchain_iris import IRISVector

    load_dotenv()

    embedding = ""
    # Handle model string robustly
    def _split_model(modelstr):
        parts = modelstr.split("/")
        if len(parts) == 2:
            return parts[0], parts[1]
        elif len(parts) == 1:
            return parts[0], ""
        else:
            raise ValueError(f"Model string '{modelstr}' has unexpected format")

    model_str = os.getenv("FHIR_INSIGHT_LLM_MODEL") if pModel == "" else pModel
    try:
        llm_model, model_name = _split_model(model_str)
    except Exception as err:
        return json.dumps({"error": f"Invalid model string: {model_str}. Error: {str(err)}"})

    if llm_model == "":
        llm_model = "openai"
        model_name = "gpt-3.5-turbo"
    try:
        if llm_model == "openai":
            iris.cls("dc.FHIRInsight.Utils").CheckOpenAi()
            from langchain_openai import OpenAIEmbeddings
            embedding = OpenAIEmbeddings(openai_api_key=os.getenv("OPENAI_API_KEY"))

        if llm_model == "gemini":
            iris.cls("dc.FHIRInsight.Utils").CheckGoogleAI()
            from langchain_google_genai import GoogleGenerativeAIEmbeddings
            embedding = GoogleGenerativeAIEmbeddings(model=model_name)

        if embedding == "":
            return json.dumps({"error": "LLM not found"})

    except Exception as err:
        return json.dumps({"error": str(err)})

    top_k = 3
    try:
        vectorstore = IRISVector(
            embedding_function = embedding,
            dimension =1536,
            collection_name=iris.cls("dc.FHIRInsight.Ingest")._GetParameter("collectionName")
        )
        docs_with_score = vectorstore.similarity_search_with_score(input, k=top_k+top_k)
        selector = ["".join(str(doc.page_content)) + " " for doc, _ in docs_with_score]

        return json.dumps(selector)
    except Exception as err:
        return json.dumps({"error": str(err)})
}

}
