package com.vp.service.student;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.vp.entity.Course;
import com.vp.entity.Enrollment;
import com.vp.entity.User;
import com.vp.repository.CourseRepository;
import com.vp.repository.EnrollmentRepository;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

@Service
public class EnrollmentService {

    @Value("${razorpay.key.id}")
    private String keyId;

    @Value("${razorpay.key.secret}")
    private String keySecret;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private CourseRepository courseRepository; // ← yeh add karo


     // BAAD (sahi) - sirf SUCCESS check karo
     public boolean isAlreadyEnrolled(Long userId, Long courseId) {
	     return enrollmentRepository.existsByUserIdAndCourseIdAndPaymentStatus(userId, courseId, "SUCCESS");
	 }
     public Optional<Enrollment> getLastEnrollmentByUser(Long userId) {
    	    return enrollmentRepository.findTopByUserIdOrderByEnrolledAtDesc(userId);
    	}
    public String createRazorpayOrder(Course course, User user) throws RazorpayException {
    	
    	 // Existing PENDING order ho toh wahi return karo
        Optional<Enrollment> existingPending = enrollmentRepository
            .findByUserIdAndCourseIdAndPaymentStatus(
                user.getId(), course.getId(), "PENDING");
        
        if (existingPending.isPresent()) {
            return existingPending.get().getRazorpayOrderId();
        }

        // Naya order banao
        RazorpayClient client = new RazorpayClient(keyId, keySecret);

        double effectivePrice = course.getEffectivePrice();
        int amountInPaise = (int) (effectivePrice * 100);

        JSONObject orderRequest = new JSONObject();
        orderRequest.put("amount", amountInPaise);
        orderRequest.put("currency", "INR");
        orderRequest.put("receipt", "order_u" + user.getId() + "_c" + course.getId());

        Order order = client.orders.create(orderRequest);

        // Duplicate order check — agar already PENDING hai toh naya mat banao
        boolean alreadyPending = enrollmentRepository
                .findByRazorpayOrderId(order.get("id"))
                .isPresent();

        if (!alreadyPending) {
            Enrollment enrollment = new Enrollment();
            enrollment.setUser(user);
            enrollment.setCourse(course);
            enrollment.setRazorpayOrderId(order.get("id"));
            enrollment.setAmountPaid(effectivePrice);
            enrollment.setPaymentStatus("PENDING");
            enrollmentRepository.save(enrollment);
        }

        return order.get("id");
    }

    public boolean verifyAndConfirmPayment(String orderId, String paymentId, String signature) {
        try {
            // Step 1: Signature verify
            String payload = orderId + "|" + paymentId;
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(
                    keySecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            byte[] hash = mac.doFinal(payload.getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) hexString.append(String.format("%02x", b));
            String generated = hexString.toString();

            if (!generated.equals(signature)) {
                System.err.println("❌ Signature mismatch! Generated: "
                        + generated + " | Received: " + signature);
                return false;
            }

            // Step 2: Enrollment dhundo
            Enrollment enrollment = enrollmentRepository
                    .findByRazorpayOrderId(orderId)
                    .orElseThrow(() -> new RuntimeException(
                            "Enrollment not found for orderId: " + orderId));

            // Step 3: Already SUCCESS? duplicate process mat karo
            if ("SUCCESS".equals(enrollment.getPaymentStatus())) {
                System.out.println("ℹ️ Already verified: " + orderId);
                return true;
            }

            // Step 4: Enrollment update
            enrollment.setRazorpayPaymentId(paymentId);
            enrollment.setRazorpaySignature(signature);
            enrollment.setPaymentStatus("SUCCESS");
            enrollmentRepository.save(enrollment);

            // Step 5: Course enrollment count update — FIX ✅
            Course course = enrollment.getCourse();
            int enrolled  = course.getStudentsEnrolled()  != null ? course.getStudentsEnrolled()  : 0;
            int total     = course.getTotalEnrollments()  != null ? course.getTotalEnrollments()  : 0;
            course.setStudentsEnrolled(enrolled + 1);
            course.setTotalEnrollments(total + 1);
            courseRepository.save(course); // ← yeh missing tha

            System.out.println("✅ Payment verified & enrollment saved for orderId: " + orderId);
            return true;

        } catch (Exception e) {
            System.err.println("❌ verifyAndConfirmPayment error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
}