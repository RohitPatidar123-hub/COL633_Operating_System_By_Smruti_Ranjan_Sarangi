
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 bc 06 00 00       	push   $0x6bc
  19:	e8 c9 02 00 00       	call   2e7 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 93 00 00 00    	js     bc <main+0xbc>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 ec 02 00 00       	call   31f <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 e0 02 00 00       	call   31f <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 c4 06 00 00       	push   $0x6c4
  4c:	6a 01                	push   $0x1
  4e:	e8 89 03 00 00       	call   3dc <printf>
    pid = fork();
  53:	e8 47 02 00 00       	call   29f <fork>
  58:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	85 c0                	test   %eax,%eax
  5f:	78 24                	js     85 <main+0x85>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  61:	74 35                	je     98 <main+0x98>
  63:	90                   	nop
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  64:	e8 46 02 00 00       	call   2af <wait>
  69:	85 c0                	test   %eax,%eax
  6b:	78 d7                	js     44 <main+0x44>
  6d:	39 c3                	cmp    %eax,%ebx
  6f:	74 d3                	je     44 <main+0x44>
      printf(1, "zombie!\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 03 07 00 00       	push   $0x703
  79:	6a 01                	push   $0x1
  7b:	e8 5c 03 00 00       	call   3dc <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb df                	jmp    64 <main+0x64>
      printf(1, "init: fork failed\n");
  85:	53                   	push   %ebx
  86:	53                   	push   %ebx
  87:	68 d7 06 00 00       	push   $0x6d7
  8c:	6a 01                	push   $0x1
  8e:	e8 49 03 00 00       	call   3dc <printf>
      exit();
  93:	e8 0f 02 00 00       	call   2a7 <exit>
      exec("sh", argv);
  98:	50                   	push   %eax
  99:	50                   	push   %eax
  9a:	68 80 07 00 00       	push   $0x780
  9f:	68 ea 06 00 00       	push   $0x6ea
  a4:	e8 36 02 00 00       	call   2df <exec>
      printf(1, "init: exec sh failed\n");
  a9:	5a                   	pop    %edx
  aa:	59                   	pop    %ecx
  ab:	68 ed 06 00 00       	push   $0x6ed
  b0:	6a 01                	push   $0x1
  b2:	e8 25 03 00 00       	call   3dc <printf>
      exit();
  b7:	e8 eb 01 00 00       	call   2a7 <exit>
    mknod("console", 1, 1);
  bc:	50                   	push   %eax
  bd:	6a 01                	push   $0x1
  bf:	6a 01                	push   $0x1
  c1:	68 bc 06 00 00       	push   $0x6bc
  c6:	e8 24 02 00 00       	call   2ef <mknod>
    open("console", O_RDWR);
  cb:	58                   	pop    %eax
  cc:	5a                   	pop    %edx
  cd:	6a 02                	push   $0x2
  cf:	68 bc 06 00 00       	push   $0x6bc
  d4:	e8 0e 02 00 00       	call   2e7 <open>
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	e9 48 ff ff ff       	jmp    29 <main+0x29>
  e1:	66 90                	xchg   %ax,%ax
  e3:	90                   	nop

000000e4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	53                   	push   %ebx
  e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	31 c0                	xor    %eax,%eax
  f0:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  f3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f6:	40                   	inc    %eax
  f7:	84 d2                	test   %dl,%dl
  f9:	75 f5                	jne    f0 <strcpy+0xc>
    ;
  return os;
}
  fb:	89 c8                	mov    %ecx,%eax
  fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 100:	c9                   	leave
 101:	c3                   	ret
 102:	66 90                	xchg   %ax,%ax

