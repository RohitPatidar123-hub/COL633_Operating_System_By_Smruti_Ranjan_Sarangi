
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
  62:	68 e3 06 00 00       	push   $0x6e3
  67:	6a 01                	push   $0x1
  69:	e8 72 03 00 00       	call   3e0 <printf>
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
  92:	68 80 07 00 00       	push   $0x780
  97:	6a 01                	push   $0x1
  99:	e8 35 02 00 00       	call   2d3 <write>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	39 d8                	cmp    %ebx,%eax
  a3:	75 23                	jne    c8 <cat+0x44>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  a5:	52                   	push   %edx
  a6:	68 00 02 00 00       	push   $0x200
  ab:	68 80 07 00 00       	push   $0x780
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
  cb:	68 c0 06 00 00       	push   $0x6c0
  d0:	6a 01                	push   $0x1
  d2:	e8 09 03 00 00       	call   3e0 <printf>
      exit();
  d7:	e8 d7 01 00 00       	call   2b3 <exit>
    printf(1, "cat: read error\n");
  dc:	50                   	push   %eax
  dd:	50                   	push   %eax
  de:	68 d2 06 00 00       	push   $0x6d2
  e3:	6a 01                	push   $0x1
  e5:	e8 f6 02 00 00       	call   3e0 <printf>
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
 353:	90                   	nop

00000354 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	56                   	push   %esi
 359:	53                   	push   %ebx
 35a:	83 ec 3c             	sub    $0x3c,%esp
 35d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 360:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 362:	8b 4d 08             	mov    0x8(%ebp),%ecx
 365:	85 c9                	test   %ecx,%ecx
 367:	74 04                	je     36d <printint+0x19>
 369:	85 d2                	test   %edx,%edx
 36b:	78 6b                	js     3d8 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 36d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 370:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 377:	31 c9                	xor    %ecx,%ecx
 379:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 37c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 37f:	31 d2                	xor    %edx,%edx
 381:	f7 f3                	div    %ebx
 383:	89 cf                	mov    %ecx,%edi
 385:	8d 49 01             	lea    0x1(%ecx),%ecx
 388:	8a 92 58 07 00 00    	mov    0x758(%edx),%dl
 38e:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 392:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 395:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 398:	39 da                	cmp    %ebx,%edx
 39a:	73 e0                	jae    37c <printint+0x28>
  if(neg)
 39c:	8b 55 08             	mov    0x8(%ebp),%edx
 39f:	85 d2                	test   %edx,%edx
 3a1:	74 07                	je     3aa <printint+0x56>
    buf[i++] = '-';
 3a3:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3a8:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3aa:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3ad:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3b1:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3b4:	8a 07                	mov    (%edi),%al
 3b6:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3b9:	50                   	push   %eax
 3ba:	6a 01                	push   $0x1
 3bc:	56                   	push   %esi
 3bd:	ff 75 c0             	push   -0x40(%ebp)
 3c0:	e8 0e ff ff ff       	call   2d3 <write>
  while(--i >= 0)
 3c5:	89 f8                	mov    %edi,%eax
 3c7:	4f                   	dec    %edi
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	39 d8                	cmp    %ebx,%eax
 3cd:	75 e5                	jne    3b4 <printint+0x60>
}
 3cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d2:	5b                   	pop    %ebx
 3d3:	5e                   	pop    %esi
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret
 3d7:	90                   	nop
    x = -xx;
 3d8:	f7 da                	neg    %edx
 3da:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3dd:	eb 98                	jmp    377 <printint+0x23>
 3df:	90                   	nop

