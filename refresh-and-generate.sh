#!/bin/bash

######
# Usage: ./refresh-and-generate.sh env-file
# Tested with IUCLID6 v5.13.0
# env-file points to a copy of default.env with a set of settings
# Tool to refresh a given ($REPORT_ID) template in a $SERVER and to generate reports for a  given list of UUIDs in DOSSIERS, SUBSTANCES, ARTICLES,
# and MIXTURES 
# IUCLID API expects a zip file that matches structure of https://dev.azure.com/echa-ecm/IUCLID/_git/iuclid6-ext?path=%2Fiuclid6-ext-adapter%2Fsrc%2Ftest%2Fresources%2Feu%2Fecha%2Fiuclid6%2Fext%2Fadapter%2Fcontext%2Freport.zip&_a=contents&version=GBmaster
# The linked zip file provides a list of possible $WORKING_CONTEXTS 
# Make a copy of default.env and modify the values
# Runs on git bash https://gitforwindows.org/
# The program assumes all ftls and stylesheets are in the same $TEMPLATE_PATH
# You need to create the folders ftl, mainFtl, styles, and output in $TEMP
# The program expects zip to be in the PATH, ie, copy zip.exe from https://sourceforge.net/projects/gnuwin32/files/zip/3.0/
# to [gitforbashpath(C:\Users\u18339\AppData\Local\Programs\Git\)]\git\mingw64\bin, 
# also a copy of bzip2.dll is in need in the PATH for zip to work


if [ -z "$1" ];
then
    echo "Missing env file"
    echo " Usage: ./refresh-and-generate.sh env-file [--diff --only-generate]"
    echo " eg. ./refresh-and-generate.sh default.env"
    exit 1
else
    set -o allexport
    source $1
    set +o allexport
fi

RF_REFRESH_TEMPLATE=true
RF_RED='\033[0;31m'
RF_NC='\033[0m' # No Color

for arg in "$@"
do
    if [ "$arg" = "--diff" ]; then
    RF_DIFF=true
    fi
    if [ "$arg" = "--only-generate" ]; then
    RF_REFRESH_TEMPLATE=false
    fi

done


if [ "$RF_REPORT_OUTPUT" = "HTML" ];
then    
    RF_REPORT_EXTENSION=html
    RF_ACCEPT_CONTENT="text/html"
elif [ "$RF_REPORT_OUTPUT" = "PDF" ];
then
    RF_REPORT_EXTENSION=pdf
    RF_ACCEPT_CONTENT="application/vnd.iuclid6.ext+pdf;type=database~$RF_REPORT_ID.$RF_STYLES"
elif [ "$RF_REPORT_OUTPUT" = "CSV" ];
then
    RF_REPORT_EXTENSION=csv
    RF_ACCEPT_CONTENT="text/csv"
elif [ "$RF_REPORT_OUTPUT" = "RTF" ];
then
    RF_REPORT_EXTENSION=rtf
    RF_ACCEPT_CONTENT="application/vnd.iuclid6.ext+rtf;type=database~$RF_REPORT_ID.$RF_STYLES"
elif [ "$RF_REPORT_OUTPUT" = "XML" ];
then
    RF_REPORT_EXTENSION=xml
    RF_ACCEPT_CONTENT="text/xml"
else 
    echo "Specify RF_REPORT_OUTPUT to be one of HTML, PDF, CSV, RTF, XML"
fi
JOIN_BY () {
    joined=$(printf "\\r%s" $@)
    echo -n ${joined:1}
}

CREATE_REPORT () {
    RF_REPORT_FILENAME="$RF_TEMP_PATH/$i.$RF_REPORT_EXTENSION"

    echo -e "Generating report for ${RF_RED}$i${RF_NC} and storing it in $RF_REPORT_FILENAME"
    RF_OLD_REPORT=$(cat "$RF_REPORT_FILENAME")
    curl -s --location --request GET ${RF_GENERATE_URL} \
    --header "IUCLID6-USER: ${RF_USERNAME}" \
    --header "IUCLID6-PASS: ${RF_PASSWORD}" \
    --header "Accept: ${RF_ACCEPT_CONTENT}" \
    > "$RF_REPORT_FILENAME"

    RF_DIFF_ARGS="--new-file  --report-identical-files --strip-trailing-cr --ignore-blank-lines --ignore-trailing-space --ignore-space-change --suppress-blank-empty"
    if [ "$RF_DIFF" = true ];
    then
        echo "$RF_OLD_REPORT" | diff - "$RF_REPORT_FILENAME" --side-by-side --suppress-common-lines --width=180 --color $RF_DIFF_ARGS
    else
        echo "$RF_OLD_REPORT" | diff - "$RF_REPORT_FILENAME" --brief $RF_DIFF_ARGS
    fi
    echo -e "\n"
}

