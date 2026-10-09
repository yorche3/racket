# Naive Sort — Racket

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **Racket**, con un paquete de cuatro colecciones y pruebas con **rackunit** mediante `raco test`.

Tres algoritmos de ordenación con coste $O(n^2)$: **selection sort**, **bubble sort** e **insertion sort**, que devuelven una lista nueva ordenada y no invocan `sort`, `list-sort` ni ninguna biblioteca de ordenamiento.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directorio | Propósito / Purpose |
|---|---|
| `naive_sort-lib/naive-sort.rkt` | Código fuente: las 3 funciones del contrato, exportadas con `provide`. |
| `naive_sort-lib/info.rkt` | Metadatos de la colección de biblioteca. |
| `naive_sort-test/tests/contract.rkt` | Ejecutor compartido `check-contract` (envuelve `check-equal?` con el mensaje de la casa). |
| `naive_sort-test/tests/naive_sort_tests.rkt` | Suite única: tabla de 8 casos × 3 algoritmos (24 checks). |
| `naive_sort-test/info.rkt` | Metadatos de la colección de pruebas. |
| `naive_sort-doc/` | Colección de documentación (Scribble), sin contenido del módulo. |
| `naive_sort/info.rkt` | Metadatos del paquete agregador. |
| `Makefile` | Makefile estándar de la comunidad (build, test, docs, cover…). |
| `.gitignore` | Archivos generados excluidos (`compiled/`, `coverage`, temporales). |

**ES:** El layout real **se desvía** del que propone la especificación en «Ubicación esperada» (`src/` + `test/`): se usa el layout de cuatro colecciones (`-lib`, `-test`, `-doc` y el agregador), que es la convención de paquetes de Racket. La desviación se justifica en _Adaptaciones idiomáticas_.

**EN:** The real layout **deviates** from the specification's "Expected location" (`src/` + `test/`): it uses the four-collection layout (`-lib`, `-test`, `-doc` and the aggregator), which is Racket's package convention. The deviation is justified under _Idiomatic adaptations_.

```text
naive_sort/
├── naive_sort/                 # metapaquete (info.rkt)
├── naive_sort-lib/             # el código (naive-sort.rkt, con guiones)
├── naive_sort-test/            # las suites (tests/)
├── naive_sort-doc/             # scribblings
├── Makefile
└── .gitignore
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El código y la suite se escribieron a mano y después el módulo se homologó al layout de cuatro colecciones del estándar de Racket del repositorio (`raco new library {module}`), el mismo que usan `data_structures_basics`, `numbers` y `calculator`: cada colección lleva su `info.rkt` y el runner es `raco test -x .`.

**EN:** The code and the suite were written by hand and the module was later homologated to the repository's Racket standard four-collection layout (`raco new library {module}`), the same one used by `data_structures_basics`, `numbers` and `calculator`: each collection carries its `info.rkt` and the runner is `raco test -x .`.

**Combinación aplicada:** TCO ✅ + iteración ✅ → los tres algoritmos son iterativos y `bubble-sort` añade un `let pass` recursivo en posición de cola = **1 suite × 3 escenarios = 24 checks**.

**Applied combination:** TCO ✅ + iteration ✅ → the three algorithms are iterative and `bubble-sort` adds a `let pass` recursion in tail position = **1 suite × 3 scenarios = 24 checks**.

### Inicialización / Initialization

```bash
# Homologar el módulo al layout de cuatro colecciones
mkdir -p naive_sort-lib naive_sort-test/tests naive_sort-doc/scribblings naive_sort

