	
global master "S:\Maggio\Malawi"


do "${master}\maizeyield.do"
drop _merge

tempfile yieldfin
save `yieldfin', replace



	
	**id
	
	use "${master}\mastermalawi.dta", clear
	
	keep y2_hhid year case_id ea_id
	
egen id=group(y2_hhid)
duplicates report id
quietly bys id:  gen dup = cond(_N==1,0,_n)
drop if dup==0
drop dup id
	
tempfile id
save `id', replace

	
	
	
	
	
	
	****************************************************************************
	********* SEEDS PRICES 1

	use "${master}\Malawi11\rawdata\Agriculture\AG_MOD_H.dta", clear
	gen year=2010
	destring case_id, replace
	destring ea_id, replace

	merge m:1 case_id year using `id', keep(3) nogen
	
	replace ag_h16a=ag_h16a/1000 if ag_h16b==1
	replace ag_h16a=ag_h16a*2 if ag_h16b==3
	replace ag_h16a=ag_h16a*3 if ag_h16b==4
	replace ag_h16a=ag_h16a*3.7 if ag_h16b==5
	replace ag_h16a=ag_h16a*5 if ag_h16b==6
	replace ag_h16a=ag_h16a*10 if ag_h16b==7
	replace ag_h16a=ag_h16a*50 if ag_h16b==8
	replace ag_h16a=ag_h16a*50 if ag_h16b==8
	*dis (50+10+5+3.7+3+2+1+0.001)/8   = 9.337625
	replace ag_h16a=ag_h16a*9.337625 if ag_h16b==9

	gen price_kg1=ag_h19/ag_h16a
    gen trans_kg1=ag_h18/ag_h16a

	gen maize_seedcostkg1=price_kg if ag_h0b>=1 & ag_h0b<=2
	gen legume_seedcostkg1=price_kg if ag_h0b>=11 & ag_h0b<=16 | ag_h0b==27 | ag_h0b>=34 &  ag_h0b<=36
	gen stap_seedcostkg1=price_kg if ag_h0b>=17 & ag_h0b<=26 |  ag_h0b>=28 & ag_h0b<=33
	gen cash_seedcostkg1=price_kg if ag_h0b>=5 & ag_h0b<=10 | ag_h0b>=37 & ag_h0b<=47
	 
	 
	 summ maize_seedcostkg1, d
	replace maize_seedcostkg1=r(p50) if maize_seedcostkg1>r(p99) & maize_seedcostkg1!=.
	 
	 summ legume_seedcostkg1, d
	replace legume_seedcostkg1=r(p50) if legume_seedcostkg1>r(p99) & legume_seedcostkg1!=.
	 
	 summ stap_seedcostkg1, d
	replace stap_seedcostkg1=r(p50) if stap_seedcostkg1>r(p99) & stap_seedcostkg1!=.
	 
	 	summ cash_seedcostkg1, d
	replace cash_seedcostkg1=r(p50) if cash_seedcostkg1>r(p95) & cash_seedcostkg1!=.
	 
	 
	 
	replace ag_h26a=ag_h26a/1000 if ag_h26b==1
	replace ag_h26a=ag_h26a*2 if ag_h26b==3
	replace ag_h26a=ag_h26a*3 if ag_h26b==4
	replace ag_h26a=ag_h26a*3.7 if ag_h26b==5
	replace ag_h26a=ag_h26a*5 if ag_h26b==6
	replace ag_h26a=ag_h26a*10 if ag_h26b==7
	replace ag_h26a=ag_h26a*50 if ag_h26b==8
	replace ag_h26a=ag_h26a*50 if ag_h26b==8
	*dis (50+10+5+3.7+3+2+1+0.001)/8   = 9.337625
	replace ag_h26a=ag_h26a*9.337625 if ag_h26b==9

	gen price_kg2=ag_h29/ag_h26a
    gen trans_kg2=ag_h28/ag_h26a

	
	gen maize_seedcostkg2=price_kg2 if ag_h0b>=1 & ag_h0b<=2
	gen legume_seedcostkg2=price_kg2 if ag_h0b>=11 & ag_h0b<=16 | ag_h0b==27 | ag_h0b>=34 &  ag_h0b<=36
	gen stap_seedcostkg2=price_kg2 if ag_h0b>=17 & ag_h0b<=26 |  ag_h0b>=28 & ag_h0b<=33
	gen cash_seedcostkg2=price_kg2 if ag_h0b>=5 & ag_h0b<=10 | ag_h0b>=37 & ag_h0b<=47
	 
		 
	summ maize_seedcostkg2, d
	replace maize_seedcostkg2=r(p50) if maize_seedcostkg2>r(p99) & maize_seedcostkg2!=.
	 
	 summ legume_seedcostkg2, d
	replace legume_seedcostkg2=r(p50) if legume_seedcostkg2>r(p99) & legume_seedcostkg2!=.
	 
	 summ stap_seedcostkg2, d
	replace stap_seedcostkg2=r(p50) if stap_seedcostkg2>r(p99) & stap_seedcostkg2!=.
	 
	 	summ cash_seedcostkg2, d
	replace cash_seedcostkg2=r(p50) if cash_seedcostkg2>r(p95) & cash_seedcostkg2!=.
	  
	

	collapse maize_seedcostkg* legume_seedcostkg* stap_seedcostkg* cash_seedcostkg*, by(ea_id)
	
	gen year=2010
	destring ea_id, replace
	
	tempfile seedprice1
	save `seedprice1', replace
	

	

	
	use "${master}\Malawi13\rawdata\Agriculture\AG_MOD_H.dta", clear
	gen year=2013
	

	merge m:1 y2_hhid year using `id', keep(3) nogen
	
	replace ag_h16a=ag_h16a/1000 if ag_h16b==1
	replace ag_h16a=ag_h16a*2 if ag_h16b==3
	replace ag_h16a=ag_h16a*3 if ag_h16b==4
	replace ag_h16a=ag_h16a*3.7 if ag_h16b==5
	replace ag_h16a=ag_h16a*5 if ag_h16b==6
	replace ag_h16a=ag_h16a*10 if ag_h16b==7
	replace ag_h16a=ag_h16a*50 if ag_h16b==8
	*dis (50+10+5+3.7+3+2+1+0.001)/8   = 9.337625
	replace ag_h16a=ag_h16a*9.337625 if ag_h16b==9

	gen price_kg1=ag_h19/ag_h16a
    gen trans_kg1=ag_h18/ag_h16a
	
	
	gen maize_seedcostkg1=price_kg if ag_h0c>=1 & ag_h0c<=4
	gen legume_seedcostkg1=price_kg if ag_h0c>=11 & ag_h0c<=16 | ag_h0c==27 | ag_h0c>=34 &  ag_h0c<=36
	gen stap_seedcostkg1=price_kg if ag_h0c>=17 & ag_h0c<=26 |  ag_h0c>=28 & ag_h0c<=33
	gen cash_seedcostkg1=price_kg if ag_h0c>=5 & ag_h0c<=10 | ag_h0c>=37 & ag_h0c<=47
	 
	
	summ maize_seedcostkg1, d
	replace maize_seedcostkg1=r(p50) if maize_seedcostkg1>r(p99) & maize_seedcostkg1!=.
	 
	 summ legume_seedcostkg1, d
	replace legume_seedcostkg1=r(p50) if legume_seedcostkg1>r(p99) & legume_seedcostkg1!=.
	 
	 summ stap_seedcostkg1, d
	replace stap_seedcostkg1=r(p50) if stap_seedcostkg1>r(p95) & stap_seedcostkg1!=.
	 
	 	summ cash_seedcostkg1, d
	replace cash_seedcostkg1=r(p50) if cash_seedcostkg1>r(p95) & cash_seedcostkg1!=.
	 
	 
	replace ag_h26a=ag_h26a/1000 if ag_h26b==1
	replace ag_h26a=ag_h26a*2 if ag_h26b==3
	replace ag_h26a=ag_h26a*3 if ag_h26b==4
	replace ag_h26a=ag_h26a*3.7 if ag_h26b==5
	replace ag_h26a=ag_h26a*5 if ag_h26b==6
	replace ag_h26a=ag_h26a*10 if ag_h26b==7
	replace ag_h26a=ag_h26a*50 if ag_h26b==8
	replace ag_h26a=ag_h26a*50 if ag_h26b==8
	*dis (50+10+5+3.7+3+2+1+0.001)/8   = 9.337625
	replace ag_h26a=ag_h26a*9.337625 if ag_h26b==9

	gen price_kg2=ag_h29/ag_h26a
    gen trans_kg2=ag_h28/ag_h26a

	
	gen maize_seedcostkg2=price_kg2 if ag_h0c>=1 & ag_h0c<=4
	gen legume_seedcostkg2=price_kg2 if ag_h0c>=11 & ag_h0c<=16 | ag_h0c==27 | ag_h0c>=34 &  ag_h0c<=36
	gen stap_seedcostkg2=price_kg2 if ag_h0c>=17 & ag_h0c<=26 |  ag_h0c>=28 & ag_h0c<=33
	gen cash_seedcostkg2=price_kg2 if ag_h0c>=5 & ag_h0c<=10 | ag_h0c>=37 & ag_h0c<=47
	 
	 
	summ maize_seedcostkg2, d
	replace maize_seedcostkg2=r(p50) if maize_seedcostkg2>r(p99) & maize_seedcostkg2!=.
	 
	 summ legume_seedcostkg2, d
	replace legume_seedcostkg2=r(p50) if legume_seedcostkg2>r(p99) & legume_seedcostkg2!=.
	 
	 summ stap_seedcostkg2, d
	replace stap_seedcostkg2=r(p50) if stap_seedcostkg2>r(p99) & stap_seedcostkg2!=.
	 
	 	summ cash_seedcostkg2, d
	replace cash_seedcostkg2=r(p50) if cash_seedcostkg2>r(p99) & cash_seedcostkg2!=.
	 

	collapse maize_seedcostkg* legume_seedcostkg* stap_seedcostkg* cash_seedcostkg*, by(ea_id)
	
	gen year=2013
	destring ea_id, replace
	
	tempfile seedprice2
	save `seedprice2', replace
	
	append using `seedprice1'
	
	
	replace maize_seedcostkg1=maize_seedcostkg2 if maize_seedcostkg1==.
	replace legume_seedcostkg1=legume_seedcostkg2 if legume_seedcostkg2==.
	replace stap_seedcostkg1=stap_seedcostkg2 if stap_seedcostkg1==.
	replace cash_seedcostkg1=cash_seedcostkg2 if cash_seedcostkg1==.
	
	
	
	tempfile seedprice
	save `seedprice', replace
	
	
	

	
	******************Hybrid maize price
	
	use "${master}\Malawi11\rawdata\Community\COM_CK.dta", clear

	keep if com_ck00a==43
	
	replace com_ck00b2=com_ck00b2/50 if com_ck00b3==2
	replace com_ck00b2=com_ck00b2/240 if com_ck00b3==7
	replace com_ck00b2=com_ck00b2/200 if com_ck00b3==10 //imputed
	replace com_ck00b2=com_ck00b2/170 if com_ck00b3==11
	replace com_ck00b2=com_ck00b2*1000 if com_ck00b3==18

	
	gen hy_price=com_ck00b1/com_ck00b2

	collapse hy_price, by(ea_id)
	
	gen year=2010
	tempfile community1
	save `community1', replace
	

	
	use "${master}\Malawi13\Community\COM_MOD_K.dta", clear

	keep if com_ck00a=="CK43" 
	
	replace com_ck00b2=com_ck00b2/50 if com_ck00b3==2
	replace com_ck00b2=com_ck00b2/240 if com_ck00b3==7
	replace com_ck00b2=com_ck00b2/200 if com_ck00b3==9 //imputed
	replace com_ck00b2=com_ck00b2/200 if com_ck00b3==10 //imputed
	replace com_ck00b2=com_ck00b2/170 if com_ck00b3==11
	replace com_ck00b2=com_ck00b2*1000 if com_ck00b3==18

	gen hy_price=com_ck00b1/com_ck00b2
	
	collapse hy_price, by(ea_id)

	gen year=2013
	tempfile community2
	save `community2', replace
	
	
	append using `community1'
	
	destring ea_id, replace
	
	tempfile commpr
	save `commpr', replace
	
	
	****************************************************************************
	*********PUBLIC MARKET

	use "${master}\Malawi11\rawdata\GeoVariables\HouseholdGeovariables.dta", clear

	keep case_id dist_admarc 
	destring case_id, replace

	gen year=2010
	
	merge 1:1 case_id year using `id', keep(3) nogen


	
	
	tempfile pubmarket1
	save `pubmarket1', replace
	
	
	
	
	
