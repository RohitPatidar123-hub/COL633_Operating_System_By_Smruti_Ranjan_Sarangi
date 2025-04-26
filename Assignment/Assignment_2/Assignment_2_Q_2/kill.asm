
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
  46:	68 38 06 00 00       	push   $0x638
  4b:	6a 02                	push   $0x2
  4d:	e8 06 03 00 00       	call   358 <printf>
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

000002bb <custom_fork>:
SYSCALL(custom_fork)
 2bb:	b8 17 00 00 00       	mov    $0x17,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <scheduler_start>:
SYSCALL(scheduler_start)
 2c3:	b8 18 00 00 00       	mov    $0x18,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret
 2cb:	90                   	nop

000002cc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	57                   	push   %edi
 2d0:	56                   	push   %esi
 2d1:	53                   	push   %ebx
 2d2:	83 ec 3c             	sub    $0x3c,%esp
 2d5:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2d8:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2da:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2dd:	85 c9                	test   %ecx,%ecx
 2df:	74 04                	je     2e5 <printint+0x19>
 2e1:	85 d2                	test   %edx,%edx
 2e3:	78 6b                	js     350 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2e5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2e8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2ef:	31 c9                	xor    %ecx,%ecx
 2f1:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2f7:	31 d2                	xor    %edx,%edx
 2f9:	f7 f3                	div    %ebx
 2fb:	89 cf                	mov    %ecx,%edi
 2fd:	8d 49 01             	lea    0x1(%ecx),%ecx
 300:	8a 92 ac 06 00 00    	mov    0x6ac(%edx),%dl
 306:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 30a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 30d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 310:	39 da                	cmp    %ebx,%edx
 312:	73 e0                	jae    2f4 <printint+0x28>
  if(neg)
 314:	8b 55 08             	mov    0x8(%ebp),%edx
 317:	85 d2                	test   %edx,%edx
 319:	74 07                	je     322 <printint+0x56>
    buf[i++] = '-';
 31b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 320:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 322:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 325:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 329:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 32c:	8a 07                	mov    (%edi),%al
 32e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 331:	50                   	push   %eax
 332:	6a 01                	push   $0x1
 334:	56                   	push   %esi
 335:	ff 75 c0             	push   -0x40(%ebp)
 338:	e8 fe fe ff ff       	call   23b <write>
  while(--i >= 0)
 33d:	89 f8                	mov    %edi,%eax
 33f:	4f                   	dec    %edi
 340:	83 c4 10             	add    $0x10,%esp
 343:	39 d8                	cmp    %ebx,%eax
 345:	75 e5                	jne    32c <printint+0x60>
}
 347:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34a:	5b                   	pop    %ebx
 34b:	5e                   	pop    %esi
 34c:	5f                   	pop    %edi
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret
 34f:	90                   	nop
    x = -xx;
 350:	f7 da                	neg    %edx
 352:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 355:	eb 98                	jmp    2ef <printint+0x23>
 357:	90                   	nop

