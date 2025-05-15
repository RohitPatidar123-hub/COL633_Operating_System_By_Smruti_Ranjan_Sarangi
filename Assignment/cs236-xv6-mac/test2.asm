
_test2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// void myHandler (){
//         printf(1, "I am inside the handler\n");
//         sv();
// }
int main()
 {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	90                   	nop
    // signal(myHandler); // you need to implement this syscall for registering
    while (1) {
    printf(1, "This is normal code running\n");
  10:	83 ec 08             	sub    $0x8,%esp
  13:	68 9c 07 00 00       	push   $0x79c
  18:	6a 01                	push   $0x1
  1a:	e8 9d 04 00 00       	call   4bc <printf>
  1f:	83 c4 10             	add    $0x10,%esp
  22:	bb 22 00 00 00       	mov    $0x22,%ebx
  27:	90                   	nop
            return fib(n - 1) + fib(n - 2);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	53                   	push   %ebx
  2c:	e8 0b 00 00 00       	call   3c <fib>
  31:	83 c4 10             	add    $0x10,%esp
            if (n == 1) return 1;
  34:	83 eb 02             	sub    $0x2,%ebx
  37:	75 ef                	jne    28 <main+0x28>
  39:	eb d5                	jmp    10 <main+0x10>
  3b:	90                   	nop

0000003c <fib>:
int fib(int n) {
  3c:	55                   	push   %ebp
  3d:	89 e5                	mov    %esp,%ebp
  3f:	57                   	push   %edi
  40:	56                   	push   %esi
  41:	53                   	push   %ebx
  42:	83 ec 4c             	sub    $0x4c,%esp
  45:	8b 45 08             	mov    0x8(%ebp),%eax
            if (n <= 0) return 0;
  48:	85 c0                	test   %eax,%eax
  4a:	0f 8e 76 01 00 00    	jle    1c6 <fib+0x18a>
            if (n == 1) return 1;
  50:	8d 78 ff             	lea    -0x1(%eax),%edi
  53:	31 db                	xor    %ebx,%ebx
  55:	83 ff 01             	cmp    $0x1,%edi
  58:	0f 86 5d 01 00 00    	jbe    1bb <fib+0x17f>
            return fib(n - 1) + fib(n - 2);
  5e:	89 fe                	mov    %edi,%esi
  60:	31 d2                	xor    %edx,%edx
  62:	89 5d dc             	mov    %ebx,-0x24(%ebp)
            if (n == 2) return 1;
  65:	83 fe 02             	cmp    $0x2,%esi
  68:	0f 84 3a 01 00 00    	je     1a8 <fib+0x16c>
            return fib(n - 1) + fib(n - 2);
  6e:	8d 5e ff             	lea    -0x1(%esi),%ebx
  71:	31 c0                	xor    %eax,%eax
  73:	89 75 d8             	mov    %esi,-0x28(%ebp)
  76:	89 c1                	mov    %eax,%ecx
  78:	89 7d d4             	mov    %edi,-0x2c(%ebp)
            if (n == 2) return 1;
  7b:	83 fb 02             	cmp    $0x2,%ebx
  7e:	0f 84 0e 01 00 00    	je     192 <fib+0x156>
            return fib(n - 1) + fib(n - 2);
  84:	8d 73 ff             	lea    -0x1(%ebx),%esi
  87:	31 ff                	xor    %edi,%edi
  89:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8c:	89 5d cc             	mov    %ebx,-0x34(%ebp)
            if (n == 2) return 1;
  8f:	83 fe 02             	cmp    $0x2,%esi
  92:	0f 84 e4 00 00 00    	je     17c <fib+0x140>
            return fib(n - 1) + fib(n - 2);
  98:	8d 5e ff             	lea    -0x1(%esi),%ebx
  9b:	31 d2                	xor    %edx,%edx
  9d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  a0:	89 75 c4             	mov    %esi,-0x3c(%ebp)
            if (n == 2) return 1;
  a3:	83 fb 02             	cmp    $0x2,%ebx
  a6:	0f 84 ba 00 00 00    	je     166 <fib+0x12a>
            return fib(n - 1) + fib(n - 2);
  ac:	8d 73 ff             	lea    -0x1(%ebx),%esi
  af:	31 c9                	xor    %ecx,%ecx
  b1:	89 55 c0             	mov    %edx,-0x40(%ebp)
            if (n == 2) return 1;
  b4:	83 fe 02             	cmp    $0x2,%esi
  b7:	0f 84 96 00 00 00    	je     153 <fib+0x117>
            return fib(n - 1) + fib(n - 2);
  bd:	8d 56 ff             	lea    -0x1(%esi),%edx
  c0:	31 c0                	xor    %eax,%eax
  c2:	89 7d bc             	mov    %edi,-0x44(%ebp)
  c5:	89 75 b8             	mov    %esi,-0x48(%ebp)
  c8:	89 de                	mov    %ebx,%esi
  ca:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
  cd:	89 c7                	mov    %eax,%edi
            if (n == 2) return 1;
  cf:	83 fa 02             	cmp    $0x2,%edx
  d2:	74 62                	je     136 <fib+0xfa>
            return fib(n - 1) + fib(n - 2);
  d4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  d7:	31 db                	xor    %ebx,%ebx
            if (n == 2) return 1;
  d9:	83 f9 02             	cmp    $0x2,%ecx
  dc:	74 4c                	je     12a <fib+0xee>
            return fib(n - 1) + fib(n - 2);
  de:	8d 41 ff             	lea    -0x1(%ecx),%eax
  e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if (n == 2) return 1;
  eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ee:	83 f8 02             	cmp    $0x2,%eax
  f1:	74 28                	je     11b <fib+0xdf>
  f3:	89 55 ac             	mov    %edx,-0x54(%ebp)
  f6:	89 4d b0             	mov    %ecx,-0x50(%ebp)
            return fib(n - 1) + fib(n - 2);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	48                   	dec    %eax
  fd:	50                   	push   %eax
  fe:	e8 39 ff ff ff       	call   3c <fib>
 103:	83 c4 10             	add    $0x10,%esp
 106:	83 6d e4 02          	subl   $0x2,-0x1c(%ebp)
 10a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 10d:	01 45 e0             	add    %eax,-0x20(%ebp)
            if (n == 1) return 1;
 110:	89 c8                	mov    %ecx,%eax
 112:	48                   	dec    %eax
 113:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 116:	8b 55 ac             	mov    -0x54(%ebp),%edx
 119:	75 d0                	jne    eb <fib+0xaf>
            return fib(n - 1) + fib(n - 2);
 11b:	83 e9 02             	sub    $0x2,%ecx
 11e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 121:	8d 5c 03 01          	lea    0x1(%ebx,%eax,1),%ebx
            if (n == 1) return 1;
 125:	83 f9 01             	cmp    $0x1,%ecx
 128:	75 af                	jne    d9 <fib+0x9d>
            return fib(n - 1) + fib(n - 2);
 12a:	83 ea 02             	sub    $0x2,%edx
 12d:	8d 7c 1f 01          	lea    0x1(%edi,%ebx,1),%edi
            if (n == 1) return 1;
 131:	83 fa 01             	cmp    $0x1,%edx
 134:	75 99                	jne    cf <fib+0x93>
            return fib(n - 1) + fib(n - 2);
 136:	89 f3                	mov    %esi,%ebx
 138:	8b 75 b8             	mov    -0x48(%ebp),%esi
 13b:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 13e:	89 f8                	mov    %edi,%eax
 140:	8b 7d bc             	mov    -0x44(%ebp),%edi
 143:	83 ee 02             	sub    $0x2,%esi
 146:	8d 4c 01 01          	lea    0x1(%ecx,%eax,1),%ecx
            if (n == 1) return 1;
 14a:	83 fe 01             	cmp    $0x1,%esi
 14d:	0f 85 61 ff ff ff    	jne    b4 <fib+0x78>
            return fib(n - 1) + fib(n - 2);
 153:	8b 55 c0             	mov    -0x40(%ebp),%edx
 156:	83 eb 02             	sub    $0x2,%ebx
 159:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
            if (n == 1) return 1;
 15d:	83 fb 01             	cmp    $0x1,%ebx
 160:	0f 85 3d ff ff ff    	jne    a3 <fib+0x67>
            return fib(n - 1) + fib(n - 2);
 166:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 169:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 16c:	83 ee 02             	sub    $0x2,%esi
 16f:	8d 7c 17 01          	lea    0x1(%edi,%edx,1),%edi
            if (n == 1) return 1;
 173:	83 fe 01             	cmp    $0x1,%esi
 176:	0f 85 13 ff ff ff    	jne    8f <fib+0x53>
            return fib(n - 1) + fib(n - 2);
 17c:	8b 55 d0             	mov    -0x30(%ebp),%edx
 17f:	8b 5d cc             	mov    -0x34(%ebp),%ebx
 182:	83 eb 02             	sub    $0x2,%ebx
 185:	8d 4c 39 01          	lea    0x1(%ecx,%edi,1),%ecx
            if (n == 1) return 1;
 189:	83 fb 01             	cmp    $0x1,%ebx
 18c:	0f 85 e9 fe ff ff    	jne    7b <fib+0x3f>
            return fib(n - 1) + fib(n - 2);
 192:	8b 75 d8             	mov    -0x28(%ebp),%esi
 195:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 198:	83 ee 02             	sub    $0x2,%esi
 19b:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
            if (n == 1) return 1;
 19f:	83 fe 01             	cmp    $0x1,%esi
 1a2:	0f 85 bd fe ff ff    	jne    65 <fib+0x29>
 1a8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 1ab:	8d 5c 13 01          	lea    0x1(%ebx,%edx,1),%ebx
 1af:	83 ef 02             	sub    $0x2,%edi
 1b2:	83 ff 01             	cmp    $0x1,%edi
 1b5:	0f 87 a3 fe ff ff    	ja     5e <fib+0x22>
 1bb:	8d 43 01             	lea    0x1(%ebx),%eax
}
 1be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5f                   	pop    %edi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret
            if (n <= 0) return 0;
 1c6:	31 c0                	xor    %eax,%eax
 1c8:	eb f4                	jmp    1be <fib+0x182>
 1ca:	66 90                	xchg   %ax,%ax

000001cc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	53                   	push   %ebx
 1d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d6:	31 c0                	xor    %eax,%eax
 1d8:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 1db:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1de:	40                   	inc    %eax
 1df:	84 d2                	test   %dl,%dl
 1e1:	75 f5                	jne    1d8 <strcpy+0xc>
    ;
  return os;
}
 1e3:	89 c8                	mov    %ecx,%eax
 1e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e8:	c9                   	leave
 1e9:	c3                   	ret
 1ea:	66 90                	xchg   %ax,%ax

000001ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	53                   	push   %ebx
 1f0:	8b 55 08             	mov    0x8(%ebp),%edx
 1f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 1f6:	0f b6 02             	movzbl (%edx),%eax
 1f9:	84 c0                	test   %al,%al
 1fb:	75 10                	jne    20d <strcmp+0x21>
 1fd:	eb 2a                	jmp    229 <strcmp+0x3d>
 1ff:	90                   	nop
    p++, q++;
 200:	42                   	inc    %edx
 201:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 204:	0f b6 02             	movzbl (%edx),%eax
 207:	84 c0                	test   %al,%al
 209:	74 11                	je     21c <strcmp+0x30>
 20b:	89 cb                	mov    %ecx,%ebx
 20d:	0f b6 0b             	movzbl (%ebx),%ecx
 210:	38 c1                	cmp    %al,%cl
 212:	74 ec                	je     200 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 214:	29 c8                	sub    %ecx,%eax
}
 216:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 219:	c9                   	leave
 21a:	c3                   	ret
 21b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 21c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 220:	31 c0                	xor    %eax,%eax
 222:	29 c8                	sub    %ecx,%eax
}
 224:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 227:	c9                   	leave
 228:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 229:	0f b6 0b             	movzbl (%ebx),%ecx
 22c:	31 c0                	xor    %eax,%eax
 22e:	eb e4                	jmp    214 <strcmp+0x28>

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 236:	80 3a 00             	cmpb   $0x0,(%edx)
 239:	74 15                	je     250 <strlen+0x20>
 23b:	31 c0                	xor    %eax,%eax
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	40                   	inc    %eax
 241:	89 c1                	mov    %eax,%ecx
 243:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 247:	75 f7                	jne    240 <strlen+0x10>
    ;
  return n;
}
 249:	89 c8                	mov    %ecx,%eax
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret
 24d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 250:	31 c9                	xor    %ecx,%ecx
}
 252:	89 c8                	mov    %ecx,%eax
 254:	5d                   	pop    %ebp
 255:	c3                   	ret
 256:	66 90                	xchg   %ax,%ax

