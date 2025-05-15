
_test6:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// Child process that sleeps
void sleeping_process() {
    sleep(1000000); // Sleep for a very long time
}

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 10             	sub    $0x10,%esp
    int pids[NUM_CHILDREN];

    printf(1, "\nCtrl+I Memory Printer Test\n");
  14:	68 1c 07 00 00       	push   $0x71c
  19:	6a 01                	push   $0x1
  1b:	e8 1c 04 00 00       	call   43c <printf>
    printf(1, "Press Ctrl+I to see process memory pages\n\n");
  20:	5f                   	pop    %edi
  21:	58                   	pop    %eax
  22:	68 68 07 00 00       	push   $0x768
  27:	6a 01                	push   $0x1
  29:	e8 0e 04 00 00       	call   43c <printf>

    // Create test processes
    for(int i = 0; i < NUM_CHILDREN; i++) {
        int pid = fork();
  2e:	e8 d4 02 00 00       	call   307 <fork>
        if(pid == 0) {
  33:	83 c4 10             	add    $0x10,%esp
  36:	85 c0                	test   %eax,%eax
  38:	0f 84 e8 00 00 00    	je     126 <main+0x126>
  3e:	89 c3                	mov    %eax,%ebx
        int pid = fork();
  40:	e8 c2 02 00 00       	call   307 <fork>
  45:	89 c6                	mov    %eax,%esi
        if(pid == 0) {
  47:	85 c0                	test   %eax,%eax
  49:	75 10                	jne    5b <main+0x5b>
    sleep(1000000); // Sleep for a very long time
  4b:	83 ec 0c             	sub    $0xc,%esp
  4e:	68 40 42 0f 00       	push   $0xf4240
  53:	e8 47 03 00 00       	call   39f <sleep>
  58:	83 c4 10             	add    $0x10,%esp
        int pid = fork();
  5b:	e8 a7 02 00 00       	call   307 <fork>
  60:	89 c7                	mov    %eax,%edi
        if(pid == 0) {
  62:	85 c0                	test   %eax,%eax
  64:	0f 84 be 00 00 00    	je     128 <main+0x128>
        }
        pids[i] = pid;
    }

    // Parent process instructions
    printf(1, "Process hierarchy:\n");
  6a:	50                   	push   %eax
  6b:	50                   	push   %eax
  6c:	68 39 07 00 00       	push   $0x739
  71:	6a 01                	push   $0x1
  73:	e8 c4 03 00 00       	call   43c <printf>
    printf(1, "- Parent PID: %d\n", getpid());
  78:	e8 12 03 00 00       	call   38f <getpid>
  7d:	83 c4 0c             	add    $0xc,%esp
  80:	50                   	push   %eax
  81:	68 4d 07 00 00       	push   $0x74d
  86:	6a 01                	push   $0x1
  88:	e8 af 03 00 00       	call   43c <printf>
    printf(1, "- Children PIDs: %d (running), %d (sleeping), %d (zombie)\n\n",
  8d:	89 3c 24             	mov    %edi,(%esp)
  90:	56                   	push   %esi
  91:	53                   	push   %ebx
  92:	68 98 07 00 00       	push   $0x798
  97:	6a 01                	push   $0x1
  99:	e8 9e 03 00 00       	call   43c <printf>
          pids[0], pids[1], pids[2]);

    printf(1, "Expected Ctrl+I output should show:\n");
  9e:	83 c4 18             	add    $0x18,%esp
  a1:	68 d4 07 00 00       	push   $0x7d4
  a6:	6a 01                	push   $0x1
  a8:	e8 8f 03 00 00       	call   43c <printf>
    printf(1, "1. Init process (PID 1) with 3 pages\n");
  ad:	5a                   	pop    %edx
  ae:	59                   	pop    %ecx
  af:	68 fc 07 00 00       	push   $0x7fc
  b4:	6a 01                	push   $0x1
  b6:	e8 81 03 00 00       	call   43c <printf>
    printf(1, "2. Parent process (PID %d) with pages >3\n", getpid());
  bb:	e8 cf 02 00 00       	call   38f <getpid>
  c0:	83 c4 0c             	add    $0xc,%esp
  c3:	50                   	push   %eax
  c4:	68 24 08 00 00       	push   $0x824
  c9:	6a 01                	push   $0x1
  cb:	e8 6c 03 00 00       	call   43c <printf>
    printf(1, "3. Running child (PID %d) with pages >3\n", pids[0]);
  d0:	83 c4 0c             	add    $0xc,%esp
  d3:	53                   	push   %ebx
  d4:	68 50 08 00 00       	push   $0x850
  d9:	6a 01                	push   $0x1
  db:	e8 5c 03 00 00       	call   43c <printf>
    printf(1, "4. Sleeping child (PID %d) with pages >3\n\n", pids[1]);
  e0:	83 c4 0c             	add    $0xc,%esp
  e3:	56                   	push   %esi
  e4:	68 7c 08 00 00       	push   $0x87c
  e9:	6a 01                	push   $0x1
  eb:	e8 4c 03 00 00       	call   43c <printf>
    printf(1, "Zombie process (PID %d) should NOT appear\n\n", pids[2]);
  f0:	83 c4 0c             	add    $0xc,%esp
  f3:	57                   	push   %edi
  f4:	68 a8 08 00 00       	push   $0x8a8
  f9:	6a 01                	push   $0x1
  fb:	e8 3c 03 00 00       	call   43c <printf>

    printf(1, "Press Ctrl+I now to verify...\n");
 100:	5b                   	pop    %ebx
 101:	5e                   	pop    %esi
 102:	68 d4 08 00 00       	push   $0x8d4
 107:	6a 01                	push   $0x1
 109:	e8 2e 03 00 00       	call   43c <printf>
 10e:	83 c4 10             	add    $0x10,%esp
 111:	8d 76 00             	lea    0x0(%esi),%esi

    // Keep parent process alive
    while(1) {
        sleep(1000);
 114:	83 ec 0c             	sub    $0xc,%esp
 117:	68 e8 03 00 00       	push   $0x3e8
 11c:	e8 7e 02 00 00       	call   39f <sleep>
 121:	83 c4 10             	add    $0x10,%esp
 124:	eb ee                	jmp    114 <main+0x114>
 126:	eb fe                	jmp    126 <main+0x126>
            if(i == 2) exit();             // Will become ZOMBIE
 128:	e8 e2 01 00 00       	call   30f <exit>
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <running_process>:
    while(1) { /* Infinite loop */ }
 130:	eb fe                	jmp    130 <running_process>
 132:	66 90                	xchg   %ax,%ax

00000134 <sleeping_process>:
void sleeping_process() {
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 14             	sub    $0x14,%esp
    sleep(1000000); // Sleep for a very long time
 13a:	68 40 42 0f 00       	push   $0xf4240
 13f:	e8 5b 02 00 00       	call   39f <sleep>
}
 144:	83 c4 10             	add    $0x10,%esp
 147:	c9                   	leave
 148:	c3                   	ret
 149:	66 90                	xchg   %ax,%ax
 14b:	90                   	nop

0000014c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	53                   	push   %ebx
 150:	8b 4d 08             	mov    0x8(%ebp),%ecx
 153:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 156:	31 c0                	xor    %eax,%eax
 158:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 15b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 15e:	40                   	inc    %eax
 15f:	84 d2                	test   %dl,%dl
 161:	75 f5                	jne    158 <strcpy+0xc>
    ;
  return os;
}
 163:	89 c8                	mov    %ecx,%eax
 165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 168:	c9                   	leave
 169:	c3                   	ret
 16a:	66 90                	xchg   %ax,%ax

0000016c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	53                   	push   %ebx
 170:	8b 55 08             	mov    0x8(%ebp),%edx
 173:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 176:	0f b6 02             	movzbl (%edx),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 10                	jne    18d <strcmp+0x21>
 17d:	eb 2a                	jmp    1a9 <strcmp+0x3d>
 17f:	90                   	nop
    p++, q++;
 180:	42                   	inc    %edx
 181:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 184:	0f b6 02             	movzbl (%edx),%eax
 187:	84 c0                	test   %al,%al
 189:	74 11                	je     19c <strcmp+0x30>
 18b:	89 cb                	mov    %ecx,%ebx
 18d:	0f b6 0b             	movzbl (%ebx),%ecx
 190:	38 c1                	cmp    %al,%cl
 192:	74 ec                	je     180 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 194:	29 c8                	sub    %ecx,%eax
}
 196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 199:	c9                   	leave
 19a:	c3                   	ret
 19b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 19c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 1a0:	31 c0                	xor    %eax,%eax
 1a2:	29 c8                	sub    %ecx,%eax
}
 1a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a7:	c9                   	leave
 1a8:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1a9:	0f b6 0b             	movzbl (%ebx),%ecx
 1ac:	31 c0                	xor    %eax,%eax
 1ae:	eb e4                	jmp    194 <strcmp+0x28>

