package com.vp.controller.admin;

import com.vp.entity.User;
import com.vp.service.auth.UserService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * Controller for admin dashboard and main navigation pages
 * Course management has been moved to AdminCourseController
 * Instructor management has been moved to AdminInstructorController
 */
@Controller
@RequestMapping("/admin")
public class AdminDashboardController {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminDashboardController.class);
    
    private static final String SESSION_USER_ID = "userId";
    private static final String REDIRECT_LOGIN = "redirect:/login";
    private static final String ATTR_ERROR = "error";
    private static final String ATTR_USER = "user";
    
    @Autowired
    private UserService userService;

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
     * Add common user attributes to model
     */
    private void populateUserModel(Model model, User user, String currentPage) {
        model.addAttribute(ATTR_USER, user);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("email", user.getEmail());
        model.addAttribute("role", "Admin");
        model.addAttribute("currentPage", currentPage);
    }

    /**
     * Handle unauthorized access
     */
    private String redirectToLogin(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(ATTR_ERROR, "Please login as an administrator.");
        return REDIRECT_LOGIN;
    }

    /**
     * Validate admin access for all methods
     */
    private Optional<User> validateAdminAccess(HttpSession session, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = getAuthenticatedUser(session);
        
        if (userOpt.isEmpty() || !isAdmin(userOpt.get())) {
            return Optional.empty();
        }
        
        return userOpt;
    }

    // ==================== DASHBOARD PAGES ====================

    /**
     * Main Dashboard Page
     */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }

            User user = userOpt.get();
            populateUserModel(model, user, "dashboard");

            // Get user statistics
            long totalStudents = userService.countByRole(User.Role.STUDENT);
            long totalInstructors = userService.countByRole(User.Role.INSTRUCTOR);
            long totalUsers = userService.countActiveUsers();

            model.addAttribute("userName", user.getFullName());
            model.addAttribute("userEmail", user.getEmail());
            model.addAttribute("totalStudents", totalStudents);
            model.addAttribute("totalInstructors", totalInstructors);
            model.addAttribute("totalUsers", totalUsers);

            logger.info("Admin dashboard loaded for: {}", user.getEmail());

            return "admin/dashboard";

        } catch (Exception e) {
            logger.error("Failed to load admin dashboard", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load dashboard");
            return REDIRECT_LOGIN;
        }
    }

    // ==================== NOTE: INSTRUCTOR MANAGEMENT MOVED ====================
    // The /admin/instructors endpoint has been moved to AdminInstructorController
    // This prevents duplicate route mapping errors
    
    /**
     * Transactions Page
     */
    @GetMapping("/transactions")
    public String transactions(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "transactions");
            
            logger.info("Transactions page loaded for admin: {}", user.getEmail());
            
            return "admin/transactions";
            
        } catch (Exception e) {
            logger.error("Failed to load transactions page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load transactions");
            return "redirect:/admin/dashboard";
        }
    }

    /**
     * Payouts Page
     */
    @GetMapping("/payouts")
    public String payouts(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "payouts");
            
            logger.info("Payouts page loaded for admin: {}", user.getEmail());
            
            return "admin/payouts";
            
        } catch (Exception e) {
            logger.error("Failed to load payouts page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load payouts");
            return "redirect:/admin/dashboard";
        }
    }

    /**
     * Refunds Page
     */
    @GetMapping("/refunds")
    public String refunds(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "refunds");
            
            logger.info("Refunds page loaded for admin: {}", user.getEmail());
            
            return "admin/refunds";
            
        } catch (Exception e) {
            logger.error("Failed to load refunds page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load refunds");
            return "redirect:/admin/dashboard";
        }
    }

    /**
     * Settings Page
     */
    @GetMapping("/settings")
    public String settings(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "settings");
            
            logger.info("Settings page loaded for admin: {}", user.getEmail());
            
            return "admin/settings";
            
        } catch (Exception e) {
            logger.error("Failed to load settings page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load settings");
            return "redirect:/admin/dashboard";
        }
    }

    /**
     * Audit Logs Page
     */
    @GetMapping("/audit-logs")
    public String auditLogs(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "audit-logs");
            
            logger.info("Audit logs page loaded for admin: {}", user.getEmail());
            
            return "admin/audit-logs";
            
        } catch (Exception e) {
            logger.error("Failed to load audit logs page", e);
            redirectAttributes.addFlashAttribute(ATTR_ERROR, "Failed to load audit logs");
            return "redirect:/admin/dashboard";
        }
    }

    /**
     * Logout Confirmation Page
     */
    @GetMapping("/logout-confirm")
    public String logoutConfirm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = getAuthenticatedUser(session);
            if (userOpt.isEmpty()) {
                return REDIRECT_LOGIN;
            }
            
            User user = userOpt.get();
            model.addAttribute(ATTR_USER, user);
            
            logger.info("Logout confirmation page loaded for admin: {}", user.getEmail());
            
            return "admin/logout";
            
        } catch (Exception e) {
            logger.error("Failed to load logout page", e);
            return "redirect:/logout";
        }
    }
}