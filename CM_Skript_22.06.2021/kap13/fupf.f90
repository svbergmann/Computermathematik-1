subroutine fup(m, y)
  implicit none
  integer, intent(in)  :: m
  real, intent(inout)  :: y(m)
  real, parameter      :: pi = 3.1415926535897
  integer              :: i

    do i=1,m
       y(i) = i*pi+y(i)
    end do
end subroutine fup
