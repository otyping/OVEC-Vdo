# OVEC TTS Spoken-Form Rules, Character Casting & 1:1 Scale Reference (ovec-one Ver.12)

เอกสารอ้างอิงฉบับเต็มสำหรับสกิล `ovec-one` ครอบคลุมกฎการแปลงคำอ่านตัวเลขและสูตรวิศวกรรม (`TTS Spoken Form`), การเลือกตัวละครและชุดเครื่องแบบอาชีวศึกษา (`Mode A` / `Mode B`), และมาตรฐานขนาดอุปกรณ์จริง `1:1`

---

## 1. กฎเหล็กการแปลงคำอ่าน OVEC TTS (`TTS Spoken Form`)

ในฟิลด์ `written_script` และข้อความที่ปรากฏบนกระดาน/มิเตอร์ใน `image_prompt` ให้ใช้ตัวเลข ตัวยก/ตัวห้อย และสัญลักษณ์มาตรฐานสากลตามปกติ  
แต่ในฟิลด์ **`tts_spoken_form`** และข้อความคำพูดในเครื่องหมาย `"..."` ของ **`video_prompt`** ห้ามมีตัวเลขดิบ (`0-9`), สัญลักษณ์คณิตศาสตร์ (`=`, `≈`, `×`, `÷`, `/`, `√`, `π`, `+`, `−`, `-`, `%`, `°`), และตัวย่อหน่วย/ตัวแปร (`V`, `A`, `Ω`, `Hz`, `kW`, `Vm`, `Vrms`, `BTU`, `°C`) โดยเด็ดขาด ต้องแปลงตามกฎ 6 หมวดต่อไปนี้:

### 1.1 จำนวนเต็ม เลขศูนย์ และปี ค.ศ. (ห้ามใส่ `"and"` ในจำนวนเต็ม)
- ห้ามพูด `"and"` คั่นกลางจำนวนเต็ม:
  - `1,250` -> `"one thousand two hundred fifty"`
  - `8,352` -> `"eight thousand three hundred fifty-two"`
  - *(ใช้ `"and"` เฉพาะเศษส่วนคละ เช่น `2 1/2` -> `"two and a half"` หรือค่าเงิน `$2.50` -> `"two dollars and fifty cents"`)*
- อ่าน `0` ว่า `"zero"` เสมอ (ห้ามอ่าน `"oh"` ยกเว้นเบอร์อุปกรณ์มาตรฐานอุตสาหกรรม เช่น `7805` -> `"seventy-eight oh five"`, `1N4007` -> `"one N four double-oh seven"`)
- แยกปี ค.ศ. (`2024` -> `"twenty twenty-four"`) ออกจากปริมาณจำนวน (`2,024` -> `"two thousand twenty-four"`)

### 1.2 ทศนิยมและเศษส่วน
- ทศนิยมที่น้อยกว่า 1 ต้องขึ้นต้นด้วย `"zero point"` เสมอ และหลังจุดทศนิยมต้องอ่านเรียงทีละหลัก **รวมเลขศูนย์ต่อท้ายทุกตัว**:
  - `0.5` -> `"zero point five"`
  - `1.50` -> `"one point five zero"`
  - `0.90` -> `"zero point nine zero"`
  - `0.637` -> `"zero point six three seven"`
  - `0.707` -> `"zero point seven zero seven"`
  - `3.14` -> `"three point one four"` *(ห้ามอ่าน `"three point fourteen"` เด็ดขาด)*
- เศษส่วนเดี่ยวต้องสะกดเป็นคำเสมอเพื่อไม่ให้ TTS อ่านเป็นวันที่:
  - `1/2` -> `"one half"`, `1/3` -> `"one third"`, `3/4` -> `"three quarters"`, `5/8` -> `"five eighths"`

### 1.3 เครื่องหมายดำเนินการ (`×`, `÷`, `/`) และกลุ่มตัวหารในวงเล็บ (`"the quantity ..."`)
- `×` ในสมการอ่านว่า `"times"` (`P = V × I` -> `"P equals V times I"`, `V = IR` -> `"V equals I times R"`, `F = ma` -> `"F equals m times a"` ส่วนพจน์หลายตัวติดกันเช่น `2πfL` หรือ `ωt` อ่าน `"two pi f L"`, `"omega t"`)
- `×` ในขนาดมิติชิ้นงานหรือเกลียวสกรูอ่านว่า `"by"` (`1200 × 600 mm` -> `"twelve hundred by six hundred millimeters"`, `M8 × 1.25` -> `"M eight by one point two five"`)
- `÷` และ `/` ในสูตรสมการอ่านว่า `"divided by"` ทุกครั้ง (`P_out / P_in` -> `"P out divided by P in"`)
- `/` ระหว่างหน่วยวัดอ่านว่า `"per"` (`rad/s` -> `"radians per second"`, `Ω/V` -> `"ohms per volt"`, `kJ/kg·K` -> `"kilojoules per kilogram kelvin"`, `W/m²K` -> `"watts per square meter kelvin"`)
  - *ข้อยกเว้น:* ระบบแรงดันคู่ `380/220 V` -> `"three eighty over two twenty volts"`, อนุพันธ์ `dy/dx` -> `"d y by d x"`
