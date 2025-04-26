
_rm:     file format elf32-i386


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
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bf 01 00 00 00       	mov    $0x1,%edi
  26:	66 90                	xchg   %ax,%ax
    if(unlink(argv[i]) < 0){
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	push   (%ebx)
  2d:	e8 51 02 00 00       	call   283 <unlink>
  32:	83 c4 10             	add    $0x10,%esp
  35:	85 c0                	test   %eax,%eax
  37:	78 0d                	js     46 <main+0x46>
  for(i = 1; i < argc; i++){
  39:	47                   	inc    %edi
  3a:	83 c3 04             	add    $0x4,%ebx
  3d:	39 fe                	cmp    %edi,%esi
  3f:	75 e7                	jne    28 <main+0x28>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  41:	e8 ed 01 00 00       	call   233 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  46:	50                   	push   %eax
  47:	ff 33                	push   (%ebx)
  49:	68 64 06 00 00       	push   $0x664
  4e:	6a 02                	push   $0x2
  50:	e8 1b 03 00 00       	call   370 <printf>
      break;
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e7                	jmp    41 <main+0x41>
    printf(2, "Usage: rm files...\n");
  5a:	52                   	push   %edx
  5b:	52                   	push   %edx
  5c:	68 50 06 00 00       	push   $0x650
  61:	6a 02                	push   $0x2
  63:	e8 08 03 00 00       	call   370 <printf>
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

000002d3 <custom_fork>:
SYSCALL(custom_fork)
 2d3:	b8 17 00 00 00       	mov    $0x17,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <scheduler_start>:
SYSCALL(scheduler_start)
 2db:	b8 18 00 00 00       	mov    $0x18,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret
 2e3:	90                   	nop

000002e4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	56                   	push   %esi
 2e9:	53                   	push   %ebx
 2ea:	83 ec 3c             	sub    $0x3c,%esp
 2ed:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2f0:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f5:	85 c9                	test   %ecx,%ecx
 2f7:	74 04                	je     2fd <printint+0x19>
 2f9:	85 d2                	test   %edx,%edx
 2fb:	78 6b                	js     368 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2fd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 300:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 307:	31 c9                	xor    %ecx,%ecx
 309:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 30c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 30f:	31 d2                	xor    %edx,%edx
 311:	f7 f3                	div    %ebx
 313:	89 cf                	mov    %ecx,%edi
 315:	8d 49 01             	lea    0x1(%ecx),%ecx
 318:	8a 92 dc 06 00 00    	mov    0x6dc(%edx),%dl
 31e:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 322:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 325:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 328:	39 da                	cmp    %ebx,%edx
 32a:	73 e0                	jae    30c <printint+0x28>
  if(neg)
 32c:	8b 55 08             	mov    0x8(%ebp),%edx
 32f:	85 d2                	test   %edx,%edx
 331:	74 07                	je     33a <printint+0x56>
    buf[i++] = '-';
 333:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 338:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 33a:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 33d:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 341:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 344:	8a 07                	mov    (%edi),%al
 346:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 349:	50                   	push   %eax
 34a:	6a 01                	push   $0x1
 34c:	56                   	push   %esi
 34d:	ff 75 c0             	push   -0x40(%ebp)
 350:	e8 fe fe ff ff       	call   253 <write>
  while(--i >= 0)
 355:	89 f8                	mov    %edi,%eax
 357:	4f                   	dec    %edi
 358:	83 c4 10             	add    $0x10,%esp
 35b:	39 d8                	cmp    %ebx,%eax
 35d:	75 e5                	jne    344 <printint+0x60>
}
 35f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 362:	5b                   	pop    %ebx
 363:	5e                   	pop    %esi
 364:	5f                   	pop    %edi
 365:	5d                   	pop    %ebp
 366:	c3                   	ret
 367:	90                   	nop
    x = -xx;
 368:	f7 da                	neg    %edx
 36a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 36d:	eb 98                	jmp    307 <printint+0x23>
 36f:	90                   	nop

00000370 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	53                   	push   %ebx
 376:	83 ec 2c             	sub    $0x2c,%esp
 379:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 37c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 37f:	8a 03                	mov    (%ebx),%al
 381:	84 c0                	test   %al,%al
 383:	74 2a                	je     3af <printf+0x3f>
 385:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 386:	8d 4d 10             	lea    0x10(%ebp),%ecx
 389:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 38c:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 38f:	83 fa 25             	cmp    $0x25,%edx
 392:	74 24                	je     3b8 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 394:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 397:	50                   	push   %eax
 398:	6a 01                	push   $0x1
 39a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 39d:	50                   	push   %eax
 39e:	56                   	push   %esi
 39f:	e8 af fe ff ff       	call   253 <write>
  for(i = 0; fmt[i]; i++){
 3a4:	43                   	inc    %ebx
 3a5:	8a 43 ff             	mov    -0x1(%ebx),%al
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	84 c0                	test   %al,%al
 3ad:	75 dd                	jne    38c <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b2:	5b                   	pop    %ebx
 3b3:	5e                   	pop    %esi
 3b4:	5f                   	pop    %edi
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret
 3b7:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3b8:	8a 13                	mov    (%ebx),%dl
 3ba:	84 d2                	test   %dl,%dl
 3bc:	74 f1                	je     3af <printf+0x3f>
    c = fmt[i] & 0xff;
 3be:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3c1:	80 fa 25             	cmp    $0x25,%dl
 3c4:	0f 84 fe 00 00 00    	je     4c8 <printf+0x158>
 3ca:	83 e8 63             	sub    $0x63,%eax
 3cd:	83 f8 15             	cmp    $0x15,%eax
 3d0:	77 0a                	ja     3dc <printf+0x6c>
 3d2:	ff 24 85 84 06 00 00 	jmp    *0x684(,%eax,4)
 3d9:	8d 76 00             	lea    0x0(%esi),%esi
 3dc:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3df:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3e3:	50                   	push   %eax
 3e4:	6a 01                	push   $0x1
 3e6:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3e9:	57                   	push   %edi
 3ea:	56                   	push   %esi
 3eb:	e8 63 fe ff ff       	call   253 <write>
        putc(fd, c);
 3f0:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3f3:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3f6:	83 c4 0c             	add    $0xc,%esp
 3f9:	6a 01                	push   $0x1
 3fb:	57                   	push   %edi
 3fc:	56                   	push   %esi
 3fd:	e8 51 fe ff ff       	call   253 <write>
  for(i = 0; fmt[i]; i++){
 402:	83 c3 02             	add    $0x2,%ebx
 405:	8a 43 ff             	mov    -0x1(%ebx),%al
 408:	83 c4 10             	add    $0x10,%esp
 40b:	84 c0                	test   %al,%al
 40d:	0f 85 79 ff ff ff    	jne    38c <printf+0x1c>
}
 413:	8d 65 f4             	lea    -0xc(%ebp),%esp
 416:	5b                   	pop    %ebx
 417:	5e                   	pop    %esi
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret
 41b:	90                   	nop
        printint(fd, *ap, 16, 0);
 41c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 41f:	8b 17                	mov    (%edi),%edx
 421:	83 ec 0c             	sub    $0xc,%esp
 424:	6a 00                	push   $0x0
 426:	b9 10 00 00 00       	mov    $0x10,%ecx
 42b:	89 f0                	mov    %esi,%eax
 42d:	e8 b2 fe ff ff       	call   2e4 <printint>
        ap++;
 432:	83 c7 04             	add    $0x4,%edi
 435:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 438:	eb c8                	jmp    402 <printf+0x92>
 43a:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 43c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 43f:	8b 01                	mov    (%ecx),%eax
        ap++;
 441:	83 c1 04             	add    $0x4,%ecx
 444:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 447:	85 c0                	test   %eax,%eax
 449:	0f 84 89 00 00 00    	je     4d8 <printf+0x168>
        while(*s != 0){
 44f:	8a 10                	mov    (%eax),%dl
 451:	84 d2                	test   %dl,%dl
 453:	74 29                	je     47e <printf+0x10e>
 455:	89 c7                	mov    %eax,%edi
 457:	88 d0                	mov    %dl,%al
 459:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 45c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 45f:	89 fb                	mov    %edi,%ebx
 461:	89 cf                	mov    %ecx,%edi
 463:	90                   	nop
          putc(fd, *s);
 464:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 467:	50                   	push   %eax
 468:	6a 01                	push   $0x1
 46a:	57                   	push   %edi
 46b:	56                   	push   %esi
 46c:	e8 e2 fd ff ff       	call   253 <write>
          s++;
 471:	43                   	inc    %ebx
        while(*s != 0){
 472:	8a 03                	mov    (%ebx),%al
 474:	83 c4 10             	add    $0x10,%esp
 477:	84 c0                	test   %al,%al
 479:	75 e9                	jne    464 <printf+0xf4>
 47b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 47e:	83 c3 02             	add    $0x2,%ebx
 481:	8a 43 ff             	mov    -0x1(%ebx),%al
 484:	84 c0                	test   %al,%al
 486:	0f 85 00 ff ff ff    	jne    38c <printf+0x1c>
 48c:	e9 1e ff ff ff       	jmp    3af <printf+0x3f>
 491:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 494:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 497:	8b 17                	mov    (%edi),%edx
 499:	83 ec 0c             	sub    $0xc,%esp
 49c:	6a 01                	push   $0x1
 49e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4a3:	eb 86                	jmp    42b <printf+0xbb>
 4a5:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4ab:	8b 00                	mov    (%eax),%eax
 4ad:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4b0:	51                   	push   %ecx
 4b1:	6a 01                	push   $0x1
 4b3:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b6:	57                   	push   %edi
 4b7:	56                   	push   %esi
 4b8:	e8 96 fd ff ff       	call   253 <write>
        ap++;
 4bd:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4c1:	e9 3c ff ff ff       	jmp    402 <printf+0x92>
 4c6:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4c8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	52                   	push   %edx
 4cc:	6a 01                	push   $0x1
 4ce:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4d1:	e9 25 ff ff ff       	jmp    3fb <printf+0x8b>
 4d6:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4d8:	bf 7d 06 00 00       	mov    $0x67d,%edi
 4dd:	b0 28                	mov    $0x28,%al
 4df:	e9 75 ff ff ff       	jmp    459 <printf+0xe9>

000004e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	57                   	push   %edi
 4e8:	56                   	push   %esi
 4e9:	53                   	push   %ebx
 4ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ed:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f0:	a1 f0 06 00 00       	mov    0x6f0,%eax
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
 4f8:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4fa:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fc:	39 ca                	cmp    %ecx,%edx
 4fe:	73 2c                	jae    52c <free+0x48>
 500:	39 c1                	cmp    %eax,%ecx
 502:	72 04                	jb     508 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 504:	39 c2                	cmp    %eax,%edx
 506:	72 f0                	jb     4f8 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 508:	8b 73 fc             	mov    -0x4(%ebx),%esi
 50b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 50e:	39 f8                	cmp    %edi,%eax
 510:	74 2c                	je     53e <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 512:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 515:	8b 42 04             	mov    0x4(%edx),%eax
 518:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 51b:	39 f1                	cmp    %esi,%ecx
 51d:	74 36                	je     555 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 51f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 521:	89 15 f0 06 00 00    	mov    %edx,0x6f0
}
 527:	5b                   	pop    %ebx
 528:	5e                   	pop    %esi
 529:	5f                   	pop    %edi
 52a:	5d                   	pop    %ebp
 52b:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 52c:	39 c2                	cmp    %eax,%edx
 52e:	72 c8                	jb     4f8 <free+0x14>
 530:	39 c1                	cmp    %eax,%ecx
 532:	73 c4                	jae    4f8 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 534:	8b 73 fc             	mov    -0x4(%ebx),%esi
 537:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 53a:	39 f8                	cmp    %edi,%eax
 53c:	75 d4                	jne    512 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 53e:	03 70 04             	add    0x4(%eax),%esi
 541:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 544:	8b 02                	mov    (%edx),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 54b:	8b 42 04             	mov    0x4(%edx),%eax
 54e:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 551:	39 f1                	cmp    %esi,%ecx
 553:	75 ca                	jne    51f <free+0x3b>
    p->s.size += bp->s.size;
 555:	03 43 fc             	add    -0x4(%ebx),%eax
 558:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 55b:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 55e:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 560:	89 15 f0 06 00 00    	mov    %edx,0x6f0
}
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret
 56b:	90                   	nop

0000056c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	57                   	push   %edi
 570:	56                   	push   %esi
 571:	53                   	push   %ebx
 572:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	8d 78 07             	lea    0x7(%eax),%edi
 57b:	c1 ef 03             	shr    $0x3,%edi
 57e:	47                   	inc    %edi
  if((prevp = freep) == 0){
 57f:	8b 15 f0 06 00 00    	mov    0x6f0,%edx
 585:	85 d2                	test   %edx,%edx
 587:	0f 84 93 00 00 00    	je     620 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 58d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 58f:	8b 48 04             	mov    0x4(%eax),%ecx
 592:	39 f9                	cmp    %edi,%ecx
 594:	73 62                	jae    5f8 <malloc+0x8c>
  if(nu < 4096)
 596:	89 fb                	mov    %edi,%ebx
 598:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 59e:	72 78                	jb     618 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5a0:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5a7:	eb 0e                	jmp    5b7 <malloc+0x4b>
 5a9:	8d 76 00             	lea    0x0(%esi),%esi
 5ac:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ae:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5b0:	8b 48 04             	mov    0x4(%eax),%ecx
 5b3:	39 f9                	cmp    %edi,%ecx
 5b5:	73 41                	jae    5f8 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5b7:	39 05 f0 06 00 00    	cmp    %eax,0x6f0
 5bd:	75 ed                	jne    5ac <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5bf:	83 ec 0c             	sub    $0xc,%esp
 5c2:	56                   	push   %esi
 5c3:	e8 f3 fc ff ff       	call   2bb <sbrk>
  if(p == (char*)-1)
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ce:	74 1c                	je     5ec <malloc+0x80>
  hp->s.size = nu;
 5d0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5d3:	83 ec 0c             	sub    $0xc,%esp
 5d6:	83 c0 08             	add    $0x8,%eax
 5d9:	50                   	push   %eax
 5da:	e8 05 ff ff ff       	call   4e4 <free>
  return freep;
 5df:	8b 15 f0 06 00 00    	mov    0x6f0,%edx
      if((p = morecore(nunits)) == 0)
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	85 d2                	test   %edx,%edx
 5ea:	75 c2                	jne    5ae <malloc+0x42>
        return 0;
 5ec:	31 c0                	xor    %eax,%eax
  }
}
 5ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f1:	5b                   	pop    %ebx
 5f2:	5e                   	pop    %esi
 5f3:	5f                   	pop    %edi
 5f4:	5d                   	pop    %ebp
 5f5:	c3                   	ret
 5f6:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5f8:	39 cf                	cmp    %ecx,%edi
 5fa:	74 4c                	je     648 <malloc+0xdc>
        p->s.size -= nunits;
 5fc:	29 f9                	sub    %edi,%ecx
 5fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 601:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 604:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 607:	89 15 f0 06 00 00    	mov    %edx,0x6f0
      return (void*)(p + 1);
 60d:	83 c0 08             	add    $0x8,%eax
}
 610:	8d 65 f4             	lea    -0xc(%ebp),%esp
 613:	5b                   	pop    %ebx
 614:	5e                   	pop    %esi
 615:	5f                   	pop    %edi
 616:	5d                   	pop    %ebp
 617:	c3                   	ret
  if(nu < 4096)
 618:	bb 00 10 00 00       	mov    $0x1000,%ebx
 61d:	eb 81                	jmp    5a0 <malloc+0x34>
 61f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 620:	c7 05 f0 06 00 00 f4 	movl   $0x6f4,0x6f0
 627:	06 00 00 
 62a:	c7 05 f4 06 00 00 f4 	movl   $0x6f4,0x6f4
 631:	06 00 00 
    base.s.size = 0;
 634:	c7 05 f8 06 00 00 00 	movl   $0x0,0x6f8
 63b:	00 00 00 
 63e:	b8 f4 06 00 00       	mov    $0x6f4,%eax
 643:	e9 4e ff ff ff       	jmp    596 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 648:	8b 08                	mov    (%eax),%ecx
 64a:	89 0a                	mov    %ecx,(%edx)
 64c:	eb b9                	jmp    607 <malloc+0x9b>
