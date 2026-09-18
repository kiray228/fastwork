# Как собрать и запустить сервер — инструкция для хостинга.
#
# Хостинг не знает, что такое Dart. Этот файл объясняет ему по шагам:
# возьми такой-то образ, положи туда код, собери, запусти вот это.
# Формат общепринятый, его понимают почти все хостинги.

# --- Шаг 1: сборка -----------------------------------------------------------
# Берём готовый образ с установленным Dart — и ТОЛЬКО с Dart.
# Flutter здесь нет и не нужен: сервер зависит от пакета fastwork_core,
# а тот про Flutter ничего не знает. Ради этого мы и разделили пакеты.
FROM dart:stable AS build

WORKDIR /app

# Сначала копируем только описания зависимостей и скачиваем их отдельным
# шагом. Тогда при правке кода зависимости не будут качаться заново:
# хостинг запомнит этот слой и пропустит его.
COPY packages/core/pubspec.yaml packages/core/
COPY packages/server/pubspec.yaml packages/server/
RUN cd packages/server && dart pub get

# Теперь сам код.
COPY packages/core packages/core
COPY packages/server packages/server
RUN cd packages/server && dart pub get --offline

# Собираем. Не `dart compile exe`, а `dart build cli`: пакет sqlite3
# приносит с собой готовую библиотеку, и её надо положить рядом —
# это умеет только `dart build`.
RUN cd packages/server && dart build cli

# --- Шаг 2: запуск -----------------------------------------------------------
# Собранное переносим в лёгкий образ: ни Dart, ни исходников там нет,
# только сервер и библиотека sqlite. Образ меньше, и ломать в нём нечего.
FROM debian:stable-slim

# Корневые сертификаты.
#
# Без них не работает ни одно соединение по https: программа не может
# проверить, что сервер на том конце — правда тот, за кого себя выдаёт,
# и обрывает связь с ошибкой CERTIFICATE_VERIFY_FAILED.
#
# В обычной системе они есть всегда, и об этом не думаешь. А минимальный
# образ на то и минимальный — в нём нет ничего лишнего, и сертификаты
# тоже считаются лишними, пока их не попросишь.
#
# Именно на этом падала отправка писем через Brevo.
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Папка для базы. Если хостинг даёт постоянный диск — подключай его
# именно сюда, иначе данные пропадут при перезапуске.
RUN mkdir -p /app/data

COPY --from=build /app/packages/server/build/cli/linux_x64/bundle /app

ENV DB_PATH=/app/data/fastwork.sqlite
ENV PORT=8080

EXPOSE 8080
CMD ["/app/bin/server"]
