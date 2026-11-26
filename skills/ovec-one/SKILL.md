---
name: ovec-one
description: >-
  สกิลเขียนบทวิดีโอสรุปบทเรียนภาษาอังกฤษ (en-US, American Accent, 23-30 ซีน / 3-4 นาที),
  แปลงคำอ่านสูตรวิศวกรรมตามมาตรฐาน OVEC TTS (Dual Output: Written Script + TTS Spoken Form),
  และเขียน Flow AI Image & Video Prompt สไตล์ Modern High-Production Korean Webtoon (อ้างอิง ovec-one Ver.12)
  พร้อมส่งออกเป็นไฟล์ JSON เก็บไว้ที่โฟลเดอร์ output/.../4. Video Hook/checkwork/image/ ของแต่ละคาบเรียนก่อนส่งต่อให้ flow-operator
---

# OVEC-One Skill (Prompt & Script Generator — Based on Ver.12)

สกิลสำหรับแปลงเนื้อหาบทเรียนอาชีวศึกษาไทย (หลักสูตร สอศ. พ.ศ. 2567 ระดับ ปวช. 1–3 และ ปวส. 1–2 ประเภทวิชาอุตสาหกรรม) ให้เป็น **บทวิดีโอสรุปบทเรียนภาษาอังกฤษ (`en-US`, American Accent) ความยาว 3–4 นาที (23–30 ซีนต่อเนื่อง ซีนละ 8 วินาที)** พร้อม **Dual Script (`Written Script` + `TTS Spoken Form`)** และ **Flow AI Image & Video Prompts** แบบ Self-Contained แล้วบันทึกเป็นไฟล์ JSON ประจำคาบเรียนเพื่อให้ `flow-operator` และ `storyboard-writer` นำไปใช้งานต่อทันที

## เอกสารอ้างอิงประกอบภายในสกิล (References)

ก่อนเขียนบทที่มีตัวเลข หน่วยวัด สมการวิศวกรรม หรือก่อนสร้างไฟล์ JSON ให้เปิดอ่านไฟล์อ้างอิงเหล่านี้ประกอบเสมอ:
- [tts-and-scale-bible.md](./references/tts-and-scale-bible.md) — กฎเหล็กการแปลงคำอ่านตัวเลขและสูตรวิศวกรรม OVEC TTS (`TTS Spoken Form`), กฎคัดเลือกตัวละครและชุดเครื่องแบบ (`Mode A` / `Mode B`), และตารางสัดส่วนอุปกรณ์อุตสาหกรรมจริง `1:1`
- [json-schema.md](./references/json-schema.md) — โครงสร้างมาตรฐานของไฟล์ `Checkwork_<BASE>_C1.json` ที่ต้องบันทึกลงโฟลเดอร์ `image/` ของแต่ละคาบเรียน

---

## เมื่อไรต้องเรียกใช้สกิลนี้ (When to Use)

1. เมื่อผู้ใช้สั่งเขียนบท / เขียน Prompt / เตรียมข้อมูลผลิตสื่อ Video Hook ประจำคาบเรียน (`<BASE>` เช่น `20104-2003_U2_1`) จากไฟล์ในโฟลเดอร์ `1. เนื้อหา/`, `2. แผนการจัดการเรียนรู้/`, ใบความรู้, ใบงาน หรือไฟล์ที่แนบมา
2. เมื่อได้รับคำสั่งสั่งทำภาพให้ `flow-operator` แต่คาบเรียนนั้น **ยังไม่มีไฟล์ JSON** อยู่ใน `output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/` — ต้องรันสกิลนี้ผ่าน `prompt-writer` เพื่อสร้างไฟล์ JSON ก่อนเสมอ

---

## กฎเหล็ก 10 ข้อ (Core Iron Rules)

1. **Cohesive 3–4 Minute Lesson Synthesis (23–30 ซีนต่อเนื่อง ห้ามตัดแปะข้ามขั้น):**
   - ความยาววิดีโอรวม **3–4 นาที (23–30 ซีน ซีนละ 8 วินาที ค่ามาตรฐานแนะนำ 25–27 ซีน)**
   - ร้อยเรียงเนื้อหาภาษาไทยให้เป็นเรื่องราวการสอนต่อเนื่องเรื่องเดียว ครอบคลุม: (ก) บทเรียนนี้สอนอะไร (ข) ผู้เรียนจะทำอะไรได้ และ (ค) หลักการ สูตรคำนวณ หรือขั้นตอนปฏิบัติเชื่อมโยงกันตั้งแต่ต้นจนจบอย่างไรตามโครงสร้าง **5-Act Instructional Arc**
