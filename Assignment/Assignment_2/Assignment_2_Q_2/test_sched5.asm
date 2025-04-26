
_test_sched5:     file format elf32-i386


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
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 14             	sub    $0x14,%esp
           
            int pid1 = custom_fork(0, 50);  // starts immediately
  13:	6a 32                	push   $0x32
  15:	6a 00                	push   $0x0
  17:	e8 c3 02 00 00       	call   2df <custom_fork>
  1c:	89 c3                	mov    %eax,%ebx
            int pid2 = custom_fork(1, 50);  // start later
  1e:	58                   	pop    %eax
  1f:	5a                   	pop    %edx
  20:	6a 32                	push   $0x32
  22:	6a 01                	push   $0x1
  24:	e8 b6 02 00 00       	call   2df <custom_fork>
  29:	89 c6                	mov    %eax,%esi
            int pid3 = custom_fork(1, 50);  // start later
  2b:	59                   	pop    %ecx
  2c:	58                   	pop    %eax
  2d:	6a 32                	push   $0x32
  2f:	6a 01                	push   $0x1
  31:	e8 a9 02 00 00       	call   2df <custom_fork>

            printf(1, "[Parent] Created PID %d (now), PID %d and %d (start later)\n", pid1, pid2, pid3);
  36:	89 04 24             	mov    %eax,(%esp)
  39:	56                   	push   %esi
  3a:	53                   	push   %ebx
  3b:	68 5c 06 00 00       	push   $0x65c
  40:	6a 01                	push   $0x1
  42:	e8 35 03 00 00       	call   37c <printf>

            sleep(200);  // wait before starting delayed procs
  47:	83 c4 14             	add    $0x14,%esp
  4a:	68 c8 00 00 00       	push   $0xc8
  4f:	e8 7b 02 00 00       	call   2cf <sleep>
            scheduler_start();
  54:	e8 8e 02 00 00       	call   2e7 <scheduler_start>
            wait();
  59:	e8 e9 01 00 00       	call   247 <wait>
            wait();
  5e:	e8 e4 01 00 00       	call   247 <wait>
            wait();
  63:	e8 df 01 00 00       	call   247 <wait>
            printf(1, "[Parent] All children done\n");
  68:	58                   	pop    %eax
  69:	5a                   	pop    %edx
  6a:	68 98 06 00 00       	push   $0x698
  6f:	6a 01                	push   $0x1
  71:	e8 06 03 00 00       	call   37c <printf>
            exit();
  76:	e8 c4 01 00 00       	call   23f <exit>
  7b:	90                   	nop

0000007c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	53                   	push   %ebx
  80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  86:	31 c0                	xor    %eax,%eax
  88:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  8b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8e:	40                   	inc    %eax
  8f:	84 d2                	test   %dl,%dl
  91:	75 f5                	jne    88 <strcpy+0xc>
    ;
  return os;
}
  93:	89 c8                	mov    %ecx,%eax
  95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  98:	c9                   	leave
  99:	c3                   	ret
  9a:	66 90                	xchg   %ax,%ax

0000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  9f:	53                   	push   %ebx
  a0:	8b 55 08             	mov    0x8(%ebp),%edx
  a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  a6:	0f b6 02             	movzbl (%edx),%eax
  a9:	84 c0                	test   %al,%al
  ab:	75 10                	jne    bd <strcmp+0x21>
  ad:	eb 2a                	jmp    d9 <strcmp+0x3d>
  af:	90                   	nop
    p++, q++;
  b0:	42                   	inc    %edx
  b1:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  b4:	0f b6 02             	movzbl (%edx),%eax
  b7:	84 c0                	test   %al,%al
  b9:	74 11                	je     cc <strcmp+0x30>
  bb:	89 cb                	mov    %ecx,%ebx
  bd:	0f b6 0b             	movzbl (%ebx),%ecx
  c0:	38 c1                	cmp    %al,%cl
  c2:	74 ec                	je     b0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  c4:	29 c8                	sub    %ecx,%eax
}
  c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c9:	c9                   	leave
  ca:	c3                   	ret
  cb:	90                   	nop
  return (uchar)*p - (uchar)*q;
  cc:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  d0:	31 c0                	xor    %eax,%eax
  d2:	29 c8                	sub    %ecx,%eax
}
  d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d7:	c9                   	leave
  d8:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  d9:	0f b6 0b             	movzbl (%ebx),%ecx
  dc:	31 c0                	xor    %eax,%eax
  de:	eb e4                	jmp    c4 <strcmp+0x28>

