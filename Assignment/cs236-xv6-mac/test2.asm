
_test2:     file format elf32-i386


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
   f:	e8 e3 03 00 00       	call   3f7 <fork>
         if (pid != 0) {
  14:	85 c0                	test   %eax,%eax
  16:	74 43                	je     5b <main+0x5b>
         printf(1, "Parent started with pid: %d\n", getpid());
  18:	e8 62 04 00 00       	call   47f <getpid>
  1d:	51                   	push   %ecx
  1e:	50                   	push   %eax
  1f:	68 14 08 00 00       	push   $0x814
  24:	6a 01                	push   $0x1
  26:	e8 09 05 00 00       	call   534 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	66 90                	xchg   %ax,%ax
         while (1) 
           {
             printf(1, "Hello , I am parent\n");
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 31 08 00 00       	push   $0x831
  38:	6a 01                	push   $0x1
  3a:	e8 f5 04 00 00       	call   534 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	bb 22 00 00 00       	mov    $0x22,%ebx
  47:	90                   	nop
    return fib(n - 1) + fib(n - 2);
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	53                   	push   %ebx
  4c:	e8 5b 00 00 00       	call   ac <fib>
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
  5b:	e8 1f 04 00 00       	call   47f <getpid>
  60:	52                   	push   %edx
  61:	50                   	push   %eax
  62:	68 46 08 00 00       	push   $0x846
  67:	6a 01                	push   $0x1
  69:	e8 c6 04 00 00       	call   534 <printf>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	8d 76 00             	lea    0x0(%esi),%esi
        while (1) {
       printf(1, "Hi there , I am child\n");
  74:	83 ec 08             	sub    $0x8,%esp
  77:	68 62 08 00 00       	push   $0x862
  7c:	6a 01                	push   $0x1
  7e:	e8 b1 04 00 00       	call   534 <printf>
  83:	83 c4 10             	add    $0x10,%esp
  86:	bb 22 00 00 00       	mov    $0x22,%ebx
  8b:	90                   	nop
    return fib(n - 1) + fib(n - 2);
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	e8 17 00 00 00       	call   ac <fib>
  95:	83 c4 10             	add    $0x10,%esp
    if (n == 1) return 1;
  98:	83 eb 02             	sub    $0x2,%ebx
  9b:	75 ef                	jne    8c <main+0x8c>
       fib (35);
       sleep(10);   
  9d:	83 ec 0c             	sub    $0xc,%esp
  a0:	6a 0a                	push   $0xa
  a2:	e8 e8 03 00 00       	call   48f <sleep>
  a7:	83 c4 10             	add    $0x10,%esp
  aa:	eb c8                	jmp    74 <main+0x74>

000000ac <fib>:
int fib(int n) {
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	57                   	push   %edi
  b0:	56                   	push   %esi
  b1:	53                   	push   %ebx
  b2:	83 ec 4c             	sub    $0x4c,%esp
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
    if (n <= 0) return 0;
  b8:	85 c0                	test   %eax,%eax
  ba:	0f 8e 76 01 00 00    	jle    236 <fib+0x18a>
    if (n == 1) return 1;
  c0:	8d 78 ff             	lea    -0x1(%eax),%edi
  c3:	31 db                	xor    %ebx,%ebx
  c5:	83 ff 01             	cmp    $0x1,%edi
  c8:	0f 86 5d 01 00 00    	jbe    22b <fib+0x17f>
    return fib(n - 1) + fib(n - 2);
  ce:	89 fe                	mov    %edi,%esi
  d0:	31 d2                	xor    %edx,%edx
  d2:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    if (n == 2) return 1;
  d5:	83 fe 02             	cmp    $0x2,%esi
  d8:	0f 84 3a 01 00 00    	je     218 <fib+0x16c>
    return fib(n - 1) + fib(n - 2);
  de:	8d 5e ff             	lea    -0x1(%esi),%ebx
  e1:	31 c0                	xor    %eax,%eax
  e3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  e6:	89 c1                	mov    %eax,%ecx
  e8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    if (n == 2) return 1;
  eb:	83 fb 02             	cmp    $0x2,%ebx
  ee:	0f 84 0e 01 00 00    	je     202 <fib+0x156>
    return fib(n - 1) + fib(n - 2);
  f4:	8d 73 ff             	lea    -0x1(%ebx),%esi
  f7:	31 ff                	xor    %edi,%edi
  f9:	89 55 d0             	mov    %edx,-0x30(%ebp)
  fc:	89 5d cc             	mov    %ebx,-0x34(%ebp)
    if (n == 2) return 1;
  ff:	83 fe 02             	cmp    $0x2,%esi
 102:	0f 84 e4 00 00 00    	je     1ec <fib+0x140>
    return fib(n - 1) + fib(n - 2);
 108:	8d 5e ff             	lea    -0x1(%esi),%ebx
 10b:	31 d2                	xor    %edx,%edx
 10d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
 110:	89 75 c4             	mov    %esi,-0x3c(%ebp)
    if (n == 2) return 1;
 113:	83 fb 02             	cmp    $0x2,%ebx
 116:	0f 84 ba 00 00 00    	je     1d6 <fib+0x12a>
    return fib(n - 1) + fib(n - 2);
 11c:	8d 73 ff             	lea    -0x1(%ebx),%esi
 11f:	31 c9                	xor    %ecx,%ecx
 121:	89 55 c0             	mov    %edx,-0x40(%ebp)
    if (n == 2) return 1;
 124:	83 fe 02             	cmp    $0x2,%esi
 127:	0f 84 96 00 00 00    	je     1c3 <fib+0x117>
    return fib(n - 1) + fib(n - 2);
 12d:	8d 56 ff             	lea    -0x1(%esi),%edx
 130:	31 c0                	xor    %eax,%eax
 132:	89 7d bc             	mov    %edi,-0x44(%ebp)
 135:	89 75 b8             	mov    %esi,-0x48(%ebp)
 138:	89 de                	mov    %ebx,%esi
 13a:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
 13d:	89 c7                	mov    %eax,%edi
    if (n == 2) return 1;
 13f:	83 fa 02             	cmp    $0x2,%edx
 142:	74 62                	je     1a6 <fib+0xfa>
    return fib(n - 1) + fib(n - 2);
 144:	8d 4a ff             	lea    -0x1(%edx),%ecx
 147:	31 db                	xor    %ebx,%ebx
    if (n == 2) return 1;
 149:	83 f9 02             	cmp    $0x2,%ecx
 14c:	74 4c                	je     19a <fib+0xee>
    return fib(n - 1) + fib(n - 2);
 14e:	8d 41 ff             	lea    -0x1(%ecx),%eax
 151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 154:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    if (n == 2) return 1;
 15b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 15e:	83 f8 02             	cmp    $0x2,%eax
 161:	74 28                	je     18b <fib+0xdf>
 163:	89 55 ac             	mov    %edx,-0x54(%ebp)
 166:	89 4d b0             	mov    %ecx,-0x50(%ebp)
    return fib(n - 1) + fib(n - 2);
 169:	83 ec 0c             	sub    $0xc,%esp
 16c:	48                   	dec    %eax
 16d:	50                   	push   %eax
 16e:	e8 39 ff ff ff       	call   ac <fib>
 173:	83 c4 10             	add    $0x10,%esp
 176:	83 6d e4 02          	subl   $0x2,-0x1c(%ebp)
 17a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 17d:	01 45 e0             	add    %eax,-0x20(%ebp)
    if (n == 1) return 1;
 180:	89 c8                	mov    %ecx,%eax
 182:	48                   	dec    %eax
 183:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 186:	8b 55 ac             	mov    -0x54(%ebp),%edx
 189:	75 d0                	jne    15b <fib+0xaf>
    return fib(n - 1) + fib(n - 2);
 18b:	83 e9 02             	sub    $0x2,%ecx
 18e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 191:	8d 5c 03 01          	lea    0x1(%ebx,%eax,1),%ebx
    if (n == 1) return 1;
 195:	83 f9 01             	cmp    $0x1,%ecx
 198:	75 af                	jne    149 <fib+0x9d>
    return fib(n - 1) + fib(n - 2);
 19a:	83 ea 02             	sub    $0x2,%edx
 19d:	8d 7c 1f 01          	lea    0x1(%edi,%ebx,1),%edi
    if (n == 1) return 1;
 1a1:	83 fa 01             	cmp    $0x1,%edx
 1a4:	75 99                	jne    13f <fib+0x93>
    return fib(n - 1) + fib(n - 2);
 1a6:	89 f3                	mov    %esi,%ebx
 1a8:	8b 75 b8             	mov    -0x48(%ebp),%esi
 1ab:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 1ae:	89 f8                	mov    %edi,%eax
 1b0:	8b 7d bc             	mov    -0x44(%ebp),%edi
 1b3:	83 ee 02             	sub    $0x2,%esi
 1b6:	8d 4c 01 01          	lea    0x1(%ecx,%eax,1),%ecx
    if (n == 1) return 1;
 1ba:	83 fe 01             	cmp    $0x1,%esi
 1bd:	0f 85 61 ff ff ff    	jne    124 <fib+0x78>
    return fib(n - 1) + fib(n - 2);
 1c3:	8b 55 c0             	mov    -0x40(%ebp),%edx
 1c6:	83 eb 02             	sub    $0x2,%ebx
 1c9:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
    if (n == 1) return 1;
 1cd:	83 fb 01             	cmp    $0x1,%ebx
 1d0:	0f 85 3d ff ff ff    	jne    113 <fib+0x67>
    return fib(n - 1) + fib(n - 2);
 1d6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 1d9:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 1dc:	83 ee 02             	sub    $0x2,%esi
 1df:	8d 7c 17 01          	lea    0x1(%edi,%edx,1),%edi
    if (n == 1) return 1;
 1e3:	83 fe 01             	cmp    $0x1,%esi
 1e6:	0f 85 13 ff ff ff    	jne    ff <fib+0x53>
    return fib(n - 1) + fib(n - 2);
 1ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
 1ef:	8b 5d cc             	mov    -0x34(%ebp),%ebx
 1f2:	83 eb 02             	sub    $0x2,%ebx
 1f5:	8d 4c 39 01          	lea    0x1(%ecx,%edi,1),%ecx
    if (n == 1) return 1;
 1f9:	83 fb 01             	cmp    $0x1,%ebx
 1fc:	0f 85 e9 fe ff ff    	jne    eb <fib+0x3f>
    return fib(n - 1) + fib(n - 2);
 202:	8b 75 d8             	mov    -0x28(%ebp),%esi
 205:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 208:	83 ee 02             	sub    $0x2,%esi
 20b:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
    if (n == 1) return 1;
 20f:	83 fe 01             	cmp    $0x1,%esi
 212:	0f 85 bd fe ff ff    	jne    d5 <fib+0x29>
 218:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 21b:	8d 5c 13 01          	lea    0x1(%ebx,%edx,1),%ebx
 21f:	83 ef 02             	sub    $0x2,%edi
 222:	83 ff 01             	cmp    $0x1,%edi
 225:	0f 87 a3 fe ff ff    	ja     ce <fib+0x22>
 22b:	8d 43 01             	lea    0x1(%ebx),%eax
}
 22e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 231:	5b                   	pop    %ebx
 232:	5e                   	pop    %esi
 233:	5f                   	pop    %edi
 234:	5d                   	pop    %ebp
 235:	c3                   	ret
    if (n <= 0) return 0;
 236:	31 c0                	xor    %eax,%eax
 238:	eb f4                	jmp    22e <fib+0x182>
 23a:	66 90                	xchg   %ax,%ax

0000023c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	53                   	push   %ebx
 240:	8b 4d 08             	mov    0x8(%ebp),%ecx
 243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 246:	31 c0                	xor    %eax,%eax
 248:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 24b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 24e:	40                   	inc    %eax
 24f:	84 d2                	test   %dl,%dl
 251:	75 f5                	jne    248 <strcpy+0xc>
    ;
  return os;
}
 253:	89 c8                	mov    %ecx,%eax
 255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 258:	c9                   	leave
 259:	c3                   	ret
 25a:	66 90                	xchg   %ax,%ax

0000025c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	53                   	push   %ebx
 260:	8b 55 08             	mov    0x8(%ebp),%edx
 263:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 266:	0f b6 02             	movzbl (%edx),%eax
 269:	84 c0                	test   %al,%al
 26b:	75 10                	jne    27d <strcmp+0x21>
 26d:	eb 2a                	jmp    299 <strcmp+0x3d>
 26f:	90                   	nop
    p++, q++;
 270:	42                   	inc    %edx
 271:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 274:	0f b6 02             	movzbl (%edx),%eax
 277:	84 c0                	test   %al,%al
 279:	74 11                	je     28c <strcmp+0x30>
 27b:	89 cb                	mov    %ecx,%ebx
 27d:	0f b6 0b             	movzbl (%ebx),%ecx
 280:	38 c1                	cmp    %al,%cl
 282:	74 ec                	je     270 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 284:	29 c8                	sub    %ecx,%eax
}
 286:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 289:	c9                   	leave
 28a:	c3                   	ret
 28b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 28c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 290:	31 c0                	xor    %eax,%eax
 292:	29 c8                	sub    %ecx,%eax
}
 294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 297:	c9                   	leave
 298:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 299:	0f b6 0b             	movzbl (%ebx),%ecx
 29c:	31 c0                	xor    %eax,%eax
 29e:	eb e4                	jmp    284 <strcmp+0x28>

