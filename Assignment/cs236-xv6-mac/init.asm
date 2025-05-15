
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
  14:	68 b4 06 00 00       	push   $0x6b4
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
  47:	68 bc 06 00 00       	push   $0x6bc
  4c:	6a 01                	push   $0x1
  4e:	e8 81 03 00 00       	call   3d4 <printf>
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
  74:	68 fb 06 00 00       	push   $0x6fb
  79:	6a 01                	push   $0x1
  7b:	e8 54 03 00 00       	call   3d4 <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb df                	jmp    64 <main+0x64>
      printf(1, "init: fork failed\n");
  85:	53                   	push   %ebx
  86:	53                   	push   %ebx
  87:	68 cf 06 00 00       	push   $0x6cf
  8c:	6a 01                	push   $0x1
  8e:	e8 41 03 00 00       	call   3d4 <printf>
      exit();
  93:	e8 0f 02 00 00       	call   2a7 <exit>
      exec("sh", argv);
  98:	50                   	push   %eax
  99:	50                   	push   %eax
  9a:	68 78 07 00 00       	push   $0x778
  9f:	68 e2 06 00 00       	push   $0x6e2
  a4:	e8 36 02 00 00       	call   2df <exec>
      printf(1, "init: exec sh failed\n");
  a9:	5a                   	pop    %edx
  aa:	59                   	pop    %ecx
  ab:	68 e5 06 00 00       	push   $0x6e5
  b0:	6a 01                	push   $0x1
  b2:	e8 1d 03 00 00       	call   3d4 <printf>
      exit();
  b7:	e8 eb 01 00 00       	call   2a7 <exit>
    mknod("console", 1, 1);
  bc:	50                   	push   %eax
  bd:	6a 01                	push   $0x1
  bf:	6a 01                	push   $0x1
  c1:	68 b4 06 00 00       	push   $0x6b4
  c6:	e8 24 02 00 00       	call   2ef <mknod>
    open("console", O_RDWR);
  cb:	58                   	pop    %eax
  cc:	5a                   	pop    %edx
  cd:	6a 02                	push   $0x2
  cf:	68 b4 06 00 00       	push   $0x6b4
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
 347:	90                   	nop

00000348 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	56                   	push   %esi
 34d:	53                   	push   %ebx
 34e:	83 ec 3c             	sub    $0x3c,%esp
 351:	89 45 c0             	mov    %eax,-0x40(%ebp)
 354:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 356:	8b 4d 08             	mov    0x8(%ebp),%ecx
 359:	85 c9                	test   %ecx,%ecx
 35b:	74 04                	je     361 <printint+0x19>
 35d:	85 d2                	test   %edx,%edx
 35f:	78 6b                	js     3cc <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 361:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 364:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 36b:	31 c9                	xor    %ecx,%ecx
 36d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 370:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 373:	31 d2                	xor    %edx,%edx
 375:	f7 f3                	div    %ebx
 377:	89 cf                	mov    %ecx,%edi
 379:	8d 49 01             	lea    0x1(%ecx),%ecx
 37c:	8a 92 64 07 00 00    	mov    0x764(%edx),%dl
 382:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 386:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 38c:	39 da                	cmp    %ebx,%edx
 38e:	73 e0                	jae    370 <printint+0x28>
  if(neg)
 390:	8b 55 08             	mov    0x8(%ebp),%edx
 393:	85 d2                	test   %edx,%edx
 395:	74 07                	je     39e <printint+0x56>
    buf[i++] = '-';
 397:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 39c:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 39e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3a1:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3a5:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3a8:	8a 07                	mov    (%edi),%al
 3aa:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3ad:	50                   	push   %eax
 3ae:	6a 01                	push   $0x1
 3b0:	56                   	push   %esi
 3b1:	ff 75 c0             	push   -0x40(%ebp)
 3b4:	e8 0e ff ff ff       	call   2c7 <write>
  while(--i >= 0)
 3b9:	89 f8                	mov    %edi,%eax
 3bb:	4f                   	dec    %edi
 3bc:	83 c4 10             	add    $0x10,%esp
 3bf:	39 d8                	cmp    %ebx,%eax
 3c1:	75 e5                	jne    3a8 <printint+0x60>
}
 3c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c6:	5b                   	pop    %ebx
 3c7:	5e                   	pop    %esi
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret
 3cb:	90                   	nop
    x = -xx;
 3cc:	f7 da                	neg    %edx
 3ce:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3d1:	eb 98                	jmp    36b <printint+0x23>
 3d3:	90                   	nop

