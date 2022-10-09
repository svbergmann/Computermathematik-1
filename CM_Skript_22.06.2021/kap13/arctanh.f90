module global_constant
  implicit none
  private
    integer, parameter, public :: wp =  selected_real_kind(2*precision(1.0))
end module global_constant


function arctanh( x) result(y)
use nag_inv_hyp_fun, only : nag_arctanh
use global_constant, only : wp
implicit none
real(wp), intent(in) :: x
real(wp)             :: y

  y = nag_arctanh( x )
end function arctanh
