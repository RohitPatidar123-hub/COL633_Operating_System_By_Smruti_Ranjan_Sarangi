
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
  2c:	68 34 06 00 00       	push   $0x634
  31:	50                   	push   %eax
  32:	68 36 06 00 00       	push   $0x636
  37:	6a 01                	push   $0x1
  39:	e8 16 03 00 00       	call   354 <printf>
  3e:	43                   	inc    %ebx
  3f:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  43:	83 c4 10             	add    $0x10,%esp
  46:	39 de                	cmp    %ebx,%esi
  48:	75 e2                	jne    2c <main+0x2c>
  4a:	68 3b 06 00 00       	push   $0x63b
  4f:	50                   	push   %eax
  50:	68 36 06 00 00       	push   $0x636
  55:	6a 01                	push   $0x1
  57:	e8 f8 02 00 00       	call   354 <printf>
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
 2c7:	90                   	nop

000002c8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	57                   	push   %edi
 2cc:	56                   	push   %esi
 2cd:	53                   	push   %ebx
 2ce:	83 ec 3c             	sub    $0x3c,%esp
 2d1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2d4:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d9:	85 c9                	test   %ecx,%ecx
 2db:	74 04                	je     2e1 <printint+0x19>
 2dd:	85 d2                	test   %edx,%edx
 2df:	78 6b                	js     34c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2e1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2e4:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2eb:	31 c9                	xor    %ecx,%ecx
 2ed:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2f3:	31 d2                	xor    %edx,%edx
 2f5:	f7 f3                	div    %ebx
 2f7:	89 cf                	mov    %ecx,%edi
 2f9:	8d 49 01             	lea    0x1(%ecx),%ecx
 2fc:	8a 92 9c 06 00 00    	mov    0x69c(%edx),%dl
 302:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 306:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 309:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 30c:	39 da                	cmp    %ebx,%edx
 30e:	73 e0                	jae    2f0 <printint+0x28>
  if(neg)
 310:	8b 55 08             	mov    0x8(%ebp),%edx
 313:	85 d2                	test   %edx,%edx
 315:	74 07                	je     31e <printint+0x56>
    buf[i++] = '-';
 317:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 31c:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 31e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 321:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 325:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 328:	8a 07                	mov    (%edi),%al
 32a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 32d:	50                   	push   %eax
 32e:	6a 01                	push   $0x1
 330:	56                   	push   %esi
 331:	ff 75 c0             	push   -0x40(%ebp)
 334:	e8 0e ff ff ff       	call   247 <write>
  while(--i >= 0)
 339:	89 f8                	mov    %edi,%eax
 33b:	4f                   	dec    %edi
 33c:	83 c4 10             	add    $0x10,%esp
 33f:	39 d8                	cmp    %ebx,%eax
 341:	75 e5                	jne    328 <printint+0x60>
}
 343:	8d 65 f4             	lea    -0xc(%ebp),%esp
 346:	5b                   	pop    %ebx
 347:	5e                   	pop    %esi
 348:	5f                   	pop    %edi
 349:	5d                   	pop    %ebp
 34a:	c3                   	ret
 34b:	90                   	nop
    x = -xx;
 34c:	f7 da                	neg    %edx
 34e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 351:	eb 98                	jmp    2eb <printint+0x23>
 353:	90                   	nop

