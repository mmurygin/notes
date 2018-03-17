# Перегрузка операторов
1. Перегрузка в виде внешней функции

    * унарный оператор
    ```cpp
    Vector operator-(Vector const & v) {
        return Vector(-v.x, -v.y);
    }
    ```

    * бинарный оператор
    ```cpp
    Vector operator*(Vector const & v, double d) {
        return Vector(v.x * d, v.y * d);
    }
    ```

1. Перегрузка внутри классов

    * следующие операторы можно пегружать **только** внутри класса: **`(type)`**, **`[]`**, **`->`**, **`->*`**, **`=`**.

    ```cpp
    struct Vector {
        Vector operator-() const {
            return Vector(-x, -y);
        }
        Vector operator-(Vector const & p) const {
            return Vector(x - p.x, y - p.y);
        }
    private:
        double x,y;
    };
    ```

1. Перегрузка инкремента и декремента
    ```cpp
    struct BigNum {
        BigNum & operator++(){ // prefix
            // increment

            return *this;
        }

        BigNum & operator++(int) {// postfix
            BigNum tmp(*this);
            ++(*this);
            return tmp;
        }
    };
    ```

    * т.к. постфиксный оператор имеет небольшой overhead (создание tmp объект) - лучше использовать префиксные.

1. Переопределине операторов ввода-вывода

    * можно переопределить только как внешную функцию (мы не можем изменить клас iostream)
    ```cpp
    #include <iostream>

    struct Vector { ... };

    std::istream& operator>>(std::istream & is, Vector &p) {
        is >> p.x >> p.y;
        return is;
    }

    std::ostream& operator<<(std::ostream &os, Vector const &p) {
        os << p.x << ' ' << p.y;
    }
    ```
1. Оператор приведения
    ```cpp
    struct String {
        operator bool() const {
            return size_ != 0;
        }

        operator char const *() const {
            if (*this)
                return data_;

            return "";
        }
    };
    ```

## Правила переопределения операторов.
1. Переопределение арифметичиских и битовых операторов
    * `+=` разумно реализовать внутри класса
        * нам нужен доступ к приватным полям класса
    * `+` разумно переопределить снаружи класса, чтобы работало приведение типов
        ```cpp
        struct String {
            String (char const * str) { ... }

            String & operator+=(String const & s) {
                ...
                return *this;
            }

            // String operator+(String const & s2) const { ... }
        }

        String operator +(String s1, String const & s2)  {
            return s1+=s2;
        }

        String s1("world");
        String s2 = "Hello " + s1; // перегрузка внутри функции не сработает в данном кейсе, перегрузка снаружи сработает
        ```
1. Не рекомендуется переопределять операторы с особым порядком выполнения: `&&`, `||`, `,`. Т.к. при переопределении будет нарушен порядок выполнения, так же может быть нарушена lazy evaluation.