000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2a6:	80 3a 00             	cmpb   $0x0,(%edx)
 2a9:	74 15                	je     2c0 <strlen+0x20>
 2ab:	31 c0                	xor    %eax,%eax
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
 2b0:	40                   	inc    %eax
 2b1:	89 c1                	mov    %eax,%ecx
 2b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2b7:	75 f7                	jne    2b0 <strlen+0x10>
    ;
  return n;
}
 2b9:	89 c8                	mov    %ecx,%eax
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2c0:	31 c9                	xor    %ecx,%ecx
}
 2c2:	89 c8                	mov    %ecx,%eax
 2c4:	5d                   	pop    %ebp
 2c5:	c3                   	ret
 2c6:	66 90                	xchg   %ax,%ax

000002c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2cc:	8b 7d 08             	mov    0x8(%ebp),%edi
 2cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d5:	fc                   	cld
 2d6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2de:	c9                   	leave
 2df:	c3                   	ret

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 2e9:	8a 10                	mov    (%eax),%dl
 2eb:	84 d2                	test   %dl,%dl
 2ed:	75 0c                	jne    2fb <strchr+0x1b>
 2ef:	eb 13                	jmp    304 <strchr+0x24>
 2f1:	8d 76 00             	lea    0x0(%esi),%esi
 2f4:	40                   	inc    %eax
 2f5:	8a 10                	mov    (%eax),%dl
 2f7:	84 d2                	test   %dl,%dl
 2f9:	74 09                	je     304 <strchr+0x24>
    if(*s == c)
 2fb:	38 d1                	cmp    %dl,%cl
 2fd:	75 f5                	jne    2f4 <strchr+0x14>
      return (char*)s;
  return 0;
}
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret
 301:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 304:	31 c0                	xor    %eax,%eax
}
 306:	5d                   	pop    %ebp
 307:	c3                   	ret

