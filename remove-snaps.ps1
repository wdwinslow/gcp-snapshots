# Set the path and file name for PowerShell transcripts (logs) to be written to.
$LogPath = "c:\logs\powershell\snaps\"
$LogFile = Get-Date -Format FileDateTimeUniversal
$TranscriptFileName = $LogPath + $LogFile +".txt"

# Start the transcript.
Start-Transcript -Path $TranscriptFileName

#Set the project.
$Project = "put-your-gcp-project-here-12345"

#Record the date / time that the snapshot cleanup started.
$StartTime = Get-Date

#Choose what snaps to remove.  Essentially, the script takes the current date / time subtracts 30 days and sets a variable ($deletable).  Is delatable even a word? Anyway... Any snaps older than that variable get removed.  Obviously, you could tweak this number of days to fit your needs.
$deleteable = (Get-Date).AddDays(-30)

#Log what date and time we set $deleteable to.
Write-Host "Deleting snapshots older than:" $deleteable

#Delete the actual snaps.
$snapshots = Get-GceSnapshot
    foreach ($snapshot in $snapshots) {
        $snapshotdate = get-date $snapshot.CreationTimestamp
        if ($snapshotdate -lt $deleteable) {
            Write-Host Removing snapshot: $snapshot.Name
            Remove-GceSnapshot $snapshot.Name
            }
}

#Record the date / time that the snapshot cleanup ended.
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
$smtpPort = "2525" #Don't put 25 here - it will not work.  See link above.

$att = new-object Net.Mail.Attachment($TranscriptFileName)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer, $smtpPort)

# Set the email from / to / subject / body / etc here:
$msg.From = "gcpsnapshots@yourdomainname.com"
$msg.To.Add("you@yourdomainname.com")
$msg.Subject = "GCP Snapshot Cleanup Report"
$msg.Body = "Please see the attached PowerShell transcript."

# Attach the log and ship it.
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()