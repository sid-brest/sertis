# Define the input and output file paths for part 1
$addr_file = "addr.txt"
$winroute_file = "winroute.cfg"
$output_file = "missingaddr.txt"

# Remove spaces and empty lines from addr.txt
(Get-Content -Path $addr_file | Where-Object { $_ -notmatch '^\s*$' } | ForEach-Object { $_ -replace ' ' }) | Set-Content -Path $addr_file

# Remove missingaddr.txt if it already exists
if (Test-Path $output_file) {
    Remove-Item -Path $output_file
}

# Read addr.txt line by line and check if it exists in winroute.cfg
$lines = Get-Content -Path $addr_file
foreach ($line in $lines) {
    $match = Select-String -Path $winroute_file -Pattern $line -Quiet
    if (-not $match) {
        Add-Content -Path $output_file -Value $line
    }
}


# Define the input and output file paths for part 2
$infile = "missingaddr.txt"
$outfile = "missingaddrwihtmask.txt"

# Read the input file
$lines = Get-Content $infile

# Define the conversion method
function ConvertToDecimalMask($network_mask) {
    if ($network_mask -as [int]) {
        try {
            [ipaddress]$network_mask_int = 0
            $mask = ([Math]::Pow(2, $network_mask) - 1) * [Math]::Pow(2, (32 - $network_mask))
            $bytes = [BitConverter]::GetBytes([UInt32] $mask)
            $network_mask_int = (($bytes.Count - 1)..0 | ForEach-Object { [String] $bytes[$_] }) -join "."
            $network_mask = $network_mask_int.IPAddressToString
        }
        catch {
            return $null
        }
    }
    else {
        return $null
    }

    return $network_mask
}

# Process each line in the input file
$outputLines = foreach ($line in $lines) {
    $ip, $cidr = $line -split '/'
    if ($cidr -as [int] -and $cidr -ge 0 -and $cidr -le 32) {
        $decimalMask = ConvertToDecimalMask $cidr

        if ($decimalMask) {
            "{0} {1}" -f $ip, $decimalMask
        } else {
            Write-Warning "Invalid CIDR mask: $cidr"
        }
    }
}

# Write the output to the file, excluding lines with IPv6 addresses
$outputLines | Where-Object { $_ -notmatch "::" } | Out-File $outfile