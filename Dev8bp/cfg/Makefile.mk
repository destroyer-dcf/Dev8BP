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

# Verificar que DEV8BP_PATH está definida
ifndef DEV8BP_PATH
$(error DEV8BP_PATH no está definida. Ejecuta setup.sh en el directorio raíz de Dev8BP)
endif

# Incluir rutas de herramientas
include $(DEV8BP_PATH)/cfg/tool_paths.mk

# Incluir funciones reutilizables
include $(DEV8BP_PATH)/cfg/functions.mk

# Ruta al directorio ASM (requerido)
ASM_PATH ?= ./8BP_V43/ASM

# Ruta al directorio BASIC (archivos .bas que se añadirán al DSK)
BASIC_PATH ?= ./bas

# Configuración del emulador RetroVirtualMachine
RVM_PATH ?= 
CPC_MODEL ?= 464
RUN_FILE ?=

# Nivel de compilación (0-4)
BUILD_LEVEL ?= 0

# Directorio de objetos compilados (binarios, lst, map)
OBJ_DIR := obj

# Directorio de salida para DSK
DIST_DIR := dist

# Intérprete de Python
PYTHON := $(shell command -v python3 2> /dev/null || command -v python)

# Scripts (desde DEV8BP_PATH)
PATCH_SCRIPT := $(DEV8BP_PATH)/scripts/patch_asm.sh
CONVERT_SCRIPT := $(DEV8BP_PATH)/scripts/convert_to_utf8.sh

