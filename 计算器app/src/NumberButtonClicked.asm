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
		.IF		dword ptr [ebx] == 1    ;��������ս���������ּ���Ҫ�����output
		mov		ebx, output
		mov		[ebx], byte ptr 30h
		mov		[ebx + 1], byte ptr 0
		mov		ebx, outputlen
		mov		[ebx], byte ptr 1
		mov		ebx, if_last
		mov		[ebx], dword ptr 0
		.ENDIF
		.IF number <= 9     ;0~9��numberֵΪ0~9��.��Ϊ10�����>=0���򸲸ǻ�ֱ����Ӽ���
		mov		ebx, output
		mov		edx, outputlen
			.IF (dword ptr [edx] == 1) && (byte ptr [ebx] == 30h)  ;���outputֻ��һ��0���򸲸ǣ����Ȳ���
			mov		al, number
			add		al, 30h
			mov		[ebx], al
			mov		[ebx + 1], byte ptr 0

			.ELSE	    ;ֱ����ӣ�����++
			add		ebx, [edx]
			mov		al, number
			add		al, 30h
			mov		[ebx], al
			mov		[ebx + 1], byte ptr 0
			inc		dword ptr [edx]    ;Ϊë����ֱ��inc dword ptr [outputlen]????
			.ENDIF
		.ELSEIF number == 10   ;��.������������ַ����������.���򲻱䣬���û�У������
	
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
		inc		dword ptr [edx]    ;Ϊë����ֱ��inc dword ptr [outputlen]????
		.ENDIF
		.ENDIF
		ret
NumberButtonClicked		endp
						end