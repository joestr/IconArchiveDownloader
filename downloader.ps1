$mainUri = "http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team.%page%.html"
$pageRange = 5..29
$iconsPerPage = 50
$filesPerIcon = 4

$pageRange | ForEach-Object {

    $currentPage = $_

    # Replace %current_page% with the current page.
    $currentUri = $mainUri -replace '%page%',$currentPage

    # Get the HTML of the page.
    $currentPage = Invoke-WebRequest -Uri $currentUri

    # Set counters
    $iconCounter = 1
    $fileCounter = 1
    
    $links = (
        $currentPage.ParsedHtml.getElementsByTagName('a') |
        Where-Object {
            $_.href -match "^about:/download/" -or
            $_.href -match "^http://icons.iconarchive.com"
        }
    )
    
    $links | ForEach-Object {

        # Set the download uri
        $downloadUri = ([string]($_.href) -replace "about:","http://www.iconarchive.com")
        
        # Split the uri in parts  
        $splittedUri = [string]($_.href) -split '/'
        
        # Get the file name from the splitted uri
        $fileName = $splittedUri.Get($splittedUri.Count - 1)

        # Status output
        Write-Host "Currently on page $currentPage/$($pageRange.Count) and icon $iconCounter/$($iconsPerPage): $(([string]($_.href) -split '/').Get(([string]($_.href) -split '/').Count -1))"
        
        # Download file
        Invoke-WebRequest -Uri $downloadUri `-OutFile $fileName

        # Increment the file counter.
        $fileCounter = $fileCounter + 1;

        if(($fileCounter - 1) -eq $filesPerIcon) {
            # Reset the file counter.
            $fileCounter = 1
            # Increment the icon counter.
            $iconCounter = $iconCounter + 1
        }
    }
}
