# CSS

## Table of Content
- [Selectors](#selectors)
- [Псевдоклассы](#Псевдоклассы)
- [Псевдоэлементы](#Псевдоэлементы)
- [Наследование стилей (каскадирование)](#Наследование-стилей-каскадирование)
- [Приоритеты стилей](#Приоритеты-стилей)
- [Режимы отображения элементов](#Режимы-отображения-элементов)
- [Позиционирование элементов](#Позиционирование-элементов)

## Selectors

| Selector | Target |
| -------- | ------ |
| * | target all elements |
| **`.class1, .class2`** | target all ement with “class1” or “class2” |
| **`h1 span`** | target all spans inside `<h1>` |
| **`.main > a`** | target all `<a>` which are directly inside .main |
| **`h2 + p`** | target directly next brother `<p>` after `<h2>` |
| **`h2 ~ p`** | target all p which have brother h2 |
| **`a[class]`** | targe all a elements which have class attribute |
| **`input[type=”text”]`** | target all input elements which have type attribute equals to text |
| **`a[href^=”http://”]`** | target all a elements which href begin with “http;//” (end with have symbol $=, contains have symbol *= ) |
| **`a:link`** | target all a elements which have href attributes. |
| **`a:visited`** | target all a elements which have been clicked There is following psedu classes: link, visited, hove, active, focus |
| **`li:first-child`** | traget first child of li. |
| **`span:only-child`** | target all spans whick are the single child of their parent(also we can use last-child |
| **`li:nth-child(even)`** | target all event li elements (insted even we can use number) |
| **`li:nth-child(2n+3)`** | target all li element start with 3 child, after 3 selects every second child (n can be negative) |
| **`div:nth-of-type(2)`** | target all each second child (other elements doesn’t count in children) div |
| **`p:only-of-type`** | target all p elements that is the only child of its type, of its parent |
| **`input[type=”text”]:enabled`** | target all input elements with type text which are enabled |
| **`p::first-line`** | target first line of every `<p>` element (other options: last-line, first-letter, last-letter) |
| **`.phone::before { content: “\2706”;}`** | insert value in content as first child of elements with class phone (as content we can put resource: `url(“path_to_resource”)` |

## Псевдоклассы
1. **`a:visited`** - посещенная ссылка
1. **`a:link`** - непосещенная ссылка
1. **`div:hover`** - элемент при наведении мыши
1. **`input:focus`** - элемент при получении фокуса
1. **`li:first-child`** - выбирает первого потомка среди множества элементов.

## Псевдоэлементы
1. **`#el:after`** - виртуальный элемент сразу после `#el`
1. **`#el:before`** - виртуальный элемент непосредственно перед `#el`
    ```css
    .jack-sparrow:before {
        content: "Captain ";
        display: inline;
    }
    ```

## Наследование стилей (каскадирование)
1. Некоторые стили (`color`, `font-family`) наследуются всеми дочерними объектами элемента.
    ```html
    <head>
        <style>
        body { color: darkgray; font-family: Arial; }
        p { font-size: 110% }
        </style>
    </head>
    <body>
        <p> Привет, <a href=”/”>Мир</a> </p>
    </body>
    ```
1. При этом нужно помнить что не все стили наследуются. Узнать поведение можно только в документации.

## Приоритеты стилей
1. В случае если два разных стиля конфликтуют между собой, применяется тот, что обладает большей **специфичностью**.
1. Правила расчета специфичности
    * id - 100
    * классы и псевдоклассы - 10
    * тэги и псевдоэлементы - 1
    * `ul.info ol + li` = 13
    * `li.red.level` = 23
1. Если специфичность двух стилей совпадает, применяется тот, что расположен **ниже** в `HTML/CSS` коде. В порядке уменьшения приоритета
    1. инлайн стиль
    1. стиль объявленный в `html` коде
    1. стиль объявленный в отдельном файле
1. Указание флага **`!important`** позволяет перекрыть проверку специфичности.

## Режимы отображения элементов
1. **`display:none`** - элемент невидим, не занимает места
1. **`display: block`** - элемент занимает максимальную ширину, начинается с новой строки, учитывает `width`, `height`.
1. **`display:inline`** - элемент занимает минимальную ширину, и не прерывает строку, игнорирует `width`, `height`.
1. **`display:inline-block`** - блочный элемент, но не разрывает строку, учитывает `width`, `height`.
1. **`float: left`** - всплывание влево.
    * Элемент с атрибутом `float` не раздвигает контейнер. Могут раздвинуть контейнер только если он так же является `float`
    * Несколько элементов с атрибутом `float` располагаются последовательно, в зависимости от порядка определения в `html`.
    * Если двум `float` элементам задать ширину по 50% то они разделят страницу пополам
1. **`clear: both`** - отменяет всплывание. Можно представить как проводящуюся черту после кторой отменяется всплывание.

## Позиционирование элементов
1. **`position: static`** - обычное расположение.
1. **`position: relative`** - смещение относительно начального местоположения на странице
1. **`position: absolute`** - относительно ближайщего родителя который является `relative`, `absolute` или `fixed`, иначе - относительно начала документа.
1. **`position: fixed`** - относительно окна браузера. Элемент должен быть блочный с шириной и высотой. Его положение определяется атрибутами `top/right/bottom/left`. Такие элементы не смещаются при прокрутке страницы
