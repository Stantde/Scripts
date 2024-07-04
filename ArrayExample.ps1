$Array = @();
$Processes = Get-Process;
Foreach($Proc in $Processes)
{
    If($Proc.ws/1mb -gt 100)
    {
        $Array += New-Object psobject -Property @{'ProcessName' = $Proc.name; 'WorkingSet' = $Proc.ws};
    }
}    
$Array | select 'ProcessName' , 'WorkingSet' | Export-Csv .\file.csv -NoTypeInformation;
$CSVImport = @();
$CSVImport = Import-Csv .\file.csv;
ForEach($obj in $CSVImport)
{
    Write-Host "Process Name:" $obj.processname `n " Working Set:" $obj.workingset
}