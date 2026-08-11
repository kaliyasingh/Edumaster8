// ==================== STUDENT Q&A ENTITY ====================
package com.vp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_questions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentQuestion {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Student Info
    @Column(nullable = false)
    private Long studentId;
    
    @Column(nullable = false)
    private String studentName;
    
    @Column
    private String studentInitials; // e.g., "RK" for Rahul Kumar
    
    @Column
    private String studentAvatar;
    
    // Course & Content Info
    @Column(nullable = false)
    private String courseId;
    
    @Column(nullable = false)
    private String courseName;
    
    @Column
    private Long contentId; // Which lecture/video this question is about
    
    @Column
    private String contentTitle; // e.g., "Introduction to Java"
    
    // Question Details
    @Column(nullable = false)
    private String title; // Question title/subject
    
    @Column(columnDefinition = "TEXT", nullable = false)
    private String questionText;
    
    @Column
    private String category; // TECHNICAL, GENERAL, ASSIGNMENT, OTHER
    
    @Column
    private Integer upvotes = 0; // Number of students who found this useful
    
    @Column(nullable = false)
    private String status = "OPEN"; // OPEN, ANSWERED, CLOSED
    
    @Column(nullable = false)
    private LocalDateTime askedAt;
    
    // Instructor Answer
    @Column(nullable = false)
    private Boolean isAnswered = false;
    
    @Column(columnDefinition = "TEXT")
    private String answerText;
    
    @Column
    private Long answeredBy; // Instructor ID
    
    @Column
    private String answeredByName; // Instructor name
    
    @Column
    private LocalDateTime answeredAt;
    
    // Additional flags
    @Column(nullable = false)
    private Boolean isPinned = false; // Pin important Q&A
    
    @Column(nullable = false)
    private Boolean isResolved = false; // Student marked as resolved
    
    @Column
    private Integer viewCount = 0;
    
    @PrePersist
    protected void onCreate() {
        this.askedAt = LocalDateTime.now();
    }
}