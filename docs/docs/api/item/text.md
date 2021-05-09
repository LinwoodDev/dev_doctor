---
title: Text item
sidebar_label: Text
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
    "name": "Text",
    "type": "text",
    "text": "Here you can write something. Markdown is supported!\n"
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/<part>/config.yml"
name: Text
type: text
text: >
  Here you can write something. Markdown is supported!
```

</TabItem>
</Tabs>

## Options

| Name   |       Type        | Required |                                                                  Description |
| :----- | :---------------: | :------: | ---------------------------------------------------------------------------: |
| text   | String (Markdown) |   true   | The current text which will be displayed as content of the current part item |
| points |      Integer      |  false   |        The points which will be get if you visited this site. Default is `0` |
