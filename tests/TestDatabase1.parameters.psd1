@{
    "ConnectionString" = "Data Source=(localdb)\MSSQLLocalDB;AttachDbFilename=DATABASE1.MDF;Integrated Security=True";
    "TableName" = "DBTable";
    "SqlServer" = "(localdb)\MSSQLLocalDB";
    "Database" = "DATABASE1.MDF";
    "Query" = "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = `'BASE TABLE`' ORDER BY TABLE_SCHEMA, TABLE_NAME;"
}
