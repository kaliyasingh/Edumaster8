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
 * Service class for managing instructor courses
 */
@Service
@Transactional
public class InstructorCourseService {

    private static final Logger logger = LoggerFactory.getLogger(InstructorCourseService.class);

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private FileUploadService fileUploadService;

    // ==================== CREATE COURSE ====================

    /**
     * Create a new course with file uploads
     * 
     * @param course Course entity to create
     * @param thumbnail Thumbnail image file (optional)
     * @param instructorPhoto Instructor photo file (optional)
     * @return Created course entity
     */
    public Course createCourse(Course course, MultipartFile thumbnail, MultipartFile instructorPhoto) {
        try {
            // Set creation timestamp
            course.setCreatedAt(LocalDateTime.now());
            course.setUpdatedAt(LocalDateTime.now());

            // Initialize default values
            if (course.getAverageRating() == null) {
                course.setAverageRating(0.0);
            }
            if (course.getTotalEnrollments() == null) {
                course.setTotalEnrollments(0);
            }
            if (course.getTotalReviews() == null) {
                course.setTotalReviews(0);
            }

            // Upload thumbnail to Cloudinary
            if (thumbnail != null && !thumbnail.isEmpty()) {
                logger.info("Uploading course thumbnail for: {}", course.getTitle());
                String thumbnailUrl = fileUploadService.uploadFile(thumbnail, "courses/thumbnails");
                course.setThumbnailUrl(thumbnailUrl);
                logger.info("Thumbnail uploaded successfully: {}", thumbnailUrl);
            }

            // Upload instructor photo to Cloudinary
            if (instructorPhoto != null && !instructorPhoto.isEmpty()) {
                logger.info("Uploading instructor photo for course: {}", course.getTitle());
                String photoUrl = fileUploadService.uploadFile(instructorPhoto, "instructors/photos");
                course.setInstructorPhotoUrl(photoUrl);
                logger.info("Instructor photo uploaded successfully: {}", photoUrl);
            }

            // Save course to database
            Course savedCourse = courseRepository.save(course);
            logger.info("✅ Course created successfully - ID: {}, Title: {}", 
                       savedCourse.getId(), savedCourse.getTitle());

            return savedCourse;

        } catch (Exception e) {
            logger.error("❌ Failed to create course: {}", course.getTitle(), e);
            throw new RuntimeException("Failed to create course: " + e.getMessage(), e);
        }
    }

    // ==================== UPDATE COURSE ====================

    /**
     * Update an existing course with optional file uploads
     * 
     * @param course Course entity with updated data
     * @param thumbnail New thumbnail image file (optional)
     * @param instructorPhoto New instructor photo file (optional)
     * @return Updated course entity
     */
    public Course updateCourse(Course course, MultipartFile thumbnail, MultipartFile instructorPhoto) {
        try {
            // Verify course exists
            Course existingCourse = getCourseById(course.getId());

            // Update timestamp
            course.setUpdatedAt(LocalDateTime.now());

            // Preserve creation timestamp
            course.setCreatedAt(existingCourse.getCreatedAt());

            // Upload new thumbnail if provided
            if (thumbnail != null && !thumbnail.isEmpty()) {
                logger.info("Uploading new thumbnail for course: {}", course.getTitle());
                
                // Delete old thumbnail from Cloudinary (optional)
                if (existingCourse.getThumbnailUrl() != null) {
                    try {
                        fileUploadService.deleteFile(existingCourse.getThumbnailUrl());
                    } catch (Exception e) {
                        logger.warn("Failed to delete old thumbnail: {}", e.getMessage());
                    }
                }

                String thumbnailUrl = fileUploadService.uploadFile(thumbnail, "courses/thumbnails");
                course.setThumbnailUrl(thumbnailUrl);
                logger.info("New thumbnail uploaded: {}", thumbnailUrl);
            } else {
                // Keep existing thumbnail if no new one provided
                course.setThumbnailUrl(existingCourse.getThumbnailUrl());
            }

            // Upload new instructor photo if provided
            if (instructorPhoto != null && !instructorPhoto.isEmpty()) {
                logger.info("Uploading new instructor photo for course: {}", course.getTitle());
                
                // Delete old photo from Cloudinary (optional)
                if (existingCourse.getInstructorPhotoUrl() != null) {
                    try {
                        fileUploadService.deleteFile(existingCourse.getInstructorPhotoUrl());
                    } catch (Exception e) {
                        logger.warn("Failed to delete old instructor photo: {}", e.getMessage());
                    }
                }

                String photoUrl = fileUploadService.uploadFile(instructorPhoto, "instructors/photos");
                course.setInstructorPhotoUrl(photoUrl);
                logger.info("New instructor photo uploaded: {}", photoUrl);
            } else {
                // Keep existing photo if no new one provided
                course.setInstructorPhotoUrl(existingCourse.getInstructorPhotoUrl());
            }

            // Save updated course
            Course updatedCourse = courseRepository.save(course);
            logger.info("✅ Course updated successfully - ID: {}, Title: {}", 
                       updatedCourse.getId(), updatedCourse.getTitle());

            return updatedCourse;

        } catch (Exception e) {
            logger.error("❌ Failed to update course ID: {}", course.getId(), e);
            throw new RuntimeException("Failed to update course: " + e.getMessage(), e);
        }
    }

