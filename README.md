# Powershell-Sadserver
Bring a little @sadserver to your Windows Servers!

MUST USE POWERSHELL V5.

You will need to generate a Twitter API Key for your Twitter account for this powershell script to work.

1. Go to https://apps.twitter.com/ and generate a Consumer Key and Consumer Secret
2. Run .\sadserver.ps1 -GenerateToken -consumerKey YOURCONSUMERKEY -consumerSecret YOURCONSUMERSECRET
3. Save the resulting output text. This is your API Access Token.
4. Run .\sadserver.ps1 -AccessToken YOURACCESSTOKENFROMSTEP2 -Getfeed sadserver -numTweets 1

Must run script with Administrative privileges. It updates your system logon banner.

use the -retrieveOnly option on Step 4 to only output the latest tweet.

haven't tested using numTweets greater than 1. Just an option I figured I'd put in there since it's a twitter feed option.

Feel free to use Step 4 in a Scheduled Task daily to update with daily @sadserver tweets!
