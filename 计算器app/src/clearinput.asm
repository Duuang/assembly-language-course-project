.386
.model flat, stdcall
option		casemap:none


.data

.code
ClearInput		proc	C	uses ebx esi edi  output:dword, outputlen:dword
		
		mov		ebx, output
		mov		[ebx], byte ptr 30h
		mov		[ebx + 1], byte ptr 0
		mov		ebx, outputlen
		mov		[ebx], byte ptr 1
		
		ret
ClearInput		endp
						end