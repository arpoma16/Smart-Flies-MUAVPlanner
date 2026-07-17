# Guía de Uso - Rama PAPER

## ¿Cómo se usa la rama PAPER sin interfaz web?

La rama `paper` se usa mediante **scripts Python de línea de comandos** que procesan archivos JSON con casos de prueba y generan visualizaciones con Matplotlib.

---

## Arquitectura de Uso

```
┌─────────────────────────────────────────────────────┐
│           FLUJO DE TRABAJO EN PAPER                 │
└─────────────────────────────────────────────────────┘

1. Preparar caso de prueba (JSON)
   ↓
2. Ejecutar script Python
   ↓
3. El solver procesa el problema
   ↓
4. Se generan resultados
   ↓
5. Visualización con Matplotlib (ventanas gráficas)
   ↓
6. Guardar/analizar resultados
```

---

## Scripts Principales

La rama `paper` incluye 5 scripts principales:

### 1. `main.py` - Script Principal de Resolución

**Propósito**: Resolver un caso de prueba y visualizar resultados

**Uso**:
```bash
# Cambiar a la rama paper
git checkout paper

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar (editar main.py para cambiar el archivo)
python main.py
```

**Contenido de main.py**:
```python
from modules import bases as BA, tasks as TS, uavs as UAVS, solver as SO, files as F
import matplotlib.pyplot as plt

# 1. CARGAR PROBLEMA desde JSON
problem = F.load_Problem_from_File("./files/OSLO.json")

# 2. OBTENER COMPONENTES
bases = problem.get_Bases()
towers = problem.get_Towers()
tasks = problem.get_Tasks()
uav_team = problem.get_UAVs()

# 3. IMPRIMIR INFORMACIÓN
uav_team.print()
tasks.print()

# 4. RESOLVER PROBLEMA
routes = problem.solve(
    dynamic=False,              # Solver estático
    auto_uav_disabling=False,   # No deshabilitar UAVs
    cost_function="mtm"         # Minimize the maximum
)

# 5. PROCESAR Y VISUALIZAR RUTAS
# ... código de visualización ...

# 6. MOSTRAR GRÁFICOS
plt.show()
```

**Para usar con otro caso**:
```python
# Editar la línea 7 de main.py:
problem = F.load_Problem_from_File("./files/eil51.json")
# O cualquier otro archivo de files/
```

### 2. `plot_towers_bases.py` - Visualizar Mapas

**Propósito**: Ver solo las torres y bases de un caso (sin resolver)

**Uso**:
```bash
python plot_towers_bases.py
```

**Código**:
```python
from modules import files as F
import matplotlib.pyplot as plt

# Cargar problema
problem = F.load_Problem_from_File("./files/eil51.json")

# Obtener bases y torres
bases = problem.get_Bases()
towers = problem.get_Towers()

# Plotear
fig = plt.figure()
axes = fig.add_subplot(111)
towers.plot(axes)
bases.plot(axes)

plt.show()
```

**Personalizar**:
```python
# Cambiar archivo en línea 5
problem = F.load_Problem_from_File("./files/ATLAS_EASY.json")
```

### 3. `results_gen.py` - Generar Redes Aleatorias

**Propósito**: Crear grafos aleatorios de redes eléctricas (PLN)

**Uso**:
```bash
python results_gen.py
```

**Código**:
```python
from modules import files as F
import networkx as nx
import matplotlib.pyplot as plt

# Generar red aleatoria
n_towers = 10        # Número de torres
p_connections = 0.001  # Probabilidad de conexión

G = F.generate_random_PLN(n_towers, p_connections)

# Visualizar
pos = nx.planar_layout(G, 200, [0, 0])
nx.draw_networkx(G, pos=pos)
plt.show()
```

**Personalizar**:
```python
n_towers = 20        # Más torres
p_connections = 0.01  # Más conexiones
```

### 4. `hilbert_gen.py` - Generar Mapas con Curvas de Hilbert

**Propósito**: Crear casos de prueba basados en curvas de Hilbert

**Uso**:
```bash
python hilbert_gen.py
```

**Código**:
```python
from modules import files as F

# Generar mapa Hilbert
F.gen_Hilbert_Map(
    num_dims=2,    # 2D
    num_bits=3,    # 2^(3*2) = 64 puntos máximo
    d_towers=150   # Distancia entre torres (metros)
)
```

