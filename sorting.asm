; 姓名：李其祐
; 學號：111016041
; 自評分數：100 可以接收數字並完成排序
; 操作說明：輸入五個數字，中間用空格隔開


INCLUDE Irvine32.inc

.386
;.model flat, stdcall
.stack 4096
ExitProcess PROTO, deExitCode:DWORD

.data
input BYTE 20 DUP(?)
output DWORD 6 DUP(?)
inputString BYTE 'please input 5 numbers: '
pre DWORD 0 ; 前一組數字，用來把字串組成真正的數值
index DWORD 0 ; 把輸入的string 轉成五個數字的index

.code

main PROC
	mov edx, OFFSET inputString
	mov ecx, LENGTHOF inputString
	call writeString

	mov edx, OFFSET input 
	mov ecx, LENGTHOF input
	call readString
	mov esi, 0

	detect: 
		; check if is space
		mov al, input[esi]
		cmp al, ' '
		je isSpace
		cmp al, 0
		je isSpace
		cbw
		cwd
	
		; process ASCII Char to Number -> 1. first number 2. add pre
		and eax, 00Fh
	
		; add previous number
		mov ebx, eax
		mov eax, pre
		mov edx, 10
		mul edx
		add ebx, eax
		mov pre, ebx
		mov eax, pre
	
		inc esi
		jmp detect		
	
	isSpace:
		; 把組起來的數字存入 output[index]
		mov ebx, OFFSET output
		mov eax, index
		mov edx, 4
		mul edx
		add ebx, eax
		mov eax, pre
		mov [ebx], eax
		inc index
		cmp index, 5 
		je done
		inc esi
		mov pre, 0
		jmp detect
	
	done:
		mov ecx, 5
		; sorting
			loop1:
				push ecx
				mov ecx, 4
				mov ebx, OFFSET output
				loop2:
					mov eax, [ebx]
					cmp eax, [ebx+4]
					ja next
					xchg eax, [ebx+4]
					mov [ebx], eax
					next: 
					add ebx, 4
				loop loop2
				pop ecx
			loop loop1

		mov ecx, 5
		mov ebx, OFFSET output

		; output answer
		print:
			mov eax, [ebx]
			call WriteDec
			call CRLF
			add ebx, 4
			loop print

main ENDP
END main