[OutputType([bool])]
param(
    [Parameter(Mandatory)]
    [string] $UserName,
    [Parameter(Mandatory)]
    [string] $RepoName
)
try{
    $last_release = Invoke-RestMethod -Uri "https://api.github.com/repos/$UserName/$RepoName/releases"
    $last_release_time = [System.DateTime]::Parse($last_release.created_at)
    Write-Host "Last release time: $($last_release_time.ToString("yyyy-MM-dd HH:mm:ss"))"
    $current_time = Get-Date
    Write-Host "Current time: $($current_time.ToString("yyyy-MM-dd HH:mm:ss"))"
    $time_difference = New-TimeSpan -Start $last_release_time -End $current_time
    $time_difference = [math]::Round($time_difference.TotalHours)
    Write-Host "Time difference: $time_difference"
    if ($time_difference -le 24) {
        return $true
    } else {
        return $false
    }
}catch{
    return $false
}