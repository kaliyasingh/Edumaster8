package com.vp.service.auth;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    /**
     * Send OTP email for registration
     */
    public void sendOtpEmail(String toEmail, String fullName, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("EduMaster - Email Verification OTP");

            String htmlContent = buildOtpEmailTemplate(fullName, otp, "registration");
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send OTP email", e);
        }
    }

    /**
     * Send password reset OTP email
     */
    public void sendPasswordResetOtpEmail(String toEmail, String fullName, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("EduMaster - Password Reset OTP");

            String htmlContent = buildOtpEmailTemplate(fullName, otp, "password-reset");
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send password reset email", e);
        }
    }

    /**
     * Send welcome email after successful registration
     */
    public void sendWelcomeEmail(String toEmail, String fullName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Welcome to EduMaster!");

            String htmlContent = buildWelcomeEmailTemplate(fullName);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send welcome email", e);
        }
    }
    
    /**
     * Send instructor registration confirmation email (Pending Approval)
     */
    public void sendInstructorRegistrationConfirmation(String toEmail, String fullName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("EduMaster - Instructor Registration Received");

            String htmlContent = buildInstructorRegistrationConfirmationTemplate(fullName);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send registration confirmation email", e);
        }
    }
    
    /**
     * Send instructor approval email
     */
    public void sendInstructorApprovalEmail(String toEmail, String fullName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("🎉 Congratulations! Your Instructor Application is Approved");

            String htmlContent = buildInstructorApprovalTemplate(fullName);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send approval email", e);
        }
    }
    
    /**
     * Send instructor rejection email
     */
    public void sendInstructorRejectionEmail(String toEmail, String fullName, String reason) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("EduMaster - Update on Your Instructor Application");

            String htmlContent = buildInstructorRejectionTemplate(fullName, reason);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send rejection email", e);
        }
    }

    /**
     * Build OTP email HTML template
     */
    private String buildOtpEmailTemplate(String fullName, String otp, String purpose) {
        String title = purpose.equals("registration") ? "Email Verification" : "Password Reset";
        String description = purpose.equals("registration") 
            ? "Thank you for registering with EduMaster. Please use the OTP below to verify your email address."
            : "You requested to reset your password. Please use the OTP below to complete the process.";

        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center; }" +
                ".header h1 { color: #ffffff; margin: 0; font-size: 28px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".greeting { font-size: 18px; color: #333; margin-bottom: 20px; }" +
                ".description { font-size: 15px; color: #666; line-height: 1.6; margin-bottom: 30px; }" +
                ".otp-box { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 8px; text-align: center; margin: 30px 0; }" +
                ".otp-label { color: #ffffff; font-size: 14px; margin-bottom: 10px; opacity: 0.9; }" +
                ".otp-code { font-size: 36px; font-weight: bold; color: #ffffff; letter-spacing: 8px; font-family: 'Courier New', monospace; }" +
                ".note { background: #f8f9fa; padding: 15px; border-left: 4px solid #667eea; margin: 20px 0; font-size: 13px; color: #666; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; font-size: 12px; color: #999; }" +
                ".warning { color: #e74c3c; font-weight: 600; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎓 EduMaster</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<div class='greeting'>Hello " + fullName + ",</div>" +
                "<div class='description'>" + description + "</div>" +
                "<div class='otp-box'>" +
                "<div class='otp-label'>Your OTP Code</div>" +
                "<div class='otp-code'>" + otp + "</div>" +
                "</div>" +
                "<div class='note'>" +
                "⏱️ <strong>This OTP will expire in 10 minutes.</strong><br>" +
                "🔒 For security reasons, never share this code with anyone." +
                "</div>" +
                "<div class='description'>" +
                "If you didn't request this, please ignore this email or contact our support team." +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "© 2026 EduMaster. All rights reserved.<br>" +
                "This is an automated email. Please do not reply." +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Build welcome email HTML template
     */
    private String buildWelcomeEmailTemplate(String fullName) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px; text-align: center; }" +
                ".header h1 { color: #ffffff; margin: 0; font-size: 32px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".greeting { font-size: 20px; color: #333; margin-bottom: 20px; font-weight: 600; }" +
                ".description { font-size: 15px; color: #666; line-height: 1.8; margin-bottom: 30px; }" +
                ".btn { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; padding: 15px 40px; text-decoration: none; border-radius: 25px; font-weight: 600; margin: 20px 0; }" +
                ".features { margin: 30px 0; }" +
                ".feature { margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 8px; }" +
                ".feature-icon { font-size: 24px; margin-right: 10px; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; font-size: 12px; color: #999; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎉 Welcome to EduMaster!</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<div class='greeting'>Hello " + fullName + ",</div>" +
                "<div class='description'>" +
                "We're thrilled to have you join our learning community! Your account has been successfully created." +
                "</div>" +
                "<div class='features'>" +
                "<div class='feature'>" +
                "<span class='feature-icon'>📚</span>" +
                "<strong>Access Thousands of Courses</strong><br>" +
                "Explore our extensive library of expert-led courses." +
                "</div>" +
                "<div class='feature'>" +
                "<span class='feature-icon'>🎓</span>" +
                "<strong>Learn at Your Own Pace</strong><br>" +
                "Study anytime, anywhere with lifetime access." +
                "</div>" +
                "<div class='feature'>" +
                "<span class='feature-icon'>🏆</span>" +
                "<strong>Earn Certificates</strong><br>" +
                "Get recognized for your achievements." +
                "</div>" +
                "</div>" +
                "<div style='text-align: center;'>" +
                "<a href='#' class='btn'>Start Learning Now</a>" +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "© 2026 EduMaster. All rights reserved.<br>" +
                "Need help? Contact us at support@edumaster.com" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Build instructor registration confirmation email template
     */
    private String buildInstructorRegistrationConfirmationTemplate(String fullName) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px; text-align: center; }" +
                ".header h1 { color: #ffffff; margin: 0; font-size: 28px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".greeting { font-size: 20px; color: #333; margin-bottom: 20px; font-weight: 600; }" +
                ".description { font-size: 15px; color: #666; line-height: 1.8; margin-bottom: 20px; }" +
                ".status-box { background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 30px 0; border-radius: 8px; }" +
                ".status-title { font-size: 18px; color: #856404; font-weight: 600; margin-bottom: 10px; }" +
                ".status-text { font-size: 14px; color: #856404; }" +
                ".info-box { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; }" +
                ".info-title { font-weight: 600; color: #333; margin-bottom: 10px; }" +
                ".info-list { margin: 10px 0; padding-left: 20px; }" +
                ".info-list li { margin: 8px 0; color: #666; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; font-size: 12px; color: #999; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>📧 Registration Received</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<div class='greeting'>Hello " + fullName + ",</div>" +
                "<div class='description'>" +
                "Thank you for your interest in becoming an instructor at EduMaster! We have successfully received your registration application." +
                "</div>" +
                "<div class='status-box'>" +
                "<div class='status-title'>⏳ Application Status: Pending Review</div>" +
                "<div class='status-text'>" +
                "Your application is currently under review by our team. This process typically takes 2-3 business days." +
                "</div>" +
                "</div>" +
                "<div class='info-box'>" +
                "<div class='info-title'>What happens next?</div>" +
                "<ul class='info-list'>" +
                "<li>Our team will review your application and credentials</li>" +
                "<li>You will receive an email notification once the review is complete</li>" +
                "<li>If approved, you'll get access to your instructor dashboard</li>" +
                "</ul>" +
                "</div>" +
                "<div class='description'>" +
                "If you have any questions in the meantime, feel free to contact our support team at support@edumaster.com" +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "© 2026 EduMaster. All rights reserved.<br>" +
                "This is an automated email. Please do not reply." +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Build instructor approval email template
     */
    private String buildInstructorApprovalTemplate(String fullName) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #10b981 0%, #059669 100%); padding: 40px; text-align: center; }" +
                ".header h1 { color: #ffffff; margin: 0; font-size: 32px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".greeting { font-size: 20px; color: #333; margin-bottom: 20px; font-weight: 600; }" +
                ".description { font-size: 15px; color: #666; line-height: 1.8; margin-bottom: 30px; }" +
                ".success-box { background: #d1fae5; border-left: 4px solid #10b981; padding: 20px; margin: 30px 0; border-radius: 8px; text-align: center; }" +
                ".success-icon { font-size: 48px; margin-bottom: 10px; }" +
                ".success-title { font-size: 22px; color: #065f46; font-weight: 700; margin-bottom: 10px; }" +
                ".success-text { font-size: 15px; color: #047857; }" +
                ".btn { display: inline-block; background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: #ffffff; padding: 15px 40px; text-decoration: none; border-radius: 25px; font-weight: 600; margin: 20px 0; }" +
                ".features { margin: 30px 0; }" +
                ".feature { margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 8px; }" +
                ".feature-icon { font-size: 24px; margin-right: 10px; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; font-size: 12px; color: #999; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎉 Welcome Aboard!</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<div class='greeting'>Congratulations, " + fullName + "!</div>" +
                "<div class='success-box'>" +
                "<div class='success-icon'>✅</div>" +
                "<div class='success-title'>Your Application is Approved!</div>" +
                "<div class='success-text'>" +
                "You are now an official EduMaster instructor." +
                "</div>" +
                "</div>" +
                "<div class='description'>" +
                "We're excited to have you join our team of expert instructors. You can now start creating courses and sharing your knowledge with thousands of eager learners." +
                "</div>" +
                "<div class='features'>" +
                "<div class='feature'>" +
                "<span class='feature-icon'>📝</span>" +
                "<strong>Create Your First Course</strong><br>" +
                "Start building engaging content for your students." +
                "</div>" +
                "<div class='feature'>" +
                "<span class='feature-icon'>💰</span>" +
                "<strong>Earn Revenue</strong><br>" +
                "Get paid for every enrollment in your courses." +
                "</div>" +
                "<div class='feature'>" +
                "<span class='feature-icon'>📊</span>" +
                "<strong>Track Your Progress</strong><br>" +
                "Monitor your course performance and student feedback." +
                "</div>" +
                "</div>" +
                "<div style='text-align: center;'>" +
                "<a href='#' class='btn'>Go to Instructor Dashboard</a>" +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "© 2026 EduMaster. All rights reserved.<br>" +
                "Need help? Contact us at instructor-support@edumaster.com" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Build instructor rejection email template
     */
    private String buildInstructorRejectionTemplate(String fullName, String reason) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px; text-align: center; }" +
                ".header h1 { color: #ffffff; margin: 0; font-size: 28px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".greeting { font-size: 20px; color: #333; margin-bottom: 20px; font-weight: 600; }" +
                ".description { font-size: 15px; color: #666; line-height: 1.8; margin-bottom: 20px; }" +
                ".status-box { background: #fee; border-left: 4px solid #dc3545; padding: 20px; margin: 30px 0; border-radius: 8px; }" +
                ".status-title { font-size: 18px; color: #721c24; font-weight: 600; margin-bottom: 15px; }" +
                ".reason-box { background: #f8f9fa; padding: 15px; border-radius: 6px; margin-top: 15px; }" +
                ".reason-label { font-weight: 600; color: #495057; margin-bottom: 8px; }" +
                ".reason-text { color: #6c757d; line-height: 1.6; }" +
                ".info-box { background: #e7f3ff; border-left: 4px solid #0066cc; padding: 20px; margin: 20px 0; border-radius: 8px; }" +
                ".info-text { font-size: 14px; color: #004085; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; font-size: 12px; color: #999; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>📧 Application Update</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<div class='greeting'>Hello " + fullName + ",</div>" +
                "<div class='description'>" +
                "Thank you for your interest in becoming an instructor at EduMaster. We appreciate the time you took to apply." +
                "</div>" +
                "<div class='status-box'>" +
                "<div class='status-title'>Application Status Update</div>" +
                "<div class='description'>" +
                "After careful review, we regret to inform you that we are unable to approve your instructor application at this time." +
                "</div>" +
                "<div class='reason-box'>" +
                "<div class='reason-label'>Reason:</div>" +
                "<div class='reason-text'>" + (reason != null && !reason.isEmpty() ? reason : "Your application did not meet our current requirements.") + "</div>" +
                "</div>" +
                "</div>" +
                "<div class='info-box'>" +
                "<div class='info-text'>" +
                "We encourage you to reapply in the future after addressing the points mentioned above. " +
                "If you have any questions or need clarification, please don't hesitate to contact us at instructor-support@edumaster.com" +
                "</div>" +
                "</div>" +
                "<div class='description'>" +
                "We appreciate your understanding and wish you the best in your future endeavors." +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "© 2026 EduMaster. All rights reserved.<br>" +
                "This is an automated email. Please do not reply." +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}