- ตัวหารในวงเล็บ หรือพจน์ในวงเล็บที่ยกกำลัง ต้องขึ้นต้นด้วย `"the quantity ..."`:
  - `X_C = 1/(2πfC)` -> `"X C equals one divided by the quantity two pi f C"`
  - `I = P / (V × cosφ)` -> `"I equals P divided by the quantity V times cosine phi"`
  - `(a + b)²` -> `"the quantity a plus b, squared"`
  - ละเว้นการอ่านวงเล็บเหลี่ยม `[ ]`: `%Error = [(V_meas − V_true) / V_true] × 100%` -> `"percent error equals the quantity V measured minus V true, divided by V true, times one hundred percent"`
- วงเล็บบอกหน่วยอ่านว่า `"in ..."`: `EER = Q (BTU/hr) ÷ P (W)` -> `"E E R equals Q in B T U per hour divided by P in watts"`
- วงเล็บฟังก์ชันอ่านว่า `"of"` (`v(t)` -> `"v of t"`), เงื่อนไขเวลาอ่านว่า `"at"` (`R_ins(30 s)` -> `"R insulation at thirty seconds"`), ค่าสัมบูรณ์ `|Z|` -> `"the magnitude of Z"`

### 1.4 ตัวแปร ตัวห้อย (ห้ามพูด `"sub"` เด็ดขาด) อักษรกรีก และเลขยกกำลัง
- อ่านชื่อตัวแปรตามด้วยตัวห้อยทันทีโดย **ห้ามพูดคำว่า `"sub"`**:
  - `V_m` / `Vm` -> `"V m"`
  - `V_rms` / `Vrms` -> `"V R M S"`
  - `X_L` -> `"X L"`, `V_1` -> `"V one"`, `R_2` -> `"R two"`
  - ขยายคำย่อตัวห้อยเชิงความหมาย: `R_T` -> `"R total"`, `V_meas` -> `"V measured"`, `V_true` -> `"V true"`, `V_AV(HW)` -> `"V average, half-wave"`, `I_start,DOL` -> `"I start, D O L"`, `ρ_air` -> `"rho air"`
- คำย่อเทคนิคอ่านเรียงตัวอักษร: `PF` -> `"P F"`, `DOL` -> `"D O L"`, `FLA` -> `"F L A"`, `LRA` -> `"L R A"`, `THW` -> `"T H W"`, `IP65` -> `"I P sixty-five"`
- อักษรกรีก: `Ω` = `ohm`/`ohms`, `π` = `pi`, `θ` = `theta`, `Δ` = `delta`, `η` = `eta`, `ρ` = `rho`, `ω` = `omega`, `φ` = `phi`, `α` = `alpha`, `λ` = `lambda`, `Σ` = `sum`, `µ` (ตัวแปร) = `mu` vs `µ` (คำอุปสรรคหน่วย) = `micro`
- ยกกำลัง ราก และตรีโกณมิติ: `x²` = `"x squared"`, `x³` = `"x cubed"`, `x⁴` = `"x to the fourth power"`, `√x` = `"the square root of x"`, `∛x` = `"the cube root of x"`, `7.2 × 10⁻⁸` = `"seven point two times ten to the minus eight"`, `sin 30°` = `"sine thirty degrees"`, `cos(ωt − 30°)` = `"cosine of omega t minus thirty degrees"`, `tan θ` = `"tangent theta"`, `ln x` = `"natural log of x"`

### 1.5 การเติมพหูพจน์หน่วย SI และตัวพิมพ์เล็ก-ใหญ่ของคำอุปสรรค
- หน่วยนับได้ต้องเป็น **พหูพจน์ในทุกค่ายกเว้น `1` พอดี** (รวมถึงทศนิยม):
  - `1 V` -> `"one volt"`, `5 V` -> `"five volts"`, `0.5 A` -> `"zero point five amperes"`, `0.1 kW` -> `"zero point one kilowatts"`, `1.5 kWh` -> `"one point five kilowatt-hours"`
  - หน่วยไม่เปลี่ยนรูปคงเดิม: `fifty hertz`, `two bar`, `two horsepower`
