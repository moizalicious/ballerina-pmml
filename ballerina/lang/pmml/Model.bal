package ballerina.lang.pmml;

import ballerina.lang.errors;
import ballerina.lang.strings;
import ballerina.lang.xmls;

function executeModel (xml pmml, any[] data) {
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }


    // TODO make the identification of the models better
    string modelType = getModelType(pmml);
    if (strings:contains(modelType, "GeneralRegressionModel")) {
        errors:Error err = {msg:"the model " + modelType + " is currently not supported"};
        throw err;
    } else if (strings:contains(modelType, "RegressionModel")) {
        executeRegressionModel(pmml, data);
    } else {
        errors:Error err = {msg:"the model " + modelType + " execution is currently not supported"};
        throw err;
    }
}

function getModelElement (xml pmml) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }

    // Models Used - AssociationModel, BaselineModel, BayesianNetworkModel,
    // ClusteringModel, GaussianProcessModel, GeneralRegressionModel, NearestNeighborModel,
    // NaiveBayesModel, NeuralNetwork, RegressionModel, RuleSetModel, Scorecard, SequenceModel,
    // TextModel, TimeSeriesModel, TreeModel, SupportVectorMachineModel
    string[] models = ["AssociationModel", "BaselineModel", "BayesianNetworkModel",
                       "ClusteringModel", "GaussianProcessModel", "GeneralRegressionModel",
                       "NearestNeighborModel", "NaiveBayesModel", "NeuralNetwork",
                       "RegressionModel", "RuleSetModel", "Scorecard",
                       "SequenceModel", "TextModel", "TimeSeriesModel",
                       "TreeModel", "SupportVectorMachineModel"];

    xml modelElement = null;
    int index = 0;
    boolean modelFound = false;
    while (index < models.length) {
        if (hasChildElement(pmml, models[index])) {
            modelFound = true;
            modelElement = xmls:selectChildren(pmml, models[index]);
            break;
        }
        index = index + 1;
    }
    if (modelFound) {
        return modelElement;
    } else {
        errors:Error err = {msg:"there is no ML model available in the pmml"};
        throw err;
    }
}

function getModelType (xml pmml) (string) {
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }

    xml modelElement = getModelElement(pmml);
    string modelType = xmls:getElementName(modelElement);
    return modelType;
}
