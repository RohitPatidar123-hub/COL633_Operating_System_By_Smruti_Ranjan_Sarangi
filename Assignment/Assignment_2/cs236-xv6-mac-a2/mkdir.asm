
_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 3c                	jle    5a <main+0x5a>
  1e:	83 c3 04             	add    $0x4,%ebx
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bf 01 00 00 00       	mov    $0x1,%edi
  26:	66 90                	xchg   %ax,%ax
    if(mkdir(argv[i]) < 0){
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	push   (%ebx)
  2d:	e8 69 02 00 00       	call   29b <mkdir>
  32:	83 c4 10             	add    $0x10,%esp
  35:	85 c0                	test   %eax,%eax
  37:	78 0d                	js     46 <main+0x46>
  for(i = 1; i < argc; i++){
  39:	47                   	inc    %edi
  3a:	83 c3 04             	add    $0x4,%ebx
  3d:	39 fe                	cmp    %edi,%esi
  3f:	75 e7                	jne    28 <main+0x28>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  41:	e8 ed 01 00 00       	call   233 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  46:	50                   	push   %eax
  47:	ff 33                	push   (%ebx)
  49:	68 6f 06 00 00       	push   $0x66f
  4e:	6a 02                	push   $0x2
  50:	e8 23 03 00 00       	call   378 <printf>
      break;
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e7                	jmp    41 <main+0x41>
    printf(2, "Usage: mkdir files...\n");
  5a:	52                   	push   %edx
  5b:	52                   	push   %edx
  5c:	68 58 06 00 00       	push   $0x658
  61:	6a 02                	push   $0x2
  63:	e8 10 03 00 00       	call   378 <printf>
    exit();
  68:	e8 c6 01 00 00       	call   233 <exit>
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	31 c0                	xor    %eax,%eax
  7c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  7f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  82:	40                   	inc    %eax
  83:	84 d2                	test   %dl,%dl
  85:	75 f5                	jne    7c <strcpy+0xc>
    ;
  return os;
}
  87:	89 c8                	mov    %ecx,%eax
  89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8c:	c9                   	leave
  8d:	c3                   	ret
  8e:	66 90                	xchg   %ax,%ax

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 10                	jne    b1 <strcmp+0x21>
  a1:	eb 2a                	jmp    cd <strcmp+0x3d>
  a3:	90                   	nop
    p++, q++;
  a4:	42                   	inc    %edx
  a5:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  a8:	0f b6 02             	movzbl (%edx),%eax
  ab:	84 c0                	test   %al,%al
  ad:	74 11                	je     c0 <strcmp+0x30>
  af:	89 cb                	mov    %ecx,%ebx
  b1:	0f b6 0b             	movzbl (%ebx),%ecx
  b4:	38 c1                	cmp    %al,%cl
  b6:	74 ec                	je     a4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  b8:	29 c8                	sub    %ecx,%eax
}
  ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  bd:	c9                   	leave
  be:	c3                   	ret
  bf:	90                   	nop
  return (uchar)*p - (uchar)*q;
  c0:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  c4:	31 c0                	xor    %eax,%eax
  c6:	29 c8                	sub    %ecx,%eax
}
  c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cb:	c9                   	leave
  cc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  cd:	0f b6 0b             	movzbl (%ebx),%ecx
  d0:	31 c0                	xor    %eax,%eax
  d2:	eb e4                	jmp    b8 <strcmp+0x28>

000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  da:	80 3a 00             	cmpb   $0x0,(%edx)
  dd:	74 15                	je     f4 <strlen+0x20>
  df:	31 c0                	xor    %eax,%eax
  e1:	8d 76 00             	lea    0x0(%esi),%esi
  e4:	40                   	inc    %eax
  e5:	89 c1                	mov    %eax,%ecx
  e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  eb:	75 f7                	jne    e4 <strlen+0x10>
    ;
  return n;
}
  ed:	89 c8                	mov    %ecx,%eax
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret
  f1:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  f4:	31 c9                	xor    %ecx,%ecx
}
  f6:	89 c8                	mov    %ecx,%eax
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret
  fa:	66 90                	xchg   %ax,%ax

