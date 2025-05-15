
_test4:     file format elf32-i386


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
                   int pid = fork(); // Start later, execution time 50
  14:	e8 56 02 00 00       	call   26f <fork>
                   if (pid < 0) {
  19:	85 c0                	test   %eax,%eax
  1b:	78 45                	js     62 <main+0x62>
                           printf(1, "Failed to fork process %d\n", i);
                           exit();
                    } else if (pid == 0) {
  1d:	74 56                	je     75 <main+0x75>
            for (int i = 0; i < NUM_PROCS; i++) {
  1f:	43                   	inc    %ebx
  20:	83 fb 03             	cmp    $0x3,%ebx
  23:	75 ef                	jne    14 <main+0x14>
                            for (volatile int j = 0; j < 100000000; j++);
                            //     printf(1,"in child...."); // Simulated work
                            exit();
                           }
                    }
            printf(1, "All child processes created with start_later flag set.\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 dc 06 00 00       	push   $0x6dc
  2d:	6a 01                	push   $0x1
  2f:	e8 70 03 00 00       	call   3a4 <printf>
                      sleep(400);
  34:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
  3b:	e8 c7 02 00 00       	call   307 <sleep>
            // printf(1, "Calling sys_scheduler_start() to allow execution.\n");
            //   scheduler_start();
            for (int i = 0; i < NUM_PROCS; i++) {
                         wait();
  40:	e8 3a 02 00 00       	call   27f <wait>
  45:	e8 35 02 00 00       	call   27f <wait>
  4a:	e8 30 02 00 00       	call   27f <wait>
            }
            printf(1, "All child processes completed.\n");
  4f:	58                   	pop    %eax
  50:	5a                   	pop    %edx
  51:	68 14 07 00 00       	push   $0x714
  56:	6a 01                	push   $0x1
  58:	e8 47 03 00 00       	call   3a4 <printf>
            exit();
  5d:	e8 15 02 00 00       	call   277 <exit>
                           printf(1, "Failed to fork process %d\n", i);
  62:	50                   	push   %eax
  63:	53                   	push   %ebx
  64:	68 84 06 00 00       	push   $0x684
  69:	6a 01                	push   $0x1
  6b:	e8 34 03 00 00       	call   3a4 <printf>
                           exit();
  70:	e8 02 02 00 00       	call   277 <exit>
                            printf(1, "Child %d (PID: %d) started but should not run yet.\n", i, getpid());
  75:	e8 7d 02 00 00       	call   2f7 <getpid>
  7a:	50                   	push   %eax
  7b:	53                   	push   %ebx
  7c:	68 a8 06 00 00       	push   $0x6a8
  81:	6a 01                	push   $0x1
  83:	e8 1c 03 00 00       	call   3a4 <printf>
                            for (volatile int j = 0; j < 100000000; j++);
  88:	31 c9                	xor    %ecx,%ecx
  8a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	83 c4 10             	add    $0x10,%esp
  93:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  98:	7f 13                	jg     ad <main+0xad>
  9a:	66 90                	xchg   %ax,%ax
  9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9f:	40                   	inc    %eax
  a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a6:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
  ab:	7e ef                	jle    9c <main+0x9c>
                            exit();
  ad:	e8 c5 01 00 00       	call   277 <exit>
  b2:	66 90                	xchg   %ax,%ax

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	53                   	push   %ebx
  b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  be:	31 c0                	xor    %eax,%eax
  c0:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  c3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  c6:	40                   	inc    %eax
  c7:	84 d2                	test   %dl,%dl
  c9:	75 f5                	jne    c0 <strcpy+0xc>
    ;
  return os;
}
  cb:	89 c8                	mov    %ecx,%eax
  cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d0:	c9                   	leave
  d1:	c3                   	ret
  d2:	66 90                	xchg   %ax,%ax

