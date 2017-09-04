## Hashing

```
H(x) => y
```

1. Properties
    * difficult to generate a specific `y`
    * infeasible to find `x` for a given `y`
    * can't modify `x` without modifying `y`
    * hard to find a **collision** (two thing has to the same value)

2. Hasing algoritms
    * **`crs32`** - is used for checksums, fast, easy to find a collision
    * **`md5`** - pretty fast, ~~secure~~, easy to find a collision
    * **`sha1`** - not fast, secure
    * **`sha256`** - slow, but very secure
