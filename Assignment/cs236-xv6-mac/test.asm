
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	50                   	push   %eax
   f:	90                   	nop
    while (1) {
        printf(1, "Hello\n");
  10:	83 ec 08             	sub    $0x8,%esp
  13:	68 08 06 00 00       	push   $0x608
  18:	6a 01                	push   $0x1
  1a:	e8 09 03 00 00       	call   328 <printf>
        sleep(100);
  1f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  26:	e8 58 02 00 00       	call   283 <sleep>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	eb e0                	jmp    10 <main+0x10>

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3a:	31 c0                	xor    %eax,%eax
  3c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  3f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  42:	40                   	inc    %eax
  43:	84 d2                	test   %dl,%dl
  45:	75 f5                	jne    3c <strcpy+0xc>
    ;
  return os;
}
  47:	89 c8                	mov    %ecx,%eax
  49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4c:	c9                   	leave
  4d:	c3                   	ret
  4e:	66 90                	xchg   %ax,%ax

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  54:	8b 55 08             	mov    0x8(%ebp),%edx
  57:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  5a:	0f b6 02             	movzbl (%edx),%eax
  5d:	84 c0                	test   %al,%al
  5f:	75 10                	jne    71 <strcmp+0x21>
  61:	eb 2a                	jmp    8d <strcmp+0x3d>
  63:	90                   	nop
    p++, q++;
  64:	42                   	inc    %edx
  65:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  68:	0f b6 02             	movzbl (%edx),%eax
  6b:	84 c0                	test   %al,%al
  6d:	74 11                	je     80 <strcmp+0x30>
  6f:	89 cb                	mov    %ecx,%ebx
  71:	0f b6 0b             	movzbl (%ebx),%ecx
  74:	38 c1                	cmp    %al,%cl
  76:	74 ec                	je     64 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  78:	29 c8                	sub    %ecx,%eax
}
  7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7d:	c9                   	leave
  7e:	c3                   	ret
  7f:	90                   	nop
  return (uchar)*p - (uchar)*q;
  80:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  84:	31 c0                	xor    %eax,%eax
  86:	29 c8                	sub    %ecx,%eax
}
  88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8b:	c9                   	leave
  8c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  8d:	0f b6 0b             	movzbl (%ebx),%ecx
  90:	31 c0                	xor    %eax,%eax
  92:	eb e4                	jmp    78 <strcmp+0x28>

00000094 <strlen>:

uint
strlen(const char *s)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  9a:	80 3a 00             	cmpb   $0x0,(%edx)
  9d:	74 15                	je     b4 <strlen+0x20>
  9f:	31 c0                	xor    %eax,%eax
  a1:	8d 76 00             	lea    0x0(%esi),%esi
  a4:	40                   	inc    %eax
  a5:	89 c1                	mov    %eax,%ecx
  a7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ab:	75 f7                	jne    a4 <strlen+0x10>
    ;
  return n;
}
  ad:	89 c8                	mov    %ecx,%eax
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret
  b1:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  b4:	31 c9                	xor    %ecx,%ecx
}
  b6:	89 c8                	mov    %ecx,%eax
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret
  ba:	66 90                	xchg   %ax,%ax

000000bc <memset>:

void*
memset(void *dst, int c, uint n)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  c9:	fc                   	cld
  ca:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d2:	c9                   	leave
  d3:	c3                   	ret

000000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  dd:	8a 10                	mov    (%eax),%dl
  df:	84 d2                	test   %dl,%dl
  e1:	75 0c                	jne    ef <strchr+0x1b>
  e3:	eb 13                	jmp    f8 <strchr+0x24>
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  e8:	40                   	inc    %eax
  e9:	8a 10                	mov    (%eax),%dl
  eb:	84 d2                	test   %dl,%dl
  ed:	74 09                	je     f8 <strchr+0x24>
    if(*s == c)
  ef:	38 d1                	cmp    %dl,%cl
  f1:	75 f5                	jne    e8 <strchr+0x14>
      return (char*)s;
  return 0;
}
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret
  f5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  f8:	31 c0                	xor    %eax,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret

000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	56                   	push   %esi
 101:	53                   	push   %ebx
 102:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 105:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 107:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 10a:	eb 24                	jmp    130 <gets+0x34>
    cc = read(0, &c, 1);
 10c:	50                   	push   %eax
 10d:	6a 01                	push   $0x1
 10f:	56                   	push   %esi
 110:	6a 00                	push   $0x0
 112:	e8 f4 00 00 00       	call   20b <read>
    if(cc < 1)
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	7e 1a                	jle    138 <gets+0x3c>
      break;
    buf[i++] = c;
 11e:	8a 45 e7             	mov    -0x19(%ebp),%al
 121:	8b 55 08             	mov    0x8(%ebp),%edx
 124:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 128:	3c 0a                	cmp    $0xa,%al
 12a:	74 0e                	je     13a <gets+0x3e>
 12c:	3c 0d                	cmp    $0xd,%al
 12e:	74 0a                	je     13a <gets+0x3e>
  for(i=0; i+1 < max; ){
 130:	89 df                	mov    %ebx,%edi
 132:	43                   	inc    %ebx
 133:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 136:	7c d4                	jl     10c <gets+0x10>
 138:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 141:	8d 65 f4             	lea    -0xc(%ebp),%esp
 144:	5b                   	pop    %ebx
 145:	5e                   	pop    %esi
 146:	5f                   	pop    %edi
 147:	5d                   	pop    %ebp
 148:	c3                   	ret
 149:	8d 76 00             	lea    0x0(%esi),%esi

0000014c <stat>:

int
stat(const char *n, struct stat *st)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	56                   	push   %esi
 150:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 151:	83 ec 08             	sub    $0x8,%esp
 154:	6a 00                	push   $0x0
 156:	ff 75 08             	push   0x8(%ebp)
 159:	e8 d5 00 00 00       	call   233 <open>
  if(fd < 0)
 15e:	83 c4 10             	add    $0x10,%esp
 161:	85 c0                	test   %eax,%eax
 163:	78 27                	js     18c <stat+0x40>
 165:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	ff 75 0c             	push   0xc(%ebp)
 16d:	50                   	push   %eax
 16e:	e8 d8 00 00 00       	call   24b <fstat>
 173:	89 c6                	mov    %eax,%esi
  close(fd);
 175:	89 1c 24             	mov    %ebx,(%esp)
 178:	e8 9e 00 00 00       	call   21b <close>
  return r;
 17d:	83 c4 10             	add    $0x10,%esp
}
 180:	89 f0                	mov    %esi,%eax
 182:	8d 65 f8             	lea    -0x8(%ebp),%esp
 185:	5b                   	pop    %ebx
 186:	5e                   	pop    %esi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret
 189:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 18c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 191:	eb ed                	jmp    180 <stat+0x34>
 193:	90                   	nop

00000194 <atoi>:

int
atoi(const char *s)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	53                   	push   %ebx
 198:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19b:	0f be 01             	movsbl (%ecx),%eax
 19e:	8d 50 d0             	lea    -0x30(%eax),%edx
 1a1:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1a4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a9:	77 16                	ja     1c1 <atoi+0x2d>
 1ab:	90                   	nop
    n = n*10 + *s++ - '0';
 1ac:	41                   	inc    %ecx
 1ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1b0:	01 d2                	add    %edx,%edx
 1b2:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1b6:	0f be 01             	movsbl (%ecx),%eax
 1b9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bc:	80 fb 09             	cmp    $0x9,%bl
 1bf:	76 eb                	jbe    1ac <atoi+0x18>
  return n;
}
 1c1:	89 d0                	mov    %edx,%eax
 1c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c6:	c9                   	leave
 1c7:	c3                   	ret

000001c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	57                   	push   %edi
 1cc:	56                   	push   %esi
 1cd:	8b 55 08             	mov    0x8(%ebp),%edx
 1d0:	8b 75 0c             	mov    0xc(%ebp),%esi
 1d3:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1d6:	85 c0                	test   %eax,%eax
 1d8:	7e 0b                	jle    1e5 <memmove+0x1d>
 1da:	01 d0                	add    %edx,%eax
  dst = vdst;
 1dc:	89 d7                	mov    %edx,%edi
 1de:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1e1:	39 f8                	cmp    %edi,%eax
 1e3:	75 fb                	jne    1e0 <memmove+0x18>
  return vdst;
}
 1e5:	89 d0                	mov    %edx,%eax
 1e7:	5e                   	pop    %esi
 1e8:	5f                   	pop    %edi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret

000001eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1eb:	b8 01 00 00 00       	mov    $0x1,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	ret

000001f3 <exit>:
SYSCALL(exit)
 1f3:	b8 02 00 00 00       	mov    $0x2,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret

000001fb <wait>:
SYSCALL(wait)
 1fb:	b8 03 00 00 00       	mov    $0x3,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret

00000203 <pipe>:
SYSCALL(pipe)
 203:	b8 04 00 00 00       	mov    $0x4,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret

0000020b <read>:
SYSCALL(read)
 20b:	b8 05 00 00 00       	mov    $0x5,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret

00000213 <write>:
SYSCALL(write)
 213:	b8 10 00 00 00       	mov    $0x10,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret

0000021b <close>:
SYSCALL(close)
 21b:	b8 15 00 00 00       	mov    $0x15,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret

00000223 <kill>:
SYSCALL(kill)
 223:	b8 06 00 00 00       	mov    $0x6,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret

0000022b <exec>:
SYSCALL(exec)
 22b:	b8 07 00 00 00       	mov    $0x7,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret

00000233 <open>:
SYSCALL(open)
 233:	b8 0f 00 00 00       	mov    $0xf,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret

0000023b <mknod>:
SYSCALL(mknod)
 23b:	b8 11 00 00 00       	mov    $0x11,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret

00000243 <unlink>:
SYSCALL(unlink)
 243:	b8 12 00 00 00       	mov    $0x12,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret

0000024b <fstat>:
SYSCALL(fstat)
 24b:	b8 08 00 00 00       	mov    $0x8,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret

00000253 <link>:
SYSCALL(link)
 253:	b8 13 00 00 00       	mov    $0x13,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret

0000025b <mkdir>:
SYSCALL(mkdir)
 25b:	b8 14 00 00 00       	mov    $0x14,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret

00000263 <chdir>:
SYSCALL(chdir)
 263:	b8 09 00 00 00       	mov    $0x9,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <dup>:
SYSCALL(dup)
 26b:	b8 0a 00 00 00       	mov    $0xa,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <getpid>:
SYSCALL(getpid)
 273:	b8 0b 00 00 00       	mov    $0xb,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <sbrk>:
SYSCALL(sbrk)
 27b:	b8 0c 00 00 00       	mov    $0xc,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <sleep>:
SYSCALL(sleep)
 283:	b8 0d 00 00 00       	mov    $0xd,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <uptime>:
SYSCALL(uptime)
 28b:	b8 0e 00 00 00       	mov    $0xe,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <signal>:
SYSCALL(signal)
 293:	b8 16 00 00 00       	mov    $0x16,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret
 29b:	90                   	nop

0000029c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	57                   	push   %edi
 2a0:	56                   	push   %esi
 2a1:	53                   	push   %ebx
 2a2:	83 ec 3c             	sub    $0x3c,%esp
 2a5:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2a8:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ad:	85 c9                	test   %ecx,%ecx
 2af:	74 04                	je     2b5 <printint+0x19>
 2b1:	85 d2                	test   %edx,%edx
 2b3:	78 6b                	js     320 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2b5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2b8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2bf:	31 c9                	xor    %ecx,%ecx
 2c1:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2c7:	31 d2                	xor    %edx,%edx
 2c9:	f7 f3                	div    %ebx
 2cb:	89 cf                	mov    %ecx,%edi
 2cd:	8d 49 01             	lea    0x1(%ecx),%ecx
 2d0:	8a 92 70 06 00 00    	mov    0x670(%edx),%dl
 2d6:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 2da:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 2dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2e0:	39 da                	cmp    %ebx,%edx
 2e2:	73 e0                	jae    2c4 <printint+0x28>
  if(neg)
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
 2e7:	85 d2                	test   %edx,%edx
 2e9:	74 07                	je     2f2 <printint+0x56>
    buf[i++] = '-';
 2eb:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 2f0:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 2f2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 2f5:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 2f9:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 2fc:	8a 07                	mov    (%edi),%al
 2fe:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 301:	50                   	push   %eax
 302:	6a 01                	push   $0x1
 304:	56                   	push   %esi
 305:	ff 75 c0             	push   -0x40(%ebp)
 308:	e8 06 ff ff ff       	call   213 <write>
  while(--i >= 0)
 30d:	89 f8                	mov    %edi,%eax
 30f:	4f                   	dec    %edi
 310:	83 c4 10             	add    $0x10,%esp
 313:	39 d8                	cmp    %ebx,%eax
 315:	75 e5                	jne    2fc <printint+0x60>
}
 317:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31a:	5b                   	pop    %ebx
 31b:	5e                   	pop    %esi
 31c:	5f                   	pop    %edi
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret
 31f:	90                   	nop
    x = -xx;
 320:	f7 da                	neg    %edx
 322:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 325:	eb 98                	jmp    2bf <printint+0x23>
 327:	90                   	nop

