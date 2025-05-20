Class tests.dc.FHIRInsight.unittests.i14y.UtilsTest Extends %UnitTest.TestCase
{

Method TestResolveModelValueDirectInput()
{
    Set input = "directValue"
    Set expected = "directValue"
    Set actual = ##class(dc.FHIRInsight.i14y.Utils).ResolveModelValue(input)
    Do $$$AssertEquals(expected, actual, "Direct input should return unchanged")
}

Method TestResolveModelValueEnvVar()
{
    Set os = ##class(%SYS.Python).Import("os")
    
    // Set up a test environment variable
    Set envVarName = "TEST_FHIRINSIGHT_VAR"
    Set envVarValue = "testValue123"
    #; Do ##class(%SYSTEM.Util).SetEnviron(envVarName, envVarValue)
    Do os.environ."__setitem__"(envVarName, envVarValue)
    
    // Test with environment variable reference
    Set input = "@"_envVarName
    Set expected = envVarValue
    Set actual = ##class(dc.FHIRInsight.i14y.Utils).ResolveModelValue(input)
    Do $$$AssertEquals(expected, actual, "Should resolve environment variable")
    
    // Clean up
    #; Do ##class(%SYSTEM.Util).SetEnviron(envVarName, "")
    Do os.environ."__setitem__"(envVarName, "")
}

Method TestResolveModelValueNonExistentEnvVar()
{
    // Use a non-existent environment variable
    Set input = "@NON_EXISTENT_VAR_123"
    Set expected = ""
    Set actual = ##class(dc.FHIRInsight.i14y.Utils).ResolveModelValue(input)
    Do $$$AssertEquals(expected, actual, "Non-existent env var should return empty string")
}

Method TestResolveModelValueEmptyInput()
{
    Set input = ""
    Set expected = ""
    Set actual = ##class(dc.FHIRInsight.i14y.Utils).ResolveModelValue(input)
    Do $$$AssertEquals(expected, actual, "Empty input should return empty string")
}

Method TestResolveModelValueOnlyAtSign()
{
    Set input = "@"
    
    // We expect an exception to be thrown
    Set exceptionThrown = 0
    Try {
        Do ##class(dc.FHIRInsight.i14y.Utils).ResolveModelValue(input)
    } Catch ex {
        Set exceptionThrown = 1
        Do $$$AssertEquals(ex.Name, "Invalid environment variable ID", "Should throw correct exception type")
    }
    Do $$$AssertTrue(exceptionThrown, "Input with only @ should throw exception")
}

}