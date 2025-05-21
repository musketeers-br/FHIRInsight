Class dc.FHIRInsight.i14y.FHIRAnalysisService Extends Ens.BusinessService
{

/// An adapaterless BS
Parameter ADAPTER;

Property LLMModel As %String [ Internal, Private ];

Method GetLLMModel() As %String
{
    If ..LLMModel = "" {
        Set ..LLMModel = ##class(dc.FHIRInsight.i14y.Utils).ResolveModelValue(
            ..GetProductionSettingValue("LLMModel")
        )
        If ..LLMModel = "" {
            Throw ##class(%Exception.General).%New("LLM Model undefined.")
        }
        $$$LOGINFO("LLM Model: "_..LLMModel)
    }

	Quit ..LLMModel
}

Method OnProcessInput(pInput As dc.FHIRInsight.i14y.FHIRBundleRequest, Output pOutput As dc.FHIRInsight.i14y.FHIRAnalysisResponse) As %Status
{
    Try {
        // Validate input
        If '$IsObject(pInput) || (pInput.FHIRBundle = "") {
            Return $$$ERROR($$$GeneralError, "Invalid input request")
        }
        
        // Forward to Business Process
        Set bpRequest = ##class(dc.FHIRInsight.i14y.FHIRAnalysisBPRequest).%New()
        Set bpRequest.FHIRBundle = pInput.FHIRBundle
        Set sc = ..SendRequestSync("FHIRAnalysis", bpRequest, .bpResponse)
        
        If $$$ISERR(sc) || '$IsObject(bpResponse) {
            Return $$$ERROR($$$GeneralError, "Business Process failed: "_$System.Status.GetErrorText(sc))
        }
        
        // Return final response
        Set pOutput = ##class(dc.FHIRInsight.i14y.FHIRAnalysisResponse).%New()
        Set pOutput.AnalysisResult = bpResponse.AnalysisResult
        Return $$$OK
        
    } Catch ex {
        Return ex.AsStatus()
    }
}

}
