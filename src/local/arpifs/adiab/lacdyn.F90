SUBROUTINE LACDYN(YDCST, YDGEOMETRY,YDVARS,YDCPG_SL1, YDCPG_SL2, YDCPG_BNDS, YDCPG_OPTS, YDCPG_TND, &
 & YDCPG_DYN0,YDCPG_DYN9,&
 ! --- INPUT ------------------------------------------------------------------
 & YDMODEL,PSLHDA,PSLHDD0,&
 ! --- INPUT/OUTPUT -----------------------------------------------------------
 & KSETTLOFF,PGMVTNDSI)

!**** *LACDYN*   Semi-Lagrangian scheme.
!                Computation of the t and t-dt useful quantities at grid-points.

!     Purpose.
!     --------

!          Dynamic non-linear computations in grid-point space
!          for hydrostatic and NH primitive equations and SL scheme.

!          Additional remarks:
!          - notation "prehyds" is for hydrostatic surface pressure.
!          - for input and output upper air variables, values are at full levels
!            if no other information is provided.
!          - NH variables: "P variable" is the pressure departure variable
!            (pressure departure equation), i.e. ln(pre/prehyd) if npdvar=2;
!            abbreviation "vwv" stands for "vertical wind variable".
!          - for PC schemes:
!            * this routine is called for nsiter=0.
!            * this routine is called for the predictor of lpc_full.
!            * this routine is called for the corrector of lpc_full.

!          This subroutine fills the semi-Lagrangian buffers to be interpolated.

!**   Interface.
!     ----------
!        *CALL* *LACDYN(..)

!        Explicit arguments :
!        --------------------

!        INPUT:
!          KST         - first element of work.
!          KPROF       - depth of work.
!          PBETADT     - BETADT or 0 according to configuration.
!          PDT         - For a leap-frog scheme (three time level scheme):
!                         'dt' at the first time-step, '2 dt' otherwise.
!                        For a 2TL SL scheme: timestep 'dt'.
!          PSLHDA      - Scaling factor of the deformation in f(d) function
!                        (including the model resolution correction)
!          PSLHDD0     - Threshold for deformation tensor enhancement
!          KIBL        - index into YDGSGEOM instance in YDGEOMETRY
!          POROGL      - zonal component of the orography gradient
!          POROGM      - merid component of the orography gradient
!          PNHXT9      - "X" at full levels at t-dt, diagnosed in CPG_GP.
!          PNHXT0      - "X" at full levels at t, diagnosed in CPG_GP.
!          PNHYT9      - "Y" at half levels at t-dt, diagnosed in CPG_GP.
!          PNHYT0      - "Y" at half levels at t, diagnosed in CPG_GP.
!          PRES0       - hydrostatic pressure "prehyd" at half levels at t.
!          PRDELP0     - 1/(pressure depth of layers) at t.
!          PCTY0       - contains vertical velocities, vertical integral of divergence at t.
!          PUVH0       - horizontal wind at time t at half levels.
!          PATND       - adiabatic Lagrangian tendencies.
!          PDBBC       - [D (Gw)_surf / Dt]_adiab .
!          PRDPHI      - HYD: not used.
!                        NHEE: contains pre/(R T prehyd [Delta log(prehyd)]) at t.
!                        NHQE: contains 1/(R Tt [Delta log(prehyd)]) at t.
!                        "R" is the version of R (may be Rdry or Rmoist) used in the definition of vertical divergence "dver".
!          PGWT0       - [Gw] at t (LGWADV=T only; levels: see CPG_GP).
!          PGWT9       - [Gw] at t-dt (LGWADV=T only; levels: see CPG_GP).
!          PGFL        - unified_treatment grid-point fields

