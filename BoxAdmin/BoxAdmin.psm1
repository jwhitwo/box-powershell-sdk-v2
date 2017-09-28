#BoxAdmin.psm1
$Global:box_token = $null

function Connect-Box()
{
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$True,Position=1)]
       [string]$token
    )

    $Global:box_token = $token

    #verify connection to Box API using provided token
    $uri = "https://api.box.com/2.0/users/me"
    $headers = @{"Authorization"="Bearer $Global:box_token"}

    try{
        Write-host "Connecting to Box..."
        $json = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/x-www-form-urlencoded"
        write-host "Connected as $($json.login) [$($json.name)]"
    }
    catch{
        #catch any errors
        Write-Host "Unable to connect to Box." -ForegroundColor Red
        Write-Debug "Error on API call:`r`n$_`r`n"

        return $null
    }
}

function Get-BoxUser()
{
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$True,Position=1)]
       [string]$login
    )
    #returns the Box user id number for a given username
    $uri = "https://api.box.com/2.0/users?filter_term=" + $login
    $headers = @{"Authorization"="Bearer $Global:box_token"} 
    
    $return = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "applicaiton/x-www-form-urlencoded"
    
    if($return.total_count -eq 0){return $null}
    else {return $return.entries}
}