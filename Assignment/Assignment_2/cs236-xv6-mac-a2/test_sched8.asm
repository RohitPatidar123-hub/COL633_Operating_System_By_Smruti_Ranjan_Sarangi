
_test_sched8:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int pid1, pid2;

    // Child 1 with exec_time 30 ticks (should terminate sooner)
    pid1 = custom_fork(1, 30);
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 1e                	push   $0x1e
  14:	6a 01                	push   $0x1
  16:	e8 20 03 00 00       	call   33b <custom_fork>
    if(pid1 < 0) {
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	85 c0                	test   %eax,%eax
  20:	78 4c                	js     6e <main+0x6e>
        printf(1, "Fork failed for child 1\n");
        exit();
    }
    if(pid1 == 0) {
  22:	74 32                	je     56 <main+0x56>
  24:	89 c3                	mov    %eax,%ebx
        // while(1);
        exit();
    }

    // Child 2 with exec_time 70 ticks (runs longer)
    pid2 = custom_fork(1, 70);
  26:	50                   	push   %eax
  27:	50                   	push   %eax
  28:	6a 46                	push   $0x46
  2a:	6a 01                	push   $0x1
  2c:	e8 0a 03 00 00       	call   33b <custom_fork>
    if(pid2 < 0) {
  31:	83 c4 10             	add    $0x10,%esp
  34:	85 c0                	test   %eax,%eax
  36:	0f 88 81 00 00 00    	js     bd <main+0xbd>
        printf(1, "Fork failed for child 2\n");
        exit();
    }
    if(pid2 == 0) {
  3c:	75 43                	jne    81 <main+0x81>
        printf(1, "[Child 2] (PID: %d) started\n", getpid());
  3e:	e8 d0 02 00 00       	call   313 <getpid>
  43:	51                   	push   %ecx
  44:	50                   	push   %eax
  45:	68 07 07 00 00       	push   $0x707
  4a:	6a 01                	push   $0x1
  4c:	e8 87 03 00 00       	call   3d8 <printf>
        // Do some work
        // while(1);
        exit();
  51:	e8 3d 02 00 00       	call   293 <exit>
        printf(1, "[Child 1] (PID: %d) started\n", getpid());
  56:	e8 b8 02 00 00       	call   313 <getpid>
  5b:	52                   	push   %edx
  5c:	50                   	push   %eax
  5d:	68 d1 06 00 00       	push   $0x6d1
  62:	6a 01                	push   $0x1
  64:	e8 6f 03 00 00       	call   3d8 <printf>
        exit();
  69:	e8 25 02 00 00       	call   293 <exit>
        printf(1, "Fork failed for child 1\n");
  6e:	51                   	push   %ecx
  6f:	51                   	push   %ecx
  70:	68 b8 06 00 00       	push   $0x6b8
  75:	6a 01                	push   $0x1
  77:	e8 5c 03 00 00       	call   3d8 <printf>
        exit();
  7c:	e8 12 02 00 00       	call   293 <exit>
    }
    
    printf(1, "[Parent] Created child PID %d with 30 ticks and PID %d with 70 ticks\n", pid1, pid2);
  81:	50                   	push   %eax
  82:	53                   	push   %ebx
  83:	68 2c 07 00 00       	push   $0x72c
  88:	6a 01                	push   $0x1
  8a:	e8 49 03 00 00       	call   3d8 <printf>
    sleep(300);
  8f:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
  96:	e8 88 02 00 00       	call   323 <sleep>
    scheduler_start();
  9b:	e8 a3 02 00 00       	call   343 <scheduler_start>
    wait();
  a0:	e8 f6 01 00 00       	call   29b <wait>
    wait();
  a5:	e8 f1 01 00 00       	call   29b <wait>
    printf(1, "[Parent] All child processes completed.\n");
  aa:	58                   	pop    %eax
  ab:	5a                   	pop    %edx
  ac:	68 74 07 00 00       	push   $0x774
  b1:	6a 01                	push   $0x1
  b3:	e8 20 03 00 00       	call   3d8 <printf>
    exit();
  b8:	e8 d6 01 00 00       	call   293 <exit>
        printf(1, "Fork failed for child 2\n");
  bd:	53                   	push   %ebx
  be:	53                   	push   %ebx
  bf:	68 ee 06 00 00       	push   $0x6ee
  c4:	6a 01                	push   $0x1
  c6:	e8 0d 03 00 00       	call   3d8 <printf>
        exit();
  cb:	e8 c3 01 00 00       	call   293 <exit>

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	31 c0                	xor    %eax,%eax
  dc:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  df:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  e2:	40                   	inc    %eax
  e3:	84 d2                	test   %dl,%dl
  e5:	75 f5                	jne    dc <strcpy+0xc>
    ;
  return os;
}
  e7:	89 c8                	mov    %ecx,%eax
  e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ec:	c9                   	leave
  ed:	c3                   	ret
  ee:	66 90                	xchg   %ax,%ax

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
  f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  fa:	0f b6 02             	movzbl (%edx),%eax
  fd:	84 c0                	test   %al,%al
  ff:	75 10                	jne    111 <strcmp+0x21>
 101:	eb 2a                	jmp    12d <strcmp+0x3d>
 103:	90                   	nop
    p++, q++;
 104:	42                   	inc    %edx
 105:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 108:	0f b6 02             	movzbl (%edx),%eax
 10b:	84 c0                	test   %al,%al
 10d:	74 11                	je     120 <strcmp+0x30>
 10f:	89 cb                	mov    %ecx,%ebx
 111:	0f b6 0b             	movzbl (%ebx),%ecx
 114:	38 c1                	cmp    %al,%cl
 116:	74 ec                	je     104 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 118:	29 c8                	sub    %ecx,%eax
}
 11a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11d:	c9                   	leave
 11e:	c3                   	ret
 11f:	90                   	nop
  return (uchar)*p - (uchar)*q;
 120:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 124:	31 c0                	xor    %eax,%eax
 126:	29 c8                	sub    %ecx,%eax
}
 128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 12b:	c9                   	leave
 12c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 12d:	0f b6 0b             	movzbl (%ebx),%ecx
 130:	31 c0                	xor    %eax,%eax
 132:	eb e4                	jmp    118 <strcmp+0x28>

