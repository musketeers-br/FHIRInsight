/// API that analyzes FHIR Bundle resources and returns Markdown reports<br/>
/// Business logic class defined by OpenAPI in dc.FHIRInsight.api.spec<br/>
/// Updated May 24, 2025 18:00:55
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

/// Receive a base64-encoded PDF containing medical research to improve future analysis insights.<br/>
/// The method arguments hold values for:<br/>
///     body, Payload containing the PDF file as a Base64 string<br/>
ClassMethod %RouteCB2(body As %DynamicObject) As %Stream.Object
{
    Set tSC = $$$OK
	Try {
        Set base64 = body.base64
        If base64 = "" {
            Do ..%SetStatusCode(400)
            Throw ##class(%Exception.General).%New("Invalid input","400",,"Failed to convert FHIR Bundle to JSON")
        }
        Set request = ##class(dc.FHIRInsight.i14y.Ingest.Messages.PdfRequest).%New()
        Set request.base64 = base64.%ToJSON()

        // Get Business Service instance
        Set sc = ##class(Ens.Director).CreateBusinessService("PdfIngest", .businessService)
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
        Do stream.Write(response)
        Return stream
    } Catch ex {
        // Handle errors
        Set errorStream = ##class(%Stream.GlobalCharacter).%New()
        Do errorStream.Write("{""error"":"""_ex.DisplayString()_"""}")
        Return errorStream
    }
}

/// Receive an array of URLs pointing to medical research documents to improve future analysis insights.<br/>
/// The method arguments hold values for:<br/>
///     body, Payload containing an array of URLs<br/>
ClassMethod %RouteCB3(body As %DynamicObject) As %Stream.Object
{
    Set tSC = $$$OK
	Try {
        Set urls = body.%Get("urls")
        If urls = "" {
            Do ..%SetStatusCode(400)
            Throw ##class(%Exception.General).%New("Invalid input","400",,"Failed to convert FHIR Bundle to JSON")
        }
        Set request = ##class(dc.FHIRInsight.i14y.Ingest.Messages.WebRequest).%New()
        Set request.urls = urls.%ToJSON()

        // Get Business Service instance
        Set sc = ##class(Ens.Director).CreateBusinessService("WebIngest", .businessService)
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
        Do stream.Write(response)
        Return stream
    } Catch ex {
        // Handle errors
        Set errorStream = ##class(%Stream.GlobalCharacter).%New()
        Do errorStream.Write("{""error"":"""_ex.DisplayString()_"""}")
        Return errorStream
    }
}

}
