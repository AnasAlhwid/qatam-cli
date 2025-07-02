# Qatam CLI

![Qatam CLI logo](./assets/qatam-cli-logo.png)

## Table of Content

- [Qatam CLI](#qatam-cli)
  - [Table of Content](#table-of-content)
  - [Introduction](#introduction)
  - [Qatam CLI diagram](#qatam-cli-diagram)
  - [Prerequisites](#prerequisites)
    - [For **Qatam CLI** usage](#for-qatam-cli-usage)
    - [For **Git** operations usage](#for-git-operations-usage)
    - [For **GitHub** operations usage](#for-github-operations-usage)
  - [Install](#install)
  - [Update](#update)
  - [Uninstall](#uninstall)
  - [Usage](#usage)
  - [List of **Qatam CLI** services](#list-of-qatam-cli-services)
  - [List of **Qatam CLI** commands](#list-of-qatam-cli-commands)
  - [Current status](#current-status)
  - [Support](#support)
  - [License](#license)

## Introduction

**Qatam CLI** is a tool that combines commands from various services into a single CLI, allowing developers to focus on their actual work and increasing productivity.

**Qatam CLI** manages different **_Services_**:

1. Windows OS
2. Git
3. GitHub

## Qatam CLI diagram

```mermaid
---
config:
  markdownAutoWrap: false
  theme: neutral
  layout: elk
  elk:
    mergeEdges: true
    nodePlacementStrategy: NETWORK_SIMPLEX
---

flowchart TB

subgraph Qatam_Syntax
    QatamCommand1[/"qatam &lt;service&gt; &lt;command&gt;"/]
end

subgraph Windows
    direction LR

    windowsCommand1[/"qatam windows &lt;command&gt;"/] ~~~ windowsCommand2[/"qatam w &lt;command&gt;"/]

    click windowsCommand1 href "https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/windows-commands.md#operations-for-windows-os" "Go to Windows section"

    click windowsCommand2 href "https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/windows-commands.md#operations-for-windows-os" "Go to Windows section"
end

subgraph Git
    direction LR

    gitCommand1[/"qatam git &lt;command&gt;"/] ~~~ gitCommand2[/"qatam g &lt;command&gt;"/]

    click gitCommand1 href "https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/git-commands.md#operations-for-git" "Go to Git section"

    click gitCommand2 href "https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/git-commands.md#operations-for-git" "Go to Git section"
end

subgraph GitHub
    direction LR

    gitHubCommand1[/"qatam github &lt;command&gt;"/] ~~~ gitHubCommand2[/"qatam gh &lt;command&gt;"/]

    click gitHubCommand1 href "https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/github-commands.md#operations-for-github" "Go to GitHub section"

    click gitHubCommand2 href "https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/github-commands.md#operations-for-github" "Go to GitHub section"
end

subgraph Help
    direction LR

    helpCommand1[/"qatam help"/] ~~~ helpCommand2[/"qatam h"/] ~~~ helpCommand3[/"qatam"/]
end

%% Paths
Start(("Start")) mainL1@--> Qatam_Syntax
Qatam_Syntax mainL2@--> Windows
Qatam_Syntax mainL3@--> Git
Qatam_Syntax mainL4@--> GitHub
Qatam_Syntax mainL5@--> Help

mainL1@{ animate: true }
mainL2@{ animate: true }
mainL3@{ animate: true }
mainL4@{ animate: true }
mainL5@{ animate: true }


%% Windows
Windows windowsL1@--> windowsDecisionId1{"`Internet connection available?`"}

windowsDecisionId1 windowsL2@-- No --> windowsEnd(("End"))

windowsDecisionId1 windowsL3@-- Yes --> windowsId1[[Performing a Windows operation based on the command used]]
windowsId1 windowsL4@--> windowsEnd(("End"))

windowsL1@{ animate: true }
windowsL2@{ animate: true }
windowsL3@{ animate: true }
windowsL4@{ animate: true }


%% Git
Git gitL1@--> gitDecisionId1{"`Internet connection available?`"}
gitDecisionId1 gitL2@-- No --> gitEnd(("End"))
gitDecisionId1 gitL3@-- Yes --> gitId1[[Performing a Git operation based on the command used]]

gitId1 gitL4@--> gitEnd(("End"))

gitL1@{ animate: true }
gitL2@{ animate: true }
gitL3@{ animate: true }
gitL4@{ animate: true }


%% GitHub
GitHub gitHubL1@--> gitHubDecisionId1{"`Internet connection available?`"}
gitHubDecisionId1 gitHubL2@-- No --> gitHubEnd(("End"))
gitHubDecisionId1 gitHubL3@-- Yes --> gitHubId1[[Performing a GitHub operation based on the command used]]

gitHubId1 gitHubL4@--> gitHubEnd(("End"))

gitHubL1@{ animate: true }
gitHubL2@{ animate: true }
gitHubL3@{ animate: true }
gitHubL4@{ animate: true }


%% Help
Help helpL1@--> helpDecisionId1{"`Internet connection available?`"}
helpDecisionId1 helpL2@-- No --> helpEnd(("End"))
helpDecisionId1 helpL3@-- Yes (help, h) --> helpIOId1[/"`Instructional message: Display 'Qatam CLI' services & commands`"/]
helpDecisionId1 helpL4@-- Yes (qatam) --> helpIOId2[/"`Display 'Qatam CLI' logo`"/]

helpIOId1 helpL5@--> helpEnd(("End"))

helpIOId2 helpL6@--> helpDecisionId2{"`Is there a newer version available?`"}
helpDecisionId2 helpL7@-- No --> helpIOId3[/"`Informational message: Display 'Qatam CLI' terms`"/]
helpDecisionId2 helpL8@-- Yes --> helpIOId4[/"`Instructional message: How to update 'Qatam CLI'`"/]

helpIOId4 helpL9@--> helpIOId3

helpIOId3 helpL10@--> helpIOId1

helpL1@{ animate: true }
helpL2@{ animate: true }
helpL3@{ animate: true }
helpL4@{ animate: true }
helpL5@{ animate: true }
helpL6@{ animate: true }
helpL7@{ animate: true }
helpL8@{ animate: true }
helpL9@{ animate: true }
helpL10@{ animate: true }
```

## Prerequisites

### For **Qatam CLI** usage

1. **Windows** [**10**](https://www.microsoft.com/en-us/software-download/windows10)/[**11**](https://www.microsoft.com/en-us/software-download/windows11) **OS**

2. **WinGet**

   - The **WinGet** command-line tool is bundled with Windows 11 and modern versions of Windows 10 by default as the App Installer.

     - Check WinGet installation status / version:

       ```powershell
       winget -v
       ```

     - If it's not installed you may install it via [**Microsoft Store (Recommended)**](https://www.microsoft.com/p/app-installer/9nblggh4nns1) or see [**other solutions**](https://github.com/microsoft/winget-cli).

3. **PowerShell 7.4**

   - Check PowerShell 7.4 installation status:

     - Type in the _"Windows search box"_ **PowerShell 7**.

       - Alternatively, check by default **PowerShell 7** is installed in `C:\Program Files\PowerShell\7`.

     - Open **PowerShell 7** & type `$PSVersionTable.PSVersion` to check the version.

   - If it's not installed, you may install it via **WinGet CLI**:
     - Install the latest **PowerShell 7** version:
       ```powershell
       winget install --id Microsoft.PowerShell --source winget
       ```
     - Or see [**other solutions**](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4)

### For **Git** operations usage

- [**Winget**](#prerequisites)

### For **GitHub** operations usage

- **Git** (least **V 2.27.0**)

  - Check Git installation status / version:

    ```powershell
    git -v
    ```

- **GCM** (Git Credential Manager)
  - By default, with **Git V 2.27.0** & later, GCM is included.

> [!NOTE]
> Both **Git** & **GCM** can be installed using the **Qatam CLI**. Thus, you ONLY need to consider the **Qatam CLI** requirements.

## Install

1. Open PowerShell 7.4
2. Run the following:

   ```powershell
   Install-Module -Name qatam-cli
   ```

> [!NOTE]
> It will be installed under `"C:\Users\Your-User-Name\Documents\PowerShell\Modules"` or `"C:\Users\Your-User-Name\OneDrive\Documents\PowerShell\Modules"` directory.

## Update

1. Open PowerShell 7.4
2. Run the following:

   ```powershell
   Update-Module -Name qatam-cli
   ```

## Uninstall

1. Open PowerShell 7.4
2. Run the following:

   ```powershell
   Uninstall-Module -Name qatam-cli
   ```

## Usage

| Command                        | Description                                                           |
| :----------------------------- | --------------------------------------------------------------------- |
| `qatam [h \| help]` Or `qatam` | Display all **Qatam-CLI** [**services**](#list-of-qatam-cli-services) |
| `qatam <service> [h \| help]`  | Display all service's [**commands**](#list-of-qatam-cli-commands)     |
| `qatam <service> <command>`    | Execute the command                                                   |

## List of **Qatam CLI** services

| Command        | Description                  |
| :------------- | ---------------------------- |
| `w \| windows` | Manage Windows OS Operations |
| `g \| git`     | Manage Git Operations        |
| `gh \| github` | Manage GitHub Operations     |

## List of **Qatam CLI** commands

[Operations for Windows OS](https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/windows-commands.md#operations-for-windows-os)

[Operations for Git](https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/git-commands.md#operations-for-git)

[Operations for GitHub](https://github.com/AnasAlhwid/qatam-cli/blob/main/docs/github-commands.md#operations-for-github)

## Current status

This project is currently under development and testing. There are three main stages in progress: **_Windows OS_**, **_Git_**, and **_GitHub_**. Once these stages are completed, the CI/CD stage will begin, focusing on community support, bug fixes, user experience enhancements, new commands, and feature creation.

## Support

<a href="https://www.buymeacoffee.com/AnasAlhwid" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## License

[**GNU Affero General Public License v3.0**](https://github.com/AnasAlhwid/qatam-cli/blob/main/LICENSE)
