.386
.model flat, stdcall
option		casemap:none


;printf proto C :ptr sbyte, :vararg

;extrn	_outputstr:dword

.data

.code
NumberButtonClicked		proc	C	uses ebx esi edi  output:dword, outputlen:dword,
													number:byte, if_last:dword
		
		mov		ebx, if_last
		.IF		dword ptr [ebx] == 1    ;如果是最终结果，则按数字键需要先清除output
		mov		ebx, output
		mov		[ebx], byte ptr 30h
		mov		[ebx + 1], byte ptr 0
		mov		ebx, outputlen
		mov		[ebx], byte ptr 1
		mov		ebx, if_last
		mov		[ebx], dword ptr 0
		.ENDIF
		.IF number <= 9     ;0~9的number值为0~9，.的为10，如果>=0，则覆盖或直接添加即可
		mov		ebx, output
		mov		edx, outputlen
			.IF (dword ptr [edx] == 1) && (byte ptr [ebx] == 30h)  ;如果output只是一个0，则覆盖，长度不变
			mov		al, number
			add		al, 30h
			mov		[ebx], al
			mov		[ebx + 1], byte ptr 0

			.ELSE	    ;直接添加，长度++
			add		ebx, [edx]
			mov		al, number
			add		al, 30h
			mov		[ebx], al
			mov		[ebx + 1], byte ptr 0
			inc		dword ptr [edx]    ;为毛不能直接inc dword ptr [outputlen]????
			.ENDIF
		.ELSEIF number == 10   ;是.的情况，遍历字符串，如果有.，则不变，如果没有，则添加
	
		mov		edx, outputlen
		mov		ecx, [edx]
L1:		mov		eax, ecx
		dec		eax
		mov		ebx, output
		add		eax, ebx
			.IF byte ptr [eax] == '.'
			jmp		L1end
			.ENDIF
		loop	 L1
L1end:	.IF ecx == 0
		mov		ebx, output
		mov		edx, outputlen
		add		ebx, [edx]
		mov		byte ptr [ebx], '.'
		mov		[ebx + 1], byte ptr 0
		inc		dword ptr [edx]    ;为毛不能直接inc dword ptr [outputlen]????
		.ENDIF
		.ENDIF
		ret
NumberButtonClicked		endp
						end