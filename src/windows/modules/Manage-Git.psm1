# Imports
Import-Module "$PSScriptRoot\Manage-Design.psm1" -Force
Import-Module "$PSScriptRoot\Manage-Windows.psm1" -Force

# Links:
$urlInstallWinGet = "https://github.com/AnasAlhwid/qatam-cli/blob/main/README.md#prerequisites"
$urlGitRepositoryLayout = "https://git-scm.com/docs/gitrepository-layout"
$urlGitignore = "https://git-scm.com/docs/gitignore"
$urlGitattributes = "https://git-scm.com/docs/gitattributes"
$urlEnv = "https://dotenvx.com/docs/env-file"

# Function: Check WinGet installation status
function Get-WinGetInstallationStatus {
    try {
        <#
            - Attempt to get the WinGet version.
            - The output is redirected to $null using 2>$null to suppress any error messages.
        #>
        $wingetVersion = winget --version 2>$null

        # WinGet is installed.
        return $null -ne $wingetVersion
    }
    catch {
        # WinGet is NOT installed.
        return $false
    }
}

# Function: Check Git installation status
function Get-GitInstallationStatus {
    try {
        <#
            - Attempt to get the Git version.
            - The output is redirected to $null using 2>$null to suppress any error messages.
        #>
        $gitVersion = git --version 2>$null

        # Git is installed.
        return $null -ne $gitVersion
    }
    catch {
        # Git is NOT installed.
        return $false
    }
}

# Function: Check Git's version
function Get-GitVersion {

    Write-Output "Checking Git version..." | Out-Default
    Write-Output "" | Out-Default

    try {
        # Fetching Git's version.
        $gitVersion = git --version

        # Display the Git version to the user.
        $(Format-Shape -T "-" -CT "*" -Str "Info" -CTC "blue" -StrBox 1)
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "*" `
                -CT "|" `
                -TC "blue" `
                -Str "$gitVersion" `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "blue")
        Write-Output "" | Out-Default
    }
    catch {
        $(Format-Shape `
                -M "!" `
                -TC "yellow" `
                -Str "Failed to find Git version." `
        )
        Write-Output $_.Exception.Message | Out-Default
    }
}

# Function: Check Git's updates
function Update-Git {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    Write-Output "Checking Git updates..." | Out-Default

    if ($PSCmdlet.ShouldProcess("Git", "Update Git using WinGet")) {
        Write-Output "" | Out-Default
        try {
            $(Format-Shape `
                    -M "*" `
                    -TC "blue" `
                    -Str "Please be patient this may take a bit :)" `
            )
            Write-Output "" | Out-Default

            # Fetching Git's updates using WinGet.
            winget upgrade --id Git.Git -e --source winget
            Write-Output "" | Out-Default
        }
        catch {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Failed to check Git updates." `
            )
            Write-Output $_.Exception.Message | Out-Default
        }
    }
    else {
        Write-Output "" | Out-Default
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Git update canceled." `
        )
        Write-Output "" | Out-Default
    }
}

# Function: Install Git
function Install-Git {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    Write-Output "Installing Git..." | Out-Default

    if ($PSCmdlet.ShouldProcess("Git", "Install Git using WinGet")) {
        Write-Output "" | Out-Default
        try {
            $(Format-Shape `
                    -M "*" `
                    -TC "blue" `
                    -Str "Please be patient this may take a bit :)" `
            )
            Write-Output "" | Out-Default

            # Install Git via: https://git-scm.com/download/win using WinGet.
            winget install --id Git.Git -e --source winget
            Write-Output "" | Out-Default
        }
        catch {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Failed to install Git." `
            )
            Write-Output $_.Exception.Message | Out-Default
        }
    }
    else {
        Write-Output "" | Out-Default
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Git installation canceled." `
        )
        Write-Output "" | Out-Default
    }
}

# Function: Uninstall Git
function Uninstall-Git {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    Write-Output "Uninstalling Git..." | Out-Default

    if ($PSCmdlet.ShouldProcess("Git", "Uninstall Git using WinGet")) {
        Write-Output "" | Out-Default
        try {
            $(Format-Shape `
                    -M "*" `
                    -TC "blue" `
                    -Str "Please be patient this may take a bit :)" `
            )
            Write-Output "" | Out-Default

            # Uninstalling Git using WinGet.
            winget uninstall --id Git.Git -e --source winget
            Write-Output "" | Out-Default
        }
        catch {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Failed to uninstall Git." `
            )
            Write-Output $_.Exception.Message | Out-Default
        }
    }
    else {
        Write-Output "" | Out-Default
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Git uninstallation canceled." `
        )
        Write-Output "" | Out-Default
    }
}

<#
.Synopsis
    Check if a Local Git Repository exist on the given path
.INPUTS
    [[-Path] <String>]
.FUNCTIONALITY
    From the given PATH, check whether a '.git' folder exist or not
.OUTPUTS
    <Boolean>
