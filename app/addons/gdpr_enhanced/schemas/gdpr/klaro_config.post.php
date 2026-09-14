<?php
/***************************************************************************
 *   GDPR Enhanced — Расширение модуля GDPR для CS-Cart                    *
 *   Маркетинговые сервисы + исправление режима Explicit (opt-in)          *
 *                                                                          *
 *   Этот файл загружается ПОСЛЕ оригинального klaro_config.php            *
 *   и безопасно модифицирует конфигурацию, не трогая файлы ядра.          *
 ***************************************************************************/

defined('BOOTSTRAP') or die('Access denied');

// --- Исправление: принудительно выключаем все ползунки по умолчанию ---
// В стандартном CS-Cart в режиме Explicit (opt-in) ползунки всё равно были ON.
// Это нарушает GDPR: пользователь должен САМИ включить каждый сервис.
$schema['default'] = false;

// --- Маркетинговые и аналитические сервисы ---
// Эти сервисы подключены через сторонние модули (UniTheme, GTM и т.д.),
// поэтому стандартный GDPR-модуль CS-Cart о них не знает.
// Добавляем их вручную, чтобы они появились в баннере согласия.

// Google Analytics (GA4)
$schema['services']['google-analytics'] = [
    'purposes'     => ['performance'],
    'name'         => 'google-analytics',
    'translations' => [
        'zz' => [
            'title'       => 'Аналитика Google (GA4)',
            'description' => 'Google Analytics собирает анонимную статистику о посещаемости сайта: количество посетителей, популярные страницы, источники трафика. Данные используются для улучшения сайта.',
        ],
    ],
];

// Яндекс.Метрика
// ВАЖНО: используем тот же ключ "yandex_metrika" (с подчёркиванием), что и родной
// аддон rus_yandex_metrika (app/addons/rus_yandex_metrika/schemas/gdpr/klaro_config.post.php).
// Если писать через дефис ("yandex-metrika"), в баннере согласия появляются ДВА
// пункта про Яндекс.Метрику одновременно (наш + родной), т.к. Klaro считает их
// разными сервисами. Здесь мы просто переопределяем текст родного пункта, а не
// создаём новый — ключ должен совпадать 1-в-1.
$schema['services']['yandex_metrika'] = [
    'purposes'     => ['performance'],
    'name'         => 'yandex_metrika',
    'translations' => [
        'zz' => [
            'title'       => 'Яндекс.Метрика',
            'description' => 'Яндекс.Метрика собирает анонимную статистику посещаемости и поведения пользователей на сайте.',
        ],
    ],
];

// Google Реклама (Ads)
$schema['services']['google-ads'] = [
    'purposes'     => ['marketing'],
    'name'         => 'google-ads',
    'translations' => [
        'zz' => [
            'title'       => 'Google Реклама',
            'description' => 'Файлы cookie Google Ads используются для показа релевантной рекламы и отслеживания эффективности рекламных кампаний. Данные передаются в Google.',
        ],
    ],
];

// Meta Pixel (Facebook / Instagram)
$schema['services']['facebook-pixel'] = [
    'purposes'     => ['marketing'],
    'name'         => 'facebook-pixel',
    'translations' => [
        'zz' => [
            'title'       => 'Meta Pixel (Facebook)',
            'description' => 'Meta Pixel отслеживает действия посетителей на сайте для показа персонализированной рекламы в Facebook и Instagram. Данные передаются в Meta.',
        ],
    ],
];

return $schema;
