Function Get-DatabaseTables {
    Param (
        $connectionString,
        $query = "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_SCHEMA, TABLE_NAME;",
        [Switch]$Quiet
    )
    $Splat = @{ connectionString = $connectionString; query = $query }
    # Remove any null value parameters to use called function's default value
    $Splat.Keys.Where({-not $Splat[$_]}).ForEach({$Splat.Remove($_)})
    Invoke-DatabaseQuery @Splat -Quiet:$Quiet
}
<# Usage Examples: # >
Get-DatabaseTables
#>
