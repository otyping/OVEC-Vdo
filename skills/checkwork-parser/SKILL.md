---
name: checkwork-parser
description: สกิลอ่าน แยก และอัปเดตไฟล์ JSON ประจำคาบเรียน (Checkwork_<BASE>_C1.json) สำหรับงานผลิตภาพ ทำสตอรี่บอร์ด และตรวจงาน Video Hook
---

# Checkwork Parser Skill

สกิลนี้ใช้สำหรับอ่านและอัปเดตข้อมูลบทเรียน สคริปต์ Prompt และผลการตรวจงานในไฟล์ JSON มาตรฐานประจำคาบเรียน:
`output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/Checkwork_<BASE>_C1.json`

## ฟังก์ชันการทำงาน
1. **อ่านข้อมูลบทเรียนและสคริปต์:**
   - รหัสวิชา (`course_code`), สาขา (`branch_thai`), รหัสคาบเรียน (`lesson_base`), ชื่อเรื่อง (`lesson_title_en` / `lesson_title_th`), และ `flow_settings`
   - รายการ `scenes[]` ทั้งหมด พร้อม `speaker`, `written_script`, `tts_spoken_form`, `dialogue_lines`, `image_prompt`, และ `video_prompt`
2. **ดึง Prompt สำหรับส่งให้ `flow-operator`:**
   - ดึง `scene.image_prompt` ของทุกซีนสำหรับการผลิตภาพครั้งแรก
   - ดึง `scene.qc.revised_prompt` เฉพาะซีนที่ `scene.qc.verdict == "ต้องเจนใหม่"` สำหรับการเจนซ้ำแก้ไขงาน
3. **บันทึกผลการตรวจคุณภาพ (Update QC Verdict):**
   - อัปเดตออบเจกต์ `scene.qc` (`verdict`, `good`, `bad`, `revised_prompt`) สำหรับแต่ละ Scene โดยคงข้อมูลบทและ Prompt ต้นฉบับไว้ครบถ้วน
