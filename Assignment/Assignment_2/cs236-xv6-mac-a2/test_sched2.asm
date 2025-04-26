
_test_sched2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

#define NUM_PROCS 3  // Number of processes to create

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 1c             	sub    $0x1c,%esp
    // int pids[NUM_PROCS];

    // Create child processes using custom_fork with start_later = 1
    for (int i = 0; i < NUM_PROCS; i++) {
  13:	31 db                	xor    %ebx,%ebx
        int t = i+1;
  15:	89 de                	mov    %ebx,%esi
  17:	43                   	inc    %ebx
        int pid = custom_fork(1, 50); // Start later, execution time 50
  18:	83 ec 08             	sub    $0x8,%esp
  1b:	6a 32                	push   $0x32
  1d:	6a 01                	push   $0x1
  1f:	e8 3f 03 00 00       	call   363 <custom_fork>
        if (pid < 0) {
  24:	83 c4 10             	add    $0x10,%esp
  27:	85 c0                	test   %eax,%eax
  29:	78 4b                	js     76 <main+0x76>
            printf(1, "Failed to fork process %d\n", i);
            exit();
        } else if (pid == 0) {
  2b:	74 5c                	je     89 <main+0x89>
    for (int i = 0; i < NUM_PROCS; i++) {
  2d:	83 fb 03             	cmp    $0x3,%ebx
  30:	75 e3                	jne    15 <main+0x15>
            // pids[i] = pid;

        }
    }

    printf(1, "All child processes created with start_later flag set.\n");
  32:	83 ec 08             	sub    $0x8,%esp
  35:	68 54 07 00 00       	push   $0x754
  3a:	6a 01                	push   $0x1
  3c:	e8 bf 03 00 00       	call   400 <printf>
    // sleep(400);

    // Start scheduling these processes
    printf(1, "Calling sys_scheduler_start() to allow execution.\n");
  41:	58                   	pop    %eax
  42:	5a                   	pop    %edx
  43:	68 8c 07 00 00       	push   $0x78c
  48:	6a 01                	push   $0x1
  4a:	e8 b1 03 00 00       	call   400 <printf>
    scheduler_start();
  4f:	e8 17 03 00 00       	call   36b <scheduler_start>

    // Wait for children to finish
    for (int i = 0; i < NUM_PROCS; i++) {
        wait();
  54:	e8 6a 02 00 00       	call   2c3 <wait>
  59:	e8 65 02 00 00       	call   2c3 <wait>
  5e:	e8 60 02 00 00       	call   2c3 <wait>

    }

    printf(1, "All child processes completed.\n");
  63:	59                   	pop    %ecx
  64:	5b                   	pop    %ebx
  65:	68 c0 07 00 00       	push   $0x7c0
  6a:	6a 01                	push   $0x1
  6c:	e8 8f 03 00 00       	call   400 <printf>
    exit();
  71:	e8 45 02 00 00       	call   2bb <exit>
            printf(1, "Failed to fork process %d\n", i);
  76:	50                   	push   %eax
  77:	56                   	push   %esi
  78:	68 e0 06 00 00       	push   $0x6e0
  7d:	6a 01                	push   $0x1
  7f:	e8 7c 03 00 00       	call   400 <printf>
            exit();
  84:	e8 32 02 00 00       	call   2bb <exit>
            sleep(100 *t);
  89:	83 ec 0c             	sub    $0xc,%esp
  8c:	6b c3 64             	imul   $0x64,%ebx,%eax
  8f:	50                   	push   %eax
  90:	e8 b6 02 00 00       	call   34b <sleep>
            for (volatile int j = 0; j < 100000000; j++);
  95:	31 c0                	xor    %eax,%eax
  97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9d:	83 c4 10             	add    $0x10,%esp
  a0:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  a5:	7f 12                	jg     b9 <main+0xb9>
  a7:	90                   	nop
  a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ab:	40                   	inc    %eax
  ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b2:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  b7:	7e ef                	jle    a8 <main+0xa8>
            printf(1, "Child %d (PID: %d) started but should not run yet.\n", i, getpid());
  b9:	e8 7d 02 00 00       	call   33b <getpid>
  be:	50                   	push   %eax
  bf:	56                   	push   %esi
  c0:	68 20 07 00 00       	push   $0x720
  c5:	6a 01                	push   $0x1
  c7:	e8 34 03 00 00       	call   400 <printf>
            sleep(200 *t);
  cc:	69 db c8 00 00 00    	imul   $0xc8,%ebx,%ebx
  d2:	89 1c 24             	mov    %ebx,(%esp)
  d5:	e8 71 02 00 00       	call   34b <sleep>
            printf(1, "Child %d (PID: %d) exiting.\n", i, getpid());
  da:	e8 5c 02 00 00       	call   33b <getpid>
  df:	50                   	push   %eax
  e0:	56                   	push   %esi
  e1:	68 fb 06 00 00       	push   $0x6fb
  e6:	6a 01                	push   $0x1
  e8:	e8 13 03 00 00       	call   400 <printf>
            exit();
  ed:	83 c4 20             	add    $0x20,%esp
  f0:	e8 c6 01 00 00       	call   2bb <exit>
  f5:	66 90                	xchg   %ax,%ax
  f7:	90                   	nop

000000f8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	31 c0                	xor    %eax,%eax
 104:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 107:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 10a:	40                   	inc    %eax
 10b:	84 d2                	test   %dl,%dl
 10d:	75 f5                	jne    104 <strcpy+0xc>
    ;
  return os;
}
 10f:	89 c8                	mov    %ecx,%eax
 111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 114:	c9                   	leave
 115:	c3                   	ret
 116:	66 90                	xchg   %ax,%ax

