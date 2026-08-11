package com.vp.controller.admin;

import com.vp.entity.Instructor;
import com.vp.entity.User;
import com.vp.service.auth.EmailService;
import com.vp.service.instructor.InstructorService;
import com.vp.service.auth.UserService;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminInstructorController {

    private static final Logger logger = LoggerFactory.getLogger(AdminInstructorController.class);

    private static final String SESSION_USER_ID = "userId";
    private static final String REDIRECT_LOGIN  = "redirect:/login";
    private static final String ATTR_ERROR      = "error";
    private static final String ATTR_SUCCESS    = "success";
    private static final String ATTR_USER       = "user";

    // Prefix used consistently so JSP can distinguish suspended vs rejected
    private static final String SUSPEND_REASON  = "Suspended by administrator";

    @Autowired private UserService       userService;
    @Autowired private InstructorService instructorService;
    @Autowired private EmailService      emailService;

    // ==================== HELPER METHODS ====================

    private Optional<User> getAuthenticatedUser(HttpSession session) {
        Long userId = (Long) session.getAttribute(SESSION_USER_ID);
        if (userId == null) return Optional.empty();
        return Optional.ofNullable(userService.findById(userId));
    }

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    private Optional<User> validateAdminAccess(HttpSession session, RedirectAttributes ra) {
        Optional<User> opt = getAuthenticatedUser(session);
        if (opt.isEmpty() || !isAdmin(opt.get())) {
            if (ra != null) ra.addFlashAttribute(ATTR_ERROR, "Please login as an administrator.");
            return Optional.empty();
        }
        return opt;
    }

    private void populateUserModel(Model model, User user) {
        model.addAttribute(ATTR_USER, user);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("email",    user.getEmail());
        model.addAttribute("role",     "Admin");
    }

    // ==================== PAGE ENDPOINTS ====================

    /**
     * GET /admin/instructors
     * Shows the Instructor Management page with ALL instructors in the table.
     */
    @GetMapping("/instructors")
    public String instructorsPage(HttpSession session, Model model, RedirectAttributes ra) {
        try {
            Optional<User> userOpt = validateAdminAccess(session, ra);
            if (userOpt.isEmpty()) return REDIRECT_LOGIN;

            User user = userOpt.get();
            populateUserModel(model, user);

            List<Instructor> allInstructors = instructorService.getAllInstructors();

            long totalInstructors = allInstructors.size();

            long pendingInstructors = allInstructors.stream()
                    .filter(i -> (i.getInstructorVerified() == null || !i.getInstructorVerified())
                              && i.getRejectedAt() == null)
                    .count();

            long activeInstructors = allInstructors.stream()
                    .filter(i -> Boolean.TRUE.equals(i.getInstructorVerified())
                              && i.getRejectedAt() == null)
                    .count();

            // Suspended = rejectedAt != null AND reason starts with "Suspended"
            long suspendedInstructors = allInstructors.stream()
                    .filter(i -> i.getRejectedAt() != null
                              && i.getRejectionReason() != null
                              && i.getRejectionReason().startsWith("Suspended"))
                    .count();

            // Rejected = rejectedAt != null AND NOT suspended
            long rejectedInstructors = allInstructors.stream()
                    .filter(i -> i.getRejectedAt() != null
                              && (i.getRejectionReason() == null
                                  || !i.getRejectionReason().startsWith("Suspended")))
                    .count();

            double totalRevenue = allInstructors.stream()
                    .filter(i -> i.getTotalRevenue() != null)
                    .mapToDouble(Instructor::getTotalRevenue)
                    .sum();

            model.addAttribute("currentPage",           "instructors");
            model.addAttribute("allInstructors",         allInstructors);
            model.addAttribute("totalInstructors",       totalInstructors);
            model.addAttribute("pendingInstructors",     pendingInstructors);
            model.addAttribute("activeInstructors",      activeInstructors);
            model.addAttribute("suspendedInstructors",   suspendedInstructors);
            model.addAttribute("rejectedInstructors",    rejectedInstructors);
            model.addAttribute("totalRevenue",           totalRevenue);

            logger.info("Instructors page | admin={} | total={} active={} pending={} suspended={} rejected={}",
                    user.getEmail(), totalInstructors, activeInstructors,
                    pendingInstructors, suspendedInstructors, rejectedInstructors);

            return "admin/instructors";

        } catch (Exception e) {
            logger.error("Failed to load instructors page", e);
            ra.addFlashAttribute(ATTR_ERROR, "Failed to load instructors page");
            return "redirect:/admin/dashboard";
        }
    }

    // ==================== REST API ENDPOINTS ====================

    /** GET /admin/api/instructors */
    @GetMapping("/api/instructors")
    @ResponseBody
    public ResponseEntity<?> getAllInstructors(
            HttpSession session,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String specialization) {
        try {
            if (validateAdminAccess(session, null).isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            List<Instructor> instructors;
            if (status != null && !status.isBlank()) {
                instructors = switch (status.toLowerCase()) {
                    case "pending"   -> instructorService.getPendingInstructors();
                    case "active"    -> instructorService.getActiveInstructors();
                    case "rejected"  -> instructorService.getRejectedInstructors();
                    case "suspended" -> instructorService.getAllInstructors().stream()
                            .filter(i -> i.getRejectedAt() != null
                                      && i.getRejectionReason() != null
                                      && i.getRejectionReason().startsWith("Suspended"))
                            .toList();
                    default          -> instructorService.getAllInstructors();
                };
            } else {
                instructors = instructorService.getAllInstructors();
            }

            if (specialization != null && !specialization.isBlank()) {
                instructors = instructors.stream()
                        .filter(i -> specialization.equalsIgnoreCase(i.getSpecialization()))
                        .toList();
            }

            return ResponseEntity.ok(instructors);

        } catch (Exception e) {
            logger.error("Error fetching instructors", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch instructors"));
        }
    }

    /** GET /admin/api/instructors/{id} */
    @GetMapping("/api/instructors/{id}")
    @ResponseBody
    public ResponseEntity<?> getInstructorDetails(HttpSession session, @PathVariable Long id) {
        try {
            if (validateAdminAccess(session, null).isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            Instructor instructor = instructorService.getInstructorById(id);
            if (instructor == null)
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "Instructor not found"));

            return ResponseEntity.ok(instructor);

        } catch (Exception e) {
            logger.error("Error fetching instructor ID={}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch instructor details"));
        }
    }

    /** POST /admin/api/instructors/{id}/approve */
    @PostMapping("/api/instructors/{id}/approve")
    @ResponseBody
    public ResponseEntity<?> approveInstructor(HttpSession session, @PathVariable Long id) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session, null);
            if (adminOpt.isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            Instructor instructor = instructorService.approveInstructor(id);

            try { emailService.sendInstructorApprovalEmail(instructor.getEmail(), instructor.getFullName()); }
            catch (Exception e) { logger.warn("Approval email failed for id={}", id, e); }

            logger.info("Approved instructor={} by admin={}", instructor.getEmail(), adminOpt.get().getEmail());
            return ResponseEntity.ok(Map.of("success", true, "message", "Instructor approved successfully"));

        } catch (Exception e) {
            logger.error("Error approving instructor ID={}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to approve: " + e.getMessage()));
        }
    }

    /** POST /admin/api/instructors/{id}/reject */
    @PostMapping("/api/instructors/{id}/reject")
    @ResponseBody
    public ResponseEntity<?> rejectInstructor(
            HttpSession session,
            @PathVariable Long id,
            @RequestBody Map<String, String> payload) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session, null);
            if (adminOpt.isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            String reason = payload.get("reason");
            if (reason == null || reason.isBlank())
                return ResponseEntity.badRequest().body(Map.of("error", "Rejection reason is required"));

            Instructor existing = instructorService.getInstructorById(id);
            String email = existing.getEmail(), name = existing.getFullName();

            instructorService.rejectInstructor(id, reason.trim());

            try { emailService.sendInstructorRejectionEmail(email, name, reason.trim()); }
            catch (Exception e) { logger.warn("Rejection email failed for id={}", id, e); }

            logger.info("Rejected instructor={} by admin={}", email, adminOpt.get().getEmail());
            return ResponseEntity.ok(Map.of("success", true, "message", "Instructor rejected successfully"));

        } catch (Exception e) {
            logger.error("Error rejecting instructor ID={}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to reject: " + e.getMessage()));
        }
    }

    /** DELETE /admin/api/instructors/{id} */
    @DeleteMapping("/api/instructors/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteInstructor(HttpSession session, @PathVariable Long id) {
        try {
            Optional<User> adminOpt = validateAdminAccess(session, null);
            if (adminOpt.isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            Instructor instructor = instructorService.getInstructorById(id);
            if (instructor == null)
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "Instructor not found"));

            String email = instructor.getEmail();
            userService.deleteUser(id);
            logger.info("Deleted instructor={} by admin={}", email, adminOpt.get().getEmail());
            return ResponseEntity.ok(Map.of("success", true, "message", "Instructor deleted successfully"));

        } catch (Exception e) {
            logger.error("Error deleting instructor ID={}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to delete: " + e.getMessage()));
        }
    }

    // ==================== BULK ENDPOINTS ====================

    /** POST /admin/api/instructors/bulk-approve */
    @PostMapping("/api/instructors/bulk-approve")
    @ResponseBody
    public ResponseEntity<?> bulkApprove(HttpSession session, @RequestBody Map<String, List<Long>> payload) {
        try {
            if (validateAdminAccess(session, null).isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            List<Long> ids = payload.get("instructorIds");
            if (ids == null || ids.isEmpty())
                return ResponseEntity.badRequest().body(Map.of("error", "No instructor IDs provided"));

            int ok = 0, fail = 0;
            for (Long id : ids) {
                try {
                    Instructor inst = instructorService.approveInstructor(id);
                    try { emailService.sendInstructorApprovalEmail(inst.getEmail(), inst.getFullName()); }
                    catch (Exception ignored) {}
                    ok++;
                } catch (Exception e) {
                    logger.error("Bulk approve failed for id={}", id, e);
                    fail++;
                }
            }

            logger.info("Bulk approve: ok={} fail={}", ok, fail);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", ok + " instructor(s) approved successfully",
                    "successCount", ok, "failCount", fail));

        } catch (Exception e) {
            logger.error("Bulk approve error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Bulk approve failed"));
        }
    }

    /**
     * POST /admin/api/instructors/bulk-suspend
     * ✅ FIX: Now calls suspendInstructor() with "Suspended by administrator" reason
     *    so JSP can distinguish it from a regular rejection using fn:startsWith check.
     */
    @PostMapping("/api/instructors/bulk-suspend")
    @ResponseBody
    public ResponseEntity<?> bulkSuspend(HttpSession session, @RequestBody Map<String, List<Long>> payload) {
        try {
            if (validateAdminAccess(session, null).isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            List<Long> ids = payload.get("instructorIds");
            if (ids == null || ids.isEmpty())
                return ResponseEntity.badRequest().body(Map.of("error", "No instructor IDs provided"));

            int ok = 0, fail = 0;
            for (Long id : ids) {
                try {
                    // ✅ FIXED: call suspendInstructor (not rejectInstructor)
                    // This sets rejectionReason = "Suspended by administrator"
                    // JSP checks fn:startsWith(rejectionReason, 'Suspended') to show blue badge
                    instructorService.suspendInstructor(id, SUSPEND_REASON);
                    ok++;
                } catch (Exception e) {
                    logger.error("Bulk suspend failed for id={}", id, e);
                    fail++;
                }
            }

            logger.info("Bulk suspend: ok={} fail={}", ok, fail);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", ok + " instructor(s) suspended successfully",
                    "successCount", ok, "failCount", fail));

        } catch (Exception e) {
            logger.error("Bulk suspend error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Bulk suspend failed"));
        }
    }

    /** POST /admin/api/instructors/bulk-delete */
    @PostMapping("/api/instructors/bulk-delete")
    @ResponseBody
    public ResponseEntity<?> bulkDelete(HttpSession session, @RequestBody Map<String, List<Long>> payload) {
        try {
            if (validateAdminAccess(session, null).isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            List<Long> ids = payload.get("instructorIds");
            if (ids == null || ids.isEmpty())
                return ResponseEntity.badRequest().body(Map.of("error", "No instructor IDs provided"));

            int ok = 0, fail = 0;
            for (Long id : ids) {
                try {
                    userService.deleteUser(id);
                    ok++;
                } catch (Exception e) {
                    logger.error("Bulk delete failed for id={}", id, e);
                    fail++;
                }
            }

            logger.info("Bulk delete: ok={} fail={}", ok, fail);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", ok + " instructor(s) deleted successfully",
                    "successCount", ok, "failCount", fail));

        } catch (Exception e) {
            logger.error("Bulk delete error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Bulk delete failed"));
        }
    }

    /** GET /admin/api/instructors/statistics */
    @GetMapping("/api/instructors/statistics")
    @ResponseBody
    public ResponseEntity<?> getStatistics(HttpSession session) {
        try {
            if (validateAdminAccess(session, null).isEmpty())
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized"));

            List<Instructor> all = instructorService.getAllInstructors();

            return ResponseEntity.ok(Map.of(
                    "totalInstructors",     all.size(),
                    "activeInstructors",    all.stream().filter(i -> Boolean.TRUE.equals(i.getInstructorVerified()) && i.getRejectedAt() == null).count(),
                    "pendingInstructors",   all.stream().filter(i -> (i.getInstructorVerified() == null || !i.getInstructorVerified()) && i.getRejectedAt() == null).count(),
                    "suspendedInstructors", all.stream().filter(i -> i.getRejectedAt() != null && i.getRejectionReason() != null && i.getRejectionReason().startsWith("Suspended")).count(),
                    "rejectedInstructors",  all.stream().filter(i -> i.getRejectedAt() != null && (i.getRejectionReason() == null || !i.getRejectionReason().startsWith("Suspended"))).count(),
                    "totalRevenue",         all.stream().filter(i -> i.getTotalRevenue() != null).mapToDouble(Instructor::getTotalRevenue).sum()
            ));

        } catch (Exception e) {
            logger.error("Error fetching statistics", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch statistics"));
        }
    }
}