{*
  gdpr_enhanced: переопределение hooks/index/scripts.post.tpl родного аддона rus_yandex_metrika.

  ПРИЧИНА: в оригинальном файле (app/addons/rus_yandex_metrika + var/themes_repository/.../rus_yandex_metrika/hooks/index/scripts.post.tpl)
  инициализация счётчика запускается безусловно по событию ce.commoninit — тумблер
  "Яндекс.Метрика" в баннере Klaro при этом существует только как текст (см. klaro_config.post.php
  этого же аддона), но НИКАК не блокирует реальную загрузку счётчика: пользователь может
  отклонить согласие, а mc.yandex.ru/metrika/tag.js всё равно загрузится и запустит трекинг.

  ФИКС: тот же код, но обёрнутый в <script type="text/plain" data-name="yandex_metrika">.
  Klaro сам активирует (заменит на исполняемый) такой блок только когда пользователь
  дал согласие на сервис "yandex_metrika" — сразу при загрузке страницы, если согласие
  уже сохранено с прошлого визита, либо в момент принятия в баннере. Ключ "yandex_metrika"
  должен совпадать с ключом сервиса в klaro_config.post.php (rus_yandex_metrika и наш
  gdpr_enhanced используют один и тот же ключ, чтобы не плодить два пункта в баннере).

  Остальная часть файла (провайдеры, index.js, datalayer, языковые переменные)
  оставлена как в оригинале без изменений.
*}
{$yandex_metrika_settings = [
    "id" => $addons.rus_yandex_metrika.counter_number|default:'',
    "collectedGoals" => array_filter($addons.rus_yandex_metrika.collect_stats_for_goals|default:[])
]}
{if $addons.rus_yandex_metrika.clickmap === "YesNo::YES"|enum}
    {$yandex_metrika_settings["clickmap"] = true}
{/if}
{if $addons.rus_yandex_metrika.external_links === "YesNo::YES"|enum}
    {$yandex_metrika_settings["trackLinks"] = true}
{/if}
{if $addons.rus_yandex_metrika.denial === "YesNo::YES"|enum}
    {$yandex_metrika_settings["accurateTrackBounce"] = true}
{/if}
{if $addons.rus_yandex_metrika.track_hash === "YesNo::YES"|enum}
    {$yandex_metrika_settings["trackHash"] = true}
{/if}
{if $addons.rus_yandex_metrika.visor === "YesNo::YES"|enum}
    {$yandex_metrika_settings["webvisor"] = true}
{/if}
{if $addons.rus_yandex_metrika.ecommerce === "YesNo::YES"|enum}
    {$yandex_metrika_settings["ecommerce"] = "dataLayerYM"}
{/if}
{$yandex_metrika_object = [
    "goalsSchema" => $yandex_metrika_goals_scheme|default:[],
    "settings" => $yandex_metrika_settings,
    "currentController" => $runtime.controller,
    "currentMode" => $runtime.mode
]}
<script type="text/plain" data-type="application/javascript" data-name="yandex_metrika">
    (function (_, $, window) {
        window.dataLayerYM = window.dataLayerYM || [];
        $.ceEvent('one', 'ce.commoninit', function() {
            _.yandexMetrika = {$yandex_metrika_object|json_encode nofilter};
            $.ceEvent('trigger', 'ce:yandexMetrika:init');
        });
    })(Tygh, Tygh.$, window);
</script>


{if $addons.rus_yandex_metrika.is_obsolete_code_snippet_used|default:("YesNo::NO"|enum) === "YesNo::YES"|enum}
    {script src="js/addons/rus_yandex_metrika/providers/obsolete.js" cookie-name="yandex_metrika"}
{else}
    {script src="js/addons/rus_yandex_metrika/providers/default.js"}
{/if}
{script src="js/addons/rus_yandex_metrika/index.js"}

{if $addons.rus_yandex_metrika.ecommerce === "YesNo::YES"|enum
    && ($yandex_metrika.deleted|default:[]
        || $yandex_metrika.added|default:[]
        || $yandex_metrika.purchased|default:[]
    )
}
    {include file="addons/rus_yandex_metrika/views/components/datalayer.tpl"}
{/if}

<script>
    (function (_, $) {
        _.tr({
            "yandex_metrika.yandex_metrika_cookie_title": '{__("yandex_metrika.yandex_metrika_cookie_title", ['skip_live_editor' => true])|escape:"javascript"}',
            "yandex_metrika.yandex_metrika_cookie_description": '{__("yandex_metrika.yandex_metrika_cookie_description", ['skip_live_editor' => true])|escape:"javascript"}',
        });
    })(Tygh, Tygh.$);
</script>
