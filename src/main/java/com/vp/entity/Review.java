// ==================== REVIEW ENTITY ====================
package com.vp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "reviews")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Review {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Link to Student
    @Column(nullable = false)
    private Long studentId;
    
    @Column(nullable = false)
    private String studentName;
    
    @Column
    private String studentInitials;
    
    // Link to Course
    @Column(nullable = false)
    private String courseId;
    
    @Column
    private String courseName;
    
    @Column(nullable = false)
    private Integer rating; // 1-5
    
    @Column(columnDefinition = "TEXT")
    private String comment;
    
    @Column(nullable = false)
    private String date;
    
    @Column(nullable = false)
    private Boolean verified = false;
    
    // Instructor Reply Fields
    @Column(nullable = false)
    private Boolean replied = false;
    
    @Column(columnDefinition = "TEXT")
    private String reply;
    
    @Column
    private String replyDate;
    
    @Column
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}