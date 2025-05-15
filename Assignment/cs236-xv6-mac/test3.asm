
_test3:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    if (n == 2) return 1;
    return fib(n - 1) + fib(n - 2);
}

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
         int pid = fork();
   f:	e8 d7 03 00 00       	call   3eb <fork>
         if (pid != 0) {
  14:	85 c0                	test   %eax,%eax
  16:	74 43                	je     5b <main+0x5b>
         printf(1, "Parent started with pid: %d\n", getpid());
  18:	e8 56 04 00 00       	call   473 <getpid>
  1d:	51                   	push   %ecx
  1e:	50                   	push   %eax
  1f:	68 00 08 00 00       	push   $0x800
  24:	6a 01                	push   $0x1
  26:	e8 f5 04 00 00       	call   520 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	66 90                	xchg   %ax,%ax
         while (1) 
           {
             printf(1, "Hello , I am parent\n");
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 1d 08 00 00       	push   $0x81d
  38:	6a 01                	push   $0x1
  3a:	e8 e1 04 00 00       	call   520 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	bb 22 00 00 00       	mov    $0x22,%ebx
  47:	90                   	nop
    return fib(n - 1) + fib(n - 2);
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	53                   	push   %ebx
  4c:	e8 4f 00 00 00       	call   a0 <fib>
  51:	83 c4 10             	add    $0x10,%esp
    if (n == 1) return 1;
  54:	83 eb 02             	sub    $0x2,%ebx
  57:	75 ef                	jne    48 <main+0x48>
  59:	eb d5                	jmp    30 <main+0x30>
             fib (35);
           }
          }
       else {
        printf(1, "Child started with pid: %d\n", getpid());
  5b:	e8 13 04 00 00       	call   473 <getpid>
  60:	52                   	push   %edx
  61:	50                   	push   %eax
  62:	68 32 08 00 00       	push   $0x832
  67:	6a 01                	push   $0x1
  69:	e8 b2 04 00 00       	call   520 <printf>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	8d 76 00             	lea    0x0(%esi),%esi
        while (1) {
       printf(1, "Hi there , I am child\n");
  74:	83 ec 08             	sub    $0x8,%esp
  77:	68 4e 08 00 00       	push   $0x84e
  7c:	6a 01                	push   $0x1
  7e:	e8 9d 04 00 00       	call   520 <printf>
  83:	83 c4 10             	add    $0x10,%esp
  86:	bb 22 00 00 00       	mov    $0x22,%ebx
  8b:	90                   	nop
    return fib(n - 1) + fib(n - 2);
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	e8 0b 00 00 00       	call   a0 <fib>
  95:	83 c4 10             	add    $0x10,%esp
    if (n == 1) return 1;
  98:	83 eb 02             	sub    $0x2,%ebx
  9b:	75 ef                	jne    8c <main+0x8c>
  9d:	eb d5                	jmp    74 <main+0x74>
  9f:	90                   	nop

000000a0 <fib>:
int fib(int n) {
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	83 ec 4c             	sub    $0x4c,%esp
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
    if (n <= 0) return 0;
  ac:	85 c0                	test   %eax,%eax
  ae:	0f 8e 76 01 00 00    	jle    22a <fib+0x18a>
    if (n == 1) return 1;
  b4:	8d 78 ff             	lea    -0x1(%eax),%edi
  b7:	31 db                	xor    %ebx,%ebx
  b9:	83 ff 01             	cmp    $0x1,%edi
  bc:	0f 86 5d 01 00 00    	jbe    21f <fib+0x17f>
    return fib(n - 1) + fib(n - 2);
  c2:	89 fe                	mov    %edi,%esi
  c4:	31 d2                	xor    %edx,%edx
  c6:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    if (n == 2) return 1;
  c9:	83 fe 02             	cmp    $0x2,%esi
  cc:	0f 84 3a 01 00 00    	je     20c <fib+0x16c>
    return fib(n - 1) + fib(n - 2);
  d2:	8d 5e ff             	lea    -0x1(%esi),%ebx
  d5:	31 c0                	xor    %eax,%eax
  d7:	89 75 d8             	mov    %esi,-0x28(%ebp)
  da:	89 c1                	mov    %eax,%ecx
  dc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    if (n == 2) return 1;
  df:	83 fb 02             	cmp    $0x2,%ebx
  e2:	0f 84 0e 01 00 00    	je     1f6 <fib+0x156>
    return fib(n - 1) + fib(n - 2);
  e8:	8d 73 ff             	lea    -0x1(%ebx),%esi
  eb:	31 ff                	xor    %edi,%edi
  ed:	89 55 d0             	mov    %edx,-0x30(%ebp)
  f0:	89 5d cc             	mov    %ebx,-0x34(%ebp)
    if (n == 2) return 1;
  f3:	83 fe 02             	cmp    $0x2,%esi
  f6:	0f 84 e4 00 00 00    	je     1e0 <fib+0x140>
    return fib(n - 1) + fib(n - 2);
  fc:	8d 5e ff             	lea    -0x1(%esi),%ebx
  ff:	31 d2                	xor    %edx,%edx
 101:	89 4d c8             	mov    %ecx,-0x38(%ebp)
 104:	89 75 c4             	mov    %esi,-0x3c(%ebp)
    if (n == 2) return 1;
 107:	83 fb 02             	cmp    $0x2,%ebx
 10a:	0f 84 ba 00 00 00    	je     1ca <fib+0x12a>
    return fib(n - 1) + fib(n - 2);
 110:	8d 73 ff             	lea    -0x1(%ebx),%esi
 113:	31 c9                	xor    %ecx,%ecx
 115:	89 55 c0             	mov    %edx,-0x40(%ebp)
    if (n == 2) return 1;
 118:	83 fe 02             	cmp    $0x2,%esi
 11b:	0f 84 96 00 00 00    	je     1b7 <fib+0x117>
    return fib(n - 1) + fib(n - 2);
 121:	8d 56 ff             	lea    -0x1(%esi),%edx
 124:	31 c0                	xor    %eax,%eax
 126:	89 7d bc             	mov    %edi,-0x44(%ebp)
 129:	89 75 b8             	mov    %esi,-0x48(%ebp)
 12c:	89 de                	mov    %ebx,%esi
 12e:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
 131:	89 c7                	mov    %eax,%edi
    if (n == 2) return 1;
 133:	83 fa 02             	cmp    $0x2,%edx
 136:	74 62                	je     19a <fib+0xfa>
    return fib(n - 1) + fib(n - 2);
 138:	8d 4a ff             	lea    -0x1(%edx),%ecx
 13b:	31 db                	xor    %ebx,%ebx
    if (n == 2) return 1;
 13d:	83 f9 02             	cmp    $0x2,%ecx
 140:	74 4c                	je     18e <fib+0xee>
    return fib(n - 1) + fib(n - 2);
 142:	8d 41 ff             	lea    -0x1(%ecx),%eax
 145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 148:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    if (n == 2) return 1;
 14f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 152:	83 f8 02             	cmp    $0x2,%eax
 155:	74 28                	je     17f <fib+0xdf>
 157:	89 55 ac             	mov    %edx,-0x54(%ebp)
 15a:	89 4d b0             	mov    %ecx,-0x50(%ebp)
    return fib(n - 1) + fib(n - 2);
 15d:	83 ec 0c             	sub    $0xc,%esp
 160:	48                   	dec    %eax
 161:	50                   	push   %eax
 162:	e8 39 ff ff ff       	call   a0 <fib>
 167:	83 c4 10             	add    $0x10,%esp
 16a:	83 6d e4 02          	subl   $0x2,-0x1c(%ebp)
 16e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 171:	01 45 e0             	add    %eax,-0x20(%ebp)
    if (n == 1) return 1;
 174:	89 c8                	mov    %ecx,%eax
 176:	48                   	dec    %eax
 177:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 17a:	8b 55 ac             	mov    -0x54(%ebp),%edx
 17d:	75 d0                	jne    14f <fib+0xaf>
    return fib(n - 1) + fib(n - 2);
 17f:	83 e9 02             	sub    $0x2,%ecx
 182:	8b 45 e0             	mov    -0x20(%ebp),%eax
 185:	8d 5c 03 01          	lea    0x1(%ebx,%eax,1),%ebx
    if (n == 1) return 1;
 189:	83 f9 01             	cmp    $0x1,%ecx
 18c:	75 af                	jne    13d <fib+0x9d>
    return fib(n - 1) + fib(n - 2);
 18e:	83 ea 02             	sub    $0x2,%edx
 191:	8d 7c 1f 01          	lea    0x1(%edi,%ebx,1),%edi
    if (n == 1) return 1;
 195:	83 fa 01             	cmp    $0x1,%edx
 198:	75 99                	jne    133 <fib+0x93>
    return fib(n - 1) + fib(n - 2);
 19a:	89 f3                	mov    %esi,%ebx
 19c:	8b 75 b8             	mov    -0x48(%ebp),%esi
 19f:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 1a2:	89 f8                	mov    %edi,%eax
 1a4:	8b 7d bc             	mov    -0x44(%ebp),%edi
 1a7:	83 ee 02             	sub    $0x2,%esi
 1aa:	8d 4c 01 01          	lea    0x1(%ecx,%eax,1),%ecx
    if (n == 1) return 1;
 1ae:	83 fe 01             	cmp    $0x1,%esi
 1b1:	0f 85 61 ff ff ff    	jne    118 <fib+0x78>
    return fib(n - 1) + fib(n - 2);
 1b7:	8b 55 c0             	mov    -0x40(%ebp),%edx
 1ba:	83 eb 02             	sub    $0x2,%ebx
 1bd:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
    if (n == 1) return 1;
 1c1:	83 fb 01             	cmp    $0x1,%ebx
 1c4:	0f 85 3d ff ff ff    	jne    107 <fib+0x67>
    return fib(n - 1) + fib(n - 2);
 1ca:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 1cd:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 1d0:	83 ee 02             	sub    $0x2,%esi
 1d3:	8d 7c 17 01          	lea    0x1(%edi,%edx,1),%edi
    if (n == 1) return 1;
 1d7:	83 fe 01             	cmp    $0x1,%esi
 1da:	0f 85 13 ff ff ff    	jne    f3 <fib+0x53>
    return fib(n - 1) + fib(n - 2);
 1e0:	8b 55 d0             	mov    -0x30(%ebp),%edx
 1e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
 1e6:	83 eb 02             	sub    $0x2,%ebx
 1e9:	8d 4c 39 01          	lea    0x1(%ecx,%edi,1),%ecx
    if (n == 1) return 1;
 1ed:	83 fb 01             	cmp    $0x1,%ebx
 1f0:	0f 85 e9 fe ff ff    	jne    df <fib+0x3f>
    return fib(n - 1) + fib(n - 2);
 1f6:	8b 75 d8             	mov    -0x28(%ebp),%esi
 1f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 1fc:	83 ee 02             	sub    $0x2,%esi
 1ff:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
    if (n == 1) return 1;
 203:	83 fe 01             	cmp    $0x1,%esi
 206:	0f 85 bd fe ff ff    	jne    c9 <fib+0x29>
 20c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 20f:	8d 5c 13 01          	lea    0x1(%ebx,%edx,1),%ebx
 213:	83 ef 02             	sub    $0x2,%edi
 216:	83 ff 01             	cmp    $0x1,%edi
 219:	0f 87 a3 fe ff ff    	ja     c2 <fib+0x22>
 21f:	8d 43 01             	lea    0x1(%ebx),%eax
}
 222:	8d 65 f4             	lea    -0xc(%ebp),%esp
 225:	5b                   	pop    %ebx
 226:	5e                   	pop    %esi
 227:	5f                   	pop    %edi
 228:	5d                   	pop    %ebp
 229:	c3                   	ret
    if (n <= 0) return 0;
 22a:	31 c0                	xor    %eax,%eax
 22c:	eb f4                	jmp    222 <fib+0x182>
 22e:	66 90                	xchg   %ax,%ax

00000230 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 4d 08             	mov    0x8(%ebp),%ecx
 237:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 23a:	31 c0                	xor    %eax,%eax
 23c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 23f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 242:	40                   	inc    %eax
 243:	84 d2                	test   %dl,%dl
 245:	75 f5                	jne    23c <strcpy+0xc>
    ;
  return os;
}
 247:	89 c8                	mov    %ecx,%eax
 249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 24c:	c9                   	leave
 24d:	c3                   	ret
 24e:	66 90                	xchg   %ax,%ax

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
 257:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 25a:	0f b6 02             	movzbl (%edx),%eax
 25d:	84 c0                	test   %al,%al
 25f:	75 10                	jne    271 <strcmp+0x21>
 261:	eb 2a                	jmp    28d <strcmp+0x3d>
 263:	90                   	nop
    p++, q++;
 264:	42                   	inc    %edx
 265:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 268:	0f b6 02             	movzbl (%edx),%eax
 26b:	84 c0                	test   %al,%al
 26d:	74 11                	je     280 <strcmp+0x30>
 26f:	89 cb                	mov    %ecx,%ebx
 271:	0f b6 0b             	movzbl (%ebx),%ecx
 274:	38 c1                	cmp    %al,%cl
 276:	74 ec                	je     264 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 278:	29 c8                	sub    %ecx,%eax
}
 27a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 27d:	c9                   	leave
 27e:	c3                   	ret
 27f:	90                   	nop
  return (uchar)*p - (uchar)*q;
 280:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 284:	31 c0                	xor    %eax,%eax
 286:	29 c8                	sub    %ecx,%eax
}
 288:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 28b:	c9                   	leave
 28c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 28d:	0f b6 0b             	movzbl (%ebx),%ecx
 290:	31 c0                	xor    %eax,%eax
 292:	eb e4                	jmp    278 <strcmp+0x28>

