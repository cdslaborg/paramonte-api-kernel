program example

    use Constants_mod, only: IK, RK32, RK64, RK128
    use Sample_mod, only: genShifted, genMean

    integer(IK) , parameter     :: NDIM = 2_IK      !<  The number of dimensions
    integer(IK) , parameter     :: NSIM = 1000_IK   !<  The number of simulated data points.

    real(RK32)                  :: Sample_RK32(NDIM,NSIM)
    real(RK64)                  :: Sample_RK64(NDIM,NSIM)
    real(RK128)                 :: Sample_RK128(NDIM,NSIM)

    integer(IK)                 :: fileUnit, i

    open(newunit = fileUnit, file = "main.out")

    ! Generate a ranSample is centered at `Mean = [( 0.5_RK, i = 1, NDIM )]`.

    call random_number(Sample_RK32)
    call random_number(Sample_RK64)
    call random_number(Sample_RK128)

    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "Sample mean along the second dimension:"
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "sample mean  RK32:", genMean(Sample_RK32  , dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))") "sample mean  RK64:", genMean(Sample_RK64  , dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))") "sample mean RK128:", genMean(Sample_RK128 , dim = 2_IK)
    write(fileUnit,"(*(g0,:,' '))")

    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "Sample mean along the first dimension:"
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "sample mean  RK32:", genMean(Sample_RK32 (:,1:4), dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))") "sample mean  RK64:", genMean(Sample_RK64 (:,1:4), dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))") "sample mean RK128:", genMean(Sample_RK128(:,1:4), dim = 1_IK)
    write(fileUnit,"(*(g0,:,' '))")

    Sample_RK32 (1,:) = 10._RK32  * Sample_RK32 (1,:)
    Sample_RK64 (1,:) = 10._RK64  * Sample_RK64 (1,:)
    Sample_RK128(1,:) = 10._RK128 * Sample_RK128(1,:)

    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "Sample mean of a 1D array:"
    write(fileUnit,"(*(g0,:,' '))")
    write(fileUnit,"(*(g0,:,' '))") "sample mean  RK32:", genMean(Sample_RK32 (1,:))
    write(fileUnit,"(*(g0,:,' '))") "sample mean  RK64:", genMean(Sample_RK64 (1,:))
    write(fileUnit,"(*(g0,:,' '))") "sample mean RK128:", genMean(Sample_RK128(1,:))
    write(fileUnit,"(*(g0,:,' '))")

end program example