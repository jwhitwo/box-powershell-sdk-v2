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
        }
        else
        {
            #user found in Box, continue
            $log += " User found in Box ($copyToID)."

            #rename the folder to USERNAME's S Drive
            $name = "Test S Drive Migraton"
            #$return = Set-BoxFolderName -token $token -folderID $item.id -name $name

            $log += " Renamed to $name."

            #create a new collaboration
            #$collabID = New-BoxCollaboration -token $token -folderID $item.id -userID $copyToID -role "co-owner"
            $log += " WhatIf - new collab on $($item.id) with $($copyToID) as co-owner."
            $log += " Added collaborator."

            #new collaboration created, now set the collaborator as the owner
            $log += " Whatif - set new collab on $collabID as owner"
            #$return = Set-BoxCollaboration -token $token -collabID $collabID -role "owner"

            if($return -eq $null){ $log += " ERROR: Unable to set collaborator!"}
            else
            {
                $log += " Set new owner."

                #remove previous collaborator
               # $folderID = $item.id

                #first, get the existing collaborator
                #$return = Get-BoxFolderCollab -token $token -folderID $folderID
        
            #    $collabID = $return.entries[0].id

             #   $log += " Found new collaboration id ($collabID)." 

                #remove the collaborator entry
            #    Remove-BoxCollaborator -token $token -collabID $collabID
                $log += " Previous collaborator removed."
            }
        }
        
    }
    else
    {
        $log += " Item is not a folder."
    }

    $log | Out-File $logfile -Append
}

$log = "$(Get-date -Format G) : Migration complete.`r`n"