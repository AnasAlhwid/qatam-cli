# Imports
Import-Module "$PSScriptRoot\Manage-Design.psm1" -Force
Import-Module "$PSScriptRoot\Manage-Windows.psm1" -Force

# Links:
$urlInstallWinGet = "https://github.com/AnasAlhwid/qatam-cli/blob/main/README.md#prerequisites"


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
    Rename the Local Git Repository's main branch
.INPUTS
    [[-Path] <String>]
.FUNCTIONALITY
    From the given PATH. Allow the user if wants to rename the Local Git Repository's main branch. Otherwise, keep it as the default name (main)
#>
function Set-LocalGitRepositoryBranchName {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path
    )

    # Check the local Git repository's main branch name.
    $mainBranchName = git -C $Path branch --format='%(refname:short)' --list main master

    # Display an information message.
    $(Format-Shape -T "-" -CT "*" -Str "Main Branch Name" -CTC "blue" -StrBox 1)
    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "1" `
            -CT "|" `
            -TC "blue" `
            -Str "Type a new $(Format-Color -TC "gold" -Str "NAME") to rename the main branch. Otherwise," `
            -F "$(Clear-Format -F "gold")" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)press $(Format-Color -TC "green" -Str "Enter") to keep the default name." `
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
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "The main branch name of your local Git repository is $(Format-Color -TC "gold" -Str "$mainBranchName")." `
            -F "$(Clear-Format -F "gold")" `
    )

    $(Format-Shape -T " " -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "blue")

    # Prompt the user to type the desired main branch name.
    $gitBranchName = $(Format-Shape `
            -M "-" `
            -TC "clear" `
            -WR 1 `
            -Str "Type the main branch NAME" `
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
                    -Str "The main branch successfully renamed to '$gitBranchName'." `
            )
        }
        else {
            Write-Output "" | Out-Default
            $(Format-Shape `
                    -M "x" `
                    -TC "red" `
                    -Str "Rename the main branch canceled." `
            )
        }
    }
    Write-Output "" | Out-Default
}

<#
.Synopsis
    Set the Local Git Repository's credential configuration
.INPUTS
    [[-Path] <String>]
.FUNCTIONALITY
    From the given PATH. Set the Local Git Repository's configuration of the "Username" & "E-mail"
#>
function Set-LocalGitRepositoryCredential {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path
    )

    # Display an information message.
    $(Format-Shape -T "-" -CT "*" -Str "Credential Configuration" -CTC "blue" -StrBox 1)
    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "2" `
            -CT "|" `
            -TC "blue" `
            -Str "Type a $(Format-Color -TC "gold" -Str "Username") for the local Git repository's credentials.$(Format-Color -TC "red" -Str "*")" `
            -F "$(Clear-Format -F @("gold", "red"))" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "3" `
            -CT "|" `
            -TC "blue" `
            -Str "Type a $(Format-Color -TC "gold" -Str "E-mail") for the local Git repository's credentials.$(Format-Color -TC "red" -Str "*")" `
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

    # Check the exestance of both Username & E-mail configuration of the Local Git Repository.
    $gitUsername = git -C $Path config --get user.name
    $gitEmail = git -C $Path config --get user.email

    # Both "Username" & "E-mail" are configured.
    if ($gitUsername -and $gitEmail) {

        Write-Output "" | Out-Default

        # Display an attention message.
        $(Format-Shape -T "-" -CT "*" -Str "Attention" -CTC "yellow" -StrBox 1)
        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "!" `
                -CT "|" `
                -TC "yellow" `
                -Str "The local Git repository credentials already configured." `
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

        Write-Output "" | Out-Default

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
                -Str "Add an $(Format-Color -TC "gold" -Str "$gitCredential") to the configured credentials" `
                -F "$(Clear-Format -F "gold")" `
        )
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

                    # Configure the credential for the user of the local Git repository.
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
        # Configure the Username for the user credentials of the local Git repository.
        git -C $Path config user.name $gitUsername

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
        # Configure the E-mail for the user credentials of the local Git repository.
        git -C $Path config user.email $gitEmail

        $(Format-Shape `
                -M "+" `
                -TC "green" `
                -Str "The credentials successfully configured." `
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
            -Str "Check Git Version / Installation Status" `
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
            -Str "Display Git Commands" `
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
            -M "bn $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") branch-name" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Rename the Main Branch of a Local Git Repository" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "cc $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") config-cred" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Configure the Local Git Repository's Credentials" `
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
    <Command>: version, v, update, upd, install, i, uninstall, uni, help, h
.OUTPUTS
    List of Git commands
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

                # Check the existence of a Local Git Repository in a given PATH.
                $doesGitExist = Get-LocalGitRepositoryStatus -Path $directoryPath

                if ($doesGitExist) {
                    # Construct the full PATH of the ".git" folder using the given PATH.
                    $gitDirectoryPath = Join-Path -Path $directoryPath -ChildPath ".git"

                    # The Local Git Repository exist in the given PATH.
                    Set-LocalGitRepositoryBranchName -Path $gitDirectoryPath
                }
                else {
                    # Display an missing message.
                    $(Format-Shape -T "-" -CT "*" -Str "Missing" -CTC "red" -StrBox 1)
                    $(Format-Shape -T " " -CT "|")

                    $(Format-Shape `
                            -M "!" `
                            -CT "|" `
                            -TC "yellow" `
                            -Str "No Local Git Repository was found in the specified path." `
                    )
                    $(Format-Shape `
                            -CT "|" `
                            -Str "$(" " * 4)Run: $(Format-Color -TC "green" -Str "qatam git branch-name") again with a valid path." `
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

                # Check the existence of a Local Git Repository in a given PATH.
                $doesGitExist = Get-LocalGitRepositoryStatus -Path $directoryPath

                if ($doesGitExist) {
                    # Construct the full PATH of the ".git" folder using the given PATH.
                    $gitDirectoryPath = Join-Path -Path $directoryPath -ChildPath ".git"

                    # The Local Git Repository exist in the given PATH.
                    Set-LocalGitRepositoryCredential -Path $gitDirectoryPath
                }
                else {
                    # Display an missing message.
                    $(Format-Shape -T "-" -CT "*" -Str "Missing" -CTC "red" -StrBox 1)
                    $(Format-Shape -T " " -CT "|")

                    $(Format-Shape `
                            -M "!" `
                            -CT "|" `
                            -TC "yellow" `
                            -Str "No Local Git Repository was found in the specified path." `
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