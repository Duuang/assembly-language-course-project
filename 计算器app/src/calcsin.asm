.386
.model flat, stdcall
option		casemap:none


;printf proto C :ptr sbyte, :vararg


.data
dot_index	dword	?
decvalue	dword	10
middle		real4	0.
tmpdword	dword	?

.code
CalcSin		proc	C	uses ebx esi edi  output:dword, outputlen:dword, 
												middle_result:dword, if_middle_int:dword,
												operate:dword
		mov		edx, outputlen    ;����С����λ��
		mov		ecx, [edx]
		mov		esi, 1    ; 1��ʾ���ֵĶ���0����������������Ϊ0ʱ����ʾ�в�Ϊ0�ĳ��֣�������С��
L1:		mov		eax, ecx
		dec		eax
		mov		ebx, output
		add		ebx, eax
		.IF byte ptr [ebx] == '.'
		mov		dot_index, eax
		jmp		L1end
		.ELSEIF byte ptr [ebx] != '0'
		mov		esi, 0
		.ENDIF
		loop	L1
L1end:	.IF ecx == 0   ;���δ����С���㣬��С����indexΪlen
		mov		eax, [edx]
		mov		dot_index, eax
		.ENDIF
		;�ۼ�С������ߵ�λ����middle
		mov		ecx, dot_index
		dec		ecx
		fld1      ;st0���浱ǰλҪ�˵�Ȩֵ,��ʼΪ1
L2:		cmp		ecx, 0
		jl		L2end          ;С��0������
		mov		ebx, output   ;����λ����st0����������middle�У�
		add		ebx, ecx
		sub		eax, eax
		mov		al, [ebx]
		sub		al, '0'
		mov		tmpdword, eax
		fild	tmpdword
		fmul	st(0), st(1)
		fadd	middle
		fstp	middle
		;��ʱmiddle���Ѿ���������st0Ϊԭ��Ȩֵ������Ҫ��Ȩֵ*10
		fild	decvalue
		fmul
		dec		ecx
		jmp		L2
L2end:	;��С�����ұߵ�λ
		mov		ecx, dot_index
		inc		ecx
		fld1      ;st0���浱ǰλҪ�˵�Ȩֵ����ʼΪ0.1
		fild	decvalue
		fdiv
		mov		edx, outputlen
L3:		cmp		ecx, [edx]
		jge		L3end          ;С��0������
		mov		ebx, output   ;����λ����st0����������middle�У�
		add		ebx, ecx
		sub		eax, eax
		mov		al, [ebx]
		sub		al, '0'
		mov		tmpdword, eax
		fild	tmpdword
		fmul	st(0), st(1)
		fadd	middle
		fstp	middle
		;��ʱmiddle���Ѿ���������st0Ϊԭ��Ȩֵ������Ҫ��Ȩֵ*10
		fild	decvalue
		fdiv
		inc		ecx
		jmp		L3

L3end:	;���op==1����sin
		.IF operate == 1
			fld		middle
			fsin
			fst		middle
			mov		ebx, middle_result
			mov		eax, middle
			mov		[ebx], eax
		.ELSEIF operate == 2
			fld		middle
			fcos
			fst		middle
			mov		ebx, middle_result
			mov		eax, middle
			mov		[ebx], eax
		.ELSEIF operate == 3
			fld		middle
			fptan
			fst		middle
			mov		ebx, middle_result
			mov		eax, middle
			mov		[ebx], eax
		.ENDIF
		ret
CalcSin		endp
			end