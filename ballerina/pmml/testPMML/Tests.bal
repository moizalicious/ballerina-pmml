package ballerina.pmml.testPMML;

import ballerina.test;
import ballerina.pmml;
import ballerina.file;
import ballerina.io;

function testLinearRegression() {
    xml pmml = readXMLFromFile("LinearRegression.pmml");
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
    test:assertIntEquals(result, expected, "LinearRegression.pmml failed to execute");
}

function testPolynomialRegression() {
    xml pmml = readXMLFromFile("PolynomialRegression.pmml");
    xml data = xml `<data>
                        <salary>20000</salary>
                        <car_location>carpark</car_location>
                    </data>`;
    var result, resultConversionError = (int)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    int expected = 2070;
    test:assertIntEquals(result, expected, "PolynomialRegression.pmml failed to execute");
}

function testLogisticRegression() {
    xml pmml = readXMLFromFile("LogisticRegression.pmml");
    xml data = xml `<data>
                        <x1>2.7</x1>
                        <x2>2.2</x2>
                    </data>`;
    var result, resultConversionError = (float)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    float expected = 0.03715760747297868;
    test:assertFloatEquals(result, expected, "LogisticRegression.pmml failed to execute");
}

function testClassification() {
    xml pmml = readXMLFromFile("Classification.pmml");
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
    test:assertStringEquals(result, expected, "Classification.pmml failed to execute");
}

function testInteractionTerms() {
    xml pmml = readXMLFromFile("InteractionTerms.pmml");
    xml data = xml `<data>
                        <sex>male</sex>
                        <age>19</age>
                        <work>8.5</work>
                    </data>`;
    var result, resultConversionError = (float)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    float expected = -34.575;
    test:assertFloatEquals(result, expected, "InteractionTerms.pmml failed to execute");
}

function generateError(string msg) (error) {
    error err = {msg:msg};
    return err;
}

function readXMLFromFile (string fileName) (xml) {
    file:File file = {path:"ballerina/pmml/testPMML/" + fileName};
    io:ByteChannel byteChannel = file.openChannel("r");
    blob bytes;
    int numberOfBytes;
    bytes, numberOfBytes = byteChannel.readBytes(1000000);
    string s = bytes.toString("UTF-8");
    var x, typeConversionError = <xml> s.trim();
    if (typeConversionError != null) {
        throw typeConversionError;
    }
    return x;
}