#>
function Get-LocalGitRepositoryStatus {
    param (
        [string]$Path
    )

    # Construct the full PATH of the ".git" folder using the given PATH.
    $gitDirectoryPath = Join-Path -Path $Path -ChildPath ".git"

    # Check if the ".git" folder exists.
    if (Test-Path -Path $gitDirectoryPath) {

        # The ".git" folder exist.
        return $true
    }
    else {
        # The ".git" folder doesn't exist.
        return $false
    }
}

<#
.Synopsis
    Create a local Git repository
.INPUTS
    [[-Path] <String>]
    [[-Overwrite] <boolean>] = $false
.FUNCTIONALITY
    From the given PATH, create a local Git repository
#>
function Set-LocalGitRepository {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path,
        [boolean]$Overwrite = $false
    )

    if ($Overwrite -eq $true) {
        if ($PSCmdlet.ShouldProcess($Path, "Overwrite the local Git repository")) {

            # Construct the full PATH of the ".git" folder using the given PATH.
            $gitDirectoryPath = Join-Path -Path $Path -ChildPath ".git"

            # Check if the current path is in or under the directory being deleted.
            if ((Get-Location).Path -like "$gitDirectoryPath*") {
                # Move to parent or another safe directory
                Set-Location -Path ([System.IO.Directory]::GetParent($gitDirectoryPath).FullName)
            }

            # Delete the existing ".git" folder.
            Remove-Item -Path $gitDirectoryPath -Recurse -Force

            Write-Output "" | Out-Default
        }
        else {
            Write-Output "" | Out-Default
            $(Format-Shape `
                    -M "x" `
                    -TC "red" `
                    -Str "Overwrite the local Git repository canceled." `
            )

            Write-Output "" | Out-Default

            return
        }
    }

    # Display an informational message.
    $(Format-Shape -T "-" -CT "*" -Str "Local Git Repository Creation" -CTC "bright_magenta" -StrBox 1)
    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "The main branch will be created with the name $(Format-Color -TC "gold" -Str "main")." `
            -F "$(Clear-Format -F @("gold"))" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "For details about the Git repository folder layout $(Format-Color -TC "gold" -Str "`e]8;;$urlGitRepositoryLayout`e\click here`e]8;;`e\")." `
            -F "$(Clear-Format -F @("gold", "link"))$urlGitRepositoryLayout" `
    )

    $(Format-Shape -T " " -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")

    Write-Output "" | Out-Default

    <#
        - (git init): Initialize a local Git repository.
        - (-C $Path): Specifies the path where the Git command should run.
    #>
    git -C $Path init | Out-Null

    # (git branch -M "main"): Rename the main Git branch from "master" to "main". (Making it the default name).
    git -C $Path branch -M "main" | Out-Null

    if ($Overwrite -eq $true) {
        $(Format-Shape `
                -M "+" `
                -TC "green" `
                -Str "The local Git repository successfully overwritten." `
        )
    }
    else {
        $(Format-Shape `
                -M "+" `
                -TC "green" `
                -Str "The local Git repository successfully created." `
        )
    }
    Write-Output "" | Out-Default
}

<#
.Synopsis
    Create file(s) for the local Git repository's environment
.INPUTS
    [[-Path] <String>]
.FUNCTIONALITY
    From the given PATH, create file(s) that helps the local Git repository environment
#>
function Set-LocalGitRepositoryFile {

    # Suppress false positive because this function delegates the state-changing logic.
    [Diagnostics.CodeAnalysis.SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Delegates state-changing operations to another function that already uses ShouldProcess")]

    param (
        [string]$Path
    )

    # Display an informational message.
    $(Format-Shape -T "-" -CT "*" -Str "Git Environment File(s) Creation" -CTC "bright_magenta" -StrBox 1)
    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "^" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Choose the file $(Format-Color -TC "gold" -Str "number(s)") to create." `
            -F "$(Clear-Format -F "gold")" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)Choose multiple file $(Format-Color -TC "gold" -Str "numbers") separated by a $(Format-Color -TC "green" -Str "space") to create them." `
            -F "$(Clear-Format -F @("gold", "green"))" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)Otherwise, press $(Format-Color -TC "green" -Str "enter") to skip the file creation." `
            -F "$(Clear-Format -F "green")" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "1" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Create $(Format-Color -TC "gold" -Str "`e]8;;$urlGitignore`e\.gitignore`e]8;;`e\") file" `
            -F "$(Clear-Format -F @("gold", "link"))$urlGitignore" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "2" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Create $(Format-Color -TC "gold" -Str "`e]8;;$urlGitattributes`e\.gitattributes`e]8;;`e\") file" `
            -F "$(Clear-Format -F @("gold", "link"))$urlGitattributes" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "3" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Create $(Format-Color -TC "gold" -Str "`e]8;;$urlEnv`e\.env`e]8;;`e\") file" `
            -F "$(Clear-Format -F @("gold", "link"))$urlEnv" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "For details about each file purpose $(Format-Color -TC "green" -Str "click") on the file name." `
            -F "$(Clear-Format -F "green")" `
    )

    $(Format-Shape -T " " -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")


    # Prompt the user to select one or multiple file(s) to create.
    $gitFile = $(Format-Shape `
            -M "-" `
            -TC "clear" `
            -WR 1 `
            -Str "Type the file(s) number" `
    )
    Write-Output "" | Out-Default

    # When the "Enter" button is NOT pressed.
    if ($gitFile -ne "") {

        # Split the input by spaces
        $operationList = $gitFile -split "\s+"

        # A hashtable for storing only 1 value without any duplicates if presented.
        $processedInput = @{}

        foreach ($operation in $operationList) {

            <#
                - If a number is encountered for the first time, it's not yet in the hashtable, so it passes the check.

                - If a number is in the hashtable, it will not be stored again and will skip to the next iteration of the loop.
            #>
            if ($processedInput.ContainsKey($operation)) {
                continue
            }

            <#
                * Add a key-value pair to the $processedInput hashtable.

                - Storing each value for the first time as the following example:
                    ("1" = $true)
            #>
            $processedInput[$operation] = $true

            <#
                1. Get the PATH that the user wants to work on.
                2. Get the File name that the user wants to create.
                3. Provide the type of the desired creation (directory or file).

                - "Select-Windows" is a function imported from "$PSScriptRoot\Manage-Windows.psm1" file.
            #>
            switch ($operation) {
                '1' {
                    Select-Windows -Command "create-dir" -Path $Path -DirName ".gitignore" -ItemType "file"
                }
                '2' {
                    Select-Windows -Command "create-dir" -Path $Path -DirName ".gitattributes" -ItemType "file"
                }
                '3' {
                    Select-Windows -Command "create-dir" -Path $Path -DirName ".env" -ItemType "file"
                }
                default {
                    # Start from a fresh line after typing each command with a line divider.
                    Clear-CurrentContent -Option "div"

                    # Propmt the user to retype the choice.
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Invalid choice '$operation'." `
                    )

                    Write-Output "" | Out-Default
                }
            }
        }
    }
    else {
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Local Git repository environment file(s) creation canceled." `
        )

        Write-Output "" | Out-Default
    }
}