00000328 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	57                   	push   %edi
 32c:	56                   	push   %esi
 32d:	53                   	push   %ebx
 32e:	83 ec 2c             	sub    $0x2c,%esp
 331:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 337:	8a 03                	mov    (%ebx),%al
 339:	84 c0                	test   %al,%al
 33b:	74 2a                	je     367 <printf+0x3f>
 33d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 33e:	8d 4d 10             	lea    0x10(%ebp),%ecx
 341:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 344:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 347:	83 fa 25             	cmp    $0x25,%edx
 34a:	74 24                	je     370 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 34c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 34f:	50                   	push   %eax
 350:	6a 01                	push   $0x1
 352:	8d 45 e7             	lea    -0x19(%ebp),%eax
 355:	50                   	push   %eax
 356:	56                   	push   %esi
 357:	e8 b7 fe ff ff       	call   213 <write>
  for(i = 0; fmt[i]; i++){
 35c:	43                   	inc    %ebx
 35d:	8a 43 ff             	mov    -0x1(%ebx),%al
 360:	83 c4 10             	add    $0x10,%esp
 363:	84 c0                	test   %al,%al
 365:	75 dd                	jne    344 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 367:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36a:	5b                   	pop    %ebx
 36b:	5e                   	pop    %esi
 36c:	5f                   	pop    %edi
 36d:	5d                   	pop    %ebp
 36e:	c3                   	ret
 36f:	90                   	nop
  for(i = 0; fmt[i]; i++){
 370:	8a 13                	mov    (%ebx),%dl
 372:	84 d2                	test   %dl,%dl
 374:	74 f1                	je     367 <printf+0x3f>
    c = fmt[i] & 0xff;
 376:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 379:	80 fa 25             	cmp    $0x25,%dl
 37c:	0f 84 fe 00 00 00    	je     480 <printf+0x158>
 382:	83 e8 63             	sub    $0x63,%eax
 385:	83 f8 15             	cmp    $0x15,%eax
 388:	77 0a                	ja     394 <printf+0x6c>
 38a:	ff 24 85 18 06 00 00 	jmp    *0x618(,%eax,4)
 391:	8d 76 00             	lea    0x0(%esi),%esi
 394:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 397:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 39b:	50                   	push   %eax
 39c:	6a 01                	push   $0x1
 39e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3a1:	57                   	push   %edi
 3a2:	56                   	push   %esi
 3a3:	e8 6b fe ff ff       	call   213 <write>
        putc(fd, c);
 3a8:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3ab:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3ae:	83 c4 0c             	add    $0xc,%esp
 3b1:	6a 01                	push   $0x1
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	e8 59 fe ff ff       	call   213 <write>
  for(i = 0; fmt[i]; i++){
 3ba:	83 c3 02             	add    $0x2,%ebx
 3bd:	8a 43 ff             	mov    -0x1(%ebx),%al
 3c0:	83 c4 10             	add    $0x10,%esp
 3c3:	84 c0                	test   %al,%al
 3c5:	0f 85 79 ff ff ff    	jne    344 <printf+0x1c>
}
 3cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ce:	5b                   	pop    %ebx
 3cf:	5e                   	pop    %esi
 3d0:	5f                   	pop    %edi
 3d1:	5d                   	pop    %ebp
 3d2:	c3                   	ret
 3d3:	90                   	nop
        printint(fd, *ap, 16, 0);
 3d4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3d7:	8b 17                	mov    (%edi),%edx
 3d9:	83 ec 0c             	sub    $0xc,%esp
 3dc:	6a 00                	push   $0x0
 3de:	b9 10 00 00 00       	mov    $0x10,%ecx
 3e3:	89 f0                	mov    %esi,%eax
 3e5:	e8 b2 fe ff ff       	call   29c <printint>
        ap++;
 3ea:	83 c7 04             	add    $0x4,%edi
 3ed:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3f0:	eb c8                	jmp    3ba <printf+0x92>
 3f2:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 3f4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 3f7:	8b 01                	mov    (%ecx),%eax
        ap++;
 3f9:	83 c1 04             	add    $0x4,%ecx
 3fc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 3ff:	85 c0                	test   %eax,%eax
 401:	0f 84 89 00 00 00    	je     490 <printf+0x168>
        while(*s != 0){
 407:	8a 10                	mov    (%eax),%dl
 409:	84 d2                	test   %dl,%dl
 40b:	74 29                	je     436 <printf+0x10e>
 40d:	89 c7                	mov    %eax,%edi
 40f:	88 d0                	mov    %dl,%al
 411:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 414:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 417:	89 fb                	mov    %edi,%ebx
 419:	89 cf                	mov    %ecx,%edi
 41b:	90                   	nop
          putc(fd, *s);
 41c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 41f:	50                   	push   %eax
 420:	6a 01                	push   $0x1
 422:	57                   	push   %edi
 423:	56                   	push   %esi
 424:	e8 ea fd ff ff       	call   213 <write>
          s++;
 429:	43                   	inc    %ebx
        while(*s != 0){
 42a:	8a 03                	mov    (%ebx),%al
 42c:	83 c4 10             	add    $0x10,%esp
 42f:	84 c0                	test   %al,%al
 431:	75 e9                	jne    41c <printf+0xf4>
 433:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 436:	83 c3 02             	add    $0x2,%ebx
 439:	8a 43 ff             	mov    -0x1(%ebx),%al
 43c:	84 c0                	test   %al,%al
 43e:	0f 85 00 ff ff ff    	jne    344 <printf+0x1c>
 444:	e9 1e ff ff ff       	jmp    367 <printf+0x3f>
 449:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 44c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 44f:	8b 17                	mov    (%edi),%edx
 451:	83 ec 0c             	sub    $0xc,%esp
 454:	6a 01                	push   $0x1
 456:	b9 0a 00 00 00       	mov    $0xa,%ecx
 45b:	eb 86                	jmp    3e3 <printf+0xbb>
 45d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 463:	8b 00                	mov    (%eax),%eax
 465:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 468:	51                   	push   %ecx
 469:	6a 01                	push   $0x1
 46b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 46e:	57                   	push   %edi
 46f:	56                   	push   %esi
 470:	e8 9e fd ff ff       	call   213 <write>
        ap++;
 475:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 479:	e9 3c ff ff ff       	jmp    3ba <printf+0x92>
 47e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 480:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 483:	52                   	push   %edx
 484:	6a 01                	push   $0x1
 486:	8d 7d e7             	lea    -0x19(%ebp),%edi
 489:	e9 25 ff ff ff       	jmp    3b3 <printf+0x8b>
 48e:	66 90                	xchg   %ax,%ax
          s = "(null)";
 490:	bf 0f 06 00 00       	mov    $0x60f,%edi
 495:	b0 28                	mov    $0x28,%al
 497:	e9 75 ff ff ff       	jmp    411 <printf+0xe9>

0000049c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 49c:	55                   	push   %ebp
 49d:	89 e5                	mov    %esp,%ebp
 49f:	57                   	push   %edi
 4a0:	56                   	push   %esi
 4a1:	53                   	push   %ebx
 4a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4a5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4a8:	a1 84 06 00 00       	mov    0x684,%eax
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
 4b0:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4b2:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4b4:	39 ca                	cmp    %ecx,%edx
 4b6:	73 2c                	jae    4e4 <free+0x48>
 4b8:	39 c1                	cmp    %eax,%ecx
 4ba:	72 04                	jb     4c0 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4bc:	39 c2                	cmp    %eax,%edx
 4be:	72 f0                	jb     4b0 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4c3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4c6:	39 f8                	cmp    %edi,%eax
 4c8:	74 2c                	je     4f6 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4ca:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4cd:	8b 42 04             	mov    0x4(%edx),%eax
 4d0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4d3:	39 f1                	cmp    %esi,%ecx
 4d5:	74 36                	je     50d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 4d7:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 4d9:	89 15 84 06 00 00    	mov    %edx,0x684
}
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5f                   	pop    %edi
 4e2:	5d                   	pop    %ebp
 4e3:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e4:	39 c2                	cmp    %eax,%edx
 4e6:	72 c8                	jb     4b0 <free+0x14>
 4e8:	39 c1                	cmp    %eax,%ecx
 4ea:	73 c4                	jae    4b0 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 4ec:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ef:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f2:	39 f8                	cmp    %edi,%eax
 4f4:	75 d4                	jne    4ca <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 4f6:	03 70 04             	add    0x4(%eax),%esi
 4f9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4fc:	8b 02                	mov    (%edx),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 503:	8b 42 04             	mov    0x4(%edx),%eax
 506:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 509:	39 f1                	cmp    %esi,%ecx
 50b:	75 ca                	jne    4d7 <free+0x3b>
    p->s.size += bp->s.size;
 50d:	03 43 fc             	add    -0x4(%ebx),%eax
 510:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 513:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 516:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 518:	89 15 84 06 00 00    	mov    %edx,0x684
}
 51e:	5b                   	pop    %ebx
 51f:	5e                   	pop    %esi
 520:	5f                   	pop    %edi
 521:	5d                   	pop    %ebp
 522:	c3                   	ret
 523:	90                   	nop

00000524 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	57                   	push   %edi
 528:	56                   	push   %esi
 529:	53                   	push   %ebx
 52a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	8d 78 07             	lea    0x7(%eax),%edi
 533:	c1 ef 03             	shr    $0x3,%edi
 536:	47                   	inc    %edi
  if((prevp = freep) == 0){
 537:	8b 15 84 06 00 00    	mov    0x684,%edx
 53d:	85 d2                	test   %edx,%edx
 53f:	0f 84 93 00 00 00    	je     5d8 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 545:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 547:	8b 48 04             	mov    0x4(%eax),%ecx
 54a:	39 f9                	cmp    %edi,%ecx
 54c:	73 62                	jae    5b0 <malloc+0x8c>
  if(nu < 4096)
 54e:	89 fb                	mov    %edi,%ebx
 550:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 556:	72 78                	jb     5d0 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 558:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 55f:	eb 0e                	jmp    56f <malloc+0x4b>
 561:	8d 76 00             	lea    0x0(%esi),%esi
 564:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 566:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 568:	8b 48 04             	mov    0x4(%eax),%ecx
 56b:	39 f9                	cmp    %edi,%ecx
 56d:	73 41                	jae    5b0 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 56f:	39 05 84 06 00 00    	cmp    %eax,0x684
 575:	75 ed                	jne    564 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 577:	83 ec 0c             	sub    $0xc,%esp
 57a:	56                   	push   %esi
 57b:	e8 fb fc ff ff       	call   27b <sbrk>
  if(p == (char*)-1)
 580:	83 c4 10             	add    $0x10,%esp
 583:	83 f8 ff             	cmp    $0xffffffff,%eax
 586:	74 1c                	je     5a4 <malloc+0x80>
  hp->s.size = nu;
 588:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 58b:	83 ec 0c             	sub    $0xc,%esp
 58e:	83 c0 08             	add    $0x8,%eax
 591:	50                   	push   %eax
 592:	e8 05 ff ff ff       	call   49c <free>
  return freep;
 597:	8b 15 84 06 00 00    	mov    0x684,%edx
      if((p = morecore(nunits)) == 0)
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	85 d2                	test   %edx,%edx
 5a2:	75 c2                	jne    566 <malloc+0x42>
        return 0;
 5a4:	31 c0                	xor    %eax,%eax
  }
}
 5a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a9:	5b                   	pop    %ebx
 5aa:	5e                   	pop    %esi
 5ab:	5f                   	pop    %edi
 5ac:	5d                   	pop    %ebp
 5ad:	c3                   	ret
 5ae:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5b0:	39 cf                	cmp    %ecx,%edi
 5b2:	74 4c                	je     600 <malloc+0xdc>
        p->s.size -= nunits;
 5b4:	29 f9                	sub    %edi,%ecx
 5b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5bf:	89 15 84 06 00 00    	mov    %edx,0x684
      return (void*)(p + 1);
 5c5:	83 c0 08             	add    $0x8,%eax
}
 5c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cb:	5b                   	pop    %ebx
 5cc:	5e                   	pop    %esi
 5cd:	5f                   	pop    %edi
 5ce:	5d                   	pop    %ebp
 5cf:	c3                   	ret
  if(nu < 4096)
 5d0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 5d5:	eb 81                	jmp    558 <malloc+0x34>
 5d7:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 5d8:	c7 05 84 06 00 00 88 	movl   $0x688,0x684
 5df:	06 00 00 
 5e2:	c7 05 88 06 00 00 88 	movl   $0x688,0x688
 5e9:	06 00 00 
    base.s.size = 0;
 5ec:	c7 05 8c 06 00 00 00 	movl   $0x0,0x68c
 5f3:	00 00 00 
 5f6:	b8 88 06 00 00       	mov    $0x688,%eax
 5fb:	e9 4e ff ff ff       	jmp    54e <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 600:	8b 08                	mov    (%eax),%ecx
 602:	89 0a                	mov    %ecx,(%edx)
 604:	eb b9                	jmp    5bf <malloc+0x9b>