000000d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	53                   	push   %ebx
  d8:	8b 55 08             	mov    0x8(%ebp),%edx
  db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  de:	0f b6 02             	movzbl (%edx),%eax
  e1:	84 c0                	test   %al,%al
  e3:	75 10                	jne    f5 <strcmp+0x21>
  e5:	eb 2a                	jmp    111 <strcmp+0x3d>
  e7:	90                   	nop
    p++, q++;
  e8:	42                   	inc    %edx
  e9:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  ec:	0f b6 02             	movzbl (%edx),%eax
  ef:	84 c0                	test   %al,%al
  f1:	74 11                	je     104 <strcmp+0x30>
  f3:	89 cb                	mov    %ecx,%ebx
  f5:	0f b6 0b             	movzbl (%ebx),%ecx
  f8:	38 c1                	cmp    %al,%cl
  fa:	74 ec                	je     e8 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  fc:	29 c8                	sub    %ecx,%eax
}
  fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 101:	c9                   	leave
 102:	c3                   	ret
 103:	90                   	nop
  return (uchar)*p - (uchar)*q;
 104:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 108:	31 c0                	xor    %eax,%eax
 10a:	29 c8                	sub    %ecx,%eax
}
 10c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10f:	c9                   	leave
 110:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 111:	0f b6 0b             	movzbl (%ebx),%ecx
 114:	31 c0                	xor    %eax,%eax
 116:	eb e4                	jmp    fc <strcmp+0x28>

00000118 <strlen>:

uint
strlen(const char *s)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 11e:	80 3a 00             	cmpb   $0x0,(%edx)
 121:	74 15                	je     138 <strlen+0x20>
 123:	31 c0                	xor    %eax,%eax
 125:	8d 76 00             	lea    0x0(%esi),%esi
 128:	40                   	inc    %eax
 129:	89 c1                	mov    %eax,%ecx
 12b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 12f:	75 f7                	jne    128 <strlen+0x10>
    ;
  return n;
}
 131:	89 c8                	mov    %ecx,%eax
 133:	5d                   	pop    %ebp
 134:	c3                   	ret
 135:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 138:	31 c9                	xor    %ecx,%ecx
}
 13a:	89 c8                	mov    %ecx,%eax
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret
 13e:	66 90                	xchg   %ax,%ax

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 144:	8b 7d 08             	mov    0x8(%ebp),%edi
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	fc                   	cld
 14e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8b 7d fc             	mov    -0x4(%ebp),%edi
 156:	c9                   	leave
 157:	c3                   	ret

00000158 <strchr>:

