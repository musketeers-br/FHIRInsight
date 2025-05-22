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

ClassMethod RetrieveAnswer()
{
    S report = "*Patient:** Emily Johnson  **DOB:** 2005-08-20 (Age 18)  **Sex:** Female\n\n==================================================================\n1. SUMMARY OF KEY HEALTH INDICATORS\n==================================================================\n\n•  Fasting Glucose: 250 mg/dL (Reference Range: 70–99 mg/dL)  \n   – Interpretation: High (H)  \n•  Hemoglobin A₁c: 9.0 % (Reference Range: 4.0–5.6 %)  \n   – Interpretation: High (H)  \n\nNo other laboratory data were provided.  \n\n==================================================================\n2. DISEASE AND CONDITION IDENTIFICATION\n==================================================================\nBased on the elevated glucose and A₁c values:\n\n•  Diabetes Mellitus  \n   – Markedly elevated fasting plasma glucose (>126 mg/dL diagnostic of diabetes)  \n   – Hemoglobin A₁c of 9.0 % (well above the diabetic threshold of ≥6.5 %)  \n   – Age and acute hyperglycemia pattern suggest Type 1 Diabetes (consider autoimmune evaluation) but Type 2 Diabetes cannot be excluded without additional clinical history (BMI, family history, insulin resistance markers).  \n   \nInsufficient data to assess for:  \n•  Anemia (no CBC parameters provided)  \n•  Allergies (no IgE, eosinophils)  \n•  Infections (no WBC differential, cultures)  \n•  Liver Disease (no AST, ALT, bilirubin)  \n•  Kidney Disease (no creatinine, BUN, eGFR)  \n•  Thyroid Disorders (no TSH, T4)  \n•  Heart Disease (no lipid panel, cardiac enzymes)  \n•  Blood Clotting Disorders (no PT, aPTT)  \n•  Autoimmune Diseases (no ANA, rheumatoid factor)  \n•  Nutritional Deficiencies (no vitamin levels, minerals)  \n•  Cancer (no tumor markers)  \n•  HIV/AIDS (no HIV serology)  \n•  Hormonal Imbalances (no cortisol, sex hormones)  \n•  Bone Disorders (no calcium, vitamin D, alkaline phosphatase)  \n\n==================================================================\n3. HEALTH RECOMMENDATIONS\n==================================================================\n\nA. Diabetes Mellitus (Probable Type 1 vs. Type 2)  \n   1. Endocrinology Consultation  \n      – Urgent referral to a pediatric/adult endocrinologist for:  \n         •  Comprehensive diabetes classification (autoantibodies: GAD65, IA-2, ZnT8)  \n         •  Initiation of insulin therapy (basal-bolus regimen) or evaluation for insulin pump/CGM  \n         •  Education on self-monitoring of blood glucose (SMBG)  \n      – Source: American Diabetes Association Clinical Guidelines  \n        https://www.diabetes.org/diabetes  \n\n   2. Diabetes Education and Support  \n      – Diabetes Self-Management Education and Support (DSMES) program  \n      – Psychosocial assessment (adolescent coping, family support)  \n\n   3. Medication Management  \n      – Initiate basal insulin (e.g., glargine) plus rapid-acting insulin with meals  \n      – Titrate doses based on SMBG and carbohydrate intake  \n      – Consider adjunctive metformin if Type 2 features present  \n      – Source: ADA Standards of Medical Care in Diabetes—Pharmacologic Approaches  \n        https://professional.diabetes.org/content-page/practice-guidelines-resources  \n\n   4. Monitoring & Follow-Up  \n      – SMBG: Before meals and bedtime for first 2 weeks, then as directed  \n      – A₁c every 3 months until target achieved, then every 6 months  \n      – Annual screening:  \n         •  Diabetic retinopathy (ophthalmology exam)  \n         •  Nephropathy (urine albumin-to-creatinine ratio, eGFR)  \n         •  Neuropathy (foot exam)  \n      – Cardiovascular risk assessment (lipid profile, blood pressure monitoring)  \n\nB. Nutritional and Lifestyle Modification  \n   1. Medical Nutrition Therapy (MNT)  \n      – Referral to registered dietitian specializing in diabetes  \n      – Carbohydrate counting and meal planning  \n      – Balanced intake:  \n         •  Carbohydrates: 45–60 g per meal from whole grains, legumes, vegetables  \n         •  Protein: 15–20 % of total calories (lean poultry, fish, low-fat dairy)  \n         •  Fats: Emphasize monounsaturated/omega-3 fats (olive oil, nuts, fatty fish)  \n      – Limit simple sugars, sugar-sweetened beverages, processed snacks  \n\n   2. Physical Activity  \n      – At least 150 minutes/week of moderate-intensity aerobic exercise (e.g., brisk walking, cycling)  \n      – Incorporate resistance training 2–3 days/week (light weights, body‐weight exercises)  \n      – Monitor glucose pre‐ and post‐exercise to prevent hypo‐/hyperglycemia  \n\n   3. Behavioral Strategies  \n      – Goal setting: incremental reductions in A₁c by 1 % every 3 months  \n      – Use of mobile apps or glucose logs to track trends  \n      – Family involvement for adherence and support  \n\nC. Preventive Care Screenings  \n   – Annual influenza vaccination; administer pneumococcal vaccines per schedule  \n   – Dental exam every 6 months (periodontal disease risk)  \n   – Bone health: ensure adequate calcium (1,300 mg/day) and vitamin D (600–1,000 IU/day)  \n\n==================================================================\nReferences\n==================================================================\n1. American Diabetes Association. “Standards of Medical Care in Diabetes—2024.” https://professional.diabetes.org/content-page/practice-guidelines-resources  \n2. American Diabetes Association. “Diabetes Basics.” https://www.diabetes.org/diabetes  \n3. Mayo Clinic. “Type 1 Diabetes.” https://www.mayoclinic.org/diseases-conditions/type-1-diabetes  \n\n**Note:** This report is based solely on the provided glucose and A₁c values. Further laboratory data and clinical history are required for comprehensive assessment."
    Set result = ##class(dc.FHIRInsight.Retrieve).RetrieveAnswer(report)
    W result
}

ClassMethod Ingest()
{
    Set url = [
            "https://diabetesjournals.org/care/article/40/4/538/3687/REPLACE-BG-A-Randomized-Trial-Comparing-Continuous",
            "https://diabetesjournals.org/care/article/39/7/1143/37357/Multinational-Home-Use-of-Closed-Loop-Control-Is",
            "https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0248560",
            "https://www.nejm.org/doi/full/10.1056/NEJMoa1907863",
            "https://pubmed.ncbi.nlm.nih.gov/17889075/",
            "https://pubmed.ncbi.nlm.nih.gov/33584164/",
            "https://diabetesjournals.org/care/article/39/4/603/29115/Risk-Factors-Associated-With-Severe-Hypoglycemia",
            "https://www.bloodresearch.or.kr/journal/view.html?uid=2711&vmd=Full"
            ]

    Quit ##class(dc.FHIRInsight.Ingest).WebIngest(url.%ToJSON())
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
