package com.vp.controller.admin;

import com.vp.entity.Course;
import com.vp.entity.User;
import com.vp.service.admin.CourseService;
import com.vp.service.auth.UserService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminCourseController {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminCourseController.class);
    
    @Autowired
    private CourseService courseService;
    
    @Autowired
    private UserService userService;
    
    /**
     * Display course approval page
     */
    @GetMapping("/courses")
    public String coursesPage(Model model, HttpSession session) {
        logger.info("Loading admin courses page");
        
        try {
            List<Course> allCourses = courseService.getAllCourses();
            
            // Enrich courses with instructor details
            List<Map<String, Object>> enrichedCourses = allCourses.stream().map(course -> {
                Map<String, Object> courseData = new HashMap<>();
                courseData.put("id", course.getId());
                courseData.put("title", course.getTitle());
                courseData.put("category", course.getCategory());
                courseData.put("status", course.getStatus());
                courseData.put("thumbnailUrl", course.getThumbnailUrl());
                courseData.put("createdAt", course.getCreatedAt());
                courseData.put("lecturesCount", course.getLecturesCount());
                courseData.put("totalDuration", course.getTotalDuration());
                
                // Get instructor details
                String instructorEmail = course.getInstructorEmail();
                courseData.put("instructorEmail", instructorEmail);
                
                Optional<User> instructor = userService.getUserByEmail(instructorEmail);
                if (instructor.isPresent()) {
                    User user = instructor.get();
                    courseData.put("instructorName", user.getFullName());
                    courseData.put("instructorPhotoUrl", user.getProfilePictureUrl());
                } else {
                    String extractedName = extractNameFromEmail(instructorEmail);
                    courseData.put("instructorName", extractedName);
                    courseData.put("instructorPhotoUrl", null);
                }
                
                return courseData;
            }).collect(Collectors.toList());
            
            model.addAttribute("courses", enrichedCourses);
            
            // ✅ APPROVED → LIVE
            long pendingCount  = allCourses.stream().filter(c -> "DRAFT".equals(c.getStatus())).count();
            long liveCount     = allCourses.stream().filter(c -> "LIVE".equals(c.getStatus())).count();
            long rejectedCount = allCourses.stream().filter(c -> "REJECTED".equals(c.getStatus())).count();
            
            model.addAttribute("pendingCourses", pendingCount);
            model.addAttribute("approvedCourses", liveCount); // JSP mein approvedCourses naam hai isliye same rakha
            model.addAttribute("rejectedCourses", rejectedCount);
            model.addAttribute("totalCount", allCourses.size());
            
            // Add user info from session
            model.addAttribute("userFullName", session.getAttribute("userFullName"));
            model.addAttribute("userRole", session.getAttribute("userRole"));
            
            logger.info("Loaded {} courses successfully", allCourses.size());
            
        } catch (Exception e) {
            logger.error("Error loading courses: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load courses");
        }
        
        return "admin/courses";
    }
    
    /**
     * Get single course details (AJAX)
     */
    @GetMapping("/courses/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCourse(@PathVariable Long id) {
        logger.info("Fetching course details for ID: {}", id);
        
        try {
            Optional<Course> courseOpt = courseService.getCourseById(id);
            
            if (courseOpt.isPresent()) {
                Course course = courseOpt.get();
                Map<String, Object> courseData = new HashMap<>();
                
                courseData.put("id", course.getId());
                courseData.put("title", course.getTitle());
                courseData.put("description", course.getDescription());
                courseData.put("category", course.getCategory());
                courseData.put("level", course.getLevel());
                courseData.put("language", course.getLanguage());
                courseData.put("price", course.getPrice());
                courseData.put("currency", course.getCurrency());
                courseData.put("status", course.getStatus());
                courseData.put("thumbnailUrl", course.getThumbnailUrl());
                courseData.put("lecturesCount", course.getLecturesCount());
                courseData.put("totalDuration", course.getTotalDuration());
                
                String instructorEmail = course.getInstructorEmail();
                courseData.put("instructorEmail", instructorEmail);
                
                Optional<User> instructor = userService.getUserByEmail(instructorEmail);
                if (instructor.isPresent()) {
                    User user = instructor.get();
                    courseData.put("instructorName", user.getFullName());
                    courseData.put("instructorPhotoUrl", user.getProfilePictureUrl());
                    courseData.put("instructorBio", user.getBio() != null ? user.getBio() : "No bio available");
                    courseData.put("instructorRole", user.getRole().toString());
                } else {
                    courseData.put("instructorName", extractNameFromEmail(instructorEmail));
                    courseData.put("instructorPhotoUrl", null);
                    courseData.put("instructorBio", "No bio available");
                }
                
                return ResponseEntity.ok(courseData);
            } else {
                return ResponseEntity.notFound().build();
            }
            
        } catch (Exception e) {
            logger.error("Error fetching course {}: {}", id, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get all courses (AJAX)
     */
    @GetMapping("/api/courses")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAllCourses() {
        try {
            List<Course> courses = courseService.getAllCourses();
            
            List<Map<String, Object>> enrichedCourses = courses.stream().map(course -> {
                Map<String, Object> data = new HashMap<>();
                data.put("course", course);
                
                String instructorEmail = course.getInstructorEmail();
                Optional<User> instructor = userService.getUserByEmail(instructorEmail);
                
                if (instructor.isPresent()) {
                    data.put("instructorName", instructor.get().getFullName());
                    data.put("instructorPhotoUrl", instructor.get().getProfilePictureUrl());
                } else {
                    data.put("instructorName", extractNameFromEmail(instructorEmail));
                    data.put("instructorPhotoUrl", null);
                }
                
                return data;
            }).collect(Collectors.toList());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("courses", enrichedCourses);
            response.put("count", courses.size());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("Error fetching courses: {}", e.getMessage(), e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to fetch courses");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Get courses by status (AJAX)
     */
    @GetMapping("/api/courses/status/{status}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCoursesByStatus(@PathVariable String status) {
        try {
            List<Course> courses = courseService.getCoursesByStatus(status.toUpperCase());
            
            List<Map<String, Object>> enrichedCourses = courses.stream().map(course -> {
                Map<String, Object> data = new HashMap<>();
                data.put("course", course);
                
                String instructorEmail = course.getInstructorEmail();
                Optional<User> instructor = userService.getUserByEmail(instructorEmail);
                
                if (instructor.isPresent()) {
                    data.put("instructorName", instructor.get().getFullName());
                    data.put("instructorPhotoUrl", instructor.get().getProfilePictureUrl());
                } else {
                    data.put("instructorName", extractNameFromEmail(instructorEmail));
                    data.put("instructorPhotoUrl", null);
                }
                
                return data;
            }).collect(Collectors.toList());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("courses", enrichedCourses);
            response.put("count", enrichedCourses.size());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("Error fetching courses by status: {}", e.getMessage(), e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to fetch courses");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * ✅ Approve = directly LIVE (AJAX)
     */
    @PostMapping("/courses/{id}/approve")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> approveCourse(@PathVariable Long id) {
        logger.info("Received request to make course LIVE, ID: {}", id);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            boolean success = courseService.approveCourse(id);
            
            if (success) {
                response.put("success", true);
                response.put("message", "Course is now LIVE!");
                logger.info("Course ID {} is now LIVE", id);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Course not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
            
        } catch (Exception e) {
            logger.error("Error making course ID {} live: {}", id, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Failed to make course live");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Reject a course (AJAX)
     */
    @PostMapping("/courses/{id}/reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> rejectCourse(
            @PathVariable Long id,
            @RequestBody Map<String, String> payload) {
        
        String reason = payload.getOrDefault("reason", "No reason provided");
        logger.info("Received request to reject course ID: {} with reason: {}", id, reason);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            boolean success = courseService.rejectCourse(id, reason);
            
            if (success) {
                response.put("success", true);
                response.put("message", "Course rejected successfully");
                logger.info("Course ID {} rejected successfully", id);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Course not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
            
        } catch (Exception e) {
            logger.error("Error rejecting course ID {}: {}", id, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "Failed to reject course");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Search courses (AJAX)
     */
    @GetMapping("/api/courses/search")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchCourses(@RequestParam String keyword) {
        try {
            List<Course> courses = courseService.searchCourses(keyword);
            
            List<Map<String, Object>> enrichedCourses = courses.stream().map(course -> {
                Map<String, Object> data = new HashMap<>();
                data.put("course", course);
                
                String instructorEmail = course.getInstructorEmail();
                Optional<User> instructor = userService.getUserByEmail(instructorEmail);
                
                if (instructor.isPresent()) {
                    data.put("instructorName", instructor.get().getFullName());
                    data.put("instructorPhotoUrl", instructor.get().getProfilePictureUrl());
                } else {
                    data.put("instructorName", extractNameFromEmail(instructorEmail));
                    data.put("instructorPhotoUrl", null);
                }
                
                return data;
            }).collect(Collectors.toList());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("courses", enrichedCourses);
            response.put("count", enrichedCourses.size());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("Error searching courses: {}", e.getMessage(), e);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to search courses");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Helper method: Extract name from email
     */
    private String extractNameFromEmail(String email) {
        if (email == null || !email.contains("@")) {
            return "Unknown Instructor";
        }
        
        String username = email.substring(0, email.indexOf("@"));
        
        username = username.replace(".", " ")
                          .replace("_", " ")
                          .replace("-", " ");
        
        String[] words = username.split("\\s+");
        StringBuilder result = new StringBuilder();
        
        for (String word : words) {
            if (word.length() > 0) {
                result.append(Character.toUpperCase(word.charAt(0)));
                if (word.length() > 1) {
                    result.append(word.substring(1).toLowerCase());
                }
                result.append(" ");
            }
        }
        
        return result.toString().trim();
    }
}