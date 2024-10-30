<#
.Synopsis
    Display the "Qatam CLI" logo
.OUTPUTS
    ASCII Art for "Qatam CLI"
#>
function Show-QatamCLILogo {

    # ASCII Art for "Qatam CLI"
    $QatamCLILogo = @"
             ██████               █████                                                  
           ███░░░░███            ░░███                                                   
          ███    ░░███  ██████   ███████    ██████   █████████████                       
         ░███     ░███ ░░░░░███ ░░░███░    ░░░░░███ ░░███░░███░░███                      
         ░███   ██░███  ███████   ░███      ███████  ░███ ░███ ░███                      
         ░░███ ░░████  ███░░███   ░███ ███ ███░░███  ░███ ░███ ░███                      
          ░░░██████░██░░████████  ░░█████ ░░████████ █████░███ █████                     
            ░░░░░░ ░░  ░░░░░░░░    ░░░░░   ░░░░░░░░ ░░░░░ ░░░ ░░░░░                      

                        █████████  █████       █████                                     
                       ███░░░░░███░░███       ░░███                                      
                      ███     ░░░  ░███        ░███                                      
                     ░███          ░███        ░███                                      
                     ░███          ░███        ░███                                      
                     ░░███     ███ ░███      █ ░███                                      
                      ░░█████████  ███████████ █████                                     
                       ░░░░░░░░░  ░░░░░░░░░░░ ░░░░░                                      
"@

    # A function that sets a color on a string.
    Write-Output "$(Format-Color -TC "gold" -Str $QatamCLILogo)"
    Write-Output ""
}

<#
.Synopsis
    Design the terminal with symbols, strings, & colors
.INPUTS
    string, color, boolean, shape
.OUTPUTS
    Shapes & strings formated with color
.FUNCTIONALITY
    Manage terminal appearance
#>
function Format-Shape {
    param (
        [string]$T = " ", # Shape's type (ex: Hyphen, etc.). Defualt is 1 Space.
        [string]$CT, # Shape's corner type (ex: Tab, Space, Hyphen, etc.).
        [string]$Str, # String.
        [boolean]$StrBox = 0, # String inside 2 "|" vertical bars. Default "false (0)"
        [string]$M, # Shape's Mark (Info (*), Exclamation (!), Hyphen, etc.).
        [string]$F, # String Format
        [string]$CTC = "clear", # Shape's corner type color.
        [string]$TC, # Shape's type color.
        [string]$NC = "clear", # Set the next string color.

        <#
            There is 2 outputs for this function:
                [0]. With "Write-Output" for terminal display. (Default)
                [1]. With "Read-Host" for user input.
        #>
        [boolean]$WR = 0
    )

    # If string should be boxed or not.
    if ($StrBox) {
        $preStr = ("-" * 5) + "|"

        $sufStr = "|"

        # Place the string inside 2 "|" vertical bars.
        $string = $preStr + $(Format-Color -CTC $CTC -Str $Str -NC $NC) + $sufStr
    }
    else {
        $string = $Str # String.
    }

    # If Shape's mark is passed.
    if ($M) {
        $preMark = "["

        $sufMark = "]"

        if ($M.Length -gt 1) {
            <#
                22 is max length set for the length of the whole mark, including 2 square brackets.
                20 (String length) + 2 (square brackets length) = 22
            #>
            $space = " " * (20 - ($M.Length - $F.Length))
        }
        else {
            $space = " "
        }

        $mark = $preMark + $(Format-Color -TC $TC -Str $M -NC $NC) + $sufMark + $space
    }

    if ($WR) {
        <#
            For Shape design:
            1. Set (If given) a starting shape at the begining of a line (ex. "|", " ", etc.).
            2. Set (If given) a mark with square brackets (ex. "[!]", "[*]", etc.).
            3. Set a string.
        #>
        $shape = @"
$($(Format-Color -CTC $CTC -Str $CT -NC $NC) + " ")
$mark
$string
"@

        # Replace new lines with a space
        $myString = $shape -replace "`r`n", ""

        Read-Host $myString
    }
    else {
        <#
            For Shape design:
            1. Set (If given) a starting shape at the begining of a line (ex. "|", " ", etc.).
            2. Set (If given) a mark with square brackets (ex. "[!]", "[*]", etc.).
            3. Set a string.
            4. Set a shape (or default is a Space) for a fixed number (ex. "-", etc.).
            5. Set (If given) an ending shape at the end of a line (ex. "|", " ", etc.).
        #>
        $shape = @"
$($(Format-Color -CTC $CTC -Str $CT -NC $NC) + " ")
$mark
$string
$($T * (78 - (($preMark.Length + $M.Length + $sufMark.Length + $space.Length) + ($preStr.Length + $Str.Length + $sufStr.Length) - $F.Length )))
$(" " + $(Format-Color -CTC $CTC -Str $CT -NC $NC))
"@

        # Replace new lines with a space
        $myString = $shape -replace "`r`n", ""

        Write-Output $myString | Out-Default
    }
}

