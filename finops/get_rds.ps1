# Name: get_rds.ps1
# Custom output RDS statistics for PBI COGS dashboard

class output_rds
{
    [string] $name = ""
    [string] $db_name = ""
    [string] $account = ""
    [string] $region = ""
    [string] $az_multi = ""
    [string] $az_primary = ""
    [string] $az_secondary = ""
    [string] $created = ""
    [string] $db_cert = ""
    [string] $db_cluster = ""
    [string] $db_engine = ""
    [string] $db_iam = ""
    [string] $db_id = ""
    [string] $db_kms = ""
    [string] $db_replica_mode = ""
    [string] $db_rid = ""
    [string] $db_status = ""
    [string] $db_version = ""
    [string] $instance_class = ""
    [string] $publicly_accessible = ""
    [string] $storage_allocated = ""
    [string] $storage_encrypted = ""
    [string] $storage_iops = ""
    [string] $storage_type = ""
    [string] $cf_org = ""
    [string] $cf_sp = ""
    [string] $cf_instance = ""    
    [string] $customer = ""
    [string] $product_family = ""
    [string] $product = ""
    [string] $feature = ""
    [string] $deployment = ""
}
<# begin test
$report_name = Read-Host 'enter PBI report name (prod,us-east-1,ap-southeast-1...)'
$report_name
$region = Read-Host 'enter region'
Set-DefaultAWSRegion $region
$cred_profile = Read-Host 'enter profile'

end test#>

<#begin test end test#>
Write-Host "Enter the number of the report you wish to run." -ForegroundColor DarkBlue

$input = Read-Host "1: prod-us-e1  2: nam-us-e1  3: ap-se  4: eu-w  5: eu-c1  6: eu-c2"
switch ($input) 
{
1 {
    $region = "us-east-1"
    $report_name = "prod"
    $cred_profile = "us-2431"  
}
2 { 
    $region = "us-east-1"
    $report_name = "us-east-1"
    $cred_profile = "us-7493"  
}
3 { 
    $region = "ap-southeast-1" 
    $report_name = "ap-southeast-1" 
    $cred_profile = "ap-0822"}
4 { 
    $region = "eu-west-1"
    $report_name = "eu-west-1"
    $cred_profile = "eu-5753-"  
}
5 { 
    $region = "eu-central-1"
    $report_name = "eu-central-1"
    $cred_profile = "eu-8417"  
}
6 { 
    $region = "eu-central-2"
    $report_name = "eu-central-2"
    $cred_profile = "eu-3221"  
}

    Default 
    {
        $region = "eu-central-2"
        $report_name = "eu-central-2"
        $cred_profile = "eu-3221"
    }
}
Set-DefaultAWSRegion $region
$all_rdss = Get-RDSDBInstance -ProfileName $cred_profile
$out_rdss = @()

ForEach($all_rds in $all_rdss)
{
    $tmp_rds = [output_rds]::New()
    $tmp_rds.name = $all_rds.DBInstanceIdentifier
    $tmp_rds.db_name = $all_rds.DBName
    $tmp_rds.account = $all_rds.DBInstanceArn.Split(":")[4]
    $tmp_rds.region = $all_rds.DBInstanceArn.Split(":")[3]
    $tmp_rds.az_multi = $all_rds.MultiAZ
    $tmp_rds.az_primary = $all_rds.AvailabilityZone
    $tmp_rds.az_secondary = $all_rds.SecondaryAvailabilityZone
    $tmp_rds.created = $all_rds.InstanceCreateTime
    $tmp_rds.db_cert = $all_rds.CACertificateIdentifier
    $tmp_rds.db_cluster = $all_rds.DBClusterIdentifier
    $tmp_rds.db_engine = $all_rds.Engine
    $tmp_rds.db_iam = $all_rds.IAMDatabaseAuthenticationEnabled
    $tmp_rds.db_id = $all_rds.DBInstanceIdentifier
    $tmp_rds.db_kms = $all_rds.KmsKeyId
    $tmp_rds.db_replica_mode = $all_rds.ReplicaMode
    $tmp_rds.db_rid = $all_rds.DbiResourceId
    $tmp_rds.db_status = $all_rds.DBInstanceStatus
    $tmp_rds.db_version = $all_rds.EngineVersion
    $tmp_rds.instance_class = $all_rds.DBInstanceClass
    $tmp_rds.publicly_accessible = $all_rds.PubliclyAccessible
    $tmp_rds.storage_allocated = $all_rds.AllocatedStorage
    $tmp_rds.storage_encrypted = $all_rds.StorageEncrypted
    $tmp_rds.storage_iops = $all_rds.Iops
    $tmp_rds.storage_type = $all_rds.StorageType
    try{$tmp_rds.cf_org = $($all_rds.TagList | Where-Object {$_.key -eq "pcf-organization-guid"}).Value.ToString()}catch{}
    try{$tmp_rds.cf_sp = $($all_rds.TagList | Where-Object {$_.key -eq "pcf-space-guid"}).Value.ToString()}catch{}
    try{$tmp_rds.cf_instance = $($all_rds.TagList | Where-Object {$_.key -eq "pcf-instance-id"}).Value.ToString()}catch{} 
    try{$tmp_rds.customer = $($all_rds.TagList | Where-Object {$_.key -eq "customer"}).Value.ToString()}catch{}
    try{$tmp_rds.product_family = $($all_rds.TagList | Where-Object {$_.key -eq "product_family"}).Value.ToString()}catch{}
    try{$tmp_rds.product = $($all_rds.TagList | Where-Object {$_.key -eq "product"}).Value.ToString()}catch{}
    try{$tmp_rds.feature = $($all_rds.TagList | Where-Object {$_.key -eq "feature"}).Value.ToString()}catch{}
    try{$tmp_rds.deployment = $($all_rds.TagList | Where-Object {$_.key -eq "deployment"}).Value.ToString()}catch{}
    $out_rdss += $tmp_rds
}

$out_date = Get-Date -Format "yyyy-MM-dd_HH_mm_ss"
$out_rdss | Select-Object | Format-Table
$out_rdss | Select-Object | Export-Csv -NoTypeInformation -Path "../../output/aws_rds_inventory_$($out_date)_$($report_name).csv"