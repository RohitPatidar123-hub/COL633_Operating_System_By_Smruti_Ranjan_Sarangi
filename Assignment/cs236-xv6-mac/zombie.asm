
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	50                   	push   %eax
  if(fork() > 0)
   f:	e8 d3 01 00 00       	call   1e7 <fork>
  14:	85 c0                	test   %eax,%eax
  16:	7e 0d                	jle    25 <main+0x25>
    sleep(5);  // Let child exit before parent.
  18:	83 ec 0c             	sub    $0xc,%esp
  1b:	6a 05                	push   $0x5
  1d:	e8 5d 02 00 00       	call   27f <sleep>
  22:	83 c4 10             	add    $0x10,%esp
  exit();
  25:	e8 c5 01 00 00       	call   1ef <exit>
  2a:	66 90                	xchg   %ax,%ax

0000002c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	53                   	push   %ebx
  30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	31 c0                	xor    %eax,%eax
  38:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  3b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  3e:	40                   	inc    %eax
  3f:	84 d2                	test   %dl,%dl
  41:	75 f5                	jne    38 <strcpy+0xc>
    ;
  return os;
}
  43:	89 c8                	mov    %ecx,%eax
  45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  48:	c9                   	leave
  49:	c3                   	ret
  4a:	66 90                	xchg   %ax,%ax

0000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	53                   	push   %ebx
  50:	8b 55 08             	mov    0x8(%ebp),%edx
  53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  56:	0f b6 02             	movzbl (%edx),%eax
  59:	84 c0                	test   %al,%al
  5b:	75 10                	jne    6d <strcmp+0x21>
  5d:	eb 2a                	jmp    89 <strcmp+0x3d>
  5f:	90                   	nop
    p++, q++;
  60:	42                   	inc    %edx
  61:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  64:	0f b6 02             	movzbl (%edx),%eax
  67:	84 c0                	test   %al,%al
  69:	74 11                	je     7c <strcmp+0x30>
  6b:	89 cb                	mov    %ecx,%ebx
  6d:	0f b6 0b             	movzbl (%ebx),%ecx
  70:	38 c1                	cmp    %al,%cl
  72:	74 ec                	je     60 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  74:	29 c8                	sub    %ecx,%eax
}
  76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  79:	c9                   	leave
  7a:	c3                   	ret
  7b:	90                   	nop
  return (uchar)*p - (uchar)*q;
  7c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  80:	31 c0                	xor    %eax,%eax
  82:	29 c8                	sub    %ecx,%eax
}
  84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  87:	c9                   	leave
  88:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  89:	0f b6 0b             	movzbl (%ebx),%ecx
  8c:	31 c0                	xor    %eax,%eax
  8e:	eb e4                	jmp    74 <strcmp+0x28>

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 3a 00             	cmpb   $0x0,(%edx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 c0                	xor    %eax,%eax
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	40                   	inc    %eax
  a1:	89 c1                	mov    %eax,%ecx
  a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a7:	75 f7                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  a9:	89 c8                	mov    %ecx,%eax
  ab:	5d                   	pop    %ebp
  ac:	c3                   	ret
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  b0:	31 c9                	xor    %ecx,%ecx
}
  b2:	89 c8                	mov    %ecx,%eax
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret
  b6:	66 90                	xchg   %ax,%ax

000000b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	fc                   	cld
  c6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ce:	c9                   	leave
  cf:	c3                   	ret

000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  d9:	8a 10                	mov    (%eax),%dl
  db:	84 d2                	test   %dl,%dl
  dd:	75 0c                	jne    eb <strchr+0x1b>
  df:	eb 13                	jmp    f4 <strchr+0x24>
  e1:	8d 76 00             	lea    0x0(%esi),%esi
  e4:	40                   	inc    %eax
  e5:	8a 10                	mov    (%eax),%dl
  e7:	84 d2                	test   %dl,%dl
  e9:	74 09                	je     f4 <strchr+0x24>
    if(*s == c)
  eb:	38 d1                	cmp    %dl,%cl
  ed:	75 f5                	jne    e4 <strchr+0x14>
      return (char*)s;
  return 0;
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret
  f1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  f4:	31 c0                	xor    %eax,%eax
}
  f6:	5d                   	pop    %ebp
  f7:	c3                   	ret

000000f8 <gets>:

