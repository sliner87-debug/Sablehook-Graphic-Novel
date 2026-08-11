$cssBlock = @"
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@700&family=Bangers&family=Crimson+Text:ital,wght@0,400;0,700;1,400&display=swap');

        body {
            background-color: #000;
            color: #ccc;
            font-family: 'Crimson Text', serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-image: radial-gradient(circle at center, #111 0%, #000 100%);
        }

        .comic-page {
            max-width: 1050px;
            width: 100%;
            background-color: #030303;
            padding: 30px;
            box-shadow: 0 0 100px rgba(100,0,0,0.2);
            position: relative;
        }

        h1, h2 {
            text-align: center;
            font-family: 'Cinzel Decorative', cursive;
            color: #8b0000;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 3px 3px 10px #000, 0 0 20px rgba(139,0,0,0.5);
        }
        h1 { font-size: 4em; margin: 20px 0; }
        h2 { font-size: 2.5em; margin: 40px 0 20px; border-bottom: 2px solid #440000; padding-bottom: 10px; }
        
        .grid-layout {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 15px; 
            margin-bottom: 40px;
        }

        .panel {
            position: relative;
            background-color: #000;
            border: 4px solid #222;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.3s, border-color 0.3s;
        }
        
        .panel:hover {
            border-color: #660000;
        }
        
        /* Jagged, aggressive clip paths */
        .panel:nth-child(3n+1) { clip-path: polygon(1% 0, 100% 2%, 98% 100%, 0 99%); }
        .panel:nth-child(3n+2) { clip-path: polygon(0 2%, 99% 0, 100% 98%, 2% 100%); }
        .panel:nth-child(3n) { clip-path: polygon(0 0, 100% 1%, 100% 100%, 1% 98%); }
        
        .panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: grayscale(30%) contrast(140%) sepia(20%) hue-rotate(330deg);
            display: block;
        }

        .span-12 { grid-column: span 12; height: 350px; }
        .span-8 { grid-column: span 8; height: 350px; }
        .span-4 { grid-column: span 4; height: 350px; }
        .span-7 { grid-column: span 7; height: 400px; }
        .span-5 { grid-column: span 5; height: 400px; }
        .span-6 { grid-column: span 6; height: 350px; }
        .span-3 { grid-column: span 3; height: 300px; }
        
        .caption-box {
            position: absolute;
            background-color: #0a0a0a;
            color: #d4d4d4;
            border: 1px solid #4a0000;
            border-left: 4px solid #8b0000;
            padding: 12px 18px;
            font-size: 1.15em;
            font-family: 'Crimson Text', serif;
            font-weight: 400;
            line-height: 1.4;
            box-shadow: 4px 4px 15px rgba(0,0,0,0.9);
            z-index: 10;
            max-width: 280px;
        }

        .speech-bubble {
            position: absolute;
            background-color: #111;
            color: #ddd;
            border: 2px solid #550000;
            border-radius: 5px; /* Boxier for grimdark */
            padding: 15px 25px;
            font-size: 1.15em;
            font-family: 'Bangers', cursive;
            letter-spacing: 1px;
            line-height: 1.2;
            text-align: center;
            box-shadow: 3px 3px 10px rgba(0,0,0,0.9);
            z-index: 10;
        }

        .speech-bubble::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 30%;
            border-width: 15px 15px 0 0;
            border-style: solid;
            border-color: #111 transparent transparent transparent;
            display: block;
            width: 0;
            z-index: 11;
        }
        
        .speech-bubble::before {
            content: '';
            position: absolute;
            bottom: -18px;
            left: 28%;
            border-width: 18px 18px 0 0;
            border-style: solid;
            border-color: #550000 transparent transparent transparent;
            display: block;
            width: 0;
            z-index: 10;
        }

        .sfx {
            position: absolute;
            font-family: 'Bangers', cursive;
            color: #b30000;
            text-transform: uppercase;
            font-size: 4.5em;
            text-shadow: 2px 2px 0 #000, -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 5px 5px 15px rgba(0,0,0,0.8);
            transform: rotate(-10deg);
            z-index: 15;
            opacity: 0.85;
            mix-blend-mode: hard-light;
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
    Write-Host "Updating CSS in $($file.Name)..."
    $content = Get-Content -Path $file.FullName -Raw

    $content = [regex]::Replace($content, '(?is)<style>.*?</style>', $cssBlock)
    
    $content | Out-File -FilePath $file.FullName -Encoding utf8
}
Write-Host "Finished CSS updates."
