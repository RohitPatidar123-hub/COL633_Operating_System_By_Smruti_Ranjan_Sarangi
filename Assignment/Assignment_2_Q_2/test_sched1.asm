
_test_sched1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#define NUM_PROCS 3 // Number of processes to create


int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
       
            for (int i = 0; i < NUM_PROCS; i++) {
  12:	31 db                	xor    %ebx,%ebx
                   int pid = custom_fork(1, 50); // Start later, execution time 50
  14:	83 ec 08             	sub    $0x8,%esp
  17:	6a 32                	push   $0x32
  19:	6a 01                	push   $0x1
  1b:	e8 13 03 00 00       	call   333 <custom_fork>
                   if (pid < 0) {
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	78 58                	js     7f <main+0x7f>
                           printf(1, "Failed to fork process %d\n", i);
                           exit();
                    } else if (pid == 0) {
  27:	74 69                	je     92 <main+0x92>
            for (int i = 0; i < NUM_PROCS; i++) {
  29:	43                   	inc    %ebx
  2a:	83 fb 03             	cmp    $0x3,%ebx
  2d:	75 e5                	jne    14 <main+0x14>
                            printf(1, "Child %d (PID: %d) started but should not run yet.\n", i, getpid());
                            for (volatile int j = 0; j < 100000000; j++); // Simulated work
                            exit();
                           }
                    }
            printf(1, "All child processes created with start_later flag set.\n");
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	68 08 07 00 00       	push   $0x708
  37:	6a 01                	push   $0x1
  39:	e8 92 03 00 00       	call   3d0 <printf>
                        sleep(400);
  3e:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
  45:	e8 d9 02 00 00       	call   323 <sleep>
            printf(1, "Calling sys_scheduler_start() to allow execution.\n");
  4a:	58                   	pop    %eax
  4b:	5a                   	pop    %edx
  4c:	68 40 07 00 00       	push   $0x740
  51:	6a 01                	push   $0x1
  53:	e8 78 03 00 00       	call   3d0 <printf>
            scheduler_start();
  58:	e8 de 02 00 00       	call   33b <scheduler_start>
            for (int i = 0; i < NUM_PROCS; i++) {
                         wait();
  5d:	e8 39 02 00 00       	call   29b <wait>
  62:	e8 34 02 00 00       	call   29b <wait>
  67:	e8 2f 02 00 00       	call   29b <wait>
            }
            printf(1, "All child processes completed.\n");
  6c:	59                   	pop    %ecx
  6d:	5b                   	pop    %ebx
  6e:	68 74 07 00 00       	push   $0x774
  73:	6a 01                	push   $0x1
  75:	e8 56 03 00 00       	call   3d0 <printf>
            exit();
  7a:	e8 14 02 00 00       	call   293 <exit>
                           printf(1, "Failed to fork process %d\n", i);
  7f:	50                   	push   %eax
  80:	53                   	push   %ebx
  81:	68 b0 06 00 00       	push   $0x6b0
  86:	6a 01                	push   $0x1
  88:	e8 43 03 00 00       	call   3d0 <printf>
                           exit();
  8d:	e8 01 02 00 00       	call   293 <exit>
                            printf(1, "Child %d (PID: %d) started but should not run yet.\n", i, getpid());
  92:	e8 7c 02 00 00       	call   313 <getpid>
  97:	50                   	push   %eax
  98:	53                   	push   %ebx
  99:	68 d4 06 00 00       	push   $0x6d4
  9e:	6a 01                	push   $0x1
  a0:	e8 2b 03 00 00       	call   3d0 <printf>
                            for (volatile int j = 0; j < 100000000; j++); // Simulated work
  a5:	31 c0                	xor    %eax,%eax
  a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ad:	83 c4 10             	add    $0x10,%esp
  b0:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  b5:	7f 12                	jg     c9 <main+0xc9>
  b7:	90                   	nop
  b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bb:	40                   	inc    %eax
  bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c2:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  c7:	7e ef                	jle    b8 <main+0xb8>
                            exit();
  c9:	e8 c5 01 00 00       	call   293 <exit>
  ce:	66 90                	xchg   %ax,%ax

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

00000333 <custom_fork>:
SYSCALL(custom_fork)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <scheduler_start>:
SYSCALL(scheduler_start)
 33b:	b8 18 00 00 00       	mov    $0x18,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret
 343:	90                   	nop

00000344 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	56                   	push   %esi
 349:	53                   	push   %ebx
 34a:	83 ec 3c             	sub    $0x3c,%esp
 34d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 350:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 352:	8b 4d 08             	mov    0x8(%ebp),%ecx
 355:	85 c9                	test   %ecx,%ecx
 357:	74 04                	je     35d <printint+0x19>
 359:	85 d2                	test   %edx,%edx
 35b:	78 6b                	js     3c8 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 35d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 360:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 367:	31 c9                	xor    %ecx,%ecx
 369:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 36c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 36f:	31 d2                	xor    %edx,%edx
 371:	f7 f3                	div    %ebx
 373:	89 cf                	mov    %ecx,%edi
 375:	8d 49 01             	lea    0x1(%ecx),%ecx
 378:	8a 92 ec 07 00 00    	mov    0x7ec(%edx),%dl
 37e:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 382:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 385:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 388:	39 da                	cmp    %ebx,%edx
 38a:	73 e0                	jae    36c <printint+0x28>
  if(neg)
 38c:	8b 55 08             	mov    0x8(%ebp),%edx
 38f:	85 d2                	test   %edx,%edx
 391:	74 07                	je     39a <printint+0x56>
    buf[i++] = '-';
 393:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 398:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 39a:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 39d:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3a1:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3a4:	8a 07                	mov    (%edi),%al
 3a6:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3a9:	50                   	push   %eax
 3aa:	6a 01                	push   $0x1
 3ac:	56                   	push   %esi
 3ad:	ff 75 c0             	push   -0x40(%ebp)
 3b0:	e8 fe fe ff ff       	call   2b3 <write>
  while(--i >= 0)
 3b5:	89 f8                	mov    %edi,%eax
 3b7:	4f                   	dec    %edi
 3b8:	83 c4 10             	add    $0x10,%esp
 3bb:	39 d8                	cmp    %ebx,%eax
 3bd:	75 e5                	jne    3a4 <printint+0x60>
}
 3bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c2:	5b                   	pop    %ebx
 3c3:	5e                   	pop    %esi
 3c4:	5f                   	pop    %edi
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret
 3c7:	90                   	nop
    x = -xx;
 3c8:	f7 da                	neg    %edx
 3ca:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3cd:	eb 98                	jmp    367 <printint+0x23>
 3cf:	90                   	nop