2. **Modern Vibrant Webtoon Style & 100% Crystal-Clear Air Lock (ห้ามมีละอองแสงวิ้งเด็ดขาด):**
   - งานภาพสไตล์ **Modern high-production Korean webtoon ผสม semi-realistic anime art** ลายเส้นคมสะอาด โทนสีสดใสทันสมัย
   - แสงธรรมชาติยามเช้า `5000K` ส่องผ่านหน้าต่างเกิดขอบแสงธรรมชาติบาง ๆ บนเส้นผมและไหล่ (`crisp subtle natural edge rim highlights`)
   - **CRITICAL ANTI-SPARKLE LOCK:** ห้ามใช้คำว่า `dust motes`, `light particles`, `sparkles`, `bokeh`, `dreamy lens bloom`, `sunbeams`, `light shafts` เด็ดขาด และต้องใส่คำสั่งล็อกอากาศใสบริสุทธิ์ (`crystal-clear clean static air with strictly NO floating light particles, NO dust motes, NO sparkles, NO glitter, NO bokeh orbs, NO dreamy lens bloom, NO lens flare shimmer, NO volumetric sunbeam shafts, NO magical glow`) ทั้งใน Image Prompt และ Video Prompt ทุกซีน
   - ห้ามโทนสีหม่นเหลืองเก่าแบบหนังสือเรียนยุคเก่า ห้ามมีกรอบช่องการ์ตูน (`NO comic panel borders, NO split-screen strips, NO speech bubbles, NO chibi`)
3. **100% True-to-Life 1:1 Human & Industrial Equipment Scale Lock:**
   - **3A. สัดส่วนครูและนักเรียนสมจริง (`1:7.5` Adult Scale — ห้ามครูตัวใหญ่ล่ำยักษ์ / ห้ามนักเรียนตัวเล็กเป็นเด็ก):**
     - อาจารย์ชายสูง `176 cm` (หญิง `164 cm`) รูปร่างสมส่วนเพรียวธรรมชาติ (`natural slim-tailored proportionate adult build, strictly NO exaggerated broad-shouldered bodybuilder or giant manhwa torso`)
     - นักเรียนอาชีวะ (`18-year-old` หรือ `20-year-old young-adult`) ชายสูง `173 cm` (หญิง `162 cm`) สัดส่วนผู้ใหญ่เต็มตัว `1:7.5` (`strictly NOT a child-sized or middle-school frame`)
     - เมื่อยืนคู่กัน (ยกเว้นมุม Over-the-Shoulder) **ต้องยืนบนระนาบความลึกเดียวกัน (`exact same mid-ground depth plane`)** โดยยอดศีรษะนักเรียนชายอยู่ระดับคิ้วถึงหน้าผากของอาจารย์ชาย (ต่างกันเพียง 3 cm)
     - ล็อกสัดส่วนสถาปัตยกรรมห้อง (`3.0-meter ceiling height, standard 75 cm waist-high demonstration desk, whiteboard spanning from 90 cm waist tray to 210 cm height`) และในซีนสนทนาที่ไม่ได้ชี้เนื้อหาบนกระดาน **กระดานด้านหลังต้องลบสะอาดขาวเกลี้ยง (`clean blank erased white porcelain whiteboard, strictly NO cropped leftover giant title letters`)**
   - **3B. สัดส่วนอุปกรณ์จริง `1:1` และการจัดโซน 3 ระดับ (3-Tier Spatial Zoning):**
     - ห้ามใช้คำว่า `"display model"`, `"tabletop model"`, `"compact unit"`, `"miniature"`, `"demo box"` เด็ดขาด ต้องระบุขนาด `cm` จริงเสมอ
     - **Tier S (`<= 25 cm`):** มัลติมิเตอร์ เครื่องคิดเลข สมุดโน้ต บีกเกอร์ เทอร์โมมิเตอร์แบบก้านจุ่ม — **วางบนโต๊ะสาธิตหน้าห้องได้ไม่เกิน 2–3 ชิ้นเท่านั้น**
     - **Tier M (`25–55 cm`):** ออสซิลโลสโคป เครื่องกำเนิดสัญญาณ มอเตอร์ คอมเพรสเซอร์ — วางบน **รถเข็นเหล็ก (`heavy-duty steel mobile equipment cart`) หรือโต๊ะปฏิบัติการด้านข้าง**
     - **Tier L (`>= 55 cm`):** ตู้คอนซูเมอร์ยูนิต/ตู้ควบคุมไฟฟ้า คอยล์ร้อนแอร์ ตู้ทำความเย็น แท่นเครื่องยนต์ — **ต้องยึดติดผนัง วางบนขาตั้งเหล็กพื้นสูง 40 cm หรือตั้งบนพื้นห้องเท่านั้น ห้ามวางบนโต๊ะเรียน/โต๊ะบรรยายเด็ดขาด!**
