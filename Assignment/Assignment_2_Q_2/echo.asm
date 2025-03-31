
_echo:     file format elf32-i386


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
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 41                	jle    5f <main+0x5f>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1e:	8b 47 04             	mov    0x4(%edi),%eax
  21:	83 fe 02             	cmp    $0x2,%esi
  24:	74 24                	je     4a <main+0x4a>
  26:	bb 02 00 00 00       	mov    $0x2,%ebx
  2b:	90                   	nop
  2c:	68 44 06 00 00       	push   $0x644
  31:	50                   	push   %eax
  32:	68 46 06 00 00       	push   $0x646
  37:	6a 01                	push   $0x1
  39:	e8 26 03 00 00       	call   364 <printf>
  3e:	43                   	inc    %ebx
  3f:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  43:	83 c4 10             	add    $0x10,%esp
  46:	39 de                	cmp    %ebx,%esi
  48:	75 e2                	jne    2c <main+0x2c>
  4a:	68 4b 06 00 00       	push   $0x64b
  4f:	50                   	push   %eax
  50:	68 46 06 00 00       	push   $0x646
  55:	6a 01                	push   $0x1
  57:	e8 08 03 00 00       	call   364 <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  exit();
  5f:	e8 c3 01 00 00       	call   227 <exit>

00000064 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	53                   	push   %ebx
  68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	31 c0                	xor    %eax,%eax
  70:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  73:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  76:	40                   	inc    %eax
  77:	84 d2                	test   %dl,%dl
  79:	75 f5                	jne    70 <strcpy+0xc>
    ;
  return os;
}
  7b:	89 c8                	mov    %ecx,%eax
  7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80:	c9                   	leave
  81:	c3                   	ret
  82:	66 90                	xchg   %ax,%ax

00000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	8b 55 08             	mov    0x8(%ebp),%edx
  8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  8e:	0f b6 02             	movzbl (%edx),%eax
  91:	84 c0                	test   %al,%al
  93:	75 10                	jne    a5 <strcmp+0x21>
  95:	eb 2a                	jmp    c1 <strcmp+0x3d>
  97:	90                   	nop
    p++, q++;
  98:	42                   	inc    %edx
  99:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  9c:	0f b6 02             	movzbl (%edx),%eax
  9f:	84 c0                	test   %al,%al
  a1:	74 11                	je     b4 <strcmp+0x30>
  a3:	89 cb                	mov    %ecx,%ebx
  a5:	0f b6 0b             	movzbl (%ebx),%ecx
  a8:	38 c1                	cmp    %al,%cl
  aa:	74 ec                	je     98 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ac:	29 c8                	sub    %ecx,%eax
}
  ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b1:	c9                   	leave
  b2:	c3                   	ret
  b3:	90                   	nop
  return (uchar)*p - (uchar)*q;
  b4:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  b8:	31 c0                	xor    %eax,%eax
  ba:	29 c8                	sub    %ecx,%eax
}
  bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  bf:	c9                   	leave
  c0:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  c1:	0f b6 0b             	movzbl (%ebx),%ecx
  c4:	31 c0                	xor    %eax,%eax
  c6:	eb e4                	jmp    ac <strcmp+0x28>

000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ce:	80 3a 00             	cmpb   $0x0,(%edx)
  d1:	74 15                	je     e8 <strlen+0x20>
  d3:	31 c0                	xor    %eax,%eax
  d5:	8d 76 00             	lea    0x0(%esi),%esi
  d8:	40                   	inc    %eax
  d9:	89 c1                	mov    %eax,%ecx
  db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  df:	75 f7                	jne    d8 <strlen+0x10>
    ;
  return n;
}
  e1:	89 c8                	mov    %ecx,%eax
  e3:	5d                   	pop    %ebp
  e4:	c3                   	ret
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e8:	31 c9                	xor    %ecx,%ecx
}
  ea:	89 c8                	mov    %ecx,%eax
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret
  ee:	66 90                	xchg   %ax,%ax

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	fc                   	cld
  fe:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	8b 7d fc             	mov    -0x4(%ebp),%edi
 106:	c9                   	leave
 107:	c3                   	ret

