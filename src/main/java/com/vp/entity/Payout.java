// ==================== PAYOUT ENTITY ====================
package com.vp.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "payouts")
@Data
public class Payout {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String payoutDisplayId; // e.g., #PAY-2512-001
    
    private Long instructorId;
    private Double amount;
    private String payoutMethod; // BANK_TRANSFER, UPI, PAYPAL
    private String status; // PENDING, COMPLETED, FAILED
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;
    
    @PrePersist
    protected void onCreate() {
        this.requestedAt = LocalDateTime.now();
    }
}