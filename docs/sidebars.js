/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 */

module.exports = {
  'docs': [
    'introduction',
    {
      type: 'category',
      label: 'Backend',
      items: [
        'backend/overview',
        'backend/own',
        'backend/collection',
      ]
    },
    'privacypolicy'
  ],
  'api': [
    'api/migrating',
    'api',
    'api/course',
    'api/part',
    'api/author',

    {
      type: 'category',
      label: 'Item',
      collapsed: false,
      items: [
        'api/item/overview',
        'api/item/text',
        'api/item/video',
        'api/item/quiz'
      ]
    }
  ]
};
