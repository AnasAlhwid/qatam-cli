# Imports
Import-Module "$PSScriptRoot\Manage-Design.psm1" -Force

<#
.SYNOPSIS
    Check if a directory exist on the local system & get its path
.OUTPUTS
    [[Path] <String>]
#>
function Get-Directory {

    # Display an information message.
    $(Format-Shape -T "-" -CT "*" -Str "Info" -CTC "blue" -StrBox 1)
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "blue" `
            -Str "Type a $(Format-Color -TC "gold" -Str "PATH") to work on. Otherwise, press $(Format-Color -TC "green" -Str "Enter") to stay on" `
            -F "$(Clear-Format -F @("gold", "green"))" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)the same path." `
    )

    $(Format-Shape -T " " -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "blue")

    # Loop until the user enters a valid path in their local system.
    while ($true) {
        # Prompt the user to type the desired directory path.
        $path = $(Format-Shape `
                -M "-" `
                -TC "clear" `
                -WR 1 `
                -Str "Type the directory PATH" `
        )
        Write-Output "" | Out-Default

        if ($path -eq "") {
            # Outputs the current working directory.
            $currentPath = Get-Location
            $currentPath = $currentPath.Path

            return $currentPath
        }
        else {
            # Insure that the path exist on the local system.
            if (Test-Path -Path $path) {
                return $path
            }
            else {
                # Propmt the user to retype the path since it doesn't exist on the local system.
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "Invalid PATH, please try again." `
                )
                Write-Output "" | Out-Default
            }
        }
    }
}

<#
.SYNOPSIS
    Set/Overwrite a new directory on the local system & get its path
.OUTPUTS
    [[Path] <String>]
#>
function Set-Directory {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path
    )

    # Display an information message.
    $(Format-Shape -T "-" -CT "*" -Str "Info" -CTC "blue" -StrBox 1)
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "*" `
            -CT "|" `
            -TC "blue" `
            -Str "Type a $(Format-Color -TC "gold" -Str "NAME") to create a new directory in the specified path. Otherwise," `
            -F "$(Clear-Format -F "gold")" `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)press $(Format-Color -TC "green" -Str "Enter") to stay on the same directory." `
            -F "$(Clear-Format -F "green")" `
    )

    $(Format-Shape -T " " -CT "|")

    $(Format-Shape `
            -M "!" `
            -CT "|" `
            -TC "yellow" `
            -Str "By default, it will navigate to the selected directory." `
    )
    $(Format-Shape `
            -CT "|" `
            -Str "$(" " * 4)To return to the previous path, type $(Format-Color -TC "green" -Str "qatam windows back-path")" `
            -F "$(Clear-Format -F "green")" `
    )

    $(Format-Shape -T " " -CT "|")
    $(Format-Shape -T "-" -CT "*" -CTC "blue")

    # Loop until the user enters a valid name in their local system.
    while ($true) {
        # Prompt the user to type the desired directory name.
        $name = $(Format-Shape `
                -M "-" `
                -TC "clear" `
                -WR 1 `
                -Str "Type the new directory Name" `
        )
        Write-Output "" | Out-Default

        if ($name -eq "") {
            # Set the path to the path selected by the user.
            Set-Location $Path

            return $Path
        }
        else {
            # Construct the full path of the new directory.
            $directoryPath = Join-Path -Path $Path -ChildPath $name

            # Insure that the path exist on the local system.
            if (Test-Path -Path $directoryPath) {
                $(Format-Shape `
                        -M "!" `
                        -TC "yellow" `
                        -Str "A directory with that name already exist on the specified path." `
                )
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
                        -Str "Continue with the existing directory" `
                )
                $(Format-Shape `
                        -M "2" `
                        -CT "|" `
                        -TC "bright_magenta" `
                        -Str "Overwrite the existing directory" `
                )
                $(Format-Shape `
                        -M "3" `
                        -CT "|" `
                        -TC "bright_magenta" `
                        -Str "Retype another directory name" `
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
                            # Set the path to the path selected by the user.
                            Set-Location $directoryPath

                            return $directoryPath
                        }
                        "2" {
                            if ($PSCmdlet.ShouldProcess($directoryPath, "Overwrite a directory")) {
                                Write-Output "" | Out-Default

                                # Delete the selected directory.
                                Remove-Item -Path $directoryPath -Recurse -Force

                                # Create a new directory.
                                $directoryPath = New-Item -Path $Path -Name $name -ItemType "directory"

                                $(Format-Shape `
                                        -M "+" `
                                        -TC "green" `
                                        -Str "The '$name' directory successfully overwritten." `
                                )
                                Write-Output "" | Out-Default

                                # Set the path to the path selected by the user.
                                Set-Location $directoryPath

                                return $directoryPath
                            }
                            else {
                                Write-Output "" | Out-Default
                                $(Format-Shape `
                                        -M "x" `
                                        -TC "red" `
                                        -Str "Overwrite the directory canceled." `
                                )
                                Write-Output "" | Out-Default

                                continue
                            }
                        }
                        "3" {
                            # Break the "while" loop.
                            $loopVar = $false
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
            else {
                # Create a new directory.
                $directoryPath = New-Item -Path $Path -Name $name -ItemType "directory"

                $(Format-Shape `
                        -M "+" `
                        -TC "green" `
                        -Str "The '$name' directory successfully created." `
                )
                Write-Output "" | Out-Default

                # Set the path to the path selected by the user.
                Set-Location $directoryPath

                return $directoryPath
            }
        }
    }
}

