
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 54                	jle    73 <main+0x73>
  1f:	83 c3 04             	add    $0x4,%ebx
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  22:	be 01 00 00 00       	mov    $0x1,%esi
  27:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	6a 00                	push   $0x0
  2d:	ff 33                	push   (%ebx)
  2f:	e8 bf 02 00 00       	call   2f3 <open>
  34:	89 c7                	mov    %eax,%edi
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	78 22                	js     5f <main+0x5f>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	50                   	push   %eax
  41:	e8 3e 00 00 00       	call   84 <cat>
    close(fd);
  46:	89 3c 24             	mov    %edi,(%esp)
  49:	e8 8d 02 00 00       	call   2db <close>
  for(i = 1; i < argc; i++){
  4e:	46                   	inc    %esi
  4f:	83 c3 04             	add    $0x4,%ebx
  52:	83 c4 10             	add    $0x10,%esp
  55:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  58:	75 ce                	jne    28 <main+0x28>
  }
  exit();
  5a:	e8 54 02 00 00       	call   2b3 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  5f:	50                   	push   %eax
  60:	ff 33                	push   (%ebx)
  62:	68 fb 06 00 00       	push   $0x6fb
  67:	6a 01                	push   $0x1
  69:	e8 8a 03 00 00       	call   3f8 <printf>
      exit();
  6e:	e8 40 02 00 00       	call   2b3 <exit>
    cat(0);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	6a 00                	push   $0x0
  78:	e8 07 00 00 00       	call   84 <cat>
    exit();
  7d:	e8 31 02 00 00       	call   2b3 <exit>
  82:	66 90                	xchg   %ax,%ax

00000084 <cat>:
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	56                   	push   %esi
  88:	53                   	push   %ebx
  89:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  8c:	eb 17                	jmp    a5 <cat+0x21>
  8e:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
  90:	51                   	push   %ecx
  91:	53                   	push   %ebx
  92:	68 a0 07 00 00       	push   $0x7a0
  97:	6a 01                	push   $0x1
  99:	e8 35 02 00 00       	call   2d3 <write>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	39 d8                	cmp    %ebx,%eax
  a3:	75 23                	jne    c8 <cat+0x44>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  a5:	52                   	push   %edx
  a6:	68 00 02 00 00       	push   $0x200
  ab:	68 a0 07 00 00       	push   $0x7a0
  b0:	56                   	push   %esi
  b1:	e8 15 02 00 00       	call   2cb <read>
  b6:	89 c3                	mov    %eax,%ebx
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	85 c0                	test   %eax,%eax
  bd:	7f d1                	jg     90 <cat+0xc>
  if(n < 0){
  bf:	75 1b                	jne    dc <cat+0x58>
}
  c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret
      printf(1, "cat: write error\n");
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	68 d8 06 00 00       	push   $0x6d8
  d0:	6a 01                	push   $0x1
  d2:	e8 21 03 00 00       	call   3f8 <printf>
      exit();
  d7:	e8 d7 01 00 00       	call   2b3 <exit>
    printf(1, "cat: read error\n");
  dc:	50                   	push   %eax
  dd:	50                   	push   %eax
  de:	68 ea 06 00 00       	push   $0x6ea
  e3:	6a 01                	push   $0x1
  e5:	e8 0e 03 00 00       	call   3f8 <printf>
    exit();
  ea:	e8 c4 01 00 00       	call   2b3 <exit>
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	31 c0                	xor    %eax,%eax
  fc:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 102:	40                   	inc    %eax
 103:	84 d2                	test   %dl,%dl
 105:	75 f5                	jne    fc <strcpy+0xc>
    ;
  return os;
}
 107:	89 c8                	mov    %ecx,%eax
 109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10c:	c9                   	leave
 10d:	c3                   	ret
 10e:	66 90                	xchg   %ax,%ax

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 10                	jne    131 <strcmp+0x21>
 121:	eb 2a                	jmp    14d <strcmp+0x3d>
 123:	90                   	nop
    p++, q++;
 124:	42                   	inc    %edx
 125:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 128:	0f b6 02             	movzbl (%edx),%eax
 12b:	84 c0                	test   %al,%al
 12d:	74 11                	je     140 <strcmp+0x30>
 12f:	89 cb                	mov    %ecx,%ebx
 131:	0f b6 0b             	movzbl (%ebx),%ecx
 134:	38 c1                	cmp    %al,%cl
 136:	74 ec                	je     124 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 138:	29 c8                	sub    %ecx,%eax
}
 13a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 13d:	c9                   	leave
 13e:	c3                   	ret
 13f:	90                   	nop
  return (uchar)*p - (uchar)*q;
 140:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 144:	31 c0                	xor    %eax,%eax
 146:	29 c8                	sub    %ecx,%eax
}
 148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14b:	c9                   	leave
 14c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 14d:	0f b6 0b             	movzbl (%ebx),%ecx
 150:	31 c0                	xor    %eax,%eax
 152:	eb e4                	jmp    138 <strcmp+0x28>

