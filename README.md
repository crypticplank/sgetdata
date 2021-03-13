# sgetdata
A swift utility that converts any data(text or a file) into a swift array to be used to bundle data directly into a swift binary, and not have it be stored elseware

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
