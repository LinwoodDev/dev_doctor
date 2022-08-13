---
title: "Windows"
sidebar_position: 2
---

```mdx-code-block
import DownloadButton from '@site/src/components/DownloadButton.js';
```

![Stable release version](https://img.shields.io/badge/dynamic/yaml?color=c4840d&label=Stable&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FLinwoodCloud%2Fdev_doctor%2Fstable%2Fapp%2Fpubspec.yaml&style=for-the-badge)
![Nightly release version](https://img.shields.io/badge/dynamic/yaml?color=f7d28c&label=Nightly&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FLinwoodCloud%2Fdev_doctor%2Fnightly%2Fapp%2Fpubspec.yaml&style=for-the-badge)

## Minimum system requirements

* Windows 10 or higher.

## Binaries

<div className="row margin-bottom--lg padding--sm">
<div className="dropdown dropdown--hoverable margin--sm">
  <button className="button button--outline button--info button--lg">Stable</button>
  <ul className="dropdown__menu">
    <li>
      <DownloadButton after="/downloads/post-windows" className="dropdown__link" href="https://github.com/LinwoodCloud/dev_doctor/releases/download/release/Dev-Doctor-1.6-Setup.exe">
        Setup
      </DownloadButton>
    </li>
    <li>
      <DownloadButton after="/downloads/post-windows" className="dropdown__link" href="https://github.com/LinwoodCloud/dev_doctor/releases/download/release/windows.zip">
        Portable
      </DownloadButton>
    </li>
  </ul>
</div>
<div className="dropdown dropdown--hoverable margin--sm">
  <button className="button button--outline button--danger button--lg">Nightly</button>
  <ul className="dropdown__menu">
    <li>
      <DownloadButton after="/downloads/post-windows" className="dropdown__link" href="https://github.com/LinwoodCloud/dev_doctor/releases/download/preview/Dev-Doctor-1.6-Setup.exe">
        Setup
      </DownloadButton>
    </li>
    <li>
      <DownloadButton after="/downloads/post-windows" className="dropdown__link" href="https://github.com/LinwoodCloud/dev_doctor/releases/download/preview/windows.zip">
        Portable
      </DownloadButton>
    </li>
  </ul>
</div>
</div>

Read more about the nightly version of Dev-Doctor [here](/nightly).

## Install using winget

```powershell
winget install LinwoodCloud.DevDoctor
```

To upgrade the winget package, run:

```powershell
winget upgrade LinwoodCloud.DevDoctor
```

To uninstall the winget package, run:

```powershell
winget uninstall LinwoodCloud.DevDoctor
```

### Nightly version

```powershell
winget install LinwoodCloud.DevDoctor.Nightly
```

To upgrade the winget package, run:

```powershell
winget upgrade LinwoodCloud.DevDoctor.Nightly
```

To uninstall the winget package, run:

```powershell
winget uninstall LinwoodCloud.DevDoctor.Nightly
```