00000258 <memset>:

void*
memset(void *dst, int c, uint n)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 25c:	8b 7d 08             	mov    0x8(%ebp),%edi
 25f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 262:	8b 45 0c             	mov    0xc(%ebp),%eax
 265:	fc                   	cld
 266:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 26e:	c9                   	leave
 26f:	c3                   	ret

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 279:	8a 10                	mov    (%eax),%dl
 27b:	84 d2                	test   %dl,%dl
 27d:	75 0c                	jne    28b <strchr+0x1b>
 27f:	eb 13                	jmp    294 <strchr+0x24>
 281:	8d 76 00             	lea    0x0(%esi),%esi
 284:	40                   	inc    %eax
 285:	8a 10                	mov    (%eax),%dl
 287:	84 d2                	test   %dl,%dl
 289:	74 09                	je     294 <strchr+0x24>
    if(*s == c)
 28b:	38 d1                	cmp    %dl,%cl
 28d:	75 f5                	jne    284 <strchr+0x14>
      return (char*)s;
  return 0;
}
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret
 291:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 294:	31 c0                	xor    %eax,%eax
}
 296:	5d                   	pop    %ebp
 297:	c3                   	ret

00000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	57                   	push   %edi
 29c:	56                   	push   %esi
 29d:	53                   	push   %ebx
 29e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a1:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 2a3:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 2a6:	eb 24                	jmp    2cc <gets+0x34>
    cc = read(0, &c, 1);
 2a8:	50                   	push   %eax
 2a9:	6a 01                	push   $0x1
 2ab:	56                   	push   %esi
 2ac:	6a 00                	push   $0x0
 2ae:	e8 f4 00 00 00       	call   3a7 <read>
    if(cc < 1)
 2b3:	83 c4 10             	add    $0x10,%esp
 2b6:	85 c0                	test   %eax,%eax
 2b8:	7e 1a                	jle    2d4 <gets+0x3c>
      break;
    buf[i++] = c;
 2ba:	8a 45 e7             	mov    -0x19(%ebp),%al
 2bd:	8b 55 08             	mov    0x8(%ebp),%edx
 2c0:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2c4:	3c 0a                	cmp    $0xa,%al
 2c6:	74 0e                	je     2d6 <gets+0x3e>
 2c8:	3c 0d                	cmp    $0xd,%al
 2ca:	74 0a                	je     2d6 <gets+0x3e>
  for(i=0; i+1 < max; ){
 2cc:	89 df                	mov    %ebx,%edi
 2ce:	43                   	inc    %ebx
 2cf:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2d2:	7c d4                	jl     2a8 <gets+0x10>
 2d4:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 2dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e0:	5b                   	pop    %ebx
 2e1:	5e                   	pop    %esi
 2e2:	5f                   	pop    %edi
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret
 2e5:	8d 76 00             	lea    0x0(%esi),%esi

000002e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	56                   	push   %esi
 2ec:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ed:	83 ec 08             	sub    $0x8,%esp
 2f0:	6a 00                	push   $0x0
 2f2:	ff 75 08             	push   0x8(%ebp)
 2f5:	e8 d5 00 00 00       	call   3cf <open>
  if(fd < 0)
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	85 c0                	test   %eax,%eax
 2ff:	78 27                	js     328 <stat+0x40>
 301:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 303:	83 ec 08             	sub    $0x8,%esp
 306:	ff 75 0c             	push   0xc(%ebp)
 309:	50                   	push   %eax
 30a:	e8 d8 00 00 00       	call   3e7 <fstat>
 30f:	89 c6                	mov    %eax,%esi
  close(fd);
 311:	89 1c 24             	mov    %ebx,(%esp)
 314:	e8 9e 00 00 00       	call   3b7 <close>
  return r;
 319:	83 c4 10             	add    $0x10,%esp
}
 31c:	89 f0                	mov    %esi,%eax
 31e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 321:	5b                   	pop    %ebx
 322:	5e                   	pop    %esi
 323:	5d                   	pop    %ebp
 324:	c3                   	ret
 325:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 328:	be ff ff ff ff       	mov    $0xffffffff,%esi
 32d:	eb ed                	jmp    31c <stat+0x34>
 32f:	90                   	nop

