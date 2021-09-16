
package ca.senofi.trials.contract;

import java.nio.charset.StandardCharsets;
import java.util.List;

import javax.json.Json;
import javax.json.JsonArrayBuilder;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperledger.fabric.protos.msp.Identities;
import org.hyperledger.fabric.protos.msp.Identities.SerializedIdentity;
import org.hyperledger.fabric.shim.ChaincodeBase;
import org.hyperledger.fabric.shim.ChaincodeStub;
import org.hyperledger.fabric.shim.ResponseUtils;
import org.hyperledger.fabric.shim.ledger.KeyValue;
import org.hyperledger.fabric.shim.ledger.QueryResultsIterator;

import com.google.protobuf.InvalidProtocolBufferException;

public class TrialChaincode extends ChaincodeBase {

    private static final Log _logger = LogFactory.getLog(TrialChaincode.class);

    private static final String COMP_KEY_CASE = "type~object";
    private static final String COMP_KEY_PATIENT = "type~object~case";
    private static final String COMP_KEY_STATUS = "type~object~case";
    private static final String TYPE_CASE = "case";
    private static final String TYPE_PATIENT = "patient";
    private static final String TYPE_STATUS = "status";


    @Override
    public Response init(ChaincodeStub stub) {
        return ResponseUtils.newSuccessResponse();
    }

    @Override
    public Response invoke(ChaincodeStub stub) {
        try {
            _logger.info("Invoke trial chaincode");
            String func = stub.getFunction();
            List<String> params = stub.getParameters();
            if (func.equals("create")) {
                return create(stub, params);
            }
            if (func.equals("delete")) {
                return delete(stub, params);
            }
            if (func.equals("status")) {
                return updateStatus(stub, params);
            }
            if (func.equals("query")) {
                return query(stub, params);
            }
            return ResponseUtils.newErrorResponse("Invalid invoke function name. Expecting one of: [\"create\", \"status\", \"delete\", \"query\"]");
        } catch (Exception e) {
            return ResponseUtils.newErrorResponse(e);
        }
    }

    private Response updateStatus(ChaincodeStub stub, List<String> params) {

        String mspID = getCallerMSPId(stub);

        String caseId = params.get(0);
        String status = params.get(1);
        QueryResultsIterator<KeyValue> result = null;
        result = stub.getStateByPartialCompositeKey(stub.createCompositeKey(COMP_KEY_CASE, TYPE_CASE, caseId).toString());
        if (!result.iterator().hasNext()) {
            return ResponseUtils.newErrorResponse("No case with id: " + caseId);
        }
        String caseJson = result.iterator().next().getStringValue();
        TrialCaseDTO caseDto = TrialCaseDTO.Create(caseJson);
        String currentStatus = caseDto.getStatus();
        caseDto.setStatus(status);

        stub.delState(stub.createCompositeKey(COMP_KEY_STATUS, TYPE_STATUS, currentStatus, caseDto.getCaseId()).toString());
        stub.putStringState(stub.createCompositeKey(COMP_KEY_STATUS, TYPE_STATUS, caseDto.getStatus(), caseDto.getCaseId()).toString(), "");
        stub.putStringState(stub.createCompositeKey(COMP_KEY_CASE, TYPE_CASE, caseId).toString(), caseDto.toJson());
        return ResponseUtils.newSuccessResponse();
    }

    private Response create(ChaincodeStub stub, List<String> args) {
        if (args.size() != 1) {
            return ResponseUtils.newErrorResponse("Incorrect number of arguments. Expecting 1");
        }

        String mspID = getCallerMSPId(stub);

        _logger.info(String.format("Creating record from json: %s", args.get(0)));

        // Convert the transaction payload from json to object
        // public part of the date to be recorded in plain on the chain
        TrialCaseDTO caseDTO = TrialCaseDTO.Create(args.get(0));

        _logger.info(String.format("Recording to public chain: %s", caseDTO.toJson()));

        String publicJson = caseDTO.toJson();
        // The data of the recorded case is stored under the composite key "type~object"
        stub.putStringState(stub.createCompositeKey(COMP_KEY_CASE, TYPE_CASE, caseDTO.getCaseId()).toString(), publicJson);

        // The following KVS is used for query purposes
        stub.putStringState(stub.createCompositeKey(COMP_KEY_PATIENT, TYPE_PATIENT, caseDTO.getSubjectName(), caseDTO.getCaseId()).toString(),
                "");
        stub.putStringState(stub.createCompositeKey(COMP_KEY_STATUS, TYPE_STATUS, caseDTO.getStatus(), caseDTO.getCaseId()).toString(), "");

        _logger.info("Case created");

        return ResponseUtils.newSuccessResponse();
    }

