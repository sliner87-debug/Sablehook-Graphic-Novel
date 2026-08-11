for ($i = 1; $i -le 13; $i++) {
    $file = "sable_novel_part_${i}_comic.html"
    $content = Get-Content -Path $file -Raw

    $prev = ""
    $next = ""
    
    if ($i -gt 1) {
        $prevNum = $i - 1
        $prev = "<a href=`"sable_novel_part_${prevNum}_comic.html`" style=`"color: #fff; text-decoration: none; background-color: #330000; border: 2px solid #8b0000; padding: 10px 20px; font-family: 'Cinzel Decorative', cursive; font-size: 1.2em; margin-right: 10px; transition: transform 0.2s;`">&lt; PREV PART</a>"
    }
    if ($i -lt 13) {
        $nextNum = $i + 1
        $next = "<a href=`"sable_novel_part_${nextNum}_comic.html`" style=`"color: #fff; text-decoration: none; background-color: #330000; border: 2px solid #8b0000; padding: 10px 20px; font-family: 'Cinzel Decorative', cursive; font-size: 1.2em; transition: transform 0.2s;`">NEXT PART &gt;</a>"
    }

    $navHtml = @"
    <div class="comic-nav" style="display: flex; justify-content: space-between; align-items: center; width: 100%; max-width: 1050px; margin: 40px auto; padding: 20px; box-sizing: border-box; background-color: #111; border: 2px solid #333;">
        <a href="index.html" style="color: #8b0000; font-family: 'Cinzel Decorative', cursive; text-decoration: none; font-size: 1.5em; font-weight: bold; border: 2px solid #8b0000; padding: 10px 20px;">HOME MENU</a>
        <div>
            $prev
            $next
        </div>
    </div>
"@

    # Remove old comic-nav if it exists
    $content = [regex]::Replace($content, '(?is)<div class="comic-nav".*?</div>\s*</div>', '')
    
    # Inject before </body>
    $content = $content.Replace("</body>", "$navHtml`n</body>")
    
    $content | Out-File -FilePath $file -Encoding utf8
    Write-Host "Updated $file"
}
