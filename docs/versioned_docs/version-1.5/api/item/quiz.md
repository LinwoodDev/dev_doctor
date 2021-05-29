---
title: Quiz item
sidebar_label: Quiz
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
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/<part>/config.yml"
name: Quiz
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

| Name      |                  Type                  | Required |                                                                               Description |
| :-------- | :------------------------------------: | :------: | ----------------------------------------------------------------------------------------: |
| time      |                Integer                 |  false   | How long should the user have time to solve this quiz. If not set, there is no time limit |
| questions | Array<[Quiz question](#quiz-question)> |   true   |                                                          All questions from the part item |

## Inner classes

### Quiz question

#### Example

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="<course>/<part>/config.json"
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
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/<part>/config.yml"
title: Question 1 title
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
```

</TabItem>
</Tabs>

#### Options

| Name        |                Type                | Required |                                                              Description |
| :---------- | :--------------------------------: | :------: | -----------------------------------------------------------------------: |
| title       |               String               |   true   |                                 This will be displayed above the answers |
| description |               String               |  false   |                                       This will be displayed as subtitle |
| evaluation  |               String               |  false   |                     This will be displayed if the user validate the form |
| multi       |              Boolean               |  false   | Choose if the question is a multiple choice question. Default is `false` |
| answers     | Array<[Quiz answer](#quiz-answer)> |   true   |                                              All answers of the question |

### Quiz answer

#### Example

<Tabs defaultValue="json" groupId="type" values={[
  { label: 'JSON', value: 'json', },
  { label: 'YAML', value: 'yaml', },
]}>
<TabItem value="json">

```json title="<course>/<part>/config.json"
{
  "name": "C",
  "points": 5,
  "correct": true
}
```

</TabItem>
<TabItem value="yaml">

```yaml title="<course>/<part>/config.yml"
name: C
points: 5
correct: true
```

</TabItem>
</Tabs>

#### Options

| Name         |  Type   | Required |                                                                                                 Description |
| :----------- | :-----: | :------: | ----------------------------------------------------------------------------------------------------------: |
| name         | String  |   true   |                                                                      The text which will be shown as answer |
| minus-points | Integer |  false   | This are the minus points which will be given if the player give the wrong answer. Default it is `0` point. |
| points       | Integer |  false   |            This are the points which will be given if the player give this answer. Default it is `1` point. |
| correct      | Boolean |   true   |                                                        This will be displayed if the user validate the form |
