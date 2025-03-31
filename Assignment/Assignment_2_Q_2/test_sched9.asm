
_test_sched9:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 8

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int i, pid;
    
    for (i = 0; i < NUM_CHILDREN; i++){
   f:	31 db                	xor    %ebx,%ebx
  11:	8d 76 00             	lea    0x0(%esi),%esi
        pid = custom_fork(1, 50);  // All delayed start, exec_time = 50
  14:	83 ec 08             	sub    $0x8,%esp
  17:	6a 32                	push   $0x32
  19:	6a 01                	push   $0x1
  1b:	e8 ef 02 00 00       	call   30f <custom_fork>
        if(pid < 0) {
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	78 5a                	js     81 <main+0x81>
            printf(1, "Failed to fork child %d\n", i);
            exit();
        }
        if(pid == 0) {
  27:	74 6b                	je     94 <main+0x94>
    for (i = 0; i < NUM_CHILDREN; i++){
  29:	43                   	inc    %ebx
  2a:	83 fb 08             	cmp    $0x8,%ebx
  2d:	75 e5                	jne    14 <main+0x14>
            int j;
            for(j = 0; j < 100000000; j++) ;  // Busy loop to simulate work.
            exit();
        }
    }
    printf(1, "[Parent] All child processes created.\n");
  2f:	52                   	push   %edx
  30:	52                   	push   %edx
  31:	68 cc 06 00 00       	push   $0x6cc
  36:	6a 01                	push   $0x1
  38:	e8 6f 03 00 00       	call   3ac <printf>
    sleep(400);
  3d:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
  44:	e8 b6 02 00 00       	call   2ff <sleep>
    printf(1, "[Parent] Calling scheduler_start()\n");
  49:	59                   	pop    %ecx
  4a:	58                   	pop    %eax
  4b:	68 f4 06 00 00       	push   $0x6f4
  50:	6a 01                	push   $0x1
  52:	e8 55 03 00 00       	call   3ac <printf>
    scheduler_start();
  57:	e8 bb 02 00 00       	call   317 <scheduler_start>
  5c:	83 c4 10             	add    $0x10,%esp
    for(i = 0; i < NUM_CHILDREN; i++){
        wait();
  5f:	e8 13 02 00 00       	call   277 <wait>
  64:	e8 0e 02 00 00       	call   277 <wait>
    for(i = 0; i < NUM_CHILDREN; i++){
  69:	83 eb 02             	sub    $0x2,%ebx
  6c:	75 f1                	jne    5f <main+0x5f>
    }
    printf(1, "[Parent] All child processes completed.\n");
  6e:	50                   	push   %eax
  6f:	50                   	push   %eax
  70:	68 18 07 00 00       	push   $0x718
  75:	6a 01                	push   $0x1
  77:	e8 30 03 00 00       	call   3ac <printf>
    exit();
  7c:	e8 ee 01 00 00       	call   26f <exit>
            printf(1, "Failed to fork child %d\n", i);
  81:	50                   	push   %eax
  82:	53                   	push   %ebx
  83:	68 8c 06 00 00       	push   $0x68c
  88:	6a 01                	push   $0x1
  8a:	e8 1d 03 00 00       	call   3ac <printf>
            exit();
  8f:	e8 db 01 00 00       	call   26f <exit>
            printf(1, "[Child %d] (PID: %d) started\n", i, getpid());
  94:	e8 56 02 00 00       	call   2ef <getpid>
  99:	50                   	push   %eax
  9a:	53                   	push   %ebx
  9b:	68 a5 06 00 00       	push   $0x6a5
  a0:	6a 01                	push   $0x1
  a2:	e8 05 03 00 00       	call   3ac <printf>
            exit();
  a7:	e8 c3 01 00 00       	call   26f <exit>

000000ac <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	53                   	push   %ebx
  b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b6:	31 c0                	xor    %eax,%eax
  b8:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  bb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  be:	40                   	inc    %eax
  bf:	84 d2                	test   %dl,%dl
  c1:	75 f5                	jne    b8 <strcpy+0xc>
    ;
  return os;
}
  c3:	89 c8                	mov    %ecx,%eax
  c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c8:	c9                   	leave
  c9:	c3                   	ret
  ca:	66 90                	xchg   %ax,%ax

000000cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	53                   	push   %ebx
  d0:	8b 55 08             	mov    0x8(%ebp),%edx
  d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  d6:	0f b6 02             	movzbl (%edx),%eax
  d9:	84 c0                	test   %al,%al
  db:	75 10                	jne    ed <strcmp+0x21>
  dd:	eb 2a                	jmp    109 <strcmp+0x3d>
  df:	90                   	nop
    p++, q++;
  e0:	42                   	inc    %edx
  e1:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  e4:	0f b6 02             	movzbl (%edx),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 11                	je     fc <strcmp+0x30>
  eb:	89 cb                	mov    %ecx,%ebx
  ed:	0f b6 0b             	movzbl (%ebx),%ecx
  f0:	38 c1                	cmp    %al,%cl
  f2:	74 ec                	je     e0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  f4:	29 c8                	sub    %ecx,%eax
}
  f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f9:	c9                   	leave
  fa:	c3                   	ret
  fb:	90                   	nop
  return (uchar)*p - (uchar)*q;
  fc:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 100:	31 c0                	xor    %eax,%eax
 102:	29 c8                	sub    %ecx,%eax
}
 104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 107:	c9                   	leave
 108:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 109:	0f b6 0b             	movzbl (%ebx),%ecx
 10c:	31 c0                	xor    %eax,%eax
 10e:	eb e4                	jmp    f4 <strcmp+0x28>

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	40                   	inc    %eax
 121:	89 c1                	mov    %eax,%ecx
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	75 f7                	jne    120 <strlen+0x10>
    ;
  return n;
}
 129:	89 c8                	mov    %ecx,%eax
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret
 12d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 130:	31 c9                	xor    %ecx,%ecx
}
 132:	89 c8                	mov    %ecx,%eax
 134:	5d                   	pop    %ebp
 135:	c3                   	ret
 136:	66 90                	xchg   %ax,%ax

