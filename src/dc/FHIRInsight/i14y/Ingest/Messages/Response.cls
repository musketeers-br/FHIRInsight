Class dc.FHIRInsight.i14y.Ingest.Messages.Response Extends (Ens.Response, %JSON.Adaptor)
{

Property status As %String(%JSONFIELDNAME = "status", MAXLEN = "");

Property size As %String(%JSONFIELDNAME = "vector_size", MAXLEN = "");

Property error As %String(%JSONFIELDNAME = "error", MAXLEN = "");

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>status</Value>
</Value>
<Value name="2">
<Value>size</Value>
</Value>
<Value name="3">
<Value>error</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
