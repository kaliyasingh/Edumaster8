package com.vp.controller.auth;

import com.vp.entity.User;
import com.vp.entity.Course;
import com.vp.entity.Instructor;
import com.vp.entity.User.Role;
import com.vp.service.auth.EmailService;
import com.vp.service.auth.OtpService;
import com.vp.service.auth.UserService;
import com.vp.service.instructor.InstructorCourseService;
import com.vp.service.admin.CourseService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
public class AuthenticationController {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationController.class);

    @Autowired private UserService userService;
    @Autowired private OtpService otpService;
    @Autowired private EmailService emailService;
    @Autowired private CourseService courseService;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private InstructorCourseService instructorCourseService;

    // ==================== PAGES ====================

    @GetMapping("/reg")
    public String showRegistrationPage() { return "auth/register"; }

    @GetMapping("/Contact")
    public String showContactPage() { return "auth/Contact"; }

    @GetMapping("/about")
    public String showAboutPage() { return "auth/about"; }

    @GetMapping("/login")
    public String showLoginPage() { return "auth/login"; }

    @GetMapping("/courses")
    public String showCoursesPage(HttpServletRequest request) {
        try {
            // Service layer hi Single SQL Query se sab data Fetch kare (No Loops needed)
            List<Course> allCourses = instructorCourseService.getLiveCourses();

            request.setAttribute("allCourses", allCourses);
            request.setAttribute("totalCourses", allCourses != null ? allCourses.size() : 0);

        } catch (Exception e) {
            logger.error("❌ Failed to load courses page", e);
            request.setAttribute("allCourses", new ArrayList<Course>());
            request.setAttribute("totalCourses", 0);
        }
        return "auth/courses";
    }

    // ==================== HOME ====================

    @GetMapping({"/", "/index"})
    public String home(HttpServletRequest request) {
        try {
            // Service layer se Optimized list fetch karein
            List<Course> liveCourses = instructorCourseService.getLiveCourses();
            request.setAttribute("liveCourses", liveCourses);
        } catch (Exception e) {
            logger.error("❌ Failed to load home page courses", e);
            request.setAttribute("liveCourses", new ArrayList<Course>());
        }
        return "auth/index";
    }

    // ==================== COURSE DETAIL ====================

    @GetMapping("/courses/{id}")
    public String courseDetail(@PathVariable Long id, HttpServletRequest request) {
        try {
            Course course = instructorCourseService.getCourseById(id);
            request.setAttribute("course", course);
            return "auth/course_detail";

        } catch (RuntimeException e) {
            logger.warn("Course not found for ID: {}", id);
            return "redirect:/";
        }
    }

    // ==================== OTP ====================

    @PostMapping("/sendOtp")
    @ResponseBody
    public String sendOtp(@RequestParam("cName") String fullName,
                          @RequestParam("email") String email) {
        try {
            if (!isValidEmail(email)) return "INVALID_EMAIL";
            if (userService.existsByEmail(email)) return "EMAIL_EXISTS";
            String otp = otpService.generateOtp(email);
            emailService.sendOtpEmail(email, fullName, otp);
            logger.info("OTP sent to: {}", email);
            return "SUCCESS";
        } catch (Exception e) {
            logger.error("Failed to send OTP to: {}", email, e);
            return "FAILURE";
        }
    }

    // ==================== REGISTRATION ====================

    @PostMapping("/adduser")
    public String registerUser(@RequestParam("cName") String fullName,
                               @RequestParam("email") String email,
                               @RequestParam("password") String password,
                               @RequestParam("otp") String otp,
                               @RequestParam(value = "role", defaultValue = "STUDENT") String roleStr,
                               RedirectAttributes redirectAttributes) {
        try {
            if (password.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Password must be at least 6 characters long.");
                redirectAttributes.addFlashAttribute("cName", fullName);
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/reg";
            }

            if (!password.matches(".*[0-9].*") || !password.matches(".*[a-zA-Z].*")) {
                redirectAttributes.addFlashAttribute("error", "Password must contain at least one letter and one number.");
                redirectAttributes.addFlashAttribute("cName", fullName);
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/reg";
            }

            if (!otpService.verifyOtp(email, otp)) {
                redirectAttributes.addFlashAttribute("error", "Invalid or expired OTP. Please try again.");
                redirectAttributes.addFlashAttribute("cName", fullName);
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/reg";
            }

            if (userService.existsByEmail(email)) {
                redirectAttributes.addFlashAttribute("error", "Email already registered. Please login.");
                return "redirect:/login";
            }

            Role role;
            try {
                role = Role.valueOf(roleStr.toUpperCase());
            } catch (IllegalArgumentException e) {
                redirectAttributes.addFlashAttribute("error", "Invalid role selected.");
                redirectAttributes.addFlashAttribute("cName", fullName);
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/reg";
            }

            String encodedPassword = passwordEncoder.encode(password);

            User user;
            if (role == Role.INSTRUCTOR) {
                Instructor instructor = new Instructor();
                instructor.setFullName(fullName);
                instructor.setEmail(email);
                instructor.setPassword(encodedPassword);
                instructor.setRole(Role.INSTRUCTOR);
                instructor.setEmailVerified(true);
                instructor.setIsActive(true);
                instructor.setAverageRating(0.0);
                instructor.setInstructorVerified(false);
                user = instructor;
                logger.info("✅ Creating INSTRUCTOR: {}", email);
            } else {
                user = new User();
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPassword(encodedPassword);
                user.setRole(role);
                user.setEmailVerified(true);
                user.setIsActive(true);
                logger.info("✅ Creating {}: {}", role, email);
            }

            userService.registerUser(user);
            otpService.clearOtp(email);

            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
            return "redirect:/login";

        } catch (Exception e) {
            logger.error("❌ Registration failed: {}", email, e);
            redirectAttributes.addFlashAttribute("error", "Registration failed. Please try again.");
            redirectAttributes.addFlashAttribute("cName", fullName);
            redirectAttributes.addFlashAttribute("email", email);
            return "redirect:/reg";
        }
    }

    // ==================== LOGIN ====================

    @PostMapping("/checkuser")
    public String checkUser(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "role", required = false, defaultValue = "STUDENT") String roleStr,
            @RequestParam(value = "rememberMe", defaultValue = "false") boolean rememberMe,
            @RequestParam(value = "redirectTo", required = false) String redirectTo,
            @RequestParam(value = "courseId",   required = false) String courseId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        try {
            User user = userService.findByEmail(email);

            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "Email not registered.");
                redirectAttributes.addFlashAttribute("email", email);
                return buildLoginRedirect(redirectTo, courseId);
            }

            if (!user.getEmailVerified()) {
                redirectAttributes.addFlashAttribute("error", "Please verify your email first.");
                redirectAttributes.addFlashAttribute("email", email);
                return buildLoginRedirect(redirectTo, courseId);
            }

            if (!user.getIsActive()) {
                redirectAttributes.addFlashAttribute("error", "Your account has been deactivated.");
                return buildLoginRedirect(redirectTo, courseId);
            }

            if (!passwordEncoder.matches(password, user.getPassword())) {
                redirectAttributes.addFlashAttribute("error", "Invalid password.");
                redirectAttributes.addFlashAttribute("email", email);
                return buildLoginRedirect(redirectTo, courseId);
            }

            try {
                Role expectedRole = Role.valueOf(roleStr.toUpperCase());
                if (expectedRole != Role.STUDENT && user.getRole() != expectedRole) {
                    redirectAttributes.addFlashAttribute("error", "Role mismatch. Please select correct role.");
                    redirectAttributes.addFlashAttribute("email", email);
                    return buildLoginRedirect(redirectTo, courseId);
                }
            } catch (IllegalArgumentException ignored) {}

            try { userService.updateLastLogin(user.getId()); } catch (Exception ignored) {}

            int sessionTimeout = rememberMe ? 30 * 24 * 60 * 60 : 2 * 60 * 60;
            session.setMaxInactiveInterval(sessionTimeout);

            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId",       user.getId());
            session.setAttribute("userEmail",    user.getEmail());
            session.setAttribute("userName",     user.getFullName());
            session.setAttribute("userFullName", user.getFullName());
            session.setAttribute("userRole",     user.getRole().name());

            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("email",    user.getEmail());
            session.setAttribute("phone",    user.getPhone() != null ? user.getPhone() : "");
            
            if (user.getRole() == Role.INSTRUCTOR) session.setAttribute("instructorId", user.getId());
            else if (user.getRole() == Role.STUDENT) session.setAttribute("studentId",  user.getId());
            else if (user.getRole() == Role.ADMIN)   session.setAttribute("adminId",    user.getId());

            logger.info("✅ Login: {} [{}]", email, user.getRole());

            if (("checkout".equals(redirectTo) || "enroll".equals(redirectTo)) 
                    && courseId != null && !courseId.trim().isEmpty()) {
                try {
                    session.setAttribute("pendingCourseId", Long.parseLong(courseId.trim()));
                } catch (NumberFormatException ignored) {}
                return "redirect:/";
            }

            switch (user.getRole()) {
                case ADMIN:      return "redirect:/admin/dashboard";
                case INSTRUCTOR: return "redirect:/instructor/dashboard";
                case STUDENT:
                default:         return "redirect:/student/dashboard";
            }

        } catch (Exception e) {
            logger.error("❌ Login failed: {}", email, e);
            redirectAttributes.addFlashAttribute("error", "Login failed. Please try again.");
            redirectAttributes.addFlashAttribute("email", email);
            return buildLoginRedirect(redirectTo, courseId);
        }
    }

    // ==================== LOGOUT & FORGOT PASSWORD ====================

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        String userEmail = (String) session.getAttribute("userEmail");
        session.invalidate();
        logger.info("✅ Logout: {}", userEmail);
        redirectAttributes.addFlashAttribute("success", "You have been logged out successfully.");
        return "redirect:/";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() { return "auth/forgot-password"; }

    @PostMapping("/auth/forgot-password/send-otp")
    @ResponseBody
    public String sendForgotPasswordOtp(@RequestParam("email") String email) {
        try {
            if (!userService.existsByEmail(email)) return "NOT_FOUND";
            User user = userService.findByEmail(email);
            String otp = otpService.generateOtp(email);
            emailService.sendPasswordResetOtpEmail(email, user.getFullName(), otp);
            return "SUCCESS";
        } catch (Exception e) {
            logger.error("Failed to send reset OTP: {}", email, e);
            return "FAILURE";
        }
    }

    @PostMapping("/auth/forgot-password/verify-otp")
    @ResponseBody
    public String verifyForgotPasswordOtp(@RequestParam("email") String email,
                                          @RequestParam("otp") String otp) {
        try {
            return otpService.verifyOtp(email, otp) ? "SUCCESS" : "INVALID";
        } catch (Exception e) {
            return "INVALID";
        }
    }

    @PostMapping("/auth/reset-password")
    public String resetPassword(@RequestParam("email") String email,
                                @RequestParam("newPassword") String newPassword,
                                @RequestParam("confirmPassword") String confirmPassword,
                                RedirectAttributes redirectAttributes) {
        try {
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Passwords do not match.");
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/forgot-password";
            }
            if (newPassword.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Password must be at least 6 characters long.");
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/forgot-password";
            }
            if (!newPassword.matches(".*[0-9].*") || !newPassword.matches(".*[a-zA-Z].*")) {
                redirectAttributes.addFlashAttribute("error", "Password must contain at least one letter and one number.");
                redirectAttributes.addFlashAttribute("email", email);
                return "redirect:/forgot-password";
            }
            if (!userService.existsByEmail(email)) {
                redirectAttributes.addFlashAttribute("error", "User not found.");
                return "redirect:/forgot-password";
            }

            userService.updatePassword(email, newPassword);
            otpService.clearOtp(email);

            redirectAttributes.addFlashAttribute("success", "Password reset successful! Please login.");
            return "redirect:/login";

        } catch (Exception e) {
            logger.error("Password reset failed: {}", email, e);
            redirectAttributes.addFlashAttribute("error", "Password reset failed. Please try again.");
            redirectAttributes.addFlashAttribute("email", email);
            return "redirect:/forgot-password";
        }
    }

    // ==================== HELPERS ====================

    private String buildLoginRedirect(String redirectTo, String courseId) {
        if (redirectTo != null && courseId != null) {
            return "redirect:/login?redirectTo=" + redirectTo + "&courseId=" + courseId;
        }
        return "redirect:/login";
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }
}