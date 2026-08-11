package com.vp.service.admin;

import com.vp.entity.Course;
import com.vp.repository.CourseRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class CourseService {
    
    private static final Logger logger = LoggerFactory.getLogger(CourseService.class);
    
    @Autowired
    private CourseRepository courseRepository;
    
    /**
     * Get all courses
     */
    public List<Course> getAllCourses() {
        logger.info("Fetching all courses");
        return courseRepository.findAll();
    }
    
    /**
     * Get courses by status
     */
    public List<Course> getCoursesByStatus(String status) {
        logger.info("Fetching courses with status: {}", status);
        return courseRepository.findByStatus(status);
    }
    
    /**
     * Get course by ID
     */
    public Optional<Course> getCourseById(Long id) {
        logger.info("Fetching course with ID: {}", id);
        return courseRepository.findById(id);
    }
    
    /**
     * Approve a course - sets status to LIVE directly
     */
    public boolean approveCourse(Long courseId) {
        try {
            logger.info("Attempting to approve course ID: {}", courseId);
            
            Optional<Course> courseOpt = courseRepository.findById(courseId);
            if (courseOpt.isEmpty()) {
                logger.warn("Course not found with ID: {}", courseId);
                return false;
            }
            
            Course course = courseOpt.get();
            course.setStatus("LIVE"); // ✅ LIVE directly (no APPROVED step)
            course.setUpdatedAt(LocalDateTime.now());
            
            courseRepository.save(course);
            logger.info("Course ID {} is now LIVE", courseId);
            return true;
            
        } catch (Exception e) {
            logger.error("Error approving course ID {}: {}", courseId, e.getMessage());
            return false;
        }
    }
    
    /**
     * Reject a course with reason
     */
    public boolean rejectCourse(Long courseId, String reason) {
        try {
            logger.info("Attempting to reject course ID: {} with reason: {}", courseId, reason);
            
            Optional<Course> courseOpt = courseRepository.findById(courseId);
            if (courseOpt.isEmpty()) {
                logger.warn("Course not found with ID: {}", courseId);
                return false;
            }
            
            Course course = courseOpt.get();
            course.setStatus("REJECTED");
            course.setUpdatedAt(LocalDateTime.now());
            
            courseRepository.save(course);
            logger.info("Course ID {} rejected successfully", courseId);
            return true;
            
        } catch (Exception e) {
            logger.error("Error rejecting course ID {}: {}", courseId, e.getMessage());
            return false;
        }
    }
    
    /**
     * Search courses by keyword (title, description, instructor, category)
     */
    public List<Course> searchCourses(String keyword) {
        logger.info("Searching courses with keyword: {}", keyword);
        return courseRepository.searchByKeyword(keyword);
    }
    
    /**
     * Get pending courses (DRAFT status)
     */
    public List<Course> getPendingCourses() {
        logger.info("Fetching pending courses");
        return courseRepository.findByStatus("DRAFT");
    }
    
    /**
     * Get live courses
     */
    public List<Course> getApprovedCourses() {
        logger.info("Fetching live courses");
        return courseRepository.findByStatus("LIVE"); // ✅ LIVE
    }
    
    /**
     * Get rejected courses
     */
    public List<Course> getRejectedCourses() {
        logger.info("Fetching rejected courses");
        return courseRepository.findByStatus("REJECTED");
    }
    
    /**
     * Get all courses with instructor details (for admin dashboard)
     */
    public List<Course> getAllCoursesWithInstructor() {
        logger.info("Fetching all courses with instructor details");
        return courseRepository.findAllWithInstructor();
    }
    
    /**
     * Get course statistics
     */
    public Map<String, Long> getCourseStatistics() {
        logger.info("Calculating course statistics");
        
        Map<String, Long> stats = new HashMap<>();
        stats.put("total", courseRepository.count());
        stats.put("pending", courseRepository.countByStatus("DRAFT"));
        stats.put("approved", courseRepository.countByStatus("LIVE")); // ✅ LIVE
        stats.put("rejected", courseRepository.countByStatus("REJECTED"));
        
        return stats;
    }
}