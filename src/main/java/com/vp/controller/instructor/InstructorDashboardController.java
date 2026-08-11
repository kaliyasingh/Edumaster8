package com.vp.controller.instructor;

import com.vp.entity.User;
import com.vp.entity.Course;
import com.vp.service.auth.UserService;
import com.vp.service.instructor.InstructorCourseService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

/**
 * Controller for instructor dashboard and main navigation pages
 */
@Controller
@RequestMapping("/instructor")
public class InstructorDashboardController {
    
    private static final Logger logger = LoggerFactory.getLogger(InstructorDashboardController.class);
    
    private static final String SESSION_USER_ID = "userId";
    private static final String REDIRECT_LOGIN = "redirect:/login";
    private static final String ATTR_ERROR = "error";
    private static final String ATTR_USER = "user";
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private InstructorCourseService courseService;

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
     * Check if user has instructor or admin role
     */
    private boolean isInstructorOrAdmin(User user) {
        return user != null && 
               (user.getRole() == User.Role.INSTRUCTOR || user.getRole() == User.Role.ADMIN);
    }

    /**
     * Add common user attributes to model
     */
    private void populateUserModel(Model model, User user, String currentPage) {
        model.addAttribute(ATTR_USER, user);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("email", user.getEmail());
        model.addAttribute("role", "Instructor");
        model.addAttribute("currentPage", currentPage);
    }

    /**
     * Handle unauthorized access
     */
    private String redirectToLogin(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute(ATTR_ERROR, "Please login as an instructor.");
        return REDIRECT_LOGIN;
    }

    /**
     * Validate instructor access for all methods
     */
    private Optional<User> validateInstructorAccess(HttpSession session, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = getAuthenticatedUser(session);
        
        if (userOpt.isEmpty() || !isInstructorOrAdmin(userOpt.get())) {
            return Optional.empty();
        }
        
        return userOpt;
    }


    // ==================== DASHBOARD PAGES ====================

    /**
     * Instructor Dashboard - Main page
     */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "dashboard");
            
            // Get dashboard statistics
            List<Course> courses = courseService.getCoursesByInstructor(user.getEmail());
            long totalCourses = courses.size();
            long publishedCourses = courses.stream()
                .filter(c -> "PUBLISHED".equals(c.getStatus()))
                .count();
            
            int totalStudents = courses.stream()
                .mapToInt(c -> c.getTotalEnrollments() != null ? c.getTotalEnrollments() : 0)
                .sum();
            
            model.addAttribute("totalCourses", totalCourses);
            model.addAttribute("publishedCourses", publishedCourses);
            model.addAttribute("totalStudents", totalStudents);
            
            logger.info("Dashboard loaded for instructor: {}", user.getEmail());
            
            return "instructor/dashboard";
            
        } catch (Exception e) {
            logger.error("Failed to load dashboard", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load dashboard");
            return REDIRECT_LOGIN;
        }
    }

    /**
     * Create Course - Form to create new course
     */
    @GetMapping("/create-course")
    public String createCourse(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "create-course");
            
            logger.info("Create course page loaded for: {}", user.getEmail());
            
            return "instructor/create-course";
            
        } catch (Exception e) {
            logger.error("Failed to load create course page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
        }
    }

    /**
     * Course Content - Manage course materials
     */
    @GetMapping("/course-content")
    public String courseContent(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "course-content");
            
            // Fetch courses for content management
            List<Course> courses = courseService.getCoursesByInstructor(user.getEmail());
            model.addAttribute("courses", courses);
            
            logger.info("Course content page loaded for: {}", user.getEmail());
            
            return "instructor/course-content";
            
        } catch (Exception e) {
            logger.error("Failed to load course content page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
        }
    }

    /**
     * Students - List of enrolled students
     */
    @GetMapping("/students")
    public String students(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "students");
            
            // TODO: Fetch enrolled students
            // List<Enrollment> enrollments = enrollmentService.findByInstructor(user.getId());
            // model.addAttribute("enrollments", enrollments);
            
            logger.info("Students page loaded for: {}", user.getEmail());
            
            return "instructor/students";
            
        } catch (Exception e) {
            logger.error("Failed to load students page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
        }
    }

    /**
     * Earnings - Financial information
     */
    @GetMapping("/earnings")
    public String earnings(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "earnings");
            
            // TODO: Fetch earnings data
            // EarningsData earnings = earningsService.getEarningsByInstructor(user.getId());
            // model.addAttribute("earnings", earnings);
            
            logger.info("Earnings page loaded for: {}", user.getEmail());
            
            return "instructor/earnings";
            
        } catch (Exception e) {
            logger.error("Failed to load earnings page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
        }
    }

    /**
     * Reviews - Course reviews and ratings
     */
    @GetMapping("/reviews")
    public String reviews(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "reviews");
            
            // TODO: Fetch reviews
            // List<Review> reviews = reviewService.findByInstructor(user.getId());
            // model.addAttribute("reviews", reviews);
            
            logger.info("Reviews page loaded for: {}", user.getEmail());
            
            return "instructor/reviews";
            
        } catch (Exception e) {
            logger.error("Failed to load reviews page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
        }
    }

    /**
     * Analytics - Course and performance analytics
     */
    @GetMapping("/analytics")
    public String analytics(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "analytics");
            
            // TODO: Fetch analytics data
            // AnalyticsData analytics = analyticsService.getAnalyticsByInstructor(user.getId());
            // model.addAttribute("analytics", analytics);
            
            logger.info("Analytics page loaded for: {}", user.getEmail());
            
            return "instructor/analytics";
            
        } catch (Exception e) {
            logger.error("Failed to load analytics page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
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
                // Already logged out, redirect to login
                return REDIRECT_LOGIN;
            }
            
            User user = userOpt.get();
            model.addAttribute(ATTR_USER, user);
            
            logger.info("Logout confirmation page loaded for: {}", user.getEmail());
            
            return "instructor/logout";
            
        } catch (Exception e) {
            logger.error("Failed to load logout page", e);
            return "redirect:/logout";
        }
    }

    /**
     * Assignment - Course assignments
     */
    @GetMapping("/assignment")
    public String assignment(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = validateInstructorAccess(session, redirectAttributes);
            if (userOpt.isEmpty()) {
                return redirectToLogin(redirectAttributes);
            }
            
            User user = userOpt.get();
            populateUserModel(model, user, "assignment");
            
            logger.info("Assignment page loaded for: {}", user.getEmail());
            
            return "instructor/assignment";
            
        } catch (Exception e) {
            logger.error("Failed to load assignment page", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load page");
            return "redirect:/instructor/dashboard";
        }
    }
}