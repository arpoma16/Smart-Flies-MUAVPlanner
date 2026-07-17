#!/bin/bash
# Script para comparar las ramas main y paper

echo "=========================================="
echo "  Comparación de Ramas: MAIN vs PAPER"
echo "=========================================="
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función de ayuda
show_help() {
    echo "Uso: $0 [opción]"
    echo ""
    echo "Opciones:"
    echo "  summary    - Resumen general de diferencias"
    echo "  files      - Listar archivos modificados/añadidos/eliminados"
    echo "  modules    - Ver cambios en el directorio modules/"
    echo "  commits    - Historial de commits únicos en cada rama"
    echo "  solver     - Ver diferencias en modules/solver.py"
    echo "  python     - Ver solo archivos Python nuevos/modificados"
    echo "  stats      - Estadísticas detalladas"
    echo "  graph      - Gráfico visual del historial"
    echo "  diff FILE  - Ver diferencias de un archivo específico"
    echo "  help       - Mostrar esta ayuda"
    echo ""
}

# Si no hay argumentos, mostrar ayuda
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    summary)
        echo -e "${BLUE}=== RESUMEN GENERAL ===${NC}"
        git diff main..origin/paper --stat | tail -1
        echo ""
        echo -e "${GREEN}Archivos modificados:${NC}"
        git diff main..origin/paper --name-only --diff-filter=M | wc -l
        echo -e "${GREEN}Archivos nuevos en PAPER:${NC}"
        git diff main..origin/paper --name-only --diff-filter=A | wc -l
        echo -e "${RED}Archivos eliminados en PAPER:${NC}"
        git diff main..origin/paper --name-only --diff-filter=D | wc -l
        ;;

    files)
        echo -e "${GREEN}=== ARCHIVOS NUEVOS EN PAPER ===${NC}"
        git diff main..origin/paper --name-only --diff-filter=A
        echo ""
        echo -e "${RED}=== ARCHIVOS ELIMINADOS EN PAPER ===${NC}"
        git diff main..origin/paper --name-only --diff-filter=D
        echo ""
        echo -e "${YELLOW}=== ARCHIVOS MODIFICADOS ===${NC}"
        git diff main..origin/paper --name-only --diff-filter=M
        ;;

    modules)
        echo -e "${BLUE}=== CAMBIOS EN MÓDULOS (modules/) ===${NC}"
        git diff main..origin/paper --stat -- modules/
        ;;

    commits)
        echo -e "${BLUE}=== COMMITS ÚNICOS EN MAIN ===${NC}"
        git log origin/paper..main --oneline --color
        echo ""
        echo -e "${BLUE}=== COMMITS ÚNICOS EN PAPER ===${NC}"
        git log main..origin/paper --oneline --color
        ;;

    solver)
        echo -e "${BLUE}=== DIFERENCIAS EN modules/solver.py ===${NC}"
        git diff main..origin/paper -- modules/solver.py --stat
        echo ""
        echo "¿Ver el diff completo? (y/n)"
        read -r response
        if [ "$response" = "y" ]; then
            git diff main..origin/paper -- modules/solver.py | less
        fi
        ;;

    python)
        echo -e "${GREEN}=== ARCHIVOS PYTHON NUEVOS EN PAPER ===${NC}"
        git diff main..origin/paper --name-only --diff-filter=A | grep "\.py$"
        echo ""
        echo -e "${YELLOW}=== ARCHIVOS PYTHON MODIFICADOS ===${NC}"
        git diff main..origin/paper --name-only --diff-filter=M | grep "\.py$"
        echo ""
        echo -e "${RED}=== ARCHIVOS PYTHON ELIMINADOS EN PAPER ===${NC}"
        git diff main..origin/paper --name-only --diff-filter=D | grep "\.py$"
        ;;

    stats)
        echo -e "${BLUE}=== ESTADÍSTICAS DETALLADAS ===${NC}"
        git diff main..origin/paper --stat
        ;;

    graph)
        echo -e "${BLUE}=== GRÁFICO DE HISTORIAL ===${NC}"
        git log --oneline --graph --all --decorate -30
        ;;

    diff)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Debes especificar un archivo${NC}"
            echo "Ejemplo: $0 diff modules/solver.py"
            exit 1
        fi
        echo -e "${BLUE}=== DIFERENCIAS EN $2 ===${NC}"
        git diff main..origin/paper -- "$2"
        ;;

    help|--help|-h)
        show_help
        ;;

    *)
        echo -e "${RED}Opción desconocida: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
