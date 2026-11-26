# มาตรฐานโครงสร้างไฟล์ JSON ประจำคาบเรียน (`Checkwork_<BASE>_C1.json`)

ไฟล์ JSON นี้สร้างโดย **Prompt Writer Agent** (ผ่านสกิล `ovec-one`) และต้องบันทึกไว้ในโฟลเดอร์ `image` ของแต่ละคาบเรียนโดยตรง:

```text
output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/Checkwork_<BASE>_C1.json
```
*(ตัวอย่าง: `output/ไฟฟ้า/20104-2003/20104-2003_U2/20104-2003_U2_1/4. Video Hook/checkwork/image/Checkwork_20104-2003_U2_1_C1.json`)*

ไฟล์นี้ทำหน้าที่เป็น **Single Source of Truth** ให้เอเจนต์ทั้ง 3 ตัวใช้งานร่วมกัน:
1. **`storyboard-writer`** — อ่าน `course_code`, `lesson_base`, `lesson_title_en`, และ `scenes[]` (`scene_id`, `speaker_mode`, `speaker`, `written_script`, `tts_spoken_form`, `dialogue_lines`) เพื่อสร้างไฟล์ Word `.docx` ตาราง 2 คอลัมน์ (`Scene` / `Script`)
2. **`flow-operator`** — อ่าน `flow_settings` และ `scenes[]` (`scene_id`, `image_filename`, `image_prompt` หรือ `qc.revised_prompt`) เพื่อสั่ง Google Flow เจนภาพและดาวน์โหลดเป็น `Scene 01.jpg`, `Scene 02.jpg`, ... ลงในโฟลเดอร์เดียวกัน
3. **`qc-reviewer`** — อ่าน `scenes[]` เทียบกับภาพจริง แล้วบันทึกผลการตรวจลงใน `scenes[].qc` (`verdict`, `good`, `bad`, `revised_prompt`)

---

## โครงสร้าง JSON Schema ฉบับเต็ม

```json
{
  "schema_version": "1.0",
  "course_code": "20104-2003",
  "branch_thai": "ไฟฟ้า",
  "unit": "U2",
  "lesson_base": "20104-2003_U2_1",
  "clip_id": "20104-2003_U2_1_C1",
  "lesson_title_en": "AC Sine Wave Values and RMS Calculations",
  "lesson_title_th": "ค่าต่าง ๆ ของคลื่นไซน์ไฟสลับและการคำนวณค่า RMS",
  "target_level": "Por Wor Chor",
  "uniform_mode": "Mode A",
  "operator_name": "Ping",
  "created_at": "2026-11-26T14:30:00+07:00",
  "flow_settings": {
    "project_name_template": "{clip_id} ({operator_name})",
    "mode": "Image",
    "model": "Nano Banana 2.1",
    "thinking_level": "High (Extra thorough)",
    "aspect_ratio": "16:9",
    "quantity": 1,
    "output_image_dir": "output/ไฟฟ้า/20104-2003/20104-2003_U2/20104-2003_U2_1/4. Video Hook/checkwork/image"
  },
  "production_bible": {
    "master_style_block": "Modern high-production Korean-style webtoon illustration...",
    "master_video_opening_block": "Modern high-production Korean-style webtoon illustration...",
    "characters": [
      {
        "id": "instructor_nont",
        "name_en": "Ajarn Nont",
        "name_th": "อาจารย์นนท์",
        "role": "Instructor",
        "height_cm": 176,
        "master_block": "Ajarn Nont, a strikingly handsome 32-year-old Thai male..."
      },
      {
        "id": "student_phu",
        "name_en": "Phu",
        "name_th": "ภู",
        "role": "Student",
        "height_cm": 173,
        "master_block": "Phu, a handsome 18-year-old young-adult Thai male..."
      }
    ],
    "master_environment_block": "Bright contemporary Thai vocational electrical theory classroom with a 3.0-meter ceiling...",
    "equipment_zoning": {
      "tier_s_desk": [
        "Palm-sized yellow-and-charcoal digital multimeter (21 cm long) with red/black test leads",
        "Dark grey scientific calculator (16 cm long)",
        "White A4 engineering notebook with pen"
      ],
      "tier_m_cart": [
        "Digital oscilloscope (32 cm x 16 cm) displaying a symmetrical emerald-green sine wave at 50.0 Hz paired with an AC function generator on a dark-grey steel mobile cart"
      ],
      "tier_l_floor_wall": [
        "Full-scale 220V consumer unit breaker panel (60 cm x 80 cm) mounted vertically on a floor-standing steel training frame along the right wall"
      ]
    },
    "tts_glossary": [
      {
        "written": "V_rms = 0.707 V_m",
        "tts_spoken": "V R M S equals zero point seven zero seven V m"
      }
    ]
  },
  "scenes": [
    {
      "scene_number": 1,
      "scene_id": "Scene 01",
      "image_filename": "Scene 01.jpg",
      "time_range": "00:00-00:08",
      "act": 1,
      "visual_type": "Type 1",
      "action_note_th": "ภาพเปิดบทเรียนมุมกว้าง แสดงชื่อเรื่องภาษาอังกฤษบนกระดานไวท์บอร์ด พร้อมอุปกรณ์ขนาด 1:1 แยกตามโซน",
      "speaker_mode": "off_screen",
      "speaker": "Off-screen Instructor Voiceover (Ajarn Nont)",
      "written_script": "Welcome to AC Circuits! Today we explore peak voltage V_m and root-mean-square voltage V_rms in 220 V power.",
      "tts_spoken_form": "Welcome to A C Circuits! Today we explore peak voltage V m and root-mean-square voltage V R M S in two hundred twenty volts power.",
      "dialogue_lines": [],
      "thai_meaning": "ยินดีต้อนรับสู่วิชาวงจรกระแสสลับ วันนี้เราจะเรียนรู้แรงดันยอดคลื่น V_m และแรงดันใช้งานจริง V_rms ในระบบไฟสองร้อยยี่สิบโวลต์",
      "image_prompt": "Modern high-production Korean-style webtoon illustration... [Self-contained full English Image Prompt]",
      "video_prompt": "Modern high-production Korean-style webtoon illustration... [Self-contained full English Video Prompt]",
      "self_qc": {
        "must_pass_th": "ชื่อเรื่องภาษาอังกฤษบนกระดานสะกดถูกต้อง อากาศใสไร้ละอองแสงวิ้ง บนโต๊ะมีอุปกรณ์เพียง 3 ชิ้น",
        "red_flags_th": "มีละอองแสงโบเก้ อุปกรณ์ขนาดจิ๋วเหมือนของเล่น มีตัวอักษรภาษาไทยเพี้ยน",
        "ref_search_en": "digital oscilloscope sine wave 50Hz electrical lab",
        "ref_search_th": "ออสซิลโลสโคปวัดคลื่นไซน์ไฟสลับ ห้องเรียนไฟฟ้า"
      },
      "qc": {
        "verdict": "",
        "good": "",
        "bad": "",
        "revised_prompt": ""
      }
    }
  ]
}
```

