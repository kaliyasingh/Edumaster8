package com.vp.repository;

import com.vp.entity.Instructor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Instructor entity
 * Provides custom queries for instructor approval workflow
 */
@Repository
public interface InstructorRepository extends JpaRepository<Instructor, Long> {

    /**
     * Find instructor by email
     */
    Optional<Instructor> findByEmail(String email);

    /**
     * Check if email already exists
     */
    boolean existsByEmail(String email);

    /**
     * Find all pending instructors (not verified and not rejected)
     * These are instructors waiting for admin approval
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "(i.instructorVerified = false OR i.instructorVerified IS NULL) " +
           "AND i.rejectedAt IS NULL " +
           "ORDER BY i.createdAt DESC")
    List<Instructor> findPendingInstructors();

    /**
     * Find all active/approved instructors
     * These are instructors who have been approved by admin
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "i.instructorVerified = true " +
           "AND i.isActive = true " +
           "ORDER BY i.verifiedAt DESC")
    List<Instructor> findActiveInstructors();

    /**
     * Find all rejected instructors
     */
    List<Instructor> findByRejectedAtIsNotNull();

    /**
     * Count pending instructors
     */
    @Query("SELECT COUNT(i) FROM Instructor i WHERE " +
           "(i.instructorVerified = false OR i.instructorVerified IS NULL) " +
           "AND i.rejectedAt IS NULL")
    long countPendingInstructors();

    /**
     * Find instructors by specialization
     */
    List<Instructor> findBySpecializationContainingIgnoreCase(String specialization);

    /**
     * Find top-rated instructors
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "i.instructorVerified = true " +
           "AND i.isActive = true " +
           "ORDER BY i.averageRating DESC")
    List<Instructor> findTopRatedInstructors();

    /**
     * Find instructors with most students
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "i.instructorVerified = true " +
           "AND i.isActive = true " +
           "ORDER BY i.totalStudents DESC")
    List<Instructor> findMostPopularInstructors();

    /**
     * Find instructors by verification status
     */
    List<Instructor> findByInstructorVerified(Boolean verified);

    /**
     * Find instructors with public profiles
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "i.profilePublic = true " +
           "AND i.instructorVerified = true " +
           "AND i.isActive = true")
    List<Instructor> findPublicInstructors();

    /**
     * Search instructors by name or specialization
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "i.instructorVerified = true " +
           "AND i.isActive = true " +
           "AND (LOWER(i.fullName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) " +
           "OR LOWER(i.specialization) LIKE LOWER(CONCAT('%', :searchTerm, '%')))")
    List<Instructor> searchInstructors(String searchTerm);

    /**
     * Find instructors with minimum rating
     */
    @Query("SELECT i FROM Instructor i WHERE " +
           "i.instructorVerified = true " +
           "AND i.isActive = true " +
           "AND i.averageRating >= :minRating " +
           "ORDER BY i.averageRating DESC")
    List<Instructor> findByMinimumRating(Double minRating);

    /**
     * Count active instructors
     */
    @Query("SELECT COUNT(i) FROM Instructor i WHERE " +
           "i.instructorVerified = true AND i.isActive = true")
    long countActiveInstructors();

    /**
     * Count rejected instructors
     */
    @Query("SELECT COUNT(i) FROM Instructor i WHERE i.rejectedAt IS NOT NULL")
    long countRejectedInstructors();
}