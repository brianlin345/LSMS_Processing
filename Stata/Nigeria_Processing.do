clear

cap log close
set more off, permanently
log using croplandarea.log, replace


{
* Nigeria folder 
	global rootpath "/Users/fse/Documents/Nigeria"
	
* Intermediates folder

	global intermediates "$rootpath/intermediates"
	
* Processed folder

	global processed "$rootpath/processed_data"
* raw data files (waves 1-4)
	global raw_data1 "$rootpath/raw_data/GHS_10.11"
	global raw_data2 "$rootpath/raw_data/GHS_12.13"
	global raw_data3 "$rootpath/raw_data/GHS_15.16"
}
*

* Process
* 1 Roster of households (ids) in sections - HH_roster
* 2 Section by section merge to the hh_roster select/rename vars
	* 	Create file for each section 
* 3 Merge all sections together _merged
* 4 Merge merged datafile to household section for EA/location 
* 5 Merge merged datafile to HH geovariables section to geovars
* 6 Clean data, create derived vars -> cropareaw3
	
	
* Repeat for each wave of NG with geovars: 1 + 2

* Outcome 
	* Village-wave level dataset
	* Rows - villages
	* Column = area planted of each crop (from standardized list of crops)
	* Total area across households in each village-wave
	* Fraction of planted area for each crop
	* Ratios of planted area for key crops (maize/beans)
	
	
	
