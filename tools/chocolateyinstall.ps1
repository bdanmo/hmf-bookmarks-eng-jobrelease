#define tools dir
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

try {
    

    #create $env:ProgramData\Temp if it doesn't exist
    Write-Output "Checking for C:\ProgramData\ChocoTemp"
    if (!(Test-Path -Path "C:\ProgramData\ChocoTemp")) {
        Write-Output "Creating C:\ProgramData\ChocoTemp"
        New-Item -Path "C:\ProgramData\ChocoTemp" -ItemType Directory
    }

    Write-Output "ChocoTemp folder exists, downloading bookmarks file"

    #move the sales+eng_bookmarks(.json) file in the tools dir to the temp folder, with the name "Bookmarks"
    Write-Output "Moving bookmarks file to C:\ProgramData\ChocoTemp"
    Move-Item -Path "$toolsDir\jobrelease_bookmarks" -Destination "C:\ProgramData\ChocoTemp\Bookmarks"


    # check if the bookmarks file exists in the temp folder, and if it does, write success message, if it does not, throw error to catch block
    if (Test-Path -Path "C:\ProgramData\ChocoTemp\Bookmarks") {
        Write-Output "Bookmarks file downloaded successfully"
    }
    else {
        Write-Output "Error copying the bookmarks files to C:\ProgramData\ChocoTemp"
        Throw
    }

    #finally, as a fail-safe, move the bookmarks.html from the tools directory to the public desktop for manual loading by the user if needed
    Write-Output "Moving bookmarks html file to public desktop"
    Move-Item -Path "$toolsDir\jobrelease_bookmarks.html" -Destination "C:\Users\Public\Desktop\Bookmarks.html"
} 
catch {
    Write-Output "Error downloading bookmarks file from Azure Blob Storage"
    Write-Output $_.Exception.Message
}

