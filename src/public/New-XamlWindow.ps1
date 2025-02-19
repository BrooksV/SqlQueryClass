<#
PsWpfHelper
WpfHelperForPS
PsWpfUtils
WpfUtilsForPS
PsWpfLib
PsXaml
PsXamlHelper
GuiMyPS - Collections of XAML & WPF Helper Functions to simplify creation of GUI based PowerShell Applications 
GuiMyPS - Module helps in creating and running WPF GUI based PowerShell Applications.

#>
Function New-XamlWindow {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        [Parameter(Mandatory=$true)]
        [Alias("InputObject")]
        [System.Object]$xaml,

        [Parameter(Mandatory=$false)]
        [switch]$NoXRemoval
    )
    # Load the necessary assemblies
    Add-Type -AssemblyName PresentationFramework

    <#
    XAML Elements might use either x:Name="" or Name="" 
    The x: refers to the namespace xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" which is not automatically defined in PowerShell
    To use XPath queries are used during preprocessing of the XAML Text, you have to create a NamespaceManager and Add the missing NameSpaces
    For x:Name, the XPath query would be $xaml.SelectNodes("//*[@x:Name]", $nsManager)
    For Name, the XPath query would be $xaml.SelectNodes("//*[@Name]", $nsManager)
    By Removing x:Name from the XAML string before converting to [System.Xml.XmlDocument], 
      there is not need for the NamespaceManager and XPath needs only$xaml.SelectNodes("//*[@Name]")
    #>
    Function Remove-XName {
        [CmdletBinding(SupportsShouldProcess=$true)]
        Param (
            [Parameter(Mandatory=$true)]
            [string]$xamlString,

            [Parameter(Mandatory=$false)]
            [switch]$NoXRemoval
        )

        If ($NoXRemoval) {
            $xamlString
        } Else {
            if ($PSCmdlet.ShouldProcess("XAML String", "Remove x:Name attributes")) {
                ((($xamlString -replace 'mc:Ignorable="d"','') -replace "x:Na",'Na') -replace '^<Win.*', '<Window')
            } else {
                $xamlString
            }
        }
    }

    # Define Return and working Variable
    $uiForm = $null
    $xamlReader = $null
    Try {
        # process the $xaml inputObject into a XmlDocument and create reader
        If ($xaml -is [System.Xml.XmlDocument]) {
            $newXaml = $xaml
        } ElseIf ($xaml -is [System.String]) {
            If (Test-Path -Path $xaml -PathType Leaf -ErrorAction SilentlyContinue) {
                $xamlString = Remove-XName -NoXRemoval:$NoXRemoval -xamlString (Get-Content -Path $xaml -Raw)
                if ($xamlString -match '<(Window|Grid|StackPanel|Button|DataGrid|TextBox)') {
                    $newXaml = [xml]$xamlString
                } Else {
                    Throw "-xaml parameter as file path was valid but it's content is not XAML"
                }
            } Elseif ($xaml -match '<(Window|Grid|StackPanel|Button|DataGrid|TextBox)') {
                $xamlString = Remove-XName -NoXRemoval:$NoXRemoval -xamlString $xaml
                $newXaml = [xml]$xamlString
            } Else {
                Throw "-xaml parameter as XAML String has no valid XAML content"
            }
        } Else {
            Throw "-xaml is not a valid [System.Xml.XmlDocument], xaml string, or filepath to a xaml file"
        }

        # preform XML data cleanup and create Powershell $WPF_* Variables for xaml names that begin with "_"
        # Remove unsupported namespaces created by XAML editors like Blend / Visual Studio
        $newXaml.Window.RemoveAttribute('x:Class')
        $newXaml.Window.RemoveAttribute('d')
        $newXaml.Window.RemoveAttribute('mc:Ignorable')

        $problemObjects = $newXaml.SelectNodes("//*[@Name]").Where({
            $_.Click -or $_.TextChanged -or $_.SelectionChanged -or $_.Checked -or $_.Unchecked -or $_.ValueChanged}) | 
                Select-Object -Property Name, LocalName, Click, TextChanged, SelectionChanged, Checked, Unchecked, ValueChanged
        
        $errorHeading = "XAML String has unsupported events defined and cannot be converted by PowerShell WPF" + [System.Environment]::NewLine
        $errorText = ForEach ($obj in $problemObjects) {
            Switch ($obj) {
                {$_.Click} {"$($_.LocalName) named ($($_.Name)) Has Click event and needs to be removed"; break}
                {$_.TextChanged} {"$($_.LocalName) named ($($_.Name)) Has TextChanged event and needs to be removed"; break}
                {$_.SelectionChanged} {"$($_.LocalName) named ($($_.Name)) Has SelectionChanged event and needs to be removed"; break}
                {$_.Checked} {"$($_.LocalName) named ($($_.Name)) Has Checked event and needs to be removed"; break}
                {$_.Unchecked} {"$($_.LocalName) named ($($_.Name)) Has Unchecked event and needs to be removed"; break}
                {$_.ValueChanged} {"$($_.LocalName) named ($($_.Name)) Has ValueChanged event and needs to be removed"; break}
                Default {"Skipping: $($_.LocalName) named ($($_.Name))"}
            }
        }
        If ($problemObjects.Count -gt 0) {
            Write-Host ($errorHeading) -ForegroundColor Red
            Write-Host ($errorText | Out-String) -ForegroundColor Magenta
            Write-Host "Please remove the event definitions from the XAML and try again" -ForegroundColor Red
            Exit
        }

        # Create and Load the XAML Reader to create the WPF Form
        $xamlReader = (New-Object System.Xml.XmlNodeReader $newXaml)
        $uiForm = [System.Windows.Markup.XamlReader]::Load($xamlReader)

        # Create a PowerShell Variable $WPF_ for each Form Object defined in the XAML where the 
        #   element name begin with "_" as in Name="_MyObj" or x:Name="_MyObj"
        # For the most part, this allows the Code-Behind to directly access the element without needing to find it first
        $FormObjects = $newXaml.SelectNodes("//*[@Name]").Where({ $_.Name -like "_*" }).ForEach({
            $element = $uiForm.FindName($_.Name)
            If ($element) {
                Write-Output ("WPF$($_.Name)")
                Set-Variable -Name "WPF$($_.Name)" -Value $element -Force -Scope Global -Visibility Public
            } Else {
                Write-Warning "Unable to locate $($_.Name) element name"
            }
        })
        Write-Host "`nList of `$WPF_ named Variables of XAML Elements`n$($FormObjects | Out-String)`n" -ForegroundColor Green
        $uiForm
    } Catch {
        Write-Error ($_ | Format-List | Out-String)
    }
}
