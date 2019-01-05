TITLE Program#4 (Phillips_Justin_Program4.asm)
	
; Author: Justin Phillips
; Course/Project ID: CS271/Project 4              Date:10/23/2018
; Description: Write a program to calculate composite numbers.First, the user is instructed to enter the number of 
; composites to be displayed, and is prompted to enter an integer in the range [1 .. 400].  The user 
; enters a number,n, and the programv erifies that 1 =n=400. If n is out of range, the user is re-
; prompted until s/he enters a value in the specified range.  The program then calculates and displays 
; all of the composite numbers up to and including thenth composite.  The results should be displayed 
; 10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)

MAXSIZE =  400					; max int
MINSIZE =  1					; min int

.data

; (insert variable definitions here)
username	BYTE	33 dup(0)	; string entered by user
usernumber1 DWORD	?			; user composite numbers
comp		DWORD	0			; composite number
compstart	DWORD	4			; start composite
sum			DWORD	0			; sum of ints in fib
count		DWORD	0			; track steps in sequence
remainder	DWORD	0			; division remainder
divisor		DWORD   2			; variable to hold values of checking composites
intro1		BYTE	"Welcome to program 4 composite numbers created by Justin Phillips.  ", 0
ecintro		BYTE	"Extra Credit numbered lines on input is active. ", 0
prompt1		BYTE	"Please enter your name. ", 0
prompt2		BYTE	"Enter a number between 1 and 400. This is the number of composites numbers shown. ", 0
errorprompt BYTE	"Invalid entry please stay with in the range. Please try again. ", 0
userinput	BYTE	"Enter Number: ", 0
compprint	BYTE	"   ", 0
countresult BYTE	"Valid numbers entered. ", 0
averesult	BYTE	"Average of your number (rounded). ", 0
linenumber	BYTE	". ", 0
goodbye		BYTE	"Thanks Good-Bye, ", 0

.code
main PROC
	call	intro
	call	userData
	call	showComp
	call	bye
	call	CrLf
	exit
main ENDP

; title:  introduction
; receives: variables
; returns: username
; preconditions: none
; registers changed: ecx, edx

intro PROC
	mov		edx, OFFSET intro1	; introduce user to program
	call	WriteString
	call	CrLf
	
; get name (getName)
	mov		edx, OFFSET prompt1	; ask for users name
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString
	call	CrLf
	ret
intro ENDP

; title:  get user data
; receives: validate 
; returns: usernumber1
; preconditions: validates number is in range
; registers changed: eax, edx

; get numbers of user (getUserData)
userData PROC

steps:
	
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		usernumber1, eax
	call	validate
	mov		usernumber1, eax	; set to variable
	ret
userData ENDP


; title:  validate
; receives: usernumber1, errorprompt, prompt2, global variables
; returns: usernumber1
; preconditions: none
; registers changed: ecx, edx

validate PROC
	mov		eax, usernumber1
	cmp		eax, MAXSIZE		; if over max get steps again
	jg		error
	cmp		eax, MINSIZE		; if under zero start over
	jl		error
	ret							; return its valid
error:
	mov		edx, OFFSET errorprompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt2	; prompt user again to reenter number
	call	WriteString
	call	ReadInt
	mov		usernumber1, eax
	call	validate			; validate number again
	;mov		usernumber1, eax	; set to variable
	ret
validate ENDP


; title:  prints composite numbers
; receives: usernumber1, errorprompt, prompt2, global variables
; returns: usernumber1
; preconditions: none
; registers changed: ecx, edx

showComp PROC

next:
	
	call	iscomp	
	mov		eax, usernumber1
	mov		ebx, count
	cmp		eax, ebx
	je		done
	jg		next
	ret

done:
	ret						; ends proc	

showComp ENDP

; title:  showComposites
; receives: variables
; returns: compstart
; preconditions: none
; registers changed: eax, ebx, edx



isComp PROC
	mov eax, compstart			; moves composite number
	mov ebx, divisor
	cdq
	div ebx
	mov	remainder, edx			; move remainder
	cmp remainder, 0			; check to see if divided evenly
	je  printcomp
	inc divisor					; increase divisor to run again
	mov eax, compstart			; reset comp to check if equal to divisor
	mov ebx, divisor
	cmp eax, ebx
	je	prime					; the number is prime
	;jl	next
	ret

printcomp:
	mov		eax, compstart		; move composite to print value
	call	writeDec
	mov		edx, OFFSET compprint ; move 3 spaces
	call	writestring
	;call	writeDec
	inc		count				; tracks comps printed
	mov		edx, 0				; 0 to edx hold for the remainder
	mov		eax, count			; move count to see divide check for a new line
	mov		ebx, 10
	div		ebx
	cmp		edx, 0				; check to see if need new line
	je		newline				; 10 numbers are on a line
	jne		nonewline
newline:
	call	Crlf
	
nonewline:
	jmp		prime

	ret
prime:
	inc compstart				; increase composite to the next number to run again
	mov eax, 2
	mov divisor, eax			; reset divisor number back to run the next number
	;jmp next
	ret
isComp ENDP


; title:  bye
; receives: variales
; returns: none
; preconditions: none
; registers changed: edx


; say good bye (farewell)

bye PROC
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf
	ret
bye ENDP



END main