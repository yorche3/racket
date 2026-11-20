# Data Structures Advanced — Racket

Implementación de la especificación [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) en **Racket**, con un paquete de colecciones generado por `raco new library` y pruebas con **rackunit** mediante `raco test`.

**ES:** Un `struct` `tree-node` con dos enlaces, un `struct` `binary-tree` con contador propio, un `struct` `graph-node` que encadena el registro canónico de vértices y un `struct` `graph` con contadores separados. No se delega en `set`, `hash` ni en las rutinas de búsqueda de la biblioteca: el recorrido, la inserción ordenada de vecinos y la pertenencia se escriben a mano.

**EN:** A `tree-node` struct with two links, a `binary-tree` struct with its own counter, a `graph-node` struct that links the canonical vertex registry, and a `graph` struct with separate counters. Nothing delegates to `set`, `hash` or the library's search routines: traversal, ordered neighbour insertion and membership are written by hand.

---

## 📂 Archivos y estructura / Files & Structure

El generador de Racket produce un paquete **multi-colección**: una colección por biblioteca, pruebas y documentación, más un paquete meta que las agrupa. El código del módulo vive en `data_structures_advanced-lib/`, no en la raíz del módulo.

| Archivo / Directorio | Propósito / Purpose |
|---|---|
| `data_structures_advanced-lib/data-structures-advanced.rkt` | Biblioteca del módulo: structs, contrato público y las 19 operaciones. / Module library: structs, public contract and the 19 operations. |
| `data_structures_advanced-lib/info.rkt` | Metadatos de la colección `data_structures_advanced`; declara la dependencia `base`. / Collection metadata; declares the `base` dependency. |
| `data_structures_advanced-test/tests/tree-node-tests.rkt` | Casos `TreeNode` (6). / `TreeNode` cases (6). |
| `data_structures_advanced-test/tests/binary-tree-tests.rkt` | Casos `BinaryTree` (7). / `BinaryTree` cases (7). |
| `data_structures_advanced-test/tests/graph-tests.rkt` | Casos `Graph` (11). / `Graph` cases (11). |
| `data_structures_advanced-test/tests/contract.rkt` | Ejecutor compartido: `check-contract` y `succeeded?`. / Shared runner: `check-contract` and `succeeded?`. |
| `data_structures_advanced-test/tests/data_structures_advanced.rkt` | Runner agregado de la plantilla: suite vacía que informa 0 tests; los casos se ejecutan desde los tres archivos anteriores. / Template aggregate runner: an empty suite reporting 0 tests; the cases run from the three files above. |
| `data_structures_advanced-test/info.rkt` | Metadatos de la colección de pruebas; `rackunit-lib` como dependencia de construcción. / Test collection metadata; `rackunit-lib` as a build dependency. |
| `data_structures_advanced-doc/scribblings/data_structures_advanced.scrbl` | Documentación Scribble de la plantilla. / Template Scribble documentation. |
| `data_structures_advanced/info.rkt` | Paquete meta: agrupa `-lib`, `-test` y `-doc`. / Meta package grouping `-lib`, `-test` and `-doc`. |
| `Makefile` | Objetivos `build`, `test` (`raco test -x .`), `clean`, `install`. / `build`, `test` (`raco test -x .`), `clean`, `install` targets. |
| `.gitignore` | Ignora `compiled/`, `/doc/`, `coverage` y archivos de editor. / Ignores `compiled/`, `/doc/`, `coverage` and editor files. |

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El paquete se creó con `raco new library data_structures_advanced`, que descarga la plantilla de `github.com/racket-library` y genera `data_structures_advanced-lib`, `-test`, `-doc` y el paquete meta. Los archivos de la plantilla se renombraron a la convención del repositorio: el código quedó en `data_structures_advanced-lib/data-structures-advanced.rkt` (guiones) y la suite en `data_structures_advanced-test/tests/{tree-node,binary-tree,graph}-tests.rkt`. El módulo de pruebas requiere la biblioteca por ruta relativa (`../../data_structures_advanced-lib/data-structures-advanced.rkt`), así que no hace falta enlazar paquetes para ejecutar la suite.

