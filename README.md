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

## Using The API
The following XML is a classification model that is written in PMML for the iris data set. We want to use this PMML file to predict which category a flower would come in (setosa, versicolor or verginica) based on the flowers petal width, petal length, sepal width & sepal length.
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
Click [here](https://raw.githubusercontent.com/moizalicious/ballerina-pmml/master/ballerina/pmml/test/res/RegressionIris.pmml) to download the above PMML file.

The following code describes how to use the API,
```ballerina
import ballerina.pmml;

function main (string[]args) {
    xml pmml = pmml:readXMLFromFile("RegressionIris.pmml");
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
    println(result);
}
```

## Making Changes
If you would like to contribute to this repository feel free to do so. Check out the [Developer Guide](addLinkHere) to learn more about the source and the internal structure of the API.

## Additional Information
Mostly about what features the API does not have. Also a link to the developer documentation.
