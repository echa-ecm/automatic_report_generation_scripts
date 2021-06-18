# Manual for installing and using the IUCLID Report Generator Git Bash Script

## Background
To further support IUCLID report builders, a Git Bash script is now available to generate reports quicker and more efficiently. Below is a guide on how to set up and use the script.

The IUCLID user interface provides a Report Manager to upload your own custom FTL report template and a Report Generator to generate a custom report from a single dataset or dossier. 
For IUCLID users who build FTL report templates, the user interface has two limitations:

1 Every time a change is made to an FTL template, a user has to re-upload the FTL template using the Report Manager

2 After upload, report generation cannot be started from across multiple datasets or dossiers.

The new GIT Bash script connects to the IUCLID API and allows users to quickly run an updated report without re-uploading the report into the IUCLID Report Manager, and supports starting report generation
from multiple datasets and dossiers.


## Requirements
To use and run the report generator Git Bash script, you will need:

- IUCLID 6 installed from version 6.3.1.1 onwards (both Desktop and Server versions can be used)
- [Git Bash](https://gitforwindows.org/) installed on your local machine
- A working FTL report template uploaded into the IUCLID report manager

## Download and Setup
Download the Git Bash script from here (*ADD LINK TO ZIP FILE*)

The zip file contains two scripts:

- refresh-and-generate.sh
- default.env

**Next steps:**

1 Create a folder on your local machine. Any name can be given to this main folder, e.g. 'IUCLID_report_generator_script_IUCLID_v6.5'

2 Move the two downloaded scripts to this main folder

3 Download two additional git files and place them in the same main folder (*ADD LINK TO ZIP FILE*)

4 Create three new sub-folders in your main folder:
- bin
- outputFile
- temp


5 The sub-folder 'temp' replicates the folder struture expected by the IUCLID API.
To do this, download this zip package (*ADD ZIP PACK*) named 'temp.zip' and extract the files into your 'temp' sub-folder.
*Notice that all Working Contexts are supplied in the file 'workingContexts', which is useful when customising the following parameter&nbsp;&nbsp;```export RF_SUBMISSION_TYPES ``` in your .env file*

## Customisation of .env file for generation

The scripts have been designed so that only the 'default.env' script needs to be tailored by a user for report generation.

To do this, **follow these steps:**

1 Replace '<...>' with your own IUCLID Username and Password:

&nbsp;&nbsp;```
export RF_USERNAME=<SuperUser>
export RF_PASSWORD=<root> 
           ```

2 Replace '<...>' with your server host name, which can be found in your IUCLID web user interface browser URL:

&nbsp;&nbsp;```
export RF_SERVER=<http://localhost:8080>
           ```

3 Replace '<...>' with the report identifier from the report which has been uploaded into the Report Manager. Find the report identifier by going into the uploaded report in the report manager, 
and looking at the last number in the browser URL, e.g.:

![Text](/doc/img/2021-06-18_10-49-05.png)

&nbsp;&nbsp;```
export RF_REPORT_ID=<1>
           ```

4 Add the UUIDs in '< ... >' of the dossiers you wish to generate the report from, and/or from the raw datasets you wish to generate the report from. 
Currently, you can generate from four different dataset entities:

- Substances / Mixtures / Categories / Articles

&nbsp;&nbsp;```
export RF_DOSSIERS=(<88798a20-8822-4b13-ab0c-2f716b0e3bd5>)
           ```
           
5 Remove the '#' for the entity or entities, the report generation is applicable for. Keep the hash for which the report generation is not applicable for.
Below, report generation is applicable for 'substances' only:

&nbsp;&nbsp;```
export RF_APPLICABLE_ENTITIES=(
    SUBSTANCE
    # MIXTURE
    # ARTICLE
    # CATEGORY
)
           ```

6 Replace '< ... >' with the path to where your FTL report templates are stored (remember that a linux based path should be used)

&nbsp;&nbsp;```
export RF_TEMPLATE_PATH=<"/c/Temporary Files/amoreno/workspace/Information Platform Services Tools/pcn/pcn-web-dossier">
           ```

7 Replace '< ... >' with the path to where your stylesheet is stored. A stylesheet has an '.xsl' file extension and can be found from the IUCLID Reports webpage

&nbsp;&nbsp;```
export RF_STYLES_PATH=<"/c/Temporary Files/amoreno/workspace/Information Platform Services Tools/pcn/stylesheet">
           ```

8 Replace '< ... >' with the name of your main FTL report template

&nbsp;&nbsp;```
export RF_MAIN_FTL=<00_pcn_web_report_main>
           ```

9 Replace '< ... >' with the names of your other FTLs. These are separated by a space.

&nbsp;&nbsp;```
export RF_FTLS=(macros_common_general.ftl pcn_web_head.ftl pcn_web_utilities.ftl)
           ```

10 Replace '< ... >' with the path to your 'outputFile' folder and your 'temp' subfolder:

&nbsp;&nbsp;```
export RF_TEMP_PATH=<"/c/Temporary Files/temp">
export RF_OUTPUT_PATH=<"/c/Temporary Files/outputFile">
           ```

11 Add the relevant Working contexts' (aka submission types) which are applicable for your report generation by removing the '#' from the Working Context identifier:

&nbsp;&nbsp;```
export RF_SUBMISSION_TYPES=( BIOC_ACTIVE_SUBSTANCE_FOR_MIXTURES
    # EU_PPP_MICRO_ACTIVE_SUBSTANCE
    # NZ_HSNO_FULL_ASSESS_MIX
)
           ```
## Run and generate the report

When you have set up your .env file, you can now generate a report using the Git Bash command line.

To do this, **follow these steps:**

1 Open 'GIT Bash here' from your main folder

2 Add to the command line:
- path to the 'refresh-and-generate.sh' script
- the name of the .env file
- '--diff' to run a difference report to the previous generation

&nbsp;``` <path to 'refresh-and-generate.sh' script> <name of .env file> --diff ```

Here is an example of the command line when opening the Git Bash command line from the main folder where the .sh script is stored:

&nbsp;```./refresh-and-generate.sh script chemicalSafetyReport.env file --diff ```

3 The report(s) will be generated and added to the folder 'outputFile' *Note that if you get a error 500 error, this points to an issue with the report FTL template and not the set up of the Git Bash script*.


