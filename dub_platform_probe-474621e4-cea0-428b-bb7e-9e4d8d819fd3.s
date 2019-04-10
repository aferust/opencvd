	.file	"dub_platform_probe-474621e4-cea0-428b-bb7e-9e4d8d819fd3.d"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"/tmp/dub_platform_probe-474621e4-cea0-428b-bb7e-9e4d8d819fd3.d"
	.text
	.globl	_D18dub_platform_probe4joinFAAyaAyaZAya
	.type	_D18dub_platform_probe4joinFAAyaAyaZAya, @function
_D18dub_platform_probe4joinFAAyaAyaZAya:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	movq	%rsi, %rax
	movq	%rsi, %rdi
	movq	%rbx, %rsi
	movq	%rax, %rdi
	movq	%rsi, -112(%rbp)
	movq	%rdi, -104(%rbp)
	movq	%rdx, -128(%rbp)
	movq	%rcx, -120(%rbp)
	movq	-104(%rbp), %rdx
	movq	-112(%rbp), %rax
	testq	%rax, %rax
	jne	.L2
	movl	$62, %r10d
	leaq	.LC0(%rip), %r11
	movq	%r10, %rcx
	movq	%r11, %rbx
	movq	%r10, %rax
	movq	%r11, %rdx
	movq	%rdx, %rax
	movl	$6, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_d_arraybounds@PLT
.L2:
	movl	$0, %eax
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-112(%rbp), %rax
	testq	%rax, %rax
	jne	.L3
	movl	$62, %r8d
	leaq	.LC0(%rip), %r9
	movq	%r8, %rcx
	movq	%r9, %rbx
	movq	%r8, %rax
	movq	%r9, %rdx
	movq	%rdx, %rax
	movl	$7, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_d_arraybounds@PLT
