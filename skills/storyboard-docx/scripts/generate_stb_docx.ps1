param(
    [Parameter(Mandatory = $true)]
    [string]$JsonPath,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not (Test-Path -LiteralPath $JsonPath)) {
    throw "JSON file not found: $JsonPath"
}

$resolvedJsonPath = (Resolve-Path -LiteralPath $JsonPath).Path
$jsonRaw = [System.IO.File]::ReadAllText($resolvedJsonPath, [System.Text.Encoding]::UTF8)
$data = $jsonRaw | ConvertFrom-Json

if (-not $data.scenes -or $data.scenes.Count -eq 0) {
    throw "JSON file contains no scenes: $resolvedJsonPath"
}

$lessonBase = if ($data.lesson_base) { [string]$data.lesson_base } elseif ($data.course_code) { [string]$data.course_code } else { "Lesson" }
$courseLabel = if ($data.lesson_base) { [string]$data.lesson_base } elseif ($data.course_code) { [string]$data.course_code } else { "" }
$titleEn = if ($data.lesson_title_en) { [string]$data.lesson_title_en } else { "Instructional Storyboard" }
$headingText = if ($courseLabel) { "$titleEn ($courseLabel)" } else { $titleEn }

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $jsonDir = [System.IO.Path]::GetDirectoryName($resolvedJsonPath)
    $OutputPath = [System.IO.Path]::Combine($jsonDir, "STB_${lessonBase}_C1.docx")
}

$outFullPath = [System.IO.Path]::GetFullPath($OutputPath)
$outParent = [System.IO.Path]::GetDirectoryName($outFullPath)
if (-not [string]::IsNullOrWhiteSpace($outParent) -and -not (Test-Path -LiteralPath $outParent)) {
    [System.IO.Directory]::CreateDirectory($outParent) | Out-Null
}

function Escape-Xml([string]$text) {
    if ($null -eq $text) { return "" }
    $clean = $text -replace "[\x00-\x08\x0B\x0C\x0E-\x1F]", ""
    return [System.Security.SecurityElement]::Escape($clean)
}

function Ensure-Quoted([string]$text) {
    if ($null -eq $text) { return '""' }
    $trimmed = $text.Trim()
    if ($trimmed.StartsWith('"') -and $trimmed.EndsWith('"') -and $trimmed.Length -ge 2) {
        return $trimmed
    }
    return '"' + $trimmed + '"'
}

function New-LabeledParagraph([string]$label, [string]$value, [int]$spaceAfter = 80) {
    $escLabel = Escape-Xml $label
    $escVal = Escape-Xml $value
    if ([string]::IsNullOrEmpty($value)) {
        return @"
          <w:p>
            <w:pPr><w:spacing w:before="0" w:after="$spaceAfter" w:line="260" w:lineRule="auto"/></w:pPr>
            <w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t xml:space="preserve">$escLabel</w:t></w:r>
          </w:p>
"@
    }
    return @"
          <w:p>
            <w:pPr><w:spacing w:before="0" w:after="$spaceAfter" w:line="260" w:lineRule="auto"/></w:pPr>
            <w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t xml:space="preserve">$escLabel </w:t></w:r>
            <w:r><w:t xml:space="preserve">$escVal</w:t></w:r>
          </w:p>
"@
}

function New-PlainParagraph([string]$text, [int]$leftIndent = 240, [int]$spaceAfter = 60) {
    $escText = Escape-Xml $text
    return @"
          <w:p>
            <w:pPr>
              <w:ind w:left="$leftIndent"/>
              <w:spacing w:before="0" w:after="$spaceAfter" w:line="260" w:lineRule="auto"/>
            </w:pPr>
            <w:r><w:t xml:space="preserve">$escText</w:t></w:r>
          </w:p>
"@
}

$rowsSb = New-Object System.Text.StringBuilder