000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1b6:	80 3a 00             	cmpb   $0x0,(%edx)
 1b9:	74 15                	je     1d0 <strlen+0x20>
 1bb:	31 c0                	xor    %eax,%eax
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
 1c0:	40                   	inc    %eax
 1c1:	89 c1                	mov    %eax,%ecx
 1c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1c7:	75 f7                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
 1c9:	89 c8                	mov    %ecx,%eax
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1d0:	31 c9                	xor    %ecx,%ecx
}
 1d2:	89 c8                	mov    %ecx,%eax
 1d4:	5d                   	pop    %ebp
 1d5:	c3                   	ret
 1d6:	66 90                	xchg   %ax,%ax

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1dc:	8b 7d 08             	mov    0x8(%ebp),%edi
 1df:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e5:	fc                   	cld
 1e6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1ee:	c9                   	leave
 1ef:	c3                   	ret

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1f9:	8a 10                	mov    (%eax),%dl
 1fb:	84 d2                	test   %dl,%dl
 1fd:	75 0c                	jne    20b <strchr+0x1b>
 1ff:	eb 13                	jmp    214 <strchr+0x24>
 201:	8d 76 00             	lea    0x0(%esi),%esi
 204:	40                   	inc    %eax
 205:	8a 10                	mov    (%eax),%dl
 207:	84 d2                	test   %dl,%dl
 209:	74 09                	je     214 <strchr+0x24>
    if(*s == c)
 20b:	38 d1                	cmp    %dl,%cl
 20d:	75 f5                	jne    204 <strchr+0x14>
      return (char*)s;
  return 0;
}
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret
 211:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 214:	31 c0                	xor    %eax,%eax
}
 216:	5d                   	pop    %ebp
 217:	c3                   	ret

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	57                   	push   %edi
 21c:	56                   	push   %esi
 21d:	53                   	push   %ebx
 21e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 221:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 223:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 226:	eb 24                	jmp    24c <gets+0x34>
    cc = read(0, &c, 1);
 228:	50                   	push   %eax
 229:	6a 01                	push   $0x1
 22b:	56                   	push   %esi
 22c:	6a 00                	push   $0x0
 22e:	e8 f4 00 00 00       	call   327 <read>
    if(cc < 1)
 233:	83 c4 10             	add    $0x10,%esp
 236:	85 c0                	test   %eax,%eax
 238:	7e 1a                	jle    254 <gets+0x3c>
      break;
    buf[i++] = c;
 23a:	8a 45 e7             	mov    -0x19(%ebp),%al
 23d:	8b 55 08             	mov    0x8(%ebp),%edx
 240:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 244:	3c 0a                	cmp    $0xa,%al
 246:	74 0e                	je     256 <gets+0x3e>
 248:	3c 0d                	cmp    $0xd,%al
 24a:	74 0a                	je     256 <gets+0x3e>
  for(i=0; i+1 < max; ){
 24c:	89 df                	mov    %ebx,%edi
 24e:	43                   	inc    %ebx
 24f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 252:	7c d4                	jl     228 <gets+0x10>
 254:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 25d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 260:	5b                   	pop    %ebx
 261:	5e                   	pop    %esi
 262:	5f                   	pop    %edi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret
 265:	8d 76 00             	lea    0x0(%esi),%esi

00000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	56                   	push   %esi
 26c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26d:	83 ec 08             	sub    $0x8,%esp
 270:	6a 00                	push   $0x0
 272:	ff 75 08             	push   0x8(%ebp)
 275:	e8 d5 00 00 00       	call   34f <open>
  if(fd < 0)
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	85 c0                	test   %eax,%eax
 27f:	78 27                	js     2a8 <stat+0x40>
 281:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 283:	83 ec 08             	sub    $0x8,%esp
 286:	ff 75 0c             	push   0xc(%ebp)
 289:	50                   	push   %eax
 28a:	e8 d8 00 00 00       	call   367 <fstat>
 28f:	89 c6                	mov    %eax,%esi
  close(fd);
 291:	89 1c 24             	mov    %ebx,(%esp)
 294:	e8 9e 00 00 00       	call   337 <close>
  return r;
 299:	83 c4 10             	add    $0x10,%esp
}
 29c:	89 f0                	mov    %esi,%eax
 29e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a1:	5b                   	pop    %ebx
 2a2:	5e                   	pop    %esi
 2a3:	5d                   	pop    %ebp
 2a4:	c3                   	ret
 2a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2ad:	eb ed                	jmp    29c <stat+0x34>
 2af:	90                   	nop

