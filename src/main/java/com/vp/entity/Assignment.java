// ==================== ASSIGNMENT ENTITY ====================
package com.vp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "assignments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Assignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Student Info
    @Column(nullable = false)
    private Long studentId;
    
    @Column(nullable = false)
    private String studentName;
    
    // Course Info
    @Column(nullable = false)
    private String courseId;
    
    @Column(nullable = false)
    private String courseName;
    
    // Assignment Details
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false)
    private LocalDateTime submissionDate;
    
    @Column(nullable = false)
    private LocalDateTime dueDate;
    
    @Column(nullable = false)
    private Boolean isLate = false;
    
    // File Data
    @Column(nullable = false)
    private String fileName;
    
    @Column
    private String fileSize;
    
    @Column(nullable = false)
    private String fileUrl;
    
    // Grading Info
    @Column(nullable = false)
    private String status = "PENDING"; // PENDING, REVIEWED
    
    @Column
    private Integer marks; // 0-100
    
    @Column
    private String grade; // A+, A, B, etc.
    
    @Column(columnDefinition = "TEXT")
    private String feedback;
    
    @Column
    private LocalDateTime gradedAt;
    
    @PrePersist
    protected void onCreate() {
        if (submissionDate == null) {
            submissionDate = LocalDateTime.now();
        }
        if (dueDate != null && submissionDate.isAfter(dueDate)) {
            isLate = true;
        }
    }
}