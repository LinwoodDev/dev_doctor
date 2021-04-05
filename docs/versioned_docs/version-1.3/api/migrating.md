---
title: Migrating
---

## Automatic

Create a new backend by clicking on the plus. Then click on the code button in the right top corner and click on the submit button in the right bottom corner. Open the website again to copy the new code.
Repeat this steps with the course and coursepart files.

## Manual

:::note

It's recommend to use the [automatic](#automatic) method.

:::

Add `"api-version": 9` to the [main](../api.md), [course](course.md) and [course part](part.md).

## Author

Change this old code:

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="<course>/config.json"
{
  "author": "CodeDoctorDE",
  "author_url": "https://github.com/CodeDoctorDE",
  "author_avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4",
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/config.yml"  
"author": "CodeDoctorDE" 
"author_url": "https://github.com/CodeDoctorDE"
"author_avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4"
```

</TabItem>
</Tabs>

To this:

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="<course>/config.json"
{
  "author": {
    "name": "CodeDoctorDE",
    "url": "https://github.com/CodeDoctorDE",
    "avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4",
  }
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/config.yml"  
"author":
  "name": "CodeDoctorDE"
  "url": "https://github.com/CodeDoctorDE"
  "avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4"
```

</TabItem>
</Tabs>
