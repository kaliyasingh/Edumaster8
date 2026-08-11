// ============================================
// 5. CourseContentRepository.java (NEW)
// ============================================
package com.vp.repository;

import com.vp.entity.CourseContent;
import com.vp.entity.CourseSection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseContentRepository extends JpaRepository<CourseContent, Long> {
    
    List<CourseContent> findBySectionOrderByOrderIndex(CourseSection section);
    
    long countBySection(CourseSection section);
}