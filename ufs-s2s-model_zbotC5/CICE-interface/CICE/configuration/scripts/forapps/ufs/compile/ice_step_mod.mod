    -   k820309    �          2021.7.1    i�Ae                                                                                                          
       /lustre/f2/dev/ncep/JieShun.Zhu/ufsp5/ufs-s2s-model_zbotC5/CICE-interface/CICE/cicecore/cicedynB/general/ice_step_mod.F90 ICE_STEP_MOD              STEP_THERM1 STEP_THERM2 STEP_DYN_HORIZ STEP_DYN_RIDGE PREP_RADIATION STEP_RADIATION OCEAN_MIXED_LAYER UPDATE_STATE BIOGEOCHEMISTRY SAVE_INIT STEP_DYN_WAVE                 @� @                                
                            @                              
       C0 C1 C1000 C4                                                     
       ABORT_ICE                      @                              
       NU_DIAG                                                     
       ICEPACK_WARNINGS_FLUSH ICEPACK_WARNINGS_ABORTED ICEPACK_PREP_RADIATION ICEPACK_STEP_THERM1 ICEPACK_STEP_THERM2 ICEPACK_AGGREGATE ICEPACK_STEP_RIDGE ICEPACK_STEP_WAVEFRACTURE ICEPACK_STEP_RADIATION ICEPACK_OCN_MIXED_LAYER ICEPACK_ATM_BOUNDARY ICEPACK_BIOGEOCHEMISTRY ICEPACK_LOAD_OCEAN_BIO_ARRAY ICEPACK_MAX_ALGAE ICEPACK_MAX_NBTRCR ICEPACK_MAX_DON ICEPACK_MAX_DOC ICEPACK_MAX_DIC ICEPACK_MAX_AERO ICEPACK_MAX_FE ICEPACK_MAX_ISO ICEPACK_QUERY_PARAMETERS ICEPACK_QUERY_TRACER_FLAGS ICEPACK_QUERY_TRACER_SIZES ICEPACK_QUERY_TRACER_INDICES #         @                                                      #STEP_THERM1%N_AERO    #STEP_THERM1%N_ISO    #STEP_THERM1%NCAT 	   #DT 
   #IBLK                                                                                                                               @                             	                      
  @                              
     
                
  @                                         #         @                                                       #DT    #IBLK              
  @                                   
                
  @                                         #         @                                                       #DT              
  @                                   
      #         @                                                       #DT    #NDTD    #IBLK              
  @                                   
                
  @                                                   
  @                                         #         @                                                       #IBLK              
  @                                         #         @                                                      #STEP_RADIATION%NCAT    #DT    #IBLK                                          @                                                   
  @                                   
                
  @                                         #         @                                                      #OCEAN_MIXED_LAYER%NY_BLOCK    #OCEAN_MIXED_LAYER%NX_BLOCK    #DT    #IBLK                                                                                                                            
  @                                   
                
                                            #         @                                                        #DT !   #DAIDT "   #DVIDT #   #DAGEDT $   #OFFSET %             
                                 !     
                
D                                "                   
               &                   &                   &                                                     
D                                #                   
               &                   &                   &                                                     
D                                $                   
               &                   &                   &                                                     
                                 %     
      #         @                                   &                    #DT '   #IBLK (             
  @                              '     
                
  @                              (           #         @                                   )                     #         @                                   *                    #DT +             
  @                              +     
         �   �      fn#fn "   /  �   b   uapp(ICE_STEP_MOD    �  @   J  ICE_KINDS_MOD      O   J  ICE_CONSTANTS    i  J   J  ICE_EXIT    �  H   J  ICE_FILEUNITS    �  X  J  ICEPACK_INTFC    S  �       STEP_THERM1 3   �  @     STEP_THERM1%N_AERO+ICE_DOMAIN_SIZE 2   2  @     STEP_THERM1%N_ISO+ICE_DOMAIN_SIZE 1   r  @     STEP_THERM1%NCAT+ICE_DOMAIN_SIZE    �  @   a   STEP_THERM1%DT !   �  @   a   STEP_THERM1%IBLK    2  Z       STEP_THERM2    �  @   a   STEP_THERM2%DT !   �  @   a   STEP_THERM2%IBLK      P       STEP_DYN_HORIZ "   \  @   a   STEP_DYN_HORIZ%DT    �  d       STEP_DYN_RIDGE "    	  @   a   STEP_DYN_RIDGE%DT $   @	  @   a   STEP_DYN_RIDGE%NDTD $   �	  @   a   STEP_DYN_RIDGE%IBLK    �	  R       PREP_RADIATION $   
  @   a   PREP_RADIATION%IBLK    R
  �       STEP_RADIATION 4   �
  @     STEP_RADIATION%NCAT+ICE_DOMAIN_SIZE "     @   a   STEP_RADIATION%DT $   ^  @   a   STEP_RADIATION%IBLK "   �  �       OCEAN_MIXED_LAYER 6   8  @     OCEAN_MIXED_LAYER%NY_BLOCK+ICE_BLOCKS 6   x  @     OCEAN_MIXED_LAYER%NX_BLOCK+ICE_BLOCKS %   �  @   a   OCEAN_MIXED_LAYER%DT '   �  @   a   OCEAN_MIXED_LAYER%IBLK    8  ~       UPDATE_STATE     �  @   a   UPDATE_STATE%DT #   �  �   a   UPDATE_STATE%DAIDT #   �  �   a   UPDATE_STATE%DVIDT $   n  �   a   UPDATE_STATE%DAGEDT $   *  @   a   UPDATE_STATE%OFFSET     j  Z       BIOGEOCHEMISTRY #   �  @   a   BIOGEOCHEMISTRY%DT %     @   a   BIOGEOCHEMISTRY%IBLK    D  H       SAVE_INIT    �  P       STEP_DYN_WAVE !   �  @   a   STEP_DYN_WAVE%DT 