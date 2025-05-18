Class dc.FHIRInsight.i14y.FHIRAnalysisResponse Extends Ens.Response
{

/// Holds the Markdown-formatted analysis result
Property AnalysisResult As %String(MAXLEN = "");

Storage Default
{
<Data name="FHIRAnalysisResponseDefaultData">
<Subscript>"FHIRAnalysisResponse"</Subscript>
<Value name="1">
<Value>AnalysisResult</Value>
</Value>
</Data>
<DefaultData>FHIRAnalysisResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
