package com.vp.service.instructor;

import com.vp.entity.Course;
import com.vp.repository.CourseRepository;
import com.vp.service.common.FileUploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Service class for managing instructor courses (Optimized for HikariCP performance)
 */
@Service
public class InstructorCourseService {

    private static final Logger logger = LoggerFactory.getLogger(InstructorCourseService.class);

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private FileUploadService fileUploadService;

    // ==================== CREATE COURSE ====================

    @Transactional
    public Course createCourse(Course course, MultipartFile thumbnail, MultipartFile instructorPhoto) {
        try {
            course.setCreatedAt(LocalDateTime.now());
            course.setUpdatedAt(LocalDateTime.now());

            if (course.getAverageRating() == null) course.setAverageRating(0.0);
            if (course.getTotalEnrollments() == null) course.setTotalEnrollments(0);
            if (course.getTotalReviews() == null) course.setTotalReviews(0);

            if (thumbnail != null && !thumbnail.isEmpty()) {
                logger.info("Uploading course thumbnail for: {}", course.getTitle());
                String thumbnailUrl = fileUploadService.uploadFile(thumbnail, "courses/thumbnails");
                course.setThumbnailUrl(thumbnailUrl);
            }

            if (instructorPhoto != null && !instructorPhoto.isEmpty()) {
                logger.info("Uploading instructor photo for course: {}", course.getTitle());
                String photoUrl = fileUploadService.uploadFile(instructorPhoto, "instructors/photos");
                course.setInstructorPhotoUrl(photoUrl);
            }

            Course savedCourse = courseRepository.save(course);
            logger.info("✅ Course created successfully - ID: {}, Title: {}", savedCourse.getId(), savedCourse.getTitle());

            return savedCourse;

        } catch (Exception e) {
            logger.error("❌ Failed to create course: {}", course.getTitle(), e);
            throw new RuntimeException("Failed to create course: " + e.getMessage(), e);
        }
    }

    // ==================== UPDATE COURSE ====================

    @Transactional
    public Course updateCourse(Course course, MultipartFile thumbnail, MultipartFile instructorPhoto) {
        try {
            Course existingCourse = getCourseById(course.getId());

            course.setUpdatedAt(LocalDateTime.now());
            course.setCreatedAt(existingCourse.getCreatedAt());

            if (thumbnail != null && !thumbnail.isEmpty()) {
                if (existingCourse.getThumbnailUrl() != null) {
                    try { fileUploadService.deleteFile(existingCourse.getThumbnailUrl()); } 
                    catch (Exception e) { logger.warn("Failed to delete old thumbnail: {}", e.getMessage()); }
                }
                String thumbnailUrl = fileUploadService.uploadFile(thumbnail, "courses/thumbnails");
                course.setThumbnailUrl(thumbnailUrl);
            } else {
                course.setThumbnailUrl(existingCourse.getThumbnailUrl());
            }

            if (instructorPhoto != null && !instructorPhoto.isEmpty()) {
                if (existingCourse.getInstructorPhotoUrl() != null) {
                    try { fileUploadService.deleteFile(existingCourse.getInstructorPhotoUrl()); } 
                    catch (Exception e) { logger.warn("Failed to delete old instructor photo: {}", e.getMessage()); }
                }
                String photoUrl = fileUploadService.uploadFile(instructorPhoto, "instructors/photos");
                course.setInstructorPhotoUrl(photoUrl);
            } else {
                course.setInstructorPhotoUrl(existingCourse.getInstructorPhotoUrl());
            }

            Course updatedCourse = courseRepository.save(course);
            logger.info("✅ Course updated successfully - ID: {}", updatedCourse.getId());

            return updatedCourse;

        } catch (Exception e) {
            logger.error("❌ Failed to update course ID: {}", course.getId(), e);
            throw new RuntimeException("Failed to update course: " + e.getMessage(), e);
        }
    }

    @Transactional
    public Course saveCourse(Course course) {
        try {
            course.setUpdatedAt(LocalDateTime.now());
            return courseRepository.save(course);
        } catch (Exception e) {
            logger.error("❌ Failed to save course ID: {}", course.getId(), e);
            throw new RuntimeException("Failed to save course: " + e.getMessage(), e);
        }
    }

    // ==================== RETRIEVE COURSES (OPTIMIZED FOR HikariCP) ====================

    @Transactional(readOnly = true)
    public List<Course> getCoursesByInstructor(String instructorEmail) {
        try {
            return courseRepository.findByInstructorEmail(instructorEmail);
        } catch (Exception e) {
            logger.error("Failed to retrieve courses for instructor: {}", instructorEmail, e);
            throw new RuntimeException("Failed to retrieve courses: " + e.getMessage(), e);
        }
    }

    @Transactional(readOnly = true)
    public Course getCourseById(Long id) {
        return courseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Course not found with ID: " + id));
    }

    /**
     * Optimized: Connection release speed is faster using readOnly = true
     */
    @Transactional(readOnly = true)
    public List<Course> getLiveCourses() {
        try {
            List<Course> courses = courseRepository.findPublishedCourses();
            logger.info("Retrieved {} published courses for homepage", courses.size());
            return courses;
        } catch (Exception e) {
            logger.error("Failed to retrieve published courses", e);
            throw new RuntimeException("Failed to retrieve published courses: " + e.getMessage(), e);
        }
    }

    @Transactional(readOnly = true)
    public List<Course> getAllCourses() {
        try {
            return courseRepository.findAll();
        } catch (Exception e) {
            logger.error("Failed to retrieve all courses", e);
            throw new RuntimeException("Failed to retrieve courses: " + e.getMessage(), e);
        }
    }

    // ==================== DELETE COURSE ====================

    @Transactional
    public void deleteCourse(Long id) {
        try {
            Course course = getCourseById(id);

            if (course.getThumbnailUrl() != null) {
                try { fileUploadService.deleteFile(course.getThumbnailUrl()); } catch (Exception ignored) {}
            }
            if (course.getInstructorPhotoUrl() != null) {
                try { fileUploadService.deleteFile(course.getInstructorPhotoUrl()); } catch (Exception ignored) {}
            }

            courseRepository.deleteById(id);
            logger.info("✅ Course deleted successfully - ID: {}", id);

        } catch (Exception e) {
            logger.error("❌ Failed to delete course ID: {}", id, e);
            throw new RuntimeException("Failed to delete course: " + e.getMessage(), e);
        }
    }

    // ==================== SEARCH & STATISTICS ====================

    @Transactional(readOnly = true)
    public List<Course> getCoursesByCategory(String category) {
        return courseRepository.findByCategory(category);
    }

    @Transactional(readOnly = true)
    public List<Course> getCoursesByStatus(String status) {
        return courseRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public List<Course> searchCourses(String keyword) {
        return courseRepository.searchByKeyword(keyword);
    }

    @Transactional(readOnly = true)
    public long getCourseCountByInstructor(String instructorEmail) {
        Long count = courseRepository.countByInstructorEmail(instructorEmail);
        return count != null ? count : 0;
    }

    @Transactional(readOnly = true)
    public boolean courseExists(Long id) {
        return courseRepository.existsById(id);
    }

    @Transactional(readOnly = true)
    public boolean isInstructorOwner(Long courseId, String instructorEmail) {
        try {
            Course course = getCourseById(courseId);
            return course.getInstructorEmail() != null && course.getInstructorEmail().equals(instructorEmail);
        } catch (Exception e) {
            return false;
        }
    }
}