## Table of Content

- [Table of Content](#table-of-content)
- [Qatam's Windows OS Diagram](#qatams-windows-os-diagram)
- [Operations for Windows OS](#operations-for-windows-os)

## Qatam's Windows OS Diagram

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

subgraph Windows_Syntax
    direction LR

    WindowsSyntax1[/"qatam windows &lt;Command&gt;"/] ~~~ WindowsSyntax2[/"qatam w &lt;Command&gt;"/]
end

subgraph Get_Existing_Directory
    direction LR

    WindowsCommand5[/"qatam windows get-dir"/] ~~~ WindowsCommand6[/"qatam windows gdir"/]
end

subgraph Set_New_Directory
    direction LR

    WindowsCommand7[/"qatam windows create-dir"/] ~~~ WindowsCommand8[/"qatam windows cdir"/]
end

subgraph Windows_Help
    direction LR

    WindowsCommand9[/"qatam windows"/] ~~~ WindowsCommand10[/"qatam w"/] ~~~ WindowsCommand11[/"qatam windows help"/]  ~~~ WindowsCommand12[/"qatam w help"/]
end

Start(("Start")) mainL1@--> Windows_Syntax
Windows_Syntax mainL2@--> Get_Existing_Directory
Windows_Syntax mainL3@--> Set_New_Directory
Windows_Syntax mainL4@--> Windows_Help

mainL1@{ animate: true }
mainL2@{ animate: true }
mainL3@{ animate: true }
mainL4@{ animate: true }


%% Check Directory Existence.
Get_Existing_Directory checkDirectoryL1@--> checkDirectoryDecisionId1{"`Internet connection available?`"}
checkDirectoryDecisionId1 checkDirectoryL2@-- No --> checkDirectoryEnd(("End"))

checkDirectoryDecisionId1 checkDirectoryL3@-- Yes --> checkDirectoryDecisionId2{"`Enter a new path or stay in the current path?`"}
checkDirectoryDecisionId2 checkDirectoryL4@-- Stay --> checkDirectoryEnd
checkDirectoryDecisionId2 checkDirectoryL5@-- New --> checkDirectoryIOId1[/"`User input: Local directory path`"/]

checkDirectoryIOId1 checkDirectoryL6@--> checkDirectoryDecisionId3{"`Does the path exist locally?`"}
checkDirectoryDecisionId3 checkDirectoryL7@-- Yes --> checkDirectoryProcessId1["`Navigate to the local directory`"] checkDirectoryL8@--> checkDirectoryEnd
checkDirectoryDecisionId3 checkDirectoryL9@-- No --> checkDirectoryIOId2[/"`Informational message: Invalid local directory path`"/] checkDirectoryL10@--> checkDirectoryIOId1

checkDirectoryL1@{ animate: true }
checkDirectoryL2@{ animate: true }
checkDirectoryL3@{ animate: true }
checkDirectoryL4@{ animate: true }
checkDirectoryL5@{ animate: true }
checkDirectoryL6@{ animate: true }
checkDirectoryL7@{ animate: true }
checkDirectoryL8@{ animate: true }
checkDirectoryL9@{ animate: true }
checkDirectoryL10@{ animate: true }


%% Create a Directory.
Set_New_Directory SetDirectoryL1@--> setDirectoryDecisionId1{"`Internet connection available?`"}
setDirectoryDecisionId1 SetDirectoryL2@-- No --> setDirectoryEnd(("End"))

setDirectoryDecisionId1 SetDirectoryL3@-- Yes --> setDirectoryId1[[Performing a Windows OS operation 'get-dir']]
setDirectoryId1 SetDirectoryL4@--> setDirectoryDecisionId2{"`Create a new directory or stay in the current directory?`"}
setDirectoryDecisionId2 SetDirectoryL5@-- Stay --> setDirectoryProcessId1["`Navigate to the local directory`"] SetDirectoryL6@--> setDirectoryEnd
setDirectoryDecisionId2 SetDirectoryL7@-- Create --> setDirectoryIOId1[/"`User input: New directory name`"/]

setDirectoryIOId1 SetDirectoryL8@--> setDirectoryDecisionId3{"`Does the directory exist locally?`"}
setDirectoryDecisionId3 SetDirectoryL9@-- Yes --> setDirectoryIOId2[/"`Informational message: A directory with that name already exist`"/]
setDirectoryDecisionId3 SetDirectoryL10@-- No --> setDirectoryProcessId2["`Create a new directory locally`"]

setDirectoryProcessId2 SetDirectoryL11@--> setDirectoryProcessId1

setDirectoryIOId2 SetDirectoryL12@--> setDirectoryDecisionId4{"`Overwrite or continue with the existing local directory?`"}
setDirectoryDecisionId4 SetDirectoryL13@-- Continue --> setDirectoryProcessId1
setDirectoryDecisionId4 SetDirectoryL14@-- Overwrite --> gitCreateLocalRepoProcessId4["`Overwrite the existing local directory`"] SetDirectoryL15@--> setDirectoryProcessId1

SetDirectoryL1@{ animate: true }
SetDirectoryL2@{ animate: true }
SetDirectoryL3@{ animate: true }
SetDirectoryL4@{ animate: true }
SetDirectoryL5@{ animate: true }
SetDirectoryL6@{ animate: true }
SetDirectoryL7@{ animate: true }
SetDirectoryL8@{ animate: true }
SetDirectoryL9@{ animate: true }
SetDirectoryL10@{ animate: true }
SetDirectoryL11@{ animate: true }
SetDirectoryL12@{ animate: true }
SetDirectoryL13@{ animate: true }
SetDirectoryL14@{ animate: true }
SetDirectoryL15@{ animate: true }


%% Windows Help
Windows_Help WindowsHelpL1@--> windowsHelpDecisionId1{"`Internet connection available?`"}
windowsHelpDecisionId1 WindowsHelpL2@-- No --> windowsHelpEnd(("End"))
windowsHelpDecisionId1 WindowsHelpL3@-- Yes --> windowsHelpIOId1[/"`Instructional message: Display 'Windows OS' commands`"/] WindowsHelpL4@--> windowsHelpEnd

WindowsHelpL1@{ animate: true }
WindowsHelpL2@{ animate: true }
WindowsHelpL3@{ animate: true }
WindowsHelpL4@{ animate: true }
```

## Operations for Windows OS

**Note**: Commands marked with (\*) are planned for future release and are NOT accessible yet.

| Command                 | Description                       |
| :---------------------- | --------------------------------- |
| `gdir \| get-dir`       | Check if a local directory exists |
| `cdir \| create-dir`    | Create a local directory          |
| \* `ddir \| delete-dir` | Delete a local directory          |
| `h \| help`             | Display Windows OS commands       |
