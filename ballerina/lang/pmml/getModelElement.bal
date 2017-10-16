package ballerina.lang.pmml;

import ballerina.lang.errors;
import ballerina.lang.xmls;

function getModelElement(xml pmml)(xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }

    xml modelElement = null;
    //TODO find a way to remove the hardcoded values.
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
        errors:Error err = {msg: "there is no ML model available in the pmml"};
        throw err;
    }
}

