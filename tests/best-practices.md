# The pillas of good unit tests

1. There is no silver bullet in software development. Tests are definitly not one of it.
2. When we do tests we should take in order:
    * how long system supposed to live
    * what is the price of changing tests
    * how fragile your tests
3. Test pyramid:
    * a lot of unit tests
    * small amount of integration tests
    * very small amount of customer tests

## Unit tests
1. Can display error source
2. Can provide a feedback quickly
3. Can help in development
4.![Do not provide a feedback - does system work as a whole ](../images/unit-tests.gif)

## Customer tests
1. Long running time
2. Do not display an error source
3. Provide feedback - does system as a whole work or not
4. If customer tests are made via UI then any change in UI will break them.

# Mocking
1. Do no mock everything, because mocking has a price
2.
