
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <match>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

// Wildcard matcher
int match(char *pattern, char *string) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	e84a                	sd	s2,16(sp)
   8:	1800                	addi	s0,sp,48
   a:	892e                	mv	s2,a1
	if (pattern[0] == '\0') return string[0] == '\0';
   c:	00054783          	lbu	a5,0(a0)
  10:	c79d                	beqz	a5,3e <match+0x3e>
  12:	e44e                	sd	s3,8(sp)
  14:	89aa                	mv	s3,a0
	if (pattern[0] == '*') {
  16:	02a00713          	li	a4,42
  1a:	02e78763          	beq	a5,a4,48 <match+0x48>
		for (int i = 0; string[i] != '\0'; i++) {
			if (match(pattern + 1, string + i)) return 1;
		}
		return match(pattern + 1, string);
	}
	if (string[0] != '\0' && (pattern[0] == string[0])) {
  1e:	0005c703          	lbu	a4,0(a1)
  22:	8f99                	sub	a5,a5,a4
  24:	0017b793          	seqz	a5,a5
  28:	00e03733          	snez	a4,a4
  2c:	8ff9                	and	a5,a5,a4
		return match(pattern + 1, string + 1);
	}
	return 0;
  2e:	4501                	li	a0,0
	if (string[0] != '\0' && (pattern[0] == string[0])) {
  30:	e7b9                	bnez	a5,7e <match+0x7e>
  32:	69a2                	ld	s3,8(sp)
}
  34:	70a2                	ld	ra,40(sp)
  36:	7402                	ld	s0,32(sp)
  38:	6942                	ld	s2,16(sp)
  3a:	6145                	addi	sp,sp,48
  3c:	8082                	ret
	if (pattern[0] == '\0') return string[0] == '\0';
  3e:	0005c503          	lbu	a0,0(a1)
  42:	00153513          	seqz	a0,a0
  46:	b7fd                	j	34 <match+0x34>
  48:	ec26                	sd	s1,24(sp)
		for (int i = 0; string[i] != '\0'; i++) {
  4a:	84ae                	mv	s1,a1
  4c:	0005c783          	lbu	a5,0(a1)
  50:	cf99                	beqz	a5,6e <match+0x6e>
  52:	e052                	sd	s4,0(sp)
			if (match(pattern + 1, string + i)) return 1;
  54:	00150793          	addi	a5,a0,1
  58:	8a3e                	mv	s4,a5
  5a:	85a6                	mv	a1,s1
  5c:	8552                	mv	a0,s4
  5e:	fa3ff0ef          	jal	0 <match>
  62:	e50d                	bnez	a0,8c <match+0x8c>
		for (int i = 0; string[i] != '\0'; i++) {
  64:	0485                	addi	s1,s1,1
  66:	0004c783          	lbu	a5,0(s1)
  6a:	fbe5                	bnez	a5,5a <match+0x5a>
  6c:	6a02                	ld	s4,0(sp)
		return match(pattern + 1, string);
  6e:	85ca                	mv	a1,s2
  70:	00198513          	addi	a0,s3,1
  74:	f8dff0ef          	jal	0 <match>
  78:	64e2                	ld	s1,24(sp)
  7a:	69a2                	ld	s3,8(sp)
  7c:	bf65                	j	34 <match+0x34>
		return match(pattern + 1, string + 1);
  7e:	0585                	addi	a1,a1,1
  80:	00198513          	addi	a0,s3,1
  84:	f7dff0ef          	jal	0 <match>
  88:	69a2                	ld	s3,8(sp)
  8a:	b76d                	j	34 <match+0x34>
			if (match(pattern + 1, string + i)) return 1;
  8c:	4505                	li	a0,1
  8e:	64e2                	ld	s1,24(sp)
  90:	69a2                	ld	s3,8(sp)
  92:	6a02                	ld	s4,0(sp)
  94:	b745                	j	34 <match+0x34>

0000000000000096 <find>:

// Recursive find function
int find(char *path, char *pattern, char *type) {
  96:	d7010113          	addi	sp,sp,-656
  9a:	28113423          	sd	ra,648(sp)
  9e:	28813023          	sd	s0,640(sp)
  a2:	27213823          	sd	s2,624(sp)
  a6:	25813023          	sd	s8,576(sp)
  aa:	23913c23          	sd	s9,568(sp)
  ae:	0d00                	addi	s0,sp,656
  b0:	892a                	mv	s2,a0
  b2:	8c2e                	mv	s8,a1
  b4:	8cb2                	mv	s9,a2
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;

	if ((fd = open(path, 0)) < 0) {
  b6:	4581                	li	a1,0
  b8:	53c000ef          	jal	5f4 <open>
  bc:	12054f63          	bltz	a0,1fa <find+0x164>
  c0:	26913c23          	sd	s1,632(sp)
  c4:	84aa                	mv	s1,a0
		fprintf(2, "find: cannot open %s\n", path);
		return -1;
	}

	if (fstat(fd, &st) < 0) {
  c6:	d7840593          	addi	a1,s0,-648
  ca:	542000ef          	jal	60c <fstat>
  ce:	12054f63          	bltz	a0,20c <find+0x176>
		close(fd);
		return -1;
	}

	if (st.type != T_DIR) {
  d2:	d8041703          	lh	a4,-640(s0)
  d6:	4785                	li	a5,1
  d8:	14f71063          	bne	a4,a5,218 <find+0x182>
		close(fd);
		return -1;
	}

	if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
  dc:	854a                	mv	a0,s2
  de:	280000ef          	jal	35e <strlen>
  e2:	2541                	addiw	a0,a0,16
  e4:	20000793          	li	a5,512
  e8:	12a7ef63          	bltu	a5,a0,226 <find+0x190>
  ec:	27313423          	sd	s3,616(sp)
  f0:	27413023          	sd	s4,608(sp)
  f4:	25513c23          	sd	s5,600(sp)
  f8:	25613823          	sd	s6,592(sp)
  fc:	25713423          	sd	s7,584(sp)
		close(fd);
		return -1;
	}

	strcpy(buf, path);
 100:	da040a13          	addi	s4,s0,-608
 104:	85ca                	mv	a1,s2
 106:	8552                	mv	a0,s4
 108:	206000ef          	jal	30e <strcpy>
	p = buf + strlen(buf);
 10c:	8552                	mv	a0,s4
 10e:	250000ef          	jal	35e <strlen>
 112:	1502                	slli	a0,a0,0x20
 114:	9101                	srli	a0,a0,0x20
 116:	9a2a                	add	s4,s4,a0
	*p++ = '/';
 118:	001a0793          	addi	a5,s4,1
 11c:	8bbe                	mv	s7,a5
 11e:	02f00793          	li	a5,47
 122:	00fa0023          	sb	a5,0(s4)

	while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 126:	d9040993          	addi	s3,s0,-624
 12a:	4941                	li	s2,16
		if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) continue;
 12c:	d9240b13          	addi	s6,s0,-622
 130:	00001a97          	auipc	s5,0x1
 134:	ac8a8a93          	addi	s5,s5,-1336 # bf8 <malloc+0x112>
	while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 138:	864a                	mv	a2,s2
 13a:	85ce                	mv	a1,s3
 13c:	8526                	mv	a0,s1
 13e:	48e000ef          	jal	5cc <read>
 142:	0f251863          	bne	a0,s2,232 <find+0x19c>
		if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) continue;
 146:	d9045783          	lhu	a5,-624(s0)
 14a:	d7fd                	beqz	a5,138 <find+0xa2>
 14c:	85d6                	mv	a1,s5
 14e:	855a                	mv	a0,s6
 150:	1de000ef          	jal	32e <strcmp>
 154:	d175                	beqz	a0,138 <find+0xa2>
 156:	00001597          	auipc	a1,0x1
 15a:	aaa58593          	addi	a1,a1,-1366 # c00 <malloc+0x11a>
 15e:	d9240513          	addi	a0,s0,-622
 162:	1cc000ef          	jal	32e <strcmp>
 166:	d969                	beqz	a0,138 <find+0xa2>

		memmove(p, de.name, DIRSIZ);
 168:	4639                	li	a2,14
 16a:	d9240593          	addi	a1,s0,-622
 16e:	855e                	mv	a0,s7
 170:	36a000ef          	jal	4da <memmove>
		p[DIRSIZ] = '\0';
 174:	000a07a3          	sb	zero,15(s4)

		if (stat(buf, &st) < 0) continue;
 178:	d7840593          	addi	a1,s0,-648
 17c:	da040513          	addi	a0,s0,-608
 180:	2d2000ef          	jal	452 <stat>
 184:	fa054ae3          	bltz	a0,138 <find+0xa2>

		if (match(pattern, de.name)) {
 188:	d9240593          	addi	a1,s0,-622
 18c:	8562                	mv	a0,s8
 18e:	e73ff0ef          	jal	0 <match>
 192:	c921                	beqz	a0,1e2 <find+0x14c>
			if (type == 0 || (strcmp(type, "f") == 0 && (st.type == T_FILE || st.type == T_DEVICE)) || (strcmp(type, "d") == 0 && st.type == T_DIR)) {
 194:	020c8f63          	beqz	s9,1d2 <find+0x13c>
 198:	00001597          	auipc	a1,0x1
 19c:	a7058593          	addi	a1,a1,-1424 # c08 <malloc+0x122>
 1a0:	8566                	mv	a0,s9
 1a2:	18c000ef          	jal	32e <strcmp>
 1a6:	e909                	bnez	a0,1b8 <find+0x122>
 1a8:	d8045783          	lhu	a5,-640(s0)
 1ac:	37f9                	addiw	a5,a5,-2
 1ae:	17c2                	slli	a5,a5,0x30
 1b0:	93c1                	srli	a5,a5,0x30
 1b2:	4705                	li	a4,1
 1b4:	00f77f63          	bgeu	a4,a5,1d2 <find+0x13c>
 1b8:	00001597          	auipc	a1,0x1
 1bc:	a5858593          	addi	a1,a1,-1448 # c10 <malloc+0x12a>
 1c0:	8566                	mv	a0,s9
 1c2:	16c000ef          	jal	32e <strcmp>
 1c6:	ed11                	bnez	a0,1e2 <find+0x14c>
 1c8:	d8041703          	lh	a4,-640(s0)
 1cc:	4785                	li	a5,1
 1ce:	f6f715e3          	bne	a4,a5,138 <find+0xa2>
				printf("%s\n", buf);
 1d2:	da040593          	addi	a1,s0,-608
 1d6:	00001517          	auipc	a0,0x1
 1da:	a4250513          	addi	a0,a0,-1470 # c18 <malloc+0x132>
 1de:	04d000ef          	jal	a2a <printf>
			}
		}

		if (st.type == T_DIR) find(buf, pattern, type);
 1e2:	d8041703          	lh	a4,-640(s0)
 1e6:	4785                	li	a5,1
 1e8:	f4f718e3          	bne	a4,a5,138 <find+0xa2>
 1ec:	8666                	mv	a2,s9
 1ee:	85e2                	mv	a1,s8
 1f0:	da040513          	addi	a0,s0,-608
 1f4:	ea3ff0ef          	jal	96 <find>
 1f8:	b781                	j	138 <find+0xa2>
		fprintf(2, "find: cannot open %s\n", path);
 1fa:	864a                	mv	a2,s2
 1fc:	00001597          	auipc	a1,0x1
 200:	9e458593          	addi	a1,a1,-1564 # be0 <malloc+0xfa>
 204:	4509                	li	a0,2
 206:	7fa000ef          	jal	a00 <fprintf>
		return -1;
 20a:	a821                	j	222 <find+0x18c>
		close(fd);
 20c:	8526                	mv	a0,s1
 20e:	3ce000ef          	jal	5dc <close>
		return -1;
 212:	27813483          	ld	s1,632(sp)
 216:	a031                	j	222 <find+0x18c>
		close(fd);
 218:	8526                	mv	a0,s1
 21a:	3c2000ef          	jal	5dc <close>
		return -1;
 21e:	27813483          	ld	s1,632(sp)
		return -1;
 222:	557d                	li	a0,-1
 224:	a03d                	j	252 <find+0x1bc>
		close(fd);
 226:	8526                	mv	a0,s1
 228:	3b4000ef          	jal	5dc <close>
		return -1;
 22c:	27813483          	ld	s1,632(sp)
 230:	bfcd                	j	222 <find+0x18c>
	}
	close(fd);
 232:	8526                	mv	a0,s1
 234:	3a8000ef          	jal	5dc <close>
	return 0;
 238:	4501                	li	a0,0
 23a:	27813483          	ld	s1,632(sp)
 23e:	26813983          	ld	s3,616(sp)
 242:	26013a03          	ld	s4,608(sp)
 246:	25813a83          	ld	s5,600(sp)
 24a:	25013b03          	ld	s6,592(sp)
 24e:	24813b83          	ld	s7,584(sp)
}
 252:	28813083          	ld	ra,648(sp)
 256:	28013403          	ld	s0,640(sp)
 25a:	27013903          	ld	s2,624(sp)
 25e:	24013c03          	ld	s8,576(sp)
 262:	23813c83          	ld	s9,568(sp)
 266:	29010113          	addi	sp,sp,656
 26a:	8082                	ret

