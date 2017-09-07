# Nginx

## Table of content
- [Установка](#установка)
- [Запуск](#запуск)
- [Файлы nginx](#Файлы-nginx)
- [Конфигурация](#Конфигурация)
- [Location](#location)
- [Доступ к файлам](#Доступ-к-файлам)

## Установка

1. Install from package repository

    ```bash
    sudo apt-get install nginx
    ```

1. [Compiling and Installing From the Sources](https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/)

    * configure example
        ```bash
        ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-debug --with-pcre --with-http_ssl_module
        ```

## Запуск
1. Команда запуска
    ```bash
    sudo /etc/init.d/nginx start
    ```
    * `sudo` т.к. сервер должен прослушивать 80 порт

1. Чтение файла конфигурации
1. Получение порта 80
1. Открытие (создание) логов
1. Понижение привелегий (чтобы воркеры обрабатывающие запросы не имели прав `sudo`)
1. Запуск дочерних процессов/потоков
1. Готов к обработке запроса.

## Файлы nginx
1. **`/etc/nginx/nginx.conf`** - конфиг веб сервера

    * внутри конфига можно подключать другие конфиги

    ```
    include /etc/nginx/site-enabled/*
    ```
1. **`/etc/init.d/nginx [start|stop|restart]`** запуск\остановка\перезапуск сервера
1. **`/var/run/nginx.pid`** - id процесса nginx
1. **`/var/log/nginx/error.log`** - лог ошибок
1. **`/var/log/nginx/access.log`** - лог доступа

## Конфигурация
* Простейший конфиг для сервинга одной папки:
    ```
    events {

    }
    http {
        include mime.types;
        server {
            listen 80;
            root /path-to-your-dir;
        }
    }
    ```
* Терминология
    * **virtual host** - секция конфига отвечающая за обработку определённого домена (один веб сервер может обрабатывать несколько доментов).
    * **location** - секция конфига, отвечающая за обслуживание определенной группы URL
```
user www www;
error_log /var/log/nginx.error_log info;
http {
    include         conf/mime.types;
    default_type    application/octet-stream;
    log_format      simple '$remote_addr $request $status';
    server {
        listen      80;
        server_name one.example.com www.one.exampe.com;
        access_log  /var/log/nginx.access_log simple;
        location / {
            root    /www/one.example.com;
        }
        location ~* ^.+\.(jpg|jpeg|gif)$ {
            root    /www/images;
            access_log off;
            expires 30d;
        }
    }
}
```
1. **`user`** - от какого пользователя и группы работают worker'ы
1. **`error_log`** - куда и с каким уровнем отправлять логи
1. **`http`** - начало конфига веб сервера
1. **`include`** - подключает другой файл(ы) конфигов
1. **`default_type`** - mime тип по умолчанию
1. **`log_format`** - формат access логов
1. **`server`** - начало секции с virtual host.
1. **`listen`** - на каком IP адресе и порту слушает веб сервер.
1. **`server_name`** - каким доменам данный хост соответствует.

## Location
1. Ниже представлены приоритеты задания `location` в порядке убывания
    * **`location = /img/1.jpg`** - точное совпадение
    * **`location ^~ /pic/`** - префикс с приоритетом над регулярным выражением
    * **`location ~ \.jpg$`** - совпадение по регулярному выражению
    * **`location /img/`** - совпадение по префиксу
1. Если два `location` имеют одинаковый приоритет, то применяется тот который расположен **выше** в конфиге.
1. Внутри `location` путь можно указать несколькими способами
    * `root` - абсолютный url
        ```
        location ~* ^.+\.(jpg|jpeg|gif)$ {
            root /www/images
        }
        ```s

        * `/2015/10/img.png` -> `/www/images/2015/10/img.png`

    * `alias` - путь относительно префикса
        ```
        location /sitemap/ {
            alias /home/www/generated;
        }
        ```

        * `/sitemap/index.html` -> `/home/www/generated/index.html`

## Доступ к файлам
1. Атрибуты процесса
    * пользователь
    * группа
1. посмотреть список процессов с атрибутами
    ```bash
    $ ps -o pid,euser,egroup,comm,args -C nginx
    PID EUSER    EGROUP   COMMAND         COMMAND
        1 root     root     nginx           nginx: master process nginx -g daemon off;
        7 nginx    nginx    nginx           nginx: worker process
    ```
1. Атрибуты файла (или директории)
    * пользователь
    * группа
    * права доступа (read/write/execute)
1. Посмотреть права доступа к файлам
    ```bash
    $ ls -lah /home
    drwxr-xr-x  3 root root 4,0K авг.  30 07:45 .
    drwxr-xr-x 24 root root 4,0K авг.  29 08:38 ..
    drwxr-xr-x 53 max  max  4,0K авг.  30 09:59 max
    ```

    * `drwxr-xr-x` - права доступа
        * d**rwx**r-xr-x - права доступа для обладателя файла
        * drwx**r-x**r-x - права доступа для группы обладателя фалйа
        * drwxr-x**r-x** - права доступа для всех остальных
    * `max` (3 колонка) - обладатель файла
    * `max` (4 колонка) - группа обладателя файла
1. **Для того чтобы процесс мог открыть файл у него должны быть права на чтение файла и права на исполнение директорий (по всей иерархии) в которой лежит этот файл**

## Настройка проксирования в nginx
```
upstream backend {
    server back1.example.com:8080 weight=1 max_fails-3;
    server back2.example.com:8080 weight=2;
    server backup1.example.com:8080 backup;
}

proxy_set_header Host $proxy_host;
proxy_set_header X-Real-IP: $remote_addr;
location / {
    proxy_pass http://backend;
}
location /partner/ {
    proxy_pass http://www.partner.com
}
location ~ \.\w\w\w?\w?$ {
    root /www/static;
}
```
1. **`upstream`** - список серверов работающих под одним именем.
    * **`weight`** - вес сервера при распределении запросов (более мощным серверам ставят больший weight)
    * **`max_fails`** - максимальное количество фейлов перед тем как сервер будет отключен
1. **`proxy_pass`** - проксирует запрос на указанный upstream
1. **`proxy_set_header`** - добавление\изменение заголовков HTTP сообщения
    * можно установить заголовок `Host` для предоставления нужного заголовка хост для бекенда.
    * `X-Real-IP` - устанавливает заголовок IP для того чтобы знать с какого IP пришёл запрос (в противном случае всегда будем получать запросы с IP прокси сервера.)
