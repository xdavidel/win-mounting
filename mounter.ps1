$drives=Get-Partition | Where-Object -FilterScript { (-Not $_.DriveLetter) -and ($_.Type -notcontains "Unknown") } | Select-Object -Property PartitionNumber,Size,Type | Sort-Object -Property Size -Descending
$drvstr= echo $drives | Foreach {"$($_.PartitionNumber) $($_.Size) $($_.Type)"}
$Title = "Select Partition"
$Info = "Please choose a partition to mount"
$options = [System.Management.Automation.Host.ChoiceDescription[]] @($drvstr)
[int]$defaultchoice = 0
$opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
$selected=$drvstr[$opt] | ConvertFrom-String -PropertyNames PartitionNumber, Size, Type

if ($selected -Eq $null) {exit} 

$Title = "Select Drive Letter"
$Info = "Please choose drive letter to mount the partition into"
$points=echo "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" | 
    Where-Object -FilterScript { ( $_ -NotIn ((Get-PSDrive).Name -match '^[a-z]$')) }

$options = [System.Management.Automation.Host.ChoiceDescription[]] @($points)
[int]$defaultchoice = 0
$opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
$mnt = $points[$opt]

if ($mnt -Eq $null) {exit} 

Get-Partition | Where-Object -FilterScript { (-Not $_.DriveLetter) -and ($_.PartitionNumber -Eq $selected.PartitionNumber) -and ($_.Size -Eq $selected.Size) -and ($_.Type -notcontains "Unknown") } | Set-Partition -NewDriveLetter $mnt