package com.vp.repository;

import com.vp.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for Course entity
 * Provides database access methods for course operations
 */
@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    
    // ==================== BASIC QUERIES ====================
	@Query("SELECT c FROM Course c LEFT JOIN FETCH c.instructor WHERE c.status = 'LIVE'")
	List<Course> findLiveCoursesWithInstructor();
	
	@Query("SELECT c FROM Course c WHERE c.status IN ('APPROVED', 'LIVE') ORDER BY c.publishDate DESC")
	List<Course> findPublishedCourses();
    /**
     * Find courses by status
     */
    List<Course> findByStatus(String status);
    
    /**
     * Find courses by category
     */
    List<Course> findByCategory(String category);
    
    /**
     * Find courses by instructor email
     */
    List<Course> findByInstructorEmail(String instructorEmail);
    
    /**
     * Find courses by instructor ID
     */
    @Query("SELECT c FROM Course c WHERE c.instructor.id = :instructorId")
    List<Course> findByInstructorId(@Param("instructorId") Long instructorId);
    
    /**
     * Find courses by title (case-insensitive, partial match)
     */
    List<Course> findByTitleContainingIgnoreCase(String title);
    
    // ==================== SEARCH QUERIES ====================
    
    /**
     * Search courses by keyword in title, description, or instructor email
     */
    @Query("SELECT c FROM Course c WHERE " +
           "LOWER(c.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.instructorEmail) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.category) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Course> searchByKeyword(@Param("keyword") String keyword);
    
    /**
     * Search courses by multiple filters
     */
    @Query("SELECT c FROM Course c WHERE " +
           "(:status IS NULL OR c.status = :status) AND " +
           "(:category IS NULL OR c.category = :category) AND " +
           "(:instructorEmail IS NULL OR c.instructorEmail = :instructorEmail)")
    List<Course> findByFilters(
        @Param("status") String status,
        @Param("category") String category,
        @Param("instructorEmail") String instructorEmail
    );
    
    // ==================== STATISTICS QUERIES ====================
    
    /**
     * Count courses by status
     */
    long countByStatus(String status);
    
    /**
     * Count courses by category
     */
    long countByCategory(String category);
    
    /**
     * Count courses by instructor ID
     */
    @Query("SELECT COUNT(c) FROM Course c WHERE c.instructor.id = :instructorId")
    long countByInstructorId(@Param("instructorId") Long instructorId);
    
    /**
     * Count courses by instructor email
     */
    long countByInstructorEmail(String instructorEmail);
    
    // ==================== ADVANCED QUERIES ====================
    
    
    
    /**
     * Find pending courses (PENDING status)
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'PENDING' ORDER BY c.createdAt ASC")
    List<Course> findPendingCourses();
    
    /**
     * Find draft courses (DRAFT status)
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'DRAFT' ORDER BY c.updatedAt DESC")
    List<Course> findDraftCourses();
    
    /**
     * Find top-rated courses
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'APPROVED' ORDER BY c.averageRating DESC")
    List<Course> findTopRatedCourses();
    
    /**
     * Find most enrolled courses
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'APPROVED' ORDER BY c.studentsEnrolled DESC")
    List<Course> findMostEnrolledCourses();
    
    /**
     * Find recently added courses
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'APPROVED' ORDER BY c.publishDate DESC")
    List<Course> findRecentCourses();
    
    /**
     * Find courses by price range
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'APPROVED' AND c.price BETWEEN :minPrice AND :maxPrice")
    List<Course> findByPriceRange(@Param("minPrice") Double minPrice, @Param("maxPrice") Double maxPrice);
    
    /**
     * Find courses by level
     */
    List<Course> findByLevel(String level);
    
    /**
     * Find courses by language
     */
    List<Course> findByLanguage(String language);
    
    // ==================== CUSTOM QUERIES FOR ADMIN ====================
    
    /**
     * Get all courses with instructor details (for admin dashboard)
     */
    @Query("SELECT c FROM Course c LEFT JOIN FETCH c.instructor ORDER BY c.createdAt DESC")
    List<Course> findAllWithInstructor();
    
    /**
     * Get courses awaiting approval
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'PENDING' ORDER BY c.createdAt ASC")
    List<Course> findCoursesAwaitingApproval();
    
    /**
     * Get recently approved courses
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'APPROVED' AND c.publishDate IS NOT NULL ORDER BY c.publishDate DESC")
    List<Course> findRecentlyApprovedCourses();
    
    /**
     * Get rejected courses
     */
    @Query("SELECT c FROM Course c WHERE c.status = 'REJECTED' ORDER BY c.updatedAt DESC")
    List<Course> findRejectedCourses();
}