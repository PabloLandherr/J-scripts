
require 'dates'

setrnd=: 3 : 0
9!:1 */>:5{.6!:0 ''
)

weeklyfreq=: 3 : 0
105%>:(todayno 3{.6!:0 '')-todayno y
)

round=: 4 : 0
x*<.0.5+y%x
)

etabudget=: 3 : 0
(3{.6!:0 '') etabudget y
:
todate >.s+(530%y)*(todayno x)-s=. todayno 2011 1 1
)

yearstat=: 3 : 0
180 yearstat y
NB. 2019G: 180
NB. 2018: 200 2017: 192 2016: 198 2015: 173 2014: 178 
NB. 2013: 171 2012: 177 2011: 177 2010: 177 2009: 182
:
days=. (todayno 3{.6!:0 '')-todayno (<:1{.6!:0 ''),12 31
goal=. x%cy=. >:(todayno ({.6!:0 ''),12 31)-todayno ({.6!:0 ''),1 1
r=. ('Weekly freq: ',0j2":t=. y%days%7)
r=. r,(' Per day: ',0j2":p=. y%days),LF
r=. r,('Over/under: ',0j0":y-x*days%cy),LF
r=. r,('Forecast full year: ',0j0":y*cy%days)
r=. r,(', and ',(":x),' to be reached ',":todate (todayno (<:1{.6!:0 ''),12 31)+>.days*x%y),LF
if. y>:x do. r=. r,'Goal reached.' else.
  r=. r,'Remaining pace per day and week to reach ',(":x),': ',(0j2":f=. 1 7*(x-y)%cy-days),LF
  r=. '_-' replace~ r,'Rate change: ',(":<.0.5+100*1-~p%~{.f),' %'
end.
)

interv=: 4 : 0
({.y)+(--/y)*x%~i.>:x NB. 5 interv 7 15
)

prob206=: 3 : 0
'1234567890'-:(20$1 0)#20{.": y
)

alex=: 4 : 0 NB. skriver ut övningstabeller för multiplikation, t.ex. 15 alex >:i.5
NB. randomiserade rader och kolumner
whilst. 0~:x=. <:x do.
  y=. ((# ? #){])y
  print ((<' '),(<"0 y)),.(1 10$<"0>:10?10),((#y),10)$<'     '
end.
)

felix=: 4 : 0 NB. skriver ut övningstabeller för multiplikation, t.ex. 15 felix 10
NB. 15 stycken tabeller från 1 till 10
whilst. 0~:x=. <:x do.
  print ((<' '),(<"0 >:i.y)),.((1,y)$<"0>:i.y),(y,y)$<'     '
end.
)

alex2=: 4 : 0 NB. skriver ut övningstabeller för division, t.ex. 15 alex2 10
NB. 15 stycken tabeller från med nämnare och kvoter 1 till 10
kvot=. y#>:i.y
taljare=. kvot*namnare=. (*:y)$>:i.y
whilst. 0~:x=. <:x do.
  list=. <"1((# ? #){])(":,.taljare),.'/',.(":,.namnare),"1 ' =       '
  print ((>.4%~#list),4)$list
end.
)

replace=: 4 : 0
'p q'=. y
j=. p nosindx x
if. ''-:j do. x return. end.
d=. p-&#q
k=. (j+(0>.-d)*i.#j)+/i.#q
select. *d
case. 1 do. (0 (j+/(#q)+i.d)}1$~#x) # q k}x
case. 0 do. q k}x
case. _1 do. q k} (0 (d{."1 k)}1$~(#x)+(#j)*|d) #^:_1 x
end.
)

nosindx=: 4 : 0
s=. x I.@E. y
i=. s I. s+#x
(i.&_1 {. ]) (s,_1) {~ (i,_1) {~^:a: 0
)

loadnfldata=: 3 : 0
Data=: (9{a.),fread 'c:/users/pablo/documents/nfl/NFLdata.txt'
Data=: <;._1 (Data replace '-';'_') replace LF;TAB
Data=: (','&,)&.>Data
Data=: |:><;._1&.>Data
Data=: |: (0~:>#&.>0{Data)#|:Data NB. remove rows with empty data
Season=: ,".>0{Data
Date=: ,".>1{Data
Year=: ,<.Date%1e4
Month=: ,100|<.Date%1e2
Day=: ,100|Date
Weekday=: >2{Data
Week=: ,".>3{Data
Team=: >4{Data
Opponent=: >5{Data
Venue=: >6{Data NB. home/away
Line=: ,".>7{Data
Total=: ,".>8{Data
PM=: ,".>9{Data
PA=: ,".>}:&.>10{Data NB. to drop unwanted last char
NB. pre-calculated numbers
Won=: 0<PM-PA
Lost=: 0>PM-PA
Tied=: 0=PM-PA
Away=: -.Home=: 'home' rm Venue
OverL=: Line<PA-PM
UnderL=: Line>PA-PM
AtL=: Line=PA-PM
OverT=: Total<PM+PA
UnderT=: Total>PM+PA
AtT=: Total=PM+PA
(":-:{.$Data=: |:Data),' games loaded'
)

label=: 3 : 0
('Season';'Date';'Day';'Week';'Team';'Opponent';'Venue';'Line';'Total';'PM';'PA'),y
)

sumtable=: 4 : 0 NB. data table rows;cols
rows=.~.>0{y
cols=.~.>1{y
z=.>.(#x)%(#rows)*#cols
r=.+/(z,(#rows),#cols)$(*/z,(#rows),#cols){.x
r=.(0,cols),rows,.r
)

rm=: 4 : 0 NB. RowMatch  row in matrix e.g. 'home' rm Venue
x-:"1 (#x){."1 y
)

for=: 4 : 0
y#x
)

count=: 4 : 0 NB. PM count /:~ ~. PM
y,.+/x =/ y
)

homefield=: 3 : 0 NB. homefield 'Fortyniners' rm Team
(medel PM for y *. Home)-medel PM for y *. -.Home
)

winpercent=: 3 : 0 NB. winpercent 'Fortyniners' rm Team
(+/y *. Won)%+/y
)

maxix=: 3 : 0
y=>./y
)

minix=: 3 : 0
y=<./y
)

freq=: 4 : 0
max=. >./y
min=. <./y
f=. min+(i. x)*(max-min)%x
f count~(<:+/f<:/y){f
)

winprob=: 3 : 0 NB. y is line, negative means favored
%>:^y%7
:
%>:^y%x
)

countif=: 4 : 0 NB. Season countif PM>50
x count /:~~.x=. y#x
)

loadviktdata=: 3 : 0
Data=: fread 'c:/users/pablo/documents/viktx.csv'
Data=: ,;._2 Data replace CR;' '
Datum=:". 8{."1 Data
rawVikt=:Vikt=:".8}."1 Data
rawDatum=:Datum=:todayno 0 100 100#:(Vikt>0)#Datum
Vikt=:(Vikt>0)#Vikt
Nydatum=.expviktdatum Datum
Vikt=:fill Vikt (Nydatum i. Datum)}Nyvikt=.(#Nydatum)$0
Datum=:Nydatum
Dag=:weekday todate Datum
nix=.+/ix=.(+./\1=Dag)*.|.+./\|.0=Dag
shape=.(nix%7),7
tDatum=:shape$ix#Datum
tVikt=:shape$ix#Vikt
#Vikt
)

expviktdatum=: 3 : 0
(<./y)+i. >:(>./y)-<./y
)

fill=: 3 : 0 ^: (*@#) NB. fill gaps of zeroes
 b=. 1 (0 _1)} 0~:y
 x=. b#y
 n=. 2 -~/\ I. b
 ({:x) ,~ (n#}:x) + ; (i.&.>n) *&.> n %~ 2 -~/\ x
)

Weekday=: 'Sunday';'Monday';'Tuesday';'Wednesday';'Thursday';'Friday';'Saturday'

foreachday=: 3 : 0
r=. 0 1$' '
day=. 0
while. day<7 do.
r=. r,(10{.>day{Weekday),":".y,' Vikt for Dag=',":day
day=.>:day
end.
r
)

statrpt=: 4 : 0 NB. x is data, y is key
data=. y</. x
r=.   ,.'Key';(<"0 ~.y),<'All'
col=. #&.>data
r=.   r,.'#';col,<+/>col
col=. <./&.>data
r=.   r,.'Min';col,<<./>col
col=. >./&.>data
r=.   r,.'Max';col,<>./>col
r=.   r,.'Range';<"0 (>1}.3{|:r)-(>1}.2{|:r)
col=. medel&.>data
r=.   r,.'Avg';col,<medel;data
col=. sigma&.>data
r=.   r,.'Std';col,<sigma;data
r=.   (1{.r),(/:~_1}.1}.r),_1{.r
)

getcolrpt=: 4 : 0 NB. x is col, y is result from statrpt
>_1}.1}.x{"(1) y
)

bucketcnt=: 4 : 0 NB. x is either no of buckets or wanted buckets, y is data
 y=./:~y
 if. 1=#x do. cutoff=. _1}.x interv (<./y),>./y else. cutoff=.x end.
 cutoff,.>#&.>(+/cutoff <:/ y)</. y
)

isdiv=: 3 : 0
c=.>:i.<.-:y
c#~(] =<.)y%c
)

commondiv=: 4 : 0
dx=.isdiv x
dy=.isdiv y
(dx-.dy);((dx e. dy)#dx);dy-.dx
)

remz=: 3 : 0 NB. remove leading and trailing zeroes
r=. y#~+./\0~:y
r#~|.+./\0~:|.r
)


rjoin=: 4 : 0 NB. plot Vikt rjoin 30 mavg Vikt
x=.remz ,x
y=.remz ,y
l=.-(#x)<.#y
(l{.x),:l{.y
)

monthkey=: 3 : 0 NB. Vikt statrpt monthkey Datum
0 100#.2{."1 todate y
)