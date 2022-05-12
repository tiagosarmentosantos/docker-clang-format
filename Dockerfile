# Set base system for this docker
FROM alpine:3.15

# Set link to github repo containing sources of this container
LABEL org.opencontainers.image.source https://github.com/tiagosarmentosantos/docker-clang-format

# Set the latest LLVM release value
# clang-format is part of LLVM project, this ENV shall be updated
# if a more recent version is intended to use.
ENV LLVM_GIT_TAG="llvmorg-14.0.3"

# All steps shall be done in a same RUN layer context to avoid 
# using too much image space
#
# 1. Install build only dependencies in Alpine Linux
# 2. Clone LLVM Project for LLVM_GIT_TAG
# 3. Move into LLVM Project cloned repo and create a build directory
# 4. Generate Unix Makefiles for clang-format build
# 5. Build clang-format tool
# 6. Install clang-format binaries on /opt/llvm/bin
# 7. Remove build artifacts
RUN apk upgrade && \
    apk add --no-cache \
        cmake \
		gcc \
		g++ \
		git \
		make \
		python3 \
	&& cd /tmp \
    && git clone --depth=1 --branch "${LLVM_GIT_TAG}" https://github.com/llvm/llvm-project.git "${LLVM_GIT_TAG}" \
	&& mkdir -p "${LLVM_GIT_TAG}"/build \
	&& cd "${LLVM_GIT_TAG}"/build \
    && cmake -G "Unix Makefiles" \
	         -DCMAKE_C_COMPILER=gcc \
             -DCMAKE_CXX_COMPILER=g++ \
			 -DCMAKE_C_FLAGS="-static-libgcc" \
			 -DCMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++" \
             -DCMAKE_BUILD_TYPE=Release \
		     -DCMAKE_INSTALL_PREFIX=/tmp/llvm-clang \
		     -DBUILD_SHARED_LIBS=OFF \
		     -DCLANG_ENABLE_STATIC_ANALYZER=OFF \
             -DCLANG_ENABLE_ARCMT=OFF \
		     -DLLVM_INCLUDE_BENCHMARKS=OFF \
             -DLLVM_INCLUDE_EXAMPLES=OFF \
             -DLLVM_INCLUDE_TESTS=OFF \
		     -DLLVM_INCLUDE_TOOLS=ON \
		     -DLLVM_ENABLE_PROJECTS=clang \
		     -DLLVM_TARGETS_TO_BUILD="X86" \
		     ../llvm \
	&& make clang-format -j 4 \
	# Since we required only clang-format, make install is skipped
	# Option to set install prefix: -DCMAKE_INSTALL_PREFIX=/tmp/llvm-clang
    # && make install -j 4 \
	&& mkdir -p /opt/llvm/bin \
	&& cp bin/clang-format /opt/llvm/bin/clang-format \
    && cd / && rm -rf /tmp/"${LLVM_GIT_TAG}" \
	&& apk del cmake gcc g++ git make python3

# Define container entrypoint to clang-format tool
COPY --chown=0:0 entrypoint.sh /root
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/root/entrypoint.sh"]