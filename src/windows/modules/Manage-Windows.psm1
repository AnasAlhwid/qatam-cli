# Imports
Import-Module "$PSScriptRoot\Manage-Design.psm1" -Force

<#
.SYNOPSIS
    Check if a directory exist on the local system & return its path
.OUTPUTS
    [[-Path] <String>]
#>
function Get-Directory {
    param (
        [string]$Path
    )

    if ($Path -eq "") {
        # Display an informational message.
        $(Format-Shape -T "-" -CT "*" -Str "Info" -CTC "blue" -StrBox 1)
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "*" `
                -CT "|" `
                -TC "blue" `
                -Str "Type a $(Format-Color -TC "gold" -Str "path") to work on. Otherwise, press $(Format-Color -TC "green" -Str "enter") to stay on" `
                -F "$(Clear-Format -F @("gold", "green"))" `
        )
        $(Format-Shape `
                -CT "|" `
                -Str "$(" " * 4)the same path." `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "blue")
    }

    # Loop until the user enters a valid path in their local system.
    while ($true) {
        # If the Path isn't passed in the parameter.
        if ($Path -eq "") {
            # Prompt the user to type the desired directory path.
            $selectedPath = $(Format-Shape `
                    -M "-" `
                    -TC "clear" `
                    -WR 1 `
                    -Str "Type the directory path" `
            )
            Write-Output "" | Out-Default

            # If the current working directory is selected.
            if ($selectedPath -eq "") {
                # Get the current working directory.
                $currentPath = Get-Location
                $currentPath = $currentPath.Path

                return $currentPath
            }
            else {
                # Insure that the path exist on the local system.
                if (Test-Path -Path $selectedPath) {
                    return $selectedPath
                }
                else {
                    # Propmt the user to retype the path since it doesn't exist on the local system.
                    $(Format-Shape `
                            -M "!" `
                            -TC "yellow" `
                            -Str "Invalid path, please try again." `
                    )
                    Write-Output "" | Out-Default
                }
            }
        }
        else {
            # Insure that the passed path exist on the local system.
            if (Test-Path -Path $Path) {
                return $Path
            }
            else {
                return $false
            }
        }
    }
}

<#
.SYNOPSIS
    Set/Overwrite a new directory on the local system & return its path
.OUTPUTS
    [[-Path] <String>]
#>
function Set-Directory {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [string]$Path,
        [string]$DirName,
        [string]$ItemType
    )

    # Apply some default values if none are passed.
    if ([string]::IsNullOrWhiteSpace($ItemType)) {
        $ItemType = "directory"
    }

    # If no directory/file name was passed.
    if ($DirName -eq "") {
        # Start from a fresh line after typing each command with a line divider.
        Clear-CurrentContent -Option "div"

        # Display an informational message.
        $(Format-Shape -T "-" -CT "*" -Str "Info" -CTC "blue" -StrBox 1)
        $(Format-Shape -CT "|")

        $(Format-Shape `
                -M "*" `
                -CT "|" `
                -TC "blue" `
                -Str "Type a $(Format-Color -TC "gold" -Str "name") to create a new directory in the specified path. Otherwise," `
                -F "$(Clear-Format -F "gold")" `
        )
        $(Format-Shape `
                -CT "|" `
                -Str "$(" " * 4)press $(Format-Color -TC "green" -Str "enter") to stay on the same directory." `
                -F "$(Clear-Format -F "green")" `
        )

        $(Format-Shape -T " " -CT "|")

        $(Format-Shape `
                -M "!" `
                -CT "|" `
                -TC "yellow" `
                -Str "By default, it will navigate to the selected directory." `
        )

        $(Format-Shape -T " " -CT "|")
        $(Format-Shape -T "-" -CT "*" -CTC "blue")
    }

    # Loop until the user enters a valid name in their local system.
    while ($true) {
        # If no directory/file name was passed.
        if ($DirName -eq "") {
            # Prompt the user to type the desired directory name.
            $DirName = $(Format-Shape `
                    -M "-" `
                    -TC "clear" `
                    -WR 1 `
                    -Str "Type the new directory Name" `
            )
            Write-Output "" | Out-Default
        }

        # If no directory/file name was passed (Enter pressed), stay on the same directory.
        if ($DirName -eq "") {
            return $Path
        }
        # If directory/file name was passed, create a new directory/file.
        else {
            # Construct the full path of the new directory/file.
            $directoryPath = Join-Path -Path $Path -ChildPath $DirName

            # Insure that the path exist on the local system.
            if (Test-Path -Path $directoryPath) {
                # Start from a fresh line after typing each command with a line divider.
                Clear-CurrentContent -Option "div"

                # Display an attention message.
                $(Format-Shape -T "-" -CT "*" -Str "Attention" -CTC "yellow" -StrBox 1)
                $(Format-Shape -T " " -CT "|")

                $(Format-Shape `
                        -M "!" `
                        -CT "|" `
                        -TC "yellow" `
                        -Str "A $ItemType with the following name exist on the specified path." `
                )

                $(Format-Shape -T " " -CT "|")

                $(Format-Shape `
                        -M "*" `
                        -CT "|" `
                        -TC "blue" `
                        -Str "$DirName" `
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
                        -Str "Continue with the existing $ItemType" `
                )
                $(Format-Shape `
                        -M "2" `
                        -CT "|" `
                        -TC "bright_magenta" `
                        -Str "Overwrite the existing $ItemType" `
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
                            # Return the parent PATH of the file.
                            if ($ItemType -eq "file") {
                                return $Path
                            }
                            # Return the PATH of the directory.
                            else {
                                return $directoryPath
                            }
                        }
                        "2" {
                            if ($PSCmdlet.ShouldProcess($directoryPath, "Overwrite a $ItemType")) {
                                Write-Output "" | Out-Default

                                # Check if the current path is in or under the directory being deleted.
                                if ((Get-Location).Path -like "$directoryPath*") {
                                    # Move to parent or another safe directory
                                    Set-Location -Path ([System.IO.Directory]::GetParent($directoryPath).FullName)
                                }

                                # Delete the selected directory.
                                Remove-Item -Path $directoryPath -Recurse -Force

                                # Create a new directory.
                                $directoryPath = New-Item -Path $Path -Name $DirName -ItemType $ItemType

                                $(Format-Shape `
                                        -M "+" `
                                        -TC "green" `
                                        -Str "The '$DirName' $ItemType successfully overwritten." `
                                )
                                Write-Output "" | Out-Default

                                if ($ItemType -eq "file") {
                                    return $Path
                                }
                                else {
                                    return $directoryPath
                                }
                            }
                            else {
                                Write-Output "" | Out-Default
                                $(Format-Shape `
                                        -M "x" `
                                        -TC "red" `
                                        -Str "Overwrite a $ItemType canceled." `
                                )
                                Write-Output "" | Out-Default

                                if ($ItemType -eq "file") {
                                    return $Path
                                }
                                else {
                                    return $directoryPath
                                }
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
            else {
                # Create a new directory/file.
                $directoryPath = New-Item -Path $Path -Name $DirName -ItemType $ItemType

                $(Format-Shape `
                        -M "+" `
                        -TC "green" `
                        -Str "The '$DirName' $ItemType successfully created." `
                )
                Write-Output "" | Out-Default

                if ($ItemType -eq "file") {
                    return $Path
                }
                else {
                    return $directoryPath
                }
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
            -M "gdir $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") get-dir" `
            -CT "|" `
            -Str "Check if a local directory exists" `
            -TC "bright_magenta" `
            -F $(Clear-Format -F "bright_magenta") `
    )
    $(Format-Shape `
            -M "cdir $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") create-dir" `
            -CT "|" `
            -Str "Create a local directory" `
            -TC "bright_magenta" `
            -F $(Clear-Format -F "bright_magenta") `
    )
    $(Format-Shape `
            -M "h $(Format-Color -TC "clear" -Str "|" -NC "bright_magenta") help" `
            -CT "|" `
            -TC "bright_magenta" `
            -Str "Display Windows OS commands" `
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
    <Command>: get-dir, gdir, create-dir, cdir, help, h
.OUTPUTS
    Windows commands outputs
.FUNCTIONALITY
    Manage the Windows workflow
#>
function Select-Windows {
    param (
        [string]$Command,
        [string]$Path,

        # By default, suppress the values. Otherwise, return them.
        [boolean]$DoReturn = $false,

        # "Set-Directory" function's parameters.
        [string]$DirName,
        [string]$ItemType
    )

    switch ($Command.ToLower()) {
        { $_ -in @("get-dir", "gdir") } {
            # A function that gets the path the user want to work on.
            $directoryPath = Get-Directory -Path $Path

            if ($directoryPath) {
                # Set the path to the path selected by the user.
                Set-Location $directoryPath
            }

            # If $true, return the values.
            if ($DoReturn) {
                return $directoryPath
            }
        }
        { $_ -in @("create-dir", "cdir") } {
            # A function that gets the path the user want to work on.
            $directoryPath = Get-Directory -Path $Path

            # A function that set/overwrite a new directory in the specified path from "Get-Directory".
            $directoryPath = Set-Directory -Path $directoryPath -DirName $DirName -ItemType $ItemType

            if ($directoryPath) {
                # Set the path to the path selected by the user.
                Set-Location $directoryPath
            }

            # If $true, return the values.
            if ($DoReturn) {
                return $directoryPath
            }
        }
        { $_ -in @("help", "h", "") } {
            # A function that displays Windows OS commands.
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