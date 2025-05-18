/// API that analyzes FHIR Bundle resources and returns Markdown reports<br/>
/// Business logic class defined by OpenAPI in dc.FHIRInsight.api.spec<br/>
/// Created May 18, 2025 14:11:12
Class dc.FHIRInsight.api.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Accepts a FHIR Bundle resource and returns a Markdown analysis report of its contents<br/>
/// The method arguments hold values for:<br/>
///     fhirBundle, FHIR Bundle resource to be analyzed (any valid JSON object)<br/>
ClassMethod %RouteCB1(fhirBundle As %DynamicObject) As %Stream.Object
{
    #dim response As dc.FHIRInsight.i14y.FHIRAnalysisResponse
    #dim businessService As Ens.BusinessService
    
    Try {
        // Validate input
        If '$IsObject(fhirBundle) {
            Do ..%SetStatusCode(400)
            Throw ##class(%Exception.General).%New("Invalid input","400",,"FHIR Bundle must be a valid JSON object")
        }
        
        // Convert the FHIR Bundle to a string
        Set fhirBundleStr = fhirBundle.%ToJSON()
        If fhirBundleStr = "" {
            Do ..%SetStatusCode(400)
            Throw ##class(%Exception.General).%New("Invalid input","400",,"Failed to convert FHIR Bundle to JSON")
        }
        
        // Create request object
        Set request = ##class(dc.FHIRInsight.i14y.FHIRBundleRequest).%New()
        Set request.FHIRBundle = fhirBundleStr
        
        // Get Business Service instance
        Set sc = ##class(Ens.Director).CreateBusinessService("RESTAPI", .businessService)
        If $$$ISERR(sc) || '$IsObject(businessService) {
            Do ..%SetStatusCode(503)
            Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError, "Service unavailable"))
        }
        
        // Process request
        Set sc = businessService.ProcessInput(request, .response)
        If $$$ISERR(sc) || '$IsObject(response) {
            Do ..%SetStatusCode(500)
            Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError, "Processing error"))
        }
        
        // Return successful response
        Do ..%SetStatusCode(200)
        Set stream = ##class(%Stream.GlobalCharacter).%New()
        Do stream.Write(response.AnalysisResult)
        Return stream
        
    } Catch ex {
        // Handle errors
        Set errorStream = ##class(%Stream.GlobalCharacter).%New()
        Do errorStream.Write("{""error"":"""_ex.DisplayString()_"""}")
        Return errorStream
    }
}

}
