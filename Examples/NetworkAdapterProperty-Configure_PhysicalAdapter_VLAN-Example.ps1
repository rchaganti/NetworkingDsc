Configuration PhysicalAdapterVLAN
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName NetworkingDsc -ModuleVersion 1.0.0.0

    NetworkAdapterProperty VLAN
    {
        Id = 'S1P1VLAN'
        Name = 'SLOT 1 PORT 1'
        DisplayName =  'VLAN ID'
        DisplayValue = '102'
        Ensure = 'Present'
    }
}
