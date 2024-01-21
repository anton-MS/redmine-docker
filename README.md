Користувався загалом цією статтью:
https://www.redmine.org/projects/redmine/wiki/HowTo_Install_Redmine_50x_on_Ubuntu_2004_with_Apache2

Для запуску Redmine впевнитись що у вас встановелний git, docker та docker-compose

1. Клонуємо репозиторій:
```bash
git clone https://github.com/anton-MS/redmine-docker.git
```
2. Редагуємо IP адресу з якою будете заходити в redmine.conf

3. Запускаємо docker-compose в якому зазначенні 2 сервіси (саме ця команда виводить логи білду):
```bash
docker-compose -f redmine-compose.yaml up 
```
Якщо хочете запустити в бекграунді (detached):
```bash
docker-compose -f redmine-compose.yaml up -d
```
4. Тепер залишилась одна проблема, коли мій контейнер з redmine забілдився, він одразу хоче стучатись до mysql, котрий тільки запускается, тому треба внести самостійно команду RAILS_ENV=production bundle exec rake db:migrate коли БД вже працює. depends_on не допомогло, healthchecks також.

Тому поки так:
```bash
docker exec -it (ID контейнера) bash
RAILS_ENV=production bundle exec rake db:migrate
```
5. Тепер можете бачити redmine на локалхості:
```bash
http://localhost/
```
user: admin
pass: admin