000000000000026c <main>:

int main(int argc, char *argv[]) {
 26c:	1101                	addi	sp,sp,-32
 26e:	ec06                	sd	ra,24(sp)
 270:	e822                	sd	s0,16(sp)
 272:	1000                	addi	s0,sp,32
	char *type = 0;

	if (argc != 3 && argc != 5) {
 274:	ffd5079b          	addiw	a5,a0,-3
 278:	9bf5                	andi	a5,a5,-3
 27a:	e385                	bnez	a5,29a <main+0x2e>
 27c:	e426                	sd	s1,8(sp)
 27e:	84ae                	mv	s1,a1
		fprintf(2, "usage: find <dir> <pattern> [-type f|d]\n");
		exit(1);
	}

	if (argc == 5) {
 280:	4795                	li	a5,5
	char *type = 0;
 282:	4601                	li	a2,0
	if (argc == 5) {
 284:	02f50663          	beq	a0,a5,2b0 <main+0x44>
			exit(1);
		}
		type = argv[4];
	}

	if (find(argv[1], argv[2], type) < 0) exit(1);
 288:	688c                	ld	a1,16(s1)
 28a:	6488                	ld	a0,8(s1)
 28c:	e0bff0ef          	jal	96 <find>
 290:	06054463          	bltz	a0,2f8 <main+0x8c>
	exit(0);
 294:	4501                	li	a0,0
 296:	31e000ef          	jal	5b4 <exit>
 29a:	e426                	sd	s1,8(sp)
		fprintf(2, "usage: find <dir> <pattern> [-type f|d]\n");
 29c:	00001597          	auipc	a1,0x1
 2a0:	98458593          	addi	a1,a1,-1660 # c20 <malloc+0x13a>
 2a4:	4509                	li	a0,2
 2a6:	75a000ef          	jal	a00 <fprintf>
		exit(1);
 2aa:	4505                	li	a0,1
 2ac:	308000ef          	jal	5b4 <exit>
		if (strcmp(argv[3], "-type") != 0 || (strcmp(argv[4], "f") != 0 && strcmp(argv[4], "d") != 0)) {
 2b0:	00001597          	auipc	a1,0x1
 2b4:	9a058593          	addi	a1,a1,-1632 # c50 <malloc+0x16a>
 2b8:	6c88                	ld	a0,24(s1)
 2ba:	074000ef          	jal	32e <strcmp>
 2be:	e11d                	bnez	a0,2e4 <main+0x78>
 2c0:	00001597          	auipc	a1,0x1
 2c4:	94858593          	addi	a1,a1,-1720 # c08 <malloc+0x122>
 2c8:	7088                	ld	a0,32(s1)
 2ca:	064000ef          	jal	32e <strcmp>
 2ce:	e119                	bnez	a0,2d4 <main+0x68>
		type = argv[4];
 2d0:	7090                	ld	a2,32(s1)
 2d2:	bf5d                	j	288 <main+0x1c>
		if (strcmp(argv[3], "-type") != 0 || (strcmp(argv[4], "f") != 0 && strcmp(argv[4], "d") != 0)) {
 2d4:	00001597          	auipc	a1,0x1
 2d8:	93c58593          	addi	a1,a1,-1732 # c10 <malloc+0x12a>
 2dc:	7088                	ld	a0,32(s1)
 2de:	050000ef          	jal	32e <strcmp>
 2e2:	d57d                	beqz	a0,2d0 <main+0x64>
			fprintf(2, "usage: find <dir> <pattern> [-type f|d]\n");
 2e4:	00001597          	auipc	a1,0x1
 2e8:	93c58593          	addi	a1,a1,-1732 # c20 <malloc+0x13a>
 2ec:	4509                	li	a0,2
 2ee:	712000ef          	jal	a00 <fprintf>
			exit(1);
 2f2:	4505                	li	a0,1
 2f4:	2c0000ef          	jal	5b4 <exit>
	if (find(argv[1], argv[2], type) < 0) exit(1);
 2f8:	4505                	li	a0,1
 2fa:	2ba000ef          	jal	5b4 <exit>

00000000000002fe <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 306:	f67ff0ef          	jal	26c <main>
  exit(r);
 30a:	2aa000ef          	jal	5b4 <exit>

000000000000030e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 316:	87aa                	mv	a5,a0
 318:	0585                	addi	a1,a1,1
 31a:	0785                	addi	a5,a5,1
 31c:	fff5c703          	lbu	a4,-1(a1)
 320:	fee78fa3          	sb	a4,-1(a5)
 324:	fb75                	bnez	a4,318 <strcpy+0xa>
    ;
  return os;
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 336:	00054783          	lbu	a5,0(a0)
 33a:	cb91                	beqz	a5,34e <strcmp+0x20>
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00f71763          	bne	a4,a5,34e <strcmp+0x20>
    p++, q++;
 344:	0505                	addi	a0,a0,1
 346:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 348:	00054783          	lbu	a5,0(a0)
 34c:	fbe5                	bnez	a5,33c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 34e:	0005c503          	lbu	a0,0(a1)
}
 352:	40a7853b          	subw	a0,a5,a0
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <strlen>:

uint
strlen(const char *s)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 366:	00054783          	lbu	a5,0(a0)
 36a:	cf91                	beqz	a5,386 <strlen+0x28>
 36c:	00150793          	addi	a5,a0,1
 370:	86be                	mv	a3,a5
 372:	0785                	addi	a5,a5,1
 374:	fff7c703          	lbu	a4,-1(a5)
 378:	ff65                	bnez	a4,370 <strlen+0x12>
 37a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  for (n = 0; s[n]; n++)
 386:	4501                	li	a0,0
 388:	bfdd                	j	37e <strlen+0x20>

000000000000038a <memset>:

void *
memset(void *dst, int c, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 392:	ca19                	beqz	a2,3a8 <memset+0x1e>
 394:	87aa                	mv	a5,a0
 396:	1602                	slli	a2,a2,0x20
 398:	9201                	srli	a2,a2,0x20
 39a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 39e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 3a2:	0785                	addi	a5,a5,1
 3a4:	fee79de3          	bne	a5,a4,39e <memset+0x14>
  }
  return dst;
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <strchr>:

char *
strchr(const char *s, char c)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e406                	sd	ra,8(sp)
 3b4:	e022                	sd	s0,0(sp)
 3b6:	0800                	addi	s0,sp,16
  for (; *s; s++)
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	c799                	beqz	a5,3ca <strchr+0x1a>
    if (*s == c)
 3be:	00f58763          	beq	a1,a5,3cc <strchr+0x1c>
  for (; *s; s++)
 3c2:	0505                	addi	a0,a0,1
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	fbfd                	bnez	a5,3be <strchr+0xe>
      return (char *)s;
  return 0;
 3ca:	4501                	li	a0,0
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <gets>:

char *
gets(char *buf, int max)
{
 3d4:	711d                	addi	sp,sp,-96
 3d6:	ec86                	sd	ra,88(sp)
 3d8:	e8a2                	sd	s0,80(sp)
 3da:	e4a6                	sd	s1,72(sp)
 3dc:	e0ca                	sd	s2,64(sp)
 3de:	fc4e                	sd	s3,56(sp)
 3e0:	f852                	sd	s4,48(sp)
 3e2:	f456                	sd	s5,40(sp)
 3e4:	f05a                	sd	s6,32(sp)
 3e6:	ec5e                	sd	s7,24(sp)
 3e8:	e862                	sd	s8,16(sp)
 3ea:	1080                	addi	s0,sp,96
 3ec:	8baa                	mv	s7,a0
 3ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 3f0:	892a                	mv	s2,a0
 3f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3f4:	faf40b13          	addi	s6,s0,-81
 3f8:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 3fa:	8c26                	mv	s8,s1
 3fc:	0014899b          	addiw	s3,s1,1
 400:	84ce                	mv	s1,s3
 402:	0349d863          	bge	s3,s4,432 <gets+0x5e>
    cc = read(0, &c, 1);
 406:	8656                	mv	a2,s5
 408:	85da                	mv	a1,s6
 40a:	4501                	li	a0,0
 40c:	1c0000ef          	jal	5cc <read>
    if (cc < 1)
 410:	02a05163          	blez	a0,432 <gets+0x5e>
      break;
    buf[i++] = c;
 414:	faf44783          	lbu	a5,-81(s0)
 418:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 41c:	0905                	addi	s2,s2,1
 41e:	ff678713          	addi	a4,a5,-10
 422:	00173713          	seqz	a4,a4
 426:	17cd                	addi	a5,a5,-13
 428:	0017b793          	seqz	a5,a5
 42c:	8fd9                	or	a5,a5,a4
 42e:	d7f1                	beqz	a5,3fa <gets+0x26>
    buf[i++] = c;
 430:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 432:	9c5e                	add	s8,s8,s7
 434:	000c0023          	sb	zero,0(s8)
  return buf;
}
 438:	855e                	mv	a0,s7
 43a:	60e6                	ld	ra,88(sp)
 43c:	6446                	ld	s0,80(sp)
 43e:	64a6                	ld	s1,72(sp)
 440:	6906                	ld	s2,64(sp)
 442:	79e2                	ld	s3,56(sp)
 444:	7a42                	ld	s4,48(sp)
 446:	7aa2                	ld	s5,40(sp)
 448:	7b02                	ld	s6,32(sp)
 44a:	6be2                	ld	s7,24(sp)
 44c:	6c42                	ld	s8,16(sp)
 44e:	6125                	addi	sp,sp,96
 450:	8082                	ret

0000000000000452 <stat>:

int
stat(const char *n, struct stat *st)
{
 452:	1101                	addi	sp,sp,-32
 454:	ec06                	sd	ra,24(sp)
 456:	e822                	sd	s0,16(sp)
 458:	e04a                	sd	s2,0(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 45e:	4581                	li	a1,0
 460:	194000ef          	jal	5f4 <open>
  if (fd < 0)
 464:	02054263          	bltz	a0,488 <stat+0x36>
 468:	e426                	sd	s1,8(sp)
 46a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 46c:	85ca                	mv	a1,s2
 46e:	19e000ef          	jal	60c <fstat>
 472:	892a                	mv	s2,a0
  close(fd);
 474:	8526                	mv	a0,s1
 476:	166000ef          	jal	5dc <close>
  return r;
 47a:	64a2                	ld	s1,8(sp)
}
 47c:	854a                	mv	a0,s2
 47e:	60e2                	ld	ra,24(sp)
 480:	6442                	ld	s0,16(sp)
 482:	6902                	ld	s2,0(sp)
 484:	6105                	addi	sp,sp,32
 486:	8082                	ret
    return -1;
 488:	57fd                	li	a5,-1
 48a:	893e                	mv	s2,a5
 48c:	bfc5                	j	47c <stat+0x2a>

000000000000048e <atoi>:

int
atoi(const char *s)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e406                	sd	ra,8(sp)
 492:	e022                	sd	s0,0(sp)
 494:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 496:	00054683          	lbu	a3,0(a0)
 49a:	fd06879b          	addiw	a5,a3,-48
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	4625                	li	a2,9
 4a4:	02f66963          	bltu	a2,a5,4d6 <atoi+0x48>
 4a8:	872a                	mv	a4,a0
  n = 0;
 4aa:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 4ac:	0705                	addi	a4,a4,1
 4ae:	0025179b          	slliw	a5,a0,0x2
 4b2:	9fa9                	addw	a5,a5,a0
 4b4:	0017979b          	slliw	a5,a5,0x1
 4b8:	9fb5                	addw	a5,a5,a3
 4ba:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 4be:	00074683          	lbu	a3,0(a4)
 4c2:	fd06879b          	addiw	a5,a3,-48
 4c6:	0ff7f793          	zext.b	a5,a5
 4ca:	fef671e3          	bgeu	a2,a5,4ac <atoi+0x1e>
  return n;
}
 4ce:	60a2                	ld	ra,8(sp)
 4d0:	6402                	ld	s0,0(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret
  n = 0;
 4d6:	4501                	li	a0,0
 4d8:	bfdd                	j	4ce <atoi+0x40>

00000000000004da <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e406                	sd	ra,8(sp)
 4de:	e022                	sd	s0,0(sp)
 4e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e2:	02b57563          	bgeu	a0,a1,50c <memmove+0x32>
    while (n-- > 0)
 4e6:	00c05f63          	blez	a2,504 <memmove+0x2a>
 4ea:	1602                	slli	a2,a2,0x20
 4ec:	9201                	srli	a2,a2,0x20
 4ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f4:	0585                	addi	a1,a1,1
 4f6:	0705                	addi	a4,a4,1
 4f8:	fff5c683          	lbu	a3,-1(a1)
 4fc:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 500:	fee79ae3          	bne	a5,a4,4f4 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 504:	60a2                	ld	ra,8(sp)
 506:	6402                	ld	s0,0(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret
    while (n-- > 0)
 50c:	fec05ce3          	blez	a2,504 <memmove+0x2a>
    dst += n;
 510:	00c50733          	add	a4,a0,a2
    src += n;
 514:	95b2                	add	a1,a1,a2
 516:	fff6079b          	addiw	a5,a2,-1
 51a:	1782                	slli	a5,a5,0x20
 51c:	9381                	srli	a5,a5,0x20
 51e:	fff7c793          	not	a5,a5
 522:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 524:	15fd                	addi	a1,a1,-1
 526:	177d                	addi	a4,a4,-1
 528:	0005c683          	lbu	a3,0(a1)
 52c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 530:	fef71ae3          	bne	a4,a5,524 <memmove+0x4a>
 534:	bfc1                	j	504 <memmove+0x2a>

0000000000000536 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 536:	1141                	addi	sp,sp,-16
 538:	e406                	sd	ra,8(sp)
 53a:	e022                	sd	s0,0(sp)
 53c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 53e:	ce19                	beqz	a2,55c <memcmp+0x26>
 540:	1602                	slli	a2,a2,0x20
 542:	9201                	srli	a2,a2,0x20
 544:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 548:	00054783          	lbu	a5,0(a0)
 54c:	0005c703          	lbu	a4,0(a1)
 550:	00e79b63          	bne	a5,a4,566 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 554:	0505                	addi	a0,a0,1
    p2++;
 556:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 558:	fed518e3          	bne	a0,a3,548 <memcmp+0x12>
  }
  return 0;
 55c:	4501                	li	a0,0
}
 55e:	60a2                	ld	ra,8(sp)
 560:	6402                	ld	s0,0(sp)
 562:	0141                	addi	sp,sp,16
 564:	8082                	ret
      return *p1 - *p2;
 566:	40e7853b          	subw	a0,a5,a4
 56a:	bfd5                	j	55e <memcmp+0x28>

000000000000056c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 56c:	1141                	addi	sp,sp,-16
 56e:	e406                	sd	ra,8(sp)
 570:	e022                	sd	s0,0(sp)
 572:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 574:	f67ff0ef          	jal	4da <memmove>
}
 578:	60a2                	ld	ra,8(sp)
 57a:	6402                	ld	s0,0(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret

0000000000000580 <sbrk>:

char *
sbrk(int n)
{
 580:	1141                	addi	sp,sp,-16
 582:	e406                	sd	ra,8(sp)
 584:	e022                	sd	s0,0(sp)
 586:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 588:	4585                	li	a1,1
 58a:	0b2000ef          	jal	63c <sys_sbrk>
}
 58e:	60a2                	ld	ra,8(sp)
 590:	6402                	ld	s0,0(sp)
 592:	0141                	addi	sp,sp,16
 594:	8082                	ret

0000000000000596 <sbrklazy>:

char *
sbrklazy(int n)
{
 596:	1141                	addi	sp,sp,-16
 598:	e406                	sd	ra,8(sp)
 59a:	e022                	sd	s0,0(sp)
 59c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 59e:	4589                	li	a1,2
 5a0:	09c000ef          	jal	63c <sys_sbrk>
}
 5a4:	60a2                	ld	ra,8(sp)
 5a6:	6402                	ld	s0,0(sp)
 5a8:	0141                	addi	sp,sp,16
 5aa:	8082                	ret

00000000000005ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ac:	4885                	li	a7,1
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b4:	4889                	li	a7,2
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 5bc:	488d                	li	a7,3
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5c4:	4891                	li	a7,4
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <read>:
.global read
read:
 li a7, SYS_read
 5cc:	4895                	li	a7,5
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <write>:
.global write
write:
 li a7, SYS_write
 5d4:	48c1                	li	a7,16
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <close>:
.global close
close:
 li a7, SYS_close
 5dc:	48d5                	li	a7,21
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5e4:	4899                	li	a7,6
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ec:	489d                	li	a7,7
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <open>:
.global open
open:
 li a7, SYS_open
 5f4:	48bd                	li	a7,15
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5fc:	48c5                	li	a7,17
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 604:	48c9                	li	a7,18
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 60c:	48a1                	li	a7,8
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <link>:
.global link
link:
 li a7, SYS_link
 614:	48cd                	li	a7,19
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 61c:	48d1                	li	a7,20
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 624:	48a5                	li	a7,9
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <dup>:
.global dup
dup:
 li a7, SYS_dup
 62c:	48a9                	li	a7,10
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 634:	48ad                	li	a7,11
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 63c:	48b1                	li	a7,12
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <pause>:
.global pause
pause:
 li a7, SYS_pause
 644:	48b5                	li	a7,13
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 64c:	48b9                	li	a7,14
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <sync>:
.global sync
sync:
 li a7, SYS_sync
 654:	48d9                	li	a7,22
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <trace>:
.global trace
trace:
 li a7, SYS_trace
 65c:	48dd                	li	a7,23
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 664:	48e1                	li	a7,24
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 66c:	48e5                	li	a7,25
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 674:	1101                	addi	sp,sp,-32
 676:	ec06                	sd	ra,24(sp)
 678:	e822                	sd	s0,16(sp)
 67a:	1000                	addi	s0,sp,32
 67c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 680:	4605                	li	a2,1
 682:	fef40593          	addi	a1,s0,-17
 686:	f4fff0ef          	jal	5d4 <write>
}
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	6105                	addi	sp,sp,32
 690:	8082                	ret

0000000000000692 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 692:	715d                	addi	sp,sp,-80
 694:	e486                	sd	ra,72(sp)
 696:	e0a2                	sd	s0,64(sp)
 698:	f84a                	sd	s2,48(sp)
 69a:	f44e                	sd	s3,40(sp)
 69c:	0880                	addi	s0,sp,80
 69e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 6a0:	00d036b3          	snez	a3,a3
 6a4:	03f5d793          	srli	a5,a1,0x3f
 6a8:	8efd                	and	a3,a3,a5
  neg = 0;
 6aa:	4301                	li	t1,0
  if (sgn && xx < 0) {
 6ac:	c681                	beqz	a3,6b4 <printint+0x22>
    neg = 1;
    x = -xx;
 6ae:	40b005b3          	neg	a1,a1
    neg = 1;
 6b2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 6b4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 6b8:	86ce                	mv	a3,s3
  i = 0;
 6ba:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 6bc:	00000817          	auipc	a6,0x0
 6c0:	5a480813          	addi	a6,a6,1444 # c60 <digits>
 6c4:	88ba                	mv	a7,a4
 6c6:	0017051b          	addiw	a0,a4,1
 6ca:	872a                	mv	a4,a0
 6cc:	02c5f7b3          	remu	a5,a1,a2
 6d0:	97c2                	add	a5,a5,a6
 6d2:	0007c783          	lbu	a5,0(a5)
 6d6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 6da:	87ae                	mv	a5,a1
 6dc:	02c5d5b3          	divu	a1,a1,a2
 6e0:	0685                	addi	a3,a3,1
 6e2:	fec7f1e3          	bgeu	a5,a2,6c4 <printint+0x32>
  if (neg)
 6e6:	00030b63          	beqz	t1,6fc <printint+0x6a>
    buf[i++] = '-';
 6ea:	fd040793          	addi	a5,s0,-48
 6ee:	953e                	add	a0,a0,a5
 6f0:	02d00793          	li	a5,45
 6f4:	fef50423          	sb	a5,-24(a0)
 6f8:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 6fc:	02e05563          	blez	a4,726 <printint+0x94>
 700:	fc26                	sd	s1,56(sp)
 702:	377d                	addiw	a4,a4,-1
 704:	00e984b3          	add	s1,s3,a4
 708:	19fd                	addi	s3,s3,-1
 70a:	99ba                	add	s3,s3,a4
 70c:	1702                	slli	a4,a4,0x20
 70e:	9301                	srli	a4,a4,0x20
 710:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 714:	0004c583          	lbu	a1,0(s1)
 718:	854a                	mv	a0,s2
 71a:	f5bff0ef          	jal	674 <putc>
  while (--i >= 0)
 71e:	14fd                	addi	s1,s1,-1
 720:	ff349ae3          	bne	s1,s3,714 <printint+0x82>
 724:	74e2                	ld	s1,56(sp)
}
 726:	60a6                	ld	ra,72(sp)
 728:	6406                	ld	s0,64(sp)
 72a:	7942                	ld	s2,48(sp)
 72c:	79a2                	ld	s3,40(sp)
 72e:	6161                	addi	sp,sp,80
 730:	8082                	ret

0000000000000732 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 732:	711d                	addi	sp,sp,-96
 734:	ec86                	sd	ra,88(sp)
 736:	e8a2                	sd	s0,80(sp)
 738:	e4a6                	sd	s1,72(sp)
 73a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 73c:	0005c483          	lbu	s1,0(a1)
 740:	2a048063          	beqz	s1,9e0 <vprintf+0x2ae>
 744:	e0ca                	sd	s2,64(sp)
 746:	fc4e                	sd	s3,56(sp)
 748:	f852                	sd	s4,48(sp)
 74a:	f456                	sd	s5,40(sp)
 74c:	f05a                	sd	s6,32(sp)
 74e:	ec5e                	sd	s7,24(sp)
 750:	e862                	sd	s8,16(sp)
 752:	8b2a                	mv	s6,a0
 754:	8a2e                	mv	s4,a1
 756:	8bb2                	mv	s7,a2
  state = 0;
 758:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 75a:	4901                	li	s2,0
 75c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 75e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 762:	06400c13          	li	s8,100
 766:	a00d                	j	788 <vprintf+0x56>
        putc(fd, c0);
 768:	85a6                	mv	a1,s1
 76a:	855a                	mv	a0,s6
 76c:	f09ff0ef          	jal	674 <putc>
 770:	a019                	j	776 <vprintf+0x44>
    } else if (state == '%') {
 772:	03598363          	beq	s3,s5,798 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 776:	0019079b          	addiw	a5,s2,1
 77a:	893e                	mv	s2,a5
 77c:	873e                	mv	a4,a5
 77e:	97d2                	add	a5,a5,s4
 780:	0007c483          	lbu	s1,0(a5)
 784:	24048763          	beqz	s1,9d2 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 788:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 78c:	fe0993e3          	bnez	s3,772 <vprintf+0x40>
      if (c0 == '%') {
 790:	fd579ce3          	bne	a5,s5,768 <vprintf+0x36>
        state = '%';
 794:	89be                	mv	s3,a5
 796:	b7c5                	j	776 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 798:	00ea06b3          	add	a3,s4,a4
 79c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 7a0:	24060563          	beqz	a2,9ea <vprintf+0x2b8>
      if (c0 == 'd') {
 7a4:	0b878763          	beq	a5,s8,852 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 7a8:	f9478693          	addi	a3,a5,-108
 7ac:	0016b693          	seqz	a3,a3
 7b0:	f9c60593          	addi	a1,a2,-100
 7b4:	0015b593          	seqz	a1,a1
 7b8:	8df5                	and	a1,a1,a3
 7ba:	e9c5                	bnez	a1,86a <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 7bc:	9752                	add	a4,a4,s4
 7be:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7c2:	f9460713          	addi	a4,a2,-108
 7c6:	00173713          	seqz	a4,a4
 7ca:	8f75                	and	a4,a4,a3
 7cc:	f9c50593          	addi	a1,a0,-100
 7d0:	0015b593          	seqz	a1,a1
 7d4:	8df9                	and	a1,a1,a4
 7d6:	e5dd                	bnez	a1,884 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 7d8:	07500593          	li	a1,117
 7dc:	0cb78163          	beq	a5,a1,89e <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 7e0:	f8b60593          	addi	a1,a2,-117
 7e4:	0015b593          	seqz	a1,a1
 7e8:	8df5                	and	a1,a1,a3
 7ea:	e5f1                	bnez	a1,8b6 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 7ec:	f8b50593          	addi	a1,a0,-117
 7f0:	0015b593          	seqz	a1,a1
 7f4:	8df9                	and	a1,a1,a4
 7f6:	ede9                	bnez	a1,8d0 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 7f8:	07800593          	li	a1,120
 7fc:	0eb78763          	beq	a5,a1,8ea <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 800:	f8860613          	addi	a2,a2,-120
 804:	00163613          	seqz	a2,a2
 808:	8ef1                	and	a3,a3,a2
 80a:	0e069c63          	bnez	a3,902 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 80e:	f8850513          	addi	a0,a0,-120
 812:	00153513          	seqz	a0,a0
 816:	8f69                	and	a4,a4,a0
 818:	10071263          	bnez	a4,91c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 81c:	07000713          	li	a4,112
 820:	10e78a63          	beq	a5,a4,934 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 824:	06300713          	li	a4,99
 828:	14e78a63          	beq	a5,a4,97c <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 82c:	07300713          	li	a4,115
 830:	16e78063          	beq	a5,a4,990 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 834:	02500713          	li	a4,37
 838:	18e78863          	beq	a5,a4,9c8 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 83c:	02500593          	li	a1,37
 840:	855a                	mv	a0,s6
 842:	e33ff0ef          	jal	674 <putc>
        putc(fd, c0);
 846:	85a6                	mv	a1,s1
 848:	855a                	mv	a0,s6
 84a:	e2bff0ef          	jal	674 <putc>
      }

      state = 0;
 84e:	4981                	li	s3,0
 850:	b71d                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 852:	008b8493          	addi	s1,s7,8
 856:	4685                	li	a3,1
 858:	4629                	li	a2,10
 85a:	000ba583          	lw	a1,0(s7)
 85e:	855a                	mv	a0,s6
 860:	e33ff0ef          	jal	692 <printint>
 864:	8ba6                	mv	s7,s1
      state = 0;
 866:	4981                	li	s3,0
 868:	b739                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 86a:	008b8493          	addi	s1,s7,8
 86e:	4685                	li	a3,1
 870:	4629                	li	a2,10
 872:	000bb583          	ld	a1,0(s7)
 876:	855a                	mv	a0,s6
 878:	e1bff0ef          	jal	692 <printint>
        i += 1;
 87c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 87e:	8ba6                	mv	s7,s1
      state = 0;
 880:	4981                	li	s3,0
 882:	bdd5                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 884:	008b8493          	addi	s1,s7,8
 888:	4685                	li	a3,1
 88a:	4629                	li	a2,10
 88c:	000bb583          	ld	a1,0(s7)
 890:	855a                	mv	a0,s6
 892:	e01ff0ef          	jal	692 <printint>
        i += 2;
 896:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 898:	8ba6                	mv	s7,s1
      state = 0;
 89a:	4981                	li	s3,0
        i += 2;
 89c:	bde9                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 89e:	008b8493          	addi	s1,s7,8
 8a2:	4681                	li	a3,0
 8a4:	4629                	li	a2,10
 8a6:	000be583          	lwu	a1,0(s7)
 8aa:	855a                	mv	a0,s6
 8ac:	de7ff0ef          	jal	692 <printint>
 8b0:	8ba6                	mv	s7,s1
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	b5c9                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b6:	008b8493          	addi	s1,s7,8
 8ba:	4681                	li	a3,0
 8bc:	4629                	li	a2,10
 8be:	000bb583          	ld	a1,0(s7)
 8c2:	855a                	mv	a0,s6
 8c4:	dcfff0ef          	jal	692 <printint>
        i += 1;
 8c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ca:	8ba6                	mv	s7,s1
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b565                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d0:	008b8493          	addi	s1,s7,8
 8d4:	4681                	li	a3,0
 8d6:	4629                	li	a2,10
 8d8:	000bb583          	ld	a1,0(s7)
 8dc:	855a                	mv	a0,s6
 8de:	db5ff0ef          	jal	692 <printint>
        i += 2;
 8e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e4:	8ba6                	mv	s7,s1
      state = 0;
 8e6:	4981                	li	s3,0
        i += 2;
 8e8:	b579                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8ea:	008b8493          	addi	s1,s7,8
 8ee:	4681                	li	a3,0
 8f0:	4641                	li	a2,16
 8f2:	000be583          	lwu	a1,0(s7)
 8f6:	855a                	mv	a0,s6
 8f8:	d9bff0ef          	jal	692 <printint>
 8fc:	8ba6                	mv	s7,s1
      state = 0;
 8fe:	4981                	li	s3,0
 900:	bd9d                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 902:	008b8493          	addi	s1,s7,8
 906:	4681                	li	a3,0
 908:	4641                	li	a2,16
 90a:	000bb583          	ld	a1,0(s7)
 90e:	855a                	mv	a0,s6
 910:	d83ff0ef          	jal	692 <printint>
        i += 1;
 914:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 916:	8ba6                	mv	s7,s1
      state = 0;
 918:	4981                	li	s3,0
 91a:	bdb1                	j	776 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 91c:	008b8493          	addi	s1,s7,8
 920:	4641                	li	a2,16
 922:	000bb583          	ld	a1,0(s7)
 926:	855a                	mv	a0,s6
 928:	d6bff0ef          	jal	692 <printint>
        i += 2;
 92c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 92e:	8ba6                	mv	s7,s1
      state = 0;
 930:	4981                	li	s3,0
        i += 2;
 932:	b591                	j	776 <vprintf+0x44>
 934:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 936:	008b8793          	addi	a5,s7,8
 93a:	8cbe                	mv	s9,a5
 93c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 940:	03000593          	li	a1,48
 944:	855a                	mv	a0,s6
 946:	d2fff0ef          	jal	674 <putc>
  putc(fd, 'x');
 94a:	07800593          	li	a1,120
 94e:	855a                	mv	a0,s6
 950:	d25ff0ef          	jal	674 <putc>
 954:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 956:	00000b97          	auipc	s7,0x0
 95a:	30ab8b93          	addi	s7,s7,778 # c60 <digits>
 95e:	03c9d793          	srli	a5,s3,0x3c
 962:	97de                	add	a5,a5,s7
 964:	0007c583          	lbu	a1,0(a5)
 968:	855a                	mv	a0,s6
 96a:	d0bff0ef          	jal	674 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 96e:	0992                	slli	s3,s3,0x4
 970:	34fd                	addiw	s1,s1,-1
 972:	f4f5                	bnez	s1,95e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 974:	8be6                	mv	s7,s9
      state = 0;
 976:	4981                	li	s3,0
 978:	6ca2                	ld	s9,8(sp)
 97a:	bbf5                	j	776 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 97c:	008b8493          	addi	s1,s7,8
 980:	000bc583          	lbu	a1,0(s7)
 984:	855a                	mv	a0,s6
 986:	cefff0ef          	jal	674 <putc>
 98a:	8ba6                	mv	s7,s1
      state = 0;
 98c:	4981                	li	s3,0
 98e:	b3e5                	j	776 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 990:	008b8993          	addi	s3,s7,8
 994:	000bb483          	ld	s1,0(s7)
 998:	cc91                	beqz	s1,9b4 <vprintf+0x282>
        for (; *s; s++)
 99a:	0004c583          	lbu	a1,0(s1)
 99e:	c195                	beqz	a1,9c2 <vprintf+0x290>
          putc(fd, *s);
 9a0:	855a                	mv	a0,s6
 9a2:	cd3ff0ef          	jal	674 <putc>
        for (; *s; s++)
 9a6:	0485                	addi	s1,s1,1
 9a8:	0004c583          	lbu	a1,0(s1)
 9ac:	f9f5                	bnez	a1,9a0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 9ae:	8bce                	mv	s7,s3
      state = 0;
 9b0:	4981                	li	s3,0
 9b2:	b3d1                	j	776 <vprintf+0x44>
          s = "(null)";
 9b4:	00000497          	auipc	s1,0x0
 9b8:	2a448493          	addi	s1,s1,676 # c58 <malloc+0x172>
        for (; *s; s++)
 9bc:	02800593          	li	a1,40
 9c0:	b7c5                	j	9a0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 9c2:	8bce                	mv	s7,s3
      state = 0;
 9c4:	4981                	li	s3,0
 9c6:	bb45                	j	776 <vprintf+0x44>
        putc(fd, '%');
 9c8:	85be                	mv	a1,a5
 9ca:	855a                	mv	a0,s6
 9cc:	ca9ff0ef          	jal	674 <putc>
 9d0:	bdbd                	j	84e <vprintf+0x11c>
 9d2:	6906                	ld	s2,64(sp)
 9d4:	79e2                	ld	s3,56(sp)
 9d6:	7a42                	ld	s4,48(sp)
 9d8:	7aa2                	ld	s5,40(sp)
 9da:	7b02                	ld	s6,32(sp)
 9dc:	6be2                	ld	s7,24(sp)
 9de:	6c42                	ld	s8,16(sp)
    }
  }
}
 9e0:	60e6                	ld	ra,88(sp)
 9e2:	6446                	ld	s0,80(sp)
 9e4:	64a6                	ld	s1,72(sp)
 9e6:	6125                	addi	sp,sp,96
 9e8:	8082                	ret
      if (c0 == 'd') {
 9ea:	06400713          	li	a4,100
 9ee:	e6e782e3          	beq	a5,a4,852 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 9f2:	f9478693          	addi	a3,a5,-108
 9f6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 9fa:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 9fc:	4701                	li	a4,0
 9fe:	bbe9                	j	7d8 <vprintf+0xa6>

0000000000000a00 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a00:	715d                	addi	sp,sp,-80
 a02:	ec06                	sd	ra,24(sp)
 a04:	e822                	sd	s0,16(sp)
 a06:	1000                	addi	s0,sp,32
 a08:	e010                	sd	a2,0(s0)
 a0a:	e414                	sd	a3,8(s0)
 a0c:	e818                	sd	a4,16(s0)
 a0e:	ec1c                	sd	a5,24(s0)
 a10:	03043023          	sd	a6,32(s0)
 a14:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a18:	8622                	mv	a2,s0
 a1a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a1e:	d15ff0ef          	jal	732 <vprintf>
}
 a22:	60e2                	ld	ra,24(sp)
 a24:	6442                	ld	s0,16(sp)
 a26:	6161                	addi	sp,sp,80
 a28:	8082                	ret