use "${master}\Malawi13\Geovariables\HouseholdGeovariables_IHPS.dta",	clear
keep y2_hhid dist_admarc 
		
	gen year=2013
	
	tempfile pubmarket2
	save `pubmarket2', replace

	append using `pubmarket1'
		
	tempfile pubmarket
	save `pubmarket', replace

	
	
	
	

	
	
	
	****************************************************************************
	********* PRIVATE MARKET
	
	use "${master}\Malawi11\rawdata\Community\COM_CD.dta", clear
	gen private_market=0 if com_cd15==2 
	replace private_market=1 if com_cd15==1
	gen private_market_dist=com_cd16a  
	replace private_market_dist=private_market_dist/1000 if com_cd16b==1
	replace private_market_dist=private_market_dist*1.6 if com_cd16b==3
	
	gen privweek_market=0 if com_cd17==2 
	replace privweek_market=1 if com_cd17==1 
	
	gen privweek_dist_market=com_cd18a 
	replace privweek_dist_market=privweek_dist_market/1000 if com_cd18b==1
	replace privweek_dist_market=privweek_dist_market*1.6 if com_cd18b==3
	
	
	
	

	collapse (max) private_market private_market_dist privweek_market privweek_dist_market, by(ea_id)
	
	gen year=2010
	
	tempfile market1
	save `market1', replace

	
	
	
	
	
	use "${master}\Malawi13\Community\COM_MOD_D.dta", clear
	gen private_market=0 if com_cd15==2 
	replace private_market=1 if com_cd15==1
	gen private_market_dist=com_cd16a  
	replace private_market_dist=private_market_dist/1000 if com_cd16b==1
	replace private_market_dist=private_market_dist*1.6 if com_cd16b==3
	
	gen privweek_market=0 if com_cd17==2 
	replace privweek_market=1 if com_cd17==1 
	
	gen privweek_dist_market=com_cd18a 
	replace privweek_dist_market=privweek_dist_market/1000 if com_cd18b==1
	replace privweek_dist_market=privweek_dist_market*1.6 if com_cd18b==3
	
	
	
	
	collapse (max) private_market private_market_dist privweek_market privweek_dist_market, by(ea_id)

	
	gen year=2013
	
	tempfile market2
	save `market2', replace

	append using `market1'
	
	destring ea_id, replace
	
	tempfile market
	save `market', replace


	
	
	****************************************************************************
	********network*************************************************************
	****************************************************************************
	
	use "${master}\Malawi11\rawdata\Agriculture\AG_MOD_T1.dta", clear
	keep case_id ag_t01 ag_t02 
	gen fnetwork=0
	replace fnetwork=1 if ag_t01==1 & ag_t02==11
	collapse(max) fnetwork, by(case_id)
	gen year=2010
	destring case_id, replace
	merge 1:1 case_id year using `id', keep(3) nogen

	tempfile fnetwork1
	save `fnetwork1', replace

	
	
	
	
	use "${master}\Malawi13\rawdata\Agriculture\AG_MOD_T1.dta", clear
	keep y2_hhid ag_t01 ag_t02 
	gen fnetwork=0
	replace fnetwork=1 if ag_t01==1 & ag_t02==11
	collapse(max) fnetwork, by(y2_hhid)
	gen year=2013
	tempfile fnetwork2
	save `fnetwork2', replace
	append using  `fnetwork1'
	
	tempfile fnetwork
	save `fnetwork', replace

	
		**Inorganic fertilizer

	use "${master}\Malawi13\Sinergies_tradeoff_paper\finalmasterplot2.dta", clear
	gen inofert_maize=1 if infert_kg>0 & infert_kg!=.
	replace inofert_maize=0 if infert_kg<=1 | infert_kg==.

	collapse(max) inofert_maize  aez, by(y2_hhid year)
	tempfile fert
	save `fert', replace

	
	

	
	* --- TLU MALAWI --- */


	
	use "${master}\Malawi11\rawdata\Agriculture\AG_MOD_R1.dta", clear

	
g tlucattle   = ag_r02     if ag_r0a==301   | ag_r0a==302  | ag_r0a==303 | ag_r0a==304
g tludonkey   = ag_r02 *0.6 if ag_r0a==305 | ag_r0a==306
g tlupig      = ag_r02 *0.4 if ag_r0a==309
g tlusheep    = ag_r02 *0.2 if ag_r0a==308
g tlugoat     = ag_r02 *0.2 if ag_r0a==307
g tluduck     = ag_r02 *0.06 if ag_r0a==315
g tluchicken  = ag_r02 *0.02 if ag_r0a==310  | ag_r0a==311  | ag_r0a==312  | ag_r0a==313
g tlufowls    = ag_r02 *0.02 if ag_r0a==314 | ag_r0a==316

collapse(sum) tlu*, by(case_id )

egen tlutotal=rowtotal(tlu*)
gen year=2010

destring case_id, replace

merge 1:1 case_id year using `id', keep(3) nogen


	tempfile tlu1
	save `tlu1', replace

		use "${master}\Malawi13\rawdata\Agriculture\AG_MOD_R1.dta"

	
g tlucattle   = ag_r02     if ag_r0a==301   | ag_r0a==302  | ag_r0a==303 | ag_r0a==304  | ag_r0a==3304
g tludonkey   = ag_r02 *0.6 if ag_r0a==305 | ag_r0a==306 | ag_r0a==3305
g tlupig      = ag_r02 *0.4 if ag_r0a==309
g tlusheep    = ag_r02 *0.2 if ag_r0a==308
g tlugoat     = ag_r02 *0.2 if ag_r0a==307
g tluduck     = ag_r02 *0.06 if ag_r0a==315
g tluchicken  = ag_r02 *0.02 if ag_r0a==310  | ag_r0a==311  | ag_r0a==312  | ag_r0a==313 | ag_r0a==319  | ag_r0a==3310
g tlufowls    = ag_r02 *0.02 if ag_r0a==314 |  ag_r0a==316  |  ag_r0a==3314

collapse(sum) tlu*, by(y2_hhid)

egen tlutotal=rowtotal(tlu*)
gen year=2013

	tempfile tlu2
	save `tlu2', replace

