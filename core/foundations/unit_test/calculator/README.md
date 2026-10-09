# Calculator — Racket

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **Racket**, con un paquete de cuatro colecciones y pruebas con **rackunit** — la biblioteca de tests estándar de Racket — mediante `raco test`.

Operaciones aritméticas básicas (`addition`, `subtraction`, `multiplication`, `division`, `modulus`) con implementaciones intuitivas y educativas, validadas mediante pruebas unitarias.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directorio | Propósito / Purpose |
|---|---|
| `calculator-lib/calculator.rkt` | Código fuente: las 5 funciones del contrato, exportadas con `provide`. |
| `calculator-lib/info.rkt` | Metadatos de la colección de biblioteca. |
| `calculator-test/tests/contract.rkt` | Ejecutor compartido `check-contract` (envuelve `check-equal?` con el mensaje de la casa). |
| `calculator-test/tests/calculator_tests.rkt` | Suite: 5 casos, uno por operación (5 checks). |
| `calculator-test/info.rkt` | Metadatos de la colección de pruebas. |
| `calculator-doc/` | Colección de documentación (Scribble), sin contenido del módulo. |
| `calculator/info.rkt` | Metadatos del paquete agregador. |
| `Makefile` | Makefile estándar de la comunidad (build, test, docs, cover…). |
| `.gitignore` | Archivos generados excluidos (`compiled/`, `coverage`, temporales). |

**ES:** El layout real **se desvía** del que propone la especificación en «Ubicación esperada» (`src/` + `test/`): se usa el layout de cuatro colecciones (`-lib`, `-test`, `-doc` y el agregador), que es la convención de paquetes de Racket. La desviación se justifica en _Adaptaciones idiomáticas_.

**EN:** The real layout **deviates** from the specification's "Expected location" (`src/` + `test/`): it uses the four-collection layout (`-lib`, `-test`, `-doc` and the aggregator), which is Racket's package convention. The deviation is justified under _Idiomatic adaptations_.

```text
calculator/
├── calculator/                 # metapaquete (info.rkt)
├── calculator-lib/             # el código (calculator.rkt)
├── calculator-test/            # las suites (tests/)
├── calculator-doc/             # scribblings
├── Makefile
└── .gitignore
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El módulo se escribió a mano y después se homologó al layout de cuatro colecciones del estándar de Racket del repositorio (`raco new library {module}`), el mismo que usan `data_structures_basics`, `numbers` y `naive_sort`: cada colección lleva su `info.rkt` y el runner es `raco test -x .`. Racket tiene un **sistema de módulos real**: `calculator-lib/calculator.rkt` declara `(provide ...)` las 5 funciones y la suite las importa con `(require "../../calculator-lib/calculator.rkt")`, por ruta relativa y sin enlazar paquetes. Las pruebas usan **rackunit** (incluida en la distribución estándar).

**EN:** The module was written by hand and later homologated to the repository's Racket standard four-collection layout (`raco new library {module}`), the same one used by `data_structures_basics`, `numbers` and `naive_sort`: each collection carries its `info.rkt` and the runner is `raco test -x .`. Racket has a **real module system**: `calculator-lib/calculator.rkt` declares `(provide ...)` for the 5 functions and the suite imports them with `(require "../../calculator-lib/calculator.rkt")`, by relative path and without linking packages. Tests use **rackunit** (bundled with the standard Racket distribution).

### Inicialización / Initialization

```bash
# Homologar el módulo al layout de cuatro colecciones
mkdir -p calculator-lib calculator-test/tests calculator-doc/scribblings calculator

# Mover el código y la suite a sus colecciones
mv src/calculator.rkt calculator-lib/calculator.rkt
mv test/calculator_test.rkt calculator-test/tests/calculator_tests.rkt
```

---

## 📄 Configuración clave / Key Configuration

| Archivo / File | Propósito / Purpose |
|---|---|
| `calculator-lib/info.rkt` | Declara la colección de biblioteca y sus dependencias (`base`). |
| `calculator-test/info.rkt` | Declara la colección de pruebas y su dependencia de `rackunit`. |
| `Makefile` | Objetivo `test` = `raco test -x .`; el resto son objetivos estándar. |

**ES:** No hay dependencias externas descargadas: `rackunit` viene con la distribución estándar de Racket. El módulo se comparte mediante `provide`/`require`.

**EN:** No external dependencies are downloaded: `rackunit` ships with the standard Racket distribution. The module is shared through `provide`/`require`.

### `calculator-lib/calculator.rkt` — Implementaciones educativas

**ES:** Cada operación compleja se construye a partir de las simples (concepto que se explora a fondo en `04_Numbers`): `multiplication` suma repetidamente, `division` resta repetidamente y `modulus` reutiliza `division` y `multiplication`. Por eso **no** se usan los operadores `*`, `/` ni `modulo`. Los bucles se expresan con *named let* (`let loop`), el idiom idiomático de Racket: es una llamada de cola, optimizada por el compilador.

**EN:** Each complex operation is built from the simple ones (a concept explored in depth in `04_Numbers`): `multiplication` adds repeatedly, `division` subtracts repeatedly, and `modulus` reuses `division` and `multiplication`. That's why the operators `*`, `/` and `modulo` are **not** used. Loops are expressed with *named let* (`let loop`), Racket's idiomatic idiom: it is a tail call, optimized by the compiler.

```racket
#lang racket

(provide addition subtraction multiplication division modulus)

(define (addition a b)
  (+ a b))