# Colores para output
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
CYAN := \033[0;36m
RED := \033[0;31m
NC := \033[0m # No Color

#TARGETS PRINCIPALES

.PHONY: all help clean info dsk bas run

# TARGET POR DEFECTO - Compilar proyecto completo
all: info _compile

# Crear directorios necesarios
$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

# MOSTRAR AYUDA
help:
	@echo ""
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo "$(BLUE)  8BP - Makefile$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(CYAN)Uso:$(NC)"
	@echo "  make [target] [VARIABLE=valor]"
	@echo ""
	@echo "$(CYAN)Targets disponibles:$(NC)"
	@echo "  help        - Mostrar esta ayuda"
	@echo "  info        - Mostrar configuración actual"
	@echo "  all         - Mostrar info + compilar + crear DSK (por defecto)"
	@echo "  dsk         - Crear imagen DSK con binario compilado"
	@echo "  bas         - Añadir archivos BASIC al DSK"
	@echo "  run         - Ejecutar DSK en RetroVirtualMachine"
	@echo "  clean       - Limpiar archivos temporales, obj y dist"
	@echo ""
	@echo "$(CYAN)Variables:$(NC)"
	@echo "  ASM_PATH      Ruta al directorio ASM (actual: $(ASM_PATH))"
	@echo "  BASIC_PATH    Ruta al directorio BASIC (actual: $(BASIC_PATH))"
	@echo "  BUILD_LEVEL   Nivel de compilación 0-4 (actual: $(BUILD_LEVEL))"
	@echo "  ABASM_PATH    Ruta a abasm.py (actual: $(ABASM_PATH))"
	@echo "  OBJ_DIR       Directorio de objetos (actual: $(OBJ_DIR))"
	@echo "  DIST_DIR      Directorio de salida DSK (actual: $(DIST_DIR))"
	@echo "  DSK           Nombre de la imagen DSK (actual: $(DSK))"
	@echo "  RVM_PATH      Ruta a RetroVirtualMachine (actual: $(RVM_PATH))"
	@echo "  CPC_MODEL     Modelo de CPC (actual: $(CPC_MODEL))"
	@echo "  RUN_FILE      Archivo a ejecutar (actual: $(RUN_FILE))"
	@echo ""
	@echo "$(CYAN)Ejemplos:$(NC)"
	@echo "  make                        # Compilar proyecto (info + compile + dsk)"
	@echo "  make clean                  # Limpiar archivos generados"
	@echo "  make info                   # Ver configuración"
	@echo ""
	@echo "$(CYAN)Niveles de compilación:$(NC)"
	@echo "  0 = Todas las funcionalidades (MEMORY 23600)"
	@echo "  1 = Juegos de laberintos (MEMORY 25000)"
	@echo "  2 = Juegos con scroll (MEMORY 24800)"
	@echo "  3 = Juegos pseudo-3D (MEMORY 24000)"
	@echo "  4 = Sin scroll/layout +500 bytes (MEMORY 25500)"
	@echo ""

# INFORMACION DE CONFIGURACION
info:
	@echo ""
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo "$(BLUE)  ⚙️ Dev8BP - Configuración$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(CYAN)Directorio ASM:$(NC)     $(ASM_PATH)"
	@echo "$(CYAN)ABASM:$(NC)              $(ABASM_PATH)"
	@echo "$(CYAN)DSK Tool:$(NC)           $(DSK_PATH)"
	@echo "$(CYAN)Nivel de build:$(NC)     $(BUILD_LEVEL)"
	@echo "$(CYAN)Directorio obj:$(NC)     $(OBJ_DIR)"
	@echo "$(CYAN)Directorio dist:$(NC)    $(DIST_DIR)"
	@echo "$(CYAN)Python:$(NC)             $(PYTHON)"
	@echo ""

# Compilar con el nivel especificado
_compile: $(OBJ_DIR) $(DIST_DIR)
	@echo "$(YELLOW)\nCompilando nivel $(BUILD_LEVEL)...$(NC)\n"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo "$(BLUE)  ▶️ 8BP - Build $(BUILD_LEVEL)$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo ""
	@# Información del build
	@case $(BUILD_LEVEL) in \
		0) DESC="Todas las funcionalidades"; MEMORY="MEMORY 23599"; COMMANDS="|LAYOUT, |COLAY, |MAP2SP, |UMA, |3D" ;; \
		1) DESC="Juegos de laberintos"; MEMORY="MEMORY 25000"; COMMANDS="|LAYOUT, |COLAY" ;; \
		2) DESC="Juegos con scroll"; MEMORY="MEMORY 24800"; COMMANDS="|MAP2SP, |UMA" ;; \
		3) DESC="Juegos pseudo-3D"; MEMORY="MEMORY 24000"; COMMANDS="|3D" ;; \
		4) DESC="Sin scroll/layout (+500 bytes)"; MEMORY="MEMORY 25500"; COMMANDS="Básicos" ;; \
	esac; \
	echo "$(CYAN)Descripción:$(NC)     $$DESC"; \
	echo "$(CYAN)Memoria BASIC:$(NC)   $$MEMORY"; \
	echo "$(CYAN)Comandos:$(NC)        $$COMMANDS"; \
	echo "$(CYAN)Directorio ASM:$(NC)  $(ASM_PATH)"; \
	echo "$(CYAN)ABASM:$(NC)           $(ABASM_PATH)"; \
	echo ""
	@# Verificar que existe make_all_mygame.asm
	@if [ ! -f "$(ASM_PATH)/make_all_mygame.asm" ]; then \
		echo "$(RED)Error: No existe el archivo $(ASM_PATH)/make_all_mygame.asm$(NC)"; \
		exit 1; \
	fi
	@# Hacer backup y modificar ASSEMBLING_OPTION
	@echo "$(YELLOW)Configurando ASSEMBLING_OPTION = $(BUILD_LEVEL)...\n$(NC)"
	@cp "$(ASM_PATH)/make_all_mygame.asm" "$(ASM_PATH)/make_all_mygame.asm.backup_build"
	@# Modificar ASSEMBLING_OPTION
	@if [[ "$(shell uname)" == "Darwin" ]]; then \
		sed -i '' 's/let ASSEMBLING_OPTION = [0-9]/let ASSEMBLING_OPTION = $(BUILD_LEVEL)/' "$(ASM_PATH)/make_all_mygame.asm"; \
	else \
		sed -i 's/let ASSEMBLING_OPTION = [0-9]/let ASSEMBLING_OPTION = $(BUILD_LEVEL)/' "$(ASM_PATH)/make_all_mygame.asm"; \
	fi
	@# Añadir directivas SAVE condicionales si no existen
	@if ! grep -q "if ASSEMBLING_OPTION = 0" "$(ASM_PATH)/make_all_mygame.asm"; then \
		if grep -q "^SAVE " "$(ASM_PATH)/make_all_mygame.asm"; then \
			if [[ "$(shell uname)" == "Darwin" ]]; then \
				sed -i '' '/^SAVE /d' "$(ASM_PATH)/make_all_mygame.asm"; \
			else \
				sed -i '/^SAVE /d' "$(ASM_PATH)/make_all_mygame.asm"; \
			fi; \
		fi; \
		echo "" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "if ASSEMBLING_OPTION = 0" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo 'SAVE "8BP0.bin",23600,19120' >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "elseif ASSEMBLING_OPTION = 1" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo 'SAVE "8BP1.bin",25000,17620' >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "elseif ASSEMBLING_OPTION = 2" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo 'SAVE "8BP2.bin",24800,17820' >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "elseif ASSEMBLING_OPTION = 3" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo 'SAVE "8BP3.bin",24000,18620' >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "elseif ASSEMBLING_OPTION = 4" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo 'SAVE "8BP4.bin",25300,17320' >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "endif" >> "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "$(CYAN)Añadidas directivas SAVE condicionales:$(NC)"; \
		echo "  $(CYAN)0:$(NC) 8BP0.bin, 23600, 19120"; \
		echo "  $(CYAN)1:$(NC) 8BP1.bin, 25000, 17620"; \
		echo "  $(CYAN)2:$(NC) 8BP2.bin, 24800, 17820"; \
		echo "  $(CYAN)3:$(NC) 8BP3.bin, 24000, 18620"; \
		echo "  $(CYAN)4:$(NC) 8BP4.bin, 25300, 17320"; \
	fi
	@echo "$(CYAN)Archivo a compilar:$(NC)  make_all_mygame.asm"
	@echo "$(CYAN)Carpeta obj:$(NC)         $(OBJ_DIR)"
	@echo "\n$(YELLOW)Compilando con ABASM...$(NC)\n"
	@# Compilar con ABASM - Guardar directorio del proyecto antes de cambiar
	@PROJECT_ROOT="$(CURDIR)"; \
	cd "$(ASM_PATH)" && $(PYTHON) "$(ABASM_PATH)" "make_all_mygame.asm" --tolerance 2 && \
	if [ -f "8BP$(BUILD_LEVEL).bin" ]; then \
		mv "8BP$(BUILD_LEVEL).bin" "$$PROJECT_ROOT/$(OBJ_DIR)/"; \
		if [ -f "make_all_mygame.bin" ]; then mv "make_all_mygame.bin" "$$PROJECT_ROOT/$(OBJ_DIR)/"; fi; \
		for ext in lst map; do \
			for file in *.$$ext; do \
				if [ -f "$$file" ]; then mv "$$file" "$$PROJECT_ROOT/$(OBJ_DIR)/" 2>/dev/null || true; fi; \
			done; \
		done; \
		rm -f *.bin; \
		SIZE=$$(stat -f%z "$(OBJ_DIR)/8BP$(BUILD_LEVEL).bin" 2>/dev/null || stat -c%s "$(OBJ_DIR)/8BP$(BUILD_LEVEL).bin" 2>/dev/null); \
		mv "$(ASM_PATH)/make_all_mygame.asm.backup_build" "$(ASM_PATH)/make_all_mygame.asm"; \
		echo ""; \
		echo "$(GREEN)  Archivo:    8BP$(BUILD_LEVEL).bin$(NC)"; \
		echo "$(GREEN)  Ubicación:  $(OBJ_DIR)/8BP$(BUILD_LEVEL).bin$(NC)"; \
		echo "$(GREEN)  Tamaño:     $$SIZE bytes$(NC)"; \
		echo ""; \
		case $(BUILD_LEVEL) in \
			0) MEMORY="MEMORY 23599" ;; \
			1) MEMORY="MEMORY 24999" ;; \
			2) MEMORY="MEMORY 24799" ;; \
			3) MEMORY="MEMORY 23999" ;; \
			4) MEMORY="MEMORY 25299" ;; \
		esac; \
		echo "$(CYAN)Uso desde BASIC:$(NC)"; \
		echo "  $$MEMORY"; \
		echo "  LOAD\"8BP$(BUILD_LEVEL).bin\""; \
		echo "  CALL &6B78"; \
		echo ""; \
	else \
		mv "$(ASM_PATH)/make_all_mygame.asm.backup_build" "$(ASM_PATH)/make_all_mygame.asm"; \
		echo "$(YELLOW)Advertencia: No se encontró el binario 8BP$(BUILD_LEVEL).bin$(NC)"; \
		exit 1; \
	fi || (mv "$(ASM_PATH)/make_all_mygame.asm.backup_build" "$(ASM_PATH)/make_all_mygame.asm" 2>/dev/null; exit 1)
	@# Verificar que el binario se generó correctamente
	@if [ -f "$(OBJ_DIR)/8BP$(BUILD_LEVEL).bin" ]; then \
		echo "$(GREEN)✓ Build Successful!!$(NC)"; \
		echo ""; \
	else \
		echo "$(YELLOW)⚠ Binario no encontrado en obj, buscando...$(NC)"; \
		if [ -f "$(ASM_PATH)/8BP$(BUILD_LEVEL).bin" ]; then \
			mv "$(ASM_PATH)/8BP$(BUILD_LEVEL).bin" "$(OBJ_DIR)/" && \
			echo "$(GREEN)✓ Binario movido a: $(OBJ_DIR)/8BP$(BUILD_LEVEL).bin$(NC)"; \
		fi \
	fi
	@# Crear/actualizar DSK automáticamente
	@$(MAKE) dsk --no-print-directory

