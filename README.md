# ✈️ SkyChauffeur — Airplane Borrowing & Fleet Management System

ระบบบริหารจัดการและยืม-คืนเครื่องบิน (Airplane & Private Jet Rental / Fleet Management System) ออกแบบมาสำหรับการบริหารจัดการอากาศยาน การฝึกบินของนักศึกษา และการกำกับดูแลโดยอาจารย์และเจ้าหน้าที่

โปรเจกต์นี้รองรับทั้งการใช้งานแบบ **Standalone Web Application (โหมดสาธิตจำลอง ดับเบิลคลิกเปิดได้ทันที)** และแบบ **Full-Stack Application (Flutter Mobile App + Node.js REST API + MySQL Database)**

---

## ⚡ วิธีเปิดใช้งานแบบด่วนที่สุด (Quick Start — Standalone Mock Demo)

หากต้องการเปิดดูระบบทันทีโดย**ไม่ต้องติดตั้ง Flutter, Android SDK, Gradle, Node.js หรือ MySQL**:

1. เข้าไปที่โฟลเดอร์ [`mock-web-app/`](file:///D:/Projects/plane_borrow-main/plane_borrow-main/mock-web-app)
2. ดับเบิลคลิกที่ไฟล์ **[`index.html`](file:///D:/Projects/plane_borrow-main/plane_borrow-main/mock-web-app/index.html)** เพื่อเปิดบน Google Chrome, Edge หรือเบราว์เซอร์ใดก็ได้
3. สามารถคลิกสลับบทบาทการใช้งานได้ทันทีที่แถบด้านบน (Student / Lecturer / Staff)
4. มีปุ่ม **"รีเซ็ตข้อมูล Mock"** สำหรับคืนค่าข้อมูลตัวอย่างตั้งต้นได้ตลอดเวลา

---

## 📑 สารบัญ (Table of Contents)
1. [ภาพรวมระบบและสิทธิ์การใช้งาน (Role-Based Access Control)](#-ภาพรวมระบบและสิทธิ์การใช้งาน)
2. [ฟีเจอร์หลักแยกตามบทบาท (Key Features by Role)](#-ฟีเจอร์หลักแยกตามบทบาท)
3. [เทคโนโลยีที่ใช้ (Tech Stack)](#-เทคโนโลยีที่ใช้-tech-stack)
4. [โครงสร้างโปรเจกต์ (Project Structure)](#-โครงสร้างโปรเจกต์)
5. [ฐานข้อมูลและข้อมูลตั้งต้น (Database Schema & Seed Data)](#-ฐานข้อมูลและข้อมูลตั้งต้น)
6. [การติดตั้งและรันระบบแบบ Full-Stack (Full-Stack Setup)](#-การติดตั้งและรันระบบแบบ-full-stack)
7. [API Endpoints Reference](#-api-endpoints-reference)

---

## 🌟 ภาพรวมระบบและสิทธิ์การใช้งาน

**SkyChauffeur** ออกแบบมาเพื่ออำนวยความสะดวกในการบริหารจัดการและจัดสรรการใช้งานเครื่องบิน ไม่ว่าจะเป็นการฝึกบินสำหรับนักศึกษา หรือการจัดการเครื่องบินส่วนบุคคล โดยแบ่งบทบาทเป็น 3 กลุ่ม:

| บทบาท (Role) | รหัสบทบาท (Role ID) | บัญชีทดสอบ | สิทธิ์หลักในระบบ |
| :--- | :---: | :---: | :--- |
| **🎓 Student (นักศึกษา / ผู้ขอยืม)** | `1` | `student1` | ค้นหาเครื่องบิน ขอยืมตามวัน-เวลาที่กำหนด ติดตามสถานะคำขอ และดูประวัติการบิน |
| **👨‍🏫 Lecturer (อาจารย์ / ผู้อนุมัติ)** | `3` | `lecturer1` | ตรวจสอบคำขอจากนักศึกษา พิจารณาอนุมัติหรือปฏิเสธ และดูความพร้อมของฝูงบิน |
| **🛠️ Staff (เจ้าหน้าที่ / ผู้ดูแลเครื่อง)** | `2` | `staff1` | จัดการข้อมูลเครื่องบิน (เพิ่ม/ลบ/แก้ไข), ตรวจรับคืนเครื่องบิน และดูสถิติภาพรวม |

---

## 👥 ฟีเจอร์หลักแยกตามบทบาท

### 1. 🎓 Student (นักศึกษา)
* **Fleet Catalog**: ดูรายการเครื่องบินในสังกัดพร้อมภาพจริง สเปกเครื่องยนต์ จำนวนที่นั่ง และสถานะความพร้อม (`พร้อมใช้งาน` / `ถูกยืมอยู่` / `ซ่อมบำรุง`)
* **ส่งคำขอยืมเครื่องบิน**: ระบุวันที่เริ่มยืม (Start Date) วันที่กำหนดคืน (Return Date) และวัตถุประสงค์การบิน
* **คำขอยืมของฉัน (My Requests)**: ตรวจสอบสถานะคำขอแบบเรียลไทม์ (`รอพิจารณา (Pending)`, `อนุมัติแล้ว (Approved)`, `ไม่อนุมัติ (Rejected)`) พร้อมปุ่มยกเลิกคำขอ
* **ประวัติการบิน (Flight History)**: ดูประวัติการบินย้อนหลังและสถานะการส่งคืนอากาศยาน

### 2. 👨‍🏫 Lecturer (อาจารย์)
* **Approval Queue**: คิวตรวจสอบคำขอยืมเครื่องบินจากนักศึกษา พร้อมรายละเอียดวัตถุประสงค์การบิน
* **Action อนุมัติ / ปฏิเสธ**: กด **✓ อนุมัติ** เพื่อจัดสรรเครื่องบิน หรือ **✗ ปฏิเสธ** คำขอ
* **Fleet Status Overview**: ตรวจสอบสถานะเครื่องบินทุกลำในสังกัดเพื่อการวางแผนตารางการบิน
* **Approval History**: บันทึกประวัติการตัดสินใจอนุมัติย้อนหลัง

### 3. 🛠️ Staff (เจ้าหน้าที่ผู้ดูแลฝูงบิน)
* **Fleet Management (CRUD)**: 
  * เพิ่มเครื่องบินใหม่เข้าสู่ระบบ (`+ เพิ่มเครื่องบินใหม่`)
  * แก้ไขข้อมูลและสเปกเครื่องบิน
  * ลบหรือปลดระวางเครื่องบินที่ไม่ใช้งาน
* **บันทึกรับคืนอากาศยาน (Return Processing)**: ตรวจสอบเครื่องบินที่กำลังถูกยืมอยู่ และกด **✓ บันทึกรับคืนเครื่องบิน** เพื่อเปลี่ยนสถานะเครื่องบินกลับเป็น "พร้อมใช้งาน"
* **Fleet Analytics**: สรุปตัวชี้วัดความพร้อมของฝูงบิน อัตราการยืม และภารกิจสะสม
* **Audit Trail**: บันทึกประวัติการยืม-คืนทั้งระบบ

---

## 💻 เทคโนโลยีที่ใช้ (Tech Stack)

### 1. Standalone Web Application (`mock-web-app/`)
* **Core**: HTML5 Semantic Markup, Vanilla CSS3, Modern JavaScript (ES6 Modules)
* **Design Palette**: Aerospace Navy (`#0f172a`), Slate Grey, Sky Blue (`#0ea5e9`)
* **Persistence**: LocalStorage API พร้อมกลไก Data Synchronization
* **Icons**: Clean Inline SVG (Aviation & Utility Icons)

### 2. Mobile Frontend (`lib/`)
* **Framework**: [Flutter](https://flutter.dev/) (Dart 3.x)
* **Architecture**: Material Design 3
* **Plugins**: `shared_preferences`, `http`, `image_picker`, `intl`
* **Build System**: Android Gradle Plugin (AGP 9.4), Gradle 9.7, Java 17

### 3. Backend REST API (`server.js`)
* **Runtime**: [Node.js](https://nodejs.org/) (Express.js)
* **Database Driver**: `mysql2`
* **Authentication**: JSON Web Token (`jsonwebtoken`), SHA-256 / `bcrypt`

---

## 📁 โครงสร้างโปรเจกต์

```text
plane_borrow/
├── mock-web-app/                   # ⚡ ระบบ Web App จำลอง ดับเบิลคลิกเปิดได้ทันที
│   ├── index.html                  # ไฟล์หน้าจอหลักของระบบ
│   ├── style.css                   # สไตล์ Aviation Theme สะอาด ทันสมัย
│   ├── app.js                      # ตรรกะระบบ Mock State และ LocalStorage
│   ├── assets/images/              # รูปภาพเครื่องบินจริงความละเอียดสูง
│   └── README.md                   # คู่มือการใช้งาน Web App
├── assets/images/                  # รูปภาพเครื่องบินสำหรับ Flutter App
│   ├── Beechcraft Bonanza G36.png
│   ├── CESSANA 172.png
│   ├── Cirrus SR-22T.png
│   ├── Diamond DA40.png
│   ├── Embraer Phonom 300.png
│   ├── Gulfstream G280.png
│   └── airplane.jpg
├── lib/                            # Flutter Application Source Code
│   ├── main.dart                   # Entry point ของแอปพลิเคชัน
│   ├── pages/                      # หน้าจอ Authentication (Login, Register, Welcome)
│   └── Desige/                     # หน้าจอแยกตาม 3 บทบาท (student, lecture, Staff)
├── android/                        # Android Native Project & Gradle Configurations
├── database.sql                    # MySQL Database Schema และ Seed Data
├── package.json                    # Node.js Dependencies สำหรับ Backend Server
├── pubspec.yaml                    # Flutter Dependencies
├── server.js                       # Express.js REST API Server
└── README.md                       # เอกสารคู่มือโครงการ (ไฟล์นี้)
```

---

## 🗄️ ฐานข้อมูลและข้อมูลตั้งต้น (Database Schema & Seed Data)

ระบบใช้ฐานข้อมูลชื่อ `plane_borrow` ประกอบด้วย 4 ตารางหลัก:

1. **`users`**: จัดเก็บข้อมูลผู้ใช้งาน (`id`, `username`, `email`, `password`, `role_id`)
2. **`plane`**: จัดเก็บข้อมูลเครื่องบิน (`planeID`, `planeName`, `status`, `category`, `seat`, `tailNumber`, `image`)
   * `status = 1`: พร้อมใช้งาน (Available)
   * `status = 2`: ถูกยืมอยู่ (Borrowed / In-Flight)
   * `status = 0`: งดให้บริการ / ซ่อมบำรุง (Maintenance)
3. **`rqtPlane`**: จัดเก็บคำขอยืมเครื่องบิน (`requestID`, `planeID`, `rqtBy`, `bDate`, `rDate`, `rqtStatus`)
   * `rqtStatus = 0`: รออนุมัติ (Pending)
   * `rqtStatus = 1`: อนุมัติแล้ว (Approved)
   * `rqtStatus = 2`: ไม่อนุมัติ (Rejected)
4. **`history`**: จัดเก็บบันทึกประวัติและผลการคืนเครื่องบิน (`historyId`, `ApprovedStatus`, `ReturnStaus`)

### ข้อมูลบัญชีผู้ใช้เริ่มต้น (Default Passwords: `password123`)
* **Student**: `username: student1` | `password: password123`
* **Staff**: `username: staff1` | `password: password123`
* **Lecturer**: `username: lecturer1` | `password: password123`

---

## 🛠️ การติดตั้งและรันระบบแบบ Full-Stack

### ขั้นตอนที่ 1: ติดตั้งฐานข้อมูล MySQL
1. เปิดโปรแกรม MySQL Server หรือ XAMPP Control Panel (Start Apache & MySQL)
2. นำเข้าไฟล์ฐานข้อมูล:
   ```bash
   mysql -u root -p < database.sql
   ```

### ขั้นตอนที่ 2: รัน Backend REST API Server
1. ติดตั้ง Dependencies ของ Node.js:
   ```bash
   npm install
   ```
2. เริ่มต้นรันเซิร์ฟเวอร์:
   ```bash
   node server.js
   ```
   *เซิร์ฟเวอร์จะเริ่มทำงานที่พอร์ต `http://localhost:3000`*

### ขั้นตอนที่ 3: รัน Flutter Mobile Application
1. ดาวน์โหลดแพ็กเกจของ Flutter:
   ```bash
   flutter pub get
   ```
2. รันแอปพลิเคชันบน Emulator, อุปกรณ์จริง หรือ Chrome:
   ```bash
   flutter run
   ```

---

## 📡 API Endpoints Reference

| Method | Endpoint | สิทธิ์การเข้าถึง | คำอธิบาย |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/login` | Public | ตรวจสอบสิทธิ์ผู้ใช้และคืนค่า JWT Token พร้อม `role_id` |
| `POST` | `/api/register` | Public | ลงทะเบียนผู้ใช้งานใหม่ |
| `GET` | `/api/planes` | Authenticated | ดึงรายการเครื่องบินทั้งหมดในระบบ |
| `GET` | `/api/planes/:id` | Authenticated | ดูรายละเอียดเครื่องบินรายลำ |
| `POST` | `/api/planes` | Staff (2) | เพิ่มข้อมูลเครื่องบินใหม่ |
| `PUT` | `/api/planes/:id` | Staff (2) | แก้ไขข้อมูลเครื่องบิน |
| `DELETE` | `/api/planes/:id` | Staff (2) | ลบข้อมูลเครื่องบิน |
| `POST` | `/api/requests` | Student (1) | ส่งคำขอยืมเครื่องบิน |
| `GET` | `/api/requests/pending` | Lecturer (3) | ดึงรายการคำขอยืมที่รอการพิจารณา |
| `PUT` | `/api/requests/:id/approve` | Lecturer (3) | อนุมัติคำขอยืมเครื่องบิน |
| `PUT` | `/api/requests/:id/reject` | Lecturer (3) | ปฏิเสธคำขอยืมเครื่องบิน |
| `PUT` | `/api/history/:id/return` | Staff (2) | บันทึกรับคืนเครื่องบินเข้าสู่ลานจอด |
| `GET` | `/api/history` | Authenticated | ดูประวัติการยืม-คืนเครื่องบิน |

---

## 📄 ลิขสิทธิ์และผู้พัฒนา
พัฒนาโดยทีมงานโครงการ **SkyChauffeur Project** สำหรับการศึกษาและทดสอบระบบบริหารจัดการอากาศยาน
