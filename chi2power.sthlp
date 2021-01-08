{smcl}
{* *! version 1.0  11jun2008}{...}
{cmd:help chi2power}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:chi2power} {hline 2}}Compute power for contingency tables.
{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 14 2}
{cmd:chi2ower} [, {it:options}]

{synoptset 23 tabbed}
{synopthdr}
{synoptline}
{synopt:{opt s:tartf(#)}}Starting sample size factor{p_end}
{synopt:{opt e:ndf(#)}}Ending sample size factor{p_end}
{synopt:{opt i:ncr([#)}}Increment for sample size factor{p_end}
{synopt:{opt a:lpha(#)}}Alpha level (default is 0.05){p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{title:Description}

{pstd}
{opt chi2power} computes power for contingency tables using the observed 
likelihood-ratio chi-square as the noncentrality parameter for a noncentral 
chi-square distribution.

{title:Examples}

{phang2}{cmd:. tabi 35 35 \ 20 10, row lrchi2}{p_end}

{phang2}{cmd:. chi2power}{p_end}

{phang2}{cmd:. chi2power, startf(1) endf(5)}{p_end}

{phang2}{cmd:. chi2power, startf(1) endf(5) incr(.5)}{p_end}

{phang2}{cmd:. chi2power, startf(1) endf(5) incr(.5) alpha(.01)}{p_end}

{title:Author}

{p 4 4 2}Philip B. Ender{break}
UCLA Statistical Consulting Group{break}
ender@ucla.edu 

{p2colreset}{...}

