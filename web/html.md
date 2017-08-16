# HTML

## Table of Content

- [Особенности HTML разметки](#Особенности-HTML-разметки)
- [DOCTYPE](#doctype)
- [Тэги верхнего уровня](#Тэги-верхнего-уровня)
- [Тэги внутри head](#Тэги-внутри-head)
- [Блочные и строковые элементы](#Блочные-и-строковые-элементы)
- [Таблицы](#Таблицы)
- [Гиперссылки](#Гиперссылки)
- [Формы](#Формы)
- [Escaping](#escaping)


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
    ```html
    <link rel="stylesheet" href="/style.css">
    <link rel="alternate" href="/news.rss" type="application/rss+xml">
    ```
1. _Рекомендации по `link` и `script`_: Загрузку `CSS` рекомендуется ставить в тэге `head`, а загрузку `JavaScript` - наоборот ближе к концу странице. Это повышает скорость отрисовки страницы.

## Блочные и строковые элементы

1. There are two type of elements:
    * **block elements** - always starts on a new line and takes up the full width of the parent element (stretches out to the left and right as far as it can).
    * **inline elements** - does not start on a new line and only takes up as much width as necessary.

2. In HTML all spaces and new lines turn into one single space

## Таблицы
1. **`table`** - контейнер для таблицы
1. **`caption`** - заголовок таблицы
1. **`thead`** - заголовок таблицы
1. **`tbody`** - тело таблицы
1. **`tr`** - строчка таблицы
1. **`td`** - ячейка таблицы
    * **`colspan`** - атрибут объединяющий две колонки
    * **`rowspan`** - атрибут объединяющий две строки


## Гиперссылки

```html
<a href="http://google.com" target="_blank">
    <img src="duck.png">
</a>
```
1. **`href`** - url гиперссылки
1. **`target`** - в каком окне открывать ссылку
1. **`name`** - имя якоря, можно использовать вместо `href`
1. Поведение браузера при переходе по гиперссылке зависит от протокола в URL:
    * `http`, `https`, `ftp` - переход по ссылке
    * `mailto` - запуск почтового клиента
    * `javascript` - выполнение JavaScript кода
    * `#anchor` - прокрутка текущей страницы


## Формы
1. Используются для отправки данных на сервер.
    ```html
    <form action="/add" enctype="multipart/form-data" method="POST" target="frame3">
        <input type="file" name="image">
        <input type="text" name="nick">
        <input type="submit" value="Send">
    </form>
    ```
1. **`method`** - метод с помощью которого отправляется запрос
1. **`action`** - url на который будет отправлена форма
1. **`target`** - имя окна в котором будет открыта форма
1. **`enctype`** - способ кодирования данных форма.
    * **`application/x-www-form-urlencoded`** - данные в формате url запроса. Если метод GET то подставляются прямо в URL, в противном случае отправляются в теле запроса. Используется для отправки обычных данных. Тип формы по умолчанию.
        * К примеру есть форма с данными:
            ```
            id: 3
            name: Вася
            friend_id: [4, 5]
            ```

            В закодированном виде:
            ```
            id=3&name=%D0%92%D0%B0%D1%81%D1%8F&friend=4&friend=5
            ```

    * **`multipart/form-data`** - используется если в форме загружается файл.

1. Элементы ввода формы
    * **`input`** - универсальное поле, может быть:
        * `type="hidden"` - невидимое, к примеру для того чтобы передать id объекта
        * `type="text"` - текстовое поле
        * `type="checkbox"` - переключатель да\нет
    * **`button`** - кнопка
    * **`textarea`** - многострочное поле ввода
    * `select`, `option` - выпадающий список
1. Атрибуты элементов ввода
    ```html
    <input type="text" name="username" value="" placeholder="Max" autocomplete="off">
    ```
    * **`type`** - определяет внешний вид и функционал
    * **`name`** - имя, с которым данный элемент попадает в запрос
    * **`value`** - начальное значение, пользователь может изменить
    * **`placeholder`** - подсказка для пользователя


## Escaping

1. You should escape all user input before inserting it to you html page.

2. You `escape` function should at least escape the following
    * `>` with `&gt`
    * `<` with `&lt`
    * `"` with `&quot`
    * `&` with `&amp`