**EN:** The package was created with `raco new library data_structures_advanced`, which downloads the `github.com/racket-library` template and generates `data_structures_advanced-lib`, `-test`, `-doc` and the meta package. Template files were renamed to the repository convention: the code landed in `data_structures_advanced-lib/data-structures-advanced.rkt` (hyphens) and the suite in `data_structures_advanced-test/tests/{tree-node,binary-tree,graph}-tests.rkt`. The test module requires the library by relative path (`../../data_structures_advanced-lib/data-structures-advanced.rkt`), so no package linking is needed to run the suite.

---

## 📄 Configuración clave / Key Configuration

**ES:** Cada colección declara su `#lang info`. La biblioteca depende solo de `base`, que ya incluye `racket/list` (de ahí salen `empty?`, `first`, `rest` e `in-list`). La colección de pruebas declara `rackunit-lib` en `build-deps`. La documentación declara `scribble-lib`, `racket-doc` y `sandbox-lib`.

**EN:** Each collection declares its own `#lang info`. The library depends only on `base`, which already includes `racket/list` (source of `empty?`, `first`, `rest` and `in-list`). The test collection declares `rackunit-lib` under `build-deps`. The documentation declares `scribble-lib`, `racket-doc` and `sandbox-lib`.

---

## 🚀 Compilación y ejecución / Build & Run

```bash
make build      # raco setup --no-docs --tidy --pkgs data_structures_advanced-lib
make test       # raco test -x .
```

**Salida real / Actual output:**

```text
$ raco test -x .
raco test: (submod (file "./data_structures_advanced-test/tests/binary-tree-tests.rkt") test)
raco test: (submod (file "./data_structures_advanced-test/tests/data_structures_advanced.rkt") test)
0 success(es) 0 failure(s) 0 error(s) 0 test(s) run
raco test: (submod (file "./data_structures_advanced-test/tests/graph-tests.rkt") test)
raco test: (submod (file "./data_structures_advanced-test/tests/tree-node-tests.rkt") test)
158 tests passed
```

Acta del sprint / Sprint evidence record: [`racket.md`](../../../../docs/evidence/algorithms/data_structures_advanced/racket.md).

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

