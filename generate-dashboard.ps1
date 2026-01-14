<<<<<<< HEAD
$scripts = Get-ChildItem -Path "scripts" -Filter *.ps1 -Recurse
=======
$scripts = Get-ChildItem "scripts" -Filter *.ps1

>>>>>>> ff0878eb9813909a5328596e2893f0b16194c34b
$categories = @{}

foreach ($script in $scripts) {

<<<<<<< HEAD
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
=======
    $data = Get-Content $script.FullName -Raw

    $title = ($data | Select-String "\.Title\s+(.*)").Matches[0].Groups[1].Value
    $category = ($data | Select-String "\.Category\s+(.*)").Matches[0].Groups[1].Value
    $desc = ($data | Select-String "\.Description\s+(.*)").Matches[0].Groups[1].Value
>>>>>>> ff0878eb9813909a5328596e2893f0b16194c34b

    if (!$categories.ContainsKey($category)) {
        $categories[$category] = @()
    }

<<<<<<< HEAD
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
=======
    $categories[$category] += "| [$title](scripts/$($script.Name)) | $desc |"
}

# Create index.md
$index = "# PowerShell Script Dashboard`n`n"

foreach ($cat in $categories.Keys) {
    $index += "## $cat`n"
    $index += "| Script | Description |`n|---|---|`n"
    $categories[$cat] | ForEach-Object { $index += "$_`n" }
}

Set-Content "index.md" $index
>>>>>>> ff0878eb9813909a5328596e2893f0b16194c34b
