

<div align="center">
<strong>
<samp>

[![Build on Windows](https://github.com/Zhaopudark/JetBrainsMonoNerdFonts/actions/workflows/build_on_windows.yaml/badge.svg)](https://github.com/Zhaopudark/JetBrainsMonoNerdFonts/actions)
[![Build on Linux](https://github.com/Zhaopudark/JetBrainsMonoNerdFonts/actions/workflows/build_on_linux.yaml/badge.svg)](https://github.com/Zhaopudark/JetBrainsMonoNerdFonts/actions)

[English](README.md) · [简体中文](README.ZH-CN.md)

</samp>
</strong>
</div>

# JetBrainsMonoNerdFonts (OpenType Layout, TrueType Outlines) (Regulear)

一个自更新的[JetBrains Mono](https://github.com/JetBrains/JetBrainsMono)编译版本，为其附加了[Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)字形。

# Features or Limitations

- 添加了当前所有可获得的`Nerd Fonts`字形。（通过`--complete`）
- 目标是供`编辑器`或`终端`使用。因此：
  - 只针对`Regular`字体，移除了其他字体。
  - 只对`JetBrainsMono-Regular.ttf`进行了补丁，输出为`JetBrainsMonoNerdFont-Regular.ttf`。

# License

- 代码: [MIT License](https://github.com/ryanoasis/nerd-fonts/blob/master/LICENSE)
- 字体: [OFL-1.1 License](https://github.com/JetBrains/JetBrainsMono/blob/master/OFL.txt)

# Usage

**注意**: 这个仓库可以借助`Github Actions`自动更新和发布（部署）。您可以直接在[发布页面](https://github.com/Zhaopudark/JetBrainsMonoNerdFonts/releases)找到最新版本的字体文件`JetBrainsMonoNerdFont-Regular-v*.*.ttf`并下载安装使用。

或者，您可以按照下面的步骤自行编译。

## Build

### Build on Windows
- 要求：
    - `Windows` 平台.
    - [PowerShell 7.x](https://github.com/PowerShell/PowerShell).
      - 为了稳定构建，您需要提供一个`Github个人访问令牌`作为shell变量`$GithubPAT`.
    - `Python 3.11` 或更高（前提是能正确安装后续依赖）.
    - `Winget`工具，例如[winget-cli](https://github.com/microsoft/winget-cli)
    - 其他工具：
      - [PSComputerManagementZp](https://www.powershellgallery.com/packages/PSComputerManagementZp)
      - [FontForge](https://fontforge.org/en-US/downloads/)
      - [gftools builder](https://googlefonts.github.io/gf-guide/build.html)
      - [fonttools](https://fonttools.readthedocs.io/en/latest/)
      
- 编译步骤：
    
  ```powershell
  git clone https://github.com/Zhaopudark/JetBrainsMonoNerdFonts.git
  cd JetBrainsMonoNerdFonts
  
  Install-Module -Name PSComputerManagementZp -Force
  Import-Module PSComputerManagementZp
  
  winget install --id FontForge.FontForge --force # UAC prompt may occur
  Add-PathToCurrentProcessEnvPath -Path "C:\Program Files (x86)\FontForgeBuilds\bin"

  pip install -r "./requirements.txt" -q
  . ".\build.ps1"
  ```
- 得到输出文件 `.\Output\JetBrainsMonoNerdFont-Regular.ttf`.

### Build on Linux

- 要求：
  - `Linux` 平台.
  - [PowerShell 7.x](https://github.com/PowerShell/PowerShell).
    - 为了稳定构建，您需要提供一个`Github个人访问令牌`作为shell变量`$GithubPAT`.
  - `Python 3.11` 或更高（前提是能正确安装后续依赖）.
  - 其他工具：
    - [FontForge](https://fontforge.org/en-US/downloads/)
    - [gftools builder](https://googlefonts.github.io/gf-guide/build.html)
    - [fonttools](https://fonttools.readthedocs.io/en/latest/)

- 编译步骤：
  
  ```powershell
  git clone https://github.com/Zhaopudark/JetBrainsMonoNerdFonts.git
  cd JetBrainsMonoNerdFonts
  
  sudo apt install fontforge
  
  pip install -r "./requirements.txt" -q
  . "./build.ps1"
  ```
  
- 得到输出文件 `.\Output\JetBrainsMonoNerdFont-Regular.ttf`.