char*
strchr(const char *s, char c)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 161:	8a 10                	mov    (%eax),%dl
 163:	84 d2                	test   %dl,%dl
 165:	75 0c                	jne    173 <strchr+0x1b>
 167:	eb 13                	jmp    17c <strchr+0x24>
 169:	8d 76 00             	lea    0x0(%esi),%esi
 16c:	40                   	inc    %eax
 16d:	8a 10                	mov    (%eax),%dl
 16f:	84 d2                	test   %dl,%dl
 171:	74 09                	je     17c <strchr+0x24>
    if(*s == c)
 173:	38 d1                	cmp    %dl,%cl
 175:	75 f5                	jne    16c <strchr+0x14>
      return (char*)s;
  return 0;
}
 177:	5d                   	pop    %ebp
 178:	c3                   	ret
 179:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 17c:	31 c0                	xor    %eax,%eax
}
 17e:	5d                   	pop    %ebp
 17f:	c3                   	ret

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
 186:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 189:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 18b:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 18e:	eb 24                	jmp    1b4 <gets+0x34>
    cc = read(0, &c, 1);
 190:	50                   	push   %eax
 191:	6a 01                	push   $0x1
 193:	56                   	push   %esi
 194:	6a 00                	push   $0x0
 196:	e8 f4 00 00 00       	call   28f <read>
    if(cc < 1)
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	85 c0                	test   %eax,%eax
 1a0:	7e 1a                	jle    1bc <gets+0x3c>
      break;
    buf[i++] = c;
 1a2:	8a 45 e7             	mov    -0x19(%ebp),%al
 1a5:	8b 55 08             	mov    0x8(%ebp),%edx
 1a8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ac:	3c 0a                	cmp    $0xa,%al
 1ae:	74 0e                	je     1be <gets+0x3e>
 1b0:	3c 0d                	cmp    $0xd,%al
 1b2:	74 0a                	je     1be <gets+0x3e>
  for(i=0; i+1 < max; ){
 1b4:	89 df                	mov    %ebx,%edi
 1b6:	43                   	inc    %ebx
 1b7:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ba:	7c d4                	jl     190 <gets+0x10>
 1bc:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c8:	5b                   	pop    %ebx
 1c9:	5e                   	pop    %esi
 1ca:	5f                   	pop    %edi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	6a 00                	push   $0x0
 1da:	ff 75 08             	push   0x8(%ebp)
 1dd:	e8 d5 00 00 00       	call   2b7 <open>
  if(fd < 0)
 1e2:	83 c4 10             	add    $0x10,%esp
 1e5:	85 c0                	test   %eax,%eax
 1e7:	78 27                	js     210 <stat+0x40>
 1e9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1eb:	83 ec 08             	sub    $0x8,%esp
 1ee:	ff 75 0c             	push   0xc(%ebp)
 1f1:	50                   	push   %eax
 1f2:	e8 d8 00 00 00       	call   2cf <fstat>
 1f7:	89 c6                	mov    %eax,%esi
  close(fd);
 1f9:	89 1c 24             	mov    %ebx,(%esp)
 1fc:	e8 9e 00 00 00       	call   29f <close>
  return r;
 201:	83 c4 10             	add    $0x10,%esp
}
 204:	89 f0                	mov    %esi,%eax
 206:	8d 65 f8             	lea    -0x8(%ebp),%esp
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret
 20d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 210:	be ff ff ff ff       	mov    $0xffffffff,%esi
 215:	eb ed                	jmp    204 <stat+0x34>
 217:	90                   	nop

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	53                   	push   %ebx
 21c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21f:	0f be 01             	movsbl (%ecx),%eax
 222:	8d 50 d0             	lea    -0x30(%eax),%edx
 225:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 228:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 22d:	77 16                	ja     245 <atoi+0x2d>
 22f:	90                   	nop
    n = n*10 + *s++ - '0';
 230:	41                   	inc    %ecx
 231:	8d 14 92             	lea    (%edx,%edx,4),%edx
 234:	01 d2                	add    %edx,%edx
 236:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 23a:	0f be 01             	movsbl (%ecx),%eax
 23d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 240:	80 fb 09             	cmp    $0x9,%bl
 243:	76 eb                	jbe    230 <atoi+0x18>
  return n;
}
 245:	89 d0                	mov    %edx,%eax
 247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 24a:	c9                   	leave
 24b:	c3                   	ret

0000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	57                   	push   %edi
 250:	56                   	push   %esi
 251:	8b 55 08             	mov    0x8(%ebp),%edx
 254:	8b 75 0c             	mov    0xc(%ebp),%esi
 257:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25a:	85 c0                	test   %eax,%eax
 25c:	7e 0b                	jle    269 <memmove+0x1d>
 25e:	01 d0                	add    %edx,%eax
  dst = vdst;
 260:	89 d7                	mov    %edx,%edi
 262:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 264:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 265:	39 f8                	cmp    %edi,%eax
 267:	75 fb                	jne    264 <memmove+0x18>
  return vdst;
}
 269:	89 d0                	mov    %edx,%eax
 26b:	5e                   	pop    %esi
 26c:	5f                   	pop    %edi
 26d:	5d                   	pop    %ebp
 26e:	c3                   	ret

0000026f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26f:	b8 01 00 00 00       	mov    $0x1,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <exit>:
SYSCALL(exit)
 277:	b8 02 00 00 00       	mov    $0x2,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <wait>:
SYSCALL(wait)
 27f:	b8 03 00 00 00       	mov    $0x3,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <pipe>:
SYSCALL(pipe)
 287:	b8 04 00 00 00       	mov    $0x4,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <read>:
SYSCALL(read)
 28f:	b8 05 00 00 00       	mov    $0x5,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <write>:
SYSCALL(write)
 297:	b8 10 00 00 00       	mov    $0x10,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <close>:
SYSCALL(close)
 29f:	b8 15 00 00 00       	mov    $0x15,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <kill>:
SYSCALL(kill)
 2a7:	b8 06 00 00 00       	mov    $0x6,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <exec>:
SYSCALL(exec)
 2af:	b8 07 00 00 00       	mov    $0x7,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <open>:
SYSCALL(open)
 2b7:	b8 0f 00 00 00       	mov    $0xf,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <mknod>:
SYSCALL(mknod)
 2bf:	b8 11 00 00 00       	mov    $0x11,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <unlink>:
SYSCALL(unlink)
 2c7:	b8 12 00 00 00       	mov    $0x12,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <fstat>:
SYSCALL(fstat)
 2cf:	b8 08 00 00 00       	mov    $0x8,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <link>:
SYSCALL(link)
 2d7:	b8 13 00 00 00       	mov    $0x13,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <mkdir>:
SYSCALL(mkdir)
 2df:	b8 14 00 00 00       	mov    $0x14,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <chdir>:
SYSCALL(chdir)
 2e7:	b8 09 00 00 00       	mov    $0x9,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <dup>:
SYSCALL(dup)
 2ef:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <getpid>:
SYSCALL(getpid)
 2f7:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <sbrk>:
SYSCALL(sbrk)
 2ff:	b8 0c 00 00 00       	mov    $0xc,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <sleep>:
SYSCALL(sleep)
 307:	b8 0d 00 00 00       	mov    $0xd,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <uptime>:
SYSCALL(uptime)
 30f:	b8 0e 00 00 00       	mov    $0xe,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret
 317:	90                   	nop

00000318 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	57                   	push   %edi
 31c:	56                   	push   %esi
 31d:	53                   	push   %ebx
 31e:	83 ec 3c             	sub    $0x3c,%esp
 321:	89 45 c0             	mov    %eax,-0x40(%ebp)
 324:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 326:	8b 4d 08             	mov    0x8(%ebp),%ecx
 329:	85 c9                	test   %ecx,%ecx
 32b:	74 04                	je     331 <printint+0x19>
 32d:	85 d2                	test   %edx,%edx
 32f:	78 6b                	js     39c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 331:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 334:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 33b:	31 c9                	xor    %ecx,%ecx
 33d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 340:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 343:	31 d2                	xor    %edx,%edx
 345:	f7 f3                	div    %ebx
 347:	89 cf                	mov    %ecx,%edi
 349:	8d 49 01             	lea    0x1(%ecx),%ecx
 34c:	8a 92 8c 07 00 00    	mov    0x78c(%edx),%dl
 352:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 356:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 359:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 35c:	39 da                	cmp    %ebx,%edx
 35e:	73 e0                	jae    340 <printint+0x28>
  if(neg)
 360:	8b 55 08             	mov    0x8(%ebp),%edx
 363:	85 d2                	test   %edx,%edx
 365:	74 07                	je     36e <printint+0x56>
    buf[i++] = '-';
 367:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 36c:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 36e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 371:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 375:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 378:	8a 07                	mov    (%edi),%al
 37a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 37d:	50                   	push   %eax
 37e:	6a 01                	push   $0x1
 380:	56                   	push   %esi
 381:	ff 75 c0             	push   -0x40(%ebp)
 384:	e8 0e ff ff ff       	call   297 <write>
  while(--i >= 0)
 389:	89 f8                	mov    %edi,%eax
 38b:	4f                   	dec    %edi
 38c:	83 c4 10             	add    $0x10,%esp
 38f:	39 d8                	cmp    %ebx,%eax
 391:	75 e5                	jne    378 <printint+0x60>
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret
 39b:	90                   	nop
    x = -xx;
 39c:	f7 da                	neg    %edx
 39e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3a1:	eb 98                	jmp    33b <printint+0x23>
 3a3:	90                   	nop