La complejidad usa `h` para la altura del árbol, `V` para los vértices registrados y `d` para los vecinos de un vértice.

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `tree-node-init` | `integer → tree-node` | `O(1)` | Construye el nodo con ambos enlaces ausentes (`#f`). / Builds the node with both links absent (`#f`). |
| `tree-node-get-value` | `tree-node → integer` | `O(1)` | Accesor del campo `value`. / `value` field accessor. |
| `tree-node-get-left` | `tree-node → tree-node \| #f` | `O(1)` | Enlace izquierdo. / Left link. |
| `tree-node-get-right` | `tree-node → tree-node \| #f` | `O(1)` | Enlace derecho. / Right link. |
| `tree-node-set-left` | `tree-node, tree-node \| #f → tree-node` | `O(1)` | Copia el nodo con el enlace nuevo; el original no cambia. / Copies the node with the new link; the original is unchanged. |
| `tree-node-set-right` | `tree-node, tree-node \| #f → tree-node` | `O(1)` | Igual, sobre el enlace derecho. / Same, on the right link. |
| `binary-tree-init` | `→ binary-tree` | `O(1)` | Raíz ausente y contador 0. / Absent root and counter 0. |
| `binary-tree-insert` | `binary-tree, integer → binary-tree` | `O(h)` | Reconstruye el camino hasta la hoja; un duplicado devuelve el mismo árbol. / Rebuilds the path to the leaf; a duplicate returns the same tree. |
| `binary-tree-contains` | `binary-tree, integer → boolean` | `O(h)` | Descenso por la invariante del ABB. / Descent by the BST invariant. |
| `binary-tree-is-empty` | `binary-tree → boolean` | `O(1)` | Contador en 0. / Counter at 0. |
| `binary-tree-size` | `binary-tree → integer` | `O(1)` | Valores distintos guardados. / Distinct values stored. |
| `graph-init` | `→ graph` | `O(1)` | Registro ausente y ambos contadores en 0. / Absent registry and both counters at 0. |
| `graph-add-vertex` | `graph, integer → graph` | `O(V)` | Busca el duplicado y, si no existe, antepone un nodo que comparte la cola del registro. / Looks up the duplicate and, when absent, prepends a node sharing the registry tail. |
| `graph-add-edge` | `graph, integer, integer → graph \| #f` | `O(V + d)` | Comprueba ambos extremos, descarta duplicados e inserta el vecino en orden. / Checks both endpoints, skips duplicates and inserts the neighbour in order. |
| `graph-has-edge` | `graph, integer, integer → boolean` | `O(V + d)` | Localiza el origen y recorre su adyacencia. / Finds the source and walks its adjacency. |
| `graph-get-neighbors` | `graph, integer → list \| #f` | `O(V)` | Lista inmutable de etiquetas ordenadas. / Immutable list of sorted labels. |
| `graph-is-empty` | `graph → boolean` | `O(1)` | Registro ausente. / Absent registry. |
| `graph-vertex-count` | `graph → integer` | `O(1)` | Contador propio. / Own counter. |
| `graph-edge-count` | `graph → integer` | `O(1)` | Contador propio, independiente del de vértices. / Own counter, independent of the vertex one. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Structs inmutables | Structs `#:mutable`, como en `data_structures_basics` | El contrato de Racket es la variante V2 (inmutable): las actualizaciones devuelven un valor nuevo y así el caso 11 puede comprobar que el resultado guardado no cambia con altas posteriores. |
| Registro canónico como cadena de `graph-node` por `next-vertex`, compartiendo la cola | `list` de Racket con los nodos | El contrato describe un registro enlazado con búsqueda lineal; la cadena usa el campo `next-vertex` que ya declara el struct y el alta reutiliza la cola en vez de copiar el registro entero. |
| `#f` como indicador de fallo | `(values ok graph)` o excepción | `#f` es lo que Racket devuelve en sus propias búsquedas (`member`, `assoc`) y deja `'()` libre como valor legítimo de «sin vecinos». |
| `has-neighbor?` e `insert-neighbor` propias | `member` y `sort` de la biblioteca | La Fase 1 prohíbe las rutinas de búsqueda y ordenamiento de la biblioteca para el paso interno del algoritmo. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `TreeNode.init`, `set_left`, `Graph.add_edge` (snake_case) | `tree-node-init`, `tree-node-set-left`, `graph-add-edge` (kebab-case) | Convención de identificadores de Racket; la suite usa los mismos nombres y los mensajes de prueba conservan el nombre del spec. / Racket identifier convention; the suite uses the same names and test messages keep the spec's names. |
| `init` como constructor de la estructura | Funciones `tree-node-init`, `binary-tree-init` y `graph-init` que devuelven la instancia | Un `struct` de Racket exige todos sus campos en el constructor, así que el `init` del contrato no puede ser el constructor sin pedir los enlaces ausentes. / A Racket `struct` requires every field in its constructor, so the contract's `init` cannot be the constructor without asking for the absent links. |
| `set_left` / `set_right` mutan el nodo | `tree-node-set-left` / `tree-node-set-right` devuelven un nodo nuevo | Los structs del módulo son inmutables (V2). / The module's structs are immutable (V2). |
| `BinaryTree.insert` devuelve éxito o fallo | Devuelve el árbol resultante; el duplicado devuelve el mismo árbol | Sin mutación el éxito se observa en el árbol devuelto y en `size`/`contains`; la inserción no tiene condición de fallo en el contrato. / Without mutation, success is observed in the returned tree and in `size`/`contains`; insertion has no contractual failure condition. |
| `Graph.add_edge` devuelve éxito o fallo | Devuelve el grafo nuevo en el éxito y `#f` si falta un extremo | Es la forma de expresar «el fallo no muta ni crea vértices» sin mutación: el fallo no produce grafo. / It is how "failure neither mutates nor creates vertices" is expressed without mutation: failure yields no graph. |
| Caso 11: «si el resultado es mutable, modificar otra copia devuelta» | **Omitido** (no representable): la lista devuelta es inmutable | El caso se ejecuta con el resto de sus comprobaciones — resultado guardado `[30]`, consulta nueva `[30,50]`, 3 vértices y 2 aristas —; solo se omite el paso de modificar la copia, y se declara en _Cobertura de pruebas_. / The case runs with its other checks — saved result `[30]`, fresh query `[30,50]`, 3 vertices and 2 edges —; only the copy-mutation step is omitted, and it is declared under _Test coverage_. |
| Ubicación esperada de la suite | `data_structures_advanced-test/tests/{tree-node,binary-tree,graph}-tests.rkt` | La plantilla de Racket usa una colección de pruebas aparte, no un directorio `tests/` en la raíz; el runner `raco test -x .` recorre los tres archivos. / The Racket template uses a separate test collection rather than a root `tests/` directory; the `raco test -x .` runner walks all three files. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `tree-node-get-left`, `tree-node-get-right` | Enlace ausente / Absent link | `#f` | `(tree-node-get-left (tree-node-init 10))` → `#f` |
| `binary-tree-contains` | Valor ausente del árbol / Value absent from the tree | `#f` | `(binary-tree-contains (binary-tree-init) 50)` → `#f` |
| `binary-tree-insert` | Sin condición de fallo en el contrato / No contractual failure condition | Devuelve el árbol (el mismo si el valor ya estaba) / Returns the tree (the same one when the value was already there) | `(binary-tree-insert tree 30)` con `30` repetido → el mismo árbol / the same tree |
| `graph-add-edge` | Extremo `u` o `v` no registrado / Endpoint `u` or `v` not registered | `#f` | `(graph-add-edge g 10 99)` → `#f` |
| `graph-has-edge` | Arista ausente o extremo no registrado / Absent edge or unregistered endpoint | `#f` | `(graph-has-edge g 70 10)` → `#f` |
| `graph-get-neighbors` | Vértice no registrado / Vertex not registered | `#f`, distinto de `'()` / distinct from `'()` | `(graph-get-neighbors g 99)` → `#f`; `(graph-get-neighbors g 10)` aislado → `'()` |
| Entrada nula o inválida | Parámetros que no son del tipo del contrato / Arguments outside the contract types | No representable: los structs no admiten `#f` como instancia / Not representable: structs do not accept `#f` as an instance | La suite no ejerce ese caso / The suite does not exercise that case |

