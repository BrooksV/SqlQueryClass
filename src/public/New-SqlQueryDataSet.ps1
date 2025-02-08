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

    Explanation of Parameter Sets:
    - **`ServerDatabase`**: This parameter set allows the user to specify the SQL Server and Database separately without needing a full connection string.
    - **`ServerDatabaseWithConnectionString`**: This parameter set allows the user to provide both the SQL Server and Database separately, or use a connection string.
    - **`ConnectionString`**: This parameter set allows the user to provide a connection string directly.
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
.FUNCTIONALITY
    Creates and initializes an Instance of [SqlQueryDataSet] class
.OUTPUTS
    Object of [SqlQueryDataSet] class
.EXAMPLE
    $result = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB" -Query "SELECT * FROM myTable"
.EXAMPLE
    $result = New-SqlQueryDataSet -ConnectionString "Server=myServer;Database=myDB;User Id=myUser;Password=myPass;" -Query "SELECT * FROM myTable" -TableName myTable -DisplayResults $false
.NOTES
    Author: Brooks Vaughn
    Date: 2025-02-01
    Version: 0.1.0
#>

function New-SqlQueryDataSet {
    [CmdletBinding(DefaultParameterSetName = 'ServerDatabase')]
    # Suppress PSScriptAnalyzer rule about ShouldProcess
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    param (
        [Parameter(Mandatory = $false)]
        [string]$SQLServer,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ if ($SQLServer -and -not $_) { throw "Database must be provided if SQLServer is specified." } else { $true } })]
        [string]$Database,

        [Parameter(Mandatory = $false)]
        [string]$ConnectionString,

        [Parameter(Mandatory = $false)]
        [ValidateScript({ if ($TableName -and -not $_) { throw "Query must be provided if TableName is specified." } else { $true } })]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [string]$TableName,

        [Parameter(Mandatory = $false)]
        [bool]$DisplayResults = $true
    )

    # Function logic here
    if ($SQLServer -and -not $Database) {
        Write-Warning "Database must be provided if SQLServer is specified."
    }

    if ($Database -and -not $SQLServer) {
        Write-Warning "SQLServer must be provided if Database is specified."
    }

    if ($TableName -and -not $Query) {
        Write-Warning "Query must be provided if TableName is specified."
    }

    $instance = $null
    if (-not [string]::IsNullOrEmpty($SQLServer) -and -not [string]::IsNullOrEmpty($Database)) {
        $instance = [SqlQueryDataSet]::new($SQLServer, $Database)
    } else {
        $instance = [SqlQueryDataSet]::new()
    }
    if (-not [string]::IsNullOrEmpty($Query)) {
        if (-not [string]::IsNullOrEmpty($TableName)) {
            [void]$instance.AddQuery($TableName, $Query)
        } else {
            [void]$instance.AddQuery($Query)
        }
    }
    if (-not [string]::IsNullOrEmpty($ConnectionString)) { $instance.ConnectionString = $ConnectionString }
    if (-not [string]::IsNullOrEmpty($SQLServer)) { $instance.SQLServer = $SQLServer }
    if (-not [string]::IsNullOrEmpty($Database)) { $instance.Database = $Database }
    $instance.DisplayResults = $DisplayResults
    return $instance
}