00000294 <strlen>:

uint
strlen(const char *s)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 29a:	80 3a 00             	cmpb   $0x0,(%edx)
 29d:	74 15                	je     2b4 <strlen+0x20>
 29f:	31 c0                	xor    %eax,%eax
 2a1:	8d 76 00             	lea    0x0(%esi),%esi
 2a4:	40                   	inc    %eax
 2a5:	89 c1                	mov    %eax,%ecx
 2a7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2ab:	75 f7                	jne    2a4 <strlen+0x10>
    ;
  return n;
}
 2ad:	89 c8                	mov    %ecx,%eax
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret
 2b1:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2b4:	31 c9                	xor    %ecx,%ecx
}
 2b6:	89 c8                	mov    %ecx,%eax
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret
 2ba:	66 90                	xchg   %ax,%ax

000002bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2c0:	8b 7d 08             	mov    0x8(%ebp),%edi
 2c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	fc                   	cld
 2ca:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2d2:	c9                   	leave
 2d3:	c3                   	ret

000002d4 <strchr>:

char*
strchr(const char *s, char c)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 2dd:	8a 10                	mov    (%eax),%dl
 2df:	84 d2                	test   %dl,%dl
 2e1:	75 0c                	jne    2ef <strchr+0x1b>
 2e3:	eb 13                	jmp    2f8 <strchr+0x24>
 2e5:	8d 76 00             	lea    0x0(%esi),%esi
 2e8:	40                   	inc    %eax
 2e9:	8a 10                	mov    (%eax),%dl
 2eb:	84 d2                	test   %dl,%dl
 2ed:	74 09                	je     2f8 <strchr+0x24>
    if(*s == c)
 2ef:	38 d1                	cmp    %dl,%cl
 2f1:	75 f5                	jne    2e8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 2f3:	5d                   	pop    %ebp
 2f4:	c3                   	ret
 2f5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 2f8:	31 c0                	xor    %eax,%eax
}
 2fa:	5d                   	pop    %ebp
 2fb:	c3                   	ret