000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 01             	movsbl (%ecx),%eax
 2ba:	8d 50 d0             	lea    -0x30(%eax),%edx
 2bd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2c0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2c5:	77 16                	ja     2dd <atoi+0x2d>
 2c7:	90                   	nop
    n = n*10 + *s++ - '0';
 2c8:	41                   	inc    %ecx
 2c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2cc:	01 d2                	add    %edx,%edx
 2ce:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2d2:	0f be 01             	movsbl (%ecx),%eax
 2d5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d8:	80 fb 09             	cmp    $0x9,%bl
 2db:	76 eb                	jbe    2c8 <atoi+0x18>
  return n;
}
 2dd:	89 d0                	mov    %edx,%eax
 2df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e2:	c9                   	leave
 2e3:	c3                   	ret

000002e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	56                   	push   %esi
 2e9:	8b 55 08             	mov    0x8(%ebp),%edx
 2ec:	8b 75 0c             	mov    0xc(%ebp),%esi
 2ef:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f2:	85 c0                	test   %eax,%eax
 2f4:	7e 0b                	jle    301 <memmove+0x1d>
 2f6:	01 d0                	add    %edx,%eax
  dst = vdst;
 2f8:	89 d7                	mov    %edx,%edi
 2fa:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2fc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2fd:	39 f8                	cmp    %edi,%eax
 2ff:	75 fb                	jne    2fc <memmove+0x18>
  return vdst;
}
 301:	89 d0                	mov    %edx,%eax
 303:	5e                   	pop    %esi
 304:	5f                   	pop    %edi
 305:	5d                   	pop    %ebp
 306:	c3                   	ret

