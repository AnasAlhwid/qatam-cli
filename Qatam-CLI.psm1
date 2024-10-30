# Imports
Import-Module "$PSScriptRoot\src\windows\modules\Manage-Design.psm1" -Force
Import-Module "$PSScriptRoot\src\windows\modules\Manage-Git.psm1" -Force
Import-Module "$PSScriptRoot\src\windows\modules\Manage-Windows.psm1" -Force

# Links
$urlQatamCLIGitHubReleases = "https://github.com/AnasAlhwid/qatam-cli/releases"
$urlQatamCLITerms = "https://github.com/AnasAlhwid/qatam-cli/blob/main/README.md#license"

# Notes
<#
    - Both "Format-Shape & Format-Color" are custom functions for terminal design & can be found at "qatam-cli\src\windows\modules\Manage-Design.psm1".
#>


# Function: Check the user's internet connection
function Test-InternetConnection {
    try {
        # Send a request to a known reliable website.
        $internetConnection = Invoke-WebRequest -Uri "https://www.google.com" -UseBasicParsing -TimeoutSec 5

        # Available internet connection. (Return 200)
        $StatusCode = $internetConnection.StatusCode
    }
    catch {
        # Unavailable internet connection. (Return $null)
        $StatusCode = $_.Exception.Response.StatusCode.value__
    }
    return $StatusCode
}

# Function: Compare versions of "Qatam CLI" between local & PowerShell Gallery
function Compare-QatamCLIVersion {
    try {
        # Get the local "Qatam-CLI" module.
        $localModulePath = Get-Module -Name 'Qatam-CLI'

        # Get the PowerShell Gallery "Qatam-CLI" module.
        $OnlineModulePath = Find-Module -Name 'Qatam-CLI'

        if ($localModulePath.Version -lt $OnlineModulePath.Version) {

            $(Format-Shape -T "-" -CT "*" -Str "Update" -CTC "green" -StrBox 1)
            $(Format-Shape -CT "|")

            $(Format-Shape `
                    -M "!" `
                    -CT "|" `
                    -TC "yellow" `
                    -Str "New update is available for $(Format-Color -TC "gold" -Str "Qatam CLI")" `
                    -F "$(Clear-Format -F "gold")" `
            )
            $(Format-Shape -CT "|")

            $(Format-Shape `
                    -M "!" `
                    -CT "|" `
                    -TC "yellow" `
                    -Str "Current version: $(Format-Color -TC "red" -Str "$($localModulePath.Version)") | New version: $(Format-Color -TC "green" -Str "$($OnlineModulePath.Version)")" `
                    -F $(Clear-Format -F @("red", "green")) `
            )
            $(Format-Shape -CT "|")

            $(Format-Shape `
                    -M "!" `
                    -CT "|" `
                    -TC "yellow" `
                    -Str "To update, run: $(Format-Color -TC "green" -Str "Update-Module -Name Qatam-CLI")" `
                    -F $(Clear-Format -F "green") `
            )

            $(Format-Shape `
                    -M "!" `
                    -CT "|" `
                    -TC "yellow" `
                    -Str "For update details, visit: $(Format-Color -TC "gold" -Str "`e]8;;$urlQatamCLIGitHubReleases`e\Qatam CLI`e]8;;`e\")" `
                    -F "$(Clear-Format -F @("gold", "link"))$urlQatamCLIGitHubReleases" `
            )

            $(Format-Shape -CT "|")
            $(Format-Shape -T "-" -CT "*" -CTC "green")
            Write-Output "" | Out-Default
        }
    }
    catch {
        Write-Output $_.Exception.Message | Out-Default
    }
}

