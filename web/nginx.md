# Nginx

## Table of content
- [Установка](#установка)
- [Запуск](#запуск)
- [Файлы nginx](#Файлы-nginx)
- [Directives and contexts](#directives-and-contexts)
- [Конфигурация](#Конфигурация)
- [Location](#location)
- [Доступ к файлам](#Доступ-к-файлам)
- [Настройка проксирования в nginx](#настройка-проксирования-в-nginx)
- [Load Balancing](#load-balancing)
- [Best Features](#best-features)
- [Configure HTTPS](#configure-htts)

## Установка

1. Install from package repository

    ```bash
    sudo apt-get install nginx
    ```

1. [Compiling and Installing From the Sources](https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/)

    1. install depencencies
        ```bash
        sudo apt-get update -y && \
        sudo apt-get install -y build-essential \
            libpcre3 \
            libpcre3-dev \
            libpcrecpp0v5 \
            libssl-dev \
            zlib1g-dev
        ```

    * configure example
        ```bash
        ./configure --sbin-path=/usr/bin/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --pid-path=/var/run/nginx.pid \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --with-debug \
            --with-pcre \
            --with-http_ssl_module
        ```

## Запуск
1. Команда запуска
    * Если установлен через `apt-get`, то тогда автоматически настраивается linux `service` и создаётся `init` вскрипт. В таком случае можно запускать:
        ```bash
        sudo /etc/init.d/nginx start
        ```

    * Если `init` скрипт не создан, то можно запустить
        ```bash
        sudo nginx
        ```

    * `sudo` т.к. сервер должен прослушивать порт < 1000

1. Чтение файла конфигурации
1. Получение порта 80|443
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
    * все относительные пути в конфиге nginx являются относительно директории указанной как `--prefix` во время установки

1. **`/var/run/nginx.pid`** - id процесса nginx
1. **`/var/log/nginx/error.log`** - лог ошибок
1. **`/var/log/nginx/access.log`** - лог доступа

## Directives and contexts
1. _Context_ - аналог `scope`, т.е. то к чему применяются конфиги
1. _Directive_ - инструкция внутри контекста
1. Типы _directive_:
    * _standart_ - стандартная директива, устанавливает свойство, переопределяется внутри вложенных контекстов
        ```nginx
        gzip on;
        ```
    * _array_ - устанавливает одно из свойств массива. При переопределении внутри вложенных контекстов перезаписывается всё значение массива, а не отдельные элементы.
        ```nginx
        # outer scope
        access_log /var/logs/nginx/access.log main;
        access_log /var/logs/nginx/notice.log notice;

        # inner scope will override all array
        access_log /var/logs/nginx/inner.log debug;
        ```
    * _action_ - performs some action when hit. Does not inherited by child contexts.
        ```nginx
        return 200;
        ```
    * _try_files_ - директива описывающая сервинг файлов. Определяет порядок поиска
        ```nginx
        try_files $uri /some/reserve/dir =404;
        ```
1. **virtual host** - секция конфига отвечающая за обработку определённого домена (один веб сервер может обрабатывать несколько доментов).
1. **location** - секция конфига, отвечающая за обслуживание определенной группы URL

## Конфигурация
```nginx
# user and group for workers
user www-data www-data;

# the amount of workers (by default 1, auto sets it to the number of CPUs)
worker_processes auto;

# error log location and level
error_log /var/log/nginx.error_log info;

events {
    # the maximum connections per worker
    worker_connections 1024;

    # accept multiple connections simultaneously or only one connection at a time (the default is on)
    multi_accept on;
}

# the begining of http server config
http {
    # include file with mime types
    include /etc/nginx/mime.types;

    # defaut mime type
    default_type    application/octet-stream;

    # the log format
    log_format      simple '$remote_addr $request $status';

    # client timeouts
    client_body_timeout 12;
    client_header_timeout 12;

    # Use a higher keepalive timeout to reduce the need for repeated handshakes
    keepalive_timeout 300;

    # server timeout
    send_timeout 10;

    # virtual server config
    server {
        # nginx port
        listen 80;

        # root directory for site
        root /www/site;

        location / {
            root /www/site/index.html;

            # adds some header to response
            add_header "Cache-Control" "no-transform";
        }
    }
}
```

1. **`ulimit -n`** - gets linux core the restiction of maximum number of connections per CPU. It's best practise to use it number as `worker_connections` value.

## Location
1. Ниже представлены приоритеты задания `location` в порядке убывания
    * **`location = /img/1.jpg`** - точное совпадение
    * **`location ^~ /pic/`** - префикс с приоритетом над регулярным выражением
    * **`location ~ \.jpg$`**, **`location ~* \.jpg$`** - casesensetive caseinsensetive совпадение по регулярному выражению
    * **`location /img/`** - совпадение по префиксу
1. Если два `location` имеют одинаковый приоритет, то применяется тот который расположен **выше** в конфиге.
1. Внутри `location` путь можно указать несколькими способами
    * `root` - абсолютный url
        ```nginx
        location ~* ^.+\.(jpg|jpeg|gif)$ {
            root /www/images
        }
        ```

        * `/2015/10/img.png` -> `/www/images/2015/10/img.png`

    * `alias` - путь относительно префикса
        ```nginx
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

[Reverse Proxy Guide](https://www.nginx.com/resources/admin-guide/reverse-proxy/)

```nginx
location /node {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://127.0.0.1:3000;
}
```

* **`proxy_pass`** - проксирует запрос на указанный upstream
* **`proxy_set_header`** - добавление\изменение заголовков HTTP сообщения
    * можно установить заголовок `Host` для предоставления нужного заголовка хост для бекенда.
    * `X-Real-IP` - устанавливает заголовок IP для того чтобы знать с какого IP пришёл запрос (в противном случае всегда будем получать запросы с IP прокси сервера.)


## Load balancing
```nginx
upstream backend {
    least_conn;
    server back1.example.com:8080 weight=1 max_fails-3;
    server back2.example.com:8080 weight=2;
    server backup1.example.com:8080 backup;
}

location / {
    proxy_pass http://backend;
}
```

* **`upstream`** - список серверов работающих под одним именем.
* **`ip_hash`** - если клиент был соединён с определённым сервером - продолжает его всегда туда направлять.
* **`least_conn`** - направляет к тому серверу с которым установленно наименьшее количество соединений.
* **`weight`** - вес сервера при распределении запросов (более мощным серверам ставят больший weight)
* **`max_fails`** - максимальное количество фейлов перед тем как сервер будет отключен

## Best Features
1. Setting expires header
    ```nginx
    location ~* \.(css|js|jpg|png|gif)$ {
        expires 1M;
        add_header Pragma public;
        add_header Cache-Control public; # tell that every proxy could cache it
        add_header Vary Accept-Encoding; # intermideate proxy should split resource cache by Accept-Encoding
    }
    ```

1. Configure gzip compression
    ```nginx
    gzip  on;
    gzip_min_length 100;
    gzip_comp_level 3;
    gzip_types text/plain;
    gzip_types text/css;
    gzip_types application/javascript;

    gzip_disable "msie6"; # disable gzip for user agent Internet Exporer 6
    ```

## Configure HTTPS
1. [Generate self-signed certificate](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04)
    ```
    sudo mkdir /etc/nginx/ssl
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
    ```
1. Add to nginx config
    ```nginx
    listen 443 ssl;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    ```

## Security
1. During installation remove unused modules
    ```bash
    ./configure --help | grep without
    ```

    * remove `http_autoindex_module`

1. Remove server version header
    ```nginx
    server_tokents off;
    ```

1. Block specific user agents
    ```nginx
    if ($http_user_agent ~* some_bot_pattern) {
        return 403;
    }
    ```