    private String getCallerMSPId(ChaincodeStub stub) {
        SerializedIdentity identity;
        try {
            identity = Identities.SerializedIdentity.parseFrom(stub.getCreator());
        } catch (InvalidProtocolBufferException e) {
            _logger.error("Internal error", e);
            throw new RuntimeException(e);
        }

        return identity.getMspid().toLowerCase();
    }

    /**
     * Deletes a case by ID and all related KVS entries
     * 
     * @param stub
     * @param args
     * @return
     */
    private Response delete(ChaincodeStub stub, List<String> args) {
        if (args.size() != 1) {
            return ResponseUtils.newErrorResponse("Incorrect number of arguments. Expecting 1");
        }
        String caseId = args.get(0);
        _logger.info("Delete case id: " + caseId);

        // Delete the key from the state in ledger
        String compKey = stub.createCompositeKey(COMP_KEY_CASE, TYPE_CASE, caseId).toString();
        String caseJson = stub.getStringState(compKey);
        _logger.info("Key is: " + compKey);
        _logger.info("Key value is: " + caseJson);

        TrialCaseDTO caseDTO = TrialCaseDTO.Create(caseJson);

        // Delete the case KVS that contains the case value
        stub.delState(compKey);

        // Delete the additional KVS entries related to the case
        if (caseDTO.getSubjectName() != null)
            stub.delState(stub.createCompositeKey(COMP_KEY_PATIENT, TYPE_PATIENT, caseDTO.getSubjectName(), caseDTO.getCaseId()).toString());
        if (caseDTO.getStatus() != null)
            stub.delState(stub.createCompositeKey(COMP_KEY_STATUS, TYPE_STATUS, caseDTO.getStatus(), caseDTO.getCaseId()).toString());

        return ResponseUtils.newSuccessResponse();
    }

    /**
     * Query for cases by Case ID, Patient ID or Case status Each of the above 3
     * queries has a pre-set type as follows: Case ID: case Patient ID: patient Case
     * Status: status
     * 
     * Examples:
     * 
     * 1. To fetch all cases for particular patient you can call this methods with
     * the following args: new String[] { "patient", <patientID> };
     * 
     * 2. To fetch all cases pass the following args: new String[] { "case", "" };
     * //Note you should pass an empty string as second parameter
     * 
     * 3. To fetch all cases with particular status, call with the following args:
     * new String[] { "status", <status> }; // for example <status> could new new or
     * pending etc..
     * 
     * @param stub
     * @param args
     * @return
     */
    private Response query(ChaincodeStub stub, List<String> args) {

        String type = args.get(0).toLowerCase();
        String objectID = args.get(1);

        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
        QueryResultsIterator<KeyValue> result = null;
        _logger.info("Case query: " + type + "  id " + objectID);
        if (objectID.equals("")) {
            result = stub.getStateByPartialCompositeKey(stub.createCompositeKey(COMP_KEY_CASE, type));
        } else {
            result = stub.getStateByPartialCompositeKey(stub.createCompositeKey(COMP_KEY_CASE, type, objectID));
        }

        if (type.equals(TYPE_CASE)) {
            for (KeyValue var : result) {
                _logger.info("Case record: " + var.getStringValue());
                arrayBuilder.add(var.getStringValue());
            }
        } else if (type.equals(TYPE_STATUS) || type.equals(TYPE_PATIENT)) {
            // Fetch the information for all the cases, the value of the iterator will be
            // the case ID
            String caseValue = null;
            for (KeyValue var : result) {
                _logger.info("Case record id: " + var.getStringValue());
                caseValue = stub.getStringState(stub.createCompositeKey(COMP_KEY_CASE, TYPE_CASE, var.getStringValue()).toString());
                _logger.info("Case record for id: " + caseValue);
                arrayBuilder.add(caseValue);
            }
        }
        String res = arrayBuilder.build().toString();
        _logger.info("Case record for id: " + res);
        return ResponseUtils.newSuccessResponse(res.getBytes(StandardCharsets.UTF_8));
    }

    public static void main(String[] args) {
        new TrialChaincode().start(args);
    }

}