00000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 111:	8a 10                	mov    (%eax),%dl
 113:	84 d2                	test   %dl,%dl
 115:	75 0c                	jne    123 <strchr+0x1b>
 117:	eb 13                	jmp    12c <strchr+0x24>
 119:	8d 76 00             	lea    0x0(%esi),%esi
 11c:	40                   	inc    %eax
 11d:	8a 10                	mov    (%eax),%dl
 11f:	84 d2                	test   %dl,%dl
 121:	74 09                	je     12c <strchr+0x24>
    if(*s == c)
 123:	38 d1                	cmp    %dl,%cl
 125:	75 f5                	jne    11c <strchr+0x14>
      return (char*)s;
  return 0;
}
 127:	5d                   	pop    %ebp
 128:	c3                   	ret
 129:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 12c:	31 c0                	xor    %eax,%eax
}
 12e:	5d                   	pop    %ebp
 12f:	c3                   	ret

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
 135:	53                   	push   %ebx
 136:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 139:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 13b:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 13e:	eb 24                	jmp    164 <gets+0x34>
    cc = read(0, &c, 1);
 140:	50                   	push   %eax
 141:	6a 01                	push   $0x1
 143:	56                   	push   %esi
 144:	6a 00                	push   $0x0
 146:	e8 f4 00 00 00       	call   23f <read>
    if(cc < 1)
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	7e 1a                	jle    16c <gets+0x3c>
      break;
    buf[i++] = c;
 152:	8a 45 e7             	mov    -0x19(%ebp),%al
 155:	8b 55 08             	mov    0x8(%ebp),%edx
 158:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 15c:	3c 0a                	cmp    $0xa,%al
 15e:	74 0e                	je     16e <gets+0x3e>
 160:	3c 0d                	cmp    $0xd,%al
 162:	74 0a                	je     16e <gets+0x3e>
  for(i=0; i+1 < max; ){
 164:	89 df                	mov    %ebx,%edi
 166:	43                   	inc    %ebx
 167:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 16a:	7c d4                	jl     140 <gets+0x10>
 16c:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 175:	8d 65 f4             	lea    -0xc(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5f                   	pop    %edi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret
 17d:	8d 76 00             	lea    0x0(%esi),%esi

00000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	56                   	push   %esi
 184:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 185:	83 ec 08             	sub    $0x8,%esp
 188:	6a 00                	push   $0x0
 18a:	ff 75 08             	push   0x8(%ebp)
 18d:	e8 d5 00 00 00       	call   267 <open>
  if(fd < 0)
 192:	83 c4 10             	add    $0x10,%esp
 195:	85 c0                	test   %eax,%eax
 197:	78 27                	js     1c0 <stat+0x40>
 199:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 19b:	83 ec 08             	sub    $0x8,%esp
 19e:	ff 75 0c             	push   0xc(%ebp)
 1a1:	50                   	push   %eax
 1a2:	e8 d8 00 00 00       	call   27f <fstat>
 1a7:	89 c6                	mov    %eax,%esi
  close(fd);
 1a9:	89 1c 24             	mov    %ebx,(%esp)
 1ac:	e8 9e 00 00 00       	call   24f <close>
  return r;
 1b1:	83 c4 10             	add    $0x10,%esp
}
 1b4:	89 f0                	mov    %esi,%eax
 1b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b9:	5b                   	pop    %ebx
 1ba:	5e                   	pop    %esi
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c5:	eb ed                	jmp    1b4 <stat+0x34>
 1c7:	90                   	nop

000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	53                   	push   %ebx
 1cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1cf:	0f be 01             	movsbl (%ecx),%eax
 1d2:	8d 50 d0             	lea    -0x30(%eax),%edx
 1d5:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1d8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1dd:	77 16                	ja     1f5 <atoi+0x2d>
 1df:	90                   	nop
    n = n*10 + *s++ - '0';
 1e0:	41                   	inc    %ecx
 1e1:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1e4:	01 d2                	add    %edx,%edx
 1e6:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1ea:	0f be 01             	movsbl (%ecx),%eax
 1ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1f0:	80 fb 09             	cmp    $0x9,%bl
 1f3:	76 eb                	jbe    1e0 <atoi+0x18>
  return n;
}
 1f5:	89 d0                	mov    %edx,%eax
 1f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1fa:	c9                   	leave
 1fb:	c3                   	ret

000001fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	57                   	push   %edi
 200:	56                   	push   %esi
 201:	8b 55 08             	mov    0x8(%ebp),%edx
 204:	8b 75 0c             	mov    0xc(%ebp),%esi
 207:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 20a:	85 c0                	test   %eax,%eax
 20c:	7e 0b                	jle    219 <memmove+0x1d>
 20e:	01 d0                	add    %edx,%eax
  dst = vdst;
 210:	89 d7                	mov    %edx,%edi
 212:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 214:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 215:	39 f8                	cmp    %edi,%eax
 217:	75 fb                	jne    214 <memmove+0x18>
  return vdst;
}
 219:	89 d0                	mov    %edx,%eax
 21b:	5e                   	pop    %esi
 21c:	5f                   	pop    %edi
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret

0000021f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 21f:	b8 01 00 00 00       	mov    $0x1,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret

00000227 <exit>:
SYSCALL(exit)
 227:	b8 02 00 00 00       	mov    $0x2,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret

0000022f <wait>:
SYSCALL(wait)
 22f:	b8 03 00 00 00       	mov    $0x3,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret

00000237 <pipe>:
SYSCALL(pipe)
 237:	b8 04 00 00 00       	mov    $0x4,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret

0000023f <read>:
SYSCALL(read)
 23f:	b8 05 00 00 00       	mov    $0x5,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret

00000247 <write>:
SYSCALL(write)
 247:	b8 10 00 00 00       	mov    $0x10,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret

0000024f <close>:
SYSCALL(close)
 24f:	b8 15 00 00 00       	mov    $0x15,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret

00000257 <kill>:
SYSCALL(kill)
 257:	b8 06 00 00 00       	mov    $0x6,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret

0000025f <exec>:
SYSCALL(exec)
 25f:	b8 07 00 00 00       	mov    $0x7,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret

00000267 <open>:
SYSCALL(open)
 267:	b8 0f 00 00 00       	mov    $0xf,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret

0000026f <mknod>:
SYSCALL(mknod)
 26f:	b8 11 00 00 00       	mov    $0x11,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <unlink>:
SYSCALL(unlink)
 277:	b8 12 00 00 00       	mov    $0x12,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <fstat>:
SYSCALL(fstat)
 27f:	b8 08 00 00 00       	mov    $0x8,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <link>:
SYSCALL(link)
 287:	b8 13 00 00 00       	mov    $0x13,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <mkdir>:
SYSCALL(mkdir)
 28f:	b8 14 00 00 00       	mov    $0x14,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <chdir>:
SYSCALL(chdir)
 297:	b8 09 00 00 00       	mov    $0x9,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <dup>:
SYSCALL(dup)
 29f:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <getpid>:
SYSCALL(getpid)
 2a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <sbrk>:
SYSCALL(sbrk)
 2af:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <sleep>:
SYSCALL(sleep)
 2b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <uptime>:
SYSCALL(uptime)
 2bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <custom_fork>:
SYSCALL(custom_fork)
 2c7:	b8 17 00 00 00       	mov    $0x17,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <scheduler_start>:
SYSCALL(scheduler_start)
 2cf:	b8 18 00 00 00       	mov    $0x18,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret
 2d7:	90                   	nop

000002d8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	57                   	push   %edi
 2dc:	56                   	push   %esi
 2dd:	53                   	push   %ebx
 2de:	83 ec 3c             	sub    $0x3c,%esp
 2e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2e4:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e9:	85 c9                	test   %ecx,%ecx
 2eb:	74 04                	je     2f1 <printint+0x19>
 2ed:	85 d2                	test   %edx,%edx
 2ef:	78 6b                	js     35c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2f1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2f4:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2fb:	31 c9                	xor    %ecx,%ecx
 2fd:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 300:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 303:	31 d2                	xor    %edx,%edx
 305:	f7 f3                	div    %ebx
 307:	89 cf                	mov    %ecx,%edi
 309:	8d 49 01             	lea    0x1(%ecx),%ecx
 30c:	8a 92 ac 06 00 00    	mov    0x6ac(%edx),%dl
 312:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 316:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 319:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 31c:	39 da                	cmp    %ebx,%edx
 31e:	73 e0                	jae    300 <printint+0x28>
  if(neg)
 320:	8b 55 08             	mov    0x8(%ebp),%edx
 323:	85 d2                	test   %edx,%edx
 325:	74 07                	je     32e <printint+0x56>
    buf[i++] = '-';
 327:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 32c:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 32e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 331:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 335:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 338:	8a 07                	mov    (%edi),%al
 33a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 33d:	50                   	push   %eax
 33e:	6a 01                	push   $0x1
 340:	56                   	push   %esi
 341:	ff 75 c0             	push   -0x40(%ebp)
 344:	e8 fe fe ff ff       	call   247 <write>
  while(--i >= 0)
 349:	89 f8                	mov    %edi,%eax
 34b:	4f                   	dec    %edi
 34c:	83 c4 10             	add    $0x10,%esp
 34f:	39 d8                	cmp    %ebx,%eax
 351:	75 e5                	jne    338 <printint+0x60>
}
 353:	8d 65 f4             	lea    -0xc(%ebp),%esp
 356:	5b                   	pop    %ebx
 357:	5e                   	pop    %esi
 358:	5f                   	pop    %edi
 359:	5d                   	pop    %ebp
 35a:	c3                   	ret
 35b:	90                   	nop
    x = -xx;
 35c:	f7 da                	neg    %edx
 35e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 361:	eb 98                	jmp    2fb <printint+0x23>
 363:	90                   	nop