append using `tlu1'
	
	
keep tlutotal year y2_hhid
tempfile tlu
save `tlu', replace

	
	**************************************
	**************************************	
	**************************************
	********LEVEL OF YIELD (LN)
	**************************************
	**************************************
	**************************************
	**************************************
	

	***PROVA PEPPE
	
	use "${master}\mastermalawi.dta", clear
	rename ea_id_mask ea_id2
	
	merge m:1 ea_id2 year using "${master}\climatedata_final_anto.dta", keep(1 3) nogen
	merge 1:1 y2_hhid year using `tlu', keep(3) nogen
	merge 1:1 y2_hhid year using `fert', keep(3) nogen
	merge 1:1 y2_hhid year using `fnetwork', keep(3) nogen
	merge m:1 year ea_id using `market', keep(3) nogen
	merge 1:1 year y2_hhid using `pubmarket', keep(3) nogen
	merge 1:1 year y2_hhid using `yieldfin', keep(3) nogen
	merge m:1 ea_id year using `commpr', keep(1 3) nogen
	merge m:1 ea_id year using `seedprice', keep(1 3) nogen

	
	
	***************************************************************************
	******imputing prices**********************
	****************************************************************************
	egen othprice_mean=rowmean(legume_seedcostkg1 stap_seedcostkg1 cash_seedcostkg1)
	
	***NOTE 1: we do not observe legume prices at all, so the other prices are mainly driven by staple and seed
	***let's construct seed and staple prices therefore
	
	foreach var of varlist maize_seedcostkg1 stap_seedcostkg1 cash_seedcostkg1 {
	egen `var'_d=mean(`var'), by(district_ year)
	egen `var'_n=mean(`var'), by(year)
	egen `var'_a=mean(`var')
	replace `var'=`var'_d if `var'==.
	replace `var'=`var'_n if `var'==.
	replace `var'=`var'_a if `var'==.
	drop `var'_d `var'_n `var'_a
	}
	
	gen cropincome=crop_income 

	replace cropincome=cropincome*(100/166.1245533)*(1/110.3700751) if year==2013
	replace cropincome=cropincome*(1/68.22978427) if year==2010


	
	
	replace maize_seedcostkg1=maize_seedcostkg1*(100/166.1245533)*(1/110.3700751) if year==2013
	replace maize_seedcostkg1=maize_seedcostkg1*(1/68.22978427) if year==2010
	
	replace stap_seedcostkg1=stap_seedcostkg1*(100/166.1245533)*(1/110.3700751) if year==2013
	replace stap_seedcostkg1=stap_seedcostkg1*(1/68.22978427) if year==2010

	replace cash_seedcostkg1=cash_seedcostkg1*(100/166.1245533)*(1/110.3700751) if year==2013
	replace cash_seedcostkg1=cash_seedcostkg1*(1/68.22978427) if year==2010


	
	gen ln_stapprice=ln(stap_seedcostkg1+1)
	gen ln_cashprice=ln(cash_seedcostkg1+1)
	gen ln_maizeprice=ln(maize_seedcostkg1+1)

	
	
	
	
	//rename yield_maize YI_maize
	//gen ln_yield=ln(YI_maize)
	
	
	gen l_spi6_apr_pos=spi6_apr_lag
	gen l_spi6_apr_neg=spi6_apr_lag 
	replace l_spi6_apr_pos=0 if spi6_apr_lag<0
	replace l_spi6_apr_neg=0 if spi6_apr_lag>0

	
	rename pos_flood_prob_apr flood1  
	rename neg_drought_prob_apr drought1 
	egen meanea_advice=mean(extension_adv), by(ea_id year)
	egen avgcredit=mean(credit), by(ea_id year)
	egen avgfisp=mean(hh_d_coupon), by(ea_id year)
	egen mean_network=mean(fnetwork), by(ea_id year)
	replace inofert_maize=0 if inofert_maize==.
	 
	*egen mean_network=mean(extension_adv), by(ea_id year)
	foreach var of varlist hhsize age  {
	gen ln_`var'=ln(`var')
	}
	
	rename educave edu
	
	foreach var of varlist landown edu private_market_dist {
	gen ln_`var'=ln(`var'+1)
	}
	
	qui summ ln_private_market_dist, d
	
	replace ln_private_market_dist=0 if ln_private_market_dist==.
	rename ln_landown ln_land
	rename landown land_ha
	rename agwealth wealth_ag
	rename femhead hh_female
	egen s=median(dist_admarc), by(ea_id year)
	gen ln_FRA_distance=ln(dist_admarc+1)
	drop if fsystems_hh==. | fsystems_hh==8
	egen meanprivatemarket=mean(private_market), by(district_ year)
	egen totprivatemarket=sum(private_market), by(district_ year)
	replace private_market_dist=0 if private_market==1
	gen lnprivatemarket=ln(private_market_dist+1)

	egen meanprivweekmarket=mean(privweek_market), by(district_ year)
	egen totprivweekmarket=sum(privweek_market), by(district_ year)
	replace privweek_dist_market=0 if privweek_market==1
	gen lnprivatweekemarket=ln(privweek_dist_market+1)

	
	
	
	qui tab  aez, g( aez)
	qui tab year, g(yfe)
	gen interaction=meanprivatemarket*ln_FRA_distance
	gen interaction2=private_market*ln_FRA_distance
	gen interaction3=lnprivatemarket*ln_FRA_distance
	gen int4=ln_private_market_dist*ln_FRA_distance
	gen fradummy=0
	replace fradummy=1 if dist_admarc<=7
	gen int5=private_market*fradummy
	gen ln_hybmaize=ln(hy_price+1)
	qui summ ln_hybmaize, d
	
	egen district_price=mean(hy_price), by(district_ year)
	replace ln_hybmaize=ln(district_price+1) if ln_hybmaize==.
	count if ln_hybmaize==.
	egen meanhy_price=mean(hy_price), by( year)
	replace ln_hybmaize=ln(meanhy_price+1) if ln_hybmaize==.

	
	****adult equivalent for malawi

