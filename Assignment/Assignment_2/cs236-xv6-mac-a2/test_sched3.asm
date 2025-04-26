
_test_sched3:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 20             	sub    $0x20,%esp
    int pid1, pid2, pid3;
    
    // Create one immediate start process:
    pid1 = custom_fork(0, 50);  // starts immediately
  14:	6a 32                	push   $0x32
  16:	6a 00                	push   $0x0
  18:	e8 ea 03 00 00       	call   407 <custom_fork>
    if (pid1 < 0) {
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	0f 88 a8 00 00 00    	js     d0 <main+0xd0>
        printf(1, "Failed to fork immediate process\n");
        exit();
    } else if (pid1 == 0) {
  28:	75 3c                	jne    66 <main+0x66>
        printf(1, "[Child] Immediate start process (PID: %d) running.\n", getpid());
  2a:	e8 b0 03 00 00       	call   3df <getpid>
  2f:	57                   	push   %edi
  30:	50                   	push   %eax
  31:	68 a8 07 00 00       	push   $0x7a8
  36:	6a 01                	push   $0x1
  38:	e8 67 04 00 00       	call   4a4 <printf>
        for (volatile int j = 0; j < 100000000; j++);
  3d:	31 c0                	xor    %eax,%eax
  3f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  45:	83 c4 10             	add    $0x10,%esp
  48:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  4d:	7f 12                	jg     61 <main+0x61>
  4f:	90                   	nop
  50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  53:	40                   	inc    %eax
  54:	89 45 dc             	mov    %eax,-0x24(%ebp)
  57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  5a:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  5f:	7e ef                	jle    50 <main+0x50>
        exit();
  61:	e8 f9 02 00 00       	call   35f <exit>
  66:	89 c3                	mov    %eax,%ebx
    }
    
    // Create two delayed start processes:
    pid2 = custom_fork(1, 50);  // start later
  68:	56                   	push   %esi
  69:	56                   	push   %esi
  6a:	6a 32                	push   $0x32
  6c:	6a 01                	push   $0x1
  6e:	e8 94 03 00 00       	call   407 <custom_fork>
  73:	89 c6                	mov    %eax,%esi
    if (pid2 < 0) {
  75:	83 c4 10             	add    $0x10,%esp
  78:	85 c0                	test   %eax,%eax
  7a:	0f 88 a2 00 00 00    	js     122 <main+0x122>
        printf(1, "Failed to fork delayed process 1\n");
        exit();
    } else if (pid2 == 0) {
  80:	74 61                	je     e3 <main+0xe3>
        printf(1, "[Child] Delayed start process (PID: %d) running.\n", getpid());
        for (volatile int j = 0; j < 100000000; j++);
        exit();
    }
    
    pid3 = custom_fork(1, 50);  // start later
  82:	57                   	push   %edi
  83:	57                   	push   %edi
  84:	6a 32                	push   $0x32
  86:	6a 01                	push   $0x1
  88:	e8 7a 03 00 00       	call   407 <custom_fork>
  8d:	89 c7                	mov    %eax,%edi
    if (pid3 < 0) {
  8f:	83 c4 10             	add    $0x10,%esp
  92:	85 c0                	test   %eax,%eax
  94:	0f 88 ed 00 00 00    	js     187 <main+0x187>
        printf(1, "Failed to fork delayed process 2\n");
        exit();
    } else if (pid3 == 0) {
  9a:	0f 85 95 00 00 00    	jne    135 <main+0x135>
        printf(1, "[Child] Delayed start process (PID: %d) running.\n", getpid());
  a0:	e8 3a 03 00 00       	call   3df <getpid>
  a5:	51                   	push   %ecx
  a6:	50                   	push   %eax
  a7:	68 00 08 00 00       	push   $0x800
  ac:	6a 01                	push   $0x1
  ae:	e8 f1 03 00 00       	call   4a4 <printf>
        for (volatile int j = 0; j < 100000000; j++);
  b3:	31 db                	xor    %ebx,%ebx
  b5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	eb 07                	jmp    c4 <main+0xc4>
  bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c0:	40                   	inc    %eax
  c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c7:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  cc:	7e ef                	jle    bd <main+0xbd>
  ce:	eb 91                	jmp    61 <main+0x61>
        printf(1, "Failed to fork immediate process\n");
  d0:	50                   	push   %eax
  d1:	50                   	push   %eax
  d2:	68 84 07 00 00       	push   $0x784
  d7:	6a 01                	push   $0x1
  d9:	e8 c6 03 00 00       	call   4a4 <printf>
        exit();
  de:	e8 7c 02 00 00       	call   35f <exit>
        printf(1, "[Child] Delayed start process (PID: %d) running.\n", getpid());
  e3:	e8 f7 02 00 00       	call   3df <getpid>
  e8:	52                   	push   %edx
  e9:	50                   	push   %eax
  ea:	68 00 08 00 00       	push   $0x800
  ef:	6a 01                	push   $0x1
  f1:	e8 ae 03 00 00       	call   4a4 <printf>
        for (volatile int j = 0; j < 100000000; j++);
  f6:	31 c9                	xor    %ecx,%ecx
  f8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  fe:	83 c4 10             	add    $0x10,%esp
 101:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 106:	0f 8f 55 ff ff ff    	jg     61 <main+0x61>
 10c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 10f:	40                   	inc    %eax
 110:	89 45 e0             	mov    %eax,-0x20(%ebp)
 113:	8b 45 e0             	mov    -0x20(%ebp),%eax
 116:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 11b:	7e ef                	jle    10c <main+0x10c>
 11d:	e9 3f ff ff ff       	jmp    61 <main+0x61>
        printf(1, "Failed to fork delayed process 1\n");
 122:	53                   	push   %ebx
 123:	53                   	push   %ebx
 124:	68 dc 07 00 00       	push   $0x7dc
 129:	6a 01                	push   $0x1
 12b:	e8 74 03 00 00       	call   4a4 <printf>
        exit();
 130:	e8 2a 02 00 00       	call   35f <exit>
        exit();
    }
    sleep(1000);
 135:	83 ec 0c             	sub    $0xc,%esp
 138:	68 e8 03 00 00       	push   $0x3e8
 13d:	e8 ad 02 00 00       	call   3ef <sleep>
    // Parent branch: print the PIDs
    printf(1, "[Parent] Created immediate PID %d, and delayed PIDs %d and %d\n", pid1, pid2, pid3);
 142:	89 3c 24             	mov    %edi,(%esp)
 145:	56                   	push   %esi
 146:	53                   	push   %ebx
 147:	68 58 08 00 00       	push   $0x858
 14c:	6a 01                	push   $0x1
 14e:	e8 51 03 00 00       	call   4a4 <printf>
    sleep(200);  // wait before starting the delayed ones
 153:	83 c4 14             	add    $0x14,%esp
 156:	68 c8 00 00 00       	push   $0xc8
 15b:	e8 8f 02 00 00       	call   3ef <sleep>
    scheduler_start();
 160:	e8 aa 02 00 00       	call   40f <scheduler_start>
    // Wait for all children to finish
    wait();
 165:	e8 fd 01 00 00       	call   367 <wait>
    wait();
 16a:	e8 f8 01 00 00       	call   367 <wait>
    wait();
 16f:	e8 f3 01 00 00       	call   367 <wait>
    printf(1, "[Parent] All children done\n");
 174:	58                   	pop    %eax
 175:	5a                   	pop    %edx
 176:	68 97 08 00 00       	push   $0x897
 17b:	6a 01                	push   $0x1
 17d:	e8 22 03 00 00       	call   4a4 <printf>
    exit();
 182:	e8 d8 01 00 00       	call   35f <exit>
        printf(1, "Failed to fork delayed process 2\n");
 187:	56                   	push   %esi
 188:	56                   	push   %esi
 189:	68 34 08 00 00       	push   $0x834
 18e:	6a 01                	push   $0x1
 190:	e8 0f 03 00 00       	call   4a4 <printf>
        exit();
 195:	e8 c5 01 00 00       	call   35f <exit>
 19a:	66 90                	xchg   %ax,%ax

