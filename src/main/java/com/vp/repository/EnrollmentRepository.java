package com.vp.repository;

import com.vp.entity.Enrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    boolean existsByUserIdAndCourseId(Long userId, Long courseId);
    Optional<Enrollment> findByRazorpayOrderId(String orderId);
    boolean existsByUserIdAndCourseIdAndPaymentStatus(Long userId, Long courseId, String paymentStatus);
    Optional<Enrollment> findTopByUserIdOrderByEnrolledAtDesc(Long userId);
    // PENDING order dobara use karne ke liye
    Optional<Enrollment> findByUserIdAndCourseIdAndPaymentStatus(
        Long userId, Long courseId, String paymentStatus);
}