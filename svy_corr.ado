program svy_corr
*! version 2.1 28apr2020 Daniel Jensen
version 14.0
syntax varlist [if] [in] [, SIG Obs PArtial(varlist) COLnames(varlist) EXport(str) BOld STar PAIRwise ]
	*'sig': display significance level of correlation
	*'obs': show number of observations for correlation
	*'partial': show partial correlations, controling for varlist
	*'colnames': use varlist as column variables (default is initial varlist)
	*'export': export a table to Excel starting in cell str (requires putexcel set)
	*'bold': display coefficients in export to Excel as bold (requires 'export')
	*'star': display p-values in export to Excel as stars (requires 'export')
	*'pairwise': run correlations pairwise (don't restrict N based on number of nonmissing observations for other variables in matrix)

*Ensure criteria are met
	*Check that no string variables in correlation matrix
	cap conf str var `varlist'
	if !_rc 	{
		error 109
	}
	
	*Check that no string variables in column variables (if 'colnames' option used)
	*If 'colnames' not specified, must have at least 2 variables
	if strlen("`colnames'")>0 {
		cap conf str var `colnames'
		if !_rc {
			error 109
		}
	}
	else {
		loc a : word count `varlist'
		if `a'<2 {
			di as error "At least two variables must be specified"
			exit
		}
	}
	
	*Check that no string variables in tester variables (if 'partial' option used)
	if strlen("`partial'")>0 {
		cap conf str var `partial'
		if !_rc {
			error 109
		}
	}
	
	*If export is specified, ensure that putexcel has been configured
	*If export is not specified, neither 'star' nor 'bold' can be specified either
	if strlen("`export'")>0 {
		cap putexcel describe
		if !_rc {	
			di as text "Output will be written to Excel."
		}
		else {
			di as error "Option export has been specified. putexcel set required"
			exit
		}
	}
	else {
		if "`star'"!="" {
			di as error "Option star requires option export"
			exit
		}
		if "`bold'"!="" {
			di as error "Option bold requires option export"
			exit
		}
	}

	*Check that svyset has been configured
	qui svyset
	if strlen("`r(wvar)'")==0 {
		di as err "svyset has not been configured or weight is missing. svyset is required for this command"
		di as err "svy_pwcorr will now exit"
		exit
	}
	else {
		loc weight="`r(wvar)'"
	}
	

*Other checks to report how correlation tables will be run

	*Partial correlations
	if strlen("`partial'")>0 {
		di as text "Partial correlations have been specified. Partial correlations will be run with tester effects for all values of variable(s) `partial'"
	}
	
	*User has specified column variables
	if strlen("`colnames'")>0 {
		di as text "Column variables have been specified. Correlation coefficients will be given paired against `colnames'"
	}
	
	
di as text "Beginning calculations for pairwise correlations with `weight' as probability weight"
di ""

