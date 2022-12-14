
SUBROUTINE LATTEX_EXPL_VSPLTRANS (YDGEOMETRY, YDCPG_BNDS, YDML_GCONF, YDML_DYN, YDCPG_SL1)

! **  NEVER TESTED **

USE PARKIND1              , ONLY : JPIM, JPRB
USE YOMHOOK               , ONLY : DR_HOOK, LHOOK
USE GEOMETRY_MOD          , ONLY : GEOMETRY
USE CPG_OPTS_TYPE_MOD     , ONLY : CPG_BNDS_TYPE
USE MODEL_GENERAL_CONF_MOD, ONLY : MODEL_GENERAL_CONF_TYPE
USE MODEL_DYNAMICS_MOD    , ONLY : MODEL_DYNAMICS_TYPE
USE CPG_TYPE_MOD          , ONLY : CPG_SL1_TYPE


IMPLICIT NONE

TYPE(GEOMETRY)                ,INTENT(IN)     :: YDGEOMETRY
TYPE(CPG_BNDS_TYPE)           ,INTENT(IN)     :: YDCPG_BNDS
TYPE(MODEL_GENERAL_CONF_TYPE) ,INTENT(IN)     :: YDML_GCONF
TYPE(MODEL_DYNAMICS_TYPE)     ,INTENT(IN)     :: YDML_DYN
TYPE(CPG_SL1_TYPE)            ,INTENT(INOUT)  :: YDCPG_SL1

#include "vspltrans.intfb.h"

LOGICAL :: LLTDIABLIN
INTEGER (KIND=JPIM) :: JLEV
INTEGER (KIND=JPIM) :: JROF
INTEGER (KIND=JPIM) :: JGFL

REAL(KIND=JPRB) :: ZHOOK_HANDLE

IF (LHOOK) CALL DR_HOOK('LATTEX_EXPL_VSPLTRANS',0,ZHOOK_HANDLE)

CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YQ%LADV, YDML_GCONF%YGFL%YQ%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YQ%CSLINT, YDCPG_SL1%Q%P, YDCPG_SL1%Q%P_F, &
                            & YDCPG_SL1%Q%P_SP, YDCPG_SL1%Q%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YI%LADV, YDML_GCONF%YGFL%YI%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YI%CSLINT, YDCPG_SL1%I%P, YDCPG_SL1%I%P_F, &
                            & YDCPG_SL1%I%P_SP, YDCPG_SL1%I%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YL%LADV, YDML_GCONF%YGFL%YL%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YL%CSLINT, YDCPG_SL1%L%P, YDCPG_SL1%L%P_F, &
                            & YDCPG_SL1%L%P_SP, YDCPG_SL1%L%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YLCONV%LADV, YDML_GCONF%YGFL%YLCONV%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YLCONV%CSLINT, YDCPG_SL1%LCONV%P, YDCPG_SL1%LCONV%P_F, &
                            & YDCPG_SL1%LCONV%P_SP, YDCPG_SL1%LCONV%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YICONV%LADV, YDML_GCONF%YGFL%YICONV%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YICONV%CSLINT, YDCPG_SL1%ICONV%P, YDCPG_SL1%ICONV%P_F, &
                            & YDCPG_SL1%ICONV%P_SP, YDCPG_SL1%ICONV%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YRCONV%LADV, YDML_GCONF%YGFL%YRCONV%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YRCONV%CSLINT, YDCPG_SL1%RCONV%P, YDCPG_SL1%RCONV%P_F, &
                            & YDCPG_SL1%RCONV%P_SP, YDCPG_SL1%RCONV%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YSCONV%LADV, YDML_GCONF%YGFL%YSCONV%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YSCONV%CSLINT, YDCPG_SL1%SCONV%P, YDCPG_SL1%SCONV%P_F, &
                            & YDCPG_SL1%SCONV%P_SP, YDCPG_SL1%SCONV%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YIRAD%LADV, YDML_GCONF%YGFL%YIRAD%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YIRAD%CSLINT, YDCPG_SL1%IRAD%P, YDCPG_SL1%IRAD%P_F, &
                            & YDCPG_SL1%IRAD%P_SP, YDCPG_SL1%IRAD%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YLRAD%LADV, YDML_GCONF%YGFL%YLRAD%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YLRAD%CSLINT, YDCPG_SL1%LRAD%P, YDCPG_SL1%LRAD%P_F, &
                            & YDCPG_SL1%LRAD%P_SP, YDCPG_SL1%LRAD%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YS%LADV, YDML_GCONF%YGFL%YS%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YS%CSLINT, YDCPG_SL1%S%P, YDCPG_SL1%S%P_F, &
                            & YDCPG_SL1%S%P_SP, YDCPG_SL1%S%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YR%LADV, YDML_GCONF%YGFL%YR%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YR%CSLINT, YDCPG_SL1%R%P, YDCPG_SL1%R%P_F, &
                            & YDCPG_SL1%R%P_SP, YDCPG_SL1%R%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YG%LADV, YDML_GCONF%YGFL%YG%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YG%CSLINT, YDCPG_SL1%G%P, YDCPG_SL1%G%P_F, &
                            & YDCPG_SL1%G%P_SP, YDCPG_SL1%G%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YH%LADV, YDML_GCONF%YGFL%YH%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YH%CSLINT, YDCPG_SL1%H%P, YDCPG_SL1%H%P_F, &
                            & YDCPG_SL1%H%P_SP, YDCPG_SL1%H%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YTKE%LADV, YDML_GCONF%YGFL%YTKE%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YTKE%CSLINT, YDCPG_SL1%TKE%P, YDCPG_SL1%TKE%P_F, &
                            & YDCPG_SL1%TKE%P_SP, YDCPG_SL1%TKE%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YTTE%LADV, YDML_GCONF%YGFL%YTTE%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YTTE%CSLINT, YDCPG_SL1%TTE%P, YDCPG_SL1%TTE%P_F, &
                            & YDCPG_SL1%TTE%P_SP, YDCPG_SL1%TTE%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YEFB1%LADV, YDML_GCONF%YGFL%YEFB1%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YEFB1%CSLINT, YDCPG_SL1%EFB1%P, YDCPG_SL1%EFB1%P_F, &
                            & YDCPG_SL1%EFB1%P_SP, YDCPG_SL1%EFB1%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YEFB2%LADV, YDML_GCONF%YGFL%YEFB2%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YEFB2%CSLINT, YDCPG_SL1%EFB2%P, YDCPG_SL1%EFB2%P_F, &
                            & YDCPG_SL1%EFB2%P_SP, YDCPG_SL1%EFB2%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YEFB3%LADV, YDML_GCONF%YGFL%YEFB3%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YEFB3%CSLINT, YDCPG_SL1%EFB3%P, YDCPG_SL1%EFB3%P_F, &
                            & YDCPG_SL1%EFB3%P_SP, YDCPG_SL1%EFB3%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YA%LADV, YDML_GCONF%YGFL%YA%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YA%CSLINT, YDCPG_SL1%A%P, YDCPG_SL1%A%P_F, &
                            & YDCPG_SL1%A%P_SP, YDCPG_SL1%A%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YO3%LADV, YDML_GCONF%YGFL%YO3%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YO3%CSLINT, YDCPG_SL1%O3%P, YDCPG_SL1%O3%P_F, &
                            & YDCPG_SL1%O3%P_SP, YDCPG_SL1%O3%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YSRC%LADV, YDML_GCONF%YGFL%YSRC%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YSRC%CSLINT, YDCPG_SL1%SRC%P, YDCPG_SL1%SRC%P_F, &
                            & YDCPG_SL1%SRC%P_SP, YDCPG_SL1%SRC%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YMXL%LADV, YDML_GCONF%YGFL%YMXL%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YMXL%CSLINT, YDCPG_SL1%MXL%P, YDCPG_SL1%MXL%P_F, &
                            & YDCPG_SL1%MXL%P_SP, YDCPG_SL1%MXL%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YSHTUR%LADV, YDML_GCONF%YGFL%YSHTUR%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YSHTUR%CSLINT, YDCPG_SL1%SHTUR%P, YDCPG_SL1%SHTUR%P_F, &
                            & YDCPG_SL1%SHTUR%P_SP, YDCPG_SL1%SHTUR%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YFQTUR%LADV, YDML_GCONF%YGFL%YFQTUR%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YFQTUR%CSLINT, YDCPG_SL1%FQTUR%P, YDCPG_SL1%FQTUR%P_F, &
                            & YDCPG_SL1%FQTUR%P_SP, YDCPG_SL1%FQTUR%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YFSTUR%LADV, YDML_GCONF%YGFL%YFSTUR%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YFSTUR%CSLINT, YDCPG_SL1%FSTUR%P, YDCPG_SL1%FSTUR%P_F, &
                            & YDCPG_SL1%FSTUR%P_SP, YDCPG_SL1%FSTUR%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YCPF%LADV, YDML_GCONF%YGFL%YCPF%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YCPF%CSLINT, YDCPG_SL1%CPF%P, YDCPG_SL1%CPF%P_F, &
                            & YDCPG_SL1%CPF%P_SP, YDCPG_SL1%CPF%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YSPF%LADV, YDML_GCONF%YGFL%YSPF%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YSPF%CSLINT, YDCPG_SL1%SPF%P, YDCPG_SL1%SPF%P_F, &
                            & YDCPG_SL1%SPF%P_SP, YDCPG_SL1%SPF%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YCVGQ%LADV, YDML_GCONF%YGFL%YCVGQ%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YCVGQ%CSLINT, YDCPG_SL1%CVGQ%P, YDCPG_SL1%CVGQ%P_F, &
                            & YDCPG_SL1%CVGQ%P_SP, YDCPG_SL1%CVGQ%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YQVA%LADV, YDML_GCONF%YGFL%YQVA%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YQVA%CSLINT, YDCPG_SL1%QVA%P, YDCPG_SL1%QVA%P_F, &
                            & YDCPG_SL1%QVA%P_SP, YDCPG_SL1%QVA%P_SPF)
