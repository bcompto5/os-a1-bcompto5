
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = {"sh", 0};

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if (open("console", O_RDWR) < 0) {
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	99250513          	addi	a0,a0,-1646 # 9a0 <malloc+0xfc>
  16:	39c000ef          	jal	3b2 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0); // stdout
  1e:	4501                	li	a0,0
  20:	3ca000ef          	jal	3ea <dup>
  dup(0); // stderr
  24:	4501                	li	a0,0
  26:	3c4000ef          	jal	3ea <dup>

  for (;;) {
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	97e90913          	addi	s2,s2,-1666 # 9a8 <malloc+0x104>
  32:	854a                	mv	a0,s2
  34:	7b4000ef          	jal	7e8 <printf>
    pid = fork();
  38:	332000ef          	jal	36a <fork>
  3c:	84aa                	mv	s1,a0
    if (pid < 0) {
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for (;;) {
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *)0);
  44:	4501                	li	a0,0
  46:	334000ef          	jal	37a <wait>
      if (wpid == pid) {
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if (wpid < 0) {
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	9a650513          	addi	a0,a0,-1626 # 9f8 <malloc+0x154>
  5a:	78e000ef          	jal	7e8 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	312000ef          	jal	372 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	93850513          	addi	a0,a0,-1736 # 9a0 <malloc+0xfc>
  70:	34a000ef          	jal	3ba <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	92a50513          	addi	a0,a0,-1750 # 9a0 <malloc+0xfc>
  7e:	334000ef          	jal	3b2 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	93c50513          	addi	a0,a0,-1732 # 9c0 <malloc+0x11c>
  8c:	75c000ef          	jal	7e8 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2e0000ef          	jal	372 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	93a50513          	addi	a0,a0,-1734 # 9d8 <malloc+0x134>
  a6:	304000ef          	jal	3aa <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	93650513          	addi	a0,a0,-1738 # 9e0 <malloc+0x13c>
  b2:	736000ef          	jal	7e8 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2ba000ef          	jal	372 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	2aa000ef          	jal	372 <exit>

00000000000000cc <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0xa>
    ;
  return os;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x20>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x20>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x28>
 12a:	00150793          	addi	a5,a0,1
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x12>
 138:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for (n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfdd                	j	13c <strlen+0x20>

0000000000000148 <memset>:

void *
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 150:	ca19                	beqz	a2,166 <memset+0x1e>
 152:	87aa                	mv	a5,a0
 154:	1602                	slli	a2,a2,0x20
 156:	9201                	srli	a2,a2,0x20
 158:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 160:	0785                	addi	a5,a5,1
 162:	fee79de3          	bne	a5,a4,15c <memset+0x14>
  }
  return dst;
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strchr>:

char *
strchr(const char *s, char c)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  for (; *s; s++)
 176:	00054783          	lbu	a5,0(a0)
 17a:	c799                	beqz	a5,188 <strchr+0x1a>
    if (*s == c)
 17c:	00f58763          	beq	a1,a5,18a <strchr+0x1c>
  for (; *s; s++)
 180:	0505                	addi	a0,a0,1
 182:	00054783          	lbu	a5,0(a0)
 186:	fbfd                	bnez	a5,17c <strchr+0xe>
      return (char *)s;
  return 0;
 188:	4501                	li	a0,0
}
 18a:	60a2                	ld	ra,8(sp)
 18c:	6402                	ld	s0,0(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <gets>:

char *
gets(char *buf, int max)
{
 192:	711d                	addi	sp,sp,-96
 194:	ec86                	sd	ra,88(sp)
 196:	e8a2                	sd	s0,80(sp)
 198:	e4a6                	sd	s1,72(sp)
 19a:	e0ca                	sd	s2,64(sp)
 19c:	fc4e                	sd	s3,56(sp)
 19e:	f852                	sd	s4,48(sp)
 1a0:	f456                	sd	s5,40(sp)
 1a2:	f05a                	sd	s6,32(sp)
 1a4:	ec5e                	sd	s7,24(sp)
 1a6:	e862                	sd	s8,16(sp)
 1a8:	1080                	addi	s0,sp,96
 1aa:	8baa                	mv	s7,a0
 1ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1ae:	892a                	mv	s2,a0
 1b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b2:	faf40b13          	addi	s6,s0,-81
 1b6:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1b8:	8c26                	mv	s8,s1
 1ba:	0014899b          	addiw	s3,s1,1
 1be:	84ce                	mv	s1,s3
 1c0:	0349d863          	bge	s3,s4,1f0 <gets+0x5e>
    cc = read(0, &c, 1);
 1c4:	8656                	mv	a2,s5
 1c6:	85da                	mv	a1,s6
 1c8:	4501                	li	a0,0
 1ca:	1c0000ef          	jal	38a <read>
    if (cc < 1)
 1ce:	02a05163          	blez	a0,1f0 <gets+0x5e>
      break;
    buf[i++] = c;
 1d2:	faf44783          	lbu	a5,-81(s0)
 1d6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1da:	0905                	addi	s2,s2,1
 1dc:	ff678713          	addi	a4,a5,-10
 1e0:	00173713          	seqz	a4,a4
 1e4:	17cd                	addi	a5,a5,-13
 1e6:	0017b793          	seqz	a5,a5
 1ea:	8fd9                	or	a5,a5,a4
 1ec:	d7f1                	beqz	a5,1b8 <gets+0x26>
    buf[i++] = c;
 1ee:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f0:	9c5e                	add	s8,s8,s7
 1f2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f6:	855e                	mv	a0,s7
 1f8:	60e6                	ld	ra,88(sp)
 1fa:	6446                	ld	s0,80(sp)
 1fc:	64a6                	ld	s1,72(sp)
 1fe:	6906                	ld	s2,64(sp)
 200:	79e2                	ld	s3,56(sp)
 202:	7a42                	ld	s4,48(sp)
 204:	7aa2                	ld	s5,40(sp)
 206:	7b02                	ld	s6,32(sp)
 208:	6be2                	ld	s7,24(sp)
 20a:	6c42                	ld	s8,16(sp)
 20c:	6125                	addi	sp,sp,96
 20e:	8082                	ret

0000000000000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	1101                	addi	sp,sp,-32
 212:	ec06                	sd	ra,24(sp)
 214:	e822                	sd	s0,16(sp)
 216:	e04a                	sd	s2,0(sp)
 218:	1000                	addi	s0,sp,32
 21a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21c:	4581                	li	a1,0
 21e:	194000ef          	jal	3b2 <open>
  if (fd < 0)
 222:	02054263          	bltz	a0,246 <stat+0x36>
 226:	e426                	sd	s1,8(sp)
 228:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22a:	85ca                	mv	a1,s2
 22c:	19e000ef          	jal	3ca <fstat>
 230:	892a                	mv	s2,a0
  close(fd);
 232:	8526                	mv	a0,s1
 234:	166000ef          	jal	39a <close>
  return r;
 238:	64a2                	ld	s1,8(sp)
}
 23a:	854a                	mv	a0,s2
 23c:	60e2                	ld	ra,24(sp)
 23e:	6442                	ld	s0,16(sp)
 240:	6902                	ld	s2,0(sp)
 242:	6105                	addi	sp,sp,32
 244:	8082                	ret
    return -1;
 246:	57fd                	li	a5,-1
 248:	893e                	mv	s2,a5
 24a:	bfc5                	j	23a <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 254:	00054683          	lbu	a3,0(a0)
 258:	fd06879b          	addiw	a5,a3,-48
 25c:	0ff7f793          	zext.b	a5,a5
 260:	4625                	li	a2,9
 262:	02f66963          	bltu	a2,a5,294 <atoi+0x48>
 266:	872a                	mv	a4,a0
  n = 0;
 268:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 26a:	0705                	addi	a4,a4,1
 26c:	0025179b          	slliw	a5,a0,0x2
 270:	9fa9                	addw	a5,a5,a0
 272:	0017979b          	slliw	a5,a5,0x1
 276:	9fb5                	addw	a5,a5,a3
 278:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 27c:	00074683          	lbu	a3,0(a4)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	fef671e3          	bgeu	a2,a5,26a <atoi+0x1e>
  return n;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  n = 0;
 294:	4501                	li	a0,0
 296:	bfdd                	j	28c <atoi+0x40>

0000000000000298 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57563          	bgeu	a0,a1,2ca <memmove+0x32>
    while (n-- > 0)
 2a4:	00c05f63          	blez	a2,2c2 <memmove+0x2a>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b2:	0585                	addi	a1,a1,1
 2b4:	0705                	addi	a4,a4,1
 2b6:	fff5c683          	lbu	a3,-1(a1)
 2ba:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2be:	fee79ae3          	bne	a5,a4,2b2 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
    while (n-- > 0)
 2ca:	fec05ce3          	blez	a2,2c2 <memmove+0x2a>
    dst += n;
 2ce:	00c50733          	add	a4,a0,a2
    src += n;
 2d2:	95b2                	add	a1,a1,a2
 2d4:	fff6079b          	addiw	a5,a2,-1
 2d8:	1782                	slli	a5,a5,0x20
 2da:	9381                	srli	a5,a5,0x20
 2dc:	fff7c793          	not	a5,a5
 2e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e2:	15fd                	addi	a1,a1,-1
 2e4:	177d                	addi	a4,a4,-1
 2e6:	0005c683          	lbu	a3,0(a1)
 2ea:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2ee:	fef71ae3          	bne	a4,a5,2e2 <memmove+0x4a>
 2f2:	bfc1                	j	2c2 <memmove+0x2a>

00000000000002f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ce19                	beqz	a2,31a <memcmp+0x26>
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 306:	00054783          	lbu	a5,0(a0)
 30a:	0005c703          	lbu	a4,0(a1)
 30e:	00e79b63          	bne	a5,a4,324 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 312:	0505                	addi	a0,a0,1
    p2++;
 314:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 316:	fed518e3          	bne	a0,a3,306 <memcmp+0x12>
  }
  return 0;
 31a:	4501                	li	a0,0
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
      return *p1 - *p2;
 324:	40e7853b          	subw	a0,a5,a4
 328:	bfd5                	j	31c <memcmp+0x28>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	f67ff0ef          	jal	298 <memmove>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <sbrk>:

char *
sbrk(int n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 346:	4585                	li	a1,1
 348:	0b2000ef          	jal	3fa <sys_sbrk>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <sbrklazy>:

char *
sbrklazy(int n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 35c:	4589                	li	a1,2
 35e:	09c000ef          	jal	3fa <sys_sbrk>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36a:	4885                	li	a7,1
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exit>:
.global exit
exit:
 li a7, SYS_exit
 372:	4889                	li	a7,2
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <wait>:
.global wait
wait:
 li a7, SYS_wait
 37a:	488d                	li	a7,3
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 382:	4891                	li	a7,4
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <read>:
.global read
read:
 li a7, SYS_read
 38a:	4895                	li	a7,5
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <write>:
.global write
write:
 li a7, SYS_write
 392:	48c1                	li	a7,16
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <close>:
.global close
close:
 li a7, SYS_close
 39a:	48d5                	li	a7,21
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a2:	4899                	li	a7,6
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3aa:	489d                	li	a7,7
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <open>:
.global open
open:
 li a7, SYS_open
 3b2:	48bd                	li	a7,15
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ba:	48c5                	li	a7,17
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c2:	48c9                	li	a7,18
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ca:	48a1                	li	a7,8
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <link>:
.global link
link:
 li a7, SYS_link
 3d2:	48cd                	li	a7,19
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3da:	48d1                	li	a7,20
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e2:	48a5                	li	a7,9
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ea:	48a9                	li	a7,10
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f2:	48ad                	li	a7,11
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3fa:	48b1                	li	a7,12
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <pause>:
.global pause
pause:
 li a7, SYS_pause
 402:	48b5                	li	a7,13
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40a:	48b9                	li	a7,14
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sync>:
.global sync
sync:
 li a7, SYS_sync
 412:	48d9                	li	a7,22
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <trace>:
.global trace
trace:
 li a7, SYS_trace
 41a:	48dd                	li	a7,23
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 422:	48e1                	li	a7,24
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 42a:	48e5                	li	a7,25
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 432:	1101                	addi	sp,sp,-32
 434:	ec06                	sd	ra,24(sp)
 436:	e822                	sd	s0,16(sp)
 438:	1000                	addi	s0,sp,32
 43a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43e:	4605                	li	a2,1
 440:	fef40593          	addi	a1,s0,-17
 444:	f4fff0ef          	jal	392 <write>
}
 448:	60e2                	ld	ra,24(sp)
 44a:	6442                	ld	s0,16(sp)
 44c:	6105                	addi	sp,sp,32
 44e:	8082                	ret

0000000000000450 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 450:	715d                	addi	sp,sp,-80
 452:	e486                	sd	ra,72(sp)
 454:	e0a2                	sd	s0,64(sp)
 456:	f84a                	sd	s2,48(sp)
 458:	f44e                	sd	s3,40(sp)
 45a:	0880                	addi	s0,sp,80
 45c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 45e:	00d036b3          	snez	a3,a3
 462:	03f5d793          	srli	a5,a1,0x3f
 466:	8efd                	and	a3,a3,a5
  neg = 0;
 468:	4301                	li	t1,0
  if (sgn && xx < 0) {
 46a:	c681                	beqz	a3,472 <printint+0x22>
    neg = 1;
    x = -xx;
 46c:	40b005b3          	neg	a1,a1
    neg = 1;
 470:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 472:	fb840993          	addi	s3,s0,-72
  neg = 0;
 476:	86ce                	mv	a3,s3
  i = 0;
 478:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 47a:	00000817          	auipc	a6,0x0
 47e:	5a680813          	addi	a6,a6,1446 # a20 <digits>
 482:	88ba                	mv	a7,a4
 484:	0017051b          	addiw	a0,a4,1
 488:	872a                	mv	a4,a0
 48a:	02c5f7b3          	remu	a5,a1,a2
 48e:	97c2                	add	a5,a5,a6
 490:	0007c783          	lbu	a5,0(a5)
 494:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 498:	87ae                	mv	a5,a1
 49a:	02c5d5b3          	divu	a1,a1,a2
 49e:	0685                	addi	a3,a3,1
 4a0:	fec7f1e3          	bgeu	a5,a2,482 <printint+0x32>
  if (neg)
 4a4:	00030b63          	beqz	t1,4ba <printint+0x6a>
    buf[i++] = '-';
 4a8:	fd040793          	addi	a5,s0,-48
 4ac:	953e                	add	a0,a0,a5
 4ae:	02d00793          	li	a5,45
 4b2:	fef50423          	sb	a5,-24(a0)
 4b6:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4ba:	02e05563          	blez	a4,4e4 <printint+0x94>
 4be:	fc26                	sd	s1,56(sp)
 4c0:	377d                	addiw	a4,a4,-1
 4c2:	00e984b3          	add	s1,s3,a4
 4c6:	19fd                	addi	s3,s3,-1
 4c8:	99ba                	add	s3,s3,a4
 4ca:	1702                	slli	a4,a4,0x20
 4cc:	9301                	srli	a4,a4,0x20
 4ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d2:	0004c583          	lbu	a1,0(s1)
 4d6:	854a                	mv	a0,s2
 4d8:	f5bff0ef          	jal	432 <putc>
  while (--i >= 0)
 4dc:	14fd                	addi	s1,s1,-1
 4de:	ff349ae3          	bne	s1,s3,4d2 <printint+0x82>
 4e2:	74e2                	ld	s1,56(sp)
}
 4e4:	60a6                	ld	ra,72(sp)
 4e6:	6406                	ld	s0,64(sp)
 4e8:	7942                	ld	s2,48(sp)
 4ea:	79a2                	ld	s3,40(sp)
 4ec:	6161                	addi	sp,sp,80
 4ee:	8082                	ret

00000000000004f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f0:	711d                	addi	sp,sp,-96
 4f2:	ec86                	sd	ra,88(sp)
 4f4:	e8a2                	sd	s0,80(sp)
 4f6:	e4a6                	sd	s1,72(sp)
 4f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4fa:	0005c483          	lbu	s1,0(a1)
 4fe:	2a048063          	beqz	s1,79e <vprintf+0x2ae>
 502:	e0ca                	sd	s2,64(sp)
 504:	fc4e                	sd	s3,56(sp)
 506:	f852                	sd	s4,48(sp)
 508:	f456                	sd	s5,40(sp)
 50a:	f05a                	sd	s6,32(sp)
 50c:	ec5e                	sd	s7,24(sp)
 50e:	e862                	sd	s8,16(sp)
 510:	8b2a                	mv	s6,a0
 512:	8a2e                	mv	s4,a1
 514:	8bb2                	mv	s7,a2
  state = 0;
 516:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 518:	4901                	li	s2,0
 51a:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 51c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 520:	06400c13          	li	s8,100
 524:	a00d                	j	546 <vprintf+0x56>
        putc(fd, c0);
 526:	85a6                	mv	a1,s1
 528:	855a                	mv	a0,s6
 52a:	f09ff0ef          	jal	432 <putc>
 52e:	a019                	j	534 <vprintf+0x44>
    } else if (state == '%') {
 530:	03598363          	beq	s3,s5,556 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 534:	0019079b          	addiw	a5,s2,1
 538:	893e                	mv	s2,a5
 53a:	873e                	mv	a4,a5
 53c:	97d2                	add	a5,a5,s4
 53e:	0007c483          	lbu	s1,0(a5)
 542:	24048763          	beqz	s1,790 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 546:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 54a:	fe0993e3          	bnez	s3,530 <vprintf+0x40>
      if (c0 == '%') {
 54e:	fd579ce3          	bne	a5,s5,526 <vprintf+0x36>
        state = '%';
 552:	89be                	mv	s3,a5
 554:	b7c5                	j	534 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 556:	00ea06b3          	add	a3,s4,a4
 55a:	0016c603          	lbu	a2,1(a3)
      if (c1)
 55e:	24060563          	beqz	a2,7a8 <vprintf+0x2b8>
      if (c0 == 'd') {
 562:	0b878763          	beq	a5,s8,610 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 566:	f9478693          	addi	a3,a5,-108
 56a:	0016b693          	seqz	a3,a3
 56e:	f9c60593          	addi	a1,a2,-100
 572:	0015b593          	seqz	a1,a1
 576:	8df5                	and	a1,a1,a3
 578:	e9c5                	bnez	a1,628 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 57a:	9752                	add	a4,a4,s4
 57c:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 580:	f9460713          	addi	a4,a2,-108
 584:	00173713          	seqz	a4,a4
 588:	8f75                	and	a4,a4,a3
 58a:	f9c50593          	addi	a1,a0,-100
 58e:	0015b593          	seqz	a1,a1
 592:	8df9                	and	a1,a1,a4
 594:	e5dd                	bnez	a1,642 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 596:	07500593          	li	a1,117
 59a:	0cb78163          	beq	a5,a1,65c <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 59e:	f8b60593          	addi	a1,a2,-117
 5a2:	0015b593          	seqz	a1,a1
 5a6:	8df5                	and	a1,a1,a3
 5a8:	e5f1                	bnez	a1,674 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5aa:	f8b50593          	addi	a1,a0,-117
 5ae:	0015b593          	seqz	a1,a1
 5b2:	8df9                	and	a1,a1,a4
 5b4:	ede9                	bnez	a1,68e <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5b6:	07800593          	li	a1,120
 5ba:	0eb78763          	beq	a5,a1,6a8 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5be:	f8860613          	addi	a2,a2,-120
 5c2:	00163613          	seqz	a2,a2
 5c6:	8ef1                	and	a3,a3,a2
 5c8:	0e069c63          	bnez	a3,6c0 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5cc:	f8850513          	addi	a0,a0,-120
 5d0:	00153513          	seqz	a0,a0
 5d4:	8f69                	and	a4,a4,a0
 5d6:	10071263          	bnez	a4,6da <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5da:	07000713          	li	a4,112
 5de:	10e78a63          	beq	a5,a4,6f2 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5e2:	06300713          	li	a4,99
 5e6:	14e78a63          	beq	a5,a4,73a <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5ea:	07300713          	li	a4,115
 5ee:	16e78063          	beq	a5,a4,74e <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5f2:	02500713          	li	a4,37
 5f6:	18e78863          	beq	a5,a4,786 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fa:	02500593          	li	a1,37
 5fe:	855a                	mv	a0,s6
 600:	e33ff0ef          	jal	432 <putc>
        putc(fd, c0);
 604:	85a6                	mv	a1,s1
 606:	855a                	mv	a0,s6
 608:	e2bff0ef          	jal	432 <putc>
      }

      state = 0;
 60c:	4981                	li	s3,0
 60e:	b71d                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 610:	008b8493          	addi	s1,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e33ff0ef          	jal	450 <printint>
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	b739                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8493          	addi	s1,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e1bff0ef          	jal	450 <printint>
        i += 1;
 63a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
 640:	bdd5                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 642:	008b8493          	addi	s1,s7,8
 646:	4685                	li	a3,1
 648:	4629                	li	a2,10
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	e01ff0ef          	jal	450 <printint>
        i += 2;
 654:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	bde9                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000be583          	lwu	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	de7ff0ef          	jal	450 <printint>
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
 672:	b5c9                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8493          	addi	s1,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dcfff0ef          	jal	450 <printint>
        i += 1;
 686:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b565                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68e:	008b8493          	addi	s1,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000bb583          	ld	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	db5ff0ef          	jal	450 <printint>
        i += 2;
 6a0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
        i += 2;
 6a6:	b579                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a8:	008b8493          	addi	s1,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000be583          	lwu	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d9bff0ef          	jal	450 <printint>
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd9d                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	008b8493          	addi	s1,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d83ff0ef          	jal	450 <printint>
        i += 1;
 6d2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	8ba6                	mv	s7,s1
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bdb1                	j	534 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6da:	008b8493          	addi	s1,s7,8
 6de:	4641                	li	a2,16
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	d6bff0ef          	jal	450 <printint>
        i += 2;
 6ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8ba6                	mv	s7,s1
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	b591                	j	534 <vprintf+0x44>
 6f2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6f4:	008b8793          	addi	a5,s7,8
 6f8:	8cbe                	mv	s9,a5
 6fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fe:	03000593          	li	a1,48
 702:	855a                	mv	a0,s6
 704:	d2fff0ef          	jal	432 <putc>
  putc(fd, 'x');
 708:	07800593          	li	a1,120
 70c:	855a                	mv	a0,s6
 70e:	d25ff0ef          	jal	432 <putc>
 712:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	00000b97          	auipc	s7,0x0
 718:	30cb8b93          	addi	s7,s7,780 # a20 <digits>
 71c:	03c9d793          	srli	a5,s3,0x3c
 720:	97de                	add	a5,a5,s7
 722:	0007c583          	lbu	a1,0(a5)
 726:	855a                	mv	a0,s6
 728:	d0bff0ef          	jal	432 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72c:	0992                	slli	s3,s3,0x4
 72e:	34fd                	addiw	s1,s1,-1
 730:	f4f5                	bnez	s1,71c <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 732:	8be6                	mv	s7,s9
      state = 0;
 734:	4981                	li	s3,0
 736:	6ca2                	ld	s9,8(sp)
 738:	bbf5                	j	534 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 73a:	008b8493          	addi	s1,s7,8
 73e:	000bc583          	lbu	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	cefff0ef          	jal	432 <putc>
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b3e5                	j	534 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 74e:	008b8993          	addi	s3,s7,8
 752:	000bb483          	ld	s1,0(s7)
 756:	cc91                	beqz	s1,772 <vprintf+0x282>
        for (; *s; s++)
 758:	0004c583          	lbu	a1,0(s1)
 75c:	c195                	beqz	a1,780 <vprintf+0x290>
          putc(fd, *s);
 75e:	855a                	mv	a0,s6
 760:	cd3ff0ef          	jal	432 <putc>
        for (; *s; s++)
 764:	0485                	addi	s1,s1,1
 766:	0004c583          	lbu	a1,0(s1)
 76a:	f9f5                	bnez	a1,75e <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 76c:	8bce                	mv	s7,s3
      state = 0;
 76e:	4981                	li	s3,0
 770:	b3d1                	j	534 <vprintf+0x44>
          s = "(null)";
 772:	00000497          	auipc	s1,0x0
 776:	2a648493          	addi	s1,s1,678 # a18 <malloc+0x174>
        for (; *s; s++)
 77a:	02800593          	li	a1,40
 77e:	b7c5                	j	75e <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 780:	8bce                	mv	s7,s3
      state = 0;
 782:	4981                	li	s3,0
 784:	bb45                	j	534 <vprintf+0x44>
        putc(fd, '%');
 786:	85be                	mv	a1,a5
 788:	855a                	mv	a0,s6
 78a:	ca9ff0ef          	jal	432 <putc>
 78e:	bdbd                	j	60c <vprintf+0x11c>
 790:	6906                	ld	s2,64(sp)
 792:	79e2                	ld	s3,56(sp)
 794:	7a42                	ld	s4,48(sp)
 796:	7aa2                	ld	s5,40(sp)
 798:	7b02                	ld	s6,32(sp)
 79a:	6be2                	ld	s7,24(sp)
 79c:	6c42                	ld	s8,16(sp)
    }
  }
}
 79e:	60e6                	ld	ra,88(sp)
 7a0:	6446                	ld	s0,80(sp)
 7a2:	64a6                	ld	s1,72(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret
      if (c0 == 'd') {
 7a8:	06400713          	li	a4,100
 7ac:	e6e782e3          	beq	a5,a4,610 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7b0:	f9478693          	addi	a3,a5,-108
 7b4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7b8:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7ba:	4701                	li	a4,0
 7bc:	bbe9                	j	596 <vprintf+0xa6>

00000000000007be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7be:	715d                	addi	sp,sp,-80
 7c0:	ec06                	sd	ra,24(sp)
 7c2:	e822                	sd	s0,16(sp)
 7c4:	1000                	addi	s0,sp,32
 7c6:	e010                	sd	a2,0(s0)
 7c8:	e414                	sd	a3,8(s0)
 7ca:	e818                	sd	a4,16(s0)
 7cc:	ec1c                	sd	a5,24(s0)
 7ce:	03043023          	sd	a6,32(s0)
 7d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d6:	8622                	mv	a2,s0
 7d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7dc:	d15ff0ef          	jal	4f0 <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6161                	addi	sp,sp,80
 7e6:	8082                	ret

00000000000007e8 <printf>:

void
printf(const char *fmt, ...)
{
 7e8:	711d                	addi	sp,sp,-96
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	addi	s0,sp,32
 7f0:	e40c                	sd	a1,8(s0)
 7f2:	e810                	sd	a2,16(s0)
 7f4:	ec14                	sd	a3,24(s0)
 7f6:	f018                	sd	a4,32(s0)
 7f8:	f41c                	sd	a5,40(s0)
 7fa:	03043823          	sd	a6,48(s0)
 7fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	00840613          	addi	a2,s0,8
 806:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80a:	85aa                	mv	a1,a0
 80c:	4505                	li	a0,1
 80e:	ce3ff0ef          	jal	4f0 <vprintf>
}
 812:	60e2                	ld	ra,24(sp)
 814:	6442                	ld	s0,16(sp)
 816:	6125                	addi	sp,sp,96
 818:	8082                	ret

000000000000081a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81a:	1141                	addi	sp,sp,-16
 81c:	e406                	sd	ra,8(sp)
 81e:	e022                	sd	s0,0(sp)
 820:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 822:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	00000797          	auipc	a5,0x0
 82a:	7ea7b783          	ld	a5,2026(a5) # 1010 <freep>
 82e:	a095                	j	892 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059813          	slli	a6,a1,0x20
 83a:	01c85693          	srli	a3,a6,0x1c
 83e:	96ba                	add	a3,a3,a4
 840:	02d60563          	beq	a2,a3,86a <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 848:	4790                	lw	a2,8(a5)
 84a:	02061593          	slli	a1,a2,0x20
 84e:	01c5d693          	srli	a3,a1,0x1c
 852:	96be                	add	a3,a3,a5
 854:	02d70263          	beq	a4,a3,878 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 858:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73b23          	sd	a5,1974(a4) # 1010 <freep>
}
 862:	60a2                	ld	ra,8(sp)
 864:	6402                	ld	s0,0(sp)
 866:	0141                	addi	sp,sp,16
 868:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 86a:	4614                	lw	a3,8(a2)
 86c:	9ead                	addw	a3,a3,a1
 86e:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 872:	6394                	ld	a3,0(a5)
 874:	6290                	ld	a2,0(a3)
 876:	b7f9                	j	844 <free+0x2a>
    p->s.size += bp->s.size;
 878:	ff852703          	lw	a4,-8(a0)
 87c:	9f31                	addw	a4,a4,a2
 87e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 880:	ff053703          	ld	a4,-16(a0)
 884:	bfd1                	j	858 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	6394                	ld	a3,0(a5)
 888:	00d7e463          	bltu	a5,a3,890 <free+0x76>
 88c:	fad762e3          	bltu	a4,a3,830 <free+0x16>
 890:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	fee7fae3          	bgeu	a5,a4,886 <free+0x6c>
 896:	6394                	ld	a3,0(a5)
 898:	f8d76ce3          	bltu	a4,a3,830 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	f8d7fae3          	bgeu	a5,a3,830 <free+0x16>
 8a0:	87b6                	mv	a5,a3
 8a2:	bfc5                	j	892 <free+0x78>

00000000000008a4 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8a4:	7139                	addi	sp,sp,-64
 8a6:	fc06                	sd	ra,56(sp)
 8a8:	f822                	sd	s0,48(sp)
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	ec4e                	sd	s3,24(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8b0:	02051993          	slli	s3,a0,0x20
 8b4:	0209d993          	srli	s3,s3,0x20
 8b8:	09bd                	addi	s3,s3,15
 8ba:	0049d993          	srli	s3,s3,0x4
 8be:	2985                	addiw	s3,s3,1
 8c0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8c2:	00000517          	auipc	a0,0x0
 8c6:	74e53503          	ld	a0,1870(a0) # 1010 <freep>
 8ca:	c905                	beqz	a0,8fa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8cc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ce:	4798                	lw	a4,8(a5)
 8d0:	09377663          	bgeu	a4,s3,95c <malloc+0xb8>
 8d4:	f426                	sd	s1,40(sp)
 8d6:	e852                	sd	s4,16(sp)
 8d8:	e456                	sd	s5,8(sp)
 8da:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8dc:	8a4e                	mv	s4,s3
 8de:	6705                	lui	a4,0x1
 8e0:	00e9f363          	bgeu	s3,a4,8e6 <malloc+0x42>
 8e4:	6a05                	lui	s4,0x1
 8e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8ee:	00000497          	auipc	s1,0x0
 8f2:	72248493          	addi	s1,s1,1826 # 1010 <freep>
  if (p == SBRK_ERROR)
 8f6:	5afd                	li	s5,-1
 8f8:	a83d                	j	936 <malloc+0x92>
 8fa:	f426                	sd	s1,40(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 902:	00000797          	auipc	a5,0x0
 906:	71e78793          	addi	a5,a5,1822 # 1020 <base>
 90a:	00000717          	auipc	a4,0x0
 90e:	70f73323          	sd	a5,1798(a4) # 1010 <freep>
 912:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 914:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 918:	b7d1                	j	8dc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 91a:	6398                	ld	a4,0(a5)
 91c:	e118                	sd	a4,0(a0)
 91e:	a899                	j	974 <malloc+0xd0>
  hp->s.size = nu;
 920:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 924:	0541                	addi	a0,a0,16
 926:	ef5ff0ef          	jal	81a <free>
  return freep;
 92a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 92c:	c125                	beqz	a0,98c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 92e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 930:	4798                	lw	a4,8(a5)
 932:	03277163          	bgeu	a4,s2,954 <malloc+0xb0>
    if (p == freep)
 936:	6098                	ld	a4,0(s1)
 938:	853e                	mv	a0,a5
 93a:	fef71ae3          	bne	a4,a5,92e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	9ffff0ef          	jal	33e <sbrk>
  if (p == SBRK_ERROR)
 944:	fd551ee3          	bne	a0,s5,920 <malloc+0x7c>
        return 0;
 948:	4501                	li	a0,0
 94a:	74a2                	ld	s1,40(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
 952:	a03d                	j	980 <malloc+0xdc>
 954:	74a2                	ld	s1,40(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 95c:	fae90fe3          	beq	s2,a4,91a <malloc+0x76>
        p->s.size -= nunits;
 960:	4137073b          	subw	a4,a4,s3
 964:	c798                	sw	a4,8(a5)
        p += p->s.size;
 966:	02071693          	slli	a3,a4,0x20
 96a:	01c6d713          	srli	a4,a3,0x1c
 96e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 970:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 974:	00000717          	auipc	a4,0x0
 978:	68a73e23          	sd	a0,1692(a4) # 1010 <freep>
      return (void *)(p + 1);
 97c:	01078513          	addi	a0,a5,16
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	7902                	ld	s2,32(sp)
 986:	69e2                	ld	s3,24(sp)
 988:	6121                	addi	sp,sp,64
 98a:	8082                	ret
 98c:	74a2                	ld	s1,40(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	b7f5                	j	980 <malloc+0xdc>
