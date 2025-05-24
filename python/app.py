
import requests
import json
import streamlit as st

ANALYZE_URL = f"http://iris:52773/FHIRInsight/analyze"
INGEST_URL = f"http://iris:52773/FHIRInsight/ingest"  # Adjust this URL as needed

# Initialize session state for modal
if 'show_ingest_modal' not in st.session_state:
    st.session_state.show_ingest_modal = False
if 'ingest_mode' not in st.session_state:
    st.session_state.ingest_mode = None

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

# Modal for ingestion
if st.session_state.show_ingest_modal:
    @st.dialog("Vector Database Ingestion")
    def ingest_modal():
        st.write("Choose how you want to ingest data into the vector database:")
        
        col1, col2 = st.columns(2)
        
        with col1:
            if st.button("📄 Upload PDF", use_container_width=True):
                st.session_state.ingest_mode = "pdf"
                st.rerun()
        
        with col2:
            if st.button("🔗 Enter URLs", use_container_width=True):
                st.session_state.ingest_mode = "urls"
                st.rerun()
        
        if st.session_state.ingest_mode == "pdf":
            st.divider()
            st.subheader("Upload PDF Document")
            pdf_file = st.file_uploader("Choose a PDF file", type="pdf", key="pdf_uploader")
            
            if pdf_file is not None:
                if st.button("Ingest PDF", type="primary"):
                    with st.spinner("Ingesting PDF..."):
                        try:
                            files = {"file": (pdf_file.name, pdf_file.read(), "application/pdf")}
                            resp = requests.post(
                                INGEST_URL,
                                files=files,
                                auth=("_SYSTEM", "SYS")
                            )
                            if resp.status_code == 200:
                                st.success("PDF ingested successfully!")
                                st.session_state.show_ingest_modal = False
                                st.session_state.ingest_mode = None
                                st.rerun()
                            else:
                                st.error(f"Failed to ingest PDF: {resp.text}")
                        except Exception as e:
                            st.error(f"Error: {e}")
        
        elif st.session_state.ingest_mode == "urls":
            st.divider()
            st.subheader("Enter URLs")
            urls_text = st.text_area(
                "Enter URLs (one per line):",
                height=150,
                placeholder="https://example.com/page1\nhttps://example.com/page2"
            )
            
            if st.button("Ingest URLs", type="primary"):
                if urls_text.strip():
                    urls = [url.strip() for url in urls_text.strip().split('\n') if url.strip()]
                    with st.spinner("Ingesting URLs..."):
                        try:
                            resp = requests.post(
                                INGEST_URL,
                                json={"urls": urls},
                                auth=("_SYSTEM", "SYS")
                            )
                            if resp.status_code == 200:
                                st.success(f"Successfully ingested {len(urls)} URLs!")
                                st.session_state.show_ingest_modal = False
                                st.session_state.ingest_mode = None
                                st.rerun()
                            else:
                                st.error(f"Failed to ingest URLs: {resp.text}")
                        except Exception as e:
                            st.error(f"Error: {e}")
                else:
                    st.warning("Please enter at least one URL")
        
        if st.button("Cancel"):
            st.session_state.show_ingest_modal = False
            st.session_state.ingest_mode = None
            st.rerun()
    
    ingest_modal()

# Add spacer to push engine icon to bottom
st.markdown("<br><br><br>", unsafe_allow_html=True)

# Engine icon at the bottom
col1, col2, col3 = st.columns([5, 1, 5])
with col1:
    if st.button("⚙️", key="engine_button", help="Upload PDFs or URLs with medical research to improve analysis insights."):
        st.session_state.show_ingest_modal = True
        st.rerun()

# Style the engine button to be at the bottom
st.markdown("""
<style>
    [data-testid="stButton"] button[kind="secondary"] {
        font-size: 2rem;
        width: 110px;
        height: 60px;
        margin: 20px auto;
    }
</style>
""", unsafe_allow_html=True)