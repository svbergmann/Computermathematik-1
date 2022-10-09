module global_constant
  implicit none
  private
    integer, parameter, public :: wp = selected_real_kind(2*precision(1.0))
end module global_constant


function arctanh( x) result(y)
use global_constant, only : wp
implicit none
real(kind=wp) s11aaf

real(kind=wp), intent(in) :: x
real(kind=wp)             :: y
integer                   :: ifail

  ifail = 0
  y = s11aaf( x, ifail )
end function arctanh