*Setup

	*If 'colnames' are specified, list of column variables from 'colnames'. If not, from initial variable list.
	loc rnames="`varlist'"
	if strlen("`colnames'")>0 {
		loc cnames="`colnames'"
	}
	else {
		loc cnames="`varlist'"
	}

	*Number of rows
		loc rmultiplier=1
		*If 'sig' is specified, add a row per variable, unless 'star' is specified
		if "`sig'"!="" {
			loc rmultiplier=`rmultiplier'+1
		}
		
		*If 'obs' is specified, add a row per variable
		if "`obs'"!="" {
			loc rmultiplier=`rmultiplier'+1
		}
	
	*Define matrices
	loc rnum	: word count `rnames'
	loc cnum	: word count `cnames'
	loc varnum	= `rnum'+`cnum'
	
	mat rvals	= I(`varnum')
	mat pvals	= I(`varnum')
	mat nvals	= I(`varnum')
	mat fvals	= J(`rnum'*`rmultiplier',`cnum',.)
	
	*Define labels
	foreach m in rvals pvals nvals {
		mat rown `m'=`rnames'
		mat coln `m'=`cnames'
	}
	loc labs ""
	forvalues i=1/`rnum' {
	forvalues j=1/`rmultiplier' {
		if `j'==1 {
			loc v : word `i' of `rnames'
			loc labs = "`labs' `v'"
		}
		if `j'==2 {
			if "`sig'"!="" {
				loc labs = "`labs' pval"
			}
			else {
				loc labs = "`labs' n"
			}
		}
		if `j'==3 {	
			loc labs = "`labs' n"
		}
	}
	}
	mat rown fvals =`labs'
	mat coln fvals =`cnames'
	
	*If Excel is specified, set up options to export to Excel and check for errors
	if strlen("`export'")>0 {
		
		*If a cellrange has been specified, only take the cell reference from before the colon
		if strpos("`export'",":")>0 {
			loc estart=substr("`export'",1,strpos("`export'",":")-1)
			di as text "A cell range has been specified. Only first cell referenced will be used to determine location of table"
		}
		else {
			loc estart="`export'"
		}
		
		*Set up column where table will begin
		
			*List of columns in Excel (to determine where things should go)
			loc cols A B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DD DE DF DG DH DI DJ DK DL DM DN DO DP DQ DR DS DT DU DV DW DX DY DZ EA EB EC ED EE EF EG EH EI EJ EK EL EM EN EO EP EQ ER ES ET EU EV EW EX EY EZ FA FB FC FD FE FF FG FH FI FJ FK FL FM FN FO FP FQ FR FS FT FU FV FW FX FY FZ GA GB GC GD GE GF GG GH GI GJ GK GL GM GN GO GP GQ GR GS GT GU GV GW GX GY GZ HA HB HC HD HE HF HG HH HI HJ HK HL HM HN HO HP HQ HR HS HT HU HV HW HX HY HZ IA IB IC ID IE IF IG IH II IJ IK IL IM IN IO IP IQ IR IS IT IU IV IW IX IY IZ JA JB JC JD JE JF JG JH JI JJ JK JL JM JN JO JP JQ JR JS JT JU JV JW JX JY JZ KA KB KC KD KE KF KG KH KI KJ KK KL KM KN KO KP KQ KR KS KT KU KV KW KX KY KZ LA LB LC LD LE LF LG LH LI LJ LK LL LM LN LO LP LQ LR LS LT LU LV LW LX LY LZ MA MB MC MD ME MF MG MH MI MJ MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NB NC ND NE NF NG NH NI NJ NK NL NM NN NO NP NQ NR NS NT NU NV NW NX NY NZ OA OB OC OD OE OF OG OH OI OJ OK OL OM ON OO OP OQ OR OS OT OU OV OW OX OY OZ PA PB PC PD PE PF PG PH PI PJ PK PL PM PN PO PP PQ PR PS PT PU PV PW PX PY PZ QA QB QC QD QE QF QG QH QI QJ QK QL QM QN QO QP QQ QR QS QT QU QV QW QX QY QZ RA RB RC RD RE RF RG RH RI RJ RK RL RM RN RO RP RQ RR RS RT RU RV RW RX RY RZ SA SB SC SD SE SF SG SH SI SJ SK SL SM SN SO SP SQ SR SS ST SU SV SW SX SY SZ TA TB TC TD TE TF TG TH TI TJ TK TL TM TN TO TP TQ TR TS TT TU TV TW TX TY TZ UA UB UC UD UE UF UG UH UI UJ UK UL UM UN UO UP UQ UR US UT UU UV UW UX UY UZ VA VB VC VD VE VF VG VH VI VJ VK VL VM VN VO VP VQ VR VS VT VU VV VW VX VY VZ WA WB WC WD WE WF WG WH WI WJ WK WL WM WN WO WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XE XF XG XH XI XJ XK XL XM XN XO XP XQ XR XS XT XU XV XW XX XY XZ YA YB YC YD YE YF YG YH YI YJ YK YL YM YN YO YP YQ YR YS YT YU YV YW YX YY YZ ZA ZB ZC ZD ZE ZF ZG ZH ZI ZJ ZK ZL ZM ZN ZO ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ
					
			*Determine the column of the reference specified (assumes format is correct)
				*'colp': Position of column where user requested table to start
				*'coln': The number of the column where table will start
				*'colr': The reference (letter) of the column where table will start
			loc colp="`estart'"
			forvalues i=0/9 {
				loc colp=subinstr("`colp'","`i'","",.)
			}
			loc coln=0
			loc rpt=1
			while `rpt'==1 {
				loc coln=`coln'+1
				*Maximum reference allowed is 'ZZ' (column 702).
				if `coln'+`cnum'+1>702 {
					di as error "Excel table would be outside range allowed by svy_pwcorr (max column ZZ)"
					exit
				}
				loc colr : word `coln' of `cols'
				*When match is found, exit the loop
				if "`colr'"=="`colp'" {
					loc rpt=0
				}
			}
		
		*Set up row where table will begin
		loc rown=real(subinstr("`estart'","`colp'","",.))
		
		di as text "Setup for Excel export now complete. Table will be written starting in cell `estart'"
	}
	
	*If partial correlations are specified, create tester variables
	loc tlist=""
	if strlen("`partial'")>0 {
		foreach v of varlist `partial' {
			qui levelsof `v', loc(a)
			loc b : word count `a'
			forvalues i=1/`b' {
				loc c : word `i' of `a'
				tempvar `v'_t`i'
				qui g ``v'_t`i''=`v'==`c' `if' `in'
				loc tlist="`tlist' ``v'_t`i''"
			}
		}
	}
	
	*Unless 'pairwise' is specified, restrict observations to those that are non-missing for all variables in the matrix
	if "`pairwise'"=="" {
		tempvar included
		qui g `included'=1
		foreach v of varlist `rnames' `cnames' {
			qui replace `included'=0 if `v'==.
		}
		if strlen("`if'")>0 {
			loc if2="`if' & `included'==1"
		}
		else {
			loc if2="if `included'==1"
		}
	}
	else {
		loc if2="`if'"
		di "Option pairwise has been specified. Correlations will be run pairwise"
	}

