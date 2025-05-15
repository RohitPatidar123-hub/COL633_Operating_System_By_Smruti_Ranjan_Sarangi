
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"
// You can write a small user program that allocates memory to see if the page count changes.
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
  11:	83 ec 24             	sub    $0x24,%esp
  // Allocate an array of 4096 * 10 bytes (i.e. 10 pages)
  char *mem = malloc(4096 * 10);
  14:	68 00 a0 00 00       	push   $0xa000
  19:	e8 b6 05 00 00       	call   5d4 <malloc>
  if(mem == 0){
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 84 aa 00 00 00    	je     d3 <main+0xd3>
  29:	89 c6                	mov    %eax,%esi
    printf(2, "Memory allocation failed\n");
    exit();
  }
  sleep(1000);
  2b:	83 ec 0c             	sub    $0xc,%esp
  2e:	68 e8 03 00 00       	push   $0x3e8
  33:	e8 03 03 00 00       	call   33b <sleep>
  // Touch each page to ensure it is allocated.
  for (int i = 0; i < 10; i++) {
  38:	89 f2                	mov    %esi,%edx
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	31 c0                	xor    %eax,%eax
  3f:	90                   	nop
    mem[i * 4096] = i;
  40:	88 02                	mov    %al,(%edx)
  for (int i = 0; i < 10; i++) {
  42:	40                   	inc    %eax
  43:	81 c2 00 10 00 00    	add    $0x1000,%edx
  49:	83 f8 0a             	cmp    $0xa,%eax
  4c:	75 f2                	jne    40 <main+0x40>
  }
  
  printf(1, "Allocated 10 pages of memory\n");
  4e:	83 ec 08             	sub    $0x8,%esp
  51:	68 d2 06 00 00       	push   $0x6d2
  56:	6a 01                	push   $0x1
  58:	e8 7b 03 00 00       	call   3d8 <printf>

  // Wait for user input so you can test memory printer:
  printf(1, "Press Ctrl+I in another terminal window, then hit Enter here to exit.\n");
  5d:	5f                   	pop    %edi
  5e:	58                   	pop    %eax
  5f:	68 f8 06 00 00       	push   $0x6f8
  64:	6a 01                	push   $0x1
  66:	e8 6d 03 00 00       	call   3d8 <printf>
  char buf[10];
  gets(buf, sizeof(buf));
  6b:	58                   	pop    %eax
  6c:	5a                   	pop    %edx
  6d:	6a 0a                	push   $0xa
  6f:	8d 5d de             	lea    -0x22(%ebp),%ebx
  72:	53                   	push   %ebx
  73:	e8 3c 01 00 00       	call   1b4 <gets>
  char *mem1 = malloc(4096 * 10000);
  78:	c7 04 24 00 00 71 02 	movl   $0x2710000,(%esp)
  7f:	e8 50 05 00 00       	call   5d4 <malloc>
  84:	89 c7                	mov    %eax,%edi
  if(mem1 == 0){
  86:	83 c4 10             	add    $0x10,%esp
  89:	85 c0                	test   %eax,%eax
  8b:	74 46                	je     d3 <main+0xd3>
  8d:	89 c1                	mov    %eax,%ecx
    printf(2, "Memory allocation failed\n");
    exit();
  }

  for (int i = 0; i < 10000; i++) {
  8f:	31 d2                	xor    %edx,%edx
  91:	8d 76 00             	lea    0x0(%esi),%esi
    mem1[i * 4096] = i;
  94:	88 11                	mov    %dl,(%ecx)
  for (int i = 0; i < 10000; i++) {
  96:	42                   	inc    %edx
  97:	81 c1 00 10 00 00    	add    $0x1000,%ecx
  9d:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
  a3:	75 ef                	jne    94 <main+0x94>
  }
  free(mem);
  a5:	83 ec 0c             	sub    $0xc,%esp
  a8:	56                   	push   %esi
  a9:	e8 9e 04 00 00       	call   54c <free>
  free(mem1);
  ae:	89 3c 24             	mov    %edi,(%esp)
  b1:	e8 96 04 00 00       	call   54c <free>
  printf(1, "Press Ctrl+I in another terminal window, then hit Enter here to exit.\n");
  b6:	58                   	pop    %eax
  b7:	5a                   	pop    %edx
  b8:	68 f8 06 00 00       	push   $0x6f8
  bd:	6a 01                	push   $0x1
  bf:	e8 14 03 00 00       	call   3d8 <printf>
  gets(buf, sizeof(buf));
  c4:	59                   	pop    %ecx
  c5:	5e                   	pop    %esi
  c6:	6a 0a                	push   $0xa
  c8:	53                   	push   %ebx
  c9:	e8 e6 00 00 00       	call   1b4 <gets>
  exit();
  ce:	e8 d8 01 00 00       	call   2ab <exit>
    printf(2, "Memory allocation failed\n");
  d3:	51                   	push   %ecx
  d4:	51                   	push   %ecx
  d5:	68 b8 06 00 00       	push   $0x6b8
  da:	6a 02                	push   $0x2
  dc:	e8 f7 02 00 00       	call   3d8 <printf>
    exit();
  e1:	e8 c5 01 00 00       	call   2ab <exit>
  e6:	66 90                	xchg   %ax,%ax

000000e8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	53                   	push   %ebx
  ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f2:	31 c0                	xor    %eax,%eax
  f4:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  f7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  fa:	40                   	inc    %eax
  fb:	84 d2                	test   %dl,%dl
  fd:	75 f5                	jne    f4 <strcpy+0xc>
    ;
  return os;
}
  ff:	89 c8                	mov    %ecx,%eax
 101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 104:	c9                   	leave
 105:	c3                   	ret
 106:	66 90                	xchg   %ax,%ax

00000108 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	8b 55 08             	mov    0x8(%ebp),%edx
 10f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 112:	0f b6 02             	movzbl (%edx),%eax
 115:	84 c0                	test   %al,%al
 117:	75 10                	jne    129 <strcmp+0x21>
 119:	eb 2a                	jmp    145 <strcmp+0x3d>
 11b:	90                   	nop
    p++, q++;
 11c:	42                   	inc    %edx
 11d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 120:	0f b6 02             	movzbl (%edx),%eax
 123:	84 c0                	test   %al,%al
 125:	74 11                	je     138 <strcmp+0x30>
 127:	89 cb                	mov    %ecx,%ebx
 129:	0f b6 0b             	movzbl (%ebx),%ecx
 12c:	38 c1                	cmp    %al,%cl
 12e:	74 ec                	je     11c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 130:	29 c8                	sub    %ecx,%eax
}
 132:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 135:	c9                   	leave
 136:	c3                   	ret
 137:	90                   	nop
  return (uchar)*p - (uchar)*q;
 138:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 13c:	31 c0                	xor    %eax,%eax
 13e:	29 c8                	sub    %ecx,%eax
}
 140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 143:	c9                   	leave
 144:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 145:	0f b6 0b             	movzbl (%ebx),%ecx
 148:	31 c0                	xor    %eax,%eax
 14a:	eb e4                	jmp    130 <strcmp+0x28>

