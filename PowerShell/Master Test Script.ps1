#Master Test script

$ServerInstance = "XXXXXX.database.windows.net"
$Database = "benchmarkbigdata"
$Username = "XXXXXX"
$Password = "XXXXXX"
$Folder = "C:\Queries"
$DWU = "2000"

$RunType = "external" #CCI or external

$Runs = 3
C:/Queries/PowerShell/ADW-performancetest.ps1 -ServerInstance $ServerInstance -Database $Database -Username $Username -Password $Password -RunType $RunType -Folder $Folder -DWU $DWU -Runs $Runs

$RunType = "CCI" #CCI or external
$Runs = 9
C:/Queries/PowerShell/ADW-performancetest.ps1 -ServerInstance $ServerInstance -Database $Database -Username $Username -Password $Password -RunType $RunType -Folder $Folder -DWU $DWU -Runs $Runs




#$DWU = "1000"
#$ServiceObjective = New-Object Microsoft.WindowsAzure.Commands.SqlDatabase.Services.Server.ServiceObjective
#$ServiceObjective.Name = ("DW" + $DWU)
#Set-AzureSQLDatabase -DatabaseName $Database -ServerName $ServerInstance -ServiceObjective $ServiceObjective