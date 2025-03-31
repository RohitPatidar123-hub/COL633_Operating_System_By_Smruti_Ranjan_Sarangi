
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

0000028f <custom_fork>:
SYSCALL(custom_fork)
 28f:	b8 17 00 00 00       	mov    $0x17,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <scheduler_start>:
SYSCALL(scheduler_start)
 297:	b8 18 00 00 00       	mov    $0x18,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret
 29f:	90                   	nop

000002a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	56                   	push   %esi
 2a5:	53                   	push   %ebx
 2a6:	83 ec 3c             	sub    $0x3c,%esp
 2a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2ac:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b1:	85 c9                	test   %ecx,%ecx
 2b3:	74 04                	je     2b9 <printint+0x19>
 2b5:	85 d2                	test   %edx,%edx
 2b7:	78 6b                	js     324 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2b9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 2bc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 2c3:	31 c9                	xor    %ecx,%ecx
 2c5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2cb:	31 d2                	xor    %edx,%edx
 2cd:	f7 f3                	div    %ebx
 2cf:	89 cf                	mov    %ecx,%edi
 2d1:	8d 49 01             	lea    0x1(%ecx),%ecx
 2d4:	8a 92 6c 06 00 00    	mov    0x66c(%edx),%dl
 2da:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 2de:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 2e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2e4:	39 da                	cmp    %ebx,%edx
 2e6:	73 e0                	jae    2c8 <printint+0x28>
  if(neg)
 2e8:	8b 55 08             	mov    0x8(%ebp),%edx
 2eb:	85 d2                	test   %edx,%edx
 2ed:	74 07                	je     2f6 <printint+0x56>
    buf[i++] = '-';
 2ef:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 2f4:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 2f6:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 2f9:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 300:	8a 07                	mov    (%edi),%al
 302:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 305:	50                   	push   %eax
 306:	6a 01                	push   $0x1
 308:	56                   	push   %esi
 309:	ff 75 c0             	push   -0x40(%ebp)
 30c:	e8 fe fe ff ff       	call   20f <write>
  while(--i >= 0)
 311:	89 f8                	mov    %edi,%eax
 313:	4f                   	dec    %edi
 314:	83 c4 10             	add    $0x10,%esp
 317:	39 d8                	cmp    %ebx,%eax
 319:	75 e5                	jne    300 <printint+0x60>
}
 31b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31e:	5b                   	pop    %ebx
 31f:	5e                   	pop    %esi
 320:	5f                   	pop    %edi
 321:	5d                   	pop    %ebp
 322:	c3                   	ret
 323:	90                   	nop
    x = -xx;
 324:	f7 da                	neg    %edx
 326:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 329:	eb 98                	jmp    2c3 <printint+0x23>
 32b:	90                   	nop

