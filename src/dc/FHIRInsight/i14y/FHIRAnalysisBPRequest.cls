Class dc.FHIRInsight.i14y.FHIRAnalysisBPRequest Extends Ens.Request
{

/// The FHIR Bundle JSON string
Property FHIRBundle As %String(MAXLEN = "");

/// The LLM model to use
Property Model As %String(MAXLEN = 100);

Storage Default
{
<Data name="FHIRAnalysisBPRequestDefaultData">
<Subscript>"FHIRAnalysisBPRequest"</Subscript>
<Value name="1">
<Value>FHIRBundle</Value>
</Value>
<Value name="2">
<Value>Model</Value>
</Value>
</Data>
<DefaultData>FHIRAnalysisBPRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
