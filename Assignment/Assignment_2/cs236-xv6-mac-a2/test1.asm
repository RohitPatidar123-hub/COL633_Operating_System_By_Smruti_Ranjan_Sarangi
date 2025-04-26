
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void myHandler (){
        printf(1, "I am inside the handler\n");
        sv();
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
    signal(myHandler); // you need to implement this syscall for registering
   f:	83 ec 0c             	sub    $0xc,%esp
  12:	68 4c 00 00 00       	push   $0x4c
  17:	e8 63 04 00 00       	call   47f <signal>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	90                   	nop
    while (1) {
    printf(1, "This is normal code running\n");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 2a 08 00 00       	push   $0x82a
  28:	6a 01                	push   $0x1
  2a:	e8 f5 04 00 00       	call   524 <printf>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	bb 22 00 00 00       	mov    $0x22,%ebx
  37:	90                   	nop
            return fib(n - 1) + fib(n - 2);
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	53                   	push   %ebx
  3c:	e8 33 00 00 00       	call   74 <fib>
  41:	83 c4 10             	add    $0x10,%esp
            if (n == 1) return 1;
  44:	83 eb 02             	sub    $0x2,%ebx
  47:	75 ef                	jne    38 <main+0x38>
  49:	eb d5                	jmp    20 <main+0x20>
  4b:	90                   	nop

0000004c <myHandler>:
void myHandler (){
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	83 ec 10             	sub    $0x10,%esp
        printf(1, "I am inside the handler\n");
  52:	68 04 08 00 00       	push   $0x804
  57:	6a 01                	push   $0x1
  59:	e8 c6 04 00 00       	call   524 <printf>
        printf(1, "I am Shivam\n");
  5e:	58                   	pop    %eax
  5f:	5a                   	pop    %edx
  60:	68 1d 08 00 00       	push   $0x81d
  65:	6a 01                	push   $0x1
  67:	e8 b8 04 00 00       	call   524 <printf>
}
  6c:	83 c4 10             	add    $0x10,%esp
  6f:	c9                   	leave
  70:	c3                   	ret
  71:	8d 76 00             	lea    0x0(%esi),%esi

00000074 <fib>:
int fib(int n) {
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	56                   	push   %esi
  79:	53                   	push   %ebx
  7a:	83 ec 4c             	sub    $0x4c,%esp
  7d:	8b 45 08             	mov    0x8(%ebp),%eax
            if (n <= 0) return 0;
  80:	85 c0                	test   %eax,%eax
  82:	0f 8e 76 01 00 00    	jle    1fe <fib+0x18a>
            if (n == 1) return 1;
  88:	8d 78 ff             	lea    -0x1(%eax),%edi
  8b:	31 db                	xor    %ebx,%ebx
  8d:	83 ff 01             	cmp    $0x1,%edi
  90:	0f 86 5d 01 00 00    	jbe    1f3 <fib+0x17f>
            return fib(n - 1) + fib(n - 2);
  96:	89 fe                	mov    %edi,%esi
  98:	31 d2                	xor    %edx,%edx
  9a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
            if (n == 2) return 1;
  9d:	83 fe 02             	cmp    $0x2,%esi
  a0:	0f 84 3a 01 00 00    	je     1e0 <fib+0x16c>
            return fib(n - 1) + fib(n - 2);
  a6:	8d 5e ff             	lea    -0x1(%esi),%ebx
  a9:	31 c0                	xor    %eax,%eax
  ab:	89 75 d8             	mov    %esi,-0x28(%ebp)
  ae:	89 c1                	mov    %eax,%ecx
  b0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
            if (n == 2) return 1;
  b3:	83 fb 02             	cmp    $0x2,%ebx
  b6:	0f 84 0e 01 00 00    	je     1ca <fib+0x156>
            return fib(n - 1) + fib(n - 2);
  bc:	8d 73 ff             	lea    -0x1(%ebx),%esi
  bf:	31 ff                	xor    %edi,%edi
  c1:	89 55 d0             	mov    %edx,-0x30(%ebp)
  c4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
            if (n == 2) return 1;
  c7:	83 fe 02             	cmp    $0x2,%esi
  ca:	0f 84 e4 00 00 00    	je     1b4 <fib+0x140>
            return fib(n - 1) + fib(n - 2);
  d0:	8d 5e ff             	lea    -0x1(%esi),%ebx
  d3:	31 d2                	xor    %edx,%edx
  d5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  d8:	89 75 c4             	mov    %esi,-0x3c(%ebp)
            if (n == 2) return 1;
  db:	83 fb 02             	cmp    $0x2,%ebx
  de:	0f 84 ba 00 00 00    	je     19e <fib+0x12a>
            return fib(n - 1) + fib(n - 2);
  e4:	8d 73 ff             	lea    -0x1(%ebx),%esi
  e7:	31 c9                	xor    %ecx,%ecx
  e9:	89 55 c0             	mov    %edx,-0x40(%ebp)
            if (n == 2) return 1;
  ec:	83 fe 02             	cmp    $0x2,%esi
  ef:	0f 84 96 00 00 00    	je     18b <fib+0x117>
            return fib(n - 1) + fib(n - 2);
  f5:	8d 56 ff             	lea    -0x1(%esi),%edx
  f8:	31 c0                	xor    %eax,%eax
  fa:	89 7d bc             	mov    %edi,-0x44(%ebp)
  fd:	89 75 b8             	mov    %esi,-0x48(%ebp)
 100:	89 de                	mov    %ebx,%esi
 102:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
 105:	89 c7                	mov    %eax,%edi
            if (n == 2) return 1;
 107:	83 fa 02             	cmp    $0x2,%edx
 10a:	74 62                	je     16e <fib+0xfa>
            return fib(n - 1) + fib(n - 2);
 10c:	8d 4a ff             	lea    -0x1(%edx),%ecx
 10f:	31 db                	xor    %ebx,%ebx
            if (n == 2) return 1;
 111:	83 f9 02             	cmp    $0x2,%ecx
 114:	74 4c                	je     162 <fib+0xee>
            return fib(n - 1) + fib(n - 2);
 116:	8d 41 ff             	lea    -0x1(%ecx),%eax
 119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 11c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if (n == 2) return 1;
 123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 126:	83 f8 02             	cmp    $0x2,%eax
 129:	74 28                	je     153 <fib+0xdf>
 12b:	89 55 ac             	mov    %edx,-0x54(%ebp)
 12e:	89 4d b0             	mov    %ecx,-0x50(%ebp)
            return fib(n - 1) + fib(n - 2);
 131:	83 ec 0c             	sub    $0xc,%esp
 134:	48                   	dec    %eax
 135:	50                   	push   %eax
 136:	e8 39 ff ff ff       	call   74 <fib>
 13b:	83 c4 10             	add    $0x10,%esp
 13e:	83 6d e4 02          	subl   $0x2,-0x1c(%ebp)
 142:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 145:	01 45 e0             	add    %eax,-0x20(%ebp)
            if (n == 1) return 1;
 148:	89 c8                	mov    %ecx,%eax
 14a:	48                   	dec    %eax
 14b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 14e:	8b 55 ac             	mov    -0x54(%ebp),%edx
 151:	75 d0                	jne    123 <fib+0xaf>
            return fib(n - 1) + fib(n - 2);
 153:	83 e9 02             	sub    $0x2,%ecx
 156:	8b 45 e0             	mov    -0x20(%ebp),%eax
 159:	8d 5c 03 01          	lea    0x1(%ebx,%eax,1),%ebx
            if (n == 1) return 1;
 15d:	83 f9 01             	cmp    $0x1,%ecx
 160:	75 af                	jne    111 <fib+0x9d>
            return fib(n - 1) + fib(n - 2);
 162:	83 ea 02             	sub    $0x2,%edx
 165:	8d 7c 1f 01          	lea    0x1(%edi,%ebx,1),%edi
            if (n == 1) return 1;
 169:	83 fa 01             	cmp    $0x1,%edx
 16c:	75 99                	jne    107 <fib+0x93>
            return fib(n - 1) + fib(n - 2);
 16e:	89 f3                	mov    %esi,%ebx
 170:	8b 75 b8             	mov    -0x48(%ebp),%esi
 173:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 176:	89 f8                	mov    %edi,%eax
 178:	8b 7d bc             	mov    -0x44(%ebp),%edi
 17b:	83 ee 02             	sub    $0x2,%esi
 17e:	8d 4c 01 01          	lea    0x1(%ecx,%eax,1),%ecx
            if (n == 1) return 1;
 182:	83 fe 01             	cmp    $0x1,%esi
 185:	0f 85 61 ff ff ff    	jne    ec <fib+0x78>
            return fib(n - 1) + fib(n - 2);
 18b:	8b 55 c0             	mov    -0x40(%ebp),%edx
 18e:	83 eb 02             	sub    $0x2,%ebx
 191:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
            if (n == 1) return 1;
 195:	83 fb 01             	cmp    $0x1,%ebx
 198:	0f 85 3d ff ff ff    	jne    db <fib+0x67>
            return fib(n - 1) + fib(n - 2);
 19e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 1a1:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 1a4:	83 ee 02             	sub    $0x2,%esi
 1a7:	8d 7c 17 01          	lea    0x1(%edi,%edx,1),%edi
            if (n == 1) return 1;
 1ab:	83 fe 01             	cmp    $0x1,%esi
 1ae:	0f 85 13 ff ff ff    	jne    c7 <fib+0x53>
            return fib(n - 1) + fib(n - 2);
 1b4:	8b 55 d0             	mov    -0x30(%ebp),%edx
 1b7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
 1ba:	83 eb 02             	sub    $0x2,%ebx
 1bd:	8d 4c 39 01          	lea    0x1(%ecx,%edi,1),%ecx
            if (n == 1) return 1;
 1c1:	83 fb 01             	cmp    $0x1,%ebx
 1c4:	0f 85 e9 fe ff ff    	jne    b3 <fib+0x3f>
            return fib(n - 1) + fib(n - 2);
 1ca:	8b 75 d8             	mov    -0x28(%ebp),%esi
 1cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 1d0:	83 ee 02             	sub    $0x2,%esi
 1d3:	8d 54 0a 01          	lea    0x1(%edx,%ecx,1),%edx
            if (n == 1) return 1;
 1d7:	83 fe 01             	cmp    $0x1,%esi
 1da:	0f 85 bd fe ff ff    	jne    9d <fib+0x29>
 1e0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 1e3:	8d 5c 13 01          	lea    0x1(%ebx,%edx,1),%ebx
 1e7:	83 ef 02             	sub    $0x2,%edi
 1ea:	83 ff 01             	cmp    $0x1,%edi
 1ed:	0f 87 a3 fe ff ff    	ja     96 <fib+0x22>
 1f3:	8d 43 01             	lea    0x1(%ebx),%eax
}
 1f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f9:	5b                   	pop    %ebx
 1fa:	5e                   	pop    %esi
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret
            if (n <= 0) return 0;
 1fe:	31 c0                	xor    %eax,%eax
 200:	eb f4                	jmp    1f6 <fib+0x182>
 202:	66 90                	xchg   %ax,%ax

00000204 <sv>:
  {
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	83 ec 10             	sub    $0x10,%esp
        printf(1, "I am Shivam\n");
 20a:	68 1d 08 00 00       	push   $0x81d
 20f:	6a 01                	push   $0x1
 211:	e8 0e 03 00 00       	call   524 <printf>
  }
 216:	83 c4 10             	add    $0x10,%esp
 219:	c9                   	leave
 21a:	c3                   	ret
 21b:	90                   	nop

0000021c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	53                   	push   %ebx
 220:	8b 4d 08             	mov    0x8(%ebp),%ecx
 223:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 226:	31 c0                	xor    %eax,%eax
 228:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 22b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 22e:	40                   	inc    %eax
 22f:	84 d2                	test   %dl,%dl
 231:	75 f5                	jne    228 <strcpy+0xc>
    ;
  return os;
}
 233:	89 c8                	mov    %ecx,%eax
 235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 238:	c9                   	leave
 239:	c3                   	ret
 23a:	66 90                	xchg   %ax,%ax

0000023c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	53                   	push   %ebx
 240:	8b 55 08             	mov    0x8(%ebp),%edx
 243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 246:	0f b6 02             	movzbl (%edx),%eax
 249:	84 c0                	test   %al,%al
 24b:	75 10                	jne    25d <strcmp+0x21>
 24d:	eb 2a                	jmp    279 <strcmp+0x3d>
 24f:	90                   	nop
    p++, q++;
 250:	42                   	inc    %edx
 251:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 254:	0f b6 02             	movzbl (%edx),%eax
 257:	84 c0                	test   %al,%al
 259:	74 11                	je     26c <strcmp+0x30>
 25b:	89 cb                	mov    %ecx,%ebx
 25d:	0f b6 0b             	movzbl (%ebx),%ecx
 260:	38 c1                	cmp    %al,%cl
 262:	74 ec                	je     250 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 264:	29 c8                	sub    %ecx,%eax
}
 266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 269:	c9                   	leave
 26a:	c3                   	ret
 26b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 26c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 270:	31 c0                	xor    %eax,%eax
 272:	29 c8                	sub    %ecx,%eax
}
 274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 277:	c9                   	leave
 278:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 279:	0f b6 0b             	movzbl (%ebx),%ecx
 27c:	31 c0                	xor    %eax,%eax
 27e:	eb e4                	jmp    264 <strcmp+0x28>

