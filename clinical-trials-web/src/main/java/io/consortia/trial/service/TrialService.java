package io.consortia.trial.service;

import java.util.List;

import javax.validation.Valid;

public interface TrialService {
    
    public static enum STATUS {NEW, INPROCESS, CLOSED, ACCEPTED };

    public TrialCaseDTO create(NewTrialCaseDTO input);

    public TrialCaseDTO update(UpdateTrialCaseDTO input);

    public List<TrialCaseDTO> get();

    public void updateStatus(@Valid String caseId, @Valid String status);

}
