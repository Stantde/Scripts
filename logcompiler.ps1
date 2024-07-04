<#The purpose of this script is to organize all logs into a single loctaion.

The script will consist of two parts:
    one for the main,
    one for the satellite.

Refer to flow chart.   
    #>
#Satellite
function isThisMain(){
$mainorsatellite = Test-path -Path "C:\Users\a3t2yzz\OneDrive - 3M\Documents\WindowsPowerShell\PowershellLog.txt" #$mainorsatellite is $true for main path
    if ($mainorsatellite){
        return "Yes"
        }
    if (!$mainorsatellite){
        return "No"
        }
}
$mainorsatellite = Test-path -Path "C:\Users\a3t2yzz\OneDrive - 3M\Documents\WindowsPowerShell\PowershellLog.txt" #$mainorsatellite is $true for main path
if(!$mainorsatellite){#Must be satellite
    #Check for M: Drive
    $lookforme = "\\usfile01\us-ac-common" #Name of the PSDrive root. 
    if(Test-Path ($lookforme)){ #Does the root exist?
        #Root exists.
        $satellite = Get-PSDrive | ? {$_.Displayroot -eq $lookforme} #Gets the name of the drive and stores it as drive.
        }
    }
#Main