00000280 <strlen>:

uint
strlen(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 286:	80 3a 00             	cmpb   $0x0,(%edx)
 289:	74 15                	je     2a0 <strlen+0x20>
 28b:	31 c0                	xor    %eax,%eax
 28d:	8d 76 00             	lea    0x0(%esi),%esi
 290:	40                   	inc    %eax
 291:	89 c1                	mov    %eax,%ecx
 293:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 297:	75 f7                	jne    290 <strlen+0x10>
    ;
  return n;
}
 299:	89 c8                	mov    %ecx,%eax
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret
 29d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2a0:	31 c9                	xor    %ecx,%ecx
}
 2a2:	89 c8                	mov    %ecx,%eax
 2a4:	5d                   	pop    %ebp
 2a5:	c3                   	ret
 2a6:	66 90                	xchg   %ax,%ax

000002a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2ac:	8b 7d 08             	mov    0x8(%ebp),%edi
 2af:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	fc                   	cld
 2b6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2be:	c9                   	leave
 2bf:	c3                   	ret

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 2c9:	8a 10                	mov    (%eax),%dl
 2cb:	84 d2                	test   %dl,%dl
 2cd:	75 0c                	jne    2db <strchr+0x1b>
 2cf:	eb 13                	jmp    2e4 <strchr+0x24>
 2d1:	8d 76 00             	lea    0x0(%esi),%esi
 2d4:	40                   	inc    %eax
 2d5:	8a 10                	mov    (%eax),%dl
 2d7:	84 d2                	test   %dl,%dl
 2d9:	74 09                	je     2e4 <strchr+0x24>
    if(*s == c)
 2db:	38 d1                	cmp    %dl,%cl
 2dd:	75 f5                	jne    2d4 <strchr+0x14>
      return (char*)s;
  return 0;
}
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret
 2e1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 2e4:	31 c0                	xor    %eax,%eax
}
 2e6:	5d                   	pop    %ebp
 2e7:	c3                   	ret

