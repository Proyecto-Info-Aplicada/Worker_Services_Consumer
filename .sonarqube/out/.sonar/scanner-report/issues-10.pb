y
csharpsquidS4487YRemove this unread private field '_workerSettings' or refactor the code to use its value.2( 7é
csharpsquidS3881KFix this implementation of 'IDisposable' to conform to the dispose pattern.2		 %:Š
‡
		 %yProvide 'protected' overridable implementation of 'Dispose(bool)' on 'KafkaConsumerService' or mark the type as 'sealed'.:o
m

–– ]'KafkaConsumerService.Dispose()' should call 'Dispose(true)' and 'GC.SuppressFinalize(this)'.Š
csharpsquidS3776RRefactor this method to reduce its Cognitive Complexity from 31 to the 15 allowed.2==- A:

AA +1:'
%
DD +2 (incl 1 for nesting):

DD# %+1:'
%
JJ +3 (incl 2 for nesting):

JJ2 4+1:'
%
TT +4 (incl 3 for nesting):'
%
WW +4 (incl 3 for nesting):'
%
ZZ +4 (incl 3 for nesting):'
%
ee +4 (incl 3 for nesting):

jj +1:'
%
oo +3 (incl 2 for nesting):'
%
tt +3 (incl 2 for nesting)