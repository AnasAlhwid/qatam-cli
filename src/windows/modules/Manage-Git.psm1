# Imports
Import-Module "$PSScriptRoot\Manage-Design.psm1" -Force

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

    Write-Output "Checking Git version..."
    Write-Output ""

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
        Write-Output ""
    }
    catch {
        $(Format-Shape `
                -M "!" `
                -TC "yellow" `
                -Str "Failed to find Git version." `
        )
        Write-Output $_.Exception.Message
    }
}

# Function: Check Git's updates
function Update-Git {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    Write-Output "Checking Git updates..."

    if ($PSCmdlet.ShouldProcess("Git", "Update Git using WinGet")) {
        Write-Output ""
        try {
            $(Format-Shape `
                    -M "*" `
                    -TC "blue" `
                    -Str "Please be patient this may take a bit :)" `
            )
            Write-Output ""

            # Fetching Git's updates using WinGet.
            winget upgrade --id Git.Git -e --source winget
            Write-Output ""
        }
        catch {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Failed to check Git updates." `
            )
            Write-Output $_.Exception.Message
        }
    }
    else {
        Write-Output ""
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Git update canceled." `
        )
        Write-Output ""
    }
}

# Function: Install Git
function Install-Git {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    Write-Output "Installing Git..."

    if ($PSCmdlet.ShouldProcess("Git", "Install Git using WinGet")) {
        Write-Output ""
        try {
            $(Format-Shape `
                    -M "*" `
                    -TC "blue" `
                    -Str "Please be patient this may take a bit :)" `
            )
            Write-Output ""

            # Install Git via: https://git-scm.com/download/win using WinGet.
            winget install --id Git.Git -e --source winget
            Write-Output ""
        }
        catch {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Failed to install Git." `
            )
            Write-Output $_.Exception.Message
        }
    }
    else {
        Write-Output ""
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Git installation canceled." `
        )
        Write-Output ""
    }
}

# Function: Uninstall Git
function Uninstall-Git {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param ()

    Write-Output "Uninstalling Git..."

    if ($PSCmdlet.ShouldProcess("Git", "Uninstall Git using WinGet")) {
        Write-Output ""
        try {
            $(Format-Shape `
                    -M "*" `
                    -TC "blue" `
                    -Str "Please be patient this may take a bit :)" `
            )
            Write-Output ""

            # Uninstalling Git using WinGet.
            winget uninstall --id Git.Git -e --source winget
            Write-Output ""
        }
        catch {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Failed to uninstall Git." `
            )
            Write-Output $_.Exception.Message
        }
    }
    else {
        Write-Output ""
        $(Format-Shape `
                -M "x" `
                -TC "red" `
                -Str "Git uninstallation canceled." `
        )
        Write-Output ""
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
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "System Operations (OS)" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "v $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") version" `
            -CT "|" `
            -Str "Check Git Version / installation status" `
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
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "Local Operations (Per Project) (Currently Under Development)" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "c $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") create" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Create Local Git Repository" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape `
            -M "m $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") mount" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Stage & Commit a Local Git Repository" `
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
                Write-Output ""
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
                    Write-Output ""
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "WinGet is Not installed. Visit: $(Format-Color -TC "gold" -Str "`e]8;;$urlInstallWinGet`e\qatam-cli/WinGet`e]8;;`e\.") to install it." `
                )
                Write-Output ""
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
                    Write-Output ""
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
                Write-Output ""
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
                    Write-Output ""
                }
            }
            else {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "WinGet is Not installed. Visit: $(Format-Color -TC "gold" -Str "`e]8;;$urlInstallWinGet`e\qatam-cli/WinGet`e]8;;`e\.") to install it." `
                )
                Write-Output ""
            }
        }
        { $_ -in @("help", "h", "") } {
            Show-GitHelp
            Write-Output ""
        }
        default {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Invalid command, run: $(Format-Color -TC "green" -Str "qatam git help") to see all Git commands." `
            )
            Write-Output ""
        }
    }
}

# Export the Main Entry Point function
Export-ModuleMember -Function Select-Git