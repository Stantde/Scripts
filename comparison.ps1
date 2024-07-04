$filespec = 'c:\folderpath\*.pdf'

# get the files

$files = Get-ChildItem $filespec -File

# Split into groups according to the base filename
# regex replace removes any version number eg ' (22)' from the end
# of the filename part and uses this to group files 

$groups = $files |
   Group-Object -property { $_.basename -replace ' \(\d*\)$',''  }

# now delete the files in each group that don't match the group name,
# ie files with a number

ForEach ( $g in $groups ) {
  "=== $($g.Name) ==="   # section heading
  $h=$g.group | Sort-Object -Property CreationDate | Select-Object -SkipLast 2
  ForEach ( $f in $h ) {
    if ( $f.basename -eq $g.Name ) {
      "Retain : $($f.FullName)"
    } else {
      "DELETE : $($f.fullname)"
      # uncomment actual delete operation below WHEN CODE IS TESTED!
      # Remove-Item -Path $f.FullName
    }
  } 
}
<#
howdy pausemsauce,

how do you determine the "newest"?

if it is just the file timestamp, that is easy. [grin]
if it is the one with the highest (##), that is doable.

for instance, you can sort by the file timestamp newest first, then group by the .BaseName with the (##) stripped off, skip groups with a .Count of 1, skip the first 1, and delete the remainder.

this ...

Group-Object {($_.BaseName -replace '\(\d+\)$', '').Trim()}
... will give you groups of all the files. you can send each group with a .Count -gt 1 thru Select-Object -Skip 1 to leave the newest alone & then use Remove-Item on the remaining files.

i can write the full script, but you seem to want more of a "how to" hint, so i will leave it at that. [grin]

take care,
lee
#>     