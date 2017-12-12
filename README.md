# PMML API For Ballerina
**A "proof-of-concept" API written in [Ballerina](https://ballerinalang.org/) for Ballerina to read and predict values using machine learning models defined with [PMML](http://dmg.org/pmml/pmml-v4-2-1.html)**

### Contents
1. [Introduction](#introduction)
2. [Downloading The API](#downloading-the-api)
3. [Using The API](#using-the-api)
4. [Making Changes](#making-changes)
5. [Additional Information](#additional-information)

## Introduction
**This is a PMML API (proof-of-concept) written to test the limits of Ballerina's built-in XML library.**

Ballerina is a general purpose, concurrent and strongly typed programming language offered by [WSO2](https://wso2.com/) with both textual and graphical syntaxes, optimized for integration.

This API does not fully support all features of PMML nor all versions. The API is only supports PMML version 4.2 and the only PMML files that can be used are the ones that have one of the following types of machine learning models:
* Linear Regression
* Polynomial Regression
* Logistic Regression
* Classification

All of the above machine learning models can be defined by the `<RegressionModel>` element in PMML.

## Downloading The API
To download the API you can either clone the repository to your local machine by typing the following git command,
> ~$ git clone https://github.com/moizalicious/ballerina-pmml

Or you can download the source files by clicking on one of the following links,
* [zip (v1.0-alpha)](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.zip)
* [tar.gz (v1.0-alpha)](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.tar.gz)

Extract and open the file, then copy the `ballerina` folder to your own Ballerina project. Once the folder is added you can use the PMML API in your project by importing the PMML package to your code by typing `import ballerina.pmml;`

**Add a screenshot here**

## Using The API
To predict values using this API with a machine learning model, we need two things,
1. The PMML file of that respective machine learning model.
2. The independent data that is to be fed into the machine learning model to predict an outcome.

Both the PMML file and the independent values should be Ballerina `xml` objects. The PMML XML object must have the `<PMML>` element as the root element and should follow the format of PMML version 4.2.

The independent values must be added in the following format,
```xml
<data>
    <value1></value1>
    <value2></value2>
    ...
    ...
</data>
```
Where the root element must always be `<data>` and the child elements must have the same names that are defined in the attributes of the PMML element's data dictionary (besides the target element).

Once you have these two XML objects you have to add them as arguments to the function `pmml:predict(xml pmml, xml data);` to obtain the predicted value. The outcome is returned as a Ballerina `any` typed object.

### Example For Classification Using The Iris Data Set
The following XML code is a trained classification model in the form of PMML for the iris data set. Using this machine learning model we can predict which species a flower would come under (setosa, versicolor or verginica), based on the flower's petal width, petal length, sepal width & sepal length. To do this, download the following code and save it as `RegressionIris.pmml` in your Ballerina project.

**Click [here](https://raw.githubusercontent.com/moizalicious/ballerina-pmml/master/ballerina/pmml/test/res/RegressionIris.pmml) to download the following PMML file.**
```xml
<PMML version="4.2" xmlns="http://www.dmg.org/PMML-4_2">
    <Header copyright="Copyright (c) 2013 Vfed" description="Multinomial Logistic Model">
        <Extension name="user" value="Vfed" extender="Rattle/PMML"/>
        <Application name="Rattle/PMML" version="1.3"/>
        <Timestamp>2013-09-16 10:33:36</Timestamp>
    </Header>
    <DataDictionary numberOfFields="5">
        <DataField name="Species" optype="categorical" dataType="string">
            <Value value="setosa"/>
            <Value value="versicolor"/>
            <Value value="virginica"/>
        </DataField>
        <DataField name="Sepal.Length" optype="continuous" dataType="double"/>
        <DataField name="Sepal.Width" optype="continuous" dataType="double"/>
        <DataField name="Petal.Length" optype="continuous" dataType="double"/>
        <DataField name="Petal.Width" optype="continuous" dataType="double"/>
    </DataDictionary>
    <RegressionModel modelName="multinom_Model" functionName="classification" algorithmName="multinom" normalizationMethod="softmax">
        <MiningSchema>
            <MiningField name="Species" usageType="target"/>
            <MiningField name="Sepal.Length" usageType="active"/>
            <MiningField name="Sepal.Width" usageType="active"/>
            <MiningField name="Petal.Length" usageType="active"/>
            <MiningField name="Petal.Width" usageType="active"/>
        </MiningSchema>
        <RegressionTable intercept="18.6903742570084" targetCategory="versicolor">
            <NumericPredictor name="Sepal.Length" exponent="1" coefficient="-5.4584240070066"/>
            <NumericPredictor name="Sepal.Width" exponent="1" coefficient="-8.70740085056537"/>
            <NumericPredictor name="Petal.Length" exponent="1" coefficient="14.2447701274546"/>
            <NumericPredictor name="Petal.Width" exponent="1" coefficient="-3.09768387037777"/>
        </RegressionTable>
        <RegressionTable intercept="-23.836276029112" targetCategory="virginica">
            <NumericPredictor name="Sepal.Length" exponent="1" coefficient="-7.92363397246724"/>
            <NumericPredictor name="Sepal.Width" exponent="1" coefficient="-15.3707689334102"/>
            <NumericPredictor name="Petal.Length" exponent="1" coefficient="23.6597792429927"/>
            <NumericPredictor name="Petal.Width" exponent="1" coefficient="15.1353005479779"/>
        </RegressionTable>
        <RegressionTable intercept="0.0" targetCategory="setosa"/>
    </RegressionModel>
</PMML>
```

The PMML file has 5 `<DataField>` elements,
* Species
* Sepal.Length
* Sepal.Width
* Petal.Length
* Petal.Width

Since 'Species' is the target that we are trying to predict (as defined by the `usageType` attribute in the `<MiningSchema>` element), we do not add any values for that. So if we want to predict what kind of species a flower with petal width = 0.4cm, petal length = 1.5cm, sepal width = 3.7cm and sepal length = 5.1cm comes under. We have to have a `<data>` element like this,
```xml
<data>
    <Petal.Width>0.4</Petal.Width>
    <Petal.Length>1.5</Petal.Length>
    <Sepal.Width>3.7</Sepal.Width>
    <Sepal.Length>5.1</Sepal.Length>
</data>
```

The following code shows how to use the `predict()` function in the PMML API to get the predicted species of the flower based on the `<data>` elements above,
```ballerina
import ballerina.pmml;

function main (string[]args) {
    xml pmml = pmml:readXMLFromFile("RegressionIris.pmml");
    xml data = xml `<data>
                        <Petal.Width>0.4</Petal.Width>
                        <Petal.Length>1.5</Petal.Length>
                        <Sepal.Width>3.7</Sepal.Width>
                        <Sepal.Length>5.1</Sepal.Length>
                    </data>`;
    any result = pmml:predict(pmml, data);                
    println(result);
}
```
The expected result of the above element should be,
> setosa

Some sample values for the iris data set can be found [here](https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data) which can be used as inputs.

|Function Name|Description|Parameters|
|:---:|---|---|
|predict(**xml** pmml, **xml** data|Based on the ML model defined in the <PMML> element will be redirected to the necessary function|**pmml** - The PMML element to be used <br/> **data** - The independent values entered by the user|
|isValid(**xml** pmml)|Checks whether the given xml argument has a valid <PMML> element|**pmml** - The PMML element to be used|
|isPredictable(**xml** pmml)|Checks whether the given <PMML> element can be predictable using the API|**pmml** - The PMML element to be used|
|isDataElementValid(**xml** data)|Checks whether the <data> element given by the user is valid|**data** - The data element entered by the user|
|getModelType(**xml** pmml)|Gets the type of the ML model the <PMML> element is using|**pmml** - THe PMML element to be used|
|getVersion(**xml** pmml)|Gets the type of the ML model the <PMML> element is using|**pmml** - The PMML element to be used|
|readXMLFromFile(**string** filePath)|Reads data from a file and converts it to an XML object|**filePath** - The relative path in which the file can be found|

## Making Changes
If you would like to contribute to this repository feel free to do so. Check out the [Developer Guide](https://github.com/moizalicious/ballerina-pmml/blob/master/docs/dev-guide.md) to learn more about the source and the internal structure of the API.

## Additional Information
Mostly about what features the API does not have. Also a link to the developer documentation.