0000000000000a2a <printf>:

void
printf(const char *fmt, ...)
{
 a2a:	711d                	addi	sp,sp,-96
 a2c:	ec06                	sd	ra,24(sp)
 a2e:	e822                	sd	s0,16(sp)
 a30:	1000                	addi	s0,sp,32
 a32:	e40c                	sd	a1,8(s0)
 a34:	e810                	sd	a2,16(s0)
 a36:	ec14                	sd	a3,24(s0)
 a38:	f018                	sd	a4,32(s0)
 a3a:	f41c                	sd	a5,40(s0)
 a3c:	03043823          	sd	a6,48(s0)
 a40:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a44:	00840613          	addi	a2,s0,8
 a48:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a4c:	85aa                	mv	a1,a0
 a4e:	4505                	li	a0,1
 a50:	ce3ff0ef          	jal	732 <vprintf>
}
 a54:	60e2                	ld	ra,24(sp)
 a56:	6442                	ld	s0,16(sp)
 a58:	6125                	addi	sp,sp,96
 a5a:	8082                	ret

0000000000000a5c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a5c:	1141                	addi	sp,sp,-16
 a5e:	e406                	sd	ra,8(sp)
 a60:	e022                	sd	s0,0(sp)
 a62:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 a64:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a68:	00000797          	auipc	a5,0x0
 a6c:	5987b783          	ld	a5,1432(a5) # 1000 <freep>
 a70:	a095                	j	ad4 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 a72:	ff852583          	lw	a1,-8(a0)
 a76:	6390                	ld	a2,0(a5)
 a78:	02059813          	slli	a6,a1,0x20
 a7c:	01c85693          	srli	a3,a6,0x1c
 a80:	96ba                	add	a3,a3,a4
 a82:	02d60563          	beq	a2,a3,aac <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a86:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 a8a:	4790                	lw	a2,8(a5)
 a8c:	02061593          	slli	a1,a2,0x20
 a90:	01c5d693          	srli	a3,a1,0x1c
 a94:	96be                	add	a3,a3,a5
 a96:	02d70263          	beq	a4,a3,aba <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a9a:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56f73223          	sd	a5,1380(a4) # 1000 <freep>
}
 aa4:	60a2                	ld	ra,8(sp)
 aa6:	6402                	ld	s0,0(sp)
 aa8:	0141                	addi	sp,sp,16
 aaa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 aac:	4614                	lw	a3,8(a2)
 aae:	9ead                	addw	a3,a3,a1
 ab0:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab4:	6394                	ld	a3,0(a5)
 ab6:	6290                	ld	a2,0(a3)
 ab8:	b7f9                	j	a86 <free+0x2a>
    p->s.size += bp->s.size;
 aba:	ff852703          	lw	a4,-8(a0)
 abe:	9f31                	addw	a4,a4,a2
 ac0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ac2:	ff053703          	ld	a4,-16(a0)
 ac6:	bfd1                	j	a9a <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac8:	6394                	ld	a3,0(a5)
 aca:	00d7e463          	bltu	a5,a3,ad2 <free+0x76>
 ace:	fad762e3          	bltu	a4,a3,a72 <free+0x16>
 ad2:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad4:	fee7fae3          	bgeu	a5,a4,ac8 <free+0x6c>
 ad8:	6394                	ld	a3,0(a5)
 ada:	f8d76ce3          	bltu	a4,a3,a72 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ade:	f8d7fae3          	bgeu	a5,a3,a72 <free+0x16>
 ae2:	87b6                	mv	a5,a3
 ae4:	bfc5                	j	ad4 <free+0x78>

