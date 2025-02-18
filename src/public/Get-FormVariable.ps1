# Function to display form variables
Function Get-FormVariable {
    if ($null -eq $ReadmeDisplay -or $ReadmeDisplay -eq $false) {
        Write-Host "If you need to reference this display again, run Get-FormVariables"
    }
    Write-Host ("`n$("-" * 65)`nFound the following intractable elements from our form`n$("-" * 65)")
    Get-Variable WPF*
    Write-Host ("$("-" * 65)`n")
}