000002e8 <gets>:

char*
gets(char *buf, int max)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	57                   	push   %edi
 2ec:	56                   	push   %esi
 2ed:	53                   	push   %ebx
 2ee:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f1:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 2f3:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 2f6:	eb 24                	jmp    31c <gets+0x34>
    cc = read(0, &c, 1);
 2f8:	50                   	push   %eax
 2f9:	6a 01                	push   $0x1
 2fb:	56                   	push   %esi
 2fc:	6a 00                	push   $0x0
 2fe:	e8 f4 00 00 00       	call   3f7 <read>
    if(cc < 1)
 303:	83 c4 10             	add    $0x10,%esp
 306:	85 c0                	test   %eax,%eax
 308:	7e 1a                	jle    324 <gets+0x3c>
      break;
    buf[i++] = c;
 30a:	8a 45 e7             	mov    -0x19(%ebp),%al
 30d:	8b 55 08             	mov    0x8(%ebp),%edx
 310:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 0e                	je     326 <gets+0x3e>
 318:	3c 0d                	cmp    $0xd,%al
 31a:	74 0a                	je     326 <gets+0x3e>
  for(i=0; i+1 < max; ){
 31c:	89 df                	mov    %ebx,%edi
 31e:	43                   	inc    %ebx
 31f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 322:	7c d4                	jl     2f8 <gets+0x10>
 324:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 32d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 330:	5b                   	pop    %ebx
 331:	5e                   	pop    %esi
 332:	5f                   	pop    %edi
 333:	5d                   	pop    %ebp
 334:	c3                   	ret
 335:	8d 76 00             	lea    0x0(%esi),%esi

00000338 <stat>:

int
stat(const char *n, struct stat *st)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	56                   	push   %esi
 33c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33d:	83 ec 08             	sub    $0x8,%esp
 340:	6a 00                	push   $0x0
 342:	ff 75 08             	push   0x8(%ebp)
 345:	e8 d5 00 00 00       	call   41f <open>
  if(fd < 0)
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	85 c0                	test   %eax,%eax
 34f:	78 27                	js     378 <stat+0x40>
 351:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 353:	83 ec 08             	sub    $0x8,%esp
 356:	ff 75 0c             	push   0xc(%ebp)
 359:	50                   	push   %eax
 35a:	e8 d8 00 00 00       	call   437 <fstat>
 35f:	89 c6                	mov    %eax,%esi
  close(fd);
 361:	89 1c 24             	mov    %ebx,(%esp)
 364:	e8 9e 00 00 00       	call   407 <close>
  return r;
 369:	83 c4 10             	add    $0x10,%esp
}
 36c:	89 f0                	mov    %esi,%eax
 36e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 371:	5b                   	pop    %ebx
 372:	5e                   	pop    %esi
 373:	5d                   	pop    %ebp
 374:	c3                   	ret
 375:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 378:	be ff ff ff ff       	mov    $0xffffffff,%esi
 37d:	eb ed                	jmp    36c <stat+0x34>
 37f:	90                   	nop