00000330 <atoi>:

int
atoi(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 337:	0f be 01             	movsbl (%ecx),%eax
 33a:	8d 50 d0             	lea    -0x30(%eax),%edx
 33d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 340:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 345:	77 16                	ja     35d <atoi+0x2d>
 347:	90                   	nop
    n = n*10 + *s++ - '0';
 348:	41                   	inc    %ecx
 349:	8d 14 92             	lea    (%edx,%edx,4),%edx
 34c:	01 d2                	add    %edx,%edx
 34e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 352:	0f be 01             	movsbl (%ecx),%eax
 355:	8d 58 d0             	lea    -0x30(%eax),%ebx
 358:	80 fb 09             	cmp    $0x9,%bl
 35b:	76 eb                	jbe    348 <atoi+0x18>
  return n;
}
 35d:	89 d0                	mov    %edx,%eax
 35f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 362:	c9                   	leave
 363:	c3                   	ret

00000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	8b 55 08             	mov    0x8(%ebp),%edx
 36c:	8b 75 0c             	mov    0xc(%ebp),%esi
 36f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 372:	85 c0                	test   %eax,%eax
 374:	7e 0b                	jle    381 <memmove+0x1d>
 376:	01 d0                	add    %edx,%eax
  dst = vdst;
 378:	89 d7                	mov    %edx,%edi
 37a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 37c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 37d:	39 f8                	cmp    %edi,%eax
 37f:	75 fb                	jne    37c <memmove+0x18>
  return vdst;
}
 381:	89 d0                	mov    %edx,%eax
 383:	5e                   	pop    %esi
 384:	5f                   	pop    %edi
 385:	5d                   	pop    %ebp
 386:	c3                   	ret

