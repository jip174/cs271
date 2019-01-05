TITLE Program 2

; Author: Justin Phillips
; Course/Project ID: CS271/Project 2              Date:9/30/2018
; Description: Prompt the user to enter the number of Fibonacci terms to be displayed
;			   Calculate and display all of the Fibonacci numbers up to and including the nth term.  The results should be 
;			   displayed 5 terms per line with at least 5 spaces between terms	

INCLUDE Irvine32.inc

; (insert constant definitions here)

MAXSIZE = 46					; max steps in fib

.data

; (insert variable definitions here)
username	BYTE	33 dup(0)	; string entered by user
usernumber1 DWORD	?			; terms in fib seq
fiba		DWORD	1			; Fibonacci starter zero
fibb		DWORD	1			; Fibonacci starting second term 1
sum			DWORD	0			; sum of ints in fib
count		DWORD	0			; track steps in sequence
intro1		BYTE	"Welcome to program 2 Fibonacci Sequence created by Justin Phillips187.  ", 0
prompt1		BYTE	"Please enter your name. ", 0
prompt2		BYTE	"Please enter the number of fibonacci terms to be displayed. Enter an integer between 1-46 ", 0
sumresult	BYTE	"     ", 0
goodbye		BYTE	"Thanks Good-Bye, ", 0

.code
main PROC

; introduce 
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf

; get name (userInstructions)
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString
	call	CrLf

; get steps in fib sequence (getUserData)
steps:
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	cmp		eax, MAXSIZE		; if over max get steps again
	jg		steps
	cmp		eax, 0				; if under zero start over
	jle		steps
	mov		usernumber1, eax	; set to variable
	mov		ecx, usernumber1	; init loop

	
top:
	mov		eax, fiba
	mov		ebx, fibb
	add		eax, ebx			; add fib sequence
	mov		sum, eax			; sum fib
	mov		eax, ebx			; mov ebx to eax for loop
	mov		ebx, sum			;
	mov		fiba, eax			; reset fiba
	mov		fibb, ebx			; reset fibb 
	mov		eax, ebx			; move sum to eax to print

; report sum of fib (displayFibs)
	mov		edx, OFFSET sumresult ; move 5 spaces
	call	writestring
	call	writeDec
	inc		count				; tracks steps
	mov		edx, 0				; 0 to edx hold for the remainder
	mov		eax, count			; move count to see divide check for a new line
	mov		ebx, 5
	div		ebx
	cmp		edx, 0				; check to see if need new line
	je		newline
	jne		nonewline

newline:
	call	Crlf

nonewline:
	loop	top

L2:
; say good bye (farewell)

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
