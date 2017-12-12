package ballerina.pmml.test;

import ballerina.test;
import ballerina.pmml;

function testIsValid () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/LinearRegression.pmml");
    var isValid, invalidPMMLError = pmml:isValid(pmml);
    println(isValid);
    if (invalidPMMLError != null) {
        throw invalidPMMLError;
    }
    test:assertTrue(isValid, "'LinearRegression.pmml' is not valid: ");
}

function testIsPredictable () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/LinearRegression.pmml");
    var isPredictable, unpredictablePMMLError = pmml:isPredictable(pmml);
    println(isPredictable);
    if (unpredictablePMMLError != null) {
        throw unpredictablePMMLError;
    }
    test:assertTrue(isPredictable, "'LinearRegression.pmml' is not predictable: ");
}

function testIsDataElementValid () {
    xml data = xml `<data>
                        <e1></e1>
                        <e2></e2>
                    </data>`;
    var isDataElementValid, invalidDataElementError = pmml:isDataElementValid(data);
    println(isDataElementValid);
    if (invalidDataElementError != null) {
        throw invalidDataElementError;
    }
    test:assertTrue(isDataElementValid, "valid data element asserted false: ");
}

function testGetModelType() {
    // TODO complete
}

function testGetVersion() {
    // TODO complete
}

function testReadXMLFromFile() {
    // TODO complete
}

function testLinearRegression () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/LinearRegression.pmml");
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
    test:assertIntEquals(result, expected, "'LinearRegression.pmml' failed to execute: ");
}

function testPolynomialRegression () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/PolynomialRegression.pmml");
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
    test:assertIntEquals(result, expected, "'PolynomialRegression.pmml' failed to execute: ");
}

function testLogisticRegression () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/LogisticRegression.pmml");
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
    test:assertFloatEquals(result, expected, "'LogisticRegression.pmml' failed to execute: ");
}

function testClassification () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/Classification.pmml");
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
    test:assertStringEquals(result, expected, "'Classification.pmml' failed to execute: ");
}

function testInteractionTerms () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/InteractionTerms.pmml");
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
    test:assertFloatEquals(result, expected, "'InteractionTerms.pmml' failed to execute: ");
}

function testRegressionIrisSetosa () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/RegressionIris.pmml");
    xml data = xml `<data>
                    <Sepal.Length>5.1</Sepal.Length>
                    <Sepal.Width>3.7</Sepal.Width>
                    <Petal.Length>1.5</Petal.Length>
                    <Petal.Width>0.4</Petal.Width>
                </data>`;
    var result, resultConversionError = (string)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    string expected = "setosa";
    println(result);
    test:assertStringEquals(result, expected, "'RegressionIris.pmml' failed to execute: ");
}

function testRegressionIrisVersicolor () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/RegressionIris.pmml");
    xml data = xml `<data>
                    <Sepal.Length>5.5</Sepal.Length>
                    <Sepal.Width>2.4</Sepal.Width>
                    <Petal.Length>3.8</Petal.Length>
                    <Petal.Width>1.1</Petal.Width>
                </data>`;
    var result, resultConversionError = (string)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    string expected = "versicolor";
    println(result);
    test:assertStringEquals(result, expected, "'RegressionIris.pmml' failed to execute: ");
}

function testRegressionIrisVirginica () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/RegressionIris.pmml");
    xml data = xml `<data>
                    <Sepal.Length>7.2</Sepal.Length>
                    <Sepal.Width>3.2</Sepal.Width>
                    <Petal.Length>6.0</Petal.Length>
                    <Petal.Width>1.8</Petal.Width>
                </data>`;
    var result, resultConversionError = (string)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    string expected = "virginica";
    println(result);
    test:assertStringEquals(result, expected, "'RegressionIris.pmml' failed to execute: ");
}

function testRegressionOzone () {
    xml pmml = pmml:readXMLFromFile("ballerina/pmml/test/res/RegressionOzone.pmml");
    xml data = xml `<data>
                    <temp>30</temp>
                    <ibh>1.21</ibh>
                    <ibt>0.032</ibt>
                </data>`;
    var result, resultConversionError = (float)pmml:predict(pmml, data);
    if (resultConversionError != null) {
        throw resultConversionError;
    }
    float expected = 3.683621024442372;
    println(result);
    test:assertFloatEquals(result, expected, "'RegressionOzone.pmml' failed to execute: ");
}
