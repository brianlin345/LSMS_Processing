clear

cap log close
set more off, permanently
log using croplandarea.log, replace


{
* Uganda folder 
	global rootpath "/Users/fse/Documents/Uganda"
	
* Intermediates folder

	global intermediates "$rootpath/intermediates"
	
* Processed folder

	global processed "$rootpath/processed_data"
* raw data files (waves 1-4)
	global raw_data2 "$rootpath/raw_data/UNPS_09.10"
	global raw_data3 "$rootpath/raw_data/UNPS_10.11"
	global raw_data4 "$rootpath/raw_data/UNPS_11.12"
}
*



* Process
* 1 Roster of households (ids) in sections 2a, 3a, 4a, 6a - HH_roster
* 2 Section by section merge to the hh_roster select/rename vars
	* 	Create file for each section 
* 3 Merge all sections together _merged
* 4 Merge merged datafile to household section for EA/location 
* 5 Merge merged datafile to HH geovariables section to geovars
* 6 Clean data, create derived vars -> cropareaw3
	
	
* Repeat for each wave of TZ with geovars: 1 + 2

* Outcome 
	* Village-wave level dataset
	* Rows - villages
	* Column = area planted of each crop (from standardized list of crops)
	* Total area across households in each village-wave
	* Fraction of planted area for each crop
	* Ratios of planted area for key crops (maize/beans)
	
	
	
	
* Wave 2
{
	* 1 - Create HH_Roster
	{
	
	* Section 4A
	
	cd $raw_data2
	use AGSEC4A
	
	drop if missing(HHID)
	drop if missing(a4aq2)
	drop if missing(a4aq1)
	
	replace a4aq2 = a4aq2 - 20 if a4aq2 > 20
	
	gen plotid = HHID + "-" + string(a4aq4)
	order plotid, after(a4aq4)
	
	duplicates drop plotid, force
	
	keep HHID a4aq4 plotid
	label variable plotid "Household-plot id" 
	
	* Save 
	
	cd $intermediates
	save temp4a.dta, replace
	
	}
	*
	
	
	* 2 - Extract relevant variables
	{

	* Section 4A
	
	cd $raw_data2
	use AGSEC4A
	
	drop if missing(HHID)
	drop if missing(a4aq4)
	drop if missing(a4aq1)
	
	*replace a4aq2 = a4aq2 - 20 if a4aq2 > 20
	
	* Create plot id
	gen plotid = HHID + "-" + string(a4aq4)
	order plotid, after(a4aq4)
	
	keep HHID plotid a4aq4 a4aq5 a4aq6 a4aq7 a4aq8 a4aq9
	
	rename(a4aq4 a4aq5 a4aq6 a4aq7 a4aq8 a4aq9) (Plot_ID Crop_Name Zao_Code Intercropping Total_Area Crop_Fraction)
	
	cd $intermediates
	save AG4A.dta, replace
	}
	*

	* 3 - Merge sections to plot roster
	{
	* Section 4A
	cd $intermediates
	use temp4a
	
	* Merge to HH data
	merge 1:m plotid using AG4A.dta
	
	drop if missing(Zao_Code)
	drop _merge
	drop a4aq4
	
	sort plotid
	
	* Save to file
	cd $intermediates
	save plotcrop_merged.dta, replace
	}
	*
	
	* 4 - Merge with EAs
	{
	cd $raw_data2
	use GSEC1
	
	keep HHID comm
	
	* Merge to EA data
	cd $intermediates
	merge 1:m HHID using plotcrop_merged
	
	drop if missing(plotid)
	drop if missing(comm)
	drop _merge
	
	sort comm
	
	* Save to file
	save cropmerged_EA.dta, replace
	
	}
	*
	
	* 5 - Merge with Geovars
	{
	cd $raw_data2
	use UNPS_Geovars_0910
	
	keep HHID lat_mod lon_mod
	
	* Merge to EA data
	cd $intermediates
	merge 1:m HHID using cropmerged_EA.dta
	
	drop if missing(plotid)
	drop if missing(comm)
	drop _merge
	
	sort comm
	
	* Save to file
	save cropmerged_EA_Geovars.dta, replace
	}
	
	* 6 - Create derived variables
	{
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Get total area per EA
	
	keep HHID comm plotid Total_Area
	
	duplicates drop plotid, force
	
	* Collapse sum for area
	collapse (sum) Total_Area, by(comm)
	
	* Save to file
	save EA_plotarea.dta, replace
	
	* Get Lat/Lon by EA
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	keep HHID comm plotid lat_mod lon_mod
	
	* Collapse mean for lat/lon
	collapse (mean) lat_mod lon_mod, by(comm)
	
	* Save to file
	save EA_coords.dta, replace
	
	* Get area by crop for EA 
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Recode crop percentage 
	gen crop_percentage = Crop_Fraction / 100
	replace crop_percentage = 1 if missing(crop_percentage)
	drop Crop_Fraction
	
	gen crop_area = crop_percentage * Total_Area
	
	keep HHID comm plotid Crop_Name crop_area
	
	* EA crop id for collapse
	gen EAcropid = comm + "-" + Crop_Name
	
	rename crop_area crop_area_
	
	* Collapse to EA level first
	collapse (sum) crop_area_, by(EAcropid comm Crop_Name)
	
	drop EAcropid
	
	* Reshape to final wide format
	reshape wide crop_area_, i(comm) j(Crop_Name) string
	
	* Merge with other files
	cd $intermediates
	
	merge 1:1 comm using EA_plotarea.dta
	
	drop _merge
	order Total_Area, after(comm)
	
	merge 1:1 comm using EA_coords.dta
	
	drop _merge
	order lon_mod, after(comm)
	order lat_mod, after(comm)
	
	* Replace missing values with 0
	foreach x of varlist crop_area_* {
		replace `x' = 0 if missing(`x')
	}
	
	* Save to file
	cd $processed
	save croparea_w2.dta, replace
	}
	*
}
*


