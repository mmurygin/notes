# Vulnerabilities

## Injection Flaws

### SQL Injection

1. [Description](https://owasp.org/www-community/attacks/SQL_Injection)
1. [Video Description](https://www.youtube.com/watch?v=pypTYPaU7mM&list=PL8239DA448CC2BB7C&index=2)
1. [Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)

### Path Injection
When users are allowed to specify the path on the server to the requested data

### Deserialization of untrusted data

#### Definition
It is often convenient to serialize objects for communication or to save them for later use. However, serialized data or code can be modified. This malformed data or unexpected data could be used to abuse application logic, deny service, or execute arbitrary code when deserialized

#### Example
* serialize shopping card and save it in cookies and send to backend
* by modifying cookies user can
    * change item prices
    * implement DoS attack
    * inject some code and if object is deserialized as it is, then the malicious code can be executed

    ```python
    import yaml
    text = "comment_text: !!python/object/apply:subprocess.check_output\n kwds: {args: 'less /etc/passwd', shell: True}"
    result = yaml.load(text, Loader=yaml.Loader)
    print(result)
    ```

#### Protection
* sanitize the data of serialized object as untrusted user input through filtering or validation
* implement integrity checks such as digital signatures or any serealized object

## Data Exposure

### Session Handling

#### Definition
Sensitive data are exposed in the session token

#### Example
An online store stores a session ID as a URL parameter.

#### Protection
* Store the session identifier in a secure HTTP cookie
* Link the session to another form of identifiable data on the server-side, such as IP Address or User-Agent
* Revoke the session validity in the event of an identity mismatch
* Require password confirmation for any potentially sensitive account operations (e.g. send money)

## Side Channel Vulnerability

### Timing Attack

#### Definition
When a difference in response time for different inputs can expose sensitive information or change the flow of a given process.

Example:
When a username is valid, then password hashing check is performed. As password hashing takes time, the response time for valid username will be longer than response time for invalid username. It could give an attacher the way to identify if username is present in the system or not.

#### Prevention
* Run timing-based testing on the application
* When a sensitive action that may take some time is executed, ensure the application makes the same processing actions regardless of the other flow it might take
