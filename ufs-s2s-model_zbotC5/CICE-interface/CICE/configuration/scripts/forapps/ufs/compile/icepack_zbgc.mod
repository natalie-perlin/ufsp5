  Úk  Ü   k820309    ð          2021.7.1    ê¶Ae                                                                                                          
       /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/CICE-interface/CICE/icepack/columnphysics/icepack_zbgc.F90 ICEPACK_ZBGC              ADD_NEW_ICE_BGC LATERAL_MELT_BGC ICEPACK_INIT_BGC ICEPACK_INIT_ZBGC ICEPACK_BIOGEOCHEMISTRY ICEPACK_LOAD_OCEAN_BIO_ARRAY ICEPACK_INIT_OCEAN_BIO                                                     
                            @                              
  $     C0 C1 C2 P001 P1 P5 PUNY DEPRESST RHOSI MIN_SALIN SALT_LOSS FR_RESP ALGAL_VEL R_DFE2DUST DUSTFE_SOL T_MAX OP_DEP_MIN FR_GRAZE_S FR_GRAZE_E FR_MORT2MIN FR_DFE K_NITRIF T_IRON_CONV MAX_LOSS MAX_DFE_DOC1 FR_RESP_S Y_SK_DMS T_SK_CONV T_SK_OX SCALE_BGC KTHERM SKL_BGC SOLVE_ZSAL Z_TRACERS FSAL CONSERV_CHECK          @          @                              
  	     NT_SICE NT_BGC_S BIO_INDEX TR_BRINE NT_FBRI NT_QICE NT_TSFC NT_ZBGC_FRAC BIO_INDEX_O                      @                              
  $     ZBGC_INIT_FRAC ZBGC_FRAC_INIT BGC_TRACER_TYPE REMAP_ZBGC REGRID_STATIONARY R_S2N R_SI2N R_FE2C R_FE2N R_FE2DON R_FE2DOC CHLABS ALPHA2MAX_LOW BETA2MAX MU_MAX GROW_TDEP FR_GRAZE MORT_PRE MORT_TDEP K_EXUDE K_NIT K_AM K_SIL K_FE F_DON KN_BAC F_DON_AM F_DOC F_EXUDE K_BAC TAU_RET TAU_REL R_C2N R_CHL2N F_ABS_CHL R_C2N_DON                      @                              
       WARNSTR ICEPACK_WARNINGS_ADD ICEPACK_WARNINGS_SETABORT ICEPACK_WARNINGS_ABORTED                      @                              
       PREFLUSHING_CHANGES COMPUTE_MICROS_MUSHY UPDATE_HBRINE COMPUTE_MICROS                      @                              
       ZBIO SKLBIO                      @                              
       CALCULATE_TIN_FROM_QIN                      @                         	     
       COLUMN_SUM COLUMN_CONSERVATION_CHECK                      @                         
     
       ZSALINITY #         @                                                       #DT    #NBLYR    #NCAT    #NILYR    #NLTRCR    #BGRID    #CGRID    #IGRID    #AICEN_INIT    #VICEN_INIT    #VI0_INIT    #AICEN    #VICEN    #VSNON1    #VI0NEW    #NTRCR    #TRCRN    #NBTRCR    #SSS    #OCEAN_BIO    #FLUX_BIO     #HSURP !             
  @                                   
                
  @                                                   
  @                                                   
  @                                                   
                                                     
  @                                                  
    p           5  p        r    n                                       2     5  p        r    n                                      2                                    
  @                                                  
    p           5  p        r    n                                       1     5  p        r    n                                      1                                    
  @                                                  
    p           5  p        r    n                                       1     5  p        r    n                                      1                                     
  @                                                 
              &                                                     
                                                    
              &                                                     
                                      
                
  @                                                 
              &                                                     
  @                                                 
              &                                                     
                                      
                
  @                                   
                
  @                                                   
D @                                                 
               &                   &                                                     
  @                                                   
  @                                   
                
  @                                                 
 
             &                                                     
