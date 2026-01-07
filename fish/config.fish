source /usr/share/cachyos-fish-config/cachyos-config.fish
# source ~/.config/fish/functions/navigation.fish
# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    greeting.fish
end

## Functions

# Remove current directory
function rmpwd
    # Запоминаем текущую директорию
    set current_dir (pwd)
    # Запрашиваем подтверждение у пользователя
    read -P "Вы уверены, что хотите удалить '$current_dir'? (y/n): " answer
    # Проверяем ответ
    if test "$answer" = y -o "$answer" = Y
        # Переходим на родительскую директорию
        cd ..
        # Удаляем директорию
        rm -rf "$current_dir"
        echo "Директория '$current_dir' удалена."
    else
        echo "Операция отменена."
    end
end

## Useful aliases
# Replace ls with eza
alias lss='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles
alias ls='eza -aG --color=always --icons'

# Common use
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl" # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Get fastest mirrors
alias rmirrors="sudo cachyos-rate-mirrors"

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias pls='sudo'
alias tb='nc termbin.com 9999'

# Get the error messages "

# Power & Sessionss
alias reboot='sudo reboot now'
alias terminate='loginctl terminate-user $(whoami)'
alias shutdown='sudo shutdown now'
alias session='lock-sessions'
alias user-status='loginctl user-status'
alias list-users='loginctl list-users'

# Others & Terminal
alias vcat='vimcat'
alias vc='vimcat'
alias c='cat'
alias n='nano'
alias sn='sudo nano'
alias snv='sudo nvim'
alias sv='sudo nvim'
alias svi='sudo nvim'
alias svn='sudo vi nano'
alias vs='vi sudo'
alias v='nvim'
alias vi='nvim'
alias nv='nvim'
alias vn='vi nano'
alias cls='clear'
alias clsls='clear && ls'
alias clslsl='clear && ls'
alias h='history'
alias ex='exit'
alias pls='sudo'
alias s='sudo'
alias ff='fastfetch'
alias pubip='curl ifconfig.me && echo ""'
alias lasterrors='journalctl -b -p err'
alias reload='source $HOME/.config/fish/config.fish'
alias d='dstl'

# Pacman
alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias paclean='sudo pacman -Sc'
alias pacins='sudo pacman -U'
alias paclr='sudo pacman -Scc'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacremc='sudo pacman -Rncs'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacinsd='sudo pacman -S --asdeps'
alias pacmir='sudo pacman -Syy'
alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'
alias pacfileupg='sudo pacman -Fy'
alias pacfiles='pacman -F'
alias pacls='pacman -Ql'
alias pacown='pacman -Qo'
alias pacupd='sudo pacman -Sy'

# AUR Helpers
alias yaconf='yay -Pg'
alias yaclean='yay -Sc'
alias yaclr='yay -Scc'
alias yaupg='yay -Syu'
alias yasu='yay -Syu --noconfirm'
alias yain='yay -S'
alias yains='yay -U'
alias yare='yay -R'
alias yarem='yay -Rns'
alias yarep='yay -Si'
alias yareps='yay -Ss'
alias yaloc='yay -Qi'
alias yalocs='yay -Qs'
alias yalst='yay -Qe'
alias yaorph='yay -Qtd'
alias yainsd='yay -S --asdeps'
alias yamir='yay -Syy'
alias yaupd='yay -Sy'

# Pacman others
alias pkglist='pacman -Qs --color=always | less -R'
alias pacman-fzf-local="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias pacman-fzf-remote="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"
alias paclocss='pacman -Qs --color=always | less -R'
alias pacloc='pacman -Qi | grep -E "Название|Описание" | less'
alias pacFU='sudo pacman -Syyu'
alias pacU='sudo pacman -Syu'

alias fullupdate='sudo pacman -Syyu'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# File & Directory
alias sl='ls'
alias mv='mv -i -nv'
alias cp='cp -i -rnv'
alias rm='rm -i'
alias toclip='xclip -i -selection clipboard'
alias fromclip='xclip -o -selection clipboard'
alias da='du -sch' # check current directory size
alias lad='ls -d .*/' # list directories starting with dot only	
alias lsa='ls -d .*' # list hidden directories & files starting with dot
alias lsbig='ls -lS --group-directories-first | head -n 11' # listk biggest directories and show top10
alias lsd='ls -d */' # list directories only 
alias ut='tar xf' # tar

# Network 
alias ipv4="ip addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1"
alias ping8='ping 8.8.8.8'
alias torsocks-test='torsocks curl 2ip.ru'
alias tor-test='curl --socks5-hostname 127.0.0.1:9050 https://2ip.ru'
alias ip='ip --color=auto'
alias pacman-proxy='http_proxy="http://127.0.0.1:12334" https_proxy="http://127.0.0.1:12334" pacman'
alias paru-proxy='http_proxy="http://127.0.0.1:12334" https_proxy="http://127.0.0.1:12334" paru'
alias yay-proxy='http_proxy="http://127.0.0.1:12334" https_proxy="http://127.0.0.1:12334" yay'
alias proxy='http_proxy="http://127.0.0.1:12334" https_proxy="http://127.0.0.1:12334" '
# System
alias sctl='sudo systemctl'
alias Stop='sudo systemctl stop'
alias Start='sudo systemctl start'
alias Restart='sudo systemctl restart'
alias Enable='sudo systemctl enable'
alias Disable='sudo systemctl disable'
alias Status='sudo systemctl status'
alias dmesgg='dmesg --human --follow-new --decode --kernel'
alias lsblkk='lsblk -o NAME,FSTYPE,PARTLABEL,LABEL,MOUNTPOINT,TYPE,TRAN,SIZE,MODEL,VENDOR'
alias tlog='tail -f /var/log/syslog || journalctl'
alias drop-caches 'echo 3 | sudo tee /proc/sys/vm/drop_caches'
alias swapr 'sudo swapoff -a && sudo swapon -a'
