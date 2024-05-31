# Define the time threshold for (90days)
$threshold = (Get-Date).AddDays(-90)

# Get the list of user profiles from registry
$profileListPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList"

$profiles = Get-ChildItem -Path $profileListPath

foreach ($profile in $profiles) {
	# Each subkey's ProfileImagePath will provide profile details
	$profilePath = $profile.PSPath
	$profileImagePath = (Get-ItemProperty -Path $profilePath -Name ProfileImagePath).ProfileImagePath
	
	# Exclude specific users
	if ($profileImagePath -like '*\Profile') {
		Write-Output "Skipping Default profiles at path $profileImagePath"
		continue
	}
	# Path to Ondrive folder in the user's directory
	$oneDrivePath = Join-Path -Path $profileImagePath -ChildPath "OneDrive"

	#Check if folder exists
	if (Test-Path $oneDrivePath) {
		$oneDriveLastWrite = (Get-Item -Path $oneDrivePath).LastWriteTime

		# Compare last used with threshold
		if ($oneDriveLastWrite -lt $threshold) {
			Write-Output "Removing profile for $profileImagePath last used on $oneDriveLastWrite"
			Remove-Item $profilePath -Force -Recurse
			Remove-Item $profileImagePath -Force -Recurse
		} 
		elseif ($oneDriveLastWrite -gt $threshold) {
			Write-Output "Profile for $profileImagePath last used on $oneDriveLastWrite is within the threshold."
		} 
		else {
			Write-Error "Failed to process profile $profileImagePath. Error: $_"
		}
	}
}

	