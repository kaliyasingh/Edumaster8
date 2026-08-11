package com.vp.service.instructor;

import com.vp.entity.Instructor;
import com.vp.entity.User;
import com.vp.repository.InstructorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
public class InstructorService {

    @Autowired
    private InstructorRepository instructorRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private static final String UPLOAD_DIR = "uploads/instructors/";

    // ==================== REGISTRATION ====================

    public Instructor registerInstructor(Instructor instructor) {
        if (instructor.getEmail() == null || instructor.getEmail().isEmpty())
            throw new RuntimeException("Email is required");
        if (instructor.getFullName() == null || instructor.getFullName().isEmpty())
            throw new RuntimeException("Full name is required");
        if (instructor.getPassword() == null || instructor.getPassword().length() < 8)
            throw new RuntimeException("Password must be at least 8 characters long");
        if (instructorRepository.existsByEmail(instructor.getEmail()))
            throw new RuntimeException("Email already registered");

        instructor.setRole(User.Role.INSTRUCTOR);
        instructor.setPassword(passwordEncoder.encode(instructor.getPassword()));
        instructor.setIsActive(false);
        instructor.setEmailVerified(true);
        instructor.setCreatedAt(LocalDateTime.now());
        instructor.updateTimestamp();

        instructor.setAverageRating(0.0);
        instructor.setTotalStudents(0);
        instructor.setTotalCourses(0);
        instructor.setInstructorVerified(false);
        instructor.setProfilePublic(false);
        instructor.setTotalRevenue(0.0);
        instructor.setAvailableBalance(0.0);
        instructor.setTotalWithdrawn(0.0);

        return instructorRepository.save(instructor);
    }

    public boolean isEmailRegistered(String email) {
        return instructorRepository.existsByEmail(email);
    }

    public Instructor findByEmail(String email) {
        return instructorRepository.findByEmail(email).orElse(null);
    }

    // ==================== FETCH ====================

    /**
     * Get ALL instructors — sirf INSTRUCTOR role wale
     */
    public List<Instructor> getAllInstructors() {
        return instructorRepository.findAll()
                .stream()
                .filter(i -> i.getRole() == User.Role.INSTRUCTOR)
                .collect(Collectors.toList());
    }

    public List<Instructor> getPendingInstructors() {
        return instructorRepository.findPendingInstructors();
    }

    public List<Instructor> getActiveInstructors() {
        return instructorRepository.findActiveInstructors();
    }

    public List<Instructor> getRejectedInstructors() {
        return instructorRepository.findByRejectedAtIsNotNull();
    }

    public long countPendingInstructors() {
        return instructorRepository.countPendingInstructors();
    }

    // ==================== APPROVAL / REJECT / SUSPEND ====================

    /**
     * Approve instructor — sets verified=true, active=true
     */
    public Instructor approveInstructor(Long instructorId) {
        Instructor instructor = getInstructorById(instructorId);

        instructor.setIsActive(true);
        instructor.setInstructorVerified(true);
        instructor.setVerifiedAt(LocalDateTime.now());
        instructor.setProfilePublic(true);
        instructor.setRejectedAt(null);
        instructor.setRejectionReason(null);
        instructor.updateTimestamp();

        return instructorRepository.save(instructor);
    }

    /**
     * Reject instructor with reason
     */
    public Instructor rejectInstructor(Long instructorId, String reason) {
        Instructor instructor = getInstructorById(instructorId);

        instructor.setIsActive(false);
        instructor.setInstructorVerified(false);
        instructor.setRejectedAt(LocalDateTime.now());
        instructor.setRejectionReason(reason != null ? reason : "No reason provided");
        instructor.setProfilePublic(false);
        instructor.setVerifiedAt(null);
        instructor.updateTimestamp();

        return instructorRepository.save(instructor);
    }

    /**
     * Reject without reason (backward compatibility)
     */
    public Instructor rejectInstructor(Long instructorId) {
        return rejectInstructor(instructorId, "No reason provided");
    }