000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 3a 00             	cmpb   $0x0,(%edx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 c0                	xor    %eax,%eax
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	40                   	inc    %eax
  f1:	89 c1                	mov    %eax,%ecx
  f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  f7:	75 f7                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  f9:	89 c8                	mov    %ecx,%eax
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 100:	31 c9                	xor    %ecx,%ecx
}
 102:	89 c8                	mov    %ecx,%eax
 104:	5d                   	pop    %ebp
 105:	c3                   	ret
 106:	66 90                	xchg   %ax,%ax

00000108 <memset>:

void*
memset(void *dst, int c, uint n)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
 10f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 112:	8b 45 0c             	mov    0xc(%ebp),%eax
 115:	fc                   	cld
 116:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 11e:	c9                   	leave
 11f:	c3                   	ret

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 129:	8a 10                	mov    (%eax),%dl
 12b:	84 d2                	test   %dl,%dl
 12d:	75 0c                	jne    13b <strchr+0x1b>
 12f:	eb 13                	jmp    144 <strchr+0x24>
 131:	8d 76 00             	lea    0x0(%esi),%esi
 134:	40                   	inc    %eax
 135:	8a 10                	mov    (%eax),%dl
 137:	84 d2                	test   %dl,%dl
 139:	74 09                	je     144 <strchr+0x24>
    if(*s == c)
 13b:	38 d1                	cmp    %dl,%cl
 13d:	75 f5                	jne    134 <strchr+0x14>
      return (char*)s;
  return 0;
}
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret
 141:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 144:	31 c0                	xor    %eax,%eax
}
 146:	5d                   	pop    %ebp
 147:	c3                   	ret

00000148 <gets>:

char*
gets(char *buf, int max)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	57                   	push   %edi
 14c:	56                   	push   %esi
 14d:	53                   	push   %ebx
 14e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 151:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 153:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 156:	eb 24                	jmp    17c <gets+0x34>
    cc = read(0, &c, 1);
 158:	50                   	push   %eax
 159:	6a 01                	push   $0x1
 15b:	56                   	push   %esi
 15c:	6a 00                	push   $0x0
 15e:	e8 f4 00 00 00       	call   257 <read>
    if(cc < 1)
 163:	83 c4 10             	add    $0x10,%esp
 166:	85 c0                	test   %eax,%eax
 168:	7e 1a                	jle    184 <gets+0x3c>
      break;
    buf[i++] = c;
 16a:	8a 45 e7             	mov    -0x19(%ebp),%al
 16d:	8b 55 08             	mov    0x8(%ebp),%edx
 170:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 174:	3c 0a                	cmp    $0xa,%al
 176:	74 0e                	je     186 <gets+0x3e>
 178:	3c 0d                	cmp    $0xd,%al
 17a:	74 0a                	je     186 <gets+0x3e>
  for(i=0; i+1 < max; ){
 17c:	89 df                	mov    %ebx,%edi
 17e:	43                   	inc    %ebx
 17f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 182:	7c d4                	jl     158 <gets+0x10>
 184:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 18d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5f                   	pop    %edi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret
 195:	8d 76 00             	lea    0x0(%esi),%esi

00000198 <stat>:

int
stat(const char *n, struct stat *st)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	56                   	push   %esi
 19c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19d:	83 ec 08             	sub    $0x8,%esp
 1a0:	6a 00                	push   $0x0
 1a2:	ff 75 08             	push   0x8(%ebp)
 1a5:	e8 d5 00 00 00       	call   27f <open>
  if(fd < 0)
 1aa:	83 c4 10             	add    $0x10,%esp
 1ad:	85 c0                	test   %eax,%eax
 1af:	78 27                	js     1d8 <stat+0x40>
 1b1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1b3:	83 ec 08             	sub    $0x8,%esp
 1b6:	ff 75 0c             	push   0xc(%ebp)
 1b9:	50                   	push   %eax
 1ba:	e8 d8 00 00 00       	call   297 <fstat>
 1bf:	89 c6                	mov    %eax,%esi
  close(fd);
 1c1:	89 1c 24             	mov    %ebx,(%esp)
 1c4:	e8 9e 00 00 00       	call   267 <close>
  return r;
 1c9:	83 c4 10             	add    $0x10,%esp
}
 1cc:	89 f0                	mov    %esi,%eax
 1ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d1:	5b                   	pop    %ebx
 1d2:	5e                   	pop    %esi
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret
 1d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1dd:	eb ed                	jmp    1cc <stat+0x34>
 1df:	90                   	nop

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e7:	0f be 01             	movsbl (%ecx),%eax
 1ea:	8d 50 d0             	lea    -0x30(%eax),%edx
 1ed:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1f0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1f5:	77 16                	ja     20d <atoi+0x2d>
 1f7:	90                   	nop
    n = n*10 + *s++ - '0';
 1f8:	41                   	inc    %ecx
 1f9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1fc:	01 d2                	add    %edx,%edx
 1fe:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 202:	0f be 01             	movsbl (%ecx),%eax
 205:	8d 58 d0             	lea    -0x30(%eax),%ebx
 208:	80 fb 09             	cmp    $0x9,%bl
 20b:	76 eb                	jbe    1f8 <atoi+0x18>
  return n;
}
 20d:	89 d0                	mov    %edx,%eax
 20f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 212:	c9                   	leave
 213:	c3                   	ret

