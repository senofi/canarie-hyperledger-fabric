package ca.senofi.trials.web.web.rest;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.senofi.trials.web.service.NewTrialCaseDTO;
import ca.senofi.trials.web.service.TrialCaseDTO;
import ca.senofi.trials.web.service.TrialService;

@RestController
@RequestMapping("/api")
public class TrialCaseApi {
    @Autowired
    private TrialService trialService;

    @PostMapping("/trials")
    public ResponseEntity<TrialCaseDTO> createTrial(@RequestBody NewTrialCaseDTO input) {
        TrialCaseDTO trial = trialService.create(input);
        return ResponseEntity.ok(trial);
    }

    @PutMapping("/trials/{caseId}/status/{status}")
    public ResponseEntity<Void> updateTrial(@Valid @PathVariable(name = "caseId", required = true) String caseId,
            @Valid @PathVariable(name = "status", required = true) String status) {
        trialService.updateStatus(caseId, status);
        return ResponseEntity.ok().headers(new HttpHeaders()).build();
    }

    @GetMapping("/trials")
    public ResponseEntity<List<TrialCaseDTO>> getTrials() {
        List<TrialCaseDTO> trials = trialService.get();
        return ResponseEntity.ok(trials);
    }

}
