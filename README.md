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
- VS Code and clone [Brooks Vaughn's SqlQueryClass](https://github.com/BrooksV/SqlQueryClass) Repository
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

## How Build `SqlQueryClass` Module

### Setup

- Uses SQL Express but should work with other SQL Databases with proper connection strings and credentials
- Requires VS Code
- For Contributors, Fork the [SqlQueryClass](https://github.com/BrooksV/SqlQueryClass) repository
- Clone the repository or fork to local pc. I like using c:\git as my local repository folder. Subfolder `SqlQueryClass` will be created with the GiHib repository contents
- Install [Manjunath Beli's ModuleTools](https://github.com/belibug/ModuleTools) module as the module build process uses ModuleTools
- - Find-Module -Name ModuleTools | Install-Module -Scope CurrentUser -Verbose
- Note that a sample SQL Express database file (.\tests\TestDatabase1.mdf) is included for pester tests. The database configuration is set in .\tests\TestDatabase1.parameters.psd1

#### Source Files used in the Module

- Public functions that are exported, are separate files in the .\src\public folder.
- Private functions that are local to the Module, are separate files in the .\src\private folder.
- - Class Definitions and Enums are not accessible outside of the Module and cannot be accessed directly like Public Functions are. This is a PowerShell limitation.
- - - Classes [SqlQueryDataSet] and [SqlQueryDataSetParms] and enum ResultType used in the Module are defined in file .\src\private\SqlQueryClass.ps1 file. The classes have properties and methods used to maintain a Database connections and result sets making it useful WPF Data binding.
- Resources are files and folders in the .\src\resources folder that needs to be included with the Manifest and Module

#### `SqlQueryClass` Module Build Process

- Create a local branch for your changes
- - Use descriptive name that reflects the type of changes for branch for example features/database-table-access
- Update the build version using Update-MTModuleVersion (Find-Module -Name ModuleTools)
- Commit your changes to the branch
- Run the Pester Teats using Invoke-MTTest (Find-Module -Name ModuleTools)
- Build the Module output using Invoke-MTBuild -Verbose (Find-Module -Name ModuleTools)
- - Outputs to the .\dist\SqlQueryClass folder
- - Combines the file contents of the files in Public and Private folder into .\dist\SqlQueryClass\SqlQueryClass.psd1 and exports the Public Functions
- - Generates the .\dist\SqlQueryClass\SqlQueryClass.psd1 Manifest file from the settings in .\project.json
- - Resources (.\src\resources) folder content is copied to .\dist\SqlQueryClass folder
- Run the Pester Teats using Invoke-MTTest (Find-Module -Name ModuleTools)
- Make corrections, repeat the build process
- For Contributors
- - Create an Issue if one does not exist that addresses the proposed changes
- - Upstream your branch
- - Create a Pull request

#### Publishing `SqlQueryClass` Module to GitHub

Stage and Commit Your Changes

```powershell
git add .
git commit -m "Implemented database and table access functions"
```

Update remote repository with branch changes

```powershell
# List status of remote repository
git branch -r
# Create Branch on remote repository if needed
# git push --set-upstream origin features/database-table-access
# Push branch changes to remote branch in repository
git push origin features/database-table-access
```

Create a Pull Request on remote repository

- Go to [SqlQueryClass GitHub repository](https://github.com/BrooksV/SqlQueryClass)
- Click on "Compare & pull request" for your branch
- Provide a meaningful title and description for the PR
- Select the base branch (main) to merge into
- Click "Create pull request"

Code Review and Feedback

- Engage with Repository Owner or collaborators to review the PR
- Address any feedback or requested changes by making additional commits to your branch and pushing them to the remote branch
- Ensure the PR passes any automated tests or checks

Merge the Pull Request

- Once the PR is approved and all checks pass, you can merge it into the main branch
- You can either use the "Merge pull request" button on GitHub or merge it locally and push the changes

Cleanup

- After merging, you can delete the feature branch from the remote repository to keep it clean

```powershell
git push origin --delete features/database-table-access
```

- Optionally, delete the local branch

```powershell
git branch -d features/database-table-access
```
These steps will ensure your changes are integrated into the main branch and your repository remains organized.

#### Publishing `SqlQueryClass` Module to PowerShell Gallery

```powershell
$data = Get-MTProjectInfo
$ApiKey = "your-api-key-here"
Publish-Module -Path $data.OutputModuleDir -NuGetApiKey $ApiKey -Repository PSGallery
```

### New-SqlQueryDataSet Helper Function to Create Class Instance

The main cmdlet provided by this module is New-SqlQueryDataSet, which returns an object instance of [SqlQueryDataSet] class. Note that all the parameters are optional.

```powershell
$testQuery = New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]
```

#### Other Helper Functions in the SqlQueryClass Module

```powershell
Get-Command -Module SqlQueryClass -Syntax

Dismount-Database [[-connectionString] <Object>] [[-Database] <Object>] [-Quiet]
Get-Database [[-connectionString] <Object>] [[-query] <Object>] [-Quiet]
Get-DatabaseTable [[-connectionString] <Object>] [[-query] <Object>] [-Quiet]
Invoke-DatabaseNonQuery [[-connectionString] <Object>] [[-NonQuery] <Object>] [-Quiet]
Invoke-DatabaseQuery [[-connectionString] <Object>] [[-query] <Object>] [-Quiet]
Mount-Database [[-connectionString] <Object>] [[-Database] <Object>] [[-DatabaseFilePath] <Object>] [-Quiet]
New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]
```

## Summary of Classes

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

### [SqlQueryDataSet] and [SqlQueryDataSetParms] Class Methods and Properties

There are more then 27+ methods and are best listed by running the following with Database connection and Query settings:

```powershell
$testQuery = New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]
$testquery | GM
$testquery.Tables | GM
```

### New-SqlQueryDataSet Examples

See .\tests\New-SqlQueryDataSets.tests.ps1 file for a fully set of usage examples used in the Pester Tests

Parameters are all optional but most of the properties will still need to be configured through the Class instance before an execute query is called.

The most common usage examples are:

```powershell
# Using a connection string, defining a query, and setting TableName
$result = New-SqlQueryDataSet -ConnectionString "Server=myServer;Database=myDB;User Id=myUser;Password=myPass;" -Query "SELECT * FROM INFORMATION_SCHEMA.COLUMNS" -TableName TableSchema

# Create an instance of the [SqlQueryDataSet] class with Database configuration and defining the SQL Query
$testQuery = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB" -Query "SELECT * FROM myTable" -TableName TableSchema

# Create an instance of the [SqlQueryDataSet] class with Database configuration, ConnectionString is autogenerated
$testQuery = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB"
```

### SQL Express Example

```powershell
# Configure Database settings for connection
$SqlServer = '(localdb)\MSSQLLocalDB'
$DatabaseName = 'C:\Git\SqlQueryClass\tests\TestDatabase1.mdf'
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
│   │   TestResults.xml
│   │
│   └───SqlQueryClass
│       │   SqlQueryClass.psd1
│       │   SqlQueryClass.psm1
│       │   about_SqlQueryClass.help.txt
│               
├───src
│   ├───private
│   │       SqlQueryClass.ps1
│   │
│   ├───public
│   │       Dismount-Database.ps1
│   │       Get-Database.ps1
│   │       Get-DatabaseTable.ps1
│   │       Invoke-DatabaseNonQuery.ps1
│   │       Invoke-DatabaseQuery.ps1
│   │       Mount-Database.ps1
│   │       New-SqlQueryDataSet.ps1
│   │
│   └───resources
│           about_SqlQueryClass.help.txt
│
└───tests
        Module.Tests.ps1
        New-SqlQueryDataSets.tests.ps1
        OutputFiles.Tests.ps1
        ScriptAnalyzer.Tests.ps1
        TestDatabase1.mdf
        TestDatabase1.parameters.psd1
        TestDatabase1_log.ldf
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
  - All files and folder contained in the `resources` folder will be published to the `dist\SqlQueryClass` folder.

### Tests Folder

If you want to run any `pester` tests, keep them in `tests` folder and named *.test.ps1.

Run `Invoke-MTTest` to execute the tests.

- .\tests\New-SqlQueryDataSets.tests.ps1 -- Full set of usage example Tests. Good Resource for usage examples
- .\tests\Module.Tests.ps1 -- General Module Control to verify the module imports correctly
- .\tests\OutputFiles.Tests.ps1 -- Module and Manifest testing to verify output files are readable
- .\tests\ScriptAnalyzer.Tests.ps1 -- Code Quality Checks to verify PowerShell syntax and best practices
- .\tests\TestDatabase1.parameters.psd1 -- PowerShell Data File of configuration settings used in New-SqlQueryDataSets.tests.ps1
- .\tests\TestDatabase1.mdf -- Sample SQL Express Database File with samples data used in New-SqlQueryDataSets.tests.ps1
- .\tests\TestDatabase1_log.ldf -- Created when using TestDatabase1.mdf

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure that your code adheres to the existing style and includes appropriate tests.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

[BadgeIOCount]: https://img.shields.io/powershellgallery/dt/SqlQueryClass?label=SqlQueryClass%40PowerShell%20Gallery
[PSGalleryLink]: https://www.powershellgallery.com/packages/SqlQueryClass/
[WorkFlowStatus]: https://img.shields.io/github/actions/workflow/status/BrooksV/SqlQueryClass/Tests.yml

## SEE ALSO

```powershell
    Get-Help -Name New-SqlQueryDataSet
```powershell

## KEYWORDS

    SQL, Database, Query, SqlQueryDataSet
