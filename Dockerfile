FROM ghcr.io/hpcflow/petsc:3.18.4_gcc12

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

WORKDIR /wd

## Tests
RUN DAMASK_grid -l tensionX.yaml -g 20grains16x16x16.vti -m material.yaml -w /DAMASK/examples/grid

ENTRYPOINT ["DAMASK_grid"]
CMD ["bash"]