#region localizeddata
if (Test-Path "${PSScriptRoot}\${PSUICulture}")
{
    Import-LocalizedData -BindingVariable LocalizedData -filename NetworkingDsc.Helper.psd1 `
                         -BaseDirectory "${PSScriptRoot}\${PSUICulture}"
} 
else
{
    #fallback to en-US
    Import-LocalizedData -BindingVariable LocalizedData -filename NetworkingDsc.Helper.psd1 `
                         -BaseDirectory "${PSScriptRoot}\en-US"
}
#endregion

function Test-NetworkAdapterAdvancedProperty
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
        $DisplayValue
    )

    $netAdapter = Get-NetAdapter -Name $Name -ErrorAction SilentlyContinue

    if ($netAdapter)
    {
        $netAdapterProperty = Get-NetAdapterAdvancedProperty -Name $Name -DisplayName $DisplayName -ErrorAction SilentlyContinue
        if ($netAdapterProperty)
        {
            if ($netAdapterProperty.DisplayValue -eq $DisplayValue)
            {
                Write-Verbose -Message ($localizedData.AdvancedPropertyMatching -f $DisplayValue)
                return $true
            }
            else
            {   
                #Check if the display belongs to valid display value set
                if ($netAdapterProperty.ValidDisplayValues)
                {
                    if ($netAdapterProperty.ValidDisplayValues -contains $DisplayValue)
                    {
                        Write-Verbose -Message ($localizedData.AdvancedPropertyNotMatching -f $DisplayValue)
                        return $false
                    }
                    else
                    {
                        throw ($localizedData.DisplayValueIsNotValid -f $DisplayValue, $DisplayName)    
                    }
                }
            }
        }
        else
        {
            throw ($localizedData.AdvancedPropertyNotFound -f $DisplayName)
        }
    }
    else
    {
        throw ($localizedData.NetAdapterNotFound -f $Name)
    }
}

Export-ModuleMember -Function *