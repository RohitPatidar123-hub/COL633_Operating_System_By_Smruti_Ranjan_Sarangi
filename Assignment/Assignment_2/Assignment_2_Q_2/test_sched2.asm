
_test_sched2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
    int pid = custom_fork(1, -1);  // start later, run indefinitely
  11:	6a ff                	push   $0xffffffff
  13:	6a 01                	push   $0x1
  15:	e8 d1 02 00 00       	call   2eb <custom_fork>
    if (pid < 0) {
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	85 c0                	test   %eax,%eax
  1f:	78 51                	js     72 <main+0x72>
        printf(1, "Fork failed\n");
        exit();
    } else if (pid == 0) {
  21:	75 18                	jne    3b <main+0x3b>
        // Child process branch
        printf(1, "[Child] I'm starting now (PID: %d)\n", getpid());
  23:	e8 a3 02 00 00       	call   2cb <getpid>
  28:	52                   	push   %edx
  29:	50                   	push   %eax
  2a:	68 7c 06 00 00       	push   $0x67c
  2f:	6a 01                	push   $0x1
  31:	e8 52 03 00 00       	call   388 <printf>
  36:	83 c4 10             	add    $0x10,%esp
        // Run indefinitely
        while(1);
  39:	eb fe                	jmp    39 <main+0x39>
        exit();
    } else {
        // Parent process branch
        printf(1, "[Parent] Child created with PID %d (start later)\n", pid);
  3b:	52                   	push   %edx
  3c:	50                   	push   %eax
  3d:	68 a0 06 00 00       	push   $0x6a0
  42:	6a 01                	push   $0x1
  44:	e8 3f 03 00 00       	call   388 <printf>
        sleep(100);
  49:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  50:	e8 86 02 00 00       	call   2db <sleep>
        scheduler_start();  // Now allow the delayed child to run
  55:	e8 99 02 00 00       	call   2f3 <scheduler_start>
        printf(1, "[Parent] Called scheduler_start\n");
  5a:	59                   	pop    %ecx
  5b:	58                   	pop    %eax
  5c:	68 d4 06 00 00       	push   $0x6d4
  61:	6a 01                	push   $0x1
  63:	e8 20 03 00 00       	call   388 <printf>
        wait();
  68:	e8 e6 01 00 00       	call   253 <wait>
    }
    exit();
  6d:	e8 d9 01 00 00       	call   24b <exit>
        printf(1, "Fork failed\n");
  72:	51                   	push   %ecx
  73:	51                   	push   %ecx
  74:	68 68 06 00 00       	push   $0x668
  79:	6a 01                	push   $0x1
  7b:	e8 08 03 00 00       	call   388 <printf>
        exit();
  80:	e8 c6 01 00 00       	call   24b <exit>
  85:	66 90                	xchg   %ax,%ax
  87:	90                   	nop

00000088 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	53                   	push   %ebx
  8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  92:	31 c0                	xor    %eax,%eax
  94:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  97:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  9a:	40                   	inc    %eax
  9b:	84 d2                	test   %dl,%dl
  9d:	75 f5                	jne    94 <strcpy+0xc>
    ;
  return os;
}
  9f:	89 c8                	mov    %ecx,%eax
  a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a4:	c9                   	leave
  a5:	c3                   	ret
  a6:	66 90                	xchg   %ax,%ax

000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	53                   	push   %ebx
  ac:	8b 55 08             	mov    0x8(%ebp),%edx
  af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  b2:	0f b6 02             	movzbl (%edx),%eax
  b5:	84 c0                	test   %al,%al
  b7:	75 10                	jne    c9 <strcmp+0x21>
  b9:	eb 2a                	jmp    e5 <strcmp+0x3d>
  bb:	90                   	nop
    p++, q++;
  bc:	42                   	inc    %edx
  bd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  c0:	0f b6 02             	movzbl (%edx),%eax
  c3:	84 c0                	test   %al,%al
  c5:	74 11                	je     d8 <strcmp+0x30>
  c7:	89 cb                	mov    %ecx,%ebx
  c9:	0f b6 0b             	movzbl (%ebx),%ecx
  cc:	38 c1                	cmp    %al,%cl
  ce:	74 ec                	je     bc <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  d0:	29 c8                	sub    %ecx,%eax
}
  d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d5:	c9                   	leave
  d6:	c3                   	ret
  d7:	90                   	nop
  return (uchar)*p - (uchar)*q;
  d8:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  dc:	31 c0                	xor    %eax,%eax
  de:	29 c8                	sub    %ecx,%eax
}
  e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e3:	c9                   	leave
  e4:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  e5:	0f b6 0b             	movzbl (%ebx),%ecx
  e8:	31 c0                	xor    %eax,%eax
  ea:	eb e4                	jmp    d0 <strcmp+0x28>