- แยกตัวพิมพ์เล็ก-ใหญ่อย่างเคร่งครัด: `m` = `milli` (`5 mW` -> `"five milliwatts"`) vs `M` = `mega` (`5 MW` -> `"five megawatts"`, `200 MΩ` -> `"two hundred megohms"`)
- อุณหภูมิ: `25 °C` -> `"twenty-five degrees Celsius"`, `77 °F` -> `"seventy-seven degrees Fahrenheit"`, `300 K` -> `"three hundred kelvins"` (**ห้ามมี `"degrees"` หน้า `kelvins`**)
- สัญลักษณ์งานช่าง: `3φ` -> `"three-phase"`, `1φ` -> `"single-phase"`, `12 AWG` / `AWG 12` -> `"twelve gauge"`

### 1.6 เครื่องหมายขีดที่ไม่ใช่การลบ และการกู้คืนตัวยก/ตัวห้อยจาก Word
- ห้ามอ่านเครื่องหมายยัติภังค์เป็น `"minus"`: `Y-Δ` -> `"wye-delta"`, `R-32` -> `"R thirty-two"`, `10-20 V` -> `"ten to twenty volts"`, `R_C-S` -> `"R C S"`
- กู้คืนตัวยก/ตัวห้อยที่แบนราบจาก Word ก่อนแปลงคำอ่านเสมอ:
  - `P = I2R` -> `P = I²R` -> `"P equals I squared R"` *(ห้ามอ่าน `"I two R"`)*
  - `2.5 mm2` -> `2.5 mm²` -> `"two point five square millimeters"`
  - `1.50 m3/s` -> `1.50 m³/s` -> `"one point five zero cubic meters per second"`
  - `8,352 kg CO2eq` -> `"eight thousand three hundred fifty-two kilograms C O two equivalent"`
- แปลคำย่อภาษาไทยในโจทย์เป็นอังกฤษทั้งหมด (`ชม.` -> `"hours"`, `ชม./วัน` -> `"hours per day"`, `ตร.ม.` -> `"square meters"`, `4 บาท/kWh` -> `"four baht per kilowatt-hour"`)

---

## 2. มาตรฐานตัวละครและเครื่องแบบอาชีวศึกษาไทย (Character & Uniform Bible)

### 2.1 การเลือกโหมดเครื่องแบบตามเนื้อหาบทเรียน
- **Mode A — ภาคทฤษฎี การคำนวณ และหลักการวิศวกรรม (`ชุดนักเรียนนักศึกษาภาคทฤษฎี`):**
  - **นักเรียน ปวช. / ปวส.:** เสื้อเชิ้ตขาวล้วนแขนสั้นเข้ารูปสะอาดตา อกเสื้อและกระเป๋าเสื้อเรียบสนิท (`completely plain solid white chest and plain pocket with NO name tag, NO school emblem, NO pin, NO embroidery`) ชายเสื้อทับในกางเกงสแล็กสีดำ/กรมท่า เข็มขัดหนังสีดำหัวโลหะเรียบ รองเท้าหนังสีดำ (นักศึกษาหญิง: กระโปรงคลุมเข่าสีดำ/กรมท่า รองเท้าคัทชูหนังสีดำ)
  - **อาจารย์ผู้สอน:** เสื้อเชิ้ตคอปกสีฟ้าอ่อน (`pale sky-blue`), เทาอ่อน หรือขาวงาช้าง ทรงสุภาพสมส่วน (ไม่รัดกล้าม) ทับในกางเกงสแล็กสีเทาชาร์โคล/ดำ **อกเรียบ 100% ห้ามมีสายคล้องคอหรือบัตรห้อยคอ (`strictly NO neck lanyard or ID card`)**
- **Mode B — ภาคปฏิบัติการโรงฝึกงานและการใช้เครื่องมือ (`ชุดเสื้อช็อปปฏิบัติการ + PPE ตามหน้างานจริง`):**
  - **นักเรียน ปวช. 1–3:** เสื้อช็อปแขนสั้นผ้าคอมทวิลสีกรมท่าเข้ม (`Solid Deep Navy Blue`) ชายเสื้อปล่อยตรงระดับสะโพก คอปกฮาวาย กระเป๋าอกซ้ายเรียบ 1 ใบ กระเป๋าล่าง 2 ใบ กางเกงขายาวสีกรมท่าเข้ม รองเท้าเซฟตี้หัวเหล็กสีดำ
  - **นักศึกษา ปวส. 1–2:** เสื้อช็อปแขนสั้นสีเทาชาร์โคลเข้ม (`Solid Dark Charcoal Grey`) กางเกงสแล็กช่างสีดำ รองเท้าเซฟตี้หัวเหล็กสีดำ
  - **อาจารย์โรงฝึกงาน:** เสื้อช็อปสีสีกากีแทน (`Khaki-Tan`), เบจหินอุ่น หรือฟ้าอมเทา (`Muted Steel Blue`) กางเกงทำงานสีดำ รองเท้าเซฟตี้สีดำ **ห้ามมีป้ายชื่อ ตราปัก หรือสายคล้องคอ**
  - **PPE:** สวมเฉพาะเมื่อกิจกรรมในซีนนั้นมีความเสี่ยงจริง (เช่น ถุงมือกันความร้อน/ฉนวนไฟฟ้า แว่นตานิรภัยใส)