00000364 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	53                   	push   %ebx
 36a:	83 ec 2c             	sub    $0x2c,%esp
 36d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 373:	8a 03                	mov    (%ebx),%al
 375:	84 c0                	test   %al,%al
 377:	74 2a                	je     3a3 <printf+0x3f>
 379:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 37a:	8d 4d 10             	lea    0x10(%ebp),%ecx
 37d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 380:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 383:	83 fa 25             	cmp    $0x25,%edx
 386:	74 24                	je     3ac <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 388:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 38b:	50                   	push   %eax
 38c:	6a 01                	push   $0x1
 38e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 391:	50                   	push   %eax
 392:	56                   	push   %esi
 393:	e8 af fe ff ff       	call   247 <write>
  for(i = 0; fmt[i]; i++){
 398:	43                   	inc    %ebx
 399:	8a 43 ff             	mov    -0x1(%ebx),%al
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	84 c0                	test   %al,%al
 3a1:	75 dd                	jne    380 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret
 3ab:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3ac:	8a 13                	mov    (%ebx),%dl
 3ae:	84 d2                	test   %dl,%dl
 3b0:	74 f1                	je     3a3 <printf+0x3f>
    c = fmt[i] & 0xff;
 3b2:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3b5:	80 fa 25             	cmp    $0x25,%dl
 3b8:	0f 84 fe 00 00 00    	je     4bc <printf+0x158>
 3be:	83 e8 63             	sub    $0x63,%eax
 3c1:	83 f8 15             	cmp    $0x15,%eax
 3c4:	77 0a                	ja     3d0 <printf+0x6c>
 3c6:	ff 24 85 54 06 00 00 	jmp    *0x654(,%eax,4)
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3d3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3d7:	50                   	push   %eax
 3d8:	6a 01                	push   $0x1
 3da:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3dd:	57                   	push   %edi
 3de:	56                   	push   %esi
 3df:	e8 63 fe ff ff       	call   247 <write>
        putc(fd, c);
 3e4:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3e7:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3ea:	83 c4 0c             	add    $0xc,%esp
 3ed:	6a 01                	push   $0x1
 3ef:	57                   	push   %edi
 3f0:	56                   	push   %esi
 3f1:	e8 51 fe ff ff       	call   247 <write>
  for(i = 0; fmt[i]; i++){
 3f6:	83 c3 02             	add    $0x2,%ebx
 3f9:	8a 43 ff             	mov    -0x1(%ebx),%al
 3fc:	83 c4 10             	add    $0x10,%esp
 3ff:	84 c0                	test   %al,%al
 401:	0f 85 79 ff ff ff    	jne    380 <printf+0x1c>
}
 407:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40a:	5b                   	pop    %ebx
 40b:	5e                   	pop    %esi
 40c:	5f                   	pop    %edi
 40d:	5d                   	pop    %ebp
 40e:	c3                   	ret
 40f:	90                   	nop
        printint(fd, *ap, 16, 0);
 410:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 413:	8b 17                	mov    (%edi),%edx
 415:	83 ec 0c             	sub    $0xc,%esp
 418:	6a 00                	push   $0x0
 41a:	b9 10 00 00 00       	mov    $0x10,%ecx
 41f:	89 f0                	mov    %esi,%eax
 421:	e8 b2 fe ff ff       	call   2d8 <printint>
        ap++;
 426:	83 c7 04             	add    $0x4,%edi
 429:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 42c:	eb c8                	jmp    3f6 <printf+0x92>
 42e:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 430:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 433:	8b 01                	mov    (%ecx),%eax
        ap++;
 435:	83 c1 04             	add    $0x4,%ecx
 438:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 43b:	85 c0                	test   %eax,%eax
 43d:	0f 84 89 00 00 00    	je     4cc <printf+0x168>
        while(*s != 0){
 443:	8a 10                	mov    (%eax),%dl
 445:	84 d2                	test   %dl,%dl
 447:	74 29                	je     472 <printf+0x10e>
 449:	89 c7                	mov    %eax,%edi
 44b:	88 d0                	mov    %dl,%al
 44d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 450:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 453:	89 fb                	mov    %edi,%ebx
 455:	89 cf                	mov    %ecx,%edi
 457:	90                   	nop
          putc(fd, *s);
 458:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 45b:	50                   	push   %eax
 45c:	6a 01                	push   $0x1
 45e:	57                   	push   %edi
 45f:	56                   	push   %esi
 460:	e8 e2 fd ff ff       	call   247 <write>
          s++;
 465:	43                   	inc    %ebx
        while(*s != 0){
 466:	8a 03                	mov    (%ebx),%al
 468:	83 c4 10             	add    $0x10,%esp
 46b:	84 c0                	test   %al,%al
 46d:	75 e9                	jne    458 <printf+0xf4>
 46f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 472:	83 c3 02             	add    $0x2,%ebx
 475:	8a 43 ff             	mov    -0x1(%ebx),%al
 478:	84 c0                	test   %al,%al
 47a:	0f 85 00 ff ff ff    	jne    380 <printf+0x1c>
 480:	e9 1e ff ff ff       	jmp    3a3 <printf+0x3f>
 485:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 488:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 48b:	8b 17                	mov    (%edi),%edx
 48d:	83 ec 0c             	sub    $0xc,%esp
 490:	6a 01                	push   $0x1
 492:	b9 0a 00 00 00       	mov    $0xa,%ecx
 497:	eb 86                	jmp    41f <printf+0xbb>
 499:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 49c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 49f:	8b 00                	mov    (%eax),%eax
 4a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4a4:	51                   	push   %ecx
 4a5:	6a 01                	push   $0x1
 4a7:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4aa:	57                   	push   %edi
 4ab:	56                   	push   %esi
 4ac:	e8 96 fd ff ff       	call   247 <write>
        ap++;
 4b1:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4b5:	e9 3c ff ff ff       	jmp    3f6 <printf+0x92>
 4ba:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4bc:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4bf:	52                   	push   %edx
 4c0:	6a 01                	push   $0x1
 4c2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4c5:	e9 25 ff ff ff       	jmp    3ef <printf+0x8b>
 4ca:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4cc:	bf 4d 06 00 00       	mov    $0x64d,%edi
 4d1:	b0 28                	mov    $0x28,%al
 4d3:	e9 75 ff ff ff       	jmp    44d <printf+0xe9>

000004d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	57                   	push   %edi
 4dc:	56                   	push   %esi
 4dd:	53                   	push   %ebx
 4de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e4:	a1 c0 06 00 00       	mov    0x6c0,%eax
 4e9:	8d 76 00             	lea    0x0(%esi),%esi
 4ec:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ee:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f0:	39 ca                	cmp    %ecx,%edx
 4f2:	73 2c                	jae    520 <free+0x48>
 4f4:	39 c1                	cmp    %eax,%ecx
 4f6:	72 04                	jb     4fc <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f8:	39 c2                	cmp    %eax,%edx
 4fa:	72 f0                	jb     4ec <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4fc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ff:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 502:	39 f8                	cmp    %edi,%eax
 504:	74 2c                	je     532 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 506:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 509:	8b 42 04             	mov    0x4(%edx),%eax
 50c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 50f:	39 f1                	cmp    %esi,%ecx
 511:	74 36                	je     549 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 513:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 515:	89 15 c0 06 00 00    	mov    %edx,0x6c0
}
 51b:	5b                   	pop    %ebx
 51c:	5e                   	pop    %esi
 51d:	5f                   	pop    %edi
 51e:	5d                   	pop    %ebp
 51f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 520:	39 c2                	cmp    %eax,%edx
 522:	72 c8                	jb     4ec <free+0x14>
 524:	39 c1                	cmp    %eax,%ecx
 526:	73 c4                	jae    4ec <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 528:	8b 73 fc             	mov    -0x4(%ebx),%esi
 52b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 52e:	39 f8                	cmp    %edi,%eax
 530:	75 d4                	jne    506 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 532:	03 70 04             	add    0x4(%eax),%esi
 535:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 538:	8b 02                	mov    (%edx),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 53f:	8b 42 04             	mov    0x4(%edx),%eax
 542:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 545:	39 f1                	cmp    %esi,%ecx
 547:	75 ca                	jne    513 <free+0x3b>
    p->s.size += bp->s.size;
 549:	03 43 fc             	add    -0x4(%ebx),%eax
 54c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 54f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 552:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 554:	89 15 c0 06 00 00    	mov    %edx,0x6c0
}
 55a:	5b                   	pop    %ebx
 55b:	5e                   	pop    %esi
 55c:	5f                   	pop    %edi
 55d:	5d                   	pop    %ebp
 55e:	c3                   	ret
 55f:	90                   	nop

00000560 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	8d 78 07             	lea    0x7(%eax),%edi
 56f:	c1 ef 03             	shr    $0x3,%edi
 572:	47                   	inc    %edi
  if((prevp = freep) == 0){
 573:	8b 15 c0 06 00 00    	mov    0x6c0,%edx
 579:	85 d2                	test   %edx,%edx
 57b:	0f 84 93 00 00 00    	je     614 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 581:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 583:	8b 48 04             	mov    0x4(%eax),%ecx
 586:	39 f9                	cmp    %edi,%ecx
 588:	73 62                	jae    5ec <malloc+0x8c>
  if(nu < 4096)
 58a:	89 fb                	mov    %edi,%ebx
 58c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 592:	72 78                	jb     60c <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 594:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 59b:	eb 0e                	jmp    5ab <malloc+0x4b>
 59d:	8d 76 00             	lea    0x0(%esi),%esi
 5a0:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5a4:	8b 48 04             	mov    0x4(%eax),%ecx
 5a7:	39 f9                	cmp    %edi,%ecx
 5a9:	73 41                	jae    5ec <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5ab:	39 05 c0 06 00 00    	cmp    %eax,0x6c0
 5b1:	75 ed                	jne    5a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5b3:	83 ec 0c             	sub    $0xc,%esp
 5b6:	56                   	push   %esi
 5b7:	e8 f3 fc ff ff       	call   2af <sbrk>
  if(p == (char*)-1)
 5bc:	83 c4 10             	add    $0x10,%esp
 5bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c2:	74 1c                	je     5e0 <malloc+0x80>
  hp->s.size = nu;
 5c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5c7:	83 ec 0c             	sub    $0xc,%esp
 5ca:	83 c0 08             	add    $0x8,%eax
 5cd:	50                   	push   %eax
 5ce:	e8 05 ff ff ff       	call   4d8 <free>
  return freep;
 5d3:	8b 15 c0 06 00 00    	mov    0x6c0,%edx
      if((p = morecore(nunits)) == 0)
 5d9:	83 c4 10             	add    $0x10,%esp
 5dc:	85 d2                	test   %edx,%edx
 5de:	75 c2                	jne    5a2 <malloc+0x42>
        return 0;
 5e0:	31 c0                	xor    %eax,%eax
  }
}
 5e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e5:	5b                   	pop    %ebx
 5e6:	5e                   	pop    %esi
 5e7:	5f                   	pop    %edi
 5e8:	5d                   	pop    %ebp
 5e9:	c3                   	ret
 5ea:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5ec:	39 cf                	cmp    %ecx,%edi
 5ee:	74 4c                	je     63c <malloc+0xdc>
        p->s.size -= nunits;
 5f0:	29 f9                	sub    %edi,%ecx
 5f2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5f5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5f8:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5fb:	89 15 c0 06 00 00    	mov    %edx,0x6c0
      return (void*)(p + 1);
 601:	83 c0 08             	add    $0x8,%eax
}
 604:	8d 65 f4             	lea    -0xc(%ebp),%esp
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret
  if(nu < 4096)
 60c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 611:	eb 81                	jmp    594 <malloc+0x34>
 613:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 614:	c7 05 c0 06 00 00 c4 	movl   $0x6c4,0x6c0
 61b:	06 00 00 
 61e:	c7 05 c4 06 00 00 c4 	movl   $0x6c4,0x6c4
 625:	06 00 00 
    base.s.size = 0;
 628:	c7 05 c8 06 00 00 00 	movl   $0x0,0x6c8
 62f:	00 00 00 
 632:	b8 c4 06 00 00       	mov    $0x6c4,%eax
 637:	e9 4e ff ff ff       	jmp    58a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 63c:	8b 08                	mov    (%eax),%ecx
 63e:	89 0a                	mov    %ecx,(%edx)
 640:	eb b9                	jmp    5fb <malloc+0x9b>
