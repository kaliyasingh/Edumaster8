// ============================================
// InstructorContentService.java (UPDATED)
// ============================================
package com.vp.service.instructor;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.vp.entity.Course;
import com.vp.entity.CourseContent;
import com.vp.entity.CourseSection;
import com.vp.repository.CourseContentRepository;
import com.vp.repository.CourseRepository;
import com.vp.repository.CourseSectionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class InstructorContentService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private CourseSectionRepository sectionRepository;

    @Autowired
    private CourseContentRepository contentRepository;

    @Autowired
    private Cloudinary cloudinary;

    public List<CourseSection> getCourseSections(Long courseId, String instructorEmail) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        if (!course.getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        return sectionRepository.findByCourseOrderByOrderIndex(course);
    }

    @Transactional
    public CourseSection createSection(Long courseId, String instructorEmail, 
                                       String title, String description, int orderIndex) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        if (!course.getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        CourseSection section = new CourseSection();
        section.setCourse(course);
        section.setTitle(title);
        section.setDescription(description);
        section.setOrderIndex(orderIndex);
        section.setCreatedAt(LocalDateTime.now());

        return sectionRepository.save(section);
    }

    @Transactional
    public CourseSection updateSection(Long sectionId, String instructorEmail, 
                                       String title, String description) {
        CourseSection section = sectionRepository.findById(sectionId)
                .orElseThrow(() -> new RuntimeException("Section not found"));

        if (!section.getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        section.setTitle(title);
        section.setDescription(description);
        section.setUpdatedAt(LocalDateTime.now());

        return sectionRepository.save(section);
    }

    @Transactional
    public void deleteSection(Long sectionId, String instructorEmail) {
        CourseSection section = sectionRepository.findById(sectionId)
                .orElseThrow(() -> new RuntimeException("Section not found"));

        if (!section.getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        List<CourseContent> contents = contentRepository.findBySectionOrderByOrderIndex(section);
        for (CourseContent content : contents) {
            deleteContentFiles(content);
        }

        sectionRepository.delete(section);
    }

    @Transactional
    public CourseContent uploadVideo(Long sectionId, String instructorEmail, String title,
                                     MultipartFile videoFile, String videoUrl,
                                     Integer durationMinutes, Integer durationSeconds,
                                     String transcript, List<MultipartFile> resourceFiles) throws IOException {
        CourseSection section = sectionRepository.findById(sectionId)
                .orElseThrow(() -> new RuntimeException("Section not found"));

        if (!section.getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        CourseContent content = new CourseContent();
        content.setSection(section);
        content.setTitle(title);
        content.setContentType("VIDEO");

        if (videoFile != null && !videoFile.isEmpty()) {
            Map<String, Object> uploadResult = cloudinary.uploader().upload(
                videoFile.getBytes(),
                ObjectUtils.asMap(
                    "resource_type", "video",
                    "folder", "edumaster/videos"
                )
            );
            String cloudinaryUrl = uploadResult.get("secure_url").toString();
            
            // FIXED: Set BOTH fileUrl and videoUrl for Cloudinary videos
            content.setFileUrl(cloudinaryUrl);
            content.setVideoUrl(cloudinaryUrl);  // ADD THIS LINE
            content.setFileSize(videoFile.getSize());
            content.setVideoFileName(videoFile.getOriginalFilename());
        } else if (videoUrl != null && !videoUrl.isEmpty()) {
            // For YouTube/Vimeo URLs
            content.setVideoUrl(videoUrl);
        }

        if (durationMinutes != null && durationSeconds != null) {
            content.setDurationSeconds((durationMinutes * 60) + durationSeconds);
        }

        if (transcript != null && !transcript.isEmpty()) {
            content.setTranscript(transcript);
        }

        // Handle resource files
        if (resourceFiles != null && !resourceFiles.isEmpty()) {
            List<String> resourceUrls = uploadResourceFiles(resourceFiles);
            content.setResources(resourceUrls);
        }

        int nextOrder = contentRepository.findBySectionOrderByOrderIndex(section).size();
        content.setOrderIndex(nextOrder);
        content.setCreatedAt(LocalDateTime.now());

        return contentRepository.save(content);
    }

    // Also fix the updateVideo method
    @Transactional
    public CourseContent updateVideo(Long contentId, String instructorEmail, String title,
                                     MultipartFile videoFile, String videoUrl,
                                     Integer durationMinutes, Integer durationSeconds,
                                     String transcript, List<MultipartFile> resourceFiles) throws IOException {
        CourseContent content = contentRepository.findById(contentId)
                .orElseThrow(() -> new RuntimeException("Content not found"));

        if (!content.getSection().getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        content.setTitle(title);

        // Update video file if provided
        if (videoFile != null && !videoFile.isEmpty()) {
            // Delete old video if exists
            if (content.getFileUrl() != null && !content.getFileUrl().isEmpty()) {
                deleteFromCloudinary(content.getFileUrl());
            }
            
            Map<String, Object> uploadResult = cloudinary.uploader().upload(
                videoFile.getBytes(),
                ObjectUtils.asMap(
                    "resource_type", "video",
                    "folder", "edumaster/videos"
                )
            );
            String cloudinaryUrl = uploadResult.get("secure_url").toString();
            
            // FIXED: Set BOTH fileUrl and videoUrl for Cloudinary videos
            content.setFileUrl(cloudinaryUrl);
            content.setVideoUrl(cloudinaryUrl);  // ADD THIS LINE
            content.setFileSize(videoFile.getSize());
            content.setVideoFileName(videoFile.getOriginalFilename());
        } else if (videoUrl != null && !videoUrl.isEmpty()) {
            // For YouTube/Vimeo URLs
            content.setVideoUrl(videoUrl);
        }

        if (durationMinutes != null && durationSeconds != null) {
            content.setDurationSeconds((durationMinutes * 60) + durationSeconds);
        }

        content.setTranscript(transcript);

        // Update resource files if provided
        if (resourceFiles != null && !resourceFiles.isEmpty()) {
            // Delete old resources
            if (content.getResources() != null && !content.getResources().isEmpty()) {
                for (String resourceUrl : content.getResources()) {
                    deleteFromCloudinary(resourceUrl);
                }
            }
            List<String> resourceUrls = uploadResourceFiles(resourceFiles);
            content.setResources(resourceUrls);
        }

        content.setUpdatedAt(LocalDateTime.now());
        return contentRepository.save(content);
    }
    

@Transactional
public CourseContent uploadDocument(Long sectionId, String instructorEmail, String title,
                                    MultipartFile documentFile, String description,
                                    boolean downloadable) throws IOException {
    CourseSection section = sectionRepository.findById(sectionId)
            .orElseThrow(() -> new RuntimeException("Section not found"));

    if (!section.getCourse().getInstructorEmail().equals(instructorEmail)) {
        throw new RuntimeException("Unauthorized access");
    }

    if (documentFile == null || documentFile.isEmpty()) {
        throw new RuntimeException("Document file is required");
    }

    // FIXED: Add file extension to public_id for proper PDF viewing
    String originalFilename = documentFile.getOriginalFilename();
    String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
    String publicId = "edumaster/documents/" + System.currentTimeMillis() + fileExtension;

    Map<String, Object> uploadResult = cloudinary.uploader().upload(
        documentFile.getBytes(),
        ObjectUtils.asMap(
            "resource_type", "auto",
            "public_id", publicId,
            "folder", "edumaster/documents",
            "flags", "attachment:" + originalFilename  // Force download with original filename
        )
    );

    CourseContent content = new CourseContent();
    content.setSection(section);
    content.setTitle(title);
    content.setContentType("DOCUMENT");
    content.setFileUrl(uploadResult.get("secure_url").toString());
    content.setFileSize(documentFile.getSize());
    content.setDocumentFileName(documentFile.getOriginalFilename());
    content.setDescription(description);
    content.setDownloadable(downloadable);

    int nextOrder = contentRepository.findBySectionOrderByOrderIndex(section).size();
    content.setOrderIndex(nextOrder);
    content.setCreatedAt(LocalDateTime.now());

    return contentRepository.save(content);
}

// Also replace ONLY the updateDocument method:

@Transactional
public CourseContent updateDocument(Long contentId, String instructorEmail, String title,
                                    MultipartFile documentFile, String description,
                                    boolean downloadable) throws IOException {
    CourseContent content = contentRepository.findById(contentId)
            .orElseThrow(() -> new RuntimeException("Content not found"));

    if (!content.getSection().getCourse().getInstructorEmail().equals(instructorEmail)) {
        throw new RuntimeException("Unauthorized access");
    }

    content.setTitle(title);
    content.setDescription(description);
    content.setDownloadable(downloadable);

    // Update document file if provided
    if (documentFile != null && !documentFile.isEmpty()) {
        // Delete old document
        if (content.getFileUrl() != null && !content.getFileUrl().isEmpty()) {
            deleteFromCloudinary(content.getFileUrl());
        }

        // FIXED: Add file extension to public_id for proper PDF viewing
        String originalFilename = documentFile.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String publicId = "edumaster/documents/" + System.currentTimeMillis() + fileExtension;

        Map<String, Object> uploadResult = cloudinary.uploader().upload(
            documentFile.getBytes(),
            ObjectUtils.asMap(
                "resource_type", "auto",
                "public_id", publicId,
                "folder", "edumaster/documents",
                "flags", "attachment:" + originalFilename  // Force download with original filename
            )
        );
        content.setFileUrl(uploadResult.get("secure_url").toString());
        content.setFileSize(documentFile.getSize());
        content.setDocumentFileName(documentFile.getOriginalFilename());
    }

    content.setUpdatedAt(LocalDateTime.now());
    return contentRepository.save(content);
}
    
    // UPDATED: Added resourceFiles parameter
    @Transactional
    public CourseContent createAssignment(Long sectionId, String instructorEmail, String title,
                                          String instructions, Double estimatedHours,
                                          boolean allowSubmission, List<MultipartFile> resourceFiles) throws IOException {
        CourseSection section = sectionRepository.findById(sectionId)
                .orElseThrow(() -> new RuntimeException("Section not found"));

        if (!section.getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        CourseContent content = new CourseContent();
        content.setSection(section);
        content.setTitle(title);
        content.setContentType("ASSIGNMENT");
        content.setInstructions(instructions);
        content.setDescription(instructions);
        content.setEstimatedHours(estimatedHours);
        content.setAllowSubmission(allowSubmission);

        // Handle resource files
        if (resourceFiles != null && !resourceFiles.isEmpty()) {
            List<String> resourceUrls = uploadResourceFiles(resourceFiles);
            content.setResources(resourceUrls);
        }

        int nextOrder = contentRepository.findBySectionOrderByOrderIndex(section).size();
        content.setOrderIndex(nextOrder);
        content.setCreatedAt(LocalDateTime.now());

        return contentRepository.save(content);
    }

    // NEW: Update assignment method
    @Transactional
    public CourseContent updateAssignment(Long contentId, String instructorEmail, String title,
                                          String instructions, Double estimatedHours,
                                          boolean allowSubmission, List<MultipartFile> resourceFiles) throws IOException {
        CourseContent content = contentRepository.findById(contentId)
                .orElseThrow(() -> new RuntimeException("Content not found"));

        if (!content.getSection().getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        content.setTitle(title);
        content.setInstructions(instructions);
        content.setDescription(instructions);
        content.setEstimatedHours(estimatedHours);
        content.setAllowSubmission(allowSubmission);

        // Update resource files if provided
        if (resourceFiles != null && !resourceFiles.isEmpty()) {
            // Delete old resources
            if (content.getResources() != null && !content.getResources().isEmpty()) {
                for (String resourceUrl : content.getResources()) {
                    deleteFromCloudinary(resourceUrl);
                }
            }
            List<String> resourceUrls = uploadResourceFiles(resourceFiles);
            content.setResources(resourceUrls);
        }

        content.setUpdatedAt(LocalDateTime.now());
        return contentRepository.save(content);
    }

    @Transactional
    public void deleteContent(Long contentId, String instructorEmail) {
        CourseContent content = contentRepository.findById(contentId)
                .orElseThrow(() -> new RuntimeException("Content not found"));

        if (!content.getSection().getCourse().getInstructorEmail().equals(instructorEmail)) {
            throw new RuntimeException("Unauthorized access");
        }

        deleteContentFiles(content);
        contentRepository.delete(content);
    }

    // NEW: Helper method to upload resource files
    private List<String> uploadResourceFiles(List<MultipartFile> resourceFiles) throws IOException {
        List<String> resourceUrls = new ArrayList<>();
        
        for (MultipartFile file : resourceFiles) {
            if (file != null && !file.isEmpty()) {
                Map<String, Object> uploadResult = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap(
                        "resource_type", "raw",
                        "folder", "edumaster/resources"
                    )
                );
                resourceUrls.add(uploadResult.get("secure_url").toString());
            }
        }
        
        return resourceUrls;
    }

    // NEW: Helper method to delete all files associated with content
    private void deleteContentFiles(CourseContent content) {
        // Delete main file (video or document)
        if (content.getFileUrl() != null && !content.getFileUrl().isEmpty()) {
            deleteFromCloudinary(content.getFileUrl());
        }
        
        // Delete resource files
        if (content.getResources() != null && !content.getResources().isEmpty()) {
            for (String resourceUrl : content.getResources()) {
                deleteFromCloudinary(resourceUrl);
            }
        }
    }

    private void deleteFromCloudinary(String fileUrl) {
        try {
            String publicId = extractPublicIdFromUrl(fileUrl);
            if (publicId != null) {
                cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
            }
        } catch (Exception e) {
            System.err.println("Failed to delete from Cloudinary: " + e.getMessage());
        }
    }

    private String extractPublicIdFromUrl(String url) {
        try {
            // Extract public_id from Cloudinary URL
            // Example: https://res.cloudinary.com/demo/raw/upload/edumaster/resources/file.pdf
            String[] parts = url.split("/upload/");
            if (parts.length > 1) {
                String pathWithExtension = parts[1];
                // Remove extension
                int lastDot = pathWithExtension.lastIndexOf('.');
                if (lastDot > 0) {
                    return pathWithExtension.substring(0, lastDot);
                }
                return pathWithExtension;
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
}