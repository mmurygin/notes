# Strings

## Строковые литералы
1. Строки - это массивы символов типа `char` заканчивающиеся нулевым символом.
    ```
    char s[] = "Hello"; // {'H', 'e', 'l', 'l', 'o', '\0' }
    ```
1. Работа осуществляется с помощью библиотеки `string`.

## Ввод-вывод
1. Используется библиотека `iostream`.
    ```cpp
    #include <string>
    #include <iostream>
    using namespace std;

    int main () {
        string name;
        cout << "Enter your name: ";
        cin >> name; // считывается слово
        cout << "Hi, " << name << endl;

        return 0;
    }
    ```
1. Реализация ввода-вывода в стиле С++ типобезопасна.

## Работа с файлами в стиле С++
1. Библиотека `fstream` обеспечивает работу с файлами
    ```cpp
    #include <string>
    #include <fstream>
    using namespace std;

    int main () {
        string name;
        ifstream input ("input.txt"); // определяем переменную типа ifstream и открываем input stream
        input >> name; // используем переменную input аналогично cin

        ofstream output("output.txt"); // теперь можно использовать output аналогично cout
        output << "Hi, " << name << endl;
    }
    ```
1. Файлы закроются при выходе из функции.
