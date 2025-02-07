<#
.SYNOPSIS
. 'C:\Git\SqlQueryEditor\scripts\SqlQueryClass.ps1'

    SqlQueryClass.ps1 -- Dot Source file of SQL Query Class definitions for classes [SqlQueryDataSet] and [SqlQueryTable]

.DESCRIPTION
    This script defines two PowerShell classes [SqlQueryDataSet] and [SqlQueryTable] which are used to execute SQL Queries and return the results in a DataTable, DataAdapter, DataSet, DataRows ([Array]DataRow) or NonQuery.

    The parent class, [SqlQueryDataSet], is designed to manage SQL Server connections, execute queries, and methods to manage data. 
    The child class, [SqlQueryTable], is designed to manage a table SQL query's configuration and query results.

    [SqlQueryDataSet] class property, [Tables], is a collection of child class [SqlQueryTable] objects. 
    When a Query is added to the [SqlQueryDataSet] object, a new [SqlQueryTable] object is created and added to the [Tables] collection.

    The original design was a single class of [SqlQueryDataSet] with a single Query and Result. The SQL query could have several statements separated by semi-colons resulting in a DataSet result.
    The DataSet approach worked out well for binding with WPF components provided you know which tables[index] was associated with which query. 
    When it came to how to edit and save changes for a specific DataTable in the DataSet, there was no easy way to only update a single table without looping through all the tables in the DataSet and checking for changes. 
    Another issue was with the default values on columns like Id, CreatedOn, which were updated in the database but could not get the WPF Components to reflect the changes without executing a new query and setting the ItemsSources.

    The next approach was resorting to ObservableCollection and DataView objects. This involved creating Model-Views for each table, a corresponding class, and functions to Add, Update, Delete, and Save. This was a lot of hard coding and not very flexible and also suffered from the default column values issue.

    A working solution was not to use multiple queries in a single DataSet but to have separate instances of [SqlQueryDataSet] for each table query executed as a SQLDataAdapter.
    Using this approach, I was able to easily edit any table using the same DataGrid component and the application does not need to know the table schema of how to Select, Insert, Update, or Delete. 
    The [SqlQueryDataSet] class handles all of that dynamically utilizing the features [System.Data.SqlClient.SqlConnection], [System.Data.SqlClient.SqlCommand], [System.Data.SqlClient.SqlDataAdapter], [System.Data.SqlClient.SqlCommandBuilder], and [System.Data.DataViewRowState] objects.

    This class was built for a document scanning application that has several comboboxes and DataGrids populated from different table queries. It used a collection of [SqlQueryDataSet] objects in the main program and an enum of the tableNames to assist with accessing the correct DataSet results.
I was uncomfortable with the idea of hardcoding the table names and having separate [SqlQueryDataSet] objects with the same repeating Database configurations and connections.
This lead to having the [SqlQueryDataSet] maintain a collection of table queries ([SqlQueryTable]) which is where we are at now.

Usage Documentation:

An instance of the [SqlQueryDataSet] can be created using any one of the following constructors:
    $TestQuery = [SqlQueryDataSet]::new()
    $TestQuery = [SqlQueryDataSet]::new($SQLServer)
    $TestQuery = [SqlQueryDataSet]::new($SQLServer, $Database)
    $TestQuery = [SqlQueryDataSet]::new($SQLServer, $Database, $Query)

When a Query is added to the [SqlQueryDataSet] object, a new [SqlQueryTable] object is created and added to [SqlQueryDataSet].Tables collection. The TableName and it's Index in the Tables collection is added a the TableNames [HashTable].

A Query can be added to the [SqlQueryDataSet] object in the following ways:
    $TestQuery = [SqlQueryDataSet]::new($SQLServer, $Database, $Query)
    $TestQuery.ExecuteQuery($Query)
    $TestQuery.ExecuteAsDataTable($Query)
    $TestQuery.ExecuteAsDataAdapter($Query)
    $TestQuery.ExecuteAsDataSet($Query)
    $TestQuery.ExecuteAsDataRows($Query)
    $TestQuery.AddQuery($Query)
    $TestQuery.LoadQueryFromFile($PathToSQLFile)

using the AddQuery() method or LoadQueryFromFile() method.
    $TestQuery.AddQuery($Query)
    $TestQuery.LoadQueryFromFile($PathToSQLFile)



It's only been test using SQL Express 

Microsoft SQL Server 2014 (SP1-CU7) (KB3162659) - 12.0.4459.0 (X64)
                May 27 2016 15:33:17
                Copyright (c) Microsoft Corporation
                Express Edition (64-bit) on Windows NT 6.3 <X64> (Build 19045: ) (Hypervisor)

Example that produced the above

. "C:\Git\SqlQueryEditor\scripts\SqlQueryClass.ps1"

$SqlServer = '(localdb)\MSSQLLocalDB'
$DatabaseName = 'F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF'
$ConnectionString = "Data Source={0};AttachDbFilename={1};Integrated Security=True" -f $SqlServer, $DatabaseName

