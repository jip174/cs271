TITLE Program 3

; Author: Justin Phillips
; Course/Project ID: CS271/Project 3              Date:9/30/2018
; Description: Repeatedly prompt the user to enter a number.  Validate the user input to be in [-100,-1] (inclusive). 
; Count and accumulate the valid user numbers until a non-negative number is entered.  (The non-negative
; number is discarded. Calculate the (rounded integer) average of the negative numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)

MAXSIZE = -1					; max int
MINSIZE = -100					; min int

.data

; (insert variable definitions here)
username	BYTE	33 dup(0)	; string entered by user
usernumber1 DWORD	?			; user neg int
total		DWORD	0			; holder for total of ints
average		DWORD	0			; average of ints
sum			DWORD	0			; sum of ints in fib
count		DWORD	0			; track steps in sequence
remainder	DWORD	0			; division remainder
intro1		BYTE	"Welcome to program 3 accumulate and average numbers created by Justin Phillips.  ", 0
ecintro		BYTE	"Extra Credit numbered lines on input is active. ", 0
prompt1		BYTE	"Please enter your name. ", 0
prompt2		BYTE	"Please enter a number between -100 and -1, 0 or above to exit  ", 0
userinput	BYTE	"Enter Number: ", 0
sumresult	BYTE	"Sum of the negative numbers is: ", 0
countresult BYTE	"Valid numbers entered. ", 0
averesult	BYTE	"Average of your number (rounded). ", 0
linenumber	BYTE	". ", 0
goodbye		BYTE	"Thanks Good-Bye, ", 0

.code
main PROC

; introduce 
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ecintro	; extra credit prompt
	call	WriteString
	call	CrLf

; get name (userInstructions)
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString
	call	CrLf

; get numbers of user (getUserData)
steps:
	mov		edx, OFFSET	linenumber	; just a spacing period
	mov		eax, count				; count moved to print for ec
	call	WriteDec
	call	WriteString
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	cmp		eax, MAXSIZE		; if over max get steps again
	jg		L2
	cmp		eax, MINSIZE		; if under zero start over
	jl		steps
	mov		usernumber1, eax	; set to variable
		
top:
	mov		eax, usernumber1
	mov		ebx, total
	add		eax, ebx			; add numbers 
	mov		total, eax			; move to toal to reuse in loop if needed
	inc		count				; tracks steps
	loop	steps 	
	
L2:

; say good bye (farewell)

	
	call	CrLf
	mov		edx, OFFSET countresult ; print number user entered
	call	writestring
	mov		eax, count
	call	writeInt
	mov		count, eax
	call	CrLf
	mov		edx, OFFSET sumresult	; print sum all numbers
	call	writestring
	mov		eax, total
	call	writeInt
	mov		total, eax
	call	CrLf
	mov		edx, OFFSET averesult	; prints average of sum
	call	writestring
	mov		edx, 0					; 0 to edx hold for the remainder
	mov		eax, total				;  
	cdq
	mov		ebx, count
	idiv	ebx						; divide total/count to get average
	call	WriteInt				; prints average
	mov		remainder, edx
	mov		average, eax
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
