# 🚀 Fundamentos / Foundations — Racket

Implementación de los ejercicios de la sección [Fundamentos / Foundations](https://yorche3.github.io/programming_languages/core/foundations/) del repositorio principal en **Racket**.

---

## 📖 Descripción / Description

**ES:** Esta sección reúne los conceptos esenciales para empezar a trabajar con **Racket**. Cubre desde los programas más básicos (`Hello, World!` y `Hello, User!`) hasta la implementación de una calculadora con pruebas unitarias y algoritmos numéricos en tres enfoques progresivos (recursivo directo, recursivo con acumulador e iterativo).

**EN:** This section brings together the essential concepts to start working with **Racket**. It covers everything from the most basic programs (`Hello, World!` and `Hello, User!`) to the implementation of a calculator with unit tests and numerical algorithms in three progressive approaches (direct recursion, accumulator recursion, and iterative).

---

## 📁 Estructura / Structure

```text
racket/
└── core/
    └── foundations/
        ├── README.md              # Este archivo / This file
        ├── helloworld/            # 01_Hello_World — Primer programa
        │   ├── helloworld.rkt
        │   └── README.md
        ├── hellouser/             # 02_Hello_User — Entrada y salida
        │   ├── hellouser.rkt
        │   └── README.md
        ├── unit_test/
        │   └── calculator/        # 03_Unit_Test_Calculator — Pruebas unitarias
        │       ├── calculator-lib/        # Código (calculator.rkt)
        │       ├── calculator-test/       # Suite (tests/) + contract.rkt
        │       ├── calculator-doc/        # Documentación (Scribble)
        │       ├── Makefile               # Build estándar de raco new
        │       └── README.md
        └── numbers/               # 04_Numbers — Algoritmos numéricos
            ├── numbers-lib/               # Código (numbers.rkt)
            ├── numbers-test/              # Tres suites (tests/) + contract.rkt
            ├── numbers-doc/               # Documentación (Scribble)
            ├── Makefile                   # Build estándar de raco new
            └── README.md
```

---

## 🔢 Progresión / Progression

| Especificación | Proyecto | Conceptos | Tests | Dependencias externas |
| -------------- | -------- | --------- | :---: | :-------------------: |
| [`01_Hello_World`](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) | [`helloworld/`](helloworld/) | `#lang racket`, `println`, ejecución con `racket` | — | ❌ Solo stdlib |
| [`02_Hello_User`](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) | [`hellouser/`](hellouser/) | `display`, `read-line`, `define`, `printf` | — | ❌ Solo stdlib |
| [`03_Unit_Test_Calculator`](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) | [`unit_test/calculator/`](unit_test/calculator/) | rackunit, `module+ test`, `provide`/`require` | 5 | ❌ rackunit incluida en Racket |
| [`04_Numbers`](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) | [`numbers/`](numbers/) | Recursión, acumuladores, bucles `do`, TCO | 15 (33 checks) | ❌ rackunit incluida en Racket |

---

## 🛠️ Enfoque general / General Approach

**ES:** Los proyectos en esta sección siguen un patrón progresivo:

1. **Hello World** y **Hello User**: Programas de un solo archivo `.rkt`, ejecutados directamente con `racket`. Usan exclusivamente la biblioteca estándar.
2. **Calculator**: Primer proyecto con framework de pruebas (**rackunit**, incluida en la distribución estándar de Racket). Introduce el sistema de módulos real de Racket (`provide`/`require`), el layout de cuatro colecciones (`-lib`, `-test`, `-doc`, agregador) y las suites en un submodule `module+ test` ejecutadas por `raco test -x .`.
3. **Numbers**: Expande el patrón a tres suites. Racket **garantiza TCO** y tiene bucles nativos (`do`), por lo que se prueban los tres enfoques: `_rec` + `_acc` + `_ite` = 3 suites con 15 grupos (33 checks).

**EN:** The projects in this section follow a progressive pattern:

1. **Hello World** and **Hello User**: Single-file `.rkt` programs, run directly with `racket`. Use only the standard library.
2. **Calculator**: First project with a test framework (**rackunit**, bundled with the standard Racket distribution). Introduces Racket's real module system (`provide`/`require`), the four-collection layout (`-lib`, `-test`, `-doc`, aggregator) and the suites in a `module+ test` submodule run by `raco test -x .`.
3. **Numbers**: Expands the pattern to three suites. Racket **guarantees TCO** and has native loops (`do`), so all three approaches are tested: `_rec` + `_acc` + `_ite` = 3 suites with 15 groups (33 checks).

---

## 🚀 Ejecución rápida / Quick Start

### Hello World

```bash
cd racket/core/foundations/helloworld
racket helloworld.rkt
```

### Hello User

```bash
cd racket/core/foundations/hellouser
racket hellouser.rkt
```

### Calculator (pruebas)

```bash
cd racket/core/foundations/unit_test/calculator
raco test -x .
```

### Numbers (pruebas)

```bash
cd racket/core/foundations/numbers
raco test -x .
```

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