* Wave 3
{
	* 1 - Create HH_Roster
	{
	
	* Section 4A
	
	cd $raw_data3
	use AGSEC4A
	
	drop if missing(HHID)
	drop if missing(pltid)
	
	gen plotid = HHID + "-" + string(pltid)
	order plotid, after(pltid)
	
	duplicates drop plotid, force
	
	keep HHID pltid plotid
	label variable plotid "Household-plot id" 
	
	* Save 
	
	cd $intermediates
	save temp4a.dta, replace
	
	}
	*
	
	
	* 2 - Extract relevant variables
	{

	* Section 4A
	
	cd $raw_data3
	use AGSEC4A
	
	drop if missing(HHID)
	drop if missing(pltid)
	
	*replace a4aq2 = a4aq2 - 20 if a4aq2 > 20
	
	gen plotid = HHID + "-" + string(pltid)
	order plotid, after(pltid)
	
	keep HHID plotid pltid cropID a4aq7 a4aq8 a4aq9
	
	rename(pltid cropID a4aq7 a4aq8 a4aq9) (Plot_Num Zao_Code Intercropping Total_Area Crop_Fraction)
	
	* Save to file
	cd $intermediates
	save AG4A.dta, replace
	}
	*

	* 3 - Merge sections to plot roster
	{
	* Section 4A
	cd $intermediates
	use temp4a
	
	
	merge 1:m plotid using AG4A.dta
	
	drop if missing(Zao_Code)
	drop _merge
	drop pltid
	
	sort plotid
	
	* Save to file
	cd $intermediates
	save plotcrop_merged.dta, replace
	}
	*
	
	* 4 - Merge with EAs
	{
	cd $raw_data3
	use GSEC1
	
	keep HHID comm
	
	cd $intermediates
	merge 1:m HHID using plotcrop_merged
	
	drop if missing(plotid)
	drop if missing(comm)
	drop _merge
	
	sort comm
	
	save cropmerged_EA.dta, replace
	
	}
	*
	
	* 5 - Merge with Geovars
	{
	cd $raw_data3
	use UNPS_Geovars_1011
	
	keep HHID lat_mod lon_mod
	
	* Merge with EA data
	cd $intermediates
	merge 1:m HHID using cropmerged_EA.dta
	
	drop if missing(plotid)
	drop if missing(comm)
	drop _merge
	
	sort comm
	
	save cropmerged_EA_Geovars.dta, replace
	}
	
	* 6 - Create derived variables
	{
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Get total area per EA
	
	keep HHID comm plotid Total_Area
	
	duplicates drop plotid, force
	
	* Collapse sum for area
	collapse (sum) Total_Area, by(comm)
	
	
	save EA_plotarea.dta, replace
	
	* Get Lat/Lon by EA
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	keep HHID comm plotid lat_mod lon_mod
	
	* Collapse mean for lat/lon
	collapse (mean) lat_mod lon_mod, by(comm)
	
	save EA_coords.dta, replace
	
	* Get area by crop for EA 
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Recode area percents
	gen crop_percentage = Crop_Fraction / 100
	replace crop_percentage = 1 if missing(crop_percentage)
	drop Crop_Fraction
	
	gen crop_area = crop_percentage * Total_Area
	
	keep HHID comm plotid Zao_Code crop_area
	
	* EA crop id for collapse
	gen EAcropid = comm + "-" + string(Zao_Code)
	
	rename crop_area crop_area_
	
	* Collapse in EA first
	collapse (sum) crop_area_, by(EAcropid comm Zao_Code)
	
	drop EAcropid
	
	decode Zao_Code, gen(Crop_Name)
	drop Zao_Code
	
	drop if missing(Crop_Name)
	
	* Reshape to wide format
	reshape wide crop_area_, i(comm) j(Crop_Name) string
	
	* Merge with other files
	cd $intermediates
	
	merge 1:1 comm using EA_plotarea.dta
	
	drop _merge
	order Total_Area, after(comm)
	
	merge 1:1 comm using EA_coords.dta
	
	drop _merge
	order lon_mod, after(comm)
	order lat_mod, after(comm)
	
	* Replace missing values with 0
	foreach x of varlist crop_area_* {
		replace `x' = 0 if missing(`x')
	}
	
	* Save to final file
	cd $processed
	save croparea_w3.dta, replace
	}
	*
}
*


