
_ln:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 13                	je     2a <main+0x2a>
    printf(2, "Usage: ln old new\n");
  17:	52                   	push   %edx
  18:	52                   	push   %edx
  19:	68 34 06 00 00       	push   $0x634
  1e:	6a 02                	push   $0x2
  20:	e8 2f 03 00 00       	call   354 <printf>
    exit();
  25:	e8 f5 01 00 00       	call   21f <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2a:	50                   	push   %eax
  2b:	50                   	push   %eax
  2c:	ff 73 08             	push   0x8(%ebx)
  2f:	ff 73 04             	push   0x4(%ebx)
  32:	e8 48 02 00 00       	call   27f <link>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	78 05                	js     43 <main+0x43>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3e:	e8 dc 01 00 00       	call   21f <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  43:	ff 73 08             	push   0x8(%ebx)
  46:	ff 73 04             	push   0x4(%ebx)
  49:	68 47 06 00 00       	push   $0x647
  4e:	6a 02                	push   $0x2
  50:	e8 ff 02 00 00       	call   354 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e4                	jmp    3e <main+0x3e>
  5a:	66 90                	xchg   %ax,%ax

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	31 c0                	xor    %eax,%eax
  68:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  6b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6e:	40                   	inc    %eax
  6f:	84 d2                	test   %dl,%dl
  71:	75 f5                	jne    68 <strcpy+0xc>
    ;
  return os;
}
  73:	89 c8                	mov    %ecx,%eax
  75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  78:	c9                   	leave
  79:	c3                   	ret
  7a:	66 90                	xchg   %ax,%ax

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	53                   	push   %ebx
  80:	8b 55 08             	mov    0x8(%ebp),%edx
  83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  86:	0f b6 02             	movzbl (%edx),%eax
  89:	84 c0                	test   %al,%al
  8b:	75 10                	jne    9d <strcmp+0x21>
  8d:	eb 2a                	jmp    b9 <strcmp+0x3d>
  8f:	90                   	nop
    p++, q++;
  90:	42                   	inc    %edx
  91:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  94:	0f b6 02             	movzbl (%edx),%eax
  97:	84 c0                	test   %al,%al
  99:	74 11                	je     ac <strcmp+0x30>
  9b:	89 cb                	mov    %ecx,%ebx
  9d:	0f b6 0b             	movzbl (%ebx),%ecx
  a0:	38 c1                	cmp    %al,%cl
  a2:	74 ec                	je     90 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a4:	29 c8                	sub    %ecx,%eax
}
  a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a9:	c9                   	leave
  aa:	c3                   	ret
  ab:	90                   	nop
  return (uchar)*p - (uchar)*q;
  ac:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  b0:	31 c0                	xor    %eax,%eax
  b2:	29 c8                	sub    %ecx,%eax
}
  b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b7:	c9                   	leave
  b8:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  b9:	0f b6 0b             	movzbl (%ebx),%ecx
  bc:	31 c0                	xor    %eax,%eax
  be:	eb e4                	jmp    a4 <strcmp+0x28>

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	40                   	inc    %eax
  d1:	89 c1                	mov    %eax,%ecx
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	75 f7                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  d9:	89 c8                	mov    %ecx,%eax
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	89 c8                	mov    %ecx,%eax
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret
  e6:	66 90                	xchg   %ax,%ax

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	fc                   	cld
  f6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  fe:	c9                   	leave
  ff:	c3                   	ret

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 109:	8a 10                	mov    (%eax),%dl
 10b:	84 d2                	test   %dl,%dl
 10d:	75 0c                	jne    11b <strchr+0x1b>
 10f:	eb 13                	jmp    124 <strchr+0x24>
 111:	8d 76 00             	lea    0x0(%esi),%esi
 114:	40                   	inc    %eax
 115:	8a 10                	mov    (%eax),%dl
 117:	84 d2                	test   %dl,%dl
 119:	74 09                	je     124 <strchr+0x24>
    if(*s == c)
 11b:	38 d1                	cmp    %dl,%cl
 11d:	75 f5                	jne    114 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret
 121:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 124:	31 c0                	xor    %eax,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	57                   	push   %edi
 12c:	56                   	push   %esi
 12d:	53                   	push   %ebx
 12e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 131:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 133:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 136:	eb 24                	jmp    15c <gets+0x34>
    cc = read(0, &c, 1);
 138:	50                   	push   %eax
 139:	6a 01                	push   $0x1
 13b:	56                   	push   %esi
 13c:	6a 00                	push   $0x0
 13e:	e8 f4 00 00 00       	call   237 <read>
    if(cc < 1)
 143:	83 c4 10             	add    $0x10,%esp
 146:	85 c0                	test   %eax,%eax
 148:	7e 1a                	jle    164 <gets+0x3c>
      break;
    buf[i++] = c;
 14a:	8a 45 e7             	mov    -0x19(%ebp),%al
 14d:	8b 55 08             	mov    0x8(%ebp),%edx
 150:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 154:	3c 0a                	cmp    $0xa,%al
 156:	74 0e                	je     166 <gets+0x3e>
 158:	3c 0d                	cmp    $0xd,%al
 15a:	74 0a                	je     166 <gets+0x3e>
  for(i=0; i+1 < max; ){
 15c:	89 df                	mov    %ebx,%edi
 15e:	43                   	inc    %ebx
 15f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 162:	7c d4                	jl     138 <gets+0x10>
 164:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 16d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 170:	5b                   	pop    %ebx
 171:	5e                   	pop    %esi
 172:	5f                   	pop    %edi
 173:	5d                   	pop    %ebp
 174:	c3                   	ret
 175:	8d 76 00             	lea    0x0(%esi),%esi

00000178 <stat>:

int
stat(const char *n, struct stat *st)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	56                   	push   %esi
 17c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17d:	83 ec 08             	sub    $0x8,%esp
 180:	6a 00                	push   $0x0
 182:	ff 75 08             	push   0x8(%ebp)
 185:	e8 d5 00 00 00       	call   25f <open>
  if(fd < 0)
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	85 c0                	test   %eax,%eax
 18f:	78 27                	js     1b8 <stat+0x40>
 191:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 193:	83 ec 08             	sub    $0x8,%esp
 196:	ff 75 0c             	push   0xc(%ebp)
 199:	50                   	push   %eax
 19a:	e8 d8 00 00 00       	call   277 <fstat>
 19f:	89 c6                	mov    %eax,%esi
  close(fd);
 1a1:	89 1c 24             	mov    %ebx,(%esp)
 1a4:	e8 9e 00 00 00       	call   247 <close>
  return r;
 1a9:	83 c4 10             	add    $0x10,%esp
}
 1ac:	89 f0                	mov    %esi,%eax
 1ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b1:	5b                   	pop    %ebx
 1b2:	5e                   	pop    %esi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bd:	eb ed                	jmp    1ac <stat+0x34>
 1bf:	90                   	nop