00000380 <atoi>:

int
atoi(const char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 387:	0f be 01             	movsbl (%ecx),%eax
 38a:	8d 50 d0             	lea    -0x30(%eax),%edx
 38d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 390:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 395:	77 16                	ja     3ad <atoi+0x2d>
 397:	90                   	nop
    n = n*10 + *s++ - '0';
 398:	41                   	inc    %ecx
 399:	8d 14 92             	lea    (%edx,%edx,4),%edx
 39c:	01 d2                	add    %edx,%edx
 39e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 3a2:	0f be 01             	movsbl (%ecx),%eax
 3a5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3a8:	80 fb 09             	cmp    $0x9,%bl
 3ab:	76 eb                	jbe    398 <atoi+0x18>
  return n;
}
 3ad:	89 d0                	mov    %edx,%eax
 3af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3b2:	c9                   	leave
 3b3:	c3                   	ret

000003b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	57                   	push   %edi
 3b8:	56                   	push   %esi
 3b9:	8b 55 08             	mov    0x8(%ebp),%edx
 3bc:	8b 75 0c             	mov    0xc(%ebp),%esi
 3bf:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3c2:	85 c0                	test   %eax,%eax
 3c4:	7e 0b                	jle    3d1 <memmove+0x1d>
 3c6:	01 d0                	add    %edx,%eax
  dst = vdst;
 3c8:	89 d7                	mov    %edx,%edi
 3ca:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3cc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3cd:	39 f8                	cmp    %edi,%eax
 3cf:	75 fb                	jne    3cc <memmove+0x18>
  return vdst;
}
 3d1:	89 d0                	mov    %edx,%eax
 3d3:	5e                   	pop    %esi
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret

000003d7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d7:	b8 01 00 00 00       	mov    $0x1,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret

000003df <exit>:
SYSCALL(exit)
 3df:	b8 02 00 00 00       	mov    $0x2,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret

000003e7 <wait>:
SYSCALL(wait)
 3e7:	b8 03 00 00 00       	mov    $0x3,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret

000003ef <pipe>:
SYSCALL(pipe)
 3ef:	b8 04 00 00 00       	mov    $0x4,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret

000003f7 <read>:
SYSCALL(read)
 3f7:	b8 05 00 00 00       	mov    $0x5,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret

000003ff <write>:
SYSCALL(write)
 3ff:	b8 10 00 00 00       	mov    $0x10,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret

00000407 <close>:
SYSCALL(close)
 407:	b8 15 00 00 00       	mov    $0x15,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret

0000040f <kill>:
SYSCALL(kill)
 40f:	b8 06 00 00 00       	mov    $0x6,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret

00000417 <exec>:
SYSCALL(exec)
 417:	b8 07 00 00 00       	mov    $0x7,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret

0000041f <open>:
SYSCALL(open)
 41f:	b8 0f 00 00 00       	mov    $0xf,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret

00000427 <mknod>:
SYSCALL(mknod)
 427:	b8 11 00 00 00       	mov    $0x11,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret

0000042f <unlink>:
SYSCALL(unlink)
 42f:	b8 12 00 00 00       	mov    $0x12,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret

00000437 <fstat>:
SYSCALL(fstat)
 437:	b8 08 00 00 00       	mov    $0x8,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret

0000043f <link>:
SYSCALL(link)
 43f:	b8 13 00 00 00       	mov    $0x13,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret

00000447 <mkdir>:
SYSCALL(mkdir)
 447:	b8 14 00 00 00       	mov    $0x14,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret

0000044f <chdir>:
SYSCALL(chdir)
 44f:	b8 09 00 00 00       	mov    $0x9,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret

00000457 <dup>:
SYSCALL(dup)
 457:	b8 0a 00 00 00       	mov    $0xa,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret

0000045f <getpid>:
SYSCALL(getpid)
 45f:	b8 0b 00 00 00       	mov    $0xb,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret

00000467 <sbrk>:
SYSCALL(sbrk)
 467:	b8 0c 00 00 00       	mov    $0xc,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret

0000046f <sleep>:
SYSCALL(sleep)
 46f:	b8 0d 00 00 00       	mov    $0xd,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret

00000477 <uptime>:
SYSCALL(uptime)
 477:	b8 0e 00 00 00       	mov    $0xe,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret

0000047f <signal>:
SYSCALL(signal)
 47f:	b8 16 00 00 00       	mov    $0x16,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret

00000487 <custom_fork>:
SYSCALL(custom_fork)
 487:	b8 17 00 00 00       	mov    $0x17,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret

0000048f <scheduler_start>:
 48f:	b8 18 00 00 00       	mov    $0x18,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret
 497:	90                   	nop

