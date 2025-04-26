
_test_sched7:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 4

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int i, pid;
    
    // Create two processes that start immediately and two that are delayed.
    for (i = 0; i < NUM_CHILDREN; i++){
   f:	31 db                	xor    %ebx,%ebx
        if (i < 2)
  11:	83 fb 01             	cmp    $0x1,%ebx
  14:	7f 23                	jg     39 <main+0x39>
            pid = custom_fork(0, 50);  // Immediate start
  16:	83 ec 08             	sub    $0x8,%esp
  19:	6a 32                	push   $0x32
  1b:	6a 00                	push   $0x0
  1d:	e8 25 03 00 00       	call   347 <custom_fork>
        else
            pid = custom_fork(1, 50);  // Delayed start
        
        if(pid < 0) {
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	0f 88 82 00 00 00    	js     af <main+0xaf>
            printf(1, "Failed to fork child %d\n", i);
            exit();
        }
        if(pid == 0) {
  2d:	0f 84 8f 00 00 00    	je     c2 <main+0xc2>
    for (i = 0; i < NUM_CHILDREN; i++){
  33:	43                   	inc    %ebx
        if (i < 2)
  34:	83 fb 01             	cmp    $0x1,%ebx
  37:	7e dd                	jle    16 <main+0x16>
            pid = custom_fork(1, 50);  // Delayed start
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	6a 32                	push   $0x32
  3e:	6a 01                	push   $0x1
  40:	e8 02 03 00 00       	call   347 <custom_fork>
        if(pid < 0) {
  45:	83 c4 10             	add    $0x10,%esp
  48:	85 c0                	test   %eax,%eax
  4a:	78 63                	js     af <main+0xaf>
        if(pid == 0) {
  4c:	74 74                	je     c2 <main+0xc2>
    for (i = 0; i < NUM_CHILDREN; i++){
  4e:	83 fb 03             	cmp    $0x3,%ebx
  51:	75 55                	jne    a8 <main+0xa8>
            int j;
            for(j = 0; j < 100000000; j++) ;  // Busy loop
            exit();
        }
    }
    printf(1, "[Parent] All child processes created\n");
  53:	83 ec 08             	sub    $0x8,%esp
  56:	68 04 07 00 00       	push   $0x704
  5b:	6a 01                	push   $0x1
  5d:	e8 82 03 00 00       	call   3e4 <printf>

    // Wait a bit before starting delayed processes.
    sleep(300);
  62:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
  69:	e8 c1 02 00 00       	call   32f <sleep>
    printf(1, "[Parent] Calling scheduler_start() to allow delayed processes to run\n");
  6e:	58                   	pop    %eax
  6f:	5a                   	pop    %edx
  70:	68 2c 07 00 00       	push   $0x72c
  75:	6a 01                	push   $0x1
  77:	e8 68 03 00 00       	call   3e4 <printf>
    scheduler_start();
  7c:	e8 ce 02 00 00       	call   34f <scheduler_start>

    // Wait for all children to exit.
    for(i = 0; i < NUM_CHILDREN; i++){
        wait();
  81:	e8 21 02 00 00       	call   2a7 <wait>
  86:	e8 1c 02 00 00       	call   2a7 <wait>
  8b:	e8 17 02 00 00       	call   2a7 <wait>
  90:	e8 12 02 00 00       	call   2a7 <wait>
    }
    printf(1, "[Parent] All child processes completed.\n");
  95:	59                   	pop    %ecx
  96:	5b                   	pop    %ebx
  97:	68 74 07 00 00       	push   $0x774
  9c:	6a 01                	push   $0x1
  9e:	e8 41 03 00 00       	call   3e4 <printf>
    exit();
  a3:	e8 f7 01 00 00       	call   29f <exit>
  a8:	bb 03 00 00 00       	mov    $0x3,%ebx
  ad:	eb 8a                	jmp    39 <main+0x39>
            printf(1, "Failed to fork child %d\n", i);
  af:	50                   	push   %eax
  b0:	53                   	push   %ebx
  b1:	68 c4 06 00 00       	push   $0x6c4
  b6:	6a 01                	push   $0x1
  b8:	e8 27 03 00 00       	call   3e4 <printf>
            exit();
  bd:	e8 dd 01 00 00       	call   29f <exit>
            printf(1, "[Child %d] (PID: %d) started\n", i, getpid());
  c2:	e8 58 02 00 00       	call   31f <getpid>
  c7:	50                   	push   %eax
  c8:	53                   	push   %ebx
  c9:	68 dd 06 00 00       	push   $0x6dd
  ce:	6a 01                	push   $0x1
  d0:	e8 0f 03 00 00       	call   3e4 <printf>
            exit();
  d5:	e8 c5 01 00 00       	call   29f <exit>
  da:	66 90                	xchg   %ax,%ax

000000dc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	53                   	push   %ebx
  e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e6:	31 c0                	xor    %eax,%eax
  e8:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  eb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  ee:	40                   	inc    %eax
  ef:	84 d2                	test   %dl,%dl
  f1:	75 f5                	jne    e8 <strcpy+0xc>
    ;
  return os;
}
  f3:	89 c8                	mov    %ecx,%eax
  f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f8:	c9                   	leave
  f9:	c3                   	ret
  fa:	66 90                	xchg   %ax,%ax

000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	53                   	push   %ebx
 100:	8b 55 08             	mov    0x8(%ebp),%edx
 103:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 106:	0f b6 02             	movzbl (%edx),%eax
 109:	84 c0                	test   %al,%al
 10b:	75 10                	jne    11d <strcmp+0x21>
 10d:	eb 2a                	jmp    139 <strcmp+0x3d>
 10f:	90                   	nop
    p++, q++;
 110:	42                   	inc    %edx
 111:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 114:	0f b6 02             	movzbl (%edx),%eax
 117:	84 c0                	test   %al,%al
 119:	74 11                	je     12c <strcmp+0x30>
 11b:	89 cb                	mov    %ecx,%ebx
 11d:	0f b6 0b             	movzbl (%ebx),%ecx
 120:	38 c1                	cmp    %al,%cl
 122:	74 ec                	je     110 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 124:	29 c8                	sub    %ecx,%eax
}
 126:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 129:	c9                   	leave
 12a:	c3                   	ret
 12b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 12c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 130:	31 c0                	xor    %eax,%eax
 132:	29 c8                	sub    %ecx,%eax
}
 134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 137:	c9                   	leave
 138:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 139:	0f b6 0b             	movzbl (%ebx),%ecx
 13c:	31 c0                	xor    %eax,%eax
 13e:	eb e4                	jmp    124 <strcmp+0x28>

00000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 3a 00             	cmpb   $0x0,(%edx)
 149:	74 15                	je     160 <strlen+0x20>
 14b:	31 c0                	xor    %eax,%eax
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	40                   	inc    %eax
 151:	89 c1                	mov    %eax,%ecx
 153:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 157:	75 f7                	jne    150 <strlen+0x10>
    ;
  return n;
}
 159:	89 c8                	mov    %ecx,%eax
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret
 15d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 160:	31 c9                	xor    %ecx,%ecx
}
 162:	89 c8                	mov    %ecx,%eax
 164:	5d                   	pop    %ebp
 165:	c3                   	ret
 166:	66 90                	xchg   %ax,%ax

