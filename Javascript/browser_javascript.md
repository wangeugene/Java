# Console javascript manipulation

```javascript
document.querySelector('header')  // get the <header>...</header>
document.querySelector('#jira')  // get the <tag id="jira" ...>...</tag>
document.querySelector('.jira')  // get the <tag class="jira" ...>...</tag>
document.querySelector('jira li:last-child')  // get the last <li>...</li> element inside <jira>...</jira>
document.querySelectorAll('jira li')  // get a collection of <li>...</li> elements inside <jira>...</jira>
document.querySelectorAll('jira li').forEach(item => item.style.backgroundColor = 'red')  // get a collection of <li>...</li> elements inside <jira>...</jira>
```