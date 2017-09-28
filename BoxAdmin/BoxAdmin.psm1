#BoxAdmin.psm1

function Connect-Box()
{
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$True,Position=1)]
       [string]$token
    )

    #verify connection to Box API using provided token
    $uri = "https://api.box.com/2.0/users/me"
    $headers = @{"Authorization"="Bearer $token"}

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