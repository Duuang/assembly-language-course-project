.386
.model flat, stdcall
option		casemap:none

.data
dot_index	dword	?
decvalue	dword	10
middle		real4	0.
tmpdword	dword	?

.code
BasicCalc		proc	C	uses ebx esi edi  output:dword, outputlen:dword, 
												middle_result:dword, if_middle_int:dword,
												operate:dword, if_middle_valid:dword,
												last_op:dword, if_last_result:dword
												;opΪ��������+Ϊ1��-Ϊ2��*3����4��=5
		mov		middle, dword ptr 0
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

L3end:	;���output�����ս������������ظ������������κδ���
		.IF		dword ptr if_last_result == 1
		jmp		procend
		.ENDIF
		;����м��������ã���ֻ��Ҫ�����м����Ͳ���������
		mov		ebx, if_middle_valid
		.IF dword ptr [ebx] == 0
		cmp		dword ptr operate, 5 ;�����=�ţ��������κβ���
		jz		procend
		fld		middle
		mov		ebx, middle_result
		fst		dword ptr [ebx]
		mov		ebx, if_middle_valid
		mov		dword ptr [ebx], 1
		mov		eax, operate
		mov		ebx, last_op
		mov		dword ptr [ebx], eax   ;lastopΪ+��1����+���Դ����ƣ���op�������浽last_op
		
		;����м������ã����ȡ�м����Ͳ����������� (middle�м���) ������ (output)������¼���������м��� 
		.ELSE
		fld		middle
		mov		ebx, middle_result
		mov		esi, last_op
		.IF		dword ptr [esi] == 1
		fld		dword ptr [ebx]
		fadd	st(0), st(1)
		.ELSEIF dword ptr [esi] == 2
		fld		dword ptr [ebx]
		fsub	st(0), st(1)
		.ELSEIF dword ptr [esi] == 3
		fld		dword ptr [ebx]
		fmul	st(0), st(1)
		.ELSEIF dword ptr [esi] == 4
		fld		dword ptr [ebx]
		fdiv	st(0), st(1)
		.ENDIF
		fst     dword ptr [ebx]

		.IF		dword ptr operate == 5
		mov		ebx,  if_middle_valid   ;�����=�ţ����øı�last_op��ֻ��Ҫ��middle_validΪ������
		mov		dword ptr [ebx], 0
		.ELSE
		mov		eax, operate
		mov		ebx, last_op
		mov		dword ptr [ebx], eax   ;lastopΪ+��1����+
		.ENDIF
		.ENDIF
procend:ret
BasicCalc		endp
			end