00000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 16c:	8b 7d 08             	mov    0x8(%ebp),%edi
 16f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 172:	8b 45 0c             	mov    0xc(%ebp),%eax
 175:	fc                   	cld
 176:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 17e:	c9                   	leave
 17f:	c3                   	ret

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 189:	8a 10                	mov    (%eax),%dl
 18b:	84 d2                	test   %dl,%dl
 18d:	75 0c                	jne    19b <strchr+0x1b>
 18f:	eb 13                	jmp    1a4 <strchr+0x24>
 191:	8d 76 00             	lea    0x0(%esi),%esi
 194:	40                   	inc    %eax
 195:	8a 10                	mov    (%eax),%dl
 197:	84 d2                	test   %dl,%dl
 199:	74 09                	je     1a4 <strchr+0x24>
    if(*s == c)
 19b:	38 d1                	cmp    %dl,%cl
 19d:	75 f5                	jne    194 <strchr+0x14>
      return (char*)s;
  return 0;
}
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret
 1a1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1a4:	31 c0                	xor    %eax,%eax
}
 1a6:	5d                   	pop    %ebp
 1a7:	c3                   	ret

000001a8 <gets>:

char*
gets(char *buf, int max)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	57                   	push   %edi
 1ac:	56                   	push   %esi
 1ad:	53                   	push   %ebx
 1ae:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b1:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1b3:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1b6:	eb 24                	jmp    1dc <gets+0x34>
    cc = read(0, &c, 1);
 1b8:	50                   	push   %eax
 1b9:	6a 01                	push   $0x1
 1bb:	56                   	push   %esi
 1bc:	6a 00                	push   $0x0
 1be:	e8 f4 00 00 00       	call   2b7 <read>
    if(cc < 1)
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	85 c0                	test   %eax,%eax
 1c8:	7e 1a                	jle    1e4 <gets+0x3c>
      break;
    buf[i++] = c;
 1ca:	8a 45 e7             	mov    -0x19(%ebp),%al
 1cd:	8b 55 08             	mov    0x8(%ebp),%edx
 1d0:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1d4:	3c 0a                	cmp    $0xa,%al
 1d6:	74 0e                	je     1e6 <gets+0x3e>
 1d8:	3c 0d                	cmp    $0xd,%al
 1da:	74 0a                	je     1e6 <gets+0x3e>
  for(i=0; i+1 < max; ){
 1dc:	89 df                	mov    %ebx,%edi
 1de:	43                   	inc    %ebx
 1df:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e2:	7c d4                	jl     1b8 <gets+0x10>
 1e4:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret
 1f5:	8d 76 00             	lea    0x0(%esi),%esi

000001f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	56                   	push   %esi
 1fc:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	6a 00                	push   $0x0
 202:	ff 75 08             	push   0x8(%ebp)
 205:	e8 d5 00 00 00       	call   2df <open>
  if(fd < 0)
 20a:	83 c4 10             	add    $0x10,%esp
 20d:	85 c0                	test   %eax,%eax
 20f:	78 27                	js     238 <stat+0x40>
 211:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 213:	83 ec 08             	sub    $0x8,%esp
 216:	ff 75 0c             	push   0xc(%ebp)
 219:	50                   	push   %eax
 21a:	e8 d8 00 00 00       	call   2f7 <fstat>
 21f:	89 c6                	mov    %eax,%esi
  close(fd);
 221:	89 1c 24             	mov    %ebx,(%esp)
 224:	e8 9e 00 00 00       	call   2c7 <close>
  return r;
 229:	83 c4 10             	add    $0x10,%esp
}
 22c:	89 f0                	mov    %esi,%eax
 22e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 231:	5b                   	pop    %ebx
 232:	5e                   	pop    %esi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret
 235:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 238:	be ff ff ff ff       	mov    $0xffffffff,%esi
 23d:	eb ed                	jmp    22c <stat+0x34>
 23f:	90                   	nop

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 01             	movsbl (%ecx),%eax
 24a:	8d 50 d0             	lea    -0x30(%eax),%edx
 24d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 250:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 255:	77 16                	ja     26d <atoi+0x2d>
 257:	90                   	nop
    n = n*10 + *s++ - '0';
 258:	41                   	inc    %ecx
 259:	8d 14 92             	lea    (%edx,%edx,4),%edx
 25c:	01 d2                	add    %edx,%edx
 25e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 262:	0f be 01             	movsbl (%ecx),%eax
 265:	8d 58 d0             	lea    -0x30(%eax),%ebx
 268:	80 fb 09             	cmp    $0x9,%bl
 26b:	76 eb                	jbe    258 <atoi+0x18>
  return n;
}
 26d:	89 d0                	mov    %edx,%eax
 26f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 272:	c9                   	leave
 273:	c3                   	ret

