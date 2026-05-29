# StampScaner — мобильное приложение

Flutter-проект приложения **StampScaner** для платформ Android и iOS (Спринт 3a в рамках roadmap).
Сейчас рабочий каркас: дизайн-система, 5 главных экранов, локализация RU/EN/AR, локальная коллекция на SQLite.

## Структура

```
stampscaner_app/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│   ├── main.dart                 # entry point
│   ├── app.dart                  # MaterialApp + темы + локализация
│   ├── core/
│   │   ├── theme/                # AppColors, AppTheme (3 темы: Light / Sepia / Dark)
│   │   ├── i18n/                 # AppTranslations (RU/EN/AR + RTL)
│   │   ├── router/               # go_router с 5 ветками + модальные экраны
│   │   ├── models/               # IdentificationResult и др.
│   │   └── services/             # ApiService, StorageService, PreferencesController
│   ├── features/
│   │   ├── home/                 # bottom-nav shell + главный экран
│   │   ├── scanner/              # камера + image_picker
│   │   ├── identify/             # результат распознавания
│   │   ├── collection/           # коллекция пользователя
│   │   ├── postman/              # чат с ИИ-агентом
│   │   ├── certificate/          # заявка на сертификат
│   │   └── profile/              # профиль + настройки
│   └── shared/widgets/           # StampCard и др.
└── assets/
    ├── images/
    └── fonts/                    # шрифты добавятся при первой сборке
```

## Что готово

- **Дизайн-система** в едином стиле с сайтом stampscaner.com: бургунди + кремовый + матовое золото, Cormorant Garamond для заголовков, Inter для тела. Три темы переключаются в Профиле.
- **Локализация** на трёх языках (RU/EN/AR) с переключением на лету и автоматическим RTL для арабского.
- **Главный экран** с hero-блоком, быстрыми действиями (4 плитки), пустым состоянием для «недавно распознанных».
- **Сканер**: запрос разрешения на камеру, съёмка через `image_picker`, fallback на галерею, обработка ошибок.
- **Экран результата** с шкалой уверенности, карточкой данных (страна, год, серия, каталог, грейд APS, состояние, оценка), кнопками «Добавить в коллекцию», «Сертификат», «Поделиться».
- **Коллекция**: SQLite через `sqflite`, RefreshIndicator, swipe-to-delete, баннер общей оценки.
- **Postman-чат**: UI готов (пузыри сообщений, набор анимация, ввод), приветственное сообщение, заглушка ответа до запуска бэкенда (Спринт 2).
- **Заявка на сертификат**: выбор тарифа (Pre-cert / Premium), форма e-mail и заметок, состояние «отправлено».
- **Профиль**: гость-карточка, переключатель тем, переключатель языков, ссылки на Terms / Privacy / Реестр / контакт.

## Что НЕ работает в текущем состоянии

- **Бэкенд распознавания** не подключён. `ApiService.identifyStamp` фоллбэчит на демо-результат через 1.2 сек. Реальное распознавание поедет на Cloudflare Worker с Claude Vision (Спринт 3c).
- **Чат с Postman** — заглушечный, отвечает константой о Спринте 2.
- **Платёжки** в заявке на сертификат не подключены — заявка просто помечается отправленной (Sprint 4).
- **iOS-сборка с Windows невозможна** — нужен Mac или Codemagic.
- **Реальные шрифты** в `assets/fonts/` ещё не подложены — пока работает через `google_fonts` (загружает с CDN). Для офлайна нужно положить TTF.

## Установка инструментов сборки на aslankaa

### Flutter SDK
```bash
# Уже сделано: склонирован stable branch в C:\flutter
# Добавить в постоянный PATH в Windows: C:\flutter\bin
```

### JDK 17
```bash
# Уже сделано: распакован в C:\java\jdk-17.0.19+10
# JAVA_HOME=C:\java\jdk-17.0.19+10
```

### Android SDK (command-line tools)
```bash
# Уже скачано: C:\flutter-install\cmdtools.zip
# Распаковать в C:\Android\cmdline-tools\latest\
# ANDROID_HOME=C:\Android
# Затем:
#   sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
#   sdkmanager --licenses
```

### Проверка
```bash
flutter doctor -v
```

## Сборка APK для Аслана

```bash
cd stampscaner_app
flutter pub get
flutter build apk --release
# Результат: build/app/outputs/flutter-apk/app-release.apk
```

Затем `adb install` или передать APK на телефон через Telegram / e-mail.

## Что делать дальше

**Спринт 3a** (текущий): закончить установку Android SDK, собрать первый APK, дать Аслану поставить на телефон.

**Спринт 3b** (когда будет Mac или Codemagic): iOS-сборка.

**Спринт 3c**: Cloudflare Worker с Claude Vision API + промт Postman → реальное распознавание марок.

**Спринт 4**: маркетплейс + платёжки.

## Атрибуция

Подготовлено по поручению Аслана Каа · StampScaner · 2026-05-29.