00000214 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	56                   	push   %esi
 219:	8b 55 08             	mov    0x8(%ebp),%edx
 21c:	8b 75 0c             	mov    0xc(%ebp),%esi
 21f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 222:	85 c0                	test   %eax,%eax
 224:	7e 0b                	jle    231 <memmove+0x1d>
 226:	01 d0                	add    %edx,%eax
  dst = vdst;
 228:	89 d7                	mov    %edx,%edi
 22a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 22c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 22d:	39 f8                	cmp    %edi,%eax
 22f:	75 fb                	jne    22c <memmove+0x18>
  return vdst;
}
 231:	89 d0                	mov    %edx,%eax
 233:	5e                   	pop    %esi
 234:	5f                   	pop    %edi
 235:	5d                   	pop    %ebp
 236:	c3                   	ret

00000237 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 237:	b8 01 00 00 00       	mov    $0x1,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret

0000023f <exit>:
SYSCALL(exit)
 23f:	b8 02 00 00 00       	mov    $0x2,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret

00000247 <wait>:
SYSCALL(wait)
 247:	b8 03 00 00 00       	mov    $0x3,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret

0000024f <pipe>:
SYSCALL(pipe)
 24f:	b8 04 00 00 00       	mov    $0x4,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret

00000257 <read>:
SYSCALL(read)
 257:	b8 05 00 00 00       	mov    $0x5,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret

0000025f <write>:
SYSCALL(write)
 25f:	b8 10 00 00 00       	mov    $0x10,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret

00000267 <close>:
SYSCALL(close)
 267:	b8 15 00 00 00       	mov    $0x15,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret

0000026f <kill>:
SYSCALL(kill)
 26f:	b8 06 00 00 00       	mov    $0x6,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <exec>:
SYSCALL(exec)
 277:	b8 07 00 00 00       	mov    $0x7,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <open>:
SYSCALL(open)
 27f:	b8 0f 00 00 00       	mov    $0xf,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <mknod>:
SYSCALL(mknod)
 287:	b8 11 00 00 00       	mov    $0x11,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <unlink>:
SYSCALL(unlink)
 28f:	b8 12 00 00 00       	mov    $0x12,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <fstat>:
