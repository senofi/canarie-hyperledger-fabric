package ca.senofi.trials.web.webclient.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;

@Configuration
@EnableWebSecurity
public class CustomWebSecurityConfigurerAdapter extends WebSecurityConfigurerAdapter {
  
    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        
        String userName = System.getenv("adminUser");
        String password = System.getenv("adminPassword");
        if (userName == null) userName = "user";
        if (password == null) password = "pass";
        auth.inMemoryAuthentication()
          .withUser(userName).password(passwordEncoder().encode(password))
          .authorities("ROLE_USER");
    }
 
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
        .antMatcher("/api/**")
        .authorizeRequests()
            .antMatchers("/api/storage/**")
            .permitAll()
        .and()
        .authorizeRequests()
            .antMatchers("/api/**")
            .hasRole("USER")
        .and()
            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        .and()
            .httpBasic()
            .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
        .and()
            .csrf().disable();
//        http.authorizeRequests()
//          .antMatchers("/securityNone").permitAll()
//          .anyRequest().authenticated()
//          .and()
//          .httpBasic(); 
    }
 
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
