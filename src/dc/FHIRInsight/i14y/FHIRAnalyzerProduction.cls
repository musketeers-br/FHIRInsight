Class dc.FHIRInsight.i14y.FHIRAnalyzerProduction Extends Ens.Production
{

/// Controls which properties are visible in the production settings UI
Parameter SETTINGS = "LLMModel";

/// Default model to use if not specified in request
Property LLMModel As %String [ InitialExpression = "" ];

XData ProductionDefinition
{
<Production Name="dc.FHIRInsight.i14y.FHIRAnalyzerProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="LLMModel">@FHIR_INSIGHT_LLM_MODEL</Setting>
  <Item Name="LLMService" Category="" ClassName="dc.FHIRInsight.i14y.LLM.Operation.LiteLLMBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="APIKeysConfig"></Setting>
    <Setting Target="Adapter" Name="Timeout">30</Setting>
  </Item>
  <Item Name="RESTAPI" Category="" ClassName="dc.FHIRInsight.i14y.FHIRAnalysisService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