000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  f2:	80 3a 00             	cmpb   $0x0,(%edx)
  f5:	74 15                	je     10c <strlen+0x20>
  f7:	31 c0                	xor    %eax,%eax
  f9:	8d 76 00             	lea    0x0(%esi),%esi
  fc:	40                   	inc    %eax
  fd:	89 c1                	mov    %eax,%ecx
  ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 103:	75 f7                	jne    fc <strlen+0x10>
    ;
  return n;
}
 105:	89 c8                	mov    %ecx,%eax
 107:	5d                   	pop    %ebp
 108:	c3                   	ret
 109:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 10c:	31 c9                	xor    %ecx,%ecx
}
 10e:	89 c8                	mov    %ecx,%eax
 110:	5d                   	pop    %ebp
 111:	c3                   	ret
 112:	66 90                	xchg   %ax,%ax

00000114 <memset>:

void*
memset(void *dst, int c, uint n)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 118:	8b 7d 08             	mov    0x8(%ebp),%edi
 11b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	fc                   	cld
 122:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	8b 7d fc             	mov    -0x4(%ebp),%edi
 12a:	c9                   	leave
 12b:	c3                   	ret

0000012c <strchr>:

char*
strchr(const char *s, char c)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 135:	8a 10                	mov    (%eax),%dl
 137:	84 d2                	test   %dl,%dl
 139:	75 0c                	jne    147 <strchr+0x1b>
 13b:	eb 13                	jmp    150 <strchr+0x24>
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	40                   	inc    %eax
 141:	8a 10                	mov    (%eax),%dl
 143:	84 d2                	test   %dl,%dl
 145:	74 09                	je     150 <strchr+0x24>
    if(*s == c)
 147:	38 d1                	cmp    %dl,%cl
 149:	75 f5                	jne    140 <strchr+0x14>
      return (char*)s;
  return 0;
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret
 14d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 150:	31 c0                	xor    %eax,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret

00000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	57                   	push   %edi
 158:	56                   	push   %esi
 159:	53                   	push   %ebx
 15a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 15f:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 162:	eb 24                	jmp    188 <gets+0x34>
    cc = read(0, &c, 1);
 164:	50                   	push   %eax
 165:	6a 01                	push   $0x1
 167:	56                   	push   %esi
 168:	6a 00                	push   $0x0
 16a:	e8 f4 00 00 00       	call   263 <read>
    if(cc < 1)
 16f:	83 c4 10             	add    $0x10,%esp
 172:	85 c0                	test   %eax,%eax
 174:	7e 1a                	jle    190 <gets+0x3c>
      break;
    buf[i++] = c;
 176:	8a 45 e7             	mov    -0x19(%ebp),%al
 179:	8b 55 08             	mov    0x8(%ebp),%edx
 17c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 0e                	je     192 <gets+0x3e>
 184:	3c 0d                	cmp    $0xd,%al
 186:	74 0a                	je     192 <gets+0x3e>
  for(i=0; i+1 < max; ){
 188:	89 df                	mov    %ebx,%edi
 18a:	43                   	inc    %ebx
 18b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18e:	7c d4                	jl     164 <gets+0x10>
 190:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 199:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19c:	5b                   	pop    %ebx
 19d:	5e                   	pop    %esi
 19e:	5f                   	pop    %edi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret
 1a1:	8d 76 00             	lea    0x0(%esi),%esi

000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	56                   	push   %esi
 1a8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	6a 00                	push   $0x0
 1ae:	ff 75 08             	push   0x8(%ebp)
 1b1:	e8 d5 00 00 00       	call   28b <open>
  if(fd < 0)
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	85 c0                	test   %eax,%eax
 1bb:	78 27                	js     1e4 <stat+0x40>
 1bd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	ff 75 0c             	push   0xc(%ebp)
 1c5:	50                   	push   %eax
 1c6:	e8 d8 00 00 00       	call   2a3 <fstat>
 1cb:	89 c6                	mov    %eax,%esi
  close(fd);
 1cd:	89 1c 24             	mov    %ebx,(%esp)
 1d0:	e8 9e 00 00 00       	call   273 <close>
  return r;
 1d5:	83 c4 10             	add    $0x10,%esp
}
 1d8:	89 f0                	mov    %esi,%eax
 1da:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1dd:	5b                   	pop    %ebx
 1de:	5e                   	pop    %esi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret
 1e1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1e4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e9:	eb ed                	jmp    1d8 <stat+0x34>
 1eb:	90                   	nop

