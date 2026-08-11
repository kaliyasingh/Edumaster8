package com.vp.controller.instructor;

import com.vp.entity.Course;
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

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/instructor")
public class InstructorCreateCourseController {

    private static final Logger logger = LoggerFactory.getLogger(InstructorCreateCourseController.class);

    @Autowired
    private InstructorCourseService courseService;

    // ==================== CREATE COURSE ====================

    /**
     * Create new course
     */
    @PostMapping("/create-course")
    public String createCourse(
            @RequestParam String title,
            @RequestParam String subtitle,
            @RequestParam String category,
            @RequestParam String level,
            @RequestParam String language,
            @RequestParam String description,
            @RequestParam String learningObjectives,
            @RequestParam String prerequisites,
            @RequestParam String targetAudience,
            @RequestParam Double duration,
            @RequestParam(required = false) MultipartFile thumbnail,
            @RequestParam(required = false) String promoVideoUrl,
            @RequestParam(required = false) MultipartFile instructorPhoto,
            @RequestParam Double price,
            @RequestParam(required = false) Double discountPrice,
            @RequestParam String currency,
            @RequestParam(required = false) String couponCode,
            @RequestParam String publishDate,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            // Check authentication
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                logger.warn("Unauthorized course creation attempt");
                return "redirect:/login";
            }

            // Create course object
            Course course = new Course();
            course.setInstructorEmail(instructorEmail);
            course.setTitle(title);
            course.setSubtitle(subtitle);
            course.setCategory(category);
            course.setLevel(level);
            course.setLanguage(language);
            course.setDescription(description);
            course.setLearningObjectives(learningObjectives);
            course.setPrerequisites(prerequisites);
            course.setTargetAudience(targetAudience);
            course.setDuration(duration);
            course.setPromoVideoUrl(promoVideoUrl);
            course.setPrice(price);
            course.setDiscountPrice(discountPrice);
            course.setCurrency(currency);
            course.setCouponCode(couponCode);
            course.setPublishDate(LocalDate.parse(publishDate));
            course.setStatus("DRAFT");

            // Save course
            Course savedCourse = courseService.createCourse(course, thumbnail, instructorPhoto);
            
