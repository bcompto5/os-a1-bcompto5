
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	a9010113          	addi	sp,sp,-1392 # 80007a90 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd84f>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	e2e78793          	addi	a5,a5,-466 # 80000ea6 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	1ec020ef          	jal	80002308 <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7d6000ef          	jal	800008fe <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00010517          	auipc	a0,0x10
    80000198:	8fc50513          	addi	a0,a0,-1796 # 8000fa90 <cons>
    8000019c:	2a3000ef          	jal	80000c3e <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00010497          	auipc	s1,0x10
    800001a4:	8f048493          	addi	s1,s1,-1808 # 8000fa90 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00010917          	auipc	s2,0x10
    800001ac:	98090913          	addi	s2,s2,-1664 # 8000fb28 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	768010ef          	jal	80001928 <myproc>
    800001c4:	7c7010ef          	jal	8000218a <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	565010ef          	jal	80001f30 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	2f1000ef          	jal	80000cc2 <release>
      sleep();
    800001d6:	597010ef          	jal	80001f6c <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	263000ef          	jal	80000c3e <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00010717          	auipc	a4,0x10
    800001f2:	8a270713          	addi	a4,a4,-1886 # 8000fa90 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	09c020ef          	jal	800022bc <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00010517          	auipc	a0,0x10
    8000023c:	85850513          	addi	a0,a0,-1960 # 8000fa90 <cons>
    80000240:	283000ef          	jal	80000cc2 <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00010717          	auipc	a4,0x10
    80000262:	8cf72523          	sw	a5,-1846(a4) # 8000fb28 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	00010517          	auipc	a0,0x10
    80000278:	81c50513          	addi	a0,a0,-2020 # 8000fa90 <cons>
    8000027c:	247000ef          	jal	80000cc2 <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6ea000ef          	jal	80000984 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6dc000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6d4000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ce000ef          	jal	80000984 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	0000f517          	auipc	a0,0xf
    800002cc:	7c850513          	addi	a0,a0,1992 # 8000fa90 <cons>
    800002d0:	16f000ef          	jal	80000c3e <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	0af48163          	beq	s1,a5,80000378 <consoleintr+0xbc>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48663          	beq	s1,a5,800003cc <consoleintr+0x110>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49763          	bne	s1,a5,800003f4 <consoleintr+0x138>
  case C('P'): // Print process list.
    procdump();
    800002ea:	06a020ef          	jal	80002354 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	0000f517          	auipc	a0,0xf
    800002f2:	7a250513          	addi	a0,a0,1954 # 8000fa90 <cons>
    800002f6:	1cd000ef          	jal	80000cc2 <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0cf48263          	beq	s1,a5,800003cc <consoleintr+0x110>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	0000f717          	auipc	a4,0xf
    80000310:	78470713          	addi	a4,a4,1924 # 8000fa90 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48963          	beq	s1,a5,800003fa <consoleintr+0x13e>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	0000f717          	auipc	a4,0xf
    80000336:	75e70713          	addi	a4,a4,1886 # 8000fa90 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	00173713          	seqz	a4,a4
    8000035a:	14f1                	addi	s1,s1,-4
    8000035c:	0014b493          	seqz	s1,s1
    80000360:	8f45                	or	a4,a4,s1
    80000362:	e361                	bnez	a4,80000422 <consoleintr+0x166>
    80000364:	0000f717          	auipc	a4,0xf
    80000368:	7c472703          	lw	a4,1988(a4) # 8000fb28 <cons+0x98>
    8000036c:	9f99                	subw	a5,a5,a4
    8000036e:	08000713          	li	a4,128
    80000372:	f6e79ee3          	bne	a5,a4,800002ee <consoleintr+0x32>
    80000376:	a075                	j	80000422 <consoleintr+0x166>
    80000378:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000037a:	0000f717          	auipc	a4,0xf
    8000037e:	71670713          	addi	a4,a4,1814 # 8000fa90 <cons>
    80000382:	0a072783          	lw	a5,160(a4)
    80000386:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000038a:	0000f497          	auipc	s1,0xf
    8000038e:	70648493          	addi	s1,s1,1798 # 8000fa90 <cons>
    while (cons.e != cons.w &&
    80000392:	4929                	li	s2,10
    80000394:	02f70863          	beq	a4,a5,800003c4 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	07f7f713          	andi	a4,a5,127
    8000039e:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003a0:	01874703          	lbu	a4,24(a4)
    800003a4:	03270263          	beq	a4,s2,800003c8 <consoleintr+0x10c>
      cons.e--;
    800003a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ac:	10000513          	li	a0,256
    800003b0:	edbff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ee3          	bne	a4,a5,80000398 <consoleintr+0xdc>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    800003c4:	6902                	ld	s2,0(sp)
    800003c6:	b725                	j	800002ee <consoleintr+0x32>
    800003c8:	6902                	ld	s2,0(sp)
    800003ca:	b715                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003cc:	0000f717          	auipc	a4,0xf
    800003d0:	6c470713          	addi	a4,a4,1732 # 8000fa90 <cons>
    800003d4:	0a072783          	lw	a5,160(a4)
    800003d8:	09c72703          	lw	a4,156(a4)
    800003dc:	f0f709e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e0:	37fd                	addiw	a5,a5,-1
    800003e2:	0000f717          	auipc	a4,0xf
    800003e6:	74f72723          	sw	a5,1870(a4) # 8000fb30 <cons+0xa0>
      consputc(BACKSPACE);
    800003ea:	10000513          	li	a0,256
    800003ee:	e9dff0ef          	jal	8000028a <consputc>
    800003f2:	bdf5                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003f4:	ee048de3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f8:	bf11                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003fa:	4529                	li	a0,10
    800003fc:	e8fff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000400:	0000f797          	auipc	a5,0xf
    80000404:	69078793          	addi	a5,a5,1680 # 8000fa90 <cons>
    80000408:	0a07a703          	lw	a4,160(a5)
    8000040c:	0017069b          	addiw	a3,a4,1
    80000410:	8636                	mv	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	0000f797          	auipc	a5,0xf
    80000426:	70c7a523          	sw	a2,1802(a5) # 8000fb2c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	0000f517          	auipc	a0,0xf
    8000042e:	6fe50513          	addi	a0,a0,1790 # 8000fb28 <cons+0x98>
    80000432:	36b010ef          	jal	80001f9c <wakeup>
    80000436:	bd65                	j	800002ee <consoleintr+0x32>

0000000080000438 <consoleinit>:

void
consoleinit(void)
{
    80000438:	1141                	addi	sp,sp,-16
    8000043a:	e406                	sd	ra,8(sp)
    8000043c:	e022                	sd	s0,0(sp)
    8000043e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000440:	00007597          	auipc	a1,0x7
    80000444:	bc058593          	addi	a1,a1,-1088 # 80007000 <etext>
    80000448:	0000f517          	auipc	a0,0xf
    8000044c:	64850513          	addi	a0,a0,1608 # 8000fa90 <cons>
    80000450:	76e000ef          	jal	80000bbe <initlock>

  uartinit();
    80000454:	454000ef          	jal	800008a8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000458:	00020797          	auipc	a5,0x20
    8000045c:	9c078793          	addi	a5,a5,-1600 # 8001fe18 <devsw>
    80000460:	00000717          	auipc	a4,0x0
    80000464:	d1870713          	addi	a4,a4,-744 # 80000178 <consoleread>
    80000468:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000046a:	00000717          	auipc	a4,0x0
    8000046e:	c6c70713          	addi	a4,a4,-916 # 800000d6 <consolewrite>
    80000472:	ef98                	sd	a4,24(a5)
}
    80000474:	60a2                	ld	ra,8(sp)
    80000476:	6402                	ld	s0,0(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f04a                	sd	s2,32(sp)
    80000484:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000486:	c219                	beqz	a2,8000048c <printint+0x10>
    80000488:	08054063          	bltz	a0,80000508 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    8000048c:	4301                	li	t1,0

  i = 0;
    8000048e:	fc840913          	addi	s2,s0,-56
    x = xx;
    80000492:	86ca                	mv	a3,s2
  i = 0;
    80000494:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000496:	00007817          	auipc	a6,0x7
    8000049a:	3b280813          	addi	a6,a6,946 # 80007848 <digits>
    8000049e:	88ba                	mv	a7,a4
    800004a0:	0017061b          	addiw	a2,a4,1
    800004a4:	8732                	mv	a4,a2
    800004a6:	02b577b3          	remu	a5,a0,a1
    800004aa:	97c2                	add	a5,a5,a6
    800004ac:	0007c783          	lbu	a5,0(a5)
    800004b0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004b4:	87aa                	mv	a5,a0
    800004b6:	02b55533          	divu	a0,a0,a1
    800004ba:	0685                	addi	a3,a3,1
    800004bc:	feb7f1e3          	bgeu	a5,a1,8000049e <printint+0x22>

  if (sign)
    800004c0:	00030b63          	beqz	t1,800004d6 <printint+0x5a>
    buf[i++] = '-';
    800004c4:	fe040793          	addi	a5,s0,-32
    800004c8:	963e                	add	a2,a2,a5
    800004ca:	02d00793          	li	a5,45
    800004ce:	fef60423          	sb	a5,-24(a2)
    800004d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d6:	02e05463          	blez	a4,800004fe <printint+0x82>
    800004da:	f426                	sd	s1,40(sp)
    800004dc:	377d                	addiw	a4,a4,-1
    800004de:	00e904b3          	add	s1,s2,a4
    800004e2:	197d                	addi	s2,s2,-1
    800004e4:	993a                	add	s2,s2,a4
    800004e6:	1702                	slli	a4,a4,0x20
    800004e8:	9301                	srli	a4,a4,0x20
    800004ea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004ee:	0004c503          	lbu	a0,0(s1)
    800004f2:	d99ff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f6:	14fd                	addi	s1,s1,-1
    800004f8:	ff249be3          	bne	s1,s2,800004ee <printint+0x72>
    800004fc:	74a2                	ld	s1,40(sp)
}
    800004fe:	70e2                	ld	ra,56(sp)
    80000500:	7442                	ld	s0,48(sp)
    80000502:	7902                	ld	s2,32(sp)
    80000504:	6121                	addi	sp,sp,64
    80000506:	8082                	ret
    x = -xx;
    80000508:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    8000050c:	4305                	li	t1,1
    x = -xx;
    8000050e:	b741                	j	8000048e <printint+0x12>

0000000080000510 <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80000510:	7131                	addi	sp,sp,-192
    80000512:	fc86                	sd	ra,120(sp)
    80000514:	f8a2                	sd	s0,112(sp)
    80000516:	f4a6                	sd	s1,104(sp)
    80000518:	0100                	addi	s0,sp,128
    8000051a:	84aa                	mv	s1,a0
    8000051c:	e40c                	sd	a1,8(s0)
    8000051e:	e810                	sd	a2,16(s0)
    80000520:	ec14                	sd	a3,24(s0)
    80000522:	f018                	sd	a4,32(s0)
    80000524:	f41c                	sd	a5,40(s0)
    80000526:	03043823          	sd	a6,48(s0)
    8000052a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000052e:	00007797          	auipc	a5,0x7
    80000532:	5367a783          	lw	a5,1334(a5) # 80007a64 <panicking>
    80000536:	cf9d                	beqz	a5,80000574 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000540:	0004c503          	lbu	a0,0(s1)
    80000544:	22050363          	beqz	a0,8000076a <printk+0x25a>
    80000548:	f0ca                	sd	s2,96(sp)
    8000054a:	ecce                	sd	s3,88(sp)
    8000054c:	e8d2                	sd	s4,80(sp)
    8000054e:	e4d6                	sd	s5,72(sp)
    80000550:	e0da                	sd	s6,64(sp)
    80000552:	fc5e                	sd	s7,56(sp)
    80000554:	f862                	sd	s8,48(sp)
    80000556:	f06a                	sd	s10,32(sp)
    80000558:	ec6e                	sd	s11,24(sp)
    8000055a:	4a01                	li	s4,0
    if (cx != '%') {
    8000055c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000560:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000564:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000568:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000056c:	4b29                	li	s6,10
    if (c0 == 'd') {
    8000056e:	06400b93          	li	s7,100
    80000572:	a015                	j	80000596 <printk+0x86>
    acquire(&pr.lock);
    80000574:	0000f517          	auipc	a0,0xf
    80000578:	5c450513          	addi	a0,a0,1476 # 8000fb38 <pr>
    8000057c:	6c2000ef          	jal	80000c3e <acquire>
    80000580:	bf65                	j	80000538 <printk+0x28>
      consputc(cx);
    80000582:	d09ff0ef          	jal	8000028a <consputc>
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000586:	001a079b          	addiw	a5,s4,1
    8000058a:	8a3e                	mv	s4,a5
    8000058c:	97a6                	add	a5,a5,s1
    8000058e:	0007c503          	lbu	a0,0(a5)
    80000592:	1c050363          	beqz	a0,80000758 <printk+0x248>
    if (cx != '%') {
    80000596:	ff3516e3          	bne	a0,s3,80000582 <printk+0x72>
    i++;
    8000059a:	001a091b          	addiw	s2,s4,1
    c0 = fmt[i + 0] & 0xff;
    8000059e:	012487b3          	add	a5,s1,s2
    800005a2:	0007ca83          	lbu	s5,0(a5)
    if (c0)
    800005a6:	200a8763          	beqz	s5,800007b4 <printk+0x2a4>
      c1 = fmt[i + 1] & 0xff;
    800005aa:	0017c703          	lbu	a4,1(a5)
    if (c1)
    800005ae:	1e070a63          	beqz	a4,800007a2 <printk+0x292>
    if (c0 == 'd') {
    800005b2:	037a8963          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b6:	f94a8793          	addi	a5,s5,-108
    800005ba:	0017b793          	seqz	a5,a5
    800005be:	f9c70693          	addi	a3,a4,-100
    800005c2:	0016b693          	seqz	a3,a3
    800005c6:	8efd                	and	a3,a3,a5
    800005c8:	ca9d                	beqz	a3,800005fe <printk+0xee>
      printint(va_arg(ap, uint64), 10, 1);
    800005ca:	f8843783          	ld	a5,-120(s0)
    800005ce:	00878713          	addi	a4,a5,8
    800005d2:	f8e43423          	sd	a4,-120(s0)
    800005d6:	4605                	li	a2,1
    800005d8:	85da                	mv	a1,s6
    800005da:	6388                	ld	a0,0(a5)
    800005dc:	ea1ff0ef          	jal	8000047c <printint>
      i += 1;
    800005e0:	2a09                	addiw	s4,s4,2
    800005e2:	b755                	j	80000586 <printk+0x76>
      printint(va_arg(ap, int), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	addi	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	85da                	mv	a1,s6
    800005f4:	4388                	lw	a0,0(a5)
    800005f6:	e87ff0ef          	jal	8000047c <printint>
    i++;
    800005fa:	8a4a                	mv	s4,s2
    800005fc:	b769                	j	80000586 <printk+0x76>
      c2 = fmt[i + 2] & 0xff;
    800005fe:	012486b3          	add	a3,s1,s2
    80000602:	863a                	mv	a2,a4
    80000604:	0026c703          	lbu	a4,2(a3)
    80000608:	aa65                	j	800007c0 <printk+0x2b0>
      printint(va_arg(ap, uint64), 10, 1);
    8000060a:	f8843783          	ld	a5,-120(s0)
    8000060e:	00878713          	addi	a4,a5,8
    80000612:	f8e43423          	sd	a4,-120(s0)
    80000616:	4605                	li	a2,1
    80000618:	45a9                	li	a1,10
    8000061a:	6388                	ld	a0,0(a5)
    8000061c:	e61ff0ef          	jal	8000047c <printint>
      i += 2;
    80000620:	2a0d                	addiw	s4,s4,3
    80000622:	b795                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 10, 0);
    80000624:	f8843783          	ld	a5,-120(s0)
    80000628:	00878713          	addi	a4,a5,8
    8000062c:	f8e43423          	sd	a4,-120(s0)
    80000630:	4601                	li	a2,0
    80000632:	85da                	mv	a1,s6
    80000634:	0007e503          	lwu	a0,0(a5)
    80000638:	e45ff0ef          	jal	8000047c <printint>
    8000063c:	bf7d                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 10, 0);
    8000063e:	f8843783          	ld	a5,-120(s0)
    80000642:	00878713          	addi	a4,a5,8
    80000646:	f8e43423          	sd	a4,-120(s0)
    8000064a:	4601                	li	a2,0
    8000064c:	85da                	mv	a1,s6
    8000064e:	6388                	ld	a0,0(a5)
    80000650:	e2dff0ef          	jal	8000047c <printint>
      i += 1;
    80000654:	2a09                	addiw	s4,s4,2
    80000656:	bf05                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 10, 0);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4601                	li	a2,0
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	e13ff0ef          	jal	8000047c <printint>
      i += 2;
    8000066e:	2a0d                	addiw	s4,s4,3
    80000670:	bf19                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 16, 0);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4601                	li	a2,0
    80000680:	45c1                	li	a1,16
    80000682:	0007e503          	lwu	a0,0(a5)
    80000686:	df7ff0ef          	jal	8000047c <printint>
    8000068a:	bf85                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 16, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45c1                	li	a1,16
    8000069c:	6388                	ld	a0,0(a5)
    8000069e:	ddfff0ef          	jal	8000047c <printint>
      i += 1;
    800006a2:	2a09                	addiw	s4,s4,2
    800006a4:	b5cd                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 16, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	45c1                	li	a1,16
    800006b4:	6388                	ld	a0,0(a5)
    800006b6:	dc7ff0ef          	jal	8000047c <printint>
      i += 2;
    800006ba:	2a0d                	addiw	s4,s4,3
    800006bc:	b5e9                	j	80000586 <printk+0x76>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	166c8c93          	addi	s9,s9,358 # 80007848 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1da>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	bde5                	j	800005fa <printk+0xea>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5d5                	j	800005fa <printk+0xea>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x232>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	ec0505e3          	beqz	a0,800005fa <printk+0xea>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x224>
    80000740:	bd6d                	j	800005fa <printk+0xea>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x224>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b555                	j	800005fa <printk+0xea>
    80000758:	7906                	ld	s2,96(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	00007797          	auipc	a5,0x7
    8000076e:	2fa7a783          	lw	a5,762(a5) # 80007a64 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x284>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	74a6                	ld	s1,104(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	7906                	ld	s2,96(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x25a>
    release(&pr.lock);
    80000794:	0000f517          	auipc	a0,0xf
    80000798:	3a450513          	addi	a0,a0,932 # 8000fb38 <pr>
    8000079c:	526000ef          	jal	80000cc2 <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x264>
    if (c0 == 'd') {
    800007a2:	e57a81e3          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8793          	addi	a5,s5,-108
    800007aa:	0017b793          	seqz	a5,a5
    800007ae:	863a                	mv	a2,a4
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4681                	li	a3,0
    800007b2:	a01d                	j	800007d8 <printk+0x2c8>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8793          	addi	a5,s5,-108
    800007b8:	0017b793          	seqz	a5,a5
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	8756                	mv	a4,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460693          	addi	a3,a2,-108
    800007c4:	0016b693          	seqz	a3,a3
    800007c8:	8efd                	and	a3,a3,a5
    800007ca:	f9c70593          	addi	a1,a4,-100
    800007ce:	0015b593          	seqz	a1,a1
    800007d2:	8df5                	and	a1,a1,a3
    800007d4:	e2059be3          	bnez	a1,8000060a <printk+0xfa>
    } else if (c0 == 'u') {
    800007d8:	e58a86e3          	beq	s5,s8,80000624 <printk+0x114>
    } else if (c0 == 'l' && c1 == 'u') {
    800007dc:	f8b60593          	addi	a1,a2,-117
    800007e0:	0015b593          	seqz	a1,a1
    800007e4:	8dfd                	and	a1,a1,a5
    800007e6:	e4059ce3          	bnez	a1,8000063e <printk+0x12e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007ea:	f8b70593          	addi	a1,a4,-117
    800007ee:	0015b593          	seqz	a1,a1
    800007f2:	8df5                	and	a1,a1,a3
    800007f4:	e60592e3          	bnez	a1,80000658 <printk+0x148>
    } else if (c0 == 'x') {
    800007f8:	e7aa8de3          	beq	s5,s10,80000672 <printk+0x162>
    } else if (c0 == 'l' && c1 == 'x') {
    800007fc:	f8860613          	addi	a2,a2,-120
    80000800:	00163613          	seqz	a2,a2
    80000804:	8e7d                	and	a2,a2,a5
    80000806:	e80613e3          	bnez	a2,8000068c <printk+0x17c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000080a:	f8870713          	addi	a4,a4,-120
    8000080e:	00173713          	seqz	a4,a4
    80000812:	8f75                	and	a4,a4,a3
    80000814:	e80719e3          	bnez	a4,800006a6 <printk+0x196>
    } else if (c0 == 'p') {
    80000818:	ebba83e3          	beq	s5,s11,800006be <printk+0x1ae>
    } else if (c0 == 'c') {
    8000081c:	06300793          	li	a5,99
    80000820:	eefa82e3          	beq	s5,a5,80000704 <printk+0x1f4>
    } else if (c0 == 's') {
    80000824:	07300793          	li	a5,115
    80000828:	eefa88e3          	beq	s5,a5,80000718 <printk+0x208>
    } else if (c0 == '%') {
    8000082c:	02500793          	li	a5,37
    80000830:	f2fa80e3          	beq	s5,a5,80000750 <printk+0x240>
    } else if (c0 == 0) {
    80000834:	f40a86e3          	beqz	s5,80000780 <printk+0x270>
      consputc('%');
    80000838:	02500513          	li	a0,37
    8000083c:	a4fff0ef          	jal	8000028a <consputc>
      consputc(c0);
    80000840:	8556                	mv	a0,s5
    80000842:	a49ff0ef          	jal	8000028a <consputc>
    80000846:	bb55                	j	800005fa <printk+0xea>

0000000080000848 <panic>:

void
panic(char *s)
{
    80000848:	1101                	addi	sp,sp,-32
    8000084a:	ec06                	sd	ra,24(sp)
    8000084c:	e822                	sd	s0,16(sp)
    8000084e:	e426                	sd	s1,8(sp)
    80000850:	e04a                	sd	s2,0(sp)
    80000852:	1000                	addi	s0,sp,32
    80000854:	892a                	mv	s2,a0
  panicking = 1;
    80000856:	4485                	li	s1,1
    80000858:	00007797          	auipc	a5,0x7
    8000085c:	2097a623          	sw	s1,524(a5) # 80007a64 <panicking>
  printk("panic: ");
    80000860:	00006517          	auipc	a0,0x6
    80000864:	7b850513          	addi	a0,a0,1976 # 80007018 <etext+0x18>
    80000868:	ca9ff0ef          	jal	80000510 <printk>
  printk("%s\n", s);
    8000086c:	85ca                	mv	a1,s2
    8000086e:	00006517          	auipc	a0,0x6
    80000872:	7b250513          	addi	a0,a0,1970 # 80007020 <etext+0x20>
    80000876:	c9bff0ef          	jal	80000510 <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000087a:	00007797          	auipc	a5,0x7
    8000087e:	1e97a323          	sw	s1,486(a5) # 80007a60 <panicked>
  for (;;)
    80000882:	a001                	j	80000882 <panic+0x3a>

0000000080000884 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000088c:	00006597          	auipc	a1,0x6
    80000890:	79c58593          	addi	a1,a1,1948 # 80007028 <etext+0x28>
    80000894:	0000f517          	auipc	a0,0xf
    80000898:	2a450513          	addi	a0,a0,676 # 8000fb38 <pr>
    8000089c:	322000ef          	jal	80000bbe <initlock>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    800008a8:	1141                	addi	sp,sp,-16
    800008aa:	e406                	sd	ra,8(sp)
    800008ac:	e022                	sd	s0,0(sp)
    800008ae:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800008b0:	100007b7          	lui	a5,0x10000
    800008b4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008b8:	10000737          	lui	a4,0x10000
    800008bc:	f8000693          	li	a3,-128
    800008c0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008c4:	468d                	li	a3,3
    800008c6:	10000637          	lui	a2,0x10000
    800008ca:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ce:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008d2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008d6:	8732                	mv	a4,a2
    800008d8:	461d                	li	a2,7
    800008da:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008de:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008e2:	00006597          	auipc	a1,0x6
    800008e6:	74e58593          	addi	a1,a1,1870 # 80007030 <etext+0x30>
    800008ea:	0000f517          	auipc	a0,0xf
    800008ee:	26650513          	addi	a0,a0,614 # 8000fb50 <tx_lock>
    800008f2:	21f030ef          	jal	80004310 <initsleeplock>
}
    800008f6:	60a2                	ld	ra,8(sp)
    800008f8:	6402                	ld	s0,0(sp)
    800008fa:	0141                	addi	sp,sp,16
    800008fc:	8082                	ret

00000000800008fe <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008fe:	7139                	addi	sp,sp,-64
    80000900:	fc06                	sd	ra,56(sp)
    80000902:	f822                	sd	s0,48(sp)
    80000904:	f04a                	sd	s2,32(sp)
    80000906:	e456                	sd	s5,8(sp)
    80000908:	0080                	addi	s0,sp,64
    8000090a:	8aaa                	mv	s5,a0
    8000090c:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    8000090e:	0000f517          	auipc	a0,0xf
    80000912:	24250513          	addi	a0,a0,578 # 8000fb50 <tx_lock>
    80000916:	231030ef          	jal	80004346 <acquiresleep>

  int i = 0;
  while (i < n) {
    8000091a:	05205963          	blez	s2,8000096c <uartwrite+0x6e>
    8000091e:	f426                	sd	s1,40(sp)
    80000920:	ec4e                	sd	s3,24(sp)
    80000922:	e852                	sd	s4,16(sp)
    80000924:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000926:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000928:	00007a17          	auipc	s4,0x7
    8000092c:	140a0a13          	addi	s4,s4,320 # 80007a68 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000930:	100009b7          	lui	s3,0x10000
    80000934:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000936:	10000b37          	lui	s6,0x10000
    8000093a:	a029                	j	80000944 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    8000093c:	630010ef          	jal	80001f6c <sleep>
  while (i < n) {
    80000940:	0324d263          	bge	s1,s2,80000964 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000944:	8552                	mv	a0,s4
    80000946:	5ea010ef          	jal	80001f30 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000094a:	0009c783          	lbu	a5,0(s3)
    8000094e:	0207f793          	andi	a5,a5,32
    80000952:	d7ed                	beqz	a5,8000093c <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000954:	009a87b3          	add	a5,s5,s1
    80000958:	0007c783          	lbu	a5,0(a5)
    8000095c:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    80000960:	2485                	addiw	s1,s1,1
    80000962:	bff9                	j	80000940 <uartwrite+0x42>
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	69e2                	ld	s3,24(sp)
    80000968:	6a42                	ld	s4,16(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    8000096c:	0000f517          	auipc	a0,0xf
    80000970:	1e450513          	addi	a0,a0,484 # 8000fb50 <tx_lock>
    80000974:	227030ef          	jal	8000439a <releasesleep>
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	7902                	ld	s2,32(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret

0000000080000984 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000984:	1101                	addi	sp,sp,-32
    80000986:	ec06                	sd	ra,24(sp)
    80000988:	e822                	sd	s0,16(sp)
    8000098a:	e426                	sd	s1,8(sp)
    8000098c:	1000                	addi	s0,sp,32
    8000098e:	84aa                	mv	s1,a0
  if (panicking == 0)
    80000990:	00007797          	auipc	a5,0x7
    80000994:	0d47a783          	lw	a5,212(a5) # 80007a64 <panicking>
    80000998:	cb91                	beqz	a5,800009ac <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    8000099a:	00007797          	auipc	a5,0x7
    8000099e:	0c67a783          	lw	a5,198(a5) # 80007a60 <panicked>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009a2:	10000737          	lui	a4,0x10000
    800009a6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
  if (panicked) {
    800009a8:	c789                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    for (;;)
    800009aa:	a001                	j	800009aa <uartputc_sync+0x26>
    push_off();
    800009ac:	258000ef          	jal	80000c04 <push_off>
    800009b0:	b7ed                	j	8000099a <uartputc_sync+0x16>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009b2:	00074783          	lbu	a5,0(a4)
    800009b6:	0207f793          	andi	a5,a5,32
    800009ba:	dfe5                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    ;
  WriteReg(THR, c);
    800009bc:	100007b7          	lui	a5,0x10000
    800009c0:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009c4:	00007797          	auipc	a5,0x7
    800009c8:	0a07a783          	lw	a5,160(a5) # 80007a64 <panicking>
    800009cc:	c791                	beqz	a5,800009d8 <uartputc_sync+0x54>
    pop_off();
}
    800009ce:	60e2                	ld	ra,24(sp)
    800009d0:	6442                	ld	s0,16(sp)
    800009d2:	64a2                	ld	s1,8(sp)
    800009d4:	6105                	addi	sp,sp,32
    800009d6:	8082                	ret
    pop_off();
    800009d8:	2a2000ef          	jal	80000c7a <pop_off>
}
    800009dc:	bfcd                	j	800009ce <uartputc_sync+0x4a>

00000000800009de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	e04a                	sd	s2,0(sp)
    800009e8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ea:	100007b7          	lui	a5,0x10000
    800009ee:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009f2:	100007b7          	lui	a5,0x10000
    800009f6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009fa:	0207f793          	andi	a5,a5,32
    800009fe:	ef99                	bnez	a5,80000a1c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a00:	100004b7          	lui	s1,0x10000
    80000a04:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a06:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a0a:	0004c783          	lbu	a5,0(s1)
    80000a0e:	8b85                	andi	a5,a5,1
    80000a10:	cf89                	beqz	a5,80000a2a <uartintr+0x4c>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a12:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
    80000a16:	8a7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a1a:	bfc5                	j	80000a0a <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a1c:	00007517          	auipc	a0,0x7
    80000a20:	04c50513          	addi	a0,a0,76 # 80007a68 <tx_chan>
    80000a24:	578010ef          	jal	80001f9c <wakeup>
    80000a28:	bfe1                	j	80000a00 <uartintr+0x22>
  }
}
    80000a2a:	60e2                	ld	ra,24(sp)
    80000a2c:	6442                	ld	s0,16(sp)
    80000a2e:	64a2                	ld	s1,8(sp)
    80000a30:	6902                	ld	s2,0(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret

0000000080000a36 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a36:	1101                	addi	sp,sp,-32
    80000a38:	ec06                	sd	ra,24(sp)
    80000a3a:	e822                	sd	s0,16(sp)
    80000a3c:	e426                	sd	s1,8(sp)
    80000a3e:	e04a                	sd	s2,0(sp)
    80000a40:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a42:	00020797          	auipc	a5,0x20
    80000a46:	56e78793          	addi	a5,a5,1390 # 80020fb0 <end>
    80000a4a:	00f53733          	sltu	a4,a0,a5
    80000a4e:	47c5                	li	a5,17
    80000a50:	07ee                	slli	a5,a5,0x1b
    80000a52:	17fd                	addi	a5,a5,-1
    80000a54:	00a7b7b3          	sltu	a5,a5,a0
    80000a58:	8fd9                	or	a5,a5,a4
    80000a5a:	03451713          	slli	a4,a0,0x34
    80000a5e:	8fd9                	or	a5,a5,a4
    80000a60:	eb9d                	bnez	a5,80000a96 <kfree+0x60>
    80000a62:	84aa                	mv	s1,a0
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	4585                	li	a1,1
    80000a68:	292000ef          	jal	80000cfa <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a6c:	0000f917          	auipc	s2,0xf
    80000a70:	11490913          	addi	s2,s2,276 # 8000fb80 <kmem>
    80000a74:	854a                	mv	a0,s2
    80000a76:	1c8000ef          	jal	80000c3e <acquire>
  r->next = kmem.freelist;
    80000a7a:	01893783          	ld	a5,24(s2)
    80000a7e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a80:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a84:	854a                	mv	a0,s2
    80000a86:	23c000ef          	jal	80000cc2 <release>
}
    80000a8a:	60e2                	ld	ra,24(sp)
    80000a8c:	6442                	ld	s0,16(sp)
    80000a8e:	64a2                	ld	s1,8(sp)
    80000a90:	6902                	ld	s2,0(sp)
    80000a92:	6105                	addi	sp,sp,32
    80000a94:	8082                	ret
    panic("kfree");
    80000a96:	00006517          	auipc	a0,0x6
    80000a9a:	5a250513          	addi	a0,a0,1442 # 80007038 <etext+0x38>
    80000a9e:	dabff0ef          	jal	80000848 <panic>

0000000080000aa2 <freerange>:
{
    80000aa2:	7179                	addi	sp,sp,-48
    80000aa4:	f406                	sd	ra,40(sp)
    80000aa6:	f022                	sd	s0,32(sp)
    80000aa8:	ec26                	sd	s1,24(sp)
    80000aaa:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000aac:	6785                	lui	a5,0x1
    80000aae:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab2:	00e504b3          	add	s1,a0,a4
    80000ab6:	777d                	lui	a4,0xfffff
    80000ab8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	94be                	add	s1,s1,a5
    80000abc:	0295e263          	bltu	a1,s1,80000ae0 <freerange+0x3e>
    80000ac0:	e84a                	sd	s2,16(sp)
    80000ac2:	e44e                	sd	s3,8(sp)
    80000ac4:	e052                	sd	s4,0(sp)
    80000ac6:	892e                	mv	s2,a1
    kfree(p);
    80000ac8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aca:	89be                	mv	s3,a5
    kfree(p);
    80000acc:	01448533          	add	a0,s1,s4
    80000ad0:	f67ff0ef          	jal	80000a36 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ad4:	94ce                	add	s1,s1,s3
    80000ad6:	fe997be3          	bgeu	s2,s1,80000acc <freerange+0x2a>
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
}
    80000ae0:	70a2                	ld	ra,40(sp)
    80000ae2:	7402                	ld	s0,32(sp)
    80000ae4:	64e2                	ld	s1,24(sp)
    80000ae6:	6145                	addi	sp,sp,48
    80000ae8:	8082                	ret

0000000080000aea <kinit>:
{
    80000aea:	1141                	addi	sp,sp,-16
    80000aec:	e406                	sd	ra,8(sp)
    80000aee:	e022                	sd	s0,0(sp)
    80000af0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af2:	00006597          	auipc	a1,0x6
    80000af6:	54e58593          	addi	a1,a1,1358 # 80007040 <etext+0x40>
    80000afa:	0000f517          	auipc	a0,0xf
    80000afe:	08650513          	addi	a0,a0,134 # 8000fb80 <kmem>
    80000b02:	0bc000ef          	jal	80000bbe <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b06:	45c5                	li	a1,17
    80000b08:	05ee                	slli	a1,a1,0x1b
    80000b0a:	00020517          	auipc	a0,0x20
    80000b0e:	4a650513          	addi	a0,a0,1190 # 80020fb0 <end>
    80000b12:	f91ff0ef          	jal	80000aa2 <freerange>
}
    80000b16:	60a2                	ld	ra,8(sp)
    80000b18:	6402                	ld	s0,0(sp)
    80000b1a:	0141                	addi	sp,sp,16
    80000b1c:	8082                	ret

0000000080000b1e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b1e:	1101                	addi	sp,sp,-32
    80000b20:	ec06                	sd	ra,24(sp)
    80000b22:	e822                	sd	s0,16(sp)
    80000b24:	e426                	sd	s1,8(sp)
    80000b26:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b28:	0000f517          	auipc	a0,0xf
    80000b2c:	05850513          	addi	a0,a0,88 # 8000fb80 <kmem>
    80000b30:	10e000ef          	jal	80000c3e <acquire>
  r = kmem.freelist;
    80000b34:	0000f497          	auipc	s1,0xf
    80000b38:	0644b483          	ld	s1,100(s1) # 8000fb98 <kmem+0x18>
  if (r)
    80000b3c:	c49d                	beqz	s1,80000b6a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b3e:	609c                	ld	a5,0(s1)
    80000b40:	0000f717          	auipc	a4,0xf
    80000b44:	04f73c23          	sd	a5,88(a4) # 8000fb98 <kmem+0x18>
  release(&kmem.lock);
    80000b48:	0000f517          	auipc	a0,0xf
    80000b4c:	03850513          	addi	a0,a0,56 # 8000fb80 <kmem>
    80000b50:	172000ef          	jal	80000cc2 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	1a0000ef          	jal	80000cfa <memset>
  return (void *)r;
}
    80000b5e:	8526                	mv	a0,s1
    80000b60:	60e2                	ld	ra,24(sp)
    80000b62:	6442                	ld	s0,16(sp)
    80000b64:	64a2                	ld	s1,8(sp)
    80000b66:	6105                	addi	sp,sp,32
    80000b68:	8082                	ret
  release(&kmem.lock);
    80000b6a:	0000f517          	auipc	a0,0xf
    80000b6e:	01650513          	addi	a0,a0,22 # 8000fb80 <kmem>
    80000b72:	150000ef          	jal	80000cc2 <release>
  if (r)
    80000b76:	b7e5                	j	80000b5e <kalloc+0x40>

0000000080000b78 <freemem>:

uint64
freemem(void)
{
    80000b78:	1101                	addi	sp,sp,-32
    80000b7a:	ec06                	sd	ra,24(sp)
    80000b7c:	e822                	sd	s0,16(sp)
    80000b7e:	e426                	sd	s1,8(sp)
    80000b80:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 pages = 0;

  acquire(&kmem.lock);
    80000b82:	0000f517          	auipc	a0,0xf
    80000b86:	ffe50513          	addi	a0,a0,-2 # 8000fb80 <kmem>
    80000b8a:	0b4000ef          	jal	80000c3e <acquire>
  r = kmem.freelist;
    80000b8e:	0000f797          	auipc	a5,0xf
    80000b92:	00a7b783          	ld	a5,10(a5) # 8000fb98 <kmem+0x18>
  while (r) {
    80000b96:	c395                	beqz	a5,80000bba <freemem+0x42>
  uint64 pages = 0;
    80000b98:	4481                	li	s1,0
    pages++;
    80000b9a:	0485                	addi	s1,s1,1
    r = r->next;
    80000b9c:	639c                	ld	a5,0(a5)
  while (r) {
    80000b9e:	fff5                	bnez	a5,80000b9a <freemem+0x22>
  }
  release(&kmem.lock);
    80000ba0:	0000f517          	auipc	a0,0xf
    80000ba4:	fe050513          	addi	a0,a0,-32 # 8000fb80 <kmem>
    80000ba8:	11a000ef          	jal	80000cc2 <release>

  return pages * PGSIZE;
}
    80000bac:	00c49513          	slli	a0,s1,0xc
    80000bb0:	60e2                	ld	ra,24(sp)
    80000bb2:	6442                	ld	s0,16(sp)
    80000bb4:	64a2                	ld	s1,8(sp)
    80000bb6:	6105                	addi	sp,sp,32
    80000bb8:	8082                	ret
  uint64 pages = 0;
    80000bba:	4481                	li	s1,0
    80000bbc:	b7d5                	j	80000ba0 <freemem+0x28>

0000000080000bbe <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bbe:	1141                	addi	sp,sp,-16
    80000bc0:	e406                	sd	ra,8(sp)
    80000bc2:	e022                	sd	s0,0(sp)
    80000bc4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bc6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bc8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bcc:	00053823          	sd	zero,16(a0)
}
    80000bd0:	60a2                	ld	ra,8(sp)
    80000bd2:	6402                	ld	s0,0(sp)
    80000bd4:	0141                	addi	sp,sp,16
    80000bd6:	8082                	ret

0000000080000bd8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bd8:	411c                	lw	a5,0(a0)
    80000bda:	e399                	bnez	a5,80000be0 <holding+0x8>
    80000bdc:	4501                	li	a0,0
  return r;
}
    80000bde:	8082                	ret
{
    80000be0:	1101                	addi	sp,sp,-32
    80000be2:	ec06                	sd	ra,24(sp)
    80000be4:	e822                	sd	s0,16(sp)
    80000be6:	e426                	sd	s1,8(sp)
    80000be8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bea:	691c                	ld	a5,16(a0)
    80000bec:	84be                	mv	s1,a5
    80000bee:	51b000ef          	jal	80001908 <mycpu>
    80000bf2:	40a48533          	sub	a0,s1,a0
    80000bf6:	00153513          	seqz	a0,a0
}
    80000bfa:	60e2                	ld	ra,24(sp)
    80000bfc:	6442                	ld	s0,16(sp)
    80000bfe:	64a2                	ld	s1,8(sp)
    80000c00:	6105                	addi	sp,sp,32
    80000c02:	8082                	ret

0000000080000c04 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c04:	1101                	addi	sp,sp,-32
    80000c06:	ec06                	sd	ra,24(sp)
    80000c08:	e822                	sd	s0,16(sp)
    80000c0a:	e426                	sd	s1,8(sp)
    80000c0c:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000c0e:	100177f3          	csrrci	a5,sstatus,2
    80000c12:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000c14:	4f5000ef          	jal	80001908 <mycpu>
    80000c18:	5d3c                	lw	a5,120(a0)
    80000c1a:	cb99                	beqz	a5,80000c30 <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c1c:	4ed000ef          	jal	80001908 <mycpu>
    80000c20:	5d3c                	lw	a5,120(a0)
    80000c22:	2785                	addiw	a5,a5,1
    80000c24:	dd3c                	sw	a5,120(a0)
}
    80000c26:	60e2                	ld	ra,24(sp)
    80000c28:	6442                	ld	s0,16(sp)
    80000c2a:	64a2                	ld	s1,8(sp)
    80000c2c:	6105                	addi	sp,sp,32
    80000c2e:	8082                	ret
    mycpu()->intena = old;
    80000c30:	4d9000ef          	jal	80001908 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000c34:	0014d793          	srli	a5,s1,0x1
    80000c38:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000c3a:	dd7c                	sw	a5,124(a0)
    80000c3c:	b7c5                	j	80000c1c <push_off+0x18>

0000000080000c3e <acquire>:
{
    80000c3e:	1101                	addi	sp,sp,-32
    80000c40:	ec06                	sd	ra,24(sp)
    80000c42:	e822                	sd	s0,16(sp)
    80000c44:	e426                	sd	s1,8(sp)
    80000c46:	1000                	addi	s0,sp,32
    80000c48:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c4a:	fbbff0ef          	jal	80000c04 <push_off>
  if (holding(lk))
    80000c4e:	8526                	mv	a0,s1
    80000c50:	f89ff0ef          	jal	80000bd8 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c54:	4705                	li	a4,1
  if (holding(lk))
    80000c56:	ed01                	bnez	a0,80000c6e <acquire+0x30>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c58:	0ce4a7af          	amoswap.w.aq	a5,a4,(s1)
    80000c5c:	fff5                	bnez	a5,80000c58 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c5e:	4ab000ef          	jal	80001908 <mycpu>
    80000c62:	e888                	sd	a0,16(s1)
}
    80000c64:	60e2                	ld	ra,24(sp)
    80000c66:	6442                	ld	s0,16(sp)
    80000c68:	64a2                	ld	s1,8(sp)
    80000c6a:	6105                	addi	sp,sp,32
    80000c6c:	8082                	ret
    panic("acquire");
    80000c6e:	00006517          	auipc	a0,0x6
    80000c72:	3da50513          	addi	a0,a0,986 # 80007048 <etext+0x48>
    80000c76:	bd3ff0ef          	jal	80000848 <panic>

0000000080000c7a <pop_off>:

void
pop_off(void)
{
    80000c7a:	1141                	addi	sp,sp,-16
    80000c7c:	e406                	sd	ra,8(sp)
    80000c7e:	e022                	sd	s0,0(sp)
    80000c80:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c82:	487000ef          	jal	80001908 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c8a:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c8c:	ef99                	bnez	a5,80000caa <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c8e:	5d3c                	lw	a5,120(a0)
    80000c90:	02f05363          	blez	a5,80000cb6 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c94:	37fd                	addiw	a5,a5,-1
    80000c96:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c98:	e789                	bnez	a5,80000ca2 <pop_off+0x28>
    80000c9a:	5d7c                	lw	a5,124(a0)
    80000c9c:	c399                	beqz	a5,80000ca2 <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c9e:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000ca2:	60a2                	ld	ra,8(sp)
    80000ca4:	6402                	ld	s0,0(sp)
    80000ca6:	0141                	addi	sp,sp,16
    80000ca8:	8082                	ret
    panic("pop_off - interruptible");
    80000caa:	00006517          	auipc	a0,0x6
    80000cae:	3a650513          	addi	a0,a0,934 # 80007050 <etext+0x50>
    80000cb2:	b97ff0ef          	jal	80000848 <panic>
    panic("pop_off");
    80000cb6:	00006517          	auipc	a0,0x6
    80000cba:	3b250513          	addi	a0,a0,946 # 80007068 <etext+0x68>
    80000cbe:	b8bff0ef          	jal	80000848 <panic>

0000000080000cc2 <release>:
{
    80000cc2:	1101                	addi	sp,sp,-32
    80000cc4:	ec06                	sd	ra,24(sp)
    80000cc6:	e822                	sd	s0,16(sp)
    80000cc8:	e426                	sd	s1,8(sp)
    80000cca:	1000                	addi	s0,sp,32
    80000ccc:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000cce:	f0bff0ef          	jal	80000bd8 <holding>
    80000cd2:	cd11                	beqz	a0,80000cee <release+0x2c>
  lk->cpu = 0;
    80000cd4:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000cd8:	0310000f          	fence	rw,w
    80000cdc:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000ce0:	f9bff0ef          	jal	80000c7a <pop_off>
}
    80000ce4:	60e2                	ld	ra,24(sp)
    80000ce6:	6442                	ld	s0,16(sp)
    80000ce8:	64a2                	ld	s1,8(sp)
    80000cea:	6105                	addi	sp,sp,32
    80000cec:	8082                	ret
    panic("release");
    80000cee:	00006517          	auipc	a0,0x6
    80000cf2:	38250513          	addi	a0,a0,898 # 80007070 <etext+0x70>
    80000cf6:	b53ff0ef          	jal	80000848 <panic>

0000000080000cfa <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e406                	sd	ra,8(sp)
    80000cfe:	e022                	sd	s0,0(sp)
    80000d00:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000d02:	ca19                	beqz	a2,80000d18 <memset+0x1e>
    80000d04:	87aa                	mv	a5,a0
    80000d06:	1602                	slli	a2,a2,0x20
    80000d08:	9201                	srli	a2,a2,0x20
    80000d0a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000d12:	0785                	addi	a5,a5,1
    80000d14:	fee79de3          	bne	a5,a4,80000d0e <memset+0x14>
  }
  return dst;
}
    80000d18:	60a2                	ld	ra,8(sp)
    80000d1a:	6402                	ld	s0,0(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret

0000000080000d20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d20:	1141                	addi	sp,sp,-16
    80000d22:	e406                	sd	ra,8(sp)
    80000d24:	e022                	sd	s0,0(sp)
    80000d26:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000d28:	ce19                	beqz	a2,80000d46 <memcmp+0x26>
    80000d2a:	1602                	slli	a2,a2,0x20
    80000d2c:	9201                	srli	a2,a2,0x20
    80000d2e:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000d32:	00054783          	lbu	a5,0(a0)
    80000d36:	0005c703          	lbu	a4,0(a1)
    80000d3a:	00e79b63          	bne	a5,a4,80000d50 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
    80000d3e:	0505                	addi	a0,a0,1
    80000d40:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000d42:	fed518e3          	bne	a0,a3,80000d32 <memcmp+0x12>
  }

  return 0;
    80000d46:	4501                	li	a0,0
}
    80000d48:	60a2                	ld	ra,8(sp)
    80000d4a:	6402                	ld	s0,0(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
      return *s1 - *s2;
    80000d50:	40e7853b          	subw	a0,a5,a4
    80000d54:	bfd5                	j	80000d48 <memcmp+0x28>

0000000080000d56 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e406                	sd	ra,8(sp)
    80000d5a:	e022                	sd	s0,0(sp)
    80000d5c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d5e:	c61d                	beqz	a2,80000d8c <memmove+0x36>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d60:	00a5f963          	bgeu	a1,a0,80000d72 <memmove+0x1c>
    80000d64:	02061693          	slli	a3,a2,0x20
    80000d68:	9281                	srli	a3,a3,0x20
    80000d6a:	00d58733          	add	a4,a1,a3
    80000d6e:	02e56363          	bltu	a0,a4,80000d94 <memmove+0x3e>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d72:	1602                	slli	a2,a2,0x20
    80000d74:	9201                	srli	a2,a2,0x20
    80000d76:	00c587b3          	add	a5,a1,a2
{
    80000d7a:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d7c:	0585                	addi	a1,a1,1
    80000d7e:	0705                	addi	a4,a4,1
    80000d80:	fff5c683          	lbu	a3,-1(a1)
    80000d84:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d88:	fef59ae3          	bne	a1,a5,80000d7c <memmove+0x26>

  return dst;
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret
    d += n;
    80000d94:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d96:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d9a:	1782                	slli	a5,a5,0x20
    80000d9c:	9381                	srli	a5,a5,0x20
    80000d9e:	fff7c793          	not	a5,a5
    80000da2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da4:	177d                	addi	a4,a4,-1
    80000da6:	16fd                	addi	a3,a3,-1
    80000da8:	00074603          	lbu	a2,0(a4)
    80000dac:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000db0:	fee79ae3          	bne	a5,a4,80000da4 <memmove+0x4e>
    80000db4:	bfe1                	j	80000d8c <memmove+0x36>

0000000080000db6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000db6:	1141                	addi	sp,sp,-16
    80000db8:	e406                	sd	ra,8(sp)
    80000dba:	e022                	sd	s0,0(sp)
    80000dbc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dbe:	f99ff0ef          	jal	80000d56 <memmove>
}
    80000dc2:	60a2                	ld	ra,8(sp)
    80000dc4:	6402                	ld	s0,0(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e406                	sd	ra,8(sp)
    80000dce:	e022                	sd	s0,0(sp)
    80000dd0:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000dd2:	ce01                	beqz	a2,80000dea <strncmp+0x20>
    80000dd4:	00054783          	lbu	a5,0(a0)
    80000dd8:	cb99                	beqz	a5,80000dee <strncmp+0x24>
    80000dda:	0005c703          	lbu	a4,0(a1)
    80000dde:	00f71863          	bne	a4,a5,80000dee <strncmp+0x24>
    n--, p++, q++;
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	0505                	addi	a0,a0,1
    80000de6:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000de8:	f675                	bnez	a2,80000dd4 <strncmp+0xa>
  if (n == 0)
    return 0;
    80000dea:	4501                	li	a0,0
    80000dec:	a031                	j	80000df8 <strncmp+0x2e>
  return (uchar)*p - (uchar)*q;
    80000dee:	00054503          	lbu	a0,0(a0)
    80000df2:	0005c783          	lbu	a5,0(a1)
    80000df6:	9d1d                	subw	a0,a0,a5
}
    80000df8:	60a2                	ld	ra,8(sp)
    80000dfa:	6402                	ld	s0,0(sp)
    80000dfc:	0141                	addi	sp,sp,16
    80000dfe:	8082                	ret

0000000080000e00 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000e00:	1141                	addi	sp,sp,-16
    80000e02:	e406                	sd	ra,8(sp)
    80000e04:	e022                	sd	s0,0(sp)
    80000e06:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000e08:	87aa                	mv	a5,a0
    80000e0a:	a011                	j	80000e0e <strncpy+0xe>
    80000e0c:	8636                	mv	a2,a3
    80000e0e:	02c05763          	blez	a2,80000e3c <strncpy+0x3c>
    80000e12:	fff6069b          	addiw	a3,a2,-1
    80000e16:	0785                	addi	a5,a5,1
    80000e18:	0005c703          	lbu	a4,0(a1)
    80000e1c:	fee78fa3          	sb	a4,-1(a5)
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	f76d                	bnez	a4,80000e0c <strncpy+0xc>
    ;
  while (n-- > 0)
    80000e24:	873e                	mv	a4,a5
    80000e26:	00d05b63          	blez	a3,80000e3c <strncpy+0x3c>
    80000e2a:	9fb1                	addw	a5,a5,a2
    80000e2c:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e2e:	0705                	addi	a4,a4,1
    80000e30:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000e34:	40e786bb          	subw	a3,a5,a4
    80000e38:	fed04be3          	bgtz	a3,80000e2e <strncpy+0x2e>
  return os;
}
    80000e3c:	60a2                	ld	ra,8(sp)
    80000e3e:	6402                	ld	s0,0(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000e44:	1141                	addi	sp,sp,-16
    80000e46:	e406                	sd	ra,8(sp)
    80000e48:	e022                	sd	s0,0(sp)
    80000e4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e4c:	02c05363          	blez	a2,80000e72 <safestrcpy+0x2e>
    80000e50:	fff6069b          	addiw	a3,a2,-1
    80000e54:	1682                	slli	a3,a3,0x20
    80000e56:	9281                	srli	a3,a3,0x20
    80000e58:	96ae                	add	a3,a3,a1
    80000e5a:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e5c:	00d58963          	beq	a1,a3,80000e6e <safestrcpy+0x2a>
    80000e60:	0585                	addi	a1,a1,1
    80000e62:	0785                	addi	a5,a5,1
    80000e64:	fff5c703          	lbu	a4,-1(a1)
    80000e68:	fee78fa3          	sb	a4,-1(a5)
    80000e6c:	fb65                	bnez	a4,80000e5c <safestrcpy+0x18>
    ;
  *s = 0;
    80000e6e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e72:	60a2                	ld	ra,8(sp)
    80000e74:	6402                	ld	s0,0(sp)
    80000e76:	0141                	addi	sp,sp,16
    80000e78:	8082                	ret

0000000080000e7a <strlen>:

int
strlen(const char *s)
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e82:	00054783          	lbu	a5,0(a0)
    80000e86:	cf91                	beqz	a5,80000ea2 <strlen+0x28>
    80000e88:	00150793          	addi	a5,a0,1
    80000e8c:	86be                	mv	a3,a5
    80000e8e:	0785                	addi	a5,a5,1
    80000e90:	fff7c703          	lbu	a4,-1(a5)
    80000e94:	ff65                	bnez	a4,80000e8c <strlen+0x12>
    80000e96:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e9a:	60a2                	ld	ra,8(sp)
    80000e9c:	6402                	ld	s0,0(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret
  for (n = 0; s[n]; n++)
    80000ea2:	4501                	li	a0,0
    80000ea4:	bfdd                	j	80000e9a <strlen+0x20>

0000000080000ea6 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e406                	sd	ra,8(sp)
    80000eaa:	e022                	sd	s0,0(sp)
    80000eac:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000eae:	247000ef          	jal	800018f4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000eb2:	00007717          	auipc	a4,0x7
    80000eb6:	bba70713          	addi	a4,a4,-1094 # 80007a6c <started>
  if (cpuid() == 0) {
    80000eba:	c51d                	beqz	a0,80000ee8 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000ebc:	431c                	lw	a5,0(a4)
    80000ebe:	0230000f          	fence	r,rw
    80000ec2:	2781                	sext.w	a5,a5
    80000ec4:	dfe5                	beqz	a5,80000ebc <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000ec6:	22f000ef          	jal	800018f4 <cpuid>
    80000eca:	85aa                	mv	a1,a0
    80000ecc:	00006517          	auipc	a0,0x6
    80000ed0:	1cc50513          	addi	a0,a0,460 # 80007098 <etext+0x98>
    80000ed4:	e3cff0ef          	jal	80000510 <printk>
    kvminithart();  // turn on paging
    80000ed8:	082000ef          	jal	80000f5a <kvminithart>
    trapinithart(); // install kernel trap vector
    80000edc:	70c010ef          	jal	800025e8 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000ee0:	2a9040ef          	jal	80005988 <plicinithart>
  }

  scheduler();
    80000ee4:	6b7000ef          	jal	80001d9a <scheduler>
    consoleinit();
    80000ee8:	d50ff0ef          	jal	80000438 <consoleinit>
    printkinit();
    80000eec:	999ff0ef          	jal	80000884 <printkinit>
    printk("\n");
    80000ef0:	00006517          	auipc	a0,0x6
    80000ef4:	18850513          	addi	a0,a0,392 # 80007078 <etext+0x78>
    80000ef8:	e18ff0ef          	jal	80000510 <printk>
    printk("xv6 kernel is booting\n");
    80000efc:	00006517          	auipc	a0,0x6
    80000f00:	18450513          	addi	a0,a0,388 # 80007080 <etext+0x80>
    80000f04:	e0cff0ef          	jal	80000510 <printk>
    printk("\n");
    80000f08:	00006517          	auipc	a0,0x6
    80000f0c:	17050513          	addi	a0,a0,368 # 80007078 <etext+0x78>
    80000f10:	e00ff0ef          	jal	80000510 <printk>
    kinit();            // physical page allocator
    80000f14:	bd7ff0ef          	jal	80000aea <kinit>
    kvminit();          // create kernel page table
    80000f18:	2c2000ef          	jal	800011da <kvminit>
    kvminithart();      // turn on paging
    80000f1c:	03e000ef          	jal	80000f5a <kvminithart>
    procinit();         // process table
    80000f20:	11d000ef          	jal	8000183c <procinit>
    trapinit();         // trap vectors
    80000f24:	6a0010ef          	jal	800025c4 <trapinit>
    trapinithart();     // install kernel trap vector
    80000f28:	6c0010ef          	jal	800025e8 <trapinithart>
    plicinit();         // set up interrupt controller
    80000f2c:	243040ef          	jal	8000596e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000f30:	259040ef          	jal	80005988 <plicinithart>
    binit();            // buffer cache
    80000f34:	763010ef          	jal	80002e96 <binit>
    iinit();            // inode table
    80000f38:	4bc020ef          	jal	800033f4 <iinit>
    fileinit();         // file table
    80000f3c:	4e0030ef          	jal	8000441c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f40:	339040ef          	jal	80005a78 <virtio_disk_init>
    userinit();         // first user process
    80000f44:	4a9000ef          	jal	80001bec <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f48:	00007797          	auipc	a5,0x7
    80000f4c:	b2478793          	addi	a5,a5,-1244 # 80007a6c <started>
    80000f50:	4705                	li	a4,1
    80000f52:	0310000f          	fence	rw,w
    80000f56:	c398                	sw	a4,0(a5)
    80000f58:	b771                	j	80000ee4 <main+0x3e>

0000000080000f5a <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e406                	sd	ra,8(sp)
    80000f5e:	e022                	sd	s0,0(sp)
    80000f60:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f62:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f66:	00007797          	auipc	a5,0x7
    80000f6a:	b0a7b783          	ld	a5,-1270(a5) # 80007a70 <kernel_pagetable>
    80000f6e:	83b1                	srli	a5,a5,0xc
    80000f70:	577d                	li	a4,-1
    80000f72:	177e                	slli	a4,a4,0x3f
    80000f74:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f76:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f7a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f7e:	60a2                	ld	ra,8(sp)
    80000f80:	6402                	ld	s0,0(sp)
    80000f82:	0141                	addi	sp,sp,16
    80000f84:	8082                	ret

0000000080000f86 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f86:	7139                	addi	sp,sp,-64
    80000f88:	fc06                	sd	ra,56(sp)
    80000f8a:	f822                	sd	s0,48(sp)
    80000f8c:	f426                	sd	s1,40(sp)
    80000f8e:	f04a                	sd	s2,32(sp)
    80000f90:	ec4e                	sd	s3,24(sp)
    80000f92:	e852                	sd	s4,16(sp)
    80000f94:	e456                	sd	s5,8(sp)
    80000f96:	e05a                	sd	s6,0(sp)
    80000f98:	0080                	addi	s0,sp,64
    80000f9a:	84aa                	mv	s1,a0
    80000f9c:	89ae                	mv	s3,a1
    80000f9e:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000fa0:	57fd                	li	a5,-1
    80000fa2:	83e9                	srli	a5,a5,0x1a
    80000fa4:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000fa6:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000fa8:	06b7e363          	bltu	a5,a1,8000100e <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fac:	0149d933          	srl	s2,s3,s4
    80000fb0:	1ff97913          	andi	s2,s2,511
    80000fb4:	090e                	slli	s2,s2,0x3
    80000fb6:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000fb8:	00093483          	ld	s1,0(s2)
    80000fbc:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fc0:	80a9                	srli	s1,s1,0xa
    80000fc2:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000fc4:	e395                	bnez	a5,80000fe8 <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fc6:	040b0a63          	beqz	s6,8000101a <walk+0x94>
    80000fca:	b55ff0ef          	jal	80000b1e <kalloc>
    80000fce:	84aa                	mv	s1,a0
    80000fd0:	c50d                	beqz	a0,80000ffa <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fd2:	6605                	lui	a2,0x1
    80000fd4:	4581                	li	a1,0
    80000fd6:	d25ff0ef          	jal	80000cfa <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fda:	00c4d793          	srli	a5,s1,0xc
    80000fde:	07aa                	slli	a5,a5,0xa
    80000fe0:	0017e793          	ori	a5,a5,1
    80000fe4:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fe8:	3a5d                	addiw	s4,s4,-9
    80000fea:	fd5a11e3          	bne	s4,s5,80000fac <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fee:	00c9d513          	srli	a0,s3,0xc
    80000ff2:	1ff57513          	andi	a0,a0,511
    80000ff6:	050e                	slli	a0,a0,0x3
    80000ff8:	9526                	add	a0,a0,s1
}
    80000ffa:	70e2                	ld	ra,56(sp)
    80000ffc:	7442                	ld	s0,48(sp)
    80000ffe:	74a2                	ld	s1,40(sp)
    80001000:	7902                	ld	s2,32(sp)
    80001002:	69e2                	ld	s3,24(sp)
    80001004:	6a42                	ld	s4,16(sp)
    80001006:	6aa2                	ld	s5,8(sp)
    80001008:	6b02                	ld	s6,0(sp)
    8000100a:	6121                	addi	sp,sp,64
    8000100c:	8082                	ret
    panic("walk");
    8000100e:	00006517          	auipc	a0,0x6
    80001012:	0a250513          	addi	a0,a0,162 # 800070b0 <etext+0xb0>
    80001016:	833ff0ef          	jal	80000848 <panic>
        return 0;
    8000101a:	4501                	li	a0,0
    8000101c:	bff9                	j	80000ffa <walk+0x74>

000000008000101e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    8000101e:	57fd                	li	a5,-1
    80001020:	83e9                	srli	a5,a5,0x1a
    80001022:	00b7f463          	bgeu	a5,a1,8000102a <walkaddr+0xc>
    return 0;
    80001026:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001028:	8082                	ret
{
    8000102a:	1141                	addi	sp,sp,-16
    8000102c:	e406                	sd	ra,8(sp)
    8000102e:	e022                	sd	s0,0(sp)
    80001030:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001032:	4601                	li	a2,0
    80001034:	f53ff0ef          	jal	80000f86 <walk>
  if (pte == 0)
    80001038:	c519                	beqz	a0,80001046 <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    8000103a:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    8000103c:	01157713          	andi	a4,a0,17
    80001040:	47c5                	li	a5,17
    80001042:	00f70763          	beq	a4,a5,80001050 <walkaddr+0x32>
    return 0;
    80001046:	4501                	li	a0,0
}
    80001048:	60a2                	ld	ra,8(sp)
    8000104a:	6402                	ld	s0,0(sp)
    8000104c:	0141                	addi	sp,sp,16
    8000104e:	8082                	ret
  pa = PTE2PA(*pte);
    80001050:	8129                	srli	a0,a0,0xa
    80001052:	0532                	slli	a0,a0,0xc
  return pa;
    80001054:	bfd5                	j	80001048 <walkaddr+0x2a>

0000000080001056 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001056:	715d                	addi	sp,sp,-80
    80001058:	e486                	sd	ra,72(sp)
    8000105a:	e0a2                	sd	s0,64(sp)
    8000105c:	fc26                	sd	s1,56(sp)
    8000105e:	f84a                	sd	s2,48(sp)
    80001060:	f44e                	sd	s3,40(sp)
    80001062:	f052                	sd	s4,32(sp)
    80001064:	ec56                	sd	s5,24(sp)
    80001066:	e85a                	sd	s6,16(sp)
    80001068:	e45e                	sd	s7,8(sp)
    8000106a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000106c:	03459793          	slli	a5,a1,0x34
    80001070:	e7b1                	bnez	a5,800010bc <mappages+0x66>
    80001072:	8a2a                	mv	s4,a0
    80001074:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001076:	03461793          	slli	a5,a2,0x34
    8000107a:	e7b9                	bnez	a5,800010c8 <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    8000107c:	ce21                	beqz	a2,800010d4 <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000107e:	77fd                	lui	a5,0xfffff
    80001080:	963e                	add	a2,a2,a5
    80001082:	00b60933          	add	s2,a2,a1
  a = va;
    80001086:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001088:	4b05                	li	s6,1
    8000108a:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000108e:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001090:	865a                	mv	a2,s6
    80001092:	85a6                	mv	a1,s1
    80001094:	8552                	mv	a0,s4
    80001096:	ef1ff0ef          	jal	80000f86 <walk>
    8000109a:	c929                	beqz	a0,800010ec <mappages+0x96>
    if (*pte & PTE_V)
    8000109c:	611c                	ld	a5,0(a0)
    8000109e:	8b85                	andi	a5,a5,1
    800010a0:	e3a1                	bnez	a5,800010e0 <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010a2:	013487b3          	add	a5,s1,s3
    800010a6:	83b1                	srli	a5,a5,0xc
    800010a8:	07aa                	slli	a5,a5,0xa
    800010aa:	0157e7b3          	or	a5,a5,s5
    800010ae:	0017e793          	ori	a5,a5,1
    800010b2:	e11c                	sd	a5,0(a0)
    if (a == last)
    800010b4:	05248863          	beq	s1,s2,80001104 <mappages+0xae>
    a += PGSIZE;
    800010b8:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800010ba:	bfd9                	j	80001090 <mappages+0x3a>
    panic("mappages: va not aligned");
    800010bc:	00006517          	auipc	a0,0x6
    800010c0:	ffc50513          	addi	a0,a0,-4 # 800070b8 <etext+0xb8>
    800010c4:	f84ff0ef          	jal	80000848 <panic>
    panic("mappages: size not aligned");
    800010c8:	00006517          	auipc	a0,0x6
    800010cc:	01050513          	addi	a0,a0,16 # 800070d8 <etext+0xd8>
    800010d0:	f78ff0ef          	jal	80000848 <panic>
    panic("mappages: size");
    800010d4:	00006517          	auipc	a0,0x6
    800010d8:	02450513          	addi	a0,a0,36 # 800070f8 <etext+0xf8>
    800010dc:	f6cff0ef          	jal	80000848 <panic>
      panic("mappages: remap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	02850513          	addi	a0,a0,40 # 80007108 <etext+0x108>
    800010e8:	f60ff0ef          	jal	80000848 <panic>
      return -1;
    800010ec:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010ee:	60a6                	ld	ra,72(sp)
    800010f0:	6406                	ld	s0,64(sp)
    800010f2:	74e2                	ld	s1,56(sp)
    800010f4:	7942                	ld	s2,48(sp)
    800010f6:	79a2                	ld	s3,40(sp)
    800010f8:	7a02                	ld	s4,32(sp)
    800010fa:	6ae2                	ld	s5,24(sp)
    800010fc:	6b42                	ld	s6,16(sp)
    800010fe:	6ba2                	ld	s7,8(sp)
    80001100:	6161                	addi	sp,sp,80
    80001102:	8082                	ret
  return 0;
    80001104:	4501                	li	a0,0
    80001106:	b7e5                	j	800010ee <mappages+0x98>

0000000080001108 <kvmmap>:
{
    80001108:	1141                	addi	sp,sp,-16
    8000110a:	e406                	sd	ra,8(sp)
    8000110c:	e022                	sd	s0,0(sp)
    8000110e:	0800                	addi	s0,sp,16
    80001110:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001112:	86b2                	mv	a3,a2
    80001114:	863e                	mv	a2,a5
    80001116:	f41ff0ef          	jal	80001056 <mappages>
    8000111a:	e509                	bnez	a0,80001124 <kvmmap+0x1c>
}
    8000111c:	60a2                	ld	ra,8(sp)
    8000111e:	6402                	ld	s0,0(sp)
    80001120:	0141                	addi	sp,sp,16
    80001122:	8082                	ret
    panic("kvmmap");
    80001124:	00006517          	auipc	a0,0x6
    80001128:	ff450513          	addi	a0,a0,-12 # 80007118 <etext+0x118>
    8000112c:	f1cff0ef          	jal	80000848 <panic>

0000000080001130 <kvmmake>:
{
    80001130:	1101                	addi	sp,sp,-32
    80001132:	ec06                	sd	ra,24(sp)
    80001134:	e822                	sd	s0,16(sp)
    80001136:	e426                	sd	s1,8(sp)
    80001138:	e04a                	sd	s2,0(sp)
    8000113a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000113c:	9e3ff0ef          	jal	80000b1e <kalloc>
    80001140:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001142:	6605                	lui	a2,0x1
    80001144:	4581                	li	a1,0
    80001146:	bb5ff0ef          	jal	80000cfa <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000114a:	4719                	li	a4,6
    8000114c:	6685                	lui	a3,0x1
    8000114e:	10000637          	lui	a2,0x10000
    80001152:	85b2                	mv	a1,a2
    80001154:	8526                	mv	a0,s1
    80001156:	fb3ff0ef          	jal	80001108 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000115a:	4719                	li	a4,6
    8000115c:	6685                	lui	a3,0x1
    8000115e:	10001637          	lui	a2,0x10001
    80001162:	85b2                	mv	a1,a2
    80001164:	8526                	mv	a0,s1
    80001166:	fa3ff0ef          	jal	80001108 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000116a:	4719                	li	a4,6
    8000116c:	040006b7          	lui	a3,0x4000
    80001170:	0c000637          	lui	a2,0xc000
    80001174:	85b2                	mv	a1,a2
    80001176:	8526                	mv	a0,s1
    80001178:	f91ff0ef          	jal	80001108 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000117c:	00006917          	auipc	s2,0x6
    80001180:	e8490913          	addi	s2,s2,-380 # 80007000 <etext>
    80001184:	4729                	li	a4,10
    80001186:	800006b7          	lui	a3,0x80000
    8000118a:	96ca                	add	a3,a3,s2
    8000118c:	4605                	li	a2,1
    8000118e:	067e                	slli	a2,a2,0x1f
    80001190:	85b2                	mv	a1,a2
    80001192:	8526                	mv	a0,s1
    80001194:	f75ff0ef          	jal	80001108 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001198:	4719                	li	a4,6
    8000119a:	46c5                	li	a3,17
    8000119c:	06ee                	slli	a3,a3,0x1b
    8000119e:	412686b3          	sub	a3,a3,s2
    800011a2:	864a                	mv	a2,s2
    800011a4:	85ca                	mv	a1,s2
    800011a6:	8526                	mv	a0,s1
    800011a8:	f61ff0ef          	jal	80001108 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ac:	4729                	li	a4,10
    800011ae:	6685                	lui	a3,0x1
    800011b0:	00005617          	auipc	a2,0x5
    800011b4:	e5060613          	addi	a2,a2,-432 # 80006000 <_trampoline>
    800011b8:	040005b7          	lui	a1,0x4000
    800011bc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011be:	05b2                	slli	a1,a1,0xc
    800011c0:	8526                	mv	a0,s1
    800011c2:	f47ff0ef          	jal	80001108 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011c6:	8526                	mv	a0,s1
    800011c8:	5e0000ef          	jal	800017a8 <proc_mapstacks>
}
    800011cc:	8526                	mv	a0,s1
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret

00000000800011da <kvminit>:
{
    800011da:	1141                	addi	sp,sp,-16
    800011dc:	e406                	sd	ra,8(sp)
    800011de:	e022                	sd	s0,0(sp)
    800011e0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011e2:	f4fff0ef          	jal	80001130 <kvmmake>
    800011e6:	00007797          	auipc	a5,0x7
    800011ea:	88a7b523          	sd	a0,-1910(a5) # 80007a70 <kernel_pagetable>
}
    800011ee:	60a2                	ld	ra,8(sp)
    800011f0:	6402                	ld	s0,0(sp)
    800011f2:	0141                	addi	sp,sp,16
    800011f4:	8082                	ret

00000000800011f6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011f6:	1101                	addi	sp,sp,-32
    800011f8:	ec06                	sd	ra,24(sp)
    800011fa:	e822                	sd	s0,16(sp)
    800011fc:	e426                	sd	s1,8(sp)
    800011fe:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001200:	91fff0ef          	jal	80000b1e <kalloc>
    80001204:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001206:	c509                	beqz	a0,80001210 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001208:	6605                	lui	a2,0x1
    8000120a:	4581                	li	a1,0
    8000120c:	aefff0ef          	jal	80000cfa <memset>
  return pagetable;
}
    80001210:	8526                	mv	a0,s1
    80001212:	60e2                	ld	ra,24(sp)
    80001214:	6442                	ld	s0,16(sp)
    80001216:	64a2                	ld	s1,8(sp)
    80001218:	6105                	addi	sp,sp,32
    8000121a:	8082                	ret

000000008000121c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000121c:	7139                	addi	sp,sp,-64
    8000121e:	fc06                	sd	ra,56(sp)
    80001220:	f822                	sd	s0,48(sp)
    80001222:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001224:	03459793          	slli	a5,a1,0x34
    80001228:	e38d                	bnez	a5,8000124a <uvmunmap+0x2e>
    8000122a:	f04a                	sd	s2,32(sp)
    8000122c:	ec4e                	sd	s3,24(sp)
    8000122e:	e852                	sd	s4,16(sp)
    80001230:	e456                	sd	s5,8(sp)
    80001232:	e05a                	sd	s6,0(sp)
    80001234:	8a2a                	mv	s4,a0
    80001236:	892e                	mv	s2,a1
    80001238:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000123a:	0632                	slli	a2,a2,0xc
    8000123c:	00b609b3          	add	s3,a2,a1
    80001240:	6b05                	lui	s6,0x1
    80001242:	0535f963          	bgeu	a1,s3,80001294 <uvmunmap+0x78>
    80001246:	f426                	sd	s1,40(sp)
    80001248:	a015                	j	8000126c <uvmunmap+0x50>
    8000124a:	f426                	sd	s1,40(sp)
    8000124c:	f04a                	sd	s2,32(sp)
    8000124e:	ec4e                	sd	s3,24(sp)
    80001250:	e852                	sd	s4,16(sp)
    80001252:	e456                	sd	s5,8(sp)
    80001254:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001256:	00006517          	auipc	a0,0x6
    8000125a:	eca50513          	addi	a0,a0,-310 # 80007120 <etext+0x120>
    8000125e:	deaff0ef          	jal	80000848 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80001262:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001266:	995a                	add	s2,s2,s6
    80001268:	03397563          	bgeu	s2,s3,80001292 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000126c:	4601                	li	a2,0
    8000126e:	85ca                	mv	a1,s2
    80001270:	8552                	mv	a0,s4
    80001272:	d15ff0ef          	jal	80000f86 <walk>
    80001276:	84aa                	mv	s1,a0
    80001278:	d57d                	beqz	a0,80001266 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    8000127a:	611c                	ld	a5,0(a0)
    8000127c:	0017f713          	andi	a4,a5,1
    80001280:	d37d                	beqz	a4,80001266 <uvmunmap+0x4a>
    if (do_free) {
    80001282:	fe0a80e3          	beqz	s5,80001262 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001286:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001288:	00c79513          	slli	a0,a5,0xc
    8000128c:	faaff0ef          	jal	80000a36 <kfree>
    80001290:	bfc9                	j	80001262 <uvmunmap+0x46>
    80001292:	74a2                	ld	s1,40(sp)
    80001294:	7902                	ld	s2,32(sp)
    80001296:	69e2                	ld	s3,24(sp)
    80001298:	6a42                	ld	s4,16(sp)
    8000129a:	6aa2                	ld	s5,8(sp)
    8000129c:	6b02                	ld	s6,0(sp)
  }
}
    8000129e:	70e2                	ld	ra,56(sp)
    800012a0:	7442                	ld	s0,48(sp)
    800012a2:	6121                	addi	sp,sp,64
    800012a4:	8082                	ret

00000000800012a6 <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    800012a6:	04b67163          	bgeu	a2,a1,800012e8 <uvmdealloc+0x42>
{
    800012aa:	1101                	addi	sp,sp,-32
    800012ac:	ec06                	sd	ra,24(sp)
    800012ae:	e822                	sd	s0,16(sp)
    800012b0:	e426                	sd	s1,8(sp)
    800012b2:	1000                	addi	s0,sp,32
    800012b4:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800012b6:	6785                	lui	a5,0x1
    800012b8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ba:	00f60733          	add	a4,a2,a5
    800012be:	76fd                	lui	a3,0xfffff
    800012c0:	8f75                	and	a4,a4,a3
    800012c2:	97ae                	add	a5,a5,a1
    800012c4:	8ff5                	and	a5,a5,a3
    800012c6:	00f76863          	bltu	a4,a5,800012d6 <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    800012ca:	8526                	mv	a0,s1
}
    800012cc:	60e2                	ld	ra,24(sp)
    800012ce:	6442                	ld	s0,16(sp)
    800012d0:	64a2                	ld	s1,8(sp)
    800012d2:	6105                	addi	sp,sp,32
    800012d4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012d6:	8f99                	sub	a5,a5,a4
    800012d8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012da:	4685                	li	a3,1
    800012dc:	0007861b          	sext.w	a2,a5
    800012e0:	85ba                	mv	a1,a4
    800012e2:	f3bff0ef          	jal	8000121c <uvmunmap>
    800012e6:	b7d5                	j	800012ca <uvmdealloc+0x24>
    return oldsz;
    800012e8:	852e                	mv	a0,a1
}
    800012ea:	8082                	ret

00000000800012ec <uvmalloc>:
  if (newsz < oldsz)
    800012ec:	08b66e63          	bltu	a2,a1,80001388 <uvmalloc+0x9c>
{
    800012f0:	715d                	addi	sp,sp,-80
    800012f2:	e486                	sd	ra,72(sp)
    800012f4:	e0a2                	sd	s0,64(sp)
    800012f6:	f052                	sd	s4,32(sp)
    800012f8:	ec56                	sd	s5,24(sp)
    800012fa:	e45e                	sd	s7,8(sp)
    800012fc:	0880                	addi	s0,sp,80
    800012fe:	8aaa                	mv	s5,a0
    80001300:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001302:	6785                	lui	a5,0x1
    80001304:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001306:	95be                	add	a1,a1,a5
    80001308:	77fd                	lui	a5,0xfffff
    8000130a:	8fed                	and	a5,a5,a1
    8000130c:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000130e:	04c7f163          	bgeu	a5,a2,80001350 <uvmalloc+0x64>
    80001312:	fc26                	sd	s1,56(sp)
    80001314:	f84a                	sd	s2,48(sp)
    80001316:	f44e                	sd	s3,40(sp)
    80001318:	e85a                	sd	s6,16(sp)
    8000131a:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    8000131c:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000131e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001322:	ffcff0ef          	jal	80000b1e <kalloc>
    80001326:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001328:	c515                	beqz	a0,80001354 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    8000132a:	864e                	mv	a2,s3
    8000132c:	4581                	li	a1,0
    8000132e:	9cdff0ef          	jal	80000cfa <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001332:	875a                	mv	a4,s6
    80001334:	86a6                	mv	a3,s1
    80001336:	864e                	mv	a2,s3
    80001338:	85ca                	mv	a1,s2
    8000133a:	8556                	mv	a0,s5
    8000133c:	d1bff0ef          	jal	80001056 <mappages>
    80001340:	e91d                	bnez	a0,80001376 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001342:	994e                	add	s2,s2,s3
    80001344:	fd496fe3          	bltu	s2,s4,80001322 <uvmalloc+0x36>
    80001348:	74e2                	ld	s1,56(sp)
    8000134a:	7942                	ld	s2,48(sp)
    8000134c:	79a2                	ld	s3,40(sp)
    8000134e:	6b42                	ld	s6,16(sp)
  return newsz;
    80001350:	8552                	mv	a0,s4
    80001352:	a819                	j	80001368 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80001354:	865e                	mv	a2,s7
    80001356:	85ca                	mv	a1,s2
    80001358:	8556                	mv	a0,s5
    8000135a:	f4dff0ef          	jal	800012a6 <uvmdealloc>
      return 0;
    8000135e:	4501                	li	a0,0
    80001360:	74e2                	ld	s1,56(sp)
    80001362:	7942                	ld	s2,48(sp)
    80001364:	79a2                	ld	s3,40(sp)
    80001366:	6b42                	ld	s6,16(sp)
}
    80001368:	60a6                	ld	ra,72(sp)
    8000136a:	6406                	ld	s0,64(sp)
    8000136c:	7a02                	ld	s4,32(sp)
    8000136e:	6ae2                	ld	s5,24(sp)
    80001370:	6ba2                	ld	s7,8(sp)
    80001372:	6161                	addi	sp,sp,80
    80001374:	8082                	ret
      kfree(mem);
    80001376:	8526                	mv	a0,s1
    80001378:	ebeff0ef          	jal	80000a36 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000137c:	865e                	mv	a2,s7
    8000137e:	85ca                	mv	a1,s2
    80001380:	8556                	mv	a0,s5
    80001382:	f25ff0ef          	jal	800012a6 <uvmdealloc>
      return 0;
    80001386:	bfe1                	j	8000135e <uvmalloc+0x72>
    return oldsz;
    80001388:	852e                	mv	a0,a1
}
    8000138a:	8082                	ret

000000008000138c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000138c:	7179                	addi	sp,sp,-48
    8000138e:	f406                	sd	ra,40(sp)
    80001390:	f022                	sd	s0,32(sp)
    80001392:	ec26                	sd	s1,24(sp)
    80001394:	e84a                	sd	s2,16(sp)
    80001396:	e44e                	sd	s3,8(sp)
    80001398:	1800                	addi	s0,sp,48
    8000139a:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000139c:	84aa                	mv	s1,a0
    8000139e:	6905                	lui	s2,0x1
    800013a0:	992a                	add	s2,s2,a0
    800013a2:	a811                	j	800013b6 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    800013a4:	00006517          	auipc	a0,0x6
    800013a8:	d9450513          	addi	a0,a0,-620 # 80007138 <etext+0x138>
    800013ac:	c9cff0ef          	jal	80000848 <panic>
  for (int i = 0; i < 512; i++) {
    800013b0:	04a1                	addi	s1,s1,8
    800013b2:	03248163          	beq	s1,s2,800013d4 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013b6:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013b8:	0017f713          	andi	a4,a5,1
    800013bc:	db75                	beqz	a4,800013b0 <freewalk+0x24>
    800013be:	00e7f713          	andi	a4,a5,14
    800013c2:	f36d                	bnez	a4,800013a4 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013c4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013c6:	00c79513          	slli	a0,a5,0xc
    800013ca:	fc3ff0ef          	jal	8000138c <freewalk>
      pagetable[i] = 0;
    800013ce:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013d2:	bff9                	j	800013b0 <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013d4:	854e                	mv	a0,s3
    800013d6:	e60ff0ef          	jal	80000a36 <kfree>
}
    800013da:	70a2                	ld	ra,40(sp)
    800013dc:	7402                	ld	s0,32(sp)
    800013de:	64e2                	ld	s1,24(sp)
    800013e0:	6942                	ld	s2,16(sp)
    800013e2:	69a2                	ld	s3,8(sp)
    800013e4:	6145                	addi	sp,sp,48
    800013e6:	8082                	ret

00000000800013e8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013e8:	1101                	addi	sp,sp,-32
    800013ea:	ec06                	sd	ra,24(sp)
    800013ec:	e822                	sd	s0,16(sp)
    800013ee:	e426                	sd	s1,8(sp)
    800013f0:	1000                	addi	s0,sp,32
    800013f2:	84aa                	mv	s1,a0
  if (sz > 0)
    800013f4:	e989                	bnez	a1,80001406 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013f6:	8526                	mv	a0,s1
    800013f8:	f95ff0ef          	jal	8000138c <freewalk>
}
    800013fc:	60e2                	ld	ra,24(sp)
    800013fe:	6442                	ld	s0,16(sp)
    80001400:	64a2                	ld	s1,8(sp)
    80001402:	6105                	addi	sp,sp,32
    80001404:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001406:	6785                	lui	a5,0x1
    80001408:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000140a:	95be                	add	a1,a1,a5
    8000140c:	4685                	li	a3,1
    8000140e:	00c5d613          	srli	a2,a1,0xc
    80001412:	4581                	li	a1,0
    80001414:	e09ff0ef          	jal	8000121c <uvmunmap>
    80001418:	bff9                	j	800013f6 <uvmfree+0xe>

000000008000141a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    8000141a:	ca59                	beqz	a2,800014b0 <uvmcopy+0x96>
{
    8000141c:	715d                	addi	sp,sp,-80
    8000141e:	e486                	sd	ra,72(sp)
    80001420:	e0a2                	sd	s0,64(sp)
    80001422:	fc26                	sd	s1,56(sp)
    80001424:	f84a                	sd	s2,48(sp)
    80001426:	f44e                	sd	s3,40(sp)
    80001428:	f052                	sd	s4,32(sp)
    8000142a:	ec56                	sd	s5,24(sp)
    8000142c:	e85a                	sd	s6,16(sp)
    8000142e:	e45e                	sd	s7,8(sp)
    80001430:	0880                	addi	s0,sp,80
    80001432:	8b2a                	mv	s6,a0
    80001434:	8bae                	mv	s7,a1
    80001436:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001438:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    8000143a:	6a05                	lui	s4,0x1
    8000143c:	a021                	j	80001444 <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    8000143e:	94d2                	add	s1,s1,s4
    80001440:	0554fc63          	bgeu	s1,s5,80001498 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    80001444:	4601                	li	a2,0
    80001446:	85a6                	mv	a1,s1
    80001448:	855a                	mv	a0,s6
    8000144a:	b3dff0ef          	jal	80000f86 <walk>
    8000144e:	d965                	beqz	a0,8000143e <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    80001450:	00053983          	ld	s3,0(a0)
    80001454:	0019f793          	andi	a5,s3,1
    80001458:	d3fd                	beqz	a5,8000143e <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    8000145a:	ec4ff0ef          	jal	80000b1e <kalloc>
    8000145e:	892a                	mv	s2,a0
    80001460:	c11d                	beqz	a0,80001486 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    80001462:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001466:	8652                	mv	a2,s4
    80001468:	05b2                	slli	a1,a1,0xc
    8000146a:	8edff0ef          	jal	80000d56 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    8000146e:	3ff9f713          	andi	a4,s3,1023
    80001472:	86ca                	mv	a3,s2
    80001474:	8652                	mv	a2,s4
    80001476:	85a6                	mv	a1,s1
    80001478:	855e                	mv	a0,s7
    8000147a:	bddff0ef          	jal	80001056 <mappages>
    8000147e:	d161                	beqz	a0,8000143e <uvmcopy+0x24>
      kfree(mem);
    80001480:	854a                	mv	a0,s2
    80001482:	db4ff0ef          	jal	80000a36 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001486:	4685                	li	a3,1
    80001488:	00c4d613          	srli	a2,s1,0xc
    8000148c:	4581                	li	a1,0
    8000148e:	855e                	mv	a0,s7
    80001490:	d8dff0ef          	jal	8000121c <uvmunmap>
  return -1;
    80001494:	557d                	li	a0,-1
    80001496:	a011                	j	8000149a <uvmcopy+0x80>
  return 0;
    80001498:	4501                	li	a0,0
}
    8000149a:	60a6                	ld	ra,72(sp)
    8000149c:	6406                	ld	s0,64(sp)
    8000149e:	74e2                	ld	s1,56(sp)
    800014a0:	7942                	ld	s2,48(sp)
    800014a2:	79a2                	ld	s3,40(sp)
    800014a4:	7a02                	ld	s4,32(sp)
    800014a6:	6ae2                	ld	s5,24(sp)
    800014a8:	6b42                	ld	s6,16(sp)
    800014aa:	6ba2                	ld	s7,8(sp)
    800014ac:	6161                	addi	sp,sp,80
    800014ae:	8082                	ret
  return 0;
    800014b0:	4501                	li	a0,0
}
    800014b2:	8082                	ret

00000000800014b4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014b4:	1141                	addi	sp,sp,-16
    800014b6:	e406                	sd	ra,8(sp)
    800014b8:	e022                	sd	s0,0(sp)
    800014ba:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800014bc:	4601                	li	a2,0
    800014be:	ac9ff0ef          	jal	80000f86 <walk>
  if (pte == 0)
    800014c2:	c901                	beqz	a0,800014d2 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014c4:	611c                	ld	a5,0(a0)
    800014c6:	9bbd                	andi	a5,a5,-17
    800014c8:	e11c                	sd	a5,0(a0)
}
    800014ca:	60a2                	ld	ra,8(sp)
    800014cc:	6402                	ld	s0,0(sp)
    800014ce:	0141                	addi	sp,sp,16
    800014d0:	8082                	ret
    panic("uvmclear");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	c7650513          	addi	a0,a0,-906 # 80007148 <etext+0x148>
    800014da:	b6eff0ef          	jal	80000848 <panic>

00000000800014de <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014de:	1141                	addi	sp,sp,-16
    800014e0:	e406                	sd	ra,8(sp)
    800014e2:	e022                	sd	s0,0(sp)
    800014e4:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014e6:	4601                	li	a2,0
    800014e8:	a9fff0ef          	jal	80000f86 <walk>
  if (pte == 0) {
    800014ec:	c119                	beqz	a0,800014f2 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014ee:	6108                	ld	a0,0(a0)
    800014f0:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014f2:	60a2                	ld	ra,8(sp)
    800014f4:	6402                	ld	s0,0(sp)
    800014f6:	0141                	addi	sp,sp,16
    800014f8:	8082                	ret

00000000800014fa <vmfault>:
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	e052                	sd	s4,0(sp)
    80001502:	1800                	addi	s0,sp,48
  if (va >= psz)
    80001504:	00b66d63          	bltu	a2,a1,8000151e <vmfault+0x24>
    return 0;
    80001508:	4a01                	li	s4,0
}
    8000150a:	8552                	mv	a0,s4
    8000150c:	70a2                	ld	ra,40(sp)
    8000150e:	7402                	ld	s0,32(sp)
    80001510:	6a02                	ld	s4,0(sp)
    80001512:	6145                	addi	sp,sp,48
    80001514:	8082                	ret
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	b7f5                	j	80001508 <vmfault+0xe>
    8000151e:	e84a                	sd	s2,16(sp)
    80001520:	e44e                	sd	s3,8(sp)
  va = PGROUNDDOWN(va);
    80001522:	77fd                	lui	a5,0xfffff
    80001524:	00f67933          	and	s2,a2,a5
  if (ismapped(pagetable, va)) {
    80001528:	85ca                	mv	a1,s2
    8000152a:	89aa                	mv	s3,a0
    8000152c:	fb3ff0ef          	jal	800014de <ismapped>
    80001530:	c501                	beqz	a0,80001538 <vmfault+0x3e>
    80001532:	6942                	ld	s2,16(sp)
    80001534:	69a2                	ld	s3,8(sp)
    80001536:	bfc9                	j	80001508 <vmfault+0xe>
    80001538:	ec26                	sd	s1,24(sp)
  mem = (uint64)kalloc();
    8000153a:	de4ff0ef          	jal	80000b1e <kalloc>
    8000153e:	84aa                	mv	s1,a0
  if (mem == 0)
    80001540:	d979                	beqz	a0,80001516 <vmfault+0x1c>
  mem = (uint64)kalloc();
    80001542:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    80001544:	6605                	lui	a2,0x1
    80001546:	4581                	li	a1,0
    80001548:	fb2ff0ef          	jal	80000cfa <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    8000154c:	4759                	li	a4,22
    8000154e:	86a6                	mv	a3,s1
    80001550:	6605                	lui	a2,0x1
    80001552:	85ca                	mv	a1,s2
    80001554:	854e                	mv	a0,s3
    80001556:	b01ff0ef          	jal	80001056 <mappages>
    8000155a:	e509                	bnez	a0,80001564 <vmfault+0x6a>
    8000155c:	64e2                	ld	s1,24(sp)
    8000155e:	6942                	ld	s2,16(sp)
    80001560:	69a2                	ld	s3,8(sp)
    80001562:	b765                	j	8000150a <vmfault+0x10>
    kfree((void *)mem);
    80001564:	8526                	mv	a0,s1
    80001566:	cd0ff0ef          	jal	80000a36 <kfree>
    return 0;
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	bf61                	j	80001508 <vmfault+0xe>

0000000080001572 <copyout>:
  while (len > 0) {
    80001572:	cf55                	beqz	a4,8000162e <copyout+0xbc>
{
    80001574:	7159                	addi	sp,sp,-112
    80001576:	f486                	sd	ra,104(sp)
    80001578:	f0a2                	sd	s0,96(sp)
    8000157a:	eca6                	sd	s1,88(sp)
    8000157c:	e8ca                	sd	s2,80(sp)
    8000157e:	e4ce                	sd	s3,72(sp)
    80001580:	e0d2                	sd	s4,64(sp)
    80001582:	fc56                	sd	s5,56(sp)
    80001584:	f85a                	sd	s6,48(sp)
    80001586:	f45e                	sd	s7,40(sp)
    80001588:	f062                	sd	s8,32(sp)
    8000158a:	ec66                	sd	s9,24(sp)
    8000158c:	e86a                	sd	s10,16(sp)
    8000158e:	e46e                	sd	s11,8(sp)
    80001590:	1880                	addi	s0,sp,112
    80001592:	8baa                	mv	s7,a0
    80001594:	8dae                	mv	s11,a1
    80001596:	84b2                	mv	s1,a2
    80001598:	8b36                	mv	s6,a3
    8000159a:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    8000159c:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    8000159e:	5cfd                	li	s9,-1
    800015a0:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    800015a4:	6c05                	lui	s8,0x1
    800015a6:	a089                	j	800015e8 <copyout+0x76>
      return -1;
    800015a8:	557d                	li	a0,-1
}
    800015aa:	70a6                	ld	ra,104(sp)
    800015ac:	7406                	ld	s0,96(sp)
    800015ae:	64e6                	ld	s1,88(sp)
    800015b0:	6946                	ld	s2,80(sp)
    800015b2:	69a6                	ld	s3,72(sp)
    800015b4:	6a06                	ld	s4,64(sp)
    800015b6:	7ae2                	ld	s5,56(sp)
    800015b8:	7b42                	ld	s6,48(sp)
    800015ba:	7ba2                	ld	s7,40(sp)
    800015bc:	7c02                	ld	s8,32(sp)
    800015be:	6ce2                	ld	s9,24(sp)
    800015c0:	6d42                	ld	s10,16(sp)
    800015c2:	6da2                	ld	s11,8(sp)
    800015c4:	6165                	addi	sp,sp,112
    800015c6:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015c8:	03449513          	slli	a0,s1,0x34
    800015cc:	9151                	srli	a0,a0,0x34
    800015ce:	0009061b          	sext.w	a2,s2
    800015d2:	85da                	mv	a1,s6
    800015d4:	954e                	add	a0,a0,s3
    800015d6:	f80ff0ef          	jal	80000d56 <memmove>
    len -= n;
    800015da:	412a8ab3          	sub	s5,s5,s2
    src += n;
    800015de:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    800015e0:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    800015e4:	040a8363          	beqz	s5,8000162a <copyout+0xb8>
    va0 = PGROUNDDOWN(dstva);
    800015e8:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    800015ec:	fb4ceee3          	bltu	s9,s4,800015a8 <copyout+0x36>
    pa0 = walkaddr(pagetable, va0);
    800015f0:	85d2                	mv	a1,s4
    800015f2:	855e                	mv	a0,s7
    800015f4:	a2bff0ef          	jal	8000101e <walkaddr>
    800015f8:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015fa:	e909                	bnez	a0,8000160c <copyout+0x9a>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015fc:	4681                	li	a3,0
    800015fe:	8652                	mv	a2,s4
    80001600:	85ee                	mv	a1,s11
    80001602:	855e                	mv	a0,s7
    80001604:	ef7ff0ef          	jal	800014fa <vmfault>
    80001608:	89aa                	mv	s3,a0
    8000160a:	dd59                	beqz	a0,800015a8 <copyout+0x36>
    pte = walk(pagetable, va0, 0);
    8000160c:	4601                	li	a2,0
    8000160e:	85d2                	mv	a1,s4
    80001610:	855e                	mv	a0,s7
    80001612:	975ff0ef          	jal	80000f86 <walk>
    if ((*pte & PTE_W) == 0)
    80001616:	611c                	ld	a5,0(a0)
    80001618:	8b91                	andi	a5,a5,4
    8000161a:	d7d9                	beqz	a5,800015a8 <copyout+0x36>
    n = PGSIZE - (dstva - va0);
    8000161c:	409a0933          	sub	s2,s4,s1
    80001620:	9962                	add	s2,s2,s8
    if (n > len)
    80001622:	fb2af3e3          	bgeu	s5,s2,800015c8 <copyout+0x56>
    80001626:	8956                	mv	s2,s5
    80001628:	b745                	j	800015c8 <copyout+0x56>
  return 0;
    8000162a:	4501                	li	a0,0
    8000162c:	bfbd                	j	800015aa <copyout+0x38>
    8000162e:	4501                	li	a0,0
}
    80001630:	8082                	ret

0000000080001632 <copyin>:
  while (len > 0) {
    80001632:	cf49                	beqz	a4,800016cc <copyin+0x9a>
{
    80001634:	711d                	addi	sp,sp,-96
    80001636:	ec86                	sd	ra,88(sp)
    80001638:	e8a2                	sd	s0,80(sp)
    8000163a:	e4a6                	sd	s1,72(sp)
    8000163c:	e0ca                	sd	s2,64(sp)
    8000163e:	fc4e                	sd	s3,56(sp)
    80001640:	f852                	sd	s4,48(sp)
    80001642:	f456                	sd	s5,40(sp)
    80001644:	f05a                	sd	s6,32(sp)
    80001646:	ec5e                	sd	s7,24(sp)
    80001648:	e862                	sd	s8,16(sp)
    8000164a:	e466                	sd	s9,8(sp)
    8000164c:	e06a                	sd	s10,0(sp)
    8000164e:	1080                	addi	s0,sp,96
    80001650:	8baa                	mv	s7,a0
    80001652:	8cae                	mv	s9,a1
    80001654:	8ab2                	mv	s5,a2
    80001656:	84b6                	mv	s1,a3
    80001658:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    8000165a:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    8000165c:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    8000165e:	6b05                	lui	s6,0x1
    80001660:	a03d                	j	8000168e <copyin+0x5c>
    80001662:	409a0933          	sub	s2,s4,s1
    80001666:	995a                	add	s2,s2,s6
    if (n > len)
    80001668:	0129f363          	bgeu	s3,s2,8000166e <copyin+0x3c>
    8000166c:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000166e:	03449593          	slli	a1,s1,0x34
    80001672:	91d1                	srli	a1,a1,0x34
    80001674:	0009061b          	sext.w	a2,s2
    80001678:	95aa                	add	a1,a1,a0
    8000167a:	8556                	mv	a0,s5
    8000167c:	edaff0ef          	jal	80000d56 <memmove>
    len -= n;
    80001680:	412989b3          	sub	s3,s3,s2
    dst += n;
    80001684:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001686:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    8000168a:	02098263          	beqz	s3,800016ae <copyin+0x7c>
    va0 = PGROUNDDOWN(srcva);
    8000168e:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    80001692:	85d2                	mv	a1,s4
    80001694:	855e                	mv	a0,s7
    80001696:	989ff0ef          	jal	8000101e <walkaddr>
    if (pa0 == 0) {
    8000169a:	f561                	bnez	a0,80001662 <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    8000169c:	86ea                	mv	a3,s10
    8000169e:	8652                	mv	a2,s4
    800016a0:	85e6                	mv	a1,s9
    800016a2:	855e                	mv	a0,s7
    800016a4:	e57ff0ef          	jal	800014fa <vmfault>
    800016a8:	fd4d                	bnez	a0,80001662 <copyin+0x30>
        return -1;
    800016aa:	557d                	li	a0,-1
    800016ac:	a011                	j	800016b0 <copyin+0x7e>
  return 0;
    800016ae:	4501                	li	a0,0
}
    800016b0:	60e6                	ld	ra,88(sp)
    800016b2:	6446                	ld	s0,80(sp)
    800016b4:	64a6                	ld	s1,72(sp)
    800016b6:	6906                	ld	s2,64(sp)
    800016b8:	79e2                	ld	s3,56(sp)
    800016ba:	7a42                	ld	s4,48(sp)
    800016bc:	7aa2                	ld	s5,40(sp)
    800016be:	7b02                	ld	s6,32(sp)
    800016c0:	6be2                	ld	s7,24(sp)
    800016c2:	6c42                	ld	s8,16(sp)
    800016c4:	6ca2                	ld	s9,8(sp)
    800016c6:	6d02                	ld	s10,0(sp)
    800016c8:	6125                	addi	sp,sp,96
    800016ca:	8082                	ret
  return 0;
    800016cc:	4501                	li	a0,0
}
    800016ce:	8082                	ret

00000000800016d0 <copyinstr>:
  while (got_null == 0 && max > 0) {
    800016d0:	c771                	beqz	a4,8000179c <copyinstr+0xcc>
{
    800016d2:	711d                	addi	sp,sp,-96
    800016d4:	ec86                	sd	ra,88(sp)
    800016d6:	e8a2                	sd	s0,80(sp)
    800016d8:	e4a6                	sd	s1,72(sp)
    800016da:	e0ca                	sd	s2,64(sp)
    800016dc:	fc4e                	sd	s3,56(sp)
    800016de:	f852                	sd	s4,48(sp)
    800016e0:	f456                	sd	s5,40(sp)
    800016e2:	f05a                	sd	s6,32(sp)
    800016e4:	ec5e                	sd	s7,24(sp)
    800016e6:	e862                	sd	s8,16(sp)
    800016e8:	e466                	sd	s9,8(sp)
    800016ea:	1080                	addi	s0,sp,96
    800016ec:	8b2a                	mv	s6,a0
    800016ee:	8c2e                	mv	s8,a1
    800016f0:	8932                	mv	s2,a2
    800016f2:	84b6                	mv	s1,a3
    800016f4:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016f6:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016f8:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016fa:	6a85                	lui	s5,0x1
    800016fc:	a881                	j	8000174c <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016fe:	86e6                	mv	a3,s9
    80001700:	864e                	mv	a2,s3
    80001702:	85e2                	mv	a1,s8
    80001704:	855a                	mv	a0,s6
    80001706:	df5ff0ef          	jal	800014fa <vmfault>
    8000170a:	e921                	bnez	a0,8000175a <copyinstr+0x8a>
        return -1;
    8000170c:	557d                	li	a0,-1
    8000170e:	a801                	j	8000171e <copyinstr+0x4e>
        *dst = '\0';
    80001710:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffde050>
        got_null = 1;
    80001714:	4785                	li	a5,1
  if (got_null) {
    80001716:	0017c793          	xori	a5,a5,1
    8000171a:	40f0053b          	negw	a0,a5
}
    8000171e:	60e6                	ld	ra,88(sp)
    80001720:	6446                	ld	s0,80(sp)
    80001722:	64a6                	ld	s1,72(sp)
    80001724:	6906                	ld	s2,64(sp)
    80001726:	79e2                	ld	s3,56(sp)
    80001728:	7a42                	ld	s4,48(sp)
    8000172a:	7aa2                	ld	s5,40(sp)
    8000172c:	7b02                	ld	s6,32(sp)
    8000172e:	6be2                	ld	s7,24(sp)
    80001730:	6c42                	ld	s8,16(sp)
    80001732:	6ca2                	ld	s9,8(sp)
    80001734:	6125                	addi	sp,sp,96
    80001736:	8082                	ret
    80001738:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000173c:	974a                	add	a4,a4,s2
      --max;
    8000173e:	40a70a33          	sub	s4,a4,a0
    srcva = va0 + PGSIZE;
    80001742:	015984b3          	add	s1,s3,s5
  while (got_null == 0 && max > 0) {
    80001746:	04e50563          	beq	a0,a4,80001790 <copyinstr+0xc0>
{
    8000174a:	893e                	mv	s2,a5
    va0 = PGROUNDDOWN(srcva);
    8000174c:	0174f9b3          	and	s3,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001750:	85ce                	mv	a1,s3
    80001752:	855a                	mv	a0,s6
    80001754:	8cbff0ef          	jal	8000101e <walkaddr>
    if (pa0 == 0) {
    80001758:	d15d                	beqz	a0,800016fe <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    8000175a:	40998633          	sub	a2,s3,s1
    8000175e:	9656                	add	a2,a2,s5
    if (n > max)
    80001760:	00ca7363          	bgeu	s4,a2,80001766 <copyinstr+0x96>
    80001764:	8652                	mv	a2,s4
    while (n > 0) {
    80001766:	c61d                	beqz	a2,80001794 <copyinstr+0xc4>
    char *p = (char *)(pa0 + (srcva - va0));
    80001768:	03449593          	slli	a1,s1,0x34
    8000176c:	91d1                	srli	a1,a1,0x34
    8000176e:	95aa                	add	a1,a1,a0
    80001770:	87ca                	mv	a5,s2
      if (*p == '\0') {
    80001772:	412585b3          	sub	a1,a1,s2
    while (n > 0) {
    80001776:	964a                	add	a2,a2,s2
    80001778:	853e                	mv	a0,a5
      if (*p == '\0') {
    8000177a:	00f58733          	add	a4,a1,a5
    8000177e:	00074683          	lbu	a3,0(a4)
    80001782:	d6d9                	beqz	a3,80001710 <copyinstr+0x40>
        *dst = *p;
    80001784:	00d78023          	sb	a3,0(a5)
      dst++;
    80001788:	0785                	addi	a5,a5,1
    while (n > 0) {
    8000178a:	fec797e3          	bne	a5,a2,80001778 <copyinstr+0xa8>
    8000178e:	b76d                	j	80001738 <copyinstr+0x68>
    srcva = va0 + PGSIZE;
    80001790:	4781                	li	a5,0
    80001792:	b751                	j	80001716 <copyinstr+0x46>
    80001794:	6485                	lui	s1,0x1
    80001796:	94ce                	add	s1,s1,s3
    80001798:	87ca                	mv	a5,s2
    8000179a:	bf45                	j	8000174a <copyinstr+0x7a>
    8000179c:	4781                	li	a5,0
  if (got_null) {
    8000179e:	0017c793          	xori	a5,a5,1
    800017a2:	40f0053b          	negw	a0,a5
}
    800017a6:	8082                	ret

00000000800017a8 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a8:	715d                	addi	sp,sp,-80
    800017aa:	e486                	sd	ra,72(sp)
    800017ac:	e0a2                	sd	s0,64(sp)
    800017ae:	fc26                	sd	s1,56(sp)
    800017b0:	f84a                	sd	s2,48(sp)
    800017b2:	f44e                	sd	s3,40(sp)
    800017b4:	f052                	sd	s4,32(sp)
    800017b6:	ec56                	sd	s5,24(sp)
    800017b8:	e85a                	sd	s6,16(sp)
    800017ba:	e45e                	sd	s7,8(sp)
    800017bc:	0880                	addi	s0,sp,80
    800017be:	8aaa                	mv	s5,a0
    800017c0:	4481                	li	s1,0

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    800017c2:	ff4df937          	lui	s2,0xff4df
    800017c6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bda0d>
    800017ca:	0936                	slli	s2,s2,0xd
    800017cc:	6f590913          	addi	s2,s2,1781
    800017d0:	0936                	slli	s2,s2,0xd
    800017d2:	bd390913          	addi	s2,s2,-1069
    800017d6:	0932                	slli	s2,s2,0xc
    800017d8:	7a790913          	addi	s2,s2,1959
    800017dc:	040009b7          	lui	s3,0x4000
    800017e0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017e2:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e4:	4b99                	li	s7,6
    800017e6:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017e8:	6a19                	lui	s4,0x6
    800017ea:	c00a0a13          	addi	s4,s4,-1024 # 5c00 <_entry-0x7fffa400>
    char *pa = kalloc();
    800017ee:	b30ff0ef          	jal	80000b1e <kalloc>
    800017f2:	862a                	mv	a2,a0
    if (pa == 0)
    800017f4:	cd15                	beqz	a0,80001830 <proc_mapstacks+0x88>
    uint64 va = KSTACK((int)(p - proc));
    800017f6:	4044d593          	srai	a1,s1,0x4
    800017fa:	032585b3          	mul	a1,a1,s2
    800017fe:	05b6                	slli	a1,a1,0xd
    80001800:	6789                	lui	a5,0x2
    80001802:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001804:	875e                	mv	a4,s7
    80001806:	86da                	mv	a3,s6
    80001808:	40b985b3          	sub	a1,s3,a1
    8000180c:	8556                	mv	a0,s5
    8000180e:	8fbff0ef          	jal	80001108 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001812:	17048493          	addi	s1,s1,368 # 1170 <_entry-0x7fffee90>
    80001816:	fd449ce3          	bne	s1,s4,800017ee <proc_mapstacks+0x46>
  }
}
    8000181a:	60a6                	ld	ra,72(sp)
    8000181c:	6406                	ld	s0,64(sp)
    8000181e:	74e2                	ld	s1,56(sp)
    80001820:	7942                	ld	s2,48(sp)
    80001822:	79a2                	ld	s3,40(sp)
    80001824:	7a02                	ld	s4,32(sp)
    80001826:	6ae2                	ld	s5,24(sp)
    80001828:	6b42                	ld	s6,16(sp)
    8000182a:	6ba2                	ld	s7,8(sp)
    8000182c:	6161                	addi	sp,sp,80
    8000182e:	8082                	ret
      panic("kalloc");
    80001830:	00006517          	auipc	a0,0x6
    80001834:	92850513          	addi	a0,a0,-1752 # 80007158 <etext+0x158>
    80001838:	810ff0ef          	jal	80000848 <panic>

000000008000183c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000183c:	7139                	addi	sp,sp,-64
    8000183e:	fc06                	sd	ra,56(sp)
    80001840:	f822                	sd	s0,48(sp)
    80001842:	f426                	sd	s1,40(sp)
    80001844:	f04a                	sd	s2,32(sp)
    80001846:	ec4e                	sd	s3,24(sp)
    80001848:	e852                	sd	s4,16(sp)
    8000184a:	e456                	sd	s5,8(sp)
    8000184c:	e05a                	sd	s6,0(sp)
    8000184e:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001850:	00006597          	auipc	a1,0x6
    80001854:	91058593          	addi	a1,a1,-1776 # 80007160 <etext+0x160>
    80001858:	0000e517          	auipc	a0,0xe
    8000185c:	34850513          	addi	a0,a0,840 # 8000fba0 <pid_lock>
    80001860:	b5eff0ef          	jal	80000bbe <initlock>
  initlock(&wait_lock, "wait_lock");
    80001864:	00006597          	auipc	a1,0x6
    80001868:	90458593          	addi	a1,a1,-1788 # 80007168 <etext+0x168>
    8000186c:	0000e517          	auipc	a0,0xe
    80001870:	34c50513          	addi	a0,a0,844 # 8000fbb8 <wait_lock>
    80001874:	b4aff0ef          	jal	80000bbe <initlock>
    80001878:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000187a:	0000e497          	auipc	s1,0xe
    8000187e:	75648493          	addi	s1,s1,1878 # 8000ffd0 <proc>
    initlock(&p->lock, "proc");
    80001882:	00006a97          	auipc	s5,0x6
    80001886:	8f6a8a93          	addi	s5,s5,-1802 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    8000188a:	ff4df9b7          	lui	s3,0xff4df
    8000188e:	9bd98993          	addi	s3,s3,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bda0d>
    80001892:	09b6                	slli	s3,s3,0xd
    80001894:	6f598993          	addi	s3,s3,1781
    80001898:	09b6                	slli	s3,s3,0xd
    8000189a:	bd398993          	addi	s3,s3,-1069
    8000189e:	09b2                	slli	s3,s3,0xc
    800018a0:	7a798993          	addi	s3,s3,1959
    800018a4:	04000a37          	lui	s4,0x4000
    800018a8:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    800018aa:	0a32                	slli	s4,s4,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    800018ac:	00014b17          	auipc	s6,0x14
    800018b0:	324b0b13          	addi	s6,s6,804 # 80015bd0 <tickslock>
    initlock(&p->lock, "proc");
    800018b4:	85d6                	mv	a1,s5
    800018b6:	8526                	mv	a0,s1
    800018b8:	b06ff0ef          	jal	80000bbe <initlock>
    p->state = UNUSED;
    800018bc:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    800018c0:	40495793          	srai	a5,s2,0x4
    800018c4:	033787b3          	mul	a5,a5,s3
    800018c8:	07b6                	slli	a5,a5,0xd
    800018ca:	6709                	lui	a4,0x2
    800018cc:	9fb9                	addw	a5,a5,a4
    800018ce:	40fa07b3          	sub	a5,s4,a5
    800018d2:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800018d4:	17048493          	addi	s1,s1,368
    800018d8:	17090913          	addi	s2,s2,368
    800018dc:	fd649ce3          	bne	s1,s6,800018b4 <procinit+0x78>
  }
}
    800018e0:	70e2                	ld	ra,56(sp)
    800018e2:	7442                	ld	s0,48(sp)
    800018e4:	74a2                	ld	s1,40(sp)
    800018e6:	7902                	ld	s2,32(sp)
    800018e8:	69e2                	ld	s3,24(sp)
    800018ea:	6a42                	ld	s4,16(sp)
    800018ec:	6aa2                	ld	s5,8(sp)
    800018ee:	6b02                	ld	s6,0(sp)
    800018f0:	6121                	addi	sp,sp,64
    800018f2:	8082                	ret

00000000800018f4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018f4:	1141                	addi	sp,sp,-16
    800018f6:	e406                	sd	ra,8(sp)
    800018f8:	e022                	sd	s0,0(sp)
    800018fa:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018fc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018fe:	2501                	sext.w	a0,a0
    80001900:	60a2                	ld	ra,8(sp)
    80001902:	6402                	ld	s0,0(sp)
    80001904:	0141                	addi	sp,sp,16
    80001906:	8082                	ret

0000000080001908 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001908:	1141                	addi	sp,sp,-16
    8000190a:	e406                	sd	ra,8(sp)
    8000190c:	e022                	sd	s0,0(sp)
    8000190e:	0800                	addi	s0,sp,16
    80001910:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001912:	2781                	sext.w	a5,a5
    80001914:	079e                	slli	a5,a5,0x7
  return c;
}
    80001916:	0000e517          	auipc	a0,0xe
    8000191a:	2ba50513          	addi	a0,a0,698 # 8000fbd0 <cpus>
    8000191e:	953e                	add	a0,a0,a5
    80001920:	60a2                	ld	ra,8(sp)
    80001922:	6402                	ld	s0,0(sp)
    80001924:	0141                	addi	sp,sp,16
    80001926:	8082                	ret

0000000080001928 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001928:	1101                	addi	sp,sp,-32
    8000192a:	ec06                	sd	ra,24(sp)
    8000192c:	e822                	sd	s0,16(sp)
    8000192e:	e426                	sd	s1,8(sp)
    80001930:	1000                	addi	s0,sp,32
  push_off();
    80001932:	ad2ff0ef          	jal	80000c04 <push_off>
    80001936:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001938:	2781                	sext.w	a5,a5
    8000193a:	079e                	slli	a5,a5,0x7
    8000193c:	0000e717          	auipc	a4,0xe
    80001940:	26470713          	addi	a4,a4,612 # 8000fba0 <pid_lock>
    80001944:	97ba                	add	a5,a5,a4
    80001946:	7b9c                	ld	a5,48(a5)
    80001948:	84be                	mv	s1,a5
  pop_off();
    8000194a:	b30ff0ef          	jal	80000c7a <pop_off>
  return p;
}
    8000194e:	8526                	mv	a0,s1
    80001950:	60e2                	ld	ra,24(sp)
    80001952:	6442                	ld	s0,16(sp)
    80001954:	64a2                	ld	s1,8(sp)
    80001956:	6105                	addi	sp,sp,32
    80001958:	8082                	ret

000000008000195a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001964:	fc5ff0ef          	jal	80001928 <myproc>
    80001968:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000196a:	b58ff0ef          	jal	80000cc2 <release>

  if (first) {
    8000196e:	00006797          	auipc	a5,0x6
    80001972:	0e27a783          	lw	a5,226(a5) # 80007a50 <first.1>
    80001976:	cf85                	beqz	a5,800019ae <forkret+0x54>
    first = 0;
    80001978:	00006797          	auipc	a5,0x6
    8000197c:	0c07ac23          	sw	zero,216(a5) # 80007a50 <first.1>

    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001980:	4505                	li	a0,1
    80001982:	777010ef          	jal	800038f8 <fsinit>

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001986:	00005797          	auipc	a5,0x5
    8000198a:	7fa78793          	addi	a5,a5,2042 # 80007180 <etext+0x180>
    8000198e:	fcf43823          	sd	a5,-48(s0)
    80001992:	fc043c23          	sd	zero,-40(s0)
    80001996:	fd040593          	addi	a1,s0,-48
    8000199a:	853e                	mv	a0,a5
    8000199c:	224030ef          	jal	80004bc0 <kexec>
    800019a0:	6cbc                	ld	a5,88(s1)
    800019a2:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800019a4:	6cbc                	ld	a5,88(s1)
    800019a6:	7bb8                	ld	a4,112(a5)
    800019a8:	57fd                	li	a5,-1
    800019aa:	02f70d63          	beq	a4,a5,800019e4 <forkret+0x8a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019ae:	457000ef          	jal	80002604 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019b2:	68a8                	ld	a0,80(s1)
    800019b4:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019b6:	04000737          	lui	a4,0x4000
    800019ba:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019bc:	0732                	slli	a4,a4,0xc
    800019be:	00004797          	auipc	a5,0x4
    800019c2:	6de78793          	addi	a5,a5,1758 # 8000609c <userret>
    800019c6:	00004697          	auipc	a3,0x4
    800019ca:	63a68693          	addi	a3,a3,1594 # 80006000 <_trampoline>
    800019ce:	8f95                	sub	a5,a5,a3
    800019d0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019d2:	577d                	li	a4,-1
    800019d4:	177e                	slli	a4,a4,0x3f
    800019d6:	8d59                	or	a0,a0,a4
    800019d8:	9782                	jalr	a5
}
    800019da:	70a2                	ld	ra,40(sp)
    800019dc:	7402                	ld	s0,32(sp)
    800019de:	64e2                	ld	s1,24(sp)
    800019e0:	6145                	addi	sp,sp,48
    800019e2:	8082                	ret
      panic("exec");
    800019e4:	00005517          	auipc	a0,0x5
    800019e8:	7a450513          	addi	a0,a0,1956 # 80007188 <etext+0x188>
    800019ec:	e5dfe0ef          	jal	80000848 <panic>

00000000800019f0 <allocpid>:
{
    800019f0:	1101                	addi	sp,sp,-32
    800019f2:	ec06                	sd	ra,24(sp)
    800019f4:	e822                	sd	s0,16(sp)
    800019f6:	e426                	sd	s1,8(sp)
    800019f8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019fa:	0000e517          	auipc	a0,0xe
    800019fe:	1a650513          	addi	a0,a0,422 # 8000fba0 <pid_lock>
    80001a02:	a3cff0ef          	jal	80000c3e <acquire>
  pid = nextpid;
    80001a06:	00006797          	auipc	a5,0x6
    80001a0a:	04e78793          	addi	a5,a5,78 # 80007a54 <nextpid>
    80001a0e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a10:	0014871b          	addiw	a4,s1,1
    80001a14:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a16:	0000e517          	auipc	a0,0xe
    80001a1a:	18a50513          	addi	a0,a0,394 # 8000fba0 <pid_lock>
    80001a1e:	aa4ff0ef          	jal	80000cc2 <release>
}
    80001a22:	8526                	mv	a0,s1
    80001a24:	60e2                	ld	ra,24(sp)
    80001a26:	6442                	ld	s0,16(sp)
    80001a28:	64a2                	ld	s1,8(sp)
    80001a2a:	6105                	addi	sp,sp,32
    80001a2c:	8082                	ret

0000000080001a2e <proc_pagetable>:
{
    80001a2e:	1101                	addi	sp,sp,-32
    80001a30:	ec06                	sd	ra,24(sp)
    80001a32:	e822                	sd	s0,16(sp)
    80001a34:	e426                	sd	s1,8(sp)
    80001a36:	e04a                	sd	s2,0(sp)
    80001a38:	1000                	addi	s0,sp,32
    80001a3a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a3c:	fbaff0ef          	jal	800011f6 <uvmcreate>
    80001a40:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a42:	cd05                	beqz	a0,80001a7a <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a44:	4729                	li	a4,10
    80001a46:	00004697          	auipc	a3,0x4
    80001a4a:	5ba68693          	addi	a3,a3,1466 # 80006000 <_trampoline>
    80001a4e:	6605                	lui	a2,0x1
    80001a50:	040005b7          	lui	a1,0x4000
    80001a54:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a56:	05b2                	slli	a1,a1,0xc
    80001a58:	dfeff0ef          	jal	80001056 <mappages>
    80001a5c:	02054663          	bltz	a0,80001a88 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a60:	4719                	li	a4,6
    80001a62:	05893683          	ld	a3,88(s2)
    80001a66:	6605                	lui	a2,0x1
    80001a68:	020005b7          	lui	a1,0x2000
    80001a6c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a6e:	05b6                	slli	a1,a1,0xd
    80001a70:	8526                	mv	a0,s1
    80001a72:	de4ff0ef          	jal	80001056 <mappages>
    80001a76:	00054f63          	bltz	a0,80001a94 <proc_pagetable+0x66>
}
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	60e2                	ld	ra,24(sp)
    80001a7e:	6442                	ld	s0,16(sp)
    80001a80:	64a2                	ld	s1,8(sp)
    80001a82:	6902                	ld	s2,0(sp)
    80001a84:	6105                	addi	sp,sp,32
    80001a86:	8082                	ret
    uvmfree(pagetable, 0);
    80001a88:	4581                	li	a1,0
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	95dff0ef          	jal	800013e8 <uvmfree>
    return 0;
    80001a90:	4481                	li	s1,0
    80001a92:	b7e5                	j	80001a7a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a94:	4681                	li	a3,0
    80001a96:	4605                	li	a2,1
    80001a98:	040005b7          	lui	a1,0x4000
    80001a9c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a9e:	05b2                	slli	a1,a1,0xc
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	f7aff0ef          	jal	8000121c <uvmunmap>
    uvmfree(pagetable, 0);
    80001aa6:	4581                	li	a1,0
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	93fff0ef          	jal	800013e8 <uvmfree>
    return 0;
    80001aae:	b7cd                	j	80001a90 <proc_pagetable+0x62>

0000000080001ab0 <proc_freepagetable>:
{
    80001ab0:	1101                	addi	sp,sp,-32
    80001ab2:	ec06                	sd	ra,24(sp)
    80001ab4:	e822                	sd	s0,16(sp)
    80001ab6:	e426                	sd	s1,8(sp)
    80001ab8:	e04a                	sd	s2,0(sp)
    80001aba:	1000                	addi	s0,sp,32
    80001abc:	84aa                	mv	s1,a0
    80001abe:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ac0:	4681                	li	a3,0
    80001ac2:	4605                	li	a2,1
    80001ac4:	040005b7          	lui	a1,0x4000
    80001ac8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aca:	05b2                	slli	a1,a1,0xc
    80001acc:	f50ff0ef          	jal	8000121c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ad0:	4681                	li	a3,0
    80001ad2:	4605                	li	a2,1
    80001ad4:	020005b7          	lui	a1,0x2000
    80001ad8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ada:	05b6                	slli	a1,a1,0xd
    80001adc:	8526                	mv	a0,s1
    80001ade:	f3eff0ef          	jal	8000121c <uvmunmap>
  uvmfree(pagetable, sz);
    80001ae2:	85ca                	mv	a1,s2
    80001ae4:	8526                	mv	a0,s1
    80001ae6:	903ff0ef          	jal	800013e8 <uvmfree>
}
    80001aea:	60e2                	ld	ra,24(sp)
    80001aec:	6442                	ld	s0,16(sp)
    80001aee:	64a2                	ld	s1,8(sp)
    80001af0:	6902                	ld	s2,0(sp)
    80001af2:	6105                	addi	sp,sp,32
    80001af4:	8082                	ret

0000000080001af6 <freeproc>:
{
    80001af6:	1101                	addi	sp,sp,-32
    80001af8:	ec06                	sd	ra,24(sp)
    80001afa:	e822                	sd	s0,16(sp)
    80001afc:	e426                	sd	s1,8(sp)
    80001afe:	1000                	addi	s0,sp,32
    80001b00:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001b02:	6d28                	ld	a0,88(a0)
    80001b04:	c119                	beqz	a0,80001b0a <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001b06:	f31fe0ef          	jal	80000a36 <kfree>
  p->trapframe = 0;
    80001b0a:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001b0e:	68a8                	ld	a0,80(s1)
    80001b10:	c501                	beqz	a0,80001b18 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b12:	64ac                	ld	a1,72(s1)
    80001b14:	f9dff0ef          	jal	80001ab0 <proc_freepagetable>
  p->pagetable = 0;
    80001b18:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b1c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b20:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001b24:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b28:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b2c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b30:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b34:	0004ac23          	sw	zero,24(s1)
  p->tracemask = 0;
    80001b38:	1604a423          	sw	zero,360(s1)
}
    80001b3c:	60e2                	ld	ra,24(sp)
    80001b3e:	6442                	ld	s0,16(sp)
    80001b40:	64a2                	ld	s1,8(sp)
    80001b42:	6105                	addi	sp,sp,32
    80001b44:	8082                	ret

0000000080001b46 <allocproc>:
{
    80001b46:	1101                	addi	sp,sp,-32
    80001b48:	ec06                	sd	ra,24(sp)
    80001b4a:	e822                	sd	s0,16(sp)
    80001b4c:	e426                	sd	s1,8(sp)
    80001b4e:	e04a                	sd	s2,0(sp)
    80001b50:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b52:	0000e497          	auipc	s1,0xe
    80001b56:	47e48493          	addi	s1,s1,1150 # 8000ffd0 <proc>
    80001b5a:	00014917          	auipc	s2,0x14
    80001b5e:	07690913          	addi	s2,s2,118 # 80015bd0 <tickslock>
    acquire(&p->lock);
    80001b62:	8526                	mv	a0,s1
    80001b64:	8daff0ef          	jal	80000c3e <acquire>
    if (p->state == UNUSED) {
    80001b68:	4c9c                	lw	a5,24(s1)
    80001b6a:	cb91                	beqz	a5,80001b7e <allocproc+0x38>
      release(&p->lock);
    80001b6c:	8526                	mv	a0,s1
    80001b6e:	954ff0ef          	jal	80000cc2 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b72:	17048493          	addi	s1,s1,368
    80001b76:	ff2496e3          	bne	s1,s2,80001b62 <allocproc+0x1c>
  return 0;
    80001b7a:	4481                	li	s1,0
    80001b7c:	a089                	j	80001bbe <allocproc+0x78>
  p->pid = allocpid();
    80001b7e:	e73ff0ef          	jal	800019f0 <allocpid>
    80001b82:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b84:	4785                	li	a5,1
    80001b86:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b88:	f97fe0ef          	jal	80000b1e <kalloc>
    80001b8c:	892a                	mv	s2,a0
    80001b8e:	eca8                	sd	a0,88(s1)
    80001b90:	cd15                	beqz	a0,80001bcc <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b92:	8526                	mv	a0,s1
    80001b94:	e9bff0ef          	jal	80001a2e <proc_pagetable>
    80001b98:	892a                	mv	s2,a0
    80001b9a:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b9c:	c121                	beqz	a0,80001bdc <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b9e:	07000613          	li	a2,112
    80001ba2:	4581                	li	a1,0
    80001ba4:	06048513          	addi	a0,s1,96
    80001ba8:	952ff0ef          	jal	80000cfa <memset>
  p->context.ra = (uint64)forkret;
    80001bac:	00000797          	auipc	a5,0x0
    80001bb0:	dae78793          	addi	a5,a5,-594 # 8000195a <forkret>
    80001bb4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bb6:	60bc                	ld	a5,64(s1)
    80001bb8:	6705                	lui	a4,0x1
    80001bba:	97ba                	add	a5,a5,a4
    80001bbc:	f4bc                	sd	a5,104(s1)
}
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6902                	ld	s2,0(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret
    freeproc(p);
    80001bcc:	8526                	mv	a0,s1
    80001bce:	f29ff0ef          	jal	80001af6 <freeproc>
    release(&p->lock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	8eeff0ef          	jal	80000cc2 <release>
    return 0;
    80001bd8:	84ca                	mv	s1,s2
    80001bda:	b7d5                	j	80001bbe <allocproc+0x78>
    freeproc(p);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	f19ff0ef          	jal	80001af6 <freeproc>
    release(&p->lock);
    80001be2:	8526                	mv	a0,s1
    80001be4:	8deff0ef          	jal	80000cc2 <release>
    return 0;
    80001be8:	84ca                	mv	s1,s2
    80001bea:	bfd1                	j	80001bbe <allocproc+0x78>

0000000080001bec <userinit>:
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bf6:	f51ff0ef          	jal	80001b46 <allocproc>
    80001bfa:	84aa                	mv	s1,a0
  initproc = p;
    80001bfc:	00006797          	auipc	a5,0x6
    80001c00:	e6a7be23          	sd	a0,-388(a5) # 80007a78 <initproc>
  p->cwd = namei("/");
    80001c04:	00005517          	auipc	a0,0x5
    80001c08:	58c50513          	addi	a0,a0,1420 # 80007190 <etext+0x190>
    80001c0c:	244020ef          	jal	80003e50 <namei>
    80001c10:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c14:	478d                	li	a5,3
    80001c16:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c18:	8526                	mv	a0,s1
    80001c1a:	8a8ff0ef          	jal	80000cc2 <release>
}
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret

0000000080001c28 <growproc>:
{
    80001c28:	1101                	addi	sp,sp,-32
    80001c2a:	ec06                	sd	ra,24(sp)
    80001c2c:	e822                	sd	s0,16(sp)
    80001c2e:	e426                	sd	s1,8(sp)
    80001c30:	e04a                	sd	s2,0(sp)
    80001c32:	1000                	addi	s0,sp,32
    80001c34:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c36:	cf3ff0ef          	jal	80001928 <myproc>
    80001c3a:	892a                	mv	s2,a0
  sz = p->sz;
    80001c3c:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c3e:	02905b63          	blez	s1,80001c74 <growproc+0x4c>
    if (sz + n > TRAPFRAME) {
    80001c42:	00b48633          	add	a2,s1,a1
    80001c46:	020007b7          	lui	a5,0x2000
    80001c4a:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c4c:	07b6                	slli	a5,a5,0xd
    80001c4e:	02c7e163          	bltu	a5,a2,80001c70 <growproc+0x48>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c52:	4691                	li	a3,4
    80001c54:	6928                	ld	a0,80(a0)
    80001c56:	e96ff0ef          	jal	800012ec <uvmalloc>
    80001c5a:	85aa                	mv	a1,a0
    80001c5c:	c911                	beqz	a0,80001c70 <growproc+0x48>
  p->sz = sz;
    80001c5e:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c62:	4501                	li	a0,0
}
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6902                	ld	s2,0(sp)
    80001c6c:	6105                	addi	sp,sp,32
    80001c6e:	8082                	ret
      return -1;
    80001c70:	557d                	li	a0,-1
    80001c72:	bfcd                	j	80001c64 <growproc+0x3c>
  } else if (n < 0) {
    80001c74:	fe04d5e3          	bgez	s1,80001c5e <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c78:	00b48633          	add	a2,s1,a1
    80001c7c:	6928                	ld	a0,80(a0)
    80001c7e:	e28ff0ef          	jal	800012a6 <uvmdealloc>
    80001c82:	85aa                	mv	a1,a0
    80001c84:	bfe9                	j	80001c5e <growproc+0x36>

0000000080001c86 <kfork>:
{
    80001c86:	7139                	addi	sp,sp,-64
    80001c88:	fc06                	sd	ra,56(sp)
    80001c8a:	f822                	sd	s0,48(sp)
    80001c8c:	f426                	sd	s1,40(sp)
    80001c8e:	e456                	sd	s5,8(sp)
    80001c90:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c92:	c97ff0ef          	jal	80001928 <myproc>
    80001c96:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c98:	eafff0ef          	jal	80001b46 <allocproc>
    80001c9c:	cd3d                	beqz	a0,80001d1a <kfork+0x94>
    80001c9e:	e852                	sd	s4,16(sp)
    80001ca0:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001ca2:	048ab603          	ld	a2,72(s5)
    80001ca6:	692c                	ld	a1,80(a0)
    80001ca8:	050ab503          	ld	a0,80(s5)
    80001cac:	f6eff0ef          	jal	8000141a <uvmcopy>
    80001cb0:	04054e63          	bltz	a0,80001d0c <kfork+0x86>
    80001cb4:	f04a                	sd	s2,32(sp)
    80001cb6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cb8:	048ab783          	ld	a5,72(s5)
    80001cbc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cc0:	058ab683          	ld	a3,88(s5)
    80001cc4:	87b6                	mv	a5,a3
    80001cc6:	058a3703          	ld	a4,88(s4)
    80001cca:	12068693          	addi	a3,a3,288
    80001cce:	6388                	ld	a0,0(a5)
    80001cd0:	678c                	ld	a1,8(a5)
    80001cd2:	6b90                	ld	a2,16(a5)
    80001cd4:	e308                	sd	a0,0(a4)
    80001cd6:	e70c                	sd	a1,8(a4)
    80001cd8:	eb10                	sd	a2,16(a4)
    80001cda:	6f90                	ld	a2,24(a5)
    80001cdc:	ef10                	sd	a2,24(a4)
    80001cde:	02078793          	addi	a5,a5,32
    80001ce2:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001ce6:	fed794e3          	bne	a5,a3,80001cce <kfork+0x48>
  np->parent = p;
    80001cea:	035a3c23          	sd	s5,56(s4)
  np->tracemask = p->tracemask;
    80001cee:	168aa783          	lw	a5,360(s5)
    80001cf2:	16fa2423          	sw	a5,360(s4)
  np->trapframe->a0 = 0;
    80001cf6:	058a3783          	ld	a5,88(s4)
    80001cfa:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001cfe:	0d0a8493          	addi	s1,s5,208
    80001d02:	0d0a0913          	addi	s2,s4,208
    80001d06:	150a8993          	addi	s3,s5,336
    80001d0a:	a831                	j	80001d26 <kfork+0xa0>
    freeproc(np);
    80001d0c:	8552                	mv	a0,s4
    80001d0e:	de9ff0ef          	jal	80001af6 <freeproc>
    release(&np->lock);
    80001d12:	8552                	mv	a0,s4
    80001d14:	faffe0ef          	jal	80000cc2 <release>
    return -1;
    80001d18:	6a42                	ld	s4,16(sp)
    return -1;
    80001d1a:	54fd                	li	s1,-1
    80001d1c:	a885                	j	80001d8c <kfork+0x106>
  for (i = 0; i < NOFILE; i++)
    80001d1e:	04a1                	addi	s1,s1,8
    80001d20:	0921                	addi	s2,s2,8
    80001d22:	01348963          	beq	s1,s3,80001d34 <kfork+0xae>
    if (p->ofile[i])
    80001d26:	6088                	ld	a0,0(s1)
    80001d28:	d97d                	beqz	a0,80001d1e <kfork+0x98>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d2a:	774020ef          	jal	8000449e <filedup>
    80001d2e:	00a93023          	sd	a0,0(s2)
    80001d32:	b7f5                	j	80001d1e <kfork+0x98>
  np->cwd = idup(p->cwd);
    80001d34:	150ab503          	ld	a0,336(s5)
    80001d38:	04f010ef          	jal	80003586 <idup>
    80001d3c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d40:	4641                	li	a2,16
    80001d42:	158a8593          	addi	a1,s5,344
    80001d46:	158a0513          	addi	a0,s4,344
    80001d4a:	8faff0ef          	jal	80000e44 <safestrcpy>
  pid = np->pid;
    80001d4e:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d52:	8552                	mv	a0,s4
    80001d54:	f6ffe0ef          	jal	80000cc2 <release>
  acquire(&wait_lock);
    80001d58:	0000e517          	auipc	a0,0xe
    80001d5c:	e6050513          	addi	a0,a0,-416 # 8000fbb8 <wait_lock>
    80001d60:	edffe0ef          	jal	80000c3e <acquire>
  np->parent = p;
    80001d64:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d68:	0000e517          	auipc	a0,0xe
    80001d6c:	e5050513          	addi	a0,a0,-432 # 8000fbb8 <wait_lock>
    80001d70:	f53fe0ef          	jal	80000cc2 <release>
  acquire(&np->lock);
    80001d74:	8552                	mv	a0,s4
    80001d76:	ec9fe0ef          	jal	80000c3e <acquire>
  np->state = RUNNABLE;
    80001d7a:	478d                	li	a5,3
    80001d7c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d80:	8552                	mv	a0,s4
    80001d82:	f41fe0ef          	jal	80000cc2 <release>
    80001d86:	7902                	ld	s2,32(sp)
    80001d88:	69e2                	ld	s3,24(sp)
    80001d8a:	6a42                	ld	s4,16(sp)
}
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	70e2                	ld	ra,56(sp)
    80001d90:	7442                	ld	s0,48(sp)
    80001d92:	74a2                	ld	s1,40(sp)
    80001d94:	6aa2                	ld	s5,8(sp)
    80001d96:	6121                	addi	sp,sp,64
    80001d98:	8082                	ret

0000000080001d9a <scheduler>:
{
    80001d9a:	711d                	addi	sp,sp,-96
    80001d9c:	ec86                	sd	ra,88(sp)
    80001d9e:	e8a2                	sd	s0,80(sp)
    80001da0:	e4a6                	sd	s1,72(sp)
    80001da2:	e0ca                	sd	s2,64(sp)
    80001da4:	fc4e                	sd	s3,56(sp)
    80001da6:	f852                	sd	s4,48(sp)
    80001da8:	f456                	sd	s5,40(sp)
    80001daa:	f05a                	sd	s6,32(sp)
    80001dac:	ec5e                	sd	s7,24(sp)
    80001dae:	e862                	sd	s8,16(sp)
    80001db0:	e466                	sd	s9,8(sp)
    80001db2:	1080                	addi	s0,sp,96
    80001db4:	8792                	mv	a5,tp
  int id = r_tp();
    80001db6:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001db8:	00779693          	slli	a3,a5,0x7
    80001dbc:	0000e717          	auipc	a4,0xe
    80001dc0:	de470713          	addi	a4,a4,-540 # 8000fba0 <pid_lock>
    80001dc4:	9736                	add	a4,a4,a3
    80001dc6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001dca:	0000ea97          	auipc	s5,0xe
    80001dce:	e0ea8a93          	addi	s5,s5,-498 # 8000fbd8 <cpus+0x8>
    80001dd2:	9ab6                	add	s5,s5,a3
        p->state = RUNNING;
    80001dd4:	4c11                	li	s8,4
        c->proc = p;
    80001dd6:	0000eb17          	auipc	s6,0xe
    80001dda:	dcab0b13          	addi	s6,s6,-566 # 8000fba0 <pid_lock>
    80001dde:	8a3a                	mv	s4,a4
        found = 1;
    80001de0:	4b85                	li	s7,1
    80001de2:	a0a9                	j	80001e2c <scheduler+0x92>
      release(&p->lock);
    80001de4:	8526                	mv	a0,s1
    80001de6:	eddfe0ef          	jal	80000cc2 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001dea:	17048493          	addi	s1,s1,368
    80001dee:	03248b63          	beq	s1,s2,80001e24 <scheduler+0x8a>
      acquire(&p->lock);
    80001df2:	8526                	mv	a0,s1
    80001df4:	e4bfe0ef          	jal	80000c3e <acquire>
      if (p->state == RUNNABLE) {
    80001df8:	4c9c                	lw	a5,24(s1)
    80001dfa:	ff3795e3          	bne	a5,s3,80001de4 <scheduler+0x4a>
        p->state = RUNNING;
    80001dfe:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001e02:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001e06:	06048593          	addi	a1,s1,96
    80001e0a:	8556                	mv	a0,s5
    80001e0c:	74e000ef          	jal	8000255a <swtch>
    80001e10:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001e12:	2781                	sext.w	a5,a5
    80001e14:	079e                	slli	a5,a5,0x7
    80001e16:	97da                	add	a5,a5,s6
    80001e18:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    80001e1c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e20:	8cde                	mv	s9,s7
    80001e22:	b7c9                	j	80001de4 <scheduler+0x4a>
    if (found == 0) {
    80001e24:	000c9463          	bnez	s9,80001e2c <scheduler+0x92>
      asm volatile("wfi");
    80001e28:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001e2c:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001e30:	10017073          	csrci	sstatus,2
    int found = 0;
    80001e34:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e36:	0000e497          	auipc	s1,0xe
    80001e3a:	19a48493          	addi	s1,s1,410 # 8000ffd0 <proc>
      if (p->state == RUNNABLE) {
    80001e3e:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e40:	00014917          	auipc	s2,0x14
    80001e44:	d9090913          	addi	s2,s2,-624 # 80015bd0 <tickslock>
    80001e48:	b76d                	j	80001df2 <scheduler+0x58>

0000000080001e4a <sched>:
{
    80001e4a:	7179                	addi	sp,sp,-48
    80001e4c:	f406                	sd	ra,40(sp)
    80001e4e:	f022                	sd	s0,32(sp)
    80001e50:	ec26                	sd	s1,24(sp)
    80001e52:	e84a                	sd	s2,16(sp)
    80001e54:	e44e                	sd	s3,8(sp)
    80001e56:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e58:	ad1ff0ef          	jal	80001928 <myproc>
    80001e5c:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e5e:	d7bfe0ef          	jal	80000bd8 <holding>
    80001e62:	c92d                	beqz	a0,80001ed4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e64:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e66:	2781                	sext.w	a5,a5
    80001e68:	079e                	slli	a5,a5,0x7
    80001e6a:	0000e717          	auipc	a4,0xe
    80001e6e:	d3670713          	addi	a4,a4,-714 # 8000fba0 <pid_lock>
    80001e72:	97ba                	add	a5,a5,a4
    80001e74:	0a87a703          	lw	a4,168(a5)
    80001e78:	4785                	li	a5,1
    80001e7a:	06f71363          	bne	a4,a5,80001ee0 <sched+0x96>
  if (p->state == RUNNING)
    80001e7e:	4c98                	lw	a4,24(s1)
    80001e80:	4791                	li	a5,4
    80001e82:	06f70563          	beq	a4,a5,80001eec <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e8a:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e8c:	e7b5                	bnez	a5,80001ef8 <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e8e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e90:	0000e917          	auipc	s2,0xe
    80001e94:	d1090913          	addi	s2,s2,-752 # 8000fba0 <pid_lock>
    80001e98:	2781                	sext.w	a5,a5
    80001e9a:	079e                	slli	a5,a5,0x7
    80001e9c:	97ca                	add	a5,a5,s2
    80001e9e:	0ac7a983          	lw	s3,172(a5)
    80001ea2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001ea4:	2781                	sext.w	a5,a5
    80001ea6:	079e                	slli	a5,a5,0x7
    80001ea8:	0000e597          	auipc	a1,0xe
    80001eac:	d3058593          	addi	a1,a1,-720 # 8000fbd8 <cpus+0x8>
    80001eb0:	95be                	add	a1,a1,a5
    80001eb2:	06048513          	addi	a0,s1,96
    80001eb6:	6a4000ef          	jal	8000255a <swtch>
    80001eba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ebc:	2781                	sext.w	a5,a5
    80001ebe:	079e                	slli	a5,a5,0x7
    80001ec0:	993e                	add	s2,s2,a5
    80001ec2:	0b392623          	sw	s3,172(s2)
}
    80001ec6:	70a2                	ld	ra,40(sp)
    80001ec8:	7402                	ld	s0,32(sp)
    80001eca:	64e2                	ld	s1,24(sp)
    80001ecc:	6942                	ld	s2,16(sp)
    80001ece:	69a2                	ld	s3,8(sp)
    80001ed0:	6145                	addi	sp,sp,48
    80001ed2:	8082                	ret
    panic("sched p->lock");
    80001ed4:	00005517          	auipc	a0,0x5
    80001ed8:	2c450513          	addi	a0,a0,708 # 80007198 <etext+0x198>
    80001edc:	96dfe0ef          	jal	80000848 <panic>
    panic("sched locks");
    80001ee0:	00005517          	auipc	a0,0x5
    80001ee4:	2c850513          	addi	a0,a0,712 # 800071a8 <etext+0x1a8>
    80001ee8:	961fe0ef          	jal	80000848 <panic>
    panic("sched RUNNING");
    80001eec:	00005517          	auipc	a0,0x5
    80001ef0:	2cc50513          	addi	a0,a0,716 # 800071b8 <etext+0x1b8>
    80001ef4:	955fe0ef          	jal	80000848 <panic>
    panic("sched interruptible");
    80001ef8:	00005517          	auipc	a0,0x5
    80001efc:	2d050513          	addi	a0,a0,720 # 800071c8 <etext+0x1c8>
    80001f00:	949fe0ef          	jal	80000848 <panic>

0000000080001f04 <yield>:
{
    80001f04:	1101                	addi	sp,sp,-32
    80001f06:	ec06                	sd	ra,24(sp)
    80001f08:	e822                	sd	s0,16(sp)
    80001f0a:	e426                	sd	s1,8(sp)
    80001f0c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f0e:	a1bff0ef          	jal	80001928 <myproc>
    80001f12:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f14:	d2bfe0ef          	jal	80000c3e <acquire>
  p->state = RUNNABLE;
    80001f18:	478d                	li	a5,3
    80001f1a:	cc9c                	sw	a5,24(s1)
  sched();
    80001f1c:	f2fff0ef          	jal	80001e4a <sched>
  release(&p->lock);
    80001f20:	8526                	mv	a0,s1
    80001f22:	da1fe0ef          	jal	80000cc2 <release>
}
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6105                	addi	sp,sp,32
    80001f2e:	8082                	ret

0000000080001f30 <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001f30:	1101                	addi	sp,sp,-32
    80001f32:	ec06                	sd	ra,24(sp)
    80001f34:	e822                	sd	s0,16(sp)
    80001f36:	e426                	sd	s1,8(sp)
    80001f38:	e04a                	sd	s2,0(sp)
    80001f3a:	1000                	addi	s0,sp,32
    80001f3c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f3e:	9ebff0ef          	jal	80001928 <myproc>
    80001f42:	892a                	mv	s2,a0

  acquire(&p->lock);
    80001f44:	cfbfe0ef          	jal	80000c3e <acquire>
  if (chan == 0)
    80001f48:	cc81                	beqz	s1,80001f60 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80001f4a:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80001f4e:	854a                	mv	a0,s2
    80001f50:	d73fe0ef          	jal	80000cc2 <release>
}
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6902                	ld	s2,0(sp)
    80001f5c:	6105                	addi	sp,sp,32
    80001f5e:	8082                	ret
    panic("sleep_prepare: zero chan");
    80001f60:	00005517          	auipc	a0,0x5
    80001f64:	28050513          	addi	a0,a0,640 # 800071e0 <etext+0x1e0>
    80001f68:	8e1fe0ef          	jal	80000848 <panic>

0000000080001f6c <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    80001f6c:	1101                	addi	sp,sp,-32
    80001f6e:	ec06                	sd	ra,24(sp)
    80001f70:	e822                	sd	s0,16(sp)
    80001f72:	e426                	sd	s1,8(sp)
    80001f74:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f76:	9b3ff0ef          	jal	80001928 <myproc>
    80001f7a:	84aa                	mv	s1,a0

  acquire(&p->lock);
    80001f7c:	cc3fe0ef          	jal	80000c3e <acquire>
  if (p->chan != 0) {
    80001f80:	709c                	ld	a5,32(s1)
    80001f82:	c789                	beqz	a5,80001f8c <sleep+0x20>
    p->state = SLEEPING;
    80001f84:	4789                	li	a5,2
    80001f86:	cc9c                	sw	a5,24(s1)
    sched();
    80001f88:	ec3ff0ef          	jal	80001e4a <sched>
  }
  release(&p->lock);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	d35fe0ef          	jal	80000cc2 <release>
}
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret

0000000080001f9c <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    80001f9c:	7139                	addi	sp,sp,-64
    80001f9e:	fc06                	sd	ra,56(sp)
    80001fa0:	f822                	sd	s0,48(sp)
    80001fa2:	f426                	sd	s1,40(sp)
    80001fa4:	f04a                	sd	s2,32(sp)
    80001fa6:	ec4e                	sd	s3,24(sp)
    80001fa8:	e852                	sd	s4,16(sp)
    80001faa:	e456                	sd	s5,8(sp)
    80001fac:	0080                	addi	s0,sp,64
    80001fae:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001fb0:	0000e497          	auipc	s1,0xe
    80001fb4:	02048493          	addi	s1,s1,32 # 8000ffd0 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    80001fb8:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001fba:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fbc:	00014997          	auipc	s3,0x14
    80001fc0:	c1498993          	addi	s3,s3,-1004 # 80015bd0 <tickslock>
    80001fc4:	a801                	j	80001fd4 <wakeup+0x38>
      }
    }
    release(&p->lock);
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	cfbfe0ef          	jal	80000cc2 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fcc:	17048493          	addi	s1,s1,368
    80001fd0:	03348063          	beq	s1,s3,80001ff0 <wakeup+0x54>
    acquire(&p->lock);
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	c69fe0ef          	jal	80000c3e <acquire>
    if (p->chan == chan) {
    80001fda:	709c                	ld	a5,32(s1)
    80001fdc:	ff2795e3          	bne	a5,s2,80001fc6 <wakeup+0x2a>
      p->chan = 0;
    80001fe0:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80001fe4:	4c9c                	lw	a5,24(s1)
    80001fe6:	ff4790e3          	bne	a5,s4,80001fc6 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fea:	0154ac23          	sw	s5,24(s1)
    80001fee:	bfe1                	j	80001fc6 <wakeup+0x2a>
  }
}
    80001ff0:	70e2                	ld	ra,56(sp)
    80001ff2:	7442                	ld	s0,48(sp)
    80001ff4:	74a2                	ld	s1,40(sp)
    80001ff6:	7902                	ld	s2,32(sp)
    80001ff8:	69e2                	ld	s3,24(sp)
    80001ffa:	6a42                	ld	s4,16(sp)
    80001ffc:	6aa2                	ld	s5,8(sp)
    80001ffe:	6121                	addi	sp,sp,64
    80002000:	8082                	ret

0000000080002002 <reparent>:
{
    80002002:	7179                	addi	sp,sp,-48
    80002004:	f406                	sd	ra,40(sp)
    80002006:	f022                	sd	s0,32(sp)
    80002008:	ec26                	sd	s1,24(sp)
    8000200a:	e84a                	sd	s2,16(sp)
    8000200c:	e44e                	sd	s3,8(sp)
    8000200e:	e052                	sd	s4,0(sp)
    80002010:	1800                	addi	s0,sp,48
    80002012:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002014:	0000e497          	auipc	s1,0xe
    80002018:	fbc48493          	addi	s1,s1,-68 # 8000ffd0 <proc>
      pp->parent = initproc;
    8000201c:	00006a17          	auipc	s4,0x6
    80002020:	a5ca0a13          	addi	s4,s4,-1444 # 80007a78 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002024:	00014997          	auipc	s3,0x14
    80002028:	bac98993          	addi	s3,s3,-1108 # 80015bd0 <tickslock>
    8000202c:	a029                	j	80002036 <reparent+0x34>
    8000202e:	17048493          	addi	s1,s1,368
    80002032:	01348b63          	beq	s1,s3,80002048 <reparent+0x46>
    if (pp->parent == p) {
    80002036:	7c9c                	ld	a5,56(s1)
    80002038:	ff279be3          	bne	a5,s2,8000202e <reparent+0x2c>
      pp->parent = initproc;
    8000203c:	000a3503          	ld	a0,0(s4)
    80002040:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002042:	f5bff0ef          	jal	80001f9c <wakeup>
    80002046:	b7e5                	j	8000202e <reparent+0x2c>
}
    80002048:	70a2                	ld	ra,40(sp)
    8000204a:	7402                	ld	s0,32(sp)
    8000204c:	64e2                	ld	s1,24(sp)
    8000204e:	6942                	ld	s2,16(sp)
    80002050:	69a2                	ld	s3,8(sp)
    80002052:	6a02                	ld	s4,0(sp)
    80002054:	6145                	addi	sp,sp,48
    80002056:	8082                	ret

0000000080002058 <kexit>:
{
    80002058:	7179                	addi	sp,sp,-48
    8000205a:	f406                	sd	ra,40(sp)
    8000205c:	f022                	sd	s0,32(sp)
    8000205e:	ec26                	sd	s1,24(sp)
    80002060:	e84a                	sd	s2,16(sp)
    80002062:	e44e                	sd	s3,8(sp)
    80002064:	e052                	sd	s4,0(sp)
    80002066:	1800                	addi	s0,sp,48
    80002068:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000206a:	8bfff0ef          	jal	80001928 <myproc>
    8000206e:	89aa                	mv	s3,a0
  if (p == initproc)
    80002070:	00006797          	auipc	a5,0x6
    80002074:	a087b783          	ld	a5,-1528(a5) # 80007a78 <initproc>
    80002078:	0d050493          	addi	s1,a0,208
    8000207c:	15050913          	addi	s2,a0,336
    80002080:	00a79b63          	bne	a5,a0,80002096 <kexit+0x3e>
    panic("init exiting");
    80002084:	00005517          	auipc	a0,0x5
    80002088:	17c50513          	addi	a0,a0,380 # 80007200 <etext+0x200>
    8000208c:	fbcfe0ef          	jal	80000848 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002090:	04a1                	addi	s1,s1,8
    80002092:	01248963          	beq	s1,s2,800020a4 <kexit+0x4c>
    if (p->ofile[fd]) {
    80002096:	6088                	ld	a0,0(s1)
    80002098:	dd65                	beqz	a0,80002090 <kexit+0x38>
      fileclose(f);
    8000209a:	44a020ef          	jal	800044e4 <fileclose>
      p->ofile[fd] = 0;
    8000209e:	0004b023          	sd	zero,0(s1)
    800020a2:	b7fd                	j	80002090 <kexit+0x38>
  begin_op();
    800020a4:	78b010ef          	jal	8000402e <begin_op>
  iput(p->cwd);
    800020a8:	1509b503          	ld	a0,336(s3)
    800020ac:	692010ef          	jal	8000373e <iput>
  end_op();
    800020b0:	00a020ef          	jal	800040ba <end_op>
  p->cwd = 0;
    800020b4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020b8:	0000e517          	auipc	a0,0xe
    800020bc:	b0050513          	addi	a0,a0,-1280 # 8000fbb8 <wait_lock>
    800020c0:	b7ffe0ef          	jal	80000c3e <acquire>
  reparent(p);
    800020c4:	854e                	mv	a0,s3
    800020c6:	f3dff0ef          	jal	80002002 <reparent>
  wakeup(p->parent);
    800020ca:	0389b503          	ld	a0,56(s3)
    800020ce:	ecfff0ef          	jal	80001f9c <wakeup>
  acquire(&p->lock);
    800020d2:	854e                	mv	a0,s3
    800020d4:	b6bfe0ef          	jal	80000c3e <acquire>
  p->xstate = status;
    800020d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020dc:	4795                	li	a5,5
    800020de:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020e2:	0000e517          	auipc	a0,0xe
    800020e6:	ad650513          	addi	a0,a0,-1322 # 8000fbb8 <wait_lock>
    800020ea:	bd9fe0ef          	jal	80000cc2 <release>
  sched();
    800020ee:	d5dff0ef          	jal	80001e4a <sched>
  panic("zombie exit");
    800020f2:	00005517          	auipc	a0,0x5
    800020f6:	11e50513          	addi	a0,a0,286 # 80007210 <etext+0x210>
    800020fa:	f4efe0ef          	jal	80000848 <panic>

00000000800020fe <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020fe:	7179                	addi	sp,sp,-48
    80002100:	f406                	sd	ra,40(sp)
    80002102:	f022                	sd	s0,32(sp)
    80002104:	ec26                	sd	s1,24(sp)
    80002106:	e84a                	sd	s2,16(sp)
    80002108:	e44e                	sd	s3,8(sp)
    8000210a:	1800                	addi	s0,sp,48
    8000210c:	892a                	mv	s2,a0
  struct proc *p;

  if (pid == 0)
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000210e:	0000e497          	auipc	s1,0xe
    80002112:	ec248493          	addi	s1,s1,-318 # 8000ffd0 <proc>
    80002116:	00014997          	auipc	s3,0x14
    8000211a:	aba98993          	addi	s3,s3,-1350 # 80015bd0 <tickslock>
  if (pid == 0)
    8000211e:	cd11                	beqz	a0,8000213a <kkill+0x3c>
    acquire(&p->lock);
    80002120:	8526                	mv	a0,s1
    80002122:	b1dfe0ef          	jal	80000c3e <acquire>
    if (p->pid == pid) {
    80002126:	589c                	lw	a5,48(s1)
    80002128:	01278b63          	beq	a5,s2,8000213e <kkill+0x40>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000212c:	8526                	mv	a0,s1
    8000212e:	b95fe0ef          	jal	80000cc2 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002132:	17048493          	addi	s1,s1,368
    80002136:	ff3495e3          	bne	s1,s3,80002120 <kkill+0x22>
    return -1;
    8000213a:	557d                	li	a0,-1
    8000213c:	a819                	j	80002152 <kkill+0x54>
      p->killed = 1;
    8000213e:	4785                	li	a5,1
    80002140:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002142:	4c98                	lw	a4,24(s1)
    80002144:	4789                	li	a5,2
    80002146:	00f70d63          	beq	a4,a5,80002160 <kkill+0x62>
      release(&p->lock);
    8000214a:	8526                	mv	a0,s1
    8000214c:	b77fe0ef          	jal	80000cc2 <release>
      return 0;
    80002150:	4501                	li	a0,0
  }
  return -1;
}
    80002152:	70a2                	ld	ra,40(sp)
    80002154:	7402                	ld	s0,32(sp)
    80002156:	64e2                	ld	s1,24(sp)
    80002158:	6942                	ld	s2,16(sp)
    8000215a:	69a2                	ld	s3,8(sp)
    8000215c:	6145                	addi	sp,sp,48
    8000215e:	8082                	ret
        p->state = RUNNABLE;
    80002160:	478d                	li	a5,3
    80002162:	cc9c                	sw	a5,24(s1)
    80002164:	b7dd                	j	8000214a <kkill+0x4c>

0000000080002166 <setkilled>:

void
setkilled(struct proc *p)
{
    80002166:	1101                	addi	sp,sp,-32
    80002168:	ec06                	sd	ra,24(sp)
    8000216a:	e822                	sd	s0,16(sp)
    8000216c:	e426                	sd	s1,8(sp)
    8000216e:	1000                	addi	s0,sp,32
    80002170:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002172:	acdfe0ef          	jal	80000c3e <acquire>
  p->killed = 1;
    80002176:	4785                	li	a5,1
    80002178:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000217a:	8526                	mv	a0,s1
    8000217c:	b47fe0ef          	jal	80000cc2 <release>
}
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	64a2                	ld	s1,8(sp)
    80002186:	6105                	addi	sp,sp,32
    80002188:	8082                	ret

000000008000218a <killed>:

int
killed(struct proc *p)
{
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	e426                	sd	s1,8(sp)
    80002192:	e04a                	sd	s2,0(sp)
    80002194:	1000                	addi	s0,sp,32
    80002196:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002198:	aa7fe0ef          	jal	80000c3e <acquire>
  k = p->killed;
    8000219c:	549c                	lw	a5,40(s1)
    8000219e:	893e                	mv	s2,a5
  release(&p->lock);
    800021a0:	8526                	mv	a0,s1
    800021a2:	b21fe0ef          	jal	80000cc2 <release>
  return k;
}
    800021a6:	854a                	mv	a0,s2
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	64a2                	ld	s1,8(sp)
    800021ae:	6902                	ld	s2,0(sp)
    800021b0:	6105                	addi	sp,sp,32
    800021b2:	8082                	ret

00000000800021b4 <kwait>:
{
    800021b4:	715d                	addi	sp,sp,-80
    800021b6:	e486                	sd	ra,72(sp)
    800021b8:	e0a2                	sd	s0,64(sp)
    800021ba:	fc26                	sd	s1,56(sp)
    800021bc:	f84a                	sd	s2,48(sp)
    800021be:	f44e                	sd	s3,40(sp)
    800021c0:	f052                	sd	s4,32(sp)
    800021c2:	ec56                	sd	s5,24(sp)
    800021c4:	e85a                	sd	s6,16(sp)
    800021c6:	e45e                	sd	s7,8(sp)
    800021c8:	0880                	addi	s0,sp,80
    800021ca:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021cc:	f5cff0ef          	jal	80001928 <myproc>
    800021d0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021d2:	0000e517          	auipc	a0,0xe
    800021d6:	9e650513          	addi	a0,a0,-1562 # 8000fbb8 <wait_lock>
    800021da:	a65fe0ef          	jal	80000c3e <acquire>
        if (pp->state == ZOMBIE) {
    800021de:	4a15                	li	s4,5
        havekids = 1;
    800021e0:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021e2:	00014997          	auipc	s3,0x14
    800021e6:	9ee98993          	addi	s3,s3,-1554 # 80015bd0 <tickslock>
    release(&wait_lock);
    800021ea:	0000eb17          	auipc	s6,0xe
    800021ee:	9ceb0b13          	addi	s6,s6,-1586 # 8000fbb8 <wait_lock>
    800021f2:	a07d                	j	800022a0 <kwait+0xec>
          pid = pp->pid;
    800021f4:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    800021f8:	000b8e63          	beqz	s7,80002214 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    800021fc:	4711                	li	a4,4
    800021fe:	02c48693          	addi	a3,s1,44
    80002202:	865e                	mv	a2,s7
    80002204:	04893583          	ld	a1,72(s2)
    80002208:	05093503          	ld	a0,80(s2)
    8000220c:	b66ff0ef          	jal	80001572 <copyout>
          if (addr != 0 &&
    80002210:	02054c63          	bltz	a0,80002248 <kwait+0x94>
          pp->parent = 0;
    80002214:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    80002218:	8526                	mv	a0,s1
    8000221a:	8ddff0ef          	jal	80001af6 <freeproc>
          release(&pp->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	aa3fe0ef          	jal	80000cc2 <release>
          release(&wait_lock);
    80002224:	0000e517          	auipc	a0,0xe
    80002228:	99450513          	addi	a0,a0,-1644 # 8000fbb8 <wait_lock>
    8000222c:	a97fe0ef          	jal	80000cc2 <release>
}
    80002230:	854e                	mv	a0,s3
    80002232:	60a6                	ld	ra,72(sp)
    80002234:	6406                	ld	s0,64(sp)
    80002236:	74e2                	ld	s1,56(sp)
    80002238:	7942                	ld	s2,48(sp)
    8000223a:	79a2                	ld	s3,40(sp)
    8000223c:	7a02                	ld	s4,32(sp)
    8000223e:	6ae2                	ld	s5,24(sp)
    80002240:	6b42                	ld	s6,16(sp)
    80002242:	6ba2                	ld	s7,8(sp)
    80002244:	6161                	addi	sp,sp,80
    80002246:	8082                	ret
            release(&pp->lock);
    80002248:	8526                	mv	a0,s1
    8000224a:	a79fe0ef          	jal	80000cc2 <release>
            release(&wait_lock);
    8000224e:	0000e517          	auipc	a0,0xe
    80002252:	96a50513          	addi	a0,a0,-1686 # 8000fbb8 <wait_lock>
    80002256:	a6dfe0ef          	jal	80000cc2 <release>
            return -1;
    8000225a:	a8b9                	j	800022b8 <kwait+0x104>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000225c:	17048493          	addi	s1,s1,368
    80002260:	03348063          	beq	s1,s3,80002280 <kwait+0xcc>
      if (pp->parent == p) {
    80002264:	7c9c                	ld	a5,56(s1)
    80002266:	ff279be3          	bne	a5,s2,8000225c <kwait+0xa8>
        acquire(&pp->lock);
    8000226a:	8526                	mv	a0,s1
    8000226c:	9d3fe0ef          	jal	80000c3e <acquire>
        if (pp->state == ZOMBIE) {
    80002270:	4c9c                	lw	a5,24(s1)
    80002272:	f94781e3          	beq	a5,s4,800021f4 <kwait+0x40>
        release(&pp->lock);
    80002276:	8526                	mv	a0,s1
    80002278:	a4bfe0ef          	jal	80000cc2 <release>
        havekids = 1;
    8000227c:	8756                	mv	a4,s5
    8000227e:	bff9                	j	8000225c <kwait+0xa8>
    if (!havekids || killed(p)) {
    80002280:	c715                	beqz	a4,800022ac <kwait+0xf8>
    80002282:	854a                	mv	a0,s2
    80002284:	f07ff0ef          	jal	8000218a <killed>
    80002288:	e115                	bnez	a0,800022ac <kwait+0xf8>
    sleep_prepare(p); //DOC: wait-sleep
    8000228a:	854a                	mv	a0,s2
    8000228c:	ca5ff0ef          	jal	80001f30 <sleep_prepare>
    release(&wait_lock);
    80002290:	855a                	mv	a0,s6
    80002292:	a31fe0ef          	jal	80000cc2 <release>
    sleep();
    80002296:	cd7ff0ef          	jal	80001f6c <sleep>
    acquire(&wait_lock);
    8000229a:	855a                	mv	a0,s6
    8000229c:	9a3fe0ef          	jal	80000c3e <acquire>
    havekids = 0;
    800022a0:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800022a2:	0000e497          	auipc	s1,0xe
    800022a6:	d2e48493          	addi	s1,s1,-722 # 8000ffd0 <proc>
    800022aa:	bf6d                	j	80002264 <kwait+0xb0>
      release(&wait_lock);
    800022ac:	0000e517          	auipc	a0,0xe
    800022b0:	90c50513          	addi	a0,a0,-1780 # 8000fbb8 <wait_lock>
    800022b4:	a0ffe0ef          	jal	80000cc2 <release>
            return -1;
    800022b8:	59fd                	li	s3,-1
    800022ba:	bf9d                	j	80002230 <kwait+0x7c>

00000000800022bc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022bc:	7179                	addi	sp,sp,-48
    800022be:	f406                	sd	ra,40(sp)
    800022c0:	f022                	sd	s0,32(sp)
    800022c2:	ec26                	sd	s1,24(sp)
    800022c4:	e84a                	sd	s2,16(sp)
    800022c6:	e44e                	sd	s3,8(sp)
    800022c8:	e052                	sd	s4,0(sp)
    800022ca:	1800                	addi	s0,sp,48
    800022cc:	84aa                	mv	s1,a0
    800022ce:	8a2e                	mv	s4,a1
    800022d0:	89b2                	mv	s3,a2
    800022d2:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022d4:	e54ff0ef          	jal	80001928 <myproc>
  if (user_dst) {
    800022d8:	c085                	beqz	s1,800022f8 <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    800022da:	874a                	mv	a4,s2
    800022dc:	86ce                	mv	a3,s3
    800022de:	8652                	mv	a2,s4
    800022e0:	652c                	ld	a1,72(a0)
    800022e2:	6928                	ld	a0,80(a0)
    800022e4:	a8eff0ef          	jal	80001572 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022e8:	70a2                	ld	ra,40(sp)
    800022ea:	7402                	ld	s0,32(sp)
    800022ec:	64e2                	ld	s1,24(sp)
    800022ee:	6942                	ld	s2,16(sp)
    800022f0:	69a2                	ld	s3,8(sp)
    800022f2:	6a02                	ld	s4,0(sp)
    800022f4:	6145                	addi	sp,sp,48
    800022f6:	8082                	ret
    memmove((char *)dst, src, len);
    800022f8:	0009061b          	sext.w	a2,s2
    800022fc:	85ce                	mv	a1,s3
    800022fe:	8552                	mv	a0,s4
    80002300:	a57fe0ef          	jal	80000d56 <memmove>
    return 0;
    80002304:	8526                	mv	a0,s1
    80002306:	b7cd                	j	800022e8 <either_copyout+0x2c>

0000000080002308 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002308:	7179                	addi	sp,sp,-48
    8000230a:	f406                	sd	ra,40(sp)
    8000230c:	f022                	sd	s0,32(sp)
    8000230e:	ec26                	sd	s1,24(sp)
    80002310:	e84a                	sd	s2,16(sp)
    80002312:	e44e                	sd	s3,8(sp)
    80002314:	e052                	sd	s4,0(sp)
    80002316:	1800                	addi	s0,sp,48
    80002318:	8a2a                	mv	s4,a0
    8000231a:	84ae                	mv	s1,a1
    8000231c:	89b2                	mv	s3,a2
    8000231e:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002320:	e08ff0ef          	jal	80001928 <myproc>
  if (user_src) {
    80002324:	c085                	beqz	s1,80002344 <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    80002326:	874a                	mv	a4,s2
    80002328:	86ce                	mv	a3,s3
    8000232a:	8652                	mv	a2,s4
    8000232c:	652c                	ld	a1,72(a0)
    8000232e:	6928                	ld	a0,80(a0)
    80002330:	b02ff0ef          	jal	80001632 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002334:	70a2                	ld	ra,40(sp)
    80002336:	7402                	ld	s0,32(sp)
    80002338:	64e2                	ld	s1,24(sp)
    8000233a:	6942                	ld	s2,16(sp)
    8000233c:	69a2                	ld	s3,8(sp)
    8000233e:	6a02                	ld	s4,0(sp)
    80002340:	6145                	addi	sp,sp,48
    80002342:	8082                	ret
    memmove(dst, (char *)src, len);
    80002344:	0009061b          	sext.w	a2,s2
    80002348:	85ce                	mv	a1,s3
    8000234a:	8552                	mv	a0,s4
    8000234c:	a0bfe0ef          	jal	80000d56 <memmove>
    return 0;
    80002350:	8526                	mv	a0,s1
    80002352:	b7cd                	j	80002334 <either_copyin+0x2c>

0000000080002354 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002354:	715d                	addi	sp,sp,-80
    80002356:	e486                	sd	ra,72(sp)
    80002358:	e0a2                	sd	s0,64(sp)
    8000235a:	fc26                	sd	s1,56(sp)
    8000235c:	f84a                	sd	s2,48(sp)
    8000235e:	f44e                	sd	s3,40(sp)
    80002360:	f052                	sd	s4,32(sp)
    80002362:	ec56                	sd	s5,24(sp)
    80002364:	e85a                	sd	s6,16(sp)
    80002366:	e45e                	sd	s7,8(sp)
    80002368:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    8000236a:	00005517          	auipc	a0,0x5
    8000236e:	d0e50513          	addi	a0,a0,-754 # 80007078 <etext+0x78>
    80002372:	99efe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002376:	0000e497          	auipc	s1,0xe
    8000237a:	db248493          	addi	s1,s1,-590 # 80010128 <proc+0x158>
    8000237e:	00014917          	auipc	s2,0x14
    80002382:	9aa90913          	addi	s2,s2,-1622 # 80015d28 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002386:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002388:	00005a97          	auipc	s5,0x5
    8000238c:	e98a8a93          	addi	s5,s5,-360 # 80007220 <etext+0x220>
    printk("%d %s %s", p->pid, state, p->name);
    80002390:	00005a17          	auipc	s4,0x5
    80002394:	e98a0a13          	addi	s4,s4,-360 # 80007228 <etext+0x228>
    printk("\n");
    80002398:	00005997          	auipc	s3,0x5
    8000239c:	ce098993          	addi	s3,s3,-800 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023a0:	00005b97          	auipc	s7,0x5
    800023a4:	4c0b8b93          	addi	s7,s7,1216 # 80007860 <states.0>
    800023a8:	a829                	j	800023c2 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    800023aa:	ed86a583          	lw	a1,-296(a3)
    800023ae:	8552                	mv	a0,s4
    800023b0:	960fe0ef          	jal	80000510 <printk>
    printk("\n");
    800023b4:	854e                	mv	a0,s3
    800023b6:	95afe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800023ba:	17048493          	addi	s1,s1,368
    800023be:	03248063          	beq	s1,s2,800023de <procdump+0x8a>
    if (p->state == UNUSED)
    800023c2:	86a6                	mv	a3,s1
    800023c4:	ec04a783          	lw	a5,-320(s1)
    800023c8:	dbed                	beqz	a5,800023ba <procdump+0x66>
      state = "???";
    800023ca:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023cc:	fcfb6fe3          	bltu	s6,a5,800023aa <procdump+0x56>
    800023d0:	02079713          	slli	a4,a5,0x20
    800023d4:	01d75793          	srli	a5,a4,0x1d
    800023d8:	97de                	add	a5,a5,s7
    800023da:	6390                	ld	a2,0(a5)
      state = states[p->state];
    800023dc:	b7f9                	j	800023aa <procdump+0x56>
  }
}
    800023de:	60a6                	ld	ra,72(sp)
    800023e0:	6406                	ld	s0,64(sp)
    800023e2:	74e2                	ld	s1,56(sp)
    800023e4:	7942                	ld	s2,48(sp)
    800023e6:	79a2                	ld	s3,40(sp)
    800023e8:	7a02                	ld	s4,32(sp)
    800023ea:	6ae2                	ld	s5,24(sp)
    800023ec:	6b42                	ld	s6,16(sp)
    800023ee:	6ba2                	ld	s7,8(sp)
    800023f0:	6161                	addi	sp,sp,80
    800023f2:	8082                	ret

00000000800023f4 <nproc>:


uint64
nproc(void)
{
    800023f4:	7179                	addi	sp,sp,-48
    800023f6:	f406                	sd	ra,40(sp)
    800023f8:	f022                	sd	s0,32(sp)
    800023fa:	ec26                	sd	s1,24(sp)
    800023fc:	e84a                	sd	s2,16(sp)
    800023fe:	e44e                	sd	s3,8(sp)
    80002400:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 count = 0;
    80002402:	4901                	li	s2,0

  for (p = proc; p < &proc[NPROC]; p++){
    80002404:	0000e497          	auipc	s1,0xe
    80002408:	bcc48493          	addi	s1,s1,-1076 # 8000ffd0 <proc>
    8000240c:	00013997          	auipc	s3,0x13
    80002410:	7c498993          	addi	s3,s3,1988 # 80015bd0 <tickslock>
    acquire(&p->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	829fe0ef          	jal	80000c3e <acquire>
    if (p->state != UNUSED)
    8000241a:	4c9c                	lw	a5,24(s1)
      count++;
    8000241c:	00f037b3          	snez	a5,a5
    80002420:	993e                	add	s2,s2,a5
    release(&p->lock);
    80002422:	8526                	mv	a0,s1
    80002424:	89ffe0ef          	jal	80000cc2 <release>
  for (p = proc; p < &proc[NPROC]; p++){
    80002428:	17048493          	addi	s1,s1,368
    8000242c:	ff3494e3          	bne	s1,s3,80002414 <nproc+0x20>
  }

  return count;
}
    80002430:	854a                	mv	a0,s2
    80002432:	70a2                	ld	ra,40(sp)
    80002434:	7402                	ld	s0,32(sp)
    80002436:	64e2                	ld	s1,24(sp)
    80002438:	6942                	ld	s2,16(sp)
    8000243a:	69a2                	ld	s3,8(sp)
    8000243c:	6145                	addi	sp,sp,48
    8000243e:	8082                	ret

0000000080002440 <proc_getprocs>:


int
proc_getprocs(uint64 addr, int max)
{
    80002440:	7135                	addi	sp,sp,-160
    80002442:	ed06                	sd	ra,152(sp)
    80002444:	e922                	sd	s0,144(sp)
    80002446:	e14a                	sd	s2,128(sp)
    80002448:	fcce                	sd	s3,120(sp)
    8000244a:	f0da                	sd	s6,96(sp)
    8000244c:	1100                	addi	s0,sp,160
    8000244e:	89aa                	mv	s3,a0
    80002450:	8b2e                	mv	s6,a1
  struct proc *p;
  struct uproc info;
  int count = 0;
  uint64 dst;
  struct proc *current = myproc();
    80002452:	cd6ff0ef          	jal	80001928 <myproc>

  if (max < 0)
    80002456:	040b4863          	bltz	s6,800024a6 <proc_getprocs+0x66>
    8000245a:	e526                	sd	s1,136(sp)
    8000245c:	f8d2                	sd	s4,112(sp)
    8000245e:	f4d6                	sd	s5,104(sp)
    80002460:	ecde                	sd	s7,88(sp)
    80002462:	e8e2                	sd	s8,80(sp)
    80002464:	e4e6                	sd	s9,72(sp)
    80002466:	e0ea                	sd	s10,64(sp)
    80002468:	fc6e                	sd	s11,56(sp)
    8000246a:	8aaa                	mv	s5,a0
    8000246c:	4901                	li	s2,0
    8000246e:	0000e497          	auipc	s1,0xe
    80002472:	b6248493          	addi	s1,s1,-1182 # 8000ffd0 <proc>
    return -1;

  dst = addr;

  for (p = proc; p < &proc[NPROC] && count < max; p++){
    acquire(&wait_lock);
    80002476:	0000da17          	auipc	s4,0xd
    8000247a:	742a0a13          	addi	s4,s4,1858 # 8000fbb8 <wait_lock>
    if (p->state != UNUSED){
      info.pid = p->pid;
      info.ppid = p->parent ? p->parent->pid : 0;
      info.state = p->state;
      info.sz = p->sz;
      safestrcpy(info.name, p->name, sizeof(info.name));
    8000247e:	f6840d93          	addi	s11,s0,-152
    80002482:	f8040d13          	addi	s10,s0,-128
    80002486:	4cc1                	li	s9,16
      release(&p->lock);
      release(&wait_lock);

      if (copyout(current->pagetable, current->sz, dst,
    80002488:	02800c13          	li	s8,40
  for (p = proc; p < &proc[NPROC] && count < max; p++){
    8000248c:	00013b97          	auipc	s7,0x13
    80002490:	744b8b93          	addi	s7,s7,1860 # 80015bd0 <tickslock>
    80002494:	a085                	j	800024f4 <proc_getprocs+0xb4>
    80002496:	64aa                	ld	s1,136(sp)
    80002498:	7a46                	ld	s4,112(sp)
    8000249a:	7aa6                	ld	s5,104(sp)
    8000249c:	6be6                	ld	s7,88(sp)
    8000249e:	6c46                	ld	s8,80(sp)
    800024a0:	6ca6                	ld	s9,72(sp)
    800024a2:	6d06                	ld	s10,64(sp)
    800024a4:	7de2                	ld	s11,56(sp)
    return -1;
    800024a6:	597d                	li	s2,-1
    800024a8:	a841                	j	80002538 <proc_getprocs+0xf8>
      info.ppid = p->parent ? p->parent->pid : 0;
    800024aa:	f6e42623          	sw	a4,-148(s0)
      info.state = p->state;
    800024ae:	f6f42823          	sw	a5,-144(s0)
      info.sz = p->sz;
    800024b2:	64bc                	ld	a5,72(s1)
    800024b4:	f6f43c23          	sd	a5,-136(s0)
      safestrcpy(info.name, p->name, sizeof(info.name));
    800024b8:	8666                	mv	a2,s9
    800024ba:	15858593          	addi	a1,a1,344
    800024be:	856a                	mv	a0,s10
    800024c0:	985fe0ef          	jal	80000e44 <safestrcpy>
      release(&p->lock);
    800024c4:	8526                	mv	a0,s1
    800024c6:	ffcfe0ef          	jal	80000cc2 <release>
      release(&wait_lock);
    800024ca:	8552                	mv	a0,s4
    800024cc:	ff6fe0ef          	jal	80000cc2 <release>
      if (copyout(current->pagetable, current->sz, dst,
    800024d0:	8762                	mv	a4,s8
    800024d2:	86ee                	mv	a3,s11
    800024d4:	864e                	mv	a2,s3
    800024d6:	048ab583          	ld	a1,72(s5)
    800024da:	050ab503          	ld	a0,80(s5)
    800024de:	894ff0ef          	jal	80001572 <copyout>
    800024e2:	fa054ae3          	bltz	a0,80002496 <proc_getprocs+0x56>
                 (char *)&info, sizeof(info)) < 0)
        return -1;

      dst += sizeof(info);
    800024e6:	02898993          	addi	s3,s3,40
      count++;
    800024ea:	2905                	addiw	s2,s2,1
  for (p = proc; p < &proc[NPROC] && count < max; p++){
    800024ec:	17048493          	addi	s1,s1,368
    800024f0:	05748c63          	beq	s1,s7,80002548 <proc_getprocs+0x108>
    800024f4:	03695a63          	bge	s2,s6,80002528 <proc_getprocs+0xe8>
    acquire(&wait_lock);
    800024f8:	8552                	mv	a0,s4
    800024fa:	f44fe0ef          	jal	80000c3e <acquire>
    acquire(&p->lock);
    800024fe:	8526                	mv	a0,s1
    80002500:	f3efe0ef          	jal	80000c3e <acquire>
    if (p->state != UNUSED){
    80002504:	4c9c                	lw	a5,24(s1)
    80002506:	cb91                	beqz	a5,8000251a <proc_getprocs+0xda>
    80002508:	85a6                	mv	a1,s1
      info.pid = p->pid;
    8000250a:	5898                	lw	a4,48(s1)
    8000250c:	f6e42423          	sw	a4,-152(s0)
      info.ppid = p->parent ? p->parent->pid : 0;
    80002510:	7c94                	ld	a3,56(s1)
    80002512:	4701                	li	a4,0
    80002514:	dad9                	beqz	a3,800024aa <proc_getprocs+0x6a>
    80002516:	5a98                	lw	a4,48(a3)
    80002518:	bf49                	j	800024aa <proc_getprocs+0x6a>
    } else {
      release(&p->lock);
    8000251a:	8526                	mv	a0,s1
    8000251c:	fa6fe0ef          	jal	80000cc2 <release>
      release(&wait_lock);
    80002520:	8552                	mv	a0,s4
    80002522:	fa0fe0ef          	jal	80000cc2 <release>
    80002526:	b7d9                	j	800024ec <proc_getprocs+0xac>
    80002528:	64aa                	ld	s1,136(sp)
    8000252a:	7a46                	ld	s4,112(sp)
    8000252c:	7aa6                	ld	s5,104(sp)
    8000252e:	6be6                	ld	s7,88(sp)
    80002530:	6c46                	ld	s8,80(sp)
    80002532:	6ca6                	ld	s9,72(sp)
    80002534:	6d06                	ld	s10,64(sp)
    80002536:	7de2                	ld	s11,56(sp)
    }
  }

  return count;
    80002538:	854a                	mv	a0,s2
    8000253a:	60ea                	ld	ra,152(sp)
    8000253c:	644a                	ld	s0,144(sp)
    8000253e:	690a                	ld	s2,128(sp)
    80002540:	79e6                	ld	s3,120(sp)
    80002542:	7b06                	ld	s6,96(sp)
    80002544:	610d                	addi	sp,sp,160
    80002546:	8082                	ret
    80002548:	64aa                	ld	s1,136(sp)
    8000254a:	7a46                	ld	s4,112(sp)
    8000254c:	7aa6                	ld	s5,104(sp)
    8000254e:	6be6                	ld	s7,88(sp)
    80002550:	6c46                	ld	s8,80(sp)
    80002552:	6ca6                	ld	s9,72(sp)
    80002554:	6d06                	ld	s10,64(sp)
    80002556:	7de2                	ld	s11,56(sp)
    80002558:	b7c5                	j	80002538 <proc_getprocs+0xf8>

000000008000255a <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000255a:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000255e:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002562:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002564:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002566:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000256a:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000256e:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002572:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002576:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000257a:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000257e:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002582:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002586:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000258a:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000258e:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002592:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002596:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002598:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000259a:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000259e:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800025a2:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800025a6:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800025aa:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800025ae:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800025b2:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800025b6:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800025ba:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800025be:	0685bd83          	ld	s11,104(a1)
        
        ret
    800025c2:	8082                	ret

00000000800025c4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025c4:	1141                	addi	sp,sp,-16
    800025c6:	e406                	sd	ra,8(sp)
    800025c8:	e022                	sd	s0,0(sp)
    800025ca:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800025cc:	00005597          	auipc	a1,0x5
    800025d0:	c9c58593          	addi	a1,a1,-868 # 80007268 <etext+0x268>
    800025d4:	00013517          	auipc	a0,0x13
    800025d8:	5fc50513          	addi	a0,a0,1532 # 80015bd0 <tickslock>
    800025dc:	de2fe0ef          	jal	80000bbe <initlock>
}
    800025e0:	60a2                	ld	ra,8(sp)
    800025e2:	6402                	ld	s0,0(sp)
    800025e4:	0141                	addi	sp,sp,16
    800025e6:	8082                	ret

00000000800025e8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800025e8:	1141                	addi	sp,sp,-16
    800025ea:	e406                	sd	ra,8(sp)
    800025ec:	e022                	sd	s0,0(sp)
    800025ee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    800025f0:	00003797          	auipc	a5,0x3
    800025f4:	32078793          	addi	a5,a5,800 # 80005910 <kernelvec>
    800025f8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025fc:	60a2                	ld	ra,8(sp)
    800025fe:	6402                	ld	s0,0(sp)
    80002600:	0141                	addi	sp,sp,16
    80002602:	8082                	ret

0000000080002604 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002604:	1141                	addi	sp,sp,-16
    80002606:	e406                	sd	ra,8(sp)
    80002608:	e022                	sd	s0,0(sp)
    8000260a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000260c:	b1cff0ef          	jal	80001928 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002610:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002614:	04000737          	lui	a4,0x4000
    80002618:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000261a:	0732                	slli	a4,a4,0xc
    8000261c:	00004797          	auipc	a5,0x4
    80002620:	9e478793          	addi	a5,a5,-1564 # 80006000 <_trampoline>
    80002624:	00004697          	auipc	a3,0x4
    80002628:	9dc68693          	addi	a3,a3,-1572 # 80006000 <_trampoline>
    8000262c:	8f95                	sub	a5,a5,a3
    8000262e:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002630:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002634:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002636:	18002773          	csrr	a4,satp
    8000263a:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000263c:	6d38                	ld	a4,88(a0)
    8000263e:	613c                	ld	a5,64(a0)
    80002640:	6685                	lui	a3,0x1
    80002642:	97b6                	add	a5,a5,a3
    80002644:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002646:	6d3c                	ld	a5,88(a0)
    80002648:	00000717          	auipc	a4,0x0
    8000264c:	0f470713          	addi	a4,a4,244 # 8000273c <usertrap>
    80002650:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002652:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002654:	8712                	mv	a4,tp
    80002656:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002658:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000265c:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002660:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002664:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002668:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000266a:	6f9c                	ld	a5,24(a5)
    8000266c:	14179073          	csrw	sepc,a5
}
    80002670:	60a2                	ld	ra,8(sp)
    80002672:	6402                	ld	s0,0(sp)
    80002674:	0141                	addi	sp,sp,16
    80002676:	8082                	ret

0000000080002678 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002678:	1141                	addi	sp,sp,-16
    8000267a:	e406                	sd	ra,8(sp)
    8000267c:	e022                	sd	s0,0(sp)
    8000267e:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80002680:	a74ff0ef          	jal	800018f4 <cpuid>
    80002684:	cd11                	beqz	a0,800026a0 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    80002686:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000268a:	000f4737          	lui	a4,0xf4
    8000268e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002692:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80002694:	14d79073          	csrw	stimecmp,a5
}
    80002698:	60a2                	ld	ra,8(sp)
    8000269a:	6402                	ld	s0,0(sp)
    8000269c:	0141                	addi	sp,sp,16
    8000269e:	8082                	ret
    acquire(&tickslock);
    800026a0:	00013517          	auipc	a0,0x13
    800026a4:	53050513          	addi	a0,a0,1328 # 80015bd0 <tickslock>
    800026a8:	d96fe0ef          	jal	80000c3e <acquire>
    ticks++;
    800026ac:	00005717          	auipc	a4,0x5
    800026b0:	3d470713          	addi	a4,a4,980 # 80007a80 <ticks>
    800026b4:	431c                	lw	a5,0(a4)
    800026b6:	2785                	addiw	a5,a5,1
    800026b8:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    800026ba:	853a                	mv	a0,a4
    800026bc:	8e1ff0ef          	jal	80001f9c <wakeup>
    release(&tickslock);
    800026c0:	00013517          	auipc	a0,0x13
    800026c4:	51050513          	addi	a0,a0,1296 # 80015bd0 <tickslock>
    800026c8:	dfafe0ef          	jal	80000cc2 <release>
    800026cc:	bf6d                	j	80002686 <clockintr+0xe>

00000000800026ce <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800026ce:	1101                	addi	sp,sp,-32
    800026d0:	ec06                	sd	ra,24(sp)
    800026d2:	e822                	sd	s0,16(sp)
    800026d4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    800026d6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    800026da:	57fd                	li	a5,-1
    800026dc:	17fe                	slli	a5,a5,0x3f
    800026de:	07a5                	addi	a5,a5,9
    800026e0:	00f70c63          	beq	a4,a5,800026f8 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    800026e4:	57fd                	li	a5,-1
    800026e6:	17fe                	slli	a5,a5,0x3f
    800026e8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800026ea:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    800026ec:	04f70463          	beq	a4,a5,80002734 <devintr+0x66>
  }
}
    800026f0:	60e2                	ld	ra,24(sp)
    800026f2:	6442                	ld	s0,16(sp)
    800026f4:	6105                	addi	sp,sp,32
    800026f6:	8082                	ret
    800026f8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800026fa:	2c2030ef          	jal	800059bc <plic_claim>
    800026fe:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002700:	47a9                	li	a5,10
    80002702:	02f50363          	beq	a0,a5,80002728 <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    80002706:	4785                	li	a5,1
    80002708:	02f50363          	beq	a0,a5,8000272e <devintr+0x60>
    } else if (irq) {
    8000270c:	c919                	beqz	a0,80002722 <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    8000270e:	85aa                	mv	a1,a0
    80002710:	00005517          	auipc	a0,0x5
    80002714:	b6050513          	addi	a0,a0,-1184 # 80007270 <etext+0x270>
    80002718:	df9fd0ef          	jal	80000510 <printk>
      plic_complete(irq);
    8000271c:	8526                	mv	a0,s1
    8000271e:	2be030ef          	jal	800059dc <plic_complete>
    return 1;
    80002722:	4505                	li	a0,1
    80002724:	64a2                	ld	s1,8(sp)
    80002726:	b7e9                	j	800026f0 <devintr+0x22>
      uartintr();
    80002728:	ab6fe0ef          	jal	800009de <uartintr>
    if (irq)
    8000272c:	bfc5                	j	8000271c <devintr+0x4e>
      virtio_disk_intr();
    8000272e:	734030ef          	jal	80005e62 <virtio_disk_intr>
    if (irq)
    80002732:	b7ed                	j	8000271c <devintr+0x4e>
    clockintr();
    80002734:	f45ff0ef          	jal	80002678 <clockintr>
    return 2;
    80002738:	4509                	li	a0,2
    8000273a:	bf5d                	j	800026f0 <devintr+0x22>

000000008000273c <usertrap>:
{
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	e04a                	sd	s2,0(sp)
    80002746:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002748:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    8000274c:	1007f793          	andi	a5,a5,256
    80002750:	eba5                	bnez	a5,800027c0 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002752:	00003797          	auipc	a5,0x3
    80002756:	1be78793          	addi	a5,a5,446 # 80005910 <kernelvec>
    8000275a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000275e:	9caff0ef          	jal	80001928 <myproc>
    80002762:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002764:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002766:	14102773          	csrr	a4,sepc
    8000276a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    8000276c:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002770:	47a1                	li	a5,8
    80002772:	04f70d63          	beq	a4,a5,800027cc <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    80002776:	f59ff0ef          	jal	800026ce <devintr>
    8000277a:	892a                	mv	s2,a0
    8000277c:	e54d                	bnez	a0,80002826 <usertrap+0xea>
    8000277e:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002782:	47bd                	li	a5,15
    80002784:	08f70463          	beq	a4,a5,8000280c <usertrap+0xd0>
    80002788:	14202773          	csrr	a4,scause
    8000278c:	47b5                	li	a5,13
    8000278e:	06f70f63          	beq	a4,a5,8000280c <usertrap+0xd0>
    80002792:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002796:	5890                	lw	a2,48(s1)
    80002798:	00005517          	auipc	a0,0x5
    8000279c:	b1850513          	addi	a0,a0,-1256 # 800072b0 <etext+0x2b0>
    800027a0:	d71fd0ef          	jal	80000510 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800027a4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800027a8:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027ac:	00005517          	auipc	a0,0x5
    800027b0:	b3450513          	addi	a0,a0,-1228 # 800072e0 <etext+0x2e0>
    800027b4:	d5dfd0ef          	jal	80000510 <printk>
    setkilled(p);
    800027b8:	8526                	mv	a0,s1
    800027ba:	9adff0ef          	jal	80002166 <setkilled>
    800027be:	a015                	j	800027e2 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    800027c0:	00005517          	auipc	a0,0x5
    800027c4:	ad050513          	addi	a0,a0,-1328 # 80007290 <etext+0x290>
    800027c8:	880fe0ef          	jal	80000848 <panic>
    if (killed(p))
    800027cc:	9bfff0ef          	jal	8000218a <killed>
    800027d0:	e915                	bnez	a0,80002804 <usertrap+0xc8>
    p->trapframe->epc += 4;
    800027d2:	6cb8                	ld	a4,88(s1)
    800027d4:	6f1c                	ld	a5,24(a4)
    800027d6:	0791                	addi	a5,a5,4
    800027d8:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800027da:	10016073          	csrsi	sstatus,2
    syscall();
    800027de:	240000ef          	jal	80002a1e <syscall>
  if (killed(p))
    800027e2:	8526                	mv	a0,s1
    800027e4:	9a7ff0ef          	jal	8000218a <killed>
    800027e8:	e521                	bnez	a0,80002830 <usertrap+0xf4>
  prepare_return();
    800027ea:	e1bff0ef          	jal	80002604 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800027ee:	68a8                	ld	a0,80(s1)
    800027f0:	8131                	srli	a0,a0,0xc
    800027f2:	57fd                	li	a5,-1
    800027f4:	17fe                	slli	a5,a5,0x3f
    800027f6:	8d5d                	or	a0,a0,a5
}
    800027f8:	60e2                	ld	ra,24(sp)
    800027fa:	6442                	ld	s0,16(sp)
    800027fc:	64a2                	ld	s1,8(sp)
    800027fe:	6902                	ld	s2,0(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret
      kexit(-1);
    80002804:	557d                	li	a0,-1
    80002806:	853ff0ef          	jal	80002058 <kexit>
    8000280a:	b7e1                	j	800027d2 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000280c:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002810:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80002814:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80002816:	0016b693          	seqz	a3,a3
    8000281a:	64ac                	ld	a1,72(s1)
    8000281c:	68a8                	ld	a0,80(s1)
    8000281e:	cddfe0ef          	jal	800014fa <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002822:	f161                	bnez	a0,800027e2 <usertrap+0xa6>
    80002824:	b7bd                	j	80002792 <usertrap+0x56>
  if (killed(p))
    80002826:	8526                	mv	a0,s1
    80002828:	963ff0ef          	jal	8000218a <killed>
    8000282c:	c511                	beqz	a0,80002838 <usertrap+0xfc>
    8000282e:	a011                	j	80002832 <usertrap+0xf6>
    80002830:	4901                	li	s2,0
    kexit(-1);
    80002832:	557d                	li	a0,-1
    80002834:	825ff0ef          	jal	80002058 <kexit>
  if (which_dev == 2)
    80002838:	4789                	li	a5,2
    8000283a:	faf918e3          	bne	s2,a5,800027ea <usertrap+0xae>
    yield();
    8000283e:	ec6ff0ef          	jal	80001f04 <yield>
    80002842:	b765                	j	800027ea <usertrap+0xae>

0000000080002844 <kerneltrap>:
{
    80002844:	7179                	addi	sp,sp,-48
    80002846:	f406                	sd	ra,40(sp)
    80002848:	f022                	sd	s0,32(sp)
    8000284a:	ec26                	sd	s1,24(sp)
    8000284c:	e84a                	sd	s2,16(sp)
    8000284e:	e44e                	sd	s3,8(sp)
    80002850:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002852:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002856:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    8000285a:	142027f3          	csrr	a5,scause
    8000285e:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80002860:	1004f793          	andi	a5,s1,256
    80002864:	c795                	beqz	a5,80002890 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002866:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000286a:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    8000286c:	eb85                	bnez	a5,8000289c <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    8000286e:	e61ff0ef          	jal	800026ce <devintr>
    80002872:	c91d                	beqz	a0,800028a8 <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    80002874:	4789                	li	a5,2
    80002876:	04f50a63          	beq	a0,a5,800028ca <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000287a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000287e:	10049073          	csrw	sstatus,s1
}
    80002882:	70a2                	ld	ra,40(sp)
    80002884:	7402                	ld	s0,32(sp)
    80002886:	64e2                	ld	s1,24(sp)
    80002888:	6942                	ld	s2,16(sp)
    8000288a:	69a2                	ld	s3,8(sp)
    8000288c:	6145                	addi	sp,sp,48
    8000288e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002890:	00005517          	auipc	a0,0x5
    80002894:	a7850513          	addi	a0,a0,-1416 # 80007308 <etext+0x308>
    80002898:	fb1fd0ef          	jal	80000848 <panic>
    panic("kerneltrap: interrupts enabled");
    8000289c:	00005517          	auipc	a0,0x5
    800028a0:	a9450513          	addi	a0,a0,-1388 # 80007330 <etext+0x330>
    800028a4:	fa5fd0ef          	jal	80000848 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800028a8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800028ac:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800028b0:	85ce                	mv	a1,s3
    800028b2:	00005517          	auipc	a0,0x5
    800028b6:	a9e50513          	addi	a0,a0,-1378 # 80007350 <etext+0x350>
    800028ba:	c57fd0ef          	jal	80000510 <printk>
    panic("kerneltrap");
    800028be:	00005517          	auipc	a0,0x5
    800028c2:	aba50513          	addi	a0,a0,-1350 # 80007378 <etext+0x378>
    800028c6:	f83fd0ef          	jal	80000848 <panic>
  if (which_dev == 2 && myproc() != 0)
    800028ca:	85eff0ef          	jal	80001928 <myproc>
    800028ce:	d555                	beqz	a0,8000287a <kerneltrap+0x36>
    yield();
    800028d0:	e34ff0ef          	jal	80001f04 <yield>
    800028d4:	b75d                	j	8000287a <kerneltrap+0x36>

00000000800028d6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800028d6:	1101                	addi	sp,sp,-32
    800028d8:	ec06                	sd	ra,24(sp)
    800028da:	e822                	sd	s0,16(sp)
    800028dc:	e426                	sd	s1,8(sp)
    800028de:	1000                	addi	s0,sp,32
    800028e0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800028e2:	846ff0ef          	jal	80001928 <myproc>
  switch (n) {
    800028e6:	4795                	li	a5,5
    800028e8:	0497e163          	bltu	a5,s1,8000292a <argraw+0x54>
    800028ec:	048a                	slli	s1,s1,0x2
    800028ee:	00005717          	auipc	a4,0x5
    800028f2:	fa270713          	addi	a4,a4,-94 # 80007890 <states.0+0x30>
    800028f6:	94ba                	add	s1,s1,a4
    800028f8:	409c                	lw	a5,0(s1)
    800028fa:	97ba                	add	a5,a5,a4
    800028fc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800028fe:	6d3c                	ld	a5,88(a0)
    80002900:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002902:	60e2                	ld	ra,24(sp)
    80002904:	6442                	ld	s0,16(sp)
    80002906:	64a2                	ld	s1,8(sp)
    80002908:	6105                	addi	sp,sp,32
    8000290a:	8082                	ret
    return p->trapframe->a1;
    8000290c:	6d3c                	ld	a5,88(a0)
    8000290e:	7fa8                	ld	a0,120(a5)
    80002910:	bfcd                	j	80002902 <argraw+0x2c>
    return p->trapframe->a2;
    80002912:	6d3c                	ld	a5,88(a0)
    80002914:	63c8                	ld	a0,128(a5)
    80002916:	b7f5                	j	80002902 <argraw+0x2c>
    return p->trapframe->a3;
    80002918:	6d3c                	ld	a5,88(a0)
    8000291a:	67c8                	ld	a0,136(a5)
    8000291c:	b7dd                	j	80002902 <argraw+0x2c>
    return p->trapframe->a4;
    8000291e:	6d3c                	ld	a5,88(a0)
    80002920:	6bc8                	ld	a0,144(a5)
    80002922:	b7c5                	j	80002902 <argraw+0x2c>
    return p->trapframe->a5;
    80002924:	6d3c                	ld	a5,88(a0)
    80002926:	6fc8                	ld	a0,152(a5)
    80002928:	bfe9                	j	80002902 <argraw+0x2c>
  panic("argraw");
    8000292a:	00005517          	auipc	a0,0x5
    8000292e:	a5e50513          	addi	a0,a0,-1442 # 80007388 <etext+0x388>
    80002932:	f17fd0ef          	jal	80000848 <panic>

0000000080002936 <fetchaddr>:
{
    80002936:	1101                	addi	sp,sp,-32
    80002938:	ec06                	sd	ra,24(sp)
    8000293a:	e822                	sd	s0,16(sp)
    8000293c:	e426                	sd	s1,8(sp)
    8000293e:	e04a                	sd	s2,0(sp)
    80002940:	1000                	addi	s0,sp,32
    80002942:	84aa                	mv	s1,a0
    80002944:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002946:	fe3fe0ef          	jal	80001928 <myproc>
  if (addr >= p->sz ||
    8000294a:	652c                	ld	a1,72(a0)
    8000294c:	02b4f663          	bgeu	s1,a1,80002978 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002950:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    80002954:	02f5e263          	bltu	a1,a5,80002978 <fetchaddr+0x42>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80002958:	4721                	li	a4,8
    8000295a:	86a6                	mv	a3,s1
    8000295c:	864a                	mv	a2,s2
    8000295e:	6928                	ld	a0,80(a0)
    80002960:	cd3fe0ef          	jal	80001632 <copyin>
    80002964:	00a03533          	snez	a0,a0
    80002968:	40a0053b          	negw	a0,a0
}
    8000296c:	60e2                	ld	ra,24(sp)
    8000296e:	6442                	ld	s0,16(sp)
    80002970:	64a2                	ld	s1,8(sp)
    80002972:	6902                	ld	s2,0(sp)
    80002974:	6105                	addi	sp,sp,32
    80002976:	8082                	ret
    return -1;
    80002978:	557d                	li	a0,-1
    8000297a:	bfcd                	j	8000296c <fetchaddr+0x36>

000000008000297c <fetchstr>:
{
    8000297c:	7179                	addi	sp,sp,-48
    8000297e:	f406                	sd	ra,40(sp)
    80002980:	f022                	sd	s0,32(sp)
    80002982:	ec26                	sd	s1,24(sp)
    80002984:	e84a                	sd	s2,16(sp)
    80002986:	e44e                	sd	s3,8(sp)
    80002988:	1800                	addi	s0,sp,48
    8000298a:	89aa                	mv	s3,a0
    8000298c:	84ae                	mv	s1,a1
    8000298e:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002990:	f99fe0ef          	jal	80001928 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    80002994:	874a                	mv	a4,s2
    80002996:	86ce                	mv	a3,s3
    80002998:	8626                	mv	a2,s1
    8000299a:	652c                	ld	a1,72(a0)
    8000299c:	6928                	ld	a0,80(a0)
    8000299e:	d33fe0ef          	jal	800016d0 <copyinstr>
    800029a2:	00054c63          	bltz	a0,800029ba <fetchstr+0x3e>
  return strlen(buf);
    800029a6:	8526                	mv	a0,s1
    800029a8:	cd2fe0ef          	jal	80000e7a <strlen>
}
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
    return -1;
    800029ba:	557d                	li	a0,-1
    800029bc:	bfc5                	j	800029ac <fetchstr+0x30>

00000000800029be <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800029be:	1101                	addi	sp,sp,-32
    800029c0:	ec06                	sd	ra,24(sp)
    800029c2:	e822                	sd	s0,16(sp)
    800029c4:	e426                	sd	s1,8(sp)
    800029c6:	1000                	addi	s0,sp,32
    800029c8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029ca:	f0dff0ef          	jal	800028d6 <argraw>
    800029ce:	c088                	sw	a0,0(s1)
}
    800029d0:	60e2                	ld	ra,24(sp)
    800029d2:	6442                	ld	s0,16(sp)
    800029d4:	64a2                	ld	s1,8(sp)
    800029d6:	6105                	addi	sp,sp,32
    800029d8:	8082                	ret

00000000800029da <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800029da:	1101                	addi	sp,sp,-32
    800029dc:	ec06                	sd	ra,24(sp)
    800029de:	e822                	sd	s0,16(sp)
    800029e0:	e426                	sd	s1,8(sp)
    800029e2:	1000                	addi	s0,sp,32
    800029e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029e6:	ef1ff0ef          	jal	800028d6 <argraw>
    800029ea:	e088                	sd	a0,0(s1)
}
    800029ec:	60e2                	ld	ra,24(sp)
    800029ee:	6442                	ld	s0,16(sp)
    800029f0:	64a2                	ld	s1,8(sp)
    800029f2:	6105                	addi	sp,sp,32
    800029f4:	8082                	ret

00000000800029f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800029f6:	1101                	addi	sp,sp,-32
    800029f8:	ec06                	sd	ra,24(sp)
    800029fa:	e822                	sd	s0,16(sp)
    800029fc:	e426                	sd	s1,8(sp)
    800029fe:	e04a                	sd	s2,0(sp)
    80002a00:	1000                	addi	s0,sp,32
    80002a02:	892e                	mv	s2,a1
    80002a04:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002a06:	ed1ff0ef          	jal	800028d6 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002a0a:	8626                	mv	a2,s1
    80002a0c:	85ca                	mv	a1,s2
    80002a0e:	f6fff0ef          	jal	8000297c <fetchstr>
}
    80002a12:	60e2                	ld	ra,24(sp)
    80002a14:	6442                	ld	s0,16(sp)
    80002a16:	64a2                	ld	s1,8(sp)
    80002a18:	6902                	ld	s2,0(sp)
    80002a1a:	6105                	addi	sp,sp,32
    80002a1c:	8082                	ret

0000000080002a1e <syscall>:

};

void
syscall(void)
{
    80002a1e:	7131                	addi	sp,sp,-192
    80002a20:	fd06                	sd	ra,184(sp)
    80002a22:	f922                	sd	s0,176(sp)
    80002a24:	f526                	sd	s1,168(sp)
    80002a26:	f14a                	sd	s2,160(sp)
    80002a28:	0180                	addi	s0,sp,192
  int string_arg;
  int no_arg;
  int string_ok;
  uint64 arg0;
  char str[128];
  struct proc *p = myproc();
    80002a2a:	efffe0ef          	jal	80001928 <myproc>
    80002a2e:	84aa                	mv	s1,a0

num = p->trapframe->a7;
    80002a30:	6d34                	ld	a3,88(a0)
    80002a32:	76dc                	ld	a5,168(a3)
    80002a34:	0007891b          	sext.w	s2,a5

  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002a38:	fff7861b          	addiw	a2,a5,-1
    80002a3c:	4761                	li	a4,24
    80002a3e:	16c76363          	bltu	a4,a2,80002ba4 <syscall+0x186>
    80002a42:	ed4e                	sd	s3,152(sp)
    80002a44:	00391613          	slli	a2,s2,0x3
    80002a48:	00005717          	auipc	a4,0x5
    80002a4c:	e6070713          	addi	a4,a4,-416 # 800078a8 <syscalls>
    80002a50:	9732                	add	a4,a4,a2
    80002a52:	00073983          	ld	s3,0(a4)
    80002a56:	14098663          	beqz	s3,80002ba2 <syscall+0x184>
    80002a5a:	e952                	sd	s4,144(sp)
    80002a5c:	e556                	sd	s5,136(sp)
    arg0 = p->trapframe->a0;
    80002a5e:	7ab8                	ld	a4,112(a3)
    80002a60:	8aba                	mv	s5,a4

    string_arg = num == SYS_open || num == SYS_exec ||
    80002a62:	87ca                	mv	a5,s2
    80002a64:	4751                	li	a4,20
    80002a66:	05276a63          	bltu	a4,s2,80002aba <syscall+0x9c>
    80002a6a:	00108737          	lui	a4,0x108
    80002a6e:	28070713          	addi	a4,a4,640 # 108280 <_entry-0x7fef7d80>
    80002a72:	01275733          	srl	a4,a4,s2
    80002a76:	8b05                	andi	a4,a4,1
    arg0 = p->trapframe->a0;
    80002a78:	4685                	li	a3,1
    80002a7a:	c321                	beqz	a4,80002aba <syscall+0x9c>
    80002a7c:	00405737          	lui	a4,0x405
    80002a80:	80270713          	addi	a4,a4,-2046 # 404802 <_entry-0x7fbfb7fe>
    80002a84:	00f757b3          	srl	a5,a4,a5
    80002a88:	8b85                	andi	a5,a5,1
    80002a8a:	8a3e                	mv	s4,a5
    no_arg = num == SYS_fork || num == SYS_getpid ||
             num == SYS_uptime || num == SYS_sync;

    string_ok = 0;

    if (string_arg && (p->tracemask & (1 << num))) {
    80002a8c:	12068f63          	beqz	a3,80002bca <syscall+0x1ac>
    80002a90:	1684a783          	lw	a5,360(s1)
    80002a94:	4127d7bb          	sraw	a5,a5,s2
    80002a98:	8b85                	andi	a5,a5,1
    80002a9a:	ef95                	bnez	a5,80002ad6 <syscall+0xb8>
      if (fetchstr(arg0, str, sizeof(str)) >= 0)
        string_ok = 1;
    }

    ret = (int)syscalls[num]();
    80002a9c:	9982                	jalr	s3
    80002a9e:	0005071b          	sext.w	a4,a0
    p->trapframe->a0 = ret;
    80002aa2:	6cbc                	ld	a5,88(s1)
    80002aa4:	fbb8                	sd	a4,112(a5)

    if (p->tracemask & (1 << num)) {
    80002aa6:	1684a783          	lw	a5,360(s1)
    80002aaa:	4127d7bb          	sraw	a5,a5,s2
    80002aae:	8b85                	andi	a5,a5,1
    80002ab0:	efad                	bnez	a5,80002b2a <syscall+0x10c>
    80002ab2:	69ea                	ld	s3,152(sp)
    80002ab4:	6a4a                	ld	s4,144(sp)
    80002ab6:	6aaa                	ld	s5,136(sp)
    80002ab8:	a219                	j	80002bbe <syscall+0x1a0>
                 num == SYS_unlink || num == SYS_link ||
    80002aba:	fee9069b          	addiw	a3,s2,-18
    80002abe:	0026b693          	sltiu	a3,a3,2
    80002ac2:	fef90713          	addi	a4,s2,-17
    80002ac6:	00173713          	seqz	a4,a4
    80002aca:	8ed9                	or	a3,a3,a4
    no_arg = num == SYS_fork || num == SYS_getpid ||
    80002acc:	4759                	li	a4,22
             num == SYS_uptime || num == SYS_sync;
    80002ace:	4a01                	li	s4,0
    80002ad0:	faf776e3          	bgeu	a4,a5,80002a7c <syscall+0x5e>
    80002ad4:	bf65                	j	80002a8c <syscall+0x6e>
      if (fetchstr(arg0, str, sizeof(str)) >= 0)
    80002ad6:	08000613          	li	a2,128
    80002ada:	f4040593          	addi	a1,s0,-192
    80002ade:	8556                	mv	a0,s5
    80002ae0:	e9dff0ef          	jal	8000297c <fetchstr>
    80002ae4:	8a2a                	mv	s4,a0
    ret = (int)syscalls[num]();
    80002ae6:	9982                	jalr	s3
    80002ae8:	0005071b          	sext.w	a4,a0
    p->trapframe->a0 = ret;
    80002aec:	6cbc                	ld	a5,88(s1)
    80002aee:	fbb8                	sd	a4,112(a5)
    if (p->tracemask & (1 << num)) {
    80002af0:	1684a783          	lw	a5,360(s1)
    80002af4:	4127d7bb          	sraw	a5,a5,s2
    80002af8:	8b85                	andi	a5,a5,1
    80002afa:	0e078763          	beqz	a5,80002be8 <syscall+0x1ca>
      if (string_arg) {
        if (string_ok)
    80002afe:	020a4663          	bltz	s4,80002b2a <syscall+0x10c>
          printk("[%d] %s(\"%s\") -> %d\n",
    80002b02:	090e                	slli	s2,s2,0x3
    80002b04:	00005797          	auipc	a5,0x5
    80002b08:	da478793          	addi	a5,a5,-604 # 800078a8 <syscalls>
    80002b0c:	97ca                	add	a5,a5,s2
    80002b0e:	f4040693          	addi	a3,s0,-192
    80002b12:	6bf0                	ld	a2,208(a5)
    80002b14:	588c                	lw	a1,48(s1)
    80002b16:	00005517          	auipc	a0,0x5
    80002b1a:	87a50513          	addi	a0,a0,-1926 # 80007390 <etext+0x390>
    80002b1e:	9f3fd0ef          	jal	80000510 <printk>
    80002b22:	69ea                	ld	s3,152(sp)
    80002b24:	6a4a                	ld	s4,144(sp)
    80002b26:	6aaa                	ld	s5,136(sp)
    80002b28:	a859                	j	80002bbe <syscall+0x1a0>
                 p->pid, syscall_names[num], str, ret);
        else
          printk("[%d] %s(?) -> %d\n",
    80002b2a:	090e                	slli	s2,s2,0x3
    80002b2c:	00005797          	auipc	a5,0x5
    80002b30:	d7c78793          	addi	a5,a5,-644 # 800078a8 <syscalls>
    80002b34:	97ca                	add	a5,a5,s2
    80002b36:	86ba                	mv	a3,a4
    80002b38:	6bf0                	ld	a2,208(a5)
    80002b3a:	588c                	lw	a1,48(s1)
    80002b3c:	00005517          	auipc	a0,0x5
    80002b40:	86c50513          	addi	a0,a0,-1940 # 800073a8 <etext+0x3a8>
    80002b44:	9cdfd0ef          	jal	80000510 <printk>
    80002b48:	69ea                	ld	s3,152(sp)
    80002b4a:	6a4a                	ld	s4,144(sp)
    80002b4c:	6aaa                	ld	s5,136(sp)
    80002b4e:	a885                	j	80002bbe <syscall+0x1a0>
                 p->pid, syscall_names[num], ret);
      } else if (no_arg) {
    80002b50:	020a0563          	beqz	s4,80002b7a <syscall+0x15c>
        printk("[%d] %s() -> %d\n",
    80002b54:	090e                	slli	s2,s2,0x3
    80002b56:	00005797          	auipc	a5,0x5
    80002b5a:	d5278793          	addi	a5,a5,-686 # 800078a8 <syscalls>
    80002b5e:	97ca                	add	a5,a5,s2
    80002b60:	86ba                	mv	a3,a4
    80002b62:	6bf0                	ld	a2,208(a5)
    80002b64:	588c                	lw	a1,48(s1)
    80002b66:	00005517          	auipc	a0,0x5
    80002b6a:	85a50513          	addi	a0,a0,-1958 # 800073c0 <etext+0x3c0>
    80002b6e:	9a3fd0ef          	jal	80000510 <printk>
    80002b72:	69ea                	ld	s3,152(sp)
    80002b74:	6a4a                	ld	s4,144(sp)
    80002b76:	6aaa                	ld	s5,136(sp)
    80002b78:	a099                	j	80002bbe <syscall+0x1a0>
               p->pid, syscall_names[num], ret);
      } else {
        printk("[%d] %s(%d) -> %d\n",
    80002b7a:	090e                	slli	s2,s2,0x3
    80002b7c:	00005797          	auipc	a5,0x5
    80002b80:	d2c78793          	addi	a5,a5,-724 # 800078a8 <syscalls>
    80002b84:	97ca                	add	a5,a5,s2
    80002b86:	000a869b          	sext.w	a3,s5
    80002b8a:	6bf0                	ld	a2,208(a5)
    80002b8c:	588c                	lw	a1,48(s1)
    80002b8e:	00005517          	auipc	a0,0x5
    80002b92:	84a50513          	addi	a0,a0,-1974 # 800073d8 <etext+0x3d8>
    80002b96:	97bfd0ef          	jal	80000510 <printk>
    80002b9a:	69ea                	ld	s3,152(sp)
    80002b9c:	6a4a                	ld	s4,144(sp)
    80002b9e:	6aaa                	ld	s5,136(sp)
    80002ba0:	a839                	j	80002bbe <syscall+0x1a0>
    80002ba2:	69ea                	ld	s3,152(sp)
               p->pid, syscall_names[num], (int)arg0, ret);
      }
    }
  } else {
    printk("%d %s: unknown sys call %d\n",
    80002ba4:	86ca                	mv	a3,s2
    80002ba6:	15848613          	addi	a2,s1,344
    80002baa:	588c                	lw	a1,48(s1)
    80002bac:	00005517          	auipc	a0,0x5
    80002bb0:	84450513          	addi	a0,a0,-1980 # 800073f0 <etext+0x3f0>
    80002bb4:	95dfd0ef          	jal	80000510 <printk>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002bb8:	6cbc                	ld	a5,88(s1)
    80002bba:	577d                	li	a4,-1
    80002bbc:	fbb8                	sd	a4,112(a5)
  }
}
    80002bbe:	70ea                	ld	ra,184(sp)
    80002bc0:	744a                	ld	s0,176(sp)
    80002bc2:	74aa                	ld	s1,168(sp)
    80002bc4:	790a                	ld	s2,160(sp)
    80002bc6:	6129                	addi	sp,sp,192
    80002bc8:	8082                	ret
    ret = (int)syscalls[num]();
    80002bca:	9982                	jalr	s3
    80002bcc:	0005071b          	sext.w	a4,a0
    p->trapframe->a0 = ret;
    80002bd0:	6cbc                	ld	a5,88(s1)
    80002bd2:	fbb8                	sd	a4,112(a5)
    if (p->tracemask & (1 << num)) {
    80002bd4:	1684a783          	lw	a5,360(s1)
    80002bd8:	4127d7bb          	sraw	a5,a5,s2
    80002bdc:	8b85                	andi	a5,a5,1
    80002bde:	fbad                	bnez	a5,80002b50 <syscall+0x132>
    80002be0:	69ea                	ld	s3,152(sp)
    80002be2:	6a4a                	ld	s4,144(sp)
    80002be4:	6aaa                	ld	s5,136(sp)
    80002be6:	bfe1                	j	80002bbe <syscall+0x1a0>
    80002be8:	69ea                	ld	s3,152(sp)
    80002bea:	6a4a                	ld	s4,144(sp)
    80002bec:	6aaa                	ld	s5,136(sp)
    80002bee:	bfc1                	j	80002bbe <syscall+0x1a0>

0000000080002bf0 <sys_exit>:
#include "vm.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002bf0:	1101                	addi	sp,sp,-32
    80002bf2:	ec06                	sd	ra,24(sp)
    80002bf4:	e822                	sd	s0,16(sp)
    80002bf6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002bf8:	fec40593          	addi	a1,s0,-20
    80002bfc:	4501                	li	a0,0
    80002bfe:	dc1ff0ef          	jal	800029be <argint>
  kexit(n);
    80002c02:	fec42503          	lw	a0,-20(s0)
    80002c06:	c52ff0ef          	jal	80002058 <kexit>
  return 0; // not reached
}
    80002c0a:	4501                	li	a0,0
    80002c0c:	60e2                	ld	ra,24(sp)
    80002c0e:	6442                	ld	s0,16(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret

0000000080002c14 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c14:	1141                	addi	sp,sp,-16
    80002c16:	e406                	sd	ra,8(sp)
    80002c18:	e022                	sd	s0,0(sp)
    80002c1a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c1c:	d0dfe0ef          	jal	80001928 <myproc>
}
    80002c20:	5908                	lw	a0,48(a0)
    80002c22:	60a2                	ld	ra,8(sp)
    80002c24:	6402                	ld	s0,0(sp)
    80002c26:	0141                	addi	sp,sp,16
    80002c28:	8082                	ret

0000000080002c2a <sys_fork>:

uint64
sys_fork(void)
{
    80002c2a:	1141                	addi	sp,sp,-16
    80002c2c:	e406                	sd	ra,8(sp)
    80002c2e:	e022                	sd	s0,0(sp)
    80002c30:	0800                	addi	s0,sp,16
  return kfork();
    80002c32:	854ff0ef          	jal	80001c86 <kfork>
}
    80002c36:	60a2                	ld	ra,8(sp)
    80002c38:	6402                	ld	s0,0(sp)
    80002c3a:	0141                	addi	sp,sp,16
    80002c3c:	8082                	ret

0000000080002c3e <sys_wait>:

uint64
sys_wait(void)
{
    80002c3e:	1101                	addi	sp,sp,-32
    80002c40:	ec06                	sd	ra,24(sp)
    80002c42:	e822                	sd	s0,16(sp)
    80002c44:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002c46:	fe840593          	addi	a1,s0,-24
    80002c4a:	4501                	li	a0,0
    80002c4c:	d8fff0ef          	jal	800029da <argaddr>
  return kwait(p);
    80002c50:	fe843503          	ld	a0,-24(s0)
    80002c54:	d60ff0ef          	jal	800021b4 <kwait>
}
    80002c58:	60e2                	ld	ra,24(sp)
    80002c5a:	6442                	ld	s0,16(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret

0000000080002c60 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c60:	7179                	addi	sp,sp,-48
    80002c62:	f406                	sd	ra,40(sp)
    80002c64:	f022                	sd	s0,32(sp)
    80002c66:	ec26                	sd	s1,24(sp)
    80002c68:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002c6a:	fd840593          	addi	a1,s0,-40
    80002c6e:	4501                	li	a0,0
    80002c70:	d4fff0ef          	jal	800029be <argint>
  argint(1, &t);
    80002c74:	fdc40593          	addi	a1,s0,-36
    80002c78:	4505                	li	a0,1
    80002c7a:	d45ff0ef          	jal	800029be <argint>
  addr = myproc()->sz;
    80002c7e:	cabfe0ef          	jal	80001928 <myproc>
    80002c82:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002c84:	fdc42703          	lw	a4,-36(s0)
    80002c88:	4785                	li	a5,1
    80002c8a:	02f70a63          	beq	a4,a5,80002cbe <sys_sbrk+0x5e>
    80002c8e:	fd842783          	lw	a5,-40(s0)
    80002c92:	0207c663          	bltz	a5,80002cbe <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80002c96:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    80002c9a:	020007b7          	lui	a5,0x2000
    80002c9e:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002ca0:	07b6                	slli	a5,a5,0xd
    80002ca2:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    80002ca6:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    80002caa:	8fd9                	or	a5,a5,a4
    80002cac:	e79d                	bnez	a5,80002cda <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    80002cae:	c7bfe0ef          	jal	80001928 <myproc>
    80002cb2:	fd842703          	lw	a4,-40(s0)
    80002cb6:	653c                	ld	a5,72(a0)
    80002cb8:	97ba                	add	a5,a5,a4
    80002cba:	e53c                	sd	a5,72(a0)
    80002cbc:	a039                	j	80002cca <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    80002cbe:	fd842503          	lw	a0,-40(s0)
    80002cc2:	f67fe0ef          	jal	80001c28 <growproc>
    80002cc6:	00054863          	bltz	a0,80002cd6 <sys_sbrk+0x76>
  }
  return addr;
}
    80002cca:	8526                	mv	a0,s1
    80002ccc:	70a2                	ld	ra,40(sp)
    80002cce:	7402                	ld	s0,32(sp)
    80002cd0:	64e2                	ld	s1,24(sp)
    80002cd2:	6145                	addi	sp,sp,48
    80002cd4:	8082                	ret
      return -1;
    80002cd6:	54fd                	li	s1,-1
    80002cd8:	bfcd                	j	80002cca <sys_sbrk+0x6a>
      return -1;
    80002cda:	54fd                	li	s1,-1
    80002cdc:	b7fd                	j	80002cca <sys_sbrk+0x6a>

0000000080002cde <sys_pause>:

uint64
sys_pause(void)
{
    80002cde:	7139                	addi	sp,sp,-64
    80002ce0:	fc06                	sd	ra,56(sp)
    80002ce2:	f822                	sd	s0,48(sp)
    80002ce4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ce6:	fcc40593          	addi	a1,s0,-52
    80002cea:	4501                	li	a0,0
    80002cec:	cd3ff0ef          	jal	800029be <argint>
  if (n < 0)
    80002cf0:	fcc42783          	lw	a5,-52(s0)
    80002cf4:	0807c063          	bltz	a5,80002d74 <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002cf8:	00013517          	auipc	a0,0x13
    80002cfc:	ed850513          	addi	a0,a0,-296 # 80015bd0 <tickslock>
    80002d00:	f3ffd0ef          	jal	80000c3e <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002d04:	fcc42783          	lw	a5,-52(s0)
    80002d08:	cbb9                	beqz	a5,80002d5e <sys_pause+0x80>
    80002d0a:	f426                	sd	s1,40(sp)
    80002d0c:	f04a                	sd	s2,32(sp)
    80002d0e:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002d10:	00005997          	auipc	s3,0x5
    80002d14:	d709a983          	lw	s3,-656(s3) # 80007a80 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002d18:	00005917          	auipc	s2,0x5
    80002d1c:	d6890913          	addi	s2,s2,-664 # 80007a80 <ticks>
    release(&tickslock);
    80002d20:	00013497          	auipc	s1,0x13
    80002d24:	eb048493          	addi	s1,s1,-336 # 80015bd0 <tickslock>
    if (killed(myproc())) {
    80002d28:	c01fe0ef          	jal	80001928 <myproc>
    80002d2c:	c5eff0ef          	jal	8000218a <killed>
    80002d30:	e529                	bnez	a0,80002d7a <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002d32:	854a                	mv	a0,s2
    80002d34:	9fcff0ef          	jal	80001f30 <sleep_prepare>
    release(&tickslock);
    80002d38:	8526                	mv	a0,s1
    80002d3a:	f89fd0ef          	jal	80000cc2 <release>
    sleep();
    80002d3e:	a2eff0ef          	jal	80001f6c <sleep>
    acquire(&tickslock);
    80002d42:	8526                	mv	a0,s1
    80002d44:	efbfd0ef          	jal	80000c3e <acquire>
  while (ticks - ticks0 < n) {
    80002d48:	00092783          	lw	a5,0(s2)
    80002d4c:	413787bb          	subw	a5,a5,s3
    80002d50:	fcc42703          	lw	a4,-52(s0)
    80002d54:	fce7eae3          	bltu	a5,a4,80002d28 <sys_pause+0x4a>
    80002d58:	74a2                	ld	s1,40(sp)
    80002d5a:	7902                	ld	s2,32(sp)
    80002d5c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d5e:	00013517          	auipc	a0,0x13
    80002d62:	e7250513          	addi	a0,a0,-398 # 80015bd0 <tickslock>
    80002d66:	f5dfd0ef          	jal	80000cc2 <release>
  return 0;
    80002d6a:	4501                	li	a0,0
}
    80002d6c:	70e2                	ld	ra,56(sp)
    80002d6e:	7442                	ld	s0,48(sp)
    80002d70:	6121                	addi	sp,sp,64
    80002d72:	8082                	ret
    n = 0;
    80002d74:	fc042623          	sw	zero,-52(s0)
    80002d78:	b741                	j	80002cf8 <sys_pause+0x1a>
      release(&tickslock);
    80002d7a:	00013517          	auipc	a0,0x13
    80002d7e:	e5650513          	addi	a0,a0,-426 # 80015bd0 <tickslock>
    80002d82:	f41fd0ef          	jal	80000cc2 <release>
      return -1;
    80002d86:	557d                	li	a0,-1
    80002d88:	74a2                	ld	s1,40(sp)
    80002d8a:	7902                	ld	s2,32(sp)
    80002d8c:	69e2                	ld	s3,24(sp)
    80002d8e:	bff9                	j	80002d6c <sys_pause+0x8e>

0000000080002d90 <sys_kill>:

uint64
sys_kill(void)
{
    80002d90:	1101                	addi	sp,sp,-32
    80002d92:	ec06                	sd	ra,24(sp)
    80002d94:	e822                	sd	s0,16(sp)
    80002d96:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002d98:	fec40593          	addi	a1,s0,-20
    80002d9c:	4501                	li	a0,0
    80002d9e:	c21ff0ef          	jal	800029be <argint>
  return kkill(pid);
    80002da2:	fec42503          	lw	a0,-20(s0)
    80002da6:	b58ff0ef          	jal	800020fe <kkill>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	6105                	addi	sp,sp,32
    80002db0:	8082                	ret

0000000080002db2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002db2:	1101                	addi	sp,sp,-32
    80002db4:	ec06                	sd	ra,24(sp)
    80002db6:	e822                	sd	s0,16(sp)
    80002db8:	e426                	sd	s1,8(sp)
    80002dba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dbc:	00013517          	auipc	a0,0x13
    80002dc0:	e1450513          	addi	a0,a0,-492 # 80015bd0 <tickslock>
    80002dc4:	e7bfd0ef          	jal	80000c3e <acquire>
  xticks = ticks;
    80002dc8:	00005797          	auipc	a5,0x5
    80002dcc:	cb87a783          	lw	a5,-840(a5) # 80007a80 <ticks>
    80002dd0:	84be                	mv	s1,a5
  release(&tickslock);
    80002dd2:	00013517          	auipc	a0,0x13
    80002dd6:	dfe50513          	addi	a0,a0,-514 # 80015bd0 <tickslock>
    80002dda:	ee9fd0ef          	jal	80000cc2 <release>
  return xticks;
}
    80002dde:	02049513          	slli	a0,s1,0x20
    80002de2:	9101                	srli	a0,a0,0x20
    80002de4:	60e2                	ld	ra,24(sp)
    80002de6:	6442                	ld	s0,16(sp)
    80002de8:	64a2                	ld	s1,8(sp)
    80002dea:	6105                	addi	sp,sp,32
    80002dec:	8082                	ret

0000000080002dee <sys_trace>:

uint64
sys_trace(void)
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80002df6:	fec40593          	addi	a1,s0,-20
    80002dfa:	4501                	li	a0,0
    80002dfc:	bc3ff0ef          	jal	800029be <argint>
  myproc()->tracemask = mask;
    80002e00:	b29fe0ef          	jal	80001928 <myproc>
    80002e04:	fec42783          	lw	a5,-20(s0)
    80002e08:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002e0c:	4501                	li	a0,0
    80002e0e:	60e2                	ld	ra,24(sp)
    80002e10:	6442                	ld	s0,16(sp)
    80002e12:	6105                	addi	sp,sp,32
    80002e14:	8082                	ret

0000000080002e16 <sys_sysinfo>:


uint64
sys_sysinfo(void)
{
    80002e16:	7139                	addi	sp,sp,-64
    80002e18:	fc06                	sd	ra,56(sp)
    80002e1a:	f822                	sd	s0,48(sp)
    80002e1c:	f426                	sd	s1,40(sp)
    80002e1e:	0080                	addi	s0,sp,64
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();
    80002e20:	b09fe0ef          	jal	80001928 <myproc>
    80002e24:	84aa                	mv	s1,a0

  argaddr(0, &addr);
    80002e26:	fd840593          	addi	a1,s0,-40
    80002e2a:	4501                	li	a0,0
    80002e2c:	bafff0ef          	jal	800029da <argaddr>

  info.freemem = freemem();
    80002e30:	d49fd0ef          	jal	80000b78 <freemem>
    80002e34:	fca43023          	sd	a0,-64(s0)
  info.nproc = nproc();
    80002e38:	dbcff0ef          	jal	800023f4 <nproc>
    80002e3c:	fca43423          	sd	a0,-56(s0)
  info.nopenfile = nopenfile();
    80002e40:	1c9010ef          	jal	80004808 <nopenfile>
    80002e44:	fca43823          	sd	a0,-48(s0)

  if(copyout(p->pagetable, p->sz, addr, (char *)&info, sizeof(info)) < 0)
    80002e48:	4761                	li	a4,24
    80002e4a:	fc040693          	addi	a3,s0,-64
    80002e4e:	fd843603          	ld	a2,-40(s0)
    80002e52:	64ac                	ld	a1,72(s1)
    80002e54:	68a8                	ld	a0,80(s1)
    80002e56:	f1cfe0ef          	jal	80001572 <copyout>
    return -1;

  return 0;
}
    80002e5a:	957d                	srai	a0,a0,0x3f
    80002e5c:	70e2                	ld	ra,56(sp)
    80002e5e:	7442                	ld	s0,48(sp)
    80002e60:	74a2                	ld	s1,40(sp)
    80002e62:	6121                	addi	sp,sp,64
    80002e64:	8082                	ret

0000000080002e66 <sys_getprocs>:


uint64
sys_getprocs(void)
{
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	1000                	addi	s0,sp,32
  uint64 addr;
  int max;

  argaddr(0, &addr);
    80002e6e:	fe840593          	addi	a1,s0,-24
    80002e72:	4501                	li	a0,0
    80002e74:	b67ff0ef          	jal	800029da <argaddr>
  argint(1, &max);
    80002e78:	fe440593          	addi	a1,s0,-28
    80002e7c:	4505                	li	a0,1
    80002e7e:	b41ff0ef          	jal	800029be <argint>

  return proc_getprocs(addr, max);
    80002e82:	fe442583          	lw	a1,-28(s0)
    80002e86:	fe843503          	ld	a0,-24(s0)
    80002e8a:	db6ff0ef          	jal	80002440 <proc_getprocs>
}
    80002e8e:	60e2                	ld	ra,24(sp)
    80002e90:	6442                	ld	s0,16(sp)
    80002e92:	6105                	addi	sp,sp,32
    80002e94:	8082                	ret

0000000080002e96 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e96:	7179                	addi	sp,sp,-48
    80002e98:	f406                	sd	ra,40(sp)
    80002e9a:	f022                	sd	s0,32(sp)
    80002e9c:	ec26                	sd	s1,24(sp)
    80002e9e:	e84a                	sd	s2,16(sp)
    80002ea0:	e44e                	sd	s3,8(sp)
    80002ea2:	e052                	sd	s4,0(sp)
    80002ea4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ea6:	00004597          	auipc	a1,0x4
    80002eaa:	62a58593          	addi	a1,a1,1578 # 800074d0 <etext+0x4d0>
    80002eae:	00013517          	auipc	a0,0x13
    80002eb2:	d3a50513          	addi	a0,a0,-710 # 80015be8 <bcache>
    80002eb6:	d09fd0ef          	jal	80000bbe <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002eba:	0001b797          	auipc	a5,0x1b
    80002ebe:	d2e78793          	addi	a5,a5,-722 # 8001dbe8 <bcache+0x8000>
    80002ec2:	0001b717          	auipc	a4,0x1b
    80002ec6:	f8e70713          	addi	a4,a4,-114 # 8001de50 <bcache+0x8268>
    80002eca:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ece:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002ed2:	00013497          	auipc	s1,0x13
    80002ed6:	d2e48493          	addi	s1,s1,-722 # 80015c00 <bcache+0x18>
    b->next = bcache.head.next;
    80002eda:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002edc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ede:	00004a17          	auipc	s4,0x4
    80002ee2:	5faa0a13          	addi	s4,s4,1530 # 800074d8 <etext+0x4d8>
    b->next = bcache.head.next;
    80002ee6:	2b893783          	ld	a5,696(s2)
    80002eea:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002eec:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ef0:	85d2                	mv	a1,s4
    80002ef2:	01048513          	addi	a0,s1,16
    80002ef6:	41a010ef          	jal	80004310 <initsleeplock>
    bcache.head.next->prev = b;
    80002efa:	2b893783          	ld	a5,696(s2)
    80002efe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f00:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002f04:	45848493          	addi	s1,s1,1112
    80002f08:	fd349fe3          	bne	s1,s3,80002ee6 <binit+0x50>
  }
}
    80002f0c:	70a2                	ld	ra,40(sp)
    80002f0e:	7402                	ld	s0,32(sp)
    80002f10:	64e2                	ld	s1,24(sp)
    80002f12:	6942                	ld	s2,16(sp)
    80002f14:	69a2                	ld	s3,8(sp)
    80002f16:	6a02                	ld	s4,0(sp)
    80002f18:	6145                	addi	sp,sp,48
    80002f1a:	8082                	ret

0000000080002f1c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002f1c:	7179                	addi	sp,sp,-48
    80002f1e:	f406                	sd	ra,40(sp)
    80002f20:	f022                	sd	s0,32(sp)
    80002f22:	ec26                	sd	s1,24(sp)
    80002f24:	e84a                	sd	s2,16(sp)
    80002f26:	e44e                	sd	s3,8(sp)
    80002f28:	1800                	addi	s0,sp,48
    80002f2a:	892a                	mv	s2,a0
    80002f2c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f2e:	00013517          	auipc	a0,0x13
    80002f32:	cba50513          	addi	a0,a0,-838 # 80015be8 <bcache>
    80002f36:	d09fd0ef          	jal	80000c3e <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002f3a:	0001b497          	auipc	s1,0x1b
    80002f3e:	f664b483          	ld	s1,-154(s1) # 8001dea0 <bcache+0x82b8>
    80002f42:	0001b797          	auipc	a5,0x1b
    80002f46:	f0e78793          	addi	a5,a5,-242 # 8001de50 <bcache+0x8268>
    80002f4a:	02f48b63          	beq	s1,a5,80002f80 <bread+0x64>
    80002f4e:	873e                	mv	a4,a5
    80002f50:	a021                	j	80002f58 <bread+0x3c>
    80002f52:	68a4                	ld	s1,80(s1)
    80002f54:	02e48663          	beq	s1,a4,80002f80 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002f58:	449c                	lw	a5,8(s1)
    80002f5a:	ff279ce3          	bne	a5,s2,80002f52 <bread+0x36>
    80002f5e:	44dc                	lw	a5,12(s1)
    80002f60:	ff3799e3          	bne	a5,s3,80002f52 <bread+0x36>
      b->refcnt++;
    80002f64:	40bc                	lw	a5,64(s1)
    80002f66:	2785                	addiw	a5,a5,1
    80002f68:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f6a:	00013517          	auipc	a0,0x13
    80002f6e:	c7e50513          	addi	a0,a0,-898 # 80015be8 <bcache>
    80002f72:	d51fd0ef          	jal	80000cc2 <release>
      acquiresleep(&b->lock);
    80002f76:	01048513          	addi	a0,s1,16
    80002f7a:	3cc010ef          	jal	80004346 <acquiresleep>
      return b;
    80002f7e:	a889                	j	80002fd0 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002f80:	0001b497          	auipc	s1,0x1b
    80002f84:	f184b483          	ld	s1,-232(s1) # 8001de98 <bcache+0x82b0>
    80002f88:	0001b797          	auipc	a5,0x1b
    80002f8c:	ec878793          	addi	a5,a5,-312 # 8001de50 <bcache+0x8268>
    80002f90:	00f48863          	beq	s1,a5,80002fa0 <bread+0x84>
    80002f94:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002f96:	40bc                	lw	a5,64(s1)
    80002f98:	cb91                	beqz	a5,80002fac <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002f9a:	64a4                	ld	s1,72(s1)
    80002f9c:	fee49de3          	bne	s1,a4,80002f96 <bread+0x7a>
  panic("bget: no buffers");
    80002fa0:	00004517          	auipc	a0,0x4
    80002fa4:	54050513          	addi	a0,a0,1344 # 800074e0 <etext+0x4e0>
    80002fa8:	8a1fd0ef          	jal	80000848 <panic>
      b->dev = dev;
    80002fac:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fb0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fb4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fb8:	4785                	li	a5,1
    80002fba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fbc:	00013517          	auipc	a0,0x13
    80002fc0:	c2c50513          	addi	a0,a0,-980 # 80015be8 <bcache>
    80002fc4:	cfffd0ef          	jal	80000cc2 <release>
      acquiresleep(&b->lock);
    80002fc8:	01048513          	addi	a0,s1,16
    80002fcc:	37a010ef          	jal	80004346 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002fd0:	409c                	lw	a5,0(s1)
    80002fd2:	cb89                	beqz	a5,80002fe4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fd4:	8526                	mv	a0,s1
    80002fd6:	70a2                	ld	ra,40(sp)
    80002fd8:	7402                	ld	s0,32(sp)
    80002fda:	64e2                	ld	s1,24(sp)
    80002fdc:	6942                	ld	s2,16(sp)
    80002fde:	69a2                	ld	s3,8(sp)
    80002fe0:	6145                	addi	sp,sp,48
    80002fe2:	8082                	ret
    virtio_disk_rw(b, 0);
    80002fe4:	4581                	li	a1,0
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	44b020ef          	jal	80005c32 <virtio_disk_rw>
    b->valid = 1;
    80002fec:	4785                	li	a5,1
    80002fee:	c09c                	sw	a5,0(s1)
  return b;
    80002ff0:	b7d5                	j	80002fd4 <bread+0xb8>

0000000080002ff2 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002ff2:	1101                	addi	sp,sp,-32
    80002ff4:	ec06                	sd	ra,24(sp)
    80002ff6:	e822                	sd	s0,16(sp)
    80002ff8:	e426                	sd	s1,8(sp)
    80002ffa:	1000                	addi	s0,sp,32
    80002ffc:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002ffe:	0541                	addi	a0,a0,16
    80003000:	3d2010ef          	jal	800043d2 <holdingsleep>
    80003004:	c911                	beqz	a0,80003018 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003006:	4585                	li	a1,1
    80003008:	8526                	mv	a0,s1
    8000300a:	429020ef          	jal	80005c32 <virtio_disk_rw>
}
    8000300e:	60e2                	ld	ra,24(sp)
    80003010:	6442                	ld	s0,16(sp)
    80003012:	64a2                	ld	s1,8(sp)
    80003014:	6105                	addi	sp,sp,32
    80003016:	8082                	ret
    panic("bwrite");
    80003018:	00004517          	auipc	a0,0x4
    8000301c:	4e050513          	addi	a0,a0,1248 # 800074f8 <etext+0x4f8>
    80003020:	829fd0ef          	jal	80000848 <panic>

0000000080003024 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	e04a                	sd	s2,0(sp)
    8000302e:	1000                	addi	s0,sp,32
    80003030:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80003032:	01050913          	addi	s2,a0,16
    80003036:	854a                	mv	a0,s2
    80003038:	39a010ef          	jal	800043d2 <holdingsleep>
    8000303c:	c125                	beqz	a0,8000309c <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000303e:	854a                	mv	a0,s2
    80003040:	35a010ef          	jal	8000439a <releasesleep>

  acquire(&bcache.lock);
    80003044:	00013517          	auipc	a0,0x13
    80003048:	ba450513          	addi	a0,a0,-1116 # 80015be8 <bcache>
    8000304c:	bf3fd0ef          	jal	80000c3e <acquire>
  b->refcnt--;
    80003050:	40bc                	lw	a5,64(s1)
    80003052:	37fd                	addiw	a5,a5,-1
    80003054:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003056:	e79d                	bnez	a5,80003084 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003058:	68b8                	ld	a4,80(s1)
    8000305a:	64bc                	ld	a5,72(s1)
    8000305c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000305e:	68b8                	ld	a4,80(s1)
    80003060:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003062:	0001b797          	auipc	a5,0x1b
    80003066:	b8678793          	addi	a5,a5,-1146 # 8001dbe8 <bcache+0x8000>
    8000306a:	2b87b703          	ld	a4,696(a5)
    8000306e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003070:	0001b717          	auipc	a4,0x1b
    80003074:	de070713          	addi	a4,a4,-544 # 8001de50 <bcache+0x8268>
    80003078:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000307a:	2b87b703          	ld	a4,696(a5)
    8000307e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003080:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80003084:	00013517          	auipc	a0,0x13
    80003088:	b6450513          	addi	a0,a0,-1180 # 80015be8 <bcache>
    8000308c:	c37fd0ef          	jal	80000cc2 <release>
}
    80003090:	60e2                	ld	ra,24(sp)
    80003092:	6442                	ld	s0,16(sp)
    80003094:	64a2                	ld	s1,8(sp)
    80003096:	6902                	ld	s2,0(sp)
    80003098:	6105                	addi	sp,sp,32
    8000309a:	8082                	ret
    panic("brelse");
    8000309c:	00004517          	auipc	a0,0x4
    800030a0:	46450513          	addi	a0,a0,1124 # 80007500 <etext+0x500>
    800030a4:	fa4fd0ef          	jal	80000848 <panic>

00000000800030a8 <bpin>:

void
bpin(struct buf *b)
{
    800030a8:	1101                	addi	sp,sp,-32
    800030aa:	ec06                	sd	ra,24(sp)
    800030ac:	e822                	sd	s0,16(sp)
    800030ae:	e426                	sd	s1,8(sp)
    800030b0:	1000                	addi	s0,sp,32
    800030b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030b4:	00013517          	auipc	a0,0x13
    800030b8:	b3450513          	addi	a0,a0,-1228 # 80015be8 <bcache>
    800030bc:	b83fd0ef          	jal	80000c3e <acquire>
  b->refcnt++;
    800030c0:	40bc                	lw	a5,64(s1)
    800030c2:	2785                	addiw	a5,a5,1
    800030c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030c6:	00013517          	auipc	a0,0x13
    800030ca:	b2250513          	addi	a0,a0,-1246 # 80015be8 <bcache>
    800030ce:	bf5fd0ef          	jal	80000cc2 <release>
}
    800030d2:	60e2                	ld	ra,24(sp)
    800030d4:	6442                	ld	s0,16(sp)
    800030d6:	64a2                	ld	s1,8(sp)
    800030d8:	6105                	addi	sp,sp,32
    800030da:	8082                	ret

00000000800030dc <bunpin>:

void
bunpin(struct buf *b)
{
    800030dc:	1101                	addi	sp,sp,-32
    800030de:	ec06                	sd	ra,24(sp)
    800030e0:	e822                	sd	s0,16(sp)
    800030e2:	e426                	sd	s1,8(sp)
    800030e4:	1000                	addi	s0,sp,32
    800030e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030e8:	00013517          	auipc	a0,0x13
    800030ec:	b0050513          	addi	a0,a0,-1280 # 80015be8 <bcache>
    800030f0:	b4ffd0ef          	jal	80000c3e <acquire>
  b->refcnt--;
    800030f4:	40bc                	lw	a5,64(s1)
    800030f6:	37fd                	addiw	a5,a5,-1
    800030f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030fa:	00013517          	auipc	a0,0x13
    800030fe:	aee50513          	addi	a0,a0,-1298 # 80015be8 <bcache>
    80003102:	bc1fd0ef          	jal	80000cc2 <release>
}
    80003106:	60e2                	ld	ra,24(sp)
    80003108:	6442                	ld	s0,16(sp)
    8000310a:	64a2                	ld	s1,8(sp)
    8000310c:	6105                	addi	sp,sp,32
    8000310e:	8082                	ret

0000000080003110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003110:	1101                	addi	sp,sp,-32
    80003112:	ec06                	sd	ra,24(sp)
    80003114:	e822                	sd	s0,16(sp)
    80003116:	e426                	sd	s1,8(sp)
    80003118:	e04a                	sd	s2,0(sp)
    8000311a:	1000                	addi	s0,sp,32
    8000311c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000311e:	00d5d79b          	srliw	a5,a1,0xd
    80003122:	0001b597          	auipc	a1,0x1b
    80003126:	1a25a583          	lw	a1,418(a1) # 8001e2c4 <sb+0x1c>
    8000312a:	9dbd                	addw	a1,a1,a5
    8000312c:	df1ff0ef          	jal	80002f1c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003130:	0074f713          	andi	a4,s1,7
    80003134:	4785                	li	a5,1
    80003136:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000313a:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    8000313c:	90d9                	srli	s1,s1,0x36
    8000313e:	00950733          	add	a4,a0,s1
    80003142:	05874703          	lbu	a4,88(a4)
    80003146:	00e7f6b3          	and	a3,a5,a4
    8000314a:	c29d                	beqz	a3,80003170 <bfree+0x60>
    8000314c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    8000314e:	94aa                	add	s1,s1,a0
    80003150:	fff7c793          	not	a5,a5
    80003154:	8f7d                	and	a4,a4,a5
    80003156:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000315a:	082010ef          	jal	800041dc <log_write>
  brelse(bp);
    8000315e:	854a                	mv	a0,s2
    80003160:	ec5ff0ef          	jal	80003024 <brelse>
}
    80003164:	60e2                	ld	ra,24(sp)
    80003166:	6442                	ld	s0,16(sp)
    80003168:	64a2                	ld	s1,8(sp)
    8000316a:	6902                	ld	s2,0(sp)
    8000316c:	6105                	addi	sp,sp,32
    8000316e:	8082                	ret
    panic("freeing free block");
    80003170:	00004517          	auipc	a0,0x4
    80003174:	39850513          	addi	a0,a0,920 # 80007508 <etext+0x508>
    80003178:	ed0fd0ef          	jal	80000848 <panic>

000000008000317c <balloc>:
{
    8000317c:	715d                	addi	sp,sp,-80
    8000317e:	e486                	sd	ra,72(sp)
    80003180:	e0a2                	sd	s0,64(sp)
    80003182:	fc26                	sd	s1,56(sp)
    80003184:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80003186:	0001b797          	auipc	a5,0x1b
    8000318a:	1267a783          	lw	a5,294(a5) # 8001e2ac <sb+0x4>
    8000318e:	0e078263          	beqz	a5,80003272 <balloc+0xf6>
    80003192:	f84a                	sd	s2,48(sp)
    80003194:	f44e                	sd	s3,40(sp)
    80003196:	f052                	sd	s4,32(sp)
    80003198:	ec56                	sd	s5,24(sp)
    8000319a:	e85a                	sd	s6,16(sp)
    8000319c:	e45e                	sd	s7,8(sp)
    8000319e:	e062                	sd	s8,0(sp)
    800031a0:	8baa                	mv	s7,a0
    800031a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031a4:	0001bb17          	auipc	s6,0x1b
    800031a8:	104b0b13          	addi	s6,s6,260 # 8001e2a8 <sb>
      m = 1 << (bi % 8);
    800031ac:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800031ae:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800031b0:	6c09                	lui	s8,0x2
    800031b2:	a09d                	j	80003218 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    800031b4:	97ca                	add	a5,a5,s2
    800031b6:	8e55                	or	a2,a2,a3
    800031b8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800031bc:	854a                	mv	a0,s2
    800031be:	01e010ef          	jal	800041dc <log_write>
        brelse(bp);
    800031c2:	854a                	mv	a0,s2
    800031c4:	e61ff0ef          	jal	80003024 <brelse>
  bp = bread(dev, bno);
    800031c8:	85a6                	mv	a1,s1
    800031ca:	855e                	mv	a0,s7
    800031cc:	d51ff0ef          	jal	80002f1c <bread>
    800031d0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031d2:	40000613          	li	a2,1024
    800031d6:	4581                	li	a1,0
    800031d8:	05850513          	addi	a0,a0,88
    800031dc:	b1ffd0ef          	jal	80000cfa <memset>
  log_write(bp);
    800031e0:	854a                	mv	a0,s2
    800031e2:	7fb000ef          	jal	800041dc <log_write>
  brelse(bp);
    800031e6:	854a                	mv	a0,s2
    800031e8:	e3dff0ef          	jal	80003024 <brelse>
        return b + bi;
    800031ec:	7942                	ld	s2,48(sp)
    800031ee:	79a2                	ld	s3,40(sp)
    800031f0:	7a02                	ld	s4,32(sp)
    800031f2:	6ae2                	ld	s5,24(sp)
    800031f4:	6b42                	ld	s6,16(sp)
    800031f6:	6ba2                	ld	s7,8(sp)
    800031f8:	6c02                	ld	s8,0(sp)
}
    800031fa:	8526                	mv	a0,s1
    800031fc:	60a6                	ld	ra,72(sp)
    800031fe:	6406                	ld	s0,64(sp)
    80003200:	74e2                	ld	s1,56(sp)
    80003202:	6161                	addi	sp,sp,80
    80003204:	8082                	ret
    brelse(bp);
    80003206:	854a                	mv	a0,s2
    80003208:	e1dff0ef          	jal	80003024 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    8000320c:	015c0abb          	addw	s5,s8,s5
    80003210:	004b2783          	lw	a5,4(s6)
    80003214:	04faf863          	bgeu	s5,a5,80003264 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003218:	40dad59b          	sraiw	a1,s5,0xd
    8000321c:	01cb2783          	lw	a5,28(s6)
    80003220:	9dbd                	addw	a1,a1,a5
    80003222:	855e                	mv	a0,s7
    80003224:	cf9ff0ef          	jal	80002f1c <bread>
    80003228:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000322a:	004b2503          	lw	a0,4(s6)
    8000322e:	84d6                	mv	s1,s5
    80003230:	4701                	li	a4,0
    80003232:	fca4fae3          	bgeu	s1,a0,80003206 <balloc+0x8a>
      m = 1 << (bi % 8);
    80003236:	00777693          	andi	a3,a4,7
    8000323a:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    8000323e:	41f7579b          	sraiw	a5,a4,0x1f
    80003242:	01d7d79b          	srliw	a5,a5,0x1d
    80003246:	9fb9                	addw	a5,a5,a4
    80003248:	4037d79b          	sraiw	a5,a5,0x3
    8000324c:	00f90633          	add	a2,s2,a5
    80003250:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003254:	00c6f5b3          	and	a1,a3,a2
    80003258:	ddb1                	beqz	a1,800031b4 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000325a:	2705                	addiw	a4,a4,1
    8000325c:	2485                	addiw	s1,s1,1
    8000325e:	fd471ae3          	bne	a4,s4,80003232 <balloc+0xb6>
    80003262:	b755                	j	80003206 <balloc+0x8a>
    80003264:	7942                	ld	s2,48(sp)
    80003266:	79a2                	ld	s3,40(sp)
    80003268:	7a02                	ld	s4,32(sp)
    8000326a:	6ae2                	ld	s5,24(sp)
    8000326c:	6b42                	ld	s6,16(sp)
    8000326e:	6ba2                	ld	s7,8(sp)
    80003270:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80003272:	00004517          	auipc	a0,0x4
    80003276:	2ae50513          	addi	a0,a0,686 # 80007520 <etext+0x520>
    8000327a:	a96fd0ef          	jal	80000510 <printk>
  return 0;
    8000327e:	4481                	li	s1,0
    80003280:	bfad                	j	800031fa <balloc+0x7e>

0000000080003282 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003282:	7179                	addi	sp,sp,-48
    80003284:	f406                	sd	ra,40(sp)
    80003286:	f022                	sd	s0,32(sp)
    80003288:	ec26                	sd	s1,24(sp)
    8000328a:	e84a                	sd	s2,16(sp)
    8000328c:	e44e                	sd	s3,8(sp)
    8000328e:	1800                	addi	s0,sp,48
    80003290:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003292:	47ad                	li	a5,11
    80003294:	02b7e363          	bltu	a5,a1,800032ba <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80003298:	02059793          	slli	a5,a1,0x20
    8000329c:	01e7d593          	srli	a1,a5,0x1e
    800032a0:	00b509b3          	add	s3,a0,a1
    800032a4:	0509a483          	lw	s1,80(s3)
    800032a8:	e0b5                	bnez	s1,8000330c <bmap+0x8a>
      addr = balloc(ip->dev);
    800032aa:	4108                	lw	a0,0(a0)
    800032ac:	ed1ff0ef          	jal	8000317c <balloc>
    800032b0:	84aa                	mv	s1,a0
      if (addr == 0)
    800032b2:	cd29                	beqz	a0,8000330c <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800032b4:	04a9a823          	sw	a0,80(s3)
    800032b8:	a891                	j	8000330c <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800032ba:	ff45879b          	addiw	a5,a1,-12
    800032be:	873e                	mv	a4,a5
    800032c0:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    800032c2:	0ff00793          	li	a5,255
    800032c6:	06e7e763          	bltu	a5,a4,80003334 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    800032ca:	08052483          	lw	s1,128(a0)
    800032ce:	e891                	bnez	s1,800032e2 <bmap+0x60>
      addr = balloc(ip->dev);
    800032d0:	4108                	lw	a0,0(a0)
    800032d2:	eabff0ef          	jal	8000317c <balloc>
    800032d6:	84aa                	mv	s1,a0
      if (addr == 0)
    800032d8:	c915                	beqz	a0,8000330c <bmap+0x8a>
    800032da:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800032dc:	08a92023          	sw	a0,128(s2)
    800032e0:	a011                	j	800032e4 <bmap+0x62>
    800032e2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800032e4:	85a6                	mv	a1,s1
    800032e6:	00092503          	lw	a0,0(s2)
    800032ea:	c33ff0ef          	jal	80002f1c <bread>
    800032ee:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800032f0:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800032f4:	02099713          	slli	a4,s3,0x20
    800032f8:	01e75593          	srli	a1,a4,0x1e
    800032fc:	97ae                	add	a5,a5,a1
    800032fe:	89be                	mv	s3,a5
    80003300:	4384                	lw	s1,0(a5)
    80003302:	cc89                	beqz	s1,8000331c <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003304:	8552                	mv	a0,s4
    80003306:	d1fff0ef          	jal	80003024 <brelse>
    return addr;
    8000330a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000330c:	8526                	mv	a0,s1
    8000330e:	70a2                	ld	ra,40(sp)
    80003310:	7402                	ld	s0,32(sp)
    80003312:	64e2                	ld	s1,24(sp)
    80003314:	6942                	ld	s2,16(sp)
    80003316:	69a2                	ld	s3,8(sp)
    80003318:	6145                	addi	sp,sp,48
    8000331a:	8082                	ret
      addr = balloc(ip->dev);
    8000331c:	00092503          	lw	a0,0(s2)
    80003320:	e5dff0ef          	jal	8000317c <balloc>
    80003324:	84aa                	mv	s1,a0
      if (addr) {
    80003326:	dd79                	beqz	a0,80003304 <bmap+0x82>
        a[bn] = addr;
    80003328:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000332c:	8552                	mv	a0,s4
    8000332e:	6af000ef          	jal	800041dc <log_write>
    80003332:	bfc9                	j	80003304 <bmap+0x82>
    80003334:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003336:	00004517          	auipc	a0,0x4
    8000333a:	20250513          	addi	a0,a0,514 # 80007538 <etext+0x538>
    8000333e:	d0afd0ef          	jal	80000848 <panic>

0000000080003342 <iget>:
{
    80003342:	7179                	addi	sp,sp,-48
    80003344:	f406                	sd	ra,40(sp)
    80003346:	f022                	sd	s0,32(sp)
    80003348:	ec26                	sd	s1,24(sp)
    8000334a:	e84a                	sd	s2,16(sp)
    8000334c:	e44e                	sd	s3,8(sp)
    8000334e:	e052                	sd	s4,0(sp)
    80003350:	1800                	addi	s0,sp,48
    80003352:	89aa                	mv	s3,a0
    80003354:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003356:	0001b517          	auipc	a0,0x1b
    8000335a:	f7250513          	addi	a0,a0,-142 # 8001e2c8 <itable>
    8000335e:	8e1fd0ef          	jal	80000c3e <acquire>
  empty = 0;
    80003362:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003364:	0001b497          	auipc	s1,0x1b
    80003368:	f7c48493          	addi	s1,s1,-132 # 8001e2e0 <itable+0x18>
    8000336c:	0001d697          	auipc	a3,0x1d
    80003370:	a0468693          	addi	a3,a3,-1532 # 8001fd70 <log>
    80003374:	a819                	j	8000338a <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003376:	0017b793          	seqz	a5,a5
    8000337a:	00193713          	seqz	a4,s2
    8000337e:	8ff9                	and	a5,a5,a4
    80003380:	eb85                	bnez	a5,800033b0 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003382:	08848493          	addi	s1,s1,136
    80003386:	02d48763          	beq	s1,a3,800033b4 <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000338a:	449c                	lw	a5,8(s1)
    8000338c:	fef055e3          	blez	a5,80003376 <iget+0x34>
    80003390:	4098                	lw	a4,0(s1)
    80003392:	ff3718e3          	bne	a4,s3,80003382 <iget+0x40>
    80003396:	40d8                	lw	a4,4(s1)
    80003398:	ff4715e3          	bne	a4,s4,80003382 <iget+0x40>
      ip->ref++;
    8000339c:	2785                	addiw	a5,a5,1
    8000339e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800033a0:	0001b517          	auipc	a0,0x1b
    800033a4:	f2850513          	addi	a0,a0,-216 # 8001e2c8 <itable>
    800033a8:	91bfd0ef          	jal	80000cc2 <release>
      return ip;
    800033ac:	8926                	mv	s2,s1
    800033ae:	a025                	j	800033d6 <iget+0x94>
      empty = ip;
    800033b0:	8926                	mv	s2,s1
    800033b2:	bfc1                	j	80003382 <iget+0x40>
  if (empty == 0)
    800033b4:	02090a63          	beqz	s2,800033e8 <iget+0xa6>
  ip->dev = dev;
    800033b8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800033bc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800033c0:	4785                	li	a5,1
    800033c2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800033c6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800033ca:	0001b517          	auipc	a0,0x1b
    800033ce:	efe50513          	addi	a0,a0,-258 # 8001e2c8 <itable>
    800033d2:	8f1fd0ef          	jal	80000cc2 <release>
}
    800033d6:	854a                	mv	a0,s2
    800033d8:	70a2                	ld	ra,40(sp)
    800033da:	7402                	ld	s0,32(sp)
    800033dc:	64e2                	ld	s1,24(sp)
    800033de:	6942                	ld	s2,16(sp)
    800033e0:	69a2                	ld	s3,8(sp)
    800033e2:	6a02                	ld	s4,0(sp)
    800033e4:	6145                	addi	sp,sp,48
    800033e6:	8082                	ret
    panic("iget: no inodes");
    800033e8:	00004517          	auipc	a0,0x4
    800033ec:	16850513          	addi	a0,a0,360 # 80007550 <etext+0x550>
    800033f0:	c58fd0ef          	jal	80000848 <panic>

00000000800033f4 <iinit>:
{
    800033f4:	7179                	addi	sp,sp,-48
    800033f6:	f406                	sd	ra,40(sp)
    800033f8:	f022                	sd	s0,32(sp)
    800033fa:	ec26                	sd	s1,24(sp)
    800033fc:	e84a                	sd	s2,16(sp)
    800033fe:	e44e                	sd	s3,8(sp)
    80003400:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003402:	00004597          	auipc	a1,0x4
    80003406:	15e58593          	addi	a1,a1,350 # 80007560 <etext+0x560>
    8000340a:	0001b517          	auipc	a0,0x1b
    8000340e:	ebe50513          	addi	a0,a0,-322 # 8001e2c8 <itable>
    80003412:	facfd0ef          	jal	80000bbe <initlock>
  for (i = 0; i < NINODE; i++) {
    80003416:	0001b497          	auipc	s1,0x1b
    8000341a:	eda48493          	addi	s1,s1,-294 # 8001e2f0 <itable+0x28>
    8000341e:	0001d997          	auipc	s3,0x1d
    80003422:	96298993          	addi	s3,s3,-1694 # 8001fd80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003426:	00004917          	auipc	s2,0x4
    8000342a:	14290913          	addi	s2,s2,322 # 80007568 <etext+0x568>
    8000342e:	85ca                	mv	a1,s2
    80003430:	8526                	mv	a0,s1
    80003432:	6df000ef          	jal	80004310 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003436:	08848493          	addi	s1,s1,136
    8000343a:	ff349ae3          	bne	s1,s3,8000342e <iinit+0x3a>
}
    8000343e:	70a2                	ld	ra,40(sp)
    80003440:	7402                	ld	s0,32(sp)
    80003442:	64e2                	ld	s1,24(sp)
    80003444:	6942                	ld	s2,16(sp)
    80003446:	69a2                	ld	s3,8(sp)
    80003448:	6145                	addi	sp,sp,48
    8000344a:	8082                	ret

000000008000344c <ialloc>:
{
    8000344c:	7139                	addi	sp,sp,-64
    8000344e:	fc06                	sd	ra,56(sp)
    80003450:	f822                	sd	s0,48(sp)
    80003452:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003454:	0001b717          	auipc	a4,0x1b
    80003458:	e6072703          	lw	a4,-416(a4) # 8001e2b4 <sb+0xc>
    8000345c:	4785                	li	a5,1
    8000345e:	06e7f063          	bgeu	a5,a4,800034be <ialloc+0x72>
    80003462:	f426                	sd	s1,40(sp)
    80003464:	f04a                	sd	s2,32(sp)
    80003466:	ec4e                	sd	s3,24(sp)
    80003468:	e852                	sd	s4,16(sp)
    8000346a:	e456                	sd	s5,8(sp)
    8000346c:	e05a                	sd	s6,0(sp)
    8000346e:	8aaa                	mv	s5,a0
    80003470:	8b2e                	mv	s6,a1
    80003472:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003474:	0001ba17          	auipc	s4,0x1b
    80003478:	e34a0a13          	addi	s4,s4,-460 # 8001e2a8 <sb>
    8000347c:	00495593          	srli	a1,s2,0x4
    80003480:	018a2783          	lw	a5,24(s4)
    80003484:	9dbd                	addw	a1,a1,a5
    80003486:	8556                	mv	a0,s5
    80003488:	a95ff0ef          	jal	80002f1c <bread>
    8000348c:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    8000348e:	05850993          	addi	s3,a0,88
    80003492:	00f97793          	andi	a5,s2,15
    80003496:	079a                	slli	a5,a5,0x6
    80003498:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000349a:	00099783          	lh	a5,0(s3)
    8000349e:	cb9d                	beqz	a5,800034d4 <ialloc+0x88>
    brelse(bp);
    800034a0:	b85ff0ef          	jal	80003024 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    800034a4:	0905                	addi	s2,s2,1
    800034a6:	00ca2703          	lw	a4,12(s4)
    800034aa:	0009079b          	sext.w	a5,s2
    800034ae:	fce7e7e3          	bltu	a5,a4,8000347c <ialloc+0x30>
    800034b2:	74a2                	ld	s1,40(sp)
    800034b4:	7902                	ld	s2,32(sp)
    800034b6:	69e2                	ld	s3,24(sp)
    800034b8:	6a42                	ld	s4,16(sp)
    800034ba:	6aa2                	ld	s5,8(sp)
    800034bc:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    800034be:	00004517          	auipc	a0,0x4
    800034c2:	0b250513          	addi	a0,a0,178 # 80007570 <etext+0x570>
    800034c6:	84afd0ef          	jal	80000510 <printk>
  return 0;
    800034ca:	4501                	li	a0,0
}
    800034cc:	70e2                	ld	ra,56(sp)
    800034ce:	7442                	ld	s0,48(sp)
    800034d0:	6121                	addi	sp,sp,64
    800034d2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800034d4:	04000613          	li	a2,64
    800034d8:	4581                	li	a1,0
    800034da:	854e                	mv	a0,s3
    800034dc:	81ffd0ef          	jal	80000cfa <memset>
      dip->type = type;
    800034e0:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800034e4:	8526                	mv	a0,s1
    800034e6:	4f7000ef          	jal	800041dc <log_write>
      brelse(bp);
    800034ea:	8526                	mv	a0,s1
    800034ec:	b39ff0ef          	jal	80003024 <brelse>
      return iget(dev, inum);
    800034f0:	0009059b          	sext.w	a1,s2
    800034f4:	8556                	mv	a0,s5
    800034f6:	e4dff0ef          	jal	80003342 <iget>
    800034fa:	74a2                	ld	s1,40(sp)
    800034fc:	7902                	ld	s2,32(sp)
    800034fe:	69e2                	ld	s3,24(sp)
    80003500:	6a42                	ld	s4,16(sp)
    80003502:	6aa2                	ld	s5,8(sp)
    80003504:	6b02                	ld	s6,0(sp)
    80003506:	b7d9                	j	800034cc <ialloc+0x80>

0000000080003508 <iupdate>:
{
    80003508:	1101                	addi	sp,sp,-32
    8000350a:	ec06                	sd	ra,24(sp)
    8000350c:	e822                	sd	s0,16(sp)
    8000350e:	e426                	sd	s1,8(sp)
    80003510:	e04a                	sd	s2,0(sp)
    80003512:	1000                	addi	s0,sp,32
    80003514:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003516:	415c                	lw	a5,4(a0)
    80003518:	0047d79b          	srliw	a5,a5,0x4
    8000351c:	0001b597          	auipc	a1,0x1b
    80003520:	da45a583          	lw	a1,-604(a1) # 8001e2c0 <sb+0x18>
    80003524:	9dbd                	addw	a1,a1,a5
    80003526:	4108                	lw	a0,0(a0)
    80003528:	9f5ff0ef          	jal	80002f1c <bread>
    8000352c:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000352e:	05850793          	addi	a5,a0,88
    80003532:	40d8                	lw	a4,4(s1)
    80003534:	8b3d                	andi	a4,a4,15
    80003536:	071a                	slli	a4,a4,0x6
    80003538:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000353a:	04449703          	lh	a4,68(s1)
    8000353e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003542:	04649703          	lh	a4,70(s1)
    80003546:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000354a:	04849703          	lh	a4,72(s1)
    8000354e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003552:	04a49703          	lh	a4,74(s1)
    80003556:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000355a:	44f8                	lw	a4,76(s1)
    8000355c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000355e:	03400613          	li	a2,52
    80003562:	05048593          	addi	a1,s1,80
    80003566:	00c78513          	addi	a0,a5,12
    8000356a:	fecfd0ef          	jal	80000d56 <memmove>
  log_write(bp);
    8000356e:	854a                	mv	a0,s2
    80003570:	46d000ef          	jal	800041dc <log_write>
  brelse(bp);
    80003574:	854a                	mv	a0,s2
    80003576:	aafff0ef          	jal	80003024 <brelse>
}
    8000357a:	60e2                	ld	ra,24(sp)
    8000357c:	6442                	ld	s0,16(sp)
    8000357e:	64a2                	ld	s1,8(sp)
    80003580:	6902                	ld	s2,0(sp)
    80003582:	6105                	addi	sp,sp,32
    80003584:	8082                	ret

0000000080003586 <idup>:
{
    80003586:	1101                	addi	sp,sp,-32
    80003588:	ec06                	sd	ra,24(sp)
    8000358a:	e822                	sd	s0,16(sp)
    8000358c:	e426                	sd	s1,8(sp)
    8000358e:	1000                	addi	s0,sp,32
    80003590:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003592:	0001b517          	auipc	a0,0x1b
    80003596:	d3650513          	addi	a0,a0,-714 # 8001e2c8 <itable>
    8000359a:	ea4fd0ef          	jal	80000c3e <acquire>
  ip->ref++;
    8000359e:	449c                	lw	a5,8(s1)
    800035a0:	2785                	addiw	a5,a5,1
    800035a2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035a4:	0001b517          	auipc	a0,0x1b
    800035a8:	d2450513          	addi	a0,a0,-732 # 8001e2c8 <itable>
    800035ac:	f16fd0ef          	jal	80000cc2 <release>
}
    800035b0:	8526                	mv	a0,s1
    800035b2:	60e2                	ld	ra,24(sp)
    800035b4:	6442                	ld	s0,16(sp)
    800035b6:	64a2                	ld	s1,8(sp)
    800035b8:	6105                	addi	sp,sp,32
    800035ba:	8082                	ret

00000000800035bc <ilock>:
{
    800035bc:	1101                	addi	sp,sp,-32
    800035be:	ec06                	sd	ra,24(sp)
    800035c0:	e822                	sd	s0,16(sp)
    800035c2:	e426                	sd	s1,8(sp)
    800035c4:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    800035c6:	cd19                	beqz	a0,800035e4 <ilock+0x28>
    800035c8:	84aa                	mv	s1,a0
    800035ca:	451c                	lw	a5,8(a0)
    800035cc:	00f05c63          	blez	a5,800035e4 <ilock+0x28>
  acquiresleep(&ip->lock);
    800035d0:	0541                	addi	a0,a0,16
    800035d2:	575000ef          	jal	80004346 <acquiresleep>
  if (ip->valid == 0) {
    800035d6:	40bc                	lw	a5,64(s1)
    800035d8:	cf89                	beqz	a5,800035f2 <ilock+0x36>
}
    800035da:	60e2                	ld	ra,24(sp)
    800035dc:	6442                	ld	s0,16(sp)
    800035de:	64a2                	ld	s1,8(sp)
    800035e0:	6105                	addi	sp,sp,32
    800035e2:	8082                	ret
    800035e4:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800035e6:	00004517          	auipc	a0,0x4
    800035ea:	fa250513          	addi	a0,a0,-94 # 80007588 <etext+0x588>
    800035ee:	a5afd0ef          	jal	80000848 <panic>
    800035f2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800035f4:	40dc                	lw	a5,4(s1)
    800035f6:	0047d79b          	srliw	a5,a5,0x4
    800035fa:	0001b597          	auipc	a1,0x1b
    800035fe:	cc65a583          	lw	a1,-826(a1) # 8001e2c0 <sb+0x18>
    80003602:	9dbd                	addw	a1,a1,a5
    80003604:	4088                	lw	a0,0(s1)
    80003606:	917ff0ef          	jal	80002f1c <bread>
    8000360a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000360c:	05850593          	addi	a1,a0,88
    80003610:	40dc                	lw	a5,4(s1)
    80003612:	8bbd                	andi	a5,a5,15
    80003614:	079a                	slli	a5,a5,0x6
    80003616:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003618:	00059783          	lh	a5,0(a1)
    8000361c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003620:	00259783          	lh	a5,2(a1)
    80003624:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003628:	00459783          	lh	a5,4(a1)
    8000362c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003630:	00659783          	lh	a5,6(a1)
    80003634:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003638:	459c                	lw	a5,8(a1)
    8000363a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000363c:	03400613          	li	a2,52
    80003640:	05b1                	addi	a1,a1,12
    80003642:	05048513          	addi	a0,s1,80
    80003646:	f10fd0ef          	jal	80000d56 <memmove>
    brelse(bp);
    8000364a:	854a                	mv	a0,s2
    8000364c:	9d9ff0ef          	jal	80003024 <brelse>
    ip->valid = 1;
    80003650:	4785                	li	a5,1
    80003652:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003654:	04449783          	lh	a5,68(s1)
    80003658:	c399                	beqz	a5,8000365e <ilock+0xa2>
    8000365a:	6902                	ld	s2,0(sp)
    8000365c:	bfbd                	j	800035da <ilock+0x1e>
      panic("ilock: no type");
    8000365e:	00004517          	auipc	a0,0x4
    80003662:	f3250513          	addi	a0,a0,-206 # 80007590 <etext+0x590>
    80003666:	9e2fd0ef          	jal	80000848 <panic>

000000008000366a <iunlock>:
{
    8000366a:	1101                	addi	sp,sp,-32
    8000366c:	ec06                	sd	ra,24(sp)
    8000366e:	e822                	sd	s0,16(sp)
    80003670:	e426                	sd	s1,8(sp)
    80003672:	e04a                	sd	s2,0(sp)
    80003674:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003676:	c505                	beqz	a0,8000369e <iunlock+0x34>
    80003678:	84aa                	mv	s1,a0
    8000367a:	01050913          	addi	s2,a0,16
    8000367e:	854a                	mv	a0,s2
    80003680:	553000ef          	jal	800043d2 <holdingsleep>
    80003684:	cd09                	beqz	a0,8000369e <iunlock+0x34>
    80003686:	449c                	lw	a5,8(s1)
    80003688:	00f05b63          	blez	a5,8000369e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000368c:	854a                	mv	a0,s2
    8000368e:	50d000ef          	jal	8000439a <releasesleep>
}
    80003692:	60e2                	ld	ra,24(sp)
    80003694:	6442                	ld	s0,16(sp)
    80003696:	64a2                	ld	s1,8(sp)
    80003698:	6902                	ld	s2,0(sp)
    8000369a:	6105                	addi	sp,sp,32
    8000369c:	8082                	ret
    panic("iunlock");
    8000369e:	00004517          	auipc	a0,0x4
    800036a2:	f0250513          	addi	a0,a0,-254 # 800075a0 <etext+0x5a0>
    800036a6:	9a2fd0ef          	jal	80000848 <panic>

00000000800036aa <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800036aa:	7179                	addi	sp,sp,-48
    800036ac:	f406                	sd	ra,40(sp)
    800036ae:	f022                	sd	s0,32(sp)
    800036b0:	ec26                	sd	s1,24(sp)
    800036b2:	e84a                	sd	s2,16(sp)
    800036b4:	e44e                	sd	s3,8(sp)
    800036b6:	1800                	addi	s0,sp,48
    800036b8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    800036ba:	05050493          	addi	s1,a0,80
    800036be:	08050913          	addi	s2,a0,128
    800036c2:	a021                	j	800036ca <itrunc+0x20>
    800036c4:	0491                	addi	s1,s1,4
    800036c6:	01248b63          	beq	s1,s2,800036dc <itrunc+0x32>
    if (ip->addrs[i]) {
    800036ca:	408c                	lw	a1,0(s1)
    800036cc:	dde5                	beqz	a1,800036c4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800036ce:	0009a503          	lw	a0,0(s3)
    800036d2:	a3fff0ef          	jal	80003110 <bfree>
      ip->addrs[i] = 0;
    800036d6:	0004a023          	sw	zero,0(s1)
    800036da:	b7ed                	j	800036c4 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    800036dc:	0809a583          	lw	a1,128(s3)
    800036e0:	ed89                	bnez	a1,800036fa <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800036e2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800036e6:	854e                	mv	a0,s3
    800036e8:	e21ff0ef          	jal	80003508 <iupdate>
}
    800036ec:	70a2                	ld	ra,40(sp)
    800036ee:	7402                	ld	s0,32(sp)
    800036f0:	64e2                	ld	s1,24(sp)
    800036f2:	6942                	ld	s2,16(sp)
    800036f4:	69a2                	ld	s3,8(sp)
    800036f6:	6145                	addi	sp,sp,48
    800036f8:	8082                	ret
    800036fa:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800036fc:	0009a503          	lw	a0,0(s3)
    80003700:	81dff0ef          	jal	80002f1c <bread>
    80003704:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003706:	05850493          	addi	s1,a0,88
    8000370a:	45850913          	addi	s2,a0,1112
    8000370e:	a021                	j	80003716 <itrunc+0x6c>
    80003710:	0491                	addi	s1,s1,4
    80003712:	01248963          	beq	s1,s2,80003724 <itrunc+0x7a>
      if (a[j])
    80003716:	408c                	lw	a1,0(s1)
    80003718:	dde5                	beqz	a1,80003710 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000371a:	0009a503          	lw	a0,0(s3)
    8000371e:	9f3ff0ef          	jal	80003110 <bfree>
    80003722:	b7fd                	j	80003710 <itrunc+0x66>
    brelse(bp);
    80003724:	8552                	mv	a0,s4
    80003726:	8ffff0ef          	jal	80003024 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000372a:	0809a583          	lw	a1,128(s3)
    8000372e:	0009a503          	lw	a0,0(s3)
    80003732:	9dfff0ef          	jal	80003110 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003736:	0809a023          	sw	zero,128(s3)
    8000373a:	6a02                	ld	s4,0(sp)
    8000373c:	b75d                	j	800036e2 <itrunc+0x38>

000000008000373e <iput>:
{
    8000373e:	7179                	addi	sp,sp,-48
    80003740:	f406                	sd	ra,40(sp)
    80003742:	f022                	sd	s0,32(sp)
    80003744:	ec26                	sd	s1,24(sp)
    80003746:	1800                	addi	s0,sp,48
    80003748:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000374a:	0001b517          	auipc	a0,0x1b
    8000374e:	b7e50513          	addi	a0,a0,-1154 # 8001e2c8 <itable>
    80003752:	cecfd0ef          	jal	80000c3e <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003756:	449c                	lw	a5,8(s1)
    80003758:	4705                	li	a4,1
    8000375a:	00e78f63          	beq	a5,a4,80003778 <iput+0x3a>
  ip->ref--;
    8000375e:	37fd                	addiw	a5,a5,-1
    80003760:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003762:	0001b517          	auipc	a0,0x1b
    80003766:	b6650513          	addi	a0,a0,-1178 # 8001e2c8 <itable>
    8000376a:	d58fd0ef          	jal	80000cc2 <release>
}
    8000376e:	70a2                	ld	ra,40(sp)
    80003770:	7402                	ld	s0,32(sp)
    80003772:	64e2                	ld	s1,24(sp)
    80003774:	6145                	addi	sp,sp,48
    80003776:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003778:	40b8                	lw	a4,64(s1)
    8000377a:	d375                	beqz	a4,8000375e <iput+0x20>
    8000377c:	e84a                	sd	s2,16(sp)
    8000377e:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80003780:	0004aa03          	lw	s4,0(s1)
    80003784:	0044a903          	lw	s2,4(s1)
  if (last) {
    80003788:	04a49703          	lh	a4,74(s1)
    8000378c:	ef3d                	bnez	a4,8000380a <iput+0xcc>
    8000378e:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80003790:	01048793          	addi	a5,s1,16
    80003794:	89be                	mv	s3,a5
    80003796:	853e                	mv	a0,a5
    80003798:	3af000ef          	jal	80004346 <acquiresleep>
    release(&itable.lock);
    8000379c:	0001b517          	auipc	a0,0x1b
    800037a0:	b2c50513          	addi	a0,a0,-1236 # 8001e2c8 <itable>
    800037a4:	d1efd0ef          	jal	80000cc2 <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    800037a8:	8526                	mv	a0,s1
    800037aa:	f01ff0ef          	jal	800036aa <itrunc>
    ip->valid = 0;
    800037ae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800037b2:	854e                	mv	a0,s3
    800037b4:	3e7000ef          	jal	8000439a <releasesleep>
    acquire(&itable.lock);
    800037b8:	0001b517          	auipc	a0,0x1b
    800037bc:	b1050513          	addi	a0,a0,-1264 # 8001e2c8 <itable>
    800037c0:	c7efd0ef          	jal	80000c3e <acquire>
  ip->ref--;
    800037c4:	449c                	lw	a5,8(s1)
    800037c6:	37fd                	addiw	a5,a5,-1
    800037c8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037ca:	0001b517          	auipc	a0,0x1b
    800037ce:	afe50513          	addi	a0,a0,-1282 # 8001e2c8 <itable>
    800037d2:	cf0fd0ef          	jal	80000cc2 <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800037d6:	0049579b          	srliw	a5,s2,0x4
    800037da:	0001b597          	auipc	a1,0x1b
    800037de:	ae65a583          	lw	a1,-1306(a1) # 8001e2c0 <sb+0x18>
    800037e2:	9dbd                	addw	a1,a1,a5
    800037e4:	8552                	mv	a0,s4
    800037e6:	f36ff0ef          	jal	80002f1c <bread>
    800037ea:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800037ec:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    800037f0:	079a                	slli	a5,a5,0x6
    800037f2:	97aa                	add	a5,a5,a0
    800037f4:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    800037f8:	1e5000ef          	jal	800041dc <log_write>
  brelse(bp);
    800037fc:	8526                	mv	a0,s1
    800037fe:	827ff0ef          	jal	80003024 <brelse>
}
    80003802:	6942                	ld	s2,16(sp)
    80003804:	69a2                	ld	s3,8(sp)
    80003806:	6a02                	ld	s4,0(sp)
    80003808:	b79d                	j	8000376e <iput+0x30>
    8000380a:	6942                	ld	s2,16(sp)
    8000380c:	6a02                	ld	s4,0(sp)
    8000380e:	bf81                	j	8000375e <iput+0x20>

0000000080003810 <iunlockput>:
{
    80003810:	1101                	addi	sp,sp,-32
    80003812:	ec06                	sd	ra,24(sp)
    80003814:	e822                	sd	s0,16(sp)
    80003816:	e426                	sd	s1,8(sp)
    80003818:	1000                	addi	s0,sp,32
    8000381a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000381c:	e4fff0ef          	jal	8000366a <iunlock>
  iput(ip);
    80003820:	8526                	mv	a0,s1
    80003822:	f1dff0ef          	jal	8000373e <iput>
}
    80003826:	60e2                	ld	ra,24(sp)
    80003828:	6442                	ld	s0,16(sp)
    8000382a:	64a2                	ld	s1,8(sp)
    8000382c:	6105                	addi	sp,sp,32
    8000382e:	8082                	ret

0000000080003830 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003830:	0001b717          	auipc	a4,0x1b
    80003834:	a8472703          	lw	a4,-1404(a4) # 8001e2b4 <sb+0xc>
    80003838:	4785                	li	a5,1
    8000383a:	0ae7fe63          	bgeu	a5,a4,800038f6 <ireclaim+0xc6>
{
    8000383e:	7139                	addi	sp,sp,-64
    80003840:	fc06                	sd	ra,56(sp)
    80003842:	f822                	sd	s0,48(sp)
    80003844:	f426                	sd	s1,40(sp)
    80003846:	f04a                	sd	s2,32(sp)
    80003848:	ec4e                	sd	s3,24(sp)
    8000384a:	e852                	sd	s4,16(sp)
    8000384c:	e456                	sd	s5,8(sp)
    8000384e:	e05a                	sd	s6,0(sp)
    80003850:	0080                	addi	s0,sp,64
    80003852:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003854:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003856:	0001ba17          	auipc	s4,0x1b
    8000385a:	a52a0a13          	addi	s4,s4,-1454 # 8001e2a8 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    8000385e:	00004b17          	auipc	s6,0x4
    80003862:	d4ab0b13          	addi	s6,s6,-694 # 800075a8 <etext+0x5a8>
    80003866:	a099                	j	800038ac <ireclaim+0x7c>
    80003868:	85ce                	mv	a1,s3
    8000386a:	855a                	mv	a0,s6
    8000386c:	ca5fc0ef          	jal	80000510 <printk>
      ip = iget(dev, inum);
    80003870:	85ce                	mv	a1,s3
    80003872:	8556                	mv	a0,s5
    80003874:	acfff0ef          	jal	80003342 <iget>
    80003878:	89aa                	mv	s3,a0
    brelse(bp);
    8000387a:	854a                	mv	a0,s2
    8000387c:	fa8ff0ef          	jal	80003024 <brelse>
    if (ip) {
    80003880:	00098f63          	beqz	s3,8000389e <ireclaim+0x6e>
      begin_op();
    80003884:	7aa000ef          	jal	8000402e <begin_op>
      ilock(ip);
    80003888:	854e                	mv	a0,s3
    8000388a:	d33ff0ef          	jal	800035bc <ilock>
      iunlock(ip);
    8000388e:	854e                	mv	a0,s3
    80003890:	ddbff0ef          	jal	8000366a <iunlock>
      iput(ip);
    80003894:	854e                	mv	a0,s3
    80003896:	ea9ff0ef          	jal	8000373e <iput>
      end_op();
    8000389a:	021000ef          	jal	800040ba <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000389e:	0485                	addi	s1,s1,1
    800038a0:	00ca2703          	lw	a4,12(s4)
    800038a4:	0004879b          	sext.w	a5,s1
    800038a8:	02e7fd63          	bgeu	a5,a4,800038e2 <ireclaim+0xb2>
    800038ac:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800038b0:	0044d593          	srli	a1,s1,0x4
    800038b4:	018a2783          	lw	a5,24(s4)
    800038b8:	9dbd                	addw	a1,a1,a5
    800038ba:	8556                	mv	a0,s5
    800038bc:	e60ff0ef          	jal	80002f1c <bread>
    800038c0:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800038c2:	05850793          	addi	a5,a0,88
    800038c6:	00f9f713          	andi	a4,s3,15
    800038ca:	071a                	slli	a4,a4,0x6
    800038cc:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    800038ce:	00079703          	lh	a4,0(a5)
    800038d2:	c701                	beqz	a4,800038da <ireclaim+0xaa>
    800038d4:	00679783          	lh	a5,6(a5)
    800038d8:	dbc1                	beqz	a5,80003868 <ireclaim+0x38>
    brelse(bp);
    800038da:	854a                	mv	a0,s2
    800038dc:	f48ff0ef          	jal	80003024 <brelse>
    if (ip) {
    800038e0:	bf7d                	j	8000389e <ireclaim+0x6e>
}
    800038e2:	70e2                	ld	ra,56(sp)
    800038e4:	7442                	ld	s0,48(sp)
    800038e6:	74a2                	ld	s1,40(sp)
    800038e8:	7902                	ld	s2,32(sp)
    800038ea:	69e2                	ld	s3,24(sp)
    800038ec:	6a42                	ld	s4,16(sp)
    800038ee:	6aa2                	ld	s5,8(sp)
    800038f0:	6b02                	ld	s6,0(sp)
    800038f2:	6121                	addi	sp,sp,64
    800038f4:	8082                	ret
    800038f6:	8082                	ret

00000000800038f8 <fsinit>:
{
    800038f8:	1101                	addi	sp,sp,-32
    800038fa:	ec06                	sd	ra,24(sp)
    800038fc:	e822                	sd	s0,16(sp)
    800038fe:	e426                	sd	s1,8(sp)
    80003900:	e04a                	sd	s2,0(sp)
    80003902:	1000                	addi	s0,sp,32
    80003904:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003906:	4585                	li	a1,1
    80003908:	e14ff0ef          	jal	80002f1c <bread>
    8000390c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000390e:	02000613          	li	a2,32
    80003912:	05850593          	addi	a1,a0,88
    80003916:	0001b517          	auipc	a0,0x1b
    8000391a:	99250513          	addi	a0,a0,-1646 # 8001e2a8 <sb>
    8000391e:	c38fd0ef          	jal	80000d56 <memmove>
  brelse(bp);
    80003922:	8526                	mv	a0,s1
    80003924:	f00ff0ef          	jal	80003024 <brelse>
  if (sb.magic != FSMAGIC)
    80003928:	0001b717          	auipc	a4,0x1b
    8000392c:	98072703          	lw	a4,-1664(a4) # 8001e2a8 <sb>
    80003930:	102037b7          	lui	a5,0x10203
    80003934:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003938:	02f71263          	bne	a4,a5,8000395c <fsinit+0x64>
  initlog(dev, &sb);
    8000393c:	0001b597          	auipc	a1,0x1b
    80003940:	96c58593          	addi	a1,a1,-1684 # 8001e2a8 <sb>
    80003944:	854a                	mv	a0,s2
    80003946:	666000ef          	jal	80003fac <initlog>
  ireclaim(dev);
    8000394a:	854a                	mv	a0,s2
    8000394c:	ee5ff0ef          	jal	80003830 <ireclaim>
}
    80003950:	60e2                	ld	ra,24(sp)
    80003952:	6442                	ld	s0,16(sp)
    80003954:	64a2                	ld	s1,8(sp)
    80003956:	6902                	ld	s2,0(sp)
    80003958:	6105                	addi	sp,sp,32
    8000395a:	8082                	ret
    panic("invalid file system");
    8000395c:	00004517          	auipc	a0,0x4
    80003960:	c6c50513          	addi	a0,a0,-916 # 800075c8 <etext+0x5c8>
    80003964:	ee5fc0ef          	jal	80000848 <panic>

0000000080003968 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003968:	1141                	addi	sp,sp,-16
    8000396a:	e406                	sd	ra,8(sp)
    8000396c:	e022                	sd	s0,0(sp)
    8000396e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003970:	411c                	lw	a5,0(a0)
    80003972:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003974:	415c                	lw	a5,4(a0)
    80003976:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003978:	04451783          	lh	a5,68(a0)
    8000397c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003980:	04a51783          	lh	a5,74(a0)
    80003984:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003988:	04c56783          	lwu	a5,76(a0)
    8000398c:	e99c                	sd	a5,16(a1)
}
    8000398e:	60a2                	ld	ra,8(sp)
    80003990:	6402                	ld	s0,0(sp)
    80003992:	0141                	addi	sp,sp,16
    80003994:	8082                	ret

0000000080003996 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003996:	457c                	lw	a5,76(a0)
    80003998:	0ed7e663          	bltu	a5,a3,80003a84 <readi+0xee>
{
    8000399c:	7159                	addi	sp,sp,-112
    8000399e:	f486                	sd	ra,104(sp)
    800039a0:	f0a2                	sd	s0,96(sp)
    800039a2:	eca6                	sd	s1,88(sp)
    800039a4:	e0d2                	sd	s4,64(sp)
    800039a6:	fc56                	sd	s5,56(sp)
    800039a8:	f85a                	sd	s6,48(sp)
    800039aa:	f45e                	sd	s7,40(sp)
    800039ac:	1880                	addi	s0,sp,112
    800039ae:	8b2a                	mv	s6,a0
    800039b0:	8bae                	mv	s7,a1
    800039b2:	8a32                	mv	s4,a2
    800039b4:	84b6                	mv	s1,a3
    800039b6:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    800039b8:	9f35                	addw	a4,a4,a3
    return 0;
    800039ba:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    800039bc:	0ad76b63          	bltu	a4,a3,80003a72 <readi+0xdc>
    800039c0:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    800039c2:	00e7f463          	bgeu	a5,a4,800039ca <readi+0x34>
    n = ip->size - off;
    800039c6:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800039ca:	080a8b63          	beqz	s5,80003a60 <readi+0xca>
    800039ce:	e8ca                	sd	s2,80(sp)
    800039d0:	f062                	sd	s8,32(sp)
    800039d2:	ec66                	sd	s9,24(sp)
    800039d4:	e86a                	sd	s10,16(sp)
    800039d6:	e46e                	sd	s11,8(sp)
    800039d8:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800039da:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039de:	5c7d                	li	s8,-1
    800039e0:	a80d                	j	80003a12 <readi+0x7c>
    800039e2:	020d1d93          	slli	s11,s10,0x20
    800039e6:	020ddd93          	srli	s11,s11,0x20
    800039ea:	05890613          	addi	a2,s2,88
    800039ee:	86ee                	mv	a3,s11
    800039f0:	963e                	add	a2,a2,a5
    800039f2:	85d2                	mv	a1,s4
    800039f4:	855e                	mv	a0,s7
    800039f6:	8c7fe0ef          	jal	800022bc <either_copyout>
    800039fa:	05850363          	beq	a0,s8,80003a40 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800039fe:	854a                	mv	a0,s2
    80003a00:	e24ff0ef          	jal	80003024 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003a04:	013d09bb          	addw	s3,s10,s3
    80003a08:	009d04bb          	addw	s1,s10,s1
    80003a0c:	9a6e                	add	s4,s4,s11
    80003a0e:	0559f363          	bgeu	s3,s5,80003a54 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003a12:	00a4d59b          	srliw	a1,s1,0xa
    80003a16:	855a                	mv	a0,s6
    80003a18:	86bff0ef          	jal	80003282 <bmap>
    80003a1c:	85aa                	mv	a1,a0
    if (addr == 0)
    80003a1e:	c139                	beqz	a0,80003a64 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003a20:	000b2503          	lw	a0,0(s6)
    80003a24:	cf8ff0ef          	jal	80002f1c <bread>
    80003a28:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003a2a:	3ff4f793          	andi	a5,s1,1023
    80003a2e:	40fc873b          	subw	a4,s9,a5
    80003a32:	413a86bb          	subw	a3,s5,s3
    80003a36:	8d3a                	mv	s10,a4
    80003a38:	fae6f5e3          	bgeu	a3,a4,800039e2 <readi+0x4c>
    80003a3c:	8d36                	mv	s10,a3
    80003a3e:	b755                	j	800039e2 <readi+0x4c>
      brelse(bp);
    80003a40:	854a                	mv	a0,s2
    80003a42:	de2ff0ef          	jal	80003024 <brelse>
      tot = -1;
    80003a46:	59fd                	li	s3,-1
      break;
    80003a48:	6946                	ld	s2,80(sp)
    80003a4a:	7c02                	ld	s8,32(sp)
    80003a4c:	6ce2                	ld	s9,24(sp)
    80003a4e:	6d42                	ld	s10,16(sp)
    80003a50:	6da2                	ld	s11,8(sp)
    80003a52:	a831                	j	80003a6e <readi+0xd8>
    80003a54:	6946                	ld	s2,80(sp)
    80003a56:	7c02                	ld	s8,32(sp)
    80003a58:	6ce2                	ld	s9,24(sp)
    80003a5a:	6d42                	ld	s10,16(sp)
    80003a5c:	6da2                	ld	s11,8(sp)
    80003a5e:	a801                	j	80003a6e <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003a60:	89d6                	mv	s3,s5
    80003a62:	a031                	j	80003a6e <readi+0xd8>
    80003a64:	6946                	ld	s2,80(sp)
    80003a66:	7c02                	ld	s8,32(sp)
    80003a68:	6ce2                	ld	s9,24(sp)
    80003a6a:	6d42                	ld	s10,16(sp)
    80003a6c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003a6e:	854e                	mv	a0,s3
    80003a70:	69a6                	ld	s3,72(sp)
}
    80003a72:	70a6                	ld	ra,104(sp)
    80003a74:	7406                	ld	s0,96(sp)
    80003a76:	64e6                	ld	s1,88(sp)
    80003a78:	6a06                	ld	s4,64(sp)
    80003a7a:	7ae2                	ld	s5,56(sp)
    80003a7c:	7b42                	ld	s6,48(sp)
    80003a7e:	7ba2                	ld	s7,40(sp)
    80003a80:	6165                	addi	sp,sp,112
    80003a82:	8082                	ret
    return 0;
    80003a84:	4501                	li	a0,0
}
    80003a86:	8082                	ret

0000000080003a88 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003a88:	457c                	lw	a5,76(a0)
    80003a8a:	10d7e163          	bltu	a5,a3,80003b8c <writei+0x104>
{
    80003a8e:	7159                	addi	sp,sp,-112
    80003a90:	f486                	sd	ra,104(sp)
    80003a92:	f0a2                	sd	s0,96(sp)
    80003a94:	e8ca                	sd	s2,80(sp)
    80003a96:	e0d2                	sd	s4,64(sp)
    80003a98:	fc56                	sd	s5,56(sp)
    80003a9a:	f85a                	sd	s6,48(sp)
    80003a9c:	f45e                	sd	s7,40(sp)
    80003a9e:	1880                	addi	s0,sp,112
    80003aa0:	8aaa                	mv	s5,a0
    80003aa2:	8bae                	mv	s7,a1
    80003aa4:	8a32                	mv	s4,a2
    80003aa6:	8936                	mv	s2,a3
    80003aa8:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003aaa:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80003aac:	000437b7          	lui	a5,0x43
    80003ab0:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    80003ab4:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    80003ab8:	8fd9                	or	a5,a5,a4
    80003aba:	ef91                	bnez	a5,80003ad6 <writei+0x4e>
    80003abc:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003abe:	0a0b0f63          	beqz	s6,80003b7c <writei+0xf4>
    80003ac2:	eca6                	sd	s1,88(sp)
    80003ac4:	f062                	sd	s8,32(sp)
    80003ac6:	ec66                	sd	s9,24(sp)
    80003ac8:	e86a                	sd	s10,16(sp)
    80003aca:	e46e                	sd	s11,8(sp)
    80003acc:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003ace:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ad2:	5c7d                	li	s8,-1
    80003ad4:	a835                	j	80003b10 <writei+0x88>
    return -1;
    80003ad6:	557d                	li	a0,-1
    80003ad8:	a849                	j	80003b6a <writei+0xe2>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ada:	020d1d93          	slli	s11,s10,0x20
    80003ade:	020ddd93          	srli	s11,s11,0x20
    80003ae2:	05848513          	addi	a0,s1,88
    80003ae6:	86ee                	mv	a3,s11
    80003ae8:	8652                	mv	a2,s4
    80003aea:	85de                	mv	a1,s7
    80003aec:	953e                	add	a0,a0,a5
    80003aee:	81bfe0ef          	jal	80002308 <either_copyin>
    80003af2:	05850663          	beq	a0,s8,80003b3e <writei+0xb6>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80003af6:	8526                	mv	a0,s1
    80003af8:	6e4000ef          	jal	800041dc <log_write>
    brelse(bp);
    80003afc:	8526                	mv	a0,s1
    80003afe:	d26ff0ef          	jal	80003024 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003b02:	013d09bb          	addw	s3,s10,s3
    80003b06:	012d093b          	addw	s2,s10,s2
    80003b0a:	9a6e                	add	s4,s4,s11
    80003b0c:	0369ff63          	bgeu	s3,s6,80003b4a <writei+0xc2>
    uint addr = bmap(ip, off / BSIZE);
    80003b10:	00a9559b          	srliw	a1,s2,0xa
    80003b14:	8556                	mv	a0,s5
    80003b16:	f6cff0ef          	jal	80003282 <bmap>
    80003b1a:	85aa                	mv	a1,a0
    if (addr == 0)
    80003b1c:	c51d                	beqz	a0,80003b4a <writei+0xc2>
    bp = bread(ip->dev, addr);
    80003b1e:	000aa503          	lw	a0,0(s5)
    80003b22:	bfaff0ef          	jal	80002f1c <bread>
    80003b26:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003b28:	3ff97793          	andi	a5,s2,1023
    80003b2c:	40fc873b          	subw	a4,s9,a5
    80003b30:	413b06bb          	subw	a3,s6,s3
    80003b34:	8d3a                	mv	s10,a4
    80003b36:	fae6f2e3          	bgeu	a3,a4,80003ada <writei+0x52>
    80003b3a:	8d36                	mv	s10,a3
    80003b3c:	bf79                	j	80003ada <writei+0x52>
      log_write(bp);
    80003b3e:	8526                	mv	a0,s1
    80003b40:	69c000ef          	jal	800041dc <log_write>
      brelse(bp);
    80003b44:	8526                	mv	a0,s1
    80003b46:	cdeff0ef          	jal	80003024 <brelse>
  }

  if (off > ip->size)
    80003b4a:	04caa783          	lw	a5,76(s5)
    80003b4e:	0327f963          	bgeu	a5,s2,80003b80 <writei+0xf8>
    ip->size = off;
    80003b52:	052aa623          	sw	s2,76(s5)
    80003b56:	64e6                	ld	s1,88(sp)
    80003b58:	7c02                	ld	s8,32(sp)
    80003b5a:	6ce2                	ld	s9,24(sp)
    80003b5c:	6d42                	ld	s10,16(sp)
    80003b5e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003b60:	8556                	mv	a0,s5
    80003b62:	9a7ff0ef          	jal	80003508 <iupdate>

  return tot;
    80003b66:	854e                	mv	a0,s3
    80003b68:	69a6                	ld	s3,72(sp)
}
    80003b6a:	70a6                	ld	ra,104(sp)
    80003b6c:	7406                	ld	s0,96(sp)
    80003b6e:	6946                	ld	s2,80(sp)
    80003b70:	6a06                	ld	s4,64(sp)
    80003b72:	7ae2                	ld	s5,56(sp)
    80003b74:	7b42                	ld	s6,48(sp)
    80003b76:	7ba2                	ld	s7,40(sp)
    80003b78:	6165                	addi	sp,sp,112
    80003b7a:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003b7c:	89da                	mv	s3,s6
    80003b7e:	b7cd                	j	80003b60 <writei+0xd8>
    80003b80:	64e6                	ld	s1,88(sp)
    80003b82:	7c02                	ld	s8,32(sp)
    80003b84:	6ce2                	ld	s9,24(sp)
    80003b86:	6d42                	ld	s10,16(sp)
    80003b88:	6da2                	ld	s11,8(sp)
    80003b8a:	bfd9                	j	80003b60 <writei+0xd8>
    return -1;
    80003b8c:	557d                	li	a0,-1
}
    80003b8e:	8082                	ret

0000000080003b90 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003b90:	1141                	addi	sp,sp,-16
    80003b92:	e406                	sd	ra,8(sp)
    80003b94:	e022                	sd	s0,0(sp)
    80003b96:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003b98:	4639                	li	a2,14
    80003b9a:	a30fd0ef          	jal	80000dca <strncmp>
}
    80003b9e:	60a2                	ld	ra,8(sp)
    80003ba0:	6402                	ld	s0,0(sp)
    80003ba2:	0141                	addi	sp,sp,16
    80003ba4:	8082                	ret

0000000080003ba6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ba6:	711d                	addi	sp,sp,-96
    80003ba8:	ec86                	sd	ra,88(sp)
    80003baa:	e8a2                	sd	s0,80(sp)
    80003bac:	e4a6                	sd	s1,72(sp)
    80003bae:	e0ca                	sd	s2,64(sp)
    80003bb0:	fc4e                	sd	s3,56(sp)
    80003bb2:	f852                	sd	s4,48(sp)
    80003bb4:	f456                	sd	s5,40(sp)
    80003bb6:	f05a                	sd	s6,32(sp)
    80003bb8:	ec5e                	sd	s7,24(sp)
    80003bba:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003bbc:	04451703          	lh	a4,68(a0)
    80003bc0:	4785                	li	a5,1
    80003bc2:	02f71963          	bne	a4,a5,80003bf4 <dirlookup+0x4e>
    80003bc6:	892a                	mv	s2,a0
    80003bc8:	8aae                	mv	s5,a1
    80003bca:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003bcc:	457c                	lw	a5,76(a0)
    80003bce:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bd0:	fa040a13          	addi	s4,s0,-96
    80003bd4:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003bd6:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003bda:	ef95                	bnez	a5,80003c16 <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003bdc:	4501                	li	a0,0
}
    80003bde:	60e6                	ld	ra,88(sp)
    80003be0:	6446                	ld	s0,80(sp)
    80003be2:	64a6                	ld	s1,72(sp)
    80003be4:	6906                	ld	s2,64(sp)
    80003be6:	79e2                	ld	s3,56(sp)
    80003be8:	7a42                	ld	s4,48(sp)
    80003bea:	7aa2                	ld	s5,40(sp)
    80003bec:	7b02                	ld	s6,32(sp)
    80003bee:	6be2                	ld	s7,24(sp)
    80003bf0:	6125                	addi	sp,sp,96
    80003bf2:	8082                	ret
    panic("dirlookup not DIR");
    80003bf4:	00004517          	auipc	a0,0x4
    80003bf8:	9ec50513          	addi	a0,a0,-1556 # 800075e0 <etext+0x5e0>
    80003bfc:	c4dfc0ef          	jal	80000848 <panic>
      panic("dirlookup read");
    80003c00:	00004517          	auipc	a0,0x4
    80003c04:	9f850513          	addi	a0,a0,-1544 # 800075f8 <etext+0x5f8>
    80003c08:	c41fc0ef          	jal	80000848 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003c0c:	24c1                	addiw	s1,s1,16
    80003c0e:	04c92783          	lw	a5,76(s2)
    80003c12:	fcf4f5e3          	bgeu	s1,a5,80003bdc <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c16:	874e                	mv	a4,s3
    80003c18:	86a6                	mv	a3,s1
    80003c1a:	8652                	mv	a2,s4
    80003c1c:	4581                	li	a1,0
    80003c1e:	854a                	mv	a0,s2
    80003c20:	d77ff0ef          	jal	80003996 <readi>
    80003c24:	fd351ee3          	bne	a0,s3,80003c00 <dirlookup+0x5a>
    if (de.inum == 0)
    80003c28:	fa045783          	lhu	a5,-96(s0)
    80003c2c:	d3e5                	beqz	a5,80003c0c <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    80003c2e:	85da                	mv	a1,s6
    80003c30:	8556                	mv	a0,s5
    80003c32:	f5fff0ef          	jal	80003b90 <namecmp>
    80003c36:	f979                	bnez	a0,80003c0c <dirlookup+0x66>
      if (poff)
    80003c38:	000b8463          	beqz	s7,80003c40 <dirlookup+0x9a>
        *poff = off;
    80003c3c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003c40:	fa045583          	lhu	a1,-96(s0)
    80003c44:	00092503          	lw	a0,0(s2)
    80003c48:	efaff0ef          	jal	80003342 <iget>
    80003c4c:	bf49                	j	80003bde <dirlookup+0x38>

0000000080003c4e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003c4e:	711d                	addi	sp,sp,-96
    80003c50:	ec86                	sd	ra,88(sp)
    80003c52:	e8a2                	sd	s0,80(sp)
    80003c54:	e4a6                	sd	s1,72(sp)
    80003c56:	e0ca                	sd	s2,64(sp)
    80003c58:	fc4e                	sd	s3,56(sp)
    80003c5a:	f852                	sd	s4,48(sp)
    80003c5c:	f456                	sd	s5,40(sp)
    80003c5e:	f05a                	sd	s6,32(sp)
    80003c60:	ec5e                	sd	s7,24(sp)
    80003c62:	e862                	sd	s8,16(sp)
    80003c64:	e466                	sd	s9,8(sp)
    80003c66:	e06a                	sd	s10,0(sp)
    80003c68:	1080                	addi	s0,sp,96
    80003c6a:	84aa                	mv	s1,a0
    80003c6c:	8b2e                	mv	s6,a1
    80003c6e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003c70:	00054703          	lbu	a4,0(a0)
    80003c74:	02f00793          	li	a5,47
    80003c78:	00f70f63          	beq	a4,a5,80003c96 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c7c:	cadfd0ef          	jal	80001928 <myproc>
    80003c80:	15053503          	ld	a0,336(a0)
    80003c84:	903ff0ef          	jal	80003586 <idup>
    80003c88:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003c8a:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003c8e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003c90:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003c92:	4b85                	li	s7,1
    80003c94:	a075                	j	80003d40 <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
    80003c96:	4585                	li	a1,1
    80003c98:	852e                	mv	a0,a1
    80003c9a:	ea8ff0ef          	jal	80003342 <iget>
    80003c9e:	8a2a                	mv	s4,a0
    80003ca0:	b7ed                	j	80003c8a <namex+0x3c>
      iunlockput(ip);
    80003ca2:	8552                	mv	a0,s4
    80003ca4:	b6dff0ef          	jal	80003810 <iunlockput>
      return 0;
    80003ca8:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003caa:	8552                	mv	a0,s4
    80003cac:	60e6                	ld	ra,88(sp)
    80003cae:	6446                	ld	s0,80(sp)
    80003cb0:	64a6                	ld	s1,72(sp)
    80003cb2:	6906                	ld	s2,64(sp)
    80003cb4:	79e2                	ld	s3,56(sp)
    80003cb6:	7a42                	ld	s4,48(sp)
    80003cb8:	7aa2                	ld	s5,40(sp)
    80003cba:	7b02                	ld	s6,32(sp)
    80003cbc:	6be2                	ld	s7,24(sp)
    80003cbe:	6c42                	ld	s8,16(sp)
    80003cc0:	6ca2                	ld	s9,8(sp)
    80003cc2:	6d02                	ld	s10,0(sp)
    80003cc4:	6125                	addi	sp,sp,96
    80003cc6:	8082                	ret
      iunlockput(ip);
    80003cc8:	8552                	mv	a0,s4
    80003cca:	b47ff0ef          	jal	80003810 <iunlockput>
      return 0;
    80003cce:	bfe9                	j	80003ca8 <namex+0x5a>
      iunlock(ip);
    80003cd0:	8552                	mv	a0,s4
    80003cd2:	999ff0ef          	jal	8000366a <iunlock>
      return ip;
    80003cd6:	bfd1                	j	80003caa <namex+0x5c>
      iunlockput(ip);
    80003cd8:	8552                	mv	a0,s4
    80003cda:	b37ff0ef          	jal	80003810 <iunlockput>
      return 0;
    80003cde:	8a4a                	mv	s4,s2
    80003ce0:	b7e9                	j	80003caa <namex+0x5c>
  while (*path != '/' && *path != 0)
    80003ce2:	8926                	mv	s2,s1
  len = path - s;
    80003ce4:	4d01                	li	s10,0
    80003ce6:	4601                	li	a2,0
    memmove(name, s, len);
    80003ce8:	2601                	sext.w	a2,a2
    80003cea:	85a6                	mv	a1,s1
    80003cec:	8556                	mv	a0,s5
    80003cee:	868fd0ef          	jal	80000d56 <memmove>
    name[len] = 0;
    80003cf2:	9d56                	add	s10,s10,s5
    80003cf4:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde050>
    80003cf8:	84ca                	mv	s1,s2
  while (*path == '/')
    80003cfa:	0004c783          	lbu	a5,0(s1)
    80003cfe:	01379763          	bne	a5,s3,80003d0c <namex+0xbe>
    path++;
    80003d02:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003d04:	0004c783          	lbu	a5,0(s1)
    80003d08:	ff378de3          	beq	a5,s3,80003d02 <namex+0xb4>
    ilock(ip);
    80003d0c:	8552                	mv	a0,s4
    80003d0e:	8afff0ef          	jal	800035bc <ilock>
    if (ip->type != T_DIR) {
    80003d12:	044a1783          	lh	a5,68(s4)
    80003d16:	f97796e3          	bne	a5,s7,80003ca2 <namex+0x54>
    if (ip->nlink == 0) {
    80003d1a:	04aa1783          	lh	a5,74(s4)
    80003d1e:	d7cd                	beqz	a5,80003cc8 <namex+0x7a>
    if (nameiparent && *path == '\0') {
    80003d20:	000b0563          	beqz	s6,80003d2a <namex+0xdc>
    80003d24:	0004c783          	lbu	a5,0(s1)
    80003d28:	d7c5                	beqz	a5,80003cd0 <namex+0x82>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003d2a:	4601                	li	a2,0
    80003d2c:	85d6                	mv	a1,s5
    80003d2e:	8552                	mv	a0,s4
    80003d30:	e77ff0ef          	jal	80003ba6 <dirlookup>
    80003d34:	892a                	mv	s2,a0
    80003d36:	d14d                	beqz	a0,80003cd8 <namex+0x8a>
    iunlockput(ip);
    80003d38:	8552                	mv	a0,s4
    80003d3a:	ad7ff0ef          	jal	80003810 <iunlockput>
    ip = next;
    80003d3e:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003d40:	0004c783          	lbu	a5,0(s1)
    80003d44:	01379763          	bne	a5,s3,80003d52 <namex+0x104>
    path++;
    80003d48:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003d4a:	0004c783          	lbu	a5,0(s1)
    80003d4e:	ff378de3          	beq	a5,s3,80003d48 <namex+0xfa>
  if (*path == 0)
    80003d52:	c7a1                	beqz	a5,80003d9a <namex+0x14c>
  while (*path != '/' && *path != 0)
    80003d54:	0004c703          	lbu	a4,0(s1)
    80003d58:	fd170793          	addi	a5,a4,-47
    80003d5c:	00f037b3          	snez	a5,a5
    80003d60:	00e03733          	snez	a4,a4
    80003d64:	8ff9                	and	a5,a5,a4
    80003d66:	dfb5                	beqz	a5,80003ce2 <namex+0x94>
    80003d68:	8926                	mv	s2,s1
    path++;
    80003d6a:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003d6c:	00094703          	lbu	a4,0(s2)
    80003d70:	fd170793          	addi	a5,a4,-47
    80003d74:	00f037b3          	snez	a5,a5
    80003d78:	00e03733          	snez	a4,a4
    80003d7c:	8ff9                	and	a5,a5,a4
    80003d7e:	f7f5                	bnez	a5,80003d6a <namex+0x11c>
  len = path - s;
    80003d80:	40990633          	sub	a2,s2,s1
    80003d84:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003d88:	f7ac50e3          	bge	s8,s10,80003ce8 <namex+0x9a>
    memmove(name, s, DIRSIZ);
    80003d8c:	8666                	mv	a2,s9
    80003d8e:	85a6                	mv	a1,s1
    80003d90:	8556                	mv	a0,s5
    80003d92:	fc5fc0ef          	jal	80000d56 <memmove>
    80003d96:	84ca                	mv	s1,s2
    80003d98:	b78d                	j	80003cfa <namex+0xac>
  if (nameiparent) {
    80003d9a:	f00b08e3          	beqz	s6,80003caa <namex+0x5c>
    iput(ip);
    80003d9e:	8552                	mv	a0,s4
    80003da0:	99fff0ef          	jal	8000373e <iput>
    return 0;
    80003da4:	b711                	j	80003ca8 <namex+0x5a>

0000000080003da6 <dirlink>:
{
    80003da6:	715d                	addi	sp,sp,-80
    80003da8:	e486                	sd	ra,72(sp)
    80003daa:	e0a2                	sd	s0,64(sp)
    80003dac:	f84a                	sd	s2,48(sp)
    80003dae:	ec56                	sd	s5,24(sp)
    80003db0:	e85a                	sd	s6,16(sp)
    80003db2:	0880                	addi	s0,sp,80
    80003db4:	892a                	mv	s2,a0
    80003db6:	8aae                	mv	s5,a1
    80003db8:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003dba:	4601                	li	a2,0
    80003dbc:	debff0ef          	jal	80003ba6 <dirlookup>
    80003dc0:	ed1d                	bnez	a0,80003dfe <dirlink+0x58>
    80003dc2:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003dc4:	04c92483          	lw	s1,76(s2)
    80003dc8:	c4b9                	beqz	s1,80003e16 <dirlink+0x70>
    80003dca:	f44e                	sd	s3,40(sp)
    80003dcc:	f052                	sd	s4,32(sp)
    80003dce:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dd0:	fb040a13          	addi	s4,s0,-80
    80003dd4:	49c1                	li	s3,16
    80003dd6:	874e                	mv	a4,s3
    80003dd8:	86a6                	mv	a3,s1
    80003dda:	8652                	mv	a2,s4
    80003ddc:	4581                	li	a1,0
    80003dde:	854a                	mv	a0,s2
    80003de0:	bb7ff0ef          	jal	80003996 <readi>
    80003de4:	03351163          	bne	a0,s3,80003e06 <dirlink+0x60>
    if (de.inum == 0)
    80003de8:	fb045783          	lhu	a5,-80(s0)
    80003dec:	c39d                	beqz	a5,80003e12 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003dee:	24c1                	addiw	s1,s1,16
    80003df0:	04c92783          	lw	a5,76(s2)
    80003df4:	fef4e1e3          	bltu	s1,a5,80003dd6 <dirlink+0x30>
    80003df8:	79a2                	ld	s3,40(sp)
    80003dfa:	7a02                	ld	s4,32(sp)
    80003dfc:	a829                	j	80003e16 <dirlink+0x70>
    iput(ip);
    80003dfe:	941ff0ef          	jal	8000373e <iput>
    return -1;
    80003e02:	557d                	li	a0,-1
    80003e04:	a83d                	j	80003e42 <dirlink+0x9c>
      panic("dirlink read");
    80003e06:	00004517          	auipc	a0,0x4
    80003e0a:	80250513          	addi	a0,a0,-2046 # 80007608 <etext+0x608>
    80003e0e:	a3bfc0ef          	jal	80000848 <panic>
    80003e12:	79a2                	ld	s3,40(sp)
    80003e14:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003e16:	4639                	li	a2,14
    80003e18:	85d6                	mv	a1,s5
    80003e1a:	fb240513          	addi	a0,s0,-78
    80003e1e:	fe3fc0ef          	jal	80000e00 <strncpy>
  de.inum = inum;
    80003e22:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e26:	4741                	li	a4,16
    80003e28:	86a6                	mv	a3,s1
    80003e2a:	fb040613          	addi	a2,s0,-80
    80003e2e:	4581                	li	a1,0
    80003e30:	854a                	mv	a0,s2
    80003e32:	c57ff0ef          	jal	80003a88 <writei>
    80003e36:	1541                	addi	a0,a0,-16
    80003e38:	00a03533          	snez	a0,a0
    80003e3c:	40a0053b          	negw	a0,a0
    80003e40:	74e2                	ld	s1,56(sp)
}
    80003e42:	60a6                	ld	ra,72(sp)
    80003e44:	6406                	ld	s0,64(sp)
    80003e46:	7942                	ld	s2,48(sp)
    80003e48:	6ae2                	ld	s5,24(sp)
    80003e4a:	6b42                	ld	s6,16(sp)
    80003e4c:	6161                	addi	sp,sp,80
    80003e4e:	8082                	ret

0000000080003e50 <namei>:

struct inode *
namei(char *path)
{
    80003e50:	1101                	addi	sp,sp,-32
    80003e52:	ec06                	sd	ra,24(sp)
    80003e54:	e822                	sd	s0,16(sp)
    80003e56:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003e58:	fe040613          	addi	a2,s0,-32
    80003e5c:	4581                	li	a1,0
    80003e5e:	df1ff0ef          	jal	80003c4e <namex>
}
    80003e62:	60e2                	ld	ra,24(sp)
    80003e64:	6442                	ld	s0,16(sp)
    80003e66:	6105                	addi	sp,sp,32
    80003e68:	8082                	ret

0000000080003e6a <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003e6a:	1141                	addi	sp,sp,-16
    80003e6c:	e406                	sd	ra,8(sp)
    80003e6e:	e022                	sd	s0,0(sp)
    80003e70:	0800                	addi	s0,sp,16
    80003e72:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003e74:	4585                	li	a1,1
    80003e76:	dd9ff0ef          	jal	80003c4e <namex>
}
    80003e7a:	60a2                	ld	ra,8(sp)
    80003e7c:	6402                	ld	s0,0(sp)
    80003e7e:	0141                	addi	sp,sp,16
    80003e80:	8082                	ret

0000000080003e82 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003e82:	1101                	addi	sp,sp,-32
    80003e84:	ec06                	sd	ra,24(sp)
    80003e86:	e822                	sd	s0,16(sp)
    80003e88:	e426                	sd	s1,8(sp)
    80003e8a:	e04a                	sd	s2,0(sp)
    80003e8c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003e8e:	0001c917          	auipc	s2,0x1c
    80003e92:	ee290913          	addi	s2,s2,-286 # 8001fd70 <log>
    80003e96:	01892583          	lw	a1,24(s2)
    80003e9a:	02492503          	lw	a0,36(s2)
    80003e9e:	87eff0ef          	jal	80002f1c <bread>
    80003ea2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003ea4:	02c92603          	lw	a2,44(s2)
    80003ea8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003eaa:	00c05f63          	blez	a2,80003ec8 <write_head+0x46>
    80003eae:	0001c717          	auipc	a4,0x1c
    80003eb2:	ef270713          	addi	a4,a4,-270 # 8001fda0 <log+0x30>
    80003eb6:	87aa                	mv	a5,a0
    80003eb8:	060a                	slli	a2,a2,0x2
    80003eba:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003ebc:	4314                	lw	a3,0(a4)
    80003ebe:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003ec0:	0711                	addi	a4,a4,4
    80003ec2:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003ec4:	fec79ce3          	bne	a5,a2,80003ebc <write_head+0x3a>
  }
  bwrite(buf);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	928ff0ef          	jal	80002ff2 <bwrite>
  brelse(buf);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	954ff0ef          	jal	80003024 <brelse>
}
    80003ed4:	60e2                	ld	ra,24(sp)
    80003ed6:	6442                	ld	s0,16(sp)
    80003ed8:	64a2                	ld	s1,8(sp)
    80003eda:	6902                	ld	s2,0(sp)
    80003edc:	6105                	addi	sp,sp,32
    80003ede:	8082                	ret

0000000080003ee0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ee0:	0001c797          	auipc	a5,0x1c
    80003ee4:	ebc7a783          	lw	a5,-324(a5) # 8001fd9c <log+0x2c>
    80003ee8:	0cf05163          	blez	a5,80003faa <install_trans+0xca>
{
    80003eec:	715d                	addi	sp,sp,-80
    80003eee:	e486                	sd	ra,72(sp)
    80003ef0:	e0a2                	sd	s0,64(sp)
    80003ef2:	fc26                	sd	s1,56(sp)
    80003ef4:	f84a                	sd	s2,48(sp)
    80003ef6:	f44e                	sd	s3,40(sp)
    80003ef8:	f052                	sd	s4,32(sp)
    80003efa:	ec56                	sd	s5,24(sp)
    80003efc:	e85a                	sd	s6,16(sp)
    80003efe:	e45e                	sd	s7,8(sp)
    80003f00:	e062                	sd	s8,0(sp)
    80003f02:	0880                	addi	s0,sp,80
    80003f04:	8b2a                	mv	s6,a0
    80003f06:	0001ca97          	auipc	s5,0x1c
    80003f0a:	e9aa8a93          	addi	s5,s5,-358 # 8001fda0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f0e:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003f10:	00003c17          	auipc	s8,0x3
    80003f14:	708c0c13          	addi	s8,s8,1800 # 80007618 <etext+0x618>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003f18:	0001ca17          	auipc	s4,0x1c
    80003f1c:	e58a0a13          	addi	s4,s4,-424 # 8001fd70 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003f20:	40000b93          	li	s7,1024
    80003f24:	a025                	j	80003f4c <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003f26:	000aa603          	lw	a2,0(s5)
    80003f2a:	85ce                	mv	a1,s3
    80003f2c:	8562                	mv	a0,s8
    80003f2e:	de2fc0ef          	jal	80000510 <printk>
    80003f32:	a839                	j	80003f50 <install_trans+0x70>
    brelse(lbuf);
    80003f34:	854a                	mv	a0,s2
    80003f36:	8eeff0ef          	jal	80003024 <brelse>
    brelse(dbuf);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	8e8ff0ef          	jal	80003024 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f40:	2985                	addiw	s3,s3,1
    80003f42:	0a91                	addi	s5,s5,4
    80003f44:	02ca2783          	lw	a5,44(s4)
    80003f48:	04f9d563          	bge	s3,a5,80003f92 <install_trans+0xb2>
    if (recovering) {
    80003f4c:	fc0b1de3          	bnez	s6,80003f26 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003f50:	018a2583          	lw	a1,24(s4)
    80003f54:	013585bb          	addw	a1,a1,s3
    80003f58:	2585                	addiw	a1,a1,1
    80003f5a:	024a2503          	lw	a0,36(s4)
    80003f5e:	fbffe0ef          	jal	80002f1c <bread>
    80003f62:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003f64:	000aa583          	lw	a1,0(s5)
    80003f68:	024a2503          	lw	a0,36(s4)
    80003f6c:	fb1fe0ef          	jal	80002f1c <bread>
    80003f70:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003f72:	865e                	mv	a2,s7
    80003f74:	05890593          	addi	a1,s2,88
    80003f78:	05850513          	addi	a0,a0,88
    80003f7c:	ddbfc0ef          	jal	80000d56 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003f80:	8526                	mv	a0,s1
    80003f82:	870ff0ef          	jal	80002ff2 <bwrite>
    if (recovering == 0)
    80003f86:	fa0b17e3          	bnez	s6,80003f34 <install_trans+0x54>
      bunpin(dbuf);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	950ff0ef          	jal	800030dc <bunpin>
    80003f90:	b755                	j	80003f34 <install_trans+0x54>
}
    80003f92:	60a6                	ld	ra,72(sp)
    80003f94:	6406                	ld	s0,64(sp)
    80003f96:	74e2                	ld	s1,56(sp)
    80003f98:	7942                	ld	s2,48(sp)
    80003f9a:	79a2                	ld	s3,40(sp)
    80003f9c:	7a02                	ld	s4,32(sp)
    80003f9e:	6ae2                	ld	s5,24(sp)
    80003fa0:	6b42                	ld	s6,16(sp)
    80003fa2:	6ba2                	ld	s7,8(sp)
    80003fa4:	6c02                	ld	s8,0(sp)
    80003fa6:	6161                	addi	sp,sp,80
    80003fa8:	8082                	ret
    80003faa:	8082                	ret

0000000080003fac <initlog>:
{
    80003fac:	7179                	addi	sp,sp,-48
    80003fae:	f406                	sd	ra,40(sp)
    80003fb0:	f022                	sd	s0,32(sp)
    80003fb2:	ec26                	sd	s1,24(sp)
    80003fb4:	e84a                	sd	s2,16(sp)
    80003fb6:	e44e                	sd	s3,8(sp)
    80003fb8:	1800                	addi	s0,sp,48
    80003fba:	84aa                	mv	s1,a0
    80003fbc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003fbe:	0001c917          	auipc	s2,0x1c
    80003fc2:	db290913          	addi	s2,s2,-590 # 8001fd70 <log>
    80003fc6:	00003597          	auipc	a1,0x3
    80003fca:	67258593          	addi	a1,a1,1650 # 80007638 <etext+0x638>
    80003fce:	854a                	mv	a0,s2
    80003fd0:	beffc0ef          	jal	80000bbe <initlock>
  log.start = sb->logstart;
    80003fd4:	0149a583          	lw	a1,20(s3)
    80003fd8:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003fdc:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	f3bfe0ef          	jal	80002f1c <bread>
  log.lh.n = lh->n;
    80003fe6:	4d30                	lw	a2,88(a0)
    80003fe8:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003fec:	00c05f63          	blez	a2,8000400a <initlog+0x5e>
    80003ff0:	87aa                	mv	a5,a0
    80003ff2:	0001c717          	auipc	a4,0x1c
    80003ff6:	dae70713          	addi	a4,a4,-594 # 8001fda0 <log+0x30>
    80003ffa:	060a                	slli	a2,a2,0x2
    80003ffc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003ffe:	4ff4                	lw	a3,92(a5)
    80004000:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004002:	0791                	addi	a5,a5,4
    80004004:	0711                	addi	a4,a4,4
    80004006:	fec79ce3          	bne	a5,a2,80003ffe <initlog+0x52>
  brelse(buf);
    8000400a:	81aff0ef          	jal	80003024 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000400e:	4505                	li	a0,1
    80004010:	ed1ff0ef          	jal	80003ee0 <install_trans>
  log.lh.n = 0;
    80004014:	0001c797          	auipc	a5,0x1c
    80004018:	d807a423          	sw	zero,-632(a5) # 8001fd9c <log+0x2c>
  write_head(); // clear the log
    8000401c:	e67ff0ef          	jal	80003e82 <write_head>
}
    80004020:	70a2                	ld	ra,40(sp)
    80004022:	7402                	ld	s0,32(sp)
    80004024:	64e2                	ld	s1,24(sp)
    80004026:	6942                	ld	s2,16(sp)
    80004028:	69a2                	ld	s3,8(sp)
    8000402a:	6145                	addi	sp,sp,48
    8000402c:	8082                	ret

000000008000402e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000402e:	1101                	addi	sp,sp,-32
    80004030:	ec06                	sd	ra,24(sp)
    80004032:	e822                	sd	s0,16(sp)
    80004034:	e426                	sd	s1,8(sp)
    80004036:	e04a                	sd	s2,0(sp)
    80004038:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000403a:	0001c517          	auipc	a0,0x1c
    8000403e:	d3650513          	addi	a0,a0,-714 # 8001fd70 <log>
    80004042:	bfdfc0ef          	jal	80000c3e <acquire>
  while (1) {
    if (log.committing) {
    80004046:	0001c497          	auipc	s1,0x1c
    8000404a:	d2a48493          	addi	s1,s1,-726 # 8001fd70 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    8000404e:	4979                	li	s2,30
    80004050:	a821                	j	80004068 <begin_op+0x3a>
      sleep_prepare(&log);
    80004052:	8526                	mv	a0,s1
    80004054:	eddfd0ef          	jal	80001f30 <sleep_prepare>
      release(&log.lock);
    80004058:	8526                	mv	a0,s1
    8000405a:	c69fc0ef          	jal	80000cc2 <release>
      sleep();
    8000405e:	f0ffd0ef          	jal	80001f6c <sleep>
      acquire(&log.lock);
    80004062:	8526                	mv	a0,s1
    80004064:	bdbfc0ef          	jal	80000c3e <acquire>
    if (log.committing) {
    80004068:	509c                	lw	a5,32(s1)
    8000406a:	f7e5                	bnez	a5,80004052 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    8000406c:	4cd8                	lw	a4,28(s1)
    8000406e:	2705                	addiw	a4,a4,1
    80004070:	0027179b          	slliw	a5,a4,0x2
    80004074:	9fb9                	addw	a5,a5,a4
    80004076:	0017979b          	slliw	a5,a5,0x1
    8000407a:	54d4                	lw	a3,44(s1)
    8000407c:	9fb5                	addw	a5,a5,a3
    8000407e:	00f95e63          	bge	s2,a5,8000409a <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80004082:	8526                	mv	a0,s1
    80004084:	eadfd0ef          	jal	80001f30 <sleep_prepare>
      release(&log.lock);
    80004088:	8526                	mv	a0,s1
    8000408a:	c39fc0ef          	jal	80000cc2 <release>
      sleep();
    8000408e:	edffd0ef          	jal	80001f6c <sleep>
      acquire(&log.lock);
    80004092:	8526                	mv	a0,s1
    80004094:	babfc0ef          	jal	80000c3e <acquire>
    80004098:	bfc1                	j	80004068 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    8000409a:	0001c797          	auipc	a5,0x1c
    8000409e:	cee7a923          	sw	a4,-782(a5) # 8001fd8c <log+0x1c>
      release(&log.lock);
    800040a2:	0001c517          	auipc	a0,0x1c
    800040a6:	cce50513          	addi	a0,a0,-818 # 8001fd70 <log>
    800040aa:	c19fc0ef          	jal	80000cc2 <release>
      break;
    }
  }
}
    800040ae:	60e2                	ld	ra,24(sp)
    800040b0:	6442                	ld	s0,16(sp)
    800040b2:	64a2                	ld	s1,8(sp)
    800040b4:	6902                	ld	s2,0(sp)
    800040b6:	6105                	addi	sp,sp,32
    800040b8:	8082                	ret

00000000800040ba <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800040ba:	7139                	addi	sp,sp,-64
    800040bc:	fc06                	sd	ra,56(sp)
    800040be:	f822                	sd	s0,48(sp)
    800040c0:	f426                	sd	s1,40(sp)
    800040c2:	f04a                	sd	s2,32(sp)
    800040c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800040c6:	0001c497          	auipc	s1,0x1c
    800040ca:	caa48493          	addi	s1,s1,-854 # 8001fd70 <log>
    800040ce:	8526                	mv	a0,s1
    800040d0:	b6ffc0ef          	jal	80000c3e <acquire>
  log.outstanding -= 1;
    800040d4:	4cdc                	lw	a5,28(s1)
    800040d6:	37fd                	addiw	a5,a5,-1
    800040d8:	893e                	mv	s2,a5
    800040da:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    800040dc:	509c                	lw	a5,32(s1)
    800040de:	e7b9                	bnez	a5,8000412c <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    800040e0:	04091f63          	bnez	s2,8000413e <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    800040e4:	0001c497          	auipc	s1,0x1c
    800040e8:	c8c48493          	addi	s1,s1,-884 # 8001fd70 <log>
    800040ec:	4785                	li	a5,1
    800040ee:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800040f0:	8526                	mv	a0,s1
    800040f2:	bd1fc0ef          	jal	80000cc2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800040f6:	54dc                	lw	a5,44(s1)
    800040f8:	06f04063          	bgtz	a5,80004158 <end_op+0x9e>
    acquire(&log.lock);
    800040fc:	0001c497          	auipc	s1,0x1c
    80004100:	c7448493          	addi	s1,s1,-908 # 8001fd70 <log>
    80004104:	8526                	mv	a0,s1
    80004106:	b39fc0ef          	jal	80000c3e <acquire>
    log.committing = 0;
    8000410a:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    8000410e:	549c                	lw	a5,40(s1)
    80004110:	2785                	addiw	a5,a5,1
    80004112:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80004114:	8526                	mv	a0,s1
    80004116:	e87fd0ef          	jal	80001f9c <wakeup>
    release(&log.lock);
    8000411a:	8526                	mv	a0,s1
    8000411c:	ba7fc0ef          	jal	80000cc2 <release>
}
    80004120:	70e2                	ld	ra,56(sp)
    80004122:	7442                	ld	s0,48(sp)
    80004124:	74a2                	ld	s1,40(sp)
    80004126:	7902                	ld	s2,32(sp)
    80004128:	6121                	addi	sp,sp,64
    8000412a:	8082                	ret
    8000412c:	ec4e                	sd	s3,24(sp)
    8000412e:	e852                	sd	s4,16(sp)
    80004130:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004132:	00003517          	auipc	a0,0x3
    80004136:	50e50513          	addi	a0,a0,1294 # 80007640 <etext+0x640>
    8000413a:	f0efc0ef          	jal	80000848 <panic>
    wakeup(&log);
    8000413e:	0001c517          	auipc	a0,0x1c
    80004142:	c3250513          	addi	a0,a0,-974 # 8001fd70 <log>
    80004146:	e57fd0ef          	jal	80001f9c <wakeup>
  release(&log.lock);
    8000414a:	0001c517          	auipc	a0,0x1c
    8000414e:	c2650513          	addi	a0,a0,-986 # 8001fd70 <log>
    80004152:	b71fc0ef          	jal	80000cc2 <release>
  if (do_commit) {
    80004156:	b7e9                	j	80004120 <end_op+0x66>
    80004158:	ec4e                	sd	s3,24(sp)
    8000415a:	e852                	sd	s4,16(sp)
    8000415c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415e:	0001ca97          	auipc	s5,0x1c
    80004162:	c42a8a93          	addi	s5,s5,-958 # 8001fda0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004166:	0001ca17          	auipc	s4,0x1c
    8000416a:	c0aa0a13          	addi	s4,s4,-1014 # 8001fd70 <log>
    8000416e:	018a2583          	lw	a1,24(s4)
    80004172:	012585bb          	addw	a1,a1,s2
    80004176:	2585                	addiw	a1,a1,1
    80004178:	024a2503          	lw	a0,36(s4)
    8000417c:	da1fe0ef          	jal	80002f1c <bread>
    80004180:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004182:	000aa583          	lw	a1,0(s5)
    80004186:	024a2503          	lw	a0,36(s4)
    8000418a:	d93fe0ef          	jal	80002f1c <bread>
    8000418e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004190:	40000613          	li	a2,1024
    80004194:	05850593          	addi	a1,a0,88
    80004198:	05848513          	addi	a0,s1,88
    8000419c:	bbbfc0ef          	jal	80000d56 <memmove>
    bwrite(to); // write the log
    800041a0:	8526                	mv	a0,s1
    800041a2:	e51fe0ef          	jal	80002ff2 <bwrite>
    brelse(from);
    800041a6:	854e                	mv	a0,s3
    800041a8:	e7dfe0ef          	jal	80003024 <brelse>
    brelse(to);
    800041ac:	8526                	mv	a0,s1
    800041ae:	e77fe0ef          	jal	80003024 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041b2:	2905                	addiw	s2,s2,1
    800041b4:	0a91                	addi	s5,s5,4
    800041b6:	02ca2783          	lw	a5,44(s4)
    800041ba:	faf94ae3          	blt	s2,a5,8000416e <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    800041be:	cc5ff0ef          	jal	80003e82 <write_head>
    install_trans(0); // Now install writes to home locations
    800041c2:	4501                	li	a0,0
    800041c4:	d1dff0ef          	jal	80003ee0 <install_trans>
    log.lh.n = 0;
    800041c8:	0001c797          	auipc	a5,0x1c
    800041cc:	bc07aa23          	sw	zero,-1068(a5) # 8001fd9c <log+0x2c>
    write_head(); // Erase the transaction from the log
    800041d0:	cb3ff0ef          	jal	80003e82 <write_head>
    800041d4:	69e2                	ld	s3,24(sp)
    800041d6:	6a42                	ld	s4,16(sp)
    800041d8:	6aa2                	ld	s5,8(sp)
    800041da:	b70d                	j	800040fc <end_op+0x42>

00000000800041dc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800041dc:	1101                	addi	sp,sp,-32
    800041de:	ec06                	sd	ra,24(sp)
    800041e0:	e822                	sd	s0,16(sp)
    800041e2:	e426                	sd	s1,8(sp)
    800041e4:	1000                	addi	s0,sp,32
    800041e6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800041e8:	0001c517          	auipc	a0,0x1c
    800041ec:	b8850513          	addi	a0,a0,-1144 # 8001fd70 <log>
    800041f0:	a4ffc0ef          	jal	80000c3e <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800041f4:	0001c617          	auipc	a2,0x1c
    800041f8:	ba862603          	lw	a2,-1112(a2) # 8001fd9c <log+0x2c>
    800041fc:	47f5                	li	a5,29
    800041fe:	04c7cc63          	blt	a5,a2,80004256 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004202:	0001c797          	auipc	a5,0x1c
    80004206:	b8a7a783          	lw	a5,-1142(a5) # 8001fd8c <log+0x1c>
    8000420a:	04f05c63          	blez	a5,80004262 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000420e:	4781                	li	a5,0
    80004210:	04c05f63          	blez	a2,8000426e <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80004214:	44cc                	lw	a1,12(s1)
    80004216:	0001c717          	auipc	a4,0x1c
    8000421a:	b8a70713          	addi	a4,a4,-1142 # 8001fda0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000421e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80004220:	4314                	lw	a3,0(a4)
    80004222:	04b68663          	beq	a3,a1,8000426e <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80004226:	2785                	addiw	a5,a5,1
    80004228:	0711                	addi	a4,a4,4
    8000422a:	fef61be3          	bne	a2,a5,80004220 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000422e:	0621                	addi	a2,a2,8
    80004230:	060a                	slli	a2,a2,0x2
    80004232:	0001c797          	auipc	a5,0x1c
    80004236:	b3e78793          	addi	a5,a5,-1218 # 8001fd70 <log>
    8000423a:	97b2                	add	a5,a5,a2
    8000423c:	44d8                	lw	a4,12(s1)
    8000423e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80004240:	8526                	mv	a0,s1
    80004242:	e67fe0ef          	jal	800030a8 <bpin>
    log.lh.n++;
    80004246:	0001c717          	auipc	a4,0x1c
    8000424a:	b2a70713          	addi	a4,a4,-1238 # 8001fd70 <log>
    8000424e:	575c                	lw	a5,44(a4)
    80004250:	2785                	addiw	a5,a5,1
    80004252:	d75c                	sw	a5,44(a4)
    80004254:	a80d                	j	80004286 <log_write+0xaa>
    panic("too big a transaction");
    80004256:	00003517          	auipc	a0,0x3
    8000425a:	3fa50513          	addi	a0,a0,1018 # 80007650 <etext+0x650>
    8000425e:	deafc0ef          	jal	80000848 <panic>
    panic("log_write outside of trans");
    80004262:	00003517          	auipc	a0,0x3
    80004266:	40650513          	addi	a0,a0,1030 # 80007668 <etext+0x668>
    8000426a:	ddefc0ef          	jal	80000848 <panic>
  log.lh.block[i] = b->blockno;
    8000426e:	00878693          	addi	a3,a5,8
    80004272:	068a                	slli	a3,a3,0x2
    80004274:	0001c717          	auipc	a4,0x1c
    80004278:	afc70713          	addi	a4,a4,-1284 # 8001fd70 <log>
    8000427c:	9736                	add	a4,a4,a3
    8000427e:	44d4                	lw	a3,12(s1)
    80004280:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004282:	faf60fe3          	beq	a2,a5,80004240 <log_write+0x64>
  }
  release(&log.lock);
    80004286:	0001c517          	auipc	a0,0x1c
    8000428a:	aea50513          	addi	a0,a0,-1302 # 8001fd70 <log>
    8000428e:	a35fc0ef          	jal	80000cc2 <release>
}
    80004292:	60e2                	ld	ra,24(sp)
    80004294:	6442                	ld	s0,16(sp)
    80004296:	64a2                	ld	s1,8(sp)
    80004298:	6105                	addi	sp,sp,32
    8000429a:	8082                	ret

000000008000429c <sys_sync>:

uint64
sys_sync(void)
{
    8000429c:	1101                	addi	sp,sp,-32
    8000429e:	ec06                	sd	ra,24(sp)
    800042a0:	e822                	sd	s0,16(sp)
    800042a2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800042a4:	0001c517          	auipc	a0,0x1c
    800042a8:	acc50513          	addi	a0,a0,-1332 # 8001fd70 <log>
    800042ac:	993fc0ef          	jal	80000c3e <acquire>
  if (log.committing || log.outstanding > 0) {
    800042b0:	0001c797          	auipc	a5,0x1c
    800042b4:	ae07a783          	lw	a5,-1312(a5) # 8001fd90 <log+0x20>
    800042b8:	e799                	bnez	a5,800042c6 <sys_sync+0x2a>
    800042ba:	0001c797          	auipc	a5,0x1c
    800042be:	ad27a783          	lw	a5,-1326(a5) # 8001fd8c <log+0x1c>
    800042c2:	02f05c63          	blez	a5,800042fa <sys_sync+0x5e>
    800042c6:	e426                	sd	s1,8(sp)
    800042c8:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    800042ca:	0001c917          	auipc	s2,0x1c
    800042ce:	ace92903          	lw	s2,-1330(s2) # 8001fd98 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    800042d2:	0001c497          	auipc	s1,0x1c
    800042d6:	a9e48493          	addi	s1,s1,-1378 # 8001fd70 <log>
    800042da:	8526                	mv	a0,s1
    800042dc:	c55fd0ef          	jal	80001f30 <sleep_prepare>
      release(&log.lock);
    800042e0:	8526                	mv	a0,s1
    800042e2:	9e1fc0ef          	jal	80000cc2 <release>
      sleep();
    800042e6:	c87fd0ef          	jal	80001f6c <sleep>
      acquire(&log.lock);
    800042ea:	8526                	mv	a0,s1
    800042ec:	953fc0ef          	jal	80000c3e <acquire>
    while (log.ncommit < n) {
    800042f0:	549c                	lw	a5,40(s1)
    800042f2:	fef954e3          	bge	s2,a5,800042da <sys_sync+0x3e>
    800042f6:	64a2                	ld	s1,8(sp)
    800042f8:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    800042fa:	0001c517          	auipc	a0,0x1c
    800042fe:	a7650513          	addi	a0,a0,-1418 # 8001fd70 <log>
    80004302:	9c1fc0ef          	jal	80000cc2 <release>
  return 0;
}
    80004306:	4501                	li	a0,0
    80004308:	60e2                	ld	ra,24(sp)
    8000430a:	6442                	ld	s0,16(sp)
    8000430c:	6105                	addi	sp,sp,32
    8000430e:	8082                	ret

0000000080004310 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004310:	1101                	addi	sp,sp,-32
    80004312:	ec06                	sd	ra,24(sp)
    80004314:	e822                	sd	s0,16(sp)
    80004316:	e426                	sd	s1,8(sp)
    80004318:	e04a                	sd	s2,0(sp)
    8000431a:	1000                	addi	s0,sp,32
    8000431c:	84aa                	mv	s1,a0
    8000431e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004320:	00003597          	auipc	a1,0x3
    80004324:	36858593          	addi	a1,a1,872 # 80007688 <etext+0x688>
    80004328:	0521                	addi	a0,a0,8
    8000432a:	895fc0ef          	jal	80000bbe <initlock>
  lk->name = name;
    8000432e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004332:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004336:	0204a423          	sw	zero,40(s1)
}
    8000433a:	60e2                	ld	ra,24(sp)
    8000433c:	6442                	ld	s0,16(sp)
    8000433e:	64a2                	ld	s1,8(sp)
    80004340:	6902                	ld	s2,0(sp)
    80004342:	6105                	addi	sp,sp,32
    80004344:	8082                	ret

0000000080004346 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004346:	1101                	addi	sp,sp,-32
    80004348:	ec06                	sd	ra,24(sp)
    8000434a:	e822                	sd	s0,16(sp)
    8000434c:	e426                	sd	s1,8(sp)
    8000434e:	e04a                	sd	s2,0(sp)
    80004350:	1000                	addi	s0,sp,32
    80004352:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004354:	00850913          	addi	s2,a0,8
    80004358:	854a                	mv	a0,s2
    8000435a:	8e5fc0ef          	jal	80000c3e <acquire>
  while (lk->locked) {
    8000435e:	409c                	lw	a5,0(s1)
    80004360:	cf91                	beqz	a5,8000437c <acquiresleep+0x36>
    sleep_prepare(lk);
    80004362:	8526                	mv	a0,s1
    80004364:	bcdfd0ef          	jal	80001f30 <sleep_prepare>
    release(&lk->lk);
    80004368:	854a                	mv	a0,s2
    8000436a:	959fc0ef          	jal	80000cc2 <release>
    sleep();
    8000436e:	bfffd0ef          	jal	80001f6c <sleep>
    acquire(&lk->lk);
    80004372:	854a                	mv	a0,s2
    80004374:	8cbfc0ef          	jal	80000c3e <acquire>
  while (lk->locked) {
    80004378:	409c                	lw	a5,0(s1)
    8000437a:	f7e5                	bnez	a5,80004362 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000437c:	4785                	li	a5,1
    8000437e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004380:	da8fd0ef          	jal	80001928 <myproc>
    80004384:	591c                	lw	a5,48(a0)
    80004386:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004388:	854a                	mv	a0,s2
    8000438a:	939fc0ef          	jal	80000cc2 <release>
}
    8000438e:	60e2                	ld	ra,24(sp)
    80004390:	6442                	ld	s0,16(sp)
    80004392:	64a2                	ld	s1,8(sp)
    80004394:	6902                	ld	s2,0(sp)
    80004396:	6105                	addi	sp,sp,32
    80004398:	8082                	ret

000000008000439a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000439a:	1101                	addi	sp,sp,-32
    8000439c:	ec06                	sd	ra,24(sp)
    8000439e:	e822                	sd	s0,16(sp)
    800043a0:	e426                	sd	s1,8(sp)
    800043a2:	e04a                	sd	s2,0(sp)
    800043a4:	1000                	addi	s0,sp,32
    800043a6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043a8:	00850913          	addi	s2,a0,8
    800043ac:	854a                	mv	a0,s2
    800043ae:	891fc0ef          	jal	80000c3e <acquire>
  lk->locked = 0;
    800043b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043b6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043ba:	8526                	mv	a0,s1
    800043bc:	be1fd0ef          	jal	80001f9c <wakeup>
  release(&lk->lk);
    800043c0:	854a                	mv	a0,s2
    800043c2:	901fc0ef          	jal	80000cc2 <release>
}
    800043c6:	60e2                	ld	ra,24(sp)
    800043c8:	6442                	ld	s0,16(sp)
    800043ca:	64a2                	ld	s1,8(sp)
    800043cc:	6902                	ld	s2,0(sp)
    800043ce:	6105                	addi	sp,sp,32
    800043d0:	8082                	ret

00000000800043d2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043d2:	7179                	addi	sp,sp,-48
    800043d4:	f406                	sd	ra,40(sp)
    800043d6:	f022                	sd	s0,32(sp)
    800043d8:	ec26                	sd	s1,24(sp)
    800043da:	e84a                	sd	s2,16(sp)
    800043dc:	1800                	addi	s0,sp,48
    800043de:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800043e0:	00850913          	addi	s2,a0,8
    800043e4:	854a                	mv	a0,s2
    800043e6:	859fc0ef          	jal	80000c3e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800043ea:	409c                	lw	a5,0(s1)
    800043ec:	ef81                	bnez	a5,80004404 <holdingsleep+0x32>
    800043ee:	4481                	li	s1,0
  release(&lk->lk);
    800043f0:	854a                	mv	a0,s2
    800043f2:	8d1fc0ef          	jal	80000cc2 <release>
  return r;
}
    800043f6:	8526                	mv	a0,s1
    800043f8:	70a2                	ld	ra,40(sp)
    800043fa:	7402                	ld	s0,32(sp)
    800043fc:	64e2                	ld	s1,24(sp)
    800043fe:	6942                	ld	s2,16(sp)
    80004400:	6145                	addi	sp,sp,48
    80004402:	8082                	ret
    80004404:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004406:	0284a983          	lw	s3,40(s1)
    8000440a:	d1efd0ef          	jal	80001928 <myproc>
    8000440e:	5904                	lw	s1,48(a0)
    80004410:	413484b3          	sub	s1,s1,s3
    80004414:	0014b493          	seqz	s1,s1
    80004418:	69a2                	ld	s3,8(sp)
    8000441a:	bfd9                	j	800043f0 <holdingsleep+0x1e>

000000008000441c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000441c:	1141                	addi	sp,sp,-16
    8000441e:	e406                	sd	ra,8(sp)
    80004420:	e022                	sd	s0,0(sp)
    80004422:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004424:	00003597          	auipc	a1,0x3
    80004428:	27458593          	addi	a1,a1,628 # 80007698 <etext+0x698>
    8000442c:	0001c517          	auipc	a0,0x1c
    80004430:	a8c50513          	addi	a0,a0,-1396 # 8001feb8 <ftable>
    80004434:	f8afc0ef          	jal	80000bbe <initlock>
}
    80004438:	60a2                	ld	ra,8(sp)
    8000443a:	6402                	ld	s0,0(sp)
    8000443c:	0141                	addi	sp,sp,16
    8000443e:	8082                	ret

0000000080004440 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80004440:	1101                	addi	sp,sp,-32
    80004442:	ec06                	sd	ra,24(sp)
    80004444:	e822                	sd	s0,16(sp)
    80004446:	e426                	sd	s1,8(sp)
    80004448:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000444a:	0001c517          	auipc	a0,0x1c
    8000444e:	a6e50513          	addi	a0,a0,-1426 # 8001feb8 <ftable>
    80004452:	fecfc0ef          	jal	80000c3e <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004456:	0001c497          	auipc	s1,0x1c
    8000445a:	a7a48493          	addi	s1,s1,-1414 # 8001fed0 <ftable+0x18>
    8000445e:	0001d717          	auipc	a4,0x1d
    80004462:	a1270713          	addi	a4,a4,-1518 # 80020e70 <disk>
    if (f->ref == 0) {
    80004466:	40dc                	lw	a5,4(s1)
    80004468:	cf89                	beqz	a5,80004482 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    8000446a:	02848493          	addi	s1,s1,40
    8000446e:	fee49ce3          	bne	s1,a4,80004466 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004472:	0001c517          	auipc	a0,0x1c
    80004476:	a4650513          	addi	a0,a0,-1466 # 8001feb8 <ftable>
    8000447a:	849fc0ef          	jal	80000cc2 <release>
  return 0;
    8000447e:	4481                	li	s1,0
    80004480:	a809                	j	80004492 <filealloc+0x52>
      f->ref = 1;
    80004482:	4785                	li	a5,1
    80004484:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004486:	0001c517          	auipc	a0,0x1c
    8000448a:	a3250513          	addi	a0,a0,-1486 # 8001feb8 <ftable>
    8000448e:	835fc0ef          	jal	80000cc2 <release>
}
    80004492:	8526                	mv	a0,s1
    80004494:	60e2                	ld	ra,24(sp)
    80004496:	6442                	ld	s0,16(sp)
    80004498:	64a2                	ld	s1,8(sp)
    8000449a:	6105                	addi	sp,sp,32
    8000449c:	8082                	ret

000000008000449e <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8000449e:	1101                	addi	sp,sp,-32
    800044a0:	ec06                	sd	ra,24(sp)
    800044a2:	e822                	sd	s0,16(sp)
    800044a4:	e426                	sd	s1,8(sp)
    800044a6:	1000                	addi	s0,sp,32
    800044a8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800044aa:	0001c517          	auipc	a0,0x1c
    800044ae:	a0e50513          	addi	a0,a0,-1522 # 8001feb8 <ftable>
    800044b2:	f8cfc0ef          	jal	80000c3e <acquire>
  if (f->ref < 1)
    800044b6:	40dc                	lw	a5,4(s1)
    800044b8:	02f05063          	blez	a5,800044d8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800044bc:	2785                	addiw	a5,a5,1
    800044be:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044c0:	0001c517          	auipc	a0,0x1c
    800044c4:	9f850513          	addi	a0,a0,-1544 # 8001feb8 <ftable>
    800044c8:	ffafc0ef          	jal	80000cc2 <release>
  return f;
}
    800044cc:	8526                	mv	a0,s1
    800044ce:	60e2                	ld	ra,24(sp)
    800044d0:	6442                	ld	s0,16(sp)
    800044d2:	64a2                	ld	s1,8(sp)
    800044d4:	6105                	addi	sp,sp,32
    800044d6:	8082                	ret
    panic("filedup");
    800044d8:	00003517          	auipc	a0,0x3
    800044dc:	1c850513          	addi	a0,a0,456 # 800076a0 <etext+0x6a0>
    800044e0:	b68fc0ef          	jal	80000848 <panic>

00000000800044e4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044e4:	7139                	addi	sp,sp,-64
    800044e6:	fc06                	sd	ra,56(sp)
    800044e8:	f822                	sd	s0,48(sp)
    800044ea:	f426                	sd	s1,40(sp)
    800044ec:	0080                	addi	s0,sp,64
    800044ee:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044f0:	0001c517          	auipc	a0,0x1c
    800044f4:	9c850513          	addi	a0,a0,-1592 # 8001feb8 <ftable>
    800044f8:	f46fc0ef          	jal	80000c3e <acquire>
  if (f->ref < 1)
    800044fc:	40dc                	lw	a5,4(s1)
    800044fe:	04f05a63          	blez	a5,80004552 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    80004502:	37fd                	addiw	a5,a5,-1
    80004504:	c0dc                	sw	a5,4(s1)
    80004506:	06f04063          	bgtz	a5,80004566 <fileclose+0x82>
    8000450a:	f04a                	sd	s2,32(sp)
    8000450c:	ec4e                	sd	s3,24(sp)
    8000450e:	e852                	sd	s4,16(sp)
    80004510:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004512:	0004a903          	lw	s2,0(s1)
    80004516:	0094c783          	lbu	a5,9(s1)
    8000451a:	89be                	mv	s3,a5
    8000451c:	689c                	ld	a5,16(s1)
    8000451e:	8a3e                	mv	s4,a5
    80004520:	6c9c                	ld	a5,24(s1)
    80004522:	8abe                	mv	s5,a5
  f->ref = 0;
    80004524:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004528:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000452c:	0001c517          	auipc	a0,0x1c
    80004530:	98c50513          	addi	a0,a0,-1652 # 8001feb8 <ftable>
    80004534:	f8efc0ef          	jal	80000cc2 <release>

  if (ff.type == FD_PIPE) {
    80004538:	4785                	li	a5,1
    8000453a:	04f90163          	beq	s2,a5,8000457c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000453e:	ffe9079b          	addiw	a5,s2,-2
    80004542:	4705                	li	a4,1
    80004544:	04f77563          	bgeu	a4,a5,8000458e <fileclose+0xaa>
    80004548:	7902                	ld	s2,32(sp)
    8000454a:	69e2                	ld	s3,24(sp)
    8000454c:	6a42                	ld	s4,16(sp)
    8000454e:	6aa2                	ld	s5,8(sp)
    80004550:	a00d                	j	80004572 <fileclose+0x8e>
    80004552:	f04a                	sd	s2,32(sp)
    80004554:	ec4e                	sd	s3,24(sp)
    80004556:	e852                	sd	s4,16(sp)
    80004558:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000455a:	00003517          	auipc	a0,0x3
    8000455e:	14e50513          	addi	a0,a0,334 # 800076a8 <etext+0x6a8>
    80004562:	ae6fc0ef          	jal	80000848 <panic>
    release(&ftable.lock);
    80004566:	0001c517          	auipc	a0,0x1c
    8000456a:	95250513          	addi	a0,a0,-1710 # 8001feb8 <ftable>
    8000456e:	f54fc0ef          	jal	80000cc2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004572:	70e2                	ld	ra,56(sp)
    80004574:	7442                	ld	s0,48(sp)
    80004576:	74a2                	ld	s1,40(sp)
    80004578:	6121                	addi	sp,sp,64
    8000457a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000457c:	85ce                	mv	a1,s3
    8000457e:	8552                	mv	a0,s4
    80004580:	398000ef          	jal	80004918 <pipeclose>
    80004584:	7902                	ld	s2,32(sp)
    80004586:	69e2                	ld	s3,24(sp)
    80004588:	6a42                	ld	s4,16(sp)
    8000458a:	6aa2                	ld	s5,8(sp)
    8000458c:	b7dd                	j	80004572 <fileclose+0x8e>
    begin_op();
    8000458e:	aa1ff0ef          	jal	8000402e <begin_op>
    iput(ff.ip);
    80004592:	8556                	mv	a0,s5
    80004594:	9aaff0ef          	jal	8000373e <iput>
    end_op();
    80004598:	b23ff0ef          	jal	800040ba <end_op>
    8000459c:	7902                	ld	s2,32(sp)
    8000459e:	69e2                	ld	s3,24(sp)
    800045a0:	6a42                	ld	s4,16(sp)
    800045a2:	6aa2                	ld	s5,8(sp)
    800045a4:	b7f9                	j	80004572 <fileclose+0x8e>

00000000800045a6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800045a6:	715d                	addi	sp,sp,-80
    800045a8:	e486                	sd	ra,72(sp)
    800045aa:	e0a2                	sd	s0,64(sp)
    800045ac:	fc26                	sd	s1,56(sp)
    800045ae:	f052                	sd	s4,32(sp)
    800045b0:	0880                	addi	s0,sp,80
    800045b2:	84aa                	mv	s1,a0
    800045b4:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800045b6:	b72fd0ef          	jal	80001928 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    800045ba:	409c                	lw	a5,0(s1)
    800045bc:	37f9                	addiw	a5,a5,-2
    800045be:	4705                	li	a4,1
    800045c0:	04f76463          	bltu	a4,a5,80004608 <filestat+0x62>
    800045c4:	f84a                	sd	s2,48(sp)
    800045c6:	f44e                	sd	s3,40(sp)
    800045c8:	892a                	mv	s2,a0
    ilock(f->ip);
    800045ca:	6c88                	ld	a0,24(s1)
    800045cc:	ff1fe0ef          	jal	800035bc <ilock>
    stati(f->ip, &st);
    800045d0:	fb840993          	addi	s3,s0,-72
    800045d4:	85ce                	mv	a1,s3
    800045d6:	6c88                	ld	a0,24(s1)
    800045d8:	b90ff0ef          	jal	80003968 <stati>
    iunlock(f->ip);
    800045dc:	6c88                	ld	a0,24(s1)
    800045de:	88cff0ef          	jal	8000366a <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    800045e2:	4761                	li	a4,24
    800045e4:	86ce                	mv	a3,s3
    800045e6:	8652                	mv	a2,s4
    800045e8:	04893583          	ld	a1,72(s2)
    800045ec:	05093503          	ld	a0,80(s2)
    800045f0:	f83fc0ef          	jal	80001572 <copyout>
    800045f4:	41f5551b          	sraiw	a0,a0,0x1f
    800045f8:	7942                	ld	s2,48(sp)
    800045fa:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800045fc:	60a6                	ld	ra,72(sp)
    800045fe:	6406                	ld	s0,64(sp)
    80004600:	74e2                	ld	s1,56(sp)
    80004602:	7a02                	ld	s4,32(sp)
    80004604:	6161                	addi	sp,sp,80
    80004606:	8082                	ret
  return -1;
    80004608:	557d                	li	a0,-1
    8000460a:	bfcd                	j	800045fc <filestat+0x56>

000000008000460c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000460c:	7179                	addi	sp,sp,-48
    8000460e:	f406                	sd	ra,40(sp)
    80004610:	f022                	sd	s0,32(sp)
    80004612:	e84a                	sd	s2,16(sp)
    80004614:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    80004616:	00854783          	lbu	a5,8(a0)
    8000461a:	0017b793          	seqz	a5,a5
    8000461e:	01f6571b          	srliw	a4,a2,0x1f
    80004622:	8fd9                	or	a5,a5,a4
    80004624:	e3c5                	bnez	a5,800046c4 <fileread+0xb8>
    80004626:	ec26                	sd	s1,24(sp)
    80004628:	e44e                	sd	s3,8(sp)
    8000462a:	84aa                	mv	s1,a0
    8000462c:	892e                	mv	s2,a1
    8000462e:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    80004630:	411c                	lw	a5,0(a0)
    80004632:	4705                	li	a4,1
    80004634:	04e78363          	beq	a5,a4,8000467a <fileread+0x6e>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004638:	470d                	li	a4,3
    8000463a:	04e78763          	beq	a5,a4,80004688 <fileread+0x7c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000463e:	4709                	li	a4,2
    80004640:	06e79a63          	bne	a5,a4,800046b4 <fileread+0xa8>
    ilock(f->ip);
    80004644:	6d08                	ld	a0,24(a0)
    80004646:	f77fe0ef          	jal	800035bc <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000464a:	874e                	mv	a4,s3
    8000464c:	5094                	lw	a3,32(s1)
    8000464e:	864a                	mv	a2,s2
    80004650:	4585                	li	a1,1
    80004652:	6c88                	ld	a0,24(s1)
    80004654:	b42ff0ef          	jal	80003996 <readi>
    80004658:	892a                	mv	s2,a0
    8000465a:	00a05563          	blez	a0,80004664 <fileread+0x58>
      f->off += r;
    8000465e:	509c                	lw	a5,32(s1)
    80004660:	9fa9                	addw	a5,a5,a0
    80004662:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004664:	6c88                	ld	a0,24(s1)
    80004666:	804ff0ef          	jal	8000366a <iunlock>
    8000466a:	64e2                	ld	s1,24(sp)
    8000466c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000466e:	854a                	mv	a0,s2
    80004670:	70a2                	ld	ra,40(sp)
    80004672:	7402                	ld	s0,32(sp)
    80004674:	6942                	ld	s2,16(sp)
    80004676:	6145                	addi	sp,sp,48
    80004678:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000467a:	6908                	ld	a0,16(a0)
    8000467c:	416000ef          	jal	80004a92 <piperead>
    80004680:	892a                	mv	s2,a0
    80004682:	64e2                	ld	s1,24(sp)
    80004684:	69a2                	ld	s3,8(sp)
    80004686:	b7e5                	j	8000466e <fileread+0x62>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004688:	02451783          	lh	a5,36(a0)
    8000468c:	03079693          	slli	a3,a5,0x30
    80004690:	92c1                	srli	a3,a3,0x30
    80004692:	4725                	li	a4,9
    80004694:	02d76663          	bltu	a4,a3,800046c0 <fileread+0xb4>
    80004698:	0792                	slli	a5,a5,0x4
    8000469a:	0001b717          	auipc	a4,0x1b
    8000469e:	77e70713          	addi	a4,a4,1918 # 8001fe18 <devsw>
    800046a2:	97ba                	add	a5,a5,a4
    800046a4:	639c                	ld	a5,0(a5)
    800046a6:	c395                	beqz	a5,800046ca <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800046a8:	4505                	li	a0,1
    800046aa:	9782                	jalr	a5
    800046ac:	892a                	mv	s2,a0
    800046ae:	64e2                	ld	s1,24(sp)
    800046b0:	69a2                	ld	s3,8(sp)
    800046b2:	bf75                	j	8000466e <fileread+0x62>
    panic("fileread");
    800046b4:	00003517          	auipc	a0,0x3
    800046b8:	00450513          	addi	a0,a0,4 # 800076b8 <etext+0x6b8>
    800046bc:	98cfc0ef          	jal	80000848 <panic>
    800046c0:	64e2                	ld	s1,24(sp)
    800046c2:	69a2                	ld	s3,8(sp)
    return -1;
    800046c4:	57fd                	li	a5,-1
    800046c6:	893e                	mv	s2,a5
    800046c8:	b75d                	j	8000466e <fileread+0x62>
    800046ca:	64e2                	ld	s1,24(sp)
    800046cc:	69a2                	ld	s3,8(sp)
    800046ce:	bfdd                	j	800046c4 <fileread+0xb8>

00000000800046d0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    800046d0:	00954783          	lbu	a5,9(a0)
    800046d4:	0017b793          	seqz	a5,a5
    800046d8:	01f6571b          	srliw	a4,a2,0x1f
    800046dc:	8fd9                	or	a5,a5,a4
    800046de:	12079363          	bnez	a5,80004804 <filewrite+0x134>
{
    800046e2:	711d                	addi	sp,sp,-96
    800046e4:	ec86                	sd	ra,88(sp)
    800046e6:	e8a2                	sd	s0,80(sp)
    800046e8:	e0ca                	sd	s2,64(sp)
    800046ea:	f456                	sd	s5,40(sp)
    800046ec:	f05a                	sd	s6,32(sp)
    800046ee:	1080                	addi	s0,sp,96
    800046f0:	892a                	mv	s2,a0
    800046f2:	8b2e                	mv	s6,a1
    800046f4:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    800046f6:	411c                	lw	a5,0(a0)
    800046f8:	4705                	li	a4,1
    800046fa:	02e78a63          	beq	a5,a4,8000472e <filewrite+0x5e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800046fe:	470d                	li	a4,3
    80004700:	02e78b63          	beq	a5,a4,80004736 <filewrite+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004704:	4709                	li	a4,2
    80004706:	0ce79763          	bne	a5,a4,800047d4 <filewrite+0x104>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    8000470a:	0ec05363          	blez	a2,800047f0 <filewrite+0x120>
    8000470e:	e4a6                	sd	s1,72(sp)
    80004710:	fc4e                	sd	s3,56(sp)
    80004712:	f852                	sd	s4,48(sp)
    80004714:	ec5e                	sd	s7,24(sp)
    80004716:	e862                	sd	s8,16(sp)
    80004718:	e466                	sd	s9,8(sp)
    int i = 0;
    8000471a:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    8000471c:	6b85                	lui	s7,0x1
    8000471e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004722:	6785                	lui	a5,0x1
    80004724:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004728:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000472a:	4c05                	li	s8,1
    8000472c:	a8ad                	j	800047a6 <filewrite+0xd6>
    ret = pipewrite(f->pipe, addr, n);
    8000472e:	6908                	ld	a0,16(a0)
    80004730:	246000ef          	jal	80004976 <pipewrite>
    80004734:	a849                	j	800047c6 <filewrite+0xf6>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004736:	02451783          	lh	a5,36(a0)
    8000473a:	03079693          	slli	a3,a5,0x30
    8000473e:	92c1                	srli	a3,a3,0x30
    80004740:	4725                	li	a4,9
    80004742:	0ad76563          	bltu	a4,a3,800047ec <filewrite+0x11c>
    80004746:	0792                	slli	a5,a5,0x4
    80004748:	0001b717          	auipc	a4,0x1b
    8000474c:	6d070713          	addi	a4,a4,1744 # 8001fe18 <devsw>
    80004750:	97ba                	add	a5,a5,a4
    80004752:	679c                	ld	a5,8(a5)
    80004754:	cfc1                	beqz	a5,800047ec <filewrite+0x11c>
    ret = devsw[f->major].write(1, addr, n);
    80004756:	4505                	li	a0,1
    80004758:	9782                	jalr	a5
    8000475a:	a0b5                	j	800047c6 <filewrite+0xf6>
      if (n1 > max)
    8000475c:	2981                	sext.w	s3,s3
      begin_op();
    8000475e:	8d1ff0ef          	jal	8000402e <begin_op>
      ilock(f->ip);
    80004762:	01893503          	ld	a0,24(s2)
    80004766:	e57fe0ef          	jal	800035bc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000476a:	874e                	mv	a4,s3
    8000476c:	02092683          	lw	a3,32(s2)
    80004770:	016a0633          	add	a2,s4,s6
    80004774:	85e2                	mv	a1,s8
    80004776:	01893503          	ld	a0,24(s2)
    8000477a:	b0eff0ef          	jal	80003a88 <writei>
    8000477e:	84aa                	mv	s1,a0
    80004780:	00a05763          	blez	a0,8000478e <filewrite+0xbe>
        f->off += r;
    80004784:	02092783          	lw	a5,32(s2)
    80004788:	9fa9                	addw	a5,a5,a0
    8000478a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000478e:	01893503          	ld	a0,24(s2)
    80004792:	ed9fe0ef          	jal	8000366a <iunlock>
      end_op();
    80004796:	925ff0ef          	jal	800040ba <end_op>

      if (r != n1) {
    8000479a:	00999d63          	bne	s3,s1,800047b4 <filewrite+0xe4>
        // error from writei
        break;
      }
      i += r;
    8000479e:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    800047a2:	015a5963          	bge	s4,s5,800047b4 <filewrite+0xe4>
      int n1 = n - i;
    800047a6:	414a87bb          	subw	a5,s5,s4
    800047aa:	89be                	mv	s3,a5
      if (n1 > max)
    800047ac:	fafbd8e3          	bge	s7,a5,8000475c <filewrite+0x8c>
    800047b0:	89e6                	mv	s3,s9
    800047b2:	b76d                	j	8000475c <filewrite+0x8c>
    }
    ret = (i == n ? n : -1);
    800047b4:	054a9063          	bne	s5,s4,800047f4 <filewrite+0x124>
    800047b8:	8556                	mv	a0,s5
    800047ba:	64a6                	ld	s1,72(sp)
    800047bc:	79e2                	ld	s3,56(sp)
    800047be:	7a42                	ld	s4,48(sp)
    800047c0:	6be2                	ld	s7,24(sp)
    800047c2:	6c42                	ld	s8,16(sp)
    800047c4:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047c6:	60e6                	ld	ra,88(sp)
    800047c8:	6446                	ld	s0,80(sp)
    800047ca:	6906                	ld	s2,64(sp)
    800047cc:	7aa2                	ld	s5,40(sp)
    800047ce:	7b02                	ld	s6,32(sp)
    800047d0:	6125                	addi	sp,sp,96
    800047d2:	8082                	ret
    800047d4:	e4a6                	sd	s1,72(sp)
    800047d6:	fc4e                	sd	s3,56(sp)
    800047d8:	f852                	sd	s4,48(sp)
    800047da:	ec5e                	sd	s7,24(sp)
    800047dc:	e862                	sd	s8,16(sp)
    800047de:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800047e0:	00003517          	auipc	a0,0x3
    800047e4:	ee850513          	addi	a0,a0,-280 # 800076c8 <etext+0x6c8>
    800047e8:	860fc0ef          	jal	80000848 <panic>
    return -1;
    800047ec:	557d                	li	a0,-1
    800047ee:	bfe1                	j	800047c6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800047f0:	8532                	mv	a0,a2
    800047f2:	bfd1                	j	800047c6 <filewrite+0xf6>
    800047f4:	557d                	li	a0,-1
    800047f6:	64a6                	ld	s1,72(sp)
    800047f8:	79e2                	ld	s3,56(sp)
    800047fa:	7a42                	ld	s4,48(sp)
    800047fc:	6be2                	ld	s7,24(sp)
    800047fe:	6c42                	ld	s8,16(sp)
    80004800:	6ca2                	ld	s9,8(sp)
    80004802:	b7d1                	j	800047c6 <filewrite+0xf6>
    return -1;
    80004804:	557d                	li	a0,-1
}
    80004806:	8082                	ret

0000000080004808 <nopenfile>:


uint64
nopenfile(void)
{
    80004808:	1101                	addi	sp,sp,-32
    8000480a:	ec06                	sd	ra,24(sp)
    8000480c:	e822                	sd	s0,16(sp)
    8000480e:	e426                	sd	s1,8(sp)
    80004810:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 count = 0;

  acquire(&ftable.lock);
    80004812:	0001b517          	auipc	a0,0x1b
    80004816:	6a650513          	addi	a0,a0,1702 # 8001feb8 <ftable>
    8000481a:	c24fc0ef          	jal	80000c3e <acquire>
  uint64 count = 0;
    8000481e:	4481                	li	s1,0
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004820:	0001b797          	auipc	a5,0x1b
    80004824:	6b078793          	addi	a5,a5,1712 # 8001fed0 <ftable+0x18>
    80004828:	0001c697          	auipc	a3,0x1c
    8000482c:	64868693          	addi	a3,a3,1608 # 80020e70 <disk>
    if(f->ref > 0)
    80004830:	43d8                	lw	a4,4(a5)
      count++;
    80004832:	00e02733          	sgtz	a4,a4
    80004836:	94ba                	add	s1,s1,a4
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004838:	02878793          	addi	a5,a5,40
    8000483c:	fed79ae3          	bne	a5,a3,80004830 <nopenfile+0x28>
  }
  release(&ftable.lock);
    80004840:	0001b517          	auipc	a0,0x1b
    80004844:	67850513          	addi	a0,a0,1656 # 8001feb8 <ftable>
    80004848:	c7afc0ef          	jal	80000cc2 <release>

  return count;
}
    8000484c:	8526                	mv	a0,s1
    8000484e:	60e2                	ld	ra,24(sp)
    80004850:	6442                	ld	s0,16(sp)
    80004852:	64a2                	ld	s1,8(sp)
    80004854:	6105                	addi	sp,sp,32
    80004856:	8082                	ret

0000000080004858 <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004858:	7179                	addi	sp,sp,-48
    8000485a:	f406                	sd	ra,40(sp)
    8000485c:	f022                	sd	s0,32(sp)
    8000485e:	ec26                	sd	s1,24(sp)
    80004860:	e052                	sd	s4,0(sp)
    80004862:	1800                	addi	s0,sp,48
    80004864:	84aa                	mv	s1,a0
    80004866:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004868:	0005b023          	sd	zero,0(a1)
    8000486c:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004870:	bd1ff0ef          	jal	80004440 <filealloc>
    80004874:	e088                	sd	a0,0(s1)
    80004876:	c549                	beqz	a0,80004900 <pipealloc+0xa8>
    80004878:	bc9ff0ef          	jal	80004440 <filealloc>
    8000487c:	00aa3023          	sd	a0,0(s4)
    80004880:	cd25                	beqz	a0,800048f8 <pipealloc+0xa0>
    80004882:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004884:	a9afc0ef          	jal	80000b1e <kalloc>
    80004888:	892a                	mv	s2,a0
    8000488a:	c12d                	beqz	a0,800048ec <pipealloc+0x94>
    8000488c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000488e:	4985                	li	s3,1
    80004890:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004894:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004898:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000489c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800048a0:	00003597          	auipc	a1,0x3
    800048a4:	b8858593          	addi	a1,a1,-1144 # 80007428 <etext+0x428>
    800048a8:	b16fc0ef          	jal	80000bbe <initlock>
  (*f0)->type = FD_PIPE;
    800048ac:	609c                	ld	a5,0(s1)
    800048ae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800048b2:	609c                	ld	a5,0(s1)
    800048b4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800048b8:	609c                	ld	a5,0(s1)
    800048ba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800048be:	609c                	ld	a5,0(s1)
    800048c0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800048c4:	000a3783          	ld	a5,0(s4)
    800048c8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800048cc:	000a3783          	ld	a5,0(s4)
    800048d0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800048d4:	000a3783          	ld	a5,0(s4)
    800048d8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800048dc:	000a3783          	ld	a5,0(s4)
    800048e0:	0127b823          	sd	s2,16(a5)
  return 0;
    800048e4:	4501                	li	a0,0
    800048e6:	6942                	ld	s2,16(sp)
    800048e8:	69a2                	ld	s3,8(sp)
    800048ea:	a00d                	j	8000490c <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    800048ec:	6088                	ld	a0,0(s1)
    800048ee:	c119                	beqz	a0,800048f4 <pipealloc+0x9c>
    800048f0:	6942                	ld	s2,16(sp)
    800048f2:	a029                	j	800048fc <pipealloc+0xa4>
    800048f4:	6942                	ld	s2,16(sp)
    800048f6:	a029                	j	80004900 <pipealloc+0xa8>
    800048f8:	6088                	ld	a0,0(s1)
    800048fa:	c901                	beqz	a0,8000490a <pipealloc+0xb2>
    fileclose(*f0);
    800048fc:	be9ff0ef          	jal	800044e4 <fileclose>
  if (*f1)
    80004900:	000a3503          	ld	a0,0(s4)
    80004904:	c119                	beqz	a0,8000490a <pipealloc+0xb2>
    fileclose(*f1);
    80004906:	bdfff0ef          	jal	800044e4 <fileclose>
  return -1;
    8000490a:	557d                	li	a0,-1
}
    8000490c:	70a2                	ld	ra,40(sp)
    8000490e:	7402                	ld	s0,32(sp)
    80004910:	64e2                	ld	s1,24(sp)
    80004912:	6a02                	ld	s4,0(sp)
    80004914:	6145                	addi	sp,sp,48
    80004916:	8082                	ret

0000000080004918 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004918:	1101                	addi	sp,sp,-32
    8000491a:	ec06                	sd	ra,24(sp)
    8000491c:	e822                	sd	s0,16(sp)
    8000491e:	e426                	sd	s1,8(sp)
    80004920:	e04a                	sd	s2,0(sp)
    80004922:	1000                	addi	s0,sp,32
    80004924:	84aa                	mv	s1,a0
    80004926:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004928:	b16fc0ef          	jal	80000c3e <acquire>
  if (writable) {
    8000492c:	02090763          	beqz	s2,8000495a <pipeclose+0x42>
    pi->writeopen = 0;
    80004930:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004934:	21848513          	addi	a0,s1,536
    80004938:	e64fd0ef          	jal	80001f9c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    8000493c:	2204a783          	lw	a5,544(s1)
    80004940:	e781                	bnez	a5,80004948 <pipeclose+0x30>
    80004942:	2244a783          	lw	a5,548(s1)
    80004946:	c38d                	beqz	a5,80004968 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    80004948:	8526                	mv	a0,s1
    8000494a:	b78fc0ef          	jal	80000cc2 <release>
}
    8000494e:	60e2                	ld	ra,24(sp)
    80004950:	6442                	ld	s0,16(sp)
    80004952:	64a2                	ld	s1,8(sp)
    80004954:	6902                	ld	s2,0(sp)
    80004956:	6105                	addi	sp,sp,32
    80004958:	8082                	ret
    pi->readopen = 0;
    8000495a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000495e:	21c48513          	addi	a0,s1,540
    80004962:	e3afd0ef          	jal	80001f9c <wakeup>
    80004966:	bfd9                	j	8000493c <pipeclose+0x24>
    release(&pi->lock);
    80004968:	8526                	mv	a0,s1
    8000496a:	b58fc0ef          	jal	80000cc2 <release>
    kfree((char *)pi);
    8000496e:	8526                	mv	a0,s1
    80004970:	8c6fc0ef          	jal	80000a36 <kfree>
    80004974:	bfe9                	j	8000494e <pipeclose+0x36>

0000000080004976 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004976:	7159                	addi	sp,sp,-112
    80004978:	f486                	sd	ra,104(sp)
    8000497a:	f0a2                	sd	s0,96(sp)
    8000497c:	eca6                	sd	s1,88(sp)
    8000497e:	e8ca                	sd	s2,80(sp)
    80004980:	e4ce                	sd	s3,72(sp)
    80004982:	e0d2                	sd	s4,64(sp)
    80004984:	fc56                	sd	s5,56(sp)
    80004986:	1880                	addi	s0,sp,112
    80004988:	84aa                	mv	s1,a0
    8000498a:	8aae                	mv	s5,a1
    8000498c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000498e:	f9bfc0ef          	jal	80001928 <myproc>
    80004992:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004994:	8526                	mv	a0,s1
    80004996:	aa8fc0ef          	jal	80000c3e <acquire>
  while (i < n) {
    8000499a:	0f405a63          	blez	s4,80004a8e <pipewrite+0x118>
    8000499e:	f85a                	sd	s6,48(sp)
    800049a0:	f45e                	sd	s7,40(sp)
    800049a2:	f062                	sd	s8,32(sp)
    800049a4:	ec66                	sd	s9,24(sp)
    800049a6:	e86a                	sd	s10,16(sp)
  int i = 0;
    800049a8:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800049aa:	f9f40c13          	addi	s8,s0,-97
    800049ae:	4b85                	li	s7,1
    800049b0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800049b2:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    800049b6:	21c48c93          	addi	s9,s1,540
    800049ba:	a0a1                	j	80004a02 <pipewrite+0x8c>
      release(&pi->lock);
    800049bc:	8526                	mv	a0,s1
    800049be:	b04fc0ef          	jal	80000cc2 <release>
      return -1;
    800049c2:	597d                	li	s2,-1
    800049c4:	7b42                	ld	s6,48(sp)
    800049c6:	7ba2                	ld	s7,40(sp)
    800049c8:	7c02                	ld	s8,32(sp)
    800049ca:	6ce2                	ld	s9,24(sp)
    800049cc:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800049ce:	854a                	mv	a0,s2
    800049d0:	70a6                	ld	ra,104(sp)
    800049d2:	7406                	ld	s0,96(sp)
    800049d4:	64e6                	ld	s1,88(sp)
    800049d6:	6946                	ld	s2,80(sp)
    800049d8:	69a6                	ld	s3,72(sp)
    800049da:	6a06                	ld	s4,64(sp)
    800049dc:	7ae2                	ld	s5,56(sp)
    800049de:	6165                	addi	sp,sp,112
    800049e0:	8082                	ret
      wakeup(&pi->nread);
    800049e2:	856a                	mv	a0,s10
    800049e4:	db8fd0ef          	jal	80001f9c <wakeup>
      sleep_prepare(&pi->nwrite);
    800049e8:	8566                	mv	a0,s9
    800049ea:	d46fd0ef          	jal	80001f30 <sleep_prepare>
      release(&pi->lock);
    800049ee:	8526                	mv	a0,s1
    800049f0:	ad2fc0ef          	jal	80000cc2 <release>
      sleep();
    800049f4:	d78fd0ef          	jal	80001f6c <sleep>
      acquire(&pi->lock);
    800049f8:	8526                	mv	a0,s1
    800049fa:	a44fc0ef          	jal	80000c3e <acquire>
  while (i < n) {
    800049fe:	07495b63          	bge	s2,s4,80004a74 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80004a02:	2204a783          	lw	a5,544(s1)
    80004a06:	dbdd                	beqz	a5,800049bc <pipewrite+0x46>
    80004a08:	854e                	mv	a0,s3
    80004a0a:	f80fd0ef          	jal	8000218a <killed>
    80004a0e:	f55d                	bnez	a0,800049bc <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80004a10:	2184a783          	lw	a5,536(s1)
    80004a14:	21c4a703          	lw	a4,540(s1)
    80004a18:	2007879b          	addiw	a5,a5,512
    80004a1c:	fcf703e3          	beq	a4,a5,800049e2 <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004a20:	875e                	mv	a4,s7
    80004a22:	015906b3          	add	a3,s2,s5
    80004a26:	8662                	mv	a2,s8
    80004a28:	0489b583          	ld	a1,72(s3)
    80004a2c:	0509b503          	ld	a0,80(s3)
    80004a30:	c03fc0ef          	jal	80001632 <copyin>
    80004a34:	03650163          	beq	a0,s6,80004a56 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004a38:	21c4a783          	lw	a5,540(s1)
    80004a3c:	0017871b          	addiw	a4,a5,1
    80004a40:	20e4ae23          	sw	a4,540(s1)
    80004a44:	1ff7f793          	andi	a5,a5,511
    80004a48:	97a6                	add	a5,a5,s1
    80004a4a:	f9f44703          	lbu	a4,-97(s0)
    80004a4e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004a52:	2905                	addiw	s2,s2,1
    80004a54:	b76d                	j	800049fe <pipewrite+0x88>
        if (i == 0)
    80004a56:	00090863          	beqz	s2,80004a66 <pipewrite+0xf0>
    80004a5a:	7b42                	ld	s6,48(sp)
    80004a5c:	7ba2                	ld	s7,40(sp)
    80004a5e:	7c02                	ld	s8,32(sp)
    80004a60:	6ce2                	ld	s9,24(sp)
    80004a62:	6d42                	ld	s10,16(sp)
    80004a64:	a829                	j	80004a7e <pipewrite+0x108>
          i = -1;
    80004a66:	892a                	mv	s2,a0
        break;
    80004a68:	7b42                	ld	s6,48(sp)
    80004a6a:	7ba2                	ld	s7,40(sp)
    80004a6c:	7c02                	ld	s8,32(sp)
    80004a6e:	6ce2                	ld	s9,24(sp)
    80004a70:	6d42                	ld	s10,16(sp)
    80004a72:	a031                	j	80004a7e <pipewrite+0x108>
    80004a74:	7b42                	ld	s6,48(sp)
    80004a76:	7ba2                	ld	s7,40(sp)
    80004a78:	7c02                	ld	s8,32(sp)
    80004a7a:	6ce2                	ld	s9,24(sp)
    80004a7c:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004a7e:	21848513          	addi	a0,s1,536
    80004a82:	d1afd0ef          	jal	80001f9c <wakeup>
  release(&pi->lock);
    80004a86:	8526                	mv	a0,s1
    80004a88:	a3afc0ef          	jal	80000cc2 <release>
  return i;
    80004a8c:	b789                	j	800049ce <pipewrite+0x58>
  int i = 0;
    80004a8e:	4901                	li	s2,0
    80004a90:	b7fd                	j	80004a7e <pipewrite+0x108>

0000000080004a92 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a92:	711d                	addi	sp,sp,-96
    80004a94:	ec86                	sd	ra,88(sp)
    80004a96:	e8a2                	sd	s0,80(sp)
    80004a98:	e4a6                	sd	s1,72(sp)
    80004a9a:	e0ca                	sd	s2,64(sp)
    80004a9c:	fc4e                	sd	s3,56(sp)
    80004a9e:	f852                	sd	s4,48(sp)
    80004aa0:	f456                	sd	s5,40(sp)
    80004aa2:	1080                	addi	s0,sp,96
    80004aa4:	84aa                	mv	s1,a0
    80004aa6:	89ae                	mv	s3,a1
    80004aa8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004aaa:	e7ffc0ef          	jal	80001928 <myproc>
    80004aae:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	98cfc0ef          	jal	80000c3e <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004ab6:	2184a703          	lw	a4,536(s1)
    80004aba:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004abe:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004ac2:	02f71a63          	bne	a4,a5,80004af6 <piperead+0x64>
    80004ac6:	2244a783          	lw	a5,548(s1)
    80004aca:	c795                	beqz	a5,80004af6 <piperead+0x64>
    if (killed(pr)) {
    80004acc:	854a                	mv	a0,s2
    80004ace:	ebcfd0ef          	jal	8000218a <killed>
    80004ad2:	e149                	bnez	a0,80004b54 <piperead+0xc2>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004ad4:	8552                	mv	a0,s4
    80004ad6:	c5afd0ef          	jal	80001f30 <sleep_prepare>
    release(&pi->lock);
    80004ada:	8526                	mv	a0,s1
    80004adc:	9e6fc0ef          	jal	80000cc2 <release>
    sleep();
    80004ae0:	c8cfd0ef          	jal	80001f6c <sleep>
    acquire(&pi->lock);
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	958fc0ef          	jal	80000c3e <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004aea:	2184a703          	lw	a4,536(s1)
    80004aee:	21c4a783          	lw	a5,540(s1)
    80004af2:	fcf70ae3          	beq	a4,a5,80004ac6 <piperead+0x34>
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004af6:	07505a63          	blez	s5,80004b6a <piperead+0xd8>
    80004afa:	f05a                	sd	s6,32(sp)
    80004afc:	ec5e                	sd	s7,24(sp)
    80004afe:	e862                	sd	s8,16(sp)
    80004b00:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004b02:	faf40c13          	addi	s8,s0,-81
    80004b06:	4b85                	li	s7,1
    80004b08:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    80004b0a:	2184a783          	lw	a5,536(s1)
    80004b0e:	21c4a703          	lw	a4,540(s1)
    80004b12:	06f70363          	beq	a4,a5,80004b78 <piperead+0xe6>
    ch = pi->data[pi->nread % PIPESIZE];
    80004b16:	1ff7f793          	andi	a5,a5,511
    80004b1a:	97a6                	add	a5,a5,s1
    80004b1c:	0187c783          	lbu	a5,24(a5)
    80004b20:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004b24:	875e                	mv	a4,s7
    80004b26:	86e2                	mv	a3,s8
    80004b28:	864e                	mv	a2,s3
    80004b2a:	04893583          	ld	a1,72(s2)
    80004b2e:	05093503          	ld	a0,80(s2)
    80004b32:	a41fc0ef          	jal	80001572 <copyout>
    80004b36:	03650463          	beq	a0,s6,80004b5e <piperead+0xcc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004b3a:	2184a783          	lw	a5,536(s1)
    80004b3e:	2785                	addiw	a5,a5,1
    80004b40:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004b44:	2a05                	addiw	s4,s4,1
    80004b46:	0985                	addi	s3,s3,1
    80004b48:	fd4a91e3          	bne	s5,s4,80004b0a <piperead+0x78>
    80004b4c:	7b02                	ld	s6,32(sp)
    80004b4e:	6be2                	ld	s7,24(sp)
    80004b50:	6c42                	ld	s8,16(sp)
    80004b52:	a035                	j	80004b7e <piperead+0xec>
      release(&pi->lock);
    80004b54:	8526                	mv	a0,s1
    80004b56:	96cfc0ef          	jal	80000cc2 <release>
      return -1;
    80004b5a:	5a7d                	li	s4,-1
    80004b5c:	a805                	j	80004b8c <piperead+0xfa>
      if (i == 0)
    80004b5e:	000a0863          	beqz	s4,80004b6e <piperead+0xdc>
    80004b62:	7b02                	ld	s6,32(sp)
    80004b64:	6be2                	ld	s7,24(sp)
    80004b66:	6c42                	ld	s8,16(sp)
    80004b68:	a819                	j	80004b7e <piperead+0xec>
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004b6a:	4a01                	li	s4,0
    80004b6c:	a809                	j	80004b7e <piperead+0xec>
        i = -1;
    80004b6e:	8a2a                	mv	s4,a0
    80004b70:	7b02                	ld	s6,32(sp)
    80004b72:	6be2                	ld	s7,24(sp)
    80004b74:	6c42                	ld	s8,16(sp)
    80004b76:	a021                	j	80004b7e <piperead+0xec>
    80004b78:	7b02                	ld	s6,32(sp)
    80004b7a:	6be2                	ld	s7,24(sp)
    80004b7c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80004b7e:	21c48513          	addi	a0,s1,540
    80004b82:	c1afd0ef          	jal	80001f9c <wakeup>
  release(&pi->lock);
    80004b86:	8526                	mv	a0,s1
    80004b88:	93afc0ef          	jal	80000cc2 <release>
  return i;
}
    80004b8c:	8552                	mv	a0,s4
    80004b8e:	60e6                	ld	ra,88(sp)
    80004b90:	6446                	ld	s0,80(sp)
    80004b92:	64a6                	ld	s1,72(sp)
    80004b94:	6906                	ld	s2,64(sp)
    80004b96:	79e2                	ld	s3,56(sp)
    80004b98:	7a42                	ld	s4,48(sp)
    80004b9a:	7aa2                	ld	s5,40(sp)
    80004b9c:	6125                	addi	sp,sp,96
    80004b9e:	8082                	ret

0000000080004ba0 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80004ba0:	1141                	addi	sp,sp,-16
    80004ba2:	e406                	sd	ra,8(sp)
    80004ba4:	e022                	sd	s0,0(sp)
    80004ba6:	0800                	addi	s0,sp,16
    80004ba8:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004baa:	0035151b          	slliw	a0,a0,0x3
    80004bae:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    80004bb0:	8b89                	andi	a5,a5,2
    80004bb2:	c399                	beqz	a5,80004bb8 <flags2perm+0x18>
    perm |= PTE_W;
    80004bb4:	00456513          	ori	a0,a0,4
  return perm;
}
    80004bb8:	60a2                	ld	ra,8(sp)
    80004bba:	6402                	ld	s0,0(sp)
    80004bbc:	0141                	addi	sp,sp,16
    80004bbe:	8082                	ret

0000000080004bc0 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004bc0:	df010113          	addi	sp,sp,-528
    80004bc4:	20113423          	sd	ra,520(sp)
    80004bc8:	20813023          	sd	s0,512(sp)
    80004bcc:	ffa6                	sd	s1,504(sp)
    80004bce:	fbca                	sd	s2,496(sp)
    80004bd0:	0c00                	addi	s0,sp,528
    80004bd2:	892a                	mv	s2,a0
    80004bd4:	e0a43023          	sd	a0,-512(s0)
    80004bd8:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004bdc:	d4dfc0ef          	jal	80001928 <myproc>
    80004be0:	84aa                	mv	s1,a0

  begin_op();
    80004be2:	c4cff0ef          	jal	8000402e <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004be6:	854a                	mv	a0,s2
    80004be8:	a68ff0ef          	jal	80003e50 <namei>
    80004bec:	c931                	beqz	a0,80004c40 <kexec+0x80>
    80004bee:	f3d2                	sd	s4,480(sp)
    80004bf0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004bf2:	9cbfe0ef          	jal	800035bc <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004bf6:	04000713          	li	a4,64
    80004bfa:	4681                	li	a3,0
    80004bfc:	e5040613          	addi	a2,s0,-432
    80004c00:	4581                	li	a1,0
    80004c02:	8552                	mv	a0,s4
    80004c04:	d93fe0ef          	jal	80003996 <readi>
    80004c08:	04000793          	li	a5,64
    80004c0c:	00f51a63          	bne	a0,a5,80004c20 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004c10:	e5042703          	lw	a4,-432(s0)
    80004c14:	464c47b7          	lui	a5,0x464c4
    80004c18:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c1c:	02f70563          	beq	a4,a5,80004c46 <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004c20:	8552                	mv	a0,s4
    80004c22:	beffe0ef          	jal	80003810 <iunlockput>
    end_op();
    80004c26:	c94ff0ef          	jal	800040ba <end_op>
    80004c2a:	7a1e                	ld	s4,480(sp)
    return -1;
    80004c2c:	557d                	li	a0,-1
  }
  return -1;
}
    80004c2e:	20813083          	ld	ra,520(sp)
    80004c32:	20013403          	ld	s0,512(sp)
    80004c36:	74fe                	ld	s1,504(sp)
    80004c38:	795e                	ld	s2,496(sp)
    80004c3a:	21010113          	addi	sp,sp,528
    80004c3e:	8082                	ret
    end_op();
    80004c40:	c7aff0ef          	jal	800040ba <end_op>
    return -1;
    80004c44:	b7e5                	j	80004c2c <kexec+0x6c>
    80004c46:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004c48:	8526                	mv	a0,s1
    80004c4a:	de5fc0ef          	jal	80001a2e <proc_pagetable>
    80004c4e:	8b2a                	mv	s6,a0
    80004c50:	26050263          	beqz	a0,80004eb4 <kexec+0x2f4>
    80004c54:	f7ce                	sd	s3,488(sp)
    80004c56:	efd6                	sd	s5,472(sp)
    80004c58:	e7de                	sd	s7,456(sp)
    80004c5a:	e3e2                	sd	s8,448(sp)
    80004c5c:	ff66                	sd	s9,440(sp)
    80004c5e:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004c60:	e8845783          	lhu	a5,-376(s0)
    80004c64:	12078763          	beqz	a5,80004d92 <kexec+0x1d2>
    80004c68:	f76e                	sd	s11,424(sp)
    80004c6a:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004c6e:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004c70:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c72:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004c76:	6c85                	lui	s9,0x1
    80004c78:	6a85                	lui	s5,0x1
    80004c7a:	a085                	j	80004cda <kexec+0x11a>
      panic("loadseg: address should exist");
    80004c7c:	00003517          	auipc	a0,0x3
    80004c80:	a5c50513          	addi	a0,a0,-1444 # 800076d8 <etext+0x6d8>
    80004c84:	bc5fb0ef          	jal	80000848 <panic>
    if (sz - i < PGSIZE)
    80004c88:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004c8a:	874a                	mv	a4,s2
    80004c8c:	009b86bb          	addw	a3,s7,s1
    80004c90:	4581                	li	a1,0
    80004c92:	8552                	mv	a0,s4
    80004c94:	d03fe0ef          	jal	80003996 <readi>
    80004c98:	22a91263          	bne	s2,a0,80004ebc <kexec+0x2fc>
  for (i = 0; i < sz; i += PGSIZE) {
    80004c9c:	009a84bb          	addw	s1,s5,s1
    80004ca0:	0334f263          	bgeu	s1,s3,80004cc4 <kexec+0x104>
    pa = walkaddr(pagetable, va + i);
    80004ca4:	02049593          	slli	a1,s1,0x20
    80004ca8:	9181                	srli	a1,a1,0x20
    80004caa:	95e2                	add	a1,a1,s8
    80004cac:	855a                	mv	a0,s6
    80004cae:	b70fc0ef          	jal	8000101e <walkaddr>
    80004cb2:	862a                	mv	a2,a0
    if (pa == 0)
    80004cb4:	d561                	beqz	a0,80004c7c <kexec+0xbc>
    if (sz - i < PGSIZE)
    80004cb6:	409987bb          	subw	a5,s3,s1
    80004cba:	893e                	mv	s2,a5
    80004cbc:	fcfcf6e3          	bgeu	s9,a5,80004c88 <kexec+0xc8>
    80004cc0:	8956                	mv	s2,s5
    80004cc2:	b7d9                	j	80004c88 <kexec+0xc8>
    sz = sz1;
    80004cc4:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004cc8:	2d05                	addiw	s10,s10,1
    80004cca:	e0843783          	ld	a5,-504(s0)
    80004cce:	0387869b          	addiw	a3,a5,56
    80004cd2:	e8845783          	lhu	a5,-376(s0)
    80004cd6:	06fd5863          	bge	s10,a5,80004d46 <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004cda:	e0d43423          	sd	a3,-504(s0)
    80004cde:	876e                	mv	a4,s11
    80004ce0:	e1840613          	addi	a2,s0,-488
    80004ce4:	4581                	li	a1,0
    80004ce6:	8552                	mv	a0,s4
    80004ce8:	caffe0ef          	jal	80003996 <readi>
    80004cec:	1db51663          	bne	a0,s11,80004eb8 <kexec+0x2f8>
    if (ph.type != ELF_PROG_LOAD)
    80004cf0:	e1842783          	lw	a5,-488(s0)
    80004cf4:	4705                	li	a4,1
    80004cf6:	fce799e3          	bne	a5,a4,80004cc8 <kexec+0x108>
    if (ph.memsz < ph.filesz)
    80004cfa:	e4043483          	ld	s1,-448(s0)
    80004cfe:	e3843783          	ld	a5,-456(s0)
    80004d02:	1af4eb63          	bltu	s1,a5,80004eb8 <kexec+0x2f8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004d06:	e2843783          	ld	a5,-472(s0)
    80004d0a:	94be                	add	s1,s1,a5
    80004d0c:	1af4e663          	bltu	s1,a5,80004eb8 <kexec+0x2f8>
    if (ph.vaddr % PGSIZE != 0)
    80004d10:	17d2                	slli	a5,a5,0x34
    80004d12:	1a079363          	bnez	a5,80004eb8 <kexec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004d16:	e1c42503          	lw	a0,-484(s0)
    80004d1a:	e87ff0ef          	jal	80004ba0 <flags2perm>
    80004d1e:	86aa                	mv	a3,a0
    80004d20:	8626                	mv	a2,s1
    80004d22:	85ca                	mv	a1,s2
    80004d24:	855a                	mv	a0,s6
    80004d26:	dc6fc0ef          	jal	800012ec <uvmalloc>
    80004d2a:	dea43823          	sd	a0,-528(s0)
    80004d2e:	18050563          	beqz	a0,80004eb8 <kexec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004d32:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004d36:	f80987e3          	beqz	s3,80004cc4 <kexec+0x104>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004d3a:	e2843c03          	ld	s8,-472(s0)
    80004d3e:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004d42:	4481                	li	s1,0
    80004d44:	b785                	j	80004ca4 <kexec+0xe4>
    80004d46:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004d48:	8552                	mv	a0,s4
    80004d4a:	ac7fe0ef          	jal	80003810 <iunlockput>
  end_op();
    80004d4e:	b6cff0ef          	jal	800040ba <end_op>
  p = myproc();
    80004d52:	bd7fc0ef          	jal	80001928 <myproc>
    80004d56:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004d58:	04853a03          	ld	s4,72(a0)
  sz = PGROUNDUP(sz);
    80004d5c:	6485                	lui	s1,0x1
    80004d5e:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    80004d60:	94ca                	add	s1,s1,s2
    80004d62:	77fd                	lui	a5,0xfffff
    80004d64:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004d66:	4691                	li	a3,4
    80004d68:	6609                	lui	a2,0x2
    80004d6a:	9626                	add	a2,a2,s1
    80004d6c:	85a6                	mv	a1,s1
    80004d6e:	855a                	mv	a0,s6
    80004d70:	d7cfc0ef          	jal	800012ec <uvmalloc>
    80004d74:	8aaa                	mv	s5,a0
    80004d76:	e105                	bnez	a0,80004d96 <kexec+0x1d6>
    proc_freepagetable(pagetable, sz);
    80004d78:	85a6                	mv	a1,s1
    80004d7a:	855a                	mv	a0,s6
    80004d7c:	d35fc0ef          	jal	80001ab0 <proc_freepagetable>
  if (ip) {
    80004d80:	79be                	ld	s3,488(sp)
    80004d82:	7a1e                	ld	s4,480(sp)
    80004d84:	6afe                	ld	s5,472(sp)
    80004d86:	6b5e                	ld	s6,464(sp)
    80004d88:	6bbe                	ld	s7,456(sp)
    80004d8a:	6c1e                	ld	s8,448(sp)
    80004d8c:	7cfa                	ld	s9,440(sp)
    80004d8e:	7d5a                	ld	s10,432(sp)
    80004d90:	bd71                	j	80004c2c <kexec+0x6c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d92:	4901                	li	s2,0
    80004d94:	bf55                	j	80004d48 <kexec+0x188>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004d96:	75f9                	lui	a1,0xffffe
    80004d98:	95aa                	add	a1,a1,a0
    80004d9a:	855a                	mv	a0,s6
    80004d9c:	f18fc0ef          	jal	800014b4 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004da0:	7bfd                	lui	s7,0xfffff
    80004da2:	9bd6                	add	s7,s7,s5
  for (argc = 0; argv[argc]; argc++) {
    80004da4:	df843783          	ld	a5,-520(s0)
    80004da8:	6388                	ld	a0,0(a5)
    80004daa:	cd3d                	beqz	a0,80004e28 <kexec+0x268>
  sp = sz;
    80004dac:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004dae:	4481                	li	s1,0
    ustack[argc] = sp;
    80004db0:	e9040913          	addi	s2,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004db4:	8c6fc0ef          	jal	80000e7a <strlen>
    80004db8:	0015079b          	addiw	a5,a0,1
    80004dbc:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004dc0:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004dc4:	077c6063          	bltu	s8,s7,80004e24 <kexec+0x264>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004dc8:	df843d03          	ld	s10,-520(s0)
    80004dcc:	000d3c83          	ld	s9,0(s10)
    80004dd0:	8566                	mv	a0,s9
    80004dd2:	8a8fc0ef          	jal	80000e7a <strlen>
    80004dd6:	0015071b          	addiw	a4,a0,1
    80004dda:	86e6                	mv	a3,s9
    80004ddc:	8662                	mv	a2,s8
    80004dde:	85d6                	mv	a1,s5
    80004de0:	855a                	mv	a0,s6
    80004de2:	f90fc0ef          	jal	80001572 <copyout>
    80004de6:	02054f63          	bltz	a0,80004e24 <kexec+0x264>
    ustack[argc] = sp;
    80004dea:	00349793          	slli	a5,s1,0x3
    80004dee:	97ca                	add	a5,a5,s2
    80004df0:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffde050>
  for (argc = 0; argv[argc]; argc++) {
    80004df4:	0485                	addi	s1,s1,1
    80004df6:	008d0793          	addi	a5,s10,8
    80004dfa:	def43c23          	sd	a5,-520(s0)
    80004dfe:	008d3503          	ld	a0,8(s10)
    80004e02:	f94d                	bnez	a0,80004db4 <kexec+0x1f4>
  ustack[argc] = 0;
    80004e04:	00349793          	slli	a5,s1,0x3
    80004e08:	f9040713          	addi	a4,s0,-112
    80004e0c:	97ba                	add	a5,a5,a4
    80004e0e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004e12:	00148713          	addi	a4,s1,1
    80004e16:	070e                	slli	a4,a4,0x3
    80004e18:	40ec0933          	sub	s2,s8,a4
  sp -= sp % 16;
    80004e1c:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80004e20:	01797763          	bgeu	s2,s7,80004e2e <kexec+0x26e>
  sz = sz1;
    80004e24:	84d6                	mv	s1,s5
    80004e26:	bf89                	j	80004d78 <kexec+0x1b8>
  sp = sz;
    80004e28:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004e2a:	4481                	li	s1,0
    80004e2c:	bfe1                	j	80004e04 <kexec+0x244>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004e2e:	e9040693          	addi	a3,s0,-368
    80004e32:	864a                	mv	a2,s2
    80004e34:	85d6                	mv	a1,s5
    80004e36:	855a                	mv	a0,s6
    80004e38:	f3afc0ef          	jal	80001572 <copyout>
    80004e3c:	fe0544e3          	bltz	a0,80004e24 <kexec+0x264>
  p->trapframe->a1 = sp;
    80004e40:	0589b783          	ld	a5,88(s3)
    80004e44:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004e48:	e0043783          	ld	a5,-512(s0)
    80004e4c:	0007c703          	lbu	a4,0(a5)
    80004e50:	cf11                	beqz	a4,80004e6c <kexec+0x2ac>
    80004e52:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004e54:	02f00693          	li	a3,47
    80004e58:	a029                	j	80004e62 <kexec+0x2a2>
  for (last = s = path; *s; s++)
    80004e5a:	0785                	addi	a5,a5,1
    80004e5c:	fff7c703          	lbu	a4,-1(a5)
    80004e60:	c711                	beqz	a4,80004e6c <kexec+0x2ac>
    if (*s == '/')
    80004e62:	fed71ce3          	bne	a4,a3,80004e5a <kexec+0x29a>
      last = s + 1;
    80004e66:	e0f43023          	sd	a5,-512(s0)
    80004e6a:	bfc5                	j	80004e5a <kexec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e6c:	4641                	li	a2,16
    80004e6e:	e0043583          	ld	a1,-512(s0)
    80004e72:	15898513          	addi	a0,s3,344
    80004e76:	fcffb0ef          	jal	80000e44 <safestrcpy>
  oldpagetable = p->pagetable;
    80004e7a:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004e7e:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004e82:	0559b423          	sd	s5,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004e86:	0589b783          	ld	a5,88(s3)
    80004e8a:	e6843703          	ld	a4,-408(s0)
    80004e8e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004e90:	0589b783          	ld	a5,88(s3)
    80004e94:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e98:	85d2                	mv	a1,s4
    80004e9a:	c17fc0ef          	jal	80001ab0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e9e:	0004851b          	sext.w	a0,s1
    80004ea2:	79be                	ld	s3,488(sp)
    80004ea4:	7a1e                	ld	s4,480(sp)
    80004ea6:	6afe                	ld	s5,472(sp)
    80004ea8:	6b5e                	ld	s6,464(sp)
    80004eaa:	6bbe                	ld	s7,456(sp)
    80004eac:	6c1e                	ld	s8,448(sp)
    80004eae:	7cfa                	ld	s9,440(sp)
    80004eb0:	7d5a                	ld	s10,432(sp)
    80004eb2:	bbb5                	j	80004c2e <kexec+0x6e>
    80004eb4:	6b5e                	ld	s6,464(sp)
    80004eb6:	b3ad                	j	80004c20 <kexec+0x60>
    return -1;
    80004eb8:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    80004ebc:	df043583          	ld	a1,-528(s0)
    80004ec0:	855a                	mv	a0,s6
    80004ec2:	beffc0ef          	jal	80001ab0 <proc_freepagetable>
  if (ip) {
    80004ec6:	79be                	ld	s3,488(sp)
    80004ec8:	6afe                	ld	s5,472(sp)
    80004eca:	6b5e                	ld	s6,464(sp)
    80004ecc:	6bbe                	ld	s7,456(sp)
    80004ece:	6c1e                	ld	s8,448(sp)
    80004ed0:	7cfa                	ld	s9,440(sp)
    80004ed2:	7d5a                	ld	s10,432(sp)
    80004ed4:	7dba                	ld	s11,424(sp)
    80004ed6:	b3a9                	j	80004c20 <kexec+0x60>

0000000080004ed8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ed8:	7179                	addi	sp,sp,-48
    80004eda:	f406                	sd	ra,40(sp)
    80004edc:	f022                	sd	s0,32(sp)
    80004ede:	ec26                	sd	s1,24(sp)
    80004ee0:	e84a                	sd	s2,16(sp)
    80004ee2:	1800                	addi	s0,sp,48
    80004ee4:	892e                	mv	s2,a1
    80004ee6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004ee8:	fdc40593          	addi	a1,s0,-36
    80004eec:	ad3fd0ef          	jal	800029be <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004ef0:	fdc42703          	lw	a4,-36(s0)
    80004ef4:	47bd                	li	a5,15
    80004ef6:	02e7e963          	bltu	a5,a4,80004f28 <argfd+0x50>
    80004efa:	a2ffc0ef          	jal	80001928 <myproc>
    80004efe:	fdc42703          	lw	a4,-36(s0)
    80004f02:	01a70793          	addi	a5,a4,26
    80004f06:	078e                	slli	a5,a5,0x3
    80004f08:	953e                	add	a0,a0,a5
    80004f0a:	611c                	ld	a5,0(a0)
    80004f0c:	cf91                	beqz	a5,80004f28 <argfd+0x50>
    return -1;
  if (pfd)
    80004f0e:	00090463          	beqz	s2,80004f16 <argfd+0x3e>
    *pfd = fd;
    80004f12:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004f16:	c091                	beqz	s1,80004f1a <argfd+0x42>
    *pf = f;
    80004f18:	e09c                	sd	a5,0(s1)
  return 0;
    80004f1a:	4501                	li	a0,0
}
    80004f1c:	70a2                	ld	ra,40(sp)
    80004f1e:	7402                	ld	s0,32(sp)
    80004f20:	64e2                	ld	s1,24(sp)
    80004f22:	6942                	ld	s2,16(sp)
    80004f24:	6145                	addi	sp,sp,48
    80004f26:	8082                	ret
    return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	bfcd                	j	80004f1c <argfd+0x44>

0000000080004f2c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f2c:	1101                	addi	sp,sp,-32
    80004f2e:	ec06                	sd	ra,24(sp)
    80004f30:	e822                	sd	s0,16(sp)
    80004f32:	e426                	sd	s1,8(sp)
    80004f34:	1000                	addi	s0,sp,32
    80004f36:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f38:	9f1fc0ef          	jal	80001928 <myproc>
    80004f3c:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004f3e:	0d050793          	addi	a5,a0,208
    80004f42:	4501                	li	a0,0
    80004f44:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004f46:	6398                	ld	a4,0(a5)
    80004f48:	cb19                	beqz	a4,80004f5e <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004f4a:	2505                	addiw	a0,a0,1
    80004f4c:	07a1                	addi	a5,a5,8
    80004f4e:	fed51ce3          	bne	a0,a3,80004f46 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f52:	557d                	li	a0,-1
}
    80004f54:	60e2                	ld	ra,24(sp)
    80004f56:	6442                	ld	s0,16(sp)
    80004f58:	64a2                	ld	s1,8(sp)
    80004f5a:	6105                	addi	sp,sp,32
    80004f5c:	8082                	ret
      p->ofile[fd] = f;
    80004f5e:	01a50793          	addi	a5,a0,26
    80004f62:	078e                	slli	a5,a5,0x3
    80004f64:	963e                	add	a2,a2,a5
    80004f66:	e204                	sd	s1,0(a2)
      return fd;
    80004f68:	b7f5                	j	80004f54 <fdalloc+0x28>

0000000080004f6a <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004f6a:	715d                	addi	sp,sp,-80
    80004f6c:	e486                	sd	ra,72(sp)
    80004f6e:	e0a2                	sd	s0,64(sp)
    80004f70:	fc26                	sd	s1,56(sp)
    80004f72:	f84a                	sd	s2,48(sp)
    80004f74:	f44e                	sd	s3,40(sp)
    80004f76:	ec56                	sd	s5,24(sp)
    80004f78:	e85a                	sd	s6,16(sp)
    80004f7a:	0880                	addi	s0,sp,80
    80004f7c:	89ae                	mv	s3,a1
    80004f7e:	8ab2                	mv	s5,a2
    80004f80:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004f82:	fb040593          	addi	a1,s0,-80
    80004f86:	ee5fe0ef          	jal	80003e6a <nameiparent>
    80004f8a:	84aa                	mv	s1,a0
    return 0;
    80004f8c:	892a                	mv	s2,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004f8e:	cd31                	beqz	a0,80004fea <create+0x80>

  ilock(dp);
    80004f90:	e2cfe0ef          	jal	800035bc <ilock>

  if (dp->nlink == 0) {
    80004f94:	04a49783          	lh	a5,74(s1)
    80004f98:	c3bd                	beqz	a5,80004ffe <create+0x94>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004f9a:	7761                	lui	a4,0xffff8
    80004f9c:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd7051>
    80004f9e:	97ba                	add	a5,a5,a4
    80004fa0:	0017b793          	seqz	a5,a5
    80004fa4:	fff98713          	addi	a4,s3,-1
    80004fa8:	00173713          	seqz	a4,a4
    80004fac:	8ff9                	and	a5,a5,a4
    80004fae:	efa1                	bnez	a5,80005006 <create+0x9c>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004fb0:	4601                	li	a2,0
    80004fb2:	fb040593          	addi	a1,s0,-80
    80004fb6:	8526                	mv	a0,s1
    80004fb8:	beffe0ef          	jal	80003ba6 <dirlookup>
    80004fbc:	892a                	mv	s2,a0
    80004fbe:	c921                	beqz	a0,8000500e <create+0xa4>
    iunlockput(dp);
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	84ffe0ef          	jal	80003810 <iunlockput>
    ilock(ip);
    80004fc6:	854a                	mv	a0,s2
    80004fc8:	df4fe0ef          	jal	800035bc <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004fcc:	4789                	li	a5,2
    80004fce:	00f99a63          	bne	s3,a5,80004fe2 <create+0x78>
    80004fd2:	04495783          	lhu	a5,68(s2)
    80004fd6:	37f9                	addiw	a5,a5,-2
    80004fd8:	17c2                	slli	a5,a5,0x30
    80004fda:	93c1                	srli	a5,a5,0x30
    80004fdc:	4705                	li	a4,1
    80004fde:	00f77663          	bgeu	a4,a5,80004fea <create+0x80>
      return ip;
    iunlockput(ip);
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	82dfe0ef          	jal	80003810 <iunlockput>
    return 0;
    80004fe8:	4901                	li	s2,0
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004fea:	854a                	mv	a0,s2
    80004fec:	60a6                	ld	ra,72(sp)
    80004fee:	6406                	ld	s0,64(sp)
    80004ff0:	74e2                	ld	s1,56(sp)
    80004ff2:	7942                	ld	s2,48(sp)
    80004ff4:	79a2                	ld	s3,40(sp)
    80004ff6:	6ae2                	ld	s5,24(sp)
    80004ff8:	6b42                	ld	s6,16(sp)
    80004ffa:	6161                	addi	sp,sp,80
    80004ffc:	8082                	ret
    iunlockput(dp);
    80004ffe:	8526                	mv	a0,s1
    80005000:	811fe0ef          	jal	80003810 <iunlockput>
    return 0;
    80005004:	b7d5                	j	80004fe8 <create+0x7e>
    iunlockput(dp);
    80005006:	8526                	mv	a0,s1
    80005008:	809fe0ef          	jal	80003810 <iunlockput>
    return 0;
    8000500c:	bff1                	j	80004fe8 <create+0x7e>
    8000500e:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80005010:	85ce                	mv	a1,s3
    80005012:	4088                	lw	a0,0(s1)
    80005014:	c38fe0ef          	jal	8000344c <ialloc>
    80005018:	8a2a                	mv	s4,a0
    8000501a:	cd1d                	beqz	a0,80005058 <create+0xee>
  ilock(ip);
    8000501c:	da0fe0ef          	jal	800035bc <ilock>
  ip->major = major;
    80005020:	055a1323          	sh	s5,70(s4)
  ip->minor = minor;
    80005024:	056a1423          	sh	s6,72(s4)
  ip->nlink = 1;
    80005028:	4705                	li	a4,1
    8000502a:	04ea1523          	sh	a4,74(s4)
  iupdate(ip);
    8000502e:	8552                	mv	a0,s4
    80005030:	cd8fe0ef          	jal	80003508 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80005034:	4785                	li	a5,1
    80005036:	02f98563          	beq	s3,a5,80005060 <create+0xf6>
  if (dirlink(dp, name, ip->inum) < 0)
    8000503a:	004a2603          	lw	a2,4(s4)
    8000503e:	fb040593          	addi	a1,s0,-80
    80005042:	8526                	mv	a0,s1
    80005044:	d63fe0ef          	jal	80003da6 <dirlink>
    80005048:	06054363          	bltz	a0,800050ae <create+0x144>
  iunlockput(dp);
    8000504c:	8526                	mv	a0,s1
    8000504e:	fc2fe0ef          	jal	80003810 <iunlockput>
    return 0;
    80005052:	8952                	mv	s2,s4
    80005054:	7a02                	ld	s4,32(sp)
    80005056:	bf51                	j	80004fea <create+0x80>
    iunlockput(dp);
    80005058:	8526                	mv	a0,s1
    8000505a:	fb6fe0ef          	jal	80003810 <iunlockput>
    return 0;
    8000505e:	bfd5                	j	80005052 <create+0xe8>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005060:	004a2603          	lw	a2,4(s4)
    80005064:	00002597          	auipc	a1,0x2
    80005068:	69458593          	addi	a1,a1,1684 # 800076f8 <etext+0x6f8>
    8000506c:	8552                	mv	a0,s4
    8000506e:	d39fe0ef          	jal	80003da6 <dirlink>
    80005072:	02054e63          	bltz	a0,800050ae <create+0x144>
    80005076:	40d0                	lw	a2,4(s1)
    80005078:	00002597          	auipc	a1,0x2
    8000507c:	68858593          	addi	a1,a1,1672 # 80007700 <etext+0x700>
    80005080:	8552                	mv	a0,s4
    80005082:	d25fe0ef          	jal	80003da6 <dirlink>
    80005086:	02054463          	bltz	a0,800050ae <create+0x144>
  if (dirlink(dp, name, ip->inum) < 0)
    8000508a:	004a2603          	lw	a2,4(s4)
    8000508e:	fb040593          	addi	a1,s0,-80
    80005092:	8526                	mv	a0,s1
    80005094:	d13fe0ef          	jal	80003da6 <dirlink>
    80005098:	00054b63          	bltz	a0,800050ae <create+0x144>
    dp->nlink++; // for ".."
    8000509c:	04a4d783          	lhu	a5,74(s1)
    800050a0:	2785                	addiw	a5,a5,1
    800050a2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050a6:	8526                	mv	a0,s1
    800050a8:	c60fe0ef          	jal	80003508 <iupdate>
    800050ac:	b745                	j	8000504c <create+0xe2>
  ip->nlink = 0;
    800050ae:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800050b2:	8552                	mv	a0,s4
    800050b4:	c54fe0ef          	jal	80003508 <iupdate>
  iunlockput(ip);
    800050b8:	8552                	mv	a0,s4
    800050ba:	f56fe0ef          	jal	80003810 <iunlockput>
  iunlockput(dp);
    800050be:	8526                	mv	a0,s1
    800050c0:	f50fe0ef          	jal	80003810 <iunlockput>
  return 0;
    800050c4:	7a02                	ld	s4,32(sp)
    800050c6:	b715                	j	80004fea <create+0x80>

00000000800050c8 <sys_dup>:
{
    800050c8:	7179                	addi	sp,sp,-48
    800050ca:	f406                	sd	ra,40(sp)
    800050cc:	f022                	sd	s0,32(sp)
    800050ce:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    800050d0:	fd840613          	addi	a2,s0,-40
    800050d4:	4581                	li	a1,0
    800050d6:	4501                	li	a0,0
    800050d8:	e01ff0ef          	jal	80004ed8 <argfd>
    800050dc:	02054863          	bltz	a0,8000510c <sys_dup+0x44>
    800050e0:	ec26                	sd	s1,24(sp)
    800050e2:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    800050e4:	fd843483          	ld	s1,-40(s0)
    800050e8:	8526                	mv	a0,s1
    800050ea:	e43ff0ef          	jal	80004f2c <fdalloc>
    800050ee:	892a                	mv	s2,a0
    800050f0:	00054c63          	bltz	a0,80005108 <sys_dup+0x40>
  filedup(f);
    800050f4:	8526                	mv	a0,s1
    800050f6:	ba8ff0ef          	jal	8000449e <filedup>
  return fd;
    800050fa:	854a                	mv	a0,s2
    800050fc:	64e2                	ld	s1,24(sp)
    800050fe:	6942                	ld	s2,16(sp)
}
    80005100:	70a2                	ld	ra,40(sp)
    80005102:	7402                	ld	s0,32(sp)
    80005104:	6145                	addi	sp,sp,48
    80005106:	8082                	ret
    80005108:	64e2                	ld	s1,24(sp)
    8000510a:	6942                	ld	s2,16(sp)
    return -1;
    8000510c:	557d                	li	a0,-1
    8000510e:	bfcd                	j	80005100 <sys_dup+0x38>

0000000080005110 <sys_read>:
{
    80005110:	7179                	addi	sp,sp,-48
    80005112:	f406                	sd	ra,40(sp)
    80005114:	f022                	sd	s0,32(sp)
    80005116:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005118:	fd840593          	addi	a1,s0,-40
    8000511c:	4505                	li	a0,1
    8000511e:	8bdfd0ef          	jal	800029da <argaddr>
  argint(2, &n);
    80005122:	fe440593          	addi	a1,s0,-28
    80005126:	4509                	li	a0,2
    80005128:	897fd0ef          	jal	800029be <argint>
  if (argfd(0, 0, &f) < 0)
    8000512c:	fe840613          	addi	a2,s0,-24
    80005130:	4581                	li	a1,0
    80005132:	4501                	li	a0,0
    80005134:	da5ff0ef          	jal	80004ed8 <argfd>
    80005138:	87aa                	mv	a5,a0
    return -1;
    8000513a:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000513c:	0007ca63          	bltz	a5,80005150 <sys_read+0x40>
  return fileread(f, p, n);
    80005140:	fe442603          	lw	a2,-28(s0)
    80005144:	fd843583          	ld	a1,-40(s0)
    80005148:	fe843503          	ld	a0,-24(s0)
    8000514c:	cc0ff0ef          	jal	8000460c <fileread>
}
    80005150:	70a2                	ld	ra,40(sp)
    80005152:	7402                	ld	s0,32(sp)
    80005154:	6145                	addi	sp,sp,48
    80005156:	8082                	ret

0000000080005158 <sys_write>:
{
    80005158:	7179                	addi	sp,sp,-48
    8000515a:	f406                	sd	ra,40(sp)
    8000515c:	f022                	sd	s0,32(sp)
    8000515e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005160:	fd840593          	addi	a1,s0,-40
    80005164:	4505                	li	a0,1
    80005166:	875fd0ef          	jal	800029da <argaddr>
  argint(2, &n);
    8000516a:	fe440593          	addi	a1,s0,-28
    8000516e:	4509                	li	a0,2
    80005170:	84ffd0ef          	jal	800029be <argint>
  if (argfd(0, 0, &f) < 0)
    80005174:	fe840613          	addi	a2,s0,-24
    80005178:	4581                	li	a1,0
    8000517a:	4501                	li	a0,0
    8000517c:	d5dff0ef          	jal	80004ed8 <argfd>
    80005180:	87aa                	mv	a5,a0
    return -1;
    80005182:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005184:	0007ca63          	bltz	a5,80005198 <sys_write+0x40>
  return filewrite(f, p, n);
    80005188:	fe442603          	lw	a2,-28(s0)
    8000518c:	fd843583          	ld	a1,-40(s0)
    80005190:	fe843503          	ld	a0,-24(s0)
    80005194:	d3cff0ef          	jal	800046d0 <filewrite>
}
    80005198:	70a2                	ld	ra,40(sp)
    8000519a:	7402                	ld	s0,32(sp)
    8000519c:	6145                	addi	sp,sp,48
    8000519e:	8082                	ret

00000000800051a0 <sys_close>:
{
    800051a0:	1101                	addi	sp,sp,-32
    800051a2:	ec06                	sd	ra,24(sp)
    800051a4:	e822                	sd	s0,16(sp)
    800051a6:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800051a8:	fe040613          	addi	a2,s0,-32
    800051ac:	fec40593          	addi	a1,s0,-20
    800051b0:	4501                	li	a0,0
    800051b2:	d27ff0ef          	jal	80004ed8 <argfd>
    return -1;
    800051b6:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    800051b8:	02054063          	bltz	a0,800051d8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800051bc:	f6cfc0ef          	jal	80001928 <myproc>
    800051c0:	fec42783          	lw	a5,-20(s0)
    800051c4:	07e9                	addi	a5,a5,26
    800051c6:	078e                	slli	a5,a5,0x3
    800051c8:	953e                	add	a0,a0,a5
    800051ca:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800051ce:	fe043503          	ld	a0,-32(s0)
    800051d2:	b12ff0ef          	jal	800044e4 <fileclose>
  return 0;
    800051d6:	4781                	li	a5,0
}
    800051d8:	853e                	mv	a0,a5
    800051da:	60e2                	ld	ra,24(sp)
    800051dc:	6442                	ld	s0,16(sp)
    800051de:	6105                	addi	sp,sp,32
    800051e0:	8082                	ret

00000000800051e2 <sys_fstat>:
{
    800051e2:	1101                	addi	sp,sp,-32
    800051e4:	ec06                	sd	ra,24(sp)
    800051e6:	e822                	sd	s0,16(sp)
    800051e8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800051ea:	fe040593          	addi	a1,s0,-32
    800051ee:	4505                	li	a0,1
    800051f0:	feafd0ef          	jal	800029da <argaddr>
  if (argfd(0, 0, &f) < 0)
    800051f4:	fe840613          	addi	a2,s0,-24
    800051f8:	4581                	li	a1,0
    800051fa:	4501                	li	a0,0
    800051fc:	cddff0ef          	jal	80004ed8 <argfd>
    80005200:	87aa                	mv	a5,a0
    return -1;
    80005202:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005204:	0007c863          	bltz	a5,80005214 <sys_fstat+0x32>
  return filestat(f, st);
    80005208:	fe043583          	ld	a1,-32(s0)
    8000520c:	fe843503          	ld	a0,-24(s0)
    80005210:	b96ff0ef          	jal	800045a6 <filestat>
}
    80005214:	60e2                	ld	ra,24(sp)
    80005216:	6442                	ld	s0,16(sp)
    80005218:	6105                	addi	sp,sp,32
    8000521a:	8082                	ret

000000008000521c <sys_link>:
{
    8000521c:	7169                	addi	sp,sp,-304
    8000521e:	f606                	sd	ra,296(sp)
    80005220:	f222                	sd	s0,288(sp)
    80005222:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005224:	08000613          	li	a2,128
    80005228:	ed040593          	addi	a1,s0,-304
    8000522c:	4501                	li	a0,0
    8000522e:	fc8fd0ef          	jal	800029f6 <argstr>
    80005232:	0e054c63          	bltz	a0,8000532a <sys_link+0x10e>
    80005236:	08000613          	li	a2,128
    8000523a:	f5040593          	addi	a1,s0,-176
    8000523e:	4505                	li	a0,1
    80005240:	fb6fd0ef          	jal	800029f6 <argstr>
    80005244:	0e054363          	bltz	a0,8000532a <sys_link+0x10e>
    80005248:	ee26                	sd	s1,280(sp)
  begin_op();
    8000524a:	de5fe0ef          	jal	8000402e <begin_op>
  if ((ip = namei(old)) == 0) {
    8000524e:	ed040513          	addi	a0,s0,-304
    80005252:	bfffe0ef          	jal	80003e50 <namei>
    80005256:	84aa                	mv	s1,a0
    80005258:	cd35                	beqz	a0,800052d4 <sys_link+0xb8>
  ilock(ip);
    8000525a:	b62fe0ef          	jal	800035bc <ilock>
  if (ip->type == T_DIR) {
    8000525e:	04449703          	lh	a4,68(s1)
    80005262:	4785                	li	a5,1
    80005264:	06f70c63          	beq	a4,a5,800052dc <sys_link+0xc0>
  if (ip->nlink >= NLINK_MAX) {
    80005268:	04a49783          	lh	a5,74(s1)
    8000526c:	6721                	lui	a4,0x8
    8000526e:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80005270:	06e78d63          	beq	a5,a4,800052ea <sys_link+0xce>
    80005274:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005276:	2785                	addiw	a5,a5,1
    80005278:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000527c:	8526                	mv	a0,s1
    8000527e:	a8afe0ef          	jal	80003508 <iupdate>
  iunlock(ip);
    80005282:	8526                	mv	a0,s1
    80005284:	be6fe0ef          	jal	8000366a <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80005288:	fd040593          	addi	a1,s0,-48
    8000528c:	f5040513          	addi	a0,s0,-176
    80005290:	bdbfe0ef          	jal	80003e6a <nameiparent>
    80005294:	892a                	mv	s2,a0
    80005296:	c925                	beqz	a0,80005306 <sys_link+0xea>
  ilock(dp);
    80005298:	b24fe0ef          	jal	800035bc <ilock>
  if (dp->nlink == 0) {
    8000529c:	04a91783          	lh	a5,74(s2)
    800052a0:	cfa1                	beqz	a5,800052f8 <sys_link+0xdc>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    800052a2:	854a                	mv	a0,s2
    800052a4:	00092703          	lw	a4,0(s2)
    800052a8:	409c                	lw	a5,0(s1)
    800052aa:	04f71b63          	bne	a4,a5,80005300 <sys_link+0xe4>
    800052ae:	40d0                	lw	a2,4(s1)
    800052b0:	fd040593          	addi	a1,s0,-48
    800052b4:	af3fe0ef          	jal	80003da6 <dirlink>
    800052b8:	04054463          	bltz	a0,80005300 <sys_link+0xe4>
  iunlockput(dp);
    800052bc:	854a                	mv	a0,s2
    800052be:	d52fe0ef          	jal	80003810 <iunlockput>
  iput(ip);
    800052c2:	8526                	mv	a0,s1
    800052c4:	c7afe0ef          	jal	8000373e <iput>
  end_op();
    800052c8:	df3fe0ef          	jal	800040ba <end_op>
  return 0;
    800052cc:	4501                	li	a0,0
    800052ce:	64f2                	ld	s1,280(sp)
    800052d0:	6952                	ld	s2,272(sp)
    800052d2:	a8a9                	j	8000532c <sys_link+0x110>
    end_op();
    800052d4:	de7fe0ef          	jal	800040ba <end_op>
    return -1;
    800052d8:	64f2                	ld	s1,280(sp)
    800052da:	a881                	j	8000532a <sys_link+0x10e>
    iunlockput(ip);
    800052dc:	8526                	mv	a0,s1
    800052de:	d32fe0ef          	jal	80003810 <iunlockput>
    end_op();
    800052e2:	dd9fe0ef          	jal	800040ba <end_op>
    return -1;
    800052e6:	64f2                	ld	s1,280(sp)
    800052e8:	a089                	j	8000532a <sys_link+0x10e>
    iunlockput(ip);
    800052ea:	8526                	mv	a0,s1
    800052ec:	d24fe0ef          	jal	80003810 <iunlockput>
    end_op();
    800052f0:	dcbfe0ef          	jal	800040ba <end_op>
    return -1;
    800052f4:	64f2                	ld	s1,280(sp)
    800052f6:	a815                	j	8000532a <sys_link+0x10e>
    iunlockput(dp);
    800052f8:	854a                	mv	a0,s2
    800052fa:	d16fe0ef          	jal	80003810 <iunlockput>
    goto bad;
    800052fe:	a021                	j	80005306 <sys_link+0xea>
    iunlockput(dp);
    80005300:	854a                	mv	a0,s2
    80005302:	d0efe0ef          	jal	80003810 <iunlockput>
  ilock(ip);
    80005306:	8526                	mv	a0,s1
    80005308:	ab4fe0ef          	jal	800035bc <ilock>
  ip->nlink--;
    8000530c:	04a4d783          	lhu	a5,74(s1)
    80005310:	37fd                	addiw	a5,a5,-1
    80005312:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005316:	8526                	mv	a0,s1
    80005318:	9f0fe0ef          	jal	80003508 <iupdate>
  iunlockput(ip);
    8000531c:	8526                	mv	a0,s1
    8000531e:	cf2fe0ef          	jal	80003810 <iunlockput>
  end_op();
    80005322:	d99fe0ef          	jal	800040ba <end_op>
  return -1;
    80005326:	64f2                	ld	s1,280(sp)
    80005328:	6952                	ld	s2,272(sp)
    return -1;
    8000532a:	557d                	li	a0,-1
}
    8000532c:	70b2                	ld	ra,296(sp)
    8000532e:	7412                	ld	s0,288(sp)
    80005330:	6155                	addi	sp,sp,304
    80005332:	8082                	ret

0000000080005334 <sys_unlink>:
{
    80005334:	7151                	addi	sp,sp,-240
    80005336:	f586                	sd	ra,232(sp)
    80005338:	f1a2                	sd	s0,224(sp)
    8000533a:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    8000533c:	08000613          	li	a2,128
    80005340:	f3040593          	addi	a1,s0,-208
    80005344:	4501                	li	a0,0
    80005346:	eb0fd0ef          	jal	800029f6 <argstr>
    8000534a:	14054763          	bltz	a0,80005498 <sys_unlink+0x164>
    8000534e:	eda6                	sd	s1,216(sp)
  begin_op();
    80005350:	cdffe0ef          	jal	8000402e <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80005354:	fb040593          	addi	a1,s0,-80
    80005358:	f3040513          	addi	a0,s0,-208
    8000535c:	b0ffe0ef          	jal	80003e6a <nameiparent>
    80005360:	84aa                	mv	s1,a0
    80005362:	c955                	beqz	a0,80005416 <sys_unlink+0xe2>
  ilock(dp);
    80005364:	a58fe0ef          	jal	800035bc <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005368:	00002597          	auipc	a1,0x2
    8000536c:	39058593          	addi	a1,a1,912 # 800076f8 <etext+0x6f8>
    80005370:	fb040513          	addi	a0,s0,-80
    80005374:	81dfe0ef          	jal	80003b90 <namecmp>
    80005378:	10050a63          	beqz	a0,8000548c <sys_unlink+0x158>
    8000537c:	00002597          	auipc	a1,0x2
    80005380:	38458593          	addi	a1,a1,900 # 80007700 <etext+0x700>
    80005384:	fb040513          	addi	a0,s0,-80
    80005388:	809fe0ef          	jal	80003b90 <namecmp>
    8000538c:	10050063          	beqz	a0,8000548c <sys_unlink+0x158>
    80005390:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005392:	f2c40613          	addi	a2,s0,-212
    80005396:	fb040593          	addi	a1,s0,-80
    8000539a:	8526                	mv	a0,s1
    8000539c:	80bfe0ef          	jal	80003ba6 <dirlookup>
    800053a0:	892a                	mv	s2,a0
    800053a2:	0e050463          	beqz	a0,8000548a <sys_unlink+0x156>
    800053a6:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800053a8:	a14fe0ef          	jal	800035bc <ilock>
  if (ip->nlink < 1)
    800053ac:	04a91783          	lh	a5,74(s2)
    800053b0:	06f05763          	blez	a5,8000541e <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    800053b4:	04491703          	lh	a4,68(s2)
    800053b8:	4785                	li	a5,1
    800053ba:	06f70863          	beq	a4,a5,8000542a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800053be:	fc040993          	addi	s3,s0,-64
    800053c2:	4641                	li	a2,16
    800053c4:	4581                	li	a1,0
    800053c6:	854e                	mv	a0,s3
    800053c8:	933fb0ef          	jal	80000cfa <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800053cc:	4741                	li	a4,16
    800053ce:	f2c42683          	lw	a3,-212(s0)
    800053d2:	864e                	mv	a2,s3
    800053d4:	4581                	li	a1,0
    800053d6:	8526                	mv	a0,s1
    800053d8:	eb0fe0ef          	jal	80003a88 <writei>
    800053dc:	47c1                	li	a5,16
    800053de:	08f51763          	bne	a0,a5,8000546c <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    800053e2:	04491703          	lh	a4,68(s2)
    800053e6:	4785                	li	a5,1
    800053e8:	08f70863          	beq	a4,a5,80005478 <sys_unlink+0x144>
  iunlockput(dp);
    800053ec:	8526                	mv	a0,s1
    800053ee:	c22fe0ef          	jal	80003810 <iunlockput>
  ip->nlink--;
    800053f2:	04a95783          	lhu	a5,74(s2)
    800053f6:	37fd                	addiw	a5,a5,-1
    800053f8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800053fc:	854a                	mv	a0,s2
    800053fe:	90afe0ef          	jal	80003508 <iupdate>
  iunlockput(ip);
    80005402:	854a                	mv	a0,s2
    80005404:	c0cfe0ef          	jal	80003810 <iunlockput>
  end_op();
    80005408:	cb3fe0ef          	jal	800040ba <end_op>
  return 0;
    8000540c:	4501                	li	a0,0
    8000540e:	64ee                	ld	s1,216(sp)
    80005410:	694e                	ld	s2,208(sp)
    80005412:	69ae                	ld	s3,200(sp)
    80005414:	a059                	j	8000549a <sys_unlink+0x166>
    end_op();
    80005416:	ca5fe0ef          	jal	800040ba <end_op>
    return -1;
    8000541a:	64ee                	ld	s1,216(sp)
    8000541c:	a8b5                	j	80005498 <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    8000541e:	00002517          	auipc	a0,0x2
    80005422:	2ea50513          	addi	a0,a0,746 # 80007708 <etext+0x708>
    80005426:	c22fb0ef          	jal	80000848 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    8000542a:	04c92703          	lw	a4,76(s2)
    8000542e:	02000793          	li	a5,32
    80005432:	f8e7f6e3          	bgeu	a5,a4,800053be <sys_unlink+0x8a>
    80005436:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005438:	4741                	li	a4,16
    8000543a:	86ce                	mv	a3,s3
    8000543c:	f1840613          	addi	a2,s0,-232
    80005440:	4581                	li	a1,0
    80005442:	854a                	mv	a0,s2
    80005444:	d52fe0ef          	jal	80003996 <readi>
    80005448:	47c1                	li	a5,16
    8000544a:	00f51b63          	bne	a0,a5,80005460 <sys_unlink+0x12c>
    if (de.inum != 0)
    8000544e:	f1845783          	lhu	a5,-232(s0)
    80005452:	eba1                	bnez	a5,800054a2 <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005454:	29c1                	addiw	s3,s3,16
    80005456:	04c92783          	lw	a5,76(s2)
    8000545a:	fcf9efe3          	bltu	s3,a5,80005438 <sys_unlink+0x104>
    8000545e:	b785                	j	800053be <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005460:	00002517          	auipc	a0,0x2
    80005464:	2c050513          	addi	a0,a0,704 # 80007720 <etext+0x720>
    80005468:	be0fb0ef          	jal	80000848 <panic>
    panic("unlink: writei");
    8000546c:	00002517          	auipc	a0,0x2
    80005470:	2cc50513          	addi	a0,a0,716 # 80007738 <etext+0x738>
    80005474:	bd4fb0ef          	jal	80000848 <panic>
    dp->nlink--;
    80005478:	04a4d783          	lhu	a5,74(s1)
    8000547c:	37fd                	addiw	a5,a5,-1
    8000547e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005482:	8526                	mv	a0,s1
    80005484:	884fe0ef          	jal	80003508 <iupdate>
    80005488:	b795                	j	800053ec <sys_unlink+0xb8>
    8000548a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000548c:	8526                	mv	a0,s1
    8000548e:	b82fe0ef          	jal	80003810 <iunlockput>
  end_op();
    80005492:	c29fe0ef          	jal	800040ba <end_op>
  return -1;
    80005496:	64ee                	ld	s1,216(sp)
    return -1;
    80005498:	557d                	li	a0,-1
}
    8000549a:	70ae                	ld	ra,232(sp)
    8000549c:	740e                	ld	s0,224(sp)
    8000549e:	616d                	addi	sp,sp,240
    800054a0:	8082                	ret
    iunlockput(ip);
    800054a2:	854a                	mv	a0,s2
    800054a4:	b6cfe0ef          	jal	80003810 <iunlockput>
    goto bad;
    800054a8:	694e                	ld	s2,208(sp)
    800054aa:	69ae                	ld	s3,200(sp)
    800054ac:	b7c5                	j	8000548c <sys_unlink+0x158>

00000000800054ae <sys_open>:

uint64
sys_open(void)
{
    800054ae:	7131                	addi	sp,sp,-192
    800054b0:	fd06                	sd	ra,184(sp)
    800054b2:	f922                	sd	s0,176(sp)
    800054b4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800054b6:	f4c40593          	addi	a1,s0,-180
    800054ba:	4505                	li	a0,1
    800054bc:	d02fd0ef          	jal	800029be <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800054c0:	08000613          	li	a2,128
    800054c4:	f5040593          	addi	a1,s0,-176
    800054c8:	4501                	li	a0,0
    800054ca:	d2cfd0ef          	jal	800029f6 <argstr>
    800054ce:	10054563          	bltz	a0,800055d8 <sys_open+0x12a>
    800054d2:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    800054d4:	b5bfe0ef          	jal	8000402e <begin_op>

  if (omode & O_CREATE) {
    800054d8:	f4c42783          	lw	a5,-180(s0)
    800054dc:	2007f793          	andi	a5,a5,512
    800054e0:	cfd9                	beqz	a5,8000557e <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    800054e2:	4681                	li	a3,0
    800054e4:	4601                	li	a2,0
    800054e6:	4589                	li	a1,2
    800054e8:	f5040513          	addi	a0,s0,-176
    800054ec:	a7fff0ef          	jal	80004f6a <create>
    800054f0:	84aa                	mv	s1,a0
    if (ip == 0) {
    800054f2:	c151                	beqz	a0,80005576 <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800054f4:	04449703          	lh	a4,68(s1)
    800054f8:	478d                	li	a5,3
    800054fa:	00f71763          	bne	a4,a5,80005508 <sys_open+0x5a>
    800054fe:	0464d703          	lhu	a4,70(s1)
    80005502:	47a5                	li	a5,9
    80005504:	0ae7e863          	bltu	a5,a4,800055b4 <sys_open+0x106>
    80005508:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    8000550a:	f37fe0ef          	jal	80004440 <filealloc>
    8000550e:	892a                	mv	s2,a0
    80005510:	cd4d                	beqz	a0,800055ca <sys_open+0x11c>
    80005512:	ed4e                	sd	s3,152(sp)
    80005514:	a19ff0ef          	jal	80004f2c <fdalloc>
    80005518:	89aa                	mv	s3,a0
    8000551a:	0a054463          	bltz	a0,800055c2 <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000551e:	04449703          	lh	a4,68(s1)
    80005522:	478d                	li	a5,3
    80005524:	0af70f63          	beq	a4,a5,800055e2 <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005528:	4789                	li	a5,2
    8000552a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000552e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005532:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005536:	f4c42783          	lw	a5,-180(s0)
    8000553a:	0017f713          	andi	a4,a5,1
    8000553e:	00174713          	xori	a4,a4,1
    80005542:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005546:	0037f713          	andi	a4,a5,3
    8000554a:	00e03733          	snez	a4,a4
    8000554e:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005552:	4007f793          	andi	a5,a5,1024
    80005556:	c791                	beqz	a5,80005562 <sys_open+0xb4>
    80005558:	04449703          	lh	a4,68(s1)
    8000555c:	4789                	li	a5,2
    8000555e:	08f70963          	beq	a4,a5,800055f0 <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    80005562:	8526                	mv	a0,s1
    80005564:	906fe0ef          	jal	8000366a <iunlock>
  end_op();
    80005568:	b53fe0ef          	jal	800040ba <end_op>

  return fd;
    8000556c:	854e                	mv	a0,s3
    8000556e:	74aa                	ld	s1,168(sp)
    80005570:	790a                	ld	s2,160(sp)
    80005572:	69ea                	ld	s3,152(sp)
    80005574:	a09d                	j	800055da <sys_open+0x12c>
      end_op();
    80005576:	b45fe0ef          	jal	800040ba <end_op>
      return -1;
    8000557a:	74aa                	ld	s1,168(sp)
    8000557c:	a8b1                	j	800055d8 <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    8000557e:	f5040513          	addi	a0,s0,-176
    80005582:	8cffe0ef          	jal	80003e50 <namei>
    80005586:	84aa                	mv	s1,a0
    80005588:	c115                	beqz	a0,800055ac <sys_open+0xfe>
    ilock(ip);
    8000558a:	832fe0ef          	jal	800035bc <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    8000558e:	04449703          	lh	a4,68(s1)
    80005592:	4785                	li	a5,1
    80005594:	f6f710e3          	bne	a4,a5,800054f4 <sys_open+0x46>
    80005598:	f4c42783          	lw	a5,-180(s0)
    8000559c:	d7b5                	beqz	a5,80005508 <sys_open+0x5a>
      iunlockput(ip);
    8000559e:	8526                	mv	a0,s1
    800055a0:	a70fe0ef          	jal	80003810 <iunlockput>
      end_op();
    800055a4:	b17fe0ef          	jal	800040ba <end_op>
      return -1;
    800055a8:	74aa                	ld	s1,168(sp)
    800055aa:	a03d                	j	800055d8 <sys_open+0x12a>
      end_op();
    800055ac:	b0ffe0ef          	jal	800040ba <end_op>
      return -1;
    800055b0:	74aa                	ld	s1,168(sp)
    800055b2:	a01d                	j	800055d8 <sys_open+0x12a>
    iunlockput(ip);
    800055b4:	8526                	mv	a0,s1
    800055b6:	a5afe0ef          	jal	80003810 <iunlockput>
    end_op();
    800055ba:	b01fe0ef          	jal	800040ba <end_op>
    return -1;
    800055be:	74aa                	ld	s1,168(sp)
    800055c0:	a821                	j	800055d8 <sys_open+0x12a>
      fileclose(f);
    800055c2:	854a                	mv	a0,s2
    800055c4:	f21fe0ef          	jal	800044e4 <fileclose>
    800055c8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800055ca:	8526                	mv	a0,s1
    800055cc:	a44fe0ef          	jal	80003810 <iunlockput>
    end_op();
    800055d0:	aebfe0ef          	jal	800040ba <end_op>
    return -1;
    800055d4:	74aa                	ld	s1,168(sp)
    800055d6:	790a                	ld	s2,160(sp)
    return -1;
    800055d8:	557d                	li	a0,-1
}
    800055da:	70ea                	ld	ra,184(sp)
    800055dc:	744a                	ld	s0,176(sp)
    800055de:	6129                	addi	sp,sp,192
    800055e0:	8082                	ret
    f->type = FD_DEVICE;
    800055e2:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800055e6:	04649783          	lh	a5,70(s1)
    800055ea:	02f91223          	sh	a5,36(s2)
    800055ee:	b791                	j	80005532 <sys_open+0x84>
    itrunc(ip);
    800055f0:	8526                	mv	a0,s1
    800055f2:	8b8fe0ef          	jal	800036aa <itrunc>
    800055f6:	b7b5                	j	80005562 <sys_open+0xb4>

00000000800055f8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800055f8:	7175                	addi	sp,sp,-144
    800055fa:	e506                	sd	ra,136(sp)
    800055fc:	e122                	sd	s0,128(sp)
    800055fe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005600:	a2ffe0ef          	jal	8000402e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005604:	08000613          	li	a2,128
    80005608:	f7040593          	addi	a1,s0,-144
    8000560c:	4501                	li	a0,0
    8000560e:	be8fd0ef          	jal	800029f6 <argstr>
    80005612:	02054363          	bltz	a0,80005638 <sys_mkdir+0x40>
    80005616:	4681                	li	a3,0
    80005618:	4601                	li	a2,0
    8000561a:	4585                	li	a1,1
    8000561c:	f7040513          	addi	a0,s0,-144
    80005620:	94bff0ef          	jal	80004f6a <create>
    80005624:	c911                	beqz	a0,80005638 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005626:	9eafe0ef          	jal	80003810 <iunlockput>
  end_op();
    8000562a:	a91fe0ef          	jal	800040ba <end_op>
  return 0;
    8000562e:	4501                	li	a0,0
}
    80005630:	60aa                	ld	ra,136(sp)
    80005632:	640a                	ld	s0,128(sp)
    80005634:	6149                	addi	sp,sp,144
    80005636:	8082                	ret
    end_op();
    80005638:	a83fe0ef          	jal	800040ba <end_op>
    return -1;
    8000563c:	557d                	li	a0,-1
    8000563e:	bfcd                	j	80005630 <sys_mkdir+0x38>

0000000080005640 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005640:	7135                	addi	sp,sp,-160
    80005642:	ed06                	sd	ra,152(sp)
    80005644:	e922                	sd	s0,144(sp)
    80005646:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005648:	9e7fe0ef          	jal	8000402e <begin_op>
  argint(1, &major);
    8000564c:	f6c40593          	addi	a1,s0,-148
    80005650:	4505                	li	a0,1
    80005652:	b6cfd0ef          	jal	800029be <argint>
  argint(2, &minor);
    80005656:	f6840593          	addi	a1,s0,-152
    8000565a:	4509                	li	a0,2
    8000565c:	b62fd0ef          	jal	800029be <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005660:	08000613          	li	a2,128
    80005664:	f7040593          	addi	a1,s0,-144
    80005668:	4501                	li	a0,0
    8000566a:	b8cfd0ef          	jal	800029f6 <argstr>
    8000566e:	02054563          	bltz	a0,80005698 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005672:	f6841683          	lh	a3,-152(s0)
    80005676:	f6c41603          	lh	a2,-148(s0)
    8000567a:	458d                	li	a1,3
    8000567c:	f7040513          	addi	a0,s0,-144
    80005680:	8ebff0ef          	jal	80004f6a <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005684:	c911                	beqz	a0,80005698 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005686:	98afe0ef          	jal	80003810 <iunlockput>
  end_op();
    8000568a:	a31fe0ef          	jal	800040ba <end_op>
  return 0;
    8000568e:	4501                	li	a0,0
}
    80005690:	60ea                	ld	ra,152(sp)
    80005692:	644a                	ld	s0,144(sp)
    80005694:	610d                	addi	sp,sp,160
    80005696:	8082                	ret
    end_op();
    80005698:	a23fe0ef          	jal	800040ba <end_op>
    return -1;
    8000569c:	557d                	li	a0,-1
    8000569e:	bfcd                	j	80005690 <sys_mknod+0x50>

00000000800056a0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800056a0:	7135                	addi	sp,sp,-160
    800056a2:	ed06                	sd	ra,152(sp)
    800056a4:	e922                	sd	s0,144(sp)
    800056a6:	e14a                	sd	s2,128(sp)
    800056a8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800056aa:	a7efc0ef          	jal	80001928 <myproc>
    800056ae:	892a                	mv	s2,a0

  begin_op();
    800056b0:	97ffe0ef          	jal	8000402e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    800056b4:	08000613          	li	a2,128
    800056b8:	f6040593          	addi	a1,s0,-160
    800056bc:	4501                	li	a0,0
    800056be:	b38fd0ef          	jal	800029f6 <argstr>
    800056c2:	02054f63          	bltz	a0,80005700 <sys_chdir+0x60>
    800056c6:	e526                	sd	s1,136(sp)
    800056c8:	f6040513          	addi	a0,s0,-160
    800056cc:	f84fe0ef          	jal	80003e50 <namei>
    800056d0:	84aa                	mv	s1,a0
    800056d2:	c515                	beqz	a0,800056fe <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    800056d4:	ee9fd0ef          	jal	800035bc <ilock>
  if (ip->type != T_DIR) {
    800056d8:	04449703          	lh	a4,68(s1)
    800056dc:	4785                	li	a5,1
    800056de:	02f71963          	bne	a4,a5,80005710 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800056e2:	8526                	mv	a0,s1
    800056e4:	f87fd0ef          	jal	8000366a <iunlock>
  iput(p->cwd);
    800056e8:	15093503          	ld	a0,336(s2)
    800056ec:	852fe0ef          	jal	8000373e <iput>
  end_op();
    800056f0:	9cbfe0ef          	jal	800040ba <end_op>
  p->cwd = ip;
    800056f4:	14993823          	sd	s1,336(s2)
  return 0;
    800056f8:	4501                	li	a0,0
    800056fa:	64aa                	ld	s1,136(sp)
    800056fc:	a029                	j	80005706 <sys_chdir+0x66>
    800056fe:	64aa                	ld	s1,136(sp)
    end_op();
    80005700:	9bbfe0ef          	jal	800040ba <end_op>
    return -1;
    80005704:	557d                	li	a0,-1
}
    80005706:	60ea                	ld	ra,152(sp)
    80005708:	644a                	ld	s0,144(sp)
    8000570a:	690a                	ld	s2,128(sp)
    8000570c:	610d                	addi	sp,sp,160
    8000570e:	8082                	ret
    iunlockput(ip);
    80005710:	8526                	mv	a0,s1
    80005712:	8fefe0ef          	jal	80003810 <iunlockput>
    end_op();
    80005716:	9a5fe0ef          	jal	800040ba <end_op>
    return -1;
    8000571a:	64aa                	ld	s1,136(sp)
    8000571c:	b7e5                	j	80005704 <sys_chdir+0x64>

000000008000571e <sys_exec>:

uint64
sys_exec(void)
{
    8000571e:	7105                	addi	sp,sp,-480
    80005720:	ef86                	sd	ra,472(sp)
    80005722:	eba2                	sd	s0,464(sp)
    80005724:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005726:	e2840593          	addi	a1,s0,-472
    8000572a:	4505                	li	a0,1
    8000572c:	aaefd0ef          	jal	800029da <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80005730:	08000613          	li	a2,128
    80005734:	f3040593          	addi	a1,s0,-208
    80005738:	4501                	li	a0,0
    8000573a:	abcfd0ef          	jal	800029f6 <argstr>
    8000573e:	0c054e63          	bltz	a0,8000581a <sys_exec+0xfc>
    80005742:	e7a6                	sd	s1,456(sp)
    80005744:	e3ca                	sd	s2,448(sp)
    80005746:	ff4e                	sd	s3,440(sp)
    80005748:	fb52                	sd	s4,432(sp)
    8000574a:	f756                	sd	s5,424(sp)
    8000574c:	f35a                	sd	s6,416(sp)
    8000574e:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005750:	e3040a13          	addi	s4,s0,-464
    80005754:	10000613          	li	a2,256
    80005758:	4581                	li	a1,0
    8000575a:	8552                	mv	a0,s4
    8000575c:	d9efb0ef          	jal	80000cfa <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005760:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005762:	89d2                	mv	s3,s4
    80005764:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005766:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000576a:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    8000576c:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005770:	00391513          	slli	a0,s2,0x3
    80005774:	85d6                	mv	a1,s5
    80005776:	e2843783          	ld	a5,-472(s0)
    8000577a:	953e                	add	a0,a0,a5
    8000577c:	9bafd0ef          	jal	80002936 <fetchaddr>
    80005780:	02054663          	bltz	a0,800057ac <sys_exec+0x8e>
    if (uarg == 0) {
    80005784:	e2043783          	ld	a5,-480(s0)
    80005788:	c3b9                	beqz	a5,800057ce <sys_exec+0xb0>
    argv[i] = kalloc();
    8000578a:	b94fb0ef          	jal	80000b1e <kalloc>
    8000578e:	85aa                	mv	a1,a0
    80005790:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005794:	cd01                	beqz	a0,800057ac <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005796:	865a                	mv	a2,s6
    80005798:	e2043503          	ld	a0,-480(s0)
    8000579c:	9e0fd0ef          	jal	8000297c <fetchstr>
    800057a0:	00054663          	bltz	a0,800057ac <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    800057a4:	0905                	addi	s2,s2,1
    800057a6:	09a1                	addi	s3,s3,8
    800057a8:	fd7914e3          	bne	s2,s7,80005770 <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800057ac:	100a0a13          	addi	s4,s4,256
    800057b0:	6088                	ld	a0,0(s1)
    800057b2:	cd29                	beqz	a0,8000580c <sys_exec+0xee>
    kfree(argv[i]);
    800057b4:	a82fb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800057b8:	04a1                	addi	s1,s1,8
    800057ba:	ff449be3          	bne	s1,s4,800057b0 <sys_exec+0x92>
    800057be:	64be                	ld	s1,456(sp)
    800057c0:	691e                	ld	s2,448(sp)
    800057c2:	79fa                	ld	s3,440(sp)
    800057c4:	7a5a                	ld	s4,432(sp)
    800057c6:	7aba                	ld	s5,424(sp)
    800057c8:	7b1a                	ld	s6,416(sp)
    800057ca:	6bfa                	ld	s7,408(sp)
    800057cc:	a0b9                	j	8000581a <sys_exec+0xfc>
      argv[i] = 0;
    800057ce:	0009079b          	sext.w	a5,s2
    800057d2:	e3040593          	addi	a1,s0,-464
    800057d6:	078e                	slli	a5,a5,0x3
    800057d8:	97ae                	add	a5,a5,a1
    800057da:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800057de:	f3040513          	addi	a0,s0,-208
    800057e2:	bdeff0ef          	jal	80004bc0 <kexec>
    800057e6:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800057e8:	100a0a13          	addi	s4,s4,256
    800057ec:	6088                	ld	a0,0(s1)
    800057ee:	c511                	beqz	a0,800057fa <sys_exec+0xdc>
    kfree(argv[i]);
    800057f0:	a46fb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800057f4:	04a1                	addi	s1,s1,8
    800057f6:	ff449be3          	bne	s1,s4,800057ec <sys_exec+0xce>
  return ret;
    800057fa:	854a                	mv	a0,s2
    800057fc:	64be                	ld	s1,456(sp)
    800057fe:	691e                	ld	s2,448(sp)
    80005800:	79fa                	ld	s3,440(sp)
    80005802:	7a5a                	ld	s4,432(sp)
    80005804:	7aba                	ld	s5,424(sp)
    80005806:	7b1a                	ld	s6,416(sp)
    80005808:	6bfa                	ld	s7,408(sp)
    8000580a:	a809                	j	8000581c <sys_exec+0xfe>
    8000580c:	64be                	ld	s1,456(sp)
    8000580e:	691e                	ld	s2,448(sp)
    80005810:	79fa                	ld	s3,440(sp)
    80005812:	7a5a                	ld	s4,432(sp)
    80005814:	7aba                	ld	s5,424(sp)
    80005816:	7b1a                	ld	s6,416(sp)
    80005818:	6bfa                	ld	s7,408(sp)
    return -1;
    8000581a:	557d                	li	a0,-1
  return -1;
}
    8000581c:	60fe                	ld	ra,472(sp)
    8000581e:	645e                	ld	s0,464(sp)
    80005820:	613d                	addi	sp,sp,480
    80005822:	8082                	ret

0000000080005824 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005824:	7139                	addi	sp,sp,-64
    80005826:	fc06                	sd	ra,56(sp)
    80005828:	f822                	sd	s0,48(sp)
    8000582a:	f426                	sd	s1,40(sp)
    8000582c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000582e:	8fafc0ef          	jal	80001928 <myproc>
    80005832:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005834:	fd840593          	addi	a1,s0,-40
    80005838:	4501                	li	a0,0
    8000583a:	9a0fd0ef          	jal	800029da <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000583e:	fc840593          	addi	a1,s0,-56
    80005842:	fd040513          	addi	a0,s0,-48
    80005846:	812ff0ef          	jal	80004858 <pipealloc>
    8000584a:	0a054663          	bltz	a0,800058f6 <sys_pipe+0xd2>
    return -1;
  fd0 = -1;
    8000584e:	57fd                	li	a5,-1
    80005850:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005854:	fd043503          	ld	a0,-48(s0)
    80005858:	ed4ff0ef          	jal	80004f2c <fdalloc>
    8000585c:	fca42223          	sw	a0,-60(s0)
    80005860:	08054363          	bltz	a0,800058e6 <sys_pipe+0xc2>
    80005864:	fc843503          	ld	a0,-56(s0)
    80005868:	ec4ff0ef          	jal	80004f2c <fdalloc>
    8000586c:	fca42023          	sw	a0,-64(s0)
    80005870:	06054263          	bltz	a0,800058d4 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005874:	4711                	li	a4,4
    80005876:	fc440693          	addi	a3,s0,-60
    8000587a:	fd843603          	ld	a2,-40(s0)
    8000587e:	64ac                	ld	a1,72(s1)
    80005880:	68a8                	ld	a0,80(s1)
    80005882:	cf1fb0ef          	jal	80001572 <copyout>
    80005886:	02054063          	bltz	a0,800058a6 <sys_pipe+0x82>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    8000588a:	4711                	li	a4,4
    8000588c:	fc040693          	addi	a3,s0,-64
    80005890:	fd843603          	ld	a2,-40(s0)
    80005894:	963a                	add	a2,a2,a4
    80005896:	64ac                	ld	a1,72(s1)
    80005898:	68a8                	ld	a0,80(s1)
    8000589a:	cd9fb0ef          	jal	80001572 <copyout>
    8000589e:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800058a0:	4501                	li	a0,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800058a2:	0407db63          	bgez	a5,800058f8 <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    800058a6:	fc442783          	lw	a5,-60(s0)
    800058aa:	07e9                	addi	a5,a5,26
    800058ac:	078e                	slli	a5,a5,0x3
    800058ae:	97a6                	add	a5,a5,s1
    800058b0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800058b4:	fc042783          	lw	a5,-64(s0)
    800058b8:	07e9                	addi	a5,a5,26
    800058ba:	078e                	slli	a5,a5,0x3
    800058bc:	94be                	add	s1,s1,a5
    800058be:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800058c2:	fd043503          	ld	a0,-48(s0)
    800058c6:	c1ffe0ef          	jal	800044e4 <fileclose>
    fileclose(wf);
    800058ca:	fc843503          	ld	a0,-56(s0)
    800058ce:	c17fe0ef          	jal	800044e4 <fileclose>
    return -1;
    800058d2:	a015                	j	800058f6 <sys_pipe+0xd2>
    if (fd0 >= 0)
    800058d4:	fc442783          	lw	a5,-60(s0)
    800058d8:	0007c763          	bltz	a5,800058e6 <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    800058dc:	07e9                	addi	a5,a5,26
    800058de:	078e                	slli	a5,a5,0x3
    800058e0:	97a6                	add	a5,a5,s1
    800058e2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800058e6:	fd043503          	ld	a0,-48(s0)
    800058ea:	bfbfe0ef          	jal	800044e4 <fileclose>
    fileclose(wf);
    800058ee:	fc843503          	ld	a0,-56(s0)
    800058f2:	bf3fe0ef          	jal	800044e4 <fileclose>
    return -1;
    800058f6:	557d                	li	a0,-1
}
    800058f8:	70e2                	ld	ra,56(sp)
    800058fa:	7442                	ld	s0,48(sp)
    800058fc:	74a2                	ld	s1,40(sp)
    800058fe:	6121                	addi	sp,sp,64
    80005900:	8082                	ret
	...

0000000080005910 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005910:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005912:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005914:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005916:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005918:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000591a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000591c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000591e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005920:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005922:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005924:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005926:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005928:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000592a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000592c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000592e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005930:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005932:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005934:	f11fc0ef          	jal	80002844 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005938:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000593a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000593c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000593e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005940:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005942:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005944:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005946:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005948:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000594a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000594c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000594e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005950:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005952:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005954:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005956:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005958:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000595a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000595c:	10200073          	sret
    80005960:	0001                	nop
    80005962:	00000013          	nop
    80005966:	00000013          	nop
    8000596a:	00000013          	nop

000000008000596e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000596e:	1141                	addi	sp,sp,-16
    80005970:	e406                	sd	ra,8(sp)
    80005972:	e022                	sd	s0,0(sp)
    80005974:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005976:	0c000737          	lui	a4,0xc000
    8000597a:	4785                	li	a5,1
    8000597c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000597e:	c35c                	sw	a5,4(a4)
}
    80005980:	60a2                	ld	ra,8(sp)
    80005982:	6402                	ld	s0,0(sp)
    80005984:	0141                	addi	sp,sp,16
    80005986:	8082                	ret

0000000080005988 <plicinithart>:

void
plicinithart(void)
{
    80005988:	1141                	addi	sp,sp,-16
    8000598a:	e406                	sd	ra,8(sp)
    8000598c:	e022                	sd	s0,0(sp)
    8000598e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005990:	f65fb0ef          	jal	800018f4 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005994:	0085171b          	slliw	a4,a0,0x8
    80005998:	0c0027b7          	lui	a5,0xc002
    8000599c:	97ba                	add	a5,a5,a4
    8000599e:	40200713          	li	a4,1026
    800059a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    800059a6:	00d5151b          	slliw	a0,a0,0xd
    800059aa:	0c2017b7          	lui	a5,0xc201
    800059ae:	97aa                	add	a5,a5,a0
    800059b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret

00000000800059bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800059bc:	1141                	addi	sp,sp,-16
    800059be:	e406                	sd	ra,8(sp)
    800059c0:	e022                	sd	s0,0(sp)
    800059c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800059c4:	f31fb0ef          	jal	800018f4 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    800059c8:	00d5151b          	slliw	a0,a0,0xd
    800059cc:	0c2017b7          	lui	a5,0xc201
    800059d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800059d2:	43c8                	lw	a0,4(a5)
    800059d4:	60a2                	ld	ra,8(sp)
    800059d6:	6402                	ld	s0,0(sp)
    800059d8:	0141                	addi	sp,sp,16
    800059da:	8082                	ret

00000000800059dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800059dc:	1101                	addi	sp,sp,-32
    800059de:	ec06                	sd	ra,24(sp)
    800059e0:	e822                	sd	s0,16(sp)
    800059e2:	e426                	sd	s1,8(sp)
    800059e4:	1000                	addi	s0,sp,32
    800059e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800059e8:	f0dfb0ef          	jal	800018f4 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800059ec:	00d5179b          	slliw	a5,a0,0xd
    800059f0:	0c201737          	lui	a4,0xc201
    800059f4:	97ba                	add	a5,a5,a4
    800059f6:	c3c4                	sw	s1,4(a5)
}
    800059f8:	60e2                	ld	ra,24(sp)
    800059fa:	6442                	ld	s0,16(sp)
    800059fc:	64a2                	ld	s1,8(sp)
    800059fe:	6105                	addi	sp,sp,32
    80005a00:	8082                	ret

0000000080005a02 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005a02:	1141                	addi	sp,sp,-16
    80005a04:	e406                	sd	ra,8(sp)
    80005a06:	e022                	sd	s0,0(sp)
    80005a08:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80005a0a:	479d                	li	a5,7
    80005a0c:	04a7ca63          	blt	a5,a0,80005a60 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005a10:	0001b797          	auipc	a5,0x1b
    80005a14:	46078793          	addi	a5,a5,1120 # 80020e70 <disk>
    80005a18:	97aa                	add	a5,a5,a0
    80005a1a:	0187c783          	lbu	a5,24(a5)
    80005a1e:	e7b9                	bnez	a5,80005a6c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005a20:	00451693          	slli	a3,a0,0x4
    80005a24:	0001b797          	auipc	a5,0x1b
    80005a28:	44c78793          	addi	a5,a5,1100 # 80020e70 <disk>
    80005a2c:	6398                	ld	a4,0(a5)
    80005a2e:	9736                	add	a4,a4,a3
    80005a30:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005a34:	6398                	ld	a4,0(a5)
    80005a36:	9736                	add	a4,a4,a3
    80005a38:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005a3c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005a40:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005a44:	97aa                	add	a5,a5,a0
    80005a46:	4705                	li	a4,1
    80005a48:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005a4c:	0001b517          	auipc	a0,0x1b
    80005a50:	43c50513          	addi	a0,a0,1084 # 80020e88 <disk+0x18>
    80005a54:	d48fc0ef          	jal	80001f9c <wakeup>
}
    80005a58:	60a2                	ld	ra,8(sp)
    80005a5a:	6402                	ld	s0,0(sp)
    80005a5c:	0141                	addi	sp,sp,16
    80005a5e:	8082                	ret
    panic("free_desc 1");
    80005a60:	00002517          	auipc	a0,0x2
    80005a64:	ce850513          	addi	a0,a0,-792 # 80007748 <etext+0x748>
    80005a68:	de1fa0ef          	jal	80000848 <panic>
    panic("free_desc 2");
    80005a6c:	00002517          	auipc	a0,0x2
    80005a70:	cec50513          	addi	a0,a0,-788 # 80007758 <etext+0x758>
    80005a74:	dd5fa0ef          	jal	80000848 <panic>

0000000080005a78 <virtio_disk_init>:
{
    80005a78:	1101                	addi	sp,sp,-32
    80005a7a:	ec06                	sd	ra,24(sp)
    80005a7c:	e822                	sd	s0,16(sp)
    80005a7e:	e426                	sd	s1,8(sp)
    80005a80:	e04a                	sd	s2,0(sp)
    80005a82:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005a84:	00002597          	auipc	a1,0x2
    80005a88:	ce458593          	addi	a1,a1,-796 # 80007768 <etext+0x768>
    80005a8c:	0001b517          	auipc	a0,0x1b
    80005a90:	50c50513          	addi	a0,a0,1292 # 80020f98 <disk+0x128>
    80005a94:	92afb0ef          	jal	80000bbe <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005a98:	100017b7          	lui	a5,0x10001
    80005a9c:	4398                	lw	a4,0(a5)
    80005a9e:	747277b7          	lui	a5,0x74727
    80005aa2:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005aa6:	14f71263          	bne	a4,a5,80005bea <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005aaa:	100017b7          	lui	a5,0x10001
    80005aae:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ab0:	4789                	li	a5,2
    80005ab2:	12f71c63          	bne	a4,a5,80005bea <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ab6:	100017b7          	lui	a5,0x10001
    80005aba:	4798                	lw	a4,8(a5)
    80005abc:	4789                	li	a5,2
    80005abe:	12f71663          	bne	a4,a5,80005bea <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005ac2:	100017b7          	lui	a5,0x10001
    80005ac6:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ac8:	554d47b7          	lui	a5,0x554d4
    80005acc:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005ad0:	10f71d63          	bne	a4,a5,80005bea <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ad4:	100017b7          	lui	a5,0x10001
    80005ad8:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005adc:	4705                	li	a4,1
    80005ade:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ae0:	470d                	li	a4,3
    80005ae2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ae4:	10001737          	lui	a4,0x10001
    80005ae8:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005aea:	c7ffe6b7          	lui	a3,0xc7ffe
    80005aee:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fdd5af>
    80005af2:	8f75                	and	a4,a4,a3
    80005af4:	100016b7          	lui	a3,0x10001
    80005af8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005afa:	472d                	li	a4,11
    80005afc:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005afe:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005b02:	00897793          	andi	a5,s2,8
    80005b06:	0e078863          	beqz	a5,80005bf6 <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005b0a:	100017b7          	lui	a5,0x10001
    80005b0e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005b12:	43fc                	lw	a5,68(a5)
    80005b14:	0e079763          	bnez	a5,80005c02 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005b18:	100017b7          	lui	a5,0x10001
    80005b1c:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    80005b1e:	0e078863          	beqz	a5,80005c0e <virtio_disk_init+0x196>
  if (max < NUM)
    80005b22:	471d                	li	a4,7
    80005b24:	0ef77b63          	bgeu	a4,a5,80005c1a <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    80005b28:	ff7fa0ef          	jal	80000b1e <kalloc>
    80005b2c:	0001b497          	auipc	s1,0x1b
    80005b30:	34448493          	addi	s1,s1,836 # 80020e70 <disk>
    80005b34:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005b36:	fe9fa0ef          	jal	80000b1e <kalloc>
    80005b3a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005b3c:	fe3fa0ef          	jal	80000b1e <kalloc>
    80005b40:	87aa                	mv	a5,a0
    80005b42:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005b44:	6088                	ld	a0,0(s1)
    80005b46:	0e050063          	beqz	a0,80005c26 <virtio_disk_init+0x1ae>
    80005b4a:	0001b717          	auipc	a4,0x1b
    80005b4e:	32e73703          	ld	a4,814(a4) # 80020e78 <disk+0x8>
    80005b52:	00173713          	seqz	a4,a4
    80005b56:	0017b793          	seqz	a5,a5
    80005b5a:	8fd9                	or	a5,a5,a4
    80005b5c:	e7e9                	bnez	a5,80005c26 <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    80005b5e:	6605                	lui	a2,0x1
    80005b60:	4581                	li	a1,0
    80005b62:	998fb0ef          	jal	80000cfa <memset>
  memset(disk.avail, 0, PGSIZE);
    80005b66:	0001b497          	auipc	s1,0x1b
    80005b6a:	30a48493          	addi	s1,s1,778 # 80020e70 <disk>
    80005b6e:	6605                	lui	a2,0x1
    80005b70:	4581                	li	a1,0
    80005b72:	6488                	ld	a0,8(s1)
    80005b74:	986fb0ef          	jal	80000cfa <memset>
  memset(disk.used, 0, PGSIZE);
    80005b78:	6605                	lui	a2,0x1
    80005b7a:	4581                	li	a1,0
    80005b7c:	6888                	ld	a0,16(s1)
    80005b7e:	97cfb0ef          	jal	80000cfa <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005b82:	100017b7          	lui	a5,0x10001
    80005b86:	4721                	li	a4,8
    80005b88:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005b8a:	4098                	lw	a4,0(s1)
    80005b8c:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005b90:	40d8                	lw	a4,4(s1)
    80005b92:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005b96:	649c                	ld	a5,8(s1)
    80005b98:	10001737          	lui	a4,0x10001
    80005b9c:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ba0:	9781                	srai	a5,a5,0x20
    80005ba2:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005ba6:	689c                	ld	a5,16(s1)
    80005ba8:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005bac:	9781                	srai	a5,a5,0x20
    80005bae:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005bb2:	4785                	li	a5,1
    80005bb4:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005bb6:	00f48c23          	sb	a5,24(s1)
    80005bba:	00f48ca3          	sb	a5,25(s1)
    80005bbe:	00f48d23          	sb	a5,26(s1)
    80005bc2:	00f48da3          	sb	a5,27(s1)
    80005bc6:	00f48e23          	sb	a5,28(s1)
    80005bca:	00f48ea3          	sb	a5,29(s1)
    80005bce:	00f48f23          	sb	a5,30(s1)
    80005bd2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005bd6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005bda:	07272823          	sw	s2,112(a4)
}
    80005bde:	60e2                	ld	ra,24(sp)
    80005be0:	6442                	ld	s0,16(sp)
    80005be2:	64a2                	ld	s1,8(sp)
    80005be4:	6902                	ld	s2,0(sp)
    80005be6:	6105                	addi	sp,sp,32
    80005be8:	8082                	ret
    panic("could not find virtio disk");
    80005bea:	00002517          	auipc	a0,0x2
    80005bee:	b8e50513          	addi	a0,a0,-1138 # 80007778 <etext+0x778>
    80005bf2:	c57fa0ef          	jal	80000848 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005bf6:	00002517          	auipc	a0,0x2
    80005bfa:	ba250513          	addi	a0,a0,-1118 # 80007798 <etext+0x798>
    80005bfe:	c4bfa0ef          	jal	80000848 <panic>
    panic("virtio disk should not be ready");
    80005c02:	00002517          	auipc	a0,0x2
    80005c06:	bb650513          	addi	a0,a0,-1098 # 800077b8 <etext+0x7b8>
    80005c0a:	c3ffa0ef          	jal	80000848 <panic>
    panic("virtio disk has no queue 0");
    80005c0e:	00002517          	auipc	a0,0x2
    80005c12:	bca50513          	addi	a0,a0,-1078 # 800077d8 <etext+0x7d8>
    80005c16:	c33fa0ef          	jal	80000848 <panic>
    panic("virtio disk max queue too short");
    80005c1a:	00002517          	auipc	a0,0x2
    80005c1e:	bde50513          	addi	a0,a0,-1058 # 800077f8 <etext+0x7f8>
    80005c22:	c27fa0ef          	jal	80000848 <panic>
    panic("virtio disk kalloc");
    80005c26:	00002517          	auipc	a0,0x2
    80005c2a:	bf250513          	addi	a0,a0,-1038 # 80007818 <etext+0x818>
    80005c2e:	c1bfa0ef          	jal	80000848 <panic>

0000000080005c32 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005c32:	711d                	addi	sp,sp,-96
    80005c34:	ec86                	sd	ra,88(sp)
    80005c36:	e8a2                	sd	s0,80(sp)
    80005c38:	e4a6                	sd	s1,72(sp)
    80005c3a:	e0ca                	sd	s2,64(sp)
    80005c3c:	fc4e                	sd	s3,56(sp)
    80005c3e:	f852                	sd	s4,48(sp)
    80005c40:	f456                	sd	s5,40(sp)
    80005c42:	f05a                	sd	s6,32(sp)
    80005c44:	ec5e                	sd	s7,24(sp)
    80005c46:	e862                	sd	s8,16(sp)
    80005c48:	1080                	addi	s0,sp,96
    80005c4a:	89aa                	mv	s3,a0
    80005c4c:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005c4e:	00c52b83          	lw	s7,12(a0)
    80005c52:	001b9b9b          	slliw	s7,s7,0x1
    80005c56:	1b82                	slli	s7,s7,0x20
    80005c58:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005c5c:	0001b517          	auipc	a0,0x1b
    80005c60:	33c50513          	addi	a0,a0,828 # 80020f98 <disk+0x128>
    80005c64:	fdbfa0ef          	jal	80000c3e <acquire>
  for (int i = 0; i < NUM; i++) {
    80005c68:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005c6a:	0001ba97          	auipc	s5,0x1b
    80005c6e:	206a8a93          	addi	s5,s5,518 # 80020e70 <disk>
  for (int i = 0; i < 3; i++) {
    80005c72:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005c74:	5c7d                	li	s8,-1
    80005c76:	a8a5                	j	80005cee <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005c78:	00fa8733          	add	a4,s5,a5
    80005c7c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005c80:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005c82:	0207c563          	bltz	a5,80005cac <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005c86:	2905                	addiw	s2,s2,1
    80005c88:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005c8a:	07490663          	beq	s2,s4,80005cf6 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005c8e:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005c90:	0001b717          	auipc	a4,0x1b
    80005c94:	1e070713          	addi	a4,a4,480 # 80020e70 <disk>
    80005c98:	4781                	li	a5,0
    if (disk.free[i]) {
    80005c9a:	01874683          	lbu	a3,24(a4)
    80005c9e:	fee9                	bnez	a3,80005c78 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005ca0:	2785                	addiw	a5,a5,1
    80005ca2:	0705                	addi	a4,a4,1
    80005ca4:	fe979be3          	bne	a5,s1,80005c9a <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005ca8:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80005cac:	01205d63          	blez	s2,80005cc6 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005cb0:	fa042503          	lw	a0,-96(s0)
    80005cb4:	d4fff0ef          	jal	80005a02 <free_desc>
      for (int j = 0; j < i; j++)
    80005cb8:	4785                	li	a5,1
    80005cba:	0127d663          	bge	a5,s2,80005cc6 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005cbe:	fa442503          	lw	a0,-92(s0)
    80005cc2:	d41ff0ef          	jal	80005a02 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80005cc6:	0001b517          	auipc	a0,0x1b
    80005cca:	1c250513          	addi	a0,a0,450 # 80020e88 <disk+0x18>
    80005cce:	a62fc0ef          	jal	80001f30 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005cd2:	0001b517          	auipc	a0,0x1b
    80005cd6:	2c650513          	addi	a0,a0,710 # 80020f98 <disk+0x128>
    80005cda:	fe9fa0ef          	jal	80000cc2 <release>
    sleep();
    80005cde:	a8efc0ef          	jal	80001f6c <sleep>
    acquire(&disk.vdisk_lock);
    80005ce2:	0001b517          	auipc	a0,0x1b
    80005ce6:	2b650513          	addi	a0,a0,694 # 80020f98 <disk+0x128>
    80005cea:	f55fa0ef          	jal	80000c3e <acquire>
  for (int i = 0; i < 3; i++) {
    80005cee:	fa040613          	addi	a2,s0,-96
    80005cf2:	4901                	li	s2,0
    80005cf4:	bf69                	j	80005c8e <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005cf6:	fa042503          	lw	a0,-96(s0)
    80005cfa:	00451693          	slli	a3,a0,0x4

  if (write)
    80005cfe:	0001b797          	auipc	a5,0x1b
    80005d02:	17278793          	addi	a5,a5,370 # 80020e70 <disk>
    80005d06:	00451713          	slli	a4,a0,0x4
    80005d0a:	0a070713          	addi	a4,a4,160
    80005d0e:	973e                	add	a4,a4,a5
    80005d10:	01603633          	snez	a2,s6
    80005d14:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005d16:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005d1a:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005d1e:	6398                	ld	a4,0(a5)
    80005d20:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005d22:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005d26:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005d28:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005d2a:	6390                	ld	a2,0(a5)
    80005d2c:	00d605b3          	add	a1,a2,a3
    80005d30:	4741                	li	a4,16
    80005d32:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005d34:	4805                	li	a6,1
    80005d36:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005d3a:	fa442703          	lw	a4,-92(s0)
    80005d3e:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005d42:	0712                	slli	a4,a4,0x4
    80005d44:	963a                	add	a2,a2,a4
    80005d46:	05898593          	addi	a1,s3,88
    80005d4a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005d4c:	0007b883          	ld	a7,0(a5)
    80005d50:	9746                	add	a4,a4,a7
    80005d52:	40000613          	li	a2,1024
    80005d56:	c710                	sw	a2,8(a4)
  if (write)
    80005d58:	001b3613          	seqz	a2,s6
    80005d5c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005d60:	01066633          	or	a2,a2,a6
    80005d64:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005d68:	fa842583          	lw	a1,-88(s0)
    80005d6c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005d70:	00250613          	addi	a2,a0,2
    80005d74:	0612                	slli	a2,a2,0x4
    80005d76:	963e                	add	a2,a2,a5
    80005d78:	577d                	li	a4,-1
    80005d7a:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005d7e:	0592                	slli	a1,a1,0x4
    80005d80:	98ae                	add	a7,a7,a1
    80005d82:	03068713          	addi	a4,a3,48
    80005d86:	973e                	add	a4,a4,a5
    80005d88:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005d8c:	6398                	ld	a4,0(a5)
    80005d8e:	972e                	add	a4,a4,a1
    80005d90:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005d94:	4689                	li	a3,2
    80005d96:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005d9a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005d9e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005da2:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005da6:	6794                	ld	a3,8(a5)
    80005da8:	0026d703          	lhu	a4,2(a3)
    80005dac:	8b1d                	andi	a4,a4,7
    80005dae:	0706                	slli	a4,a4,0x1
    80005db0:	96ba                	add	a3,a3,a4
    80005db2:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005db6:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005dba:	6798                	ld	a4,8(a5)
    80005dbc:	00275783          	lhu	a5,2(a4)
    80005dc0:	2785                	addiw	a5,a5,1
    80005dc2:	00f71123          	sh	a5,2(a4)
    80005dc6:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005dca:	100017b7          	lui	a5,0x10001
    80005dce:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005dd2:	0049a783          	lw	a5,4(s3)
    80005dd6:	03079663          	bne	a5,a6,80005e02 <virtio_disk_rw+0x1d0>
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005dda:	0001b497          	auipc	s1,0x1b
    80005dde:	1be48493          	addi	s1,s1,446 # 80020f98 <disk+0x128>
  while (b->disk == 1) {
    80005de2:	893e                	mv	s2,a5
    sleep_prepare(b);
    80005de4:	854e                	mv	a0,s3
    80005de6:	94afc0ef          	jal	80001f30 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005dea:	8526                	mv	a0,s1
    80005dec:	ed7fa0ef          	jal	80000cc2 <release>
    sleep();
    80005df0:	97cfc0ef          	jal	80001f6c <sleep>
    acquire(&disk.vdisk_lock);
    80005df4:	8526                	mv	a0,s1
    80005df6:	e49fa0ef          	jal	80000c3e <acquire>
  while (b->disk == 1) {
    80005dfa:	0049a783          	lw	a5,4(s3)
    80005dfe:	ff2783e3          	beq	a5,s2,80005de4 <virtio_disk_rw+0x1b2>
  }

  disk.info[idx[0]].b = 0;
    80005e02:	fa042903          	lw	s2,-96(s0)
    80005e06:	00290713          	addi	a4,s2,2
    80005e0a:	0712                	slli	a4,a4,0x4
    80005e0c:	0001b797          	auipc	a5,0x1b
    80005e10:	06478793          	addi	a5,a5,100 # 80020e70 <disk>
    80005e14:	97ba                	add	a5,a5,a4
    80005e16:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005e1a:	0001b997          	auipc	s3,0x1b
    80005e1e:	05698993          	addi	s3,s3,86 # 80020e70 <disk>
    80005e22:	00491713          	slli	a4,s2,0x4
    80005e26:	0009b783          	ld	a5,0(s3)
    80005e2a:	97ba                	add	a5,a5,a4
    80005e2c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005e30:	854a                	mv	a0,s2
    80005e32:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005e36:	bcdff0ef          	jal	80005a02 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005e3a:	8885                	andi	s1,s1,1
    80005e3c:	f0fd                	bnez	s1,80005e22 <virtio_disk_rw+0x1f0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005e3e:	0001b517          	auipc	a0,0x1b
    80005e42:	15a50513          	addi	a0,a0,346 # 80020f98 <disk+0x128>
    80005e46:	e7dfa0ef          	jal	80000cc2 <release>
}
    80005e4a:	60e6                	ld	ra,88(sp)
    80005e4c:	6446                	ld	s0,80(sp)
    80005e4e:	64a6                	ld	s1,72(sp)
    80005e50:	6906                	ld	s2,64(sp)
    80005e52:	79e2                	ld	s3,56(sp)
    80005e54:	7a42                	ld	s4,48(sp)
    80005e56:	7aa2                	ld	s5,40(sp)
    80005e58:	7b02                	ld	s6,32(sp)
    80005e5a:	6be2                	ld	s7,24(sp)
    80005e5c:	6c42                	ld	s8,16(sp)
    80005e5e:	6125                	addi	sp,sp,96
    80005e60:	8082                	ret

0000000080005e62 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005e62:	1101                	addi	sp,sp,-32
    80005e64:	ec06                	sd	ra,24(sp)
    80005e66:	e822                	sd	s0,16(sp)
    80005e68:	e426                	sd	s1,8(sp)
    80005e6a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005e6c:	0001b497          	auipc	s1,0x1b
    80005e70:	00448493          	addi	s1,s1,4 # 80020e70 <disk>
    80005e74:	0001b517          	auipc	a0,0x1b
    80005e78:	12450513          	addi	a0,a0,292 # 80020f98 <disk+0x128>
    80005e7c:	dc3fa0ef          	jal	80000c3e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005e80:	100017b7          	lui	a5,0x10001
    80005e84:	53bc                	lw	a5,96(a5)
    80005e86:	8b8d                	andi	a5,a5,3
    80005e88:	10001737          	lui	a4,0x10001
    80005e8c:	d37c                	sw	a5,100(a4)
    80005e8e:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005e92:	689c                	ld	a5,16(s1)
    80005e94:	0204d703          	lhu	a4,32(s1)
    80005e98:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005e9c:	04f70663          	beq	a4,a5,80005ee8 <virtio_disk_intr+0x86>
    80005ea0:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ea4:	6898                	ld	a4,16(s1)
    80005ea6:	0204d783          	lhu	a5,32(s1)
    80005eaa:	8b9d                	andi	a5,a5,7
    80005eac:	078e                	slli	a5,a5,0x3
    80005eae:	97ba                	add	a5,a5,a4
    80005eb0:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005eb2:	00278713          	addi	a4,a5,2
    80005eb6:	0712                	slli	a4,a4,0x4
    80005eb8:	9726                	add	a4,a4,s1
    80005eba:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005ebe:	e321                	bnez	a4,80005efe <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ec0:	0789                	addi	a5,a5,2
    80005ec2:	0792                	slli	a5,a5,0x4
    80005ec4:	97a6                	add	a5,a5,s1
    80005ec6:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005ec8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ecc:	8d0fc0ef          	jal	80001f9c <wakeup>

    disk.used_idx += 1;
    80005ed0:	0204d783          	lhu	a5,32(s1)
    80005ed4:	2785                	addiw	a5,a5,1
    80005ed6:	17c2                	slli	a5,a5,0x30
    80005ed8:	93c1                	srli	a5,a5,0x30
    80005eda:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005ede:	6898                	ld	a4,16(s1)
    80005ee0:	00275703          	lhu	a4,2(a4)
    80005ee4:	faf71ee3          	bne	a4,a5,80005ea0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005ee8:	0001b517          	auipc	a0,0x1b
    80005eec:	0b050513          	addi	a0,a0,176 # 80020f98 <disk+0x128>
    80005ef0:	dd3fa0ef          	jal	80000cc2 <release>
}
    80005ef4:	60e2                	ld	ra,24(sp)
    80005ef6:	6442                	ld	s0,16(sp)
    80005ef8:	64a2                	ld	s1,8(sp)
    80005efa:	6105                	addi	sp,sp,32
    80005efc:	8082                	ret
      panic("virtio_disk_intr status");
    80005efe:	00002517          	auipc	a0,0x2
    80005f02:	93250513          	addi	a0,a0,-1742 # 80007830 <etext+0x830>
    80005f06:	943fa0ef          	jal	80000848 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