000003d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	57                   	push   %edi
 3d8:	56                   	push   %esi
 3d9:	53                   	push   %ebx
 3da:	83 ec 2c             	sub    $0x2c,%esp
 3dd:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3e3:	8a 03                	mov    (%ebx),%al
 3e5:	84 c0                	test   %al,%al
 3e7:	74 2a                	je     413 <printf+0x3f>
 3e9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3ea:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3ed:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3f0:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3f3:	83 fa 25             	cmp    $0x25,%edx
 3f6:	74 24                	je     41c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3f8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3fb:	50                   	push   %eax
 3fc:	6a 01                	push   $0x1
 3fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 401:	50                   	push   %eax
 402:	56                   	push   %esi
 403:	e8 bf fe ff ff       	call   2c7 <write>
  for(i = 0; fmt[i]; i++){
 408:	43                   	inc    %ebx
 409:	8a 43 ff             	mov    -0x1(%ebx),%al
 40c:	83 c4 10             	add    $0x10,%esp
 40f:	84 c0                	test   %al,%al
 411:	75 dd                	jne    3f0 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 413:	8d 65 f4             	lea    -0xc(%ebp),%esp
 416:	5b                   	pop    %ebx
 417:	5e                   	pop    %esi
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret
 41b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 41c:	8a 13                	mov    (%ebx),%dl
 41e:	84 d2                	test   %dl,%dl
 420:	74 f1                	je     413 <printf+0x3f>
    c = fmt[i] & 0xff;
 422:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 425:	80 fa 25             	cmp    $0x25,%dl
 428:	0f 84 fe 00 00 00    	je     52c <printf+0x158>
 42e:	83 e8 63             	sub    $0x63,%eax
 431:	83 f8 15             	cmp    $0x15,%eax
 434:	77 0a                	ja     440 <printf+0x6c>
 436:	ff 24 85 0c 07 00 00 	jmp    *0x70c(,%eax,4)
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 443:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 447:	50                   	push   %eax
 448:	6a 01                	push   $0x1
 44a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 44d:	57                   	push   %edi
 44e:	56                   	push   %esi
 44f:	e8 73 fe ff ff       	call   2c7 <write>
        putc(fd, c);
 454:	8a 55 d0             	mov    -0x30(%ebp),%dl
 457:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 45a:	83 c4 0c             	add    $0xc,%esp
 45d:	6a 01                	push   $0x1
 45f:	57                   	push   %edi
 460:	56                   	push   %esi
 461:	e8 61 fe ff ff       	call   2c7 <write>
  for(i = 0; fmt[i]; i++){
 466:	83 c3 02             	add    $0x2,%ebx
 469:	8a 43 ff             	mov    -0x1(%ebx),%al
 46c:	83 c4 10             	add    $0x10,%esp
 46f:	84 c0                	test   %al,%al
 471:	0f 85 79 ff ff ff    	jne    3f0 <printf+0x1c>
}
 477:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47a:	5b                   	pop    %ebx
 47b:	5e                   	pop    %esi
 47c:	5f                   	pop    %edi
 47d:	5d                   	pop    %ebp
 47e:	c3                   	ret
 47f:	90                   	nop
        printint(fd, *ap, 16, 0);
 480:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 483:	8b 17                	mov    (%edi),%edx
 485:	83 ec 0c             	sub    $0xc,%esp
 488:	6a 00                	push   $0x0
 48a:	b9 10 00 00 00       	mov    $0x10,%ecx
 48f:	89 f0                	mov    %esi,%eax
 491:	e8 b2 fe ff ff       	call   348 <printint>
        ap++;
 496:	83 c7 04             	add    $0x4,%edi
 499:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 49c:	eb c8                	jmp    466 <printf+0x92>
 49e:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4a0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4a3:	8b 01                	mov    (%ecx),%eax
        ap++;
 4a5:	83 c1 04             	add    $0x4,%ecx
 4a8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4ab:	85 c0                	test   %eax,%eax
 4ad:	0f 84 89 00 00 00    	je     53c <printf+0x168>
        while(*s != 0){
 4b3:	8a 10                	mov    (%eax),%dl
 4b5:	84 d2                	test   %dl,%dl
 4b7:	74 29                	je     4e2 <printf+0x10e>
 4b9:	89 c7                	mov    %eax,%edi
 4bb:	88 d0                	mov    %dl,%al
 4bd:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4c0:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4c3:	89 fb                	mov    %edi,%ebx
 4c5:	89 cf                	mov    %ecx,%edi
 4c7:	90                   	nop
          putc(fd, *s);
 4c8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	50                   	push   %eax
 4cc:	6a 01                	push   $0x1
 4ce:	57                   	push   %edi
 4cf:	56                   	push   %esi
 4d0:	e8 f2 fd ff ff       	call   2c7 <write>
          s++;
 4d5:	43                   	inc    %ebx
        while(*s != 0){
 4d6:	8a 03                	mov    (%ebx),%al
 4d8:	83 c4 10             	add    $0x10,%esp
 4db:	84 c0                	test   %al,%al
 4dd:	75 e9                	jne    4c8 <printf+0xf4>
 4df:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4e2:	83 c3 02             	add    $0x2,%ebx
 4e5:	8a 43 ff             	mov    -0x1(%ebx),%al
 4e8:	84 c0                	test   %al,%al
 4ea:	0f 85 00 ff ff ff    	jne    3f0 <printf+0x1c>
 4f0:	e9 1e ff ff ff       	jmp    413 <printf+0x3f>
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4f8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4fb:	8b 17                	mov    (%edi),%edx
 4fd:	83 ec 0c             	sub    $0xc,%esp
 500:	6a 01                	push   $0x1
 502:	b9 0a 00 00 00       	mov    $0xa,%ecx
 507:	eb 86                	jmp    48f <printf+0xbb>
 509:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 50c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 50f:	8b 00                	mov    (%eax),%eax
 511:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 514:	51                   	push   %ecx
 515:	6a 01                	push   $0x1
 517:	8d 7d e7             	lea    -0x19(%ebp),%edi
 51a:	57                   	push   %edi
 51b:	56                   	push   %esi
 51c:	e8 a6 fd ff ff       	call   2c7 <write>
        ap++;
 521:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 525:	e9 3c ff ff ff       	jmp    466 <printf+0x92>
 52a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 52c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 52f:	52                   	push   %edx
 530:	6a 01                	push   $0x1
 532:	8d 7d e7             	lea    -0x19(%ebp),%edi
 535:	e9 25 ff ff ff       	jmp    45f <printf+0x8b>
 53a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 53c:	bf 04 07 00 00       	mov    $0x704,%edi
 541:	b0 28                	mov    $0x28,%al
 543:	e9 75 ff ff ff       	jmp    4bd <printf+0xe9>

00000548 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 548:	55                   	push   %ebp
 549:	89 e5                	mov    %esp,%ebp
 54b:	57                   	push   %edi
 54c:	56                   	push   %esi
 54d:	53                   	push   %ebx
 54e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 551:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 554:	a1 80 07 00 00       	mov    0x780,%eax
 559:	8d 76 00             	lea    0x0(%esi),%esi
 55c:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55e:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 560:	39 ca                	cmp    %ecx,%edx
 562:	73 2c                	jae    590 <free+0x48>
 564:	39 c1                	cmp    %eax,%ecx
 566:	72 04                	jb     56c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 568:	39 c2                	cmp    %eax,%edx
 56a:	72 f0                	jb     55c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 56c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 572:	39 f8                	cmp    %edi,%eax
 574:	74 2c                	je     5a2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 576:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 579:	8b 42 04             	mov    0x4(%edx),%eax
 57c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 57f:	39 f1                	cmp    %esi,%ecx
 581:	74 36                	je     5b9 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 583:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 585:	89 15 80 07 00 00    	mov    %edx,0x780
}
 58b:	5b                   	pop    %ebx
 58c:	5e                   	pop    %esi
 58d:	5f                   	pop    %edi
 58e:	5d                   	pop    %ebp
 58f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 590:	39 c2                	cmp    %eax,%edx
 592:	72 c8                	jb     55c <free+0x14>
 594:	39 c1                	cmp    %eax,%ecx
 596:	73 c4                	jae    55c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 598:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59e:	39 f8                	cmp    %edi,%eax
 5a0:	75 d4                	jne    576 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5a2:	03 70 04             	add    0x4(%eax),%esi
 5a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a8:	8b 02                	mov    (%edx),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5af:	8b 42 04             	mov    0x4(%edx),%eax
 5b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5b5:	39 f1                	cmp    %esi,%ecx
 5b7:	75 ca                	jne    583 <free+0x3b>
    p->s.size += bp->s.size;
 5b9:	03 43 fc             	add    -0x4(%ebx),%eax
 5bc:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5bf:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5c2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5c4:	89 15 80 07 00 00    	mov    %edx,0x780
}
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5f                   	pop    %edi
 5cd:	5d                   	pop    %ebp
 5ce:	c3                   	ret
 5cf:	90                   	nop

000005d0 <malloc>:
}


