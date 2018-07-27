# PMML Library For Ballerina
**A "proof-of-concept" library written in [Ballerina](https://ballerinalang.org/) for Ballerina to read and predict values using machine learning models defined with [PMML](http://dmg.org/pmml/pmml-v4-2-1.html)**

### Contents
1. [Introduction](#introduction)
2. [Downloading The Library](#downloading-the-library)
3. [Using The Library](#using-the-library)
4. [Making Changes](#making-changes)
5. [Copyright Information](#copyright-information)

## Introduction
**This is a PMML library (proof-of-concept) written to test the limits of Ballerina's built-in XML library.**

Ballerina is a general purpose, concurrent and strongly typed programming language offered by [WSO2](https://wso2.com/) with both textual and graphical syntaxes, optimized for integration.

The Predictive Model Markup Language (PMML) is an XML-based language which provides a way for applications to define statistical and data mining models and to share models between PMML compliant applications.

This library does not fully support all features of PMML nor all versions. The library only supports PMML version 4.2 and the only PMML files that can be used are the ones that contain one of the following machine learning models:
* Linear Regression
* Polynomial Regression
* Logistic Regression
* Classification

*All of the above machine learning models are defined by the `<RegressionModel>` element in PMML.*

## Downloading The Library
To download the library you can either clone the repository to your local machine by typing the following git command,
> ~$ git clone https://github.com/moizalicious/ballerina-pmml

Or you can download the source files by clicking on one of the following links,
* [zip (v1.0-alpha)](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.zip)
* [tar.gz (v1.0-alpha)](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.tar.gz)

Extract and open the downloaded file, then copy the `ml` folder provided to your own Ballerina project. Once the folder is added to your project you can start using the PMML library by importing the `pmml` package in your code by typing `import ml.pmml;`

![Using The PMML Library](https://raw.githubusercontent.com/moizalicious/ballerina-pmml/master/docs/imgs/pmmlSample.png)

## Using The library
To predict values using this library with a machine learning model, you need two things,
1. The PMML file of that respective machine learning model.
2. The independent values that is to be fed into the machine learning model to predict an outcome.

Both the PMML file and the independent values should be of Ballerina `xml` type. The PMML XML object must have the `<PMML>` element as the root element and should follow the XML Schema of PMML version 4.2.

The independent values must be added in the following XML format,
```xml
<data>
    <value1></value1>
    <value2></value2>
    ...
    ...
</data>
```
Where the root element must always be `<data>` and the child elements must have the same names that are defined in the name attribute in the data field elements of the PMML element's data dictionary (besides the target element).

Once we have these two XML objects, we have to add them as arguments to the function `predict(xml pmml, xml data)` to obtain the predicted value. The outcome is returned as a Ballerina `any` type variable. An example is given below.

### Example For Classification Using The Iris Data Set
The following XML code is a trained classification model in the form of PMML for the iris data set. Using this machine learning model we can predict which species a flower would come under (setosa, versicolor or verginica), based on the flower's sepal length, sepal width, petal length & petal width. To do this, download the following XML code and save it as `RegressionIris.pmml` in your Ballerina project.

**Click [here](https://raw.githubusercontent.com/moizalicious/ballerina-pmml/master/ml/pmml/test/res/RegressionIris.pmml) to download the following PMML file.**
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
* Sepal Length
* Sepal Width
* Petal Length
* Petal Width

Since 'Species' is the target that we are trying to predict (as defined by the `usageType` attribute in the `<MiningSchema>` element), we do not add any values for that. So if we want to predict what kind of species a flower with sepal length = 5.1, sepal width = 3.5, petal length = 1.4 and petal width = 0.2 comes under. We write the `<data>` element like this,
```xml
<data>
    <Sepal.Length>5.1</Sepal.Length>
    <Sepal.Width>3.5</Sepal.Width>
    <Petal.Length>1.4</Petal.Length>
    <Petal.Width>0.2</Petal.Width>
</data>
```

The following code shows how to use the `predict()` function in the PMML library to get the predicted species of the flower based on the `<data>` element above (the `RegressionIris.pmml` file is read using the `readXMLFromFile()` function provided by the library),
```ballerina
import ml.pmml;

function main (string[]args) {
    // Read the file as a Ballerina XML object
    xml pmml = pmml:readXMLFromFile("RegressionIris.pmml");
    // Create the data XML with the independent values
    xml data = xml `<data>
                        <Sepal.Length>5.1</Sepal.Length>
                        <Sepal.Width>3.5</Sepal.Width>
                        <Petal.Length>1.4</Petal.Length>
                        <Petal.Width>0.2</Petal.Width>
                    </data>`;
    // Predict the outcome and print it to the console                
    any result = pmml:predict(pmml, data);                
    println(result);
}
```
The output of the above code is,
> setosa

This means that the species the flower with sepal length = 5.1, sepal width = 3.5, petal length = 1.4 and petal width = 0.2 is predicted to come under the *setosa* category. You can change the values yourself and see how the outcome changes. **To see whether the model is accurate you can use real data from [here](https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data) and see whether the expected outcome is printed in the console.**

*Note that the inputs in the data element do not always have to be continuous (i.e numerical), you can enter categorical values as well based on the PMML code requirements*

For an example,
```xml
<data>
    <age>20</age>
    <salary>10000</salary>
    <car_location>street</car_location>
</data>
```

**To know more about the other public functions provided by the library check out the [User Guide](https://github.com/moizalicious/ballerina-pmml/blob/master/docs/user-guide.md)**

## Making Changes
If you would like to contribute to this repository and help improve this library feel free to do so. Check out the [Developer Guide](https://github.com/moizalicious/ballerina-pmml/blob/master/docs/dev-guide.md) to learn more about the source and the internal structure of the library.

## Copyright Information
Copyright 2017 Moiz Mansoor Ali.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
