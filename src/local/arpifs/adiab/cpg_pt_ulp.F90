SUBROUTINE CPG_PT_ULP (YDMODEL, YDGEOMETRY, YDCPG_SL1, YDVARS, YGFL, KSTART, &
                     & KPROF, LDGET, PGFLPT, PGFLT1, PGFL)

! -----------------------------------------------------------------------------
!     --------------------------------------------
!**** *CPG_PT_ULP*  physics tendencies written to or extracted from GFLPT
!     --------------------------------------------

!     Purpose.
!     --------
!       Copy the physics tendencies calculated (for ex in predictor)
!       to GFLPT to be retrieved and used during corrector
!       Designed for unlagged physics packages (LAGPHY=F).
!       May be used for non advected GFL too.

!       This routine is called for lpc_full=true only.

!**   Interface.
!     ----------
!        CALL CPG_PT_ULP(...)

!     Input arguments
!     ------------------
!       KSTART  : start of horizontal loop
!       KPROF   : end of horizontal loop
!       LDGET   : T = get tendencies from buffers.
!                 F = save tendencies in buffers.
!       KFLDN,KFLDX: for second dimension of PTENDEXT.

!     Input or Output according to LDGET
!     ----------------------------------
!       PTEND[X]: tendency of X variable from phy (advected variables).
!       PGFLPT  : buffer for tendency of GFL variable from phy.
!       PGFLT1  : tendency of X variable from phy (not advected variables).
!       PGFL    : GFL variables.
!       PGMV    : upper air GMV variables at time t.
!       PGMVS   : surface GMV variables at time t.

!     Implicit arguments
!     --------------------

!     Author.
!     -------
!      Martina Tudor + Karim Yessad
!      Original : Jan 2011 (from CPG_PT)

!     Modifications.
!     --------------
! -----------------------------------------------------------------------------

USE GEOMETRY_MOD , ONLY : GEOMETRY
USE PARKIND1     , ONLY : JPIM, JPRB
USE YOMHOOK      , ONLY : LHOOK, DR_HOOK
USE YOM_YGFL     , ONLY : TYPE_GFLD
USE YOMCT0       , ONLY : LNHDYN
USE FIELD_VARIABLES_MOD     , ONLY : FIELD_VARIABLES
USE CPG_TYPE_MOD            , ONLY : CPG_SL1_TYPE
USE TYPE_MODEL              , ONLY : MODEL
USE MF_PHYS_NEXT_STATE_TYPE_MOD &
                            , ONLY : MF_PHYS_NEXT_STATE_TYPE

! -----------------------------------------------------------------------------

IMPLICIT NONE

TYPE(MODEL)             ,INTENT(INOUT)  :: YDMODEL
TYPE(GEOMETRY)          ,INTENT(IN)     :: YDGEOMETRY
TYPE(CPG_SL1_TYPE)      ,INTENT(INOUT)  :: YDCPG_SL1
TYPE(FIELD_VARIABLES)   ,INTENT(INOUT)  :: YDVARS
TYPE(TYPE_GFLD)         ,INTENT(IN)    :: YGFL
INTEGER(KIND=JPIM)      ,INTENT(IN)    :: KSTART
INTEGER(KIND=JPIM)      ,INTENT(IN)    :: KPROF
LOGICAL                 ,INTENT(IN)    :: LDGET
REAL(KIND=JPRB)         ,INTENT(INOUT) :: PGFLPT(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG,YGFL%NDIMPT)
REAL(KIND=JPRB)         ,INTENT(INOUT) :: PGFLT1(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG,YGFL%NDIM1)
REAL(KIND=JPRB)         ,INTENT(IN)    :: PGFL(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG,YGFL%NDIM)
! -----------------------------------------------------------------------------

#include "cp_ptrslb1.intfb.h"

TYPE (MF_PHYS_NEXT_STATE_TYPE) :: YLMF_PHYS_NEXT_STATE

REAL(KIND=JPRB), POINTER :: ZTENDGFL (:,:)

INTEGER(KIND=JPIM) :: JGFL,IPT
INTEGER(KIND=JPIM) :: ISLB1GFL9,ISLB1T9,ISLB1V9,ISLB1U9,ISLB1VD9

REAL(KIND=JPRB) :: ZHOOK_HANDLE

! -----------------------------------------------------------------------------

IF (LHOOK) CALL DR_HOOK('CPG_PT_ULP',0,ZHOOK_HANDLE)
ASSOCIATE(YDDIM=>YDGEOMETRY%YRDIM,YDDIMV=>YDGEOMETRY%YRDIMV)
ASSOCIATE(NUMFLDS=>YGFL%NUMFLDS, YCOMP=>YGFL%YCOMP, YCPF=>YGFL%YCPF,   NFLEVG=>YDDIMV%NFLEVG)
! -----------------------------------------------------------------------------

CALL YLMF_PHYS_NEXT_STATE%INIT (YDCPG_SL1, YDGEOMETRY, YDVARS, YDMODEL)

