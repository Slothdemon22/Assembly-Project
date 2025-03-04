# Sudoku Solver in 8086 Assembly Language

## Overview
This project is a **Sudoku solver** implemented in **8086 Assembly Language**. It takes an incomplete 9x9 Sudoku grid as input, solves it using a **backtracking algorithm**, and displays the solved grid on the screen. The program demonstrates efficient use of low-level programming techniques, including memory management, stack operations, and recursion, to solve a classic logic puzzle.

---

## Features
- **Input Handling**: Accepts a 9x9 Sudoku grid from the user (0 represents empty cells).
- **Backtracking Algorithm**: Solves the puzzle using recursion and backtracking.
- **Validation**: Ensures the input grid adheres to Sudoku rules.
- **Output Display**: Displays the solved grid in a readable tabular format.
- **Error Handling**: Detects and reports invalid inputs (e.g., duplicate numbers in rows, columns, or subgrids).

---

## How It Works
1. **Input Phase**:
   - The user inputs the Sudoku grid row by row, with 0s representing empty cells.
   - Example input:
     ```
     5 3 0 0 7 0 0 0 0
     6 0 0 1 9 5 0 0 0
     0 9 8 0 0 0 0 6 0
     8 0 0 0 6 0 0 0 3
     4 0 0 8 0 3 0 0 1
     7 0 0 0 2 0 0 0 6
     0 6 0 0 0 0 2 8 0
     0 0 0 4 1 9 0 0 5
     0 0 0 0 8 0 0 7 9
     ```

2. **Solving Phase**:
   - The program uses a **backtracking algorithm** to fill empty cells:
     - Tries numbers from 1 to 9 in each empty cell.
     - Checks for conflicts in the row, column, and 3x3 subgrid.
     - Backtracks if a conflict arises and tries the next number.

3. **Output Phase**:
   - The solved Sudoku grid is displayed on the screen in a tabular format.

---

## Technical Details
- **8086 Architecture**:
  - The program is written for the **8086 microprocessor**, utilizing its 16-bit registers, memory segmentation, and interrupt-based I/O operations.
  - The Sudoku grid is stored as a 9x9 array in memory, with each cell occupying 1 byte.
- **Interrupts**:
  - Uses **INT 21h** for input/output operations.
- **Subroutines**:
  - Includes routines for input, validation, solving, and output.