000002fc <gets>:

char*
gets(char *buf, int max)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	57                   	push   %edi
 300:	56                   	push   %esi
 301:	53                   	push   %ebx
 302:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 305:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 307:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 30a:	eb 24                	jmp    330 <gets+0x34>
    cc = read(0, &c, 1);
 30c:	50                   	push   %eax
 30d:	6a 01                	push   $0x1
 30f:	56                   	push   %esi
 310:	6a 00                	push   $0x0
 312:	e8 f4 00 00 00       	call   40b <read>
    if(cc < 1)
 317:	83 c4 10             	add    $0x10,%esp
 31a:	85 c0                	test   %eax,%eax
 31c:	7e 1a                	jle    338 <gets+0x3c>
      break;
    buf[i++] = c;
 31e:	8a 45 e7             	mov    -0x19(%ebp),%al
 321:	8b 55 08             	mov    0x8(%ebp),%edx
 324:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 328:	3c 0a                	cmp    $0xa,%al
 32a:	74 0e                	je     33a <gets+0x3e>
 32c:	3c 0d                	cmp    $0xd,%al
 32e:	74 0a                	je     33a <gets+0x3e>
  for(i=0; i+1 < max; ){
 330:	89 df                	mov    %ebx,%edi
 332:	43                   	inc    %ebx
 333:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 336:	7c d4                	jl     30c <gets+0x10>
 338:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 341:	8d 65 f4             	lea    -0xc(%ebp),%esp
 344:	5b                   	pop    %ebx
 345:	5e                   	pop    %esi
 346:	5f                   	pop    %edi
 347:	5d                   	pop    %ebp
 348:	c3                   	ret
 349:	8d 76 00             	lea    0x0(%esi),%esi

0000034c <stat>:

int
stat(const char *n, struct stat *st)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	56                   	push   %esi
 350:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 351:	83 ec 08             	sub    $0x8,%esp
 354:	6a 00                	push   $0x0
 356:	ff 75 08             	push   0x8(%ebp)
 359:	e8 d5 00 00 00       	call   433 <open>
  if(fd < 0)
 35e:	83 c4 10             	add    $0x10,%esp
 361:	85 c0                	test   %eax,%eax
 363:	78 27                	js     38c <stat+0x40>
 365:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 367:	83 ec 08             	sub    $0x8,%esp
 36a:	ff 75 0c             	push   0xc(%ebp)
 36d:	50                   	push   %eax
 36e:	e8 d8 00 00 00       	call   44b <fstat>
 373:	89 c6                	mov    %eax,%esi
  close(fd);
 375:	89 1c 24             	mov    %ebx,(%esp)
 378:	e8 9e 00 00 00       	call   41b <close>
  return r;
 37d:	83 c4 10             	add    $0x10,%esp
}
 380:	89 f0                	mov    %esi,%eax
 382:	8d 65 f8             	lea    -0x8(%ebp),%esp
 385:	5b                   	pop    %ebx
 386:	5e                   	pop    %esi
 387:	5d                   	pop    %ebp
 388:	c3                   	ret
 389:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 38c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 391:	eb ed                	jmp    380 <stat+0x34>
 393:	90                   	nop

