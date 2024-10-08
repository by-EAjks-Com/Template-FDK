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

PROJECT(Interfaces VERSION ${Template-FDK_VERSION} LANGUAGES NONE)

STRING(TOLOWER ${PROJECT_NAME} PROJECT_NAME_TOLOWER)

SET(IP_XACT_LIBRARY ${PROJECT_NAME_TOLOWER} CACHE STRING "IP-XACT Library" FORCE)

ADD_SUBDIRECTORY(Handshaking_OneWay-1.0)
ADD_SUBDIRECTORY(Handshaking_TwoWay-1.0)
ADD_SUBDIRECTORY(Handshaking_Credit-1.0)

ADD_SUBDIRECTORY(FIFO_Read-1.0)
ADD_SUBDIRECTORY(FIFO_Write-1.0)
