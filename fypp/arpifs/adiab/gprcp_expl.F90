
SUBROUTINE GPRCP_EXPL (YDCST,KPROMA,KST,KPROF,KFLEV,PCP,PR,PKAP,YDVARS,KGFLTYP)

!**** *GPRCP_EXPL* - Computes Cp, R and R/Cp from Q

!     Purpose.
!     --------
!        Computes Cp, R and R/Cp from Q

!**   Interface.
!     ----------
!        *CALL* *GPRCP_EXPL(...)

!        Explicit arguments :
!        --------------------

!        INPUT:
!          KPROMA               - dimensioning.
!          KSTART               - start of work.
!          KPROF                - depth of work.
!          KFLEV                - number of layers.

!        OUTPUT:
!          PCP(KPROMA,KFLEV)    - CP
!          PR(KPROMA,KFLEV)     - R
!          PKAP(KPROMA,KFLEV)   - KAPPA

!        Implicit arguments :  Physical constants from YOMCST
!        --------------------

!     Method.
!     -------
!        See documentation

!     Externals.  None.
!     ----------

!     Reference.
!     ----------
!        ECMWF Research Department documentation of the IFS

!     Author.
!     -------
!      Mats Hamrud and Philippe Courtier  *ECMWF*
!      Original : 88-02-04

!     Modifications.
!      M.Hamrud      01-Oct-2003 CY28 Cleaning
!      Y.Seity  04-02-13 (Rain, Snow and Graupel)
!      M.Hamrud  15-Jan-2006  Revised GPRCP
!      K. Yessad (Jan 2011): more compact rewriting.
!      R. El Khatib 28-Aug-2014 Optimizations :
!       - compute R or CP only if required
!       - loop collapsing whenever possible, through pure array syntax
!      A. Geer      01-Oct-2015    For independence of observation operator in OOPS, 
!                                  allow calls without YGFL initialised. Removal
!                                  of all YGFL references will have to wait.
!      H Petithomme (Dec 2020): general rewrite for optimization
!     ------------------------------------------------------------------

USE PARKIND1, ONLY: JPIM, JPRB
USE YOMHOOK,  ONLY: LHOOK, DR_HOOK

USE YOMCST,              ONLY: TCST
USE FIELD_VARIABLES_MOD, ONLY : FIELD_VARIABLES

IMPLICIT NONE

TYPE(TCST),                     INTENT(IN)    :: YDCST
INTEGER(KIND=JPIM),             INTENT(IN)    :: KPROMA,KFLEV,KST,KPROF
INTEGER(KIND=JPIM),OPTIONAL,    INTENT(IN)    :: KGFLTYP
TYPE(FIELD_VARIABLES),          INTENT(INOUT) :: YDVARS
REAL(KIND=JPRB),OPTIONAL,TARGET,INTENT(OUT)   :: PCP(KPROMA,KFLEV)
REAL(KIND=JPRB),OPTIONAL,TARGET,INTENT(OUT)   :: PR(KPROMA,KFLEV)
REAL(KIND=JPRB),OPTIONAL,       INTENT(OUT)   :: PKAP(KPROMA,KFLEV)

#include "abor1.intfb.h"

REAL(KIND=JPRB),CONTIGUOUS,POINTER :: ZR(:,:)
REAL(KIND=JPRB),CONTIGUOUS,POINTER :: ZCP(:,:)
LOGICAL :: LLCP

REAL(KIND=JPRB),TARGET :: ZCP0(KPROMA,KFLEV),ZR0(KPROMA,KFLEV)
INTEGER(KIND=JPIM) :: IGFLTYP, JLON, JLEV, JFLD

REAL(KIND=JPRB) :: ZHOOK_HANDLE

IF (LHOOK) CALL DR_HOOK("GPRCP_EXPL",0,ZHOOK_HANDLE)

IF (PRESENT(PR)) THEN
  ZR => PR(:,:)
ELSEIF (PRESENT(PKAP)) THEN
  ZR => ZR0(:,:)
ENDIF

LLCP = .TRUE.

IF (PRESENT(PCP)) THEN
  ZCP => PCP(:,:)
ELSEIF (PRESENT(PKAP)) THEN
  ZCP => ZCP0(:,:)
ELSE
  ZCP => NULL()
  LLCP = .FALSE.
ENDIF

IF (LLCP) THEN
  ZCP = 0._JPRB
ENDIF

ZR = 0._JPRB

IGFLTYP = 0
IF (PRESENT (KGFLTYP)) IGFLTYP = KGFLTYP 



