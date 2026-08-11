package com.vp.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "course_sections")
public class CourseSection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    @JsonIgnoreProperties({
        "hibernateLazyInitializer",
        "handler",
        "sections"
    })
    private Course course;

    @Column(nullable = false)
    private String title;

    @Column(length = 1000)
    private String description;

    @Column(name = "order_index")
    private Integer orderIndex = 0;

    @Column(name = "display_order")
    private Integer displayOrder = 0;

    @OneToMany(
        mappedBy = "section",
        cascade = CascadeType.ALL,
        orphanRemoval = true
    )
    @OrderBy("orderIndex ASC")
    @JsonIgnoreProperties("section")
    private List<CourseContent> contents = new ArrayList<>();

    @Column(name = "is_active")
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;


    // Default Constructor
    public CourseSection() {
    }


    // All Arguments Constructor
    public CourseSection(
            Long id,
            Course course,
            String title,
            String description,
            Integer orderIndex,
            Integer displayOrder,
            List<CourseContent> contents,
            Boolean isActive,
            LocalDateTime createdAt,
            LocalDateTime updatedAt) {

        this.id = id;
        this.course = course;
        this.title = title;
        this.description = description;
        this.orderIndex = orderIndex;
        this.displayOrder = displayOrder;
        this.contents = contents;
        this.isActive = isActive;
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

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public List<CourseContent> getContents() {
        return contents;
    }

    public void setContents(List<CourseContent> contents) {
        this.contents = contents;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
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


    // Sync orderIndex and displayOrder

    @PrePersist
    @PreUpdate
    public void syncOrderIndex() {

        if (orderIndex == null && displayOrder != null) {
            orderIndex = displayOrder;
        }

        if (displayOrder == null && orderIndex != null) {
            displayOrder = orderIndex;
        }
    }
}
