
// ==================== Q&A REPLY/COMMENT ENTITY ====================
package com.vp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "question_replies")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuestionReply {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private Long questionId; // Links to StudentQuestion
    
    // Reply Author Info
    @Column(nullable = false)
    private Long authorId; // Can be student or instructor
    
    @Column(nullable = false)
    private String authorName;
    
    @Column(nullable = false)
    private String authorType; // STUDENT, INSTRUCTOR
    
    @Column
    private String authorInitials;
    
    @Column
    private String authorAvatar;
    
    // Reply Content
    @Column(columnDefinition = "TEXT", nullable = false)
    private String replyText;
    
    @Column
    private Integer upvotes = 0;
    
    @Column(nullable = false)
    private LocalDateTime repliedAt;
    
    // Optional: Reply to another reply (nested comments)
    @Column
    private Long parentReplyId;
    
    @Column(nullable = false)
    private Boolean isInstructorReply = false;
    
    @Column(nullable = false)
    private Boolean isEdited = false;
    
    @Column
    private LocalDateTime editedAt;
    
    @PrePersist
    protected void onCreate() {
        this.repliedAt = LocalDateTime.now();
    }
}