0000014c <strlen>:

uint
strlen(const char *s)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 152:	80 3a 00             	cmpb   $0x0,(%edx)
 155:	74 15                	je     16c <strlen+0x20>
 157:	31 c0                	xor    %eax,%eax
 159:	8d 76 00             	lea    0x0(%esi),%esi
 15c:	40                   	inc    %eax
 15d:	89 c1                	mov    %eax,%ecx
 15f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 163:	75 f7                	jne    15c <strlen+0x10>
    ;
  return n;
}
 165:	89 c8                	mov    %ecx,%eax
 167:	5d                   	pop    %ebp
 168:	c3                   	ret
 169:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 16c:	31 c9                	xor    %ecx,%ecx
}
 16e:	89 c8                	mov    %ecx,%eax
 170:	5d                   	pop    %ebp
 171:	c3                   	ret
 172:	66 90                	xchg   %ax,%ax

00000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 178:	8b 7d 08             	mov    0x8(%ebp),%edi
 17b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	fc                   	cld
 182:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	8b 7d fc             	mov    -0x4(%ebp),%edi
 18a:	c9                   	leave
 18b:	c3                   	ret

0000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 195:	8a 10                	mov    (%eax),%dl
 197:	84 d2                	test   %dl,%dl
 199:	75 0c                	jne    1a7 <strchr+0x1b>
 19b:	eb 13                	jmp    1b0 <strchr+0x24>
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	40                   	inc    %eax
 1a1:	8a 10                	mov    (%eax),%dl
 1a3:	84 d2                	test   %dl,%dl
 1a5:	74 09                	je     1b0 <strchr+0x24>
    if(*s == c)
 1a7:	38 d1                	cmp    %dl,%cl
 1a9:	75 f5                	jne    1a0 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1b0:	31 c0                	xor    %eax,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bd:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1bf:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1c2:	eb 24                	jmp    1e8 <gets+0x34>
    cc = read(0, &c, 1);
 1c4:	50                   	push   %eax
 1c5:	6a 01                	push   $0x1
 1c7:	56                   	push   %esi
 1c8:	6a 00                	push   $0x0
 1ca:	e8 f4 00 00 00       	call   2c3 <read>
    if(cc < 1)
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	85 c0                	test   %eax,%eax
 1d4:	7e 1a                	jle    1f0 <gets+0x3c>
      break;
    buf[i++] = c;
 1d6:	8a 45 e7             	mov    -0x19(%ebp),%al
 1d9:	8b 55 08             	mov    0x8(%ebp),%edx
 1dc:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1e0:	3c 0a                	cmp    $0xa,%al
 1e2:	74 0e                	je     1f2 <gets+0x3e>
 1e4:	3c 0d                	cmp    $0xd,%al
 1e6:	74 0a                	je     1f2 <gets+0x3e>
  for(i=0; i+1 < max; ){
 1e8:	89 df                	mov    %ebx,%edi
 1ea:	43                   	inc    %ebx
 1eb:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ee:	7c d4                	jl     1c4 <gets+0x10>
 1f0:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fc:	5b                   	pop    %ebx
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret
 201:	8d 76 00             	lea    0x0(%esi),%esi

00000204 <stat>:

int
stat(const char *n, struct stat *st)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	56                   	push   %esi
 208:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	6a 00                	push   $0x0
 20e:	ff 75 08             	push   0x8(%ebp)
 211:	e8 d5 00 00 00       	call   2eb <open>
  if(fd < 0)
 216:	83 c4 10             	add    $0x10,%esp
 219:	85 c0                	test   %eax,%eax
 21b:	78 27                	js     244 <stat+0x40>
 21d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 21f:	83 ec 08             	sub    $0x8,%esp
 222:	ff 75 0c             	push   0xc(%ebp)
 225:	50                   	push   %eax
 226:	e8 d8 00 00 00       	call   303 <fstat>
 22b:	89 c6                	mov    %eax,%esi
  close(fd);
 22d:	89 1c 24             	mov    %ebx,(%esp)
 230:	e8 9e 00 00 00       	call   2d3 <close>
  return r;
 235:	83 c4 10             	add    $0x10,%esp
}
 238:	89 f0                	mov    %esi,%eax
 23a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 23d:	5b                   	pop    %ebx
 23e:	5e                   	pop    %esi
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret
 241:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 244:	be ff ff ff ff       	mov    $0xffffffff,%esi
 249:	eb ed                	jmp    238 <stat+0x34>
 24b:	90                   	nop

