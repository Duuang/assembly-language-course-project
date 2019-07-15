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
												;op为操作符，+为1，-为2，*3，÷4，=5
		mov		middle, dword ptr 0
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

L3end:	;如果output是最终结果，则这次是重复按键，不做任何处理
		.IF		dword ptr if_last_result == 1
		jmp		procend
		.ENDIF
		;如果中间结果不可用，则只需要保存中间结果和操作符即可
		mov		ebx, if_middle_valid
		.IF dword ptr [ebx] == 0
		cmp		dword ptr operate, 5 ;如果是=号，则不用做任何操作
		jz		procend
		fld		middle
		mov		ebx, middle_result
		fst		dword ptr [ebx]
		mov		ebx, if_middle_valid
		mov		dword ptr [ebx], 1
		mov		eax, operate
		mov		ebx, last_op
		mov		dword ptr [ebx], eax   ;lastop为+，1代表+，以此类推，将op参数保存到last_op
		
		;如果中间结果可用，则读取中间结果和操作符，计算 (middle中间结果) 操作符 (output)，并记录操作符和中间结果 
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
		mov		ebx,  if_middle_valid   ;如果是=号，则不用改变last_op，只需要设middle_valid为不可用
		mov		dword ptr [ebx], 0
		.ELSE
		mov		eax, operate
		mov		ebx, last_op
		mov		dword ptr [ebx], eax   ;lastop为+，1代表+
		.ENDIF
		.ENDIF
procend:ret
BasicCalc		endp
			end