00000394 <atoi>:

int
atoi(const char *s)
{
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	53                   	push   %ebx
 398:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39b:	0f be 01             	movsbl (%ecx),%eax
 39e:	8d 50 d0             	lea    -0x30(%eax),%edx
 3a1:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 3a4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 3a9:	77 16                	ja     3c1 <atoi+0x2d>
 3ab:	90                   	nop
    n = n*10 + *s++ - '0';
 3ac:	41                   	inc    %ecx
 3ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
 3b0:	01 d2                	add    %edx,%edx
 3b2:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 3b6:	0f be 01             	movsbl (%ecx),%eax
 3b9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3bc:	80 fb 09             	cmp    $0x9,%bl
 3bf:	76 eb                	jbe    3ac <atoi+0x18>
  return n;
}
 3c1:	89 d0                	mov    %edx,%eax
 3c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c6:	c9                   	leave
 3c7:	c3                   	ret

000003c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	57                   	push   %edi
 3cc:	56                   	push   %esi
 3cd:	8b 55 08             	mov    0x8(%ebp),%edx
 3d0:	8b 75 0c             	mov    0xc(%ebp),%esi
 3d3:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d6:	85 c0                	test   %eax,%eax
 3d8:	7e 0b                	jle    3e5 <memmove+0x1d>
 3da:	01 d0                	add    %edx,%eax
  dst = vdst;
 3dc:	89 d7                	mov    %edx,%edi
 3de:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3e1:	39 f8                	cmp    %edi,%eax
 3e3:	75 fb                	jne    3e0 <memmove+0x18>
  return vdst;
}
 3e5:	89 d0                	mov    %edx,%eax
 3e7:	5e                   	pop    %esi
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret

000003eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3eb:	b8 01 00 00 00       	mov    $0x1,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <exit>:
SYSCALL(exit)
 3f3:	b8 02 00 00 00       	mov    $0x2,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <wait>:
SYSCALL(wait)
 3fb:	b8 03 00 00 00       	mov    $0x3,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <pipe>:
SYSCALL(pipe)
 403:	b8 04 00 00 00       	mov    $0x4,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <read>:
SYSCALL(read)
 40b:	b8 05 00 00 00       	mov    $0x5,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <write>:
SYSCALL(write)
 413:	b8 10 00 00 00       	mov    $0x10,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <close>:
SYSCALL(close)
 41b:	b8 15 00 00 00       	mov    $0x15,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <kill>:
SYSCALL(kill)
 423:	b8 06 00 00 00       	mov    $0x6,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <exec>:
SYSCALL(exec)
 42b:	b8 07 00 00 00       	mov    $0x7,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <open>:
SYSCALL(open)
 433:	b8 0f 00 00 00       	mov    $0xf,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <mknod>:
SYSCALL(mknod)
 43b:	b8 11 00 00 00       	mov    $0x11,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <unlink>:
SYSCALL(unlink)
 443:	b8 12 00 00 00       	mov    $0x12,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <fstat>:
SYSCALL(fstat)
 44b:	b8 08 00 00 00       	mov    $0x8,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <link>:
SYSCALL(link)
 453:	b8 13 00 00 00       	mov    $0x13,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <mkdir>:
SYSCALL(mkdir)
 45b:	b8 14 00 00 00       	mov    $0x14,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <chdir>:
SYSCALL(chdir)
 463:	b8 09 00 00 00       	mov    $0x9,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <dup>:
SYSCALL(dup)
 46b:	b8 0a 00 00 00       	mov    $0xa,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <getpid>:
SYSCALL(getpid)
 473:	b8 0b 00 00 00       	mov    $0xb,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <sbrk>:
SYSCALL(sbrk)
 47b:	b8 0c 00 00 00       	mov    $0xc,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <sleep>:
SYSCALL(sleep)
 483:	b8 0d 00 00 00       	mov    $0xd,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <uptime>:
SYSCALL(uptime)
 48b:	b8 0e 00 00 00       	mov    $0xe,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret
 493:	90                   	nop

