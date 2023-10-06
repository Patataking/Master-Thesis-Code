﻿Set-Location "C:/_Thesis/Data/"

# Take number from command line for folder naming
$Nr=$args[0]
# Set port number by using modulo on input number
$NrP=$Nr%10

# Create target folders
$Path = "1_0_1j/5000000-"+$Nr
$FullPath="C:/_Thesis/Data/$Path"
$Cont="container_"+$Nr
New-Item -Path .\$Path -ItemType Directory

# Copy scripts to container
Copy-Item "C:\_Thesis\client.sh" -Destination $Path
Copy-Item "C:\_Thesis\server.sh" -Destination $Path

# Run the container
Start-Process powershell  -WindowStyle Hidden "docker run -v ${FullPath}:/src -it --name $Cont -p 4433${NrP}:4433${NrP} openssl"
Start-Sleep -Seconds 15
# Start the server
Start-Process powershell  -WindowStyle Hidden "docker exec -it $Cont bash src/server.sh"
Start-Sleep -Seconds 15
# Start packet capture and open connections
Start-Process powershell -WindowStyle Hidden "docker exec -it $Cont bash src/client.sh"