
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 26                	jle    44 <main+0x44>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	90                   	nop
    kill(atoi(argv[i]));
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 34 9f             	push   (%edi,%ebx,4)
  2a:	e8 8d 01 00 00       	call   1bc <atoi>
  2f:	89 04 24             	mov    %eax,(%esp)
  32:	e8 14 02 00 00       	call   24b <kill>
  for(i=1; i<argc; i++)
  37:	43                   	inc    %ebx
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 de                	cmp    %ebx,%esi
  3d:	75 e5                	jne    24 <main+0x24>
  exit();
  3f:	e8 d7 01 00 00       	call   21b <exit>
    printf(2, "usage: kill pid...\n");
  44:	50                   	push   %eax
  45:	50                   	push   %eax
  46:	68 30 06 00 00       	push   $0x630
  4b:	6a 02                	push   $0x2
  4d:	e8 fe 02 00 00       	call   350 <printf>
    exit();
  52:	e8 c4 01 00 00       	call   21b <exit>
  57:	90                   	nop

00000058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	53                   	push   %ebx
  5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	31 c0                	xor    %eax,%eax
  64:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  67:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6a:	40                   	inc    %eax
  6b:	84 d2                	test   %dl,%dl
  6d:	75 f5                	jne    64 <strcpy+0xc>
    ;
  return os;
}
  6f:	89 c8                	mov    %ecx,%eax
  71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  74:	c9                   	leave
  75:	c3                   	ret
  76:	66 90                	xchg   %ax,%ax

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	53                   	push   %ebx
  7c:	8b 55 08             	mov    0x8(%ebp),%edx
  7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  82:	0f b6 02             	movzbl (%edx),%eax
  85:	84 c0                	test   %al,%al
  87:	75 10                	jne    99 <strcmp+0x21>
  89:	eb 2a                	jmp    b5 <strcmp+0x3d>
  8b:	90                   	nop
    p++, q++;
  8c:	42                   	inc    %edx
  8d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  90:	0f b6 02             	movzbl (%edx),%eax
  93:	84 c0                	test   %al,%al
  95:	74 11                	je     a8 <strcmp+0x30>
  97:	89 cb                	mov    %ecx,%ebx
  99:	0f b6 0b             	movzbl (%ebx),%ecx
  9c:	38 c1                	cmp    %al,%cl
  9e:	74 ec                	je     8c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a0:	29 c8                	sub    %ecx,%eax
}
  a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a5:	c9                   	leave
  a6:	c3                   	ret
  a7:	90                   	nop
  return (uchar)*p - (uchar)*q;
  a8:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  ac:	31 c0                	xor    %eax,%eax
  ae:	29 c8                	sub    %ecx,%eax
}
  b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b3:	c9                   	leave
  b4:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  b5:	0f b6 0b             	movzbl (%ebx),%ecx
  b8:	31 c0                	xor    %eax,%eax
  ba:	eb e4                	jmp    a0 <strcmp+0x28>

000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c2:	80 3a 00             	cmpb   $0x0,(%edx)
  c5:	74 15                	je     dc <strlen+0x20>
  c7:	31 c0                	xor    %eax,%eax
  c9:	8d 76 00             	lea    0x0(%esi),%esi
  cc:	40                   	inc    %eax
  cd:	89 c1                	mov    %eax,%ecx
  cf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d3:	75 f7                	jne    cc <strlen+0x10>
    ;
  return n;
}
  d5:	89 c8                	mov    %ecx,%eax
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret
  d9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  dc:	31 c9                	xor    %ecx,%ecx
}
  de:	89 c8                	mov    %ecx,%eax
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret
  e2:	66 90                	xchg   %ax,%ax

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	fc                   	cld
  f2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  fa:	c9                   	leave
  fb:	c3                   	ret

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 105:	8a 10                	mov    (%eax),%dl
 107:	84 d2                	test   %dl,%dl
 109:	75 0c                	jne    117 <strchr+0x1b>
 10b:	eb 13                	jmp    120 <strchr+0x24>
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	40                   	inc    %eax
 111:	8a 10                	mov    (%eax),%dl
 113:	84 d2                	test   %dl,%dl
 115:	74 09                	je     120 <strchr+0x24>
    if(*s == c)
 117:	38 d1                	cmp    %dl,%cl
 119:	75 f5                	jne    110 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 120:	31 c0                	xor    %eax,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret

00000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	57                   	push   %edi
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
 12a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 12f:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 132:	eb 24                	jmp    158 <gets+0x34>
    cc = read(0, &c, 1);
 134:	50                   	push   %eax
 135:	6a 01                	push   $0x1
 137:	56                   	push   %esi
 138:	6a 00                	push   $0x0
 13a:	e8 f4 00 00 00       	call   233 <read>
    if(cc < 1)
 13f:	83 c4 10             	add    $0x10,%esp
 142:	85 c0                	test   %eax,%eax
 144:	7e 1a                	jle    160 <gets+0x3c>
      break;
    buf[i++] = c;
 146:	8a 45 e7             	mov    -0x19(%ebp),%al
 149:	8b 55 08             	mov    0x8(%ebp),%edx
 14c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 150:	3c 0a                	cmp    $0xa,%al
 152:	74 0e                	je     162 <gets+0x3e>
 154:	3c 0d                	cmp    $0xd,%al
 156:	74 0a                	je     162 <gets+0x3e>
  for(i=0; i+1 < max; ){
 158:	89 df                	mov    %ebx,%edi
 15a:	43                   	inc    %ebx
 15b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15e:	7c d4                	jl     134 <gets+0x10>
 160:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 169:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16c:	5b                   	pop    %ebx
 16d:	5e                   	pop    %esi
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret
 171:	8d 76 00             	lea    0x0(%esi),%esi

00000174 <stat>:

int
stat(const char *n, struct stat *st)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	56                   	push   %esi
 178:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 179:	83 ec 08             	sub    $0x8,%esp
 17c:	6a 00                	push   $0x0
 17e:	ff 75 08             	push   0x8(%ebp)
 181:	e8 d5 00 00 00       	call   25b <open>
  if(fd < 0)
 186:	83 c4 10             	add    $0x10,%esp
 189:	85 c0                	test   %eax,%eax
 18b:	78 27                	js     1b4 <stat+0x40>
 18d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18f:	83 ec 08             	sub    $0x8,%esp
 192:	ff 75 0c             	push   0xc(%ebp)
 195:	50                   	push   %eax
 196:	e8 d8 00 00 00       	call   273 <fstat>
 19b:	89 c6                	mov    %eax,%esi
  close(fd);
 19d:	89 1c 24             	mov    %ebx,(%esp)
 1a0:	e8 9e 00 00 00       	call   243 <close>
  return r;
 1a5:	83 c4 10             	add    $0x10,%esp
}
 1a8:	89 f0                	mov    %esi,%eax
 1aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ad:	5b                   	pop    %ebx
 1ae:	5e                   	pop    %esi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret
 1b1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1b4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b9:	eb ed                	jmp    1a8 <stat+0x34>
 1bb:	90                   	nop

000001bc <atoi>:

int
atoi(const char *s)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	53                   	push   %ebx
 1c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c3:	0f be 01             	movsbl (%ecx),%eax
 1c6:	8d 50 d0             	lea    -0x30(%eax),%edx
 1c9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1cc:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d1:	77 16                	ja     1e9 <atoi+0x2d>
 1d3:	90                   	nop
    n = n*10 + *s++ - '0';
 1d4:	41                   	inc    %ecx
 1d5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1d8:	01 d2                	add    %edx,%edx
 1da:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1de:	0f be 01             	movsbl (%ecx),%eax
 1e1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1e4:	80 fb 09             	cmp    $0x9,%bl
 1e7:	76 eb                	jbe    1d4 <atoi+0x18>
  return n;
}
 1e9:	89 d0                	mov    %edx,%eax
 1eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ee:	c9                   	leave
 1ef:	c3                   	ret

000001f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	8b 55 08             	mov    0x8(%ebp),%edx
 1f8:	8b 75 0c             	mov    0xc(%ebp),%esi
 1fb:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1fe:	85 c0                	test   %eax,%eax
 200:	7e 0b                	jle    20d <memmove+0x1d>
 202:	01 d0                	add    %edx,%eax
  dst = vdst;
 204:	89 d7                	mov    %edx,%edi
 206:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 208:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 209:	39 f8                	cmp    %edi,%eax
 20b:	75 fb                	jne    208 <memmove+0x18>
  return vdst;
}
 20d:	89 d0                	mov    %edx,%eax
 20f:	5e                   	pop    %esi
 210:	5f                   	pop    %edi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret

00000213 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 213:	b8 01 00 00 00       	mov    $0x1,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret

0000021b <exit>:
SYSCALL(exit)
 21b:	b8 02 00 00 00       	mov    $0x2,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret

00000223 <wait>:
SYSCALL(wait)
 223:	b8 03 00 00 00       	mov    $0x3,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret

0000022b <pipe>:
SYSCALL(pipe)
 22b:	b8 04 00 00 00       	mov    $0x4,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret

00000233 <read>:
SYSCALL(read)
 233:	b8 05 00 00 00       	mov    $0x5,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret

0000023b <write>:
SYSCALL(write)
 23b:	b8 10 00 00 00       	mov    $0x10,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret

00000243 <close>:
SYSCALL(close)
 243:	b8 15 00 00 00       	mov    $0x15,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret

0000024b <kill>:
SYSCALL(kill)
 24b:	b8 06 00 00 00       	mov    $0x6,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret

00000253 <exec>:
SYSCALL(exec)
 253:	b8 07 00 00 00       	mov    $0x7,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret

0000025b <open>:
SYSCALL(open)
 25b:	b8 0f 00 00 00       	mov    $0xf,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret

00000263 <mknod>:
SYSCALL(mknod)
 263:	b8 11 00 00 00       	mov    $0x11,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <unlink>:
SYSCALL(unlink)
 26b:	b8 12 00 00 00       	mov    $0x12,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <fstat>:
SYSCALL(fstat)
 273:	b8 08 00 00 00       	mov    $0x8,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <link>:
SYSCALL(link)
 27b:	b8 13 00 00 00       	mov    $0x13,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <mkdir>:
SYSCALL(mkdir)
 283:	b8 14 00 00 00       	mov    $0x14,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <chdir>:
SYSCALL(chdir)
 28b:	b8 09 00 00 00       	mov    $0x9,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <dup>:
SYSCALL(dup)
 293:	b8 0a 00 00 00       	mov    $0xa,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <getpid>:
SYSCALL(getpid)
 29b:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <sbrk>:
SYSCALL(sbrk)
 2a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <sleep>:
SYSCALL(sleep)
 2ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <uptime>:
SYSCALL(uptime)
 2b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <signal>:
SYSCALL(signal)
 2bb:	b8 16 00 00 00       	mov    $0x16,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret
 2c3:	90                   	nop

000002c4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	56                   	push   %esi
 2c9:	53                   	push   %ebx
 2ca:	83 ec 3c             	sub    $0x3c,%esp
 2cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2d0:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d5:	85 c9                	test   %ecx,%ecx
 2d7:	74 04                	je     2dd <printint+0x19>
 2d9:	85 d2                	test   %edx,%edx
 2db:	78 6b                	js     348 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2dd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2e0:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2e7:	31 c9                	xor    %ecx,%ecx
 2e9:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2ef:	31 d2                	xor    %edx,%edx
 2f1:	f7 f3                	div    %ebx
 2f3:	89 cf                	mov    %ecx,%edi
 2f5:	8d 49 01             	lea    0x1(%ecx),%ecx
 2f8:	8a 92 a4 06 00 00    	mov    0x6a4(%edx),%dl
 2fe:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 302:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 305:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 308:	39 da                	cmp    %ebx,%edx
 30a:	73 e0                	jae    2ec <printint+0x28>
  if(neg)
 30c:	8b 55 08             	mov    0x8(%ebp),%edx
 30f:	85 d2                	test   %edx,%edx
 311:	74 07                	je     31a <printint+0x56>
    buf[i++] = '-';
 313:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 318:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 31a:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 31d:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 321:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 324:	8a 07                	mov    (%edi),%al
 326:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 329:	50                   	push   %eax
 32a:	6a 01                	push   $0x1
 32c:	56                   	push   %esi
 32d:	ff 75 c0             	push   -0x40(%ebp)
 330:	e8 06 ff ff ff       	call   23b <write>
  while(--i >= 0)
 335:	89 f8                	mov    %edi,%eax
 337:	4f                   	dec    %edi
 338:	83 c4 10             	add    $0x10,%esp
 33b:	39 d8                	cmp    %ebx,%eax
 33d:	75 e5                	jne    324 <printint+0x60>
}
 33f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 342:	5b                   	pop    %ebx
 343:	5e                   	pop    %esi
 344:	5f                   	pop    %edi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret
 347:	90                   	nop
    x = -xx;
 348:	f7 da                	neg    %edx
 34a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 34d:	eb 98                	jmp    2e7 <printint+0x23>
 34f:	90                   	nop