00000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	53                   	push   %ebx
 108:	8b 55 08             	mov    0x8(%ebp),%edx
 10b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 10e:	0f b6 02             	movzbl (%edx),%eax
 111:	84 c0                	test   %al,%al
 113:	75 10                	jne    125 <strcmp+0x21>
 115:	eb 2a                	jmp    141 <strcmp+0x3d>
 117:	90                   	nop
    p++, q++;
 118:	42                   	inc    %edx
 119:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 11c:	0f b6 02             	movzbl (%edx),%eax
 11f:	84 c0                	test   %al,%al
 121:	74 11                	je     134 <strcmp+0x30>
 123:	89 cb                	mov    %ecx,%ebx
 125:	0f b6 0b             	movzbl (%ebx),%ecx
 128:	38 c1                	cmp    %al,%cl
 12a:	74 ec                	je     118 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 12c:	29 c8                	sub    %ecx,%eax
}
 12e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 131:	c9                   	leave
 132:	c3                   	ret
 133:	90                   	nop
  return (uchar)*p - (uchar)*q;
 134:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 138:	31 c0                	xor    %eax,%eax
 13a:	29 c8                	sub    %ecx,%eax
}
 13c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 13f:	c9                   	leave
 140:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 141:	0f b6 0b             	movzbl (%ebx),%ecx
 144:	31 c0                	xor    %eax,%eax
 146:	eb e4                	jmp    12c <strcmp+0x28>

00000148 <strlen>:

uint
strlen(const char *s)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 14e:	80 3a 00             	cmpb   $0x0,(%edx)
 151:	74 15                	je     168 <strlen+0x20>
 153:	31 c0                	xor    %eax,%eax
 155:	8d 76 00             	lea    0x0(%esi),%esi
 158:	40                   	inc    %eax
 159:	89 c1                	mov    %eax,%ecx
 15b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 15f:	75 f7                	jne    158 <strlen+0x10>
    ;
  return n;
}
 161:	89 c8                	mov    %ecx,%eax
 163:	5d                   	pop    %ebp
 164:	c3                   	ret
 165:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 168:	31 c9                	xor    %ecx,%ecx
}
 16a:	89 c8                	mov    %ecx,%eax
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret
 16e:	66 90                	xchg   %ax,%ax

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 174:	8b 7d 08             	mov    0x8(%ebp),%edi
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	fc                   	cld
 17e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	8b 7d fc             	mov    -0x4(%ebp),%edi
 186:	c9                   	leave
 187:	c3                   	ret

00000188 <strchr>:

char*
strchr(const char *s, char c)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 191:	8a 10                	mov    (%eax),%dl
 193:	84 d2                	test   %dl,%dl
 195:	75 0c                	jne    1a3 <strchr+0x1b>
 197:	eb 13                	jmp    1ac <strchr+0x24>
 199:	8d 76 00             	lea    0x0(%esi),%esi
 19c:	40                   	inc    %eax
 19d:	8a 10                	mov    (%eax),%dl
 19f:	84 d2                	test   %dl,%dl
 1a1:	74 09                	je     1ac <strchr+0x24>
    if(*s == c)
 1a3:	38 d1                	cmp    %dl,%cl
 1a5:	75 f5                	jne    19c <strchr+0x14>
      return (char*)s;
  return 0;
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret
 1a9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1ac:	31 c0                	xor    %eax,%eax
}
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b9:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1bb:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1be:	eb 24                	jmp    1e4 <gets+0x34>
    cc = read(0, &c, 1);
 1c0:	50                   	push   %eax
 1c1:	6a 01                	push   $0x1
 1c3:	56                   	push   %esi
 1c4:	6a 00                	push   $0x0
 1c6:	e8 f4 00 00 00       	call   2bf <read>
    if(cc < 1)
 1cb:	83 c4 10             	add    $0x10,%esp
 1ce:	85 c0                	test   %eax,%eax
 1d0:	7e 1a                	jle    1ec <gets+0x3c>
      break;
    buf[i++] = c;
 1d2:	8a 45 e7             	mov    -0x19(%ebp),%al
 1d5:	8b 55 08             	mov    0x8(%ebp),%edx
 1d8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 0e                	je     1ee <gets+0x3e>
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 0a                	je     1ee <gets+0x3e>
  for(i=0; i+1 < max; ){
 1e4:	89 df                	mov    %ebx,%edi
 1e6:	43                   	inc    %ebx
 1e7:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ea:	7c d4                	jl     1c0 <gets+0x10>
 1ec:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f8:	5b                   	pop    %ebx
 1f9:	5e                   	pop    %esi
 1fa:	5f                   	pop    %edi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret
 1fd:	8d 76 00             	lea    0x0(%esi),%esi

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	push   0x8(%ebp)
 20d:	e8 d5 00 00 00       	call   2e7 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
 219:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 21b:	83 ec 08             	sub    $0x8,%esp
 21e:	ff 75 0c             	push   0xc(%ebp)
 221:	50                   	push   %eax
 222:	e8 d8 00 00 00       	call   2ff <fstat>
 227:	89 c6                	mov    %eax,%esi
  close(fd);
 229:	89 1c 24             	mov    %ebx,(%esp)
 22c:	e8 9e 00 00 00       	call   2cf <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	89 f0                	mov    %esi,%eax
 236:	8d 65 f8             	lea    -0x8(%ebp),%esp
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	90                   	nop

00000248 <atoi>:

int
atoi(const char *s)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	53                   	push   %ebx
 24c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24f:	0f be 01             	movsbl (%ecx),%eax
 252:	8d 50 d0             	lea    -0x30(%eax),%edx
 255:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 258:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 25d:	77 16                	ja     275 <atoi+0x2d>
 25f:	90                   	nop
    n = n*10 + *s++ - '0';
 260:	41                   	inc    %ecx
 261:	8d 14 92             	lea    (%edx,%edx,4),%edx
 264:	01 d2                	add    %edx,%edx
 266:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 26a:	0f be 01             	movsbl (%ecx),%eax
 26d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x18>
  return n;
}
 275:	89 d0                	mov    %edx,%eax
 277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 27a:	c9                   	leave
 27b:	c3                   	ret

