<div align="center" width="100%">
    <h1>SqlQueryClass</h1>
    <p>Module that create an instance of a PowerShell class which is used to execute SQL Queries and manages output as DataTable, DataAdapter, DataSet, DataRows, or NonQuery result object.</p><p>
    <a target="_blank" href="https://github.com/BrooksV"><img src="https://img.shields.io/badge/maintainer-BrooksV-orange" /></a>
    <a target="_blank" href="https://github.com/BrooksV/SqlQueryClass/graphs/contributors/"><img src="https://img.shields.io/github/contributors/BrooksV/SqlQueryClass.svg" /></a><br>
    <a target="_blank" href="https://github.com/BrooksV/SqlQueryClass/commits/"><img src="https://img.shields.io/github/last-commit/BrooksV/SqlQueryClass.svg" /></a>
    <a target="_blank" href="https://github.com/BrooksV/SqlQueryClass/issues/"><img src="https://img.shields.io/github/issues/BrooksV/SqlQueryClass.svg" /></a>
    <a target="_blank" href="https://github.com/BrooksV/SqlQueryClass/issues?q=is%3Aissue+is%3Aclosed"><img src="https://img.shields.io/github/issues-closed/BrooksV/SqlQueryClass.svg" /></a><br>
</div>

# SqlQueryClass

Provides functionality for executing SQL queries and managing SQL datasets

## Description

The SqlQueryClass module provides a set of functions and cmdlets for working with SQL Server databases. It includes functionality for connecting to a SQL Server, executing SQL queries, and managing the results in datasets.

[![SqlQueryClass@PowerShell Gallery][BadgeIOCount]][PSGalleryLink]
![WorkFlow Status][WorkFlowStatus]

## Module Install

SqlQueryClass is in early development phase. Please read through [ChangeLog](/CHANGELOG.md) for all updates.

Stable releases can be installed from the PowerShell Gallery:

```PowerShell
Install-Module -Name SqlQueryClass -Verbose
```

To load a local build of the module, use `Import-Module` as follows:

```PowerShell
Import-Module -Name ".\dist\SqlQueryClass\SqlQueryClass.psd1" -Force -verbose
```

## Requirements

