$a = Get-ChildItem -Path "C:\Users\P114320a\Downloads\" -attributes !Directory; #"..copied from code
$g = $a |Group-Object {($_.BaseName -replace '\(\d+\)$', '').Trim()} #g was assigned on line 62
foreach($ex in $g){
    if($ex.count-gt 1){
        $tmp = $ex.group; $time = Get-Date; 
        "The following files were flagged for deletion at: $time"|Out-File -FilePath C:\Users\P114320a\Documents\WindowsPowershell\deletelog.txt -Append; 
        ($tmp|sort-object -Property creationtime | select -SkipLast 1).fullname|Out-File -FilePath C:\Users\P114320a\Documents\WindowsPowershell\deletelog.txt -Append;
        Remove-item -Path ($tmp|sort-object -Property creationtime | select -SkipLast 1).fullname;
    }
} #list of stuff to delete