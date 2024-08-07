# Helpdesk Conversation Analysis
Phone call and email transcripts saved to Database, and AI analysis for Key Phrase, Sentiment and 
Vector Semantic Search capability.

## Pre-requisites
Oracle 23ai Database (Autonomous) with Oracle APEX Workspace configured
Oracle Object Store
Permissions to run Oracle AI Services
API Key or Resource Principal for DB to access Object Store 


## Voice to Text
[OCI Language Service : Speech Service](https://docs.oracle.com/en/solutions/ai-speech/#GUID-E42B9FB3-3DB6-4FD1-B80D-4E4E5BB8B24A)

Recorded Phone Calls > Voice to Text > Transcript Saved to DB

Store Audio files in OCI Object Store (could be accessible S3 compatible bucket)

Create Job > 
Give a Name if required
Select Input Bucket and Output Bucket 
Model Type, Oracle. Select English AU 
Enable Diarisation.. possibly only 2 speakers, or leave as “Auto Detect”
Click Next
Choose Files to be Transcribed
Submit

Either copy output files (*.json) into another bucket, or remember Output Bucket Name

Run PLSQL Script to :
Identify All *.json transcriptions in Selected Bucket
Write Transcriptions to Database
