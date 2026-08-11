// Specific exceptions
package com.vp.exception;

public class CourseNotFoundException extends CourseException {
    public CourseNotFoundException(String message) {
        super(message);
    }
}