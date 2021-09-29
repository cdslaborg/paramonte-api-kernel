#!/bin/bash
FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# build the ParaMonte library

####################################################################################################################################
#### usage
####################################################################################################################################

usage()
{
cat << EndOfMessage

    Building and running the ParaMonte Doxygen examples requires the GNU compiler collection 10 or newer.

    script flag definitions:

        -x | --xrun             : the ParaMonte library example run enabled: true, false
        -X | --xbuild           : the ParaMonte library example build enabled: true, false
        -b | --build            : the ParaMonte library build type: release, testing, debug
        -f | --fortran          : path to Fortran compiler. If provided, the ParaMonte library will be built via the specified compiler.
        -j | --njob             : the default number of processes via which the ParaMonte library will be built for the requested configuration: positive integer
        -h | --help             : help with the script usage

EndOfMessage
}

# set the build configuration.

BTYPE="release"
NUM_JOB_FLAG="-j 2"
EXAM_RUN_ENABLED="true"
EXAM_BUILD_ENABLED="true"

# set the preferred compiler path.

unset PREFERRED_COMPILER_PATH_FLAG
PREFERRED_COMPILER_PATH="/usr/bin/gfortran-10"
if [ -f "${PREFERRED_COMPILER_PATH}" ]; then
    echo >&2 "-- ParaMonteDoxygen - The preferred ParaMonte Doxygen documentation compiler choice detected: ${PREFERRED_COMPILER_PATH}"
    PREFERRED_COMPILER_PATH_FLAG="-f ${PREFERRED_COMPILER_PATH}"
else
    echo >&2 "-- ParaMonteDoxygen - WARNING: The preferred ParaMonte Doxygen documentation compiler choice not detected. Building with the default available compiler..."
fi

#fetch the user options.

while [ "$1" != "" ]; do
    case $1 in
        -X | --xbuild )         shift
                                EXAM_BUILD_ENABLED="$1"
                                ;;
        -b | --build )          shift
                                BTYPE="$1"
                                ;;
        -f | --build )          shift
                                BTYPE="$1"
                                ;;
        -x | --xrun )           shift
                                EXAM_RUN_ENABLED="$1"
                                ;;
        -j | --njob )           shift
                                NUM_JOB_FLAG="--njob $1"
                                ;;
        -f | --fortran )        shift
                                PREFERRED_COMPILER_PATH_FLAG="-f $1"
                                ;;
        * )                     usage
                                echo >&2 ""
                                echo >&2 "-- ParaMonte - FATAL: The specified flag $1 does not exist."
                                echo >&2 ""
                                echo >&2 "-- ParaMonte - gracefully exiting."
                                echo >&2 ""
                                echo >&2 ""
                                exit 1
    esac
    shift
done

# Build the ParaMonte Fortran binary in the Doxygen bin directory.

DOXYGEN_BIN_DIR="${FILE_DIR}"/bin
echo >&2 "-- ParaMonteDoxygen - The ParaMonte binary install directory: ${DOXYGEN_BIN_DIR}"

if [ "${EXAM_BUILD_ENABLED}" = "true" ]; then
    if [ -d "${DOXYGEN_BIN_DIR}" ]; then
        echo >&2 "-- ParaMonteDoxygen - The ParaMonte binary install directory exists. Deleting the old contents..."
        rm -rf "${DOXYGEN_BIN_DIR}" || {
        echo >&2 
        echo >&2 "-- ParaMonteDoxygen - FATAL: Failed to delete the ParaMonte binary install directory: ${DOXYGEN_BIN_DIR}"
        echo >&2 
        exit 1
        }
    fi
    cd "${FILE_DIR}"/../.. &&
    ./install.sh \
    --lang fortran \
    --lib shared \
    --par none \
    --mem heap \
    --build "${BTYPE}" \
    -t none \
    -x kernel \
    --check none \
    -s gnu \
    --idir "${DOXYGEN_BIN_DIR}" \
    ${PREFERRED_COMPILER_PATH_FLAG} \
    ${NUM_JOB_FLAG} && \
    cd "${FILE_DIR}" || {
        echo >&2
        echo >&2 "-- ParaMonteDoxygen - Failed to build the ParaMonte library for Doxygen examples. exiting..."
        echo >&2
        exit 1
    }
fi

# Build and run the kernel examples in the Doxygen bin directory to generate documentation example output files.

if [ "${EXAM_RUN_ENABLED}" = "true" ]; then
    for moduleDir in "${FILE_DIR}/bin/example/kernel"/*; do
        moduleName="$(basename "${moduleDir}")"
        for procDir in "${moduleDir}"/*; do
            procName="$(basename "${procDir}")"
            cd "${procDir}" && ./build.sh && {
                echo >&2 "-- ParaMonteDoxygen - ParaMonte example build and run succeeded: ${moduleName}@${procName}"
            } || {
                echo >&2 "-- ParaMonteDoxygen - Failed to build and run the ${moduleName}@${procName} example. exiting..."
                echo >&2 "-- ParaMonteDoxygen - source directory: ${procDir}"
                echo >&2
                exit 1
            }
        done
    done
fi
echo >&2

# Build the kernel documentation.

cd "${FILE_DIR}" && ../../build/doxygen/build/bin/doxygen "${FILE_DIR}/config.txt" || {
    echo >&2
    echo >&2 "-- ParaMonteDoxygen - Failed to build the ParaMonte::Kernel Doxygen library. exiting..."
    echo >&2
    exit 1
}
