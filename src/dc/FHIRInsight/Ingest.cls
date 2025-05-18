Class dc.FHIRInsight.Ingest Extends %RegisteredObject
{

ClassMethod Ingest(modelName As %String, collectionName As %String) As %String [ Language = python ]
{
    import json
    import litellm
    import os
    from langchain_iris import IRISVector
    from langchain_community.document_loaders import WebBaseLoader
    from langchain_text_splitters import RecursiveCharacterTextSplitter

    try:
        loader = WebBaseLoader([
            "https://diabetesjournals.org/care/article/40/4/538/3687/REPLACE-BG-A-Randomized-Trial-Comparing-Continuous",
            "https://diabetesjournals.org/care/article/39/7/1143/37357/Multinational-Home-Use-of-Closed-Loop-Control-Is",
            "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0248560",
            "https://www.nejm.org/doi/full/10.1056/NEJMoa1907863",
            "https://pubmed.ncbi.nlm.nih.gov/17889075/",
            "https://pubmed.ncbi.nlm.nih.gov/33584164/",
            "https://diabetesjournals.org/care/article/39/4/603/29115/Risk-Factors-Associated-With-Severe-Hypoglycemia",
            "https://www.bloodresearch.or.kr/journal/view.html?uid=2711&vmd=Full"
        ])
        docs = loader.load()

        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
        splits = text_splitter.split_documents(docs)

        vectorstore = IRISVector.from_documents(
            documents=splits,
            embedding=litellm.aembedding(model=modelName),
            dimension=1536,
            collection_name=collectionName,
        )

        return json.dumps({"status": True})
    except Exception as err:
        return json.dumps({"error": str(err)})
}

}
