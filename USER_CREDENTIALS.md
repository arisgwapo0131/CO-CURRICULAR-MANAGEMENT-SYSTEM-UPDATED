# 🎓 BCP Co-Curricular Management System — 4 Core Accounts

All 4 primary user accounts are pre-configured, tested, and active with the uniform password: **`Password123`**.

---

## 👥 The 4 Core Accounts

| # | Account / Role | Username | Email | Password | Access & Responsibilities |
|---|---|---|---|---|---|
| **1** | **Student** | `student` | `student@bcp.edu.ph` | **`Password123`** | • Generate personal Attendance QR Pass<br>• Real-time attendance auto-sync<br>• Enter ballot booth & vote in elections<br>• Log volunteer community service hours<br>• Download Official PDF Transcripts |
| **2** | **Faculty Adviser** | `adviser` | `adviser@bcp.edu.ph` | **`Password123`** | • Manage CSSEC club & members<br>• Scan student QR passes via terminal<br>• Supervise elections & review turnouts<br>• Review & approve volunteer service hours<br>• Generate event posters & budget vouchers |
| **3** | **SSC Officer** | `ssc` | `ssc@bcp.edu.ph` | **`Password123`** | • Campus-wide event & budget reviews<br>• **Analyze live election tallies (No voting)**<br>• **Proclaim & announce election winners**<br>• Oversee volunteer tracking & audit<br>• Issue official certificates |
| **4** | **System Admin** | `admin` | `admin@bcp.edu.ph` | **`Password123`** | • Full system administration & user control<br>• **Analyze election turnouts (No voting)**<br>• **Proclaim & certify election winners**<br>• System audit logs & volunteer verification<br>• Master PDF generation suite |

---

## 📝 Student Self-Registration
Students can also register their own personalized accounts at:
🔗 **`http://localhost/sms/bcp-cocurricolar-sms-main/app/auth/register.php`**

**Registration Fields:**
- First & Last Name
- Academic Program (BSIT, BSHM, BSAIS, BSTM, BSOA, BSE, BSBA, BSIS, BSCpE, BSPsych, BSCrim, BSPE, TLE, BSElEd, BSSecEd, BSLIS)
- Student ID Number (e.g. `2024-10001`)
- Email & Custom Password

---

## 📲 Student QR Code & Faculty Scanner Workflow
```
┌────────────────────────────┐          ┌────────────────────────────┐
│   Student Account          │          │   Faculty / Adviser        │
│   (tracking_history.php)   │          │   (tracking_scanner.php)   │
│                            │          │                            │
│  1. Displays Student QR    │ ───────> │  2. Scans Student QR Code  │
│     Badge (BCP-STUDENT-id) │          │     via Camera or Barcode  │
└────────────────────────────┘          └──────────────┬─────────────┘
                                                       │
                                        3. Logs Attendance in DB
                                           (method = QR_FACULTY_SCAN)
                                                       │
┌────────────────────────────┐                         │
│   Real-Time Auto Update    │ <───────────────────────┘
│   (tracking_history.php)   │
│                            │
│  4. Row instantly appears  │
│     with green flash &     │
│     audio notification     │
└────────────────────────────┘
```

---

## 🗳️ Election Workflow for SSC & Admin
- **Students**: Cast ballots in the secure ballot booth.
- **Faculty Advisers**: Supervise their club's election pool.
- **SSC & Admin**: **Do not vote**. Instead, they analyze live vote tallies, inspect candidate distributions, and click **"Announce & Proclaim Results"** to officially close the election and broadcast campus-wide proclamations.