gen hhszae = (hhsize-hhchildren)+(0.63*hhchildren)
gen landrat= land_ha/hhsize
egen landtot=sum(land_ha), by(ea_id year)
egen hhsizetot=sum(hhszae), by(ea_id year)
gen landrat2=landtot/hhsizetot

gen divergence=hhsize-hhszae
	


 gen l_spi6_apr=l_spi6_apr_neg+l_spi6_apr_pos
 
	
global instruments "flood1 drought1 meanea_advice mean_network"

global controls "wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize aez2-aez4"

*global controlsfe " wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female edu avgcredit avgfisp inofert_maize"

global market "ln_maizeprice ln_stapprice ln_cashprice  lnprivatweekemarket ln_FRA_distance"

global climatesubj "l_spi6_apr_neg l_spi6_apr_pos"

global climate "mean_tmax_season spi6_apr_neg spi6_apr_pos l_spi6_apr_neg l_spi6_apr_pos"


*merge 1:1 y2_hhid year using "/Users/peppe/Dropbox/Giuseppe_myself/Maggio/farmsystem/new files/mal_final_dataset.dta", keep(3)


egen id=group(y2_hhid)
duplicates report id
quietly bys id:  gen dup = cond(_N==1,0,_n)
drop if dup==0

**only 5055 maize farmers 


