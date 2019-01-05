TITLE Program#5 (Phillips_Justin_Program5.asm)
	
; Author: Justin Phillips
; Course/Project ID: CS271/Project 5              Date:11/05/2018
; Description: Get user to request a number within therange of [10-200]. Generate a random integer within the range
; [lo=100.. hi=999]Storing them in consecutive elements of an array. Display the list before sorting, 10 numbers per line. Sort the list
; sort the list in descending order( largest first). Calculate and display the median value, rounded to the nearest integer.
; Display sorted list, 10 numbers per line. registered indirect array 

INCLUDE Irvine32.inc

; (insert constant definitions here)

MAXSIZE =  200					; max size of array
MINSIZE =  10					; min size of array
HI		=  999					; highest random number
LO		=  100					; lowest random number

.data

; (insert variable definitions here)
username	BYTE	33 dup(0)	; string entered by user
usernumber1 DWORD	?			; user range number
temp		DWORD	0			; temp
;sum			DWORD	0			; sum of ints in fib
count		DWORD	0			; track steps in sequence
ARRAYCOUNT	DWORD	10			; counts the array
remainder	DWORD	0			; division remainder
divisor		DWORD   2			; variable to hold values of checking composites
median		DWORD	0			; holds median value rounded to nearest int
arraynum	DWORD	0			; holds value to set median
temp1		DWORD	0			; holds a temp value
list		DWORD	MAXSIZE	DUP(?) ; defines array	
intro1		BYTE	"Welcome to program 5 array sorting created by Justin Phillips.  ", 0
ecintro		BYTE	"Extra Credit numbered lines on input is active. ", 0
prompt1		BYTE	"Please enter your name. ", 0
prompt2		BYTE	"Enter a number between 10 and 200. This is the range of the array. ", 0
prompt3		BYTE	"The median of the array: ", 0
prompt4		BYTE	"Unsorted array: ", 0
prompt5		BYTE	"Sorted Array: ",0
errorprompt BYTE	"Invalid entry please stay with in the range. Please try again. ", 0
userinput	BYTE	"Enter Number: ", 0
compprint	BYTE	"   ", 0
countresult BYTE	"Valid numbers entered. ", 0
;averesult	BYTE	"Average of your number (rounded). ", 0
;linenumber	BYTE	". ", 0
goodbye		BYTE	"Thanks Good-Bye, ", 0

.code
main PROC
	;push	OFFSET	list
	;push	ARRAYCOUNT
	call	Randomize			; intialize sequence based on system clock
	call	intro
	call	userData
;-----------------------------------------------------------------
	push	OFFSET	list		; push array on stack
	push	ARRAYCOUNT			; push array size
	call	fillArray			; autofill array
	mov		edx, OFFSET prompt4	; prints unsorted array string
	call	writeString
	call	CrLf
;-----------------------------------------------------------------
	push	OFFSET	list
	push	ARRAYCOUNT
	call	print				; prints randomized array
	call	CrLf
;-----------------------------------------------------------------
	mov		edx, OFFSET	prompt5	; prints string "sorted array:"
	call	writestring
	call	CrLf
;-----------------------------------------------------------------
	push	OFFSET	list
	push	ARRAYCOUNT
	call	sort				; calls bubblesort proc
	call	CrLf
;-----------------------------------------------------------------
	push	OFFSET	list
	push	ARRAYCOUNT
	call	print				; prints sorted array
	call	CrLf
;-----------------------------------------------------------------
	push	OFFSET	list
	push	ARRAYCOUNT
	call	medn				; calculates median and prints it
	call	CrLf
;-----------------------------------------------------------------
	call	bye
	call	CrLf
	exit
main ENDP

;-----------------------------------------------------------------
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

;-----------------------------------------------------------------
; title:  get user data (get data)
; receives: validate 
; returns: usernumber1
; preconditions: validates number is in range
; registers changed: eax, edx

; get numbers of user (getUserData)

userData PROC
	
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		ARRAYCOUNT, eax
	call	validate
	mov		ARRAYCOUNT, eax	; set to variable
	ret

userData ENDP

;-----------------------------------------------------------------
; title:  validate
; receives: usernumber1, errorprompt, prompt2, global variables
; returns: usernumber1
; preconditions: none
; registers changed: ecx, edx

validate PROC
	mov		eax, ARRAYCOUNT
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
	mov		ARRAYCOUNT, eax
	call	validate			; validate number again
	ret
validate ENDP

;-----------------------------------------------------------------
; title:  fill array
; receives: ebp, constant variables
; returns: array edi elements
; preconditions: none
; registers changed: edi, eax, ecx, ebp

