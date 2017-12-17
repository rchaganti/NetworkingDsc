#region helper modules
$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'

Import-Module -Name (Join-Path -Path $modulePath `
                               -ChildPath (Join-Path -Path 'NetworkingDsc.Helper' `
                                                     -ChildPath 'NetworkingDsc.Helper.psd1'))
#endregion

#region localizeddata
if (Test-Path "${PSScriptRoot}\${PSUICulture}")
{
    Import-LocalizedData -BindingVariable LocalizedData -filename NetworkAdapterProperty.psd1 `
                         -BaseDirectory "${PSScriptRoot}\${PSUICulture}"
} 
else
{
    #fallback to en-US
    Import-LocalizedData -BindingVariable LocalizedData -filename NetworkAdapterProperty.psd1 `
                         -BaseDirectory "${PSScriptRoot}\en-US"
}
#endregion

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Name
Parameter description

.PARAMETER DisplayName
Parameter description

.PARAMETER DisplayValue
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
        [Parameter(Mandatory = $true)]
		[String]
        $Name,
        
        [Parameter(Mandatory = $true)]
		[String]
        $DisplayName,
        
        [Parameter(Mandatory = $true)]
		[String]
        $DisplayValue        
	)

    $configuration = @{
        Name = $Name
        DisplayName = $DisplayName
        DisplayValue = $DisplayValue
    }

    if (Test-NetworkAdapterAdvancedProperty @PSBoundParameters)
    {
        $configuration.Add('Ensure','Present')
    }
    else
    {
        $configuration.Add('Ensure','Absent')    
    }

    return $configuration
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Name
Parameter description

.PARAMETER DisplayName
Parameter description

.PARAMETER DisplayValue
Parameter description

.PARAMETER Ensure
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $true)]
		[String]
        $Name,
        
        [Parameter(Mandatory = $true)]
		[String]
        $DisplayName,
        
        [Parameter(Mandatory = $true)]
		[String]
        $DisplayValue,

		[ValidateSet('Present','Absent')]
        [String]
		$Ensure = 'Present'    
	)

    $params = @{
        Name = $Name
        DisplayName = $DisplayName
        DisplayValue = $DisplayValue
    }

    $propertyExists = Test-NetworkAdapterAdvancedProperty @params -Verbose
    $netAdapterProperty = Get-NetAdapterAdvancedProperty -Name $Name -DisplayName $DisplayName

    if ($Ensure -eq 'Present')
    {
        if (-not $propertyExists)
        {
            Write-Verbose -Message $localizedData.SetProperty
            Set-NetAdapterAdvancedProperty @params -Verbose
        }
    }
    else
    {
        if ($DisplayValue -ne $netAdapterProperty.DefaultDisplayValue)
        {
            Write-Verbose -Message $localizedData.SetDefaultValue
            Set-NetAdapterAdvancedProperty -Name $Name -DisplayName $DisplayName -DisplayValue $netAdapterProperty.DefaultDisplayValue -Verbose
        }
    }
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Name
Parameter description

.PARAMETER DisplayName
Parameter description

.PARAMETER DisplayValue
Parameter description

.PARAMETER Ensure
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
        [Parameter(Mandatory = $true)]
		[String]
        $Name,
        
        [Parameter(Mandatory = $true)]
		[String]
        $DisplayName,
        
        [Parameter(Mandatory = $true)]
		[String]
        $DisplayValue,

		[ValidateSet('Present','Absent')]
        [String]
		$Ensure = 'Present'   
	)

    $params = @{
        Name = $Name
        DisplayName = $DisplayName
        DisplayValue = $DisplayValue
    }
    
    $propertyExists = Test-NetworkAdapterAdvancedProperty @params -Verbose
    $netAdapterProperty = Get-NetAdapterAdvancedProperty -Name $Name -DisplayName $DisplayName
    
    if ($Ensure -eq 'Present')
    {
        if ($propertyExists)
        {
            Write-Verbose -Message $localizedData.PropertyInDesiredState
            return $true
        }
        else
        {
            Write-Verbose -Message $localizedData.PropertyNotInDesiredState
            return $false
        }
    }
    else
    {
        if ($DisplayValue -eq $netAdapterProperty.DefaultDisplayValue)
        {
            Write-Verbose -Message $localizedData.PropertyInDesiredState
            return $true
        }
        else
        {
            Write-Verbose -Message $localizedData.PropertyWillBeSetToDefault
            return $false
        }
    }
}

Export-ModuleMember -Function *-TargetResource
