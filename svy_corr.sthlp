{smcl}
{* *! version 1.0  25jun2020}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "svy_corr##syntax"}{...}
{viewerjumpto "Description" "svy_corr##description"}{...}
{viewerjumpto "Options" "svy_corr##options"}{...}
{viewerjumpto "Remarks" "svy_corr##remarks"}{...}
{viewerjumpto "Examples" "svy_corr##examples"}{...}
{title:Title}

{phang}
{bf:svy_corr} {hline 2} Calculate correlation tables controlling for probability/sample weights

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:svy_corr}
[{varlist}]
{ifin}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt sig}}display levels of significance adjusted for weights specified by {cmd:svyset} (p values){p_end}
{synopt:{opt ob:s}}display number of observations for relationship{p_end}
{synopt:{opt pair:wise}}run correlations pairwise{p_end}
{synopt:{opth pa:rtial(varlist)}}display partial correlations, controlling for interaction effects of varlist; dummies created for each value of {it:varlist}{p_end}
{synopt:{opth col:names(varlist)}}display only correlations for variables in command line, specified against {it:varlist}{p_end}
{synopt:{opth ex:port(str)}}export results to Excel, starting in cell {it:str}; requires {cmd:putexcel set} to be configured{p_end}
{synopt:{opt bo:ld}}display coefficients as bolded text in export to Excel; requires {cmd:export}{p_end}
{synopt:{opt st:ar}}display p-values as starts in export to Excel; ***=.001, **=.01, *=.05; requieres {cmd:export}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by} is not allowed.{p_end}
{p 4 6 2}
{cmd:svyset} is required; see {help svyset}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy_corr} displays the correlation matrix for a group of variables. If {it:colnames} is not specified, the matrix is displayed for all
    variables in the command line. 


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt sig} displays levels of significance, adjusted for whatever weights were specified by {cmd:svyset}.{p_end}
{phang}
{opt obs} displays number of observations for each correlation in the matrix; useful when {cmd:pair} is speficied.{p_end}
{phang}
{opt pairwise} displays all the pairwise correlation coefficients.{p_end}
{phang}
{opth partial(varlist)} displays partial correlations, controlling for interaction effects with variables specified in {it:varlist}. Dummies will be created for every value in the dataset of each variable specified.{p_end}
{phang}
{opth colnames(varlist)} displays correlation coefficients with the variables specified in the command line as rows, and the variables specified by {cmd:colnames} as columns.{p_end}
{phang}
{opth export(str)} exports results to Excel, starting in cell {it:str}. {cmd:putexcel set} must be configured prior to running {cmd:svy_corr}.{p_end}
{phang}
{opt bold} displays correlation coefficients in bold when exporting to Excel. {cmd:export} must be specified, and {cmd:putexcel set} must be configured prior to running {cmd:svy_corr}.{p_end}
{phang}
{opt star} displays p-values as stars when exporting to Excel. Options {cmd:sig} and {cmd:export} must be specified, and {cmd:putexcel set} must be configured prior to running {cmd:svy_corr}.{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
svy_corr uses a combination of the {cmd:correlate}, {cmd:pwcorr}, {cmd:reg}, and {cmd:pcorr} estimation commands. However, not all options available for these commands can be specified as of yet.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse stage5a}{p_end}

{phang}{cmd:. svyset su1 [pweight=pw], strata(strata)}{p_end}

{phang}{cmd:. svy_corr x1 x2 x3 x4, sig obs pair}{p_end}
