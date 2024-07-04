<#The purpose of this script is to organize all logs into a single loctaion.

The script will consist of two parts:
    one for the main,
    one for the satellite.

Refer to flow chart.   
    #>
function isThisMain(){
$mainorsatellite = Test-path -Path "C:\Users\a3t2yzz\OneDrive - 3M\Documents\WindowsPowerShell\PowershellLog.txt" #$mainorsatellite is $true for main path
    if ($mainorsatellite){
        return $true #"Main"
        }
    if (!$mainorsatellite){
        return $false #"Satellite"
        }
}
function isThereCloud(){
        $lookforme = "\\usfile01\us-ac-common" #Name of the PSDrive root. 
        if(Test-Path ($lookforme)){ #Does the root exist?
                return "We Have Clouds!" #$satellite = Get-PSDrive | ? {$_.Displayroot -eq $lookforme} #Gets the name of the drive and stores it as drive.
        } else {return $null}

}
function createClouds([string] $a, [string] $b){ return $null}
function thisIsNotMain(){}
$1 = isThisMain;
$CloudsExist = isThereCloud;#Cloud test
#Next, look for the log file. Also have a specific loctaion in mind.
#See Example: Start-Transcript -Append -Path "C:\Users\a3t2yzz\OneDrive - 3M\Documents\WindowsPowerShell\PowershellLog.txt";
CreateClouds($MoS, $CloudsExist);

<#
A basic switch statement has the following format:

    Switch (<test-expression>)
    {
        <result1-to-be-matched> {<action>}
        <result2-to-be-matched> {<action>}
    }

The equivalent if statements are:

    if (<result1-to-be-matched> -eq (<test-expression>)) {<action>}
    if (<result2-to-be-matched> -eq (<test-expression>)) {<action>}

switch (3)
    {
        1 {"It is one."}
        2 {"It is two."}
        3 {"It is three."}
        4 {"It is four."}
    }

    It is three.
#>