00000498 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	57                   	push   %edi
 49c:	56                   	push   %esi
 49d:	53                   	push   %ebx
 49e:	83 ec 3c             	sub    $0x3c,%esp
 4a1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4a4:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4a9:	85 c9                	test   %ecx,%ecx
 4ab:	74 04                	je     4b1 <printint+0x19>
 4ad:	85 d2                	test   %edx,%edx
 4af:	78 6b                	js     51c <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 4b4:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 4bb:	31 c9                	xor    %ecx,%ecx
 4bd:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 4c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4c3:	31 d2                	xor    %edx,%edx
 4c5:	f7 f3                	div    %ebx
 4c7:	89 cf                	mov    %ecx,%edi
 4c9:	8d 49 01             	lea    0x1(%ecx),%ecx
 4cc:	8a 92 a8 08 00 00    	mov    0x8a8(%edx),%dl
 4d2:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 4d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 4d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4dc:	39 da                	cmp    %ebx,%edx
 4de:	73 e0                	jae    4c0 <printint+0x28>
  if(neg)
 4e0:	8b 55 08             	mov    0x8(%ebp),%edx
 4e3:	85 d2                	test   %edx,%edx
 4e5:	74 07                	je     4ee <printint+0x56>
    buf[i++] = '-';
 4e7:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 4ec:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 4ee:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 4f1:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 4f8:	8a 07                	mov    (%edi),%al
 4fa:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 4fd:	50                   	push   %eax
 4fe:	6a 01                	push   $0x1
 500:	56                   	push   %esi
 501:	ff 75 c0             	push   -0x40(%ebp)
 504:	e8 f6 fe ff ff       	call   3ff <write>
  while(--i >= 0)
 509:	89 f8                	mov    %edi,%eax
 50b:	4f                   	dec    %edi
 50c:	83 c4 10             	add    $0x10,%esp
 50f:	39 d8                	cmp    %ebx,%eax
 511:	75 e5                	jne    4f8 <printint+0x60>
}
 513:	8d 65 f4             	lea    -0xc(%ebp),%esp
 516:	5b                   	pop    %ebx
 517:	5e                   	pop    %esi
 518:	5f                   	pop    %edi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret
 51b:	90                   	nop
    x = -xx;
 51c:	f7 da                	neg    %edx
 51e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 521:	eb 98                	jmp    4bb <printint+0x23>
 523:	90                   	nop