# Mover el código al nombre con guiones y la suite al directorio tests/
mv src/naive_sort.rkt naive_sort-lib/naive-sort.rkt
mv test/naive_sort_tests.rkt naive_sort-test/tests/naive_sort_tests.rkt
```

---

## 📄 Configuración clave / Key Configuration

| Archivo / File | Propósito / Purpose |
|---|---|
| `naive_sort-lib/info.rkt` | Declara la colección de biblioteca y sus dependencias (`base`). |
| `naive_sort-test/info.rkt` | Declara la colección de pruebas y su dependencia de `rackunit`. |
| `Makefile` | Objetivo `test` = `raco test -x .`; el resto son objetivos estándar. |

**ES:** No hay dependencias externas descargadas: `rackunit` viene con la distribución estándar de Racket. La suite importa el módulo **por ruta relativa** (`"../../naive_sort-lib/naive-sort.rkt"`), así que no hace falta instalar ni enlazar el paquete.

**EN:** No external dependencies are downloaded: `rackunit` ships with the standard Racket distribution. The suite imports the module **by relative path** (`"../../naive_sort-lib/naive-sort.rkt"`), so no package install or link is needed.

### `naive_sort-lib/naive-sort.rkt` — Implementación

**ES:** Los tres algoritmos comprueban primero la entrada inválida y la lista vacía, y después ordenan sobre un **vector** (`list->vector`) y devuelven una lista nueva (`vector->list`). Extracto de `bubble-sort`, que conserva la bandera de intercambio y la salida temprana del pseudocódigo:

**EN:** All three algorithms first check the invalid input and the empty list, and then sort on a **vector** (`list->vector`) and return a new list (`vector->list`). Excerpt from `bubble-sort`, which keeps the swap flag and the pseudocode's early exit:

```racket
(define (bubble-sort arr)
  (cond
    [(not (list? arr)) #f]
    [(or (null? arr) (null? (cdr arr))) arr]
    [else
     (define v (list->vector arr))
     (define n (vector-length v))
     (let pass ([i 0] [swapped #t])
       (cond
         [(or (>= i (- n 1)) (not swapped)) (vector->list v)]
         [else
          (define did-swap #f)
          (for ([j (in-range 0 (- n 1 i))])
            (when (> (vector-ref v j) (vector-ref v (add1 j)))
              (define temp (vector-ref v j))
              (vector-set! v j (vector-ref v (add1 j)))
              (vector-set! v (add1 j) temp)
              (set! did-swap #t)))
          (pass (add1 i) did-swap)]))]))
```

| Algoritmo | Estrategia implementada |
| --------- | ----------------------- |
| `selection-sort` | Doble `for` que busca el índice del mínimo del tramo no ordenado y lo intercambia con la posición actual |
| `bubble-sort` | `let pass` por pasada con `for` adyacente y bandera `did-swap` que decide si repite |
| `insertion-sort` | `for` con `key` y un `let shift` que desplaza a la derecha los elementos mayores antes de colocar la clave |

### `naive_sort-test/tests/naive_sort_tests.rkt` — Suite rackunit

**ES:** Una única suite con un escenario por algoritmo. Los 8 casos viven en una tabla compartida y un único ejecutor los recorre para cualquier función; el mensaje del contrato viaja como primer argumento de `check-contract`:

**EN:** A single suite with one scenario per algorithm. The 8 cases live in a shared table and a single executor walks them for any function; the contract message travels as `check-contract`'s first argument:

```racket
(define (check-sorts-all-cases sort-function algorithm)
  (for ([c (in-list cases)])
    (match-define (list description input expected) c)
    (check-contract (format "~a should sort ~a" algorithm description)
                    (sort-function input)
                    expected)))

(module+ test
  (check-sorts-all-cases selection-sort "selection_sort")
  (check-sorts-all-cases bubble-sort "bubble_sort")
  (check-sorts-all-cases insertion-sort "insertion_sort"))
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

**ES:** Racket compila a bytecode con `raco make`, que es también el análisis estático del módulo y de la suite: sin salida significa compilación limpia.

**EN:** Racket compiles to bytecode with `raco make`, which is also the static analysis of the module and the suite: no output means a clean compilation.

```bash
cd racket/core/algorithms/naive_sort
raco make naive_sort-lib/naive-sort.rkt naive_sort-test/tests/naive_sort_tests.rkt
```

```text
(sin salida, exit 0)
```

### Ejecutar las pruebas / Run tests

Desde la raíz del proyecto:

```bash
cd racket/core/algorithms/naive_sort
raco test -x .        # equivale a make test
```

**Salida real / Actual output:**

```text
$ raco test -x .
raco test: (submod (file "./naive_sort-test/tests/naive_sort_tests.rkt") test)
24 tests passed
```

> **ES:** Los 24 checks del contrato (8 casos × 3 algoritmos) pasan en un solo escenario por algoritmo. Un fallo se reporta así: `FAILURE` + `message: "bubble_sort should sort an unsorted array"` + `actual` frente a `expected`. `raco test -x .` devuelve código **1** cuando algún caso falla.
> **EN:** The contract's 24 checks (8 cases × 3 algorithms) pass, one scenario per algorithm. A failure is reported as: `FAILURE` + `message: "bubble_sort should sort an unsorted array"` + `actual` versus `expected`. `raco test -x .` returns exit code **1** when any case fails.

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Algoritmo | Función | Estrategia | Entrada ordenada | Entrada invertida |
|-----------|---------|-----------|:----------------:|:-----------------:|
| Selection sort | `selection-sort` | Doble `for`: el mínimo del tramo no ordenado se intercambia con la posición actual | $O(n^2)$ | $O(n^2)$ |
| Bubble sort | `bubble-sort` | `for` adyacente con bandera `did-swap` que repite solo si hubo intercambios (**salida temprana**) | $O(n)$ | $O(n^2)$ |
| Insertion sort | `insertion-sort` | Inserta cada clave en su posición desplazando a la derecha los elementos mayores | $O(n)$ | $O(n^2)$ |

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

### 🧬 Se ordena un vector y se devuelve una lista nueva / A vector is sorted and a new list is returned

**ES:** El pseudocódigo ordena el propio array con `swap(arr, i, j)`. Las listas de Racket son **inmutables** y acceder a un índice con `list-ref` cuesta $O(n)$, de modo que cada intercambio sobre una lista costaría $O(n)$ y el algoritmo resultante sería $O(n^3)$: el pseudocódigo pide una **secuencia indexable**, así que los tres algoritmos copian la entrada a un **vector** ($O(n)$), ordenan con `vector-set!` y devuelven una **lista nueva** con `vector->list`. La entrada queda intacta (la variante «copia ordenada» que la especificación permite) y eso es lo que mantiene la cota $O(n^2)$ prometida. Por eso los tests **no necesitan copiar** el fixture: es imposible que un caso contamine al siguiente.

**EN:** The pseudocode sorts the array itself with `swap(arr, i, j)`. Racket lists are **immutable** and `list-ref` costs $O(n)$, so each swap on a list would cost $O(n)$ and the resulting algorithm would be $O(n^3)$: the pseudocode asks for an **indexable sequence**, so all three algorithms copy the input into a **vector** ($O(n)$), sort with `vector-set!` and return a **new list** with `vector->list`. The input is left untouched (the "sorted copy" variant the specification allows) and that is what keeps the promised $O(n^2)$ bound. That is why the tests **need no copy** of the fixture: a case cannot contaminate the next one.

### 🚫 Caso nulo/inválido incluido: `#f` como indicador de fallo / Null/invalid case included: `#f` as the failure indicator

**ES:** La especificación pide devolver el indicador de fallo del lenguaje si la entrada es nula o inválida, sin lanzar excepciones. En Racket la lista vacía **es** `null` (`(null? '())` da `#t`), de modo que el indicador de fallo es **`#f`**, que sí distingue una entrada nula o inválida de la lista vacía: las tres funciones comprueban `(not (list? arr))` y devuelven `#f`, y el caso vacío se resuelve por separado devolviendo **la misma lista vacía** (`[(or (null? arr) (null? (cdr arr))) arr]`, el `if n <= 1 return arr` del pseudocódigo).

**EN:** The specification requires returning the language's failure indicator when the input is null or invalid, without throwing exceptions. In Racket the empty list **is** `null` (`(null? '())` is `#t`), so the failure indicator is **`#f`**, which does distinguish a null or invalid input from the empty list: all three functions check `(not (list? arr))` and return `#f`, and the empty case is resolved separately by returning **the same empty list** (`[(or (null? arr) (null? (cdr arr))) arr]`, the pseudocode's `if n <= 1 return arr`).

### 🔁 `bubble-sort` y la bandera de intercambio / `bubble-sort` and the swap flag

**ES:** El criterio de aceptación exige la optimización de salida temprana. `bubble-sort` inicializa `did-swap` en `#f` al empezar cada pasada, lo activa al intercambiar y repite **solo si la bandera quedó en `#t`** (`(pass (add1 i) did-swap)`), que es el `if not swapped then break` del pseudocódigo: una lista ya ordenada se resuelve en **una sola pasada** y el mejor caso es $O(n)$. La bandera **no es observable en la salida** (las tres funciones devuelven una lista ordenada), así que la suite no puede detectar su ausencia: su presencia se verifica comparando el código con el pseudocódigo.

**EN:** The acceptance criteria require the early-exit optimisation. `bubble-sort` initialises `did-swap` to `#f` at the start of each pass, sets it when swapping and repeats **only if the flag ended up `#t`** (`(pass (add1 i) did-swap)`), which is the pseudocode's `if not swapped then break`: an already sorted list is solved in **a single pass** and the best case is $O(n)$. The flag is **not observable in the output** (all three functions return a sorted list), so the suite cannot detect its absence: its presence is verified by comparing the code against the pseudocode.

### 🔀 `insertion-sort`: se desplazan los mayores a la derecha / `insertion-sort`: greater elements are shifted right

**ES:** El `let shift` interno retrocede mientras el elemento sea mayor que la clave (`(> (vector-ref v j) key)`) y **desplaza a la derecha** cada uno (`(vector-set! v (add1 j) (vector-ref v j))`); al terminar coloca la clave en el hueco. La comparación es estricta, así que los elementos iguales no se desplazan y `insertion-sort` es **estable**: el caso 1 (`'(5 2 9 1 5 6)`, con dos cincos) se beneficia de ello, aunque los tests comparan valores y no identidad.

**EN:** The inner `let shift` walks backwards while the element is greater than the key (`(> (vector-ref v j) key)`) and **shifts** each one **right** (`(vector-set! v (add1 j) (vector-ref v j))`); when it stops it places the key in the gap. The comparison is strict, so equal elements are not shifted and `insertion-sort` is **stable**: case 1 (`'(5 2 9 1 5 6)`, with two fives) benefits from it, although the tests compare values rather than identity.

### 🏷️ Naming: kebab-case y nombres de la especificación / Naming: kebab-case and specification names

**ES:** Las funciones usan **kebab-case** (`selection-sort`, `bubble-sort`, `insertion-sort`), que es la convención de Racket, mientras que la especificación las nombra en `snake_case`. El nombre de la especificación se conserva en el **mensaje del contrato** (`"selection_sort should sort an unsorted array"`), de modo que el reporte sigue mostrando `selection_sort`, `bubble_sort` e `insertion_sort`. El parámetro conserva el nombre `arr` de la documentación y el módulo no exporta ningún helper.

**EN:** Functions use **kebab-case** (`selection-sort`, `bubble-sort`, `insertion-sort`), which is Racket's convention, while the specification names them in `snake_case`. The specification name is preserved in the **contract message** (`"selection_sort should sort an unsorted array"`), so the report still shows `selection_sort`, `bubble_sort` and `insertion_sort`. The parameter keeps the documentation's `arr` name and the module exports no helper.

### 🧱 `compiled/` y el bytecode / `compiled/` and bytecode

**ES:** `raco make` deja los `.zo` (y los `compiled/*.dep`) dentro de cada colección; están ignorados por el `.gitignore` del módulo. Al hacer una prueba manual sobre una copia, conviene borrar `compiled/` primero: un `.zo` heredado puede hacer que Racket cargue el módulo antiguo y oculte un cambio del `.rkt`.

**EN:** `raco make` leaves the `.zo` files (and `compiled/*.dep`) inside each collection; they are ignored by the module's `.gitignore`. When running a manual check on a copy, delete `compiled/` first: an inherited `.zo` can make Racket load the old module and hide a change to the `.rkt`.

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| Ubicación esperada `src/` + `test/` | Layout de cuatro colecciones (`-lib`, `-test`, `-doc`, agregador) | Es la convención de paquetes de Racket: cada colección tiene su `info.rkt` y `raco test -x .` descubre los submódulos `test`. El archivo del módulo se llama `naive-sort.rkt` (guiones), que es la convención de nombres de Racket. |
| `test/naive_sort_test.ext` | `naive_sort-test/tests/naive_sort_tests.rkt` | El sufijo va en plural (`_tests.rkt`), como en `data_structures_basics`, `numbers` y `calculator`. |
| `test/run_tests.ext` | Sin archivo `run_tests`: `raco test -x .` descubre los submódulos `test` de cada archivo | El runner es el propio `raco`; un runner manual duplicaría el descubrimiento. |
| Secuencia indexable de enteros | Vector interno (`list->vector`), salida como lista nueva | Las listas de Racket son inmutables y `list-ref` es $O(n)$; el vector conserva la cota $O(n^2)$ del pseudocódigo. |
| Indicador de fallo numérico de otras implementaciones (`-1`) | `#f` | Racket no tiene `null` como valor distinto de la lista vacía; `#f` distingue la entrada inválida de la lista vacía y no colisiona con los enteros de prueba. |
| Identificadores en `snake_case` | kebab-case (`selection-sort`) | Es la convención de nombres de Racket; el nombre de la especificación se conserva en el mensaje del contrato. |

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*[← Volver a Algoritmos Puros](../README.md) · [↑ Volver a Core](../../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