*Calculate tables
forvalues i=1/`rnum' {
forvalues j=1/`cnum' {
	*Local: should we continue with calculations?
	loc cont=0
	if `i'<`j' {
		*If 'colnames' are specified, run for all possible combinations of 'cnum' and 'rnum'
		*Otherwise, only run for first combination of variables
		if strlen("`colnames'")>0 {
			loc cont=1
		}
	}
	else {
		loc cont=1
	}
	
	if `cont'==0 {
	}
	else {
		loc var1 : word `i' of `rnames'
		loc var2 : word `j' of `cnames'
		
		*Calculate rho and nro of observations. Type of calculation will depend on whether 'partial' is specified or not.
		if strlen("`partial'")>0 {
			if `var1'==`var2' {
			}
			else {
				qui pcorr `var2' `var1' `tlist' `if2' `in' [aw=`weight']
				mat z=r(p_corr)
				loc rho_raw=z[1,1]
				if `rho_raw'>=-1 & `rho_raw'<=1 {
					matrix rvals[`i',`j']=round(`rho_raw',.0001)
					matrix nvals[`i',`j']=r(N)
				}
			}
		}
		else {
			qui corr `var2' `var1' `if2' `in' [aw=`weight']
			if r(rho)>=-1 & r(rho)<=1 {
				matrix rvals[`i',`j']=round(r(rho),.0001)
				matrix nvals[`i',`j']=r(N)
			}
		}
		
		*Calculate p value if required
		if "`sig'"!="" {
			*Don't run if 1:1 correlation
			if rvals[`i',`j']==1 {
			}
			else {
				qui svy : reg `var1' `var2' `tlist' `if2' `in' 
				mat z=r(table)
				loc p1=z[4,1]
				qui svy: reg `var2' `var1' `tlist' `if2' `in' 
				mat z=r(table)
				loc p2=z[4,1]
				matrix pvals[`i',`j']=round(max(`p1',`p2'),.0001)
			}
		}
		
		*Put values in final matrix as required by options Row number will depend on options speficied
			*Correlation coefficient
			loc k=`i'*`rmultiplier'-`rmultiplier'+1
			mat fvals[`k',`j']=rvals[`i',`j']
			*P value
			if "`sig'"!="" {
				*Don't run if 1:1 correlation
				if rvals[`i',`j']==1 {
				}
				else {
					loc l=`i'*`rmultiplier'-`rmultiplier'+2
					mat fvals[`l',`j']=pvals[`i',`j']
				}
			}
			*Nro of observations
			if "`obs'"!="" {
				*Don't run if var1 is var2
				if "`var1'"=="`var2'" {
				}
				else {
					loc n=`i'*`rmultiplier'
					mat fvals[`n',`j']=nvals[`i',`j']
				}
			}
	}
}
}
	
di ""
di as text "Correlation matrix"
mat list fvals

cap drop `tlist'

*If Excel is specified, set up options to export to Excel and check for errors
if strlen("`export'")>0 {
	tempvar rho p_val
	if "`star'"!="" {
		tempvar star1
		qui g `star1'="*"
	}
	
	*Table title
	if strlen("`partial'")>0 {
		qui putexcel `estart'=("Pairwise correlation matrix with survey weights (partial correlations)")
	}
	else {
		qui putexcel `estart'=("Pairwise correlation matrix with survey weights")
	}
	qui putexcel `estart'=bold("on")
	
	*Write row names to Excel
		*If 'star' option is specified, adjust multiplier and rewrite list of row names
		if "`star'"!="" {
			loc rmultiplier2=`rmultiplier'-1
			loc labs2 ""
			forvalues i=1/`rnum' {
			forvalues j=1/`rmultiplier2' {
				if `j'==1 {
					loc v : word `i' of `rnames'
					loc labs2 = "`labs2' `v'"
				}
				if `j'==2 {
					loc labs2 = "`labs2' n"
				}
			}
			}
		}
	else {
		loc rmultiplier2=`rmultiplier'
		loc labs2="`labs'"
	}
	loc rnum2 : word count `labs2'
	forvalues i=1/`rnum2' {
		loc r = `rown'+`i'+1
		loc l : word `i' of `labs2'
		qui putexcel `colr'`r'=("`l'")
	}
	
	*Write column names to Excel
	forvalues i=1/`cnum' {
		loc cn = `coln'+`i'
		loc cr : word `cn' of `cols'
		loc r  = `rown'+1
		loc l  : word `i' of `cnames'
		qui putexcel `cr'`r'=("`l'")
		if "`bold'"!="" {
			qui putexcel `cr'`r'=bold("on")
		}	
	}

	*Write table to Excel
	forvalues i=1/`rnum' {
	forvalues j=1/`cnum' {
		*Local: should we continue writing?
		loc cont=0
		if `i'<`j' {
			*If 'colnames' are specified, run for all possible combinations of 'cnum' and 'rnum'
			*Otherwise, only run for first combination of variables
			if strlen("`colnames'")>0 {
				loc cont=1
			}
		}
		else {
			loc cont=1
		}
		
		if `cont'==0 {
		}
		else {
		
			*Column reference
			loc cn = `coln'+`j'
			loc cr : word `cn' of `cols'
			
			*Correlation coefficients
			loc k=`i'*`rmultiplier2'-`rmultiplier2'+1
			loc r = `rown'+`k'+1	
			qui g `rho'=string(rvals[`i',`j'],"%9.3f")
				
			if "`star'"!="" {
				if pvals[`i',`j'] <= .05 {
					qui replace `rho'=`rho'+`star1'
				}
				if pvals[`i',`j'] <= .01 {
					qui replace `rho'=`rho'+`star1'
				}
				if pvals[`i',`j'] <= .001 {
					qui replace `rho'=`rho'+`star1'
				}			
			}
			
			qui levelsof `rho', loc(a)
			qui putexcel `cr'`r'=(`a')
			drop `rho'
			qui putexcel `cr'`r'=halign("center")
			if "`bold'"!="" {
				qui putexcel `cr'`r'=bold("on")
				if `j'==1 {
					qui putexcel `colr'`r'=bold("on")
				}
			}
			
			*Pvalues (if specified)
			if "`sig'"!="" & "`star'"=="" {
				if rvals[`i',`j']==1 {
				}
				else {
					loc l=`i'*`rmultiplier2'-`rmultiplier2'+2
					loc rp = `rown'+`l'+1
					qui g `p_val'=string(pvals[`i',`j'],"%9.f")
					qui levelsof `p_val', loc(a)
					qui putexcel `cr'`rp'=(`a')
					qui putexcel `cr'`rp'=halign("center")
					drop `p_val'
				}
			}
			
			*Observations (if specifed)
			if "`obs'"!="" {
				loc var1 : word `i' of `rnames'
				loc var2 : word `j' of `cnames'
				if "`var1'"=="`var2'" {
				}
				else {
					loc no  = `i'*`rmultiplier2'
					loc rno = `rown'+`no'+1
					qui putexcel `cr'`rno'=(nvals[`i',`j'])
					qui putexcel `cr'`rno'=nformat("number")
					qui putexcel `cr'`rno'=halign("center")
				}
			}
		}
	}
	}
	
	if "`star'"!="" {
		loc rfin=`rown'+`rnum2'+3
		qui putexcel `colr'`rfin'=("*p<0.05, **p<0.01, ***p<0.001")
	}
	
	cap drop `star1'
	di ""
	di as result "Writing of Excel table now complete"
		
}		
	
cap drop `included'
	

end
