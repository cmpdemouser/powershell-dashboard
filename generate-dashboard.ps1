$scripts = Get-ChildItem "scripts" -Filter *.ps1

$categories = @{}

foreach ($script in $scripts) {

    $data = Get-Content $script.FullName -Raw

    $title = ($data | Select-String "\.Title\s+(.*)").Matches[0].Groups[1].Value
    $category = ($data | Select-String "\.Category\s+(.*)").Matches[0].Groups[1].Value
    $desc = ($data | Select-String "\.Description\s+(.*)").Matches[0].Groups[1].Value

    if (!$categories.ContainsKey($category)) {
        $categories[$category] = @()
    }

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