D                                                    
 	              &                                                     
                                 !     
      #         @                                   "                 	   #DT #   #NCAT $   #NBLYR %   #RSIDE &   #VICEN '   #TRCRN (   #FZSAL )   #FLUX_BIO *   #NBLTRCR +             
                                 #     
                
                                 $                     
  @                              %                     
                                 &     
                
                                 '                   
              &                                                     
                                 (                   
              &                   &                                                     
D                                )     
                 
D                                *                   
               &                                                     
                                 +           #         @                                   ,                    #NCAT -   #NBLYR .   #NILYR /   #NTRCR_O 0   #CGRID 1   #IGRID 2   #NTRCR 3   #NBTRCR 4   #SICEN 5   #TRCRN 6   #SSS 7   #OCEAN_BIO_ALL 8             
                                 -                     
                                 .                     
  @                              /                     
                                 0                    
                                1                    
     p           5  p        r /   n                                       1     5  p        r /   n                                      1                                    
                                2                    
     p           5  p        r .   n                                       1     5  p        r .   n                                      1                                     
                                 3                     
                                 4                    
  @                              5                    
      p        5  p        r /   p          5  p        r /     5  p        r -       5  p        r /     5  p        r -                               
D                                6                   
               &                   &                                                     
                                 7     
                
                                8                   
               &                                           #         @                                   9                 5   #R_SI2N_IN :   #R_S2N_IN ;   #R_FE2C_IN <   #R_FE2N_IN =   #R_C2N_IN >   #R_C2N_DON_IN ?   #R_CHL2N_IN @   #F_ABS_CHL_IN A   #R_FE2DON_IN B   #R_FE2DOC_IN C   #CHLABS_IN D   #ALPHA2MAX_LOW_IN E   #BETA2MAX_IN F   #MU_MAX_IN G   #FR_GRAZE_IN H   #MORT_PRE_IN I   #MORT_TDEP_IN J   #K_EXUDE_IN K   #K_NIT_IN L   #K_AM_IN M   #K_SIL_IN N   #K_FE_IN O   #F_DON_IN P   #KN_BAC_IN Q   #F_DON_AM_IN R   #F_DOC_IN S   #F_EXUDE_IN T   #K_BAC_IN U   #GROW_TDEP_IN V   #ZBGC_FRAC_INIT_IN W   #ZBGC_INIT_FRAC_IN X   #TAU_RET_IN Y   #TAU_REL_IN Z   #BGC_TRACER_TYPE_IN [   #FR_RESP_IN \   #ALGAL_VEL_IN ]   #R_DFE2DUST_IN ^   #DUSTFE_SOL_IN _   #T_MAX_IN `   #OP_DEP_MIN_IN a   #FR_GRAZE_S_IN b   #FR_GRAZE_E_IN c   #FR_MORT2MIN_IN d   #FR_DFE_IN e   #K_NITRIF_IN f   #T_IRON_CONV_IN g   #MAX_LOSS_IN h   #MAX_DFE_DOC1_IN i   #FR_RESP_S_IN j   #Y_SK_DMS_IN k   #T_SK_CONV_IN l   #T_SK_OX_IN m   #FSAL_IN n              @                              :                   
 "              &                                                      @                              ;                   
 #              &                                                      @                              <                   
 $              &                                                      @                              =                   
 %              &                                                      @                              >                   
               &                                                      @                              ?                   
 !              &                                                      @                              @                   
               &                                                      @                              A                   
                &                                                      @                              B                   
 &              &                                                      @                              C                   
 '              &                                                      @                              D                   
 (              &                                                      @                              E                   
 )              &                                                      @                              F                   
 *              &                                                      @                              G                   
 +              &                                                      @                              H                   
 -              &                                                      @                              I                   
 .              &                                                      @                              J                   
 /              &                                                      @                              K                   
 0              &                                                      @                              L                   
 1              &                                                      @                              M                   
 2              &                                                      @                              N                   
 3              &                                                      @                              O                   
 4              &                                                      @                              P                   
 5              &                                                      @                              Q                   
 6              &                                                      @                              R                   
 7              &                                                      @                              S                   
 8              &                                                      @                              T                   
 9              &                                                      @                              U                   
 :              &                                                      @                              V                   
 ,              &                                                      @                              W                   
 ;              &                                                      @                              X                   
 =              &                                                      @                              Y                   
 >              &                                                      @                              Z                   
 ?              &                                                      @                              [                   
 <              &                                                      @                              \     
                  @                              ]     
                  @                              ^     
                  @                              _     
                  @                              `     
                  @                              a     
                  @                              b     
                  @                              c     
                  @                              d     
                  @                              e     
                  @                              f     
                  @                              g     
                  @                              h     
                  @                              i     
                  @                              j     
                  @                              k     
                  @                              l     
                  @                              m     
                  @                              n     
       #         @                                   o                 A   #DT p   #NTRCR q   #NBTRCR r   #UPNO s   #UPNH t   #IDI u   #IKI v   #ZFSWIN w   #ZSAL_TOT x   #DARCY_V y   #GROW_NET z   #PP_NET {   #HBRI |   #DHBR_BOT }   #DHBR_TOP ~   #ZOO    #FBIO_SNOICE    #FBIO_ATMICE    #OCEAN_BIO    #FIRST_ICE    #FSWPENLN    #BPHI    #BTIZ    #ICE_BIO_NET    #SNOW_BIO_NET    #FSWTHRUN    #RAYLEIGH_CRITERIA    #SICE_RHO    #FZSAL    #FZSAL_G    #BGRID    #IGRID    #ICGRID    #CGRID    #NBLYR    #NILYR    #NSLYR    #N_ALGAE    #N_ZAERO    #NCAT    #N_DOC    #N_DIC    #N_DON    #N_FED    #N_FEP    #MELTBN    #MELTTN    #CONGELN    #SNOICEN     #SST ¡   #SSS ¢   #FSNOW £   #MELTSN ¤   #HIN_OLD ¥   #FLUX_BIO ¦   #FLUX_BIO_ATM §   #AICEN_INIT ¨   #VICEN_INIT ©   #AICEN ª   #VICEN «   #VSNON ¬   #AICE0 ­   #TRCRN ®   #VSNON_INIT ¯   #SKL_BGC °             
  @                              p     
                
  @                              q                     
  @                              r                     
D @                              s     
                 
D @                              t     
                 
D @                              u                   
 T              &                   &                                                     
D @                              v                   
 U              &                   &                                                     
D @                              w                   
 S              &                   &                                                     
D @                              x     
                 
D @                              y                   
 I              &                                                     
D @                              z     
                 
D @                              {     
                 
D                                |     
                 
D @                              }                   
 H              &                                                     
D @                              ~                   
 G              &                                                     
D @                                                 
 P              &                   &                                                     
D @                                                 
 E              &                                                     
D @                                                 
 F              &                                                     
                                                   
 D              &                                                     
D @                                                  O              &                                                     
                                                    
 W             &                   &                                                     
D @                                                 
 Q              &                   &                                                     
D @                                                 
 R              &                   &                                                     
D @                                                 
 L              &                                                     
D @                                                 
 M              &                                                     
  @                                                 
 X             &                                                     
D @                                                    
D @                                                 
 K              &                                                     
D @                                   
                 
D @                                   
                 
D @                                                 
 @              &                                                     
 @                                                 
 A              &                                                     
 @                                                 
 C              &                                                     
 @                                                 
 B              &                                                     
  @                                                   
  @                                                   
  @                                                   
  @                                                   
  @                                                   
                                                      
  @                                                   
  @                                                   
  @                                                   
  @                                                   
  @                                                   
  @                                                 
 [             &                                                     
  @                                                 
 Z             &                                                     
  @                                                 
 \             &                                                     
  @                                                  
 ]             &                                                     
  @                              ¡     
                
  @                              ¢     
                
  @                              £     
                
  @                              ¤                   
 Y             &                                                     
D @                              ¥                   
 J              &                                                     
D @                              ¦                   
 N              &                                                     
                                 §                   
 ^             &                                                     
  @                              ¨                   
 _             &                                                     
  @                              ©                   
 `             &                                                     
  @                              ª                   
 b             &                                                     
  @                              «                   
 c             &                                                     
  @                              ¬                   
 d             &                                                     
  @                              ­     
                
