# Algorithms Pure — Racket

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **Racket**: ordenamientos elementales, estructuras de datos propias, ordenamientos óptimos y distribuidos, y búsqueda.

Los módulos de esta fase trabajan sobre **listas inmutables**, que se recorren por recursión o con `for`, y usan **`#f`** como indicador de fallo, que distingue una entrada nula o inválida de la lista vacía `'()`.

---

## 📂 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`naive_sort/`](naive_sort/) | [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | `raco test -x .` + rackunit | 3 | ✅ |
| [`data_structures_basics/`](data_structures_basics/) | [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) | `raco test -x .` + rackunit | 3 | ✅ |

---

## 📁 Estructura / Structure

```text
algorithms/
├── naive_sort/                      # 05_Naive_Sort
│   ├── naive_sort-lib/              # Código (naive-sort.rkt, 3 funciones)
│   ├── naive_sort-test/tests/       # Suites (24 checks) + contract.rkt
│   ├── naive_sort-doc/              # Documentación (Scribble)
│   ├── Makefile                     # Build estándar de raco new
│   └── README.md
└── data_structures_basics/          # 06_Data_Structures_Basics
    ├── data_structures_basics-lib/  # Código fuente (4 structs, 23 funciones)
    ├── data_structures_basics-test/ # Suites (53 checks)
    ├── data_structures_basics-doc/  # Documentación (Scribble)
    ├── Makefile                     # Build estándar de raco new
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | Racket 9.x (`racket`), intérprete con compilación a bytecode (`raco`) |
| **CLI** | `raco test -x .` desde la raíz del módulo |
| **Andamiaje** | ✅ Layout de cuatro colecciones de `raco new library {module}` (`-lib`, `-test`, `-doc` y agregador), el mismo que usan `naive_sort`, `data_structures_basics`, `numbers` y `calculator`; cada colección lleva su `info.rkt` |
| **Framework de tests** | rackunit, incluida en la distribución estándar (`(require rackunit)`) |
| **Runner** | `raco test -x .`: descubre los archivos con submodule `test` y cuenta sus checks; sin runner manual |
| **Separación** | `{module}-lib/` (código) ↔ `{module}-test/tests/` (suites) |
| **Carga del módulo** | `(require "../../{module}-lib/{modulo}.rkt")` al inicio de la suite, por ruta relativa y sin enlazar paquetes |
| **Modularidad** | `#lang racket` + `(provide …)`; los helpers internos no se exportan |
| **Iteración** | Recursión con `let loop` (Racket garantiza TCO) y bucles `for`/`do` |
| **Mutabilidad** | Las listas son inmutables: los algoritmos copian la entrada a un vector (`list->vector`), ordenan con `vector-set!` y devuelven una lista nueva (`vector->list`) |
| **Naming** | `kebab-case` en el código (`selection-sort`), con el nombre `snake_case` de la especificación conservado en el mensaje del contrato |
| **Nulabilidad** | La lista vacía **es** `null`; el indicador de fallo es `#f`, que distingue la entrada inválida de `'()` |
| **Verificación estática** | `raco make {module}-lib/… {module}-test/tests/…`: compila a bytecode y no imprime nada si todo está bien |
| **Artefactos** | `compiled/` (`.zo` y `.dep`) — ignorado por el `.gitignore` del módulo; bórralo antes de una prueba manual sobre una copia, porque un `.zo` heredado puede ocultar cambios del `.rkt` |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort Tests
cd naive_sort
raco test -x .

# Data Structures Basics Tests
cd data_structures_basics
raco test -x .
```

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).
👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