    // ==================== SAVE COURSE ====================

    /**
     * Save or update a course (used for status changes)
     * 
     * @param course Course entity to save
     * @return Saved course entity
     */
    public Course saveCourse(Course course) {
        try {
            course.setUpdatedAt(LocalDateTime.now());
            Course savedCourse = courseRepository.save(course);
            logger.info("✅ Course saved - ID: {}, Status: {}", 
                       savedCourse.getId(), savedCourse.getStatus());
            return savedCourse;
        } catch (Exception e) {
            logger.error("❌ Failed to save course ID: {}", course.getId(), e);
            throw new RuntimeException("Failed to save course: " + e.getMessage(), e);
        }
    }

    // ==================== RETRIEVE COURSES ====================

    /**
     * Get all courses for a specific instructor
     * 
     * @param instructorEmail Instructor's email address
     * @return List of courses
     */
    public List<Course> getCoursesByInstructor(String instructorEmail) {
        try {
            List<Course> courses = courseRepository.findByInstructorEmail(instructorEmail);
            logger.info("Retrieved {} courses for instructor: {}", courses.size(), instructorEmail);
            return courses;
        } catch (Exception e) {
            logger.error("Failed to retrieve courses for instructor: {}", instructorEmail, e);
            throw new RuntimeException("Failed to retrieve courses: " + e.getMessage(), e);
        }
    }

    /**
     * Get a course by ID
     * 
     * @param id Course ID
     * @return Course entity
     * @throws RuntimeException if course not found
     */
    public Course getCourseById(Long id) {
        return courseRepository.findById(id)
                .orElseThrow(() -> {
                    logger.error("Course not found with ID: {}", id);
                    return new RuntimeException("Course not found with ID: " + id);
                });
    }

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
    /**
     * Get all courses (for admin)
     * 
     * @return List of all courses
     */
    
    public List<Course> getAllCourses() {
        try {
            List<Course> courses = courseRepository.findAll();
            logger.info("Retrieved all {} courses", courses.size());
            return courses;
        } catch (Exception e) {
            logger.error("Failed to retrieve all courses", e);
            throw new RuntimeException("Failed to retrieve courses: " + e.getMessage(), e);
        }
    }

    // ==================== DELETE COURSE ====================

