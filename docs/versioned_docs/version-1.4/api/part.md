---
title: Part
---

## Example
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="<course>/<part>/config.json"
{
  "name": "Part 1",
  "description": "This is a description",
  "assets": [],
  "items": [
    {
      "name": "Welcome",
      "description": "Welcome to the course",
      "type": "video",
      "source": "youtube",
      "url": "ScMzIvxBSi4"
    },
    {
      "name": "Text",
      "type": "text",
      "text": "Here you can write something. Markdown is supported!\n"
    },
    {
      "name": "Quiz",
      "time": 600,
      "type": "quiz",
      "questions": [
        {
          "title": "Question 1 title",
          "description": "Question 1 description",
          "evaluation": "An evaluation",
          "answers": [
            {
              "name": "A"
            },
            {
              "name": "B"
            },
            {
              "name": "C",
              "points": 5,
              "correct": true
            },
            {
              "name": "D",
              "points": 2,
              "correct": true
            }
          ]
        },
        {
          "title": "Question 2 title",
          "description": "Question 2 description",
          "evaluation": "An evaluation for question 2",
          "answers": [
            {
              "name": "A",
              "correct": true
            },
            {
              "name": "B",
              "correct": true
            },
            {
              "name": "C"
            },
            {
              "name": "D"
            }
          ]
        }
      ]
    }
  ]
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/<part>/config.yml"
# The name of the current part. The name will stand on the sidebar
name: Part 1

# Optional: The description of the part
description: This is a description

# Assets which will be cached if the user is offline. The assets need to be in the asset directory
assets: []

# The content of the part.
items:
- name: Welcome
  description: Welcome to the course
  type: video
  source: youtube
  url: ScMzIvxBSi4
- name: Text
  type: text
  text: >
    Here you can write something. Markdown is supported!
- name: Quiz
  # Optional: Max time in seconds (here: 10 minutes)
  time: 600
  type: quiz
  questions:
  - title: Question 1 title
    description: Question 1 description
    evaluation: An evaluation
    answers:
    - name: A
    - name: B
    - name: C
      points: 5
      correct: true
    - name: D
      points: 2
      correct: true
  - title: Question 2 title
    description: Question 2 description
    evaluation: An evaluation for question 2
    answers:
    - name: A
      correct: true
    - name: B
      correct: true
    - name: C
    - name: D
```

</TabItem>
</Tabs>

## Options

| Name        |             Type              | Required |                                                                                     Description |
| :---------- | :---------------------------: | :------: | ----------------------------------------------------------------------------------------------: |
| name        |            String             |   true   |                 The name of the current part. It will show up in the app bar and in the drawer. |
| description |            String             |  false   |                                                               This will be shown in the drawer. |
| assets      |        Array<String\>         |   true   | The assets (like images, videos, ...) filee names in the assets folder in the current directory |
| items       | Array<[Item](item/overview)\> |   true   |                                                            A list of items in the current part. |
