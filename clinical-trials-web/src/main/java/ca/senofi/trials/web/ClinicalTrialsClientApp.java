package ca.senofi.trials.web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
//@EnableConfigurationProperties({ApplicationProperties.class})
//@EnableDiscoveryClient
public class ClinicalTrialsClientApp   {


    /**
     * Main method, used to run the application.
     *
     * @param args the command line arguments.
     */
    public static void main(String[] args) {
        SpringApplication.run(ClinicalTrialsClientApp.class, args);
    }
}
