Function Add-ClickToMenuItem() {
    Param (
        $MenuObj,
        [ScriptBlock]$Handler
    )
    If ([String]::IsNullOrEmpty($Handler)) {
        Write-Warning "Parameter -Handler `$Handler cannot be blank"
        Return
    }
    If ([String]::IsNullOrEmpty($MenuObj)) {
        Write-Warning "Parameter -MenuObj `$MenuObj cannot be blank"
        Return
    }
    Write-Verbose ("Menu Object: [{0}] - {1}" -f $MenuObj.Name, $MenuObj.GetType().ToString())
    ForEach ($child in $MenuObj.Item) {
        Write-Verbose ("  {0} - [{1}]" -f $child.Header, $child.GetType().ToString())
        If ($child.HasItems) {
            Add-ClickToMenuItems -MenuObj $child -Handler:$handler
        } Else {
            If ($child -is 'System.Windows.Controls.MenuItem') {
                $child.Add_Click($handler)
            }
        }
    }
}