fillArray PROC

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]				; @list in edi
	mov		ecx, [ebp+8]				; value of count in ecx
	;call	Randomize
more:
	;call	randomizer
	mov		eax, HI				; 999
	sub		eax, LO				; 100
	inc		eax
	call	RandomRange			; gets range for random numbers
	add		eax, LO
	mov		[edi], eax			; sets value to array
	add		edi, 4				; move to next array element
	loop	more				; repeat loop

	pop		ebp
	ret		8

fillArray ENDP

;-----------------------------------------------------------------
; title:  randomizer (not Used)
; receives: variables
; returns: 
; preconditions: none
; registers changed: eax



randomizer PROC
	mov		eax, HI				; 999
	sub		eax, LO				; 100
	inc		eax
	call	RandomRange			;
	add		eax, LO
	ret
randomizer ENDP

;-----------------------------------------------------------------
; title:  print (display List)
; receives: ebp
; returns: esi
; preconditions: none
; registers changed: edx


print PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]		; @array
	mov		ecx, [ebp+8]		; set loop counter
more:
	mov		eax, [esi]			; move composite to print value
	call	writeDec
	mov		edx, OFFSET compprint ; move 3 spaces
	call	writestring
	add		esi, 4
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
	loop	more
nonewline:
	loop	more
	mov		count, 0			; reset count back to zero for numbers per line
	pop		ebp
	ret		8
print ENDP
;-----------------------------------------------------------------

; title:  bubble sort (sort list)
; receives: ebp
; returns: esi
; preconditions: none
; registers changed: esi, ebp, ecx, eax

sort PROC
	push	ebp
	mov		ebp, esp
	;mov		esi, [ebp+12]
	mov		ecx, [ebp+8]			; set loop counter
	dec		ecx
start:
	push	ecx						; push outerloop counter to stack
	;push	ecx, [ebp+8]
	;mov		ebx, [ebp+12]
	mov		esi, [ebp+12]			; set start of array
innerLoop:
	mov		eax, [esi]				; value of esi to eax
	cmp		[esi+4], eax			; compare to the next element
	jle		nextstep				; jump to nextstep if greater
	xchg	eax, [esi+4]			; swap if greater
	mov		[esi], eax				; move to the array
nextstep:
	add		esi, 4					; next element
	loop	innerLoop				; return to inner loop

	pop		ecx						; pop loop counter
	loop	start					; return to outer loop
	;call	print
	pop		ebp
	ret		8

sort ENDP
;-----------------------------------------------------------------

; title:  median (display median)
; receives: ebp, 
; returns: median results, 
; preconditions: none
; registers changed: edx, ebp, ebx, eax, 

medn PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		eax, [ebp+8]
	;mov		eax, [ebx]
	mov		edx, 0					; set 0 as a remainder
	mov		ebx, 2					; set to divide by 2 check if even or odd
	div		ebx
	;mov		remainder, edx
	mov		arraynum, eax			; set results
	cmp		edx, 0
	je		noremainder				; even number of elements
	jg		addmed					; odd number

addmed:								; odd find the center element
	mov		ebx, 4					; mov 4(dword) to get location of center 
	mul		ebx
	mov		arraynum, eax			; save to a variable
	mov		eax, arraynum
	mov		eax, [esi+eax]			; move value at array adress + eax to get proper element
	mov		edx, OFFSET	prompt3		; median string
	call	WriteString
	call	WriteDec
	pop		ebp
	ret		8

noremainder:						; even number
	mov		eax, arraynum			; 
	mov		ebx, 4
	mul		ebx						; find element in the array
	;mov		arraynum, eax
	;mov		eax, arraynum
	mov		eax, [esi+eax]
	mov		temp1, eax				; store eax value into variable
	mov		eax, arraynum			; reset variable to find other element for median
	mul		ebx
	sub		eax, 4					; mov to previous element
	mov		ebx, eax				; set 2nd element location
	;add		eax, ebx
	mov		ebx, [esi+ebx]			; set locations value
	mov		eax, temp1				; reset 1st element
	add		eax, ebx				; add to values to get median
	mov		ebx, 2					; divide by 2 to get average of values
	div		ebx
	mov		edx, OFFSET	prompt3
	call	WriteString
	call	WriteDec				; prints median average of 2 values


	pop		ebp
	ret		8

medn ENDP

;-----------------------------------------------------------------

; say good bye (farewell)

; title:  bye
; receives: variales
; returns: none
; preconditions: none
; registers changed: edx

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

; some code was used from sources of Kip Irvines book Assembly Language 7th ed
; and https://media.oregonstate.edu/media/t/0_kaxnnvrf lecture 20 osu ecampus