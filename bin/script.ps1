# Check for PowerShell v3 or greater
if ($PSVersionTable.PSVersion.Major -ge 3) {
	
	# Self elevating PowerShell script
	if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
	cd "C:\Users\Kevin\Desktop\Dokumente\windowshostsadblock" # CHANGE THIS ACCORDINGLY !!!

	# Paths
	$RemoteHostsURL = "http://someonewhocares.org/hosts/ipv6/hosts"
	$LocalLatestAdblock = "$PSScriptRoot\latest-adblock.txt"
	$AdblockHosts = "$PSScriptRoot\..\hosts\99-adblock.hosts"
	$TempHostsFile = "$PSScriptRoot\hosts.tmp"
	$RealHostsFile = "C:\Windows\System32\drivers\etc\hosts"

	# Get Last-Modified
	$WebResponse = Invoke-WebRequest $RemoteHostsURL -Method Head
	$RemoteLastModified = $WebResponse.Headers["Last-Modified"]
	$RemoteDate = [DateTime] $RemoteLastModified
	if (Test-Path $LocalLatestAdblock) {
		$LocalLastModified = Get-Content -Path $LocalLatestAdblock
		$LocalDate = [DateTime] $LocalLastModified
	}

	# Compare and only download if remote is newer
	if ($LocalLastModified -eq $Null -or $RemoteDate.CompareTo($LocalDate) -gt 0) {
		# Remote is newer
		Write-Host "Remote Hosts-File is newer, getting it ..."
		
		# Write new Date into $LocalLatestAdblock
		$Stream = [System.IO.StreamWriter] $LocalLatestAdblock
		$Stream.Write("$RemoteLastModified")
		$Stream.Close()
		
		# Write adblock-hosts in $AdblockHosts
		$WebResponseFull = Invoke-WebRequest $RemoteHostsURL
		$Stream = [System.IO.StreamWriter] $AdblockHosts
		$Stream.Write("$WebResponseFull")
		$Stream.Close()
	} else {
		Write-Host "You have the newest Hosts-File. Just refreshing it locally."
	}
	
	# Build new Hosts-File
	Write-Host "Building new Hosts-File ..."
	$HostsFiles = Get-ChildItem hosts\*.hosts
	$Stream = [System.IO.StreamWriter] "$TempHostsFile"
	foreach ($File in $HostsFiles) {
		$Contents = Get-Content $File.FullName -Raw
		$Stream.WriteLine("$Contents")
	}
	$Stream.Close()
	
	# Activate new Hosts-File in System
	Write-Host "Activating new Hosts-File in the System ..."
	Copy-Item -Path $TempHostsFile -Destination $RealHostsFile -Force
	
	Write-Host "Done!"
	Write-Host "You may have to restart your Computer for the changes to apply."
} else {
	Write-Host "Sorry, your PowerShell-Version is too old - consider upgrading"
}

Write-Host "Press any key to continue ..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")