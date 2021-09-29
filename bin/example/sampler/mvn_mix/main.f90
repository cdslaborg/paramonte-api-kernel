!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%
!%  Description:
!%      +   Run the Monte Carlo sampler of the ParaMonte library given the input log-target density function `getLogFunc()`.
!%  Output:
!%      +   The simulation output files.
!%  Author:
!%      +   Computational Data Science Lab, Monday 9:03 AM, May 16 2016, ICES, The University of Texas at Austin
!%  Visit:
!%      +   https://www.cdslab.org/paramonte
!%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

!   Keep in mind that Fortran is case-insensitive, except for character values and string values.
!   So, feel free to use upper-case or lower-case for the Fortran syntax and entity names.
!   The ParaMonte library uses camelCase convention for variable naming.

#if IS_COMPATIBLE_COMPILER

    program main

        ! This is the Object-Oriented-Programming (OOP) style interface to the ParaMonte routines.
        ! This is more flexible but less portable, as its compilation requires the same compiler
        ! brand and version with which the ParaMonte library has been built.

        use paramonte, only: IK
        use LogFunc_mod, only: getLogFunc, NDIM

        implicit none

        ! Rune the ParaDRAM Adaptive MCMC sampler.

        block
            use paramonte, only: ParaDRAM
            type(ParaDRAM) :: sim
            call sim%runSampler ( ndim = NDIM &
                                , getLogFunc = getLogFunc &
                                , inputFile = "./paramonte.in" &    ! this is optional argument
                                ! You can also specify simulation specifications as input arguments, like
                                ! the following. This is possible only from the OOP interface to ParaDRAM.
                                , proposalAdaptationCountGreedy = 0_IK &    ! this is optional argument
                                , description = "an example run" &  ! this is optional argument
                                ! More optional arguments can appear here.
                                ! See the ParaDRAM routine's list of input arguments.
                                )
            if (sim%Err%occurred) error stop
        end block

        ! Rune the ParaNest Nested sampler.

        block
            use paramonte, only: ParaNest
            type(ParaNest) :: sim
            call sim%runSampler ( ndim = NDIM &
                                , getLogFunc = getLogFunc &
                                , inputFile = "./paramonte.in" &    ! this is optional argument
                                ! You can also specify simulation specifications as input arguments, like
                                ! the following. This is possible only from the OOP interface to ParaNest.
                                , description = "an example run" &  ! this is optional argument
                                ! More optional arguments can appear here.
                                ! See the ParaNest routine's list of input arguments.
                                )
            if (sim%Err%occurred) error stop
        end block

    end program main

#else

    ! This is the default simple procedural interface to the ParaMonte routines.
    ! The first two arguments `ndim` and `getLogFunc` to the sampler routines are mandatory.
    ! The last argument `inputFile` is optional.

    program main

        use paramonte, only: runParaDRAM, runParaNest, IK
        use LogFunc_mod, only: getLogFunc, NDIM

        implicit none

        integer(IK) :: ierr

        ierr = runParaDRAM  ( NDIM &
                            , getLogFunc &
                            , "./paramonte.in" & ! this is optional argument
                            )
        if (ierr /= 0_IK) error stop

        ierr = runParaNest  ( NDIM &
                            , getLogFunc &
                            , "./paramonte.in" & ! this is optional argument
                            )
        if (ierr /= 0_IK) error stop

    end program main

#endif

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%