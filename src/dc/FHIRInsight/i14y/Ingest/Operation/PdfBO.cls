Class dc.FHIRInsight.i14y.Ingest.PdfBO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// Main entry point for requests
Method ProcessRequest(pRequest As dc.FHIRInsight.i14y.Ingest.Messages.PdfRequest, Output pResponse As dc.FHIRInsight.i14y.Ingest.Messages.Response) As %Status
{
        Set tSC = $$$OK
        Try {
                Set pResponse =  ##class(dc.FHIRInsight.i14y.Ingest.Messages.Response).%New()
                Set response = {}.%FromJSON(##class(dc.FHIRInsight.Ingest).PdfIngest(pRequest.PdfBase64)) 
                If (response.%Get("error")'="") {
                        Return $$$ERROR($$$GeneralError, response.error)
                }
                Set pResponse.size = response.%Get("vector_size")
                Set pResponse.status = response.status
        } Catch e {
                Set tSC = e.AsStatus()
                Set pResponse.error = $System.Status.GetOneErrorText(tSC)
        }
        Return tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.FHIRInsight.i14y.Ingest.Messages.PdfRequest">
        <Method>ProcessRequest</Method>
    </MapItem>
</MapItems>
}

}