* Wave 4
{
	* 1 - Create HH_Roster
	{
	
	* Section 4A
	
	cd $raw_data4
	use AGSEC4A
	
	drop if missing(HHID)
	drop if missing(plotID)
	
	format HHID %20.0f
	
	tostring HHID, gen(HHID_new) format("%17.0f")
	drop HHID
	
	rename HHID_new HHID
	
	gen plotid = HHID + "-" + string(plotID)
	order plotid, after(plotID)
	
	duplicates drop plotid, force
	
	keep HHID plotID plotid
	label variable plotid "Household-plot id" 
	
	* Save 
	
	cd $intermediates
	save temp4a.dta, replace
	
	}
	*
	
	
	* 2 - Extract relevant variables
	{

	* Section 4A
	
	cd $raw_data4
	use AGSEC4A
	
	drop if missing(HHID)
	drop if missing(plotID)
		
	* Reformat HHID values
	format HHID %20.0f
	
	* Convert to string for id
	tostring HHID, gen(HHID_new) format("%17.0f")
	drop HHID
	
	rename HHID_new HHID
	
	gen plotid = HHID + "-" + string(plotID)
	order plotid, after(plotID)
	
	keep HHID plotid plotID cropID a4aq7 a4aq8 a4aq9
	
	rename(plotID cropID a4aq7 a4aq8 a4aq9) (Plot_Num Zao_Code Intercropping Total_Area Crop_Fraction)
	
	cd $intermediates
	save AG4A.dta, replace
	}
	*

	* 3 - Merge sections to plot roster
	{
	* Section 4A
	cd $intermediates
	use temp4a
	
	
	merge 1:m plotid using AG4A.dta
	
	drop if missing(Zao_Code)
	drop _merge
	drop plotID
	
	sort plotid
	
	cd $intermediates
	save plotcrop_merged.dta, replace
	}
	*
	
	* 4 - Merge with EAs
	{
	cd $raw_data4
	use GSEC1
	
	keep HHID comm
	
	* Merge to HH data
	cd $intermediates
	merge 1:m HHID using plotcrop_merged
	
	drop if missing(plotid)
	drop if missing(comm)
	drop _merge
	
	sort comm
	
	save cropmerged_EA.dta, replace
	
	}
	*
	
	* 5 - Merge with Geovars
	{
	cd $raw_data4
	use UNPS_Geovars_1112
	
	keep HHID lat_mod lon_mod
	
	* Merge with EA data
	cd $intermediates
	merge 1:m HHID using cropmerged_EA.dta
	
	drop if missing(plotid)
	drop if missing(comm)
	drop _merge
	
	sort comm
	
	save cropmerged_EA_Geovars.dta, replace
	}
	
	* 6 - Create derived variables
	{
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Reformat EA values to string
	* Get total area per EA
	tostring comm, gen(comm_new) format("%17.0f")
	drop comm
	
	rename comm_new comm
	
	keep HHID comm plotid Total_Area
	
	duplicates drop plotid, force
	
	* Collapse sum for area
	collapse (sum) Total_Area, by(comm)
	
	save EA_plotarea.dta, replace
	
	* Get Lat/Lon by EA
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Reformat EA to string
	tostring comm, gen(comm_new) format("%17.0f")
	drop comm
	
	rename comm_new comm
	
	keep HHID comm plotid lat_mod lon_mod
	
	* Collapse by mean for lat/lon
	collapse (mean) lat_mod lon_mod, by(comm)
	
	save EA_coords.dta, replace
	
	* Get area by crop for EA 
	cd $intermediates
	use cropmerged_EA_Geovars.dta
	
	* Recode crop area percents
	gen crop_percentage = Crop_Fraction / 100
	replace crop_percentage = 1 if missing(crop_percentage)
	drop Crop_Fraction
	
	gen crop_area = crop_percentage * Total_Area
	
	keep HHID comm plotid Zao_Code crop_area
	
	* Reformat EA to string
	tostring comm, gen(comm_new) format("%17.0f")
	drop comm
	
	rename comm_new comm
	
	* EA crop id for collapse 
	gen EAcropid = comm + "-" + string(Zao_Code)
	
	rename crop_area crop_area_
	
	* Collapse in EA first
	collapse (sum) crop_area_, by(EAcropid comm Zao_Code)
	
	drop EAcropid
	
	* Pull value label instead of code
	decode Zao_Code, gen(Crop_Name)
	drop Zao_Code
	
	drop if missing(Crop_Name)
	
	* Reshape to wide format
	reshape wide crop_area_, i(comm) j(Crop_Name) string
	
	* Merge with other files
	cd $intermediates
	
	merge 1:1 comm using EA_plotarea.dta
	
	drop _merge
	order Total_Area, after(comm)
	
	merge 1:1 comm using EA_coords.dta
	
	drop _merge
	order lon_mod, after(comm)
	order lat_mod, after(comm)
	
	drop if missing(lat_mod)
	drop if missing(lon_mod)
	
	* Replace missing values with 0
	foreach x of varlist crop_area_* {
		replace `x' = 0 if missing(`x')
	}
	
	* Save final file
	cd $processed
	save croparea_w4.dta, replace
	}
	*
}
*