char*
gets(char *buf, int max)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	57                   	push   %edi
  fc:	56                   	push   %esi
  fd:	53                   	push   %ebx
  fe:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 101:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 103:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 106:	eb 24                	jmp    12c <gets+0x34>
    cc = read(0, &c, 1);
 108:	50                   	push   %eax
 109:	6a 01                	push   $0x1
 10b:	56                   	push   %esi
 10c:	6a 00                	push   $0x0
 10e:	e8 f4 00 00 00       	call   207 <read>
    if(cc < 1)
 113:	83 c4 10             	add    $0x10,%esp
 116:	85 c0                	test   %eax,%eax
 118:	7e 1a                	jle    134 <gets+0x3c>
      break;
    buf[i++] = c;
 11a:	8a 45 e7             	mov    -0x19(%ebp),%al
 11d:	8b 55 08             	mov    0x8(%ebp),%edx
 120:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 124:	3c 0a                	cmp    $0xa,%al
 126:	74 0e                	je     136 <gets+0x3e>
 128:	3c 0d                	cmp    $0xd,%al
 12a:	74 0a                	je     136 <gets+0x3e>
  for(i=0; i+1 < max; ){
 12c:	89 df                	mov    %ebx,%edi
 12e:	43                   	inc    %ebx
 12f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 132:	7c d4                	jl     108 <gets+0x10>
 134:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 13d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret
 145:	8d 76 00             	lea    0x0(%esi),%esi

00000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	56                   	push   %esi
 14c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	6a 00                	push   $0x0
 152:	ff 75 08             	push   0x8(%ebp)
 155:	e8 d5 00 00 00       	call   22f <open>
  if(fd < 0)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	85 c0                	test   %eax,%eax
 15f:	78 27                	js     188 <stat+0x40>
 161:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 163:	83 ec 08             	sub    $0x8,%esp
 166:	ff 75 0c             	push   0xc(%ebp)
 169:	50                   	push   %eax
 16a:	e8 d8 00 00 00       	call   247 <fstat>
 16f:	89 c6                	mov    %eax,%esi
  close(fd);
 171:	89 1c 24             	mov    %ebx,(%esp)
 174:	e8 9e 00 00 00       	call   217 <close>
  return r;
 179:	83 c4 10             	add    $0x10,%esp
}
 17c:	89 f0                	mov    %esi,%eax
 17e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret
 185:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 188:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18d:	eb ed                	jmp    17c <stat+0x34>
 18f:	90                   	nop

00000190 <atoi>:

int
atoi(const char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 197:	0f be 01             	movsbl (%ecx),%eax
 19a:	8d 50 d0             	lea    -0x30(%eax),%edx
 19d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1a0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a5:	77 16                	ja     1bd <atoi+0x2d>
 1a7:	90                   	nop
    n = n*10 + *s++ - '0';
 1a8:	41                   	inc    %ecx
 1a9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1ac:	01 d2                	add    %edx,%edx
 1ae:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1b2:	0f be 01             	movsbl (%ecx),%eax
 1b5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b8:	80 fb 09             	cmp    $0x9,%bl
 1bb:	76 eb                	jbe    1a8 <atoi+0x18>
  return n;
}
 1bd:	89 d0                	mov    %edx,%eax
 1bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c2:	c9                   	leave
 1c3:	c3                   	ret

000001c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	56                   	push   %esi
 1c9:	8b 55 08             	mov    0x8(%ebp),%edx
 1cc:	8b 75 0c             	mov    0xc(%ebp),%esi
 1cf:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1d2:	85 c0                	test   %eax,%eax
 1d4:	7e 0b                	jle    1e1 <memmove+0x1d>
 1d6:	01 d0                	add    %edx,%eax
  dst = vdst;
 1d8:	89 d7                	mov    %edx,%edi
 1da:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1dc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1dd:	39 f8                	cmp    %edi,%eax
 1df:	75 fb                	jne    1dc <memmove+0x18>
  return vdst;
}
 1e1:	89 d0                	mov    %edx,%eax
 1e3:	5e                   	pop    %esi
 1e4:	5f                   	pop    %edi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret

000001e7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e7:	b8 01 00 00 00       	mov    $0x1,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret

000001ef <exit>:
SYSCALL(exit)
 1ef:	b8 02 00 00 00       	mov    $0x2,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret

000001f7 <wait>:
SYSCALL(wait)
 1f7:	b8 03 00 00 00       	mov    $0x3,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret

000001ff <pipe>:
SYSCALL(pipe)
 1ff:	b8 04 00 00 00       	mov    $0x4,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret

00000207 <read>:
SYSCALL(read)
 207:	b8 05 00 00 00       	mov    $0x5,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret

0000020f <write>:
SYSCALL(write)
 20f:	b8 10 00 00 00       	mov    $0x10,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret

00000217 <close>:
SYSCALL(close)
 217:	b8 15 00 00 00       	mov    $0x15,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret

0000021f <kill>:
SYSCALL(kill)
 21f:	b8 06 00 00 00       	mov    $0x6,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret

00000227 <exec>:
SYSCALL(exec)
 227:	b8 07 00 00 00       	mov    $0x7,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret

0000022f <open>:
SYSCALL(open)
 22f:	b8 0f 00 00 00       	mov    $0xf,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret

00000237 <mknod>:
SYSCALL(mknod)
 237:	b8 11 00 00 00       	mov    $0x11,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret

0000023f <unlink>:
SYSCALL(unlink)
 23f:	b8 12 00 00 00       	mov    $0x12,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret

00000247 <fstat>:
SYSCALL(fstat)
 247:	b8 08 00 00 00       	mov    $0x8,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret

0000024f <link>:
SYSCALL(link)
 24f:	b8 13 00 00 00       	mov    $0x13,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret

00000257 <mkdir>:
SYSCALL(mkdir)
 257:	b8 14 00 00 00       	mov    $0x14,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret

0000025f <chdir>:
SYSCALL(chdir)
 25f:	b8 09 00 00 00       	mov    $0x9,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret

00000267 <dup>:
SYSCALL(dup)
 267:	b8 0a 00 00 00       	mov    $0xa,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret

0000026f <getpid>:
SYSCALL(getpid)
 26f:	b8 0b 00 00 00       	mov    $0xb,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <sbrk>:
SYSCALL(sbrk)
 277:	b8 0c 00 00 00       	mov    $0xc,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <sleep>:
SYSCALL(sleep)
 27f:	b8 0d 00 00 00       	mov    $0xd,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <uptime>:
SYSCALL(uptime)
 287:	b8 0e 00 00 00       	mov    $0xe,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <signal>:
SYSCALL(signal)
 28f:	b8 16 00 00 00       	mov    $0x16,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret
 297:	90                   	nop

00000298 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	57                   	push   %edi
 29c:	56                   	push   %esi
 29d:	53                   	push   %ebx
 29e:	83 ec 3c             	sub    $0x3c,%esp
 2a1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2a4:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a9:	85 c9                	test   %ecx,%ecx
 2ab:	74 04                	je     2b1 <printint+0x19>
 2ad:	85 d2                	test   %edx,%edx
 2af:	78 6b                	js     31c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2b1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2b4:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2bb:	31 c9                	xor    %ecx,%ecx
 2bd:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2c3:	31 d2                	xor    %edx,%edx
 2c5:	f7 f3                	div    %ebx
 2c7:	89 cf                	mov    %ecx,%edi
 2c9:	8d 49 01             	lea    0x1(%ecx),%ecx
 2cc:	8a 92 64 06 00 00    	mov    0x664(%edx),%dl
 2d2:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 2d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 2d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2dc:	39 da                	cmp    %ebx,%edx
 2de:	73 e0                	jae    2c0 <printint+0x28>
  if(neg)
 2e0:	8b 55 08             	mov    0x8(%ebp),%edx
 2e3:	85 d2                	test   %edx,%edx
 2e5:	74 07                	je     2ee <printint+0x56>
    buf[i++] = '-';
 2e7:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 2ec:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 2ee:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 2f1:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 2f5:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 2f8:	8a 07                	mov    (%edi),%al
 2fa:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 2fd:	50                   	push   %eax
 2fe:	6a 01                	push   $0x1
 300:	56                   	push   %esi
 301:	ff 75 c0             	push   -0x40(%ebp)
 304:	e8 06 ff ff ff       	call   20f <write>
  while(--i >= 0)
 309:	89 f8                	mov    %edi,%eax
 30b:	4f                   	dec    %edi
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	39 d8                	cmp    %ebx,%eax
 311:	75 e5                	jne    2f8 <printint+0x60>
}
 313:	8d 65 f4             	lea    -0xc(%ebp),%esp
 316:	5b                   	pop    %ebx
 317:	5e                   	pop    %esi
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret
 31b:	90                   	nop
    x = -xx;
 31c:	f7 da                	neg    %edx
 31e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 321:	eb 98                	jmp    2bb <printint+0x23>
 323:	90                   	nop

