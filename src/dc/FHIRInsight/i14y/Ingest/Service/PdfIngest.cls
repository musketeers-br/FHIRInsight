Class dc.FHIRInsight.i14y.Ingest.Service.PdfIngest Extends Ens.BusinessService
{

Parameter ADAPTER;

Method OnProcessInput(pRequest As dc.FHIRInsight.i14y.Ingest.Messages.PdfRequest, Output pResponse As dc.FHIRInsight.i14y.Ingest.Messages.Response) As %Status
{
    Try {
        // Validate input
        If '$IsObject(pRequest) || (pRequest.base64 = "") {
            Return $$$ERROR($$$GeneralError, "Invalid input request")
        }
        
        // Forward to Business Process
        Set sc = ..SendRequestSync("IngestPdf", pRequest, .pResponse)
        
        If $$$ISERR(sc) || '$IsObject(pResponse) {
            Return $$$ERROR($$$GeneralError, "Business Process failed: "_$System.Status.GetErrorText(sc))
        }
        
        Return $$$OK
        
    } Catch ex {
        Return ex.AsStatus()
    }
}

}
