#!/bin/bash

# create group and user on the container preserving UID/GID of the caller
groupadd --gid $GIDVAR $USER
useradd --gid $GIDVAR --shell /bin/bash --uid $UIDVAR -M $USER

# Be able to execute clang-format as user
chown -R $UIDVAR:$GIDVAR /opt/llvm-clang/bin/clang-format

# Change permission to execute clang-format scripts
chmod -R 550 /opt/llvm-clang/bin/clang-format

# Call clang-format with input arguments
if [ $# -eq 0 ]
then
    /usr/bin/sudo --user $USER /opt/llvm-clang/bin/clang-format --help
else
    /usr/bin/sudo --user $USER /opt/llvm-clang/bin/clang-format "$@"
fi
