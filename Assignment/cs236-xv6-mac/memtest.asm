
_memtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	exit();
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 08             	sub    $0x8,%esp
	printf(1,"Total Memory    : %d\n", TOTAL_MEMORY);
  11:	68 00 00 26 00       	push   $0x260000
  16:	68 5b 07 00 00       	push   $0x75b
  1b:	6a 01                	push   $0x1
  1d:	e8 fa 03 00 00       	call   41c <printf>
	printf(1,"Page Size       : 4096\n");
  22:	58                   	pop    %eax
  23:	5a                   	pop    %edx
  24:	68 71 07 00 00       	push   $0x771
  29:	6a 01                	push   $0x1
  2b:	e8 ec 03 00 00       	call   41c <printf>
	
	mem(); // 3 page table
  30:	e8 03 00 00 00       	call   38 <mem>
  35:	66 90                	xchg   %ax,%ax
  37:	90                   	nop

00000038 <mem>:
{   
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	57                   	push   %edi
  3c:	56                   	push   %esi
  3d:	53                   	push   %ebx
  3e:	83 ec 28             	sub    $0x28,%esp
	m1 = malloc(4096);
  41:	68 00 10 00 00       	push   $0x1000
  46:	e8 cd 05 00 00       	call   618 <malloc>
  4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (m1 == 0)
  4e:	83 c4 10             	add    $0x10,%esp
  51:	85 c0                	test   %eax,%eax
  53:	0f 84 ab 00 00 00    	je     104 <mem+0xcc>
	m1 = malloc(4096);
  59:	8b 5d e0             	mov    -0x20(%ebp),%ebx
	uint count = 0;
  5c:	31 ff                	xor    %edi,%edi
  5e:	eb 26                	jmp    86 <mem+0x4e>
		*(char**)m1 = m2;
  60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  63:	89 02                	mov    %eax,(%edx)
		((int*)m1)[2] = count++;
  65:	8d 77 01             	lea    0x1(%edi),%esi
  68:	89 7a 08             	mov    %edi,0x8(%edx)
	    printf(1,"mallocing page no :%d\n", i);
  6b:	57                   	push   %edi
  6c:	56                   	push   %esi
  6d:	68 12 07 00 00       	push   $0x712
  72:	6a 01                	push   $0x1
  74:	e8 a3 03 00 00       	call   41c <printf>
	while (cur < TOTAL_MEMORY) {
  79:	83 c4 10             	add    $0x10,%esp
  7c:	81 fe 60 02 00 00    	cmp    $0x260,%esi
  82:	74 53                	je     d7 <mem+0x9f>
  84:	89 f7                	mov    %esi,%edi
		m2 = malloc(4096);
  86:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  89:	83 ec 0c             	sub    $0xc,%esp
  8c:	68 00 10 00 00       	push   $0x1000
  91:	e8 82 05 00 00       	call   618 <malloc>
  96:	89 c3                	mov    %eax,%ebx
		if (m2 == 0)
  98:	83 c4 10             	add    $0x10,%esp
  9b:	85 c0                	test   %eax,%eax
  9d:	75 c1                	jne    60 <mem+0x28>
	printf(1,"total only %d pages allocated\n", i);
  9f:	50                   	push   %eax
  a0:	57                   	push   %edi
  a1:	68 90 07 00 00       	push   $0x790
  a6:	6a 01                	push   $0x1
  a8:	e8 6f 03 00 00       	call   41c <printf>
	printf(2,"Remaing Pages %d\n", total_count - i);
  ad:	83 c4 0c             	add    $0xc,%esp
  b0:	b8 60 02 00 00       	mov    $0x260,%eax
  b5:	29 f8                	sub    %edi,%eax
  b7:	50                   	push   %eax
  b8:	68 39 07 00 00       	push   $0x739
  bd:	6a 02                	push   $0x2
  bf:	e8 58 03 00 00       	call   41c <printf>
	printf(1, "Memtest Failed\n");
  c4:	5a                   	pop    %edx
  c5:	59                   	pop    %ecx
  c6:	68 4b 07 00 00       	push   $0x74b
  cb:	6a 01                	push   $0x1
  cd:	e8 4a 03 00 00       	call   41c <printf>
	exit();
  d2:	e8 18 02 00 00       	call   2ef <exit>
	((int*)m1)[2] = count;
  d7:	c7 43 08 60 02 00 00 	movl   $0x260,0x8(%ebx)
	count = 0;
  de:	31 c0                	xor    %eax,%eax
  e0:	eb 13                	jmp    f5 <mem+0xbd>
  e2:	66 90                	xchg   %ax,%ax
		m1 = *(char**)m1;
  e4:	8b 09                	mov    (%ecx),%ecx
  e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		count++;
  e9:	8d 50 01             	lea    0x1(%eax),%edx
	while (count != total_count) {
  ec:	3d 5f 02 00 00       	cmp    $0x25f,%eax
  f1:	74 26                	je     119 <mem+0xe1>
  f3:	89 d0                	mov    %edx,%eax
		if (((int*)m1)[2] != count)
  f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  f8:	39 41 08             	cmp    %eax,0x8(%ecx)
  fb:	74 e7                	je     e4 <mem+0xac>
  fd:	bf 60 02 00 00       	mov    $0x260,%edi
 102:	eb 9b                	jmp    9f <mem+0x67>
	    printf(1,"malloc failed  1 ...\n");
 104:	50                   	push   %eax
 105:	50                   	push   %eax
 106:	68 fc 06 00 00       	push   $0x6fc
 10b:	6a 01                	push   $0x1
 10d:	e8 0a 03 00 00       	call   41c <printf>
		goto failed;
 112:	83 c4 10             	add    $0x10,%esp
	i = 0;
 115:	31 ff                	xor    %edi,%edi
		goto failed;
 117:	eb 86                	jmp    9f <mem+0x67>
	printf(1, "Memtest Passed\n");
 119:	53                   	push   %ebx
 11a:	53                   	push   %ebx
 11b:	68 29 07 00 00       	push   $0x729
 120:	6a 01                	push   $0x1
 122:	e8 f5 02 00 00       	call   41c <printf>
	exit();
 127:	e8 c3 01 00 00       	call   2ef <exit>

0000012c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	53                   	push   %ebx
 130:	8b 4d 08             	mov    0x8(%ebp),%ecx
 133:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 136:	31 c0                	xor    %eax,%eax
 138:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 13b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 13e:	40                   	inc    %eax
 13f:	84 d2                	test   %dl,%dl
 141:	75 f5                	jne    138 <strcpy+0xc>
    ;
  return os;
}
 143:	89 c8                	mov    %ecx,%eax
 145:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 148:	c9                   	leave
 149:	c3                   	ret
 14a:	66 90                	xchg   %ax,%ax

0000014c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	53                   	push   %ebx
 150:	8b 55 08             	mov    0x8(%ebp),%edx
 153:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 156:	0f b6 02             	movzbl (%edx),%eax
 159:	84 c0                	test   %al,%al
 15b:	75 10                	jne    16d <strcmp+0x21>
 15d:	eb 2a                	jmp    189 <strcmp+0x3d>
 15f:	90                   	nop
    p++, q++;
 160:	42                   	inc    %edx
 161:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 164:	0f b6 02             	movzbl (%edx),%eax
 167:	84 c0                	test   %al,%al
 169:	74 11                	je     17c <strcmp+0x30>
 16b:	89 cb                	mov    %ecx,%ebx
 16d:	0f b6 0b             	movzbl (%ebx),%ecx
 170:	38 c1                	cmp    %al,%cl
 172:	74 ec                	je     160 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 174:	29 c8                	sub    %ecx,%eax
}
 176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 179:	c9                   	leave
 17a:	c3                   	ret
 17b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 17c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 180:	31 c0                	xor    %eax,%eax
 182:	29 c8                	sub    %ecx,%eax
}
 184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 187:	c9                   	leave
 188:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 189:	0f b6 0b             	movzbl (%ebx),%ecx
 18c:	31 c0                	xor    %eax,%eax
 18e:	eb e4                	jmp    174 <strcmp+0x28>

00000190 <strlen>:

uint
strlen(const char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 3a 00             	cmpb   $0x0,(%edx)
 199:	74 15                	je     1b0 <strlen+0x20>
 19b:	31 c0                	xor    %eax,%eax
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	40                   	inc    %eax
 1a1:	89 c1                	mov    %eax,%ecx
 1a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1a7:	75 f7                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1a9:	89 c8                	mov    %ecx,%eax
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1b0:	31 c9                	xor    %ecx,%ecx
}
 1b2:	89 c8                	mov    %ecx,%eax
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret
 1b6:	66 90                	xchg   %ax,%ax

000001b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1bc:	8b 7d 08             	mov    0x8(%ebp),%edi
 1bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	fc                   	cld
 1c6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1ce:	c9                   	leave
 1cf:	c3                   	ret

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1d9:	8a 10                	mov    (%eax),%dl
 1db:	84 d2                	test   %dl,%dl
 1dd:	75 0c                	jne    1eb <strchr+0x1b>
 1df:	eb 13                	jmp    1f4 <strchr+0x24>
 1e1:	8d 76 00             	lea    0x0(%esi),%esi
 1e4:	40                   	inc    %eax
 1e5:	8a 10                	mov    (%eax),%dl
 1e7:	84 d2                	test   %dl,%dl
 1e9:	74 09                	je     1f4 <strchr+0x24>
    if(*s == c)
 1eb:	38 d1                	cmp    %dl,%cl
 1ed:	75 f5                	jne    1e4 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret
 1f1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1f4:	31 c0                	xor    %eax,%eax
}
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret

000001f8 <gets>:

char*
gets(char *buf, int max)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	57                   	push   %edi
 1fc:	56                   	push   %esi
 1fd:	53                   	push   %ebx
 1fe:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 201:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 203:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 206:	eb 24                	jmp    22c <gets+0x34>
    cc = read(0, &c, 1);
 208:	50                   	push   %eax
 209:	6a 01                	push   $0x1
 20b:	56                   	push   %esi
 20c:	6a 00                	push   $0x0
 20e:	e8 f4 00 00 00       	call   307 <read>
    if(cc < 1)
 213:	83 c4 10             	add    $0x10,%esp
 216:	85 c0                	test   %eax,%eax
 218:	7e 1a                	jle    234 <gets+0x3c>
      break;
    buf[i++] = c;
 21a:	8a 45 e7             	mov    -0x19(%ebp),%al
 21d:	8b 55 08             	mov    0x8(%ebp),%edx
 220:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 224:	3c 0a                	cmp    $0xa,%al
 226:	74 0e                	je     236 <gets+0x3e>
 228:	3c 0d                	cmp    $0xd,%al
 22a:	74 0a                	je     236 <gets+0x3e>
  for(i=0; i+1 < max; ){
 22c:	89 df                	mov    %ebx,%edi
 22e:	43                   	inc    %ebx
 22f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 232:	7c d4                	jl     208 <gets+0x10>
 234:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 23d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 240:	5b                   	pop    %ebx
 241:	5e                   	pop    %esi
 242:	5f                   	pop    %edi
 243:	5d                   	pop    %ebp
 244:	c3                   	ret
 245:	8d 76 00             	lea    0x0(%esi),%esi

00000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	56                   	push   %esi
 24c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24d:	83 ec 08             	sub    $0x8,%esp
 250:	6a 00                	push   $0x0
 252:	ff 75 08             	push   0x8(%ebp)
 255:	e8 d5 00 00 00       	call   32f <open>
  if(fd < 0)
 25a:	83 c4 10             	add    $0x10,%esp
 25d:	85 c0                	test   %eax,%eax
 25f:	78 27                	js     288 <stat+0x40>
 261:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 263:	83 ec 08             	sub    $0x8,%esp
 266:	ff 75 0c             	push   0xc(%ebp)
 269:	50                   	push   %eax
 26a:	e8 d8 00 00 00       	call   347 <fstat>
 26f:	89 c6                	mov    %eax,%esi
  close(fd);
 271:	89 1c 24             	mov    %ebx,(%esp)
 274:	e8 9e 00 00 00       	call   317 <close>
  return r;
 279:	83 c4 10             	add    $0x10,%esp
}
 27c:	89 f0                	mov    %esi,%eax
 27e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 281:	5b                   	pop    %ebx
 282:	5e                   	pop    %esi
 283:	5d                   	pop    %ebp
 284:	c3                   	ret
 285:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 288:	be ff ff ff ff       	mov    $0xffffffff,%esi
 28d:	eb ed                	jmp    27c <stat+0x34>
 28f:	90                   	nop