000000fc <memset>:

void*
memset(void *dst, int c, uint n)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 100:	8b 7d 08             	mov    0x8(%ebp),%edi
 103:	8b 4d 10             	mov    0x10(%ebp),%ecx
 106:	8b 45 0c             	mov    0xc(%ebp),%eax
 109:	fc                   	cld
 10a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 112:	c9                   	leave
 113:	c3                   	ret

00000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 11d:	8a 10                	mov    (%eax),%dl
 11f:	84 d2                	test   %dl,%dl
 121:	75 0c                	jne    12f <strchr+0x1b>
 123:	eb 13                	jmp    138 <strchr+0x24>
 125:	8d 76 00             	lea    0x0(%esi),%esi
 128:	40                   	inc    %eax
 129:	8a 10                	mov    (%eax),%dl
 12b:	84 d2                	test   %dl,%dl
 12d:	74 09                	je     138 <strchr+0x24>
    if(*s == c)
 12f:	38 d1                	cmp    %dl,%cl
 131:	75 f5                	jne    128 <strchr+0x14>
      return (char*)s;
  return 0;
}
 133:	5d                   	pop    %ebp
 134:	c3                   	ret
 135:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 138:	31 c0                	xor    %eax,%eax
}
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	56                   	push   %esi
 141:	53                   	push   %ebx
 142:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 145:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 147:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 14a:	eb 24                	jmp    170 <gets+0x34>
    cc = read(0, &c, 1);
 14c:	50                   	push   %eax
 14d:	6a 01                	push   $0x1
 14f:	56                   	push   %esi
 150:	6a 00                	push   $0x0
 152:	e8 f4 00 00 00       	call   24b <read>
    if(cc < 1)
 157:	83 c4 10             	add    $0x10,%esp
 15a:	85 c0                	test   %eax,%eax
 15c:	7e 1a                	jle    178 <gets+0x3c>
      break;
    buf[i++] = c;
 15e:	8a 45 e7             	mov    -0x19(%ebp),%al
 161:	8b 55 08             	mov    0x8(%ebp),%edx
 164:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 168:	3c 0a                	cmp    $0xa,%al
 16a:	74 0e                	je     17a <gets+0x3e>
 16c:	3c 0d                	cmp    $0xd,%al
 16e:	74 0a                	je     17a <gets+0x3e>
  for(i=0; i+1 < max; ){
 170:	89 df                	mov    %ebx,%edi
 172:	43                   	inc    %ebx
 173:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 176:	7c d4                	jl     14c <gets+0x10>
 178:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 181:	8d 65 f4             	lea    -0xc(%ebp),%esp
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5f                   	pop    %edi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret
 189:	8d 76 00             	lea    0x0(%esi),%esi

0000018c <stat>:

int
stat(const char *n, struct stat *st)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	56                   	push   %esi
 190:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 191:	83 ec 08             	sub    $0x8,%esp
 194:	6a 00                	push   $0x0
 196:	ff 75 08             	push   0x8(%ebp)
 199:	e8 d5 00 00 00       	call   273 <open>
  if(fd < 0)
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	85 c0                	test   %eax,%eax
 1a3:	78 27                	js     1cc <stat+0x40>
 1a5:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a7:	83 ec 08             	sub    $0x8,%esp
 1aa:	ff 75 0c             	push   0xc(%ebp)
 1ad:	50                   	push   %eax
 1ae:	e8 d8 00 00 00       	call   28b <fstat>
 1b3:	89 c6                	mov    %eax,%esi
  close(fd);
 1b5:	89 1c 24             	mov    %ebx,(%esp)
 1b8:	e8 9e 00 00 00       	call   25b <close>
  return r;
 1bd:	83 c4 10             	add    $0x10,%esp
}
 1c0:	89 f0                	mov    %esi,%eax
 1c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c5:	5b                   	pop    %ebx
 1c6:	5e                   	pop    %esi
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret
 1c9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1cc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d1:	eb ed                	jmp    1c0 <stat+0x34>
 1d3:	90                   	nop

