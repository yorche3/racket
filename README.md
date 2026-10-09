# Racket

Proyectos en **Racket**, con programas simples ejecutados con el intérprete
`racket` y proyectos con pruebas unitarias gestionados con **rackunit**, la
biblioteca de tests estándar de Racket (incluida en la distribución oficial).

---

## 📂 Módulos / Modules

| Módulo | Descripción |
| ------ | ----------- |
| [`core/foundations/`](core/foundations/) | **Fase 0 — Fundamentos**: `helloworld`, `hellouser`, `unit_test/calculator`, `numbers` |
| [`core/algorithms/`](core/algorithms/) | **Fase 1 — Algoritmos Puros**: `naive_sort`, `data_structures_basics` |

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
raco test -x .

# Numbers Tests
cd core/foundations/numbers
raco test -x .

# Naive Sort Tests
cd core/algorithms/naive_sort
raco test -x .

# Data Structures Basics Tests
cd core/algorithms/data_structures_basics
raco test -x .
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

### 2. Paquete con pruebas unitarias (rackunit)

**ES:** Para proyectos que requieren pruebas unitarias, se usa **rackunit** como
framework de test y el **layout de cuatro colecciones** de la comunidad
(`{module}/` metapaquete, `{module}-lib/` con el código, `{module}-test/` con las
suites y `{module}-doc/` con los scribblings), cada una con su `info.rkt`. Racket
tiene un sistema de módulos real: `provide` exporta y `require` importa; la suite
importa el módulo **por ruta relativa** (`"../../{module}-lib/{modulo}.rkt"`), así
que no hace falta instalar ni enlazar paquetes. Cada suite declara su escenario
en un submodule **`module+ test`** y un `contract.rkt` compartido envuelve
`check-equal?` con el mensaje de la casa. El runner es **`raco test -x .`**, que
descubre esos submódulos, sale limpio y devuelve código **1** cuando algún caso
falla. Lo usan `data_structures_basics`, `naive_sort`, `numbers` y `calculator`.

**EN:** For projects that require unit tests, **rackunit** is used as the test
framework along with the community's **four-collection layout** (`{module}/`
metapackage, `{module}-lib/` with the code, `{module}-test/` with the suites and
`{module}-doc/` with the scribblings), each one with its `info.rkt`. Racket has a
real module system: `provide` exports and `require` imports; the suite imports the
module **by relative path** (`"../../{module}-lib/{modulo}.rkt"`), so no package
install or link is needed. Each suite declares its scenario in a **`module+ test`**
submodule and a shared `contract.rkt` wraps `check-equal?` with the house message.
The runner is **`raco test -x .`**, which discovers those submodules, prints clean
output and returns exit code **1** when any case fails. It is used by
`data_structures_basics`, `naive_sort`, `numbers` and `calculator`.

```bash
raco test -x .                # descubre las suites con submodule test
```

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio
principal](https://github.com/yorche3/programming_languages) para ver todas las
versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*