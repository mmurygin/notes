# Express JS

## Routes

1. If we created some route with `express.Router` then all requests will have property `baseUrl`

  ```javascript
  app.use('/tasks', tasksRouter);

  tasksRouter.get('/list', (req, res) => {
    req.baseUrl // tasks
  })
  ```

2. To send value to view you can use one of the following
  * the model of a view
  * `res.locals`
  * `app.locals`


## Error handling

1. To throw error we can pass error instance or message to the `next` callback

  ```javascript
  app.get('/home', (res, req, next) => {
    next(new Error('my custom error'));
  });
  ```

  ```javascript
  app.get('/home', (res, req, next) => {
    db.User
      .get()
      .catch(next);
  });
  ```