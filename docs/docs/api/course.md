---
title: Course
---

## Example

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

````json title="<course>/config.json"
{
  "icon": "png",
  "name": "Example course",
  "author": "CodeDoctorDE",
  "author_url": "https://github.com/CodeDoctorDE",
  "author_avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4",
  "description": "This course is only an example which shows how this config works\n",
  "body": "Changes are automatically rendered as you type.\n* Implements [GitHub Flavored Markdown](https://github.github.com/gfm/)\n* Renders actual, \"native\" React DOM elements\n* Allows you to escape or skip HTML (try toggling the checkboxes above)\n* If you escape or skip the HTML, no `dangerouslySetInnerHTML` is used! Yay!\n## Table of Contents\n## HTML block below\n<blockquote>\n  This blockquote will change based on the HTML settings above.\n</blockquote>\n## How about some code?\n```js\nvar React = require('react');\nvar Markdown = require('react-markdown');\nReact.render(\n  <Markdown source=\"# Your markdown here\" />,\n  document.getElementById('content')\n);\n```\n\nPretty neat, eh?\n\n## Tables?\n\n|  Feature  | Support |\n| :-------: | ------- |\n|  tables   | ✔       |\n| alignment | ✔       |\n|   wewt    | ✔       |\n\n## More info?\n\nRead usage information and more on [GitHub](https://github.com/remarkjs/react-markdown)\n---------------\nA component by [Espen Hovlandsdal](https://espen.codes/)\n",
  "category": [],
  "lang": "en",
  "private": true,
  "parts": [
    "part-1",
    "part-2"
  ]
}
````

</TabItem>
<TabItem value="yaml">

````yaml title="<course>/config.yml"
# The icon of the backend. Supported values are [png, jpg, svg, null]
icon: png

# The name of the course. You can see it in the title or in the list
name: Example course

# The author. It will appear on the front page and on the courses list
author: CodeDoctorDE
author_url: https://github.com/CodeDoctorDE
author_avatar: https://avatars1.githubusercontent.com/u/20452814?v=4

# The description of the course which can be seen in the list of the courses and the intro page.
description: >
  This course is only an example which
  shows how this config works
  
# The body is posting on the home page of the course page. Source: https://remarkjs.github.io/react-markdown/
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

# The current category of the course. You can see the categories in the list
category: []

# The language of the course. You can see a flag as a badge of the course.
lang: en

# Controls if the course is shown in the list
private: true

# The course. See the preview to understand all config entries
parts:
- part-1
- part-2

````

</TabItem>
</Tabs>

## Options

| Name        |              Type              | Required |                                                                                       Description |
| :---------- | :----------------------------: | :------: | ------------------------------------------------------------------------------------------------: |
| name        |             String             |   true   |              The name of the course. It will shown in the courses list and in the course details. |
| description |             String             |  false   |    The description of the course which can be seen in the list of the courses and the intro page. |
| body        |       String (Markdown)        |   true   |                                                      This will display on the course details page |
| icon        | String (png, jpg, svg) or null |  false   | The icon will show up in the course list left to the title and on the details page of the course. |
| lang        |     String (Language tag)      |  false   |                                                                The language of the current course |
| author      |      [Author](author.md)       |  false   |                              The author. It will appear on the front page and on the courses list |
| category    |         Array<String\>         |  false   |                        The current category of the course. You can see the categories in the list |
| private     |            Boolean             |  false   |                                                       Controls if the course is shown in the list |
| parts       |         Array<String\>         |   true   |                                       The course contents. This are the folder names of the parts |
| support_url |             String             |  false   |                   The current url where you can get help. This will override the main support url |
