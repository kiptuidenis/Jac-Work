#* 
This is a multi-line comment that will intentionally 
never be closed with an asterisk-hash.
This should trigger an End Of File (EOF) parsing error.

with entry {
    print("This code should never execute");
}
