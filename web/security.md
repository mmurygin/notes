# Security

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