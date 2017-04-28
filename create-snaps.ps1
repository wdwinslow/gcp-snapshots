# Set the path and file name for PowerShell transcripts (logs) to be written to.
$LogPath = "c:\logs\powershell\snaps\"
$LogFile = Get-Date -Format FileDateTimeUniversal
$TranscriptFileName = $LogPath + $LogFile +".txt"

# Start the transcript.
Start-Transcript -Path $TranscriptFileName

#Set the GCP project.
$Project = "put-your-gcp-project-here-12345"

#Set the zone(s) where the disks are that you would like to take snapshots of.
$Zones = "us-east1-d", "us-central1-c"

#Record the date that the snapshots started.
$StartTime = Get-Date

#Go snapshot all of the disks in the zones identified above.
foreach ($Zone in $Zones) {
$DisksInZone = Get-GceDisk -Project $Project -zone $Zone | foreach { $_.Name }

    foreach ($Disk in $DisksInZone) {
        Write-Host "=========================================="
        Write-Host "$Zone "-" $Disk"
        Write-Host "=========================================="
        Add-GceSnapshot -project $Project -zone $Zone $Disk #In the future we could clean this output up a bit.
        }
}

#Record the date that the snapshots ended.
$EndTime = Get-Date

#Print out the start and end times.
Write-Host "=========================================="
Write-Host "Started at:" $StartTime
Write-Host "Ended at:" $EndTime
Write-Host "=========================================="

#Stope the transcript.
Stop-Transcript

#Send the PowerShell transcript (log) by email.  You can delete this entire section if you don't want log copies delivered by email.
#Google Cloud Platform blocks direct outbound mail on port 25.  Reference: https://cloud.google.com/compute/docs/tutorials/sending-mail/

#Mail Server Settings
$smtpServer = "mail.yourdomainname.com"
$smtpPort = "2525" #Don't put 25 here it will not work.  See link above.

$att = new-object Net.Mail.Attachment($TranscriptFileName)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer, $smtpPort)

# Set the email from / to / subject / body / etc here:
$msg.From = "gcpsnapshots@yourdomainname.com"
$msg.To.Add("you@yourdomainname.com")
$msg.Subject = "GCP Snapshot Report"
$msg.Body = "Please see the attached PowerShell transcript."

# Attach the log and ship it.
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()