---

## ✅ Cobertura de pruebas / Test coverage

Unidad y variante: una sola variante del contrato, la V2 inmutable de Racket. Grupo lógico → archivo → runner: `TreeNode`, `BinaryTree` y `Graph` en su propio archivo, ejecutados por `raco test -x .`. Cada fila es un caso del spec; un archivo contiene un bloque `module+ test` por unidad y el ejecutor compartido `contract.rkt` normaliza los indicadores.

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| **TreeNode:** Crear un nodo de árbol / Create a tree node | Sí | `tree-node-tests.rkt:20` | `tree-node-init` y `get-value`. |
| **TreeNode:** Enlaces iniciales ausentes / Absent initial links | Sí | `tree-node-tests.rkt:25` | Ambos enlaces `#f`. / Both links `#f`. |
| **TreeNode:** Enlazar dos hijos / Link two children | Sí | `tree-node-tests.rkt:30` | `set-left` y `set-right` encadenados. / Chained `set-left` and `set-right`. |
| **TreeNode:** Recorrer cada enlace / Traverse each link | Sí | `tree-node-tests.rkt:37` | Hijos y enlaces de los hijos. / Children and children's links. |
| **TreeNode:** Desenlazar hijos / Unlink children | Sí | `tree-node-tests.rkt:48` | Izquierdo y luego derecho. / Left, then right. |
| **TreeNode:** Adaptación inmutable / Immutable adaptation | Sí | `tree-node-tests.rkt:60` | El original conserva el enlace ausente. / The original keeps the absent link. |
| **BinaryTree:** Crear vacío / Create empty | Sí | `binary-tree-tests.rkt:33` | `is-empty`, `size`, `contains`. |
| **BinaryTree:** Insertar la raíz / Insert the root | Sí | `binary-tree-tests.rkt:39` | Tamaño 1 y pertenencia. / Size 1 and membership. |
| **BinaryTree:** Insertar menor y mayor / Insert lower and higher | Sí | `binary-tree-tests.rkt:45` | `50`, `30`, `70`. |
| **BinaryTree:** Ramas de varios niveles / Multilevel branches | Sí | `binary-tree-tests.rkt:51` | `50`, `30`, `70`, `20`, `40`. |
| **BinaryTree:** Valor ausente en árbol no vacío / Missing value in nonempty tree | Sí | `binary-tree-tests.rkt:57` | `contains(99)` falla, tamaño 1. |
| **BinaryTree:** Duplicado idempotente / Idempotent duplicate | Sí | `binary-tree-tests.rkt:63` | Tamaño 3 tras repetir `30`. / Size 3 after repeating `30`. |
| **BinaryTree:** Inserciones ordenadas / Ordered insertions | Sí | `binary-tree-tests.rkt:69` | `20`, `30`, `40`, `50`, `70`. |
| **Graph:** Crear vacío / Create empty | Sí | `graph-tests.rkt:36` | Contadores y consultas fallidas. / Counters and failed queries. |
| **Graph:** Vértice aislado / Isolated vertex | Sí | `graph-tests.rkt:43` | Vecinos `'()`. / Neighbours `'()`. |
| **Graph:** Etiquetas no consecutivas y arista dirigida / Nonconsecutive labels and directed edge | Sí | `graph-tests.rkt:49` | `has-edge(70,10)` falla. / Fails. |
| **Graph:** Vértice duplicado conserva adyacencia / Duplicate vertex preserves adjacency | Sí | `graph-tests.rkt:56` | Contadores intactos. / Counters intact. |
| **Graph:** Arista duplicada / Duplicate edge | Sí | `graph-tests.rkt:63` | Una sola arista contada. / A single edge counted. |
| **Graph:** Extremo inexistente sin mutación / Missing endpoint without mutation | Sí | `graph-tests.rkt:70` | Cuatro intentos fallidos; estado intacto. / Four failed attempts; state intact. |
| **Graph:** Vecinos ordenados y contadores / Sorted neighbours and counts | Sí | `graph-tests.rkt:87` | `[30,50,70]` y 4 aristas. / `[30,50,70]` and 4 edges. |
| **Graph:** Consulta de arista ausente / Missing-edge query | Sí | `graph-tests.rkt:100` | 2 vértices, 0 aristas. / 2 vertices, 0 edges. |
| **Graph:** Vecinos de vértice inexistente / Neighbours of missing vertex | Sí | `graph-tests.rkt:106` | `#f` frente a `'()`. / `#f` versus `'()`. |
| **Graph:** Bucle y duplicado / Self-loop and duplicate | Sí | `graph-tests.rkt:112` | Vecinos `[10]`, 1 arista. / Neighbours `[10]`, 1 edge. |
| **Graph:** Aislamiento del resultado de vecinos / Neighbour-result isolation | Sí | `graph-tests.rkt:120` | Paso de mutación omitido (lista inmutable); resto verificado. / Mutation step omitted (immutable list); the rest is verified. |