0000027c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	57                   	push   %edi
 280:	56                   	push   %esi
 281:	8b 55 08             	mov    0x8(%ebp),%edx
 284:	8b 75 0c             	mov    0xc(%ebp),%esi
 287:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28a:	85 c0                	test   %eax,%eax
 28c:	7e 0b                	jle    299 <memmove+0x1d>
 28e:	01 d0                	add    %edx,%eax
  dst = vdst;
 290:	89 d7                	mov    %edx,%edi
 292:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 294:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 295:	39 f8                	cmp    %edi,%eax
 297:	75 fb                	jne    294 <memmove+0x18>
  return vdst;
}
 299:	89 d0                	mov    %edx,%eax
 29b:	5e                   	pop    %esi
 29c:	5f                   	pop    %edi
 29d:	5d                   	pop    %ebp
 29e:	c3                   	ret

0000029f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29f:	b8 01 00 00 00       	mov    $0x1,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <exit>:
SYSCALL(exit)
 2a7:	b8 02 00 00 00       	mov    $0x2,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <wait>:
SYSCALL(wait)
 2af:	b8 03 00 00 00       	mov    $0x3,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <pipe>:
SYSCALL(pipe)
 2b7:	b8 04 00 00 00       	mov    $0x4,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <read>:
SYSCALL(read)
 2bf:	b8 05 00 00 00       	mov    $0x5,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <write>:
SYSCALL(write)
 2c7:	b8 10 00 00 00       	mov    $0x10,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <close>:
SYSCALL(close)
 2cf:	b8 15 00 00 00       	mov    $0x15,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <kill>:
SYSCALL(kill)
 2d7:	b8 06 00 00 00       	mov    $0x6,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <exec>:
SYSCALL(exec)
 2df:	b8 07 00 00 00       	mov    $0x7,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <open>:
SYSCALL(open)
 2e7:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <mknod>:
SYSCALL(mknod)
 2ef:	b8 11 00 00 00       	mov    $0x11,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <unlink>:
SYSCALL(unlink)
 2f7:	b8 12 00 00 00       	mov    $0x12,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <fstat>:
SYSCALL(fstat)
 2ff:	b8 08 00 00 00       	mov    $0x8,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <link>:
SYSCALL(link)
 307:	b8 13 00 00 00       	mov    $0x13,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <mkdir>:
SYSCALL(mkdir)
 30f:	b8 14 00 00 00       	mov    $0x14,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <chdir>:
SYSCALL(chdir)
 317:	b8 09 00 00 00       	mov    $0x9,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <dup>:
SYSCALL(dup)
 31f:	b8 0a 00 00 00       	mov    $0xa,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <getpid>:
SYSCALL(getpid)
 327:	b8 0b 00 00 00       	mov    $0xb,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <sbrk>:
SYSCALL(sbrk)
 32f:	b8 0c 00 00 00       	mov    $0xc,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <sleep>:
SYSCALL(sleep)
 337:	b8 0d 00 00 00       	mov    $0xd,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <uptime>:
SYSCALL(uptime)
 33f:	b8 0e 00 00 00       	mov    $0xe,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <signal>:
SYSCALL(signal)
 347:	b8 16 00 00 00       	mov    $0x16,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret
 34f:	90                   	nop

00000350 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
 356:	83 ec 3c             	sub    $0x3c,%esp
 359:	89 45 c0             	mov    %eax,-0x40(%ebp)
 35c:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 361:	85 c9                	test   %ecx,%ecx
 363:	74 04                	je     369 <printint+0x19>
 365:	85 d2                	test   %edx,%edx
 367:	78 6b                	js     3d4 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 369:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 36c:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 373:	31 c9                	xor    %ecx,%ecx
 375:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 378:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 37b:	31 d2                	xor    %edx,%edx
 37d:	f7 f3                	div    %ebx
 37f:	89 cf                	mov    %ecx,%edi
 381:	8d 49 01             	lea    0x1(%ecx),%ecx
 384:	8a 92 6c 07 00 00    	mov    0x76c(%edx),%dl
 38a:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 38e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 391:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 394:	39 da                	cmp    %ebx,%edx
 396:	73 e0                	jae    378 <printint+0x28>
  if(neg)
 398:	8b 55 08             	mov    0x8(%ebp),%edx
 39b:	85 d2                	test   %edx,%edx
 39d:	74 07                	je     3a6 <printint+0x56>
    buf[i++] = '-';
 39f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3a4:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3a6:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3a9:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3b0:	8a 07                	mov    (%edi),%al
 3b2:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3b5:	50                   	push   %eax
 3b6:	6a 01                	push   $0x1
 3b8:	56                   	push   %esi
 3b9:	ff 75 c0             	push   -0x40(%ebp)
 3bc:	e8 06 ff ff ff       	call   2c7 <write>
  while(--i >= 0)
 3c1:	89 f8                	mov    %edi,%eax
 3c3:	4f                   	dec    %edi
 3c4:	83 c4 10             	add    $0x10,%esp
 3c7:	39 d8                	cmp    %ebx,%eax
 3c9:	75 e5                	jne    3b0 <printint+0x60>
}
 3cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ce:	5b                   	pop    %ebx
 3cf:	5e                   	pop    %esi
 3d0:	5f                   	pop    %edi
 3d1:	5d                   	pop    %ebp
 3d2:	c3                   	ret
 3d3:	90                   	nop
    x = -xx;
 3d4:	f7 da                	neg    %edx
 3d6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3d9:	eb 98                	jmp    373 <printint+0x23>
 3db:	90                   	nop