    /**
     * Suspend instructor — same as reject but with "Suspended" reason.
     * Sets isActive=false, instructorVerified=false, rejectedAt=now.
     * Use this for admin bulk-suspend action.
     */
    public Instructor suspendInstructor(Long instructorId, String reason) {
        Instructor instructor = getInstructorById(instructorId);

        instructor.setIsActive(false);
        instructor.setInstructorVerified(false);
        instructor.setRejectedAt(LocalDateTime.now());
        instructor.setRejectionReason(reason != null ? reason : "Suspended by administrator");
        instructor.setProfilePublic(false);
        instructor.updateTimestamp();

        return instructorRepository.save(instructor);
    }

    /**
     * Suspend without custom reason
     */
    public Instructor suspendInstructor(Long instructorId) {
        return suspendInstructor(instructorId, "Suspended by administrator");
    }

    /**
     * Revoke instructor approval
     */
    public Instructor revokeApproval(Long instructorId, String reason) {
        return suspendInstructor(instructorId, reason);
    }

    /**
     * Verify instructor email
     */
    public Instructor verifyEmail(Long instructorId) {
        Instructor instructor = getInstructorById(instructorId);
        instructor.setEmailVerified(true);
        instructor.updateTimestamp();
        return instructorRepository.save(instructor);
    }

    // ==================== PROFILE ====================

    public Instructor getInstructorById(Long id) {
        return instructorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Instructor not found with id: " + id));
    }

    public Instructor updateProfile(Long instructorId, Instructor updatedData) {
        Instructor instructor = getInstructorById(instructorId);

        if (updatedData.getFullName()       != null && !updatedData.getFullName().isEmpty())       instructor.setFullName(updatedData.getFullName());
        if (updatedData.getEmail()          != null && !updatedData.getEmail().isEmpty())           instructor.setEmail(updatedData.getEmail());
        if (updatedData.getPhone()          != null && !updatedData.getPhone().isEmpty())           instructor.setPhone(updatedData.getPhone());
        if (updatedData.getBio()            != null && !updatedData.getBio().isEmpty())             instructor.setBio(updatedData.getBio());
        if (updatedData.getSpecialization() != null && !updatedData.getSpecialization().isEmpty()) instructor.setSpecialization(updatedData.getSpecialization());
        if (updatedData.getPortfolioUrl()   != null && !updatedData.getPortfolioUrl().isEmpty())   instructor.setPortfolioUrl(updatedData.getPortfolioUrl());
        if (updatedData.getLinkedInUrl()    != null && !updatedData.getLinkedInUrl().isEmpty())    instructor.setLinkedInUrl(updatedData.getLinkedInUrl());
        if (updatedData.getHighestDegree()  != null && !updatedData.getHighestDegree().isEmpty())  instructor.setHighestDegree(updatedData.getHighestDegree());
        if (updatedData.getUniversity()     != null && !updatedData.getUniversity().isEmpty())     instructor.setUniversity(updatedData.getUniversity());
        if (updatedData.getGraduationYear() != null)                                               instructor.setGraduationYear(updatedData.getGraduationYear());
        if (updatedData.getExperience()     != null && !updatedData.getExperience().isEmpty())     instructor.setExperience(updatedData.getExperience());
        if (updatedData.getCertifications() != null && !updatedData.getCertifications().isEmpty()) instructor.setCertifications(updatedData.getCertifications());
        if (updatedData.getCredentialUrl()  != null && !updatedData.getCredentialUrl().isEmpty())  instructor.setCredentialUrl(updatedData.getCredentialUrl());

        instructor.updateTimestamp();
        return instructorRepository.save(instructor);
    }

    // ==================== PROFILE PHOTO ====================

    public String uploadProfilePhoto(Long instructorId, MultipartFile file) throws IOException {
        if (file.isEmpty()) throw new RuntimeException("File is empty");

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/"))
            throw new RuntimeException("Only image files are allowed");
        if (file.getSize() > 5 * 1024 * 1024)
            throw new RuntimeException("File size must not exceed 5MB");

        Instructor instructor = getInstructorById(instructorId);
        if (instructor.getProfilePictureUrl() != null)
            deleteProfilePhoto(instructor.getProfilePictureUrl());

        new File(UPLOAD_DIR).mkdirs();

        String original  = file.getOriginalFilename();
        String extension = original != null && original.contains(".")
                ? original.substring(original.lastIndexOf(".")) : ".jpg";
        String filename  = "instructor_" + instructorId + "_" + UUID.randomUUID() + extension;

        Files.copy(file.getInputStream(), Paths.get(UPLOAD_DIR + filename), StandardCopyOption.REPLACE_EXISTING);

        String photoUrl = "/uploads/instructors/" + filename;
        instructor.setProfilePictureUrl(photoUrl);
        instructor.updateTimestamp();
        instructorRepository.save(instructor);
        return photoUrl;
    }

