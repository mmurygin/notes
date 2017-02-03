# Types

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