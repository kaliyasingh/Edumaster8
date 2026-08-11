// ==================== TRANSACTION ENTITY ====================
package com.vp.entity;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Data
public class Transaction {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	private String transactionId; // e.g., TXN-12345
	private Long courseId;
	private Long studentId;
	private String studentName; // For easy table display
	private Double amount; // Total paid (Gross)
	private Double platformFee; // 15%
	private Double instructorNet; // 85% (You Get)
	private String status; // COMPLETED, PENDING, REFUNDED, PROCESSING
	private LocalDateTime createdAt;

	@PrePersist
	protected void onCreate() {
		this.createdAt = LocalDateTime.now();
		this.platformFee = this.amount * 0.15;
		this.instructorNet = this.amount - this.platformFee;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public Long getCourseId() {
		return courseId;
	}

	public void setCourseId(Long courseId) {
		this.courseId = courseId;
	}

	public Long getStudentId() {
		return studentId;
	}

	public void setStudentId(Long studentId) {
		this.studentId = studentId;
	}

	public String getStudentName() {
		return studentName;
	}

	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public Double getPlatformFee() {
		return platformFee;
	}

	public void setPlatformFee(Double platformFee) {
		this.platformFee = platformFee;
	}

	public Double getInstructorNet() {
		return instructorNet;
	}

	public void setInstructorNet(Double instructorNet) {
		this.instructorNet = instructorNet;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
}