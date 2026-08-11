package com.vp.controller.admin;

import com.vp.entity.User;
import com.vp.service.auth.UserService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.regex.Pattern;

/**
 * Controller for admin user management operations
 */
@Controller
@RequestMapping("/admin/users")
public class AdminUserController {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminUserController.class);
    
    private static final String SESSION_USER_ID = "userId";
    private static final String REDIRECT_LOGIN = "redirect:/login";
    private static final String REDIRECT_USERS = "redirect:/admin/users";
    private static final String ATTR_ERROR = "error";
    private static final String ATTR_SUCCESS = "success";
    private static final String ATTR_USER = "user";
    
    private static final String ACTION_ACTIVATE = "activate";
    private static final String ACTION_DEACTIVATE = "deactivate";
    private static final String ACTION_DELETE = "delete";
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final String PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
    private static final int TEMP_PASSWORD_LENGTH = 12;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    // ==================== HELPER METHODS ====================

    /**
     * Get authenticated user from session
     */
    private Optional<User> getAuthenticatedUser(HttpSession session) {
        Long userId = (Long) session.getAttribute(SESSION_USER_ID);
        if (userId == null) {
            return Optional.empty();
        }
        User user = userService.findById(userId);
        return Optional.ofNullable(user);
    }

    /**
     * Check if user has admin role
     */
    private boolean isAdmin(User user) {
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    /**
     * Validate admin access
     */
    private Optional<User> validateAdminAccess(HttpSession session) {
        Optional<User> userOpt = getAuthenticatedUser(session);
        
        if (userOpt.isEmpty() || !isAdmin(userOpt.get())) {
            return Optional.empty();
        }
        
        return userOpt;
    }

    /**
     * Add common user attributes to model
     */
    private void populateUserModel(Model model, User user) {
        model.addAttribute(ATTR_USER, user);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("email", user.getEmail());
        model.addAttribute("role", "Admin");
        model.addAttribute("currentPage", "users");
    }
    
    /**
     * Validate user input
     */
    private void validateUserInput(String fullName, String email, String role) {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }
        if (fullName.length() > 100) {
            throw new IllegalArgumentException("Full name must not exceed 100 characters");
        }
        if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
            throw new IllegalArgumentException("Valid email is required");
        }
        if (email.length() > 255) {
            throw new IllegalArgumentException("Email must not exceed 255 characters");
        }
        try {
            User.Role.valueOf(role);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid role: " + role);
        }
    }
    
    /**
     * Generate secure temporary password
     */
    private String generateSecurePassword() {
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(TEMP_PASSWORD_LENGTH);
        
        for (int i = 0; i < TEMP_PASSWORD_LENGTH; i++) {
            int index = random.nextInt(PASSWORD_CHARS.length());
            password.append(PASSWORD_CHARS.charAt(index));
        }
        
        return password.toString();
    }
    
    /**
     * Escape CSV field to prevent injection attacks
     */
    private String escapeCsvField(String field) {
        if (field == null) {
            return "";
        }
        
        // Prevent CSV injection by escaping fields starting with dangerous characters
        String trimmed = field.trim();
        if (trimmed.matches("^[=+\\-@].*")) {
            trimmed = "'" + trimmed;
        }
        
        // Escape quotes and wrap in quotes
        return "\"" + trimmed.replace("\"", "\"\"") + "\"";
    }

    // ==================== USER MANAGEMENT PAGES ====================

    /**
     * User Management - List all users
     */
    @GetMapping("")
    public String listUsers(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session);
            if (userOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Please login as an administrator.");
                return REDIRECT_LOGIN;
            }

            User adminUser = userOpt.get();
            populateUserModel(model, adminUser);

            // Fetch all users
            List<User> users = userService.findAllUsers();
            long totalUsers = users.size();
            long activeUsers = users.stream().filter(u -> Boolean.TRUE.equals(u.getIsActive())).count();
            long inactiveUsers = totalUsers - activeUsers;

            model.addAttribute("users", users);
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("activeUsers", activeUsers);
            model.addAttribute("inactiveUsers", inactiveUsers);

            logger.info("User management page loaded for admin: {}", adminUser.getEmail());

            return "admin/users";

        } catch (Exception e) {
            logger.error("Failed to load users page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load users");
            return "redirect:/admin/dashboard";
        }
    }

    /**
     * Get user by ID (AJAX endpoint)
     * Returns user details in JSON format for the view panel
     */
    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUserById(@PathVariable Long id, HttpSession session) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                logger.warn("Unauthorized access attempt to user details: {}", id);
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
            
            User user = userService.findById(id);
            if (user == null) {
                logger.warn("User not found: {}", id);
                return ResponseEntity.notFound().build();
            }
            
            // Build response with user details
            Map<String, Object> response = new HashMap<>();
            response.put("id", user.getId());
            response.put("fullName", user.getFullName());
            response.put("email", user.getEmail());
            response.put("role", user.getRole().toString());
            response.put("active", user.getIsActive());
            response.put("profilePictureUrl", user.getProfilePictureUrl());
            response.put("createdAt", user.getCreatedAt() != null ? user.getCreatedAt().toString() : null);
            response.put("lastLoginAt", user.getLastLoginAt() != null ? user.getLastLoginAt().toString() : null);
            
            logger.info("User details retrieved: {} by admin: {}", id, adminOpt.get().getEmail());
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("Failed to fetch user by ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Add new user (POST endpoint)
     */
    @PostMapping("/add")
    public String addUser(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("role") String role,
            @RequestParam(value = "active", required = false) String active,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Unauthorized access");
                return REDIRECT_LOGIN;
            }
            
            // Validate input
            validateUserInput(fullName, email, role);
            
            // Check if email already exists
            if (userService.existsByEmail(email)) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Email already exists");
                return REDIRECT_USERS;
            }
            
            // Generate secure temporary password
            String tempPassword = generateSecurePassword();
            
            // Create new user
            User newUser = new User();
            newUser.setFullName(fullName.trim());
            newUser.setEmail(email.trim().toLowerCase());
            newUser.setRole(User.Role.valueOf(role));
            newUser.setIsActive(active != null);
            newUser.setPassword(passwordEncoder.encode(tempPassword));
            
            userService.save(newUser);
            
            logger.info("New user created: {} by admin: {}", email, adminOpt.get().getEmail());
            redirectAttributes.addFlashAttribute(ATTR_SUCCESS, 
                "User created successfully. Temporary password: " + tempPassword);
            
            // TODO: Send welcome email with temporary password via email service
            // emailService.sendWelcomeEmail(email, tempPassword);
            
            return REDIRECT_USERS;
            
        } catch (IllegalArgumentException e) {
            logger.warn("Invalid input for user creation: {}", e.getMessage());
            redirectAttributes.addFlashAttribute(ATTR_ERROR, e.getMessage());
            return REDIRECT_USERS;
        } catch (Exception e) {
            logger.error("Failed to create user", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to create user: " + e.getMessage());
            return REDIRECT_USERS;
        }
    }

    /**
     * Edit user page
     */
    @GetMapping("/edit/{id}")
    public String editUserPage(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Unauthorized access");
                return REDIRECT_LOGIN;
            }
            
            User user = userService.findById(id);
            if (user == null) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "User not found");
                return REDIRECT_USERS;
            }
            
            populateUserModel(model, adminOpt.get());
            model.addAttribute("editUser", user);
            
            logger.info("Edit user page loaded for user: {} by admin: {}", id, adminOpt.get().getEmail());
            
            return "admin/user-edit";
            
        } catch (Exception e) {
            logger.error("Failed to load edit user page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load user");
            return REDIRECT_USERS;
        }
    }

    /**
     * Update user (POST endpoint)
     */
    @PostMapping("/update/{id}")
    public String updateUser(
            @PathVariable Long id,
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("role") String role,
            @RequestParam(value = "active", required = false) String active,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Unauthorized access");
                return REDIRECT_LOGIN;
            }
            
            User user = userService.findById(id);
            if (user == null) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "User not found");
                return REDIRECT_USERS;
            }
            
            // Validate input
            validateUserInput(fullName, email, role);
            
            // Check if email changed and already exists
            String normalizedEmail = email.trim().toLowerCase();
            if (!user.getEmail().equalsIgnoreCase(normalizedEmail)) {
                if (userService.existsByEmail(normalizedEmail)) {
                    redirectAttributes.addFlashAttribute(ATTR_ERROR, "Email already exists");
                    return "redirect:/admin/users/edit/" + id;
                }
            }
            
            // Prevent changing own admin role
            if (user.getId().equals(adminOpt.get().getId()) && 
                !role.equals(User.Role.ADMIN.toString())) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, 
                    "Cannot change your own admin role");
                return "redirect:/admin/users/edit/" + id;
            }
            
            user.setFullName(fullName.trim());
            user.setEmail(normalizedEmail);
            user.setRole(User.Role.valueOf(role));
            user.setIsActive(active != null);
            
            userService.save(user);
            
            logger.info("User updated: {} by admin: {}", id, adminOpt.get().getEmail());
            redirectAttributes.addFlashAttribute(ATTR_SUCCESS, "User updated successfully");
            
            return REDIRECT_USERS;
            
        } catch (IllegalArgumentException e) {
            logger.warn("Invalid input for user update: {}", e.getMessage());
            redirectAttributes.addFlashAttribute(ATTR_ERROR, e.getMessage());
            return "redirect:/admin/users/edit/" + id;
        } catch (Exception e) {
            logger.error("Failed to update user: {}", id, e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to update user: " + e.getMessage());
            return "redirect:/admin/users/edit/" + id;
        }
    }

    /**
     * Delete user (DELETE endpoint)
     */
    @PostMapping("/delete/{id}")
    public String deleteUser(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Unauthorized access");
                return REDIRECT_LOGIN;
            }
            
            User user = userService.findById(id);
            if (user == null) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "User not found");
                return REDIRECT_USERS;
            }
            
            // Prevent self-deletion
            if (user.getId().equals(adminOpt.get().getId())) {
                redirectAttributes.addFlashAttribute(ATTR_ERROR, "Cannot delete your own account");
                return REDIRECT_USERS;
            }
            
            userService.deleteById(id);
            
            logger.info("User deleted: {} by admin: {}", id, adminOpt.get().getEmail());
            redirectAttributes.addFlashAttribute(ATTR_SUCCESS, "User deleted successfully");
            
            return REDIRECT_USERS;
            
        } catch (Exception e) {
            logger.error("Failed to delete user: {}", id, e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to delete user: " + e.getMessage());
            return REDIRECT_USERS;
        }
    }

    /**
     * Bulk action on users (AJAX endpoint)
     * Supports: activate, deactivate, delete
     */
    @PostMapping("/bulk-action")
    @ResponseBody
    @Transactional
    public ResponseEntity<Map<String, Object>> bulkAction(
            @RequestParam("action") String action,
            @RequestParam("userIds") List<Long> userIds,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Unauthorized");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            if (userIds == null || userIds.isEmpty()) {
                response.put("success", false);
                response.put("message", "No users selected");
                return ResponseEntity.badRequest().body(response);
            }
            
            if (!isValidAction(action)) {
                response.put("success", false);
                response.put("message", "Invalid action: " + action);
                return ResponseEntity.badRequest().body(response);
            }
            
            int successCount = 0;
            List<String> errors = new ArrayList<>();
            
            for (Long userId : userIds) {
                try {
                    User user = userService.findById(userId);
                    if (user == null) {
                        errors.add("User " + userId + " not found");
                        continue;
                    }
                    
                    // Prevent action on self
                    if (user.getId().equals(adminOpt.get().getId())) {
                        errors.add("Cannot perform action on your own account");
                        continue;
                    }
                    
                    boolean actionPerformed = performBulkAction(action, user);
                    if (actionPerformed) {
                        successCount++;
                    }
                    
                } catch (Exception e) {
                    logger.error("Failed to process user {} in bulk action", userId, e);
                    errors.add("Failed to process user " + userId + ": " + e.getMessage());
                }
            }
            
            logger.info("Bulk action '{}' performed on {} users by admin: {}", 
                action, successCount, adminOpt.get().getEmail());
            
            response.put("success", true);
            response.put("message", successCount + " user(s) " + action + "d successfully");
            response.put("successCount", successCount);
            response.put("totalCount", userIds.size());
            if (!errors.isEmpty()) {
                response.put("errors", errors);
            }
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("Failed to perform bulk action", e);
            response.put("success", false);
            response.put("message", "Failed to perform action: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * Check if action is valid
     */
    private boolean isValidAction(String action) {
        return ACTION_ACTIVATE.equalsIgnoreCase(action) ||
               ACTION_DEACTIVATE.equalsIgnoreCase(action) ||
               ACTION_DELETE.equalsIgnoreCase(action);
    }
    
    /**
     * Perform bulk action on a single user
     */
    private boolean performBulkAction(String action, User user) {
        switch (action.toLowerCase()) {
            case ACTION_ACTIVATE:
                user.setIsActive(true);
                userService.save(user);
                return true;
                
            case ACTION_DEACTIVATE:
                user.setIsActive(false);
                userService.save(user);
                return true;
                
            case ACTION_DELETE:
                userService.deleteById(user.getId());
                return true;
                
            default:
                return false;
        }
    }

    /**
     * Export users (CSV download)
     */
    @GetMapping("/export")
    public ResponseEntity<String> exportUsers(HttpSession session) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session);
            if (adminOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
            
            List<User> users = userService.findAllUsers();
            
            // Build CSV with proper escaping
            StringBuilder csv = new StringBuilder();
            csv.append("ID,Full Name,Email,Role,Status,Created At,Last Login\n");
            
            for (User user : users) {
                csv.append(user.getId()).append(",");
                csv.append(escapeCsvField(user.getFullName())).append(",");
                csv.append(escapeCsvField(user.getEmail())).append(",");
                csv.append(escapeCsvField(user.getRole().toString())).append(",");
                csv.append(escapeCsvField(user.getIsActive() ? "Active" : "Inactive")).append(",");
                csv.append(escapeCsvField(user.getCreatedAt() != null ? user.getCreatedAt().toString() : "")).append(",");
                csv.append(escapeCsvField(user.getLastLoginAt() != null ? user.getLastLoginAt().toString() : "")).append("\n");
            }
            
            logger.info("Users exported by admin: {}", adminOpt.get().getEmail());
            
            return ResponseEntity.ok()
                .header("Content-Type", "text/csv; charset=utf-8")
                .header("Content-Disposition", "attachment; filename=\"users.csv\"")
                .body(csv.toString());
            
        } catch (Exception e) {
            logger.error("Failed to export users", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}