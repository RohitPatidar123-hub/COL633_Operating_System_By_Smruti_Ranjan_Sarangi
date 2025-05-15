
_test_sched9:     file format elf32-i386


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
    
    for (i = 0; i < NUM_CHILDREN; i++){
   f:	31 db                	xor    %ebx,%ebx
        pid = custom_fork(0, 10);  // All delayed start, exec_time = 50
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 0a                	push   $0xa
  16:	6a 00                	push   $0x0
  18:	e8 fa 02 00 00       	call   317 <custom_fork>
        if(pid < 0) {
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	78 5d                	js     81 <main+0x81>
            printf(1, "Failed to fork child %d\n", i);
            exit();
        }
        if(pid == 0) {
  24:	74 6e                	je     94 <main+0x94>
    for (i = 0; i < NUM_CHILDREN; i++){
  26:	43                   	inc    %ebx
  27:	83 fb 04             	cmp    $0x4,%ebx
  2a:	75 e5                	jne    11 <main+0x11>
            int j;
            for(j = 0; j < 100000000; j++) ;  // Busy loop to simulate work.
            exit();
        }
    }
    printf(1, "[Parent] All child processes created.\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 d4 06 00 00       	push   $0x6d4
  34:	6a 01                	push   $0x1
  36:	e8 79 03 00 00       	call   3b4 <printf>
    sleep(400);
  3b:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
  42:	e8 b8 02 00 00       	call   2ff <sleep>
    printf(1, "[Parent] Calling scheduler_start()\n");
  47:	58                   	pop    %eax
  48:	5a                   	pop    %edx
  49:	68 fc 06 00 00       	push   $0x6fc
  4e:	6a 01                	push   $0x1
  50:	e8 5f 03 00 00       	call   3b4 <printf>
    scheduler_start();
  55:	e8 c5 02 00 00       	call   31f <scheduler_start>
    for(i = 0; i < NUM_CHILDREN; i++){
        wait();
  5a:	e8 18 02 00 00       	call   277 <wait>
  5f:	e8 13 02 00 00       	call   277 <wait>
  64:	e8 0e 02 00 00       	call   277 <wait>
  69:	e8 09 02 00 00       	call   277 <wait>
    }
    printf(1, "[Parent] All child processes completed.\n");
  6e:	59                   	pop    %ecx
  6f:	5b                   	pop    %ebx
  70:	68 20 07 00 00       	push   $0x720
  75:	6a 01                	push   $0x1
  77:	e8 38 03 00 00       	call   3b4 <printf>
    exit();
  7c:	e8 ee 01 00 00       	call   26f <exit>
            printf(1, "Failed to fork child %d\n", i);
  81:	50                   	push   %eax
  82:	53                   	push   %ebx
  83:	68 94 06 00 00       	push   $0x694
  88:	6a 01                	push   $0x1
  8a:	e8 25 03 00 00       	call   3b4 <printf>
            exit();
  8f:	e8 db 01 00 00       	call   26f <exit>
            printf(1, "[Child %d] (PID: %d) started\n", i, getpid());
  94:	e8 56 02 00 00       	call   2ef <getpid>
  99:	50                   	push   %eax
  9a:	53                   	push   %ebx
  9b:	68 ad 06 00 00       	push   $0x6ad
  a0:	6a 01                	push   $0x1
  a2:	e8 0d 03 00 00       	call   3b4 <printf>
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

0000030f <signal>:
SYSCALL(signal)
 30f:	b8 16 00 00 00       	mov    $0x16,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <custom_fork>:
SYSCALL(custom_fork)
 317:	b8 17 00 00 00       	mov    $0x17,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <scheduler_start>:
 31f:	b8 18 00 00 00       	mov    $0x18,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret
 327:	90                   	nop

00000328 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	57                   	push   %edi
 32c:	56                   	push   %esi
 32d:	53                   	push   %ebx
 32e:	83 ec 3c             	sub    $0x3c,%esp
 331:	89 45 c0             	mov    %eax,-0x40(%ebp)
 334:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 336:	8b 4d 08             	mov    0x8(%ebp),%ecx
 339:	85 c9                	test   %ecx,%ecx
 33b:	74 04                	je     341 <printint+0x19>
 33d:	85 d2                	test   %edx,%edx
 33f:	78 6b                	js     3ac <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 341:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 344:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 34b:	31 c9                	xor    %ecx,%ecx
 34d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 350:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 353:	31 d2                	xor    %edx,%edx
 355:	f7 f3                	div    %ebx
 357:	89 cf                	mov    %ecx,%edi
 359:	8d 49 01             	lea    0x1(%ecx),%ecx
 35c:	8a 92 a4 07 00 00    	mov    0x7a4(%edx),%dl
 362:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 366:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 369:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 36c:	39 da                	cmp    %ebx,%edx
 36e:	73 e0                	jae    350 <printint+0x28>
  if(neg)
 370:	8b 55 08             	mov    0x8(%ebp),%edx
 373:	85 d2                	test   %edx,%edx
 375:	74 07                	je     37e <printint+0x56>
    buf[i++] = '-';
 377:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 37c:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 37e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 381:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 385:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 388:	8a 07                	mov    (%edi),%al
 38a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 38d:	50                   	push   %eax
 38e:	6a 01                	push   $0x1
 390:	56                   	push   %esi
 391:	ff 75 c0             	push   -0x40(%ebp)
 394:	e8 f6 fe ff ff       	call   28f <write>
  while(--i >= 0)
 399:	89 f8                	mov    %edi,%eax
 39b:	4f                   	dec    %edi
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	39 d8                	cmp    %ebx,%eax
 3a1:	75 e5                	jne    388 <printint+0x60>
}
 3a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret
 3ab:	90                   	nop
    x = -xx;
 3ac:	f7 da                	neg    %edx
 3ae:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 3b1:	eb 98                	jmp    34b <printint+0x23>
 3b3:	90                   	nop

000003b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	57                   	push   %edi
 3b8:	56                   	push   %esi
 3b9:	53                   	push   %ebx
 3ba:	83 ec 2c             	sub    $0x2c,%esp
 3bd:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3c3:	8a 03                	mov    (%ebx),%al
 3c5:	84 c0                	test   %al,%al
 3c7:	74 2a                	je     3f3 <printf+0x3f>
 3c9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3ca:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3cd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 3d0:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 3d3:	83 fa 25             	cmp    $0x25,%edx
 3d6:	74 24                	je     3fc <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 3d8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 3db:	50                   	push   %eax
 3dc:	6a 01                	push   $0x1
 3de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3e1:	50                   	push   %eax
 3e2:	56                   	push   %esi
 3e3:	e8 a7 fe ff ff       	call   28f <write>
  for(i = 0; fmt[i]; i++){
 3e8:	43                   	inc    %ebx
 3e9:	8a 43 ff             	mov    -0x1(%ebx),%al
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	84 c0                	test   %al,%al
 3f1:	75 dd                	jne    3d0 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret
 3fb:	90                   	nop
  for(i = 0; fmt[i]; i++){
 3fc:	8a 13                	mov    (%ebx),%dl
 3fe:	84 d2                	test   %dl,%dl
 400:	74 f1                	je     3f3 <printf+0x3f>
    c = fmt[i] & 0xff;
 402:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 405:	80 fa 25             	cmp    $0x25,%dl
 408:	0f 84 fe 00 00 00    	je     50c <printf+0x158>
 40e:	83 e8 63             	sub    $0x63,%eax
 411:	83 f8 15             	cmp    $0x15,%eax
 414:	77 0a                	ja     420 <printf+0x6c>
 416:	ff 24 85 4c 07 00 00 	jmp    *0x74c(,%eax,4)
 41d:	8d 76 00             	lea    0x0(%esi),%esi
 420:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 423:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 427:	50                   	push   %eax
 428:	6a 01                	push   $0x1
 42a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 42d:	57                   	push   %edi
 42e:	56                   	push   %esi
 42f:	e8 5b fe ff ff       	call   28f <write>
        putc(fd, c);
 434:	8a 55 d0             	mov    -0x30(%ebp),%dl
 437:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 43a:	83 c4 0c             	add    $0xc,%esp
 43d:	6a 01                	push   $0x1
 43f:	57                   	push   %edi
 440:	56                   	push   %esi
 441:	e8 49 fe ff ff       	call   28f <write>
  for(i = 0; fmt[i]; i++){
 446:	83 c3 02             	add    $0x2,%ebx
 449:	8a 43 ff             	mov    -0x1(%ebx),%al
 44c:	83 c4 10             	add    $0x10,%esp
 44f:	84 c0                	test   %al,%al
 451:	0f 85 79 ff ff ff    	jne    3d0 <printf+0x1c>
}
 457:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45a:	5b                   	pop    %ebx
 45b:	5e                   	pop    %esi
 45c:	5f                   	pop    %edi
 45d:	5d                   	pop    %ebp
 45e:	c3                   	ret
 45f:	90                   	nop
        printint(fd, *ap, 16, 0);
 460:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 463:	8b 17                	mov    (%edi),%edx
 465:	83 ec 0c             	sub    $0xc,%esp
 468:	6a 00                	push   $0x0
 46a:	b9 10 00 00 00       	mov    $0x10,%ecx
 46f:	89 f0                	mov    %esi,%eax
 471:	e8 b2 fe ff ff       	call   328 <printint>
        ap++;
 476:	83 c7 04             	add    $0x4,%edi
 479:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 47c:	eb c8                	jmp    446 <printf+0x92>
 47e:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 480:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 483:	8b 01                	mov    (%ecx),%eax
        ap++;
 485:	83 c1 04             	add    $0x4,%ecx
 488:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 48b:	85 c0                	test   %eax,%eax
 48d:	0f 84 89 00 00 00    	je     51c <printf+0x168>
        while(*s != 0){
 493:	8a 10                	mov    (%eax),%dl
 495:	84 d2                	test   %dl,%dl
 497:	74 29                	je     4c2 <printf+0x10e>
 499:	89 c7                	mov    %eax,%edi
 49b:	88 d0                	mov    %dl,%al
 49d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4a0:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4a3:	89 fb                	mov    %edi,%ebx
 4a5:	89 cf                	mov    %ecx,%edi
 4a7:	90                   	nop
          putc(fd, *s);
 4a8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ab:	50                   	push   %eax
 4ac:	6a 01                	push   $0x1
 4ae:	57                   	push   %edi
 4af:	56                   	push   %esi
 4b0:	e8 da fd ff ff       	call   28f <write>
          s++;
 4b5:	43                   	inc    %ebx
        while(*s != 0){
 4b6:	8a 03                	mov    (%ebx),%al
 4b8:	83 c4 10             	add    $0x10,%esp
 4bb:	84 c0                	test   %al,%al
 4bd:	75 e9                	jne    4a8 <printf+0xf4>
 4bf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 4c2:	83 c3 02             	add    $0x2,%ebx
 4c5:	8a 43 ff             	mov    -0x1(%ebx),%al
 4c8:	84 c0                	test   %al,%al
 4ca:	0f 85 00 ff ff ff    	jne    3d0 <printf+0x1c>
 4d0:	e9 1e ff ff ff       	jmp    3f3 <printf+0x3f>
 4d5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4db:	8b 17                	mov    (%edi),%edx
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	6a 01                	push   $0x1
 4e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e7:	eb 86                	jmp    46f <printf+0xbb>
 4e9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4ef:	8b 00                	mov    (%eax),%eax
 4f1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4f4:	51                   	push   %ecx
 4f5:	6a 01                	push   $0x1
 4f7:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4fa:	57                   	push   %edi
 4fb:	56                   	push   %esi
 4fc:	e8 8e fd ff ff       	call   28f <write>
        ap++;
 501:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 505:	e9 3c ff ff ff       	jmp    446 <printf+0x92>
 50a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 50c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 50f:	52                   	push   %edx
 510:	6a 01                	push   $0x1
 512:	8d 7d e7             	lea    -0x19(%ebp),%edi
 515:	e9 25 ff ff ff       	jmp    43f <printf+0x8b>
 51a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 51c:	bf cb 06 00 00       	mov    $0x6cb,%edi
 521:	b0 28                	mov    $0x28,%al
 523:	e9 75 ff ff ff       	jmp    49d <printf+0xe9>

00000528 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	53                   	push   %ebx
 52e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 531:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 534:	a1 b8 07 00 00       	mov    0x7b8,%eax
 539:	8d 76 00             	lea    0x0(%esi),%esi
 53c:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53e:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 540:	39 ca                	cmp    %ecx,%edx
 542:	73 2c                	jae    570 <free+0x48>
 544:	39 c1                	cmp    %eax,%ecx
 546:	72 04                	jb     54c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 548:	39 c2                	cmp    %eax,%edx
 54a:	72 f0                	jb     53c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 54c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 54f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 552:	39 f8                	cmp    %edi,%eax
 554:	74 2c                	je     582 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 556:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 559:	8b 42 04             	mov    0x4(%edx),%eax
 55c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 55f:	39 f1                	cmp    %esi,%ecx
 561:	74 36                	je     599 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 563:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 565:	89 15 b8 07 00 00    	mov    %edx,0x7b8
}
 56b:	5b                   	pop    %ebx
 56c:	5e                   	pop    %esi
 56d:	5f                   	pop    %edi
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 570:	39 c2                	cmp    %eax,%edx
 572:	72 c8                	jb     53c <free+0x14>
 574:	39 c1                	cmp    %eax,%ecx
 576:	73 c4                	jae    53c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 578:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57e:	39 f8                	cmp    %edi,%eax
 580:	75 d4                	jne    556 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 582:	03 70 04             	add    0x4(%eax),%esi
 585:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 588:	8b 02                	mov    (%edx),%eax
 58a:	8b 00                	mov    (%eax),%eax
 58c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 58f:	8b 42 04             	mov    0x4(%edx),%eax
 592:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 595:	39 f1                	cmp    %esi,%ecx
 597:	75 ca                	jne    563 <free+0x3b>
    p->s.size += bp->s.size;
 599:	03 43 fc             	add    -0x4(%ebx),%eax
 59c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 59f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5a2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5a4:	89 15 b8 07 00 00    	mov    %edx,0x7b8
}
 5aa:	5b                   	pop    %ebx
 5ab:	5e                   	pop    %esi
 5ac:	5f                   	pop    %edi
 5ad:	5d                   	pop    %ebp
 5ae:	c3                   	ret
 5af:	90                   	nop

000005b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	8d 78 07             	lea    0x7(%eax),%edi
 5bf:	c1 ef 03             	shr    $0x3,%edi
 5c2:	47                   	inc    %edi
  if((prevp = freep) == 0){
 5c3:	8b 15 b8 07 00 00    	mov    0x7b8,%edx
 5c9:	85 d2                	test   %edx,%edx
 5cb:	0f 84 93 00 00 00    	je     664 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5d3:	8b 48 04             	mov    0x4(%eax),%ecx
 5d6:	39 f9                	cmp    %edi,%ecx
 5d8:	73 62                	jae    63c <malloc+0x8c>
  if(nu < 4096)
 5da:	89 fb                	mov    %edi,%ebx
 5dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 5e2:	72 78                	jb     65c <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 5e4:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 5eb:	eb 0e                	jmp    5fb <malloc+0x4b>
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
 5f0:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5f4:	8b 48 04             	mov    0x4(%eax),%ecx
 5f7:	39 f9                	cmp    %edi,%ecx
 5f9:	73 41                	jae    63c <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5fb:	39 05 b8 07 00 00    	cmp    %eax,0x7b8
 601:	75 ed                	jne    5f0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 603:	83 ec 0c             	sub    $0xc,%esp
 606:	56                   	push   %esi
 607:	e8 eb fc ff ff       	call   2f7 <sbrk>
  if(p == (char*)-1)
 60c:	83 c4 10             	add    $0x10,%esp
 60f:	83 f8 ff             	cmp    $0xffffffff,%eax
 612:	74 1c                	je     630 <malloc+0x80>
  hp->s.size = nu;
 614:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 617:	83 ec 0c             	sub    $0xc,%esp
 61a:	83 c0 08             	add    $0x8,%eax
 61d:	50                   	push   %eax
 61e:	e8 05 ff ff ff       	call   528 <free>
  return freep;
 623:	8b 15 b8 07 00 00    	mov    0x7b8,%edx
      if((p = morecore(nunits)) == 0)
 629:	83 c4 10             	add    $0x10,%esp
 62c:	85 d2                	test   %edx,%edx
 62e:	75 c2                	jne    5f2 <malloc+0x42>
        return 0;
 630:	31 c0                	xor    %eax,%eax
  }
}
 632:	8d 65 f4             	lea    -0xc(%ebp),%esp
 635:	5b                   	pop    %ebx
 636:	5e                   	pop    %esi
 637:	5f                   	pop    %edi
 638:	5d                   	pop    %ebp
 639:	c3                   	ret
 63a:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 63c:	39 cf                	cmp    %ecx,%edi
 63e:	74 4c                	je     68c <malloc+0xdc>
        p->s.size -= nunits;
 640:	29 f9                	sub    %edi,%ecx
 642:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 645:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 648:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 64b:	89 15 b8 07 00 00    	mov    %edx,0x7b8
      return (void*)(p + 1);
 651:	83 c0 08             	add    $0x8,%eax
}
 654:	8d 65 f4             	lea    -0xc(%ebp),%esp
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret
  if(nu < 4096)
 65c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 661:	eb 81                	jmp    5e4 <malloc+0x34>
 663:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 664:	c7 05 b8 07 00 00 bc 	movl   $0x7bc,0x7b8
 66b:	07 00 00 
 66e:	c7 05 bc 07 00 00 bc 	movl   $0x7bc,0x7bc
 675:	07 00 00 
    base.s.size = 0;
 678:	c7 05 c0 07 00 00 00 	movl   $0x0,0x7c0
 67f:	00 00 00 
 682:	b8 bc 07 00 00       	mov    $0x7bc,%eax
 687:	e9 4e ff ff ff       	jmp    5da <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 68c:	8b 08                	mov    (%eax),%ecx
 68e:	89 0a                	mov    %ecx,(%edx)
 690:	eb b9                	jmp    64b <malloc+0x9b>