00000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	53                   	push   %ebx
 11c:	8b 55 08             	mov    0x8(%ebp),%edx
 11f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 122:	0f b6 02             	movzbl (%edx),%eax
 125:	84 c0                	test   %al,%al
 127:	75 10                	jne    139 <strcmp+0x21>
 129:	eb 2a                	jmp    155 <strcmp+0x3d>
 12b:	90                   	nop
    p++, q++;
 12c:	42                   	inc    %edx
 12d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 130:	0f b6 02             	movzbl (%edx),%eax
 133:	84 c0                	test   %al,%al
 135:	74 11                	je     148 <strcmp+0x30>
 137:	89 cb                	mov    %ecx,%ebx
 139:	0f b6 0b             	movzbl (%ebx),%ecx
 13c:	38 c1                	cmp    %al,%cl
 13e:	74 ec                	je     12c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 140:	29 c8                	sub    %ecx,%eax
}
 142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 145:	c9                   	leave
 146:	c3                   	ret
 147:	90                   	nop
  return (uchar)*p - (uchar)*q;
 148:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 14c:	31 c0                	xor    %eax,%eax
 14e:	29 c8                	sub    %ecx,%eax
}
 150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 153:	c9                   	leave
 154:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 155:	0f b6 0b             	movzbl (%ebx),%ecx
 158:	31 c0                	xor    %eax,%eax
 15a:	eb e4                	jmp    140 <strcmp+0x28>

0000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 162:	80 3a 00             	cmpb   $0x0,(%edx)
 165:	74 15                	je     17c <strlen+0x20>
 167:	31 c0                	xor    %eax,%eax
 169:	8d 76 00             	lea    0x0(%esi),%esi
 16c:	40                   	inc    %eax
 16d:	89 c1                	mov    %eax,%ecx
 16f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 173:	75 f7                	jne    16c <strlen+0x10>
    ;
  return n;
}
 175:	89 c8                	mov    %ecx,%eax
 177:	5d                   	pop    %ebp
 178:	c3                   	ret
 179:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 17c:	31 c9                	xor    %ecx,%ecx
}
 17e:	89 c8                	mov    %ecx,%eax
 180:	5d                   	pop    %ebp
 181:	c3                   	ret
 182:	66 90                	xchg   %ax,%ax

00000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 188:	8b 7d 08             	mov    0x8(%ebp),%edi
 18b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	fc                   	cld
 192:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	8b 7d fc             	mov    -0x4(%ebp),%edi
 19a:	c9                   	leave
 19b:	c3                   	ret

0000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1a5:	8a 10                	mov    (%eax),%dl
 1a7:	84 d2                	test   %dl,%dl
 1a9:	75 0c                	jne    1b7 <strchr+0x1b>
 1ab:	eb 13                	jmp    1c0 <strchr+0x24>
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	40                   	inc    %eax
 1b1:	8a 10                	mov    (%eax),%dl
 1b3:	84 d2                	test   %dl,%dl
 1b5:	74 09                	je     1c0 <strchr+0x24>
    if(*s == c)
 1b7:	38 d1                	cmp    %dl,%cl
 1b9:	75 f5                	jne    1b0 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1c0:	31 c0                	xor    %eax,%eax
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret

000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	56                   	push   %esi
 1c9:	53                   	push   %ebx
 1ca:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cd:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1cf:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1d2:	eb 24                	jmp    1f8 <gets+0x34>
    cc = read(0, &c, 1);
 1d4:	50                   	push   %eax
 1d5:	6a 01                	push   $0x1
 1d7:	56                   	push   %esi
 1d8:	6a 00                	push   $0x0
 1da:	e8 f4 00 00 00       	call   2d3 <read>
    if(cc < 1)
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	7e 1a                	jle    200 <gets+0x3c>
      break;
    buf[i++] = c;
 1e6:	8a 45 e7             	mov    -0x19(%ebp),%al
 1e9:	8b 55 08             	mov    0x8(%ebp),%edx
 1ec:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1f0:	3c 0a                	cmp    $0xa,%al
 1f2:	74 0e                	je     202 <gets+0x3e>
 1f4:	3c 0d                	cmp    $0xd,%al
 1f6:	74 0a                	je     202 <gets+0x3e>
  for(i=0; i+1 < max; ){
 1f8:	89 df                	mov    %ebx,%edi
 1fa:	43                   	inc    %ebx
 1fb:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1fe:	7c d4                	jl     1d4 <gets+0x10>
 200:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 209:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5f                   	pop    %edi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret
 211:	8d 76 00             	lea    0x0(%esi),%esi

00000214 <stat>:

int
stat(const char *n, struct stat *st)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	56                   	push   %esi
 218:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	6a 00                	push   $0x0
 21e:	ff 75 08             	push   0x8(%ebp)
 221:	e8 d5 00 00 00       	call   2fb <open>
  if(fd < 0)
 226:	83 c4 10             	add    $0x10,%esp
 229:	85 c0                	test   %eax,%eax
 22b:	78 27                	js     254 <stat+0x40>
 22d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22f:	83 ec 08             	sub    $0x8,%esp
 232:	ff 75 0c             	push   0xc(%ebp)
 235:	50                   	push   %eax
 236:	e8 d8 00 00 00       	call   313 <fstat>
 23b:	89 c6                	mov    %eax,%esi
  close(fd);
 23d:	89 1c 24             	mov    %ebx,(%esp)
 240:	e8 9e 00 00 00       	call   2e3 <close>
  return r;
 245:	83 c4 10             	add    $0x10,%esp
}
 248:	89 f0                	mov    %esi,%eax
 24a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 24d:	5b                   	pop    %ebx
 24e:	5e                   	pop    %esi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret
 251:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 254:	be ff ff ff ff       	mov    $0xffffffff,%esi
 259:	eb ed                	jmp    248 <stat+0x34>
 25b:	90                   	nop

0000025c <atoi>:

int
atoi(const char *s)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	53                   	push   %ebx
 260:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 263:	0f be 01             	movsbl (%ecx),%eax
 266:	8d 50 d0             	lea    -0x30(%eax),%edx
 269:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 26c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 271:	77 16                	ja     289 <atoi+0x2d>
 273:	90                   	nop
    n = n*10 + *s++ - '0';
 274:	41                   	inc    %ecx
 275:	8d 14 92             	lea    (%edx,%edx,4),%edx
 278:	01 d2                	add    %edx,%edx
 27a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 27e:	0f be 01             	movsbl (%ecx),%eax
 281:	8d 58 d0             	lea    -0x30(%eax),%ebx
 284:	80 fb 09             	cmp    $0x9,%bl
 287:	76 eb                	jbe    274 <atoi+0x18>
  return n;
}
 289:	89 d0                	mov    %edx,%eax
 28b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 28e:	c9                   	leave
 28f:	c3                   	ret

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	56                   	push   %esi
 295:	8b 55 08             	mov    0x8(%ebp),%edx
 298:	8b 75 0c             	mov    0xc(%ebp),%esi
 29b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 0b                	jle    2ad <memmove+0x1d>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a9:	39 f8                	cmp    %edi,%eax
 2ab:	75 fb                	jne    2a8 <memmove+0x18>
  return vdst;
}
 2ad:	89 d0                	mov    %edx,%eax
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret

000002b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b3:	b8 01 00 00 00       	mov    $0x1,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <exit>:
SYSCALL(exit)
 2bb:	b8 02 00 00 00       	mov    $0x2,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <wait>:
SYSCALL(wait)
 2c3:	b8 03 00 00 00       	mov    $0x3,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <pipe>:
SYSCALL(pipe)
 2cb:	b8 04 00 00 00       	mov    $0x4,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <read>:
SYSCALL(read)
 2d3:	b8 05 00 00 00       	mov    $0x5,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <write>:
SYSCALL(write)
 2db:	b8 10 00 00 00       	mov    $0x10,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <close>:
SYSCALL(close)
 2e3:	b8 15 00 00 00       	mov    $0x15,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <kill>:
SYSCALL(kill)
 2eb:	b8 06 00 00 00       	mov    $0x6,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <exec>:
SYSCALL(exec)
 2f3:	b8 07 00 00 00       	mov    $0x7,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <open>:
SYSCALL(open)
 2fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <mknod>:
SYSCALL(mknod)
 303:	b8 11 00 00 00       	mov    $0x11,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <unlink>:
SYSCALL(unlink)
 30b:	b8 12 00 00 00       	mov    $0x12,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <fstat>:
SYSCALL(fstat)
 313:	b8 08 00 00 00       	mov    $0x8,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <link>:
SYSCALL(link)
 31b:	b8 13 00 00 00       	mov    $0x13,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <mkdir>:
SYSCALL(mkdir)
 323:	b8 14 00 00 00       	mov    $0x14,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <chdir>:
SYSCALL(chdir)
 32b:	b8 09 00 00 00       	mov    $0x9,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <dup>:
SYSCALL(dup)
 333:	b8 0a 00 00 00       	mov    $0xa,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <getpid>:
SYSCALL(getpid)
 33b:	b8 0b 00 00 00       	mov    $0xb,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <sbrk>:
SYSCALL(sbrk)
 343:	b8 0c 00 00 00       	mov    $0xc,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <sleep>:
SYSCALL(sleep)
 34b:	b8 0d 00 00 00       	mov    $0xd,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <uptime>:
SYSCALL(uptime)
 353:	b8 0e 00 00 00       	mov    $0xe,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <signal>:
SYSCALL(signal)
 35b:	b8 16 00 00 00       	mov    $0x16,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <custom_fork>:
SYSCALL(custom_fork)
 363:	b8 17 00 00 00       	mov    $0x17,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <scheduler_start>:
 36b:	b8 18 00 00 00       	mov    $0x18,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret
 373:	90                   	nop