0000019c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	53                   	push   %ebx
 1a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a6:	31 c0                	xor    %eax,%eax
 1a8:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 1ab:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1ae:	40                   	inc    %eax
 1af:	84 d2                	test   %dl,%dl
 1b1:	75 f5                	jne    1a8 <strcpy+0xc>
    ;
  return os;
}
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b8:	c9                   	leave
 1b9:	c3                   	ret
 1ba:	66 90                	xchg   %ax,%ax

000001bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	53                   	push   %ebx
 1c0:	8b 55 08             	mov    0x8(%ebp),%edx
 1c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 1c6:	0f b6 02             	movzbl (%edx),%eax
 1c9:	84 c0                	test   %al,%al
 1cb:	75 10                	jne    1dd <strcmp+0x21>
 1cd:	eb 2a                	jmp    1f9 <strcmp+0x3d>
 1cf:	90                   	nop
    p++, q++;
 1d0:	42                   	inc    %edx
 1d1:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 1d4:	0f b6 02             	movzbl (%edx),%eax
 1d7:	84 c0                	test   %al,%al
 1d9:	74 11                	je     1ec <strcmp+0x30>
 1db:	89 cb                	mov    %ecx,%ebx
 1dd:	0f b6 0b             	movzbl (%ebx),%ecx
 1e0:	38 c1                	cmp    %al,%cl
 1e2:	74 ec                	je     1d0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1e4:	29 c8                	sub    %ecx,%eax
}
 1e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e9:	c9                   	leave
 1ea:	c3                   	ret
 1eb:	90                   	nop
  return (uchar)*p - (uchar)*q;
 1ec:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 1f0:	31 c0                	xor    %eax,%eax
 1f2:	29 c8                	sub    %ecx,%eax
}
 1f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f7:	c9                   	leave
 1f8:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1f9:	0f b6 0b             	movzbl (%ebx),%ecx
 1fc:	31 c0                	xor    %eax,%eax
 1fe:	eb e4                	jmp    1e4 <strcmp+0x28>

