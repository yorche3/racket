# Hello, World! — Racket

Implementación de la especificación [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) en **Racket**, con un enfoque manual y minimalista.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`helloworld.rkt`](helloworld.rkt) | Código fuente: imprime `"Hello, World! from Racket!"` en la salida estándar. |

**Estructura de directorios esperada:**

```text
helloworld/
├── helloworld.rkt  # Código fuente
└── README.md       # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente, sin herramientas de scaffolding. Un único archivo `.rkt` es suficiente: Racket es un lenguaje interpretado, por lo que no requiere compilación previa para ejecutarse. Opcionalmente se puede compilar a bytecode con `raco make`.

**EN:** The project was created manually, without scaffolding tools. A single `.rkt` file is enough: Racket is an interpreted language, so no prior compilation is required to run it. Optionally, it can be compiled to bytecode with `raco make`.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p racket/core/foundations/helloworld
   ```

2. Escribir el archivo `helloworld.rkt` con el código fuente.

3. No se necesita ningún paso adicional de construcción o vinculación de dependencias.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración de build. El programa se ejecuta directamente con el intérprete `racket`.

```racket
#lang racket

(println "Hello, World! from Racket!")
```

| Elemento | Propósito |
|----------|-----------|
| `#lang racket` | Declara el lenguaje del módulo. Debe ser la **primera** línea del archivo; `racket` es el lenguaje completo estándar. |
| `(println ...)` | Imprime la representación del valor en la salida estándar, seguida de un salto de línea (`\n`). |
| `"Hello, World! from Racket!"` | Argumento: la cadena a imprimir. |

> **ES:** `println` imprime la representación impresa del valor; para cadenas, incluye las comillas. Para imprimir la cadena **sin** comillas se usa `displayln` (mismo resultado visual de `print` en otros lenguajes).
> **EN:** `println` prints the value's printed representation; for strings, it includes the quotes. To print the string **without** quotes, use `displayln` (the same visual result as `print` in other languages).

---

## 🚀 Compilación y ejecución / Build & Run

### Requisito: Tener Racket instalado

```bash
# Verificar instalación
racket --version
```

### Ejecutar directamente / Run directly

```bash
cd racket/core/foundations/helloworld
racket helloworld.rkt
```

### Compilar con `raco make` (opcional) / Compile with `raco make` (optional)

**ES:** `raco make` compila el módulo a bytecode (`.zo` en `compiled/`), que el intérprete carga sin recompilar.

**EN:** `raco make` compiles the module to bytecode (`.zo` under `compiled/`), which the interpreter loads without recompiling.

```bash
cd racket/core/foundations/helloworld
raco make helloworld.rkt
racket helloworld.rkt
```

### Salida esperada / Expected output

```text
"Hello, World! from Racket!"
```

> **ES:** Con `println`, la salida incluye las comillas por ser la representación de una cadena.
> **EN:** With `println`, the output includes the quotes because that is the representation of a string.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Racket no requiere una función `main`: el script se ejecuta de arriba a abajo como en lenguajes de scripting.
- **EN:** Racket does not require a `main` function: the script executes top to bottom like in scripting languages.
- **ES:** `println` escribe en `stdout` y añade automáticamente un salto de línea.
- **EN:** `println` writes to `stdout` and automatically appends a newline.
- **ES:** Todo archivo `.rkt` empieza con `#lang <nombre>`; sin esa línea, `racket` lo trata como código del lenguaje base y produce un error de sintaxis en la primera expresión entre paréntesis.
- **EN:** Every `.rkt` file starts with `#lang <name>`; without that line, `racket` treats it as base language code and raises a syntax error on the first parenthesized expression.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
