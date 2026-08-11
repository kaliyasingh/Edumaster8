package com.vp.config;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CloudinaryConfig {

    @Value("${cloudinary.cloud-name}")
    private String cloudName;

    @Value("${cloudinary.api-key}")
    private String apiKey;

    @Value("${cloudinary.api-secret}")
    private String apiSecret;

    @Bean
    public Cloudinary cloudinary() {
        Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", cloudName,
            "api_key", apiKey,
            "api_secret", apiSecret,
            "secure", true
        ));
        
        // Log configuration (without exposing secret)
        System.out.println("=== Cloudinary Configuration ===");
        System.out.println("Cloud Name: " + cloudName);
        System.out.println("API Key: " + apiKey);
        System.out.println("API Secret: " + (apiSecret != null && !apiSecret.isEmpty() ? "*******" : "NOT SET"));
        System.out.println("================================");
        
        return cloudinary;
    }
}

// ============================================================
// application.properties or application.yml configuration
// ============================================================

// For application.properties:
// cloudinary.cloud-name=df9afoenn
// cloudinary.api-key=262622358469544
// cloudinary.api-secret=YOUR_ACTUAL_API_SECRET_HERE

// For application.yml:
// cloudinary:
//   cloud-name: df9afoenn
//   api-key: 262622358469544
//   api-secret: YOUR_ACTUAL_API_SECRET_HERE