package com.vp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * Async Configuration for Background Tasks
 * This enables @Async annotation to work properly for sending emails in background
 */
@Configuration
@EnableAsync
public class AsyncConfiguration {

    /**
     * Thread pool for async tasks (like sending welcome emails)
     * This ensures emails are sent in background without blocking registration
     */
    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);           // Minimum threads
        executor.setMaxPoolSize(5);            // Maximum threads
        executor.setQueueCapacity(100);        // Queue capacity
        executor.setThreadNamePrefix("async-"); // Thread name prefix
        executor.initialize();
        return executor;
    }
}