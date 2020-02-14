$mainUri = "http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team.%page%.html"
$pageRange = 5..29
$iconsPerPage = 50
$filesPerIcon = 4;

$pageRange | ForEach-Object {

    $currentPage = $_

    # Replace %current_page% with the current page.
    $currentUri = $mainUri -replace '%page%',$currentPage

    # Get the HTML of the page.
    $currentPage = Invoke-WebRequest -Uri $currentUri

    $iconCounter = 1
    $fileCounter = 1
    
    $links = (
        $HTML.ParsedHtml.getElementsByTagName('a') |
        Where-Object {
            $_.href -match "^about:/download/" -or
            $_.href -match "^http://icons.iconarchive.com"
        }
    )
    
    $links | ForEach-Object {

        $downloadUri = ([string]($_.href) -replace "about:","http://www.iconarchive.com")
        $fileName = (([string]($_.href) -split '/').Get(([string]($_.href) -split '/').Count -1))

        Write-Host "Currently on page $currentPage/$($pageRange.Count) and icon $iconCounter/$($iconsPerPage): $(([string]($_.href) -split '/').Get(([string]($_.href) -split '/').Count -1))"
        
        Invoke-WebRequest -Uri $downloadUri `-OutFile $fileName

        # Icrement the file counter.
        $fileCounter = $fileCounter + 1;

        if(($fileCounter - 1) -eq $filesPerIcon) {
            # Reset the file counter.
            $fileCounter = 1
            # Increment the icon counter.
            $iconCounter = $iconCounter + 1
        }
    }
}
