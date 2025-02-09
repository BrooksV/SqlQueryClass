# WPF Usage Guide

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setting Up the Environment](#setting-up-the-environment)
- [Creating the WPF Application](#creating-the-wpf-application)
  - [XAML Layout](#xaml-layout)
  - [PowerShell Code-Behind Example](#powershell-code-behind-example)
- [Binding Data to the DataGrid](#binding-data-to-the-datagrid)
  - [Creating the SqlQueryDataSet Instance](#creating-the-sqlquerydataset-instance)
  - [Executing the Query](#executing-the-query)
  - [Binding the DataTable to the DataGrid](#binding-the-datatable-to-the-datagrid)
- [Handling CRUD Operations](#handling-crud-operations)
  - [Adding New Rows](#adding-new-rows)
  - [Updating Existing Rows](#updating-existing-rows)
  - [Deleting Rows](#deleting-rows)
  - [Saving Changes](#saving-changes)
- [Advanced Topics](#advanced-topics)
  - [Handling Complex Queries](#handling-complex-queries)
  - [Using Multiple DataGrids](#using-multiple-datagrids)
  - [Customizing DataGrid Columns](#customizing-datagrid-columns)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

## Introduction

This guide provides detailed instructions on how to use the `SqlQueryClass` module to bind the `SqlQueryTable` class result as a `DataTable` to a WPF `DataGrid` component. This allows for seamless integration of SQL query results into a WPF application, enabling data manipulation and display.

## Prerequisites

Before you begin, ensure you have the following:

- Visual Studio or Visual Studio Code installed
- Basic knowledge of WPF and XAML
- SQL Server or SQL Express installed
- The `SqlQueryClass` module installed
- The example code below uses tests configuration and sample SQL Express database from [GitHub `SqlQueryClass` repository](https://github.com/BrooksV/SqlQueryClass)
- - Clone the Repository to C:\Git folder to maintain compatibility with the sample and test data

## Setting Up the Environment

1. Install the `SqlQueryClass` module if you haven't already:

    ```powershell
    Install-Module -Name SqlQueryClass -Repository PSGallery -Scope CurrentUser
    ```

    <button onclick="copyToClipboard('#install-module')">Copy</button>

2. Create a new WPF project in Visual Studio or Visual Studio Code.

## Creating the WPF Application

### XAML Layout

Define the layout of your WPF application in the `MainWindow.xaml` file. Add a `DataGrid` component to display the data.

The [PowerShell Code-Behind Example](#powershell-code-behind-example) uses the XAML in-line to avoid having to read from disk.

```xml
<Window x:Class="SqlQueryWpfApp.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SQL Query DataGrid" Height="450" Width="800">
    <Grid>
        <DataGrid x:Name="dataGrid" AutoGenerateColumns="True" />
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="10">
            <Button x:Name="saveButton" Content="Save" Width="75" Margin="5"/>
            <Button x:Name="quitButton" Content="Quit" Width="75" Margin="5"/>
        </StackPanel>
    </Grid>
</Window>
```

<button onclick="copyToClipboard('#xaml-layout')">Copy</button>

### PowerShell Code-Behind Example

Code-Behind is a PowerShell example script `WPF_SqlQueryClassUsageExample.ps1` to demonstrate the usage of the SqlQueryClass module in a WPF application and how to bind data to the `DataGrid`.

```powershell
Add-Type -AssemblyName PresentationFramework

# Define variable `$syncHash` for global use to store synchronized data and provide access to object data.
$syncHash = [System.Collections.Hashtable]::Synchronized((New-Object System.Collections.Hashtable))
$syncHash.Add('UI', [PSCustomObject]@{
    SqlResults = $null
})

# Database Configuration
# Using sample database configuration data from tests `.\tests\TestDatabase1.parameters.psd1` and the SQL Express test database `.\tests\TestDatabase1.mdf`.

$SqlServer = '(localdb)\MSSQLLocalDB'
$Database = 'TestDatabase1'
$ConnectionString = "Data Source=$SqlServer;AttachDbFilename=C:\Git\SqlQueryClass\tests\TestDatabase1.mdf;Integrated Security=True"

# Use the `New-SqlQueryDataSet` function to create and initialize the `SqlQueryDataSet` instance.
$syncHash.UI.SqlResults = New-SqlQueryDataSet -SQLServer $SqlServer -Database $Database -ConnectionString $ConnectionString

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SQL Query DataGrid" Height="450" Width="800">
    <Grid>
        <DataGrid x:Name="dataGrid" AutoGenerateColumns="True" />
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="10">
            <Button x:Name="saveButton" Content="Save" Width="75" Margin="5"/>
            <Button x:Name="quitButton" Content="Quit" Width="75" Margin="5"/>
        </StackPanel>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$dataGrid = $window.FindName("dataGrid")
$saveButton = $window.FindName("saveButton")
$quitButton = $window.FindName("quitButton")

$syncHash.UI.SqlResults.ExecuteQuery("SELECT * FROM myTable")
$dataGrid.ItemsSource = $syncHash.UI.SqlResults.Tables[0].Result.DefaultView

# Event handler for Save button
$saveButton.Add_Click({
    $syncHash.UI.SqlResults.SaveChanges()
    [System.Windows.MessageBox]::Show("Changes saved successfully.", "Save", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
})

# Event handler for Quit button
$quitButton.Add_Click({
    $window.Close()
})

$window.ShowDialog() | Out-Null
```

<button onclick="copyToClipboard('#powershell-code-behind')">Copy</button>

## Binding Data to the DataGrid

### Creating the SqlQueryDataSet Instance

Create an instance of the `SqlQueryDataSet` class and configure the necessary properties such as `SQLServer`, `Database`, or `ConnectionString`.

```powershell
$syncHash.UI.SqlResults = New-SqlQueryDataSet -SQLServer $SqlServer -Database $Database
$syncHash.UI.SqlResults = New-SqlQueryDataSet -SQLServer -ConnectionString $ConnectionString
```

### Executing the Query

Use the `ExecuteQuery` method to execute the SQL query and retrieve the results.

### Binding the DataTable to the DataGrid

Bind the `DataTable` result to the `DataGrid` by setting the `ItemsSource` property to the `DefaultView` of the `DataTable`.

## Handling CRUD Operations

### Adding New Rows

To add new rows to the `DataGrid`, modify the `DataTable` and call the `SaveChanges` method on the `SqlQueryDataSet` instance.

### Updating Existing Rows

To update existing rows, modify the `DataTable` and call the `SaveChanges` method.

### Deleting Rows

To delete rows, remove them from the `DataTable` and call the `SaveChanges` method.

### Saving Changes

Call the `SaveChanges` method on the `SqlQueryDataSet` instance to persist changes to the database.

## Advanced Topics

### Handling Complex Queries

Learn how to handle complex queries and multiple result sets.

### Using Multiple DataGrids

Bind multiple `DataGrids` to different `DataTables` within the same `SqlQueryDataSet` instance.

### Customizing DataGrid Columns

Customize the columns of the `DataGrid` to display specific data and apply formatting.

## Troubleshooting

Common issues and solutions when working with the `SqlQueryClass` module and WPF `DataGrid`.

## Conclusion

By following this guide, you can effectively bind SQL query results to a WPF `DataGrid` using the `SqlQueryClass` module. This enables seamless data manipulation and display within your WPF applications.

<script>
function copyToClipboard(element) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(element).text()).select();
    document.execCommand("copy");
    $temp.remove();
}
</script>
