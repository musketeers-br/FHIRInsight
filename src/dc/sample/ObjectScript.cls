Class dc.sample.ObjectScript
{

ClassMethod Test() As %Status
{
    set sc = $$$OK
    Try {
        set sc = ..Run() ; Python
        set sc = ..Run(0) ; ObjectScript
    }
    Catch ex {
        set sc=ex.AsStatus()
    }
    return sc
}

ClassMethod Run(python As %Boolean = 1) As %Status
{
    return:python ..Python()
    return:'python ..ObjectScript()
}

ClassMethod ObjectScript() As %Status
{
    set a=42 
    write "Hello World! from ",$CLASSMETHOD("dc.sample.ObjectScript","%ClassName",1)," in ObjectScript language",!
    write "This is InterSystems IRIS with version ",$zv,!
    write "Current time is: "_$zdt($now(),3,,6),!
    return a
}

ClassMethod Python() As %Status [ Language = python ]
{
import iris    
from datetime import datetime
a=42 
print("Hello World! from",iris.cls('dc.sample.ObjectScript')._ClassName(1),"in Python language")
print("This is InterSystems IRIS with version",iris.system.Version.GetVersion())
print("Current time is:",datetime.now())
return a
}

ClassMethod Diabetes() As %Status
{
    Set sc = $$$OK
    Set fhir = {
    "resourceType": "Bundle",
    "type": "collection",
    "entry": [
        {
        "resource": {
            "resourceType": "Patient",
            "id": "diabetes-example",
            "name": [
            {
                "use": "official",
                "family": "Doe",
                "given": ["Jane"]
            }
            ],
            "gender": "female",
            "birthDate": "1975-08-15"
        }
        },
        {
        "resource": {
            "resourceType": "Observation",
            "id": "fasting-glucose",
            "status": "final",
            "category": [
            {
                "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                    "code": "laboratory",
                    "display": "Laboratory"
                }
                ]
            }
            ],
            "code": {
            "coding": [
                {
                "system": "http://loinc.org",
                "code": "1558-6",
                "display": "Glucose [Mass/volume] in Blood"
                }
            ]
            },
            "subject": {
            "reference": "Patient/diabetes-example"
            },
            "effectiveDateTime": "2023-10-01T08:00:00+00:00",
            "valueQuantity": {
            "value": 130,
            "unit": "mg/dL",
            "system": "http://unitsofmeasure.org",
            "code": "mg/dL"
            },
            "referenceRange": [
            {
                "low": {
                "value": 70,
                "unit": "mg/dL",
                "system": "http://unitsofmeasure.org",
                "code": "mg/dL"
                },
                "high": {
                "value": 99,
                "unit": "mg/dL",
                "system": "http://unitsofmeasure.org",
                "code": "mg/dL"
                }
            }
            ]
        }
        },
        {
        "resource": {
            "resourceType": "Observation",
            "id": "hba1c",
            "status": "final",
            "category": [
            {
                "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                    "code": "laboratory",
                    "display": "Laboratory"
                }
                ]
            }
            ],
            "code": {
            "coding": [
                {
                "system": "http://loinc.org",
                "code": "4548-4",
                "display": "Hemoglobin A1c/Hemoglobin.total in Blood"
                }
            ]
            },
            "subject": {
            "reference": "Patient/diabetes-example"
            },
            "effectiveDateTime": "2023-10-01T08:00:00+00:00",
            "valueQuantity": {
            "value": 7.5,
            "unit": "%",
            "system": "http://unitsofmeasure.org",
            "code": "%"
            },
            "referenceRange": [
            {
                "low": {
                "value": 4.0,
                "unit": "%",
                "system": "http://unitsofmeasure.org",
                "code": "%"
                },
                "high": {
                "value": 5.6,
                "unit": "%",
                "system": "http://unitsofmeasure.org",
                "code": "%"
                }
            }
            ]
        }
        }
    ]
    }
    Set output = ##class(dc.FHIRInsight.Core).Execute(fhir.%ToJSON())
    W output
    Return sc
}

}
