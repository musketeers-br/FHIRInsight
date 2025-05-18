Class dc.FHIRInsight.i14y.FHIRAnalyzerProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="myapp.FHIRAnalyzer" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="LLMService" Category="" ClassName="dc.FHIRInsight.i14y.LLM.Operation.LiteLLMBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="APIKeysConfig"></Setting>
    <Setting Target="Adapter" Name="Timeout">30</Setting>
  </Item>
  <Item Name="RESTAPI" Category="" ClassName="dc.FHIRInsight.i14y.FHIRAnalysisService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
