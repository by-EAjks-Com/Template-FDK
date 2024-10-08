#!/bin/bash
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

rm    -rf ./GeneratePackagesForLinuxUsingGnuCompiler
mkdir -p  ./GeneratePackagesForLinuxUsingGnuCompiler
pushd     ./GeneratePackagesForLinuxUsingGnuCompiler

export XILINX_VIVADO_VERSION=2024.1
source /opt/Xilinx/Vitis/$XILINX_VIVADO_VERSION/.settings64-Vitis.sh
source /opt/Xilinx/Vitis_HLS/$XILINX_VIVADO_VERSION/.settings64-Vitis_HLS.sh
source /opt/Xilinx/Vivado/$XILINX_VIVADO_VERSION/.settings64-Vivado.sh

. /opt/intel/oneapi/setvars.sh

export EAjks_NoEncryption=1

/opt/Kitware/cmake-3.30.2-linux-x86_64/bin/cmake \
    -G "Ninja" \
    -D CMAKE_C_COMPILER=gcc \
    -D CMAKE_CXX_COMPILER=g++ \
    -D CMAKE_BUILD_TYPE=Debug \
    -D TEMPLATE_FDK_VERSION=1.2.3.4 \
    ../../../Code

ninja package

popd