00000154 <strlen>:

uint
strlen(const char *s)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 15a:	80 3a 00             	cmpb   $0x0,(%edx)
 15d:	74 15                	je     174 <strlen+0x20>
 15f:	31 c0                	xor    %eax,%eax
 161:	8d 76 00             	lea    0x0(%esi),%esi
 164:	40                   	inc    %eax
 165:	89 c1                	mov    %eax,%ecx
 167:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 16b:	75 f7                	jne    164 <strlen+0x10>
    ;
  return n;
}
 16d:	89 c8                	mov    %ecx,%eax
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret
 171:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 174:	31 c9                	xor    %ecx,%ecx
}
 176:	89 c8                	mov    %ecx,%eax
 178:	5d                   	pop    %ebp
 179:	c3                   	ret
 17a:	66 90                	xchg   %ax,%ax

0000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 180:	8b 7d 08             	mov    0x8(%ebp),%edi
 183:	8b 4d 10             	mov    0x10(%ebp),%ecx
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	fc                   	cld
 18a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 192:	c9                   	leave
 193:	c3                   	ret

00000194 <strchr>:

char*
strchr(const char *s, char c)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 19d:	8a 10                	mov    (%eax),%dl
 19f:	84 d2                	test   %dl,%dl
 1a1:	75 0c                	jne    1af <strchr+0x1b>
 1a3:	eb 13                	jmp    1b8 <strchr+0x24>
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
 1a8:	40                   	inc    %eax
 1a9:	8a 10                	mov    (%eax),%dl
 1ab:	84 d2                	test   %dl,%dl
 1ad:	74 09                	je     1b8 <strchr+0x24>
    if(*s == c)
 1af:	38 d1                	cmp    %dl,%cl
 1b1:	75 f5                	jne    1a8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1b8:	31 c0                	xor    %eax,%eax
}
 1ba:	5d                   	pop    %ebp
 1bb:	c3                   	ret

000001bc <gets>:

char*
gets(char *buf, int max)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1c7:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1ca:	eb 24                	jmp    1f0 <gets+0x34>
    cc = read(0, &c, 1);
 1cc:	50                   	push   %eax
 1cd:	6a 01                	push   $0x1
 1cf:	56                   	push   %esi
 1d0:	6a 00                	push   $0x0
 1d2:	e8 f4 00 00 00       	call   2cb <read>
    if(cc < 1)
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	85 c0                	test   %eax,%eax
 1dc:	7e 1a                	jle    1f8 <gets+0x3c>
      break;
    buf[i++] = c;
 1de:	8a 45 e7             	mov    -0x19(%ebp),%al
 1e1:	8b 55 08             	mov    0x8(%ebp),%edx
 1e4:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1e8:	3c 0a                	cmp    $0xa,%al
 1ea:	74 0e                	je     1fa <gets+0x3e>
 1ec:	3c 0d                	cmp    $0xd,%al
 1ee:	74 0a                	je     1fa <gets+0x3e>
  for(i=0; i+1 < max; ){
 1f0:	89 df                	mov    %ebx,%edi
 1f2:	43                   	inc    %ebx
 1f3:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1f6:	7c d4                	jl     1cc <gets+0x10>
 1f8:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 201:	8d 65 f4             	lea    -0xc(%ebp),%esp
 204:	5b                   	pop    %ebx
 205:	5e                   	pop    %esi
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret
 209:	8d 76 00             	lea    0x0(%esi),%esi

0000020c <stat>:

int
stat(const char *n, struct stat *st)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	56                   	push   %esi
 210:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 211:	83 ec 08             	sub    $0x8,%esp
 214:	6a 00                	push   $0x0
 216:	ff 75 08             	push   0x8(%ebp)
 219:	e8 d5 00 00 00       	call   2f3 <open>
  if(fd < 0)
 21e:	83 c4 10             	add    $0x10,%esp
 221:	85 c0                	test   %eax,%eax
 223:	78 27                	js     24c <stat+0x40>
 225:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 227:	83 ec 08             	sub    $0x8,%esp
 22a:	ff 75 0c             	push   0xc(%ebp)
 22d:	50                   	push   %eax
 22e:	e8 d8 00 00 00       	call   30b <fstat>
 233:	89 c6                	mov    %eax,%esi
  close(fd);
 235:	89 1c 24             	mov    %ebx,(%esp)
 238:	e8 9e 00 00 00       	call   2db <close>
  return r;
 23d:	83 c4 10             	add    $0x10,%esp
}
 240:	89 f0                	mov    %esi,%eax
 242:	8d 65 f8             	lea    -0x8(%ebp),%esp
 245:	5b                   	pop    %ebx
 246:	5e                   	pop    %esi
 247:	5d                   	pop    %ebp
 248:	c3                   	ret
 249:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 24c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 251:	eb ed                	jmp    240 <stat+0x34>
 253:	90                   	nop

00000254 <atoi>:

int
atoi(const char *s)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	53                   	push   %ebx
 258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25b:	0f be 01             	movsbl (%ecx),%eax
 25e:	8d 50 d0             	lea    -0x30(%eax),%edx
 261:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 264:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 269:	77 16                	ja     281 <atoi+0x2d>
 26b:	90                   	nop
    n = n*10 + *s++ - '0';
 26c:	41                   	inc    %ecx
 26d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 270:	01 d2                	add    %edx,%edx
 272:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 276:	0f be 01             	movsbl (%ecx),%eax
 279:	8d 58 d0             	lea    -0x30(%eax),%ebx
 27c:	80 fb 09             	cmp    $0x9,%bl
 27f:	76 eb                	jbe    26c <atoi+0x18>
  return n;
}
 281:	89 d0                	mov    %edx,%eax
 283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 286:	c9                   	leave
 287:	c3                   	ret

00000288 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	57                   	push   %edi
 28c:	56                   	push   %esi
 28d:	8b 55 08             	mov    0x8(%ebp),%edx
 290:	8b 75 0c             	mov    0xc(%ebp),%esi
 293:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	85 c0                	test   %eax,%eax
 298:	7e 0b                	jle    2a5 <memmove+0x1d>
 29a:	01 d0                	add    %edx,%eax
  dst = vdst;
 29c:	89 d7                	mov    %edx,%edi
 29e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a1:	39 f8                	cmp    %edi,%eax
 2a3:	75 fb                	jne    2a0 <memmove+0x18>
  return vdst;
}
 2a5:	89 d0                	mov    %edx,%eax
 2a7:	5e                   	pop    %esi
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <signal>:
SYSCALL(signal)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <custom_fork>:
SYSCALL(custom_fork)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <scheduler_start>:
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret
 36b:	90                   	nop