<#
.Synopsis
    Design the terminal with color
.INPUTS
    string, color, shape
.OUTPUTS
    Shapes & strings formated with color
.FUNCTIONALITY
    Manage terminal appearance
#>
function Format-Color {
    param (
        [string]$CTC, # Shape's corner type color.
        [string]$TC, # Shape's type color.
        [string]$Str, # String.
        [string]$NC = "clear" # Set the next string color.
    )

    $foregroundColors = @{
        'clear'          = "`e[0m"
        'red'            = "`e[31m" # (*: Delete, Cancel, Uninstall)
        'green'          = "`e[32m" # (*: Agreement, Accomplished, install)
        'yellow'         = "`e[33m" # (*: Warning, Important notice, Recommend, Advice)
        'blue'           = "`e[34m" # (*: Info, Usage)
        'gold'           = "`e[38;5;214m"  # (*: Qatam Operations logo)
        'bright_magenta' = "`e[95m" # (*: choice)
    }

    if ($CTC -ne "") {
        # Get the ANSI code for the specified color.
        $fgColor = $foregroundColors[$CTC]
        $endColor = $foregroundColors[$NC]

        $colored = $fgColor + $Str + $endColor # Reset the color after the string to default.

        return $colored
    }
    if ($TC -ne "") {
        # Get the ANSI code for the specified color.
        $fgColor = $foregroundColors[$TC]
        $endColor = $foregroundColors[$NC]

        $colored = $fgColor + $Str + $endColor # Reset the color after the string to default.

        return $colored
    }
}

<#
.Synopsis
    Get & combine all formats added to a string
.INPUTS
    Format
.FUNCTIONALITY
    Get & combine all formats added to a string
#>
function Clear-Format {
    param (
        [array]$F
    )

    $totalformat = ""

    # Combine all formats added to a string.
    foreach ($format in $f) {
        switch ($format) {
            'link' {
                $formatType = "`e]8;;`e\`e]8;;`e\"
            }
            'black' {
                $formatType = "`e[30m`e[0m"
            }
            'red' {
                $formatType = "`e[31m`e[0m"
            }
            'green' {
                $formatType = "`e[32m`e[0m"
            }
            'yellow' {
                $formatType = "`e[33m`e[0m"
            }
            'blue' {
                $formatType = "`e[34m`e[0m"
            }
            'gold' {
                $formatType = "`e[38;5;214m`e[0m"
            }
            'bright_magenta' {
                $formatType = "`e[95m`e[0m"
            }
            Default {
                return $totalformat
            }
        }
        $totalformat += $formatType
    }
    return $totalformat
}

<#
.Synopsis
    Clear the current content of PS terminal
.OUTPUTS
    New terminal line
#>
function Clear-CurrentContent {
    param (
        [string]$Option
    )

    if ($Option -eq "div") {
        # Line Divider.
        $(Format-Shape -T "-" -CT "+" -CTC "green")
    }

    Write-Output "" | Out-Default
    Write-Output "" | Out-Default

    # Adjust to ensure old commands are pushed up.
    $linesToAdd = [console]::WindowHeight - 3

    for ($i = 0; $i -lt $linesToAdd; $i++) {
        Write-Output "" | Out-Default
    }

    # Move cursor to the top-left of the console.
    [System.Console]::SetCursorPosition(0, 0)

    Write-Output "" | Out-Default
}

# Export multiple functions
Export-ModuleMember -Function Show-QatamCLILogo, Format-Shape, Format-Color, Clear-Format, Clear-CurrentContent