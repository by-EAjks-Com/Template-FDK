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

PROJECT(Template_PM VERSION 1.0 LANGUAGES NONE)

STRING(TOLOWER ${PROJECT_NAME} PROJECT_NAME_TOLOWER)

SET(IP_XACT_VENDOR by-eajks.com CACHE STRING "IP-XACT Vendor")
SET(IP_XACT_LIBRARY designs CACHE STRING "IP-XACT Library")
SET(IP_XACT_NAME ${PROJECT_NAME_TOLOWER})
SET(IP_XACT_VERSION ${PROJECT_VERSION})

SET(PROJECT_OUTPUT_DIR ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/${IP_XACT_LIBRARY}/${IP_XACT_NAME}-${IP_XACT_VERSION})
SET(LIBRARY_NAME ${PROJECT_NAME_TOLOWER}_v${PROJECT_VERSION_MAJOR}_${PROJECT_VERSION_MINOR})

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION}-Assemble
        DEPENDS
            ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.xpr
            ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.srcs/sources_1/bd/system/system.bd
            ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.gen/sources_1/bd/system/hdl/system_wrapper.vhd
        VERBATIM)

ADD_CUSTOM_COMMAND(
    OUTPUT
        ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.xpr
        ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.srcs/sources_1/bd/system/system.bd
        ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.gen/sources_1/bd/system/hdl/system_wrapper.vhd
    COMMAND
        vivado
            -mode batch
            -quiet
            -source ${PROJECT_SOURCE_DIR}/etc/script_assemble.tcl
            -nojournal
            -log script_assemble.log
            -tclargs
                ${IP_XACT_VENDOR}
                ${IP_XACT_LIBRARY}
                ${IP_XACT_NAME}
                ${IP_XACT_VERSION}
                ${PROJECT_SOURCE_DIR}/src
                ${PROJECT_OUTPUT_DIR}
                ${LIBRARY_NAME}
                ${CMAKE_SOURCE_DIR}/Repositories/Boards
                ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/components
                ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/interfaces
                0 # QUICK_COMPILE
                1 # INCLUDE_DEBUG
    DEPENDS
        ${CMAKE_SOURCE_DIR}/Repositories/Boards/Xilinx/Alveo_U50.xdc
        ${PROJECT_SOURCE_DIR}/etc/script_assemble.tcl
    COMMENT "Assembling ${PROJECT_NAME}-${PROJECT_VERSION}"
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION}-Synthesize
        DEPENDS
            ${PROJECT_BINARY_DIR}/Synthesis/${IP_XACT_NAME}.xpr
            ${PROJECT_BINARY_DIR}/Synthesis/${IP_XACT_NAME}.runs/synth_1/system_wrapper.dcp
        VERBATIM)

ADD_CUSTOM_COMMAND(
    OUTPUT
        ${PROJECT_BINARY_DIR}/Synthesis/${IP_XACT_NAME}.xpr
        ${PROJECT_BINARY_DIR}/Synthesis/${IP_XACT_NAME}.runs/synth_1/system_wrapper.dcp
    COMMAND
        vivado
            -mode batch
            -quiet
            -source ${PROJECT_SOURCE_DIR}/etc/script_synthesize.tcl
            -nojournal
            -log script_synthesize.log
            -tclargs
                ${IP_XACT_VENDOR}
                ${IP_XACT_LIBRARY}
                ${IP_XACT_NAME}
                ${IP_XACT_VERSION}
                ${PROJECT_SOURCE_DIR}/src
                ${PROJECT_OUTPUT_DIR}
                ${LIBRARY_NAME}
                ${CMAKE_SOURCE_DIR}/Repositories/Boards
                ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/components
                ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/interfaces
                ${QUICK_COMPILE}
                ${INCLUDE_DEBUG}
    DEPENDS
        ${PROJECT_NAME}-${PROJECT_VERSION}-Assemble
        ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.xpr
        ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.srcs/sources_1/bd/system/system.bd
        ${PROJECT_BINARY_DIR}/Assembly/${IP_XACT_NAME}.gen/sources_1/bd/system/hdl/system_wrapper.vhd
        ${PROJECT_SOURCE_DIR}/etc/script_synthesize.tcl
    COMMENT "Synthesizing ${PROJECT_NAME}-${PROJECT_VERSION}"
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)

ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}-${PROJECT_VERSION}-Implement
        DEPENDS
            ${PROJECT_BINARY_DIR}/Implementation/${IP_XACT_NAME}.xpr
        VERBATIM)

ADD_CUSTOM_COMMAND(
    OUTPUT
        ${PROJECT_BINARY_DIR}/Implementation/${IP_XACT_NAME}.xpr
    COMMAND
        vivado
            -mode batch
            -quiet
            -source ${PROJECT_SOURCE_DIR}/etc/script_implement.tcl
            -nojournal
            -log script_implement.log
            -tclargs
                ${IP_XACT_VENDOR}
                ${IP_XACT_LIBRARY}
                ${IP_XACT_NAME}
                ${IP_XACT_VERSION}
                ${PROJECT_SOURCE_DIR}/src
                ${PROJECT_OUTPUT_DIR}
                ${LIBRARY_NAME}
                ${CMAKE_SOURCE_DIR}/Repositories/Boards
                ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/components
                ${CMAKE_BINARY_DIR}/Repositories-Generated/${IP_XACT_VENDOR}/interfaces
                ${QUICK_COMPILE}
                ${INCLUDE_DEBUG}
    DEPENDS
        ${PROJECT_NAME}-${PROJECT_VERSION}-Synthesize
        ${PROJECT_BINARY_DIR}/Synthesis/${IP_XACT_NAME}.xpr
        ${PROJECT_BINARY_DIR}/Synthesis/${IP_XACT_NAME}.runs/synth_1/system_wrapper.dcp
        ${PROJECT_SOURCE_DIR}/etc/script_implement.tcl
    COMMENT "Implementing ${PROJECT_NAME}-${PROJECT_VERSION}"
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)
