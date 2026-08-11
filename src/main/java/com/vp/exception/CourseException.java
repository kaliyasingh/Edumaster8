package com.vp.exception;

// Base exception for course-related errors
public class CourseException extends RuntimeException {
    public CourseException(String message) {
        super(message);
    }

    public CourseException(String message, Throwable cause) {
        super(message, cause);
    }
}