<#
.Synopsis
    Rename the local Git repository's main branch
.INPUTS
    [[-Path] <String>]
.FUNCTIONALITY
    From the given PATH, rename the local Git repository's main branch. Otherwise, keep it with the default name (main)
#>
function Set-LocalGitRepositoryBranchName {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path
    )

    <#
        Check the local Git repository's main branch name.
        - (-C $Path): Specifies the path where the Git command should run.
    #>
    $mainBranchName = git -C $Path branch --format='%(refname:short)' --list main master

    # Apply values based on the branch name.
    if ([string]::IsNullOrWhiteSpace($mainBranchName)) {
        $mainBranchName = "nameless"
        $mainBranchNameColor = "red"
        $mainBranchNameFormat = "red"
    }
    else {
        $mainBranchNameColor = "gold"
        $mainBranchNameFormat = "gold"
    }

    # Display an informational message.
    $(Format-Shape -T "-" -CT "*" -Str "Main Branch Name" -CTC "blue" -StrBox 1)
    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "1" `
            -CT "|" `
            -TC "blue" `
            -Str "Type a new $(Format-Color -TC "gold" -Str "name") to rename the main branch. Otherwise," `
            -F "$(Clear-Format -F "gold")" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)press $(Format-Color -TC "green" -Str "enter") to keep the default name." `
            -F "$(Clear-Format -F "green")" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "blue" `
            -Str "It's recommended to change the main branch name to $(Format-Color -TC "gold" -Str "main")." `
            -F "$(Clear-Format -F "gold")" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "blue" `
            -Str "Staging the repository at least once after creation is" `
    )

    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)required for the name to be applied." `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "The main branch name of the local Git repository is $(Format-Color -TC "$mainBranchNameColor" -Str "$mainBranchName")." `
            -F "$(Clear-Format -F $mainBranchNameFormat)" `
    )

    $(Format-Shape -T " " -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "blue")

    # Prompt the user to type the desired main branch name.
    $gitBranchName = $(Format-Shape `
            -M "-" `
            -TC "clear" `
            -WR 1 `
            -Str "Type the main branch name" `
    )

    if ($gitBranchName -ne "") {
        if ($PSCmdlet.ShouldProcess($Path, "Change the main branch name")) {
            Write-Output "" | Out-Default

            <#
                - (git branch -M $gitBranchName): Rename the main Git branch to the user's desired name.
                - (-C $Path): Specifies the path where the Git command should run.
            #>
            git -C $Path branch -M $gitBranchName

            $(Format-Shape `
                    -M "+" `
                    -TC "green" `
                    -Str "The local Git repository's main branch successfully renamed to '$gitBranchName'." `
            )
        }
        else {
            Write-Output "" | Out-Default
            $(Format-Shape `
                    -M "x" `
                    -TC "red" `
                    -Str "Rename the local Git repository's main branch canceled." `
            )
        }
    }
}

<#
.Synopsis
    Set the local Git repository's credential configuration
.INPUTS
    [[-Path] <String>]
.FUNCTIONALITY
    From the given PATH. Set the local Git repository's configuration of the "Username" & "E-mail"
