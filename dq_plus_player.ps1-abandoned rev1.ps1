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
function grind([int]$loop = 5){
    for($i=0;$i -lt $loop; $i++){
        Get-Date
        pace
        slay
        Get-Date
    }
}