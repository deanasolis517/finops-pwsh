# NAME: get_ec2.ps1
# COMMENT: Gets AWS ec2 inventory
#  Module Initialization
# Check that we're in PowerSell 5.0 or better
# If($psversiontable.psversion.major -lt 5)
# {
# 	Write-Host -ForegroundColor Red "This script requires PowerShell 5.0 or higher. Fix that and try agin."
# 	Exit
# }

class output_ec2
{
    [string] $name = ""
    [string] $customer = ""
    [string] $product_family = ""
    [string] $product = ""
    [string] $feature = ""
    [string] $type = ""
    [string] $ip = ""
    [string] $image = ""
    [string] $launch_time = ""
    [string] $instance = ""
    [string] $platform = ""
    [string] $vpc = ""
    [string] $deployment = ""
    [string] $tier = ""
    [string] $az = ""
    [int] $disks = 0
    [int] $disks_total_size = 0
    [float] $disk_0_size = 0
    [string] $disk_0_type = ""
    [float] $disk_0_iops = 0
    [float] $disk_0_throughput = 0
    [float] $disk_1_size = 0
    [string] $disk_1_type = ""
    [float] $disk_1_iops = 0
    [float] $disk_1_throughput = 0
    [float] $disk_2_size = 0
    [string] $disk_2_type = ""
    [float] $disk_2_iops = 0
    [float] $disk_2_throughput = 0
}

$report_name = Read-Host 'enter report name'
$report_name
$region = Read-Host 'enter region'
Set-DefaultAWSRegion $region
$cred_profile = Read-Host 'enter profile'

#  Connect to all hosts

$all_ec2s = Get-EC2Instance -ProfileName $cred_profile
$out_ec2s = @()
ForEach($all_ec2a in $all_ec2s)
{
    ForEach($all_ec2 in $all_ec2a.Instances)
    {
        $tmp_ec2 = [output_ec2]::New()
        try{$tmp_ec2.name = $($all_ec2.Tags | Where-Object {$_.key -eq "Name"}).Value.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.customer = $($all_ec2.Tags | Where-Object {$_.key -eq "customer"}).Value.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.product_family = $($all_ec2.Tags | Where-Object {$_.key -eq "product_family"}).Value.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.product = $($all_ec2.Tags | Where-Object {$_.key -eq "product"}).Value.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.feature = $($all_ec2.Tags | Where-Object {$_.key -eq "feature"}).Value.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.type = $all_ec2.InstanceType.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.ip = $all_ec2.PrivateIpAddress.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.image = $all_ec2.ImageId.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.launch_time = $all_ec2.LaunchTime.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.instance = $all_ec2.InstanceId.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.platform = $all_ec2.PlatformDetails.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.vpc = $all_ec2.VpcId.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.deployment = $($all_ec2.Tags | Where-Object {$_.key -eq "deployment"}).Value.ToString()}catch{"Missing tag."}
        try{$tmp_ec2.tier = $($all_ec2.Tags | Where-Object {$_.key -eq "tier"}).Value.ToString()}catch{"Missing tag."}
        $tmp_ec2.az = $all_ec2.Placement.AvailabilityZone.ToString()

        If($all_ec2.BlockDeviceMappings.Length -gt 0)
        {
            # Capture disk stats
            $tmp_ec2.disks = @($all_ec2.BlockDeviceMappings).Length

            For($i=0;$i -lt $tmp_ec2.disks;$i++)
            {
                $tmp_ebs = Get-EC2Volume $all_ec2.BlockDeviceMappings[$i].Ebs.VolumeId -ProfileName $cred_profile
                $tmp_ec2.disks_total_size += $tmp_ebs.Size
            }

            If($tmp_ec2.disks -eq 3)
            {
                $tmp_ebs_0 = Get-EC2Volume $all_ec2.BlockDeviceMappings[0].Ebs.VolumeId -ProfileName $cred_profile
                $tmp_ebs_1 = Get-EC2Volume $all_ec2.BlockDeviceMappings[1].Ebs.VolumeId -ProfileName $cred_profile
                $tmp_ebs_2 = Get-EC2Volume $all_ec2.BlockDeviceMappings[2].Ebs.VolumeId -ProfileName $cred_profile

                $tmp_ec2.disk_0_size = $tmp_ebs_0.Size
                $tmp_ec2.disk_0_type = $tmp_ebs_0.VolumeType
                $tmp_ec2.disk_0_iops = $tmp_ebs_0.Iops
                $tmp_ec2.disk_0_throughput = $tmp_ebs_0.Throughput

                $tmp_ec2.disk_1_size = $tmp_ebs_1.Size
                $tmp_ec2.disk_1_type = $tmp_ebs_1.VolumeType
                $tmp_ec2.disk_1_iops = $tmp_ebs_1.Iops
                $tmp_ec2.disk_1_throughput = $tmp_ebs_1.Throughput

                $tmp_ec2.disk_2_size = $tmp_ebs_2.Size
                $tmp_ec2.disk_2_type = $tmp_ebs_2.VolumeType
                $tmp_ec2.disk_2_iops = $tmp_ebs_2.Iops
                $tmp_ec2.disk_2_throughput = $tmp_ebs_2.Throughput
            }
            Else
            {
                Write-Host -ForegroundColor Yellow "$($all_ec2.name) isnt bosh managed, capturing only total stats."
            }
        }
        else
        {
            Write-Host -ForegroundColor Yellow "$($tmp_ec2.name) has no disks."
        }
        $out_ec2s += $tmp_ec2

    }
}
$out_date = Get-Date -Format "yyyy-MM-dd_HH_mm_ss"
$out_ec2s | Select-Object | ft
$out_ec2s | Select-Object | Export-Csv -NoTypeInformation -Path "./output/aws_ec2_inventory_$($out_date)_$($report_name).csv"