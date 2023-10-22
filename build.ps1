$guid = [guid]::NewGuid().ToString()
$temp_path = "${Home}/tmp/$guid"
$font_to_be_pathced = "JetBrainsMono-Regular.ttf"
$font_patched = "JetBrainsMonoNerdFont-Regular.ttf"
New-Item $temp_path -ItemType Directory -Force
## Build JetBrainsMono
git submodule update --init --recursive  # check the submodule `JetBrainsMono` as latest release version
git submodule foreach 'git reset --hard && git checkout master && git pull' # should be master instead of main
Set-Location "${PSScriptRoot}/JetBrainsMono"
git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) --force
Set-Location $PSScriptRoot
Copy-Item "$PSScriptRoot/gftools_builder_config.yaml" -Destination "$PSScriptRoot/JetBrainsMono/sources/config.yaml" -Force

gftools builder "$PSScriptRoot/JetBrainsMono/sources/config.yaml"

## Install FontPatcher and prepare target font that will be patched
$repoUrl = "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" # Send a GET request to the GitHub API to get the latest release information
$releaseInfo = Invoke-RestMethod -Uri $repoUrl 
$fontPatcherAsset = $releaseInfo.assets | Where-Object { $_.name -eq "FontPatcher.zip" } # Find the asset with the name "FontPatcher.zip"
if ($fontPatcherAsset) {
    $downloadUrl = $fontPatcherAsset.browser_download_url
    Invoke-WebRequest -Uri $downloadUrl -OutFile "$temp_path/FontPatcher.zip"
    Write-Host "Downloaded $("$temp_path/FontPatcher.zip")"
} else {
    Write-Host "FontPatcher.zip not found in the latest release."
}
Expand-Archive -Path "$temp_path/FontPatcher.zip" -DestinationPath "$temp_path/FontPatcher" -Force

Copy-Item -LiteralPath "$PSScriptRoot/JetBrainsMono/fonts/ttf/$font_to_be_pathced" -Destination "$temp_path/FontPatcher/$font_to_be_pathced" -Force

Set-Location  "$temp_path/FontPatcher"
fontforge -script font-patcher "./$font_to_be_pathced" -out "./" --complete --careful --quiet
Set-Location $PSScriptRoot 
Copy-Item -LiteralPath "$temp_path/FontPatcher/$font_patched" -Destination "$PSScriptRoot/Output/$font_patched" -Force

# reset submodule
git submodule foreach 'git reset --hard && git checkout master && git pull'