00000200 <strlen>:

uint
strlen(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 206:	80 3a 00             	cmpb   $0x0,(%edx)
 209:	74 15                	je     220 <strlen+0x20>
 20b:	31 c0                	xor    %eax,%eax
 20d:	8d 76 00             	lea    0x0(%esi),%esi
 210:	40                   	inc    %eax
 211:	89 c1                	mov    %eax,%ecx
 213:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 217:	75 f7                	jne    210 <strlen+0x10>
    ;
  return n;
}
 219:	89 c8                	mov    %ecx,%eax
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret
 21d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 220:	31 c9                	xor    %ecx,%ecx
}
 222:	89 c8                	mov    %ecx,%eax
 224:	5d                   	pop    %ebp
 225:	c3                   	ret
 226:	66 90                	xchg   %ax,%ax

00000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 22c:	8b 7d 08             	mov    0x8(%ebp),%edi
 22f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 232:	8b 45 0c             	mov    0xc(%ebp),%eax
 235:	fc                   	cld
 236:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 23e:	c9                   	leave
 23f:	c3                   	ret

00000240 <strchr>:

char*
strchr(const char *s, char c)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 249:	8a 10                	mov    (%eax),%dl
 24b:	84 d2                	test   %dl,%dl
 24d:	75 0c                	jne    25b <strchr+0x1b>
 24f:	eb 13                	jmp    264 <strchr+0x24>
 251:	8d 76 00             	lea    0x0(%esi),%esi
 254:	40                   	inc    %eax
 255:	8a 10                	mov    (%eax),%dl
 257:	84 d2                	test   %dl,%dl
 259:	74 09                	je     264 <strchr+0x24>
    if(*s == c)
 25b:	38 d1                	cmp    %dl,%cl
 25d:	75 f5                	jne    254 <strchr+0x14>
      return (char*)s;
  return 0;
}
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret
 261:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 264:	31 c0                	xor    %eax,%eax
}
 266:	5d                   	pop    %ebp
 267:	c3                   	ret

00000268 <gets>:

char*
gets(char *buf, int max)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	57                   	push   %edi
 26c:	56                   	push   %esi
 26d:	53                   	push   %ebx
 26e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 271:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 273:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 276:	eb 24                	jmp    29c <gets+0x34>
    cc = read(0, &c, 1);
 278:	50                   	push   %eax
 279:	6a 01                	push   $0x1
 27b:	56                   	push   %esi
 27c:	6a 00                	push   $0x0
 27e:	e8 f4 00 00 00       	call   377 <read>
    if(cc < 1)
 283:	83 c4 10             	add    $0x10,%esp
 286:	85 c0                	test   %eax,%eax
 288:	7e 1a                	jle    2a4 <gets+0x3c>
      break;
    buf[i++] = c;
 28a:	8a 45 e7             	mov    -0x19(%ebp),%al
 28d:	8b 55 08             	mov    0x8(%ebp),%edx
 290:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 294:	3c 0a                	cmp    $0xa,%al
 296:	74 0e                	je     2a6 <gets+0x3e>
 298:	3c 0d                	cmp    $0xd,%al
 29a:	74 0a                	je     2a6 <gets+0x3e>
  for(i=0; i+1 < max; ){
 29c:	89 df                	mov    %ebx,%edi
 29e:	43                   	inc    %ebx
 29f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2a2:	7c d4                	jl     278 <gets+0x10>
 2a4:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 2ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret
 2b5:	8d 76 00             	lea    0x0(%esi),%esi

000002b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	56                   	push   %esi
 2bc:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2bd:	83 ec 08             	sub    $0x8,%esp
 2c0:	6a 00                	push   $0x0
 2c2:	ff 75 08             	push   0x8(%ebp)
 2c5:	e8 d5 00 00 00       	call   39f <open>
  if(fd < 0)
 2ca:	83 c4 10             	add    $0x10,%esp
 2cd:	85 c0                	test   %eax,%eax
 2cf:	78 27                	js     2f8 <stat+0x40>
 2d1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	ff 75 0c             	push   0xc(%ebp)
 2d9:	50                   	push   %eax
 2da:	e8 d8 00 00 00       	call   3b7 <fstat>
 2df:	89 c6                	mov    %eax,%esi
  close(fd);
 2e1:	89 1c 24             	mov    %ebx,(%esp)
 2e4:	e8 9e 00 00 00       	call   387 <close>
  return r;
 2e9:	83 c4 10             	add    $0x10,%esp
}
 2ec:	89 f0                	mov    %esi,%eax
 2ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2f1:	5b                   	pop    %ebx
 2f2:	5e                   	pop    %esi
 2f3:	5d                   	pop    %ebp
 2f4:	c3                   	ret
 2f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2fd:	eb ed                	jmp    2ec <stat+0x34>
 2ff:	90                   	nop

00000300 <atoi>:

int
atoi(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	53                   	push   %ebx
 304:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 307:	0f be 01             	movsbl (%ecx),%eax
 30a:	8d 50 d0             	lea    -0x30(%eax),%edx
 30d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 310:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 315:	77 16                	ja     32d <atoi+0x2d>
 317:	90                   	nop
    n = n*10 + *s++ - '0';
 318:	41                   	inc    %ecx
 319:	8d 14 92             	lea    (%edx,%edx,4),%edx
 31c:	01 d2                	add    %edx,%edx
 31e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 322:	0f be 01             	movsbl (%ecx),%eax
 325:	8d 58 d0             	lea    -0x30(%eax),%ebx
 328:	80 fb 09             	cmp    $0x9,%bl
 32b:	76 eb                	jbe    318 <atoi+0x18>
  return n;
}
 32d:	89 d0                	mov    %edx,%eax
 32f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 332:	c9                   	leave
 333:	c3                   	ret

00000334 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	57                   	push   %edi
 338:	56                   	push   %esi
 339:	8b 55 08             	mov    0x8(%ebp),%edx
 33c:	8b 75 0c             	mov    0xc(%ebp),%esi
 33f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 342:	85 c0                	test   %eax,%eax
 344:	7e 0b                	jle    351 <memmove+0x1d>
 346:	01 d0                	add    %edx,%eax
  dst = vdst;
 348:	89 d7                	mov    %edx,%edi
 34a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 34c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 34d:	39 f8                	cmp    %edi,%eax
 34f:	75 fb                	jne    34c <memmove+0x18>
  return vdst;
}
 351:	89 d0                	mov    %edx,%eax
 353:	5e                   	pop    %esi
 354:	5f                   	pop    %edi
 355:	5d                   	pop    %ebp
 356:	c3                   	ret

00000357 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 357:	b8 01 00 00 00       	mov    $0x1,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <exit>:
SYSCALL(exit)
 35f:	b8 02 00 00 00       	mov    $0x2,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <wait>:
SYSCALL(wait)
 367:	b8 03 00 00 00       	mov    $0x3,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <pipe>:
SYSCALL(pipe)
 36f:	b8 04 00 00 00       	mov    $0x4,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret

00000377 <read>:
SYSCALL(read)
 377:	b8 05 00 00 00       	mov    $0x5,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret

0000037f <write>:
SYSCALL(write)
 37f:	b8 10 00 00 00       	mov    $0x10,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret

00000387 <close>:
SYSCALL(close)
 387:	b8 15 00 00 00       	mov    $0x15,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret

0000038f <kill>:
SYSCALL(kill)
 38f:	b8 06 00 00 00       	mov    $0x6,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret

00000397 <exec>:
SYSCALL(exec)
 397:	b8 07 00 00 00       	mov    $0x7,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret

0000039f <open>:
SYSCALL(open)
 39f:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret

000003a7 <mknod>:
SYSCALL(mknod)
 3a7:	b8 11 00 00 00       	mov    $0x11,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret

000003af <unlink>:
SYSCALL(unlink)
 3af:	b8 12 00 00 00       	mov    $0x12,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret

000003b7 <fstat>:
SYSCALL(fstat)
 3b7:	b8 08 00 00 00       	mov    $0x8,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret

000003bf <link>:
SYSCALL(link)
 3bf:	b8 13 00 00 00       	mov    $0x13,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret

000003c7 <mkdir>:
SYSCALL(mkdir)
 3c7:	b8 14 00 00 00       	mov    $0x14,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret

000003cf <chdir>:
SYSCALL(chdir)
 3cf:	b8 09 00 00 00       	mov    $0x9,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret

000003d7 <dup>:
SYSCALL(dup)
 3d7:	b8 0a 00 00 00       	mov    $0xa,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret

000003df <getpid>:
SYSCALL(getpid)
 3df:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret

000003e7 <sbrk>:
SYSCALL(sbrk)
 3e7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret

000003ef <sleep>:
SYSCALL(sleep)
 3ef:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret

000003f7 <uptime>:
SYSCALL(uptime)
 3f7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret

000003ff <signal>:
SYSCALL(signal)
 3ff:	b8 16 00 00 00       	mov    $0x16,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret

00000407 <custom_fork>:
SYSCALL(custom_fork)
 407:	b8 17 00 00 00       	mov    $0x17,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret

0000040f <scheduler_start>:
 40f:	b8 18 00 00 00       	mov    $0x18,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret
 417:	90                   	nop

00000418 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	57                   	push   %edi
 41c:	56                   	push   %esi
 41d:	53                   	push   %ebx
 41e:	83 ec 3c             	sub    $0x3c,%esp
 421:	89 45 c0             	mov    %eax,-0x40(%ebp)
 424:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 426:	8b 4d 08             	mov    0x8(%ebp),%ecx
 429:	85 c9                	test   %ecx,%ecx
 42b:	74 04                	je     431 <printint+0x19>
 42d:	85 d2                	test   %edx,%edx
 42f:	78 6b                	js     49c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 431:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 434:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 43b:	31 c9                	xor    %ecx,%ecx
 43d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 440:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 443:	31 d2                	xor    %edx,%edx
 445:	f7 f3                	div    %ebx
 447:	89 cf                	mov    %ecx,%edi
 449:	8d 49 01             	lea    0x1(%ecx),%ecx
 44c:	8a 92 14 09 00 00    	mov    0x914(%edx),%dl
 452:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 456:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 459:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 45c:	39 da                	cmp    %ebx,%edx
 45e:	73 e0                	jae    440 <printint+0x28>
  if(neg)
 460:	8b 55 08             	mov    0x8(%ebp),%edx
 463:	85 d2                	test   %edx,%edx
 465:	74 07                	je     46e <printint+0x56>
    buf[i++] = '-';
 467:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 46c:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 46e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 471:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 475:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 478:	8a 07                	mov    (%edi),%al
 47a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 47d:	50                   	push   %eax
 47e:	6a 01                	push   $0x1
 480:	56                   	push   %esi
 481:	ff 75 c0             	push   -0x40(%ebp)
 484:	e8 f6 fe ff ff       	call   37f <write>
  while(--i >= 0)
 489:	89 f8                	mov    %edi,%eax
 48b:	4f                   	dec    %edi
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	39 d8                	cmp    %ebx,%eax
 491:	75 e5                	jne    478 <printint+0x60>
}
 493:	8d 65 f4             	lea    -0xc(%ebp),%esp
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret
 49b:	90                   	nop
    x = -xx;
 49c:	f7 da                	neg    %edx
 49e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 4a1:	eb 98                	jmp    43b <printint+0x23>
 4a3:	90                   	nop

