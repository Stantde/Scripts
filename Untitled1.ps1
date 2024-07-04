$a = gci .\folder1 -recurse
$b = gci .\folder2 -recurse
$c = Compare-Object -ReferenceObject $a -DifferenceObject $b
#$c
$d1 = $c | Where-Object SideIndicator -eq "<="
$d2 = $c | Where-Object SideIndicator -eq "=>"
$e1 = $d1.inputobject.fullname
$e1
