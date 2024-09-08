$dataBricksResourceId  = "517183117086332"

# Assume that you have already logged in to Azure using Connect-AzAccount
# Connect-AzAccount -Tenant $tenantId

$azureADToken = Get-AzAccessToken -ResourceUrl $dataBricksResourceId | Select-Object -ExpandProperty Token

Write-Host "Create Databricks Cluster"

$body = @{
    cluster_name = "https://adb-517183117086332.12.azuredatabricks.net"
    spark_version = "5.5.x-scala2.11"
    node_type_id = "Standard_DS3_v2"
    autoscale = @{
        min_workers = 1
        max_workers = 2
    }
    autotermination_minutes = 30
} | ConvertTo-Json

$headers = @{
    "Authorization"="Bearer " + "$zureADToken";
    "Content-Type"="application/json";
}

$uri = "$uriroot/2.0/clusters/create"

Write-Host $uri
Write-Host $headers

try { $response = Invoke-RestMethod -Method 'Post' -Uri $uri -Headers $headers -Body $body }
catch { 
    Write-Host $_
    Write-Host $_.ScriptStackTrace
    Write-Host $_.Exception
    Write-Host $_.ErrorDetails
}

Write-Host $response