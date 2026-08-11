$cssBlock = @"
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@700&family=Bangers&family=Crimson+Text:ital,wght@0,400;0,700;1,400&display=swap');

        body {
            background-color: #111;
            color: #ddd;
            font-family: 'Crimson Text', serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .comic-page {
            max-width: 1050px;
            width: 100%;
            background-color: #0a0a0a;
            padding: 30px;
            box-shadow: 0 0 50px rgba(0,0,0,1);
            position: relative;
        }

        h1, h2 {
            text-align: center;
            font-family: 'Cinzel Decorative', cursive;
            color: #b00000;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 2px 2px 5px #000;
        }
        h1 { font-size: 3.5em; margin: 20px 0; }
        h2 { font-size: 2.5em; margin: 40px 0 20px; border-bottom: 1px solid #330000; padding-bottom: 10px; }
        
        .grid-layout {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 15px; 
            margin-bottom: 40px;
        }

        .panel {
            position: relative;
            background-color: #000;
            border: 4px solid #ddd;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s;
        }
        
        .panel:nth-child(even) { clip-path: polygon(0 0, 100% 2%, 100% 100%, 0 98%); }
        .panel:nth-child(odd) { clip-path: polygon(0 2%, 100% 0, 100% 98%, 0 100%); }
        
        .panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: grayscale(10%) contrast(120%);
            display: block;
        }

        /* Dynamic Panel Spans */
        .span-12 { grid-column: span 12; height: 350px; }
        .span-8 { grid-column: span 8; height: 350px; }
        .span-4 { grid-column: span 4; height: 350px; }
        .span-7 { grid-column: span 7; height: 400px; }
        .span-5 { grid-column: span 5; height: 400px; }
        .span-6 { grid-column: span 6; height: 350px; }
        .span-3 { grid-column: span 3; height: 300px; }
        
        .caption-box {
            position: absolute;
            background-color: #fff9e6;
            color: #000;
            border: 2px solid #000;
            padding: 10px 15px;
            font-size: 1.15em;
            font-family: 'Crimson Text', serif;
            font-weight: 700;
            line-height: 1.3;
            box-shadow: 4px 4px 0px rgba(0,0,0,1);
            z-index: 10;
            max-width: 250px;
        }

        .speech-bubble {
            position: absolute;
            background-color: #fff;
            color: #000;
            border: 3px solid #000;
            border-radius: 50%;
            padding: 15px 25px;
            font-size: 1.15em;
            font-family: 'Bangers', cursive;
            line-height: 1.2;
            text-align: center;
            box-shadow: 3px 3px 0px rgba(0,0,0,1);
            z-index: 10;
        }

        .speech-bubble::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 30%;
            border-width: 15px 15px 0 0;
            border-style: solid;
            border-color: #fff transparent transparent transparent;
            display: block;
            width: 0;
            z-index: 11;
        }
        
        .speech-bubble::before {
            content: '';
            position: absolute;
            bottom: -19px;
            left: 28%;
            border-width: 18px 18px 0 0;
            border-style: solid;
            border-color: #000 transparent transparent transparent;
            display: block;
            width: 0;
            z-index: 10;
        }

        .sfx {
            position: absolute;
            font-family: 'Bangers', cursive;
            color: #e60000;
            text-transform: uppercase;
            font-size: 4em;
            text-shadow: 4px 4px 0 #000, -2px -2px 0 #000, 2px -2px 0 #000, -2px 2px 0 #000;
            transform: rotate(-10deg);
            z-index: 15;
            opacity: 0.9;
        }

        .top-left { top: 15px; left: 15px; }
        .bottom-right { bottom: 15px; right: 15px; }
        .top-right { top: 15px; right: 15px; }
        .bottom-left { bottom: 15px; left: 15px; }
        .center { top: 50%; left: 50%; transform: translate(-50%, -50%); }
    </style>
"@

$files = Get-ChildItem "sable_novel_part_*_comic.html"
foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content -Path $file.FullName -Raw

    # 1. Update CSS
    $content = [regex]::Replace($content, '(?is)<style>.*?</style>', $cssBlock)
    
    # 2. Trim Captions
    $content = [regex]::Replace($content, '(?is)(<div class="caption-box[^>]*>)(.*?)(</div>)', {
        param($match)
        $prefix = $match.Groups[1].Value
        $text = $match.Groups[2].Value
        $suffix = $match.Groups[3].Value
        
        $text = $text.Trim()
        
        if ($text -match '(?i)^(Wide shot|Close-up|Camera pans|The camera|View from)') {
            return "" 
        }
        
        if ($text -match '(?i)^(Sable|Banki|Corvin|The barmaid|Mara|He|She|The Shadowcat) (stands|looks|stares|pours|sits|walks|turns|nods|enters|sleeps|watched|didn''t|felt|dropped)') {
            return ""
        }
        
        if ([string]::IsNullOrWhiteSpace($text)) {
            return ""
        }
        
        $sentences = [regex]::Split($text, '(?<=[.!?])\s+') | Where-Object { $_ -match '\w' }
        if ($sentences.Count -gt 2) {
            $text = $sentences[0] + " " + $sentences[1]
        }
        
        return $prefix + $text + $suffix
    })
    
    # 3. Dynamic Grid Spans
    $global:spanToggle = 0
    $global:currentFirstSpan = 7
    $content = [regex]::Replace($content, 'class="panel span-6"', {
        if ($global:spanToggle -eq 0) {
            $global:spanToggle = 1
            $options = @(7, 8, 4, 5)
            $global:currentFirstSpan = $options | Get-Random
            return 'class="panel span-' + $global:currentFirstSpan + '"'
        } else {
            $global:spanToggle = 0
            $secondSpan = 12 - $global:currentFirstSpan
            return 'class="panel span-' + $secondSpan + '"'
        }
    })
    
    $content | Out-File -FilePath $file.FullName -Encoding utf8
}
Write-Host "Finished processing all files."
