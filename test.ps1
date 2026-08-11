$content = Get-Content -Path "sable_novel_part_3_comic_stripped.html" -Raw

$content = [regex]::Replace($content, '(?is)(<div class="caption-box[^>]*>)(.*?)(</div>)', {
    param($match)
    $prefix = $match.Groups[1].Value
    $text = $match.Groups[2].Value
    $suffix = $match.Groups[3].Value
    
    $text = $text.Trim()
    
    # Remove stage directions
    if ($text -match '(?i)^(Wide shot|Close-up|Camera pans|The camera|View from)') {
        return "" 
    }
    
    # Redundant action removal
    $text = $text -replace '(?i)^(Sable|Banki|Corvin|The barmaid|Mara) (stands|looks|stares|pours|sits|walks|turns|nods|enters|sleeps).*?\.?', ''
    $text = $text.Trim()
    
    if ([string]::IsNullOrWhiteSpace($text)) {
        return ""
    }
    
    # Sentence reduction
    $sentences = [regex]::Split($text, '(?<=[.!?])\s+') | Where-Object { $_ -match '\w' }
    if ($sentences.Count -gt 2) {
        $text = $sentences[0] + " " + $sentences[1]
    }
    
    return $prefix + $text + $suffix
})

$content | Out-File -FilePath "sable_novel_part_3_test.html" -Encoding utf8