0000036c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	57                   	push   %edi
 370:	56                   	push   %esi
 371:	53                   	push   %ebx
 372:	83 ec 3c             	sub    $0x3c,%esp
 375:	89 45 c0             	mov    %eax,-0x40(%ebp)
 378:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 37d:	85 c9                	test   %ecx,%ecx
 37f:	74 04                	je     385 <printint+0x19>
 381:	85 d2                	test   %edx,%edx
 383:	78 6b                	js     3f0 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 385:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 388:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 38f:	31 c9                	xor    %ecx,%ecx
 391:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 394:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 397:	31 d2                	xor    %edx,%edx
 399:	f7 f3                	div    %ebx
 39b:	89 cf                	mov    %ecx,%edi
 39d:	8d 49 01             	lea    0x1(%ecx),%ecx
 3a0:	8a 92 70 07 00 00    	mov    0x770(%edx),%dl
 3a6:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3aa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3b0:	39 da                	cmp    %ebx,%edx
 3b2:	73 e0                	jae    394 <printint+0x28>
  if(neg)
 3b4:	8b 55 08             	mov    0x8(%ebp),%edx
 3b7:	85 d2                	test   %edx,%edx
 3b9:	74 07                	je     3c2 <printint+0x56>
    buf[i++] = '-';
 3bb:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3c0:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3c2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3c5:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3c9:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3cc:	8a 07                	mov    (%edi),%al
 3ce:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3d1:	50                   	push   %eax
 3d2:	6a 01                	push   $0x1
 3d4:	56                   	push   %esi
 3d5:	ff 75 c0             	push   -0x40(%ebp)
 3d8:	e8 f6 fe ff ff       	call   2d3 <write>
  while(--i >= 0)
 3dd:	89 f8                	mov    %edi,%eax
 3df:	4f                   	dec    %edi
 3e0:	83 c4 10             	add    $0x10,%esp
 3e3:	39 d8                	cmp    %ebx,%eax
 3e5:	75 e5                	jne    3cc <printint+0x60>
}
 3e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ea:	5b                   	pop    %ebx
 3eb:	5e                   	pop    %esi
 3ec:	5f                   	pop    %edi
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret
 3ef:	90                   	nop
    x = -xx;
 3f0:	f7 da                	neg    %edx
 3f2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3f5:	eb 98                	jmp    38f <printint+0x23>
 3f7:	90                   	nop

