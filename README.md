#pwsh

## what's in here?

| Path | Description
| ---  | -----------
| [finops/get_rds.ps1](finops/get_rds.ps1) | inventory and utilization script for RDS 
| [finops/get_ec2.ps1](finops/get_ec2.ps1) | inventory and utilization script for EC2 
 
## setup
Use AWS SSO credentials to authenticat before running script.  
PS > aws sso login --profile <_example, profile name stored in \.aws\config_>  
Create output destination folder  
Run script  
PS > .\get_rds.ps1 

## purpose & background
These files are ingested in the COGS dashboard built in PowerBI described here:  
*  https://smarsh.atlassian.net/wiki/spaces/PROD/pages/3345383619/PowerBI+Tables  
* [EC2](https://smarsh.atlassian.net/wiki/spaces/PROD/pages/3347251214/EC2)  
* [RDS](https://smarsh.atlassian.net/wiki/spaces/PROD/pages/3353542984/RDS)  
