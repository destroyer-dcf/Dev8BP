# ==============================================================================
#  Dev8BP - Copyright (c) 2026 Destroyer
# ==============================================================================
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ==============================================================================

# tool_paths.mk - Rutas a las herramientas de Dev8BP
# =====================================================
# Este archivo centraliza las rutas a todas las herramientas
# incluidas en Dev8bp/tools/
# =====================================================

# ABASM - Ensamblador Z80 para Amstrad CPC
ABASM_PATH ?= $(DEV8BP_PATH)/tools/abasm/src/abasm.py

# DSK.PY - Herramienta para crear y manipular imágenes DSK de Amstrad CPC
DSK_PATH ?= $(DEV8BP_PATH)/tools/abasm/src/dsk.py

# HEX2BIN - Conversor de archivos Intel HEX a binario
# Detectar sistema operativo y arquitectura
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
    ifeq ($(UNAME_M),arm64)
        HEX2BIN_DIR := mac-arm64
    else
        HEX2BIN_DIR := macos-x86_64
    endif
else ifeq ($(UNAME_S),Linux)
    ifeq ($(UNAME_M),aarch64)
        HEX2BIN_DIR := linux-arm64
    else
        HEX2BIN_DIR := linux-x86_64
    endif
else
    # Windows (WSL o MSYS2)
    HEX2BIN_DIR := windows-x86_64
endif

HEX2BIN_PATH ?= $(DEV8BP_PATH)/tools/hex2bin/$(HEX2BIN_DIR)/hex2bin
MOT2BIN_PATH ?= $(DEV8BP_PATH)/tools/hex2bin/$(HEX2BIN_DIR)/mot2bin

