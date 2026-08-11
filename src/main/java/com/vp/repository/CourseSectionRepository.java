// ============================================
// 4. CourseSectionRepository.java (NEW)
// ============================================
package com.vp.repository;

import com.vp.entity.Course;
import com.vp.entity.CourseSection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseSectionRepository extends JpaRepository<CourseSection, Long> {
    
    List<CourseSection> findByCourseOrderByOrderIndex(Course course);
    
    long countByCourse(Course course);
}