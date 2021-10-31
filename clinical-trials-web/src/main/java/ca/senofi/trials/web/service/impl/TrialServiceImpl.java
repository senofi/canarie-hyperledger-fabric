package ca.senofi.trials.web.service.impl;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import ca.senofi.trials.web.service.NewTrialCaseDTO;
import ca.senofi.trials.web.service.TrialCaseDTO;
import ca.senofi.trials.web.service.TrialService;
import ca.senofi.trials.web.service.UpdateTrialCaseDTO;
import ca.senofi.trials.web.webclient.rest.InvokeInputDTO;
import ca.senofi.trials.web.webclient.rest.QueryResultDTO;
import ca.senofi.trials.web.webclient.service.ContractService;


@Service
public class TrialServiceImpl implements TrialService {

    private static final String CREATE = "create";
    private static final String STATUS = "status";

    private static String TYPE_CASE = "case";
    
    @Autowired
    private ContractService contractService;
    
    private String channelId = System.getenv("channel");
    private String contractId = System.getenv("contractId");
    
    @Override
    public TrialCaseDTO create(NewTrialCaseDTO input) {
        InvokeInputDTO invokeDto = new InvokeInputDTO();
        TrialCaseDTO caseDto = new TrialCaseDTO();
        caseDto.setDescription(input.getDescription());
        caseDto.setSiteName(input.getSiteName());
        caseDto.setSubjectName(input.getSubjectName());
        caseDto.setSubmissionDate(Calendar.getInstance().getTime());
        caseDto.setStatus(TrialService.STATUS.NEW.toString());
        caseDto.setCaseId(UUID.randomUUID().toString());
        invokeDto.setArgs(new String[] {caseDto.toJson()});
        contractService.invoke(channelId, contractId, CREATE, invokeDto);
        
        return caseDto;
    }

    @Override
    public TrialCaseDTO update(UpdateTrialCaseDTO input) {
       throw new RuntimeException("Not implemented");
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<TrialCaseDTO> get() { 
        QueryResultDTO result = contractService.query(channelId, contractId, TYPE_CASE, "");
        String resultAsString = result.getResult();
        //Convert it from json to list of objects
        
        ObjectMapper mapper = new ObjectMapper(); 

        try {
            System.out.println("Query result is: " + resultAsString);
            @SuppressWarnings("unchecked")
            List<TrialCaseDTO> obj = (List<TrialCaseDTO>) mapper.readValue(resultAsString, mapper.getTypeFactory().constructCollectionType(List.class, TrialCaseDTO.class));
            return obj;//new TypeReference<List<TrialCaseDTO>>(){}
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void updateStatus(@Valid String caseId, @Valid String status) { 
        InvokeInputDTO invokeDto = new InvokeInputDTO();
        invokeDto.setArgs(new String[] {caseId, status});
        contractService.invoke(channelId, contractId, STATUS, invokeDto); 
        
    }

}
