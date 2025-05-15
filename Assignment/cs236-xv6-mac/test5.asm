
_test5:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    sleep(100000);
    printf(1, "Child %d exiting\n", id);
    exit();
}

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    printf(1, "MemSwapTest starting...\n");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 5e 07 00 00       	push   $0x75e
  17:	6a 01                	push   $0x1
  19:	e8 1a 04 00 00       	call   438 <printf>
  1e:	83 c4 10             	add    $0x10,%esp
    
    for (int i = 0; i < NUM_CHILDREN; i++) {
  21:	31 db                	xor    %ebx,%ebx
        int pid = fork();
  23:	e8 db 02 00 00       	call   303 <fork>
        if (pid < 0) {
  28:	85 c0                	test   %eax,%eax
  2a:	78 35                	js     61 <main+0x61>
            printf(1, "Fork failed!\n");
            exit();
        }
        if (pid == 0) { // Child
  2c:	74 46                	je     74 <main+0x74>
    for (int i = 0; i < NUM_CHILDREN; i++) {
  2e:	43                   	inc    %ebx
  2f:	83 fb 05             	cmp    $0x5,%ebx
  32:	75 ef                	jne    23 <main+0x23>
        }
    }

    // Parent waits for all children
    for (int i = 0; i < NUM_CHILDREN; i++) {
        wait();
  34:	e8 da 02 00 00       	call   313 <wait>
  39:	e8 d5 02 00 00       	call   313 <wait>
  3e:	e8 d0 02 00 00       	call   313 <wait>
  43:	e8 cb 02 00 00       	call   313 <wait>
  48:	e8 c6 02 00 00       	call   313 <wait>
    }
    
    printf(1, "MemSwapTest completed\n");
  4d:	83 ec 08             	sub    $0x8,%esp
  50:	68 85 07 00 00       	push   $0x785
  55:	6a 01                	push   $0x1
  57:	e8 dc 03 00 00       	call   438 <printf>
    exit();
  5c:	e8 aa 02 00 00       	call   30b <exit>
            printf(1, "Fork failed!\n");
  61:	50                   	push   %eax
  62:	50                   	push   %eax
  63:	68 77 07 00 00       	push   $0x777
  68:	6a 01                	push   $0x1
  6a:	e8 c9 03 00 00       	call   438 <printf>
            exit();
  6f:	e8 97 02 00 00       	call   30b <exit>
            child_process(i);
  74:	83 ec 0c             	sub    $0xc,%esp
  77:	53                   	push   %ebx
  78:	e8 03 00 00 00       	call   80 <child_process>
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <child_process>:
void child_process(int id) {
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	57                   	push   %edi
  84:	56                   	push   %esi
  85:	53                   	push   %ebx
  86:	83 ec 10             	sub    $0x10,%esp
  89:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "Child %d starting...\n", id);
  8c:	56                   	push   %esi
  8d:	68 18 07 00 00       	push   $0x718
  92:	6a 01                	push   $0x1
  94:	e8 9f 03 00 00       	call   438 <printf>
  99:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < ITERATIONS; i++) {
  9c:	31 db                	xor    %ebx,%ebx
  9e:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
        char *mem = sbrk(PAGE_SIZE);
  a4:	83 ec 0c             	sub    $0xc,%esp
  a7:	68 00 10 00 00       	push   $0x1000
  ac:	e8 e2 02 00 00       	call   393 <sbrk>
        if (mem == (char*)-1) {
  b1:	83 c4 10             	add    $0x10,%esp
  b4:	83 f8 ff             	cmp    $0xffffffff,%eax
  b7:	74 79                	je     132 <child_process+0xb2>
  b9:	89 f2                	mov    %esi,%edx
            mem[j] = (id + j) % 256;
  bb:	29 f0                	sub    %esi,%eax
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  c0:	89 d1                	mov    %edx,%ecx
  c2:	81 e1 ff 00 00 80    	and    $0x800000ff,%ecx
  c8:	79 08                	jns    d2 <child_process+0x52>
  ca:	49                   	dec    %ecx
  cb:	81 c9 00 ff ff ff    	or     $0xffffff00,%ecx
  d1:	41                   	inc    %ecx
  d2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
        for (int j = 0; j < PAGE_SIZE; j++) {
  d5:	42                   	inc    %edx
  d6:	39 fa                	cmp    %edi,%edx
  d8:	75 e6                	jne    c0 <child_process+0x40>
        if (i % 100 == 0) {
  da:	89 d8                	mov    %ebx,%eax
  dc:	b9 64 00 00 00       	mov    $0x64,%ecx
  e1:	99                   	cltd
  e2:	f7 f9                	idiv   %ecx
            printf(1, "Child %d: allocated %d pages\n", id, i+1);
  e4:	43                   	inc    %ebx
        if (i % 100 == 0) {
  e5:	85 d2                	test   %edx,%edx
  e7:	74 2a                	je     113 <child_process+0x93>
    for (int i = 0; i < ITERATIONS; i++) {
  e9:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
  ef:	75 b3                	jne    a4 <child_process+0x24>
    sleep(100000);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	68 a0 86 01 00       	push   $0x186a0
  f9:	e8 9d 02 00 00       	call   39b <sleep>
    printf(1, "Child %d exiting\n", id);
  fe:	83 c4 0c             	add    $0xc,%esp
 101:	56                   	push   %esi
 102:	68 4c 07 00 00       	push   $0x74c
 107:	6a 01                	push   $0x1
 109:	e8 2a 03 00 00       	call   438 <printf>
    exit();
 10e:	e8 f8 01 00 00       	call   30b <exit>
            printf(1, "Child %d: allocated %d pages\n", id, i+1);
 113:	53                   	push   %ebx
 114:	56                   	push   %esi
 115:	68 2e 07 00 00       	push   $0x72e
 11a:	6a 01                	push   $0x1
 11c:	e8 17 03 00 00       	call   438 <printf>
            sleep(10);  // Sleep for 10 ticks periodically
 121:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 128:	e8 6e 02 00 00       	call   39b <sleep>
 12d:	83 c4 10             	add    $0x10,%esp
 130:	eb b7                	jmp    e9 <child_process+0x69>
            printf(1, "Child %d: sbrk failed at iteration %d\n", id, i);
 132:	53                   	push   %ebx
 133:	56                   	push   %esi
 134:	68 a4 07 00 00       	push   $0x7a4
 139:	6a 01                	push   $0x1
 13b:	e8 f8 02 00 00       	call   438 <printf>
            break;
 140:	83 c4 10             	add    $0x10,%esp
 143:	eb ac                	jmp    f1 <child_process+0x71>
 145:	66 90                	xchg   %ax,%ax
 147:	90                   	nop

00000148 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	53                   	push   %ebx
 14c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 152:	31 c0                	xor    %eax,%eax
 154:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 157:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 15a:	40                   	inc    %eax
 15b:	84 d2                	test   %dl,%dl
 15d:	75 f5                	jne    154 <strcpy+0xc>
    ;
  return os;
}
 15f:	89 c8                	mov    %ecx,%eax
 161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 164:	c9                   	leave
 165:	c3                   	ret
 166:	66 90                	xchg   %ax,%ax

00000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	53                   	push   %ebx
 16c:	8b 55 08             	mov    0x8(%ebp),%edx
 16f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 172:	0f b6 02             	movzbl (%edx),%eax
 175:	84 c0                	test   %al,%al
 177:	75 10                	jne    189 <strcmp+0x21>
 179:	eb 2a                	jmp    1a5 <strcmp+0x3d>
 17b:	90                   	nop
    p++, q++;
 17c:	42                   	inc    %edx
 17d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 180:	0f b6 02             	movzbl (%edx),%eax
 183:	84 c0                	test   %al,%al
 185:	74 11                	je     198 <strcmp+0x30>
 187:	89 cb                	mov    %ecx,%ebx
 189:	0f b6 0b             	movzbl (%ebx),%ecx
 18c:	38 c1                	cmp    %al,%cl
 18e:	74 ec                	je     17c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 190:	29 c8                	sub    %ecx,%eax
}
 192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 195:	c9                   	leave
 196:	c3                   	ret
 197:	90                   	nop
  return (uchar)*p - (uchar)*q;
 198:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 19c:	31 c0                	xor    %eax,%eax
 19e:	29 c8                	sub    %ecx,%eax
}
 1a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a3:	c9                   	leave
 1a4:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1a5:	0f b6 0b             	movzbl (%ebx),%ecx
 1a8:	31 c0                	xor    %eax,%eax
 1aa:	eb e4                	jmp    190 <strcmp+0x28>

000001ac <strlen>:

uint
strlen(const char *s)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1b2:	80 3a 00             	cmpb   $0x0,(%edx)
 1b5:	74 15                	je     1cc <strlen+0x20>
 1b7:	31 c0                	xor    %eax,%eax
 1b9:	8d 76 00             	lea    0x0(%esi),%esi
 1bc:	40                   	inc    %eax
 1bd:	89 c1                	mov    %eax,%ecx
 1bf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1c3:	75 f7                	jne    1bc <strlen+0x10>
    ;
  return n;
}
 1c5:	89 c8                	mov    %ecx,%eax
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret
 1c9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1cc:	31 c9                	xor    %ecx,%ecx
}
 1ce:	89 c8                	mov    %ecx,%eax
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret
 1d2:	66 90                	xchg   %ax,%ax

000001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d8:	8b 7d 08             	mov    0x8(%ebp),%edi
 1db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	fc                   	cld
 1e2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1ea:	c9                   	leave
 1eb:	c3                   	ret

000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1f5:	8a 10                	mov    (%eax),%dl
 1f7:	84 d2                	test   %dl,%dl
 1f9:	75 0c                	jne    207 <strchr+0x1b>
 1fb:	eb 13                	jmp    210 <strchr+0x24>
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	40                   	inc    %eax
 201:	8a 10                	mov    (%eax),%dl
 203:	84 d2                	test   %dl,%dl
 205:	74 09                	je     210 <strchr+0x24>
    if(*s == c)
 207:	38 d1                	cmp    %dl,%cl
 209:	75 f5                	jne    200 <strchr+0x14>
      return (char*)s;
  return 0;
}
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret
 20d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 210:	31 c0                	xor    %eax,%eax
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret

00000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	56                   	push   %esi
 219:	53                   	push   %ebx
 21a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 21f:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 222:	eb 24                	jmp    248 <gets+0x34>
    cc = read(0, &c, 1);
 224:	50                   	push   %eax
 225:	6a 01                	push   $0x1
 227:	56                   	push   %esi
 228:	6a 00                	push   $0x0
 22a:	e8 f4 00 00 00       	call   323 <read>
    if(cc < 1)
 22f:	83 c4 10             	add    $0x10,%esp
 232:	85 c0                	test   %eax,%eax
 234:	7e 1a                	jle    250 <gets+0x3c>
      break;
    buf[i++] = c;
 236:	8a 45 e7             	mov    -0x19(%ebp),%al
 239:	8b 55 08             	mov    0x8(%ebp),%edx
 23c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 240:	3c 0a                	cmp    $0xa,%al
 242:	74 0e                	je     252 <gets+0x3e>
 244:	3c 0d                	cmp    $0xd,%al
 246:	74 0a                	je     252 <gets+0x3e>
  for(i=0; i+1 < max; ){
 248:	89 df                	mov    %ebx,%edi
 24a:	43                   	inc    %ebx
 24b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 24e:	7c d4                	jl     224 <gets+0x10>
 250:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 259:	8d 65 f4             	lea    -0xc(%ebp),%esp
 25c:	5b                   	pop    %ebx
 25d:	5e                   	pop    %esi
 25e:	5f                   	pop    %edi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret
 261:	8d 76 00             	lea    0x0(%esi),%esi

00000264 <stat>:

int
stat(const char *n, struct stat *st)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	56                   	push   %esi
 268:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 269:	83 ec 08             	sub    $0x8,%esp
 26c:	6a 00                	push   $0x0
 26e:	ff 75 08             	push   0x8(%ebp)
 271:	e8 d5 00 00 00       	call   34b <open>
  if(fd < 0)
 276:	83 c4 10             	add    $0x10,%esp
 279:	85 c0                	test   %eax,%eax
 27b:	78 27                	js     2a4 <stat+0x40>
 27d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	ff 75 0c             	push   0xc(%ebp)
 285:	50                   	push   %eax
 286:	e8 d8 00 00 00       	call   363 <fstat>
 28b:	89 c6                	mov    %eax,%esi
  close(fd);
 28d:	89 1c 24             	mov    %ebx,(%esp)
 290:	e8 9e 00 00 00       	call   333 <close>
  return r;
 295:	83 c4 10             	add    $0x10,%esp
}
 298:	89 f0                	mov    %esi,%eax
 29a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 29d:	5b                   	pop    %ebx
 29e:	5e                   	pop    %esi
 29f:	5d                   	pop    %ebp
 2a0:	c3                   	ret
 2a1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a9:	eb ed                	jmp    298 <stat+0x34>
 2ab:	90                   	nop

