$RANDO = 0 #tested working 04302022 1017
$user = @("P114320a","A3T2YZZ") #tested working 04302022 1017
$pth = @("C:\Users\"+$USER[$RANDO]+"\Downloads\"); $pth +=@("C:\Users\"+$USER[$RANDO]+"\Documents\WindowsPowershell\deletelog.txt")  #tested working 04302022 1017
$a = Get-ChildItem -Path $pth[0] -attributes !Directory;  #tested working 04302022 1017
$g = $a |Group-Object {($_.BaseName -replace '\(\d+\)$', '').Trim()+$_.extension}  #testing
foreach($ex in $g){
    if($ex.count-gt 1){
        $tmp = $ex.group; $time = Get-Date; 
        "The following files were flagged for deletion at: $time"|Out-File -FilePath $pth[1] -Append; 
        ($tmp|sort-object -Property creationtime | select -SkipLast 1).fullname|Out-File -FilePath $pth[1] -Append;
        #Remove-item -Path ($tmp|sort-object -Property creationtime | select -SkipLast 1).fullname;
    }
} #list of stuff to delete
# C:\Users\P114320A\Documents\WindowsPowerShell\CleanUpRev3.ps1rive  