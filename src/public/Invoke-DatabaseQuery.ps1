Function Invoke-DatabaseQuery {
    Param (
        $connectionString = "Data Source=(localdb)\MSSQLLocalDB;AttachDbFilename=C:\Git\SqlQueryClass\tests\TestDatabase1.mdf;Integrated Security=True",
        $query,
        [Switch]$Quiet
    )
    If ([String]::IsNullOrWhiteSpace($Query)) {
        Throw "Parameter -Query cannot be null or empty"
    }
    If (-Not $Quiet) {
        Write-Host "`nUsing ConnectionString: ($connectionString)"
        Write-Host ("Executing SQL Query: $($Query | Out-String)").Trim()
    }
    $SQLReader = $null
    $Result = $null
    Try {
        # Create and open the connection
        $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $connection.Open()

        # Create the command
        $command = $connection.CreateCommand()
        $command.CommandText = $query
        $command.CommandTimeout = 600

        # Execute the command and read the results
        $SQLReader = $command.ExecuteReader()
        If ($SQLReader) {
            $Result = [System.Data.DataTable]::new()
            $Result.Load($SQLReader)
        }
        # Write-Host ($Result.Rows | Out-String)
        Return ,$Result
    } Catch {
        Write-host ($_ | Out-String) -ForegroundColor Red
    } Finally {
        # Close the reader and the connection
        If ($SQLReader) {
            $SQLReader.Close()
        }
        $connection.Close()
    }
}
<# Usage Example: # >
Invoke-DatabaseQuery -connectionString 'Data Source=(localdb)\MSSQLLocalDB;AttachDbFilename=C:\Git\SqlQueryClass\tests\TestDatabase1.mdf;Integrated Security=True' -query 'SELECT database_id, name, compatibility_level FROM sys.databases;'
Invoke-DatabaseQuery -query "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_SCHEMA, TABLE_NAME;"
Invoke-DatabaseQuery -query "SELECT * FROM SqlQuery;"
Invoke-DatabaseQuery -query "SELECT * FROM SqlQueryParms;"
#>
