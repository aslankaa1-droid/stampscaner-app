import 'package:flutter/material.dart';

/// Lightweight translations for StampScaner.
/// Uses a flat key map per locale, loaded synchronously.
/// Languages: RU (default), EN, AR (RTL).
class AppTranslations {
  AppTranslations(this.locale);
  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
    Locale('ar'),
  ];

  static AppTranslations of(BuildContext context) =>
      Localizations.of<AppTranslations>(context, AppTranslations)!;

  String t(String key) {
    return _maps[locale.languageCode]?[key] ?? _maps['ru']![key] ?? key;
  }

  /// Returns true when the active locale renders right-to-left.
  bool get isRtl => locale.languageCode == 'ar';

  static const Map<String, Map<String, String>> _maps = {
    'ru': {
      'app.title': 'StampScaner',
      'app.tagline': 'Премиальная экспертиза почтовых марок',

      'nav.home': 'Главная',
      'nav.scanner': 'Сканер',
      'nav.collection': 'Коллекция',
      'nav.postman': 'Postman',
      'nav.profile': 'Профиль',

      'home.welcome': 'Добро пожаловать',
      'home.hero.title': 'Сфотографируйте марку.',
      'home.hero.subtitle': 'Получите страну, год, серию и оценку за секунды.',
      'home.cta.scan': 'Открыть сканер',
      'home.cta.collection': 'Моя коллекция',
      'home.section.quick': 'Быстрые действия',
      'home.section.recent': 'Недавно распознанные',
      'home.empty.recent': 'Здесь будут марки, которые вы распознали.',

      'scanner.title': 'Распознать марку',
      'scanner.hint': 'Наведите камеру на марку и нажмите кнопку.',
      'scanner.capture': 'Сделать снимок',
      'scanner.permission.title': 'Доступ к камере',
      'scanner.permission.body': 'Для распознавания марки нужен доступ к камере. Это бесплатно и без рекламы.',
      'scanner.permission.grant': 'Разрешить доступ',
      'scanner.processing': 'Postman анализирует марку…',
      'scanner.fallback.title': 'Камера недоступна',
      'scanner.fallback.body': 'Можно загрузить фото из галереи.',
      'scanner.fallback.pick': 'Выбрать из галереи',

      'identify.title': 'Результат распознавания',
      'identify.confidence': 'Уверенность',
      'identify.country': 'Страна',
      'identify.year': 'Год',
      'identify.series': 'Серия',
      'identify.catalog': 'Каталог',
      'identify.grade': 'Грейд APS',
      'identify.estimate': 'Оценка',
      'identify.condition': 'Состояние',
      'identify.actions.collection': 'Добавить в коллекцию',
      'identify.actions.certificate': 'Заказать сертификат',
      'identify.actions.share': 'Поделиться',
      'identify.disclaimer': 'Бесплатная идентификация даётся справочно. Для документа на сделку или страховку — оформите сертификат.',

      'collection.title': 'Моя коллекция',
      'collection.empty.title': 'Коллекция пуста',
      'collection.empty.body': 'Распознайте первую марку — она появится здесь.',
      'collection.empty.cta': 'Открыть сканер',
      'collection.total.value': 'Общая оценка',
      'collection.items': 'предметов',

      'postman.title': 'Postman',
      'postman.subtitle': 'Эксперт-филателист мирового уровня',
      'postman.welcome': 'Здравствуйте. Я Postman — эксперт по почтовым маркам уровня RDP / AIEP. Помогу с идентификацией, оценкой и подбором сертификата.',
      'postman.input.hint': 'Опишите марку или прикрепите фото…',
      'postman.send': 'Отправить',
      'postman.offline': 'Бэкенд Postman в разработке (Спринт 2). На главной странице сайта чат тоже временно в макете.',

      'cert.title': 'Заявка на сертификат',
      'cert.intro': 'Сертификат за подписью Аслана Каа. Premium — со страховым покрытием \$1000 при условии очной экспертизы и личной передачи.',
      'cert.tier.precert.title': 'Pre-cert',
      'cert.tier.precert.price': '\$19',
      'cert.tier.precert.body': 'Анализ Postman, PDF за 24 часа, без страхового покрытия.',
      'cert.tier.premium.title': 'Premium',
      'cert.tier.premium.price': '\$199',
      'cert.tier.premium.body': 'Очная экспертиза, страховое покрытие \$1000, печатная версия по запросу.',
      'cert.cta.precert': 'Заказать Pre-cert',
      'cert.cta.premium': 'Заявка на Premium',
      'cert.notice': 'Оплата откроется после интеграции платёжного шлюза. Сейчас заявка фиксируется на e-mail основателя.',

      'profile.title': 'Профиль',
      'profile.guest': 'Гость',
      'profile.signIn': 'Войти или зарегистрироваться',
      'profile.settings': 'Настройки',
      'profile.theme': 'Оформление',
      'profile.theme.light': 'Светлая',
      'profile.theme.sepia': 'Сепия',
      'profile.theme.dark': 'Тёмная',
      'profile.language': 'Язык',
      'profile.about': 'О приложении',
      'profile.legal.terms': 'Пользовательское соглашение',
      'profile.legal.privacy': 'Политика конфиденциальности',
      'profile.legal.registry': 'Реестр сертификатов',
      'profile.contact': 'Связаться с основателем',
      'profile.version': 'Версия',

      'common.cancel': 'Отмена',
      'common.continue': 'Продолжить',
      'common.ok': 'Хорошо',
      'common.retry': 'Повторить',
      'common.close': 'Закрыть',
      'common.coming.soon': 'Скоро',
    },

    'en': {
      'app.title': 'StampScaner',
      'app.tagline': 'Premium philatelic expertise',

      'nav.home': 'Home',
      'nav.scanner': 'Scanner',
      'nav.collection': 'Collection',
      'nav.postman': 'Postman',
      'nav.profile': 'Profile',

      'home.welcome': 'Welcome',
      'home.hero.title': 'Photograph the stamp.',
      'home.hero.subtitle': 'Country, year, series and a value range in seconds.',
      'home.cta.scan': 'Open scanner',
      'home.cta.collection': 'My collection',
      'home.section.quick': 'Quick actions',
      'home.section.recent': 'Recently identified',
      'home.empty.recent': 'Stamps you identify will appear here.',

      'scanner.title': 'Identify a stamp',
      'scanner.hint': 'Point your camera at the stamp and tap the button.',
      'scanner.capture': 'Capture',
      'scanner.permission.title': 'Camera access',
      'scanner.permission.body': 'Identifying a stamp needs access to the camera. Free, no ads.',
      'scanner.permission.grant': 'Grant access',
      'scanner.processing': 'Postman is analysing the stamp…',
      'scanner.fallback.title': 'Camera unavailable',
      'scanner.fallback.body': 'You can pick a photo from the gallery.',
      'scanner.fallback.pick': 'Pick from gallery',

      'identify.title': 'Identification result',
      'identify.confidence': 'Confidence',
      'identify.country': 'Country',
      'identify.year': 'Year',
      'identify.series': 'Series',
      'identify.catalog': 'Catalogue',
      'identify.grade': 'APS grade',
      'identify.estimate': 'Estimate',
      'identify.condition': 'Condition',
      'identify.actions.collection': 'Add to collection',
      'identify.actions.certificate': 'Request a certificate',
      'identify.actions.share': 'Share',
      'identify.disclaimer': 'Free identification is informational. For a document used in a deal or insurance, order a certificate.',

      'collection.title': 'My collection',
      'collection.empty.title': 'Your collection is empty',
      'collection.empty.body': 'Identify your first stamp — it will appear here.',
      'collection.empty.cta': 'Open scanner',
      'collection.total.value': 'Total estimate',
      'collection.items': 'items',

      'postman.title': 'Postman',
      'postman.subtitle': 'World-class philatelic expert',
      'postman.welcome': 'Hello. I am Postman, a philatelic expert trained at RDP / AIEP level. I help with identification, valuation and certification.',
      'postman.input.hint': 'Describe the stamp or attach a photo…',
      'postman.send': 'Send',
      'postman.offline': 'Postman backend is in development (Sprint 2). The website chat is a placeholder too.',

      'cert.title': 'Request a certificate',
      'cert.intro': 'Certificate signed by Aslan Kaa. Premium includes a \$1000 insurance cover when issued after in-person expertise and personal handover.',
      'cert.tier.precert.title': 'Pre-cert',
      'cert.tier.precert.price': '\$19',
      'cert.tier.precert.body': 'Postman analysis, PDF within 24h, no insurance cover.',
      'cert.tier.premium.title': 'Premium',
      'cert.tier.premium.price': '\$199',
      'cert.tier.premium.body': 'In-person expertise, \$1000 insurance cover, printed version on request.',
      'cert.cta.precert': 'Order Pre-cert',
      'cert.cta.premium': 'Request Premium',
      'cert.notice': 'Payment will go live after the gateway is wired up. For now the request is e-mailed to the founder.',

      'profile.title': 'Profile',
      'profile.guest': 'Guest',
      'profile.signIn': 'Sign in or register',
      'profile.settings': 'Settings',
      'profile.theme': 'Appearance',
      'profile.theme.light': 'Light',
      'profile.theme.sepia': 'Sepia',
      'profile.theme.dark': 'Dark',
      'profile.language': 'Language',
      'profile.about': 'About',
      'profile.legal.terms': 'Terms of Service',
      'profile.legal.privacy': 'Privacy Policy',
      'profile.legal.registry': 'Certificate registry',
      'profile.contact': 'Contact the founder',
      'profile.version': 'Version',

      'common.cancel': 'Cancel',
      'common.continue': 'Continue',
      'common.ok': 'OK',
      'common.retry': 'Retry',
      'common.close': 'Close',
      'common.coming.soon': 'Coming soon',
    },

    'ar': {
      'app.title': 'StampScaner',
      'app.tagline': 'خبرة عالمية متميزة في الطوابع',

      'nav.home': 'الرئيسية',
      'nav.scanner': 'الماسح',
      'nav.collection': 'المجموعة',
      'nav.postman': 'Postman',
      'nav.profile': 'الملف',

      'home.welcome': 'أهلاً بك',
      'home.hero.title': 'صور الطابع.',
      'home.hero.subtitle': 'الدولة والسنة والمجموعة ونطاق التقييم خلال ثوانٍ.',
      'home.cta.scan': 'فتح الماسح',
      'home.cta.collection': 'مجموعتي',
      'home.section.quick': 'إجراءات سريعة',
      'home.section.recent': 'تم التعرف عليها مؤخراً',
      'home.empty.recent': 'ستظهر هنا الطوابع التي تتعرف عليها.',

      'scanner.title': 'التعرف على طابع',
      'scanner.hint': 'وجه الكاميرا نحو الطابع واضغط الزر.',
      'scanner.capture': 'التقاط',
      'scanner.permission.title': 'الوصول إلى الكاميرا',
      'scanner.permission.body': 'يحتاج التعرف على الطابع إلى الكاميرا. مجاناً وبدون إعلانات.',
      'scanner.permission.grant': 'منح الإذن',
      'scanner.processing': 'Postman يحلل الطابع…',
      'scanner.fallback.title': 'الكاميرا غير متاحة',
      'scanner.fallback.body': 'يمكنك اختيار صورة من المعرض.',
      'scanner.fallback.pick': 'اختر من المعرض',

      'identify.title': 'نتيجة التعرف',
      'identify.confidence': 'الثقة',
      'identify.country': 'الدولة',
      'identify.year': 'السنة',
      'identify.series': 'المجموعة',
      'identify.catalog': 'الكتالوج',
      'identify.grade': 'تقييم APS',
      'identify.estimate': 'التقدير',
      'identify.condition': 'الحالة',
      'identify.actions.collection': 'إضافة للمجموعة',
      'identify.actions.certificate': 'طلب شهادة',
      'identify.actions.share': 'مشاركة',
      'identify.disclaimer': 'التعرف المجاني للإرشاد فقط. للوثائق في الصفقات أو التأمين — اطلب شهادة.',

      'collection.title': 'مجموعتي',
      'collection.empty.title': 'المجموعة فارغة',
      'collection.empty.body': 'تعرف على طابعك الأول — وسيظهر هنا.',
      'collection.empty.cta': 'فتح الماسح',
      'collection.total.value': 'التقدير الإجمالي',
      'collection.items': 'قطعة',

      'postman.title': 'Postman',
      'postman.subtitle': 'خبير فلاتيلي عالمي',
      'postman.welcome': 'مرحباً. أنا Postman، خبير الطوابع البريدية بمستوى RDP / AIEP. أساعد في التعرف والتقييم وإصدار الشهادات.',
      'postman.input.hint': 'صف الطابع أو أرفق صورة…',
      'postman.send': 'إرسال',
      'postman.offline': 'الواجهة الخلفية لـ Postman قيد التطوير (Sprint 2). الدردشة في الموقع أيضاً بنفس المرحلة.',

      'cert.title': 'طلب شهادة',
      'cert.intro': 'شهادة بتوقيع أصلان كاع. النسخة Premium تتضمن تغطية تأمينية بقيمة 1000 دولار بعد الفحص الشخصي والتسليم اليدوي.',
      'cert.tier.precert.title': 'Pre-cert',
      'cert.tier.precert.price': '\$19',
      'cert.tier.precert.body': 'تحليل Postman، ملف PDF خلال 24 ساعة، بدون تغطية تأمينية.',
      'cert.tier.premium.title': 'Premium',
      'cert.tier.premium.price': '\$199',
      'cert.tier.premium.body': 'فحص شخصي، تغطية تأمينية 1000 دولار، نسخة مطبوعة حسب الطلب.',
      'cert.cta.precert': 'اطلب Pre-cert',
      'cert.cta.premium': 'اطلب Premium',
      'cert.notice': 'سيتم تفعيل الدفع بعد ربط البوابة. الطلب الآن يصل بالبريد الإلكتروني إلى المؤسس.',

      'profile.title': 'الملف الشخصي',
      'profile.guest': 'زائر',
      'profile.signIn': 'تسجيل الدخول أو إنشاء حساب',
      'profile.settings': 'الإعدادات',
      'profile.theme': 'المظهر',
      'profile.theme.light': 'فاتح',
      'profile.theme.sepia': 'سيبيا',
      'profile.theme.dark': 'داكن',
      'profile.language': 'اللغة',
      'profile.about': 'حول التطبيق',
      'profile.legal.terms': 'شروط الخدمة',
      'profile.legal.privacy': 'سياسة الخصوصية',
      'profile.legal.registry': 'سجل الشهادات',
      'profile.contact': 'التواصل مع المؤسس',
      'profile.version': 'الإصدار',

      'common.cancel': 'إلغاء',
      'common.continue': 'متابعة',
      'common.ok': 'حسناً',
      'common.retry': 'إعادة',
      'common.close': 'إغلاق',
      'common.coming.soon': 'قريباً',
    },
  };
}

class AppTranslationsDelegate
    extends LocalizationsDelegate<AppTranslations> {
  const AppTranslationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppTranslations.supportedLocales
          .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppTranslations> load(Locale locale) async => AppTranslations(locale);

  @override
  bool shouldReload(AppTranslationsDelegate old) => false;
}

extension TranslateX on BuildContext {
  /// Short helper: context.tr('key')
  String tr(String key) => AppTranslations.of(this).t(key);
  bool get isRtl => AppTranslations.of(this).isRtl;
}