00000374 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	56                   	push   %esi
 379:	53                   	push   %ebx
 37a:	83 ec 3c             	sub    $0x3c,%esp
 37d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 380:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 382:	8b 4d 08             	mov    0x8(%ebp),%ecx
 385:	85 c9                	test   %ecx,%ecx
 387:	74 04                	je     38d <printint+0x19>
 389:	85 d2                	test   %edx,%edx
 38b:	78 6b                	js     3f8 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 38d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 390:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 397:	31 c9                	xor    %ecx,%ecx
 399:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 39c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 39f:	31 d2                	xor    %edx,%edx
 3a1:	f7 f3                	div    %ebx
 3a3:	89 cf                	mov    %ecx,%edi
 3a5:	8d 49 01             	lea    0x1(%ecx),%ecx
 3a8:	8a 92 38 08 00 00    	mov    0x838(%edx),%dl
 3ae:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3b2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3b8:	39 da                	cmp    %ebx,%edx
 3ba:	73 e0                	jae    39c <printint+0x28>
  if(neg)
 3bc:	8b 55 08             	mov    0x8(%ebp),%edx
 3bf:	85 d2                	test   %edx,%edx
 3c1:	74 07                	je     3ca <printint+0x56>
    buf[i++] = '-';
 3c3:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3c8:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3ca:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3cd:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3d1:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3d4:	8a 07                	mov    (%edi),%al
 3d6:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3d9:	50                   	push   %eax
 3da:	6a 01                	push   $0x1
 3dc:	56                   	push   %esi
 3dd:	ff 75 c0             	push   -0x40(%ebp)
 3e0:	e8 f6 fe ff ff       	call   2db <write>
  while(--i >= 0)
 3e5:	89 f8                	mov    %edi,%eax
 3e7:	4f                   	dec    %edi
 3e8:	83 c4 10             	add    $0x10,%esp
 3eb:	39 d8                	cmp    %ebx,%eax
 3ed:	75 e5                	jne    3d4 <printint+0x60>
}
 3ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f2:	5b                   	pop    %ebx
 3f3:	5e                   	pop    %esi
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret
 3f7:	90                   	nop
    x = -xx;
 3f8:	f7 da                	neg    %edx
 3fa:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3fd:	eb 98                	jmp    397 <printint+0x23>
 3ff:	90                   	nop

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
 409:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 40c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 40f:	8a 03                	mov    (%ebx),%al
 411:	84 c0                	test   %al,%al
 413:	74 2a                	je     43f <printf+0x3f>
 415:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 416:	8d 4d 10             	lea    0x10(%ebp),%ecx
 419:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 41c:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 41f:	83 fa 25             	cmp    $0x25,%edx
 422:	74 24                	je     448 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 424:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 427:	50                   	push   %eax
 428:	6a 01                	push   $0x1
 42a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 42d:	50                   	push   %eax
 42e:	56                   	push   %esi
 42f:	e8 a7 fe ff ff       	call   2db <write>
  for(i = 0; fmt[i]; i++){
 434:	43                   	inc    %ebx
 435:	8a 43 ff             	mov    -0x1(%ebx),%al
 438:	83 c4 10             	add    $0x10,%esp
 43b:	84 c0                	test   %al,%al
 43d:	75 dd                	jne    41c <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 43f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 442:	5b                   	pop    %ebx
 443:	5e                   	pop    %esi
 444:	5f                   	pop    %edi
 445:	5d                   	pop    %ebp
 446:	c3                   	ret
 447:	90                   	nop
  for(i = 0; fmt[i]; i++){
 448:	8a 13                	mov    (%ebx),%dl
 44a:	84 d2                	test   %dl,%dl
 44c:	74 f1                	je     43f <printf+0x3f>
    c = fmt[i] & 0xff;
 44e:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 451:	80 fa 25             	cmp    $0x25,%dl
 454:	0f 84 fe 00 00 00    	je     558 <printf+0x158>
 45a:	83 e8 63             	sub    $0x63,%eax
 45d:	83 f8 15             	cmp    $0x15,%eax
 460:	77 0a                	ja     46c <printf+0x6c>
 462:	ff 24 85 e0 07 00 00 	jmp    *0x7e0(,%eax,4)
 469:	8d 76 00             	lea    0x0(%esi),%esi
 46c:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 46f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 473:	50                   	push   %eax
 474:	6a 01                	push   $0x1
 476:	8d 7d e7             	lea    -0x19(%ebp),%edi
 479:	57                   	push   %edi
 47a:	56                   	push   %esi
 47b:	e8 5b fe ff ff       	call   2db <write>
        putc(fd, c);
 480:	8a 55 d0             	mov    -0x30(%ebp),%dl
 483:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 486:	83 c4 0c             	add    $0xc,%esp
 489:	6a 01                	push   $0x1
 48b:	57                   	push   %edi
 48c:	56                   	push   %esi
 48d:	e8 49 fe ff ff       	call   2db <write>
  for(i = 0; fmt[i]; i++){
 492:	83 c3 02             	add    $0x2,%ebx
 495:	8a 43 ff             	mov    -0x1(%ebx),%al
 498:	83 c4 10             	add    $0x10,%esp
 49b:	84 c0                	test   %al,%al
 49d:	0f 85 79 ff ff ff    	jne    41c <printf+0x1c>
}
 4a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret
 4ab:	90                   	nop
        printint(fd, *ap, 16, 0);
 4ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4af:	8b 17                	mov    (%edi),%edx
 4b1:	83 ec 0c             	sub    $0xc,%esp
 4b4:	6a 00                	push   $0x0
 4b6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bb:	89 f0                	mov    %esi,%eax
 4bd:	e8 b2 fe ff ff       	call   374 <printint>
        ap++;
 4c2:	83 c7 04             	add    $0x4,%edi
 4c5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4c8:	eb c8                	jmp    492 <printf+0x92>
 4ca:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4cf:	8b 01                	mov    (%ecx),%eax
        ap++;
 4d1:	83 c1 04             	add    $0x4,%ecx
 4d4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4d7:	85 c0                	test   %eax,%eax
 4d9:	0f 84 89 00 00 00    	je     568 <printf+0x168>
        while(*s != 0){
 4df:	8a 10                	mov    (%eax),%dl
 4e1:	84 d2                	test   %dl,%dl
 4e3:	74 29                	je     50e <printf+0x10e>
 4e5:	89 c7                	mov    %eax,%edi
 4e7:	88 d0                	mov    %dl,%al
 4e9:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4ec:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4ef:	89 fb                	mov    %edi,%ebx
 4f1:	89 cf                	mov    %ecx,%edi
 4f3:	90                   	nop
          putc(fd, *s);
 4f4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4f7:	50                   	push   %eax
 4f8:	6a 01                	push   $0x1
 4fa:	57                   	push   %edi
 4fb:	56                   	push   %esi
 4fc:	e8 da fd ff ff       	call   2db <write>
          s++;
 501:	43                   	inc    %ebx
        while(*s != 0){
 502:	8a 03                	mov    (%ebx),%al
 504:	83 c4 10             	add    $0x10,%esp
 507:	84 c0                	test   %al,%al
 509:	75 e9                	jne    4f4 <printf+0xf4>
 50b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 50e:	83 c3 02             	add    $0x2,%ebx
 511:	8a 43 ff             	mov    -0x1(%ebx),%al
 514:	84 c0                	test   %al,%al
 516:	0f 85 00 ff ff ff    	jne    41c <printf+0x1c>
 51c:	e9 1e ff ff ff       	jmp    43f <printf+0x3f>
 521:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 524:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 527:	8b 17                	mov    (%edi),%edx
 529:	83 ec 0c             	sub    $0xc,%esp
 52c:	6a 01                	push   $0x1
 52e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 533:	eb 86                	jmp    4bb <printf+0xbb>
 535:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 53b:	8b 00                	mov    (%eax),%eax
 53d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 540:	51                   	push   %ecx
 541:	6a 01                	push   $0x1
 543:	8d 7d e7             	lea    -0x19(%ebp),%edi
 546:	57                   	push   %edi
 547:	56                   	push   %esi
 548:	e8 8e fd ff ff       	call   2db <write>
        ap++;
 54d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 551:	e9 3c ff ff ff       	jmp    492 <printf+0x92>
 556:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 558:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 55b:	52                   	push   %edx
 55c:	6a 01                	push   $0x1
 55e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 561:	e9 25 ff ff ff       	jmp    48b <printf+0x8b>
 566:	66 90                	xchg   %ax,%ax
          s = "(null)";
 568:	bf 18 07 00 00       	mov    $0x718,%edi
 56d:	b0 28                	mov    $0x28,%al
 56f:	e9 75 ff ff ff       	jmp    4e9 <printf+0xe9>

00000574 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	57                   	push   %edi
 578:	56                   	push   %esi
 579:	53                   	push   %ebx
 57a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 57d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 580:	a1 4c 08 00 00       	mov    0x84c,%eax
 585:	8d 76 00             	lea    0x0(%esi),%esi
 588:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 58c:	39 ca                	cmp    %ecx,%edx
 58e:	73 2c                	jae    5bc <free+0x48>
 590:	39 c1                	cmp    %eax,%ecx
 592:	72 04                	jb     598 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 594:	39 c2                	cmp    %eax,%edx
 596:	72 f0                	jb     588 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 598:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59e:	39 f8                	cmp    %edi,%eax
 5a0:	74 2c                	je     5ce <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5a5:	8b 42 04             	mov    0x4(%edx),%eax
 5a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5ab:	39 f1                	cmp    %esi,%ecx
 5ad:	74 36                	je     5e5 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5af:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5b1:	89 15 4c 08 00 00    	mov    %edx,0x84c
}
 5b7:	5b                   	pop    %ebx
 5b8:	5e                   	pop    %esi
 5b9:	5f                   	pop    %edi
 5ba:	5d                   	pop    %ebp
 5bb:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5bc:	39 c2                	cmp    %eax,%edx
 5be:	72 c8                	jb     588 <free+0x14>
 5c0:	39 c1                	cmp    %eax,%ecx
 5c2:	73 c4                	jae    588 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5c4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ca:	39 f8                	cmp    %edi,%eax
 5cc:	75 d4                	jne    5a2 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5ce:	03 70 04             	add    0x4(%eax),%esi
 5d1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d4:	8b 02                	mov    (%edx),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5db:	8b 42 04             	mov    0x4(%edx),%eax
 5de:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5e1:	39 f1                	cmp    %esi,%ecx
 5e3:	75 ca                	jne    5af <free+0x3b>
    p->s.size += bp->s.size;
 5e5:	03 43 fc             	add    -0x4(%ebx),%eax
 5e8:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5eb:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5ee:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5f0:	89 15 4c 08 00 00    	mov    %edx,0x84c
}
 5f6:	5b                   	pop    %ebx
 5f7:	5e                   	pop    %esi
 5f8:	5f                   	pop    %edi
 5f9:	5d                   	pop    %ebp
 5fa:	c3                   	ret
 5fb:	90                   	nop

000005fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	57                   	push   %edi
 600:	56                   	push   %esi
 601:	53                   	push   %ebx
 602:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	8d 78 07             	lea    0x7(%eax),%edi
 60b:	c1 ef 03             	shr    $0x3,%edi
 60e:	47                   	inc    %edi
  if((prevp = freep) == 0){
 60f:	8b 15 4c 08 00 00    	mov    0x84c,%edx
 615:	85 d2                	test   %edx,%edx
 617:	0f 84 93 00 00 00    	je     6b0 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 61f:	8b 48 04             	mov    0x4(%eax),%ecx
 622:	39 f9                	cmp    %edi,%ecx
 624:	73 62                	jae    688 <malloc+0x8c>
  if(nu < 4096)
 626:	89 fb                	mov    %edi,%ebx
 628:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 62e:	72 78                	jb     6a8 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 630:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 637:	eb 0e                	jmp    647 <malloc+0x4b>
 639:	8d 76 00             	lea    0x0(%esi),%esi
 63c:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 640:	8b 48 04             	mov    0x4(%eax),%ecx
 643:	39 f9                	cmp    %edi,%ecx
 645:	73 41                	jae    688 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 647:	39 05 4c 08 00 00    	cmp    %eax,0x84c
 64d:	75 ed                	jne    63c <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 64f:	83 ec 0c             	sub    $0xc,%esp
 652:	56                   	push   %esi
 653:	e8 eb fc ff ff       	call   343 <sbrk>
  if(p == (char*)-1)
 658:	83 c4 10             	add    $0x10,%esp
 65b:	83 f8 ff             	cmp    $0xffffffff,%eax
 65e:	74 1c                	je     67c <malloc+0x80>
  hp->s.size = nu;
 660:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	83 c0 08             	add    $0x8,%eax
 669:	50                   	push   %eax
 66a:	e8 05 ff ff ff       	call   574 <free>
  return freep;
 66f:	8b 15 4c 08 00 00    	mov    0x84c,%edx
      if((p = morecore(nunits)) == 0)
 675:	83 c4 10             	add    $0x10,%esp
 678:	85 d2                	test   %edx,%edx
 67a:	75 c2                	jne    63e <malloc+0x42>
        return 0;
 67c:	31 c0                	xor    %eax,%eax
  }
}
 67e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 681:	5b                   	pop    %ebx
 682:	5e                   	pop    %esi
 683:	5f                   	pop    %edi
 684:	5d                   	pop    %ebp
 685:	c3                   	ret
 686:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 688:	39 cf                	cmp    %ecx,%edi
 68a:	74 4c                	je     6d8 <malloc+0xdc>
        p->s.size -= nunits;
 68c:	29 f9                	sub    %edi,%ecx
 68e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 691:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 694:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 697:	89 15 4c 08 00 00    	mov    %edx,0x84c
      return (void*)(p + 1);
 69d:	83 c0 08             	add    $0x8,%eax
}
 6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a3:	5b                   	pop    %ebx
 6a4:	5e                   	pop    %esi
 6a5:	5f                   	pop    %edi
 6a6:	5d                   	pop    %ebp
 6a7:	c3                   	ret
  if(nu < 4096)
 6a8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6ad:	eb 81                	jmp    630 <malloc+0x34>
 6af:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6b0:	c7 05 4c 08 00 00 50 	movl   $0x850,0x84c
 6b7:	08 00 00 
 6ba:	c7 05 50 08 00 00 50 	movl   $0x850,0x850
 6c1:	08 00 00 
    base.s.size = 0;
 6c4:	c7 05 54 08 00 00 00 	movl   $0x0,0x854
 6cb:	00 00 00 
 6ce:	b8 50 08 00 00       	mov    $0x850,%eax
 6d3:	e9 4e ff ff ff       	jmp    626 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6d8:	8b 08                	mov    (%eax),%ecx
 6da:	89 0a                	mov    %ecx,(%edx)
 6dc:	eb b9                	jmp    697 <malloc+0x9b>