.L3:
	movq	-112(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -80(%rbp)
	movq	-104(%rbp), %rax
	addq	$16, %rax
	movq	%rax, -72(%rbp)
	movq	$0, -40(%rbp)
.L6:
	movq	-80(%rbp), %rax
	cmpq	%rax, -40(%rbp)
	jnb	.L7
	movq	-72(%rbp), %rdx
	movq	-80(%rbp), %rax
	cmpq	%rax, -40(%rbp)
	jb	.L5
	movl	$62, %r12d
	leaq	.LC0(%rip), %r13
	movq	%r12, %rcx
	movq	%r13, %rbx
	movq	%r12, %rax
	movq	%r13, %rdx
	movq	%rdx, %rax
	movl	$7, %edx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	call	_d_arraybounds@PLT
.L5:
	movq	-40(%rbp), %rax
	salq	$4, %rax
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rsi
	movq	-128(%rbp), %rdx
	movq	-120(%rbp), %rax
	movq	%rsi, %r8
	movq	%rdx, %rsi
	movq	%rax, %rdx
	movq	_D12TypeInfo_Aya6__initZ@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	_d_arraycatT@PLT
	leaq	-64(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movq	_D12TypeInfo_Aya6__initZ@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	_d_arrayappendT@PLT
	addq	$1, -40(%rbp)
	jmp	.L6
.L7:
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	addq	$104, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	_D18dub_platform_probe4joinFAAyaAyaZAya, .-_D18dub_platform_probe4joinFAAyaAyaZAya
	.section	.rodata
.LC1:
	.string	"linux"
.LC2:
	.string	"posix"
	.text
	.globl	_D18dub_platform_probe17determinePlatformFZAAya
	.type	_D18dub_platform_probe17determinePlatformFZAAya, @function
_D18dub_platform_probe17determinePlatformFZAAya:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	$0, -16(%rbp)
	movq	$0, -8(%rbp)
	leaq	-16(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	leaq	_D13TypeInfo_AAya6__initZ(%rip), %rdi
	call	_d_arrayappendcTX@PLT
	movq	%rdx, %rcx
	subq	$1, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	$5, (%rax)
	leaq	.LC1(%rip), %rdx
	movq	%rdx, 8(%rax)
	leaq	-16(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	leaq	_D13TypeInfo_AAya6__initZ(%rip), %rdi
	call	_d_arrayappendcTX@PLT
	movq	%rdx, %rcx
	subq	$1, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	$5, (%rax)
	leaq	.LC2(%rip), %rdx
	movq	%rdx, 8(%rax)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	_D18dub_platform_probe17determinePlatformFZAAya, .-_D18dub_platform_probe17determinePlatformFZAAya
	.weak	_D13TypeInfo_AAya6__initZ
	.section	.data.rel.ro._D13TypeInfo_AAya6__initZ,"awG",@progbits,_D13TypeInfo_AAya6__initZ,comdat
	.align 16
	.type	_D13TypeInfo_AAya6__initZ, @object
	.size	_D13TypeInfo_AAya6__initZ, 24
_D13TypeInfo_AAya6__initZ:
	.quad	_D14TypeInfo_Array6__vtblZ
	.quad	0
	.quad	_D12TypeInfo_Aya6__initZ
	.section	.rodata
.LC3:
	.string	"x86_64"
	.text
	.globl	_D18dub_platform_probe21determineArchitectureFZAAya
	.type	_D18dub_platform_probe21determineArchitectureFZAAya, @function
_D18dub_platform_probe21determineArchitectureFZAAya:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	$0, -16(%rbp)
	movq	$0, -8(%rbp)
	leaq	-16(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	leaq	_D13TypeInfo_AAya6__initZ(%rip), %rdi
	call	_d_arrayappendcTX@PLT
	movq	%rdx, %rcx
	subq	$1, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	$6, (%rax)
	leaq	.LC3(%rip), %rdx
	movq	%rdx, 8(%rax)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	_D18dub_platform_probe21determineArchitectureFZAAya, .-_D18dub_platform_probe21determineArchitectureFZAAya
	.section	.rodata
.LC4:
	.string	"gdc"
	.text
	.globl	_D18dub_platform_probe17determineCompilerFZAya
	.type	_D18dub_platform_probe17determineCompilerFZAya, @function
_D18dub_platform_probe17determineCompilerFZAya:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$3, %eax
	leaq	.LC4(%rip), %rdx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	_D18dub_platform_probe17determineCompilerFZAya, .-_D18dub_platform_probe17determineCompilerFZAya
	.globl	_D18dub_platform_probe12__ModuleInfoZ
	.data
	.align 16
	.type	_D18dub_platform_probe12__ModuleInfoZ, @object
	.size	_D18dub_platform_probe12__ModuleInfoZ, 27
_D18dub_platform_probe12__ModuleInfoZ:
	.long	4100
	.long	0
	.string	"dub_platform_probe"
	.globl	_D18dub_platform_probe11__moduleRefZ
	.section	minfo,"aw"
	.align 8
	.type	_D18dub_platform_probe11__moduleRefZ, @object
	.size	_D18dub_platform_probe11__moduleRefZ, 8
_D18dub_platform_probe11__moduleRefZ:
	.quad	_D18dub_platform_probe12__ModuleInfoZ
	.hidden	gdc.dso_slot
	.weak	gdc.dso_slot
	.section	.bss.gdc.dso_slot,"awG",@nobits,gdc.dso_slot,comdat
	.align 8
	.type	gdc.dso_slot, @gnu_unique_object
	.size	gdc.dso_slot, 8
gdc.dso_slot:
	.zero	8
	.hidden	gdc.dso_initialized
	.weak	gdc.dso_initialized
	.section	.bss.gdc.dso_initialized,"awG",@nobits,gdc.dso_initialized,comdat
	.type	gdc.dso_initialized, @gnu_unique_object
	.size	gdc.dso_initialized, 1
gdc.dso_initialized:
	.zero	1
	.section	.text.gdc.dso_ctor,"axG",@progbits,gdc.dso_ctor,comdat
	.weak	gdc.dso_ctor
	.hidden	gdc.dso_ctor
	.type	gdc.dso_ctor, @function
gdc.dso_ctor:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movzbl	gdc.dso_initialized(%rip), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L17
	movb	$1, gdc.dso_initialized(%rip)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movq	$0, -16(%rbp)
	movq	$0, -8(%rbp)
	movq	$1, -48(%rbp)
	leaq	gdc.dso_slot(%rip), %rax
	movq	%rax, -40(%rbp)
	leaq	__start_minfo(%rip), %rax
	movq	%rax, -32(%rbp)
	leaq	__stop_minfo(%rip), %rax
	movq	%rax, -24(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	_d_dso_registry@PLT
.L17:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	gdc.dso_ctor, .-gdc.dso_ctor
	.section	.text.gdc.dso_dtor,"axG",@progbits,gdc.dso_dtor,comdat
	.weak	gdc.dso_dtor
	.hidden	gdc.dso_dtor
	.type	gdc.dso_dtor, @function
gdc.dso_dtor:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movzbl	gdc.dso_initialized(%rip), %eax
	testb	%al, %al
	je	.L20
	movb	$0, gdc.dso_initialized(%rip)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movq	$0, -16(%rbp)
	movq	$0, -8(%rbp)
	movq	$1, -48(%rbp)
	leaq	gdc.dso_slot(%rip), %rax
	movq	%rax, -40(%rbp)
	leaq	__start_minfo(%rip), %rax
	movq	%rax, -32(%rbp)
	leaq	__stop_minfo(%rip), %rax
	movq	%rax, -24(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	_d_dso_registry@PLT
.L20:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	gdc.dso_dtor, .-gdc.dso_dtor
	.text
	.type	_GLOBAL__I_18dub_platform_probe, @function
_GLOBAL__I_18dub_platform_probe:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	gdc.dso_ctor
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	_GLOBAL__I_18dub_platform_probe, .-_GLOBAL__I_18dub_platform_probe
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__I_18dub_platform_probe
	.text
	.type	_GLOBAL__D_18dub_platform_probe, @function
_GLOBAL__D_18dub_platform_probe:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	gdc.dso_dtor
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	_GLOBAL__D_18dub_platform_probe, .-_GLOBAL__D_18dub_platform_probe
	.section	.fini_array,"aw"
	.align 8
	.quad	_GLOBAL__D_18dub_platform_probe
	.hidden	__stop_minfo
	.hidden	__start_minfo
	.ident	"GCC: (Ubuntu 8.2.0-1ubuntu2~18.04) 8.2.0"
	.section	.note.GNU-stack,"",@progbits