DO JGFL = 1, SIZE (YDCPG_SL1%GHG)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YGHG(JGFL)%LADV, YDML_GCONF%YGFL%YGHG(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YGHG(JGFL)%CSLINT, YDCPG_SL1%GHG(JGFL)%P, YDCPG_SL1%GHG(JGFL)%P_F, &
                              & YDCPG_SL1%GHG(JGFL)%P_SP, YDCPG_SL1%GHG(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%CHEM)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YCHEM(JGFL)%LADV, YDML_GCONF%YGFL%YCHEM(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YCHEM(JGFL)%CSLINT, YDCPG_SL1%CHEM(JGFL)%P, YDCPG_SL1%CHEM(JGFL)%P_F, &
                              & YDCPG_SL1%CHEM(JGFL)%P_SP, YDCPG_SL1%CHEM(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%AERO)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YAERO(JGFL)%LADV, YDML_GCONF%YGFL%YAERO(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YAERO(JGFL)%CSLINT, YDCPG_SL1%AERO(JGFL)%P, YDCPG_SL1%AERO(JGFL)%P_F, &
                              & YDCPG_SL1%AERO(JGFL)%P_SP, YDCPG_SL1%AERO(JGFL)%P_SPF)
ENDDO
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YLRCH4%LADV, YDML_GCONF%YGFL%YLRCH4%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YLRCH4%CSLINT, YDCPG_SL1%LRCH4%P, YDCPG_SL1%LRCH4%P_F, &
                            & YDCPG_SL1%LRCH4%P_SP, YDCPG_SL1%LRCH4%P_SPF)
DO JGFL = 1, SIZE (YDCPG_SL1%FORC)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YFORC(JGFL)%LADV, YDML_GCONF%YGFL%YFORC(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YFORC(JGFL)%CSLINT, YDCPG_SL1%FORC(JGFL)%P, YDCPG_SL1%FORC(JGFL)%P_F, &
                              & YDCPG_SL1%FORC(JGFL)%P_SP, YDCPG_SL1%FORC(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%EZDIAG)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YEZDIAG(JGFL)%LADV, YDML_GCONF%YGFL%YEZDIAG(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YEZDIAG(JGFL)%CSLINT, YDCPG_SL1%EZDIAG(JGFL)%P, YDCPG_SL1%EZDIAG(JGFL)%P_F, &
                              & YDCPG_SL1%EZDIAG(JGFL)%P_SP, YDCPG_SL1%EZDIAG(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%ERA40)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YERA40(JGFL)%LADV, YDML_GCONF%YGFL%YERA40(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YERA40(JGFL)%CSLINT, YDCPG_SL1%ERA40(JGFL)%P, YDCPG_SL1%ERA40(JGFL)%P_F, &
                              & YDCPG_SL1%ERA40(JGFL)%P_SP, YDCPG_SL1%ERA40(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%NOGW)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YNOGW(JGFL)%LADV, YDML_GCONF%YGFL%YNOGW(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YNOGW(JGFL)%CSLINT, YDCPG_SL1%NOGW(JGFL)%P, YDCPG_SL1%NOGW(JGFL)%P_F, &
                              & YDCPG_SL1%NOGW(JGFL)%P_SP, YDCPG_SL1%NOGW(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%EDRP)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YEDRP(JGFL)%LADV, YDML_GCONF%YGFL%YEDRP(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YEDRP(JGFL)%CSLINT, YDCPG_SL1%EDRP(JGFL)%P, YDCPG_SL1%EDRP(JGFL)%P_F, &
                              & YDCPG_SL1%EDRP(JGFL)%P_SP, YDCPG_SL1%EDRP(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%SLDIA)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YSLDIA(JGFL)%LADV, YDML_GCONF%YGFL%YSLDIA(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YSLDIA(JGFL)%CSLINT, YDCPG_SL1%SLDIA(JGFL)%P, YDCPG_SL1%SLDIA(JGFL)%P_F, &
                              & YDCPG_SL1%SLDIA(JGFL)%P_SP, YDCPG_SL1%SLDIA(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%AERAOT)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YAERAOT(JGFL)%LADV, YDML_GCONF%YGFL%YAERAOT(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YAERAOT(JGFL)%CSLINT, YDCPG_SL1%AERAOT(JGFL)%P, YDCPG_SL1%AERAOT(JGFL)%P_F, &
                              & YDCPG_SL1%AERAOT(JGFL)%P_SP, YDCPG_SL1%AERAOT(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%AERLISI)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YAERLISI(JGFL)%LADV, YDML_GCONF%YGFL%YAERLISI(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YAERLISI(JGFL)%CSLINT, YDCPG_SL1%AERLISI(JGFL)%P, YDCPG_SL1%AERLISI(JGFL)%P_F, &
                              & YDCPG_SL1%AERLISI(JGFL)%P_SP, YDCPG_SL1%AERLISI(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%AEROUT)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YAEROUT(JGFL)%LADV, YDML_GCONF%YGFL%YAEROUT(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YAEROUT(JGFL)%CSLINT, YDCPG_SL1%AEROUT(JGFL)%P, YDCPG_SL1%AEROUT(JGFL)%P_F, &
                              & YDCPG_SL1%AEROUT(JGFL)%P_SP, YDCPG_SL1%AEROUT(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%AEROCLIM)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YAEROCLIM(JGFL)%LADV, YDML_GCONF%YGFL%YAEROCLIM(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YAEROCLIM(JGFL)%CSLINT, YDCPG_SL1%AEROCLIM(JGFL)%P, YDCPG_SL1%AEROCLIM(JGFL)%P_F, &
                              & YDCPG_SL1%AEROCLIM(JGFL)%P_SP, YDCPG_SL1%AEROCLIM(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%UVP)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YUVP(JGFL)%LADV, YDML_GCONF%YGFL%YUVP(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YUVP(JGFL)%CSLINT, YDCPG_SL1%UVP(JGFL)%P, YDCPG_SL1%UVP(JGFL)%P_F, &
                              & YDCPG_SL1%UVP(JGFL)%P_SP, YDCPG_SL1%UVP(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%PHYS)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YPHYS(JGFL)%LADV, YDML_GCONF%YGFL%YPHYS(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YPHYS(JGFL)%CSLINT, YDCPG_SL1%PHYS(JGFL)%P, YDCPG_SL1%PHYS(JGFL)%P_F, &
                              & YDCPG_SL1%PHYS(JGFL)%P_SP, YDCPG_SL1%PHYS(JGFL)%P_SPF)
ENDDO
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YPHYCTY%LADV, YDML_GCONF%YGFL%YPHYCTY%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YPHYCTY%CSLINT, YDCPG_SL1%PHYCTY%P, YDCPG_SL1%PHYCTY%P_F, &
                            & YDCPG_SL1%PHYCTY%P_SP, YDCPG_SL1%PHYCTY%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YRSPEC%LADV, YDML_GCONF%YGFL%YRSPEC%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YRSPEC%CSLINT, YDCPG_SL1%RSPEC%P, YDCPG_SL1%RSPEC%P_F, &
                            & YDCPG_SL1%RSPEC%P_SP, YDCPG_SL1%RSPEC%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YSDSAT%LADV, YDML_GCONF%YGFL%YSDSAT%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YSDSAT%CSLINT, YDCPG_SL1%SDSAT%P, YDCPG_SL1%SDSAT%P_F, &
                            & YDCPG_SL1%SDSAT%P_SP, YDCPG_SL1%SDSAT%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YCVV%LADV, YDML_GCONF%YGFL%YCVV%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YCVV%CSLINT, YDCPG_SL1%CVV%P, YDCPG_SL1%CVV%P_F, &
                            & YDCPG_SL1%CVV%P_SP, YDCPG_SL1%CVV%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YRKTH%LADV, YDML_GCONF%YGFL%YRKTH%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YRKTH%CSLINT, YDCPG_SL1%RKTH%P, YDCPG_SL1%RKTH%P_F, &
                            & YDCPG_SL1%RKTH%P_SP, YDCPG_SL1%RKTH%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YRKTQV%LADV, YDML_GCONF%YGFL%YRKTQV%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YRKTQV%CSLINT, YDCPG_SL1%RKTQV%P, YDCPG_SL1%RKTQV%P_F, &
                            & YDCPG_SL1%RKTQV%P_SP, YDCPG_SL1%RKTQV%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YRKTQC%LADV, YDML_GCONF%YGFL%YRKTQC%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YRKTQC%CSLINT, YDCPG_SL1%RKTQC%P, YDCPG_SL1%RKTQC%P_F, &
                            & YDCPG_SL1%RKTQC%P_SP, YDCPG_SL1%RKTQC%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YUOM%LADV, YDML_GCONF%YGFL%YUOM%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YUOM%CSLINT, YDCPG_SL1%UOM%P, YDCPG_SL1%UOM%P_F, &
                            & YDCPG_SL1%UOM%P_SP, YDCPG_SL1%UOM%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YUAL%LADV, YDML_GCONF%YGFL%YUAL%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YUAL%CSLINT, YDCPG_SL1%UAL%P, YDCPG_SL1%UAL%P_F, &
                            & YDCPG_SL1%UAL%P_SP, YDCPG_SL1%UAL%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YDOM%LADV, YDML_GCONF%YGFL%YDOM%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YDOM%CSLINT, YDCPG_SL1%DOM%P, YDCPG_SL1%DOM%P_F, &
                            & YDCPG_SL1%DOM%P_SP, YDCPG_SL1%DOM%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YDAL%LADV, YDML_GCONF%YGFL%YDAL%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YDAL%CSLINT, YDCPG_SL1%DAL%P, YDCPG_SL1%DAL%P_F, &
                            & YDCPG_SL1%DAL%P_SP, YDCPG_SL1%DAL%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YUEN%LADV, YDML_GCONF%YGFL%YUEN%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YUEN%CSLINT, YDCPG_SL1%UEN%P, YDCPG_SL1%UEN%P_F, &
                            & YDCPG_SL1%UEN%P_SP, YDCPG_SL1%UEN%P_SPF)
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YUNEBH%LADV, YDML_GCONF%YGFL%YUNEBH%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YUNEBH%CSLINT, YDCPG_SL1%UNEBH%P, YDCPG_SL1%UNEBH%P_F, &
                            & YDCPG_SL1%UNEBH%P_SP, YDCPG_SL1%UNEBH%P_SPF)
DO JGFL = 1, SIZE (YDCPG_SL1%CRM)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YCRM(JGFL)%LADV, YDML_GCONF%YGFL%YCRM(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YCRM(JGFL)%CSLINT, YDCPG_SL1%CRM(JGFL)%P, YDCPG_SL1%CRM(JGFL)%P_F, &
                              & YDCPG_SL1%CRM(JGFL)%P_SP, YDCPG_SL1%CRM(JGFL)%P_SPF)
ENDDO
DO JGFL = 1, SIZE (YDCPG_SL1%LIMA)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YLIMA(JGFL)%LADV, YDML_GCONF%YGFL%YLIMA(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YLIMA(JGFL)%CSLINT, YDCPG_SL1%LIMA(JGFL)%P, YDCPG_SL1%LIMA(JGFL)%P_F, &
                              & YDCPG_SL1%LIMA(JGFL)%P_SP, YDCPG_SL1%LIMA(JGFL)%P_SPF)
ENDDO
CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YFSD%LADV, YDML_GCONF%YGFL%YFSD%LTDIABLIN,          &
                            & YDML_GCONF%YGFL%YFSD%CSLINT, YDCPG_SL1%FSD%P, YDCPG_SL1%FSD%P_F, &
                            & YDCPG_SL1%FSD%P_SP, YDCPG_SL1%FSD%P_SPF)
DO JGFL = 1, SIZE (YDCPG_SL1%EXT)
  CALL LATTEX_EXPL_VSPLTRANS_V (YDML_GCONF%YGFL%YEXT(JGFL)%LADV, YDML_GCONF%YGFL%YEXT(JGFL)%LTDIABLIN,          &
                              & YDML_GCONF%YGFL%YEXT(JGFL)%CSLINT, YDCPG_SL1%EXT(JGFL)%P, YDCPG_SL1%EXT(JGFL)%P_F, &
                              & YDCPG_SL1%EXT(JGFL)%P_SP, YDCPG_SL1%EXT(JGFL)%P_SPF)
ENDDO

!  DO JGFL=1,YDML_GCONF%YGFL%NUMFLDS
!    IF(YDML_GCONF%YGFL%YCOMP(JGFL)%LADV .AND. YDML_GCONF%YGFL%YCOMP(JGFL)%CSLINT=='LAITVSPCQM  ' ) THEN
!      IPX  =(YDML_GCONF%YGFL%YCOMP(JGFL)%MP_SL1-1)*(YDGEOMETRY%YRDIMV%NFLEN-YDGEOMETRY%YRDIMV%NFLSA+1)
!      IPXSP=(YDML_GCONF%YGFL%YCOMP(JGFL)%MP_SPL-1)*(YDGEOMETRY%YRDIMV%NFLEN-YDGEOMETRY%YRDIMV%NFLSA+1)
!      LLTDIABLIN=YDML_GCONF%YGFL%YCOMP(JGFL)%LTDIABLIN
!      IF ((YDML_DYN%YRDYN%NSPLTHOI /= 0).OR.LLTDIABLIN) THEN
!        DO JLEV=1,YDGEOMETRY%YRDIMV%NFLEVG
!          DO JROF=YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA
!            YDCPG_SL1%ZVIEW(JROF,YDML_DYN%YRPTRSLB1%MSLB1GFLSPF9+IPXSP+JLEV-YDGEOMETRY%YRDIMV%NFLSA)=&
!          & YDCPG_SL1%ZVIEW(JROF,YDML_DYN%YRPTRSLB1%MSLB1GFLF9  +IPX  +JLEV-YDGEOMETRY%YRDIMV%NFLSA)
!          ENDDO
!        ENDDO
!        CALL VSPLTRANS(YDGEOMETRY%YRVSPLIP,YDGEOMETRY%YRDIM%NPROMA,YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,
!                     & YDGEOMETRY%YRDIMV%NFLEVG,YDGEOMETRY%YRDIMV%NFLSA,YDGEOMETRY%YRDIMV%NFLEN,
!                     & YDCPG_SL1%ZVIEW(:,YDML_DYN%YRPTRSLB1%MSLB1GFLSPF9+IPXSP))
!      ENDIF
!      DO JLEV=1,YDGEOMETRY%YRDIMV%NFLEVG
!        DO JROF=YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA
!          YDCPG_SL1%ZVIEW(JROF,YDML_DYN%YRPTRSLB1%MSLB1GFLSP9+IPXSP+JLEV-YDGEOMETRY%YRDIMV%NFLSA)=&
!        & YDCPG_SL1%ZVIEW(JROF,YDML_DYN%YRPTRSLB1%MSLB1GFL9  +IPX  +JLEV-YDGEOMETRY%YRDIMV%NFLSA)
!        ENDDO
!      ENDDO
!      CALL VSPLTRANS(YDGEOMETRY%YRVSPLIP,YDGEOMETRY%YRDIM%NPROMA,YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,&
!                   & YDGEOMETRY%YRDIMV%NFLEVG,YDGEOMETRY%YRDIMV%NFLSA,YDGEOMETRY%YRDIMV%NFLEN,&
!                   & YDCPG_SL1%ZVIEW(:,YDML_DYN%YRPTRSLB1%MSLB1GFLSP9+IPXSP))
!    ENDIF
!  ENDDO

IF (LHOOK) CALL DR_HOOK('LATTEX_EXPL_VSPLTRANS',1,ZHOOK_HANDLE)

CONTAINS

SUBROUTINE LATTEX_EXPL_VSPLTRANS_V (LDADV, LDTDIABLIN, CDSLINT, PSL1, PSL1_F, PSL1_SPF, PSL1_SP)

LOGICAL            , INTENT (IN)    :: LDADV
LOGICAL            , INTENT (IN)    :: LDTDIABLIN
CHARACTER (LEN=*)  , INTENT (IN)    :: CDSLINT
REAL (KIND=JPRB)   , INTENT (IN)    :: PSL1     (YDGEOMETRY%YRDIM%NPROMA,0:YDGEOMETRY%YRDIMV%NFLEVG+1)
REAL (KIND=JPRB)   , INTENT (IN)    :: PSL1_F   (YDGEOMETRY%YRDIM%NPROMA,0:YDGEOMETRY%YRDIMV%NFLEVG+1)
REAL (KIND=JPRB)   , INTENT (INOUT) :: PSL1_SP  (YDGEOMETRY%YRDIM%NPROMA,0:YDGEOMETRY%YRDIMV%NFLEVG+1)
REAL (KIND=JPRB)   , INTENT (INOUT) :: PSL1_SPF (YDGEOMETRY%YRDIM%NPROMA,0:YDGEOMETRY%YRDIMV%NFLEVG+1)

IF (LDADV .AND. CDSLINT=='LAITVSPCQM  ') THEN
  LLTDIABLIN=LDTDIABLIN
  IF ((YDML_DYN%YRDYN%NSPLTHOI /= 0).OR.LLTDIABLIN) THEN
    DO JLEV=1,YDGEOMETRY%YRDIMV%NFLEVG
      DO JROF=YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA
        PSL1_SPF(JROF,JLEV)=PSL1_F(JROF,JLEV)
      ENDDO
    ENDDO
    CALL VSPLTRANS(YDGEOMETRY%YRVSPLIP,YDGEOMETRY%YRDIM%NPROMA,YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,&
                 & YDGEOMETRY%YRDIMV%NFLEVG,YDGEOMETRY%YRDIMV%NFLSA,YDGEOMETRY%YRDIMV%NFLEN,PSL1_SPF)
  ENDIF
  DO JLEV=1,YDGEOMETRY%YRDIMV%NFLEVG
    DO JROF=YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA
      PSL1_SP(JROF,JLEV)=PSL1(JROF,JLEV)
    ENDDO
  ENDDO
  CALL VSPLTRANS(YDGEOMETRY%YRVSPLIP,YDGEOMETRY%YRDIM%NPROMA,YDCPG_BNDS%KIDIA,YDCPG_BNDS%KFDIA,&
               & YDGEOMETRY%YRDIMV%NFLEVG,YDGEOMETRY%YRDIMV%NFLSA,YDGEOMETRY%YRDIMV%NFLEN,PSL1_SP)
ENDIF

END SUBROUTINE LATTEX_EXPL_VSPLTRANS_V

END SUBROUTINE
