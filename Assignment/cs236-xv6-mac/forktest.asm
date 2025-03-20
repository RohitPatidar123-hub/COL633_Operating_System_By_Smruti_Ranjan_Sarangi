
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
   6:	e8 2d 00 00 00       	call   38 <forktest>
  exit();
   b:	e8 b3 02 00 00       	call   2c3 <exit>

00000010 <printf>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	83 ec 10             	sub    $0x10,%esp
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  1a:	53                   	push   %ebx
  1b:	e8 44 01 00 00       	call   164 <strlen>
  20:	83 c4 0c             	add    $0xc,%esp
  23:	50                   	push   %eax
  24:	53                   	push   %ebx
  25:	ff 75 08             	push   0x8(%ebp)
  28:	e8 b6 02 00 00       	call   2e3 <write>
}
  2d:	83 c4 10             	add    $0x10,%esp
  30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  33:	c9                   	leave
  34:	c3                   	ret
  35:	8d 76 00             	lea    0x0(%esi),%esi

00000038 <forktest>:
{
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	53                   	push   %ebx
  3c:	83 ec 10             	sub    $0x10,%esp
  write(fd, s, strlen(s));
  3f:	68 6c 03 00 00       	push   $0x36c
  44:	e8 1b 01 00 00       	call   164 <strlen>
  49:	83 c4 0c             	add    $0xc,%esp
  4c:	50                   	push   %eax
  4d:	68 6c 03 00 00       	push   $0x36c
  52:	6a 01                	push   $0x1
  54:	e8 8a 02 00 00       	call   2e3 <write>
  59:	83 c4 10             	add    $0x10,%esp
  for(n=0; n<N; n++){
  5c:	31 db                	xor    %ebx,%ebx
  5e:	eb 0b                	jmp    6b <forktest+0x33>
    if(pid == 0)
  60:	74 4c                	je     ae <forktest+0x76>
  for(n=0; n<N; n++){
  62:	43                   	inc    %ebx
  63:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  69:	74 7d                	je     e8 <forktest+0xb0>
    pid = fork();
  6b:	e8 4b 02 00 00       	call   2bb <fork>
    if(pid < 0)
  70:	85 c0                	test   %eax,%eax
  72:	79 ec                	jns    60 <forktest+0x28>
  for(; n > 0; n--){
  74:	85 db                	test   %ebx,%ebx
  76:	74 0c                	je     84 <forktest+0x4c>
    if(wait() < 0){
  78:	e8 4e 02 00 00       	call   2cb <wait>
  7d:	85 c0                	test   %eax,%eax
  7f:	78 32                	js     b3 <forktest+0x7b>
  for(; n > 0; n--){
  81:	4b                   	dec    %ebx
  82:	75 f4                	jne    78 <forktest+0x40>
  if(wait() != -1){
  84:	e8 42 02 00 00       	call   2cb <wait>
  89:	40                   	inc    %eax
  8a:	75 49                	jne    d5 <forktest+0x9d>
  write(fd, s, strlen(s));
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	68 9e 03 00 00       	push   $0x39e
  94:	e8 cb 00 00 00       	call   164 <strlen>
  99:	83 c4 0c             	add    $0xc,%esp
  9c:	50                   	push   %eax
  9d:	68 9e 03 00 00       	push   $0x39e
  a2:	6a 01                	push   $0x1
  a4:	e8 3a 02 00 00       	call   2e3 <write>
}
  a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ac:	c9                   	leave
  ad:	c3                   	ret
      exit();
  ae:	e8 10 02 00 00       	call   2c3 <exit>
  write(fd, s, strlen(s));
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	68 77 03 00 00       	push   $0x377
  bb:	e8 a4 00 00 00       	call   164 <strlen>
  c0:	83 c4 0c             	add    $0xc,%esp
  c3:	50                   	push   %eax
  c4:	68 77 03 00 00       	push   $0x377
  c9:	6a 01                	push   $0x1
  cb:	e8 13 02 00 00       	call   2e3 <write>
      exit();
  d0:	e8 ee 01 00 00       	call   2c3 <exit>
    printf(1, "wait got too many\n");
  d5:	52                   	push   %edx
  d6:	52                   	push   %edx
  d7:	68 8b 03 00 00       	push   $0x38b
  dc:	6a 01                	push   $0x1
  de:	e8 2d ff ff ff       	call   10 <printf>
    exit();
  e3:	e8 db 01 00 00       	call   2c3 <exit>
    printf(1, "fork claimed to work N times!\n", N);
  e8:	50                   	push   %eax
  e9:	68 e8 03 00 00       	push   $0x3e8
  ee:	68 ac 03 00 00       	push   $0x3ac
  f3:	6a 01                	push   $0x1
  f5:	e8 16 ff ff ff       	call   10 <printf>
    exit();
  fa:	e8 c4 01 00 00       	call   2c3 <exit>
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10a:	31 c0                	xor    %eax,%eax
 10c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 10f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 112:	40                   	inc    %eax
 113:	84 d2                	test   %dl,%dl
 115:	75 f5                	jne    10c <strcpy+0xc>
    ;
  return os;
}
 117:	89 c8                	mov    %ecx,%eax
 119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11c:	c9                   	leave
 11d:	c3                   	ret
 11e:	66 90                	xchg   %ax,%ax

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	84 c0                	test   %al,%al
 12f:	75 10                	jne    141 <strcmp+0x21>
 131:	eb 2a                	jmp    15d <strcmp+0x3d>
 133:	90                   	nop
    p++, q++;
 134:	42                   	inc    %edx
 135:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 138:	0f b6 02             	movzbl (%edx),%eax
 13b:	84 c0                	test   %al,%al
 13d:	74 11                	je     150 <strcmp+0x30>
 13f:	89 cb                	mov    %ecx,%ebx
 141:	0f b6 0b             	movzbl (%ebx),%ecx
 144:	38 c1                	cmp    %al,%cl
 146:	74 ec                	je     134 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 148:	29 c8                	sub    %ecx,%eax
}
 14a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14d:	c9                   	leave
 14e:	c3                   	ret
 14f:	90                   	nop
  return (uchar)*p - (uchar)*q;
 150:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 154:	31 c0                	xor    %eax,%eax
 156:	29 c8                	sub    %ecx,%eax
}
 158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 15b:	c9                   	leave
 15c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 15d:	0f b6 0b             	movzbl (%ebx),%ecx
 160:	31 c0                	xor    %eax,%eax
 162:	eb e4                	jmp    148 <strcmp+0x28>

00000164 <strlen>:

uint
strlen(const char *s)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 16a:	80 3a 00             	cmpb   $0x0,(%edx)
 16d:	74 15                	je     184 <strlen+0x20>
 16f:	31 c0                	xor    %eax,%eax
 171:	8d 76 00             	lea    0x0(%esi),%esi
 174:	40                   	inc    %eax
 175:	89 c1                	mov    %eax,%ecx
 177:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 17b:	75 f7                	jne    174 <strlen+0x10>
    ;
  return n;
}
 17d:	89 c8                	mov    %ecx,%eax
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret
 181:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 184:	31 c9                	xor    %ecx,%ecx
}
 186:	89 c8                	mov    %ecx,%eax
 188:	5d                   	pop    %ebp
 189:	c3                   	ret
 18a:	66 90                	xchg   %ax,%ax

0000018c <memset>:

void*
memset(void *dst, int c, uint n)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 190:	8b 7d 08             	mov    0x8(%ebp),%edi
 193:	8b 4d 10             	mov    0x10(%ebp),%ecx
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	fc                   	cld
 19a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1a2:	c9                   	leave
 1a3:	c3                   	ret

000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1ad:	8a 10                	mov    (%eax),%dl
 1af:	84 d2                	test   %dl,%dl
 1b1:	75 0c                	jne    1bf <strchr+0x1b>
 1b3:	eb 13                	jmp    1c8 <strchr+0x24>
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
 1b8:	40                   	inc    %eax
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	74 09                	je     1c8 <strchr+0x24>
    if(*s == c)
 1bf:	38 d1                	cmp    %dl,%cl
 1c1:	75 f5                	jne    1b8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1c8:	31 c0                	xor    %eax,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1d7:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1da:	eb 24                	jmp    200 <gets+0x34>
    cc = read(0, &c, 1);
 1dc:	50                   	push   %eax
 1dd:	6a 01                	push   $0x1
 1df:	56                   	push   %esi
 1e0:	6a 00                	push   $0x0
 1e2:	e8 f4 00 00 00       	call   2db <read>
    if(cc < 1)
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	85 c0                	test   %eax,%eax
 1ec:	7e 1a                	jle    208 <gets+0x3c>
      break;
    buf[i++] = c;
 1ee:	8a 45 e7             	mov    -0x19(%ebp),%al
 1f1:	8b 55 08             	mov    0x8(%ebp),%edx
 1f4:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1f8:	3c 0a                	cmp    $0xa,%al
 1fa:	74 0e                	je     20a <gets+0x3e>
 1fc:	3c 0d                	cmp    $0xd,%al
 1fe:	74 0a                	je     20a <gets+0x3e>
  for(i=0; i+1 < max; ){
 200:	89 df                	mov    %ebx,%edi
 202:	43                   	inc    %ebx
 203:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 206:	7c d4                	jl     1dc <gets+0x10>
 208:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 211:	8d 65 f4             	lea    -0xc(%ebp),%esp
 214:	5b                   	pop    %ebx
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret
 219:	8d 76 00             	lea    0x0(%esi),%esi

0000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	56                   	push   %esi
 220:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 221:	83 ec 08             	sub    $0x8,%esp
 224:	6a 00                	push   $0x0
 226:	ff 75 08             	push   0x8(%ebp)
 229:	e8 d5 00 00 00       	call   303 <open>
  if(fd < 0)
 22e:	83 c4 10             	add    $0x10,%esp
 231:	85 c0                	test   %eax,%eax
 233:	78 27                	js     25c <stat+0x40>
 235:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 237:	83 ec 08             	sub    $0x8,%esp
 23a:	ff 75 0c             	push   0xc(%ebp)
 23d:	50                   	push   %eax
 23e:	e8 d8 00 00 00       	call   31b <fstat>
 243:	89 c6                	mov    %eax,%esi
  close(fd);
 245:	89 1c 24             	mov    %ebx,(%esp)
 248:	e8 9e 00 00 00       	call   2eb <close>
  return r;
 24d:	83 c4 10             	add    $0x10,%esp
}
 250:	89 f0                	mov    %esi,%eax
 252:	8d 65 f8             	lea    -0x8(%ebp),%esp
 255:	5b                   	pop    %ebx
 256:	5e                   	pop    %esi
 257:	5d                   	pop    %ebp
 258:	c3                   	ret
 259:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 25c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 261:	eb ed                	jmp    250 <stat+0x34>
 263:	90                   	nop

00000264 <atoi>:

int
atoi(const char *s)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	53                   	push   %ebx
 268:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	0f be 01             	movsbl (%ecx),%eax
 26e:	8d 50 d0             	lea    -0x30(%eax),%edx
 271:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 274:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 279:	77 16                	ja     291 <atoi+0x2d>
 27b:	90                   	nop
    n = n*10 + *s++ - '0';
 27c:	41                   	inc    %ecx
 27d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 280:	01 d2                	add    %edx,%edx
 282:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 286:	0f be 01             	movsbl (%ecx),%eax
 289:	8d 58 d0             	lea    -0x30(%eax),%ebx
 28c:	80 fb 09             	cmp    $0x9,%bl
 28f:	76 eb                	jbe    27c <atoi+0x18>
  return n;
}
 291:	89 d0                	mov    %edx,%eax
 293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 296:	c9                   	leave
 297:	c3                   	ret

00000298 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	57                   	push   %edi
 29c:	56                   	push   %esi
 29d:	8b 55 08             	mov    0x8(%ebp),%edx
 2a0:	8b 75 0c             	mov    0xc(%ebp),%esi
 2a3:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a6:	85 c0                	test   %eax,%eax
 2a8:	7e 0b                	jle    2b5 <memmove+0x1d>
 2aa:	01 d0                	add    %edx,%eax
  dst = vdst;
 2ac:	89 d7                	mov    %edx,%edi
 2ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x18>
  return vdst;
}
 2b5:	89 d0                	mov    %edx,%eax
 2b7:	5e                   	pop    %esi
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <signal>:
SYSCALL(signal)
 363:	b8 16 00 00 00       	mov    $0x16,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret
