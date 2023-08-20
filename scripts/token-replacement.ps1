param (
    [ValidateScript({-not([string]::IsNullOrWhiteSpace($_))})]
    [string] $Path,
    [ValidateScript({-not([string]::IsNullOrWhiteSpace($_))})]
    [string] $Find,
    [ValidateScript({-not([string]::IsNullOrWhiteSpace($_))})]
    [string] $Replace
)

Get-ChildItem -Path $Path -Recurse -File -Include *.yaml | ForEach-Object {
    [string] $content = Get-Content -Path $_ -Raw

    if($content.Contains($Find)) {

        $content = $content.Replace($Find, $Replace)

        Set-Content -Path $_ -Value $content -Force -PassThru | Out-Null
    }
}