000001ec <atoi>:

int
atoi(const char *s)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	53                   	push   %ebx
 1f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f3:	0f be 01             	movsbl (%ecx),%eax
 1f6:	8d 50 d0             	lea    -0x30(%eax),%edx
 1f9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1fc:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 201:	77 16                	ja     219 <atoi+0x2d>
 203:	90                   	nop
    n = n*10 + *s++ - '0';
 204:	41                   	inc    %ecx
 205:	8d 14 92             	lea    (%edx,%edx,4),%edx
 208:	01 d2                	add    %edx,%edx
 20a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 20e:	0f be 01             	movsbl (%ecx),%eax
 211:	8d 58 d0             	lea    -0x30(%eax),%ebx
 214:	80 fb 09             	cmp    $0x9,%bl
 217:	76 eb                	jbe    204 <atoi+0x18>
  return n;
}
 219:	89 d0                	mov    %edx,%eax
 21b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 21e:	c9                   	leave
 21f:	c3                   	ret

00000220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	8b 55 08             	mov    0x8(%ebp),%edx
 228:	8b 75 0c             	mov    0xc(%ebp),%esi
 22b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22e:	85 c0                	test   %eax,%eax
 230:	7e 0b                	jle    23d <memmove+0x1d>
 232:	01 d0                	add    %edx,%eax
  dst = vdst;
 234:	89 d7                	mov    %edx,%edi
 236:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 238:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 239:	39 f8                	cmp    %edi,%eax
 23b:	75 fb                	jne    238 <memmove+0x18>
  return vdst;
}
 23d:	89 d0                	mov    %edx,%eax
 23f:	5e                   	pop    %esi
 240:	5f                   	pop    %edi
 241:	5d                   	pop    %ebp
 242:	c3                   	ret

00000243 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 243:	b8 01 00 00 00       	mov    $0x1,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret

0000024b <exit>:
SYSCALL(exit)
 24b:	b8 02 00 00 00       	mov    $0x2,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret

00000253 <wait>:
SYSCALL(wait)
 253:	b8 03 00 00 00       	mov    $0x3,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret

0000025b <pipe>:
SYSCALL(pipe)
 25b:	b8 04 00 00 00       	mov    $0x4,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret

00000263 <read>:
SYSCALL(read)
 263:	b8 05 00 00 00       	mov    $0x5,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <write>:
SYSCALL(write)
 26b:	b8 10 00 00 00       	mov    $0x10,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <close>:
SYSCALL(close)
 273:	b8 15 00 00 00       	mov    $0x15,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <kill>:
SYSCALL(kill)
 27b:	b8 06 00 00 00       	mov    $0x6,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <exec>:
SYSCALL(exec)
 283:	b8 07 00 00 00       	mov    $0x7,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <open>:
SYSCALL(open)
 28b:	b8 0f 00 00 00       	mov    $0xf,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <mknod>:
SYSCALL(mknod)
 293:	b8 11 00 00 00       	mov    $0x11,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <unlink>:
SYSCALL(unlink)
 29b:	b8 12 00 00 00       	mov    $0x12,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <fstat>:
SYSCALL(fstat)
 2a3:	b8 08 00 00 00       	mov    $0x8,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <link>:
SYSCALL(link)
 2ab:	b8 13 00 00 00       	mov    $0x13,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <mkdir>:
SYSCALL(mkdir)
 2b3:	b8 14 00 00 00       	mov    $0x14,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <chdir>:
SYSCALL(chdir)
 2bb:	b8 09 00 00 00       	mov    $0x9,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <dup>:
SYSCALL(dup)
 2c3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <getpid>:
SYSCALL(getpid)
 2cb:	b8 0b 00 00 00       	mov    $0xb,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <sbrk>:
SYSCALL(sbrk)
 2d3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <sleep>:
SYSCALL(sleep)
 2db:	b8 0d 00 00 00       	mov    $0xd,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <uptime>:
SYSCALL(uptime)
 2e3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <custom_fork>:
SYSCALL(custom_fork)
 2eb:	b8 17 00 00 00       	mov    $0x17,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <scheduler_start>:
SYSCALL(scheduler_start)
 2f3:	b8 18 00 00 00       	mov    $0x18,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret
 2fb:	90                   	nop

000002fc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	57                   	push   %edi
 300:	56                   	push   %esi
 301:	53                   	push   %ebx
 302:	83 ec 3c             	sub    $0x3c,%esp
 305:	89 45 c0             	mov    %eax,-0x40(%ebp)
 308:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30d:	85 c9                	test   %ecx,%ecx
 30f:	74 04                	je     315 <printint+0x19>
 311:	85 d2                	test   %edx,%edx
 313:	78 6b                	js     380 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 315:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 318:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 31f:	31 c9                	xor    %ecx,%ecx
 321:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 324:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 327:	31 d2                	xor    %edx,%edx
 329:	f7 f3                	div    %ebx
 32b:	89 cf                	mov    %ecx,%edi
 32d:	8d 49 01             	lea    0x1(%ecx),%ecx
 330:	8a 92 50 07 00 00    	mov    0x750(%edx),%dl
 336:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 33a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 33d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 340:	39 da                	cmp    %ebx,%edx
 342:	73 e0                	jae    324 <printint+0x28>
  if(neg)
 344:	8b 55 08             	mov    0x8(%ebp),%edx
 347:	85 d2                	test   %edx,%edx
 349:	74 07                	je     352 <printint+0x56>
    buf[i++] = '-';
 34b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 350:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 352:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 355:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 359:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 35c:	8a 07                	mov    (%edi),%al
 35e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 361:	50                   	push   %eax
 362:	6a 01                	push   $0x1
 364:	56                   	push   %esi
 365:	ff 75 c0             	push   -0x40(%ebp)
 368:	e8 fe fe ff ff       	call   26b <write>
  while(--i >= 0)
 36d:	89 f8                	mov    %edi,%eax
 36f:	4f                   	dec    %edi
 370:	83 c4 10             	add    $0x10,%esp
 373:	39 d8                	cmp    %ebx,%eax
 375:	75 e5                	jne    35c <printint+0x60>
}
 377:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37a:	5b                   	pop    %ebx
 37b:	5e                   	pop    %esi
 37c:	5f                   	pop    %edi
 37d:	5d                   	pop    %ebp
 37e:	c3                   	ret
 37f:	90                   	nop
    x = -xx;
 380:	f7 da                	neg    %edx
 382:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 385:	eb 98                	jmp    31f <printint+0x23>
 387:	90                   	nop

