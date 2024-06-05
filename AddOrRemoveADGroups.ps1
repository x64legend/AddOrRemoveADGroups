# Import Modules
Import-Module ActiveDirectory

# Groups - can be adjusted
$group1 = "changeme"
$group2 = "changeme"
$group3 = "changeme"

# Reset Variable
$userValid = $false

# Checks to see if the user exists in AD
while (-not $userValid) {
    # Assign a user to action
    $user = Read-Host "Please enter the firstname.lastname of the user to action."
    Write-Host "User set to $user - searching AD for user..."

    if (Get-ADUser -Filter "samaccountname -eq '$user'") {
        Write-Host "User found!" -ForegroundColor Green
        $userValid = $true
    } else {
        Write-Host "User not found. Please try again." -ForegroundColor Yellow
        $userValid = $false
    }
}
Write-Host "Group adjuster!" -ForegroundColor Cyan
$groupAction = Read-Host "Would you like to add (A) or remove (R) groups? Press (Q) to quit."
switch ($groupAction) {
    "A" { # Adds groups 1 and 2 and removes group 3. 
        Write-Host "Adding $group1 and $group2..."
        Add-ADGroupMember $group1 $user 
        Add-ADGroupMember $group2 $user 
        Write-Host "Done!" -ForegroundColor Green

        Write-Host "Removing $group3..."
        Remove-ADGroupMember $group3 $user -Confirm:$false 
        Write-Host "Done!" -ForegroundColor Green

        Write-Host "Groups have been adjusted - here are $user's new groups"
        Get-ADUser $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup | Select-Object name | Sort-Object name | Format-Table

        Write-Host "User groups have been displayed. This screen will stay up for 30 seconds unless you close it before then"
        Start-Sleep -s 30
      }
    "R" { # Removes Dynamics groups and adds an E3 license.
        Write-Host "Removing $group1 and $group2..."
        Remove-ADGroupMember $group1 $user -Confirm:$false
        Remove-ADGroupMember $group2 $user -Confirm:$false
        Write-Host "Done!" -ForegroundColor Green

        Write-Host "Adding $group3..."
        Add-ADGroupMember $group3 $user
        Write-Host "Done!"

        Write-Host "Groups have been adjusted - here are $user's new groups"
        Get-ADUser $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup | Select-Object name | Sort-Object name | Format-Table

        Write-Host "User groups have been displayed. This screen will stay up for 30 seconds unless you close it before then"
        Start-Sleep -s 30
    }
    "Q" {
        Break
    }
    Default {
        Write-Host "Please make a valid selection."
    }
}