# Function: Display a welcom message to the brothers & sisters with "Qatam CLI" terms
function Show-QatamCLITerm {

    $(Format-Shape -T "-" -CT "*" -Str "Terms" -CTC "green" -StrBox 1)
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 28)Alsalam Alaykum!" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "green" `
            -Str "$(Format-Color -TC "gold" -Str "Qatam CLI") is a tool that combines commands from various services into" `
            -F "$(Clear-Format -F "gold")" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)a single CLI, allowing developers to focus on their actual work and" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)increasing productivity." `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "green" `
            -Str "Please read the following $(Format-Color -TC "green" -Str "`e]8;;$urlQatamCLITerms`e\Terms`e]8;;`e\")." `
            -F "$(Clear-Format -F @("green", "link"))$urlQatamCLITerms" `
    )

    $(Format-Shape -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "green")
    Write-Output "" | Out-Default
}

# Function: Display list of services with help command
function Show-QatamCLIHelp {

    $(Format-Shape -T "-" -CT "*" -Str "Services & Commands" -CTC "bright_magenta" -StrBox 1)
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "Usage" `
            -CT "|" `
            -TC "green" `
            -Str "qatam <service> <command>" `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape -T "-" -CT "|")
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "Service $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") Command" `
            -CT "|" `
            -TC "gold" `
            -Str "Description" `
            -F $(Clear-Format -F @("bright_magenta", "clear", "gold")) `
    )

    $(Format-Shape -CT "|")
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "w $(Format-Color -TC "clear" -Str "|" -NC "gold") windows" `
            -CT "|" `
            -TC "gold" `
            -Str "Windows OS Service" `
            -F $(Clear-Format -F "gold") `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "g $(Format-Color -TC "clear" -Str "|" -NC "gold") git" `
            -CT "|" `
            -TC "gold" `
            -Str "Git Service" `
            -F $(Clear-Format -F "gold") `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "g $(Format-Color -TC "clear" -Str "|" -NC "gold") github" `
            -CT "|" `
            -TC "gold" `
            -Str "GitHub Service (Currently Under Development)" `
            -F $(Clear-Format -F "gold") `
    )
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "h $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") help" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "List Service's Commands" `
            -F $(Clear-Format -F "bright_magenta") `
    )

    $(Format-Shape -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")
}

<#
.Synopsis
    Main Entry Point for the Qatam CLI that manages the entire Qatam CLI system
.EXAMPLE
    qatam
.EXAMPLE
    qatam [[-Service] <String>] help
.INPUTS
    <Servic>: git, g, github, gh, help, h
.OUTPUTS
    List of services & commands
.FUNCTIONALITY
    Manage the Qatam CLI workflow
#>
function Qatam {
    param (
        [string]$Service,
        [string]$Command
    )
    # Start from a fresh line after typing each command.
    Clear-CurrentContent

    # A function that checks the user's internet connection.
    if (Test-InternetConnection) {
        switch ($Service.ToLower()) {
            "" {
                <#
                    - A function that displays the "Qatam CLI" logo.
                    * The function imported from "$PSScriptRoot\src\windows\modules\Manage-Design.psm1" file.
                #>
                Show-QatamCLILogo

                # A function that checks 'Qatam CLI' updates.
                Compare-QatamCLIVersion

                # A function that displays 'Qatam CLI' terms.
                Show-QatamCLITerm

                # A function that displays 'Qatam CLI' services.
                Show-QatamCLIHelp
                Write-Output "" | Out-Default
            }
            { $_ -in @("windows", "w") } {
                <#
                    - A function that displays or executes the "Windows" service commands.
                    * The function imported from "$PSScriptRoot\src\windows\modules\Manage-Windows.psm1" file.
                #>
                Select-Windows -Command $Command
            }
            { $_ -in @("git", "g") } {
                <#
                    - A function that displays or executes the "Git" service commands.
                    * The function imported from "$PSScriptRoot\src\windows\modules\Manage-Git.psm1" file.
                #>
                Select-Git -Command $Command
            }
            { $_ -in @("github", "gh") } {
                <#
                    - A function that displays or executes the "GitHub" service commands.
                    * The function imported from "$PSScriptRoot\src\windows\modules\Manage-GitHub.psm1" file.
                #>
                # Select-GitHub -Command $Command
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Sorry, this service is currently under development." `
                )
                Write-Output "" | Out-Default
            }
            { $_ -in @("help", "h") } {
                Show-QatamCLIHelp
            }
            default {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Invalid command, run: $(Format-Color -TC "green" -Str "qatam help") to see all services." `
                        -F "$(Clear-Format -F "green")" `
                )
                Write-Output "" | Out-Default
            }
        }
    }
    else {
        $(Format-Shape `
                -M "!" `
                -TC "yellow" `
                -Str "No internet connection. Please check your internet connection & try again." `
        )
        Write-Output "" | Out-Default
    }
}

# Export the Main Entry Point function
Export-ModuleMember -Function Qatam