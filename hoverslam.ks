// set ship to known state
clearscreen.
SAS off.
print "initializing" at (5,4).
wait 1.
SAS on.
rcs off.
gear off.
brakes off.

// set parameters for landing
set vLand to -4.
set runmode to 1.
set thrust to ship:maxthrust.
set counter to 0. // to check if landed

// gravity calculator
function gravity_calculator {
  declare local GM to ship:body:mu.
  declare local R to ship:body:radius.
  declare local g to GM/(R^2).
  return -g.
}.

// suicide burn calculator
function suicide_burn_calculator {
  declare local shipmass to ship:mass.
  declare local vd to ship:verticalspeed.
  declare local va to ((thrust/shipmass) + gravity_calculator().
  declare local A to (vd^2)/(2*va).
  return 1.1 * A.
}.


// loops until landed
until runmode = 0 {
  // find ship parameters
  set h to alt:radar.
  set vd to ship:verticalspeed.
  set g to -gravity_calculator().
  
  // calculates values for landing
  set TimeToBurn to ((suicide_burn_calculator()-h)/vd).
  set ZeroAccelThrust to ((ship:mass * g)/thrust).
  
  // setup for high atmosphere
  if runmode = 1 {
    set TVAL to 0.
    if h > 5000 {
    lock steering to retrograde.
    }
    if h < 50000 {
    brakes on.
    lock steering to srfretrograde // surface retrograde
    set runmode to 2.
    }
  }
  
  // suicide burn start with 10% margin for error and velocity because it takes time for maximum thrust to be reached
  if runmode = 2 {
    if h < 1.1 * (suicide_burn_calculator() -vd) {
      set TVAL to 1.
      RCS on.
    }
    else {
      set TVAL to 0.
    }
    if h/-vd < 2 {
      gear on. 
      brakes off.
    }
    if vd > -6 {
      lock steering to up.
      set runmode to 3.
    }
  }
  
  // suicide burn final appproach
  if runmode = 3 {
    set vDiff to (vLand - vd).
    if vdiff > 0 {
      set TVAL to ( ZeroAccelThrust + 0.1).
    }
    
    if vDiff < 0 {
      set TVAL to (ZeroAccelThrust - 0.1).
    }
    
    if vd > -0.1 and h < 100 {
      set counter to counter + 1.
    }
    
    if counter > 5 {
       set runmode to 0.
    }
    wait 0.1.
  }
  
  lock throttle to TVAL.
  
  // parameters to display
  print "vertical velocity:       " +vd+ "      " at (5,4).
  print " Required Burn height:   " + suicide_burn_calculator + "     " at (5,5).
  print " Time to Required Burn:  " + TimeToBurn + "    " at (5,6).
  print " Runmode:                " + runmode + "      " at (5,7).
}

if runmode = 0 {
  set TVAL to 0.
  clearscreen.
  print "Landing Complete at (5,4).
  wait 1. //wait to make sure throttle = 0
}





