#pwsh

## what's in here?

| Path | Description
| ---  | -----------
| [finops/get_rds.ps1](finops/get_rds.ps1) | inventory and utilization script for RDS 
| [finops/get_ec2.ps1](finops/get_ec2.ps1) | inventory and utilization script for EC2 
 
## setup
Use AWS SSO credentials to authenticat before running script. \
PS > aws sso login --profile <_example, profile name stored in \.aws\config_> \
Create output destination folder \
Run script \
PS > .\get_rds.ps1 

