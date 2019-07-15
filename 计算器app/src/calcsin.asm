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
		mov		edx, outputlen    ;先求小数点位置
		mov		ecx, [edx]
		mov		esi, 1    ; 1表示出现的都是0，是整数；当被置为0时，表示有不为0的出现，所以是小数
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
L1end:	.IF ecx == 0   ;如果未出现小数点，则小数点index为len
		mov		eax, [edx]
		mov		dot_index, eax
		.ENDIF
		;累加小数点左边的位，求middle
		mov		ecx, dot_index
		dec		ecx
		fld1      ;st0保存当前位要乘的权值,初始为1
L2:		cmp		ecx, 0
		jl		L2end          ;小于0则跳出
		mov		ebx, output   ;将该位乘上st0，并弹出到middle中，
		add		ebx, ecx
		sub		eax, eax
		mov		al, [ebx]
		sub		al, '0'
		mov		tmpdword, eax
		fild	tmpdword
		fmul	st(0), st(1)
		fadd	middle
		fstp	middle
		;此时middle中已经保存结果，st0为原先权值，现在要将权值*10
		fild	decvalue
		fmul
		dec		ecx
		jmp		L2
L2end:	;加小数点右边的位
		mov		ecx, dot_index
		inc		ecx
		fld1      ;st0保存当前位要乘的权值，初始为0.1
		fild	decvalue
		fdiv
		mov		edx, outputlen
L3:		cmp		ecx, [edx]
		jge		L3end          ;小于0则跳出
		mov		ebx, output   ;将该位乘上st0，并弹出到middle中，
		add		ebx, ecx
		sub		eax, eax
		mov		al, [ebx]
		sub		al, '0'
		mov		tmpdword, eax
		fild	tmpdword
		fmul	st(0), st(1)
		fadd	middle
		fstp	middle
		;此时middle中已经保存结果，st0为原先权值，现在要将权值*10
		fild	decvalue
		fdiv
		inc		ecx
		jmp		L3

L3end:	;如果op==1，求sin
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