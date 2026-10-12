
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	9e278793          	addi	a5,a5,-1566 # a00 <malloc+0x130>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	99c50513          	addi	a0,a0,-1636 # 9d0 <malloc+0x100>
  3c:	7d8000ef          	jal	814 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	128000ef          	jal	174 <memset>

  for (i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if (fork() > 0)
  54:	342000ef          	jal	396 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for (i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	98450513          	addi	a0,a0,-1660 # 9e8 <malloc+0x118>
  6c:	7a8000ef          	jal	814 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	35c000ef          	jal	3de <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) {
    // printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	326000ef          	jal	3be <write>
  for (i = 0; i < 20; i++) {
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  }
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	324000ef          	jal	3c6 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	95250513          	addi	a0,a0,-1710 # 9f8 <malloc+0x128>
  ae:	766000ef          	jal	814 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	326000ef          	jal	3de <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2e8000ef          	jal	3b6 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	2ee000ef          	jal	3c6 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2c8000ef          	jal	3a6 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2ba000ef          	jal	39e <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	2aa000ef          	jal	39e <exit>

00000000000000f8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf91                	beqz	a5,170 <strlen+0x28>
 156:	00150793          	addi	a5,a0,1
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for (n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strlen+0x20>

0000000000000174 <memset>:

void *
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 17c:	ca19                	beqz	a2,192 <memset+0x1e>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x14>
  }
  return dst;
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char *
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	c799                	beqz	a5,1b4 <strchr+0x1a>
    if (*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1c>
  for (; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xe>
      return (char *)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <gets>:

char *
gets(char *buf, int max)
{
 1be:	711d                	addi	sp,sp,-96
 1c0:	ec86                	sd	ra,88(sp)
 1c2:	e8a2                	sd	s0,80(sp)
 1c4:	e4a6                	sd	s1,72(sp)
 1c6:	e0ca                	sd	s2,64(sp)
 1c8:	fc4e                	sd	s3,56(sp)
 1ca:	f852                	sd	s4,48(sp)
 1cc:	f456                	sd	s5,40(sp)
 1ce:	f05a                	sd	s6,32(sp)
 1d0:	ec5e                	sd	s7,24(sp)
 1d2:	e862                	sd	s8,16(sp)
 1d4:	1080                	addi	s0,sp,96
 1d6:	8baa                	mv	s7,a0
 1d8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1de:	faf40b13          	addi	s6,s0,-81
 1e2:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1e4:	8c26                	mv	s8,s1
 1e6:	0014899b          	addiw	s3,s1,1
 1ea:	84ce                	mv	s1,s3
 1ec:	0349d863          	bge	s3,s4,21c <gets+0x5e>
    cc = read(0, &c, 1);
 1f0:	8656                	mv	a2,s5
 1f2:	85da                	mv	a1,s6
 1f4:	4501                	li	a0,0
 1f6:	1c0000ef          	jal	3b6 <read>
    if (cc < 1)
 1fa:	02a05163          	blez	a0,21c <gets+0x5e>
      break;
    buf[i++] = c;
 1fe:	faf44783          	lbu	a5,-81(s0)
 202:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 206:	0905                	addi	s2,s2,1
 208:	ff678713          	addi	a4,a5,-10
 20c:	00173713          	seqz	a4,a4
 210:	17cd                	addi	a5,a5,-13
 212:	0017b793          	seqz	a5,a5
 216:	8fd9                	or	a5,a5,a4
 218:	d7f1                	beqz	a5,1e4 <gets+0x26>
    buf[i++] = c;
 21a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 21c:	9c5e                	add	s8,s8,s7
 21e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 222:	855e                	mv	a0,s7
 224:	60e6                	ld	ra,88(sp)
 226:	6446                	ld	s0,80(sp)
 228:	64a6                	ld	s1,72(sp)
 22a:	6906                	ld	s2,64(sp)
 22c:	79e2                	ld	s3,56(sp)
 22e:	7a42                	ld	s4,48(sp)
 230:	7aa2                	ld	s5,40(sp)
 232:	7b02                	ld	s6,32(sp)
 234:	6be2                	ld	s7,24(sp)
 236:	6c42                	ld	s8,16(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e04a                	sd	s2,0(sp)
 244:	1000                	addi	s0,sp,32
 246:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	4581                	li	a1,0
 24a:	194000ef          	jal	3de <open>
  if (fd < 0)
 24e:	02054263          	bltz	a0,272 <stat+0x36>
 252:	e426                	sd	s1,8(sp)
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	19e000ef          	jal	3f6 <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	166000ef          	jal	3c6 <close>
  return r;
 264:	64a2                	ld	s1,8(sp)
}
 266:	854a                	mv	a0,s2
 268:	60e2                	ld	ra,24(sp)
 26a:	6442                	ld	s0,16(sp)
 26c:	6902                	ld	s2,0(sp)
 26e:	6105                	addi	sp,sp,32
 270:	8082                	ret
    return -1;
 272:	57fd                	li	a5,-1
 274:	893e                	mv	s2,a5
 276:	bfc5                	j	266 <stat+0x2a>

0000000000000278 <atoi>:

int
atoi(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 280:	00054683          	lbu	a3,0(a0)
 284:	fd06879b          	addiw	a5,a3,-48
 288:	0ff7f793          	zext.b	a5,a5
 28c:	4625                	li	a2,9
 28e:	02f66963          	bltu	a2,a5,2c0 <atoi+0x48>
 292:	872a                	mv	a4,a0
  n = 0;
 294:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 296:	0705                	addi	a4,a4,1
 298:	0025179b          	slliw	a5,a0,0x2
 29c:	9fa9                	addw	a5,a5,a0
 29e:	0017979b          	slliw	a5,a5,0x1
 2a2:	9fb5                	addw	a5,a5,a3
 2a4:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2a8:	00074683          	lbu	a3,0(a4)
 2ac:	fd06879b          	addiw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	fef671e3          	bgeu	a2,a5,296 <atoi+0x1e>
  return n;
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  n = 0;
 2c0:	4501                	li	a0,0
 2c2:	bfdd                	j	2b8 <atoi+0x40>

00000000000002c4 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2cc:	02b57563          	bgeu	a0,a1,2f6 <memmove+0x32>
    while (n-- > 0)
 2d0:	00c05f63          	blez	a2,2ee <memmove+0x2a>
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2de:	0585                	addi	a1,a1,1
 2e0:	0705                	addi	a4,a4,1
 2e2:	fff5c683          	lbu	a3,-1(a1)
 2e6:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2ea:	fee79ae3          	bne	a5,a4,2de <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    while (n-- > 0)
 2f6:	fec05ce3          	blez	a2,2ee <memmove+0x2a>
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 31a:	fef71ae3          	bne	a4,a5,30e <memmove+0x4a>
 31e:	bfc1                	j	2ee <memmove+0x2a>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 328:	ce19                	beqz	a2,346 <memcmp+0x26>
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 332:	00054783          	lbu	a5,0(a0)
 336:	0005c703          	lbu	a4,0(a1)
 33a:	00e79b63          	bne	a5,a4,350 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 33e:	0505                	addi	a0,a0,1
    p2++;
 340:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 342:	fed518e3          	bne	a0,a3,332 <memcmp+0x12>
  }
  return 0;
 346:	4501                	li	a0,0
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
 354:	bfd5                	j	348 <memcmp+0x28>

0000000000000356 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35e:	f67ff0ef          	jal	2c4 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrk>:

char *
sbrk(int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 372:	4585                	li	a1,1
 374:	0b2000ef          	jal	426 <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <sbrklazy>:

char *
sbrklazy(int n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 388:	4589                	li	a1,2
 38a:	09c000ef          	jal	426 <sys_sbrk>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ae:	4891                	li	a7,4
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <read>:
.global read
read:
 li a7, SYS_read
 3b6:	4895                	li	a7,5
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <close>:
.global close
close:
 li a7, SYS_close
 3c6:	48d5                	li	a7,21
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <open>:
.global open
open:
 li a7, SYS_open
 3de:	48bd                	li	a7,15
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e6:	48c5                	li	a7,17
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ee:	48c9                	li	a7,18
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f6:	48a1                	li	a7,8
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <link>:
.global link
link:
 li a7, SYS_link
 3fe:	48cd                	li	a7,19
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 406:	48d1                	li	a7,20
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40e:	48a5                	li	a7,9
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <dup>:
.global dup
dup:
 li a7, SYS_dup
 416:	48a9                	li	a7,10
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41e:	48ad                	li	a7,11
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 426:	48b1                	li	a7,12
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <pause>:
.global pause
pause:
 li a7, SYS_pause
 42e:	48b5                	li	a7,13
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 436:	48b9                	li	a7,14
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sync>:
.global sync
sync:
 li a7, SYS_sync
 43e:	48d9                	li	a7,22
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <trace>:
.global trace
trace:
 li a7, SYS_trace
 446:	48dd                	li	a7,23
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 44e:	48e1                	li	a7,24
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 456:	48e5                	li	a7,25
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	f4fff0ef          	jal	3be <write>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret

000000000000047c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 47c:	715d                	addi	sp,sp,-80
 47e:	e486                	sd	ra,72(sp)
 480:	e0a2                	sd	s0,64(sp)
 482:	f84a                	sd	s2,48(sp)
 484:	f44e                	sd	s3,40(sp)
 486:	0880                	addi	s0,sp,80
 488:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 48a:	00d036b3          	snez	a3,a3
 48e:	03f5d793          	srli	a5,a1,0x3f
 492:	8efd                	and	a3,a3,a5
  neg = 0;
 494:	4301                	li	t1,0
  if (sgn && xx < 0) {
 496:	c681                	beqz	a3,49e <printint+0x22>
    neg = 1;
    x = -xx;
 498:	40b005b3          	neg	a1,a1
    neg = 1;
 49c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 49e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4a2:	86ce                	mv	a3,s3
  i = 0;
 4a4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4a6:	00000817          	auipc	a6,0x0
 4aa:	57280813          	addi	a6,a6,1394 # a18 <digits>
 4ae:	88ba                	mv	a7,a4
 4b0:	0017051b          	addiw	a0,a4,1
 4b4:	872a                	mv	a4,a0
 4b6:	02c5f7b3          	remu	a5,a1,a2
 4ba:	97c2                	add	a5,a5,a6
 4bc:	0007c783          	lbu	a5,0(a5)
 4c0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4c4:	87ae                	mv	a5,a1
 4c6:	02c5d5b3          	divu	a1,a1,a2
 4ca:	0685                	addi	a3,a3,1
 4cc:	fec7f1e3          	bgeu	a5,a2,4ae <printint+0x32>
  if (neg)
 4d0:	00030b63          	beqz	t1,4e6 <printint+0x6a>
    buf[i++] = '-';
 4d4:	fd040793          	addi	a5,s0,-48
 4d8:	953e                	add	a0,a0,a5
 4da:	02d00793          	li	a5,45
 4de:	fef50423          	sb	a5,-24(a0)
 4e2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4e6:	02e05563          	blez	a4,510 <printint+0x94>
 4ea:	fc26                	sd	s1,56(sp)
 4ec:	377d                	addiw	a4,a4,-1
 4ee:	00e984b3          	add	s1,s3,a4
 4f2:	19fd                	addi	s3,s3,-1
 4f4:	99ba                	add	s3,s3,a4
 4f6:	1702                	slli	a4,a4,0x20
 4f8:	9301                	srli	a4,a4,0x20
 4fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fe:	0004c583          	lbu	a1,0(s1)
 502:	854a                	mv	a0,s2
 504:	f5bff0ef          	jal	45e <putc>
  while (--i >= 0)
 508:	14fd                	addi	s1,s1,-1
 50a:	ff349ae3          	bne	s1,s3,4fe <printint+0x82>
 50e:	74e2                	ld	s1,56(sp)
}
 510:	60a6                	ld	ra,72(sp)
 512:	6406                	ld	s0,64(sp)
 514:	7942                	ld	s2,48(sp)
 516:	79a2                	ld	s3,40(sp)
 518:	6161                	addi	sp,sp,80
 51a:	8082                	ret

000000000000051c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51c:	711d                	addi	sp,sp,-96
 51e:	ec86                	sd	ra,88(sp)
 520:	e8a2                	sd	s0,80(sp)
 522:	e4a6                	sd	s1,72(sp)
 524:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 526:	0005c483          	lbu	s1,0(a1)
 52a:	2a048063          	beqz	s1,7ca <vprintf+0x2ae>
 52e:	e0ca                	sd	s2,64(sp)
 530:	fc4e                	sd	s3,56(sp)
 532:	f852                	sd	s4,48(sp)
 534:	f456                	sd	s5,40(sp)
 536:	f05a                	sd	s6,32(sp)
 538:	ec5e                	sd	s7,24(sp)
 53a:	e862                	sd	s8,16(sp)
 53c:	8b2a                	mv	s6,a0
 53e:	8a2e                	mv	s4,a1
 540:	8bb2                	mv	s7,a2
  state = 0;
 542:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 544:	4901                	li	s2,0
 546:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 548:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 54c:	06400c13          	li	s8,100
 550:	a00d                	j	572 <vprintf+0x56>
        putc(fd, c0);
 552:	85a6                	mv	a1,s1
 554:	855a                	mv	a0,s6
 556:	f09ff0ef          	jal	45e <putc>
 55a:	a019                	j	560 <vprintf+0x44>
    } else if (state == '%') {
 55c:	03598363          	beq	s3,s5,582 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 560:	0019079b          	addiw	a5,s2,1
 564:	893e                	mv	s2,a5
 566:	873e                	mv	a4,a5
 568:	97d2                	add	a5,a5,s4
 56a:	0007c483          	lbu	s1,0(a5)
 56e:	24048763          	beqz	s1,7bc <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 572:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 576:	fe0993e3          	bnez	s3,55c <vprintf+0x40>
      if (c0 == '%') {
 57a:	fd579ce3          	bne	a5,s5,552 <vprintf+0x36>
        state = '%';
 57e:	89be                	mv	s3,a5
 580:	b7c5                	j	560 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c603          	lbu	a2,1(a3)
      if (c1)
 58a:	24060563          	beqz	a2,7d4 <vprintf+0x2b8>
      if (c0 == 'd') {
 58e:	0b878763          	beq	a5,s8,63c <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 592:	f9478693          	addi	a3,a5,-108
 596:	0016b693          	seqz	a3,a3
 59a:	f9c60593          	addi	a1,a2,-100
 59e:	0015b593          	seqz	a1,a1
 5a2:	8df5                	and	a1,a1,a3
 5a4:	e9c5                	bnez	a1,654 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 5a6:	9752                	add	a4,a4,s4
 5a8:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5ac:	f9460713          	addi	a4,a2,-108
 5b0:	00173713          	seqz	a4,a4
 5b4:	8f75                	and	a4,a4,a3
 5b6:	f9c50593          	addi	a1,a0,-100
 5ba:	0015b593          	seqz	a1,a1
 5be:	8df9                	and	a1,a1,a4
 5c0:	e5dd                	bnez	a1,66e <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5c2:	07500593          	li	a1,117
 5c6:	0cb78163          	beq	a5,a1,688 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5ca:	f8b60593          	addi	a1,a2,-117
 5ce:	0015b593          	seqz	a1,a1
 5d2:	8df5                	and	a1,a1,a3
 5d4:	e5f1                	bnez	a1,6a0 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5d6:	f8b50593          	addi	a1,a0,-117
 5da:	0015b593          	seqz	a1,a1
 5de:	8df9                	and	a1,a1,a4
 5e0:	ede9                	bnez	a1,6ba <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5e2:	07800593          	li	a1,120
 5e6:	0eb78763          	beq	a5,a1,6d4 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5ea:	f8860613          	addi	a2,a2,-120
 5ee:	00163613          	seqz	a2,a2
 5f2:	8ef1                	and	a3,a3,a2
 5f4:	0e069c63          	bnez	a3,6ec <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5f8:	f8850513          	addi	a0,a0,-120
 5fc:	00153513          	seqz	a0,a0
 600:	8f69                	and	a4,a4,a0
 602:	10071263          	bnez	a4,706 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 606:	07000713          	li	a4,112
 60a:	10e78a63          	beq	a5,a4,71e <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 60e:	06300713          	li	a4,99
 612:	14e78a63          	beq	a5,a4,766 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 616:	07300713          	li	a4,115
 61a:	16e78063          	beq	a5,a4,77a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 61e:	02500713          	li	a4,37
 622:	18e78863          	beq	a5,a4,7b2 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 626:	02500593          	li	a1,37
 62a:	855a                	mv	a0,s6
 62c:	e33ff0ef          	jal	45e <putc>
        putc(fd, c0);
 630:	85a6                	mv	a1,s1
 632:	855a                	mv	a0,s6
 634:	e2bff0ef          	jal	45e <putc>
      }

      state = 0;
 638:	4981                	li	s3,0
 63a:	b71d                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 63c:	008b8493          	addi	s1,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e33ff0ef          	jal	47c <printint>
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	b739                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	008b8493          	addi	s1,s7,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e1bff0ef          	jal	47c <printint>
        i += 1;
 666:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bdd5                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	008b8493          	addi	s1,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	e01ff0ef          	jal	47c <printint>
        i += 2;
 680:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	bde9                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000be583          	lwu	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	de7ff0ef          	jal	47c <printint>
 69a:	8ba6                	mv	s7,s1
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b5c9                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8493          	addi	s1,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	dcfff0ef          	jal	47c <printint>
        i += 1;
 6b2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b565                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	db5ff0ef          	jal	47c <printint>
        i += 2;
 6cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	b579                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000be583          	lwu	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d9bff0ef          	jal	47c <printint>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd9d                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000bb583          	ld	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d83ff0ef          	jal	47c <printint>
        i += 1;
 6fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	bdb1                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	008b8493          	addi	s1,s7,8
 70a:	4641                	li	a2,16
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	d6bff0ef          	jal	47c <printint>
        i += 2;
 716:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	b591                	j	560 <vprintf+0x44>
 71e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 720:	008b8793          	addi	a5,s7,8
 724:	8cbe                	mv	s9,a5
 726:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72a:	03000593          	li	a1,48
 72e:	855a                	mv	a0,s6
 730:	d2fff0ef          	jal	45e <putc>
  putc(fd, 'x');
 734:	07800593          	li	a1,120
 738:	855a                	mv	a0,s6
 73a:	d25ff0ef          	jal	45e <putc>
 73e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 740:	00000b97          	auipc	s7,0x0
 744:	2d8b8b93          	addi	s7,s7,728 # a18 <digits>
 748:	03c9d793          	srli	a5,s3,0x3c
 74c:	97de                	add	a5,a5,s7
 74e:	0007c583          	lbu	a1,0(a5)
 752:	855a                	mv	a0,s6
 754:	d0bff0ef          	jal	45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 758:	0992                	slli	s3,s3,0x4
 75a:	34fd                	addiw	s1,s1,-1
 75c:	f4f5                	bnez	s1,748 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 75e:	8be6                	mv	s7,s9
      state = 0;
 760:	4981                	li	s3,0
 762:	6ca2                	ld	s9,8(sp)
 764:	bbf5                	j	560 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 766:	008b8493          	addi	s1,s7,8
 76a:	000bc583          	lbu	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	cefff0ef          	jal	45e <putc>
 774:	8ba6                	mv	s7,s1
      state = 0;
 776:	4981                	li	s3,0
 778:	b3e5                	j	560 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 77a:	008b8993          	addi	s3,s7,8
 77e:	000bb483          	ld	s1,0(s7)
 782:	cc91                	beqz	s1,79e <vprintf+0x282>
        for (; *s; s++)
 784:	0004c583          	lbu	a1,0(s1)
 788:	c195                	beqz	a1,7ac <vprintf+0x290>
          putc(fd, *s);
 78a:	855a                	mv	a0,s6
 78c:	cd3ff0ef          	jal	45e <putc>
        for (; *s; s++)
 790:	0485                	addi	s1,s1,1
 792:	0004c583          	lbu	a1,0(s1)
 796:	f9f5                	bnez	a1,78a <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b3d1                	j	560 <vprintf+0x44>
          s = "(null)";
 79e:	00000497          	auipc	s1,0x0
 7a2:	27248493          	addi	s1,s1,626 # a10 <malloc+0x140>
        for (; *s; s++)
 7a6:	02800593          	li	a1,40
 7aa:	b7c5                	j	78a <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7ac:	8bce                	mv	s7,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	bb45                	j	560 <vprintf+0x44>
        putc(fd, '%');
 7b2:	85be                	mv	a1,a5
 7b4:	855a                	mv	a0,s6
 7b6:	ca9ff0ef          	jal	45e <putc>
 7ba:	bdbd                	j	638 <vprintf+0x11c>
 7bc:	6906                	ld	s2,64(sp)
 7be:	79e2                	ld	s3,56(sp)
 7c0:	7a42                	ld	s4,48(sp)
 7c2:	7aa2                	ld	s5,40(sp)
 7c4:	7b02                	ld	s6,32(sp)
 7c6:	6be2                	ld	s7,24(sp)
 7c8:	6c42                	ld	s8,16(sp)
    }
  }
}
 7ca:	60e6                	ld	ra,88(sp)
 7cc:	6446                	ld	s0,80(sp)
 7ce:	64a6                	ld	s1,72(sp)
 7d0:	6125                	addi	sp,sp,96
 7d2:	8082                	ret
      if (c0 == 'd') {
 7d4:	06400713          	li	a4,100
 7d8:	e6e782e3          	beq	a5,a4,63c <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7dc:	f9478693          	addi	a3,a5,-108
 7e0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7e4:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7e6:	4701                	li	a4,0
 7e8:	bbe9                	j	5c2 <vprintf+0xa6>

00000000000007ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ea:	715d                	addi	sp,sp,-80
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	e010                	sd	a2,0(s0)
 7f4:	e414                	sd	a3,8(s0)
 7f6:	e818                	sd	a4,16(s0)
 7f8:	ec1c                	sd	a5,24(s0)
 7fa:	03043023          	sd	a6,32(s0)
 7fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	8622                	mv	a2,s0
 804:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 808:	d15ff0ef          	jal	51c <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6161                	addi	sp,sp,80
 812:	8082                	ret

0000000000000814 <printf>:

void
printf(const char *fmt, ...)
{
 814:	711d                	addi	sp,sp,-96
 816:	ec06                	sd	ra,24(sp)
 818:	e822                	sd	s0,16(sp)
 81a:	1000                	addi	s0,sp,32
 81c:	e40c                	sd	a1,8(s0)
 81e:	e810                	sd	a2,16(s0)
 820:	ec14                	sd	a3,24(s0)
 822:	f018                	sd	a4,32(s0)
 824:	f41c                	sd	a5,40(s0)
 826:	03043823          	sd	a6,48(s0)
 82a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82e:	00840613          	addi	a2,s0,8
 832:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 836:	85aa                	mv	a1,a0
 838:	4505                	li	a0,1
 83a:	ce3ff0ef          	jal	51c <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6125                	addi	sp,sp,96
 844:	8082                	ret

0000000000000846 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 846:	1141                	addi	sp,sp,-16
 848:	e406                	sd	ra,8(sp)
 84a:	e022                	sd	s0,0(sp)
 84c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 84e:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 852:	00000797          	auipc	a5,0x0
 856:	7ae7b783          	ld	a5,1966(a5) # 1000 <freep>
 85a:	a095                	j	8be <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 85c:	ff852583          	lw	a1,-8(a0)
 860:	6390                	ld	a2,0(a5)
 862:	02059813          	slli	a6,a1,0x20
 866:	01c85693          	srli	a3,a6,0x1c
 86a:	96ba                	add	a3,a3,a4
 86c:	02d60563          	beq	a2,a3,896 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 870:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 874:	4790                	lw	a2,8(a5)
 876:	02061593          	slli	a1,a2,0x20
 87a:	01c5d693          	srli	a3,a1,0x1c
 87e:	96be                	add	a3,a3,a5
 880:	02d70263          	beq	a4,a3,8a4 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 884:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 886:	00000717          	auipc	a4,0x0
 88a:	76f73d23          	sd	a5,1914(a4) # 1000 <freep>
}
 88e:	60a2                	ld	ra,8(sp)
 890:	6402                	ld	s0,0(sp)
 892:	0141                	addi	sp,sp,16
 894:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 896:	4614                	lw	a3,8(a2)
 898:	9ead                	addw	a3,a3,a1
 89a:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	6394                	ld	a3,0(a5)
 8a0:	6290                	ld	a2,0(a3)
 8a2:	b7f9                	j	870 <free+0x2a>
    p->s.size += bp->s.size;
 8a4:	ff852703          	lw	a4,-8(a0)
 8a8:	9f31                	addw	a4,a4,a2
 8aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ac:	ff053703          	ld	a4,-16(a0)
 8b0:	bfd1                	j	884 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	6394                	ld	a3,0(a5)
 8b4:	00d7e463          	bltu	a5,a3,8bc <free+0x76>
 8b8:	fad762e3          	bltu	a4,a3,85c <free+0x16>
 8bc:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	fee7fae3          	bgeu	a5,a4,8b2 <free+0x6c>
 8c2:	6394                	ld	a3,0(a5)
 8c4:	f8d76ce3          	bltu	a4,a3,85c <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	f8d7fae3          	bgeu	a5,a3,85c <free+0x16>
 8cc:	87b6                	mv	a5,a3
 8ce:	bfc5                	j	8be <free+0x78>

00000000000008d0 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8d0:	7139                	addi	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	ec4e                	sd	s3,24(sp)
 8da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8dc:	02051993          	slli	s3,a0,0x20
 8e0:	0209d993          	srli	s3,s3,0x20
 8e4:	09bd                	addi	s3,s3,15
 8e6:	0049d993          	srli	s3,s3,0x4
 8ea:	2985                	addiw	s3,s3,1
 8ec:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8ee:	00000517          	auipc	a0,0x0
 8f2:	71253503          	ld	a0,1810(a0) # 1000 <freep>
 8f6:	c905                	beqz	a0,926 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8f8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8fa:	4798                	lw	a4,8(a5)
 8fc:	09377663          	bgeu	a4,s3,988 <malloc+0xb8>
 900:	f426                	sd	s1,40(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 908:	8a4e                	mv	s4,s3
 90a:	6705                	lui	a4,0x1
 90c:	00e9f363          	bgeu	s3,a4,912 <malloc+0x42>
 910:	6a05                	lui	s4,0x1
 912:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 916:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 91a:	00000497          	auipc	s1,0x0
 91e:	6e648493          	addi	s1,s1,1766 # 1000 <freep>
  if (p == SBRK_ERROR)
 922:	5afd                	li	s5,-1
 924:	a83d                	j	962 <malloc+0x92>
 926:	f426                	sd	s1,40(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 92e:	00000797          	auipc	a5,0x0
 932:	6e278793          	addi	a5,a5,1762 # 1010 <base>
 936:	00000717          	auipc	a4,0x0
 93a:	6cf73523          	sd	a5,1738(a4) # 1000 <freep>
 93e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 940:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 944:	b7d1                	j	908 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	e118                	sd	a4,0(a0)
 94a:	a899                	j	9a0 <malloc+0xd0>
  hp->s.size = nu;
 94c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 950:	0541                	addi	a0,a0,16
 952:	ef5ff0ef          	jal	846 <free>
  return freep;
 956:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 958:	c125                	beqz	a0,9b8 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 95a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 95c:	4798                	lw	a4,8(a5)
 95e:	03277163          	bgeu	a4,s2,980 <malloc+0xb0>
    if (p == freep)
 962:	6098                	ld	a4,0(s1)
 964:	853e                	mv	a0,a5
 966:	fef71ae3          	bne	a4,a5,95a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 96a:	8552                	mv	a0,s4
 96c:	9ffff0ef          	jal	36a <sbrk>
  if (p == SBRK_ERROR)
 970:	fd551ee3          	bne	a0,s5,94c <malloc+0x7c>
        return 0;
 974:	4501                	li	a0,0
 976:	74a2                	ld	s1,40(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	a03d                	j	9ac <malloc+0xdc>
 980:	74a2                	ld	s1,40(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 988:	fae90fe3          	beq	s2,a4,946 <malloc+0x76>
        p->s.size -= nunits;
 98c:	4137073b          	subw	a4,a4,s3
 990:	c798                	sw	a4,8(a5)
        p += p->s.size;
 992:	02071693          	slli	a3,a4,0x20
 996:	01c6d713          	srli	a4,a3,0x1c
 99a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a0:	00000717          	auipc	a4,0x0
 9a4:	66a73023          	sd	a0,1632(a4) # 1000 <freep>
      return (void *)(p + 1);
 9a8:	01078513          	addi	a0,a5,16
  }
}
 9ac:	70e2                	ld	ra,56(sp)
 9ae:	7442                	ld	s0,48(sp)
 9b0:	7902                	ld	s2,32(sp)
 9b2:	69e2                	ld	s3,24(sp)
 9b4:	6121                	addi	sp,sp,64
 9b6:	8082                	ret
 9b8:	74a2                	ld	s1,40(sp)
 9ba:	6a42                	ld	s4,16(sp)
 9bc:	6aa2                	ld	s5,8(sp)
 9be:	6b02                	ld	s6,0(sp)
 9c0:	b7f5                	j	9ac <malloc+0xdc>
