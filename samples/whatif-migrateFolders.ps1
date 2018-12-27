$token = "Ljdp9Cwz7waW4rKIl0NwRUECElTnwL0R"

$logfile = "migration.log"

$log = "$(Get-date -Format G) : Starting Migration.`r`n"

#takes iterates through each sub-folder any copies the folder to a username with the same name

#the parent migration folder
$parent = "61189337812"

#return all sub items of the parent
$subfolders = Get-BoxSubItems -token $token -parent $parent
$log += "$(Get-date -Format G) : $($subfolders.count) sub-items found."

$log | Out-File $logfile -Append

foreach($item in $subfolders)
{
    #verify the item is a folder and not a file
    $log = "$(Get-date -Format G) : Elvaluating $($item.name)."

    if($item.type -eq "folder")
    {
        $user = $item.name + "@uncg.edu"
        $log += " Folder found. Belongs to $user."

        #get the destination user ID
        $copyToID = Get-BoxUserID -token $token -username $user

        if($copyToID -eq $null)
        {
            #user is not found in Box
            $log += " ERROR: User not found in Box!`r`n"
            $fail++
        }
        else
        {
            #user found in Box, continue
            $log += " User found in Box ($copyToID)."

            #rename the folder to USERNAME's S Drive
            $name = "$($item.name)'s S drive migrated by ITS"
            #$return = Set-BoxFolderName -token $token -folderID $item.id -name $name

            $log += " Renamed to $name."

            #create a new collaboration
            #$collabID = New-BoxCollaboration -token $token -folderID $item.id -userID $copyToID -role "co-owner"
            $log += " WhatIf - new collab on $($item.id) with $($copyToID) as co-owner."
            
            $success++
        }
        
    }
    else
    {
        $log += " Item is not a folder."
    }


    $log | Out-File $logfile -Append
}

$log = "$(Get-date -Format G) : WhatIf complete. Success: $sucess Failure: $fail`r`n"
$log | Out-File $logfile -Append