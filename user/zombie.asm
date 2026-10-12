
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (fork() > 0)
   8:	2c4000ef          	jal	2cc <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5); // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2c2000ef          	jal	2d4 <exit>
    pause(5); // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	34c000ef          	jal	364 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	2aa000ef          	jal	2d4 <exit>

000000000000002e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0xa>
    ;
  return os;
}
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	cb91                	beqz	a5,6e <strcmp+0x20>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x20>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf91                	beqz	a5,a6 <strlen+0x28>
  8c:	00150793          	addi	a5,a0,1
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x12>
  9a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  9e:	60a2                	ld	ra,8(sp)
  a0:	6402                	ld	s0,0(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret
  for (n = 0; s[n]; n++)
  a6:	4501                	li	a0,0
  a8:	bfdd                	j	9e <strlen+0x20>

00000000000000aa <memset>:

void *
memset(void *dst, int c, uint n)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  b2:	ca19                	beqz	a2,c8 <memset+0x1e>
  b4:	87aa                	mv	a5,a0
  b6:	1602                	slli	a2,a2,0x20
  b8:	9201                	srli	a2,a2,0x20
  ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  be:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  c2:	0785                	addi	a5,a5,1
  c4:	fee79de3          	bne	a5,a4,be <memset+0x14>
  }
  return dst;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char *
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  for (; *s; s++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	c799                	beqz	a5,ea <strchr+0x1a>
    if (*s == c)
  de:	00f58763          	beq	a1,a5,ec <strchr+0x1c>
  for (; *s; s++)
  e2:	0505                	addi	a0,a0,1
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbfd                	bnez	a5,de <strchr+0xe>
      return (char *)s;
  return 0;
  ea:	4501                	li	a0,0
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <gets>:

char *
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	e862                	sd	s8,16(sp)
 10a:	1080                	addi	s0,sp,96
 10c:	8baa                	mv	s7,a0
 10e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 110:	892a                	mv	s2,a0
 112:	4481                	li	s1,0
    cc = read(0, &c, 1);
 114:	faf40b13          	addi	s6,s0,-81
 118:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 11a:	8c26                	mv	s8,s1
 11c:	0014899b          	addiw	s3,s1,1
 120:	84ce                	mv	s1,s3
 122:	0349d863          	bge	s3,s4,152 <gets+0x5e>
    cc = read(0, &c, 1);
 126:	8656                	mv	a2,s5
 128:	85da                	mv	a1,s6
 12a:	4501                	li	a0,0
 12c:	1c0000ef          	jal	2ec <read>
    if (cc < 1)
 130:	02a05163          	blez	a0,152 <gets+0x5e>
      break;
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 13c:	0905                	addi	s2,s2,1
 13e:	ff678713          	addi	a4,a5,-10
 142:	00173713          	seqz	a4,a4
 146:	17cd                	addi	a5,a5,-13
 148:	0017b793          	seqz	a5,a5
 14c:	8fd9                	or	a5,a5,a4
 14e:	d7f1                	beqz	a5,11a <gets+0x26>
    buf[i++] = c;
 150:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 152:	9c5e                	add	s8,s8,s7
 154:	000c0023          	sb	zero,0(s8)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6c42                	ld	s8,16(sp)
 16e:	6125                	addi	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17e:	4581                	li	a1,0
 180:	194000ef          	jal	314 <open>
  if (fd < 0)
 184:	02054263          	bltz	a0,1a8 <stat+0x36>
 188:	e426                	sd	s1,8(sp)
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	19e000ef          	jal	32c <fstat>
 192:	892a                	mv	s2,a0
  close(fd);
 194:	8526                	mv	a0,s1
 196:	166000ef          	jal	2fc <close>
  return r;
 19a:	64a2                	ld	s1,8(sp)
}
 19c:	854a                	mv	a0,s2
 19e:	60e2                	ld	ra,24(sp)
 1a0:	6442                	ld	s0,16(sp)
 1a2:	6902                	ld	s2,0(sp)
 1a4:	6105                	addi	sp,sp,32
 1a6:	8082                	ret
    return -1;
 1a8:	57fd                	li	a5,-1
 1aa:	893e                	mv	s2,a5
 1ac:	bfc5                	j	19c <stat+0x2a>