00000307 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 307:	b8 01 00 00 00       	mov    $0x1,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <exit>:
SYSCALL(exit)
 30f:	b8 02 00 00 00       	mov    $0x2,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <wait>:
SYSCALL(wait)
 317:	b8 03 00 00 00       	mov    $0x3,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <pipe>:
SYSCALL(pipe)
 31f:	b8 04 00 00 00       	mov    $0x4,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <read>:
SYSCALL(read)
 327:	b8 05 00 00 00       	mov    $0x5,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <write>:
SYSCALL(write)
 32f:	b8 10 00 00 00       	mov    $0x10,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <close>:
SYSCALL(close)
 337:	b8 15 00 00 00       	mov    $0x15,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <kill>:
SYSCALL(kill)
 33f:	b8 06 00 00 00       	mov    $0x6,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <exec>:
SYSCALL(exec)
 347:	b8 07 00 00 00       	mov    $0x7,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <open>:
SYSCALL(open)
 34f:	b8 0f 00 00 00       	mov    $0xf,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret

00000357 <mknod>:
SYSCALL(mknod)
 357:	b8 11 00 00 00       	mov    $0x11,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <unlink>:
SYSCALL(unlink)
 35f:	b8 12 00 00 00       	mov    $0x12,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <fstat>:
SYSCALL(fstat)
 367:	b8 08 00 00 00       	mov    $0x8,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <link>:
SYSCALL(link)
 36f:	b8 13 00 00 00       	mov    $0x13,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret

00000377 <mkdir>:
SYSCALL(mkdir)
 377:	b8 14 00 00 00       	mov    $0x14,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret

0000037f <chdir>:
SYSCALL(chdir)
 37f:	b8 09 00 00 00       	mov    $0x9,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret

00000387 <dup>:
SYSCALL(dup)
 387:	b8 0a 00 00 00       	mov    $0xa,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret

0000038f <getpid>:
SYSCALL(getpid)
 38f:	b8 0b 00 00 00       	mov    $0xb,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret

00000397 <sbrk>:
SYSCALL(sbrk)
 397:	b8 0c 00 00 00       	mov    $0xc,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret

0000039f <sleep>:
SYSCALL(sleep)
 39f:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret

000003a7 <uptime>:
SYSCALL(uptime)
 3a7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 3c             	sub    $0x3c,%esp
 3b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3bc:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3c1:	85 c9                	test   %ecx,%ecx
 3c3:	74 04                	je     3c9 <printint+0x19>
 3c5:	85 d2                	test   %edx,%edx
 3c7:	78 6b                	js     434 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 3cc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 3d3:	31 c9                	xor    %ecx,%ecx
 3d5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3db:	31 d2                	xor    %edx,%edx
 3dd:	f7 f3                	div    %ebx
 3df:	89 cf                	mov    %ecx,%edi
 3e1:	8d 49 01             	lea    0x1(%ecx),%ecx
 3e4:	8a 92 4c 09 00 00    	mov    0x94c(%edx),%dl
 3ea:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3f4:	39 da                	cmp    %ebx,%edx
 3f6:	73 e0                	jae    3d8 <printint+0x28>
  if(neg)
 3f8:	8b 55 08             	mov    0x8(%ebp),%edx
 3fb:	85 d2                	test   %edx,%edx
 3fd:	74 07                	je     406 <printint+0x56>
    buf[i++] = '-';
 3ff:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 404:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 406:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 409:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 40d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 410:	8a 07                	mov    (%edi),%al
 412:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 415:	50                   	push   %eax
 416:	6a 01                	push   $0x1
 418:	56                   	push   %esi
 419:	ff 75 c0             	push   -0x40(%ebp)
 41c:	e8 0e ff ff ff       	call   32f <write>
  while(--i >= 0)
 421:	89 f8                	mov    %edi,%eax
 423:	4f                   	dec    %edi
 424:	83 c4 10             	add    $0x10,%esp
 427:	39 d8                	cmp    %ebx,%eax
 429:	75 e5                	jne    410 <printint+0x60>
}
 42b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42e:	5b                   	pop    %ebx
 42f:	5e                   	pop    %esi
 430:	5f                   	pop    %edi
 431:	5d                   	pop    %ebp
 432:	c3                   	ret
 433:	90                   	nop
    x = -xx;
 434:	f7 da                	neg    %edx
 436:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 439:	eb 98                	jmp    3d3 <printint+0x23>
 43b:	90                   	nop