000002ac <atoi>:

int
atoi(const char *s)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	53                   	push   %ebx
 2b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b3:	0f be 01             	movsbl (%ecx),%eax
 2b6:	8d 50 d0             	lea    -0x30(%eax),%edx
 2b9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2bc:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2c1:	77 16                	ja     2d9 <atoi+0x2d>
 2c3:	90                   	nop
    n = n*10 + *s++ - '0';
 2c4:	41                   	inc    %ecx
 2c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2c8:	01 d2                	add    %edx,%edx
 2ca:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2ce:	0f be 01             	movsbl (%ecx),%eax
 2d1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d4:	80 fb 09             	cmp    $0x9,%bl
 2d7:	76 eb                	jbe    2c4 <atoi+0x18>
  return n;
}
 2d9:	89 d0                	mov    %edx,%eax
 2db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2de:	c9                   	leave
 2df:	c3                   	ret

000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	56                   	push   %esi
 2e5:	8b 55 08             	mov    0x8(%ebp),%edx
 2e8:	8b 75 0c             	mov    0xc(%ebp),%esi
 2eb:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ee:	85 c0                	test   %eax,%eax
 2f0:	7e 0b                	jle    2fd <memmove+0x1d>
 2f2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2f4:	89 d7                	mov    %edx,%edi
 2f6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2f9:	39 f8                	cmp    %edi,%eax
 2fb:	75 fb                	jne    2f8 <memmove+0x18>
  return vdst;
}
 2fd:	89 d0                	mov    %edx,%eax
 2ff:	5e                   	pop    %esi
 300:	5f                   	pop    %edi
 301:	5d                   	pop    %ebp
 302:	c3                   	ret

