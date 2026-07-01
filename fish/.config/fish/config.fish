if status is-interactive
  fzf --fish | source
  zoxide init fish | source
  atuin init fish --disable-up-arrow | source
end