0000024c <atoi>:

int
atoi(const char *s)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	53                   	push   %ebx
 250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 253:	0f be 01             	movsbl (%ecx),%eax
 256:	8d 50 d0             	lea    -0x30(%eax),%edx
 259:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 25c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 261:	77 16                	ja     279 <atoi+0x2d>
 263:	90                   	nop
    n = n*10 + *s++ - '0';
 264:	41                   	inc    %ecx
 265:	8d 14 92             	lea    (%edx,%edx,4),%edx
 268:	01 d2                	add    %edx,%edx
 26a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 26e:	0f be 01             	movsbl (%ecx),%eax
 271:	8d 58 d0             	lea    -0x30(%eax),%ebx
 274:	80 fb 09             	cmp    $0x9,%bl
 277:	76 eb                	jbe    264 <atoi+0x18>
  return n;
}
 279:	89 d0                	mov    %edx,%eax
 27b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 27e:	c9                   	leave
 27f:	c3                   	ret

00000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	56                   	push   %esi
 285:	8b 55 08             	mov    0x8(%ebp),%edx
 288:	8b 75 0c             	mov    0xc(%ebp),%esi
 28b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 c0                	test   %eax,%eax
 290:	7e 0b                	jle    29d <memmove+0x1d>
 292:	01 d0                	add    %edx,%eax
  dst = vdst;
 294:	89 d7                	mov    %edx,%edi
 296:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 298:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 299:	39 f8                	cmp    %edi,%eax
 29b:	75 fb                	jne    298 <memmove+0x18>
  return vdst;
}
 29d:	89 d0                	mov    %edx,%eax
 29f:	5e                   	pop    %esi
 2a0:	5f                   	pop    %edi
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret

000002a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a3:	b8 01 00 00 00       	mov    $0x1,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <exit>:
SYSCALL(exit)
 2ab:	b8 02 00 00 00       	mov    $0x2,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <wait>:
SYSCALL(wait)
 2b3:	b8 03 00 00 00       	mov    $0x3,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <pipe>:
SYSCALL(pipe)
 2bb:	b8 04 00 00 00       	mov    $0x4,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <read>:
SYSCALL(read)
 2c3:	b8 05 00 00 00       	mov    $0x5,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <write>:
SYSCALL(write)
 2cb:	b8 10 00 00 00       	mov    $0x10,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <close>:
SYSCALL(close)
 2d3:	b8 15 00 00 00       	mov    $0x15,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <kill>:
SYSCALL(kill)
 2db:	b8 06 00 00 00       	mov    $0x6,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <exec>:
SYSCALL(exec)
 2e3:	b8 07 00 00 00       	mov    $0x7,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <open>:
SYSCALL(open)
 2eb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <mknod>:
SYSCALL(mknod)
 2f3:	b8 11 00 00 00       	mov    $0x11,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <unlink>:
SYSCALL(unlink)
 2fb:	b8 12 00 00 00       	mov    $0x12,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <fstat>:
SYSCALL(fstat)
 303:	b8 08 00 00 00       	mov    $0x8,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <link>:
SYSCALL(link)
 30b:	b8 13 00 00 00       	mov    $0x13,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <mkdir>:
SYSCALL(mkdir)
 313:	b8 14 00 00 00       	mov    $0x14,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <chdir>:
SYSCALL(chdir)
 31b:	b8 09 00 00 00       	mov    $0x9,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <dup>:
SYSCALL(dup)
 323:	b8 0a 00 00 00       	mov    $0xa,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <getpid>:
SYSCALL(getpid)
 32b:	b8 0b 00 00 00       	mov    $0xb,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <sbrk>:
SYSCALL(sbrk)
 333:	b8 0c 00 00 00       	mov    $0xc,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <sleep>:
SYSCALL(sleep)
 33b:	b8 0d 00 00 00       	mov    $0xd,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <uptime>:
SYSCALL(uptime)
 343:	b8 0e 00 00 00       	mov    $0xe,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret
 34b:	90                   	nop

