# Web Servers

## Table of content
- [Виды вебсерверов](#Виды-вебсерверов)
- [Процессы web сервера](#Процессы-web-сервера)
- [Модульная архитектура](#Модульная-архитектура)
- [Модели обработки сетевых соединений](#Модели-обработки-сетевых-соединений)

## Виды вебсерверов
1. Apache
1. Nginx
1. IIS7
1. LightTPD

## Процессы web сервера
1. Master (user: root, 1 процесс)
    * чтение и валидация конфига
    * открытие сокета (ов) и логов
    * запуск и управление дочерними процессами (worker)
    * Graceful restart, binary updates
1. Worker (user: www-data or no-body, 1+ процессов)
    * обработка сетевых запросов

## Цикл обработки запроса
![Цикл обработки запроса](../images/web-server-circle.png)

1. Чтение HTTP запроса из соединения (соединение предоставляет master процесс)
1. Выбор virtual host (на основе заголовка `Host`)
1. Выбор location и определение пути к файлу который нужно отдать.
1. Проверка доступа к отдаваемому файлу
1. Чтение файла с диска
1. Применяем выходные фильтры (сжатие gzip, разбитие на части в случае большого документа)
1. Отправка HTTP ответа
1. Запись Access Log
1. Очистка выделенной для обработки запроса памяти.

## Модульная архитектура
1. У большинства популярных веб-серверов существует модульная архитектура. Т.е. есть ядро и опционально подключаемые модули.
1. Задачи ядра:
    * открытие\закрытие соединений
    * обработка http запросов по циклу описанному выше
1. Модули можно подключать динамически. Модуль добавляет некоторые опции в конфиг веб сервера и добавляет некоторые middleware на каком-либо этапе обработки запроса.

## Модели обработки сетевых соединений.
1. Простейший TCP сервер для отдачи файлов в блокирующем режиме
    ```python
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('127.0.0.1', 8080))
    s.listen(10)
    while True:
        conn, addr = s.accept()
        path = conn.recv(512).decode('utf8').rstrip("\r\n")
        file = open('/www' + str(path), 'r')
        data = file.read().encode('utf8')
        conn.sendall(data)
        file.close()
        conn.close()
    ```

    * проблема вышеописанного сервера в том, что он не способен обрабатывать больше одного соединения одновременно.

    * Проблема особенна актуальна в случае медленной обработки запроса (медленный клиент, или медленная бизнес логика)
1. Блокирующий ввод-вывод
    ![Блокирующий ввод-вывод](../images/blocking-io.png)
1. Решение проблемы блокирующего ввода-вывода:
    * множество потоков - multithreading
        * :heavy_plus_sign:
    * множество процессов - prefork, pool of workers
    * комбинированный подход