00000388 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	57                   	push   %edi
 38c:	56                   	push   %esi
 38d:	53                   	push   %ebx
 38e:	83 ec 2c             	sub    $0x2c,%esp
 391:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 394:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 397:	8a 03                	mov    (%ebx),%al
 399:	84 c0                	test   %al,%al
 39b:	74 2a                	je     3c7 <printf+0x3f>
 39d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 39e:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3a1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3a4:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3a7:	83 fa 25             	cmp    $0x25,%edx
 3aa:	74 24                	je     3d0 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3ac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3af:	50                   	push   %eax
 3b0:	6a 01                	push   $0x1
 3b2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3b5:	50                   	push   %eax
 3b6:	56                   	push   %esi
 3b7:	e8 af fe ff ff       	call   26b <write>
  for(i = 0; fmt[i]; i++){
 3bc:	43                   	inc    %ebx
 3bd:	8a 43 ff             	mov    -0x1(%ebx),%al
 3c0:	83 c4 10             	add    $0x10,%esp
 3c3:	84 c0                	test   %al,%al
 3c5:	75 dd                	jne    3a4 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ca:	5b                   	pop    %ebx
 3cb:	5e                   	pop    %esi
 3cc:	5f                   	pop    %edi
 3cd:	5d                   	pop    %ebp
 3ce:	c3                   	ret
 3cf:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3d0:	8a 13                	mov    (%ebx),%dl
 3d2:	84 d2                	test   %dl,%dl
 3d4:	74 f1                	je     3c7 <printf+0x3f>
    c = fmt[i] & 0xff;
 3d6:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3d9:	80 fa 25             	cmp    $0x25,%dl
 3dc:	0f 84 fe 00 00 00    	je     4e0 <printf+0x158>
 3e2:	83 e8 63             	sub    $0x63,%eax
 3e5:	83 f8 15             	cmp    $0x15,%eax
 3e8:	77 0a                	ja     3f4 <printf+0x6c>
 3ea:	ff 24 85 f8 06 00 00 	jmp    *0x6f8(,%eax,4)
 3f1:	8d 76 00             	lea    0x0(%esi),%esi
 3f4:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3f7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3fb:	50                   	push   %eax
 3fc:	6a 01                	push   $0x1
 3fe:	8d 7d e7             	lea    -0x19(%ebp),%edi
 401:	57                   	push   %edi
 402:	56                   	push   %esi
 403:	e8 63 fe ff ff       	call   26b <write>
        putc(fd, c);
 408:	8a 55 d0             	mov    -0x30(%ebp),%dl
 40b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 40e:	83 c4 0c             	add    $0xc,%esp
 411:	6a 01                	push   $0x1
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	e8 51 fe ff ff       	call   26b <write>
  for(i = 0; fmt[i]; i++){
 41a:	83 c3 02             	add    $0x2,%ebx
 41d:	8a 43 ff             	mov    -0x1(%ebx),%al
 420:	83 c4 10             	add    $0x10,%esp
 423:	84 c0                	test   %al,%al
 425:	0f 85 79 ff ff ff    	jne    3a4 <printf+0x1c>
}
 42b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42e:	5b                   	pop    %ebx
 42f:	5e                   	pop    %esi
 430:	5f                   	pop    %edi
 431:	5d                   	pop    %ebp
 432:	c3                   	ret
 433:	90                   	nop
        printint(fd, *ap, 16, 0);
 434:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 437:	8b 17                	mov    (%edi),%edx
 439:	83 ec 0c             	sub    $0xc,%esp
 43c:	6a 00                	push   $0x0
 43e:	b9 10 00 00 00       	mov    $0x10,%ecx
 443:	89 f0                	mov    %esi,%eax
 445:	e8 b2 fe ff ff       	call   2fc <printint>
        ap++;
 44a:	83 c7 04             	add    $0x4,%edi
 44d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 450:	eb c8                	jmp    41a <printf+0x92>
 452:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 454:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 457:	8b 01                	mov    (%ecx),%eax
        ap++;
 459:	83 c1 04             	add    $0x4,%ecx
 45c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 45f:	85 c0                	test   %eax,%eax
 461:	0f 84 89 00 00 00    	je     4f0 <printf+0x168>
        while(*s != 0){
 467:	8a 10                	mov    (%eax),%dl
 469:	84 d2                	test   %dl,%dl
 46b:	74 29                	je     496 <printf+0x10e>
 46d:	89 c7                	mov    %eax,%edi
 46f:	88 d0                	mov    %dl,%al
 471:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 474:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 477:	89 fb                	mov    %edi,%ebx
 479:	89 cf                	mov    %ecx,%edi
 47b:	90                   	nop
          putc(fd, *s);
 47c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 47f:	50                   	push   %eax
 480:	6a 01                	push   $0x1
 482:	57                   	push   %edi
 483:	56                   	push   %esi
 484:	e8 e2 fd ff ff       	call   26b <write>
          s++;
 489:	43                   	inc    %ebx
        while(*s != 0){
 48a:	8a 03                	mov    (%ebx),%al
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	84 c0                	test   %al,%al
 491:	75 e9                	jne    47c <printf+0xf4>
 493:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 496:	83 c3 02             	add    $0x2,%ebx
 499:	8a 43 ff             	mov    -0x1(%ebx),%al
 49c:	84 c0                	test   %al,%al
 49e:	0f 85 00 ff ff ff    	jne    3a4 <printf+0x1c>
 4a4:	e9 1e ff ff ff       	jmp    3c7 <printf+0x3f>
 4a9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4af:	8b 17                	mov    (%edi),%edx
 4b1:	83 ec 0c             	sub    $0xc,%esp
 4b4:	6a 01                	push   $0x1
 4b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4bb:	eb 86                	jmp    443 <printf+0xbb>
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4c3:	8b 00                	mov    (%eax),%eax
 4c5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4c8:	51                   	push   %ecx
 4c9:	6a 01                	push   $0x1
 4cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4ce:	57                   	push   %edi
 4cf:	56                   	push   %esi
 4d0:	e8 96 fd ff ff       	call   26b <write>
        ap++;
 4d5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4d9:	e9 3c ff ff ff       	jmp    41a <printf+0x92>
 4de:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4e3:	52                   	push   %edx
 4e4:	6a 01                	push   $0x1
 4e6:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4e9:	e9 25 ff ff ff       	jmp    413 <printf+0x8b>
 4ee:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4f0:	bf 75 06 00 00       	mov    $0x675,%edi
 4f5:	b0 28                	mov    $0x28,%al
 4f7:	e9 75 ff ff ff       	jmp    471 <printf+0xe9>

000004fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	57                   	push   %edi
 500:	56                   	push   %esi
 501:	53                   	push   %ebx
 502:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 505:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 508:	a1 64 07 00 00       	mov    0x764,%eax
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 512:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 514:	39 ca                	cmp    %ecx,%edx
 516:	73 2c                	jae    544 <free+0x48>
 518:	39 c1                	cmp    %eax,%ecx
 51a:	72 04                	jb     520 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 51c:	39 c2                	cmp    %eax,%edx
 51e:	72 f0                	jb     510 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 520:	8b 73 fc             	mov    -0x4(%ebx),%esi
 523:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 526:	39 f8                	cmp    %edi,%eax
 528:	74 2c                	je     556 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 52a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 52d:	8b 42 04             	mov    0x4(%edx),%eax
 530:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 533:	39 f1                	cmp    %esi,%ecx
 535:	74 36                	je     56d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 537:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 539:	89 15 64 07 00 00    	mov    %edx,0x764
}
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5f                   	pop    %edi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 544:	39 c2                	cmp    %eax,%edx
 546:	72 c8                	jb     510 <free+0x14>
 548:	39 c1                	cmp    %eax,%ecx
 54a:	73 c4                	jae    510 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 54c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 54f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 552:	39 f8                	cmp    %edi,%eax
 554:	75 d4                	jne    52a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 556:	03 70 04             	add    0x4(%eax),%esi
 559:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 55c:	8b 02                	mov    (%edx),%eax
 55e:	8b 00                	mov    (%eax),%eax
 560:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 563:	8b 42 04             	mov    0x4(%edx),%eax
 566:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 569:	39 f1                	cmp    %esi,%ecx
 56b:	75 ca                	jne    537 <free+0x3b>
    p->s.size += bp->s.size;
 56d:	03 43 fc             	add    -0x4(%ebx),%eax
 570:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 573:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 576:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 578:	89 15 64 07 00 00    	mov    %edx,0x764
}
 57e:	5b                   	pop    %ebx
 57f:	5e                   	pop    %esi
 580:	5f                   	pop    %edi
 581:	5d                   	pop    %ebp
 582:	c3                   	ret
 583:	90                   	nop

00000584 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	57                   	push   %edi
 588:	56                   	push   %esi
 589:	53                   	push   %ebx
 58a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	8d 78 07             	lea    0x7(%eax),%edi
 593:	c1 ef 03             	shr    $0x3,%edi
 596:	47                   	inc    %edi
  if((prevp = freep) == 0){
 597:	8b 15 64 07 00 00    	mov    0x764,%edx
 59d:	85 d2                	test   %edx,%edx
 59f:	0f 84 93 00 00 00    	je     638 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5a7:	8b 48 04             	mov    0x4(%eax),%ecx
 5aa:	39 f9                	cmp    %edi,%ecx
 5ac:	73 62                	jae    610 <malloc+0x8c>
  if(nu < 4096)
 5ae:	89 fb                	mov    %edi,%ebx
 5b0:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5b6:	72 78                	jb     630 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5b8:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5bf:	eb 0e                	jmp    5cf <malloc+0x4b>
 5c1:	8d 76 00             	lea    0x0(%esi),%esi
 5c4:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5c8:	8b 48 04             	mov    0x4(%eax),%ecx
 5cb:	39 f9                	cmp    %edi,%ecx
 5cd:	73 41                	jae    610 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5cf:	39 05 64 07 00 00    	cmp    %eax,0x764
 5d5:	75 ed                	jne    5c4 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5d7:	83 ec 0c             	sub    $0xc,%esp
 5da:	56                   	push   %esi
 5db:	e8 f3 fc ff ff       	call   2d3 <sbrk>
  if(p == (char*)-1)
 5e0:	83 c4 10             	add    $0x10,%esp
 5e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e6:	74 1c                	je     604 <malloc+0x80>
  hp->s.size = nu;
 5e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5eb:	83 ec 0c             	sub    $0xc,%esp
 5ee:	83 c0 08             	add    $0x8,%eax
 5f1:	50                   	push   %eax
 5f2:	e8 05 ff ff ff       	call   4fc <free>
  return freep;
 5f7:	8b 15 64 07 00 00    	mov    0x764,%edx
      if((p = morecore(nunits)) == 0)
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	85 d2                	test   %edx,%edx
 602:	75 c2                	jne    5c6 <malloc+0x42>
        return 0;
 604:	31 c0                	xor    %eax,%eax
  }
}
 606:	8d 65 f4             	lea    -0xc(%ebp),%esp
 609:	5b                   	pop    %ebx
 60a:	5e                   	pop    %esi
 60b:	5f                   	pop    %edi
 60c:	5d                   	pop    %ebp
 60d:	c3                   	ret
 60e:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 610:	39 cf                	cmp    %ecx,%edi
 612:	74 4c                	je     660 <malloc+0xdc>
        p->s.size -= nunits;
 614:	29 f9                	sub    %edi,%ecx
 616:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 619:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 61c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 61f:	89 15 64 07 00 00    	mov    %edx,0x764
      return (void*)(p + 1);
 625:	83 c0 08             	add    $0x8,%eax
}
 628:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62b:	5b                   	pop    %ebx
 62c:	5e                   	pop    %esi
 62d:	5f                   	pop    %edi
 62e:	5d                   	pop    %ebp
 62f:	c3                   	ret
  if(nu < 4096)
 630:	bb 00 10 00 00       	mov    $0x1000,%ebx
 635:	eb 81                	jmp    5b8 <malloc+0x34>
 637:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 638:	c7 05 64 07 00 00 68 	movl   $0x768,0x764
 63f:	07 00 00 
 642:	c7 05 68 07 00 00 68 	movl   $0x768,0x768
 649:	07 00 00 
    base.s.size = 0;
 64c:	c7 05 6c 07 00 00 00 	movl   $0x0,0x76c
 653:	00 00 00 
 656:	b8 68 07 00 00       	mov    $0x768,%eax
 65b:	e9 4e ff ff ff       	jmp    5ae <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 660:	8b 08                	mov    (%eax),%ecx
 662:	89 0a                	mov    %ecx,(%edx)
 664:	eb b9                	jmp    61f <malloc+0x9b>
