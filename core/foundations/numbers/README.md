# Numbers — Racket

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Racket**, con un paquete de cuatro colecciones y pruebas con **rackunit** mediante `raco test`.

Tres enfoques de implementación para los mismos 5 algoritmos: **recursivo directo** (`_rec`), **recursivo con acumulador** (`_acc`) e **iterativo** (`_ite`).

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directorio | Propósito / Purpose |
|---|---|
| `numbers-lib/numbers.rkt` | Código fuente: las 15 funciones (3 enfoques × 5 algoritmos) + 4 helpers `_help` privados. |
| `numbers-lib/info.rkt` | Metadatos de la colección de biblioteca. |
| `numbers-test/tests/contract.rkt` | Ejecutor compartido `check-contract` (envuelve `check-equal?` con el mensaje de la casa). |
| `numbers-test/tests/recursive_tests.rkt` | Suite recursiva: 5 grupos, 11 checks. |
| `numbers-test/tests/recursive_with_acc_tests.rkt` | Suite con acumulador: 5 grupos, 11 checks. |
| `numbers-test/tests/iterative_tests.rkt` | Suite iterativa: 5 grupos, 11 checks. |
| `numbers-test/info.rkt` | Metadatos de la colección de pruebas. |
| `numbers-doc/` | Colección de documentación (Scribble), sin contenido del módulo. |
| `numbers/info.rkt` | Metadatos del paquete agregador. |
| `Makefile` | Makefile estándar de la comunidad (build, test, docs, cover…). |
| `.gitignore` | Archivos generados excluidos (`compiled/`, `coverage`, temporales). |

**ES:** El layout real **se desvía** del que propone la especificación en «Ubicación esperada» (`src/` + `test/`): se usa el layout de cuatro colecciones (`-lib`, `-test`, `-doc` y el agregador), que es la convención de paquetes de Racket. La desviación se justifica en _Adaptaciones idiomáticas_.

**EN:** The real layout **deviates** from the specification's "Expected location" (`src/` + `test/`): it uses the four-collection layout (`-lib`, `-test`, `-doc` and the aggregator), which is Racket's package convention. The deviation is justified under _Idiomatic adaptations_.

```text
numbers/
├── numbers/                         # metapaquete (info.rkt)
├── numbers-lib/                     # el código (numbers.rkt)
├── numbers-test/                    # las suites (tests/)
├── numbers-doc/                     # scribblings
├── Makefile
└── .gitignore
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El módulo se escribió a mano y después se homologó al layout de cuatro colecciones del estándar de Racket del repositorio (`raco new library {module}`), el mismo que usan `data_structures_basics`, `naive_sort` y `calculator`: cada colección lleva su `info.rkt` y el runner es `raco test -x .`. Las 15 funciones se organizan en 3 grupos por enfoque:

**EN:** The module was written by hand and later homologated to the repository's Racket standard four-collection layout (`raco new library {module}`), the same one used by `data_structures_basics`, `naive_sort` and `calculator`: each collection carries its `info.rkt` and the runner is `raco test -x .`. The 15 functions are organized into 3 groups by approach:

| Enfoque | Sufijo | Ejemplo | ¿Tiene tests directos? |
| ------- | ------ | ------- | :---------------------: |
| Recursivo directo | `_rec` | `fibonacci_rec` | ✅ Sí |
| Recursivo con acumulador | `_acc` | `fibonacci_acc` | ✅ Sí (TCO garantizada) |
| Iterativo | `_ite` | `fibonacci_ite` | ✅ Sí |

**Combinación aplicada:** TCO ✅ + iteración ✅ → `_rec` + `_acc` + `_ite` = **3 suites × 5 grupos = 15 casos que agrupan 33 checks**.

**Applied combination:** TCO ✅ + iteration ✅ → `_rec` + `_acc` + `_ite` = **3 suites × 5 groups = 15 cases grouping 33 checks**.

### Inicialización / Initialization

```bash
# Homologar el módulo al layout de cuatro colecciones
mkdir -p numbers-lib numbers-test/tests numbers-doc/scribblings numbers