4. **American English (`en-US`), Native American Accent & Standardized OVEC TTS Spoken Form:**
   - ความยาวบทพูดต่อซีน 8 วินาที นับจาก **`TTS Spoken Form` ประมาณ `13–20 คำพูด` (`13 to 20 spoken words`)** หากการแทนค่าสูตรยาวเกิน ~20 คำ ให้แบ่งเป็น 2 ซีนต่อเนื่อง (ซีนแรกแนะนำสูตรสัญลักษณ์ ซีนถัดไปแทนค่าตัวเลขและสรุปคำตอบ)
   - **Dual Output บังคับทุกซีน:**
     - `written_script`: ใช้ตัวเลข สัญลักษณ์คณิตศาสตร์ ตัวยก/ตัวห้อย และหน่วยย่อมาตรฐานสากล (ตรงกับข้อความที่เขียนบนกระดานหรือหน้าจอมิเตอร์ใน Image Prompt)
     - `tts_spoken_form` และบทพูดในเครื่องหมาย `"..."` ของ `video_prompt`: **ห้ามมีตัวเลขดิบ (`0-9`) ห้ามมีสัญลักษณ์ (`=`, `≈`, `×`, `÷`, `/`, `√`, `π`, `+`, `-`, `%`, `°`) และห้ามมีตัวย่อหน่วย/ตัวแปรดิบ (`V`, `A`, `Ω`, `Hz`, `kW`, `Vrms`) โดยเด็ดขาด** ต้องแปลงเป็นคำอ่านภาษาอังกฤษเต็มรูปแบบตาม [tts-and-scale-bible.md](./references/tts-and-scale-bible.md) (เช่น ห้ามมี `"and"` ในจำนวนเต็ม, ทศนิยมอ่านเรียงตัวรวมเลขศูนย์ท้าย เช่น `1.50` -> `"one point five zero"`, ตัวห้อยห้ามพูด `"sub"` เช่น `V_rms` -> `"V R M S"`, วงเล็บตัวหารใช้ `"the quantity ..."`, หน่วยนับพหูพจน์ทุกค่ายกเว้น `1`)
5. **Content-Adaptive Visual Routing (`Type 1` – `Type 5`):**
   - `Type 1`: ภาพเปิดบทเรียนมุมกว้าง `16:9` แสดงห้องและอุปกรณ์ `1:1` ตามโซน พร้อมชื่อเรื่องภาษาอังกฤษบนกระดานไวท์บอร์ด (**บังคับใช้ใน Scene 01 เท่านั้น**)
   - `Type 2`: ภาพสนทนาครู-นักเรียน ยืนระนาบความลึกเดียวกัน สัดส่วนผู้ใหญ่สมจริง กระดานด้านหลังสะอาดหรือมีเฉพาะสูตรที่ไม่ถูกบัง
   - `Type 3`: ภาพตัดขวาง/แผนภาพวิศวกรรม `2.5D` บนพื้นหลังสีขาวมุกสะอาด (`bright pearl-white studio backdrop`) ไร้ละอองแสงวิ้ง ไร้โฮโลแกรมไซไฟ
   - `Type 4`: ภาพโคลสอัปมือปฏิบัติงาน หน้าปัดเครื่องมือวัด เนมเพลท หรือการแทนค่าสมการขนาดสมจริง `1:1`
   - `Type 5`: ภาพเน้นข้อควรระวัง ความปลอดภัย และสรุปรวบยอดทั้งระบบ