SYSCALL(fstat)
 297:	b8 08 00 00 00       	mov    $0x8,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <link>:
SYSCALL(link)
 29f:	b8 13 00 00 00       	mov    $0x13,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <mkdir>:
SYSCALL(mkdir)
 2a7:	b8 14 00 00 00       	mov    $0x14,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <chdir>:
SYSCALL(chdir)
 2af:	b8 09 00 00 00       	mov    $0x9,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <dup>:
SYSCALL(dup)
 2b7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <getpid>:
SYSCALL(getpid)
 2bf:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <sbrk>:
SYSCALL(sbrk)
 2c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <sleep>:
SYSCALL(sleep)
 2cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <uptime>:
SYSCALL(uptime)
 2d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <custom_fork>:
SYSCALL(custom_fork)
 2df:	b8 17 00 00 00       	mov    $0x17,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <scheduler_start>:
SYSCALL(scheduler_start)
 2e7:	b8 18 00 00 00       	mov    $0x18,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret
 2ef:	90                   	nop

000002f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	53                   	push   %ebx
 2f6:	83 ec 3c             	sub    $0x3c,%esp
 2f9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 2fc:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
 301:	85 c9                	test   %ecx,%ecx
 303:	74 04                	je     309 <printint+0x19>
 305:	85 d2                	test   %edx,%edx
 307:	78 6b                	js     374 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 309:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 30c:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 313:	31 c9                	xor    %ecx,%ecx
 315:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 318:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 31b:	31 d2                	xor    %edx,%edx
 31d:	f7 f3                	div    %ebx
 31f:	89 cf                	mov    %ecx,%edi
 321:	8d 49 01             	lea    0x1(%ecx),%ecx
 324:	8a 92 14 07 00 00    	mov    0x714(%edx),%dl
 32a:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 32e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 331:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 334:	39 da                	cmp    %ebx,%edx
 336:	73 e0                	jae    318 <printint+0x28>
  if(neg)
 338:	8b 55 08             	mov    0x8(%ebp),%edx
 33b:	85 d2                	test   %edx,%edx
 33d:	74 07                	je     346 <printint+0x56>
    buf[i++] = '-';
 33f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 344:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 346:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 349:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 34d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 350:	8a 07                	mov    (%edi),%al
 352:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 355:	50                   	push   %eax
 356:	6a 01                	push   $0x1
 358:	56                   	push   %esi
 359:	ff 75 c0             	push   -0x40(%ebp)
 35c:	e8 fe fe ff ff       	call   25f <write>
  while(--i >= 0)
 361:	89 f8                	mov    %edi,%eax
 363:	4f                   	dec    %edi
 364:	83 c4 10             	add    $0x10,%esp
 367:	39 d8                	cmp    %ebx,%eax
 369:	75 e5                	jne    350 <printint+0x60>
}
 36b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36e:	5b                   	pop    %ebx
 36f:	5e                   	pop    %esi
 370:	5f                   	pop    %edi
 371:	5d                   	pop    %ebp
 372:	c3                   	ret
 373:	90                   	nop
    x = -xx;
 374:	f7 da                	neg    %edx
 376:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 379:	eb 98                	jmp    313 <printint+0x23>
 37b:	90                   	nop

