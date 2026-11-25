---
name: checkwork-parser
description: สกิลอ่าน แยก และอัปเดตไฟล์ JSON ตรวจงานและข้อมูลบทเรียน Video Hook
---

# Checkwork Parser Skill

สกิลนี้ใช้สำหรับจัดการข้อมูลบทเรียนและผลการตรวจงานในไฟล์ `Checkwork_<id>.json`

## ฟังก์ชันการทำงาน
1. **อ่านข้อมูลบทเรียน:**
   - รหัสวิชา, หน่วยที่, ชื่อเรื่อง, URL ต้นทาง
   - รายการ Scene ทั้งหมด พร้อมบทพูดและ Prompt
2. **ดึง Prompt เฉพาะ Scene:**
   - ค้นหา Prompt ของ Scene ที่ต้องการเจนซ้ำหรือเจนใหม่
3. **บันทึกผลการตรวจ (Update Verdict):**
   - อัปเดตฟิลด์ `verdict`, `good`, `bad`, และ `prompt` สำหรับแต่ละ Scene
