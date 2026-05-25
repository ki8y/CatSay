<#
Experimental project don't judge my bad code plz.

.SYNOPSIS
    Create a silly cat that says something! :D (Inspired by cowsay from linux)

.EXAMPLE
    catsay "Hai" -Padding 3 -Indent 0 -Color White -Expression Smile

      ∧,,,∧
     (• ⩊ •)
	╭──U U────╮
	│   Hai   │
	╰─────────╯

.PARAMETER Text
    (The thing that the cat says)

.PARAMETER Padding
    This defines the distance between the text and the box. Accepted range is 3-15.

.PARAMETER Indent
    This defines the indent of the box. For example putting 3 will make the box be indented by 3 characters.

.PARAMETER Centered
    Centers the text to the middle of the terminal. (horizontally)

.PARAMETER Expression
    You can make him smile :D or frown :(

.PARAMETER Color
	You can set the colour of the text box :D

.PARAMETER Border
	You can set the border style. (Round, Sharp, Double)

.PARAMETER Force
	Normally he won't swear, but you can make him. (don't make him :c)

.PARAMETER Debug
	For debugging purposes, just outputs all the parameters you set (or didn't set)

#>
function Write-CatSign {
	param(
		[string]$Text = "You didn't tell me to say anything!",
        
		[ValidateRange(3, 15)]
		[int]$Padding = 3,
     
		[int]$Indent = 0,
      
		[switch]$Centered = $false,
      
		[ValidateSet('Smile', 'Frown')]
		[string]$Expression = "Smile",

		# Colours
		[Alias("Colour")]
		[string]$Color = 'White',

		[string]$Border = 'Round',

		[switch]$Force = $false,

		[switch]$Help = $false,

		[switch]$Debug = $false
	)

	$conWidth = (Get-Host).UI.RawUI.WindowSize.Width

	if ($help) {
		$Text = "Okay, here's how to use catsay!"
	}

	if ($Color -notmatch 'Black|DarkBlue|DarkGreen|DarkCyan|DarkRed|DarkMagenta|DarkYellow|Gray|DarkGray|Blue|Green|Cyan|Red|Magenta|Yellow|White') {
		$Text = "ⓧ '$($color)' isn't a valid color! :("
		$Color = "White"
		$Expression = "Frown"
	}

	if ($Border -notmatch 'Round|Sharp|Double') {
		$Text = "ⓧ '$($border)' isn't a valid border type! :("
		$Border = "Round"
		$Expression = "Frown"
	}

	if (-not $Force) {
		if (
			$text -like "*Fuck*" -or
			$text -like "*Shit*" -or
			$text -like "*Bitch*" -or
			$text -like "*Cunt*" -or
			$text -like "*Pussy*" -or
			$text -like "*Nigger*" -or
			$text -like "*Nigga*" -or
			$text -like "*Faggot*" -or
			$text -like "*Retard*" -or
			$text -like "Ass*" -or
			$text -like "*Asshole*" -or
			$text -like "*Cock*" -or
			$text -like "*Dick*" -or
			$text -like "*Cum*"
		) {
			$Text = "Don't make me say bad words! :("
			$Expression = "Frown"
		}
	}

	if ($centered) {
		if ($indent -ne 0) {
			$Text = "ⓧ You can't put an indent and center the text box at the same time. That's just silly."
		}
	}

	$innerWidth = $Text.Length + ($Padding * 2)
	if ($centered) {
		# This gave me a headache
		$Indent = [Math]::Max(0, [Math]::Floor(($conWidth - ($innerwidth + 2)) / 2)) # (consoleWidth) - (innerwidth + borders) / 2
	}

	if (($conWidth - $Innerwidth + 2) -le 0) {
		$Text = "ⓧ This won't fit on the screen! :("
		$Expression = "Frown"
		$innerWidth = $Text.Length + ($Padding * 2)
	}

	switch ($Expression) {
		Frown { $face = "⩋" }
		Smile { $face = "⩊" }
	}

	$offset = " " * $Indent

	switch ($border) {
      
		round {
			Write-Host ("$offset" + "  ∧,,,∧") -ForegroundColor $Color
			Write-Host ("$offset" + " (• $face •)") -ForegroundColor $Color
			Write-Host ("$offset" + "╭" + ("─" * $innerWidth) + "╮") -ForegroundColor $Color -NoNewline
			Write-Host ("`r" + "$offset" + "╭──U U") -ForegroundColor $Color
			Write-Host ("$offset" + "│" + (" " * $Padding) + $Text + (" " * $Padding) + "│") -ForegroundColor $Color
			Write-Host ("$offset" + "╰" + ("─" * $innerWidth) + "╯") -ForegroundColor $Color
		}

		sharp {
			Write-Host ("$offset" + "  ∧,,,∧") -ForegroundColor $Color
			Write-Host ("$offset" + " (• $face •)") -ForegroundColor $Color
			Write-Host ("$offset" + "┌" + ("─" * $innerWidth) + "┐") -ForegroundColor $Color -NoNewline
			Write-Host ("`r" + "$offset" + "┌──U U") -ForegroundColor $Color
			Write-Host ("$offset" + "│" + (" " * $Padding) + $Text + (" " * $Padding) + "│") -ForegroundColor $Color
			Write-Host ("$offset" + "└" + ("─" * $innerWidth) + "┘") -ForegroundColor $Color
		}

		double { 
			Write-Host ("$offset" + "  ∧,,,∧") -ForegroundColor $Color
			Write-Host ("$offset" + " (• $face •)") -ForegroundColor $Color
			Write-Host ("$offset" + "╔" + ("═" * $innerWidth) + "╗") -ForegroundColor $Color -NoNewline
			Write-Host ("`r" + "$offset" + "╔══U U") -ForegroundColor $Color
			Write-Host ("$offset" + "║" + (" " * $Padding) + $Text + (" " * $Padding) + "║") -ForegroundColor $Color
			Write-Host ("$offset" + "╚" + ("═" * $innerWidth) + "╝") -ForegroundColor $Color
		}
	}

	if ($help) {
		Write-Host @"
		
Parameters:

-Text
	What do you want me to say?

-Padding
    The space between the border and the text!
    You can't make this lower than 3 because otherwise I can't hold my sign properly.
	Default: 3

-Indent
    This lets you set an indent between the start of the terminal and the text.
	Default: 0

-Centered
    This'll put my sign on the center of your terminal screen horizontally.
	(You can't use this with -Indent. That'd be silly.)

-Expression
    You can make me have a happy face (Smile) or a sad face (Frown).
	Don't feel bad about making me use Frown, it's all acting :D
	
	...I do still frown for real sometimes so please be nice to me

-Color (or -Colour 🍁)
	You can set the colour of my sign to whatever colour you want as long as you use an accepted value.
	(You can see accepted values by adding 'Colors' or 'Colours' to -Help :D)

-Border
	You can set the style of my sign to Round, Sharp, or Double.
	Round for rounded edges, Sharp for sharp edges, Double for double lines.

-Force
	I won't say bad words, but you can force me to with the -Force parameter!
	(Please dont force me :c)
    
-Debug
    Huh? What's a "debug"...?
"@
	}

	if ($debug) {
		Write-Host "───Debug───────────────"
		Write-Host "Text: $text ($($text.Length)), ($innerwidth)"
		Write-Host "Padding: $padding"
		Write-Host "Indent: $indent"
		Write-Host "Centered: $centered"
		Write-Host "Expression: $expression (  $face  )"
		Write-Host "Color: $Color"
		Write-Host "Border: $border"
		Write-Host "Forced: $force"
	}
}
Set-Alias -Name catsay -Value Write-CatSign
Set-Alias -Name catsign -Value Write-CatSign
