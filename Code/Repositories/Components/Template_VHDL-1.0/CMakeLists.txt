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

PROJECT(Template_VHDL VERSION 1.0 LANGUAGES NONE)

STRING(TOLOWER ${PROJECT_NAME} PROJECT_NAME_TOLOWER)

SET(IP_XACT_VENDOR by-eajks.com CACHE STRING "IP-XACT Vendor")
SET(IP_XACT_LIBRARY components CACHE STRING "IP-XACT Library")
SET(IP_XACT_NAME ${PROJECT_NAME_TOLOWER})
SET(IP_XACT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})

SET(PROJECT_OUTPUT_DIR ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/${IP_XACT_LIBRARY}/${IP_XACT_NAME}-${IP_XACT_VERSION})
SET(LIBRARY_NAME ${PROJECT_NAME_TOLOWER}_v${PROJECT_VERSION_MAJOR}_${PROJECT_VERSION_MINOR})

CONFIGURE_FILE(
    ${PROJECT_SOURCE_DIR}/LICENSE
    ${PROJECT_OUTPUT_DIR}/LICENSE
    COPYONLY)

SET(
    PROJECT_SOURCE_FILES
        ${PROJECT_SOURCE_DIR}/src/constraints/top_level_ooc.xdc
        ${PROJECT_SOURCE_DIR}/src/constraints/top_level.xdc
        ${PROJECT_SOURCE_DIR}/src/models/top_level.vhd)

SET(
    PROJECT_SOURCE_TESTS
        ${PROJECT_SOURCE_DIR}/src/tests/testbench_pkg.vhd
        ${PROJECT_SOURCE_DIR}/src/tests/testbench.vhd
        ${PROJECT_SOURCE_DIR}/src/tests/testcases_pkg.vhd
        ${PROJECT_SOURCE_DIR}/src/tests/testcases.vhd)

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION} ALL
        DEPENDS
            ${PROJECT_OUTPUT_DIR}/component.xml
        VERBATIM)

ADD_CUSTOM_COMMAND(
    OUTPUT
        ${PROJECT_OUTPUT_DIR}/component.xml
    COMMAND
        vivado
            -mode batch
            -quiet
            -source ${Template-FDK_SOURCE_DIR}/Miscellaneous/Encryption/script_copy_then_encrypt_ieee_1735_2014.tcl
            -nojournal
            -log script_copy_then_encrypt_ieee_1735_2014.log
            -tclargs
                ${PROJECT_SOURCE_DIR}/src
                ${PROJECT_OUTPUT_DIR}
                ${PROJECT_SOURCE_FILES}
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
                ${IP_XACT_NAME}
                ${IP_XACT_VERSION}
                ${PROJECT_OUTPUT_DIR}
                ${LIBRARY_NAME}
    DEPENDS
        Handshaking_OneWay-1.0
        Handshaking_TwoWay-1.0
        ${Template-FDK_SOURCE_DIR}/Miscellaneous/Encryption/script_copy_then_encrypt_ieee_1735_2014.tcl
        ${Template-FDK_SOURCE_DIR}/Miscellaneous/Encryption/ieee_1735_2014_public_keys.v
        ${Template-FDK_SOURCE_DIR}/Miscellaneous/Encryption/ieee_1735_2014_public_keys.vhd
        ${PROJECT_SOURCE_DIR}/etc/script_package_ip_xact.tcl
        ${PROJECT_SOURCE_FILES}
    COMMENT "Packaging ${PROJECT_NAME}-${PROJECT_VERSION}"
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION}-Simulate
        COMMAND
            vivado
                -mode gui
                -quiet
                -source ${PROJECT_SOURCE_DIR}/etc/script_simulate.tcl
                -nojournal
                -log script_simulate.log
                -tclargs
                    ${IP_XACT_VENDOR}
                    ${IP_XACT_LIBRARY}
                    ${IP_XACT_NAME}
                    ${IP_XACT_VERSION}
                    ${PROJECT_SOURCE_DIR}/src
                    ${PROJECT_OUTPUT_DIR}
                    ${LIBRARY_NAME}
                    ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/boards
                    ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/components
                    ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/interfaces
        DEPENDS
            ${PROJECT_NAME}-${PROJECT_VERSION}
            ${PROJECT_OUTPUT_DIR}/component.xml
            ${PROJECT_SOURCE_TESTS}
            ${PROJECT_SOURCE_DIR}/etc/script_simulate.tcl
        COMMENT "Simulating ${PROJECT_NAME}-${PROJECT_VERSION}"
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        VERBATIM)

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION}-Synthesize
        COMMAND
            vivado
                -mode gui
                -quiet
                -source ${PROJECT_SOURCE_DIR}/etc/script_synthesize.tcl
                -nojournal
                -log script_synthesize.log
                -tclargs
                    ${IP_XACT_VENDOR}
                    ${IP_XACT_LIBRARY}
                    ${IP_XACT_NAME}
                    ${IP_XACT_VERSION}
                    ${PROJECT_OUTPUT_DIR}
                    ${LIBRARY_NAME}
                    ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/boards
                    ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/components
                    ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/interfaces
        DEPENDS
            ${PROJECT_NAME}-${PROJECT_VERSION}
            ${PROJECT_OUTPUT_DIR}/component.xml
            ${PROJECT_SOURCE_DIR}/etc/script_synthesize.tcl
        COMMENT "Synthesizing ${PROJECT_NAME}-${PROJECT_VERSION}"
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        VERBATIM)

INSTALL(
    DIRECTORY ${PROJECT_OUTPUT_DIR}
    DESTINATION repositories/${IP_XACT_VENDOR}/${IP_XACT_LIBRARY}
    COMPONENT fdk)