CALL CP_PTRSLB1(YDMODEL%YRML_DYN%YRDYN, YDMODEL%YRML_DYN%YRPTRSLB1, &
              & ISLB1U9, ISLB1V9, ISLB1T9, ISLB1VD9, ISLB1GFL9)

ZTENDGFL (1:,0:) => YDCPG_SL1%ZVIEW(:, ISLB1GFL9:)

!*       1.  PREDICTOR FOR LPC_FULL.
!        ---------------------------

IF (.NOT.LDGET) THEN

  ! * GMV:
  YDVARS%CUPT%T9(KSTART:KPROF,1:NFLEVG)=YLMF_PHYS_NEXT_STATE%U%P(KSTART:KPROF,1:NFLEVG)
  YDVARS%CVPT%T9(KSTART:KPROF,1:NFLEVG)=YLMF_PHYS_NEXT_STATE%V%P(KSTART:KPROF,1:NFLEVG)
  YDVARS%CTPT%T9(KSTART:KPROF,1:NFLEVG)=YLMF_PHYS_NEXT_STATE%T%P(KSTART:KPROF,1:NFLEVG)
  IF (LNHDYN) THEN
    YDVARS%CSVDPT%T9(KSTART:KPROF,1:NFLEVG)=YLMF_PHYS_NEXT_STATE%SVD%P(KSTART:KPROF,1:NFLEVG)
  ENDIF

  ! * GMVS:
  YDVARS%CSPPT%T9(KSTART:KPROF)=YDCPG_SL1%SP9%P(KSTART:KPROF)

  ! * GFL:
  DO JGFL=1,NUMFLDS
    IF (YCOMP(JGFL)%LT1 .AND. YCOMP(JGFL)%LPT) THEN
      IF (YCOMP(JGFL)%LADV) THEN
        IPT=YCOMP(JGFL)%MP_SLX
        PGFLPT(KSTART:KPROF,1:NFLEVG,YCOMP(JGFL)%MPPT)=ZTENDGFL(KSTART:KPROF,IPT+1:IPT+NFLEVG)
      ELSE
        PGFLPT(KSTART:KPROF,1:NFLEVG,YCOMP(JGFL)%MPPT)=PGFLT1(KSTART:KPROF,1:NFLEVG,YCOMP(JGFL)%MP1)
      ENDIF
    ENDIF
  ENDDO

ENDIF

! -----------------------------------------------------------------------------

!*       2.  CORRECTOR FOR LPC_FULL.
!        ---------------------------

IF (LDGET) THEN

  ! * GMV:
  YLMF_PHYS_NEXT_STATE%U%P(KSTART:KPROF,1:NFLEVG)=YDVARS%CUPT%T9(KSTART:KPROF,1:NFLEVG)
  YLMF_PHYS_NEXT_STATE%V%P(KSTART:KPROF,1:NFLEVG)=YDVARS%CVPT%T9(KSTART:KPROF,1:NFLEVG)
  YLMF_PHYS_NEXT_STATE%T%P(KSTART:KPROF,1:NFLEVG)=YDVARS%CTPT%T9(KSTART:KPROF,1:NFLEVG)
  IF (LNHDYN) THEN
    YLMF_PHYS_NEXT_STATE%SVD%P(KSTART:KPROF,1:NFLEVG)=YDVARS%CSVDPT%T9(KSTART:KPROF,1:NFLEVG)
  ENDIF

  ! * GMVS:
  YDCPG_SL1%SP9%P(KSTART:KPROF)=YDVARS%CSPPT%T9(KSTART:KPROF)

  ! * GFL:
  DO JGFL=1,NUMFLDS
    IF (YCOMP(JGFL)%LT1 .AND. YCOMP(JGFL)%LPT) THEN
      IF (YCOMP(JGFL)%LADV) THEN
        IPT=YCOMP(JGFL)%MP_SLX
        ZTENDGFL(KSTART:KPROF,IPT+1:IPT+NFLEVG)=PGFLPT(KSTART:KPROF,1:NFLEVG,YCOMP(JGFL)%MPPT)
      ELSE
        PGFLT1(KSTART:KPROF,1:NFLEVG,YCOMP(JGFL)%MP1)=PGFLPT(KSTART:KPROF,1:NFLEVG,YCOMP(JGFL)%MPPT)
      ENDIF
    ENDIF
  ENDDO

  IF (YCPF%LACTIVE) THEN
    YDVARS%CPF%T1(KSTART:KPROF,1:NFLEVG)=YDVARS%CPF%T0(KSTART:KPROF,1:NFLEVG)
  ENDIF

ENDIF

! -----------------------------------------------------------------------------

END ASSOCIATE
END ASSOCIATE
IF (LHOOK) CALL DR_HOOK('CPG_PT_ULP',1,ZHOOK_HANDLE)
END SUBROUTINE CPG_PT_ULP
