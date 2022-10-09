module global_constant
  implicit none
  private
    integer, parameter, public :: wp =  selected_real_kind(2*precision(1.0))
end module global_constant


function bessel_j_nag( nu, z) result(y) 
! Computes besselj( nu, z) with nag_routine nag_bessel_j
use nag_bessel_fun, only : nag_bessel_j
use global_constant, only : wp
implicit none
real(kind=wp), intent(in)       :: nu
real(kind=wp), intent(in)       :: z
real(kind=wp)                   :: y
complex(kind=wp)                :: z_nag

  z_nag = cmplx(z, 0)
  y = nag_bessel_j( z_nag, nu)
end function bessel_j_nag
