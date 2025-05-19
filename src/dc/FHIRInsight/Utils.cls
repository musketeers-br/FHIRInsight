Class dc.FHIRInsight.Utils Extends %RegisteredObject
{

/// Check if Langchain-openai is installed
ClassMethod CheckOpenAi() [ Language = python ]
{
    import iris
    try:
        from langchain_openai import AzureChatOpenAI,ChatOpenAI
    except ImportError:
        iris.cls(__name__).PipInstall("langchain-openai")
}

ClassMethod CheckOllama() [ Language = python ]
{
    import iris
    try:
        from langchain_ollama.llms import OllamaLLM
    except ImportError:
        iris.cls(__name__).PipInstall("langchain-ollama")
}

ClassMethod CheckAnthropic() [ Language = python ]
{
    import iris
    try:
        from langchain_anthropic import ChatAnthropic
    except ImportError:
        iris.cls(__name__).PipInstall("langchain-anthropic")
}

ClassMethod CheckGoogleAI() [ Language = python ]
{
    import iris
    try:
        from langchain_google_genai import GoogleGenerativeAI
    except ImportError:
        iris.cls(__name__).PipInstall("langchain-google-genai")
}

/// Install a custom lib
ClassMethod PipInstall(pLib As %String) [ Language = python ]
{
    try:
        import subprocess
        import sys
        
        subprocess.check_call([sys.executable, "-m", "pip", "install", pLib])
        print(f"Successfully installed {pLib}!")
    except Exception as e:
        print(f"Failed to install {pLib}: {str(e)}")
        print(f"Please install it manually using: pip install {pLib}")
}

ClassMethod StartProduction()
{
    Set pProductionName = "dc.FHIRInsight.i14y.FHIRAnalyzerProduction"
    Set attempt = 0
    Set maxAttempts = 10
    While (attempt < maxAttempts) && '##class(Ens.Director).IsProductionRunning(pProductionName) {
        Hang 1
        Do ##class(Ens.Director).SetAutoStart(pProductionName)
            Do ##class(Ens.Director).StartProduction(pProductionName)
            Set attempt = attempt + 1
    }
    If '##class(Ens.Director).IsProductionRunning(pProductionName) {
        Write "Produciton "_pProductionName_" couldn't be started. Please start it manually."
    }
}

}
