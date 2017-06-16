<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   File creat: 2017 / 06/ 14
   File update: 2017 / 06 / 16
   Create by: Dmitry V Babich
   e-mail: dmitry@gladsir.ru
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
Clear-Host

function Get-DiskSnap
{
    [CmdletBinding( 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.gladspir.ru/powershell/help')]
    
    #[Alias()]
    #[OutputType([String])]
    Param
    (
        # Volume Name
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,                     
                   Position=0
                   )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("C:\", "D:\", "E:\", "H:\")]
        [Alias("Volume")] 
        [String]$disk,

        # String Search
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1
                   )]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [ValidateSet('.BMP', '.GIF', '.PNG', '.JPG', '.MP3', '.WMA', '.WAV')]
        #[Alias("search")]       
        [String[]]$filterFiles,

        # Flag to Usee Filet
        [Parameter(Mandatory=$false)]
        [switch]$filterStart,

        # Flag to print root directory
        [Parameter(Mandatory=$false)]
        [switch]$printRoot,

        # Flag to generate html report
        [Parameter(Mandatory=$false)]
        [switch]$htmlStart

    

    )

    Write-Verbose " Set param complite "

    Write-Verbose " Get Snap "

    $diskSreen = Get-ChildItem -Path $disk -ErrorAction Ignore -Recurse

    [int32]$folderCount = $null
    [int32]$fileCount = $null
    [int32]$totalCount = ($diskSreen | Select-Object -Property Directory).count

    [System.IO.FileInfo[]]$dictFile = $null
    [System.IO.DirectoryInfo[]]$dictFolder = $null

    Write-Verbose " Start sorting "

    # разбор файлов и каталогов
    $diskSreen | ForEach-Object {
    
        if ( ($_.GetType()).Name -like 'FileInfo' )
        {
            $fileCount++
            #($_).GetType().FullName
            $dictFile += $_  
        }
        elseif ( ($_.GetType()).Name -like 'DirectoryInfo' )
        {
            $folderCount++
            #($_).GetType().FullName
            $dictFolder += $_  
        
        }

        }

    Write-Verbose " Print count "
    # вывод подсчета файлов и каталогов 
    Write-Host "`nИтак немного итогов" -BackgroundColor Red -ForegroundColor White 
    Write-Host "Directory:`t $folderCount"
    Write-Host "Files:`t $fileCount"


    if ( ( $folderCount + $fileCount ) -eq $totalCount )
        {

        Write-Host "Total:`t $totalCount"

        }
    Else
        {
    
        Write-Host "Error total" -BackgroundColor Red

        }
    
    Write-Verbose " Print Root "
    # печать корня
    if ( $printRoot -eq $true ) {

        # вывод каталогов в корне
        Write-Host "`nПоискав немного удалось найти следующие каталоги в корне" -ForegroundColor DarkYellow
        ($dictFolder | Select-Object -Property BaseName,@{ n="RootName"; e={$_.Parent.Name} } | Where-Object { $_.RootName -eq $disk }).BaseName
        # вывод файлов в корне
        Write-Host "`nА так же там были еще и эти файлы" -ForegroundColor Green
        ($dictFile | Select-Object -Property BaseName,@{ n="RootName"; e={$_.DirectoryName} },Name | Where-Object { $_.RootName -eq $disk }).Name

    } 
   
   Write-Verbose " Use Filter "
    # поиск по фильтру
    if ( $filterStart -eq $true) {

        Write-Host "`n"
        ForEach ($filterFile in $filterFiles) {  
        
            $extC = ($dictFile | Where-Object Extension -EQ $filterFile).count
            Write-Host "Extension type $filterFile is: $extC"

            }
    
    
        }
    
    Write-Verbose " generate html report "
    # создание отчета в html
    if ( $htmlStart -eq $true ) {
        
        Write-Host -ForegroundColor Cyan "`nИди настраивай Web сервер, создавай CSS и шаблон. `nА я пока курну, и так транзисторы скрипят "
        
        }


}