00000308 <gets>:

char*
gets(char *buf, int max)
{
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	57                   	push   %edi
 30c:	56                   	push   %esi
 30d:	53                   	push   %ebx
 30e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 311:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 313:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 316:	eb 24                	jmp    33c <gets+0x34>
    cc = read(0, &c, 1);
 318:	50                   	push   %eax
 319:	6a 01                	push   $0x1
 31b:	56                   	push   %esi
 31c:	6a 00                	push   $0x0
 31e:	e8 f4 00 00 00       	call   417 <read>
    if(cc < 1)
 323:	83 c4 10             	add    $0x10,%esp
 326:	85 c0                	test   %eax,%eax
 328:	7e 1a                	jle    344 <gets+0x3c>
      break;
    buf[i++] = c;
 32a:	8a 45 e7             	mov    -0x19(%ebp),%al
 32d:	8b 55 08             	mov    0x8(%ebp),%edx
 330:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 334:	3c 0a                	cmp    $0xa,%al
 336:	74 0e                	je     346 <gets+0x3e>
 338:	3c 0d                	cmp    $0xd,%al
 33a:	74 0a                	je     346 <gets+0x3e>
  for(i=0; i+1 < max; ){
 33c:	89 df                	mov    %ebx,%edi
 33e:	43                   	inc    %ebx
 33f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 342:	7c d4                	jl     318 <gets+0x10>
 344:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 34d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 350:	5b                   	pop    %ebx
 351:	5e                   	pop    %esi
 352:	5f                   	pop    %edi
 353:	5d                   	pop    %ebp
 354:	c3                   	ret
 355:	8d 76 00             	lea    0x0(%esi),%esi

00000358 <stat>:

int
stat(const char *n, struct stat *st)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	56                   	push   %esi
 35c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35d:	83 ec 08             	sub    $0x8,%esp
 360:	6a 00                	push   $0x0
 362:	ff 75 08             	push   0x8(%ebp)
 365:	e8 d5 00 00 00       	call   43f <open>
  if(fd < 0)
 36a:	83 c4 10             	add    $0x10,%esp
 36d:	85 c0                	test   %eax,%eax
 36f:	78 27                	js     398 <stat+0x40>
 371:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 373:	83 ec 08             	sub    $0x8,%esp
 376:	ff 75 0c             	push   0xc(%ebp)
 379:	50                   	push   %eax
 37a:	e8 d8 00 00 00       	call   457 <fstat>
 37f:	89 c6                	mov    %eax,%esi
  close(fd);
 381:	89 1c 24             	mov    %ebx,(%esp)
 384:	e8 9e 00 00 00       	call   427 <close>
  return r;
 389:	83 c4 10             	add    $0x10,%esp
}
 38c:	89 f0                	mov    %esi,%eax
 38e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 391:	5b                   	pop    %ebx
 392:	5e                   	pop    %esi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret
 395:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 398:	be ff ff ff ff       	mov    $0xffffffff,%esi
 39d:	eb ed                	jmp    38c <stat+0x34>
 39f:	90                   	nop

000003a0 <atoi>:

int
atoi(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a7:	0f be 01             	movsbl (%ecx),%eax
 3aa:	8d 50 d0             	lea    -0x30(%eax),%edx
 3ad:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 3b0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 3b5:	77 16                	ja     3cd <atoi+0x2d>
 3b7:	90                   	nop
    n = n*10 + *s++ - '0';
 3b8:	41                   	inc    %ecx
 3b9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 3bc:	01 d2                	add    %edx,%edx
 3be:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 3c2:	0f be 01             	movsbl (%ecx),%eax
 3c5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3c8:	80 fb 09             	cmp    $0x9,%bl
 3cb:	76 eb                	jbe    3b8 <atoi+0x18>
  return n;
}
 3cd:	89 d0                	mov    %edx,%eax
 3cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3d2:	c9                   	leave
 3d3:	c3                   	ret

000003d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	57                   	push   %edi
 3d8:	56                   	push   %esi
 3d9:	8b 55 08             	mov    0x8(%ebp),%edx
 3dc:	8b 75 0c             	mov    0xc(%ebp),%esi
 3df:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e2:	85 c0                	test   %eax,%eax
 3e4:	7e 0b                	jle    3f1 <memmove+0x1d>
 3e6:	01 d0                	add    %edx,%eax
  dst = vdst;
 3e8:	89 d7                	mov    %edx,%edi
 3ea:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3ec:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3ed:	39 f8                	cmp    %edi,%eax
 3ef:	75 fb                	jne    3ec <memmove+0x18>
  return vdst;
}
 3f1:	89 d0                	mov    %edx,%eax
 3f3:	5e                   	pop    %esi
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret

000003f7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f7:	b8 01 00 00 00       	mov    $0x1,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret

000003ff <exit>:
SYSCALL(exit)
 3ff:	b8 02 00 00 00       	mov    $0x2,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret

00000407 <wait>:
SYSCALL(wait)
 407:	b8 03 00 00 00       	mov    $0x3,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret

0000040f <pipe>:
SYSCALL(pipe)
 40f:	b8 04 00 00 00       	mov    $0x4,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret

00000417 <read>:
SYSCALL(read)
 417:	b8 05 00 00 00       	mov    $0x5,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret

0000041f <write>:
SYSCALL(write)
 41f:	b8 10 00 00 00       	mov    $0x10,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret

00000427 <close>:
SYSCALL(close)
 427:	b8 15 00 00 00       	mov    $0x15,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret

0000042f <kill>:
SYSCALL(kill)
 42f:	b8 06 00 00 00       	mov    $0x6,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret

00000437 <exec>:
SYSCALL(exec)
 437:	b8 07 00 00 00       	mov    $0x7,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret

0000043f <open>:
SYSCALL(open)
 43f:	b8 0f 00 00 00       	mov    $0xf,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret

00000447 <mknod>:
SYSCALL(mknod)
 447:	b8 11 00 00 00       	mov    $0x11,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret

0000044f <unlink>:
SYSCALL(unlink)
 44f:	b8 12 00 00 00       	mov    $0x12,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret

00000457 <fstat>:
SYSCALL(fstat)
 457:	b8 08 00 00 00       	mov    $0x8,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret

0000045f <link>:
SYSCALL(link)
 45f:	b8 13 00 00 00       	mov    $0x13,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret

00000467 <mkdir>:
SYSCALL(mkdir)
 467:	b8 14 00 00 00       	mov    $0x14,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret

0000046f <chdir>:
SYSCALL(chdir)
 46f:	b8 09 00 00 00       	mov    $0x9,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret

00000477 <dup>:
SYSCALL(dup)
 477:	b8 0a 00 00 00       	mov    $0xa,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret

0000047f <getpid>:
SYSCALL(getpid)
 47f:	b8 0b 00 00 00       	mov    $0xb,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret

00000487 <sbrk>:
SYSCALL(sbrk)
 487:	b8 0c 00 00 00       	mov    $0xc,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret

0000048f <sleep>:
SYSCALL(sleep)
 48f:	b8 0d 00 00 00       	mov    $0xd,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret

00000497 <uptime>:
SYSCALL(uptime)
 497:	b8 0e 00 00 00       	mov    $0xe,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret

0000049f <signal>:
SYSCALL(signal)
 49f:	b8 16 00 00 00       	mov    $0x16,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret
 4a7:	90                   	nop

