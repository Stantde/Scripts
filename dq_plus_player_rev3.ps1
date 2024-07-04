# Open DQ plus

$TITLE = "Dragon Quest Plus"
function open_dq_plus([string]$location = ""){
    # If no value is passed, the following evaluates to false.
    if ($location){
        if (Test-Path -Path $location){
            ii $location
            return
        }
    }
    
    ii "G:\DQPluslocked\Dragon Quest Remix Gold\RPG_RT.exe";
}#OK
function skip_title(){
    #sleep -s 5 #not enough
    echo "Starting sleep"
    sleep -s 20
    echo "done"
    press_key "ZZZ" 
    return
}
function update_dq_save_file(){
    <# Compare the local save file with the common drive save file by datetime saved. Whichever is most recent: 
        Copy the old file to a temporary location.
        Move the new file to the old file location.
        Remove the temporary loctaion.
        Verify each step along the way.
            In the event of an error, abort operations and report the error.
                Consider wrapping each step.
    #>
    $usb_save = "G:\DQPluslocked\Dragon Quest Remix Gold\save01"
    $usb_save_time = (ls "$usb_save*").LastWriteTime
    $cloud_save = "M:\114320 Quality Assur\Quality\Common folder\DQPlus\save"
    $cloud_save_time = (ls "$cloud_save*").LastAccessTime
    $tmp_save = "C:\Users\A3T2YZZ\tmp_save"
    mkdir tmp_save
    if (! (Test-Path -Path C:\Users\A3T2YZZ\tmp_save)){
        echo "Failed to create tmp_save at $tmp_save" 
        return 
    }
    ri $tmp_save
    return
}
function open_adventure_log([int]$log_number=0){
    $log_number = $log_number%3;
    skip_title    
    # Scroll down once to continue adventure
    sleep 5
    press_key "D" 
    press_key "Z"
    press_key "D" $log_number
    press_key "Z" 3
    return
}
function start_new_player (){
    $player = New-Object -ComObject wscript.shell;
    open_dq_plus
    sleep 5
    $player.AppActivate($TITLE)
    return $player
}#uneccessary
function press_key([string]$keystrokes, [int]$number = 0, $wshell=$player){
    if ($keystrokes -eq "D"){
        $keystrokes = "{DOWN}"
    }  
    $wshell = New-Object -ComObject wscript.shell;  
    $wshell.AppActivate($TITLE)
    Sleep 2
    Add-Type -AssemblyName System.Windows.Forms
    if ($number){
        $number = ($number + 1) * 3
    }
    else {
        $number = $number * 3
    }
    for($i = 0; $i -lt ($number); $i++){

        [System.Windows.Forms.SendKeys]::SendWait($keystrokes);
    }
    return
} # TO DO
function main(){
    open_dq_plus;
    open_adventure_log
}

#$player = start_new_player
#main


# Wait a bit then Left click at point 938,516 to set DQ active window.
function pace (){    
    echo "Pacing"
    for($i=0;$i -lt 5; $i++) {    
        press_key "{LEFT}" 30
        sleep 1
        press_key "{RIGHT}" 30
    }
}
function slay([string]$indef="") {    
    echo "Slaying"
    if(!$indef) {
        for($i=0;$i -lt 10; $i++){
        press_key "Z" 30
        }
    }
    else {
        while($true){
        press_key "Z" 30
        }
    }
}
function grind([int]$loop = 5, [string]$cloud=""){
    for($i=0;$i -lt $loop; $i++){
        if ($loop -ne 5){
            echo "i = $i out of $loop"
        }
        Get-Date
        pace
        #grab_screen "remonster"
        slay
        Get-Date
    }
}
<#
#function grab_screen ([string]$remote=""){#Not OK for 3M applications, due to triggering suspicious activity response
    #take a screen shot and save it to a screenshot folder.
       #size limits?
    $save_location = "$HOME\dq_screenshots"
    if(! $remote){
        $save_location = "M:\114320 Quality Assur\Quality\Common folder\dq_screenshots"
    }
    # If folder doesn't exist, create it
    if( !(Test-Path -Path $save_location)){
        mkdir $save_location
    }
    $c = 0
    while (Test-Path "${save_location}\${c}.png") {
        $c++
        }
    [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")
    sleep 1
    mspaint
    sleep 1
    #ctrl+v
    [Windows.Forms.Sendkeys]::SendWait("^v")
    sleep 1
    #alt, f, s
    [Windows.Forms.Sendkeys]::SendWait("%fs")
    sleep 1
    #filepath
    [Windows.Forms.Sendkeys]::SendWait("${save_location}\${c}.png")
    sleep 1
    [Windows.Forms.Sendkeys]::SendWait("~")
    sleep 5
    
    kill -name mspaint
    return
}


    <#
    Add-Type -AssemblyName System.Drawing
    $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
        Where-Object { $_.FormatDescription -eq "JPEG" }
    do{
        [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")# safe
        $bitmap = $null
    }
    while (([System.Windows.Forms.Clipboard]::ContainsImage()))
    #$bitmap = Get-Clipboard
    $ep = New-Object Drawing.Imaging.EncoderParameters # not safe flag
    $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)# not safe flag
    $c = 0
    while (Test-Path "${save_location}${c}.jpg") {
        $c++
        }
    (gcb).Save("${save_location}\${c}.jpg", $jpegCodec, $ep)

return
}

<#
alternative methods:
get-clipboard -format image
 $img = get-clipboard -format image
 $img.save("c:\temp\temp.jpg")
#>