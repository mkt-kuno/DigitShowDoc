#!/usr/bin/env bash
# Markdown -> 静的HTML (GitHub Pages 用)。要 pandoc。
# 使い方: bash .github/scripts/build_pages.sh [出力先ディレクトリ(既定: _site)]
set -euo pipefail

# pandoc はコマンドライン引数をロケールで解釈するため UTF-8 に固定する
export LC_ALL=C.UTF-8

OUT="${1:-_site}"
MATHJAX="https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/tex-mml-chtml.js"

# 公開するドキュメント: ファイル名(拡張子なし)|ページタイトル
DOCS=(
  "quickstart|クイックスタート"
  "user_manual|ユーザーマニュアル"
  "developer_manual|デベロッパーマニュアル"
)

rm -rf "$OUT"
mkdir -p "$OUT"
cp -r img "$OUT/img"

cat > "$OUT/style.css" <<'CSS'
body { max-width: 60em; margin: 0 auto; padding: 1em 1.2em 4em; line-height: 1.7;
       font-family: system-ui, -apple-system, "Segoe UI", "Hiragino Sans", "Yu Gothic", Meiryo, sans-serif; color: #222; }
img { max-width: 100%; height: auto; }
table { border-collapse: collapse; }
th, td { border: 1px solid #bbb; padding: .3em .6em; }
pre { background: #f5f5f5; padding: .8em; overflow-x: auto; }
code { background: #f5f5f5; padding: 0 .2em; }
pre code { background: none; padding: 0; }
a { color: #0b57d0; }
nav.top { margin-bottom: 1.5em; font-size: .9em; }
CSS

for entry in "${DOCS[@]}"; do
  name="${entry%%|*}"
  title="${entry#*|}"
  pandoc -f gfm -t html5 -s \
    --mathjax="$MATHJAX" \
    -V lang=ja \
    --css style.css \
    --metadata pagetitle="$title | DigitShowModbus" \
    -B <(printf '<nav class="top"><a href="index.html">&larr; ドキュメント一覧</a></nav>\n') \
    "$name.md" -o "$OUT/$name.html"
  # 文書間リンク (*.md[#anchor]) を *.html に書き換える
  sed -i -E 's/href="([A-Za-z0-9_]+)\.md(#[^"]*)?"/href="\1.html\2"/g' "$OUT/$name.html"
done

{
  cat <<'HTML'
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>DigitShowModbus ドキュメント</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<h1>DigitShowModbus ドキュメント</h1>
<ul>
HTML
  for entry in "${DOCS[@]}"; do
    printf '<li><a href="%s.html">%s</a></li>\n' "${entry%%|*}" "${entry#*|}"
  done
  cat <<'HTML'
</ul>
</body>
</html>
HTML
} > "$OUT/index.html"

echo "Built: $OUT"
