$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$dataPath = Join-Path $root 'data'
$sitePath = Join-Path $root 'site'
$capsules = @()

$fallbackLinks = @(
    [ordered]@{ label = 'RNA-seq primer'; url = 'https://www.ebi.ac.uk/training/online/courses/analysis-of-rna-seq-data-i/' },
    [ordered]@{ label = 'Ensembl'; url = 'https://www.ensembl.org/' },
    [ordered]@{ label = 'GEO'; url = 'https://www.ncbi.nlm.nih.gov/geo/' },
    [ordered]@{ label = 'scvi-tools'; url = 'https://scvi-tools.org/' }
)

Get-ChildItem -LiteralPath $dataPath -Filter '*.md' -File | Sort-Object Name | ForEach-Object {
    $raw = Get-Content -LiteralPath $_.FullName -Raw
    $titleMatch = [regex]::Match($raw, '(?m)^# Capsule\s+(\d+)\s+[—-]\s+(.+)$')
    if (-not $titleMatch.Success) { throw "Could not find a capsule title in $($_.Name)" }
    $number = [int]$titleMatch.Groups[1].Value
    $title = $titleMatch.Groups[2].Value.Trim() -replace '\\-', '-'
    $descriptor = [regex]::Match($raw, '(?m)^From Nucleus to Neural Networks.*?·\s*(\d+\s*minutes).*?(optional|compulsory)?')
    $duration = if ($descriptor.Success) { $descriptor.Groups[1].Value.Trim() } else { '20 minutes' }
    $level = if ($descriptor.Success -and $descriptor.Groups[2].Success -and $descriptor.Groups[2].Value) { $descriptor.Groups[2].Value.Trim() } else { 'core capsule' }
    $outcomesMatch = [regex]::Match($raw, '(?ms)\*\*Learning outcomes\.\*\*\s*(.+?)(?:\r?\n\r?\n|\r?\n##)')
    $outcomesText = if ($outcomesMatch.Success) { $outcomesMatch.Groups[1].Value.Trim() } else { 'Build a working understanding of the concepts in this capsule and connect them to the next stage of the transcriptomics workflow.' }
    $outcomes = @($outcomesText -split '(?=\([ivx]+\)\s)' | ForEach-Object { (($_ -replace '^\([ivx]+\)\s*', '') -replace '\.$', '').Trim() } | Where-Object { $_ })
    $slideMatches = [regex]::Matches($raw, '(?m)^## Slide \d+\s+[—-]\s+(.+)$')
    $topics = @($slideMatches | Select-Object -First 5 | ForEach-Object { $_.Groups[1].Value.Trim() -replace '\\-', '-' })
    $summary = 'A focused 20-minute bridge from biological context to the data structures and decisions used in AI for transcriptomics.'
    if ($number -eq 1) { $summary = 'Start with the biological hierarchy, the central dogma, and the idea that every transcriptomic measurement begins as a molecule in a cell.' }
    if ($number -eq 8) { $summary = 'Close the block by connecting count matrices to PCA, UMAP, autoencoders, and count-aware representation learning.' }
    $referencesMatch = [regex]::Match($raw, '(?ms)^## References\s*(.+?)(?=\r?\n##|\z)')
    $links = @()
    if ($referencesMatch.Success) {
        $referenceMatches = [regex]::Matches($referencesMatch.Groups[1].Value, '(?m)^-\s*(.*?)\s*\[https?://[^\]]+\]\((https?://[^)]+)\)')
        $links = @($referenceMatches | ForEach-Object {
            [ordered]@{
                label = ($_.Groups[1].Value -replace '\\', '' -replace '\*', '').Trim()
                url = ($_.Groups[2].Value -replace '\\', '')
            }
        })
    }
    if ($links.Count -eq 0) {
        $links = @($fallbackLinks[($number - 1) % $fallbackLinks.Count], $fallbackLinks[$number % $fallbackLinks.Count])
    }
    $capsules += [ordered]@{ number = $number; title = $title; duration = $duration; level = $level; summary = $summary; outcomes = $outcomes; topics = $topics; links = $links }
}

$capsules | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $sitePath 'data.json') -Encoding utf8
Write-Output "Built $($capsules.Count) public capsule records in site/data.json"