000001d4 <atoi>:

int
atoi(const char *s)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	53                   	push   %ebx
 1d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1db:	0f be 01             	movsbl (%ecx),%eax
 1de:	8d 50 d0             	lea    -0x30(%eax),%edx
 1e1:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1e4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1e9:	77 16                	ja     201 <atoi+0x2d>
 1eb:	90                   	nop
    n = n*10 + *s++ - '0';
 1ec:	41                   	inc    %ecx
 1ed:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1f0:	01 d2                	add    %edx,%edx
 1f2:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1f6:	0f be 01             	movsbl (%ecx),%eax
 1f9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1fc:	80 fb 09             	cmp    $0x9,%bl
 1ff:	76 eb                	jbe    1ec <atoi+0x18>
  return n;
}
 201:	89 d0                	mov    %edx,%eax
 203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 206:	c9                   	leave
 207:	c3                   	ret

00000208 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	57                   	push   %edi
 20c:	56                   	push   %esi
 20d:	8b 55 08             	mov    0x8(%ebp),%edx
 210:	8b 75 0c             	mov    0xc(%ebp),%esi
 213:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 216:	85 c0                	test   %eax,%eax
 218:	7e 0b                	jle    225 <memmove+0x1d>
 21a:	01 d0                	add    %edx,%eax
  dst = vdst;
 21c:	89 d7                	mov    %edx,%edi
 21e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 220:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 221:	39 f8                	cmp    %edi,%eax
 223:	75 fb                	jne    220 <memmove+0x18>
  return vdst;
}
 225:	89 d0                	mov    %edx,%eax
 227:	5e                   	pop    %esi
 228:	5f                   	pop    %edi
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret

0000022b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22b:	b8 01 00 00 00       	mov    $0x1,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret

00000233 <exit>:
SYSCALL(exit)
 233:	b8 02 00 00 00       	mov    $0x2,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret

0000023b <wait>:
SYSCALL(wait)
 23b:	b8 03 00 00 00       	mov    $0x3,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret

00000243 <pipe>:
SYSCALL(pipe)
 243:	b8 04 00 00 00       	mov    $0x4,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret

0000024b <read>:
SYSCALL(read)
 24b:	b8 05 00 00 00       	mov    $0x5,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret

00000253 <write>:
SYSCALL(write)
 253:	b8 10 00 00 00       	mov    $0x10,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret

0000025b <close>:
SYSCALL(close)
 25b:	b8 15 00 00 00       	mov    $0x15,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret

00000263 <kill>:
SYSCALL(kill)
 263:	b8 06 00 00 00       	mov    $0x6,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <exec>:
SYSCALL(exec)
 26b:	b8 07 00 00 00       	mov    $0x7,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <open>:
SYSCALL(open)
 273:	b8 0f 00 00 00       	mov    $0xf,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <mknod>:
SYSCALL(mknod)
 27b:	b8 11 00 00 00       	mov    $0x11,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <unlink>:
SYSCALL(unlink)
 283:	b8 12 00 00 00       	mov    $0x12,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <fstat>:
SYSCALL(fstat)
 28b:	b8 08 00 00 00       	mov    $0x8,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <link>:
SYSCALL(link)
 293:	b8 13 00 00 00       	mov    $0x13,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <mkdir>:
SYSCALL(mkdir)
 29b:	b8 14 00 00 00       	mov    $0x14,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <chdir>:
SYSCALL(chdir)
 2a3:	b8 09 00 00 00       	mov    $0x9,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <dup>:
