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

1. Не рекомендуется переопределять операторы с особым порядком выполнения: `&&`, `||`, `,`. Т.к. при переопределении будет нарушен порядок выполнения.
