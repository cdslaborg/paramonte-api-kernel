!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%
!%  Description:
!%      +   Return the natural logarithm of an ndim-dimensional mixture of Standard Multivariate
!%          Normal (SMVN) density functions (PDF) with the mean and amplitude vectors as defined below.
!%          Reference: https://en.wikipedia.org/wiki/Multivariate_normal_distribution
!%  Input:
!%      +   ndim:       The number of dimensions of the domain of the objective function.
!%      +   point:      The input 64-bit real-valued vector of length ndim,
!%                      at which the natural logarithm of objective function is computed.
!%  Output:
!%      +   logFunc:    A 64-bit real scalar number representing the natural logarithm of the objective function.
!%  Author:
!%      +   Computational Data Science Lab, Monday 9:03 AM, May 16 2016, ICES, The University of Texas at Austin
!%  Visit:
!%      +   https://www.cdslab.org/paramonte
!%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

module LogFunc_mod

    use paramonte, only: IK, RK

    implicit none

    ! The number of dimensions of the domain of the objective function.

    integer(IK), parameter  :: NDIM = 1_IK

    ! The number of mixtures of multivariate normal distributions.

    integer(IK), parameter  :: NMIX = 3_IK

    ! The mean vectors of the SMVN mixtures.

    integer(IK)             :: idim, imix
    real(RK), parameter     :: MEAN(NDIM,NMIX) = reshape([((real(3*imix,RK), idim = 1, NDIM), imix = -NMIX/2, NMIX/2 + mod(NMIX,2) - 1)], shape = shape(MEAN))

    ! The log-amplitudes of the SMVN mixtures.

    real(RK), parameter     :: LOG_AMPLITUDE(NMIX) = [(imix*log(2._RK), imix = 1, NMIX)]

contains

    function getLogFunc(ndim,Point) result(logFunc)
        ! Return the negative natural logarithm of SMVN mixture density evaluated at the input vector `Point` of length `ndim`.
        implicit none
        integer(IK), intent(in) :: ndim
        real(RK), intent(in)    :: Point(ndim)
        real(RK)                :: LogFuncMix(NMIX)
        real(RK)                :: maxLogFuncMix
        real(RK)                :: logFunc
        maxLogFuncMix = -huge(maxLogFuncMix)
        do imix = 1, NMIX
            LogFuncMix(imix) = LOG_AMPLITUDE(imix) - 0.5_RK * sum((Point - MEAN(:,imix))**2)
            if (maxLogFuncMix < LogFuncMix(imix)) maxLogFuncMix = LogFuncMix(imix)
        end do
        logFunc = maxLogFuncMix + log(sum(exp(LogFuncMix - maxLogFuncMix)))
    end function getLogFunc

end module LogFunc_mod

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
