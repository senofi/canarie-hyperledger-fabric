package ca.senofi.trials.web.webclient.service;

import javax.validation.Valid;

import ca.senofi.trials.web.webclient.rest.InvokeInputDTO;
import ca.senofi.trials.web.webclient.rest.InvokeResultDTO;
import ca.senofi.trials.web.webclient.rest.QueryResultDTO;

public interface ContractService {

   public QueryResultDTO query(@Valid String channelId, @Valid String contractId, String... input);

   public InvokeResultDTO invoke(@Valid String channelId, @Valid String contractId, String operation, InvokeInputDTO input);

}
