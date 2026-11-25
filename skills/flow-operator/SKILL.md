---
name: flow-operator
description: สกิลควบคุม Google Flow AI เพื่อสร้างโปรเจกต์ ตั้งค่าโมเดล Nano Banana 2.1 สั่งเจนภาพ และดาวน์โหลดภาพ Scene มาจัดเก็บ
---

# Flow Operator Skill

สกิลนี้ใช้สำหรับปฏิบัติการใน Google Flow AI (`https://flow.google.com/`) ผ่าน Antigravity Browser หรือ MCP

## ขั้นตอนการทำงาน (Workflow)

### 1. เข้าสู่ Google Flow และสร้างโปรเจกต์
- เปิด `https://flow.google.com/` โดยใช้ Chrome Profile `GW AI Agent`
- สร้าง **New project** และตั้งชื่อโปรเจกต์ตามรหัสไฟล์ เช่น `20104-2003_U2_1_C1`

### 2. ตั้งค่าการเจนภาพ (Generation Settings)
- **Mode:** `Image`
- **Model:** `Nano Banana 2.1`
- **Thinking Level:** `High (Extra thorough)`
- **Aspect Ratio:** `16:9 (1376x768 หรือ 1920x1080)`
- **Quantity:** `x1`

### 3. ป้อน Prompt และเจนภาพ
- ป้อน Prompt ตามที่กำหนดในบทหรือไฟล์ JSON ทีละ Scene
- ตรวจสอบสถานะจนกว่าภาพจะเรนเดอร์เสร็จสมบูรณ์

### 4. ดาวน์โหลดภาพและจัดเก็บ
- ดาวน์โหลดภาพคุณภาพ 1K Original Size (JPEG)
- บันทึกไฟล์ลงโฟลเดอร์:  
  `output/<branch>/<subject>/<unit>/<part>/4. Video Hook/checkwork/image/Scene XX.jpg`
- ตรวจสอบว่าขนาดไฟล์ถูกต้องและเปิดดูได้
