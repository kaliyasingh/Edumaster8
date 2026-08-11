package com.vp.controller.student;

import com.vp.entity.Course;
import com.vp.entity.User;
import com.vp.repository.UserRepository;
import com.vp.service.admin.CourseService;
import com.vp.service.student.EnrollmentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class PaymentController {

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Autowired
    private CourseService courseService;

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private UserRepository userRepository;

    // ── /enroll/{courseId} GET ──
    @GetMapping("/enroll/{courseId}")
    public String showCheckout(@PathVariable Long courseId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login?redirectTo=enroll&courseId=" + courseId;
        }

        if (enrollmentService.isAlreadyEnrolled(userId, courseId)) {
            redirectAttributes.addFlashAttribute("info", "Aap pehle se enrolled hain!");
            return "redirect:/student/dashboard";
        }

        Optional<Course> courseOpt = courseService.getCourseById(courseId);
        if (courseOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Course not found.");
            return "redirect:/";
        }

        session.setAttribute("pendingCourseId", courseId);
        return "redirect:/";
    }

    // ── Create Razorpay Order ──
    @PostMapping("/payment/create-order")
    @ResponseBody
    public Map<String, Object> createOrder(@RequestParam Long courseId,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long userId = (Long) session.getAttribute("userId");

            if (userId == null) {
                result.put("error", "UNAUTHORIZED");
                return result;
            }

            if (enrollmentService.isAlreadyEnrolled(userId, courseId)) {
                result.put("error", "already_purchased");
                return result;
            }

            Optional<Course> courseOpt = courseService.getCourseById(courseId);
            if (courseOpt.isEmpty()) {
                result.put("error", "Course not found");
                return result;
            }
            Course course = courseOpt.get();

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                result.put("error", "User not found");
                return result;
            }
            User user = userOpt.get();

            String razorpayOrderId = enrollmentService.createRazorpayOrder(course, user);

            double finalPrice = (course.getDiscountPrice() != null && course.getDiscountPrice() > 0)
                    ? course.getDiscountPrice() : course.getPrice();
            long amountInPaise = (long)(finalPrice * 100);

            result.put("razorpayOrderId", razorpayOrderId);
            result.put("amount",          amountInPaise);
            result.put("keyId",           razorpayKeyId);

            return result;

        } catch (Exception e) {
            System.err.println("❌ createOrder error: " + e.getMessage());
            result.put("error", e.getMessage());
            return result;
        }
    }

    // ── Payment Verify ──
    @PostMapping("/payment/verify")
    public String verifyPayment(@RequestParam String razorpay_order_id,
                                @RequestParam String razorpay_payment_id,
                                @RequestParam String razorpay_signature,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        boolean success = enrollmentService.verifyAndConfirmPayment(
                razorpay_order_id, razorpay_payment_id, razorpay_signature);

        if (success) {
            Long userId = (Long) session.getAttribute("userId");

            // Student details
            if (userId != null) {
                userRepository.findById(userId).ifPresent(user -> {
                    redirectAttributes.addFlashAttribute("studentName", user.getFullName());
                    redirectAttributes.addFlashAttribute("studentEmail", user.getEmail());
                });

                // Last enrolled course details
                enrollmentService.getLastEnrollmentByUser(userId).ifPresent(enrollment -> {
                    redirectAttributes.addFlashAttribute("courseName",
                            enrollment.getCourse().getTitle());
                    redirectAttributes.addFlashAttribute("instructorName",
                            enrollment.getCourse().getInstructor().getFullName());
                    redirectAttributes.addFlashAttribute("amountPaid",
                            enrollment.getAmountPaid());
                });
            }

            // Order details
            redirectAttributes.addFlashAttribute("orderId", razorpay_order_id);
            redirectAttributes.addFlashAttribute("enrolledDate",
                    LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy")));

            return "redirect:/payment/success";

        } else {
            redirectAttributes.addFlashAttribute("error", "Payment verification failed.");
            return "redirect:/payment/failed";
        }
    }

    // ── Payment Success Page ──  (SIRF EK method — duplicate nahi)
    @GetMapping("/payment/success")
    public String paymentSuccess(HttpSession session, Model model) {

        Long userId = (Long) session.getAttribute("userId");

        // Agar FlashAttributes nahi aaye (direct URL access) toh session se fill karo
        if (userId != null && !model.containsAttribute("studentName")) {
            userRepository.findById(userId).ifPresent(user -> {
                model.addAttribute("studentName", user.getFullName());
                model.addAttribute("studentEmail", user.getEmail());
            });
        }

        return "auth/success";
    }

    // ── Payment Failed Page ──
    @GetMapping("/payment/failed")
    public String paymentFailed() {
        return "auth/failed";
    }
}