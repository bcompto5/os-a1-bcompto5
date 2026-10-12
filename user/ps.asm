
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7d413023          	sd	s4,1984(sp)
  1c:	7f010413          	addi	s0,sp,2032
  20:	dc010113          	addi	sp,sp,-576
  struct uproc p[64];
  int n, i;
  char *state;

  n = getprocs(p, 64);
  24:	04000593          	li	a1,64
  28:	dd040513          	addi	a0,s0,-560
  2c:	80050513          	addi	a0,a0,-2048
  30:	432000ef          	jal	462 <getprocs>
  if(n < 0){
  34:	02054a63          	bltz	a0,68 <main+0x68>
  38:	892a                	mv	s2,a0
    fprintf(2, "ps: getprocs failed\n");
    exit(1);
  }

  printf("PID\tPPID\tSTATE\tSIZE\tNAME\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	9f650513          	addi	a0,a0,-1546 # a30 <malloc+0x154>
  42:	7de000ef          	jal	820 <printf>

  for(i = 0; i < n; i++){
  46:	0b205463          	blez	s2,ee <main+0xee>
  4a:	dd040493          	addi	s1,s0,-560
  4e:	81848493          	addi	s1,s1,-2024
  52:	02800793          	li	a5,40
  56:	02f90933          	mul	s2,s2,a5
  5a:	9926                	add	s2,s2,s1
  5c:	4a15                	li	s4,5
  5e:	00001997          	auipc	s3,0x1
  62:	a1298993          	addi	s3,s3,-1518 # a70 <malloc+0x194>
  66:	a885                	j	d6 <main+0xd6>
    fprintf(2, "ps: getprocs failed\n");
  68:	00001597          	auipc	a1,0x1
  6c:	9b058593          	addi	a1,a1,-1616 # a18 <malloc+0x13c>
  70:	4509                	li	a0,2
  72:	784000ef          	jal	7f6 <fprintf>
    exit(1);
  76:	4505                	li	a0,1
  78:	332000ef          	jal	3aa <exit>
    state = "???";

    // Values follow enum procstate in kernel/proc.h.
    if(p[i].state == 1)
  7c:	00001697          	auipc	a3,0x1
  80:	99468693          	addi	a3,a3,-1644 # a10 <malloc+0x134>
  84:	a80d                	j	b6 <main+0xb6>
  86:	00001697          	auipc	a3,0x1
  8a:	95a68693          	addi	a3,a3,-1702 # 9e0 <malloc+0x104>
  8e:	a025                	j	b6 <main+0xb6>
  90:	00001697          	auipc	a3,0x1
  94:	96068693          	addi	a3,a3,-1696 # 9f0 <malloc+0x114>
  98:	a839                	j	b6 <main+0xb6>
  9a:	00001697          	auipc	a3,0x1
  9e:	96668693          	addi	a3,a3,-1690 # a00 <malloc+0x124>
  a2:	a811                	j	b6 <main+0xb6>
    else if(p[i].state == 3)
      state = "runnable";
    else if(p[i].state == 4)
      state = "running";
    else if(p[i].state == 5)
      state = "zombie";
  a4:	00001697          	auipc	a3,0x1
  a8:	96468693          	addi	a3,a3,-1692 # a08 <malloc+0x12c>
  ac:	a029                	j	b6 <main+0xb6>
    if(p[i].state == 1)
  ae:	00001697          	auipc	a3,0x1
  b2:	92268693          	addi	a3,a3,-1758 # 9d0 <malloc+0xf4>

    printf("%d\t%d\t%s\t%lu\t%s\n",
  b6:	ff87b703          	ld	a4,-8(a5)
  ba:	fec7a603          	lw	a2,-20(a5)
  be:	fe87a583          	lw	a1,-24(a5)
  c2:	00001517          	auipc	a0,0x1
  c6:	98e50513          	addi	a0,a0,-1650 # a50 <malloc+0x174>
  ca:	756000ef          	jal	820 <printf>
  for(i = 0; i < n; i++){
  ce:	02848493          	addi	s1,s1,40
  d2:	01248e63          	beq	s1,s2,ee <main+0xee>
    if(p[i].state == 1)
  d6:	87a6                	mv	a5,s1
  d8:	ff04a703          	lw	a4,-16(s1)
  dc:	faea60e3          	bltu	s4,a4,7c <main+0x7c>
  e0:	ff04e703          	lwu	a4,-16(s1)
  e4:	070a                	slli	a4,a4,0x2
  e6:	974e                	add	a4,a4,s3
  e8:	4318                	lw	a4,0(a4)
  ea:	974e                	add	a4,a4,s3
  ec:	8702                	jr	a4
           p[i].pid, p[i].ppid, state, p[i].sz, p[i].name);
  }

  exit(0);
  ee:	4501                	li	a0,0
  f0:	2ba000ef          	jal	3aa <exit>

00000000000000f4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fc:	f05ff0ef          	jal	0 <main>
  exit(r);
 100:	2aa000ef          	jal	3aa <exit>

0000000000000104 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 10c:	87aa                	mv	a5,a0
 10e:	0585                	addi	a1,a1,1
 110:	0785                	addi	a5,a5,1
 112:	fff5c703          	lbu	a4,-1(a1)
 116:	fee78fa3          	sb	a4,-1(a5)
 11a:	fb75                	bnez	a4,10e <strcpy+0xa>
    ;
  return os;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	1141                	addi	sp,sp,-16
 126:	e406                	sd	ra,8(sp)
 128:	e022                	sd	s0,0(sp)
 12a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb91                	beqz	a5,144 <strcmp+0x20>
 132:	0005c703          	lbu	a4,0(a1)
 136:	00f71763          	bne	a4,a5,144 <strcmp+0x20>
    p++, q++;
 13a:	0505                	addi	a0,a0,1
 13c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbe5                	bnez	a5,132 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 144:	0005c503          	lbu	a0,0(a1)
}
 148:	40a7853b          	subw	a0,a5,a0
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:

uint
strlen(const char *s)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cf91                	beqz	a5,17c <strlen+0x28>
 162:	00150793          	addi	a5,a0,1
 166:	86be                	mv	a3,a5
 168:	0785                	addi	a5,a5,1
 16a:	fff7c703          	lbu	a4,-1(a5)
 16e:	ff65                	bnez	a4,166 <strlen+0x12>
 170:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 174:	60a2                	ld	ra,8(sp)
 176:	6402                	ld	s0,0(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret
  for (n = 0; s[n]; n++)
 17c:	4501                	li	a0,0
 17e:	bfdd                	j	174 <strlen+0x20>

0000000000000180 <memset>:

void *
memset(void *dst, int c, uint n)
{
 180:	1141                	addi	sp,sp,-16
 182:	e406                	sd	ra,8(sp)
 184:	e022                	sd	s0,0(sp)
 186:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 188:	ca19                	beqz	a2,19e <memset+0x1e>
 18a:	87aa                	mv	a5,a0
 18c:	1602                	slli	a2,a2,0x20
 18e:	9201                	srli	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x14>
  }
  return dst;
}
 19e:	60a2                	ld	ra,8(sp)
 1a0:	6402                	ld	s0,0(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char *
strchr(const char *s, char c)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e406                	sd	ra,8(sp)
 1aa:	e022                	sd	s0,0(sp)
 1ac:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	c799                	beqz	a5,1c0 <strchr+0x1a>
    if (*s == c)
 1b4:	00f58763          	beq	a1,a5,1c2 <strchr+0x1c>
  for (; *s; s++)
 1b8:	0505                	addi	a0,a0,1
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbfd                	bnez	a5,1b4 <strchr+0xe>
      return (char *)s;
  return 0;
 1c0:	4501                	li	a0,0
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <gets>:

char *
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	e862                	sd	s8,16(sp)
 1e0:	1080                	addi	s0,sp,96
 1e2:	8baa                	mv	s7,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ea:	faf40b13          	addi	s6,s0,-81
 1ee:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1f0:	8c26                	mv	s8,s1
 1f2:	0014899b          	addiw	s3,s1,1
 1f6:	84ce                	mv	s1,s3
 1f8:	0349d863          	bge	s3,s4,228 <gets+0x5e>
    cc = read(0, &c, 1);
 1fc:	8656                	mv	a2,s5
 1fe:	85da                	mv	a1,s6
 200:	4501                	li	a0,0
 202:	1c0000ef          	jal	3c2 <read>
    if (cc < 1)
 206:	02a05163          	blez	a0,228 <gets+0x5e>
      break;
    buf[i++] = c;
 20a:	faf44783          	lbu	a5,-81(s0)
 20e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 212:	0905                	addi	s2,s2,1
 214:	ff678713          	addi	a4,a5,-10
 218:	00173713          	seqz	a4,a4
 21c:	17cd                	addi	a5,a5,-13
 21e:	0017b793          	seqz	a5,a5
 222:	8fd9                	or	a5,a5,a4
 224:	d7f1                	beqz	a5,1f0 <gets+0x26>
    buf[i++] = c;
 226:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 228:	9c5e                	add	s8,s8,s7
 22a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22e:	855e                	mv	a0,s7
 230:	60e6                	ld	ra,88(sp)
 232:	6446                	ld	s0,80(sp)
 234:	64a6                	ld	s1,72(sp)
 236:	6906                	ld	s2,64(sp)
 238:	79e2                	ld	s3,56(sp)
 23a:	7a42                	ld	s4,48(sp)
 23c:	7aa2                	ld	s5,40(sp)
 23e:	7b02                	ld	s6,32(sp)
 240:	6be2                	ld	s7,24(sp)
 242:	6c42                	ld	s8,16(sp)
 244:	6125                	addi	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	194000ef          	jal	3ea <open>
  if (fd < 0)
 25a:	02054263          	bltz	a0,27e <stat+0x36>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	19e000ef          	jal	402 <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	166000ef          	jal	3d2 <close>
  return r;
 270:	64a2                	ld	s1,8(sp)
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	57fd                	li	a5,-1
 280:	893e                	mv	s2,a5
 282:	bfc5                	j	272 <stat+0x2a>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66963          	bltu	a2,a5,2cc <atoi+0x48>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2a2:	0705                	addi	a4,a4,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1e>
  return n;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  n = 0;
 2cc:	4501                	li	a0,0
 2ce:	bfdd                	j	2c4 <atoi+0x40>

00000000000002d0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d8:	02b57563          	bgeu	a0,a1,302 <memmove+0x32>
    while (n-- > 0)
 2dc:	00c05f63          	blez	a2,2fa <memmove+0x2a>
 2e0:	1602                	slli	a2,a2,0x20
 2e2:	9201                	srli	a2,a2,0x20
 2e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ea:	0585                	addi	a1,a1,1
 2ec:	0705                	addi	a4,a4,1
 2ee:	fff5c683          	lbu	a3,-1(a1)
 2f2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
    while (n-- > 0)
 302:	fec05ce3          	blez	a2,2fa <memmove+0x2a>
    dst += n;
 306:	00c50733          	add	a4,a0,a2
    src += n;
 30a:	95b2                	add	a1,a1,a2
 30c:	fff6079b          	addiw	a5,a2,-1
 310:	1782                	slli	a5,a5,0x20
 312:	9381                	srli	a5,a5,0x20
 314:	fff7c793          	not	a5,a5
 318:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31a:	15fd                	addi	a1,a1,-1
 31c:	177d                	addi	a4,a4,-1
 31e:	0005c683          	lbu	a3,0(a1)
 322:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 326:	fef71ae3          	bne	a4,a5,31a <memmove+0x4a>
 32a:	bfc1                	j	2fa <memmove+0x2a>

000000000000032c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	ce19                	beqz	a2,352 <memcmp+0x26>
 336:	1602                	slli	a2,a2,0x20
 338:	9201                	srli	a2,a2,0x20
 33a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 33e:	00054783          	lbu	a5,0(a0)
 342:	0005c703          	lbu	a4,0(a1)
 346:	00e79b63          	bne	a5,a4,35c <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 34a:	0505                	addi	a0,a0,1
    p2++;
 34c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34e:	fed518e3          	bne	a0,a3,33e <memcmp+0x12>
  }
  return 0;
 352:	4501                	li	a0,0
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
      return *p1 - *p2;
 35c:	40e7853b          	subw	a0,a5,a4
 360:	bfd5                	j	354 <memcmp+0x28>

0000000000000362 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36a:	f67ff0ef          	jal	2d0 <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <sbrk>:

char *
sbrk(int n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 37e:	4585                	li	a1,1
 380:	0b2000ef          	jal	432 <sys_sbrk>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <sbrklazy>:

char *
sbrklazy(int n)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e406                	sd	ra,8(sp)
 390:	e022                	sd	s0,0(sp)
 392:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 394:	4589                	li	a1,2
 396:	09c000ef          	jal	432 <sys_sbrk>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <pause>:
.global pause
pause:
 li a7, SYS_pause
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sync>:
.global sync
sync:
 li a7, SYS_sync
 44a:	48d9                	li	a7,22
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <trace>:
.global trace
trace:
 li a7, SYS_trace
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 45a:	48e1                	li	a7,24
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 462:	48e5                	li	a7,25
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46a:	1101                	addi	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	1000                	addi	s0,sp,32
 472:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 476:	4605                	li	a2,1
 478:	fef40593          	addi	a1,s0,-17
 47c:	f4fff0ef          	jal	3ca <write>
}
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	6105                	addi	sp,sp,32
 486:	8082                	ret

0000000000000488 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 488:	715d                	addi	sp,sp,-80
 48a:	e486                	sd	ra,72(sp)
 48c:	e0a2                	sd	s0,64(sp)
 48e:	f84a                	sd	s2,48(sp)
 490:	f44e                	sd	s3,40(sp)
 492:	0880                	addi	s0,sp,80
 494:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 496:	00d036b3          	snez	a3,a3
 49a:	03f5d793          	srli	a5,a1,0x3f
 49e:	8efd                	and	a3,a3,a5
  neg = 0;
 4a0:	4301                	li	t1,0
  if (sgn && xx < 0) {
 4a2:	c681                	beqz	a3,4aa <printint+0x22>
    neg = 1;
    x = -xx;
 4a4:	40b005b3          	neg	a1,a1
    neg = 1;
 4a8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4aa:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4ae:	86ce                	mv	a3,s3
  i = 0;
 4b0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4b2:	00000817          	auipc	a6,0x0
 4b6:	5d680813          	addi	a6,a6,1494 # a88 <digits>
 4ba:	88ba                	mv	a7,a4
 4bc:	0017051b          	addiw	a0,a4,1
 4c0:	872a                	mv	a4,a0
 4c2:	02c5f7b3          	remu	a5,a1,a2
 4c6:	97c2                	add	a5,a5,a6
 4c8:	0007c783          	lbu	a5,0(a5)
 4cc:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4d0:	87ae                	mv	a5,a1
 4d2:	02c5d5b3          	divu	a1,a1,a2
 4d6:	0685                	addi	a3,a3,1
 4d8:	fec7f1e3          	bgeu	a5,a2,4ba <printint+0x32>
  if (neg)
 4dc:	00030b63          	beqz	t1,4f2 <printint+0x6a>
    buf[i++] = '-';
 4e0:	fd040793          	addi	a5,s0,-48
 4e4:	953e                	add	a0,a0,a5
 4e6:	02d00793          	li	a5,45
 4ea:	fef50423          	sb	a5,-24(a0)
 4ee:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4f2:	02e05563          	blez	a4,51c <printint+0x94>
 4f6:	fc26                	sd	s1,56(sp)
 4f8:	377d                	addiw	a4,a4,-1
 4fa:	00e984b3          	add	s1,s3,a4
 4fe:	19fd                	addi	s3,s3,-1
 500:	99ba                	add	s3,s3,a4
 502:	1702                	slli	a4,a4,0x20
 504:	9301                	srli	a4,a4,0x20
 506:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50a:	0004c583          	lbu	a1,0(s1)
 50e:	854a                	mv	a0,s2
 510:	f5bff0ef          	jal	46a <putc>
  while (--i >= 0)
 514:	14fd                	addi	s1,s1,-1
 516:	ff349ae3          	bne	s1,s3,50a <printint+0x82>
 51a:	74e2                	ld	s1,56(sp)
}
 51c:	60a6                	ld	ra,72(sp)
 51e:	6406                	ld	s0,64(sp)
 520:	7942                	ld	s2,48(sp)
 522:	79a2                	ld	s3,40(sp)
 524:	6161                	addi	sp,sp,80
 526:	8082                	ret

0000000000000528 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 528:	711d                	addi	sp,sp,-96
 52a:	ec86                	sd	ra,88(sp)
 52c:	e8a2                	sd	s0,80(sp)
 52e:	e4a6                	sd	s1,72(sp)
 530:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 532:	0005c483          	lbu	s1,0(a1)
 536:	2a048063          	beqz	s1,7d6 <vprintf+0x2ae>
 53a:	e0ca                	sd	s2,64(sp)
 53c:	fc4e                	sd	s3,56(sp)
 53e:	f852                	sd	s4,48(sp)
 540:	f456                	sd	s5,40(sp)
 542:	f05a                	sd	s6,32(sp)
 544:	ec5e                	sd	s7,24(sp)
 546:	e862                	sd	s8,16(sp)
 548:	8b2a                	mv	s6,a0
 54a:	8a2e                	mv	s4,a1
 54c:	8bb2                	mv	s7,a2
  state = 0;
 54e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 550:	4901                	li	s2,0
 552:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 554:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 558:	06400c13          	li	s8,100
 55c:	a00d                	j	57e <vprintf+0x56>
        putc(fd, c0);
 55e:	85a6                	mv	a1,s1
 560:	855a                	mv	a0,s6
 562:	f09ff0ef          	jal	46a <putc>
 566:	a019                	j	56c <vprintf+0x44>
    } else if (state == '%') {
 568:	03598363          	beq	s3,s5,58e <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 56c:	0019079b          	addiw	a5,s2,1
 570:	893e                	mv	s2,a5
 572:	873e                	mv	a4,a5
 574:	97d2                	add	a5,a5,s4
 576:	0007c483          	lbu	s1,0(a5)
 57a:	24048763          	beqz	s1,7c8 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 57e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 582:	fe0993e3          	bnez	s3,568 <vprintf+0x40>
      if (c0 == '%') {
 586:	fd579ce3          	bne	a5,s5,55e <vprintf+0x36>
        state = '%';
 58a:	89be                	mv	s3,a5
 58c:	b7c5                	j	56c <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 58e:	00ea06b3          	add	a3,s4,a4
 592:	0016c603          	lbu	a2,1(a3)
      if (c1)
 596:	24060563          	beqz	a2,7e0 <vprintf+0x2b8>
      if (c0 == 'd') {
 59a:	0b878763          	beq	a5,s8,648 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 59e:	f9478693          	addi	a3,a5,-108
 5a2:	0016b693          	seqz	a3,a3
 5a6:	f9c60593          	addi	a1,a2,-100
 5aa:	0015b593          	seqz	a1,a1
 5ae:	8df5                	and	a1,a1,a3
 5b0:	e9c5                	bnez	a1,660 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 5b2:	9752                	add	a4,a4,s4
 5b4:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5b8:	f9460713          	addi	a4,a2,-108
 5bc:	00173713          	seqz	a4,a4
 5c0:	8f75                	and	a4,a4,a3
 5c2:	f9c50593          	addi	a1,a0,-100
 5c6:	0015b593          	seqz	a1,a1
 5ca:	8df9                	and	a1,a1,a4
 5cc:	e5dd                	bnez	a1,67a <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5ce:	07500593          	li	a1,117
 5d2:	0cb78163          	beq	a5,a1,694 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5d6:	f8b60593          	addi	a1,a2,-117
 5da:	0015b593          	seqz	a1,a1
 5de:	8df5                	and	a1,a1,a3
 5e0:	e5f1                	bnez	a1,6ac <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5e2:	f8b50593          	addi	a1,a0,-117
 5e6:	0015b593          	seqz	a1,a1
 5ea:	8df9                	and	a1,a1,a4
 5ec:	ede9                	bnez	a1,6c6 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5ee:	07800593          	li	a1,120
 5f2:	0eb78763          	beq	a5,a1,6e0 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5f6:	f8860613          	addi	a2,a2,-120
 5fa:	00163613          	seqz	a2,a2
 5fe:	8ef1                	and	a3,a3,a2
 600:	0e069c63          	bnez	a3,6f8 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 604:	f8850513          	addi	a0,a0,-120
 608:	00153513          	seqz	a0,a0
 60c:	8f69                	and	a4,a4,a0
 60e:	10071263          	bnez	a4,712 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 612:	07000713          	li	a4,112
 616:	10e78a63          	beq	a5,a4,72a <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 61a:	06300713          	li	a4,99
 61e:	14e78a63          	beq	a5,a4,772 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 622:	07300713          	li	a4,115
 626:	16e78063          	beq	a5,a4,786 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 62a:	02500713          	li	a4,37
 62e:	18e78863          	beq	a5,a4,7be <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 632:	02500593          	li	a1,37
 636:	855a                	mv	a0,s6
 638:	e33ff0ef          	jal	46a <putc>
        putc(fd, c0);
 63c:	85a6                	mv	a1,s1
 63e:	855a                	mv	a0,s6
 640:	e2bff0ef          	jal	46a <putc>
      }

      state = 0;
 644:	4981                	li	s3,0
 646:	b71d                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 648:	008b8493          	addi	s1,s7,8
 64c:	4685                	li	a3,1
 64e:	4629                	li	a2,10
 650:	000ba583          	lw	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e33ff0ef          	jal	488 <printint>
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b739                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	008b8493          	addi	s1,s7,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	e1bff0ef          	jal	488 <printint>
        i += 1;
 672:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
 678:	bdd5                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67a:	008b8493          	addi	s1,s7,8
 67e:	4685                	li	a3,1
 680:	4629                	li	a2,10
 682:	000bb583          	ld	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	e01ff0ef          	jal	488 <printint>
        i += 2;
 68c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
        i += 2;
 692:	bde9                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 694:	008b8493          	addi	s1,s7,8
 698:	4681                	li	a3,0
 69a:	4629                	li	a2,10
 69c:	000be583          	lwu	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	de7ff0ef          	jal	488 <printint>
 6a6:	8ba6                	mv	s7,s1
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b5c9                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000bb583          	ld	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	dcfff0ef          	jal	488 <printint>
        i += 1;
 6be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	8ba6                	mv	s7,s1
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b565                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4629                	li	a2,10
 6ce:	000bb583          	ld	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	db5ff0ef          	jal	488 <printint>
        i += 2;
 6d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
        i += 2;
 6de:	b579                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e0:	008b8493          	addi	s1,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4641                	li	a2,16
 6e8:	000be583          	lwu	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	d9bff0ef          	jal	488 <printint>
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bd9d                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4641                	li	a2,16
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	d83ff0ef          	jal	488 <printint>
        i += 1;
 70a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
 710:	bdb1                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 712:	008b8493          	addi	s1,s7,8
 716:	4641                	li	a2,16
 718:	000bb583          	ld	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	d6bff0ef          	jal	488 <printint>
        i += 2;
 722:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
        i += 2;
 728:	b591                	j	56c <vprintf+0x44>
 72a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 72c:	008b8793          	addi	a5,s7,8
 730:	8cbe                	mv	s9,a5
 732:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 736:	03000593          	li	a1,48
 73a:	855a                	mv	a0,s6
 73c:	d2fff0ef          	jal	46a <putc>
  putc(fd, 'x');
 740:	07800593          	li	a1,120
 744:	855a                	mv	a0,s6
 746:	d25ff0ef          	jal	46a <putc>
 74a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74c:	00000b97          	auipc	s7,0x0
 750:	33cb8b93          	addi	s7,s7,828 # a88 <digits>
 754:	03c9d793          	srli	a5,s3,0x3c
 758:	97de                	add	a5,a5,s7
 75a:	0007c583          	lbu	a1,0(a5)
 75e:	855a                	mv	a0,s6
 760:	d0bff0ef          	jal	46a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 764:	0992                	slli	s3,s3,0x4
 766:	34fd                	addiw	s1,s1,-1
 768:	f4f5                	bnez	s1,754 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 76a:	8be6                	mv	s7,s9
      state = 0;
 76c:	4981                	li	s3,0
 76e:	6ca2                	ld	s9,8(sp)
 770:	bbf5                	j	56c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 772:	008b8493          	addi	s1,s7,8
 776:	000bc583          	lbu	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	cefff0ef          	jal	46a <putc>
 780:	8ba6                	mv	s7,s1
      state = 0;
 782:	4981                	li	s3,0
 784:	b3e5                	j	56c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 786:	008b8993          	addi	s3,s7,8
 78a:	000bb483          	ld	s1,0(s7)
 78e:	cc91                	beqz	s1,7aa <vprintf+0x282>
        for (; *s; s++)
 790:	0004c583          	lbu	a1,0(s1)
 794:	c195                	beqz	a1,7b8 <vprintf+0x290>
          putc(fd, *s);
 796:	855a                	mv	a0,s6
 798:	cd3ff0ef          	jal	46a <putc>
        for (; *s; s++)
 79c:	0485                	addi	s1,s1,1
 79e:	0004c583          	lbu	a1,0(s1)
 7a2:	f9f5                	bnez	a1,796 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7a4:	8bce                	mv	s7,s3
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b3d1                	j	56c <vprintf+0x44>
          s = "(null)";
 7aa:	00000497          	auipc	s1,0x0
 7ae:	2be48493          	addi	s1,s1,702 # a68 <malloc+0x18c>
        for (; *s; s++)
 7b2:	02800593          	li	a1,40
 7b6:	b7c5                	j	796 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7b8:	8bce                	mv	s7,s3
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bb45                	j	56c <vprintf+0x44>
        putc(fd, '%');
 7be:	85be                	mv	a1,a5
 7c0:	855a                	mv	a0,s6
 7c2:	ca9ff0ef          	jal	46a <putc>
 7c6:	bdbd                	j	644 <vprintf+0x11c>
 7c8:	6906                	ld	s2,64(sp)
 7ca:	79e2                	ld	s3,56(sp)
 7cc:	7a42                	ld	s4,48(sp)
 7ce:	7aa2                	ld	s5,40(sp)
 7d0:	7b02                	ld	s6,32(sp)
 7d2:	6be2                	ld	s7,24(sp)
 7d4:	6c42                	ld	s8,16(sp)
    }
  }
}
 7d6:	60e6                	ld	ra,88(sp)
 7d8:	6446                	ld	s0,80(sp)
 7da:	64a6                	ld	s1,72(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret
      if (c0 == 'd') {
 7e0:	06400713          	li	a4,100
 7e4:	e6e782e3          	beq	a5,a4,648 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7e8:	f9478693          	addi	a3,a5,-108
 7ec:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7f0:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7f2:	4701                	li	a4,0
 7f4:	bbe9                	j	5ce <vprintf+0xa6>

00000000000007f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f6:	715d                	addi	sp,sp,-80
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e010                	sd	a2,0(s0)
 800:	e414                	sd	a3,8(s0)
 802:	e818                	sd	a4,16(s0)
 804:	ec1c                	sd	a5,24(s0)
 806:	03043023          	sd	a6,32(s0)
 80a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	8622                	mv	a2,s0
 810:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 814:	d15ff0ef          	jal	528 <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6161                	addi	sp,sp,80
 81e:	8082                	ret

0000000000000820 <printf>:

void
printf(const char *fmt, ...)
{
 820:	711d                	addi	sp,sp,-96
 822:	ec06                	sd	ra,24(sp)
 824:	e822                	sd	s0,16(sp)
 826:	1000                	addi	s0,sp,32
 828:	e40c                	sd	a1,8(s0)
 82a:	e810                	sd	a2,16(s0)
 82c:	ec14                	sd	a3,24(s0)
 82e:	f018                	sd	a4,32(s0)
 830:	f41c                	sd	a5,40(s0)
 832:	03043823          	sd	a6,48(s0)
 836:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83a:	00840613          	addi	a2,s0,8
 83e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 842:	85aa                	mv	a1,a0
 844:	4505                	li	a0,1
 846:	ce3ff0ef          	jal	528 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6125                	addi	sp,sp,96
 850:	8082                	ret

0000000000000852 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 852:	1141                	addi	sp,sp,-16
 854:	e406                	sd	ra,8(sp)
 856:	e022                	sd	s0,0(sp)
 858:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 85a:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	00000797          	auipc	a5,0x0
 862:	7a27b783          	ld	a5,1954(a5) # 1000 <freep>
 866:	a095                	j	8ca <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059813          	slli	a6,a1,0x20
 872:	01c85693          	srli	a3,a6,0x1c
 876:	96ba                	add	a3,a3,a4
 878:	02d60563          	beq	a2,a3,8a2 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 880:	4790                	lw	a2,8(a5)
 882:	02061593          	slli	a1,a2,0x20
 886:	01c5d693          	srli	a3,a1,0x1c
 88a:	96be                	add	a3,a3,a5
 88c:	02d70263          	beq	a4,a3,8b0 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 890:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	76f73723          	sd	a5,1902(a4) # 1000 <freep>
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8a2:	4614                	lw	a3,8(a2)
 8a4:	9ead                	addw	a3,a3,a1
 8a6:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	6394                	ld	a3,0(a5)
 8ac:	6290                	ld	a2,0(a3)
 8ae:	b7f9                	j	87c <free+0x2a>
    p->s.size += bp->s.size;
 8b0:	ff852703          	lw	a4,-8(a0)
 8b4:	9f31                	addw	a4,a4,a2
 8b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b8:	ff053703          	ld	a4,-16(a0)
 8bc:	bfd1                	j	890 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	6394                	ld	a3,0(a5)
 8c0:	00d7e463          	bltu	a5,a3,8c8 <free+0x76>
 8c4:	fad762e3          	bltu	a4,a3,868 <free+0x16>
 8c8:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ca:	fee7fae3          	bgeu	a5,a4,8be <free+0x6c>
 8ce:	6394                	ld	a3,0(a5)
 8d0:	f8d76ce3          	bltu	a4,a3,868 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	f8d7fae3          	bgeu	a5,a3,868 <free+0x16>
 8d8:	87b6                	mv	a5,a3
 8da:	bfc5                	j	8ca <free+0x78>

00000000000008dc <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	ec4e                	sd	s3,24(sp)
 8e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8e8:	02051993          	slli	s3,a0,0x20
 8ec:	0209d993          	srli	s3,s3,0x20
 8f0:	09bd                	addi	s3,s3,15
 8f2:	0049d993          	srli	s3,s3,0x4
 8f6:	2985                	addiw	s3,s3,1
 8f8:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8fa:	00000517          	auipc	a0,0x0
 8fe:	70653503          	ld	a0,1798(a0) # 1000 <freep>
 902:	c905                	beqz	a0,932 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 904:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 906:	4798                	lw	a4,8(a5)
 908:	09377663          	bgeu	a4,s3,994 <malloc+0xb8>
 90c:	f426                	sd	s1,40(sp)
 90e:	e852                	sd	s4,16(sp)
 910:	e456                	sd	s5,8(sp)
 912:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 914:	8a4e                	mv	s4,s3
 916:	6705                	lui	a4,0x1
 918:	00e9f363          	bgeu	s3,a4,91e <malloc+0x42>
 91c:	6a05                	lui	s4,0x1
 91e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 926:	00000497          	auipc	s1,0x0
 92a:	6da48493          	addi	s1,s1,1754 # 1000 <freep>
  if (p == SBRK_ERROR)
 92e:	5afd                	li	s5,-1
 930:	a83d                	j	96e <malloc+0x92>
 932:	f426                	sd	s1,40(sp)
 934:	e852                	sd	s4,16(sp)
 936:	e456                	sd	s5,8(sp)
 938:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 93a:	00000797          	auipc	a5,0x0
 93e:	6d678793          	addi	a5,a5,1750 # 1010 <base>
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
 94a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 950:	b7d1                	j	914 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 952:	6398                	ld	a4,0(a5)
 954:	e118                	sd	a4,0(a0)
 956:	a899                	j	9ac <malloc+0xd0>
  hp->s.size = nu;
 958:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 95c:	0541                	addi	a0,a0,16
 95e:	ef5ff0ef          	jal	852 <free>
  return freep;
 962:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 964:	c125                	beqz	a0,9c4 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 966:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 968:	4798                	lw	a4,8(a5)
 96a:	03277163          	bgeu	a4,s2,98c <malloc+0xb0>
    if (p == freep)
 96e:	6098                	ld	a4,0(s1)
 970:	853e                	mv	a0,a5
 972:	fef71ae3          	bne	a4,a5,966 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 976:	8552                	mv	a0,s4
 978:	9ffff0ef          	jal	376 <sbrk>
  if (p == SBRK_ERROR)
 97c:	fd551ee3          	bne	a0,s5,958 <malloc+0x7c>
        return 0;
 980:	4501                	li	a0,0
 982:	74a2                	ld	s1,40(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
 98a:	a03d                	j	9b8 <malloc+0xdc>
 98c:	74a2                	ld	s1,40(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 994:	fae90fe3          	beq	s2,a4,952 <malloc+0x76>
        p->s.size -= nunits;
 998:	4137073b          	subw	a4,a4,s3
 99c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99e:	02071693          	slli	a3,a4,0x20
 9a2:	01c6d713          	srli	a4,a3,0x1c
 9a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64a73a23          	sd	a0,1620(a4) # 1000 <freep>
      return (void *)(p + 1);
 9b4:	01078513          	addi	a0,a5,16
  }
}
 9b8:	70e2                	ld	ra,56(sp)
 9ba:	7442                	ld	s0,48(sp)
 9bc:	7902                	ld	s2,32(sp)
 9be:	69e2                	ld	s3,24(sp)
 9c0:	6121                	addi	sp,sp,64
 9c2:	8082                	ret
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
 9cc:	b7f5                	j	9b8 <malloc+0xdc>
