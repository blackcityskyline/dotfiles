# ============================================
# navigation.fish - Полная навигация для Fish Shell
# ============================================

# ФЛАГ ИНИЦИАЛИЗАЦИИ
if not set -q __NAV_INITIALIZED
    set -g __NAV_INITIALIZED true

    # ============================================
    # ЯДРО: АББРЕВИАТУРЫ ДЛЯ САМЫХ ЧАСТЫХ КОМАНД
    # ============================================

    # БАЗОВАЯ НАВИГАЦИЯ
    abbr .. 'cd ..'
    abbr ... 'cd ../..'
    abbr .... 'cd ../../..'
    abbr ..... 'cd ../../../..'

    # ОСНОВНОЙ ПРОСМОТР
    abbr l 'command -q eza && eza -aG --icons || ls -la'
    abbr la 'command -q eza && eza -a --group-directories-first --icons || ls -la'
    abbr ll 'command -q eza && eza -al --group-directories-first --icons || ls -la'
    abbr lss 'command -q eza && eza -al --group-directories-first --icons || ls -la'

    # ЧАСТЫЕ ПАПКИ
    abbr docs 'cd ~/Documents'
    abbr downloads 'cd ~/Downloads'
    abbr desktop 'cd ~/Desktop'
    abbr config 'cd ~/.config'
    abbr projects 'cd ~/projects'
    abbr etc 'cd /etc'
    abbr var 'cd /var'
    abbr tmp 'cd /tmp'
    abbr log 'cd /var/log'

    # ============================================
    # ФУНКЦИИ БЫСТРОЙ ЗАГРУЗКИ (легкие)
    # ============================================

    function mkcd
        mkdir -p $argv[1] && cd $argv[1]
    end

    function mkdirs
        for dir in $argv
            mkdir -p $dir
        end
    end

    # ============================================
    # СИСТЕМА ЛЕНИВОЙ ЗАГРУЗКИ
    # ============================================

    # Список всех функций для ленивой загрузки
    set -g __NAV_LAZY_FUNCTIONS \
        cpc cpcd mvc cpv \
        trash empty-trash show-trash restore \
        lsd lsf lt ldot lls llt lg \
        dus duh du-top info \
        bookmark bookmarks unbookmark \
        dirhistory d find-dir \
        findf findd findall ff \
        tarz tarbz untar unzip-all \
        mklink find-broken-links \
        backup restore-backup \
        pwd-info toggle-dir \
        find-project-root goto-type \
        nav-help

    # Создаем заглушки для всех функций
    for func in $__NAV_LAZY_FUNCTIONS
        function $func --inherit-variable func
            # Загружаем полные функции при первом вызове
            __nav_load_all_functions
            # Вызываем реальную функцию
            eval $func $argv
        end
    end

    # ============================================
    # ФУНКЦИЯ ПОЛНОЙ ЗАГРУЗКИ (все остальное)
    # ============================================

    function __nav_load_all_functions
        # Удаляем себя после первого вызова
        functions -e __nav_load_all_functions
        functions -e __NAV_LAZY_FUNCTIONS

        # ============================================
        # ОСНОВНАЯ НАВИГАЦИЯ (полные версии)
        # ============================================

        function ..
            cd ..
        end

        function ...
            cd ../..
        end

        function ....
            cd ../../..
        end

        function .....
            cd ../../../..
        end

        function mkcd
            if test (count $argv) -eq 0
                echo "Использование: mkcd <имя_папки>"
                return 1
            end
            mkdir -p $argv[1] && cd $argv[1]
        end

        function mkdirs
            for dir in $argv
                mkdir -p $dir
                echo "Создано: $dir"
            end
        end

        # ============================================
        # КОПИРОВАНИЕ И ПЕРЕМЕЩЕНИЕ
        # ============================================

        function cpc
            if test (count $argv) -lt 2
                echo "Использование: cpc <источник> <цель>"
                return 1
            end
            cp -r $argv && cd (dirname $argv[-1])
        end

        function cpcd
            if test (count $argv) -lt 2
                echo "Использование: cpcd <файл1> <файл2> ... <целевая_папка>"
                return 1
            end
            cp -r $argv && cd $argv[-1]
        end

        function mvc
            if test (count $argv) -lt 2
                echo "Использование: mvc <источник> <цель>"
                return 1
            end
            mv $argv && cd (dirname $argv[-1])
        end

        function cpv
            if not command -q rsync
                echo "Установите rsync: sudo apt install rsync"
                return 1
            end
            rsync -WavP --human-readable --progress $argv
        end

        # ============================================
        # УДАЛЕНИЕ И КОРЗИНА
        # ============================================

        function trash
            mkdir -p ~/.trash
            if test (count $argv) -eq 0
                echo "Использование: trash <файл1> <файл2> ..."
                return 1
            end
            for file in $argv
                if test -e $file
                    mv $file ~/.trash/
                    echo "Перемещено в корзину: $file"
                else
                    echo "Файл не найден: $file"
                end
            end
        end

        function empty-trash
            if test -d ~/.trash
                echo "Очистка корзины..."
                rm -rf ~/.trash/*
                echo "Корзина очищена"
            else
                echo "Корзина не существует"
            end
        end

        function show-trash
            if test -d ~/.trash
                echo "Содержимое корзины (~/.trash/):"
                eza -al --color=always --group-directories-first --icons ~/.trash/
            else
                echo "Корзина не существует"
            end
        end

        function restore
            if test (count $argv) -eq 0
                echo "Использование: restore <имя_файла>"
                echo "Доступные файлы:"
                eza -a --color=always --group-directories-first --icons ~/.trash/ 2>/dev/null
                return 1
            end
            for file in $argv
                if test -e ~/.trash/$file
                    mv ~/.trash/$file .
                    echo "Восстановлено: $file"
                else
                    echo "Файл не найден в корзине: $file"
                end
            end
        end

        # ============================================
        # ПРОСМОТР ФАЙЛОВ И ПАПОК
        # ============================================

        function l
            eza -aG --color=always --icons
        end

        function la
            eza -a --color=always --group-directories-first --icons
        end

        function ll
            eza -al --color=always --group-directories-first --icons
        end

        function lss
            eza -al --color=always --group-directories-first --icons
        end

        function lsd
            eza -D --color=always --group-directories-first --icons
        end

        function lsf
            eza -a --color=always --icons | grep -v '/$' | head -20
        end

        function lt
            eza -aT --color=always --group-directories-first --icons $argv
        end

        function ldot
            eza -a --color=always --icons | grep -e '^\.'
        end

        function lls
            eza -alS --color=always --group-directories-first --icons
        end

        function llt
            eza -alt --color=always --group-directories-first --icons
        end

        function lg
            eza -al --color=always --group-directories-first --icons --git $argv
        end

        # ============================================
        # РАЗМЕРЫ И ИНФОРМАЦИЯ
        # ============================================

        function dus
            du -sh * | sort -h
        end

        function duh
            du -sh .
        end

        function du-top
            du -h --max-depth=1 | sort -hr | head -10
        end

        function info
            if test (count $argv) -eq 0
                echo "Использование: info <файл>"
                return 1
            end
            for file in $argv
                echo "=== $file ==="
                if test -e $file
                    stat $file
                    echo "Тип: "(file -b $file)
                    if test -f $file
                        echo "Размер: "(du -h $file | cut -f1)
                        echo "Строк: "(wc -l < $file)
                        echo "EZA подробно:"
                        eza -l --color=always --icons $file
                    end
                else
                    echo "Файл не существует"
                end
                echo ""
            end
        end

        # ============================================
        # БЫСТРАЯ НАВИГАЦИЯ ПО ПАПКАМ (полные версии)
        # ============================================

        function docs
            cd ~/Documents
        end
        function downloads
            cd ~/Downloads
        end
        function desktop
            cd ~/Desktop
        end
        function config
            cd ~/.config
        end
        function projects
            cd ~/projects
        end
        function etc
            cd /etc
        end
        function var
            cd /var
        end
        function tmp
            cd /tmp
        end
        function log
            cd /var/log
        end

        # ============================================
        # ЗАКЛАДКИ
        # ============================================

        function bookmark
            if test (count $argv) -eq 0
                echo "Использование: bookmark <имя_закладки>"
                return 1
            end
            set bookmark_name $argv[1]
            set bookmark_file ~/.config/fish/bookmarks.fish
            if not test -f $bookmark_file
                touch $bookmark_file
            end
            echo "function $bookmark_name --description 'Закладка: $bookmark_name'; cd $PWD; end" >>$bookmark_file
            source $bookmark_file
            echo "Закладка '$bookmark_name' добавлена для: $PWD"
        end

        function bookmarks
            set bookmark_file ~/.config/fish/bookmarks.fish
            if test -f $bookmark_file
                echo "Список закладок:"
                grep "function " $bookmark_file | sed 's/function //' | sed "s/ --description.*//"
            else
                echo "Нет сохраненных закладок"
                echo "Добавьте закладку: bookmark <имя>"
            end
        end

        function unbookmark
            if test (count $argv) -eq 0
                echo "Использование: unbookmark <имя_закладки>"
                bookmarks
                return 1
            end
            set bookmark_name $argv[1]
            set bookmark_file ~/.config/fish/bookmarks.fish
            if test -f $bookmark_file
                functions -e $bookmark_name
                sed -i "/function $bookmark_name /d" $bookmark_file
                echo "Закладка '$bookmark_name' удалена"
            else
                echo "Файл закладок не найден"
            end
        end

        # ============================================
        # ИСТОРИЯ НАВИГАЦИИ
        # ============================================

        function dirhistory
            dirs -v
        end

        function d
            if test (count $argv) -eq 0
                dirhistory
                return
            end
            cd ~$argv[1]
        end

        function find-dir
            if test (count $argv) -eq 0
                echo "Использование: find-dir <часть_пути>"
                return 1
            end
            dirs -v | grep -i $argv[1]
        end

        # ============================================
        # ПОИСК ФАЙЛОВ
        # ============================================

        function findf
            if test (count $argv) -eq 0
                echo "Использование: findf <имя_файла>"
                return 1
            end
            find . -type f -name "*$argv[1]*" 2>/dev/null
        end

        function findd
            if test (count $argv) -eq 0
                echo "Использование: findd <имя_папки>"
                return 1
            end
            find . -type d -name "*$argv[1]*" 2>/dev/null
        end

        function findall
            if test (count $argv) -eq 0
                echo "Использование: findall <имя>"
                return 1
            end
            find . -name "*$argv[1]*" 2>/dev/null
        end

        function ff
            if test (count $argv) -eq 0
                echo "Использование: ff <шаблон>"
                return 1
            end
            fd $argv[1] . 2>/dev/null || find . -type f -iname "*$argv[1]*" 2>/dev/null
        end

        # ============================================
        # АРХИВЫ
        # ============================================

        function tarz
            if test (count $argv) -eq 0
                echo "Использование: tarz <имя_архива> <файлы...>"
                return 1
            end
            tar -czf $argv[1].tar.gz $argv[2..-1]
            echo "Создан архив: $argv[1].tar.gz"
        end

        function tarbz
            if test (count $argv) -eq 0
                echo "Использование: tarbz <имя_архива> <файлы...>"
                return 1
            end
            tar -cjf $argv[1].tar.bz2 $argv[2..-1]
            echo "Создан архив: $argv[1].tar.bz2"
        end

        function untar
            if test (count $argv) -eq 0
                echo "Использование: untar <архив.tar.gz>"
                return 1
            end
            tar -xzf $argv[1]
            echo "Распакован: $argv[1]"
        end

        function unzip-all
            for file in *.zip
                if test -f $file
                    echo "Распаковка: $file"
                    unzip $file
                end
            end
        end

        # ============================================
        # ССЫЛКИ
        # ============================================

        function mklink
            if test (count $argv) -ne 2
                echo "Использование: mklink <цель> <имя_ссылки>"
                return 1
            end
            ln -s $argv[1] $argv[2]
            echo "Создана ссылка: $argv[2] → $argv[1]"
        end

        function find-broken-links
            find -L . -type l
        end

        # ============================================
        # БЭКАП
        # ============================================

        function backup
            if test (count $argv) -eq 0
                echo "Использование: backup <файл>"
                return 1
            end
            for file in $argv
                if test -e $file
                    cp -r $file $file.backup.(date +%Y%m%d_%H%M%S)
                    echo "Бэкап создан: $file → $file.backup.*"
                else
                    echo "Файл не существует: $file"
                end
            end
        end

        function restore-backup
            if test (count $argv) -eq 0
                echo "Использование: restore-backup <файл>"
                return 1
            end
            set file $argv[1]
            set backup_file (ls -t $file.backup.* 2>/dev/null | head -1)
            if test -n "$backup_file" && test -f "$backup_file"
                cp $backup_file $file
                echo "Восстановлено: $backup_file → $file"
            else
                echo "Бэкап не найден для: $file"
            end
        end

        # ============================================
        # ИНФОРМАЦИЯ
        # ============================================

        function pwd-info
            echo "Текущая папка: $PWD"
            echo "Владелец: "(stat -c '%U' .)
            echo "Права: "(stat -c '%A' .)
            echo "Размер: "(du -sh . | cut -f1)
            echo "Файлов: "(find . -type f | wc -l)
            echo "Папок: "(find . -type d | wc -l)
            echo "Содержимое:"
            eza -a --color=always --group-directories-first --icons
        end

        # ============================================
        # ПЕРЕКЛЮЧЕНИЕ
        # ============================================

        function toggle-dir
            if not set -q TOGGLE_DIR_OTHER
                set -g TOGGLE_DIR_OTHER $PWD
                cd -
            else
                set temp $PWD
                cd $TOGGLE_DIR_OTHER
                set -g TOGGLE_DIR_OTHER $temp
            end
        end

        # ============================================
        # УМНАЯ НАВИГАЦИЯ
        # ============================================

        function find-project-root
            set current $PWD
            while test $current != /
                if test -d "$current/.git" -o \
                        -f "$current/package.json" -o \
                        -f "$current/Cargo.toml" -o \
                        -f "$current/pyproject.toml" -o \
                        -f "$current/Makefile"
                    cd $current
                    echo "Корень проекта найден: $current"
                    return
                end
                set current (dirname $current)
            end
            echo "Корень проекта не найден"
        end

        function goto-type
            if test (count $argv) -eq 0
                echo "Использование: goto-type <тип>"
                echo "Доступные типы: docs, images, videos, music, downloads"
                return 1
            end
            switch $argv[1]
                case docs documents
                    cd ~/Documents
                case images pics pictures
                    cd ~/Pictures
                case videos movies
                    cd ~/Videos
                case music audio
                    cd ~/Music
                case downloads
                    cd ~/Downloads
                case '*'
                    echo "Неизвестный тип: $argv[1]"
            end
        end

        # ============================================
        # СПРАВКА
        # ============================================

        function nav-help --description 'Краткая справка с описанием и оригинальными командами'
            # Цвета
            set -l green (set_color green) # Сокращенные команды
            set -l purple (set_color magenta) # Оригинальные команды
            set -l gray (set_color 888) # Описания
            set -l bold (set_color -o)
            set -l reset (set_color normal)

            echo "$bold🚀 НАВИГАЦИЯ FISH$reset - $boldОПИСАНИЕ И ОРИГИНАЛЫ$reset"
            echo "$bold══════════════════════════════════════════════════$reset"

            echo "$bold📁 НАВИГАЦИЯ:$reset"
            echo "  $green..$reset ../ ....           - На уровень выше      $purple→ cd ..$reset"
            echo "  $green mkcd$reset <dir>           - Создать и перейти    $purple→ mkdir -p dir && cd dir$reset"
            echo "  $green mkdirs$reset <dirs...>     - Создать несколько    $purple→ mkdir -p dir1 dir2$reset"

            echo "$bold📋 КОПИРОВАНИЕ/ПЕРЕМЕЩЕНИЕ:$reset"
            echo "  $green cpc$reset <src> <dst>     - Копировать+перейти   $purple→ cp -r src dst && cd (dirname dst)$reset"
            echo "  $green mvc$reset <src> <dst>     - Переместить+перейти  $purple→ mv src dst && cd (dirname dst)$reset"
            echo "  $green cpv$reset <src> <dst>     - Копирование с прогрессом $purple→ rsync -avP src dst$reset"

            echo "$bold🗑️  КОРЗИНА:$reset"
            echo "  $green trash$reset <files>       - Безопасное удаление  $purple→ mv files ~/.trash/$reset"
            echo "  $green empty-trash$reset         - Очистить корзину     $purple→ rm -rf ~/.trash/*$reset"
            echo "  $green show-trash$reset          - Показать корзину     $purple→ eza -al ~/.trash/$reset"
            echo "  $green restore$reset <file>      - Восстановить файл    $purple→ mv ~/.trash/file .$reset"

            echo "$bold👁️  ПРОСМОТР (eza):$reset"
            echo "  $green l$reset                   - Компактный формат    $purple→ eza -aG --icons$reset"
            echo "  $green la$reset                  - Все файлы            $purple→ eza -a --group-directories-first$reset"
            echo "  $green ll$reset / $green lss$reset            - Подробный список    $purple→ eza -al$reset"
            echo "  $green lsd$reset                 - Только папки         $purple→ eza -D$reset"
            echo "  $green lsf$reset                 - Только файлы         $purple→ eza -a | grep -v '/\$'$reset"
            echo "  $green lt$reset                  - Дерево каталогов     $purple→ eza -aT$reset"
            echo "  $green lls$reset                 - Сортировка по размеру $purple→ eza -alS$reset"
            echo "  $green llt$reset                 - Сортировка по времени $purple→ eza -alt$reset"
            echo "  $green lg$reset                  - С git статусом       $purple→ eza -al --git$reset"

            echo "$bold🔖 ЗАКЛАДКИ:$reset"
            echo "  $green bookmark$reset <name>     - Создать закладку     $purple→ echo 'function name; cd \$PWD; end' >> bookmarks.fish$reset"
            echo "  $green bookmarks$reset           - Список закладок      $purple→ grep 'function ' bookmarks.fish$reset"
            echo "  $green unbookmark$reset <name>   - Удалить закладку     $purple→ sed -i '/function name /d' bookmarks.fish$reset"

            echo "$bold🔍 ПОИСК:$reset"
            echo "  $green findf$reset <name>       - Найти файлы          $purple→ find . -type f -name '*name*'$reset"
            echo "  $green findd$reset <name>       - Найти папки          $purple→ find . -type d -name '*name*'$reset"
            echo "  $green ff$reset <pattern>       - Быстрый поиск        $purple→ fd pattern или find -iname$reset"

            echo "$bold📦 АРХИВЫ:$reset"
            echo "  $green tarz$reset <n> <files>   - Создать tar.gz       $purple→ tar -czf n.tar.gz files$reset"
            echo "  $green untar$reset <archive>    - Распаковать          $purple→ tar -xzf archive$reset"
            echo "  $green unzip-all$reset          - Распаковать все zip  $purple→ for f in *.zip; unzip \$f$reset"

            echo "$bold💾 БЭКАП:$reset"
            echo "  $green backup$reset <file>      - Резервная копия      $purple→ cp file file.backup.(date)$reset"
            echo "  $green restore-backup$reset     - Восстановить бэкап   $purple→ cp file.backup.* file$reset"

            echo "$bold🔄 СИСТЕМА:$reset"
            echo "  $green toggle-dir$reset         - Переключение папок   $purple→ cd между текущей и предыдущей$reset"
            echo "  $green find-project-root$reset  - Найти корень проекта $purple→ поиск .git/package.json вверх$reset"
            echo "  $green dirhistory$reset         - История навигации    $purple→ dirs -v$reset"
            echo "  $green d$reset <number>         - Перейти по номеру    $purple→ cd ~число$reset"

            echo "$bold📊 ИНФОРМАЦИЯ:$reset"
            echo "  $green dus$reset                - Размеры папок        $purple→ du -sh * | sort -h$reset"
            echo "  $green info$reset <file>        - Инфо о файле         $purple→ stat file + file -b + wc -l$reset"
            echo "  $green pwd-info$reset           - Инфо о папке         $purple→ du, find, eza$reset"

            echo "$bold🏠 БЫСТРЫЕ ПАПКИ:$reset"
            echo "  $green docs$reset               - Документы            $purple→ cd ~/Documents$reset"
            echo "  $green downloads$reset          - Загрузки             $purple→ cd ~/Downloads$reset"
            echo "  $green desktop$reset            - Рабочий стол         $purple→ cd ~/Desktop$reset"
            echo "  $green config$reset             - Конфиги              $purple→ cd ~/.config$reset"
            echo "  $green projects$reset           - Проекты              $purple→ cd ~/projects$reset"
            echo "  $green etc$reset / $green var$reset / $green tmp$reset / $green log$reset  - Системные        $purple→ cd /etc /var /tmp /var/log$reset"

            echo "$bold══════════════════════════════════════════════════$reset"
            echo "$boldℹ️  Все команды:$reset $green functions -a | grep -v __$reset"
            echo "$bold📖 Детальное описание:$reset $green functions <команда>$reset"
        end

        # Загружаем закладки
        if test -f ~/.config/fish/bookmarks.fish
            source ~/.config/fish/bookmarks.fish 2>/dev/null
        end

        # Создаем папку для закладок если нет
        mkdir -p ~/.config/fish
    end

    # Тихая инициализация
    if set -q NAV_DEBUG
        echo "✅ Все навигационные функции готовы (ленивая загрузка)"
    end
end
