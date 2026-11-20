$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dataPath = Join-Path $root 'data'
$sitePath = Join-Path $root 'site'
$courses = @()

# Hand-maintained content: learning objectives, repository/code cards, additional resources.
$configPath = Join-Path $dataPath 'site-config.json'
if (-not (Test-Path -LiteralPath $configPath)) { throw "Missing $configPath" }
$config = Get-Content -LiteralPath $configPath -Raw -Encoding utf8 | ConvertFrom-Json

$sourceFiles = @(Get-ChildItem -LiteralPath $dataPath -Filter '*.md' -File)
if ($sourceFiles.Count -eq 0) {
    throw "No course Markdown files found in $dataPath"
}

$sourceFiles | Sort-Object Name | ForEach-Object {
    $raw = Get-Content -LiteralPath $_.FullName -Raw -Encoding utf8
    # Title: "# Course 1: Title" (also accepts the older "# Capsule 1 — Title" form)
    $titleMatch = [regex]::Match($raw, '(?m)^# (?:Course|Capsule)\s+(\d+)\s*[:·—-]\s+(.+?)\s*$')
    if (-not $titleMatch.Success) { throw "Could not find a course title in $($_.Name)" }
    $number = [int]$titleMatch.Groups[1].Value
    $title = $titleMatch.Groups[2].Value.Trim() -replace '\\-', '-'
    # Duration: taken from the video length "(20:09)" on the video lecture line, rounded to the minute
    $videoLength = [regex]::Match($raw, '(?m)^- Course \d+,.*?\((\d+):(\d{2})\)')
    $duration = if ($videoLength.Success) { "$([int][math]::Round([int]$videoLength.Groups[1].Value + [int]$videoLength.Groups[2].Value / 60)) minutes" } else { '20 minutes' }
    # Level: "optional" or "compulsory" as stated in the introduction section
    $intro = [regex]::Match($raw, '(?ms)^## 1\. Introduction\s*(.+?)(?=^## )')
    $introLevel = if ($intro.Success) { [regex]::Match($intro.Groups[1].Value, '\b(optional|compulsory)\b') } else { $null }
    $level = if ($introLevel -and $introLevel.Success) { $introLevel.Groups[1].Value } else { 'core course' }
    # Learning objectives: the block-level objectives of site-config.json that list this course
    $objectives = @($config.objectives | Where-Object { $_.courses -contains $number } | ForEach-Object { $_.id })
    # Topics: numbered sections "## 2. Title", without the framing sections
    $sectionMatches = [regex]::Matches($raw, '(?m)^## (?:Slide \d+\s+[—-]|\d+\.)\s+(.+?)\s*$')
    $topics = @($sectionMatches | ForEach-Object { $_.Groups[1].Value.Trim() -replace '\\-', '-' } |
        Where-Object { $_ -notmatch '^(Introduction|Vocabulary|Summary and next course|Conclusion of the block)$' } |
        Select-Object -First 5)
    $summary = 'A focused 20-minute bridge from biological context to the data structures and decisions used in AI for transcriptomics.'
    if ($number -eq 1) { $summary = 'Start with the biological hierarchy, the central dogma, and the idea that every transcriptomic measurement begins as a molecule in a cell.' }
    if ($number -eq 8) { $summary = 'Close the block by connecting count matrices to PCA, UMAP, autoencoders, and count-aware representation learning.' }
    # References: every "- " line of the "## References" section. The YouTube line is the video,
    # the others feed the "go further" card of the course on the Resources page.
    $video = $null
    $references = @()
    $referencesMatch = [regex]::Match($raw, '(?ms)^## References\s*(.+?)(?=\r?\n##|\z)')
    if ($referencesMatch.Success) {
        foreach ($line in [regex]::Matches($referencesMatch.Groups[1].Value, '(?m)^-\s+(.+?)\s*$')) {
            $entry = $line.Groups[1].Value
            $link = [regex]::Match($entry, '\[https?://[^\]]+\]\((https?://[^)]+)\)')
            $text = ($entry -replace '\s*\[https?://[^\]]+\]\(https?://[^)]+\)', '') -replace '[*`\\]', ''
            $text = ($text.Trim() -replace '[:.]$', '')
            $url = if ($link.Success) { $link.Groups[1].Value -replace '\\', '' } else { $null }
            if ($url -and $url -match 'youtube\.com|youtu\.be') {
                if (-not $video) { $video = [ordered]@{ label = $text; url = $url } }
            } else {
                $references += [ordered]@{ text = $text; url = $url }
            }
        }
    }
    if (-not $video) { Write-Warning "No YouTube link found in the References of $($_.Name)" }
    $courses += [ordered]@{ number = $number; title = $title; duration = $duration; level = $level; summary = $summary; objectives = $objectives; topics = $topics; video = $video; references = $references }
}

$site = [ordered]@{
    objectives = @($config.objectives | ForEach-Object { [ordered]@{ id = $_.id; title = $_.title; text = $_.text; courses = @($_.courses) } })
    courses = $courses
    resources = [ordered]@{
        code = @($config.code)
        additional = @($config.additional)
    }
}

$site | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $sitePath 'data.json') -Encoding utf8
Write-Output "Built $($courses.Count) course records, $(@($config.objectives).Count) learning objectives and $(@($config.code).Count + @($config.additional).Count) hand-maintained resources in site/data.json"
