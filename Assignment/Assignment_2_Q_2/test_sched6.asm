
_test_sched6:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 3

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int i, pid;
    
    // Create several children that will start later and run for 50 ticks each.
    for (i = 0; i < NUM_CHILDREN; i++) {
   f:	31 db                	xor    %ebx,%ebx
        pid = custom_fork(1, 50);  // Delayed start, exec_time = 50 ticks
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 32                	push   $0x32
  16:	6a 01                	push   $0x1
  18:	e8 ee 02 00 00       	call   30b <custom_fork>
        if (pid < 0) {
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	78 58                	js     7c <main+0x7c>
            printf(1, "Failed to fork child %d\n", i);
            exit();
        } else if (pid == 0) {
  24:	74 69                	je     8f <main+0x8f>
    for (i = 0; i < NUM_CHILDREN; i++) {
  26:	43                   	inc    %ebx
  27:	83 fb 03             	cmp    $0x3,%ebx
  2a:	75 e5                	jne    11 <main+0x11>
            exit();
        }
        // Parent continues to create the next child.
    }
    
    printf(1, "All child processes created with start_later flag set.\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 dc 06 00 00       	push   $0x6dc
  34:	6a 01                	push   $0x1
  36:	e8 6d 03 00 00       	call   3a8 <printf>
    
    // Sleep for a while to simulate delay before starting children.
    sleep(400);
  3b:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
  42:	e8 b4 02 00 00       	call   2fb <sleep>
    
    printf(1, "Calling sys_scheduler_start() to allow execution.\n");
  47:	58                   	pop    %eax
  48:	5a                   	pop    %edx
  49:	68 14 07 00 00       	push   $0x714
  4e:	6a 01                	push   $0x1
  50:	e8 53 03 00 00       	call   3a8 <printf>
    scheduler_start();
  55:	e8 b9 02 00 00       	call   313 <scheduler_start>
    
    // Wait for all children to exit.
    for (i = 0; i < NUM_CHILDREN; i++) {
        wait();
  5a:	e8 14 02 00 00       	call   273 <wait>
  5f:	e8 0f 02 00 00       	call   273 <wait>
  64:	e8 0a 02 00 00       	call   273 <wait>
    }
    
    printf(1, "All child processes completed.\n");
  69:	59                   	pop    %ecx
  6a:	5b                   	pop    %ebx
  6b:	68 48 07 00 00       	push   $0x748
  70:	6a 01                	push   $0x1
  72:	e8 31 03 00 00       	call   3a8 <printf>
    exit();
  77:	e8 ef 01 00 00       	call   26b <exit>
            printf(1, "Failed to fork child %d\n", i);
  7c:	50                   	push   %eax
  7d:	53                   	push   %ebx
  7e:	68 88 06 00 00       	push   $0x688
  83:	6a 01                	push   $0x1
  85:	e8 1e 03 00 00       	call   3a8 <printf>
            exit();
  8a:	e8 dc 01 00 00       	call   26b <exit>
            printf(1, "Child %d (PID: %d) started but should not run yet.\n", i, getpid());
  8f:	e8 57 02 00 00       	call   2eb <getpid>
  94:	50                   	push   %eax
  95:	53                   	push   %ebx
  96:	68 a8 06 00 00       	push   $0x6a8
  9b:	6a 01                	push   $0x1
  9d:	e8 06 03 00 00       	call   3a8 <printf>
            exit();
  a2:	e8 c4 01 00 00       	call   26b <exit>
  a7:	90                   	nop

000000a8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	53                   	push   %ebx
  ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	31 c0                	xor    %eax,%eax
  b4:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  b7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  ba:	40                   	inc    %eax
  bb:	84 d2                	test   %dl,%dl
  bd:	75 f5                	jne    b4 <strcpy+0xc>
    ;
  return os;
}
  bf:	89 c8                	mov    %ecx,%eax
  c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c4:	c9                   	leave
  c5:	c3                   	ret
  c6:	66 90                	xchg   %ax,%ax

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	53                   	push   %ebx
  cc:	8b 55 08             	mov    0x8(%ebp),%edx
  cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  d2:	0f b6 02             	movzbl (%edx),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 10                	jne    e9 <strcmp+0x21>
  d9:	eb 2a                	jmp    105 <strcmp+0x3d>
  db:	90                   	nop
    p++, q++;
  dc:	42                   	inc    %edx
  dd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  e0:	0f b6 02             	movzbl (%edx),%eax
  e3:	84 c0                	test   %al,%al
  e5:	74 11                	je     f8 <strcmp+0x30>
  e7:	89 cb                	mov    %ecx,%ebx
  e9:	0f b6 0b             	movzbl (%ebx),%ecx
  ec:	38 c1                	cmp    %al,%cl
  ee:	74 ec                	je     dc <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  f0:	29 c8                	sub    %ecx,%eax
}
  f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f5:	c9                   	leave
  f6:	c3                   	ret
  f7:	90                   	nop
  return (uchar)*p - (uchar)*q;
  f8:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  fc:	31 c0                	xor    %eax,%eax
  fe:	29 c8                	sub    %ecx,%eax
}
 100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 103:	c9                   	leave
 104:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 105:	0f b6 0b             	movzbl (%ebx),%ecx
 108:	31 c0                	xor    %eax,%eax
 10a:	eb e4                	jmp    f0 <strcmp+0x28>

