<#
The purpose of this script is to remove all old FOPs that have been saved in the dowloads folder.

This is accomplished by identifying the Names of FOPs in the download folder, as well as their date downloaded.

Next, duplicate files are identified.

Finally, oldest duplicates are removed.

#>
<#
-Copied from thoughts
#Identify root elements of a file name.
#root 1 Extension.
#Root two name.
#root 3 copy number.
#Compile list of files with roots 1 and 2 in common.
#Determine most recent file within list and flag the others for removal.
    #This creates a fourth element FLAGGED.
        #What about the revision number?
        #Hash table:@{<Filename,datecreated?> = @(Array of roots)}
#Create a list of files to be removed. Must be appendable.
#Test period
#>
<#
This should do the job if the files are in subfolders and all have the same name. just fill in your path and extension and try it.

nothing will be removed untill you delete the -Whatiff behind remove-item

##You can filter for your extension and get the creation time

$files = gci "yourpath" -recurse | where {$_.Extension -eq ".yourextension"} | select name, creationtime

##FOREACH thru the files checking for doubles

foreach($file in $files){

$checkfilefordoubles = gci "yourpath" -recurse | where {$_.name -eq "$($file.name)"}

##IF you find doubles you fill a variable($filecount) with the count subtract## 1, sort the $checkfilefordoubles variable by creationtime## and select all the objects besides the newest which is after the sort by## creationtime the first

if($checkfilefordoubles.count -gt "1" ){

$filecount = $checkfilefordoubles.count -1

$checkfilefordoubles | sort CreationTime -Descending | select -Last $filecount | remove-item -WhatIf }##end of IF

}##end of FOREACH
#>
function Get-Names{
    $a = Get-ChildItem -Path "C:\Users\P114320a\Downloads\" -attributes !Directory; #"
    Return $a;
}
function Generate-Hashtable ($Files){
    Foreach($file in $Files){
        $NamesAndTimes += @{($File | Select-Object -Property Name |Sort -Descending)=$File.CreationTime};
    }
    return $NamesAndTimes;
}
function Slice-Hashtables ($Hash){
#    Foreach($slice in $hash.keys){
#        $N += @($hash.keys);    
#    }
    $N = $Hash.keys | Out-String -Stream #first filename is $pie[3] last is $pie.length-3
    Return $N
}
function Find-FileExtension ($Filename){
#This function absolutely requires a string input.!
#    (Does string exist?) check against lib
#    if (not in lib)
#    $Str1 = "$Filename";
    $ext += @($Filename.substring($Filename.indexOf('.'),$filename.length-$Filename.indexOf('.')));
    #add to lib
    return $ext
}
function Resolve-FileName ($hashkey){
    #This will generate a new hashtable to store the original name as a key and the resolved string as a value
    $hashkey = $hashkey |Sort-Object -Descending | ?{$_.contains("(")}
    for ($i=0;$i -lt $hashkey.length; $i++){
        switch($hashkey[$i]){
            {$_.contains("FLAGGED") }{Continue}#Checks root 4
            {!$_.contains("FLAGGED")}{
                $resval += @(Find-Root2 ($hashkey[$i]));#find root 2
                $rehash += @(Find-FileExtension ($hashkey[$i]));#find root1?
                $previousval += @($resval[$i] + $rehash[$i]);
                if($i -gt 0){
                    if($previousval[$i] -eq $previousval[($i-1)]){
                        $copyNum = $hashkey[$i].substring($hashkey[$i].indexOf("("),$hashkey[$i].indexOf(")")+1-$hashkey[$i].indexOf("("))
                        $newList += @($resval[$i]+" " + $copyNum + $rehash[$i])
                    }
                }
            }
        }
    }
    #$newList  | Out-File -FilePath C:\Users\P114320A\Documents\windowspowershell\newlist.txt
    #$previousval | Out-File -FilePath C:\Users\P114320A\Documents\windowspowershell\previousval.txt
    #$resval | Out-File -FilePath C:\Users\P114320A\Documents\windowspowershell\resval.txt
    #$rehash | Out-File -FilePath C:\Users\P114320A\Documents\windowspowershell\rehash.txt
    #$hashkey  | Out-File -FilePath C:\Users\P114320A\Documents\windowspowershell\hashkey.txt
    return $newList
}
function Find-Root2 ($beforeparen){
    #find index of (. use everything up to that in the new string.
    $NextString = $beforeparen.substring(0,($beforeparen.IndexOf("(")-1));
    return $NextString
}
#Find most recent file using $Rname and $filesindownloadfolder.
function Find-MostRecentFile($FilesAndTimes,$Files){

Return $rf
}
$FilesinDownloadfolder = Generate-Hashtable (Get-Names)#Master hash of all files in download and the creation time
$pie = Slice-Hashtables ($FilesinDownloadfolder)#Names of all files in download
#Resolve Files in Download Folder 
$Rname = Resolve-FileName ($pie)#Names of duplicates in download
#Find most recent file using $Rname and $filesindownloadfolder.
$RecentFiles = Find-MostRecentFile($FilesinDownloadfolder,$Rname);
#remove recentfiles from rname or create new rname without recentfiles.
#remove items in modified rname(new).