#>
function Set-LocalGitRepositoryCredential {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path
    )

    <#
        Check the existence of both Username & E-mail configuration of the local Git repository.
        - (-C $Path): Specifies the path where the Git command should run.
        - (config): Read and write Git configuration settings (like user info, aliases, settings, etc.).
        - (--get): Retrieve the value of a specific configuration setting.
    #>
    $gitUsername = git -C $Path config --get user.name
    $gitEmail = git -C $Path config --get user.email

    # Both "Username" & "E-mail" are configured.
    if ($gitUsername -and $gitEmail) {

        # Display an attention message.
        $(Format-Shape -T "-" -CT "*" -Str "Attention" -CTC "yellow" -StrBox 1)
        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "!" `
                -CT "|" `
                -TC "yellow" `
                -Str "The local Git repository credentials are already configured." `
        )

        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "*" `
                -CT "|" `
                -TC "blue" `
                -Str "Username: $gitUsername" `
        )

        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "*" `
                -CT "|" `
                -TC "blue" `
                -Str "E-mail: $gitEmail" `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "yellow")

        Write-Output "" | Out-Default

        # Display a choice message.
        $(Format-Shape -T "-" -CT "*" -Str "Choice" -CTC "bright_magenta" -StrBox 1)
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "^" `
                -CT "|" `
                -TC "bright_magenta" `
                -Str "What would you like to do?" `
        )
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "1" `
                -CT "|" `
                -TC "bright_magenta" `
                -Str "Continue with the configured credentials" `
        )
        $(Format-Shape `
                -M "2" `
                -CT "|" `
                -TC "bright_magenta" `
                -Str "Overwrite the configured credentials" `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")

        # Loop until the user enters a valid operation number.
        $loopVar = $true
        while ($loopVar) {

            # Prompt the user to type the desired operation number.
            $choice = $(Format-Shape `
                    -M "^" `
                    -TC "bright_magenta" `
                    -WR 1 `
                    -Str "Type the operation number" `
            )
            Write-Output "" | Out-Default

            switch ($choice) {
                "1" {
                    # Break the "while" loop.
                    $loopVar = $false
                }
                "2" {
                    # Loop until the user enters a non-empty Username.
                    while ($true) {
                        # Prompt the user to type the desired Username.
                        $gitUsername = $(Format-Shape `
                                -M "-" `
                                -TC "clear" `
                                -WR 1 `
                                -Str "Type the Username" `
                        )
                        Write-Output "" | Out-Default

                        if ($gitUsername -eq "") {
                            $(Format-Shape `
                                    -M "!" `
                                    -TC "yellow" `
                                    -Str "Username cannot be empty, please try again." `
                            )
                            Write-Output "" | Out-Default

                            continue
                        }
                        break
                    }

                    # Loop until the user enters a non-empty E-mail.
                    while ($true) {
                        # Prompt the user to type the desired E-mail.
                        $gitEmail = $(Format-Shape `
                                -M "-" `
                                -TC "clear" `
                                -WR 1 `
                                -Str "Type the E-mail" `
                        )
                        Write-Output "" | Out-Default

                        if ($gitEmail -eq "") {
                            $(Format-Shape `
                                    -M "!" `
                                    -TC "yellow" `
                                    -Str "E-mail cannot be empty, please try again." `
                            )
                            Write-Output "" | Out-Default

                            continue
                        }
                        break
                    }

                    if ($PSCmdlet.ShouldProcess($Path, "Overwrite the configured credentials")) {
                        Write-Output "" | Out-Default

                        # Configure both Username & E-mail for the user credentials of the local Git repository.
                        git -C $Path config user.name $gitUsername
                        git -C $Path config user.email $gitEmail

                        $(Format-Shape `
                                -M "+" `
                                -TC "green" `
                                -Str "The configured credentials successfully overwritten." `
                        )
                        Write-Output "" | Out-Default

                        # Break the "while" loop.
                        $loopVar = $false
                    }
                    else {
                        Write-Output "" | Out-Default
                        $(Format-Shape `
                                -M "x" `
                                -TC "red" `
                                -Str "Overwrite the configured credentials canceled." `
                        )
                        Write-Output "" | Out-Default

                        # Break the "while" loop.
                        $loopVar = $false
                    }
                }
                Default {
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Invalid choice, please try again." `
                    )
                    Write-Output "" | Out-Default
                }
            }
        }
    }
    # Only one of "Username" or "E-mail" is configured.
    elseif (($gitUsername -and ($null -eq $gitEmail)) -or ($gitEmail -and ($null -eq $gitUsername))) {

        # If the E-mail is not configured.
        if ($null -eq $gitEmail) {
            $gitValidCredential = "Username"
            $gitValidCredentialValue = $gitUsername

            $gitCredential = "E-mail"
            $gitUserCredential = "email"
        }
        # If the Username is not configured.
        elseif ($null -eq $gitUsername) {
            $gitValidCredential = "E-mail"
            $gitValidCredentialValue = $gitEmail

            $gitCredential = "Username"
            $gitUserCredential = "name"
        }

        # Display an attention message.
        $(Format-Shape -T "-" -CT "*" -Str "Attention" -CTC "yellow" -StrBox 1)
        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "!" `
                -CT "|" `
                -TC "yellow" `
                -Str "The $(Format-Color -TC "gold" -Str "$gitValidCredential") is configured for the local Git repository as:" `
                -F "$(Clear-Format -F "gold")" `
        )
        $(Format-Shape `
                -CT "|" `
                -Str "$(" " * 4)'$(Format-Color -TC "gold" -Str "$gitValidCredentialValue")'" `
                -F "$(Clear-Format -F "gold")" `
        )

        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "!" `
                -CT "|" `
                -TC "yellow" `
                -Str "The $(Format-Color -TC "gold" -Str "$gitCredential") is $(Format-Color -TC "red" -Str "not") configured for the local Git repository." `
                -F "$(Clear-Format -F @("gold", "red"))" `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "yellow")

        Write-Output "" | Out-Default

        # Display a choice message.
        $(Format-Shape -T "-" -CT "*" -Str "Choice" -CTC "bright_magenta" -StrBox 1)
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "^" `
                -CT "|" `
                -TC "bright_magenta" `
                -Str "What would you like to do?" `
        )
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "1" `
                -CT "|" `
                -TC "bright_magenta" `
                -Str "Set the $(Format-Color -TC "gold" -Str "$gitCredential") for the configured credentials" `
                -F "$(Clear-Format -F "gold")" `
        )

        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "2" `
                -CT "|" `
                -TC "bright_magenta" `
                -Str "Overwrite the configured credentials with new $(Format-Color -TC "gold" -Str "Username") & $(Format-Color -TC "gold" -Str "E-mail")" `
                -F "$(Clear-Format -F @("gold", "gold"))" `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")

        # Loop until the user enters a valid operation number.
        $loopVar = $true
        while ($loopVar) {

            # Prompt the user to type the desired operation number.
            $choice = $(Format-Shape `
                    -M "^" `
                    -TC "bright_magenta" `
                    -WR 1 `
                    -Str "Type the operation number" `
            )
            Write-Output "" | Out-Default

            switch ($choice) {
                "1" {
                    # Loop until the user enters a non-empty credential.
                    while ($true) {
                        # Prompt the user to type the desired credential.
                        $gitUserInfo = $(Format-Shape `
                                -M "-" `
                                -TC "clear" `
                                -WR 1 `
                                -Str "Type the $gitCredential" `
                        )
                        Write-Output "" | Out-Default

                        if ($gitUserInfo -eq "") {
                            $(Format-Shape `
                                    -M "!" `
                                    -TC "yellow" `
                                    -Str "$gitCredential cannot be empty, please try again." `
                            )
                            Write-Output "" | Out-Default

                            continue
                        }
                        break
                    }

                    # Configure the user credential for the local Git repository.
                    git -C $Path config user.$gitUserCredential $gitUserInfo

                    $(Format-Shape `
                            -M "+" `
                            -TC "green" `
                            -Str "The $gitCredential for the credentials successfully configured." `
                    )
                    Write-Output "" | Out-Default

                    # Break the "while" loop.
                    $loopVar = $false
                }
                "2" {
                    # Loop until the user enters a non-empty Username.
                    while ($true) {
                        # Prompt the user to type the desired Username.
                        $gitUsername = $(Format-Shape `
                                -M "-" `
                                -TC "clear" `
                                -WR 1 `
                                -Str "Type the Username" `
                        )
                        Write-Output "" | Out-Default

                        if ($gitUsername -eq "") {
                            $(Format-Shape `
                                    -M "!" `
                                    -TC "yellow" `
                                    -Str "Username cannot be empty, please try again." `
                            )
                            Write-Output "" | Out-Default

                            continue
                        }
                        break
                    }

                    # Loop until the user enters a non-empty E-mail.
                    while ($true) {
                        # Prompt the user to type the desired E-mail.
                        $gitEmail = $(Format-Shape `
                                -M "-" `
                                -TC "clear" `
                                -WR 1 `
                                -Str "Type the E-mail" `
                        )
                        Write-Output "" | Out-Default

                        if ($gitEmail -eq "") {
                            $(Format-Shape `
                                    -M "!" `
                                    -TC "yellow" `
                                    -Str "E-mail cannot be empty, please try again." `
                            )
                            Write-Output "" | Out-Default

                            continue
                        }
                        break
                    }

                    if ($PSCmdlet.ShouldProcess($Path, "Overwrite the configured credentials")) {
                        Write-Output "" | Out-Default

                        # Configure both Username & E-mail for the user credentials of the local Git repository.
                        git -C $Path config user.name $gitUsername
                        git -C $Path config user.email $gitEmail

                        $(Format-Shape `
                                -M "+" `
                                -TC "green" `
                                -Str "The configured credentials successfully overwritten." `
                        )
                        Write-Output "" | Out-Default

                        # Break the "while" loop.
                        $loopVar = $false
                    }
                    else {
                        Write-Output "" | Out-Default
                        $(Format-Shape `
                                -M "x" `
                                -TC "red" `
                                -Str "Overwrite the configured credentials canceled." `
                        )
                        Write-Output "" | Out-Default

                        # Break the "while" loop.
                        $loopVar = $false
                    }
                }
                Default {
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Invalid choice, please try again." `
                    )
                    Write-Output "" | Out-Default
                }
            }
        }
    }
    # Both "Username" & "E-mail" are NOT configured.
    else {
        # Display an informational message.
        $(Format-Shape -T "-" -CT "*" -Str "Credential Configuration" -CTC "blue" -StrBox 1)
        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "1" `
                -CT "|" `
                -TC "blue" `
                -Str "Type a $(Format-Color -TC "gold" -Str "Username") for the local Git repository's credentials.$(Format-Color -TC "red" -Str "*")" `
                -F "$(Clear-Format -F @("gold", "red"))" `
        )

        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "2" `
                -CT "|" `
                -TC "blue" `
                -Str "Type an $(Format-Color -TC "gold" -Str "E-mail") for the local Git repository's credentials.$(Format-Color -TC "red" -Str "*")" `
                -F "$(Clear-Format -F @("gold", "red"))" `
        )

        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "!" `
                -CT "|" `
                -TC "yellow" `
                -Str "($(Format-Color -TC "red" -Str "*")) Mandatory fields." `
                -F "$(Clear-Format -F "red")" `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "blue")


        # Loop until the user enters a non-empty Username.
        while ($true) {
            # Prompt the user to type the desired Username.
            $gitUsername = $(Format-Shape `
                    -M "-" `
                    -TC "clear" `
                    -WR 1 `
                    -Str "Type the Username" `
            )
            Write-Output "" | Out-Default

            if ($gitUsername -eq "") {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Username cannot be empty, please try again." `
                )
                Write-Output "" | Out-Default

                continue
            }
            break
        }

        # Loop until the user enters a non-empty E-mail.
        while ($true) {
            # Prompt the user to type the desired E-mail.
            $gitEmail = $(Format-Shape `
                    -M "-" `
                    -TC "clear" `
                    -WR 1 `
                    -Str "Type the E-mail" `
            )
            Write-Output "" | Out-Default

            if ($gitEmail -eq "") {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "E-mail cannot be empty, please try again." `
                )
                Write-Output "" | Out-Default

                continue
            }
            break
        }

        # Configure the Username for the user credentials of the local Git repository.
        git -C $Path config user.name $gitUsername

        # Configure the E-mail for the user credentials of the local Git repository.
        git -C $Path config user.email $gitEmail

        $(Format-Shape `
                -M "+" `
                -TC "green" `
                -Str "Local Git repository credentials were configured successfully" `
        )
        Write-Output "" | Out-Default
    }
}

