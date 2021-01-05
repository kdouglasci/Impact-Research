{smcl}
{* *! version 1.1  06dec2020}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "accent##syntax"}{...}
{viewerjumpto "Description" "accent##description"}{...}
{viewerjumpto "Options" "accent##options"}{...}
{viewerjumpto "Remarks" "accent##remarks"}{...}
{viewerjumpto "Examples" "accent##examples"}{...}
{title:Title}

{phang}
{bf:accent} {hline 2} Remove all accents and extended characters from string variables or variable names

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:accent}
[{varlist}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt n:ame}}strip accents and extended characters from variable names instead of observations.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by} is not allowed.


{marker description}{...}
{title:Description}

{pstd}
{cmd:accent} removes accents and extended characters from string variables or variable names, to improve ease of cleaning and avoid distorted characters when working between multiple versions of Stata.


{marker options}{...}
{title:Options}
{pstd}
{opt name} cleans variable names instead of observations.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:accent} is backwards compatible (i.e. pre Stata 14) and works with both Unicode and ASCII. It was initially designed to work with data collected in Spanish but will also work with most cases from French as well. If you find an extended character that is not removed by the command, please contact djensen@us.ci.org to report the bug


{marker examples}{...}
{title:Examples}

{phang}{cmd: clear}{p_end}
{phang}{cmd: input str50 city}{p_end}
{phang}{cmd: "Córdoba"}{p_end}
{phang}{cmd: "A Coruña"}{p_end}
{phang}{cmd: "buen"}{p_end}
{phang}{cmd: end}{p_end}
{phang}{cmd: accent city}{p_end}
