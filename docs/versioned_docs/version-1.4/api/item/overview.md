---
title: Item
sidebar_label: Overview
---

## Sub classes

- [text](text)
- [video](video)
- [quiz](quiz)

## Options

| Name        |                        Type                         | Required |                                                                                    Description |
| :---------- | :-------------------------------------------------: | :------: | ---------------------------------------------------------------------------------------------: |
| name        |                       String                        |   true   | The name of the current part item. It will show up in the tab as label and in the details card |
| description |                       String                        |  false   |   The description of the current part item. It will show up in the details card under the name |
| type        | String ([text](text), [video](video), [quiz](quiz)) |   true   |                                                                         The current sub class. |