00000303 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 303:	b8 01 00 00 00       	mov    $0x1,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <exit>:
SYSCALL(exit)
 30b:	b8 02 00 00 00       	mov    $0x2,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <wait>:
SYSCALL(wait)
 313:	b8 03 00 00 00       	mov    $0x3,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <pipe>:
SYSCALL(pipe)
 31b:	b8 04 00 00 00       	mov    $0x4,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <read>:
SYSCALL(read)
 323:	b8 05 00 00 00       	mov    $0x5,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <write>:
SYSCALL(write)
 32b:	b8 10 00 00 00       	mov    $0x10,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <close>:
SYSCALL(close)
 333:	b8 15 00 00 00       	mov    $0x15,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <kill>:
SYSCALL(kill)
 33b:	b8 06 00 00 00       	mov    $0x6,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <exec>:
SYSCALL(exec)
 343:	b8 07 00 00 00       	mov    $0x7,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <open>:
SYSCALL(open)
 34b:	b8 0f 00 00 00       	mov    $0xf,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <mknod>:
SYSCALL(mknod)
 353:	b8 11 00 00 00       	mov    $0x11,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <unlink>:
SYSCALL(unlink)
 35b:	b8 12 00 00 00       	mov    $0x12,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <fstat>:
SYSCALL(fstat)
 363:	b8 08 00 00 00       	mov    $0x8,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <link>:
SYSCALL(link)
 36b:	b8 13 00 00 00       	mov    $0x13,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <mkdir>:
SYSCALL(mkdir)
 373:	b8 14 00 00 00       	mov    $0x14,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <chdir>:
SYSCALL(chdir)
 37b:	b8 09 00 00 00       	mov    $0x9,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <dup>:
SYSCALL(dup)
 383:	b8 0a 00 00 00       	mov    $0xa,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <getpid>:
SYSCALL(getpid)
 38b:	b8 0b 00 00 00       	mov    $0xb,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <sbrk>:
SYSCALL(sbrk)
 393:	b8 0c 00 00 00       	mov    $0xc,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <sleep>:
SYSCALL(sleep)
 39b:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <uptime>:
SYSCALL(uptime)
 3a3:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret
 3ab:	90                   	nop

000003ac <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	53                   	push   %ebx
 3b2:	83 ec 3c             	sub    $0x3c,%esp
 3b5:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3b8:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3bd:	85 c9                	test   %ecx,%ecx
 3bf:	74 04                	je     3c5 <printint+0x19>
 3c1:	85 d2                	test   %edx,%edx
 3c3:	78 6b                	js     430 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 3c8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 3cf:	31 c9                	xor    %ecx,%ecx
 3d1:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3d7:	31 d2                	xor    %edx,%edx
 3d9:	f7 f3                	div    %ebx
 3db:	89 cf                	mov    %ecx,%edi
 3dd:	8d 49 01             	lea    0x1(%ecx),%ecx
 3e0:	8a 92 24 08 00 00    	mov    0x824(%edx),%dl
 3e6:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3ea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3f0:	39 da                	cmp    %ebx,%edx
 3f2:	73 e0                	jae    3d4 <printint+0x28>
  if(neg)
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
 3f7:	85 d2                	test   %edx,%edx
 3f9:	74 07                	je     402 <printint+0x56>
    buf[i++] = '-';
 3fb:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 400:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 402:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 405:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 409:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 40c:	8a 07                	mov    (%edi),%al
 40e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 411:	50                   	push   %eax
 412:	6a 01                	push   $0x1
 414:	56                   	push   %esi
 415:	ff 75 c0             	push   -0x40(%ebp)
 418:	e8 0e ff ff ff       	call   32b <write>
  while(--i >= 0)
 41d:	89 f8                	mov    %edi,%eax
 41f:	4f                   	dec    %edi
 420:	83 c4 10             	add    $0x10,%esp
 423:	39 d8                	cmp    %ebx,%eax
 425:	75 e5                	jne    40c <printint+0x60>
}
 427:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42a:	5b                   	pop    %ebx
 42b:	5e                   	pop    %esi
 42c:	5f                   	pop    %edi
 42d:	5d                   	pop    %ebp
 42e:	c3                   	ret
 42f:	90                   	nop
    x = -xx;
 430:	f7 da                	neg    %edx
 432:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 435:	eb 98                	jmp    3cf <printint+0x23>
 437:	90                   	nop

