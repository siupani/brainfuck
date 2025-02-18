# Brainfuck Interpreter

This project is an assembly-based implementation of a Brainfuck interpreter. 
It was made for the course Computer Organisaton - CSE1400 at TU Delft.
It reads Brainfuck code from a file, interprets it, and executes the instructions on a memory tape of 30,000 cells. 
I personally recommend using WSL to run this in Visual Studio Code.

## 📁 Files Overview

- **main.s**:  
  The main function that:
  - Reads a file from a command line argument.
  - Passes the contents to the Brainfuck interpreter (`brainfuck` subroutine in `brainfuck.s`).
  - Handles error cases like incorrect arguments or file reading failures.

- **read_file.s**:  
  A subroutine that:
  - Reads the contents of a file into a newly allocated buffer.
  - Appends a null byte at the end for safety.
  - Returns the buffer's address and the number of bytes read.

- **brainfuck.s**:  
  The core interpreter that:
  - Implements the Brainfuck commands: `<`, `>`, `+`, `-`, `.`, `,`, `[` and `]`.
  - Maintains a tape of 30,000 bytes using `buffer`.
  - Manages nested loops and pointer manipulation.

- **Makefile**:  
  Compilation instructions to build the executable. Simply run:
  ```sh
  make
  ```

## ⚙️ Compilation and Execution

### Compile
To compile the project, navigate to the project directory and run:
```sh
make
```

### Run
Execute the interpreter with:
```sh
./brainfuck <path_to_brainfuck_code>
```
Example:
```sh
./brainfuck examples/hello.bf
```

## 💡 Usage Notes
- The tape is initialized with 30,000 bytes, as per the Brainfuck specification.
- The interpreter handles nested loops efficiently.
- Ensure the input file is in Brainfuck syntax; otherwise, unexpected behavior may occur.

## 📖 Example
- To run mandelbrot.b, do the following:
    ```sh
	make
	./brainfuck mandelbrot.b
    ```

## 🚀 Features
- Full support for Brainfuck commands:
  - `<` and `>` for pointer manipulation.
  - `+` and `-` for byte manipulation.
  - `.` for output and `,` for input.
  - `[` and `]` for loops.
- Efficient loop handling, supporting nested loops.
- Optimized memory usage with a tape of 30,000 cells.

## 🛠️ Requirements
- **Assembler and Linker**: Compatible with `nasm`,`wsl` and `gcc` on Unix-like systems. (I personally use WSL in Visual Studio Code)
- **Make**: To use the provided Makefile for compilation.

## 🔥 Getting Started
1. Clone the repository:
    ```sh
    git clone https://github.com/siupani/brainfuck
    cd brainfuck
    ```
2. Compile using:
    ```sh
    make
    ```
3. Run a Brainfuck file:
    ```sh
    ./brainfuck <path_to_brainfuck_code>
    ```

## 📧 Contact
For questions or suggestions, contact [urumovstepan@gmail.com](mailto:urumovstepan@gmail.com).

