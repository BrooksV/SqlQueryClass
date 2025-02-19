
Function Build-HandlerCode {
    Param (
        [System.Object]$Element,
        [String]$ControlType
    )
    If ([String]::IsNullOrEmpty($Element)) {
        Write-Warning "Parameter -Element is empty or missing"
        Return
    }    
    If ([String]::IsNullOrEmpty($ControlType)) {
        Write-Host "Parameter -ControlType is empty or missing" -ForegroundColor Red
        Return
    }

    $eol = [System.Environment]::NewLine
    $sb = [System.Text.StringBuilder]::new()

    $handlerName = "`$handler_$($ControlType.Split('.')[-1])_Click"

    # Starting Code
    [void]$sb.AppendLine(@"
$handlerName = {
    Param ([object]`$theSender, [System.EventArgs]`$e)
    Write-Host ("``$handlerName() Item clicked: {0}" -f `$theSender.Name)
    Switch -Regex (`$theSender.Name) {
"@ + $eol)

    # Body Code consists of Regex patterns of the Item Element Name it finds of matching ControlTypes
    # $elements = Find-EveryMatchingElement -Element:$Element -ControlType:$ControlType -Verbose
    # Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.MenuItem'
    # Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.RadioButton'
    # Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Combobox'
    # Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Button'
    # Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.MenuItem'
    # Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Primitives.ToggleButton'

    $elements = Find-EveryControl -Element $form -ControlType $ControlType
    ForEach ($element in $elements) {
        If (-not [String]::IsNullOrEmpty($element)) {
            [void]$sb.AppendLine(@"
            '^$($element.Name)$' {
                Break
            }
"@)
        }
    }

    # Ending Code
    [void]$sb.AppendLine(@"
        default {
            Write-Host ("{0}: {1}({2})" -f `$theSender.Name, `$e.OriginalSource.Name, `$e.OriginalSource.ToString())
        }
    }
}
"@)

    $sb.ToString()

}


# Build-HandlerCode -Element $form -ControlType System.Windows.Controls.MenuItem
# Build-HandlerCode -Element $form -ControlType 'System.Windows.Controls.Primitives.ToggleButton'
