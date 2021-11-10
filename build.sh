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

        -E | --bench            : the ParaMonte library benchmark enabled: true, false
        -N | --benchpp          : the ParaMonte library benchmark postptocessing enabled: true, false
        -b | --build            : the ParaMonte library build type: release, testing, debug
        -x | --exam             : the ParaMonte library example build enabled: true, false
        -X | --xpostproc        : the ParaMonte library example post-processing enabled: true, false
        -k | --keepold          : Keep the old builds and files of the ParaMonte example and benchmaks: true, false
        -F | --fresh            : Wipe the entire old build and rebuild library from scratch.
        -f | --fortran          : path to Fortran compiler. If provided, the ParaMonte library will be built via the specified compiler.
        -j | --njob             : the default number of processes via which the ParaMonte library will be built for the requested configuration: positive integer
        -h | --help             : help with the script usage
        --benchfile             : the ParaMonte library benchmark and postptocessing file.

    Example usage:

        # build in `release` mode,
        # build and run example files, 
        # run example files postprocessing, 
        # build and run ParaMonte benchmark files, 
        # build and run ParaMonte benchmark postprocessing, 
        # keep any old existing ParaMonte example/benchmark files.

        ./build.sh -b release -x kernel -X true --bench true --benchpp true --keepold true

EndOfMessage
}

# set the build configuration.

# set the preferred compiler path.

unset fortran_flag
PREFERRED_COMPILER_PATH="/usr/bin/gfortran-10"
if [ -f "${PREFERRED_COMPILER_PATH}" ]; then
    echo >&2 "-- ParaMonteDoxygen - The preferred ParaMonte Doxygen documentation compiler choice detected: ${PREFERRED_COMPILER_PATH}"
    fortran_flag="-f ${PREFERRED_COMPILER_PATH}"
else
    echo >&2 "-- ParaMonteDoxygen - WARNING: The preferred ParaMonte Doxygen documentation compiler choice not detected. Building with the default available compiler..."
fi


BTYPE="release"
NUM_JOB_FLAG="-j 2"
keepold_flag="--keepold true"
ParaMonte_BUILD_ENABLED="true"
CLEAN_BUILD_ENABLED="false"
xpostproc_flag="--xpostproc true"
build_flag="--build ${BTYPE}"
benchpp_flag="--benchpp true"
bench_flag="--bench true"
exam_flag="--exam kernel"
benchfile_flag=""
check_flag=""
compiler_suite_flag="--compiler_suite gnu"

#fetch the user options.

while [ "$1" != "" ]; do
    case $1 in
        -s | --compiler_suite ) shift
                                compiler_suite_flag="--compiler_suite $1"
                                ;;
        -P | --pmbuild )        shift
                                ParaMonte_BUILD_ENABLED="$1"
                                ;;
        -X | --xpostproc )      shift
                                xpostproc_flag="--xpostproc $1"
                                ;;
        -x | --exam )           shift
                                exam_flag="--exam $1"
                                ;;
        -b | --build )          shift
                                BTYPE="$1"
                                build_flag="--build ${BTYPE}"
                                ;;
        -E | --bench )          shift
                                bench_flag="--bench $1"
                                ;;
        -N | --benchpp )        shift
                                benchpp_flag="--benchpp $1"
                                ;;
        -j | --njob )           shift
                                NUM_JOB_FLAG="--njob $1"
                                ;;
        -f | --fortran )        shift
                                fortran_flag="-f $1"
                                ;;
        -C | --check )          shift
                                check_flag="--check $1"
                                ;;
        -k | --keepold )        shift
                                keepold_flag="--keepold $1"
                                ;;
        -F | --fresh )          CLEAN_BUILD_ENABLED="true"
                                ;;
        --benchfile )           shift
                                benchfile_flag="--benchfile $1"
                                ;;
        * )                     usage
                                echo >&2 ""
                                echo >&2 "-- ParaMonte - FATAL: The specified flag $1 does not exist."
                                echo >&2 ""
                                echo >&2 "-- ParaMonte - Example build command:"
                                echo >&2 ""
                                echo >&2 "    ./build.sh --build release -x ./example/runParaMonteExample.tmp -X true --bench false --benchfile ./benchmark/runParaMonteBenchmark.tmp --benchpp true --keepold true --pmbuild true"
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
DOXYGEN_BLD_DIR="${FILE_DIR}"/bld/"${BTYPE}"
echo >&2 "-- ParaMonteDoxygen - The ParaMonte binary install directory: ${DOXYGEN_BLD_DIR}"