Totales: 24 casos del spec en 3 archivos, **158 aserciones** de rackunit. Por archivo: 20 (`tree-node-tests`), 49 (`binary-tree-tests`) y 89 (`graph-tests`).

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| `tree-insert-node` no es recursión de cola: reconstruye el camino de la raíz a la hoja | Inserciones estrictamente ordenadas consumen pila `O(n)` | Es el coste de la inmutabilidad: el camino debe copiarse. La alternativa —structs mutables— cambiaría la variante del contrato. / This is the cost of immutability: the path must be copied. The alternative — mutable structs — would change the contract's variant. |
| Búsqueda de vértices lineal sobre el registro enlazado | `O(V)` por consulta de arista o de vecinos | Es lo que fija el contrato (registro enlazado sin índice); un `hash` sería otra estructura. / This is what the contract fixes (linked registry without an index); a `hash` would be a different structure. |
| Inserción de vecinos `O(d)` por arista | Coste lineal en la adyacencia al añadir una arista | La adyacencia ordenada permite comparar listas completas en las pruebas. / Sorted adjacency lets tests compare whole lists. |

---

## 📝 Notas de implementación / Implementation Notes

- **Recursión e iteración:** `tree-insert-node` recursa por el camino del ABB y devuelve dos valores con `define-values` (`nodo`, `insertado?`); `tree-contains-node` desciende con `cond`. `find-vertex`, `has-neighbor?`, `insert-neighbor` y `update-neighbors` recorren o reconstruyen estructuras enlazadas. Racket garantiza llamadas en cola propias, pero `insert-neighbor` y `update-neighbors` no están en posición de cola porque construyen el resultado con `cons`.
- **Indicadores:** la ausencia y el fallo son `#f`; el ejecutor compartido `succeeded?` normaliza «cualquier valor distinto de `#f`» a booleano, así que el éxito de un alta se comprueba sobre el valor devuelto.
- **Mutabilidad:** ningún struct es `#:mutable`; `graph-add-vertex` y `graph-add-edge` devuelven un `graph` nuevo y el registro se comparte por la cola.
- **Organización de pruebas:** un archivo por unidad con bloques `module+ test`, el ejecutor compartido en `contract.rkt` y `raco test -x .` como runner, que recorre los tres archivos y propaga los fallos. El runner agregado de la plantilla (`tests/data_structures_advanced.rkt`) conserva una suite vacía.
- **Documentación:** el paquete `-doc` conserva la plantilla Scribble; este README es la documentación del módulo.