* Wave 1 
{
	* 1 - Create HH roster
	{
	* Section 11a
	cd $raw_data1
	use sect11a1_plantingw1
	
	keep hhid plotid
	
	rename plotid plotnum
	
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	* Save to file
	cd $intermediates
	save temp.dta, replace
	
	* Section 11f
	cd $raw_data1
	use sect11f_plantingw1
	
	keep hhid plotid
	
	rename plotid plotnum
	
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	duplicates drop plotid, force
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	
	* Save to file
	cd $intermediates
	save HH_roster.dta, replace
	}
	*
	
	* 2 - Extract relevant variables
	{
	* Section 11a
	cd $raw_data1
	use sect11a1_plantingw1
	
	keep zone ea hhid plotid s11aq4a s11aq4b s11aq4d
	
	rename (s11aq4a s11aq4b s11aq4d) (Area_Farmer Area_FarmerUnits Area_GPS)
	
	rename plotid plotnum

	gen plotid = string(hhid) + "-" + string(plotnum)
	label variable plotid "Household-plot id" 
	
	* Unit conversions to hectares
	
	replace Area_Farmer=Area_Farmer*0.4 if Area_FarmerUnits==5 //acres
	replace Area_Farmer=Area_Farmer*1 if Area_FarmerUnits==6 //hectares
	replace Area_Farmer=Area_Farmer*0.0001 if Area_FarmerUnits==7 //sq. meters
	replace Area_Farmer=Area_Farmer*0.00012 if Area_FarmerUnits==1 & (zone==1 | zone==6) //heaps zone 1 or 6
	replace Area_Farmer=Area_Farmer*0.00016 if Area_FarmerUnits==1 & zone==2 //heaps zone 2
	replace Area_Farmer=Area_Farmer*0.00011 if Area_FarmerUnits==1 & zone==3 //heaps zone 3
	replace Area_Farmer=Area_Farmer*0.00019 if Area_FarmerUnits==1 & zone==4 //heaps zone 4
	replace Area_Farmer=Area_Farmer*0.00021 if Area_FarmerUnits==1 & zone==5 //heaps zone 5
	replace Area_Farmer=Area_Farmer*0.0027 if Area_FarmerUnits==2 & zone==1 //ridges zone 1
	replace Area_Farmer=Area_Farmer*0.004 if Area_FarmerUnits==2 & zone==2 //ridges zone 2
	replace Area_Farmer=Area_Farmer*0.00494 if Area_FarmerUnits==2 & zone==3 //ridges zone 3
	replace Area_Farmer=Area_Farmer*0.0023 if Area_FarmerUnits==2 & (zone==4 | zone==5) //ridges zone 4 or 5
	replace Area_Farmer=Area_Farmer*0.00001 if Area_FarmerUnits==2 & zone==6 //ridges zone 6
	replace Area_Farmer=Area_Farmer*0.00006 if Area_FarmerUnits==3 & zone==1 //stands zone 1
	replace Area_Farmer=Area_Farmer*0.00016 if Area_FarmerUnits==3 & zone==2 //stands zone 2
	replace Area_Farmer=Area_Farmer*0.00004 if Area_FarmerUnits==3 & (zone==3 | zone==4) //stands zone 3 or 4
	replace Area_Farmer=Area_Farmer*0.00013 if Area_FarmerUnits==3 & zone==5 //stands zone 5
	replace Area_Farmer=Area_Farmer*0.00041 if Area_FarmerUnits==3 & zone==6 //stands zone 6
	
	
	* Save to file
	cd $intermediates
	save 11a.dta, replace
	
	* Section 11f
	cd $raw_data1
	use sect11f_plantingw1
	
	keep zone ea hhid plotid cropcode s11fq1a s11fq1b
	
	rename (s11fq1a s11fq1b) (Crop_Area Crop_AreaUnits)
	rename plotid plotnum
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	* Unit Conversion to Hectares
	
	replace Crop_Area=Crop_Area*0.4 if Crop_AreaUnits==5 //acres
	replace Crop_Area=Crop_Area*1 if Crop_AreaUnits==6 //hectares
	replace Crop_Area=Crop_Area*0.0001 if Crop_AreaUnits==7 //sq. meters
	replace Crop_Area=Crop_Area*0.00012 if Crop_AreaUnits==1 & (zone==1 | zone==6) //heaps zone 1 or 6
	replace Crop_Area=Crop_Area*0.00016 if Crop_AreaUnits==1 & zone==2 //heaps zone 2
	replace Crop_Area=Crop_Area*0.00011 if Crop_AreaUnits==1 & zone==3 //heaps zone 3
	replace Crop_Area=Crop_Area*0.00019 if Crop_AreaUnits==1 & zone==4 //heaps zone 4
	replace Crop_Area=Crop_Area*0.00021 if Crop_AreaUnits==1 & zone==5 //heaps zone 5
	replace Crop_Area=Crop_Area*0.0027 if Crop_AreaUnits==2 & zone==1 //ridges zone 1
	replace Crop_Area=Crop_Area*0.004 if Crop_AreaUnits==2 & zone==2 //ridges zone 2
	replace Crop_Area=Crop_Area*0.00494 if Crop_AreaUnits==2 & zone==3 //ridges zone 3
	replace Crop_Area=Crop_Area*0.0023 if Crop_AreaUnits==2 & (zone==4 | zone==5) //ridges zone 4 or 5
	replace Crop_Area=Crop_Area*0.00001 if Crop_AreaUnits==2 & zone==6 //ridges zone 6
	replace Crop_Area=Crop_Area*0.00006 if Crop_AreaUnits==3 & zone==1 //stands zone 1
	replace Crop_Area=Crop_Area*0.00016 if Crop_AreaUnits==3 & zone==2 //stands zone 2
	replace Crop_Area=Crop_Area*0.00004 if Crop_AreaUnits==3 & (zone==3 | zone==4) //stands zone 3 or 4
	replace Crop_Area=Crop_Area*0.00013 if Crop_AreaUnits==3 & zone==5 //stands zone 5
	replace Crop_Area=Crop_Area*0.00041 if Crop_AreaUnits==3 & zone==6 //stands zone 6
	
	* Save to file
	
	cd $intermediates
	save 11f.dta, replace
	
	}
	*
	
	* 3 Merge to HH_Roster
	{
	
	* Section 11a
	cd $intermediates
	use HH_roster
	
	* Merge to roster
	merge 1:1 plotid using 11a.dta
	drop _merge
	
	
	* Section 11f
	cd $intermediates
	
	* Merge to roster
	merge 1:m plotid using 11f.dta
	drop _merge
	
	* Keep needed observations
	drop if missing(cropcode)
	drop if missing(Crop_Area)	
	
	* Drop unneeded vars
	drop Area_FarmerUnits Crop_AreaUnits 
	drop zone
	
	* Save to file
	cd $intermediates
	save crop_merged.dta, replace
	}
	*
	
	* 4 Merge with Lat/Lon Coords
	{
	cd $raw_data1
	use NGA_HouseholdGeovariables_Y1.dta
	
	keep hhid lat_dd_mod lon_dd_mod
	
	* Merge to HH data
	cd $intermediates
	merge 1:m hhid using crop_merged.dta
	
	drop _merge
	drop if missing(plotnum)
	
	* Save to file 
	cd $intermediates
	save crop_mergedEA.dta, replace
	}
	*
	
	* 5 Calc Derived Variables
	{
	* Get total area by EA
	cd $intermediates
	use crop_mergedEA
	
	duplicates drop plotid, force
	
	collapse (sum) Area_Farmer, by(ea)
	drop if missing(ea)
	
	cd $intermediates
	save EA_plotarea.dta, replace
	
	* Get lat/lon by EA
	
	cd $intermediates
	use crop_mergedEA
	
	collapse (mean) lat_dd_mod lon_dd_mod, by(ea)
	
	cd $intermediates
	save EA_coords.dta, replace
	
	* Get area per crop by EA
	
	cd $intermediates
	use crop_mergedEA
	
	keep hhid plotnum plotid ea cropcode Crop_Area
	
	* For collapse within EA
	gen EAcropid = string(ea) + "-" + string(cropcode)
	
	rename Crop_Area crop_area_
	decode cropcode, gen(cropname)
	
	drop if missing(ea)
	
	* Collapses each crop by EA
	collapse (sum) crop_area_, by(EAcropid ea cropname)
	
	drop EAcropid
	
	* Fixes naming issues
	replace cropname = subinstr(cropname, "/", "_",.)
	replace cropname = subinstr(cropname, "-", "_",.)
	replace cropname = subinstr(cropname, " ", "",.)
	replace cropname = subinstr(cropname, "(", "_",.)
	replace cropname = subinstr(cropname, ")", "",.)



	* Reshape to final wide format
	reshape wide crop_area_, i(ea) j(cropname) string
	
	* Replace missing with 0 values
	foreach x of varlist crop_area_* {
		replace `x' = 0 if missing(`x')
	}
	
	* Merge to other files
	
	cd $intermediates
	merge 1:1 ea using EA_plotarea.dta
	order Area_Farmer, after(ea)
	
	drop _merge
	
	cd $intermediates
	merge 1:1 ea using EA_coords.dta
	order lon_dd_mod, after(ea)
	order lat_dd_mod, after(ea)
	
	drop if missing(Area_Farmer)
	drop _merge
	
	* Save final file
	cd $processed
	save croparea_w1.dta, replace
	
	}
	*
	
	
}
*	
	
	

	
* Wave 2
{
	* 1 - Create HH roster
	{
	* Section 11a
	cd $raw_data2
	use sect11a1_plantingw2
	
	keep hhid plotid
	
	rename plotid plotnum
	
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	* Save to file
	cd $intermediates
	save temp.dta, replace
	
	* Section 11f
	cd $raw_data2
	use sect11f_plantingw2
	
	keep hhid plotid
	
	rename plotid plotnum
	
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	duplicates drop plotid, force
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	
	* Save to file
	cd $intermediates
	save HH_roster.dta, replace
	}
	*
	
	* 2 - Extract relevant variables
	{
	* Section 11a
	cd $raw_data2
	use sect11a1_plantingw2
	
	keep zone ea hhid plotid s11aq4a s11aq4b s11aq4c
	
	rename (s11aq4a s11aq4b s11aq4c) (Area_Farmer Area_FarmerUnits Area_GPS)
	
	rename plotid plotnum

	gen plotid = string(hhid) + "-" + string(plotnum)
	label variable plotid "Household-plot id" 
	
	* Unit conversions to hectares
	
	replace Area_Farmer=Area_Farmer*0.4 if Area_FarmerUnits==5 //acres
	replace Area_Farmer=Area_Farmer*1 if Area_FarmerUnits==6 //hectares
	replace Area_Farmer=Area_Farmer*0.0001 if Area_FarmerUnits==7 //sq. meters
	replace Area_Farmer=Area_Farmer*0.00012 if Area_FarmerUnits==1 & (zone==1 | zone==6) //heaps zone 1 or 6
	replace Area_Farmer=Area_Farmer*0.00016 if Area_FarmerUnits==1 & zone==2 //heaps zone 2
	replace Area_Farmer=Area_Farmer*0.00011 if Area_FarmerUnits==1 & zone==3 //heaps zone 3
	replace Area_Farmer=Area_Farmer*0.00019 if Area_FarmerUnits==1 & zone==4 //heaps zone 4
	replace Area_Farmer=Area_Farmer*0.00021 if Area_FarmerUnits==1 & zone==5 //heaps zone 5
	replace Area_Farmer=Area_Farmer*0.0027 if Area_FarmerUnits==2 & zone==1 //ridges zone 1
	replace Area_Farmer=Area_Farmer*0.004 if Area_FarmerUnits==2 & zone==2 //ridges zone 2
	replace Area_Farmer=Area_Farmer*0.00494 if Area_FarmerUnits==2 & zone==3 //ridges zone 3
	replace Area_Farmer=Area_Farmer*0.0023 if Area_FarmerUnits==2 & (zone==4 | zone==5) //ridges zone 4 or 5
	replace Area_Farmer=Area_Farmer*0.00001 if Area_FarmerUnits==2 & zone==6 //ridges zone 6
	replace Area_Farmer=Area_Farmer*0.00006 if Area_FarmerUnits==3 & zone==1 //stands zone 1
	replace Area_Farmer=Area_Farmer*0.00016 if Area_FarmerUnits==3 & zone==2 //stands zone 2
	replace Area_Farmer=Area_Farmer*0.00004 if Area_FarmerUnits==3 & (zone==3 | zone==4) //stands zone 3 or 4
	replace Area_Farmer=Area_Farmer*0.00013 if Area_FarmerUnits==3 & zone==5 //stands zone 5
	replace Area_Farmer=Area_Farmer*0.00041 if Area_FarmerUnits==3 & zone==6 //stands zone 6
	
	* Save to file
	cd $intermediates
	save 11a.dta, replace
	
	* Section 11f
	cd $raw_data2
	use sect11f_plantingw2
	
	keep zone ea hhid plotid cropcode s11fq1a s11fq1b
	
	rename (s11fq1a s11fq1b) (Crop_Area Crop_AreaUnits)
	rename plotid plotnum
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	* Unit Conversion to Hectares
	
	replace Crop_Area=Crop_Area*0.4 if Crop_AreaUnits==5 //acres
	replace Crop_Area=Crop_Area*1 if Crop_AreaUnits==6 //hectares
	replace Crop_Area=Crop_Area*0.0001 if Crop_AreaUnits==7 //sq. meters
	replace Crop_Area=Crop_Area*0.00012 if Crop_AreaUnits==1 & (zone==1 | zone==6) //heaps zone 1 or 6
	replace Crop_Area=Crop_Area*0.00016 if Crop_AreaUnits==1 & zone==2 //heaps zone 2
	replace Crop_Area=Crop_Area*0.00011 if Crop_AreaUnits==1 & zone==3 //heaps zone 3
	replace Crop_Area=Crop_Area*0.00019 if Crop_AreaUnits==1 & zone==4 //heaps zone 4
	replace Crop_Area=Crop_Area*0.00021 if Crop_AreaUnits==1 & zone==5 //heaps zone 5
	replace Crop_Area=Crop_Area*0.0027 if Crop_AreaUnits==2 & zone==1 //ridges zone 1
	replace Crop_Area=Crop_Area*0.004 if Crop_AreaUnits==2 & zone==2 //ridges zone 2
	replace Crop_Area=Crop_Area*0.00494 if Crop_AreaUnits==2 & zone==3 //ridges zone 3
	replace Crop_Area=Crop_Area*0.0023 if Crop_AreaUnits==2 & (zone==4 | zone==5) //ridges zone 4 or 5
	replace Crop_Area=Crop_Area*0.00001 if Crop_AreaUnits==2 & zone==6 //ridges zone 6
	replace Crop_Area=Crop_Area*0.00006 if Crop_AreaUnits==3 & zone==1 //stands zone 1
	replace Crop_Area=Crop_Area*0.00016 if Crop_AreaUnits==3 & zone==2 //stands zone 2
	replace Crop_Area=Crop_Area*0.00004 if Crop_AreaUnits==3 & (zone==3 | zone==4) //stands zone 3 or 4
	replace Crop_Area=Crop_Area*0.00013 if Crop_AreaUnits==3 & zone==5 //stands zone 5
	replace Crop_Area=Crop_Area*0.00041 if Crop_AreaUnits==3 & zone==6 //stands zone 6
	
	* Save to file
	cd $intermediates
	save 11f.dta, replace
	
	}
	*
	
	* 3 Merge to HH_Roster
	{
	
	* Section 11a
	cd $intermediates
	use HH_roster
	
	* Merge to HH Roster
	merge 1:1 plotid using 11a.dta
	drop _merge
	
	
	* Section 11f
	cd $intermediates
	
	* Merge to HH Roster
	merge 1:m plotid using 11f.dta
	drop _merge
	
	* Drop unneeded vars
	drop if missing(cropcode)
	drop if missing(Crop_Area)	
	
	drop Area_FarmerUnits Crop_AreaUnits 
	drop zone
	
	* Save to file
	cd $intermediates
	save crop_merged.dta, replace
	}
	*
	
	* 4 Merge with Lat/Lon Coords
	{
	cd $raw_data2
	use NGA_HouseholdGeovars_Y2.dta
	
	keep hhid LAT_DD_MOD LON_DD_MOD
	rename(LAT_DD_MOD LON_DD_MOD) (lat_dd_mod lon_dd_mod)
	
	* Merge to HH data
	cd $intermediates
	merge 1:m hhid using crop_merged.dta
	
	drop _merge
	drop if missing(plotnum)
	
	* Save to file
	cd $intermediates
	save crop_mergedEA.dta, replace
	}
	*
	
	* 5 Calc Derived Variables
	{
	* Get total area by EA
	cd $intermediates
	use crop_mergedEA
	
	duplicates drop plotid, force
	
	* Collapse sum for area
	collapse (sum) Area_Farmer, by(ea)
	drop if missing(ea)
	
	cd $intermediates
	save EA_plotarea.dta, replace
	
	* Get lat/lon by EA
	
	cd $intermediates
	use crop_mergedEA
	
	* Collapse mean for lat/lon by EA
	collapse (mean) lat_dd_mod lon_dd_mod, by(ea)
	
	cd $intermediates
	save EA_coords.dta, replace
	
	* Get area per crop by EA
	
	cd $intermediates
	use crop_mergedEA
	
	keep hhid plotnum plotid ea cropcode Crop_Area
	
	* EA crop id for initial collapse
	gen EAcropid = string(ea) + "-" + string(cropcode)
	
	rename Crop_Area crop_area_
	decode cropcode, gen(cropname)
	
	drop if missing(ea)
	
	* Collapse area by ea for crops
	collapse (sum) crop_area_, by(EAcropid ea cropname)
	
	drop EAcropid
	 
	* Fixes naming issues
	replace cropname = subinstr(cropname, "/", "_",.)
	replace cropname = subinstr(cropname, "-", "_",.)
	replace cropname = subinstr(cropname, " ", "_",.)
	replace cropname = subinstr(cropname, "(", "_",.)
	replace cropname = subinstr(cropname, ")", "",.)



	* Wide reshape to final form
	reshape wide crop_area_, i(ea) j(cropname) string
	
	* Replaces missing with 0 values
	foreach x of varlist crop_area_* {
		replace `x' = 0 if missing(`x')
	}
	
	* Merge to other files
	
	cd $intermediates
	merge 1:1 ea using EA_plotarea.dta
	order Area_Farmer, after(ea)
	
	drop _merge
	
	cd $intermediates
	merge 1:1 ea using EA_coords.dta
	order lon_dd_mod, after(ea)
	order lat_dd_mod, after(ea)
	
	drop if missing(Area_Farmer)
	drop _merge
	
	* Save final file
	cd $processed
	save croparea_w2.dta, replace
	
	}
	*
	
	
}
*	
	
	
	