00000274 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	57                   	push   %edi
 278:	56                   	push   %esi
 279:	8b 55 08             	mov    0x8(%ebp),%edx
 27c:	8b 75 0c             	mov    0xc(%ebp),%esi
 27f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 282:	85 c0                	test   %eax,%eax
 284:	7e 0b                	jle    291 <memmove+0x1d>
 286:	01 d0                	add    %edx,%eax
  dst = vdst;
 288:	89 d7                	mov    %edx,%edi
 28a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 28c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 28d:	39 f8                	cmp    %edi,%eax
 28f:	75 fb                	jne    28c <memmove+0x18>
  return vdst;
}
 291:	89 d0                	mov    %edx,%eax
 293:	5e                   	pop    %esi
 294:	5f                   	pop    %edi
 295:	5d                   	pop    %ebp
 296:	c3                   	ret

00000297 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 297:	b8 01 00 00 00       	mov    $0x1,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <exit>:
SYSCALL(exit)
 29f:	b8 02 00 00 00       	mov    $0x2,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <wait>:
SYSCALL(wait)
 2a7:	b8 03 00 00 00       	mov    $0x3,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <pipe>:
SYSCALL(pipe)
 2af:	b8 04 00 00 00       	mov    $0x4,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <read>:
SYSCALL(read)
 2b7:	b8 05 00 00 00       	mov    $0x5,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <write>:
