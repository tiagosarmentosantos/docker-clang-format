#!/bin/sh

# Change permission to execute clang-format scripts
chmod -R 550 /opt/llvm/bin/clang-format

# Call clang-format with input arguments
if [ $# -eq 0 ]
then
    /opt/llvm/bin/clang-format --help
else
    /opt/llvm/bin/clang-format "$@"
fi