6. **Context-Driven Cast & Uniform Selection:**
   - วิเคราะห์เนื้อหาบทเรียนเพื่อเลือกตัวละครและชุดให้ตรงบริบทจริง (`Mode A` ชุดนักเรียนเสื้อขาวภาคทฤษฎี/คำนวณ หรือ `Mode B` เสื้อช็อปปฏิบัติการ ปวช. สีกรมท่า / ปวส. สีเทาชาร์โคล + PPE เฉพาะจุดที่มีอันตรายจริง)
   - สำหรับวิชาทฤษฎีไฟฟ้ามาตรฐาน อ้างอิงตัวละครหลักจาก OVEC Style Bible (`Ajarn Nont` สูง 176 cm เสื้อเชิ้ตฟ้าอ่อน + `Phu` สูง 173 cm เสื้อขาวอาชีวะ) หรือปรับตามสาขาวิชาโดยรักษา **อกเสื้อเรียบ 100% ห้ามมีป้ายชื่อ ห้ามมีตราโรงเรียน และครูห้ามห้อยสายคล้องคอ (`strictly NO neck lanyard`)**
7. **Verbatim Master Environment Block & 180-Degree Camera Axis:** ใช้บล็อกสภาพแวดล้อมและแสงชุดเดียวกันแบบคำต่อคำในทุกซีนของห้องนั้น และตั้งมุมกล้องฝั่งเดียวของแกน 180 องศาเพื่อไม่ให้ซ้าย-ขวาสลับกัน
8. **Natural Observational Eyeline:** ตัวละครต้องมองคู่สนทนา กระดาน เครื่องคิดเลข หรืออุปกรณ์อย่างเป็นธรรมชาติ **ห้ามจ้องเลนส์กล้อง (`strictly NOT looking into the camera lens`)**
9. **Protagonist-Grade Thai Aesthetics & 100% Clean-Shaven Male Lock:** ใบหน้าหล่อคม/สวยละมุนสไตล์พระเอก-นางเอกเว็บตูนยุคใหม่ ผิวโทนน้ำผึ้งไทยสุขภาพดี ตัวละครชายทุกคน **โกนหนวดเคราเกลี้ยงเกลา 100% (`strictly NO mustache, NO beard, NO goatee, NO stubble, NO five-o'clock shadow`)**
10. **Thai Self-QC Checklist:** ทุกซีนต้องแนบจุดตรวจเช็กความถูกต้องภาษาไทย (`must_pass_th`, `red_flags_th`, คำค้นหาอ้างอิง) ลงในไฟล์ JSON เพื่อให้ผู้ผลิตและ `qc-reviewer` ตรวจสอบได้ทันที

---

## บล็อกข้อความบังคับสำหรับประกอบ Prompt (Mandatory Copy-Paste Blocks)

### 1. Master Visual Style & Crystal-Clear Daylight Anchor (วางต้น `image_prompt` ทุกซีน)
```text
Modern high-production Korean-style webtoon illustration, refined semi-realistic anime art, crisp clean linework, smooth clean cel-and-soft-gradient digital rendering, vibrant fresh modern color grading (strictly NO dull muddy desaturated colors, NO vintage yellow or sepia cast, NO dated textbook cartoon look), clean warm 5000K morning daylight with crisp subtle natural edge rim highlights on hair and shoulders, crystal-clear clean air with ZERO atmospheric particle effects (strictly NO floating light particles, NO dust motes, NO sparkles, NO glitter, NO bokeh orbs, NO dreamy lens bloom, NO lens flare shimmer, NO volumetric sunbeam shafts, NO magical glow), realistic 1:7.5 proportionate adult anatomical scale (strictly NO exaggerated broad-shouldered bodybuilder giants and NO shrunken child-sized students), authentic 1:1 real-world industrial equipment scale (strictly NO miniature or toy-sized machinery), single unified full-frame 16:9 widescreen cinematic composition, NO comic panel borders, NO split-screen strips, NO speech bubbles, NO manga sound-effect text, NO chibi proportions.
```

