Class dc.FHIRInsight.i14y.Ingest.Service.WebIngest Extends Ens.BusinessService
{

Parameter ADAPTER;

Method OnProcessInput(pRequest As dc.FHIRInsight.i14y.Ingest.Messages.WebRequest, Output pResponse As dc.FHIRInsight.i14y.Ingest.Messages.Response) As %Status
{
    Try {
        // Validate input
        If '$IsObject(pRequest) || (pRequest.urls = "") {
            Return $$$ERROR($$$GeneralError, "Invalid input request")
        }
        
        // Forward to Business Process
        Set sc = ..SendRequestSync("IngestWebURL", pRequest, .pResponse)
        
        If $$$ISERR(sc) || '$IsObject(pResponse) {
            Return $$$ERROR($$$GeneralError, "Business Process failed: "_$System.Status.GetErrorText(sc))
        }
        
        Return $$$OK
        
    } Catch ex {
        Return ex.AsStatus()
    }
}

}
