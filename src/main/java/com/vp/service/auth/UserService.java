package com.vp.service.auth;

import com.vp.entity.Instructor;
import com.vp.entity.User;
import com.vp.entity.User.Role;
import com.vp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Register a new user
     */
    public User registerUser(User user) {
        // Encrypt password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        
        // Set default values
        if (user.getRole() == null) {
            user.setRole(Role.STUDENT);
        }
        if (user.getIsActive() == null) {
            user.setIsActive(true);
        }
        if (user.getEmailVerified() == null) {
            user.setEmailVerified(false);
        }
        
        return userRepository.save(user);
    }

    /**
     * Authenticate user with email, password, and role
     */
    public User authenticateUser(String email, String password, Role role) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        
        if (userOpt.isEmpty()) {
            return null;
        }
        
        User user = userOpt.get();
        
        // Check if password matches
        if (!passwordEncoder.matches(password, user.getPassword())) {
            return null;
        }
        
        // Check if role matches
        if (user.getRole() != role) {
            return null;
        }
        
        // Check if account is active
        if (!user.getIsActive()) {
            return null;
        }
        
        return user;
    }

    /**
     * Find user by email
     */
    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }
    
    /**
     * Get user by email - Returns Optional for null-safe handling
     * ✅ NEW METHOD: Used by admin controllers to fetch instructor details
     */
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Check if email exists
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Find user by ID
     */
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    /**
     * Save or update user
     * This is the generic save method that can be used for both create and update
     */
    public User save(User user) {
        return userRepository.save(user);
    }

    /**
     * Update user profile
     * Alias for save() method for backward compatibility
     */
    public User updateUser(User user) {
        return save(user);
    }

    /**
     * Update password
     */
    public void updatePassword(String email, String newPassword) {
        User user = findByEmail(email);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
        }
    }
    
    /**
     * Update password by user ID
     */
    public void updatePassword(Long userId, String newPassword) {
        User user = findById(userId);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
        }
    }

    /**
     * Update last login time
     */
    public void updateLastLogin(Long userId) {
        User user = findById(userId);
        if (user != null) {
            user.setLastLoginAt(LocalDateTime.now());
            userRepository.save(user);
        }
    }

    /**
     * Verify email
     */
    public boolean verifyEmail(String email) {
        User user = findByEmail(email);
        if (user != null) {
            user.setEmailVerified(true);
            user.setVerificationToken(null);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    /**
     * Deactivate user account
     */
    public void deactivateUser(Long userId) {
        User user = findById(userId);
        if (user != null) {
            user.setIsActive(false);
            userRepository.save(user);
        }
    }

    /**
     * Activate user account
     */
    public void activateUser(Long userId) {
        User user = findById(userId);
        if (user != null) {
            user.setIsActive(true);
            userRepository.save(user);
        }
    }

    /**
     * Get all users by role
     */
    public List<User> findByRole(Role role) {
        return userRepository.findByRole(role);
    }

    /**
     * Get all active users
     */
    public List<User> findAllActiveUsers() {
        return userRepository.findByIsActive(true);
    }

    /**
     * Get all users
     */
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Delete user
     * Alias for deleteById() for backward compatibility
     */
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }
    
    /**
     * Delete user by ID
     * This matches the repository method name
     */
    public void deleteById(Long userId) {
        userRepository.deleteById(userId);
    }

    /**
     * Update user role
     */
    public void updateUserRole(Long userId, Role newRole) {
        User user = findById(userId);
        if (user != null) {
            user.setRole(newRole);
            userRepository.save(user);
        }
    }

    /**
     * Update profile picture
     */
    public void updateProfilePicture(Long userId, String profilePictureUrl) {
        User user = findById(userId);
        if (user != null) {
            user.setProfilePictureUrl(profilePictureUrl);
            userRepository.save(user);
        }
    }

    /**
     * Search users by name or email
     */
    public List<User> searchUsers(String keyword) {
        return userRepository.findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(keyword, keyword);
    }

    /**
     * Count users by role
     */
    public long countByRole(Role role) {
        return userRepository.countByRole(role);
    }

    /**
     * Count total active users
     */
    public long countActiveUsers() {
        return userRepository.countByIsActive(true);
    }
    
    /**
     * Count total inactive users
     */
    public long countInactiveUsers() {
        return userRepository.countByIsActive(false);
    }
    
    /**
     * Count total users
     */
    public long countAllUsers() {
        return userRepository.count();
    }
    
    /**
     * Create user with encoded password
     * Helper method for admin user creation
     */
    public User createUserWithEncodedPassword(User user, String plainPassword) {
        user.setPassword(passwordEncoder.encode(plainPassword));
        return userRepository.save(user);
    }
    
    /**
     * Bulk activate users
     */
    @Transactional
    public int bulkActivateUsers(List<Long> userIds) {
        int count = 0;
        for (Long userId : userIds) {
            User user = findById(userId);
            if (user != null) {
                user.setIsActive(true);
                userRepository.save(user);
                count++;
            }
        }
        return count;
    }
    
    /**
     * Bulk deactivate users
     */
    @Transactional
    public int bulkDeactivateUsers(List<Long> userIds) {
        int count = 0;
        for (Long userId : userIds) {
            User user = findById(userId);
            if (user != null) {
                user.setIsActive(false);
                userRepository.save(user);
                count++;
            }
        }
        return count;
    }
    
    /**
     * Bulk delete users
     */
    @Transactional
    public int bulkDeleteUsers(List<Long> userIds) {
        int count = 0;
        for (Long userId : userIds) {
            try {
                userRepository.deleteById(userId);
                count++;
            } catch (Exception e) {
                // Log error but continue with other deletions
            }
        }
        return count;
    }
    
    // ==================== INSTRUCTOR-SPECIFIC METHODS ====================
    
    /**
     * Find all instructors
     * Returns all users with INSTRUCTOR role cast to Instructor entity
     * ✅ REQUIRED by AdminInstructorController
     */
    public List<Instructor> findAllInstructors() {
        // Get all users with INSTRUCTOR role and cast to Instructor
        return userRepository.findByRole(Role.INSTRUCTOR).stream()
            .filter(user -> user instanceof Instructor)
            .map(user -> (Instructor) user)
            .toList();
    }
}