00000134 <strlen>:

uint
strlen(const char *s)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 13a:	80 3a 00             	cmpb   $0x0,(%edx)
 13d:	74 15                	je     154 <strlen+0x20>
 13f:	31 c0                	xor    %eax,%eax
 141:	8d 76 00             	lea    0x0(%esi),%esi
 144:	40                   	inc    %eax
 145:	89 c1                	mov    %eax,%ecx
 147:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 14b:	75 f7                	jne    144 <strlen+0x10>
    ;
  return n;
}
 14d:	89 c8                	mov    %ecx,%eax
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret
 151:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 154:	31 c9                	xor    %ecx,%ecx
}
 156:	89 c8                	mov    %ecx,%eax
 158:	5d                   	pop    %ebp
 159:	c3                   	ret
 15a:	66 90                	xchg   %ax,%ax

0000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 160:	8b 7d 08             	mov    0x8(%ebp),%edi
 163:	8b 4d 10             	mov    0x10(%ebp),%ecx
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	fc                   	cld
 16a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 172:	c9                   	leave
 173:	c3                   	ret

00000174 <strchr>:

char*
strchr(const char *s, char c)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 17d:	8a 10                	mov    (%eax),%dl
 17f:	84 d2                	test   %dl,%dl
 181:	75 0c                	jne    18f <strchr+0x1b>
 183:	eb 13                	jmp    198 <strchr+0x24>
 185:	8d 76 00             	lea    0x0(%esi),%esi
 188:	40                   	inc    %eax
 189:	8a 10                	mov    (%eax),%dl
 18b:	84 d2                	test   %dl,%dl
 18d:	74 09                	je     198 <strchr+0x24>
    if(*s == c)
 18f:	38 d1                	cmp    %dl,%cl
 191:	75 f5                	jne    188 <strchr+0x14>
      return (char*)s;
  return 0;
}
 193:	5d                   	pop    %ebp
 194:	c3                   	ret
 195:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 198:	31 c0                	xor    %eax,%eax
}
 19a:	5d                   	pop    %ebp
 19b:	c3                   	ret

0000019c <gets>:

