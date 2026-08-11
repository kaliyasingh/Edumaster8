// ==================== STUDENT PROGRESS ENTITY ====================
package com.vp.entity;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_progress")
@Data
public class StudentProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long studentId;
    private String studentName; 
    private String studentEmail;
    private String avatarUrl;
    private String courseId;
    private String courseName;
    
    // Learning Stats
    private Integer videoProgress;
    private String currentLesson;
    private Integer resourcesUsed;
    
    // Assignment Stats
    private Integer assignmentsSubmitted;
    private Integer totalAssignments;
    private String instructorGrade; 
    private LocalDateTime lastSubmissionDate;
    
    // Activity
    private String status; // ACTIVE, COMPLETED
    private LocalDateTime enrolledDate;
    private LocalDateTime lastActive;
    
    @PrePersist
    protected void onCreate() {
        this.enrolledDate = LocalDateTime.now();
        this.lastActive = LocalDateTime.now();
    }
}
