package ballerina.pmml;

function invalidPMMLElementError () (error) {
    error err = {msg:"not a valid pmml element"};
    return err;
}

function unsupportedPMMLElementError () (error) {
    error err = {msg:"the given PMML element is currently not supported"};
    return err;
}

function generateError (string msg) (error) {
    error err = {msg:msg};
    return err;
}