### 2. Mandatory Pair Scale & Same-Depth-Plane Anchor (วางใน `image_prompt` ทุกซีนที่มีครูและนักเรียนยืนด้วยกัน)
- **กรณีครูชาย + นักเรียนชาย:**
```text
standing on the exact same depth plane at equal distance from the camera with matched realistic adult human scale and identical head size: the 173 cm young-adult male student is nearly the same height as the 176 cm slim-tailored male instructor, with the top of the student's head reaching the instructor's eyebrow-to-forehead level (only a subtle 3 cm height difference) and comparable natural shoulder widths - strictly NO towering giant broad-shouldered instructor and NO shrunken child-sized student.
```
- **กรณีมีตัวละครหญิงร่วมเฟรม:**
```text
standing on the exact same depth plane with matched realistic adult head scale and natural shoulder proportions, top of the 162 cm young-adult female character's head reaching the 176 cm male character's eye-to-nose level (~12-14 cm difference) - strictly NO giant torso distortion.
```

### 3. Mandatory Video Prompt Opening Anchor (วางต้น `video_prompt` ทุกซีน)
```text
Modern high-production Korean-style webtoon illustration, refined semi-realistic anime art, smooth clean shading, crisp natural daylight rim highlights, realistic matched adult human proportions, authentic 1:1 real-world equipment scale, crystal-clear static air (strictly NO floating light particles, NO dust motes, NO sparkles, NO glittering effects, NO bokeh orbs, NO lens flare shimmer).
```

---

## โครงสร้างการเล่าเรื่อง 5 องก์ (5-Act Instructional Arc: 23–30 ซีน)

1. **Act 1 — Topic Title & Learning Outcomes (`Scenes 01–04 | ~32s`):** `Scene 01` เป็น `Type 1` แสดงชื่อเรื่องภาษาอังกฤษบนกระดานพร้อมอุปกรณ์ขนาด `1:1` ตามโซน ต่อด้วย `Scenes 02–04` อธิบายว่าคาบนี้เรียนเรื่องอะไรและนำไปใช้อะไรได้
2. **Act 2 — Core Principles, Units & Internal Mechanisms (`Scenes 05–11 | ~56s`):** อธิบายหลักการพื้นฐาน สัญลักษณ์ หน่วยวัด และกลไกภายในด้วย `Type 2`, `Type 3` (ภาพตัดขวาง/แผนภาพ) และ `Type 4` (โคลสอัป)
3. **Act 3 — Step-by-Step Calculation / Practical Workflow (`Scenes 12–21 | ~80s`):** เดินเรื่องการคำนวณหรือขั้นตอนปฏิบัติงานต่อเนื่องทีละขั้น (แยกซีนตั้งสูตรและซีนแทนค่าตัวเลขเมื่อคำอ่าน TTS ยาวเกิน 20 คำ)
4. **Act 4 — Common Mistakes & Safety Precautions (`Scenes 22–24 | ~24s`):** ชี้จุดผิดพลาดที่พบบ่อยในการแปลงหน่วย/การวัด และกฎความปลอดภัยหน้างานจริง (`Type 5`)
5. **Act 5 — Synthesis & Competency Takeaway (`Scenes 25–27 | ~24s`):** สรุปสูตรและหัวใจสำคัญทั้งหมดเชื่อมกลับสู่เป้าหมายใน Act 1

---

## ขั้นตอนการทำงาน (Execution Steps)

### ขั้นที่ 1: วิเคราะห์เนื้อหาคาบเรียนและวาง Production Blueprint
1. อ่านเอกสารต้นทาง กู้คืนตัวยก/ตัวห้อยที่หลุดจากไฟล์ Word (`I2R` -> `I²R`, `mm2` -> `mm²`, `Vrms` -> `V_rms`) และแปลหน่วยย่อภาษาไทยเป็นอังกฤษ (`ชม.` -> `hours`, `ตร.ม.` -> `m²`)
2. กำหนดรหัสคาบเรียน `<BASE>` (เช่น `20104-2003_U2_1`), สาขา `<thaiName>` (`ไฟฟ้า` หรือ `อิเล็กทรอนิกส์` หรือสาขาที่ตรงกับรหัสวิชา), โหมดชุดเครื่องแบบ (`Mode A` หรือ `Mode B`), ผังจัดวางอุปกรณ์ `Tier S / M / L`, และตารางคำอ่าน `tts_glossary`

