clear

cap log close
set more off, permanently
log using croplandarea.log, replace


{
*Tanzania folder 
	global rootpath "/Users/fse/Documents/Tanzania"
	
* Intermediates folder

	global intermediates "$rootpath/intermediates"
	
* Processed folder

	global processed "$rootpath/processed_data"
* raw data files (waves 1-4)
	global raw_data1 "$rootpath/Raw_data/TZNPS_08.09"
	global raw_data2 "$rootpath/Raw_data/TZNPS_10.11"
	global raw_data3 "$rootpath/raw_data/TZNPS_12.13"
	*global raw_data4 "$rootpath\Raw_data\TZNPS_14.15"
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
	
* Wave 1
{
* Section 2A
	cd $raw_data1
	use AG_SEC_2A

* Drop missing ids, plotnum

	drop if missing(hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	
* Keep relevant vars
	
	keep hhid plotnum plotid
	label variable plotid "Household-plot id" 
	
* Save 
	
	cd $intermediates
	save temp.dta, replace


* Section 3A

	cd $raw_data1
	use AG_SEC_3A

* Drop missing ids, plotnum

	drop if missing(hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	
* Keep relevant vars
	
	keep hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save temp.dta, replace



* Section 4A

	cd $raw_data1
	use AG_SEC_4A


* Drop missing ids, plotnum

	drop if missing(hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	duplicates drop plotid, force
* Keep relevant vars
	
	keep hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save temp.dta, replace

* Section 6A

	cd $raw_data1
	use AG_SEC_6A


* Drop missing ids, plotnum

	drop if missing(hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	duplicates drop plotid, force
* Keep relevant vars
	
	keep hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save plot_roster.dta, replace

	
* 2 Section by section extract relevant vars
* 	Create file for each section 
	
{
* Section 2A

	cd $raw_data1
	use AG_SEC_2A

	
	
* Drop missing ids, plotnum
	drop if missing(hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Keep variables
	
	keep hhid plotnum plotid s2aq4 area
	label variable plotid "Household-plot id" 
	
* Rename variables

	rename (s2aq4 area) (Area_Farmer Area_GPS)
* Save to own file

	cd $intermediates
	save AG2A.dta, replace

	
	
* Section 3A

	cd $raw_data1
	use AG_SEC_3A

	
	
* Drop missing ids, plotnum
	drop if missing(hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Keep variables
	
	keep hhid plotnum plotid s3aq5code
	label variable plotid "Household-plot id" 
	
* Rename variables

	rename (s3aq5code) (Main_Crop)
* Save to own file
	
	cd $intermediates
	save AG3A.dta, replace

	
* Section 4A

	cd $raw_data1
	use AG_SEC_4A

	
	
* Drop missing ids, plotnum
	drop if missing(hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Construct plotcropid
	gen plotcropid = hhid + "-" + plotnum + "-" + string(zaocode)
	order plotcropid, after(plotid)
	
* Keep variables
	
	keep hhid plotnum plotid plotcropid zaocode s4aq3 s4aq4 s4aq6

	label variable plotid "Household-plot id" 
	label variable plotcropid "Household-plot-crop id"
	
* Rename variables

	rename (zaocode s4aq3 s4aq4 s4aq6) (Crop_Code Crop_Entire Crop_Fraction Intercropping)
* Save to own file
	
	cd $intermediates
	save AG4A.dta, replace


}
*

* 3 Merge each section file to plot-crop roster

{
* Section 2a

	cd $intermediates
	use plot_roster
	
	merge 1:1 plotid using AG2A.dta
	
	drop _merge
	
* Section 3a

	merge 1:1 plotid using AG3A.dta
	
	drop _merge
}	
*
	
* Section 4a

	merge 1:m plotid using AG4A.dta
	
	order plotcropid, after(plotid)
	
	drop _merge
	duplicates drop plotcropid, force
	
	drop if missing(plotcropid)
	
* Save to temp
	
	cd $intermediates
	save 4a_Merged.dta, replace

* 4A Merging only crop data with EA Locations
{

	cd $raw_data1
	use HH_SEC_A_T
	
* keep household id and cluster id

	keep hhid clusterid

*merge to _merged file

	cd $intermediates
	merge 1:m hhid using 4a_Merged.dta

* drop households with no plots/not in merged

	drop if missing(plotnum)
	drop if missing(clusterid)
	drop _merge
	
	sort plotid
	
* save to temp file

	cd $intermediates
	save Crops_HH_EA_Merged.dta, replace
}
*

* 5A Merging with Household Geovars, crops only
{
	cd $raw_data1
	use HH.Geovariables_Y1.dta

* keep household id and x/y coordinates

	keep hhid lat_modified lon_modified
	
* merge to _merged file

	cd $intermediates
	
	merge 1:m hhid using Crops_HH_EA_Merged.dta

* drop households with no ag data

	drop if missing(plotnum)
	drop _merge
	
	sort hhid
	
* save to temp file
	
	cd $intermediates
	save Crops_HH_Geo_Merged.dta, replace
}
*

* 6A Created Derived Variables, crops only
{
* Get EA Area totals by farmer estimate

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep hhid clusterid plotid Area_Farmer
	duplicates drop plotid, force
	
	drop if missing(clusterid)
	
* Collapse by EA and sum area
	collapse (sum) Area_Farmer, by(clusterid)
	
* Save to temp

	save Crops_FarmerArea_EA.dta, replace
	

* Get EA Area totals by GPS

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep hhid clusterid plotid Area_GPS
	duplicates drop plotid, force
	
	drop if missing(clusterid)
	
* Collapse by EA and sum area
	collapse (sum) Area_GPS, by(clusterid)
	
* Save to temp

	save Crops_GPSArea_EA.dta, replace
	
* Get Lat/Lon Coordinates for EA

* Get Latitude
	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep hhid clusterid plotid lat_modified
	
	drop if missing(clusterid)
	
* Collapse by EA and Lat variable
	collapse (mean) lat_modified, by(clusterid)
	
* Save to temp

	save Crops_Lat_EA.dta, replace
	

* Get Longitude
	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep hhid clusterid plotid lon_modified
	
	drop if missing(clusterid)
	
* Collapse by EA and Lat variable
	collapse (mean) lon_modified, by(clusterid)
	
* Save to temp

	save Crops_Lon_EA.dta, replace	
	

* Calculate area per crop by EA

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Generates correct factor for fraction per crop
	gen Crop_Fraction_Fixed = Crop_Fraction / 4
	replace Crop_Fraction_Fixed = 1 if missing(Crop_Fraction_Fixed)
	
	order Crop_Fraction_Fixed, after(Crop_Fraction)
	
* Calculates area based on fraction occupied by each crop
	gen Crop_Area = Crop_Fraction_Fixed * Area_Farmer

	keep hhid clusterid plotid plotcropid Crop_Code Crop_Area
	
	drop if missing(clusterid)
	
	rename Crop_Code ZAO_Code
	drop hhid plotid 
	
	drop if missing(ZAO_Code)
	
* Create clustercrop id for collapse
	gen clustercropid = string(clusterid) + "-" + string(ZAO_Code)
	rename Crop_Area Crop_Area_
	
* Collapse by cluster for crop area
	collapse (sum) Crop_Area_, by(clustercropid clusterid ZAO_Code)
	drop clustercropid
	
* Apply consistent set of labels to crop code
	cd $intermediates
	do cropcodes
    la val ZAO_Code cropcodes 
	
* Extract labels and create seperate string variable
	decode ZAO_Code, gen(zao_code)
	drop ZAO_Code
* Reshape to wide formate by cluster and ZAO_Code as id
	reshape wide Crop_Area_, i(clusterid) j(zao_code) string
	
* Merge with previous lat/lon and area 

* Merge with EA Lat data
	cd $intermediates
	merge 1:1 clusterid using Crops_Lat_EA.dta
	order lat_modified, after(clusterid)
	drop _merge
	
* Merge with EA Lon data
	cd $intermediates
	merge 1:1 clusterid using Crops_Lon_EA.dta
	order lon_modified, after(clusterid)
	drop _merge

* Merge with EA Farmer-reported area data
	cd $intermediates
	merge 1:1 clusterid using Crops_FarmerArea_EA.dta
	order Area_Farmer, after(lat_modified)
	drop _merge

* Merge with EA GPS-reported area data
	cd $intermediates
	merge 1:1 clusterid using Crops_GPSArea_EA.dta
	order Area_GPS, after(Area_Farmer)
	drop _merge
	
	drop if missing(lat_modified)
	
* Replaces missing values of crop area
	foreach x of varlist Crop_Area_* {
		replace `x' = 0 if missing(`x')
	}

* Creates total area number based on fractions of crops
	gen TotalArea_Check = 0
	foreach x of varlist Crop_Area_* {
		replace TotalArea_Check = TotalArea_Check + `x'
	}
	
	order TotalArea_Check, after(Area_Farmer)

	* Save data of just areas, no fractions
		
	cd $processed
	
	save crop_areaonly_w1.dta, replace
* Option for calculation type
	local cropareatype = 2

	if `cropareatype'==1 {
	* Use TotalArea_Check as estimate of total area within EA
		foreach x of varlist Crop_Area_* {
			gen `x'_Fraction = `x' / TotalArea_Check
			order `x'_Fraction, after(`x')
		}
		
		gen MaizeBeans_Ratio = Crop_Area_Maize / Crop_Area_Beans
		replace MaizeBeans_Ratio = 0 if missing(MaizeBeans_Ratio)
		
		cd $processed
		save crop_areaType1_W3.dta, replace
	}
	*
	if `cropareatype'==2 {
		* Calculate CropFrac = CropArea/TotalArea_Check 
		foreach x of varlist Crop_Area_* {
			gen `x'_Fraction = `x' / TotalArea_Check
			order `x'_Fraction, after(`x')
		* CropArea = Farmer_Area * Crop_Frac
			replace `x' = Area_Farmer * `x'_Fraction
		}
	
		gen MaizeBeans_Ratio = Crop_Area_Maize / Crop_Area_Beans
		replace MaizeBeans_Ratio = 0 if missing(MaizeBeans_Ratio)

		* Save to file
		cd $processed
		save crop_areaType2_W3.dta, replace
	}
	*
}
*
	
}
*

* Wave 2
{
{
* 1 - Create household roster
* Section 2A
	cd $raw_data2
	use AG_SEC2A

* Drop missing ids, plotnum

	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	
* Keep relevant vars
	
	keep y2_hhid plotnum plotid
	label variable plotid "Household-plot id" 
	
* Save 
	
	cd $intermediates
	save temp.dta, replace


* Section 3A

	cd $raw_data2
	use AG_SEC3A

* Drop missing ids, plotnum

	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	
* Keep relevant vars
	
	keep y2_hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save temp.dta, replace



* Section 4A

	cd $raw_data2
	use AG_SEC4A


* Drop missing ids, plotnum

	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	duplicates drop plotid, force
* Keep relevant vars
	
	keep y2_hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save temp.dta, replace

	
* Section 6A

	cd $raw_data2
	use AG_SEC6A


* Drop missing ids, plotnum

	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	duplicates drop plotid, force
* Keep relevant vars
	
	keep y2_hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save plot_roster.dta, replace

}
*	


* 2 Section by section extract relevant vars
	* 	Create file for each section 
	
{
* Section 2A

	cd $raw_data2
	use AG_SEC2A

	
	
* Drop missing ids, plotnum
	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Keep variables
	
	keep y2_hhid plotnum plotid ag2a_04 ag2a_09
	label variable plotid "Household-plot id" 
	
* Rename variables

	rename (ag2a_04 ag2a_09) (Area_Farmer Area_GPS)
* Save to own file

	cd $intermediates
	save AG2A.dta, replace

	
	
* Section 3A

	cd $raw_data2
	use AG_SEC3A

	
	
* Drop missing ids, plotnum
	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Keep variables
	
	keep y2_hhid plotnum plotid zaocode
	label variable plotid "Household-plot id" 
	
* Rename variables

	rename (zaocode) (Main_Crop)
* Save to own file
	
	cd $intermediates
	save AG3A.dta, replace

	
* Section 4A

	cd $raw_data2
	use AG_SEC4A

	
	
* Drop missing ids, plotnum
	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Construct plotcropid
	gen plotcropid = y2_hhid + "-" + plotnum + "-" + string(zaocode)
	order plotcropid, after(plotid)
	
* Keep variables
	
	keep y2_hhid plotnum plotid plotcropid zaocode ag4a_01 ag4a_02 ag4a_04

	label variable plotid "Household-plot id" 
	label variable plotcropid "Household-plot-crop id"
	
* Rename variables

	rename (zaocode ag4a_01 ag4a_02 ag4a_04) (Crop_Code Crop_Entire Crop_Fraction Intercropping)
* Save to own file
	
	cd $intermediates
	save AG4A.dta, replace


* Section 6A

	cd $raw_data2
	use AG_SEC6A

	
	
* Drop missing ids, plotnum
	drop if missing(y2_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y2_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Construct plotcropid
	gen plotcropid = y2_hhid + "-" + plotnum + "-" + string(zaocode)
	order plotcropid, after(plotid)
	
* Keep variables
	
	keep y2_hhid plotnum plotid plotcropid zaocode ag6a_05

	label variable plotid "Household-plot id" 
	label variable plotcropid "Household-plot-crop id"
	
	duplicates drop plotcropid, force
* Rename variables

	rename (zaocode ag6a_05) (TreeCrop_Code Tree_Intercropping)
* Save to own file

	cd $intermediates
	save AG6A.dta, replace
}
*	
* 3 Merge each section file to plot-crop roster

{
* Section 2a

	cd $intermediates
	use plot_roster
	
	merge 1:1 plotid using AG2A.dta
	
	drop _merge
	
* Section 3a

	merge 1:1 plotid using AG3A.dta
	
	drop _merge
	
	
* Section 4a

	merge 1:m plotid using AG4A.dta
	
	order plotcropid, after(plotid)
	
	drop _merge
	duplicates drop plotcropid, force
	
	drop if missing(plotcropid)
	
* Save to temp
	
	cd $intermediates
	save 4a_Merged.dta, replace
	

}
*
	
	


* 4A Merging only crop data with EA Locations
{

	cd $raw_data2
	use HH_SEC_A
	
* keep household id and cluster id

	keep y2_hhid clusterid

*merge to _merged file

	cd $intermediates
	merge 1:m y2_hhid using 4a_Merged.dta

* drop households with no plots/not in merged

	drop if missing(plotnum)
	drop if missing(clusterid)
	drop _merge
	
	sort plotid
	
* save to temp file

	cd $intermediates
	save Crops_HH_EA_Merged.dta, replace
}

* 5A Merging with Household Geovars, crops only
{
	cd $raw_data2
	use HH.Geovariables_Y2.dta

* keep household id and x/y coordinates

	keep y2_hhid lat_modified lon_modified
	
* merge to _merged file

	cd $intermediates
	
	merge 1:m y2_hhid using Crops_HH_EA_Merged.dta

* drop households with no ag data

	drop if missing(plotnum)
	drop _merge
	
	sort y2_hhid
	
* save to temp file
	
	cd $intermediates
	save Crops_HH_Geo_Merged.dta, replace
}
*


* 6A Created Derived Variables, crops only
{
* Get EA Area totals by farmer estimate

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y2_hhid clusterid plotid Area_Farmer
	duplicates drop plotid, force
	
	drop if missing(clusterid)
	
* Collapse by EA and sum area
	collapse (sum) Area_Farmer, by(clusterid)
	
* Save to temp

	save Crops_FarmerArea_EA.dta, replace
	

* Get EA Area totals by GPS

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y2_hhid clusterid plotid Area_GPS
	duplicates drop plotid, force
	
	drop if missing(clusterid)
	
* Collapse by EA and sum area
	collapse (sum) Area_GPS, by(clusterid)
	
* Save to temp

	save Crops_GPSArea_EA.dta, replace
	
* Get Lat/Lon Coordinates for EA

* Get Latitude
	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y2_hhid clusterid plotid lat_modified
	
	drop if missing(clusterid)
	
* Collapse by EA and Lat variable
	collapse (mean) lat_modified, by(clusterid)
	
* Save to temp

	save Crops_Lat_EA.dta, replace
	

* Get Longitude
	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y2_hhid clusterid plotid lon_modified
	
	drop if missing(clusterid)
	
* Collapse by EA and Lat variable
	collapse (mean) lon_modified, by(clusterid)
	
* Save to temp

	save Crops_Lon_EA.dta, replace	
	

* Calculate area per crop by EA

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Generates correct factor for fraction per crop
	gen Crop_Fraction_Fixed = Crop_Fraction / 4
	replace Crop_Fraction_Fixed = 1 if missing(Crop_Fraction_Fixed)
	
	order Crop_Fraction_Fixed, after(Crop_Fraction)
	
* Calculates area based on fraction occupied by each crop
	gen Crop_Area = Crop_Fraction_Fixed * Area_Farmer

	keep y2_hhid clusterid plotid plotcropid Crop_Code Crop_Area
	
	drop if missing(clusterid)
	
	rename Crop_Code ZAO_Code
	drop y2_hhid plotid 
	
	drop if missing(ZAO_Code)
* Create clustercrop id for collapse
	gen clustercropid = string(clusterid) + "-" + string(ZAO_Code)
	rename Crop_Area Crop_Area_
	
* Collapse by cluster for crop area
	collapse (sum) Crop_Area_, by(clustercropid clusterid ZAO_Code)
	drop clustercropid
	
* Apply consistent set of labels to crop code
	cd $intermediates
	do cropcodes
    la val ZAO_Code cropcodes 
	
* Extract labels and create seperate string variable
	decode ZAO_Code, gen(zao_code)
	drop ZAO_Code
* Reshape to wide formate by cluster and ZAO_Code as id
	reshape wide Crop_Area_, i(clusterid) j(zao_code) string
	
* Merge with previous lat/lon and area 

* Merge with EA Lat data
	cd $intermediates
	merge 1:1 clusterid using Crops_Lat_EA.dta
	order lat_modified, after(clusterid)
	drop _merge
	
* Merge with EA Lon data
	cd $intermediates
	merge 1:1 clusterid using Crops_Lon_EA.dta
	order lon_modified, after(clusterid)
	drop _merge

* Merge with EA Farmer-reported area data
	cd $intermediates
	merge 1:1 clusterid using Crops_FarmerArea_EA.dta
	order Area_Farmer, after(lat_modified)
	drop _merge

* Merge with EA GPS-reported area data
	cd $intermediates
	merge 1:1 clusterid using Crops_GPSArea_EA.dta
	order Area_GPS, after(Area_Farmer)
	drop _merge
	
* Replaces missing values of crop area
	foreach x of varlist Crop_Area_* {
		replace `x' = 0 if missing(`x')
	}

* Creates total area number based on fractions of crops
	gen TotalArea_Check = 0
	foreach x of varlist Crop_Area_* {
		replace TotalArea_Check = TotalArea_Check + `x'
	}
	
	order TotalArea_Check, after(Area_Farmer)

	* Save data of just areas, no fractions
		
	cd $processed
	save crop_areaonly_w2.dta, replace
	
* Option for calculation type
	local cropareatype = 2

	if `cropareatype'==1 {
	* Use TotalArea_Check as estimate of total area within EA
		foreach x of varlist Crop_Area_* {
			gen `x'_Fraction = `x' / TotalArea_Check
			order `x'_Fraction, after(`x')
		}
		
		gen MaizeBeans_Ratio = Crop_Area_Maize / Crop_Area_Beans
		replace MaizeBeans_Ratio = 0 if missing(MaizeBeans_Ratio)
		
		cd $processed
		save crop_areaType1_W3.dta, replace
	}
	*
	if `cropareatype'==2 {
		* Calculate CropFrac = CropArea/TotalArea_Check 
		foreach x of varlist Crop_Area_* {
			gen `x'_Fraction = `x' / TotalArea_Check
			order `x'_Fraction, after(`x')
		* CropArea = Farmer_Area * Crop_Frac
			replace `x' = Area_Farmer * `x'_Fraction
		}
	
		gen MaizeBeans_Ratio = Crop_Area_Maize / Crop_Area_Beans
		replace MaizeBeans_Ratio = 0 if missing(MaizeBeans_Ratio)

		* Save to file
		cd $processed
		save crop_areaType2_W3.dta, replace
	}
	
	
}
*
}	
*

	
	
* Wave 3
{
{
* 1 - Create HH Roster
* Section 2A
	cd $raw_data3
	use AG_SEC_2A

* Drop missing ids, plotnum

	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	
* Keep relevant vars
	
	keep y3_hhid plotnum plotid
	label variable plotid "Household-plot id" 
	
* Save 
	
	cd $intermediates
	save temp.dta, replace


* Section 3A

	cd $raw_data3
	use AG_SEC_3A

* Drop missing ids, plotnum

	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	
* Keep relevant vars
	
	keep y3_hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save temp.dta, replace



* Section 4A

	cd $raw_data3
	use AG_SEC_4A


* Drop missing ids, plotnum

	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	duplicates drop plotid, force
* Keep relevant vars
	
	keep y3_hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save temp.dta, replace

	
* Section 6A

	cd $raw_data3
	use AG_SEC_6A


* Drop missing ids, plotnum

	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
	
* Construct plot id - unique
	
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
	
	unique plotid
	duplicates drop plotid, force
* Keep relevant vars
	
	keep y3_hhid plotnum plotid
	label variable plotid "Household-plot id" 

* Merges data
	
	cd $intermediates
	merge 1:1 plotid using temp.dta
	
	drop _merge
	* merge 1 id in 3a, not in temp
	* merge 2 id in temp, not in 3a
	* merge 3 id in both
	
* Save 
	
	cd $intermediates
	save plot_roster.dta, replace

}
*	


* 2 Section by section extract relevant vars
	* 	Create file for each section 
	
{
* Section 2A

	cd $raw_data3
	use AG_SEC_2A

	
	
* Drop missing ids, plotnum
	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Keep variables
	
	keep y3_hhid plotnum plotid ag2a_04 ag2a_09
	label variable plotid "Household-plot id" 
	
* Rename variables

	rename (ag2a_04 ag2a_09) (Area_Farmer Area_GPS)
* Save to own file

	cd $intermediates
	save AG2A.dta, replace

	
	
* Section 3A

	cd $raw_data3
	use AG_SEC_3A

	
	
* Drop missing ids, plotnum
	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Keep variables
	
	keep y3_hhid plotnum plotid ag3a_07_2
	label variable plotid "Household-plot id" 
	
* Rename variables

	rename (ag3a_07_2) (Main_Crop)
* Save to own file
	
	cd $intermediates
	save AG3A.dta, replace

	
* Section 4A

	cd $raw_data3
	use AG_SEC_4A

	
	
* Drop missing ids, plotnum
	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Construct plotcropid
	gen plotcropid = y3_hhid + "-" + plotnum + "-" + string(zaocode)
	order plotcropid, after(plotid)
	
* Keep variables
	
	keep y3_hhid plotnum plotid plotcropid zaocode ag4a_01 ag4a_02 ag4a_04

	label variable plotid "Household-plot id" 
	label variable plotcropid "Household-plot-crop id"
	
* Rename variables

	rename (zaocode ag4a_01 ag4a_02 ag4a_04) (Crop_Code Crop_Entire Crop_Fraction Intercropping)
* Save to own file
	
	cd $intermediates
	save AG4A.dta, replace


* Section 6A

	cd $raw_data3
	use AG_SEC_6A

	
	
* Drop missing ids, plotnum
	drop if missing(y3_hhid)
	drop if missing(plotnum)
	
* Construct plotid
	gen plotid = y3_hhid + "-" + plotnum
	order plotid, after(plotnum)
	
* Construct plotcropid
	gen plotcropid = y3_hhid + "-" + plotnum + "-" + string(zaocode)
	order plotcropid, after(plotid)
	
* Keep variables
	
	keep y3_hhid plotnum plotid plotcropid zaocode ag6a_05

	label variable plotid "Household-plot id" 
	label variable plotcropid "Household-plot-crop id"
	
	duplicates drop plotcropid, force
* Rename variables

	rename (zaocode ag6a_05) (TreeCrop_Code Tree_Intercropping)
* Save to own file

	cd $intermediates
	save AG6A.dta, replace
}
*	
* 3 Merge each section file to plot-crop roster

{
* Section 2a

	cd $intermediates
	use plot_roster
	
	merge 1:1 plotid using AG2A.dta
	
	drop _merge
	
* Section 3a

	merge 1:1 plotid using AG3A.dta
	
	drop _merge
	
	
* Section 4a

	merge 1:m plotid using AG4A.dta
	
	order plotcropid, after(plotid)
	
	drop _merge
	duplicates drop plotcropid, force
	
	drop if missing(plotcropid)
	
* Save to temp
	
	cd $intermediates
	save 4a_Merged.dta, replace
	
* Section 6a - do previous merges with plot-crop data for trees
	
	cd $intermediates
	use plot_roster
	
	merge 1:1 plotid using AG2A.dta
	
	drop _merge
	
* Section 3a

	merge 1:1 plotid using AG3A.dta
	
	drop _merge
	
* Section 6a
	
	merge 1:m plotid using AG6A.dta
	
	drop _merge
	
	sort plotid
	
	drop if missing(plotcropid)
* Save to temp file

	cd $intermediates
	save 6a_Merged.dta, replace
	
* Merging two plot-crop datasets

	cd $intermediates
	use 4a_Merged.dta
	
	merge 1:1 plotcropid using 6a_Merged.dta
	
	drop _merge
	
	sort(plotid)
	
* Save to temp file

	save HH_Merged.dta, replace
}
*
	
	
* 4 Merging with EA locations
{

	cd $raw_data3
	use HH_SEC_A
	
* keep household id and cluster id

	keep y3_hhid y3_cluster

*merge to _merged file

	cd $intermediates
	merge 1:m y3_hhid using HH_Merged.dta

* drop households with no plots/not in merged

	drop if missing(plotnum)
	drop if missing(y3_cluster)
	drop _merge
	
	sort plotid
	
* save to temp file

	cd $intermediates
	save HH_EA_Merged.dta, replace
}
*


* 4A Merging only crop data with EA Locations
{

	cd $raw_data3
	use HH_SEC_A
	
* keep household id and cluster id

	keep y3_hhid y3_cluster

*merge to _merged file

	cd $intermediates
	merge 1:m y3_hhid using 4a_Merged.dta

* drop households with no plots/not in merged

	drop if missing(plotnum)
	drop if missing(y3_cluster)
	drop _merge
	
	sort plotid
	
* save to temp file

	cd $intermediates
	save Crops_HH_EA_Merged.dta, replace
}
* 5 Merging with Household Geovars

{
	cd $raw_data3
	use HouseholdGeovars_Y3

* keep household id and x/y coordinates

	keep y3_hhid lat_dd_mod lon_dd_mod
	
* merge to _merged file

	cd $intermediates
	
	merge 1:m y3_hhid using HH_EA_Merged.dta

* drop households with no ag data

	drop if missing(plotnum)
	drop _merge
	
	sort y3_hhid
	
* save to temp file
	
	cd $intermediates
	save HH_Geo_Merged.dta, replace
}	
*

* 5A Merging with Household Geovars, crops only
{
	cd $raw_data3
	use HouseholdGeovars_Y3

* keep household id and x/y coordinates

	keep y3_hhid lat_dd_mod lon_dd_mod
	
* merge to _merged file

	cd $intermediates
	
	merge 1:m y3_hhid using Crops_HH_EA_Merged.dta

* drop households with no ag data

	drop if missing(plotnum)
	drop _merge
	
	sort y3_hhid
	
* save to temp file
	
	cd $intermediates
	save Crops_HH_Geo_Merged.dta, replace
}
*

* 6 Created Derived Variables
{
* Get EA Area totals by farmer estimate

	cd $intermediates
	use HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid Area_Farmer
	duplicates drop plotid, force
	
	drop if missing(y3_cluster)
	
* Collapse by EA and sum area
	collapse (sum) Area_Farmer, by(y3_cluster)
	
* Save to temp

	save FarmerArea_EA.dta, replace
	

* Get EA Area totals by GPS

	cd $intermediates
	use HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid Area_GPS
	duplicates drop plotid, force
	
	drop if missing(y3_cluster)
	
* Collapse by EA and sum area
	collapse (sum) Area_GPS, by(y3_cluster)
	
* Save to temp

	save GPSArea_EA.dta, replace
	
* Get Lat/Lon Coordinates for EA

* Get Latitude
	cd $intermediates
	use HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid lat_dd_mod
	
	drop if missing(y3_cluster)
	
* Collapse by EA and Lat variable
	collapse (mean) lat_dd_mod, by(y3_cluster)
	
* Save to temp

	save Lat_EA.dta, replace
	

* Get Longitude
	cd $intermediates
	use HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid lon_dd_mod
	
	drop if missing(y3_cluster)
	
* Collapse by EA and Lat variable
	collapse (mean) lon_dd_mod, by(y3_cluster)
	
* Save to temp

	save Lon_EA.dta, replace	
	

* Calculate area per crop by EA

	cd $intermediates
	use HH_Geo_Merged
	
* Generates correct factor for fraction per crop
	gen Crop_Fraction_Fixed = Crop_Fraction / 4
	replace Crop_Fraction_Fixed = 1 if missing(Crop_Fraction_Fixed)
	
	order Crop_Fraction_Fixed, after(Crop_Fraction)
	
* Calculates area based on fraction occupied by each crop
	gen Crop_Area = Crop_Fraction_Fixed * Area_Farmer

	keep y3_hhid y3_cluster plotid plotcropid Crop_Code TreeCrop_Code Crop_Area
	
	drop if missing(y3_cluster)
	
* Create new column to combine 4a and 6a crop ids
	egen ZAO_Code = rowmax(Crop_Code TreeCrop_Code)
	
	drop Crop_Code TreeCrop_Code y3_hhid plotid 
* Create clustercrop id for collapse
	gen clustercropid = y3_cluster + "-" + string(ZAO_Code)
	rename Crop_Area Crop_Area_
	
* Collapse by cluster for crop area
	collapse (sum) Crop_Area_, by(clustercropid y3_cluster ZAO_Code)
	drop clustercropid

* Reshape to wide formate by cluster and ZAO_Code as id
	reshape wide Crop_Area_, i(y3_cluster) j(ZAO_Code) 
	
* Merge with previous lat/lon and area 

* Merge with EA Lat data
	cd $intermediates
	merge 1:1 y3_cluster using Lat_EA.dta
	order lat_dd_mod, after(y3_cluster)
	drop _merge
	
* Merge with EA Lon data
	cd $intermediates
	merge 1:1 y3_cluster using Lon_EA.dta
	order lon_dd_mod, after(y3_cluster)
	drop _merge

* Merge with EA Farmer-reported area data
	cd $intermediates
	merge 1:1 y3_cluster using FarmerArea_EA.dta
	order Area_Farmer, after(lat_dd_mod)
	drop _merge

* Merge with EA GPS-reported area data
	cd $intermediates
	merge 1:1 y3_cluster using GPSArea_EA.dta
	order Area_GPS, after(Area_Farmer)
	drop _merge
	
* Save to file

	cd $processed
	save cropareaw3.dta, replace
}	
*

* 6A Created Derived Variables, crops only
{
* Get EA Area totals by farmer estimate

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid Area_Farmer
	duplicates drop plotid, force
	
	drop if missing(y3_cluster)
	
* Collapse by EA and sum area
	collapse (sum) Area_Farmer, by(y3_cluster)
	
* Save to temp

	save Crops_FarmerArea_EA.dta, replace
	

* Get EA Area totals by GPS

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid Area_GPS
	duplicates drop plotid, force
	
	drop if missing(y3_cluster)
	
* Collapse by EA and sum area
	collapse (sum) Area_GPS, by(y3_cluster)
	
* Save to temp

	save Crops_GPSArea_EA.dta, replace
	
* Get Lat/Lon Coordinates for EA

* Get Latitude
	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid lat_dd_mod
	
	drop if missing(y3_cluster)
	
* Collapse by EA and Lat variable
	collapse (mean) lat_dd_mod, by(y3_cluster)
	
* Save to temp

	save Crops_Lat_EA.dta, replace
	

* Get Longitude
	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Keeps needed vars from merged file
	keep y3_hhid y3_cluster plotid lon_dd_mod
	
	drop if missing(y3_cluster)
	
* Collapse by EA and Lat variable
	collapse (mean) lon_dd_mod, by(y3_cluster)
	
* Save to temp

	save Crops_Lon_EA.dta, replace	
	

* Calculate area per crop by EA

	cd $intermediates
	use Crops_HH_Geo_Merged
	
* Generates correct factor for fraction per crop
	gen Crop_Fraction_Fixed = Crop_Fraction / 4
	replace Crop_Fraction_Fixed = 1 if missing(Crop_Fraction_Fixed)
	
	order Crop_Fraction_Fixed, after(Crop_Fraction)
	
* Calculates area based on fraction occupied by each crop
	gen Crop_Area = Crop_Fraction_Fixed * Area_Farmer

	keep y3_hhid y3_cluster plotid plotcropid Crop_Code Crop_Area
	
	drop if missing(y3_cluster)
	
	rename Crop_Code ZAO_Code
	drop y3_hhid plotid 
* Create clustercrop id for collapse
	gen clustercropid = y3_cluster + "-" + string(ZAO_Code)
	rename Crop_Area Crop_Area_
	
* Collapse by cluster for crop area
	collapse (sum) Crop_Area_, by(clustercropid y3_cluster ZAO_Code)
	drop clustercropid
	
* Apply consistent set of labels to crop code
	cd $intermediates
	do cropcodes
    la val ZAO_Code cropcodes 
	
* Extract labels and create seperate string variable
	decode ZAO_Code, gen(zao_code)
	drop ZAO_Code
* Reshape to wide formate by cluster and ZAO_Code as id
	reshape wide Crop_Area_, i(y3_cluster) j(zao_code) string
	
* Merge with previous lat/lon and area 

* Merge with EA Lat data
	cd $intermediates
	merge 1:1 y3_cluster using Crops_Lat_EA.dta
	order lat_dd_mod, after(y3_cluster)
	drop _merge
	
* Merge with EA Lon data
	cd $intermediates
	merge 1:1 y3_cluster using Crops_Lon_EA.dta
	order lon_dd_mod, after(y3_cluster)
	drop _merge

* Merge with EA Farmer-reported area data
	cd $intermediates
	merge 1:1 y3_cluster using Crops_FarmerArea_EA.dta
	order Area_Farmer, after(lat_dd_mod)
	drop _merge

* Merge with EA GPS-reported area data
	cd $intermediates
	merge 1:1 y3_cluster using Crops_GPSArea_EA.dta
	order Area_GPS, after(Area_Farmer)
	drop _merge
	
* Replaces missing values of crop area
	foreach x of varlist Crop_Area_* {
		replace `x' = 0 if missing(`x')
	}

* Creates total area number based on fractions of crops
	gen TotalArea_Check = 0
	foreach x of varlist Crop_Area_* {
		replace TotalArea_Check = TotalArea_Check + `x'
	}
	
	order TotalArea_Check, after(Area_Farmer)

	* Save data of just areas, no fractions
		
	cd $processed
	
	save crop_areaonly.dta, replace
* Option for calculation type
	local cropareatype = 2

	if `cropareatype'==1 {
	* Use TotalArea_Check as estimate of total area within EA
		foreach x of varlist Crop_Area_* {
			gen `x'_Fraction = `x' / TotalArea_Check
			order `x'_Fraction, after(`x')
		}
		
		gen MaizeBeans_Ratio = Crop_Area_Maize / Crop_Area_Beans
		replace MaizeBeans_Ratio = 0 if missing(MaizeBeans_Ratio)
		
		cd $processed
		save crop_areaType1_W3.dta, replace
	}
	*
	if `cropareatype'==2 {
		* Calculate CropFrac = CropArea/TotalArea_Check 
		foreach x of varlist Crop_Area_* {
			gen `x'_Fraction = `x' / TotalArea_Check
			order `x'_Fraction, after(`x')
		* CropArea = Farmer_Area * Crop_Frac
			replace `x' = Area_Farmer * `x'_Fraction
		}
	
		gen MaizeBeans_Ratio = Crop_Area_Maize / Crop_Area_Beans
		replace MaizeBeans_Ratio = 0 if missing(MaizeBeans_Ratio)

		cd $processed
		save crop_areaType2_W3.dta, replace
	}
	
	
* Save to file

}	
*
}
*




