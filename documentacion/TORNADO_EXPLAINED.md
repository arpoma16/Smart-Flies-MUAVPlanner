# ¿Por qué Tornado en la Rama PAPER?

## Resumen Rápido

**Tornado** NO se usa para crear una interfaz web en la rama `paper`.

Se incluye como **dependencia de Dask** para permitir **computación distribuida** y procesar los 80+ casos de prueba en paralelo.

---

## La Confusión: Tornado = Web?

Es fácil confundirse porque:
- ✅ **Tornado** es conocido como un framework web asíncrono
- ✅ En la rama **MAIN** sí hay interfaz web (pero usa Flask, no Tornado)
- ❌ En la rama **PAPER** hay Tornado pero NO hay interfaz web

---

## ¿Entonces por qué está Tornado?

### La Cadena de Dependencias

```
PAPER necesita:
    ↓
Procesar 80+ casos de prueba de forma eficiente
    ↓
Usa: Dask (computación paralela en Python)
    ↓
Dask requiere: Tornado (comunicación asíncrona)
    ↓
Resultado: Tornado instalado (pero NO para web)
```

---

## ¿Qué es Dask y cómo usa Tornado?

### Dask en la Rama PAPER

**Dask** es una librería para computación paralela en Python que permite:

1. **Paralelizar cálculos** - Ejecutar solver en múltiples casos simultáneamente
2. **Distribuir trabajo** - Usar múltiples CPUs o máquinas
3. **Manejar grandes datasets** - Procesar datos más grandes que la RAM

### ¿Cómo funciona Dask internamente?

```
┌─────────────────────────────────────────────────────┐
│              ARQUITECTURA DASK                      │
└─────────────────────────────────────────────────────┘

Cliente Python (tu código)
    │
    ├─ Dask Scheduler (orquestador)
    │      ↓
    │  [Usa Tornado para comunicación asíncrona]
    │      ↓
    ├─ Worker 1  ─┐
    ├─ Worker 2   ├─ Procesan casos de prueba
    ├─ Worker 3   │  en paralelo
    └─ Worker N  ─┘

Todos se comunican vía Tornado (HTTP asíncrono)
```

### Ejemplo Práctico en PAPER

Imagina que quieres resolver los 80+ casos TSPLIB:

**SIN Dask** (secuencial):
```python
# Tarda mucho tiempo
for caso in casos_de_prueba:
    resultado = solver.solve(caso)  # ~5 min cada uno
    # Total: 80 casos × 5 min = 400 minutos (6.7 horas)
```

**CON Dask** (paralelo con 8 workers):
```python
import dask
from dask.distributed import Client

# Crear cluster (esto usa Tornado internamente)
client = Client()  # Tornado coordina workers

# Procesar en paralelo
resultados = client.map(solver.solve, casos_de_prueba)
# Total: 80 casos ÷ 8 workers × 5 min = 50 minutos
```

---

## Dependencias Científicas de PAPER

La rama `paper` no es solo para publicaciones, es una **plataforma de investigación de alto rendimiento**:

### Stack Completo

```
┌─────────────────────────────────────────────────────┐
│           STACK CIENTÍFICO DE PAPER                 │
└─────────────────────────────────────────────────────┘

1. COMPUTACIÓN PARALELA
   ├─ Dask        → Paralelización
   ├─ Distributed → Cluster computing
   └─ Tornado     → Comunicación async

2. OPTIMIZACIÓN NUMÉRICA
   ├─ NumPy 2.0   → Arrays rápidos
   ├─ Numba       → JIT compilation (acelera Python)
   ├─ SciPy       → Algoritmos científicos
   └─ PySCIPOpt   → Solver MILP

3. ANÁLISIS DE DATOS
   ├─ Pandas      → DataFrames
   ├─ Xarray      → Arrays multidimensionales
   └─ Zarr        → Almacenamiento eficiente

4. VISUALIZACIÓN
   ├─ Matplotlib  → Gráficos
   ├─ NetworkX    → Visualización de grafos
   └─ Graphviz    → Diagramas

5. PROCESAMIENTO DE IMÁGENES (para casos avanzados)
   ├─ Scikit-image
   ├─ ImageIO
   └─ AICS ImageIO

6. CLOUD (para experimentos grandes)
   ├─ S3FS        → Acceso a Amazon S3
   └─ Aiobotocore → AWS async
```

