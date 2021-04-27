---
title: Main
id: api
---
## Example

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="config.json"
{
    "name": "Dev-Doctor",
    "description": "The sample backend of dev-doctor",
    "icon": null,
    "courses": [
        "example",
        "example2"
    ]
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="config.yml"
# The name of the current backend
name: 'Dev-Doctor'
# The description of the current backend
description: /
    The sample backend of dev-doctor
# The icon of the backend. Supported values are [png, jpg, svg, null]
icon: null
# All courses of the current backend
courses:
- example
- example2
```

</TabItem>
</Tabs>

## Options

| Name        |              Type              | Required |                                                                                                                                     Description |
| :---------- | :----------------------------: | :------: | ----------------------------------------------------------------------------------------------------------------------------------------------: |
| name        |             String             |   true   |                                      The name of the current backend. It will show up in the backend store as title or in the servers settings. |
| description |             String             |  false   |                                                   The description of the current backend. It will show up in the backend store after the title. |
| icon        | String (png, jpg, svg) or null |  false   | The icon will show up in the backend store in the list left to the title, on the details page of the backend store and in the servers settings. |
| courses     |         Array<String\>         |   true   |                                                        The folder names of the courses. With this option the app will iterate above the courses |
| support_url |             String             |  false   |                                                                                                          The current url where you can get help |