    public void removeProfilePhoto(Long instructorId) {
        Instructor instructor = getInstructorById(instructorId);
        if (instructor.getProfilePictureUrl() != null) {
            deleteProfilePhoto(instructor.getProfilePictureUrl());
            instructor.setProfilePictureUrl(null);
            instructor.updateTimestamp();
            instructorRepository.save(instructor);
        }
    }

    private void deleteProfilePhoto(String photoUrl) {
        try {
            String filename = photoUrl.substring(photoUrl.lastIndexOf("/") + 1);
            Files.deleteIfExists(Paths.get(UPLOAD_DIR + filename));
        } catch (IOException e) {
            System.err.println("Error deleting photo: " + e.getMessage());
        }
    }

    // ==================== PASSWORD ====================

    public void changePassword(Long instructorId, String currentPassword, String newPassword) {
        Instructor instructor = getInstructorById(instructorId);
        if (!passwordEncoder.matches(currentPassword, instructor.getPassword()))
            throw new RuntimeException("Current password is incorrect");
        if (newPassword == null || newPassword.length() < 8)
            throw new RuntimeException("New password must be at least 8 characters long");
        instructor.setPassword(passwordEncoder.encode(newPassword));
        instructor.updateTimestamp();
        instructorRepository.save(instructor);
    }

    // ==================== PAYOUT ====================

    public Instructor updatePayoutSettings(Long instructorId, Instructor payoutData) {
        Instructor instructor = getInstructorById(instructorId);

        if (payoutData.getPayoutMethod()        != null && !payoutData.getPayoutMethod().isEmpty())        instructor.setPayoutMethod(payoutData.getPayoutMethod());
        if (payoutData.getAccountHolderName()   != null && !payoutData.getAccountHolderName().isEmpty())  instructor.setAccountHolderName(payoutData.getAccountHolderName());
        if (payoutData.getBankName()            != null && !payoutData.getBankName().isEmpty())            instructor.setBankName(payoutData.getBankName());
        if (payoutData.getAccountNumber()       != null && !payoutData.getAccountNumber().isEmpty())       instructor.setAccountNumber(payoutData.getAccountNumber());
        if (payoutData.getIfscCode()            != null && !payoutData.getIfscCode().isEmpty())            instructor.setIfscCode(payoutData.getIfscCode());
        if (payoutData.getMinPayoutThreshold()  != null)                                                   instructor.setMinPayoutThreshold(payoutData.getMinPayoutThreshold());
        if (payoutData.getUpiId()               != null && !payoutData.getUpiId().isEmpty())               instructor.setUpiId(payoutData.getUpiId());
        if (payoutData.getPaypalEmail()         != null && !payoutData.getPaypalEmail().isEmpty())         instructor.setPaypalEmail(payoutData.getPaypalEmail());

        instructor.updateTimestamp();
        return instructorRepository.save(instructor);
    }

    // ==================== STATISTICS ====================

    public void incrementCourseCount(Long instructorId) {
        Instructor i = getInstructorById(instructorId);
        i.setTotalCourses((i.getTotalCourses() != null ? i.getTotalCourses() : 0) + 1);
        i.updateTimestamp();
        instructorRepository.save(i);
    }

    public void incrementStudentCount(Long instructorId) {
        Instructor i = getInstructorById(instructorId);
        i.setTotalStudents((i.getTotalStudents() != null ? i.getTotalStudents() : 0) + 1);
        i.updateTimestamp();
        instructorRepository.save(i);
    }

    public void updateRating(Long instructorId, Double newRating) {
        Instructor i = getInstructorById(instructorId);
        i.setAverageRating(newRating);
        i.updateTimestamp();
        instructorRepository.save(i);
    }
}