

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

An auto-updated compiling version of [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) that has been patched with [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts).

# Features or Limitations
- Add all available `Nerd Fonts` glyphs by `--complete`.
- Aim to `editor` and `terminal` scenarios. So:
  - Only patch `Regular` font and remove any other fonts.
  - Only patch `JetBrainsMono-Regular.ttf` and output `JetBrainsMonoNerdFont-Regular.ttf`.

# License
- Codes: [MIT License](https://github.com/ryanoasis/nerd-fonts/blob/master/LICENSE)
- Fonts: [OFL-1.1 License](https://github.com/JetBrains/JetBrainsMono/blob/master/OFL.txt)


# Usage

**NOTICE**: This repository can update automatically by `Github Actions`. You can just download `JetBrainsMonoNerdFont-Regular-v*.*.ttf` from [the latest release](https://github.com/Zhaopudark/JetBrainsMonoNerdFonts/releases).

Or, you can build it by yourself as the following steps.

## Build

### Build on Windows
- Requirements:
    - `Windows` platform.
    - `Python 3.11` or higher. (As long as you can install the following dependencies correctly.)
    - `Winget`, i.e., [winget-cli](https://github.com/microsoft/winget-cli)
    - Other Tools:
      - [PSComputerManagementZp](https://www.powershellgallery.com/packages/PSComputerManagementZp)
      - [FontForge](https://fontforge.org/en-US/downloads/)
      - [gftools builder](https://googlefonts.github.io/gf-guide/build.html)
      - [fonttools](https://fonttools.readthedocs.io/en/latest/)
    
- Steps:
  
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
  
- Get the output font file from `.\Output\JetBrainsMonoNerdFont-Regular.ttf`.

### Build on Linux

- Requirements:
  - `Linux` platform.
  - `Python 3.11` or higher. (As long as you can install the following dependencies correctly.)
  - Other Tools:
    - [FontForge](https://fontforge.org/en-US/downloads/)
    - [gftools builder](https://googlefonts.github.io/gf-guide/build.html)
    - [fonttools](https://fonttools.readthedocs.io/en/latest/)

- Steps:
  
  ```powershell
  git clone https://github.com/Zhaopudark/JetBrainsMonoNerdFonts.git
  cd JetBrainsMonoNerdFonts
  
  sudo apt install fontforge
  
  pip install -r "./requirements.txt" -q
  . "./build.ps1"
  ```
  
- Get the output font file from `.\Output\JetBrainsMonoNerdFont-Regular.ttf`.