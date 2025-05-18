Class dc.FHIRInsight.i14y.FHIRBundleRequest Extends Ens.Request
{

/// Holds the JSON string of the FHIR Bundle
Property FHIRBundle As %String(MAXLEN = "");

Storage Default
{
<Data name="FHIRBundleRequestDefaultData">
<Subscript>"FHIRBundleRequest"</Subscript>
<Value name="1">
<Value>FHIRBundle</Value>
</Value>
</Data>
<DefaultData>FHIRBundleRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
