  q  5   k820309    ð          2021.7.1    í¶Ae                                                                                                          
       /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/CICE-interface/CICE/icepack/columnphysics/icepack_therm_bl99.F90 ICEPACK_THERM_BL99              SURFACE_FLUXES TEMPERATURE_CHANGES                                                     
                            @                              
       C0 C1 C2 P1 P5 PUNY RHOI RHOS HS_MIN CP_ICE CP_OCN DEPRESST LFRESH KSNO KICE CONDUCT CALC_TSFC SOLVE_ZSAL SW_REDIST SW_FRAC SW_DTEMP                      @                              
       WARNSTR ICEPACK_WARNINGS_ADD ICEPACK_WARNINGS_SETABORT ICEPACK_WARNINGS_ABORTED                      @                              
       FERRMAX L_BRINE SURFACE_HEAT_FLUX DSURFACE_HEAT_FLUX_DTSF #         @                                                       #TSF    #FSWSFC    #RHOA    #FLW 	   #POTT 
   #QA    #SHCOEF    #LHCOEF    #FLWOUTN    #FSENSN    #FLATN    #FSURFN    #DFLWOUT_DT    #DFSENS_DT    #DFLAT_DT    #DFSURF_DT              
  @                                   
                
  @                                   
                
  @                                   
                
  @                              	     
                
  @                              
     
                
  @                                   
                
  @                                   
                
  @                                   
                
D @                                   
                 
D @                                   
                 
D @                                   
                 
D @                                   
                 
D @                                   
                 
D @                                   
                 
D @                                   
                 
D @                                   
       #         @                                                       #DT    #NILYR    #NSLYR    #RHOA    #FLW    #POTT    #QA    #SHCOEF    #LHCOEF    #FSWSFC     #FSWINT !   #SSWABS "   #ISWABS #   #HILYR $   #HSLYR %   #ZQIN &   #ZTIN '   #ZQSN (   #ZTSN )   #ZSIN *   #TSF +   #TBOT ,   #FSENSN -   #FLATN .   #FLWOUTN /   #FSURFN 0   #FCONDTOPN 1   #FCONDBOT 2   #EINIT 3             
                                      
                
  @                                                   
  @                                                   
  @                                   
                
  @                                   
                
  @                                   
                
  @                                   
                
  @                                   
                
  @                                   
                
D @                                    
                 
D @                              !     
                
D @                              "                    
     p          5  p        r        5  p        r                               
D @                              #                    
     p          5  p        r        5  p        r                                
  @                              $     
                
  @                              %     
               
D                                &                    
     p          5  p        r        5  p        r                               
D @                              '                    
     p          5  p        r        5  p        r                               
D                                (                    
     p          5  p        r        5  p        r                               
D                                )                    
     p          5  p        r        5  p        r                               
  @                              *                    
    p          5  p        r        5  p        r                                
D @                              +     
                 
  @                              ,     
                
D @                              -     
                 
D @                              .     
                 
D @                              /     
                 
D @                              0     
                 
D @                              1     
                 D                                2     
                 
                                 3     
                   fn#fn (   7  3   b   uapp(ICEPACK_THERM_BL99    j  @   J  ICEPACK_KINDS #   ª  Å   J  ICEPACK_PARAMETERS !   o     J  ICEPACK_WARNINGS %   ÿ  z   J  ICEPACK_THERM_SHARED    y        SURFACE_FLUXES #     @   a   SURFACE_FLUXES%TSF &   ¿  @   a   SURFACE_FLUXES%FSWSFC $   ÿ  @   a   SURFACE_FLUXES%RHOA #   ?  @   a   SURFACE_FLUXES%FLW $     @   a   SURFACE_FLUXES%POTT "   ¿  @   a   SURFACE_FLUXES%QA &   ÿ  @   a   SURFACE_FLUXES%SHCOEF &   ?  @   a   SURFACE_FLUXES%LHCOEF '     @   a   SURFACE_FLUXES%FLWOUTN &   ¿  @   a   SURFACE_FLUXES%FSENSN %   ÿ  @   a   SURFACE_FLUXES%FLATN &   ?  @   a   SURFACE_FLUXES%FSURFN *     @   a   SURFACE_FLUXES%DFLWOUT_DT )   ¿  @   a   SURFACE_FLUXES%DFSENS_DT (   ÿ  @   a   SURFACE_FLUXES%DFLAT_DT )   ?  @   a   SURFACE_FLUXES%DFSURF_DT $           TEMPERATURE_CHANGES '   
  @   a   TEMPERATURE_CHANGES%DT *   E
  @   a   TEMPERATURE_CHANGES%NILYR *   
  @   a   TEMPERATURE_CHANGES%NSLYR )   Å
  @   a   TEMPERATURE_CHANGES%RHOA (     @   a   TEMPERATURE_CHANGES%FLW )   E  @   a   TEMPERATURE_CHANGES%POTT '     @   a   TEMPERATURE_CHANGES%QA +   Å  @   a   TEMPERATURE_CHANGES%SHCOEF +     @   a   TEMPERATURE_CHANGES%LHCOEF +   E  @   a   TEMPERATURE_CHANGES%FSWSFC +     @   a   TEMPERATURE_CHANGES%FSWINT +   Å  ´   a   TEMPERATURE_CHANGES%SSWABS +   y  ´   a   TEMPERATURE_CHANGES%ISWABS *   -  @   a   TEMPERATURE_CHANGES%HILYR *   m  @   a   TEMPERATURE_CHANGES%HSLYR )   ­  ´   a   TEMPERATURE_CHANGES%ZQIN )   a  ´   a   TEMPERATURE_CHANGES%ZTIN )     ´   a   TEMPERATURE_CHANGES%ZQSN )   É  ´   a   TEMPERATURE_CHANGES%ZTSN )   }  ´   a   TEMPERATURE_CHANGES%ZSIN (   1  @   a   TEMPERATURE_CHANGES%TSF )   q  @   a   TEMPERATURE_CHANGES%TBOT +   ±  @   a   TEMPERATURE_CHANGES%FSENSN *   ñ  @   a   TEMPERATURE_CHANGES%FLATN ,   1  @   a   TEMPERATURE_CHANGES%FLWOUTN +   q  @   a   TEMPERATURE_CHANGES%FSURFN .   ±  @   a   TEMPERATURE_CHANGES%FCONDTOPN -   ñ  @   a   TEMPERATURE_CHANGES%FCONDBOT *   1  @   a   TEMPERATURE_CHANGES%EINIT 