000003e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 2c             	sub    $0x2c,%esp
 3e9:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ef:	8a 03                	mov    (%ebx),%al
 3f1:	84 c0                	test   %al,%al
 3f3:	74 2a                	je     41f <printf+0x3f>
 3f5:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3f6:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3fc:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3ff:	83 fa 25             	cmp    $0x25,%edx
 402:	74 24                	je     428 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 404:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 407:	50                   	push   %eax
 408:	6a 01                	push   $0x1
 40a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 40d:	50                   	push   %eax
 40e:	56                   	push   %esi
 40f:	e8 bf fe ff ff       	call   2d3 <write>
  for(i = 0; fmt[i]; i++){
 414:	43                   	inc    %ebx
 415:	8a 43 ff             	mov    -0x1(%ebx),%al
 418:	83 c4 10             	add    $0x10,%esp
 41b:	84 c0                	test   %al,%al
 41d:	75 dd                	jne    3fc <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 41f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 422:	5b                   	pop    %ebx
 423:	5e                   	pop    %esi
 424:	5f                   	pop    %edi
 425:	5d                   	pop    %ebp
 426:	c3                   	ret
 427:	90                   	nop
  for(i = 0; fmt[i]; i++){
 428:	8a 13                	mov    (%ebx),%dl
 42a:	84 d2                	test   %dl,%dl
 42c:	74 f1                	je     41f <printf+0x3f>
    c = fmt[i] & 0xff;
 42e:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 431:	80 fa 25             	cmp    $0x25,%dl
 434:	0f 84 fe 00 00 00    	je     538 <printf+0x158>
 43a:	83 e8 63             	sub    $0x63,%eax
 43d:	83 f8 15             	cmp    $0x15,%eax
 440:	77 0a                	ja     44c <printf+0x6c>
 442:	ff 24 85 00 07 00 00 	jmp    *0x700(,%eax,4)
 449:	8d 76 00             	lea    0x0(%esi),%esi
 44c:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 44f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 453:	50                   	push   %eax
 454:	6a 01                	push   $0x1
 456:	8d 7d e7             	lea    -0x19(%ebp),%edi
 459:	57                   	push   %edi
 45a:	56                   	push   %esi
 45b:	e8 73 fe ff ff       	call   2d3 <write>
        putc(fd, c);
 460:	8a 55 d0             	mov    -0x30(%ebp),%dl
 463:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 466:	83 c4 0c             	add    $0xc,%esp
 469:	6a 01                	push   $0x1
 46b:	57                   	push   %edi
 46c:	56                   	push   %esi
 46d:	e8 61 fe ff ff       	call   2d3 <write>
  for(i = 0; fmt[i]; i++){
 472:	83 c3 02             	add    $0x2,%ebx
 475:	8a 43 ff             	mov    -0x1(%ebx),%al
 478:	83 c4 10             	add    $0x10,%esp
 47b:	84 c0                	test   %al,%al
 47d:	0f 85 79 ff ff ff    	jne    3fc <printf+0x1c>
}
 483:	8d 65 f4             	lea    -0xc(%ebp),%esp
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5f                   	pop    %edi
 489:	5d                   	pop    %ebp
 48a:	c3                   	ret
 48b:	90                   	nop
        printint(fd, *ap, 16, 0);
 48c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 48f:	8b 17                	mov    (%edi),%edx
 491:	83 ec 0c             	sub    $0xc,%esp
 494:	6a 00                	push   $0x0
 496:	b9 10 00 00 00       	mov    $0x10,%ecx
 49b:	89 f0                	mov    %esi,%eax
 49d:	e8 b2 fe ff ff       	call   354 <printint>
        ap++;
 4a2:	83 c7 04             	add    $0x4,%edi
 4a5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4a8:	eb c8                	jmp    472 <printf+0x92>
 4aa:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4af:	8b 01                	mov    (%ecx),%eax
        ap++;
 4b1:	83 c1 04             	add    $0x4,%ecx
 4b4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4b7:	85 c0                	test   %eax,%eax
 4b9:	0f 84 89 00 00 00    	je     548 <printf+0x168>
        while(*s != 0){
 4bf:	8a 10                	mov    (%eax),%dl
 4c1:	84 d2                	test   %dl,%dl
 4c3:	74 29                	je     4ee <printf+0x10e>
 4c5:	89 c7                	mov    %eax,%edi
 4c7:	88 d0                	mov    %dl,%al
 4c9:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4cc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4cf:	89 fb                	mov    %edi,%ebx
 4d1:	89 cf                	mov    %ecx,%edi
 4d3:	90                   	nop
          putc(fd, *s);
 4d4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4d7:	50                   	push   %eax
 4d8:	6a 01                	push   $0x1
 4da:	57                   	push   %edi
 4db:	56                   	push   %esi
 4dc:	e8 f2 fd ff ff       	call   2d3 <write>
          s++;
 4e1:	43                   	inc    %ebx
        while(*s != 0){
 4e2:	8a 03                	mov    (%ebx),%al
 4e4:	83 c4 10             	add    $0x10,%esp
 4e7:	84 c0                	test   %al,%al
 4e9:	75 e9                	jne    4d4 <printf+0xf4>
 4eb:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4ee:	83 c3 02             	add    $0x2,%ebx
 4f1:	8a 43 ff             	mov    -0x1(%ebx),%al
 4f4:	84 c0                	test   %al,%al
 4f6:	0f 85 00 ff ff ff    	jne    3fc <printf+0x1c>
 4fc:	e9 1e ff ff ff       	jmp    41f <printf+0x3f>
 501:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 504:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 507:	8b 17                	mov    (%edi),%edx
 509:	83 ec 0c             	sub    $0xc,%esp
 50c:	6a 01                	push   $0x1
 50e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 513:	eb 86                	jmp    49b <printf+0xbb>
 515:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 51b:	8b 00                	mov    (%eax),%eax
 51d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 520:	51                   	push   %ecx
 521:	6a 01                	push   $0x1
 523:	8d 7d e7             	lea    -0x19(%ebp),%edi
 526:	57                   	push   %edi
 527:	56                   	push   %esi
 528:	e8 a6 fd ff ff       	call   2d3 <write>
        ap++;
 52d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 531:	e9 3c ff ff ff       	jmp    472 <printf+0x92>
 536:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 538:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 53b:	52                   	push   %edx
 53c:	6a 01                	push   $0x1
 53e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 541:	e9 25 ff ff ff       	jmp    46b <printf+0x8b>
 546:	66 90                	xchg   %ax,%ax
          s = "(null)";
 548:	bf f8 06 00 00       	mov    $0x6f8,%edi
 54d:	b0 28                	mov    $0x28,%al
 54f:	e9 75 ff ff ff       	jmp    4c9 <printf+0xe9>

00000554 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	57                   	push   %edi
 558:	56                   	push   %esi
 559:	53                   	push   %ebx
 55a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 55d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 560:	a1 80 09 00 00       	mov    0x980,%eax
 565:	8d 76 00             	lea    0x0(%esi),%esi
 568:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56c:	39 ca                	cmp    %ecx,%edx
 56e:	73 2c                	jae    59c <free+0x48>
 570:	39 c1                	cmp    %eax,%ecx
 572:	72 04                	jb     578 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 574:	39 c2                	cmp    %eax,%edx
 576:	72 f0                	jb     568 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 578:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57e:	39 f8                	cmp    %edi,%eax
 580:	74 2c                	je     5ae <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 582:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 585:	8b 42 04             	mov    0x4(%edx),%eax
 588:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 58b:	39 f1                	cmp    %esi,%ecx
 58d:	74 36                	je     5c5 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 58f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 591:	89 15 80 09 00 00    	mov    %edx,0x980
}
 597:	5b                   	pop    %ebx
 598:	5e                   	pop    %esi
 599:	5f                   	pop    %edi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59c:	39 c2                	cmp    %eax,%edx
 59e:	72 c8                	jb     568 <free+0x14>
 5a0:	39 c1                	cmp    %eax,%ecx
 5a2:	73 c4                	jae    568 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5a4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5aa:	39 f8                	cmp    %edi,%eax
 5ac:	75 d4                	jne    582 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5ae:	03 70 04             	add    0x4(%eax),%esi
 5b1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b4:	8b 02                	mov    (%edx),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5bb:	8b 42 04             	mov    0x4(%edx),%eax
 5be:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5c1:	39 f1                	cmp    %esi,%ecx
 5c3:	75 ca                	jne    58f <free+0x3b>
    p->s.size += bp->s.size;
 5c5:	03 43 fc             	add    -0x4(%ebx),%eax
 5c8:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5cb:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5ce:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5d0:	89 15 80 09 00 00    	mov    %edx,0x980
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret
 5db:	90                   	nop

000005dc <malloc>:
}


void*
malloc(uint nbytes)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	57                   	push   %edi
 5e0:	56                   	push   %esi
 5e1:	53                   	push   %ebx
 5e2:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	8d 78 07             	lea    0x7(%eax),%edi
 5eb:	c1 ef 03             	shr    $0x3,%edi
 5ee:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5ef:	8b 15 80 09 00 00    	mov    0x980,%edx
 5f5:	85 d2                	test   %edx,%edx
 5f7:	0f 84 93 00 00 00    	je     690 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fd:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ff:	8b 48 04             	mov    0x4(%eax),%ecx
 602:	39 f9                	cmp    %edi,%ecx
 604:	73 62                	jae    668 <malloc+0x8c>
  if(nu < 4096)
 606:	89 fb                	mov    %edi,%ebx
 608:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 60e:	72 78                	jb     688 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 610:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 617:	eb 0e                	jmp    627 <malloc+0x4b>
 619:	8d 76 00             	lea    0x0(%esi),%esi
 61c:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 620:	8b 48 04             	mov    0x4(%eax),%ecx
 623:	39 f9                	cmp    %edi,%ecx
 625:	73 41                	jae    668 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 627:	39 05 80 09 00 00    	cmp    %eax,0x980
 62d:	75 ed                	jne    61c <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 62f:	83 ec 0c             	sub    $0xc,%esp
 632:	56                   	push   %esi
 633:	e8 03 fd ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 638:	83 c4 10             	add    $0x10,%esp
 63b:	83 f8 ff             	cmp    $0xffffffff,%eax
 63e:	74 1c                	je     65c <malloc+0x80>
  hp->s.size = nu;
 640:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 643:	83 ec 0c             	sub    $0xc,%esp
 646:	83 c0 08             	add    $0x8,%eax
 649:	50                   	push   %eax
 64a:	e8 05 ff ff ff       	call   554 <free>
  return freep;
 64f:	8b 15 80 09 00 00    	mov    0x980,%edx
      if((p = morecore(nunits)) == 0)
 655:	83 c4 10             	add    $0x10,%esp
 658:	85 d2                	test   %edx,%edx
 65a:	75 c2                	jne    61e <malloc+0x42>
        return 0;
 65c:	31 c0                	xor    %eax,%eax
  }
}
 65e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 661:	5b                   	pop    %ebx
 662:	5e                   	pop    %esi
 663:	5f                   	pop    %edi
 664:	5d                   	pop    %ebp
 665:	c3                   	ret
 666:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 668:	39 cf                	cmp    %ecx,%edi
 66a:	74 4c                	je     6b8 <malloc+0xdc>
        p->s.size -= nunits;
 66c:	29 f9                	sub    %edi,%ecx
 66e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 671:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 674:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 677:	89 15 80 09 00 00    	mov    %edx,0x980
      return (void*)(p + 1);
 67d:	83 c0 08             	add    $0x8,%eax
}
 680:	8d 65 f4             	lea    -0xc(%ebp),%esp
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret
  if(nu < 4096)
 688:	bb 00 10 00 00       	mov    $0x1000,%ebx
 68d:	eb 81                	jmp    610 <malloc+0x34>
 68f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 690:	c7 05 80 09 00 00 84 	movl   $0x984,0x980
 697:	09 00 00 
 69a:	c7 05 84 09 00 00 84 	movl   $0x984,0x984
 6a1:	09 00 00 
    base.s.size = 0;
 6a4:	c7 05 88 09 00 00 00 	movl   $0x0,0x988
 6ab:	00 00 00 
 6ae:	b8 84 09 00 00       	mov    $0x984,%eax
 6b3:	e9 4e ff ff ff       	jmp    606 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6b8:	8b 08                	mov    (%eax),%ecx
 6ba:	89 0a                	mov    %ecx,(%edx)
 6bc:	eb b9                	jmp    677 <malloc+0x9b>
