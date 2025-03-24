
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	be 07 07 00 00       	mov    $0x707,%esi
  1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  21:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  29:	68 e4 06 00 00       	push   $0x6e4
  2e:	6a 01                	push   $0x1
  30:	e8 cf 03 00 00       	call   404 <printf>
  memset(data, 'a', sizeof(data));
  35:	83 c4 0c             	add    $0xc,%esp
  38:	68 00 02 00 00       	push   $0x200
  3d:	6a 61                	push   $0x61
  3f:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  45:	56                   	push   %esi
  46:	e8 4d 01 00 00       	call   198 <memset>
  4b:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  4e:	31 ff                	xor    %edi,%edi
    if(fork() > 0)
  50:	e8 72 02 00 00       	call   2c7 <fork>
  55:	85 c0                	test   %eax,%eax
  57:	0f 8f a5 00 00 00    	jg     102 <main+0x102>
  for(i = 0; i < 4; i++)
  5d:	47                   	inc    %edi
  5e:	83 ff 04             	cmp    $0x4,%edi
  61:	75 ed                	jne    50 <main+0x50>
  63:	b3 04                	mov    $0x4,%bl
      break;

  printf(1, "write %d\n", i);
  65:	50                   	push   %eax
  66:	57                   	push   %edi
  67:	68 f7 06 00 00       	push   $0x6f7
  6c:	6a 01                	push   $0x1
  6e:	e8 91 03 00 00       	call   404 <printf>

  path[8] += i;
  73:	00 9d e6 fd ff ff    	add    %bl,-0x21a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  79:	58                   	pop    %eax
  7a:	5a                   	pop    %edx
  7b:	68 02 02 00 00       	push   $0x202
  80:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  86:	50                   	push   %eax
  87:	e8 83 02 00 00       	call   30f <open>
  8c:	89 c7                	mov    %eax,%edi
  8e:	83 c4 10             	add    $0x10,%esp
  91:	bb 14 00 00 00       	mov    $0x14,%ebx
  96:	66 90                	xchg   %ax,%ax
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  98:	50                   	push   %eax
  99:	68 00 02 00 00       	push   $0x200
  9e:	56                   	push   %esi
  9f:	57                   	push   %edi
  a0:	e8 4a 02 00 00       	call   2ef <write>
  for(i = 0; i < 20; i++)
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	4b                   	dec    %ebx
  a9:	75 ed                	jne    98 <main+0x98>
  close(fd);
  ab:	83 ec 0c             	sub    $0xc,%esp
  ae:	57                   	push   %edi
  af:	e8 43 02 00 00       	call   2f7 <close>

  printf(1, "read\n");
  b4:	5a                   	pop    %edx
  b5:	59                   	pop    %ecx
  b6:	68 01 07 00 00       	push   $0x701
  bb:	6a 01                	push   $0x1
  bd:	e8 42 03 00 00       	call   404 <printf>

  fd = open(path, O_RDONLY);
  c2:	5b                   	pop    %ebx
  c3:	5f                   	pop    %edi
  c4:	6a 00                	push   $0x0
  c6:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  cc:	50                   	push   %eax
  cd:	e8 3d 02 00 00       	call   30f <open>
  d2:	89 c7                	mov    %eax,%edi
  d4:	83 c4 10             	add    $0x10,%esp
  d7:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  dc:	50                   	push   %eax
  dd:	68 00 02 00 00       	push   $0x200
  e2:	56                   	push   %esi
  e3:	57                   	push   %edi
  e4:	e8 fe 01 00 00       	call   2e7 <read>
  for (i = 0; i < 20; i++)
  e9:	83 c4 10             	add    $0x10,%esp
  ec:	4b                   	dec    %ebx
  ed:	75 ed                	jne    dc <main+0xdc>
  close(fd);
  ef:	83 ec 0c             	sub    $0xc,%esp
  f2:	57                   	push   %edi
  f3:	e8 ff 01 00 00       	call   2f7 <close>

  wait();
  f8:	e8 da 01 00 00       	call   2d7 <wait>

  exit();
  fd:	e8 cd 01 00 00       	call   2cf <exit>
  path[8] += i;
 102:	89 fb                	mov    %edi,%ebx
 104:	e9 5c ff ff ff       	jmp    65 <main+0x65>
 109:	66 90                	xchg   %ax,%ax
 10b:	90                   	nop

