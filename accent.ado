program accent
	*! version 1.1 06dec2020 Daniel Jensen
	syntax varlist [, Name]
	
	foreach v in `varlist' {
		
		*ascii (stata 13)
			*List is for characters 128-175
			loc ascii `" C u e a a a a c e e e i i i A A E ae AE o o o u u y O U c L Y P F a i o u n N a o ? - - "1/2" "1/4" ! "<<" ">>" "'
			loc b : word count `ascii'
					
		*unicode (stata 14 and up)
			loc uni_cat c d e f
			loc uni_let 0 1 2 3 4 5 6 7 8 9 a b c d e f
			loc uni_c A A A A A A AE C E E E E I I I I
			loc uni_d D N O O O O O x O U U U U Y b B
			loc uni_e a a a a a a ae c e e e e i i i i
			loc uni_f o n o o o o o - o u u u u y b y
		
		cap conf str var `v'		
		if !_rc {

			if `c(version)'<14 {
					forvalues i=1/`b' {
						loc c=127+`i'
						loc d : word `i' of `ascii'
						qui replace `v'=itrim(subinstr(`v',char(`c'),"`d'",.))
						}
					}
				else {
					forvalues i=1/4 {
						loc a : word `i' of `uni_cat'
						forvalues j=1/16 {
							loc b : word `j' of `uni_let'
							loc c : word `j' of `uni_`a''
							loc d="\u00`a'`b'"
							qui replace `v'=itrim(subinstr(`v',ustrunescape("`d'"),"`c'",.))
							}
						}
					}
			
			di as result "All extended characters stripped from `v'"
			
			}
		else {
			di "`v' is numeric, no strip accent"
			}
		
		if "`name'"!="" {
			qui ds `v'
			loc newname `r(varlist)'
			if `c(version)'<14 {
					forvalues i=1/`b' {
						loc c=127+`i'
						loc d : word `i' of `ascii'
						loc newname=itrim(subinstr("`newname'",char(`c'),"`d'",.))
						}
					}
				else {
					forvalues i=1/4 {
						loc a : word `i' of `uni_cat'
						forvalues j=1/16 {
							loc b : word `j' of `uni_let'
							loc c : word `j' of `uni_`a''
							loc d="\u00`a'`b'"
							loc newname=itrim(subinstr("`newname'",ustrunescape("`d'"),"`c'",.))
							}
						}
					}
				qui ren `v' `newname'
			
			di as result "All extended characters stripped from variable name `v'"
			}
	}
				
end