00000138 <memset>:

void*
memset(void *dst, int c, uint n)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 13c:	8b 7d 08             	mov    0x8(%ebp),%edi
 13f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	fc                   	cld
 146:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 14e:	c9                   	leave
 14f:	c3                   	ret

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 159:	8a 10                	mov    (%eax),%dl
 15b:	84 d2                	test   %dl,%dl
 15d:	75 0c                	jne    16b <strchr+0x1b>
 15f:	eb 13                	jmp    174 <strchr+0x24>
 161:	8d 76 00             	lea    0x0(%esi),%esi
 164:	40                   	inc    %eax
 165:	8a 10                	mov    (%eax),%dl
 167:	84 d2                	test   %dl,%dl
 169:	74 09                	je     174 <strchr+0x24>
    if(*s == c)
 16b:	38 d1                	cmp    %dl,%cl
 16d:	75 f5                	jne    164 <strchr+0x14>
      return (char*)s;
  return 0;
}
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret
 171:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 174:	31 c0                	xor    %eax,%eax
}
 176:	5d                   	pop    %ebp
 177:	c3                   	ret

00000178 <gets>:

char*
gets(char *buf, int max)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	57                   	push   %edi
 17c:	56                   	push   %esi
 17d:	53                   	push   %ebx
 17e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 183:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 186:	eb 24                	jmp    1ac <gets+0x34>
    cc = read(0, &c, 1);
 188:	50                   	push   %eax
 189:	6a 01                	push   $0x1
 18b:	56                   	push   %esi
 18c:	6a 00                	push   $0x0
 18e:	e8 f4 00 00 00       	call   287 <read>
    if(cc < 1)
 193:	83 c4 10             	add    $0x10,%esp
 196:	85 c0                	test   %eax,%eax
 198:	7e 1a                	jle    1b4 <gets+0x3c>
      break;
    buf[i++] = c;
 19a:	8a 45 e7             	mov    -0x19(%ebp),%al
 19d:	8b 55 08             	mov    0x8(%ebp),%edx
 1a0:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1a4:	3c 0a                	cmp    $0xa,%al
 1a6:	74 0e                	je     1b6 <gets+0x3e>
 1a8:	3c 0d                	cmp    $0xd,%al
 1aa:	74 0a                	je     1b6 <gets+0x3e>
  for(i=0; i+1 < max; ){
 1ac:	89 df                	mov    %ebx,%edi
 1ae:	43                   	inc    %ebx
 1af:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b2:	7c d4                	jl     188 <gets+0x10>
 1b4:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c0:	5b                   	pop    %ebx
 1c1:	5e                   	pop    %esi
 1c2:	5f                   	pop    %edi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret
 1c5:	8d 76 00             	lea    0x0(%esi),%esi

000001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	56                   	push   %esi
 1cc:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cd:	83 ec 08             	sub    $0x8,%esp
 1d0:	6a 00                	push   $0x0
 1d2:	ff 75 08             	push   0x8(%ebp)
 1d5:	e8 d5 00 00 00       	call   2af <open>
  if(fd < 0)
 1da:	83 c4 10             	add    $0x10,%esp
 1dd:	85 c0                	test   %eax,%eax
 1df:	78 27                	js     208 <stat+0x40>
 1e1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	ff 75 0c             	push   0xc(%ebp)
 1e9:	50                   	push   %eax
 1ea:	e8 d8 00 00 00       	call   2c7 <fstat>
 1ef:	89 c6                	mov    %eax,%esi
  close(fd);
 1f1:	89 1c 24             	mov    %ebx,(%esp)
 1f4:	e8 9e 00 00 00       	call   297 <close>
  return r;
 1f9:	83 c4 10             	add    $0x10,%esp
}
 1fc:	89 f0                	mov    %esi,%eax
 1fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
 201:	5b                   	pop    %ebx
 202:	5e                   	pop    %esi
 203:	5d                   	pop    %ebp
 204:	c3                   	ret
 205:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 208:	be ff ff ff ff       	mov    $0xffffffff,%esi
 20d:	eb ed                	jmp    1fc <stat+0x34>
 20f:	90                   	nop

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	0f be 01             	movsbl (%ecx),%eax
 21a:	8d 50 d0             	lea    -0x30(%eax),%edx
 21d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 220:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 225:	77 16                	ja     23d <atoi+0x2d>
 227:	90                   	nop
    n = n*10 + *s++ - '0';
 228:	41                   	inc    %ecx
 229:	8d 14 92             	lea    (%edx,%edx,4),%edx
 22c:	01 d2                	add    %edx,%edx
 22e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 232:	0f be 01             	movsbl (%ecx),%eax
 235:	8d 58 d0             	lea    -0x30(%eax),%ebx
 238:	80 fb 09             	cmp    $0x9,%bl
 23b:	76 eb                	jbe    228 <atoi+0x18>
  return n;
}
 23d:	89 d0                	mov    %edx,%eax
 23f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 242:	c9                   	leave
 243:	c3                   	ret