---

## กฎการจัดเก็บข้อมูลสำหรับ 3 รูปแบบผู้พูด (`speaker_mode`)

เพื่อให้สคริปต์สร้าง `.docx` ตาราง 2 คอลัมน์ (`Scene` / `Script`) ทำงานได้ตรงตามเทมเพลต STB 100%:

1. **กรณีเสียงบรรยายนอกจอ (`"speaker_mode": "off_screen"`):**
   - `"speaker": "Off-screen Instructor Voiceover (Ajarn Nont)"`
   - `"written_script"`: ประโยคเดียว
   - `"tts_spoken_form"`: ประโยคคำอ่าน TTS เต็มรูปแบบ
   - `"dialogue_lines": []`

2. **กรณีตัวละครพูดหน้าจอคนเดียว (`"speaker_mode": "single_on_screen"`):**
   - `"speaker": "Ajarn Nont (On-screen)"` หรือ `"Phu (On-screen)"`
   - `"written_script"`: ประโยคเดียว
   - `"tts_spoken_form"`: ประโยคคำอ่าน TTS เต็มรูปแบบ
   - `"dialogue_lines": []`

3. **กรณีตัวละครพูดโต้ตอบกัน 2 คนในซีนเดียว (`"speaker_mode": "multi_speaker"`):**
   - `"speaker": "Ajarn Nont -> Phu (On-screen Dialogue)"`
   - `"dialogue_lines"`: ระบุลำดับคำพูดพร้อมช่วงเวลาชัดเจน:
     ```json
     "dialogue_lines": [
       {
         "speaker": "Ajarn Nont",
         "timestamp": "00:00-00:03",
         "written": "What does a 220 V meter actually measure?",
         "tts_spoken": "What does a two hundred twenty volts meter actually measure?"
       },
       {
         "speaker": "Phu",
         "timestamp": "00:04-00:08",
         "written": "It reads the effective V_rms value, right?",
         "tts_spoken": "It reads the effective V R M S value, right?"
       }
     ]
     ```
   - และใส่ข้อความรวมไว้ใน `"written_script"` กับ `"tts_spoken_form"` ด้วยเพื่อความสะดวกในการค้นหา
