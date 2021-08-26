# Manual for installing and using the IUCLID Report Generator Bash script

## Background
To further support IUCLID report builders, a Bash script is now available to generate reports quicker and more efficiently. Below is a guide on how to set up and use the script.

The IUCLID user interface provides a Report Manager to upload your own custom FTL report template and a Report Generator to generate a custom report from a single dataset or dossier.
For IUCLID users who build FTL report templates, the user interface has two limitations:

1. Every time a change is made to an FTL template, a user has to re-upload the FTL template using the Report Manager

2. After upload, report generation cannot be started from across multiple datasets or dossiers.

The new Bash script connects to the [IUCLID API](https://iuclid6.echa.europa.eu/public-api)and allows users to quickly run an updated report without re-uploading the report into the IUCLID Report Manager, and supports starting report generation
from multiple datasets and dossiers.


## Requirements
To use and run the report generator  Bash script, you will need:

- IUCLID 6 installed from version v5.15.0 onwards (both Desktop and Server versions can be used)
- If using Windows you will need a [Git Bash](https://gitforwindows.org/) terminal installed on your local machine
- If using Linux or Mac you need to install the GNU Zip and GIT utilities into your system and use the provided Terminal application
- A working FTL report template uploaded into the IUCLID report manager

## Setup of the script

Open your terminal from the folder you want the tool to be installed, e.g., C:\Users\<username>\Documents\workspace. In Windows you can right-click on top of the folder and select Git Bash Here.

![Git Bash Here](/doc/img/Git-bash-here.png)

In the terminal type
```
git clone https://github.com/Mark-R-R/automatic_report_generation_scripts.git
```

![Screenshot of Terminal with clone command](/doc/img/git-clone.png)

The tool is composed of two main files:
* The main script file refresh-and-generate.sh
* A sample configuration file sample.env

## Customisation of .env file for generation

The scripts have been designed so that you can create configurations for several report creation processes just by creating copies of the sample.env configuratoin file. Once you have created a copied of the sample.env file (e.g., pcn_html_report.env) you can tailor your copy to you needs.

To do this, **follow these steps:**

1. Replace '<...>' with your own IUCLID Username and Password:

```
export RF_USERNAME=<SuperUser>
export RF_PASSWORD=<root>
```

2. Replace '<...>' with your server host name, which can be found in your IUCLID web user interface browser URL:

```
export RF_SERVER=<http://localhost:8080>
```

3. Replace '<...>' with the report identifier from the report which has been uploaded into the Report Manager. Find the report identifier by going into the uploaded report in the report manager,
and looking at the last number in the browser URL, e.g.:

![Report ID from IUCLID URL](/doc/img/2021-06-18_10-49-05.png)

```
export RF_REPORT_ID=<1>
```

4. Add the UUIDs in '< ... >' of the dossiers you wish to generate the report from, and/or from the raw datasets you wish to generate the report from.
Currently, you can generate from four different dataset entities:

- Substances / Mixtures / Categories / Articles

```
export RF_DOSSIERS=(<88798a20-8822-4b13-ab0c-2f716b0e3bd5>)
```

5. Remove the '#' for the entity or entities, the report generation is applicable for. Keep the hash for which the report generation is not applicable for.
Below, report generation is applicable for 'substances' only:

```
export RF_APPLICABLE_ENTITIES=(
                        SUBSTANCE
                        # MIXTURE
                        # ARTICLE
                        # CATEGORY
        )
```

6. Replace '< ... >' with the path to where your FTL report templates are stored (remember that a linux based path should be used)

```
export RF_TEMPLATE_PATH=<"/c/Users/report_user/Documents/workspace/pcn-web-dossier">
```

7. Replace '< ... >' with the path to where your stylesheet is stored. A stylesheet has an '.xsl' file extension and can be found from the IUCLID Reports webpage

```
export RF_STYLES_PATH=<"/c/Users/report_user/Documents/workspace/stylesheet">
```

8. Replace '< ... >' with the name of your main FTL report template. Do not include the extension (.ftl)

```
export RF_MAIN_FTL=<00_pcn_web_report_main>
```

9. Replace '< ... >' with the names of your other FTLs. These are separated by a space and enclosed by paranthesis '()'.

```
export RF_FTLS=<(macros_common_general.ftl pcn_web_head.ftl pcn_web_utilities.ftl)>
```

10. Add the relevant Working contexts' (aka submission types) which are applicable for your report generation by removing the '#' from the Working Context identifier:

```
export RF_SUBMISSION_TYPES=(
        BIOC_ACTIVE_SUBSTANCE_FOR_MIXTURES
        # EU_PPP_MICRO_ACTIVE_SUBSTANCE
        # NZ_HSNO_FULL_ASSESS_MIX
)
```
## Run and generate the report

When you have set up your own configuration file, you can now generate a report using the bash terminal.

To do this, **follow these steps:**

1. Open 'GIT Bash here' from the folder where you installed the tool, e.g.,  `C:\Users\<username>\Documents\workspace\automatic_report_generation_scripts`.

![Screenshot of File Explorer with Git Bash Here](/doc/img/run-script.png)


2. Add to the command line:
- `./refresh-and-generate.sh`
- the name of the `.env` file, e.g., `pcn_html_report.env`
- (optional) `--diff` to run a difference report to the previous generation

```
./refresh-and-generate.sh <name of .env file> --diff
```

Here is an example of the command line when opening the  Bash command line from the main folder where the .sh script is stored:

```
./refresh-and-generate.sh pcn_html_report.env --diff
```

3. The report(s) will be generated and added to the folder 'generated_reports', e.g.,`C:\Users\<username>\Documents\workspace\automatic_report_generation_scripts\generated_reports`

*Note that if you get a error __500 error__, this points to an issue with the report FTL template files and not the set up of the Git Bash script*. To find out the cause of the error you should inspect the IUCLID logs files (`server.log` and `iuclid6/error_iuclid6.log`) that are found in the installation directory of IUCLID `<installation_path>\glassfish4\glassfish\domains\domain1\logs`, e.g., `C:\iuclid6\glassfish4\glassfish\domains\domain1\logs`.



## Run and generate reports for several .env files

A different script let's you run all refresh-and-generate script with all the .env files in a directory

```
./multiple-refresh-genearation.sh <path to .envs folder>
```

The script accepts the following parameters:
1. `<path to .envs folder>` It can be set to any path, e.g., '`./envs/`' for a subfolder in this repo called 'envs'. Wrap the path around `"` if the path contains spaces.