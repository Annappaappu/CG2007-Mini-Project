stk segment stack
	db 128 DUP(?)
tos label word
stk ends
;
data segment
	array db 8,9
	len equ $ - array
	nonumbers db "There are no numbers", 0Ah
	threshold equ 4
data ends
;
code segment
assume cs:code, ss:stk, ds:data
;
start:
print MACRO val
	mov ah, 2
	mov dl, val
	add dl, 30h
	int 21h
ENDM
doublePrint MACRO val
	mov ax, val
	mov dx, 0
	mov bx, 10
	div word ptr bx 		;divide ax by bx
	mov cx, dx
	mov dl, 0
	cmp dl, al				;if single digit
	je second
first:	print al			;printing first char
second:	print cl			;printing second char
ENDM
	mov	ax, stk		;initialize stack
	mov	ss, ax
	mov	sp, offset tos
	mov	ax, data		;initialize data segment
	mov	ds, ax
	;q1
	doublePrint len
	;
	;q2
	mov cl, 0ah
	print cl
	xor cl, cl
	xor bx, bx
	xor al, al
	xor ch, ch
traverse:
	mov cl, array[bx]	;copying array element to cl
	cmp cl, threshold	;comparing cl and threshold
	jl printcl			;if cl<threshold then print cl
	inc bx				;increment counter
	cmp bx, len			;comparing counter and length
	jl traverse		;if not equal, then continuing the loop
	jg checkIfNone
	je checkIfNone
printcl:
	print cl
	mov ch, 5
	inc bx
	cmp bx, len
	jl traverse
	;
checkIfNone:
	cmp ch,5
	jnz printNoNumber
	jz exit
printNoNumber:
	mov ah, 9
	mov dl, nonumbers
	int 21h
;
; call exit function to DOS
exit:
	mov ah,4ch
	int 21h
code ends
end start