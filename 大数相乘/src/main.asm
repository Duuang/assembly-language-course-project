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
		sub		byte ptr [esi], 30h   ;��ascii��ת��Ϊ����
		inc		op1len            ;op1����+1 
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
		
L3:		sub		edx, edx    ;��op2��Ҫ�˵�λ����dx
		mov		esi, offset op2
		add		esi, ecx
		sub		esi, 1     ;esi = op2 + ecx - 1
		mov		dl, [esi]
		sub		ebx, ebx    ;��ebx�����λ

		push	ecx        ;����ecx
		mov		ecx, op1len
		mov		middleresultlen, 0
	L4:		sub		eax, eax    ;��op1��Ҫ�˵�λ����ax
			mov		esi, offset op1
			add		esi, ecx
			sub		esi, 1     ;esi = op1 + ecx - 1
			mov		al, [esi]
		
			imul	ax, dx     ;��λ���
			add		eax, ebx     ;���Ͻ�λ
			
			mov		ebx, 10
			push	edx      ;����edx
			sub		edx, edx
			div		ebx        ;�˻� / 10

			mov		esi, offset middle_result
			add		esi, middleresultlen    
			mov		[esi], dl       ;�м����ĸ�λֵ=����
			mov		ebx, eax      ;ebx��¼��λ����λ=��
			inc		middleresultlen
			pop		edx
			loop	L4

		.IF ebx != 0     ;������һ�μ��㻹�н�λ�����м������ü���һλ��λ
		mov		esi, offset middle_result
		add		esi, middleresultlen
		mov		[esi], bl
		inc		middleresultlen
		.ENDIF
		
		mov		ecx, middleresultlen    ;result = �м�����shift֮��+result
		pop		edx   ;����һ��ѭ���б����ecxȡ��edx
		push	edx
		mov		edi, op2len   ;edi�����м��������ǰ��Ҫ��λ��λ����Ҳ���Ǵ�result[?]��ʼ�ӣ���Ϊop2len - ��һ��ecx
		sub		edi, edx
		sub		dx, dx		;dl�б����λ
	L5:		mov		ebx, middleresultlen     ;result[edi + len-ecx] += middle[len-ecx]
			sub		ebx, ecx
			mov		esi, ebx
			add		ebx, offset middle_result     ;ebx��Ϊmiddle[?]�� esi��Ϊresult[?]
			add		esi, edi
			add		esi, offset result
			sub		eax, eax
			mov		al, [ebx]
			add		al, [esi]
			add		al, dl
			mov		bl, 10
			div		bl
			mov		[esi], ah     ;result = ��/10������
			mov		dl, al
			loop	L5
		.IF	dl != 0     ;�������н�λ������result��һλΪ1
			inc		esi
			mov		byte ptr [esi], 1
		.ENDIF

		pop		ecx         ;loop L3�����ﳬ����Χ�ˣ�ֻ����jmp
		dec		ecx
		.IF ecx > 0 
			jmp		L3    
		.ENDIF

		mov		esi, offset result      ;��ӡ���
		add		esi, 399
		mov		eax, 0     ;Ϊ0��������֮ǰ��ȫ�ǲ��ô�ӡ��0��Ϊ1��������ڿ�ʼ��Ҫ��ӡ
L6:		.IF	eax == 0
			.IF	byte ptr [esi] != 0     ;������������һ����Ϊ0�ģ���ӡ����eaxΪ1
				mov		eax, 1
				add		byte ptr [esi], 30h
				push	eax
				push	esi
				invoke printf, offset printfstr, byte ptr [esi]
				pop		esi
				pop		eax
			.ELSEIF esi == offset result
				invoke printf, offset printfstr, '0'   ;���ȫΪ0�����
			.ENDIF
		.ELSE     ;eaxΪ1�����ӡ����
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