#######Get List of Users########
$logonDate = Get-Date
$logonDatead = $logonDate.AddDays(-30)
$username = Get-ADUser -filter {(lastlogondate -gt $logonDatead) } -Properties lastlogondate 
#$users = $username.userprincipalname





foreach ($user in $username)
{
 
 
    $us = Get-ADUser -identity "$user" -Properties LastLogonDate | select samaccountname, Name, LastLogonDate | Sort-Object LastLogonDate -erroraction silentlycontinue
    


    foreach ($u in $us)


 {
    $prop = @{
    "LastLogonDate" = $u.LastLogonDate;
    "Name" = $u.Name;
    
    }
 
 $obj = new-object -TypeName PSObject -Property $prop

 ##change the export output area
 write-output $obj | sort-object Name | export-csv -Path "C:\AD Audit Reports\userreport_$((Get-Date).ToString('MM-dd-yyyy')).csv" -NoTypeInformation -append -force


}

}


