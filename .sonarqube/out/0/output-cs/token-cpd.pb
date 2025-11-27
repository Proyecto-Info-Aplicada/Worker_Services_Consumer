ãE
nC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Worker.cs
	namespace 	$
Worker_Services_Consumer
 "
{ 
public 

class 
Worker 
: 
BackgroundService +
{ 
private		 
readonly		 
ILogger		  
<		  !
Worker		! '
>		' (
_logger		) 0
;		0 1
private

 
readonly

 !
IKafkaConsumerService

 .
_kafkaConsumer

/ =
;

= >
private 
readonly 
IDatabaseService )
_databaseService* :
;: ;
private 
readonly 
WorkerSettings '
_workerSettings( 7
;7 8
private 
int #
_totalMessagesProcessed +
=, -
$num. /
;/ 0
public 
Worker 
( 
ILogger 
< 
Worker 
> 
logger "
," #!
IKafkaConsumerService !
kafkaConsumer" /
,/ 0
IDatabaseService 
databaseService ,
,, -
IOptions 
< 
WorkerSettings #
># $
workerSettings% 3
)3 4
{ 	
_logger 
= 
logger 
; 
_kafkaConsumer 
= 
kafkaConsumer *
;* +
_databaseService 
= 
databaseService .
;. /
_workerSettings 
= 
workerSettings ,
., -
Value- 2
;2 3
} 	
public 
override 
async 
Task "

StartAsync# -
(- .
CancellationToken. ?
cancellationToken@ Q
)Q R
{ 	
_logger 
. 
LogInformation "
(" #
$str# K
)K L
;L M
_logger 
. 
LogInformation "
(" #
$str# N
,N O
_workerSettingsP _
._ `&
ConsumptionIntervalSeconds` z
)z {
;{ |
await   
base   
.   

StartAsync   !
(  ! "
cancellationToken  " 3
)  3 4
;  4 5
}!! 	
	protected## 
override## 
async##  
Task##! %
ExecuteAsync##& 2
(##2 3
CancellationToken##3 D
stoppingToken##E R
)##R S
{$$ 	
_logger%% 
.%% 
LogInformation%% "
(%%" #
$str%%# `
)%%` a
;%%a b
try'' 
{(( 
await)) 
_databaseService)) &
.))& '#
InitializeDatabaseAsync))' >
())> ?
)))? @
;))@ A
_logger** 
.** 
LogInformation** &
(**& '
$str**' Q
)**Q R
;**R S
}++ 
catch,, 
(,, 
	Exception,, 
ex,, 
),,  
{-- 
_logger.. 
... 
LogError..  
(..  !
ex..! #
,..# $
$str..% 
)	.. Ä
;
..Ä Å
}// 
while11 
(11 
!11 
stoppingToken11 !
.11! "#
IsCancellationRequested11" 9
)119 :
{22 
try33 
{44 
var55 
	startTime55 !
=55" #
DateTime55$ ,
.55, -
UtcNow55- 3
;553 4
_logger66 
.66 
LogInformation66 *
(66* +
$str66+ O
,66O P
	startTime66Q Z
.66Z [
ToLocalTime66[ f
(66f g
)66g h
)66h i
;66i j
var88 
messages88  
=88! "
await88# (
_kafkaConsumer88) 7
.887 8 
ConsumeMessagesAsync888 L
(88L M
stoppingToken88M Z
)88Z [
;88[ \
if:: 
(:: 
messages::  
.::  !
Any::! $
(::$ %
)::% &
)::& '
{;; 
_logger<< 
.<<  
LogInformation<<  .
(<<. /
$str<</ T
,<<T U
messages<<V ^
.<<^ _
Count<<_ d
)<<d e
;<<e f
await>> 
_databaseService>> .
.>>. / 
SaveLogMessagesAsync>>/ C
(>>C D
messages>>D L
)>>L M
;>>M N#
_totalMessagesProcessed@@ /
+=@@0 2
messages@@3 ;
.@@; <
Count@@< A
;@@A B
varBB 
topicGroupsBB '
=BB( )
messagesBB* 2
.BB2 3
GroupByBB3 :
(BB: ;
mBB; <
=>BB= ?
mBB@ A
.BBA B
TopicBBB G
)BBG H
;BBH I
foreachCC 
(CC  !
varCC! $
groupCC% *
inCC+ -
topicGroupsCC. 9
)CC9 :
{DD 
_loggerEE #
.EE# $
LogInformationEE$ 2
(EE2 3
$strEE3 [
,EE[ \
groupEE] b
.EEb c
KeyEEc f
,EEf g
groupEEh m
.EEm n
CountEEn s
(EEs t
)EEt u
)EEu v
;EEv w
}FF 
varHH 
	totalInDbHH %
=HH& '
awaitHH( -
_databaseServiceHH. >
.HH> ?&
GetTotalMessagesCountAsyncHH? Y
(HHY Z
)HHZ [
;HH[ \
_loggerII 
.II  
LogInformationII  .
(II. /
$strII/ T
,IIT U
	totalInDbIIV _
)II_ `
;II` a
_loggerJJ 
.JJ  
LogInformationJJ  .
(JJ. /
$strJJ/ _
,JJ_ `#
_totalMessagesProcessedJJa x
)JJx y
;JJy z
}KK 
elseLL 
{MM 
_loggerNN 
.NN  
LogInformationNN  .
(NN. /
$strNN/ W
)NNW X
;NNX Y
}OO 
varQQ 
endTimeQQ 
=QQ  !
DateTimeQQ" *
.QQ* +
UtcNowQQ+ 1
;QQ1 2
varRR 
durationRR  
=RR! "
(RR# $
endTimeRR$ +
-RR, -
	startTimeRR. 7
)RR7 8
.RR8 9
TotalMillisecondsRR9 J
;RRJ K
_loggerSS 
.SS 
LogInformationSS *
(SS* +
$strSS+ P
,SSP Q
durationSSR Z
)SSZ [
;SS[ \
_loggerTT 
.TT 
LogInformationTT *
(TT* +
$strTT+ Z
)TTZ [
;TT[ \
awaitVV 
TaskVV 
.VV 
DelayVV $
(VV$ %
TimeSpanVV% -
.VV- .
FromSecondsVV. 9
(VV9 :
$numVV: ;
)VV; <
,VV< =
stoppingTokenVV> K
)VVK L
;VVL M
}WW 
catchXX 
(XX &
OperationCanceledExceptionXX 1
)XX1 2
{YY 
_loggerZZ 
.ZZ 
LogInformationZZ *
(ZZ* +
$strZZ+ V
)ZZV W
;ZZW X
break[[ 
;[[ 
}\\ 
catch]] 
(]] 
	Exception]]  
ex]]! #
)]]# $
{^^ 
_logger__ 
.__ 
LogError__ $
(__$ %
ex__% '
,__' (
$str__) U
)__U V
;__V W
_logger`` 
.`` 
LogInformation`` *
(``* +
$str``+ X
)``X Y
;``Y Z
awaitaa 
Taskaa 
.aa 
Delayaa $
(aa$ %
TimeSpanaa% -
.aa- .
FromSecondsaa. 9
(aa9 :
$numaa: ;
)aa; <
,aa< =
stoppingTokenaa> K
)aaK L
;aaL M
}bb 
}cc 
}dd 	
publicff 
overrideff 
asyncff 
Taskff "
	StopAsyncff# ,
