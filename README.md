# BUILD8BP - Makefile

Sistema de compilación automatizado para proyectos 8BP usando GNU Make.

## Características

- ✅ Configuración mediante variables de entorno
- ✅ Múltiples niveles de compilación (0-4)
- ✅ Conversión automática a UTF-8
- ✅ Aplicación de parches de sintaxis
- ✅ Compilación de todos los niveles con un comando
- ✅ Binarios organizados en carpeta `dist/`
- ✅ No modifica archivos originales

## Uso rápido

```bash
# Ver ayuda
make help

# Compilar con configuración por defecto (nivel 0)
make all

# Compilar nivel específico
make 8bp2

# Compilar todos los niveles (0-4)
make build-all

# Solo parchear archivos (incluye conversión a UTF-8)
make patch

# Limpiar archivos temporales y dist
make clean
```

## Variables de configuración

| Variable | Descripción | Por defecto |
|----------|-------------|-------------|
| `8BP_ASM_PATH` | Ruta al directorio ASM | `./8BP_V43/ASM` |
| `ABASM_PATH` | Ruta a abasm.py | `./abasm/src/abasm.py` |
| `DIST_DIR` | Directorio de salida | `./dist` |

## Niveles de compilación

| Nivel | Descripción | Memoria BASIC | Comandos |
|-------|-------------|---------------|----------|
| 0 | Todas las funcionalidades | 23600 | \|LAYOUT, \|COLAY, \|MAP2SP, \|UMA, \|3D |
| 1 | Juegos de laberintos | 25000 | \|LAYOUT, \|COLAY |
| 2 | Juegos con scroll | 24800 | \|MAP2SP, \|UMA |
| 3 | Juegos pseudo-3D | 24000 | \|3D |
| 4 | Sin scroll/layout | 25500 | Básicos |

## Ejemplos

### Compilar proyecto específico

```bash
make all 8BP_ASM_PATH=/ruta/mi_proyecto/ASM ABASM_PATH=/ruta/abasm/src/abasm.py
```

### Compilar nivel 2 (scroll)

```bash
make 8bp2
```

### Compilar todos los niveles

```bash
make build-all 8BP_ASM_PATH=./8BP_V43/ASM
```

### Usar con proyecto específico

Crea un `Makefile` en tu proyecto:

```makefile
# Incluir Makefile principal
include ../Makefile

# Configuración del proyecto
8BP_ASM_PATH := ./ASM
ABASM_PATH := ../../abasm/src/abasm.py
BUILD_LEVEL := 1
```

Luego ejecuta:

```bash
make all
```

### Workflow completo

```bash
# 1. Parchear archivos (incluye conversión a UTF-8)
make patch

# 2. Compilar nivel 2
make 8bp2

# O hacer todo con nivel por defecto (0):
make all
```

## Targets disponibles

| Target | Descripción |
|--------|-------------|
| `help` | Mostrar ayuda |
| `info` | Mostrar configuración actual |
| `patch` | Convertir a UTF-8 y aplicar parches de sintaxis |
| `all` | Ejecutar patch + compilar nivel 0 (por defecto) |
| `build-all` | Compilar todos los niveles (0-4) |
| `8bp0` a `8bp4` | Compilar nivel específico (ej: `make 8bp2`) |
| `clean` | Limpiar archivos temporales y dist |
| `check` | Verificar configuración |

## Variables de entorno

También puedes usar variables de entorno:

```bash
export 8BP_ASM_PATH=./8BP_V43/ASM
export ABASM_PATH=./abasm/src/abasm.py

make all
```

## Estructura de archivos

```
proyecto/
├── Makefile              # Makefile principal (este archivo)
├── Makefile.example      # Ejemplo de configuración
├── patch_asm.sh          # Script de parches
├── convert_to_utf8.sh    # Script de conversión
├── compile_asm.sh        # Script de compilación
├── dist/                 # Binarios generados
│   ├── 8BP0.bin
│   ├── 8BP1.bin
│   └── ...
└── 8BP_V43/
    └── ASM/              # Archivos fuente
```

## Solución de problemas

### Error: Directorio ASM no existe

```bash
make check  # Verificar configuración
make info   # Ver rutas actuales
```

### Error de encoding o sintaxis (and a,, djnz,, etc.)

```bash
make patch  # Convertir a UTF-8 y aplicar parches
```

### Limpiar y volver a compilar

```bash
make clean
make all
```

## Integración con CI/CD

### GitHub Actions

```yaml
name: Build 8BP

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.x'
      
      - name: Build all levels
        run: make build-all
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v2
        with:
          name: binaries
          path: dist/*.bin
```

## Licencia

MIT