(define (subtraction a b)
  (- a b))

(define (multiplication a b)
  (let loop ([i 0] [result 0])
    (if (= i b)
        result
        (loop (+ i 1) (addition result a)))))

(define (division a b)
  (let loop ([a a] [quotient 0])
    (if (< a b)
        quotient
        (loop (subtraction a b) (addition quotient 1)))))

(define (modulus a b)
  (define q (division a b))
  (define p (multiplication q b))
  (subtraction a p))
```

| Función | Implementación educativa |
|---------|-------------------------|
| `(addition a b)` | Suma directa (`+`) |
| `(subtraction a b)` | Resta directa (`-`) |
| `(multiplication a b)` | Suma repetitiva: `let loop` suma `a` a `result` hasta `b` veces |
| `(division a b)` | Resta repetitiva: `let loop` resta `b` y cuenta hasta que `a < b` |
| `(modulus a b)` | `q = (division a b)`; `p = (multiplication q b)`; `(subtraction a p)` |

### `calculator-test/tests/calculator_tests.rkt` — Suite rackunit

**ES:** Un caso por operación (5 casos, uno por función), cada uno con su `check-contract` y el mensaje de la casa. La suite declara su escenario en un submodule `test`, que es lo que `raco test` ejecuta; el ejecutor compartido `contract.rkt` es el único punto donde se compara.

**EN:** One case per operation (5 cases, one per function), each with its `check-contract` and the house message. The suite declares its scenario in a `test` submodule, which is what `raco test` executes; the shared `contract.rkt` executor is the only place where the comparison happens.

```racket
#lang racket

(require rackunit
         "contract.rkt"
         "../../calculator-lib/calculator.rkt")

(module+ test
  ;; addition
  (check-contract "addition should be 5 for 2 and 3" (addition 2 3) 5)

  ;; subtraction
  (check-contract "subtraction should be 3 for 5 and 2" (subtraction 5 2) 3)

  ;; multiplication
  (check-contract "multiplication should be 12 for 3 and 4" (multiplication 3 4) 12)

  ;; division
  (check-contract "division should be 3 for 10 and 3" (division 10 3) 3)

  ;; modulus
  (check-contract "modulus should be 1 for 10 and 3" (modulus 10 3) 1))
```

### Sin `run_tests.rkt` / No `run_tests.rkt`

**ES:** El runner manual desapareció: `raco test -x .` descubre los archivos con submodule `test` y los ejecuta.

**EN:** The manual runner is gone: `raco test -x .` discovers the files with a `test` submodule and runs them.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **Racket** (`racket` y `raco`, ambos incluidos en la distribución).

```bash
# Verificar instalación
racket --version
raco --version
```

> **ES:** rackunit viene incluida en la distribución estándar de Racket; no requiere instalación adicional.
> **EN:** rackunit ships with the standard Racket distribution; no additional installation is required.

### Ejecutar las pruebas / Run tests

```bash
cd racket/core/foundations/unit_test/calculator
raco test -x .        # equivale a make test
```

**Salida real / Actual output:**

```text
$ raco test -x .
raco test: (submod (file "./calculator-test/tests/calculator_tests.rkt") test)
5 tests passed
```

> **ES:** Los 5 casos pasan sin fallos ni errores (equivale al `Tests run: 5, Passed: 5, Failed: 0` de la especificación). `raco test -x .` devuelve código **1** cuando algún caso falla.
> **EN:** The 5 cases pass with no failures or errors (equivalent to the specification's `Tests run: 5, Passed: 5, Failed: 0`). `raco test -x .` returns exit code **1** when any case fails.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Racket usa módulos reales: `provide` exporta y `require` importa; la ruta relativa en `require` se resuelve respecto al archivo que la usa.
- **EN:** Racket uses real modules: `provide` exports and `require` imports; the relative path in `require` resolves relative to the file that uses it.
- **ES:** Los `let loop` son llamadas de cola: Racket garantiza TCO, así que estos bucles recursivos no consumen pila.
- **EN:** The `let loop`s are tail calls: Racket guarantees TCO, so these recursive loops consume no stack.
- **ES:** La división por cero no se maneja en este ejemplo educativo (según el pseudocódigo de la especificación); las pruebas usan valores válidos.
- **EN:** Division by zero is not handled in this educational example (per the specification's pseudocode); tests use valid values.
- **ES:** La suite declara su escenario en un submodule `module+ test` y el runner es `raco test -x .`, que descubre esos submódulos y cuenta los `check-contract`.
- **EN:** The suite declares its scenario in a `module+ test` submodule and the runner is `raco test -x .`, which discovers those submodules and counts the `check-contract`s.

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| Ubicación esperada `src/` + `test/` | Layout de cuatro colecciones (`-lib`, `-test`, `-doc`, agregador) | Es la convención de paquetes de Racket: cada colección tiene su `info.rkt` y `raco test -x .` descubre los submódulos `test`. |
| `test/calculator_test.ext` | `calculator-test/tests/calculator_tests.rkt` | El sufijo va en plural (`_tests.rkt`), como en `data_structures_basics`, `numbers` y `naive_sort`. |
| `test/run_tests.ext` | Sin archivo `run_tests`: `raco test -x .` descubre los submódulos `test` de cada archivo | El runner es el propio `raco`; un runner manual duplicaría el descubrimiento. |
| Mensaje del contrato | `check-contract` en `contract.rkt` con el formato `<sujeto> should <conducta>` | Conserva el nombre de la operación en el reporte de fallos. |

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