- Tested with PowerShell 5.1 and 7.5x
- No known dependencies for usage
- Module build process uses [Manjunath Beli's](https://github.com/belibug) [ModuleTools](https://github.com/belibug) module.

## ToDo

- [ ] Seek peer review and comments
- [ ] Integrate feedback
- [ ] Improve Documentation

## LONG DESCRIPTION

This module is designed to simplify database operations and improve productivity by offering a set of easy-to-use cmdlets.

Classes [SqlQueryDataSet] and [SqlQueryTable] are defined in the `.\src\private\SqlQueryClass.ps1` file.

New-SqlQueryDataSet helper function is used to creates an instance of the [SqlQueryDataSet] class. This is necessary as classes within modules are local to the module and are not directly accessible outside of the module.

It is best to read the details in the details `.\src\private\SqlQueryClass.ps1` and in `.\src\public\New-SqlQueryDataSet.ps1` files.

### New-SqlQueryDataSet Helper Function to Create Class Instance

The main cmdlet provided by this module is New-SqlQueryDataSet, which returns an object instance of [SqlQueryDataSet] class. Note that all the parameters are optional.

```powershell
$testQuery = New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]

$testquery | GM

   TypeName: SqlQueryDataSet

Name                       MemberType Definition
----                       ---------- ----------
AddQuery                   Method     int AddQuery(string Query), int AddQuery(string Query, string TableName)
BuildOleDbConnectionString Method     string BuildOleDbConnectionString()
Clear                      Method     void Clear()
CloseConnection            Method     void CloseConnection()
Equals                     Method     bool Equals(System.Object obj)
Execute                    Method     System.Object Execute(), System.Object Execute(SqlQueryTable table), System.Object Execute(int TableIndex), System.Object Execute(string SqlQuery), System.Object Execute(ResultType ResultType)
ExecuteAsDataAdapter       Method     System.Object ExecuteAsDataAdapter(string SqlQuery)
ExecuteAsDataSet           Method     System.Object ExecuteAsDataSet(string SqlQuery)
ExecuteAsDataTable         Method     System.Object ExecuteAsDataTable(string SqlQuery)
ExecuteAsDataRows          Method     System.Object ExecuteAsDataRows(string SqlQuery)
ExecuteNonQuery            Method     System.Object ExecuteNonQuery(string SqlQuery)
ExecuteQuery               Method     System.Object ExecuteQuery(string SqlQuery), System.Object ExecuteQuery(string TableName, string SqlQuery)
GetCreateBasicDLL          Method     System.Object GetCreateBasicDLL(string TableName)
GetCreateDDL               Method     System.Object GetCreateDDL(string TableName)
GetDBTableIndexes          Method     System.Object GetDBTableIndexes(string TableName)
GetDBTableIndexesV17       Method     System.Object GetDBTableIndexesV17(string TableName)
GetDBTableSchema           Method     System.Object GetDBTableSchema(string TableName)
GetHashCode                Method     int GetHashCode()
GetTableFromQuery          Method     System.Object GetTableFromQuery(string Query)
GetTableFromTableName      Method     System.Object GetTableFromTableName(string TableName)
GetType                    Method     type GetType()
LoadQueryFromFile          Method     void LoadQueryFromFile(string Path)
OpenConnection             Method     void OpenConnection()
ParseSQLQuery              Method     System.Object ParseSQLQuery(string Query)
SaveChanges                Method     System.Object SaveChanges()
ToString                   Method     string ToString()
CommandTimeout             Property   int CommandTimeout {get;set;}
ConnectionString           Property   string ConnectionString {get;set;}
ConnectionTimeout          Property   int ConnectionTimeout {get;set;}
Database                   Property   string Database {get;set;}
DisplayResults             Property   bool DisplayResults {get;set;}
KeepAlive                  Property   bool KeepAlive {get;set;}
SQLConnection              Property   System.Object SQLConnection {get;set;}
SQLServer                  Property   string SQLServer {get;set;}
TableIndex                 Property   int TableIndex {get;set;}
TableNames                 Property   hashtable TableNames {get;set;}
Tables                     Property   System.Collections.Generic.List`1[[SqlQueryTable, PowerShell Class Assembly, Version=1.0.0.1, Culture=neutral, PublicKeyToken=null]], System.Private.CoreLib, Version=9.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e Tables {get;set;}
```

## Summary

An instance of Class [SqlQueryDataSet] is used to maintain the DataBase configuration and connection details.

All the properties and methods defined in the [SqlQueryDataSet] class are referenced through the object returned by calling helper function New-SqlQueryDataSet.

```powershell
class SqlQueryDataSet {
    [string]$SQLServer
    [string]$Database
    [int]$ConnectionTimeout = 5
    [int]$CommandTimeout = 600
    [string]$ConnectionString
    [object]$SQLConnection
    [int]$TableIndex = 0
    [System.Collections.Generic.List[SqlQueryTable]]$Tables
    [System.Collections.Hashtable]$TableNames = @{}
    [bool]$DisplayResults = $True
    [bool]$KeepAlive = $False
...
```
  
There are many methods and ways to add a SQL Query.  When a query is prepared, an instance of [SqlQueryTable] is created and added to the [System.Collections.Generic.List[SqlQueryTable]]$Tables property of the returned object.

An instance of [SqlQueryTable] maintains the query configuration and the results of it's execution. Each unique query will have it's own instance of [SqlQueryTable].

If a Query is added without a TableName being set, [SqlQueryDataSet]::GetTableFromQuery([String]$Query) will attempt to extract the TableName from the Query. This works best with simple Select From statements so it's always best to use a unique identifier as the TableName. It is not part of the SQL Query or it's executions. It is only used to locate the desired query and can be called anything that helps to uniquely identify the row in the Tables property.

To help in locating the desired Query and Result, [HashTable]$TableNames property TableName Key returns the Index value. There is also the [int]$TableIndex property that defaults Tables[TableIndex] when executing a query.

Class method [SqlQueryDataSet]::GetTableFromTableName([String]$TableName) will return Result as [SqlQueryTable]

```powershell
class SqlQueryTable {
    [int]$TableIndex = 0
    [string]$TableName = [string]::Empty
    [string]$Query = [string]::Empty
    [object]$SQLCommand = $null
    [object]$SqlDataAdapter = $null
    [ResultType]$ResultType = [ResultType]::NonQuery
    [object]$Result = $null
    [bool]$isDirty = $false
    [string]$QueryFile = [string]::Empty
    [SqlQueryDataSet]$Parent = $null

     # Constructor -empty object
    SqlQueryTable ()
    { 
        Return
    }
}
```

The ResultsType property defines how the query will be executed and the DataType for the result. ResultType values are: DataTable; DataAdapter; DataSet; DataRows; and NonQuery.

ResultType of DataTable and DataRows use the [System.Data.SqlClient.SqlDataReader] approach to load() a DataTable object and return [SqlQueryTable]$table.Result as [System.Data.DataTable] or [Array][System.Data.DataRow]

ResultType of DataAdapter and DataSet returns [SqlQueryTable]$table.Result as [System.Data.DataSet] and retains the SqlDataAdapter used in [SqlQueryTable]$table.SqlDataAdapter

### New-SqlQueryDataSet Examples

```powershell
# Create an instance of the [SqlQueryDataSet] class
$testQuery = New-SqlQueryDataSet

# Create an instance of the [SqlQueryDataSet] class with Database configuration, ConnectionString is autogenerated
$testQuery = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB"

# Create an instance of the [SqlQueryDataSet] class with Database configuration and defining the SQL Query
$testQuery = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB" -Query "SELECT * FROM myTable"

# Using a connection string, defining a query, and setting DisplayResults to False
$result = New-SqlQueryDataSet -ConnectionString "Server=myServer;Database=myDB;User Id=myUser;Password=myPass;" -Query "SELECT * FROM myTable" -DisplayResults $false

# Using a connection string, defining a query, and setting TableName
$result = New-SqlQueryDataSet -ConnectionString "Server=myServer;Database=myDB;User Id=myUser;Password=myPass;" -Query "SELECT * FROM INFORMATION_SCHEMA.COLUMNS" -TableName TableSchema
```

### SQL Express Example

```powershell
# Configure Database settings for connection
$SqlServer = '(localdb)\MSSQLLocalDB'
$DatabaseName = 'F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF'
$ConnectionString = "Data Source={0};AttachDbFilename={1};Integrated Security=True" -f $SqlServer, $DatabaseName

# Create a new instance of SqlQueryDataSet
$TestQuery = New-SqlQueryDataSet -SQLServer $SqlServer -Database $DatabaseName -ConnectionString $ConnectionString -DisplayResults $true

# Add and Execute Query to return TableNames and DataBase Version
$TestQuery.ExecuteQuery('DBTables', "SELECT TABLE_NAME, @@VERSION FROM INFORMATION_SCHEMA.TABLES")

# Displaying the Results of the Query
$TestQuery.Tables[$TestQuery.TableIndex].Result
or 
$TestQuery.Tables[$TestQuery.TableNames['DBTables']].Result
or
$index = $TestQuery.TableIndex
$TestQuery.Tables[$index].Result
or
$table = $TestQuery.GetTableFromTableName('DBTables')
$table.Result

# Changing an existing Table Query and then executing it.
$TestQuery.Tables[$TestQuery.TableIndex].Query = "SELECT * FROM INFORMATION_SCHEMA.TABLES"
$TestQuery.Execute($TestQuery.Tables[$TestQuery.TableIndex])
$TestQuery.tables[$TestQuery.TableIndex].Result
or
$table = $TestQuery.GetTableFromTableName('DBTables')
$table.Query = "SELECT * FROM INFORMATION_SCHEMA.TABLES"
$table.Parent.Execute()
$table.Result
```

### Troubleshooting

If you encounter issues while using the `SqlQueryClass` Module, ensure that the SQL Server and Database parameters are correctly specified. Verify that the connection string is valid and that the SQL Server is accessible. Check for any errors in the SQL query and make sure that the table name, if specified, exists in the database.

Examine the object returned from `New-SqlQueryDataSet`

```powershell
$TestQuery

SQLServer         : (localdb)\MSSQLLocalDB
Database          : F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF
ConnectionTimeout : 5
CommandTimeout    : 600
ConnectionString  : Data Source=(localdb)\MSSQLLocalDB;AttachDbFilename=F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF;Integrated Security=True
SQLConnection     :
TableIndex        : 0
Tables            : {DBTables}
TableNames        : {[DBTables, 0]}
DisplayResults    : True
KeepAlive         : False

$TestQuery.Tables

TableIndex     : 0
TableName      : DBTables
Query          : SELECT * FROM INFORMATION_SCHEMA.TABLES
SQLCommand     : System.Data.SqlClient.SqlCommand
SqlDataAdapter :
ResultType     : DataTable
Result         : {Document, Category, Entity, DocName...}
isDirty        : False
QueryFile      :
Parent         : SqlQueryDataSet

$TestQuery.Tables.Result

TABLE_CATALOG                                     TABLE_SCHEMA TABLE_NAME    TABLE_TYPE
-------------                                     ------------ ----------    ----------
F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF dbo          Document      BASE TABLE
F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF dbo          Category      BASE TABLE
F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF dbo          Entity        BASE TABLE
F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF dbo          DocName       BASE TABLE
F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF dbo          SqlQuery      BASE TABLE
F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF dbo          SqlQueryParms BASE TABLE
```

## Folder Structure and Build Management

The folder structure of the SqlQueryClass module is based on best practices for PowerShell module development and was initially created using [Manjunath Beli's](https://github.com/belibug) [ModuleTools](https://github.com/belibug) module. Check out his [Blog article](https://blog.belibug.com/post/ps-modulebuild) that explains the core concepts of ModuleTools.

The the following ModuleTools CmdLets used in the build and maintenance process. They need to be executed from project root:

- Get-MTProjectInfo -- returns hashatble of project configuration which can be used in pester tests or for general troubleshooting
- Update-MTModuleVersion -- Increments SqlQueryClass module version by modifying the values in `project.json` or you can manually edit the json file.
- Invoke-MTBuild -- Run `Invoke-MTBuild -Verbose` to build the module. The output will be saved in the `dist` folder, ready for distribution.
- Invoke-MTTest -- Executes pester configuration (*.text.ps1) files in the `tests` folder

- To skip a test, add `-skip` in describe block of the Pester *.test.ps1 file to skip.

### Folder and Files
 
```powershell
.\SQLQUERYCLASS
│   .gitignore
│   GitHub_Action_Docs.md
│   LICENSE
│   project.json
│   README.md
│
├───.vscode
│       settings.json
│
├───archive
│
├───dist
│   └───SqlQueryClass
│           about_SqlQueryClass.help.txt
│           SqlQueryClass.psd1
│           SqlQueryClass.psm1
│
├───src
│   ├───private
│   │       SqlQueryClass.ps1
│   │
│   ├───public
│   │       about_SqlQueryClass.help.txt
│   │       New-SqlQueryDataSet.ps1
│   │
│   └───resources
│           about_SqlQueryClass.help.txt
│
└───tests
        Module.Tests.ps1
        OutputFiles.Tests.ps1
        ScriptAnalyzer.Tests.ps1
```

All files and folders in the `src` folder, will be published Module.

All other folder and files in the `.\SqlQueryClass` folder will resides in the [GitHub SqlQueryClass Repository](https://github.com/BrooksV/SqlQueryClass) except those excluded by inclusion in the `.\SqlQueryClass\.gitignore` file.

### Project JSON File

The `project.json` file contains all the important details about your module, is used during the module build process, and helps to generate the SqlQueryClass.psd1 manifest.

### Root Level and Other Files

- .gitignore -- List of file, folder, and wildcard specifications to ignore when publishing to GitHub repository
- GitHub_Action_Docs.md -- How to add GitHub Action WorkFlows to automate CI/CD (Continuous Integration/Continuous Deployment)
- LICENSE -- MIT License notice and copyright
- project.json -- ModuleTools project configuration file used to build the `SqlQueryClass` module
- README.md -- Documentation (this) file for the `SqlQueryClass` module
- .vscode\settings.json -- VS Code settings used during `SqlQueryClass` module development

### archive Folder

`.\SqlQueryClass\archive` is not used in this project. Its a temporary place / BitBucket to hold code snippets and files during development and is not part of the build.

### Dist (build output) Folder

Generated module is stored in `dist\SqlQueryClass` folder, you can easily import it or publish it to PowerShell Gallery or repository.

### Src Folder

  - All functions in the `public` folder are exported during the module build.
  - All functions in the `private` folder are accessible internally within the module but are not exposed outside the module.
  - All files and folder contained in the `resources` folder will be `dist\SqlQueryClass` folder.

### Tests Folder

If you want to run any `pester` tests, keep them in `tests` folder and named *.test.ps1.

Run `Invoke-MTTest` to execute the tests.

## How the `SqlQueryClass` Module Works

SqlQueryClass.ps1


## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure that your code adheres to the existing style and includes appropriate tests.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

[BadgeIOCount]: https://img.shields.io/powershellgallery/dt/SqlQueryClass?label=SqlQueryClass%40PowerShell%20Gallery
[PSGalleryLink]: https://www.powershellgallery.com/packages/SqlQueryClass/
[WorkFlowStatus]: https://img.shields.io/github/actions/workflow/status/BrooksV/SqlQueryClass/Tests.yml

## SEE ALSO
    New-SqlQueryDataSet
    Get-Help

## KEYWORDS
    SQL, Database, Query, SqlQueryDataSet
