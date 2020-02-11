INCLUDE Irvine32.inc
.DATA

filename byte "C:\Users\HP\Desktop\test1.txt",0
filename2 byte "C:\Users\HP\Desktop\test2.txt",0
fileHandle HANDLE ?
str1 byte 1000 dup(0)

arrchar byte 'a','b','c','d','e', 'f','g','h','i','k', 'l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',0
arrchar2 byte 26 dup(?)        
keystr byte 1000 dup (?)
keylength dword ?

message byte 1000 dup(?)
tempmessage byte 1000 dup(?)
messagelength dword ?
spacelength dword ?

thereallocation dword ?
rownumberfirst dword ?
columnnumberfirst dword ?
rownumbersecond dword ?
columnnumbersecond dword ?

resultmessage byte 1000 dup(?)
input byte "Enter 1 to Encrypt 2 to Decrypt: ",0
.code
main PROC
call readingfile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx ,  keylength
mov esi , OFFSET keystr
mov bl,' ' 
tolowerkeyreal:
cmp bl,[esi]
je mnss
mov al,[esi]
or al,00100000b
mov [esi ], al
mnss:inc esi
loop tolowerkeyreal
;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov esi,offset keystr
mov ecx,keylength
mov al,'j'
mov bl,'i'
;;;;;;;;;;;;;;;;;;;;;;;;;;;
removethej:
cmp [esi],al
jne ifnotequal
mov [esi],bl
ifnotequal:
add esi,type keystr
loop removethej
;;;;;;;;;;;;;;;;;;;
;removing space from key
;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
mov esi,offset keystr
mov ecx,keylength
mov al,' '
mov bl,'i'
removing_space:
cmp [esi],al
jne ifnotequal2
mov [esi],bl
ifnotequal2:

add esi,type keystr
loop removing_space
;;;;;;;;;;;;;;;;;;;;;;
;add in the array
;;;;;;;;;;;;;;;;;;;;;;
mov edx,offset keystr
mov esi,offset arrchar2
mov ecx,lengthof keystr
adding_matrix:
mov al, [edx]
mov edi,offset arrchar2
push ecx
mov ecx,lengthof arrchar2
repne scasb 
jne notfound
jmp next
notfound:
mov [esi],al
add esi ,type arrchar2
next:
pop ecx
inc edx
loop adding_matrix
dec esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;copying the value in the array
;;;;;;;;;;;;;;;;;;;;;;;
mov edx, offset arrchar
mov ecx, lengthof arrchar
adding_matrix1:
mov al, [edx]
mov edi,offset arrchar2
push ecx
mov ecx,lengthof arrchar2
repne scasb 
jne notfound1
jmp next1
notfound1:
mov [esi],al
add esi ,type arrchar2
next1:
pop ecx
inc edx

loop adding_matrix1
;;/////
;////////////////////////////////////////////////////////////
mov edx ,offset input
call writestring
call readdec
cmp eax,1 
jne todecryption
;////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;read the message
;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx ,  messagelength
mov esi , OFFSET message
mov bl,' ' 
tolowerkey:
cmp bl,[esi]
je mns
mov al,[esi]
or al,00100000b
mov [esi ], al
mns:inc esi
loop tolowerkey
;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;removing the spaces from message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx,lengthof message
mov esi,offset message
mov edi, offset tempmessage
mov bl,' '
removespacefrommessage:
cmp [esi],bl
je foundsapceinmessage
mov al,[esi]
mov [edi],al
inc edi
inc spacelength
foundsapceinmessage:
inc esi
loop removespacefrommessage
mov esi,offset tempmessage
mov edi ,offset message
mov ecx,lengthof tempmessage
 rep movsb

mov eax ,1000
sub eax,spacelength
sub messagelength,eax


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;add x for duplicated element
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov esi,offset message
mov edi,offset message
inc edi
mov edx ,offset tempmessage
mov ecx ,messagelength
removeduplication:
mov al,[edi]
cmp [esi],al
je theyareequal
mov al,[esi]
mov [edx],al
jmp theend
theyareequal:
mov al,[esi]
mov [edx],al
inc edx
mov al,'x'

mov [edx],al
inc messagelength
theend:
inc edx
inc esi
inc edi
loop removeduplication

mov esi,offset tempmessage
mov edi ,offset message
mov ecx,lengthof tempmessage
 rep movsb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;adding x if it odd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov edx,0
mov eax,messagelength
mov ebx,2
div ebx
cmp edx,0
ja thelengthisodd

