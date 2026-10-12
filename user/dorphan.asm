
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if (mkdir("dd") != 0) {
   c:	00001517          	auipc	a0,0x1
  10:	96450513          	addi	a0,a0,-1692 # 970 <malloc+0xfc>
  14:	396000ef          	jal	3aa <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	95c50513          	addi	a0,a0,-1700 # 978 <malloc+0x104>
  24:	794000ef          	jal	7b8 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	318000ef          	jal	342 <exit>
  }

  if (chdir("dd") != 0) {
  2e:	00001517          	auipc	a0,0x1
  32:	94250513          	addi	a0,a0,-1726 # 970 <malloc+0xfc>
  36:	37c000ef          	jal	3b2 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	95250513          	addi	a0,a0,-1710 # 990 <malloc+0x11c>
  46:	772000ef          	jal	7b8 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2f6000ef          	jal	342 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	95850513          	addi	a0,a0,-1704 # 9a8 <malloc+0x134>
  58:	33a000ef          	jal	392 <unlink>
  5c:	00054e63          	bltz	a0,78 <main+0x78>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	96850513          	addi	a0,a0,-1688 # 9c8 <malloc+0x154>
  68:	750000ef          	jal	7b8 <printf>
  // sit around until killed
  for (;;)
    pause(1000);
  6c:	3e800493          	li	s1,1000
  70:	8526                	mv	a0,s1
  72:	360000ef          	jal	3d2 <pause>
  for (;;)
  76:	bfed                	j	70 <main+0x70>
    printf("%s: unlink failed\n", s);
  78:	85a6                	mv	a1,s1
  7a:	00001517          	auipc	a0,0x1
  7e:	93650513          	addi	a0,a0,-1738 # 9b0 <malloc+0x13c>
  82:	736000ef          	jal	7b8 <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	2ba000ef          	jal	342 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	2aa000ef          	jal	342 <exit>

000000000000009c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf91                	beqz	a5,114 <strlen+0x28>
  fa:	00150793          	addi	a5,a0,1
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 10c:	60a2                	ld	ra,8(sp)
 10e:	6402                	ld	s0,0(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  for (n = 0; s[n]; n++)
 114:	4501                	li	a0,0
 116:	bfdd                	j	10c <strlen+0x20>

0000000000000118 <memset>:

void *
memset(void *dst, int c, uint n)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 120:	ca19                	beqz	a2,136 <memset+0x1e>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x14>
  }
  return dst;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strchr>:

char *
strchr(const char *s, char c)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  for (; *s; s++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	c799                	beqz	a5,158 <strchr+0x1a>
    if (*s == c)
 14c:	00f58763          	beq	a1,a5,15a <strchr+0x1c>
  for (; *s; s++)
 150:	0505                	addi	a0,a0,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbfd                	bnez	a5,14c <strchr+0xe>
      return (char *)s;
  return 0;
 158:	4501                	li	a0,0
}
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <gets>:

char *
gets(char *buf, int max)
{
 162:	711d                	addi	sp,sp,-96
 164:	ec86                	sd	ra,88(sp)
 166:	e8a2                	sd	s0,80(sp)
 168:	e4a6                	sd	s1,72(sp)
 16a:	e0ca                	sd	s2,64(sp)
 16c:	fc4e                	sd	s3,56(sp)
 16e:	f852                	sd	s4,48(sp)
 170:	f456                	sd	s5,40(sp)
 172:	f05a                	sd	s6,32(sp)
 174:	ec5e                	sd	s7,24(sp)
 176:	e862                	sd	s8,16(sp)
 178:	1080                	addi	s0,sp,96
 17a:	8baa                	mv	s7,a0
 17c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 17e:	892a                	mv	s2,a0
 180:	4481                	li	s1,0
    cc = read(0, &c, 1);
 182:	faf40b13          	addi	s6,s0,-81
 186:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 188:	8c26                	mv	s8,s1
 18a:	0014899b          	addiw	s3,s1,1
 18e:	84ce                	mv	s1,s3
 190:	0349d863          	bge	s3,s4,1c0 <gets+0x5e>
    cc = read(0, &c, 1);
 194:	8656                	mv	a2,s5
 196:	85da                	mv	a1,s6
 198:	4501                	li	a0,0
 19a:	1c0000ef          	jal	35a <read>
    if (cc < 1)
 19e:	02a05163          	blez	a0,1c0 <gets+0x5e>
      break;
    buf[i++] = c;
 1a2:	faf44783          	lbu	a5,-81(s0)
 1a6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1aa:	0905                	addi	s2,s2,1
 1ac:	ff678713          	addi	a4,a5,-10
 1b0:	00173713          	seqz	a4,a4
 1b4:	17cd                	addi	a5,a5,-13
 1b6:	0017b793          	seqz	a5,a5
 1ba:	8fd9                	or	a5,a5,a4
 1bc:	d7f1                	beqz	a5,188 <gets+0x26>
    buf[i++] = c;
 1be:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1c0:	9c5e                	add	s8,s8,s7
 1c2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1c6:	855e                	mv	a0,s7
 1c8:	60e6                	ld	ra,88(sp)
 1ca:	6446                	ld	s0,80(sp)
 1cc:	64a6                	ld	s1,72(sp)
 1ce:	6906                	ld	s2,64(sp)
 1d0:	79e2                	ld	s3,56(sp)
 1d2:	7a42                	ld	s4,48(sp)
 1d4:	7aa2                	ld	s5,40(sp)
 1d6:	7b02                	ld	s6,32(sp)
 1d8:	6be2                	ld	s7,24(sp)
 1da:	6c42                	ld	s8,16(sp)
 1dc:	6125                	addi	sp,sp,96
 1de:	8082                	ret

00000000000001e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e0:	1101                	addi	sp,sp,-32
 1e2:	ec06                	sd	ra,24(sp)
 1e4:	e822                	sd	s0,16(sp)
 1e6:	e04a                	sd	s2,0(sp)
 1e8:	1000                	addi	s0,sp,32
 1ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ec:	4581                	li	a1,0
 1ee:	194000ef          	jal	382 <open>
  if (fd < 0)
 1f2:	02054263          	bltz	a0,216 <stat+0x36>
 1f6:	e426                	sd	s1,8(sp)
 1f8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1fa:	85ca                	mv	a1,s2
 1fc:	19e000ef          	jal	39a <fstat>
 200:	892a                	mv	s2,a0
  close(fd);
 202:	8526                	mv	a0,s1
 204:	166000ef          	jal	36a <close>
  return r;
 208:	64a2                	ld	s1,8(sp)
}
 20a:	854a                	mv	a0,s2
 20c:	60e2                	ld	ra,24(sp)
 20e:	6442                	ld	s0,16(sp)
 210:	6902                	ld	s2,0(sp)
 212:	6105                	addi	sp,sp,32
 214:	8082                	ret
    return -1;
 216:	57fd                	li	a5,-1
 218:	893e                	mv	s2,a5
 21a:	bfc5                	j	20a <stat+0x2a>

000000000000021c <atoi>:

int
atoi(const char *s)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 224:	00054683          	lbu	a3,0(a0)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	4625                	li	a2,9
 232:	02f66963          	bltu	a2,a5,264 <atoi+0x48>
 236:	872a                	mv	a4,a0
  n = 0;
 238:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 23a:	0705                	addi	a4,a4,1
 23c:	0025179b          	slliw	a5,a0,0x2
 240:	9fa9                	addw	a5,a5,a0
 242:	0017979b          	slliw	a5,a5,0x1
 246:	9fb5                	addw	a5,a5,a3
 248:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 24c:	00074683          	lbu	a3,0(a4)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	fef671e3          	bgeu	a2,a5,23a <atoi+0x1e>
  return n;
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  n = 0;
 264:	4501                	li	a0,0
 266:	bfdd                	j	25c <atoi+0x40>

0000000000000268 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57563          	bgeu	a0,a1,29a <memmove+0x32>
    while (n-- > 0)
 274:	00c05f63          	blez	a2,292 <memmove+0x2a>
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 280:	872a                	mv	a4,a0
      *dst++ = *src++;
 282:	0585                	addi	a1,a1,1
 284:	0705                	addi	a4,a4,1
 286:	fff5c683          	lbu	a3,-1(a1)
 28a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
    while (n-- > 0)
 29a:	fec05ce3          	blez	a2,292 <memmove+0x2a>
    dst += n;
 29e:	00c50733          	add	a4,a0,a2
    src += n;
 2a2:	95b2                	add	a1,a1,a2
 2a4:	fff6079b          	addiw	a5,a2,-1
 2a8:	1782                	slli	a5,a5,0x20
 2aa:	9381                	srli	a5,a5,0x20
 2ac:	fff7c793          	not	a5,a5
 2b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b2:	15fd                	addi	a1,a1,-1
 2b4:	177d                	addi	a4,a4,-1
 2b6:	0005c683          	lbu	a3,0(a1)
 2ba:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2be:	fef71ae3          	bne	a4,a5,2b2 <memmove+0x4a>
 2c2:	bfc1                	j	292 <memmove+0x2a>

00000000000002c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2cc:	ce19                	beqz	a2,2ea <memcmp+0x26>
 2ce:	1602                	slli	a2,a2,0x20
 2d0:	9201                	srli	a2,a2,0x20
 2d2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	00e79b63          	bne	a5,a4,2f4 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2e2:	0505                	addi	a0,a0,1
    p2++;
 2e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e6:	fed518e3          	bne	a0,a3,2d6 <memcmp+0x12>
  }
  return 0;
 2ea:	4501                	li	a0,0
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
      return *p1 - *p2;
 2f4:	40e7853b          	subw	a0,a5,a4
 2f8:	bfd5                	j	2ec <memcmp+0x28>

