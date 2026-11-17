typeset -U path

eval "$(fnm env --use-on-cd)"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt PROMPT_SUBST
setopt AUTO_CD
stty -ixon

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
git_branch_name() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        echo "%F{cyan}($branch)%f $ "
    else
        echo "$ "
    fi
}
PROMPT='%F{yellow}%1~%f • $(git_branch_name)'

alias c="claude"
alias cr="claude --resume"
alias cw="claude --worktree"
# A function, not an alias, so it prints a confirmation line. The bare alias wrote
# nothing to stdout, which made it indistinguishable from a no-op.
# The unalias is required: zsh expands aliases at parse time, so re-sourcing this file
# in a shell that still holds the old `pr` alias would parse `pr()` as the alias body.
unalias pr 2>/dev/null
pr() {
    local info
    info=$(gh pr view "$@" --json number,title -q '"#\(.number) — \(.title)"' 2>/dev/null)
    gh pr view --web "$@" || return $?
    echo "→ opened ${info:-PR} in browser"
}
alias reload="source ~/.zshrc"
alias editzsh="cursor ~/.zshrc"
alias gti="git"
alias run="npm run"
alias ts-count='echo "TypeScript files: $(find . -type f \( -name "*.ts" -o -name "*.tsx" \) -not -path "*/node_modules/*" -not -path "*/.next/*" | wc -l)"; echo "JavaScript files: $(find . -type f \( -name "*.js" -o -name "*.jsx" \) -not -path "*/node_modules/*" -not -path "*/.next/*" | wc -l)"'
alias ts-expect-count='grep -r --exclude-dir={node_modules,.next} "@ts-expect-error" . | wc -l'

fresh() {
    local base="$HOME/Developer/zetland"
    for repo in app web api; do
        echo "==> $repo"
        (cd "$base/$repo" && git switch main && git pull) || return 1
    done
    clear
    echo "All repos are up to date ✨"
}

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.local/bin:$PATH"

source <(fzf --zsh)

# opencode
export PATH=/Users/thomasflensted/.opencode/bin:$PATH

# Pi
export PATH="/Users/thomasflensted/.local/share/fnm/node-versions/v23.11.1/installation/bin:$PATH"
