# Calculator — Racket

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **Racket**, con **rackunit** como framework de pruebas unitarias — la biblioteca de tests estándar de Racket — y **`raco test`** como runner.

Operaciones aritméticas básicas (`addition`, `subtraction`, `multiplication`, `division`, `modulus`) con implementaciones intuitivas y educativas, validadas mediante pruebas unitarias.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/calculator.rkt`](src/calculator.rkt) | Código fuente: módulo Racket que provee las 5 funciones. |
| [`test/calculator_test.rkt`](test/calculator_test.rkt) | Suite de pruebas: 5 `check-equal?` con rackunit. |
| [`.gitignore`](.gitignore) | Ignora los artefactos compilados (`compiled/`). |

**Estructura de directorios esperada:**

```text
calculator/
├── src/
│   └── calculator.rkt         # Código fuente
├── test/
│   └── calculator_test.rkt    # Suite de pruebas
├── .gitignore
└── README.md                  # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente, sin herramientas de scaffolding. Racket tiene un **sistema de módulos real**: `src/calculator.rkt` declara `(provide ...)` las 5 funciones y la suite las importa con `(require "../src/calculator.rkt")`. Las pruebas usan **rackunit** (incluida en la distribución estándar de Racket) y se ejecutan con **`raco test`**, el runner oficial — por eso no se crea el `run_tests` del pseudocódigo (la especificación lo pide solo si el lenguaje no lo incluye).

**EN:** The project was created manually, without scaffolding tools. Racket has a **real module system**: `src/calculator.rkt` declares `(provide ...)` for the 5 functions and the suite imports them with `(require "../src/calculator.rkt")`. Tests use **rackunit** (bundled with the standard Racket distribution) and run with **`raco test`**, the official runner — that's why the pseudocode's `run_tests` is not created (the specification asks for it only if the language doesn't include one).

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p racket/core/foundations/unit_test/calculator/{src,test}
   ```

2. Escribir `src/calculator.rkt` y `test/calculator_test.rkt`.

3. No se necesita ningún paso adicional de construcción o vinculación de dependencias.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración de build. El módulo se comparte mediante `provide`/`require`.

### `src/calculator.rkt` — Implementaciones educativas

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

### `test/calculator_test.rkt` — Suite rackunit

**ES:** Un `check-equal?` por operación (5 checks, uno por función), cada uno con su mensaje. La línea `(require ...)` importa el módulo `calculator` desde `src/`.

**EN:** One `check-equal?` per operation (5 checks, one per function), each with its message. The `(require ...)` line imports the `calculator` module from `src/`.

```racket
#lang racket

(require rackunit
         "../src/calculator.rkt")

(check-equal? (addition 2 3) 5 "addition")
(check-equal? (subtraction 5 2) 3 "subtraction")
(check-equal? (multiplication 3 4) 12 "multiplication")
(check-equal? (division 10 3) 3 "division")
(check-equal? (modulus 10 3) 1 "modulus")
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

```bash
cd racket/core/foundations/unit_test/calculator
raco test test/calculator_test.rkt
```

### Salida esperada / Expected output

```text
raco test: (file "test/calculator_test.rkt")
5 tests passed
```

> **ES:** `5 tests passed` confirma que las 5 operaciones se verificaron correctamente (equivale al `Tests run: 5, Passed: 5, Failed: 0` de la especificación).
> **EN:** `5 tests passed` confirms that all 5 operations were verified correctly (equivalent to the specification's `Tests run: 5, Passed: 5, Failed: 0`).

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Racket usa módulos reales: `provide` exporta y `require` importa; la ruta relativa en `require` se resuelve respecto al archivo que la usa.
- **EN:** Racket uses real modules: `provide` exports and `require` imports; the relative path in `require` resolves relative to the file that uses it.
- **ES:** Los `let loop` son llamadas de cola: Racket garantiza TCO, así que estos bucles recursivos no consumen pila.
- **EN:** The `let loop`s are tail calls: Racket guarantees TCO, so these recursive loops consume no stack.
- **ES:** La división por cero no se maneja en este ejemplo educativo (según el pseudocódigo de la especificación); las pruebas usan valores válidos.
- **EN:** Division by zero is not handled in this educational example (per the specification's pseudocode); tests use valid values.
- **ES:** No se usa `run_tests.rkt` porque `raco test` ya es el punto de entrada del lenguaje (la especificación pide crearlo solo si el framework no lo incluye).
- **EN:** `run_tests.rkt` is not used because `raco test` is already the language's entry point (the specification asks to create it only if the framework doesn't include one).

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