$TestQuery = [SqlQueryDataSet]::new()
$TestQuery.Database = $DatabaseName
$TestQuery.ConnectionString = $ConnectionString
$TestQuery.DisplayResults = $true

$TestQuery.AddQuery("SELECT @@VERSION FROM INFORMATION_SCHEMA.TABLES", 'Version')
$TestQuery.Tables[0].Query = "SELECT TABLE_NAME, @@VERSION FROM INFORMATION_SCHEMA.TABLES"
$TestQuery.Execute()

$TestQuery.ExecuteQuery('SELECT @@VERSION FROM INFORMATION_SCHEMA.TABLES')
$TestQuery.Tables[0].Result

$TestQuery.ExecuteAsDataSet('SELECT @@VERSION FROM INFORMATION_SCHEMA.TABLES')

$TestQuery.AddQuery("SELECT * FROM [dbo].[SqlQuery] ORDER BY Id DESC")

Setting the TableIndex controls which table query will be selected when performing Executions and Saves. These are a few ways to set the TableIndex:
$TestQuery.TableIndex = 2
$TestQuery.TableIndex = $TestQuery.Tables.Where({$_.TableName -eq 'SqlQuery'})[0].TableIndex
$TestQuery.TableIndex = $TestQuery.TableNames['SqlQuery']


Helper Methods
$TestQuery.BuildOleDbConnectionString() -- Builds a connection string for OleDb
$TestQuery.BuildConnectionString() -- [Hidden] Builds a connection string for SqlClient used as a fallback when $TestQuery.ConnectionString is missing or fails
$TestQuery.Clear() -- Closes the connection and clears all the properties and collections of the [SqlQueryDataSet] object
$TestQuery.CloseConnection() -- Closes the SQL Connection
$TestQuery.GetCreateBasicDLL($TableName) -- Returns a DataTable with the basic structure of a table with the following columns: Id, CreatedOn, CreatedBy, UpdatedOn, UpdatedBy
$TestQuery
$TestQuery
$TestQuery
$TestQuery
$TestQuery