SYSCALL(dup)
 2ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <getpid>:
SYSCALL(getpid)
 2b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <sbrk>:
SYSCALL(sbrk)
 2bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <sleep>:
SYSCALL(sleep)
 2c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <uptime>:
SYSCALL(uptime)
 2cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <signal>:
SYSCALL(signal)
 2d3:	b8 16 00 00 00       	mov    $0x16,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <custom_fork>:
SYSCALL(custom_fork)
 2db:	b8 17 00 00 00       	mov    $0x17,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <scheduler_start>:
 2e3:	b8 18 00 00 00       	mov    $0x18,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret
 2eb:	90                   	nop

000002ec <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	57                   	push   %edi
 2f0:	56                   	push   %esi
 2f1:	53                   	push   %ebx
 2f2:	83 ec 3c             	sub    $0x3c,%esp
 2f5:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2f8:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fd:	85 c9                	test   %ecx,%ecx
 2ff:	74 04                	je     305 <printint+0x19>
 301:	85 d2                	test   %edx,%edx
 303:	78 6b                	js     370 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 305:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 308:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 30f:	31 c9                	xor    %ecx,%ecx
 311:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 314:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 317:	31 d2                	xor    %edx,%edx
 319:	f7 f3                	div    %ebx
 31b:	89 cf                	mov    %ecx,%edi
 31d:	8d 49 01             	lea    0x1(%ecx),%ecx
 320:	8a 92 ec 06 00 00    	mov    0x6ec(%edx),%dl
 326:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 32a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 32d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 330:	39 da                	cmp    %ebx,%edx
 332:	73 e0                	jae    314 <printint+0x28>
  if(neg)
 334:	8b 55 08             	mov    0x8(%ebp),%edx
 337:	85 d2                	test   %edx,%edx
 339:	74 07                	je     342 <printint+0x56>
    buf[i++] = '-';
 33b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 340:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 342:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 345:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 349:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 34c:	8a 07                	mov    (%edi),%al
 34e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 351:	50                   	push   %eax
 352:	6a 01                	push   $0x1
 354:	56                   	push   %esi
 355:	ff 75 c0             	push   -0x40(%ebp)
 358:	e8 f6 fe ff ff       	call   253 <write>
  while(--i >= 0)
 35d:	89 f8                	mov    %edi,%eax
 35f:	4f                   	dec    %edi
 360:	83 c4 10             	add    $0x10,%esp
 363:	39 d8                	cmp    %ebx,%eax
 365:	75 e5                	jne    34c <printint+0x60>
}
 367:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36a:	5b                   	pop    %ebx
 36b:	5e                   	pop    %esi
 36c:	5f                   	pop    %edi
 36d:	5d                   	pop    %ebp
 36e:	c3                   	ret
 36f:	90                   	nop
    x = -xx;
 370:	f7 da                	neg    %edx
 372:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 375:	eb 98                	jmp    30f <printint+0x23>
 377:	90                   	nop

