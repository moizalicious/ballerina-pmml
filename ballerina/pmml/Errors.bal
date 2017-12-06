package ballerina.pmml;

function generateError (string msg) (error) {
    error err = {msg:msg};
    return err;
}
