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

CMAKE_MINIMUM_REQUIRED(VERSION 3.30.2)

SET(TEMPLATE_FDK_VERSION "0.0.0.0" CACHE STRING "Template-FDK Version")

PROJECT(Template-FDK VERSION ${TEMPLATE_FDK_VERSION} LANGUAGES NONE)

STRING(TOLOWER ${PROJECT_NAME} PROJECT_NAME_TOLOWER)

SET(IP_XACT_VENDOR ${PROJECT_NAME_TOLOWER} CACHE STRING "IP-XACT Vendor" FORCE)

INSTALL(
    FILES
        ${PROJECT_SOURCE_DIR}/AUTHORS.md
        ${PROJECT_SOURCE_DIR}/CHANGELOG.md
        ${PROJECT_SOURCE_DIR}/LICENSE
        ${PROJECT_SOURCE_DIR}/README.md
    DESTINATION .
    COMPONENT runtime)

ADD_SUBDIRECTORY(Repositories)
ADD_SUBDIRECTORY(Designs)

IF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")

    SET(CMAKE_INSTALL_PREFIX /opt/by-EAjks.Com/${PROJECT_NAME})

    CONFIGURE_FILE(
        ${PROJECT_SOURCE_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/conffiles.in
        ${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/conffiles
        @ONLY)

    CONFIGURE_FILE(
        ${PROJECT_SOURCE_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/preinst.in
        ${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/preinst
        @ONLY)

    CONFIGURE_FILE(
        ${PROJECT_SOURCE_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/postinst.in
        ${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/postinst
        @ONLY)

    CONFIGURE_FILE(
        ${PROJECT_SOURCE_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/prerm.in
        ${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/prerm
        @ONLY)

    CONFIGURE_FILE(
        ${PROJECT_SOURCE_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/postrm.in
        ${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/postrm
        @ONLY)

ENDIF()

INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_PACKAGE_NAME ${PROJECT_NAME})
SET(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "FDK Template by EAjks")
SET(CPACK_PACKAGE_VENDOR "by-EAjks.Com")
SET(CPACK_PACKAGE_CONTACT "Andrea and Eric DELAGE <Contact@by-EAjks.Com>")
SET(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}")

IF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")

    SET(CPACK_SET_DESTDIR ON)

    SET(LINUX_DISTRIBUTION_ID "unknown")

    IF(EXISTS "/etc/os-release")
        FILE(STRINGS "/etc/os-release" LINUX_DISTRIBUTION_ID REGEX "^ID=")
        IF(NOT LINUX_DISTRIBUTION_ID STREQUAL "")
            STRING(REPLACE "ID=" "" LINUX_DISTRIBUTION_ID "${LINUX_DISTRIBUTION_ID}")
            STRING(REPLACE "\""  "" LINUX_DISTRIBUTION_ID "${LINUX_DISTRIBUTION_ID}")
        ENDIF()
    ENDIF()

    MESSAGE("-- The Linux distribution identification is '${LINUX_DISTRIBUTION_ID}'.")

    IF(${LINUX_DISTRIBUTION_ID} MATCHES "debian|ubuntu")
        SET(CPACK_GENERATOR "DEB")
        SET(CPACK_DEB_PACKAGE_ARCHITECTURE "amd64")
        SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/conffiles;${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/preinst;${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/postinst;${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/prerm;${PROJECT_BINARY_DIR}/Miscellaneous/Packaging/Linux/DEBIAN/postrm")
        SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libpython3.12")
    ENDIF()

    IF(${LINUX_DISTRIBUTION_ID} MATCHES "centos|redhat")
        SET(CPACK_GENERATOR "RPM")
        SET(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
    ENDIF()

    SET(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)

ENDIF()

IF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")

    SET(CPACK_GENERATOR "ZIP")

ENDIF()

INCLUDE(CPack)