SELECT CASE (IGFLTYP)
  CASE (0)
  CALL GPRCP_EXPL_V (YDVARS%Q%LTHERMACT, YDVARS%Q%R, YDVARS%Q%RCP, YDVARS%Q%T0)
  CALL GPRCP_EXPL_V (YDVARS%I%LTHERMACT, YDVARS%I%R, YDVARS%I%RCP, YDVARS%I%T0)
  CALL GPRCP_EXPL_V (YDVARS%L%LTHERMACT, YDVARS%L%R, YDVARS%L%RCP, YDVARS%L%T0)
  CALL GPRCP_EXPL_V (YDVARS%LCONV%LTHERMACT, YDVARS%LCONV%R, YDVARS%LCONV%RCP, YDVARS%LCONV%T0)
  CALL GPRCP_EXPL_V (YDVARS%ICONV%LTHERMACT, YDVARS%ICONV%R, YDVARS%ICONV%RCP, YDVARS%ICONV%T0)
  CALL GPRCP_EXPL_V (YDVARS%RCONV%LTHERMACT, YDVARS%RCONV%R, YDVARS%RCONV%RCP, YDVARS%RCONV%T0)
  CALL GPRCP_EXPL_V (YDVARS%SCONV%LTHERMACT, YDVARS%SCONV%R, YDVARS%SCONV%RCP, YDVARS%SCONV%T0)
  CALL GPRCP_EXPL_V (YDVARS%IRAD%LTHERMACT, YDVARS%IRAD%R, YDVARS%IRAD%RCP, YDVARS%IRAD%T0)
  CALL GPRCP_EXPL_V (YDVARS%LRAD%LTHERMACT, YDVARS%LRAD%R, YDVARS%LRAD%RCP, YDVARS%LRAD%T0)
  CALL GPRCP_EXPL_V (YDVARS%S%LTHERMACT, YDVARS%S%R, YDVARS%S%RCP, YDVARS%S%T0)
  CALL GPRCP_EXPL_V (YDVARS%R%LTHERMACT, YDVARS%R%R, YDVARS%R%RCP, YDVARS%R%T0)
  CALL GPRCP_EXPL_V (YDVARS%G%LTHERMACT, YDVARS%G%R, YDVARS%G%RCP, YDVARS%G%T0)
  CALL GPRCP_EXPL_V (YDVARS%H%LTHERMACT, YDVARS%H%R, YDVARS%H%RCP, YDVARS%H%T0)
  CALL GPRCP_EXPL_V (YDVARS%TKE%LTHERMACT, YDVARS%TKE%R, YDVARS%TKE%RCP, YDVARS%TKE%T0)
  CALL GPRCP_EXPL_V (YDVARS%TTE%LTHERMACT, YDVARS%TTE%R, YDVARS%TTE%RCP, YDVARS%TTE%T0)
  CALL GPRCP_EXPL_V (YDVARS%EFB1%LTHERMACT, YDVARS%EFB1%R, YDVARS%EFB1%RCP, YDVARS%EFB1%T0)
  CALL GPRCP_EXPL_V (YDVARS%EFB2%LTHERMACT, YDVARS%EFB2%R, YDVARS%EFB2%RCP, YDVARS%EFB2%T0)
  CALL GPRCP_EXPL_V (YDVARS%EFB3%LTHERMACT, YDVARS%EFB3%R, YDVARS%EFB3%RCP, YDVARS%EFB3%T0)
  CALL GPRCP_EXPL_V (YDVARS%A%LTHERMACT, YDVARS%A%R, YDVARS%A%RCP, YDVARS%A%T0)
  CALL GPRCP_EXPL_V (YDVARS%O3%LTHERMACT, YDVARS%O3%R, YDVARS%O3%RCP, YDVARS%O3%T0)
  CALL GPRCP_EXPL_V (YDVARS%SRC%LTHERMACT, YDVARS%SRC%R, YDVARS%SRC%RCP, YDVARS%SRC%T0)
  CALL GPRCP_EXPL_V (YDVARS%MXL%LTHERMACT, YDVARS%MXL%R, YDVARS%MXL%RCP, YDVARS%MXL%T0)
  CALL GPRCP_EXPL_V (YDVARS%SHTUR%LTHERMACT, YDVARS%SHTUR%R, YDVARS%SHTUR%RCP, YDVARS%SHTUR%T0)
  CALL GPRCP_EXPL_V (YDVARS%FQTUR%LTHERMACT, YDVARS%FQTUR%R, YDVARS%FQTUR%RCP, YDVARS%FQTUR%T0)
  CALL GPRCP_EXPL_V (YDVARS%FSTUR%LTHERMACT, YDVARS%FSTUR%R, YDVARS%FSTUR%RCP, YDVARS%FSTUR%T0)
  CALL GPRCP_EXPL_V (YDVARS%CPF%LTHERMACT, YDVARS%CPF%R, YDVARS%CPF%RCP, YDVARS%CPF%T0)
  CALL GPRCP_EXPL_V (YDVARS%SPF%LTHERMACT, YDVARS%SPF%R, YDVARS%SPF%RCP, YDVARS%SPF%T0)
  CALL GPRCP_EXPL_V (YDVARS%CVGQ%LTHERMACT, YDVARS%CVGQ%R, YDVARS%CVGQ%RCP, YDVARS%CVGQ%T0)
  CALL GPRCP_EXPL_V (YDVARS%QVA%LTHERMACT, YDVARS%QVA%R, YDVARS%QVA%RCP, YDVARS%QVA%T0)
  DO JFLD = 1, SIZE (YDVARS%GHG)
    CALL GPRCP_EXPL_V (YDVARS%GHG(JFLD)%LTHERMACT, YDVARS%GHG(JFLD)%R, YDVARS%GHG(JFLD)%RCP, YDVARS%GHG(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%CHEM)
    CALL GPRCP_EXPL_V (YDVARS%CHEM(JFLD)%LTHERMACT, YDVARS%CHEM(JFLD)%R, YDVARS%CHEM(JFLD)%RCP, YDVARS%CHEM(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERO)
    CALL GPRCP_EXPL_V (YDVARS%AERO(JFLD)%LTHERMACT, YDVARS%AERO(JFLD)%R, YDVARS%AERO(JFLD)%RCP, YDVARS%AERO(JFLD)%T0)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%LRCH4%LTHERMACT, YDVARS%LRCH4%R, YDVARS%LRCH4%RCP, YDVARS%LRCH4%T0)
  DO JFLD = 1, SIZE (YDVARS%FORC)
    CALL GPRCP_EXPL_V (YDVARS%FORC(JFLD)%LTHERMACT, YDVARS%FORC(JFLD)%R, YDVARS%FORC(JFLD)%RCP, YDVARS%FORC(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%EZDIAG)
    CALL GPRCP_EXPL_V (YDVARS%EZDIAG(JFLD)%LTHERMACT, YDVARS%EZDIAG(JFLD)%R, YDVARS%EZDIAG(JFLD)%RCP, YDVARS%EZDIAG(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%ERA40)
    CALL GPRCP_EXPL_V (YDVARS%ERA40(JFLD)%LTHERMACT, YDVARS%ERA40(JFLD)%R, YDVARS%ERA40(JFLD)%RCP, YDVARS%ERA40(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%NOGW)
    CALL GPRCP_EXPL_V (YDVARS%NOGW(JFLD)%LTHERMACT, YDVARS%NOGW(JFLD)%R, YDVARS%NOGW(JFLD)%RCP, YDVARS%NOGW(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%EDRP)
    CALL GPRCP_EXPL_V (YDVARS%EDRP(JFLD)%LTHERMACT, YDVARS%EDRP(JFLD)%R, YDVARS%EDRP(JFLD)%RCP, YDVARS%EDRP(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%SLDIA)
    CALL GPRCP_EXPL_V (YDVARS%SLDIA(JFLD)%LTHERMACT, YDVARS%SLDIA(JFLD)%R, YDVARS%SLDIA(JFLD)%RCP, YDVARS%SLDIA(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERAOT)
    CALL GPRCP_EXPL_V (YDVARS%AERAOT(JFLD)%LTHERMACT, YDVARS%AERAOT(JFLD)%R, YDVARS%AERAOT(JFLD)%RCP, YDVARS%AERAOT(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERLISI)
    CALL GPRCP_EXPL_V (YDVARS%AERLISI(JFLD)%LTHERMACT, YDVARS%AERLISI(JFLD)%R, YDVARS%AERLISI(JFLD)%RCP, YDVARS%AERLISI(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AEROUT)
    CALL GPRCP_EXPL_V (YDVARS%AEROUT(JFLD)%LTHERMACT, YDVARS%AEROUT(JFLD)%R, YDVARS%AEROUT(JFLD)%RCP, YDVARS%AEROUT(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AEROCLIM)
    CALL GPRCP_EXPL_V (YDVARS%AEROCLIM(JFLD)%LTHERMACT, YDVARS%AEROCLIM(JFLD)%R, YDVARS%AEROCLIM(JFLD)%RCP,&
        & YDVARS%AEROCLIM(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%UVP)
    CALL GPRCP_EXPL_V (YDVARS%UVP(JFLD)%LTHERMACT, YDVARS%UVP(JFLD)%R, YDVARS%UVP(JFLD)%RCP, YDVARS%UVP(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%PHYS)
    CALL GPRCP_EXPL_V (YDVARS%PHYS(JFLD)%LTHERMACT, YDVARS%PHYS(JFLD)%R, YDVARS%PHYS(JFLD)%RCP, YDVARS%PHYS(JFLD)%T0)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%PHYCTY%LTHERMACT, YDVARS%PHYCTY%R, YDVARS%PHYCTY%RCP, YDVARS%PHYCTY%T0)
  CALL GPRCP_EXPL_V (YDVARS%RSPEC%LTHERMACT, YDVARS%RSPEC%R, YDVARS%RSPEC%RCP, YDVARS%RSPEC%T0)
  CALL GPRCP_EXPL_V (YDVARS%SDSAT%LTHERMACT, YDVARS%SDSAT%R, YDVARS%SDSAT%RCP, YDVARS%SDSAT%T0)
  CALL GPRCP_EXPL_V (YDVARS%CVV%LTHERMACT, YDVARS%CVV%R, YDVARS%CVV%RCP, YDVARS%CVV%T0)
  CALL GPRCP_EXPL_V (YDVARS%RKTH%LTHERMACT, YDVARS%RKTH%R, YDVARS%RKTH%RCP, YDVARS%RKTH%T0)
  CALL GPRCP_EXPL_V (YDVARS%RKTQV%LTHERMACT, YDVARS%RKTQV%R, YDVARS%RKTQV%RCP, YDVARS%RKTQV%T0)
  CALL GPRCP_EXPL_V (YDVARS%RKTQC%LTHERMACT, YDVARS%RKTQC%R, YDVARS%RKTQC%RCP, YDVARS%RKTQC%T0)
  CALL GPRCP_EXPL_V (YDVARS%UOM%LTHERMACT, YDVARS%UOM%R, YDVARS%UOM%RCP, YDVARS%UOM%T0)
  CALL GPRCP_EXPL_V (YDVARS%UAL%LTHERMACT, YDVARS%UAL%R, YDVARS%UAL%RCP, YDVARS%UAL%T0)
  CALL GPRCP_EXPL_V (YDVARS%DOM%LTHERMACT, YDVARS%DOM%R, YDVARS%DOM%RCP, YDVARS%DOM%T0)
  CALL GPRCP_EXPL_V (YDVARS%DAL%LTHERMACT, YDVARS%DAL%R, YDVARS%DAL%RCP, YDVARS%DAL%T0)
  CALL GPRCP_EXPL_V (YDVARS%UEN%LTHERMACT, YDVARS%UEN%R, YDVARS%UEN%RCP, YDVARS%UEN%T0)
  CALL GPRCP_EXPL_V (YDVARS%UNEBH%LTHERMACT, YDVARS%UNEBH%R, YDVARS%UNEBH%RCP, YDVARS%UNEBH%T0)
  DO JFLD = 1, SIZE (YDVARS%CRM)
    CALL GPRCP_EXPL_V (YDVARS%CRM(JFLD)%LTHERMACT, YDVARS%CRM(JFLD)%R, YDVARS%CRM(JFLD)%RCP, YDVARS%CRM(JFLD)%T0)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%LIMA)
    CALL GPRCP_EXPL_V (YDVARS%LIMA(JFLD)%LTHERMACT, YDVARS%LIMA(JFLD)%R, YDVARS%LIMA(JFLD)%RCP, YDVARS%LIMA(JFLD)%T0)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%FSD%LTHERMACT, YDVARS%FSD%R, YDVARS%FSD%RCP, YDVARS%FSD%T0)
  DO JFLD = 1, SIZE (YDVARS%EXT)
    CALL GPRCP_EXPL_V (YDVARS%EXT(JFLD)%LTHERMACT, YDVARS%EXT(JFLD)%R, YDVARS%EXT(JFLD)%RCP, YDVARS%EXT(JFLD)%T0)
  ENDDO
  CASE (1)
  CALL GPRCP_EXPL_V (YDVARS%Q%LTHERMACT, YDVARS%Q%R, YDVARS%Q%RCP, YDVARS%Q%T1)
  CALL GPRCP_EXPL_V (YDVARS%I%LTHERMACT, YDVARS%I%R, YDVARS%I%RCP, YDVARS%I%T1)
  CALL GPRCP_EXPL_V (YDVARS%L%LTHERMACT, YDVARS%L%R, YDVARS%L%RCP, YDVARS%L%T1)
  CALL GPRCP_EXPL_V (YDVARS%LCONV%LTHERMACT, YDVARS%LCONV%R, YDVARS%LCONV%RCP, YDVARS%LCONV%T1)
  CALL GPRCP_EXPL_V (YDVARS%ICONV%LTHERMACT, YDVARS%ICONV%R, YDVARS%ICONV%RCP, YDVARS%ICONV%T1)
  CALL GPRCP_EXPL_V (YDVARS%RCONV%LTHERMACT, YDVARS%RCONV%R, YDVARS%RCONV%RCP, YDVARS%RCONV%T1)
  CALL GPRCP_EXPL_V (YDVARS%SCONV%LTHERMACT, YDVARS%SCONV%R, YDVARS%SCONV%RCP, YDVARS%SCONV%T1)
  CALL GPRCP_EXPL_V (YDVARS%IRAD%LTHERMACT, YDVARS%IRAD%R, YDVARS%IRAD%RCP, YDVARS%IRAD%T1)
  CALL GPRCP_EXPL_V (YDVARS%LRAD%LTHERMACT, YDVARS%LRAD%R, YDVARS%LRAD%RCP, YDVARS%LRAD%T1)
  CALL GPRCP_EXPL_V (YDVARS%S%LTHERMACT, YDVARS%S%R, YDVARS%S%RCP, YDVARS%S%T1)
  CALL GPRCP_EXPL_V (YDVARS%R%LTHERMACT, YDVARS%R%R, YDVARS%R%RCP, YDVARS%R%T1)
  CALL GPRCP_EXPL_V (YDVARS%G%LTHERMACT, YDVARS%G%R, YDVARS%G%RCP, YDVARS%G%T1)
  CALL GPRCP_EXPL_V (YDVARS%H%LTHERMACT, YDVARS%H%R, YDVARS%H%RCP, YDVARS%H%T1)
  CALL GPRCP_EXPL_V (YDVARS%TKE%LTHERMACT, YDVARS%TKE%R, YDVARS%TKE%RCP, YDVARS%TKE%T1)
  CALL GPRCP_EXPL_V (YDVARS%TTE%LTHERMACT, YDVARS%TTE%R, YDVARS%TTE%RCP, YDVARS%TTE%T1)
  CALL GPRCP_EXPL_V (YDVARS%EFB1%LTHERMACT, YDVARS%EFB1%R, YDVARS%EFB1%RCP, YDVARS%EFB1%T1)
  CALL GPRCP_EXPL_V (YDVARS%EFB2%LTHERMACT, YDVARS%EFB2%R, YDVARS%EFB2%RCP, YDVARS%EFB2%T1)
  CALL GPRCP_EXPL_V (YDVARS%EFB3%LTHERMACT, YDVARS%EFB3%R, YDVARS%EFB3%RCP, YDVARS%EFB3%T1)
  CALL GPRCP_EXPL_V (YDVARS%A%LTHERMACT, YDVARS%A%R, YDVARS%A%RCP, YDVARS%A%T1)
  CALL GPRCP_EXPL_V (YDVARS%O3%LTHERMACT, YDVARS%O3%R, YDVARS%O3%RCP, YDVARS%O3%T1)
  CALL GPRCP_EXPL_V (YDVARS%SRC%LTHERMACT, YDVARS%SRC%R, YDVARS%SRC%RCP, YDVARS%SRC%T1)
  CALL GPRCP_EXPL_V (YDVARS%MXL%LTHERMACT, YDVARS%MXL%R, YDVARS%MXL%RCP, YDVARS%MXL%T1)
  CALL GPRCP_EXPL_V (YDVARS%SHTUR%LTHERMACT, YDVARS%SHTUR%R, YDVARS%SHTUR%RCP, YDVARS%SHTUR%T1)
  CALL GPRCP_EXPL_V (YDVARS%FQTUR%LTHERMACT, YDVARS%FQTUR%R, YDVARS%FQTUR%RCP, YDVARS%FQTUR%T1)
  CALL GPRCP_EXPL_V (YDVARS%FSTUR%LTHERMACT, YDVARS%FSTUR%R, YDVARS%FSTUR%RCP, YDVARS%FSTUR%T1)
  CALL GPRCP_EXPL_V (YDVARS%CPF%LTHERMACT, YDVARS%CPF%R, YDVARS%CPF%RCP, YDVARS%CPF%T1)
  CALL GPRCP_EXPL_V (YDVARS%SPF%LTHERMACT, YDVARS%SPF%R, YDVARS%SPF%RCP, YDVARS%SPF%T1)
  CALL GPRCP_EXPL_V (YDVARS%CVGQ%LTHERMACT, YDVARS%CVGQ%R, YDVARS%CVGQ%RCP, YDVARS%CVGQ%T1)
  CALL GPRCP_EXPL_V (YDVARS%QVA%LTHERMACT, YDVARS%QVA%R, YDVARS%QVA%RCP, YDVARS%QVA%T1)
  DO JFLD = 1, SIZE (YDVARS%GHG)
    CALL GPRCP_EXPL_V (YDVARS%GHG(JFLD)%LTHERMACT, YDVARS%GHG(JFLD)%R, YDVARS%GHG(JFLD)%RCP, YDVARS%GHG(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%CHEM)
    CALL GPRCP_EXPL_V (YDVARS%CHEM(JFLD)%LTHERMACT, YDVARS%CHEM(JFLD)%R, YDVARS%CHEM(JFLD)%RCP, YDVARS%CHEM(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERO)
    CALL GPRCP_EXPL_V (YDVARS%AERO(JFLD)%LTHERMACT, YDVARS%AERO(JFLD)%R, YDVARS%AERO(JFLD)%RCP, YDVARS%AERO(JFLD)%T1)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%LRCH4%LTHERMACT, YDVARS%LRCH4%R, YDVARS%LRCH4%RCP, YDVARS%LRCH4%T1)
  DO JFLD = 1, SIZE (YDVARS%FORC)
    CALL GPRCP_EXPL_V (YDVARS%FORC(JFLD)%LTHERMACT, YDVARS%FORC(JFLD)%R, YDVARS%FORC(JFLD)%RCP, YDVARS%FORC(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%EZDIAG)
    CALL GPRCP_EXPL_V (YDVARS%EZDIAG(JFLD)%LTHERMACT, YDVARS%EZDIAG(JFLD)%R, YDVARS%EZDIAG(JFLD)%RCP, YDVARS%EZDIAG(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%ERA40)
    CALL GPRCP_EXPL_V (YDVARS%ERA40(JFLD)%LTHERMACT, YDVARS%ERA40(JFLD)%R, YDVARS%ERA40(JFLD)%RCP, YDVARS%ERA40(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%NOGW)
    CALL GPRCP_EXPL_V (YDVARS%NOGW(JFLD)%LTHERMACT, YDVARS%NOGW(JFLD)%R, YDVARS%NOGW(JFLD)%RCP, YDVARS%NOGW(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%EDRP)
    CALL GPRCP_EXPL_V (YDVARS%EDRP(JFLD)%LTHERMACT, YDVARS%EDRP(JFLD)%R, YDVARS%EDRP(JFLD)%RCP, YDVARS%EDRP(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%SLDIA)
    CALL GPRCP_EXPL_V (YDVARS%SLDIA(JFLD)%LTHERMACT, YDVARS%SLDIA(JFLD)%R, YDVARS%SLDIA(JFLD)%RCP, YDVARS%SLDIA(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERAOT)
    CALL GPRCP_EXPL_V (YDVARS%AERAOT(JFLD)%LTHERMACT, YDVARS%AERAOT(JFLD)%R, YDVARS%AERAOT(JFLD)%RCP, YDVARS%AERAOT(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERLISI)
    CALL GPRCP_EXPL_V (YDVARS%AERLISI(JFLD)%LTHERMACT, YDVARS%AERLISI(JFLD)%R, YDVARS%AERLISI(JFLD)%RCP, YDVARS%AERLISI(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AEROUT)
    CALL GPRCP_EXPL_V (YDVARS%AEROUT(JFLD)%LTHERMACT, YDVARS%AEROUT(JFLD)%R, YDVARS%AEROUT(JFLD)%RCP, YDVARS%AEROUT(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AEROCLIM)
    CALL GPRCP_EXPL_V (YDVARS%AEROCLIM(JFLD)%LTHERMACT, YDVARS%AEROCLIM(JFLD)%R, YDVARS%AEROCLIM(JFLD)%RCP,&
        & YDVARS%AEROCLIM(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%UVP)
    CALL GPRCP_EXPL_V (YDVARS%UVP(JFLD)%LTHERMACT, YDVARS%UVP(JFLD)%R, YDVARS%UVP(JFLD)%RCP, YDVARS%UVP(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%PHYS)
    CALL GPRCP_EXPL_V (YDVARS%PHYS(JFLD)%LTHERMACT, YDVARS%PHYS(JFLD)%R, YDVARS%PHYS(JFLD)%RCP, YDVARS%PHYS(JFLD)%T1)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%PHYCTY%LTHERMACT, YDVARS%PHYCTY%R, YDVARS%PHYCTY%RCP, YDVARS%PHYCTY%T1)
  CALL GPRCP_EXPL_V (YDVARS%RSPEC%LTHERMACT, YDVARS%RSPEC%R, YDVARS%RSPEC%RCP, YDVARS%RSPEC%T1)
  CALL GPRCP_EXPL_V (YDVARS%SDSAT%LTHERMACT, YDVARS%SDSAT%R, YDVARS%SDSAT%RCP, YDVARS%SDSAT%T1)
  CALL GPRCP_EXPL_V (YDVARS%CVV%LTHERMACT, YDVARS%CVV%R, YDVARS%CVV%RCP, YDVARS%CVV%T1)
  CALL GPRCP_EXPL_V (YDVARS%RKTH%LTHERMACT, YDVARS%RKTH%R, YDVARS%RKTH%RCP, YDVARS%RKTH%T1)
  CALL GPRCP_EXPL_V (YDVARS%RKTQV%LTHERMACT, YDVARS%RKTQV%R, YDVARS%RKTQV%RCP, YDVARS%RKTQV%T1)
  CALL GPRCP_EXPL_V (YDVARS%RKTQC%LTHERMACT, YDVARS%RKTQC%R, YDVARS%RKTQC%RCP, YDVARS%RKTQC%T1)
  CALL GPRCP_EXPL_V (YDVARS%UOM%LTHERMACT, YDVARS%UOM%R, YDVARS%UOM%RCP, YDVARS%UOM%T1)
  CALL GPRCP_EXPL_V (YDVARS%UAL%LTHERMACT, YDVARS%UAL%R, YDVARS%UAL%RCP, YDVARS%UAL%T1)
  CALL GPRCP_EXPL_V (YDVARS%DOM%LTHERMACT, YDVARS%DOM%R, YDVARS%DOM%RCP, YDVARS%DOM%T1)
  CALL GPRCP_EXPL_V (YDVARS%DAL%LTHERMACT, YDVARS%DAL%R, YDVARS%DAL%RCP, YDVARS%DAL%T1)
  CALL GPRCP_EXPL_V (YDVARS%UEN%LTHERMACT, YDVARS%UEN%R, YDVARS%UEN%RCP, YDVARS%UEN%T1)
  CALL GPRCP_EXPL_V (YDVARS%UNEBH%LTHERMACT, YDVARS%UNEBH%R, YDVARS%UNEBH%RCP, YDVARS%UNEBH%T1)
  DO JFLD = 1, SIZE (YDVARS%CRM)
    CALL GPRCP_EXPL_V (YDVARS%CRM(JFLD)%LTHERMACT, YDVARS%CRM(JFLD)%R, YDVARS%CRM(JFLD)%RCP, YDVARS%CRM(JFLD)%T1)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%LIMA)
    CALL GPRCP_EXPL_V (YDVARS%LIMA(JFLD)%LTHERMACT, YDVARS%LIMA(JFLD)%R, YDVARS%LIMA(JFLD)%RCP, YDVARS%LIMA(JFLD)%T1)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%FSD%LTHERMACT, YDVARS%FSD%R, YDVARS%FSD%RCP, YDVARS%FSD%T1)
  DO JFLD = 1, SIZE (YDVARS%EXT)
    CALL GPRCP_EXPL_V (YDVARS%EXT(JFLD)%LTHERMACT, YDVARS%EXT(JFLD)%R, YDVARS%EXT(JFLD)%RCP, YDVARS%EXT(JFLD)%T1)
  ENDDO
  CASE (9)
  CALL GPRCP_EXPL_V (YDVARS%Q%LTHERMACT, YDVARS%Q%R, YDVARS%Q%RCP, YDVARS%Q%T9)
  CALL GPRCP_EXPL_V (YDVARS%I%LTHERMACT, YDVARS%I%R, YDVARS%I%RCP, YDVARS%I%T9)
  CALL GPRCP_EXPL_V (YDVARS%L%LTHERMACT, YDVARS%L%R, YDVARS%L%RCP, YDVARS%L%T9)
  CALL GPRCP_EXPL_V (YDVARS%LCONV%LTHERMACT, YDVARS%LCONV%R, YDVARS%LCONV%RCP, YDVARS%LCONV%T9)
  CALL GPRCP_EXPL_V (YDVARS%ICONV%LTHERMACT, YDVARS%ICONV%R, YDVARS%ICONV%RCP, YDVARS%ICONV%T9)
  CALL GPRCP_EXPL_V (YDVARS%RCONV%LTHERMACT, YDVARS%RCONV%R, YDVARS%RCONV%RCP, YDVARS%RCONV%T9)
  CALL GPRCP_EXPL_V (YDVARS%SCONV%LTHERMACT, YDVARS%SCONV%R, YDVARS%SCONV%RCP, YDVARS%SCONV%T9)
  CALL GPRCP_EXPL_V (YDVARS%IRAD%LTHERMACT, YDVARS%IRAD%R, YDVARS%IRAD%RCP, YDVARS%IRAD%T9)
  CALL GPRCP_EXPL_V (YDVARS%LRAD%LTHERMACT, YDVARS%LRAD%R, YDVARS%LRAD%RCP, YDVARS%LRAD%T9)
  CALL GPRCP_EXPL_V (YDVARS%S%LTHERMACT, YDVARS%S%R, YDVARS%S%RCP, YDVARS%S%T9)
  CALL GPRCP_EXPL_V (YDVARS%R%LTHERMACT, YDVARS%R%R, YDVARS%R%RCP, YDVARS%R%T9)
  CALL GPRCP_EXPL_V (YDVARS%G%LTHERMACT, YDVARS%G%R, YDVARS%G%RCP, YDVARS%G%T9)
  CALL GPRCP_EXPL_V (YDVARS%H%LTHERMACT, YDVARS%H%R, YDVARS%H%RCP, YDVARS%H%T9)
  CALL GPRCP_EXPL_V (YDVARS%TKE%LTHERMACT, YDVARS%TKE%R, YDVARS%TKE%RCP, YDVARS%TKE%T9)
  CALL GPRCP_EXPL_V (YDVARS%TTE%LTHERMACT, YDVARS%TTE%R, YDVARS%TTE%RCP, YDVARS%TTE%T9)
  CALL GPRCP_EXPL_V (YDVARS%EFB1%LTHERMACT, YDVARS%EFB1%R, YDVARS%EFB1%RCP, YDVARS%EFB1%T9)
  CALL GPRCP_EXPL_V (YDVARS%EFB2%LTHERMACT, YDVARS%EFB2%R, YDVARS%EFB2%RCP, YDVARS%EFB2%T9)
  CALL GPRCP_EXPL_V (YDVARS%EFB3%LTHERMACT, YDVARS%EFB3%R, YDVARS%EFB3%RCP, YDVARS%EFB3%T9)
  CALL GPRCP_EXPL_V (YDVARS%A%LTHERMACT, YDVARS%A%R, YDVARS%A%RCP, YDVARS%A%T9)
  CALL GPRCP_EXPL_V (YDVARS%O3%LTHERMACT, YDVARS%O3%R, YDVARS%O3%RCP, YDVARS%O3%T9)
  CALL GPRCP_EXPL_V (YDVARS%SRC%LTHERMACT, YDVARS%SRC%R, YDVARS%SRC%RCP, YDVARS%SRC%T9)
  CALL GPRCP_EXPL_V (YDVARS%MXL%LTHERMACT, YDVARS%MXL%R, YDVARS%MXL%RCP, YDVARS%MXL%T9)
  CALL GPRCP_EXPL_V (YDVARS%SHTUR%LTHERMACT, YDVARS%SHTUR%R, YDVARS%SHTUR%RCP, YDVARS%SHTUR%T9)
  CALL GPRCP_EXPL_V (YDVARS%FQTUR%LTHERMACT, YDVARS%FQTUR%R, YDVARS%FQTUR%RCP, YDVARS%FQTUR%T9)
  CALL GPRCP_EXPL_V (YDVARS%FSTUR%LTHERMACT, YDVARS%FSTUR%R, YDVARS%FSTUR%RCP, YDVARS%FSTUR%T9)
  CALL GPRCP_EXPL_V (YDVARS%CPF%LTHERMACT, YDVARS%CPF%R, YDVARS%CPF%RCP, YDVARS%CPF%T9)
  CALL GPRCP_EXPL_V (YDVARS%SPF%LTHERMACT, YDVARS%SPF%R, YDVARS%SPF%RCP, YDVARS%SPF%T9)
  CALL GPRCP_EXPL_V (YDVARS%CVGQ%LTHERMACT, YDVARS%CVGQ%R, YDVARS%CVGQ%RCP, YDVARS%CVGQ%T9)
  CALL GPRCP_EXPL_V (YDVARS%QVA%LTHERMACT, YDVARS%QVA%R, YDVARS%QVA%RCP, YDVARS%QVA%T9)
  DO JFLD = 1, SIZE (YDVARS%GHG)
    CALL GPRCP_EXPL_V (YDVARS%GHG(JFLD)%LTHERMACT, YDVARS%GHG(JFLD)%R, YDVARS%GHG(JFLD)%RCP, YDVARS%GHG(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%CHEM)
    CALL GPRCP_EXPL_V (YDVARS%CHEM(JFLD)%LTHERMACT, YDVARS%CHEM(JFLD)%R, YDVARS%CHEM(JFLD)%RCP, YDVARS%CHEM(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERO)
    CALL GPRCP_EXPL_V (YDVARS%AERO(JFLD)%LTHERMACT, YDVARS%AERO(JFLD)%R, YDVARS%AERO(JFLD)%RCP, YDVARS%AERO(JFLD)%T9)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%LRCH4%LTHERMACT, YDVARS%LRCH4%R, YDVARS%LRCH4%RCP, YDVARS%LRCH4%T9)
  DO JFLD = 1, SIZE (YDVARS%FORC)
    CALL GPRCP_EXPL_V (YDVARS%FORC(JFLD)%LTHERMACT, YDVARS%FORC(JFLD)%R, YDVARS%FORC(JFLD)%RCP, YDVARS%FORC(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%EZDIAG)
    CALL GPRCP_EXPL_V (YDVARS%EZDIAG(JFLD)%LTHERMACT, YDVARS%EZDIAG(JFLD)%R, YDVARS%EZDIAG(JFLD)%RCP, YDVARS%EZDIAG(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%ERA40)
    CALL GPRCP_EXPL_V (YDVARS%ERA40(JFLD)%LTHERMACT, YDVARS%ERA40(JFLD)%R, YDVARS%ERA40(JFLD)%RCP, YDVARS%ERA40(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%NOGW)
    CALL GPRCP_EXPL_V (YDVARS%NOGW(JFLD)%LTHERMACT, YDVARS%NOGW(JFLD)%R, YDVARS%NOGW(JFLD)%RCP, YDVARS%NOGW(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%EDRP)
    CALL GPRCP_EXPL_V (YDVARS%EDRP(JFLD)%LTHERMACT, YDVARS%EDRP(JFLD)%R, YDVARS%EDRP(JFLD)%RCP, YDVARS%EDRP(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%SLDIA)
    CALL GPRCP_EXPL_V (YDVARS%SLDIA(JFLD)%LTHERMACT, YDVARS%SLDIA(JFLD)%R, YDVARS%SLDIA(JFLD)%RCP, YDVARS%SLDIA(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERAOT)
    CALL GPRCP_EXPL_V (YDVARS%AERAOT(JFLD)%LTHERMACT, YDVARS%AERAOT(JFLD)%R, YDVARS%AERAOT(JFLD)%RCP, YDVARS%AERAOT(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AERLISI)
    CALL GPRCP_EXPL_V (YDVARS%AERLISI(JFLD)%LTHERMACT, YDVARS%AERLISI(JFLD)%R, YDVARS%AERLISI(JFLD)%RCP, YDVARS%AERLISI(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AEROUT)
    CALL GPRCP_EXPL_V (YDVARS%AEROUT(JFLD)%LTHERMACT, YDVARS%AEROUT(JFLD)%R, YDVARS%AEROUT(JFLD)%RCP, YDVARS%AEROUT(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%AEROCLIM)
    CALL GPRCP_EXPL_V (YDVARS%AEROCLIM(JFLD)%LTHERMACT, YDVARS%AEROCLIM(JFLD)%R, YDVARS%AEROCLIM(JFLD)%RCP,&
        & YDVARS%AEROCLIM(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%UVP)
    CALL GPRCP_EXPL_V (YDVARS%UVP(JFLD)%LTHERMACT, YDVARS%UVP(JFLD)%R, YDVARS%UVP(JFLD)%RCP, YDVARS%UVP(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%PHYS)
    CALL GPRCP_EXPL_V (YDVARS%PHYS(JFLD)%LTHERMACT, YDVARS%PHYS(JFLD)%R, YDVARS%PHYS(JFLD)%RCP, YDVARS%PHYS(JFLD)%T9)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%PHYCTY%LTHERMACT, YDVARS%PHYCTY%R, YDVARS%PHYCTY%RCP, YDVARS%PHYCTY%T9)
  CALL GPRCP_EXPL_V (YDVARS%RSPEC%LTHERMACT, YDVARS%RSPEC%R, YDVARS%RSPEC%RCP, YDVARS%RSPEC%T9)
  CALL GPRCP_EXPL_V (YDVARS%SDSAT%LTHERMACT, YDVARS%SDSAT%R, YDVARS%SDSAT%RCP, YDVARS%SDSAT%T9)
  CALL GPRCP_EXPL_V (YDVARS%CVV%LTHERMACT, YDVARS%CVV%R, YDVARS%CVV%RCP, YDVARS%CVV%T9)
  CALL GPRCP_EXPL_V (YDVARS%RKTH%LTHERMACT, YDVARS%RKTH%R, YDVARS%RKTH%RCP, YDVARS%RKTH%T9)
  CALL GPRCP_EXPL_V (YDVARS%RKTQV%LTHERMACT, YDVARS%RKTQV%R, YDVARS%RKTQV%RCP, YDVARS%RKTQV%T9)
  CALL GPRCP_EXPL_V (YDVARS%RKTQC%LTHERMACT, YDVARS%RKTQC%R, YDVARS%RKTQC%RCP, YDVARS%RKTQC%T9)
  CALL GPRCP_EXPL_V (YDVARS%UOM%LTHERMACT, YDVARS%UOM%R, YDVARS%UOM%RCP, YDVARS%UOM%T9)
  CALL GPRCP_EXPL_V (YDVARS%UAL%LTHERMACT, YDVARS%UAL%R, YDVARS%UAL%RCP, YDVARS%UAL%T9)
  CALL GPRCP_EXPL_V (YDVARS%DOM%LTHERMACT, YDVARS%DOM%R, YDVARS%DOM%RCP, YDVARS%DOM%T9)
  CALL GPRCP_EXPL_V (YDVARS%DAL%LTHERMACT, YDVARS%DAL%R, YDVARS%DAL%RCP, YDVARS%DAL%T9)
  CALL GPRCP_EXPL_V (YDVARS%UEN%LTHERMACT, YDVARS%UEN%R, YDVARS%UEN%RCP, YDVARS%UEN%T9)
  CALL GPRCP_EXPL_V (YDVARS%UNEBH%LTHERMACT, YDVARS%UNEBH%R, YDVARS%UNEBH%RCP, YDVARS%UNEBH%T9)
  DO JFLD = 1, SIZE (YDVARS%CRM)
    CALL GPRCP_EXPL_V (YDVARS%CRM(JFLD)%LTHERMACT, YDVARS%CRM(JFLD)%R, YDVARS%CRM(JFLD)%RCP, YDVARS%CRM(JFLD)%T9)
  ENDDO
  DO JFLD = 1, SIZE (YDVARS%LIMA)
    CALL GPRCP_EXPL_V (YDVARS%LIMA(JFLD)%LTHERMACT, YDVARS%LIMA(JFLD)%R, YDVARS%LIMA(JFLD)%RCP, YDVARS%LIMA(JFLD)%T9)
  ENDDO
  CALL GPRCP_EXPL_V (YDVARS%FSD%LTHERMACT, YDVARS%FSD%R, YDVARS%FSD%RCP, YDVARS%FSD%T9)
  DO JFLD = 1, SIZE (YDVARS%EXT)
    CALL GPRCP_EXPL_V (YDVARS%EXT(JFLD)%LTHERMACT, YDVARS%EXT(JFLD)%R, YDVARS%EXT(JFLD)%RCP, YDVARS%EXT(JFLD)%T9)
  ENDDO
  CASE DEFAULT
    CALL ABOR1 ('UNEXPECTED IGFLTYP')
END SELECT 

DO JLEV = 1, KFLEV
  DO JLON = KST, KPROF
    ZR (JLON,JLEV) = YDCST%RD + ZR (JLON,JLEV)
    IF (LLCP) THEN
      ZCP (JLON,JLEV) = YDCST%RCPD + ZCP (JLON,JLEV)
    ENDIF
  ENDDO
ENDDO

IF (PRESENT(PKAP)) THEN
  PKAP(KST:KPROF,1:KFLEV)=ZR(KST:KPROF,1:KFLEV)/ZCP(KST:KPROF,1:KFLEV)
ENDIF

IF (LHOOK) CALL DR_HOOK("GPRCP_EXPL",1,ZHOOK_HANDLE)

CONTAINS

SUBROUTINE GPRCP_EXPL_V (LDTHERMACT, PV_R, PV_RCP, PV_T)

LOGICAL, INTENT (IN) :: LDTHERMACT
REAL (KIND=JPRB), INTENT (IN) :: PV_R
REAL (KIND=JPRB), INTENT (IN) :: PV_RCP
REAL (KIND=JPRB), INTENT (IN) :: PV_T (KPROMA,KFLEV)

IF (LDTHERMACT) THEN
  DO JLEV = 1, KFLEV
    DO JLON = KST, KPROF
      ZR (JLON,JLEV) = ZR (JLON,JLEV) + (PV_R - YDCST%RD) * PV_T (JLON, JLEV)
      IF (LLCP) THEN
        ZCP (JLON,JLEV) = ZCP (JLON,JLEV) + (PV_RCP - YDCST%RCPD) * PV_T (JLON, JLEV)
      ENDIF
    ENDDO
  ENDDO
ENDIF

END SUBROUTINE GPRCP_EXPL_V

END SUBROUTINE GPRCP_EXPL