00000000000002fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 302:	f67ff0ef          	jal	268 <memmove>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <sbrk>:

char *
sbrk(int n)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 316:	4585                	li	a1,1
 318:	0b2000ef          	jal	3ca <sys_sbrk>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <sbrklazy>:

char *
sbrklazy(int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 32c:	4589                	li	a1,2
 32e:	09c000ef          	jal	3ca <sys_sbrk>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33a:	4885                	li	a7,1
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exit>:
.global exit
exit:
 li a7, SYS_exit
 342:	4889                	li	a7,2
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <wait>:
.global wait
wait:
 li a7, SYS_wait
 34a:	488d                	li	a7,3
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 352:	4891                	li	a7,4
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <read>:
.global read
read:
 li a7, SYS_read
 35a:	4895                	li	a7,5
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <write>:
.global write
write:
 li a7, SYS_write
 362:	48c1                	li	a7,16
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <close>:
.global close
close:
 li a7, SYS_close
 36a:	48d5                	li	a7,21
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <kill>:
.global kill
kill:
 li a7, SYS_kill
 372:	4899                	li	a7,6
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exec>:
.global exec
exec:
 li a7, SYS_exec
 37a:	489d                	li	a7,7
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <open>:
.global open
open:
 li a7, SYS_open
 382:	48bd                	li	a7,15
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38a:	48c5                	li	a7,17
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 392:	48c9                	li	a7,18
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39a:	48a1                	li	a7,8
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <link>:
.global link
link:
 li a7, SYS_link
 3a2:	48cd                	li	a7,19
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3aa:	48d1                	li	a7,20
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b2:	48a5                	li	a7,9
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ba:	48a9                	li	a7,10
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c2:	48ad                	li	a7,11
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ca:	48b1                	li	a7,12
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3d2:	48b5                	li	a7,13
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3da:	48b9                	li	a7,14
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3e2:	48d9                	li	a7,22
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ea:	48dd                	li	a7,23
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3f2:	48e1                	li	a7,24
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 3fa:	48e5                	li	a7,25
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 402:	1101                	addi	sp,sp,-32
 404:	ec06                	sd	ra,24(sp)
 406:	e822                	sd	s0,16(sp)
 408:	1000                	addi	s0,sp,32
 40a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40e:	4605                	li	a2,1
 410:	fef40593          	addi	a1,s0,-17
 414:	f4fff0ef          	jal	362 <write>
}
 418:	60e2                	ld	ra,24(sp)
 41a:	6442                	ld	s0,16(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret

0000000000000420 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 420:	715d                	addi	sp,sp,-80
 422:	e486                	sd	ra,72(sp)
 424:	e0a2                	sd	s0,64(sp)
 426:	f84a                	sd	s2,48(sp)
 428:	f44e                	sd	s3,40(sp)
 42a:	0880                	addi	s0,sp,80
 42c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 42e:	00d036b3          	snez	a3,a3
 432:	03f5d793          	srli	a5,a1,0x3f
 436:	8efd                	and	a3,a3,a5
  neg = 0;
 438:	4301                	li	t1,0
  if (sgn && xx < 0) {
 43a:	c681                	beqz	a3,442 <printint+0x22>
    neg = 1;
    x = -xx;
 43c:	40b005b3          	neg	a1,a1
    neg = 1;
 440:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 442:	fb840993          	addi	s3,s0,-72
  neg = 0;
 446:	86ce                	mv	a3,s3
  i = 0;
 448:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 44a:	00000817          	auipc	a6,0x0
 44e:	5a680813          	addi	a6,a6,1446 # 9f0 <digits>
 452:	88ba                	mv	a7,a4
 454:	0017051b          	addiw	a0,a4,1
 458:	872a                	mv	a4,a0
 45a:	02c5f7b3          	remu	a5,a1,a2
 45e:	97c2                	add	a5,a5,a6
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 468:	87ae                	mv	a5,a1
 46a:	02c5d5b3          	divu	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec7f1e3          	bgeu	a5,a2,452 <printint+0x32>
  if (neg)
 474:	00030b63          	beqz	t1,48a <printint+0x6a>
    buf[i++] = '-';
 478:	fd040793          	addi	a5,s0,-48
 47c:	953e                	add	a0,a0,a5
 47e:	02d00793          	li	a5,45
 482:	fef50423          	sb	a5,-24(a0)
 486:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 48a:	02e05563          	blez	a4,4b4 <printint+0x94>
 48e:	fc26                	sd	s1,56(sp)
 490:	377d                	addiw	a4,a4,-1
 492:	00e984b3          	add	s1,s3,a4
 496:	19fd                	addi	s3,s3,-1
 498:	99ba                	add	s3,s3,a4
 49a:	1702                	slli	a4,a4,0x20
 49c:	9301                	srli	a4,a4,0x20
 49e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a2:	0004c583          	lbu	a1,0(s1)
 4a6:	854a                	mv	a0,s2
 4a8:	f5bff0ef          	jal	402 <putc>
  while (--i >= 0)
 4ac:	14fd                	addi	s1,s1,-1
 4ae:	ff349ae3          	bne	s1,s3,4a2 <printint+0x82>
 4b2:	74e2                	ld	s1,56(sp)
}
 4b4:	60a6                	ld	ra,72(sp)
 4b6:	6406                	ld	s0,64(sp)
 4b8:	7942                	ld	s2,48(sp)
 4ba:	79a2                	ld	s3,40(sp)
 4bc:	6161                	addi	sp,sp,80
 4be:	8082                	ret

00000000000004c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c0:	711d                	addi	sp,sp,-96
 4c2:	ec86                	sd	ra,88(sp)
 4c4:	e8a2                	sd	s0,80(sp)
 4c6:	e4a6                	sd	s1,72(sp)
 4c8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4ca:	0005c483          	lbu	s1,0(a1)
 4ce:	2a048063          	beqz	s1,76e <vprintf+0x2ae>
 4d2:	e0ca                	sd	s2,64(sp)
 4d4:	fc4e                	sd	s3,56(sp)
 4d6:	f852                	sd	s4,48(sp)
 4d8:	f456                	sd	s5,40(sp)
 4da:	f05a                	sd	s6,32(sp)
 4dc:	ec5e                	sd	s7,24(sp)
 4de:	e862                	sd	s8,16(sp)
 4e0:	8b2a                	mv	s6,a0
 4e2:	8a2e                	mv	s4,a1
 4e4:	8bb2                	mv	s7,a2
  state = 0;
 4e6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4e8:	4901                	li	s2,0
 4ea:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4f0:	06400c13          	li	s8,100
 4f4:	a00d                	j	516 <vprintf+0x56>
        putc(fd, c0);
 4f6:	85a6                	mv	a1,s1
 4f8:	855a                	mv	a0,s6
 4fa:	f09ff0ef          	jal	402 <putc>
 4fe:	a019                	j	504 <vprintf+0x44>
    } else if (state == '%') {
 500:	03598363          	beq	s3,s5,526 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 504:	0019079b          	addiw	a5,s2,1
 508:	893e                	mv	s2,a5
 50a:	873e                	mv	a4,a5
 50c:	97d2                	add	a5,a5,s4
 50e:	0007c483          	lbu	s1,0(a5)
 512:	24048763          	beqz	s1,760 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 516:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 51a:	fe0993e3          	bnez	s3,500 <vprintf+0x40>
      if (c0 == '%') {
 51e:	fd579ce3          	bne	a5,s5,4f6 <vprintf+0x36>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7c5                	j	504 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 526:	00ea06b3          	add	a3,s4,a4
 52a:	0016c603          	lbu	a2,1(a3)
      if (c1)
 52e:	24060563          	beqz	a2,778 <vprintf+0x2b8>
      if (c0 == 'd') {
 532:	0b878763          	beq	a5,s8,5e0 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 536:	f9478693          	addi	a3,a5,-108
 53a:	0016b693          	seqz	a3,a3
 53e:	f9c60593          	addi	a1,a2,-100
 542:	0015b593          	seqz	a1,a1
 546:	8df5                	and	a1,a1,a3
 548:	e9c5                	bnez	a1,5f8 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 54a:	9752                	add	a4,a4,s4
 54c:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 550:	f9460713          	addi	a4,a2,-108
 554:	00173713          	seqz	a4,a4
 558:	8f75                	and	a4,a4,a3
 55a:	f9c50593          	addi	a1,a0,-100
 55e:	0015b593          	seqz	a1,a1
 562:	8df9                	and	a1,a1,a4
 564:	e5dd                	bnez	a1,612 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 566:	07500593          	li	a1,117
 56a:	0cb78163          	beq	a5,a1,62c <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 56e:	f8b60593          	addi	a1,a2,-117
 572:	0015b593          	seqz	a1,a1
 576:	8df5                	and	a1,a1,a3
 578:	e5f1                	bnez	a1,644 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 57a:	f8b50593          	addi	a1,a0,-117
 57e:	0015b593          	seqz	a1,a1
 582:	8df9                	and	a1,a1,a4
 584:	ede9                	bnez	a1,65e <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 586:	07800593          	li	a1,120
 58a:	0eb78763          	beq	a5,a1,678 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 58e:	f8860613          	addi	a2,a2,-120
 592:	00163613          	seqz	a2,a2
 596:	8ef1                	and	a3,a3,a2
 598:	0e069c63          	bnez	a3,690 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 59c:	f8850513          	addi	a0,a0,-120
 5a0:	00153513          	seqz	a0,a0
 5a4:	8f69                	and	a4,a4,a0
 5a6:	10071263          	bnez	a4,6aa <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5aa:	07000713          	li	a4,112
 5ae:	10e78a63          	beq	a5,a4,6c2 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5b2:	06300713          	li	a4,99
 5b6:	14e78a63          	beq	a5,a4,70a <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5ba:	07300713          	li	a4,115
 5be:	16e78063          	beq	a5,a4,71e <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5c2:	02500713          	li	a4,37
 5c6:	18e78863          	beq	a5,a4,756 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	855a                	mv	a0,s6
 5d0:	e33ff0ef          	jal	402 <putc>
        putc(fd, c0);
 5d4:	85a6                	mv	a1,s1
 5d6:	855a                	mv	a0,s6
 5d8:	e2bff0ef          	jal	402 <putc>
      }

      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b71d                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e33ff0ef          	jal	420 <printint>
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b739                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e1bff0ef          	jal	420 <printint>
        i += 1;
 60a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	bdd5                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	008b8493          	addi	s1,s7,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e01ff0ef          	jal	420 <printint>
        i += 2;
 624:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	bde9                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000be583          	lwu	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	de7ff0ef          	jal	420 <printint>
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	b5c9                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	dcfff0ef          	jal	420 <printint>
        i += 1;
 656:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b565                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	db5ff0ef          	jal	420 <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	b579                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000be583          	lwu	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	d9bff0ef          	jal	420 <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bd9d                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d83ff0ef          	jal	420 <printint>
        i += 1;
 6a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bdb1                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4641                	li	a2,16
 6b0:	000bb583          	ld	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d6bff0ef          	jal	420 <printint>
        i += 2;
 6ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
        i += 2;
 6c0:	b591                	j	504 <vprintf+0x44>
 6c2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6c4:	008b8793          	addi	a5,s7,8
 6c8:	8cbe                	mv	s9,a5
 6ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ce:	03000593          	li	a1,48
 6d2:	855a                	mv	a0,s6
 6d4:	d2fff0ef          	jal	402 <putc>
  putc(fd, 'x');
 6d8:	07800593          	li	a1,120
 6dc:	855a                	mv	a0,s6
 6de:	d25ff0ef          	jal	402 <putc>
 6e2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e4:	00000b97          	auipc	s7,0x0
 6e8:	30cb8b93          	addi	s7,s7,780 # 9f0 <digits>
 6ec:	03c9d793          	srli	a5,s3,0x3c
 6f0:	97de                	add	a5,a5,s7
 6f2:	0007c583          	lbu	a1,0(a5)
 6f6:	855a                	mv	a0,s6
 6f8:	d0bff0ef          	jal	402 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fc:	0992                	slli	s3,s3,0x4
 6fe:	34fd                	addiw	s1,s1,-1
 700:	f4f5                	bnez	s1,6ec <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 702:	8be6                	mv	s7,s9
      state = 0;
 704:	4981                	li	s3,0
 706:	6ca2                	ld	s9,8(sp)
 708:	bbf5                	j	504 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 70a:	008b8493          	addi	s1,s7,8
 70e:	000bc583          	lbu	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	cefff0ef          	jal	402 <putc>
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b3e5                	j	504 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 71e:	008b8993          	addi	s3,s7,8
 722:	000bb483          	ld	s1,0(s7)
 726:	cc91                	beqz	s1,742 <vprintf+0x282>
        for (; *s; s++)
 728:	0004c583          	lbu	a1,0(s1)
 72c:	c195                	beqz	a1,750 <vprintf+0x290>
          putc(fd, *s);
 72e:	855a                	mv	a0,s6
 730:	cd3ff0ef          	jal	402 <putc>
        for (; *s; s++)
 734:	0485                	addi	s1,s1,1
 736:	0004c583          	lbu	a1,0(s1)
 73a:	f9f5                	bnez	a1,72e <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b3d1                	j	504 <vprintf+0x44>
          s = "(null)";
 742:	00000497          	auipc	s1,0x0
 746:	2a648493          	addi	s1,s1,678 # 9e8 <malloc+0x174>
        for (; *s; s++)
 74a:	02800593          	li	a1,40
 74e:	b7c5                	j	72e <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	bb45                	j	504 <vprintf+0x44>
        putc(fd, '%');
 756:	85be                	mv	a1,a5
 758:	855a                	mv	a0,s6
 75a:	ca9ff0ef          	jal	402 <putc>
 75e:	bdbd                	j	5dc <vprintf+0x11c>
 760:	6906                	ld	s2,64(sp)
 762:	79e2                	ld	s3,56(sp)
 764:	7a42                	ld	s4,48(sp)
 766:	7aa2                	ld	s5,40(sp)
 768:	7b02                	ld	s6,32(sp)
 76a:	6be2                	ld	s7,24(sp)
 76c:	6c42                	ld	s8,16(sp)
    }
  }
}
 76e:	60e6                	ld	ra,88(sp)
 770:	6446                	ld	s0,80(sp)
 772:	64a6                	ld	s1,72(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret
      if (c0 == 'd') {
 778:	06400713          	li	a4,100
 77c:	e6e782e3          	beq	a5,a4,5e0 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 780:	f9478693          	addi	a3,a5,-108
 784:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 788:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 78a:	4701                	li	a4,0
 78c:	bbe9                	j	566 <vprintf+0xa6>

000000000000078e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78e:	715d                	addi	sp,sp,-80
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e010                	sd	a2,0(s0)
 798:	e414                	sd	a3,8(s0)
 79a:	e818                	sd	a4,16(s0)
 79c:	ec1c                	sd	a5,24(s0)
 79e:	03043023          	sd	a6,32(s0)
 7a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	8622                	mv	a2,s0
 7a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ac:	d15ff0ef          	jal	4c0 <vprintf>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6161                	addi	sp,sp,80
 7b6:	8082                	ret

00000000000007b8 <printf>:

void
printf(const char *fmt, ...)
{
 7b8:	711d                	addi	sp,sp,-96
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e40c                	sd	a1,8(s0)
 7c2:	e810                	sd	a2,16(s0)
 7c4:	ec14                	sd	a3,24(s0)
 7c6:	f018                	sd	a4,32(s0)
 7c8:	f41c                	sd	a5,40(s0)
 7ca:	03043823          	sd	a6,48(s0)
 7ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	00840613          	addi	a2,s0,8
 7d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7da:	85aa                	mv	a1,a0
 7dc:	4505                	li	a0,1
 7de:	ce3ff0ef          	jal	4c0 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6125                	addi	sp,sp,96
 7e8:	8082                	ret

00000000000007ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ea:	1141                	addi	sp,sp,-16
 7ec:	e406                	sd	ra,8(sp)
 7ee:	e022                	sd	s0,0(sp)
 7f0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7f2:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	00001797          	auipc	a5,0x1
 7fa:	80a7b783          	ld	a5,-2038(a5) # 1000 <freep>
 7fe:	a095                	j	862 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 800:	ff852583          	lw	a1,-8(a0)
 804:	6390                	ld	a2,0(a5)
 806:	02059813          	slli	a6,a1,0x20
 80a:	01c85693          	srli	a3,a6,0x1c
 80e:	96ba                	add	a3,a3,a4
 810:	02d60563          	beq	a2,a3,83a <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 818:	4790                	lw	a2,8(a5)
 81a:	02061593          	slli	a1,a2,0x20
 81e:	01c5d693          	srli	a3,a1,0x1c
 822:	96be                	add	a3,a3,a5
 824:	02d70263          	beq	a4,a3,848 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 828:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82a:	00000717          	auipc	a4,0x0
 82e:	7cf73b23          	sd	a5,2006(a4) # 1000 <freep>
}
 832:	60a2                	ld	ra,8(sp)
 834:	6402                	ld	s0,0(sp)
 836:	0141                	addi	sp,sp,16
 838:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 83a:	4614                	lw	a3,8(a2)
 83c:	9ead                	addw	a3,a3,a1
 83e:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	6394                	ld	a3,0(a5)
 844:	6290                	ld	a2,0(a3)
 846:	b7f9                	j	814 <free+0x2a>
    p->s.size += bp->s.size;
 848:	ff852703          	lw	a4,-8(a0)
 84c:	9f31                	addw	a4,a4,a2
 84e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 850:	ff053703          	ld	a4,-16(a0)
 854:	bfd1                	j	828 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6394                	ld	a3,0(a5)
 858:	00d7e463          	bltu	a5,a3,860 <free+0x76>
 85c:	fad762e3          	bltu	a4,a3,800 <free+0x16>
 860:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fee7fae3          	bgeu	a5,a4,856 <free+0x6c>
 866:	6394                	ld	a3,0(a5)
 868:	f8d76ce3          	bltu	a4,a3,800 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	f8d7fae3          	bgeu	a5,a3,800 <free+0x16>
 870:	87b6                	mv	a5,a3
 872:	bfc5                	j	862 <free+0x78>

0000000000000874 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 874:	7139                	addi	sp,sp,-64
 876:	fc06                	sd	ra,56(sp)
 878:	f822                	sd	s0,48(sp)
 87a:	f04a                	sd	s2,32(sp)
 87c:	ec4e                	sd	s3,24(sp)
 87e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 880:	02051993          	slli	s3,a0,0x20
 884:	0209d993          	srli	s3,s3,0x20
 888:	09bd                	addi	s3,s3,15
 88a:	0049d993          	srli	s3,s3,0x4
 88e:	2985                	addiw	s3,s3,1
 890:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 892:	00000517          	auipc	a0,0x0
 896:	76e53503          	ld	a0,1902(a0) # 1000 <freep>
 89a:	c905                	beqz	a0,8ca <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 89c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 89e:	4798                	lw	a4,8(a5)
 8a0:	09377663          	bgeu	a4,s3,92c <malloc+0xb8>
 8a4:	f426                	sd	s1,40(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8ac:	8a4e                	mv	s4,s3
 8ae:	6705                	lui	a4,0x1
 8b0:	00e9f363          	bgeu	s3,a4,8b6 <malloc+0x42>
 8b4:	6a05                	lui	s4,0x1
 8b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8be:	00000497          	auipc	s1,0x0
 8c2:	74248493          	addi	s1,s1,1858 # 1000 <freep>
  if (p == SBRK_ERROR)
 8c6:	5afd                	li	s5,-1
 8c8:	a83d                	j	906 <malloc+0x92>
 8ca:	f426                	sd	s1,40(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d2:	00001797          	auipc	a5,0x1
 8d6:	93678793          	addi	a5,a5,-1738 # 1208 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8e8:	b7d1                	j	8ac <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	e118                	sd	a4,0(a0)
 8ee:	a899                	j	944 <malloc+0xd0>
  hp->s.size = nu;
 8f0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8f4:	0541                	addi	a0,a0,16
 8f6:	ef5ff0ef          	jal	7ea <free>
  return freep;
 8fa:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8fc:	c125                	beqz	a0,95c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8fe:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 900:	4798                	lw	a4,8(a5)
 902:	03277163          	bgeu	a4,s2,924 <malloc+0xb0>
    if (p == freep)
 906:	6098                	ld	a4,0(s1)
 908:	853e                	mv	a0,a5
 90a:	fef71ae3          	bne	a4,a5,8fe <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 90e:	8552                	mv	a0,s4
 910:	9ffff0ef          	jal	30e <sbrk>
  if (p == SBRK_ERROR)
 914:	fd551ee3          	bne	a0,s5,8f0 <malloc+0x7c>
        return 0;
 918:	4501                	li	a0,0
 91a:	74a2                	ld	s1,40(sp)
 91c:	6a42                	ld	s4,16(sp)
 91e:	6aa2                	ld	s5,8(sp)
 920:	6b02                	ld	s6,0(sp)
 922:	a03d                	j	950 <malloc+0xdc>
 924:	74a2                	ld	s1,40(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 92c:	fae90fe3          	beq	s2,a4,8ea <malloc+0x76>
        p->s.size -= nunits;
 930:	4137073b          	subw	a4,a4,s3
 934:	c798                	sw	a4,8(a5)
        p += p->s.size;
 936:	02071693          	slli	a3,a4,0x20
 93a:	01c6d713          	srli	a4,a3,0x1c
 93e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 940:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 944:	00000717          	auipc	a4,0x0
 948:	6aa73e23          	sd	a0,1724(a4) # 1000 <freep>
      return (void *)(p + 1);
 94c:	01078513          	addi	a0,a5,16
  }
}
 950:	70e2                	ld	ra,56(sp)
 952:	7442                	ld	s0,48(sp)
 954:	7902                	ld	s2,32(sp)
 956:	69e2                	ld	s3,24(sp)
 958:	6121                	addi	sp,sp,64
 95a:	8082                	ret
 95c:	74a2                	ld	s1,40(sp)
 95e:	6a42                	ld	s4,16(sp)
 960:	6aa2                	ld	s5,8(sp)
 962:	6b02                	ld	s6,0(sp)
 964:	b7f5                	j	950 <malloc+0xdc>