0000043c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	57                   	push   %edi
 440:	56                   	push   %esi
 441:	53                   	push   %ebx
 442:	83 ec 2c             	sub    $0x2c,%esp
 445:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 448:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 44b:	8a 03                	mov    (%ebx),%al
 44d:	84 c0                	test   %al,%al
 44f:	74 2a                	je     47b <printf+0x3f>
 451:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 452:	8d 4d 10             	lea    0x10(%ebp),%ecx
 455:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 458:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 45b:	83 fa 25             	cmp    $0x25,%edx
 45e:	74 24                	je     484 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 460:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 463:	50                   	push   %eax
 464:	6a 01                	push   $0x1
 466:	8d 45 e7             	lea    -0x19(%ebp),%eax
 469:	50                   	push   %eax
 46a:	56                   	push   %esi
 46b:	e8 bf fe ff ff       	call   32f <write>
  for(i = 0; fmt[i]; i++){
 470:	43                   	inc    %ebx
 471:	8a 43 ff             	mov    -0x1(%ebx),%al
 474:	83 c4 10             	add    $0x10,%esp
 477:	84 c0                	test   %al,%al
 479:	75 dd                	jne    458 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 47b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47e:	5b                   	pop    %ebx
 47f:	5e                   	pop    %esi
 480:	5f                   	pop    %edi
 481:	5d                   	pop    %ebp
 482:	c3                   	ret
 483:	90                   	nop
  for(i = 0; fmt[i]; i++){
 484:	8a 13                	mov    (%ebx),%dl
 486:	84 d2                	test   %dl,%dl
 488:	74 f1                	je     47b <printf+0x3f>
    c = fmt[i] & 0xff;
 48a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 48d:	80 fa 25             	cmp    $0x25,%dl
 490:	0f 84 fe 00 00 00    	je     594 <printf+0x158>
 496:	83 e8 63             	sub    $0x63,%eax
 499:	83 f8 15             	cmp    $0x15,%eax
 49c:	77 0a                	ja     4a8 <printf+0x6c>
 49e:	ff 24 85 f4 08 00 00 	jmp    *0x8f4(,%eax,4)
 4a5:	8d 76 00             	lea    0x0(%esi),%esi
 4a8:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 4ab:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4af:	50                   	push   %eax
 4b0:	6a 01                	push   $0x1
 4b2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b5:	57                   	push   %edi
 4b6:	56                   	push   %esi
 4b7:	e8 73 fe ff ff       	call   32f <write>
        putc(fd, c);
 4bc:	8a 55 d0             	mov    -0x30(%ebp),%dl
 4bf:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4c2:	83 c4 0c             	add    $0xc,%esp
 4c5:	6a 01                	push   $0x1
 4c7:	57                   	push   %edi
 4c8:	56                   	push   %esi
 4c9:	e8 61 fe ff ff       	call   32f <write>
  for(i = 0; fmt[i]; i++){
 4ce:	83 c3 02             	add    $0x2,%ebx
 4d1:	8a 43 ff             	mov    -0x1(%ebx),%al
 4d4:	83 c4 10             	add    $0x10,%esp
 4d7:	84 c0                	test   %al,%al
 4d9:	0f 85 79 ff ff ff    	jne    458 <printf+0x1c>
}
 4df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e2:	5b                   	pop    %ebx
 4e3:	5e                   	pop    %esi
 4e4:	5f                   	pop    %edi
 4e5:	5d                   	pop    %ebp
 4e6:	c3                   	ret
 4e7:	90                   	nop
        printint(fd, *ap, 16, 0);
 4e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4eb:	8b 17                	mov    (%edi),%edx
 4ed:	83 ec 0c             	sub    $0xc,%esp
 4f0:	6a 00                	push   $0x0
 4f2:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f7:	89 f0                	mov    %esi,%eax
 4f9:	e8 b2 fe ff ff       	call   3b0 <printint>
        ap++;
 4fe:	83 c7 04             	add    $0x4,%edi
 501:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 504:	eb c8                	jmp    4ce <printf+0x92>
 506:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 508:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 50b:	8b 01                	mov    (%ecx),%eax
        ap++;
 50d:	83 c1 04             	add    $0x4,%ecx
 510:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 513:	85 c0                	test   %eax,%eax
 515:	0f 84 89 00 00 00    	je     5a4 <printf+0x168>
        while(*s != 0){
 51b:	8a 10                	mov    (%eax),%dl
 51d:	84 d2                	test   %dl,%dl
 51f:	74 29                	je     54a <printf+0x10e>
 521:	89 c7                	mov    %eax,%edi
 523:	88 d0                	mov    %dl,%al
 525:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 528:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 52b:	89 fb                	mov    %edi,%ebx
 52d:	89 cf                	mov    %ecx,%edi
 52f:	90                   	nop
          putc(fd, *s);
 530:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 533:	50                   	push   %eax
 534:	6a 01                	push   $0x1
 536:	57                   	push   %edi
 537:	56                   	push   %esi
 538:	e8 f2 fd ff ff       	call   32f <write>
          s++;
 53d:	43                   	inc    %ebx
        while(*s != 0){
 53e:	8a 03                	mov    (%ebx),%al
 540:	83 c4 10             	add    $0x10,%esp
 543:	84 c0                	test   %al,%al
 545:	75 e9                	jne    530 <printf+0xf4>
 547:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 54a:	83 c3 02             	add    $0x2,%ebx
 54d:	8a 43 ff             	mov    -0x1(%ebx),%al
 550:	84 c0                	test   %al,%al
 552:	0f 85 00 ff ff ff    	jne    458 <printf+0x1c>
 558:	e9 1e ff ff ff       	jmp    47b <printf+0x3f>
 55d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 560:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 563:	8b 17                	mov    (%edi),%edx
 565:	83 ec 0c             	sub    $0xc,%esp
 568:	6a 01                	push   $0x1
 56a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 56f:	eb 86                	jmp    4f7 <printf+0xbb>
 571:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 57c:	51                   	push   %ecx
 57d:	6a 01                	push   $0x1
 57f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 582:	57                   	push   %edi
 583:	56                   	push   %esi
 584:	e8 a6 fd ff ff       	call   32f <write>
        ap++;
 589:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 58d:	e9 3c ff ff ff       	jmp    4ce <printf+0x92>
 592:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 594:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 597:	52                   	push   %edx
 598:	6a 01                	push   $0x1
 59a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 59d:	e9 25 ff ff ff       	jmp    4c7 <printf+0x8b>
 5a2:	66 90                	xchg   %ax,%ax
          s = "(null)";
 5a4:	bf 5f 07 00 00       	mov    $0x75f,%edi
 5a9:	b0 28                	mov    $0x28,%al
 5ab:	e9 75 ff ff ff       	jmp    525 <printf+0xe9>

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5bc:	a1 60 09 00 00       	mov    0x960,%eax
 5c1:	8d 76 00             	lea    0x0(%esi),%esi
 5c4:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c6:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c8:	39 ca                	cmp    %ecx,%edx
 5ca:	73 2c                	jae    5f8 <free+0x48>
 5cc:	39 c1                	cmp    %eax,%ecx
 5ce:	72 04                	jb     5d4 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 c2                	cmp    %eax,%edx
 5d2:	72 f0                	jb     5c4 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5da:	39 f8                	cmp    %edi,%eax
 5dc:	74 2c                	je     60a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5de:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5e1:	8b 42 04             	mov    0x4(%edx),%eax
 5e4:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5e7:	39 f1                	cmp    %esi,%ecx
 5e9:	74 36                	je     621 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5eb:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5ed:	89 15 60 09 00 00    	mov    %edx,0x960
}
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f8:	39 c2                	cmp    %eax,%edx
 5fa:	72 c8                	jb     5c4 <free+0x14>
 5fc:	39 c1                	cmp    %eax,%ecx
 5fe:	73 c4                	jae    5c4 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 600:	8b 73 fc             	mov    -0x4(%ebx),%esi
 603:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 606:	39 f8                	cmp    %edi,%eax
 608:	75 d4                	jne    5de <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 60a:	03 70 04             	add    0x4(%eax),%esi
 60d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 610:	8b 02                	mov    (%edx),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 617:	8b 42 04             	mov    0x4(%edx),%eax
 61a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 61d:	39 f1                	cmp    %esi,%ecx
 61f:	75 ca                	jne    5eb <free+0x3b>
    p->s.size += bp->s.size;
 621:	03 43 fc             	add    -0x4(%ebx),%eax
 624:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 627:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 62a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 62c:	89 15 60 09 00 00    	mov    %edx,0x960
}
 632:	5b                   	pop    %ebx
 633:	5e                   	pop    %esi
 634:	5f                   	pop    %edi
 635:	5d                   	pop    %ebp
 636:	c3                   	ret
 637:	90                   	nop

00000638 <malloc>:
}


void*
malloc(uint nbytes)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	57                   	push   %edi
 63c:	56                   	push   %esi
 63d:	53                   	push   %ebx
 63e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	8d 78 07             	lea    0x7(%eax),%edi
 647:	c1 ef 03             	shr    $0x3,%edi
 64a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 64b:	8b 15 60 09 00 00    	mov    0x960,%edx
 651:	85 d2                	test   %edx,%edx
 653:	0f 84 93 00 00 00    	je     6ec <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 659:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 65b:	8b 48 04             	mov    0x4(%eax),%ecx
 65e:	39 f9                	cmp    %edi,%ecx
 660:	73 62                	jae    6c4 <malloc+0x8c>
  if(nu < 4096)
 662:	89 fb                	mov    %edi,%ebx
 664:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 66a:	72 78                	jb     6e4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 66c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 673:	eb 0e                	jmp    683 <malloc+0x4b>
 675:	8d 76 00             	lea    0x0(%esi),%esi
 678:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 67a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 67c:	8b 48 04             	mov    0x4(%eax),%ecx
 67f:	39 f9                	cmp    %edi,%ecx
 681:	73 41                	jae    6c4 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 683:	39 05 60 09 00 00    	cmp    %eax,0x960
 689:	75 ed                	jne    678 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 68b:	83 ec 0c             	sub    $0xc,%esp
 68e:	56                   	push   %esi
 68f:	e8 03 fd ff ff       	call   397 <sbrk>
  if(p == (char*)-1)
 694:	83 c4 10             	add    $0x10,%esp
 697:	83 f8 ff             	cmp    $0xffffffff,%eax
 69a:	74 1c                	je     6b8 <malloc+0x80>
  hp->s.size = nu;
 69c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 69f:	83 ec 0c             	sub    $0xc,%esp
 6a2:	83 c0 08             	add    $0x8,%eax
 6a5:	50                   	push   %eax
 6a6:	e8 05 ff ff ff       	call   5b0 <free>
  return freep;
 6ab:	8b 15 60 09 00 00    	mov    0x960,%edx
      if((p = morecore(nunits)) == 0)
 6b1:	83 c4 10             	add    $0x10,%esp
 6b4:	85 d2                	test   %edx,%edx
 6b6:	75 c2                	jne    67a <malloc+0x42>
        return 0;
 6b8:	31 c0                	xor    %eax,%eax
  }
}
 6ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bd:	5b                   	pop    %ebx
 6be:	5e                   	pop    %esi
 6bf:	5f                   	pop    %edi
 6c0:	5d                   	pop    %ebp
 6c1:	c3                   	ret
 6c2:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 6c4:	39 cf                	cmp    %ecx,%edi
 6c6:	74 4c                	je     714 <malloc+0xdc>
        p->s.size -= nunits;
 6c8:	29 f9                	sub    %edi,%ecx
 6ca:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6cd:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6d0:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6d3:	89 15 60 09 00 00    	mov    %edx,0x960
      return (void*)(p + 1);
 6d9:	83 c0 08             	add    $0x8,%eax
}
 6dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6df:	5b                   	pop    %ebx
 6e0:	5e                   	pop    %esi
 6e1:	5f                   	pop    %edi
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret
  if(nu < 4096)
 6e4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e9:	eb 81                	jmp    66c <malloc+0x34>
 6eb:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6ec:	c7 05 60 09 00 00 64 	movl   $0x964,0x960
 6f3:	09 00 00 
 6f6:	c7 05 64 09 00 00 64 	movl   $0x964,0x964
 6fd:	09 00 00 
    base.s.size = 0;
 700:	c7 05 68 09 00 00 00 	movl   $0x0,0x968
 707:	00 00 00 
 70a:	b8 64 09 00 00       	mov    $0x964,%eax
 70f:	e9 4e ff ff ff       	jmp    662 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 714:	8b 08                	mov    (%eax),%ecx
 716:	89 0a                	mov    %ecx,(%edx)
 718:	eb b9                	jmp    6d3 <malloc+0x9b>
