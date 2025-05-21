Class dc.FHIRInsight.Retrieve Extends %RegisteredObject
{

ClassMethod RetrieveAnswer(input As %String) As %String [ Language = python ]
{
    import os
    import json
    import iris
    from dotenv import load_dotenv
    from langchain_iris import IRISVector

    load_dotenv()

    embedding = ""
    llm_model, model_name = os.getenv("FHIR_INSIGHT_LLM_MODEL").split("/")

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
        docs_with_score = example_db.similarity_search_with_score(input, k=top_k+top_k)
        selector = ["".join(str(doc.page_content)) + " " for doc, _ in docs_with_score]

        return json.dumps(selector)
    except Exception as err:
        return json.dumps({"error": str(err)})
}

}