0000037c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	57                   	push   %edi
 380:	56                   	push   %esi
 381:	53                   	push   %ebx
 382:	83 ec 2c             	sub    $0x2c,%esp
 385:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 38b:	8a 03                	mov    (%ebx),%al
 38d:	84 c0                	test   %al,%al
 38f:	74 2a                	je     3bb <printf+0x3f>
 391:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 392:	8d 4d 10             	lea    0x10(%ebp),%ecx
 395:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 398:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 39b:	83 fa 25             	cmp    $0x25,%edx
 39e:	74 24                	je     3c4 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3a0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3a3:	50                   	push   %eax
 3a4:	6a 01                	push   $0x1
 3a6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3a9:	50                   	push   %eax
 3aa:	56                   	push   %esi
 3ab:	e8 af fe ff ff       	call   25f <write>
  for(i = 0; fmt[i]; i++){
 3b0:	43                   	inc    %ebx
 3b1:	8a 43 ff             	mov    -0x1(%ebx),%al
 3b4:	83 c4 10             	add    $0x10,%esp
 3b7:	84 c0                	test   %al,%al
 3b9:	75 dd                	jne    398 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3be:	5b                   	pop    %ebx
 3bf:	5e                   	pop    %esi
 3c0:	5f                   	pop    %edi
 3c1:	5d                   	pop    %ebp
 3c2:	c3                   	ret
 3c3:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3c4:	8a 13                	mov    (%ebx),%dl
 3c6:	84 d2                	test   %dl,%dl
 3c8:	74 f1                	je     3bb <printf+0x3f>
    c = fmt[i] & 0xff;
 3ca:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3cd:	80 fa 25             	cmp    $0x25,%dl
 3d0:	0f 84 fe 00 00 00    	je     4d4 <printf+0x158>
 3d6:	83 e8 63             	sub    $0x63,%eax
 3d9:	83 f8 15             	cmp    $0x15,%eax
 3dc:	77 0a                	ja     3e8 <printf+0x6c>
 3de:	ff 24 85 bc 06 00 00 	jmp    *0x6bc(,%eax,4)
 3e5:	8d 76 00             	lea    0x0(%esi),%esi
 3e8:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 3eb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3ef:	50                   	push   %eax
 3f0:	6a 01                	push   $0x1
 3f2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3f5:	57                   	push   %edi
 3f6:	56                   	push   %esi
 3f7:	e8 63 fe ff ff       	call   25f <write>
        putc(fd, c);
 3fc:	8a 55 d0             	mov    -0x30(%ebp),%dl
 3ff:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 402:	83 c4 0c             	add    $0xc,%esp
 405:	6a 01                	push   $0x1
 407:	57                   	push   %edi
 408:	56                   	push   %esi
 409:	e8 51 fe ff ff       	call   25f <write>
  for(i = 0; fmt[i]; i++){
 40e:	83 c3 02             	add    $0x2,%ebx
 411:	8a 43 ff             	mov    -0x1(%ebx),%al
 414:	83 c4 10             	add    $0x10,%esp
 417:	84 c0                	test   %al,%al
 419:	0f 85 79 ff ff ff    	jne    398 <printf+0x1c>
}
 41f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 422:	5b                   	pop    %ebx
 423:	5e                   	pop    %esi
 424:	5f                   	pop    %edi
 425:	5d                   	pop    %ebp
 426:	c3                   	ret
 427:	90                   	nop
        printint(fd, *ap, 16, 0);
 428:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 42b:	8b 17                	mov    (%edi),%edx
 42d:	83 ec 0c             	sub    $0xc,%esp
 430:	6a 00                	push   $0x0
 432:	b9 10 00 00 00       	mov    $0x10,%ecx
 437:	89 f0                	mov    %esi,%eax
 439:	e8 b2 fe ff ff       	call   2f0 <printint>
        ap++;
 43e:	83 c7 04             	add    $0x4,%edi
 441:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 444:	eb c8                	jmp    40e <printf+0x92>
 446:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 448:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 44b:	8b 01                	mov    (%ecx),%eax
        ap++;
 44d:	83 c1 04             	add    $0x4,%ecx
 450:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 453:	85 c0                	test   %eax,%eax
 455:	0f 84 89 00 00 00    	je     4e4 <printf+0x168>
        while(*s != 0){
 45b:	8a 10                	mov    (%eax),%dl
 45d:	84 d2                	test   %dl,%dl
 45f:	74 29                	je     48a <printf+0x10e>
 461:	89 c7                	mov    %eax,%edi
 463:	88 d0                	mov    %dl,%al
 465:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 468:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 46b:	89 fb                	mov    %edi,%ebx
 46d:	89 cf                	mov    %ecx,%edi
 46f:	90                   	nop
          putc(fd, *s);
 470:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 473:	50                   	push   %eax
 474:	6a 01                	push   $0x1
 476:	57                   	push   %edi
 477:	56                   	push   %esi
 478:	e8 e2 fd ff ff       	call   25f <write>
          s++;
 47d:	43                   	inc    %ebx
        while(*s != 0){
 47e:	8a 03                	mov    (%ebx),%al
 480:	83 c4 10             	add    $0x10,%esp
 483:	84 c0                	test   %al,%al
 485:	75 e9                	jne    470 <printf+0xf4>
 487:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 48a:	83 c3 02             	add    $0x2,%ebx
 48d:	8a 43 ff             	mov    -0x1(%ebx),%al
 490:	84 c0                	test   %al,%al
 492:	0f 85 00 ff ff ff    	jne    398 <printf+0x1c>
 498:	e9 1e ff ff ff       	jmp    3bb <printf+0x3f>
 49d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4a0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a3:	8b 17                	mov    (%edi),%edx
 4a5:	83 ec 0c             	sub    $0xc,%esp
 4a8:	6a 01                	push   $0x1
 4aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4af:	eb 86                	jmp    437 <printf+0xbb>
 4b1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4b7:	8b 00                	mov    (%eax),%eax
 4b9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4bc:	51                   	push   %ecx
 4bd:	6a 01                	push   $0x1
 4bf:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4c2:	57                   	push   %edi
 4c3:	56                   	push   %esi
 4c4:	e8 96 fd ff ff       	call   25f <write>
        ap++;
 4c9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4cd:	e9 3c ff ff ff       	jmp    40e <printf+0x92>
 4d2:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 4d4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4d7:	52                   	push   %edx
 4d8:	6a 01                	push   $0x1
 4da:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4dd:	e9 25 ff ff ff       	jmp    407 <printf+0x8b>
 4e2:	66 90                	xchg   %ax,%ax
          s = "(null)";
 4e4:	bf b4 06 00 00       	mov    $0x6b4,%edi
 4e9:	b0 28                	mov    $0x28,%al
 4eb:	e9 75 ff ff ff       	jmp    465 <printf+0xe9>

000004f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4f9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fc:	a1 28 07 00 00       	mov    0x728,%eax
 501:	8d 76 00             	lea    0x0(%esi),%esi
 504:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 506:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 508:	39 ca                	cmp    %ecx,%edx
 50a:	73 2c                	jae    538 <free+0x48>
 50c:	39 c1                	cmp    %eax,%ecx
 50e:	72 04                	jb     514 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 510:	39 c2                	cmp    %eax,%edx
 512:	72 f0                	jb     504 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 514:	8b 73 fc             	mov    -0x4(%ebx),%esi
 517:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 51a:	39 f8                	cmp    %edi,%eax
 51c:	74 2c                	je     54a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 51e:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 521:	8b 42 04             	mov    0x4(%edx),%eax
 524:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 527:	39 f1                	cmp    %esi,%ecx
 529:	74 36                	je     561 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 52b:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 52d:	89 15 28 07 00 00    	mov    %edx,0x728
}
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 538:	39 c2                	cmp    %eax,%edx
 53a:	72 c8                	jb     504 <free+0x14>
 53c:	39 c1                	cmp    %eax,%ecx
 53e:	73 c4                	jae    504 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 540:	8b 73 fc             	mov    -0x4(%ebx),%esi
 543:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 546:	39 f8                	cmp    %edi,%eax
 548:	75 d4                	jne    51e <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 54a:	03 70 04             	add    0x4(%eax),%esi
 54d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 550:	8b 02                	mov    (%edx),%eax
 552:	8b 00                	mov    (%eax),%eax
 554:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 557:	8b 42 04             	mov    0x4(%edx),%eax
 55a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 55d:	39 f1                	cmp    %esi,%ecx
 55f:	75 ca                	jne    52b <free+0x3b>
    p->s.size += bp->s.size;
 561:	03 43 fc             	add    -0x4(%ebx),%eax
 564:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 567:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 56a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 56c:	89 15 28 07 00 00    	mov    %edx,0x728
}
 572:	5b                   	pop    %ebx
 573:	5e                   	pop    %esi
 574:	5f                   	pop    %edi
 575:	5d                   	pop    %ebp
 576:	c3                   	ret
 577:	90                   	nop

00000578 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	57                   	push   %edi
 57c:	56                   	push   %esi
 57d:	53                   	push   %ebx
 57e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	8d 78 07             	lea    0x7(%eax),%edi
 587:	c1 ef 03             	shr    $0x3,%edi
 58a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 58b:	8b 15 28 07 00 00    	mov    0x728,%edx
 591:	85 d2                	test   %edx,%edx
 593:	0f 84 93 00 00 00    	je     62c <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 599:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 59b:	8b 48 04             	mov    0x4(%eax),%ecx
 59e:	39 f9                	cmp    %edi,%ecx
 5a0:	73 62                	jae    604 <malloc+0x8c>
  if(nu < 4096)
 5a2:	89 fb                	mov    %edi,%ebx
 5a4:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5aa:	72 78                	jb     624 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5ac:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5b3:	eb 0e                	jmp    5c3 <malloc+0x4b>
 5b5:	8d 76 00             	lea    0x0(%esi),%esi
 5b8:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ba:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5bc:	8b 48 04             	mov    0x4(%eax),%ecx
 5bf:	39 f9                	cmp    %edi,%ecx
 5c1:	73 41                	jae    604 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5c3:	39 05 28 07 00 00    	cmp    %eax,0x728
 5c9:	75 ed                	jne    5b8 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5cb:	83 ec 0c             	sub    $0xc,%esp
 5ce:	56                   	push   %esi
 5cf:	e8 f3 fc ff ff       	call   2c7 <sbrk>
  if(p == (char*)-1)
 5d4:	83 c4 10             	add    $0x10,%esp
 5d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 5da:	74 1c                	je     5f8 <malloc+0x80>
  hp->s.size = nu;
 5dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5df:	83 ec 0c             	sub    $0xc,%esp
 5e2:	83 c0 08             	add    $0x8,%eax
 5e5:	50                   	push   %eax
 5e6:	e8 05 ff ff ff       	call   4f0 <free>
  return freep;
 5eb:	8b 15 28 07 00 00    	mov    0x728,%edx
      if((p = morecore(nunits)) == 0)
 5f1:	83 c4 10             	add    $0x10,%esp
 5f4:	85 d2                	test   %edx,%edx
 5f6:	75 c2                	jne    5ba <malloc+0x42>
        return 0;
 5f8:	31 c0                	xor    %eax,%eax
  }
}
 5fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5fd:	5b                   	pop    %ebx
 5fe:	5e                   	pop    %esi
 5ff:	5f                   	pop    %edi
 600:	5d                   	pop    %ebp
 601:	c3                   	ret
 602:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 604:	39 cf                	cmp    %ecx,%edi
 606:	74 4c                	je     654 <malloc+0xdc>
        p->s.size -= nunits;
 608:	29 f9                	sub    %edi,%ecx
 60a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 60d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 610:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 613:	89 15 28 07 00 00    	mov    %edx,0x728
      return (void*)(p + 1);
 619:	83 c0 08             	add    $0x8,%eax
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret
  if(nu < 4096)
 624:	bb 00 10 00 00       	mov    $0x1000,%ebx
 629:	eb 81                	jmp    5ac <malloc+0x34>
 62b:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 62c:	c7 05 28 07 00 00 2c 	movl   $0x72c,0x728
 633:	07 00 00 
 636:	c7 05 2c 07 00 00 2c 	movl   $0x72c,0x72c
 63d:	07 00 00 
    base.s.size = 0;
 640:	c7 05 30 07 00 00 00 	movl   $0x0,0x730
 647:	00 00 00 
 64a:	b8 2c 07 00 00       	mov    $0x72c,%eax
 64f:	e9 4e ff ff ff       	jmp    5a2 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 654:	8b 08                	mov    (%eax),%ecx
 656:	89 0a                	mov    %ecx,(%edx)
 658:	eb b9                	jmp    613 <malloc+0x9b>
