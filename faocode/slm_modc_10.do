 gl DRIVE "C:\Users/`c(username)'\Dropbox\FAO\Epic\COUNTRY\Malawi\DATA\IHPS\Antonio\in"


adopath + "C:\Users/`c(username)'\Dropbox\FAO\Epic\Tools box\STATA TOOLS\ado"

cd ${DRIVE}\MALAWI_2010-2013-2016
**************************************************
gl INAG ${DRIVE}\MALAWI_2010-2013-2016\raw\Agriculture
gl INHH ${DRIVE}\MALAWI_2010-2013-2016\raw\Household
gl INC  ${DRIVE}\MALAWI_2010-2013-2016\dofile_panel\Income\dta
gl CON  ${DRIVE}\MALAWI_2010-2013-2016\dofile_panel\Consumption\dta
gl COM  ${DRIVE}\MALAWI_2010-2013-2016\raw\Community
gl TEMP ${DRIVE}\MALAWI_2010-2013-2016\dofile_panel\Tempdata
gl ANAL ${DRIVE}\MALAWI_2010-2013-2016\Analysis
gl HHC  ${DRIVE}\MALAWI_2010-2013-2016\dofile_panel\Hhcharacter\dta
gl OTHER ${DRIVE}\MALAWI_2010-2013-2016\dofile_panel\Other
**************************************************




set more off
cap log close
log using  "${DRIVE}\MALAWI_2010-2013-2016\dofile_panel\log\slm_modc_10.log", replace



**************************************************************
**    SUSTAINABLE LAND MANAGMENT
**                                                            
**************************************************************
**                                                            
**  Country: Malawi      YEAR:   2010                     
**                                                            
**  Program Name:  slm_modc_10.do
**                                                            
**  Input Data Sets: 
**                                            
**                                   
**					  
**  Output Data Set: $ANAL/slm_modc_10.dta                             
**                                    
**                                                            
**  Description:  Sustainable land managment practices
**  HHID: case_id
**
** # Households in the sample:     
**                                             
**                                          	
** Program first written: November 30, 2018 (Antonio Scognamillo)     
**************************************************************
**************************************************************


					
u "$INAG/ag_mod_c_10.dta", clear
drop if mi(ag_c00)
isid case_id ag_c00
ren ag_c00 plot_id
recode ag_c04b (1=0.40468564) (2=1) (3=0.0001) (4=.), gen(areaconv)
g sr = areaconv * ag_c04a if !mi(areaconv) & ag_c04a!=0 & !mi(ag_c04a)
g gps = ag_c04c * 0.40468564 if !mi(ag_c04c)
g ha = gps if !mi(gps)	//	gps preferred
replace ha = sr if mi(gps) & !mi(sr)
keep case_id plot_id ha 

log close
