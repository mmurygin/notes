# Templates

## Destination
1. Призванны убрать дублирование при определении похожих классов (к примеру ArrayInt, ArrayFloat)

## Шаблоны в С
1. Макросы

    ```cpp
    #define DEFINE_ARRAY(Name, Type) \
    struct Name {
        explicit Name(size_t size) : data_(new Type[size]), size_(size) {} \
        ~Name() { delete [] data_; } \
        size_t size() const { return size_; } \
        Type operator[](size_t i) const { return data_[i]; } \
        Type & operator[](size_t i) { return data_[i]; } \
        \
    private: \
        Type * data_; \
        size_t size_; \
    };

    // usage
    DEFINE_ARRAY(ArrayInt, int);
    DEFINE_ARRAY(ArrayFlt, float);
    ```

1. Проблемы:
    * Макросы подставляются в текстовом виде
    * Ошибки возникают не в том коде который мы написали, а в том коде который получился после препроцессора

## Шаблоны С++
1. Определение:
    ```cpp
    template <class Type>
    struct Array {
        explicit Array(size_t size)

        ~Array() {
            delete [] data_;
        }

        size_t size() const {
            return size_;
        }

        Type operator[] (size_t i) const {
            return data_[i];
        }

        Type & operator[] (size_t i) {
            return data_[i];
        }
        ...
    private:
        Type * data_;
        size_t size;
    }
    ```
1. Использование
    ```cpp
    Array<int> ai(10);
    Array<fload> af(20);
    ```
1. Когда комплятор первый раз встретит строчку `Array<int>` то он скомпилирует нужный нам класс из шаблона.