00000324 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
 328:	56                   	push   %esi
 329:	53                   	push   %ebx
 32a:	83 ec 2c             	sub    $0x2c,%esp
 32d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 330:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 333:	8a 03                	mov    (%ebx),%al
 335:	84 c0                	test   %al,%al
 337:	74 2a                	je     363 <printf+0x3f>
 339:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 33a:	8d 4d 10             	lea    0x10(%ebp),%ecx
 33d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 340:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 343:	83 fa 25             	cmp    $0x25,%edx
 346:	74 24                	je     36c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 348:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 34b:	50                   	push   %eax
 34c:	6a 01                	push   $0x1
 34e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 351:	50                   	push   %eax
 352:	56                   	push   %esi
 353:	e8 b7 fe ff ff       	call   20f <write>
  for(i = 0; fmt[i]; i++){
 358:	43                   	inc    %ebx
 359:	8a 43 ff             	mov    -0x1(%ebx),%al
 35c:	83 c4 10             	add    $0x10,%esp
 35f:	84 c0                	test   %al,%al
 361:	75 dd                	jne    340 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 363:	8d 65 f4             	lea    -0xc(%ebp),%esp
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret
 36b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 36c:	8a 13                	mov    (%ebx),%dl
 36e:	84 d2                	test   %dl,%dl
 370:	74 f1                	je     363 <printf+0x3f>
    c = fmt[i] & 0xff;
 372:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 375:	80 fa 25             	cmp    $0x25,%dl
 378:	0f 84 fe 00 00 00    	je     47c <printf+0x158>
 37e:	83 e8 63             	sub    $0x63,%eax
 381:	83 f8 15             	cmp    $0x15,%eax
 384:	77 0a                	ja     390 <printf+0x6c>
 386:	ff 24 85 0c 06 00 00 	jmp    *0x60c(,%eax,4)
 38d:	8d 76 00             	lea    0x0(%esi),%esi
 390:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 393:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 397:	50                   	push   %eax
 398:	6a 01                	push   $0x1
 39a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 39d:	57                   	push   %edi
 39e:	56                   	push   %esi
 39f:	e8 6b fe ff ff       	call   20f <write>
        putc(fd, c);
 3a4:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3a7:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3aa:	83 c4 0c             	add    $0xc,%esp
 3ad:	6a 01                	push   $0x1
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	e8 59 fe ff ff       	call   20f <write>
  for(i = 0; fmt[i]; i++){
 3b6:	83 c3 02             	add    $0x2,%ebx
 3b9:	8a 43 ff             	mov    -0x1(%ebx),%al
 3bc:	83 c4 10             	add    $0x10,%esp
 3bf:	84 c0                	test   %al,%al
 3c1:	0f 85 79 ff ff ff    	jne    340 <printf+0x1c>
}
 3c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ca:	5b                   	pop    %ebx
 3cb:	5e                   	pop    %esi
 3cc:	5f                   	pop    %edi
 3cd:	5d                   	pop    %ebp
 3ce:	c3                   	ret
 3cf:	90                   	nop
        printint(fd, *ap, 16, 0);
 3d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3d3:	8b 17                	mov    (%edi),%edx
 3d5:	83 ec 0c             	sub    $0xc,%esp
 3d8:	6a 00                	push   $0x0
 3da:	b9 10 00 00 00       	mov    $0x10,%ecx
 3df:	89 f0                	mov    %esi,%eax
 3e1:	e8 b2 fe ff ff       	call   298 <printint>
        ap++;
 3e6:	83 c7 04             	add    $0x4,%edi
 3e9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3ec:	eb c8                	jmp    3b6 <printf+0x92>
 3ee:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 3f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 3f3:	8b 01                	mov    (%ecx),%eax
        ap++;
 3f5:	83 c1 04             	add    $0x4,%ecx
 3f8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 3fb:	85 c0                	test   %eax,%eax
 3fd:	0f 84 89 00 00 00    	je     48c <printf+0x168>
        while(*s != 0){
 403:	8a 10                	mov    (%eax),%dl
 405:	84 d2                	test   %dl,%dl
 407:	74 29                	je     432 <printf+0x10e>
 409:	89 c7                	mov    %eax,%edi
 40b:	88 d0                	mov    %dl,%al
 40d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 410:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 413:	89 fb                	mov    %edi,%ebx
 415:	89 cf                	mov    %ecx,%edi
 417:	90                   	nop
          putc(fd, *s);
 418:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 41b:	50                   	push   %eax
 41c:	6a 01                	push   $0x1
 41e:	57                   	push   %edi
 41f:	56                   	push   %esi
 420:	e8 ea fd ff ff       	call   20f <write>
          s++;
 425:	43                   	inc    %ebx
        while(*s != 0){
 426:	8a 03                	mov    (%ebx),%al
 428:	83 c4 10             	add    $0x10,%esp
 42b:	84 c0                	test   %al,%al
 42d:	75 e9                	jne    418 <printf+0xf4>
 42f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 432:	83 c3 02             	add    $0x2,%ebx
 435:	8a 43 ff             	mov    -0x1(%ebx),%al
 438:	84 c0                	test   %al,%al
 43a:	0f 85 00 ff ff ff    	jne    340 <printf+0x1c>
 440:	e9 1e ff ff ff       	jmp    363 <printf+0x3f>
 445:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 448:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 44b:	8b 17                	mov    (%edi),%edx
 44d:	83 ec 0c             	sub    $0xc,%esp
 450:	6a 01                	push   $0x1
 452:	b9 0a 00 00 00       	mov    $0xa,%ecx
 457:	eb 86                	jmp    3df <printf+0xbb>
 459:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 45c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 45f:	8b 00                	mov    (%eax),%eax
 461:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 464:	51                   	push   %ecx
 465:	6a 01                	push   $0x1
 467:	8d 7d e7             	lea    -0x19(%ebp),%edi
 46a:	57                   	push   %edi
 46b:	56                   	push   %esi
 46c:	e8 9e fd ff ff       	call   20f <write>
        ap++;
 471:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 475:	e9 3c ff ff ff       	jmp    3b6 <printf+0x92>
 47a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 47c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 47f:	52                   	push   %edx
 480:	6a 01                	push   $0x1
 482:	8d 7d e7             	lea    -0x19(%ebp),%edi
 485:	e9 25 ff ff ff       	jmp    3af <printf+0x8b>
 48a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 48c:	bf 04 06 00 00       	mov    $0x604,%edi
 491:	b0 28                	mov    $0x28,%al
 493:	e9 75 ff ff ff       	jmp    40d <printf+0xe9>

00000498 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	57                   	push   %edi
 49c:	56                   	push   %esi
 49d:	53                   	push   %ebx
 49e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4a1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4a4:	a1 78 06 00 00       	mov    0x678,%eax
 4a9:	8d 76 00             	lea    0x0(%esi),%esi
 4ac:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ae:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4b0:	39 ca                	cmp    %ecx,%edx
 4b2:	73 2c                	jae    4e0 <free+0x48>
 4b4:	39 c1                	cmp    %eax,%ecx
 4b6:	72 04                	jb     4bc <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4b8:	39 c2                	cmp    %eax,%edx
 4ba:	72 f0                	jb     4ac <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4bc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4bf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4c2:	39 f8                	cmp    %edi,%eax
 4c4:	74 2c                	je     4f2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4c6:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4c9:	8b 42 04             	mov    0x4(%edx),%eax
 4cc:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4cf:	39 f1                	cmp    %esi,%ecx
 4d1:	74 36                	je     509 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 4d3:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 4d5:	89 15 78 06 00 00    	mov    %edx,0x678
}
 4db:	5b                   	pop    %ebx
 4dc:	5e                   	pop    %esi
 4dd:	5f                   	pop    %edi
 4de:	5d                   	pop    %ebp
 4df:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e0:	39 c2                	cmp    %eax,%edx
 4e2:	72 c8                	jb     4ac <free+0x14>
 4e4:	39 c1                	cmp    %eax,%ecx
 4e6:	73 c4                	jae    4ac <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 4e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ee:	39 f8                	cmp    %edi,%eax
 4f0:	75 d4                	jne    4c6 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 4f2:	03 70 04             	add    0x4(%eax),%esi
 4f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4f8:	8b 02                	mov    (%edx),%eax
 4fa:	8b 00                	mov    (%eax),%eax
 4fc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 4ff:	8b 42 04             	mov    0x4(%edx),%eax
 502:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 505:	39 f1                	cmp    %esi,%ecx
 507:	75 ca                	jne    4d3 <free+0x3b>
    p->s.size += bp->s.size;
 509:	03 43 fc             	add    -0x4(%ebx),%eax
 50c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 50f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 512:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 514:	89 15 78 06 00 00    	mov    %edx,0x678
}
 51a:	5b                   	pop    %ebx
 51b:	5e                   	pop    %esi
 51c:	5f                   	pop    %edi
 51d:	5d                   	pop    %ebp
 51e:	c3                   	ret
 51f:	90                   	nop

00000520 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	8d 78 07             	lea    0x7(%eax),%edi
 52f:	c1 ef 03             	shr    $0x3,%edi
 532:	47                   	inc    %edi
  if((prevp = freep) == 0){
 533:	8b 15 78 06 00 00    	mov    0x678,%edx
 539:	85 d2                	test   %edx,%edx
 53b:	0f 84 93 00 00 00    	je     5d4 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 541:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 543:	8b 48 04             	mov    0x4(%eax),%ecx
 546:	39 f9                	cmp    %edi,%ecx
 548:	73 62                	jae    5ac <malloc+0x8c>
  if(nu < 4096)
 54a:	89 fb                	mov    %edi,%ebx
 54c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 552:	72 78                	jb     5cc <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 554:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 55b:	eb 0e                	jmp    56b <malloc+0x4b>
 55d:	8d 76 00             	lea    0x0(%esi),%esi
 560:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 562:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 564:	8b 48 04             	mov    0x4(%eax),%ecx
 567:	39 f9                	cmp    %edi,%ecx
 569:	73 41                	jae    5ac <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 56b:	39 05 78 06 00 00    	cmp    %eax,0x678
 571:	75 ed                	jne    560 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 573:	83 ec 0c             	sub    $0xc,%esp
 576:	56                   	push   %esi
 577:	e8 fb fc ff ff       	call   277 <sbrk>
  if(p == (char*)-1)
 57c:	83 c4 10             	add    $0x10,%esp
 57f:	83 f8 ff             	cmp    $0xffffffff,%eax
 582:	74 1c                	je     5a0 <malloc+0x80>
  hp->s.size = nu;
 584:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 587:	83 ec 0c             	sub    $0xc,%esp
 58a:	83 c0 08             	add    $0x8,%eax
 58d:	50                   	push   %eax
 58e:	e8 05 ff ff ff       	call   498 <free>
  return freep;
 593:	8b 15 78 06 00 00    	mov    0x678,%edx
      if((p = morecore(nunits)) == 0)
 599:	83 c4 10             	add    $0x10,%esp
 59c:	85 d2                	test   %edx,%edx
 59e:	75 c2                	jne    562 <malloc+0x42>
        return 0;
 5a0:	31 c0                	xor    %eax,%eax
  }
}
 5a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a5:	5b                   	pop    %ebx
 5a6:	5e                   	pop    %esi
 5a7:	5f                   	pop    %edi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret
 5aa:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5ac:	39 cf                	cmp    %ecx,%edi
 5ae:	74 4c                	je     5fc <malloc+0xdc>
        p->s.size -= nunits;
 5b0:	29 f9                	sub    %edi,%ecx
 5b2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5b5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5b8:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5bb:	89 15 78 06 00 00    	mov    %edx,0x678
      return (void*)(p + 1);
 5c1:	83 c0 08             	add    $0x8,%eax
}
 5c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c7:	5b                   	pop    %ebx
 5c8:	5e                   	pop    %esi
 5c9:	5f                   	pop    %edi
 5ca:	5d                   	pop    %ebp
 5cb:	c3                   	ret
  if(nu < 4096)
 5cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 5d1:	eb 81                	jmp    554 <malloc+0x34>
 5d3:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 5d4:	c7 05 78 06 00 00 7c 	movl   $0x67c,0x678
 5db:	06 00 00 
 5de:	c7 05 7c 06 00 00 7c 	movl   $0x67c,0x67c
 5e5:	06 00 00 
    base.s.size = 0;
 5e8:	c7 05 80 06 00 00 00 	movl   $0x0,0x680
 5ef:	00 00 00 
 5f2:	b8 7c 06 00 00       	mov    $0x67c,%eax
 5f7:	e9 4e ff ff ff       	jmp    54a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 5fc:	8b 08                	mov    (%eax),%ecx
 5fe:	89 0a                	mov    %ecx,(%edx)
 600:	eb b9                	jmp    5bb <malloc+0x9b>
