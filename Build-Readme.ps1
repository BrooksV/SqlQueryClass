<#
. "C:\Git\SqlQueryClass\Build-Readme.ps1" -- Generates a README.md file but saves it as .\archive\ModuleDoc.md to prevent overwriting 

#>


<# # >
# $TestQuery.ExecuteQuery('DBTables', $Query)
# enum ResultType { DataTable; DataRows; DataAdapter; DataSet; NonQuery; }

$projectData = Get-MTProjectInfo

Remove-Module -Name SqlQueryClass -Force -Verbose
# Import-Module -Name SqlQueryClass -Force -Verbose
Import-Module C:\Git\SqlQueryClass\dist\SqlQueryClass\SqlQueryClass.psd1 -Verbose -Force

# Configure Database settings for connection
$SqlServer = '(localdb)\MSSQLLocalDB'
$DatabaseName = 'C:\Git\SqlQueryClass\tests\TestDatabase1.mdf'
$ConnectionString = "Data Source={0};AttachDbFilename={1};Integrated Security=True" -f $SqlServer, $DatabaseName
$Query = "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_SCHEMA, TABLE_NAME;"

$TestQuery = New-SqlQueryDataSet -SQLServer $SqlServer -Database $DatabaseName -ConnectionString $ConnectionString -DisplayResults $false
[void]$TestQuery.AddQuery('DBTables', $Query)

Function Get-ClassMemberData {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [PSObject]$InputObject,
        [String[]]$excludeMembers
    )
    Begin {
        If ($InputObject -is [System.Array]) {
            Throw "-InputObject cannot be an Array or Collection"
        }
        If (-not $excludeMembers) {
            $excludeMembers = @'
GetType
ToString
Equals
GetHashCode
'@ -split [System.Environment]::NewLine
        }
        $retResult = [PSCustomObject]@{
            Properties = [System.Collections.Generic.List[PSCustomObject]]::new()
            Methods = [System.Collections.Generic.List[PSCustomObject]]::new()
         }
    }

    Process {
        $members = $InputObject.PSObject.Members.GetEnumerator() | Select-Object -Property MemberType, Name, OverloadDefinitions, TypeNameOfValue
        ForEach ($member in $members) {
            If ($member.Name -in $excludeMembers -or $member.Name.StartsWith('get_') -or $member.Name.StartsWith('set_')) {
                Continue
            }
            If ($member.MemberType -eq 'Method') {
                # Expand Each Overload
                ForEach ($overLoad in $member.OverloadDefinitions) {
                    [void]$retResult.Methods.Add([PSCustomObject]@{
                        Name   = $member.Name
                        Syntax = $overLoad
                    })
                }
            } ElseIf ($member.MemberType -in @('Property','NoteProperty')) {
                [void]$retResult.Properties.Add([PSCustomObject]@{
                    Name   = $member.Name
                    Type = ($member.TypeNameOfValue -replace ', PowerShell Class Assembly, Version=1.0.0.1, Culture=neutral, PublicKeyToken=null','')
                })
            } Else {
                Write-Warning "InputObject Has member of unexpected MemberType ($($member.MemberType)): $($member | Out-String)"
            }
        }
    }

    End {
        $retResult
    }
}


# Initialize the Class Method and Property Data to document
$ClassData = $TestQuery | Get-ClassMemberData
If ([String]::IsNullOrEmpty($ClassData)) {
    Throw "Get-ClassMemberData() Failed to retreive Class Members for `$TestQuery"
}
$ChildClassData = $TestQuery.Tables[0] | Get-ClassMemberData
If ([String]::IsNullOrEmpty($ChildClassData)) {
    Throw "Get-ClassMemberData() Failed to retreive Class Members for `$TestQuery.Tables[0]"
}

$psCodeStart = '```powershell'
$psCodeEnd = '```'
$eol = [System.Environment]::NewLine

# ConvertTo-Markdown creates MarkDown Table from PS Object
. "C:\CMD\PowerShell\MarkDown\ConvertTo-Markdown.ps1"
#>

