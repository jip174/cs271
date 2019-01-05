TITLE Program 1

; Author: Justin Phillips
; Course/Project ID: CS271/Project 1              Date:9/23/2018
; Description: Get user to enter 2 numbers and then calculate sum,diff,product quotient and 
;			   remainder of the numbers

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; (insert variable definitions here)
username	BYTE	33 dup(0)	; string entered by user
usernumber1 DWORD	?			; 1st user int
usernumber2	DWORD	?			; 2nd user int
sum			DWORD	0			; sum of ints
diff		DWORD	0			; difference of ints
product		DWORD	0			; product of ints
quotient	DWORD	0			; quotient of ints
modulus		DWORD	0			; modulus of ints/remainder
intro1		BYTE	"Welcome to program 1 created by Justin Phillips. enter 2 numbers with the 1st greater then 2nd ", 0
intro2		BYTE	"Extra Credit verifies 2nd number is less than 1st", 0
prompt1		BYTE	"Please enter your name. ", 0
prompt2		BYTE	"Please enter your 1st number. ", 0
prompt3		BYTE	"Please enter your 2nd number. ", 0
prompt4		BYTE	"2nd numbers is greater then the 1st. ", 0
sumresult	BYTE	"The sum is ... ", 0
diffresult	BYTE	"The difference is ... ", 0
prodresult	BYTE	"The product is ... ", 0
quotresult	BYTE	"The quotient is ... ", 0
modresult	BYTE	"The remainder is ... ", 0
goodbye		BYTE	"Thanks Good-Bye, ", 0

.code
main PROC

; introduce 
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf

; extra credit number check	
	mov		edx, OFFSET	intro2
	call	writestring
	call	CrLf
	call	CrLf
	

; get name
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString

; get first number
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		usernumber1, eax

; get second number
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	mov		usernumber2, eax

; compares user number 1>2
	mov		eax, usernumber2
	cmp		eax, usernumber1
	jl		L1

; compares user numbers making sure 1 > 2, displays msg if isnt
	mov		edx, OFFSET prompt4
	call	WriteString
	call	CrLf
	call	CrLf
	jmp		L2

L1:
; calculate sum
	mov		eax, usernumber1
	add		eax, usernumber2
	mov		sum, eax

; report sum
	mov		edx, OFFSET sumresult
	call	writestring
	mov		eax, sum
	call	writeDec
	call	CrLf
	
; calculate difference
	mov		eax, usernumber1
	sub		eax, usernumber2
	mov		diff, eax
	
; report difference
	mov		edx, OFFSET	diffresult
	call	writestring
	mov		eax, diff
	call	WriteDec
	call	CrLf

; calculate product
	mov		eax, usernumber1
	mov		ebx, usernumber2
	mul		ebx
	mov		product, eax

; report product
	mov		edx, OFFSET	prodresult
	call	writestring
	mov		eax, product
	call	WriteDec
	call	CrLf

; calculate quotient 
	mov		edx, 0
	mov		eax, usernumber1
	mov		ebx, usernumber2
	div		ebx
	mov		quotient, eax
	mov		modulus, edx

; report quotient 
	mov		edx, OFFSET	quotresult
	call	writestring
	mov		eax, quotient
	call	WriteDec
	call	CrLf

; calculate mod

; report mod
	mov		edx, OFFSET	modresult
	call	writestring
	mov		eax, modulus
	call	WriteDec
	call	CrLf

L2:
; say good bye
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