SYSCALL(write)
 2bf:	b8 10 00 00 00       	mov    $0x10,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <close>:
SYSCALL(close)
 2c7:	b8 15 00 00 00       	mov    $0x15,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <kill>:
SYSCALL(kill)
 2cf:	b8 06 00 00 00       	mov    $0x6,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <exec>:
SYSCALL(exec)
 2d7:	b8 07 00 00 00       	mov    $0x7,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <open>:
SYSCALL(open)
 2df:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <mknod>:
SYSCALL(mknod)
 2e7:	b8 11 00 00 00       	mov    $0x11,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <unlink>:
SYSCALL(unlink)
 2ef:	b8 12 00 00 00       	mov    $0x12,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <fstat>:
SYSCALL(fstat)
 2f7:	b8 08 00 00 00       	mov    $0x8,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <link>:
SYSCALL(link)
 2ff:	b8 13 00 00 00       	mov    $0x13,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <mkdir>:
SYSCALL(mkdir)
 307:	b8 14 00 00 00       	mov    $0x14,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <chdir>:
SYSCALL(chdir)
 30f:	b8 09 00 00 00       	mov    $0x9,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <dup>:
SYSCALL(dup)
 317:	b8 0a 00 00 00       	mov    $0xa,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <getpid>:
SYSCALL(getpid)
 31f:	b8 0b 00 00 00       	mov    $0xb,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <sbrk>:
SYSCALL(sbrk)
 327:	b8 0c 00 00 00       	mov    $0xc,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <sleep>:
SYSCALL(sleep)
 32f:	b8 0d 00 00 00       	mov    $0xd,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <uptime>:
SYSCALL(uptime)
 337:	b8 0e 00 00 00       	mov    $0xe,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <signal>:
SYSCALL(signal)
 33f:	b8 16 00 00 00       	mov    $0x16,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <custom_fork>:
SYSCALL(custom_fork)
 347:	b8 17 00 00 00       	mov    $0x17,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <scheduler_start>:
 34f:	b8 18 00 00 00       	mov    $0x18,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret
 357:	90                   	nop

00000358 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 3c             	sub    $0x3c,%esp
 361:	89 45 c0             	mov    %eax,-0x40(%ebp)
 364:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 366:	8b 4d 08             	mov    0x8(%ebp),%ecx
 369:	85 c9                	test   %ecx,%ecx
 36b:	74 04                	je     371 <printint+0x19>
 36d:	85 d2                	test   %edx,%edx
 36f:	78 6b                	js     3dc <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 371:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 374:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 37b:	31 c9                	xor    %ecx,%ecx
 37d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 380:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 383:	31 d2                	xor    %edx,%edx
 385:	f7 f3                	div    %ebx
 387:	89 cf                	mov    %ecx,%edi
 389:	8d 49 01             	lea    0x1(%ecx),%ecx
 38c:	8a 92 f8 07 00 00    	mov    0x7f8(%edx),%dl
 392:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 396:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 399:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 39c:	39 da                	cmp    %ebx,%edx
 39e:	73 e0                	jae    380 <printint+0x28>
  if(neg)
 3a0:	8b 55 08             	mov    0x8(%ebp),%edx
 3a3:	85 d2                	test   %edx,%edx
 3a5:	74 07                	je     3ae <printint+0x56>
    buf[i++] = '-';
 3a7:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3ac:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3ae:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3b1:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3b5:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3b8:	8a 07                	mov    (%edi),%al
 3ba:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3bd:	50                   	push   %eax
 3be:	6a 01                	push   $0x1
 3c0:	56                   	push   %esi
 3c1:	ff 75 c0             	push   -0x40(%ebp)
 3c4:	e8 f6 fe ff ff       	call   2bf <write>
  while(--i >= 0)
 3c9:	89 f8                	mov    %edi,%eax
 3cb:	4f                   	dec    %edi
 3cc:	83 c4 10             	add    $0x10,%esp
 3cf:	39 d8                	cmp    %ebx,%eax
 3d1:	75 e5                	jne    3b8 <printint+0x60>
}
 3d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret
 3db:	90                   	nop
    x = -xx;
 3dc:	f7 da                	neg    %edx
 3de:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3e1:	eb 98                	jmp    37b <printint+0x23>
 3e3:	90                   	nop

