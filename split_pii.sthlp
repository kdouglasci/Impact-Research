{smcl}
{* *! version 1.0 Matthew Bombyk 21apr2016}{...}
{title:Title}

{phang}
{cmd:split_pii} {hline 2} Stata module to simplify dataset de-identification.

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:de_audit} {varlist} {cmd:,} {opth id(varname)} {opth newid1(varname)} {opth newid2(varname)} {opth newname(string)} [{it:options}]


{* Using -help duplicates- as a template.}{...}
{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{* Using -help ca postestimation- as a template.}{...}
{p2coldent:* {opth id(varname)}}the unique ID{p_end}
{p2coldent:* {opth newid1(varname)}} Name of new variable containing the ID in the dataset of identifiers. {p_end}
{p2coldent:* {opth newid2(varname)}} Name of new variable containing the ID in the anonymized dataset. {p_end}
{p2coldent:* {opth newname(filename)}} Name of new files. Three files with this name will be produced with difference suffixes.{p_end}

{syntab:Options}
{synopt:{opt replace}} Replace datasets if they exist.{p_end}
{synopt:{opth dir(dirname)}} Specifies the directory to save the new files. Defaults to working directory.{p_end}


{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt id()}, {opt newid1()}, {opt newid2()}, and {opt newname()} are required.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:split_pii} removes direct identifiers (specified in {varlist}) from the dataset
in memory and generates three new datasets: one with direct identifiers (a.k.a. personally identifying information or PII), 
one with anonymized data, and linking file. Both the PII and anonymized data files are given new, randomly assigned IDs.{p_end}

{pstd}New files are named in a standard way:{p_end}
	{it:newname}_PII.dta
	{it:newname}_Anonymized.dta
	{it:newname}_IDLink.dta

	
{marker remarks}{...}
{title:Remarks}

{pstd}
The GitHub repository for {cmd:split_pii} is
{browse "https://github.com/PovertyAction/split_pii":here}.
Previous versions may be found there: see the tags.{p_end}

{pstd}
This module only removes direct identifiers. It does not perform all data anonymization activities, particularly
when variables must be censored or statistically perturbed in some way. This is
usually necessary to some extent prior to data publication. However,
removing direct identifiers early on increases data security and is often 
sufficient for limited sharing. {it:Be careful to search the dataset thoroughly for all direct identifiers.} {p_end}

{pstd} {hi:Warning!! You should encrypt or delete the original dataset} 
{hi:after running this command.} The PII and anonymized datasets should be 
stored separately from the ID links. {p_end}


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opth dir(dirname)} Do any of the options need additional explanation?




{marker examples}{...}
{title:Examples}

{pstd}Remove the variables name, phone, and dob.{p_end}

{phang2}{cmd:split_pii name phone dob , id(KEY) newid1(id_pii) id2(id_data) newname("my baseline data")} {p_end} 

		


{marker author}{...}
{title:Author}

{pstd}Matthew Bombyk{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/de_audit/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}


