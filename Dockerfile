FROM debian:bullseye-slim

# Environment VAR for running container
ENV USER=
ENV UIDVAR=
ENV GIDVAR=

# The latest LLVM release
# clang-format is part of LLVM project, this ENV shall be updated if a more
# recent version is intended to use.
ENV LLVM_GIT_TAG="llvmorg-13.0.1"

# Install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo \
    cmake \
	gcc \
	g++ \
	git \
	make \
	python3

# Create directory for clang build
WORKDIR /build

# All steps shall be done in a same RUN layer context to avoid 
# using too much image space
#
# 1. Clone LLVM Project
# 2. Move into LLVM Project clone repo
# 3. Generate Unix Makefiles for clang build
# 4. Build clang tool
# 5. Install clang binaries on system
# 6. Remove build artifacts
RUN git clone --branch "${LLVM_GIT_TAG}" \
        https://github.com/llvm/llvm-project.git \
		"${LLVM_GIT_TAG}" && \
	mkdir /build/"${LLVM_GIT_TAG}"/build && \
	cd /build/"${LLVM_GIT_TAG}"/build && \
    cmake -G "Unix Makefiles" \
          -DCMAKE_BUILD_TYPE=Release \
		  -DLLVM_ENABLE_PROJECTS=clang \
		  -DCMAKE_INSTALL_PREFIX=/opt/llvm-clang ../llvm && \
	make -j 4 && \
    make install && \
    rm -rf /build

# Define entrypoint as clang-format tool
COPY --chown=0:0 entrypoint.sh /root
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
