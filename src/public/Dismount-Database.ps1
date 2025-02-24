Function Dismount-Database {
    Param (
        $connectionString = "Data Source=(localdb)\MSSQLLocalDB;Integrated Security=True",
        $Database = 'TestDatabase1',
        [Switch]$Quiet
    )
    Write-Warning "`nDetaching Database: ($Database)"
    $NonQuery = "EXEC sp_detach_db '$Database'"
    $Splat = @{connectionString = $connectionString; NonQuery = $NonQuery}
    # Remove any null value parameters to use called function's default value
    $Splat.Keys.Where({-not $Splat[$_]}).ForEach({$Splat.Remove($_)})
    Invoke-DatabaseNonQuery @Splat -Quiet:$Quiet
}
<# Usage Example: # >
$Error.Clear()
# Dismount-Database
# Dismount-Database -Database:$null
Dismount-Database -Database 'TestDataBase1'
Get-Database
#>