!        INPUT/OUTPUT:
!          KSETTLOFF   - counter for SETTLSTF=T (# of points new scheme activated at each lev);
!                        counter for LMIXETTLS (only for LSETTLSTF=F)
!          PGMV        - GMV variables at t-dt and t.
!          PGMVS       - GMVS variables at t-dt and t.
!          PB1         - "SLBUF1" buffer for interpolations.
!          PB2         - "SLBUF2" buffer.
!          PGMVT1      - GMV variables at t+dt.
!          PGMVT1S     - GMVS variables at t+dt.
!          PGWS        - [Gw]_surf at t (LRDBBC only).
!          PGMVTNDSI   - GMV: tendency due to linear terms (for DDH).
!          PWRL95      - store current timestep PGMV(,,YMEDOT%YT9) values before re-setting

!        Implicit arguments :
!        --------------------

!     Method.
!     -------
!        See documentation

!     Externals.
!     ----------
!        Called by CPG_DYN.

!     Reference.
!     ----------
!             Arpege documentation about semi-lagrangian scheme.

!     Author.
!     -------
!      K. YESSAD (METEO FRANCE/CNRM/GMAP) after routines
!        CPLGDY1 and LAGSIMP coded by Maurice IMBARD.
!      Original : FEBRUARY 1992.

! Modifications
! -------------
!   N. Wedi and K. Yessad (Jan 2008): different dev for NH model and PC scheme
!   K. Yessad Aug 2008: rationalisation of dummy argument interfaces
!   09-Sep-2008 J. Masek  Dataflow for flow deformation along pressure levels
!   K. Yessad Nov 2008: rationalisation of dummy argument interfaces
!   K. Yessad (Nov 2009): cleanings, DT/Dt now pre-computed in CPG_GP.
!   K. Yessad (Nov 2009): prune lpc_old.
!   K. Yessad (Jan 2011): introduce INTDYN_MOD structures.
!   K. Yessad (Dec 2011): various contributions.
!   M. Diamantakis (Feb 2014): code for LSETTLSVF=T
!   T. Wilhelmsson (Sept 2013) Geometry and setup refactoring.
!   S. Malardel (Nov 2013): LATTE_STDDIS for COMAD corrections
!   K. Yessad (July 2014): Move some variables.
!   K. Yessad (Dec 2016): Prune obsolete options.
!   K. Yessad (June 2017): Introduce NHQE model.
!   F. Vana    21-Nov-2017: Option LSLDP_CURV
!   K. Yessad (Feb 2018): remove deep-layer formulations.
!   J. Vivoda (July 2018): mixed NESC/SETTLS scheme.
! End Modifications
!------------------------------------------------------------------

USE TYPE_MODEL   , ONLY : MODEL
USE GEOMETRY_MOD , ONLY : GEOMETRY
USE CPG_OPTS_TYPE_MOD, ONLY : CPG_BNDS_TYPE, CPG_OPTS_TYPE
USE CPG_TYPE_MOD,ONLY : CPG_DYN_TYPE, CPG_TND_TYPE, CPG_SL1_TYPE, CPG_SL2_TYPE
USE PARKIND1     , ONLY : JPIM, JPRB
USE YOMHOOK      , ONLY : LHOOK, DR_HOOK
USE FIELD_VARIABLES_MOD,ONLY : FIELD_VARIABLES
USE YOMCST, ONLY : TCST

!   ---------------------------------------------------------------

IMPLICIT NONE

TYPE(TCST)            ,INTENT(IN)     :: YDCST
TYPE(GEOMETRY)        ,INTENT(IN)     :: YDGEOMETRY
TYPE(FIELD_VARIABLES) ,INTENT(INOUT)  :: YDVARS
TYPE(CPG_SL1_TYPE)    ,INTENT(INOUT)  :: YDCPG_SL1
TYPE(CPG_SL2_TYPE)    ,INTENT(INOUT)  :: YDCPG_SL2
TYPE(CPG_BNDS_TYPE)   ,INTENT(IN)     :: YDCPG_BNDS
TYPE(CPG_OPTS_TYPE)   ,INTENT(IN)     :: YDCPG_OPTS
TYPE(CPG_TND_TYPE)    ,INTENT(INOUT)  :: YDCPG_TND
TYPE(CPG_DYN_TYPE)    ,INTENT(INOUT)  :: YDCPG_DYN0
TYPE(CPG_DYN_TYPE)    ,INTENT(INOUT)  :: YDCPG_DYN9
TYPE(MODEL)           ,INTENT(IN)     :: YDMODEL
INTEGER(KIND=JPIM)    ,INTENT(OUT)    :: KSETTLOFF(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB)       ,INTENT(IN)     :: PSLHDA(YDGEOMETRY%YRDIM%NPROMA)
REAL(KIND=JPRB)       ,INTENT(IN)     :: PSLHDD0(YDGEOMETRY%YRDIM%NPROMA)
REAL(KIND=JPRB)       ,INTENT(INOUT)  :: PGMVTNDSI(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG,YDMODEL%YRML_DIAG%YRMDDH%NDIMSIGMV)
!     ------------------------------------------------------------------
! * computed in LASURE:
REAL(KIND=JPRB) :: ZBT, ZDTS2, ZESGM, ZESGP
REAL(KIND=JPRB) :: ZREDIV(YDGEOMETRY%YRDIM%NPROMA)
! * computed in LASSIE or LANHSI:
REAL(KIND=JPRB) :: ZBDT(YDGEOMETRY%YRDIM%NPROMA)
REAL(KIND=JPRB) :: ZGAGT0L(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG),&
 & ZGAGT0M(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB) :: ZGAGT9L(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG),&
 & ZGAGT9M(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB) :: ZLPD0(YDGEOMETRY%YRDIM%NPROMNH,YDGEOMETRY%YRDIMV%NFLEVG),&
 & ZLPD9(YDGEOMETRY%YRDIM%NPROMNH,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB) :: ZSDIV0(YDGEOMETRY%YRDIM%NPROMA),ZSDIV9(YDGEOMETRY%YRDIM%NPROMA)
REAL(KIND=JPRB) :: ZSPDS0 (YDGEOMETRY%YRDIM%NPROMNH,YDGEOMETRY%YRDIMV%NFLEVG),&
 & ZSPDS9(YDGEOMETRY%YRDIM%NPROMNH,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB) :: ZTOD0(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG),&
 & ZTOD9(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB) :: ZMIXNL(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG)

LOGICAL :: LL2TLFF1, LLGWADV
REAL(KIND=JPRB) :: ZHOOK_HANDLE

!     ------------------------------------------------------------------

#include "lanhsi.intfb.h"
#include "lanhqesi.intfb.h"
#include "lanhsib.intfb.h"
#include "lassie.intfb.h"
#include "lasure.intfb.h"
#include "latte_bbc.intfb.h"
#include "latte_kappa.intfb.h"
#include "latte_nl.intfb.h"
#include "latte_stddis.intfb.h"
#include "lattes.intfb.h"
#include "lattex.intfb.h"
#include "lavabo.intfb.h"
#include "lavent.intfb.h"

!     ------------------------------------------------------------------

IF (LHOOK) CALL DR_HOOK('LACDYN',0,ZHOOK_HANDLE)
ASSOCIATE(YDDIM=>YDGEOMETRY%YRDIM,YDDIMV=>YDGEOMETRY%YRDIMV,YDDYN=>YDMODEL%YRML_DYN%YRDYN,YDEPHY=>YDMODEL%YRML_PHY_EC%YREPHY,   &
& YDPTRSLB1=>YDMODEL%YRML_DYN%YRPTRSLB1,YDPTRSLB2=>YDMODEL%YRML_DYN%YRPTRSLB2,YDMDDH=>YDMODEL%YRML_DIAG%YRMDDH,                 &
& YGFL=>YDMODEL%YRML_GCONF%YGFL)

ASSOCIATE(NFLEVG=>YDDIMV%NFLEVG, LSLPHY=>YDEPHY%LSLPHY,  NCURRENT_ITER=>YDDYN%NCURRENT_ITER)
!     ------------------------------------------------------------------

!*       1.    PRELIMINARY INITIALISATIONS:
!              ----------------------------

CALL LASURE(YDGEOMETRY,YDMODEL%YRML_PHY_EC%YREPHY,YDDYN,YDMODEL%YRML_DYN%YREDYN,YDMODEL%YRML_PHY_MF%YRPHY,&
 & YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,YDCPG_OPTS%ZBETADT,YDCPG_OPTS%ZDT,YDVARS%GEOMETRY%GMAPPA%T0,YDVARS%GEOMETRY%GM%T0, &
 & ZDTS2,ZBT,LL2TLFF1,ZBDT,ZREDIV,ZESGP,ZESGM)

!     ------------------------------------------------------------------

!*       2.    COMPUTATION OF THE LINEAR TERMS FOR SEMI-IMPLICIT SCHEME.
!              ---------------------------------------------------------

IF (YDCPG_OPTS%LNHEE) THEN
  CALL LANHSI(YDMODEL%YRML_DYN%YRDYNA,YDMODEL%YRCST,YDGEOMETRY,YDVARS,YDCPG_BNDS,YDCPG_OPTS,YDDYN,YDMODEL%YRML_DYN%YRDYNA%LGWADV,YDVARS%GEOMETRY%RCORI%T0,ZREDIV,&
   & ZSDIV0,ZSDIV9,ZTOD0,ZTOD9,ZGAGT0L,ZGAGT0M,ZGAGT9L,ZGAGT9M,&
   & ZSPDS0,ZSPDS9,ZLPD0,ZLPD9)
ELSEIF (YDCPG_OPTS%LNHQE) THEN
  CALL LANHQESI(YDMODEL%YRML_DYN%YRDYNA,YDMODEL%YRCST,YDGEOMETRY,YDVARS,YDCPG_BNDS,YDCPG_OPTS,YDDYN,YDMODEL%YRML_DYN%YRDYNA%LGWADV,YDVARS%GEOMETRY%RCORI%T0,&
   & ZSDIV0,ZSDIV9,ZTOD0,ZTOD9,ZGAGT0L,ZGAGT0M,ZGAGT9L,ZGAGT9M,&
   & ZLPD0,ZLPD9)
ELSE
  CALL LASSIE(YDMODEL%YRCST,YDGEOMETRY,YDVARS,YDCPG_BNDS,YDCPG_OPTS,YDDYN,YDVARS%GEOMETRY%RCORI%T0,&
   & ZSDIV0,ZSDIV9,ZTOD0,ZTOD9,ZGAGT0L,ZGAGT0M,ZGAGT9L,ZGAGT9M)
ENDIF

!     ------------------------------------------------------------------

!*       3.    COMPUTATION OF THE WIND COMPONENTS NECESSARY FOR SL TRAJECTORY.
!              ---------------------------------------------------------------

IF ((NCURRENT_ITER == 0).OR. (&
 & NCURRENT_ITER > 0 .AND. YDMODEL%YRML_DYN%YRDYNA%LPC_FULL .AND.(.NOT.YDMODEL%YRML_DYN%YRDYNA%LPC_CHEAP) )) THEN

  CALL LAVENT(YDCST, YDGEOMETRY,YDCPG_OPTS,YDCPG_BNDS,YDVARS,YDCPG_TND,YDCPG_SL1, YDCPG_SL2, YDMODEL%YRML_GCONF%YRRIP,YDMODEL%YRML_DYN,YDMODEL%YRML_PHY_MF%YRPARAR,&
   & KSETTLOFF,LL2TLFF1, &
   & ZDTS2,YDCPG_DYN0%XYB%RDELP,&
   & YDCPG_DYN0%CTY%EVEL,YDCPG_DYN9%WRL)

ENDIF

!     ------------------------------------------------------------------

!*       4.    COMPUTATION OF THE 3D-EQUATIONS RIGHT-HAND SIDE TERMS.
!              ------------------------------------------------------

!        4.1:  compute what kind of extrapolation will be used in each grid
!              point and level for LMIXETTLS=T:

IF (YDMODEL%YRML_DYN%YRDYNA%LMIXETTLS) THEN
  CALL LATTE_NL(YDCPG_OPTS%NSTEP, YDCPG_OPTS%LRPLANE, YDCST, YDGEOMETRY,YDMODEL%YRML_DYN,YDMODEL%YRML_GCONF%YRRIP,&
   & YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,ZDTS2,ZBDT,YDVARS%U%T0,YDVARS%V%T0,YDCPG_DYN0%CTY%EVEL,&
   & YDCPG_DYN0%XYB%RDELP,ZMIXNL,KSETTLOFF)
ELSE
  ZMIXNL(:,:) = 1.0_JPRB
ENDIF

!        4.2:  general case:

CALL LATTEX(YDMODEL%YRCST,YDGEOMETRY,YDVARS,YDCPG_TND,YDCPG_SL1,YDCPG_SL2,YDCPG_BNDS,YDCPG_OPTS,YDMODEL%YRML_DIAG%YRLDDH,YDMDDH,YDMODEL%YRML_GCONF,YDMODEL%YRML_DYN,ZDTS2,ZBT,ZBDT, &
 & ZESGP,ZESGM,&
 & YDCPG_DYN0%OROGL,YDCPG_DYN0%OROGM,&
 & ZGAGT0L,ZGAGT0M,ZTOD0,ZSPDS0,ZLPD0,&
 & ZGAGT9L,ZGAGT9M,ZTOD9,ZSPDS9,ZLPD9,&
 & YDCPG_DYN0%XYB%RDELP,YDCPG_DYN0%CTY%EVEL,&
 & YDCPG_DYN0%NHX,YDCPG_DYN0%GWT,YDCPG_DYN0%NHY,YDCPG_DYN9%NHX,YDCPG_DYN9%GWT,YDCPG_DYN9%NHY,ZMIXNL,&
 & PGMVTNDSI)

!        4.3:  Additional quantities required in the NH model
!              for option LRDBBC=T:

IF (YDCPG_OPTS%LNHDYN.AND.YDMODEL%YRML_DYN%YRDYNA%LRDBBC.AND.(.NOT.YDMODEL%YRML_DYN%YRDYNA%LGWADV)) THEN
  ! * Remarks:
  !   - for LGWADV=T this calculation is not required because
  !     in this case [Gw]_surf(t+dt) is computed by a diagnostic relationship
  !     in routine LAPINEB.
  CALL LATTE_BBC(YDGEOMETRY,YDVARS,YDCPG_SL1,YDCPG_SL2, YDCPG_BNDS, YDCPG_OPTS,YDMODEL%YRML_DYN,ZDTS2,ZESGP,ZESGM,YDCPG_DYN0%DBBC,YDCPG_DYN0%RDPHI,&
   & ZMIXNL,YDCPG_DYN0%GWS)
ENDIF

!     ------------------------------------------------------------------

!*       5.    COMPUTATION OF THE 2D-EQUATIONS RIGHT-HAND SIDE TERMS.
!              ------------------------------------------------------

CALL LATTES(YDCST, YDGEOMETRY,YDCPG_BNDS,YDCPG_OPTS,YDVARS,YDCPG_SL1,YDCPG_SL2,YDMODEL%YRML_GCONF%YRRIP,YDMODEL%YRML_DYN,ZDTS2,ZBDT,ZESGP,ZESGM,&
 & YDCPG_DYN0%OROGL,YDCPG_DYN0%OROGM,ZSDIV0,ZSDIV9,YDCPG_DYN0%CTY%PSDVBC,YDCPG_DYN0%PRE,ZMIXNL)

!     ------------------------------------------------------------------

!*       6.    COMPUTATION OF "KAPPA" AND STORE IT IN  "SLBUF2".
!              -----------------------------------------------------------

IF (YDMODEL%YRML_DYN%YRDYNA%LSLHD) THEN
  CALL LATTE_KAPPA(YDMODEL%YRML_DYN%YRDYNA,YDCST, YDGEOMETRY,YDVARS,YDCPG_SL1,YDCPG_SL2,YDCPG_BNDS, YDCPG_OPTS,YDDYN,ZDTS2,PSLHDA,PSLHDD0,&
   & YDCPG_DYN0%UVH%UH,YDCPG_DYN0%UVH%VH,YDCPG_DYN0%PRE(1:,NFLEVG),YDCPG_DYN0%XYB%RDELP)
ENDIF

!     ------------------------------------------------------------------

!*       7.    COMPUTATION OF "STDDIS" for each direction
!              AND STORE THEM IN  "SLBUF2".
!              -----------------------------------------------------------

IF (YDMODEL%YRML_DYN%YRDYNA%LCOMAD) THEN
  CALL LATTE_STDDIS(YDGEOMETRY,YDVARS,YDCPG_SL2,YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,ZDTS2,YDMODEL%YRML_DYN%YRDYNA%LCOMADH,YDMODEL%YRML_DYN%YRDYNA%LCOMADV)
ENDIF

!     ------------------------------------------------------------------

!*       8.    UPPER AND LOWER LATERAL BOUNDARIES CONDITIONS.
!              ----------------------------------------------

IF ((NCURRENT_ITER == 0).OR. (&
 & NCURRENT_ITER > 0 .AND. YDMODEL%YRML_DYN%YRDYNA%LPC_FULL .AND.(.NOT.YDMODEL%YRML_DYN%YRDYNA%LPC_CHEAP) )) THEN
  CALL LAVABO(YDMODEL%YRML_DYN%YRDYNA,YDGEOMETRY,YDCPG_BNDS,YDCPG_OPTS,YDCPG_SL1,YGFL,YDDYN,YDPTRSLB1,LL2TLFF1,LSLPHY)
ENDIF

!     ------------------------------------------------------------------

!*       8.    SI TERM COMPUTED WITH d3 OR d4 VARIABLE FOR GWADV 
!              -------------------------------------------------
!*    compute dt L X(t) (+ Xterm)
!*    this quantity is substracted later in CPGLAG

IF (YDMODEL%YRML_DYN%YRDYNA%LGWADV) THEN

  LLGWADV=.FALSE.
  IF (YDCPG_OPTS%LNHEE) THEN
    CALL LANHSI(YDMODEL%YRML_DYN%YRDYNA,YDMODEL%YRCST,YDGEOMETRY,YDVARS,YDCPG_BNDS,YDCPG_OPTS,YDDYN,LLGWADV,YDVARS%GEOMETRY%RCORI%T0,ZREDIV,&
     & ZSDIV0,ZSDIV9,ZTOD0,ZTOD9,ZGAGT0L,ZGAGT0M,ZGAGT9L,ZGAGT9M,&
     & ZSPDS0,ZSPDS9,ZLPD0,ZLPD9)
  ELSEIF (YDCPG_OPTS%LNHQE) THEN
    CALL LANHQESI(YDMODEL%YRML_DYN%YRDYNA,YDMODEL%YRCST,YDGEOMETRY,YDVARS,YDCPG_BNDS,YDCPG_OPTS,YDDYN,LLGWADV,YDVARS%GEOMETRY%RCORI%T0,&
     & ZSDIV0,ZSDIV9,ZTOD0,ZTOD9,ZGAGT0L,ZGAGT0M,ZGAGT9L,ZGAGT9M,&
     & ZLPD0,ZLPD9)
  ENDIF

  CALL LANHSIB(YDGEOMETRY,YDVARS,YDCPG_SL1,YDCPG_SL2,YDCPG_BNDS, YDCPG_OPTS,YDMODEL%YRML_DYN,ZBT,ZBDT,ZESGP,&
   & ZGAGT0L,ZGAGT0M,ZTOD0,ZSPDS0,ZLPD0,ZSDIV0,YDCPG_DYN0%NHX,ZMIXNL)

ENDIF

!     ------------------------------------------------------------------

END ASSOCIATE
END ASSOCIATE
IF (LHOOK) CALL DR_HOOK('LACDYN',1,ZHOOK_HANDLE)
END SUBROUTINE LACDYN
