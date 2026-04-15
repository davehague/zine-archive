#!/bin/bash
# Generates index.html from all magazine .html files in this directory
# Run after adding new magazines, or call from the zine app's publish flow

cd "$(dirname "$0")"

# Build magazine entries by reading <title> tags and file metadata
entries=""
for f in $(ls -t *.html 2>/dev/null | grep -v index.html); do
  title=$(grep -oP '(?<=<title>).*?(?=</title>)' "$f" 2>/dev/null || echo "$f")
  # Fallback if no title found
  [ -z "$title" ] && title="${f%.html}"
  date="${f:0:10}"
  size=$(du -h "$f" | cut -f1 | xargs)
  entries="$entries<a href=\"$f\" class=\"issue\"><span class=\"date\">$date</span><span class=\"title\">$title</span><span class=\"size\">$size</span></a>\n"
done

cat > index.html << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Zine — Magazine Archive</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,100..900;1,9..144,100..900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
  html { font-size: 17px; }
  body {
    font-family: 'Inter', sans-serif;
    background: #0a0a0a;
    color: #e0e0e0;
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
  }
  header {
    padding: 3rem 1.5rem 2rem;
    text-align: center;
    border-bottom: 1px solid #1a1a1a;
  }
  header h1 {
    font-family: 'Fraunces', serif;
    font-size: clamp(2.5rem, 8vw, 4rem);
    font-weight: 900;
    letter-spacing: -0.03em;
    line-height: 1;
    color: #fff;
  }
  header p {
    margin-top: 0.75rem;
    font-size: 0.9rem;
    color: #666;
    font-weight: 300;
  }
  .issues {
    max-width: 700px;
    margin: 0 auto;
    padding: 1rem 1rem 4rem;
  }
  .issue {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    padding: 1.25rem 1rem;
    border-bottom: 1px solid #161616;
    text-decoration: none;
    color: inherit;
    transition: background 0.15s;
  }
  .issue:active, .issue:hover {
    background: #111;
  }
  .date {
    font-size: 0.75rem;
    font-weight: 500;
    color: #555;
    letter-spacing: 0.05em;
    font-variant-numeric: tabular-nums;
  }
  .title {
    font-family: 'Fraunces', serif;
    font-size: 1.25rem;
    font-weight: 700;
    color: #f0f0f0;
    line-height: 1.3;
  }
  .size {
    font-size: 0.7rem;
    color: #444;
    font-weight: 400;
  }
  footer {
    text-align: center;
    padding: 2rem;
    font-size: 0.7rem;
    color: #333;
  }
</style>
</head>
<body>
<header>
  <h1>Zine</h1>
  <p>Editorial magazines generated from transcripts and text</p>
</header>
<div class="issues">
HEADER

# Inject entries
echo -e "$entries" >> index.html

cat >> index.html << 'FOOTER'
</div>
<footer>Generated with Zine</footer>
</body>
</html>
FOOTER

echo "index.html generated with $(ls *.html 2>/dev/null | grep -v index.html | wc -l | xargs) magazines"
