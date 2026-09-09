# Numbers — Racket

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Racket**, con **rackunit** como framework de pruebas unitarias y un `run_tests.rkt` con **rackunit/text-ui** como runner.

Tres enfoques de implementación para los mismos 5 algoritmos: **recursivo directo** (`_rec`), **recursivo con acumulador** (`_acc`) e **iterativo** (`_ite`).

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/numbers.rkt`](src/numbers.rkt) | Módulo `numbers` — único archivo con las 15 funciones (3 enfoques × 5 algoritmos) + 4 helpers `_help`. |
| [`test/recursive_tests.rkt`](test/recursive_tests.rkt) | Suite recursiva: 5 `test-case` (11 checks). |
| [`test/recursive_with_acc_tests.rkt`](test/recursive_with_acc_tests.rkt) | Suite con acumulador: 5 `test-case` (11 checks). |
| [`test/iterative_tests.rkt`](test/iterative_tests.rkt) | Suite iterativa: 5 `test-case` (11 checks). |
| [`test/run_tests.rkt`](test/run_tests.rkt) | Punto de entrada: ejecuta las tres suites con `run-tests`. |
| [`.gitignore`](.gitignore) | Ignora los artefactos compilados (`compiled/`). |

**Estructura de directorios esperada:**

```text
numbers/
├── src/
│   └── numbers.rkt                  # Único archivo: 3 enfoques en 1
├── test/
│   ├── recursive_tests.rkt          # Tests: enfoque recursivo
│   ├── recursive_with_acc_tests.rkt # Tests: enfoque con acumulador
│   ├── iterative_tests.rkt          # Tests: enfoque iterativo
│   └── run_tests.rkt                # Punto de entrada
├── .gitignore
└── README.md                        # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este proyecto usa el mismo patrón que `calculator`: un módulo Racket con `(provide ...)` y suites **rackunit** definidas con `test-suite`/`test-case` y exportadas con `provide`. El punto de entrada `test/run_tests.rkt` las ejecuta con `run-tests` de **rackunit/text-ui**. Las 15 funciones se organizan en 3 grupos por enfoque:

**EN:** This project uses the same pattern as `calculator`: a Racket module with `(provide ...)` and **rackunit** suites defined with `test-suite`/`test-case` and exported with `provide`. The `test/run_tests.rkt` entry point executes them with `run-tests` from **rackunit/text-ui**. The 15 functions are organized into 3 groups by approach:

| Enfoque | Sufijo | Ejemplo | ¿Tiene tests directos? |
| ------- | ------ | ------- | :---------------------: |
| Recursivo directo | `_rec` | `fibonacci_rec` | ✅ Sí |
| Recursivo con acumulador | `_acc` | `fibonacci_acc` | ✅ Sí (TCO garantizada) |
| Iterativo | `_ite` | `fibonacci_ite` | ✅ Sí |

**Combinación aplicada:** TCO ✅ + iteración ✅ → `_rec` + `_acc` + `_ite` = **3 suites × 5 test-cases = 15 casos que agrupan 33 checks**.

**Applied combination:** TCO ✅ + iteration ✅ → `_rec` + `_acc` + `_ite` = **3 suites × 5 test-cases = 15 cases grouping 33 checks**.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p racket/core/foundations/numbers/{src,test}
   ```

2. Escribir `src/numbers.rkt` y las suites en `test/`.

3. No se necesita ningún paso adicional de construcción o vinculación de dependencias.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración de build. Las suites importan el módulo con `(require "../src/numbers.rkt")`.

### `src/numbers.rkt` — Implementación (3 enfoques en 1 archivo)

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

**ES:** Tres suites, una por enfoque. Cada suite define un `test-suite` con un `test-case` por función (5 casos); los 11 casos del pseudocódigo viven como `check-equal?` dentro de ellos (33 checks en total). Cada suite se exporta con `(provide ...-suite)` para que el runner la ejecute.

**EN:** Three suites, one per approach. Each suite defines a `test-suite` with one `test-case` per function (5 cases); the pseudocode's 11 cases live as `check-equal?`s within them (33 checks in total). Each suite is exported with `(provide ...-suite)` so the runner can execute it.

```racket
#lang racket

(require rackunit)
(require "../src/numbers.rkt")

(provide recursive-suite)

(define recursive-suite
  (test-suite "Recursive Algorithms"
    (test-case "sum_of_first_n_rec"
      (check-equal? (sum_of_first_n_rec 0) 0)
      (check-equal? (sum_of_first_n_rec 3) 6))

    (test-case "fibonacci_rec"
      (check-equal? (fibonacci_rec 0) 0)
      (check-equal? (fibonacci_rec 1) 1)
      (check-equal? (fibonacci_rec 6) 8))

    (test-case "least_common_multiple_rec"
      (check-equal? (least_common_multiple_rec 4 6) 12)
      (check-equal? (least_common_multiple_rec 6 8) 24))))
```

### `test/run_tests.rkt` — Punto de entrada

```racket
#lang racket

(require rackunit/text-ui)
(require "./recursive_tests.rkt")
(require "./recursive_with_acc_tests.rkt")
(require "./iterative_tests.rkt")

(run-tests recursive-suite)
(run-tests recursive-with-acc-suite)
(run-tests iterative-suite)
```

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
racket test/run_tests.rkt
```

### Salida esperada / Expected output

```text
5 success(es) 0 failure(s) 0 error(s) 5 test(s) run
5 success(es) 0 failure(s) 0 error(s) 5 test(s) run
5 success(es) 0 failure(s) 0 error(s) 5 test(s) run
```

> **ES:** Una línea por suite: 15 `test-case` en total (5 por suite) que agrupan los 33 checks del pseudocódigo, todos pasando (equivale al `tests runned 33 / passed 33 / failed 0` de la especificación).
> **EN:** One line per suite: 15 `test-case`s in total (5 per suite) grouping the pseudocode's 33 checks, all passing (equivalent to the specification's `tests runned 33 / passed 33 / failed 0`).

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
- **ES:** Cada suite se define con `test-suite`/`test-case` (un caso por función) y se exporta con `provide`; el runner `run_tests.rkt` las ejecuta con `run-tests` de `rackunit/text-ui`.
- **EN:** Each suite is defined with `test-suite`/`test-case` (one case per function) and exported with `provide`; the `run_tests.rkt` runner executes them with `run-tests` from `rackunit/text-ui`.
- **ES:** En `greatest_common_divisor` se usa `modulo` (operador módulo de Racket), legítimo en este algoritmo (la restricción de no usar operadores de módulo aplica solo al módulo `calculator` de la especificación 03).
- **EN:** `greatest_common_divisor` uses `modulo` (Racket's modulus operator), which is legitimate in this algorithm (the no-modulus-operator restriction applies only to the `calculator` module of specification 03).

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
