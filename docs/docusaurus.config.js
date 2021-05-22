/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 */

/** @type {import('@docusaurus/types').DocusaurusConfig} */
module.exports = {
  title: 'Dev-Doctor Docs',
  tagline: 'The documentation to the dev-doctor app',
  url: 'https://docs.dev-doctor.cf',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  organizationName: 'LinwoodCloud', // Usually your GitHub org/user name.
  projectName: 'dev_doctor', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: 'Dev-Doctor',
      logo: {
        alt: 'Dev-Doctor Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'doc',
          docId: 'introduction',
          label: 'Docs',
          position: 'left'
        },
        {
          type: 'doc',
          docId: 'api',
          label: 'API',
          position: 'left'
        },
        {
          to: 'downloads',
          label: 'Downloads',
          position: 'left'
        },
        {href: 'https://linwood.tk/blog', label: 'Blog', position: 'left'},
        {
          type: 'docsVersionDropdown',

          position: 'right',
          // Add additional dropdown items at the beginning/end of the dropdown.
          dropdownItemsBefore: [],
          dropdownItemsAfter: [{to: '/versions', label: 'All versions'}],
          // Do not add the link active class when browsing docs.
          dropdownActiveClassDisabled: true
        },

        // Please keep GitHub link to the right for consistency.
        {
          href: 'https://github.com/LinwoodCloud?q=dev_doctor&type=&language=&sort=',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Community',
          items: [
            {
              label: 'Discord',
              href: 'https://discord.linwood.tk',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/LinwoodCloud',
            },
          ],
        },
        {
          title: 'Source code',
          items: [
            {
              label: 'App',
              href: 'https://github.com/LinwoodCloud/dev_doctor.git',
            },
            {
              label: 'Collection',
              href: 'https://github.com/LinwoodCloud/dev_doctor-collection',
            },
            {
              label: 'Backend',
              href: 'https://github.com/LinwoodCloud/dev_doctor-backend',
            }
          ],
        },
        {
          title: 'Legal',
          items: [
            {
              label: 'Imprint',
              to: 'https://codedoctor.tk/impress',
            },
            {
              label: 'Privacy Policy',
              href: 'https://codedoctor.tk/privacy',
            },
          ],
        }
      ],
      // Please do not remove the credits, help to publicize Docusaurus :)
      copyright: `Copyright © ${new Date().getFullYear()} LinwoodCloud.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          routeBasePath: '/docs',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/LinwoodCloud/dev_doctor/edit/develop/docs/',
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
  
  plugins: [
    [
      '@docusaurus/plugin-pwa',
      {
        offlineModeActivationStrategies: [
          'appInstalled',
          'standalone',
          'queryString',
        ],
        pwaHead: [
          {
            tagName: 'link',
            rel: 'icon',
            href: '/img/logo.png',
          },
          {
            tagName: 'link',
            rel: 'manifest',
            href: '/manifest.json', // your PWA manifest
          },
          {
            tagName: 'meta',
            name: 'theme-color',
            content: 'rgb(92, 48, 112)',
          },
        ],
      },
    ],
  ],
};
