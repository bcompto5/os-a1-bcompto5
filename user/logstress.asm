
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ = 2000 };

  for (int i = 1; i < argc; i++) {
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++) {
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	390000ef          	jal	3b0 <fork>
    if (pid1 < 0) {
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if (pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++) {
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for (int i = 1; i < argc; i++) {
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	9a250513          	addi	a0,a0,-1630 # 9e0 <malloc+0xf6>
  46:	7e8000ef          	jal	82e <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	36c000ef          	jal	3b8 <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	39a000ef          	jal	3f8 <open>
  62:	89aa                	mv	s3,a0
      if (fd < 0) {
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0' + i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	116000ef          	jal	18e <memset>
  7c:	0fa00493          	li	s1,250
        if ((n = write(fd, buf, SZ)) != SZ) {
  80:	7d000913          	li	s2,2000
  84:	00001a17          	auipc	s4,0x1
  88:	f8ca0a13          	addi	s4,s4,-116 # 1010 <buf>
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	346000ef          	jal	3d8 <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for (i = 0; i < N; i++) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	318000ef          	jal	3b8 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	94c50513          	addi	a0,a0,-1716 # 9f8 <malloc+0x10e>
  b4:	77a000ef          	jal	82e <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	2fe000ef          	jal	3b8 <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	95050513          	addi	a0,a0,-1712 # a10 <malloc+0x126>
  c8:	766000ef          	jal	82e <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2ea000ef          	jal	3b8 <exit>
  for (int i = 1; i < argc; i++) {
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	2ea000ef          	jal	3c0 <wait>
    if (xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for (int i = 1; i < argc; i++) {
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2be000ef          	jal	3b8 <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	2aa000ef          	jal	3b8 <exit>

0000000000000112 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x28>
 170:	00150793          	addi	a5,a0,1
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  for (n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfdd                	j	182 <strlen+0x20>

000000000000018e <memset>:

void *
memset(void *dst, int c, uint n)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 196:	ca19                	beqz	a2,1ac <memset+0x1e>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x14>
  }
  return dst;
}
 1ac:	60a2                	ld	ra,8(sp)
 1ae:	6402                	ld	s0,0(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strchr>:

char *
strchr(const char *s, char c)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	c799                	beqz	a5,1ce <strchr+0x1a>
    if (*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1c>
  for (; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xe>
      return (char *)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	60a2                	ld	ra,8(sp)
 1d2:	6402                	ld	s0,0(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <gets>:

char *
gets(char *buf, int max)
{
 1d8:	711d                	addi	sp,sp,-96
 1da:	ec86                	sd	ra,88(sp)
 1dc:	e8a2                	sd	s0,80(sp)
 1de:	e4a6                	sd	s1,72(sp)
 1e0:	e0ca                	sd	s2,64(sp)
 1e2:	fc4e                	sd	s3,56(sp)
 1e4:	f852                	sd	s4,48(sp)
 1e6:	f456                	sd	s5,40(sp)
 1e8:	f05a                	sd	s6,32(sp)
 1ea:	ec5e                	sd	s7,24(sp)
 1ec:	e862                	sd	s8,16(sp)
 1ee:	1080                	addi	s0,sp,96
 1f0:	8baa                	mv	s7,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f8:	faf40b13          	addi	s6,s0,-81
 1fc:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1fe:	8c26                	mv	s8,s1
 200:	0014899b          	addiw	s3,s1,1
 204:	84ce                	mv	s1,s3
 206:	0349d863          	bge	s3,s4,236 <gets+0x5e>
    cc = read(0, &c, 1);
 20a:	8656                	mv	a2,s5
 20c:	85da                	mv	a1,s6
 20e:	4501                	li	a0,0
 210:	1c0000ef          	jal	3d0 <read>
    if (cc < 1)
 214:	02a05163          	blez	a0,236 <gets+0x5e>
      break;
    buf[i++] = c;
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 220:	0905                	addi	s2,s2,1
 222:	ff678713          	addi	a4,a5,-10
 226:	00173713          	seqz	a4,a4
 22a:	17cd                	addi	a5,a5,-13
 22c:	0017b793          	seqz	a5,a5
 230:	8fd9                	or	a5,a5,a4
 232:	d7f1                	beqz	a5,1fe <gets+0x26>
    buf[i++] = c;
 234:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 236:	9c5e                	add	s8,s8,s7
 238:	000c0023          	sb	zero,0(s8)
  return buf;
}
 23c:	855e                	mv	a0,s7
 23e:	60e6                	ld	ra,88(sp)
 240:	6446                	ld	s0,80(sp)
 242:	64a6                	ld	s1,72(sp)
 244:	6906                	ld	s2,64(sp)
 246:	79e2                	ld	s3,56(sp)
 248:	7a42                	ld	s4,48(sp)
 24a:	7aa2                	ld	s5,40(sp)
 24c:	7b02                	ld	s6,32(sp)
 24e:	6be2                	ld	s7,24(sp)
 250:	6c42                	ld	s8,16(sp)
 252:	6125                	addi	sp,sp,96
 254:	8082                	ret

0000000000000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	194000ef          	jal	3f8 <open>
  if (fd < 0)
 268:	02054263          	bltz	a0,28c <stat+0x36>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	19e000ef          	jal	410 <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	166000ef          	jal	3e0 <close>
  return r;
 27e:	64a2                	ld	s1,8(sp)
}
 280:	854a                	mv	a0,s2
 282:	60e2                	ld	ra,24(sp)
 284:	6442                	ld	s0,16(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	57fd                	li	a5,-1
 28e:	893e                	mv	s2,a5
 290:	bfc5                	j	280 <stat+0x2a>

0000000000000292 <atoi>:

int
atoi(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66963          	bltu	a2,a5,2da <atoi+0x48>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1e>
  return n;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <atoi+0x40>

00000000000002de <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57563          	bgeu	a0,a1,310 <memmove+0x32>
    while (n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x2a>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    while (n-- > 0)
 310:	fec05ce3          	blez	a2,308 <memmove+0x2a>
    dst += n;
 314:	00c50733          	add	a4,a0,a2
    src += n;
 318:	95b2                	add	a1,a1,a2
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 334:	fef71ae3          	bne	a4,a5,328 <memmove+0x4a>
 338:	bfc1                	j	308 <memmove+0x2a>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	ce19                	beqz	a2,360 <memcmp+0x26>
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79b63          	bne	a5,a4,36a <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x12>
  }
  return 0;
 360:	4501                	li	a0,0
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret
      return *p1 - *p2;
 36a:	40e7853b          	subw	a0,a5,a4
 36e:	bfd5                	j	362 <memcmp+0x28>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f67ff0ef          	jal	2de <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <sbrk>:

char *
sbrk(int n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 38c:	4585                	li	a1,1
 38e:	0b2000ef          	jal	440 <sys_sbrk>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <sbrklazy>:

char *
sbrklazy(int n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e406                	sd	ra,8(sp)
 39e:	e022                	sd	s0,0(sp)
 3a0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a2:	4589                	li	a1,2
 3a4:	09c000ef          	jal	440 <sys_sbrk>
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b0:	4885                	li	a7,1
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b8:	4889                	li	a7,2
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c0:	488d                	li	a7,3
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c8:	4891                	li	a7,4
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <read>:
.global read
read:
 li a7, SYS_read
 3d0:	4895                	li	a7,5
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <write>:
.global write
write:
 li a7, SYS_write
 3d8:	48c1                	li	a7,16
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <close>:
.global close
close:
 li a7, SYS_close
 3e0:	48d5                	li	a7,21
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e8:	4899                	li	a7,6
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f0:	489d                	li	a7,7
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <open>:
.global open
open:
 li a7, SYS_open
 3f8:	48bd                	li	a7,15
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 400:	48c5                	li	a7,17
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 408:	48c9                	li	a7,18
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 410:	48a1                	li	a7,8
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <link>:
.global link
link:
 li a7, SYS_link
 418:	48cd                	li	a7,19
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 420:	48d1                	li	a7,20
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 428:	48a5                	li	a7,9
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <dup>:
.global dup
dup:
 li a7, SYS_dup
 430:	48a9                	li	a7,10
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 438:	48ad                	li	a7,11
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 440:	48b1                	li	a7,12
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pause>:
.global pause
pause:
 li a7, SYS_pause
 448:	48b5                	li	a7,13
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 450:	48b9                	li	a7,14
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sync>:
.global sync
sync:
 li a7, SYS_sync
 458:	48d9                	li	a7,22
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <trace>:
.global trace
trace:
 li a7, SYS_trace
 460:	48dd                	li	a7,23
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 468:	48e1                	li	a7,24
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 470:	48e5                	li	a7,25
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 478:	1101                	addi	sp,sp,-32
 47a:	ec06                	sd	ra,24(sp)
 47c:	e822                	sd	s0,16(sp)
 47e:	1000                	addi	s0,sp,32
 480:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 484:	4605                	li	a2,1
 486:	fef40593          	addi	a1,s0,-17
 48a:	f4fff0ef          	jal	3d8 <write>
}
 48e:	60e2                	ld	ra,24(sp)
 490:	6442                	ld	s0,16(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret

0000000000000496 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 496:	715d                	addi	sp,sp,-80
 498:	e486                	sd	ra,72(sp)
 49a:	e0a2                	sd	s0,64(sp)
 49c:	f84a                	sd	s2,48(sp)
 49e:	f44e                	sd	s3,40(sp)
 4a0:	0880                	addi	s0,sp,80
 4a2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4a4:	00d036b3          	snez	a3,a3
 4a8:	03f5d793          	srli	a5,a1,0x3f
 4ac:	8efd                	and	a3,a3,a5
  neg = 0;
 4ae:	4301                	li	t1,0
  if (sgn && xx < 0) {
 4b0:	c681                	beqz	a3,4b8 <printint+0x22>
    neg = 1;
    x = -xx;
 4b2:	40b005b3          	neg	a1,a1
    neg = 1;
 4b6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4b8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4bc:	86ce                	mv	a3,s3
  i = 0;
 4be:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4c0:	00000817          	auipc	a6,0x0
 4c4:	57080813          	addi	a6,a6,1392 # a30 <digits>
 4c8:	88ba                	mv	a7,a4
 4ca:	0017051b          	addiw	a0,a4,1
 4ce:	872a                	mv	a4,a0
 4d0:	02c5f7b3          	remu	a5,a1,a2
 4d4:	97c2                	add	a5,a5,a6
 4d6:	0007c783          	lbu	a5,0(a5)
 4da:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4de:	87ae                	mv	a5,a1
 4e0:	02c5d5b3          	divu	a1,a1,a2
 4e4:	0685                	addi	a3,a3,1
 4e6:	fec7f1e3          	bgeu	a5,a2,4c8 <printint+0x32>
  if (neg)
 4ea:	00030b63          	beqz	t1,500 <printint+0x6a>
    buf[i++] = '-';
 4ee:	fd040793          	addi	a5,s0,-48
 4f2:	953e                	add	a0,a0,a5
 4f4:	02d00793          	li	a5,45
 4f8:	fef50423          	sb	a5,-24(a0)
 4fc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 500:	02e05563          	blez	a4,52a <printint+0x94>
 504:	fc26                	sd	s1,56(sp)
 506:	377d                	addiw	a4,a4,-1
 508:	00e984b3          	add	s1,s3,a4
 50c:	19fd                	addi	s3,s3,-1
 50e:	99ba                	add	s3,s3,a4
 510:	1702                	slli	a4,a4,0x20
 512:	9301                	srli	a4,a4,0x20
 514:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 518:	0004c583          	lbu	a1,0(s1)
 51c:	854a                	mv	a0,s2
 51e:	f5bff0ef          	jal	478 <putc>
  while (--i >= 0)
 522:	14fd                	addi	s1,s1,-1
 524:	ff349ae3          	bne	s1,s3,518 <printint+0x82>
 528:	74e2                	ld	s1,56(sp)
}
 52a:	60a6                	ld	ra,72(sp)
 52c:	6406                	ld	s0,64(sp)
 52e:	7942                	ld	s2,48(sp)
 530:	79a2                	ld	s3,40(sp)
 532:	6161                	addi	sp,sp,80
 534:	8082                	ret

0000000000000536 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 536:	711d                	addi	sp,sp,-96
 538:	ec86                	sd	ra,88(sp)
 53a:	e8a2                	sd	s0,80(sp)
 53c:	e4a6                	sd	s1,72(sp)
 53e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 540:	0005c483          	lbu	s1,0(a1)
 544:	2a048063          	beqz	s1,7e4 <vprintf+0x2ae>
 548:	e0ca                	sd	s2,64(sp)
 54a:	fc4e                	sd	s3,56(sp)
 54c:	f852                	sd	s4,48(sp)
 54e:	f456                	sd	s5,40(sp)
 550:	f05a                	sd	s6,32(sp)
 552:	ec5e                	sd	s7,24(sp)
 554:	e862                	sd	s8,16(sp)
 556:	8b2a                	mv	s6,a0
 558:	8a2e                	mv	s4,a1
 55a:	8bb2                	mv	s7,a2
  state = 0;
 55c:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 55e:	4901                	li	s2,0
 560:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 562:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 566:	06400c13          	li	s8,100
 56a:	a00d                	j	58c <vprintf+0x56>
        putc(fd, c0);
 56c:	85a6                	mv	a1,s1
 56e:	855a                	mv	a0,s6
 570:	f09ff0ef          	jal	478 <putc>
 574:	a019                	j	57a <vprintf+0x44>
    } else if (state == '%') {
 576:	03598363          	beq	s3,s5,59c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 57a:	0019079b          	addiw	a5,s2,1
 57e:	893e                	mv	s2,a5
 580:	873e                	mv	a4,a5
 582:	97d2                	add	a5,a5,s4
 584:	0007c483          	lbu	s1,0(a5)
 588:	24048763          	beqz	s1,7d6 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 58c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 590:	fe0993e3          	bnez	s3,576 <vprintf+0x40>
      if (c0 == '%') {
 594:	fd579ce3          	bne	a5,s5,56c <vprintf+0x36>
        state = '%';
 598:	89be                	mv	s3,a5
 59a:	b7c5                	j	57a <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 59c:	00ea06b3          	add	a3,s4,a4
 5a0:	0016c603          	lbu	a2,1(a3)
      if (c1)
 5a4:	24060563          	beqz	a2,7ee <vprintf+0x2b8>
      if (c0 == 'd') {
 5a8:	0b878763          	beq	a5,s8,656 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5ac:	f9478693          	addi	a3,a5,-108
 5b0:	0016b693          	seqz	a3,a3
 5b4:	f9c60593          	addi	a1,a2,-100
 5b8:	0015b593          	seqz	a1,a1
 5bc:	8df5                	and	a1,a1,a3
 5be:	e9c5                	bnez	a1,66e <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 5c0:	9752                	add	a4,a4,s4
 5c2:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5c6:	f9460713          	addi	a4,a2,-108
 5ca:	00173713          	seqz	a4,a4
 5ce:	8f75                	and	a4,a4,a3
 5d0:	f9c50593          	addi	a1,a0,-100
 5d4:	0015b593          	seqz	a1,a1
 5d8:	8df9                	and	a1,a1,a4
 5da:	e5dd                	bnez	a1,688 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5dc:	07500593          	li	a1,117
 5e0:	0cb78163          	beq	a5,a1,6a2 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5e4:	f8b60593          	addi	a1,a2,-117
 5e8:	0015b593          	seqz	a1,a1
 5ec:	8df5                	and	a1,a1,a3
 5ee:	e5f1                	bnez	a1,6ba <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5f0:	f8b50593          	addi	a1,a0,-117
 5f4:	0015b593          	seqz	a1,a1
 5f8:	8df9                	and	a1,a1,a4
 5fa:	ede9                	bnez	a1,6d4 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5fc:	07800593          	li	a1,120
 600:	0eb78763          	beq	a5,a1,6ee <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 604:	f8860613          	addi	a2,a2,-120
 608:	00163613          	seqz	a2,a2
 60c:	8ef1                	and	a3,a3,a2
 60e:	0e069c63          	bnez	a3,706 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 612:	f8850513          	addi	a0,a0,-120
 616:	00153513          	seqz	a0,a0
 61a:	8f69                	and	a4,a4,a0
 61c:	10071263          	bnez	a4,720 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 620:	07000713          	li	a4,112
 624:	10e78a63          	beq	a5,a4,738 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 628:	06300713          	li	a4,99
 62c:	14e78a63          	beq	a5,a4,780 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 630:	07300713          	li	a4,115
 634:	16e78063          	beq	a5,a4,794 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 638:	02500713          	li	a4,37
 63c:	18e78863          	beq	a5,a4,7cc <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 640:	02500593          	li	a1,37
 644:	855a                	mv	a0,s6
 646:	e33ff0ef          	jal	478 <putc>
        putc(fd, c0);
 64a:	85a6                	mv	a1,s1
 64c:	855a                	mv	a0,s6
 64e:	e2bff0ef          	jal	478 <putc>
      }

      state = 0;
 652:	4981                	li	s3,0
 654:	b71d                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 656:	008b8493          	addi	s1,s7,8
 65a:	4685                	li	a3,1
 65c:	4629                	li	a2,10
 65e:	000ba583          	lw	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e33ff0ef          	jal	496 <printint>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b739                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	008b8493          	addi	s1,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	e1bff0ef          	jal	496 <printint>
        i += 1;
 680:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	bdd5                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	008b8493          	addi	s1,s7,8
 68c:	4685                	li	a3,1
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	e01ff0ef          	jal	496 <printint>
        i += 2;
 69a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	bde9                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6a2:	008b8493          	addi	s1,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4629                	li	a2,10
 6aa:	000be583          	lwu	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	de7ff0ef          	jal	496 <printint>
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b5c9                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	dcfff0ef          	jal	496 <printint>
        i += 1;
 6cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b565                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4681                	li	a3,0
 6da:	4629                	li	a2,10
 6dc:	000bb583          	ld	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	db5ff0ef          	jal	496 <printint>
        i += 2;
 6e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	8ba6                	mv	s7,s1
      state = 0;
 6ea:	4981                	li	s3,0
        i += 2;
 6ec:	b579                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ee:	008b8493          	addi	s1,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4641                	li	a2,16
 6f6:	000be583          	lwu	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	d9bff0ef          	jal	496 <printint>
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	bd9d                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	008b8493          	addi	s1,s7,8
 70a:	4681                	li	a3,0
 70c:	4641                	li	a2,16
 70e:	000bb583          	ld	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	d83ff0ef          	jal	496 <printint>
        i += 1;
 718:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71a:	8ba6                	mv	s7,s1
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bdb1                	j	57a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 720:	008b8493          	addi	s1,s7,8
 724:	4641                	li	a2,16
 726:	000bb583          	ld	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	d6bff0ef          	jal	496 <printint>
        i += 2;
 730:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 732:	8ba6                	mv	s7,s1
      state = 0;
 734:	4981                	li	s3,0
        i += 2;
 736:	b591                	j	57a <vprintf+0x44>
 738:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 73a:	008b8793          	addi	a5,s7,8
 73e:	8cbe                	mv	s9,a5
 740:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 744:	03000593          	li	a1,48
 748:	855a                	mv	a0,s6
 74a:	d2fff0ef          	jal	478 <putc>
  putc(fd, 'x');
 74e:	07800593          	li	a1,120
 752:	855a                	mv	a0,s6
 754:	d25ff0ef          	jal	478 <putc>
 758:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75a:	00000b97          	auipc	s7,0x0
 75e:	2d6b8b93          	addi	s7,s7,726 # a30 <digits>
 762:	03c9d793          	srli	a5,s3,0x3c
 766:	97de                	add	a5,a5,s7
 768:	0007c583          	lbu	a1,0(a5)
 76c:	855a                	mv	a0,s6
 76e:	d0bff0ef          	jal	478 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 772:	0992                	slli	s3,s3,0x4
 774:	34fd                	addiw	s1,s1,-1
 776:	f4f5                	bnez	s1,762 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 778:	8be6                	mv	s7,s9
      state = 0;
 77a:	4981                	li	s3,0
 77c:	6ca2                	ld	s9,8(sp)
 77e:	bbf5                	j	57a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 780:	008b8493          	addi	s1,s7,8
 784:	000bc583          	lbu	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	cefff0ef          	jal	478 <putc>
 78e:	8ba6                	mv	s7,s1
      state = 0;
 790:	4981                	li	s3,0
 792:	b3e5                	j	57a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 794:	008b8993          	addi	s3,s7,8
 798:	000bb483          	ld	s1,0(s7)
 79c:	cc91                	beqz	s1,7b8 <vprintf+0x282>
        for (; *s; s++)
 79e:	0004c583          	lbu	a1,0(s1)
 7a2:	c195                	beqz	a1,7c6 <vprintf+0x290>
          putc(fd, *s);
 7a4:	855a                	mv	a0,s6
 7a6:	cd3ff0ef          	jal	478 <putc>
        for (; *s; s++)
 7aa:	0485                	addi	s1,s1,1
 7ac:	0004c583          	lbu	a1,0(s1)
 7b0:	f9f5                	bnez	a1,7a4 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7b2:	8bce                	mv	s7,s3
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b3d1                	j	57a <vprintf+0x44>
          s = "(null)";
 7b8:	00000497          	auipc	s1,0x0
 7bc:	27048493          	addi	s1,s1,624 # a28 <malloc+0x13e>
        for (; *s; s++)
 7c0:	02800593          	li	a1,40
 7c4:	b7c5                	j	7a4 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7c6:	8bce                	mv	s7,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bb45                	j	57a <vprintf+0x44>
        putc(fd, '%');
 7cc:	85be                	mv	a1,a5
 7ce:	855a                	mv	a0,s6
 7d0:	ca9ff0ef          	jal	478 <putc>
 7d4:	bdbd                	j	652 <vprintf+0x11c>
 7d6:	6906                	ld	s2,64(sp)
 7d8:	79e2                	ld	s3,56(sp)
 7da:	7a42                	ld	s4,48(sp)
 7dc:	7aa2                	ld	s5,40(sp)
 7de:	7b02                	ld	s6,32(sp)
 7e0:	6be2                	ld	s7,24(sp)
 7e2:	6c42                	ld	s8,16(sp)
    }
  }
}
 7e4:	60e6                	ld	ra,88(sp)
 7e6:	6446                	ld	s0,80(sp)
 7e8:	64a6                	ld	s1,72(sp)
 7ea:	6125                	addi	sp,sp,96
 7ec:	8082                	ret
      if (c0 == 'd') {
 7ee:	06400713          	li	a4,100
 7f2:	e6e782e3          	beq	a5,a4,656 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7f6:	f9478693          	addi	a3,a5,-108
 7fa:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7fe:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 800:	4701                	li	a4,0
 802:	bbe9                	j	5dc <vprintf+0xa6>

0000000000000804 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 804:	715d                	addi	sp,sp,-80
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e010                	sd	a2,0(s0)
 80e:	e414                	sd	a3,8(s0)
 810:	e818                	sd	a4,16(s0)
 812:	ec1c                	sd	a5,24(s0)
 814:	03043023          	sd	a6,32(s0)
 818:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	8622                	mv	a2,s0
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	d15ff0ef          	jal	536 <vprintf>
}
 826:	60e2                	ld	ra,24(sp)
 828:	6442                	ld	s0,16(sp)
 82a:	6161                	addi	sp,sp,80
 82c:	8082                	ret

000000000000082e <printf>:

void
printf(const char *fmt, ...)
{
 82e:	711d                	addi	sp,sp,-96
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	1000                	addi	s0,sp,32
 836:	e40c                	sd	a1,8(s0)
 838:	e810                	sd	a2,16(s0)
 83a:	ec14                	sd	a3,24(s0)
 83c:	f018                	sd	a4,32(s0)
 83e:	f41c                	sd	a5,40(s0)
 840:	03043823          	sd	a6,48(s0)
 844:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	00840613          	addi	a2,s0,8
 84c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 850:	85aa                	mv	a1,a0
 852:	4505                	li	a0,1
 854:	ce3ff0ef          	jal	536 <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6125                	addi	sp,sp,96
 85e:	8082                	ret

0000000000000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	1141                	addi	sp,sp,-16
 862:	e406                	sd	ra,8(sp)
 864:	e022                	sd	s0,0(sp)
 866:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 868:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	00000797          	auipc	a5,0x0
 870:	7947b783          	ld	a5,1940(a5) # 1000 <freep>
 874:	a095                	j	8d8 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 876:	ff852583          	lw	a1,-8(a0)
 87a:	6390                	ld	a2,0(a5)
 87c:	02059813          	slli	a6,a1,0x20
 880:	01c85693          	srli	a3,a6,0x1c
 884:	96ba                	add	a3,a3,a4
 886:	02d60563          	beq	a2,a3,8b0 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 88e:	4790                	lw	a2,8(a5)
 890:	02061593          	slli	a1,a2,0x20
 894:	01c5d693          	srli	a3,a1,0x1c
 898:	96be                	add	a3,a3,a5
 89a:	02d70263          	beq	a4,a3,8be <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 89e:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a0:	00000717          	auipc	a4,0x0
 8a4:	76f73023          	sd	a5,1888(a4) # 1000 <freep>
}
 8a8:	60a2                	ld	ra,8(sp)
 8aa:	6402                	ld	s0,0(sp)
 8ac:	0141                	addi	sp,sp,16
 8ae:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8b0:	4614                	lw	a3,8(a2)
 8b2:	9ead                	addw	a3,a3,a1
 8b4:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b8:	6394                	ld	a3,0(a5)
 8ba:	6290                	ld	a2,0(a3)
 8bc:	b7f9                	j	88a <free+0x2a>
    p->s.size += bp->s.size;
 8be:	ff852703          	lw	a4,-8(a0)
 8c2:	9f31                	addw	a4,a4,a2
 8c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c6:	ff053703          	ld	a4,-16(a0)
 8ca:	bfd1                	j	89e <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8cc:	6394                	ld	a3,0(a5)
 8ce:	00d7e463          	bltu	a5,a3,8d6 <free+0x76>
 8d2:	fad762e3          	bltu	a4,a3,876 <free+0x16>
 8d6:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d8:	fee7fae3          	bgeu	a5,a4,8cc <free+0x6c>
 8dc:	6394                	ld	a3,0(a5)
 8de:	f8d76ce3          	bltu	a4,a3,876 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e2:	f8d7fae3          	bgeu	a5,a3,876 <free+0x16>
 8e6:	87b6                	mv	a5,a3
 8e8:	bfc5                	j	8d8 <free+0x78>

00000000000008ea <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8ea:	7139                	addi	sp,sp,-64
 8ec:	fc06                	sd	ra,56(sp)
 8ee:	f822                	sd	s0,48(sp)
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	ec4e                	sd	s3,24(sp)
 8f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8f6:	02051993          	slli	s3,a0,0x20
 8fa:	0209d993          	srli	s3,s3,0x20
 8fe:	09bd                	addi	s3,s3,15
 900:	0049d993          	srli	s3,s3,0x4
 904:	2985                	addiw	s3,s3,1
 906:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 908:	00000517          	auipc	a0,0x0
 90c:	6f853503          	ld	a0,1784(a0) # 1000 <freep>
 910:	c905                	beqz	a0,940 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 912:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 914:	4798                	lw	a4,8(a5)
 916:	09377663          	bgeu	a4,s3,9a2 <malloc+0xb8>
 91a:	f426                	sd	s1,40(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 922:	8a4e                	mv	s4,s3
 924:	6705                	lui	a4,0x1
 926:	00e9f363          	bgeu	s3,a4,92c <malloc+0x42>
 92a:	6a05                	lui	s4,0x1
 92c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 930:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 934:	00000497          	auipc	s1,0x0
 938:	6cc48493          	addi	s1,s1,1740 # 1000 <freep>
  if (p == SBRK_ERROR)
 93c:	5afd                	li	s5,-1
 93e:	a83d                	j	97c <malloc+0x92>
 940:	f426                	sd	s1,40(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 948:	00001797          	auipc	a5,0x1
 94c:	8c078793          	addi	a5,a5,-1856 # 1208 <base>
 950:	00000717          	auipc	a4,0x0
 954:	6af73823          	sd	a5,1712(a4) # 1000 <freep>
 958:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 95e:	b7d1                	j	922 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	a899                	j	9ba <malloc+0xd0>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 96a:	0541                	addi	a0,a0,16
 96c:	ef5ff0ef          	jal	860 <free>
  return freep;
 970:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 972:	c125                	beqz	a0,9d2 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 974:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 976:	4798                	lw	a4,8(a5)
 978:	03277163          	bgeu	a4,s2,99a <malloc+0xb0>
    if (p == freep)
 97c:	6098                	ld	a4,0(s1)
 97e:	853e                	mv	a0,a5
 980:	fef71ae3          	bne	a4,a5,974 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 984:	8552                	mv	a0,s4
 986:	9ffff0ef          	jal	384 <sbrk>
  if (p == SBRK_ERROR)
 98a:	fd551ee3          	bne	a0,s5,966 <malloc+0x7c>
        return 0;
 98e:	4501                	li	a0,0
 990:	74a2                	ld	s1,40(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	a03d                	j	9c6 <malloc+0xdc>
 99a:	74a2                	ld	s1,40(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9a2:	fae90fe3          	beq	s2,a4,960 <malloc+0x76>
        p->s.size -= nunits;
 9a6:	4137073b          	subw	a4,a4,s3
 9aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ac:	02071693          	slli	a3,a4,0x20
 9b0:	01c6d713          	srli	a4,a3,0x1c
 9b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ba:	00000717          	auipc	a4,0x0
 9be:	64a73323          	sd	a0,1606(a4) # 1000 <freep>
      return (void *)(p + 1);
 9c2:	01078513          	addi	a0,a5,16
  }
}
 9c6:	70e2                	ld	ra,56(sp)
 9c8:	7442                	ld	s0,48(sp)
 9ca:	7902                	ld	s2,32(sp)
 9cc:	69e2                	ld	s3,24(sp)
 9ce:	6121                	addi	sp,sp,64
 9d0:	8082                	ret
 9d2:	74a2                	ld	s1,40(sp)
 9d4:	6a42                	ld	s4,16(sp)
 9d6:	6aa2                	ld	s5,8(sp)
 9d8:	6b02                	ld	s6,0(sp)
 9da:	b7f5                	j	9c6 <malloc+0xdc>
