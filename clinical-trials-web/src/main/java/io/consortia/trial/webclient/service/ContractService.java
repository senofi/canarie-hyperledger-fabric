package io.consortia.trial.webclient.service;

import javax.validation.Valid;

import io.consortia.trial.webclient.rest.InvokeInputDTO;
import io.consortia.trial.webclient.rest.InvokeResultDTO;
import io.consortia.trial.webclient.rest.QueryResultDTO;

public interface ContractService {

   public QueryResultDTO query(@Valid String channelId, @Valid String contractId, String... input);

   public InvokeResultDTO invoke(@Valid String channelId, @Valid String contractId, String operation, InvokeInputDTO input);

}
