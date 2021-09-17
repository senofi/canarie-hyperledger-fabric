package io.consortia.trial.web.rest;

import java.security.Principal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class UserApi {
    
    @GetMapping("/user")
    public ResponseEntity<Principal> login(Principal principal) {
        return ResponseEntity.ok(principal);
    }

}
