# to_do_list

### Приложение может работать с задержками, если есть проблемы с подключением к back-end, т.к. реализована синхронизация данных при изменении(про это в задании не было сказано, пришлось додумывать, как сделать лучше, в итоге было решено сделать так)

## Перечень реализованных функций:

* По заданию:
  * Реализована обработка ошибок сети
  * Приложение может работать в оффлай режиме. При изменениях в оффлайн режиме при следующем входе с интернетом будет возможность загрузить данные на back-end
  * Работа с данными вынесена в отдельный слой
  * Реализован state management с использованием пакета riverpod
  * Реализован DI с помощью пакета GetIt
  * Добавлены unit тесты для класса DataManager
  * Реализован интеграционный тест !ВАЖНО!, который симулирует случай создания задания, при входе в приложение с подключенным интернетом

* Не по заданию:
  * Добавлено всплывающее окно, которое показывается, когда приложение теряет связь в back-end
  * Добавлена функция, позволяющая пользователю, при входе в приложение, выбирать, хочет он загрузить список задач с локального хранилища, или же с back-end

## Ссылка на загрузку .apk:

[Скачать](https://drive.google.com/file/d/1yIggX6nc0BUpoAKkcbTTVbpaEwfh5e8B/view?usp=sharing)

## Демонстация внешнего вида приложения:

*Диалоговое окно, предлагающее варианты загрузки данных:

![app6](https://github.com/Vantwozz/to_do_list/assets/95244485/34d56b0e-521a-4308-ad61-6618fd5cd373)

*Всплывающее окно, оповещающее о отсутствии связи с back-end:

![app7](https://github.com/Vantwozz/to_do_list/assets/95244485/1504a10d-e7b3-4495-9b1b-bd1a7f6442f4)![app7](https://github.com/Vantwozz/to_do_list/assets/95244485/1504a10d-e7b3-4495-9b1b-bd1a7f6442f4)

* Внешний вид домашней страницы:

![app1](https://github.com/Vantwozz/to_do_list/assets/95244485/c4f25b02-6943-49a8-b89e-8d6dd04335ae)

![app2](https://github.com/Vantwozz/to_do_list/assets/95244485/193ac229-8fbf-4a24-8596-728aae4be4c7)

* Страница редактирования/создания задания:

![app3](https://github.com/Vantwozz/to_do_list/assets/95244485/2bae51c4-e0bb-4022-81f0-263c94c98f8e)

![app4](https://github.com/Vantwozz/to_do_list/assets/95244485/3bcbaa2e-46c1-40f4-b64d-f3e0c8c9b927)


* Иконка приложения:

![icon](https://github.com/Vantwozz/to_do_list/assets/95244485/ff6cde85-5eb1-4a86-ad4f-2e74f1000cf0)
