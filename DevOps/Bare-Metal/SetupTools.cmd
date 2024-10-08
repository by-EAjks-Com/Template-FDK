@echo off
::  Template-FDK, by-EAjks.Com FPGA Design Best Practices
::  Copyright (c) 2022-2024 Andrea and Eric DELAGE <Contact@by-EAjks.Com>
::
::  This program is free software: you can redistribute it and/or modify
::  it under the terms of the GNU General Public License as published by
::  the Free Software Foundation, either version 3 of the License, or
::  (at your option) any later version.
::
::  This program is distributed in the hope that it will be useful,
::  but WITHOUT ANY WARRANTY; without even the implied warranty of
::  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::  GNU General Public License for more details.
::
::  You should have received a copy of the GNU General Public License
::  along with this program.  If not, see <https://www.gnu.org/licenses/>.

set XILINX_VIVADO_VERSION=2024.1
call "D:\Tools\Xilinx\Vitis\%XILINX_VIVADO_VERSION%\.settings64-Vitis.bat"
call "D:\Tools\Xilinx\Vitis_HLS\%XILINX_VIVADO_VERSION%\.settings64-Vitis_HLS.bat"
call "D:\Tools\Xilinx\Vivado\%XILINX_VIVADO_VERSION%\.settings64-Vivado.bat"

call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set EAjks_NoEncryption=1
