
# Define the time threshold for (30days)
$threshold = (Get-Date).AddDays(-30)

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
		# Check when a profile was last used
		$sid = $profile.PSChildName
		$userRegPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid"
		try {
			$lastUseTime = Get-WinEvent -filterHashtable @{LogName='Security'; Id='4624'; StartTime=$threshold
			}
			$regex = [regex]::Match($profileImagePath, "\b\w+$")
			$user =$regex.Value
			$logList =@{}
			$userLogin = $lastUseTime | Where {$_.Message -like "*$user*"-and $_.Message -like "*Domain*"
			}
			$loginCount =($lastUseTime | Measure).Count
		

		# Compare last used time with threshold
		if ($loginCount -eq 0) {
			Write-Output "Removing profile for User $user was used $loginCount time in the last 30 days"
			#Remove-Item $profilePath -Force -Recurse
			#Remove-Item $profileImagePath -Force -Recurse
		} Else {
			Write-Output "Profile for User $user was used $loginCount time in the last 30 days."
			}
		} catch {
			Write-Error "Failed to process profile $sid. Error: $_"
		}
}

 LogonType='11'; 