            logger.info("✅ Course created successfully by {}: {}", instructorEmail, title);
            redirectAttributes.addFlashAttribute("success", "Course created successfully!");
            return "redirect:/instructor/my-courses";

        } catch (Exception e) {
            logger.error("❌ Failed to create course", e);
            redirectAttributes.addFlashAttribute("error", "Failed to create course: " + e.getMessage());
            return "redirect:/instructor/create-course";
        }
    }

    // ==================== GET COURSES ====================

    /**
     * Get all courses for logged-in instructor (AJAX)
     */
    @GetMapping("/my-courses-data")
    @ResponseBody
    public List<Course> getMyCourses(HttpSession session) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return Collections.emptyList();
            }

            return courseService.getCoursesByInstructor(instructorEmail);

        } catch (Exception e) {
            logger.error("Failed to fetch courses", e);
            return Collections.emptyList();
        }
    }

    /**
     * Get single course by ID (AJAX)
     */
    @GetMapping("/course-data/{id}")
    @ResponseBody
    public Course getCourseData(@PathVariable Long id, HttpSession session) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return null;
            }

            Course course = courseService.getCourseById(id);
            
            // Security check: Ensure instructor owns this course
            if (!course.getInstructorEmail().equals(instructorEmail)) {
                logger.warn("Unauthorized access attempt to course {} by {}", id, instructorEmail);
                return null;
            }

            return course;

        } catch (Exception e) {
            logger.error("Failed to fetch course data for ID: {}", id, e);
            return null;
        }
    }

    // ==================== EDIT COURSE ====================

    /**
     * Show edit course page
     */
    @GetMapping("/edit-course/{id}")
    public String showEditCourse(@PathVariable Long id,
                                HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return "redirect:/login";
            }

            Course course = courseService.getCourseById(id);

            // Security check: Ensure instructor owns this course
            if (!course.getInstructorEmail().equals(instructorEmail)) {
                logger.warn("Unauthorized edit attempt for course {} by {}", id, instructorEmail);
                redirectAttributes.addFlashAttribute("error", "Unauthorized access.");
                return "redirect:/instructor/my-courses";
            }

            model.addAttribute("course", course);
            model.addAttribute("currentPage", "edit-course");
            return "instructor/edit-course";

        } catch (Exception e) {
            logger.error("Failed to load edit page for course: {}", id, e);
            redirectAttributes.addFlashAttribute("error", "Course not found.");
            return "redirect:/instructor/my-courses";
        }
    }

    /**
     * Update existing course
     */
    @PostMapping("/update-course/{id}")
    public String updateCourse(
            @PathVariable Long id,
            @RequestParam String title,
            @RequestParam String subtitle,
            @RequestParam String category,
            @RequestParam String level,
            @RequestParam String language,
            @RequestParam String description,
            @RequestParam String learningObjectives,
            @RequestParam String prerequisites,
            @RequestParam String targetAudience,
            @RequestParam Double duration,
            @RequestParam(required = false) MultipartFile thumbnail,
            @RequestParam(required = false) String promoVideoUrl,
            @RequestParam(required = false) MultipartFile instructorPhoto,
            @RequestParam Double price,
            @RequestParam(required = false) Double discountPrice,
            @RequestParam String currency,
            @RequestParam(required = false) String couponCode,
            @RequestParam String publishDate,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return "redirect:/login";
            }

            Course course = courseService.getCourseById(id);

            // Security check
            if (!course.getInstructorEmail().equals(instructorEmail)) {
                logger.warn("Unauthorized update attempt for course {} by {}", id, instructorEmail);
                redirectAttributes.addFlashAttribute("error", "Unauthorized access.");
                return "redirect:/instructor/my-courses";
            }

            // Update course fields
            course.setTitle(title);
            course.setSubtitle(subtitle);
            course.setCategory(category);
            course.setLevel(level);
            course.setLanguage(language);
            course.setDescription(description);
            course.setLearningObjectives(learningObjectives);
            course.setPrerequisites(prerequisites);
            course.setTargetAudience(targetAudience);
            course.setDuration(duration);
            course.setPromoVideoUrl(promoVideoUrl);
            course.setPrice(price);
            course.setDiscountPrice(discountPrice);
            course.setCurrency(currency);
            course.setCouponCode(couponCode);
            course.setPublishDate(LocalDate.parse(publishDate));

            courseService.updateCourse(course, thumbnail, instructorPhoto);

            logger.info("✅ Course updated successfully: {} by {}", id, instructorEmail);
            redirectAttributes.addFlashAttribute("success", "Course updated successfully!");
            return "redirect:/instructor/my-courses";

        } catch (Exception e) {
            logger.error("❌ Failed to update course: {}", id, e);
            redirectAttributes.addFlashAttribute("error", "Failed to update course: " + e.getMessage());
            return "redirect:/instructor/edit-course/" + id;
        }
    }

    // ==================== DELETE COURSE ====================

    /**
     * Delete course
     */
    @PostMapping("/delete-course/{id}")
    public String deleteCourse(@PathVariable Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return "redirect:/login";
            }

            Course course = courseService.getCourseById(id);

            // Security check
            if (!course.getInstructorEmail().equals(instructorEmail)) {
                logger.warn("Unauthorized delete attempt for course {} by {}", id, instructorEmail);
                redirectAttributes.addFlashAttribute("error", "Unauthorized access.");
                return "redirect:/instructor/my-courses";
            }

            courseService.deleteCourse(id);
            
            logger.info("✅ Course deleted: {} by {}", id, instructorEmail);
            redirectAttributes.addFlashAttribute("success", "Course deleted successfully!");

        } catch (Exception e) {
            logger.error("❌ Failed to delete course: {}", id, e);
            redirectAttributes.addFlashAttribute("error", "Failed to delete course: " + e.getMessage());
        }

        return "redirect:/instructor/my-courses";
    }

    /**
     * Delete course (AJAX)
     */
    @DeleteMapping("/delete-course-ajax/{id}")
    @ResponseBody
    public String deleteCourseAjax(@PathVariable Long id, HttpSession session) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return "UNAUTHORIZED";
            }

            Course course = courseService.getCourseById(id);

            if (!course.getInstructorEmail().equals(instructorEmail)) {
                return "UNAUTHORIZED";
            }

            courseService.deleteCourse(id);
            logger.info("✅ Course deleted via AJAX: {} by {}", id, instructorEmail);
            return "SUCCESS";

        } catch (Exception e) {
            logger.error("❌ Failed to delete course via AJAX: {}", id, e);
            return "FAILURE";
        }
    }

    // ==================== TOGGLE STATUS ====================

    /**
     * Toggle course status between DRAFT and PUBLISHED
     */
    @PostMapping("/toggle-course-status/{id}")
    @ResponseBody
    public String toggleCourseStatus(@PathVariable Long id, HttpSession session) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return "UNAUTHORIZED";
            }

            Course course = courseService.getCourseById(id);

            if (!course.getInstructorEmail().equals(instructorEmail)) {
                logger.warn("Unauthorized status toggle attempt for course {} by {}", id, instructorEmail);
                return "UNAUTHORIZED";
            }

            // Toggle between DRAFT and PUBLISHED
            String newStatus = course.getStatus().equals("DRAFT") ? "PUBLISHED" : "DRAFT";
            course.setStatus(newStatus);
            courseService.saveCourse(course);

            logger.info("✅ Course status toggled to {} for course {} by {}", newStatus, id, instructorEmail);
            return "SUCCESS";

        } catch (Exception e) {
            logger.error("❌ Failed to toggle course status: {}", id, e);
            return "FAILURE";
        }
    }

    // ==================== COURSE ANALYTICS ====================

    /**
     * Get course statistics
     */
    @GetMapping("/course-stats/{id}")
    @ResponseBody
    public Object getCourseStats(@PathVariable Long id, HttpSession session) {
        try {
            String instructorEmail = (String) session.getAttribute("userEmail");
            if (instructorEmail == null) {
                return null;
            }

            Course course = courseService.getCourseById(id);

            if (!course.getInstructorEmail().equals(instructorEmail)) {
                return null;
            }

            // Return course statistics
            return new Object() {
                public final Long courseId = course.getId();
                public final String title = course.getTitle();
                public final Integer enrollments = course.getTotalEnrollments();
                public final Integer reviews = course.getTotalReviews();
                public final Double rating = course.getAverageRating();
                public final String status = course.getStatus();
            };

        } catch (Exception e) {
            logger.error("Failed to fetch course stats: {}", id, e);
            return null;
        }
    }
}