# Hello, User! — Racket

Implementación de la especificación [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) en **Racket**, con un enfoque manual y minimalista.

Solicita un nombre al usuario por la entrada estándar (estilo prompt) y saluda.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hellouser.rkt`](hellouser.rkt) | Código fuente: solicita un nombre al usuario y saluda. |

**Estructura de directorios esperada:**

```text
hellouser/
├── hellouser.rkt   # Código fuente
└── README.md       # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este programa introduce tres conceptos nuevos respecto a `helloworld`:

1. **Escritura sin salto de línea** — `display` imprime el prompt dejando el cursor en la misma línea.
2. **Entrada de usuario** — `read-line` lee una línea desde la entrada estándar.
3. **Variables y formato de salida** — `define` enlaza un nombre a un valor, y `printf` con `~a` interpola valores en una plantilla.

**EN:** This program introduces three new concepts compared to `helloworld`:

1. **Writing without newline** — `display` prints the prompt leaving the cursor on the same line.
2. **User input** — `read-line` reads a line from standard input.
3. **Variables and output formatting** — `define` binds a name to a value, and `printf` with `~a` interpolates values into a template.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p racket/core/foundations/hellouser
   ```

2. Escribir el archivo `hellouser.rkt` con el código fuente.

3. No se necesita ningún paso adicional de construcción o vinculación de dependencias.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración de build. El programa se ejecuta directamente con el intérprete `racket`.

**ES:** El flujo del programa es:

1. Imprimir `"Enter your name: "` con `display` (sin salto de línea).
2. Leer una línea desde `stdin` con `read-line` y enlazarla a `name` con `define`.
3. Imprimir `"Hello, <nombre>!"` con `printf` y el director `~a`.

**EN:** Program flow:

1. Print `"Enter your name: "` with `display` (no newline).
2. Read a line from `stdin` with `read-line` and bind it to `name` with `define`.
3. Print `"Hello, <name>!"` with `printf` and the `~a` directive.

```racket
#lang racket

(display "Enter your name: ")
(define name (read-line))
(printf "Hello, ~a!\n" name)
```

| Elemento | Propósito |
|----------|-----------|
| `(display ...)` | Imprime su argumento en la salida estándar **sin** salto de línea al final (el cursor permanece junto al prompt). |
| `(read-line)` | Lee una línea desde la entrada estándar y la devuelve como cadena, **sin** el salto de línea final. |
| `(define name ...)` | Enlaza la cadena leída al nombre `name` dentro del módulo. |
| `(printf "Hello, ~a!\n" name)` | Imprime con formato: `~a` interpola `name` (formato de *display*) y `\n` añade el salto de línea. |
| `#lang racket` | Declara el lenguaje del módulo (primera línea obligatoria). |

> **ES:** `printf` admite múltiples directores: `~a` (display), `~s` (representación con comillas), `~v` (representación legible), `~r` (números) o `~%` (nueva línea portátil). `read-line` devuelve `eof` si la entrada ya terminó.
> **EN:** `printf` accepts several directives: `~a` (display), `~s` (representation with quotes), `~v` (readable representation), `~r` (numbers), or `~%` (portable newline). `read-line` returns `eof` if the input has already ended.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisito: Tener Racket instalado

```bash
# Verificar instalación
racket --version
```

### Ejecutar / Run

```bash
cd racket/core/foundations/hellouser
racket hellouser.rkt
```

**ES:** El programa muestra el prompt y espera a que escribas tu nombre y presiones Enter.
**EN:** The program shows the prompt and waits for you to type your name and press Enter.

### Salida esperada / Expected output

```text
Enter your name: Ada
Hello, Ada!
```

> **ES:** También admite entrada redirigida: `printf 'Ada\n' | racket hellouser.rkt` produce el mismo saludo.
> **EN:** It also accepts redirected input: `printf 'Ada\n' | racket hellouser.rkt` produces the same greeting.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Racket no requiere una función `main`: el script se ejecuta de arriba a abajo como en lenguajes de scripting.
- **EN:** Racket does not require a `main` function: the script executes top to bottom like in scripting languages.
- **ES:** Se usa `display` para el prompt (sin comillas ni salto de línea) y `printf` con `~a` para el saludo, que interpola la variable sin comillas.
- **EN:** `display` is used for the prompt (no quotes or newline) and `printf` with `~a` for the greeting, which interpolates the variable without quotes.
- **ES:** `printf` escribe en `stdout`; el salto de línea se incluye explícitamente con `\n` en la plantilla (o con el director `~%`).
- **EN:** `printf` writes to `stdout`; the newline is included explicitly with `\n` in the template (or with the `~%` directive).

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