0000034c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	57                   	push   %edi
 350:	56                   	push   %esi
 351:	53                   	push   %ebx
 352:	83 ec 3c             	sub    $0x3c,%esp
 355:	89 45 c0             	mov    %eax,-0x40(%ebp)
 358:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35d:	85 c9                	test   %ecx,%ecx
 35f:	74 04                	je     365 <printint+0x19>
 361:	85 d2                	test   %edx,%edx
 363:	78 6b                	js     3d0 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 365:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 368:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 36f:	31 c9                	xor    %ecx,%ecx
 371:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 374:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 377:	31 d2                	xor    %edx,%edx
 379:	f7 f3                	div    %ebx
 37b:	89 cf                	mov    %ecx,%edi
 37d:	8d 49 01             	lea    0x1(%ecx),%ecx
 380:	8a 92 98 07 00 00    	mov    0x798(%edx),%dl
 386:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 38a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 38d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 390:	39 da                	cmp    %ebx,%edx
 392:	73 e0                	jae    374 <printint+0x28>
  if(neg)
 394:	8b 55 08             	mov    0x8(%ebp),%edx
 397:	85 d2                	test   %edx,%edx
 399:	74 07                	je     3a2 <printint+0x56>
    buf[i++] = '-';
 39b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3a0:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3a2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3a5:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3a9:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3ac:	8a 07                	mov    (%edi),%al
 3ae:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3b1:	50                   	push   %eax
 3b2:	6a 01                	push   $0x1
 3b4:	56                   	push   %esi
 3b5:	ff 75 c0             	push   -0x40(%ebp)
 3b8:	e8 0e ff ff ff       	call   2cb <write>
  while(--i >= 0)
 3bd:	89 f8                	mov    %edi,%eax
 3bf:	4f                   	dec    %edi
 3c0:	83 c4 10             	add    $0x10,%esp
 3c3:	39 d8                	cmp    %ebx,%eax
 3c5:	75 e5                	jne    3ac <printint+0x60>
}
 3c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ca:	5b                   	pop    %ebx
 3cb:	5e                   	pop    %esi
 3cc:	5f                   	pop    %edi
 3cd:	5d                   	pop    %ebp
 3ce:	c3                   	ret
 3cf:	90                   	nop
    x = -xx;
 3d0:	f7 da                	neg    %edx
 3d2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3d5:	eb 98                	jmp    36f <printint+0x23>
 3d7:	90                   	nop

