package ballerina.pmml.testPMML;

import ballerina.test;
import ballerina.pmml;
import ballerina.file;
import ballerina.io;

function testIsValid () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/LinearRegression.pmml");
    var isValid, _ = pmml:isValid(pmml);
    println(isValid);
    test:assertTrue(isValid, "LinearRegression.pmml is not valid");
}

function testIsPredictable () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/LinearRegression.pmml");
    var isPreditable, _ = pmml:isPredictable(pmml);
    println(isPreditable);
    test:assertTrue(isPreditable, "LinearRegression.pmml is not predictable");
}

function testIsDataElementValid () {
    xml data = xml `<data>
                        <e1></e1>
                        <e2></e2>
                    </data>`;
    var isDataElementValid, _ = pmml:isDataElementValid(data);
    println(isDataElementValid);
    test:assertTrue(isDataElementValid, "valid data element asserted false");
}

function testLinearRegression () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/LinearRegression.pmml");
    xml data = xml `<data>
                        <age>19</age>
                        <salary>20000</salary>
                        <car_location>carpark</car_location>
                    </data>`;
    var result, resultConversionError = (int)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    int expected = 508;
    println(result);
    test:assertIntEquals(result, expected, "LinearRegression.pmml failed to execute");
}

function testPolynomialRegression () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/PolynomialRegression.pmml");
    xml data = xml `<data>
                        <salary>20000</salary>
                        <car_location>carpark</car_location>
                    </data>`;
    var result, resultConversionError = (int)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    int expected = 2070;
    println(result);
    test:assertIntEquals(result, expected, "PolynomialRegression.pmml failed to execute");
}

function testLogisticRegression () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/LogisticRegression.pmml");
    xml data = xml `<data>
                        <x1>2.7</x1>
                        <x2>2.2</x2>
                    </data>`;
    var result, resultConversionError = (float)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    float expected = 0.03715760747297868;
    println(result);
    test:assertFloatEquals(result, expected, "LogisticRegression.pmml failed to execute");
}

function testClassification () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/Classification.pmml");
    xml data = xml `<data>
                        <age>19</age>
                        <work>8</work>
                        <sex>0</sex>
                        <minority>1</minority>
                    </data>`;
    var result, resultConversionError = (string)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    string expected = "professional";
    println(result);
    test:assertStringEquals(result, expected, "Classification.pmml failed to execute");
}

function testInteractionTerms () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/testPMML/InteractionTerms.pmml");
    xml data = xml `<data>
                        <sex>male</sex>
                        <age>19</age>
                        <work>8</work>
                    </data>`;
    var result, resultConversionError = (float)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    float expected = -33.625;
    println(result);
    test:assertFloatEquals(result, expected, "InteractionTerms.pmml failed to execute");
}
