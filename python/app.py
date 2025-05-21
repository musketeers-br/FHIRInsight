import requests
import json
import streamlit as st

ANALYZE_URL = f"http://iris:52773/FHIRInsight/analyze"

st.markdown('<a name="top"></a>', unsafe_allow_html=True)
st.title("FHIRInsight")

# File uploader widget
uploaded_file = st.file_uploader(
    label="Upload a FHIR JSON file",
    type=["json"],
    accept_multiple_files=False
)

# Only enable the Analyze button once a file is uploaded
if uploaded_file is not None:
    if st.button("Analyze"):
        try:
            # Read file contents
            file_bytes = uploaded_file.read()
            # Parse to Python object to ensure it's valid JSON
            payload = json.loads(file_bytes)
        except json.JSONDecodeError as e:
            st.error(f"Invalid JSON: {e}")
        # Send POST
        with st.spinner("Sending to analysis service..."):
            try:
                resp = requests.post(
                    ANALYZE_URL,
                    json=payload,
                    timeout=30,
                    auth=("_SYSTEM", "SYS")
                )
            except Exception as e:
                st.error(f"Error connecting to the service: {e}")
            else:
                # If the service returns JSON, assume it's an error message
                content_type = resp.headers.get("Content-Type", "")
                if "application/json" in content_type:
                    try:
                        err = resp.json()
                        st.error(f"Service returned an error:\n\n{json.dumps(err, indent=2)}")
                    except Exception:
                        st.error(f"Unexpected response:\n\n{resp.text}")
                else:
                    # Otherwise, assume the body is a Markdown report
                    report_md = resp.text
                    st.markdown(report_md, unsafe_allow_html=True)
                    st.markdown('<a href="#top">Upload another JSON file</a>', unsafe_allow_html=True)