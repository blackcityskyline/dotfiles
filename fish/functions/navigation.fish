# ============================================
# navigation.fish - Enhanced Navigation for Fish Shell
# ============================================
# Загрузите в ~/.config/fish/functions/navigation.fish
# или добавьте в config.fish: source ~/.config/fish/functions/navigation.fish
# ============================================

# ============================================
# ОСНОВНАЯ НАВИГАЦИЯ
# ============================================

# Быстрая навигация по папкам
function .. --description 'Перейти на уровень выше'
    cd ..
end

function ... --description 'Перейти на два уровня выше'
    cd ../..
end

function .... --description 'Перейти на три уровня выше'
    cd ../../..
end

function ..... --description 'Перейти на четыре уровня выше'
    cd ../../../..
end

# Для домашней папки используйте встроенный cd ~
# или добавьте в config.fish: abbr --add ~ 'cd ~'

# Создать папку и перейти в неё
function mkcd --description 'Создать папку и перейти в неё'
    if test (count $argv) -eq 0
        echo "Использование: mkcd <имя_папки>"
        return 1
    end

    mkdir -p $argv[1]
    and cd $argv[1]
end

# Создать несколько папок
function mkdirs --description 'Создать несколько папок'
    for dir in $argv
        mkdir -p $dir
        echo "Создано: $dir"
    end
end

# ============================================
# КОПИРОВАНИЕ И ПЕРЕМЕЩЕНИЕ
# ============================================

# Копировать и перейти в целевую папку
function cpc --description 'Копировать файл/папку и перейти в целевую директорию'
    if test (count $argv) -lt 2
        echo "Использование: cpc <источник> <цель>"
        return 1
    end

    cp -r $argv
    if test $status -eq 0
        cd (dirname $argv[-1])
    end
end

# Копировать несколько файлов и перейти
function cpcd --description 'Копировать несколько файлов и перейти в целевую директорию'
    if test (count $argv) -lt 2
        echo "Использование: cpcd <файл1> <файл2> ... <целевая_папка>"
        return 1
    end

    cp -r $argv
    if test $status -eq 0
        cd $argv[-1]
    end
end

# Переместить и перейти
function mvc --description 'Переместить файл/папку и перейти в целевую директорию'
    if test (count $argv) -lt 2
        echo "Использование: mvc <источник> <цель>"
        return 1
    end

    mv $argv
    if test $status -eq 0
        cd (dirname $argv[-1])
    end
end

# Копировать с прогрессом (требуется rsync)
function cpv --description 'Копировать с отображением прогресса'
    if not command -q rsync
        echo "Установите rsync: sudo pacman -S rsync"
        return 1
    end

    rsync -WavP --human-readable --progress $argv
end

# ============================================
# УДАЛЕНИЕ И КОРЗИНА
# ============================================

# Безопасное удаление в корзину
function trash --description 'Переместить файлы в корзину'
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

