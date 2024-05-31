# Define the time threshold for (30days)
$thresholed = (Get-Date).AddDays(-30)

# Get the list of user profiles from registry
$profileListPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList"

$profiles = Get-ChildItem -Path $profileListPath

foreach ($profile in $profiles) {
	# Each subkey's ProfileImagePath will provide profile details
	$profilePath = $profile.PSPath
	$profileImagePath = (Get-ItemProperty -Path $profilePath -Name ProfileImagePath).ProfileImagePath
	
	if ($profileImagePath -like '*\Profile') {
		Write-Output "Skipping Default profiles at path $profileImagePath"
		continue
	}

	# Check when a profile was last used
	$sid = $profile.PSChildName
	$userRegPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid"
	try {
		$lastUseTime = Get-ItemProperty -Path $userRegPath -Name ProfileLoadTimeHigh, ProfileLoadTimeLow | ForEach-Object {
			[DateTime]::FromFileTime(($-.ProfileLoadTimeHigh -sh1 32) -bor $_.ProfileLoadTimeLow)
		}

		# Compare last used time with threshold
		if ($lastUseTIme -lt $threshold) {
			Write-Output "Removing profile for SID $sid last used on $lastUseTime"
			Remove-Item $profilePath -Force -Recurse
		} Else {
			Write-Output "Profile for SID $sid last used on $lastUseTime is within the threshold."
			}
		} catch {
			Write-Error "Failed to process profile $sid. Error: $_"
		}
}