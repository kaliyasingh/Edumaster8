package com.vp.controller.instructor;

import com.vp.entity.Instructor;
import com.vp.entity.User;
import com.vp.service.auth.EmailService;
import com.vp.service.auth.OtpService;
import com.vp.service.instructor.InstructorService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * FIXED Controller for Instructor Registration and Approval Workflow
 * 
 * Key fixes:
 * - Proper parameter handling for sendOtp (cName instead of fullName)
 * - Detailed logging for debugging email issues
 * - Handles both /adduser and /complete-registration endpoints
 * - Comprehensive error handling
 */
@Controller
@RequestMapping("/instructor")
public class InstructorRegistrationController {

    private static final Logger logger = LoggerFactory.getLogger(InstructorRegistrationController.class);

    @Autowired
    private InstructorService instructorService;

    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;

    // ==================== REGISTRATION FLOW ====================

    /**
     * Display instructor registration page
     */
    @GetMapping("/register")
    public String showRegistrationPage(Model model) {
        try {
            logger.info("Instructor registration page accessed");
            model.addAttribute("instructor", new Instructor());
            return "instructor/register";
        } catch (Exception e) {
            logger.error("Error loading registration page", e);
            model.addAttribute("error", "Unable to load registration page");
            return "redirect:/";
        }
    }

