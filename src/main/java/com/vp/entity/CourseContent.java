package com.vp.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "course_contents")
public class CourseContent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "section_id", nullable = false)
    @JsonIgnoreProperties({
        "hibernateLazyInitializer",
        "handler",
        "contents"
    })
    private CourseSection section;

    @Column(nullable = false)
    private String title;

    @Column(name = "content_type", nullable = false)
    private String contentType;

    @Column(name = "order_index")
    private Integer orderIndex = 0;


    // Video Fields

    @Column(name = "video_url", length = 500)
    private String videoUrl;

    @Column(name = "video_file_name")
    private String videoFileName;

    @Column(name = "file_url", length = 500)
    private String fileUrl;

    private String duration;

    @Column(name = "duration_seconds")
    private Integer durationSeconds;

    @Column(columnDefinition = "TEXT")
    private String transcript;


    // Document Fields

    @Column(name = "document_file_name")
    private String documentFileName;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(length = 5000)
    private String description;

    private Boolean downloadable = true;


    // Assignment Fields

    @Column(columnDefinition = "TEXT")
    private String instructions;

    @Column(name = "estimated_time")
    private String estimatedTime;

    @Column(name = "estimated_hours")
    private Double estimatedHours;

    @Column(name = "allow_submission")
    private Boolean allowSubmission = false;


    // Shared Resources

    @ElementCollection
    @CollectionTable(
        name = "content_resources",
        joinColumns = @JoinColumn(name = "content_id")
    )
    @Column(name = "resource_name")
    private List<String> resources;


    // Additional Fields

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "is_preview")
    private Boolean isPreview = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;


    // Default Constructor

    public CourseContent() {
    }


    // All Arguments Constructor

    public CourseContent(
            Long id,
            CourseSection section,
            String title,
            String contentType,
            Integer orderIndex,
            String videoUrl,
            String videoFileName,
            String fileUrl,
            String duration,
            Integer durationSeconds,
            String transcript,
            String documentFileName,
            Long fileSize,
            String description,
            Boolean downloadable,
            String instructions,
            String estimatedTime,
            Double estimatedHours,
            Boolean allowSubmission,
            List<String> resources,
            Boolean isActive,
            Boolean isPreview,
            LocalDateTime createdAt,
            LocalDateTime updatedAt) {

        this.id = id;
        this.section = section;
        this.title = title;
        this.contentType = contentType;
        this.orderIndex = orderIndex;
        this.videoUrl = videoUrl;
        this.videoFileName = videoFileName;
        this.fileUrl = fileUrl;
        this.duration = duration;
        this.durationSeconds = durationSeconds;
        this.transcript = transcript;
        this.documentFileName = documentFileName;
        this.fileSize = fileSize;
        this.description = description;
        this.downloadable = downloadable;
        this.instructions = instructions;
        this.estimatedTime = estimatedTime;
        this.estimatedHours = estimatedHours;
        this.allowSubmission = allowSubmission;
        this.resources = resources;
        this.isActive = isActive;
        this.isPreview = isPreview;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }


    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public CourseSection getSection() {
        return section;
    }

    public void setSection(CourseSection section) {
        this.section = section;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getVideoFileName() {
        return videoFileName;
    }

    public void setVideoFileName(String videoFileName) {
        this.videoFileName = videoFileName;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public Integer getDurationSeconds() {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds) {
        this.durationSeconds = durationSeconds;
    }

    public String getTranscript() {
        return transcript;
    }

    public void setTranscript(String transcript) {
        this.transcript = transcript;
    }

    public String getDocumentFileName() {
        return documentFileName;
    }

    public void setDocumentFileName(String documentFileName) {
        this.documentFileName = documentFileName;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getDownloadable() {
        return downloadable;
    }

    public void setDownloadable(Boolean downloadable) {
        this.downloadable = downloadable;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public String getEstimatedTime() {
        return estimatedTime;
    }

    public void setEstimatedTime(String estimatedTime) {
        this.estimatedTime = estimatedTime;
    }

    public Double getEstimatedHours() {
        return estimatedHours;
    }

    public void setEstimatedHours(Double estimatedHours) {
        this.estimatedHours = estimatedHours;
    }

    public Boolean getAllowSubmission() {
        return allowSubmission;
    }

    public void setAllowSubmission(Boolean allowSubmission) {
        this.allowSubmission = allowSubmission;
    }

    public List<String> getResources() {
        return resources;
    }

    public void setResources(List<String> resources) {
        this.resources = resources;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getIsPreview() {
        return isPreview;
    }

    public void setIsPreview(Boolean isPreview) {
        this.isPreview = isPreview;
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


    // Helper Method

    public Integer getDurationInMinutes() {

        if (durationSeconds != null && durationSeconds > 0) {
            return (int) Math.ceil(durationSeconds / 60.0);
        }

        if (duration == null || duration.isEmpty()) {
            return 0;
        }

        try {

            if (!duration.contains(":")) {
                return Integer.parseInt(duration);
            }

            String[] parts = duration.split(":");

            int minutes = Integer.parseInt(parts[0]);

            int seconds = parts.length > 1
                    ? Integer.parseInt(parts[1])
                    : 0;

            return minutes + (seconds > 0 ? 1 : 0);

        } catch (Exception e) {
            return 0;
        }
    }


    // Enum

    public enum ContentType {
        VIDEO,
        DOCUMENT,
        ASSIGNMENT
    }
}