0000000000000ae6 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 ae6:	7139                	addi	sp,sp,-64
 ae8:	fc06                	sd	ra,56(sp)
 aea:	f822                	sd	s0,48(sp)
 aec:	f04a                	sd	s2,32(sp)
 aee:	ec4e                	sd	s3,24(sp)
 af0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 af2:	02051993          	slli	s3,a0,0x20
 af6:	0209d993          	srli	s3,s3,0x20
 afa:	09bd                	addi	s3,s3,15
 afc:	0049d993          	srli	s3,s3,0x4
 b00:	2985                	addiw	s3,s3,1
 b02:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 b04:	00000517          	auipc	a0,0x0
 b08:	4fc53503          	ld	a0,1276(a0) # 1000 <freep>
 b0c:	c905                	beqz	a0,b3c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b0e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b10:	4798                	lw	a4,8(a5)
 b12:	09377663          	bgeu	a4,s3,b9e <malloc+0xb8>
 b16:	f426                	sd	s1,40(sp)
 b18:	e852                	sd	s4,16(sp)
 b1a:	e456                	sd	s5,8(sp)
 b1c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 b1e:	8a4e                	mv	s4,s3
 b20:	6705                	lui	a4,0x1
 b22:	00e9f363          	bgeu	s3,a4,b28 <malloc+0x42>
 b26:	6a05                	lui	s4,0x1
 b28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b2c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 b30:	00000497          	auipc	s1,0x0
 b34:	4d048493          	addi	s1,s1,1232 # 1000 <freep>
  if (p == SBRK_ERROR)
 b38:	5afd                	li	s5,-1
 b3a:	a83d                	j	b78 <malloc+0x92>
 b3c:	f426                	sd	s1,40(sp)
 b3e:	e852                	sd	s4,16(sp)
 b40:	e456                	sd	s5,8(sp)
 b42:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b44:	00000797          	auipc	a5,0x0
 b48:	4cc78793          	addi	a5,a5,1228 # 1010 <base>
 b4c:	00000717          	auipc	a4,0x0
 b50:	4af73a23          	sd	a5,1204(a4) # 1000 <freep>
 b54:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b56:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 b5a:	b7d1                	j	b1e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b5c:	6398                	ld	a4,0(a5)
 b5e:	e118                	sd	a4,0(a0)
 b60:	a899                	j	bb6 <malloc+0xd0>
  hp->s.size = nu;
 b62:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 b66:	0541                	addi	a0,a0,16
 b68:	ef5ff0ef          	jal	a5c <free>
  return freep;
 b6c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 b6e:	c125                	beqz	a0,bce <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b70:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b72:	4798                	lw	a4,8(a5)
 b74:	03277163          	bgeu	a4,s2,b96 <malloc+0xb0>
    if (p == freep)
 b78:	6098                	ld	a4,0(s1)
 b7a:	853e                	mv	a0,a5
 b7c:	fef71ae3          	bne	a4,a5,b70 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b80:	8552                	mv	a0,s4
 b82:	9ffff0ef          	jal	580 <sbrk>
  if (p == SBRK_ERROR)
 b86:	fd551ee3          	bne	a0,s5,b62 <malloc+0x7c>
        return 0;
 b8a:	4501                	li	a0,0
 b8c:	74a2                	ld	s1,40(sp)
 b8e:	6a42                	ld	s4,16(sp)
 b90:	6aa2                	ld	s5,8(sp)
 b92:	6b02                	ld	s6,0(sp)
 b94:	a03d                	j	bc2 <malloc+0xdc>
 b96:	74a2                	ld	s1,40(sp)
 b98:	6a42                	ld	s4,16(sp)
 b9a:	6aa2                	ld	s5,8(sp)
 b9c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b9e:	fae90fe3          	beq	s2,a4,b5c <malloc+0x76>
        p->s.size -= nunits;
 ba2:	4137073b          	subw	a4,a4,s3
 ba6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ba8:	02071693          	slli	a3,a4,0x20
 bac:	01c6d713          	srli	a4,a3,0x1c
 bb0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bb2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bb6:	00000717          	auipc	a4,0x0
 bba:	44a73523          	sd	a0,1098(a4) # 1000 <freep>
      return (void *)(p + 1);
 bbe:	01078513          	addi	a0,a5,16
  }
}
 bc2:	70e2                	ld	ra,56(sp)
 bc4:	7442                	ld	s0,48(sp)
 bc6:	7902                	ld	s2,32(sp)
 bc8:	69e2                	ld	s3,24(sp)
 bca:	6121                	addi	sp,sp,64
 bcc:	8082                	ret
 bce:	74a2                	ld	s1,40(sp)
 bd0:	6a42                	ld	s4,16(sp)
 bd2:	6aa2                	ld	s5,8(sp)
 bd4:	6b02                	ld	s6,0(sp)
 bd6:	b7f5                	j	bc2 <malloc+0xdc>
