# Nginx

## Table of content
- [Установка](#Установка)
- [Запуск](#Запуск)
- [Файлы nginx](#Файлы-nginx)
- [Конфигурация](#Конфигурация)

## Установка

1. Install

    ```bash
    sudo apt-get install nginx
    ```

1. Check start nginx

    ```bash
    sudo systemctl start nginx
    ```

1. Check that it's running

    ```
    sudo systemctl status nginx
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
1. Терминология
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


