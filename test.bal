import ballerina/log;

type User record {|
    string name;
|};

type Payload record {|
    record {|
        *User;
        string cardNo;
    |} patient;
|};

function foo(Payload payload) {
    Payload {patient: {...patient}} = payload;
    log:printInfo("Appointment reservation successful", name = patient.name);
}

public function main() {
    Payload request = {
        patient: {name: "jack", cardNo: "1"}
    };
    foo(request);
}