# Mover el código y las suites a sus colecciones
mv src/numbers.rkt numbers-lib/numbers.rkt
mv test/recursive_tests.rkt test/recursive_with_acc_tests.rkt test/iterative_tests.rkt numbers-test/tests/
rm -rf src test
```

---

## 📄 Configuración clave / Key Configuration

| Archivo / File | Propósito / Purpose |
|---|---|
| `numbers-lib/info.rkt` | Declara la colección de biblioteca y sus dependencias (`base`). |
| `numbers-test/info.rkt` | Declara la colección de pruebas y su dependencia de `rackunit`. |
| `Makefile` | Objetivo `test` = `raco test -x .`; el resto son objetivos estándar. |

**ES:** No hay dependencias externas descargadas: `rackunit` viene con la distribución estándar de Racket. Las suites importan el módulo **por ruta relativa** (`"../../numbers-lib/numbers.rkt"`), así que no hace falta instalar ni enlazar el paquete.

**EN:** No external dependencies are downloaded: `rackunit` ships with the standard Racket distribution. The suites import the module **by relative path** (`"../../numbers-lib/numbers.rkt"`), so no package install or link is needed.

### `numbers-lib/numbers.rkt` — Implementación (3 enfoques en 1 archivo)

**ES:** Cada algoritmo tiene 3 implementaciones con los sufijos `_rec`, `_acc` e `_ite`; los helpers `_help` son privados por convención (no se exportan con `provide`). Por ejemplo, `fibonacci`:

**EN:** Each algorithm has 3 implementations with the suffixes `_rec`, `_acc` and `_ite`; the `_help` helpers are private by convention (not exported with `provide`). For example, `fibonacci`:

```racket
;; Direct recursion (_rec)
(define (fibonacci_rec n)
  (if (<= n 1)
      n
      (+ (fibonacci_rec (- n 1)) (fibonacci_rec (- n 2)))))

;; Accumulator recursion (_acc): tail calls, TCO guaranteed in Racket
(define (fibonacci_acc n)
  (fibonacci_acc_help n 0 1))

(define (fibonacci_acc_help n acc2 acc1)
  (cond
    [(<= n 0) acc2]
    [(<= n 2) (+ acc1 acc2)]
    [else (fibonacci_acc_help (- n 1) acc1 (+ acc1 acc2))]))

;; Iterative (_ite): native do loops
(define (fibonacci_ite n)
  (if (<= n 1)
      n
      (do ([i 2 (+ i 1)]
           [acc2 0 acc1]
           [acc1 1 (+ acc1 acc2)])
          [(> i n) acc1])))
```

| Algoritmo | `_rec` | `_acc` | `_ite` |
| --------- | ------ | ------ | ------ |
| `sum_of_first_n` | `(+ n (sum_rec ...))` | helper con `(+ n acc)` | `do` de `1` a `n` |
| `factorial` | `(* n (fact_rec ...))` | helper con `(* n acc)` | `do` de `2` a `n` |
| `fibonacci` | suma de dos llamadas | helper con `acc2, acc1` (`cond`) | `do` con dos acumuladores |
| `greatest_common_divisor` | Euclides recursivo | helper (Euclides) | `do` con actualización paralela |
| `least_common_multiple` | `(/ (* a b) gcd)` | `(/ (* a b) gcd)` | `(/ (* a b) gcd)` |

### Suites de pruebas — rackunit

**ES:** Tres suites, una por enfoque, con un grupo por función (5 grupos) y los 11 casos del pseudocódigo como `check-contract` (33 checks en total). Cada suite declara su escenario en un submodule `test`, que es lo que `raco test` ejecuta; el ejecutor compartido `contract.rkt` es el único punto donde se compara.

**EN:** Three suites, one per approach, with one group per function (5 groups) and the pseudocode's 11 cases as `check-contract` (33 checks in total). Each suite declares its scenario in a `test` submodule, which is what `raco test` executes; the shared `contract.rkt` executor is the only place where the comparison happens.

```racket
#lang racket

(require rackunit
         "contract.rkt"
         "../../numbers-lib/numbers.rkt")

(module+ test
  ;; sum_of_first_n_rec
  (check-contract "sum_of_first_n_rec should be 0 for n = 0" (sum_of_first_n_rec 0) 0)
  (check-contract "sum_of_first_n_rec should be 6 for n = 3" (sum_of_first_n_rec 3) 6)

  ;; fibonacci_rec
  (check-contract "fibonacci_rec should be 0 for n = 0" (fibonacci_rec 0) 0)
  (check-contract "fibonacci_rec should be 1 for n = 1" (fibonacci_rec 1) 1)
  (check-contract "fibonacci_rec should be 8 for n = 6" (fibonacci_rec 6) 8)

  ;; least_common_multiple_rec
  (check-contract "least_common_multiple_rec should be 12 for 4 and 6"
                  (least_common_multiple_rec 4 6) 12)
  (check-contract "least_common_multiple_rec should be 24 for 6 and 8"
                  (least_common_multiple_rec 6 8) 24))
