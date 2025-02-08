Function Invoke-DatabaseNonQuery {
    Param (
        $connectionString = "Data Source=(localdb)\MSSQLLocalDB;AttachDbFilename=C:\Git\SqlQueryClass\tests\TestDatabase1.mdf;Integrated Security=True",
        $NonQuery,
        [Switch]$Quiet
    )
    If ([String]::IsNullOrWhiteSpace($NonQuery)) {
        Throw "Parameter -NonQuery cannot be null or empty"
    }
    If (-Not $Quiet) {
        Write-Host "`nUsing ConnectionString: ($connectionString)"
        Write-Host ("Executing Database NonQuery: $($NonQuery | Out-String)").Trim()
    }
    Try {
        # Create and open the connection
        $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $connection.Open()
        # Create a command to attach the database
        $attachCommand = $connection.CreateCommand()
        $attachCommand.CommandText = $NonQuery
        $attachCommand.ExecuteNonQuery()
    } Catch {
        Write-host ($_ | Out-String) -ForegroundColor Red
    } Finally {
        # Close connection
        $connection.Close()
    }
}
<# Usage Example: # >
$Error.Clear()
Invoke-DatabaseNonQuery -NonQuery "EXEC sp_detach_db 'NORTHWIND'"
#>
