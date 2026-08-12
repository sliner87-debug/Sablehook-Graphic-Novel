param(
    [Parameter(Mandatory=$true)]
    [string]$HtmlFile,
    
    [Parameter(Mandatory=$true)]
    [string[]]$ImagePaths
)

$content = Get-Content -Path $HtmlFile -Raw
$matches = [regex]::Matches($content, '(?i)<img[^>]+src="([^"]+)"')

# strict check removed

$offset = 0
for ($i = 0; $i -lt $ImagePaths.Count; $i++) {
    $match = $matches[$i]
    $imagePath = $ImagePaths[$i]
    
    if (-not (Test-Path $imagePath)) {
        Write-Error "Image not found: $imagePath"
        exit 1
    }
    
    $bytes = [IO.File]::ReadAllBytes($imagePath)
    $base64 = [Convert]::ToBase64String($bytes)
    $newSrc = "data:image/jpeg;base64,$base64"
    
    # Calculate positions
    $start = $match.Groups[1].Index + $offset
    $length = $match.Groups[1].Length
    
    # Replace in string
    $content = $content.Remove($start, $length).Insert($start, $newSrc)
    
    # Update offset
    $offset += ($newSrc.Length - $length)
}

$content | Out-File -FilePath $HtmlFile -Encoding utf8
Write-Host "Successfully injected $($ImagePaths.Count) images into $HtmlFile."