00000387 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 387:	b8 01 00 00 00       	mov    $0x1,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret

0000038f <exit>:
SYSCALL(exit)
 38f:	b8 02 00 00 00       	mov    $0x2,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret

00000397 <wait>:
SYSCALL(wait)
 397:	b8 03 00 00 00       	mov    $0x3,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret

0000039f <pipe>:
SYSCALL(pipe)
 39f:	b8 04 00 00 00       	mov    $0x4,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret

000003a7 <read>:
SYSCALL(read)
 3a7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret

000003af <write>:
SYSCALL(write)
 3af:	b8 10 00 00 00       	mov    $0x10,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret

000003b7 <close>:
SYSCALL(close)
 3b7:	b8 15 00 00 00       	mov    $0x15,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret

000003bf <kill>:
SYSCALL(kill)
 3bf:	b8 06 00 00 00       	mov    $0x6,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret

000003c7 <exec>:
SYSCALL(exec)
 3c7:	b8 07 00 00 00       	mov    $0x7,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret

000003cf <open>:
SYSCALL(open)
 3cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret

000003d7 <mknod>:
SYSCALL(mknod)
 3d7:	b8 11 00 00 00       	mov    $0x11,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret

000003df <unlink>:
SYSCALL(unlink)
 3df:	b8 12 00 00 00       	mov    $0x12,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret

000003e7 <fstat>:
SYSCALL(fstat)
 3e7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret

000003ef <link>:
SYSCALL(link)
 3ef:	b8 13 00 00 00       	mov    $0x13,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret

000003f7 <mkdir>:
SYSCALL(mkdir)
 3f7:	b8 14 00 00 00       	mov    $0x14,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret

000003ff <chdir>:
SYSCALL(chdir)
 3ff:	b8 09 00 00 00       	mov    $0x9,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret

00000407 <dup>:
SYSCALL(dup)
 407:	b8 0a 00 00 00       	mov    $0xa,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret

0000040f <getpid>:
SYSCALL(getpid)
 40f:	b8 0b 00 00 00       	mov    $0xb,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret

00000417 <sbrk>:
SYSCALL(sbrk)
 417:	b8 0c 00 00 00       	mov    $0xc,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret

0000041f <sleep>:
SYSCALL(sleep)
 41f:	b8 0d 00 00 00       	mov    $0xd,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret

00000427 <uptime>:
SYSCALL(uptime)
 427:	b8 0e 00 00 00       	mov    $0xe,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 3c             	sub    $0x3c,%esp
 439:	89 45 c0             	mov    %eax,-0x40(%ebp)
 43c:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 441:	85 c9                	test   %ecx,%ecx
 443:	74 04                	je     449 <printint+0x19>
 445:	85 d2                	test   %edx,%edx
 447:	78 6b                	js     4b4 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 449:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 44c:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 453:	31 c9                	xor    %ecx,%ecx
 455:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 458:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 45b:	31 d2                	xor    %edx,%edx
 45d:	f7 f3                	div    %ebx
 45f:	89 cf                	mov    %ecx,%edi
 461:	8d 49 01             	lea    0x1(%ecx),%ecx
 464:	8a 92 18 08 00 00    	mov    0x818(%edx),%dl
 46a:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 46e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 471:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 474:	39 da                	cmp    %ebx,%edx
 476:	73 e0                	jae    458 <printint+0x28>
  if(neg)
 478:	8b 55 08             	mov    0x8(%ebp),%edx
 47b:	85 d2                	test   %edx,%edx
 47d:	74 07                	je     486 <printint+0x56>
    buf[i++] = '-';
 47f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 484:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 486:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 489:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 490:	8a 07                	mov    (%edi),%al
 492:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 495:	50                   	push   %eax
 496:	6a 01                	push   $0x1
 498:	56                   	push   %esi
 499:	ff 75 c0             	push   -0x40(%ebp)
 49c:	e8 0e ff ff ff       	call   3af <write>
  while(--i >= 0)
 4a1:	89 f8                	mov    %edi,%eax
 4a3:	4f                   	dec    %edi
 4a4:	83 c4 10             	add    $0x10,%esp
 4a7:	39 d8                	cmp    %ebx,%eax
 4a9:	75 e5                	jne    490 <printint+0x60>
}
 4ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ae:	5b                   	pop    %ebx
 4af:	5e                   	pop    %esi
 4b0:	5f                   	pop    %edi
 4b1:	5d                   	pop    %ebp
 4b2:	c3                   	ret
 4b3:	90                   	nop
    x = -xx;
 4b4:	f7 da                	neg    %edx
 4b6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 4b9:	eb 98                	jmp    453 <printint+0x23>
 4bb:	90                   	nop