    /**
     * Delete a course and its associated files
     * 
     * @param id Course ID to delete
     */
    public void deleteCourse(Long id) {
        try {
            // Get course to delete associated files
            Course course = getCourseById(id);

            // Delete thumbnail from Cloudinary
            if (course.getThumbnailUrl() != null) {
                try {
                    fileUploadService.deleteFile(course.getThumbnailUrl());
                    logger.info("Deleted thumbnail for course: {}", course.getTitle());
                } catch (Exception e) {
                    logger.warn("Failed to delete thumbnail: {}", e.getMessage());
                }
            }

            // Delete instructor photo from Cloudinary
            if (course.getInstructorPhotoUrl() != null) {
                try {
                    fileUploadService.deleteFile(course.getInstructorPhotoUrl());
                    logger.info("Deleted instructor photo for course: {}", course.getTitle());
                } catch (Exception e) {
                    logger.warn("Failed to delete instructor photo: {}", e.getMessage());
                }
            }

            // Delete course from database
            courseRepository.deleteById(id);
            logger.info("✅ Course deleted successfully - ID: {}, Title: {}", id, course.getTitle());

        } catch (Exception e) {
            logger.error("❌ Failed to delete course ID: {}", id, e);
            throw new RuntimeException("Failed to delete course: " + e.getMessage(), e);
        }
    }

    // ==================== SEARCH & FILTER ====================

    /**
     * Get courses by category
     * 
     * @param category Course category
     * @return List of courses in the category
     */
    public List<Course> getCoursesByCategory(String category) {
        try {
            List<Course> courses = courseRepository.findByCategory(category);
            logger.info("Retrieved {} courses in category: {}", courses.size(), category);
            return courses;
        } catch (Exception e) {
            logger.error("Failed to retrieve courses for category: {}", category, e);
            throw new RuntimeException("Failed to retrieve courses: " + e.getMessage(), e);
        }
    }

    /**
     * Get courses by status
     * 
     * @param status Course status (DRAFT, PUBLISHED, etc.)
     * @return List of courses with the status
     */
    public List<Course> getCoursesByStatus(String status) {
        try {
            List<Course> courses = courseRepository.findByStatus(status);
            logger.info("Retrieved {} courses with status: {}", courses.size(), status);
            return courses;
        } catch (Exception e) {
            logger.error("Failed to retrieve courses for status: {}", status, e);
            throw new RuntimeException("Failed to retrieve courses: " + e.getMessage(), e);
        }
    }

    /**
     * Search courses by title or description
     * 
     * @param keyword Search keyword
     * @return List of matching courses
     */
    public List<Course> searchCourses(String keyword) {
        try {
            // Use custom query method
            List<Course> courses = courseRepository.searchByKeyword(keyword);
            logger.info("Found {} courses matching keyword: {}", courses.size(), keyword);
            return courses;
        } catch (Exception e) {
            logger.error("Failed to search courses with keyword: {}", keyword, e);
            throw new RuntimeException("Failed to search courses: " + e.getMessage(), e);
        }
    }

    // ==================== STATISTICS ====================

    /**
     * Get course count for an instructor
     * 
     * @param instructorEmail Instructor's email
     * @return Number of courses
     */
    public long getCourseCountByInstructor(String instructorEmail) {
        try {
            Long count = courseRepository.countByInstructorEmail(instructorEmail);
            logger.info("Instructor {} has {} courses", instructorEmail, count != null ? count : 0);
            return count != null ? count : 0;
        } catch (Exception e) {
            logger.error("Failed to count courses for instructor: {}", instructorEmail, e);
            return 0;
        }
    }

    /**
     * Check if course exists
     * 
     * @param id Course ID
     * @return true if exists, false otherwise
     */
    public boolean courseExists(Long id) {
        return courseRepository.existsById(id);
    }

    // ==================== VALIDATION ====================

    /**
     * Validate if instructor owns the course
     * 
     * @param courseId Course ID
     * @param instructorEmail Instructor's email
     * @return true if instructor owns the course
     */
    public boolean isInstructorOwner(Long courseId, String instructorEmail) {
        try {
            Course course = getCourseById(courseId);
            return course.getInstructorEmail().equals(instructorEmail);
        } catch (Exception e) {
            logger.error("Failed to validate course ownership - ID: {}, Email: {}", 
                        courseId, instructorEmail, e);
            return false;
        }
    }
}