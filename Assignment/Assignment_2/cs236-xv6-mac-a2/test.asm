
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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int count = 0;
   f:	31 db                	xor    %ebx,%ebx
  11:	8d 76 00             	lea    0x0(%esi),%esi
    while (1) {
        printf(1, "Hello %d \n", count);
  14:	50                   	push   %eax
  15:	53                   	push   %ebx
  16:	68 1c 06 00 00       	push   $0x61c
  1b:	6a 01                	push   $0x1
  1d:	e8 1a 03 00 00       	call   33c <printf>
        count++;
  22:	43                   	inc    %ebx
        sleep(100);
  23:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  2a:	e8 58 02 00 00       	call   287 <sleep>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	eb e0                	jmp    14 <main+0x14>

00000034 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	53                   	push   %ebx
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3e:	31 c0                	xor    %eax,%eax
  40:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  43:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  46:	40                   	inc    %eax
  47:	84 d2                	test   %dl,%dl
  49:	75 f5                	jne    40 <strcpy+0xc>
    ;
  return os;
}
  4b:	89 c8                	mov    %ecx,%eax
  4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  50:	c9                   	leave
  51:	c3                   	ret
  52:	66 90                	xchg   %ax,%ax

00000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	53                   	push   %ebx
  58:	8b 55 08             	mov    0x8(%ebp),%edx
  5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  5e:	0f b6 02             	movzbl (%edx),%eax
  61:	84 c0                	test   %al,%al
  63:	75 10                	jne    75 <strcmp+0x21>
  65:	eb 2a                	jmp    91 <strcmp+0x3d>
  67:	90                   	nop
    p++, q++;
  68:	42                   	inc    %edx
  69:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  6c:	0f b6 02             	movzbl (%edx),%eax
  6f:	84 c0                	test   %al,%al
  71:	74 11                	je     84 <strcmp+0x30>
  73:	89 cb                	mov    %ecx,%ebx
  75:	0f b6 0b             	movzbl (%ebx),%ecx
  78:	38 c1                	cmp    %al,%cl
  7a:	74 ec                	je     68 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  7c:	29 c8                	sub    %ecx,%eax
}
  7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  81:	c9                   	leave
  82:	c3                   	ret
  83:	90                   	nop
  return (uchar)*p - (uchar)*q;
  84:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  88:	31 c0                	xor    %eax,%eax
  8a:	29 c8                	sub    %ecx,%eax
}
  8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8f:	c9                   	leave
  90:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  91:	0f b6 0b             	movzbl (%ebx),%ecx
  94:	31 c0                	xor    %eax,%eax
  96:	eb e4                	jmp    7c <strcmp+0x28>

00000098 <strlen>:

uint
strlen(const char *s)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  9e:	80 3a 00             	cmpb   $0x0,(%edx)
  a1:	74 15                	je     b8 <strlen+0x20>
  a3:	31 c0                	xor    %eax,%eax
  a5:	8d 76 00             	lea    0x0(%esi),%esi
  a8:	40                   	inc    %eax
  a9:	89 c1                	mov    %eax,%ecx
  ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  af:	75 f7                	jne    a8 <strlen+0x10>
    ;
  return n;
}
  b1:	89 c8                	mov    %ecx,%eax
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret
  b5:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  b8:	31 c9                	xor    %ecx,%ecx
}
  ba:	89 c8                	mov    %ecx,%eax
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret
  be:	66 90                	xchg   %ax,%ax

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	fc                   	cld
  ce:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d6:	c9                   	leave
  d7:	c3                   	ret

000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  e1:	8a 10                	mov    (%eax),%dl
  e3:	84 d2                	test   %dl,%dl
  e5:	75 0c                	jne    f3 <strchr+0x1b>
  e7:	eb 13                	jmp    fc <strchr+0x24>
  e9:	8d 76 00             	lea    0x0(%esi),%esi
  ec:	40                   	inc    %eax
  ed:	8a 10                	mov    (%eax),%dl
  ef:	84 d2                	test   %dl,%dl
  f1:	74 09                	je     fc <strchr+0x24>
    if(*s == c)
  f3:	38 d1                	cmp    %dl,%cl
  f5:	75 f5                	jne    ec <strchr+0x14>
      return (char*)s;
  return 0;
}
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret
  f9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  fc:	31 c0                	xor    %eax,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret

00000100 <gets>:

char*
gets(char *buf, int max)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 109:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 10b:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 10e:	eb 24                	jmp    134 <gets+0x34>
    cc = read(0, &c, 1);
 110:	50                   	push   %eax
 111:	6a 01                	push   $0x1
 113:	56                   	push   %esi
 114:	6a 00                	push   $0x0
 116:	e8 f4 00 00 00       	call   20f <read>
    if(cc < 1)
 11b:	83 c4 10             	add    $0x10,%esp
 11e:	85 c0                	test   %eax,%eax
 120:	7e 1a                	jle    13c <gets+0x3c>
      break;
    buf[i++] = c;
 122:	8a 45 e7             	mov    -0x19(%ebp),%al
 125:	8b 55 08             	mov    0x8(%ebp),%edx
 128:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 12c:	3c 0a                	cmp    $0xa,%al
 12e:	74 0e                	je     13e <gets+0x3e>
 130:	3c 0d                	cmp    $0xd,%al
 132:	74 0a                	je     13e <gets+0x3e>
  for(i=0; i+1 < max; ){
 134:	89 df                	mov    %ebx,%edi
 136:	43                   	inc    %ebx
 137:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 13a:	7c d4                	jl     110 <gets+0x10>
 13c:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
 141:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 145:	8d 65 f4             	lea    -0xc(%ebp),%esp
 148:	5b                   	pop    %ebx
 149:	5e                   	pop    %esi
 14a:	5f                   	pop    %edi
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret
 14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <stat>:

int
stat(const char *n, struct stat *st)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	56                   	push   %esi
 154:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 155:	83 ec 08             	sub    $0x8,%esp
 158:	6a 00                	push   $0x0
 15a:	ff 75 08             	push   0x8(%ebp)
 15d:	e8 d5 00 00 00       	call   237 <open>
  if(fd < 0)
 162:	83 c4 10             	add    $0x10,%esp
 165:	85 c0                	test   %eax,%eax
 167:	78 27                	js     190 <stat+0x40>
 169:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	ff 75 0c             	push   0xc(%ebp)
 171:	50                   	push   %eax
 172:	e8 d8 00 00 00       	call   24f <fstat>
 177:	89 c6                	mov    %eax,%esi
  close(fd);
 179:	89 1c 24             	mov    %ebx,(%esp)
 17c:	e8 9e 00 00 00       	call   21f <close>
  return r;
 181:	83 c4 10             	add    $0x10,%esp
}
 184:	89 f0                	mov    %esi,%eax
 186:	8d 65 f8             	lea    -0x8(%ebp),%esp
 189:	5b                   	pop    %ebx
 18a:	5e                   	pop    %esi
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret
 18d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 190:	be ff ff ff ff       	mov    $0xffffffff,%esi
 195:	eb ed                	jmp    184 <stat+0x34>
 197:	90                   	nop

00000198 <atoi>:

int
atoi(const char *s)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	53                   	push   %ebx
 19c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19f:	0f be 01             	movsbl (%ecx),%eax
 1a2:	8d 50 d0             	lea    -0x30(%eax),%edx
 1a5:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1a8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ad:	77 16                	ja     1c5 <atoi+0x2d>
 1af:	90                   	nop
    n = n*10 + *s++ - '0';
 1b0:	41                   	inc    %ecx
 1b1:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1b4:	01 d2                	add    %edx,%edx
 1b6:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1ba:	0f be 01             	movsbl (%ecx),%eax
 1bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1c0:	80 fb 09             	cmp    $0x9,%bl
 1c3:	76 eb                	jbe    1b0 <atoi+0x18>
  return n;
}
 1c5:	89 d0                	mov    %edx,%eax
 1c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ca:	c9                   	leave
 1cb:	c3                   	ret

000001cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	8b 55 08             	mov    0x8(%ebp),%edx
 1d4:	8b 75 0c             	mov    0xc(%ebp),%esi
 1d7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1da:	85 c0                	test   %eax,%eax
 1dc:	7e 0b                	jle    1e9 <memmove+0x1d>
 1de:	01 d0                	add    %edx,%eax
  dst = vdst;
 1e0:	89 d7                	mov    %edx,%edi
 1e2:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1e4:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1e5:	39 f8                	cmp    %edi,%eax
 1e7:	75 fb                	jne    1e4 <memmove+0x18>
  return vdst;
}
 1e9:	89 d0                	mov    %edx,%eax
 1eb:	5e                   	pop    %esi
 1ec:	5f                   	pop    %edi
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret

000001ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ef:	b8 01 00 00 00       	mov    $0x1,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret

000001f7 <exit>:
SYSCALL(exit)
 1f7:	b8 02 00 00 00       	mov    $0x2,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret

000001ff <wait>:
SYSCALL(wait)
 1ff:	b8 03 00 00 00       	mov    $0x3,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret

00000207 <pipe>:
SYSCALL(pipe)
 207:	b8 04 00 00 00       	mov    $0x4,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret

0000020f <read>:
SYSCALL(read)
 20f:	b8 05 00 00 00       	mov    $0x5,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret

00000217 <write>:
SYSCALL(write)
 217:	b8 10 00 00 00       	mov    $0x10,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret

0000021f <close>:
SYSCALL(close)
 21f:	b8 15 00 00 00       	mov    $0x15,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret

00000227 <kill>:
SYSCALL(kill)
 227:	b8 06 00 00 00       	mov    $0x6,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret

0000022f <exec>:
SYSCALL(exec)
 22f:	b8 07 00 00 00       	mov    $0x7,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret

00000237 <open>:
SYSCALL(open)
 237:	b8 0f 00 00 00       	mov    $0xf,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret

0000023f <mknod>:
SYSCALL(mknod)
 23f:	b8 11 00 00 00       	mov    $0x11,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret

00000247 <unlink>:
SYSCALL(unlink)
 247:	b8 12 00 00 00       	mov    $0x12,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret

0000024f <fstat>:
SYSCALL(fstat)
 24f:	b8 08 00 00 00       	mov    $0x8,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret

00000257 <link>:
SYSCALL(link)
 257:	b8 13 00 00 00       	mov    $0x13,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret

0000025f <mkdir>:
SYSCALL(mkdir)
 25f:	b8 14 00 00 00       	mov    $0x14,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret

00000267 <chdir>:
SYSCALL(chdir)
 267:	b8 09 00 00 00       	mov    $0x9,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret

0000026f <dup>:
SYSCALL(dup)
 26f:	b8 0a 00 00 00       	mov    $0xa,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <getpid>:
SYSCALL(getpid)
 277:	b8 0b 00 00 00       	mov    $0xb,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <sbrk>:
SYSCALL(sbrk)
 27f:	b8 0c 00 00 00       	mov    $0xc,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <sleep>:
SYSCALL(sleep)
 287:	b8 0d 00 00 00       	mov    $0xd,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <uptime>:
SYSCALL(uptime)
 28f:	b8 0e 00 00 00       	mov    $0xe,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <signal>:
SYSCALL(signal)
 297:	b8 16 00 00 00       	mov    $0x16,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <custom_fork>:
SYSCALL(custom_fork)
 29f:	b8 17 00 00 00       	mov    $0x17,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <scheduler_start>:
 2a7:	b8 18 00 00 00       	mov    $0x18,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret
 2af:	90                   	nop

000002b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
 2b6:	83 ec 3c             	sub    $0x3c,%esp
 2b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2bc:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2be:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2c1:	85 c9                	test   %ecx,%ecx
 2c3:	74 04                	je     2c9 <printint+0x19>
 2c5:	85 d2                	test   %edx,%edx
 2c7:	78 6b                	js     334 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2c9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2cc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2d3:	31 c9                	xor    %ecx,%ecx
 2d5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2db:	31 d2                	xor    %edx,%edx
 2dd:	f7 f3                	div    %ebx
 2df:	89 cf                	mov    %ecx,%edi
 2e1:	8d 49 01             	lea    0x1(%ecx),%ecx
 2e4:	8a 92 88 06 00 00    	mov    0x688(%edx),%dl
 2ea:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 2ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 2f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2f4:	39 da                	cmp    %ebx,%edx
 2f6:	73 e0                	jae    2d8 <printint+0x28>
  if(neg)
 2f8:	8b 55 08             	mov    0x8(%ebp),%edx
 2fb:	85 d2                	test   %edx,%edx
 2fd:	74 07                	je     306 <printint+0x56>
    buf[i++] = '-';
 2ff:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 304:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 306:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 309:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 310:	8a 07                	mov    (%edi),%al
 312:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 315:	50                   	push   %eax
 316:	6a 01                	push   $0x1
 318:	56                   	push   %esi
 319:	ff 75 c0             	push   -0x40(%ebp)
 31c:	e8 f6 fe ff ff       	call   217 <write>
  while(--i >= 0)
 321:	89 f8                	mov    %edi,%eax
 323:	4f                   	dec    %edi
 324:	83 c4 10             	add    $0x10,%esp
 327:	39 d8                	cmp    %ebx,%eax
 329:	75 e5                	jne    310 <printint+0x60>
}
 32b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32e:	5b                   	pop    %ebx
 32f:	5e                   	pop    %esi
 330:	5f                   	pop    %edi
 331:	5d                   	pop    %ebp
 332:	c3                   	ret
 333:	90                   	nop
    x = -xx;
 334:	f7 da                	neg    %edx
 336:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 339:	eb 98                	jmp    2d3 <printint+0x23>
 33b:	90                   	nop