00000494 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	57                   	push   %edi
 498:	56                   	push   %esi
 499:	53                   	push   %ebx
 49a:	83 ec 3c             	sub    $0x3c,%esp
 49d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4a0:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4a5:	85 c9                	test   %ecx,%ecx
 4a7:	74 04                	je     4ad <printint+0x19>
 4a9:	85 d2                	test   %edx,%edx
 4ab:	78 6b                	js     518 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ad:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 4b0:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 4b7:	31 c9                	xor    %ecx,%ecx
 4b9:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 4bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4bf:	31 d2                	xor    %edx,%edx
 4c1:	f7 f3                	div    %ebx
 4c3:	89 cf                	mov    %ecx,%edi
 4c5:	8d 49 01             	lea    0x1(%ecx),%ecx
 4c8:	8a 92 c4 08 00 00    	mov    0x8c4(%edx),%dl
 4ce:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 4d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 4d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4d8:	39 da                	cmp    %ebx,%edx
 4da:	73 e0                	jae    4bc <printint+0x28>
  if(neg)
 4dc:	8b 55 08             	mov    0x8(%ebp),%edx
 4df:	85 d2                	test   %edx,%edx
 4e1:	74 07                	je     4ea <printint+0x56>
    buf[i++] = '-';
 4e3:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 4e8:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 4ea:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 4ed:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 4f1:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 4f4:	8a 07                	mov    (%edi),%al
 4f6:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 4f9:	50                   	push   %eax
 4fa:	6a 01                	push   $0x1
 4fc:	56                   	push   %esi
 4fd:	ff 75 c0             	push   -0x40(%ebp)
 500:	e8 0e ff ff ff       	call   413 <write>
  while(--i >= 0)
 505:	89 f8                	mov    %edi,%eax
 507:	4f                   	dec    %edi
 508:	83 c4 10             	add    $0x10,%esp
 50b:	39 d8                	cmp    %ebx,%eax
 50d:	75 e5                	jne    4f4 <printint+0x60>
}
 50f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 512:	5b                   	pop    %ebx
 513:	5e                   	pop    %esi
 514:	5f                   	pop    %edi
 515:	5d                   	pop    %ebp
 516:	c3                   	ret
 517:	90                   	nop
    x = -xx;
 518:	f7 da                	neg    %edx
 51a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 51d:	eb 98                	jmp    4b7 <printint+0x23>
 51f:	90                   	nop

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 2c             	sub    $0x2c,%esp
 529:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 52c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 52f:	8a 03                	mov    (%ebx),%al
 531:	84 c0                	test   %al,%al
 533:	74 2a                	je     55f <printf+0x3f>
 535:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 536:	8d 4d 10             	lea    0x10(%ebp),%ecx
 539:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 53c:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 53f:	83 fa 25             	cmp    $0x25,%edx
 542:	74 24                	je     568 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 544:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 547:	50                   	push   %eax
 548:	6a 01                	push   $0x1
 54a:	8d 45 e7             	lea    -0x19(%ebp),%eax
 54d:	50                   	push   %eax
 54e:	56                   	push   %esi
 54f:	e8 bf fe ff ff       	call   413 <write>
  for(i = 0; fmt[i]; i++){
 554:	43                   	inc    %ebx
 555:	8a 43 ff             	mov    -0x1(%ebx),%al
 558:	83 c4 10             	add    $0x10,%esp
 55b:	84 c0                	test   %al,%al
 55d:	75 dd                	jne    53c <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 55f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 562:	5b                   	pop    %ebx
 563:	5e                   	pop    %esi
 564:	5f                   	pop    %edi
 565:	5d                   	pop    %ebp
 566:	c3                   	ret
 567:	90                   	nop
  for(i = 0; fmt[i]; i++){
 568:	8a 13                	mov    (%ebx),%dl
 56a:	84 d2                	test   %dl,%dl
 56c:	74 f1                	je     55f <printf+0x3f>
    c = fmt[i] & 0xff;
 56e:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 571:	80 fa 25             	cmp    $0x25,%dl
 574:	0f 84 fe 00 00 00    	je     678 <printf+0x158>
 57a:	83 e8 63             	sub    $0x63,%eax
 57d:	83 f8 15             	cmp    $0x15,%eax
 580:	77 0a                	ja     58c <printf+0x6c>
 582:	ff 24 85 6c 08 00 00 	jmp    *0x86c(,%eax,4)
 589:	8d 76 00             	lea    0x0(%esi),%esi
 58c:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 58f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 593:	50                   	push   %eax
 594:	6a 01                	push   $0x1
 596:	8d 7d e7             	lea    -0x19(%ebp),%edi
 599:	57                   	push   %edi
 59a:	56                   	push   %esi
 59b:	e8 73 fe ff ff       	call   413 <write>
        putc(fd, c);
 5a0:	8a 55 d0             	mov    -0x30(%ebp),%dl
 5a3:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5a6:	83 c4 0c             	add    $0xc,%esp
 5a9:	6a 01                	push   $0x1
 5ab:	57                   	push   %edi
 5ac:	56                   	push   %esi
 5ad:	e8 61 fe ff ff       	call   413 <write>
  for(i = 0; fmt[i]; i++){
 5b2:	83 c3 02             	add    $0x2,%ebx
 5b5:	8a 43 ff             	mov    -0x1(%ebx),%al
 5b8:	83 c4 10             	add    $0x10,%esp
 5bb:	84 c0                	test   %al,%al
 5bd:	0f 85 79 ff ff ff    	jne    53c <printf+0x1c>
}
 5c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c6:	5b                   	pop    %ebx
 5c7:	5e                   	pop    %esi
 5c8:	5f                   	pop    %edi
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret
 5cb:	90                   	nop
        printint(fd, *ap, 16, 0);
 5cc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5cf:	8b 17                	mov    (%edi),%edx
 5d1:	83 ec 0c             	sub    $0xc,%esp
 5d4:	6a 00                	push   $0x0
 5d6:	b9 10 00 00 00       	mov    $0x10,%ecx
 5db:	89 f0                	mov    %esi,%eax
 5dd:	e8 b2 fe ff ff       	call   494 <printint>
        ap++;
 5e2:	83 c7 04             	add    $0x4,%edi
 5e5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 5e8:	eb c8                	jmp    5b2 <printf+0x92>
 5ea:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 5ec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 5ef:	8b 01                	mov    (%ecx),%eax
        ap++;
 5f1:	83 c1 04             	add    $0x4,%ecx
 5f4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 5f7:	85 c0                	test   %eax,%eax
 5f9:	0f 84 89 00 00 00    	je     688 <printf+0x168>
        while(*s != 0){
 5ff:	8a 10                	mov    (%eax),%dl
 601:	84 d2                	test   %dl,%dl
 603:	74 29                	je     62e <printf+0x10e>
 605:	89 c7                	mov    %eax,%edi
 607:	88 d0                	mov    %dl,%al
 609:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 60c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 60f:	89 fb                	mov    %edi,%ebx
 611:	89 cf                	mov    %ecx,%edi
 613:	90                   	nop
          putc(fd, *s);
 614:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 617:	50                   	push   %eax
 618:	6a 01                	push   $0x1
 61a:	57                   	push   %edi
 61b:	56                   	push   %esi
 61c:	e8 f2 fd ff ff       	call   413 <write>
          s++;
 621:	43                   	inc    %ebx
        while(*s != 0){
 622:	8a 03                	mov    (%ebx),%al
 624:	83 c4 10             	add    $0x10,%esp
 627:	84 c0                	test   %al,%al
 629:	75 e9                	jne    614 <printf+0xf4>
 62b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 62e:	83 c3 02             	add    $0x2,%ebx
 631:	8a 43 ff             	mov    -0x1(%ebx),%al
 634:	84 c0                	test   %al,%al
 636:	0f 85 00 ff ff ff    	jne    53c <printf+0x1c>
 63c:	e9 1e ff ff ff       	jmp    55f <printf+0x3f>
 641:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 644:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 647:	8b 17                	mov    (%edi),%edx
 649:	83 ec 0c             	sub    $0xc,%esp
 64c:	6a 01                	push   $0x1
 64e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 653:	eb 86                	jmp    5db <printf+0xbb>
 655:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 660:	51                   	push   %ecx
 661:	6a 01                	push   $0x1
 663:	8d 7d e7             	lea    -0x19(%ebp),%edi
 666:	57                   	push   %edi
 667:	56                   	push   %esi
 668:	e8 a6 fd ff ff       	call   413 <write>
        ap++;
 66d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 671:	e9 3c ff ff ff       	jmp    5b2 <printf+0x92>
 676:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 678:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 67b:	52                   	push   %edx
 67c:	6a 01                	push   $0x1
 67e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 681:	e9 25 ff ff ff       	jmp    5ab <printf+0x8b>
 686:	66 90                	xchg   %ax,%ax
          s = "(null)";
 688:	bf 65 08 00 00       	mov    $0x865,%edi
 68d:	b0 28                	mov    $0x28,%al
 68f:	e9 75 ff ff ff       	jmp    609 <printf+0xe9>

00000694 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	57                   	push   %edi
 698:	56                   	push   %esi
 699:	53                   	push   %ebx
 69a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	a1 d8 08 00 00       	mov    0x8d8,%eax
 6a5:	8d 76 00             	lea    0x0(%esi),%esi
 6a8:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	39 ca                	cmp    %ecx,%edx
 6ae:	73 2c                	jae    6dc <free+0x48>
 6b0:	39 c1                	cmp    %eax,%ecx
 6b2:	72 04                	jb     6b8 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b4:	39 c2                	cmp    %eax,%edx
 6b6:	72 f0                	jb     6a8 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6be:	39 f8                	cmp    %edi,%eax
 6c0:	74 2c                	je     6ee <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c5:	8b 42 04             	mov    0x4(%edx),%eax
 6c8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6cb:	39 f1                	cmp    %esi,%ecx
 6cd:	74 36                	je     705 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6cf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 6d1:	89 15 d8 08 00 00    	mov    %edx,0x8d8
}
 6d7:	5b                   	pop    %ebx
 6d8:	5e                   	pop    %esi
 6d9:	5f                   	pop    %edi
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dc:	39 c2                	cmp    %eax,%edx
 6de:	72 c8                	jb     6a8 <free+0x14>
 6e0:	39 c1                	cmp    %eax,%ecx
 6e2:	73 c4                	jae    6a8 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 6e4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6e7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ea:	39 f8                	cmp    %edi,%eax
 6ec:	75 d4                	jne    6c2 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 6ee:	03 70 04             	add    0x4(%eax),%esi
 6f1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f4:	8b 02                	mov    (%edx),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6fb:	8b 42 04             	mov    0x4(%edx),%eax
 6fe:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 701:	39 f1                	cmp    %esi,%ecx
 703:	75 ca                	jne    6cf <free+0x3b>
    p->s.size += bp->s.size;
 705:	03 43 fc             	add    -0x4(%ebx),%eax
 708:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 70b:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 70e:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 710:	89 15 d8 08 00 00    	mov    %edx,0x8d8
}
 716:	5b                   	pop    %ebx
 717:	5e                   	pop    %esi
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret
 71b:	90                   	nop

0000071c <malloc>:
}


void*
malloc(uint nbytes)
{
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	57                   	push   %edi
 720:	56                   	push   %esi
 721:	53                   	push   %ebx
 722:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	8d 78 07             	lea    0x7(%eax),%edi
 72b:	c1 ef 03             	shr    $0x3,%edi
 72e:	47                   	inc    %edi
  if((prevp = freep) == 0){
 72f:	8b 15 d8 08 00 00    	mov    0x8d8,%edx
 735:	85 d2                	test   %edx,%edx
 737:	0f 84 93 00 00 00    	je     7d0 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 73f:	8b 48 04             	mov    0x4(%eax),%ecx
 742:	39 f9                	cmp    %edi,%ecx
 744:	73 62                	jae    7a8 <malloc+0x8c>
  if(nu < 4096)
 746:	89 fb                	mov    %edi,%ebx
 748:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 74e:	72 78                	jb     7c8 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 750:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 757:	eb 0e                	jmp    767 <malloc+0x4b>
 759:	8d 76 00             	lea    0x0(%esi),%esi
 75c:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 760:	8b 48 04             	mov    0x4(%eax),%ecx
 763:	39 f9                	cmp    %edi,%ecx
 765:	73 41                	jae    7a8 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 767:	39 05 d8 08 00 00    	cmp    %eax,0x8d8
 76d:	75 ed                	jne    75c <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	56                   	push   %esi
 773:	e8 03 fd ff ff       	call   47b <sbrk>
  if(p == (char*)-1)
 778:	83 c4 10             	add    $0x10,%esp
 77b:	83 f8 ff             	cmp    $0xffffffff,%eax
 77e:	74 1c                	je     79c <malloc+0x80>
  hp->s.size = nu;
 780:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	83 c0 08             	add    $0x8,%eax
 789:	50                   	push   %eax
 78a:	e8 05 ff ff ff       	call   694 <free>
  return freep;
 78f:	8b 15 d8 08 00 00    	mov    0x8d8,%edx
      if((p = morecore(nunits)) == 0)
 795:	83 c4 10             	add    $0x10,%esp
 798:	85 d2                	test   %edx,%edx
 79a:	75 c2                	jne    75e <malloc+0x42>
        return 0;
 79c:	31 c0                	xor    %eax,%eax
  }
}
 79e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7a1:	5b                   	pop    %ebx
 7a2:	5e                   	pop    %esi
 7a3:	5f                   	pop    %edi
 7a4:	5d                   	pop    %ebp
 7a5:	c3                   	ret
 7a6:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 7a8:	39 cf                	cmp    %ecx,%edi
 7aa:	74 4c                	je     7f8 <malloc+0xdc>
        p->s.size -= nunits;
 7ac:	29 f9                	sub    %edi,%ecx
 7ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7b4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7b7:	89 15 d8 08 00 00    	mov    %edx,0x8d8
      return (void*)(p + 1);
 7bd:	83 c0 08             	add    $0x8,%eax
}
 7c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7c3:	5b                   	pop    %ebx
 7c4:	5e                   	pop    %esi
 7c5:	5f                   	pop    %edi
 7c6:	5d                   	pop    %ebp
 7c7:	c3                   	ret
  if(nu < 4096)
 7c8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7cd:	eb 81                	jmp    750 <malloc+0x34>
 7cf:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 05 d8 08 00 00 dc 	movl   $0x8dc,0x8d8
 7d7:	08 00 00 
 7da:	c7 05 dc 08 00 00 dc 	movl   $0x8dc,0x8dc
 7e1:	08 00 00 
    base.s.size = 0;
 7e4:	c7 05 e0 08 00 00 00 	movl   $0x0,0x8e0
 7eb:	00 00 00 
 7ee:	b8 dc 08 00 00       	mov    $0x8dc,%eax
 7f3:	e9 4e ff ff ff       	jmp    746 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 7f8:	8b 08                	mov    (%eax),%ecx
 7fa:	89 0a                	mov    %ecx,(%edx)
 7fc:	eb b9                	jmp    7b7 <malloc+0x9b>