# Очистить корзину
function empty-trash --description 'Очистить корзину'
    if test -d ~/.trash
        echo "Очистка корзины..."
        rm -rf ~/.trash/*
        echo "Корзина очищена"
    else
        echo "Корзина не существует"
    end
end

# Показать содержимое корзины
function show-trash --description 'Показать содержимое корзины'
    if test -d ~/.trash
        echo "Содержимое корзины (~/.trash/):"
        eza -al --color=always --group-directories-first --icons ~/.trash/
    else
        echo "Корзина не существует"
    end
end

# Восстановить из корзины
function restore --description 'Восстановить файл из корзины'
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
# ПРОСМОТР ФАЙЛОВ И ПАПОК (с eza)
# ============================================

# Быстрый просмотр содержимого папки
function l --description 'Показать файлы в компактном формате'
    eza -aG --color=always --icons
end

function la --description 'Показать все файлы (включая скрытые)'
    eza -a --color=always --group-directories-first --icons
end

function ll --description 'Подробный список файлов'
    eza -al --color=always --group-directories-first --icons
end

function lss --description 'Полный подробный список (предпочтительный)'
    eza -al --color=always --group-directories-first --icons
end

# Показать только папки
function lsd --description 'Показать только директории'
    eza -D --color=always --group-directories-first --icons
end

# Показать только файлы
function lsf --description 'Показать только файлы (не директории)'
    eza -a --color=always --icons | grep -v '/$' | head -20
end

# Дерево каталогов
function lt --description 'Показать дерево каталогов'
    eza -aT --color=always --group-directories-first --icons $argv
end

# Дотфайлы
function ldot --description 'Показать только дотфайлы'
    eza -a --color=always --icons | grep -e '^\.'
end

# Сортировка по размеру
function lls --description 'Сортировка по размеру'
    eza -alS --color=always --group-directories-first --icons
end

# Сортировка по времени изменения
function llt --description 'Сортировка по времени изменения'
    eza -alt --color=always --group-directories-first --icons
end

# Гит статус (если eza с git)
function lg --description 'Показать с git статусом'
    eza -al --color=always --group-directories-first --icons --git $argv
end

# ============================================
# РАЗМЕРЫ И ИНФОРМАЦИЯ
# ============================================

# Размер файлов и папок
function dus --description 'Показать размер файлов/папок отсортированный'
    du -sh * | sort -h
end

function duh --description 'Размер текущей папки'
    du -sh .
end

function du-top --description 'Топ 10 самых больших папок'
    du -h --max-depth=1 | sort -hr | head -10
end

# Информация о файле
function info --description 'Подробная информация о файле'
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
# БЫСТРАЯ НАВИГАЦИЯ ПО ЧАСТЫМ ПАПКАМ
# ============================================

# Домашние папки
function docs --description 'Перейти в Документы'
    cd ~/Documents
end

function downloads --description 'Перейти в Загрузки'
    cd ~/Downloads
end

function desktop --description 'Перейти в Рабочий стол'
    cd ~/Desktop
end

function config --description 'Перейти в конфиги'
    cd ~/.config
end

function projects --description 'Перейти в папку проектов'
    cd ~/projects
end

# Системные папки
function etc --description 'Перейти в /etc'
    cd /etc
end

function var --description 'Перейти в /var'
    cd /var
end

function tmp --description 'Перейти в /tmp'
    cd /tmp
end

function log --description 'Перейти в логи'
    cd /var/log
end

# ============================================
# ЗАКЛАДКИ (BOOKMARKS)
# ============================================

# Добавить закладку
function bookmark --description 'Добавить закладку на текущую папку'
    if test (count $argv) -eq 0
        echo "Использование: bookmark <имя_закладки>"
        return 1
    end

    set bookmark_name $argv[1]
    set bookmark_file ~/.config/fish/bookmarks.fish

    # Создаем файл если нет
    if not test -f $bookmark_file
        touch $bookmark_file
    end

    # Добавляем закладку
    echo "function $bookmark_name --description 'Закладка: $bookmark_name'; cd $PWD; end" >>$bookmark_file

    # Загружаем закладку
    source $bookmark_file

    echo "Закладка '$bookmark_name' добавлена для: $PWD"
end

# Список закладок
function bookmarks --description 'Показать все закладки'
    set bookmark_file ~/.config/fish/bookmarks.fish

    if test -f $bookmark_file
        echo "Список закладок:"
        grep "function " $bookmark_file | sed 's/function //' | sed "s/ --description.*//"
    else
        echo "Нет сохраненных закладок"
        echo "Добавьте закладку: bookmark <имя>"
    end
end

# Удалить закладку
function unbookmark --description 'Удалить закладку'
    if test (count $argv) -eq 0
        echo "Использование: unbookmark <имя_закладки>"
        bookmarks
        return 1
    end

    set bookmark_name $argv[1]
    set bookmark_file ~/.config/fish/bookmarks.fish

    if test -f $bookmark_file
        # Удаляем функцию
        functions -e $bookmark_name

        # Удаляем из файла
        sed -i "/function $bookmark_name /d" $bookmark_file

        echo "Закладка '$bookmark_name' удалена"
    else
        echo "Файл закладок не найден"
    end
