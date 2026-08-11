package com.vp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@Configuration
// REMOVED @EnableWebMvc - Spring Boot handles MVC auto-configuration
public class WebMvcConfiguration implements WebMvcConfigurer {

    /**
     * Configure JSP View Resolver
     */
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        resolver.setExposeContextBeansAsAttributes(true);
        return resolver;
    }

    /**
     * Configure Static Resource Handling
     * Maps /static/** to /resources/static/
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // CSS files
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCachePeriod(3600);
        
        // JavaScript files
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCachePeriod(3600);
        
        // Images
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/")
                .setCachePeriod(3600);
        
        // Uploaded files (if storing locally)
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:./uploads/")
                .setCachePeriod(3600);
        
        // Fonts
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/")
                .setCachePeriod(3600);
    }

    /**
     * Configure CORS (Cross-Origin Resource Sharing)
     * Allows frontend applications to communicate with backend
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:3000", "http://localhost:8080")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }

    /**
     * Configure Multipart Resolver for File Uploads
     */
    @Bean
    public MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

    /**
     * Configure View Controllers (Direct URL to View mapping)
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Root redirects to login only
        // No other routes defined here - controllers will handle everything
    }

    /**
     * Configure Interceptors (e.g., for authentication checks)
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Add custom interceptors here when needed
        // Example: registry.addInterceptor(new AuthenticationInterceptor())
        //           .addPathPatterns("/instructor/**", "/student/**", "/admin/**")
        //           .excludePathPatterns("/auth/**", "/css/**", "/js/**", "/images/**");
    }

    /**
     * Configure Content Negotiation
     */
    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer
                .favorParameter(false)
                .favorPathExtension(false)
                .ignoreAcceptHeader(false)
                .defaultContentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .mediaType("json", org.springframework.http.MediaType.APPLICATION_JSON)
                .mediaType("xml", org.springframework.http.MediaType.APPLICATION_XML);
    }
}