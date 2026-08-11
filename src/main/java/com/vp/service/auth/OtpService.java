package com.vp.service.auth;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpService {

    // Store OTP with email as key
    private final Map<String, OtpData> otpStorage = new ConcurrentHashMap<>();
    
    // OTP expires in 10 minutes
    private static final int OTP_EXPIRY_MINUTES = 10;
    
    // OTP length
    private static final int OTP_LENGTH = 6;

    /**
     * Inner class to store OTP with expiry time
     */
    private static class OtpData {
        String otp;
        LocalDateTime expiryTime;
        int attemptCount;

        OtpData(String otp, LocalDateTime expiryTime) {
            this.otp = otp;
            this.expiryTime = expiryTime;
            this.attemptCount = 0;
        }
    }

    /**
     * Generate a random 6-digit OTP
     */
    public String generateOtp(String email) {
        // Generate random 6-digit OTP
        Random random = new Random();
        int otpNumber = 100000 + random.nextInt(900000);
        String otp = String.valueOf(otpNumber);
        
        // Store OTP with expiry time
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES);
        otpStorage.put(email.toLowerCase(), new OtpData(otp, expiryTime));
        
        // Clean up expired OTPs
        cleanupExpiredOtps();
        
        return otp;
    }

    /**
     * Verify OTP for given email
     */
    public boolean verifyOtp(String email, String otp) {
        String emailKey = email.toLowerCase();
        OtpData otpData = otpStorage.get(emailKey);
        
        if (otpData == null) {
            return false;
        }
        
        // Check if OTP has expired
        if (LocalDateTime.now().isAfter(otpData.expiryTime)) {
            otpStorage.remove(emailKey);
            return false;
        }
        
        // Increment attempt count
        otpData.attemptCount++;
        
        // Block after 5 failed attempts
        if (otpData.attemptCount > 5) {
            otpStorage.remove(emailKey);
            return false;
        }
        
        // Verify OTP
        boolean isValid = otp.equals(otpData.otp);
        
        // Remove OTP after successful verification
        if (isValid) {
            otpStorage.remove(emailKey);
        }
        
        return isValid;
    }

    /**
     * Clear OTP for given email
     */
    public void clearOtp(String email) {
        otpStorage.remove(email.toLowerCase());
    }

    /**
     * Check if OTP exists for email
     */
    public boolean hasOtp(String email) {
        String emailKey = email.toLowerCase();
        OtpData otpData = otpStorage.get(emailKey);
        
        if (otpData == null) {
            return false;
        }
        
        // Check if expired
        if (LocalDateTime.now().isAfter(otpData.expiryTime)) {
            otpStorage.remove(emailKey);
            return false;
        }
        
        return true;
    }

    /**
     * Get remaining time for OTP in seconds
     */
    public long getRemainingTime(String email) {
        String emailKey = email.toLowerCase();
        OtpData otpData = otpStorage.get(emailKey);
        
        if (otpData == null) {
            return 0;
        }
        
        LocalDateTime now = LocalDateTime.now();
        if (now.isAfter(otpData.expiryTime)) {
            otpStorage.remove(emailKey);
            return 0;
        }
        
        return java.time.Duration.between(now, otpData.expiryTime).getSeconds();
    }

    /**
     * Clean up expired OTPs (called periodically)
     */
    private void cleanupExpiredOtps() {
        LocalDateTime now = LocalDateTime.now();
        otpStorage.entrySet().removeIf(entry -> now.isAfter(entry.getValue().expiryTime));
    }

    /**
     * Get OTP attempt count
     */
    public int getAttemptCount(String email) {
        OtpData otpData = otpStorage.get(email.toLowerCase());
        return otpData != null ? otpData.attemptCount : 0;
    }

    /**
     * For testing purposes - get stored OTP (remove in production)
     */
    public String getStoredOtp(String email) {
        OtpData otpData = otpStorage.get(email.toLowerCase());
        return otpData != null ? otpData.otp : null;
    }
}