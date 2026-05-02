# Generate-EzaTheme.ps1
# Generates an eza theme.yml from Terminal-Icons theme data

$modPath    = (Get-Module Terminal-Icons -ErrorAction Stop).ModuleBase
$glyphs     = & "$modPath\Data\glyphs.ps1"
$iconTheme  = (Import-PowerShellDataFile "$modPath\Data\iconThemes\devblackops.psd1").Types
$colorTheme = (Import-PowerShellDataFile "$modPath\Data\colorThemes\devblackops.psd1").Types

function Get-Glyph($name) {
    if (-not $name) { return $null }
    $g = $glyphs[$name]
    if (-not $g) { return $null }
    return $g
}

function Hex-ToRgb($hex) {
    if (-not $hex) { return $null }
    $hex = $hex.TrimStart('#')
    if ($hex.Length -ne 6) { return $null }
    return "#$hex"
}

$lines = [System.Collections.Generic.List[string]]::new()

function Add($s) { $lines.Add($s) }

Add "# eza theme.yml — generated from Terminal-Icons devblackops theme"
Add "# Terminal-Icons version: $((Get-Module Terminal-Icons).Version)"
Add "# Run Generate-EzaTheme.ps1 to regenerate"
Add ''

# --- extensions ---
Add 'extensions:'

$fileIcons  = $iconTheme.Files
$fileColors = $colorTheme.Files

$extKeys = $fileIcons.Keys | Where-Object { $_ -match '^\.' } | Sort-Object

foreach ($ext in $extKeys) {
    $bareExt = $ext.TrimStart('.')
    $glyph   = Get-Glyph $fileIcons[$ext]
    $color   = Hex-ToRgb $fileColors[$ext]

    if (-not $glyph -and -not $color) { continue }

    $parts = @()
    if ($glyph) { $parts += "icon: {glyph: ""$glyph""}" }
    if ($color) { $parts += "filename: {foreground: ""$color""}" }

    Add "  ${bareExt}: {$($parts -join ', ')}"
}

Add ''

# --- filenames: well-known files AND well-known directories (single block) ---
Add 'filenames:'

$wellKnownFileIcons  = $fileIcons.WellKnown
$wellKnownFileColors = $fileColors.WellKnown

foreach ($fn in ($wellKnownFileIcons.Keys | Sort-Object)) {
    $glyph = Get-Glyph $wellKnownFileIcons[$fn]
    $color = Hex-ToRgb $wellKnownFileColors[$fn]

    if (-not $glyph -and -not $color) { continue }

    $parts = @()
    if ($glyph) { $parts += "icon: {glyph: ""$glyph""}" }
    if ($color) { $parts += "filename: {foreground: ""$color""}" }

    Add "  ""$fn"": {$($parts -join ', ')}"
}

$wellKnownDirIcons  = $iconTheme.Directories.WellKnown
$wellKnownDirColors = $colorTheme.Directories.WellKnown

$windowsTitleCaseDirs = @(
    'Apps', 'Applications', 'Artifacts', 'Benchmark', 'Bin',
    'Contacts', 'Demo', 'Desktop', 'Development', 'Documents',
    'Downloads', 'Favorites', 'Fonts', 'Github', 'Images',
    'Links', 'Media', 'Movies', 'Music', 'OneDrive', 'Output',
    'Photos', 'Pictures', 'Projects', 'Samples', 'Shortcuts',
    'Songs', 'Src', 'Tests', 'Umbraco', 'Users', 'Videos', 'Windows'
)

foreach ($dir in ($wellKnownDirIcons.Keys | Sort-Object)) {
    $glyph = Get-Glyph $wellKnownDirIcons[$dir]
    $color = Hex-ToRgb $wellKnownDirColors[$dir]

    if (-not $glyph -and -not $color) { continue }

    $parts = @()
    if ($glyph) { $parts += "icon: {glyph: ""$glyph""}" }
    if ($color) { $parts += "filename: {foreground: ""$color""}" }

    $titleCase = $windowsTitleCaseDirs | Where-Object { $_ -ieq $dir } | Select-Object -First 1
    if ($titleCase) {
        Add "  ""$titleCase"": {$($parts -join ', ')}"
    }
    Add "  ""$dir"": {$($parts -join ', ')}"
}

Add ''

# --- filekinds (default directory icon/color, symlink color) ---
Add 'filekinds:'
Add '  normal:       {foreground: "#E6D4A3"}'
Add "  directory:    {icon: {glyph: ""$dirDefaultIcon""}, foreground: ""#E6D4A3""}"
Add '  symlink:      {foreground: "#E6D4A3"}'
Add '  pipe:         {foreground: "#E6D4A3"}'
Add '  block_device: {foreground: "#E6D4A3"}'
Add '  char_device:  {foreground: "#E6D4A3"}'
Add '  socket:       {foreground: "#E6D4A3"}'
Add '  special:      {foreground: "#E6D4A3"}'
Add '  executable:   {foreground: "#E6D4A3"}'
Add '  mount_point:  {foreground: "#E6D4A3"}'

$dirDefaultIcon  = Get-Glyph $iconTheme.Directories['']
$dirDefaultColor = Hex-ToRgb $colorTheme.Directories['']

if ($dirDefaultIcon -or $dirDefaultColor) {
    $parts = @()
    if ($dirDefaultIcon)  { $parts += "icon: {glyph: ""$dirDefaultIcon""}" }
    if ($dirDefaultColor) { $parts += "foreground: ""$dirDefaultColor""" }
}

Add ''

# --- fixed colors for mode, size, date ---
Add 'perms:'
Add '  user_read:     {foreground: "#E6D4A3"}'
Add '  user_write:    {foreground: "#E6D4A3"}'
Add '  user_execute_file:  {foreground: "#E6D4A3"}'
Add '  user_execute_other: {foreground: "#E6D4A3"}'
Add '  group_read:    {foreground: "#E6D4A3"}'
Add '  group_write:   {foreground: "#E6D4A3"}'
Add '  group_execute: {foreground: "#E6D4A3"}'
Add '  other_read:    {foreground: "#E6D4A3"}'
Add '  other_write:   {foreground: "#E6D4A3"}'
Add '  other_execute: {foreground: "#E6D4A3"}'
Add '  special_user_file:  {foreground: "#E6D4A3"}'
Add '  special_other:      {foreground: "#E6D4A3"}'
Add '  attribute:     {foreground: "#E6D4A3"}'
Add ''
Add 'size:'
Add '  number_byte:     {foreground: "#1E90FF"}'
Add '  number_kilo:     {foreground: "#1E90FF"}'
Add '  number_mega:     {foreground: "#1E90FF"}'
Add '  number_giga:     {foreground: "#1E90FF"}'
Add '  number_huge:     {foreground: "#1E90FF"}'
Add '  unit_byte:       {foreground: "#1E90FF"}'
Add '  unit_kilo:       {foreground: "#1E90FF"}'
Add '  unit_mega:       {foreground: "#1E90FF"}'
Add '  unit_giga:       {foreground: "#1E90FF"}'
Add '  unit_huge:       {foreground: "#1E90FF"}'
Add ''
Add 'date:'
Add '  {foreground: "#F4A460"}'
Add ''

# $outPath = Join-Path $PSScriptRoot 'theme.yml'
$outPath = Join-Path $PSScriptRoot '..\themes\devblackops.yml'
$lines | Set-Content -Path $outPath -Encoding UTF8
Write-Host "Written to $outPath"
