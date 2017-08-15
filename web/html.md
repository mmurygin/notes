# HTML

## Особенности HTML разметки
1. Браузер корректно парсит всё описанное ниже
1. Произвольный регистр: `<BR> == <br>`
1. Атрибуты без скобок: `color=red`
1. Сокращенные атрибуты: `disabled`
1. Непарные тэги: `<p>` вместо `<p></p>`
1. Перестановки тэгов: `<b><i></b><i>`
1. Кастомные тэги (никак не отрисовываются по умолчанию): `<magic></magic>`

## DOCTYPE
1. `DOCTYPE` уточняет тип содержимого, указывает  HTML парсеру как правильно разбирать данный документ.
1. HTML 4 Transitional:
    ```html
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    ```
1. HTML 5
    ```html
    <!DOCTYPE html>
    ```
## Тэги верхнего уровня
1. `html` - обёртка
    * **`lang`** - атрибут тэга `html` позволяющий браузеру сопоставить язык документа и язык предпочитаемый пользователем, к примеру для того чтобы предложить перевод
1. `head` - заголовок страницы, не отображается
1. `body` - тело страницы, то что видит пользователь

## Тэги внутри head
1. `title` - отображается в заголовке окна браузера
1. `meta` - содержит информацию для user-agentов
    * установка header'a страницы (вместо установки её бэкэндом)
        ```html
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        ```
    * иногда веб сервер не отдаёт кодировку, т.е. указывает контент но не указывает его кодировку, тогда можно исправить это следующим тегом:
        ```html
        <meta charset="utf-8" />
        ```

    * настройка корректной работы мобильного браузера
        ```html
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        ```
1. **`link`** - указание связанных ресурсов, например `CSS`

## Common

1. There are two type of elements:
    * **block elements** - always starts on a new line and takes up the full width of the parent element (stretches out to the left and right as far as it can).
    * **inline elements** - does not start on a new line and only takes up as much width as necessary.

2. In HTML all spaces and new lines turn into one single space

## Metadata

1. **viewport**
    * ensures that the screen width is set to the device width and the content is rendered with this width in mind

    * Designing the websites to be responsive to the size of the viewport

## Escaping

1. You should escape all user input before inserting it to you html page.

2. You `escape` function should at least escape the following
    * `>` with `&gt`
    * `<` with `&lt`
    * `"` with `&quot`
    * `&` with `&amp`
