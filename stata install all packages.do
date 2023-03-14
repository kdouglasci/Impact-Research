/* Data cleaning and analysis setup*/
net install accent, from("https://kdouglasci.github.io/Impact-Research") replace

ssc install cfout

ssc install egenmore

ssc install egenmore

ssc install iefieldkit

ssc install mdesc

ssc install mypkg

ssc install povcalnet

net install split_pii, from("https://kdouglasci.github.io/Impact-Research") replace

net install readreplace, from("https://kdouglasci.github.io/Impact-Research") replace

ssc install reclink

ssc install rev

ssc install geodist

ssc install geodist2

*not working, not an option for apple
*net install usespss, from("https://kdouglasci.github.io/Impact-Research") replace

ssc install vlc

ssc install vreverse



/*Estimation (general)*/

*adjrr
net install st0306, from("http://www.stata-journal.com/software/sj13-3") replace

net install collin, from("https://stats.idre.ucla.edu/stat/stata/ado/analysis/") replace

ssc install elasticregress

ssc install hte

ssc install lassopack

ssc install metan

net install svy_corr, from("https://kdouglasci.github.io/Impact-Research") replace

ssc install randinf

net install spost9_ado, from("https://jslsoc.sitehost.iu.edu/stata") 



/*Factor analysis, PCA*/

ssc install factortest

net install fapara, from("https://stats.idre.ucla.edu/stat/stata/ado/analysis/") replace

net install spost9_ado, from("https://jslsoc.sitehost.iu.edu/stata") 

ssc install sortl



/*Postestimation (general)*/

ssc install crossfold

ssc install evalue_estat

ssc install fitstat, replace

​​net install mibeta, from("http://www.stata.com/users/ymarchenko")

ssc install r2sem



/*Propensity scoring*/

*attk
net install st0026_1, from("http://www.stata-journal.com/software/sj4-2") replace

*glmdose
net install st0328, from("http://www.stata-journal.com/software/sj14-1") replace

ssc install psestimate

ssc install psmatch2



/*​Sampling and power*/

net install chi2power, from("https://stats.idre.ucla.edu/stat/stata/ado/analysis/") replace

ssc install pstrata

ssc install svysampsi




/*​​Randomization*/

ssc install rsort



/*Reporting out results and other visualizations*/

ssc install asdoc

ssc install corr2docx

ssc install descsave

ssc install estout

ssc install grqreg

ssc install outreg2

ssc install svvarlbl

ssc install tabstat2excel
