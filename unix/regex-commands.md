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
        ```
    * **`+`** - соответствует одному или большему количеству вхождений предыдущего символа

        ```code
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

    * **`-w`** - поиск по словам
        ```shell
        $ grep -w over text
        The winter is over.
        Can you get over there?
        ```
1. Предотвращение раскрытия регулярного выражения командной оболочкой. Т.к. символ доллара является специальным символом, то рекомендуется экранировать регулярные выражения
    ```shell
    $ grep 'r$' names
    Fleur
    Floor
    ```

## rename
1. _Осуществляет переименование файлов по шаблону_
1. Реализация утилиты `rename` отличается между дистрибутивами _Debian_ и _Red Hat_
1. **`'s/to_replace_regex/replace_value/`**Поиск и переименование файлов по шаблону:

    ```shell
    $ ls
    abc       allfiles.TXT  bllfiles.TXT  Scratch   tennis2.TXT
    abc.conf  backup        cllfiles.TXT  temp.TXT  tennis.TXT
    $ rename 's/TXT/text/' *
    $ ls
    abc       allfiles.text  bllfiles.text  Scratch    tennis2.text
    abc.conf  backup         cllfiles.text  temp.text  tennis.text
    ```
1. **`'s/regex/str/g`** - замена всех вхожденй строки
    ```shell
    $ touch aTXT.TXT
    $ rename -n 's/TXT/txt/g' aTXT.TXT
    aTXT.TXT renamed as atxt.txt
    ```
1. **`'s/regex/str/i`** - замена без учета регистра
    ```shell
    $ ls
    file1.text  file2.TEXT  file3.txt
    $ rename 's/.text/.txt/i' *
    $ ls
    file1.txt  file2.txt  file3.txt
    ```
1. **Изменение расширений**
    ```shell
    $ ls *.txt
    allfiles.txt  bllfiles.txt  cllfiles.txt  really.txt.txt  temp.txt  tennis.txt
    $ rename 's/.txt$/.TXT/' *.txt
    $ ls *.TXT
    allfiles.TXT  bllfiles.TXT    cllfiles.TXT    really.txt.TXT
    temp.TXT      tennis.TXT
    ```

## sed
1. Редактор потока данных (_stream editor_) или, для краткости, утилита `sed`, использует регулярные выражения для модификации потока данных.
1. Замена строки
    ```shell
    $ echo Понедельник | sed 's/Понедель/Втор/'
    Вторник
    ```
1. Слэши могут быть заменены на некоторые другие символы, которые могут оказаться более удобными и повысить читаемость команды в ряде случаев.
    ```shell
    $ echo Понедельник | sed 's:Понедель:Втор:'
    Вторник
    $ echo Понедельник | sed 's_Понедель_Втор_'
    Вторник
    $ echo Понедельник | sed 's|Понедель|Втор|'
    Вторник
    ```
1. **`sed -i`** интерактивная обработка файлов (т.е. изменения содержимого файла)
    ```shell
    $ echo Понедельник > today
    $ cat today
    Понедельник
    $ sed -i 's/Понедель/Втор/' today
    $ cat today
    Вторник
    ```
1. **`.`** - любой символ
    ```shell
    $ echo 2014-04-01 | sed 's/....-..-../YYYY-MM-DD/'
    YYYY-MM-DD
    ```
1. **`\s`** - используется на ссылку на пробел и табуляцию
    ```shell
    $ echo -e 'сегодня\tтеплый\tдень'
    сегодня	теплый	день
    $ echo -e 'сегодня\tтеплый\tдень' | sed 's_\s_ _g'
    сегодня теплый день
    ```
1. **`?`** - необязательный символ
    ```shell
    $ cat list2
    ll
    lol
    lool
    loool
    $ grep -E 'ooo?' list2
    lool
    loool
    $ cat list2 | sed 's/ooo\?/A/'
    ll
    lol
    lAl
    lAl
    ```
1. **ровно n повторение**
    ```shell
    $ cat list2
    ll
    lol
    lool
    loool
    $ grep -E 'o{3}' list2
    loool
    $ cat list2 | sed 's/o\{3\}/A/'
    ll
    lol
    lool
    lAl
    ```
1. **от n до m повторений**
    ```shell
    $ cat list2
    ll
    lol
    lool
    loool
    $ grep -E 'o{2,3}' list2
    lool
    loool
    $ grep 'o\{2,3\}' list2
    lool
    loool
    $ cat list2 | sed 's/o\{2,3\}/A/'
    ll
    lol
    lAl
    lAl
    ```

1. **Обратные ссылки** - круглые скобки используются для группировки частей регулярного выражения, на которые впоследствии могут быть установлены ссылки.
    ```shell
    $ echo Sunday | sed 's_\(Sun\)_\1ny_'
    Sunnyday
    $ echo Sunday | sed 's_\(Sun\)_\1ny \1_'
    Sunny Sunday
    ```
1. **Множественные обратные ссылки** - в случае использования более чем одной пары круглых скобок, ссылка на каждую из них может быть осуществлена путем использования последовательных числовых значений.
    ```shell
    $ echo 2014-04-01 | sed 's/\(....\)-\(..\)-\(..\)/\1+\2+\3/'
    2014+04+01
    $ echo 2014-04-01 | sed 's/\(....\)-\(..\)-\(..\)/\3:\2:\1/'
    01:04:2014
    ```

## Ресурсы
1. [stepik Основы Линукс](https://stepik.org/lesson/30012/step/2?course=%D0%9E%D1%81%D0%BD%D0%BE%D0%B2%D1%8B-Linux&unit=10741)