# LIMPIAR ARCHIVOS TEMPORALES
clean:
	@echo "\n$(YELLOW)Limpiando archivos temporales...$(NC)"
	@rm -f "$(ASM_PATH)"/*.backup
	@rm -f "$(ASM_PATH)"/*.backup_build
	@rm -f "$(ASM_PATH)"/*.encoding_backup
	@rm -f "$(ASM_PATH)"/make_all_mygame.bin
	@rm -f "$(ASM_PATH)"/*.lst
	@rm -f "$(ASM_PATH)"/*.map
	@rm -rf $(OBJ_DIR)
	@rm -rf $(DIST_DIR)
	@echo "$(GREEN)✓ Limpieza completada (obj y dist eliminados)$(NC)\n"

# CREAR IMAGEN DSK
dsk: $(DIST_DIR)
	@echo ""
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo "$(BLUE)  💾 Crear imagen DSK$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(CYAN)Nombre DSK:$(NC)         $(DSK)"
	@echo "$(CYAN)DSK Tool:$(NC)           $(DSK_PATH)"
	@echo ""
	@if [ ! -f "$(DSK_PATH)" ]; then \
		echo "$(RED)Error: dsk.py no encontrado en $(DSK_PATH)$(NC)"; \
		exit 1; \
	fi
	@$(call create-dsk,$(DSK))
	@echo ""
	@if [ ! -f "$(OBJ_DIR)/8BP$(BUILD_LEVEL).bin" ]; then \
		echo "$(YELLOW)⚠ No se encontró 8BP$(BUILD_LEVEL).bin en $(OBJ_DIR) - ejecuta make primero$(NC)"; \
		echo ""; \
		exit 1; \
	fi
	@case $(BUILD_LEVEL) in \
		0) LOAD_ADDR="0x5C30" ;; \
		1) LOAD_ADDR="0x61A8" ;; \
		2) LOAD_ADDR="0x60E0" ;; \
		3) LOAD_ADDR="0x5DC0" ;; \
		4) LOAD_ADDR="0x62D4" ;; \
	esac; \
	$(call dsk-put-bin,$(DSK),8BP$(BUILD_LEVEL).bin,$$LOAD_ADDR,$$LOAD_ADDR)
	@$(MAKE) bas --no-print-directory
	@echo "$(YELLOW)Nota:$(NC) Los archivos >16KB se dividen en múltiples extents (extensiones)"
	@echo "       Cada extent puede contener hasta 128 páginas de datos (16KB)"
	@echo ""


# AÑADIR ARCHIVOS BASIC AL DSK
bas:
	@if [ ! -d "$(BASIC_PATH)" ]; then \
		echo "$(YELLOW)⚠ No existe la carpeta $(BASIC_PATH)$(NC)"; \
		exit 0; \
	fi
	@echo ""
	@echo "$(CYAN)Añadiendo archivos BASIC desde:$(NC) $(BASIC_PATH)"
	@BASIC_COUNT=0; \
	for file in "$(BASIC_PATH)"/*.bas; do \
		if [ -f "$$file" ]; then \
			BASENAME=$$(basename "$$file"); \
			cp "$$file" "$(CURDIR)/$(OBJ_DIR)/$$BASENAME"; \
			if [ $$(tail -c 1 "$(CURDIR)/$(OBJ_DIR)/$$BASENAME" | wc -l) -eq 0 ]; then \
				echo "" >> "$(CURDIR)/$(OBJ_DIR)/$$BASENAME"; \
			fi; \
			$(call dsk-put-ascii,$(DSK),$$BASENAME) && \
			BASIC_COUNT=$$((BASIC_COUNT + 1)); \
		fi; \
	done; \
	if [ $$BASIC_COUNT -eq 0 ]; then \
		echo "$(YELLOW)⚠ No se encontraron archivos .bas en $(BASIC_PATH)$(NC)"; \
	else \
		echo "$(GREEN)✓ $$BASIC_COUNT archivo(s) BASIC añadido(s)$(NC)"; \
	fi
	@echo ""

# EJECUTAR EN RETROVIRTUALMACHINE
run:
	@echo ""
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo "$(BLUE)  🎮 Ejecutar en RetroVirtualMachine$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo ""
	@if [ -z "$(RVM_PATH)" ]; then \
		echo "$(RED)✗ Error: RVM_PATH no está definida$(NC)"; \
		echo "$(YELLOW)Define RVM_PATH en tu Makefile con la ruta a RetroVirtualMachine$(NC)"; \
		exit 1; \
	fi
	@if [ ! -f "$(RVM_PATH)" ]; then \
		echo "$(RED)✗ Error: RetroVirtualMachine no encontrado en: $(RVM_PATH)$(NC)"; \
		exit 1; \
	fi
	@if [ ! -f "$(DIST_DIR)/$(DSK)" ]; then \
		echo "$(RED)✗ Error: DSK no encontrado en $(DIST_DIR)/$(DSK)$(NC)"; \
		echo "$(YELLOW)Ejecuta 'make' primero para compilar y crear el DSK$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)Emulador:$(NC)       $(RVM_PATH)"
	@echo "$(CYAN)Modelo CPC:$(NC)     $(CPC_MODEL)"
	@echo "$(CYAN)DSK:$(NC)            $(DIST_DIR)/$(DSK)"
	@# Matar procesos existentes de RetroVirtualMachine
	@RVM_NAME=$$(basename "$(RVM_PATH)"); \
	if pgrep -f "$$RVM_NAME" > /dev/null 2>&1; then \
		echo "$(YELLOW)⚠ Cerrando sesión anterior de RetroVirtualMachine...$(NC)"; \
		pkill -9 -f "$$RVM_NAME"; \
		sleep 1; \
	fi
	@# Ejecutar RetroVirtualMachine en background
	@if [ -n "$(RUN_FILE)" ]; then \
		echo "$(CYAN)Ejecutando:$(NC)     $(RUN_FILE)"; \
		echo ""; \
		nohup "$(RVM_PATH)" -b=cpc$(CPC_MODEL) -i "$(CURDIR)/$(DIST_DIR)/$(DSK)" -c='run"$(RUN_FILE)\n' > /dev/null 2>&1 & \
	else \
		echo "$(YELLOW)⚠ RUN_FILE no definido, solo se cargará el DSK$(NC)"; \
		echo ""; \
		nohup "$(RVM_PATH)" -b=cpc$(CPC_MODEL) -i "$(CURDIR)/$(DIST_DIR)/$(DSK)" > /dev/null 2>&1 & \
	fi
	@sleep 0.5
	@echo "$(GREEN)✓ RetroVirtualMachine iniciado$(NC)"
	@echo ""
