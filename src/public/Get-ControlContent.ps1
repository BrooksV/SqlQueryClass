Function Get-ControlContent {
    Param (
        $Element 
    )
    Switch ($Element) {
        {$_.Content} {Return $_.Content}
        {$_.Header} {Return $_.Header}
        {$_.Text} {Return $_.Text}
        {$_.SelectedItem} {Return $_.SelectedItem}
        Default {Return $_.Name}
    }
}
