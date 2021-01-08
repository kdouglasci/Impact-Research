*! version 1 -- 5/29/09 -- pbe
program define chi2power
  version 9.0
  syntax [, Startf(real 1.0) Endf(real 0) Incr(real 1.0) Alpha(real .05) ]
  
  /****************************************************/
  /*  chi-square power analysis                       */
  /*  first run tab var1 var2, row lrchi2             */
  /*  or        tabi 28 39 \ 34 20, row lrchi2        */
  /*  startf() - starting factor for sample size      */
  /*  endf()   - ending factor for sample size        */
  /*  inc()    - increment in factor for sample size  */
  /*  alpha()  - alpha level                          */
  /****************************************************/
  
  display
  
  if "`r(chi2_lr)'"=="" {
    display as err "likelihood-ratio chi2 missing"
    exit
  }
  
  /* power of observed chi-square */
  local noncent = r(chi2_lr)
  local df=(r(c)-1)*(r(r)-1)
  local bign=r(N)
  local cval=invchi2(`df',1-`alpha')

  if `endf'==0 {
    local endf=`startf'
  }
  
  local endf=`endf'+`incr'*.1  /* kluge adjustmanet */
  display as txt "alpha = " as res `alpha'
  forvalues i=`startf'(`incr')`endf' {
    /* power with larger sample size */
    local newnoncent = `i'*`noncent'
    display as txt "sample size factor = " as res %4.2f `i' as txt " power = " ///
    as res %6.4f (1-nchi2(`df',`newnoncent',`cval')) as txt " for n = " as res `i'*`bign'
  }
end

