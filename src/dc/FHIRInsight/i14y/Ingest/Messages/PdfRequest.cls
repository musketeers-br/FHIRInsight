Class dc.FHIRInsight.i14y.Ingest.Messages.PdfRequest Extends (Ens.Request, %JSON.Adaptor)
{

Property base64 As %String(%JSONFIELDNAME = "pdf_base64", MAXLEN = "");

Storage Default
{
<Data name="PdfRequestDefaultData">
<Subscript>"PdfRequest"</Subscript>
<Value name="1">
<Value>base64</Value>
</Value>
</Data>
<DefaultData>PdfRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