000003d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 2c             	sub    $0x2c,%esp
 3d9:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3df:	8a 03                	mov    (%ebx),%al
 3e1:	84 c0                	test   %al,%al
 3e3:	74 2a                	je     40f <printf+0x3f>
 3e5:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3e6:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3ec:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3ef:	83 fa 25             	cmp    $0x25,%edx
 3f2:	74 24                	je     418 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3f4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3f7:	50                   	push   %eax
 3f8:	6a 01                	push   $0x1
 3fa:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3fd:	50                   	push   %eax
 3fe:	56                   	push   %esi
 3ff:	e8 af fe ff ff       	call   2b3 <write>
  for(i = 0; fmt[i]; i++){
 404:	43                   	inc    %ebx
 405:	8a 43 ff             	mov    -0x1(%ebx),%al
 408:	83 c4 10             	add    $0x10,%esp
 40b:	84 c0                	test   %al,%al
 40d:	75 dd                	jne    3ec <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 40f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 412:	5b                   	pop    %ebx
 413:	5e                   	pop    %esi
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret
 417:	90                   	nop
  for(i = 0; fmt[i]; i++){
 418:	8a 13                	mov    (%ebx),%dl
 41a:	84 d2                	test   %dl,%dl
 41c:	74 f1                	je     40f <printf+0x3f>
    c = fmt[i] & 0xff;
 41e:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 421:	80 fa 25             	cmp    $0x25,%dl
 424:	0f 84 fe 00 00 00    	je     528 <printf+0x158>
 42a:	83 e8 63             	sub    $0x63,%eax
 42d:	83 f8 15             	cmp    $0x15,%eax
 430:	77 0a                	ja     43c <printf+0x6c>
 432:	ff 24 85 94 07 00 00 	jmp    *0x794(,%eax,4)
 439:	8d 76 00             	lea    0x0(%esi),%esi
 43c:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 43f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 443:	50                   	push   %eax
 444:	6a 01                	push   $0x1
 446:	8d 7d e7             	lea    -0x19(%ebp),%edi
 449:	57                   	push   %edi
 44a:	56                   	push   %esi
 44b:	e8 63 fe ff ff       	call   2b3 <write>
        putc(fd, c);
 450:	8a 55 d0             	mov    -0x30(%ebp),%dl
 453:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 456:	83 c4 0c             	add    $0xc,%esp
 459:	6a 01                	push   $0x1
 45b:	57                   	push   %edi
 45c:	56                   	push   %esi
 45d:	e8 51 fe ff ff       	call   2b3 <write>
  for(i = 0; fmt[i]; i++){
 462:	83 c3 02             	add    $0x2,%ebx
 465:	8a 43 ff             	mov    -0x1(%ebx),%al
 468:	83 c4 10             	add    $0x10,%esp
 46b:	84 c0                	test   %al,%al
 46d:	0f 85 79 ff ff ff    	jne    3ec <printf+0x1c>
}
 473:	8d 65 f4             	lea    -0xc(%ebp),%esp
 476:	5b                   	pop    %ebx
 477:	5e                   	pop    %esi
 478:	5f                   	pop    %edi
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret
 47b:	90                   	nop
        printint(fd, *ap, 16, 0);
 47c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 47f:	8b 17                	mov    (%edi),%edx
 481:	83 ec 0c             	sub    $0xc,%esp
 484:	6a 00                	push   $0x0
 486:	b9 10 00 00 00       	mov    $0x10,%ecx
 48b:	89 f0                	mov    %esi,%eax
 48d:	e8 b2 fe ff ff       	call   344 <printint>
        ap++;
 492:	83 c7 04             	add    $0x4,%edi
 495:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 498:	eb c8                	jmp    462 <printf+0x92>
 49a:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 49c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 49f:	8b 01                	mov    (%ecx),%eax
        ap++;
 4a1:	83 c1 04             	add    $0x4,%ecx
 4a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4a7:	85 c0                	test   %eax,%eax
 4a9:	0f 84 89 00 00 00    	je     538 <printf+0x168>
        while(*s != 0){
 4af:	8a 10                	mov    (%eax),%dl
 4b1:	84 d2                	test   %dl,%dl
 4b3:	74 29                	je     4de <printf+0x10e>
 4b5:	89 c7                	mov    %eax,%edi
 4b7:	88 d0                	mov    %dl,%al
 4b9:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4bc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4bf:	89 fb                	mov    %edi,%ebx
 4c1:	89 cf                	mov    %ecx,%edi
 4c3:	90                   	nop
          putc(fd, *s);
 4c4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4c7:	50                   	push   %eax
 4c8:	6a 01                	push   $0x1
 4ca:	57                   	push   %edi
 4cb:	56                   	push   %esi
 4cc:	e8 e2 fd ff ff       	call   2b3 <write>
          s++;
 4d1:	43                   	inc    %ebx
        while(*s != 0){
 4d2:	8a 03                	mov    (%ebx),%al
 4d4:	83 c4 10             	add    $0x10,%esp
 4d7:	84 c0                	test   %al,%al
 4d9:	75 e9                	jne    4c4 <printf+0xf4>
 4db:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4de:	83 c3 02             	add    $0x2,%ebx
 4e1:	8a 43 ff             	mov    -0x1(%ebx),%al
 4e4:	84 c0                	test   %al,%al
 4e6:	0f 85 00 ff ff ff    	jne    3ec <printf+0x1c>
 4ec:	e9 1e ff ff ff       	jmp    40f <printf+0x3f>
 4f1:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4f4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f7:	8b 17                	mov    (%edi),%edx
 4f9:	83 ec 0c             	sub    $0xc,%esp
 4fc:	6a 01                	push   $0x1
 4fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
 503:	eb 86                	jmp    48b <printf+0xbb>
 505:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 50b:	8b 00                	mov    (%eax),%eax
 50d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 510:	51                   	push   %ecx
 511:	6a 01                	push   $0x1
 513:	8d 7d e7             	lea    -0x19(%ebp),%edi
 516:	57                   	push   %edi
 517:	56                   	push   %esi
 518:	e8 96 fd ff ff       	call   2b3 <write>
        ap++;
 51d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 521:	e9 3c ff ff ff       	jmp    462 <printf+0x92>
 526:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 528:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 52b:	52                   	push   %edx
 52c:	6a 01                	push   $0x1
 52e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 531:	e9 25 ff ff ff       	jmp    45b <printf+0x8b>
 536:	66 90                	xchg   %ax,%ax
          s = "(null)";
 538:	bf cb 06 00 00       	mov    $0x6cb,%edi
 53d:	b0 28                	mov    $0x28,%al
 53f:	e9 75 ff ff ff       	jmp    4b9 <printf+0xe9>

00000544 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	57                   	push   %edi
 548:	56                   	push   %esi
 549:	53                   	push   %ebx
 54a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 550:	a1 00 08 00 00       	mov    0x800,%eax
 555:	8d 76 00             	lea    0x0(%esi),%esi
 558:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55c:	39 ca                	cmp    %ecx,%edx
 55e:	73 2c                	jae    58c <free+0x48>
 560:	39 c1                	cmp    %eax,%ecx
 562:	72 04                	jb     568 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 564:	39 c2                	cmp    %eax,%edx
 566:	72 f0                	jb     558 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 568:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56e:	39 f8                	cmp    %edi,%eax
 570:	74 2c                	je     59e <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 572:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 575:	8b 42 04             	mov    0x4(%edx),%eax
 578:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 57b:	39 f1                	cmp    %esi,%ecx
 57d:	74 36                	je     5b5 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 57f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 581:	89 15 00 08 00 00    	mov    %edx,0x800
}
 587:	5b                   	pop    %ebx
 588:	5e                   	pop    %esi
 589:	5f                   	pop    %edi
 58a:	5d                   	pop    %ebp
 58b:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58c:	39 c2                	cmp    %eax,%edx
 58e:	72 c8                	jb     558 <free+0x14>
 590:	39 c1                	cmp    %eax,%ecx
 592:	73 c4                	jae    558 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 594:	8b 73 fc             	mov    -0x4(%ebx),%esi
 597:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59a:	39 f8                	cmp    %edi,%eax
 59c:	75 d4                	jne    572 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 59e:	03 70 04             	add    0x4(%eax),%esi
 5a1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a4:	8b 02                	mov    (%edx),%eax
 5a6:	8b 00                	mov    (%eax),%eax
 5a8:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ab:	8b 42 04             	mov    0x4(%edx),%eax
 5ae:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5b1:	39 f1                	cmp    %esi,%ecx
 5b3:	75 ca                	jne    57f <free+0x3b>
    p->s.size += bp->s.size;
 5b5:	03 43 fc             	add    -0x4(%ebx),%eax
 5b8:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5bb:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5be:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5c0:	89 15 00 08 00 00    	mov    %edx,0x800
}
 5c6:	5b                   	pop    %ebx
 5c7:	5e                   	pop    %esi
 5c8:	5f                   	pop    %edi
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret
 5cb:	90                   	nop

000005cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	57                   	push   %edi
 5d0:	56                   	push   %esi
 5d1:	53                   	push   %ebx
 5d2:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	8d 78 07             	lea    0x7(%eax),%edi
 5db:	c1 ef 03             	shr    $0x3,%edi
 5de:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5df:	8b 15 00 08 00 00    	mov    0x800,%edx
 5e5:	85 d2                	test   %edx,%edx
 5e7:	0f 84 93 00 00 00    	je     680 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ed:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ef:	8b 48 04             	mov    0x4(%eax),%ecx
 5f2:	39 f9                	cmp    %edi,%ecx
 5f4:	73 62                	jae    658 <malloc+0x8c>
  if(nu < 4096)
 5f6:	89 fb                	mov    %edi,%ebx
 5f8:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5fe:	72 78                	jb     678 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 600:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 607:	eb 0e                	jmp    617 <malloc+0x4b>
 609:	8d 76 00             	lea    0x0(%esi),%esi
 60c:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 610:	8b 48 04             	mov    0x4(%eax),%ecx
 613:	39 f9                	cmp    %edi,%ecx
 615:	73 41                	jae    658 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 617:	39 05 00 08 00 00    	cmp    %eax,0x800
 61d:	75 ed                	jne    60c <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 61f:	83 ec 0c             	sub    $0xc,%esp
 622:	56                   	push   %esi
 623:	e8 f3 fc ff ff       	call   31b <sbrk>
  if(p == (char*)-1)
 628:	83 c4 10             	add    $0x10,%esp
 62b:	83 f8 ff             	cmp    $0xffffffff,%eax
 62e:	74 1c                	je     64c <malloc+0x80>
  hp->s.size = nu;
 630:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 633:	83 ec 0c             	sub    $0xc,%esp
 636:	83 c0 08             	add    $0x8,%eax
 639:	50                   	push   %eax
 63a:	e8 05 ff ff ff       	call   544 <free>
  return freep;
 63f:	8b 15 00 08 00 00    	mov    0x800,%edx
      if((p = morecore(nunits)) == 0)
 645:	83 c4 10             	add    $0x10,%esp
 648:	85 d2                	test   %edx,%edx
 64a:	75 c2                	jne    60e <malloc+0x42>
        return 0;
 64c:	31 c0                	xor    %eax,%eax
  }
}
 64e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 651:	5b                   	pop    %ebx
 652:	5e                   	pop    %esi
 653:	5f                   	pop    %edi
 654:	5d                   	pop    %ebp
 655:	c3                   	ret
 656:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 658:	39 cf                	cmp    %ecx,%edi
 65a:	74 4c                	je     6a8 <malloc+0xdc>
        p->s.size -= nunits;
 65c:	29 f9                	sub    %edi,%ecx
 65e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 661:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 664:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 667:	89 15 00 08 00 00    	mov    %edx,0x800
      return (void*)(p + 1);
 66d:	83 c0 08             	add    $0x8,%eax
}
 670:	8d 65 f4             	lea    -0xc(%ebp),%esp
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret
  if(nu < 4096)
 678:	bb 00 10 00 00       	mov    $0x1000,%ebx
 67d:	eb 81                	jmp    600 <malloc+0x34>
 67f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 680:	c7 05 00 08 00 00 04 	movl   $0x804,0x800
 687:	08 00 00 
 68a:	c7 05 04 08 00 00 04 	movl   $0x804,0x804
 691:	08 00 00 
    base.s.size = 0;
 694:	c7 05 08 08 00 00 00 	movl   $0x0,0x808
 69b:	00 00 00 
 69e:	b8 04 08 00 00       	mov    $0x804,%eax
 6a3:	e9 4e ff ff ff       	jmp    5f6 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6a8:	8b 08                	mov    (%eax),%ecx
 6aa:	89 0a                	mov    %ecx,(%edx)
 6ac:	eb b9                	jmp    667 <malloc+0x9b>
