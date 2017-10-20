package ballerina.lang.pmml;

import ballerina.lang.xmls;

function version (xml pmml) (float) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    var pmmlVersion, _ = <float>pmml@["version"];
    return pmmlVersion;
}

function isValid (xml pmml) (boolean) {
    // Currently supported models.
    string[] models = ["AssociationModel", "BaselineModel", "BayesianNetworkModel",
                       "ClusteringModel", "GaussianProcessModel", "GeneralRegressionModel",
                       "NearestNeighborModel", "NaiveBayesModel", "NeuralNetwork",
                       "RegressionModel", "RuleSetModel", "Scorecard",
                       "SequenceModel", "TextModel", "TimeSeriesModel",
                       "TreeModel", "SupportVectorMachineModel"];

    // Get XML information.
    boolean isEmpty = xmls:isEmpty(pmml);
    string itemType = xmls:getItemType(pmml);
    boolean isSingleton = xmls:isSingleton(pmml);
    string elementName = xmls:getElementName(pmml);
    //TODO find a way to read the namespace from the pmml file. This is hardcoded.
    xmlns "http://www.dmg.org/PMML-4_1" as ns1;
    xmlns "http://www.dmg.org/PMML-4_2" as ns2;
    xmlns "http://www.dmg.org/PMML-4_3" as ns3;
    string pmmlVersion = pmml@["version"];
    // Check whether the pmml has a valid ML model element
    boolean isValidModelType = hasValidModelType(pmml);
    // Check whether the XML is a valid PMML element.
    if (!isEmpty && (itemType == "element") && isSingleton && isValidModelType) {
        if (elementName == ns1:PMML || elementName == ns2:PMML || elementName == ns3:PMML) {
            if (pmmlVersion == "4.1" || pmmlVersion == "4.2" || pmmlVersion == "4.3") {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}

function hasChildElement (xml pmml, string elementName) (boolean) {
    xml element = xmls:selectChildren(pmml, elementName);
    if (!xmls:isEmpty(element)) {
        return true;
    } else {
        return false;
    }
}

function hasValidModelType (xml pmml) (boolean) {
    string[] models = ["AssociationModel", "BaselineModel", "BayesianNetworkModel",
                       "ClusteringModel", "GaussianProcessModel", "GeneralRegressionModel",
                       "NearestNeighborModel", "NaiveBayesModel", "NeuralNetwork",
                       "RegressionModel", "RuleSetModel", "Scorecard",
                       "SequenceModel", "TextModel", "TimeSeriesModel",
                       "TreeModel", "SupportVectorMachineModel"];

    int index = 0;
    while (index < models.length) {
        if (hasChildElement(pmml, models[index])) {
            return true;
        }
        index = index + 1;
    }
    return false;
}