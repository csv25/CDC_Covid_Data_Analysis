/************** Part 1 - Lisette Cruz Vazquez *******************
 ******Cases & Deaths occurred up to March 1st and March 31st*****/
/*** Step 1 - Import excel files into SAS***/
proc import datafile="/home/u63021488/MyFolders/us_counties_cases_covid_confirmed_usafacts(1).xlsx" 
		dbms=xlsx out=COCONF Replace;
	getnames=yes;
run;

proc import 
		datafile="/home/u63021488/MyFolders/us_counties_covid_deaths_usafacts(1).xlsx" 
		dbms=xlsx out=CODEATH Replace;
	getnames=yes;
run;

/*** Steps 2 & 4 - Data Clean up ***/
options validvarname=any;

data new_COCONF;
	set COCONF;

	if 'County Name'n="Statewide Unallocated" then
		delete;
run;

data new_CODEATH;
	set CODEATH;

	if 'County Name'n="Statewide Unallocated" then
		delete;
run;

/*** Steps 3 & 4 - Run proc freq on cases up to March 1st, 2020 ***/
data cases_up_to_march_1;
	set new_COCONF;
	as_of_3_1_2020=sum(of 'as_of_1/22/2020'n 'as_of_1/31/2020'n 'as_of_2/1/2020'n 
		'as_of_2/29/2020'n 'as_of_3/1/2020'n);
	proc freq data=cases_up_to_march_1;
    ods noproctitle;
	title1 "Covid Cases Confirmed";
	title2 "Up to March 1,2020";
	tables 'as_of_3_1_2020'n;
	run;
run;

data deaths_up_to_march_1;
	set new_CODEATH;
	as_of_3_1_2020=sum(of 'as_of_1/22/2020'n 'as_of_1/31/2020'n 'as_of_2/1/2020'n 
		'as_of_2/29/2020'n 'as_of_3/1/2020'n);
	proc freq data=deaths_up_to_march_1;
    ods noproctitle;
	title1 "Covid Deaths";
	title2 "Up to March 1st, 2020";
	tables 'as_of_3_1_2020'n;
	run;
run;

/*** Steps 5 & 6 - Average of cases for all counties as of March 31st, 2020 ***/
proc means data=new_COCONF;
    ods noproctitle;
	title1 "Avg of Confirmed Cases";
	title2 "All Counties as of March 31st, 2020";
	var 'as_of_3/31/2020'n;
run;

proc means data=new_CODEATH;
    ods noproctitle;
	title1 "Avg of Deaths";
	title2 "All Counties as of March 31st, 2020";
	var 'as_of_3/31/2020'n;
run;

/*** Steps 7 & 8 - Top three counties that had the most covid cases
and deaths as of March 31st, 2020***/
data CovidConfirm_JanMar;
	set new_COCONF;
	total_confirm=sum(of 'as_of_1/22/2020'n 'as_of_1/31/2020'n 'as_of_2/1/2020'n 
		'as_of_2/29/2020'n 'as_of_3/1/2020'n 'as_of_3/31/2020'n);
run;

proc sort data=CovidConfirm_JanMar;
	by descending total_confirm;
run;

proc print data=CovidConfirm_JanMar (obs=3);
	var 'County Name'n state total_confirm;
	title "Top_Counties_w_mostConfirmed_Cases";
	format total_confirm comma10.;
run;


data CovidDeaths_JanMar;
	set new_CODEATH;
	total_deaths=sum(of 'as_of_1/22/2020'n 'as_of_1/31/2020'n 'as_of_2/1/2020'n 
		'as_of_2/29/2020'n 'as_of_3/1/2020'n 'as_of_3/31/2020'n);
run;

proc sort data=CovidDeaths_JanMar;
	by descending total_deaths;
run;

proc print data=CovidDeaths_JanMar (obs=3);
	var 'County Name'n state total_deaths;
	title "Top_Counties_w_mostCovid_Deaths";
run;

Carlos Vargas Code :
*Group Project - Part 2;
options validvarname=V7;
libname bas150 "/home/u63027572/myfolders";
*Import us_counties_cases_covid_confirmed_usafacts;
FILENAME REFFILE 
	'/home/u63027572/myfolders/us_counties_cases_covid_confirmed_usafacts.xlsx';

PROC IMPORT DATAFILE=REFFILE 
			DBMS=XLSX 
			OUT=bas150.cases_covid_excel_file REPLACE;
			GETNAMES=YES;
RUN;

*Clean up data and calculate the to see the number of cases for each month;
*Months: Aug 2021, Sep 2021, Oct 2021, Nov 2021, and Dec 2021;

data bas150.project_Part2;
	set bas150.cases_covid_excel_file;
	if county_name ="Statewide Unallocated" then
		delete;
	aug_cases_2021=as_of_8_31_2021 - as_of_7_31_2021;
	sep_cases_2021=as_of_9_30_2021 - as_of_8_31_2021;
	oct_cases_2021=as_of_10_31_2021 - as_of_9_30_2021;
	nov_cases_2021=as_of_11_30_2021 - as_of_10_31_2021;
	dec_cases_2021=as_of_12_31_2021 - as_of_11_30_2021;
run;

proc means data=bas150.project_Part2;
	var aug_cases_2021 sep_cases_2021 oct_cases_2021 nov_cases_2021 dec_cases_2021;
run;

*Sorting Aug. cases;
proc sort data=bas150.project_Part2;
	by decending aug_cases_2021;
run;

*Sorting Sep. cases;
proc sort data=bas150.project_Part2;
	by decending sep_cases_2021;
run;

*Sorting Oct. cases;
proc sort data=bas150.project_Part2;
	by decending oct_cases_2021;
run;

*Sorting Nov. cases;
proc sort data=bas150.project_Part2;
	by decending nov_cases_2021;
run;

*Sorting Dec. cases;
proc sort data=bas150.project_part2;
	by decending dec_cases_2021;
run;

*STEP 5 Answers for  the top three counties that had the most covid cases 
in the entire US for each of the five months

August: 
1	Los Angeles County	CA	83756	
2	Miami-Dade County	FL	78018	
3	Harris County	    TX	72560	

September:
1	Harris County	    TX	58494	
2	Maricopa County	    AZ	52592	
3	Los Angeles County	CA	46574

October:
1	Maricopa County	    AZ	44474	
2	Los Angeles County	CA	34309	
3	Cook County	        IL	23324

November:
1	Maricopa County	    AZ	63593	
2	Los Angeles County	CA	32053	
3	Cook County	        IL	34447	

December: 
1	Los Angeles County	CA	213877	
2	Miami-Dade County	FL	168546	
3	Cook County	        IL	158009