**Resultado**: Crea archivos JSON en `files/` con torres organizadas según una curva de Hilbert.

### 5. `tsp_map.py` - Convertir Mapas TSP

**Propósito**: Convertir archivos .vrp (TSPLIB) a formato JSON

**Uso**:
```bash
python tsp_map.py
```

---

## Formato de Archivos JSON

Los casos de prueba se definen en archivos JSON con esta estructura:

### Ejemplo Mínimo

```json
{
    "Bases": {
        "B1": [100.0, 200.0, 50.0]
    },
    "UAVs": {
        "UAV1": {
            "Model": "DJI_Matrice",
            "Base": "B1"
        }
    },
    "Towers": {
        "List": {
            "T1": [150.0, 250.0, 30.0],
            "T2": [200.0, 300.0, 35.0]
        },
        "Lines": {}
    },
    "Tasks": {
        "Task1": {
            "inspection_of": "T1"
        },
        "Task2": {
            "inspection_of": "T2"
        }
    }
}
```

### Ejemplo Avanzado (OSLO.json)

```json
{
    "Bases": {
        "B": [4091763.3267208, 4361545.4235238, 64.28099823]
    },
    "UAVs": {
        "Day1": {
            "Model": "Human",
            "Base": "B"
        },
        "Day2": {
            "Model": "Human",
            "Base": "B",
            "Max Cost": 7500
        }
    },
    "Wind": [0, 0, 0],
    "Towers": {
        "List": {
            "P2": [4097092.87, 4364699.73, 152.92],
            "P3": [4096422.21, 4358273.48, 371.33]
        },
        "Lines": {}
    },
    "Tasks": {
        "T1": {
            "inspection_of": "P2"
        },
        "T2": {
            "inspection_of": "P3",
            "incompatible_IDs": ["T1"]
        }
    },
    "Tasks_Order": [
        ["T1", "T2"]
    ],
    "Tasks_Precedence": [
        ["T1", "T2"]
    ]
}
```

### Campos Principales

| Campo | Descripción | Obligatorio |
|-------|-------------|-------------|
| `Bases` | Diccionario de bases con coordenadas [x, y, z] | ✅ Sí |
| `UAVs` | UAVs con modelo y base asignada | ✅ Sí |
| `Towers.List` | Torres con coordenadas [x, y, z] | ✅ Sí |
| `Towers.Lines` | Líneas eléctricas entre torres | ❌ No |
| `Tasks` | Tareas de inspección | ✅ Sí |
| `Wind` | Vector de viento [x, y, z] | ❌ No |
| `Tasks_Order` | Orden de tareas | ❌ No |
| `Tasks_Precedence` | Precedencias entre tareas | ❌ No |

### Características Avanzadas

#### Modelo Humano
```json
"UAVs": {
    "Worker1": {
        "Model": "Human",
        "Base": "B1",
        "Max Cost": 7500  // Tiempo máximo por día
    }
}
```

#### Tareas con Incompatibilidades
```json
"Tasks": {
    "T1": {
        "inspection_of": "Tower1",
        "incompatible_IDs": ["T2", "T3"]  // No pueden hacerse juntas
    }
}
```

#### Inspección de Línea
```json
"Tasks": {
    "LineInspection": {
        "inspection_of": ["Tower1", "Tower2"]  // Inspección entre dos torres
    }
}
```

#### Tarea Personalizada
```json
"Tasks": {
    "CustomTask": {
        "custom_task_at": [100.0, 200.0, 50.0],
        "duration": 300,  // segundos
        "wait_time": 60   // tiempo de espera
    }
}
```

#### Precedencias
```json
"Tasks_Precedence": [
    ["T1", "T2"],  // T1 debe completarse antes que T2
    ["T2", "T3"]   // T2 debe completarse antes que T3
]
```

---

## Funciones de Costo Disponibles

Al resolver el problema, puedes especificar diferentes funciones objetivo:

```python
routes = problem.solve(
    dynamic=False,
    auto_uav_disabling=False,
    cost_function="mtm"  # ← Cambiar aquí
)
```

### Opciones de `cost_function`:

| Valor | Descripción | Uso |
|-------|-------------|-----|
| `"mtt"` | **Minimize Total Time** - Minimiza tiempo total | Eficiencia global |
| `"mtm"` | **Minimize The Maximum** - Minimiza el máximo tiempo por trabajador | Balanceo de carga |
| `"mte"` | **Minimize Total Energy** - Minimiza energía total | Ahorro energético |
| `"mtc"` | **Minimize Total Cost** - Minimiza costo total | Optimización económica |

---

## Procesamiento por Lotes (Batch)

Para procesar múltiples casos de prueba, puedes crear un script personalizado:

### `batch_process.py` (crear este archivo)

```python
import glob
from modules import files as F
import json

# Obtener todos los archivos JSON
casos = glob.glob("./files/eil*.json")

resultados = {}

for caso_file in casos:
    print(f"\nProcesando: {caso_file}")

    # Cargar y resolver
    problem = F.load_Problem_from_File(caso_file)

    try:
        routes = problem.solve(
            dynamic=False,
            auto_uav_disabling=False,
            cost_function="mtm"
        )

        # Guardar resultado
        resultados[caso_file] = {
            "status": "solved",
            "routes": routes
        }

    except Exception as e:
        resultados[caso_file] = {
            "status": "failed",
            "error": str(e)
        }

# Guardar resultados
with open("resultados_batch.json", "w") as f:
    json.dump(resultados, f, indent=2)

print("\n✅ Procesamiento completado")
```

**Ejecutar**:
```bash
python batch_process.py
```

---

## Procesamiento Paralelo con Dask

Para aprovechar Dask y procesar casos en paralelo:

### `parallel_solve.py` (crear este archivo)

```python
from dask.distributed import Client
from modules import files as F
import glob

def solve_case(file_path):
    """Resolver un caso individual"""
    problem = F.load_Problem_from_File(file_path)
    routes = problem.solve(
        dynamic=False,
        auto_uav_disabling=False,
        cost_function="mtm"
    )
    return {
        "file": file_path,
        "routes": routes
    }

# Iniciar cluster Dask con 4 workers
client = Client(n_workers=4, threads_per_worker=2)

print(f"Dashboard: {client.dashboard_link}")

# Obtener casos
casos = glob.glob("./files/*.json")

print(f"Procesando {len(casos)} casos en paralelo...")

# Procesar en paralelo
futures = client.map(solve_case, casos)
resultados = client.gather(futures)

print(f"✅ Completados {len(resultados)} casos")

# Cerrar cluster
client.close()
```

**Ejecutar**:
```bash
python parallel_solve.py
```

**Ventajas**:
- 🚀 Procesamiento paralelo
- 📊 Dashboard web en `http://localhost:8787`
- 💾 Manejo eficiente de memoria

---

## Visualización de Resultados

### Personalizar Gráficos

```python
import matplotlib.pyplot as plt
from modules import files as F

problem = F.load_Problem_from_File("./files/OSLO.json")

# Resolver
routes = problem.solve(dynamic=False, cost_function="mtm")

# Crear figura personalizada
fig = plt.figure(figsize=(12, 8))
axes = fig.add_subplot(111)

# Plotear componentes
problem.get_Towers().plot(axes)
problem.get_Bases().plot(axes)

# Personalizar
axes.set_title("Solución Óptima - OSLO", fontsize=16)
axes.set_xlabel("X [m]", fontsize=14)
axes.set_ylabel("Y [m]", fontsize=14)
axes.grid(True, alpha=0.3)

# Guardar
plt.savefig("solucion_oslo.png", dpi=300, bbox_inches='tight')

# Mostrar
plt.show()
```

---

## Casos de Prueba Disponibles

La rama `paper` incluye 80+ casos organizados:

### Por Tamaño (TSPLIB)

| Prefijo | Torres | Variaciones | Ejemplo |
|---------|--------|-------------|---------|
| `eil22` | 22 | 7 | `eil22.json`, `eil22_NCOE.json` |
| `eil23` | 23 | 6 | `eil23_OC.json`, `eil23_PC.json` |
| `eil30` | 30 | 6 | `eil30.json` |
| `eil33` | 33 | 7 | `eil33_U2NCOE_OC.json` |
| `eil51` | 51 | 6 | `eil51.json` |
| `att48` | 48 | 5 | `att48_NCOE_PC.json` |

