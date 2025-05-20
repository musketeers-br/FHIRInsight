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
--data-binary '@./data/sample1.json'
```

If you use Postman, you can find a collection for your convinience [here](./postman/FHIRInsights.postman_collection.json)

With FHIRInsight, transform the complexity of medical data into clarity, empowering patients and healthcare providers to make informed decisions.


## 🎖️ Credits
FHIRInsight is developed with ❤️ by the Musketeers Team

* [José Roberto Pereira](https://community.intersystems.com/user/jos%C3%A9-roberto-pereira-0)
* [Henry Pereira](https://community.intersystems.com/user/henry-pereira)
* [Henrique Dias](https://community.intersystems.com/user/henrique-dias-2)