0000010c <strlen>:

uint
strlen(const char *s)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 112:	80 3a 00             	cmpb   $0x0,(%edx)
 115:	74 15                	je     12c <strlen+0x20>
 117:	31 c0                	xor    %eax,%eax
 119:	8d 76 00             	lea    0x0(%esi),%esi
 11c:	40                   	inc    %eax
 11d:	89 c1                	mov    %eax,%ecx
 11f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 123:	75 f7                	jne    11c <strlen+0x10>
    ;
  return n;
}
 125:	89 c8                	mov    %ecx,%eax
 127:	5d                   	pop    %ebp
 128:	c3                   	ret
 129:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 12c:	31 c9                	xor    %ecx,%ecx
}
 12e:	89 c8                	mov    %ecx,%eax
 130:	5d                   	pop    %ebp
 131:	c3                   	ret
 132:	66 90                	xchg   %ax,%ax

00000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 138:	8b 7d 08             	mov    0x8(%ebp),%edi
 13b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13e:	8b 45 0c             	mov    0xc(%ebp),%eax
 141:	fc                   	cld
 142:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8b 7d fc             	mov    -0x4(%ebp),%edi
 14a:	c9                   	leave
 14b:	c3                   	ret

0000014c <strchr>:

char*
strchr(const char *s, char c)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 155:	8a 10                	mov    (%eax),%dl
 157:	84 d2                	test   %dl,%dl
 159:	75 0c                	jne    167 <strchr+0x1b>
 15b:	eb 13                	jmp    170 <strchr+0x24>
 15d:	8d 76 00             	lea    0x0(%esi),%esi
 160:	40                   	inc    %eax
 161:	8a 10                	mov    (%eax),%dl
 163:	84 d2                	test   %dl,%dl
 165:	74 09                	je     170 <strchr+0x24>
    if(*s == c)
 167:	38 d1                	cmp    %dl,%cl
 169:	75 f5                	jne    160 <strchr+0x14>
      return (char*)s;
  return 0;
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret
 16d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 170:	31 c0                	xor    %eax,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret

00000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	56                   	push   %esi
 179:	53                   	push   %ebx
 17a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 17f:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 182:	eb 24                	jmp    1a8 <gets+0x34>
    cc = read(0, &c, 1);
 184:	50                   	push   %eax
 185:	6a 01                	push   $0x1
 187:	56                   	push   %esi
 188:	6a 00                	push   $0x0
 18a:	e8 f4 00 00 00       	call   283 <read>
    if(cc < 1)
 18f:	83 c4 10             	add    $0x10,%esp
 192:	85 c0                	test   %eax,%eax
 194:	7e 1a                	jle    1b0 <gets+0x3c>
      break;
    buf[i++] = c;
 196:	8a 45 e7             	mov    -0x19(%ebp),%al
 199:	8b 55 08             	mov    0x8(%ebp),%edx
 19c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1a0:	3c 0a                	cmp    $0xa,%al
 1a2:	74 0e                	je     1b2 <gets+0x3e>
 1a4:	3c 0d                	cmp    $0xd,%al
 1a6:	74 0a                	je     1b2 <gets+0x3e>
  for(i=0; i+1 < max; ){
 1a8:	89 df                	mov    %ebx,%edi
 1aa:	43                   	inc    %ebx
 1ab:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ae:	7c d4                	jl     184 <gets+0x10>
 1b0:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1bc:	5b                   	pop    %ebx
 1bd:	5e                   	pop    %esi
 1be:	5f                   	pop    %edi
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret
 1c1:	8d 76 00             	lea    0x0(%esi),%esi

000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	56                   	push   %esi
 1c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	6a 00                	push   $0x0
 1ce:	ff 75 08             	push   0x8(%ebp)
 1d1:	e8 d5 00 00 00       	call   2ab <open>
  if(fd < 0)
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	85 c0                	test   %eax,%eax
 1db:	78 27                	js     204 <stat+0x40>
 1dd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	ff 75 0c             	push   0xc(%ebp)
 1e5:	50                   	push   %eax
 1e6:	e8 d8 00 00 00       	call   2c3 <fstat>
 1eb:	89 c6                	mov    %eax,%esi
  close(fd);
 1ed:	89 1c 24             	mov    %ebx,(%esp)
 1f0:	e8 9e 00 00 00       	call   293 <close>
  return r;
 1f5:	83 c4 10             	add    $0x10,%esp
}
 1f8:	89 f0                	mov    %esi,%eax
 1fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1fd:	5b                   	pop    %ebx
 1fe:	5e                   	pop    %esi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret
 201:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 204:	be ff ff ff ff       	mov    $0xffffffff,%esi
 209:	eb ed                	jmp    1f8 <stat+0x34>
 20b:	90                   	nop

0000020c <atoi>:

int
atoi(const char *s)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	53                   	push   %ebx
 210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 213:	0f be 01             	movsbl (%ecx),%eax
 216:	8d 50 d0             	lea    -0x30(%eax),%edx
 219:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 21c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 221:	77 16                	ja     239 <atoi+0x2d>
 223:	90                   	nop
    n = n*10 + *s++ - '0';
 224:	41                   	inc    %ecx
 225:	8d 14 92             	lea    (%edx,%edx,4),%edx
 228:	01 d2                	add    %edx,%edx
 22a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 22e:	0f be 01             	movsbl (%ecx),%eax
 231:	8d 58 d0             	lea    -0x30(%eax),%ebx
 234:	80 fb 09             	cmp    $0x9,%bl
 237:	76 eb                	jbe    224 <atoi+0x18>
  return n;
}
 239:	89 d0                	mov    %edx,%eax
 23b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 23e:	c9                   	leave
 23f:	c3                   	ret

00000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	8b 55 08             	mov    0x8(%ebp),%edx
 248:	8b 75 0c             	mov    0xc(%ebp),%esi
 24b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 c0                	test   %eax,%eax
 250:	7e 0b                	jle    25d <memmove+0x1d>
 252:	01 d0                	add    %edx,%eax
  dst = vdst;
 254:	89 d7                	mov    %edx,%edi
 256:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 258:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 259:	39 f8                	cmp    %edi,%eax
 25b:	75 fb                	jne    258 <memmove+0x18>
  return vdst;
}
 25d:	89 d0                	mov    %edx,%eax
 25f:	5e                   	pop    %esi
 260:	5f                   	pop    %edi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret

00000263 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 263:	b8 01 00 00 00       	mov    $0x1,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <exit>:
SYSCALL(exit)
 26b:	b8 02 00 00 00       	mov    $0x2,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <wait>:
SYSCALL(wait)
 273:	b8 03 00 00 00       	mov    $0x3,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <pipe>:
SYSCALL(pipe)
 27b:	b8 04 00 00 00       	mov    $0x4,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <read>:
SYSCALL(read)
 283:	b8 05 00 00 00       	mov    $0x5,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <write>:
SYSCALL(write)
 28b:	b8 10 00 00 00       	mov    $0x10,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <close>:
SYSCALL(close)
 293:	b8 15 00 00 00       	mov    $0x15,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <kill>:
