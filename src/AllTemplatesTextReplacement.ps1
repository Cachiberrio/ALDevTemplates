Function CreateRenamedFolder{
    echo ("Creando directorio: " + $RenamedFolderPath)
    if (Test-Path $RenamedFolderPath) 
        {
        Remove-Item ($RenamedFolderPath) -Recurse | out-null
        }
    New-Item -Path $RenamedFolderPath -ItemType "directory" | out-null
    for ( $index1 = 0; $index1 -lt $ALFileExtensions.count; $index1++)
        {
        $Ficheros = (Get-Item ($PsScriptRoot + '\' + $TemplateToRename + '\*.' + $ALFileExtensions[$index1]))
        foreach ($Ficheros in $Ficheros)
            {
            $OriginalFileName = $Ficheros.FullName
            $ParentPath = Split-Path $Ficheros.FullName
            $ParentPath = $ParentPath + '\'
            $OriginalFileName = $OriginalFileName.Replace($ParentPath,'')
            $RenamedFileName = $OriginalFileName
            for ( $index2 = 0; $index2 -lt $TextArray.count; $index2++)
                {
                $RenamedFileName = $RenamedFileName.Replace($TextArray[$index2].TextToReplace,$TextArray[$index2].ReplacementText)
                }
            Copy-Item $Ficheros -Destination ($RenamedFolderPath + '\' + $RenamedFileName)
            }        
        }

}
Function ReplaceTextsInALFiles{
    $Ficheros = (Get-Item ($RenamedFolderPath + '\*.*'))
    foreach ($Ficheros in $Ficheros)
        {
        Write-Output $Ficheros.FullName
        for ( $index = 0; $index -lt $TextArray.count; $index++)
            {
                Write-Output ('Sustituyendo ' + $TextArray[$index].TextToReplace + ' -> ' + $TextArray[$index].ReplacementText)
                $text = get-content -path $Ficheros -Encoding default
                $text -replace $TextArray[$index].TextToReplace,$TextArray[$index].ReplacementText |out-file -FilePath $Ficheros.FullName -Encoding default
            }
        Write-Output ('')
        }        
}

Clear-Host
$TemplateToRename = 'DOC'
switch ($TemplateToRename)
    {
    'CNF' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'CNFTableName';        ReplacementText = 'ChickenFarm'}
                [PSCustomObject]@{TextToReplace = 'CNFTableCaptionENU';  ReplacementText = 'Chicken Farm'}
                [PSCustomObject]@{TextToReplace = 'CNFTableCaptionESP';  ReplacementText = 'Granja Pollos'}
                )
          }
    'COD' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'CODTableName';        ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'TableCaptionENU';     ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'CODPageName';         ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'PageCaptionENU';      ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'PageCaptionESP';      ReplacementText = ''}
                )
          } 
    'DIA' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'DIAJournalName';         ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'DIAJournalCode';         ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'DIAJournalCaptionENU';   ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'DIAJournalCaptionESP';   ReplacementText = ''}
                )
          } 
    'DOC' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'DOCTableName';        ReplacementText = 'EXSExpenseSheet'}
                [PSCustomObject]@{TextToReplace = 'DOCTableCaptionENU';  ReplacementText = 'Expense Sheet'}
                [PSCustomObject]@{TextToReplace = 'DOCTableCaptionESP';  ReplacementText = 'Hoja Gastos'}
                )
          } 
    'DOC-Test' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'DOCTableName';        ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'DOCTableCaptionENU';  ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'DOCTableCaptionESP';  ReplacementText = ''}
                )
                } 
    'MAE' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'MAETableName';        ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'MAETableCaptionENU';  ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'MAETableCaptionESP';  ReplacementText = ''}
                )
          } 
    'MCP' {
            $TextArray = @(
                [PSCustomObject]@{TextToReplace = 'MCPTableName';        ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'MCPTableCaptionENU';  ReplacementText = ''}
                [PSCustomObject]@{TextToReplace = 'MCPTableCaptionESP';  ReplacementText = ''}
                )
          } 
    }
$ALFileExtensions = @('al','rdlc','xlf')
$RenamedFolderPath = $PSScriptRoot + '\Renamed'
CreateRenamedFolder
ReplaceTextsInALFiles
