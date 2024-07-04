# Open DQ plus
$TITLE = "Dragon Quest Plus"
function open_dq_plus([string]$location = ""){
    echo "start open dq plus"
    # If no value is passed, the following evaluates to false.
    if ($location){
        if (Test-Path -Path $location){
            ii $location
            return
        }
    }
    
    ii "G:\DQPluslocked\Dragon Quest Remix Gold\RPG_RT.exe";
    echo "end open dq plus"
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
    echo "start main"    
    open_dq_plus;
    skip_intro;
    load_adventure_log
    echo "end main"
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
    echo "start skip intro"
    sleep 15
    [Microsoft.VisualBasic.Interaction]::AppActivate($TITLE)
    sleep 1
    [System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
    echo "end skip intro"
    return
}
function dbg_skip_intro(){
    echo "start skip intro"
    sleep 15
    [Microsoft.VisualBasic.Interaction]::AppActivate($TITLE)
    sleep 5
    [System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
    echo "end skip intro"
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
    echo "start load adventure log"
    [System.Windows.Forms.SendKeys]::SendWait(“{DOWN}”)
    sleep 1
    [System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
    sleep 1   
    [System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
    sleep 1
    [System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
    sleep 1
    [System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
    sleep 1
    echo "end load adventure log"
    return
}
function dbg_load_adventure_log([int]$log_number = 0){
    echo "start load adventure log"
    Get-Date
    [Microsoft.VisualBasic.Interaction]::AppActivate($TITLE)
    sleep 5
    [System.Windows.Forms.SendKeys]::SendWait(“{DOWN}”)
    sleep 2
    [System.Windows.Forms.SendKeys]::SendWait(“Z”)
    sleep 2   
    [System.Windows.Forms.SendKeys]::SendWait(“Z”)
    sleep 2
    [System.Windows.Forms.SendKeys]::SendWait(“Z”)
    sleep 2
    [System.Windows.Forms.SendKeys]::SendWait(“Z”)
    sleep 2
    Get-Date
    echo "end load adventure log"
    return
}
<#

[Microsoft.VisualBasic.Interaction]::AppActivate($TITLE)
sleep 5
[System.Windows.Forms.SendKeys]::SendWait(“{Z}”)
#>
function Keypress(){
Param (
    [Parameter(position=0, mandatory=$true, parametersetname='key')]
    [char]$Key,
    [Parameter(position=0, mandatory=$true, parametersetname='scancode')]
    [int]$ScanCode
)
}
$code = @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public static class KBEmulator {	
    public enum InputType : uint {
	    INPUT_MOUSE = 0,
	    INPUT_KEYBOARD = 1,
	    INPUT_HARDWARE = 3
    }

    [Flags]
    internal enum KEYEVENTF : uint
    {
	    KEYDOWN = 0x0,
        EXTENDEDKEY = 0x0001,
        KEYUP = 0x0002,
        SCANCODE = 0x0008,
        UNICODE = 0x0004
    }

    [Flags]
    internal enum MOUSEEVENTF : uint
    {
        ABSOLUTE = 0x8000,
        HWHEEL = 0x01000,
        MOVE = 0x0001,
        MOVE_NOCOALESCE = 0x2000,
        LEFTDOWN = 0x0002,
        LEFTUP = 0x0004,
        RIGHTDOWN = 0x0008,
        RIGHTUP = 0x0010,
        MIDDLEDOWN = 0x0020,
        MIDDLEUP = 0x0040,
        VIRTUALDESK = 0x4000,
        WHEEL = 0x0800,
        XDOWN = 0x0080,
        XUP = 0x0100
    }

    // Master Input structure
    [StructLayout(LayoutKind.Sequential)]
    public struct lpInput {
	    internal InputType type;
	    internal InputUnion Data;
	    internal static int Size { get { return Marshal.SizeOf(typeof(lpInput)); } }			
    }

    // Union structure
    [StructLayout(LayoutKind.Explicit)]
    internal struct InputUnion {
	    [FieldOffset(0)]
	    internal MOUSEINPUT mi;
	    [FieldOffset(0)]
	    internal KEYBDINPUT ki;
	    [FieldOffset(0)]
	    internal HARDWAREINPUT hi;
    }

    // Input Types
    [StructLayout(LayoutKind.Sequential)]
    internal struct MOUSEINPUT
    {
        internal int dx;
        internal int dy;
        internal int mouseData;
        internal MOUSEEVENTF dwFlags;
        internal uint time;
        internal UIntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct KEYBDINPUT
    {
        internal short wVk;
        internal short wScan;
        internal KEYEVENTF dwFlags;
        internal int time;
        internal UIntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct HARDWAREINPUT
    {
        internal int uMsg;
        internal short wParamL;
        internal short wParamH;
    }

    private class unmanaged {
	    [DllImport("user32.dll", SetLastError = true)]
	    internal static extern uint SendInput (
		    uint cInputs, 
		    [MarshalAs(UnmanagedType.LPArray)]
		    lpInput[] inputs,
		    int cbSize
	    );
	
	    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
	    public static extern short VkKeyScan(char ch);
    }

    internal static short VkKeyScan(char ch) {
	    return unmanaged.VkKeyScan(ch);
    }

    internal static uint SendInput(uint cInputs, lpInput[] inputs, int cbSize) {
	    return unmanaged.SendInput(cInputs, inputs, cbSize);
    }

    public static void SendScanCode(short scanCode) {
        lpInput[] KeyInputs = new lpInput[1];
	    lpInput KeyInput = new lpInput();
	    // Generic Keyboard Event
	    KeyInput.type = InputType.INPUT_KEYBOARD;
	    KeyInput.Data.ki.wScan = 0;
	    KeyInput.Data.ki.time = 1;
	    KeyInput.Data.ki.dwExtraInfo = UIntPtr.Zero;
	
	
	    // Push the correct key
	    KeyInput.Data.ki.wVk = scanCode;
	    KeyInput.Data.ki.dwFlags = KEYEVENTF.KEYDOWN;
	    KeyInputs[0] = KeyInput;
	    SendInput(1, KeyInputs, lpInput.Size);
	
	    // Release the key
	    KeyInput.Data.ki.dwFlags = KEYEVENTF.KEYUP;
	    KeyInputs[0] = KeyInput;
	    SendInput(1, KeyInputs, lpInput.Size);
	
	    return;
    }

    public static void SendKeyboard(char ch) {
	    lpInput[] KeyInputs = new lpInput[1];
	    lpInput KeyInput = new lpInput();
	    // Generic Keyboard Event
	    KeyInput.type = InputType.INPUT_KEYBOARD;
	    KeyInput.Data.ki.wScan = 0;
	    KeyInput.Data.ki.time = 0;
	    KeyInput.Data.ki.dwExtraInfo = UIntPtr.Zero;
	
	
	    // Push the correct key
	    KeyInput.Data.ki.wVk = VkKeyScan(ch);
	    KeyInput.Data.ki.dwFlags = KEYEVENTF.KEYDOWN;
	    KeyInputs[0] = KeyInput;
	    SendInput(1, KeyInputs, lpInput.Size);
	
	    // Release the key
	    KeyInput.Data.ki.dwFlags = KEYEVENTF.KEYUP;
	    KeyInputs[0] = KeyInput;
	    SendInput(1, KeyInputs, lpInput.Size);
	
	    return;
    }
}
"@
<#
if(([System.AppDomain]::CurrentDomain.GetAssemblies() | ?{$_ -match "KBEmulator"}) -eq $null) {
    Add-Type -TypeDefinition $code
}
#>
switch($PSCmdlet.ParameterSetName){
    'key' { [KBEmulator]::SendKeyboard($Key) }
    'scancode' { [KBEmulator]::SendScanCode($ScanCode) }
}