AddQuery                   Method     int AddQuery(string Query), int AddQuery(string Query, string TableName)
BuildOleDbConnectionString Method     string BuildOleDbConnectionString()
Clear                      Method     void Clear()
CloseConnection            Method     void CloseConnection()
Equals                     Method     bool Equals(System.Object obj)
Execute                    Method     System.Object Execute(), System.Object Execute(SqlQueryTable table), System.Object Execute(int TableIndex), System.Object Execute(stri… 
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
Tables                     Property   System.Collections.Generic.List[SqlQueryTable] Tables {get;set;}

$TestQuery.Tables | GM



Helpful commands to check and manage SQL Express:

# Check environment PATH for Sql Related Paths
ForEach ($path in (([environment]::GetEnvironmentVariables()).Path -split ';').Where({$_ -like '*SQL*'})) {(Get-ChildItem -Path $path -Filter *.exe -Recurse).FullName}

# Check environment PATH for Sql Express Paths
ForEach ($path in (([environment]::GetEnvironmentVariables()).Path -split ';').Where({$_ -like '*SQL*'})) {(Get-ChildItem -Path $path -Filter sqllocaldb.exe -Recurse).FullName}
C:\Program Files\Microsoft SQL Server\110\Tools\Binn\SqlLocalDB.exe
C:\Program Files\Microsoft SQL Server\120\Tools\Binn\SqlLocalDB.exe
C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe

# Display Help
SqlLocalDB.exe -?

# Show Version
SqlLocalDB.exe v
Microsoft SQL Server 2012 (11.0.3000.0)
Microsoft SQL Server 2014 (12.0.4459.0)
Microsoft SQL Server 2016 (13.0.7037.1)

# List Databases
SqlLocalDB.exe info
MSSQLLocalDB
ProjectsV13
v11.0

# Info on specific Database
SqlLocalDB.exe info MSSQLLocalDB
Name:               MSSQLLocalDB
Version:            12.0.4459.0
Shared name:
Owner:              Desktop\Brooks
Auto-create:        Yes
State:              Running
Last start time:    1/31/2025 9:51:16 AM
Instance pipe name:

# Get current Database Status
$status = ((SqlLocalDB.exe info MSSQLLocalDB) -split [Environment]::NewLine).Where({$_}).Where({$_.StartsWith('State:')})[0].Split(' ')[-1]
$status

# Start the Database
SqlLocalDB.exe Start MSSQLLocalDB


.AUTHOR
    Brooks Vaughn

.COMPONENT
    VERSION 1.0.0

.NOTES
When using the debugger, I always get this error and not sure why or how to correct it as I have no idea where it is coming from.
ParserError: 
Line |
   1 |  [System.Diagnostics.DebuggerHidden()]param() ,eval $stdout.sync=true
     |                                                ~
     | Missing expression after unary operator ','.
it was suggested to use this at top of my scripts:
[System.Diagnostics.DebuggerHidden()]
param()
It doesn't seem to help. Strange think is it happens every other execution

.EXAMPLE

# Configure Database settings for connection
$SqlServer = '(localdb)\MSSQLLocalDB'
$DatabaseName = 'F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF'
$ConnectionString = "Data Source={0};AttachDbFilename={1};Integrated Security=True" -f $SqlServer, $DatabaseName


# Create a new instance of SqlQueryDataSet
$TestQuery = New-SqlQueryDataSet -SQLServer $SqlServer -Database $DatabaseName -ConnectionString $ConnectionString -DisplayResults $true
# There are at least 12 different overloaded Execute methods used execute queries and return results as different object types.

# Example usage of the class
$TestQuery.ExecuteQuery('DBTables', "SELECT TABLE_NAME, @@VERSION FROM INFORMATION_SCHEMA.TABLES")

# Displaying the Results of the Query
$TestQuery.Tables[0].Result

# Changing an existing Table Query and then executing it.
$TestQuery.Tables[0].Query = "SELECT * FROM INFORMATION_SCHEMA.TABLES"
$TestQuery.Execute($TestQuery.Tables[0])

$TestQuery = New-SqlQueryDataSet -SQLServer $SqlServer -Database $DatabaseName -ConnectionString $ConnectionString -DisplayResults $true -TableName 'Category' -Query 'SELECT * FROM [dbo].Category;'
$TestQuery = New-SqlQueryDataSet -SQLServer $SqlServer -Database $DatabaseName -ConnectionString $ConnectionString -DisplayResults $false
$TestQuery.ExecuteQuery('Category', 'SELECT * FROM [dbo].Category;')
$TestQuery.Tables[0].Result[0]
$TestQuery.DisplayResults = $false
$TestQuery.Execute($TestQuery.Tables[0])

.NOTES
C:\Git\SqlQueryEditor> $TestQuery = [SqlQueryDataSet]::new()
PS C:\Git\SqlQueryEditor> $TestQuery | GM

   TypeName: SqlQueryDataSet

Name                       MemberType Definition
----                       ---------- ----------
AddQuery                   Method     int AddQuery(string Query), int AddQuery(string Query, string TableName)
BuildOleDbConnectionString Method     string BuildOleDbConnectionString()
Clear                      Method     void Clear()
CloseConnection            Method     void CloseConnection()
Equals                     Method     bool Equals(System.Object obj)
Execute                    Method     System.Object Execute(), System.Object Execute(SqlQueryTable table), System.Object Execute(int TableIndex), System.Object Execute(stri… 
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
Tables                     Property   System.Collections.Generic.List[SqlQueryTable] Tables {get;set;}

PS C:\Git\SqlQueryEditor> $TestQuery.AddQuery("SELECT TABLE_NAME, @@VERSION FROM INFORMATION_SCHEMA.TABLES")

dataBase schemaTable               Schema             TableName
-------- -----------               ------             ---------
         INFORMATION_SCHEMA.TABLES INFORMATION_SCHEMA TABLES

GetTableFromQuery(): $schemaTable.tableName=TABLES, TableName=TABLES, TableIndex=0

PS C:\Git\SqlQueryEditor> $TestQuery.Tables | GM

   TypeName: SqlQueryTable

Name           MemberType Definition
----           ---------- ----------
Equals         Method     bool Equals(System.Object obj)
GetHashCode    Method     int GetHashCode()
GetType        Method     type GetType()
ToString       Method     string ToString()
isDirty        Property   bool isDirty {get;set;}
Parent         Property   SqlQueryDataSet Parent {get;set;}
Query          Property   string Query {get;set;}
QueryFile      Property   string QueryFile {get;set;}
Result         Property   System.Object Result {get;set;}
ResultType     Property   ResultType ResultType {get;set;}
SQLCommand     Property   System.Object SQLCommand {get;set;}
SqlDataAdapter Property   System.Object SqlDataAdapter {get;set;}
TableIndex     Property   int TableIndex {get;set;}
TableName      Property   string TableName {get;set;}

#>

enum ResultType { DataTable; DataRows; DataAdapter; DataSet; NonQuery; }

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

class SqlQueryDataSet {
    [string]$SQLServer
    [string]$Database
    [int]$ConnectionTimeout = 5
    [int]$CommandTimeout = 600
    # Connection string keywords: https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectionstring(v=vs.110).aspx
    [string]$ConnectionString
    [object]$SQLConnection
    [int]$TableIndex = 0
    [System.Collections.Generic.List[SqlQueryTable]]$Tables
    [System.Collections.Hashtable]$TableNames = @{}
    [bool]$DisplayResults = $True
    [bool]$KeepAlive = $False

     # Constructor -empty object
    SqlQueryDataSet () { Return }
    
    # Constructor - sql server and database
    SqlQueryDataSet ([String]$SQLServer, [String]$Database) { 
        $This.SQLServer = $SQLServer
        $This.Database = $Database
    }

    # Constructor - sql server, database and query
    SqlQueryDataSet ([String]$SQLServer, [String]$Database, [string]$Query) { 
        $This.SQLServer = $SQLServer
        $This.Database = $Database
        $This.TableIndex = $This.AddQuery($Query)
    }

    # Methods to Add New Table for Query and Results
    [int] AddQuery([String]$Query) {
        Return $This.AddQuery($Query, [String]::Empty)
    }
    [int] AddQuery([String]$Query, [String]$TableName) {
        If (-not $this.Tables) {
            $this.Tables = [System.Collections.Generic.List[SqlQueryTable]]::new()
        }
        $table = $null
        $schemaTable = $This.ParseSQLQuery($Query)
        If ([string]::IsNullOrEmpty($TableName)) {
            $table = $This.GetTableFromQuery([String]$Query)
            Write-Host ($schemaTable | Out-String)
            $tableName = $schemaTable.tableName
        } Else {
            $table = $This.GetTableFromTableName([String]$TableName)
        }
        If ([String]::IsNullOrEmpty($table)) {
            $index = $This.TableNames[$TableName]
            If ($index) {
                $table = $This.Tables[$index]
            }
            If ([String]::IsNullOrEmpty($table)) {
                $table = [SqlQueryTable]::new()
                $table.Parent = $This
                $table.Query = $Query
                $table.TableIndex = $This.Tables.Count
                $table.TableName = $TableName
                $This.TableNames.Add($TableName,$table.TableIndex)
                [void]$This.Tables.Add($table)
            } Else {
                $This.TableIndex = $table.TableIndex
            }
        } Else {
            $This.TableIndex = $table.TableIndex
            If ($schemaTable.tableName -ne $table.TableName) {
                Write-Warning "GetTableFromQuery() TableName from Query is different then TableName in Tables: `$schemaTable.tableName=$($schemaTable.tableName), TableName=$($table.TableName), TableIndex=$($table.TableIndex)"
            }
        }
        Write-Host "GetTableFromQuery(): `$schemaTable.tableName=$($schemaTable.tableName), TableName=$($table.TableName), TableIndex=$($table.TableIndex)" -ForegroundColor Green
        Return ($table.TableIndex)
    }

    # Method to Find existing Table based on if there is an existing SQL Query
    [Object] GetTableFromQuery([String]$Query) {
        $table = $null
        If ($this.Tables) {
            $table = $This.Tables.Where({$_.Query -eq $Query})
            If ($table) {
                Return ($table[0])
            }
        }
        Return ($table)
    }

   # Method to Find existing Table based on TableName
    [Object] GetTableFromTableName([String]$TableName) {
        $table = $null
        If ($this.Tables) {
            $table = $This.Tables.Where({$_.TableName -eq $TableName})
            If ($table) {
                Return ($table[0])
            }
        }
        Return ($table)
    }

    # Method
    hidden [String]BuildConnectionString() {
        Return ("Server=$($This.SQLServer);Database=$($This.Database);Integrated Security=SSPI;Connection Timeout=$($This.ConnectionTimeout)")
        # Return ("Data Source=$($This.SQLServer);Initial Catalog=$($This.Database);Integrated Security=True;Connect Timeout=$($This.ConnectionTimeout);Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False")
    }

    [String]BuildOleDbConnectionString() {
        # Return ("Provider=MSOLEDBSQL;Data Source=$($This.SQLServer);Initial Catalog=$($This.Database);Integrated Security=SSPI;Connection Timeout=$($This.ConnectionTimeout)")
        # Return ("Provider=MSOLEDBSQL;Server=$($This.SQLServer);Initial Catalog=$($This.Database);Integrated Security=SSPI;Connection Timeout=$($This.ConnectionTimeout)")
        # Return ("Provider=MSOLEDBSQL;Server=$($This.SQLServer);Database=$($This.Database);Trusted_Connection=yes")
        # Return ("Provider=MSOLEDBSQL;DataTypeCompatibility=80;Server=$($This.SQLServer);Database=$($This.Database);Trusted_Connection=yes")
        # Return ("Provider=MSOLEDBSQL;Driver={ODBC Driver 17 for SQL Server};Server=$($This.SQLServer);Database=$($This.Database);Trusted_Connection=yes;Connection Timeout=$($This.ConnectionTimeout)")
        Return ("Provider=MSOLEDBSQL;Server=$($This.SQLServer);Database=$($This.Database);Trusted_Connection=yes;Connection Timeout=$($This.ConnectionTimeout)")
        <#
        All the above: "Could not find server 'System' in sys.servers. 
          Verify that the correct server name was specified. 
          If necessary, execute the stored procedure sp_addlinkedserver to add the server to sys.servers."
        #>
    }

    # Method
    LoadQueryFromFile([String]$Path) {
        If (Test-Path $Path) {
            If ([IO.Path]::GetExtension($Path) -ne ".sql") {
                throw [System.IO.FileFormatException] "'$Path' does not have an '.sql' extension'"
            } Else {
                Try {
                    [String]$QueryStatement = Get-Content -Path $Path -Raw -ErrorAction Stop
                    $This.TableIndex = $This.AddQuery($QueryStatement)
                    $This.Tables[$This.TableIndex].QueryFile = $Path
                } Catch {
                    Write-host ($_ | Out-String) -ForegroundColor Red 
                }
            }
       } Else {
         throw [System.IO.FileNotFoundException] "'$Path' not found"
       }
    }

    # Method
    [void] OpenConnection() {
        #If localDB, Get Instance Name
        $localdb = ($This.SQLConnection.DataSource -split '\\')[-1]
        If (-not $localdb) {
            $localdb = ($This.ConnectionString -split ';').Where({$_.StartsWith('Data Source')}).ForEach({$_ -split '\\'})[-1]
        }
        $status = ((SqlLocalDB.exe info "$localdb") -split [environment]::NewLine).Where({$_})
        Switch ($status.Where({$_.StartsWith('State:')}).ForEach({($_ -split ' ')[-1]})) {
            'Stopped' {SqlLocalDB.exe Start "$localdb" ; break}
        }
        If ($This.SQLConnection -and $This.SQLConnection.State -eq 'Open' -and $This.KeepAlive) {
            Return
        } ElseIf ($This.SQLConnection -and $This.SQLConnection.State -ne 'Open') {
            $This.SQLConnection.Open()
        } Else {
            If ($This.SQLConnection -and -not $This.KeepAlive) {
                If ($This.SQLConnection.State -eq 'Open') {
                    $This.SQLConnection.Close()
                }
                $This.SQLConnection.Dispose()
            }

            If (-not $This.ConnectionString) {
                $This.ConnectionString = $This.BuildConnectionString()
            }

            If ($This.SQLConnection.State -ne 'Open') {
                $This.SQLConnection = [System.Data.SqlClient.SqlConnection]::new()
                $This.SQLConnection.ConnectionString = $This.ConnectionString
                Try {
                    $This.SQLConnection.Open()
                } Catch {
                    $This.CloseConnection()
                    Write-host ($_ | Out-String) -ForegroundColor Red
                }
            }
        }
    }

    # Method
    [void] CloseConnection() {
        If ($This.SQLConnection) {
            $This.SQLConnection.Close()
            $This.SQLConnection.Dispose()
            $This.SQLConnection = $null
        }
    }

    # Method
    [System.Data.SqlClient.SqlCommand] GetSqlCommand([string]$query) {
        $This.OpenConnection()
        $SQLCommand = $This.SQLConnection.CreateCommand()
        $SQLCommand.CommandText = $query
        $SQLCommand.CommandTimeout = $This.CommandTimeout
        $SQLCommand.Connection = $This.SQLConnection
        Return $SQLCommand
    }

    [void] Clear() {
        $This.CloseConnection()
        $This.SQLServer = $null
        $This.Database = $null
        $This.ConnectionTimeout = 5
        $This.CommandTimeout = 600
        $This.ConnectionString = $null
        $This.SQLConnection = $null
        $This.TableIndex = 0
        $This.Tables.Clear()
        $This.TableNames.Clear()
        $This.DisplayResults = $True
        $This.KeepAlive = $False
    }

    # Method
    [Object] Execute() {
        $table = $This.Tables[$This.TableIndex]
        Return $This.Execute($table)
    }
    # Method
    [Object] Execute([SqlQueryTable]$table) {
        $SQLReader = $null
        $table.SQLCommand = GetSqlCommand($table.Query)
        Try {
            If ($table.ResultType -in @([ResultType]::DataTable, [ResultType]::DataRows)) {
                $SQLReader = $table.SQLCommand.ExecuteReader()
                If ($SQLReader) {
                    $table.Result = [System.Data.DataTable]::new()
                    $table.Result.Load($SQLReader)
                    If ($This.DisplayResults) {
                        If ($table.ResultType -eq [ResultType]::DataTable) {
                            Return ,$table.Result
                        } Else {
                            Return $table.Result
                        }
                    }
                }
            } ElseIf ($table.ResultType -eq [ResultType]::DataAdapter) {
                $table.Result = [System.Data.DataSet]::new()
                $table.SqlDataAdapter = [System.Data.SqlClient.SqlDataAdapter]::new($table.SQLCommand)
                [void]$table.SqlDataAdapter.Fill($table.Result)

                # $SqlCommandBuilder = [System.Data.SqlClient.SqlCommandBuilder]::new($table.SqlDataAdapter)
                # $SqlCommandBuilder.DataAdapter = $table.SqlDataAdapter
                # $SqlCommandBuilder.QuotePrefix = "["
                # $SqlCommandBuilder.QuoteSuffix = "]"
                # Try { $table.SqlDataAdapter.DeleteCommand = $SqlCommandBuilder.GetDeleteCommand()
                # } Catch { 
                #     Write-Warning "Failed to get DeleteCommand: $_"
                # }
                # Try { $table.SqlDataAdapter.UpdateCommand = $SqlCommandBuilder.GetUpdateCommand()
                # } Catch {
                #     Write-Warning "Failed to get UpdateCommand: $_" 
                # }
                # Try { $table.SqlDataAdapter.InsertCommand = $SqlCommandBuilder.GetInsertCommand()
                # } Catch {
                #     Write-Warning "Failed to get InsertCommand: $_" 
                # }

                If ($This.DisplayResults) {
                    Return $table.Result.Tables[0]
                }
            } ElseIf ($table.ResultType -eq [ResultType]::DataSet) {
                $table.Result = [System.Data.DataSet]::new()
                $table.SqlDataAdapter = [System.Data.SqlClient.SqlDataAdapter]::new($table.SQLCommand)
                [void]$table.SqlDataAdapter.Fill($table.Result)
                If ($This.DisplayResults) {
                    Return $table.Result.Tables[0]
                }
            } ElseIf ($table.ResultType -eq [ResultType]::NonQuery) {
                $table.Result = $table.SQLCommand.ExecuteNonQuery()
                Return $table.Result
            }
        } Catch {
            $This.SQLConnection.Close()
            Return $(Write-host ($_ | Out-String) -ForegroundColor Red)           
        } Finally {
            If (-not $this.KeepAlive) {
                $This.CloseConnection()
            }
            If ($SQLReader -and -not $SQLReader.IsClosed) {
                $SQLReader.Close()
                $SQLReader.Dispose()
            }
        }
        Return $null
    }

    # Method
    [Object] Execute([Int]$TableIndex) {
        If ($TableIndex -ge 0) {
            $This.TableIndex = $TableIndex
        }
        $table = $This.Tables[$TableIndex]
        Return ($This.Execute($table))
    }

    # Method
    [Object] Execute([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
        }
        $table = $This.Tables[$This.TableIndex]
        Return ($This.Execute($table))
    }

    # Method
    [Object] Execute([ResultType]$ResultType) {
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = $ResultType
        Return ($This.Execute($table))
    }

    # Method
    [Object] ExecuteNonQuery([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::NonQuery
        Return ($This.Execute($table))
    }

    # Method
    [Object] ExecuteQuery([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::DataTable
        Return ($This.Execute($table))
    }

    [Object] ExecuteQuery([String]$TableName, [String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery, $TableName)
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::DataTable
        Return ($This.Execute($table))
    }

    # Method
    [Object] ExecuteAsDataTable([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
            $table = $This.Tables[$This.TableIndex]
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::DataTable
        Return ($This.Execute($table))
    }

    # Method
    [Object] ExecuteAsDataAdapter([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::DataAdapter
        Return ($This.Execute($table))
    }

    # Method
    [Object] ExecuteAsDataSet([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::DataSet
        Return ($This.Execute($table))
    }

    # Method
    [Object] ExecuteAsDataRows([String]$SqlQuery) {
        If ($SqlQuery) {
            $This.TableIndex = $This.AddQuery($SqlQuery)
        }
        $table = $This.Tables[$This.TableIndex]
        $table.ResultType = [ResultType]::DataRows
        Return ($This.Execute($table))
    }

    # Method
    [Object] SaveChanges() {
        $table = $This.Tables[$This.TableIndex]
        If ($This.ConnectionString) {
            $SaveChangesConnectionString = $This.ConnectionString
        } Else {
            $SaveChangesConnectionString = $This.BuildConnectionString()
        }

        $SaveChangesConnection = [System.Data.SqlClient.SqlConnection]::new()
        $SaveChangesConnection.ConnectionString = $SaveChangesConnectionString

        Try {
            $This.KeepAlive = $false
            $This.OpenConnection()

            #--------------------------------------------------
            # Create a DataView to examine the changes
            #--------------------------------------------------
            # $dataView = [System.Data.DataView]::new($This.Tables[0].Result.Tables[0])
            # # Set the RowStateFilter to display only added and modified rows.
            # $dataView.RowStateFilter = ([System.Data.DataViewRowState]::Deleted -bor [System.Data.DataViewRowState]::Added -bor [System.Data.DataViewRowState]::ModifiedCurrent)
            # ForEach ($row in $dataView) {Write-Host ($row | FT -AutoSize | Out-String).Trim()}
            # Write-Host ($dataView | FT -AutoSize | Out-String).Trim()

            $commandBuilder = [System.Data.SqlClient.SqlCommandBuilder]::new($table.SqlDataAdapter)
            $table.SqlDataAdapter.UpdateCommand = $commandBuilder.GetUpdateCommand()
            $table.SqlDataAdapter.InsertCommand = $commandBuilder.GetInsertCommand()
            $table.SqlDataAdapter.DeleteCommand = $commandBuilder.GetDeleteCommand()

            If ($table.ResultType -in @([ResultType]::DataAdapter,[ResultType]::DataSet)) {
                $table.SqlDataAdapter.Update($table.Result.Tables[0])
            } ElseIf ($table.ResultType -eq [ResultType]::DataTable) {
                $table.SqlDataAdapter.Update($table.Result)
            }

            If (-not [String]::IsNullOrEmpty($table.SqlDataAdapter.DeleteCommand)) {
                $table.SqlDataAdapter.DeleteCommand.Connection = $This.SQLConnection
            }
            If (-not [String]::IsNullOrEmpty($table.SqlDataAdapter.UpdateCommand)) {
                $table.SqlDataAdapter.UpdateCommand.Connection = $This.SQLConnection
            }
            If (-not [String]::IsNullOrEmpty($table.SqlDataAdapter.InsertCommand)) {
                $table.SqlDataAdapter.InsertCommand.Connection = $This.SQLConnection
            }
            
            Try { # First process deletes.
                $table.SqlDataAdapter.Update($table.Result.Tables[0].Select($null, $null, [System.Data.DataViewRowState]::Deleted))
            } Catch {
                Write-Warning "Handled an exception in the delete process: $($_.Exception.Message)"
            }
            
            Try { # Next process updates.
                $table.SqlDataAdapter.Update($table.Result.Tables[0].Select($null, $null, [System.Data.DataViewRowState]::ModifiedCurrent))
            } Catch {
                Write-Warning "Handled an exception in the delete process: $($_.Exception.Message)"
            }
            
            Try { # Finally, process inserts.
                $table.SqlDataAdapter.Update($table.Result.Tables[0].Select($null, $null, [System.Data.DataViewRowState]::Added))
                $table.Result.Tables[0].AcceptChanges()
            } Catch {
                Write-Warning "Handled an exception in the delete process: $($_.Exception.Message)"
            }
        } Catch {
            return $(Write-host ($_ | Out-String) -ForegroundColor Red) 
        } Finally {
            $table.Result.AcceptChanges()
            $This.CloseConnection()
        }

        If ($This.DisplayResults) {
            Return $table.Result.Tables[0]
        } Else {
            Return $null
        }
    }

    # Method to Retrieve Table Schema
    [Object] GetDBTableSchema([String]$TableName) {
        $SqlQuery = "SELECT * FROM [$($This.Database)].INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$TableName';"
        # $SqlQuery = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM [$($This.Database)].INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$TableName';"
        Return ($This.ExecuteQuery($SqlQuery))
    }

    # Method to Retrieve Table Indexes from SQL v17 or higher using STRING_AGG
    [Object] GetDBTableIndexesV17([String]$TableName) {
        $query = "SELECT i.name AS INDEX_NAME, 
                        STRING_AGG(c.name, ', ') AS COLUMN_NAMES,
                        i.is_unique AS IS_UNIQUE
                FROM sys.indexes AS i
                JOIN sys.index_columns AS ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
                JOIN sys.columns AS c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                WHERE i.object_id = OBJECT_ID('dbo.$TableName')
                GROUP BY i.name, i.is_unique"
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($query, $This.ConnectionString)
        $indexTable = New-Object System.Data.DataTable
        $adapter.Fill($indexTable)
        return $indexTable
    }

    # Method to Retrieve Table Indexes Without STRING_AGG
    [Object] GetDBTableIndexes([String]$TableName) {
        $SqlQuery = "SELECT i.name AS INDEX_NAME, 
                        STUFF((SELECT ', ' + c.name
                                FROM [$($This.Database)].sys.index_columns AS ic
                                JOIN [$($This.Database)].sys.columns AS c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                                WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
                                FOR XML PATH('')), 1, 2, '') AS COLUMN_NAMES,
                        i.is_unique AS IS_UNIQUE
                FROM [$($This.Database)].sys.indexes AS i
                WHERE i.object_id = OBJECT_ID('dbo.$TableName')
                GROUP BY i.name, i.is_unique, i.object_id, i.index_id"
        Return ($This.ExecuteQuery($SqlQuery))
    }

    # Method to Generate the CREATE TABLE statement
    [Object] GetCreateBasicDLL([String]$TableName) {
        $schemaTable = $This.GetDBTableSchema($TableName)
        $createTableStatement = "USE [$($This.Database)]" + [Environment]::NewLine +
            "GO" + [Environment]::NewLine + [Environment]::NewLine +
            "CREATE TABLE [$TableName] (" + [Environment]::NewLine
        foreach ($column in $schemaTable.Rows) {
            $columnName = $column.COLUMN_NAME
            $dataType = $column.DATA_TYPE
            $maxLength = if ($column.CHARACTER_MAXIMUM_LENGTH -ne -1) { "($($column.CHARACTER_MAXIMUM_LENGTH))" } else { "" }
            $nullable = if ($column.IS_NULLABLE -eq "YES") { "NULL" } else { "NOT NULL" }
            $createTableStatement += "    [$columnName] $dataType$maxLength $nullable," + [Environment]::NewLine
        }
        # Remove the last comma and add closing parenthesis
        $createTableStatement = $createTableStatement.TrimEnd(",`r`n".ToCharArray()) + [Environment]::NewLine + ");"
        Return ($createTableStatement)
    }

    # Method to Generate the CREATE TABLE statement
    [Object] GetCreateDDL([String]$TableName) {
        $schemaTable = $This.GetDBTableSchema($TableName)
        $indexTable = $This.GetDBTableIndexes($TableName)

        $createTableStatement = "USE [$($This.Database)]" + [Environment]::NewLine +
                                "GO" + [Environment]::NewLine + [Environment]::NewLine +
                                "/****** Object: Table [dbo].[$TableName] Script Date: $(Get-Date -Format 'MM/dd/yyyy hh:mm:ss tt') ******/" + [Environment]::NewLine +
                                "SET ANSI_NULLS ON" + [Environment]::NewLine +
                                "GO" + [Environment]::NewLine + [Environment]::NewLine +
                                "SET QUOTED_IDENTIFIER ON" + [Environment]::NewLine +
                                "GO" + [Environment]::NewLine + [Environment]::NewLine +
                                "CREATE TABLE [dbo].[$TableName] (" + [Environment]::NewLine

        foreach ($column in $schemaTable.Rows) {
            $columnName = $column.COLUMN_NAME
            $dataType = $column.DATA_TYPE
            $maxLength = if ($column.CHARACTER_MAXIMUM_LENGTH -ne -1) { "($($column.CHARACTER_MAXIMUM_LENGTH))" } else { "" }
            $nullable = if ($column.IS_NULLABLE -eq "YES") { "NULL" } else { "NOT NULL" }
            $identity = if ($column.COLUMN_NAME -eq "Id") { "IDENTITY (1, 1)" } else { "" }
            $createTableStatement += "    [$columnName] $dataType$maxLength $identity $nullable," + [Environment]::NewLine
        }

        # Remove the last comma and add closing parenthesis
        $createTableStatement = $createTableStatement.TrimEnd(",`r`n".ToCharArray()) + [Environment]::NewLine + ");" + [Environment]::NewLine + [Environment]::NewLine
        # $createTableStatement = $createTableStatement.TrimEnd(",`r`n".ToCharArray()) + [Environment]::NewLine + "), PRIMARY KEY CLUSTERED ([Id] ASC);" + [Environment]::NewLine + [Environment]::NewLine

        # Add index creation statements, excluding the primary key index
        foreach ($index in $indexTable.Rows) {
            if ($index.INDEX_NAME -notlike 'PK__*') {
                $indexName = $index.INDEX_NAME
                $columnNames = $index.COLUMN_NAMES
                $unique = if ($index.IS_UNIQUE -eq 1) { "UNIQUE " } else { "" }
                $createTableStatement += "GO" + [Environment]::NewLine +
                                        "CREATE $($unique)NONCLUSTERED INDEX [$indexName]" + [Environment]::NewLine +
                                        "    ON [dbo].[$TableName]([$columnNames] ASC);" + [Environment]::NewLine
            }
        }
        return $createTableStatement
    }

    # Method to Parse SQL Statements to extract the Schema and TableName. Support Multi-line Select From statements
    [Object] ParseSQLQuery([String]$Query) {
        $queryPattern = '([\s\t]*FROM[\s\t\r\n](?<schemaTable>[A-Za-z0-9_.\[\]]+).*$)|((?s)[\s\t]*FROM[\s\t\r\n]+(?<schemaTable>[A-Za-z0-9_. \[\] ]+).*$)'

        If ($Query -like '*\*' -and $Query -like '*.MDF*') {
            $queryPattern = '([\s\t]*FROM[\s\t\r\n](?<databaseName>[\[]?[A-Za-z0-9_\:\\]+[\.MDF]{4}[\]]?)[.]{1}(?<schemaTable>[A-Za-z0-9_.\[\]]+).*$)'
        } Else {
            $queryPattern = '([\s\t]*FROM[\s\t\r\n](?<schemaTable>[A-Za-z0-9_.\[\]]+).*$)|((?s)[\s\t]*FROM[\s\t\r\n]+(?<schemaTable>[A-Za-z0-9_. \[\] ]+).*$)'
        }
        $schemaTablePattern = '([\[]?(?<tableName>[A-Za-z0-9_]+)[\.\[\] ]?$)|([\[]?(?<schema>[A-Za-z0-9_]+)[\.\[\]]*(?<tableName>[A-Za-z0-9_]+)[\.\[\] ]?$)'
        $retResult = ([PSCustomObject]@{
            dataBase = [string]::Empty
            schemaTable = [string]::Empty
            Schema = [string]::Empty
            TableName = [string]::Empty
        })
        If ($Query -match $queryPattern) {
            $retResult.schemaTable = $Matches.schemaTable
            $retResult.dataBase = $Matches.databaseName
            If ($retResult.schemaTable -match $schemaTablePattern) {
                $retResult.schema = $Matches.schema
                $retResult.TableName = $Matches.tableName
            }
        }
        Return ($retResult)
    }

}
