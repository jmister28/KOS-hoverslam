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
}

// suicide burn calculator
function suicide_burn_calculator {
  declare local shipmass to ship:mass.
  declare local vd to ship:verticalspeed.
  declare local va to ((thrust/shipmass) + gravity_calculator().
  declare local A to (vd^2)/(2*va).
  return 1.1 * A.
}