000004bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	57                   	push   %edi
 4c0:	56                   	push   %esi
 4c1:	53                   	push   %ebx
 4c2:	83 ec 2c             	sub    $0x2c,%esp
 4c5:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4cb:	8a 03                	mov    (%ebx),%al
 4cd:	84 c0                	test   %al,%al
 4cf:	74 2a                	je     4fb <printf+0x3f>
 4d1:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 4d2:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4d5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 4d8:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 4db:	83 fa 25             	cmp    $0x25,%edx
 4de:	74 24                	je     504 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 4e0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4e3:	50                   	push   %eax
 4e4:	6a 01                	push   $0x1
 4e6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e9:	50                   	push   %eax
 4ea:	56                   	push   %esi
 4eb:	e8 bf fe ff ff       	call   3af <write>
  for(i = 0; fmt[i]; i++){
 4f0:	43                   	inc    %ebx
 4f1:	8a 43 ff             	mov    -0x1(%ebx),%al
 4f4:	83 c4 10             	add    $0x10,%esp
 4f7:	84 c0                	test   %al,%al
 4f9:	75 dd                	jne    4d8 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fe:	5b                   	pop    %ebx
 4ff:	5e                   	pop    %esi
 500:	5f                   	pop    %edi
 501:	5d                   	pop    %ebp
 502:	c3                   	ret
 503:	90                   	nop
  for(i = 0; fmt[i]; i++){
 504:	8a 13                	mov    (%ebx),%dl
 506:	84 d2                	test   %dl,%dl
 508:	74 f1                	je     4fb <printf+0x3f>
    c = fmt[i] & 0xff;
 50a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 50d:	80 fa 25             	cmp    $0x25,%dl
 510:	0f 84 fe 00 00 00    	je     614 <printf+0x158>
 516:	83 e8 63             	sub    $0x63,%eax
 519:	83 f8 15             	cmp    $0x15,%eax
 51c:	77 0a                	ja     528 <printf+0x6c>
 51e:	ff 24 85 c0 07 00 00 	jmp    *0x7c0(,%eax,4)
 525:	8d 76 00             	lea    0x0(%esi),%esi
 528:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 52b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 52f:	50                   	push   %eax
 530:	6a 01                	push   $0x1
 532:	8d 7d e7             	lea    -0x19(%ebp),%edi
 535:	57                   	push   %edi
 536:	56                   	push   %esi
 537:	e8 73 fe ff ff       	call   3af <write>
        putc(fd, c);
 53c:	8a 55 d0             	mov    -0x30(%ebp),%dl
 53f:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 542:	83 c4 0c             	add    $0xc,%esp
 545:	6a 01                	push   $0x1
 547:	57                   	push   %edi
 548:	56                   	push   %esi
 549:	e8 61 fe ff ff       	call   3af <write>
  for(i = 0; fmt[i]; i++){
 54e:	83 c3 02             	add    $0x2,%ebx
 551:	8a 43 ff             	mov    -0x1(%ebx),%al
 554:	83 c4 10             	add    $0x10,%esp
 557:	84 c0                	test   %al,%al
 559:	0f 85 79 ff ff ff    	jne    4d8 <printf+0x1c>
}
 55f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 562:	5b                   	pop    %ebx
 563:	5e                   	pop    %esi
 564:	5f                   	pop    %edi
 565:	5d                   	pop    %ebp
 566:	c3                   	ret
 567:	90                   	nop
        printint(fd, *ap, 16, 0);
 568:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 56b:	8b 17                	mov    (%edi),%edx
 56d:	83 ec 0c             	sub    $0xc,%esp
 570:	6a 00                	push   $0x0
 572:	b9 10 00 00 00       	mov    $0x10,%ecx
 577:	89 f0                	mov    %esi,%eax
 579:	e8 b2 fe ff ff       	call   430 <printint>
        ap++;
 57e:	83 c7 04             	add    $0x4,%edi
 581:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 584:	eb c8                	jmp    54e <printf+0x92>
 586:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 588:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 58b:	8b 01                	mov    (%ecx),%eax
        ap++;
 58d:	83 c1 04             	add    $0x4,%ecx
 590:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 593:	85 c0                	test   %eax,%eax
 595:	0f 84 89 00 00 00    	je     624 <printf+0x168>
        while(*s != 0){
 59b:	8a 10                	mov    (%eax),%dl
 59d:	84 d2                	test   %dl,%dl
 59f:	74 29                	je     5ca <printf+0x10e>
 5a1:	89 c7                	mov    %eax,%edi
 5a3:	88 d0                	mov    %dl,%al
 5a5:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 5a8:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ab:	89 fb                	mov    %edi,%ebx
 5ad:	89 cf                	mov    %ecx,%edi
 5af:	90                   	nop
          putc(fd, *s);
 5b0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b3:	50                   	push   %eax
 5b4:	6a 01                	push   $0x1
 5b6:	57                   	push   %edi
 5b7:	56                   	push   %esi
 5b8:	e8 f2 fd ff ff       	call   3af <write>
          s++;
 5bd:	43                   	inc    %ebx
        while(*s != 0){
 5be:	8a 03                	mov    (%ebx),%al
 5c0:	83 c4 10             	add    $0x10,%esp
 5c3:	84 c0                	test   %al,%al
 5c5:	75 e9                	jne    5b0 <printf+0xf4>
 5c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 5ca:	83 c3 02             	add    $0x2,%ebx
 5cd:	8a 43 ff             	mov    -0x1(%ebx),%al
 5d0:	84 c0                	test   %al,%al
 5d2:	0f 85 00 ff ff ff    	jne    4d8 <printf+0x1c>
 5d8:	e9 1e ff ff ff       	jmp    4fb <printf+0x3f>
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5e3:	8b 17                	mov    (%edi),%edx
 5e5:	83 ec 0c             	sub    $0xc,%esp
 5e8:	6a 01                	push   $0x1
 5ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5ef:	eb 86                	jmp    577 <printf+0xbb>
 5f1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 5f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5fc:	51                   	push   %ecx
 5fd:	6a 01                	push   $0x1
 5ff:	8d 7d e7             	lea    -0x19(%ebp),%edi
 602:	57                   	push   %edi
 603:	56                   	push   %esi
 604:	e8 a6 fd ff ff       	call   3af <write>
        ap++;
 609:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 60d:	e9 3c ff ff ff       	jmp    54e <printf+0x92>
 612:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 614:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 617:	52                   	push   %edx
 618:	6a 01                	push   $0x1
 61a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 61d:	e9 25 ff ff ff       	jmp    547 <printf+0x8b>
 622:	66 90                	xchg   %ax,%ax
          s = "(null)";
 624:	bf b9 07 00 00       	mov    $0x7b9,%edi
 629:	b0 28                	mov    $0x28,%al
 62b:	e9 75 ff ff ff       	jmp    5a5 <printf+0xe9>

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 639:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	a1 2c 08 00 00       	mov    0x82c,%eax
 641:	8d 76 00             	lea    0x0(%esi),%esi
 644:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 646:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	39 ca                	cmp    %ecx,%edx
 64a:	73 2c                	jae    678 <free+0x48>
 64c:	39 c1                	cmp    %eax,%ecx
 64e:	72 04                	jb     654 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 c2                	cmp    %eax,%edx
 652:	72 f0                	jb     644 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 654:	8b 73 fc             	mov    -0x4(%ebx),%esi
 657:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65a:	39 f8                	cmp    %edi,%eax
 65c:	74 2c                	je     68a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 65e:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 661:	8b 42 04             	mov    0x4(%edx),%eax
 664:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 667:	39 f1                	cmp    %esi,%ecx
 669:	74 36                	je     6a1 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 66b:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 66d:	89 15 2c 08 00 00    	mov    %edx,0x82c
}
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	39 c2                	cmp    %eax,%edx
 67a:	72 c8                	jb     644 <free+0x14>
 67c:	39 c1                	cmp    %eax,%ecx
 67e:	73 c4                	jae    644 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 680:	8b 73 fc             	mov    -0x4(%ebx),%esi
 683:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 686:	39 f8                	cmp    %edi,%eax
 688:	75 d4                	jne    65e <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 68a:	03 70 04             	add    0x4(%eax),%esi
 68d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	8b 02                	mov    (%edx),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 697:	8b 42 04             	mov    0x4(%edx),%eax
 69a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 69d:	39 f1                	cmp    %esi,%ecx
 69f:	75 ca                	jne    66b <free+0x3b>
    p->s.size += bp->s.size;
 6a1:	03 43 fc             	add    -0x4(%ebx),%eax
 6a4:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6a7:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6aa:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 6ac:	89 15 2c 08 00 00    	mov    %edx,0x82c
}
 6b2:	5b                   	pop    %ebx
 6b3:	5e                   	pop    %esi
 6b4:	5f                   	pop    %edi
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret
 6b7:	90                   	nop

000006b8 <malloc>:
}


void*
malloc(uint nbytes)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	57                   	push   %edi
 6bc:	56                   	push   %esi
 6bd:	53                   	push   %ebx
 6be:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c1:	8b 45 08             	mov    0x8(%ebp),%eax
 6c4:	8d 78 07             	lea    0x7(%eax),%edi
 6c7:	c1 ef 03             	shr    $0x3,%edi
 6ca:	47                   	inc    %edi
  if((prevp = freep) == 0){
 6cb:	8b 15 2c 08 00 00    	mov    0x82c,%edx
 6d1:	85 d2                	test   %edx,%edx
 6d3:	0f 84 93 00 00 00    	je     76c <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6db:	8b 48 04             	mov    0x4(%eax),%ecx
 6de:	39 f9                	cmp    %edi,%ecx
 6e0:	73 62                	jae    744 <malloc+0x8c>
  if(nu < 4096)
 6e2:	89 fb                	mov    %edi,%ebx
 6e4:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6ea:	72 78                	jb     764 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 6ec:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6f3:	eb 0e                	jmp    703 <malloc+0x4b>
 6f5:	8d 76 00             	lea    0x0(%esi),%esi
 6f8:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fa:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6fc:	8b 48 04             	mov    0x4(%eax),%ecx
 6ff:	39 f9                	cmp    %edi,%ecx
 701:	73 41                	jae    744 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 703:	39 05 2c 08 00 00    	cmp    %eax,0x82c
 709:	75 ed                	jne    6f8 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	56                   	push   %esi
 70f:	e8 03 fd ff ff       	call   417 <sbrk>
  if(p == (char*)-1)
 714:	83 c4 10             	add    $0x10,%esp
 717:	83 f8 ff             	cmp    $0xffffffff,%eax
 71a:	74 1c                	je     738 <malloc+0x80>
  hp->s.size = nu;
 71c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 71f:	83 ec 0c             	sub    $0xc,%esp
 722:	83 c0 08             	add    $0x8,%eax
 725:	50                   	push   %eax
 726:	e8 05 ff ff ff       	call   630 <free>
  return freep;
 72b:	8b 15 2c 08 00 00    	mov    0x82c,%edx
      if((p = morecore(nunits)) == 0)
 731:	83 c4 10             	add    $0x10,%esp
 734:	85 d2                	test   %edx,%edx
 736:	75 c2                	jne    6fa <malloc+0x42>
        return 0;
 738:	31 c0                	xor    %eax,%eax
  }
}
 73a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73d:	5b                   	pop    %ebx
 73e:	5e                   	pop    %esi
 73f:	5f                   	pop    %edi
 740:	5d                   	pop    %ebp
 741:	c3                   	ret
 742:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 744:	39 cf                	cmp    %ecx,%edi
 746:	74 4c                	je     794 <malloc+0xdc>
        p->s.size -= nunits;
 748:	29 f9                	sub    %edi,%ecx
 74a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 74d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 750:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 753:	89 15 2c 08 00 00    	mov    %edx,0x82c
      return (void*)(p + 1);
 759:	83 c0 08             	add    $0x8,%eax
}
 75c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75f:	5b                   	pop    %ebx
 760:	5e                   	pop    %esi
 761:	5f                   	pop    %edi
 762:	5d                   	pop    %ebp
 763:	c3                   	ret
  if(nu < 4096)
 764:	bb 00 10 00 00       	mov    $0x1000,%ebx
 769:	eb 81                	jmp    6ec <malloc+0x34>
 76b:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 76c:	c7 05 2c 08 00 00 30 	movl   $0x830,0x82c
 773:	08 00 00 
 776:	c7 05 30 08 00 00 30 	movl   $0x830,0x830
 77d:	08 00 00 
    base.s.size = 0;
 780:	c7 05 34 08 00 00 00 	movl   $0x0,0x834
 787:	00 00 00 
 78a:	b8 30 08 00 00       	mov    $0x830,%eax
 78f:	e9 4e ff ff ff       	jmp    6e2 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 794:	8b 08                	mov    (%eax),%ecx
 796:	89 0a                	mov    %ecx,(%edx)
 798:	eb b9                	jmp    753 <malloc+0x9b>