    /**
     * Send OTP to instructor's email
     * POST /instructor/sendOtp
     * 
     * Called via AJAX from registration form
     * Parameters: cName (fullName), email
     */
    @PostMapping("/sendOtp")
    @ResponseBody
    public String sendOtp(@RequestParam("cName") String fullName,
                          @RequestParam("email") String email) {
        try {
            logger.info("╔═══════════════════════════════════════╗");
            logger.info("║   OTP REQUEST RECEIVED                ║");
            logger.info("╚═══════════════════════════════════════╝");
            logger.info("📧 Email: {}", email);
            logger.info("👤 Name: {}", fullName);

            // Validate inputs
            if (email == null || email.trim().isEmpty()) {
                logger.warn("⚠️ Email is null or empty");
                return "INVALID_EMAIL";
            }

            if (fullName == null || fullName.trim().isEmpty()) {
                logger.warn("⚠️ Name is null or empty");
                return "INVALID_NAME";
            }

            // Validate email format
            if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                logger.warn("⚠️ Invalid email format: {}", email);
                return "INVALID_EMAIL";
            }

            // Check if email already exists
            boolean emailExists = instructorService.isEmailRegistered(email);
            logger.info("📋 Email exists check: {}", emailExists);
            
            if (emailExists) {
                logger.warn("⚠️ Email already registered: {}", email);
                return "EMAIL_EXISTS";
            }

            // Generate OTP
            logger.info("🔐 Generating OTP...");
            String otp = otpService.generateOtp(email);
            logger.info("✅ OTP generated: {}", otp);

            // Send OTP email
            logger.info("📨 Attempting to send OTP email...");
            logger.info("   To: {}", email);
            logger.info("   Name: {}", fullName);
            logger.info("   OTP: {}", otp);
            
            try {
                emailService.sendOtpEmail(email, fullName, otp);
                logger.info("╔═══════════════════════════════════════╗");
                logger.info("║   ✅ EMAIL SENT SUCCESSFULLY          ║");
                logger.info("╚═══════════════════════════════════════╝");
                logger.info("📬 OTP email delivered to: {}", email);
                return "SUCCESS";
                
            } catch (Exception emailException) {
                logger.error("╔═══════════════════════════════════════╗");
                logger.error("║   ❌ EMAIL SENDING FAILED             ║");
                logger.error("╚═══════════════════════════════════════╝");
                logger.error("📧 Failed to send OTP email to: {}", email);
                logger.error("❌ Error type: {}", emailException.getClass().getName());
                logger.error("❌ Error message: {}", emailException.getMessage());
                logger.error("❌ Stack trace:", emailException);
                
                // Check common email issues
                if (emailException.getMessage() != null) {
                    String msg = emailException.getMessage().toLowerCase();
                    if (msg.contains("authentication failed")) {
                        logger.error("🔑 ISSUE: Email authentication failed - check username/password");
                    } else if (msg.contains("connection")) {
                        logger.error("🌐 ISSUE: Connection problem - check SMTP host/port");
                    } else if (msg.contains("tls") || msg.contains("ssl")) {
                        logger.error("🔒 ISSUE: TLS/SSL problem - check security settings");
                    }
                }
                
                return "EMAIL_SEND_FAILED";
            }

        } catch (Exception e) {
            logger.error("╔═══════════════════════════════════════╗");
            logger.error("║   ❌ UNEXPECTED ERROR IN SENDOTP      ║");
            logger.error("╚═══════════════════════════════════════╝");
            logger.error("Exception type: {}", e.getClass().getName());
            logger.error("Exception message: {}", e.getMessage());
            logger.error("Stack trace:", e);
            return "ERROR";
        }
    }

    /**
     * Complete instructor registration (handles /adduser endpoint)
     */
    @PostMapping("/adduser")
    public String registerInstructor(
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("phone") String phone,
            @RequestParam("specialization") String specialization,
            @RequestParam("experienceYears") String experienceYears,
            @RequestParam("bio") String bio,
            @RequestParam(value = "skills", required = false) String skills,
            @RequestParam("highestDegree") String highestDegree,
            @RequestParam("university") String university,
            @RequestParam("graduationYear") Integer graduationYear,
            @RequestParam(value = "certifications", required = false) String certifications,
            @RequestParam("otp") String otp,
            @RequestParam(value = "role", defaultValue = "INSTRUCTOR") String role,
            RedirectAttributes redirectAttributes) {
        
        try {
            logger.info("╔═══════════════════════════════════════╗");
            logger.info("║   INSTRUCTOR REGISTRATION STARTED     ║");
            logger.info("╚═══════════════════════════════════════╝");
            logger.info("📧 Email: {}", email);
            logger.info("👤 Name: {} {}", firstName, lastName);
            logger.info("🔐 OTP: {}", otp);

            // Verify OTP
            logger.info("🔍 Verifying OTP...");
            boolean otpValid = otpService.verifyOtp(email, otp);
            logger.info("OTP verification result: {}", otpValid);
            
            if (!otpValid) {
                logger.warn("❌ Invalid or expired OTP for: {}", email);
                redirectAttributes.addFlashAttribute("error", "Invalid or expired OTP. Please request a new one.");
                return "redirect:/instructor/register";
            }

            logger.info("✅ OTP verified successfully");

            // Create instructor object
            Instructor instructor = new Instructor();
            
            // Basic info
            String fullName = firstName.trim() + " " + lastName.trim();
            instructor.setFullName(fullName);
            instructor.setEmail(email.trim());
            instructor.setPassword(password);
            instructor.setPhone(phone.trim());
            
            // Professional info
            instructor.setSpecialization(specialization);
            instructor.setExperience(experienceYears);
            instructor.setBio(bio);
            
            // Skills
            if (skills != null && !skills.trim().isEmpty()) {
                instructor.setSpecialization(skills);
            }
            
            // Education
            instructor.setHighestDegree(highestDegree);
            instructor.setUniversity(university);
            instructor.setGraduationYear(graduationYear);
            
            // Certifications
            if (certifications != null && !certifications.trim().isEmpty()) {
                instructor.setCertifications(certifications);
            }

            // Register instructor
            logger.info("💾 Saving instructor to database...");
            Instructor registeredInstructor = instructorService.registerInstructor(instructor);
            logger.info("✅ Instructor registered with ID: {}", registeredInstructor.getId());

            // Send confirmation email
            logger.info("📨 Sending confirmation email...");
            try {
                emailService.sendInstructorRegistrationConfirmation(
                    registeredInstructor.getEmail(),
                    registeredInstructor.getFullName()
                );
                logger.info("✅ Confirmation email sent successfully");
            } catch (Exception emailEx) {
                logger.error("⚠️ Failed to send confirmation email (registration still successful)", emailEx);
            }

            logger.info("╔═══════════════════════════════════════╗");
            logger.info("║   ✅ REGISTRATION COMPLETE            ║");
            logger.info("╚═══════════════════════════════════════╝");

            redirectAttributes.addFlashAttribute("success", 
                "Registration successful! Your application is pending admin approval. You will receive an email once approved.");
            
            return "redirect:/login";

        } catch (RuntimeException e) {
            logger.error("❌ Registration failed (RuntimeException)", e);
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/instructor/register";
        } catch (Exception e) {
            logger.error("❌ Unexpected error during registration", e);
            redirectAttributes.addFlashAttribute("error", "Registration failed. Please try again.");
            return "redirect:/instructor/register";
        }
    }

    // ==================== ADMIN APPROVAL WORKFLOW ====================

    @GetMapping("/admin/pending")
    public String getPendingInstructors(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        try {
            if (!isAdmin(session)) {
                redirectAttributes.addFlashAttribute("error", "Admin access required");
                return "redirect:/login";
            }

            List<Instructor> pendingInstructors = instructorService.getPendingInstructors();
            model.addAttribute("pendingInstructors", pendingInstructors);
            model.addAttribute("pendingCount", pendingInstructors.size());

            logger.info("Loaded {} pending instructor applications", pendingInstructors.size());
            return "admin/pending-instructors";

        } catch (Exception e) {
            logger.error("Error loading pending instructors", e);
            redirectAttributes.addFlashAttribute("error", "Failed to load pending applications");
            return "redirect:/admin/dashboard";
        }
    }

    @PostMapping("/admin/approve/{instructorId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> approveInstructor(@PathVariable Long instructorId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (!isAdmin(session)) {
                response.put("success", false);
                response.put("message", "Admin access required");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            Instructor instructor = instructorService.approveInstructor(instructorId);

            // Send approval email
            try {
                emailService.sendInstructorApprovalEmail(instructor.getEmail(), instructor.getFullName());
                logger.info("✅ Approval email sent to: {}", instructor.getEmail());
            } catch (Exception emailEx) {
                logger.error("⚠️ Failed to send approval email", emailEx);
            }

            logger.info("✅ Instructor approved: {}", instructor.getEmail());

            response.put("success", true);
            response.put("message", "Instructor approved successfully");
            response.put("instructorName", instructor.getFullName());
            response.put("instructorEmail", instructor.getEmail());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("Error approving instructor", e);
            response.put("success", false);
            response.put("message", "Failed to approve instructor");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/admin/reject/{instructorId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> rejectInstructor(
            @PathVariable Long instructorId,
            @RequestParam(value = "reason", required = false) String reason,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (!isAdmin(session)) {
                response.put("success", false);
                response.put("message", "Admin access required");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            Instructor instructor = instructorService.rejectInstructor(instructorId);

            if (reason != null && !reason.trim().isEmpty()) {
                instructor.setRejectionReason(reason);
                instructor.updateTimestamp();
            }

            // Send rejection email
            try {
                emailService.sendInstructorRejectionEmail(
                    instructor.getEmail(),
                    instructor.getFullName(),
                    reason != null ? reason : "Your application did not meet our current requirements."
                );
                logger.info("✅ Rejection email sent to: {}", instructor.getEmail());
            } catch (Exception emailEx) {
                logger.error("⚠️ Failed to send rejection email", emailEx);
            }

            response.put("success", true);
            response.put("message", "Instructor application rejected");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("Error rejecting instructor", e);
            response.put("success", false);
            response.put("message", "Failed to reject instructor");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/admin/view/{instructorId}")
    public String viewInstructorDetails(@PathVariable Long instructorId, HttpSession session, 
                                        Model model, RedirectAttributes redirectAttributes) {
        try {
            if (!isAdmin(session)) {
                redirectAttributes.addFlashAttribute("error", "Admin access required");
                return "redirect:/login";
            }

            Instructor instructor = instructorService.getInstructorById(instructorId);
            model.addAttribute("instructor", instructor);
            return "admin/instructor-details";

        } catch (Exception e) {
            logger.error("Error viewing instructor details", e);
            redirectAttributes.addFlashAttribute("error", "Instructor not found");
            return "redirect:/instructor/admin/pending";
        }
    }

    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }
}