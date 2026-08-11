package com.vp.controller.instructor;

import com.vp.entity.Instructor;
import com.vp.service.instructor.InstructorService;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/instructor/settings")
public class InstructorSettingsController {
    
    private static final Logger logger = LoggerFactory.getLogger(InstructorSettingsController.class);
    
    @Autowired
    private InstructorService instructorService;
    
    // ==================== SETTINGS PAGE ====================
    
    @GetMapping
    public String showSettingsPage(HttpSession session, Model model) {
        // Get logged-in user ID from session (works for all roles)
        Long userId = (Long) session.getAttribute("userId");
        
        // Debug logging
        logger.info("Settings page accessed - Session ID: {}", session.getId());
        logger.info("Session attributes - userId: {}, userEmail: {}, userRole: {}", 
            session.getAttribute("userId"),
            session.getAttribute("userEmail"),
            session.getAttribute("userRole"));
        
        if (userId == null) {
            logger.warn("UserId is null in session, redirecting to login");
            return "redirect:/login";
        }
        
        logger.info("Loading settings for userId: {}", userId);
        Instructor instructor = instructorService.getInstructorById(userId);
        model.addAttribute("instructor", instructor);
        
        return "instructor/settings";
    }
    
    // ==================== PROFILE UPDATE ====================
    
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute Instructor updatedData,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            
            if (userId == null) {
                logger.warn("UserId is null during profile update");
                return "redirect:/login";
            }
            
            instructorService.updateProfile(userId, updatedData);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                "Profile updated successfully!");
            
        } catch (Exception e) {
            logger.error("Error updating profile", e);
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error updating profile: " + e.getMessage());
        }
        
        return "redirect:/instructor/settings";
    }
    
    // ==================== PROFILE PHOTO ====================
    
    @PostMapping("/upload-photo")
    public String uploadProfilePhoto(@RequestParam("photo") MultipartFile file,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            
            if (userId == null) {
                return "redirect:/login";
            }
            
            instructorService.uploadProfilePhoto(userId, file);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                "Profile photo uploaded successfully!");
            
        } catch (Exception e) {
            logger.error("Error uploading photo", e);
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error uploading photo: " + e.getMessage());
        }
        
        return "redirect:/instructor/settings";
    }
    
    @PostMapping("/remove-photo")
    public String removeProfilePhoto(HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            
            if (userId == null) {
                return "redirect:/login";
            }
            
            instructorService.removeProfilePhoto(userId);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                "Profile photo removed successfully!");
            
        } catch (Exception e) {
            logger.error("Error removing photo", e);
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error removing photo: " + e.getMessage());
        }
        
        return "redirect:/instructor/settings";
    }
    
    // ==================== PASSWORD CHANGE ====================
    
    @PostMapping("/change-password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
                                @RequestParam("newPassword") String newPassword,
                                @RequestParam("confirmPassword") String confirmPassword,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            
            if (userId == null) {
                return "redirect:/login";
            }
            
            // Validate passwords match
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("errorMessage", 
                    "New passwords do not match!");
                return "redirect:/instructor/settings";
            }
            
            instructorService.changePassword(userId, currentPassword, newPassword);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                "Password changed successfully!");
            
        } catch (Exception e) {
            logger.error("Error changing password", e);
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error changing password: " + e.getMessage());
        }
        
        return "redirect:/instructor/settings";
    }
    
    // ==================== PAYOUT SETTINGS ====================
    
    @PostMapping("/payout")
    public String updatePayoutSettings(@ModelAttribute Instructor payoutData,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            
            if (userId == null) {
                return "redirect:/login";
            }
            
            instructorService.updatePayoutSettings(userId, payoutData);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                "Payout settings updated successfully!");
            
        } catch (Exception e) {
            logger.error("Error updating payout settings", e);
            redirectAttributes.addFlashAttribute("errorMessage", 
                "Error updating payout settings: " + e.getMessage());
        }
        
        return "redirect:/instructor/settings";
    }
}