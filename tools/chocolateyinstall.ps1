#define tools dir
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$bookmarksObjectUrl = https://sennecadeployments.blob.core.windows.net/bookmarks/jobrelease_bookmarks
$bookmarksHtmlUrl = https://sennecadeployments.blob.core.windows.net/bookmarks/jobrelease_bookmarks.html

try {
    

    #create $env:ProgramData\Temp if it doesn't exist
    Write-Output "Checking for C:\ProgramData\ChocoTemp"
    if (!(Test-Path -Path "C:\ProgramData\ChocoTemp")) {
        Write-Output "Creating C:\ProgramData\ChocoTemp"
        New-Item -Path "C:\ProgramData\ChocoTemp" -ItemType Directory
    }

    Write-Output "ChocoTemp folder exists, downloading bookmarks file"

    #get the bookmarks file from the Azure Blob Storage and put it in c:\ProgramData\ChocoTemp as "Bookmarks"
    Write-Output "Pulling bookmarks file to C:\ProgramData\ChocoTemp"
    Invoke-WebRequest -Uri $bookmarksObjectUrl -OutFile "C:\ProgramData\ChocoTemp\Bookmarks"


    # check if the bookmarks file exists in the temp folder, and if it does, write success message, if it does not, throw error to catch block
    if (Test-Path -Path "C:\ProgramData\ChocoTemp\Bookmarks") {
        Write-Output "Bookmarks file downloaded successfully"
    }
    else {
        Write-Output "Error copying the bookmarks files to C:\ProgramData\ChocoTemp"
        Throw
    }

    #finally, as a fail-safe, pull the bookmarks.html from the Azure Blob Storage and put it on the public desktop
    Write-Output "Pulling bookmarks html file to public desktop"
    Invoke-WebRequest -Uri $bookmarksHtmlUrl -OutFile "$env:Public\Desktop\Bookmarks.html"
} 
catch {
    Write-Output "Error downloading bookmarks file from Azure Blob Storage"
    Write-Output $_.Exception.Message
}

