
import ballerina/edi;
import ballerina/io;

public function main() returns error? {
    string ediText = check io:fileReadString("message.edi");
    PURCHASE_ORDER simpleOrder = check fromEdiString(ediText);
    io:println(simpleOrder);
}


public isolated function fromEdiString(string ediText) returns PURCHASE_ORDER|error {
    edi:EdiSchema ediSchema = check edi:getSchema(schemaJson);
    json dataJson = check edi:fromEdiString(ediText, ediSchema);
    return dataJson.cloneWithType();
}

public isolated function toEdiString(PURCHASE_ORDER data) returns string|error {
    edi:EdiSchema ediSchema = check edi:getSchema(schemaJson);
    return edi:toEdiString(data, ediSchema);    
} 

public isolated function getSchema() returns edi:EdiSchema|error {
    return edi:getSchema(schemaJson);
}

public isolated function fromEdiStringWithSchema(string ediText, edi:EdiSchema schema) returns PURCHASE_ORDER|error {
    json dataJson = check edi:fromEdiString(ediText, schema);
    return dataJson.cloneWithType();
}

public isolated function toEdiStringWithSchema(PURCHASE_ORDER data, edi:EdiSchema ediSchema) returns string|error {
    return edi:toEdiString(data, ediSchema);    
}

public type Date_GType record {|
   string year;
   string month;
   string date;
|};

public type MessageHeader_Type record {|
   string code = "HDR";
   string message_id;
   Date_GType date;
|};

public type Catagory_Type record {|
   string code = "CAT";
   string name?;
   string catagory_id;
|};

public type Date2_GType record {|
   string year;
   string month;
   string date?;
|};

public type Location_GType record {|
   string city;
   string street?;
|};

public type Delivery_Type record {|
   string code = "LOC";
   Date2_GType date;
   Location_GType location;
|};

public type Item_Type record {|
   string code = "ITM";
   string item_name?;
   string item_id;
|};

public type Quantity_limit_GType record {|
   int? min?;
   int max;
|};

public type Quantity_Type record {|
   string code = "QUAN";
   Quantity_limit_GType quantity_limit;
|};

public type Price_limit_GType record {|
   float? min?;
   float max;
|};

public type Price_Type record {|
   string code = "PRC";
   Price_limit_GType price_limit;
|};

public type Price_GType record {|
   Item_Type item;
   Quantity_Type quantity;
   Price_Type price;
|};

public type Items_GType record {|
   Catagory_Type catagory;
   Delivery_Type delivery;
   Price_GType[] Price = [];
|};

public type PURCHASE_ORDER record {|
   MessageHeader_Type MessageHeader;
   Items_GType[] Items = [];
|};



final readonly & json schemaJson = {"name":"PURCHASE_ORDER", "ignoreSegments":[], "delimiters":{"segment":"'", "field":"+", "component":":", "repetition":"*", "decimalSeparator":","}, "segments":[{"code":"HDR", "tag":"MessageHeader", "fields":[{"tag":"code", "required":true}, {"tag":"message_id", "dataType":"string", "required":true}, {"tag":"date", "dataType":"composite", "required":true, "components":[{"tag":"year", "required":true, "dataType":"string"}, {"tag":"month", "required":true, "dataType":"string"}, {"tag":"date", "required":true, "dataType":"string"}]}], "minOccurances":1, "maxOccurances":1}, {"tag":"Items", "minOccurances":1, "maxOccurances":99, "segments":[{"code":"CAT", "tag":"catagory", "fields":[{"tag":"code", "required":true}, {"tag":"name"}, {"tag":"catagory_id", "required":true}], "minOccurances":1, "maxOccurances":1}, {"code":"LOC", "tag":"delivery", "fields":[{"tag":"code", "required":true}, {"tag":"date", "dataType":"composite", "required":true, "components":[{"tag":"year", "required":true, "dataType":"string"}, {"tag":"month", "required":true, "dataType":"string"}, {"tag":"date", "required":false, "dataType":"string"}]}, {"tag":"location", "dataType":"composite", "required":true, "components":[{"tag":"city", "required":true, "dataType":"string"}, {"tag":"street", "required":false, "dataType":"string"}]}], "minOccurances":1, "maxOccurances":1}, {"tag":"Price", "minOccurances":1, "maxOccurances":99, "segments":[{"code":"ITM", "tag":"item", "fields":[{"tag":"code", "required":true}, {"tag":"item_name", "required":false}, {"tag":"item_id", "required":true}], "minOccurances":1, "maxOccurances":1}, {"code":"QUAN", "tag":"quantity", "fields":[{"tag":"code", "required":true}, {"tag":"quantity_limit", "dataType":"composite", "required":true, "components":[{"tag":"min", "required":false, "dataType":"int"}, {"tag":"max", "required":true, "dataType":"int"}]}], "minOccurances":1, "maxOccurances":1}, {"code":"PRC", "tag":"price", "fields":[{"tag":"code", "required":true}, {"tag":"price_limit", "dataType":"composite", "required":true, "components":[{"tag":"min", "required":false, "dataType":"float"}, {"tag":"max", "required":true, "dataType":"float"}]}], "minOccurances":1, "maxOccurances":1}]}]}]};
    