### ขั้นที่ 2: สร้าง Master Production Bible
สร้างบล็อกข้อความภาษาอังกฤษต้นฉบับสำหรับคัดลอกซ้ำแบบคำต่อคำ:
1. `master_style_block` และ `master_video_opening_block`
2. `characters[]` — Master Character Block ของตัวละครทุกตัว (ระบุส่วนสูง `cm`, โครงสร้างร่างกายผู้ใหญ่สมส่วน, ผิวโทนไทย, โกนหนวดเคราเกลี้ยงเกลา 100%, ชุดอกเรียบไร้ป้ายชื่อ/สายคล้องคอ)
3. `master_environment_block` — ล็อกเพดาน 3.0 m, โต๊ะ 75 cm (ของบนโต๊ะไม่เกิน 2–3 ชิ้น), กระดาน 90–210 cm, โซนอุปกรณ์ Tier M/L และแสง 5000K อากาศใส 100%

### ขั้นที่ 3: เขียนครบทุกซีน (23–30 ซีน ห้ามย่อหรือข้ามซีน)
สำหรับแต่ละซีน (`Scene 01` ถึง `Scene N`) ต้องสร้างข้อมูลครบถ้วน:
- `speaker_mode` (`"off_screen"`, `"single_on_screen"`, หรือ `"multi_speaker"`), `speaker`, `written_script`, `tts_spoken_form` (และ `dialogue_lines` กรณี 2 คนโต้ตอบกัน), `thai_meaning`
- `image_prompt` **(Self-Contained 100%):** รวม `master_style_block` + มุมกล้องตามแกน 180 องศา + `Character Block` แบบคำต่อคำ + `Pair Scale Anchor` (ถ้ามี 2 คน) + สถานะกระดานไวท์บอร์ดและขนาดอุปกรณ์ `cm` + สายตามองนอกกล้อง (`strictly NOT looking into the camera lens`) + `master_environment_block` + ข้อห้ามข้อความภาษาไทยและกรอบคอมิก
- `video_prompt`: รวม `master_video_opening_block` + การเคลื่อนไหวเดียวที่ชัดเจน + คิวเสียงพูด `Native Standard American English Accent (General American en-US)` โดยวาง `tts_spoken_form` แบบคำต่อคำในเครื่องหมาย `"..."`
- `self_qc`: จุดที่ต้องผ่าน (`must_pass_th`), จุดต้องตีกลับ (`red_flags_th`), และคำค้นหาภาพอ้างอิง

### ขั้นที่ 4: ตรวจสอบความถูกต้องก่อนบันทึก (Pre-Save Verification)
1. ตรวจว่าทุก `image_prompt` และ `video_prompt` ไม่มีคำที่ทำให้เกิดละอองแสงวิ้ง และมี Anti-Sparkle Lock ครบ
2. ตรวจว่าทุก `tts_spoken_form` และคำพูดใน `video_prompt` **ไม่มีตัวเลข `0-9` สัญลักษณ์คณิตศาสตร์ หรือตัวย่อหน่วยดิบหลงเหลือแม้แต่จุดเดียว** และยาวประมาณ 13–20 คำต่อซีน
3. ตรวจว่า हर `image_prompt` เป็นแบบ Self-Contained (มี Style + Character + Environment ครบในตัว ไม่ใช้คำย่อว่า `[Same as Scene 1]`) เพื่อให้ `flow-operator` ดึงไปเจนทีละซีนได้ทันที

### ขั้นที่ 5: บันทึกเป็นไฟล์ JSON เข้าโฟลเดอร์ `image` ของคาบเรียนนั้น
1. สร้างโฟลเดอร์ปลายทางอัตโนมัติ (หากยังไม่มี):
   `output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/`
   *(ตัวอย่าง: `output/ไฟฟ้า/20104-2003/20104-2003_U2/20104-2003_U2_1/4. Video Hook/checkwork/image/`)*
2. บันทึกไฟล์ JSON ด้วยเข้ารหัส UTF-8 ตามโครงสร้างใน [json-schema.md](./references/json-schema.md) ไว้ที่:
   `output/<thaiName>/<CODE>/<CODE>_U<หน่วย>/<BASE>/4. Video Hook/checkwork/image/Checkwork_<BASE>_C1.json`
3. แจ้ง Path ของไฟล์ JSON ที่สร้างเสร็จเพื่อให้:
   - **`storyboard-writer`** นำไปสร้างไฟล์ `.docx` ตาราง 2 คอลัมน์ (`Scene` / `Script`)
   - **`flow-operator`** นำไปอ่าน `scenes[].image_prompt` เพื่อผลิตภาพใน Google Flow ต่อไป
