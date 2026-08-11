package com.vp.repository;

import com.vp.entity.User;
import com.vp.entity.User.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Find user by email
     */
    Optional<User> findByEmail(String email);

    /**
     * Check if email exists
     */
    boolean existsByEmail(String email);

    /**
     * Find users by role
     */
    List<User> findByRole(Role role);

    /**
     * Find active/inactive users
     */
    List<User> findByIsActive(Boolean isActive);

    /**
     * Find users by email verification status
     */
    List<User> findByEmailVerified(Boolean emailVerified);

    /**
     * Find user by verification token
     */
    Optional<User> findByVerificationToken(String verificationToken);

    /**
     * Search users by name or email
     */
    List<User> findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(String fullName, String email);

    /**
     * Find users by role and active status
     */
    List<User> findByRoleAndIsActive(Role role, Boolean isActive);

    /**
     * Count users by role
     */
    long countByRole(Role role);

    /**
     * Count users by active status
     */
    long countByIsActive(Boolean isActive);

    /**
     * Find all users ordered by creation date
     */
    List<User> findAllByOrderByCreatedAtDesc();
}