00000358 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 2c             	sub    $0x2c,%esp
 361:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 364:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 367:	8a 03                	mov    (%ebx),%al
 369:	84 c0                	test   %al,%al
 36b:	74 2a                	je     397 <printf+0x3f>
 36d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 36e:	8d 4d 10             	lea    0x10(%ebp),%ecx
 371:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 374:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 377:	83 fa 25             	cmp    $0x25,%edx
 37a:	74 24                	je     3a0 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 37c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 37f:	50                   	push   %eax
 380:	6a 01                	push   $0x1
 382:	8d 45 e7             	lea    -0x19(%ebp),%eax
 385:	50                   	push   %eax
 386:	56                   	push   %esi
 387:	e8 af fe ff ff       	call   23b <write>
  for(i = 0; fmt[i]; i++){
 38c:	43                   	inc    %ebx
 38d:	8a 43 ff             	mov    -0x1(%ebx),%al
 390:	83 c4 10             	add    $0x10,%esp
 393:	84 c0                	test   %al,%al
 395:	75 dd                	jne    374 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 397:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39a:	5b                   	pop    %ebx
 39b:	5e                   	pop    %esi
 39c:	5f                   	pop    %edi
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret
 39f:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3a0:	8a 13                	mov    (%ebx),%dl
 3a2:	84 d2                	test   %dl,%dl
 3a4:	74 f1                	je     397 <printf+0x3f>
    c = fmt[i] & 0xff;
 3a6:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3a9:	80 fa 25             	cmp    $0x25,%dl
 3ac:	0f 84 fe 00 00 00    	je     4b0 <printf+0x158>
 3b2:	83 e8 63             	sub    $0x63,%eax
 3b5:	83 f8 15             	cmp    $0x15,%eax
 3b8:	77 0a                	ja     3c4 <printf+0x6c>
 3ba:	ff 24 85 54 06 00 00 	jmp    *0x654(,%eax,4)
 3c1:	8d 76 00             	lea    0x0(%esi),%esi
 3c4:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3c7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3cb:	50                   	push   %eax
 3cc:	6a 01                	push   $0x1
 3ce:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3d1:	57                   	push   %edi
 3d2:	56                   	push   %esi
 3d3:	e8 63 fe ff ff       	call   23b <write>
        putc(fd, c);
 3d8:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3db:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3de:	83 c4 0c             	add    $0xc,%esp
 3e1:	6a 01                	push   $0x1
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	e8 51 fe ff ff       	call   23b <write>
  for(i = 0; fmt[i]; i++){
 3ea:	83 c3 02             	add    $0x2,%ebx
 3ed:	8a 43 ff             	mov    -0x1(%ebx),%al
 3f0:	83 c4 10             	add    $0x10,%esp
 3f3:	84 c0                	test   %al,%al
 3f5:	0f 85 79 ff ff ff    	jne    374 <printf+0x1c>
}
 3fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fe:	5b                   	pop    %ebx
 3ff:	5e                   	pop    %esi
 400:	5f                   	pop    %edi
 401:	5d                   	pop    %ebp
 402:	c3                   	ret
 403:	90                   	nop
        printint(fd, *ap, 16, 0);
 404:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 407:	8b 17                	mov    (%edi),%edx
 409:	83 ec 0c             	sub    $0xc,%esp
 40c:	6a 00                	push   $0x0
 40e:	b9 10 00 00 00       	mov    $0x10,%ecx
 413:	89 f0                	mov    %esi,%eax
 415:	e8 b2 fe ff ff       	call   2cc <printint>
        ap++;
 41a:	83 c7 04             	add    $0x4,%edi
 41d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 420:	eb c8                	jmp    3ea <printf+0x92>
 422:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 424:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 427:	8b 01                	mov    (%ecx),%eax
        ap++;
 429:	83 c1 04             	add    $0x4,%ecx
 42c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 42f:	85 c0                	test   %eax,%eax
 431:	0f 84 89 00 00 00    	je     4c0 <printf+0x168>
        while(*s != 0){
 437:	8a 10                	mov    (%eax),%dl
 439:	84 d2                	test   %dl,%dl
 43b:	74 29                	je     466 <printf+0x10e>
 43d:	89 c7                	mov    %eax,%edi
 43f:	88 d0                	mov    %dl,%al
 441:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 444:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 447:	89 fb                	mov    %edi,%ebx
 449:	89 cf                	mov    %ecx,%edi
 44b:	90                   	nop
          putc(fd, *s);
 44c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 44f:	50                   	push   %eax
 450:	6a 01                	push   $0x1
 452:	57                   	push   %edi
 453:	56                   	push   %esi
 454:	e8 e2 fd ff ff       	call   23b <write>
          s++;
 459:	43                   	inc    %ebx
        while(*s != 0){
 45a:	8a 03                	mov    (%ebx),%al
 45c:	83 c4 10             	add    $0x10,%esp
 45f:	84 c0                	test   %al,%al
 461:	75 e9                	jne    44c <printf+0xf4>
 463:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 466:	83 c3 02             	add    $0x2,%ebx
 469:	8a 43 ff             	mov    -0x1(%ebx),%al
 46c:	84 c0                	test   %al,%al
 46e:	0f 85 00 ff ff ff    	jne    374 <printf+0x1c>
 474:	e9 1e ff ff ff       	jmp    397 <printf+0x3f>
 479:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 47c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 47f:	8b 17                	mov    (%edi),%edx
 481:	83 ec 0c             	sub    $0xc,%esp
 484:	6a 01                	push   $0x1
 486:	b9 0a 00 00 00       	mov    $0xa,%ecx
 48b:	eb 86                	jmp    413 <printf+0xbb>
 48d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 493:	8b 00                	mov    (%eax),%eax
 495:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 498:	51                   	push   %ecx
 499:	6a 01                	push   $0x1
 49b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 49e:	57                   	push   %edi
 49f:	56                   	push   %esi
 4a0:	e8 96 fd ff ff       	call   23b <write>
        ap++;
 4a5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4a9:	e9 3c ff ff ff       	jmp    3ea <printf+0x92>
 4ae:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4b3:	52                   	push   %edx
 4b4:	6a 01                	push   $0x1
 4b6:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b9:	e9 25 ff ff ff       	jmp    3e3 <printf+0x8b>
 4be:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4c0:	bf 4c 06 00 00       	mov    $0x64c,%edi
 4c5:	b0 28                	mov    $0x28,%al
 4c7:	e9 75 ff ff ff       	jmp    441 <printf+0xe9>

000004cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	57                   	push   %edi
 4d0:	56                   	push   %esi
 4d1:	53                   	push   %ebx
 4d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d8:	a1 c0 06 00 00       	mov    0x6c0,%eax
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
 4e0:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e2:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e4:	39 ca                	cmp    %ecx,%edx
 4e6:	73 2c                	jae    514 <free+0x48>
 4e8:	39 c1                	cmp    %eax,%ecx
 4ea:	72 04                	jb     4f0 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ec:	39 c2                	cmp    %eax,%edx
 4ee:	72 f0                	jb     4e0 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f6:	39 f8                	cmp    %edi,%eax
 4f8:	74 2c                	je     526 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4fa:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4fd:	8b 42 04             	mov    0x4(%edx),%eax
 500:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 503:	39 f1                	cmp    %esi,%ecx
 505:	74 36                	je     53d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 507:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 509:	89 15 c0 06 00 00    	mov    %edx,0x6c0
}
 50f:	5b                   	pop    %ebx
 510:	5e                   	pop    %esi
 511:	5f                   	pop    %edi
 512:	5d                   	pop    %ebp
 513:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 514:	39 c2                	cmp    %eax,%edx
 516:	72 c8                	jb     4e0 <free+0x14>
 518:	39 c1                	cmp    %eax,%ecx
 51a:	73 c4                	jae    4e0 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 51c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 51f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 522:	39 f8                	cmp    %edi,%eax
 524:	75 d4                	jne    4fa <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 526:	03 70 04             	add    0x4(%eax),%esi
 529:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 52c:	8b 02                	mov    (%edx),%eax
 52e:	8b 00                	mov    (%eax),%eax
 530:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 533:	8b 42 04             	mov    0x4(%edx),%eax
 536:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 539:	39 f1                	cmp    %esi,%ecx
 53b:	75 ca                	jne    507 <free+0x3b>
    p->s.size += bp->s.size;
 53d:	03 43 fc             	add    -0x4(%ebx),%eax
 540:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 543:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 546:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 548:	89 15 c0 06 00 00    	mov    %edx,0x6c0
}
 54e:	5b                   	pop    %ebx
 54f:	5e                   	pop    %esi
 550:	5f                   	pop    %edi
 551:	5d                   	pop    %ebp
 552:	c3                   	ret
 553:	90                   	nop

00000554 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	57                   	push   %edi
 558:	56                   	push   %esi
 559:	53                   	push   %ebx
 55a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	8d 78 07             	lea    0x7(%eax),%edi
 563:	c1 ef 03             	shr    $0x3,%edi
 566:	47                   	inc    %edi
  if((prevp = freep) == 0){
 567:	8b 15 c0 06 00 00    	mov    0x6c0,%edx
 56d:	85 d2                	test   %edx,%edx
 56f:	0f 84 93 00 00 00    	je     608 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 575:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 577:	8b 48 04             	mov    0x4(%eax),%ecx
 57a:	39 f9                	cmp    %edi,%ecx
 57c:	73 62                	jae    5e0 <malloc+0x8c>
  if(nu < 4096)
 57e:	89 fb                	mov    %edi,%ebx
 580:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 586:	72 78                	jb     600 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 588:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 58f:	eb 0e                	jmp    59f <malloc+0x4b>
 591:	8d 76 00             	lea    0x0(%esi),%esi
 594:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 596:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 598:	8b 48 04             	mov    0x4(%eax),%ecx
 59b:	39 f9                	cmp    %edi,%ecx
 59d:	73 41                	jae    5e0 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 59f:	39 05 c0 06 00 00    	cmp    %eax,0x6c0
 5a5:	75 ed                	jne    594 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5a7:	83 ec 0c             	sub    $0xc,%esp
 5aa:	56                   	push   %esi
 5ab:	e8 f3 fc ff ff       	call   2a3 <sbrk>
  if(p == (char*)-1)
 5b0:	83 c4 10             	add    $0x10,%esp
 5b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5b6:	74 1c                	je     5d4 <malloc+0x80>
  hp->s.size = nu;
 5b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5bb:	83 ec 0c             	sub    $0xc,%esp
 5be:	83 c0 08             	add    $0x8,%eax
 5c1:	50                   	push   %eax
 5c2:	e8 05 ff ff ff       	call   4cc <free>
  return freep;
 5c7:	8b 15 c0 06 00 00    	mov    0x6c0,%edx
      if((p = morecore(nunits)) == 0)
 5cd:	83 c4 10             	add    $0x10,%esp
 5d0:	85 d2                	test   %edx,%edx
 5d2:	75 c2                	jne    596 <malloc+0x42>
        return 0;
 5d4:	31 c0                	xor    %eax,%eax
  }
}
 5d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d9:	5b                   	pop    %ebx
 5da:	5e                   	pop    %esi
 5db:	5f                   	pop    %edi
 5dc:	5d                   	pop    %ebp
 5dd:	c3                   	ret
 5de:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5e0:	39 cf                	cmp    %ecx,%edi
 5e2:	74 4c                	je     630 <malloc+0xdc>
        p->s.size -= nunits;
 5e4:	29 f9                	sub    %edi,%ecx
 5e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5ec:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5ef:	89 15 c0 06 00 00    	mov    %edx,0x6c0
      return (void*)(p + 1);
 5f5:	83 c0 08             	add    $0x8,%eax
}
 5f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5fb:	5b                   	pop    %ebx
 5fc:	5e                   	pop    %esi
 5fd:	5f                   	pop    %edi
 5fe:	5d                   	pop    %ebp
 5ff:	c3                   	ret
  if(nu < 4096)
 600:	bb 00 10 00 00       	mov    $0x1000,%ebx
 605:	eb 81                	jmp    588 <malloc+0x34>
 607:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 608:	c7 05 c0 06 00 00 c4 	movl   $0x6c4,0x6c0
 60f:	06 00 00 
 612:	c7 05 c4 06 00 00 c4 	movl   $0x6c4,0x6c4
 619:	06 00 00 
    base.s.size = 0;
 61c:	c7 05 c8 06 00 00 00 	movl   $0x0,0x6c8
 623:	00 00 00 
 626:	b8 c4 06 00 00       	mov    $0x6c4,%eax
 62b:	e9 4e ff ff ff       	jmp    57e <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 630:	8b 08                	mov    (%eax),%ecx
 632:	89 0a                	mov    %ecx,(%edx)
 634:	eb b9                	jmp    5ef <malloc+0x9b>