00000354 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	56                   	push   %esi
 359:	53                   	push   %ebx
 35a:	83 ec 2c             	sub    $0x2c,%esp
 35d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 363:	8a 03                	mov    (%ebx),%al
 365:	84 c0                	test   %al,%al
 367:	74 2a                	je     393 <printf+0x3f>
 369:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 36a:	8d 4d 10             	lea    0x10(%ebp),%ecx
 36d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 370:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 373:	83 fa 25             	cmp    $0x25,%edx
 376:	74 24                	je     39c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 378:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 37b:	50                   	push   %eax
 37c:	6a 01                	push   $0x1
 37e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 381:	50                   	push   %eax
 382:	56                   	push   %esi
 383:	e8 bf fe ff ff       	call   247 <write>
  for(i = 0; fmt[i]; i++){
 388:	43                   	inc    %ebx
 389:	8a 43 ff             	mov    -0x1(%ebx),%al
 38c:	83 c4 10             	add    $0x10,%esp
 38f:	84 c0                	test   %al,%al
 391:	75 dd                	jne    370 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret
 39b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 39c:	8a 13                	mov    (%ebx),%dl
 39e:	84 d2                	test   %dl,%dl
 3a0:	74 f1                	je     393 <printf+0x3f>
    c = fmt[i] & 0xff;
 3a2:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3a5:	80 fa 25             	cmp    $0x25,%dl
 3a8:	0f 84 fe 00 00 00    	je     4ac <printf+0x158>
 3ae:	83 e8 63             	sub    $0x63,%eax
 3b1:	83 f8 15             	cmp    $0x15,%eax
 3b4:	77 0a                	ja     3c0 <printf+0x6c>
 3b6:	ff 24 85 44 06 00 00 	jmp    *0x644(,%eax,4)
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3c3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3c7:	50                   	push   %eax
 3c8:	6a 01                	push   $0x1
 3ca:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3cd:	57                   	push   %edi
 3ce:	56                   	push   %esi
 3cf:	e8 73 fe ff ff       	call   247 <write>
        putc(fd, c);
 3d4:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3d7:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3da:	83 c4 0c             	add    $0xc,%esp
 3dd:	6a 01                	push   $0x1
 3df:	57                   	push   %edi
 3e0:	56                   	push   %esi
 3e1:	e8 61 fe ff ff       	call   247 <write>
  for(i = 0; fmt[i]; i++){
 3e6:	83 c3 02             	add    $0x2,%ebx
 3e9:	8a 43 ff             	mov    -0x1(%ebx),%al
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	84 c0                	test   %al,%al
 3f1:	0f 85 79 ff ff ff    	jne    370 <printf+0x1c>
}
 3f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fa:	5b                   	pop    %ebx
 3fb:	5e                   	pop    %esi
 3fc:	5f                   	pop    %edi
 3fd:	5d                   	pop    %ebp
 3fe:	c3                   	ret
 3ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 400:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 403:	8b 17                	mov    (%edi),%edx
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	6a 00                	push   $0x0
 40a:	b9 10 00 00 00       	mov    $0x10,%ecx
 40f:	89 f0                	mov    %esi,%eax
 411:	e8 b2 fe ff ff       	call   2c8 <printint>
        ap++;
 416:	83 c7 04             	add    $0x4,%edi
 419:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 41c:	eb c8                	jmp    3e6 <printf+0x92>
 41e:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 420:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 423:	8b 01                	mov    (%ecx),%eax
        ap++;
 425:	83 c1 04             	add    $0x4,%ecx
 428:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 42b:	85 c0                	test   %eax,%eax
 42d:	0f 84 89 00 00 00    	je     4bc <printf+0x168>
        while(*s != 0){
 433:	8a 10                	mov    (%eax),%dl
 435:	84 d2                	test   %dl,%dl
 437:	74 29                	je     462 <printf+0x10e>
 439:	89 c7                	mov    %eax,%edi
 43b:	88 d0                	mov    %dl,%al
 43d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 440:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 443:	89 fb                	mov    %edi,%ebx
 445:	89 cf                	mov    %ecx,%edi
 447:	90                   	nop
          putc(fd, *s);
 448:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 44b:	50                   	push   %eax
 44c:	6a 01                	push   $0x1
 44e:	57                   	push   %edi
 44f:	56                   	push   %esi
 450:	e8 f2 fd ff ff       	call   247 <write>
          s++;
 455:	43                   	inc    %ebx
        while(*s != 0){
 456:	8a 03                	mov    (%ebx),%al
 458:	83 c4 10             	add    $0x10,%esp
 45b:	84 c0                	test   %al,%al
 45d:	75 e9                	jne    448 <printf+0xf4>
 45f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 462:	83 c3 02             	add    $0x2,%ebx
 465:	8a 43 ff             	mov    -0x1(%ebx),%al
 468:	84 c0                	test   %al,%al
 46a:	0f 85 00 ff ff ff    	jne    370 <printf+0x1c>
 470:	e9 1e ff ff ff       	jmp    393 <printf+0x3f>
 475:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 478:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 47b:	8b 17                	mov    (%edi),%edx
 47d:	83 ec 0c             	sub    $0xc,%esp
 480:	6a 01                	push   $0x1
 482:	b9 0a 00 00 00       	mov    $0xa,%ecx
 487:	eb 86                	jmp    40f <printf+0xbb>
 489:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 48c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 48f:	8b 00                	mov    (%eax),%eax
 491:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 494:	51                   	push   %ecx
 495:	6a 01                	push   $0x1
 497:	8d 7d e7             	lea    -0x19(%ebp),%edi
 49a:	57                   	push   %edi
 49b:	56                   	push   %esi
 49c:	e8 a6 fd ff ff       	call   247 <write>
        ap++;
 4a1:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4a5:	e9 3c ff ff ff       	jmp    3e6 <printf+0x92>
 4aa:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4ac:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4af:	52                   	push   %edx
 4b0:	6a 01                	push   $0x1
 4b2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b5:	e9 25 ff ff ff       	jmp    3df <printf+0x8b>
 4ba:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4bc:	bf 3d 06 00 00       	mov    $0x63d,%edi
 4c1:	b0 28                	mov    $0x28,%al
 4c3:	e9 75 ff ff ff       	jmp    43d <printf+0xe9>

000004c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	57                   	push   %edi
 4cc:	56                   	push   %esi
 4cd:	53                   	push   %ebx
 4ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d4:	a1 b0 06 00 00       	mov    0x6b0,%eax
 4d9:	8d 76 00             	lea    0x0(%esi),%esi
 4dc:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4de:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e0:	39 ca                	cmp    %ecx,%edx
 4e2:	73 2c                	jae    510 <free+0x48>
 4e4:	39 c1                	cmp    %eax,%ecx
 4e6:	72 04                	jb     4ec <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e8:	39 c2                	cmp    %eax,%edx
 4ea:	72 f0                	jb     4dc <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4ec:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ef:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f2:	39 f8                	cmp    %edi,%eax
 4f4:	74 2c                	je     522 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4f6:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4f9:	8b 42 04             	mov    0x4(%edx),%eax
 4fc:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4ff:	39 f1                	cmp    %esi,%ecx
 501:	74 36                	je     539 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 503:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 505:	89 15 b0 06 00 00    	mov    %edx,0x6b0
}
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5f                   	pop    %edi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 510:	39 c2                	cmp    %eax,%edx
 512:	72 c8                	jb     4dc <free+0x14>
 514:	39 c1                	cmp    %eax,%ecx
 516:	73 c4                	jae    4dc <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 518:	8b 73 fc             	mov    -0x4(%ebx),%esi
 51b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 51e:	39 f8                	cmp    %edi,%eax
 520:	75 d4                	jne    4f6 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 522:	03 70 04             	add    0x4(%eax),%esi
 525:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 528:	8b 02                	mov    (%edx),%eax
 52a:	8b 00                	mov    (%eax),%eax
 52c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 52f:	8b 42 04             	mov    0x4(%edx),%eax
 532:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 535:	39 f1                	cmp    %esi,%ecx
 537:	75 ca                	jne    503 <free+0x3b>
    p->s.size += bp->s.size;
 539:	03 43 fc             	add    -0x4(%ebx),%eax
 53c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 53f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 542:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 544:	89 15 b0 06 00 00    	mov    %edx,0x6b0
}
 54a:	5b                   	pop    %ebx
 54b:	5e                   	pop    %esi
 54c:	5f                   	pop    %edi
 54d:	5d                   	pop    %ebp
 54e:	c3                   	ret
 54f:	90                   	nop

00000550 <malloc>:
}