00000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	56                   	push   %esi
 249:	8b 55 08             	mov    0x8(%ebp),%edx
 24c:	8b 75 0c             	mov    0xc(%ebp),%esi
 24f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 252:	85 c0                	test   %eax,%eax
 254:	7e 0b                	jle    261 <memmove+0x1d>
 256:	01 d0                	add    %edx,%eax
  dst = vdst;
 258:	89 d7                	mov    %edx,%edi
 25a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 25c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 25d:	39 f8                	cmp    %edi,%eax
 25f:	75 fb                	jne    25c <memmove+0x18>
  return vdst;
}
 261:	89 d0                	mov    %edx,%eax
 263:	5e                   	pop    %esi
 264:	5f                   	pop    %edi
 265:	5d                   	pop    %ebp
 266:	c3                   	ret

00000267 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 267:	b8 01 00 00 00       	mov    $0x1,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret

0000026f <exit>:
SYSCALL(exit)
 26f:	b8 02 00 00 00       	mov    $0x2,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret

00000277 <wait>:
SYSCALL(wait)
 277:	b8 03 00 00 00       	mov    $0x3,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <pipe>:
SYSCALL(pipe)
 27f:	b8 04 00 00 00       	mov    $0x4,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <read>:
SYSCALL(read)
 287:	b8 05 00 00 00       	mov    $0x5,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <write>:
SYSCALL(write)
 28f:	b8 10 00 00 00       	mov    $0x10,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <close>:
SYSCALL(close)
 297:	b8 15 00 00 00       	mov    $0x15,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <kill>:
SYSCALL(kill)
 29f:	b8 06 00 00 00       	mov    $0x6,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <exec>:
SYSCALL(exec)
 2a7:	b8 07 00 00 00       	mov    $0x7,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <open>:
SYSCALL(open)
 2af:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <mknod>:
SYSCALL(mknod)
 2b7:	b8 11 00 00 00       	mov    $0x11,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <unlink>:
SYSCALL(unlink)
 2bf:	b8 12 00 00 00       	mov    $0x12,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <fstat>:
SYSCALL(fstat)
 2c7:	b8 08 00 00 00       	mov    $0x8,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <link>:
SYSCALL(link)
 2cf:	b8 13 00 00 00       	mov    $0x13,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <mkdir>:
SYSCALL(mkdir)
 2d7:	b8 14 00 00 00       	mov    $0x14,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <chdir>:
SYSCALL(chdir)
 2df:	b8 09 00 00 00       	mov    $0x9,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <dup>:
SYSCALL(dup)
 2e7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <getpid>:
SYSCALL(getpid)
 2ef:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <sbrk>:
SYSCALL(sbrk)
 2f7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <sleep>:
SYSCALL(sleep)
 2ff:	b8 0d 00 00 00       	mov    $0xd,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <uptime>:
SYSCALL(uptime)
 307:	b8 0e 00 00 00       	mov    $0xe,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <custom_fork>:
SYSCALL(custom_fork)
 30f:	b8 17 00 00 00       	mov    $0x17,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <scheduler_start>:
SYSCALL(scheduler_start)
 317:	b8 18 00 00 00       	mov    $0x18,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret
 31f:	90                   	nop

00000320 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
 326:	83 ec 3c             	sub    $0x3c,%esp
 329:	89 45 c0             	mov    %eax,-0x40(%ebp)
 32c:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 331:	85 c9                	test   %ecx,%ecx
 333:	74 04                	je     339 <printint+0x19>
 335:	85 d2                	test   %edx,%edx
 337:	78 6b                	js     3a4 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 339:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 33c:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 343:	31 c9                	xor    %ecx,%ecx
 345:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 348:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 34b:	31 d2                	xor    %edx,%edx
 34d:	f7 f3                	div    %ebx
 34f:	89 cf                	mov    %ecx,%edi
 351:	8d 49 01             	lea    0x1(%ecx),%ecx
 354:	8a 92 9c 07 00 00    	mov    0x79c(%edx),%dl
 35a:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 35e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 361:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 364:	39 da                	cmp    %ebx,%edx
 366:	73 e0                	jae    348 <printint+0x28>
  if(neg)
 368:	8b 55 08             	mov    0x8(%ebp),%edx
 36b:	85 d2                	test   %edx,%edx
 36d:	74 07                	je     376 <printint+0x56>
    buf[i++] = '-';
 36f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 374:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 376:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 379:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 37d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 380:	8a 07                	mov    (%edi),%al
 382:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 385:	50                   	push   %eax
 386:	6a 01                	push   $0x1
 388:	56                   	push   %esi
 389:	ff 75 c0             	push   -0x40(%ebp)
 38c:	e8 fe fe ff ff       	call   28f <write>
  while(--i >= 0)
 391:	89 f8                	mov    %edi,%eax
 393:	4f                   	dec    %edi
 394:	83 c4 10             	add    $0x10,%esp
 397:	39 d8                	cmp    %ebx,%eax
 399:	75 e5                	jne    380 <printint+0x60>
}
 39b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39e:	5b                   	pop    %ebx
 39f:	5e                   	pop    %esi
 3a0:	5f                   	pop    %edi
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret
 3a3:	90                   	nop
    x = -xx;
 3a4:	f7 da                	neg    %edx
 3a6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3a9:	eb 98                	jmp    343 <printint+0x23>
 3ab:	90                   	nop

