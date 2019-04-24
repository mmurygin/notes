# Text Processing
* [Globbing](#globbing)
* [Regex](#regex)
* [grep](#grep)
* [sed](#sed)
* [awk](#awk)
* [rename](#rename)
* [Usefull utilities](#usefull-utilities)

## Globbing
1. **globbing** - file name substitution by bash
1. **`man 7 glob`** - globbing overview
1. Restricted amount of BRE is used for globbing
    * **`*`** - any character any number of times
    * **`?`** - any character one time
    * **`[xyz]`** - x, y or z
    * **`[a-z]`** - characters from a to z
    * **`[^az]`** - not a or z
    * **`{a*, b*}`** - a* or b*

## Regex
1. **`man 7 regex`** - get help about regex
1. It's better to use quotes **''** to prevent shell globbing
1. There are the following types of regular expressions in linux
    * **BRE** - basic regular expressions
        * `grep`
        * `sed`
    * **ERE** - extended regular expressions
        * `egrep`
        * `awk`
        * `perl`
    * **PRE** - perl regular exressions
1. **With `BRE` we need to escape symbols like `{}`, `()`, `+`, `?`, `|`**
1. Regexp
    * **`^`** - start of a string
        * `^abc` => abc, abcdef, abc123
    * **`$`** - end of a string
        * `abc$` => abc, llabc, 456abc
    * **`.`** - any symbol (except a new line)
        * `a.c` => abc, aaa, a2c
    * **`*`** - null or more of the preceding character
        * `ab*c` => ac, abc, abbbbc
    * **`+`** - one or more of the preceding characters
        * `ab+c` => abc, abbbc
    * **`?`** null or one of the preceding character
        * `ab?c` => ac, abc
    * **`\`** - escape symbol
    * **`{..}`** - explicit quantity of preceding character
        * **`{m,n}`** - from `m` to `n` occurencies
        * **`{m}`** - exactly `m` occurencies
            * `ab{2}c` => abbc
    * **`[...]`** - explicit set of characters to match
        * **`[A-Z]`** - symbols range
            * `^[a-c]` => axxx, bxx, cxx
        * **`[xyz]`** - one of
        * **`[^xyz]`** - not one of
    * **`(...)`** - group of characters
        * `(123){3}` => 123123123
1. The above table describes the difference between `BRE` \ `ERE` an `PRE`

| Name                                      | BRE and ERE   | PRE
| ----------------------------------------- | :------------ | :- |
| any digit                                 | [[:digit:]]   | \d |
| new line                                  | -             | \n |
| tab                                       | -             | \t |
| carriage return                           | -             | \r |
| space,tab,new line,cariage return         | -             | \s |
| not space,tab, new line, carriage return  | -             | \S |

## grep
1. Search lines which match pattern
1. It's best practise to use **''** around regex to prevent shell globbing
1. Set regexp version (default is BRE)
    * **`grep -E`** - use Extended Regular Expression
    * **`grep -G`** - use Basic Regular Expression
    * **`grep -P`** - use Perl Regular Expressions
1. Вывод строк совпадающих с шаблоном
    * Поиск по одному символу
        ```bash
        $ cat names
        Tania
        Laura
        Valentina

        $ grep u names
        Laura
        ```

    * Поиск по группе символов
        ```bash
        $ grep ia names
        Tania
        ```

    * Один из двух символов
        ```bash
        $ grep '[LT]' names

        $ grep '[0-9]' names

    * to not match
        ```bash
        $ grep '[^0-9]' names
        ```

    * or condition

        $ grep -E 'L|T' names
        Laura
        Tania

        $ grep 'L\|T' names
        Laura
        Tania
        ```

1. Совпадение одного или нескольких символов
    * **`*`** - соответствует 0, одному или большему количеству вхождений предыдущего симола.
        ```bash
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
        ```bash
        $ cat names
        Tania
        Laura
        Valentina
        Fleur
        Floor

        $ grep 'a$' names
        Tania
        Laura
        Valentina
        $ grep 'r$' names
        Fleur
        Floor
        ```

    * **`^`** - совпадение в начале строки
        ```bash
        $ grep '^Val' names
        Valentina
        $ grep '^F' names
        Fleur
        Floor
        ```

1. Разделение слов
    * **`\b`** - используется как разделитель слов при поиске

        ```bash
        $ cat text
        The governer is governing.
        The winter is over.
        Can you get over there?

        $ grep '\bover\b' text
        The winter is over.
        Can you get over there?
        ```

    * **`-w`** - поиск по словам
        ```bash
        $ grep -w over text
        The winter is over.
        Can you get over there?
        ```

1. Обратная ссылка: `\(..\)` `\1`
    ```bash
    grep '\([a-z]\)\1' # finds all words with two similar characters
    ```

1. Предотвращение раскрытия регулярного выражения командной оболочкой. Т.к. символ доллара является специальным символом, то рекомендуется экранировать регулярные выражения
    ```bash
    $ grep 'r$' names
    Fleur
    Floor
    ```

## sed
1. Редактор потока данных (_stream editor_) или, для краткости, утилита `sed`, использует регулярные выражения для модификации потока данных.
1. Замена строки
    ```bash
    $ echo Понедельник | sed 's/Понедель/Втор/'
    Вторник
    ```
1. Слэши могут быть заменены на некоторые другие символы, которые могут оказаться более удобными и повысить читаемость команды в ряде случаев.
    ```bash
    $ echo Понедельник | sed 's:Понедель:Втор:'
    Вторник
    $ echo Понедельник | sed 's_Понедель_Втор_'
    Вторник
    $ echo Понедельник | sed 's|Понедель|Втор|'
    Вторник
    ```
1. **`sed -i`** интерактивная обработка файлов (т.е. изменения содержимого файла)
    ```bash
    $ echo Понедельник > today
    $ cat today
    Понедельник
    $ sed -i 's/Понедель/Втор/' today
    $ cat today
    Вторник
    ```
1. **`.`** - любой символ
    ```bash
    $ echo 2014-04-01 | sed 's/....-..-../YYYY-MM-DD/'
    YYYY-MM-DD
    ```
1. **`\s`** - используется на ссылку на пробел и табуляцию
    ```bash
    $ echo -e 'сегодня\tтеплый\tдень'
    сегодня	теплый	день
    $ echo -e 'сегодня\tтеплый\tдень' | sed 's_\s_ _g'
    сегодня теплый день
    ```
1. **`?`** - необязательный символ
    ```bash
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
    ```bash
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
    ```bash
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
    ```bash
    $ echo Sunday | sed 's_\(Sun\)_\1ny_'
    Sunnyday
    $ echo Sunday | sed 's_\(Sun\)_\1ny \1_'
    Sunny Sunday
    ```
1. **Множественные обратные ссылки** - в случае использования более чем одной пары круглых скобок, ссылка на каждую из них может быть осуществлена путем использования последовательных числовых значений.
    ```bash
    $ echo 2014-04-01 | sed 's/\(....\)-\(..\)-\(..\)/\1+\2+\3/'
    2014+04+01
    $ echo 2014-04-01 | sed 's/\(....\)-\(..\)-\(..\)/\3:\2:\1/'
    01:04:2014

## awk
1. [Tutorial (rus)](https://www.opennet.ru/docs/RUS/awk/)
1. Print column
    ```bash
    awk -F: '{print $1}' /etc/passwd
    ```

## rename
1. _Осуществляет переименование файлов по шаблону_
1. Реализация утилиты `rename` отличается между дистрибутивами _Debian_ и _Red Hat_
1. **`'s/to_replace_regex/replace_value/`**Поиск и переименование файлов по шаблону:

    ```bash
    $ ls
    abc       allfiles.TXT  bllfiles.TXT  Scratch   tennis2.TXT
    abc.conf  backup        cllfiles.TXT  temp.TXT  tennis.TXT
    $ rename 's/TXT/text/' *
    $ ls
    abc       allfiles.text  bllfiles.text  Scratch    tennis2.text
    abc.conf  backup         cllfiles.text  temp.text  tennis.text
    ```
1. **`'s/regex/str/g`** - замена всех вхожденй строки
    ```bash
    $ touch aTXT.TXT
    $ rename -n 's/TXT/txt/g' aTXT.TXT
    aTXT.TXT renamed as atxt.txt
    ```
1. **`'s/regex/str/i`** - замена без учета регистра
    ```bash
    $ ls
    file1.text  file2.TEXT  file3.txt
    $ rename 's/.text/.txt/i' *
    $ ls
    file1.txt  file2.txt  file3.txt
    ```
1. **Изменение расширений**
    ```bash
    $ ls *.txt
    allfiles.txt  bllfiles.txt  cllfiles.txt  really.txt.txt  temp.txt  tennis.txt
    $ rename 's/.txt$/.TXT/' *.txt
    $ ls *.TXT
    allfiles.TXT  bllfiles.TXT    cllfiles.TXT    really.txt.TXT
    temp.TXT      tennis.TXT
    ```

## Usefull utilities
1. **`cat`** - copy data from `stdin` to `stdout`.
    * **`cat file1 file2 file3`** - concatenates 3 files
    * create a file with content (stop - here is a special marker of end of input - we could specify any word, most common is EOF)
        ```bash
        cat > hot.txt <<stop
        some string
        stop
        ```
    * copy file1 to file2
        ```bash
        cat file1 > file2
        ```
    * при размещении фильтра cat между двумя программными каналами не будет осуществляться какой-либо обработки передающихся через них данных.
        ```bash
        $ tac count.txt | cat | cat | cat | cat | cat
        три
        два
        один
        ```
1. **`tee`** - перемещает данные из стандартного потока ввода stdin в стандартный поток вывода stdout, а также записывает их в файл.

    ```bash
    $ tac count.txt | tee temp.txt | tac
    один
    два
    три
    $ cat temp.txt
    три
    два
    один
    ```
1. **`cut`** - извлекает данные из столбцов расположенных в файлах таблиц с указанием разделителя столбцов или количества байт данных в столбцах. Чаще всего используется для того чтобы убрать делимитер

    * разделить строку по двоеточию и вывести 1 и 3 столбцы
        ```bash
        cut -d: -f1,3 /etc/passwd | tail -4
        ```

    * разделить строку по пробелам
        ```bash
        cut -d" " -f1 file.txt
        ```

1. **`tr`** - преобразование символов в потоке

    * заменить символ в строке
        ```bash
        cat tennis.txt | tr 'e' 'E'
        ```

    * **`-d`** - удалить символ
        ```bash
        cat tennis.txt | tr -d e
        ```

    * заменить последовательность символов
        ```bash
        cat tennis.txt | tr 'a-z' 'A-Z'
        ```

1. **`wc`** - подсчитывает строки, слова и символы
1. **`sort`** - сортирует строки

    * сортировка строк
        ```bash
        sort music.txt
        ```

    * **`-k`** - сортировка строк по 1 столбцу
        ```bash
        sort -k1 country.txt
        ```

    * **`-n`** - числовая сортировка
        ```bash
        $ sort -k3 country.txt
        Belgium, Brussels, 10
        Germany, Berlin, 100
        Italy, Rome, 50
        France, Paris, 60

        Iran, Teheran, 70
        $ sort -n -k3 country.txt
        Belgium, Brussels, 10
        Italy, Rome, 50
        France, Paris, 60
        Iran, Teheran, 70
        Germany, Berlin, 100
        ```

1. **`uniq`** - отфильтровывает повторяющиеся строки
1. **`head`** - get first 10 lines of file
    * **`head -4`** - get first 4 files of file
    * **`head -4c`** - get first 4 bytes of file
1. **`tail`** - get last 10 lines of file
    * **`tail -4`** - get last 4 files of file
    * **`tail -4c`** - get last 4 bytes of file
1. **`less`** get file content and format it into multiple pages (use space to navigate between them).
1. **`tac`** - print file with reversed string order
    ```bash
    $ tac count.txt
    три
    два
    один
    ```
1. **`fmt`** - formats text
