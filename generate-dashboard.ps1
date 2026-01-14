$scripts = Get-ChildItem -Path "scripts" -Filter *.ps1 -Recurse
$categories = @{}

foreach ($script in $scripts) {

    $content = Get-Content $script.FullName -Raw

    $titleMatch = [regex]::Match($content, '\.Title\s+(.*)')
    $categoryMatch = [regex]::Match($content, '\.Category\s+(.*)')
    $descMatch = [regex]::Match($content, '\.Description\s+(.*)')

    if (-not $titleMatch.Success -or
        -not $categoryMatch.Success -or
        -not $descMatch.Success) { continue }

    $title = $titleMatch.Groups[1].Value.Trim()
    $category = $categoryMatch.Groups[1].Value.Trim()
    $description = $descMatch.Groups[1].Value.Trim()

    if (!$categories.ContainsKey($category)) {
        $categories[$category] = @()
    }

    $categories[$category] += "| [$title](scripts/$($script.Name)) | $description |"
}

$index = "# ?? PowerShell Script Dashboard`n`n"

foreach ($cat in ($categories.Keys | Sort-Object)) {
    $index += "## $cat`n"
    $index += "| Script | Description |`n"
    $index += "|--------|-------------|`n"
    foreach ($row in $categories[$cat]) {
        $index += "$row`n"
    }
    $index += "`n"
}

Set-Content -Path "index.md" -Value $index -Encoding UTF8