# Function: Display list of Git commands
function Show-GitHelp {

    # Display Git commands to the user.
    $(Format-Shape -T "-" -CT "*" -Str "Git Commands" -CTC "bright_magenta" -StrBox 1)
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "Usage" `
            -CT "|" `
            -TC "green" `
            -Str "qatam git <command>" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape -T "-" -CT "|")
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "Command" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Description" `
    )

    $(Format-Shape -CT "|")
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "blue" `
            -Str "System Operations (OS)" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "v $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") version" `
            -CT "|" `
            -Str "Check Git version / Installation status" `
            -TC "bright_magenta" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "upd $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") update" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Update Git" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "i $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") install" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Install Git" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "uni $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") uninstall" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Uninstall Git" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "h $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") help" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Display Git commands" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape -CT "|")
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "blue" `
            -Str "Local Operations (Project)" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "c $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") create" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Create a new local Git repository & environment file(s)" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "bn $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") branch-name" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Rename the local Git repository's main branch" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "cc $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") config-cred" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Configure the local Git repository's credentials" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")
}

<#
.Synopsis
    Main Entry Point for the Git operations that manages the entire Git commands
.EXAMPLE
    qatam git
.EXAMPLE
    qatam git [[-Command] <String>]
.INPUTS
    <Command>: version, v, update, upd, install, i, uninstall, uni, create, c, branch-name, bn, config-cred, cc, help, h
.OUTPUTS
    Git commands outputs
.FUNCTIONALITY
    Manage the Git workflow
#>
function Select-Git {
    param (
        [string]$Command
    )

    switch ($Command.ToLower()) {
        { $_ -in @("version", "v") } {
            # A function that checks Git installation status.
            if (Get-GitInstallationStatus) {

                # A function that checks Git version.
                Get-GitVersion
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Git is Not installed. Run: $(Format-Color -TC "green" -Str "qatam git install") to install it." `
                )
                Write-Output "" | Out-Default
            }
        }
        { $_ -in @("update", "upd") } {
            # A function that checks WinGet installation status.
            if (Get-WinGetInstallationStatus) {
                # A function that checks Git installation status.
                if (Get-GitInstallationStatus) {

                    # A function that update Git.
                    Update-Git
                }
                else {
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Git is Not installed. Run: $(Format-Color -TC "green" -Str "qatam git install") to install it." `
                    )
                    Write-Output "" | Out-Default
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "WinGet is Not installed. Visit: $(Format-Color -TC "gold" -Str "`e]8;;$urlInstallWinGet`e\qatam-cli/WinGet`e]8;;`e\.") to install it." `
                )
                Write-Output "" | Out-Default
            }
        }
        { $_ -in @("install", "i") } {
            # A function that checks WinGet installation status.
            if (Get-WinGetInstallationStatus) {
                # A function that checks Git installation status.
                if (Get-GitInstallationStatus) {
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Git is installed. Run: $(Format-Color -TC "green" -Str "qatam git help") to see other Git commands." `
                    )
                    Write-Output "" | Out-Default
                }
                else {
                    # A function that install Git.
                    Install-Git
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "WinGet is Not installed. Visit: $(Format-Color -TC "gold" -Str "`e]8;;$urlInstallWinGet`e\qatam-cli/WinGet`e]8;;`e\.") to install it." `
                )
                Write-Output "" | Out-Default
            }
        }
        { $_ -in @("uninstall", "uni") } {
            # A function that checks WinGet installation status.
            if (Get-WinGetInstallationStatus) {
                # A function that checks Git installation status.
                if (Get-GitInstallationStatus) {

                    # A function that uninstall Git.
                    Uninstall-Git
                }
                else {
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Git is Not installed. Run: $(Format-Color -TC "green" -Str "qatam git help") to see other Git commands." `
                            -F $(Clear-Format -F "green") `
                    )
                    Write-Output "" | Out-Default
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "WinGet is Not installed. Visit: $(Format-Color -TC "gold" -Str "`e]8;;$urlInstallWinGet`e\qatam-cli/WinGet`e]8;;`e\.") to install it." `
                )
                Write-Output "" | Out-Default
            }
        }
        { $_ -in @("create", "c") } {
            # A function that checks Git installation status.
            if (Get-GitInstallationStatus) {
                <#
                    1. Get the PATH that the user wants to work on.

                    - "Select-Windows" is a function imported from "$PSScriptRoot\Manage-Windows.psm1" file.
                #>
                $directoryPath = Select-Windows -Command "get-dir" -DoReturn $true

                # Check the existence of a local Git repository in the given PATH.
                $doesGitExist = Get-LocalGitRepositoryStatus -Path $directoryPath

                if ($doesGitExist) {
                    # Start from a fresh line after typing each command with a line divider.
                    Clear-CurrentContent -Option "div"

                    # Display an attention message.
                    $(Format-Shape -T "-" -CT "*" -Str "Attention" -CTC "yellow" -StrBox 1)
                    $(Format-Shape -T " " -CT "|")

                    $(Format-Shape `
                            -M "!" `
                            -CT "|" `
                            -TC "yellow" `
                            -Str "A local Git repository already exist in the specified path." `
                    )

                    $(Format-Shape -T " " -CT "|")
                    $(Format-Shape -T "-" -CT "*" -CTC "yellow")

                    Write-Output "" | Out-Default

                    # Display a choice message.
                    $(Format-Shape -T "-" -CT "*" -Str "Choice" -CTC "bright_magenta" -StrBox 1)
                    $(Format-Shape -CT "|")

                    $(Format-Shape `
                            -M "^" `
                            -CT "|" `
                            -TC "bright_magenta" `
                            -Str "What would you like to do?" `
                    )
                    $(Format-Shape -CT "|")

                    $(Format-Shape `
                            -M "1" `
                            -CT "|" `
                            -TC "bright_magenta" `
                            -Str "Continue with the existing local Git repository" `
                    )
                    $(Format-Shape `
                            -M "2" `
                            -CT "|" `
                            -TC "bright_magenta" `
                            -Str "Overwrite the existing local Git repository" `
                    )

                    $(Format-Shape -T " " -CT "|")
                    $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")

                    # Loop until the user enters a valid operation number.
                    $loopVar = $true
                    while ($loopVar) {

                        # Prompt the user to type the desired operation number.
                        $choice = $(Format-Shape `
                                -M "^" `
                                -TC "bright_magenta" `
                                -WR 1 `
                                -Str "Type the operation number" `
                        )
                        Write-Output "" | Out-Default

                        switch ($choice) {
                            "1" {
                                # Start from a fresh line after typing each command with a line divider.
                                Clear-CurrentContent -Option "div"

                                # Create new file(s) in the given PATH.
                                Set-LocalGitRepositoryFile -Path $directoryPath

                                $loopVar = $false
                            }
                            "2" {
                                # Start from a fresh line after typing each command with a line divider.
                                Clear-CurrentContent -Option "div"

                                # Create new file(s) in the given PATH.
                                Set-LocalGitRepository -Path $directoryPath -Overwrite $true

                                # Create new file(s) in the given PATH.
                                Set-LocalGitRepositoryFile -Path $directoryPath

                                $loopVar = $false
                            }
                            default {
                                # Propmt the user to retype the choice.
                                $(Format-Shape `
                                        -M "!" `
                                        -TC "yellow" `
                                        -Str "Invalid choice, please try again." `
                                )

                                Write-Output "" | Out-Default
                            }
                        }
                    }
                }
                else {
                    # Start from a fresh line after typing each command with a line divider.
                    Clear-CurrentContent -Option "div"

                    # Create a new local Git repository in the given PATH.
                    Set-LocalGitRepository -Path $directoryPath

                    # Create new file(s) in the given PATH.
                    Set-LocalGitRepositoryFile -Path $directoryPath
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Git is Not installed. Run: $(Format-Color -TC "green" -Str "qatam git help") to see other Git commands." `
                        -F $(Clear-Format -F "green") `
                )
                Write-Output "" | Out-Default
            }
        }
        { $_ -in @("branch-name", "bn") } {
            # A function that checks Git installation status.
            if (Get-GitInstallationStatus) {
                <#
                    1. Get the PATH that the user wants to work on.

                    - "Select-Windows" is a function imported from "$PSScriptRoot\Manage-Directory.psm1" file.
                #>
                $directoryPath = Select-Windows -Command "get-dir" -DoReturn $true

                # Start from a fresh line after typing each command with a line divider.
                Clear-CurrentContent -Option "div"

                # Check the existence of a local Git repository in a given PATH.
                $doesGitExist = Get-LocalGitRepositoryStatus -Path $directoryPath

                # If a local Git repository exist in the given PATH.
                if ($doesGitExist) {
                    # Construct the full PATH of the ".git" folder using the given PATH.
                    $gitDirectoryPath = Join-Path -Path $directoryPath -ChildPath ".git"

                    # Rename the local Git repository's main branch.
                    Set-LocalGitRepositoryBranchName -Path $gitDirectoryPath
                }
                # If a local Git repository doesn't exist in the given PATH.
                else {
                    # Display a missing message.
                    $(Format-Shape -T "-" -CT "*" -Str "Missing" -CTC "red" -StrBox 1)
                    $(Format-Shape -T " " -CT "|")

                    $(Format-Shape `
                            -M "!" `
                            -CT "|" `
                            -TC "yellow" `
                            -Str "No local Git repository was found in the specified path." `
                    )
                    $(Format-Shape `
                            -CT "|" `
                            -Str "$(" " * 4)Run: $(Format-Color -TC "green" -Str "qatam git branch-name") again with a valid path." `
                            -F $(Clear-Format -F "green") `
                    )

                    $(Format-Shape -T " " -CT "|")
                    $(Format-Shape -T "-" -CT "*" -CTC "red")
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Git is Not installed. Run: $(Format-Color -TC "green" -Str "qatam git help") to see other Git commands." `
                        -F $(Clear-Format -F "green") `
                )
            }
            Write-Output "" | Out-Default
        }
        { $_ -in @("config-cred", "cc") } {
            # A function that checks Git installation status.
            if (Get-GitInstallationStatus) {
                <#
                    1. Get the PATH that the user wants to work on.

                    - "Select-Windows" is a function imported from "$PSScriptRoot\Manage-Directory.psm1" file.
                #>
                $directoryPath = Select-Windows -Command "get-dir" -DoReturn $true

                # Start from a fresh line after typing each command with a line divider.
                Clear-CurrentContent -Option "div"

                # Check the existence of a local Git repository in the given path.
                $doesGitExist = Get-LocalGitRepositoryStatus -Path $directoryPath

                if ($doesGitExist) {
                    # Construct the full path of the ".git" folder using the given path.
                    $gitDirectoryPath = Join-Path -Path $directoryPath -ChildPath ".git"

                    # Set the local Git repository's credentials.
                    Set-LocalGitRepositoryCredential -Path $gitDirectoryPath
                }
                else {
                    # Display a missing message.
                    $(Format-Shape -T "-" -CT "*" -Str "Missing" -CTC "red" -StrBox 1)
                    $(Format-Shape -T " " -CT "|")

                    $(Format-Shape `
                            -M "!" `
                            -CT "|" `
                            -TC "yellow" `
                            -Str "No local Git repository was found in the specified path." `
                    )
                    $(Format-Shape `
                            -CT "|" `
                            -Str "$(" " * 4)Run: $(Format-Color -TC "green" -Str "qatam git config-cred") again with a valid path." `
                            -F $(Clear-Format -F "green") `
                    )

                    $(Format-Shape -T " " -CT "|")
                    $(Format-Shape -T "-" -CT "*" -CTC "red")
                    Write-Output "" | Out-Default
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Git is Not installed. Run: $(Format-Color -TC "green" -Str "qatam git help") to see other Git commands." `
                        -F $(Clear-Format -F "green") `
                )
                Write-Output "" | Out-Default
            }
        }
        { $_ -in @("help", "h", "") } {
            Show-GitHelp

            Write-Output "" | Out-Default
        }
        default {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Invalid command, run: $(Format-Color -TC "green" -Str "qatam git help") to see all Git commands." `
            )
            Write-Output "" | Out-Default
        }
    }
}

# Export the Main Entry Point function
Export-ModuleMember -Function Select-Git