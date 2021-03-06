# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.
   1. `chdir("/tmp")`
2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
   1. `/usr/share/misc/magic.mgc`
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
   1. На примере с `vi`  
   `lsof | grep test`
   ```bash
   vi    1340    vagrant    3u    REG     253,0    12288     131084 /home/vagrant/.test_file.swp (deleted)
   ```
   `echo '' > /proc/1340/fd/3`
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
   1. Когда процесс становится зомби, он освобождает все свои ресурсы т.е. это пустая запись в таблице процессов, хранящая статус завершения, предназначенная для чтения родительским процессом.
5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
   На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
   1. `sudo opensnoop-bpfcc`
   ```bash
   PID    COMM               FD ERR PATH
   767    vminfo              6   0 /var/run/utmp
   571    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
   571    dbus-daemon        18   0 /usr/share/dbus-1/system-services
   571    dbus-daemon        -1   2 /lib/dbus-1/system-services
   571    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
   ```
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
   1. системный вызов uname()  
   Цитата из man: `/proc/version`  
   This string identifies the kernel version that is currently running.  It includes the contents of /proc/sys/kernel/ostype, /proc/sys/kernel/osrelease and /proc/sys/kernel/version.
7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
   1. `&&` - условный оператор  
   `;` - разделитель последовательных команд  
   `set -e` - указывает оболочке выйти, если команда дает ненулевой статус выхода. Проще говоря, оболочка завершает работу при сбое команды. Вероятно использовать `&&`, если применить `set -e` смысла нет, т.к. выполнение команды прекратится.
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
   1. `-e` указывает оболочке выйти, если команда дает ненулевой статус выхода.  
   `-u` обрабатывает неустановленные или неопределенные переменные, за исключением специальных параметров, таких как подстановочные знаки `*` или `@`, как ошибки во время раскрытия параметра.  
   `-x` печатает аргументы команды во время выполнения.  
   `-o pipefail` возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.  
   Данный режим удобно использовать для отладки сценария
9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   1. `S` - ожидание события завершения  
   `I` - простаивающие в потоке ядра  
   Дополнительные символы это дополнительные характеристики статуса процесса