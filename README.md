# pg_indexes

1. Для запуска бд скачать docker desktop
2. Из корня прокта выпольнить команду
    ```
    docker-compose up --build
    ```
    В результате поднимиться образ postgresql

    теперь мы можем подключится к инстансу к примеру через DBeaver
    ```
    host: 127.0.0.1
    port: 5432
    db: index_test
    login: postgres
    password: postgres
    ```
3. В каталоге scripts расприсаны примеры из презентации