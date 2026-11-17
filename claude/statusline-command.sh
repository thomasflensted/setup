#!/bin/sh
input=$(cat)

# Directory (basename only, matching %1~ in zsh PROMPT)
dir=$(echo "$input" | jq -r '.cwd')
basename_dir=$(basename "$dir")

# Git branch (--no-optional-locks avoids touching lock files)
branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Repo/PR info, used to build a clickable link for the branch
repo_owner=$(echo "$input" | jq -r '.workspace.repo.owner // empty')
repo_name=$(echo "$input" | jq -r '.workspace.repo.name // empty')
repo_host=$(echo "$input" | jq -r '.workspace.repo.host // empty')
pr_url=$(echo "$input" | jq -r '.pr.url // empty')

branch_url=""
if [ -n "$pr_url" ]; then
    branch_url="$pr_url"
elif [ -n "$repo_owner" ] && [ -n "$repo_name" ] && [ -n "$branch" ]; then
    branch_url="https://${repo_host:-github.com}/${repo_owner}/${repo_name}/tree/${branch}"
fi

# Context used percentage (pre-calculated)
used=$(echo "$input" | jq -r '.context_window.used_percentage // "N/A"')

# Session rate limit usage (5-hour window)
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // "N/A"')

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // "—"' | sed 's/ (.*)//')

# Output style name
output_style=$(echo "$input" | jq -r '.output_style.name // empty')

# ANSI colors
yellow='\033[33m'
cyan='\033[36m'
reset='\033[0m'

# Directory part: yellow basename
line=$(printf "${yellow}%s${reset}" "$basename_dir")

# Git branch part: cyan (branch)
if [ -n "$branch" ]; then
    line=$(printf "%s ${cyan}(%s)${reset}" "$line" "$branch")
fi

# Context usage
if [ "$used" = "N/A" ]; then
    line=$(printf "%s  ctx: N/A" "$line")
elif [ -n "$used" ]; then
    used_int=$(printf "%.0f" "$used")
    line=$(printf "%s  ctx: %s%%" "$line" "$used_int")
fi

# Session usage (5-hour rate limit)
if [ "$five_hour" = "N/A" ]; then
    line=$(printf "%s  session: N/A" "$line")
elif [ -n "$five_hour" ]; then
    five_int=$(printf "%.0f" "$five_hour")
    line=$(printf "%s  session: %s%%" "$line" "$five_int")
fi

# Model name
if [ -n "$model" ]; then
    line=$(printf "%s  %s" "$line" "$model")
fi

# Output style
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    line=$(printf "%s  ${cyan}[%s]${reset}" "$line" "$output_style")
fi

printf "%s" "$line"
