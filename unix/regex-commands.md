# Regex commands

## Table of contents
- [Версии синтаксисов регулярных выражений](#Версии-синтаксисов-регулярных-выражений)
- [grep](#grep)
- [rename](#rename)
- [sed](#sed)

## Версии синтаксисов регулярных выражений
1. **`BRE`** - Basic Regular Expression
1. **`ERE`** - Extended Regular Expression
1. **`PCRE`** - Perl Regular Expressions
1. В зависимости от используемого инструмента может использоваться один или несколько упомянутых выше синтаксисов.

## grep
1. Ищет строки соответствующие паттерну
1. Переключение версий регулярных выражений
    * **`grep -E`** - use Extended Regular Expression
    * **`grep -G`** - use Basic Regular Expression
    * **`grep -P`** - use Perl Regular Expressions
1. Вывод строк совпадающих с шаблоном
    * Поиск по одному символу
        ```shell
        $ cat names
        Tania
        Laura
        Valentina

        $ grep u names
        Laura
        ```

    * Поиск по группе символов
        ```shell
        $ grep ia names
        Tania
        ```

    * Один из двух символов
        ```shell
        $ grep -E 'L|T' names
        Laura
        Tania

        $ grep 'L\|T' names
        Laura
        Tania
        ```

1. Совпадение одного или нескольких символов
    * **`*`** - соответствует 0, одному или большему количеству вхождений предыдущего симола.
    * **`+`** - соответствует одному или большему количеству вхождений предыдущего символа

        ```shell
        $ cat list2
        ll
        lol
        lool
        loool
        $ grep -E 'o*' list2
        ll
        lol
        lool
        loool
        $ grep -E 'o+' list2
        lol
        lool
        loool
        ```

1. Совпадение начала\конца строки
    * **`$`** - совпадение в конце строки
        ```shell
        $ cat names
        Tania
        Laura
        Valentina
        Fleur
        Floor

        $ grep a$ names
        Tania
        Laura
        Valentina
        $ grep r$ names
        Fleur
        Floor
        ```

    * **`^`** - совпадение в начале строки
        ```shell
        $ grep ^Val names
        Valentina
        $ grep ^F names
        Fleur
        Floor
        ```

1. Разделение слов
    * **`\b`** - используется как разделитель слов при поиске

        ```shell
        $ cat text
        The governer is governing.
        The winter is over.
        Can you get over there?

        $ grep '\bover\b' text
        The winter is over.
        Can you get over there?
        ```

    * **`-w`** - строковый поиск
        ```shell
        $ grep -w over text
        The winter is over.
        Can you get over there?
        ```

## Ресурсы
1. [Основы Линукс](https://stepik.org/lesson/30012/step/2?course=%D0%9E%D1%81%D0%BD%D0%BE%D0%B2%D1%8B-Linux&unit=10741)
