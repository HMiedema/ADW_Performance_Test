## First time import the sql module
#Import-Module “sqlps” -DisableNameChecking

#Param(
#    [string]$ServerInstance,
#    [string]$Database,
#    [string]$Username,
#    [string]$Password,
#    [string]$RunType,
#    [string]$Folder,
#    [string]$DWU,
#    [string]$Runs,
#    [string]$RunParallel
#)

Get-Date -Format s

$ServerInstance = "XXXXXX.database.windows.net"
$Database = "benchmarkbigdata"
$Username = "XXXXXX"
$Password = "XXXXXX"
$RunType = "CCI" #CCI or external
$Folder = "C:\Queries"
$DWU = "100"
$Runs = 1
$RunParallel ="Y" #Y or N


##Don't touch the code below

$QueryFolder = $Folder + "\Queries"
$MaintenanceFolder = $Folder + "\Maintenance\"

If($RunType.Equals("CCI"))
{
    $Schema = "dbo."
    $RunName = "Run_DWU" + $DWU + "CCI"
}
ELSE
{
    $Schema = "ext."
    $RunName = "Run_DWU" + $DWU + "EXT"
}

$seq_or_par = If($RunParallel.Equals("N")){"Seq"} Else{"Par"}
$RunNameFolder =  $RunName + "_" + (Get-Date -Format s).Replace("-", "").Replace(":","") + "_" + $seq_or_par
$SqlcommandBase = "sqlcmd -S """ + $ServerInstance + """ -d """ + $Database + """ -U """+ $Username + """ -P """ + $Password + """ -I" 

##Create the results table if it doesn't exist
$Sqlcommand = $SqlcommandBase + " -i """ + ($MaintenanceFolder + "Create Results Table.sql") + """"
$Sqlcommand
Invoke-Expression -Command $Sqlcommand

##Drop All External tables
$Sqlcommand = $SqlcommandBase + " -i """ + ($MaintenanceFolder + "Drop All External Tables.sql") + """" 
Invoke-Expression -Command $Sqlcommand

##Create All External tables
$Sqlcommand = $SqlcommandBase + " -i """ + ($MaintenanceFolder + "Create All External Tables.sql") + """" 
Invoke-Expression -Command $Sqlcommand

##Create or empty run directory 
If (Test-Path ($Folder + "\" + $RunNameFolder))
{
    Remove-Item ($Folder + "\" + $RunNameFolder + "\*")
}
Else
{
    New-Item ($Folder + "\" + $RunNameFolder) -type directory
}

c:
##Define Parallel Query script:
workflow Invoke-ParallelQueries
{
    Param(
        [string]$ServerInstance,
        [string]$Database,
        [string]$Username,
        [string]$Password,
        [string]$Name, #$RunNameFolder
        [int]$Run,
        [string[]]$QueryFiles,
        [string]$RunParallel
    )

    c:
     
     $Name
     $Run
    $SqlcommandBase = "sqlcmd -S """ + $ServerInstance + """ -d """ + $Database + """ -U """+ $Username + """ -P """ + $Password + """ -I" 

    switch -casesensitive ($RunParallel) 
    {
        "Y"
        {
            foreach -parallel($QueryFile in $QueryFiles)
            {

                $start_query = @"
                Declare @Action_Time datetime = GetDate();
                Insert into Results (Run, Run_Number, Step, Step_Action, Action_Time) VALUES ('$($Name)', $($Run), '$($QueryFile)', 'Start', @Action_Time)
"@
                $Sqlcommand = $SqlcommandBase + " -i """ + $QueryFile + """"
                $Sqlcommand_start = $SqlcommandBase + " -Q """ + $start_query + """"
                $Sqlcommand_end = $SqlcommandBase + " -Q """ + $end_query + """"

                sequence
                {
                    Invoke-Expression -Command $Sqlcommand_start
                    $Resultset = [string](Invoke-Expression -Command $Sqlcommand)

                    InlineScript #Using inline script otherwise not allowed to do ".EndWith"
                    {

                        $Resultset = $using:Resultset
                        $SqlcommandBase = $using:SqlcommandBase
                        $Name = $using:Name
                        $Run = $using:Run
                        $QueryFile = $using:QueryFile

                        If( $Resultset.EndsWith("rows affected)"))
                        {
                            $Message = $Resultset.substring($Resultset.LastIndexOf("("), $Resultset.Length - $Resultset.LastIndexOf("("))
                            $end_query = @"
                                Declare @Action_Time datetime = GetDate();
                                Insert into Results (Run, Run_Number, Step, Step_Action, Action_Time, Error_flag, Error_Message) VALUES ('$($Name)', $($Run), '$($QueryFile)', 'End', @Action_Time, 'N', '$($Message)')
"@
                            $Sqlcommand_end = $SqlcommandBase + " -Q """ + $end_query + """"
                            $Sqlcommand_end
                            Invoke-Expression -Command $Sqlcommand_end
                        }
                        Else
                        {
                            $end_query = @"
                            Declare @Action_Time datetime = GetDate();
                            Insert into Results (Run, Run_Number, Step, Step_Action, Action_Time, Error_flag, Error_Message) VALUES ('$($Name)', $($Run), '$($QueryFile)', 'End', @Action_Time, 'Y', '$($Resultset.Replace("'", "''"))')
"@
                            $Sqlcommand_end = $SqlcommandBase + " -Q """ + $end_query + """"
                            Invoke-Expression -Command $Sqlcommand_end
                        }
                    }
                }
            }
         } 
         "N"
        {
            foreach ($QueryFile in $QueryFiles)
            {

                $start_query = @"
                Declare @Action_Time datetime = GetDate();
                Insert into Results (Run, Run_Number, Step, Step_Action, Action_Time) VALUES ('$($Name)', $($Run), '$($QueryFile)', 'Start', @Action_Time)
"@
                $Sqlcommand = $SqlcommandBase + " -i """ + $QueryFile + """"
                $Sqlcommand_start = $SqlcommandBase + " -Q """ + $start_query + """"
                $Sqlcommand_end = $SqlcommandBase + " -Q """ + $end_query + """"

                sequence
                {
                    Invoke-Expression -Command $Sqlcommand_start
                    $Resultset = [string](Invoke-Expression -Command $Sqlcommand)

                    InlineScript #Using inline script otherwise not allowed to do ".EndWith"
                    {

                        $Resultset = $using:Resultset
                        $SqlcommandBase = $using:SqlcommandBase
                        $Name = $using:Name
                        $Run = $using:Run
                        $QueryFile = $using:QueryFile

                        If( $Resultset.EndsWith("rows affected)"))
                        {
                            $Message = $Resultset.substring($Resultset.LastIndexOf("("), $Resultset.Length - $Resultset.LastIndexOf("("))
                            $end_query = @"
                                Declare @Action_Time datetime = GetDate();
                                Insert into Results (Run, Run_Number, Step, Step_Action, Action_Time, Error_flag, Error_Message) VALUES ('$($Name)', $($Run), '$($QueryFile)', 'End', @Action_Time, 'N', '$($Message)')
"@
                            $Sqlcommand_end = $SqlcommandBase + " -Q """ + $end_query + """"
                            $Sqlcommand_end
                            Invoke-Expression -Command $Sqlcommand_end
                        }
                        Else
                        {
                            $end_query = @"
                            Declare @Action_Time datetime = GetDate();
                            Insert into Results (Run, Run_Number, Step, Step_Action, Action_Time, Error_flag, Error_Message) VALUES ('$($Name)', $($Run), '$($QueryFile)', 'End', @Action_Time, 'Y', '$($Resultset.Replace("'", "''"))')
"@
                            $Sqlcommand_end = $SqlcommandBase + " -Q """ + $end_query + """"
                            Invoke-Expression -Command $Sqlcommand_end
                        }
                    }
                }
            }
         }
         Default
         {
            #This block should never be reached
         }        

    }
}





 

For ($Run=1; $Run -le $Runs; $Run++) {



    ## When CCI do every 3rd run a total set of new CCI tables e.g 1st, 4th, 7th etc.
    If (($Run % 3).Equals(1) -and $Schema.Equals("dbo."))
    {

        ##Drop All regular tables
        $Sqlcommand = $SqlcommandBase + " -i """ + ($MaintenanceFolder + "Drop All CCI Tables.sql") + """" 

        Invoke-Expression -Command $Sqlcommand



        ##Get all the query files for CCI creation
        $QueryFiles = [String[]](Get-ChildItem ($MaintenanceFolder + "\Create CCI\") -Filter *.sql).FullName
        Invoke-ParallelQueries -ServerInstance $ServerInstance -Database $Database -Username $Username -Password $Password -QueryFiles $QueryFiles -Name $RunNameFolder -Run $Run -RunParallel $RunParallel



    }




    ##Get all the query files for CCI creation
    $QueryFiles = [String[]](Get-ChildItem ($QueryFolder) -Filter *.dsql).FullName
    Invoke-ParallelQueries -ServerInstance $ServerInstance -Database $Database -Username $Username -Password $Password -QueryFiles $QueryFiles -Name $RunNameFolder -Run $Run -RunParallel $RunParallel

}

#$Sqlcommand = "sqlcmd -S """ + $ServerInstance + """ -d """ + $Database + """ -U """+ $Username + """ -P """ + $Password + """ -i """ + ($MaintenanceFolder + "Show Results.sql") + """ -I" 
#Invoke-Expression -Command $Sqlcommand