(ff, -
CancellationTokenff- >
cancellationTokenff? P
)ffP Q
{gg 	
_loggerhh 
.hh 
LogInformationhh "
(hh" #
$strhh# K
)hhK L
;hhL M
_loggerii 
.ii 
LogInformationii "
(ii" #
$strii# J
,iiJ K#
_totalMessagesProcessediiL c
)iic d
;iid e
awaitkk 
basekk 
.kk 
	StopAsynckk  
(kk  !
cancellationTokenkk! 2
)kk2 3
;kk3 4
}ll 	
}mm 
}nn ‰A
|C:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Services\ServiceBase.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Services# +
{ 
public 

abstract 
class 
ServiceBase %
{ 
	protected 
readonly 
ILogger "
_logger# *
;* +
	protected 
ServiceBase 
( 
ILogger %
logger& ,
), -
{ 	
_logger		 
=		 
logger		 
;		 
}

 	
	protected 
void 
LogError 
(  
	Exception  )
ex* ,
,, -
string. 4
message5 <
,< =
params> D
objectE K
[K L
]L M
argsN R
)R S
{ 	
_logger 
. 
LogError 
( 
ex 
,  
message! (
,( )
args* .
). /
;/ 0
} 	
	protected 
void 
LogInformation %
(% &
string& ,
message- 4
,4 5
params6 <
object= C
[C D
]D E
argsF J
)J K
{ 	
_logger 
. 
LogInformation "
(" #
message# *
,* +
args, 0
)0 1
;1 2
} 	
	protected 
void 

LogWarning !
(! "
	Exception" +
?+ ,
ex- /
,/ 0
string1 7
message8 ?
,? @
paramsA G
objectH N
[N O
]O P
argsQ U
)U V
{ 	
if 
( 
ex 
!= 
null 
) 
_logger 
. 

LogWarning "
(" #
ex# %
,% &
message' .
,. /
args0 4
)4 5
;5 6
else 
_logger 
. 

LogWarning "
(" #
message# *
,* +
args, 0
)0 1
;1 2
} 	
	protected 
async 
Task 
< 
T 
> )
ExecuteWithErrorHandlingAsync  =
<= >
T> ?
>? @
(@ A
Func 
< 
Task 
< 
T 
> 
> 
	operation #
,# $
string   
operationName    
,    !
T!! 
?!! 
defaultValue!! 
=!! 
default!! %
)!!% &
{"" 	
try## 
{$$ 
return%% 
await%% 
	operation%% &
(%%& '
)%%' (
;%%( )
}&& 
catch'' 
('' 
	Exception'' 
ex'' 
)''  
{(( 
LogError)) 
()) 
ex)) 
,)) 
$str)) B
,))B C
operationName))D Q
)))Q R
;))R S
if++ 
(++ 
defaultValue++  
!=++! #
null++$ (
)++( )
return,, 
defaultValue,, '
;,,' (
throw.. 
;.. 
}// 
}00 	
	protected22 
