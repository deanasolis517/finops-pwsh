<# 
AWS SSO Login is required to run this script from a local dev environment.
example:  aws sso login --profile us-2931

#>

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
Write-Host "You selected region:" -ForegroundColor Yellow 
Write-host $region -ForegroundColor Cyan
Write-Host "Using credential profile:" -ForegroundColor Yellow
Write-Host $cred_profile -ForegroundColor Cyan
Write-Host "for report name: " -ForegroundColor Yellow
Write-Host $report_name -ForegroundColor Cyan
