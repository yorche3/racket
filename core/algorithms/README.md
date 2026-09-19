# Algorithms Pure — Racket

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **Racket**: ordenamientos elementales, estructuras de datos propias, ordenamientos óptimos y distribuidos, y búsqueda.

Los módulos de esta fase trabajan sobre **listas inmutables**, que se recorren por recursión o con `for`, y usan **`#f`** como indicador de fallo, que distingue una entrada nula o inválida de la lista vacía `'()`.

---

## 📂 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`naive_sort/`](naive_sort/) | [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | `racket test/run_tests.rkt` + rackunit | 3 | ✅ |

---

## 📁 Estructura / Structure

```text
algorithms/
└── naive_sort/                      # 05_Naive_Sort
    ├── src/
    │   └── naive_sort.rkt           # 3 funciones del contrato (provide)
    ├── test/
    │   ├── naive_sort_tests.rkt     # 3 test-case × 8 checks
    │   └── run_tests.rkt            # Punto de entrada
    ├── .gitignore                   # Ignora compiled/
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | Racket 9.x (`racket`), intérprete con compilación a bytecode (`raco`) |
| **CLI** | `racket test/run_tests.rkt` desde la raíz del módulo |
| **Andamiaje** | ✅ Estructura manual (`mkdir -p src test`), la que ya usa [`foundations/numbers/`](../foundations/numbers/); no hay manifiesto de dependencias |
| **Framework de tests** | rackunit, incluida en la distribución estándar (`(require rackunit)`) |
| **Runner** | `test/run_tests.rkt` con `run-tests` de `rackunit/text-ui`; la suite se exporta con `provide` para que el runner la ejecute |
| **Separación** | `src/` (módulo) ↔ `test/` (suites y punto de entrada) |
| **Carga del módulo** | `(require "../src/{modulo}.rkt")` al inicio de la suite |
| **Modularidad** | `#lang racket` + `(provide …)`; los helpers internos no se exportan |
| **Iteración** | Recursión con `let loop` (Racket garantiza TCO) y bucles `for`/`do` |
| **Mutabilidad** | Las listas son inmutables (`list-set` devuelve una lista nueva): los algoritmos devuelven una lista nueva |
| **Naming** | `kebab-case` en el código (`selection-sort`), con el nombre `snake_case` de la especificación conservado como nombre del `test-case` y en el mensaje del contrato |
| **Nulabilidad** | La lista vacía **es** `null`; el indicador de fallo es `#f`, que distingue la entrada inválida de `'()` |
| **Verificación estática** | `raco make src/… test/…`: compila a bytecode y no imprime nada si todo está bien |
| **Artefactos** | `compiled/` (`.zo` y `.dep`) — ignorado por el `.gitignore` del módulo; bórralo antes de una prueba manual sobre una copia, porque un `.zo` heredado puede ocultar cambios del `.rkt` |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort Tests
cd naive_sort
racket test/run_tests.rkt
```

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).
👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
