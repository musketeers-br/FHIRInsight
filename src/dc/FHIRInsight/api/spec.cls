Class dc.FHIRInsight.api.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "title":"FHIR Bundle Analyzer",
    "description":"API that analyzes FHIR Bundle resources and returns Markdown reports",
    "version":"1.0.0"
  },
  "basePath":"/v1",
  "schemes":[
    "https"
  ],
  "consumes":[
    "application/json"
  ],
  "produces":[
    "text/markdown"
  ],
  "securityDefinitions":{
    "basicAuth":{
      "type":"basic",
      "description":"HTTP Basic Authentication"
    }
  },
  "security":[
    {
      "basicAuth":[
      ]
    }
  ],
  "paths":{
    "/analyze":{
      "post":{
        "summary":"Analyze FHIR Bundle",
        "description":"Accepts a FHIR Bundle resource and returns a Markdown analysis report of its contents",
        "parameters":[
          {
            "name":"fhirBundle",
            "in":"body",
            "description":"FHIR Bundle resource to be analyzed (any valid JSON object)",
            "required":true,
            "schema":{
              "type":"object"
            }
          }
        ],
        "responses":{
          "200":{
            "description":"Successful analysis",
            "schema":{
              "type":"string",
              "example":"# FHIR Bundle Analysis Report\n\n## Summary\n- Total resources: 5\n- Resource types: Patient, Observation, Condition\n..."
            }
          },
          "400":{
            "description":"Invalid input (non-JSON or malformed request)"
          },
          "401":{
            "description":"Unauthorized - Invalid credentials"
          },
          "500":{
            "description":"Internal server error during analysis"
          }
        }
      }
    }
  }
}
}

}