SYSCALL(kill)
 29b:	b8 06 00 00 00       	mov    $0x6,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <exec>:
SYSCALL(exec)
 2a3:	b8 07 00 00 00       	mov    $0x7,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <open>:
SYSCALL(open)
 2ab:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <mknod>:
SYSCALL(mknod)
 2b3:	b8 11 00 00 00       	mov    $0x11,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <unlink>:
SYSCALL(unlink)
 2bb:	b8 12 00 00 00       	mov    $0x12,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <fstat>:
SYSCALL(fstat)
 2c3:	b8 08 00 00 00       	mov    $0x8,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <link>:
SYSCALL(link)
 2cb:	b8 13 00 00 00       	mov    $0x13,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <mkdir>:
SYSCALL(mkdir)
 2d3:	b8 14 00 00 00       	mov    $0x14,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <chdir>:
SYSCALL(chdir)
 2db:	b8 09 00 00 00       	mov    $0x9,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <dup>:
SYSCALL(dup)
 2e3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <getpid>:
SYSCALL(getpid)
 2eb:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <sbrk>:
SYSCALL(sbrk)
 2f3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <sleep>:
SYSCALL(sleep)
 2fb:	b8 0d 00 00 00       	mov    $0xd,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <uptime>:
SYSCALL(uptime)
 303:	b8 0e 00 00 00       	mov    $0xe,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <custom_fork>:
SYSCALL(custom_fork)
 30b:	b8 17 00 00 00       	mov    $0x17,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <scheduler_start>:
SYSCALL(scheduler_start)
 313:	b8 18 00 00 00       	mov    $0x18,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret
 31b:	90                   	nop

0000031c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	57                   	push   %edi
 320:	56                   	push   %esi
 321:	53                   	push   %ebx
 322:	83 ec 3c             	sub    $0x3c,%esp
 325:	89 45 c0             	mov    %eax,-0x40(%ebp)
 328:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32d:	85 c9                	test   %ecx,%ecx
 32f:	74 04                	je     335 <printint+0x19>
 331:	85 d2                	test   %edx,%edx
 333:	78 6b                	js     3a0 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 335:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 338:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 33f:	31 c9                	xor    %ecx,%ecx
 341:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 344:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 347:	31 d2                	xor    %edx,%edx
 349:	f7 f3                	div    %ebx
 34b:	89 cf                	mov    %ecx,%edi
 34d:	8d 49 01             	lea    0x1(%ecx),%ecx
 350:	8a 92 c0 07 00 00    	mov    0x7c0(%edx),%dl
 356:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 35a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 35d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 360:	39 da                	cmp    %ebx,%edx
 362:	73 e0                	jae    344 <printint+0x28>
  if(neg)
 364:	8b 55 08             	mov    0x8(%ebp),%edx
 367:	85 d2                	test   %edx,%edx
 369:	74 07                	je     372 <printint+0x56>
    buf[i++] = '-';
 36b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 370:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 372:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 375:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 379:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 37c:	8a 07                	mov    (%edi),%al
 37e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 381:	50                   	push   %eax
 382:	6a 01                	push   $0x1
 384:	56                   	push   %esi
 385:	ff 75 c0             	push   -0x40(%ebp)
 388:	e8 fe fe ff ff       	call   28b <write>
  while(--i >= 0)
 38d:	89 f8                	mov    %edi,%eax
 38f:	4f                   	dec    %edi
 390:	83 c4 10             	add    $0x10,%esp
 393:	39 d8                	cmp    %ebx,%eax
 395:	75 e5                	jne    37c <printint+0x60>
}
 397:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39a:	5b                   	pop    %ebx
 39b:	5e                   	pop    %esi
 39c:	5f                   	pop    %edi
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret
 39f:	90                   	nop
    x = -xx;
 3a0:	f7 da                	neg    %edx
 3a2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3a5:	eb 98                	jmp    33f <printint+0x23>
 3a7:	90                   	nop

