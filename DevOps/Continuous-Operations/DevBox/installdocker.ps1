Install-Module -Name PowerShellGet -Force -AllowClobber -SkipPublisherCheck
Install-Module -Name cChoco -Force -AllowClobber -SkipPublisherCheck

Configuration InstallDockerDesktop {
    Import-DscResource -ModuleName cChoco

    Node 'localhost' {
        cChocoInstaller DockerDesktop {
            Name = 'docker-desktop'
            Ensure = 'Present'
            Force = $true
            PackageParameters = '--quiet'
        }
    }
}

InstallDockerDesktop

# Set the execution policy to allow running DSC configurations
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Compile the DSC configuration
.\InstallDockerDesktop.ps1

# Apply the DSC configuration
Start-DscConfiguration -Path .\InstallDockerDesktop -Wait -Verbose