*gl results "/Users/peppe/Dropbox/Giuseppe_myself/Maggio/farmsystem/result"

global results "S:\Maggio\farmsystem\result"

gen ln_yield_hh=ln(maize_yield_hh)


**************summaries table***************************************************
 bys fsystems_hh: summ maize_yield_hh cropincome maize_seedcostkg1 stap_seedcostkg1 cash_seedcostkg1 privweek_dist_market dist_admarc  mean_tmax_season spi6_apr_neg spi6_apr_pos l_spi6_apr_neg l_spi6_apr_pos wealth_ag tlutotal land_ha hhsize age hh_female edu avgcredit avgfisp inofert_maize flood1 drought1 meanea_advice mean_network
********************************************************************************


foreach var of varlist interaction meanprivatemarket ln_FRA_distance  wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize mean_tmax_season spi6_apr_neg spi6_apr_pos l_spi6_apr_neg l_spi6_apr_pos {
egen mean_`var'=mean(`var'), by(y2_hhid)

}


***first option 
 mtreatreg ln_yield_hh  ${market} ${controls}  ${climate} yfe1 , mtreatment(fsystems_hh = ${market} ${controls} ${climatesubj} ${instruments} yfe1) simulationdraws(10) density(normal )basecat(1) vce(cluster y2_hhid)
 
 est store mtewp2