$idx = 0
foreach ($scene in $data.scenes) {
    $idx++
    $num = if ($scene.scene_number) { [int]$scene.scene_number } else { $idx }
    $sceneId = if ($scene.scene_id) { [string]$scene.scene_id } else { ("Scene {0:D2}" -f $num) }
    $escSceneId = Escape-Xml $sceneId

    $speakerVal = if ($scene.speaker) { [string]$scene.speaker } else { "Off-screen Instructor Voiceover" }
    $isMulti = ($scene.speaker_mode -eq "multi_speaker") -and ($null -ne $scene.dialogue_lines) -and ($scene.dialogue_lines.Count -gt 0)

    $cell2Sb = New-Object System.Text.StringBuilder
    [void]$cell2Sb.Append((New-LabeledParagraph -label "Speaker:" -value $speakerVal -spaceAfter 80))

    if ($isMulti) {
        [void]$cell2Sb.Append((New-LabeledParagraph -label "Written Script:" -value "" -spaceAfter 40))
        foreach ($dl in $scene.dialogue_lines) {
            $sp = if ($dl.speaker) { [string]$dl.speaker } else { "Speaker" }
            $ts = if ($dl.timestamp) { " ($($dl.timestamp))" } else { "" }
            $wr = Ensure-Quoted ([string]$dl.written)
            [void]$cell2Sb.Append((New-PlainParagraph -text "- ${sp}${ts}: $wr" -leftIndent 240 -spaceAfter 40))
        }

        [void]$cell2Sb.Append((New-LabeledParagraph -label "TTS Spoken Form:" -value "" -spaceAfter 40))
        $dlCount = $scene.dialogue_lines.Count
        $dlIdx = 0
        foreach ($dl in $scene.dialogue_lines) {
            $dlIdx++
            $sp = if ($dl.speaker) { [string]$dl.speaker } else { "Speaker" }
            $ts = if ($dl.timestamp) { " ($($dl.timestamp))" } else { "" }
            $tts = Ensure-Quoted ([string]$dl.tts_spoken)
            $after = if ($dlIdx -eq $dlCount) { 0 } else { 40 }
            [void]$cell2Sb.Append((New-PlainParagraph -text "- ${sp}${ts}: $tts" -leftIndent 240 -spaceAfter $after))
        }
    }
    else {
        $writtenVal = Ensure-Quoted ([string]$scene.written_script)
        $ttsVal = Ensure-Quoted ([string]$scene.tts_spoken_form)
        [void]$cell2Sb.Append((New-LabeledParagraph -label "Written Script:" -value $writtenVal -spaceAfter 80))
        [void]$cell2Sb.Append((New-LabeledParagraph -label "TTS Spoken Form:" -value $ttsVal -spaceAfter 0))
    }

    $rowBg = if (($idx % 2) -eq 0) { '<w:shd w:val="clear" w:color="auto" w:fill="F8FAFC"/>' } else { '' }

    $rowXml = @"
      <w:tr>
        <w:trPr><w:cantSplit/></w:trPr>
        <w:tc>
          <w:tcPr>
            <w:tcW w:w="1800" w:type="dxa"/>
            <w:vAlign w:val="top"/>
            $rowBg
          </w:tcPr>
          <w:p>
            <w:pPr><w:spacing w:before="0" w:after="0" w:line="260" w:lineRule="auto"/></w:pPr>
            <w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t xml:space="preserve">$escSceneId</w:t></w:r>
          </w:p>
        </w:tc>
        <w:tc>
          <w:tcPr>
            <w:tcW w:w="7560" w:type="dxa"/>
            <w:vAlign w:val="top"/>
            $rowBg
          </w:tcPr>
$($cell2Sb.ToString())
        </w:tc>
      </w:tr>
"@
    [void]$rowsSb.Append($rowXml)
}

$escHeading = Escape-Xml $headingText

$contentTypesXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
'@

$rootRelsXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'@

$docRelsXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
'@

$stylesXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault>
      <w:rPr>
        <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:eastAsia="Leelawadee UI" w:cs="Leelawadee UI"/>
        <w:sz w:val="22"/>
        <w:szCs w:val="22"/>
        <w:lang w:val="en-US" w:eastAsia="en-US" w:bidi="th-TH"/>
      </w:rPr>
    </w:rPrDefault>
  </w:docDefaults>
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:qFormat/>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:basedOn w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:keepNext/>
      <w:spacing w:before="120" w:after="200"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:bCs/>
      <w:color w:val="0F172A"/>
      <w:sz w:val="32"/>
      <w:szCs w:val="32"/>
    </w:rPr>
  </w:style>
