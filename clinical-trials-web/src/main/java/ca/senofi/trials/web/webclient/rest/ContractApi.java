package ca.senofi.trials.web.webclient.rest;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.senofi.trials.web.webclient.service.ContractService; 

@RestController
@RequestMapping("/api")
public class ContractApi {
    @Autowired
    private ContractService contractService;

    @PostMapping("/channel/{channelId}/contract/{contractId}/{operation}")
    public ResponseEntity<InvokeResultDTO> contractInvoke(@Valid @PathVariable(name = "contractId", required = true) String contractId,
            @Valid @PathVariable(name = "channelId", required = true) String channelId,
            @PathVariable(name = "operation", required = true) String operation, @RequestBody InvokeInputDTO input) {
        
        InvokeResultDTO invokeDTO = contractService.invoke(channelId, contractId, operation, input);
        return ResponseEntity.ok(invokeDTO);
    }

    @PostMapping("/channel/{channelId}/contract/{contractId}")
    public ResponseEntity<QueryResultDTO> contractQuery(@Valid @PathVariable(name = "channelId", required = true) String channelId,
            @Valid @PathVariable(name = "contractId", required = true) String contractId, @RequestBody String input) {
        QueryResultDTO queryDTO = contractService.query(channelId, contractId, input);
        return ResponseEntity.ok(queryDTO);
    }

}