```

### Sin `run_tests.rkt` / No `run_tests.rkt`

**ES:** El runner manual desapareció: `raco test -x .` descubre los archivos con submodule `test` y los ejecuta. Un `run_tests.rkt` con `run-tests` de `rackunit/text-ui` duplicaría ese descubrimiento.

**EN:** The manual runner is gone: `raco test -x .` discovers the files with a `test` submodule and runs them. A `run_tests.rkt` with `run-tests` from `rackunit/text-ui` would duplicate that discovery.

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

Desde la raíz del proyecto:

```bash
cd racket/core/foundations/numbers
raco test -x .        # equivale a make test
```

**Salida real / Actual output:**

```text
$ raco test -x .
raco test: (submod (file "./numbers-test/tests/iterative_tests.rkt") test)
raco test: (submod (file "./numbers-test/tests/recursive_tests.rkt") test)
raco test: (submod (file "./numbers-test/tests/recursive_with_acc_tests.rkt") test)
33 tests passed
```

> **ES:** Una línea por suite y el total de checks: los 33 del pseudocódigo, todos pasando (equivale al `tests runned 33 / passed 33 / failed 0` de la especificación). `raco test -x .` devuelve código **1** cuando algún caso falla.
> **EN:** One line per suite plus the check total: the pseudocode's 33, all passing (equivalent to the specification's `tests runned 33 / passed 33 / failed 0`). `raco test -x .` returns exit code **1** when any case fails.

---

## 🔁 Sobre recursión con acumulador y Tail Call Optimization (TCO)

**ES:**
Tail recursion ocurre cuando la llamada recursiva es la última acción que ejecuta una función; después de la llamada no hay más instrucciones. La recursión con acumulador consigue esto pasando el estado previo como parámetro, sin dejar trabajo pendiente en la pila.

**Racket garantiza TCO**: el estándar del lenguaje exige que las llamadas de cola en posición de cola usen espacio de pila constante. Por eso las funciones `_acc` tienen una ventaja real sobre `_rec` y **sí se les escriben pruebas unitarias propias** (suite `recursive_with_acc_tests.rkt`), a diferencia de lenguajes sin TCO como Python o R.

**EN:**
Tail recursion occurs when the recursive call is the last action executed by a function; after the call there are no more instructions. Accumulator recursion achieves this by passing the previous state as a parameter, leaving no pending work on the stack.

**Racket guarantees TCO**: the language standard requires tail calls in tail position to use constant stack space. That's why the `_acc` functions have a real advantage over `_rec` and **dedicated unit tests are written for them** (suite `recursive_with_acc_tests.rkt`), unlike languages without TCO such as Python or R.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Racket usa módulos reales: `provide` exporta las 15 funciones y `require` las importa; los helpers `_help` no se exportan (privados por convención).
- **EN:** Racket uses real modules: `provide` exports the 15 functions and `require` imports them; the `_help` helpers are not exported (private by convention).
- **ES:** Las funciones `_ite` usan `do`, el bucle imperativo nativo de Racket, con actualización **paralela** de variables (las nuevas variables se calculan con los valores anteriores, como en el pseudocódigo).
- **EN:** The `_ite` functions use `do`, Racket's native imperative loop, with **parallel** variable updates (new variables are computed from the previous values, as in the pseudocode).
- **ES:** El MCM usa `(/ (* a b) gcd)`; con aritmética exacta de Racket el resultado es un entero exacto (p. ej. `24/2` = `12` exacto).
- **EN:** LCM uses `(/ (* a b) gcd)`; with Racket's exact arithmetic the result is an exact integer (e.g. `24/2` = exact `12`).
- **ES:** Cada suite declara su escenario en un submodule `module+ test` y el runner es `raco test -x .`, que descubre esos submódulos y cuenta los `check-contract`.
- **EN:** Each suite declares its scenario in a `module+ test` submodule and the runner is `raco test -x .`, which discovers those submodules and counts the `check-contract`s.
- **ES:** En `greatest_common_divisor` se usa `modulo` (operador módulo de Racket), legítimo en este algoritmo (la restricción de no usar operadores de módulo aplica solo al módulo `calculator` de la especificación 03).
- **EN:** `greatest_common_divisor` uses `modulo` (Racket's modulus operator), which is legitimate in this algorithm (the no-modulus-operator restriction applies only to the `calculator` module of specification 03).

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| Ubicación esperada `src/` + `test/` | Layout de cuatro colecciones (`-lib`, `-test`, `-doc`, agregador) | Es la convención de paquetes de Racket: cada colección tiene su `info.rkt` y `raco test -x .` descubre los submódulos `test`. |
| `test/run_tests.ext` | Sin archivo `run_tests`: `raco test -x .` descubre los submódulos `test` de cada archivo | El runner es el propio `raco`; un runner manual duplicaría el descubrimiento. |
| Mensaje del contrato | `check-contract` en `contract.rkt` con el formato `<sujeto> should <conducta>` | Unifica el mensaje de las tres suites y conserva el nombre de la función en el reporte de fallos. |

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