000003d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	57                   	push   %edi
 3dc:	56                   	push   %esi
 3dd:	53                   	push   %ebx
 3de:	83 ec 2c             	sub    $0x2c,%esp
 3e1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3e7:	8a 03                	mov    (%ebx),%al
 3e9:	84 c0                	test   %al,%al
 3eb:	74 2a                	je     417 <printf+0x3f>
 3ed:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3ee:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3f1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3f4:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3f7:	83 fa 25             	cmp    $0x25,%edx
 3fa:	74 24                	je     420 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3ff:	50                   	push   %eax
 400:	6a 01                	push   $0x1
 402:	8d 45 e7             	lea    -0x19(%ebp),%eax
 405:	50                   	push   %eax
 406:	56                   	push   %esi
 407:	e8 bf fe ff ff       	call   2cb <write>
  for(i = 0; fmt[i]; i++){
 40c:	43                   	inc    %ebx
 40d:	8a 43 ff             	mov    -0x1(%ebx),%al
 410:	83 c4 10             	add    $0x10,%esp
 413:	84 c0                	test   %al,%al
 415:	75 dd                	jne    3f4 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 417:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41a:	5b                   	pop    %ebx
 41b:	5e                   	pop    %esi
 41c:	5f                   	pop    %edi
 41d:	5d                   	pop    %ebp
 41e:	c3                   	ret
 41f:	90                   	nop
  for(i = 0; fmt[i]; i++){
 420:	8a 13                	mov    (%ebx),%dl
 422:	84 d2                	test   %dl,%dl
 424:	74 f1                	je     417 <printf+0x3f>
    c = fmt[i] & 0xff;
 426:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 429:	80 fa 25             	cmp    $0x25,%dl
 42c:	0f 84 fe 00 00 00    	je     530 <printf+0x158>
 432:	83 e8 63             	sub    $0x63,%eax
 435:	83 f8 15             	cmp    $0x15,%eax
 438:	77 0a                	ja     444 <printf+0x6c>
 43a:	ff 24 85 40 07 00 00 	jmp    *0x740(,%eax,4)
 441:	8d 76 00             	lea    0x0(%esi),%esi
 444:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 447:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 44b:	50                   	push   %eax
 44c:	6a 01                	push   $0x1
 44e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 451:	57                   	push   %edi
 452:	56                   	push   %esi
 453:	e8 73 fe ff ff       	call   2cb <write>
        putc(fd, c);
 458:	8a 55 d0             	mov    -0x30(%ebp),%dl
 45b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 45e:	83 c4 0c             	add    $0xc,%esp
 461:	6a 01                	push   $0x1
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	e8 61 fe ff ff       	call   2cb <write>
  for(i = 0; fmt[i]; i++){
 46a:	83 c3 02             	add    $0x2,%ebx
 46d:	8a 43 ff             	mov    -0x1(%ebx),%al
 470:	83 c4 10             	add    $0x10,%esp
 473:	84 c0                	test   %al,%al
 475:	0f 85 79 ff ff ff    	jne    3f4 <printf+0x1c>
}
 47b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47e:	5b                   	pop    %ebx
 47f:	5e                   	pop    %esi
 480:	5f                   	pop    %edi
 481:	5d                   	pop    %ebp
 482:	c3                   	ret
 483:	90                   	nop
        printint(fd, *ap, 16, 0);
 484:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 487:	8b 17                	mov    (%edi),%edx
 489:	83 ec 0c             	sub    $0xc,%esp
 48c:	6a 00                	push   $0x0
 48e:	b9 10 00 00 00       	mov    $0x10,%ecx
 493:	89 f0                	mov    %esi,%eax
 495:	e8 b2 fe ff ff       	call   34c <printint>
        ap++;
 49a:	83 c7 04             	add    $0x4,%edi
 49d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4a0:	eb c8                	jmp    46a <printf+0x92>
 4a2:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4a4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4a7:	8b 01                	mov    (%ecx),%eax
        ap++;
 4a9:	83 c1 04             	add    $0x4,%ecx
 4ac:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4af:	85 c0                	test   %eax,%eax
 4b1:	0f 84 89 00 00 00    	je     540 <printf+0x168>
        while(*s != 0){
 4b7:	8a 10                	mov    (%eax),%dl
 4b9:	84 d2                	test   %dl,%dl
 4bb:	74 29                	je     4e6 <printf+0x10e>
 4bd:	89 c7                	mov    %eax,%edi
 4bf:	88 d0                	mov    %dl,%al
 4c1:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4c4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4c7:	89 fb                	mov    %edi,%ebx
 4c9:	89 cf                	mov    %ecx,%edi
 4cb:	90                   	nop
          putc(fd, *s);
 4cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4cf:	50                   	push   %eax
 4d0:	6a 01                	push   $0x1
 4d2:	57                   	push   %edi
 4d3:	56                   	push   %esi
 4d4:	e8 f2 fd ff ff       	call   2cb <write>
          s++;
 4d9:	43                   	inc    %ebx
        while(*s != 0){
 4da:	8a 03                	mov    (%ebx),%al
 4dc:	83 c4 10             	add    $0x10,%esp
 4df:	84 c0                	test   %al,%al
 4e1:	75 e9                	jne    4cc <printf+0xf4>
 4e3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4e6:	83 c3 02             	add    $0x2,%ebx
 4e9:	8a 43 ff             	mov    -0x1(%ebx),%al
 4ec:	84 c0                	test   %al,%al
 4ee:	0f 85 00 ff ff ff    	jne    3f4 <printf+0x1c>
 4f4:	e9 1e ff ff ff       	jmp    417 <printf+0x3f>
 4f9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4fc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4ff:	8b 17                	mov    (%edi),%edx
 501:	83 ec 0c             	sub    $0xc,%esp
 504:	6a 01                	push   $0x1
 506:	b9 0a 00 00 00       	mov    $0xa,%ecx
 50b:	eb 86                	jmp    493 <printf+0xbb>
 50d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 510:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 518:	51                   	push   %ecx
 519:	6a 01                	push   $0x1
 51b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 51e:	57                   	push   %edi
 51f:	56                   	push   %esi
 520:	e8 a6 fd ff ff       	call   2cb <write>
        ap++;
 525:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 529:	e9 3c ff ff ff       	jmp    46a <printf+0x92>
 52e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 530:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 533:	52                   	push   %edx
 534:	6a 01                	push   $0x1
 536:	8d 7d e7             	lea    -0x19(%ebp),%edi
 539:	e9 25 ff ff ff       	jmp    463 <printf+0x8b>
 53e:	66 90                	xchg   %ax,%ax
          s = "(null)";
 540:	bf f0 06 00 00       	mov    $0x6f0,%edi
 545:	b0 28                	mov    $0x28,%al
 547:	e9 75 ff ff ff       	jmp    4c1 <printf+0xe9>

0000054c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	57                   	push   %edi
 550:	56                   	push   %esi
 551:	53                   	push   %ebx
 552:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 555:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 558:	a1 ac 07 00 00       	mov    0x7ac,%eax
 55d:	8d 76 00             	lea    0x0(%esi),%esi
 560:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 562:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 564:	39 ca                	cmp    %ecx,%edx
 566:	73 2c                	jae    594 <free+0x48>
 568:	39 c1                	cmp    %eax,%ecx
 56a:	72 04                	jb     570 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56c:	39 c2                	cmp    %eax,%edx
 56e:	72 f0                	jb     560 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 570:	8b 73 fc             	mov    -0x4(%ebx),%esi
 573:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 576:	39 f8                	cmp    %edi,%eax
 578:	74 2c                	je     5a6 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 57a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 57d:	8b 42 04             	mov    0x4(%edx),%eax
 580:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 583:	39 f1                	cmp    %esi,%ecx
 585:	74 36                	je     5bd <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 587:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 589:	89 15 ac 07 00 00    	mov    %edx,0x7ac
}
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 594:	39 c2                	cmp    %eax,%edx
 596:	72 c8                	jb     560 <free+0x14>
 598:	39 c1                	cmp    %eax,%ecx
 59a:	73 c4                	jae    560 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 59c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a2:	39 f8                	cmp    %edi,%eax
 5a4:	75 d4                	jne    57a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5a6:	03 70 04             	add    0x4(%eax),%esi
 5a9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ac:	8b 02                	mov    (%edx),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b3:	8b 42 04             	mov    0x4(%edx),%eax
 5b6:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5b9:	39 f1                	cmp    %esi,%ecx
 5bb:	75 ca                	jne    587 <free+0x3b>
    p->s.size += bp->s.size;
 5bd:	03 43 fc             	add    -0x4(%ebx),%eax
 5c0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5c3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5c6:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5c8:	89 15 ac 07 00 00    	mov    %edx,0x7ac
}
 5ce:	5b                   	pop    %ebx
 5cf:	5e                   	pop    %esi
 5d0:	5f                   	pop    %edi
 5d1:	5d                   	pop    %ebp
 5d2:	c3                   	ret
 5d3:	90                   	nop

000005d4 <malloc>:
}


void*
malloc(uint nbytes)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	57                   	push   %edi
 5d8:	56                   	push   %esi
 5d9:	53                   	push   %ebx
 5da:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	8d 78 07             	lea    0x7(%eax),%edi
 5e3:	c1 ef 03             	shr    $0x3,%edi
 5e6:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5e7:	8b 15 ac 07 00 00    	mov    0x7ac,%edx
 5ed:	85 d2                	test   %edx,%edx
 5ef:	0f 84 93 00 00 00    	je     688 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5f7:	8b 48 04             	mov    0x4(%eax),%ecx
 5fa:	39 f9                	cmp    %edi,%ecx
 5fc:	73 62                	jae    660 <malloc+0x8c>
  if(nu < 4096)
 5fe:	89 fb                	mov    %edi,%ebx
 600:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 606:	72 78                	jb     680 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 608:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 60f:	eb 0e                	jmp    61f <malloc+0x4b>
 611:	8d 76 00             	lea    0x0(%esi),%esi
 614:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 616:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 618:	8b 48 04             	mov    0x4(%eax),%ecx
 61b:	39 f9                	cmp    %edi,%ecx
 61d:	73 41                	jae    660 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 61f:	39 05 ac 07 00 00    	cmp    %eax,0x7ac
 625:	75 ed                	jne    614 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 627:	83 ec 0c             	sub    $0xc,%esp
 62a:	56                   	push   %esi
 62b:	e8 03 fd ff ff       	call   333 <sbrk>
  if(p == (char*)-1)
 630:	83 c4 10             	add    $0x10,%esp
 633:	83 f8 ff             	cmp    $0xffffffff,%eax
 636:	74 1c                	je     654 <malloc+0x80>
  hp->s.size = nu;
 638:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 63b:	83 ec 0c             	sub    $0xc,%esp
 63e:	83 c0 08             	add    $0x8,%eax
 641:	50                   	push   %eax
 642:	e8 05 ff ff ff       	call   54c <free>
  return freep;
 647:	8b 15 ac 07 00 00    	mov    0x7ac,%edx
      if((p = morecore(nunits)) == 0)
 64d:	83 c4 10             	add    $0x10,%esp
 650:	85 d2                	test   %edx,%edx
 652:	75 c2                	jne    616 <malloc+0x42>
        return 0;
 654:	31 c0                	xor    %eax,%eax
  }
}
 656:	8d 65 f4             	lea    -0xc(%ebp),%esp
 659:	5b                   	pop    %ebx
 65a:	5e                   	pop    %esi
 65b:	5f                   	pop    %edi
 65c:	5d                   	pop    %ebp
 65d:	c3                   	ret
 65e:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 660:	39 cf                	cmp    %ecx,%edi
 662:	74 4c                	je     6b0 <malloc+0xdc>
        p->s.size -= nunits;
 664:	29 f9                	sub    %edi,%ecx
 666:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 669:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 66c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 66f:	89 15 ac 07 00 00    	mov    %edx,0x7ac
      return (void*)(p + 1);
 675:	83 c0 08             	add    $0x8,%eax
}
 678:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67b:	5b                   	pop    %ebx
 67c:	5e                   	pop    %esi
 67d:	5f                   	pop    %edi
 67e:	5d                   	pop    %ebp
 67f:	c3                   	ret
  if(nu < 4096)
 680:	bb 00 10 00 00       	mov    $0x1000,%ebx
 685:	eb 81                	jmp    608 <malloc+0x34>
 687:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 688:	c7 05 ac 07 00 00 b0 	movl   $0x7b0,0x7ac
 68f:	07 00 00 
 692:	c7 05 b0 07 00 00 b0 	movl   $0x7b0,0x7b0
 699:	07 00 00 
    base.s.size = 0;
 69c:	c7 05 b4 07 00 00 00 	movl   $0x0,0x7b4
 6a3:	00 00 00 
 6a6:	b8 b0 07 00 00       	mov    $0x7b0,%eax
 6ab:	e9 4e ff ff ff       	jmp    5fe <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6b0:	8b 08                	mov    (%eax),%ecx
 6b2:	89 0a                	mov    %ecx,(%edx)
 6b4:	eb b9                	jmp    66f <malloc+0x9b>
