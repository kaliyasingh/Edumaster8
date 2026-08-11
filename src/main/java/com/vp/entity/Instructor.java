// ==================== INSTRUCTOR ENTITY ====================
package com.vp.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;
import lombok.*;

/**
 * Instructor Entity - Extended from User
 * Represents instructor/teacher profiles with professional details,
 * education, certifications, and verification status
 */
@Entity
@Table(name = "instructors")
@PrimaryKeyJoinColumn(name = "user_id")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Instructor extends User {
    
    // ==================== PROFESSIONAL INFORMATION ====================
    
    /**
     * Primary area of expertise/specialization
     * Can be comma-separated for multiple skills
     * Example: "Web Development, JavaScript, React"
     */
    @Column(name = "specialization", length = 500)
    private String specialization;
    
    /**
     * Detailed professional and teaching experience
     * Max 2000 characters
     */
    @Column(name = "experience", length = 2000)
    private String experience;
    
    /**
     * Average rating from student reviews
     * Scale: 0.0 to 5.0
     */
    @Column(name = "average_rating")
    private Double averageRating = 0.0;
    
    /**
     * Total number of students taught
     */
    @Column(name = "total_students")
    private Integer totalStudents = 0;
    
    /**
     * Total number of courses created
     */
    @Column(name = "total_courses")
    private Integer totalCourses = 0;
    
    // ==================== EDUCATION ====================
    
    /**
     * Highest degree obtained
     * Example: "MBA in Marketing", "B.Tech in Computer Science"
     */
    @Column(name = "highest_degree", length = 100)
    private String highestDegree;
    
    /**
     * University/Institution name
     */
    @Column(name = "university", length = 200)
    private String university;
    
    /**
     * Year of graduation
     * Range: 1950-2030
     */
    @Column(name = "graduation_year")
    private Integer graduationYear;
    
    // ==================== CERTIFICATIONS & CREDENTIALS ====================
    
    /**
     * Professional certifications (comma-separated)
     * Example: "AWS Certified, Google Cloud Professional, Oracle Java SE 11"
     */
    @Column(name = "certifications", length = 1000)
    private String certifications;
    
    /**
     * URL to verify credentials/certifications
     */
    @Column(name = "credential_url", length = 500)
    private String credentialUrl;
    
    
    // ==================== PROFESSIONAL LINKS ====================
    
    /**
     * Personal portfolio website URL
     */
    @Column(name = "portfolio_url", length = 500)
    private String portfolioUrl;
    
    /**
     * LinkedIn profile URL
     */
    @Column(name = "linkedin_url", length = 500)
    private String linkedInUrl;
    
    
    // ==================== VERIFICATION STATUS ====================
    
    /**
     * Whether instructor is verified/approved by admin
     */
    @Column(name = "instructor_verified")
    private Boolean instructorVerified = false;
    
    /**
     * Timestamp when instructor was verified
     */
    @Column(name = "verified_at")
    private LocalDateTime verifiedAt;
    
    /**
     * Timestamp when instructor was rejected (if applicable)
     */
    @Column(name = "rejected_at")
    private LocalDateTime rejectedAt;
    
    /**
     * Reason for rejection (if applicable)
     */
    @Column(name = "rejection_reason", length = 500)
    private String rejectionReason;
    
    /**
     * Admin who approved/rejected the instructor
     */
    @Column(name = "reviewed_by")
    private Long reviewedBy; // Admin user ID
    
    // ==================== PAYOUT & BANKING DETAILS ====================
    
    /**
     * Preferred payout method
     * Values: "BANK_TRANSFER", "PAYPAL", "UPI"
     */
    @Column(name = "payout_method", length = 50)
    private String payoutMethod;
    
    /**
     * Bank name for bank transfers
     */
    @Column(name = "bank_name", length = 100)
    private String bankName;
    
    /**
     * Bank account number
     */
    @Column(name = "account_number", length = 50)
    private String accountNumber;
    
    /**
     * IFSC code for Indian banks
     */
    @Column(name = "ifsc_code", length = 20)
    private String ifscCode;
    
    /**
     * Account holder name
     */
    @Column(name = "account_holder_name", length = 100)
    private String accountHolderName;
    
    /**
     * Minimum payout threshold amount
     */
    @Column(name = "min_payout_threshold")
    private Integer minPayoutThreshold;
    
    /**
     * UPI ID for UPI payments
     */
    @Column(name = "upi_id", length = 100)
    private String upiId;
    
    /**
     * PayPal email for PayPal payments
     */
    @Column(name = "paypal_email", length = 100)
    private String paypalEmail;
    
    // ==================== REVENUE & EARNINGS ====================
    
    /**
     * Total revenue earned by instructor
     */
    @Column(name = "total_revenue")
    private Double totalRevenue = 0.0;
    
    /**
     * Available balance for withdrawal
     */
    @Column(name = "available_balance")
    private Double availableBalance = 0.0;
    
    /**
     * Total amount withdrawn
     */
    @Column(name = "total_withdrawn")
    private Double totalWithdrawn = 0.0;
    
    // ==================== PROFILE VISIBILITY ====================
    
    /**
     * Whether instructor profile is publicly visible
     */
    @Column(name = "profile_public")
    private Boolean profilePublic = true;
    
    /**
     * Bio/About section (shorter version for profile cards)
     */
    @Column(name = "bio", length = 500)
    private String bio;
    
    // ==================== HELPER METHODS ====================
    
    /**
     * Update the timestamp - delegates to parent User class
     */
    public void updateTimestamp() {
        this.setUpdatedAt(LocalDateTime.now());
    }
    
    /**
     * Check if instructor is approved and can teach
     */
    public boolean canTeach() {
        return this.instructorVerified != null && this.instructorVerified && this.rejectedAt == null;
    }
    
    /**
     * Check if instructor is pending approval
     */
    public boolean isPending() {
        return (this.instructorVerified == null || !this.instructorVerified) && this.rejectedAt == null;
    }
    
    /**
     * Check if instructor was rejected
     */
    public boolean isRejected() {
        return this.rejectedAt != null;
    }
    
    /**
     * Approve the instructor
     */
    public void approve(Long adminId) {
        this.instructorVerified = true;
        this.verifiedAt = LocalDateTime.now();
        this.rejectedAt = null;
        this.rejectionReason = null;
        this.reviewedBy = adminId;
        this.updateTimestamp();
    }
    
    /**
     * Reject the instructor
     */
    public void reject(Long adminId, String reason) {
        this.instructorVerified = false;
        this.rejectedAt = LocalDateTime.now();
        this.rejectionReason = reason;
        this.reviewedBy = adminId;
        this.updateTimestamp();
    }
    
    /**
     * Update revenue and balance
     */
    public void addRevenue(Double amount) {
        if (amount != null && amount > 0) {
            this.totalRevenue = (this.totalRevenue != null ? this.totalRevenue : 0.0) + amount;
            this.availableBalance = (this.availableBalance != null ? this.availableBalance : 0.0) + amount;
            this.updateTimestamp();
        }
    }
    
    /**
     * Process withdrawal
     */
    public boolean processWithdrawal(Double amount) {
        if (amount != null && amount > 0 && this.availableBalance != null && this.availableBalance >= amount) {
            this.availableBalance -= amount;
            this.totalWithdrawn = (this.totalWithdrawn != null ? this.totalWithdrawn : 0.0) + amount;
            this.updateTimestamp();
            return true;
        }
        return false;
    }
    
    /**
     * Get formatted average rating (1 decimal place)
     */
    public String getFormattedRating() {
        if (this.averageRating == null) return "0.0";
        return String.format("%.1f", this.averageRating);
    }
    
    /**
     * Get experience years from the experience text (if format is "X years")
     */
    public Integer getExperienceYears() {
        if (this.experience == null) return null;
        try {
            // Try to extract number followed by "years" or "yrs"
            String exp = this.experience.toLowerCase();
            if (exp.contains("year")) {
                String[] words = exp.split("\\s+");
                for (int i = 0; i < words.length - 1; i++) {
                    if (words[i + 1].contains("year") || words[i + 1].contains("yr")) {
                        return Integer.parseInt(words[i].replaceAll("[^0-9]", ""));
                    }
                }
            }
        } catch (Exception e) {
            // Ignore parsing errors
        }
        return null;
    }
    
    // ==================== GETTERS AND SETTERS ====================
    // Lombok @Data generates these automatically, but you can override if needed
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getExperience() {
        return experience;
    }
    
    public void setExperience(String experience) {
        this.experience = experience;
    }
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Integer getTotalStudents() {
        return totalStudents;
    }
    
    public void setTotalStudents(Integer totalStudents) {
        this.totalStudents = totalStudents;
    }
    
    public Integer getTotalCourses() {
        return totalCourses;
    }
    
    public void setTotalCourses(Integer totalCourses) {
        this.totalCourses = totalCourses;
    }
    
    public String getHighestDegree() {
        return highestDegree;
    }
    
    public void setHighestDegree(String highestDegree) {
        this.highestDegree = highestDegree;
    }
    
    public String getUniversity() {
        return university;
    }
    
    public void setUniversity(String university) {
        this.university = university;
    }
    
    public Integer getGraduationYear() {
        return graduationYear;
    }
    
    public void setGraduationYear(Integer graduationYear) {
        this.graduationYear = graduationYear;
    }
    
    public String getCertifications() {
        return certifications;
    }
    
    public void setCertifications(String certifications) {
        this.certifications = certifications;
    }
    
    public String getCredentialUrl() {
        return credentialUrl;
    }
    
    public void setCredentialUrl(String credentialUrl) {
        this.credentialUrl = credentialUrl;
    }
    
    public String getPortfolioUrl() {
        return portfolioUrl;
    }
    
    public void setPortfolioUrl(String portfolioUrl) {
        this.portfolioUrl = portfolioUrl;
    }
    
    public String getLinkedInUrl() {
        return linkedInUrl;
    }
    
    public void setLinkedInUrl(String linkedInUrl) {
        this.linkedInUrl = linkedInUrl;
    }
    
    
    public Boolean getInstructorVerified() {
        return instructorVerified;
    }
    
    public void setInstructorVerified(Boolean instructorVerified) {
        this.instructorVerified = instructorVerified;
    }
    
    public LocalDateTime getVerifiedAt() {
        return verifiedAt;
    }
    
    public void setVerifiedAt(LocalDateTime verifiedAt) {
        this.verifiedAt = verifiedAt;
    }
    
    public LocalDateTime getRejectedAt() {
        return rejectedAt;
    }
    
    public void setRejectedAt(LocalDateTime rejectedAt) {
        this.rejectedAt = rejectedAt;
    }
    
    public String getRejectionReason() {
        return rejectionReason;
    }
    
    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }
    
    public Long getReviewedBy() {
        return reviewedBy;
    }
    
    public void setReviewedBy(Long reviewedBy) {
        this.reviewedBy = reviewedBy;
    }
    
    public String getPayoutMethod() {
        return payoutMethod;
    }
    
    public void setPayoutMethod(String payoutMethod) {
        this.payoutMethod = payoutMethod;
    }
    
    public String getBankName() {
        return bankName;
    }
    
    public void setBankName(String bankName) {
        this.bankName = bankName;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public String getIfscCode() {
        return ifscCode;
    }
    
    public void setIfscCode(String ifscCode) {
        this.ifscCode = ifscCode;
    }
    
    public String getAccountHolderName() {
        return accountHolderName;
    }
    
    public void setAccountHolderName(String accountHolderName) {
        this.accountHolderName = accountHolderName;
    }
    
    public Integer getMinPayoutThreshold() {
        return minPayoutThreshold;
    }
    
    public void setMinPayoutThreshold(Integer minPayoutThreshold) {
        this.minPayoutThreshold = minPayoutThreshold;
    }
    
    public String getUpiId() {
        return upiId;
    }
    
    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }
    
    public String getPaypalEmail() {
        return paypalEmail;
    }
    
    public void setPaypalEmail(String paypalEmail) {
        this.paypalEmail = paypalEmail;
    }
    
    public Double getTotalRevenue() {
        return totalRevenue;
    }
    
    public void setTotalRevenue(Double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    public Double getAvailableBalance() {
        return availableBalance;
    }
    
    public void setAvailableBalance(Double availableBalance) {
        this.availableBalance = availableBalance;
    }
    
    public Double getTotalWithdrawn() {
        return totalWithdrawn;
    }
    
    public void setTotalWithdrawn(Double totalWithdrawn) {
        this.totalWithdrawn = totalWithdrawn;
    }
    
    public Boolean getProfilePublic() {
        return profilePublic;
    }
    
    public void setProfilePublic(Boolean profilePublic) {
        this.profilePublic = profilePublic;
    }
    
    public String getBio() {
        return bio;
    }
    
    public void setBio(String bio) {
        this.bio = bio;
    }
}