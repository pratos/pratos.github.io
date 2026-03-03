#!/usr/bin/env bash
set -euo pipefail

OBSIDIAN_DIR_DEFAULT="/Users/pratos/Documents/obsidian/pratos-mbm1max/openclaw/Blogs/blogs_"
OBSIDIAN_DIR_FALLBACK="/Users/pratos/Documents/obsidian/pratos-mbm1max/openclaw/Blogs/blogs"
OBSIDIAN_DIR="${OBSIDIAN_DIR:-$OBSIDIAN_DIR_DEFAULT}"
VAULT_ROOT="/Users/pratos/Documents/obsidian/pratos-mbm1max"
DEST_DIR="src/content/blog"
ASSET_BASE="src/assets/images/blog"
TWEET_REGEX='^!\[[^]]+\]\((https?://(x\.com|twitter\.com)/[^)]+/status/[^)]+)\)$'

slugify() {
  local input="$1"
  input="${input%.md}"
  echo "$input" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

sanitize_filename() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}

extract_frontmatter() {
  local file="$1"
  if [[ -f "$file" ]]; then
    awk 'NR==1 && $0=="---" {fm=1} fm {print} $0=="---" && NR>1 {exit}' "$file"
  fi
}

build_default_frontmatter() {
  local title="$1"
  local slug="$2"
  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  cat <<EOF
---
author: pratos
pubDatetime: ${now}
title: ${title}
slug: ${slug}
featured: false
draft: false
tags:
  - others
description: 
---
EOF
}

if [[ ! -d "$OBSIDIAN_DIR" ]]; then
  if [[ -d "$OBSIDIAN_DIR_FALLBACK" ]]; then
    OBSIDIAN_DIR="$OBSIDIAN_DIR_FALLBACK"
  else
    echo "Obsidian directory not found: $OBSIDIAN_DIR" >&2
    exit 1
  fi
fi

mkdir -p "$DEST_DIR" "$ASSET_BASE"

for md in "$OBSIDIAN_DIR"/*.md; do
  [[ -f "$md" ]] || continue
  filename=$(basename "$md")
  slug=$(slugify "$filename")
  dest="$DEST_DIR/$slug.md"
  asset_dir="$ASSET_BASE/$slug"
  mkdir -p "$asset_dir"

  frontmatter=$(extract_frontmatter "$dest")
  if [[ -z "$frontmatter" ]]; then
    title=$(basename "$md" .md)
    frontmatter=$(build_default_frontmatter "$title" "$slug")
  fi

  tmp_body=$(mktemp)

  while IFS= read -r line; do
    if [[ "$line" =~ ^([[:space:]]*)!\[\[(.+)\]\] ]]; then
      indent="${BASH_REMATCH[1]}"
      img="${BASH_REMATCH[2]}"
      sanitized=$(sanitize_filename "$img")
      source=$(find "$VAULT_ROOT" -name "$img" -print -quit || true)
      if [[ -n "$source" ]]; then
        cp "$source" "$asset_dir/$sanitized"
      else
        echo "Warning: image not found: $img" >&2
      fi
      alt="${sanitized%.*}"
      line="${indent}![${alt}](@assets/images/blog/${slug}/${sanitized})"
    elif [[ "$line" =~ $TWEET_REGEX ]]; then
      url="${BASH_REMATCH[1]}"
      line="<blockquote class=\"twitter-tweet\"><a href=\"${url}\"></a></blockquote>"
    fi
    printf '%s\n' "$line" >> "$tmp_body"
  done < "$md"

  {
    printf '%s\n\n' "$frontmatter"
    cat "$tmp_body"
  } > "$dest"

  rm -f "$tmp_body"
  echo "Synced: $md -> $dest"
done