end

# ============================================
# ИСТОРИЯ НАВИГАЦИИ
# ============================================

# Показать историю переходов
function dirhistory --description 'Показать историю переходов по папкам'
    dirs -v
end

# Быстрый переход по истории
function d --description 'Перейти по номеру из истории'
    if test (count $argv) -eq 0
        dirhistory
        return
    end

    cd ~$argv[1]
end

# Поиск в истории
function find-dir --description 'Найти папку в истории'
    if test (count $argv) -eq 0
        echo "Использование: find-dir <часть_пути>"
        return 1
    end

    dirs -v | grep -i $argv[1]
end

# ============================================
# ПОИСК ФАЙЛОВ И ПАПОК
# ============================================

# Найти файл по имени
function findf --description 'Найти файл по имени'
    if test (count $argv) -eq 0
        echo "Использование: findf <имя_файла>"
        return 1
    end

    find . -type f -name "*$argv[1]*" 2>/dev/null
end

# Найти папку по имени
function findd --description 'Найти папку по имени'
    if test (count $argv) -eq 0
        echo "Использование: findd <имя_папки>"
        return 1
    end

    find . -type d -name "*$argv[1]*" 2>/dev/null
end

# Найти любой файл/папку
function findall --description 'Найти файл или папку'
    if test (count $argv) -eq 0
        echo "Использование: findall <имя>"
        return 1
    end

    find . -name "*$argv[1]*" 2>/dev/null
end

# Быстрый поиск файлов
function ff --description 'Быстрый поиск файлов (рекурсивный)'
    if test (count $argv) -eq 0
        echo "Использование: ff <шаблон>"
        return 1
    end

    fd $argv[1] . 2>/dev/null || find . -type f -iname "*$argv[1]*" 2>/dev/null
end

# ============================================
# РАБОТА С АРХИВАМИ
# ============================================

# Создать архив
function tarz --description 'Создать tar.gz архив'
    if test (count $argv) -eq 0
        echo "Использование: tarz <имя_архива> <файлы...>"
        return 1
    end

    tar -czf $argv[1].tar.gz $argv[2..-1]
    echo "Создан архив: $argv[1].tar.gz"
end

function tarbz --description 'Создать tar.bz2 архив'
    if test (count $argv) -eq 0
        echo "Использование: tarbz <имя_архива> <файлы...>"
        return 1
    end

    tar -cjf $argv[1].tar.bz2 $argv[2..-1]
    echo "Создан архив: $argv[1].tar.bz2"
end

# Распаковать архив
function untar --description 'Распаковать tar архив'
    if test (count $argv) -eq 0
        echo "Использование: untar <архив.tar.gz>"
        return 1
    end

    tar -xzf $argv[1]
    echo "Распакован: $argv[1]"
end

function unzip-all --description 'Распаковать все zip файлы в текущей папке'
    for file in *.zip
        if test -f $file
            echo "Распаковка: $file"
            unzip $file
        end
    end
end

# ============================================
# СИМВОЛИЧЕСКИЕ ССЫЛКИ
# ============================================

# Создать симлинк
function mklink --description 'Создать символическую ссылку'
    if test (count $argv) -ne 2
        echo "Использование: mklink <цель> <имя_ссылки>"
        return 1
    end

    ln -s $argv[1] $argv[2]
    echo "Создана ссылка: $argv[2] → $argv[1]"
end

# Найти битые ссылки
function find-broken-links --description 'Найти битые символические ссылки'
    find -L . -type l
end

# ============================================
# РЕЗЕРВНОЕ КОПИРОВАНИЕ
# ============================================

# Бэкап файла
function backup --description 'Создать резервную копию файла'
    if test (count $argv) -eq 0
        echo "Использование: backup <файл>"
        return 1
    end

    for file in $argv
        if test -e $file
            cp -r $file $file.backup.$(date +%Y%m%d_%H%M%S)
            echo "Бэкап создан: $file → $file.backup.*"
        else
            echo "Файл не существует: $file"
        end
    end
