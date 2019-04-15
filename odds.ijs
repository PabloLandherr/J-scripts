NB. New section for other related calculations
keno=: 4 : 0
'tot corr'=: x NB. Total nos, no of correct nos
'pick hit'=: y NB. Total picked nos, no of required correct nos
t=:(corr-i.hit),(tot-corr)-i.pick-hit
n=:tot-i.pick
t*/ .%n
)

NB. Section 0
require 'plot'
combodds=: 4 : 0
  m=. -: x+&return y
  (x,&#y)$m setodds ,%x*/y
)
invodds=: 3 : '%+/"1(-i)+%i+y*"1 -.i=.id y'
id=: =@i.@#
return=: %@(+/)@:%
margin=: [: 1&- return
vig=: %@>:@margin
cart=:1.6 3.5 6 13 15 16 21 26 26 41 51 51 NB. test data

NB. Section 1
setodds=: [ * [: % ] % [: +/ ]
damp=: 4 : 'y<.((0{x)*^.y)+(1{x)*y^(2{x)-(3{x)*y'
std_damp=: 0.1 0.82 1.1 0.0025 NB. gives maxvalue of 42.77 at damp 82
std_damp=: 0.1 1    1   0.0013 NB. max 57.60 at 131
adjodds=: [: 1&>. [: std_damp&damp 131&<.
setmargin=: 0.04&*  NB. two outcomes -> 8 %, four outcomes -> 16 %, etc
setreturn=: [: % [: >: setmargin

NB. Section 2
simulation=: 4 : 0
  stakes=. y NB. "initial" stakes when starting
  Bets=: 0#Odds=: ,: 0.1 round _0.05+adjodds (r=. setreturn #stakes) setodds stakes
  Bets=: ,: robot~ 0{Odds
  for. i. <:x do.
    Odds=:Odds,0.1 round _0.05+(0>.LP-LPdecay*<:#Bets) filter adjodds r setodds 0.1>.+/(-W){.BP lp (SW normal stakes),Bets
    Bets=:Bets,(_2{Odds) robot _1{Odds
  end.
  +/Bets
)
BP=: 0 0 NB. breakpoints as follows: 0{ use only seeds 1{ use only placed bets
LP=: 0 NB. weight of previous odds
LPdecay=: 0 NB. reduction of LP over time
SW=: 1 NB. stake weight to normal
Run=: 5 NB. Input to tactic RT=4
RT=: 0 NB. governs robot behaviour
Truth=: 1 NB. Input to tactic RT=6
W=: 1000 NB. window size, i.e. how far back do we look
robot=: 4 : 0  NB. change RT for different tactics
  NB. x is last odds, y is current odds
  select. RT
  case. 0 do. 'Set RT!'=.RT
  case. 1 do. </\max y NB. bet on highest odds
  case. 2 do. </\max y%x NB. bet on highest increase
  case. 3 do. (?#y)=i.#y NB. random bet
  case. 4 do. </\(-Run<:>./i)|. max i=.+/*/\|.Bets NB. run or shift
  case. 5 do. </\y=y NB. bet on 'leftmost' outcome all the time
  case. 6 do. </\max y%Truth NB. bet on 'best' bet compared to 'Truth'
end.
)
runningresult=: 4 : '>(<\x) ([: +/ *)&.> (<\y)'
max=: ] = >./
plot1=: 4 : 0 NB. (no. of rounds) plot1 (stakes)
  x simulation y
  plot (>:i. x),|: Bets runningresult Odds
)
plot2=: 4 : 'plot (>:i. #x),|: x runningresult y'
filter=: 4 : 'y<.(x*_1{Odds)+(-.x)*y' NB. "y<." filter dampens only odds _increases_
lp=: 4 : 0 NB. x is breakpoint 1 and 2, y is bets
  f=.0>.1<.((n=.#y)-0{x)%--/x
  y*(1-f),}.n#f
  if. x-:0 0 do. y end.
)
round=: [ * [: <. [: 0.5&+ %~      NB. x. is precision
setstakes=: 4 : '([ % +/)(x%%+/%y)*%y' NB. x. is return y. are initial odds
normal=: [ * [: (] % +/) ] NB. (SW) normal (stakes)

NB. Section 3
min=: ] = <./
resultanalysis=: 4 : '(>./ , variance)(+/x*y)%#x' NB. worst result (in %) and variance
majorsim=: 3 : 0 NB. Set MSvar, then majorsim y=.no. of rounds in each simulation
  MS=:(>#&.>MSvar)$a: NB. Initialize result matrix
  for_j. i.*/$MS do.
    ix=:($MS)#:j
    'LP LPdecay stakes RT Truth SW W'=:ix{&.>MSvar
    y simulation stakes
    MS=:(<+/Bets*Odds) (<ix)}MS
    if. 0=10|j do. (":j) 1!:2 ] 2 end.
  end.
*/$MS
)
minisim=: 4 : 0 NB. (no. of rounds) minisim (index into ,MS)
  'LP LPdecay stakes RT Truth SW W'=:((>#&.>MSvar)#:y){&.>MSvar
  x simulation stakes
)
showonesim=: 4 : 0
  x minisim y
  Bets plot2 Odds
)
reportvars=: 3 : 0
  if. y=_1 do.
    'a b c d e f g'=.LP;LPdecay;0;RT;Truth;SW;W
  else.
    'a b c d e f g'=.((>#&.>MSvar)#:y){&.>MSvar
  end.
  r=.'LP      = ',":a
  r=.r,:'LPdecay = ',":b
  r=.r,'stakes  = ',":c
  r=.r,'RT      = ',":d
  r=.r,'Truth   = ',":e
  r=.r,'SW      = ',":f
  r=.r,'W       = ',":g
)
small=:(setreturn 3) setodds 4 2 1
large=:(setreturn 12) setodds |.*/\12$1.5
BYT=: 4 : 0                    NB. 'ynYN' BYT 'yes'
  a1=. (-:#x){.x
  a2=. (-:#x)}.x
  ((a1,a.)&i.{(a2,a.)"_)y     NB. phrase from R Hui
)
variance=: avg@:*:@:-"1 avg
avg=: +/ % #
export=: 4 : 0
  x minisim y
  wdclipwrite (,(reportvars y),"1 CRLF),'.,' BYT clipfmt (>:i. x),. Bets runningresult Odds
)
findextreme=: 3 : 0 NB. findextreme ,MS
  ((min # i.@#);(max # i.@#)) >>./&.>y
)
MSix=: 4 : 0 NB. (which var) MSix (MSvar)
  odo=.>#&.>y
  (i.x{odo)(<"1 (i.x{odo),.x)}(x{odo)#,:<:odo
)
NB. MSvar=: 0 0.3 0.6 0.9;0 0.03 0.06 0.1;(3 3$4 2 1,2 2 2,1 2 4);6;(,:1.5 3 6);1 10 50;10 50 500
breakeven=: 4 : 0 NB. Bets breakeven Odds
  (#x)-+/*./\|.(>:i.#x)>>./|:x runningresult y
)
Kelly_crit=: 4 : 0 NB. Kelly Criterion
NB. x is odds offered
NB. y is probability of winning
NB. r is fraction of bankroll to wager
NB. Odds 2 given, 60 % percent chance gives 0.2, i.e. bet 20 % of bankroll
(<:x)%~(y*<:x)--.y
)