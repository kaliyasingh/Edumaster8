// ==================== COURSE DETAILS ENTITY ====================
package com.vp.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "course_details")
@Data
public class CourseDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    private String subtitle;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private String category;
    private String level;
    private String language;
    private String status;   // LIVE, PENDING, DRAFT
    private String thumbnailUrl;
    private Double price;
    
    // Pre-calculated stats
    private Integer lecturesCount = 0;
    private String totalDuration;
    private Integer studentsEnrolled = 0;
    private Double averageRating = 0.0;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}