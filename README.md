# Decaf Language

this is a compiler project for building a lexical analyzer for Decaf programming language.

## Files

I modefied only `scanner.l` file which is a flex file that contains all regular expression for the language.

## Build && Run

* you first need to add your code in the `c.in` file.
* then you can run the binary file directly using this command:

```
./dcc < c.in
```
* or you can build the program yourself:

```
make
./dcc < c.in
```
## Directed by:

> Dr. Mohamed Al-Ammer


 