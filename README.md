# SqlQueryClass

The SqlQueryClass module provides a set of functions and cmdlets for working with SQL databases. It includes functionality for connecting, executing SQL queries, and managing output as DataTable, DataAdapter, DataSet, SqlReader, or NonQuery result objects.

## `SqlQueryClass` Module and Status Details

Name          | Version | PS Compatibility | Project Uri (GitHub)
------------- | ------- | ---------------- | ------------------------------------------------------------------------------------
SqlQueryClass | 0.1.1   | 5.1              | [https://github.com/BrooksV/SqlQueryClass](https://github.com/BrooksV/SqlQueryClass)

[PSGalleryLink]: https://www.powershellgallery.com/packages/SqlQueryClass/
[BadgeIOCount]: https://img.shields.io/powershellgallery/dt/SqlQueryClass.svg?label=downoads%20SqlQueryClass%40PSGallery
[WorkFlowStatus]: https://img.shields.io/github/actions/workflow/status/BrooksV/SqlQueryClass/tests.yml?label=tests.yml%20build

[![maintainer](https://img.shields.io/badge/maintainer-BrooksV-orange)](https://github.com/BrooksV)
[![License](https://img.shields.io/github/license/BrooksV/SqlQueryClass)](https://github.com/BrooksV/SqlQueryClass/blob/main/LICENSE)
[![contributors](https://img.shields.io/github/contributors/BrooksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/graphs/contributors/)
[![last-commit](https://img.shields.io/github/last-commit/BroksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/commits/)
[![issues](https://img.shields.io/github/issues/BrooksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/issues/)
[![issues-closed](https://img.shields.io/github/issues-closed/BrooksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub stars](https://img.shields.io/github/stars/BrooksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/BrooksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/network/members)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/BrooksV/SqlQueryClass.svg)](https://github.com/BrooksV/SqlQueryClass/pulls)

### Build and Release Statistics

[![SqlQueryClass@PowerShell Gallery][BadgeIOCount]][PSGalleryLink]
![WorkFlow Status][WorkFlowStatus]
![Build Status](https://img.shields.io/github/actions/workflow/status/BrooksV/SqlQueryClass/ci.yml?label=ci.yml%20build)

![Version](https://img.shields.io/github/v/release/BrooksV/SqlQueryClass.svg?label=version)
![GitHub All Releases](https://img.shields.io/github/downloads/BrooksV/SqlQueryClass/total.svg?label=release%20dl%20all%40GitHub)
![GitHub release (latest by date)](https://img.shields.io/github/downloads/BrooksV/SqlQueryClass/latest/total.svg?label=release%20dl%20by%20date%40GitHub)
![Downloads](https://img.shields.io/github/downloads/BrooksV/SqlQueryClass/total.svg?label=total%20release%20dl%40GitHub)

### Related Links

- [LicenseUri](https://github.com/BrooksV/SqlQueryClass/blob/main/LICENSE)
- [ProjectUri](https://github.com/BrooksV/SqlQueryClass)

### Module Tags / Keywords

[PowerShell], [Database], [SQL], [SQLServer], [SQLQuery], [DataAdapter], [DataSet], [DataTable]

## Installation

```powershell
Install-Module -Name SqlQueryClass -Repository PSGallery -Scope CurrentUser
```

To load a local build of the module, use Import-Module as follows:

```powershell
Import-Module -Name "C:\Git\SqlQueryClass\dist\SqlQueryClass\SqlQueryClass.psd1" -Force -verbose
```

### Requirements

- Tested with PowerShell 5.1 and 7.5x
- No known dependencies for usage
- VS Code and clone [Brooks Vaughn's SqlQueryClass](https://github.com/BrooksV/SqlQueryClass) Repository
- Module build process uses [Manjunath Beli's](https://github.com/belibug) [ModuleTools](https://github.com/belibug) module.
- Test scripts requires the Pester module and SQL Express
- Includes sample SQL Express database file used in test scripts

### Features

- Includes helper functions (not used by the Classes as they have there own methods for database access and management)
- - Class Constructor
- - SQL Query and NonQuery execute functions
- - Attach and Detach Database functions
- - List Database and Table functions
- - Create SQL Connection function
- Uses PowerShell Classes to:
- - Manage database connections and configuration persistence
- - Execute SQL queries
- - Manage multiple SQL Query configurations and execution results as persist data
- - Supports multiple query types, output data types
- - Includes database schema, table, and DDL methods
- - Support for multiple SQL servers using multiple instances of the parent class

## Usage

The SqlQueryClass Module was developed to support data binding of WPF (Windows Presentation Framework) elements to DataTables and uses SQL Adapter features for CRUD operations. Having a single class object is very convenient since it allows for maintaining connectivity, queries, and results.

It can be useful in any PS script that needs to read and write to SQL databases. For quick and simple, the Module's helper functions are also a consideration. When needing to use the Classes, use the `New-SqlQueryDataSet` function which calls the Parent Class [SqlQueryDataSet]::New() constructor and return an instance of the class.

### New-SqlQueryDataSet Helper Function Used to Create Parent [SqlQueryDataSet] Class Instance

```powershell
$result = New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]
```

These and other properties can be configured after the instance is created and before the desired execution method is called.

#### New-SqlQueryDataSet Help Links

- For usage examples, the [New-SqlQueryDataSets.tests.ps1](.\tests\New-SqlQueryDataSets.tests.ps1) contains a full suite of usage examples used in the Pester tests.
- For examples, type: "Get-Help New-SqlQueryDataSet -Examples"
- For detailed information, type: "Get-Help New-SqlQueryDataSet -Detailed"
- For technical information, type: "Get-Help New-SqlQueryDataSet -Full"
- See [API Guide and Class Documentation](api.guide.md) for detailed information about the module functions and classes.

### Example 1: Create Class and Initializes with Database and Query Settings

```powershell
$result = New-SqlQueryDataSet -SQLServer "myServer" -Database "myDB" -Query "SELECT * FROM myTable"
```

### Example 2: Create Class and Initializes with Connection String and Query Settings

```powershell
$result = New-SqlQueryDataSet -ConnectionString "Server=myServer;Database=myDB;User Id=myUser;Password=myPass;" -Query "SELECT * FROM myTable" -DisplayResults $false
```

## How to Contribute

1. Fork the repository.
2. Create a local branch for your changes.
3. Make your changes and commit them.
4. Push your changes to your fork.
5. Create a pull request.

For detailed information on "How to Contribute", set up the development environment, and more, please refer to the [Developer and Contributor Guide](contributor.guide.md).

This includes details on:

- [Setup](contributor.guide.md#setup)
- [Source Files used in the Module](contributor.guide.md#source-files-used-in-the-module)
- [Module Build Process](contributor.guide.md#module-build-process)
- [Publishing `SqlQueryClass` Module to GitHub](contributor.guide.md#publishing-sqlqueryclass-module-to-github)
- [Code Review and Feedback](contributor.guide.md#code-review-and-feedback)
- [Merge the Pull Request](contributor.guide.md#merge-the-pull-request)
- [Cleanup](contributor.guide.md#cleanup)
- [Publishing `SqlQueryClass` Module to PowerShell Gallery](contributor.guide.md#publishing-sqlqueryclass-module-to-powershell-gallery)

### ToDo

- [ ] Seek peer review and comments
- [ ] Integrate feedback
- [ ] Improve Documentation
- [ ] Develop a Build-Readme.ps1 script to support README.md updates to code changes

## Module Exported Functions

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

### API Guide Overview

For detailed API documentation, please refer to the [API Guide](api.guide.md).

This includes details on:

- [Functions](api.guide.md#functions)
  - [Dismount-Database](api.guide.md#dismount-database)
  - [Get-Database](api.guide.md#get-database)
  - [Get-DatabaseTable](api.guide.md#get-database-table)
  - [Invoke-DatabaseNonQuery](api.guide.md#invoke-database-non-query)
  - [Invoke-DatabaseQuery](api.guide.md#invoke-database-query)
  - [Mount-Database](api.guide.md#mount-database)
  - [New-SqlQueryDataSet](api.guide.md#new-sql-query-data-set)
- [Classes](api.guide.md#classes)
  - [SqlQueryDataSet Parent Class Details](api.guide.md#sql-query-data-set-parent-class-details)
  - [Class SqlQueryDataSet Properties](api.guide.md#class-sql-query-data-set-properties)
  - [Class SqlQueryDataSet Methods](api.guide.md#class-sql-query-data-set-methods)
  - [Child Class SqlQueryTable Properties](api.guide.md#child-class-sql-query-table-properties)
  - [Child Class SqlQueryTable Methods](api.guide.md#child-class-sql-query-table-methods)

### Class Overview

The module includes two classes, the parent class [SqlQueryDataSet] which includes the Tables collections property of child class [SqlQueryTable] objects.

An instances of [SqlQueryDataSet] manages database information and connections. It's properties and methods manages child [SqlQueryTable] classes, executes queries, and saves the results.

Each instance of the [SqlQueryTable] Class holds the Query configuration and execution results. Each unique query that is added or executed is a separate item in the parent's Tables property.

An instance Parent Class [SqlQueryDataSet] are created using the New-SqlQueryDataSet() helper CmdLet.

See [API Guide and Class Documentation](api.guide.md) for detailed class and module information.

For additional technical information, see:

- "Get-Help New-SqlQueryDataSet -Full"
- [New-SqlQueryDataSets.tests.ps1](.\tests\New-SqlQueryDataSets.tests.ps1) in the [.\tests](.\tests) folder has full usage examples used to validate usage
- [Developer and Contributor Guide](contributor.guide.md)

## Join the Conversation

We encourage you to participate in our [Discussions](https://github.com/BrooksV/SqlQueryClass/discussions) section! Whether you have questions, ideas, or just want to chat with other users, Discussions is the place to be. Your feedback and contributions are valuable to us!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Manjunath Beli](https://github.com/belibug) for the [ModuleTools](https://github.com/belibug/ModuleTools) module used in the build process.
- [Brooks Vaughn](https://github.com/BrooksV) for maintaining the SqlQueryClass module.

## Contact

For support, inquiries, or feedback, contact Brooks Vaughn at [BrooksV](https://github.com/BrooksV) through one of the following methods:

- **GitHub Issues**: [Open an issue](https://github.com/BrooksV/SqlQueryClass/issues)
- **GitHub Discussions**: [Start a discussion](https://github.com/BrooksV/SqlQueryClass/discussions)