REFRESH_TEMPLATE () {
    RF_SUBMISSION_TYPES=$(JOIN_BY $RF_SUBMISSION_TYPES)
    RF_APPLICABLE_ENTITIES=$(JOIN_BY $RF_APPLICABLE_ENTITIES)
    RF_WORKING_CONTEXTS=$RF_SUBMISSION_TYPES$'\r'$RF_APPLICABLE_ENTITIES
    RF_REPORT_ZIP_PATH=$RF_TEMP_PATH/package.zip


    # The zip created with bash created directory breaks IUCLID. Create these directories manually using git bash, and not windows file explorer
    # mkdir temp
    # mkdir temp/ftl 
    # mkdir temp/mainFtl
    # mkdir temp/output
    # mkdir temp/styles
    echo $RF_REPORT_NAME > "$RF_TEMP_PATH/name" 
    echo $RF_REPORT_DESC > "$RF_TEMP_PATH/description"
    echo $RF_WORKING_CONTEXTS > "$RF_TEMP_PATH/workingContexts" 
    echo $RF_REPORT_OUTPUT > "$RF_TEMP_PATH/output/output"
    cp "$RF_TEMPLATE_PATH/$RF_MAIN_FTL.ftl" "$RF_TEMP_PATH/mainFtl"

    for i in "${RF_FTLS[@]}"; 
    do 
        cp "$RF_TEMPLATE_PATH/$i" "$RF_TEMP_PATH/ftl"
    done

    cp "$RF_STYLES_PATH/$RF_STYLES.xsl" "$RF_TEMP_PATH/styles"
    
    rm "$RF_REPORT_ZIP_PATH"
    (cd "$RF_TEMP_PATH" && zip -r -q "package.zip" ./*)

    RF_REFRESH_URL=$RF_SERVER/iuclid6-ext/api/ext/v1/reports?id=$RF_REPORT_ID
    RF_REPORT_URL=$RF_SERVER/iuclid6-web/reports/$RF_REPORT_NAME/$RF_REPORT_ID
    echo -e "Refreshing ${RF_RED}$RF_REPORT_NAME${RF_NC} $RF_REPORT_URL"
    curl -s --location --request POST $RF_REFRESH_URL \
    --header 'Content-Type: application/vnd.iuclid6.report' \
    --header 'Accept: application/json, text/plain, */*' \
    --header "report: ${RF_REPORT_ID}" \
    --header "IUCLID6-USER: ${RF_USERNAME}" \
    --header "IUCLID6-PASS: ${RF_PASSWORD}" \
    --data-binary "@${RF_REPORT_ZIP_PATH}"
    echo -e "\n\n"
}

if [ "$RF_REFRESH_TEMPLATE" = true ];
then
    REFRESH_TEMPLATE
fi

for i in "${RF_DOSSIERS[@]}"; 
do 
    RF_GENERATE_URL=$RF_SERVER/iuclid6-ext/api/ext/v1/dossier/$i?template=database~$RF_REPORT_ID.$RF_MAIN_FTL
    CREATE_REPORT
done

for i in "${RF_MIXTURES[@]}"; 
do 
    RF_GENERATE_URL=$RF_SERVER/iuclid6-ext/api/ext/v1/raw/MIXTURE/$i?template=database~$RF_REPORT_ID.$RF_MAIN_FTL
    CREATE_REPORT
done

for i in "${RF_SUBSTANCES[@]}"; 
do 
    RF_GENERATE_URL=$RF_SERVER/iuclid6-ext/api/ext/v1/raw/SUBSTANCE/$i?template=database~$RF_REPORT_ID.$RF_MAIN_FTL
    CREATE_REPORT
done

for i in "${RF_ARTICLES[@]}"; 
do 
    RF_GENERATE_URL=$RF_SERVER/iuclid6-ext/api/ext/v1/raw/ARTICLE/$i?template=database~$RF_REPORT_ID.$RF_MAIN_FTL
    CREATE_REPORT
done

rm "$RF_TEMP_PATH/styles/"* >&/dev/null
rm "$RF_TEMP_PATH/ftl/"* >&/dev/null
rm "$RF_TEMP_PATH/mainFtl/"* >&/dev/null