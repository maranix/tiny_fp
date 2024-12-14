# tiny_fp

<p align="center">
    A Haskell inspired tiny package to do functional programming in dart which doesn't get in your way and provides minimal paradigms along with base types to create your own custom types.
</p>

<p align="center">
    <img src="https://img.shields.io/badge/stage-alpha-red" />
    <img src="https://img.shields.io/pub/v/tiny_fp?" />
    <img src="https://img.shields.io/github/license/maranix/tiny_fp?logo=github" />
</p>

> [!WARNING]
>
> tiny_fp is currently in `alpha` stage and is bound to have some API changes and cleanups as the development progresses further.
> 
> Usage of this package in a production application or environment is not recommended.

## Supported Platforms

| Platform | Supported |
| -------------- | --------------- |
| Windows | ✅ |
| Linux | ✅ |
| macOS | ✅ |
| iOS | ✅ |
| Android | ✅ |

## Table of contents
- [Goals](#goals)
- [Foundational Types](#foundational-types)
- [Built-in Types](#built-in-types)
- [Getting Started](#getting-started)
  - [Dependencies](#dependencies)
  - [Installation](#installation)
- [Usage](#usage)

## Features

## Goals

This package was designed with the following goals in mind:

1. **Minimal Footprint**: Keep the package size as small as possible.
2. **Feature-Rich, Yet Minimal**: Include essential features and paradigms from functional programming to improve readability and maintainability, while avoiding unnecessary complexity.
3. **Extensibility**: Allow users to create their own types based on provided foundational types.

### Foundational Types

| Type  | Derived By                             | Core Purpose                                    | Implemented |
| ------------------- | -------------------------------------- | ---------------------------------------------- | ----------- |
| `SumType<T>`        | `Maybe<T>`, `Either<E, T>`            | A generalized base type for algebraic sum types, representing one of multiple possible values. | ❌ |
| `ProductType<A, B>`| `Tuple`                | Represents a composite type that combines multiple values of different types.                | ❌          |
| `Functor<T>`       | `Maybe<T>`, `Either<E, T>` | Provides a way to apply functions to wrapped values inside a data structure.                  | ✅         |
| `Applicative<T>`   | `Maybe<T>`, `Either<E, T>` | Extends `Functor` to allow applying functions inside a functor to values inside another functor. | ✅          |
| `Monad<T>`         | `Maybe<T>`, `Either<E, T>` | Extends `Applicative` to support chaining of computations that return wrapped values.           | ✅         |
| `Foldable<T>`      | `Maybe<T>` | Allows folding values inside a data structure into a single result.                           | ✅          |

### Built-in Types

| Type      | Derived From            | Purpose                                                   | Implemented |
| ------------------- | ----------------------- | --------------------------------------------------------- | ----------- |
| `Maybe<T>`          | `SumType<T>`            | Represents an optional value (`Just` or `Nothing`).       | ❌          |
| `Either<E, T>`      | `SumType<T>`            | Represents a value that is either a success (`Right`) or an error (`Left`). | ❌          |
| `Tuple<A, B>`     | `ProductType<A, B>`| A tuple containing two values of different types.                                | ❌          |

## Getting Started

To get started with this package, follow the steps below to install.

### Dependencies

> [!IMPORTANT]
> This package requires `Dart 3.6.0` or `Flutter 3.27.0`. Ensure that you are using the correct version before proceeding.

### Installation

```yaml
dependencies:
    tiny_fp: any
```

Run the following command to install the package.

```bash
dart pub get
```

or if you are developing a `Flutter Application`.

```bash
flutter pub get
```

## Usage

TBD
