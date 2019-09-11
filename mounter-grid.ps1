# Grid with unmouted known partitions
$chosen=Get-Partition | Where-Object -FilterScript { (-Not $_.DriveLetter) -and ($_.Type -notcontains "Unknown") } | Select-Object -Property PartitionNumber,Size,Type | Sort-Object -Property Size -Descending | Out-GridView -OutputMode "Single"

# Safeguard
if ($chosen -Eq $null) {exit}

# Shoose available mounting drive letter
$mnt=echo "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" | 
    Where-Object -FilterScript { ( $_ -NotIn ((Get-PSDrive).Name -match '^[a-z]$')) } | Out-GridView -OutputMode "Single"

# Safeguard
if ($mnt -Eq $null) {exit}

# mount the selected partition to the selected drive letter
Get-Partition | Where-Object -FilterScript { (-Not $_.DriveLetter) -and ($_.PartitionNumber -Eq $chosen.PartitionNumber) -and ($_.Size -Eq $selected.Size) -and ($_.Type -notcontains "Unknown") } | Set-Partition -NewDriveLetter $mnt