00000290 <atoi>:

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 01             	movsbl (%ecx),%eax
 29a:	8d 50 d0             	lea    -0x30(%eax),%edx
 29d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2a0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2a5:	77 16                	ja     2bd <atoi+0x2d>
 2a7:	90                   	nop
    n = n*10 + *s++ - '0';
 2a8:	41                   	inc    %ecx
 2a9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2ac:	01 d2                	add    %edx,%edx
 2ae:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2b2:	0f be 01             	movsbl (%ecx),%eax
 2b5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b8:	80 fb 09             	cmp    $0x9,%bl
 2bb:	76 eb                	jbe    2a8 <atoi+0x18>
  return n;
}
 2bd:	89 d0                	mov    %edx,%eax
 2bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c2:	c9                   	leave
 2c3:	c3                   	ret

000002c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	56                   	push   %esi
 2c9:	8b 55 08             	mov    0x8(%ebp),%edx
 2cc:	8b 75 0c             	mov    0xc(%ebp),%esi
 2cf:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d2:	85 c0                	test   %eax,%eax
 2d4:	7e 0b                	jle    2e1 <memmove+0x1d>
 2d6:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d8:	89 d7                	mov    %edx,%edi
 2da:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2dc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2dd:	39 f8                	cmp    %edi,%eax
 2df:	75 fb                	jne    2dc <memmove+0x18>
  return vdst;
}
 2e1:	89 d0                	mov    %edx,%eax
 2e3:	5e                   	pop    %esi
 2e4:	5f                   	pop    %edi
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret

000002e7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <exit>:
SYSCALL(exit)
 2ef:	b8 02 00 00 00       	mov    $0x2,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <wait>:
SYSCALL(wait)
 2f7:	b8 03 00 00 00       	mov    $0x3,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <pipe>:
SYSCALL(pipe)
 2ff:	b8 04 00 00 00       	mov    $0x4,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <read>:
SYSCALL(read)
 307:	b8 05 00 00 00       	mov    $0x5,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <write>:
SYSCALL(write)
 30f:	b8 10 00 00 00       	mov    $0x10,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <close>:
SYSCALL(close)
 317:	b8 15 00 00 00       	mov    $0x15,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <kill>:
SYSCALL(kill)
 31f:	b8 06 00 00 00       	mov    $0x6,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <exec>:
SYSCALL(exec)
 327:	b8 07 00 00 00       	mov    $0x7,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <open>:
SYSCALL(open)
 32f:	b8 0f 00 00 00       	mov    $0xf,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <mknod>:
SYSCALL(mknod)
 337:	b8 11 00 00 00       	mov    $0x11,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <unlink>:
SYSCALL(unlink)
 33f:	b8 12 00 00 00       	mov    $0x12,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <fstat>:
SYSCALL(fstat)
 347:	b8 08 00 00 00       	mov    $0x8,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <link>:
SYSCALL(link)
 34f:	b8 13 00 00 00       	mov    $0x13,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret

00000357 <mkdir>:
SYSCALL(mkdir)
 357:	b8 14 00 00 00       	mov    $0x14,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <chdir>:
SYSCALL(chdir)
 35f:	b8 09 00 00 00       	mov    $0x9,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <dup>:
SYSCALL(dup)
 367:	b8 0a 00 00 00       	mov    $0xa,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <getpid>:
SYSCALL(getpid)
 36f:	b8 0b 00 00 00       	mov    $0xb,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret

00000377 <sbrk>:
SYSCALL(sbrk)
 377:	b8 0c 00 00 00       	mov    $0xc,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret

0000037f <sleep>:
SYSCALL(sleep)
 37f:	b8 0d 00 00 00       	mov    $0xd,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret

00000387 <uptime>:
SYSCALL(uptime)
 387:	b8 0e 00 00 00       	mov    $0xe,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret
 38f:	90                   	nop

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 3c             	sub    $0x3c,%esp
 399:	89 45 c0             	mov    %eax,-0x40(%ebp)
 39c:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a1:	85 c9                	test   %ecx,%ecx
 3a3:	74 04                	je     3a9 <printint+0x19>
 3a5:	85 d2                	test   %edx,%edx
 3a7:	78 6b                	js     414 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 3ac:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 3b3:	31 c9                	xor    %ecx,%ecx
 3b5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3bb:	31 d2                	xor    %edx,%edx
 3bd:	f7 f3                	div    %ebx
 3bf:	89 cf                	mov    %ecx,%edi
 3c1:	8d 49 01             	lea    0x1(%ecx),%ecx
 3c4:	8a 92 08 08 00 00    	mov    0x808(%edx),%dl
 3ca:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3ce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3d4:	39 da                	cmp    %ebx,%edx
 3d6:	73 e0                	jae    3b8 <printint+0x28>
  if(neg)
 3d8:	8b 55 08             	mov    0x8(%ebp),%edx
 3db:	85 d2                	test   %edx,%edx
 3dd:	74 07                	je     3e6 <printint+0x56>
    buf[i++] = '-';
 3df:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3e4:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3e6:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3e9:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3f0:	8a 07                	mov    (%edi),%al
 3f2:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3f5:	50                   	push   %eax
 3f6:	6a 01                	push   $0x1
 3f8:	56                   	push   %esi
 3f9:	ff 75 c0             	push   -0x40(%ebp)
 3fc:	e8 0e ff ff ff       	call   30f <write>
  while(--i >= 0)
 401:	89 f8                	mov    %edi,%eax
 403:	4f                   	dec    %edi
 404:	83 c4 10             	add    $0x10,%esp
 407:	39 d8                	cmp    %ebx,%eax
 409:	75 e5                	jne    3f0 <printint+0x60>
}
 40b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40e:	5b                   	pop    %ebx
 40f:	5e                   	pop    %esi
 410:	5f                   	pop    %edi
 411:	5d                   	pop    %ebp
 412:	c3                   	ret
 413:	90                   	nop
    x = -xx;
 414:	f7 da                	neg    %edx
 416:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 419:	eb 98                	jmp    3b3 <printint+0x23>
 41b:	90                   	nop

