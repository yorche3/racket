# Naive Sort — Racket

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **Racket**, con **rackunit** como framework de pruebas unitarias y un `run_tests.rkt` con **rackunit/text-ui** como runner.

Tres algoritmos de ordenación con coste $O(n^2)$: **selection sort**, **bubble sort** e **insertion sort**, trabajando sobre listas **inmutables**, sin invocar `sort` ni `list-sort` ni ninguna biblioteca de ordenamiento.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/naive_sort.rkt`](src/naive_sort.rkt) | Módulo `naive_sort` — las 3 funciones del contrato, exportadas con `provide`. |
| [`test/naive_sort_tests.rkt`](test/naive_sort_tests.rkt) | Suite única: 3 `test-case` (8 checks cada uno). |
| [`test/run_tests.rkt`](test/run_tests.rkt) | Punto de entrada: ejecuta la suite con `run-tests`. |
| [`.gitignore`](.gitignore) | Ignora los artefactos compilados (`compiled/`). |

**Estructura de directorios esperada:**

```text
naive_sort/
├── src/
│   └── naive_sort.rkt            # 3 funciones del contrato
├── test/
│   ├── naive_sort_tests.rkt      # Suite: los 3 algoritmos
│   └── run_tests.rkt             # Punto de entrada
├── .gitignore
└── README.md                     # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este proyecto usa el mismo patrón que [`numbers`](../../foundations/numbers/) y [`calculator`](../../foundations/unit_test/calculator/): un módulo Racket con `(provide ...)` y una suite **rackunit** definida con `test-suite`/`test-case` y exportada con `provide`. El punto de entrada `test/run_tests.rkt` la ejecuta con `run-tests` de **rackunit/text-ui**. Las 3 funciones del contrato viven en un único módulo y no hay helpers exportados.

**EN:** This project uses the same pattern as [`numbers`](../../foundations/numbers/) and [`calculator`](../../foundations/unit_test/calculator/): a Racket module with `(provide ...)` and a **rackunit** suite defined with `test-suite`/`test-case` and exported with `provide`. The `test/run_tests.rkt` entry point executes it with `run-tests` from **rackunit/text-ui**. The contract's 3 functions live in a single module and no helper is exported.

**Combinación aplicada:** TCO ✅ + iteración ✅ → `_rec`-style recursion where it reads better (`selection-sort`, `insertion-sort`) + loops for `bubble-sort` = **1 suite × 3 test-cases = 3 tests que agrupan 24 checks**.

**Applied combination:** TCO ✅ + iteration ✅ → `_rec`-style recursion where it reads better (`selection-sort`, `insertion-sort`) + loops for `bubble-sort` = **1 suite × 3 test-cases = 3 tests grouping 24 checks**.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p racket/core/algorithms/naive_sort/{src,test}
   ```

2. Escribir `src/naive_sort.rkt` y la suite en `test/`.

3. No se necesita ningún paso adicional de construcción o vinculación de dependencias.

---

## 📄 Archivos de configuración clave / Key Configuration Files

**ES:** No se requieren archivos de configuración de build. La suite importa el módulo con `(require "../src/naive_sort.rkt")`.

**EN:** No build configuration files are required. The suite imports the module with `(require "../src/naive_sort.rkt")`.

### `src/naive_sort.rkt` — Implementación

**ES:** Las tres funciones comprueban primero la entrada inválida y la lista vacía, y después ordenan. Extracto de `bubble-sort`, que conserva la bandera `swapped` y la salida temprana del pseudocódigo:

**EN:** All three functions first check the invalid input and the empty list, and then sort. Excerpt from `bubble-sort`, which keeps the pseudocode's `swapped` flag and early exit:

```racket
;; Contrato: recibe una lista de enteros y devuelve la lista ordenada de menor a
;; mayor (in-place o como copia ordenada), sin invocar `sort` ni ninguna
;; biblioteca de ordenamiento, y sin estructuras auxiliares complejas.
;; Si la entrada es nula o inválida devuelve `#f` como indicador de fallo; si
;; está vacía devuelve la misma lista vacía. No lanza excepciones.

