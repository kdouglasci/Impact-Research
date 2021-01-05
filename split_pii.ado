

program split_pii
	syntax varlist , id(string) newid1(name) newid2(name) newname(string) [replace  dir(string)]
	
	isid `id'
	
	tempvar sorter1
	gen `sorter1' = runiform()
	sort `sorter1'
	drop `sorter1'
	gen `newid1' = _n

	tempvar sorter2
	gen `sorter2' = runiform()
	sort `sorter2'
	drop `sorter2'
	gen `newid2' = _n
	
	order `id' `newid1' `newid2' , first
	
	preserve
	keep `newid1' `varlist' 
	if `"`dir'"'!="" save `"`dir'/`newname'_PII.dta"' , `replace'
	else save `"`newname'_PII.dta"' , `replace'
	restore
	
	preserve
	drop `id' `newid1' `varlist' 
	if `"`dir'"'!="" save `"`dir'/`newname'_Anonymized.dta"' , `replace'
	else save `"`newname'_Anonymized.dta"' , `replace'
	restore

	preserve
	keep `id' `newid1' `newid2'
	if `"`dir'"'!="" save `"`dir'/`newname'_IDLink.dta"' , `replace'
	else save `"`newname'_IDLink.dta"' , `replace'
	restore	
	
	di as result "Dataset was de-identified and saved as three new files: dataname_PII, dataname_Anonymized, dataname_IDLink"
	di as result "Be sure to secure the original dataset."
	di as result "It is important to consider other combinations of variables that can serve as PII, as well."
	
	di in red "Did you remove all PII variables? Consider these 18 categories, mandated by HIPAA:" ///
		_newline(1) "names" ///
		_newline(1) "phone number" ///
		_newline(1) "etc"
 
end
	






