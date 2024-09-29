# Define server names
$servers = @("Server1", "Server2", "Server3")  # Add all server names here

# Function to install Hyper-V on each server
function Install-HyperV {
    foreach ($server in $servers) {
        Invoke-Command -ComputerName $server -ScriptBlock {
            Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
        }
    }
}

# Function to configure networking
function Configure-Networking {
    New-VMSwitch -Name "ExternalSwitch" -NetAdapterName "Ethernet" -AllowManagementOS $true
}

# Function to create virtual machines
function Create-VMs {
    $vmName = "MyVM"
    $vmMemory = 2GB
    $vmDiskPath = "C:\VMs\$vmName\$vmName.vhdx"

    New-VM -Name $vmName -MemoryStartupBytes $vmMemory -BootDevice VHD -NewVHDPath $vmDiskPath -NewVHDSizeBytes 20GB -SwitchName "ExternalSwitch"
    Start-VM -VM $vmName
}

# Function to set up shared storage
function Setup-SharedStorage {
    New-Item -Path "C:\SharedVMs" -ItemType Directory
    New-SmbShare -Name "SharedVMs" -Path "C:\SharedVMs" -FullAccess Everyone
}

# Function to automate resource management
function Manage-Resources {
    $vms = Get-VM
    foreach ($vm in $vms) {
        if ($vm.State -eq 'Off') {
            Start-VM -VM $vm.Name  # Start VM if it's off
        }
    }
}

# Function to implement load balancing (NLB)
function Setup-NLB {
    Install-WindowsFeature NLB
    New-NlbCluster -HostName "NLBCluster" -ClusterIP "192.168.1.100"
}

# Function to monitor performance
function Monitor-Performance {
    Get-VM | ForEach-Object {
        $cpuUsage = Get-Counter "\Hyper-V Hypervisor Logical Processor(_Total)\% Guest Run Time"
        Write-Output "$($_.Name) CPU Usage: $cpuUsage"
    }
}

# Function for backup strategy
function Setup-Backup {
    $backupJob = New-WBJob -Policy (Get-WBPolicy)
    Add-WBFileSpec -BackupJob $backupJob -FileSpec "C:\SharedVMs"
    Start-WBBackup -BackupJob $backupJob 
}

# I) Compute Services (Virtual Machines, PaaS, Container Services, Serverless Functions)
function Setup-ComputeServices {
    # Placeholder for PaaS, Container Services, Serverless Functions setup.
    Write-Output "Setting up Compute Services..."
}

# II) Storage Solutions (Object Storage, File Storage, Archival Storage)
function Setup-StorageSolutions {
    # Placeholder for Object Storage and Archival Storage setup.
    Write-Output "Setting up Storage Solutions..."
}

# III) Networking Services (VPC, Load Balancing, DNS Services)
function Setup-NetworkingServices {
    # Placeholder for DNS and other networking services setup.
    Write-Output "Setting up Networking Services..."
}

# IV) AI and Machine Learning (Machine Learning Tools)
function Setup-AIandML {
    # Placeholder for AI and ML tools setup.
    Write-Output "Setting up AI and Machine Learning tools..."
}

# V) Security and Compliance (Security Hub, Compliance Offerings)
function Setup-SecurityAndCompliance {
    # Placeholder for security and compliance setup.
    Write-Output "Setting up Security and Compliance..."
}

# VI) Backup and Disaster Recovery
function Setup-BackupAndRecovery {
    Setup-Backup
}

# Execute all functions in order
Install-HyperV
Configure-Networking
Create-VMs
Setup-SharedStorage
Manage-Resources
Setup-NLB
Monitor-Performance

Setup-ComputeServices
Setup-StorageSolutions
Setup-NetworkingServices
Setup-AIandML
Setup-SecurityAndCompliance
Setup-BackupAndRecovery

Write-Output "Cloud infrastructure setup completed successfully."
