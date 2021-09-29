program example

    use Constants_mod, only: IK, RK32, RK64, RK128
    use Sample_mod, only: getShifted, genMean

    integer(IK) , parameter     :: NDIM = 2_IK  !<  The number of dimensions
    integer(IK) , parameter     :: NSIM = 4_IK  !<  The number of simulated data points.

    real(RK32)                  :: Sample_RK32(NDIM,NSIM)
    real(RK64)                  :: Sample_RK64(NDIM,NSIM)
    real(RK128)                 :: Sample_RK128(NDIM,NSIM)

    real(RK32)  , allocatable   :: ShiftedSample_RK32(:,:)
    real(RK64)  , allocatable   :: ShiftedSample_RK64(:,:)
    real(RK128) , allocatable   :: ShiftedSample_RK128(:,:)

    integer(IK)                 :: fileUnit, i

    open(newunit = fileUnit, file = "main.out")

    ! Generate a ranSample is centered at `Mean = [( 0.5_RK, i = 1, NDIM )]`.

    call random_number(Sample_RK32)
    call random_number(Sample_RK64)
    call random_number(Sample_RK128)

    ! Shift the samples along the second dimension to the origin to have a mean of zero along the second dimension.

    ShiftedSample_RK32  = Sample_RK32 ; call getShifted(ShiftedSample_RK32  , -genMean(Sample_RK32  , dim = 2_IK), dim = 2_IK)
    ShiftedSample_RK64  = Sample_RK64 ; call getShifted(ShiftedSample_RK64  , -genMean(Sample_RK64  , dim = 2_IK), dim = 2_IK)
    ShiftedSample_RK128 = Sample_RK128; call getShifted(ShiftedSample_RK128 , -genMean(Sample_RK128 , dim = 2_IK), dim = 2_IK)

    ! Output the values to an external file.

    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "Sample mean across the second dimension."
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "original sample mean RK32:", genMean(Sample_RK32, dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))") " shifted sample mean RK32:", genMean(ShiftedSample_RK32, dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "original sample mean RK64:", genMean(Sample_RK64, dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))") " shifted sample mean RK64:", genMean(ShiftedSample_RK64, dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "original sample mean RK128:", genMean(Sample_RK128, dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))") " shifted sample mean RK128:", genMean(ShiftedSample_RK128, dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))")

    ! Shift the samples along the first dimension to the origin to have a mean of zero along the first dimension.

    ShiftedSample_RK32  = Sample_RK32 ; call getShifted(ShiftedSample_RK32  , -genMean(Sample_RK32  , dim = 1_IK), dim = 1_IK)
    ShiftedSample_RK64  = Sample_RK64 ; call getShifted(ShiftedSample_RK64  , -genMean(Sample_RK64  , dim = 1_IK), dim = 1_IK)
    ShiftedSample_RK128 = Sample_RK128; call getShifted(ShiftedSample_RK128 , -genMean(Sample_RK128 , dim = 1_IK), dim = 1_IK)

    ! Output the values to an external file.

    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "Sample mean across the first dimension."
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "original sample mean RK32:", genMean(Sample_RK32, dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))") " shifted sample mean RK32:", genMean(ShiftedSample_RK32, dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "original sample mean RK64:", genMean(Sample_RK64, dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))") " shifted sample mean RK64:", genMean(ShiftedSample_RK64, dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "original sample mean RK128:", genMean(Sample_RK128, dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))") " shifted sample mean RK128:", genMean(ShiftedSample_RK128, dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))")

    ! Shift a 1D array.

    block

        use Constants_mod, only: RK ! default real kind
        real(RK) :: ShiftedSample_1D(NSIM)
        real(RK) :: Sample_1D(NSIM)

        call random_number(Sample_1D)

        ShiftedSample_1D = Sample_1D
        call getShifted(ShiftedSample_1D, 1._RK)

        ! Output the values to an external file.

        write(fileUnit,"(*(g0,:,' '))")
        write(fileUnit,"(*(g0,:,' '))") "1D sample mean."
        write(fileUnit,"(*(g0,:,' '))")
        write(fileUnit,"(*(g0,:,' '))") "original sample:", Sample_1D
        write(fileUnit,"(*(g0,:,' '))") " shifted sample:", ShiftedSample_1D
        write(fileUnit,"(*(g0,:,' '))")

    end block

end program example