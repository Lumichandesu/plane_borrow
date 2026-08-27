# ✈️ SkyChauffeur - Airplane Borrowing & Management System

ระบบจัดการและยืม-คืนเครื่องบิน (Airplane / Private Jet Rental & Fleet Management System) พัฒนาขึ้นด้วย **Flutter** สำหรับ Mobile Application และ **Node.js (Express.js) + MySQL** สำหรับ Backend REST API โดยแบ่งสิทธิ์การใช้งานตามบทบาท (Role-based Access Control) ครอบคลุมตั้งแต่ขั้นตอนการขอยืม การอนุมัติ การจัดการเครื่องบิน และการส่งคืน

---

## 📑 สารบัญ (Table of Contents)
1. [ภาพรวมระบบ (Overview)](#-ภาพรวมระบบ-overview)
2. [บทบาทและฟีเจอร์หลัก (Key Features by Role)](#-บทบาทและฟีเจอร์หลัก-key-features-by-role)
3. [เทคโนโลยีที่ใช้ (Tech Stack)](#-เทคโนโลยีที่ใช้-tech-stack)
4. [โครงสร้างโปรเจกต์ (Project Structure)](#-โครงสร้างโปรเจกต์-project-structure)
5. [โครงสร้างฐานข้อมูล (Database Schema)](#-โครงสร้างฐานข้อมูล-database-schema)
6. [API Endpoints Reference](#-api-endpoints-reference)
7. [ขั้นตอนการติดตั้งและเริ่มใช้งาน (Installation & Setup)](#-ขั้นตอนการติดตั้งและเริ่มใช้งาน-installation--setup)
8. [หมายเหตุและการตั้งค่าเพิ่มเติม (Configuration Notes)](#-หมายเหตุและการตั้งค่าเพิ่มเติม-configuration-notes)

---

## 🌟 ภาพรวมระบบ (Overview)

**SkyChauffeur** ออกแบบมาเพื่ออำนวยความสะดวกในการบริหารจัดการและจัดสรรการใช้งานเครื่องบิน ไม่ว่าจะเป็นการฝึกบินสำหรับนักศึกษา หรือการจัดการเครื่องบินส่วนบุคคล โดยมีระบบแบ่งการทำงาน 3 บทบาทหลัก:
- **Student (นักศึกษา/ผู้ยืม)**: ค้นหาเครื่องบิน ขอยืมตามวัน-เวลาที่กำหนด และติดตามสถานะ
- **Lecturer (อาจารย์/ผู้อนุมัติ)**: พิจารณาอนุมัติหรือปฏิเสธคำขอยืม พร้อมดูสถิติการใช้งาน
- **Staff (เจ้าหน้าที่/ผู้ดูแล)**: จัดการข้อมูลเครื่องบิน (เพิ่ม/ลบ/แก้ไข), บันทึกการรับคืน และดูแดชบอร์ดภาพรวม

---

## 👥 บทบาทและฟีเจอร์หลัก (Key Features by Role)

| บทบาท (Role) | สิทธิ์และฟังก์ชันการใช้งาน |
| :--- | :--- |
| **🎓 Student (Role ID: 1)** | • ดูรายการเครื่องบินพร้อมสถานะความพร้อม (Available / Unavailable / Pending)<br>• ดูรายละเอียดเฉพาะของเครื่องบิน (ที่นั่ง, Tail Number, รายละเอียดรุ่น)<br>• ส่งคำขอยืมเครื่องบิน ระบุวันที่ยืม (Borrow Date) และวันที่คืน (Return Date)<br>• ตรวจสอบสถานะคำขอ (Pending / Approved / Rejected)<br>• ดูประวัติการยืมเครื่องบินของตนเอง |
| **👨‍🏫 Lecturer (Role ID: 3)** | • ดูรายการเครื่องบินในระบบ<br>• ตรวจสอบคำขอยืมเครื่องบินจากนักศึกษา<br>• ทำการอนุมัติ (Approve) หรือปฏิเสธ (Reject) คำขอ<br>• ดูแดชบอร์ดสถานะเครื่องบิน (Available / Borrowed / Disabled)<br>• ตรวจสอบประวัติการอนุมัติคำขอ |
| **🛠️ Staff (Role ID: 2)** | • ดูรายการและจัดการข้อมูลเครื่องบินทั้งหมด (CRUD Management)<br>• เพิ่มเครื่องบินใหม่ (Add Plane) พร้อมรูปภาพ รายละเอียด และสถานะเริ่มต้น<br>• แก้ไขข้อมูลเครื่องบิน (Edit Plane)<br>• ลบข้อมูลเครื่องบินที่ไม่ใช้งาน (Delete Plane)<br>• บันทึกรับคืนเครื่องบิน (Plane Return) และอัปเดตสถานะคืนสำเร็จ<br>• แดชบอร์ดสรุปสถิติจำนวนเครื่องบินตามสถานะ<br>• ตรวจสอบประวัติการยืม-คืนทั้งหมดในระบบ |

---

## 💻 เทคโนโลยีที่ใช้ (Tech Stack)

### Frontend (Mobile Application)
- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK >= 3.3.0)
- **UI Design**: Material Design
- **State & Storage**: `shared_preferences` (จัดเก็บ Auth Token และ User Session)
- **Networking**: `http` (REST API Client)
- **Utilities**: `intl` (จัดการรูปแบบวันที่และเวลา), `image_picker` (อัปโหลดรูปภาพ)

### Backend (REST API Server)
- **Runtime**: [Node.js](https://nodejs.org/)
- **Framework**: Express.js
- **Database Driver**: `mysql2`
- **Security & Auth**: JWT (`jsonwebtoken`), SHA-256 / `bcrypt` สำหรับเข้ารหัสรหัสผ่าน
- **Middleware**: `cors`, `body-parser`

### Database
- **Database**: MySQL / MariaDB (เช่น ผ่าน XAMPP หรือ MySQL Server)

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)

```text
plane_borrow-main/
├── assets/
│   └── images/                     # รูปภาพเครื่องบินและไอคอนในแอปพลิเคชัน
│       ├── Beechcraft Bonanza G36.png
│       ├── CESSANA 172.png
│       ├── Cirrus SR-22T.png
│       ├── Diamond DA40.png
│       ├── Embraer Phonom 300.png
│       ├── Gulfstream G280.png
│       └── airplane.jpg
├── lib/
│   ├── main.dart                   # จุดเริ่มต้นแอปพลิเคชัน (Entry Point)
│   ├── pages/
│   │   ├── Welcome.dart            # หน้าต้อนรับ (Landing/Splash)
│   │   ├── Loginpage.dart          # หน้าเข้าสู่ระบบ (จำแนกตาม role_id)
│   │   └── Register.dart           # หน้าลงทะเบียนผู้ใช้ใหม่
│   └── Desige/
│       ├── student/                # หน้าจอสำหรับนักศึกษา (Student)
│       │   ├── Home_Student.dart
│       │   ├── Listplane_Student.dart
│       │   ├── Request_Student.dart
│       │   └── History_Student.dart
│       ├── lecture/                # หน้าจอสำหรับอาจารย์ (Lecturer)
│       │   ├── Home_lecture.dart
│       │   ├── Listplane_lecture.dart
│       │   ├── Requestlist_lecture.dart
│       │   ├── Dashboard_lecture.dart
│       │   └── History_lecture.dart
│       └── Staff/                  # หน้าจอสำหรับเจ้าหน้าที่ (Staff)
│           ├── Home_Staff.dart
│           ├── Listplane_staff.dart
│           ├── AddPlane.dart
│           ├── Editplane.dart
│           ├── Return_staff.dart
│           ├── dashboard_staff.dart
│           └── History_staff.dart
├── package.json                    # รายการ Dependencies สำหรับ Node.js
├── pubspec.yaml                    # การตั้งค่า Flutter และ Dependencies
├── server.js                       # Express API Server หลัก
└── testConnection.js               # สคริปต์ทดสอบการเชื่อมต่อฐานข้อมูล MySQL
```

---

## 🗄️ โครงสร้างฐานข้อมูล (Database Schema)

สร้างฐานข้อมูลชื่อ `plane_borrow` และตารางที่จำเป็นด้วยคำสั่ง SQL ด้านล่าง:

```sql
CREATE DATABASE IF NOT EXISTS `plane_borrow` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `plane_borrow`;

-- 1. ตารางข้อมูลผู้ใช้งาน (Users)
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL COMMENT '1: Student, 2: Staff, 3: Lecturer',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ตารางข้อมูลเครื่องบิน (Plane)
CREATE TABLE IF NOT EXISTS `plane` (
  `planeID` INT AUTO_INCREMENT PRIMARY KEY,
  `planeName` VARCHAR(150) NOT NULL,
  `planeTitle` VARCHAR(150) DEFAULT 'General Aviation',
  `status` INT DEFAULT 1 COMMENT '0: Disabled/Unavailable, 1: Available, 2: Borrowed/Pending',
  `category` VARCHAR(100) DEFAULT 'General',
  `seat` VARCHAR(50) NOT NULL,
  `planeDescription` TEXT,
  `tailNumber` VARCHAR(50) NOT NULL,
  `image` VARCHAR(255) DEFAULT 'airplane.jpg'
);

-- 3. ตารางคำขอยืมเครื่องบิน (rqtPlane)
CREATE TABLE IF NOT EXISTS `rqtPlane` (
  `requestID` INT AUTO_INCREMENT PRIMARY KEY,
  `planeID` INT NOT NULL,
  `rqtBy` INT NOT NULL,
  `bDate` DATE NOT NULL,
  `rDate` DATE NOT NULL,
  `rqtStatus` INT DEFAULT 0 COMMENT '0: Pending, 1: Approved, 2: Rejected',
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`rqtBy`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`planeID`) REFERENCES `plane`(`planeID`) ON DELETE CASCADE
);

-- 4. ตารางประวัติการยืม-คืน (History)
CREATE TABLE IF NOT EXISTS `history` (
  `historyId` INT AUTO_INCREMENT PRIMARY KEY,
  `planeId` INT NOT NULL,
  `rqtBy` INT NOT NULL,
  `bDate` DATE NOT NULL,
  `rDate` DATE NOT NULL,
  `approved` INT COMMENT 'User ID ของผู้อนุมัติ (Lecturer/Staff)',
  `Lender` INT COMMENT 'User ID ของผู้ให้ยืม/เจ้าหน้าที่',
  `ApprovedStatus` INT DEFAULT 1 COMMENT '1: Approved, 0: Rejected',
  `ReturnStaus` INT DEFAULT 0 COMMENT '0: Not Return, 1: Returned',
  FOREIGN KEY (`rqtBy`) REFERENCES `users`(`id`),
  FOREIGN KEY (`planeId`) REFERENCES `plane`(`planeID`)
);
```

---

## 🔌 API Endpoints Reference

ระบบ Backend รันที่พอร์ตเริ่มต้น `3000` (`http://localhost:3000`)

### 1. Authentication (การเข้าสู่ระบบและสมัครสมาชิก)
| Method | Endpoint | Description | Body / Params |
| :--- | :--- | :--- | :--- |
| `POST` | `/register` | ลงทะเบียนผู้ใช้งานใหม่ | `{ "username", "email", "password", "role_id" }` |
| `POST` | `/login` | เข้าสู่ระบบและรับ JWT Token | `{ "username", "password" }` |

### 2. Plane Fleet Management (จัดการข้อมูลเครื่องบิน)
| Method | Endpoint | Description | Body / Params |
| :--- | :--- | :--- | :--- |
| `GET` | `/plane` | ดึงรายการเครื่องบินทั้งหมด | - |
| `GET` | `/plane/:planeID` | ดึงข้อมูลเครื่องบินตาม ID | `planeID` (URL param) |
| `POST` | `/addplane` | เพิ่มเครื่องบินใหม่เข้าสู่ระบบ | `{ "planeName", "planeTitle", "status", "category", "seat", "planeDescription", "tailNumber", "image" }` |
| `PUT` | `/updateplane/:planeID` | อัปเดตข้อมูลเครื่องบิน | `{ "planeName", "status", "category", "seat", "tailNumber", ... }` |
| `DELETE` | `/plane/:planeID` | ลบเครื่องบินออกจากระบบ | `planeID` (URL param) |

### 3. Borrowing & Approval (การขอยืมและอนุมัติ)
| Method | Endpoint | Description | Body / Params |
| :--- | :--- | :--- | :--- |
| `GET` | `/RequestStudent/:rqtBy` | ดึงคำขอยืมของนักศึกษาตาม User ID | `rqtBy` (Header: Authorization Bearer Token) |
| `GET` | `/RequestLecture` | ดึงรายการคำขอยืมทั้งหมดให้อาจารย์ตรวจสอบ | - |
| `PUT` | `/UpdateRequestStatus` | อัปเดตสถานะคำขอ (Approve / Reject) | `{ "requestID", "rqtStatus" }` |

### 4. Return Management (การคืนเครื่องบิน)
| Method | Endpoint | Description | Body / Params |
| :--- | :--- | :--- | :--- |
| `GET` | `/Returnplane` | ดึงรายการที่อยู่ระหว่างการยืมเพื่อรอรับคืน | - |
| `PUT` | `/UpdateReturnStatus/:rqtBy` | อัปเดตสถานะการคืนเครื่องบิน (`status=1`) และเปลี่ยนสถานะเครื่องบินเป็น Available | `{ "status": 1, "planeID": <id> }` |

### 5. Dashboard & History (แดชบอร์ดและประวัติ)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/asset-status` | สรุปจำนวนเครื่องบิน: `borrowed_assets`, `available_assets`, `disabled_assets` |
| `POST` | `/HistoryStudent/:rqtBy` | ประวัติการยืมของนักศึกษา |
| `POST` | `/HistoryLecture/:approved` | ประวัติการอนุมัติของอาจารย์ |
| `POST` | `/HistoryStaff` | ประวัติการยืม-คืนทั้งหมดสำหรับเจ้าหน้าที่ |

---

## 🚀 ขั้นตอนการติดตั้งและเริ่มใช้งาน (Installation & Setup)

### 1. การเตรียมความพร้อม (Prerequisites)
- ติดตั้ง [Flutter SDK](https://docs.flutter.dev/get-started/install) (เวอร์ชัน 3.3.0 ขึ้นไป)
- ติดตั้ง [Node.js](https://nodejs.org/) (เวอร์ชัน 18 ขึ้นไป)
- ติดตั้ง MySQL Database (เช่น [XAMPP](https://www.apachefriends.org/) หรือ Docker MySQL)

---

### 2. ติดตั้งและเริ่มทำงาน Backend Server

1. เข้าไปยังโฟลเดอร์โปรเจกต์:
   ```bash
   cd plane_borrow-main
   ```
2. ติดตั้ง Node.js dependencies:
   ```bash
   npm install
   ```
3. เปิด MySQL Server (เช่น Start MySQL ใน XAMPP Control Panel)
4. นำเข้า SQL Schema ที่ระบุไว้ในหัวข้อ [โครงสร้างฐานข้อมูล](#-โครงสร้างฐานข้อมูล-database-schema)
5. ตรวจสอบการตั้งค่าฐานข้อมูลใน `server.js` หรือทดสอบการเชื่อมต่อ:
   ```bash
   node testConnection.js
   ```
6. เริ่มต้นรันเซิร์ฟเวอร์:
   ```bash
   node server.js
   ```
   เซิร์ฟเวอร์จะเริ่มทำงานที่ `http://localhost:3000`

---

### 3. ติดตั้งและเริ่มทำงาน Flutter Application

1. ดาวน์โหลด Flutter packages:
   ```bash
   flutter pub get
   ```
2. ตรวจสอบและแก้ไข IP Address สำหรับการเรียก API ในไฟล์ `lib/`:
   > **ข้อแนะนำสำคัญ**: หากทดสอบผ่าน Physical Device หรือ Android Emulator ให้แก้ไข Base URL จาก `localhost` หรือ `192.168.1.x` ให้เป็น IP เครื่องคอมพิวเตอร์ของคุณในวง LAN เดียวกัน หรือใช้ `10.0.2.2` สำหรับ Android Emulator
3. รันแอปพลิเคชัน:
   ```bash
   flutter run
   ```

---

## ⚙️ หมายเหตุและการตั้งค่าเพิ่มเติม (Configuration Notes)

- **การกำหนดสิทธิ์ผู้ใช้ (Role Mapping)**:
  - `role_id = 1`: **Student** (หน้าแรก `Home_Student.dart`)
  - `role_id = 2`: **Staff** (หน้าแรก `Home_Staff.dart`)
  - `role_id = 3`: **Lecturer** (หน้าแรก `Home_lecture.dart`)
- **การทดสอบรันบนอุปกรณ์จริง (Mobile Device Testing)**:
  - ตรวจสอบให้แน่ใจว่าอุปกรณ์มือถือและเครื่องคอมพิวเตอร์ที่รัน `server.js` เชื่อมต่อ Wi-Fi เครือข่ายเดียวกัน
  - ตรวจสอบ Firewall บนเครื่องคอมพิวเตอร์ให้อนุญาตการเชื่อมต่อที่ Port `3000`