000004a8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	57                   	push   %edi
 4ac:	56                   	push   %esi
 4ad:	53                   	push   %ebx
 4ae:	83 ec 3c             	sub    $0x3c,%esp
 4b1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4b4:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4b9:	85 c9                	test   %ecx,%ecx
 4bb:	74 04                	je     4c1 <printint+0x19>
 4bd:	85 d2                	test   %edx,%edx
 4bf:	78 6b                	js     52c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 4c4:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 4cb:	31 c9                	xor    %ecx,%ecx
 4cd:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 4d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4d3:	31 d2                	xor    %edx,%edx
 4d5:	f7 f3                	div    %ebx
 4d7:	89 cf                	mov    %ecx,%edi
 4d9:	8d 49 01             	lea    0x1(%ecx),%ecx
 4dc:	8a 92 d8 08 00 00    	mov    0x8d8(%edx),%dl
 4e2:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 4e6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 4e9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4ec:	39 da                	cmp    %ebx,%edx
 4ee:	73 e0                	jae    4d0 <printint+0x28>
  if(neg)
 4f0:	8b 55 08             	mov    0x8(%ebp),%edx
 4f3:	85 d2                	test   %edx,%edx
 4f5:	74 07                	je     4fe <printint+0x56>
    buf[i++] = '-';
 4f7:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 4fc:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 4fe:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 501:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 505:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 508:	8a 07                	mov    (%edi),%al
 50a:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 50d:	50                   	push   %eax
 50e:	6a 01                	push   $0x1
 510:	56                   	push   %esi
 511:	ff 75 c0             	push   -0x40(%ebp)
 514:	e8 06 ff ff ff       	call   41f <write>
  while(--i >= 0)
 519:	89 f8                	mov    %edi,%eax
 51b:	4f                   	dec    %edi
 51c:	83 c4 10             	add    $0x10,%esp
 51f:	39 d8                	cmp    %ebx,%eax
 521:	75 e5                	jne    508 <printint+0x60>
}
 523:	8d 65 f4             	lea    -0xc(%ebp),%esp
 526:	5b                   	pop    %ebx
 527:	5e                   	pop    %esi
 528:	5f                   	pop    %edi
 529:	5d                   	pop    %ebp
 52a:	c3                   	ret
 52b:	90                   	nop
    x = -xx;
 52c:	f7 da                	neg    %edx
 52e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 531:	eb 98                	jmp    4cb <printint+0x23>
 533:	90                   	nop

