Код производит некоторые действия, требуемые для автоматической сборки
из Jenkins:

1. генерит версию пакета на основе коммита
2. создаёт Changelog из шаблона
3. копирует SSH ключ для доступа во вторичные закрытые репозитории
4. запускает pdebuild для сборки deb пакетов
5. публикует deb пакеты в репозиторий

Основная идея — всё, что делается здесь, можно пропустить и запустить сборку
deb пакета вручную (например у себя локально) с помощью dpkg-buildpackage
