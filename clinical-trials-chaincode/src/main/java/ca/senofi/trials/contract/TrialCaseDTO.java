package ca.senofi.trials.contract;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@JsonIgnoreProperties(ignoreUnknown = true)
public class TrialCaseDTO {
    
    /**
     * Status code. One of 'new', 'in process', 'closed', 'accepted'
     */
    private String status;
    private String caseId;
    private String description;
    private String subjectName;
    private String siteName;
    private Date submissionDate;


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCaseId() {
        return caseId;
    }

    public void setCaseId(String caseId) {
        this.caseId = caseId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public Date getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Date submissionDate) {
        this.submissionDate = submissionDate;
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

    public String toJson() {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.writeValueAsString(this);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
 
}
