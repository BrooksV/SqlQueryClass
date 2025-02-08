Describe 'New-SqlQueryDataSet' {
    BeforeAll {
        $data = Get-MTProjectInfo
        # Import-Module -Name "$($data.ProjectName)" -Verbose -Force
        Import-Module "$($data.ManifestFilePSD1)" -Verbose -Force
        $fsoParamFile = [System.IO.FileInfo]("$($data.ProjectRoot)/tests/TestDatabase1.parameters.psd1")
        $params = @{}
        If ($fsoParamFile.Exists) {
            Write-Host ("Loading Parameters from: $($fsoParamFile.FullName)")
            $params = Import-PowerShellDataFile -Path $fsoParamFile.FullName
            $DatabasePath = "$($data.ProjectRoot)/tests/$($params.Database)"
            $params.ConnectionString = $params.ConnectionString -replace "$($params.Database)",$DatabasePath
            $params.Database = $DatabasePath
        }
        Write-Host ("Parameters: $($params | Out-String)")
    }

    Context 'When using No Parameters' {
        It 'Should create an instance with No Parameters' {
            $result = New-SqlQueryDataSet
            $result | Should -Not -BeNullOrEmpty
            $result.Database | Should -BeNullOrEmpty
            $result.SQLServer | Should -BeNullOrEmpty
            $result.ConnectionString | Should -BeNullOrEmpty
            $result.Tables | Should -BeNullOrEmpty
            $result.TableNames | Should -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 0
        }
    }

    Context 'When using SQLServer' {
        It 'Should create an instance with SQLServer' {
            $result = New-SqlQueryDataSet -SQLServer $params.SqlServer
            $result | Should -Not -BeNullOrEmpty
            $result.SQLServer | Should -Be $params.SqlServer
            $result.Database | Should -BeNullOrEmpty
        }
    }

    Context 'When using Database' {
        It 'Should create an instance with Database' {
            $result = New-SqlQueryDataSet -Database $params.Database
            $result | Should -Not -BeNullOrEmpty
            $result.Database | Should -Be $params.Database
            $result.SQLServer | Should -BeNullOrEmpty
        }
    }

    Context 'When using SQLServer and Database' {
        It 'Should create an instance with SQLServer and Database' {
            $result = New-SqlQueryDataSet -SQLServer $params.SqlServer -Database $params.Database
            $result | Should -Not -BeNullOrEmpty
            $result.SQLServer | Should -Be $params.SqlServer
            $result.Database | Should -Be $params.Database
        }
    }

    Context 'When using ConnectionString' {
        It 'Should create an instance with ConnectionString' {
            $result = New-SqlQueryDataSet -ConnectionString $params.ConnectionString
            $result | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Be $params.ConnectionString
        }
    }

    Context 'When using ConnectionString SQLServer and Database' {
        It 'Should create an instance with ConnectionString, SQLServer, and Database' {
            $result = New-SqlQueryDataSet -SQLServer $params.SqlServer -Database $params.Database -ConnectionString $params.ConnectionString
            $result | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Be $params.ConnectionString
            $result.SQLServer | Should -Be $params.SqlServer
            $result.Database | Should -Be $params.Database
        }
    }

    Context 'When using SQLServer, Database, and Query' {
        It 'Should create an instance with SQLServer, Database, and Query' {
            $result = New-SqlQueryDataSet -SQLServer $params.SqlServer -Database $params.Database -Query "SELECT * FROM myTable"
            $result | Should -Not -BeNullOrEmpty
            $result.SQLServer | Should -Be $params.SqlServer
            $result.Database | Should -Be $params.Database
            $result.TableIndex | Should -Be 0
            $result.Tables | Should -Not -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 1
            $result.Tables[$result.TableIndex].TableIndex | Should -Be $result.TableIndex
            $result.Tables[$result.TableIndex].TableName | Should -Be "myTable"
            $result.Tables[$result.TableIndex].Query | Should -Be "SELECT * FROM myTable"
        }
    }

    Context 'When using ConnectionString and Query' {
        It 'Should create an instance with ConnectionString and Query' {
            $result = New-SqlQueryDataSet -ConnectionString $params.ConnectionString -Query $params.Query
            $result | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Be $params.ConnectionString
            $result.TableIndex | Should -Be 0
            $result.Tables | Should -Not -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 1
            $result.Tables[$result.TableIndex].TableIndex | Should -Be $result.TableIndex
            $result.Tables[$result.TableIndex].TableName | Should -Be "TABLES"
            $result.Tables[$result.TableIndex].Query | Should -Be $params.Query
            $result.Tables[$result.TableIndex].ResultType | Should -Be 'DataTable'
        }
    }

    Context 'When using ConnectionString, Query, and TableName' {
        It 'Should create an instance with ConnectionString and Query' {
            $result = New-SqlQueryDataSet -ConnectionString $params.ConnectionString -Query $params.Query -TableName $params.TableName
            $result | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Be $params.ConnectionString
            $result.TableIndex | Should -Be 0
            $result.Tables | Should -Not -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 1
            $result.Tables[$result.TableIndex].TableIndex | Should -Be $result.TableIndex
            $result.Tables[$result.TableIndex].TableName | Should -Be $params.TableName
            $result.Tables[$result.TableIndex].Query | Should -Be $params.Query
            $result.Tables[$result.TableIndex].ResultType | Should -Be 'DataTable'
        }
    }

    Context 'When using Query and TableName' {
        It 'Should create an instance with Query and TableName' {
            $result = New-SqlQueryDataSet -Query $params.Query -TableName $params.TableName
            $result | Should -Not -BeNullOrEmpty
            $result.Database | Should -BeNullOrEmpty
            $result.SQLServer | Should -BeNullOrEmpty
            $result.ConnectionString | Should -BeNullOrEmpty
            $result.TableIndex | Should -Be 0
            $result.Tables | Should -Not -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 1
            $result.Tables[$result.TableIndex].TableIndex | Should -Be $result.TableIndex
            $result.Tables[$result.TableIndex].TableName | Should -Be $params.TableName
            $result.Tables[$result.TableIndex].Query | Should -Be $params.Query
            $result.Tables[$result.TableIndex].ResultType | Should -Be 'DataTable'
        }
    }

    Context 'When using Query' {
        It 'Should create an instance with Query' {
            $result = New-SqlQueryDataSet -Query $params.Query
            $result | Should -Not -BeNullOrEmpty
            $result.Database | Should -BeNullOrEmpty
            $result.SQLServer | Should -BeNullOrEmpty
            $result.ConnectionString | Should -BeNullOrEmpty
            $result.TableIndex | Should -Be 0
            $result.Tables | Should -Not -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 1
            $result.Tables[$result.TableIndex].TableIndex | Should -Be $result.TableIndex
            $result.Tables[$result.TableIndex].TableName | Should -Be 'TABLES'
            $result.Tables[$result.TableIndex].Query | Should -Be $params.Query
            $result.Tables[$result.TableIndex].ResultType | Should -Be 'DataTable'
        }
    }

    Context 'When using TableName' {
        It 'Should create an instance with no configuration as TableName is ignored without Query' {
            $result = New-SqlQueryDataSet -TableName $params.TableName
            $result | Should -Not -BeNullOrEmpty
            $result.Database | Should -BeNullOrEmpty
            $result.SQLServer | Should -BeNullOrEmpty
            $result.ConnectionString | Should -BeNullOrEmpty
            $result.Tables | Should -BeNullOrEmpty
            $result.TableNames | Should -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 0
        }
    }

    Context 'When using DisplayResults' {
        It 'Should create an instance with DisplayResults set to false' {
            $result = New-SqlQueryDataSet -DisplayResults $false
            $result | Should -Not -BeNullOrEmpty
            $result.Database | Should -BeNullOrEmpty
            $result.SQLServer | Should -BeNullOrEmpty
            $result.ConnectionString | Should -BeNullOrEmpty
            $result.Tables | Should -BeNullOrEmpty
            $result.TableNames | Should -BeNullOrEmpty
            $result.TableNames.Count | Should -Be 0
            $result.DisplayResults | Should -Be $false
        }
    }
}


