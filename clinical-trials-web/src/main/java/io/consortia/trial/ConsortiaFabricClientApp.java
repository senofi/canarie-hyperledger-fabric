package io.consortia.trial;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
//@EnableConfigurationProperties({ApplicationProperties.class})
//@EnableDiscoveryClient
public class ConsortiaFabricClientApp   {


    /**
     * Main method, used to run the application.
     *
     * @param args the command line arguments.
     */
    public static void main(String[] args) {
        SpringApplication.run(ConsortiaFabricClientApp.class, args);
    }
}
