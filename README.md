 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/intersystems-iris-dev-template)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fintersystems-iris-dev-template&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fintersystems-iris-dev-template)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fintersystems-iris-dev-template&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fintersystems-iris-dev-template)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)


![FHIRInsight made by AI](./FHIRInsight.png)	

# FHIRInsight
## 🚀 Motivation
Reading blood test results can be confusing — not just for patients, but even for healthcare providers who aren’t experts in lab diagnostics. That’s where FHIRInsight comes in. It takes the complicated FHIR JSON data behind your blood work and turns it into a clear, easy-to-understand report. By using smart technology, FHIRInsight makes health data simpler and more accessible, so anyone can understand what’s going on in their body.

## 🛠️ How It Works
FHIRInsight utilizes several cutting-edge technologies to perform its task:

1. **FHIR**: Fast Healthcare Interoperability Resources (FHIR) standard is used to handle healthcare-related data. It provides the JSON structure required for representing blood test data.

2. **InterSystems IRIS**: A high-performance data platform that supports the storage and querying of the data efficiently.

3. ~~**AI Agent using LangChain**~~ (WIP): The analysis and conversion of the raw data into insightful reports are powered by an AI agent developed with the LangChain framework, offering contextual understanding and generating user-friendly reports.

## 📋 Prerequisites
- Docker and Docker Compose installed on your machine
- Access to the FHIRInsight GitHub repository: [https://github.com/musketeers-br/FHIRInsight](https://github.com/musketeers-br/FHIRInsight)

## 🛠️ Installation

1. **Clone the Repository**
   ```sh
   git clone https://github.com/musketeers-br/FHIRInsight.git
   cd FHIRInsight
   ```

2. **Configure Environment Variables**
   - This project relies on [LiteLLM library](https://github.com/BerriAI/litellm) to accesse several LLM service providers. A complete list of providers and their expected environment variables could be found [here](https://docs.litellm.ai/docs/providers). For instance:
     - To set up an OpenAI API Key: `export OPENAI_API_KEY=your-openai-key`
     - To set up an Anthropic API Key: `export ANTHROPIC_API_KEY=your-anthropic-key`
   - Another variable is the System LLM Model name: `FHIR_INSIGHT_LLM_MODEL`. The value for this variable follows the [LiteLLM definitions](https://docs.litellm.ai/docs/#basic-usage), which you prefix the model name with its provider. For instance:
     - To set up the OpenAI `o4-mini` model: `export FHIR_INSIGHT_LLM_MODEL=openai/o4-mini`
     - To set up the Anthropic `claude-3-sonnet` model: `export FHIR_INSIGHT_LLM_MODEL=anthropic/claude-3-sonnet`
   - You can also set up the model by the Production parameter `LLMModel`
     - By default, this parameter uses a reference to the `FHIR_INSIGHT_LLM_MODEL` environment variable, using the sinxta `@<environment variable>`.
     - But you can define a model directly, like `openai/gpt-4o`, for instance.

3. **Build the Docker Container**
   - Always use the following command to build the container so that no caching interferes, ensuring a clean build process:
     ```sh
     docker-compose build --no-cache --progress=plain
     ```

4. **Start the Application**
   ```sh
   docker-compose up -d
   ```

5. **Wait until IRIS startup**
   ```sh
   docker-compose logs -f
   ```
   Wait until see logs like this:
```bash
fhirinsight-iris-1  | [INFO] ...started InterSystems IRIS instance IRIS
fhirinsight-iris-1  | [INFO] Executing command /docker-entrypoint.sh iris-after-start ...
fhirinsight-iris-1  | [INFO]
```
You can also checkout the [Production](http://localhost:62773/csp/healthshare/irisapp/EnsPortal.ProductionConfig.zen?PRODUCTION=dc.FHIRInsight.i14y.FHIRAnalyzerProduction) for its status

## 💡 How to Use

Once FHIRInsight is up and running, you can start converting FHIR JSON data with blood test information into informative reports. Follow these simple steps:

- Select a FHIR Bundle resource with Patient information, like its demographics, Observations, Encounter etc.
- Issue a HTTP Post to the FHIRInsight REST API.
- The analysis report in Markdown formmat will be gererated

For instance:

```bash
curl --location 'http://localhost:62773/FHIRInsight/analyze' \
--user _system:SYS \
--header 'Content-Type: application/json' \
--data-binary '@./FHIR_Samples/joe.json'
```

If you use Postman, you can find a collection for your convinience [here](./postman/FHIRInsights.postman_collection.json)

With FHIRInsight, transform the complexity of medical data into clarity, empowering patients and healthcare providers to make informed decisions.

### 📂 FHIR Samples
In the repository, you will find a directory named `FHIR_Samples` that contains JSON files, each representing a patient. Each patient entry includes an inferred medical condition based on the JSON data. Below is a summary of the patients and their conditions:

| Patient Name      | Condition (Inferred)                               |
|-------------------|----------------------------------------------------|
| Carter DUMMY      | Normal (No condition detected)                     |
| Emily Johnson     | Type 1 Diabetes                                    |
| Jane Smith        | Hypothyroidism                                     |
| Joe DUMMY         | Anemia                                             |
| John Doe          | Liver dysfunction (Hyperbilirubinemia)             |
| John Ramsey       | Coagulopathy (High INR and PT)                     |
| Mary Doe          | Type 2 Diabetes                                    |
| Phillipe DUMMY    | Normal (No condition detected)                     |
| Sophie D'Abbraccio| Hormonal imbalance (Low Estrogen & Progesterone)   |

These samples serve as a quick reference for testing the application's capabilities to analyze and interpret medical data.

### 🌐 Frontend Testing Interface
FHIRInsight provides a user-friendly frontend page to test and explore the application's functionalities interactively. This frontend is accessible via the following URL:

- **Frontend Page:** [http://localhost:8501](http://localhost:8501)

This page allows users to input data, run analyses, and view results directly through a web interface, enhancing the user experience and providing a visual understanding of how FHIRInsight transforms complex JSON data into insightful reports.

<iframe width="560" height="315" src="https://www.youtube.com/embed/pNae4awjuz4?si=z58vm64882PtbDe2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 🎖️ Credits
FHIRInsight is developed with ❤️ by the Musketeers Team

* [José Roberto Pereira](https://community.intersystems.com/user/jos%C3%A9-roberto-pereira-0)
* [Henry Pereira](https://community.intersystems.com/user/henry-pereira)
* [Henrique Dias](https://community.intersystems.com/user/henrique-dias-2)