char*
gets(char *buf, int max)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	57                   	push   %edi
 1a0:	56                   	push   %esi
 1a1:	53                   	push   %ebx
 1a2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1a7:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1aa:	eb 24                	jmp    1d0 <gets+0x34>
    cc = read(0, &c, 1);
 1ac:	50                   	push   %eax
 1ad:	6a 01                	push   $0x1
 1af:	56                   	push   %esi
 1b0:	6a 00                	push   $0x0
 1b2:	e8 f4 00 00 00       	call   2ab <read>
    if(cc < 1)
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	85 c0                	test   %eax,%eax
 1bc:	7e 1a                	jle    1d8 <gets+0x3c>
      break;
    buf[i++] = c;
 1be:	8a 45 e7             	mov    -0x19(%ebp),%al
 1c1:	8b 55 08             	mov    0x8(%ebp),%edx
 1c4:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1c8:	3c 0a                	cmp    $0xa,%al
 1ca:	74 0e                	je     1da <gets+0x3e>
 1cc:	3c 0d                	cmp    $0xd,%al
 1ce:	74 0a                	je     1da <gets+0x3e>
  for(i=0; i+1 < max; ){
 1d0:	89 df                	mov    %ebx,%edi
 1d2:	43                   	inc    %ebx
 1d3:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d6:	7c d4                	jl     1ac <gets+0x10>
 1d8:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e4:	5b                   	pop    %ebx
 1e5:	5e                   	pop    %esi
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret
 1e9:	8d 76 00             	lea    0x0(%esi),%esi

000001ec <stat>:

int
stat(const char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	6a 00                	push   $0x0
 1f6:	ff 75 08             	push   0x8(%ebp)
 1f9:	e8 d5 00 00 00       	call   2d3 <open>
  if(fd < 0)
 1fe:	83 c4 10             	add    $0x10,%esp
 201:	85 c0                	test   %eax,%eax
 203:	78 27                	js     22c <stat+0x40>
 205:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	ff 75 0c             	push   0xc(%ebp)
 20d:	50                   	push   %eax
 20e:	e8 d8 00 00 00       	call   2eb <fstat>
 213:	89 c6                	mov    %eax,%esi
  close(fd);
 215:	89 1c 24             	mov    %ebx,(%esp)
 218:	e8 9e 00 00 00       	call   2bb <close>
  return r;
 21d:	83 c4 10             	add    $0x10,%esp
}
 220:	89 f0                	mov    %esi,%eax
 222:	8d 65 f8             	lea    -0x8(%ebp),%esp
 225:	5b                   	pop    %ebx
 226:	5e                   	pop    %esi
 227:	5d                   	pop    %ebp
 228:	c3                   	ret
 229:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 22c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 231:	eb ed                	jmp    220 <stat+0x34>
 233:	90                   	nop

00000234 <atoi>:

int
atoi(const char *s)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	53                   	push   %ebx
 238:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23b:	0f be 01             	movsbl (%ecx),%eax
 23e:	8d 50 d0             	lea    -0x30(%eax),%edx
 241:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 244:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 249:	77 16                	ja     261 <atoi+0x2d>
 24b:	90                   	nop
    n = n*10 + *s++ - '0';
 24c:	41                   	inc    %ecx
 24d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 250:	01 d2                	add    %edx,%edx
 252:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 256:	0f be 01             	movsbl (%ecx),%eax
 259:	8d 58 d0             	lea    -0x30(%eax),%ebx
 25c:	80 fb 09             	cmp    $0x9,%bl
 25f:	76 eb                	jbe    24c <atoi+0x18>
  return n;
}
 261:	89 d0                	mov    %edx,%eax
 263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 266:	c9                   	leave
 267:	c3                   	ret

00000268 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	57                   	push   %edi
 26c:	56                   	push   %esi
 26d:	8b 55 08             	mov    0x8(%ebp),%edx
 270:	8b 75 0c             	mov    0xc(%ebp),%esi
 273:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 276:	85 c0                	test   %eax,%eax
 278:	7e 0b                	jle    285 <memmove+0x1d>
 27a:	01 d0                	add    %edx,%eax
  dst = vdst;
 27c:	89 d7                	mov    %edx,%edi
 27e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 280:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 281:	39 f8                	cmp    %edi,%eax
 283:	75 fb                	jne    280 <memmove+0x18>
  return vdst;
}
 285:	89 d0                	mov    %edx,%eax
 287:	5e                   	pop    %esi
 288:	5f                   	pop    %edi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret

0000028b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28b:	b8 01 00 00 00       	mov    $0x1,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <exit>:
SYSCALL(exit)
 293:	b8 02 00 00 00       	mov    $0x2,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <wait>:
SYSCALL(wait)
 29b:	b8 03 00 00 00       	mov    $0x3,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <pipe>:
SYSCALL(pipe)
 2a3:	b8 04 00 00 00       	mov    $0x4,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <read>:
SYSCALL(read)
 2ab:	b8 05 00 00 00       	mov    $0x5,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <write>:
SYSCALL(write)
 2b3:	b8 10 00 00 00       	mov    $0x10,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <close>:
SYSCALL(close)
 2bb:	b8 15 00 00 00       	mov    $0x15,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <kill>:
SYSCALL(kill)
 2c3:	b8 06 00 00 00       	mov    $0x6,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <exec>:
SYSCALL(exec)
 2cb:	b8 07 00 00 00       	mov    $0x7,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <open>:
SYSCALL(open)
 2d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <mknod>:
SYSCALL(mknod)
 2db:	b8 11 00 00 00       	mov    $0x11,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <unlink>:
SYSCALL(unlink)
 2e3:	b8 12 00 00 00       	mov    $0x12,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <fstat>:
SYSCALL(fstat)
 2eb:	b8 08 00 00 00       	mov    $0x8,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <link>:
SYSCALL(link)
 2f3:	b8 13 00 00 00       	mov    $0x13,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <mkdir>:
SYSCALL(mkdir)
 2fb:	b8 14 00 00 00       	mov    $0x14,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <chdir>:
SYSCALL(chdir)
 303:	b8 09 00 00 00       	mov    $0x9,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <dup>:
SYSCALL(dup)
 30b:	b8 0a 00 00 00       	mov    $0xa,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <getpid>:
SYSCALL(getpid)
 313:	b8 0b 00 00 00       	mov    $0xb,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <sbrk>:
SYSCALL(sbrk)
 31b:	b8 0c 00 00 00       	mov    $0xc,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <sleep>:
SYSCALL(sleep)
 323:	b8 0d 00 00 00       	mov    $0xd,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <uptime>:
SYSCALL(uptime)
 32b:	b8 0e 00 00 00       	mov    $0xe,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <signal>:
SYSCALL(signal)
 333:	b8 16 00 00 00       	mov    $0x16,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <custom_fork>:
SYSCALL(custom_fork)
 33b:	b8 17 00 00 00       	mov    $0x17,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <scheduler_start>:
 343:	b8 18 00 00 00       	mov    $0x18,%eax
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
 380:	8a 92 f8 07 00 00    	mov    0x7f8(%edx),%dl
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
 3b8:	e8 f6 fe ff ff       	call   2b3 <write>
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
 407:	e8 a7 fe ff ff       	call   2b3 <write>
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
 43a:	ff 24 85 a0 07 00 00 	jmp    *0x7a0(,%eax,4)
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
 453:	e8 5b fe ff ff       	call   2b3 <write>
        putc(fd, c);
 458:	8a 55 d0             	mov    -0x30(%ebp),%dl
 45b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 45e:	83 c4 0c             	add    $0xc,%esp
 461:	6a 01                	push   $0x1
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	e8 49 fe ff ff       	call   2b3 <write>
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
 4d4:	e8 da fd ff ff       	call   2b3 <write>
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
 520:	e8 8e fd ff ff       	call   2b3 <write>
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
 540:	bf 24 07 00 00       	mov    $0x724,%edi
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
 558:	a1 0c 08 00 00       	mov    0x80c,%eax
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
 589:	89 15 0c 08 00 00    	mov    %edx,0x80c
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
 5c8:	89 15 0c 08 00 00    	mov    %edx,0x80c
}
 5ce:	5b                   	pop    %ebx
 5cf:	5e                   	pop    %esi
 5d0:	5f                   	pop    %edi
 5d1:	5d                   	pop    %ebp
 5d2:	c3                   	ret
 5d3:	90                   	nop

000005d4 <malloc>:
  return freep;
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
 5e7:	8b 15 0c 08 00 00    	mov    0x80c,%edx
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
  p = sbrk(nu * sizeof(Header));
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
 61f:	39 05 0c 08 00 00    	cmp    %eax,0x80c
 625:	75 ed                	jne    614 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 627:	83 ec 0c             	sub    $0xc,%esp
 62a:	56                   	push   %esi
 62b:	e8 eb fc ff ff       	call   31b <sbrk>
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
 647:	8b 15 0c 08 00 00    	mov    0x80c,%edx
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
 66f:	89 15 0c 08 00 00    	mov    %edx,0x80c
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
 688:	c7 05 0c 08 00 00 10 	movl   $0x810,0x80c
 68f:	08 00 00 
 692:	c7 05 10 08 00 00 10 	movl   $0x810,0x810
 699:	08 00 00 
    base.s.size = 0;
 69c:	c7 05 14 08 00 00 00 	movl   $0x0,0x814
 6a3:	00 00 00 
 6a6:	b8 10 08 00 00       	mov    $0x810,%eax
 6ab:	e9 4e ff ff ff       	jmp    5fe <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6b0:	8b 08                	mov    (%eax),%ecx
 6b2:	89 0a                	mov    %ecx,(%edx)
 6b4:	eb b9                	jmp    66f <malloc+0x9b>
