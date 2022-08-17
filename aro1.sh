#!/bin/bash
#SBATCH --export=NONE
#SBATCH --job-name=aro
#SBATCH --nodes=1
#SBATCH --time=00:15:00
#SBATCH --exclusive
#SBATCH --verbose
#SBATCH --no-requeue

set -x

# Environment variables

ulimit -s unlimited
export OMP_STACKSIZE=4G
export KMP_STACKSIZE=4G
export KMP_MONITOR_STACKSIZE=1G
export DR_HOOK=1
export DR_HOOK_IGNORE_SIGNALS=-1
export DR_HOOK_OPT=prof
export EC_PROFILE_HEAP=0
export EC_MPI_ATEXIT=0

export PATH=$HOME/bin:$HOME/benchmf1709/scripts:$PATH

# Directory where input data is stored

DATA=/scratch/work/marguina/benchmf1709-data

# Change to a temporary directory

export workdir=/scratch/work/marguina

export TMPDIR=$workdir/tmp/aro.$SLURM_JOBID

mkdir -p $TMPDIR

cd $TMPDIR

for NAM1 in ARO.LPC_FULL
do

for NAM2 in NHEE 
do

mkdir -p $NAM1.$NAM2
cd $NAM1.$NAM2

# Choose your test case resolution

 GRID=0064x0064

# Choose a pack

 PACK=/home/gmap/mrpm/marguina/pack/cy48t1_cpg_drv.01.MIMPIIFC1805.2y.pack

# Copy data to $TMPDIR

for f in $DATA/aro/grid/$GRID/* $DATA/aro/code/43oops/data/* 
do
  if [ -f "$f" ]
  then
    \rm -f $(basename $f)
    ln $f .
  fi
done

for f in $PACK/data/*
do
  b=$(basename $f)
  \rm -f $b
  ln -s $f $b
done

cp EXSEG1.nam EXSEG1.nam.tmp
\rm -f EXSEG1.nam
mv EXSEG1.nam.tmp EXSEG1.nam
chmod 644 EXSEG1.nam

for f in $DATA/aro/code/43oops/naml/*
do
  cp $f .
  chmod 644 $(basename $f)
done

# Set the number of nodes, tasks, threads for the model

NNODE_FC=1
NTASK_FC=4
NOPMP_FC=8

# Set the number of nodes, tasks, threads for the IO server

NNODE_IO=0
NTASK_IO=32
NOPMP_IO=4

let "NPROC_FC=$NNODE_FC*$NTASK_FC"
let "NPROC_IO=$NNODE_IO*$NTASK_IO"

# Set forecast term; reduce it for debugging

STOP=1

# Modify namelist

xpnam --delta="
&NAMRIP
  CSTOP='h$STOP',
  TSTEP=60,
/
&NAMARG
  CUSTOP=-,
  UTSTEP=-,
/
&NAMCVER
  NVSCH=-,
  NVFE_TYPE=1,
/
&NAMTRAJ
/
&NAMCT0
  LNHDYN=-,
  LNHEE=.TRUE.,
  LGRIB_API=.FALSE.,
/
&NAETLDIAG
/
&NAMDVISI
/
&NAMSATSIM
/
&NAMPHY0
  GREDDRS=-,
/
&NAMNORGWD
/
&NAMMETHOX
/
&NAMNUDGLH
/
&NAMSPP
/
&NAMFA
  NVGRIB=0,
/
" --inplace fort.4

xpnam --delta="
&NAMIO_SERV
  NPROC_IO=$NPROC_IO,
/
&NAMPAR0
  NPROC=$NPROC_FC,
  $(square $NPROC_FC)
/
&NAMPAR1
  NSTRIN=$NPROC_FC,
/
" --inplace fort.4

xpnam --delta="
&NAM_ISBAn
  CROUGH=-,
/
" --inplace EXSEG1.nam

xpnam --delta="
$(cat $PACK/nam/$NAM1.nam)
" --inplace fort.4

xpnam --delta="
$(cat $PACK/nam/$NAM2.nam)
" --inplace fort.4

perl -e '
for (1 .. 100)
  {
    my $i = $_-1;
    print "  NSDITS($_)=$i,\n"
  }' > nsdist.nam

perl -i -ne ' print unless (m/\bNSDITS\b/o) ' fort.4

xpnam --delta="
&NAMCT0
   NSDITS(0)=100,
$(cat nsdist.nam)
/
" --inplace fort.4

perl -i -ne ' print unless (m/CROUGH/o) ' EXSEG1.nam

# Set up grib_api environment

grib_api_prefix=$(ldd $PACK/bin/MASTERODB  | perl -ne ' 
   next unless (m/libeccodes_f90/o); 
   my ($path) = (m/=>\s+(\S+)/o); 
   use File::Basename; 
   print &dirname (&dirname ($path)), "\n" ')
export GRIB_DEFINITION_PATH=$PWD/extra_grib_defs:$grib_api_prefix/share/definitions:$grib_api_prefix/share/eccodes/definitions
export GRIB_SAMPLES_PATH=$grib_api_prefix/ifs_samples/grib1:$grib_api_prefix/share/eccodes/ifs_samples/grib1

# Change NPROMA

if [ 1 -eq 1 ]
then
xpnam --delta="
&NAMDIM
  NPROMA=-4,
/
" --inplace fort.4
fi

ls -lrt

cat fort.4

# Run the model; use your mpirun

pack=$PACK
#pack=$HOME/pack/cy48t1_cpg_drv_43d0bc961f71744300a71666600beff1589da7b1.gprcp=1.01.MIMPIIFC1805.2y.pack
#pack=$HOME/pack/cy48t1_cpg_drv_d65247173713658d22f41cf09dec434ecbec2407.gprcp=0.01.MIMPIIFC1805.2y.pack

/opt/softs/mpiauto/mpiauto --verbose --wrap --wrap-stdeo --nouse-slurm-mpi --prefix-mpirun '/usr/bin/time -f "time=%e"' \
    --nnp $NTASK_FC --nn $NNODE_FC --openmp $NOPMP_FC -- $pack/bin/MASTERODB \
 -- --nnp $NTASK_IO --nn $NNODE_IO --openmp $NOPMP_IO -- $pack/bin/MASTERODB 

ls -lrt

 diffNODE.001_01 NODE.001_01 $pack/ref.cy48t1_cpg_drv_43d0bc961f71744300a71666600beff1589da7b1.gprcp=1.01.MIMPIIFC1805.2y.pack/NODE.001_01.$NAM1.$NAM2
#cp NODE.001_01 $PACK/ref.cy48t1_cpg_drv_43d0bc961f71744300a71666600beff1589da7b1.gprcp=1.01.MIMPIIFC1805.2y.pack/NODE.001_01.$NAM1.$NAM2
#cp NODE.001_01 $PACK/ref.cy48t1_cpg_drv_d65247173713658d22f41cf09dec434ecbec2407.gprcp=0.01.MIMPIIFC1805.2y.pack/NODE.001_01.$NAM1.$NAM2

cd ..

done
done