00000534 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	57                   	push   %edi
 538:	56                   	push   %esi
 539:	53                   	push   %ebx
 53a:	83 ec 2c             	sub    $0x2c,%esp
 53d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 540:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 543:	8a 03                	mov    (%ebx),%al
 545:	84 c0                	test   %al,%al
 547:	74 2a                	je     573 <printf+0x3f>
 549:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 54a:	8d 4d 10             	lea    0x10(%ebp),%ecx
 54d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 550:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 553:	83 fa 25             	cmp    $0x25,%edx
 556:	74 24                	je     57c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 558:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 55b:	50                   	push   %eax
 55c:	6a 01                	push   $0x1
 55e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 561:	50                   	push   %eax
 562:	56                   	push   %esi
 563:	e8 b7 fe ff ff       	call   41f <write>
  for(i = 0; fmt[i]; i++){
 568:	43                   	inc    %ebx
 569:	8a 43 ff             	mov    -0x1(%ebx),%al
 56c:	83 c4 10             	add    $0x10,%esp
 56f:	84 c0                	test   %al,%al
 571:	75 dd                	jne    550 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 573:	8d 65 f4             	lea    -0xc(%ebp),%esp
 576:	5b                   	pop    %ebx
 577:	5e                   	pop    %esi
 578:	5f                   	pop    %edi
 579:	5d                   	pop    %ebp
 57a:	c3                   	ret
 57b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 57c:	8a 13                	mov    (%ebx),%dl
 57e:	84 d2                	test   %dl,%dl
 580:	74 f1                	je     573 <printf+0x3f>
    c = fmt[i] & 0xff;
 582:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 585:	80 fa 25             	cmp    $0x25,%dl
 588:	0f 84 fe 00 00 00    	je     68c <printf+0x158>
 58e:	83 e8 63             	sub    $0x63,%eax
 591:	83 f8 15             	cmp    $0x15,%eax
 594:	77 0a                	ja     5a0 <printf+0x6c>
 596:	ff 24 85 80 08 00 00 	jmp    *0x880(,%eax,4)
 59d:	8d 76 00             	lea    0x0(%esi),%esi
 5a0:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 5a3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 5a7:	50                   	push   %eax
 5a8:	6a 01                	push   $0x1
 5aa:	8d 7d e7             	lea    -0x19(%ebp),%edi
 5ad:	57                   	push   %edi
 5ae:	56                   	push   %esi
 5af:	e8 6b fe ff ff       	call   41f <write>
        putc(fd, c);
 5b4:	8a 55 d0             	mov    -0x30(%ebp),%dl
 5b7:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5ba:	83 c4 0c             	add    $0xc,%esp
 5bd:	6a 01                	push   $0x1
 5bf:	57                   	push   %edi
 5c0:	56                   	push   %esi
 5c1:	e8 59 fe ff ff       	call   41f <write>
  for(i = 0; fmt[i]; i++){
 5c6:	83 c3 02             	add    $0x2,%ebx
 5c9:	8a 43 ff             	mov    -0x1(%ebx),%al
 5cc:	83 c4 10             	add    $0x10,%esp
 5cf:	84 c0                	test   %al,%al
 5d1:	0f 85 79 ff ff ff    	jne    550 <printf+0x1c>
}
 5d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5da:	5b                   	pop    %ebx
 5db:	5e                   	pop    %esi
 5dc:	5f                   	pop    %edi
 5dd:	5d                   	pop    %ebp
 5de:	c3                   	ret
 5df:	90                   	nop
        printint(fd, *ap, 16, 0);
 5e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5e3:	8b 17                	mov    (%edi),%edx
 5e5:	83 ec 0c             	sub    $0xc,%esp
 5e8:	6a 00                	push   $0x0
 5ea:	b9 10 00 00 00       	mov    $0x10,%ecx
 5ef:	89 f0                	mov    %esi,%eax
 5f1:	e8 b2 fe ff ff       	call   4a8 <printint>
        ap++;
 5f6:	83 c7 04             	add    $0x4,%edi
 5f9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 5fc:	eb c8                	jmp    5c6 <printf+0x92>
 5fe:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 600:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 603:	8b 01                	mov    (%ecx),%eax
        ap++;
 605:	83 c1 04             	add    $0x4,%ecx
 608:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 60b:	85 c0                	test   %eax,%eax
 60d:	0f 84 89 00 00 00    	je     69c <printf+0x168>
        while(*s != 0){
 613:	8a 10                	mov    (%eax),%dl
 615:	84 d2                	test   %dl,%dl
 617:	74 29                	je     642 <printf+0x10e>
 619:	89 c7                	mov    %eax,%edi
 61b:	88 d0                	mov    %dl,%al
 61d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 620:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 623:	89 fb                	mov    %edi,%ebx
 625:	89 cf                	mov    %ecx,%edi
 627:	90                   	nop
          putc(fd, *s);
 628:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 62b:	50                   	push   %eax
 62c:	6a 01                	push   $0x1
 62e:	57                   	push   %edi
 62f:	56                   	push   %esi
 630:	e8 ea fd ff ff       	call   41f <write>
          s++;
 635:	43                   	inc    %ebx
        while(*s != 0){
 636:	8a 03                	mov    (%ebx),%al
 638:	83 c4 10             	add    $0x10,%esp
 63b:	84 c0                	test   %al,%al
 63d:	75 e9                	jne    628 <printf+0xf4>
 63f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 642:	83 c3 02             	add    $0x2,%ebx
 645:	8a 43 ff             	mov    -0x1(%ebx),%al
 648:	84 c0                	test   %al,%al
 64a:	0f 85 00 ff ff ff    	jne    550 <printf+0x1c>
 650:	e9 1e ff ff ff       	jmp    573 <printf+0x3f>
 655:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 658:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 65b:	8b 17                	mov    (%edi),%edx
 65d:	83 ec 0c             	sub    $0xc,%esp
 660:	6a 01                	push   $0x1
 662:	b9 0a 00 00 00       	mov    $0xa,%ecx
 667:	eb 86                	jmp    5ef <printf+0xbb>
 669:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 66c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 674:	51                   	push   %ecx
 675:	6a 01                	push   $0x1
 677:	8d 7d e7             	lea    -0x19(%ebp),%edi
 67a:	57                   	push   %edi
 67b:	56                   	push   %esi
 67c:	e8 9e fd ff ff       	call   41f <write>
        ap++;
 681:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 685:	e9 3c ff ff ff       	jmp    5c6 <printf+0x92>
 68a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 68c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 68f:	52                   	push   %edx
 690:	6a 01                	push   $0x1
 692:	8d 7d e7             	lea    -0x19(%ebp),%edi
 695:	e9 25 ff ff ff       	jmp    5bf <printf+0x8b>
 69a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 69c:	bf 79 08 00 00       	mov    $0x879,%edi
 6a1:	b0 28                	mov    $0x28,%al
 6a3:	e9 75 ff ff ff       	jmp    61d <printf+0xe9>

000006a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	57                   	push   %edi
 6ac:	56                   	push   %esi
 6ad:	53                   	push   %ebx
 6ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b4:	a1 ec 08 00 00       	mov    0x8ec,%eax
 6b9:	8d 76 00             	lea    0x0(%esi),%esi
 6bc:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6be:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c0:	39 ca                	cmp    %ecx,%edx
 6c2:	73 2c                	jae    6f0 <free+0x48>
 6c4:	39 c1                	cmp    %eax,%ecx
 6c6:	72 04                	jb     6cc <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c8:	39 c2                	cmp    %eax,%edx
 6ca:	72 f0                	jb     6bc <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6cc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6cf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6d2:	39 f8                	cmp    %edi,%eax
 6d4:	74 2c                	je     702 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6d6:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d9:	8b 42 04             	mov    0x4(%edx),%eax
 6dc:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6df:	39 f1                	cmp    %esi,%ecx
 6e1:	74 36                	je     719 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6e3:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 6e5:	89 15 ec 08 00 00    	mov    %edx,0x8ec
}
 6eb:	5b                   	pop    %ebx
 6ec:	5e                   	pop    %esi
 6ed:	5f                   	pop    %edi
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	39 c2                	cmp    %eax,%edx
 6f2:	72 c8                	jb     6bc <free+0x14>
 6f4:	39 c1                	cmp    %eax,%ecx
 6f6:	73 c4                	jae    6bc <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 f8                	cmp    %edi,%eax
 700:	75 d4                	jne    6d6 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 702:	03 70 04             	add    0x4(%eax),%esi
 705:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	8b 02                	mov    (%edx),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 70f:	8b 42 04             	mov    0x4(%edx),%eax
 712:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 715:	39 f1                	cmp    %esi,%ecx
 717:	75 ca                	jne    6e3 <free+0x3b>
    p->s.size += bp->s.size;
 719:	03 43 fc             	add    -0x4(%ebx),%eax
 71c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 71f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 722:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 724:	89 15 ec 08 00 00    	mov    %edx,0x8ec
}
 72a:	5b                   	pop    %ebx
 72b:	5e                   	pop    %esi
 72c:	5f                   	pop    %edi
 72d:	5d                   	pop    %ebp
 72e:	c3                   	ret
 72f:	90                   	nop

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	8d 78 07             	lea    0x7(%eax),%edi
 73f:	c1 ef 03             	shr    $0x3,%edi
 742:	47                   	inc    %edi
  if((prevp = freep) == 0){
 743:	8b 15 ec 08 00 00    	mov    0x8ec,%edx
 749:	85 d2                	test   %edx,%edx
 74b:	0f 84 93 00 00 00    	je     7e4 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 751:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 753:	8b 48 04             	mov    0x4(%eax),%ecx
 756:	39 f9                	cmp    %edi,%ecx
 758:	73 62                	jae    7bc <malloc+0x8c>
  if(nu < 4096)
 75a:	89 fb                	mov    %edi,%ebx
 75c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 762:	72 78                	jb     7dc <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 764:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 76b:	eb 0e                	jmp    77b <malloc+0x4b>
 76d:	8d 76 00             	lea    0x0(%esi),%esi
 770:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 774:	8b 48 04             	mov    0x4(%eax),%ecx
 777:	39 f9                	cmp    %edi,%ecx
 779:	73 41                	jae    7bc <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 77b:	39 05 ec 08 00 00    	cmp    %eax,0x8ec
 781:	75 ed                	jne    770 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	56                   	push   %esi
 787:	e8 fb fc ff ff       	call   487 <sbrk>
  if(p == (char*)-1)
 78c:	83 c4 10             	add    $0x10,%esp
 78f:	83 f8 ff             	cmp    $0xffffffff,%eax
 792:	74 1c                	je     7b0 <malloc+0x80>
  hp->s.size = nu;
 794:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 797:	83 ec 0c             	sub    $0xc,%esp
 79a:	83 c0 08             	add    $0x8,%eax
 79d:	50                   	push   %eax
 79e:	e8 05 ff ff ff       	call   6a8 <free>
  return freep;
 7a3:	8b 15 ec 08 00 00    	mov    0x8ec,%edx
      if((p = morecore(nunits)) == 0)
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	85 d2                	test   %edx,%edx
 7ae:	75 c2                	jne    772 <malloc+0x42>
        return 0;
 7b0:	31 c0                	xor    %eax,%eax
  }
}
 7b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7b5:	5b                   	pop    %ebx
 7b6:	5e                   	pop    %esi
 7b7:	5f                   	pop    %edi
 7b8:	5d                   	pop    %ebp
 7b9:	c3                   	ret
 7ba:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 7bc:	39 cf                	cmp    %ecx,%edi
 7be:	74 4c                	je     80c <malloc+0xdc>
        p->s.size -= nunits;
 7c0:	29 f9                	sub    %edi,%ecx
 7c2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7c5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7c8:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7cb:	89 15 ec 08 00 00    	mov    %edx,0x8ec
      return (void*)(p + 1);
 7d1:	83 c0 08             	add    $0x8,%eax
}
 7d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7d7:	5b                   	pop    %ebx
 7d8:	5e                   	pop    %esi
 7d9:	5f                   	pop    %edi
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret
  if(nu < 4096)
 7dc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e1:	eb 81                	jmp    764 <malloc+0x34>
 7e3:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7e4:	c7 05 ec 08 00 00 f0 	movl   $0x8f0,0x8ec
 7eb:	08 00 00 
 7ee:	c7 05 f0 08 00 00 f0 	movl   $0x8f0,0x8f0
 7f5:	08 00 00 
    base.s.size = 0;
 7f8:	c7 05 f4 08 00 00 00 	movl   $0x0,0x8f4
 7ff:	00 00 00 
 802:	b8 f0 08 00 00       	mov    $0x8f0,%eax
 807:	e9 4e ff ff ff       	jmp    75a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 80c:	8b 08                	mov    (%eax),%ecx
 80e:	89 0a                	mov    %ecx,(%edx)
 810:	eb b9                	jmp    7cb <malloc+0x9b>
