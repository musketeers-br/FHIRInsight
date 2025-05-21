Class dc.FHIRInsight.i14y.FHIRAnalysisBPResponse Extends Ens.Response
{

/// The analysis result from LLM
Property AnalysisResult As %String(MAXLEN = "");

Storage Default
{
<Data name="FHIRAnalysisBPResponseDefaultData">
<Subscript>"FHIRAnalysisBPResponse"</Subscript>
<Value name="1">
<Value>AnalysisResult</Value>
</Value>
</Data>
<DefaultData>FHIRAnalysisBPResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
