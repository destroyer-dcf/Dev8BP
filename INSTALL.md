# Instalación de DevCPC

DevCPC es una herramienta de desarrollo para crear juegos y aplicaciones para Amstrad CPC.

## Instalación Automática

### Linux / macOS

Ejecuta el siguiente comando en tu terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/destroyer-dcf/CPCDevKit/main/install.sh | bash
```

O con `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/destroyer-dcf/CPCDevKit/main/install.sh | bash
```

El instalador:
- Descarga la última versión de DevCPC
- Instala en `~/.DevCPC`
- Configura automáticamente tu shell (bash/zsh)
- Añade DevCPC al PATH

### Después de la instalación

Recarga tu shell:

```bash
source ~/.bashrc  # Para bash
source ~/.zshrc   # Para zsh
```

O simplemente abre una nueva terminal.

Verifica la instalación:

```bash
devcpc version
```

## Instalación Manual

Si prefieres instalar manualmente:

1. Descarga la última versión desde [Releases](https://github.com/destroyer-dcf/CPCDevKit/releases)
2. Extrae el archivo:
   ```bash
   tar -xzf DevCPC-X.Y.Z.tar.gz
   ```
3. Ejecuta el script de instalación:
   ```bash
   cd CPCDevKit
   ./setup.sh
   ```

## Requisitos

- Python 3.x (requerido)
- SDCC (opcional, solo para programación en C)

## Primeros Pasos

```bash
# Crear un nuevo proyecto
devcpc new mi-juego

# Entrar al proyecto
cd mi-juego

# Compilar
devcpc build

# Ejecutar en emulador
devcpc run
```

## Actualización

Para actualizar a la última versión, simplemente ejecuta de nuevo el instalador:

```bash
curl -fsSL https://raw.githubusercontent.com/destroyer-dcf/CPCDevKit/main/install.sh | bash
```

## Desinstalación

```bash
rm -rf ~/.DevCPC
```

Y elimina las líneas de configuración de tu archivo `~/.bashrc` o `~/.zshrc`:

```bash
# DevCPC CLI
export DEVCPC_PATH="$HOME/.DevCPC"
export PATH="$PATH:$DEVCPC_PATH/bin"
```
