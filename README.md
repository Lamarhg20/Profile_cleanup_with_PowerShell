# 

<h1>Profile_cleanup_with_PowerShell</h1>
<h2>Description</h2>
These are power scripts that will clean up old user profiles. Always make a registry back up when making changes to registry and always run script in a test environment to see how they will impact you system before implementing <br/>

<h2>Environments Used </h2>

- <b>Windows 10</b> 


<h2>How to Use:</h2>

-Before using, edit the PowerShell script. Fill in your Domain name where ever prompted. <br/> 
-# out Remove-Item $profilePath -Force -Recurse and Remove-Item $profileImagePath -Force -Recurse to see if script returns error before running. <br/>
-Run PowerShell ISE as an administrator and open .ps1 script <br/>
<br/>
<br/>
-<b>Login_event_profile_cleanup.ps1</b> 
-Before using, edit the PowerShell script.# out Remove-Item $profilePath -Force -Recurse and Remove-Item $profileImagePath -Force -Recurse to see if script returns error before running. Add any profile you want it to ignore.<br/>
<br/>
<br/>
-<b>Folder_last_modified_cleanup.ps1</b> 
-Before using, edit the PowerShell script.# out Remove-Item $profilePath -Force -Recurse and Remove-Item $profileImagePath -Force -Recurse to see if script returns error before running. Add any profile you want it to ignore. <br/>
-change the folder name to any folder in the user profile path you want it to check for. by default is set to "OneDrive". <br/>
<br/>
<br/>
-<b>Folder_last_modified_cleanup.ps1</b> 
-Before using, edit the PowerShell script.# out Remove-Item $profilePath -Force -Recurse and Remove-Item $profileImagePath -Force -Recurse to see if script returns error before running. Add any profile you want it to ignore. Change the "domain" to your domain name.<br/> 



  <!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
