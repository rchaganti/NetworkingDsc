Configuration PhysicalAdapterVLAN
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName NetworkingDsc -ModuleVersion 1.0.0.0

    NetworkAdapterProperty VLAN
    {
        Id = 'S1P1DCBX'
        Name = 'SLOT 1 PORT 1'
        DisplayName =  'DcbxMode'
        DisplayValue = 'Host in charge'
        Ensure = 'Present'
    }

    NetworkAdapterProperty VLAN
    {
        Id = 'S2P2DCBX'
        Name = 'SLOT 1 PORT 2'
        DisplayName =  'DcbxMode'
        DisplayValue = 'Host in charge'
        Ensure = 'Present'
    }    
}