0000010c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	53                   	push   %ebx
 110:	8b 4d 08             	mov    0x8(%ebp),%ecx
 113:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	31 c0                	xor    %eax,%eax
 118:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 11b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 11e:	40                   	inc    %eax
 11f:	84 d2                	test   %dl,%dl
 121:	75 f5                	jne    118 <strcpy+0xc>
    ;
  return os;
}
 123:	89 c8                	mov    %ecx,%eax
 125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 128:	c9                   	leave
 129:	c3                   	ret
 12a:	66 90                	xchg   %ax,%ax

0000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	53                   	push   %ebx
 130:	8b 55 08             	mov    0x8(%ebp),%edx
 133:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 136:	0f b6 02             	movzbl (%edx),%eax
 139:	84 c0                	test   %al,%al
 13b:	75 10                	jne    14d <strcmp+0x21>
 13d:	eb 2a                	jmp    169 <strcmp+0x3d>
 13f:	90                   	nop
    p++, q++;
 140:	42                   	inc    %edx
 141:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 144:	0f b6 02             	movzbl (%edx),%eax
 147:	84 c0                	test   %al,%al
 149:	74 11                	je     15c <strcmp+0x30>
 14b:	89 cb                	mov    %ecx,%ebx
 14d:	0f b6 0b             	movzbl (%ebx),%ecx
 150:	38 c1                	cmp    %al,%cl
 152:	74 ec                	je     140 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 154:	29 c8                	sub    %ecx,%eax
}
 156:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 159:	c9                   	leave
 15a:	c3                   	ret
 15b:	90                   	nop
  return (uchar)*p - (uchar)*q;
 15c:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 160:	31 c0                	xor    %eax,%eax
 162:	29 c8                	sub    %ecx,%eax
}
 164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 167:	c9                   	leave
 168:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 169:	0f b6 0b             	movzbl (%ebx),%ecx
 16c:	31 c0                	xor    %eax,%eax
 16e:	eb e4                	jmp    154 <strcmp+0x28>

00000170 <strlen>:

uint
strlen(const char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 3a 00             	cmpb   $0x0,(%edx)
 179:	74 15                	je     190 <strlen+0x20>
 17b:	31 c0                	xor    %eax,%eax
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	40                   	inc    %eax
 181:	89 c1                	mov    %eax,%ecx
 183:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 187:	75 f7                	jne    180 <strlen+0x10>
    ;
  return n;
}
 189:	89 c8                	mov    %ecx,%eax
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret
 18d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 190:	31 c9                	xor    %ecx,%ecx
}
 192:	89 c8                	mov    %ecx,%eax
 194:	5d                   	pop    %ebp
 195:	c3                   	ret
 196:	66 90                	xchg   %ax,%ax

00000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19c:	8b 7d 08             	mov    0x8(%ebp),%edi
 19f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	fc                   	cld
 1a6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1ae:	c9                   	leave
 1af:	c3                   	ret

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	75 0c                	jne    1cb <strchr+0x1b>
 1bf:	eb 13                	jmp    1d4 <strchr+0x24>
 1c1:	8d 76 00             	lea    0x0(%esi),%esi
 1c4:	40                   	inc    %eax
 1c5:	8a 10                	mov    (%eax),%dl
 1c7:	84 d2                	test   %dl,%dl
 1c9:	74 09                	je     1d4 <strchr+0x24>
    if(*s == c)
 1cb:	38 d1                	cmp    %dl,%cl
 1cd:	75 f5                	jne    1c4 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret
 1d1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1d4:	31 c0                	xor    %eax,%eax
}
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret

000001d8 <gets>:

char*
gets(char *buf, int max)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	57                   	push   %edi
 1dc:	56                   	push   %esi
 1dd:	53                   	push   %ebx
 1de:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e1:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1e3:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 1e6:	eb 24                	jmp    20c <gets+0x34>
    cc = read(0, &c, 1);
 1e8:	50                   	push   %eax
 1e9:	6a 01                	push   $0x1
 1eb:	56                   	push   %esi
 1ec:	6a 00                	push   $0x0
 1ee:	e8 f4 00 00 00       	call   2e7 <read>
    if(cc < 1)
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	85 c0                	test   %eax,%eax
 1f8:	7e 1a                	jle    214 <gets+0x3c>
      break;
    buf[i++] = c;
 1fa:	8a 45 e7             	mov    -0x19(%ebp),%al
 1fd:	8b 55 08             	mov    0x8(%ebp),%edx
 200:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 204:	3c 0a                	cmp    $0xa,%al
 206:	74 0e                	je     216 <gets+0x3e>
 208:	3c 0d                	cmp    $0xd,%al
 20a:	74 0a                	je     216 <gets+0x3e>
  for(i=0; i+1 < max; ){
 20c:	89 df                	mov    %ebx,%edi
 20e:	43                   	inc    %ebx
 20f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 212:	7c d4                	jl     1e8 <gets+0x10>
 214:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 21d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 220:	5b                   	pop    %ebx
 221:	5e                   	pop    %esi
 222:	5f                   	pop    %edi
 223:	5d                   	pop    %ebp
 224:	c3                   	ret
 225:	8d 76 00             	lea    0x0(%esi),%esi

00000228 <stat>:

int
stat(const char *n, struct stat *st)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	56                   	push   %esi
 22c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22d:	83 ec 08             	sub    $0x8,%esp
 230:	6a 00                	push   $0x0
 232:	ff 75 08             	push   0x8(%ebp)
 235:	e8 d5 00 00 00       	call   30f <open>
  if(fd < 0)
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	85 c0                	test   %eax,%eax
 23f:	78 27                	js     268 <stat+0x40>
 241:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 243:	83 ec 08             	sub    $0x8,%esp
 246:	ff 75 0c             	push   0xc(%ebp)
 249:	50                   	push   %eax
 24a:	e8 d8 00 00 00       	call   327 <fstat>
 24f:	89 c6                	mov    %eax,%esi
  close(fd);
 251:	89 1c 24             	mov    %ebx,(%esp)
 254:	e8 9e 00 00 00       	call   2f7 <close>
  return r;
 259:	83 c4 10             	add    $0x10,%esp
}
 25c:	89 f0                	mov    %esi,%eax
 25e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 261:	5b                   	pop    %ebx
 262:	5e                   	pop    %esi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret
 265:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 268:	be ff ff ff ff       	mov    $0xffffffff,%esi
 26d:	eb ed                	jmp    25c <stat+0x34>
 26f:	90                   	nop

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 01             	movsbl (%ecx),%eax
 27a:	8d 50 d0             	lea    -0x30(%eax),%edx
 27d:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 280:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 285:	77 16                	ja     29d <atoi+0x2d>
 287:	90                   	nop
    n = n*10 + *s++ - '0';
 288:	41                   	inc    %ecx
 289:	8d 14 92             	lea    (%edx,%edx,4),%edx
 28c:	01 d2                	add    %edx,%edx
 28e:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 292:	0f be 01             	movsbl (%ecx),%eax
 295:	8d 58 d0             	lea    -0x30(%eax),%ebx
 298:	80 fb 09             	cmp    $0x9,%bl
 29b:	76 eb                	jbe    288 <atoi+0x18>
  return n;
}
 29d:	89 d0                	mov    %edx,%eax
 29f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a2:	c9                   	leave
 2a3:	c3                   	ret

000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	57                   	push   %edi
 2a8:	56                   	push   %esi
 2a9:	8b 55 08             	mov    0x8(%ebp),%edx
 2ac:	8b 75 0c             	mov    0xc(%ebp),%esi
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b2:	85 c0                	test   %eax,%eax
 2b4:	7e 0b                	jle    2c1 <memmove+0x1d>
 2b6:	01 d0                	add    %edx,%eax
  dst = vdst;
 2b8:	89 d7                	mov    %edx,%edi
 2ba:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2bc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2bd:	39 f8                	cmp    %edi,%eax
 2bf:	75 fb                	jne    2bc <memmove+0x18>
  return vdst;
}
 2c1:	89 d0                	mov    %edx,%eax
 2c3:	5e                   	pop    %esi
 2c4:	5f                   	pop    %edi
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <pipe>:
SYSCALL(pipe)
 2df:	b8 04 00 00 00       	mov    $0x4,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <read>:
SYSCALL(read)
 2e7:	b8 05 00 00 00       	mov    $0x5,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <write>:
SYSCALL(write)
 2ef:	b8 10 00 00 00       	mov    $0x10,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <close>:
SYSCALL(close)
 2f7:	b8 15 00 00 00       	mov    $0x15,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <kill>:
SYSCALL(kill)
 2ff:	b8 06 00 00 00       	mov    $0x6,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <exec>:
SYSCALL(exec)
 307:	b8 07 00 00 00       	mov    $0x7,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <open>:
SYSCALL(open)
 30f:	b8 0f 00 00 00       	mov    $0xf,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <mknod>:
SYSCALL(mknod)
 317:	b8 11 00 00 00       	mov    $0x11,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <unlink>:
SYSCALL(unlink)
 31f:	b8 12 00 00 00       	mov    $0x12,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <fstat>:
SYSCALL(fstat)
 327:	b8 08 00 00 00       	mov    $0x8,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <link>:
SYSCALL(link)
 32f:	b8 13 00 00 00       	mov    $0x13,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <mkdir>:
SYSCALL(mkdir)
 337:	b8 14 00 00 00       	mov    $0x14,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <chdir>:
SYSCALL(chdir)
 33f:	b8 09 00 00 00       	mov    $0x9,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <dup>:
SYSCALL(dup)
 347:	b8 0a 00 00 00       	mov    $0xa,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <getpid>:
SYSCALL(getpid)
 34f:	b8 0b 00 00 00       	mov    $0xb,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret

00000357 <sbrk>:
SYSCALL(sbrk)
 357:	b8 0c 00 00 00       	mov    $0xc,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <sleep>:
SYSCALL(sleep)
 35f:	b8 0d 00 00 00       	mov    $0xd,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <uptime>:
SYSCALL(uptime)
 367:	b8 0e 00 00 00       	mov    $0xe,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <signal>:
SYSCALL(signal)
 36f:	b8 16 00 00 00       	mov    $0x16,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret
 377:	90                   	nop

00000378 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	57                   	push   %edi
 37c:	56                   	push   %esi
 37d:	53                   	push   %ebx
 37e:	83 ec 3c             	sub    $0x3c,%esp
 381:	89 45 c0             	mov    %eax,-0x40(%ebp)
 384:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 386:	8b 4d 08             	mov    0x8(%ebp),%ecx
 389:	85 c9                	test   %ecx,%ecx
 38b:	74 04                	je     391 <printint+0x19>
 38d:	85 d2                	test   %edx,%edx
 38f:	78 6b                	js     3fc <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 391:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 394:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 39b:	31 c9                	xor    %ecx,%ecx
 39d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3a3:	31 d2                	xor    %edx,%edx
 3a5:	f7 f3                	div    %ebx
 3a7:	89 cf                	mov    %ecx,%edi
 3a9:	8d 49 01             	lea    0x1(%ecx),%ecx
 3ac:	8a 92 70 07 00 00    	mov    0x770(%edx),%dl
 3b2:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3b6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3bc:	39 da                	cmp    %ebx,%edx
 3be:	73 e0                	jae    3a0 <printint+0x28>
  if(neg)
 3c0:	8b 55 08             	mov    0x8(%ebp),%edx
 3c3:	85 d2                	test   %edx,%edx
 3c5:	74 07                	je     3ce <printint+0x56>
    buf[i++] = '-';
 3c7:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3cc:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 3ce:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3d1:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 3d5:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 3d8:	8a 07                	mov    (%edi),%al
 3da:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3dd:	50                   	push   %eax
 3de:	6a 01                	push   $0x1
 3e0:	56                   	push   %esi
 3e1:	ff 75 c0             	push   -0x40(%ebp)
 3e4:	e8 06 ff ff ff       	call   2ef <write>
  while(--i >= 0)
 3e9:	89 f8                	mov    %edi,%eax
 3eb:	4f                   	dec    %edi
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	39 d8                	cmp    %ebx,%eax
 3f1:	75 e5                	jne    3d8 <printint+0x60>
}
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret
 3fb:	90                   	nop
    x = -xx;
 3fc:	f7 da                	neg    %edx
 3fe:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 401:	eb 98                	jmp    39b <printint+0x23>
 403:	90                   	nop

