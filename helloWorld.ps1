#The goal of this script is to ask for the user's name and say hello.;
Write-Output "Hello world!";
$name = Read-Host "What's your name?";
Write-Output 'Hi, "$name"! Your name is "$name.length.ToString()" +characters long!';