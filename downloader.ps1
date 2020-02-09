$masterURI = "http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team.%uriplaceholder%.html"
$URIS = 5..29
$maxpiccount = 50
$maxsinglepiccount = 4;


$URIS | ForEach-Object {
    $URI = $masterURI -replace '%uriplaceholder%',$_
    $HTML = Invoke-WebRequest -Uri $URI
    $piccount = 1
    $singlepiccount = 1
    $currenturi = $_
    (
        $HTML.ParsedHtml.getElementsByTagName('a') |
        Where-Object {
            $_.href -match "^about:/download/" -or
            $_.href -match "^http://icons.iconarchive.com"
        }
    ) | ForEach-Object {
       
        Write-Host "Currently on page $currenturi/$($URIS.Count) and icon $piccount/$($maxpiccount): $(([string]($_.href) -split '/').Get(([string]($_.href) -split '/').Count -1))"
        
        Invoke-WebRequest `
        -Uri ([string]($_.href) -replace "about:","http://www.iconarchive.com") `
        -OutFile (([string]($_.href) -split '/').Get(([string]($_.href) -split '/').Count -1))

        $singlepiccount = $singlepiccount + 1;

        if(($singlepiccount-1) -eq $maxsinglepiccount) {
            $singlepiccount = 1
            $piccount = $piccount + 1
        }
    }
}
