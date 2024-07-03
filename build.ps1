param(
    [Parameter(Mandatory)]
    [string] $GithubPAT
)

$guid = [guid]::NewGuid().ToString()
$temp_path = "${Home}/tmp/$guid"
$temp_path = "${Home}/tmp/5e0661b6-6ce0-43f7-9297-a5ea8cd4da35"
$font_to_be_pathced = "JetBrainsMono-Regular.ttf"
$font_patched = "JetBrainsMonoNerdFont-Regular.ttf"

New-Item $temp_path -ItemType Directory -Force

$headers = @{
    Authorization = "token $GithubPAT"
}
# Download the latest release of JetBrainsMono
# NOTE: It will take a long time to clone the JetBrainsMono repo as a submodule, so it is recommended to use the GitHub API to download the latest release only.
$response  = Invoke-RestMethod -Uri "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" -Headers $headers
# Extract the URL for the zipball of the latest release
$zipUrl = $response.zipball_url
# Define the output file path
$outputFile = "$temp_path/JetBrainsMono-latest.zip"
# Download the zipball
Invoke-WebRequest -Uri $zipUrl -Headers $headers -OutFile $outputFile
Write-Output "The latest release of JetBrainsMono has been downloaded to $outputFile"
Expand-Archive -Path $outputFile -DestinationPath $temp_path -Force

$JetBrainsMono_path = (Get-Item "$temp_path/JetBrains*" -Exclude "*.zip").FullName
write-host $JetBrainsMono_path

# Build JetBrainsMono
Copy-Item "$PSScriptRoot/gftools_builder_config.yaml" -Destination "$JetBrainsMono_path/sources/config.yaml" -Force
gftools builder "$JetBrainsMono_path/sources/config.yaml"

# Install FontPatcher and prepare target font that will be patched
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" -Headers $headers
$fontPatcherAsset = $response.assets | Where-Object { $_.name -eq "FontPatcher.zip" } # Find the asset with the name "FontPatcher.zip"
if ($fontPatcherAsset) {
    $downloadUrl = $fontPatcherAsset.browser_download_url
    Invoke-WebRequest -Uri $downloadUrl -Headers $headers -OutFile "$temp_path/FontPatcher.zip" 
    Write-Host "Downloaded $("$temp_path/FontPatcher.zip")"
} else {
    Write-Error "FontPatcher.zip not found in the latest release."
}
Expand-Archive -Path "$temp_path/FontPatcher.zip" -DestinationPath "$temp_path/FontPatcher" -Force
$FontPatcher_path = (Get-Item "$temp_path/FontPatcher" -Exclude "*.zip").FullName
Write-Host $FontPatcher_path
Copy-Item -LiteralPath "$JetBrainsMono_path/fonts/ttf/$font_to_be_pathced" -Destination "$FontPatcher_path/$font_to_be_pathced" -Force

# Patch the font
Set-Location $FontPatcher_path
fontforge -script font-patcher "./$font_to_be_pathced" -out "./" --complete --careful --quiet
Set-Location $PSScriptRoot 
Copy-Item -LiteralPath "$FontPatcher_path/$font_patched" -Destination "$PSScriptRoot/Output/$font_patched" -Force