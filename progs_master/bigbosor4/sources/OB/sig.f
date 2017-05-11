c Signal handling function.  Gracefully STOPS a FORTRAN program when
c called as a result of receiving a certain signal (defined in the main
c program).




#if cnvx
      subroutine signal_handler(signal_number, signal_subcode, flag)
      integer signal_number, signal_subcode, flag(*)
      stop
#endif
#if sgi
      integer function
     1 signal_handler(signal_number, signal_subcode, flag)
      integer signal_number, signal_subcode, flag(*)
      signal_handler = 1
      stop
#endif
#if star
      integer function signal_handler
      signal_handler = 1
      stop
#endif
#if !(cnvx || sgi || star)
      subroutine dummy2
#endif

      end