# Function: Display list of Windows commands
function Show-WindowsHelp {

    # Display Window commands to the user.
    $(Format-Shape -T "-" -CT "*" -Str "Windows Commands" -CTC "bright_magenta" -StrBox 1)
    $(Format-Shape -CT "|")

    $(Format-Shape `
            -M "Usage" `
            -CT "|" `
            -TC "green" `
            -Str "qatam windows <command>" `
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
            -M "cdir $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") create-dir" `
            -CT "|" `
            -Str "Create a local directory" `
            -TC "bright_magenta" `
            -F $(Clear-Format -F "bright_magenta") `
    )
    $(Format-Shape `
            -M "bp $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") back-path" `
            -CT "|" `
            -Str "Navigate to the previous path" `
            -TC "bright_magenta" `
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
    $(Format-Shape -T "-" -CT "*" -CTC "bright_magenta")
}

<#
.Synopsis
    Main Entry Point for the Windows operations that manages the entire Windows commands
.EXAMPLE
    qatam windows
.EXAMPLE
    qatam windows [[-Command] <String>]
.INPUTS
    <Command>: create-dir, cdir, back-path, bp, help, h
.OUTPUTS
    List of Windows commands
.FUNCTIONALITY
    Manage the Windows workflow
#>
function Select-Windows {
    param (
        [string]$Command
    )

    switch ($Command.ToLower()) {
        { $_ -in @("create-dir", "cdir") } {
            # Save the current path.
            Push-Location

            # A function that gets the path the user want to work on.
            $directoryPath = Get-Directory

            # Divider.
            $(Format-Shape -T "-" -CT "+" -CTC "green")
            Write-Output "" | Out-Default

            # A function that set/overwrite a new directory in the specified path from "Get-Directory".
            $directoryPath = Set-Directory -Path $directoryPath
        }
        { $_ -in @("back-path", "bp") } {
            # Return back to the previous path.
            Pop-Location
        }
        { $_ -in @("help", "h", "") } {
            Show-WindowsHelp
            Write-Output "" | Out-Default
        }
        default {
            $(Format-Shape `
                    -M "!" `
                    -TC "yellow" `
                    -Str "Invalid command, run: $(Format-Color -TC "green" -Str "qatam windows help") to see all Windows commands." `
                    -F "$(Clear-Format -F "green")" `
            )
            Write-Output "" | Out-Default
        }
    }
}

# Export the Main Entry Point function
Export-ModuleMember -Function Select-Windows