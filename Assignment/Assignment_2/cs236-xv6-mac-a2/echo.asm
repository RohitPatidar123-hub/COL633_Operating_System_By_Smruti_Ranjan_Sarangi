
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
  2c:	68 4c 06 00 00       	push   $0x64c
  31:	50                   	push   %eax
  32:	68 4e 06 00 00       	push   $0x64e
  37:	6a 01                	push   $0x1
  39:	e8 2e 03 00 00       	call   36c <printf>
  3e:	43                   	inc    %ebx
  3f:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  43:	83 c4 10             	add    $0x10,%esp
  46:	39 de                	cmp    %ebx,%esi
  48:	75 e2                	jne    2c <main+0x2c>
  4a:	68 53 06 00 00       	push   $0x653
  4f:	50                   	push   %eax
  50:	68 4e 06 00 00       	push   $0x64e
  55:	6a 01                	push   $0x1
  57:	e8 10 03 00 00       	call   36c <printf>
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

000002c7 <signal>:
SYSCALL(signal)
 2c7:	b8 16 00 00 00       	mov    $0x16,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <custom_fork>:
SYSCALL(custom_fork)
 2cf:	b8 17 00 00 00       	mov    $0x17,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <scheduler_start>:
 2d7:	b8 18 00 00 00       	mov    $0x18,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret
 2df:	90                   	nop

000002e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	56                   	push   %esi
 2e5:	53                   	push   %ebx
 2e6:	83 ec 3c             	sub    $0x3c,%esp
 2e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2ec:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f1:	85 c9                	test   %ecx,%ecx
 2f3:	74 04                	je     2f9 <printint+0x19>
 2f5:	85 d2                	test   %edx,%edx
 2f7:	78 6b                	js     364 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2f9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2fc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 303:	31 c9                	xor    %ecx,%ecx
 305:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 308:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 30b:	31 d2                	xor    %edx,%edx
 30d:	f7 f3                	div    %ebx
 30f:	89 cf                	mov    %ecx,%edi
 311:	8d 49 01             	lea    0x1(%ecx),%ecx
 314:	8a 92 b4 06 00 00    	mov    0x6b4(%edx),%dl
 31a:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 31e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 321:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 324:	39 da                	cmp    %ebx,%edx
 326:	73 e0                	jae    308 <printint+0x28>
  if(neg)
 328:	8b 55 08             	mov    0x8(%ebp),%edx
 32b:	85 d2                	test   %edx,%edx
 32d:	74 07                	je     336 <printint+0x56>
    buf[i++] = '-';
 32f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 334:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 336:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 339:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 340:	8a 07                	mov    (%edi),%al
 342:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 345:	50                   	push   %eax
 346:	6a 01                	push   $0x1
 348:	56                   	push   %esi
 349:	ff 75 c0             	push   -0x40(%ebp)
 34c:	e8 f6 fe ff ff       	call   247 <write>
  while(--i >= 0)
 351:	89 f8                	mov    %edi,%eax
 353:	4f                   	dec    %edi
 354:	83 c4 10             	add    $0x10,%esp
 357:	39 d8                	cmp    %ebx,%eax
 359:	75 e5                	jne    340 <printint+0x60>
}
 35b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35e:	5b                   	pop    %ebx
 35f:	5e                   	pop    %esi
 360:	5f                   	pop    %edi
 361:	5d                   	pop    %ebp
 362:	c3                   	ret
 363:	90                   	nop
    x = -xx;
 364:	f7 da                	neg    %edx
 366:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 369:	eb 98                	jmp    303 <printint+0x23>
 36b:	90                   	nop