if [ "${ParaMonte_BUILD_ENABLED}" = "true" ]; then

    if [ "${CLEAN_BUILD_ENABLED}" = "true" ]; then
        if [ -d "${DOXYGEN_BIN_DIR}" ]; then
            echo >&2 "-- ParaMonteDoxygen - The ParaMonte binary install directory exists. Deleting the old contents..."
            rm -rf "${DOXYGEN_BIN_DIR}" || {
            echo >&2
            echo >&2 "-- ParaMonteDoxygen - FATAL: Failed to delete the ParaMonte binary install directory: ${DOXYGEN_BIN_DIR}"
            echo >&2
            exit 1
            }
        fi
        if [ -d "${DOXYGEN_BLD_DIR}" ]; then
            echo >&2 "-- ParaMonteDoxygen - The ParaMonte binary install directory exists. Deleting the old contents..."
            rm -rf "${DOXYGEN_BLD_DIR}" || {
            echo >&2
            echo >&2 "-- ParaMonteDoxygen - FATAL: Failed to delete the ParaMonte binary install directory: ${DOXYGEN_BLD_DIR}"
            echo >&2
            exit 1
            }
        fi
    fi

    cd "${FILE_DIR}"/../.. &&
    ./install.sh \
    --lang fortran \
    --lib shared \
    --par none \
    --mem heap \
    ${compiler_suite_flag} \
    ${exam_flag} \
    ${build_flag} \
    ${bench_flag} \
    ${benchpp_flag} \
    ${benchfile_flag} \
    ${xpostproc_flag} \
    ${keepold_flag} \
    ${check_flag} \
    -t none \
    --bdir "${DOXYGEN_BLD_DIR}" \
    --idir "${DOXYGEN_BIN_DIR}" \
    ${fortran_flag} \
    ${NUM_JOB_FLAG} && \
    cd "${FILE_DIR}" || {
        echo >&2
        echo >&2 "-- ParaMonteDoxygen - Failed to build the ParaMonte library for Doxygen examples. exiting..."
        echo >&2
        exit 1
    }
fi

# Build the kernel documentation. The env variable ParaMonte_BLD_DIR is used in the Doxygen config file.

ParaMonte_BLD_DIR="${DOXYGEN_BLD_DIR}/Fortran"; export ParaMonte_BLD_DIR
if ! [ -d "${ParaMonte_BLD_DIR}" ]; then
    echo >&2
    echo >&2 "-- ParaMonteDoxygen - Failed to detect the ParaMonte Doxygen build directory: ${ParaMonte_BLD_DIR}"
    echo >&2 "-- ParaMonteDoxygen - exiting..."
    echo >&2
    exit 1
fi

ParaMonteDeploy_BLD_DIR="${ParaMonte_BLD_DIR}/deploy"; export ParaMonteDeploy_BLD_DIR
if ! [ -d "${ParaMonteDeploy_BLD_DIR}" ]; then
    echo >&2
    echo >&2 "-- ParaMonteDoxygen - Failed to detect the ParaMonte Doxygen build directory: ${ParaMonteDeploy_BLD_DIR}"
    echo >&2 "-- ParaMonteDoxygen - exiting..."
    echo >&2
    exit 1
fi

cd "${FILE_DIR}" && ../../build/doxygen/build/bin/doxygen "${FILE_DIR}/config.txt" || {
    echo >&2
    echo >&2 "-- ParaMonteDoxygen - Failed to build the ParaMonte::Kernel Doxygen library. exiting..."
    echo >&2
    exit 1
}
