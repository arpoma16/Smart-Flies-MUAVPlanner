# Agentic Coding Guidelines for Smart Flies Multi-UAV Planner

This document outlines the essential commands and code style guidelines for agents operating within the `Smart-Flies-MUAVPlanner` repository. Adhering to these guidelines ensures consistency, maintainability, and compatibility with the existing codebase.

## 1. Build, Lint, and Test Commands

### Build
The project uses `hatchling` as its build backend.
- **Build command**: `hatch build`

### Linting and Formatting
The project uses `black` for code formatting, `isort` for import sorting, `flake8` with various plugins for general linting, `pylint` for static analysis, `docformatter` for docstring formatting, and `pyupgrade` for modernizing syntax.

- **Format code with Black**:
  ```bash
  black .
  ```
- **Sort imports with Isort**:
  ```bash
  isort .
  ```
- **Run Flake8 linting**:
  ```bash
  flake8 .
  ```
- **Run Pylint static analysis**:
  ```bash
  pylint modules # Assuming 'modules' is the main source directory
  ```
- **Check docstring formatting with Docformatter**:
  ```bash
  docformatter -c .
  ```
- **Upgrade Python syntax with Pyupgrade**:
  ```bash
  pyupgrade --py310-plus .
  ```
- **Run all linting/formatting checks (recommended before committing)**:
  ```bash
  black . && isort . && flake8 . && pylint modules && docformatter -c . && pyupgrade --py310-plus .
  ```

### Testing
The project uses `pytest` for unit and integration testing, with `pytest-cov` for coverage reporting.

- **Run all tests**:
  ```bash
  pytest
  ```
- **Run tests in a specific file**:
  ```bash
  pytest <path/to/test_file.py>
  ```
  Example: `pytest tests/test_planner.py`
- **Run a specific test function within a file**:
  ```bash
  pytest <path/to/test_file.py>::<test_function_name>
  ```
  Example: `pytest tests/test_planner.py::test_calculate_path`
- **Run tests with coverage reporting**:
  ```bash
  pytest --cov=modules # Assuming 'modules' is the main source directory
  ```

## 2. Code Style Guidelines

### Imports
- **Ordering**: Imports should be sorted using `isort`. Generally, this means:
  1. Standard library imports
  2. Third-party imports
  3. Local application/library-specific imports
- **Formatting**: Each import should be on its own line. Use absolute imports where possible.

### Formatting
- **Black**: All Python code must be formatted using `black`. This ensures a consistent style across the entire codebase. Do not deviate from `black`'s formatting.
- **Line Length**: Adhere to `black`'s default line length (88 characters).

### Types
- **Type Hints**: Type hints should be used extensively for function arguments, return values, and variables. This improves code readability, maintainability, and enables static analysis.
  - Example: `def func(arg: int) -> str:`
- **Mypy**: While `mypy` is not explicitly listed as a direct dependency, the presence of `mypy-extensions` and `flake8-annotations`/`flake8-typing-imports` strongly suggests that type correctness is important. Ensure type hints are accurate and consistent.

### Naming Conventions
- **PEP 8**: Adhere strictly to PEP 8 naming conventions.
  - **Modules**: `lowercase_with_underscores.py`
  - **Packages**: `lowercase_with_underscores/`
  - **Classes**: `CamelCase`
  - **Functions/Methods**: `lowercase_with_underscores()`
  - **Variables**: `lowercase_with_underscores`
  - **Constants**: `UPPERCASE_WITH_UNDERSCORES`

### Docstrings
- **Style**: Adhere to a consistent docstring style throughout the codebase. The `docformatter` tool is used for checking, which supports PEP 257 and other common styles.
- **Content**: Docstrings should clearly explain the purpose of the module, class, function, or method, its arguments, and what it returns.

### Error Handling
- **Explicit Exceptions**: Use explicit exception handling (e.g., `try...except` blocks) for anticipated errors. Avoid broad `except` clauses without specific exception types.
- **Logging**: Use the standard `logging` module for reporting errors, warnings, and informational messages.

### Comments
- **Clarity over Quantity**: Add comments sparingly, primarily to explain *why* complex logic is implemented in a certain way, rather than *what* the code is doing (which should be clear from the code itself).
- **No TODOs/FIXMEs in final code**: Ensure no `TODO` or `FIXME` comments remain in code intended for production.

### General Guidelines
- **Flake8 & Pylint Compliance**: Ensure all code passes `flake8` and `pylint` checks. Address all warnings and errors reported by these tools.
- **Modularity**: Design code to be modular, with clear separation of concerns.
- **Readability**: Prioritize clear, concise, and readable code.

## 3. Cursor/Copilot Specific Rules

No specific `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` files were found in this repository. Agents should follow the general code style and development guidelines outlined above.
