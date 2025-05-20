Class tests.dc.FHIRInsight.unittests.LiteLLMMock Extends %RegisteredObject
{

Method completion(model, messages) [ Language = python ]
{
    import litellm

    response_dict = {
        "choices": [
            {
                "finish_reason": "stop",
                "index": 0,
                "message": {
                    "content": "Detailed Medical Analysis and Health Recommendation Report  \nPatient: John DUMMY (Male, born 1993-05-14)  \nReport Date: 2023-05-14  \n\n1. Summary of Key Health Indicators  \n-----------------------------------  \n• Hemoglobin  \n  – Value: 15.0 g/dL  \n  – Reference range: 13.0–17.0 g/dL  \n  – Interpretation: Within normal limits; no evidence of anemia.  \n• Red Blood Cell (RBC) Count  \n  – Value: 4.50 ×10⁶/µL  \n  – Reference range: 4.50–5.50 ×10⁶/µL  \n  – Interpretation: At the lower end of normal; overall adequate erythropoiesis.  \n\nNote: No data available in this panel for:  \n  – Fasting Glucose (normal: 70–99 mg/dL)  \n  – Hemoglobin A1c (normal: <5.7%)  \n  – Lipid profile, liver enzymes, renal function, thyroid‐stimulating hormone, inflammatory markers, or vitamin/mineral assays.  \n\n2. Disease and Condition Identification  \n---------------------------------------  \nBased on the provided hemoglobin and RBC results, and acknowledging the absence of other laboratory data, the following assessments apply:  \n\n• Anemia  \n  – Hemoglobin and RBC count are within normal ranges.  \n  – No laboratory evidence of anemia (iron-deficiency, hemolytic, or chronic disease) at this time.  \n\n• Other Conditions (insufficient data for definitive assessment):  \n  – Allergies, Infections (CBC differential, CRP, ESR absent)  \n  – Diabetes (no glucose or A1c values)  \n  – Liver Disease (LFTs absent)  \n  – Kidney Disease (creatinine, eGFR absent)  \n  – Thyroid Disorders (TSH, free T4 absent)  \n  – Heart Disease (lipids, cardiac enzymes absent)  \n  – Blood Clotting Disorders (PT/INR, aPTT absent)  \n  – Autoimmune Diseases (ANA, RF absent)  \n  – Nutritional Deficiencies (iron studies, B12, folate absent)  \n  – Cancer (tumor markers absent)  \n  – HIV/AIDS (HIV serology absent)  \n  – Hormonal Imbalances (testosterone, cortisol absent)  \n  – Bone Disorders (calcium, vitamin D, alkaline phosphatase absent)  \n\n3. Health Recommendations  \n-------------------------  \nA. General Preventive Care  \n• Primary Care Consultation  \n  – Schedule an annual wellness visit with a PCP or family physician.  \n  – Review personal & family history, physical exam, and age-appropriate screening schedule.  \n• Laboratory Follow-Up  \n  – Complete Blood Count with differential (for WBC, platelets).  \n  – Fasting glucose and HbA1c (to screen for prediabetes/diabetes).  \n  – Lipid panel (total cholesterol, LDL, HDL, triglycerides).  \n  – Comprehensive Metabolic Panel (liver enzymes, renal function, electrolytes).  \n  – Thyroid Stimulating Hormone (TSH) with Free T4.  \n  – Iron studies (serum iron, ferritin, TIBC), vitamin B12, folate for nutritional status.  \n  – Vitamin D (25-hydroxyvitamin D) if risk factors for deficiency.  \n  – PSA for prostate health if age ≥50 or earlier with risk factors.  \n  – Colon cancer screening per guidelines (age ≥45).  \n\nB. Lifestyle and Nutrition  \n• Diet  \n  – Emphasize a Mediterranean-style diet:  \n    • Vegetables, fruits, whole grains, legumes, nuts, and seeds daily.  \n    • Lean protein sources: fish (e.g., salmon, mackerel twice weekly), poultry, beans.  \n    • Healthy fats: extra-virgin olive oil, avocado; limit saturated and trans fats.  \n    • Low-fat dairy or fortified plant alternatives.  \n    • Sodium <2,300 mg/day; added sugars <10% of total calories.  \n  – Hydration: 8–10 cups (2–2.5 L) of water daily, adjust for activity level.  \n  Source: American Heart Association – \"Healthy Eating\"  \n  (https://www.heart.org/en/healthy-living/healthy-eating)  \n\n• Physical Activity  \n  – ≥150 minutes/week of moderate-intensity aerobic activity (e.g., brisk walking, cycling).  \n  – Resistance training ≥2 days/week targeting major muscle groups.  \n  Source: U.S. Department of Health and Human Services – Physical Activity Guidelines  \n  (https://health.gov/sites/default/files/2019-09/Physical_Activity_Guidelines_2nd_edition.pdf)  \n\n• Weight Management  \n  – Aim for BMI within 18.5–24.9 kg/m²; if overweight, target 5–10% weight reduction over 6 months.  \n\n• Tobacco and Alcohol  \n  – Avoid tobacco in any form.  \n  – Limit alcohol to ≤2 standard drinks/day for men.  \n\nC. Condition-Specific Follow-Up  \nSince no current abnormalities were identified, focus remains on preventive screening and risk factor modification. Should follow-up labs reveal specific derangements, tailored interventions will be initiated.  \n\n4. References  \n------------  \n1. Complete Blood Count (CBC) Interpretation – Mayo Clinic  \n   https://www.mayoclinic.org/tests-procedures/complete-blood-count/about/pac-20384919  \n2. Prediabetes & Diabetes Screening Guidelines – American Diabetes Association  \n   https://diabetes.org/a1c  \n3. Healthy Eating – American Heart Association  \n   https://www.heart.org/en/healthy-living/healthy-eating  \n4. Physical Activity Guidelines for Americans (2nd edition) – HHS  \n   https://health.gov/sites/default/files/2019-09/Physical_Activity_Guidelines_2nd_edition.pdf  \n\nEnd of Report", 
                    "role": "assistant",
                    "tool_calls": None, 
                    "function_call": None 
                }
            }
        ],
        "usage": {
            "completion_tokens": 1978,
            "prompt_tokens": 872,
            "total_tokens": 2850
        },
        "model": "o4-mini-2025-04-16"
    }
    mock_response = litellm.ModelResponse(**response_dict)
    return mock_response
}

}