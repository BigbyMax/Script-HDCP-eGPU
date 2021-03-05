Register-WmiEvent -Class win32_devicechangeevent -SourceIdentifier deviceChange
write-host (get-date -format s) " Beginning script..."
do{
$newEvent = Wait-Event -SourceIdentifier deviceChange
$eventType = $newEvent.SourceEventArgs.NewEvent.EventType
$eventTypeName = switch($eventType)
{
1 {"Configuration changed"}
2 {"Device arrival"}
3 {"Device removal"}
4 {"docking"}
}
write-host (get-date -format s) " Event detected = " $eventTypeName
if ($eventType -eq 2)
{
# Quand un appareil est branché, on regarde si les deux cartes sont branchées
    if ( Get-PnpDevice -InstanceId '<GPU_Intel>', '<eGPU>')
    {
    if (Get-PnpDevice -InstanceId '<eGPU>' -Status OK)
    {
        write-host (get-date -format s) " Désactivons Intel"

        Disable-PnpDevice -InstanceId '<GPU_Intel>' -Confirm:$false
    }
    }

}
if ($eventType -eq 3)
{
    
# Quand un appareil est débranché, on regarde si c'est la Nvidia qui est débranchée
    if ( Get-PnpDevice -InstanceId '<eGPU>' -Status Ok)
    {
    if ( Get-PnpDevice -InstanceId '<GPU_Intel>' -Status ERROR)
    {
    write-host (get-date -format s) " On fait rien"
        
    }
    }
    else{
    write-host (get-date -format s) " Réactivons Intel"

    Enable-PnpDevice -InstanceId '<GPU_Intel>' -Confirm:$false

    }

}
Remove-Event -SourceIdentifier deviceChange
} while (1-eq1) #Loop until next event
Unregister-Event -SourceIdentifier deviceChange