0000041c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	57                   	push   %edi
 420:	56                   	push   %esi
 421:	53                   	push   %ebx
 422:	83 ec 2c             	sub    $0x2c,%esp
 425:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 428:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 42b:	8a 03                	mov    (%ebx),%al
 42d:	84 c0                	test   %al,%al
 42f:	74 2a                	je     45b <printf+0x3f>
 431:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 432:	8d 4d 10             	lea    0x10(%ebp),%ecx
 435:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 438:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 43b:	83 fa 25             	cmp    $0x25,%edx
 43e:	74 24                	je     464 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 440:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 443:	50                   	push   %eax
 444:	6a 01                	push   $0x1
 446:	8d 45 e7             	lea    -0x19(%ebp),%eax
 449:	50                   	push   %eax
 44a:	56                   	push   %esi
 44b:	e8 bf fe ff ff       	call   30f <write>
  for(i = 0; fmt[i]; i++){
 450:	43                   	inc    %ebx
 451:	8a 43 ff             	mov    -0x1(%ebx),%al
 454:	83 c4 10             	add    $0x10,%esp
 457:	84 c0                	test   %al,%al
 459:	75 dd                	jne    438 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 45b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45e:	5b                   	pop    %ebx
 45f:	5e                   	pop    %esi
 460:	5f                   	pop    %edi
 461:	5d                   	pop    %ebp
 462:	c3                   	ret
 463:	90                   	nop
  for(i = 0; fmt[i]; i++){
 464:	8a 13                	mov    (%ebx),%dl
 466:	84 d2                	test   %dl,%dl
 468:	74 f1                	je     45b <printf+0x3f>
    c = fmt[i] & 0xff;
 46a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 46d:	80 fa 25             	cmp    $0x25,%dl
 470:	0f 84 fe 00 00 00    	je     574 <printf+0x158>
 476:	83 e8 63             	sub    $0x63,%eax
 479:	83 f8 15             	cmp    $0x15,%eax
 47c:	77 0a                	ja     488 <printf+0x6c>
 47e:	ff 24 85 b0 07 00 00 	jmp    *0x7b0(,%eax,4)
 485:	8d 76 00             	lea    0x0(%esi),%esi
 488:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 48b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 48f:	50                   	push   %eax
 490:	6a 01                	push   $0x1
 492:	8d 7d e7             	lea    -0x19(%ebp),%edi
 495:	57                   	push   %edi
 496:	56                   	push   %esi
 497:	e8 73 fe ff ff       	call   30f <write>
        putc(fd, c);
 49c:	8a 55 d0             	mov    -0x30(%ebp),%dl
 49f:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4a2:	83 c4 0c             	add    $0xc,%esp
 4a5:	6a 01                	push   $0x1
 4a7:	57                   	push   %edi
 4a8:	56                   	push   %esi
 4a9:	e8 61 fe ff ff       	call   30f <write>
  for(i = 0; fmt[i]; i++){
 4ae:	83 c3 02             	add    $0x2,%ebx
 4b1:	8a 43 ff             	mov    -0x1(%ebx),%al
 4b4:	83 c4 10             	add    $0x10,%esp
 4b7:	84 c0                	test   %al,%al
 4b9:	0f 85 79 ff ff ff    	jne    438 <printf+0x1c>
}
 4bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c2:	5b                   	pop    %ebx
 4c3:	5e                   	pop    %esi
 4c4:	5f                   	pop    %edi
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret
 4c7:	90                   	nop
        printint(fd, *ap, 16, 0);
 4c8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4cb:	8b 17                	mov    (%edi),%edx
 4cd:	83 ec 0c             	sub    $0xc,%esp
 4d0:	6a 00                	push   $0x0
 4d2:	b9 10 00 00 00       	mov    $0x10,%ecx
 4d7:	89 f0                	mov    %esi,%eax
 4d9:	e8 b2 fe ff ff       	call   390 <printint>
        ap++;
 4de:	83 c7 04             	add    $0x4,%edi
 4e1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4e4:	eb c8                	jmp    4ae <printf+0x92>
 4e6:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4eb:	8b 01                	mov    (%ecx),%eax
        ap++;
 4ed:	83 c1 04             	add    $0x4,%ecx
 4f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4f3:	85 c0                	test   %eax,%eax
 4f5:	0f 84 89 00 00 00    	je     584 <printf+0x168>
        while(*s != 0){
 4fb:	8a 10                	mov    (%eax),%dl
 4fd:	84 d2                	test   %dl,%dl
 4ff:	74 29                	je     52a <printf+0x10e>
 501:	89 c7                	mov    %eax,%edi
 503:	88 d0                	mov    %dl,%al
 505:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 508:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 50b:	89 fb                	mov    %edi,%ebx
 50d:	89 cf                	mov    %ecx,%edi
 50f:	90                   	nop
          putc(fd, *s);
 510:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 513:	50                   	push   %eax
 514:	6a 01                	push   $0x1
 516:	57                   	push   %edi
 517:	56                   	push   %esi
 518:	e8 f2 fd ff ff       	call   30f <write>
          s++;
 51d:	43                   	inc    %ebx
        while(*s != 0){
 51e:	8a 03                	mov    (%ebx),%al
 520:	83 c4 10             	add    $0x10,%esp
 523:	84 c0                	test   %al,%al
 525:	75 e9                	jne    510 <printf+0xf4>
 527:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 52a:	83 c3 02             	add    $0x2,%ebx
 52d:	8a 43 ff             	mov    -0x1(%ebx),%al
 530:	84 c0                	test   %al,%al
 532:	0f 85 00 ff ff ff    	jne    438 <printf+0x1c>
 538:	e9 1e ff ff ff       	jmp    45b <printf+0x3f>
 53d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 540:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 543:	8b 17                	mov    (%edi),%edx
 545:	83 ec 0c             	sub    $0xc,%esp
 548:	6a 01                	push   $0x1
 54a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 54f:	eb 86                	jmp    4d7 <printf+0xbb>
 551:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 554:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 55c:	51                   	push   %ecx
 55d:	6a 01                	push   $0x1
 55f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 562:	57                   	push   %edi
 563:	56                   	push   %esi
 564:	e8 a6 fd ff ff       	call   30f <write>
        ap++;
 569:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 56d:	e9 3c ff ff ff       	jmp    4ae <printf+0x92>
 572:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 574:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 577:	52                   	push   %edx
 578:	6a 01                	push   $0x1
 57a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 57d:	e9 25 ff ff ff       	jmp    4a7 <printf+0x8b>
 582:	66 90                	xchg   %ax,%ax
          s = "(null)";
 584:	bf 89 07 00 00       	mov    $0x789,%edi
 589:	b0 28                	mov    $0x28,%al
 58b:	e9 75 ff ff ff       	jmp    505 <printf+0xe9>

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 599:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59c:	a1 1c 08 00 00       	mov    0x81c,%eax
 5a1:	8d 76 00             	lea    0x0(%esi),%esi
 5a4:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a6:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a8:	39 ca                	cmp    %ecx,%edx
 5aa:	73 2c                	jae    5d8 <free+0x48>
 5ac:	39 c1                	cmp    %eax,%ecx
 5ae:	72 04                	jb     5b4 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b0:	39 c2                	cmp    %eax,%edx
 5b2:	72 f0                	jb     5a4 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ba:	39 f8                	cmp    %edi,%eax
 5bc:	74 2c                	je     5ea <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5be:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5c1:	8b 42 04             	mov    0x4(%edx),%eax
 5c4:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5c7:	39 f1                	cmp    %esi,%ecx
 5c9:	74 36                	je     601 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5cb:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5cd:	89 15 1c 08 00 00    	mov    %edx,0x81c
}
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d8:	39 c2                	cmp    %eax,%edx
 5da:	72 c8                	jb     5a4 <free+0x14>
 5dc:	39 c1                	cmp    %eax,%ecx
 5de:	73 c4                	jae    5a4 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5e6:	39 f8                	cmp    %edi,%eax
 5e8:	75 d4                	jne    5be <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5ea:	03 70 04             	add    0x4(%eax),%esi
 5ed:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5f0:	8b 02                	mov    (%edx),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f7:	8b 42 04             	mov    0x4(%edx),%eax
 5fa:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5fd:	39 f1                	cmp    %esi,%ecx
 5ff:	75 ca                	jne    5cb <free+0x3b>
    p->s.size += bp->s.size;
 601:	03 43 fc             	add    -0x4(%ebx),%eax
 604:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 607:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 60a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 60c:	89 15 1c 08 00 00    	mov    %edx,0x81c
}
 612:	5b                   	pop    %ebx
 613:	5e                   	pop    %esi
 614:	5f                   	pop    %edi
 615:	5d                   	pop    %ebp
 616:	c3                   	ret
 617:	90                   	nop

00000618 <malloc>:
}


void*
malloc(uint nbytes)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	57                   	push   %edi
 61c:	56                   	push   %esi
 61d:	53                   	push   %ebx
 61e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	8d 78 07             	lea    0x7(%eax),%edi
 627:	c1 ef 03             	shr    $0x3,%edi
 62a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 62b:	8b 15 1c 08 00 00    	mov    0x81c,%edx
 631:	85 d2                	test   %edx,%edx
 633:	0f 84 93 00 00 00    	je     6cc <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 639:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 63b:	8b 48 04             	mov    0x4(%eax),%ecx
 63e:	39 f9                	cmp    %edi,%ecx
 640:	73 62                	jae    6a4 <malloc+0x8c>
  if(nu < 4096)
 642:	89 fb                	mov    %edi,%ebx
 644:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 64a:	72 78                	jb     6c4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 64c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 653:	eb 0e                	jmp    663 <malloc+0x4b>
 655:	8d 76 00             	lea    0x0(%esi),%esi
 658:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 65a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 65c:	8b 48 04             	mov    0x4(%eax),%ecx
 65f:	39 f9                	cmp    %edi,%ecx
 661:	73 41                	jae    6a4 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 663:	39 05 1c 08 00 00    	cmp    %eax,0x81c
 669:	75 ed                	jne    658 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 66b:	83 ec 0c             	sub    $0xc,%esp
 66e:	56                   	push   %esi
 66f:	e8 03 fd ff ff       	call   377 <sbrk>
  if(p == (char*)-1)
 674:	83 c4 10             	add    $0x10,%esp
 677:	83 f8 ff             	cmp    $0xffffffff,%eax
 67a:	74 1c                	je     698 <malloc+0x80>
  hp->s.size = nu;
 67c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 67f:	83 ec 0c             	sub    $0xc,%esp
 682:	83 c0 08             	add    $0x8,%eax
 685:	50                   	push   %eax
 686:	e8 05 ff ff ff       	call   590 <free>
  return freep;
 68b:	8b 15 1c 08 00 00    	mov    0x81c,%edx
      if((p = morecore(nunits)) == 0)
 691:	83 c4 10             	add    $0x10,%esp
 694:	85 d2                	test   %edx,%edx
 696:	75 c2                	jne    65a <malloc+0x42>
        return 0;
 698:	31 c0                	xor    %eax,%eax
  }
}
 69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret
 6a2:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 6a4:	39 cf                	cmp    %ecx,%edi
 6a6:	74 4c                	je     6f4 <malloc+0xdc>
        p->s.size -= nunits;
 6a8:	29 f9                	sub    %edi,%ecx
 6aa:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6ad:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6b0:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6b3:	89 15 1c 08 00 00    	mov    %edx,0x81c
      return (void*)(p + 1);
 6b9:	83 c0 08             	add    $0x8,%eax
}
 6bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bf:	5b                   	pop    %ebx
 6c0:	5e                   	pop    %esi
 6c1:	5f                   	pop    %edi
 6c2:	5d                   	pop    %ebp
 6c3:	c3                   	ret
  if(nu < 4096)
 6c4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c9:	eb 81                	jmp    64c <malloc+0x34>
 6cb:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6cc:	c7 05 1c 08 00 00 20 	movl   $0x820,0x81c
 6d3:	08 00 00 
 6d6:	c7 05 20 08 00 00 20 	movl   $0x820,0x820
 6dd:	08 00 00 
    base.s.size = 0;
 6e0:	c7 05 24 08 00 00 00 	movl   $0x0,0x824
 6e7:	00 00 00 
 6ea:	b8 20 08 00 00       	mov    $0x820,%eax
 6ef:	e9 4e ff ff ff       	jmp    642 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6f4:	8b 08                	mov    (%eax),%ecx
 6f6:	89 0a                	mov    %ecx,(%edx)
 6f8:	eb b9                	jmp    6b3 <malloc+0x9b>