000003dc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	57                   	push   %edi
 3e0:	56                   	push   %esi
 3e1:	53                   	push   %ebx
 3e2:	83 ec 2c             	sub    $0x2c,%esp
 3e5:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3eb:	8a 03                	mov    (%ebx),%al
 3ed:	84 c0                	test   %al,%al
 3ef:	74 2a                	je     41b <printf+0x3f>
 3f1:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3f2:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3f5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3f8:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3fb:	83 fa 25             	cmp    $0x25,%edx
 3fe:	74 24                	je     424 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 400:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 403:	50                   	push   %eax
 404:	6a 01                	push   $0x1
 406:	8d 45 e7             	lea    -0x19(%ebp),%eax
 409:	50                   	push   %eax
 40a:	56                   	push   %esi
 40b:	e8 b7 fe ff ff       	call   2c7 <write>
  for(i = 0; fmt[i]; i++){
 410:	43                   	inc    %ebx
 411:	8a 43 ff             	mov    -0x1(%ebx),%al
 414:	83 c4 10             	add    $0x10,%esp
 417:	84 c0                	test   %al,%al
 419:	75 dd                	jne    3f8 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 41b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5f                   	pop    %edi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret
 423:	90                   	nop
  for(i = 0; fmt[i]; i++){
 424:	8a 13                	mov    (%ebx),%dl
 426:	84 d2                	test   %dl,%dl
 428:	74 f1                	je     41b <printf+0x3f>
    c = fmt[i] & 0xff;
 42a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 42d:	80 fa 25             	cmp    $0x25,%dl
 430:	0f 84 fe 00 00 00    	je     534 <printf+0x158>
 436:	83 e8 63             	sub    $0x63,%eax
 439:	83 f8 15             	cmp    $0x15,%eax
 43c:	77 0a                	ja     448 <printf+0x6c>
 43e:	ff 24 85 14 07 00 00 	jmp    *0x714(,%eax,4)
 445:	8d 76 00             	lea    0x0(%esi),%esi
 448:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 44b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 44f:	50                   	push   %eax
 450:	6a 01                	push   $0x1
 452:	8d 7d e7             	lea    -0x19(%ebp),%edi
 455:	57                   	push   %edi
 456:	56                   	push   %esi
 457:	e8 6b fe ff ff       	call   2c7 <write>
        putc(fd, c);
 45c:	8a 55 d0             	mov    -0x30(%ebp),%dl
 45f:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 462:	83 c4 0c             	add    $0xc,%esp
 465:	6a 01                	push   $0x1
 467:	57                   	push   %edi
 468:	56                   	push   %esi
 469:	e8 59 fe ff ff       	call   2c7 <write>
  for(i = 0; fmt[i]; i++){
 46e:	83 c3 02             	add    $0x2,%ebx
 471:	8a 43 ff             	mov    -0x1(%ebx),%al
 474:	83 c4 10             	add    $0x10,%esp
 477:	84 c0                	test   %al,%al
 479:	0f 85 79 ff ff ff    	jne    3f8 <printf+0x1c>
}
 47f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 482:	5b                   	pop    %ebx
 483:	5e                   	pop    %esi
 484:	5f                   	pop    %edi
 485:	5d                   	pop    %ebp
 486:	c3                   	ret
 487:	90                   	nop
        printint(fd, *ap, 16, 0);
 488:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 48b:	8b 17                	mov    (%edi),%edx
 48d:	83 ec 0c             	sub    $0xc,%esp
 490:	6a 00                	push   $0x0
 492:	b9 10 00 00 00       	mov    $0x10,%ecx
 497:	89 f0                	mov    %esi,%eax
 499:	e8 b2 fe ff ff       	call   350 <printint>
        ap++;
 49e:	83 c7 04             	add    $0x4,%edi
 4a1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4a4:	eb c8                	jmp    46e <printf+0x92>
 4a6:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4a8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4ab:	8b 01                	mov    (%ecx),%eax
        ap++;
 4ad:	83 c1 04             	add    $0x4,%ecx
 4b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4b3:	85 c0                	test   %eax,%eax
 4b5:	0f 84 89 00 00 00    	je     544 <printf+0x168>
        while(*s != 0){
 4bb:	8a 10                	mov    (%eax),%dl
 4bd:	84 d2                	test   %dl,%dl
 4bf:	74 29                	je     4ea <printf+0x10e>
 4c1:	89 c7                	mov    %eax,%edi
 4c3:	88 d0                	mov    %dl,%al
 4c5:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4c8:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4cb:	89 fb                	mov    %edi,%ebx
 4cd:	89 cf                	mov    %ecx,%edi
 4cf:	90                   	nop
          putc(fd, *s);
 4d0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4d3:	50                   	push   %eax
 4d4:	6a 01                	push   $0x1
 4d6:	57                   	push   %edi
 4d7:	56                   	push   %esi
 4d8:	e8 ea fd ff ff       	call   2c7 <write>
          s++;
 4dd:	43                   	inc    %ebx
        while(*s != 0){
 4de:	8a 03                	mov    (%ebx),%al
 4e0:	83 c4 10             	add    $0x10,%esp
 4e3:	84 c0                	test   %al,%al
 4e5:	75 e9                	jne    4d0 <printf+0xf4>
 4e7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4ea:	83 c3 02             	add    $0x2,%ebx
 4ed:	8a 43 ff             	mov    -0x1(%ebx),%al
 4f0:	84 c0                	test   %al,%al
 4f2:	0f 85 00 ff ff ff    	jne    3f8 <printf+0x1c>
 4f8:	e9 1e ff ff ff       	jmp    41b <printf+0x3f>
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 500:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 503:	8b 17                	mov    (%edi),%edx
 505:	83 ec 0c             	sub    $0xc,%esp
 508:	6a 01                	push   $0x1
 50a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 50f:	eb 86                	jmp    497 <printf+0xbb>
 511:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 514:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 517:	8b 00                	mov    (%eax),%eax
 519:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 51c:	51                   	push   %ecx
 51d:	6a 01                	push   $0x1
 51f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 522:	57                   	push   %edi
 523:	56                   	push   %esi
 524:	e8 9e fd ff ff       	call   2c7 <write>
        ap++;
 529:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 52d:	e9 3c ff ff ff       	jmp    46e <printf+0x92>
 532:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 534:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 537:	52                   	push   %edx
 538:	6a 01                	push   $0x1
 53a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 53d:	e9 25 ff ff ff       	jmp    467 <printf+0x8b>
 542:	66 90                	xchg   %ax,%ax
          s = "(null)";
 544:	bf 0c 07 00 00       	mov    $0x70c,%edi
 549:	b0 28                	mov    $0x28,%al
 54b:	e9 75 ff ff ff       	jmp    4c5 <printf+0xe9>

00000550 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 559:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55c:	a1 88 07 00 00       	mov    0x788,%eax
 561:	8d 76 00             	lea    0x0(%esi),%esi
 564:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 566:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 568:	39 ca                	cmp    %ecx,%edx
 56a:	73 2c                	jae    598 <free+0x48>
 56c:	39 c1                	cmp    %eax,%ecx
 56e:	72 04                	jb     574 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 570:	39 c2                	cmp    %eax,%edx
 572:	72 f0                	jb     564 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 574:	8b 73 fc             	mov    -0x4(%ebx),%esi
 577:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57a:	39 f8                	cmp    %edi,%eax
 57c:	74 2c                	je     5aa <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 57e:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 581:	8b 42 04             	mov    0x4(%edx),%eax
 584:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 587:	39 f1                	cmp    %esi,%ecx
 589:	74 36                	je     5c1 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 58b:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 58d:	89 15 88 07 00 00    	mov    %edx,0x788
}
 593:	5b                   	pop    %ebx
 594:	5e                   	pop    %esi
 595:	5f                   	pop    %edi
 596:	5d                   	pop    %ebp
 597:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 598:	39 c2                	cmp    %eax,%edx
 59a:	72 c8                	jb     564 <free+0x14>
 59c:	39 c1                	cmp    %eax,%ecx
 59e:	73 c4                	jae    564 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a6:	39 f8                	cmp    %edi,%eax
 5a8:	75 d4                	jne    57e <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5aa:	03 70 04             	add    0x4(%eax),%esi
 5ad:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b0:	8b 02                	mov    (%edx),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b7:	8b 42 04             	mov    0x4(%edx),%eax
 5ba:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5bd:	39 f1                	cmp    %esi,%ecx
 5bf:	75 ca                	jne    58b <free+0x3b>
    p->s.size += bp->s.size;
 5c1:	03 43 fc             	add    -0x4(%ebx),%eax
 5c4:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5c7:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5ca:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5cc:	89 15 88 07 00 00    	mov    %edx,0x788
}
 5d2:	5b                   	pop    %ebx
 5d3:	5e                   	pop    %esi
 5d4:	5f                   	pop    %edi
 5d5:	5d                   	pop    %ebp
 5d6:	c3                   	ret
 5d7:	90                   	nop

000005d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	57                   	push   %edi
 5dc:	56                   	push   %esi
 5dd:	53                   	push   %ebx
 5de:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	8d 78 07             	lea    0x7(%eax),%edi
 5e7:	c1 ef 03             	shr    $0x3,%edi
 5ea:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5eb:	8b 15 88 07 00 00    	mov    0x788,%edx
 5f1:	85 d2                	test   %edx,%edx
 5f3:	0f 84 93 00 00 00    	je     68c <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5fb:	8b 48 04             	mov    0x4(%eax),%ecx
 5fe:	39 f9                	cmp    %edi,%ecx
 600:	73 62                	jae    664 <malloc+0x8c>
  if(nu < 4096)
 602:	89 fb                	mov    %edi,%ebx
 604:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 60a:	72 78                	jb     684 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 60c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 613:	eb 0e                	jmp    623 <malloc+0x4b>
 615:	8d 76 00             	lea    0x0(%esi),%esi
 618:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 61c:	8b 48 04             	mov    0x4(%eax),%ecx
 61f:	39 f9                	cmp    %edi,%ecx
 621:	73 41                	jae    664 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 623:	39 05 88 07 00 00    	cmp    %eax,0x788
 629:	75 ed                	jne    618 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 62b:	83 ec 0c             	sub    $0xc,%esp
 62e:	56                   	push   %esi
 62f:	e8 fb fc ff ff       	call   32f <sbrk>
  if(p == (char*)-1)
 634:	83 c4 10             	add    $0x10,%esp
 637:	83 f8 ff             	cmp    $0xffffffff,%eax
 63a:	74 1c                	je     658 <malloc+0x80>
  hp->s.size = nu;
 63c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 63f:	83 ec 0c             	sub    $0xc,%esp
 642:	83 c0 08             	add    $0x8,%eax
 645:	50                   	push   %eax
 646:	e8 05 ff ff ff       	call   550 <free>
  return freep;
 64b:	8b 15 88 07 00 00    	mov    0x788,%edx
      if((p = morecore(nunits)) == 0)
 651:	83 c4 10             	add    $0x10,%esp
 654:	85 d2                	test   %edx,%edx
 656:	75 c2                	jne    61a <malloc+0x42>
        return 0;
 658:	31 c0                	xor    %eax,%eax
  }
}
 65a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65d:	5b                   	pop    %ebx
 65e:	5e                   	pop    %esi
 65f:	5f                   	pop    %edi
 660:	5d                   	pop    %ebp
 661:	c3                   	ret
 662:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 664:	39 cf                	cmp    %ecx,%edi
 666:	74 4c                	je     6b4 <malloc+0xdc>
        p->s.size -= nunits;
 668:	29 f9                	sub    %edi,%ecx
 66a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 66d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 670:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 673:	89 15 88 07 00 00    	mov    %edx,0x788
      return (void*)(p + 1);
 679:	83 c0 08             	add    $0x8,%eax
}
 67c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67f:	5b                   	pop    %ebx
 680:	5e                   	pop    %esi
 681:	5f                   	pop    %edi
 682:	5d                   	pop    %ebp
 683:	c3                   	ret
  if(nu < 4096)
 684:	bb 00 10 00 00       	mov    $0x1000,%ebx
 689:	eb 81                	jmp    60c <malloc+0x34>
 68b:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 68c:	c7 05 88 07 00 00 8c 	movl   $0x78c,0x788
 693:	07 00 00 
 696:	c7 05 8c 07 00 00 8c 	movl   $0x78c,0x78c
 69d:	07 00 00 
    base.s.size = 0;
 6a0:	c7 05 90 07 00 00 00 	movl   $0x0,0x790
 6a7:	00 00 00 
 6aa:	b8 8c 07 00 00       	mov    $0x78c,%eax
 6af:	e9 4e ff ff ff       	jmp    602 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6b4:	8b 08                	mov    (%eax),%ecx
 6b6:	89 0a                	mov    %ecx,(%edx)
 6b8:	eb b9                	jmp    673 <malloc+0x9b>
