Function Get-Databases {
    Param (
        $connectionString = "Data Source=(localdb)\MSSQLLocalDB;Integrated Security=True",
        $query = "SELECT name FROM sys.databases;",
        [Switch]$Quiet
    )
    $Splat = @{connectionString = $connectionString; query = $query}
    # Remove any null value parameters to use called function's default value
    $Splat.Keys.Where({-not $Splat[$_]}).ForEach({$Splat.Remove($_)})
    Invoke-DatabaseQuery @Splat -Quiet:$Quiet
}
<# Usage Examples # >
Get-Databases
Get-Databases -Quiet
Get-Databases -connectionString:$null
#>