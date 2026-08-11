package com.vp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class EdumasterApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(EdumasterApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(EdumasterApplication.class, args);
        System.out.println("========================================");
        System.out.println("✅ EduMaster Application Started!");
        System.out.println("🌐 Access at:http://localhost:8081");
        System.out.println("========================================");
  
    }
}