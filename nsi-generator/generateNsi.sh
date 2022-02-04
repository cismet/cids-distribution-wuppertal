#!/bin/bash

NSI_FILE="cids-wupp-installer.nsi"

NSI_TEMPLATE=$(<main.template)
VAR_TEMPLATE=$(<var.template)
INSTALL_TEMPLATE=$(<install.template)
SECTION_TEMPLATE=$(<section.template)
SECTIONS_TEMPLATE=$(<sections.template)
DESCRIPTIONS_TEMPLATE=$(<descriptions.template)
DESCRIPTION_TEMPLATE=$(<description.template)
APPS_INFO=$(<apps.info)

SECTIONS__NAVIGATOR_SNIPPET=
SECTIONS__CISMAP_SNIPPET=
SECTIONS__BELIS_SNIPPET=
SECTIONS__LAGIS_SNIPPET=
SECTIONS__VERDIS_SNIPPET=
SECTIONS__TOOLS_SNIPPET=
SECTIONS__NAVIGATOR_INTRA_SNIPPET=
SECTIONS__NAVIGATOR_PUBLIC_SNIPPET=
SECTIONS__CISMAP_INTRA_SNIPPET=
SECTIONS__CISMAP_PUBLIC_SNIPPET=
SECTIONS__BELIS_INTRA_SNIPPET=
SECTIONS__BELIS_PUBLIC_SNIPPET=
SECTIONS__LAGIS_INTRA_SNIPPET=
SECTIONS__LAGIS_PUBLIC_SNIPPET=
SECTIONS__VERDIS_INTRA_SNIPPET=
SECTIONS__VERDIS_PUBLIC_SNIPPET=
SECTIONS__TOOLS_INTRA_SNIPPET=
SECTIONS__TOOLS_PUBLIC_SNIPPET=
VARS_SNIPPET=
INSTALL_SNIPPET=
DESCRIPTIONS_SNIPPET=
DESCRIPTIONS_SNIPPET="$(echo "${DESCRIPTIONS_SNIPPET}"; echo "${DESCRIPTION_TEMPLATE}" | sed "s#__SECNAME__#secgroup_apps#g;s#__DESCRIPTION__#CIDS-WuNDa Starter.#g")"
DESCRIPTIONS_SNIPPET="$(echo "${DESCRIPTIONS_SNIPPET}"; echo "${DESCRIPTION_TEMPLATE}" | sed "s#__SECNAME__#secgroup_intra#g;s#__DESCRIPTION__#Starter die nur aus dem Netzwerk der Stadtverwaltung Wuppertal heraus aufrufbar.#g")"
DESCRIPTIONS_SNIPPET="$(echo "${DESCRIPTIONS_SNIPPET}"; echo "${DESCRIPTION_TEMPLATE}" | sed "s#__SECNAME__#secgroup_public#g;s#__DESCRIPTION__#Starter welche explizit für den Aufruf außerhalb des Netzwerks der Stadtverwaltung Wuppertal vorgesehen sind.#g")"
for POM in "../getdown-"*"/pom.xml"; do 
    SHORTNAME=$(grep -Eo '<launcher.shortname>(.*)</launcher.shortname>' ${POM} | sed 's#<launcher.shortname>\(.*\)</launcher.shortname>#\1#g') 
    if ! echo "${APPS_INFO}" | grep -q "^${SHORTNAME}\$"; then continue; fi

    NAME=$(grep -Eo '<launcher.name>(.*)</launcher.name>' ${POM} | sed 's#<launcher.name>\(.*\)</launcher.name>#\1#g')
    VARNAME=INSTALL_$(echo ${SHORTNAME//-/_} | tr '[:lower:]' '[:upper:]')

    VARS_SNIPPET="$(echo "${VARS_SNIPPET}"; echo "${VAR_TEMPLATE}" | sed 's#__VARNAME__#'"${VARNAME}"'#g;')"
    INSTALL_SNIPPET="$(echo "${INSTALL_SNIPPET}"; echo "${INSTALL_TEMPLATE}" | sed "s#__POM__#${POM}#g;s#__VARNAME__#${VARNAME}#g;s#__SUBDIR__#${SUBDIR}#g;s#__SHORTNAME__#${SHORTNAME}#g;s#__NAME__#${NAME}#g;")"

    if [[ "${SHORTNAME}" == "navigator-public"* ]]; then SECNAME="sec-navigator-public-${SHORTNAME}"; SECTIONS__NAVIGATOR_PUBLIC_SNIPPET="$(echo "${SECTIONS__NAVIGATOR_PUBLIC_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    elif [[ "${SHORTNAME}" == "navigator"* ]]; then SECNAME="sec-navigator-${SHORTNAME}"; SECTIONS__NAVIGATOR_INTRA_SNIPPET="$(echo "${SECTIONS__NAVIGATOR_INTRA_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";

    elif [[ "${SHORTNAME}" == "cismap-public"* ]]; then SECNAME="sec-cismap-public-${SHORTNAME}"; SECTIONS__CISMAP_PUBLIC_SNIPPET="$(echo "${SECTIONS__CISMAP_PUBLIC_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    elif [[ "${SHORTNAME}" == "cismap"* ]]; then SECNAME="sec-cismap-${SHORTNAME}"; SECTIONS__CISMAP_INTRA_SNIPPET="$(echo "${SECTIONS__CISMAP_INTRA_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";

    elif [[ "${SHORTNAME}" == "belis-public"* ]]; then SECNAME="sec-belis-public-${SHORTNAME}"; SECTIONS__BELIS_PUBLIC_SNIPPET="$(echo "${SECTIONS__BELIS_PUBLIC_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    elif [[ "${SHORTNAME}" == "belis"* ]]; then SECNAME="sec-belis-${SHORTNAME}"; SECTIONS__BELIS_INTRA_SNIPPET="$(echo "${SECTIONS__BELIS_INTRA_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";

    elif [[ "${SHORTNAME}" == "lagis-public"* ]]; then SECNAME="sec-lagis-public-${SHORTNAME}"; SECTIONS__LAGIS_PUBLIC_SNIPPET="$(echo "${SECTIONS__LAGIS_PUBLIC_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    elif [[ "${SHORTNAME}" == "lagis"* ]]; then SECNAME="sec-lagis-${SHORTNAME}"; SECTIONS__LAGIS_INTRA_SNIPPET="$(echo "${SECTIONS__LAGIS_INTRA_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";

    elif [[ "${SHORTNAME}" == "verdis-public"* ]]; then SECNAME="sec-verdis-public-${SHORTNAME}"; SECTIONS__VERDIS_PUBLIC_SNIPPET="$(echo "${SECTIONS__VERDIS_PUBLIC_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    elif [[ "${SHORTNAME}" == "verdis"* ]]; then SECNAME="sec-verdis-${SHORTNAME}"; SECTIONS__VERDIS_INTRA_SNIPPET="$(echo "${SECTIONS__VERDIS_INTRA_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";

    elif [[ "${SHORTNAME}" == *"-public"* ]]; then SECNAME="sec-tools-public-${SHORTNAME}"; SECTIONS__TOOLS_PUBLIC_SNIPPET="$(echo "${SECTIONS__TOOLS_PUBLIC_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    else SECNAME="sec-tools-${SHORTNAME}"; SECTIONS__TOOLS_INTRA_SNIPPET="$(echo "${SECTIONS__TOOLS_INTRA_SNIPPET}"; echo "${SECTION_TEMPLATE}" | sed "s#__NAME__#${NAME}#g;s#__VARNAME__#${VARNAME}#g;s#__SECNAME__#${SECNAME}#g")";
    fi
done

SECTIONS__NAVIGATOR_INTRA_SNIPPET=$(echo "${SECTIONS__NAVIGATOR_INTRA_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__CISMAP_INTRA_SNIPPET=$(echo "${SECTIONS__CISMAP_INTRA_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__BELIS_INTRA_SNIPPET=$(echo "${SECTIONS__BELIS_INTRA_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__LAGIS_INTRA_SNIPPET=$(echo "${SECTIONS__LAGIS_INTRA_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__VERDIS_INTRA_SNIPPET=$(echo "${SECTIONS__VERDIS_INTRA_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__TOOLS_INTRA_SNIPPET=$(echo "${SECTIONS__TOOLS_INTRA_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__NAVIGATOR_PUBLIC_SNIPPET=$(echo "${SECTIONS__NAVIGATOR_PUBLIC_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__CISMAP_PUBLIC_SNIPPET=$(echo "${SECTIONS__CISMAP_PUBLIC_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__BELIS_PUBLIC_SNIPPET=$(echo "${SECTIONS__BELIS_PUBLIC_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__LAGIS_PUBLIC_SNIPPET=$(echo "${SECTIONS__LAGIS_PUBLIC_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__VERDIS_PUBLIC_SNIPPET=$(echo "${SECTIONS__VERDIS_PUBLIC_SNIPPET}" | awk 1 ORS='\\n')
SECTIONS__TOOLS_PUBLIC_SNIPPET=$(echo "${SECTIONS__TOOLS_PUBLIC_SNIPPET}" | awk 1 ORS='\\n')

VARS=$(echo "${VARS_SNIPPET}" | sort | awk NF)
INSTALL=$(echo "${INSTALL_SNIPPET}" | awk NF)
SECTIONS=$(echo "${SECTIONS_TEMPLATE}" | sed "
s#__SECTIONS__NAVIGATOR_INTRA_SNIPPET__#${SECTIONS__NAVIGATOR_INTRA_SNIPPET}#g;
s#__SECTIONS__CISMAP_INTRA_SNIPPET__#${SECTIONS__CISMAP_INTRA_SNIPPET}#g;
s#__SECTIONS__BELIS_INTRA_SNIPPET__#${SECTIONS__BELIS_INTRA_SNIPPET}#g;
s#__SECTIONS__LAGIS_INTRA_SNIPPET__#${SECTIONS__LAGIS_INTRA_SNIPPET}#g;
s#__SECTIONS__VERDIS_INTRA_SNIPPET__#${SECTIONS__VERDIS_INTRA_SNIPPET}#g;
s#__SECTIONS__TOOLS_INTRA_SNIPPET__#${SECTIONS__TOOLS_INTRA_SNIPPET}#g;
s#__SECTIONS__NAVIGATOR_PUBLIC_SNIPPET__#${SECTIONS__NAVIGATOR_PUBLIC_SNIPPET}#g;
s#__SECTIONS__CISMAP_PUBLIC_SNIPPET__#${SECTIONS__CISMAP_PUBLIC_SNIPPET}#g;
s#__SECTIONS__BELIS_PUBLIC_SNIPPET__#${SECTIONS__BELIS_PUBLIC_SNIPPET}#g;
s#__SECTIONS__LAGIS_PUBLIC_SNIPPET__#${SECTIONS__LAGIS_PUBLIC_SNIPPET}#g;
s#__SECTIONS__VERDIS_PUBLIC_SNIPPET__#${SECTIONS__VERDIS_PUBLIC_SNIPPET}#g;
s#__SECTIONS__TOOLS_PUBLIC_SNIPPET__#${SECTIONS__TOOLS_PUBLIC_SNIPPET}#g;
" | awk NF)
DESCRIPTIONS=$(echo "${DESCRIPTIONS_TEMPLATE}" | sed "s#__DESCRIPTIONS__#$(echo "${DESCRIPTIONS_SNIPPET}" | awk 1 ORS='\\n')#g" | awk NF)

echo "${NSI_TEMPLATE}" | sed "
s#__VARS__#$(echo "${VARS}" | awk 1 ORS='\\n')#g;
s#__INSTALL__#$(echo "${INSTALL}" | awk 1 ORS='\\n')#g;
s#__SECTIONS__#$(echo "${SECTIONS}" | awk 1 ORS='\\n')#g;
s#__DESCRIPTIONS__#$(echo "${DESCRIPTIONS}" | awk 1 ORS='\\n')#g;
" | iconv -c -f UTF-8 -t ISO8859-1 > ${NSI_FILE}
