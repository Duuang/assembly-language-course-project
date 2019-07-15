.386
.model flat, stdcall
option casemap:none
includelib msvcrt.lib
printf	proto C :ptr sbyte, :vararg
scanf	proto C :dword, :vararg

.data
printfstr	byte	'%c', 0
scanfstr	byte	'%s', 0
enterstr    byte    0ah, 0
op1			byte	200 dup(?)
op2			byte	200 dup(?)
middle_result	byte	200 dup(?)
result		byte	400 dup(0)
op1len		dword	0
op2len		dword	0
middleresultlen		dword	0
resultlen		dword	0


.code
main	proc
		invoke	scanf, offset scanfstr, offset op1
		invoke	scanf, offset scanfstr, offset op2
		mov		esi, offset op1
L1:		cmp		byte ptr [esi], 0
		jz		endL1
		sub		byte ptr [esi], 30h   ;将ascii码转换为数字
		inc		op1len            ;op1长度+1 
		inc		esi
		jmp		L1
endL1:	mov		esi, offset op2
L2:		cmp		byte ptr [esi], 0
		jz		endL2
		sub		byte ptr [esi], 30h
		inc		op2len
		inc		esi
		jmp		L2
endL2:	mov		ecx, op2len
		
L3:		sub		edx, edx    ;将op2中要乘的位放入dx
		mov		esi, offset op2
		add		esi, ecx
		sub		esi, 1     ;esi = op2 + ecx - 1
		mov		dl, [esi]
		sub		ebx, ebx    ;用ebx保存进位

		push	ecx        ;保存ecx
		mov		ecx, op1len
		mov		middleresultlen, 0
	L4:		sub		eax, eax    ;将op1中要乘的位放入ax
			mov		esi, offset op1
			add		esi, ecx
			sub		esi, 1     ;esi = op1 + ecx - 1
			mov		al, [esi]
		
			imul	ax, dx     ;两位相乘
			add		eax, ebx     ;加上进位
			
			mov		ebx, 10
			push	edx      ;保存edx
			sub		edx, edx
			div		ebx        ;乘积 / 10

			mov		esi, offset middle_result
			add		esi, middleresultlen    
			mov		[esi], dl       ;中间结果的该位值=余数
			mov		ebx, eax      ;ebx记录进位，进位=商
			inc		middleresultlen
			pop		edx
			loop	L4

		.IF ebx != 0     ;如果最后一次计算还有进位，则中间结果还得加上一位进位
		mov		esi, offset middle_result
		add		esi, middleresultlen
		mov		[esi], bl
		inc		middleresultlen
		.ENDIF
		
		mov		ecx, middleresultlen    ;result = 中间结果（shift之后）+result
		pop		edx   ;将上一层循环中保存的ecx取到edx
		push	edx
		mov		edi, op2len   ;edi保存中间结果在相加前需要移位的位数（也就是从result[?]开始加），为op2len - 上一层ecx
		sub		edi, edx
		sub		dx, dx		;dl中保存进位
	L5:		mov		ebx, middleresultlen     ;result[edi + len-ecx] += middle[len-ecx]
			sub		ebx, ecx
			mov		esi, ebx
			add		ebx, offset middle_result     ;ebx中为middle[?]， esi中为result[?]
			add		esi, edi
			add		esi, offset result
			sub		eax, eax
			mov		al, [ebx]
			add		al, [esi]
			add		al, dl
			mov		bl, 10
			div		bl
			mov		[esi], ah     ;result = 和/10的余数
			mov		dl, al
			loop	L5
		.IF	dl != 0     ;如果最后还有进位，则置result下一位为1
			inc		esi
			mov		byte ptr [esi], 1
		.ENDIF

		pop		ecx         ;loop L3，这里超出范围了，只能用jmp
		dec		ecx
		.IF ecx > 0 
			jmp		L3    
		.ENDIF

		mov		esi, offset result      ;打印结果
		add		esi, 399
		mov		eax, 0     ;为0代表在这之前的全是不用打印的0，为1代表从现在开始需要打印
L6:		.IF	eax == 0
			.IF	byte ptr [esi] != 0     ;遍历，遇到第一个不为0的，打印并设eax为1
				mov		eax, 1
				add		byte ptr [esi], 30h
				push	eax
				push	esi
				invoke printf, offset printfstr, byte ptr [esi]
				pop		esi
				pop		eax
			.ELSEIF esi == offset result
				invoke printf, offset printfstr, '0'   ;如果全为0的情况
			.ENDIF
		.ELSE     ;eax为1，则打印即可
			add		byte ptr [esi], 30h
			push	eax
			push	esi
			invoke printf, offset printfstr, byte ptr [esi]
			pop		esi
			pop		eax
		.ENDIF
		dec		esi
		cmp		esi, offset result
		jae		L6
		invoke printf, offset enterstr
	ret
main endp
end main