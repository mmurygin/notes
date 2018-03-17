# Умные указатели

## Определение
1. Реализуют концепт: "Получение ресурса есть инициализация" (Resource Acquisition is Inicialization)

## Пример
```cpp
struct SmartPtr {
    SmartPtr(data * data)
        : data(data) { }

    ~SmartPtr() {
        delete data_;
    }

    Data & operator*() const {
        return * data_;
    }

    Data * operator-> const {
        return data_;
    }

    Data * get() const {
        return data_;
    }

    bool operator==(SmartPtr const & p) {
        return p.get() == get();
    }

private:
    Data * data_;
};
```
