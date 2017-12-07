package ballerina.pmml.testPMML;

import ballerina.pmml;
import ballerina.file;
import ballerina.io;

public function runAllTests() {
    // Runs all the test functions.
    testLinearRegression();
    testPolynomialRegression();
    testLogisticRegression();
    testClassification();
    testInteractionTerms();
    testErrorHandling();
}

public function testLinearRegression() {
    file:File file = {path:"ballerina/pmml/testPMML/LinearRegression.pmml"};
    io:ByteChannel byteChannel = file.openChannel("r");
    blob bytes;
    int numberOfBytes;
    bytes, numberOfBytes = byteChannel.readBytes(1000000);
    string s = bytes.toString("UTF-8");
    var pmml, typeConversionError = <xml> s;
    if (typeConversionError != null) {
        throw typeConversionError;
    }
    xml data = xml `<data>
                        <age>20</age>
                        <salary>10000</salary>
                        <car_location>carpark</car_location>
                    </data>`;
    any result = pmml:predict(pmml, data);
    any expected = 415;
}

public function testPolynomialRegression() {

}

public function testLogisticRegression() {

}

public function testClassification() {

}

public function testInteractionTerms() {

}

public function testErrorHandling() {

}
