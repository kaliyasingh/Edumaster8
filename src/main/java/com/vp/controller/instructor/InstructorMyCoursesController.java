package com.vp.controller.instructor;

import com.vp.entity.Course;
import com.vp.entity.User;
import com.vp.service.auth.UserService;
import com.vp.service.instructor.InstructorCourseService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

/**
 * Dedicated controller for the Instructor "My Courses" page.
 *
 * Routes handled:
 *   GET  /instructor/my-courses                  → list all courses
 *   POST /instructor/my-courses/submit-review     → DRAFT → PENDING
 *   POST /instructor/edit-course                  → update course fields + thumbnail
 */
@Controller
public class InstructorMyCoursesController {

    private static final Logger logger = LoggerFactory.getLogger(InstructorMyCoursesController.class);

    private static final String REDIRECT_LOGIN      = "redirect:/login";
    private static final String REDIRECT_MY_COURSES = "redirect:/instructor/my-courses";
    private static final String VIEW_MY_COURSES     = "instructor/my-courses";

    @Autowired
    private UserService userService;

    @Autowired
    private InstructorCourseService courseService;

    // ──────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ──────────────────────────────────────────────────────────────

    private Optional<User> getAuthUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return Optional.empty();
        return Optional.ofNullable(userService.findById(userId));
    }

    private boolean isInstructorOrAdmin(User user) {
        return user != null &&
               (user.getRole() == User.Role.INSTRUCTOR || user.getRole() == User.Role.ADMIN);
    }

    private void populateModel(Model model, User user) {
        model.addAttribute("user",     user);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("email",    user.getEmail());
        model.addAttribute("role",     "Instructor");
    }

    private String unauthorized(RedirectAttributes ra) {
        ra.addFlashAttribute("error", "Please log in as an instructor.");
        return REDIRECT_LOGIN;
    }

    // ──────────────────────────────────────────────────────────────
    // GET  /instructor/my-courses
    // ──────────────────────────────────────────────────────────────

    @GetMapping("/instructor/my-courses")
    public String myCourses(HttpSession session,
                             Model model,
                             RedirectAttributes ra) {
        try {
            Optional<User> userOpt = getAuthUser(session);
            if (userOpt.isEmpty() || !isInstructorOrAdmin(userOpt.get())) {
                return unauthorized(ra);
            }

            User user = userOpt.get();
            populateModel(model, user);

            List<Course> courses = courseService.getCoursesByInstructor(user.getEmail());
            model.addAttribute("courses", courses);

            long totalCourses    = courses.size();
            long publishedCourses = courses.stream().filter(c -> "PUBLISHED".equalsIgnoreCase(c.getStatus())).count();
            long draftCourses    = courses.stream().filter(c -> "DRAFT".equalsIgnoreCase(c.getStatus())).count();
            long pendingCourses  = courses.stream().filter(c -> "PENDING".equalsIgnoreCase(c.getStatus())).count();
            long rejectedCourses = courses.stream().filter(c -> "REJECTED".equalsIgnoreCase(c.getStatus())).count();

            int    totalStudents = courses.stream().mapToInt(c -> c.getTotalEnrollments() != null ? c.getTotalEnrollments() : 0).sum();
            double totalEarnings = courses.stream().mapToDouble(c -> {
                int    e = c.getTotalEnrollments() != null ? c.getTotalEnrollments() : 0;
                double p = c.getPrice()            != null ? c.getPrice()            : 0.0;
                return e * p;
            }).sum();

            model.addAttribute("totalCourses",    totalCourses);
            model.addAttribute("publishedCourses", publishedCourses);
            model.addAttribute("draftCourses",    draftCourses);
            model.addAttribute("pendingCourses",  pendingCourses);
            model.addAttribute("rejectedCourses", rejectedCourses);
            model.addAttribute("totalStudents",   totalStudents);
            model.addAttribute("totalEarnings",   totalEarnings);

            logger.info("My Courses loaded for {} — total:{}, live:{}, draft:{}, pending:{}, rejected:{}",
                    user.getEmail(), totalCourses, publishedCourses, draftCourses, pendingCourses, rejectedCourses);

            return VIEW_MY_COURSES;

        } catch (Exception e) {
            logger.error("Failed to load My Courses", e);
            ra.addFlashAttribute("error", "Failed to load courses. Please try again.");
            return "redirect:/instructor/dashboard";
        }
    }

    // ──────────────────────────────────────────────────────────────
    // POST /instructor/my-courses/submit-review
    // ──────────────────────────────────────────────────────────────

    @PostMapping("/instructor/my-courses/submit-review")
    public String submitForReview(@RequestParam("courseId") Long courseId,
                                  HttpSession session,
                                  RedirectAttributes ra) {
        try {
            Optional<User> userOpt = getAuthUser(session);
            if (userOpt.isEmpty() || !isInstructorOrAdmin(userOpt.get())) {
                return unauthorized(ra);
            }

            User user = userOpt.get();

            if (!courseService.isInstructorOwner(courseId, user.getEmail())
                    && user.getRole() != User.Role.ADMIN) {
                logger.warn("Unauthorized submit-review attempt: user={}, courseId={}", user.getEmail(), courseId);
                ra.addFlashAttribute("error", "You are not authorized to submit this course.");
                return REDIRECT_MY_COURSES;
            }

            Course course        = courseService.getCourseById(courseId);
            String currentStatus = course.getStatus();

            if (!"DRAFT".equalsIgnoreCase(currentStatus) && !"REJECTED".equalsIgnoreCase(currentStatus)) {
                logger.warn("Submit-review rejected — invalid status '{}' for courseId={}", currentStatus, courseId);
                ra.addFlashAttribute("error",
                        "Course '" + course.getTitle() + "' cannot be submitted — current status: " + currentStatus);
                return REDIRECT_MY_COURSES;
            }

            course.setStatus("PENDING");
            course.setRejectionReason(null);
            courseService.saveCourse(course);

            logger.info("Course '{}' (id={}) submitted for review by {}", course.getTitle(), courseId, user.getEmail());
            ra.addFlashAttribute("successMessage",
                    "'" + course.getTitle() + "' has been submitted for review! We'll notify you within 48 hours.");

        } catch (Exception e) {
            logger.error("Failed to submit course {} for review", courseId, e);
            ra.addFlashAttribute("errorMessage", "Failed to submit course for review. Please try again.");
        }

        return REDIRECT_MY_COURSES;
    }

    // ──────────────────────────────────────────────────────────────
    // POST /instructor/edit-course
    // ──────────────────────────────────────────────────────────────

    /**
     * Save changes made in the Edit modal and redirect back to My Courses.
     *
     * Accepts:
     *   courseId      — required, identifies the course to update
     *   title         — course title
     *   category      — course category
     *   level         — difficulty level
     *   price         — course price
     *   sections      — lecture count
     *   duration      — duration string (e.g. "6h 30m")
     *   description   — course description
     *   thumbnailFile — optional new thumbnail (multipart)
     *   thumbnailUrl  — existing URL (used only if no file uploaded)
     */
    @PostMapping("/instructor/edit-course")
    public String editCourse(@RequestParam("courseId")                        Long          courseId,
                             @RequestParam(value = "title",       defaultValue = "") String title,
                             @RequestParam(value = "category",    defaultValue = "") String category,
                             @RequestParam(value = "level",       defaultValue = "") String level,
                             @RequestParam(value = "price",       defaultValue = "0") Double price,
                             @RequestParam(value = "sections",    defaultValue = "0") Integer sections,
                             @RequestParam(value = "duration",    defaultValue = "") String duration,
                             @RequestParam(value = "description", defaultValue = "") String description,
                             @RequestParam(value = "thumbnailUrl", defaultValue = "") String thumbnailUrl,
                             @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile,
                             HttpSession session,
                             RedirectAttributes ra) {
        try {
            // ── Auth ──
            Optional<User> userOpt = getAuthUser(session);
            if (userOpt.isEmpty() || !isInstructorOrAdmin(userOpt.get())) {
                return unauthorized(ra);
            }

            User user = userOpt.get();

            // ── Ownership ──
            if (!courseService.isInstructorOwner(courseId, user.getEmail())
                    && user.getRole() != User.Role.ADMIN) {
                logger.warn("Unauthorized edit attempt: user={}, courseId={}", user.getEmail(), courseId);
                ra.addFlashAttribute("errorMessage", "You are not authorized to edit this course.");
                return REDIRECT_MY_COURSES;
            }

            // ── Load existing course ──
            Course course = courseService.getCourseById(courseId);

            // ── Status guard: PENDING courses cannot be edited ──
            if ("PENDING".equalsIgnoreCase(course.getStatus())) {
                ra.addFlashAttribute("errorMessage",
                        "Course '" + course.getTitle() + "' is under review and cannot be edited right now.");
                return REDIRECT_MY_COURSES;
            }

            // ── Apply updates ──
            if (!title.isBlank())       course.setTitle(title.trim());
            if (!category.isBlank())    course.setCategory(category.trim());
            if (!level.isBlank())       course.setLevel(level.trim());
            if (!duration.isBlank())    course.setDuration(parseDurationToDouble(duration.trim()));
            if (!description.isBlank()) course.setDescription(description.trim());
            course.setPrice(price);

            // ── Save via service (handles thumbnail upload automatically) ──
            Course updatedCourse = courseService.updateCourse(course, thumbnailFile, null);

            logger.info("Course '{}' (id={}) updated by {}", updatedCourse.getTitle(), courseId, user.getEmail());
            ra.addFlashAttribute("successMessage",
                    "'" + updatedCourse.getTitle() + "' has been updated successfully!");

        } catch (Exception e) {
            logger.error("Failed to update course id={}", courseId, e);
            ra.addFlashAttribute("errorMessage", "Failed to save changes. Please try again.");
        }

        return REDIRECT_MY_COURSES;
    }

    // ──────────────────────────────────────────────────────────────
    // PRIVATE UTILITY
    // ──────────────────────────────────────────────────────────────

    /**
     * Parse a duration string like "6h 30m" or "2h" or "45m" into a Double (hours).
     * Falls back to 0.0 on parse failure.
     */
    private Double parseDurationToDouble(String duration) {
        try {
            double hours   = 0;
            double minutes = 0;

            String d = duration.toLowerCase().trim();

            int hIdx = d.indexOf('h');
            int mIdx = d.indexOf('m');

            if (hIdx > 0) {
                hours = Double.parseDouble(d.substring(0, hIdx).trim());
            }
            if (mIdx > 0) {
                int start = (hIdx > 0) ? hIdx + 1 : 0;
                String minPart = d.substring(start, mIdx).trim();
                if (!minPart.isEmpty()) {
                    minutes = Double.parseDouble(minPart);
                }
            }

            return hours + (minutes / 60.0);

        } catch (NumberFormatException e) {
            logger.warn("Could not parse duration '{}', defaulting to 0.0", duration);
            return 0.0;
        }
    }
}