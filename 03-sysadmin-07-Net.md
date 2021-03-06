# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
   1. Linux - `ip -c -br link`
   2. Windows - `ipconfig /all` или `netsh interface ip show interfaces`

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
   1. Протокол - `LLDP`
   2. Пакет в Linux - `lldpd`
   3. Команда - `lldpctl`

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
   1. Технология - `VLAN ID`
   2. Пакет - `vlan`  
   3. 
   ```bash
   cat /etc/network/interfaces
   auto eth0.1400
   iface eth0.1400 inet static
           address 192.168.1.1
           netmask 255.255.255.0
           vlan_raw_device eth0
   ```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
   1. Типы агрегации - статический и динамический
   2. Опции для балансировки нагрузки Bonding:
      1. balance-rr - трафик распределяется по принципу «карусели»: пакеты по очереди направляются на сетевые карты объединённого интерфейса
      2. active-backup - активен только один физический интерфейс, а остальные работают как резервные на случай отказа основного
      3. balance-xor - объединенный интерфейс определяет, через какую физическую сетевую карту отправить пакеты, в зависимости от MAC-адресов источника и получателя
      4. broadcast - широковещательный режим, все пакеты отправляются через каждый интерфейс
      5. 802.3ad - реализует стандарты объединения каналов IEEE и обеспечивает как увеличение пропускной способности, так и отказоустойчивость. Требует поддержку на коммутаторе
      6. balance-tlb - входящий трафик обрабатывается в обычном режиме, а при передаче интерфейс определяется на основе данных о загруженности
      7. balance-alb - аналогично предыдущему режиму, но с возможностью балансировать также входящую нагрузку
   3. `/etc/network/interfaces`  
   ```bash
   # Define slaves   
   auto eth0
   iface eth0 inet manual
       bond-master bond0
       bond-primary eth0
       bond-mode active-backup
      
   auto wlan0
   iface wlan0 inet manual
       wpa-conf /etc/network/wpa.conf
       bond-master bond0
       bond-primary eth0
       bond-mode active-backup
   
   # Define master
   auto bond0
   iface bond0 inet dhcp
       bond-slaves none
       bond-primary eth0
       bond-mode active-backup
       bond-miimon 100
   ```

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
   1. В сети с маской /29 - 6 хостов, 1 идентификатор сети, 1 широковещательный адрес.
   2. `sipcalc -s 29 10.10.10.0/24` - 32 подсети /29 в сети /24
   ```bash
   Network                 - 10.10.10.0      - 10.10.10.7
   Network                 - 10.10.10.8      - 10.10.10.15
   Network                 - 10.10.10.16     - 10.10.10.23 
   ...
   Network                 - 10.10.10.232    - 10.10.10.239
   Network                 - 10.10.10.240    - 10.10.10.247
   Network                 - 10.10.10.248    - 10.10.10.255
   ```

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
   1. Из сети Carrier-Grade NAT 100.64.0.0/26, это 62 хоста. Если брать подсеть размером /27, тогда уже будет 30 хостов, что не вписывается в условия задачи (`ipcalc --split 50 100.64.0.0/10`)

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
   1. Проверить ARP таблицу:
      1. Linux - `ip neigh show`
      2. Windows - `arp -a`
   2. Очистить ARP кеш полностью:
      1. Linux - `ip neigh flush all`
      2. Windows - `netsh interface ip delete arpcache`
   3. Удалить з ARP таблицы только один нужный IP:
      1. Linux - `ip neigh del dev eth0 192.168.1.101`
      2. Windows - `arp -d 192.168.1.121`



 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
 ---