mov esi,offset tempmessage
mov edi ,offset message
mov ecx,messagelength
l3:
mov bl,[edi]
mov [esi],bl
add edi,type message
add esi,type tempmessage
loop l3 
jmp theend1

thelengthisodd:

mov esi,offset tempmessage
mov edi ,offset message
mov ecx,messagelength

l2:
mov bl,[edi]
mov [esi],bl
add edi,type message
add esi,type tempmessage
loop l2
mov bl,'x'
inc messagelength
mov[esi],bl

theend1:
mov esi,offset tempmessage
mov edi ,offset message
mov ecx,lengthof tempmessage
 rep movsb

call encryptionproc
jmp tooutput
todecryption:
mov ecx ,  messagelength
mov esi , OFFSET message
mov bl,' ' 
tolowerkey2:
cmp bl,[esi]
je mn
mov al,[esi]
or al,00100000b
mov [esi ], al
mn:inc esi
loop tolowerkey2
call decryptionproc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;output
;;;;;;;;;;;;;;;;;;;;;;;;
tooutput:call writingfile


;call crlf
;////////////////////////////////////////////////////////

exit
main ENDP
firstelementgetlocation proc
push ecx
mov ecx,lengthof arrchar2
mov edi ,offset  arrchar2
mov al,[esi]
repne scasb
mov eax , 25
sub eax , ecx
mov thereallocation,eax 
pop ecx
push ebx
push edx
cdq
mov ebx,5
div ebx
mov rownumberfirst ,eax
mov columnnumberfirst ,edx
pop edx
pop ebx
ret
firstelementgetlocation endp

secondelementgetlocation proc
push ecx
mov ecx,lengthof arrchar2
mov edi ,offset  arrchar2
mov al,[ebx]
repne scasb
mov eax , 25
sub eax , ecx
mov thereallocation,eax 
pop ecx
push ebx
push edx
cdq
mov ebx,5
div ebx
mov rownumbersecond ,eax
mov columnnumbersecond ,edx
pop edx
pop ebx
ret
secondelementgetlocation endp
;rownumber equal in encrypt
rownumberencrypt proc
mov ebx ,4
inc columnnumbersecond
cmp columnnumbersecond,ebx
ja secondgreaterthan4 
jmp secondnotgreaterthan4
secondgreaterthan4:
mov ebx,0
mov columnnumbersecond,ebx

secondnotgreaterthan4:

inc columnnumberfirst
cmp columnnumberfirst,ebx
ja firstgreaterthan4 
jmp firstnotgreaterthan4
firstgreaterthan4:
mov ebx,0
mov columnnumberfirst,ebx
firstnotgreaterthan4:
ret
rownumberencrypt endp

;columnnumber equal in encrypt
columnnumberencrypt proc
mov ebx ,4
inc rownumbersecond
cmp rownumbersecond,ebx
ja secondgreaterthan4inrow 
jmp secondnotgreaterthan4inrow
secondgreaterthan4inrow:
mov ebx,0
mov rownumbersecond,ebx

secondnotgreaterthan4inrow:

inc rownumberfirst
cmp rownumberfirst,ebx
ja firstgreaterthan4inrow 
jmp firstnotgreaterthan4inrow
firstgreaterthan4inrow:
mov ebx,0
mov rownumberfirst,ebx
firstnotgreaterthan4inrow:
ret
columnnumberencrypt endp

case3encrypt proc
mov eax,columnnumberfirst 
xchg eax,columnnumbersecond
mov columnnumberfirst,eax
ret
case3encrypt endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;filling the result answer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

resultfillingencrypt proc



mov eax ,5
mul rownumberfirst

mov ebx , eax
mov esi , columnnumberfirst
mov al, arrchar2[ ebx + esi]
mov [edi],al
inc edi

mov eax ,5
mul rownumbersecond
mov ebx , eax

mov esi , columnnumbersecond
mov al, arrchar2[ ebx + esi]
mov [edi],al
inc edi


ret
resultfillingencrypt endp

encryptionproc proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov esi , offset message
mov ebx ,offset message
mov edi ,offset resultmessage
inc ebx
mov ecx, messagelength

encryptloop:
;first element getlocation
push edi
call firstelementgetlocation

;second element getlocation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
call secondelementgetlocation
pop edi
mov eax ,rownumbersecond
cmp eax,rownumberfirst
je rowsareequal
;not same rows
mov eax ,columnnumbersecond
cmp eax,columnnumberfirst
je columnareequal
;not same column 
jmp no_rows_or_columns_are_equal 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rowsareequal:
push ebx
call rownumberencrypt
pop ebx
jmp endtheloop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
columnareequal:
push ebx
call columnnumberencrypt
pop ebx
jmp endtheloop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_rows_or_columns_are_equal:
call case3encrypt
endtheloop:

push ebx
push esi
call resultfillingencrypt
pop esi
pop ebx


dec ecx
add esi ,2
add ebx , 2
loop encryptloop
ret
encryptionproc endp
;/////////////////////////////////////////
;/////////////////////////////////////////
decryptionproc proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov esi , offset message
mov ebx ,offset message
mov edi ,offset resultmessage
inc ebx
mov ecx, messagelength

decryptloop:
;first element getlocation
push edi
call firstelementgetlocation

;second element getlocation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
call secondelementgetlocation
pop edi
mov eax ,rownumbersecond
cmp eax,rownumberfirst
je rowsareequaldecrypt
;not same rows
mov eax ,columnnumbersecond
cmp eax,columnnumberfirst
je columnareequaldecrypt
;not same column 
jmp no_rows_or_columns_are_equaldecrypt 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rowsareequaldecrypt:
push ebx
call rownumberdecrypt
pop ebx
jmp endtheloopdecrypt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
columnareequaldecrypt:
push ebx
call columnnumberdecrypt
pop ebx
jmp endtheloopdecrypt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_rows_or_columns_are_equaldecrypt:
call case3encrypt
endtheloopdecrypt:

push ebx
push esi
call resultfillingencrypt
pop esi
pop ebx


dec ecx
add esi ,2
add ebx , 2
loop decryptloop
ret
decryptionproc endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;rownumber equal in decrypt
rownumberdecrypt proc
mov ebx ,4
dec columnnumbersecond
cmp columnnumbersecond,ebx
ja secondgreaterthan4de 
jmp secondnotgreaterthan4de
secondgreaterthan4de:
mov ebx,4
mov columnnumbersecond,ebx

secondnotgreaterthan4de:

dec columnnumberfirst
cmp columnnumberfirst,ebx
ja firstgreaterthan4de 
jmp firstnotgreaterthan4de
firstgreaterthan4de:
mov ebx,4
mov columnnumberfirst,ebx
firstnotgreaterthan4de:
ret
rownumberdecrypt endp

;columnnumber equal in decrypt
columnnumberdecrypt proc
mov ebx ,4
dec rownumbersecond
cmp rownumbersecond,ebx
ja secondgreaterthan4inrowde 
jmp secondnotgreaterthan4inrowde
secondgreaterthan4inrowde:
mov ebx,4
mov rownumbersecond,ebx

secondnotgreaterthan4inrowde:

dec rownumberfirst
cmp rownumberfirst,ebx
ja firstgreaterthan4inrowde 
jmp firstnotgreaterthan4inrowde
firstgreaterthan4inrowde:
mov ebx,4
mov rownumberfirst,ebx
firstnotgreaterthan4inrowde:
ret
columnnumberdecrypt endp
;////////////////////////////////
;file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readingfile proc
mov edx,offset filename                   ;move the path of the file
call OpenInputFile                        ;to open from file
mov fileHandle,eax                        ;move handle to eax


; Read the file into string
mov edx,OFFSET str1                       ;move to string you want in it
mov ecx,100                                  ;size to read from file
call ReadFromFile                          ;to read from file

mov edx ,offset str1
mov edi ,offset keystr
mov ecx ,lengthof str1
mov bl,10

enteringdataloop:
mov al,[edx]
cmp [edx],bl
jne notenter
jmp itsthekeyenter
notenter:
push ebx
mov bl,[edx]
mov [edi],bl
pop ebx
inc edi
inc edx
inc keylength
loop enteringdataloop
itsthekeyenter:

mov al ,[edx]
inc edx
mov edi ,offset message
mov bl,0

enteringmessageloop:
mov al,[edx]
cmp [edx],bl
jne notenter2
jmp enterkey2
notenter2:
push ebx
mov bl,[edx]
mov [edi],bl
pop ebx
inc edi
inc edx
inc messagelength
loop enteringmessageloop
enterkey2:



ret
readingfile endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;writing in a file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
writingfile proc
;open file for output
mov edx,offset filename2
call CreateOutputFile
mov fileHandle,eax

;writing in a file
;uppercase
mov ecx , messagelength
mov esi , OFFSET resultmessage
toupper:
mov al,[esi]
and al,11011111b
mov [esi], al
inc esi
Loop toupper
mov eax,fileHandle
mov edx,offset resultmessage
mov ecx,messagelength                    ;put size of string
call WriteToFile


ret
writingfile endp
END main