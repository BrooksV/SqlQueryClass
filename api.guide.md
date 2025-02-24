# API Guide and Class Documentation

## Table of Contents

- [Functions](#functions)
  - [Dismount-Database](#dismount-database)
  - [Get-Database](#get-database)
  - [Get-DatabaseTable](#get-database-table)
  - [Invoke-DatabaseNonQuery](#invoke-database-non-query)
  - [Invoke-DatabaseQuery](#invoke-database-query)
  - [Mount-Database](#mount-database)
  - [New-SqlQueryDataSet](#new-sql-query-data-set)
- [Classes](#classes)
  - [SqlQueryDataSet Parent Class Details](#sql-query-data-set-parent-class-details)
  - [Class SqlQueryDataSet Properties](#class-sql-query-data-set-properties)
  - [Class SqlQueryDataSet Methods](#class-sql-query-data-set-methods)
  - [Child Class SqlQueryTable Properties](#child-class-sql-query-table-properties)
  - [Child Class SqlQueryTable Methods](#child-class-sql-query-table-methods)

## Functions

```powershell
Get-Command -Module "SqlQueryClass" -Syntax

- Dismount-Database [[-connectionString] <Object>] [[-Database] <Object>] [-Quiet]
- Get-Database [[-connectionString] <Object>] [[-query] <Object>] [-Quiet]
- Get-DatabaseTable [[-connectionString] <Object>] [[-query] <Object>] [-Quiet]
- Invoke-DatabaseNonQuery [[-connectionString] <Object>] [[-NonQuery] <Object>] [-Quiet]
- Invoke-DatabaseQuery [[-connectionString] <Object>] [[-query] <Object>] [-Quiet]
- Mount-Database [[-connectionString] <Object>] [[-Database] <Object>] [[-DatabaseFilePath] <Object>] [-Quiet]
- New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]
```

New-SqlQueryDataSet is the Constructor method for creating an instance of Parent Class [SqlQueryDataSet] and is the main cmdlet.

To see the examples, type: "Get-Help New-SqlQueryDataSet -Examples"
For more information, type: "Get-Help New-SqlQueryDataSet -Detailed"
For technical information, type: "Get-Help New-SqlQueryDataSet -Full"

### Dismount-Database

```powershell
NAME
    Dismount-Database
SYNTAX
    Dismount-Database [[-connectionString] <Object>] [[-Database] <Object>] [-Quiet] 
DESCRIPTION
    Detaches a database from the SQL Server.
PARAMETERS
    -connectionString: The connection string to the SQL Server.
    -Database: The name of the database to detach.
    -Quiet: Suppresses output.
```

### Get-Database

```powershell
NAME
    Get-Database
SYNTAX
    Get-Database [[-connectionString] <Object>] [[-query] <Object>] [-Quiet] 
DESCRIPTION
    Executes a query against the SQL Server and returns the results.
PARAMETERS
    -connectionString: The connection string to the SQL Server.
    -query: The SQL query to execute.
    -Quiet: Suppresses output.
```

### Get-DatabaseTable

```powershell
NAME
    Get-DatabaseTable
SYNTAX
    Get-DatabaseTable [[-connectionString] <Object>] [[-query] <Object>] [-Quiet] 
DESCRIPTION
    Executes a query against the SQL Server and returns the results as a table.
PARAMETERS
    -connectionString: The connection string to the SQL Server.
    -query: The SQL query to execute.
    -Quiet: Suppresses output.
```

### Invoke-DatabaseNonQuery

```powershell
NAME
    Invoke-DatabaseNonQuery
SYNTAX
    Invoke-DatabaseNonQuery [[-connectionString] <Object>] [[-NonQuery] <Object>] [-Quiet] 
DESCRIPTION
    Executes a non-query SQL command against the SQL Server.
PARAMETERS
    -connectionString: The connection string to the SQL Server.
    -NonQuery: The non-query SQL command to execute.
    -Quiet: Suppresses output.
```

### Invoke-DatabaseQuery

```powershell
NAME
    Invoke-DatabaseQuery
SYNTAX
    Invoke-DatabaseQuery [[-connectionString] <Object>] [[-query] <Object>] [-Quiet] 
DESCRIPTION
    Executes a query against the SQL Server and returns the results.
PARAMETERS
    -connectionString: The connection string to the SQL Server.
    -query: The SQL query to execute.
    -Quiet: Suppresses output.
```

### Mount-Database

```powershell
NAME
    Mount-Database
SYNTAX
    Mount-Database [[-connectionString] <Object>] [[-Database] <Object>] [[-DatabaseFilePath] <Object>] [-Quiet] 
DESCRIPTION
    Attaches a database to the SQL Server.
PARAMETERS
    -connectionString: The connection string to the SQL Server.
    -Database: The name of the database to attach.
    -DatabaseFilePath: The file path of the database to attach.
    -Quiet: Suppresses output.
```

### New-SqlQueryDataSet

```powershell
NAME
    New-SqlQueryDataSet
SYNOPSIS
    New-SqlQueryDataSet -- Creates and returns an Object instance of the [SqlQueryDataSet] class configured with or without the specified parameters.
SYNTAX
    New-SqlQueryDataSet [[-SQLServer] <String>] [[-Database] <String>] [[-ConnectionString] <String>] [[-Query] <String>] [[-TableName] <String>] [[-DisplayResults] <Boolean>] [<CommonParameters>]
DESCRIPTION
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
REMARKS
    To see the examples, type: "Get-Help New-SqlQueryDataSet -Examples"
    For more information, type: "Get-Help New-SqlQueryDataSet -Detailed"
    For technical information, type: "Get-Help New-SqlQueryDataSet -Full"
```

## Classes

### [SqlQueryDataSet] Parent Class Details

Instances of [SqlQueryDataSet] Parent Class are created using the New-SqlQueryDataSet() helper CmdLet. The object returned is of type [SqlQueryDataSet]. The properties and methods are used to manage and configure database information and connections, manage creation of the Child Class, execute queries, and save the results. Instances of Child Classes are collected in the Tables property of the Parent Class. Tables is a collection of [SqlQueryTable] objects. One is created for every unique query that was added or executed.

Each instance of the [SqlQueryTable] Class holds the Query configuration and execution results.

For technical information, see:

- Get-Help New-SqlQueryDataSet -Full
- New-SqlQueryDataSets.tests.ps1 in the Tests (C:\Git\SqlQueryClass\tests\) folder has full usage examples used to validate usage

### Class [SqlQueryDataSet] Properties

Name              | Type
----------------- | ----------------------------------------------------------------------
SQLServer         | [System.String]
Database          | [System.String]
ConnectionTimeout | [System.Int32]
CommandTimeout    | [System.Int32]
ConnectionString  | [System.String]
SQLConnection     | [System.Object]
TableIndex        | [System.Int32]
Tables            | [System.Collections.Generic.List`1[[SqlQueryTable, PowerShell Class Assembly, Version=1.0.0.2, Culture=neutral, PublicKeyToken=null]]]
TableNames        | [System.Collections.Hashtable]
DisplayResults    | [System.Boolean]
KeepAlive         | [System.Boolean]

### Class [SqlQueryDataSet] Methods

Name                       | Syntax
-------------------------- | -------------------------------------------------------------
AddQuery                   | int AddQuery(string Query)
AddQuery                   | int AddQuery(string TableName, string Query)
GetTableFromQuery          | System.Object GetTableFromQuery(string Query)
GetTableFromTableName      | System.Object GetTableFromTableName(string TableName)
BuildOleDbConnectionString | string BuildOleDbConnectionString()
LoadQueryFromFile          | void LoadQueryFromFile(string Path)
OpenConnection             | void OpenConnection()
CloseConnection            | void CloseConnection()
GetSqlCommand              | System.Data.SqlClient.SqlCommand GetSqlCommand(string query)
Clear                      | void Clear()
Execute                    | System.Object Execute()
Execute                    | System.Object Execute(SqlQueryTable table)
Execute                    | System.Object Execute(int TableIndex)
Execute                    | System.Object Execute(string SqlQuery)
Execute                    | System.Object Execute(ResultType ResultType)
ExecuteNonQuery            | System.Object ExecuteNonQuery(string SqlQuery)
ExecuteQuery               | System.Object ExecuteQuery(string SqlQuery)
ExecuteQuery               | System.Object ExecuteQuery(string TableName, string SqlQuery)
ExecuteAsDataTable         | System.Object ExecuteAsDataTable(string SqlQuery)
ExecuteAsDataAdapter       | System.Object ExecuteAsDataAdapter(string SqlQuery)
ExecuteAsDataSet           | System.Object ExecuteAsDataSet(string SqlQuery)
ExecuteAsDataRows          | System.Object ExecuteAsDataRows(string SqlQuery)
SaveChanges                | System.Object SaveChanges()
GetDBTableSchema           | System.Object GetDBTableSchema(string TableName)
GetDBTableIndexesV17       | System.Object GetDBTableIndexesV17(string TableName)
GetDBTableIndexes          | System.Object GetDBTableIndexes(string TableName)
GetCreateBasicDLL          | System.Object GetCreateBasicDLL(string TableName)
GetCreateDDL               | System.Object GetCreateDDL(string TableName)
ParseSQLQuery              | System.Object ParseSQLQuery(string Query)

### Child Class [SqlQueryTable] Properties

Name           | Type
-------------- | -----------------
TableIndex     | [System.Int32]
TableName      | [System.String]
Query          | [System.String]
SQLCommand     | [System.Object]
SqlDataAdapter | [System.Object]
ResultType     | [ResultType]
Result         | [System.Object]
isDirty        | [System.Boolean]
QueryFile      | [System.String]
Parent         | [SqlQueryDataSet]

### Child Class [SqlQueryTable] Methods

Class Has No Methods
