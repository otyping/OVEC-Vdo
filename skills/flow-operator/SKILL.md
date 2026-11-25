---
name: flow-operator
description: สกิลควบคุม Google Flow AI เพื่อสร้างโปรเจกต์ ตั้งค่าโมเดล Nano Banana 2.1 สั่งเจนภาพ และดาวน์โหลดภาพ Scene มาจัดเก็บ
---

# Flow Operator Skill

สกิลนี้ใช้สำหรับปฏิบัติการใน Google Flow AI (`https://flow.google.com/`) ผ่าน Antigravity Browser หรือ MCP

## ขั้นตอนการทำงาน (Workflow)

### 1. เข้าสู่ Google Flow และสร้างโปรเจกต์
- เปิด `https://flow.google.com/` โดยใช้ Chrome Profile `GW AI Agent`
- สร้าง **New project** และตั้งชื่อโปรเจกต์ตามรูปแบบ: `<รหัสบทเรียน>_<ประเภท> (<ชื่อพนักงาน>)` เช่น `20104-2003_U1_1_C1 (Ping)` เพื่อระบุตัวตนผู้รับผิดชอบบนคลาวด์ชัดเจน ไม่ปะปนกับผู้อื่น

### 2. ตั้งค่าการเจนภาพ (Generation Settings)
- **Mode:** `Image`
- **Model:** `Nano Banana 2.1`
- **Thinking Level:** `High (Extra thorough)`
- **Aspect Ratio:** `16:9 (1376x768 หรือ 1920x1080)`
- **Quantity:** `x1`

### 3. ป้อน Prompt และเจนภาพ
- ป้อน Prompt ตามที่กำหนดในบทหรือไฟล์ JSON ทีละ Scene
- ตรวจสอบสถานะจนกว่าภาพจะเรนเดอร์เสร็จสมบูรณ์

### 4. ดาวน์โหลดภาพและจัดเก็บแบบ Silent Background (ห้ามกดปุ่ม Download บนหน้าเว็บ)
- **หลีกเลี่ยงการกดปุ่ม Download บน UI ของเบราว์เซอร์เด็ดขาด** เพื่อไม่ให้ระบบปฏิบัติการ Windows เด้งป็อปอัป "Save As" ขึ้นมารบกวนหน้าจอ
- **วิธีดาวน์โหลดที่ถูกต้อง:** ให้ดึง Direct CDN Image URL จาก `img` tag หรือ URL จาก thumbnail (`https://flow-content.google/image/...` หรือ `asb/...`) แล้วให้ script ดาวน์โหลดเงียบ ๆ ใน background (เช่น Python `urllib.request.urlretrieve`) เข้าสู่โฟลเดอร์ปลายทางโดยตรง
- ตรวจสอบโฟลเดอร์ปลายทาง หากยังไม่มีโฟลเดอร์ ให้ระบบสร้างโฟลเดอร์โครงสร้างอัตโนมัติตามมาตรฐานกลาง OVEC-Agent (Recursive Directory Creation เช่น `os.makedirs(..., exist_ok=True)` หรือ `mkdir -p`):  
  `Output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image`  
  *(ตัวอย่าง: `Output/ไฟฟ้า/20104-2003/20104-2003_U2/20104-2003_U2_1/4. Video Hook/checkwork/image` โดยที่พนักงานไม่ต้องสร้างโฟลเดอร์เองล่วงหน้า ระบบจะสร้างให้ทั้งหมดอัตโนมัติ)*
- บันทึกไฟล์ลงโฟลเดอร์ปลายทางตามชื่อมาตรฐานทันที: `Scene 01.jpg`, `Scene 02.jpg`, ...
- ตรวจสอบขนาดภาพและความสมบูรณ์ (1376x768 หรือตามสเปก) ไม่ให้มีไฟล์ `.tmp` ตกค้าง