**ES:** Este proyecto también está implementado en otros lenguajes. Explora el repositorio principal para consultar las demás versiones.

**EN:** This project is also implemented in other languages. Explore the main repository to see the other versions.

---

## 🔍 Checklist de validación / Validation checklist

- [x] La suite nativa se ejecutó y su salida real está copiada en este README.
- [x] Cada caso de la especificación tiene su fila en _Cobertura de pruebas_ (o `Omitido` con razón).
- [x] Cada desviación del pseudocódigo o de la ubicación esperada está en _Adaptaciones idiomáticas_.
- [x] Cada operación con fallo posible está en _Indicadores de fallo_.
- [x] No hay rutas absolutas del autor, credenciales ni salidas inventadas.
- [x] Los enlaces relativos resuelven dentro del repositorio y el documento es bilingüe.
- [x] Ninguna sección repite lo que ya dice la especificación.

---

## 📚 Referencias / References

| Tipo / Kind | Referencia / Reference |
|---|---|
| Especificación / Specification | [`07_Data_Structures_Advanced.md`](../../../../docs/core/algorithms/07_Data_Structures_Advanced.md) |
| Primera base del lenguaje / First language reference | `data_structures_basics` — [`README.md`](../data_structures_basics/README.md) |
| Segunda base del lenguaje / Second language reference | `numbers` — [`README.md`](../../foundations/numbers/README.md) |
| Plantilla de este README / This README's template | [`README_Template.md`](../../../../docs/README_Template.md) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](../../../../docs/AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](../../../../docs/WORKFLOW.md) |
| Documentación oficial del lenguaje / Language official docs | [The Racket Reference](https://docs.racket-lang.org/reference/) |

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
