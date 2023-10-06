Set-Location "C:/_Thesis/Data/"
$Nr=$args[0] # Take number from command line for folder naming

#port=modulo to folder nr for using deferent ports for each cont instance
$NrP=$Nr%10

#crate target folder for pcap files
$Path = "3_1_1/5000000-"+$Nr
$FullPath="C:/_Thesis/Data/$Path"
$Cont="openssl3_"+$Nr
New-Item -Path .\$Path -ItemType Directory

#copy default scripts for each container
#cont sripts starts openssl server and many client connections 
#by using special parameters
#client script create tcp dump=pcap files

Copy-Item "C:\_Thesis\client3.sh" -Destination $Path
Copy-Item "C:\_Thesis\server3.sh" -Destination $Path

#each next command starts as separate process cont 
#and from to cont mapped folder client & server sripts


Start-Process powershell  -WindowStyle Hidden "docker run -v ${FullPath}:/src -it --name $Cont -p 4433${NrP}:4433${NrP} openssl3"

Start-Sleep -Seconds 15

Start-Process powershell  -WindowStyle Hidden "docker exec -it $Cont bash src/server3.sh"

Start-Sleep -Seconds 15

Start-Process powershell -WindowStyle Hidden "docker exec -it $Cont bash src/client3.sh"
