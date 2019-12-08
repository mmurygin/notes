# Types & Grammar

## Table of Content

* [Types](#types)
* [Numbers](#numbers)
* [Natives](#natives)
* [Coercing](#coercing)

## Types

1. JavaScript defines seven built-in types:
    * `null`
    * `undefined`
    * `boolean`
    * `number`
    * `string`
    * `object`
    * `symbol` (added in ES6)

2. `typeof` returns one of the above types

    ```javascript
    typeof true          === 'boolean' // true
    typeof true          === "boolean";   // true
    typeof 42            === "number";    // true
    typeof "42"          === "string";    // true
    typeof { life: 42 }  === "object";    // true
    typeof Symbol()      === "symbol";    // true
    ```

3. But typeof have some special behaviour with `null` and `function`

    ```javascript
    typeof null === 'object'; // true
    typeof function a() {} === 'function'; // true
    ```

4. In JavaScript, variables don't have types - **values have types**. Variables can hold any value, at any time.

5. `undefined` is a value that a declared variable can hold. "Undeclared" means a variable has never been declared. To safely check for undeclared variables use:

    ```javascript
    typeof a !== 'undefined'
    ```

6. The difference between `null` and `undefined`
    * `undefined` hasn't had a value yet
    * `null` had a value and doesn't anymore

## Numbers

1. JavaScript has just one numeric type: number. This type includes both "integer" values and fractional decimal numbers.

2. The best way to compare two floats

    ```javascript
    function numbersCloseEnoughToEqual(n1,n2) {
        return Math.abs( n1 - n2 ) < Number.EPSILON;
    }
    ```

3. Because of how numbers are represented, there is a range of "safe" values for the whole number "integers". Numbers that are out of that range are represented as floats.

4. To test if variable is integer use

    ```javascript
    Number.isInteger( 42 );     // true
    Number.isInteger( 42.000 ); // true
    Number.isInteger( 42.3 );   // false
    ```
5. To test if variable is "save" integer

    ```javascript
    Number.isSafeInteger( Number.MAX_SAFE_INTEGER );    // true
    Number.isSafeInteger( Math.pow( 2, 53 ) );          // false
    Number.isSafeInteger( Math.pow( 2, 53 ) - 1 );      // true
    ```

6. There are some operations (like the bitwise operators) which are only defined for 32-bit numbers.

7. To check if variable is `NaN` use

    ```javascript
    const a = 2 / "foo";
    Number.isNaN(a); // true
    ```

8. It's commonly a bad idea to pass `Number` wrapper to function, and try to edit it value. `Number` is mutable object and it can hold only one value.

    ```javascript
    function foo(x) {
        x = x + 1;
        x; // 3
    }

    var a = 2;
    var b = new Number( a ); // or equivalently `Object(a)`

    foo( b );
    console.log( b ); // 2, not 3
    ```

## Natives

1. There are the following natives:
    * `String()`
    * `Number()`
    * `Boolean()`
    * `Array()`
    * `Object()`
    * `Function()`
    * `RegExp()`
    * `Date()`
    * `Error()`
    * `Symbol()` -- added in ES6!

2. If you call `"my string".length` the string value is automatically boxed to object `String`. The same for `number`, `boolean`.

3. `Function.prototype` it is an empty function, `RegExp.prototype` it is an empty regex, `Array.prototype` it is an empty array. So it's usefull to use that objects as default value. But you should be sure that these value will not be modified.

    ```javascript
    function isThisCool(vals,fn,rx) {
        vals = vals || Array.prototype;
        fn = fn || Function.prototype;
        rx = rx || RegExp.prototype;

        return rx.test(
            vals.map( fn ).join( "" )
        );
    }
    ```

## Coercing

1. **Converting** a value from one type to another is often called "type casting," when done **explicitly**, and **coercion** when done **implicitly** (forced by the rules of how a value is used).

2. JavaScript coercions always result in one of the scalar primitive values, like `string`, `number`, or `boolean`.

6. **`toBoolean`**

    * there are the following **falsy** values in javascript
        * `undefined`
        * `null`
        * `false`
        * `+0`, `-0` and `NaN`
        * `""`
        * `document.all` (it is obsolete browser behaviour)

    * Everything which is not from the above list evaluates to true

        ```javascript
        var a = new Boolean( false );   // true
        var b = new Number( 0 );        // true
        var c = new String( "" );       // true
        ```

3. **`toString`** is used in case when we convert object to `String`

    ```javascript
    const obj = {
        foo: 'bar',
        toString: function () {
            return 'the number 42';
        }
    }

    console.log(obj); // 'the number 42'
    ```

4. **`valueOf`**- is used in case when we convert object to `Number`

    ```javascript
    const obj = {
        foo: 'bar',
        valueOf: function () {
            return 28;
        }
    }

    obj + 14 // 42
    ```

5. **`toJSON`** is called when object is passed to `JSON.stringify`. `toJSON` should return object which could be safely pass to `JSON.stringify`

    ```javascript
    var o = { };

    var a = {
        b: 42,
        c: o,
        d: function(){}
    };

    // create a circular reference inside `a`
    o.e = a;

    // would throw an error on the circular reference
    // JSON.stringify( a );

    // define a custom JSON value serialization
    a.toJSON = function() {
        // only include the `b` property for serialization
        return { b: this.b };
    };

    JSON.stringify( a ); // "{"b":42}"
    ```

