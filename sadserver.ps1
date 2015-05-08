# This twitter feed to Logon notice updater was inspired by the amazing twitter account @sadserver.
# Bring a little @sadserver to your servers.

[CmdletBinding()]
Param(
    [switch]$GenerateToken,
    [string]$consumerKey,
    [string]$consumerSecret,
    [string]$AccessToken,
    [string]$Getfeed,
    [int]$numTweets,
    [bool]$retrieveOnly
)

$requestUserAgent = "PowerShell SadServer Reader 0.1"

Function GenerateToken([string]$tokenConsumerKey,[string]$tokenConsumerSecret) {
    $concatenatedSecret = $tokenConsumerKey + ":" + $tokenConsumerSecret

    # Convert to Base64
    $base64Secret = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($concatenatedSecret))

    # Set our Request Header/Body
    $authrequestURI = "https://api.twitter.com/oauth2/token"
    $authrequestContentType = "application/x-www-form-urlencoded;charset=UTF-8"
    $authrequestMethod = "Post"
    $authrequestHeader = @{"Authorization" = ("Basic " + $base64Secret)}
    $authrequestBody = @{}
    $authrequestBody.grant_type = "client_credentials"

    # The Magic!
    $responseBody = Invoke-RestMethod -uri $authrequestURI -ContentType $authrequestContentType -Headers $authrequestHeader -body $authrequestBody -UserAgent $requestUserAgent -method $authrequestMethod
    return $responseBody.access_token
}

Function GetTweet([string]$accessToken,[string]$tweetAccount,[int]$numTweets) {
    $getrequestUri = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=" + $numTweets + "&screen_name=" + $tweetAccount
    $getRequestHeader = @{"Authorization" = ("Bearer " + $accessToken)}
    $getRequestMethod = "Get"
    $getTweet = Invoke-RestMethod -uri $getrequestUri -UserAgent $requestUserAgent -Method $getRequestMethod -Headers $getRequestHeader
    return $getTweet.text
}

Function UpdateRegistry([string]$legalCaption,[string]$legalText) {
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "LegalNoticeCaption" -value $legalCaption
    Set-ItemProperty -path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "LegalNoticeText" -value $legalText
}

if ($GenerateToken) {
    if ((!$consumerKey) -or (!$consumerSecret)) {
        write-host "Error: Missing -consumerSecret and -consumerKey parameters"
    }
    else {
        GenerateToken $consumerkey $consumerSecret
        }
 }

if ($Getfeed) {
    if (($AccessToken) -and ($numTweets)) {
        if ($retrieveOnly) {
            write-host (GetTweet $AccessToken $Getfeed $numTweets)
        }
        else {
            UpdateRegistry ("@" + $Getfeed) (GetTweet $AccessToken $Getfeed $numTweets)
        }
    }
    else {
        write-host "Error: Missing -AccessToken or -numTweets"
    }
    
}