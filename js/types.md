# Types & Grammar

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
    typeof true === 'boolean' // true
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

## Coercing

1. There are the following **falsy** values in javascript
    * `undefined`
    * `null`
    * `false`
    * `+0`, `-0` and `NaN`
    * `""`
    * `document.all` (it is obsolete browser behaviour)

2. Everything which is not from the above list evaluates to true
    
    ```javascript
    var a = new Boolean( false );   // true
    var b = new Number( 0 );        // true
    var c = new String( "" );       // true
    ```

3. 