end

# Восстановить из бэкапа
function restore-backup --description 'Восстановить из последнего бэкапа'
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
# ИНФОРМАЦИЯ О ТЕКУЩЕЙ ПАПКЕ
# ============================================

function pwd-info --description 'Информация о текущей папке'
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
# ПЕРЕКЛЮЧЕНИЕ МЕЖДУ ПАПКАМИ
# ============================================

# Быстрое переключение между двумя папками
function toggle-dir --description 'Переключиться между двумя папками'
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

# Перейти в папку проекта (ищет .git, package.json и т.д.)
function find-project-root --description 'Найти корень проекта и перейти в него'
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

# Перейти в папку по типу файла
function goto-type --description 'Перейти в папку по типу файла'
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
# ИНИЦИАЛИЗАЦИЯ И ПОМОЩЬ
# ============================================

# Показать справку
function nav-help --description 'Показать справку по навигации'
    echo "============================================"
    echo "НАВИГАЦИОННЫЕ КОМАНДЫ FISH SHELL (с eza)"
    echo "============================================"
    echo ""
    echo "ОСНОВНАЯ НАВИГАЦИЯ:"
    echo "  .., ..., ...., .....  - На уровень выше"
    echo "  cd ~                  - Домашняя папка (встроено)"
    echo "  mkcd <dir>            - Создать папку и перейти"
    echo ""
    echo "КОПИРОВАНИЕ/ПЕРЕМЕЩЕНИЕ:"
    echo "  cpc <src> <dst>       - Копировать и перейти"
    echo "  mvc <src> <dst>       - Переместить и перейти"
    echo "  cpv <src> <dst>       - Копировать с прогрессом"
    echo ""
    echo "УДАЛЕНИЕ И КОРЗИНА:"
    echo "  trash <files>         - В корзину"
    echo "  empty-trash           - Очистить корзину"
    echo "  restore <file>        - Восстановить из корзины"
    echo "  show-trash            - Показать корзину"
    echo ""
    echo "ПРОСМОТР (с eza):"
    echo "  l, la, ll, lss        - Разные форматы eza"
    echo "  lsd                   - Только директории"
    echo "  lsf                   - Только файлы"
    echo "  lt                    - Дерево каталогов"
    echo "  ldot                  - Только дотфайлы"
    echo "  lls                   - Сортировка по размеру"
    echo "  llt                   - Сортировка по времени"
    echo "  lg                    - С git статусом"
    echo "  dus, duh, du-top      - Размеры"
    echo "  info <file>           - Информация о файле"
    echo ""
    echo "ЗАКЛАДКИ:"
    echo "  bookmark <name>       - Добавить закладку"
    echo "  bookmarks             - Список закладок"
    echo "  unbookmark <name>     - Удалить закладку"
    echo ""
    echo "ПОИСК:"
    echo "  findf <name>          - Найти файл"
    echo "  findd <name>          - Найти папку"
    echo "  ff <pattern>          - Быстрый поиск"
    echo ""
    echo "АРХИВЫ:"
    echo "  tarz <name> <files>   - Создать tar.gz"
    echo "  untar <archive>       - Распаковать"
    echo "  unzip-all             - Распаковать все zip"
    echo ""
    echo "БЭКАП:"
    echo "  backup <file>         - Резервная копия"
    echo "  restore-backup <file> - Восстановить"
    echo ""
    echo "ИНФОРМАЦИЯ:"
    echo "  pwd-info              - Инфо о текущей папке"
    echo "  nav-help              - Эта справка"
    echo "============================================"
end

# Инициализация
function navigation-init --description 'Инициализировать навигационные функции'
    #  echo "Навигационные функции загружены (использует eza)"
    #  echo "Используйте 'nav-help' для справки"

    # Создаем папку для закладок если нет
    mkdir -p ~/.config/fish

    # Загружаем закладки если есть
    if test -f ~/.config/fish/bookmarks.fish
        source ~/.config/fish/bookmarks.fish
    end
end

# Автоматически вызываем инициализацию при загрузке
navigation-init
