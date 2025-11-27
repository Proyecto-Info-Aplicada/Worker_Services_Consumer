É
roslynCA1816⁄Cambie "KafkaConsumerService.Dispose()" para llamar a GC.SuppressFinalize(object). Con esto se evitar√° que los tipos derivados que introducen un finalizador tengan que volver a implementar "IDisposable" para llamarlo. 2
ññ @RŸ
roslynCA1854¢Preferir una llamada "TryGetValue" en lugar de un acceso al indexador del diccionario protegido por una comprobaci√≥n "ContainsKey" para evitar la doble b√∫squeda 2TT  O:

UU; ^@RŸ
roslynCA1854¢Preferir una llamada "TryGetValue" en lugar de un acceso al indexador del diccionario protegido por una comprobaci√≥n "ContainsKey" para evitar la doble b√∫squeda 2WW  J:

XX6 T@RŸ
roslynCA1854¢Preferir una llamada "TryGetValue" en lugar de un acceso al indexador del diccionario protegido por una comprobaci√≥n "ContainsKey" para evitar la doble b√∫squeda 2ZZ  H:

[[4 P@R