00000000000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1b6:	00054683          	lbu	a3,0(a0)
 1ba:	fd06879b          	addiw	a5,a3,-48
 1be:	0ff7f793          	zext.b	a5,a5
 1c2:	4625                	li	a2,9
 1c4:	02f66963          	bltu	a2,a5,1f6 <atoi+0x48>
 1c8:	872a                	mv	a4,a0
  n = 0;
 1ca:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1cc:	0705                	addi	a4,a4,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1de:	00074683          	lbu	a3,0(a4)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	fef671e3          	bgeu	a2,a5,1cc <atoi+0x1e>
  return n;
}
 1ee:	60a2                	ld	ra,8(sp)
 1f0:	6402                	ld	s0,0(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  n = 0;
 1f6:	4501                	li	a0,0
 1f8:	bfdd                	j	1ee <atoi+0x40>

00000000000001fa <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 202:	02b57563          	bgeu	a0,a1,22c <memmove+0x32>
    while (n-- > 0)
 206:	00c05f63          	blez	a2,224 <memmove+0x2a>
 20a:	1602                	slli	a2,a2,0x20
 20c:	9201                	srli	a2,a2,0x20
 20e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 212:	872a                	mv	a4,a0
      *dst++ = *src++;
 214:	0585                	addi	a1,a1,1
 216:	0705                	addi	a4,a4,1
 218:	fff5c683          	lbu	a3,-1(a1)
 21c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 220:	fee79ae3          	bne	a5,a4,214 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    while (n-- > 0)
 22c:	fec05ce3          	blez	a2,224 <memmove+0x2a>
    dst += n;
 230:	00c50733          	add	a4,a0,a2
    src += n;
 234:	95b2                	add	a1,a1,a2
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 250:	fef71ae3          	bne	a4,a5,244 <memmove+0x4a>
 254:	bfc1                	j	224 <memmove+0x2a>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25e:	ce19                	beqz	a2,27c <memcmp+0x26>
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 268:	00054783          	lbu	a5,0(a0)
 26c:	0005c703          	lbu	a4,0(a1)
 270:	00e79b63          	bne	a5,a4,286 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 274:	0505                	addi	a0,a0,1
    p2++;
 276:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 278:	fed518e3          	bne	a0,a3,268 <memcmp+0x12>
  }
  return 0;
 27c:	4501                	li	a0,0
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
      return *p1 - *p2;
 286:	40e7853b          	subw	a0,a5,a4
 28a:	bfd5                	j	27e <memcmp+0x28>

000000000000028c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 294:	f67ff0ef          	jal	1fa <memmove>
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <sbrk>:

char *
sbrk(int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2a8:	4585                	li	a1,1
 2aa:	0b2000ef          	jal	35c <sys_sbrk>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrklazy>:

char *
sbrklazy(int n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2be:	4589                	li	a1,2
 2c0:	09c000ef          	jal	35c <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pause>:
.global pause
pause:
 li a7, SYS_pause
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sync>:
.global sync
sync:
 li a7, SYS_sync
 374:	48d9                	li	a7,22
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <trace>:
.global trace
trace:
 li a7, SYS_trace
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 384:	48e1                	li	a7,24
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 38c:	48e5                	li	a7,25
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 394:	1101                	addi	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	1000                	addi	s0,sp,32
 39c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a0:	4605                	li	a2,1
 3a2:	fef40593          	addi	a1,s0,-17
 3a6:	f4fff0ef          	jal	2f4 <write>
}
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	6105                	addi	sp,sp,32
 3b0:	8082                	ret

00000000000003b2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3b2:	715d                	addi	sp,sp,-80
 3b4:	e486                	sd	ra,72(sp)
 3b6:	e0a2                	sd	s0,64(sp)
 3b8:	f84a                	sd	s2,48(sp)
 3ba:	f44e                	sd	s3,40(sp)
 3bc:	0880                	addi	s0,sp,80
 3be:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3c0:	00d036b3          	snez	a3,a3
 3c4:	03f5d793          	srli	a5,a1,0x3f
 3c8:	8efd                	and	a3,a3,a5
  neg = 0;
 3ca:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3cc:	c681                	beqz	a3,3d4 <printint+0x22>
    neg = 1;
    x = -xx;
 3ce:	40b005b3          	neg	a1,a1
    neg = 1;
 3d2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3d8:	86ce                	mv	a3,s3
  i = 0;
 3da:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3dc:	00000817          	auipc	a6,0x0
 3e0:	52c80813          	addi	a6,a6,1324 # 908 <digits>
 3e4:	88ba                	mv	a7,a4
 3e6:	0017051b          	addiw	a0,a4,1
 3ea:	872a                	mv	a4,a0
 3ec:	02c5f7b3          	remu	a5,a1,a2
 3f0:	97c2                	add	a5,a5,a6
 3f2:	0007c783          	lbu	a5,0(a5)
 3f6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3fa:	87ae                	mv	a5,a1
 3fc:	02c5d5b3          	divu	a1,a1,a2
 400:	0685                	addi	a3,a3,1
 402:	fec7f1e3          	bgeu	a5,a2,3e4 <printint+0x32>
  if (neg)
 406:	00030b63          	beqz	t1,41c <printint+0x6a>
    buf[i++] = '-';
 40a:	fd040793          	addi	a5,s0,-48
 40e:	953e                	add	a0,a0,a5
 410:	02d00793          	li	a5,45
 414:	fef50423          	sb	a5,-24(a0)
 418:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 41c:	02e05563          	blez	a4,446 <printint+0x94>
 420:	fc26                	sd	s1,56(sp)
 422:	377d                	addiw	a4,a4,-1
 424:	00e984b3          	add	s1,s3,a4
 428:	19fd                	addi	s3,s3,-1
 42a:	99ba                	add	s3,s3,a4
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 434:	0004c583          	lbu	a1,0(s1)
 438:	854a                	mv	a0,s2
 43a:	f5bff0ef          	jal	394 <putc>
  while (--i >= 0)
 43e:	14fd                	addi	s1,s1,-1
 440:	ff349ae3          	bne	s1,s3,434 <printint+0x82>
 444:	74e2                	ld	s1,56(sp)
}
 446:	60a6                	ld	ra,72(sp)
 448:	6406                	ld	s0,64(sp)
 44a:	7942                	ld	s2,48(sp)
 44c:	79a2                	ld	s3,40(sp)
 44e:	6161                	addi	sp,sp,80
 450:	8082                	ret

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	711d                	addi	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 45c:	0005c483          	lbu	s1,0(a1)
 460:	2a048063          	beqz	s1,700 <vprintf+0x2ae>
 464:	e0ca                	sd	s2,64(sp)
 466:	fc4e                	sd	s3,56(sp)
 468:	f852                	sd	s4,48(sp)
 46a:	f456                	sd	s5,40(sp)
 46c:	f05a                	sd	s6,32(sp)
 46e:	ec5e                	sd	s7,24(sp)
 470:	e862                	sd	s8,16(sp)
 472:	8b2a                	mv	s6,a0
 474:	8a2e                	mv	s4,a1
 476:	8bb2                	mv	s7,a2
  state = 0;
 478:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 47a:	4901                	li	s2,0
 47c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 47e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 482:	06400c13          	li	s8,100
 486:	a00d                	j	4a8 <vprintf+0x56>
        putc(fd, c0);
 488:	85a6                	mv	a1,s1
 48a:	855a                	mv	a0,s6
 48c:	f09ff0ef          	jal	394 <putc>
 490:	a019                	j	496 <vprintf+0x44>
    } else if (state == '%') {
 492:	03598363          	beq	s3,s5,4b8 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 496:	0019079b          	addiw	a5,s2,1
 49a:	893e                	mv	s2,a5
 49c:	873e                	mv	a4,a5
 49e:	97d2                	add	a5,a5,s4
 4a0:	0007c483          	lbu	s1,0(a5)
 4a4:	24048763          	beqz	s1,6f2 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4a8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4ac:	fe0993e3          	bnez	s3,492 <vprintf+0x40>
      if (c0 == '%') {
 4b0:	fd579ce3          	bne	a5,s5,488 <vprintf+0x36>
        state = '%';
 4b4:	89be                	mv	s3,a5
 4b6:	b7c5                	j	496 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4b8:	00ea06b3          	add	a3,s4,a4
 4bc:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4c0:	24060563          	beqz	a2,70a <vprintf+0x2b8>
      if (c0 == 'd') {
 4c4:	0b878763          	beq	a5,s8,572 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4c8:	f9478693          	addi	a3,a5,-108
 4cc:	0016b693          	seqz	a3,a3
 4d0:	f9c60593          	addi	a1,a2,-100
 4d4:	0015b593          	seqz	a1,a1
 4d8:	8df5                	and	a1,a1,a3
 4da:	e9c5                	bnez	a1,58a <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4dc:	9752                	add	a4,a4,s4
 4de:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4e2:	f9460713          	addi	a4,a2,-108
 4e6:	00173713          	seqz	a4,a4
 4ea:	8f75                	and	a4,a4,a3
 4ec:	f9c50593          	addi	a1,a0,-100
 4f0:	0015b593          	seqz	a1,a1
 4f4:	8df9                	and	a1,a1,a4
 4f6:	e5dd                	bnez	a1,5a4 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4f8:	07500593          	li	a1,117
 4fc:	0cb78163          	beq	a5,a1,5be <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 500:	f8b60593          	addi	a1,a2,-117
 504:	0015b593          	seqz	a1,a1
 508:	8df5                	and	a1,a1,a3
 50a:	e5f1                	bnez	a1,5d6 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 50c:	f8b50593          	addi	a1,a0,-117
 510:	0015b593          	seqz	a1,a1
 514:	8df9                	and	a1,a1,a4
 516:	ede9                	bnez	a1,5f0 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 518:	07800593          	li	a1,120
 51c:	0eb78763          	beq	a5,a1,60a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 520:	f8860613          	addi	a2,a2,-120
 524:	00163613          	seqz	a2,a2
 528:	8ef1                	and	a3,a3,a2
 52a:	0e069c63          	bnez	a3,622 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 52e:	f8850513          	addi	a0,a0,-120
 532:	00153513          	seqz	a0,a0
 536:	8f69                	and	a4,a4,a0
 538:	10071263          	bnez	a4,63c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 53c:	07000713          	li	a4,112
 540:	10e78a63          	beq	a5,a4,654 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 544:	06300713          	li	a4,99
 548:	14e78a63          	beq	a5,a4,69c <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 54c:	07300713          	li	a4,115
 550:	16e78063          	beq	a5,a4,6b0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 554:	02500713          	li	a4,37
 558:	18e78863          	beq	a5,a4,6e8 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55c:	02500593          	li	a1,37
 560:	855a                	mv	a0,s6
 562:	e33ff0ef          	jal	394 <putc>
        putc(fd, c0);
 566:	85a6                	mv	a1,s1
 568:	855a                	mv	a0,s6
 56a:	e2bff0ef          	jal	394 <putc>
      }

      state = 0;
 56e:	4981                	li	s3,0
 570:	b71d                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b8493          	addi	s1,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e33ff0ef          	jal	3b2 <printint>
 584:	8ba6                	mv	s7,s1
      state = 0;
 586:	4981                	li	s3,0
 588:	b739                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e1bff0ef          	jal	3b2 <printint>
        i += 1;
 59c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bdd5                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e01ff0ef          	jal	3b2 <printint>
        i += 2;
 5b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
        i += 2;
 5bc:	bde9                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000be583          	lwu	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	de7ff0ef          	jal	3b2 <printint>
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b5c9                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	dcfff0ef          	jal	3b2 <printint>
        i += 1;
 5e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b565                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	db5ff0ef          	jal	3b2 <printint>
        i += 2;
 602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	b579                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4641                	li	a2,16
 612:	000be583          	lwu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	d9bff0ef          	jal	3b2 <printint>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	bd9d                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	d83ff0ef          	jal	3b2 <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	bdb1                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4641                	li	a2,16
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	d6bff0ef          	jal	3b2 <printint>
        i += 2;
 64c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
        i += 2;
 652:	b591                	j	496 <vprintf+0x44>
 654:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 656:	008b8793          	addi	a5,s7,8
 65a:	8cbe                	mv	s9,a5
 65c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 660:	03000593          	li	a1,48
 664:	855a                	mv	a0,s6
 666:	d2fff0ef          	jal	394 <putc>
  putc(fd, 'x');
 66a:	07800593          	li	a1,120
 66e:	855a                	mv	a0,s6
 670:	d25ff0ef          	jal	394 <putc>
 674:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 676:	00000b97          	auipc	s7,0x0
 67a:	292b8b93          	addi	s7,s7,658 # 908 <digits>
 67e:	03c9d793          	srli	a5,s3,0x3c
 682:	97de                	add	a5,a5,s7
 684:	0007c583          	lbu	a1,0(a5)
 688:	855a                	mv	a0,s6
 68a:	d0bff0ef          	jal	394 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68e:	0992                	slli	s3,s3,0x4
 690:	34fd                	addiw	s1,s1,-1
 692:	f4f5                	bnez	s1,67e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 694:	8be6                	mv	s7,s9
      state = 0;
 696:	4981                	li	s3,0
 698:	6ca2                	ld	s9,8(sp)
 69a:	bbf5                	j	496 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 69c:	008b8493          	addi	s1,s7,8
 6a0:	000bc583          	lbu	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	cefff0ef          	jal	394 <putc>
 6aa:	8ba6                	mv	s7,s1
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b3e5                	j	496 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6b0:	008b8993          	addi	s3,s7,8
 6b4:	000bb483          	ld	s1,0(s7)
 6b8:	cc91                	beqz	s1,6d4 <vprintf+0x282>
        for (; *s; s++)
 6ba:	0004c583          	lbu	a1,0(s1)
 6be:	c195                	beqz	a1,6e2 <vprintf+0x290>
          putc(fd, *s);
 6c0:	855a                	mv	a0,s6
 6c2:	cd3ff0ef          	jal	394 <putc>
        for (; *s; s++)
 6c6:	0485                	addi	s1,s1,1
 6c8:	0004c583          	lbu	a1,0(s1)
 6cc:	f9f5                	bnez	a1,6c0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b3d1                	j	496 <vprintf+0x44>
          s = "(null)";
 6d4:	00000497          	auipc	s1,0x0
 6d8:	22c48493          	addi	s1,s1,556 # 900 <malloc+0xfa>
        for (; *s; s++)
 6dc:	02800593          	li	a1,40
 6e0:	b7c5                	j	6c0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6e2:	8bce                	mv	s7,s3
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bb45                	j	496 <vprintf+0x44>
        putc(fd, '%');
 6e8:	85be                	mv	a1,a5
 6ea:	855a                	mv	a0,s6
 6ec:	ca9ff0ef          	jal	394 <putc>
 6f0:	bdbd                	j	56e <vprintf+0x11c>
 6f2:	6906                	ld	s2,64(sp)
 6f4:	79e2                	ld	s3,56(sp)
 6f6:	7a42                	ld	s4,48(sp)
 6f8:	7aa2                	ld	s5,40(sp)
 6fa:	7b02                	ld	s6,32(sp)
 6fc:	6be2                	ld	s7,24(sp)
 6fe:	6c42                	ld	s8,16(sp)
    }
  }
}
 700:	60e6                	ld	ra,88(sp)
 702:	6446                	ld	s0,80(sp)
 704:	64a6                	ld	s1,72(sp)
 706:	6125                	addi	sp,sp,96
 708:	8082                	ret
      if (c0 == 'd') {
 70a:	06400713          	li	a4,100
 70e:	e6e782e3          	beq	a5,a4,572 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 712:	f9478693          	addi	a3,a5,-108
 716:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 71a:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 71c:	4701                	li	a4,0
 71e:	bbe9                	j	4f8 <vprintf+0xa6>

0000000000000720 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 720:	715d                	addi	sp,sp,-80
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e010                	sd	a2,0(s0)
 72a:	e414                	sd	a3,8(s0)
 72c:	e818                	sd	a4,16(s0)
 72e:	ec1c                	sd	a5,24(s0)
 730:	03043023          	sd	a6,32(s0)
 734:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	8622                	mv	a2,s0
 73a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73e:	d15ff0ef          	jal	452 <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e40c                	sd	a1,8(s0)
 754:	e810                	sd	a2,16(s0)
 756:	ec14                	sd	a3,24(s0)
 758:	f018                	sd	a4,32(s0)
 75a:	f41c                	sd	a5,40(s0)
 75c:	03043823          	sd	a6,48(s0)
 760:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	00840613          	addi	a2,s0,8
 768:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76c:	85aa                	mv	a1,a0
 76e:	4505                	li	a0,1
 770:	ce3ff0ef          	jal	452 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6125                	addi	sp,sp,96
 77a:	8082                	ret

000000000000077c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77c:	1141                	addi	sp,sp,-16
 77e:	e406                	sd	ra,8(sp)
 780:	e022                	sd	s0,0(sp)
 782:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 784:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	00001797          	auipc	a5,0x1
 78c:	8787b783          	ld	a5,-1928(a5) # 1000 <freep>
 790:	a095                	j	7f4 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 792:	ff852583          	lw	a1,-8(a0)
 796:	6390                	ld	a2,0(a5)
 798:	02059813          	slli	a6,a1,0x20
 79c:	01c85693          	srli	a3,a6,0x1c
 7a0:	96ba                	add	a3,a3,a4
 7a2:	02d60563          	beq	a2,a3,7cc <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7aa:	4790                	lw	a2,8(a5)
 7ac:	02061593          	slli	a1,a2,0x20
 7b0:	01c5d693          	srli	a3,a1,0x1c
 7b4:	96be                	add	a3,a3,a5
 7b6:	02d70263          	beq	a4,a3,7da <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ba:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7bc:	00001717          	auipc	a4,0x1
 7c0:	84f73223          	sd	a5,-1980(a4) # 1000 <freep>
}
 7c4:	60a2                	ld	ra,8(sp)
 7c6:	6402                	ld	s0,0(sp)
 7c8:	0141                	addi	sp,sp,16
 7ca:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7cc:	4614                	lw	a3,8(a2)
 7ce:	9ead                	addw	a3,a3,a1
 7d0:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	6394                	ld	a3,0(a5)
 7d6:	6290                	ld	a2,0(a3)
 7d8:	b7f9                	j	7a6 <free+0x2a>
    p->s.size += bp->s.size;
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9f31                	addw	a4,a4,a2
 7e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e2:	ff053703          	ld	a4,-16(a0)
 7e6:	bfd1                	j	7ba <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	6394                	ld	a3,0(a5)
 7ea:	00d7e463          	bltu	a5,a3,7f2 <free+0x76>
 7ee:	fad762e3          	bltu	a4,a3,792 <free+0x16>
 7f2:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	fee7fae3          	bgeu	a5,a4,7e8 <free+0x6c>
 7f8:	6394                	ld	a3,0(a5)
 7fa:	f8d76ce3          	bltu	a4,a3,792 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	f8d7fae3          	bgeu	a5,a3,792 <free+0x16>
 802:	87b6                	mv	a5,a3
 804:	bfc5                	j	7f4 <free+0x78>