# Create a new SQL Server connection
$connectionString = "Data Source=(localdb)\MSSQLLocalDB;Integrated Security=True"
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$connection.Open()

# Create a command to detach the database
$detachCommand = $connection.CreateCommand()
$detachCommand.CommandText = "EXEC sp_detach_db 'DATABASE1'"
$detachCommand.ExecuteNonQuery()
$connection.Close()

# Define the source and destination paths
$sourcePath = "F:\DATA\BILLS\PSSCRIPTS\SCANMYBILLS\DATABASE1.MDF"
$destinationPath = "C:\Git\SqlQueryClass\tests\TestDatabase1.mdf"

# Move and rename the file
Move-Item -Path $sourcePath -Destination $destinationPath

# Create a new SQL Server connection
$connection.Open()

# Create a command to attach the database
$attachCommand = $connection.CreateCommand()
$attachCommand.CommandText = @"
CREATE DATABASE TestDatabase1
ON (FILENAME = 'C:\Git\SqlQueryClass\tests\TestDatabase1.mdf')
FOR ATTACH
"@
$attachCommand.ExecuteNonQuery()
$connection.Close()

$ConnectionString = 'Data Source=(localdb)\MSSQLLocalDB;AttachDbFilename=C:\Git\SqlQueryClass\tests\TestDatabase1.mdf;Integrated Security=True'


