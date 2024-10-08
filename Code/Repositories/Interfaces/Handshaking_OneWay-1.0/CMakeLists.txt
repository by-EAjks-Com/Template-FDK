#   Template-FDK, by-EAjks.Com FPGA Design Best Practices
#   Copyright (c) 2022-2024 Andrea and Eric DELAGE <Contact@by-EAjks.Com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROJECT(Handshaking_OneWay VERSION 1.0 LANGUAGES NONE)

STRING(TOLOWER ${PROJECT_NAME} PROJECT_NAME_TOLOWER)

SET(IP_XACT_VENDOR by-eajks.com CACHE STRING "IP-XACT Vendor")
SET(IP_XACT_LIBRARY interfaces CACHE STRING "IP-XACT Library")
SET(IP_XACT_NAME_BUSDEF ${PROJECT_NAME_TOLOWER})
SET(IP_XACT_NAME_ABSDEF ${PROJECT_NAME_TOLOWER}_rtl)
SET(IP_XACT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})

SET(PROJECT_OUTPUT_DIR ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/${IP_XACT_LIBRARY}/${IP_XACT_NAME_BUSDEF}-${IP_XACT_VERSION})

CONFIGURE_FILE(
    ${PROJECT_SOURCE_DIR}/LICENSE
    ${PROJECT_OUTPUT_DIR}/LICENSE
    COPYONLY)

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION} ALL
        DEPENDS
            ${PROJECT_OUTPUT_DIR}/${IP_XACT_NAME_BUSDEF}.xml
            ${PROJECT_OUTPUT_DIR}/${IP_XACT_NAME_ABSDEF}.xml
        VERBATIM)

ADD_CUSTOM_COMMAND(
    OUTPUT
        ${PROJECT_OUTPUT_DIR}/${IP_XACT_NAME_BUSDEF}.xml
        ${PROJECT_OUTPUT_DIR}/${IP_XACT_NAME_ABSDEF}.xml
    COMMAND
        vivado
            -mode batch
            -quiet
            -source ${PROJECT_SOURCE_DIR}/etc/script_package_ip_xact.tcl
            -nojournal
            -log script_package_ip_xact.log
            -tclargs
                ${IP_XACT_VENDOR}
                ${IP_XACT_LIBRARY}
                ${IP_XACT_NAME_BUSDEF}
                ${IP_XACT_NAME_ABSDEF}
                ${IP_XACT_VERSION}
                ${PROJECT_OUTPUT_DIR}
    DEPENDS
        ${PROJECT_SOURCE_DIR}/etc/script_package_ip_xact.tcl
    COMMENT "Packaging ${PROJECT_NAME}-${PROJECT_VERSION}"
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)

INSTALL(
    DIRECTORY ${PROJECT_OUTPUT_DIR}
    DESTINATION repositories/${IP_XACT_VENDOR}/${IP_XACT_LIBRARY}
    COMPONENT fdk)