async22 
Task22 )
ExecuteWithErrorHandlingAsync22 :
(22: ;
Func33 
<33 
Task33 
>33 
	operation33  
,33  !
string44 
operationName44  
,44  !
bool55 
suppressException55 "
=55# $
false55% *
)55* +
{66 	
try77 
{88 
await99 
	operation99 
(99  
)99  !
;99! "
}:: 
catch;; 
(;; 
	Exception;; 
ex;; 
);;  
{<< 
LogError== 
(== 
ex== 
,== 
$str== B
,==B C
operationName==D Q
)==Q R
;==R S
if?? 
(?? 
!?? 
suppressException?? &
)??& '
throw@@ 
;@@ 
}AA 
}BB 	
	protectedDD 
TDD $
ExecuteWithErrorHandlingDD ,
<DD, -
TDD- .
>DD. /
(DD/ 0
FuncEE 
<EE 
TEE 
>EE 
	operationEE 
,EE 
stringFF 
operationNameFF  
,FF  !
TGG 
?GG 
defaultValueGG 
=GG 
defaultGG %
)GG% &
{HH 	
tryII 
{JJ 
returnKK 
	operationKK  
(KK  !
)KK! "
;KK" #
}LL 
catchMM 
(MM 
	ExceptionMM 
exMM 
)MM  
{NN 
LogErrorOO 
(OO 
exOO 
,OO 
$strOO B
,OOB C
operationNameOOD Q
)OOQ R
;OOR S
ifQQ 
(QQ 
defaultValueQQ  
!=QQ! #
nullQQ$ (
)QQ( )
returnRR 
defaultValueRR '
;RR' (
throwTT 
;TT 
}UU 
}VV 	
	protectedXX 
voidXX $
ExecuteWithErrorHandlingXX /
(XX/ 0
ActionYY 
	operationYY 
,YY 
stringZZ 
operationNameZZ  
,ZZ  !
bool[[ 
suppressException[[ "
=[[# $
false[[% *
)[[* +
{\\ 	
try]] 
{^^ 
	operation__ 
(__ 
)__ 
;__ 
}`` 
catchaa 
(aa 
	Exceptionaa 
exaa 
)aa  
{bb 
LogErrorcc 
(cc 
excc 
,cc 
$strcc B
,ccB C
operationNameccD Q
)ccQ R
;ccR S
ifee 
(ee 
!ee 
suppressExceptionee &
)ee& '
throwff 
;ff 
}gg 
}hh 	
	protectedjj 
voidjj 
ValidateNotNulljj &
<jj& '
Tjj' (
>jj( )
(jj) *
Tjj* +
valuejj, 1
,jj1 2
stringjj3 9
parameterNamejj: G
)jjG H
wherejjI N
TjjO P
:jjQ R
classjjS X
{kk 	
ifll 
(ll 
valuell 
==ll 
nullll 
)ll 
{mm 
varnn 
exnn 
=nn 
newnn !
ArgumentNullExceptionnn 2
(nn2 3
parameterNamenn3 @
)nn@ A
;nnA B
LogErroroo 
(oo 
exoo 
,oo 
$stroo >
,oo> ?
parameterNameoo@ M
)ooM N
;ooN O
throwpp 
expp 
;pp 
}qq 
}rr 	
	protectedtt 
voidtt 
ValidateNotEmptytt '
<tt' (
Ttt( )
>tt) *
(tt* +
IEnumerablett+ 6
<tt6 7
Ttt7 8
>tt8 9

collectiontt: D
,ttD E
stringttF L
parameterNamettM Z
)ttZ [
{uu 	
ifvv 
(vv 

collectionvv 
==vv 
nullvv "
||vv# %
!vv& '

collectionvv' 1
.vv1 2
Anyvv2 5
(vv5 6
)vv6 7
)vv7 8
{ww 
varxx 
exxx 
=xx 
newxx 
ArgumentExceptionxx .
(xx. /
$"xx/ 1
$strxx1 ?
{xx? @
parameterNamexx@ M
}xxM N
$strxxN d
"xxd e
,xxe f
parameterNamexxg t
)xxt u
;xxu v
LogErroryy 
(yy 
exyy 
,yy 
$stryy ?
,yy? @
parameterNameyyA N
)yyN O
;yyO P
throwzz 
exzz 
;zz 
}{{ 
}|| 	
}}} 
}~~ ∂e
ÖC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Services\KafkaConsumerService.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Services# +
{ 
public		 

class		  
KafkaConsumerService		 %
:		& '
ServiceBase		( 3
,		3 4!
IKafkaConsumerService		5 J
,		J K
IDisposable		L W
{

 
private 
readonly 
KafkaSettings &
_kafkaSettings' 5
;5 6
private 
readonly 
WorkerSettings '
_workerSettings( 7
;7 8
private 
readonly 
List 
< 
	IConsumer '
<' (
Ignore( .
,. /
string0 6
>6 7
>7 8

_consumers9 C
=D E
newF I
(I J
)J K
;K L
public  
KafkaConsumerService #
(# $
IOptions 
< 
KafkaSettings "
>" #
kafkaSettings$ 1
,1 2
IOptions 
< 
WorkerSettings #
># $
workerSettings% 3
,3 4
ILogger 
<  
KafkaConsumerService (
>( )
logger* 0
)0 1
: 
base 
( 
logger 
) 
{ 	
_kafkaSettings 
= 
kafkaSettings *
.* +
Value+ 0
;0 1
_workerSettings 
= 
workerSettings ,
., -
Value- 2
;2 3
InitializeConsumers 
(  
)  !
;! "
} 	
private 
void 
InitializeConsumers (
(( )
)) *
{ 	
var 
config 
= 
new 
ConsumerConfig +
{ 
BootstrapServers  
=! "
_kafkaSettings# 1
.1 2
BootstrapServers2 B
,B C
GroupId   
=   
_kafkaSettings   (
.  ( )
ConsumerGroup  ) 6
,  6 7
AutoOffsetReset!! 
=!!  !
Enum!!" &
.!!& '
Parse!!' ,
<!!, -
AutoOffsetReset!!- <
>!!< =
(!!= >
_kafkaSettings!!> L
.!!L M
AutoOffsetReset!!M \
)!!\ ]
,!!] ^
EnableAutoCommit""  
=""! "
_kafkaSettings""# 1
.""1 2
EnableAutoCommit""2 B
,""B C
SessionTimeoutMs##  
=##! "
_kafkaSettings### 1
.##1 2
SessionTimeoutMs##2 B
,##B C
MaxPollIntervalMs$$ !
=$$" #
_kafkaSettings$$$ 2
.$$2 3
MaxPollIntervalMs$$3 D
}%% 
;%% 
var'' 
topics'' 
='' 
new'' 
['' 
]'' 
{(( 
_kafkaSettings)) 
.)) 
RequestLogsTopic)) /
,))/ 0
_kafkaSettings** 
.** 
ErrorLogsTopic** -
,**- .
_kafkaSettings++ 
.++ 
EventLogsTopic++ -
},, 
;,, 
var.. 
consumer.. 
=.. 
new.. 
ConsumerBuilder.. .
<... /
Ignore../ 5
,..5 6
string..7 =
>..= >
(..> ?
config..? E
)..E F
.// 
SetErrorHandler//  
(//  !
(//! "
_//" #
,//# $
error//% *
)//* +
=>//, .
LogError00 
(00 
new00  
	Exception00! *
(00* +
error00+ 0
.000 1
Reason001 7
)007 8
,008 9
$str00: a
,00a b
error00c h
.00h i
Reason00i o
)00o p
)00p q
.11 
Build11 
(11 
)11 
;11 
consumer33 
.33 
	Subscribe33 
(33 
topics33 %
)33% &
;33& '

_consumers44 
.44 
Add44 
(44 
consumer44 #
)44# $
;44$ %
LogInformation66 
(66 
$str66 V
,66V W
topics66X ^
.66^ _
Length66_ e
)66e f
;66f g
foreach77 
(77 
var77 
topic77 
in77 !
topics77" (
)77( )
{88 
LogInformation99 
(99 
$str99 H
,99H I
topic99J O
)99O P
;99P Q
}:: 
};; 	
public== 
Task== 
<== 
List== 
<== 
Models== 
.==  

LogMessage==  *
>==* +
>==+ , 
ConsumeMessagesAsync==- A
(==A B
CancellationToken==B S
cancellationToken==T e
)==e f
{>> 	
var?? 
messages?? 
=?? 
new?? 
List?? #
<??# $
Models??$ *
.??* +

LogMessage??+ 5
>??5 6
(??6 7
)??7 8
;??8 9
foreachAA 
(AA 
varAA 
consumerAA !
inAA" $

_consumersAA% /
)AA/ 0
{BB 
boolCC 
hasMessagesCC  
=CC! "
trueCC# '
;CC' (
whileDD 
(DD 
hasMessagesDD "
&&DD# %
!DD& '
cancellationTokenDD' 8
.DD8 9#
IsCancellationRequestedDD9 P
)DDP Q
{EE 
tryFF 
{GG 
varHH 
consumeResultHH )
=HH* +
consumerHH, 4
.HH4 5
ConsumeHH5 <
(HH< =
TimeSpanHH= E
.HHE F
FromMillisecondsHHF V
(HHV W
$numHHW Z
)HHZ [
)HH[ \
;HH\ ]
ifJJ 
(JJ 
consumeResultJJ )
!=JJ* ,
nullJJ- 1
&&JJ2 4
!JJ5 6
consumeResultJJ6 C
.JJC D
IsPartitionEOFJJD R
)JJR S
{KK 
varLL 

logMessageLL  *
=LL+ ,
newLL- 0
ModelsLL1 7
.LL7 8

LogMessageLL8 B
{MM 
TopicNN  %
=NN& '
consumeResultNN( 5
.NN5 6
TopicNN6 ;
,NN; <
MessageOO  '
=OO( )
consumeResultOO* 7
.OO7 8
MessageOO8 ?
.OO? @
ValueOO@ E
,OOE F

ReceivedAtPP  *
=PP+ ,
DateTimePP- 5
.PP5 6
UtcNowPP6 <
,PP< =
HeadersQQ  '
=QQ( )
ExtractHeadersQQ* 8
(QQ8 9
consumeResultQQ9 F
.QQF G
MessageQQG N
.QQN O
HeadersQQO V
)QQV W
}RR 
;RR 
ifTT 
(TT  

logMessageTT  *
.TT* +
HeadersTT+ 2
.TT2 3
ContainsKeyTT3 >
(TT> ?
$strTT? N
)TTN O
)TTO P

logMessageUU  *
.UU* +
CorrelationIdUU+ 8
=UU9 :

logMessageUU; E
.UUE F
HeadersUUF M
[UUM N
$strUUN ]
]UU] ^
;UU^ _
ifWW 
(WW  

logMessageWW  *
.WW* +
HeadersWW+ 2
.WW2 3
ContainsKeyWW3 >
(WW> ?
$strWW? I
)WWI J
)WWJ K

logMessageXX  *
.XX* +
LogLevelXX+ 3
=XX4 5

logMessageXX6 @
.XX@ A
HeadersXXA H
[XXH I
$strXXI S
]XXS T
;XXT U
ifZZ 
(ZZ  

logMessageZZ  *
.ZZ* +
HeadersZZ+ 2
.ZZ2 3
ContainsKeyZZ3 >
(ZZ> ?
$strZZ? G
)ZZG H
)ZZH I

logMessage[[  *
.[[* +
Source[[+ 1
=[[2 3

logMessage[[4 >
.[[> ?
Headers[[? F
[[[F G
$str[[G O
][[O P
;[[P Q
messages]] $
.]]$ %
Add]]% (
(]]( )

logMessage]]) 3
)]]3 4
;]]4 5
LogInformation__ *
(__* +
$str``  q
,``q r
consumeResultaa  -
.aa- .
Topicaa. 3
,aa3 4
consumeResultbb  -
.bb- .
Offsetbb. 4
.bb4 5
Valuebb5 :
,bb: ;
consumeResultcc  -
.cc- .
	Partitioncc. 7
.cc7 8
Valuecc8 =
)cc= >
;cc> ?
ifee 
(ee  
!ee  !
_kafkaSettingsee! /
.ee/ 0
EnableAutoCommitee0 @
)ee@ A
{ff 
consumergg  (
.gg( )
Commitgg) /
(gg/ 0
consumeResultgg0 =
)gg= >
;gg> ?
}hh 
}ii 
elsejj 
{kk 
hasMessagesll '
=ll( )
falsell* /
;ll/ 0
}mm 
}nn 
catchoo 
(oo 
ConsumeExceptionoo +
exoo, .
)oo. /
{pp 
LogErrorqq  
(qq  !
exqq! #
,qq# $
$strqq% L
,qqL M
exqqN P
.qqP Q
ErrorqqQ V
.qqV W
ReasonqqW ]
)qq] ^
;qq^ _
hasMessagesrr #
=rr$ %
falserr& +
;rr+ ,
}ss 
catchtt 
(tt 
	Exceptiontt $
extt% '
)tt' (
{uu 
LogErrorvv  
(vv  !
exvv! #
,vv# $
$strvv% M
)vvM N
;vvN O
hasMessagesww #
=ww$ %
falseww& +
;ww+ ,
}xx 
}yy 
}zz 
return|| 
Task|| 
.|| 

FromResult|| "
(||" #
messages||# +
)||+ ,
;||, -
}}} 	
private 

Dictionary 
< 
string !
,! "
string# )
>) *
ExtractHeaders+ 9
(9 :
Headers: A
headersB I
)I J
{
ÄÄ 	
var
ÅÅ 

headerDict
ÅÅ 
=
ÅÅ 
new
ÅÅ  

Dictionary
ÅÅ! +
<
ÅÅ+ ,
string
ÅÅ, 2
,
ÅÅ2 3
string
ÅÅ4 :
>
ÅÅ: ;
(
ÅÅ; <
)
ÅÅ< =
;
ÅÅ= >
if
ÉÉ 
(
ÉÉ 
headers
ÉÉ 
!=
ÉÉ 
null
ÉÉ 
)
ÉÉ  
{
ÑÑ 
foreach
ÖÖ 
(
ÖÖ 
var
ÖÖ 
header
ÖÖ #
in
ÖÖ$ &
headers
ÖÖ' .
)
ÖÖ. /
{
ÜÜ 
try
áá 
{
àà 
var
ââ 
value
ââ !
=
ââ" #
Encoding
ââ$ ,
.
ââ, -
UTF8
ââ- 1
.
ââ1 2
	GetString
ââ2 ;
(
ââ; <
header
ââ< B
.
ââB C
GetValueBytes
ââC P
(
ââP Q
)
ââQ R
)
ââR S
;
ââS T

headerDict
ää "
[
ää" #
header
ää# )
.
ää) *
Key
ää* -
]
ää- .
=
ää/ 0
value
ää1 6
;
ää6 7
}
ãã 
catch
åå 
(
åå 
	Exception
åå $
ex
åå% '
)
åå' (
{
çç 

LogWarning
éé "
(
éé" #
ex
éé# %
,
éé% &
$str
éé' H
,
ééH I
header
ééJ P
.
ééP Q
Key
ééQ T
)
ééT U
;
ééU V
}
èè 
}
êê 
}
ëë 
return
ìì 

headerDict
ìì 
;
ìì 
}
îî 	
public
ññ 
void
ññ 
Dispose
ññ 
(
ññ 
)
ññ 
{
óó 	
foreach
òò 
(
òò 
var
òò 
consumer
òò !
in
òò" $

_consumers
òò% /
)
òò/ 0
{
ôô &
ExecuteWithErrorHandling
öö (
(
öö( )
(
öö) *
)
öö* +
=>
öö, .
{
õõ 
consumer
úú 
?
úú 
.
úú 
Close
úú #
(
úú# $
)
úú$ %
;
úú% &
consumer
ùù 
?
ùù 
.
ùù 
Dispose
ùù %
(
ùù% &
)
ùù& '
;
ùù' (
}
ûû 
,
ûû 
$str
ûû %
,
ûû% &
suppressException
ûû' 8
:
ûû8 9
true
ûû: >
)
ûû> ?
;
ûû? @
}
üü 

_consumers
°° 
.
°° 
Clear
°° 
(
°° 
)
°° 
;
°° 
}
¢¢ 	
}
££ 
}§§ ó
ÜC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Services\IKafkaConsumerService.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Services# +
{ 
public 

	interface !
IKafkaConsumerService *
{ 
Task 
< 
List 
< 
Models 
. 

LogMessage #
># $
>$ % 
ConsumeMessagesAsync& :
(: ;
CancellationToken; L
cancellationTokenM ^
)^ _
;_ `
} 
}		 û
ÅC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Services\IDatabaseService.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Services# +
{ 
public 

	interface 
IDatabaseService %
{ 
Task #
InitializeDatabaseAsync $
($ %
)% &
;& '
Task  
SaveLogMessagesAsync !
(! "
List" &
<& '

LogMessage' 1
>1 2
messages3 ;
); <
;< =
Task		 
<		 
int		 
>		 &
GetTotalMessagesCountAsync		 ,
(		, -
)		- .
;		. /
}

 
} çN
ÄC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Services\DatabaseService.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Services# +
{ 
public 

class 
DatabaseService  
:! "
ServiceBase# .
,. /
IDatabaseService0 @
{		 
private

 
readonly

 
string

 
_connectionString

  1
;

1 2
public 
DatabaseService 
( 
IConfiguration -
configuration. ;
,; <
ILogger= D
<D E
DatabaseServiceE T
>T U
loggerV \
)\ ]
: 
base 
( 
logger 
) 
{ 	
_connectionString 
= 
configuration  -
.- .
GetConnectionString. A
(A B
$strB U
)U V
?? 
throw 
new %
InvalidOperationException 6
(6 7
$str7 T
)T U
;U V
} 	
public 
async 
Task #
InitializeDatabaseAsync 1
(1 2
)2 3
{ 	
await )
ExecuteWithErrorHandlingAsync /
(/ 0
async0 5
(6 7
)7 8
=>9 ;
{ 
using 
var 

connection $
=% &
new' *
SqlConnection+ 8
(8 9
_connectionString9 J
)J K
;K L
await 

connection  
.  !
	OpenAsync! *
(* +
)+ ,
;, -
var "
createRequestLogsTable *
=+ ,
$str+- 
;++ 
var--  
createErrorLogsTable-- (
=--) *
$str->+ 
;>> 
var@@  
createEventLogsTable@@ (
=@@) *
$str@Q+ 
;QQ 
usingSS 
varSS 
command1SS "
=SS# $
newSS% (

SqlCommandSS) 3
(SS3 4"
createRequestLogsTableSS4 J
,SSJ K

connectionSSL V
)SSV W
;SSW X
awaitTT 
command1TT 
.TT  
ExecuteNonQueryAsyncTT 3
(TT3 4
)TT4 5
;TT5 6
usingVV 
varVV 
command2VV "
=VV# $
newVV% (

SqlCommandVV) 3
(VV3 4 
createErrorLogsTableVV4 H
,VVH I

connectionVVJ T
)VVT U
;VVU V
awaitWW 
command2WW 
.WW  
ExecuteNonQueryAsyncWW 3
(WW3 4
)WW4 5
;WW5 6
usingYY 
varYY 
command3YY "
=YY# $
newYY% (

SqlCommandYY) 3
(YY3 4 
createEventLogsTableYY4 H
,YYH I

connectionYYJ T
)YYT U
;YYU V
awaitZZ 
command3ZZ 
.ZZ  
ExecuteNonQueryAsyncZZ 3
(ZZ3 4
)ZZ4 5
;ZZ5 6
LogInformation\\ 
(\\ 
$str\\ I
)\\I J
;\\J K
}]] 
,]] 
$str]] (
)]]( )
;]]) *
}^^ 	
public`` 
async`` 
Task``  
SaveLogMessagesAsync`` .
(``. /
List``/ 3
<``3 4

LogMessage``4 >
>``> ?
messages``@ H
)``H I
{aa 	
ValidateNotEmptybb 
(bb 
messagesbb %
,bb% &
nameofbb' -
(bb- .
messagesbb. 6
)bb6 7
)bb7 8
;bb8 9
awaitdd )
ExecuteWithErrorHandlingAsyncdd /
(dd/ 0
asyncdd0 5
(dd6 7
)dd7 8
=>dd9 ;
{ee 
usingff 
varff 

connectionff $
=ff% &
newff' *
SqlConnectionff+ 8
(ff8 9
_connectionStringff9 J
)ffJ K
;ffK L
awaitgg 

connectiongg  
.gg  !
	OpenAsyncgg! *
(gg* +
)gg+ ,
;gg, -
foreachii 
(ii 
varii 
messageii $
inii% '
messagesii( 0
)ii0 1
{jj 
varkk 
	tableNamekk !
=kk" #
GetTableNameByTopickk$ 7
(kk7 8
messagekk8 ?
.kk? @
Topickk@ E
)kkE F
;kkF G
varll 
headersJsonll #
=ll$ %
JsonConvertll& 1
.ll1 2
SerializeObjectll2 A
(llA B
messagellB I
.llI J
HeadersllJ Q
)llQ R
;llR S
varnn 
insertQuerynn #
=nn$ %
$@"nn& )
$strno) $
{oo$ %
	tableNameoo% .
}oo. /
$stror/ s
"rrs t
;rrt u
usingtt 
vartt 
commandtt %
=tt& '
newtt( +

SqlCommandtt, 6
(tt6 7
insertQuerytt7 B
,ttB C

connectionttD N
)ttN O
;ttO P
commanduu 
.uu 

Parametersuu &
.uu& '
AddWithValueuu' 3
(uu3 4
$struu4 <
,uu< =
messageuu> E
.uuE F
TopicuuF K
)uuK L
;uuL M
commandvv 
.vv 

Parametersvv &
.vv& '
AddWithValuevv' 3
(vv3 4
$strvv4 >
,vv> ?
messagevv@ G
.vvG H
MessagevvH O
)vvO P
;vvP Q
commandww 
.ww 

Parametersww &
.ww& '
AddWithValueww' 3
(ww3 4
$strww4 A
,wwA B
messagewwC J
.wwJ K

ReceivedAtwwK U
)wwU V
;wwV W
commandxx 
.xx 

Parametersxx &
.xx& '
AddWithValuexx' 3
(xx3 4
$strxx4 D
,xxD E
(xxF G
objectxxG M
?xxM N
)xxN O
messagexxO V
.xxV W
CorrelationIdxxW d
??xxe g
DBNullxxh n
.xxn o
Valuexxo t
)xxt u
;xxu v
commandyy 
.yy 

Parametersyy &
.yy& '
AddWithValueyy' 3
(yy3 4
$stryy4 ?
,yy? @
(yyA B
objectyyB H
?yyH I
)yyI J
messageyyJ Q
.yyQ R
LogLevelyyR Z
??yy[ ]
DBNullyy^ d
.yyd e
Valueyye j
)yyj k
;yyk l
commandzz 
.zz 

Parameterszz &
.zz& '
AddWithValuezz' 3
(zz3 4
$strzz4 =
,zz= >
(zz? @
objectzz@ F
?zzF G
)zzG H
messagezzH O
.zzO P
SourcezzP V
??zzW Y
DBNullzzZ `
.zz` a
Valuezza f
)zzf g
;zzg h
command{{ 
.{{ 

Parameters{{ &
.{{& '
AddWithValue{{' 3
({{3 4
$str{{4 >
,{{> ?
headersJson{{@ K
){{K L
;{{L M
await}} 
command}} !
.}}! " 
ExecuteNonQueryAsync}}" 6
(}}6 7
)}}7 8
;}}8 9
}~~ 
LogInformation
ÄÄ 
(
ÄÄ 
$str
ÄÄ I
,
ÄÄI J
messages
ÄÄK S
.
ÄÄS T
Count
ÄÄT Y
)
ÄÄY Z
;
ÄÄZ [
}
ÅÅ 
,
ÅÅ 
$str
ÅÅ %
)
ÅÅ% &
;
ÅÅ& '
}
ÇÇ 	
public
ÑÑ 
async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
int
ÑÑ 
>
ÑÑ (
GetTotalMessagesCountAsync
ÑÑ 9
(
ÑÑ9 :
)
ÑÑ: ;
{
ÖÖ 	
return
ÜÜ 
await
ÜÜ +
ExecuteWithErrorHandlingAsync
ÜÜ 6
(
ÜÜ6 7
async
ÜÜ7 <
(
ÜÜ= >
)
ÜÜ> ?
=>
ÜÜ@ B
{
áá 
using
àà 
var
àà 

connection
àà $
=
àà% &
new
àà' *
SqlConnection
àà+ 8
(
àà8 9
_connectionString
àà9 J
)
ààJ K
;
ààK L
await
ââ 

connection
ââ  
.
ââ  !
	OpenAsync
ââ! *
(
ââ* +
)
ââ+ ,
;
ââ, -
var
ãã 
query
ãã 
=
ãã 
$str
ãè G
;
èèG H
using
ëë 
var
ëë 
command
ëë !
=
ëë" #
new
ëë$ '

SqlCommand
ëë( 2
(
ëë2 3
query
ëë3 8
,
ëë8 9

connection
ëë: D
)
ëëD E
;
ëëE F
var
íí 
result
íí 
=
íí 
await
íí "
command
íí# *
.
íí* + 
ExecuteScalarAsync
íí+ =
(
íí= >
)
íí> ?
;
íí? @
return
ìì 
Convert
ìì 
.
ìì 
ToInt32
ìì &
(
ìì& '
result
ìì' -
)
ìì- .
;
ìì. /
}
îî 
,
îî 
$str
îî +
,
îî+ ,
defaultValue
îî- 9
:
îî9 :
$num
îî; <
)
îî< =
;
îî= >
}
ïï 	
private
óó 
string
óó !
GetTableNameByTopic
óó *
(
óó* +
string
óó+ 1
topic
óó2 7
)
óó7 8
{
òò 	
return
ôô 
topic
ôô 
switch
ôô 
{
öö 
$str
õõ 
=>
õõ !
$str
õõ" /
,
õõ/ 0
$str
úú 
=>
úú 
$str
úú  +
,
úú+ ,
$str
ùù 
=>
ùù 
$str
ùù  +
,
ùù+ ,
_
ûû 
=>
ûû 
$str
ûû "
}
üü 
;
üü 
}
†† 	
}
°° 
}¢¢ ≠
oC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Program.cs
var 
builder 
= 
Host 
. $
CreateApplicationBuilder +
(+ ,
args, 0
)0 1
;1 2
builder 
. 
Services 
. 
	Configure 
< 
KafkaSettings (
>( )
() *
builder		 
.		 
Configuration		 
.		 

GetSection		 $
(		$ %
$str		% ,
)		, -
)		- .
;		. /
builder 
. 
Services 
. 
	Configure 
< 
WorkerSettings )
>) *
(* +
builder 
. 
Configuration 
. 

GetSection $
($ %
$str% 5
)5 6
)6 7
;7 8
builder 
. 
Services 
. 
AddSingleton 
< !
IKafkaConsumerService 3
,3 4 
KafkaConsumerService5 I
>I J
(J K
)K L
;L M
builder 
. 
Services 
. 
AddSingleton 
< 
IDatabaseService .
,. /
DatabaseService0 ?
>? @
(@ A
)A B
;B C
builder 
. 
Services 
. 
AddHostedService !
<! "
Worker" (
>( )
() *
)* +
;+ ,
builder 
. 
Logging 
. 
ClearProviders 
( 
)  
;  !
builder 
. 
Logging 
. 

AddConsole 
( 
) 
; 
builder 
. 
Logging 
. 
AddDebug 
( 
) 
; 
var 
host 
=	 

builder 
. 
Build 
( 
) 
; 
host 
. 
Run 
( 	
)	 

;
 ë
yC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Models\LogMessage.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Models# )
{ 
public 

class 

LogMessage 
{ 
public 
string 
Topic 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
public 
string 
Message 
{ 
get  #
;# $
set% (
;( )
}* +
=, -
string. 4
.4 5
Empty5 :
;: ;
public 
DateTime 

ReceivedAt "
{# $
get% (
;( )
set* -
;- .
}/ 0
public 
string 
? 
CorrelationId $
{% &
get' *
;* +
set, /
;/ 0
}1 2
public		 
string		 
?		 
LogLevel		 
{		  !
get		" %
;		% &
set		' *
;		* +
}		, -
public

 
string

 
?

 
Source

 
{

 
get

  #
;

# $
set

% (
;

( )
}

* +
public 

Dictionary 
< 
string  
,  !
string" (
>( )
Headers* 1
{2 3
get4 7
;7 8
set9 <
;< =
}> ?
=@ A
newB E
(E F
)F G
;G H
} 
} å
ÑC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Configuration\WorkerSettings.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Configuration# 0
{ 
public 

class 
WorkerSettings 
{ 
public 
int &
ConsumptionIntervalSeconds -
{. /
get0 3
;3 4
set5 8
;8 9
}: ;
=< =
$num> @
;@ A
public 
int 
	BatchSize 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
$num- 0
;0 1
} 
} ˇ
ÉC:\UCR_2025\Segundo_Semestre\InfoAplicada\Proyecto\Worker_Services_Consumer\Worker_Services_Consumer\Configuration\KafkaSettings.cs
	namespace 	$
Worker_Services_Consumer
 "
." #
Configuration# 0
{ 
public 

class 
KafkaSettings 
{ 
public 
string 
BootstrapServers &
{' (
get) ,
;, -
set. 1
;1 2
}3 4
=5 6
string7 =
.= >
Empty> C
;C D
public 
string 
RequestLogsTopic &
{' (
get) ,
;, -
set. 1
;1 2
}3 4
=5 6
string7 =
.= >
Empty> C
;C D
public 
string 
ErrorLogsTopic $
{% &
get' *
;* +
set, /
;/ 0
}1 2
=3 4
string5 ;
.; <
Empty< A
;A B
public 
string 
EventLogsTopic $
{% &
get' *
;* +
set, /
;/ 0
}1 2
=3 4
string5 ;
.; <
Empty< A
;A B
public		 
string		 
ConsumerGroup		 #
{		$ %
get		& )
;		) *
set		+ .
;		. /
}		0 1
=		2 3
string		4 :
.		: ;
Empty		; @
;		@ A
public

 
string

 
AutoOffsetReset

 %
{

& '
get

( +
;

+ ,
set

- 0
;

0 1
}

2 3
=

4 5
$str

6 @
;

@ A
public 
bool 
EnableAutoCommit $
{% &
get' *
;* +
set, /
;/ 0
}1 2
=3 4
false5 :
;: ;
public 
int 
SessionTimeoutMs #
{$ %
get& )
;) *
set+ .
;. /
}0 1
=2 3
$num4 9
;9 :
public 
int 
MaxPollIntervalMs $
{% &
get' *
;* +
set, /
;/ 0
}1 2
=3 4
$num5 ;
;; <
} 
} 