0000036c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	57                   	push   %edi
 370:	56                   	push   %esi
 371:	53                   	push   %ebx
 372:	83 ec 2c             	sub    $0x2c,%esp
 375:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 37b:	8a 03                	mov    (%ebx),%al
 37d:	84 c0                	test   %al,%al
 37f:	74 2a                	je     3ab <printf+0x3f>
 381:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 382:	8d 4d 10             	lea    0x10(%ebp),%ecx
 385:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 388:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 38b:	83 fa 25             	cmp    $0x25,%edx
 38e:	74 24                	je     3b4 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 390:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 393:	50                   	push   %eax
 394:	6a 01                	push   $0x1
 396:	8d 45 e7             	lea    -0x19(%ebp),%eax
 399:	50                   	push   %eax
 39a:	56                   	push   %esi
 39b:	e8 a7 fe ff ff       	call   247 <write>
  for(i = 0; fmt[i]; i++){
 3a0:	43                   	inc    %ebx
 3a1:	8a 43 ff             	mov    -0x1(%ebx),%al
 3a4:	83 c4 10             	add    $0x10,%esp
 3a7:	84 c0                	test   %al,%al
 3a9:	75 dd                	jne    388 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ae:	5b                   	pop    %ebx
 3af:	5e                   	pop    %esi
 3b0:	5f                   	pop    %edi
 3b1:	5d                   	pop    %ebp
 3b2:	c3                   	ret
 3b3:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3b4:	8a 13                	mov    (%ebx),%dl
 3b6:	84 d2                	test   %dl,%dl
 3b8:	74 f1                	je     3ab <printf+0x3f>
    c = fmt[i] & 0xff;
 3ba:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3bd:	80 fa 25             	cmp    $0x25,%dl
 3c0:	0f 84 fe 00 00 00    	je     4c4 <printf+0x158>
 3c6:	83 e8 63             	sub    $0x63,%eax
 3c9:	83 f8 15             	cmp    $0x15,%eax
 3cc:	77 0a                	ja     3d8 <printf+0x6c>
 3ce:	ff 24 85 5c 06 00 00 	jmp    *0x65c(,%eax,4)
 3d5:	8d 76 00             	lea    0x0(%esi),%esi
 3d8:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3db:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3df:	50                   	push   %eax
 3e0:	6a 01                	push   $0x1
 3e2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3e5:	57                   	push   %edi
 3e6:	56                   	push   %esi
 3e7:	e8 5b fe ff ff       	call   247 <write>
        putc(fd, c);
 3ec:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3ef:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3f2:	83 c4 0c             	add    $0xc,%esp
 3f5:	6a 01                	push   $0x1
 3f7:	57                   	push   %edi
 3f8:	56                   	push   %esi
 3f9:	e8 49 fe ff ff       	call   247 <write>
  for(i = 0; fmt[i]; i++){
 3fe:	83 c3 02             	add    $0x2,%ebx
 401:	8a 43 ff             	mov    -0x1(%ebx),%al
 404:	83 c4 10             	add    $0x10,%esp
 407:	84 c0                	test   %al,%al
 409:	0f 85 79 ff ff ff    	jne    388 <printf+0x1c>
}
 40f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 412:	5b                   	pop    %ebx
 413:	5e                   	pop    %esi
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret
 417:	90                   	nop
        printint(fd, *ap, 16, 0);
 418:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 41b:	8b 17                	mov    (%edi),%edx
 41d:	83 ec 0c             	sub    $0xc,%esp
 420:	6a 00                	push   $0x0
 422:	b9 10 00 00 00       	mov    $0x10,%ecx
 427:	89 f0                	mov    %esi,%eax
 429:	e8 b2 fe ff ff       	call   2e0 <printint>
        ap++;
 42e:	83 c7 04             	add    $0x4,%edi
 431:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 434:	eb c8                	jmp    3fe <printf+0x92>
 436:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 438:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 43b:	8b 01                	mov    (%ecx),%eax
        ap++;
 43d:	83 c1 04             	add    $0x4,%ecx
 440:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 443:	85 c0                	test   %eax,%eax
 445:	0f 84 89 00 00 00    	je     4d4 <printf+0x168>
        while(*s != 0){
 44b:	8a 10                	mov    (%eax),%dl
 44d:	84 d2                	test   %dl,%dl
 44f:	74 29                	je     47a <printf+0x10e>
 451:	89 c7                	mov    %eax,%edi
 453:	88 d0                	mov    %dl,%al
 455:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 458:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 45b:	89 fb                	mov    %edi,%ebx
 45d:	89 cf                	mov    %ecx,%edi
 45f:	90                   	nop
          putc(fd, *s);
 460:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 463:	50                   	push   %eax
 464:	6a 01                	push   $0x1
 466:	57                   	push   %edi
 467:	56                   	push   %esi
 468:	e8 da fd ff ff       	call   247 <write>
          s++;
 46d:	43                   	inc    %ebx
        while(*s != 0){
 46e:	8a 03                	mov    (%ebx),%al
 470:	83 c4 10             	add    $0x10,%esp
 473:	84 c0                	test   %al,%al
 475:	75 e9                	jne    460 <printf+0xf4>
 477:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 47a:	83 c3 02             	add    $0x2,%ebx
 47d:	8a 43 ff             	mov    -0x1(%ebx),%al
 480:	84 c0                	test   %al,%al
 482:	0f 85 00 ff ff ff    	jne    388 <printf+0x1c>
 488:	e9 1e ff ff ff       	jmp    3ab <printf+0x3f>
 48d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 490:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 493:	8b 17                	mov    (%edi),%edx
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	6a 01                	push   $0x1
 49a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 49f:	eb 86                	jmp    427 <printf+0xbb>
 4a1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4a7:	8b 00                	mov    (%eax),%eax
 4a9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ac:	51                   	push   %ecx
 4ad:	6a 01                	push   $0x1
 4af:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b2:	57                   	push   %edi
 4b3:	56                   	push   %esi
 4b4:	e8 8e fd ff ff       	call   247 <write>
        ap++;
 4b9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4bd:	e9 3c ff ff ff       	jmp    3fe <printf+0x92>
 4c2:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4c4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4c7:	52                   	push   %edx
 4c8:	6a 01                	push   $0x1
 4ca:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4cd:	e9 25 ff ff ff       	jmp    3f7 <printf+0x8b>
 4d2:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4d4:	bf 55 06 00 00       	mov    $0x655,%edi
 4d9:	b0 28                	mov    $0x28,%al
 4db:	e9 75 ff ff ff       	jmp    455 <printf+0xe9>

000004e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ec:	a1 c8 06 00 00       	mov    0x6c8,%eax
 4f1:	8d 76 00             	lea    0x0(%esi),%esi
 4f4:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f6:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f8:	39 ca                	cmp    %ecx,%edx
 4fa:	73 2c                	jae    528 <free+0x48>
 4fc:	39 c1                	cmp    %eax,%ecx
 4fe:	72 04                	jb     504 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 500:	39 c2                	cmp    %eax,%edx
 502:	72 f0                	jb     4f4 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 504:	8b 73 fc             	mov    -0x4(%ebx),%esi
 507:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 50a:	39 f8                	cmp    %edi,%eax
 50c:	74 2c                	je     53a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 50e:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 511:	8b 42 04             	mov    0x4(%edx),%eax
 514:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 517:	39 f1                	cmp    %esi,%ecx
 519:	74 36                	je     551 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 51b:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 51d:	89 15 c8 06 00 00    	mov    %edx,0x6c8
}
 523:	5b                   	pop    %ebx
 524:	5e                   	pop    %esi
 525:	5f                   	pop    %edi
 526:	5d                   	pop    %ebp
 527:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 528:	39 c2                	cmp    %eax,%edx
 52a:	72 c8                	jb     4f4 <free+0x14>
 52c:	39 c1                	cmp    %eax,%ecx
 52e:	73 c4                	jae    4f4 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 530:	8b 73 fc             	mov    -0x4(%ebx),%esi
 533:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 536:	39 f8                	cmp    %edi,%eax
 538:	75 d4                	jne    50e <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 53a:	03 70 04             	add    0x4(%eax),%esi
 53d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 540:	8b 02                	mov    (%edx),%eax
 542:	8b 00                	mov    (%eax),%eax
 544:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 547:	8b 42 04             	mov    0x4(%edx),%eax
 54a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 54d:	39 f1                	cmp    %esi,%ecx
 54f:	75 ca                	jne    51b <free+0x3b>
    p->s.size += bp->s.size;
 551:	03 43 fc             	add    -0x4(%ebx),%eax
 554:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 557:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 55a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 55c:	89 15 c8 06 00 00    	mov    %edx,0x6c8
}
 562:	5b                   	pop    %ebx
 563:	5e                   	pop    %esi
 564:	5f                   	pop    %edi
 565:	5d                   	pop    %ebp
 566:	c3                   	ret
 567:	90                   	nop

00000568 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	57                   	push   %edi
 56c:	56                   	push   %esi
 56d:	53                   	push   %ebx
 56e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	8d 78 07             	lea    0x7(%eax),%edi
 577:	c1 ef 03             	shr    $0x3,%edi
 57a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 57b:	8b 15 c8 06 00 00    	mov    0x6c8,%edx
 581:	85 d2                	test   %edx,%edx
 583:	0f 84 93 00 00 00    	je     61c <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 589:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 58b:	8b 48 04             	mov    0x4(%eax),%ecx
 58e:	39 f9                	cmp    %edi,%ecx
 590:	73 62                	jae    5f4 <malloc+0x8c>
  if(nu < 4096)
 592:	89 fb                	mov    %edi,%ebx
 594:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 59a:	72 78                	jb     614 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 59c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5a3:	eb 0e                	jmp    5b3 <malloc+0x4b>
 5a5:	8d 76 00             	lea    0x0(%esi),%esi
 5a8:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5aa:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ac:	8b 48 04             	mov    0x4(%eax),%ecx
 5af:	39 f9                	cmp    %edi,%ecx
 5b1:	73 41                	jae    5f4 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5b3:	39 05 c8 06 00 00    	cmp    %eax,0x6c8
 5b9:	75 ed                	jne    5a8 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5bb:	83 ec 0c             	sub    $0xc,%esp
 5be:	56                   	push   %esi
 5bf:	e8 eb fc ff ff       	call   2af <sbrk>
  if(p == (char*)-1)
 5c4:	83 c4 10             	add    $0x10,%esp
 5c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ca:	74 1c                	je     5e8 <malloc+0x80>
  hp->s.size = nu;
 5cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5cf:	83 ec 0c             	sub    $0xc,%esp
 5d2:	83 c0 08             	add    $0x8,%eax
 5d5:	50                   	push   %eax
 5d6:	e8 05 ff ff ff       	call   4e0 <free>
  return freep;
 5db:	8b 15 c8 06 00 00    	mov    0x6c8,%edx
      if((p = morecore(nunits)) == 0)
 5e1:	83 c4 10             	add    $0x10,%esp
 5e4:	85 d2                	test   %edx,%edx
 5e6:	75 c2                	jne    5aa <malloc+0x42>
        return 0;
 5e8:	31 c0                	xor    %eax,%eax
  }
}
 5ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ed:	5b                   	pop    %ebx
 5ee:	5e                   	pop    %esi
 5ef:	5f                   	pop    %edi
 5f0:	5d                   	pop    %ebp
 5f1:	c3                   	ret
 5f2:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5f4:	39 cf                	cmp    %ecx,%edi
 5f6:	74 4c                	je     644 <malloc+0xdc>
        p->s.size -= nunits;
 5f8:	29 f9                	sub    %edi,%ecx
 5fa:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5fd:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 600:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 603:	89 15 c8 06 00 00    	mov    %edx,0x6c8
      return (void*)(p + 1);
 609:	83 c0 08             	add    $0x8,%eax
}
 60c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60f:	5b                   	pop    %ebx
 610:	5e                   	pop    %esi
 611:	5f                   	pop    %edi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret
  if(nu < 4096)
 614:	bb 00 10 00 00       	mov    $0x1000,%ebx
 619:	eb 81                	jmp    59c <malloc+0x34>
 61b:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 61c:	c7 05 c8 06 00 00 cc 	movl   $0x6cc,0x6c8
 623:	06 00 00 
 626:	c7 05 cc 06 00 00 cc 	movl   $0x6cc,0x6cc
 62d:	06 00 00 
    base.s.size = 0;
 630:	c7 05 d0 06 00 00 00 	movl   $0x0,0x6d0
 637:	00 00 00 
 63a:	b8 cc 06 00 00       	mov    $0x6cc,%eax
 63f:	e9 4e ff ff ff       	jmp    592 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 644:	8b 08                	mov    (%eax),%ecx
 646:	89 0a                	mov    %ecx,(%edx)
 648:	eb b9                	jmp    603 <malloc+0x9b>
