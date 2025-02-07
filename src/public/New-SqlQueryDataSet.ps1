<#
.SYNOPSIS
    Creates and returns an Object instance of the [SqlQueryDataSet] class configured with or without the specified parameters.
.DESCRIPTION
    This function initializes a new instance of the [SqlQueryDataSet] class based on the provided SQL Server, 
    Database, ConnectionString, Query, and TableName. 
    Based on which parameters are passed, this CmdLet will use one of the overloaded class constructors and configure instance settings with the other parameters:
    - [SqlQueryDataSet]::new()
    - [SqlQueryDataSet]::new(string SQLServer, string Database)
    - [SqlQueryDataSet]::new(string SQLServer, string Database, string Query)
.PARAMETER SQLServer
    The name of the SQL Server.
.PARAMETER Database
    The name of the Database.
.PARAMETER ConnectionString
    The connection string for the SQL Server.
.PARAMETER Query
    The SQL query to be executed.
.PARAMETER TableName
    The name of the table to store the query results.
.PARAMETER DisplayResults
    Boolean flag to display the results. Default is true which effects query executions by outputting the Results property contents to standard out.
.EXAMPLE
    $result = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB" -Query "SELECT * FROM myTable"
.EXAMPLE
    $result = New-SqlQueryDataSet -ConnectionString "Server=myServer;Database=myDB;User Id=myUser;Password=myPass;" -Query "SELECT * FROM myTable" -DisplayResults $false
.NOTES
    Author: Brooks Vaughn
    Date: 2025-02-01
    Version: 0.1.0
#>

function New-SqlQueryDataSet {
    # Suppress PSScriptAnalyzer rule about ShouldProcess
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    
    [CmdletBinding()]
    param (
        [string]$SQLServer,
        [string]$Database,
        [string]$ConnectionString,
        [string]$Query,
        [string]$TableName,
        [bool]$DisplayResults = $true
    )
    
    $SqlQueryInstance = if ([string]::IsNullOrEmpty($SQLServer) -and [string]::IsNullOrEmpty($ConnectionString) -and [string]::IsNullOrEmpty($Database)) {
        [SqlQueryDataSet]::new()
    } elseif (-not [string]::IsNullOrEmpty($SQLServer) -and -not [string]::IsNullOrEmpty($Database)) {
        if ([string]::IsNullOrEmpty($Query)) {
            [SqlQueryDataSet]::new($SQLServer, $Database)
        } else {
            $instance = [SqlQueryDataSet]::new($SQLServer, $Database)
            if ([string]::IsNullOrEmpty($TableName)) {
                [void]$instance.AddQuery($Query)
            } else {
                [void]$instance.AddQuery($Query, $TableName)
            }
            $instance
        }
    } else {
        $instance = [SqlQueryDataSet]::new()
        if (-not [string]::IsNullOrEmpty($SQLServer)) { $instance.SQLServer = $SQLServer }
        if (-not [string]::IsNullOrEmpty($Database)) { $instance.Database = $Database }
        if ($Query) {
            if ([string]::IsNullOrEmpty($TableName)) {
                [void]$instance.AddQuery($Query)
            } else {
                [void]$instance.AddQuery($Query, $TableName)
            }
        }
        $instance
    }
    
    if ($ConnectionString) { $SqlQueryInstance.ConnectionString = $ConnectionString }
    $SqlQueryInstance.DisplayResults = $DisplayResults
    
    return $SqlQueryInstance
}
