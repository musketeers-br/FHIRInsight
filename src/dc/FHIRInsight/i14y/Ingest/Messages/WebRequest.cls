Class dc.FHIRInsight.i14y.Ingest.Messages.WebRequest Extends (Ens.Request, %JSON.Adaptor)
{

Property urls As %String(%JSONFIELDNAME = "urls", MAXLEN = "");

Storage Default
{
<Data name="WebRequestDefaultData">
<Subscript>"WebRequest"</Subscript>
<Value name="1">
<Value>urls</Value>
</Value>
</Data>
<DefaultData>WebRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
