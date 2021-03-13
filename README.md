# sgetdata
A swift utility that converts any data(text or a file) into a swift array to be used to bundle data directly into a swift binary, and not have it be stored elseware


Example command 1(Music)

```c
sgetdata /Users/brandonplank/Downloads/whatlove.mp3 -f -o whatislove.swift
```

Example command 2(String)

```c
sgetdata "Hello world"
```

Example command 3(Compress)

```c
sgetdata "Hello world" -c
```

Example command 4(Encrypt)

```c
sgetdata "Hello world" -e supersecretpassword
```

### You can always pair the options.

```c
USAGE: sgetdata <file-string> [--verbose] [--file] [--compress] [--output <output>] [--encrypt <encrypt>]

ARGUMENTS:
  <file-string>           File(use with -f) / String 

OPTIONS:
  -v, --verbose           Verbose output. 
  -f, --file              Specifies that you are using a file, and not a string. 
  -c, --compress          Compress the data to save some space, uses lzma. 
  -o, --output <output>   Specifies the output file to put the code in. 
  -e, --encrypt <encrypt> Encrypt data using AES256 encrytion with a passkey. 
  -h, --help              Show help information.
```
