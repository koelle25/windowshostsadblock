# Windows hosts-based AdBlock
With this small application (written in PowerShell) your complete Web-Experience will be mostly ad-free - thanks to hosts-based blocking.

## Usage
1. [**!!! important !!!**] Change line 6 in the *script.ps1* to the path, where your script is in
2. Put the contents of your current hosts file (*C:\Windows\System32\drivers\etc\hosts*) into the *0-default.hosts* file.
3. Put any other hosts you would like to block/redirect in files, structured to your pleasure (e.g. *1-bad.hosts*, *2-redirect.hosts*, ...) - **don't use number 99** (reserved for the adblock-hosts).
4. Execute the *Update*-File by just double-clicking it
5. Surf the Web - Ad-Free!

## Requirements
- Windows 7, 8, 8.1, 10
- PowerShell v3+