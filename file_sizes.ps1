Function Get-Folder($initialDirectory) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()
    return $FolderBrowserDialog.SelectedPath
}
$folderd = Get-Folder C:\
$dataColl = @()
Get-ChildItem -force $folderd -ErrorAction SilentlyContinue | Where-Object { $_ -is [io.directoryinfo] } | ForEach-Object {
    $len = 0
    Get-ChildItem -recurse -force $_.fullname -ErrorAction SilentlyContinue | ForEach-Object { $len += $_.length }
    $foldername = $_.fullname
    $foldersize = '{0:N2}' -f ($len / 1Gb)
    $dataObject = New-Object PSObject
    Add-Member -inputObject $dataObject -memberType NoteProperty -name "Folder name" -value $foldername
    Add-Member -inputObject $dataObject -memberType NoteProperty -name "Folder size in Gb" -value $foldersize
    $dataColl += $dataObject
}
$dataColl | Out-GridView -Title "Size of subdirectories"
