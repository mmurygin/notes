# Common

## SQL vs NoSQL
1. SQL
    * Pros
        * stores data in uniform way, so that you could query anything
        * data is consitent in the meaning of relations
        * no dublicated data => easy to update
        * consistency, regarding foreign keys
    * Cons
        * challenging to scale horizontally
        * difficult to change schema on a big running system
1. NoSQL
    * Pros
        * easy to scale horizontally
        * better performance due to data locality
        * schema flexibility
    * Cons
        * there is data dublication
        * it's very tricky, and almost impossible to implement many-to-mane relationship
        * data ara not stored in uniform way, that means that you are restricred in the variety of queires you can perform
        * some queries will be very heavy, especially "join-like". And most of the NoSQL engines does not supports joins
1. Usually if you don't work with huge scale it's better to use traditional SQL database
