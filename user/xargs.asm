
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/param.h"
#include "user/user.h"

char words[MAXARG][512];

int main(int argc, char *argv[]) {
   0:	c7010113          	addi	sp,sp,-912
   4:	38113423          	sd	ra,904(sp)
   8:	38813023          	sd	s0,896(sp)
   c:	36913c23          	sd	s1,888(sp)
  10:	37413023          	sd	s4,864(sp)
  14:	0f00                	addi	s0,sp,912
	char c;

	start = 1;
	limit = 0;

	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  16:	4785                	li	a5,1
  18:	0ea7d963          	bge	a5,a0,10a <main+0x10a>
  1c:	8a2a                	mv	s4,a0
  1e:	84ae                	mv	s1,a1
  20:	00001597          	auipc	a1,0x1
  24:	c4058593          	addi	a1,a1,-960 # c60 <malloc+0xfe>
  28:	6488                	ld	a0,8(s1)
  2a:	380000ef          	jal	3aa <strcmp>
  2e:	e151                	bnez	a0,b2 <main+0xb2>
		if (argc < 4) {
  30:	478d                	li	a5,3
  32:	0347ce63          	blt	a5,s4,6e <main+0x6e>
  36:	37213823          	sd	s2,880(sp)
  3a:	37313423          	sd	s3,872(sp)
  3e:	35513c23          	sd	s5,856(sp)
  42:	35613823          	sd	s6,848(sp)
  46:	35713423          	sd	s7,840(sp)
  4a:	35813023          	sd	s8,832(sp)
  4e:	33913c23          	sd	s9,824(sp)
  52:	33a13823          	sd	s10,816(sp)
  56:	33b13423          	sd	s11,808(sp)
			fprintf(2, "usage: xargs [-n N] cmd [args...]\n");
  5a:	00001597          	auipc	a1,0x1
  5e:	c0e58593          	addi	a1,a1,-1010 # c68 <malloc+0x106>
  62:	4509                	li	a0,2
  64:	219000ef          	jal	a7c <fprintf>
			exit(1);
  68:	4505                	li	a0,1
  6a:	5c6000ef          	jal	630 <exit>
		}

		limit = atoi(argv[2]);
  6e:	6888                	ld	a0,16(s1)
  70:	49a000ef          	jal	50a <atoi>
		if (limit < 1) {
			fprintf(2, "usage: xargs [-n N] cmd [args...]\n");
			exit(1);
		}

		start = 3;
  74:	468d                	li	a3,3
		if (limit < 1) {
  76:	04a04063          	bgtz	a0,b6 <main+0xb6>
  7a:	37213823          	sd	s2,880(sp)
  7e:	37313423          	sd	s3,872(sp)
  82:	35513c23          	sd	s5,856(sp)
  86:	35613823          	sd	s6,848(sp)
  8a:	35713423          	sd	s7,840(sp)
  8e:	35813023          	sd	s8,832(sp)
  92:	33913c23          	sd	s9,824(sp)
  96:	33a13823          	sd	s10,816(sp)
  9a:	33b13423          	sd	s11,808(sp)
			fprintf(2, "usage: xargs [-n N] cmd [args...]\n");
  9e:	00001597          	auipc	a1,0x1
  a2:	bca58593          	addi	a1,a1,-1078 # c68 <malloc+0x106>
  a6:	4509                	li	a0,2
  a8:	1d5000ef          	jal	a7c <fprintf>
			exit(1);
  ac:	4505                	li	a0,1
  ae:	582000ef          	jal	630 <exit>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  b2:	4501                	li	a0,0
  b4:	4685                	li	a3,1
  b6:	37213823          	sd	s2,880(sp)
  ba:	37313423          	sd	s3,872(sp)
  be:	35513c23          	sd	s5,856(sp)
  c2:	35613823          	sd	s6,848(sp)
  c6:	35713423          	sd	s7,840(sp)
  ca:	35813023          	sd	s8,832(sp)
  ce:	33913c23          	sd	s9,824(sp)
  d2:	33a13823          	sd	s10,816(sp)
  d6:	33b13423          	sd	s11,808(sp)
	}

	if (start >= argc) exit(1);

	base = 0;
	for (i = start; i < argc; i++) {
  da:	00369793          	slli	a5,a3,0x3
  de:	00f485b3          	add	a1,s1,a5
  e2:	c9040793          	addi	a5,s0,-880
	base = 0;
  e6:	4901                	li	s2,0
		if (base >= MAXARG - 1) exit(1);
  e8:	467d                	li	a2,31
		args[base++] = argv[i];
  ea:	0019099b          	addiw	s3,s2,1
  ee:	894e                	mv	s2,s3
  f0:	6198                	ld	a4,0(a1)
  f2:	e398                	sd	a4,0(a5)
	for (i = start; i < argc; i++) {
  f4:	00d9873b          	addw	a4,s3,a3
  f8:	03475e63          	bge	a4,s4,134 <main+0x134>
		if (base >= MAXARG - 1) exit(1);
  fc:	05a1                	addi	a1,a1,8
  fe:	07a1                	addi	a5,a5,8
 100:	fec915e3          	bne	s2,a2,ea <main+0xea>
 104:	4505                	li	a0,1
 106:	52a000ef          	jal	630 <exit>
 10a:	37213823          	sd	s2,880(sp)
 10e:	37313423          	sd	s3,872(sp)
 112:	35513c23          	sd	s5,856(sp)
 116:	35613823          	sd	s6,848(sp)
 11a:	35713423          	sd	s7,840(sp)
 11e:	35813023          	sd	s8,832(sp)
 122:	33913c23          	sd	s9,824(sp)
 126:	33a13823          	sd	s10,816(sp)
 12a:	33b13423          	sd	s11,808(sp)
	if (start >= argc) exit(1);
 12e:	4505                	li	a0,1
 130:	500000ef          	jal	630 <exit>
	}

	if (limit == 0)	limit = MAXARG - 1 - base;
 134:	e501                	bnez	a0,13c <main+0x13c>
 136:	457d                	li	a0,31
 138:	4135053b          	subw	a0,a0,s3
	if (limit > MAXARG - 1 - base) limit = MAXARG - 1 - base;
 13c:	4cfd                	li	s9,31
 13e:	413c8cbb          	subw	s9,s9,s3
 142:	87e6                	mv	a5,s9
 144:	01955363          	bge	a0,s9,14a <main+0x14a>
 148:	87aa                	mv	a5,a0
 14a:	2781                	sext.w	a5,a5
 14c:	c6f43c23          	sd	a5,-904(s0)
	if (limit < 1) exit(1);
 150:	02f05363          	blez	a5,176 <main+0x176>
					if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
					count = 0;
				}
			}

			if (c == '\n' && count > 0 && limit == MAXARG - 1 - base) {
 154:	01952cb3          	slt	s9,a0,s9
 158:	001ccc93          	xori	s9,s9,1
	inword = 0;
 15c:	4b81                	li	s7,0
	len = 0;
 15e:	4a01                	li	s4,0
	failed = 0;
 160:	c6043823          	sd	zero,-912(s0)
	count = 0;
 164:	4a81                	li	s5,0
	while (read(0, &c, 1) == 1) {
 166:	c8b40c13          	addi	s8,s0,-885
 16a:	4b05                	li	s6,1
				}
				if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
				count = 0;
			}
		} else {
			if (len < sizeof(buf) - 1) {
 16c:	1fe00d13          	li	s10,510
				strcpy(words[count], buf);
 170:	d9040d93          	addi	s11,s0,-624
 174:	a8a9                	j	1ce <main+0x1ce>
	if (limit < 1) exit(1);
 176:	4505                	li	a0,1
 178:	4b8000ef          	jal	630 <exit>
						exec(args[0], args);
 17c:	c9040593          	addi	a1,s0,-880
 180:	c9043503          	ld	a0,-880(s0)
 184:	4e4000ef          	jal	668 <exec>
						exit(1);
 188:	4505                	li	a0,1
 18a:	4a6000ef          	jal	630 <exit>
					if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
 18e:	c8c40513          	addi	a0,s0,-884
 192:	4a6000ef          	jal	638 <wait>
 196:	0c054163          	bltz	a0,258 <main+0x258>
 19a:	c8c42783          	lw	a5,-884(s0)
 19e:	00f037b3          	snez	a5,a5
 1a2:	c7043703          	ld	a4,-912(s0)
 1a6:	8fd9                	or	a5,a5,a4
 1a8:	2781                	sext.w	a5,a5
 1aa:	c6f43823          	sd	a5,-912(s0)
 1ae:	4b81                	li	s7,0
 1b0:	4a01                	li	s4,0
 1b2:	4a81                	li	s5,0
 1b4:	a829                	j	1ce <main+0x1ce>
			if (c == '\n' && count > 0 && limit == MAXARG - 1 - base) {
 1b6:	c8b44783          	lbu	a5,-885(s0)
 1ba:	17d9                	addi	a5,a5,-10
 1bc:	0017b793          	seqz	a5,a5
 1c0:	00fcf7b3          	and	a5,s9,a5
 1c4:	01502733          	sgtz	a4,s5
 1c8:	8ff9                	and	a5,a5,a4
 1ca:	4b81                	li	s7,0
 1cc:	efc1                	bnez	a5,264 <main+0x264>
	while (read(0, &c, 1) == 1) {
 1ce:	865a                	mv	a2,s6
 1d0:	85e2                	mv	a1,s8
 1d2:	4501                	li	a0,0
 1d4:	474000ef          	jal	648 <read>
 1d8:	84aa                	mv	s1,a0
 1da:	11651763          	bne	a0,s6,2e8 <main+0x2e8>
		if (c == ' ' || c == '\t' || c == '\n') {
 1de:	c8b44683          	lbu	a3,-885(s0)
 1e2:	ff76879b          	addiw	a5,a3,-9
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	0027b793          	sltiu	a5,a5,2
 1ee:	fe068713          	addi	a4,a3,-32
 1f2:	00173713          	seqz	a4,a4
 1f6:	8fd9                	or	a5,a5,a4
 1f8:	c7e1                	beqz	a5,2c0 <main+0x2c0>
			if (inword) {
 1fa:	fa0b8ee3          	beqz	s7,1b6 <main+0x1b6>
				buf[len] = '\0';
 1fe:	f9040793          	addi	a5,s0,-112
 202:	9a3e                	add	s4,s4,a5
 204:	e00a0023          	sb	zero,-512(s4)
				strcpy(words[count], buf);
 208:	009a9a13          	slli	s4,s5,0x9
 20c:	00001797          	auipc	a5,0x1
 210:	e0478793          	addi	a5,a5,-508 # 1010 <words>
 214:	9a3e                	add	s4,s4,a5
 216:	85ee                	mv	a1,s11
 218:	8552                	mv	a0,s4
 21a:	170000ef          	jal	38a <strcpy>
				args[base + count] = words[count];
 21e:	012a87bb          	addw	a5,s5,s2
 222:	078e                	slli	a5,a5,0x3
 224:	c9040713          	addi	a4,s0,-880
 228:	97ba                	add	a5,a5,a4
 22a:	0147b023          	sd	s4,0(a5)
				count++;
 22e:	001a879b          	addiw	a5,s5,1
 232:	8abe                	mv	s5,a5
				len = 0;
 234:	4a01                	li	s4,0
				if (count == limit) {
 236:	c7843703          	ld	a4,-904(s0)
 23a:	f6f71ee3          	bne	a4,a5,1b6 <main+0x1b6>
					args[base + count] = 0;
 23e:	012787bb          	addw	a5,a5,s2
 242:	078e                	slli	a5,a5,0x3
 244:	c9040713          	addi	a4,s0,-880
 248:	97ba                	add	a5,a5,a4
 24a:	0007b023          	sd	zero,0(a5)
					pid = fork();
 24e:	3da000ef          	jal	628 <fork>
					if (pid == 0) {
 252:	d50d                	beqz	a0,17c <main+0x17c>
					if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
 254:	f2055de3          	bgez	a0,18e <main+0x18e>
 258:	c7743823          	sd	s7,-912(s0)
 25c:	4b81                	li	s7,0
 25e:	4a01                	li	s4,0
 260:	4a81                	li	s5,0
 262:	b7b5                	j	1ce <main+0x1ce>
				args[base + count] = 0;
 264:	012a87bb          	addw	a5,s5,s2
 268:	078e                	slli	a5,a5,0x3
 26a:	f9040713          	addi	a4,s0,-112
 26e:	97ba                	add	a5,a5,a4
 270:	d007b023          	sd	zero,-768(a5)
				pid = fork();
 274:	3b4000ef          	jal	628 <fork>
				if (pid == 0) {
 278:	c901                	beqz	a0,288 <main+0x288>
				if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
 27a:	02055063          	bgez	a0,29a <main+0x29a>
 27e:	c6943823          	sd	s1,-912(s0)
 282:	4b81                	li	s7,0
				count = 0;
 284:	4a81                	li	s5,0
 286:	b7a1                	j	1ce <main+0x1ce>
					exec(args[0], args);
 288:	c9040593          	addi	a1,s0,-880
 28c:	c9043503          	ld	a0,-880(s0)
 290:	3d8000ef          	jal	668 <exec>
					exit(1);
 294:	4505                	li	a0,1
 296:	39a000ef          	jal	630 <exit>
				if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
 29a:	c8c40513          	addi	a0,s0,-884
 29e:	39a000ef          	jal	638 <wait>
 2a2:	fc054ee3          	bltz	a0,27e <main+0x27e>
 2a6:	c8c42783          	lw	a5,-884(s0)
 2aa:	00f037b3          	snez	a5,a5
 2ae:	c7043703          	ld	a4,-912(s0)
 2b2:	8fd9                	or	a5,a5,a4
 2b4:	2781                	sext.w	a5,a5
 2b6:	c6f43823          	sd	a5,-912(s0)
 2ba:	4b81                	li	s7,0
				count = 0;
 2bc:	4a81                	li	s5,0
 2be:	bf01                	j	1ce <main+0x1ce>
			if (len < sizeof(buf) - 1) {
 2c0:	014d6a63          	bltu	s10,s4,2d4 <main+0x2d4>
				buf[len++] = c;
 2c4:	f9040793          	addi	a5,s0,-112
 2c8:	97d2                	add	a5,a5,s4
 2ca:	e0d78023          	sb	a3,-512(a5)
				inword = 1;
 2ce:	8ba6                	mv	s7,s1
				buf[len++] = c;
 2d0:	2a05                	addiw	s4,s4,1
 2d2:	bdf5                	j	1ce <main+0x1ce>
			} else {
				fprintf(2, "xargs: word too long\n");
 2d4:	00001597          	auipc	a1,0x1
 2d8:	9bc58593          	addi	a1,a1,-1604 # c90 <malloc+0x12e>
 2dc:	4509                	li	a0,2
 2de:	79e000ef          	jal	a7c <fprintf>
				exit(1);
 2e2:	4505                	li	a0,1
 2e4:	34c000ef          	jal	630 <exit>
			}
		}
	}

	if (inword) {
 2e8:	020b9863          	bnez	s7,318 <main+0x318>
		strcpy(words[count], buf);
		args[base + count] = words[count];
		count++;
	}
		
	if (count > 0) {
 2ec:	03505263          	blez	s5,310 <main+0x310>
		args[base + count] = 0;
 2f0:	013a87bb          	addw	a5,s5,s3
 2f4:	078e                	slli	a5,a5,0x3
 2f6:	f9040713          	addi	a4,s0,-112
 2fa:	97ba                	add	a5,a5,a4
 2fc:	d007b023          	sd	zero,-768(a5)
		pid = fork();
 300:	328000ef          	jal	628 <fork>
		if (pid == 0) {
 304:	c529                	beqz	a0,34e <main+0x34e>
			exec(args[0], args);
			exit(1);
		}
		if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
 306:	04055d63          	bgez	a0,360 <main+0x360>
 30a:	4785                	li	a5,1
 30c:	c6f43823          	sd	a5,-912(s0)
	}
	exit(failed);
 310:	c7043503          	ld	a0,-912(s0)
 314:	31c000ef          	jal	630 <exit>
		buf[len] = '\0';
 318:	f9040793          	addi	a5,s0,-112
 31c:	9a3e                	add	s4,s4,a5
 31e:	e00a0023          	sb	zero,-512(s4)
		strcpy(words[count], buf);
 322:	009a9493          	slli	s1,s5,0x9
 326:	00001797          	auipc	a5,0x1
 32a:	cea78793          	addi	a5,a5,-790 # 1010 <words>
 32e:	94be                	add	s1,s1,a5
 330:	d9040593          	addi	a1,s0,-624
 334:	8526                	mv	a0,s1
 336:	054000ef          	jal	38a <strcpy>
		args[base + count] = words[count];
 33a:	013a87bb          	addw	a5,s5,s3
 33e:	078e                	slli	a5,a5,0x3
 340:	f9040713          	addi	a4,s0,-112
 344:	97ba                	add	a5,a5,a4
 346:	d097b023          	sd	s1,-768(a5)
		count++;
 34a:	2a85                	addiw	s5,s5,1
 34c:	b745                	j	2ec <main+0x2ec>
			exec(args[0], args);
 34e:	c9040593          	addi	a1,s0,-880
 352:	c9043503          	ld	a0,-880(s0)
 356:	312000ef          	jal	668 <exec>
			exit(1);
 35a:	4505                	li	a0,1
 35c:	2d4000ef          	jal	630 <exit>
		if (pid < 0 || wait(&status) < 0 || status != 0) failed = 1;
 360:	c8c40513          	addi	a0,s0,-884
 364:	2d4000ef          	jal	638 <wait>
 368:	fa0541e3          	bltz	a0,30a <main+0x30a>
 36c:	c8c42783          	lw	a5,-884(s0)
 370:	d3c5                	beqz	a5,310 <main+0x310>
 372:	4785                	li	a5,1
 374:	c6f43823          	sd	a5,-912(s0)
 378:	bf61                	j	310 <main+0x310>

000000000000037a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e406                	sd	ra,8(sp)
 37e:	e022                	sd	s0,0(sp)
 380:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 382:	c7fff0ef          	jal	0 <main>
  exit(r);
 386:	2aa000ef          	jal	630 <exit>

000000000000038a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 392:	87aa                	mv	a5,a0
 394:	0585                	addi	a1,a1,1
 396:	0785                	addi	a5,a5,1
 398:	fff5c703          	lbu	a4,-1(a1)
 39c:	fee78fa3          	sb	a4,-1(a5)
 3a0:	fb75                	bnez	a4,394 <strcpy+0xa>
    ;
  return os;
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	cb91                	beqz	a5,3ca <strcmp+0x20>
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00f71763          	bne	a4,a5,3ca <strcmp+0x20>
    p++, q++;
 3c0:	0505                	addi	a0,a0,1
 3c2:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	fbe5                	bnez	a5,3b8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 3ca:	0005c503          	lbu	a0,0(a1)
}
 3ce:	40a7853b          	subw	a0,a5,a0
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret

00000000000003da <strlen>:

uint
strlen(const char *s)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e406                	sd	ra,8(sp)
 3de:	e022                	sd	s0,0(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	cf91                	beqz	a5,402 <strlen+0x28>
 3e8:	00150793          	addi	a5,a0,1
 3ec:	86be                	mv	a3,a5
 3ee:	0785                	addi	a5,a5,1
 3f0:	fff7c703          	lbu	a4,-1(a5)
 3f4:	ff65                	bnez	a4,3ec <strlen+0x12>
 3f6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 3fa:	60a2                	ld	ra,8(sp)
 3fc:	6402                	ld	s0,0(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret
  for (n = 0; s[n]; n++)
 402:	4501                	li	a0,0
 404:	bfdd                	j	3fa <strlen+0x20>

0000000000000406 <memset>:

void *
memset(void *dst, int c, uint n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 40e:	ca19                	beqz	a2,424 <memset+0x1e>
 410:	87aa                	mv	a5,a0
 412:	1602                	slli	a2,a2,0x20
 414:	9201                	srli	a2,a2,0x20
 416:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 41a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 41e:	0785                	addi	a5,a5,1
 420:	fee79de3          	bne	a5,a4,41a <memset+0x14>
  }
  return dst;
}
 424:	60a2                	ld	ra,8(sp)
 426:	6402                	ld	s0,0(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <strchr>:

char *
strchr(const char *s, char c)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	addi	s0,sp,16
  for (; *s; s++)
 434:	00054783          	lbu	a5,0(a0)
 438:	c799                	beqz	a5,446 <strchr+0x1a>
    if (*s == c)
 43a:	00f58763          	beq	a1,a5,448 <strchr+0x1c>
  for (; *s; s++)
 43e:	0505                	addi	a0,a0,1
 440:	00054783          	lbu	a5,0(a0)
 444:	fbfd                	bnez	a5,43a <strchr+0xe>
      return (char *)s;
  return 0;
 446:	4501                	li	a0,0
}
 448:	60a2                	ld	ra,8(sp)
 44a:	6402                	ld	s0,0(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret

0000000000000450 <gets>:

char *
gets(char *buf, int max)
{
 450:	711d                	addi	sp,sp,-96
 452:	ec86                	sd	ra,88(sp)
 454:	e8a2                	sd	s0,80(sp)
 456:	e4a6                	sd	s1,72(sp)
 458:	e0ca                	sd	s2,64(sp)
 45a:	fc4e                	sd	s3,56(sp)
 45c:	f852                	sd	s4,48(sp)
 45e:	f456                	sd	s5,40(sp)
 460:	f05a                	sd	s6,32(sp)
 462:	ec5e                	sd	s7,24(sp)
 464:	e862                	sd	s8,16(sp)
 466:	1080                	addi	s0,sp,96
 468:	8baa                	mv	s7,a0
 46a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 46c:	892a                	mv	s2,a0
 46e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 470:	faf40b13          	addi	s6,s0,-81
 474:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 476:	8c26                	mv	s8,s1
 478:	0014899b          	addiw	s3,s1,1
 47c:	84ce                	mv	s1,s3
 47e:	0349d863          	bge	s3,s4,4ae <gets+0x5e>
    cc = read(0, &c, 1);
 482:	8656                	mv	a2,s5
 484:	85da                	mv	a1,s6
 486:	4501                	li	a0,0
 488:	1c0000ef          	jal	648 <read>
    if (cc < 1)
 48c:	02a05163          	blez	a0,4ae <gets+0x5e>
      break;
    buf[i++] = c;
 490:	faf44783          	lbu	a5,-81(s0)
 494:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 498:	0905                	addi	s2,s2,1
 49a:	ff678713          	addi	a4,a5,-10
 49e:	00173713          	seqz	a4,a4
 4a2:	17cd                	addi	a5,a5,-13
 4a4:	0017b793          	seqz	a5,a5
 4a8:	8fd9                	or	a5,a5,a4
 4aa:	d7f1                	beqz	a5,476 <gets+0x26>
    buf[i++] = c;
 4ac:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 4ae:	9c5e                	add	s8,s8,s7
 4b0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 4b4:	855e                	mv	a0,s7
 4b6:	60e6                	ld	ra,88(sp)
 4b8:	6446                	ld	s0,80(sp)
 4ba:	64a6                	ld	s1,72(sp)
 4bc:	6906                	ld	s2,64(sp)
 4be:	79e2                	ld	s3,56(sp)
 4c0:	7a42                	ld	s4,48(sp)
 4c2:	7aa2                	ld	s5,40(sp)
 4c4:	7b02                	ld	s6,32(sp)
 4c6:	6be2                	ld	s7,24(sp)
 4c8:	6c42                	ld	s8,16(sp)
 4ca:	6125                	addi	sp,sp,96
 4cc:	8082                	ret

00000000000004ce <stat>:

int
stat(const char *n, struct stat *st)
{
 4ce:	1101                	addi	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	e04a                	sd	s2,0(sp)
 4d6:	1000                	addi	s0,sp,32
 4d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4da:	4581                	li	a1,0
 4dc:	194000ef          	jal	670 <open>
  if (fd < 0)
 4e0:	02054263          	bltz	a0,504 <stat+0x36>
 4e4:	e426                	sd	s1,8(sp)
 4e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4e8:	85ca                	mv	a1,s2
 4ea:	19e000ef          	jal	688 <fstat>
 4ee:	892a                	mv	s2,a0
  close(fd);
 4f0:	8526                	mv	a0,s1
 4f2:	166000ef          	jal	658 <close>
  return r;
 4f6:	64a2                	ld	s1,8(sp)
}
 4f8:	854a                	mv	a0,s2
 4fa:	60e2                	ld	ra,24(sp)
 4fc:	6442                	ld	s0,16(sp)
 4fe:	6902                	ld	s2,0(sp)
 500:	6105                	addi	sp,sp,32
 502:	8082                	ret
    return -1;
 504:	57fd                	li	a5,-1
 506:	893e                	mv	s2,a5
 508:	bfc5                	j	4f8 <stat+0x2a>

000000000000050a <atoi>:

int
atoi(const char *s)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 512:	00054683          	lbu	a3,0(a0)
 516:	fd06879b          	addiw	a5,a3,-48
 51a:	0ff7f793          	zext.b	a5,a5
 51e:	4625                	li	a2,9
 520:	02f66963          	bltu	a2,a5,552 <atoi+0x48>
 524:	872a                	mv	a4,a0
  n = 0;
 526:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 528:	0705                	addi	a4,a4,1
 52a:	0025179b          	slliw	a5,a0,0x2
 52e:	9fa9                	addw	a5,a5,a0
 530:	0017979b          	slliw	a5,a5,0x1
 534:	9fb5                	addw	a5,a5,a3
 536:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 53a:	00074683          	lbu	a3,0(a4)
 53e:	fd06879b          	addiw	a5,a3,-48
 542:	0ff7f793          	zext.b	a5,a5
 546:	fef671e3          	bgeu	a2,a5,528 <atoi+0x1e>
  return n;
}
 54a:	60a2                	ld	ra,8(sp)
 54c:	6402                	ld	s0,0(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret
  n = 0;
 552:	4501                	li	a0,0
 554:	bfdd                	j	54a <atoi+0x40>

0000000000000556 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 556:	1141                	addi	sp,sp,-16
 558:	e406                	sd	ra,8(sp)
 55a:	e022                	sd	s0,0(sp)
 55c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 55e:	02b57563          	bgeu	a0,a1,588 <memmove+0x32>
    while (n-- > 0)
 562:	00c05f63          	blez	a2,580 <memmove+0x2a>
 566:	1602                	slli	a2,a2,0x20
 568:	9201                	srli	a2,a2,0x20
 56a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 56e:	872a                	mv	a4,a0
      *dst++ = *src++;
 570:	0585                	addi	a1,a1,1
 572:	0705                	addi	a4,a4,1
 574:	fff5c683          	lbu	a3,-1(a1)
 578:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 57c:	fee79ae3          	bne	a5,a4,570 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 580:	60a2                	ld	ra,8(sp)
 582:	6402                	ld	s0,0(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
    while (n-- > 0)
 588:	fec05ce3          	blez	a2,580 <memmove+0x2a>
    dst += n;
 58c:	00c50733          	add	a4,a0,a2
    src += n;
 590:	95b2                	add	a1,a1,a2
 592:	fff6079b          	addiw	a5,a2,-1
 596:	1782                	slli	a5,a5,0x20
 598:	9381                	srli	a5,a5,0x20
 59a:	fff7c793          	not	a5,a5
 59e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5a0:	15fd                	addi	a1,a1,-1
 5a2:	177d                	addi	a4,a4,-1
 5a4:	0005c683          	lbu	a3,0(a1)
 5a8:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 5ac:	fef71ae3          	bne	a4,a5,5a0 <memmove+0x4a>
 5b0:	bfc1                	j	580 <memmove+0x2a>

00000000000005b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5b2:	1141                	addi	sp,sp,-16
 5b4:	e406                	sd	ra,8(sp)
 5b6:	e022                	sd	s0,0(sp)
 5b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5ba:	ce19                	beqz	a2,5d8 <memcmp+0x26>
 5bc:	1602                	slli	a2,a2,0x20
 5be:	9201                	srli	a2,a2,0x20
 5c0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 5c4:	00054783          	lbu	a5,0(a0)
 5c8:	0005c703          	lbu	a4,0(a1)
 5cc:	00e79b63          	bne	a5,a4,5e2 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 5d0:	0505                	addi	a0,a0,1
    p2++;
 5d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5d4:	fed518e3          	bne	a0,a3,5c4 <memcmp+0x12>
  }
  return 0;
 5d8:	4501                	li	a0,0
}
 5da:	60a2                	ld	ra,8(sp)
 5dc:	6402                	ld	s0,0(sp)
 5de:	0141                	addi	sp,sp,16
 5e0:	8082                	ret
      return *p1 - *p2;
 5e2:	40e7853b          	subw	a0,a5,a4
 5e6:	bfd5                	j	5da <memcmp+0x28>

00000000000005e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5e8:	1141                	addi	sp,sp,-16
 5ea:	e406                	sd	ra,8(sp)
 5ec:	e022                	sd	s0,0(sp)
 5ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5f0:	f67ff0ef          	jal	556 <memmove>
}
 5f4:	60a2                	ld	ra,8(sp)
 5f6:	6402                	ld	s0,0(sp)
 5f8:	0141                	addi	sp,sp,16
 5fa:	8082                	ret

00000000000005fc <sbrk>:

char *
sbrk(int n)
{
 5fc:	1141                	addi	sp,sp,-16
 5fe:	e406                	sd	ra,8(sp)
 600:	e022                	sd	s0,0(sp)
 602:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 604:	4585                	li	a1,1
 606:	0b2000ef          	jal	6b8 <sys_sbrk>
}
 60a:	60a2                	ld	ra,8(sp)
 60c:	6402                	ld	s0,0(sp)
 60e:	0141                	addi	sp,sp,16
 610:	8082                	ret

0000000000000612 <sbrklazy>:

char *
sbrklazy(int n)
{
 612:	1141                	addi	sp,sp,-16
 614:	e406                	sd	ra,8(sp)
 616:	e022                	sd	s0,0(sp)
 618:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 61a:	4589                	li	a1,2
 61c:	09c000ef          	jal	6b8 <sys_sbrk>
}
 620:	60a2                	ld	ra,8(sp)
 622:	6402                	ld	s0,0(sp)
 624:	0141                	addi	sp,sp,16
 626:	8082                	ret

0000000000000628 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 628:	4885                	li	a7,1
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <exit>:
.global exit
exit:
 li a7, SYS_exit
 630:	4889                	li	a7,2
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <wait>:
.global wait
wait:
 li a7, SYS_wait
 638:	488d                	li	a7,3
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 640:	4891                	li	a7,4
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <read>:
.global read
read:
 li a7, SYS_read
 648:	4895                	li	a7,5
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <write>:
.global write
write:
 li a7, SYS_write
 650:	48c1                	li	a7,16
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <close>:
.global close
close:
 li a7, SYS_close
 658:	48d5                	li	a7,21
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <kill>:
.global kill
kill:
 li a7, SYS_kill
 660:	4899                	li	a7,6
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <exec>:
.global exec
exec:
 li a7, SYS_exec
 668:	489d                	li	a7,7
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <open>:
.global open
open:
 li a7, SYS_open
 670:	48bd                	li	a7,15
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 678:	48c5                	li	a7,17
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 680:	48c9                	li	a7,18
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 688:	48a1                	li	a7,8
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <link>:
.global link
link:
 li a7, SYS_link
 690:	48cd                	li	a7,19
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 698:	48d1                	li	a7,20
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a0:	48a5                	li	a7,9
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6a8:	48a9                	li	a7,10
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b0:	48ad                	li	a7,11
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 6b8:	48b1                	li	a7,12
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 6c0:	48b5                	li	a7,13
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6c8:	48b9                	li	a7,14
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 6d0:	48d9                	li	a7,22
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 6d8:	48dd                	li	a7,23
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6e0:	48e1                	li	a7,24
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 6e8:	48e5                	li	a7,25
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f0:	1101                	addi	sp,sp,-32
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6fc:	4605                	li	a2,1
 6fe:	fef40593          	addi	a1,s0,-17
 702:	f4fff0ef          	jal	650 <write>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6105                	addi	sp,sp,32
 70c:	8082                	ret

000000000000070e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 70e:	715d                	addi	sp,sp,-80
 710:	e486                	sd	ra,72(sp)
 712:	e0a2                	sd	s0,64(sp)
 714:	f84a                	sd	s2,48(sp)
 716:	f44e                	sd	s3,40(sp)
 718:	0880                	addi	s0,sp,80
 71a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 71c:	00d036b3          	snez	a3,a3
 720:	03f5d793          	srli	a5,a1,0x3f
 724:	8efd                	and	a3,a3,a5
  neg = 0;
 726:	4301                	li	t1,0
  if (sgn && xx < 0) {
 728:	c681                	beqz	a3,730 <printint+0x22>
    neg = 1;
    x = -xx;
 72a:	40b005b3          	neg	a1,a1
    neg = 1;
 72e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 730:	fb840993          	addi	s3,s0,-72
  neg = 0;
 734:	86ce                	mv	a3,s3
  i = 0;
 736:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 738:	00000817          	auipc	a6,0x0
 73c:	57880813          	addi	a6,a6,1400 # cb0 <digits>
 740:	88ba                	mv	a7,a4
 742:	0017051b          	addiw	a0,a4,1
 746:	872a                	mv	a4,a0
 748:	02c5f7b3          	remu	a5,a1,a2
 74c:	97c2                	add	a5,a5,a6
 74e:	0007c783          	lbu	a5,0(a5)
 752:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 756:	87ae                	mv	a5,a1
 758:	02c5d5b3          	divu	a1,a1,a2
 75c:	0685                	addi	a3,a3,1
 75e:	fec7f1e3          	bgeu	a5,a2,740 <printint+0x32>
  if (neg)
 762:	00030b63          	beqz	t1,778 <printint+0x6a>
    buf[i++] = '-';
 766:	fd040793          	addi	a5,s0,-48
 76a:	953e                	add	a0,a0,a5
 76c:	02d00793          	li	a5,45
 770:	fef50423          	sb	a5,-24(a0)
 774:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 778:	02e05563          	blez	a4,7a2 <printint+0x94>
 77c:	fc26                	sd	s1,56(sp)
 77e:	377d                	addiw	a4,a4,-1
 780:	00e984b3          	add	s1,s3,a4
 784:	19fd                	addi	s3,s3,-1
 786:	99ba                	add	s3,s3,a4
 788:	1702                	slli	a4,a4,0x20
 78a:	9301                	srli	a4,a4,0x20
 78c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 790:	0004c583          	lbu	a1,0(s1)
 794:	854a                	mv	a0,s2
 796:	f5bff0ef          	jal	6f0 <putc>
  while (--i >= 0)
 79a:	14fd                	addi	s1,s1,-1
 79c:	ff349ae3          	bne	s1,s3,790 <printint+0x82>
 7a0:	74e2                	ld	s1,56(sp)
}
 7a2:	60a6                	ld	ra,72(sp)
 7a4:	6406                	ld	s0,64(sp)
 7a6:	7942                	ld	s2,48(sp)
 7a8:	79a2                	ld	s3,40(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec86                	sd	ra,88(sp)
 7b2:	e8a2                	sd	s0,80(sp)
 7b4:	e4a6                	sd	s1,72(sp)
 7b6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 7b8:	0005c483          	lbu	s1,0(a1)
 7bc:	2a048063          	beqz	s1,a5c <vprintf+0x2ae>
 7c0:	e0ca                	sd	s2,64(sp)
 7c2:	fc4e                	sd	s3,56(sp)
 7c4:	f852                	sd	s4,48(sp)
 7c6:	f456                	sd	s5,40(sp)
 7c8:	f05a                	sd	s6,32(sp)
 7ca:	ec5e                	sd	s7,24(sp)
 7cc:	e862                	sd	s8,16(sp)
 7ce:	8b2a                	mv	s6,a0
 7d0:	8a2e                	mv	s4,a1
 7d2:	8bb2                	mv	s7,a2
  state = 0;
 7d4:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 7d6:	4901                	li	s2,0
 7d8:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 7da:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 7de:	06400c13          	li	s8,100
 7e2:	a00d                	j	804 <vprintf+0x56>
        putc(fd, c0);
 7e4:	85a6                	mv	a1,s1
 7e6:	855a                	mv	a0,s6
 7e8:	f09ff0ef          	jal	6f0 <putc>
 7ec:	a019                	j	7f2 <vprintf+0x44>
    } else if (state == '%') {
 7ee:	03598363          	beq	s3,s5,814 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 7f2:	0019079b          	addiw	a5,s2,1
 7f6:	893e                	mv	s2,a5
 7f8:	873e                	mv	a4,a5
 7fa:	97d2                	add	a5,a5,s4
 7fc:	0007c483          	lbu	s1,0(a5)
 800:	24048763          	beqz	s1,a4e <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 804:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 808:	fe0993e3          	bnez	s3,7ee <vprintf+0x40>
      if (c0 == '%') {
 80c:	fd579ce3          	bne	a5,s5,7e4 <vprintf+0x36>
        state = '%';
 810:	89be                	mv	s3,a5
 812:	b7c5                	j	7f2 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 814:	00ea06b3          	add	a3,s4,a4
 818:	0016c603          	lbu	a2,1(a3)
      if (c1)
 81c:	24060563          	beqz	a2,a66 <vprintf+0x2b8>
      if (c0 == 'd') {
 820:	0b878763          	beq	a5,s8,8ce <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 824:	f9478693          	addi	a3,a5,-108
 828:	0016b693          	seqz	a3,a3
 82c:	f9c60593          	addi	a1,a2,-100
 830:	0015b593          	seqz	a1,a1
 834:	8df5                	and	a1,a1,a3
 836:	e9c5                	bnez	a1,8e6 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 838:	9752                	add	a4,a4,s4
 83a:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 83e:	f9460713          	addi	a4,a2,-108
 842:	00173713          	seqz	a4,a4
 846:	8f75                	and	a4,a4,a3
 848:	f9c50593          	addi	a1,a0,-100
 84c:	0015b593          	seqz	a1,a1
 850:	8df9                	and	a1,a1,a4
 852:	e5dd                	bnez	a1,900 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 854:	07500593          	li	a1,117
 858:	0cb78163          	beq	a5,a1,91a <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 85c:	f8b60593          	addi	a1,a2,-117
 860:	0015b593          	seqz	a1,a1
 864:	8df5                	and	a1,a1,a3
 866:	e5f1                	bnez	a1,932 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 868:	f8b50593          	addi	a1,a0,-117
 86c:	0015b593          	seqz	a1,a1
 870:	8df9                	and	a1,a1,a4
 872:	ede9                	bnez	a1,94c <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 874:	07800593          	li	a1,120
 878:	0eb78763          	beq	a5,a1,966 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 87c:	f8860613          	addi	a2,a2,-120
 880:	00163613          	seqz	a2,a2
 884:	8ef1                	and	a3,a3,a2
 886:	0e069c63          	bnez	a3,97e <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 88a:	f8850513          	addi	a0,a0,-120
 88e:	00153513          	seqz	a0,a0
 892:	8f69                	and	a4,a4,a0
 894:	10071263          	bnez	a4,998 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 898:	07000713          	li	a4,112
 89c:	10e78a63          	beq	a5,a4,9b0 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 8a0:	06300713          	li	a4,99
 8a4:	14e78a63          	beq	a5,a4,9f8 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 8a8:	07300713          	li	a4,115
 8ac:	16e78063          	beq	a5,a4,a0c <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 8b0:	02500713          	li	a4,37
 8b4:	18e78863          	beq	a5,a4,a44 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b8:	02500593          	li	a1,37
 8bc:	855a                	mv	a0,s6
 8be:	e33ff0ef          	jal	6f0 <putc>
        putc(fd, c0);
 8c2:	85a6                	mv	a1,s1
 8c4:	855a                	mv	a0,s6
 8c6:	e2bff0ef          	jal	6f0 <putc>
      }

      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	b71d                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 8ce:	008b8493          	addi	s1,s7,8
 8d2:	4685                	li	a3,1
 8d4:	4629                	li	a2,10
 8d6:	000ba583          	lw	a1,0(s7)
 8da:	855a                	mv	a0,s6
 8dc:	e33ff0ef          	jal	70e <printint>
 8e0:	8ba6                	mv	s7,s1
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b739                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e6:	008b8493          	addi	s1,s7,8
 8ea:	4685                	li	a3,1
 8ec:	4629                	li	a2,10
 8ee:	000bb583          	ld	a1,0(s7)
 8f2:	855a                	mv	a0,s6
 8f4:	e1bff0ef          	jal	70e <printint>
        i += 1;
 8f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8fa:	8ba6                	mv	s7,s1
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	bdd5                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 900:	008b8493          	addi	s1,s7,8
 904:	4685                	li	a3,1
 906:	4629                	li	a2,10
 908:	000bb583          	ld	a1,0(s7)
 90c:	855a                	mv	a0,s6
 90e:	e01ff0ef          	jal	70e <printint>
        i += 2;
 912:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 914:	8ba6                	mv	s7,s1
      state = 0;
 916:	4981                	li	s3,0
        i += 2;
 918:	bde9                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 91a:	008b8493          	addi	s1,s7,8
 91e:	4681                	li	a3,0
 920:	4629                	li	a2,10
 922:	000be583          	lwu	a1,0(s7)
 926:	855a                	mv	a0,s6
 928:	de7ff0ef          	jal	70e <printint>
 92c:	8ba6                	mv	s7,s1
      state = 0;
 92e:	4981                	li	s3,0
 930:	b5c9                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 932:	008b8493          	addi	s1,s7,8
 936:	4681                	li	a3,0
 938:	4629                	li	a2,10
 93a:	000bb583          	ld	a1,0(s7)
 93e:	855a                	mv	a0,s6
 940:	dcfff0ef          	jal	70e <printint>
        i += 1;
 944:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 946:	8ba6                	mv	s7,s1
      state = 0;
 948:	4981                	li	s3,0
 94a:	b565                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 94c:	008b8493          	addi	s1,s7,8
 950:	4681                	li	a3,0
 952:	4629                	li	a2,10
 954:	000bb583          	ld	a1,0(s7)
 958:	855a                	mv	a0,s6
 95a:	db5ff0ef          	jal	70e <printint>
        i += 2;
 95e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 960:	8ba6                	mv	s7,s1
      state = 0;
 962:	4981                	li	s3,0
        i += 2;
 964:	b579                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 966:	008b8493          	addi	s1,s7,8
 96a:	4681                	li	a3,0
 96c:	4641                	li	a2,16
 96e:	000be583          	lwu	a1,0(s7)
 972:	855a                	mv	a0,s6
 974:	d9bff0ef          	jal	70e <printint>
 978:	8ba6                	mv	s7,s1
      state = 0;
 97a:	4981                	li	s3,0
 97c:	bd9d                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 97e:	008b8493          	addi	s1,s7,8
 982:	4681                	li	a3,0
 984:	4641                	li	a2,16
 986:	000bb583          	ld	a1,0(s7)
 98a:	855a                	mv	a0,s6
 98c:	d83ff0ef          	jal	70e <printint>
        i += 1;
 990:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 992:	8ba6                	mv	s7,s1
      state = 0;
 994:	4981                	li	s3,0
 996:	bdb1                	j	7f2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 998:	008b8493          	addi	s1,s7,8
 99c:	4641                	li	a2,16
 99e:	000bb583          	ld	a1,0(s7)
 9a2:	855a                	mv	a0,s6
 9a4:	d6bff0ef          	jal	70e <printint>
        i += 2;
 9a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9aa:	8ba6                	mv	s7,s1
      state = 0;
 9ac:	4981                	li	s3,0
        i += 2;
 9ae:	b591                	j	7f2 <vprintf+0x44>
 9b0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 9b2:	008b8793          	addi	a5,s7,8
 9b6:	8cbe                	mv	s9,a5
 9b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9bc:	03000593          	li	a1,48
 9c0:	855a                	mv	a0,s6
 9c2:	d2fff0ef          	jal	6f0 <putc>
  putc(fd, 'x');
 9c6:	07800593          	li	a1,120
 9ca:	855a                	mv	a0,s6
 9cc:	d25ff0ef          	jal	6f0 <putc>
 9d0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9d2:	00000b97          	auipc	s7,0x0
 9d6:	2deb8b93          	addi	s7,s7,734 # cb0 <digits>
 9da:	03c9d793          	srli	a5,s3,0x3c
 9de:	97de                	add	a5,a5,s7
 9e0:	0007c583          	lbu	a1,0(a5)
 9e4:	855a                	mv	a0,s6
 9e6:	d0bff0ef          	jal	6f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9ea:	0992                	slli	s3,s3,0x4
 9ec:	34fd                	addiw	s1,s1,-1
 9ee:	f4f5                	bnez	s1,9da <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 9f0:	8be6                	mv	s7,s9
      state = 0;
 9f2:	4981                	li	s3,0
 9f4:	6ca2                	ld	s9,8(sp)
 9f6:	bbf5                	j	7f2 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 9f8:	008b8493          	addi	s1,s7,8
 9fc:	000bc583          	lbu	a1,0(s7)
 a00:	855a                	mv	a0,s6
 a02:	cefff0ef          	jal	6f0 <putc>
 a06:	8ba6                	mv	s7,s1
      state = 0;
 a08:	4981                	li	s3,0
 a0a:	b3e5                	j	7f2 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 a0c:	008b8993          	addi	s3,s7,8
 a10:	000bb483          	ld	s1,0(s7)
 a14:	cc91                	beqz	s1,a30 <vprintf+0x282>
        for (; *s; s++)
 a16:	0004c583          	lbu	a1,0(s1)
 a1a:	c195                	beqz	a1,a3e <vprintf+0x290>
          putc(fd, *s);
 a1c:	855a                	mv	a0,s6
 a1e:	cd3ff0ef          	jal	6f0 <putc>
        for (; *s; s++)
 a22:	0485                	addi	s1,s1,1
 a24:	0004c583          	lbu	a1,0(s1)
 a28:	f9f5                	bnez	a1,a1c <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 a2a:	8bce                	mv	s7,s3
      state = 0;
 a2c:	4981                	li	s3,0
 a2e:	b3d1                	j	7f2 <vprintf+0x44>
          s = "(null)";
 a30:	00000497          	auipc	s1,0x0
 a34:	27848493          	addi	s1,s1,632 # ca8 <malloc+0x146>
        for (; *s; s++)
 a38:	02800593          	li	a1,40
 a3c:	b7c5                	j	a1c <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 a3e:	8bce                	mv	s7,s3
      state = 0;
 a40:	4981                	li	s3,0
 a42:	bb45                	j	7f2 <vprintf+0x44>
        putc(fd, '%');
 a44:	85be                	mv	a1,a5
 a46:	855a                	mv	a0,s6
 a48:	ca9ff0ef          	jal	6f0 <putc>
 a4c:	bdbd                	j	8ca <vprintf+0x11c>
 a4e:	6906                	ld	s2,64(sp)
 a50:	79e2                	ld	s3,56(sp)
 a52:	7a42                	ld	s4,48(sp)
 a54:	7aa2                	ld	s5,40(sp)
 a56:	7b02                	ld	s6,32(sp)
 a58:	6be2                	ld	s7,24(sp)
 a5a:	6c42                	ld	s8,16(sp)
    }
  }
}
 a5c:	60e6                	ld	ra,88(sp)
 a5e:	6446                	ld	s0,80(sp)
 a60:	64a6                	ld	s1,72(sp)
 a62:	6125                	addi	sp,sp,96
 a64:	8082                	ret
      if (c0 == 'd') {
 a66:	06400713          	li	a4,100
 a6a:	e6e782e3          	beq	a5,a4,8ce <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 a6e:	f9478693          	addi	a3,a5,-108
 a72:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 a76:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 a78:	4701                	li	a4,0
 a7a:	bbe9                	j	854 <vprintf+0xa6>

0000000000000a7c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a7c:	715d                	addi	sp,sp,-80
 a7e:	ec06                	sd	ra,24(sp)
 a80:	e822                	sd	s0,16(sp)
 a82:	1000                	addi	s0,sp,32
 a84:	e010                	sd	a2,0(s0)
 a86:	e414                	sd	a3,8(s0)
 a88:	e818                	sd	a4,16(s0)
 a8a:	ec1c                	sd	a5,24(s0)
 a8c:	03043023          	sd	a6,32(s0)
 a90:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a94:	8622                	mv	a2,s0
 a96:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a9a:	d15ff0ef          	jal	7ae <vprintf>
}
 a9e:	60e2                	ld	ra,24(sp)
 aa0:	6442                	ld	s0,16(sp)
 aa2:	6161                	addi	sp,sp,80
 aa4:	8082                	ret

0000000000000aa6 <printf>:

void
printf(const char *fmt, ...)
{
 aa6:	711d                	addi	sp,sp,-96
 aa8:	ec06                	sd	ra,24(sp)
 aaa:	e822                	sd	s0,16(sp)
 aac:	1000                	addi	s0,sp,32
 aae:	e40c                	sd	a1,8(s0)
 ab0:	e810                	sd	a2,16(s0)
 ab2:	ec14                	sd	a3,24(s0)
 ab4:	f018                	sd	a4,32(s0)
 ab6:	f41c                	sd	a5,40(s0)
 ab8:	03043823          	sd	a6,48(s0)
 abc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ac0:	00840613          	addi	a2,s0,8
 ac4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ac8:	85aa                	mv	a1,a0
 aca:	4505                	li	a0,1
 acc:	ce3ff0ef          	jal	7ae <vprintf>
}
 ad0:	60e2                	ld	ra,24(sp)
 ad2:	6442                	ld	s0,16(sp)
 ad4:	6125                	addi	sp,sp,96
 ad6:	8082                	ret

0000000000000ad8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad8:	1141                	addi	sp,sp,-16
 ada:	e406                	sd	ra,8(sp)
 adc:	e022                	sd	s0,0(sp)
 ade:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 ae0:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae4:	00000797          	auipc	a5,0x0
 ae8:	51c7b783          	ld	a5,1308(a5) # 1000 <freep>
 aec:	a095                	j	b50 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 aee:	ff852583          	lw	a1,-8(a0)
 af2:	6390                	ld	a2,0(a5)
 af4:	02059813          	slli	a6,a1,0x20
 af8:	01c85693          	srli	a3,a6,0x1c
 afc:	96ba                	add	a3,a3,a4
 afe:	02d60563          	beq	a2,a3,b28 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b02:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 b06:	4790                	lw	a2,8(a5)
 b08:	02061593          	slli	a1,a2,0x20
 b0c:	01c5d693          	srli	a3,a1,0x1c
 b10:	96be                	add	a3,a3,a5
 b12:	02d70263          	beq	a4,a3,b36 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 b16:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b18:	00000717          	auipc	a4,0x0
 b1c:	4ef73423          	sd	a5,1256(a4) # 1000 <freep>
}
 b20:	60a2                	ld	ra,8(sp)
 b22:	6402                	ld	s0,0(sp)
 b24:	0141                	addi	sp,sp,16
 b26:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 b28:	4614                	lw	a3,8(a2)
 b2a:	9ead                	addw	a3,a3,a1
 b2c:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b30:	6394                	ld	a3,0(a5)
 b32:	6290                	ld	a2,0(a3)
 b34:	b7f9                	j	b02 <free+0x2a>
    p->s.size += bp->s.size;
 b36:	ff852703          	lw	a4,-8(a0)
 b3a:	9f31                	addw	a4,a4,a2
 b3c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b3e:	ff053703          	ld	a4,-16(a0)
 b42:	bfd1                	j	b16 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b44:	6394                	ld	a3,0(a5)
 b46:	00d7e463          	bltu	a5,a3,b4e <free+0x76>
 b4a:	fad762e3          	bltu	a4,a3,aee <free+0x16>
 b4e:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b50:	fee7fae3          	bgeu	a5,a4,b44 <free+0x6c>
 b54:	6394                	ld	a3,0(a5)
 b56:	f8d76ce3          	bltu	a4,a3,aee <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b5a:	f8d7fae3          	bgeu	a5,a3,aee <free+0x16>
 b5e:	87b6                	mv	a5,a3
 b60:	bfc5                	j	b50 <free+0x78>

0000000000000b62 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 b62:	7139                	addi	sp,sp,-64
 b64:	fc06                	sd	ra,56(sp)
 b66:	f822                	sd	s0,48(sp)
 b68:	f04a                	sd	s2,32(sp)
 b6a:	ec4e                	sd	s3,24(sp)
 b6c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b6e:	02051993          	slli	s3,a0,0x20
 b72:	0209d993          	srli	s3,s3,0x20
 b76:	09bd                	addi	s3,s3,15
 b78:	0049d993          	srli	s3,s3,0x4
 b7c:	2985                	addiw	s3,s3,1
 b7e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 b80:	00000517          	auipc	a0,0x0
 b84:	48053503          	ld	a0,1152(a0) # 1000 <freep>
 b88:	c905                	beqz	a0,bb8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b8a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b8c:	4798                	lw	a4,8(a5)
 b8e:	09377663          	bgeu	a4,s3,c1a <malloc+0xb8>
 b92:	f426                	sd	s1,40(sp)
 b94:	e852                	sd	s4,16(sp)
 b96:	e456                	sd	s5,8(sp)
 b98:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 b9a:	8a4e                	mv	s4,s3
 b9c:	6705                	lui	a4,0x1
 b9e:	00e9f363          	bgeu	s3,a4,ba4 <malloc+0x42>
 ba2:	6a05                	lui	s4,0x1
 ba4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ba8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 bac:	00000497          	auipc	s1,0x0
 bb0:	45448493          	addi	s1,s1,1108 # 1000 <freep>
  if (p == SBRK_ERROR)
 bb4:	5afd                	li	s5,-1
 bb6:	a83d                	j	bf4 <malloc+0x92>
 bb8:	f426                	sd	s1,40(sp)
 bba:	e852                	sd	s4,16(sp)
 bbc:	e456                	sd	s5,8(sp)
 bbe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bc0:	00004797          	auipc	a5,0x4
 bc4:	45078793          	addi	a5,a5,1104 # 5010 <base>
 bc8:	00000717          	auipc	a4,0x0
 bcc:	42f73c23          	sd	a5,1080(a4) # 1000 <freep>
 bd0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bd2:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 bd6:	b7d1                	j	b9a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 bd8:	6398                	ld	a4,0(a5)
 bda:	e118                	sd	a4,0(a0)
 bdc:	a899                	j	c32 <malloc+0xd0>
  hp->s.size = nu;
 bde:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 be2:	0541                	addi	a0,a0,16
 be4:	ef5ff0ef          	jal	ad8 <free>
  return freep;
 be8:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 bea:	c125                	beqz	a0,c4a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 bec:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 bee:	4798                	lw	a4,8(a5)
 bf0:	03277163          	bgeu	a4,s2,c12 <malloc+0xb0>
    if (p == freep)
 bf4:	6098                	ld	a4,0(s1)
 bf6:	853e                	mv	a0,a5
 bf8:	fef71ae3          	bne	a4,a5,bec <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 bfc:	8552                	mv	a0,s4
 bfe:	9ffff0ef          	jal	5fc <sbrk>
  if (p == SBRK_ERROR)
 c02:	fd551ee3          	bne	a0,s5,bde <malloc+0x7c>
        return 0;
 c06:	4501                	li	a0,0
 c08:	74a2                	ld	s1,40(sp)
 c0a:	6a42                	ld	s4,16(sp)
 c0c:	6aa2                	ld	s5,8(sp)
 c0e:	6b02                	ld	s6,0(sp)
 c10:	a03d                	j	c3e <malloc+0xdc>
 c12:	74a2                	ld	s1,40(sp)
 c14:	6a42                	ld	s4,16(sp)
 c16:	6aa2                	ld	s5,8(sp)
 c18:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 c1a:	fae90fe3          	beq	s2,a4,bd8 <malloc+0x76>
        p->s.size -= nunits;
 c1e:	4137073b          	subw	a4,a4,s3
 c22:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c24:	02071693          	slli	a3,a4,0x20
 c28:	01c6d713          	srli	a4,a3,0x1c
 c2c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c2e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c32:	00000717          	auipc	a4,0x0
 c36:	3ca73723          	sd	a0,974(a4) # 1000 <freep>
      return (void *)(p + 1);
 c3a:	01078513          	addi	a0,a5,16
  }
}
 c3e:	70e2                	ld	ra,56(sp)
 c40:	7442                	ld	s0,48(sp)
 c42:	7902                	ld	s2,32(sp)
 c44:	69e2                	ld	s3,24(sp)
 c46:	6121                	addi	sp,sp,64
 c48:	8082                	ret
 c4a:	74a2                	ld	s1,40(sp)
 c4c:	6a42                	ld	s4,16(sp)
 c4e:	6aa2                	ld	s5,8(sp)
 c50:	6b02                	ld	s6,0(sp)
 c52:	b7f5                	j	c3e <malloc+0xdc>