---

## Comparación: MAIN vs PAPER

### MAIN - Interfaz Web con Flask

```python
# api.py en MAIN
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/mission_request', methods=['POST'])
def mission_request():
    mission = request.get_json()
    # Procesa UNA misión a la vez
    result = solver.solve(mission)
    return jsonify(result)

# Corre en un solo proceso
# Interfaz web para usuarios
```

### PAPER - Computación Distribuida con Dask

```python
# main.py en PAPER (hipotético)
from dask.distributed import Client
import dask.bag as db

# Crear cluster (usa Tornado internamente)
client = Client(n_workers=8)

# Cargar 80 casos de prueba
casos = db.read_text('files/*.json')

# Procesar todos en paralelo
resultados = casos.map(solver.solve).compute()

# Sin interfaz web
# Para investigación y benchmarking
```

---

## Historia: ¿Hubo interfaz web en PAPER?

**SÍ**, pero fue eliminada:

### Commits Históricos (ya no existen en PAPER actual)

1. `ea60144` - "Added basic html webpage"
2. `afebb60` - "UAV Database as a table in the Web"
3. `e68b33f` - "Web API Json Output"
4. `e9ca811` - "Threading for Web API"
5. `8a79185` - "New Web API Output format"

### ¿Por qué se eliminó?

Cuando se creó la rama `paper` para investigación:
- ❌ Se eliminó la API Flask (no necesaria para papers)
- ❌ Se eliminó la interfaz HTML (no necesaria para benchmarks)
- ❌ Se eliminó el Dockerfile (se ejecuta en clusters de investigación)
- ✅ Se añadió Dask para paralelización (necesario para 80+ casos)
- ✅ Se añadieron herramientas científicas (análisis de datos)

---

## Casos de Uso de Cada Rama

### Cuándo usar MAIN

```
Escenarios:
✓ Demo para clientes
✓ Interfaz web necesaria
✓ Procesar pocas misiones
✓ Integración con PX4
✓ Despliegue en servidor
✓ Usuarios no técnicos

Tecnología:
→ Flask (web framework)
→ Threading (paralelización simple)
→ HTML estático
```

### Cuándo usar PAPER

```
Escenarios:
✓ Publicación científica
✓ Benchmark de algoritmos
✓ Procesar 80+ casos
✓ Experimentos paralelos
✓ Análisis de datos
✓ HPC (High Performance Computing)

Tecnología:
→ Dask (computación distribuida)
→ Tornado (usado por Dask)
→ Numba (aceleración)
→ Cluster computing
```

---

## Preguntas Frecuentes

### ¿Puedo usar Tornado para hacer una web en PAPER?

Sí, técnicamente Tornado está instalado, pero:
- No es el propósito de la rama
- Ya tienes MAIN para eso
- Sería duplicar esfuerzo

### ¿Puedo usar Dask en MAIN?

Sí, pero:
- MAIN está optimizado para pocas misiones
- Dask añade complejidad innecesaria
- Threading es suficiente para API web

### ¿Por qué no unir las ramas?

Son propósitos muy diferentes:
- **MAIN**: Producto, usuarios, web
- **PAPER**: Investigación, benchmarks, ciencia

Mantenerlas separadas simplifica cada una.

### ¿Cómo ejecuto experimentos paralelos en PAPER?

```python
from dask.distributed import Client

# Iniciar cluster local con 4 workers
client = Client(n_workers=4)

# Tu código Dask aquí
# ...
```

---

## Conclusión

**Tornado en PAPER** = Dependencia técnica de Dask, NO interfaz web

```
Tornado en MAIN:  ❌ No se usa (tienen Flask)
Tornado en PAPER: ✅ Sí, pero para Dask (no web)
```

La rama `paper` es una **plataforma de investigación científica** que sacrifica la interfaz de usuario a cambio de capacidades de computación de alto rendimiento.