0000000000000806 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 806:	7139                	addi	sp,sp,-64
 808:	fc06                	sd	ra,56(sp)
 80a:	f822                	sd	s0,48(sp)
 80c:	f04a                	sd	s2,32(sp)
 80e:	ec4e                	sd	s3,24(sp)
 810:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 812:	02051993          	slli	s3,a0,0x20
 816:	0209d993          	srli	s3,s3,0x20
 81a:	09bd                	addi	s3,s3,15
 81c:	0049d993          	srli	s3,s3,0x4
 820:	2985                	addiw	s3,s3,1
 822:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 824:	00000517          	auipc	a0,0x0
 828:	7dc53503          	ld	a0,2012(a0) # 1000 <freep>
 82c:	c905                	beqz	a0,85c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 82e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 830:	4798                	lw	a4,8(a5)
 832:	09377663          	bgeu	a4,s3,8be <malloc+0xb8>
 836:	f426                	sd	s1,40(sp)
 838:	e852                	sd	s4,16(sp)
 83a:	e456                	sd	s5,8(sp)
 83c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 83e:	8a4e                	mv	s4,s3
 840:	6705                	lui	a4,0x1
 842:	00e9f363          	bgeu	s3,a4,848 <malloc+0x42>
 846:	6a05                	lui	s4,0x1
 848:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 850:	00000497          	auipc	s1,0x0
 854:	7b048493          	addi	s1,s1,1968 # 1000 <freep>
  if (p == SBRK_ERROR)
 858:	5afd                	li	s5,-1
 85a:	a83d                	j	898 <malloc+0x92>
 85c:	f426                	sd	s1,40(sp)
 85e:	e852                	sd	s4,16(sp)
 860:	e456                	sd	s5,8(sp)
 862:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 864:	00000797          	auipc	a5,0x0
 868:	7ac78793          	addi	a5,a5,1964 # 1010 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 87a:	b7d1                	j	83e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	a899                	j	8d6 <malloc+0xd0>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	ef5ff0ef          	jal	77c <free>
  return freep;
 88c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 88e:	c125                	beqz	a0,8ee <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 890:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 892:	4798                	lw	a4,8(a5)
 894:	03277163          	bgeu	a4,s2,8b6 <malloc+0xb0>
    if (p == freep)
 898:	6098                	ld	a4,0(s1)
 89a:	853e                	mv	a0,a5
 89c:	fef71ae3          	bne	a4,a5,890 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8a0:	8552                	mv	a0,s4
 8a2:	9ffff0ef          	jal	2a0 <sbrk>
  if (p == SBRK_ERROR)
 8a6:	fd551ee3          	bne	a0,s5,882 <malloc+0x7c>
        return 0;
 8aa:	4501                	li	a0,0
 8ac:	74a2                	ld	s1,40(sp)
 8ae:	6a42                	ld	s4,16(sp)
 8b0:	6aa2                	ld	s5,8(sp)
 8b2:	6b02                	ld	s6,0(sp)
 8b4:	a03d                	j	8e2 <malloc+0xdc>
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8be:	fae90fe3          	beq	s2,a4,87c <malloc+0x76>
        p->s.size -= nunits;
 8c2:	4137073b          	subw	a4,a4,s3
 8c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c8:	02071693          	slli	a3,a4,0x20
 8cc:	01c6d713          	srli	a4,a3,0x1c
 8d0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d6:	00000717          	auipc	a4,0x0
 8da:	72a73523          	sd	a0,1834(a4) # 1000 <freep>
      return (void *)(p + 1);
 8de:	01078513          	addi	a0,a5,16
  }
}
 8e2:	70e2                	ld	ra,56(sp)
 8e4:	7442                	ld	s0,48(sp)
 8e6:	7902                	ld	s2,32(sp)
 8e8:	69e2                	ld	s3,24(sp)
 8ea:	6121                	addi	sp,sp,64
 8ec:	8082                	ret
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
 8f6:	b7f5                	j	8e2 <malloc+0xdc>
