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
} # Works like a charm
function update_dq_save_file(){
    <# Compare the local save file with the common drive save file by datetime saved. Whichever is most recent: 
        Copy the old file to a temporary location.
        Move the new file to the old file location.
        Remove the temporary loctaion.
        Verify each step along the way.
            In the event of an error, abort operations and report the error.
                Consider wrapping each step.
    #>
    return
} # TO DO
function main(){
    open_dq_plus;
    skip_intro;
    load_adventure_log
}
function activate_dq_window(){
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate($TITLE)
    Sleep 1
    # Choose an option

    # Option A
    #$wshell.SendKeys($keystrokes)
    # Option B        
    #Add-Type -AssemblyName System.Windows.Forms
    #[System.Windows.Forms.SendKeys]::SendWait('~');
    # Option B alledgely works better, but both suck. Tremendously.
}
function skip_intro(){
    sleep 15
    press_key z
    sleep 5
    return
}
function press_key ([string]$key){
    activate_dq_window
    python 'C:\Users\A3T2YZZ\OneDrive - 3M\Desktop\Life\40_lessons\Scripts\keyboard_input.py' $key
    <#
        $key = "hi"
        python 'C:\Users\A3T2YZZ\OneDrive - 3M\Desktop\Life\40_lessons\Scripts\keyboard_input.py' $key
        Index: 0 C:\Users\A3T2YZZ\OneDrive - 3M\Desktop\Life\40_lessons\Scripts\keyboard_input.py
        Index: 1 hi
    #>

}
function load_adventure_log([int]$log_number = 0){
    press_key d
    press_key z

    for ($i = 0; $i -lt $log_number; $i++ ){
        press_key d
    }
    for ($i = 0; $i -lt $3; $i++ ){
        press_key z
    }
    return
}
#main