</w:styles>
'@

$documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t xml:space="preserve">$escHeading</w:t></w:r>
    </w:p>
    <w:tbl>
      <w:tblPr>
        <w:tblW w:w="9360" w:type="dxa"/>
        <w:tblBorders>
          <w:top w:val="single" w:sz="6" w:space="0" w:color="94A3B8"/>
          <w:left w:val="single" w:sz="6" w:space="0" w:color="94A3B8"/>
          <w:bottom w:val="single" w:sz="6" w:space="0" w:color="94A3B8"/>
          <w:right w:val="single" w:sz="6" w:space="0" w:color="94A3B8"/>
          <w:insideH w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
          <w:insideV w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
        </w:tblBorders>
        <w:tblCellMar>
          <w:top w:w="120" w:type="dxa"/>
          <w:left w:w="160" w:type="dxa"/>
          <w:bottom w:w="120" w:type="dxa"/>
          <w:right w:w="160" w:type="dxa"/>
        </w:tblCellMar>
        <w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
      </w:tblPr>
      <w:tblGrid>
        <w:gridCol w:w="1800"/>
        <w:gridCol w:w="7560"/>
      </w:tblGrid>
      <w:tr>
        <w:trPr><w:tblHeader/><w:cantSplit/></w:trPr>
        <w:tc>
          <w:tcPr>
            <w:tcW w:w="1800" w:type="dxa"/>
            <w:shd w:val="clear" w:color="auto" w:fill="1E3A8A"/>
            <w:vAlign w:val="center"/>
          </w:tcPr>
          <w:p>
            <w:pPr><w:spacing w:before="40" w:after="40"/></w:pPr>
            <w:r><w:rPr><w:b/><w:bCs/><w:color w:val="FFFFFF"/></w:rPr><w:t>Scene</w:t></w:r>
          </w:p>
        </w:tc>
        <w:tc>
          <w:tcPr>
            <w:tcW w:w="7560" w:type="dxa"/>
            <w:shd w:val="clear" w:color="auto" w:fill="1E3A8A"/>
            <w:vAlign w:val="center"/>
          </w:tcPr>
          <w:p>
            <w:pPr><w:spacing w:before="40" w:after="40"/></w:pPr>
            <w:r><w:rPr><w:b/><w:bCs/><w:color w:val="FFFFFF"/></w:rPr><w:t>Script</w:t></w:r>
          </w:p>
        </w:tc>
      </w:tr>
$($rowsSb.ToString())
    </w:tbl>
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="1134" w:right="1273" w:bottom="1134" w:left="1273" w:header="720" w:footer="720" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

if (Test-Path -LiteralPath $outFullPath) {
    Remove-Item -LiteralPath $outFullPath -Force
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$fs = [System.IO.File]::Open($outFullPath, [System.IO.FileMode]::CreateNew)
try {
    $zip = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        $entries = @{
            "[Content_Types].xml"          = $contentTypesXml
            "_rels/.rels"                  = $rootRelsXml
            "word/_rels/document.xml.rels" = $docRelsXml
            "word/styles.xml"              = $stylesXml
            "word/document.xml"            = $documentXml
        }
        foreach ($entryName in $entries.Keys) {
            $entry = $zip.CreateEntry($entryName, [System.IO.Compression.CompressionLevel]::Optimal)
            $stream = $entry.Open()
            try {
                $bytes = $utf8NoBom.GetBytes($entries[$entryName])
                $stream.Write($bytes, 0, $bytes.Length)
            }
            finally {
                $stream.Dispose()
            }
        }
    }
    finally {
        $zip.Dispose()
    }
}
finally {
    $fs.Dispose()
}

Write-Output "SUCCESS: Generated 2-column Storyboard DOCX ($idx scenes) -> $outFullPath"
