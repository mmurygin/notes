# Security

## Table Of Contents

- [Origins](#origins)
- [CSRF](#csrf)
- [SQL Injection](#sql-injection)
- [XSS](#xss)
- [Resources](#resources)

## Origins

1. **Same Origin Policy** - javascript is not allowed to get or put any data from dirrerent origin. [More info](https://www.w3.org/Security/wiki/Same_Origin_Policy)

2. Origin consist of (for example **https://www.udacity.com**):
    * Data Scheme (**https://**)
    * Hostname (**www.udacity.com**)
    * Port (**443**)

    If you change any of this values - you are on a different origin.

3. Same origin policy is resticted by the client, not the server. So if we got a response from different origin, browser will not allow to read it.

4. Browsers can get images and scripts from a different origin, using correcpoing tags (`<img>`, `<script></script>`). In this case we are not allowed to read image or script content.

5. **CORS** (Cross Origin Resource Sharing) - allow servers to specify a set of origins that are allowed to fetch resources.

    ![cross  origin get request](https://mdn.mozillademos.org/files/14293/simple_req.png)

6. **Preflighted requests** - requests first send an `HTTP` request by the `OPTIONS` method to the resource on the other domain, in order to determine whether the actual request is safe to send. Cross-site requests are preflighted like this since they may have implications to user data. In particular, a request is preflighted if:

    * It uses methods other than GET, HEAD or POST. Also, if POST is used to send request data with a Content-Type other than application/x-www-form-urlencoded, multipart/form-data, or text/plain, e.g. if the POST request sends an XML payload to the server using application/xml or text/xml, then the request is preflighted.

    * It sets custom headers in the request

    ![preflight request description](https://mdn.mozillademos.org/files/14289/prelight.png)

7. [More info abount CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)

## CSRF

1. **CSRF** (Cross-site request forgery) - is an attack that forces an end user to execute unwanted actions on a web application in which they're currently authenticated. CSRF attacks specifically target state-changing requests, not theft of data, since the attacker has no way to see the response to the forged request. With a little help of social engineering (such as sending a link via email or chat), an attacker may trick the users of a web application into executing actions of the attacker's choosing.

3. As `POST` requests with type `application/x-www-form-urlencoded` are not preflighted, it's possible to send post request from evil site to trusted site, if user is authorized inside trusted site.

    ```javascript
    fetch('www.no-very-secure-bank', {
        method: 'POST',
        body: 'recipient=Umbrella+Corp&amount=666',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        credentials: 'include',
    });

## SQL Injection

1. **SQL Injection** - attack consists of insertion or "injection" of a SQL query via the input data from the client to the application.

2. Example

    * We have a route `/users?id={id}`

    * We have a backend for selecting user:

    ```python
    query = "SELECT * FROM Users WHERE id = %s" % self.get.id
    ```

    * Hacker made a request `/users?id=12;some_sql_query` and can run any sql within our database


## XSS

1. **XSS** (Cross-site scripting) - Cross-Site Scripting (XSS) attacks are a type of injection, in which malicious scripts are injected into otherwise benign and trusted web sites. XSS attacks occur when an attacker uses a web application to send malicious code, generally in the form of a browser side script, to a different end user. Flaws that allow these attacks to succeed are quite widespread and occur anywhere a web application uses input from a user within the output it generates without validating or encoding it.

An attacker can use XSS to send a malicious script to an unsuspecting user. The end user’s browser has no way to know that the script should not be trusted, and will execute the script. Because it thinks the script came from a trusted source, the malicious script can access any cookies, session tokens, or other sensitive information retained by the browser and used with that site. These scripts can even rewrite the content of the HTML page

2. The only way to protect from such kind of attack - **only way to secure for such kind of attack is validate user input on a serverside**. If we insert user input into html we should escape that html

## Resources

[https://www.owasp.org](https://www.owasp.org)