D @                              ®                   
 V              &                   &                                                     
  @                              ¯                   
 a             &                                                     
                                 °           #         @                                   ±                    #MAX_NBTRCR ²   #MAX_ALGAE ³   #MAX_DON ´   #MAX_DOC µ   #MAX_DIC ¶   #MAX_AERO ·   #MAX_FE ¸   #NIT ¹   #AMM º   #SIL »   #DMSP ¼   #DMS ½   #ALGALN ¾   #DOC ¿   #DON À   #DIC Á   #FED Â   #FEP Ã   #ZAEROS Ä   #OCEAN_BIO_ALL Å   #HUM Æ             
                                 ²                     
                                 ³                     
                                 ´                     
                                 µ                     
                                 ¶                     
                                 ·                     
                                 ¸                     
                                 ¹     
                
                                 º     
                
                                 »     
                
                                 ¼     
                
                                 ½     
               
                                 ¾                    
 l   p          5  p        r ³       5  p        r ³                              
                                 ¿                    
 m   p          5  p        r µ       5  p        r µ                              
                                 À                    
 n   p          5  p        r ´       5  p        r ´                              
                                 Á                    
 o   p          5  p        r ¶       5  p        r ¶                              
                                 Â                    
 p   p          5  p        r ¸       5  p        r ¸                              
                                 Ã                    
 q   p          5  p        r ¸       5  p        r ¸                              
                                 Ä                    
 r   p          5  p        r ·       5  p        r ·                              