noi xml_tab mtewp2, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/Yield_mte_pooled.xls") sheet(MTREGP)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace


qui mlogit fsystems ${market}  ${controls} ${climatesubj} ${instruments} yfe1, baseoutcome(1) vce(cluster y2_hhid)


margins, dydx(ln_maizeprice ln_stapprice ln_cashprice  lnprivatweekemarket l_spi6_apr_neg l_spi6_apr_pos ln_FRA_distance flood1 drought1 meanea_advice mean_network) atmeans  post




 mtreatreg ln_yield_hh  ${market} ${controls}  ${climate} yfe1 , mtreatment(fsystems_hh = ${market} ${controls} ${climatesubj} ${instruments} yfe1) simulationdraws(10) density(normal )basecat(1) vce(cluster y2_hhid)

  forvalue i=2/7 {
 
gen beta_fsysd`i'=_b[ln_yield_hh:_Tcategory`i']
gen se_fsysd`i'=_se[ln_yield_hh:_Tcategory`i']

}




 gen newid=1
 


collapse beta_* se_*, by(newid)


reshape long beta_fsysd se_fsysd, i(newid) j(fs)

drop newid



gen y1=(exp(beta_fsysd)-1)*100
gen double y2 =round(y1,.01)
 
 tostring y2, replace force
gen perc="%"
replace y2=y2+perc


serrbar beta_fsysd se_fsysd fs, mvopt(msize(small) mlabel(y2) mcolor(edkblue)) xlabel(2 "ML" 3 "MS" 4 "MC" 5 "MLS" 6 "MLC" 7 "MLSC", valuelabel) mlcolor(edkblue) yline(0, lpattern(dash)) scale(1.64) graphregion(  margin(l+7 r+7) color(white)) ytitle("Change in maize yield compared to MM (log)") ytick(-0.0005(0.0005) 0.001)  xtitle("Cropping System")








