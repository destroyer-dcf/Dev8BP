# Dev8BP

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows%20WSL-lightgrey.svg)]()
[![Python](https://img.shields.io/badge/python-3.x-blue.svg)](https://www.python.org/)
[![ABASM](https://img.shields.io/badge/ABASM-1.4.0%20%20-green.svg)](https://github.com/fragarco/abasm)
[![Amstrad CPC](https://img.shields.io/badge/Amstrad-CPC-red.svg)]()
[![Make](https://img.shields.io/badge/build-Make-orange.svg)]()
[![8BP](https://img.shields.io/badge/8BP-v0.43-purple.svg)](https://github.com/jjaranda13/8BP)

Compilacion [8BP](https://github.com/jjaranda13/8BP) utilizando [ABASM](https://github.com/fragarco/abasm)

## Sistemas

- ✅ Windows (Utilizando MSYS2 MinGW64 o WSL)
- ✅ Linux
- ✅ Mac


## Requisitos

- Python 3.x
- Make
- Git (para submódulos)
- ABASM (incluido como submódulo)

## Instalación

1. Clona el repositorio con submódulos:
```bash
git clone --recurse-submodules https://github.com/tu-usuario/Dev8BP.git
cd Dev8BP
```

2. Si ya clonaste el repositorio sin submódulos:
```bash
git submodule update --init --recursive
```

## Configuración

1. Copia el archivo de ejemplo:
```bash
cp Makefile.example Makefile
```

2. Edita el `Makefile` con la configuración de tu proyecto:
```makefile

# Ruta al directorio ASM del proyecto
8BP_ASM_PATH := ./mi_proyecto/8BP_V43/ASM

# Directorio de salida para los binarios compilados
DIST_DIR := ./mi_proyecto/dist
```

## Uso (Compilación básica)

### Niveles de Compilación

Cada nivel optimiza el código para diferentes tipos de juegos:

| Nivel | Descripción | MEMORY | DIRECTIVA | INICIO | TAMAÑO |
|-------|-------------|--------|--------|---------------------|-----------|
| **8BP0** | Todos los comandos disponibles | Puedes hacer cualquier juego.Todos los comandos disponibles | MEMORY 23599 |23600|19120|
| **8BP1** | juegos de laberintos o de pasar pantallas | No disponibles en este modo: MAP2SP,UMAP,3D|MEMORY 24999 | 25000|17620|
| **8BP2** | Juegos con scroll | No disponibles en este modo: LAYOUT,COLAY,3D|MEMORY 24799 |24800|17820|
| **8BP3** | Juegos pseudo-3D | No disponibles en este modo: LAYOUT,COLAY|MEMORY 23999 |24000|18620|
| **8BP4** | JUEGOS Sin scroll/layout | No disponibles en este modo: LAYOUT,COLAY,3D,MAP2SP,UMAP|MEMORY 25299 |25300|17320|

### Otros comandos

```bash
# Compilar todos los niveles
make build-all

# Mostrar información de configuración
make info

# Limpiar archivos temporales y binarios
make clean

# Mostrar ayuda
make help
```

## 📝 Comandos Make

| Comando | Descripción |
|---------|-------------|
| `make` o `make all` | Muestra info y compila nivel 0 |
| `make help` | Muestra la ayuda completa |
| `make info` | Muestra la configuración actual |
| `make 8bp0` | Compila nivel 0 |
| `make 8bp1` | Compila nivel 1 |
| `make 8bp2` | Compila nivel 2 |
| `make 8bp3` | Compila nivel 3 |
| `make 8bp4` | Compila nivel 4 |
| `make build-all` | Compila todos los niveles (0-4) |
| `make clean` | Limpia archivos temporales y dist |

## 🔧 Variables de Configuración

### Variables Principales

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `8BP_ASM_PATH` | Ruta al directorio ASM | `./8BP_V43/ASM` |
| `DIST_DIR` | Directorio de salida | `./dist` |
| `BUILD_LEVEL` | Nivel de compilación (0-4) | `0` |

### Variables Automáticas

| Variable | Descripción |
|----------|-------------|
| `ABASM_PATH` | Ruta construida automáticamente: `Dev8BP/tools/abasm/src/abasm.py` |
| `PYTHON` | Intérprete Python detectado automáticamente (python3 o python) |

### Ejemplo de Configuración

```makefile
# Usar ABASM versión 1.4.0
ABASM_VERSION := 1.4.0

# Proyecto en ruta personalizada
8BP_ASM_PATH := /Users/usuario/proyectos/mi_juego/ASM

# Salida en carpeta específica
DIST_DIR := /Users/usuario/proyectos/mi_juego/build

# Compilar nivel 2 por defecto
BUILD_LEVEL := 2
```

### Uso desde BASIC

Después de compilar, carga el binario en tu CPC:

```basic
MEMORY 23500
LOAD"8BP0.bin"
CALL &6B78
```

Ajusta el valor de `MEMORY` según el nivel compilado.


## 🕹️ Roadmap

- ✅ Compilación 8BP automatizada con ABASM
- ✅ Generacion niveles de compilación (0-4)
- 📌 Gestion de imagenes (tiles, scr, etc)
- 📌 Generacion DSK
- 📌 Generacion TAP
- 📌 Generacion de ROMs
- 📌 Test/Run Retro Virtual Machine (RVVM)
- 📌 Test/Run M4Board
- 📌 ....más..

---

## 📄 Licencia

MIT License

Copyright (c) 2026 Destroyer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Agradecimientos

- **[jjaranda13](https://github.com/jjaranda13)** - [https://github.com/fragarco/abasm](https://github.com/fragarco/abasm)
- **[fragarco](https://github.com/fragarco)** - [https://github.com/jjaranda13/8BP](https://github.com/jjaranda13/8BP)

## Contacto

© Destroyer 2026 - [Destroyer](mailto:destroyer.dcf@gmail.com)