000003f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	57                   	push   %edi
 3fc:	56                   	push   %esi
 3fd:	53                   	push   %ebx
 3fe:	83 ec 2c             	sub    $0x2c,%esp
 401:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 404:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 407:	8a 03                	mov    (%ebx),%al
 409:	84 c0                	test   %al,%al
 40b:	74 2a                	je     437 <printf+0x3f>
 40d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 40e:	8d 4d 10             	lea    0x10(%ebp),%ecx
 411:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 414:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 417:	83 fa 25             	cmp    $0x25,%edx
 41a:	74 24                	je     440 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 41c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 41f:	50                   	push   %eax
 420:	6a 01                	push   $0x1
 422:	8d 45 e7             	lea    -0x19(%ebp),%eax
 425:	50                   	push   %eax
 426:	56                   	push   %esi
 427:	e8 a7 fe ff ff       	call   2d3 <write>
  for(i = 0; fmt[i]; i++){
 42c:	43                   	inc    %ebx
 42d:	8a 43 ff             	mov    -0x1(%ebx),%al
 430:	83 c4 10             	add    $0x10,%esp
 433:	84 c0                	test   %al,%al
 435:	75 dd                	jne    414 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 437:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43a:	5b                   	pop    %ebx
 43b:	5e                   	pop    %esi
 43c:	5f                   	pop    %edi
 43d:	5d                   	pop    %ebp
 43e:	c3                   	ret
 43f:	90                   	nop
  for(i = 0; fmt[i]; i++){
 440:	8a 13                	mov    (%ebx),%dl
 442:	84 d2                	test   %dl,%dl
 444:	74 f1                	je     437 <printf+0x3f>
    c = fmt[i] & 0xff;
 446:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 449:	80 fa 25             	cmp    $0x25,%dl
 44c:	0f 84 fe 00 00 00    	je     550 <printf+0x158>
 452:	83 e8 63             	sub    $0x63,%eax
 455:	83 f8 15             	cmp    $0x15,%eax
 458:	77 0a                	ja     464 <printf+0x6c>
 45a:	ff 24 85 18 07 00 00 	jmp    *0x718(,%eax,4)
 461:	8d 76 00             	lea    0x0(%esi),%esi
 464:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 467:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 46b:	50                   	push   %eax
 46c:	6a 01                	push   $0x1
 46e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 471:	57                   	push   %edi
 472:	56                   	push   %esi
 473:	e8 5b fe ff ff       	call   2d3 <write>
        putc(fd, c);
 478:	8a 55 d0             	mov    -0x30(%ebp),%dl
 47b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 47e:	83 c4 0c             	add    $0xc,%esp
 481:	6a 01                	push   $0x1
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	e8 49 fe ff ff       	call   2d3 <write>
  for(i = 0; fmt[i]; i++){
 48a:	83 c3 02             	add    $0x2,%ebx
 48d:	8a 43 ff             	mov    -0x1(%ebx),%al
 490:	83 c4 10             	add    $0x10,%esp
 493:	84 c0                	test   %al,%al
 495:	0f 85 79 ff ff ff    	jne    414 <printf+0x1c>
}
 49b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49e:	5b                   	pop    %ebx
 49f:	5e                   	pop    %esi
 4a0:	5f                   	pop    %edi
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret
 4a3:	90                   	nop
        printint(fd, *ap, 16, 0);
 4a4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a7:	8b 17                	mov    (%edi),%edx
 4a9:	83 ec 0c             	sub    $0xc,%esp
 4ac:	6a 00                	push   $0x0
 4ae:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b3:	89 f0                	mov    %esi,%eax
 4b5:	e8 b2 fe ff ff       	call   36c <printint>
        ap++;
 4ba:	83 c7 04             	add    $0x4,%edi
 4bd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4c0:	eb c8                	jmp    48a <printf+0x92>
 4c2:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4c4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4c7:	8b 01                	mov    (%ecx),%eax
        ap++;
 4c9:	83 c1 04             	add    $0x4,%ecx
 4cc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4cf:	85 c0                	test   %eax,%eax
 4d1:	0f 84 89 00 00 00    	je     560 <printf+0x168>
        while(*s != 0){
 4d7:	8a 10                	mov    (%eax),%dl
 4d9:	84 d2                	test   %dl,%dl
 4db:	74 29                	je     506 <printf+0x10e>
 4dd:	89 c7                	mov    %eax,%edi
 4df:	88 d0                	mov    %dl,%al
 4e1:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4e4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4e7:	89 fb                	mov    %edi,%ebx
 4e9:	89 cf                	mov    %ecx,%edi
 4eb:	90                   	nop
          putc(fd, *s);
 4ec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ef:	50                   	push   %eax
 4f0:	6a 01                	push   $0x1
 4f2:	57                   	push   %edi
 4f3:	56                   	push   %esi
 4f4:	e8 da fd ff ff       	call   2d3 <write>
          s++;
 4f9:	43                   	inc    %ebx
        while(*s != 0){
 4fa:	8a 03                	mov    (%ebx),%al
 4fc:	83 c4 10             	add    $0x10,%esp
 4ff:	84 c0                	test   %al,%al
 501:	75 e9                	jne    4ec <printf+0xf4>
 503:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 506:	83 c3 02             	add    $0x2,%ebx
 509:	8a 43 ff             	mov    -0x1(%ebx),%al
 50c:	84 c0                	test   %al,%al
 50e:	0f 85 00 ff ff ff    	jne    414 <printf+0x1c>
 514:	e9 1e ff ff ff       	jmp    437 <printf+0x3f>
 519:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 51c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 51f:	8b 17                	mov    (%edi),%edx
 521:	83 ec 0c             	sub    $0xc,%esp
 524:	6a 01                	push   $0x1
 526:	b9 0a 00 00 00       	mov    $0xa,%ecx
 52b:	eb 86                	jmp    4b3 <printf+0xbb>
 52d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 533:	8b 00                	mov    (%eax),%eax
 535:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 538:	51                   	push   %ecx
 539:	6a 01                	push   $0x1
 53b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 53e:	57                   	push   %edi
 53f:	56                   	push   %esi
 540:	e8 8e fd ff ff       	call   2d3 <write>
        ap++;
 545:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 549:	e9 3c ff ff ff       	jmp    48a <printf+0x92>
 54e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 550:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 553:	52                   	push   %edx
 554:	6a 01                	push   $0x1
 556:	8d 7d e7             	lea    -0x19(%ebp),%edi
 559:	e9 25 ff ff ff       	jmp    483 <printf+0x8b>
 55e:	66 90                	xchg   %ax,%ax
          s = "(null)";
 560:	bf 10 07 00 00       	mov    $0x710,%edi
 565:	b0 28                	mov    $0x28,%al
 567:	e9 75 ff ff ff       	jmp    4e1 <printf+0xe9>

0000056c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	57                   	push   %edi
 570:	56                   	push   %esi
 571:	53                   	push   %ebx
 572:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 575:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 578:	a1 a0 09 00 00       	mov    0x9a0,%eax
 57d:	8d 76 00             	lea    0x0(%esi),%esi
 580:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 582:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 584:	39 ca                	cmp    %ecx,%edx
 586:	73 2c                	jae    5b4 <free+0x48>
 588:	39 c1                	cmp    %eax,%ecx
 58a:	72 04                	jb     590 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58c:	39 c2                	cmp    %eax,%edx
 58e:	72 f0                	jb     580 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 590:	8b 73 fc             	mov    -0x4(%ebx),%esi
 593:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 596:	39 f8                	cmp    %edi,%eax
 598:	74 2c                	je     5c6 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 59a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 59d:	8b 42 04             	mov    0x4(%edx),%eax
 5a0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5a3:	39 f1                	cmp    %esi,%ecx
 5a5:	74 36                	je     5dd <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5a7:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5a9:	89 15 a0 09 00 00    	mov    %edx,0x9a0
}
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b4:	39 c2                	cmp    %eax,%edx
 5b6:	72 c8                	jb     580 <free+0x14>
 5b8:	39 c1                	cmp    %eax,%ecx
 5ba:	73 c4                	jae    580 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5bc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5bf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5c2:	39 f8                	cmp    %edi,%eax
 5c4:	75 d4                	jne    59a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5c6:	03 70 04             	add    0x4(%eax),%esi
 5c9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5cc:	8b 02                	mov    (%edx),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5d3:	8b 42 04             	mov    0x4(%edx),%eax
 5d6:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5d9:	39 f1                	cmp    %esi,%ecx
 5db:	75 ca                	jne    5a7 <free+0x3b>
    p->s.size += bp->s.size;
 5dd:	03 43 fc             	add    -0x4(%ebx),%eax
 5e0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5e3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5e6:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5e8:	89 15 a0 09 00 00    	mov    %edx,0x9a0
}
 5ee:	5b                   	pop    %ebx
 5ef:	5e                   	pop    %esi
 5f0:	5f                   	pop    %edi
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret
 5f3:	90                   	nop

000005f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	57                   	push   %edi
 5f8:	56                   	push   %esi
 5f9:	53                   	push   %ebx
 5fa:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	8d 78 07             	lea    0x7(%eax),%edi
 603:	c1 ef 03             	shr    $0x3,%edi
 606:	47                   	inc    %edi
  if((prevp = freep) == 0){
 607:	8b 15 a0 09 00 00    	mov    0x9a0,%edx
 60d:	85 d2                	test   %edx,%edx
 60f:	0f 84 93 00 00 00    	je     6a8 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 615:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 617:	8b 48 04             	mov    0x4(%eax),%ecx
 61a:	39 f9                	cmp    %edi,%ecx
 61c:	73 62                	jae    680 <malloc+0x8c>
  if(nu < 4096)
 61e:	89 fb                	mov    %edi,%ebx
 620:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 626:	72 78                	jb     6a0 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 628:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 62f:	eb 0e                	jmp    63f <malloc+0x4b>
 631:	8d 76 00             	lea    0x0(%esi),%esi
 634:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 636:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 638:	8b 48 04             	mov    0x4(%eax),%ecx
 63b:	39 f9                	cmp    %edi,%ecx
 63d:	73 41                	jae    680 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 63f:	39 05 a0 09 00 00    	cmp    %eax,0x9a0
 645:	75 ed                	jne    634 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 647:	83 ec 0c             	sub    $0xc,%esp
 64a:	56                   	push   %esi
 64b:	e8 eb fc ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 650:	83 c4 10             	add    $0x10,%esp
 653:	83 f8 ff             	cmp    $0xffffffff,%eax
 656:	74 1c                	je     674 <malloc+0x80>
  hp->s.size = nu;
 658:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 65b:	83 ec 0c             	sub    $0xc,%esp
 65e:	83 c0 08             	add    $0x8,%eax
 661:	50                   	push   %eax
 662:	e8 05 ff ff ff       	call   56c <free>
  return freep;
 667:	8b 15 a0 09 00 00    	mov    0x9a0,%edx
      if((p = morecore(nunits)) == 0)
 66d:	83 c4 10             	add    $0x10,%esp
 670:	85 d2                	test   %edx,%edx
 672:	75 c2                	jne    636 <malloc+0x42>
        return 0;
 674:	31 c0                	xor    %eax,%eax
  }
}
 676:	8d 65 f4             	lea    -0xc(%ebp),%esp
 679:	5b                   	pop    %ebx
 67a:	5e                   	pop    %esi
 67b:	5f                   	pop    %edi
 67c:	5d                   	pop    %ebp
 67d:	c3                   	ret
 67e:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 680:	39 cf                	cmp    %ecx,%edi
 682:	74 4c                	je     6d0 <malloc+0xdc>
        p->s.size -= nunits;
 684:	29 f9                	sub    %edi,%ecx
 686:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 689:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 68c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 68f:	89 15 a0 09 00 00    	mov    %edx,0x9a0
      return (void*)(p + 1);
 695:	83 c0 08             	add    $0x8,%eax
}
 698:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69b:	5b                   	pop    %ebx
 69c:	5e                   	pop    %esi
 69d:	5f                   	pop    %edi
 69e:	5d                   	pop    %ebp
 69f:	c3                   	ret
  if(nu < 4096)
 6a0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a5:	eb 81                	jmp    628 <malloc+0x34>
 6a7:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6a8:	c7 05 a0 09 00 00 a4 	movl   $0x9a4,0x9a0
 6af:	09 00 00 
 6b2:	c7 05 a4 09 00 00 a4 	movl   $0x9a4,0x9a4
 6b9:	09 00 00 
    base.s.size = 0;
 6bc:	c7 05 a8 09 00 00 00 	movl   $0x0,0x9a8
 6c3:	00 00 00 
 6c6:	b8 a4 09 00 00       	mov    $0x9a4,%eax
 6cb:	e9 4e ff ff ff       	jmp    61e <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6d0:	8b 08                	mov    (%eax),%ecx
 6d2:	89 0a                	mov    %ecx,(%edx)
 6d4:	eb b9                	jmp    68f <malloc+0x9b>
