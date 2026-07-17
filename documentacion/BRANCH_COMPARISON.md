# Comparación Detallada: Rama MAIN vs PAPER

Fecha: 2025-12-28
Autor: Análisis automatizado

## Resumen Ejecutivo

Las ramas **main** y **paper** han divergido significativamente desde su punto común:

- **149 archivos** han cambiado
- **+30,378 líneas** añadidas en paper
- **-11,327 líneas** eliminadas en paper
- **49 commits** únicos en main
- **84 commits** únicos en paper

## Propósito de Cada Rama

### Rama MAIN
Sistema completo de planificación de misiones multi-UAV con:
- API REST (Flask)
- Interfaz web con HTML estático
- Procesamiento en tiempo real
- Sistema de coordenadas completo
- Integración con PX4

**Caso de uso**: Producción, demos, integración con sistemas reales

### Rama PAPER
Implementación para investigación académica y computación distribuida:
- Código core del solver (simplificado)
- Procesamiento distribuido con Dask/Tornado
- Casos de prueba extensivos (80+ mapas TSPLIB)
- Análisis de datos científicos (Zarr, Xarray, Scikit-image)
- Sin interfaz web activa (fue eliminada del historial)
- Enfoque en algoritmos y benchmarking

**Nota histórica**: La rama paper TUVO una Web API (commits ea60144-8a79185) que fue eliminada posteriormente para simplificar el código de investigación.

**Caso de uso**: Publicaciones, benchmarks, experimentos académicos, computación de alto rendimiento

---

## Diferencias en Arquitectura

### Estructura de Módulos

#### MAIN (14 módulos)
```
modules/
├── bases.py          (252 líneas)
├── coordinates.py    (871 líneas) ❌ No en paper
├── dubins.py         (362 líneas) ❌ No en paper
├── solver.py         (2373+ líneas)
├── towers.py         (277 líneas) ❌ No en paper
├── uav.py            (1101 líneas) ❌ No en paper
├── waypoints.py      (123 líneas) ❌ No en paper
├── weather.py        (162 líneas) ❌ No en paper
├── weights.py        (261 líneas) ❌ No en paper
├── yaml.py           (496 líneas) ❌ No en paper
└── simulation.py     (69 líneas) ❌ No en paper
```

#### PAPER (6 módulos)
```
modules/
├── bases.py          (simplificado)
├── solver.py         (~1400 líneas, refactorizado)
├── files.py          (234 líneas) ✅ Nuevo
├── tasks.py          (220 líneas) ✅ Nuevo
└── uavs.py           (205 líneas) ✅ Nuevo
```

### Archivos Principales

#### MAIN
- `api.py` - API Flask completa (281 líneas)
- `main_flow.py` - Flujo de prueba (70 líneas)
- `server_linux.sh` - Script de servidor
- `Dockerfile` - Containerización

#### PAPER
- `main.py` - Punto de entrada principal (108 líneas) ✅ Nuevo
- `hilbert_gen.py` - Generador de curvas Hilbert ✅ Nuevo
- `plot_towers_bases.py` - Visualización ✅ Nuevo
- `results_gen.py` - Generador de resultados ✅ Nuevo
- `tsp_map.py` - Mapas TSP ✅ Nuevo

---

## Funcionalidades Comparadas

### Características Únicas de MAIN

1. **API REST Completa**
   - Endpoints: `/`, `/status`, `/uav_database`, `/mission_request`, `/get_plan`
   - CORS habilitado
   - Procesamiento asíncrono con threading

2. **Sistema de Coordenadas**
   - Conversiones UTM completas
   - Soporte para múltiples EPSG (3035, 4326, etc.)
   - Cálculos geodésicos precisos

3. **Simulación Dubins**
   - Cálculo de trayectorias curvas
   - Optimización de rutas para vehículos no-holonómicos

4. **Gestión de UAVs Detallada**
   - Modelos específicos con parámetros físicos
   - Base de datos de dispositivos (devices.yaml)
   - Cálculo de consumo energético detallado

5. **Integración PX4**
   - Generación de waypoints para PX4
   - Formato de misión compatible
   - Gestión de alturas de seguridad

6. **Clima y Viento**
   - Modelo de viento
   - Ajuste de trayectorias por condiciones climáticas

### Características Únicas de PAPER

1. **Restricciones de Precedencia**
   - Implementación completa de orden de tareas
   - Basado en MTZ (Miller-Tucker-Zemlin)
   - Restricciones one-by-one

2. **Ventanas de Tiempo (Wait Time)**
   - Tareas con tiempos de espera
   - Sincronización de UAVs

3. **Tareas Personalizadas**
   - Sistema genérico de tareas no relacionadas con inspección
   - Flexibilidad para diferentes escenarios

4. **Múltiples Funciones de Costo**
   - Minimizar tiempo total
   - Minimizar máximo tiempo por trabajador
   - Balanceo de carga
   - Límites de costo por trabajador

5. **Modelo de Trabajador Humano**
   - Simulación de operadores humanos
   - Integración con UAVs

6. **Casos de Prueba Extensivos**
   - 80+ archivos de casos de prueba
   - Mapas TSPLIB estándar
   - Benchmarks reproducibles

---

## Cambios en Dependencias

### Dependencias Eliminadas en PAPER
- **Flask** - API web (sustituido por enfoque offline)
- **Flask-CORS** - CORS para API
- **PyQt6** (y dependencias relacionadas) - Interfaz gráfica
- **Muchos paquetes de linting/testing** - Flake8, pylint, pytest plugins, etc.

### Dependencias NUEVAS en PAPER (Computación Científica)

**Procesamiento Distribuido**:
- `dask==2024.10.0` - Computación paralela
- `distributed==2024.10.0` - Cluster computing
- `tornado==6.4.1` - Framework asíncrono (usado por Dask)

**Análisis de Datos Científicos**:
- `xarray==2024.10.0` - Arrays multidimensionales etiquetados
- `zarr==2.15.0` - Almacenamiento chunked arrays
- `ome-zarr==0.9.0` - Formato OME para imágenes
- `scikit-image==0.24.0` - Procesamiento de imágenes
- `pandas==2.2.3` - Análisis de datos

**Procesamiento de Imágenes**:
- `aicsimageio==4.14.0` - I/O de imágenes científicas
- `imageio==2.36.0` - Lectura/escritura de imágenes
- `imagecodecs==2024.9.22` - Codecs de imágenes
- `tifffile==2023.2.28` - Archivos TIFF

**Cloud Storage**:
- `s3fs==2023.6.0` - Sistema de archivos S3
- `aiobotocore==2.5.4` - Cliente async para AWS

**Otros**:
- `numba==0.60.0` - JIT compiler para Python
- `llvmlite==0.43.0` - LLVM para Numba
- `numpy-hilbert-curve==1.0.1` - Curvas de Hilbert
- `graphviz==0.20.3` - Visualización de grafos

### Dependencias Mantenidas (Actualizadas)
- **PySCIPOpt** 5.1.1 → 5.2.1 (solver MILP)
- **NumPy** 1.26.3 → 2.0.2
- **SciPy** 1.11.4 → 1.14.1
- **Matplotlib** 3.8.2 → 3.9.2
- **PyYAML** 6.0.1 → 6.0.2
- **NetworkX** 3.2.1 → 3.4.2

### ¿Por qué Tornado en PAPER?

**Tornado NO se usa para interfaz web**, sino como dependencia de Dask:
- **Dask** requiere Tornado para su sistema de comunicación distribuida
- Permite ejecutar el solver en múltiples workers en paralelo
- Ideal para procesar los 80+ casos de prueba simultáneamente
- Comunicación asíncrona entre nodos del cluster

---

## Mapas y Casos de Prueba

### MAIN
- Pocos casos de prueba (~10)
- Mapas en formato KML
- Archivos traducidos en `files/translated/`

### PAPER
- 80+ casos de prueba
- Mapas TSPLIB estándar (.vrp)
- Series organizadas:
  - **ATLAS**: 14 casos (EASY, TOOMANY, U1T13, etc.)
  - **EIL**: 30+ variaciones (eil22, eil23, eil30, eil33, eil51)
  - **ATT**: 5 variaciones (att48)
  - **HILBERT**: 2 casos (U1S63, U2S63)
  - **OSLO**: Caso real
  - **GUITAR_ASSEMBLY**: Caso personalizado

---

## Cambios en solver.py

El archivo `modules/solver.py` tiene cambios masivos:

### MAIN
- ~2373 líneas
- Solver completo con todas las funcionalidades
- Integración con todos los módulos

### PAPER
- ~1400 líneas (reducción del 41%)
- Enfoque en core algorítmico
- Código más limpio y documentado
- Nuevas features:
  - Precedence constraints
  - Wait time
  - Multiple cost functions
  - Cost limits per worker

---

## Commits Destacados

### Commits Importantes en PAPER
1. `acda0e2` - New Cost limit per worker
2. `cced527` - Human model
3. `ec121cf` - Precedence constraints fully implemented
4. `c01a0b4` - First implementation (punto de divergencia)

### Commits Importantes en MAIN
1. `a25a45e` - Update README.md (HEAD actual)
2. `528b642` - Added Dockerfile
3. `6ac6614` - New cost function
4. `c8ee7c5` - Merge cost-function branch

---

## Recomendaciones

### ¿Cuándo usar MAIN?
- Despliegue en producción
- Demos para clientes
- Integración con PX4
- Interfaz web necesaria
- APIs REST necesarias

### ¿Cuándo usar PAPER?
- Investigación académica
- Publicaciones científicas
- Benchmarking
- Experimentos con nuevos algoritmos
- Testing de casos extremos

### ¿Merge entre ramas?
**⚠️ PRECAUCIÓN**: Las ramas son muy diferentes. No se recomienda merge directo.

**Opciones**:
1. **Cherry-pick selectivo**: Traer commits específicos
2. **Port manual**: Reimplementar características específicas
3. **Mantener separadas**: Usar cada rama para su propósito

### Cherry-picking de PAPER a MAIN
```bash
# Ejemplo: traer funcionalidad de precedence constraints
git checkout main
git cherry-pick <commit-hash>
```

### Port de características específicas
```bash
# Ver diferencia de un archivo específico
git diff main..origin/paper -- modules/solver.py

# Aplicar cambios manualmente
```

---

## Comandos Útiles

### Comparar archivos específicos
```bash
git diff main..origin/paper -- modules/solver.py
git diff main..origin/paper -- modules/bases.py
```

### Ver historial visual
```bash
git log --oneline --graph --all --decorate -30
```

### Listar archivos diferentes
```bash
# Archivos nuevos en paper
git diff main..origin/paper --name-only --diff-filter=A

# Archivos eliminados en paper
git diff main..origin/paper --name-only --diff-filter=D

# Archivos modificados
git diff main..origin/paper --name-only --diff-filter=M
```

### Usar el script de comparación
```bash
./compare_branches.sh summary
./compare_branches.sh modules
./compare_branches.sh python
./compare_branches.sh diff modules/solver.py
```

---

## Conclusión

Las ramas MAIN y PAPER representan dos enfoques diferentes del mismo proyecto:

- **MAIN**: Sistema completo, orientado a producción
- **PAPER**: Investigación académica, algoritmos core

Ambas son valiosas y deben mantenerse por separado, usando cada una para su propósito específico.
