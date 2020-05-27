# AES Formal verification
Formally verify each module alone, then the whole implementation
- Tool:  [SymbiYosys](https://github.com/YosysHQ/SymbiYosys)

## Contents
- This directory contains the configuration files for the symbiYosys tool
- The formal assertions are in the [source](../src) directory under the `ifdef FORMAL` macro
- to run the formal verification install the tool then run `sby -f module_name.sby` replace `module_name` with the module you wanna verify


## Thoughts
- This is a preliminary version, I'm still learning formal so if you have any thoughts please open an issue or a PR
