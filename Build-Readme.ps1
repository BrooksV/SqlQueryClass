<#
. "C:\Git\SqlQueryClass\Build-Readme.ps1" -- Generates a README.md file but saves it as .\archive\ModuleDoc.md to prevent overwriting 

#>


<# #>
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
    Throw "Get-ClassMemberData() Failed to retrieve Class Members for `$TestQuery"
}
$ChildClassData = $TestQuery.Tables[0] | Get-ClassMemberData
If ([String]::IsNullOrEmpty($ChildClassData)) {
    Throw "Get-ClassMemberData() Failed to retrieve Class Members for `$TestQuery.Tables[0]"
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

# Create String Builder for Assembling the MarkDown output
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

# Badges
# To use a different label
# [BadgeIOCount]: https://img.shields.io/powershellgallery/dt/SqlQueryClass?label=SqlQueryClass%40PowerShell%20Gallery
# ![Coverage](https://img.shields.io/codecov/c/github/$ownerId/$ProjectName)

[void]$sb.AppendLine("## ``$($projectData.ProjectName)`` Module and Status Details" + $eol)
[void]$sb.Append(((Get-Module -Name "$($projectData.ProjectName)") | Select-Object -Property Name, Version, @{L='PS Compatibility'; E={$_.PowerShellHostVersion}}, @{L='Project Uri (GitHub)';E={('[{0}]({0})' -f $_.PrivateData.PSData.ProjectUri)}} | ConvertTo-Markdown | Out-String) +$eol)

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

[void]$sb.AppendLine(@"
[PSGalleryLink]: https://www.powershellgallery.com/packages/$ProjectName/
[BadgeIOCount]: https://img.shields.io/powershellgallery/dt/$ProjectName.svg?label=downoads%20$ProjectName%40PSGallery
[WorkFlowStatus]: https://img.shields.io/github/actions/workflow/status/$ownerId/$ProjectName/tests.yml?label=tests.yml%20build

[![maintainer](https://img.shields.io/badge/maintainer-$ownerId-orange)]($githubAccount)
[![License](https://img.shields.io/github/license/$ownerId/$ProjectName)]($projectUri/blob/main/LICENSE)
[![contributors](https://img.shields.io/github/contributors/$ownerId/$ProjectName.svg)]($projectUri/graphs/contributors/)
[![last-commit](https://img.shields.io/github/last-commit/$ownerId/$ProjectName.svg)]($projectUri/commits/)
[![issues](https://img.shields.io/github/issues/$ownerId/$ProjectName.svg)]($projectUri/issues/)
[![issues-closed](https://img.shields.io/github/issues-closed/$ownerId/$ProjectName.svg)]($projectUri/issues?q=is%3Aissue+is%3Aclosed)

[![GitHub stars](https://img.shields.io/github/stars/$ownerId/$ProjectName.svg)]($projectUri/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/$ownerId/$ProjectName.svg)]($projectUri/network/members)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/$ownerId/$ProjectName.svg)]($projectUri/pulls)

### Build and Release Statistics

[![$ProjectName@PowerShell Gallery][BadgeIOCount]][PSGalleryLink]
![WorkFlow Status][WorkFlowStatus]
![Build Status](https://img.shields.io/github/actions/workflow/status/$ownerId/$ProjectName/ci.yml?label=ci.yml%20build)
![Version](https://img.shields.io/github/v/release/$ownerId/$ProjectName.svg?label=version)

![GitHub All Releases](https://img.shields.io/github/downloads/$ownerId/$ProjectName/total.svg?label=release%20dl%20all%40GitHub)
![GitHub release (latest by date)](https://img.shields.io/github/downloads/$ownerId/$ProjectName/latest/total.svg?label=release%20dl%20by%20date%40GitHub)
![Downloads](https://img.shields.io/github/downloads/$ownerId/$ProjectName/total.svg?label=total%20release%20dl%40GitHub)
"@ + $eol) 

[void]$sb.AppendLine("### Module Links to License and GitHub Project" + $eol)
[void]$sb.AppendLine(($docLinks.ForEach({"`n- [{0}]({1})" -f $_.DocLink, $_.Uri}).Trim() | Out-String))

# Module Tags
# (Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData.Tags| Select-Object -Property @{L='Tags'; E={$_}} | ConvertTo-Markdown
[void]$sb.AppendLine("### Module Tags" + $eol)
[void]$sb.AppendLine("[$((Get-Module -Name "$($projectData.ProjectName)").PSObject.Properties.Where({-not [string]::IsNullOrEmpty($_.Value) -and $_.Name -eq 'PrivateData'}).Value.PSData.Tags -join '], [')]" + $eol)

# Module Installation
[void]$sb.AppendLine("## Installation" + $eol)
[void]$sb.AppendLine(@"
$psCodeStart
Install-Module -Name $($ProjectName) -Repository PSGallery -Scope CurrentUser
$psCodeEnd

To load a local build of the module, use `Import-Module` as follows:

$psCodeStart
Import-Module -Name "$($projectData.ManifestFilePSD1)" -Force -verbose
$psCodeEnd

### Requirements

- Tested with PowerShell 5.1 and 7.5x
- No known dependencies for usage
- VS Code and clone [Brooks Vaughn's $ProjectName]($projectUri) Repository
- Module build process uses [Manjunath Beli's](https://github.com/belibug) [ModuleTools](https://github.com/belibug) module.

### ToDo

- [ ] Seek peer review and comments
- [ ] Integrate feedback
- [ ] Improve Documentation
- [ ] Complete Build-Readme.ps1 script that generates the README.md file

## How Build ``$ProjectName`` Module

### Setup

- Uses SQL Express but should work with other SQL Databases with proper connection strings and credentials
- Requires VS Code
- For Contributors, Fork the [$ProjectName]($projectUri) repository
- Clone the repository or fork to local pc. I like using c:\git as my local repository folder. Subfolder `$ProjectName` will be created with the GiHib repository contents
- Install [Manjunath Beli's ModuleTools](https://github.com/belibug/ModuleTools) module as the module build process uses ModuleTools
- - Find-Module -Name ModuleTools | Install-Module -Scope CurrentUser -Verbose
- Note that a sample SQL Express database file (.\tests\TestDatabase1.mdf) is included for pester tests. The database configuration is set in .\tests\TestDatabase1.parameters.psd1

#### Source Files used in the Module

- Public functions that are exported, are separate files in the .\src\public folder.
- Private functions that are local to the Module, are separate files in the .\src\private folder.
- - Class Definitions and Enums are not accessible outside of the Module and cannot be accessed directly like Public Functions are. This is a PowerShell limitation.
- - - Classes [SqlQueryDataSet] and [SqlQueryDataSetParms] and enum ResultType used in the Module are defined in file .\src\private\$ProjectName.ps1 file. The classes have properties and methods used to maintain a Database connections and result sets making it useful WPF Data binding.
- Resources are files and folders in the .\src\resources folder that needs to be included with the Manifest and Module

#### ``$ProjectName`` Module Build Process

- Create a local branch for your changes
- - Use descriptive name that reflects the type of changes for branch for example features/database-table-access
- Update the build version using Update-MTModuleVersion (Find-Module -Name ModuleTools)
- Commit your changes to the branch
- Run the Pester Teats using Invoke-MTTest (Find-Module -Name ModuleTools)
- Build the Module output using Invoke-MTBuild -Verbose (Find-Module -Name ModuleTools)
- - Outputs to the .\dist\$ProjectName folder
- - Combines the file contents of the files in Public and Private folder into .\dist\$ProjectName\$ProjectName.psd1 and exports the Public Functions
- - Generates the .\dist\$ProjectName\$ProjectName.psd1 Manifest file from the settings in .\project.json
- - Resources (.\src\resources) folder content is copied to .\dist\$ProjectName folder
- Run the Pester Teats using Invoke-MTTest (Find-Module -Name ModuleTools)
- Make corrections, repeat the build process
- For Contributors
- - Create an Issue if one does not exist that addresses the proposed changes
- - Upstream your branch
- - Create a Pull request

#### Publishing ``$ProjectName`` Module to GitHub

Stage and Commit Your Changes

$psCodeStart
git add .
git commit -m "Implemented database and table access functions"
$psCodeEnd

Update remote repository with branch changes

$psCodeStart
# List status of remote repository
git branch -r
# Create Branch on remote repository if needed
# git push --set-upstream origin features/database-table-access
# Push branch changes to remote branch in repository
git push origin features/database-table-access
$psCodeEnd

Create a Pull Request on remote repository

- Go to [$ProjectName GitHub repository]($projectUri)
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

$psCodeStart
git push origin --delete features/database-table-access
$psCodeEnd

- Optionally, delete the local branch

$psCodeStart
git branch -d features/database-table-access
$psCodeEnd

These steps will ensure your changes are integrated into the main branch and your repository remains organized.

#### Publishing ``$ProjectName`` Module to PowerShell Gallery

$psCodeStart
`$data = Get-MTProjectInfo
`$ApiKey = "your-api-key-here"
Publish-Module -Path `$data.OutputModuleDir -NuGetApiKey `$ApiKey -Repository PSGallery
$psCodeEnd

### New-SqlQueryDataSet Helper Function to Create Class Instance

The main cmdlet provided by this module is New-SqlQueryDataSet, which returns an object instance of [SqlQueryDataSet] class. Note that all the parameters are optional.

$psCodeStart
`$testQuery = New-SqlQueryDataSet [[-SQLServer] <string>] [[-Database] <string>] [[-ConnectionString] <string>] [[-Query] <string>] [[-TableName] <string>] [[-DisplayResults] <bool>] [<CommonParameters>]
$psCodeEnd
"@ + $eol) 

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
[void]$sb.AppendLine("### [$($TestQuery.GetType().Name)] Parent Class Details" + $eol)
[void]$sb.AppendLine("Instances of [$($TestQuery.GetType().Name)] Parent Class are created using the New-SqlQueryDataSet() helper CmdLet. The object returned id of type [$($TestQuery.GetType().Name)]. The properties and methods are used to manage and configure database information and connections, manages creation of the Child Class, executes queries, and saves the results. Instances of Child Classes are collected in the Tables property of the Parent Class. Tables is a collection of [$($TestQuery.Tables[0].GetType().Name)] objects. One is created for every unique query that was added or executed." + $eol)
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