D                                Å                    
 s    p          5  p        r ²       5  p        r ²                               
                                 Æ     
      #         @                                   Ç                    #AMM È   #DMSP É   #DMS Ê   #ALGALN Ë   #DOC Ì   #DIC Í   #DON Î   #FED Ï   #FEP Ð   #HUM Ñ   #NIT Ò   #SIL Ó   #ZAEROS Ô   #MAX_DIC Õ   #MAX_DON Ö   #MAX_FE ×   #MAX_AERO Ø   #CTON Ù   #CTON_DON Ú             D                                È     
                 D                                É     
                 D                                Ê     
                 D                                Ë                   
 t              &                                                     D                                Ì                   
 u              &                                                     D                                Í                   
 v              &                                                     D                                Î                   
 w              &                                                     D                                Ï                   
 x              &                                                     D                                Ð                   
 y              &                                                     D                                Ñ     
                 D                                Ò     
                 D                                Ó     
                 D                                Ô                   
 z              &                                                     
                                 Õ                     
                                 Ö                     
                                 ×                     
                                 Ø                     
F @                              Ù                   
 {              &                                                     
F @                              Ú                   
 |              &                                                        fn#fn "   +      b   uapp(ICEPACK_ZBGC    Ë  @   J  ICEPACK_KINDS #     o  J  ICEPACK_PARAMETERS     z     J  ICEPACK_TRACERS $     }  J  ICEPACK_ZBGC_SHARED !        J  ICEPACK_WARNINGS         J  ICEPACK_BRINE    ¢  L   J  ICEPACK_ALGAE %   î  W   J  ICEPACK_THERM_SHARED    E  e   J  ICEPACK_ITD "   ª  J   J  ICEPACK_ZSALINITY     ô  L      ADD_NEW_ICE_BGC #   @	  @   a   ADD_NEW_ICE_BGC%DT &   	  @   a   ADD_NEW_ICE_BGC%NBLYR %   À	  @   a   ADD_NEW_ICE_BGC%NCAT &    
  @   a   ADD_NEW_ICE_BGC%NILYR '   @
  @   a   ADD_NEW_ICE_BGC%NLTRCR &   
  &  a   ADD_NEW_ICE_BGC%BGRID &   ¦  &  a   ADD_NEW_ICE_BGC%CGRID &   Ì  &  a   ADD_NEW_ICE_BGC%IGRID +   ò     a   ADD_NEW_ICE_BGC%AICEN_INIT +   ~     a   ADD_NEW_ICE_BGC%VICEN_INIT )   
  @   a   ADD_NEW_ICE_BGC%VI0_INIT &   J     a   ADD_NEW_ICE_BGC%AICEN &   Ö     a   ADD_NEW_ICE_BGC%VICEN '   b  @   a   ADD_NEW_ICE_BGC%VSNON1 '   ¢  @   a   ADD_NEW_ICE_BGC%VI0NEW &   â  @   a   ADD_NEW_ICE_BGC%NTRCR &   "  ¤   a   ADD_NEW_ICE_BGC%TRCRN '   Æ  @   a   ADD_NEW_ICE_BGC%NBTRCR $     @   a   ADD_NEW_ICE_BGC%SSS *   F     a   ADD_NEW_ICE_BGC%OCEAN_BIO )   Ò     a   ADD_NEW_ICE_BGC%FLUX_BIO &   ^  @   a   ADD_NEW_ICE_BGC%HSURP !     ¬       LATERAL_MELT_BGC $   J  @   a   LATERAL_MELT_BGC%DT &     @   a   LATERAL_MELT_BGC%NCAT '   Ê  @   a   LATERAL_MELT_BGC%NBLYR '   
  @   a   LATERAL_MELT_BGC%RSIDE '   J     a   LATERAL_MELT_BGC%VICEN '   Ö  ¤   a   LATERAL_MELT_BGC%TRCRN '   z  @   a   LATERAL_MELT_BGC%FZSAL *   º     a   LATERAL_MELT_BGC%FLUX_BIO )   F  @   a   LATERAL_MELT_BGC%NBLTRCR !     Ô       ICEPACK_INIT_BGC &   Z  @   a   ICEPACK_INIT_BGC%NCAT '     @   a   ICEPACK_INIT_BGC%NBLYR '   Ú  @   a   ICEPACK_INIT_BGC%NILYR )     @   a   ICEPACK_INIT_BGC%NTRCR_O '   Z  &  a   ICEPACK_INIT_BGC%CGRID '     &  a   ICEPACK_INIT_BGC%IGRID '   ¦  @   a   ICEPACK_INIT_BGC%NTRCR (   æ  @   a   ICEPACK_INIT_BGC%NBTRCR '   &  $  a   ICEPACK_INIT_BGC%SICEN '   J  ¤   a   ICEPACK_INIT_BGC%TRCRN %   î  @   a   ICEPACK_INIT_BGC%SSS /   .     a   ICEPACK_INIT_BGC%OCEAN_BIO_ALL "   º  Ç      ICEPACK_INIT_ZBGC ,   "     a   ICEPACK_INIT_ZBGC%R_SI2N_IN +   #     a   ICEPACK_INIT_ZBGC%R_S2N_IN ,   #     a   ICEPACK_INIT_ZBGC%R_FE2C_IN ,   %$     a   ICEPACK_INIT_ZBGC%R_FE2N_IN +   ±$     a   ICEPACK_INIT_ZBGC%R_C2N_IN /   =%     a   ICEPACK_INIT_ZBGC%R_C2N_DON_IN -   É%     a   ICEPACK_INIT_ZBGC%R_CHL2N_IN /   U&     a   ICEPACK_INIT_ZBGC%F_ABS_CHL_IN .   á&     a   ICEPACK_INIT_ZBGC%R_FE2DON_IN .   m'     a   ICEPACK_INIT_ZBGC%R_FE2DOC_IN ,   ù'     a   ICEPACK_INIT_ZBGC%CHLABS_IN 3   (     a   ICEPACK_INIT_ZBGC%ALPHA2MAX_LOW_IN .   )     a   ICEPACK_INIT_ZBGC%BETA2MAX_IN ,   )     a   ICEPACK_INIT_ZBGC%MU_MAX_IN .   )*     a   ICEPACK_INIT_ZBGC%FR_GRAZE_IN .   µ*     a   ICEPACK_INIT_ZBGC%MORT_PRE_IN /   A+     a   ICEPACK_INIT_ZBGC%MORT_TDEP_IN -   Í+     a   ICEPACK_INIT_ZBGC%K_EXUDE_IN +   Y,     a   ICEPACK_INIT_ZBGC%K_NIT_IN *   å,     a   ICEPACK_INIT_ZBGC%K_AM_IN +   q-     a   ICEPACK_INIT_ZBGC%K_SIL_IN *   ý-     a   ICEPACK_INIT_ZBGC%K_FE_IN +   .     a   ICEPACK_INIT_ZBGC%F_DON_IN ,   /     a   ICEPACK_INIT_ZBGC%KN_BAC_IN .   ¡/     a   ICEPACK_INIT_ZBGC%F_DON_AM_IN +   -0     a   ICEPACK_INIT_ZBGC%F_DOC_IN -   ¹0     a   ICEPACK_INIT_ZBGC%F_EXUDE_IN +   E1     a   ICEPACK_INIT_ZBGC%K_BAC_IN /   Ñ1     a   ICEPACK_INIT_ZBGC%GROW_TDEP_IN 4   ]2     a   ICEPACK_INIT_ZBGC%ZBGC_FRAC_INIT_IN 4   é2     a   ICEPACK_INIT_ZBGC%ZBGC_INIT_FRAC_IN -   u3     a   ICEPACK_INIT_ZBGC%TAU_RET_IN -   4     a   ICEPACK_INIT_ZBGC%TAU_REL_IN 5   4     a   ICEPACK_INIT_ZBGC%BGC_TRACER_TYPE_IN -   5  @   a   ICEPACK_INIT_ZBGC%FR_RESP_IN /   Y5  @   a   ICEPACK_INIT_ZBGC%ALGAL_VEL_IN 0   5  @   a   ICEPACK_INIT_ZBGC%R_DFE2DUST_IN 0   Ù5  @   a   ICEPACK_INIT_ZBGC%DUSTFE_SOL_IN +   6  @   a   ICEPACK_INIT_ZBGC%T_MAX_IN 0   Y6  @   a   ICEPACK_INIT_ZBGC%OP_DEP_MIN_IN 0   6  @   a   ICEPACK_INIT_ZBGC%FR_GRAZE_S_IN 0   Ù6  @   a   ICEPACK_INIT_ZBGC%FR_GRAZE_E_IN 1   7  @   a   ICEPACK_INIT_ZBGC%FR_MORT2MIN_IN ,   Y7  @   a   ICEPACK_INIT_ZBGC%FR_DFE_IN .   7  @   a   ICEPACK_INIT_ZBGC%K_NITRIF_IN 1   Ù7  @   a   ICEPACK_INIT_ZBGC%T_IRON_CONV_IN .   8  @   a   ICEPACK_INIT_ZBGC%MAX_LOSS_IN 2   Y8  @   a   ICEPACK_INIT_ZBGC%MAX_DFE_DOC1_IN /   8  @   a   ICEPACK_INIT_ZBGC%FR_RESP_S_IN .   Ù8  @   a   ICEPACK_INIT_ZBGC%Y_SK_DMS_IN /   9  @   a   ICEPACK_INIT_ZBGC%T_SK_CONV_IN -   Y9  @   a   ICEPACK_INIT_ZBGC%T_SK_OX_IN *   9  @   a   ICEPACK_INIT_ZBGC%FSAL_IN (   Ù9  r      ICEPACK_BIOGEOCHEMISTRY +   K=  @   a   ICEPACK_BIOGEOCHEMISTRY%DT .   =  @   a   ICEPACK_BIOGEOCHEMISTRY%NTRCR /   Ë=  @   a   ICEPACK_BIOGEOCHEMISTRY%NBTRCR -   >  @   a   ICEPACK_BIOGEOCHEMISTRY%UPNO -   K>  @   a   ICEPACK_BIOGEOCHEMISTRY%UPNH ,   >  ¤   a   ICEPACK_BIOGEOCHEMISTRY%IDI ,   /?  ¤   a   ICEPACK_BIOGEOCHEMISTRY%IKI /   Ó?  ¤   a   ICEPACK_BIOGEOCHEMISTRY%ZFSWIN 1   w@  @   a   ICEPACK_BIOGEOCHEMISTRY%ZSAL_TOT 0   ·@     a   ICEPACK_BIOGEOCHEMISTRY%DARCY_V 1   CA  @   a   ICEPACK_BIOGEOCHEMISTRY%GROW_NET /   A  @   a   ICEPACK_BIOGEOCHEMISTRY%PP_NET -   ÃA  @   a   ICEPACK_BIOGEOCHEMISTRY%HBRI 1   B     a   ICEPACK_BIOGEOCHEMISTRY%DHBR_BOT 1   B     a   ICEPACK_BIOGEOCHEMISTRY%DHBR_TOP ,   C  ¤   a   ICEPACK_BIOGEOCHEMISTRY%ZOO 4   ¿C     a   ICEPACK_BIOGEOCHEMISTRY%FBIO_SNOICE 4   KD     a   ICEPACK_BIOGEOCHEMISTRY%FBIO_ATMICE 2   ×D     a   ICEPACK_BIOGEOCHEMISTRY%OCEAN_BIO 2   cE     a   ICEPACK_BIOGEOCHEMISTRY%FIRST_ICE 1   ïE  ¤   a   ICEPACK_BIOGEOCHEMISTRY%FSWPENLN -   F  ¤   a   ICEPACK_BIOGEOCHEMISTRY%BPHI -   7G  ¤   a   ICEPACK_BIOGEOCHEMISTRY%BTIZ 4   ÛG     a   ICEPACK_BIOGEOCHEMISTRY%ICE_BIO_NET 5   gH     a   ICEPACK_BIOGEOCHEMISTRY%SNOW_BIO_NET 1   óH     a   ICEPACK_BIOGEOCHEMISTRY%FSWTHRUN :   I  @   a   ICEPACK_BIOGEOCHEMISTRY%RAYLEIGH_CRITERIA 1   ¿I     a   ICEPACK_BIOGEOCHEMISTRY%SICE_RHO .   KJ  @   a   ICEPACK_BIOGEOCHEMISTRY%FZSAL 0   J  @   a   ICEPACK_BIOGEOCHEMISTRY%FZSAL_G .   ËJ     a   ICEPACK_BIOGEOCHEMISTRY%BGRID .   WK     a   ICEPACK_BIOGEOCHEMISTRY%IGRID /   ãK     a   ICEPACK_BIOGEOCHEMISTRY%ICGRID .   oL     a   ICEPACK_BIOGEOCHEMISTRY%CGRID .   ûL  @   a   ICEPACK_BIOGEOCHEMISTRY%NBLYR .   ;M  @   a   ICEPACK_BIOGEOCHEMISTRY%NILYR .   {M  @   a   ICEPACK_BIOGEOCHEMISTRY%NSLYR 0   »M  @   a   ICEPACK_BIOGEOCHEMISTRY%N_ALGAE 0   ûM  @   a   ICEPACK_BIOGEOCHEMISTRY%N_ZAERO -   ;N  @   a   ICEPACK_BIOGEOCHEMISTRY%NCAT .   {N  @   a   ICEPACK_BIOGEOCHEMISTRY%N_DOC .   »N  @   a   ICEPACK_BIOGEOCHEMISTRY%N_DIC .   ûN  @   a   ICEPACK_BIOGEOCHEMISTRY%N_DON .   ;O  @   a   ICEPACK_BIOGEOCHEMISTRY%N_FED .   {O  @   a   ICEPACK_BIOGEOCHEMISTRY%N_FEP /   »O     a   ICEPACK_BIOGEOCHEMISTRY%MELTBN /   GP     a   ICEPACK_BIOGEOCHEMISTRY%MELTTN 0   ÓP     a   ICEPACK_BIOGEOCHEMISTRY%CONGELN 0   _Q     a   ICEPACK_BIOGEOCHEMISTRY%SNOICEN ,   ëQ  @   a   ICEPACK_BIOGEOCHEMISTRY%SST ,   +R  @   a   ICEPACK_BIOGEOCHEMISTRY%SSS .   kR  @   a   ICEPACK_BIOGEOCHEMISTRY%FSNOW /   «R     a   ICEPACK_BIOGEOCHEMISTRY%MELTSN 0   7S     a   ICEPACK_BIOGEOCHEMISTRY%HIN_OLD 1   ÃS     a   ICEPACK_BIOGEOCHEMISTRY%FLUX_BIO 5   OT     a   ICEPACK_BIOGEOCHEMISTRY%FLUX_BIO_ATM 3   ÛT     a   ICEPACK_BIOGEOCHEMISTRY%AICEN_INIT 3   gU     a   ICEPACK_BIOGEOCHEMISTRY%VICEN_INIT .   óU     a   ICEPACK_BIOGEOCHEMISTRY%AICEN .   V     a   ICEPACK_BIOGEOCHEMISTRY%VICEN .   W     a   ICEPACK_BIOGEOCHEMISTRY%VSNON .   W  @   a   ICEPACK_BIOGEOCHEMISTRY%AICE0 .   ×W  ¤   a   ICEPACK_BIOGEOCHEMISTRY%TRCRN 3   {X     a   ICEPACK_BIOGEOCHEMISTRY%VSNON_INIT 0   Y  @   a   ICEPACK_BIOGEOCHEMISTRY%SKL_BGC -   GY  7      ICEPACK_LOAD_OCEAN_BIO_ARRAY 8   ~Z  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_NBTRCR 7   ¾Z  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_ALGAE 5   þZ  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_DON 5   >[  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_DOC 5   ~[  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_DIC 6   ¾[  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_AERO 4   þ[  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%MAX_FE 1   >\  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%NIT 1   ~\  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%AMM 1   ¾\  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%SIL 2   þ\  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%DMSP 1   >]  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%DMS 4   ~]  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%ALGALN 1   2^  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%DOC 1   æ^  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%DON 1   _  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%DIC 1   N`  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%FED 1   a  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%FEP 4   ¶a  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%ZAEROS ;   jb  ´   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%OCEAN_BIO_ALL 1   c  @   a   ICEPACK_LOAD_OCEAN_BIO_ARRAY%HUM '   ^c        ICEPACK_INIT_OCEAN_BIO +   nd  @   a   ICEPACK_INIT_OCEAN_BIO%AMM ,   ®d  @   a   ICEPACK_INIT_OCEAN_BIO%DMSP +   îd  @   a   ICEPACK_INIT_OCEAN_BIO%DMS .   .e     a   ICEPACK_INIT_OCEAN_BIO%ALGALN +   ºe     a   ICEPACK_INIT_OCEAN_BIO%DOC +   Ff     a   ICEPACK_INIT_OCEAN_BIO%DIC +   Òf     a   ICEPACK_INIT_OCEAN_BIO%DON +   ^g     a   ICEPACK_INIT_OCEAN_BIO%FED +   êg     a   ICEPACK_INIT_OCEAN_BIO%FEP +   vh  @   a   ICEPACK_INIT_OCEAN_BIO%HUM +   ¶h  @   a   ICEPACK_INIT_OCEAN_BIO%NIT +   öh  @   a   ICEPACK_INIT_OCEAN_BIO%SIL .   6i     a   ICEPACK_INIT_OCEAN_BIO%ZAEROS /   Âi  @   a   ICEPACK_INIT_OCEAN_BIO%MAX_DIC /   j  @   a   ICEPACK_INIT_OCEAN_BIO%MAX_DON .   Bj  @   a   ICEPACK_INIT_OCEAN_BIO%MAX_FE 0   j  @   a   ICEPACK_INIT_OCEAN_BIO%MAX_AERO ,   Âj     a   ICEPACK_INIT_OCEAN_BIO%CTON 0   Nk     a   ICEPACK_INIT_OCEAN_BIO%CTON_DON 