# Manual for installing and using the IUCLID Report Generator Script

## Background
To further support IUCLID report builders, a Git Bash script is now available to generate reports quicker and more efficiently.

The IUCLID user interface provides a Report Manager to upload your own custom FTL report template and a Report Generator to generate a report from a single dataset or dossier. 
For IUCLID users who build FTL report templates, the user interface has two limitatoins:

-- Every time a change is made to an FTL template, a user has to re-upload the FTL template using the Report Manager
-- After upload, report generation cannot be started from across multiple datasets or dossiers.

The new GIT Bash script connects to the IUCLID API to allow users to quickly run an updated report without uploading the report into the IUCLID Report Manager, and supports starting report generation
from multiple datasets and dossiers.


## Requirements
To use and run the report generator Git Bash script, you will need:

- IUCLID 6 installed from version 6.3.1.1 onwards (both Desktop and Server versions can be used)
- [Git Bash](https://gitforwindows.org/) installed on your local machine
- A working report FTL template uploaded into the IUCLID report manager

## Download and Setup
Download the Git Bash script from here (*ADD LINK TO ZIP FILE*)

The zip file contains to scripts:

- refresh-and-generate.sh
- default.env

Next steps:

1 Create a folder on your local machine. Any name can be given to this main folder, e.g. 'IUCLID_report_generator_script_IUCLID_v6.5'
2 Move the two downloaded scripts to this main folder
3 Download these git attribute files and place them in the same main folder
3 Create three new sub-folders in your main folder:
- bin
- outputFile
- temp
4 The sub-folder 'temp' repliactes the folder struture expected by the IUCLID API. to do this, download this zip package (*ADD ZIP PACK*) named 'temp.zip' and extract the files to your 'temp' sub-folder.
*Notice that all Working Contexts are supplied in the file 'workingContexts', which is useful when customising your .env file*

## Customisation .env file for generation

The scripts have been desgiend so that only the 'default.env' script needs to be tailored by a user for report generation.

To do this, follow these steps:

1 Replace '<...>' with your own IUCLID Username and Password:

&nbsp;&nbsp;```
export RF_USERNAME=<SuperUser>
export RF_PASSWORD=<root> 
           ```

2 Replace '<...>' with your server host name

&nbsp;&nbsp;```
export RF_SERVER=<http://localhost:8080>
           ```
3 Replace the report identifier with the report which has been uploaded into the Report Manager. Find the report identifier by going into the uploaded report in the report manager, 
and looking at the last number in the browser URL, e.g.:

![Text](URL)

&nbsp;&nbsp;```
export RF_REPORT_ID=<1>
           ```
