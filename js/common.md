# Common

## JSON Stringification

1. `toJSON` is called when object is passed to `JSON.stringify`

2. `toJSON` should return object which could be safely pass to `JSON.stringify`

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