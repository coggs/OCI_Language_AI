# OCI_Language_AI
Perform AI Language Analysis over Voice to text Transcriptions

- Autonomous Database 23ai [Oracle Always Free Tier](https://www.oracle.com/au/cloud/free/) + APEX Workspace
- OCI Object Store Bucket
- API Key or OCI Resource Principal
- Permissions to use OCI AI Language Services

## Oracle Free Tier Sign-up
[How to Sign up for Oracle Free Tier](https://www.youtube.com/watch?v=YnsN52hB8EY)

## Install Oracle DB23ai Autonomous Database
[Create Always Free Autonomous Database 23ai](https://www.youtube.com/watch?v=-d-DxUJ3DvI) 

## Object Store Set up and Authentication
[Create Object Store Bucket and Authentication for Autonomous Database](https://www.youtube.com/watch?v=IPkjI6zd2CU)

## Create APEX Workspace
OCI Quick Start - Deploy a low-code app on Autonomous Database using APEX
> https://cloud.oracle.com/resourcemanager/quickstarts?solution-name=apex&region=*home-region*

(Note - ensure logged in to your Cloud Tenancy and that the home region is selected)

## Next Steps
- Run OCI Language Speech to Text service pointing to Object Store Location of audio files (Output is a series of .json transcription files)
- Run Script to open each JSON file and write details into Database (written as JSON to preserve output)
- Run "Transcription" through Key Phrase API => Store to DB
- Run "Transcription" through Sentiment API => Store to DB
- Convert "Key Phrase" JSON Object to ListAGG (Comma separated list of Key Phrases)
- Convert "Key Phrase" Comma Separated list into a Vector
- Transcription, key phrase and sentiment reporting available in APEX Applicaiton