#========================================================
# Readme MarkDown Generation Starts Here !!!
#========================================================

# Reset the Class Report as MarkDown file
$fsoClassDoc = [System.IO.FileInfo]("C:\Git\SqlQueryClass\archive\ModuleDoc.md")
If ($fsoClassDoc.Exists) { $fsoClassDoc.Delete() }

# Create String Bulder for Assembling the MarkDown output
$sb = [System.Text.StringBuilder]::new()

# Configure Project and User specific settings used to keep the README.md file generator as generic as possible
$projectUri = $projectData.Manifest.ProjectUri
$githubAccount = $projectUri.Split('/')
$ownerId = $githubAccount[-2]
$ProjectName = $githubAccount[-1] # $projectData.ProjectName
$githubAccount = $githubAccount[0..($githubAccount.Count -2)] -join '/'
$ProjectRoot = $projectData.ProjectRoot

[void]$sb.AppendLine("# ``$ProjectName``" + $eol)
[void]$sb.AppendLine($projectData.Description + $eol)

## Module Details
[void]$sb.AppendLine(@"
[![maintainer](https://img.shields.io/badge/maintainer-$ownerId-orange)]($githubAccount)
[![contributors](https://img.shields.io/github/contributors/BrooksV/$ProjectName.svg)]($projectUri/graphs/contributors/)
[![last-commit](https://img.shields.io/github/last-commit/BrooksV/$ProjectName.svg)]($projectUri/commits/)
[![issues](https://img.shields.io/github/issues/BrooksV/$ProjectName.svg)]($projectUri/issues/)
[![issues-closed](https://img.shields.io/github/issues-closed/BrooksV/$ProjectName.svg)]($projectUri/issues?q=is%3Aissue+is%3Aclosed)
"@ + $eol) 

[void]$sb.AppendLine("# ``$($projectData.ProjectName)`` Module Details" + $eol)
[void]$sb.Append(((Get-Module -Name "$($projectData.ProjectName)") | Select-Object -Property Name, Version, @{L='PS Compatiblity'; E={$_.PowerShellHostVersion}}, @{L='Project Uri (GitHub)';E={('[{0}]({0})' -f $_.PrivateData.PSData.ProjectUri)}} | ConvertTo-Markdown | Out-String) +$eol)

# Module Documentation Links / Uri
$docLinks = ((Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData).GetEnumerator().Where({$_.Name -like '*Uri'}) |
    Select-Object -Property @{L='DocLink'; E={$_.Name}}, @{L='Uri'; E={$_.Value}}
# How to add additional Links
# $docLinks += [PSCustomObject]@{
#     DocLink='Test'
#     Uri='https://www.brooksvaughn.net'
# }
<# Table of Links # >
((Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData).GetEnumerator().Where({$_.Name -like '*Uri'}) | 
    Select-Object -Property @{L='Link'; E={$_.Name}}, @{L='Uri'; E={$_.Value}} |
    ConvertTo-Markdown | Out-File -FilePath $fsoClassDoc.FullName -Encoding utf8 -Width 999 -Append
#>

[void]$sb.AppendLine("## Module Links to License and GitHub Project" + $eol)
[void]$sb.AppendLine(($docLinks.ForEach({"`n- [{0}]({1})" -f $_.DocLink, $_.Uri}).Trim() | Out-String))

# Module Tags
# (Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData.Tags| Select-Object -Property @{L='Tags'; E={$_}} | ConvertTo-Markdown
[void]$sb.AppendLine("## Module Tags" + $eol)
[void]$sb.AppendLine("[$((Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData.Tags -join '], [')]" + $eol)

# Module Exported Functions
# (Get-Module -Name "$($projectData.ProjectName)") | FL
# (Get-Module -Name "$($projectData.ProjectName)").ExportedFunctions.GetEnumerator().Key | Select-Object -Property Key
# (Get-Module -Name "$($projectData.ProjectName)").ExportedFunctions.Keys
# (Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value)}) | Select-Object -Property Name, Value
# (Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData | FT -AutoSize -Force -Wrap
[void]$sb.AppendLine("## ``$($projectData.ProjectName)`` Module Exported Functions" + $eol)
[void]$sb.AppendLine($psCodeStart)
[void]$sb.AppendLine("Get-Command -Module `"$($projectData.ProjectName)`" -Syntax"+ $eol)
# [void]$sb.AppendLine((((Get-Command -Module "$($projectData.ProjectName)" -Syntax) -split [System.Environment]::NewLine).Where({-not [String]::IsNullOrWhiteSpace($_)}).ForEach({'- {0}' -f $_}) | Out-String).Replace('[<CommonParameters>]',''))
[void]$sb.AppendLine((((Get-Command -Module "$($projectData.ProjectName)" -Syntax) -split [System.Environment]::NewLine).Where({-not [String]::IsNullOrWhiteSpace($_)}).ForEach({'- {0}' -f $_}) | Out-String).TrimEnd())
[void]$sb.AppendLine($psCodeEnd + $eol)

<#
Common Help Metadata Fields Descriptions

SYNOPSIS: A brief summary of what the cmdlet does.
DESCRIPTION: A detailed description of the cmdlet’s functionality.
PARAMETER: Descriptions for each parameter, detailing its purpose.
EXAMPLE: Examples showing how to use the cmdlet.
INPUTS: Types of objects that can be piped to the cmdlet (if any).
OUTPUTS: Types of objects that the cmdlet emits.
NOTES: Any additional notes, such as author information.
LINK: Links to related documentation or resources.
#>
$Lines = ForEach($foo in (Get-Command -Module "$($projectData.ProjectName)").Name) {
    If ($foo -ne 'New-SqlQueryDataSet') {
        # Continue
    }
    $header = [string]::Empty
    # Get-Command -Name $foo -Syntax
    "### $foo" + $eol
    $psCodeStart
    ForEach ($line in ((Get-Help -Name $foo | Out-String) -split [System.Environment]::NewLine).Where({-not [String]::IsNullOrWhiteSpace($_)})) {
        Switch -Regex ($line) {
            '^\s{4}None$' {$header = [string]::Empty; break} 
            # Common Help Metadata Fields
            '^NAME$' {$header = $line; break}
            '^SYNTAX$' {$header = $line; break}
            '^ALIASES$' {$header = $line; break}
            '^REMARKS$' {$header = $line; break}
            '^DESCRIPTION$' {$header = $line; break}
            '^RELATED LINKS$' {$header = $line; break}
            '^REMARKS$' {$header = $line; break}
            '^SYNOPSIS$' {$header = $line; break}
            '^PARAMETERS$' {$header = $line; break}
            '^INPUTS$' {$header = $line; break}
            '^OUTPUTS$' {$header = $line; break}
            '^EXAMPLES$' {$header = $line; break}
            '^NOTES$' {$header = $line; break}
            '^RELATED LINKS$' {$header = $line; break}
            # Module / Manifest Help Metadata Fields
            '^TOPIC$' {$header = $line; break}
            '^SHORT DESCRIPTION$' {$header = $line; break}
            '^LONG DESCRIPTION$' {$header = $line; break}
            '^AUTHOR$' {$header = $line; break}
            '^COMPANYNAME$' {$header = $line; break}
            '^COPYRIGHT$' {$header = $line; break}
            '^TAGS$' {$header = $line; break}
            '^FUNCTIONSTOEXPORT$' {$header = $line; break}
            '^CMDLETSTOEXPORT$' {$header = $line; break}
            '^REQUIREDMODULES$' {$header = $line; break}
            '^REQUIREDASSEMBLIES$' {$header = $line; break}
            '^VERSION$' {$header = $line; break}
            '^HELPURI$' {$header = $line; break}
            '^MODULEVERSION$' {$header = $line; break}
            '^GUID$' {$header = $line; break}
            '^VARIABLESTOEXPORT$' {$header = $line; break}
            '^ALIASESTOEXPORT$' {$header = $line; break}
            '^PROJECTURI$' {$header = $line; break}
            '^LICENSEURI$' {$header = $line; break}
            '^RELEASENOTES$' {$header = $line; break}
            Default {
                If (-not [string]::IsNullOrWhiteSpace($header)) {
                    $header
                    $header = [string]::Empty
                }
                $line
            }
        }
    }
    $psCodeEnd + $eol
}
[void]$sb.AppendLine(($Lines | Out-String).TrimEnd() + $eol)

# Class Details
[void]$sb.AppendLine("## [$($TestQuery.GetType().Name)] Parent Class Details" + $eol)
[void]$sb.AppendLine("Instances of [$($TestQuery.GetType().Name)] Parent Class are created using the New-SqlQueryDataSet() helper CmdLet. The object returned id of type [$($TestQuery.GetType().Name)]. The properties and methods are used to manage and configure database information and connections, manages creation of the Child Class, executes queries, and saves the results. Instances of Child Classes are collected in the Tables property of the Parent Class. Tables is a collecton of [$($TestQuery.Tables[0].GetType().Name)] objects. One is created for every unique query that was added or executed." + $eol)
[void]$sb.AppendLine("Each instance of the [$($TestQuery.Tables[0].GetType().Name)] Class, holds the Query configuration and execution results." + $eol)
[void]$sb.AppendLine("For technical information, See" + $eol)
[void]$sb.AppendLine("- Get-Help New-SqlQueryDataSet -Full")
[void]$sb.AppendLine("- New-SqlQueryDataSets.tests.ps1 in the Tests ($ProjectRoot\tests\) folder has full usage examples used to validate usage" + $eol)

# Parent Class Properties
[void]$sb.AppendLine("### Class [$($TestQuery.GetType().Name)] Properties" + $eol)
If ([string]::IsNullOrEmpty($ClassData.Properties)) {
    [void]$sb.AppendLine("Class Has No Properties")
} Else {
    [void]$sb.AppendLine(($ClassData.properties | Select-Object -Property Name, @{L='Type'; E={"[$($_.Type)]"}} | ConvertTo-Markdown | Out-String))
}
# Parent Class Methods
[void]$sb.AppendLine("### Class [$($TestQuery.GetType().Name)] Methods" + $eol)
If ([string]::IsNullOrEmpty($ClassData.Methods)) {
    [void]$sb.AppendLine("Class Has No Methods")
} Else {
    [void]$sb.AppendLine(($ClassData.Methods | Select-Object -Property Name, Syntax | ConvertTo-Markdown | Out-String))
}

# Child Class Properties
[void]$sb.AppendLine("### Child Class [$($TestQuery.Tables[0].GetType().Name)] Properties" + $eol)
If ([string]::IsNullOrEmpty($ChildClassData.Properties)) {
    [void]$sb.AppendLine("Class Has No Properties")
} Else {
    [void]$sb.AppendLine(($ChildClassData.properties | Select-Object -Property Name, @{L='Type'; E={"[$($_.Type)]"}} | ConvertTo-Markdown | Out-String))
}
# Child Class Methods
[void]$sb.AppendLine("### Child Class [$($TestQuery.Tables[0].GetType().Name)] Modules" + $eol)
If ([string]::IsNullOrEmpty($ChildClassData.Methods)) {
    [void]$sb.AppendLine("Class Has No Methods")
 } Else {
    [void]$sb.AppendLine(($ChildClassData.Methods | Select-Object -Property Name, Syntax | ConvertTo-Markdown | Out-String))
 }

# $sb.ToString()
$sb.ToString() | Out-File -FilePath $fsoClassDoc.FullName -Encoding utf8 -Width 999 -Append
Break
[void]$sb.AppendLine("" + $eol)
[void]$sb.AppendLine("" + $eol)
[void]$sb.AppendLine("" + $eol)
[void]$sb.AppendLine("" + $eol)
[void]$sb.AppendLine("" + $eol)
[void]$sb.AppendLine("" + $eol)