000003a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	57                   	push   %edi
 3ac:	56                   	push   %esi
 3ad:	53                   	push   %ebx
 3ae:	83 ec 2c             	sub    $0x2c,%esp
 3b1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3b7:	8a 03                	mov    (%ebx),%al
 3b9:	84 c0                	test   %al,%al
 3bb:	74 2a                	je     3e7 <printf+0x3f>
 3bd:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3be:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3c1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3c4:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3c7:	83 fa 25             	cmp    $0x25,%edx
 3ca:	74 24                	je     3f0 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3cf:	50                   	push   %eax
 3d0:	6a 01                	push   $0x1
 3d2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3d5:	50                   	push   %eax
 3d6:	56                   	push   %esi
 3d7:	e8 af fe ff ff       	call   28b <write>
  for(i = 0; fmt[i]; i++){
 3dc:	43                   	inc    %ebx
 3dd:	8a 43 ff             	mov    -0x1(%ebx),%al
 3e0:	83 c4 10             	add    $0x10,%esp
 3e3:	84 c0                	test   %al,%al
 3e5:	75 dd                	jne    3c4 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ea:	5b                   	pop    %ebx
 3eb:	5e                   	pop    %esi
 3ec:	5f                   	pop    %edi
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret
 3ef:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3f0:	8a 13                	mov    (%ebx),%dl
 3f2:	84 d2                	test   %dl,%dl
 3f4:	74 f1                	je     3e7 <printf+0x3f>
    c = fmt[i] & 0xff;
 3f6:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3f9:	80 fa 25             	cmp    $0x25,%dl
 3fc:	0f 84 fe 00 00 00    	je     500 <printf+0x158>
 402:	83 e8 63             	sub    $0x63,%eax
 405:	83 f8 15             	cmp    $0x15,%eax
 408:	77 0a                	ja     414 <printf+0x6c>
 40a:	ff 24 85 68 07 00 00 	jmp    *0x768(,%eax,4)
 411:	8d 76 00             	lea    0x0(%esi),%esi
 414:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 417:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 41b:	50                   	push   %eax
 41c:	6a 01                	push   $0x1
 41e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 421:	57                   	push   %edi
 422:	56                   	push   %esi
 423:	e8 63 fe ff ff       	call   28b <write>
        putc(fd, c);
 428:	8a 55 d0             	mov    -0x30(%ebp),%dl
 42b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 42e:	83 c4 0c             	add    $0xc,%esp
 431:	6a 01                	push   $0x1
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	e8 51 fe ff ff       	call   28b <write>
  for(i = 0; fmt[i]; i++){
 43a:	83 c3 02             	add    $0x2,%ebx
 43d:	8a 43 ff             	mov    -0x1(%ebx),%al
 440:	83 c4 10             	add    $0x10,%esp
 443:	84 c0                	test   %al,%al
 445:	0f 85 79 ff ff ff    	jne    3c4 <printf+0x1c>
}
 44b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44e:	5b                   	pop    %ebx
 44f:	5e                   	pop    %esi
 450:	5f                   	pop    %edi
 451:	5d                   	pop    %ebp
 452:	c3                   	ret
 453:	90                   	nop
        printint(fd, *ap, 16, 0);
 454:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 457:	8b 17                	mov    (%edi),%edx
 459:	83 ec 0c             	sub    $0xc,%esp
 45c:	6a 00                	push   $0x0
 45e:	b9 10 00 00 00       	mov    $0x10,%ecx
 463:	89 f0                	mov    %esi,%eax
 465:	e8 b2 fe ff ff       	call   31c <printint>
        ap++;
 46a:	83 c7 04             	add    $0x4,%edi
 46d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 470:	eb c8                	jmp    43a <printf+0x92>
 472:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 474:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 477:	8b 01                	mov    (%ecx),%eax
        ap++;
 479:	83 c1 04             	add    $0x4,%ecx
 47c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 47f:	85 c0                	test   %eax,%eax
 481:	0f 84 89 00 00 00    	je     510 <printf+0x168>
        while(*s != 0){
 487:	8a 10                	mov    (%eax),%dl
 489:	84 d2                	test   %dl,%dl
 48b:	74 29                	je     4b6 <printf+0x10e>
 48d:	89 c7                	mov    %eax,%edi
 48f:	88 d0                	mov    %dl,%al
 491:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 494:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 497:	89 fb                	mov    %edi,%ebx
 499:	89 cf                	mov    %ecx,%edi
 49b:	90                   	nop
          putc(fd, *s);
 49c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 49f:	50                   	push   %eax
 4a0:	6a 01                	push   $0x1
 4a2:	57                   	push   %edi
 4a3:	56                   	push   %esi
 4a4:	e8 e2 fd ff ff       	call   28b <write>
          s++;
 4a9:	43                   	inc    %ebx
        while(*s != 0){
 4aa:	8a 03                	mov    (%ebx),%al
 4ac:	83 c4 10             	add    $0x10,%esp
 4af:	84 c0                	test   %al,%al
 4b1:	75 e9                	jne    49c <printf+0xf4>
 4b3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4b6:	83 c3 02             	add    $0x2,%ebx
 4b9:	8a 43 ff             	mov    -0x1(%ebx),%al
 4bc:	84 c0                	test   %al,%al
 4be:	0f 85 00 ff ff ff    	jne    3c4 <printf+0x1c>
 4c4:	e9 1e ff ff ff       	jmp    3e7 <printf+0x3f>
 4c9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4cc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4cf:	8b 17                	mov    (%edi),%edx
 4d1:	83 ec 0c             	sub    $0xc,%esp
 4d4:	6a 01                	push   $0x1
 4d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4db:	eb 86                	jmp    463 <printf+0xbb>
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4e8:	51                   	push   %ecx
 4e9:	6a 01                	push   $0x1
 4eb:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4ee:	57                   	push   %edi
 4ef:	56                   	push   %esi
 4f0:	e8 96 fd ff ff       	call   28b <write>
        ap++;
 4f5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4f9:	e9 3c ff ff ff       	jmp    43a <printf+0x92>
 4fe:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 500:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 503:	52                   	push   %edx
 504:	6a 01                	push   $0x1
 506:	8d 7d e7             	lea    -0x19(%ebp),%edi
 509:	e9 25 ff ff ff       	jmp    433 <printf+0x8b>
 50e:	66 90                	xchg   %ax,%ax
          s = "(null)";
 510:	bf a1 06 00 00       	mov    $0x6a1,%edi
 515:	b0 28                	mov    $0x28,%al
 517:	e9 75 ff ff ff       	jmp    491 <printf+0xe9>

0000051c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	57                   	push   %edi
 520:	56                   	push   %esi
 521:	53                   	push   %ebx
 522:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 525:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 528:	a1 d4 07 00 00       	mov    0x7d4,%eax
 52d:	8d 76 00             	lea    0x0(%esi),%esi
 530:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 532:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 534:	39 ca                	cmp    %ecx,%edx
 536:	73 2c                	jae    564 <free+0x48>
 538:	39 c1                	cmp    %eax,%ecx
 53a:	72 04                	jb     540 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53c:	39 c2                	cmp    %eax,%edx
 53e:	72 f0                	jb     530 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 540:	8b 73 fc             	mov    -0x4(%ebx),%esi
 543:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 546:	39 f8                	cmp    %edi,%eax
 548:	74 2c                	je     576 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 54a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 54d:	8b 42 04             	mov    0x4(%edx),%eax
 550:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 553:	39 f1                	cmp    %esi,%ecx
 555:	74 36                	je     58d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 557:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 559:	89 15 d4 07 00 00    	mov    %edx,0x7d4
}
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 564:	39 c2                	cmp    %eax,%edx
 566:	72 c8                	jb     530 <free+0x14>
 568:	39 c1                	cmp    %eax,%ecx
 56a:	73 c4                	jae    530 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 56c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 572:	39 f8                	cmp    %edi,%eax
 574:	75 d4                	jne    54a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 576:	03 70 04             	add    0x4(%eax),%esi
 579:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 57c:	8b 02                	mov    (%edx),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 583:	8b 42 04             	mov    0x4(%edx),%eax
 586:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 589:	39 f1                	cmp    %esi,%ecx
 58b:	75 ca                	jne    557 <free+0x3b>
    p->s.size += bp->s.size;
 58d:	03 43 fc             	add    -0x4(%ebx),%eax
 590:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 593:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 596:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 598:	89 15 d4 07 00 00    	mov    %edx,0x7d4
}
 59e:	5b                   	pop    %ebx
 59f:	5e                   	pop    %esi
 5a0:	5f                   	pop    %edi
 5a1:	5d                   	pop    %ebp
 5a2:	c3                   	ret
 5a3:	90                   	nop

000005a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	57                   	push   %edi
 5a8:	56                   	push   %esi
 5a9:	53                   	push   %ebx
 5aa:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	8d 78 07             	lea    0x7(%eax),%edi
 5b3:	c1 ef 03             	shr    $0x3,%edi
 5b6:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5b7:	8b 15 d4 07 00 00    	mov    0x7d4,%edx
 5bd:	85 d2                	test   %edx,%edx
 5bf:	0f 84 93 00 00 00    	je     658 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5c7:	8b 48 04             	mov    0x4(%eax),%ecx
 5ca:	39 f9                	cmp    %edi,%ecx
 5cc:	73 62                	jae    630 <malloc+0x8c>
  if(nu < 4096)
 5ce:	89 fb                	mov    %edi,%ebx
 5d0:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5d6:	72 78                	jb     650 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5d8:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5df:	eb 0e                	jmp    5ef <malloc+0x4b>
 5e1:	8d 76 00             	lea    0x0(%esi),%esi
 5e4:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5e8:	8b 48 04             	mov    0x4(%eax),%ecx
 5eb:	39 f9                	cmp    %edi,%ecx
 5ed:	73 41                	jae    630 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5ef:	39 05 d4 07 00 00    	cmp    %eax,0x7d4
 5f5:	75 ed                	jne    5e4 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5f7:	83 ec 0c             	sub    $0xc,%esp
 5fa:	56                   	push   %esi
 5fb:	e8 f3 fc ff ff       	call   2f3 <sbrk>
  if(p == (char*)-1)
 600:	83 c4 10             	add    $0x10,%esp
 603:	83 f8 ff             	cmp    $0xffffffff,%eax
 606:	74 1c                	je     624 <malloc+0x80>
  hp->s.size = nu;
 608:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 60b:	83 ec 0c             	sub    $0xc,%esp
 60e:	83 c0 08             	add    $0x8,%eax
 611:	50                   	push   %eax
 612:	e8 05 ff ff ff       	call   51c <free>
  return freep;
 617:	8b 15 d4 07 00 00    	mov    0x7d4,%edx
      if((p = morecore(nunits)) == 0)
 61d:	83 c4 10             	add    $0x10,%esp
 620:	85 d2                	test   %edx,%edx
 622:	75 c2                	jne    5e6 <malloc+0x42>
        return 0;
 624:	31 c0                	xor    %eax,%eax
  }
}
 626:	8d 65 f4             	lea    -0xc(%ebp),%esp
 629:	5b                   	pop    %ebx
 62a:	5e                   	pop    %esi
 62b:	5f                   	pop    %edi
 62c:	5d                   	pop    %ebp
 62d:	c3                   	ret
 62e:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 630:	39 cf                	cmp    %ecx,%edi
 632:	74 4c                	je     680 <malloc+0xdc>
        p->s.size -= nunits;
 634:	29 f9                	sub    %edi,%ecx
 636:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 639:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 63c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 63f:	89 15 d4 07 00 00    	mov    %edx,0x7d4
      return (void*)(p + 1);
 645:	83 c0 08             	add    $0x8,%eax
}
 648:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5f                   	pop    %edi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret
  if(nu < 4096)
 650:	bb 00 10 00 00       	mov    $0x1000,%ebx
 655:	eb 81                	jmp    5d8 <malloc+0x34>
 657:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 658:	c7 05 d4 07 00 00 d8 	movl   $0x7d8,0x7d4
 65f:	07 00 00 
 662:	c7 05 d8 07 00 00 d8 	movl   $0x7d8,0x7d8
 669:	07 00 00 
    base.s.size = 0;
 66c:	c7 05 dc 07 00 00 00 	movl   $0x0,0x7dc
 673:	00 00 00 
 676:	b8 d8 07 00 00       	mov    $0x7d8,%eax
 67b:	e9 4e ff ff ff       	jmp    5ce <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 680:	8b 08                	mov    (%eax),%ecx
 682:	89 0a                	mov    %ecx,(%edx)
 684:	eb b9                	jmp    63f <malloc+0x9b>