00000378 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	57                   	push   %edi
 37c:	56                   	push   %esi
 37d:	53                   	push   %ebx
 37e:	83 ec 2c             	sub    $0x2c,%esp
 381:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 384:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 387:	8a 03                	mov    (%ebx),%al
 389:	84 c0                	test   %al,%al
 38b:	74 2a                	je     3b7 <printf+0x3f>
 38d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 38e:	8d 4d 10             	lea    0x10(%ebp),%ecx
 391:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 394:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 397:	83 fa 25             	cmp    $0x25,%edx
 39a:	74 24                	je     3c0 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 39c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 39f:	50                   	push   %eax
 3a0:	6a 01                	push   $0x1
 3a2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3a5:	50                   	push   %eax
 3a6:	56                   	push   %esi
 3a7:	e8 a7 fe ff ff       	call   253 <write>
  for(i = 0; fmt[i]; i++){
 3ac:	43                   	inc    %ebx
 3ad:	8a 43 ff             	mov    -0x1(%ebx),%al
 3b0:	83 c4 10             	add    $0x10,%esp
 3b3:	84 c0                	test   %al,%al
 3b5:	75 dd                	jne    394 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ba:	5b                   	pop    %ebx
 3bb:	5e                   	pop    %esi
 3bc:	5f                   	pop    %edi
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret
 3bf:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3c0:	8a 13                	mov    (%ebx),%dl
 3c2:	84 d2                	test   %dl,%dl
 3c4:	74 f1                	je     3b7 <printf+0x3f>
    c = fmt[i] & 0xff;
 3c6:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3c9:	80 fa 25             	cmp    $0x25,%dl
 3cc:	0f 84 fe 00 00 00    	je     4d0 <printf+0x158>
 3d2:	83 e8 63             	sub    $0x63,%eax
 3d5:	83 f8 15             	cmp    $0x15,%eax
 3d8:	77 0a                	ja     3e4 <printf+0x6c>
 3da:	ff 24 85 94 06 00 00 	jmp    *0x694(,%eax,4)
 3e1:	8d 76 00             	lea    0x0(%esi),%esi
 3e4:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3eb:	50                   	push   %eax
 3ec:	6a 01                	push   $0x1
 3ee:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3f1:	57                   	push   %edi
 3f2:	56                   	push   %esi
 3f3:	e8 5b fe ff ff       	call   253 <write>
        putc(fd, c);
 3f8:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3fe:	83 c4 0c             	add    $0xc,%esp
 401:	6a 01                	push   $0x1
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	e8 49 fe ff ff       	call   253 <write>
  for(i = 0; fmt[i]; i++){
 40a:	83 c3 02             	add    $0x2,%ebx
 40d:	8a 43 ff             	mov    -0x1(%ebx),%al
 410:	83 c4 10             	add    $0x10,%esp
 413:	84 c0                	test   %al,%al
 415:	0f 85 79 ff ff ff    	jne    394 <printf+0x1c>
}
 41b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5f                   	pop    %edi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret
 423:	90                   	nop
        printint(fd, *ap, 16, 0);
 424:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 427:	8b 17                	mov    (%edi),%edx
 429:	83 ec 0c             	sub    $0xc,%esp
 42c:	6a 00                	push   $0x0
 42e:	b9 10 00 00 00       	mov    $0x10,%ecx
 433:	89 f0                	mov    %esi,%eax
 435:	e8 b2 fe ff ff       	call   2ec <printint>
        ap++;
 43a:	83 c7 04             	add    $0x4,%edi
 43d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 440:	eb c8                	jmp    40a <printf+0x92>
 442:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 444:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 447:	8b 01                	mov    (%ecx),%eax
        ap++;
 449:	83 c1 04             	add    $0x4,%ecx
 44c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 44f:	85 c0                	test   %eax,%eax
 451:	0f 84 89 00 00 00    	je     4e0 <printf+0x168>
        while(*s != 0){
 457:	8a 10                	mov    (%eax),%dl
 459:	84 d2                	test   %dl,%dl
 45b:	74 29                	je     486 <printf+0x10e>
 45d:	89 c7                	mov    %eax,%edi
 45f:	88 d0                	mov    %dl,%al
 461:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 464:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 467:	89 fb                	mov    %edi,%ebx
 469:	89 cf                	mov    %ecx,%edi
 46b:	90                   	nop
          putc(fd, *s);
 46c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 46f:	50                   	push   %eax
 470:	6a 01                	push   $0x1
 472:	57                   	push   %edi
 473:	56                   	push   %esi
 474:	e8 da fd ff ff       	call   253 <write>
          s++;
 479:	43                   	inc    %ebx
        while(*s != 0){
 47a:	8a 03                	mov    (%ebx),%al
 47c:	83 c4 10             	add    $0x10,%esp
 47f:	84 c0                	test   %al,%al
 481:	75 e9                	jne    46c <printf+0xf4>
 483:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 486:	83 c3 02             	add    $0x2,%ebx
 489:	8a 43 ff             	mov    -0x1(%ebx),%al
 48c:	84 c0                	test   %al,%al
 48e:	0f 85 00 ff ff ff    	jne    394 <printf+0x1c>
 494:	e9 1e ff ff ff       	jmp    3b7 <printf+0x3f>
 499:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 49c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 49f:	8b 17                	mov    (%edi),%edx
 4a1:	83 ec 0c             	sub    $0xc,%esp
 4a4:	6a 01                	push   $0x1
 4a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4ab:	eb 86                	jmp    433 <printf+0xbb>
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4b3:	8b 00                	mov    (%eax),%eax
 4b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4b8:	51                   	push   %ecx
 4b9:	6a 01                	push   $0x1
 4bb:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4be:	57                   	push   %edi
 4bf:	56                   	push   %esi
 4c0:	e8 8e fd ff ff       	call   253 <write>
        ap++;
 4c5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4c9:	e9 3c ff ff ff       	jmp    40a <printf+0x92>
 4ce:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4d3:	52                   	push   %edx
 4d4:	6a 01                	push   $0x1
 4d6:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4d9:	e9 25 ff ff ff       	jmp    403 <printf+0x8b>
 4de:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4e0:	bf 8b 06 00 00       	mov    $0x68b,%edi
 4e5:	b0 28                	mov    $0x28,%al
 4e7:	e9 75 ff ff ff       	jmp    461 <printf+0xe9>

000004ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	57                   	push   %edi
 4f0:	56                   	push   %esi
 4f1:	53                   	push   %ebx
 4f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4f5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f8:	a1 00 07 00 00       	mov    0x700,%eax
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
 500:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 502:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 504:	39 ca                	cmp    %ecx,%edx
 506:	73 2c                	jae    534 <free+0x48>
 508:	39 c1                	cmp    %eax,%ecx
 50a:	72 04                	jb     510 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 50c:	39 c2                	cmp    %eax,%edx
 50e:	72 f0                	jb     500 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 510:	8b 73 fc             	mov    -0x4(%ebx),%esi
 513:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 516:	39 f8                	cmp    %edi,%eax
 518:	74 2c                	je     546 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 51a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 51d:	8b 42 04             	mov    0x4(%edx),%eax
 520:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 523:	39 f1                	cmp    %esi,%ecx
 525:	74 36                	je     55d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 527:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 529:	89 15 00 07 00 00    	mov    %edx,0x700
}
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5f                   	pop    %edi
 532:	5d                   	pop    %ebp
 533:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 534:	39 c2                	cmp    %eax,%edx
 536:	72 c8                	jb     500 <free+0x14>
 538:	39 c1                	cmp    %eax,%ecx
 53a:	73 c4                	jae    500 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 53c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 53f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 542:	39 f8                	cmp    %edi,%eax
 544:	75 d4                	jne    51a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 546:	03 70 04             	add    0x4(%eax),%esi
 549:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54c:	8b 02                	mov    (%edx),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 553:	8b 42 04             	mov    0x4(%edx),%eax
 556:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 559:	39 f1                	cmp    %esi,%ecx
 55b:	75 ca                	jne    527 <free+0x3b>
    p->s.size += bp->s.size;
 55d:	03 43 fc             	add    -0x4(%ebx),%eax
 560:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 563:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 566:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 568:	89 15 00 07 00 00    	mov    %edx,0x700
}
 56e:	5b                   	pop    %ebx
 56f:	5e                   	pop    %esi
 570:	5f                   	pop    %edi
 571:	5d                   	pop    %ebp
 572:	c3                   	ret
 573:	90                   	nop

00000574 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	57                   	push   %edi
 578:	56                   	push   %esi
 579:	53                   	push   %ebx
 57a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	8d 78 07             	lea    0x7(%eax),%edi
 583:	c1 ef 03             	shr    $0x3,%edi
 586:	47                   	inc    %edi
  if((prevp = freep) == 0){
 587:	8b 15 00 07 00 00    	mov    0x700,%edx
 58d:	85 d2                	test   %edx,%edx
 58f:	0f 84 93 00 00 00    	je     628 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 595:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 597:	8b 48 04             	mov    0x4(%eax),%ecx
 59a:	39 f9                	cmp    %edi,%ecx
 59c:	73 62                	jae    600 <malloc+0x8c>
  if(nu < 4096)
 59e:	89 fb                	mov    %edi,%ebx
 5a0:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5a6:	72 78                	jb     620 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5a8:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5af:	eb 0e                	jmp    5bf <malloc+0x4b>
 5b1:	8d 76 00             	lea    0x0(%esi),%esi
 5b4:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5b8:	8b 48 04             	mov    0x4(%eax),%ecx
 5bb:	39 f9                	cmp    %edi,%ecx
 5bd:	73 41                	jae    600 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5bf:	39 05 00 07 00 00    	cmp    %eax,0x700
 5c5:	75 ed                	jne    5b4 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5c7:	83 ec 0c             	sub    $0xc,%esp
 5ca:	56                   	push   %esi
 5cb:	e8 eb fc ff ff       	call   2bb <sbrk>
  if(p == (char*)-1)
 5d0:	83 c4 10             	add    $0x10,%esp
 5d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5d6:	74 1c                	je     5f4 <malloc+0x80>
  hp->s.size = nu;
 5d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5db:	83 ec 0c             	sub    $0xc,%esp
 5de:	83 c0 08             	add    $0x8,%eax
 5e1:	50                   	push   %eax
 5e2:	e8 05 ff ff ff       	call   4ec <free>
  return freep;
 5e7:	8b 15 00 07 00 00    	mov    0x700,%edx
      if((p = morecore(nunits)) == 0)
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	85 d2                	test   %edx,%edx
 5f2:	75 c2                	jne    5b6 <malloc+0x42>
        return 0;
 5f4:	31 c0                	xor    %eax,%eax
  }
}
 5f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f9:	5b                   	pop    %ebx
 5fa:	5e                   	pop    %esi
 5fb:	5f                   	pop    %edi
 5fc:	5d                   	pop    %ebp
 5fd:	c3                   	ret
 5fe:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 600:	39 cf                	cmp    %ecx,%edi
 602:	74 4c                	je     650 <malloc+0xdc>
        p->s.size -= nunits;
 604:	29 f9                	sub    %edi,%ecx
 606:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 609:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 60c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 60f:	89 15 00 07 00 00    	mov    %edx,0x700
      return (void*)(p + 1);
 615:	83 c0 08             	add    $0x8,%eax
}
 618:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61b:	5b                   	pop    %ebx
 61c:	5e                   	pop    %esi
 61d:	5f                   	pop    %edi
 61e:	5d                   	pop    %ebp
 61f:	c3                   	ret
  if(nu < 4096)
 620:	bb 00 10 00 00       	mov    $0x1000,%ebx
 625:	eb 81                	jmp    5a8 <malloc+0x34>
 627:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 628:	c7 05 00 07 00 00 04 	movl   $0x704,0x700
 62f:	07 00 00 
 632:	c7 05 04 07 00 00 04 	movl   $0x704,0x704
 639:	07 00 00 
    base.s.size = 0;
 63c:	c7 05 08 07 00 00 00 	movl   $0x0,0x708
 643:	00 00 00 
 646:	b8 04 07 00 00       	mov    $0x704,%eax
 64b:	e9 4e ff ff ff       	jmp    59e <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 650:	8b 08                	mov    (%eax),%ecx
 652:	89 0a                	mov    %ecx,(%edx)
 654:	eb b9                	jmp    60f <malloc+0x9b>