000003ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	53                   	push   %ebx
 3b2:	83 ec 2c             	sub    $0x2c,%esp
 3b5:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3bb:	8a 03                	mov    (%ebx),%al
 3bd:	84 c0                	test   %al,%al
 3bf:	74 2a                	je     3eb <printf+0x3f>
 3c1:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3c2:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3c5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3c8:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3cb:	83 fa 25             	cmp    $0x25,%edx
 3ce:	74 24                	je     3f4 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3d0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3d3:	50                   	push   %eax
 3d4:	6a 01                	push   $0x1
 3d6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3d9:	50                   	push   %eax
 3da:	56                   	push   %esi
 3db:	e8 af fe ff ff       	call   28f <write>
  for(i = 0; fmt[i]; i++){
 3e0:	43                   	inc    %ebx
 3e1:	8a 43 ff             	mov    -0x1(%ebx),%al
 3e4:	83 c4 10             	add    $0x10,%esp
 3e7:	84 c0                	test   %al,%al
 3e9:	75 dd                	jne    3c8 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ee:	5b                   	pop    %ebx
 3ef:	5e                   	pop    %esi
 3f0:	5f                   	pop    %edi
 3f1:	5d                   	pop    %ebp
 3f2:	c3                   	ret
 3f3:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3f4:	8a 13                	mov    (%ebx),%dl
 3f6:	84 d2                	test   %dl,%dl
 3f8:	74 f1                	je     3eb <printf+0x3f>
    c = fmt[i] & 0xff;
 3fa:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 3fd:	80 fa 25             	cmp    $0x25,%dl
 400:	0f 84 fe 00 00 00    	je     504 <printf+0x158>
 406:	83 e8 63             	sub    $0x63,%eax
 409:	83 f8 15             	cmp    $0x15,%eax
 40c:	77 0a                	ja     418 <printf+0x6c>
 40e:	ff 24 85 44 07 00 00 	jmp    *0x744(,%eax,4)
 415:	8d 76 00             	lea    0x0(%esi),%esi
 418:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 41b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 41f:	50                   	push   %eax
 420:	6a 01                	push   $0x1
 422:	8d 7d e7             	lea    -0x19(%ebp),%edi
 425:	57                   	push   %edi
 426:	56                   	push   %esi
 427:	e8 63 fe ff ff       	call   28f <write>
        putc(fd, c);
 42c:	8a 55 d0             	mov    -0x30(%ebp),%dl
 42f:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 432:	83 c4 0c             	add    $0xc,%esp
 435:	6a 01                	push   $0x1
 437:	57                   	push   %edi
 438:	56                   	push   %esi
 439:	e8 51 fe ff ff       	call   28f <write>
  for(i = 0; fmt[i]; i++){
 43e:	83 c3 02             	add    $0x2,%ebx
 441:	8a 43 ff             	mov    -0x1(%ebx),%al
 444:	83 c4 10             	add    $0x10,%esp
 447:	84 c0                	test   %al,%al
 449:	0f 85 79 ff ff ff    	jne    3c8 <printf+0x1c>
}
 44f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 452:	5b                   	pop    %ebx
 453:	5e                   	pop    %esi
 454:	5f                   	pop    %edi
 455:	5d                   	pop    %ebp
 456:	c3                   	ret
 457:	90                   	nop
        printint(fd, *ap, 16, 0);
 458:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 45b:	8b 17                	mov    (%edi),%edx
 45d:	83 ec 0c             	sub    $0xc,%esp
 460:	6a 00                	push   $0x0
 462:	b9 10 00 00 00       	mov    $0x10,%ecx
 467:	89 f0                	mov    %esi,%eax
 469:	e8 b2 fe ff ff       	call   320 <printint>
        ap++;
 46e:	83 c7 04             	add    $0x4,%edi
 471:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 474:	eb c8                	jmp    43e <printf+0x92>
 476:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 478:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 47b:	8b 01                	mov    (%ecx),%eax
        ap++;
 47d:	83 c1 04             	add    $0x4,%ecx
 480:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 483:	85 c0                	test   %eax,%eax
 485:	0f 84 89 00 00 00    	je     514 <printf+0x168>
        while(*s != 0){
 48b:	8a 10                	mov    (%eax),%dl
 48d:	84 d2                	test   %dl,%dl
 48f:	74 29                	je     4ba <printf+0x10e>
 491:	89 c7                	mov    %eax,%edi
 493:	88 d0                	mov    %dl,%al
 495:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 498:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 49b:	89 fb                	mov    %edi,%ebx
 49d:	89 cf                	mov    %ecx,%edi
 49f:	90                   	nop
          putc(fd, *s);
 4a0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4a3:	50                   	push   %eax
 4a4:	6a 01                	push   $0x1
 4a6:	57                   	push   %edi
 4a7:	56                   	push   %esi
 4a8:	e8 e2 fd ff ff       	call   28f <write>
          s++;
 4ad:	43                   	inc    %ebx
        while(*s != 0){
 4ae:	8a 03                	mov    (%ebx),%al
 4b0:	83 c4 10             	add    $0x10,%esp
 4b3:	84 c0                	test   %al,%al
 4b5:	75 e9                	jne    4a0 <printf+0xf4>
 4b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4ba:	83 c3 02             	add    $0x2,%ebx
 4bd:	8a 43 ff             	mov    -0x1(%ebx),%al
 4c0:	84 c0                	test   %al,%al
 4c2:	0f 85 00 ff ff ff    	jne    3c8 <printf+0x1c>
 4c8:	e9 1e ff ff ff       	jmp    3eb <printf+0x3f>
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d3:	8b 17                	mov    (%edi),%edx
 4d5:	83 ec 0c             	sub    $0xc,%esp
 4d8:	6a 01                	push   $0x1
 4da:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4df:	eb 86                	jmp    467 <printf+0xbb>
 4e1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4e7:	8b 00                	mov    (%eax),%eax
 4e9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ec:	51                   	push   %ecx
 4ed:	6a 01                	push   $0x1
 4ef:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4f2:	57                   	push   %edi
 4f3:	56                   	push   %esi
 4f4:	e8 96 fd ff ff       	call   28f <write>
        ap++;
 4f9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4fd:	e9 3c ff ff ff       	jmp    43e <printf+0x92>
 502:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 504:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 507:	52                   	push   %edx
 508:	6a 01                	push   $0x1
 50a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 50d:	e9 25 ff ff ff       	jmp    437 <printf+0x8b>
 512:	66 90                	xchg   %ax,%ax
          s = "(null)";
 514:	bf c3 06 00 00       	mov    $0x6c3,%edi
 519:	b0 28                	mov    $0x28,%al
 51b:	e9 75 ff ff ff       	jmp    495 <printf+0xe9>

00000520 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 529:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 52c:	a1 b0 07 00 00       	mov    0x7b0,%eax
 531:	8d 76 00             	lea    0x0(%esi),%esi
 534:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 536:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 538:	39 ca                	cmp    %ecx,%edx
 53a:	73 2c                	jae    568 <free+0x48>
 53c:	39 c1                	cmp    %eax,%ecx
 53e:	72 04                	jb     544 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 540:	39 c2                	cmp    %eax,%edx
 542:	72 f0                	jb     534 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 544:	8b 73 fc             	mov    -0x4(%ebx),%esi
 547:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 54a:	39 f8                	cmp    %edi,%eax
 54c:	74 2c                	je     57a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 54e:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 551:	8b 42 04             	mov    0x4(%edx),%eax
 554:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 557:	39 f1                	cmp    %esi,%ecx
 559:	74 36                	je     591 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 55b:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 55d:	89 15 b0 07 00 00    	mov    %edx,0x7b0
}
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 568:	39 c2                	cmp    %eax,%edx
 56a:	72 c8                	jb     534 <free+0x14>
 56c:	39 c1                	cmp    %eax,%ecx
 56e:	73 c4                	jae    534 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 570:	8b 73 fc             	mov    -0x4(%ebx),%esi
 573:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 576:	39 f8                	cmp    %edi,%eax
 578:	75 d4                	jne    54e <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 57a:	03 70 04             	add    0x4(%eax),%esi
 57d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 580:	8b 02                	mov    (%edx),%eax
 582:	8b 00                	mov    (%eax),%eax
 584:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 587:	8b 42 04             	mov    0x4(%edx),%eax
 58a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 58d:	39 f1                	cmp    %esi,%ecx
 58f:	75 ca                	jne    55b <free+0x3b>
    p->s.size += bp->s.size;
 591:	03 43 fc             	add    -0x4(%ebx),%eax
 594:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 597:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 59a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 59c:	89 15 b0 07 00 00    	mov    %edx,0x7b0
}
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret
 5a7:	90                   	nop

000005a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5a8:	55                   	push   %ebp
 5a9:	89 e5                	mov    %esp,%ebp
 5ab:	57                   	push   %edi
 5ac:	56                   	push   %esi
 5ad:	53                   	push   %ebx
 5ae:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	8d 78 07             	lea    0x7(%eax),%edi
 5b7:	c1 ef 03             	shr    $0x3,%edi
 5ba:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5bb:	8b 15 b0 07 00 00    	mov    0x7b0,%edx
 5c1:	85 d2                	test   %edx,%edx
 5c3:	0f 84 93 00 00 00    	je     65c <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5cb:	8b 48 04             	mov    0x4(%eax),%ecx
 5ce:	39 f9                	cmp    %edi,%ecx
 5d0:	73 62                	jae    634 <malloc+0x8c>
  if(nu < 4096)
 5d2:	89 fb                	mov    %edi,%ebx
 5d4:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5da:	72 78                	jb     654 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5dc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5e3:	eb 0e                	jmp    5f3 <malloc+0x4b>
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
 5e8:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ea:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ec:	8b 48 04             	mov    0x4(%eax),%ecx
 5ef:	39 f9                	cmp    %edi,%ecx
 5f1:	73 41                	jae    634 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5f3:	39 05 b0 07 00 00    	cmp    %eax,0x7b0
 5f9:	75 ed                	jne    5e8 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 5fb:	83 ec 0c             	sub    $0xc,%esp
 5fe:	56                   	push   %esi
 5ff:	e8 f3 fc ff ff       	call   2f7 <sbrk>
  if(p == (char*)-1)
 604:	83 c4 10             	add    $0x10,%esp
 607:	83 f8 ff             	cmp    $0xffffffff,%eax
 60a:	74 1c                	je     628 <malloc+0x80>
  hp->s.size = nu;
 60c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 60f:	83 ec 0c             	sub    $0xc,%esp
 612:	83 c0 08             	add    $0x8,%eax
 615:	50                   	push   %eax
 616:	e8 05 ff ff ff       	call   520 <free>
  return freep;
 61b:	8b 15 b0 07 00 00    	mov    0x7b0,%edx
      if((p = morecore(nunits)) == 0)
 621:	83 c4 10             	add    $0x10,%esp
 624:	85 d2                	test   %edx,%edx
 626:	75 c2                	jne    5ea <malloc+0x42>
        return 0;
 628:	31 c0                	xor    %eax,%eax
  }
}
 62a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62d:	5b                   	pop    %ebx
 62e:	5e                   	pop    %esi
 62f:	5f                   	pop    %edi
 630:	5d                   	pop    %ebp
 631:	c3                   	ret
 632:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 634:	39 cf                	cmp    %ecx,%edi
 636:	74 4c                	je     684 <malloc+0xdc>
        p->s.size -= nunits;
 638:	29 f9                	sub    %edi,%ecx
 63a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 63d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 640:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 643:	89 15 b0 07 00 00    	mov    %edx,0x7b0
      return (void*)(p + 1);
 649:	83 c0 08             	add    $0x8,%eax
}
 64c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64f:	5b                   	pop    %ebx
 650:	5e                   	pop    %esi
 651:	5f                   	pop    %edi
 652:	5d                   	pop    %ebp
 653:	c3                   	ret
  if(nu < 4096)
 654:	bb 00 10 00 00       	mov    $0x1000,%ebx
 659:	eb 81                	jmp    5dc <malloc+0x34>
 65b:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 65c:	c7 05 b0 07 00 00 b4 	movl   $0x7b4,0x7b0
 663:	07 00 00 
 666:	c7 05 b4 07 00 00 b4 	movl   $0x7b4,0x7b4
 66d:	07 00 00 
    base.s.size = 0;
 670:	c7 05 b8 07 00 00 00 	movl   $0x0,0x7b8
 677:	00 00 00 
 67a:	b8 b4 07 00 00       	mov    $0x7b4,%eax
 67f:	e9 4e ff ff ff       	jmp    5d2 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 684:	8b 08                	mov    (%eax),%ecx
 686:	89 0a                	mov    %ecx,(%edx)
 688:	eb b9                	jmp    643 <malloc+0x9b>