00000404 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	56                   	push   %esi
 409:	53                   	push   %ebx
 40a:	83 ec 2c             	sub    $0x2c,%esp
 40d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 413:	8a 03                	mov    (%ebx),%al
 415:	84 c0                	test   %al,%al
 417:	74 2a                	je     443 <printf+0x3f>
 419:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 41a:	8d 4d 10             	lea    0x10(%ebp),%ecx
 41d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 420:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 423:	83 fa 25             	cmp    $0x25,%edx
 426:	74 24                	je     44c <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 428:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 42b:	50                   	push   %eax
 42c:	6a 01                	push   $0x1
 42e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 431:	50                   	push   %eax
 432:	56                   	push   %esi
 433:	e8 b7 fe ff ff       	call   2ef <write>
  for(i = 0; fmt[i]; i++){
 438:	43                   	inc    %ebx
 439:	8a 43 ff             	mov    -0x1(%ebx),%al
 43c:	83 c4 10             	add    $0x10,%esp
 43f:	84 c0                	test   %al,%al
 441:	75 dd                	jne    420 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 443:	8d 65 f4             	lea    -0xc(%ebp),%esp
 446:	5b                   	pop    %ebx
 447:	5e                   	pop    %esi
 448:	5f                   	pop    %edi
 449:	5d                   	pop    %ebp
 44a:	c3                   	ret
 44b:	90                   	nop
  for(i = 0; fmt[i]; i++){
 44c:	8a 13                	mov    (%ebx),%dl
 44e:	84 d2                	test   %dl,%dl
 450:	74 f1                	je     443 <printf+0x3f>
    c = fmt[i] & 0xff;
 452:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 455:	80 fa 25             	cmp    $0x25,%dl
 458:	0f 84 fe 00 00 00    	je     55c <printf+0x158>
 45e:	83 e8 63             	sub    $0x63,%eax
 461:	83 f8 15             	cmp    $0x15,%eax
 464:	77 0a                	ja     470 <printf+0x6c>
 466:	ff 24 85 18 07 00 00 	jmp    *0x718(,%eax,4)
 46d:	8d 76 00             	lea    0x0(%esi),%esi
 470:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 473:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 477:	50                   	push   %eax
 478:	6a 01                	push   $0x1
 47a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 47d:	57                   	push   %edi
 47e:	56                   	push   %esi
 47f:	e8 6b fe ff ff       	call   2ef <write>
        putc(fd, c);
 484:	8a 55 d0             	mov    -0x30(%ebp),%dl
 487:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 48a:	83 c4 0c             	add    $0xc,%esp
 48d:	6a 01                	push   $0x1
 48f:	57                   	push   %edi
 490:	56                   	push   %esi
 491:	e8 59 fe ff ff       	call   2ef <write>
  for(i = 0; fmt[i]; i++){
 496:	83 c3 02             	add    $0x2,%ebx
 499:	8a 43 ff             	mov    -0x1(%ebx),%al
 49c:	83 c4 10             	add    $0x10,%esp
 49f:	84 c0                	test   %al,%al
 4a1:	0f 85 79 ff ff ff    	jne    420 <printf+0x1c>
}
 4a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4aa:	5b                   	pop    %ebx
 4ab:	5e                   	pop    %esi
 4ac:	5f                   	pop    %edi
 4ad:	5d                   	pop    %ebp
 4ae:	c3                   	ret
 4af:	90                   	nop
        printint(fd, *ap, 16, 0);
 4b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4b3:	8b 17                	mov    (%edi),%edx
 4b5:	83 ec 0c             	sub    $0xc,%esp
 4b8:	6a 00                	push   $0x0
 4ba:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bf:	89 f0                	mov    %esi,%eax
 4c1:	e8 b2 fe ff ff       	call   378 <printint>
        ap++;
 4c6:	83 c7 04             	add    $0x4,%edi
 4c9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4cc:	eb c8                	jmp    496 <printf+0x92>
 4ce:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 4d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4d3:	8b 01                	mov    (%ecx),%eax
        ap++;
 4d5:	83 c1 04             	add    $0x4,%ecx
 4d8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4db:	85 c0                	test   %eax,%eax
 4dd:	0f 84 89 00 00 00    	je     56c <printf+0x168>
        while(*s != 0){
 4e3:	8a 10                	mov    (%eax),%dl
 4e5:	84 d2                	test   %dl,%dl
 4e7:	74 29                	je     512 <printf+0x10e>
 4e9:	89 c7                	mov    %eax,%edi
 4eb:	88 d0                	mov    %dl,%al
 4ed:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 4f0:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4f3:	89 fb                	mov    %edi,%ebx
 4f5:	89 cf                	mov    %ecx,%edi
 4f7:	90                   	nop
          putc(fd, *s);
 4f8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4fb:	50                   	push   %eax
 4fc:	6a 01                	push   $0x1
 4fe:	57                   	push   %edi
 4ff:	56                   	push   %esi
 500:	e8 ea fd ff ff       	call   2ef <write>
          s++;
 505:	43                   	inc    %ebx
        while(*s != 0){
 506:	8a 03                	mov    (%ebx),%al
 508:	83 c4 10             	add    $0x10,%esp
 50b:	84 c0                	test   %al,%al
 50d:	75 e9                	jne    4f8 <printf+0xf4>
 50f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 512:	83 c3 02             	add    $0x2,%ebx
 515:	8a 43 ff             	mov    -0x1(%ebx),%al
 518:	84 c0                	test   %al,%al
 51a:	0f 85 00 ff ff ff    	jne    420 <printf+0x1c>
 520:	e9 1e ff ff ff       	jmp    443 <printf+0x3f>
 525:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 528:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 52b:	8b 17                	mov    (%edi),%edx
 52d:	83 ec 0c             	sub    $0xc,%esp
 530:	6a 01                	push   $0x1
 532:	b9 0a 00 00 00       	mov    $0xa,%ecx
 537:	eb 86                	jmp    4bf <printf+0xbb>
 539:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 53c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 53f:	8b 00                	mov    (%eax),%eax
 541:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 544:	51                   	push   %ecx
 545:	6a 01                	push   $0x1
 547:	8d 7d e7             	lea    -0x19(%ebp),%edi
 54a:	57                   	push   %edi
 54b:	56                   	push   %esi
 54c:	e8 9e fd ff ff       	call   2ef <write>
        ap++;
 551:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 555:	e9 3c ff ff ff       	jmp    496 <printf+0x92>
 55a:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 55c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 55f:	52                   	push   %edx
 560:	6a 01                	push   $0x1
 562:	8d 7d e7             	lea    -0x19(%ebp),%edi
 565:	e9 25 ff ff ff       	jmp    48f <printf+0x8b>
 56a:	66 90                	xchg   %ax,%ax
          s = "(null)";
 56c:	bf 11 07 00 00       	mov    $0x711,%edi
 571:	b0 28                	mov    $0x28,%al
 573:	e9 75 ff ff ff       	jmp    4ed <printf+0xe9>

00000578 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	57                   	push   %edi
 57c:	56                   	push   %esi
 57d:	53                   	push   %ebx
 57e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 581:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 584:	a1 84 07 00 00       	mov    0x784,%eax
 589:	8d 76 00             	lea    0x0(%esi),%esi
 58c:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58e:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 590:	39 ca                	cmp    %ecx,%edx
 592:	73 2c                	jae    5c0 <free+0x48>
 594:	39 c1                	cmp    %eax,%ecx
 596:	72 04                	jb     59c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 598:	39 c2                	cmp    %eax,%edx
 59a:	72 f0                	jb     58c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 59c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a2:	39 f8                	cmp    %edi,%eax
 5a4:	74 2c                	je     5d2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5a6:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5a9:	8b 42 04             	mov    0x4(%edx),%eax
 5ac:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5af:	39 f1                	cmp    %esi,%ecx
 5b1:	74 36                	je     5e9 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5b3:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5b5:	89 15 84 07 00 00    	mov    %edx,0x784
}
 5bb:	5b                   	pop    %ebx
 5bc:	5e                   	pop    %esi
 5bd:	5f                   	pop    %edi
 5be:	5d                   	pop    %ebp
 5bf:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c0:	39 c2                	cmp    %eax,%edx
 5c2:	72 c8                	jb     58c <free+0x14>
 5c4:	39 c1                	cmp    %eax,%ecx
 5c6:	73 c4                	jae    58c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ce:	39 f8                	cmp    %edi,%eax
 5d0:	75 d4                	jne    5a6 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5d2:	03 70 04             	add    0x4(%eax),%esi
 5d5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d8:	8b 02                	mov    (%edx),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5df:	8b 42 04             	mov    0x4(%edx),%eax
 5e2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5e5:	39 f1                	cmp    %esi,%ecx
 5e7:	75 ca                	jne    5b3 <free+0x3b>
    p->s.size += bp->s.size;
 5e9:	03 43 fc             	add    -0x4(%ebx),%eax
 5ec:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5ef:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5f2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5f4:	89 15 84 07 00 00    	mov    %edx,0x784
}
 5fa:	5b                   	pop    %ebx
 5fb:	5e                   	pop    %esi
 5fc:	5f                   	pop    %edi
 5fd:	5d                   	pop    %ebp
 5fe:	c3                   	ret
 5ff:	90                   	nop

00000600 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 609:	8b 45 08             	mov    0x8(%ebp),%eax
 60c:	8d 78 07             	lea    0x7(%eax),%edi
 60f:	c1 ef 03             	shr    $0x3,%edi
 612:	47                   	inc    %edi
  if((prevp = freep) == 0){
 613:	8b 15 84 07 00 00    	mov    0x784,%edx
 619:	85 d2                	test   %edx,%edx
 61b:	0f 84 93 00 00 00    	je     6b4 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 621:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 623:	8b 48 04             	mov    0x4(%eax),%ecx
 626:	39 f9                	cmp    %edi,%ecx
 628:	73 62                	jae    68c <malloc+0x8c>
  if(nu < 4096)
 62a:	89 fb                	mov    %edi,%ebx
 62c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 632:	72 78                	jb     6ac <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 634:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 63b:	eb 0e                	jmp    64b <malloc+0x4b>
 63d:	8d 76 00             	lea    0x0(%esi),%esi
 640:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 642:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 644:	8b 48 04             	mov    0x4(%eax),%ecx
 647:	39 f9                	cmp    %edi,%ecx
 649:	73 41                	jae    68c <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 64b:	39 05 84 07 00 00    	cmp    %eax,0x784
 651:	75 ed                	jne    640 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	56                   	push   %esi
 657:	e8 fb fc ff ff       	call   357 <sbrk>
  if(p == (char*)-1)
 65c:	83 c4 10             	add    $0x10,%esp
 65f:	83 f8 ff             	cmp    $0xffffffff,%eax
 662:	74 1c                	je     680 <malloc+0x80>
  hp->s.size = nu;
 664:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 667:	83 ec 0c             	sub    $0xc,%esp
 66a:	83 c0 08             	add    $0x8,%eax
 66d:	50                   	push   %eax
 66e:	e8 05 ff ff ff       	call   578 <free>
  return freep;
 673:	8b 15 84 07 00 00    	mov    0x784,%edx
      if((p = morecore(nunits)) == 0)
 679:	83 c4 10             	add    $0x10,%esp
 67c:	85 d2                	test   %edx,%edx
 67e:	75 c2                	jne    642 <malloc+0x42>
        return 0;
 680:	31 c0                	xor    %eax,%eax
  }
}
 682:	8d 65 f4             	lea    -0xc(%ebp),%esp
 685:	5b                   	pop    %ebx
 686:	5e                   	pop    %esi
 687:	5f                   	pop    %edi
 688:	5d                   	pop    %ebp
 689:	c3                   	ret
 68a:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 68c:	39 cf                	cmp    %ecx,%edi
 68e:	74 4c                	je     6dc <malloc+0xdc>
        p->s.size -= nunits;
 690:	29 f9                	sub    %edi,%ecx
 692:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 695:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 698:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 69b:	89 15 84 07 00 00    	mov    %edx,0x784
      return (void*)(p + 1);
 6a1:	83 c0 08             	add    $0x8,%eax
}
 6a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a7:	5b                   	pop    %ebx
 6a8:	5e                   	pop    %esi
 6a9:	5f                   	pop    %edi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret
  if(nu < 4096)
 6ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b1:	eb 81                	jmp    634 <malloc+0x34>
 6b3:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6b4:	c7 05 84 07 00 00 88 	movl   $0x788,0x784
 6bb:	07 00 00 
 6be:	c7 05 88 07 00 00 88 	movl   $0x788,0x788
 6c5:	07 00 00 
    base.s.size = 0;
 6c8:	c7 05 8c 07 00 00 00 	movl   $0x0,0x78c
 6cf:	00 00 00 
 6d2:	b8 88 07 00 00       	mov    $0x788,%eax
 6d7:	e9 4e ff ff ff       	jmp    62a <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 6dc:	8b 08                	mov    (%eax),%ecx
 6de:	89 0a                	mov    %ecx,(%edx)
 6e0:	eb b9                	jmp    69b <malloc+0x9b>
