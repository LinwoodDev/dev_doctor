---
title: Article
---

## Example

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem';

<Tabs defaultValue="json" groupId="type" values={[
{ label: 'JSON', value: 'json', }, { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

````json title="<article>/config.json"
{
  "icon": "png",
  "title": "Example article",
  "time":"2012-02-27",
  "author": {
    "name": "CodeDoctorDE",
    "url": "https://github.com/CodeDoctorDE",
    "avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4"
  },
  "body": "Changes are automatically rendered as you type.\n* Implements [GitHub Flavored Markdown](https://github.github.com/gfm/)\n* Renders actual, \"native\" React DOM elements\n* Allows you to escape or skip HTML (try toggling the checkboxes above)\n* If you escape or skip the HTML, no `dangerouslySetInnerHTML` is used! Yay!\n## Table of Contents\n## HTML block below\n<blockquote>\n  This blockquote will change based on the HTML settings above.\n</blockquote>\n## How about some code?\n```js\nvar React = require('react');\nvar Markdown = require('react-markdown');\nReact.render(\n  <Markdown source=\"# Your markdown here\" />,\n  document.getElementById('content')\n);\n```\n\nPretty neat, eh?\n\n## Tables?\n\n|  Feature  | Support |\n| :-------: | ------- |\n|  tables   | ✔       |\n| alignment | ✔       |\n|   wewt    | ✔       |\n\n## More info?\n\nRead usage information and more on [GitHub](https://github.com/remarkjs/react-markdown)\n---------------\nA component by [Espen Hovlandsdal](https://espen.codes/)\n",
  "keywords": [
    "example",
    "article"
  ],
  "slug":"example-article",
  "description":"Short description"
}
````

</TabItem>
<TabItem value="yaml">

````yaml title="<article>/config.yml"
icon: png
title: Example article
time: '2012-02-27'
author:
  name: CodeDoctorDE
  url: https://github.com/CodeDoctorDE
  avatar: https://avatars1.githubusercontent.com/u/20452814?v=4
body: |
  Changes are automatically rendered as you type.
  * Implements [GitHub Flavored Markdown](https://github.github.com/gfm/)
  * Renders actual, "native" React DOM elements
  * Allows you to escape or skip HTML (try toggling the checkboxes above)
  * If you escape or skip the HTML, no `dangerouslySetInnerHTML` is used! Yay!
  ## Table of Contents
  ## HTML block below
  <blockquote>
    This blockquote will change based on the HTML settings above.
  </blockquote>
  ## How about some code?
  ```js
  var React = require('react');
  var Markdown = require('react-markdown');
  React.render(
    <Markdown source="# Your markdown here" />,
    document.getElementById('content')
  );
  ```

  Pretty neat, eh?

  ## Tables?

  |  Feature  | Support |
  | :-------: | ------- |
  |  tables   | ✔       |
  | alignment | ✔       |
  |   wewt    | ✔       |

  ## More info?

  Read usage information and more on [GitHub](https://github.com/remarkjs/react-markdown)
  ---------------
  A component by [Espen Hovlandsdal](https://espen.codes/)
keywords:
- example
- article
slug: example-article
description: Short description

````

</TabItem>
</Tabs>

## Options

| Name        |              Type              | Required |                                                                                       Description |
| :---------- | :----------------------------: | :------: | ------------------------------------------------------------------------------------------------: |
| slug        |             String             |   true   |                                                   The slug where you can find the article by url. |
| title       |             String             |   true   |              The name of the article. It will shown in the articles list and in the article details. |
| description |             String             |  false   |    The description of the article which can be seen in the list of the articles and the intro page. |
| body        |       String (Markdown)        |   true   |                                                      This will display on the article details page |
| icon        | String (png, jpg, svg) or null |  false   | The icon will show up in the article list left to the title and on the details page of the article. |
| author      |      [Author](author.md)       |  false   |                              The author. It will appear on the front page and on the articles list |
| keywords    |         Array<String\>         |  false   |                                     All keywords for the article. This will be used for the search |
| time        |         Integer (Time)         |  false                     |                                         The time where the article was published |