(define (bubble-sort arr)
  (cond
    [(not (list? arr)) #f]
    [(or (null? arr) (null? (cdr arr))) arr]
    [else
     (let loop ((lst arr) (n (length arr)))
       (if (= n 1)
           lst
           (let ((swapped #f))
             (for ((i (- n 1)))
               (when (> (list-ref lst i) (list-ref lst (+ i 1)))
                 (let ((temp (list-ref lst i)))
                   (set! lst (list-set lst i (list-ref lst (+ i 1))))
                   (set! lst (list-set lst (+ i 1) temp))
                   (set! swapped #t))))
             (if swapped
                 (loop lst (- n 1))
                 lst))))]))
```

| Algoritmo | Estrategia implementada |
| --------- | ----------------------- |
| `selection-sort` | `(apply min lst)` para el mínimo y `remove` para el resto, acumulando en un `let loop` |
| `bubble-sort` | Bucle `for` por pasada con `list-set` y bandera `swapped` que decide si repite |
| `insertion-sort` | Recursión con un `let insert` interno que acumula en `skipped` el prefijo ya descartado |

### Suites de pruebas — rackunit

**ES:** Una única suite con un `test-case` por algoritmo. Los 8 casos viven en una lista compartida y un único helper los recorre para cualquier función; el mensaje del contrato viaja en el tercer argumento de `check-equal?`:

**EN:** A single suite with one `test-case` per algorithm. The 8 cases live in a shared list and a single helper walks them for any function; the contract message travels in `check-equal?`'s third argument:

```racket
(define (assert-sorts-all-cases sort-function algorithm)
  (for ([c (in-list cases)])
    (match-define (list description input expected) c)
    (check-equal?
     (sort-function input)
     expected
     (format "~a should sort ~a" algorithm description))))

(provide naive-sort-suite)

(define naive-sort-suite
  (test-suite
   "naive_sort"
   (test-case "selection_sort"
     (assert-sorts-all-cases selection-sort "selection_sort"))
   (test-case "bubble_sort"
     (assert-sorts-all-cases bubble-sort "bubble_sort"))
   (test-case "insertion_sort"
     (assert-sorts-all-cases insertion-sort "insertion_sort"))))
```

### `test/run_tests.rkt` — Punto de entrada

```racket
#lang racket

(require rackunit/text-ui rackunit-fancy-runner)
(require "./naive_sort_tests.rkt")

(run-tests naive-sort-suite)
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

### Verificación estática / Static check

**ES:** Racket compila a bytecode con `raco make`, que es también el análisis estático del módulo y de las suites: sin salida significa compilación limpia (los `.zo` quedan en `compiled/`, ignorado por git).

**EN:** Racket compiles to bytecode with `raco make`, which is also the static analysis of the module and the suites: no output means a clean compilation (the `.zo` files land in `compiled/`, ignored by git).

```bash
cd racket/core/algorithms/naive_sort
raco make src/naive_sort.rkt test/naive_sort_tests.rkt test/run_tests.rkt
```

```text
(sin salida, exit 0)
```

### Ejecutar las pruebas / Run tests

Desde la raíz del proyecto:

```bash
cd racket/core/algorithms/naive_sort
racket test/run_tests.rkt
```

### Salida esperada / Expected output

```text
3 success(es) 0 failure(s) 0 error(s) 3 test(s) run
```

> **ES:** Un `test-case` por algoritmo (3 en total) que agrupan los 24 checks del contrato (8 por algoritmo), todos pasando (`0 failure(s)`). Un fallo se reporta así: `FAILURE` + `message: "bubble_sort should sort an unsorted array"` + `actual` frente a `expected`.
> **EN:** One `test-case` per algorithm (3 in total) grouping the contract's 24 checks (8 per algorithm), all passing (`0 failure(s)`). A failure is reported as: `FAILURE` + `message: "bubble_sort should sort an unsorted array"` + `actual` versus `expected`.

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Algoritmo | Función | Estrategia | Entrada ordenada | Entrada invertida |
|-----------|---------|-----------|:----------------:|:-----------------:|
| Selection sort | `selection-sort` | Extrae el mínimo y el resto en una sola pasada (`min` + `remove`) y lo antepone al resultado | $O(n^2)$ | $O(n^2)$ |
| Bubble sort | `bubble-sort` | Una pasada con bandera `swapped` que arrastra el mayor al final y repite solo si hubo intercambios (**salida temprana**) | $O(n)$ | $O(n^2)$ |
| Insertion sort | `insertion-sort` | Ordena la cola recursivamente e inserta la cabeza en su posición con un `let insert` interno | $O(n)$ | $O(n^2)$ |

### Casos cubiertos / Covered cases

| # | Caso | Entrada | Salida esperada |
|:-:|------|---------|-----------------|
| 1 | Array estándar desordenado | `'(5 2 9 1 5 6)` | `'(1 2 5 5 6 9)` |
| 2 | Array ya ordenado | `'(1 2 3 4 5)` | `'(1 2 3 4 5)` |
| 3 | Array en orden inverso | `'(5 4 3 2 1)` | `'(1 2 3 4 5)` |
| 4 | Elementos idénticos | `'(7 7 7 7)` | `'(7 7 7 7)` |
| 5 | Con números negativos | `'(3 -1 4 -5 0)` | `'(-5 -1 0 3 4)` |
| 6 | Un solo elemento | `'(42)` | `'(42)` |
| 7 | Lista vacía | `'()` | `'()` |
| 8 | Entrada nula o inválida | `#f` | `#f` |

**ES:** Son los 7 casos obligatorios de la especificación más el caso nulo/inválido, que en Racket sí es representable (ver la nota correspondiente).

**EN:** These are the 7 mandatory cases from the specification plus the null/invalid case, which is representable in Racket (see the corresponding note).

---

## 📝 Notas de implementación / Implementation Notes

### 🧬 Listas inmutables: se devuelve una lista nueva / Immutable lists: a new list is returned

**ES:** El pseudocódigo ordena el propio array con `swap(arr, i, j)`. En Racket las listas son **inmutables**: `list-set` devuelve una lista nueva, así que los tres algoritmos construyen y devuelven una **lista nueva** y la de entrada queda intacta (la variante «copia ordenada» que la especificación permite). Por eso los tests **no necesitan copiar** el fixture: es imposible que un caso contamine al siguiente.

**EN:** The pseudocode sorts the array itself with `swap(arr, i, j)`. In Racket lists are **immutable**: `list-set` returns a new list, so all three algorithms build and return a **new list** and the input one is left untouched (the "sorted copy" variant the specification allows). That is why the tests **need no copy** of the fixture: a case cannot contaminate the next one.

### 🚫 Caso nulo/inválido incluido: `#f` como indicador de fallo / Null/invalid case included: `#f` as the failure indicator

**ES:** La especificación pide devolver el indicador de fallo del lenguaje si la entrada es nula o inválida, sin lanzar excepciones. En Racket la lista vacía **es** `null` (`(null? '())` da `#t`), de modo que el indicador de fallo es **`#f`**, que sí distingue una entrada nula o inválida de la lista vacía: las tres funciones comprueban `(not (list? arr))` y devuelven `#f`, y el caso vacío se resuelve por separado devolviendo **la misma lista vacía** (`[(or (null? arr) (null? (cdr arr))) arr]`, el `if n <= 1 return arr` del pseudocódigo).

**EN:** The specification requires returning the language's failure indicator when the input is null or invalid, without throwing exceptions. In Racket the empty list **is** `null` (`(null? '())` is `#t`), so the failure indicator is **`#f`**, which does distinguish a null or invalid input from the empty list: all three functions check `(not (list? arr))` and return `#f`, and the empty case is resolved separately by returning **the same empty list** (`[(or (null? arr) (null? (cdr arr))) arr]`, the pseudocode's `if n <= 1 return arr`).

### 🔁 `bubble-sort` y la bandera de intercambio / `bubble-sort` and the swap flag

**ES:** El criterio de aceptación exige la optimización de salida temprana. `bubble-sort` inicializa `swapped` en `#f` al empezar cada pasada, lo activa al intercambiar y repite **solo si la bandera quedó en `#t`** (`(if swapped (loop lst (- n 1)) lst)`), que es el `if not swapped then break` del pseudocódigo: una lista ya ordenada se resuelve en **una sola pasada** y el mejor caso es $O(n)$. La bandera **no es observable en la salida** (las tres funciones devuelven una lista ordenada), así que la suite no puede detectar su ausencia: su presencia se verifica comparando el código con el pseudocódigo.

**EN:** The acceptance criteria require the early-exit optimisation. `bubble-sort` initialises `swapped` to `#f` at the start of each pass, sets it when swapping and repeats **only if the flag ended up `#t`** (`(if swapped (loop lst (- n 1)) lst)`), which is the pseudocode's `if not swapped then break`: an already sorted list is solved in **a single pass** and the best case is $O(n)$. The flag is **not observable in the output** (all three functions return a sorted list), so the suite cannot detect its absence: its presence is verified by comparing the code against the pseudocode.

### 🔀 `insertion-sort`: inserción acumulando el prefijo / `insertion-sort`: insertion accumulating the prefix

**ES:** El `let insert` interno recorre la parte ya ordenada y **acumula en `skipped`** los elementos que va dejando atrás, para reinsertarlos al encontrar la posición (`(append (reverse skipped) (cons current s))`). Es lo que evita perder elementos, que es el error natural de esta formulación. Como la lista se construye ya en orden ascendente, no hay `reverse` final. La comparación es estricta (`(< current (car s))`), así que los elementos iguales quedan después del insertado y `insertion-sort` es **estable**: el caso 1 (`'(5 2 9 1 5 6)`, con dos cincos) se beneficia de ello, aunque los tests comparan valores y no identidad.

**EN:** The inner `let insert` walks the already sorted part and **accumulates in `skipped`** the elements it leaves behind, to reinsert them when the position is found (`(append (reverse skipped) (cons current s))`). That is what prevents losing elements, the natural mistake of this formulation. Since the list is built already in ascending order, there is no final `reverse`. The comparison is strict (`(< current (car s))`), so equal elements end up after the inserted one and `insertion-sort` is **stable**: case 1 (`'(5 2 9 1 5 6)`, with two fives) benefits from it, although the tests compare values rather than identity.

### 🏷️ Naming: kebab-case y nombres de la especificación / Naming: kebab-case and specification names

**ES:** Las funciones usan **kebab-case** (`selection-sort`, `bubble-sort`, `insertion-sort`), que es la convención de Racket, mientras que la especificación las nombra en `snake_case`. El nombre de la especificación se conserva como **nombre del `test-case`** y en el **mensaje del contrato** (`"selection_sort should sort an unsorted array"`), de modo que el reporte sigue mostrando `selection_sort`, `bubble_sort` e `insertion_sort`. El parámetro conserva el nombre `arr` de la documentación y el módulo no exporta ningún helper.

**EN:** Functions use **kebab-case** (`selection-sort`, `bubble-sort`, `insertion-sort`), which is Racket's convention, while the specification names them in `snake_case`. The specification name is preserved as the **`test-case` name** and in the **contract message** (`"selection_sort should sort an unsorted array"`), so the report still shows `selection_sort`, `bubble_sort` and `insertion_sort`. The parameter keeps the documentation's `arr` name and the module exports no helper.

### 🧱 `compiled/` y el bytecode / `compiled/` and bytecode

**ES:** `raco make` deja los `.zo` (y los `compiled/*.dep`) dentro de cada directorio; están ignorados por el `.gitignore` del módulo. Al hacer una prueba manual sobre una copia, conviene borrar `compiled/` primero: un `.zo` heredado puede hacer que Racket cargue el módulo antiguo y oculte un cambio del `.rkt`.

**EN:** `raco make` leaves the `.zo` files (and `compiled/*.dep`) inside each directory; they are ignored by the module's `.gitignore`. When running a manual check on a copy, delete `compiled/` first: an inherited `.zo` can make Racket load the old module and hide a change to the `.rkt`.

### 📍 Desviaciones respecto a la ubicación esperada / Deviations from the expected location

| Especificación | Implementación | Motivo |
|----------------|----------------|--------|
| `src/naive_sort.ext` | `src/naive_sort.rkt` | Nombre exacto del módulo; solo cambia la extensión (`.rkt`, como `numbers.rkt`). |
| `test/naive_sort_test.ext` | `test/naive_sort_tests.rkt` | El sufijo va en plural (`_tests.rkt`), como `recursive_tests.rkt` e `iterative_tests.rkt` en `numbers/`. |
| `test/run_tests.ext` | `test/run_tests.rkt` | El punto de entrada ejecuta la suite con `run-tests` de `rackunit/text-ui`, igual que en `numbers/` y `calculator/` (la suite se exporta con `provide` para que el runner pueda ejecutarla). |

**ES:** Además, los identificadores son `kebab-case` y la declaración de módulo, la de dependencias y la del propio runner son las de Racket (`#lang racket`, `(provide ...)`, `(require ...)`), tal como documenta la guía de agentes del repositorio.

**EN:** In addition, identifiers are `kebab-case` and the module declaration, the dependency declarations and the runner's own declaration are Racket's (`#lang racket`, `(provide ...)`, `(require ...)`), as the repository's agent guide documents.

**ES:** Este proyecto también está implementado en otros lenguajes. Explora el repositorio principal para consultar las demás versiones.

**EN:** This project is also implemented in other languages. Explore the main repository to see the other versions.

---

*[← Volver a Algoritmos Puros](../README.md) · [↑ Volver a Core](../../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
