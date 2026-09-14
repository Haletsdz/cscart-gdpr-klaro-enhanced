{*
  gdpr_enhanced: переопределение hooks/index/body.pre.tpl аддона ab__product_fe05_facebook_ads.

  ПРИЧИНА: в оригинальном файле пиксель Facebook инициализируется безусловно —
  <script data-no-defer"> без какой-либо проверки согласия: fbq('init', ...) и
  fbq('track', 'PageView') выполняются сразу при загрузке страницы, независимо от
  выбора пользователя в баннере Klaro. Тумблер "Meta Pixel (Facebook)" в баннере
  (см. klaro_config.post.php модуля gdpr_enhanced, ключ "facebook-pixel") при этом
  был чисто декоративным.

  ФИКС: тот же код, но с <script type="text/plain" data-name="facebook-pixel">
  вместо обычного <script>. Klaro выполнит этот блок только когда пользователь дал
  согласие на сервис "facebook-pixel" — сразу при загрузке, если согласие уже
  сохранено с прошлого визита, либо в момент принятия в баннере (без перезагрузки
  страницы).

  ВАЖНО (осознанное решение, не техническая ошибка): <noscript><img ...
  facebook.com/tr?...></noscript> — резервный пиксель для браузеров с отключённым
  JS — из фикса УБРАН. Его нельзя обусловить согласием (Klaro сам работает на JS,
  а noscript-контент рендерится только когда JS выключен), поэтому единственный
  способ не отправлять данные в Meta без явного согласия — не использовать этот
  запасной вариант вообще. Если для вас важнее не терять учёт трафика с
  отключённым JS больше, чем эта строгость — можно вернуть блок обратно, это
  компромисс, а не баг.
*}
{if $addons.ab__product_fe05_facebook_ads.fb_pixel_id}
    <!-- Facebook Pixel Code -->
    <script type="text/plain" data-type="application/javascript" data-name="facebook-pixel">
        {literal}
        !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
                n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
                n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
                t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
            document,'script','https://connect.facebook.net/en_US/fbevents.js');
        {/literal}
        fbq('init', '{$addons.ab__product_fe05_facebook_ads.fb_pixel_id}');
        fbq('track', 'PageView');

    {if $ab__pfe05_pixel}
        {foreach $ab__pfe05_pixel as $item}
        fbq('track', '{$item.event|escape:"javascript"}', {$item.data|json_encode nofilter});
        {/foreach}
    {/if}
    </script>
    <!-- End Facebook Pixel Code -->
{/if}