000004a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	57                   	push   %edi
 4a8:	56                   	push   %esi
 4a9:	53                   	push   %ebx
 4aa:	83 ec 2c             	sub    $0x2c,%esp
 4ad:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4b3:	8a 03                	mov    (%ebx),%al
 4b5:	84 c0                	test   %al,%al
 4b7:	74 2a                	je     4e3 <printf+0x3f>
 4b9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 4ba:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4bd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 4c0:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 4c3:	83 fa 25             	cmp    $0x25,%edx
 4c6:	74 24                	je     4ec <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 4c8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	50                   	push   %eax
 4cc:	6a 01                	push   $0x1
 4ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d1:	50                   	push   %eax
 4d2:	56                   	push   %esi
 4d3:	e8 a7 fe ff ff       	call   37f <write>
  for(i = 0; fmt[i]; i++){
 4d8:	43                   	inc    %ebx
 4d9:	8a 43 ff             	mov    -0x1(%ebx),%al
 4dc:	83 c4 10             	add    $0x10,%esp
 4df:	84 c0                	test   %al,%al
 4e1:	75 dd                	jne    4c0 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e6:	5b                   	pop    %ebx
 4e7:	5e                   	pop    %esi
 4e8:	5f                   	pop    %edi
 4e9:	5d                   	pop    %ebp
 4ea:	c3                   	ret
 4eb:	90                   	nop
  for(i = 0; fmt[i]; i++){
 4ec:	8a 13                	mov    (%ebx),%dl
 4ee:	84 d2                	test   %dl,%dl
 4f0:	74 f1                	je     4e3 <printf+0x3f>
    c = fmt[i] & 0xff;
 4f2:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 4f5:	80 fa 25             	cmp    $0x25,%dl
 4f8:	0f 84 fe 00 00 00    	je     5fc <printf+0x158>
 4fe:	83 e8 63             	sub    $0x63,%eax
 501:	83 f8 15             	cmp    $0x15,%eax
 504:	77 0a                	ja     510 <printf+0x6c>
 506:	ff 24 85 bc 08 00 00 	jmp    *0x8bc(,%eax,4)
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 513:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 517:	50                   	push   %eax
 518:	6a 01                	push   $0x1
 51a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 51d:	57                   	push   %edi
 51e:	56                   	push   %esi
 51f:	e8 5b fe ff ff       	call   37f <write>
        putc(fd, c);
 524:	8a 55 d0             	mov    -0x30(%ebp),%dl
 527:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 52a:	83 c4 0c             	add    $0xc,%esp
 52d:	6a 01                	push   $0x1
 52f:	57                   	push   %edi
 530:	56                   	push   %esi
 531:	e8 49 fe ff ff       	call   37f <write>
  for(i = 0; fmt[i]; i++){
 536:	83 c3 02             	add    $0x2,%ebx
 539:	8a 43 ff             	mov    -0x1(%ebx),%al
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	84 c0                	test   %al,%al
 541:	0f 85 79 ff ff ff    	jne    4c0 <printf+0x1c>
}
 547:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54a:	5b                   	pop    %ebx
 54b:	5e                   	pop    %esi
 54c:	5f                   	pop    %edi
 54d:	5d                   	pop    %ebp
 54e:	c3                   	ret
 54f:	90                   	nop
        printint(fd, *ap, 16, 0);
 550:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 553:	8b 17                	mov    (%edi),%edx
 555:	83 ec 0c             	sub    $0xc,%esp
 558:	6a 00                	push   $0x0
 55a:	b9 10 00 00 00       	mov    $0x10,%ecx
 55f:	89 f0                	mov    %esi,%eax
 561:	e8 b2 fe ff ff       	call   418 <printint>
        ap++;
 566:	83 c7 04             	add    $0x4,%edi
 569:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 56c:	eb c8                	jmp    536 <printf+0x92>
 56e:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 570:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 573:	8b 01                	mov    (%ecx),%eax
        ap++;
 575:	83 c1 04             	add    $0x4,%ecx
 578:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 57b:	85 c0                	test   %eax,%eax
 57d:	0f 84 89 00 00 00    	je     60c <printf+0x168>
        while(*s != 0){
 583:	8a 10                	mov    (%eax),%dl
 585:	84 d2                	test   %dl,%dl
 587:	74 29                	je     5b2 <printf+0x10e>
 589:	89 c7                	mov    %eax,%edi
 58b:	88 d0                	mov    %dl,%al
 58d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 590:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 593:	89 fb                	mov    %edi,%ebx
 595:	89 cf                	mov    %ecx,%edi
 597:	90                   	nop
          putc(fd, *s);
 598:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 59b:	50                   	push   %eax
 59c:	6a 01                	push   $0x1
 59e:	57                   	push   %edi
 59f:	56                   	push   %esi
 5a0:	e8 da fd ff ff       	call   37f <write>
          s++;
 5a5:	43                   	inc    %ebx
        while(*s != 0){
 5a6:	8a 03                	mov    (%ebx),%al
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	84 c0                	test   %al,%al
 5ad:	75 e9                	jne    598 <printf+0xf4>
 5af:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 5b2:	83 c3 02             	add    $0x2,%ebx
 5b5:	8a 43 ff             	mov    -0x1(%ebx),%al
 5b8:	84 c0                	test   %al,%al
 5ba:	0f 85 00 ff ff ff    	jne    4c0 <printf+0x1c>
 5c0:	e9 1e ff ff ff       	jmp    4e3 <printf+0x3f>
 5c5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5c8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5cb:	8b 17                	mov    (%edi),%edx
 5cd:	83 ec 0c             	sub    $0xc,%esp
 5d0:	6a 01                	push   $0x1
 5d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5d7:	eb 86                	jmp    55f <printf+0xbb>
 5d9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 5dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e4:	51                   	push   %ecx
 5e5:	6a 01                	push   $0x1
 5e7:	8d 7d e7             	lea    -0x19(%ebp),%edi
 5ea:	57                   	push   %edi
 5eb:	56                   	push   %esi
 5ec:	e8 8e fd ff ff       	call   37f <write>
        ap++;
 5f1:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5f5:	e9 3c ff ff ff       	jmp    536 <printf+0x92>
 5fa:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 5fc:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5ff:	52                   	push   %edx
 600:	6a 01                	push   $0x1
 602:	8d 7d e7             	lea    -0x19(%ebp),%edi
 605:	e9 25 ff ff ff       	jmp    52f <printf+0x8b>
 60a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 60c:	bf b3 08 00 00       	mov    $0x8b3,%edi
 611:	b0 28                	mov    $0x28,%al
 613:	e9 75 ff ff ff       	jmp    58d <printf+0xe9>

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	57                   	push   %edi
 61c:	56                   	push   %esi
 61d:	53                   	push   %ebx
 61e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 621:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	a1 28 09 00 00       	mov    0x928,%eax
 629:	8d 76 00             	lea    0x0(%esi),%esi
 62c:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62e:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 630:	39 ca                	cmp    %ecx,%edx
 632:	73 2c                	jae    660 <free+0x48>
 634:	39 c1                	cmp    %eax,%ecx
 636:	72 04                	jb     63c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 638:	39 c2                	cmp    %eax,%edx
 63a:	72 f0                	jb     62c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 63c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 642:	39 f8                	cmp    %edi,%eax
 644:	74 2c                	je     672 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 649:	8b 42 04             	mov    0x4(%edx),%eax
 64c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 64f:	39 f1                	cmp    %esi,%ecx
 651:	74 36                	je     689 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 653:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 655:	89 15 28 09 00 00    	mov    %edx,0x928
}
 65b:	5b                   	pop    %ebx
 65c:	5e                   	pop    %esi
 65d:	5f                   	pop    %edi
 65e:	5d                   	pop    %ebp
 65f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 c2                	cmp    %eax,%edx
 662:	72 c8                	jb     62c <free+0x14>
 664:	39 c1                	cmp    %eax,%ecx
 666:	73 c4                	jae    62c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 73 fc             	mov    -0x4(%ebx),%esi
 66b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66e:	39 f8                	cmp    %edi,%eax
 670:	75 d4                	jne    646 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 672:	03 70 04             	add    0x4(%eax),%esi
 675:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 678:	8b 02                	mov    (%edx),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 67f:	8b 42 04             	mov    0x4(%edx),%eax
 682:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 685:	39 f1                	cmp    %esi,%ecx
 687:	75 ca                	jne    653 <free+0x3b>
    p->s.size += bp->s.size;
 689:	03 43 fc             	add    -0x4(%ebx),%eax
 68c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 68f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 692:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 694:	89 15 28 09 00 00    	mov    %edx,0x928
}
 69a:	5b                   	pop    %ebx
 69b:	5e                   	pop    %esi
 69c:	5f                   	pop    %edi
 69d:	5d                   	pop    %ebp
 69e:	c3                   	ret
 69f:	90                   	nop

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	8d 78 07             	lea    0x7(%eax),%edi
 6af:	c1 ef 03             	shr    $0x3,%edi
 6b2:	47                   	inc    %edi
  if((prevp = freep) == 0){
 6b3:	8b 15 28 09 00 00    	mov    0x928,%edx
 6b9:	85 d2                	test   %edx,%edx
 6bb:	0f 84 93 00 00 00    	je     754 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6c3:	8b 48 04             	mov    0x4(%eax),%ecx
 6c6:	39 f9                	cmp    %edi,%ecx
 6c8:	73 62                	jae    72c <malloc+0x8c>
  if(nu < 4096)
 6ca:	89 fb                	mov    %edi,%ebx
 6cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6d2:	72 78                	jb     74c <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 6d4:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6db:	eb 0e                	jmp    6eb <malloc+0x4b>
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
 6e0:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6e4:	8b 48 04             	mov    0x4(%eax),%ecx
 6e7:	39 f9                	cmp    %edi,%ecx
 6e9:	73 41                	jae    72c <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6eb:	39 05 28 09 00 00    	cmp    %eax,0x928
 6f1:	75 ed                	jne    6e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6f3:	83 ec 0c             	sub    $0xc,%esp
 6f6:	56                   	push   %esi
 6f7:	e8 eb fc ff ff       	call   3e7 <sbrk>
  if(p == (char*)-1)
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 702:	74 1c                	je     720 <malloc+0x80>
  hp->s.size = nu;
 704:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 707:	83 ec 0c             	sub    $0xc,%esp
 70a:	83 c0 08             	add    $0x8,%eax
 70d:	50                   	push   %eax
 70e:	e8 05 ff ff ff       	call   618 <free>
  return freep;
 713:	8b 15 28 09 00 00    	mov    0x928,%edx
      if((p = morecore(nunits)) == 0)
 719:	83 c4 10             	add    $0x10,%esp
 71c:	85 d2                	test   %edx,%edx
 71e:	75 c2                	jne    6e2 <malloc+0x42>
        return 0;
 720:	31 c0                	xor    %eax,%eax
  }
}
 722:	8d 65 f4             	lea    -0xc(%ebp),%esp
 725:	5b                   	pop    %ebx
 726:	5e                   	pop    %esi
 727:	5f                   	pop    %edi
 728:	5d                   	pop    %ebp
 729:	c3                   	ret
 72a:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 72c:	39 cf                	cmp    %ecx,%edi
 72e:	74 4c                	je     77c <malloc+0xdc>
        p->s.size -= nunits;
 730:	29 f9                	sub    %edi,%ecx
 732:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 735:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 738:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 73b:	89 15 28 09 00 00    	mov    %edx,0x928
      return (void*)(p + 1);
 741:	83 c0 08             	add    $0x8,%eax
}
 744:	8d 65 f4             	lea    -0xc(%ebp),%esp
 747:	5b                   	pop    %ebx
 748:	5e                   	pop    %esi
 749:	5f                   	pop    %edi
 74a:	5d                   	pop    %ebp
 74b:	c3                   	ret
  if(nu < 4096)
 74c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 751:	eb 81                	jmp    6d4 <malloc+0x34>
 753:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 754:	c7 05 28 09 00 00 2c 	movl   $0x92c,0x928
 75b:	09 00 00 
 75e:	c7 05 2c 09 00 00 2c 	movl   $0x92c,0x92c
 765:	09 00 00 
    base.s.size = 0;
 768:	c7 05 30 09 00 00 00 	movl   $0x0,0x930
 76f:	00 00 00 
 772:	b8 2c 09 00 00       	mov    $0x92c,%eax
 777:	e9 4e ff ff ff       	jmp    6ca <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 77c:	8b 08                	mov    (%eax),%ecx
 77e:	89 0a                	mov    %ecx,(%edx)
 780:	eb b9                	jmp    73b <malloc+0x9b>
