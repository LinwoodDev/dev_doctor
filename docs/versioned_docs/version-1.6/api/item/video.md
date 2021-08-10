---
title: Video item
sidebar_label: Video
---
Extends [Item](overview)

## Example

In the items option in the [part](../part)

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="<course>/<part>/config.json"
{
    "name": "Welcome",
    "description": "Welcome to the course",
    "type": "video",
    "source": "youtube",
    "url": "ScMzIvxBSi4"
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/<part>/config.yml"
name: Welcome
description: Welcome to the course
type: video
source: youtube
url: ScMzIvxBSi4
```

</TabItem>
</Tabs>

## Options

| Name   |             Type             | Required |                                                           Description |
| :----- | :--------------------------: | :------: | --------------------------------------------------------------------: |
| source | String (youtube, url, asset) |   true   |    The source of the file. Asset is the file in the current directory |
| url    |            String            |   true   |     The current url of the file. On youtube it is the id of the video |
| points |           Integer            |  false   | The points which will be get if you visited this site. Default is `1` |
