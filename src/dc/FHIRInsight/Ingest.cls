Class dc.FHIRInsight.Ingest Extends %RegisteredObject
{

Parameter collectionName = "FHIRInsightRAG";

ClassMethod WebIngest(pURLs As %String) As %String [ Language = python ]
{
    import os
    import json
    import iris
    from dotenv import load_dotenv
    from langchain_iris import IRISVector
    from langchain_community.document_loaders import WebBaseLoader
    from langchain_text_splitters import RecursiveCharacterTextSplitter

    load_dotenv()

    embedding = ""
    llm_model, model_name = os.getenv("FHIR_INSIGHT_LLM_MODEL").split("/")

    urls = json.loads(pURLs)
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

    try:
        loader = WebBaseLoader(urls)
        docs = loader.load()

        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
        splits = text_splitter.split_documents(docs)

        vectorstore = IRISVector.from_documents(
            documents=splits,
            embedding=embedding,
            dimension=1536,
            collection_name=iris.cls(__name__)._GetParameter("collectionName"),
        )

        return json.dumps({"status": True, "vector_size": len(vectorstore.get()['ids'])})
    except Exception as err:
        return json.dumps({"error": str(err)})
}

ClassMethod PdfIngest(pBase64PDF As %String) As %String [ Language = python ]
{
    import os
    import json
    import iris
    import base64
    from dotenv import load_dotenv
    from langchain_iris import IRISVector
    from langchain_community.document_loaders import PyPDFLoader
    from langchain_text_splitters import RecursiveCharacterTextSplitter
    from io import BytesIO
    import tempfile

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

    try:
        pdf_bytes = base64.b64decode(pBase64PDF)
        #; pdf_file = BytesIO(pdf_bytes)
        #; loader = PyPDFLoader(pdf_file)  # Pass file-like object, not file path
        #; docs = loader.load()
        with tempfile.NamedTemporaryFile(suffix=".pdf", delete=False) as temp_file:
            temp_file.write(pdf_bytes)
            temp_file_path = temp_file.name
        loader = PyPDFLoader(temp_file_path)  # Pass the temporary file path
        docs = loader.load()
        os.remove(temp_file_path)  # Remove the temporary file after use

        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
        splits = text_splitter.split_documents(docs)

        vectorstore = IRISVector.from_documents(
            documents=splits,
            embedding=embedding,
            dimension=1536,
            collection_name=iris.cls(__name__)._GetParameter("collectionName"),
        )

        return json.dumps({"status": True, "vector_size": len(vectorstore.get()['ids'])})
    except Exception as err:
        return json.dumps({"error": str(err)})
}

}
