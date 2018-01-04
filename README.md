# Networking DSC resource module
*This is not a fork of the xNetworking module. I am adding only the resources that I am developing from scratch to this NetworkingDsc. These resources will follow the HQRM guidelines.*

|Resource Name| Description|
|-------------|------------|
|NetworkAdapterProperty|This resource can be used to set network adapter advanced properties. | 

## NetworkAdapterProperty
|Property Name| Description|
|-------------|------------|
|Id |Key property to uniquely identify the resource instance. |
|Name |Name of the network adapter. | 
|DisplayName |Display Name of the advanced property. |
|DisplayValue |Value to be set on the advanced property. |
|Ensure |Specifies if the property needs to configured (present) or reset to it's default value (absent). |