00000524 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	57                   	push   %edi
 528:	56                   	push   %esi
 529:	53                   	push   %ebx
 52a:	83 ec 2c             	sub    $0x2c,%esp
 52d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 530:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 533:	8a 03                	mov    (%ebx),%al
 535:	84 c0                	test   %al,%al
 537:	74 2a                	je     563 <printf+0x3f>
 539:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 53a:	8d 4d 10             	lea    0x10(%ebp),%ecx
 53d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 540:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 543:	83 fa 25             	cmp    $0x25,%edx
 546:	74 24                	je     56c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 548:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 54b:	50                   	push   %eax
 54c:	6a 01                	push   $0x1
 54e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 551:	50                   	push   %eax
 552:	56                   	push   %esi
 553:	e8 a7 fe ff ff       	call   3ff <write>
  for(i = 0; fmt[i]; i++){
 558:	43                   	inc    %ebx
 559:	8a 43 ff             	mov    -0x1(%ebx),%al
 55c:	83 c4 10             	add    $0x10,%esp
 55f:	84 c0                	test   %al,%al
 561:	75 dd                	jne    540 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 563:	8d 65 f4             	lea    -0xc(%ebp),%esp
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret
 56b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 56c:	8a 13                	mov    (%ebx),%dl
 56e:	84 d2                	test   %dl,%dl
 570:	74 f1                	je     563 <printf+0x3f>
    c = fmt[i] & 0xff;
 572:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 575:	80 fa 25             	cmp    $0x25,%dl
 578:	0f 84 fe 00 00 00    	je     67c <printf+0x158>
 57e:	83 e8 63             	sub    $0x63,%eax
 581:	83 f8 15             	cmp    $0x15,%eax
 584:	77 0a                	ja     590 <printf+0x6c>
 586:	ff 24 85 50 08 00 00 	jmp    *0x850(,%eax,4)
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 593:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 597:	50                   	push   %eax
 598:	6a 01                	push   $0x1
 59a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 59d:	57                   	push   %edi
 59e:	56                   	push   %esi
 59f:	e8 5b fe ff ff       	call   3ff <write>
        putc(fd, c);
 5a4:	8a 55 d0             	mov    -0x30(%ebp),%dl
 5a7:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5aa:	83 c4 0c             	add    $0xc,%esp
 5ad:	6a 01                	push   $0x1
 5af:	57                   	push   %edi
 5b0:	56                   	push   %esi
 5b1:	e8 49 fe ff ff       	call   3ff <write>
  for(i = 0; fmt[i]; i++){
 5b6:	83 c3 02             	add    $0x2,%ebx
 5b9:	8a 43 ff             	mov    -0x1(%ebx),%al
 5bc:	83 c4 10             	add    $0x10,%esp
 5bf:	84 c0                	test   %al,%al
 5c1:	0f 85 79 ff ff ff    	jne    540 <printf+0x1c>
}
 5c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5f                   	pop    %edi
 5cd:	5d                   	pop    %ebp
 5ce:	c3                   	ret
 5cf:	90                   	nop
        printint(fd, *ap, 16, 0);
 5d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5d3:	8b 17                	mov    (%edi),%edx
 5d5:	83 ec 0c             	sub    $0xc,%esp
 5d8:	6a 00                	push   $0x0
 5da:	b9 10 00 00 00       	mov    $0x10,%ecx
 5df:	89 f0                	mov    %esi,%eax
 5e1:	e8 b2 fe ff ff       	call   498 <printint>
        ap++;
 5e6:	83 c7 04             	add    $0x4,%edi
 5e9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 5ec:	eb c8                	jmp    5b6 <printf+0x92>
 5ee:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 5f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 5f3:	8b 01                	mov    (%ecx),%eax
        ap++;
 5f5:	83 c1 04             	add    $0x4,%ecx
 5f8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 5fb:	85 c0                	test   %eax,%eax
 5fd:	0f 84 89 00 00 00    	je     68c <printf+0x168>
        while(*s != 0){
 603:	8a 10                	mov    (%eax),%dl
 605:	84 d2                	test   %dl,%dl
 607:	74 29                	je     632 <printf+0x10e>
 609:	89 c7                	mov    %eax,%edi
 60b:	88 d0                	mov    %dl,%al
 60d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 610:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 613:	89 fb                	mov    %edi,%ebx
 615:	89 cf                	mov    %ecx,%edi
 617:	90                   	nop
          putc(fd, *s);
 618:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 61b:	50                   	push   %eax
 61c:	6a 01                	push   $0x1
 61e:	57                   	push   %edi
 61f:	56                   	push   %esi
 620:	e8 da fd ff ff       	call   3ff <write>
          s++;
 625:	43                   	inc    %ebx
        while(*s != 0){
 626:	8a 03                	mov    (%ebx),%al
 628:	83 c4 10             	add    $0x10,%esp
 62b:	84 c0                	test   %al,%al
 62d:	75 e9                	jne    618 <printf+0xf4>
 62f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 632:	83 c3 02             	add    $0x2,%ebx
 635:	8a 43 ff             	mov    -0x1(%ebx),%al
 638:	84 c0                	test   %al,%al
 63a:	0f 85 00 ff ff ff    	jne    540 <printf+0x1c>
 640:	e9 1e ff ff ff       	jmp    563 <printf+0x3f>
 645:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 648:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 64b:	8b 17                	mov    (%edi),%edx
 64d:	83 ec 0c             	sub    $0xc,%esp
 650:	6a 01                	push   $0x1
 652:	b9 0a 00 00 00       	mov    $0xa,%ecx
 657:	eb 86                	jmp    5df <printf+0xbb>
 659:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 65c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 664:	51                   	push   %ecx
 665:	6a 01                	push   $0x1
 667:	8d 7d e7             	lea    -0x19(%ebp),%edi
 66a:	57                   	push   %edi
 66b:	56                   	push   %esi
 66c:	e8 8e fd ff ff       	call   3ff <write>
        ap++;
 671:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 675:	e9 3c ff ff ff       	jmp    5b6 <printf+0x92>
 67a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 67c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 67f:	52                   	push   %edx
 680:	6a 01                	push   $0x1
 682:	8d 7d e7             	lea    -0x19(%ebp),%edi
 685:	e9 25 ff ff ff       	jmp    5af <printf+0x8b>
 68a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 68c:	bf 47 08 00 00       	mov    $0x847,%edi
 691:	b0 28                	mov    $0x28,%al
 693:	e9 75 ff ff ff       	jmp    60d <printf+0xe9>

00000698 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	57                   	push   %edi
 69c:	56                   	push   %esi
 69d:	53                   	push   %ebx
 69e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	a1 bc 08 00 00       	mov    0x8bc,%eax
 6a9:	8d 76 00             	lea    0x0(%esi),%esi
 6ac:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ae:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	39 ca                	cmp    %ecx,%edx
 6b2:	73 2c                	jae    6e0 <free+0x48>
 6b4:	39 c1                	cmp    %eax,%ecx
 6b6:	72 04                	jb     6bc <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b8:	39 c2                	cmp    %eax,%edx
 6ba:	72 f0                	jb     6ac <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6bf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6c2:	39 f8                	cmp    %edi,%eax
 6c4:	74 2c                	je     6f2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c9:	8b 42 04             	mov    0x4(%edx),%eax
 6cc:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6cf:	39 f1                	cmp    %esi,%ecx
 6d1:	74 36                	je     709 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6d3:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 6d5:	89 15 bc 08 00 00    	mov    %edx,0x8bc
}
 6db:	5b                   	pop    %ebx
 6dc:	5e                   	pop    %esi
 6dd:	5f                   	pop    %edi
 6de:	5d                   	pop    %ebp
 6df:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	39 c2                	cmp    %eax,%edx
 6e2:	72 c8                	jb     6ac <free+0x14>
 6e4:	39 c1                	cmp    %eax,%ecx
 6e6:	73 c4                	jae    6ac <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 6e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ee:	39 f8                	cmp    %edi,%eax
 6f0:	75 d4                	jne    6c6 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 6f2:	03 70 04             	add    0x4(%eax),%esi
 6f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	8b 02                	mov    (%edx),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ff:	8b 42 04             	mov    0x4(%edx),%eax
 702:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 705:	39 f1                	cmp    %esi,%ecx
 707:	75 ca                	jne    6d3 <free+0x3b>
    p->s.size += bp->s.size;
 709:	03 43 fc             	add    -0x4(%ebx),%eax
 70c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 70f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 712:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 714:	89 15 bc 08 00 00    	mov    %edx,0x8bc
}
 71a:	5b                   	pop    %ebx
 71b:	5e                   	pop    %esi
 71c:	5f                   	pop    %edi
 71d:	5d                   	pop    %ebp
 71e:	c3                   	ret
 71f:	90                   	nop

00000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	8d 78 07             	lea    0x7(%eax),%edi
 72f:	c1 ef 03             	shr    $0x3,%edi
 732:	47                   	inc    %edi
  if((prevp = freep) == 0){
 733:	8b 15 bc 08 00 00    	mov    0x8bc,%edx
 739:	85 d2                	test   %edx,%edx
 73b:	0f 84 93 00 00 00    	je     7d4 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 741:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 743:	8b 48 04             	mov    0x4(%eax),%ecx
 746:	39 f9                	cmp    %edi,%ecx
 748:	73 62                	jae    7ac <malloc+0x8c>
  if(nu < 4096)
 74a:	89 fb                	mov    %edi,%ebx
 74c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 752:	72 78                	jb     7cc <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 754:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 75b:	eb 0e                	jmp    76b <malloc+0x4b>
 75d:	8d 76 00             	lea    0x0(%esi),%esi
 760:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 762:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 764:	8b 48 04             	mov    0x4(%eax),%ecx
 767:	39 f9                	cmp    %edi,%ecx
 769:	73 41                	jae    7ac <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76b:	39 05 bc 08 00 00    	cmp    %eax,0x8bc
 771:	75 ed                	jne    760 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	56                   	push   %esi
 777:	e8 eb fc ff ff       	call   467 <sbrk>
  if(p == (char*)-1)
 77c:	83 c4 10             	add    $0x10,%esp
 77f:	83 f8 ff             	cmp    $0xffffffff,%eax
 782:	74 1c                	je     7a0 <malloc+0x80>
  hp->s.size = nu;
 784:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 787:	83 ec 0c             	sub    $0xc,%esp
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	50                   	push   %eax
 78e:	e8 05 ff ff ff       	call   698 <free>
  return freep;
 793:	8b 15 bc 08 00 00    	mov    0x8bc,%edx
      if((p = morecore(nunits)) == 0)
 799:	83 c4 10             	add    $0x10,%esp
 79c:	85 d2                	test   %edx,%edx
 79e:	75 c2                	jne    762 <malloc+0x42>
        return 0;
 7a0:	31 c0                	xor    %eax,%eax
  }
}
 7a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7a5:	5b                   	pop    %ebx
 7a6:	5e                   	pop    %esi
 7a7:	5f                   	pop    %edi
 7a8:	5d                   	pop    %ebp
 7a9:	c3                   	ret
 7aa:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 7ac:	39 cf                	cmp    %ecx,%edi
 7ae:	74 4c                	je     7fc <malloc+0xdc>
        p->s.size -= nunits;
 7b0:	29 f9                	sub    %edi,%ecx
 7b2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7b5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7b8:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7bb:	89 15 bc 08 00 00    	mov    %edx,0x8bc
      return (void*)(p + 1);
 7c1:	83 c0 08             	add    $0x8,%eax
}
 7c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7c7:	5b                   	pop    %ebx
 7c8:	5e                   	pop    %esi
 7c9:	5f                   	pop    %edi
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret
  if(nu < 4096)
 7cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7d1:	eb 81                	jmp    754 <malloc+0x34>
 7d3:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7d4:	c7 05 bc 08 00 00 c0 	movl   $0x8c0,0x8bc
 7db:	08 00 00 
 7de:	c7 05 c0 08 00 00 c0 	movl   $0x8c0,0x8c0
 7e5:	08 00 00 
    base.s.size = 0;
 7e8:	c7 05 c4 08 00 00 00 	movl   $0x0,0x8c4
 7ef:	00 00 00 
 7f2:	b8 c0 08 00 00       	mov    $0x8c0,%eax
 7f7:	e9 4e ff ff ff       	jmp    74a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 7fc:	8b 08                	mov    (%eax),%ecx
 7fe:	89 0a                	mov    %ecx,(%edx)
 800:	eb b9                	jmp    7bb <malloc+0x9b>
