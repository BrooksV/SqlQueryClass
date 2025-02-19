
Function Find-EveryControl () {
    [CmdletBinding()]
    Param(
        $ControlType,
        $Element,
        [Switch]$UseVisualTreeHelper,
        [Switch]$IncludeAll
    )
    If (-not [String]::IsNullOrEmpty($IncludeAll) -and $IncludeAll) {
        [PSCustomObject]@{
            Name = $Element.Name
            Type = $Element.GetType().ToString()
            Text = (Get-ControlContent -Element $Element)
            Element = $Element
        }        
    } Else {
        If ($Element -is $ControlType) {
            Return ([PSCustomObject]@{
                Name = $Element.Name
                Type = $Element.GetType().ToString()
                Text = (Get-ControlContent -Element $Element)
                Element = $Element
            })
        }
    }
    If ($UseVisualTreeHelper) {
        $Count = [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($Element)
        If ($Count -gt 0) {
            For ($i=0; $i -lt $Count; $i++) {
                $current = [System.Windows.Media.VisualTreeHelper]::GetChild($Element, $i)
                # If (-not [String]::IsNullOrEmpty($IncludeAll) -and $IncludeAll) {
                #     [PSCustomObject]@{
                #         Name = $Element.Name
                #         Type = $Element.GetType().ToString()
                #         Text = $Element.Content
                #         Element = $Element
                #     }
                # }
                Find-EveryControl -Element:$current -ControlType:$ControlType -IncludeAll:$IncludeAll
            }
        }
    } Else {
        If ($Element.HasContent) {
            ForEach ($item in $Element.Content) {
                Find-EveryControl -Element:$item -ControlType:$ControlType -IncludeAll:$IncludeAll
            }
        }
        If ($Element.Children) {
            ForEach ($child in $Element.Children) {
                Find-EveryControl -Element:$child -ControlType:$ControlType -IncludeAll:$IncludeAll
            }
        }
        If ($Element.HasItems) {
            ForEach ($item in $Element.Items) {
                Find-EveryControl -Element:$item -ControlType:$ControlType -IncludeAll:$IncludeAll
            }
        }
    }
}

# Find-EveryControl -Element $WPF_menuMasterDataGrid -ControlType 'System.Windows.Controls.MenuItem'
# Find-EveryControl -Element $WPF_menuDetailDataGrid -ControlType 'System.Windows.Controls.MenuItem'
# Find-EveryControl -Element $WPF_tabControl -ControlType 'System.Windows.Controls.Button'
# Find-EveryControl -Element $WPF_gridSqlQueryEditor -ControlType 'System.Windows.Controls.Primitives.ToggleButton'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.MenuItem'
# Find-EveryControl -Element $WPF_tabControl -ControlType 'System.Windows.Controls.Primitives.ToggleButton'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Primitives.ToggleButton'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.MenuItem'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.RadioButton'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Combobox'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Button'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.MenuItem'
# Find-EveryControl -Element $form -ControlType 'System.Windows.Controls.Primitives.ToggleButton'
