Користувався загалом цією статтею: 
https://www.redmine.org/projects/redmine/wiki/HowTo_Install_Redmine_50x_on_Ubuntu_2004_with_Apache2

Для запуску Redmine впевніться, що у вас встановлені git, Docker та Docker Compose.

1. Клонуємо репозиторій:
```bash
git clone https://github.com/anton-MS/redmine-docker.git
```
2. Редагуємо IP-адресу, з якою ви будете заходити в redmine.conf.

3. Запускаємо Docker Compose, вказавши 2 сервіси (ця команда виводить логи білду):
```bash
docker-compose -f redmine-compose.yaml up 
```
Якщо хочете запустити в режимі фону (detached):
```bash
docker-compose -f redmine-compose.yaml up -d
```
4. Тепер залишилася одна проблема: коли мій контейнер з Redmine забілдився, він одразу хоче стучатись до MySQL, який тільки запускається. Тому треба ввести команду RAILS_ENV=production bundle exec rake db:migrate, коли БД вже працює. depends_on не допомогло, healthchecks також.

Тому поки так:
```bash
docker exec -it (ID контейнера my-redmine) bash
RAILS_ENV=production bundle exec rake db:migrate
```
5. Тепер можете бачити redmine на локалхості:
```bash
http://localhost/
```
user: admin
pass: admin