0000033c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	57                   	push   %edi
 340:	56                   	push   %esi
 341:	53                   	push   %ebx
 342:	83 ec 2c             	sub    $0x2c,%esp
 345:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 348:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 34b:	8a 03                	mov    (%ebx),%al
 34d:	84 c0                	test   %al,%al
 34f:	74 2a                	je     37b <printf+0x3f>
 351:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 352:	8d 4d 10             	lea    0x10(%ebp),%ecx
 355:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 358:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 35b:	83 fa 25             	cmp    $0x25,%edx
 35e:	74 24                	je     384 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 360:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 363:	50                   	push   %eax
 364:	6a 01                	push   $0x1
 366:	8d 45 e7             	lea    -0x19(%ebp),%eax
 369:	50                   	push   %eax
 36a:	56                   	push   %esi
 36b:	e8 a7 fe ff ff       	call   217 <write>
  for(i = 0; fmt[i]; i++){
 370:	43                   	inc    %ebx
 371:	8a 43 ff             	mov    -0x1(%ebx),%al
 374:	83 c4 10             	add    $0x10,%esp
 377:	84 c0                	test   %al,%al
 379:	75 dd                	jne    358 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 37b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37e:	5b                   	pop    %ebx
 37f:	5e                   	pop    %esi
 380:	5f                   	pop    %edi
 381:	5d                   	pop    %ebp
 382:	c3                   	ret
 383:	90                   	nop
  for(i = 0; fmt[i]; i++){
 384:	8a 13                	mov    (%ebx),%dl
 386:	84 d2                	test   %dl,%dl
 388:	74 f1                	je     37b <printf+0x3f>
    c = fmt[i] & 0xff;
 38a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 38d:	80 fa 25             	cmp    $0x25,%dl
 390:	0f 84 fe 00 00 00    	je     494 <printf+0x158>
 396:	83 e8 63             	sub    $0x63,%eax
 399:	83 f8 15             	cmp    $0x15,%eax
 39c:	77 0a                	ja     3a8 <printf+0x6c>
 39e:	ff 24 85 30 06 00 00 	jmp    *0x630(,%eax,4)
 3a5:	8d 76 00             	lea    0x0(%esi),%esi
 3a8:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3ab:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3af:	50                   	push   %eax
 3b0:	6a 01                	push   $0x1
 3b2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3b5:	57                   	push   %edi
 3b6:	56                   	push   %esi
 3b7:	e8 5b fe ff ff       	call   217 <write>
        putc(fd, c);
 3bc:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3bf:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3c2:	83 c4 0c             	add    $0xc,%esp
 3c5:	6a 01                	push   $0x1
 3c7:	57                   	push   %edi
 3c8:	56                   	push   %esi
 3c9:	e8 49 fe ff ff       	call   217 <write>
  for(i = 0; fmt[i]; i++){
 3ce:	83 c3 02             	add    $0x2,%ebx
 3d1:	8a 43 ff             	mov    -0x1(%ebx),%al
 3d4:	83 c4 10             	add    $0x10,%esp
 3d7:	84 c0                	test   %al,%al
 3d9:	0f 85 79 ff ff ff    	jne    358 <printf+0x1c>
}
 3df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e2:	5b                   	pop    %ebx
 3e3:	5e                   	pop    %esi
 3e4:	5f                   	pop    %edi
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret
 3e7:	90                   	nop
        printint(fd, *ap, 16, 0);
 3e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3eb:	8b 17                	mov    (%edi),%edx
 3ed:	83 ec 0c             	sub    $0xc,%esp
 3f0:	6a 00                	push   $0x0
 3f2:	b9 10 00 00 00       	mov    $0x10,%ecx
 3f7:	89 f0                	mov    %esi,%eax
 3f9:	e8 b2 fe ff ff       	call   2b0 <printint>
        ap++;
 3fe:	83 c7 04             	add    $0x4,%edi
 401:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 404:	eb c8                	jmp    3ce <printf+0x92>
 406:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 408:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 40b:	8b 01                	mov    (%ecx),%eax
        ap++;
 40d:	83 c1 04             	add    $0x4,%ecx
 410:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 413:	85 c0                	test   %eax,%eax
 415:	0f 84 89 00 00 00    	je     4a4 <printf+0x168>
        while(*s != 0){
 41b:	8a 10                	mov    (%eax),%dl
 41d:	84 d2                	test   %dl,%dl
 41f:	74 29                	je     44a <printf+0x10e>
 421:	89 c7                	mov    %eax,%edi
 423:	88 d0                	mov    %dl,%al
 425:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 428:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 42b:	89 fb                	mov    %edi,%ebx
 42d:	89 cf                	mov    %ecx,%edi
 42f:	90                   	nop
          putc(fd, *s);
 430:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 433:	50                   	push   %eax
 434:	6a 01                	push   $0x1
 436:	57                   	push   %edi
 437:	56                   	push   %esi
 438:	e8 da fd ff ff       	call   217 <write>
          s++;
 43d:	43                   	inc    %ebx
        while(*s != 0){
 43e:	8a 03                	mov    (%ebx),%al
 440:	83 c4 10             	add    $0x10,%esp
 443:	84 c0                	test   %al,%al
 445:	75 e9                	jne    430 <printf+0xf4>
 447:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 44a:	83 c3 02             	add    $0x2,%ebx
 44d:	8a 43 ff             	mov    -0x1(%ebx),%al
 450:	84 c0                	test   %al,%al
 452:	0f 85 00 ff ff ff    	jne    358 <printf+0x1c>
 458:	e9 1e ff ff ff       	jmp    37b <printf+0x3f>
 45d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 460:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 463:	8b 17                	mov    (%edi),%edx
 465:	83 ec 0c             	sub    $0xc,%esp
 468:	6a 01                	push   $0x1
 46a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 46f:	eb 86                	jmp    3f7 <printf+0xbb>
 471:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 474:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 477:	8b 00                	mov    (%eax),%eax
 479:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 47c:	51                   	push   %ecx
 47d:	6a 01                	push   $0x1
 47f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 482:	57                   	push   %edi
 483:	56                   	push   %esi
 484:	e8 8e fd ff ff       	call   217 <write>
        ap++;
 489:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 48d:	e9 3c ff ff ff       	jmp    3ce <printf+0x92>
 492:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 494:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 497:	52                   	push   %edx
 498:	6a 01                	push   $0x1
 49a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 49d:	e9 25 ff ff ff       	jmp    3c7 <printf+0x8b>
 4a2:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4a4:	bf 27 06 00 00       	mov    $0x627,%edi
 4a9:	b0 28                	mov    $0x28,%al
 4ab:	e9 75 ff ff ff       	jmp    425 <printf+0xe9>

000004b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4b9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4bc:	a1 9c 06 00 00       	mov    0x69c,%eax
 4c1:	8d 76 00             	lea    0x0(%esi),%esi
 4c4:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4c6:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c8:	39 ca                	cmp    %ecx,%edx
 4ca:	73 2c                	jae    4f8 <free+0x48>
 4cc:	39 c1                	cmp    %eax,%ecx
 4ce:	72 04                	jb     4d4 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d0:	39 c2                	cmp    %eax,%edx
 4d2:	72 f0                	jb     4c4 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4d4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4d7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4da:	39 f8                	cmp    %edi,%eax
 4dc:	74 2c                	je     50a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4de:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4e1:	8b 42 04             	mov    0x4(%edx),%eax
 4e4:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4e7:	39 f1                	cmp    %esi,%ecx
 4e9:	74 36                	je     521 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 4eb:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 4ed:	89 15 9c 06 00 00    	mov    %edx,0x69c
}
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f8:	39 c2                	cmp    %eax,%edx
 4fa:	72 c8                	jb     4c4 <free+0x14>
 4fc:	39 c1                	cmp    %eax,%ecx
 4fe:	73 c4                	jae    4c4 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 500:	8b 73 fc             	mov    -0x4(%ebx),%esi
 503:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 506:	39 f8                	cmp    %edi,%eax
 508:	75 d4                	jne    4de <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 50a:	03 70 04             	add    0x4(%eax),%esi
 50d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 510:	8b 02                	mov    (%edx),%eax
 512:	8b 00                	mov    (%eax),%eax
 514:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 517:	8b 42 04             	mov    0x4(%edx),%eax
 51a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 51d:	39 f1                	cmp    %esi,%ecx
 51f:	75 ca                	jne    4eb <free+0x3b>
    p->s.size += bp->s.size;
 521:	03 43 fc             	add    -0x4(%ebx),%eax
 524:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 527:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 52a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 52c:	89 15 9c 06 00 00    	mov    %edx,0x69c
}
 532:	5b                   	pop    %ebx
 533:	5e                   	pop    %esi
 534:	5f                   	pop    %edi
 535:	5d                   	pop    %ebp
 536:	c3                   	ret
 537:	90                   	nop

00000538 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 538:	55                   	push   %ebp
 539:	89 e5                	mov    %esp,%ebp
 53b:	57                   	push   %edi
 53c:	56                   	push   %esi
 53d:	53                   	push   %ebx
 53e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	8d 78 07             	lea    0x7(%eax),%edi
 547:	c1 ef 03             	shr    $0x3,%edi
 54a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 54b:	8b 15 9c 06 00 00    	mov    0x69c,%edx
 551:	85 d2                	test   %edx,%edx
 553:	0f 84 93 00 00 00    	je     5ec <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 559:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 55b:	8b 48 04             	mov    0x4(%eax),%ecx
 55e:	39 f9                	cmp    %edi,%ecx
 560:	73 62                	jae    5c4 <malloc+0x8c>
  if(nu < 4096)
 562:	89 fb                	mov    %edi,%ebx
 564:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 56a:	72 78                	jb     5e4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 56c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 573:	eb 0e                	jmp    583 <malloc+0x4b>
 575:	8d 76 00             	lea    0x0(%esi),%esi
 578:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 57a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 57c:	8b 48 04             	mov    0x4(%eax),%ecx
 57f:	39 f9                	cmp    %edi,%ecx
 581:	73 41                	jae    5c4 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 583:	39 05 9c 06 00 00    	cmp    %eax,0x69c
 589:	75 ed                	jne    578 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 58b:	83 ec 0c             	sub    $0xc,%esp
 58e:	56                   	push   %esi
 58f:	e8 eb fc ff ff       	call   27f <sbrk>
  if(p == (char*)-1)
 594:	83 c4 10             	add    $0x10,%esp
 597:	83 f8 ff             	cmp    $0xffffffff,%eax
 59a:	74 1c                	je     5b8 <malloc+0x80>
  hp->s.size = nu;
 59c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 59f:	83 ec 0c             	sub    $0xc,%esp
 5a2:	83 c0 08             	add    $0x8,%eax
 5a5:	50                   	push   %eax
 5a6:	e8 05 ff ff ff       	call   4b0 <free>
  return freep;
 5ab:	8b 15 9c 06 00 00    	mov    0x69c,%edx
      if((p = morecore(nunits)) == 0)
 5b1:	83 c4 10             	add    $0x10,%esp
 5b4:	85 d2                	test   %edx,%edx
 5b6:	75 c2                	jne    57a <malloc+0x42>
        return 0;
 5b8:	31 c0                	xor    %eax,%eax
  }
}
 5ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bd:	5b                   	pop    %ebx
 5be:	5e                   	pop    %esi
 5bf:	5f                   	pop    %edi
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret
 5c2:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5c4:	39 cf                	cmp    %ecx,%edi
 5c6:	74 4c                	je     614 <malloc+0xdc>
        p->s.size -= nunits;
 5c8:	29 f9                	sub    %edi,%ecx
 5ca:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5cd:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5d0:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5d3:	89 15 9c 06 00 00    	mov    %edx,0x69c
      return (void*)(p + 1);
 5d9:	83 c0 08             	add    $0x8,%eax
}
 5dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5f                   	pop    %edi
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret
  if(nu < 4096)
 5e4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 5e9:	eb 81                	jmp    56c <malloc+0x34>
 5eb:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 5ec:	c7 05 9c 06 00 00 a0 	movl   $0x6a0,0x69c
 5f3:	06 00 00 
 5f6:	c7 05 a0 06 00 00 a0 	movl   $0x6a0,0x6a0
 5fd:	06 00 00 
    base.s.size = 0;
 600:	c7 05 a4 06 00 00 00 	movl   $0x0,0x6a4
 607:	00 00 00 
 60a:	b8 a0 06 00 00       	mov    $0x6a0,%eax
 60f:	e9 4e ff ff ff       	jmp    562 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 614:	8b 08                	mov    (%eax),%ecx
 616:	89 0a                	mov    %ecx,(%edx)
 618:	eb b9                	jmp    5d3 <malloc+0x9b>