0000032c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	57                   	push   %edi
 330:	56                   	push   %esi
 331:	53                   	push   %ebx
 332:	83 ec 2c             	sub    $0x2c,%esp
 335:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 33b:	8a 03                	mov    (%ebx),%al
 33d:	84 c0                	test   %al,%al
 33f:	74 2a                	je     36b <printf+0x3f>
 341:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 342:	8d 4d 10             	lea    0x10(%ebp),%ecx
 345:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 348:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 34b:	83 fa 25             	cmp    $0x25,%edx
 34e:	74 24                	je     374 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 350:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 353:	50                   	push   %eax
 354:	6a 01                	push   $0x1
 356:	8d 45 e7             	lea    -0x19(%ebp),%eax
 359:	50                   	push   %eax
 35a:	56                   	push   %esi
 35b:	e8 af fe ff ff       	call   20f <write>
  for(i = 0; fmt[i]; i++){
 360:	43                   	inc    %ebx
 361:	8a 43 ff             	mov    -0x1(%ebx),%al
 364:	83 c4 10             	add    $0x10,%esp
 367:	84 c0                	test   %al,%al
 369:	75 dd                	jne    348 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 36b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36e:	5b                   	pop    %ebx
 36f:	5e                   	pop    %esi
 370:	5f                   	pop    %edi
 371:	5d                   	pop    %ebp
 372:	c3                   	ret
 373:	90                   	nop
  for(i = 0; fmt[i]; i++){
 374:	8a 13                	mov    (%ebx),%dl
 376:	84 d2                	test   %dl,%dl
 378:	74 f1                	je     36b <printf+0x3f>
    c = fmt[i] & 0xff;
 37a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 37d:	80 fa 25             	cmp    $0x25,%dl
 380:	0f 84 fe 00 00 00    	je     484 <printf+0x158>
 386:	83 e8 63             	sub    $0x63,%eax
 389:	83 f8 15             	cmp    $0x15,%eax
 38c:	77 0a                	ja     398 <printf+0x6c>
 38e:	ff 24 85 14 06 00 00 	jmp    *0x614(,%eax,4)
 395:	8d 76 00             	lea    0x0(%esi),%esi
 398:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 39b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 39f:	50                   	push   %eax
 3a0:	6a 01                	push   $0x1
 3a2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3a5:	57                   	push   %edi
 3a6:	56                   	push   %esi
 3a7:	e8 63 fe ff ff       	call   20f <write>
        putc(fd, c);
 3ac:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3af:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3b2:	83 c4 0c             	add    $0xc,%esp
 3b5:	6a 01                	push   $0x1
 3b7:	57                   	push   %edi
 3b8:	56                   	push   %esi
 3b9:	e8 51 fe ff ff       	call   20f <write>
  for(i = 0; fmt[i]; i++){
 3be:	83 c3 02             	add    $0x2,%ebx
 3c1:	8a 43 ff             	mov    -0x1(%ebx),%al
 3c4:	83 c4 10             	add    $0x10,%esp
 3c7:	84 c0                	test   %al,%al
 3c9:	0f 85 79 ff ff ff    	jne    348 <printf+0x1c>
}
 3cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d2:	5b                   	pop    %ebx
 3d3:	5e                   	pop    %esi
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret
 3d7:	90                   	nop
        printint(fd, *ap, 16, 0);
 3d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3db:	8b 17                	mov    (%edi),%edx
 3dd:	83 ec 0c             	sub    $0xc,%esp
 3e0:	6a 00                	push   $0x0
 3e2:	b9 10 00 00 00       	mov    $0x10,%ecx
 3e7:	89 f0                	mov    %esi,%eax
 3e9:	e8 b2 fe ff ff       	call   2a0 <printint>
        ap++;
 3ee:	83 c7 04             	add    $0x4,%edi
 3f1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3f4:	eb c8                	jmp    3be <printf+0x92>
 3f6:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 3f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 3fb:	8b 01                	mov    (%ecx),%eax
        ap++;
 3fd:	83 c1 04             	add    $0x4,%ecx
 400:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 403:	85 c0                	test   %eax,%eax
 405:	0f 84 89 00 00 00    	je     494 <printf+0x168>
        while(*s != 0){
 40b:	8a 10                	mov    (%eax),%dl
 40d:	84 d2                	test   %dl,%dl
 40f:	74 29                	je     43a <printf+0x10e>
 411:	89 c7                	mov    %eax,%edi
 413:	88 d0                	mov    %dl,%al
 415:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 418:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 41b:	89 fb                	mov    %edi,%ebx
 41d:	89 cf                	mov    %ecx,%edi
 41f:	90                   	nop
          putc(fd, *s);
 420:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 423:	50                   	push   %eax
 424:	6a 01                	push   $0x1
 426:	57                   	push   %edi
 427:	56                   	push   %esi
 428:	e8 e2 fd ff ff       	call   20f <write>
          s++;
 42d:	43                   	inc    %ebx
        while(*s != 0){
 42e:	8a 03                	mov    (%ebx),%al
 430:	83 c4 10             	add    $0x10,%esp
 433:	84 c0                	test   %al,%al
 435:	75 e9                	jne    420 <printf+0xf4>
 437:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 43a:	83 c3 02             	add    $0x2,%ebx
 43d:	8a 43 ff             	mov    -0x1(%ebx),%al
 440:	84 c0                	test   %al,%al
 442:	0f 85 00 ff ff ff    	jne    348 <printf+0x1c>
 448:	e9 1e ff ff ff       	jmp    36b <printf+0x3f>
 44d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 450:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 453:	8b 17                	mov    (%edi),%edx
 455:	83 ec 0c             	sub    $0xc,%esp
 458:	6a 01                	push   $0x1
 45a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 45f:	eb 86                	jmp    3e7 <printf+0xbb>
 461:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 464:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 467:	8b 00                	mov    (%eax),%eax
 469:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 46c:	51                   	push   %ecx
 46d:	6a 01                	push   $0x1
 46f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 472:	57                   	push   %edi
 473:	56                   	push   %esi
 474:	e8 96 fd ff ff       	call   20f <write>
        ap++;
 479:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 47d:	e9 3c ff ff ff       	jmp    3be <printf+0x92>
 482:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 484:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 487:	52                   	push   %edx
 488:	6a 01                	push   $0x1
 48a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 48d:	e9 25 ff ff ff       	jmp    3b7 <printf+0x8b>
 492:	66 90                	xchg   %ax,%ax
          s = "(null)";
 494:	bf 0c 06 00 00       	mov    $0x60c,%edi
 499:	b0 28                	mov    $0x28,%al
 49b:	e9 75 ff ff ff       	jmp    415 <printf+0xe9>

000004a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4a9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ac:	a1 80 06 00 00       	mov    0x680,%eax
 4b1:	8d 76 00             	lea    0x0(%esi),%esi
 4b4:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4b6:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4b8:	39 ca                	cmp    %ecx,%edx
 4ba:	73 2c                	jae    4e8 <free+0x48>
 4bc:	39 c1                	cmp    %eax,%ecx
 4be:	72 04                	jb     4c4 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4c0:	39 c2                	cmp    %eax,%edx
 4c2:	72 f0                	jb     4b4 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4c4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4c7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ca:	39 f8                	cmp    %edi,%eax
 4cc:	74 2c                	je     4fa <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4ce:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4d1:	8b 42 04             	mov    0x4(%edx),%eax
 4d4:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4d7:	39 f1                	cmp    %esi,%ecx
 4d9:	74 36                	je     511 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 4db:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 4dd:	89 15 80 06 00 00    	mov    %edx,0x680
}
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e8:	39 c2                	cmp    %eax,%edx
 4ea:	72 c8                	jb     4b4 <free+0x14>
 4ec:	39 c1                	cmp    %eax,%ecx
 4ee:	73 c4                	jae    4b4 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 4f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f6:	39 f8                	cmp    %edi,%eax
 4f8:	75 d4                	jne    4ce <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 4fa:	03 70 04             	add    0x4(%eax),%esi
 4fd:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 500:	8b 02                	mov    (%edx),%eax
 502:	8b 00                	mov    (%eax),%eax
 504:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 507:	8b 42 04             	mov    0x4(%edx),%eax
 50a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 50d:	39 f1                	cmp    %esi,%ecx
 50f:	75 ca                	jne    4db <free+0x3b>
    p->s.size += bp->s.size;
 511:	03 43 fc             	add    -0x4(%ebx),%eax
 514:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 517:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 51a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 51c:	89 15 80 06 00 00    	mov    %edx,0x680
}
 522:	5b                   	pop    %ebx
 523:	5e                   	pop    %esi
 524:	5f                   	pop    %edi
 525:	5d                   	pop    %ebp
 526:	c3                   	ret
 527:	90                   	nop

00000528 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	53                   	push   %ebx
 52e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	8d 78 07             	lea    0x7(%eax),%edi
 537:	c1 ef 03             	shr    $0x3,%edi
 53a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 53b:	8b 15 80 06 00 00    	mov    0x680,%edx
 541:	85 d2                	test   %edx,%edx
 543:	0f 84 93 00 00 00    	je     5dc <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 549:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 54b:	8b 48 04             	mov    0x4(%eax),%ecx
 54e:	39 f9                	cmp    %edi,%ecx
 550:	73 62                	jae    5b4 <malloc+0x8c>
  if(nu < 4096)
 552:	89 fb                	mov    %edi,%ebx
 554:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 55a:	72 78                	jb     5d4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 55c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 563:	eb 0e                	jmp    573 <malloc+0x4b>
 565:	8d 76 00             	lea    0x0(%esi),%esi
 568:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 56a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 56c:	8b 48 04             	mov    0x4(%eax),%ecx
 56f:	39 f9                	cmp    %edi,%ecx
 571:	73 41                	jae    5b4 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 573:	39 05 80 06 00 00    	cmp    %eax,0x680
 579:	75 ed                	jne    568 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 57b:	83 ec 0c             	sub    $0xc,%esp
 57e:	56                   	push   %esi
 57f:	e8 f3 fc ff ff       	call   277 <sbrk>
  if(p == (char*)-1)
 584:	83 c4 10             	add    $0x10,%esp
 587:	83 f8 ff             	cmp    $0xffffffff,%eax
 58a:	74 1c                	je     5a8 <malloc+0x80>
  hp->s.size = nu;
 58c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 58f:	83 ec 0c             	sub    $0xc,%esp
 592:	83 c0 08             	add    $0x8,%eax
 595:	50                   	push   %eax
 596:	e8 05 ff ff ff       	call   4a0 <free>
  return freep;
 59b:	8b 15 80 06 00 00    	mov    0x680,%edx
      if((p = morecore(nunits)) == 0)
 5a1:	83 c4 10             	add    $0x10,%esp
 5a4:	85 d2                	test   %edx,%edx
 5a6:	75 c2                	jne    56a <malloc+0x42>
        return 0;
 5a8:	31 c0                	xor    %eax,%eax
  }
}
 5aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ad:	5b                   	pop    %ebx
 5ae:	5e                   	pop    %esi
 5af:	5f                   	pop    %edi
 5b0:	5d                   	pop    %ebp
 5b1:	c3                   	ret
 5b2:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5b4:	39 cf                	cmp    %ecx,%edi
 5b6:	74 4c                	je     604 <malloc+0xdc>
        p->s.size -= nunits;
 5b8:	29 f9                	sub    %edi,%ecx
 5ba:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5bd:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5c0:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 5c3:	89 15 80 06 00 00    	mov    %edx,0x680
      return (void*)(p + 1);
 5c9:	83 c0 08             	add    $0x8,%eax
}
 5cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret
  if(nu < 4096)
 5d4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 5d9:	eb 81                	jmp    55c <malloc+0x34>
 5db:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 5dc:	c7 05 80 06 00 00 84 	movl   $0x684,0x680
 5e3:	06 00 00 
 5e6:	c7 05 84 06 00 00 84 	movl   $0x684,0x684
 5ed:	06 00 00 
    base.s.size = 0;
 5f0:	c7 05 88 06 00 00 00 	movl   $0x0,0x688
 5f7:	00 00 00 
 5fa:	b8 84 06 00 00       	mov    $0x684,%eax
 5ff:	e9 4e ff ff ff       	jmp    552 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 604:	8b 08                	mov    (%eax),%ecx
 606:	89 0a                	mov    %ecx,(%edx)
 608:	eb b9                	jmp    5c3 <malloc+0x9b>