*************
****other tests
 
 
 mtreatreg ln_yield_hh  ${market}  ${controls}  ${climate} yfe1 if year==2010, mtreatment(fsystems_hh = ${market}  ${controls} ${climatesubj} ${instruments} yfe1) simulationdraws(10) density(normal )basecat(1) vce(cluster y2_hhid)
 
 est store mtewp1

noi xml_tab mtewp1, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/Yield_mte_2010.xls") sheet(MTREGP)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace



 mtreatreg ln_yield_hh  ${market}  ${controls}  ${climate} yfe1 if year==2013, mtreatment(fsystems_hh = ${market}  ${controls} ${climatesubj} ${instruments} yfe1) simulationdraws(10) density(normal )basecat(1) vce(cluster y2_hhid)
 
 est store mtewp3

noi xml_tab mtewp3, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/Yield_mte_2013.xls") sheet(MTREGP)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace


global controls "wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize "

 xtreg ln_yield i.fsystems_hh  ${market}  ${controls}  ${climate} yfe1, fe vce(cluster y2_hhid)

  est store olsfe

 noi xml_tab olsfe, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/Yieldolsfe.xls") sheet(OLS-FE)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace

 est clear
   
  
 global controls "wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize aez2-aez4"

 xtreg ln_yield i.fsystems_hh  ${market}  ${controls}  ${climate}  yfe1, re vce(cluster y2_hhid)

 est store glsre
  
 noi xml_tab glsre, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/Yieldgls_re.xls") sheet(GLS-RE)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace
*********************



 mtreatreg ln_yield_hh  ${market}  ${controls}  ${climate} yfe1 if year==2010, mtreatment(fsystems_hh = ${market}  ${controls} ${climatesubj} ${instruments} yfe1) simulationdraws(10) density(normal )basecat(1) vce(cluster y2_hhid)

 
 
  est store mtewp
 




 ***************************
*****Income variability
***************************

egen idhh=group(y2_hhid)

 xtset idhh year

 	gen ln_cropincome=ln(crop_income)
 gen ln_cropincome2=ln(crop_income+1)

 foreach var of varlist ln_cropincome ln_cropincome2 ln_hhsize ln_age hh_female ln_edu wealth_ag tlutotal ln_land inofert_maize {
 
 egen m_`var'=mean(`var'), by(ea_id year)
 replace `var'=`var'-m_`var'
 }

  
  
 ***********************
 ***********************
 *********************** 
 *********MTREG**********
 *********************** 
 ***********************
 ***********************
  
 
 
 
global instruments "flood1 drought1 meanea_advice mean_network"

global controls "wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize aez2-aez4"

*global controlsfe " wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female edu avgcredit avgfisp inofert_maize"

global market "ln_maizeprice ln_stapprice ln_cashprice  lnprivatweekemarket ln_FRA_distance"

global climatesubj "l_spi6_apr_neg l_spi6_apr_pos"

global climate "mean_tmax_season spi6_apr_neg spi6_apr_pos l_spi6_apr_neg l_spi6_apr_pos"


  
 ***MTE Crop Income Variability Pooled


 mtreatreg ln_cropincome2 ${market}  ${controls}  ${climate} yfe1 , mtreatment(fsystems_hh = ${market}  ${controls} ${instruments} ${climatesubj} yfe1) simulationdraws(30) density(normal )basecat(1) vce(cluster y2_hhid)

predict resmtep_inc2
 
replace resmtep_inc2=(ln_cropincome-resmtep_inc2)^2

mtreatreg resmtep_inc2 ${market}  ${controls}  ${climate} yfe1, mtreatment(fsystems_hh = ${market}  ${controls} ${instruments} yfe1) simulationdraws(10) density(normal )basecat(1) vce(cluster y2_hhid)

 
est store mt_inc2
 

 noi xml_tab mt_inc2, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/IncomeVar_Pooled.xls") sheet(MTREG)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace




 
 
 
 
 
 ********************************************************************************
 *****OTHER TESTS INCOME VARIABILITY**********OLS FE*****************************
******************************************************************************** 
 ********************************************************************************
 xtreg ln_cropincome i.fsystems_hh ${market}  ${controlsfe}  ${climate}  yfe1, fe vce(cluster y2_hhid)

 predict residual_inc2, ue
 
 replace residual_inc2=residual_inc2^2
 
 
 xtreg residual_inc2 i.fsystems_hh ${market}  ${controlsfe}  ${climate}  yfe1, fe vce(cluster y2_hhid)

 predict presidual2, ue
   
 replace presidual2=presidual2^2

  ***weight need to be costant within the  group
  egen m_presidual2=mean(presidual2), by( ea_id)
  egen m_residual_inc2=mean(residual_inc2), by(ea_id)

  ***variance reg
  
 xtreg residual_inc2 i.fsystems_hh ${market}  ${controlsfe}  ${climate}  yfe1 [weight=1/m_presidual2], fe vce(cluster y2_hhid)

 
 est store fe_incre

 
 noi xml_tab fe_incre, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/IncomeVar_FE.xls") sheet(MTREG)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace

 
 ***********************
 ***********************
 ***********************
 ***********************
 *****RANDOM EFFECT
 ***********************
 ***********************
 ***********************
 ***********************
 ***********************