00000438 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	57                   	push   %edi
 43c:	56                   	push   %esi
 43d:	53                   	push   %ebx
 43e:	83 ec 2c             	sub    $0x2c,%esp
 441:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 444:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 447:	8a 03                	mov    (%ebx),%al
 449:	84 c0                	test   %al,%al
 44b:	74 2a                	je     477 <printf+0x3f>
 44d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 44e:	8d 4d 10             	lea    0x10(%ebp),%ecx
 451:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 454:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 457:	83 fa 25             	cmp    $0x25,%edx
 45a:	74 24                	je     480 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 45c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 45f:	50                   	push   %eax
 460:	6a 01                	push   $0x1
 462:	8d 45 e7             	lea    -0x19(%ebp),%eax
 465:	50                   	push   %eax
 466:	56                   	push   %esi
 467:	e8 bf fe ff ff       	call   32b <write>
  for(i = 0; fmt[i]; i++){
 46c:	43                   	inc    %ebx
 46d:	8a 43 ff             	mov    -0x1(%ebx),%al
 470:	83 c4 10             	add    $0x10,%esp
 473:	84 c0                	test   %al,%al
 475:	75 dd                	jne    454 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 477:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47a:	5b                   	pop    %ebx
 47b:	5e                   	pop    %esi
 47c:	5f                   	pop    %edi
 47d:	5d                   	pop    %ebp
 47e:	c3                   	ret
 47f:	90                   	nop
  for(i = 0; fmt[i]; i++){
 480:	8a 13                	mov    (%ebx),%dl
 482:	84 d2                	test   %dl,%dl
 484:	74 f1                	je     477 <printf+0x3f>
    c = fmt[i] & 0xff;
 486:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 489:	80 fa 25             	cmp    $0x25,%dl
 48c:	0f 84 fe 00 00 00    	je     590 <printf+0x158>
 492:	83 e8 63             	sub    $0x63,%eax
 495:	83 f8 15             	cmp    $0x15,%eax
 498:	77 0a                	ja     4a4 <printf+0x6c>
 49a:	ff 24 85 cc 07 00 00 	jmp    *0x7cc(,%eax,4)
 4a1:	8d 76 00             	lea    0x0(%esi),%esi
 4a4:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 4a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4ab:	50                   	push   %eax
 4ac:	6a 01                	push   $0x1
 4ae:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4b1:	57                   	push   %edi
 4b2:	56                   	push   %esi
 4b3:	e8 73 fe ff ff       	call   32b <write>
        putc(fd, c);
 4b8:	8a 55 d0             	mov    -0x30(%ebp),%dl
 4bb:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4be:	83 c4 0c             	add    $0xc,%esp
 4c1:	6a 01                	push   $0x1
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	e8 61 fe ff ff       	call   32b <write>
  for(i = 0; fmt[i]; i++){
 4ca:	83 c3 02             	add    $0x2,%ebx
 4cd:	8a 43 ff             	mov    -0x1(%ebx),%al
 4d0:	83 c4 10             	add    $0x10,%esp
 4d3:	84 c0                	test   %al,%al
 4d5:	0f 85 79 ff ff ff    	jne    454 <printf+0x1c>
}
 4db:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4de:	5b                   	pop    %ebx
 4df:	5e                   	pop    %esi
 4e0:	5f                   	pop    %edi
 4e1:	5d                   	pop    %ebp
 4e2:	c3                   	ret
 4e3:	90                   	nop
        printint(fd, *ap, 16, 0);
 4e4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4e7:	8b 17                	mov    (%edi),%edx
 4e9:	83 ec 0c             	sub    $0xc,%esp
 4ec:	6a 00                	push   $0x0
 4ee:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f3:	89 f0                	mov    %esi,%eax
 4f5:	e8 b2 fe ff ff       	call   3ac <printint>
        ap++;
 4fa:	83 c7 04             	add    $0x4,%edi
 4fd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 500:	eb c8                	jmp    4ca <printf+0x92>
 502:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 504:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 507:	8b 01                	mov    (%ecx),%eax
        ap++;
 509:	83 c1 04             	add    $0x4,%ecx
 50c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 50f:	85 c0                	test   %eax,%eax
 511:	0f 84 89 00 00 00    	je     5a0 <printf+0x168>
        while(*s != 0){
 517:	8a 10                	mov    (%eax),%dl
 519:	84 d2                	test   %dl,%dl
 51b:	74 29                	je     546 <printf+0x10e>
 51d:	89 c7                	mov    %eax,%edi
 51f:	88 d0                	mov    %dl,%al
 521:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 524:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 527:	89 fb                	mov    %edi,%ebx
 529:	89 cf                	mov    %ecx,%edi
 52b:	90                   	nop
          putc(fd, *s);
 52c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 52f:	50                   	push   %eax
 530:	6a 01                	push   $0x1
 532:	57                   	push   %edi
 533:	56                   	push   %esi
 534:	e8 f2 fd ff ff       	call   32b <write>
          s++;
 539:	43                   	inc    %ebx
        while(*s != 0){
 53a:	8a 03                	mov    (%ebx),%al
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	84 c0                	test   %al,%al
 541:	75 e9                	jne    52c <printf+0xf4>
 543:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 546:	83 c3 02             	add    $0x2,%ebx
 549:	8a 43 ff             	mov    -0x1(%ebx),%al
 54c:	84 c0                	test   %al,%al
 54e:	0f 85 00 ff ff ff    	jne    454 <printf+0x1c>
 554:	e9 1e ff ff ff       	jmp    477 <printf+0x3f>
 559:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 55c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 55f:	8b 17                	mov    (%edi),%edx
 561:	83 ec 0c             	sub    $0xc,%esp
 564:	6a 01                	push   $0x1
 566:	b9 0a 00 00 00       	mov    $0xa,%ecx
 56b:	eb 86                	jmp    4f3 <printf+0xbb>
 56d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 578:	51                   	push   %ecx
 579:	6a 01                	push   $0x1
 57b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 57e:	57                   	push   %edi
 57f:	56                   	push   %esi
 580:	e8 a6 fd ff ff       	call   32b <write>
        ap++;
 585:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 589:	e9 3c ff ff ff       	jmp    4ca <printf+0x92>
 58e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 590:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 593:	52                   	push   %edx
 594:	6a 01                	push   $0x1
 596:	8d 7d e7             	lea    -0x19(%ebp),%edi
 599:	e9 25 ff ff ff       	jmp    4c3 <printf+0x8b>
 59e:	66 90                	xchg   %ax,%ax
          s = "(null)";
 5a0:	bf 9c 07 00 00       	mov    $0x79c,%edi
 5a5:	b0 28                	mov    $0x28,%al
 5a7:	e9 75 ff ff ff       	jmp    521 <printf+0xe9>

000005ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ac:	55                   	push   %ebp
 5ad:	89 e5                	mov    %esp,%ebp
 5af:	57                   	push   %edi
 5b0:	56                   	push   %esi
 5b1:	53                   	push   %ebx
 5b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b8:	a1 38 08 00 00       	mov    0x838,%eax
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c2:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c4:	39 ca                	cmp    %ecx,%edx
 5c6:	73 2c                	jae    5f4 <free+0x48>
 5c8:	39 c1                	cmp    %eax,%ecx
 5ca:	72 04                	jb     5d0 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cc:	39 c2                	cmp    %eax,%edx
 5ce:	72 f0                	jb     5c0 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5d6:	39 f8                	cmp    %edi,%eax
 5d8:	74 2c                	je     606 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5da:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5dd:	8b 42 04             	mov    0x4(%edx),%eax
 5e0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5e3:	39 f1                	cmp    %esi,%ecx
 5e5:	74 36                	je     61d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5e7:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5e9:	89 15 38 08 00 00    	mov    %edx,0x838
}
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f4:	39 c2                	cmp    %eax,%edx
 5f6:	72 c8                	jb     5c0 <free+0x14>
 5f8:	39 c1                	cmp    %eax,%ecx
 5fa:	73 c4                	jae    5c0 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5fc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ff:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 602:	39 f8                	cmp    %edi,%eax
 604:	75 d4                	jne    5da <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 606:	03 70 04             	add    0x4(%eax),%esi
 609:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60c:	8b 02                	mov    (%edx),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 613:	8b 42 04             	mov    0x4(%edx),%eax
 616:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 619:	39 f1                	cmp    %esi,%ecx
 61b:	75 ca                	jne    5e7 <free+0x3b>
    p->s.size += bp->s.size;
 61d:	03 43 fc             	add    -0x4(%ebx),%eax
 620:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 623:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 626:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 628:	89 15 38 08 00 00    	mov    %edx,0x838
}
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5f                   	pop    %edi
 631:	5d                   	pop    %ebp
 632:	c3                   	ret
 633:	90                   	nop

00000634 <malloc>:
}


void*
malloc(uint nbytes)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	57                   	push   %edi
 638:	56                   	push   %esi
 639:	53                   	push   %ebx
 63a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	8d 78 07             	lea    0x7(%eax),%edi
 643:	c1 ef 03             	shr    $0x3,%edi
 646:	47                   	inc    %edi
  if((prevp = freep) == 0){
 647:	8b 15 38 08 00 00    	mov    0x838,%edx
 64d:	85 d2                	test   %edx,%edx
 64f:	0f 84 93 00 00 00    	je     6e8 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 655:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 657:	8b 48 04             	mov    0x4(%eax),%ecx
 65a:	39 f9                	cmp    %edi,%ecx
 65c:	73 62                	jae    6c0 <malloc+0x8c>
  if(nu < 4096)
 65e:	89 fb                	mov    %edi,%ebx
 660:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 666:	72 78                	jb     6e0 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 668:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 66f:	eb 0e                	jmp    67f <malloc+0x4b>
 671:	8d 76 00             	lea    0x0(%esi),%esi
 674:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 676:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 678:	8b 48 04             	mov    0x4(%eax),%ecx
 67b:	39 f9                	cmp    %edi,%ecx
 67d:	73 41                	jae    6c0 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 67f:	39 05 38 08 00 00    	cmp    %eax,0x838
 685:	75 ed                	jne    674 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 687:	83 ec 0c             	sub    $0xc,%esp
 68a:	56                   	push   %esi
 68b:	e8 03 fd ff ff       	call   393 <sbrk>
  if(p == (char*)-1)
 690:	83 c4 10             	add    $0x10,%esp
 693:	83 f8 ff             	cmp    $0xffffffff,%eax
 696:	74 1c                	je     6b4 <malloc+0x80>
  hp->s.size = nu;
 698:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 69b:	83 ec 0c             	sub    $0xc,%esp
 69e:	83 c0 08             	add    $0x8,%eax
 6a1:	50                   	push   %eax
 6a2:	e8 05 ff ff ff       	call   5ac <free>
  return freep;
 6a7:	8b 15 38 08 00 00    	mov    0x838,%edx
      if((p = morecore(nunits)) == 0)
 6ad:	83 c4 10             	add    $0x10,%esp
 6b0:	85 d2                	test   %edx,%edx
 6b2:	75 c2                	jne    676 <malloc+0x42>
        return 0;
 6b4:	31 c0                	xor    %eax,%eax
  }
}
 6b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b9:	5b                   	pop    %ebx
 6ba:	5e                   	pop    %esi
 6bb:	5f                   	pop    %edi
 6bc:	5d                   	pop    %ebp
 6bd:	c3                   	ret
 6be:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 6c0:	39 cf                	cmp    %ecx,%edi
 6c2:	74 4c                	je     710 <malloc+0xdc>
        p->s.size -= nunits;
 6c4:	29 f9                	sub    %edi,%ecx
 6c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6cc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6cf:	89 15 38 08 00 00    	mov    %edx,0x838
      return (void*)(p + 1);
 6d5:	83 c0 08             	add    $0x8,%eax
}
 6d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6db:	5b                   	pop    %ebx
 6dc:	5e                   	pop    %esi
 6dd:	5f                   	pop    %edi
 6de:	5d                   	pop    %ebp
 6df:	c3                   	ret
  if(nu < 4096)
 6e0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e5:	eb 81                	jmp    668 <malloc+0x34>
 6e7:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6e8:	c7 05 38 08 00 00 3c 	movl   $0x83c,0x838
 6ef:	08 00 00 
 6f2:	c7 05 3c 08 00 00 3c 	movl   $0x83c,0x83c
 6f9:	08 00 00 
    base.s.size = 0;
 6fc:	c7 05 40 08 00 00 00 	movl   $0x0,0x840
 703:	00 00 00 
 706:	b8 3c 08 00 00       	mov    $0x83c,%eax
 70b:	e9 4e ff ff ff       	jmp    65e <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 710:	8b 08                	mov    (%eax),%ecx
 712:	89 0a                	mov    %ecx,(%edx)
 714:	eb b9                	jmp    6cf <malloc+0x9b>
