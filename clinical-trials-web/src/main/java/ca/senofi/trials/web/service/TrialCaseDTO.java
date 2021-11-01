package ca.senofi.trials.web.service;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
 
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrialCaseDTO {
   
    private String status;//new, in process, closed, accepted
    private String caseId;
    private String description;
    private String subjectName;
    private String siteName;
    private Date submissionDate;

//    private Date closedDate;
//    private String closedBy;
//    private String acceptedBy;
//    private Date acceptedDate;
//    
//    private String conclusion;
    
    public String toJson() {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.writeValueAsString(this);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
    
    @JsonCreator
    public static TrialCaseDTO Create(String jsonString) {
        ObjectMapper mapper = new ObjectMapper();
        TrialCaseDTO caseDto = null;
        try {
            caseDto = mapper.readValue(jsonString, TrialCaseDTO.class);
        } catch (Exception e) {
            return new TrialCaseDTO();
        }
        return caseDto;
    }
}