### Por Tipo de Caso

| Serie | Descripción | Archivos |
|-------|-------------|----------|
| **ATLAS** | Casos específicos | 14 archivos (EASY, TOOMANY, U1T13...) |
| **HILBERT** | Curvas de Hilbert | 2 archivos (U1S63, U2S63) |
| **OSLO** | Caso real (Noruega) | 1 archivo |
| **GUITAR** | Ensamblaje tipo guitarra | 1 archivo |
| **Y_T9U3** | Caso Y con 9 torres, 3 UAVs | 1 archivo |

### Sufijos de Variación

- `_NCOE` - No Cost of Edge (sin costo de aristas)
- `_OC` - Order Constraints (con orden)
- `_PC` - Precedence Constraints (con precedencias)
- `_U2`, `_U3`, `_U4` - Número de UAVs

---

## Flujo de Trabajo Típico para Investigación

### 1. Exploración Inicial
```bash
# Ver un mapa
python plot_towers_bases.py  # Editar para cambiar archivo

# Resolver caso simple
python main.py  # Editar para cambiar archivo
```

### 2. Experimentación
```python
# Crear script experimento.py
from modules import files as F

casos = ["eil22.json", "eil23.json", "eil30.json"]
funciones = ["mtt", "mtm", "mte"]

for caso in casos:
    for func in funciones:
        problem = F.load_Problem_from_File(f"./files/{caso}")
        routes = problem.solve(cost_function=func)
        # Guardar/analizar resultados
```

### 3. Benchmarking a Gran Escala
```bash
# Usar Dask para procesar todos los casos
python parallel_solve.py
```

### 4. Análisis de Resultados
```python
import pandas as pd
import matplotlib.pyplot as plt

# Cargar resultados
df = pd.read_json("resultados_batch.json")

# Análisis estadístico
# ...

# Visualizar
plt.figure()
df.plot(kind='bar')
plt.show()
```

---

## Diferencias con MAIN

| Aspecto | MAIN | PAPER |
|---------|------|-------|
| **Interfaz** | Web (Flask) | CLI + Matplotlib |
| **Input** | POST JSON vía API | Archivos JSON locales |
| **Ejecución** | Servidor continuo | Scripts one-shot |
| **Visualización** | HTML estático | Matplotlib interactivo |
| **Paralelización** | Threading | Dask cluster |
| **Output** | JSON vía API | Gráficos + archivos |
| **Uso** | Demos, producción | Investigación, papers |

---

## Migrar de MAIN a PAPER

Si tienes un caso de MAIN y quieres usarlo en PAPER:

### 1. Convertir formato
```python
# MAIN usa formato diferente
# PAPER usa el formato mostrado arriba

# Crear convertidor (ejemplo simplificado)
def main_to_paper(main_json):
    paper_json = {
        "Bases": main_json["bases"],
        "UAVs": main_json["uavs"],
        "Towers": {
            "List": main_json["towers"],
            "Lines": main_json.get("power_lines", {})
        },
        "Tasks": main_json["tasks"]
    }
    return paper_json
```

### 2. Guardar en files/
```python
import json

with open("./files/mi_caso.json", "w") as f:
    json.dump(paper_json, f, indent=2)
```

### 3. Ejecutar
```python
# Editar main.py
problem = F.load_Problem_from_File("./files/mi_caso.json")
```

---

## Enlaces Útiles

- **Paper (Preprint)**: https://arxiv.org/abs/2410.20849
- **Repositorio**: Smart-Flies-MUAVPlanner (rama `paper`)
- **Dask Dashboard**: http://localhost:8787 (cuando ejecutas con Dask)

---

## Resumen Rápido

```bash
# 1. Cambiar a rama paper
git checkout paper

# 2. Instalar dependencias
pip install -r requirements.txt

# 3. Ejecutar script principal
python main.py  # Ver visualización

# 4. Explorar casos
ls files/*.json

# 5. Personalizar
# Editar main.py, cambiar archivo de entrada y función de costo
```

**No hay interfaz web, todo es mediante scripts Python y archivos JSON**. Los resultados se visualizan con Matplotlib en ventanas gráficas interactivas.
