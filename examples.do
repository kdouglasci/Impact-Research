*************************************************************
*********************BINOMIAL********************************
*************************************************************


**********************binomial GPS***************************
log using glmgpscore1, replace
use lotterydataset
egen max_p=max(prize)
generate fraction= prize/max_p
quietly generate cut1 = 23/max_p if fraction<=23/max_p
quietly replace cut1 = 80/max_p if fraction>23/max_p & fraction<=80/max_p
quietly replace cut1 = 485/max_p if fraction >80/max_p
#delimit ;
glmgpscore male ownhs owncoll tixbot workthen yearw yearm1 yearm2,
t(fraction) gpscore(gpscore_fr) predict(y_hat_fr) sigma(sd_fr) 
cutpoints(cut1) index(mean) nq_gps(5) family(binomial) link(logit) detail
;
#delimit cr
log close, replace

**********************binomial doserespone********************
log using glmgpscore2, replace
use lotterydataset, clear
egen max_p=max(prize)
generate fraction= prize/max_p
quietly generate cut1 = 23/max_p if fraction<=23/max_p
quietly replace cut1 = 80/max_p if fraction>23/max_p & fraction<=80/max_p
quietly replace cut1 = 485/max_p if fraction >80/max_p
mat def tp1 = (0.10\0.20\0.30\0.40\0.50\0.60\0.70\0.80)
#delimit ;
glmdose male ownhs owncoll tixbot workthen yearw yearm1 yearm2,
t(fraction) gpscore(gps_flog) predict(y_hat_fl) sigma(sd_fl) 
cutpoints(cut1) index(mean) nq_gps(5) family(binomial) link(logit) 
outcome(year6) dose_response(doseresp_fl) tpoints(tp1) delta(0.1)
reg_type_t(quadratic) reg_type_gps(quadratic) interaction(1)
bootstrap(yes) boot_reps(10) analysis(yes) detail
filename("output_flog") graph("graphflog.eps") 
;
#delimit cr
log close, replace

drop gps_flog
drop y_hat_fl
drop sd_fl
drop doseresp_fl
drop doseresp_fl_plus
d, short
local N = r(N)
save junk, replace
append using junk
generate orig = _n<=`N'

#delimit ;
glmdose male ownhs owncoll tixbot workthen yearw yearm1 yearm2,
t(fraction) gpscore(gps_flog) predict(y_hat_fl) sigma(sd_fl) 
cutpoints(cut1) index(mean) nq_gps(5) family(binomial) link(logit) 
outcome(year6) dose_response(doseresp_fl) tpoints(tp1) delta(0.1) 
reg_type_t(quadratic) reg_type_gps(quadratic) interaction(1)
bootstrap(yes) boot_reps(10) analysis(yes) 
filename("output_proof") graph("graphproof.eps") detail,
if orig
;
#delimit cr


*************************************************************
*************************************************************
*************************************************************