void*
malloc(uint nbytes)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	8d 78 07             	lea    0x7(%eax),%edi
 5df:	c1 ef 03             	shr    $0x3,%edi
 5e2:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5e3:	8b 15 80 07 00 00    	mov    0x780,%edx
 5e9:	85 d2                	test   %edx,%edx
 5eb:	0f 84 93 00 00 00    	je     684 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5f3:	8b 48 04             	mov    0x4(%eax),%ecx
 5f6:	39 f9                	cmp    %edi,%ecx
 5f8:	73 62                	jae    65c <malloc+0x8c>
  if(nu < 4096)
 5fa:	89 fb                	mov    %edi,%ebx
 5fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 602:	72 78                	jb     67c <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 604:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 60b:	eb 0e                	jmp    61b <malloc+0x4b>
 60d:	8d 76 00             	lea    0x0(%esi),%esi
 610:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 612:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 614:	8b 48 04             	mov    0x4(%eax),%ecx
 617:	39 f9                	cmp    %edi,%ecx
 619:	73 41                	jae    65c <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 61b:	39 05 80 07 00 00    	cmp    %eax,0x780
 621:	75 ed                	jne    610 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	56                   	push   %esi
 627:	e8 03 fd ff ff       	call   32f <sbrk>
  if(p == (char*)-1)
 62c:	83 c4 10             	add    $0x10,%esp
 62f:	83 f8 ff             	cmp    $0xffffffff,%eax
 632:	74 1c                	je     650 <malloc+0x80>
  hp->s.size = nu;
 634:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 637:	83 ec 0c             	sub    $0xc,%esp
 63a:	83 c0 08             	add    $0x8,%eax
 63d:	50                   	push   %eax
 63e:	e8 05 ff ff ff       	call   548 <free>
  return freep;
 643:	8b 15 80 07 00 00    	mov    0x780,%edx
      if((p = morecore(nunits)) == 0)
 649:	83 c4 10             	add    $0x10,%esp
 64c:	85 d2                	test   %edx,%edx
 64e:	75 c2                	jne    612 <malloc+0x42>
        return 0;
 650:	31 c0                	xor    %eax,%eax
  }
}
 652:	8d 65 f4             	lea    -0xc(%ebp),%esp
 655:	5b                   	pop    %ebx
 656:	5e                   	pop    %esi
 657:	5f                   	pop    %edi
 658:	5d                   	pop    %ebp
 659:	c3                   	ret
 65a:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 65c:	39 cf                	cmp    %ecx,%edi
 65e:	74 4c                	je     6ac <malloc+0xdc>
        p->s.size -= nunits;
 660:	29 f9                	sub    %edi,%ecx
 662:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 665:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 668:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 66b:	89 15 80 07 00 00    	mov    %edx,0x780
      return (void*)(p + 1);
 671:	83 c0 08             	add    $0x8,%eax
}
 674:	8d 65 f4             	lea    -0xc(%ebp),%esp
 677:	5b                   	pop    %ebx
 678:	5e                   	pop    %esi
 679:	5f                   	pop    %edi
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret
  if(nu < 4096)
 67c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 681:	eb 81                	jmp    604 <malloc+0x34>
 683:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 684:	c7 05 80 07 00 00 84 	movl   $0x784,0x780
 68b:	07 00 00 
 68e:	c7 05 84 07 00 00 84 	movl   $0x784,0x784
 695:	07 00 00 
    base.s.size = 0;
 698:	c7 05 88 07 00 00 00 	movl   $0x0,0x788
 69f:	00 00 00 
 6a2:	b8 84 07 00 00       	mov    $0x784,%eax
 6a7:	e9 4e ff ff ff       	jmp    5fa <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6ac:	8b 08                	mov    (%eax),%ecx
 6ae:	89 0a                	mov    %ecx,(%edx)
 6b0:	eb b9                	jmp    66b <malloc+0x9b>
