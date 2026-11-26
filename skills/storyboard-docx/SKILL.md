---
name: storyboard-docx
description: >-
  สกิลสร้างไฟล์เอกสารสคริปต์สตอรี่บอร์ด Word (.docx) มาตรฐาน STB ตาราง 2 คอลัมน์ (Scene / Script)
  จากไฟล์ JSON ประจำคาบเรียน โดยแสดง Speaker, Written Script, และ TTS Spoken Form ครบทุกซีน
---

# Storyboard DOCX Skill (2-Column `Scene` / `Script` Generator)

สกิลสำหรับแปลงไฟล์ JSON บทเรียนและ Prompt ประจำคาบ (`Checkwork_<BASE>_C1.json`) ให้เป็นไฟล์เอกสาร Word (`.docx`) สคริปต์สตอรี่บอร์ดมาตรฐาน **STB 2 คอลัมน์ (`Scene` | `Script`)** โดยทำงานผ่านสคริปต์ PowerShell OpenXML ในตัวเครื่อง ไม่ต้องติดตั้งไลบรารีภายนอกเพิ่มเติม

---

## กฎเหล็กโครงสร้างตาราง STB 2 คอลัมน์ (Locked 2-Column Template)

1. **หัวเรื่องเอกสาร (Heading 1):** `<English Lesson Title> (<Course Code / Lesson Base>)` เช่น `AC Sine Wave Values and RMS Calculations (20104-2003_U2_1)`
2. **ห้ามเพิ่มคอลัมน์ที่ 3 เด็ดขาด — ต้องมี 2 คอลัมน์เท่านั้น:**
   - **คอลัมน์ที่ 1 (`Scene`):** แสดงเฉพาะรหัสซีนกระชับชัดเจน `Scene 01`, `Scene 02`, ..., `Scene 25` (ตัวเลข 2 หลักนำหน้าด้วยศูนย์)
   - **คอลัมน์ที่ 2 (`Script`):** ต้องแสดงหัวข้อตัวหนาครบทั้ง **3 ส่วน** เรียงลำดับจากบนลงล่างในทุกซีน:
     1. **`Speaker:`**
     2. **`Written Script:`**
     3. **`TTS Spoken Form:`**
3. **รูปแบบการแสดงผลตามประเภทผู้พูด 3 กรณี:**
   - **Case A — เสียงบรรยายนอกจอ (`off_screen`):**
     - **Speaker:** Off-screen Instructor Voiceover (Ajarn Nont)
     - **Written Script:** `"..."`
     - **TTS Spoken Form:** `"..."`
   - **Case B — ตัวละครพูดหน้าจอคนเดียว (`single_on_screen`):**
     - **Speaker:** Ajarn Nont (On-screen)
     - **Written Script:** `"..."`
     - **TTS Spoken Form:** `"..."`
   - **Case C — ตัวละครพูดโต้ตอบกันในซีนเดียว (`multi_speaker`):**
     - **Speaker:** Ajarn Nont -> Phu (On-screen Dialogue)
     - **Written Script:**
       - Ajarn Nont (00:00-00:03): `"..."`
       - Phu (00:04-00:08): `"..."`
     - **TTS Spoken Form:**
       - Ajarn Nont (00:00-00:03): `"..."`
       - Phu (00:04-00:08): `"..."`
4. **ตารางเดียวสะอาดตา:** เอกสารต้องมีตารางชุดเดียวครบทุกซีนตั้งแต่ต้นจนจบ ห้ามสร้างตารางซ้ำซ้อน

---

## ขั้นตอนการเรียกใช้งาน (Workflow)

### 1. ตรวจสอบไฟล์ JSON ต้นทางของคาบเรียน
ค้นหาไฟล์ JSON ประจำคาบเรียนที่:
`output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/Checkwork_<BASE>_C1.json`

*(หากยังไม่มีไฟล์ JSON ให้แจ้ง Coordinator เรียก `prompt-writer` รันสกิล `ovec-one` เพื่อสร้างไฟล์ JSON ก่อน)*

### 2. รันสคริปต์สร้างไฟล์ `.docx`
เรียกใช้สคริปต์ [generate_stb_docx.ps1](./scripts/generate_stb_docx.ps1) ด้วยคำสั่ง PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "skills/storyboard-docx/scripts/generate_stb_docx.ps1" -JsonPath "output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/Checkwork_<BASE>_C1.json"
```

- **ตำแหน่งไฟล์ผลลัพธ์เริ่มต้น (Default Output):**
  `output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/STB_<BASE>_C1.docx`
- หากต้องการกำหนดชื่อหรือตำแหน่งไฟล์ `.docx` เอง สามารถระบุพารามิเตอร์ `-OutputPath "<path/to/file.docx>"` เพิ่มเติมได้

### 3. การตรวจสอบความถูกต้องหลังสร้างไฟล์ (Validation)
1. ตรวจสอบว่าสคริปต์คืนค่า `SUCCESS` พร้อมจำนวนซีนครบตาม `scenes[]` ใน JSON
2. ตรวจสอบว่าไฟล์ `.docx` ถูกสร้างขึ้นจริงและมีขนาดไฟล์มากกว่า 0 ไบต์