000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c7:	0f be 01             	movsbl (%ecx),%eax
 1ca:	8d 50 d0             	lea    -0x30(%eax),%edx
 1cd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1d0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d5:	77 16                	ja     1ed <atoi+0x2d>
 1d7:	90                   	nop
    n = n*10 + *s++ - '0';
 1d8:	41                   	inc    %ecx
 1d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1dc:	01 d2                	add    %edx,%edx
 1de:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1e2:	0f be 01             	movsbl (%ecx),%eax
 1e5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1e8:	80 fb 09             	cmp    $0x9,%bl
 1eb:	76 eb                	jbe    1d8 <atoi+0x18>
  return n;
}
 1ed:	89 d0                	mov    %edx,%eax
 1ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f2:	c9                   	leave
 1f3:	c3                   	ret

000001f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	57                   	push   %edi
 1f8:	56                   	push   %esi
 1f9:	8b 55 08             	mov    0x8(%ebp),%edx
 1fc:	8b 75 0c             	mov    0xc(%ebp),%esi
 1ff:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 202:	85 c0                	test   %eax,%eax
 204:	7e 0b                	jle    211 <memmove+0x1d>
 206:	01 d0                	add    %edx,%eax
  dst = vdst;
 208:	89 d7                	mov    %edx,%edi
 20a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 20c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 20d:	39 f8                	cmp    %edi,%eax
 20f:	75 fb                	jne    20c <memmove+0x18>
  return vdst;
}
 211:	89 d0                	mov    %edx,%eax
 213:	5e                   	pop    %esi
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret

00000217 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret

0000021f <exit>:
SYSCALL(exit)
 21f:	b8 02 00 00 00       	mov    $0x2,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret

00000227 <wait>:
SYSCALL(wait)
 227:	b8 03 00 00 00       	mov    $0x3,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret

0000022f <pipe>:
SYSCALL(pipe)
 22f:	b8 04 00 00 00       	mov    $0x4,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret

00000237 <read>:
SYSCALL(read)
 237:	b8 05 00 00 00       	mov    $0x5,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret

0000023f <write>:
SYSCALL(write)
 23f:	b8 10 00 00 00       	mov    $0x10,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret

00000247 <close>:
SYSCALL(close)
 247:	b8 15 00 00 00       	mov    $0x15,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret

0000024f <kill>:
SYSCALL(kill)
 24f:	b8 06 00 00 00       	mov    $0x6,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret

00000257 <exec>:
SYSCALL(exec)
 257:	b8 07 00 00 00       	mov    $0x7,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret

0000025f <open>:
SYSCALL(open)
 25f:	b8 0f 00 00 00       	mov    $0xf,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret

00000267 <mknod>:
SYSCALL(mknod)
 267:	b8 11 00 00 00       	mov    $0x11,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret

0000026f <unlink>:
SYSCALL(unlink)
 26f:	b8 12 00 00 00       	mov    $0x12,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <fstat>:
SYSCALL(fstat)
 277:	b8 08 00 00 00       	mov    $0x8,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <link>:
SYSCALL(link)
 27f:	b8 13 00 00 00       	mov    $0x13,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <mkdir>:
SYSCALL(mkdir)
 287:	b8 14 00 00 00       	mov    $0x14,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <chdir>:
SYSCALL(chdir)
 28f:	b8 09 00 00 00       	mov    $0x9,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <dup>:
SYSCALL(dup)
 297:	b8 0a 00 00 00       	mov    $0xa,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <getpid>:
SYSCALL(getpid)
 29f:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <sbrk>:
SYSCALL(sbrk)
 2a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <sleep>:
SYSCALL(sleep)
 2af:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <uptime>:
SYSCALL(uptime)
 2b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <signal>:
SYSCALL(signal)
 2bf:	b8 16 00 00 00       	mov    $0x16,%eax
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
 2fc:	8a 92 bc 06 00 00    	mov    0x6bc(%edx),%dl
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
 334:	e8 06 ff ff ff       	call   23f <write>
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
 383:	e8 b7 fe ff ff       	call   23f <write>
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
 3b6:	ff 24 85 64 06 00 00 	jmp    *0x664(,%eax,4)
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
 3cf:	e8 6b fe ff ff       	call   23f <write>
        putc(fd, c);
 3d4:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3d7:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3da:	83 c4 0c             	add    $0xc,%esp
 3dd:	6a 01                	push   $0x1
 3df:	57                   	push   %edi
 3e0:	56                   	push   %esi
 3e1:	e8 59 fe ff ff       	call   23f <write>
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
 450:	e8 ea fd ff ff       	call   23f <write>
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
 49c:	e8 9e fd ff ff       	call   23f <write>
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
 4bc:	bf 5b 06 00 00       	mov    $0x65b,%edi
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
 4d4:	a1 d0 06 00 00       	mov    0x6d0,%eax
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
 505:	89 15 d0 06 00 00    	mov    %edx,0x6d0
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
 544:	89 15 d0 06 00 00    	mov    %edx,0x6d0
}
 54a:	5b                   	pop    %ebx
 54b:	5e                   	pop    %esi
 54c:	5f                   	pop    %edi
 54d:	5d                   	pop    %ebp
 54e:	c3                   	ret
 54f:	90                   	nop

00000550 <malloc>:
  return freep;
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
 563:	8b 15 d0 06 00 00    	mov    0x6d0,%edx
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
  p = sbrk(nu * sizeof(Header));
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
 59b:	39 05 d0 06 00 00    	cmp    %eax,0x6d0
 5a1:	75 ed                	jne    590 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5a3:	83 ec 0c             	sub    $0xc,%esp
 5a6:	56                   	push   %esi
 5a7:	e8 fb fc ff ff       	call   2a7 <sbrk>
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
 5c3:	8b 15 d0 06 00 00    	mov    0x6d0,%edx
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
 5eb:	89 15 d0 06 00 00    	mov    %edx,0x6d0
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
 604:	c7 05 d0 06 00 00 d4 	movl   $0x6d4,0x6d0
 60b:	06 00 00 
 60e:	c7 05 d4 06 00 00 d4 	movl   $0x6d4,0x6d4
 615:	06 00 00 
    base.s.size = 0;
 618:	c7 05 d8 06 00 00 00 	movl   $0x0,0x6d8
 61f:	00 00 00 
 622:	b8 d4 06 00 00       	mov    $0x6d4,%eax
 627:	e9 4e ff ff ff       	jmp    57a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 62c:	8b 08                	mov    (%eax),%ecx
 62e:	89 0a                	mov    %ecx,(%edx)
 630:	eb b9                	jmp    5eb <malloc+0x9b>
