install.packages(
  "Rmpi", 
  configure.args = c(
    "--with-Rmpi-include=/trinity/shared/apps/cv-standard/openmpi/psm2/gcc75/3.1.6/include/", # This is where LAM's mpi.h is located
    "--with-Rmpi-libpath=/trinity/shared/apps/cv-standard/openmpi/psm2/gcc75/3.1.6/bin/",     # This is where liblam.so is located (actually as I type it mine was located in /usr/lib64/liblam.so.0, so maybe this is not needed at all)
    "--with-Rmpi-type=OPENMPI"               # This says that the type is OPENMPI (there is also LAM and MPICH)
  ))

# 1) R/4.0.2                     3) cwipi/intel2016/0.11.1      5) hdf5/openmpi/gcc61/1.10.1   7) gcc/6.1.0                   9) openmpi/psm2/gcc75/3.1.6
# 2) cwipi/gcc-7.5.0/0.11.1      4) cv-standard                 6) gcc/7.5.0                   8) hwloc/1.11.2
