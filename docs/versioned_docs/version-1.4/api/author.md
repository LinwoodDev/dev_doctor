---
title: Author
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
  "name": "CodeDoctorDE" ,
  "url": "https://github.com/CodeDoctorDE",
  "avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4",
  "avatar-type": "png"
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="config.yml"
"author":
  "name": "CodeDoctorDE" 
  "url": "https://github.com/CodeDoctorDE"
  "avatar": "https://avatars1.githubusercontent.com/u/20452814?v=4"
  "avatar-type": "png"
```

</TabItem>
</Tabs>

## Options

| Name        |          Type          | Required |                                                              Description |
| :---------- | :--------------------: | :------: | -----------------------------------------------------------------------: |
| name        |         String         |   true   | The display name of the author. It will be displayed right to the avatar |
| url         |         String         |  false   |            The url which will be opened if the user clicks on the author |
| avatar      |         String         |  false   |                                              The url to the avatar image |
| avatar-type | String (png, jpg, svg) |  false   |                                           The type of the current avatar |