xtreg ln_cropincome i.fsystems_hh ${market}  ${controls}  ${climate} yfe1, re vce(cluster y2_hhid)

predict residualre_inc2, ue
 
replace residualre_inc2=residualre_inc2^2

xtreg residualre_inc2 i.fsystems_hh ${market}  ${controls}  ${climate} yfe1, re vce(cluster y2_hhid)
 
est store re_incre

noi xml_tab re_incre, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/IncomeVar_RE.xls") sheet(MTREG)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace




  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
***MTE Crop Income Variability first wave
 
mtreatreg ln_cropincome ${market}  ${controls}  ${climate} year if year==2010, mtreatment(fsystems_hh = ${market}  ${controls}  ${instruments}) simulationdraws(50) density(normal )basecat(1) vce(cluster y2_hhid)

 
predict resmte_inc2
 
replace resmte_inc2=(ln_cropincome-resmte_inc2)^2

mtreatreg resmte_inc2 ${market}  ${controls}  ${climate} if year==2010, mtreatment(fsystems_hh = ${market}  ${controls}  ${instruments}) simulationdraws(20) density(normal )basecat(1) vce(cluster y2_hhid)


est store mt_inc1

 
noi xml_tab mt_inc1, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/IncomeVar_W1.xls") sheet(MTREG)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace

 
 ***MTE Crop Income Variability second wave

mtreatreg ln_cropincome ${market}  ${controls}  ${climate} if year==2013, mtreatment(fsystems = ${market}  ${controls} ${climatesubj}  ${instruments}) simulationdraws(50) density(normal )basecat(1) vce(cluster y2_hhid)

predict resmte2_inc2
 
replace resmte2_inc2=(ln_cropincome-resmte2_inc2)^2

mtreatreg resmte2_inc2 ${market}  ${controls}  ${climate}  if year==2013, mtreatment(fsystems = ${market}  ${controls} ${climatesubj}  ${instruments}) simulationdraws(50) density(normal )basecat(1) vce(cluster y2_hhid)

est store mt_inc2

 noi xml_tab mt_inc2, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/IncomeVar_W2.xls") sheet(MTREG)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace

 
 
 
 
 
 
 
 
 ******************************************************************************** 
******************************************************************************** 
******************************************************************************** 
******************************************************************************** 
******************************************************************************** 
************ALTERNATIVE SPECIFICATIONS******************************************
******************************************************************************** 
******************************************************************************** 
******************************************************************************** 
******************************************************************************** 



 gen spiabs=abs(spi6_apr)
 gen l_spiabs=abs(l_spi6_apr)
gen prob_events=(flood1+drought1)
 

*took out this one: easervice

	
	
label var interaction "Distance from FRA (ln) X Traders (ln)"

	
global instruments "prob_events meanea_advice mean_network"

global controls "wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize aez2-aez4"

*global controlsfe " wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female edu avgcredit avgfisp inofert_maize"

global market "interaction meanprivatemarket ln_FRA_distance"

global climatesubj "l_spiabs"

global climate "mean_tmax_season tot_rain spiabs"




foreach var of varlist wealth_ag tlutotal ln_land ln_hhsize ln_age hh_female ln_edu  avgcredit avgfisp inofert_maize  interaction meanprivatemarket ln_FRA_distance l_spiabs mean_tmax_season tot_rain spiabs {

egen MUND`var'=mean(`var'), by(y2_hhid)

}

egen idhh=group(y2_hhid)

global mundlak "MUNDwealth_ag MUNDtlutotal MUNDln_land MUNDln_hhsize MUNDln_age MUNDhh_female MUNDln_edu MUNDavgcredit MUNDavgfisp MUNDinofert_maize MUNDinteraction MUNDl_spiabs MUNDmean_tmax_season MUNDtot_rain"


mtreatreg ln_yield  ${market}  ${controls}  ${climate} ${mundlak} MUNDspiabs yfe1, mtreatment(fsystems_hh = ${market}  ${controls} ${climatesubj} ${instruments}  ${mundlak} yfe1) simulationdraws(30) density(normal )basecat(1) vce(cluster idhh)

 est store mtewpalt1

 set matsize 11000
	
noi xml_tab mtewpalt1, stats(N ll chi2 r2_p)  c(Constant) t("Adoption of Farming Systems'") lines(SCOL_NAMES 13 COL_NAMES 2 _cons 2 LAST_ROW 13) font("Times New Roman" 10)  save("${results}/malawi/Yield_mte_Mundlak.xls") sheet(MTREGP)  note("Note: hh-clustered robust standard errors in parenthesis") star(* 0.1 ** 0.05 *** 0.01)   below long  replace


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
