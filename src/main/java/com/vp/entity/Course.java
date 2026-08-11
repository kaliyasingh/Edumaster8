package com.vp.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Complete Course Entity with Instructor relationship
 */
@Entity
@Table(name = "courses")
public class Course {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ==================== BASIC INFO ====================
    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String subtitle;

    @Column(name = "category")
    private String category;

    @Column(name = "level")
    private String level;

    @Column(name = "language")
    private String language;

    // ==================== DETAILED DESCRIPTION ====================
    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String learningObjectives;

    @Column(columnDefinition = "TEXT")
    private String prerequisites;

    @Column(columnDefinition = "TEXT")
    private String targetAudience;
    
    @Column(columnDefinition = "TEXT")
    private String shortDescription;

    // ==================== MEDIA ====================
    @Column(name = "thumbnailUrl")
    private String thumbnailUrl;

    @Column(name = "promoVideoUrl")
    private String promoVideoUrl;
    
    @Column(name = "previewVideoUrl")
    private String previewVideoUrl;

    // ==================== PRICING ====================
    @Column(name = "price")
    private Double price;

    @Column(name = "discountPrice")
    private Double discountPrice;

    @Column(name = "currency")
    private String currency = "USD";

    @Column(name = "couponCode")
    private String couponCode;

    // ==================== COURSE METRICS ====================
    @Column(name = "duration")
    private Double duration; // In hours

    @Column(name = "lecturesCount")
    private Integer lecturesCount = 0;

    @Column(name = "totalDuration")
    private String totalDuration; // Formatted like "5h 30m"

    // ==================== ENROLLMENT & RATINGS ====================
    @Column(name = "totalEnrollments")
    private Integer totalEnrollments = 0;

    @Column(name = "studentsEnrolled")
    private Integer studentsEnrolled = 0;

    @Column(name = "averageRating")
    private Double averageRating = 0.0;

    @Column(name = "totalReviews")
    private Integer totalReviews = 0;

    // ==================== STATUS & PUBLISHING ====================
    @Column(name = "status")
    private String status = "DRAFT"; // DRAFT, PENDING, APPROVED, LIVE, REJECTED, ARCHIVED

    @Column(name = "publishDate")
    private LocalDate publishDate;
    
    @Column(name = "rejectionReason", columnDefinition = "TEXT")
    private String rejectionReason;

    // ==================== TIMESTAMPS ====================
    @Column(name = "createdAt")
    private LocalDateTime createdAt;

    @Column(name = "updatedAt")
    private LocalDateTime updatedAt;

    // ==================== RELATIONSHIPS ====================
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "instructor_id", referencedColumnName = "id")
    @JsonIgnoreProperties({"password", "courses"})
    private User instructor;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("orderIndex ASC")
    @JsonIgnoreProperties("course")
    private List<CourseSection> sections = new ArrayList<>();

    // ==================== LEGACY FIELDS (for backward compatibility) ====================
    @Column(name = "instructorEmail")
    private String instructorEmail;

    @Column(name = "instructorPhotoUrl")
    private String instructorPhotoUrl;

    // ==================== LIFECYCLE CALLBACKS ====================
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        
        // Sync legacy fields with instructor relationship
        if (this.instructor != null) {
            this.instructorEmail = this.instructor.getEmail();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
        
        // Sync legacy fields with instructor relationship
        if (this.instructor != null) {
            this.instructorEmail = this.instructor.getEmail();
        }
    }

    // ==================== UTILITY METHODS ====================
    
    /**
     * Format duration in human-readable format
     */
    public void calculateTotalDuration() {
        if (duration != null && duration > 0) {
            int hours = duration.intValue();
            int minutes = (int) ((duration - hours) * 60);
            this.totalDuration = hours + "h " + minutes + "m";
        } else {
            this.totalDuration = "0h 0m";
        }
    }

    /**
     * Check if course is published
     */
    @Transient
    public boolean isPublished() {
        return "LIVE".equalsIgnoreCase(this.status) || 
               "PUBLISHED".equalsIgnoreCase(this.status);
    }

    /**
     * Check if course has discount
     */
    @Transient
    public boolean hasDiscount() {
        return discountPrice != null && discountPrice > 0 && discountPrice < price;
    }

    /**
     * Get effective price (discount or regular)
     */
    @Transient
    public Double getEffectivePrice() {
        return hasDiscount() ? discountPrice : price;
    }

    // ==================== GETTERS & SETTERS ====================

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getInstructor() {
        return instructor;
    }

    public void setInstructor(User instructor) {
        this.instructor = instructor;
        if (instructor != null) {
            this.instructorEmail = instructor.getEmail();
        }
    }

    public String getInstructorEmail() {
        // Return from relationship if available, otherwise from legacy field
        if (instructor != null) {
            return instructor.getEmail();
        }
        return instructorEmail;
    }

    public void setInstructorEmail(String instructorEmail) {
        this.instructorEmail = instructorEmail;
    }

    public String getInstructorPhotoUrl() {
        return instructorPhotoUrl;
    }

    public void setInstructorPhotoUrl(String instructorPhotoUrl) {
        this.instructorPhotoUrl = instructorPhotoUrl;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLearningObjectives() {
        return learningObjectives;
    }

    public void setLearningObjectives(String learningObjectives) {
        this.learningObjectives = learningObjectives;
    }

    public String getPrerequisites() {
        return prerequisites;
    }

    public void setPrerequisites(String prerequisites) {
        this.prerequisites = prerequisites;
    }

    public String getTargetAudience() {
        return targetAudience;
    }

    public void setTargetAudience(String targetAudience) {
        this.targetAudience = targetAudience;
    }
    
    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getPromoVideoUrl() {
        return promoVideoUrl;
    }

    public void setPromoVideoUrl(String promoVideoUrl) {
        this.promoVideoUrl = promoVideoUrl;
    }
    
    public String getPreviewVideoUrl() {
        return previewVideoUrl;
    }

    public void setPreviewVideoUrl(String previewVideoUrl) {
        this.previewVideoUrl = previewVideoUrl;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(Double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public Double getDuration() {
        return duration;
    }

    public void setDuration(Double duration) {
        this.duration = duration;
    }

    public Integer getLecturesCount() {
        return lecturesCount;
    }

    public void setLecturesCount(Integer lecturesCount) {
        this.lecturesCount = lecturesCount;
    }

    public String getTotalDuration() {
        return totalDuration;
    }

    public void setTotalDuration(String totalDuration) {
        this.totalDuration = totalDuration;
    }

    public Integer getTotalEnrollments() {
        return totalEnrollments;
    }

    public void setTotalEnrollments(Integer totalEnrollments) {
        this.totalEnrollments = totalEnrollments;
    }

    public Integer getStudentsEnrolled() {
        return studentsEnrolled;
    }

    public void setStudentsEnrolled(Integer studentsEnrolled) {
        this.studentsEnrolled = studentsEnrolled;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }

    public Integer getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(Integer totalReviews) {
        this.totalReviews = totalReviews;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(LocalDate publishDate) {
        this.publishDate = publishDate;
    }
    
    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<CourseSection> getSections() {
        return sections;
    }

    public void setSections(List<CourseSection> sections) {
        this.sections = sections;
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", price=" + price +
                ", studentsEnrolled=" + studentsEnrolled +
                ", averageRating=" + averageRating +
                ", instructor=" + (instructor != null ? instructor.getEmail() : "null") +
                '}';
    }
}