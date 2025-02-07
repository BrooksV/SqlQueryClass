<#
.SYNOPSIS
    New-SqlQueryDataSet -- Creates and returns an Object instance of the [SqlQueryDataSet] class configured with or without the specified parameters.
.DESCRIPTION
    This function initializes a new instance of the [SqlQueryDataSet] class and the resulting object is configured is based which parameters were specified.
    
    All parameters are optional as the can be configured later using the [SqlQueryDataSet]$object returned when calling $object = New-SqlQueryDataSet
    When using $SQLServer and $Database, both must be specified together. The [SqlQueryDataSet] class will auto generate a SQL ConnectionString.
    Specifying $ConnectionString overrides auto generation even when $SQLServer and $Database are also specified.
    
    Based on which parameters are passed, this CmdLet will use one of the overloaded class constructors and configure instance settings with the other parameters:
    - [SqlQueryDataSet]::new()
    - [SqlQueryDataSet]::new(string SQLServer, string Database)
    - [SqlQueryDataSet]::new(string SQLServer, string Database, string Query)

.PARAMETER SQLServer
    The name or address of the SQL Server to connect to. This parameter is optional, but when used, must be specified with $Database.
.PARAMETER Database
    The name of the database to connect to on the specified SQL Server. This parameter is also optional, but when used, must be specified with $SQLServer.
.PARAMETER ConnectionString
    The full connection string to use for connecting to the SQL Server. This parameter is optional and provides an alternative to specifying $SQLServer and $Database separately.
.PARAMETER Query
    The SQL query to execute against the database. This parameter is optional, only configures the query settings, and does not trigger execution. Best when used with $TableName.
.PARAMETER TableName
    Unique identifier that names the configuration of this Query. This parameter is optional and a $TableName will be parsed from only simple queries which is why its best to specify with $Query.
.PARAMETER DisplayResults
    Boolean flag indicating whether to display the query results. The default value is $true.
    The [SqlQueryDataSet] class uses this flag to output content to standard out when executing content generating methods such as Execute().
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
    [CmdletBinding(DefaultParameterSetName = 'ServerDatabase')]
    param (
        [Parameter(ParameterSetName = 'ServerDatabase', Mandatory = $false)]
        [Parameter(ParameterSetName = 'ServerDatabaseWithConnectionString', Mandatory = $false)]
        [string]$SQLServer,

        [Parameter(ParameterSetName = 'ServerDatabase', Mandatory = $false)]
        [Parameter(ParameterSetName = 'ServerDatabaseWithConnectionString', Mandatory = $false)]
        [string]$Database,

        [Parameter(ParameterSetName = 'ConnectionString', Mandatory = $false)]
        [Parameter(ParameterSetName = 'ServerDatabaseWithConnectionString', Mandatory = $false)]
        [string]$ConnectionString,

        [Parameter(Mandatory = $false)]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [string]$TableName,

        [Parameter(Mandatory = $false)]
        [bool]$DisplayResults = $true
    )

    # Suppress PSScriptAnalyzer rule about ShouldProcess
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

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
