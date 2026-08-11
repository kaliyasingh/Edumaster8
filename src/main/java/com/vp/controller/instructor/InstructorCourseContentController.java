// ============================================
// InstructorCourseContentController.java (UPDATED)
// ============================================
package com.vp.controller.instructor;

import com.vp.entity.CourseContent;
import com.vp.entity.CourseSection;
import com.vp.entity.User;
import com.vp.service.instructor.InstructorContentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/instructor/course-content")
public class InstructorCourseContentController {

    @Autowired
    private InstructorContentService contentService;

    @GetMapping("/sections/{courseId}")
    public ResponseEntity<Map<String, Object>> getSections(
            @PathVariable Long courseId, 
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            List<CourseSection> sections = contentService.getCourseSections(courseId, userEmail);
            
            // DEBUG: Print what we're returning
            for (CourseSection section : sections) {
                System.out.println("=== Section: " + section.getTitle() + " ===");
                if (section.getContents() != null) {
                    for (CourseContent content : section.getContents()) {
                        System.out.println("Content ID: " + content.getId());
                        System.out.println("Content Type: " + content.getContentType());
                        System.out.println("Video URL: " + content.getVideoUrl());
                        System.out.println("File URL: " + content.getFileUrl());
                        System.out.println("---");
                    }
                }
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("sections", sections);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/sections")
    public ResponseEntity<Map<String, Object>> createSection(
            @RequestParam Long courseId,
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam int orderIndex,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseSection section = contentService.createSection(
                courseId, userEmail, title, description, orderIndex);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("section", section);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/sections/{sectionId}")
    public ResponseEntity<Map<String, Object>> updateSection(
            @PathVariable Long sectionId,
            @RequestParam String title,
            @RequestParam(required = false) String description,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseSection section = contentService.updateSection(
                sectionId, userEmail, title, description);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("section", section);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/sections/{sectionId}")
    public ResponseEntity<Map<String, Object>> deleteSection(
            @PathVariable Long sectionId, 
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            contentService.deleteSection(sectionId, userEmail);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // UPDATED: Added resourceFiles parameter
    @PostMapping("/content/video")
    public ResponseEntity<Map<String, Object>> uploadVideo(
            @RequestParam Long sectionId,
            @RequestParam String title,
            @RequestParam(required = false) MultipartFile videoFile,
            @RequestParam(required = false) String videoUrl,
            @RequestParam(required = false) Integer durationMinutes,
            @RequestParam(required = false) Integer durationSeconds,
            @RequestParam(required = false) String transcript,
            @RequestParam(required = false) List<MultipartFile> resourceFiles,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseContent content = contentService.uploadVideo(
                sectionId, userEmail, title, videoFile, videoUrl,
                durationMinutes, durationSeconds, transcript, resourceFiles);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("content", content);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // UPDATED: Added PUT method for video
    @PutMapping("/content/video/{contentId}")
    public ResponseEntity<Map<String, Object>> updateVideo(
            @PathVariable Long contentId,
            @RequestParam String title,
            @RequestParam(required = false) MultipartFile videoFile,
            @RequestParam(required = false) String videoUrl,
            @RequestParam(required = false) Integer durationMinutes,
            @RequestParam(required = false) Integer durationSeconds,
            @RequestParam(required = false) String transcript,
            @RequestParam(required = false) List<MultipartFile> resourceFiles,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseContent content = contentService.updateVideo(
                contentId, userEmail, title, videoFile, videoUrl,
                durationMinutes, durationSeconds, transcript, resourceFiles);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("content", content);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/content/document")
    public ResponseEntity<Map<String, Object>> uploadDocument(
            @RequestParam Long sectionId,
            @RequestParam String title,
            @RequestParam MultipartFile documentFile,
            @RequestParam(required = false) String description,
            @RequestParam(defaultValue = "true") boolean downloadable,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseContent content = contentService.uploadDocument(
                sectionId, userEmail, title, documentFile, description, downloadable);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("content", content);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // UPDATED: Added PUT method for document
    @PutMapping("/content/document/{contentId}")
    public ResponseEntity<Map<String, Object>> updateDocument(
            @PathVariable Long contentId,
            @RequestParam String title,
            @RequestParam(required = false) MultipartFile documentFile,
            @RequestParam(required = false) String description,
            @RequestParam(defaultValue = "true") boolean downloadable,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseContent content = contentService.updateDocument(
                contentId, userEmail, title, documentFile, description, downloadable);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("content", content);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // UPDATED: Added resourceFiles parameter
    @PostMapping("/content/assignment")
    public ResponseEntity<Map<String, Object>> createAssignment(
            @RequestParam Long sectionId,
            @RequestParam String title,
            @RequestParam String instructions,
            @RequestParam(required = false) Double estimatedHours,
            @RequestParam(defaultValue = "false") boolean allowSubmission,
            @RequestParam(required = false) List<MultipartFile> resourceFiles,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseContent content = contentService.createAssignment(
                sectionId, userEmail, title, instructions, estimatedHours, 
                allowSubmission, resourceFiles);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("content", content);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // UPDATED: Added PUT method for assignment
    @PutMapping("/content/assignment/{contentId}")
    public ResponseEntity<Map<String, Object>> updateAssignment(
            @PathVariable Long contentId,
            @RequestParam String title,
            @RequestParam String instructions,
            @RequestParam(required = false) Double estimatedHours,
            @RequestParam(defaultValue = "false") boolean allowSubmission,
            @RequestParam(required = false) List<MultipartFile> resourceFiles,
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            CourseContent content = contentService.updateAssignment(
                contentId, userEmail, title, instructions, estimatedHours, 
                allowSubmission, resourceFiles);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("content", content);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/content/{contentId}")
    public ResponseEntity<Map<String, Object>> deleteContent(
            @PathVariable Long contentId, 
            HttpSession session) {
        
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            contentService.deleteContent(contentId, userEmail);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}