000003a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	57                   	push   %edi
 3a8:	56                   	push   %esi
 3a9:	53                   	push   %ebx
 3aa:	83 ec 2c             	sub    $0x2c,%esp
 3ad:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3b3:	8a 03                	mov    (%ebx),%al
 3b5:	84 c0                	test   %al,%al
 3b7:	74 2a                	je     3e3 <printf+0x3f>
 3b9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3ba:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3bd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3c0:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3c3:	83 fa 25             	cmp    $0x25,%edx
 3c6:	74 24                	je     3ec <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3c8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3cb:	50                   	push   %eax
 3cc:	6a 01                	push   $0x1
 3ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3d1:	50                   	push   %eax
 3d2:	56                   	push   %esi
 3d3:	e8 bf fe ff ff       	call   297 <write>
  for(i = 0; fmt[i]; i++){
 3d8:	43                   	inc    %ebx
 3d9:	8a 43 ff             	mov    -0x1(%ebx),%al
 3dc:	83 c4 10             	add    $0x10,%esp
 3df:	84 c0                	test   %al,%al
 3e1:	75 dd                	jne    3c0 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e6:	5b                   	pop    %ebx
 3e7:	5e                   	pop    %esi
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret
 3eb:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3ec:	8a 13                	mov    (%ebx),%dl
 3ee:	84 d2                	test   %dl,%dl
 3f0:	74 f1                	je     3e3 <printf+0x3f>
    c = fmt[i] & 0xff;
 3f2:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3f5:	80 fa 25             	cmp    $0x25,%dl
 3f8:	0f 84 fe 00 00 00    	je     4fc <printf+0x158>
 3fe:	83 e8 63             	sub    $0x63,%eax
 401:	83 f8 15             	cmp    $0x15,%eax
 404:	77 0a                	ja     410 <printf+0x6c>
 406:	ff 24 85 34 07 00 00 	jmp    *0x734(,%eax,4)
 40d:	8d 76 00             	lea    0x0(%esi),%esi
 410:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 413:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 417:	50                   	push   %eax
 418:	6a 01                	push   $0x1
 41a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 41d:	57                   	push   %edi
 41e:	56                   	push   %esi
 41f:	e8 73 fe ff ff       	call   297 <write>
        putc(fd, c);
 424:	8a 55 d0             	mov    -0x30(%ebp),%dl
 427:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 42a:	83 c4 0c             	add    $0xc,%esp
 42d:	6a 01                	push   $0x1
 42f:	57                   	push   %edi
 430:	56                   	push   %esi
 431:	e8 61 fe ff ff       	call   297 <write>
  for(i = 0; fmt[i]; i++){
 436:	83 c3 02             	add    $0x2,%ebx
 439:	8a 43 ff             	mov    -0x1(%ebx),%al
 43c:	83 c4 10             	add    $0x10,%esp
 43f:	84 c0                	test   %al,%al
 441:	0f 85 79 ff ff ff    	jne    3c0 <printf+0x1c>
}
 447:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44a:	5b                   	pop    %ebx
 44b:	5e                   	pop    %esi
 44c:	5f                   	pop    %edi
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret
 44f:	90                   	nop
        printint(fd, *ap, 16, 0);
 450:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 453:	8b 17                	mov    (%edi),%edx
 455:	83 ec 0c             	sub    $0xc,%esp
 458:	6a 00                	push   $0x0
 45a:	b9 10 00 00 00       	mov    $0x10,%ecx
 45f:	89 f0                	mov    %esi,%eax
 461:	e8 b2 fe ff ff       	call   318 <printint>
        ap++;
 466:	83 c7 04             	add    $0x4,%edi
 469:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 46c:	eb c8                	jmp    436 <printf+0x92>
 46e:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 470:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 473:	8b 01                	mov    (%ecx),%eax
        ap++;
 475:	83 c1 04             	add    $0x4,%ecx
 478:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 47b:	85 c0                	test   %eax,%eax
 47d:	0f 84 89 00 00 00    	je     50c <printf+0x168>
        while(*s != 0){
 483:	8a 10                	mov    (%eax),%dl
 485:	84 d2                	test   %dl,%dl
 487:	74 29                	je     4b2 <printf+0x10e>
 489:	89 c7                	mov    %eax,%edi
 48b:	88 d0                	mov    %dl,%al
 48d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 490:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 493:	89 fb                	mov    %edi,%ebx
 495:	89 cf                	mov    %ecx,%edi
 497:	90                   	nop
          putc(fd, *s);
 498:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 49b:	50                   	push   %eax
 49c:	6a 01                	push   $0x1
 49e:	57                   	push   %edi
 49f:	56                   	push   %esi
 4a0:	e8 f2 fd ff ff       	call   297 <write>
          s++;
 4a5:	43                   	inc    %ebx
        while(*s != 0){
 4a6:	8a 03                	mov    (%ebx),%al
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	84 c0                	test   %al,%al
 4ad:	75 e9                	jne    498 <printf+0xf4>
 4af:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4b2:	83 c3 02             	add    $0x2,%ebx
 4b5:	8a 43 ff             	mov    -0x1(%ebx),%al
 4b8:	84 c0                	test   %al,%al
 4ba:	0f 85 00 ff ff ff    	jne    3c0 <printf+0x1c>
 4c0:	e9 1e ff ff ff       	jmp    3e3 <printf+0x3f>
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4c8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4cb:	8b 17                	mov    (%edi),%edx
 4cd:	83 ec 0c             	sub    $0xc,%esp
 4d0:	6a 01                	push   $0x1
 4d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d7:	eb 86                	jmp    45f <printf+0xbb>
 4d9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4e4:	51                   	push   %ecx
 4e5:	6a 01                	push   $0x1
 4e7:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4ea:	57                   	push   %edi
 4eb:	56                   	push   %esi
 4ec:	e8 a6 fd ff ff       	call   297 <write>
        ap++;
 4f1:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4f5:	e9 3c ff ff ff       	jmp    436 <printf+0x92>
 4fa:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4fc:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4ff:	52                   	push   %edx
 500:	6a 01                	push   $0x1
 502:	8d 7d e7             	lea    -0x19(%ebp),%edi
 505:	e9 25 ff ff ff       	jmp    42f <printf+0x8b>
 50a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 50c:	bf 9f 06 00 00       	mov    $0x69f,%edi
 511:	b0 28                	mov    $0x28,%al
 513:	e9 75 ff ff ff       	jmp    48d <printf+0xe9>

00000518 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 518:	55                   	push   %ebp
 519:	89 e5                	mov    %esp,%ebp
 51b:	57                   	push   %edi
 51c:	56                   	push   %esi
 51d:	53                   	push   %ebx
 51e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 521:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 524:	a1 a0 07 00 00       	mov    0x7a0,%eax
 529:	8d 76 00             	lea    0x0(%esi),%esi
 52c:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 52e:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 530:	39 ca                	cmp    %ecx,%edx
 532:	73 2c                	jae    560 <free+0x48>
 534:	39 c1                	cmp    %eax,%ecx
 536:	72 04                	jb     53c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 538:	39 c2                	cmp    %eax,%edx
 53a:	72 f0                	jb     52c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 53c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 53f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 542:	39 f8                	cmp    %edi,%eax
 544:	74 2c                	je     572 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 546:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 549:	8b 42 04             	mov    0x4(%edx),%eax
 54c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 54f:	39 f1                	cmp    %esi,%ecx
 551:	74 36                	je     589 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 553:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 555:	89 15 a0 07 00 00    	mov    %edx,0x7a0
}
 55b:	5b                   	pop    %ebx
 55c:	5e                   	pop    %esi
 55d:	5f                   	pop    %edi
 55e:	5d                   	pop    %ebp
 55f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 560:	39 c2                	cmp    %eax,%edx
 562:	72 c8                	jb     52c <free+0x14>
 564:	39 c1                	cmp    %eax,%ecx
 566:	73 c4                	jae    52c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 568:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56e:	39 f8                	cmp    %edi,%eax
 570:	75 d4                	jne    546 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 572:	03 70 04             	add    0x4(%eax),%esi
 575:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 578:	8b 02                	mov    (%edx),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 57f:	8b 42 04             	mov    0x4(%edx),%eax
 582:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 585:	39 f1                	cmp    %esi,%ecx
 587:	75 ca                	jne    553 <free+0x3b>
    p->s.size += bp->s.size;
 589:	03 43 fc             	add    -0x4(%ebx),%eax
 58c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 58f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 592:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 594:	89 15 a0 07 00 00    	mov    %edx,0x7a0
}
 59a:	5b                   	pop    %ebx
 59b:	5e                   	pop    %esi
 59c:	5f                   	pop    %edi
 59d:	5d                   	pop    %ebp
 59e:	c3                   	ret
 59f:	90                   	nop

000005a0 <malloc>:
}


