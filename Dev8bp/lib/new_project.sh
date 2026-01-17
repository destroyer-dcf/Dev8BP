#!/usr/bin/env bash
# ==============================================================================
# new_project.sh - Crear nuevo proyecto
# ==============================================================================

new_project() {
    local project_name="$1"
    
    if [[ -z "$project_name" ]]; then
        error "Debes especificar un nombre para el proyecto"
        echo ""
        echo "Uso: dev8bp new <nombre>"
        echo ""
        echo "Ejemplo:"
        echo "  dev8bp new mi-juego"
        exit 1
    fi
    
    # Validar nombre
    if [[ ! "$project_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        error "El nombre del proyecto solo puede contener letras, números, guiones y guiones bajos"
        exit 1
    fi
    
    # Verificar que no existe
    if [[ -d "$project_name" ]]; then
        error "El directorio '$project_name' ya existe"
        exit 1
    fi
    
    header "Crear Nuevo Proyecto"
    
    info "Nombre del proyecto: $project_name"
    echo ""
    
    # Crear estructura
    step "Creando estructura de directorios..."
    mkdir -p "$project_name"/{ASM,bas,obj,dist,raw,assets/sprites}
    success "Directorios creados"
    
    # Crear README en assets/sprites
    step "Creando guía de sprites..."
    cat > "$project_name/assets/sprites/README.md" << 'SPRITES_EOF'
# Sprites

Coloca aquí tus archivos PNG para convertirlos automáticamente a ASM.

## Configuración

Edita `dev8bp.conf` y descomenta estas líneas:

```bash
SPRITES_PATH="assets/sprites"
MODE=0
SPRITES_OUT_FILE="ASM/sprites.asm"
SPRITES_TOLERANCE=8
```

## Requisitos de los PNG

### Ancho
- **Modo 0**: múltiplo de 2 píxeles (2, 4, 6, 8, 10, 12, 14, 16...)
- **Modo 1**: múltiplo de 4 píxeles (4, 8, 12, 16, 20...)
- **Modo 2**: múltiplo de 8 píxeles (8, 16, 24, 32...)

### Colores
- **Modo 0**: máximo 16 colores
- **Modo 1**: máximo 4 colores
- **Modo 2**: máximo 2 colores

### Paleta CPC
Usa colores de la paleta Amstrad CPC o cercanos (con tolerancia).

## Uso

```bash
# 1. Coloca tus PNG aquí
cp /ruta/a/sprites/*.png assets/sprites/

# 2. Compila
dev8bp build

# 3. El archivo ASM/sprites.asm se genera automáticamente
```

## Estructura Recomendada

```
assets/sprites/
├── player.png
├── enemies/
│   ├── enemy1.png
│   └── enemy2.png
└── tiles/
    ├── tile1.png
    └── tile2.png
```

## Más Información

https://github.com/destroyer-dcf/Dev8BP#-conversión-de-gráficos-png-a-asm
SPRITES_EOF
    success "Guía de sprites creada"
    
    # Crear configuración
    step "Creando archivo de configuración..."
    local config_content=$(cat "$DEV8BP_CLI_ROOT/templates/project.conf")
    config_content="${config_content//\{\{PROJECT_NAME\}\}/$project_name}"
    echo "$config_content" > "$project_name/dev8bp.conf"
    success "dev8bp.conf creado"
    
    # Crear README
    step "Creando README..."
    cat > "$project_name/README.md" << EOF
# $project_name

Proyecto creado con Dev8BP CLI.

## Estructura

\`\`\`
$project_name/
├── dev8bp.conf      # Configuración del proyecto
├── ASM/             # Código ensamblador 8BP
├── bas/             # Archivos BASIC
├── assets/          # Recursos del proyecto
│   └── sprites/     # Sprites PNG (se convierten a ASM automáticamente)
├── obj/             # Archivos intermedios (generado)
└── dist/            # Imagen DSK final (generado)
\`\`\`

## Uso

\`\`\`bash
# Compilar
dev8bp build

# Limpiar
dev8bp clean

# Ejecutar en emulador
dev8bp run

# Ver configuración
dev8bp info
\`\`\`

## Configuración

Edita \`dev8bp.conf\` para configurar tu proyecto:
- Nivel de compilación (BUILD_LEVEL)
- Rutas de código (ASM_PATH, BASIC_PATH, etc.)
- Configuración del emulador

## Documentación

https://github.com/destroyer-dcf/Dev8BP
EOF
    success "README.md creado"
    
    # Crear .gitignore
    step "Creando .gitignore..."
    cat > "$project_name/.gitignore" << EOF
# Archivos generados
obj/
dist/
*.bin
*.lst
*.map
*.ihx
*.lk
*.noi
*.rel
*.sym

# ASM generados automáticamente (sprites)
ASM/sprites.asm

# Backups
*.backup
*.backup_build
*.bak
*.BAK

# Sistema
.DS_Store
Thumbs.db
EOF
    success ".gitignore creado"
    
    echo ""
    success "Proyecto '$project_name' creado exitosamente!"
    echo ""
    
    info "Próximos pasos:"
    echo ""
    echo "  1. cd $project_name"
    echo "  2. Edita dev8bp.conf según tus necesidades"
    echo "  3. Añade tu código en ASM/, bas/, etc."
    echo "  4. dev8bp build"
    echo ""
    
    info "Para más ayuda: dev8bp help"
    echo ""
}
