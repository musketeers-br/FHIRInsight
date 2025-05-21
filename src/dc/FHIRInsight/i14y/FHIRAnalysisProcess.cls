Class dc.FHIRInsight.i14y.FHIRAnalysisProcess Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As dc.FHIRInsight.i14y.FHIRAnalysisBPRequest, Output pResponse As dc.FHIRInsight.i14y.FHIRAnalysisBPResponse) As %Status
{
    #dim ex As %Exception.AbstractException
    #dim llmRequest As dc.FHIRInsight.i14y.LLM.Messages.LiteLLMRequest
    #dim llmResponse As dc.FHIRInsight.i14y.LLM.Messages.LiteLLMResponse

    Set tSC = $$$OK
    
    Try {
        // Create and configure the LLM request
        Set llmRequest = ##class(dc.FHIRInsight.i14y.LLM.Messages.LiteLLMRequest).%New()
        Set llmRequest.Model = pRequest.Model
        
        // Build the medical analysis prompt
        Set prompt = ..GetPrompt(pRequest.FHIRBundle)
        
        // Add the message using the helper method
        Set sc = llmRequest.AddMessage("user", prompt)
        If $$$ISERR(sc) {
            Return $$$ERROR($$$GeneralError, "Failed to construct LLM request: "_$System.Status.GetErrorText(sc))
        }
        
        // Optional: Set parameters if needed
        Set llmRequest.Parameters = {"temperature":0.7, "max_tokens":2000}.%ToJSON()
        
        // Call the LLM Business Operation
        Set sc = ..SendRequestSync("LLMService", llmRequest, .llmResponse, 30)
        If $$$ISERR(sc) {
            Return $$$ERROR($$$GeneralError, "Failed to call LLM service: "_$System.Status.GetErrorText(sc))
        }
        If '$IsObject(llmResponse) {
            Return $$$ERROR($$$GeneralError, "No response received from LLM service")
        }
        
        // Check for LLM errors
        If llmResponse.Error '= "" {
            Set errorInfo = {}.%FromJSON(llmResponse.Error)
            Return $$$ERROR($$$GeneralError, "LLM error: "_$Get(errorInfo.message, "Unknown error"))
        }
        
        // Create and populate the response
        Set pResponse = ##class(dc.FHIRInsight.i14y.FHIRAnalysisBPResponse).%New()
        Set pResponse.AnalysisResult = llmResponse.GetFirstCompletion()
    } Catch ex {
        Set tSC = $$$ERROR($$$GeneralError,"Error in FHIRAnalysisProcess: "_ex.DisplayString()_" at "_ex.Location)
    }

    Return tSC
}

Method GetPrompt(fhirBundle As %String) As %String
{
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
        fhirBundle
    
    Return prompt
}

}