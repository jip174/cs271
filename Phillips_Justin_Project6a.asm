TITLE Program Template     (Phillips_Justin_Project6a.asm)

; Author: Justin Phillips
; Last Modified: 11/13/2018
; OSU email address: phillij6@oregonstate.edu
; Course number/section: cs271/
; Project Number: 6a                Due Date: 12/2/2018
; Description: Implement and test procedures for unsigned ints. Implement macros getString and displayString
; 
; write a small test program that gets 10 ints and validates stores values then display sum and average
;

INCLUDE Irvine32.inc
;--------------------------------------------------
; code from pg 415 in Irvines 7th edition
; macros
getString MACRO address, length
	
		push	edx
		push	ecx
		mov		edx, address
		mov		ecx, length
		;call	WriteString
		call	ReadString
		;mov		usernumber, eax
		pop		ecx
		pop		edx
	ENDM

;--------------------------------------------------
displayString MACRO str
				
		push	edx
		mov		edx, OFFSET str
		call	WriteString
		pop		edx
		
ENDM
;--------------------------------------------------
; (insert constant definitions here)
	MAX		= 10							; max number of integers
;--------------------------------------------------	
.data

	username		BYTE	33 dup(0)	; string of users name
	buffer			BYTE	255 DUP(0)
	instring		BYTE	32 DUP(?)
	temp			BYTE	32 DUP(?)
	
	usernumber		DWORD	?			; user
	sum				DWORD	0			; 
	average			DWORD	0			; average of the inputed digits
	intarray		DWORD	MAX DUP(0)	; holds array input
	tempArray		BYTE	10	DUP(?)	; 
	intro1			BYTE	" Welcome to program 6a string conversion by Justin Phillips. ", 0
	intro2			BYTE	" Instructions: Enter an unsigned integer. It must fit in a 32bit register(digits only)", 0
	prompt1			BYTE	" Please enter your name: ", 0
	prompt2			BYTE	" Please enter unsigned number: ", 0
	prompt3			BYTE	" You entered the following numbers: ", 0
	prompt4			BYTE	" The sum of these numbers is: ", 0
	prompt5			BYTE	" The average is: ", 0
	prompt6			BYTE	" User input: ", 0
	space			BYTE	" ", 0
	errorprompt		BYTE	" Invalid entry please reenter a unsigned number.(entry was a nondidgit or it was to large) ", 0
	goodbye			BYTE	" Good-Bye. ", 0
; (insert variable definitions here)
;--------------------------------------------------
.code
main PROC

; (insert executable instructions here)
	call	intro
	;call	userData
	mov		edi, OFFSET intarray
	mov		ecx, MAX
input:
	displayString	prompt2			; get user data
	push	OFFSET buffer			; push address on stack by reference
	push	SIZEOF	buffer			; push size on stack by value
	call	readVal
	mov		eax, DWORD PTR buffer
	mov		[edi], eax
	add		edi, 4
	loop	input
;--------------------------------------------------	
	mov		ecx, MAX				; reset loop counter
	mov		esi, OFFSET intarray
	mov		ebx, 0					; holds sum value
	displayString	prompt6			; print user text
;--------------------------------------------------
total:
	mov		eax, [esi]				; move value at address to eax
	add		ebx, eax
	push	eax
	push	OFFSET temp
	call	writeVal
	add		esi, 4
	loop	total					; loop through array to get total sum
;--------------------------------------------------
	mov		eax, ebx
	mov		sum, eax				; set value to sum
	call	CrLf
	displaystring prompt4			; print sum title	
	push	sum						; push on stack to print in proc
	push	OFFSET temp
	call	WriteVal
	call	CrLf
;--------------------------------------------------
	mov		ebx, MAX				; set 10
	mov		edx, 0					; set remainder
	div		ebx
	mov		ecx, eax
	mov		eax, edx
	mov		edx, 2
	mul		ebx						; 
	cmp		eax, ebx
	mov		eax, ecx
	mov		average, eax
	jb		L2						; jump if no need to round
	inc		eax						; add 1 because rounding is required
	mov		average, eax			; adjust average becuase rounded

L2:
	displayString	prompt5			; average title
	push	average	
	push	OFFSET	temp
	call	WriteVal
	call	CrLf
	call	bye

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
;--------------------------------------------------
; title:  introduction
; receives: variables
; returns: username
; preconditions: none
; registers changed: ecx, edx
;--------------------------------------------------

intro PROC
	;mov		edx, OFFSET intro1	; introduce user to program
	;call	WriteString
	displayString	intro1
	call	CrLf
	displayString	intro2
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

;--------------------------------------------------
; title:  readVal
; receives: address, sizeof
; returns: none
; preconditions: none
; registers changed: edx, ecx, eax
;--------------------------------------------------

readVal PROC
	push	ebp
	mov		ebp, esp
	pushad						; push all registers to save
start:
	mov		edx, [ebp+12]		; address
	mov		ecx, [ebp+8]		; sizeof
	getString	edx, ecx
	mov		esi, edx			; address of buffer
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, MAX			; MAX = 10
arrayFill:
	lodsb						; loads a byte from esi to ax
	cmp		eax, 0				; check to see if reached end 
	je		done
	cmp		eax, 57				; 9 is ASCII 57
	ja		invalid
	cmp		eax, 48				; 0 is ASCII 48
	jb		invalid
	;loop	arrayfill
	;cld
;convert:
	sub		ax, 48
	xchg	eax, ecx			; swap registers
	mul		ebx
	jc		invalid				; if carry is set its invalid
	jnc		valid
invalid:
	displayString	errorprompt ; prints error msg
	call	CrLf
	jmp		start
valid:
	add		eax, ecx
	xchg	eax, ecx
	jmp		arrayfill
done:
	xchg	ecx, eax
	mov		DWORD PTR buffer, eax ; move the eax to the ptr
	popad						; restores registers
	pop		ebp
	ret 8
readVal	ENDP

;--------------------------------------------------
; title:  writeVal
; receives: integers, address for the string(temp)
; returns: none
; preconditions: none
; registers changed: edx
;--------------------------------------------------

writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad
	mov		eax, [ebp+12]		; integer to be converted
	mov		edi, [ebp+8]		; address to store string
	mov		ebx, MAX
	push	0					; top of the stack
	;STD
	;lodsb
convert:
	mov		edx, 0
	div		ebx
	add		edx, 48
	 push	edx	
	 ;mov	eax, edx	
	 ;stosb
	 ;pop	eax		
	cmp		eax, 0				; check if at the end
	jne		convert
clear:
	pop		[edi]
	mov		eax, [edi]
	inc		edi
	cmp		eax, 0
	jne		clear				; loop through untill all are popped

	mov		edx, [ebp+8]
	displaystring OFFSET temp
	displayString	space		; insert space between numbers
	;call CrLf
	popad						; restore registers
	pop	ebp
	ret 8
writeVal ENDP


;--------------------------------------------------
; title:  bye
; receives: variales
; returns: none
; preconditions: none
; registers changed: edx
;--------------------------------------------------

bye PROC
	call	CrLf
	displayString	goodbye
	;mov		edx, OFFSET goodbye
	;call	WriteString
	;mov		edx, OFFSET username
	;call	WriteString
	displayString	username
	call	CrLf
	ret
bye ENDP

END main

