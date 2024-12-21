ARG BASE_IMAGE=nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04
FROM ${BASE_IMAGE}

RUN export DEBIAN_FRONTEND=nointeractive \
    && apt-get update --fix-missing \
    && apt-get upgrade --yes \
    && apt-get install --no-install-recommends --yes \
        curl \
        xorg-dev \
        zlib1g-dev \
        libvulkan-dev \
        libompl-dev \
        libglu1-mesa \
        libgl1-mesa-glx \
        libosmesa6-dev \
        libglib2.0-dev \
        libxrender1 \
        libegl1 \
    && apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=nointeractive \
    && apt-get update --fix-missing \
    && apt-get upgrade --yes \
    && apt-get install --no-install-recommends --yes \
        python3-venv \
        python3-tk \
    && python3 -m venv /opt/pylocal \
    && apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

RUN . /opt/pylocal/bin/activate \
    && python3 -m pip install --no-cache \
        torch==2.4.0 \
        torchvision==0.19.0 \
        torchaudio==2.4.0 \
        --index-url https://download.pytorch.org/whl/cu121

RUN . /opt/pylocal/bin/activate \
    && python3 -m pip install --no-cache \
        genesis-world \
        ipython

RUN . /opt/pylocal/bin/activate \
    && python3 -m pip install --no-cache \
        pyplusplus \
        pygccxml \
    && apt-get update --fix-missing \
    && apt-get install --no-install-recommends --yes \
        ca-certificates \
        git-core \
        build-essential \
        cmake \
        make \
        libode-dev \
        libboost-all-dev \
        castxml \
    && git clone https://github.com/ompl/ompl.git \
        -b 1.6.0 \
        --depth 1 \
    && cmake \
        -S ompl \
        -B ompl_build \
        -D CMAKE_BUILD_TYPE=Release \
        -D OMPL_BUILD_TESTS=OFF \
        -D OMPL_BUILD_DEMOS=OFF \
        -D OMPL_BUILD_PYTESTS=OFF \
        -D OMPL_BUILD_PYBINDINGS=ON \
    && make \
        -C ompl_build \
        -j $(nproc) \
        update_bindings \
    && cmake \
        --build ompl_build \
        --parallel $(nproc) \
    && cmake \
        --install ompl_build \
    && rm -rf ompl ompl_build \
    && apt-get remove --purge --yes \
        git-core \
        build-essential \
        cmake \
        make \
    && apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

RUN . /opt/pylocal/bin/activate \
    && apt-get update --fix-missing \
    && apt-get install --no-install-recommends --yes \
        ca-certificates \
        git-core \
    && python3 -m pip install --no-cache \
        tensorboard \
    && cd /opt \
    && git clone https://github.com/leggedrobotics/rsl_rl.git -b v1.0.2 --depth 1 \
    && cd rsl_rl \
    && python3 -m pip install -e . \
    && apt-get remove --purge --yes \
        git-core \
    && apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

RUN echo '. /opt/pylocal/bin/activate' >> /root/.bashrc

ENV __NV_PRIME_RENDER_OFFLOAD=1
ENV __GLX_VENDOR_LIBRARY_NAME=nvidia
ENV PYOPENGL_PLATFORM=mesa
