# OVEC VDO (สถาบันการอาชีวศึกษา)

ระบบไปป์ไลน์ครบวงจรสำหรับเขียนบทและ Prompt (`ovec-one Ver.12`), สร้างเอกสารสคริปต์สตอรี่บอร์ด `.docx` (2 คอลัมน์ `Scene` / `Script`), ผลิตภาพด้วย Google Flow AI (`Nano Banana 2.1`), และตรวจคุณภาพ (QC) สำหรับสื่อการสอนอาชีวศึกษา

## 🤖 ทีมเอเจนต์และสกิลในระบบ (Agents & Skills)

| เอเจนต์ (`agents/`) | สกิลหลัก (`skills/`) | หน้าที่รับผิดชอบ |
| :--- | :--- | :--- |
| **Coordinator** (`coordinator.md`) | `checklist-updater` | ประสานงานทุกขั้นตอน อัปเดต Google Sheet (`In Progress` -> `ส่งตรวจ STB`) |
| **Prompt Writer** (`prompt-writer.md`) | `ovec-one` | แปลงเนื้อหาบทเรียนเป็นบท `en-US` + `TTS Spoken Form` และ Flow AI Prompts บันทึกเป็น `Checkwork_{BASE}_C1.json` ลงโฟลเดอร์ `image/` ของแต่ละคาบ |
| **Storyboard Writer** (`storyboard-writer.md`) | `storyboard-docx` | สร้างไฟล์ Word `STB_{BASE}_C1.docx` ตารางสคริปต์สตอรี่บอร์ด 2 คอลัมน์ (`Scene` / `Script`) จากไฟล์ JSON |
| **Flow Operator** (`flow-operator.md`) | `flow-operator` | อ่านไฟล์ JSON ในโฟลเดอร์ `image/` ไปสั่งเจนภาพใน Google Flow และดาวน์โหลดเป็น `Scene 01.jpg`, ... |
| **QC Reviewer** (`qc-reviewer.md`) | `qc-reviewer`, `checkwork-parser` | ตรวจความถูกต้องของภาพ 10 ข้อ และอัปเดตผลตรวจ / `revised_prompt` ลงไฟล์ JSON |

## 📁 โครงสร้างโฟลเดอร์ผลผลิต (Output Directory Convention)
```text
output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/
(ตัวอย่าง: output/ไฟฟ้า/20104-2003/20104-2003_U2/20104-2003_U2_1/)
├── 1. เนื้อหา/
├── 2. แผนการจัดการเรียนรู้/
├── 3. Powerpoint/
├── 4. Video Hook/
│   ├── checkwork/
│   │   ├── image/
│   │   │   ├── Checkwork_{BASE}_C1.json   # ไฟล์ JSON สคริปต์และ Prompt ประจำคาบ
│   │   │   ├── Scene 01.jpg               # ไฟล์ภาพที่เจนจาก JSON ด้วย Google Flow
│   │   │   └── Scene 02.jpg
│   │   └── STB_{BASE}_C1.docx             # สคริปต์สตอรี่บอร์ด 2 คอลัมน์ (Scene / Script)
│   └── {BASE}_C1.mp4                      # ไฟล์วิดีโอสมบูรณ์
└── 5.exercise/
```
* **สาขา (`<thaiName>`):** `ไฟฟ้า` (ช่างไฟฟ้า) หรือ `อิเล็กทรอนิกส์`
* **รหัสคาบเรียน (`<BASE>`):** `<CODE>_U<หน่วย>_<ลำดับ>` เช่น `20104-2003_U2_1`

## 🚀 สำหรับพนักงานในการใช้งาน
เมื่อมีการอัปเดตระบบ ให้ดึงเวอร์ชันล่าสุดด้วยคำสั่ง:
```bash
git pull
```
