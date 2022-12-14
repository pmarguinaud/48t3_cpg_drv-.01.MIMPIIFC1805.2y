SUBROUTINE CPG_DYN_SLG (YDGEOMETRY, YDCPG_BNDS, YDCPG_OPTS, YDCPG_TND, YDCPG_MISC, YDCPG_DYN0, YDCPG_DYN9, &
                      & YDVARS, YDCPG_SL1, YDCPG_SL2, YDMODEL, PSLHDA, PSLHDD0, KSETTLOFF, PGMVTNDSI)

USE PARKIND1, ONLY : JPIM, JPRB

USE GEOMETRY_MOD , ONLY : GEOMETRY
USE CPG_OPTS_TYPE_MOD, ONLY : CPG_BNDS_TYPE, CPG_OPTS_TYPE
USE CPG_TYPE_MOD,ONLY : CPG_DYN_TYPE, CPG_MISC_TYPE, CPG_TND_TYPE, CPG_SL1_TYPE, CPG_SL2_TYPE
USE FIELD_VARIABLES_MOD,ONLY : FIELD_VARIABLES
USE TYPE_MODEL   , ONLY : MODEL
USE YOMCT0, ONLY : LTWOTL


IMPLICIT NONE

TYPE(GEOMETRY)        ,INTENT(IN)     :: YDGEOMETRY
TYPE(CPG_BNDS_TYPE)   ,INTENT(IN)     :: YDCPG_BNDS
TYPE(CPG_OPTS_TYPE)   ,INTENT(IN)     :: YDCPG_OPTS
TYPE(CPG_TND_TYPE)    ,INTENT(INOUT)  :: YDCPG_TND
TYPE(CPG_MISC_TYPE)   ,INTENT(INOUT)  :: YDCPG_MISC
TYPE(CPG_DYN_TYPE)    ,INTENT(INOUT)  :: YDCPG_DYN0
TYPE(CPG_DYN_TYPE)    ,INTENT(INOUT)  :: YDCPG_DYN9
TYPE(FIELD_VARIABLES) ,INTENT(INOUT)  :: YDVARS
TYPE(CPG_SL1_TYPE)    ,INTENT(INOUT)  :: YDCPG_SL1
TYPE(CPG_SL2_TYPE)    ,INTENT(INOUT)  :: YDCPG_SL2
TYPE(MODEL)           ,INTENT(INOUT)  :: YDMODEL
REAL(KIND=JPRB)       ,INTENT(IN)     :: PSLHDA(YDGEOMETRY%YRDIM%NPROMA)
REAL(KIND=JPRB)       ,INTENT(IN)     :: PSLHDD0(YDGEOMETRY%YRDIM%NPROMA)
INTEGER(KIND=JPIM)    ,INTENT(OUT)    :: KSETTLOFF(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG)
REAL(KIND=JPRB)       ,INTENT(INOUT)  :: PGMVTNDSI(YDGEOMETRY%YRDIM%NPROMA,YDGEOMETRY%YRDIMV%NFLEVG,YDMODEL%YRML_DIAG%YRMDDH%NDIMSIGMV)

#include "lacdyn.intfb.h"
#include "vdiflcz.intfb.h"


!*       2.1   Semi-lagrangian dynamics (not lagged part).

CALL LACDYN(YDMODEL%YRCST, YDGEOMETRY, YDVARS, YDCPG_SL1, YDCPG_SL2, YDCPG_BNDS, YDCPG_OPTS, YDCPG_TND, &
& YDCPG_DYN0, YDCPG_DYN9, YDMODEL, PSLHDA, PSLHDD0, KSETTLOFF, PGMVTNDSI)

!*       2.2   Simple physics.

IF ((.NOT.(YDMODEL%YRML_PHY_MF%YRPHY%LMPHYS.OR.YDMODEL%YRML_PHY_EC%YREPHY%LEPHYS)).AND.YDMODEL%YRML_PHY_SLIN%YRPHLC%LSPHLC) THEN
  IF (LTWOTL) THEN
    CALL VDIFLCZ(YDMODEL%YRML_PHY_G%YRVDF, YDGEOMETRY%YRVAB, YDMODEL%YRML_PHY_SLIN%YRPHLC, YDCPG_BNDS%KIDIA, YDCPG_BNDS%KFDIA, YDGEOMETRY%YRDIM%NPROMA, YDGEOMETRY%YRDIMV%NFLEVG, YDCPG_OPTS%ZDT, YDCPG_MISC%LSM, &
    & YDCPG_DYN0%PHI, YDCPG_DYN0%PHIF, YDCPG_DYN0%RCP%CP, YDCPG_DYN0%RCP%R, YDCPG_DYN0%XYB%RDELP, YDVARS%U%T0,  &
    & YDVARS%V%T0, YDVARS%T%T0, YDCPG_DYN0%PRE, YDVARS%U%T0, YDVARS%V%T0, YDVARS%T%T0, YDVARS%U%T1,             &
    & YDVARS%V%T1, YDVARS%T%T1)
  ELSE
    CALL VDIFLCZ(YDMODEL%YRML_PHY_G%YRVDF, YDGEOMETRY%YRVAB, YDMODEL%YRML_PHY_SLIN%YRPHLC, YDCPG_BNDS%KIDIA, YDCPG_BNDS%KFDIA, YDGEOMETRY%YRDIM%NPROMA, YDGEOMETRY%YRDIMV%NFLEVG, YDCPG_OPTS%ZDT, YDCPG_MISC%LSM, &
    & YDCPG_DYN0%PHI, YDCPG_DYN0%PHIF, YDCPG_DYN0%RCP%CP, YDCPG_DYN0%RCP%R, YDCPG_DYN0%XYB%RDELP, YDVARS%U%T0,  &
    & YDVARS%V%T0, YDVARS%T%T0, YDCPG_DYN0%PRE, YDVARS%U%T9, YDVARS%V%T9, YDVARS%T%T9, YDVARS%U%T1,             &
    & YDVARS%V%T1, YDVARS%T%T1)
  ENDIF
ENDIF

END SUBROUTINE
