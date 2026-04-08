# Test 05: Generators and Asynchrony (Broken)

# 1. Top-level yield (Forbidden)
yield 10; # Error: yield outside of function

def sync_func() {
     # 2. Await in sync function
     # await some_async_op(); 
     return 1;
}

with entry {
     sync_func();
}