000003e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 2c             	sub    $0x2c,%esp
 3ed:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3f3:	8a 03                	mov    (%ebx),%al
 3f5:	84 c0                	test   %al,%al
 3f7:	74 2a                	je     423 <printf+0x3f>
 3f9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3fa:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3fd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 400:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 403:	83 fa 25             	cmp    $0x25,%edx
 406:	74 24                	je     42c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 408:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 40b:	50                   	push   %eax
 40c:	6a 01                	push   $0x1
 40e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 411:	50                   	push   %eax
 412:	56                   	push   %esi
 413:	e8 a7 fe ff ff       	call   2bf <write>
  for(i = 0; fmt[i]; i++){
 418:	43                   	inc    %ebx
 419:	8a 43 ff             	mov    -0x1(%ebx),%al
 41c:	83 c4 10             	add    $0x10,%esp
 41f:	84 c0                	test   %al,%al
 421:	75 dd                	jne    400 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 423:	8d 65 f4             	lea    -0xc(%ebp),%esp
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret
 42b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 42c:	8a 13                	mov    (%ebx),%dl
 42e:	84 d2                	test   %dl,%dl
 430:	74 f1                	je     423 <printf+0x3f>
    c = fmt[i] & 0xff;
 432:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 435:	80 fa 25             	cmp    $0x25,%dl
 438:	0f 84 fe 00 00 00    	je     53c <printf+0x158>
 43e:	83 e8 63             	sub    $0x63,%eax
 441:	83 f8 15             	cmp    $0x15,%eax
 444:	77 0a                	ja     450 <printf+0x6c>
 446:	ff 24 85 a0 07 00 00 	jmp    *0x7a0(,%eax,4)
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 453:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 457:	50                   	push   %eax
 458:	6a 01                	push   $0x1
 45a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 45d:	57                   	push   %edi
 45e:	56                   	push   %esi
 45f:	e8 5b fe ff ff       	call   2bf <write>
        putc(fd, c);
 464:	8a 55 d0             	mov    -0x30(%ebp),%dl
 467:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 46a:	83 c4 0c             	add    $0xc,%esp
 46d:	6a 01                	push   $0x1
 46f:	57                   	push   %edi
 470:	56                   	push   %esi
 471:	e8 49 fe ff ff       	call   2bf <write>
  for(i = 0; fmt[i]; i++){
 476:	83 c3 02             	add    $0x2,%ebx
 479:	8a 43 ff             	mov    -0x1(%ebx),%al
 47c:	83 c4 10             	add    $0x10,%esp
 47f:	84 c0                	test   %al,%al
 481:	0f 85 79 ff ff ff    	jne    400 <printf+0x1c>
}
 487:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48a:	5b                   	pop    %ebx
 48b:	5e                   	pop    %esi
 48c:	5f                   	pop    %edi
 48d:	5d                   	pop    %ebp
 48e:	c3                   	ret
 48f:	90                   	nop
        printint(fd, *ap, 16, 0);
 490:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 493:	8b 17                	mov    (%edi),%edx
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	6a 00                	push   $0x0
 49a:	b9 10 00 00 00       	mov    $0x10,%ecx
 49f:	89 f0                	mov    %esi,%eax
 4a1:	e8 b2 fe ff ff       	call   358 <printint>
        ap++;
 4a6:	83 c7 04             	add    $0x4,%edi
 4a9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4ac:	eb c8                	jmp    476 <printf+0x92>
 4ae:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4b0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4b3:	8b 01                	mov    (%ecx),%eax
        ap++;
 4b5:	83 c1 04             	add    $0x4,%ecx
 4b8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4bb:	85 c0                	test   %eax,%eax
 4bd:	0f 84 89 00 00 00    	je     54c <printf+0x168>
        while(*s != 0){
 4c3:	8a 10                	mov    (%eax),%dl
 4c5:	84 d2                	test   %dl,%dl
 4c7:	74 29                	je     4f2 <printf+0x10e>
 4c9:	89 c7                	mov    %eax,%edi
 4cb:	88 d0                	mov    %dl,%al
 4cd:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4d0:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4d3:	89 fb                	mov    %edi,%ebx
 4d5:	89 cf                	mov    %ecx,%edi
 4d7:	90                   	nop
          putc(fd, *s);
 4d8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4db:	50                   	push   %eax
 4dc:	6a 01                	push   $0x1
 4de:	57                   	push   %edi
 4df:	56                   	push   %esi
 4e0:	e8 da fd ff ff       	call   2bf <write>
          s++;
 4e5:	43                   	inc    %ebx
        while(*s != 0){
 4e6:	8a 03                	mov    (%ebx),%al
 4e8:	83 c4 10             	add    $0x10,%esp
 4eb:	84 c0                	test   %al,%al
 4ed:	75 e9                	jne    4d8 <printf+0xf4>
 4ef:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4f2:	83 c3 02             	add    $0x2,%ebx
 4f5:	8a 43 ff             	mov    -0x1(%ebx),%al
 4f8:	84 c0                	test   %al,%al
 4fa:	0f 85 00 ff ff ff    	jne    400 <printf+0x1c>
 500:	e9 1e ff ff ff       	jmp    423 <printf+0x3f>
 505:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 508:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 50b:	8b 17                	mov    (%edi),%edx
 50d:	83 ec 0c             	sub    $0xc,%esp
 510:	6a 01                	push   $0x1
 512:	b9 0a 00 00 00       	mov    $0xa,%ecx
 517:	eb 86                	jmp    49f <printf+0xbb>
 519:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 51c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 51f:	8b 00                	mov    (%eax),%eax
 521:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 524:	51                   	push   %ecx
 525:	6a 01                	push   $0x1
 527:	8d 7d e7             	lea    -0x19(%ebp),%edi
 52a:	57                   	push   %edi
 52b:	56                   	push   %esi
 52c:	e8 8e fd ff ff       	call   2bf <write>
        ap++;
 531:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 535:	e9 3c ff ff ff       	jmp    476 <printf+0x92>
 53a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 53c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 53f:	52                   	push   %edx
 540:	6a 01                	push   $0x1
 542:	8d 7d e7             	lea    -0x19(%ebp),%edi
 545:	e9 25 ff ff ff       	jmp    46f <printf+0x8b>
 54a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 54c:	bf fb 06 00 00       	mov    $0x6fb,%edi
 551:	b0 28                	mov    $0x28,%al
 553:	e9 75 ff ff ff       	jmp    4cd <printf+0xe9>

00000558 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	53                   	push   %ebx
 55e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 561:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 564:	a1 0c 08 00 00       	mov    0x80c,%eax
 569:	8d 76 00             	lea    0x0(%esi),%esi
 56c:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56e:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 570:	39 ca                	cmp    %ecx,%edx
 572:	73 2c                	jae    5a0 <free+0x48>
 574:	39 c1                	cmp    %eax,%ecx
 576:	72 04                	jb     57c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 578:	39 c2                	cmp    %eax,%edx
 57a:	72 f0                	jb     56c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 57c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 582:	39 f8                	cmp    %edi,%eax
 584:	74 2c                	je     5b2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 586:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 589:	8b 42 04             	mov    0x4(%edx),%eax
 58c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 58f:	39 f1                	cmp    %esi,%ecx
 591:	74 36                	je     5c9 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 593:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 595:	89 15 0c 08 00 00    	mov    %edx,0x80c
}
 59b:	5b                   	pop    %ebx
 59c:	5e                   	pop    %esi
 59d:	5f                   	pop    %edi
 59e:	5d                   	pop    %ebp
 59f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a0:	39 c2                	cmp    %eax,%edx
 5a2:	72 c8                	jb     56c <free+0x14>
 5a4:	39 c1                	cmp    %eax,%ecx
 5a6:	73 c4                	jae    56c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ae:	39 f8                	cmp    %edi,%eax
 5b0:	75 d4                	jne    586 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5b2:	03 70 04             	add    0x4(%eax),%esi
 5b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b8:	8b 02                	mov    (%edx),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5bf:	8b 42 04             	mov    0x4(%edx),%eax
 5c2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5c5:	39 f1                	cmp    %esi,%ecx
 5c7:	75 ca                	jne    593 <free+0x3b>
    p->s.size += bp->s.size;
 5c9:	03 43 fc             	add    -0x4(%ebx),%eax
 5cc:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5cf:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5d2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5d4:	89 15 0c 08 00 00    	mov    %edx,0x80c
}
 5da:	5b                   	pop    %ebx
 5db:	5e                   	pop    %esi
 5dc:	5f                   	pop    %edi
 5dd:	5d                   	pop    %ebp
 5de:	c3                   	ret
 5df:	90                   	nop

000005e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	8d 78 07             	lea    0x7(%eax),%edi
 5ef:	c1 ef 03             	shr    $0x3,%edi
 5f2:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5f3:	8b 15 0c 08 00 00    	mov    0x80c,%edx
 5f9:	85 d2                	test   %edx,%edx
 5fb:	0f 84 93 00 00 00    	je     694 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 601:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 603:	8b 48 04             	mov    0x4(%eax),%ecx
 606:	39 f9                	cmp    %edi,%ecx
 608:	73 62                	jae    66c <malloc+0x8c>
  if(nu < 4096)
 60a:	89 fb                	mov    %edi,%ebx
 60c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 612:	72 78                	jb     68c <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 614:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 61b:	eb 0e                	jmp    62b <malloc+0x4b>
 61d:	8d 76 00             	lea    0x0(%esi),%esi
 620:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 622:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 624:	8b 48 04             	mov    0x4(%eax),%ecx
 627:	39 f9                	cmp    %edi,%ecx
 629:	73 41                	jae    66c <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 62b:	39 05 0c 08 00 00    	cmp    %eax,0x80c
 631:	75 ed                	jne    620 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 633:	83 ec 0c             	sub    $0xc,%esp
 636:	56                   	push   %esi
 637:	e8 eb fc ff ff       	call   327 <sbrk>
  if(p == (char*)-1)
 63c:	83 c4 10             	add    $0x10,%esp
 63f:	83 f8 ff             	cmp    $0xffffffff,%eax
 642:	74 1c                	je     660 <malloc+0x80>
  hp->s.size = nu;
 644:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 647:	83 ec 0c             	sub    $0xc,%esp
 64a:	83 c0 08             	add    $0x8,%eax
 64d:	50                   	push   %eax
 64e:	e8 05 ff ff ff       	call   558 <free>
  return freep;
 653:	8b 15 0c 08 00 00    	mov    0x80c,%edx
      if((p = morecore(nunits)) == 0)
 659:	83 c4 10             	add    $0x10,%esp
 65c:	85 d2                	test   %edx,%edx
 65e:	75 c2                	jne    622 <malloc+0x42>
        return 0;
 660:	31 c0                	xor    %eax,%eax
  }
}
 662:	8d 65 f4             	lea    -0xc(%ebp),%esp
 665:	5b                   	pop    %ebx
 666:	5e                   	pop    %esi
 667:	5f                   	pop    %edi
 668:	5d                   	pop    %ebp
 669:	c3                   	ret
 66a:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 66c:	39 cf                	cmp    %ecx,%edi
 66e:	74 4c                	je     6bc <malloc+0xdc>
        p->s.size -= nunits;
 670:	29 f9                	sub    %edi,%ecx
 672:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 675:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 678:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 67b:	89 15 0c 08 00 00    	mov    %edx,0x80c
      return (void*)(p + 1);
 681:	83 c0 08             	add    $0x8,%eax
}
 684:	8d 65 f4             	lea    -0xc(%ebp),%esp
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret
  if(nu < 4096)
 68c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 691:	eb 81                	jmp    614 <malloc+0x34>
 693:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 694:	c7 05 0c 08 00 00 10 	movl   $0x810,0x80c
 69b:	08 00 00 
 69e:	c7 05 10 08 00 00 10 	movl   $0x810,0x810
 6a5:	08 00 00 
    base.s.size = 0;
 6a8:	c7 05 14 08 00 00 00 	movl   $0x0,0x814
 6af:	00 00 00 
 6b2:	b8 10 08 00 00       	mov    $0x810,%eax
 6b7:	e9 4e ff ff ff       	jmp    60a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6bc:	8b 08                	mov    (%eax),%ecx
 6be:	89 0a                	mov    %ecx,(%edx)
 6c0:	eb b9                	jmp    67b <malloc+0x9b>
