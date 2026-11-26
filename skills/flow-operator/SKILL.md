---
name: flow-operator
description: สกิลควบคุม Google Flow AI โดยอ่านไฟล์ JSON ประจำคาบเรียนจากโฟลเดอร์ output/.../image เพื่อสร้างโปรเจกต์ ตั้งค่าโมเดล Nano Banana 2.1 สั่งเจนภาพ และดาวน์โหลดภาพ Scene มาจัดเก็บ
---

# Flow Operator Skill

สกิลนี้ใช้สำหรับปฏิบัติการผลิตภาพใน Google Flow AI (`https://flow.google.com/`) ผ่าน MCP Server (`flow`) หรือ Antigravity Browser โดยดึงข้อมูล Prompt จากไฟล์ JSON ประจำคาบเรียน

## ขั้นตอนการทำงาน (Workflow)

### 1. โหลดไฟล์ JSON ประจำคาบเรียน (Mandatory Input)
- ค้นหาและอ่านไฟล์ JSON จากโฟลเดอร์ `image` ของคาบเรียนนั้น:  
  `output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/Checkwork_<BASE>_C1.json`  
  *(หากมีไฟล์ `<BASE>*.json` ชื่ออื่นใน `checkwork/image/` หรือ `checkwork/` ให้สามารถอ่านเป็น Fallback ได้ แต่หากยังไม่มีไฟล์ JSON เลย ต้องให้ `prompt-writer` รันสกิล `ovec-one` สร้าง JSON ก่อนเริ่มงาน)*
- อ่านค่า `clip_id`, `operator_name` (หรืออ่านจาก `operator.local.txt`), `flow_settings`, และอาร์เรย์ `scenes[]`
- สำหรับแต่ละซีนใน `scenes[]`:
  - ดึงชื่อไฟล์ภาพปลายทางจาก `scene.image_filename` (เช่น `Scene 01.jpg`)
  - ดึง Prompt จาก `scene.image_prompt` (หรือใช้ `scene.qc.revised_prompt` กรณีสั่งเจนซ้ำเฉพาะซีนที่ `scene.qc.verdict == "ต้องเจนใหม่"`)

### 2. เข้าสู่ Google Flow และสร้างโปรเจกต์
- ใช้งานผ่าน MCP Server (`flow`: `flow_new_project` -> `flow_generate` -> `flow_wait` -> `flow_download`) หรือเปิด `https://flow.google.com/` ด้วย Chrome Profile `Pohnrawee`
- สร้าง **New project** และตั้งชื่อโปรเจกต์ตามรูปแบบ: `<รหัสบทเรียน>_C1 (<ชื่อพนักงาน>)` เช่น `20104-2003_U2_1_C1 (Ping)` เพื่อระบุตัวตนผู้รับผิดชอบบนคลาวด์ชัดเจน ไม่ปะปนกับผู้อื่น

### 3. ตั้งค่าการเจนภาพ (Generation Settings)
- **Mode / Type:** `Image` (`type: "image"`)
- **Model:** `Nano Banana 2.1`
- **Thinking Level:** `High (Extra thorough)`
- **Aspect Ratio:** `16:9` (`1376x768` หรือ `1920x1080`)
- **Quantity / Variants:** `x1` (`variants: 1`)

### 4. ป้อน Prompt จากไฟล์ JSON และเจนภาพ
- นำ Prompt ที่อ่านได้จากไฟล์ JSON ป้อนสั่งเจนทีละ Scene (หรือส่งชุด `scenes` ผ่าน `flow_generate` โดยกำหนด `type: "image"`, `aspect_ratio: "16:9"`)
- รอและตรวจสอบสถานะจนกว่าภาพจะเรนเดอร์เสร็จสมบูรณ์

### 5. ดาวน์โหลดภาพและจัดเก็บแบบ Silent Background (ห้ามกดปุ่ม Download บนหน้าเว็บ)
- **กรณีใช้ MCP (`flow`):** ใช้ `flow_wait` และ `flow_download` ดึงไฟล์คุณภาพ `original` แล้วคัดลอก/เปลี่ยนชื่อเข้าโฟลเดอร์ปลายทางให้ตรงตาม `Scene 01.jpg`, `Scene 02.jpg`, ...
- **กรณีใช้ Browser:** **หลีกเลี่ยงการกดปุ่ม Download บน UI ของเบราว์เซอร์เด็ดขาด** เพื่อไม่ให้ Windows เด้งป็อปอัป "Save As" มารบกวนหน้าจอ ให้ดึง Direct CDN Image URL จาก `img` tag แล้วดาวน์โหลดเงียบ ๆ ใน background เข้าสู่โฟลเดอร์ปลายทางโดยตรง
- โฟลเดอร์จัดเก็บมาตรฐาน (ที่เดียวกับไฟล์ JSON ประจำคาบ):  
  `output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/`
- บันทึกไฟล์ตามชื่อใน `scene.image_filename`: `Scene 01.jpg`, `Scene 02.jpg`, ...
- ตรวจสอบความสมบูรณ์ของไฟล์ภาพทุกซีน (ขนาดภาพ 16:9 ครบถ้วน ไม่มีไฟล์ `.tmp` ตกค้าง)
