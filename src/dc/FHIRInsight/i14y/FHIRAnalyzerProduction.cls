Class dc.FHIRInsight.i14y.FHIRAnalyzerProduction Extends Ens.Production
{

/// Controls which properties are visible in the production settings UI
Parameter SETTINGS = "LLMModel";

/// Default model to use if not specified in request
Property LLMModel As %String;

XData ProductionDefinition
{
<Production Name="dc.FHIRInsight.i14y.FHIRAnalyzerProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="LLMModel">@FHIR_INSIGHT_LLM_MODEL</Setting>
  <Item Name="RESTAPI" Category="" ClassName="dc.FHIRInsight.i14y.FHIRAnalysisService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>

  <Item Name="PdfIngest" Category="" ClassName="dc.FHIRInsight.i14y.Ingest.Service.PdfIngest" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="WebIngest" Category="" ClassName="dc.FHIRInsight.i14y.Ingest.Service.WebIngest" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>

  <Item Name="FHIRAnalysis" Category="" ClassName="dc.FHIRInsight.i14y.FHIRAnalysisProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="LLMService" Category="" ClassName="dc.FHIRInsight.i14y.LLM.Operation.LiteLLMBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="APIKeysConfig"></Setting>
    <Setting Target="Adapter" Name="Timeout">30</Setting>
  </Item>
  <Item Name="IngestPdf" Category="" ClassName="dc.FHIRInsight.i14y.Ingest.Operation.PdfBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="IngestWebURL" Category="" ClassName="dc.FHIRInsight.i14y.Ingest.Operation.WebBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