### 2.2 บล็อกต้นฉบับตัวละครมาตรฐานสาขาไฟฟ้า (Default Electrical Theory Pair)
- **Ajarn Nont (อาจารย์นนท์ — 176 cm):**
  `"Ajarn Nont, a strikingly handsome 32-year-old Thai male vocational electrical engineering instructor, modern webtoon male-lead facial aesthetics, refined symmetrical jawline, straight nose bridge, warm dark-brown almond eyes with lively catchlights, neatly sculpted dark eyebrows, approachable gentle expression, authentic Thai Southeast Asian heritage with warm healthy golden-tan skin tone, 100% smoothly clean-shaven face and jawline (strictly NO mustache, NO beard, NO goatee, NO stubble, NO five-o'clock shadow, NO facial blemishes), sleek glossy jet-black hair in a crisp modern side-parted comma taper haircut, natural slim-tailored proportionate adult build (176 cm tall, realistic normal shoulder width - strictly NO broad-shouldered bodybuilder or giant manhwa torso), wearing a crisp tucked-in solid pale sky-blue short-sleeve collared dress shirt (100% plain chest and pocket with NO name tag, NO emblem, strictly NO neck lanyard or ID badge), dark charcoal tailored slacks, and a plain black leather belt."`
- **Phu (ภู — 173 cm):**
  `"Phu, a handsome 18-year-old young-adult Thai male Por Wor Chor vocational student, modern webtoon facial appeal, bright attentive dark-brown eyes, warm golden-honey Thai skin tone with a fresh clean complexion, 100% smoothly clean-shaven face (strictly NO mustache, NO beard, NO stubble, NO blemishes), glossy jet-black hair in a neat youthful OVEC taper haircut brushing lightly above the eyebrows, proportionate young-adult build (173 cm tall, full 1:7.5 adult head-to-body ratio and natural young-adult shoulder width nearly matching the instructor - strictly NOT a child-sized or middle-school frame), wearing a crisp tailored plain solid white short-sleeve vocational student shirt (100% plain chest and pocket with NO name tag, NO school emblem, NO pin, NO embroidery) neatly tucked into black slacks with a plain metal-buckle black leather belt."`

---

## 3. คู่มือขนาดอุปกรณ์จริง `1:1` และการป้องกัน AI วาดเครื่องมือเพี้ยน

- **ไฟฟ้ากำลัง / อิเล็กทรอนิกส์:**
  - โต๊ะสาธิตหน้าห้อง (`75 cm high`): วางเฉพาะของชิ้นเล็ก `Tier S` ไม่เกิน 3 ชิ้น ได้แก่ ดิจิทัลมัลติมิเตอร์ขนาดฝ่ามือ (`21 cm long`), เครื่องคิดเลขวิทยาศาสตร์ (`16 cm long`), สมุดบันทึกวิศวกรรม A4 พร้อมปากกา
  - รถเข็นเหล็กด้านขวา (`Tier M`): ดิจิทัลออสซิลโลสโคป (`32 cm × 16 cm`) คู่กับเครื่องกำเนิดสัญญาณ AC
  - โครงเหล็ก/ผนังด้านขวา (`Tier L`): ตู้คอนซูเมอร์ยูนิต/ตู้ควบคุมมอเตอร์ (`60 cm × 80 cm`) ติดตั้งแนวตั้งระดับสายตา
- **เครื่องทำความเย็นและปรับอากาศ (HVAC):**
  - คอยล์เย็นติดผนัง (`85 cm wide × 29 cm tall`) ติดตั้งสูง `2.3 m` บนผนัง
  - คอยล์ร้อน (`80 cm wide × 58 cm tall × 32 cm deep`) วางบนขาตั้งเหล็กพื้นสูง `40 cm` ข้างกระดาน (ยอดเครื่องสูงระดับเอว `~98 cm` ห้ามวางบนโต๊ะเรียนเด็ดขาด)
  - เทอร์โมมิเตอร์วัดของเหลว: ต้องระบุ `"slender pen-style digital stem thermometer with a compact 2 cm × 4 cm white/silver button head inline with a thin 2 mm × 15 cm stainless-steel needle probe (strictly NOT a pistol-grip yellow-and-black infrared laser thermometer gun)"`