* Wave 3
{
	* 1 - Create HH roster
	{
	* Section 11a
	cd $raw_data3
	use sect11a1_plantingw3
	
	keep hhid plotid
	
	rename plotid plotnum
	
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	* Save to file
	cd $intermediates
	save temp.dta, replace
	
	* Section 11f
	cd $raw_data3
	use sect11f_plantingw3
	
	keep hhid plotid
	
	rename plotid plotnum
	
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	duplicates drop plotid, force
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	
	* Save to file
	cd $intermediates
	save HH_roster.dta, replace
	}
	*
	
	* 2 - Extract relevant variables
	{
	* Section 11a
	cd $raw_data3
	use sect11a1_plantingw3
	
	keep zone ea hhid plotid s11aq4a s11aq4b s11aq4c
	
	rename (s11aq4a s11aq4b s11aq4c) (Area_Farmer Area_FarmerUnits Area_GPS)
	
	rename plotid plotnum

	gen plotid = string(hhid) + "-" + string(plotnum)
	label variable plotid "Household-plot id" 
	
	* Unit conversions to hectares
	
	replace Area_Farmer=Area_Farmer*0.4 if Area_FarmerUnits==5 //acres
	replace Area_Farmer=Area_Farmer*1 if Area_FarmerUnits==6 //hectares
	replace Area_Farmer=Area_Farmer*0.0001 if Area_FarmerUnits==7 //sq. meters
	replace Area_Farmer=Area_Farmer*0.00012 if Area_FarmerUnits==1 & (zone==1 | zone==6) //heaps zone 1 or 6
	replace Area_Farmer=Area_Farmer*0.00016 if Area_FarmerUnits==1 & zone==2 //heaps zone 2
	replace Area_Farmer=Area_Farmer*0.00011 if Area_FarmerUnits==1 & zone==3 //heaps zone 3
	replace Area_Farmer=Area_Farmer*0.00019 if Area_FarmerUnits==1 & zone==4 //heaps zone 4
	replace Area_Farmer=Area_Farmer*0.00021 if Area_FarmerUnits==1 & zone==5 //heaps zone 5
	replace Area_Farmer=Area_Farmer*0.0027 if Area_FarmerUnits==2 & zone==1 //ridges zone 1
	replace Area_Farmer=Area_Farmer*0.004 if Area_FarmerUnits==2 & zone==2 //ridges zone 2
	replace Area_Farmer=Area_Farmer*0.00494 if Area_FarmerUnits==2 & zone==3 //ridges zone 3
	replace Area_Farmer=Area_Farmer*0.0023 if Area_FarmerUnits==2 & (zone==4 | zone==5) //ridges zone 4 or 5
	replace Area_Farmer=Area_Farmer*0.00001 if Area_FarmerUnits==2 & zone==6 //ridges zone 6
	replace Area_Farmer=Area_Farmer*0.00006 if Area_FarmerUnits==3 & zone==1 //stands zone 1
	replace Area_Farmer=Area_Farmer*0.00016 if Area_FarmerUnits==3 & zone==2 //stands zone 2
	replace Area_Farmer=Area_Farmer*0.00004 if Area_FarmerUnits==3 & (zone==3 | zone==4) //stands zone 3 or 4
	replace Area_Farmer=Area_Farmer*0.00013 if Area_FarmerUnits==3 & zone==5 //stands zone 5
	replace Area_Farmer=Area_Farmer*0.00041 if Area_FarmerUnits==3 & zone==6 //stands zone 6
	
	* Save to file
	cd $intermediates
	save 11a.dta, replace
	
	* Section 11f
	cd $raw_data3
	use sect11f_plantingw3
	
	keep zone ea hhid plotid cropcode s11fq1a s11fq1b
	
	rename (s11fq1a s11fq1b) (Crop_Area Crop_AreaUnits)
	rename plotid plotnum
	gen plotid = string(hhid) + "-" + string(plotnum)
	
	label variable plotid "Household-plot id" 
	
	* Unit Conversion to Hectares
	
	replace Crop_Area=Crop_Area*0.4 if Crop_AreaUnits==5 //acres
	replace Crop_Area=Crop_Area*1 if Crop_AreaUnits==6 //hectares
	replace Crop_Area=Crop_Area*0.0001 if Crop_AreaUnits==7 //sq. meters
	replace Crop_Area=Crop_Area*0.00012 if Crop_AreaUnits==1 & (zone==1 | zone==6) //heaps zone 1 or 6
	replace Crop_Area=Crop_Area*0.00016 if Crop_AreaUnits==1 & zone==2 //heaps zone 2
	replace Crop_Area=Crop_Area*0.00011 if Crop_AreaUnits==1 & zone==3 //heaps zone 3
	replace Crop_Area=Crop_Area*0.00019 if Crop_AreaUnits==1 & zone==4 //heaps zone 4
	replace Crop_Area=Crop_Area*0.00021 if Crop_AreaUnits==1 & zone==5 //heaps zone 5
	replace Crop_Area=Crop_Area*0.0027 if Crop_AreaUnits==2 & zone==1 //ridges zone 1
	replace Crop_Area=Crop_Area*0.004 if Crop_AreaUnits==2 & zone==2 //ridges zone 2
	replace Crop_Area=Crop_Area*0.00494 if Crop_AreaUnits==2 & zone==3 //ridges zone 3
	replace Crop_Area=Crop_Area*0.0023 if Crop_AreaUnits==2 & (zone==4 | zone==5) //ridges zone 4 or 5
	replace Crop_Area=Crop_Area*0.00001 if Crop_AreaUnits==2 & zone==6 //ridges zone 6
	replace Crop_Area=Crop_Area*0.00006 if Crop_AreaUnits==3 & zone==1 //stands zone 1
	replace Crop_Area=Crop_Area*0.00016 if Crop_AreaUnits==3 & zone==2 //stands zone 2
	replace Crop_Area=Crop_Area*0.00004 if Crop_AreaUnits==3 & (zone==3 | zone==4) //stands zone 3 or 4
	replace Crop_Area=Crop_Area*0.00013 if Crop_AreaUnits==3 & zone==5 //stands zone 5
	replace Crop_Area=Crop_Area*0.00041 if Crop_AreaUnits==3 & zone==6 //stands zone 6
	
	* Save to file
	cd $intermediates
	save 11f.dta, replace
	
	}
	*
	
	* 3 Merge to HH_Roster
	{
	
	* Section 11a
	cd $intermediates
	use HH_roster
	
	* Merge to HH roster
	merge 1:1 plotid using 11a.dta
	drop _merge
	
	
	* Section 11f
	cd $intermediates
	
	* Merge to HH roster
	merge 1:m plotid using 11f.dta
	drop _merge
	
	drop if missing(cropcode)
	drop if missing(Crop_Area)	
	
	drop Area_FarmerUnits Crop_AreaUnits 
	drop zone
	
	* Save to file
	cd $intermediates
	save crop_merged.dta, replace
	}
	*
	
	* 4 Merge with Lat/Lon Coords
	{
	cd $raw_data3
	use NGA_HouseholdGeovars_Y3.dta
	
	keep hhid LAT_DD_MOD LON_DD_MOD
	rename(LAT_DD_MOD LON_DD_MOD) (lat_dd_mod lon_dd_mod)
	
	* Merge to HH level data
	cd $intermediates
	merge 1:m hhid using crop_merged.dta
	
	drop _merge
	drop if missing(plotnum)
	
	* Save to file
	cd $intermediates
	save crop_mergedEA.dta, replace
	}
	*
	
	* 5 Calc Derived Variables
	{
	* Get total area by EA
	cd $intermediates
	use crop_mergedEA
	
	duplicates drop plotid, force
	
	* Collapse by sum for area
	collapse (sum) Area_Farmer, by(ea)
	drop if missing(ea)
	
	* Save to file
	cd $intermediates
	save EA_plotarea.dta, replace
	
	* Get lat/lon by EA
	
	cd $intermediates
	use crop_mergedEA
	
	* Collapse by mean for lat/lon
	collapse (mean) lat_dd_mod lon_dd_mod, by(ea)
	
	* Save to file
	cd $intermediates
	save EA_coords.dta, replace
	
	* Get area per crop by EA
	
	cd $intermediates
	use crop_mergedEA
	
	keep hhid plotnum plotid ea cropcode Crop_Area
	
	* id for collapse across EA
	gen EAcropid = string(ea) + "-" + string(cropcode)
	
	rename Crop_Area crop_area_
	decode cropcode, gen(cropname)
	
	drop if missing(ea)
	
	* Reformats value labels
	replace cropname = substr(cropname, strpos(cropname, ".") + 2, strlen(cropname))
	
	* Collapse by EA first
	collapse (sum) crop_area_, by(EAcropid ea cropname)
	
	drop EAcropid
	
	* Fixes naming issues
	replace cropname = subinstr(cropname, "/", "_",.)
	replace cropname = subinstr(cropname, "-", "_",.)
	replace cropname = subinstr(cropname, " ", "_",.)
	replace cropname = subinstr(cropname, "(", "_",.)
	replace cropname = subinstr(cropname, ")", "",.)



	* Reshape to final wide format
	reshape wide crop_area_, i(ea) j(cropname) string
	
	* Replace missing values with 0
	foreach x of varlist crop_area_* {
		replace `x' = 0 if missing(`x')
	}
	
	* Merge to other files
	
	cd $intermediates
	merge 1:1 ea using EA_plotarea.dta
	order Area_Farmer, after(ea)
	
	drop _merge
	
	cd $intermediates
	merge 1:1 ea using EA_coords.dta
	order lon_dd_mod, after(ea)
	order lat_dd_mod, after(ea)
	
	drop if missing(Area_Farmer)
	drop _merge
	
	* Save to final file
	cd $processed
	save croparea_w3.dta, replace
	
	}
	*
	
	
}
*	
	
	
