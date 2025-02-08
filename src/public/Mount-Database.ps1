Function Mount-Database {
    Param (
        $connectionString = "Data Source=(localdb)\MSSQLLocalDB;Integrated Security=True",
        $Database = 'TestDatabase1',
        $DatabaseFilePath = 'C:\Git\SqlQueryClass\tests\TestDatabase1.mdf',
        [Switch]$Quiet
    )
    Write-Warning "`nAttaching Database: ($Database) with Database File ($DatabaseFilePath)"
    $Query = "CREATE DATABASE $Database ON (FILENAME = '$DatabaseFilePath') FOR ATTACH"
    $Splat = @{ connectionString = $connectionString; query = $query }
    # Remove any null value parameters to use called function's default value
    $Splat.Keys.Where({-not $Splat[$_]}).ForEach({$Splat.Remove($_)})
    Invoke-DatabaseQuery @Splat -Quiet:$Quiet
}
<# Usage Example: # >
$Error.Clear()
Mount-Database
Get-Database
# Mount-Database -Database 'TestDataBase1' -DatabaseFilePath 'C:\Git\SqlQueryClass\tests\TestDatabase1.mdf'
#>