00000350 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
 356:	83 ec 2c             	sub    $0x2c,%esp
 359:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 35c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 35f:	8a 03                	mov    (%ebx),%al
 361:	84 c0                	test   %al,%al
 363:	74 2a                	je     38f <printf+0x3f>
 365:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 366:	8d 4d 10             	lea    0x10(%ebp),%ecx
 369:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 36c:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 36f:	83 fa 25             	cmp    $0x25,%edx
 372:	74 24                	je     398 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 374:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 377:	50                   	push   %eax
 378:	6a 01                	push   $0x1
 37a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 37d:	50                   	push   %eax
 37e:	56                   	push   %esi
 37f:	e8 b7 fe ff ff       	call   23b <write>
  for(i = 0; fmt[i]; i++){
 384:	43                   	inc    %ebx
 385:	8a 43 ff             	mov    -0x1(%ebx),%al
 388:	83 c4 10             	add    $0x10,%esp
 38b:	84 c0                	test   %al,%al
 38d:	75 dd                	jne    36c <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 38f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 392:	5b                   	pop    %ebx
 393:	5e                   	pop    %esi
 394:	5f                   	pop    %edi
 395:	5d                   	pop    %ebp
 396:	c3                   	ret
 397:	90                   	nop
  for(i = 0; fmt[i]; i++){
 398:	8a 13                	mov    (%ebx),%dl
 39a:	84 d2                	test   %dl,%dl
 39c:	74 f1                	je     38f <printf+0x3f>
    c = fmt[i] & 0xff;
 39e:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3a1:	80 fa 25             	cmp    $0x25,%dl
 3a4:	0f 84 fe 00 00 00    	je     4a8 <printf+0x158>
 3aa:	83 e8 63             	sub    $0x63,%eax
 3ad:	83 f8 15             	cmp    $0x15,%eax
 3b0:	77 0a                	ja     3bc <printf+0x6c>
 3b2:	ff 24 85 4c 06 00 00 	jmp    *0x64c(,%eax,4)
 3b9:	8d 76 00             	lea    0x0(%esi),%esi
 3bc:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3c3:	50                   	push   %eax
 3c4:	6a 01                	push   $0x1
 3c6:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3c9:	57                   	push   %edi
 3ca:	56                   	push   %esi
 3cb:	e8 6b fe ff ff       	call   23b <write>
        putc(fd, c);
 3d0:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3d3:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3d6:	83 c4 0c             	add    $0xc,%esp
 3d9:	6a 01                	push   $0x1
 3db:	57                   	push   %edi
 3dc:	56                   	push   %esi
 3dd:	e8 59 fe ff ff       	call   23b <write>
  for(i = 0; fmt[i]; i++){
 3e2:	83 c3 02             	add    $0x2,%ebx
 3e5:	8a 43 ff             	mov    -0x1(%ebx),%al
 3e8:	83 c4 10             	add    $0x10,%esp
 3eb:	84 c0                	test   %al,%al
 3ed:	0f 85 79 ff ff ff    	jne    36c <printf+0x1c>
}
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret
 3fb:	90                   	nop
        printint(fd, *ap, 16, 0);
 3fc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3ff:	8b 17                	mov    (%edi),%edx
 401:	83 ec 0c             	sub    $0xc,%esp
 404:	6a 00                	push   $0x0
 406:	b9 10 00 00 00       	mov    $0x10,%ecx
 40b:	89 f0                	mov    %esi,%eax
 40d:	e8 b2 fe ff ff       	call   2c4 <printint>
        ap++;
 412:	83 c7 04             	add    $0x4,%edi
 415:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 418:	eb c8                	jmp    3e2 <printf+0x92>
 41a:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 41c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 41f:	8b 01                	mov    (%ecx),%eax
        ap++;
 421:	83 c1 04             	add    $0x4,%ecx
 424:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 427:	85 c0                	test   %eax,%eax
 429:	0f 84 89 00 00 00    	je     4b8 <printf+0x168>
        while(*s != 0){
 42f:	8a 10                	mov    (%eax),%dl
 431:	84 d2                	test   %dl,%dl
 433:	74 29                	je     45e <printf+0x10e>
 435:	89 c7                	mov    %eax,%edi
 437:	88 d0                	mov    %dl,%al
 439:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 43c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 43f:	89 fb                	mov    %edi,%ebx
 441:	89 cf                	mov    %ecx,%edi
 443:	90                   	nop
          putc(fd, *s);
 444:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 447:	50                   	push   %eax
 448:	6a 01                	push   $0x1
 44a:	57                   	push   %edi
 44b:	56                   	push   %esi
 44c:	e8 ea fd ff ff       	call   23b <write>
          s++;
 451:	43                   	inc    %ebx
        while(*s != 0){
 452:	8a 03                	mov    (%ebx),%al
 454:	83 c4 10             	add    $0x10,%esp
 457:	84 c0                	test   %al,%al
 459:	75 e9                	jne    444 <printf+0xf4>
 45b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 45e:	83 c3 02             	add    $0x2,%ebx
 461:	8a 43 ff             	mov    -0x1(%ebx),%al
 464:	84 c0                	test   %al,%al
 466:	0f 85 00 ff ff ff    	jne    36c <printf+0x1c>
 46c:	e9 1e ff ff ff       	jmp    38f <printf+0x3f>
 471:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 474:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 477:	8b 17                	mov    (%edi),%edx
 479:	83 ec 0c             	sub    $0xc,%esp
 47c:	6a 01                	push   $0x1
 47e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 483:	eb 86                	jmp    40b <printf+0xbb>
 485:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 488:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 48b:	8b 00                	mov    (%eax),%eax
 48d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 490:	51                   	push   %ecx
 491:	6a 01                	push   $0x1
 493:	8d 7d e7             	lea    -0x19(%ebp),%edi
 496:	57                   	push   %edi
 497:	56                   	push   %esi
 498:	e8 9e fd ff ff       	call   23b <write>
        ap++;
 49d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4a1:	e9 3c ff ff ff       	jmp    3e2 <printf+0x92>
 4a6:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4a8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4ab:	52                   	push   %edx
 4ac:	6a 01                	push   $0x1
 4ae:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b1:	e9 25 ff ff ff       	jmp    3db <printf+0x8b>
 4b6:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4b8:	bf 44 06 00 00       	mov    $0x644,%edi
 4bd:	b0 28                	mov    $0x28,%al
 4bf:	e9 75 ff ff ff       	jmp    439 <printf+0xe9>

000004c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	57                   	push   %edi
 4c8:	56                   	push   %esi
 4c9:	53                   	push   %ebx
 4ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4cd:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d0:	a1 b8 06 00 00       	mov    0x6b8,%eax
 4d5:	8d 76 00             	lea    0x0(%esi),%esi
 4d8:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4da:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4dc:	39 ca                	cmp    %ecx,%edx
 4de:	73 2c                	jae    50c <free+0x48>
 4e0:	39 c1                	cmp    %eax,%ecx
 4e2:	72 04                	jb     4e8 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e4:	39 c2                	cmp    %eax,%edx
 4e6:	72 f0                	jb     4d8 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ee:	39 f8                	cmp    %edi,%eax
 4f0:	74 2c                	je     51e <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4f2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4f5:	8b 42 04             	mov    0x4(%edx),%eax
 4f8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4fb:	39 f1                	cmp    %esi,%ecx
 4fd:	74 36                	je     535 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 4ff:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 501:	89 15 b8 06 00 00    	mov    %edx,0x6b8
}
 507:	5b                   	pop    %ebx
 508:	5e                   	pop    %esi
 509:	5f                   	pop    %edi
 50a:	5d                   	pop    %ebp
 50b:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 50c:	39 c2                	cmp    %eax,%edx
 50e:	72 c8                	jb     4d8 <free+0x14>
 510:	39 c1                	cmp    %eax,%ecx
 512:	73 c4                	jae    4d8 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 514:	8b 73 fc             	mov    -0x4(%ebx),%esi
 517:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 51a:	39 f8                	cmp    %edi,%eax
 51c:	75 d4                	jne    4f2 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 51e:	03 70 04             	add    0x4(%eax),%esi
 521:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 524:	8b 02                	mov    (%edx),%eax
 526:	8b 00                	mov    (%eax),%eax
 528:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 52b:	8b 42 04             	mov    0x4(%edx),%eax
 52e:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 531:	39 f1                	cmp    %esi,%ecx
 533:	75 ca                	jne    4ff <free+0x3b>
    p->s.size += bp->s.size;
 535:	03 43 fc             	add    -0x4(%ebx),%eax
 538:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 53b:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 53e:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 540:	89 15 b8 06 00 00    	mov    %edx,0x6b8
}
 546:	5b                   	pop    %ebx
 547:	5e                   	pop    %esi
 548:	5f                   	pop    %edi
 549:	5d                   	pop    %ebp
 54a:	c3                   	ret
 54b:	90                   	nop

0000054c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	57                   	push   %edi
 550:	56                   	push   %esi
 551:	53                   	push   %ebx
 552:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	8d 78 07             	lea    0x7(%eax),%edi
 55b:	c1 ef 03             	shr    $0x3,%edi
 55e:	47                   	inc    %edi
  if((prevp = freep) == 0){
 55f:	8b 15 b8 06 00 00    	mov    0x6b8,%edx
 565:	85 d2                	test   %edx,%edx
 567:	0f 84 93 00 00 00    	je     600 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 56d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 56f:	8b 48 04             	mov    0x4(%eax),%ecx
 572:	39 f9                	cmp    %edi,%ecx
 574:	73 62                	jae    5d8 <malloc+0x8c>
  if(nu < 4096)
 576:	89 fb                	mov    %edi,%ebx
 578:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 57e:	72 78                	jb     5f8 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 580:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 587:	eb 0e                	jmp    597 <malloc+0x4b>
 589:	8d 76 00             	lea    0x0(%esi),%esi
 58c:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 58e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 590:	8b 48 04             	mov    0x4(%eax),%ecx
 593:	39 f9                	cmp    %edi,%ecx
 595:	73 41                	jae    5d8 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 597:	39 05 b8 06 00 00    	cmp    %eax,0x6b8
 59d:	75 ed                	jne    58c <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 59f:	83 ec 0c             	sub    $0xc,%esp
 5a2:	56                   	push   %esi
 5a3:	e8 fb fc ff ff       	call   2a3 <sbrk>
  if(p == (char*)-1)
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ae:	74 1c                	je     5cc <malloc+0x80>
  hp->s.size = nu;
 5b0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5b3:	83 ec 0c             	sub    $0xc,%esp
 5b6:	83 c0 08             	add    $0x8,%eax
 5b9:	50                   	push   %eax
 5ba:	e8 05 ff ff ff       	call   4c4 <free>
  return freep;
 5bf:	8b 15 b8 06 00 00    	mov    0x6b8,%edx
      if((p = morecore(nunits)) == 0)
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	85 d2                	test   %edx,%edx
 5ca:	75 c2                	jne    58e <malloc+0x42>
        return 0;
 5cc:	31 c0                	xor    %eax,%eax
  }
}
 5ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d1:	5b                   	pop    %ebx
 5d2:	5e                   	pop    %esi
 5d3:	5f                   	pop    %edi
 5d4:	5d                   	pop    %ebp
 5d5:	c3                   	ret
 5d6:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5d8:	39 cf                	cmp    %ecx,%edi
 5da:	74 4c                	je     628 <malloc+0xdc>
        p->s.size -= nunits;
 5dc:	29 f9                	sub    %edi,%ecx
 5de:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5e1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5e4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5e7:	89 15 b8 06 00 00    	mov    %edx,0x6b8
      return (void*)(p + 1);
 5ed:	83 c0 08             	add    $0x8,%eax
}
 5f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret
  if(nu < 4096)
 5f8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 5fd:	eb 81                	jmp    580 <malloc+0x34>
 5ff:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 600:	c7 05 b8 06 00 00 bc 	movl   $0x6bc,0x6b8
 607:	06 00 00 
 60a:	c7 05 bc 06 00 00 bc 	movl   $0x6bc,0x6bc
 611:	06 00 00 
    base.s.size = 0;
 614:	c7 05 c0 06 00 00 00 	movl   $0x0,0x6c0
 61b:	00 00 00 
 61e:	b8 bc 06 00 00       	mov    $0x6bc,%eax
 623:	e9 4e ff ff ff       	jmp    576 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 628:	8b 08                	mov    (%eax),%ecx
 62a:	89 0a                	mov    %ecx,(%edx)
 62c:	eb b9                	jmp    5e7 <malloc+0x9b>
