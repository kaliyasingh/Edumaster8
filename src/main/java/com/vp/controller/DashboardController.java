package com.vp.controller;

import com.vp.entity.User;
import com.vp.service.auth.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.Optional;

@Controller
public class DashboardController {
    
    private static final String SESSION_USER_ID = "userId";
    private static final String REDIRECT_LOGIN = "redirect:/login";
    private static final String ATTR_ERROR = "error";
    private static final String ATTR_USER = "user";
    
    @Autowired
    private UserService userService;

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
     * Check if user has required role
     */
    private boolean hasRole(User user, User.Role... allowedRoles) {
        return user != null && Arrays.asList(allowedRoles).contains(user.getRole());
    }

    /**
     * Add common user attributes to model
     */
    private void populateUserModel(Model model, User user, String roleDisplayName) {
        model.addAttribute(ATTR_USER, user);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("email", user.getEmail());
        model.addAttribute("role", roleDisplayName);
    }

    /**
     * Handle unauthorized access
     */
    private String redirectToLogin(RedirectAttributes redirectAttributes, String message) {
        redirectAttributes.addFlashAttribute(ATTR_ERROR, message);
        return REDIRECT_LOGIN;
    }

    /**
     * Student Dashboard
     */
    @GetMapping("/student/dashboard")
    public String studentDashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = getAuthenticatedUser(session);
        
        if (userOpt.isEmpty() || !hasRole(userOpt.get(), User.Role.STUDENT)) {
            return redirectToLogin(redirectAttributes, "Please login as a student.");
        }
        
        User user = userOpt.get();
        populateUserModel(model, user, "Student");
        return "student/dashboard";
    }

    // REMOVED: /instructor/dashboard - now handled by InstructorDashboardController

   
    /**
     * Profile page (accessible by all authenticated users)
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = getAuthenticatedUser(session);
        
        if (userOpt.isEmpty()) {
            return redirectToLogin(redirectAttributes, "Please login first.");
        }
        
        model.addAttribute(ATTR_USER, userOpt.get());
        return "profile/view-profile";
    }
    
   
}