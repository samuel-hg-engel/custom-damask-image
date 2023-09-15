ARG GCC_V=13.2.0
ARG PETSC_VERSION=3.19.5

FROM ghcr.io/hpcflow/petsc:${PETSC_VERSION}_gcc${GCC_V}_s

RUN <<SysReq
    apt-get update
    apt-get install -y wget git software-properties-common make cmake pkg-config
SysReq

ARG damask_repo=eisenforschung/DAMASK

RUN git clone https://github.com/${damask_repo}.git /DAMASK
WORKDIR /DAMASK

## DAMASK_grid
RUN <<DAMASK_grid
    cmake -B build/grid -DDAMASK_SOLVER=grid -DCMAKE_INSTALL_PREFIX=${PWD}
    cmake --build build/grid --parallel
    cmake --install build/grid
    cp ./bin/DAMASK_grid /usr/bin/
DAMASK_grid


# Multistage
RUN <<Clean&Keep
    mkdir -p /KEEP/DAMASK
    mkdir -p /KEEP/usr/bin
    mv /petsc* /KEEP
    mv examples /KEEP/DAMASK
    mv /usr/bin/DAMASK_grid /KEEP/usr/bin/
Clean&Keep

FROM gcc:${GCC_V}
ARG PETSC_VERSION
COPY --from=0 /KEEP* /
WORKDIR /wd


## Tests
RUN DAMASK_grid -l tensionX.yaml -g 20grains16x16x16.vti -m material.yaml -w /DAMASK/examples/grid

ENTRYPOINT ["DAMASK_grid"]
CMD ["bash"]
