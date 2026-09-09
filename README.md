# Racket

Proyectos en **Racket**, con programas simples ejecutados con el intérprete
`racket` y proyectos con pruebas unitarias gestionados con **rackunit**, la
biblioteca de tests estándar de Racket (incluida en la distribución oficial).

---

## 📂 Módulos / Modules

| Módulo | Descripción |
| ------ | ----------- |
| [`core/foundations/`](core/foundations/) | **Fase 0 — Fundamentos**: `helloworld`, `hellouser`, `unit_test/calculator`, `numbers` |

---

## ▶️ Comenzar / Getting Started

```bash
# Hello, World!
cd core/foundations/helloworld
racket helloworld.rkt

# Hello, User!
cd core/foundations/hellouser
racket hellouser.rkt

# Calculator Tests
cd core/foundations/unit_test/calculator
racket test/run_tests.rkt

# Numbers Tests
cd core/foundations/numbers
racket test/run_tests.rkt
```

---

## 📦 Requisitos / Requirements

| Herramienta | Instalación |
| ----------- | ----------- |
| [Racket](https://racket-lang.org/) | `sudo apt install racket` (Linux) / [Descargar](https://download.racket-lang.org/) |
| [rackunit](https://docs.racket-lang.org/rackunit/) | Incluida en la distribución estándar (no requiere instalación) |

```bash
# Verificar instalación
racket --version
raco --version
```

---

## 🏗️ Tipos de proyecto / Project Types

### 1. Programa simple (interpretado con `racket`)

**ES:** Un único archivo fuente, sin dependencias externas, ejecutado directamente
con `racket`. Ideal para `helloworld` y `hellouser`. Solo requiere la biblioteca
estándar. Todo archivo `.rkt` empieza con `#lang racket`.

**EN:** A single source file, no external dependencies, run directly with
`racket`. Ideal for `helloworld` and `hellouser`. Only the standard library is
required. Every `.rkt` file starts with `#lang racket`.

```bash
racket <File>.rkt
```

### 2. Proyecto con pruebas unitarias (rackunit)

**ES:** Para proyectos que requieren pruebas unitarias, se usa **rackunit** como
framework de test. El código fuente se organiza en `src/` y las pruebas en `test/`.
Racket tiene un sistema de módulos real: `provide` exporta y `require` importa.
Las suites se definen con `test-suite`/`test-case`, se exportan con `provide` y
se ejecutan con un `run_tests.rkt` que usa `run-tests` de `rackunit/text-ui`.

**EN:** For projects that require unit tests, **rackunit** is used as the test
framework. Source code goes in `src/` and tests in `test/`. Racket has a real
module system: `provide` exports and `require` imports. Suites are defined with
`test-suite`/`test-case`, exported with `provide`, and run with a `run_tests.rkt`
that uses `run-tests` from `rackunit/text-ui`.

```bash
racket test/run_tests.rkt     # punto de entrada que ejecuta las suites
```

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio
principal](https://github.com/yorche3/programming_languages) para ver todas las
versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*