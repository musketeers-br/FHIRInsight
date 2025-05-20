Class dc.FHIRInsight.unittests.i14y.FHIRAnalyzerProductionTest Extends %UnitTest.TestProduction
{
Parameter PRODUCTION = "dc.FHIRInsight.i14y.FHIRAnalyzerProduction";

Parameter IGNOREPRODUCTIONERRORS = 1;

Method OnAfterProductionStart() As %Status
{
    Set fhirBundleStr = {
        "resourceType": "Bundle",
        "type": "collection",
        "entry": [
            {
            "resource": {
                "resourceType": "Patient",
                "id": "example",
                "name": [
                {
                    "use": "official",
                    "family": "DUMMY",
                    "given": ["John"]
                }
                ],
                "gender": "male",
                "birthDate": "1993-05-14"
            }
            },
            {
            "resource": {
                "resourceType": "Observation",
                "id": "hemoglobin",
                "status": "final",
                "category": [
                {
                    "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "laboratory",
                        "display": "Laboratory"
                    }
                    ]
                }
                ],
                "code": {
                "coding": [
                    {
                    "system": "http://loinc.org",
                    "code": "718-7",
                    "display": "Hemoglobin [Mass/volume] in Blood"
                    }
                ]
                },
                "subject": {
                "reference": "Patient/example"
                },
                "effectiveDateTime": "2023-05-14T11:03:00+05:30",
                "valueQuantity": {
                "value": 15.00,
                "unit": "g/dL",
                "system": "http://unitsofmeasure.org",
                "code": "g/dL"
                },
                "referenceRange": [
                {
                    "low": {
                    "value": 13.00,
                    "unit": "g/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "g/dL"
                    },
                    "high": {
                    "value": 17.00,
                    "unit": "g/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "g/dL"
                    }
                }
                ]
            }
            },
            {
            "resource": {
                "resourceType": "Observation",
                "id": "rbc-count",
                "status": "final",
                "category": [
                {
                    "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "laboratory",
                        "display": "Laboratory"
                    }
                    ]
                }
                ],
                "code": {
                "coding": [
                    {
                    "system": "http://loinc.org",
                    "code": "789-8",
                    "display": "Erythrocytes [#/volume] in Blood"
                    }
                ]
                },
                "subject": {
                "reference": "Patient/example"
                },
                "effectiveDateTime": "2023-05-14T11:03:00+05:30",
                "valueQuantity": {
                "value": 4.50,
                "unit": "10^6/uL",
                "system": "http://unitsofmeasure.org",
                "code": "10*6/uL"
                },
                "referenceRange": [
                {
                    "low": {
                    "value": 4.50,
                    "unit": "10^6/uL",
                    "system": "http://unitsofmeasure.org",
                    "code": "10*6/uL"
                    },
                    "high": {
                    "value": 5.50,
                    "unit": "10^6/uL",
                    "system": "http://unitsofmeasure.org",
                    "code": "10*6/uL"
                    }
                }
                ]
            }
            }
        ]
    }.%ToJSON()
    #; Set request = ##class(dc.FHIRInsight.i14y.FHIRBundleRequest).%New()
    #; Set request.FHIRBundle = fhirBundleStr
    #; Set tSC = ..SendRequest("RESTAPI", request, .response, 1)
    #; Do $$$AssertEquals(response.StringValue,"OK","Response should contain OK.")
    #; Set llmRequest = ##class(dc.FHIRInsight.i14y.LLM.Messages.LiteLLMRequest).%New()
    Set llmRequest = ##class(tests.dc.FHIRInsight.unittests.LiteLLMRequestMock).%New()
    Set llmRequest.Model = "openai/o4-mini"
    Set prompt = 
        "You are a proficient medical analyst with extensive experience in interpreting blood test results and providing comprehensive health recommendations. "_$c(10)_
        "Your task is to analyze the provided FHIR JSON data containing a patient's blood test results and "_$c(10)_
        "generate a detailed medical analysis and health recommendation report. "_$c(10)_
        "Please follow the steps below to deliver a comprehensive report:"_$c(10)_
        "    *Analysis Requirements:*"_$c(10)_
        "    Your Final Answer MUST be a detailed narrative report with the following sections:"_$c(10)_
        "    *1. Summary of Key Health Indicators:*"_$c(10)_
        "    - Provide specific test values with their reference ranges (e.g., ""Fasting Glucose: 130 mg/dL (normal range: 70-99 mg/dL)"")"_$c(10)_
        "    - Highlight abnormalities in glucose, Hemoglobin A1c levels, and any other noteworthy values"_$c(10)_
        "    *2. Disease and Condition Identification:*"_$c(10)_
        "    - Assess the test results to identify potential indicators for: Anemia, Allergies, Infections, Diabetes, Liver Disease, Kidney Disease, "_$c(10)_
        "        Thyroid Disorders, Heart Disease, Blood Clotting Disorders, Autoimmune Diseases, Nutritional Deficiencies, "_$c(10)_
        "        Cancer, HIV/AIDS, Hormonal Imbalances, Bone Disorders"_$c(10)_
        "    - Clearly state if there is insufficient data to assess certain conditions"_$c(10)_
        "    *3. Health Recommendations:*"_$c(10)_
        "    - Provide detailed medical management recommendations:"_$c(10)_
        "        - Consultation needs with specific healthcare providers"_$c(10)_
        "    - Include comprehensive nutritional and lifestyle recommendations:"_$c(10)_
        "        - Specific dietary guidelines with examples"_$c(10)_
        "        - Follow-up care and screening recommendations"_$c(10)_
        "    - For each condition identified, include:"_$c(10)_
        "        - Condition name"_$c(10)_
        "        - Detailed recommendations"_$c(10)_
        "        - Source URL for medical information (obtained from the search tool)"_$c(10)_
        "    Format your report as a detailed narrative with clear section headers, bullet points for readability, "_$c(10)_
        "    and professional medical terminology suitable for healthcare workers. Include specific values, reference ranges, "_$c(10)_
        "    and detailed explanations throughout."_$c(10,10)_
        "FHIR JSON:"_$c(10)_
        fhirBundleStr
    Set sc = llmRequest.AddMessage("user", prompt)
    Set llmRequest.Parameters = {"temperature":0.7, "max_tokens":2000}.%ToJSON()
    Set tSC = ..SendRequest("LLMService", llmRequest, .llmResponse, 1)
    Do $$$AssertNotEquals(llmResponse.Choices,"","Response should not be empty.")
    Return $$$OK
}

}