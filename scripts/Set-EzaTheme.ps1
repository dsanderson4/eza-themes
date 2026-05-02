# Set-EzaTheme.ps1
$themesDir = "$HOME\eza-themes\themes"

$selected = Get-ChildItem $themesDir -Filter '*.yml' |
    Select-Object -ExpandProperty Name |
    fzf --prompt='eza theme> ' --preview="bat --color=always $themesDir/{}" --height 40% --reverse

if ($selected) {
    Copy-Item "$themesDir\$selected" "$HOME\psinit\theme.yml" -Force
    Write-Host "Applied theme: $selected"
}