void*
malloc(uint nbytes)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	8d 78 07             	lea    0x7(%eax),%edi
 55f:	c1 ef 03             	shr    $0x3,%edi
 562:	47                   	inc    %edi
  if((prevp = freep) == 0){
 563:	8b 15 b0 06 00 00    	mov    0x6b0,%edx
 569:	85 d2                	test   %edx,%edx
 56b:	0f 84 93 00 00 00    	je     604 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 571:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 573:	8b 48 04             	mov    0x4(%eax),%ecx
 576:	39 f9                	cmp    %edi,%ecx
 578:	73 62                	jae    5dc <malloc+0x8c>
  if(nu < 4096)
 57a:	89 fb                	mov    %edi,%ebx
 57c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 582:	72 78                	jb     5fc <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 584:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 58b:	eb 0e                	jmp    59b <malloc+0x4b>
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 592:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 594:	8b 48 04             	mov    0x4(%eax),%ecx
 597:	39 f9                	cmp    %edi,%ecx
 599:	73 41                	jae    5dc <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 59b:	39 05 b0 06 00 00    	cmp    %eax,0x6b0
 5a1:	75 ed                	jne    590 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 5a3:	83 ec 0c             	sub    $0xc,%esp
 5a6:	56                   	push   %esi
 5a7:	e8 03 fd ff ff       	call   2af <sbrk>
  if(p == (char*)-1)
 5ac:	83 c4 10             	add    $0x10,%esp
 5af:	83 f8 ff             	cmp    $0xffffffff,%eax
 5b2:	74 1c                	je     5d0 <malloc+0x80>
  hp->s.size = nu;
 5b4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5b7:	83 ec 0c             	sub    $0xc,%esp
 5ba:	83 c0 08             	add    $0x8,%eax
 5bd:	50                   	push   %eax
 5be:	e8 05 ff ff ff       	call   4c8 <free>
  return freep;
 5c3:	8b 15 b0 06 00 00    	mov    0x6b0,%edx
      if((p = morecore(nunits)) == 0)
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	85 d2                	test   %edx,%edx
 5ce:	75 c2                	jne    592 <malloc+0x42>
        return 0;
 5d0:	31 c0                	xor    %eax,%eax
  }
}
 5d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d5:	5b                   	pop    %ebx
 5d6:	5e                   	pop    %esi
 5d7:	5f                   	pop    %edi
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret
 5da:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5dc:	39 cf                	cmp    %ecx,%edi
 5de:	74 4c                	je     62c <malloc+0xdc>
        p->s.size -= nunits;
 5e0:	29 f9                	sub    %edi,%ecx
 5e2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5e5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5e8:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5eb:	89 15 b0 06 00 00    	mov    %edx,0x6b0
      return (void*)(p + 1);
 5f1:	83 c0 08             	add    $0x8,%eax
}
 5f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret
  if(nu < 4096)
 5fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 601:	eb 81                	jmp    584 <malloc+0x34>
 603:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 604:	c7 05 b0 06 00 00 b4 	movl   $0x6b4,0x6b0
 60b:	06 00 00 
 60e:	c7 05 b4 06 00 00 b4 	movl   $0x6b4,0x6b4
 615:	06 00 00 
    base.s.size = 0;
 618:	c7 05 b8 06 00 00 00 	movl   $0x0,0x6b8
 61f:	00 00 00 
 622:	b8 b4 06 00 00       	mov    $0x6b4,%eax
 627:	e9 4e ff ff ff       	jmp    57a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 62c:	8b 08                	mov    (%eax),%ecx
 62e:	89 0a                	mov    %ecx,(%edx)
 630:	eb b9                	jmp    5eb <malloc+0x9b>
