# CSS

## Table of Content
- [Selectors](#selectors)


## Selectors

| Selector | Target |
| -------- | ------ |
| * | target all elements |
| .class1, .class2 | target all ement with “class1” or “class2” |
| h1 span | target all spans inside `<h1>` |
| .main > a | target all `<a>` which are directly inside .main |
| h2 + p | target directly next brother <p> after <h2> |
| h2 ~ p | target all p which have brother h2 |
| a[class] | targe all a elements which have class attribute |
input[type=”text”] | target all input elements which have type attribute equals to | text |
| a[href^=”http://”] | target all a elements which href begin with “http;//” (end with have symbol $=, contains have symbol *= ) |
| a:link | target all a elements which have href attributes. |
| a:visited | target all a elements which have been clicked There is following psedu classes: link, visited, hove, active, focus |
| li:first-child | traget first child of li. |
| span:only-child | target all spans whick are the single child of their parent(also we can use last-child |
| li:nth-child(even) | target all event li elements (insted even we can use number) |
| li:nth-child(2n+3) | target all li element start with 3 child, after 3 selects every second child (n can be negative) |
| div:nth-of-type(2) | target all each second child (other elements doesn’t count in children) div |
| p:only-of-type | target all p elements that is the only child of its type, of its parent |
| input[type=”text”]:enabled | target all input elements with type text which are enabled |
| p::first-line | target first line of every <p> element (other options: last-line, first-letter, last-letter) |
| .phone::before { content: “\2706”;} | insert value in content as first child of elements with class phone (as content we can put resource: url(“path_to_resource”) |