void*
malloc(uint nbytes)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	8d 78 07             	lea    0x7(%eax),%edi
 5af:	c1 ef 03             	shr    $0x3,%edi
 5b2:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5b3:	8b 15 a0 07 00 00    	mov    0x7a0,%edx
 5b9:	85 d2                	test   %edx,%edx
 5bb:	0f 84 93 00 00 00    	je     654 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5c3:	8b 48 04             	mov    0x4(%eax),%ecx
 5c6:	39 f9                	cmp    %edi,%ecx
 5c8:	73 62                	jae    62c <malloc+0x8c>
  if(nu < 4096)
 5ca:	89 fb                	mov    %edi,%ebx
 5cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5d2:	72 78                	jb     64c <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 5d4:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5db:	eb 0e                	jmp    5eb <malloc+0x4b>
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
 5e0:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5e4:	8b 48 04             	mov    0x4(%eax),%ecx
 5e7:	39 f9                	cmp    %edi,%ecx
 5e9:	73 41                	jae    62c <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5eb:	39 05 a0 07 00 00    	cmp    %eax,0x7a0
 5f1:	75 ed                	jne    5e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 5f3:	83 ec 0c             	sub    $0xc,%esp
 5f6:	56                   	push   %esi
 5f7:	e8 03 fd ff ff       	call   2ff <sbrk>
  if(p == (char*)-1)
 5fc:	83 c4 10             	add    $0x10,%esp
 5ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 602:	74 1c                	je     620 <malloc+0x80>
  hp->s.size = nu;
 604:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 607:	83 ec 0c             	sub    $0xc,%esp
 60a:	83 c0 08             	add    $0x8,%eax
 60d:	50                   	push   %eax
 60e:	e8 05 ff ff ff       	call   518 <free>
  return freep;
 613:	8b 15 a0 07 00 00    	mov    0x7a0,%edx
      if((p = morecore(nunits)) == 0)
 619:	83 c4 10             	add    $0x10,%esp
 61c:	85 d2                	test   %edx,%edx
 61e:	75 c2                	jne    5e2 <malloc+0x42>
        return 0;
 620:	31 c0                	xor    %eax,%eax
  }
}
 622:	8d 65 f4             	lea    -0xc(%ebp),%esp
 625:	5b                   	pop    %ebx
 626:	5e                   	pop    %esi
 627:	5f                   	pop    %edi
 628:	5d                   	pop    %ebp
 629:	c3                   	ret
 62a:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 62c:	39 cf                	cmp    %ecx,%edi
 62e:	74 4c                	je     67c <malloc+0xdc>
        p->s.size -= nunits;
 630:	29 f9                	sub    %edi,%ecx
 632:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 635:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 638:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 63b:	89 15 a0 07 00 00    	mov    %edx,0x7a0
      return (void*)(p + 1);
 641:	83 c0 08             	add    $0x8,%eax
}
 644:	8d 65 f4             	lea    -0xc(%ebp),%esp
 647:	5b                   	pop    %ebx
 648:	5e                   	pop    %esi
 649:	5f                   	pop    %edi
 64a:	5d                   	pop    %ebp
 64b:	c3                   	ret
  if(nu < 4096)
 64c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 651:	eb 81                	jmp    5d4 <malloc+0x34>
 653:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 654:	c7 05 a0 07 00 00 a4 	movl   $0x7a4,0x7a0
 65b:	07 00 00 
 65e:	c7 05 a4 07 00 00 a4 	movl   $0x7a4,0x7a4
 665:	07 00 00 
    base.s.size = 0;
 668:	c7 05 a8 07 00 00 00 	movl   $0x0,0x7a8
 66f:	00 00 00 
 672:	b8 a4 07 00 00       	mov    $0x7a4,%eax
 677:	e9 4e ff ff ff       	jmp    5ca <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 67c:	8b 08                	mov    (%eax),%ecx
 67e:	89 0a                	mov    %ecx,(%edx)
 680:	eb b9                	jmp    63b <malloc+0x9b>
