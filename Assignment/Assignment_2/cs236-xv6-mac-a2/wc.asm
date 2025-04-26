
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 71 04             	mov    0x4(%ecx),%esi
  int fd, i;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 51                	jle    70 <main+0x70>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  1f:	bf 01 00 00 00       	mov    $0x1,%edi
    if((fd = open(argv[i], 0)) < 0){
  24:	83 ec 08             	sub    $0x8,%esp
  27:	6a 00                	push   $0x0
  29:	ff 34 be             	push   (%esi,%edi,4)
  2c:	e8 16 03 00 00       	call   347 <open>
  31:	89 c3                	mov    %eax,%ebx
      printf(1, "wc: cannot open %s\n", argv[i]);
  33:	8b 04 be             	mov    (%esi,%edi,4),%eax
    if((fd = open(argv[i], 0)) < 0){
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 db                	test   %ebx,%ebx
  3b:	78 20                	js     5d <main+0x5d>
      exit();
    }
    wc(fd, argv[i]);
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	50                   	push   %eax
  41:	53                   	push   %ebx
  42:	e8 3d 00 00 00       	call   84 <wc>
    close(fd);
  47:	89 1c 24             	mov    %ebx,(%esp)
  4a:	e8 e0 02 00 00       	call   32f <close>
  for(i = 1; i < argc; i++){
  4f:	47                   	inc    %edi
  50:	83 c4 10             	add    $0x10,%esp
  53:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  56:	75 cc                	jne    24 <main+0x24>
  }
  exit();
  58:	e8 aa 02 00 00       	call   307 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
  5d:	52                   	push   %edx
  5e:	50                   	push   %eax
  5f:	68 4f 07 00 00       	push   $0x74f
  64:	6a 01                	push   $0x1
  66:	e8 e1 03 00 00       	call   44c <printf>
      exit();
  6b:	e8 97 02 00 00       	call   307 <exit>
    wc(0, "");
  70:	51                   	push   %ecx
  71:	51                   	push   %ecx
  72:	68 41 07 00 00       	push   $0x741
  77:	6a 00                	push   $0x0
  79:	e8 06 00 00 00       	call   84 <wc>
    exit();
  7e:	e8 84 02 00 00       	call   307 <exit>
  83:	90                   	nop

00000084 <wc>:
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	56                   	push   %esi
  89:	53                   	push   %ebx
  8a:	83 ec 1c             	sub    $0x1c,%esp
  inword = 0;
  8d:	31 db                	xor    %ebx,%ebx
  l = w = c = 0;
  8f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  96:	31 c9                	xor    %ecx,%ecx
  98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  9f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  a2:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf, sizeof(buf))) > 0){
  a4:	52                   	push   %edx
  a5:	68 00 02 00 00       	push   $0x200
  aa:	68 e0 07 00 00       	push   $0x7e0
  af:	ff 75 08             	push   0x8(%ebp)
  b2:	e8 68 02 00 00       	call   31f <read>
  b7:	89 c7                	mov    %eax,%edi
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	85 c0                	test   %eax,%eax
  be:	7e 48                	jle    108 <wc+0x84>
    for(i=0; i<n; i++){
  c0:	31 f6                	xor    %esi,%esi
  c2:	eb 07                	jmp    cb <wc+0x47>
        inword = 0;
  c4:	31 db                	xor    %ebx,%ebx
    for(i=0; i<n; i++){
  c6:	46                   	inc    %esi
  c7:	39 f7                	cmp    %esi,%edi
  c9:	74 35                	je     100 <wc+0x7c>
      if(buf[i] == '\n')
  cb:	0f be 86 e0 07 00 00 	movsbl 0x7e0(%esi),%eax
  d2:	3c 0a                	cmp    $0xa,%al
  d4:	75 03                	jne    d9 <wc+0x55>
        l++;
  d6:	ff 45 e4             	incl   -0x1c(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  d9:	83 ec 08             	sub    $0x8,%esp
  dc:	50                   	push   %eax
  dd:	68 2c 07 00 00       	push   $0x72c
  e2:	e8 01 01 00 00       	call   1e8 <strchr>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	85 c0                	test   %eax,%eax
  ec:	75 d6                	jne    c4 <wc+0x40>
      else if(!inword){
  ee:	85 db                	test   %ebx,%ebx
  f0:	75 d4                	jne    c6 <wc+0x42>
        w++;
  f2:	ff 45 e0             	incl   -0x20(%ebp)
        inword = 1;
  f5:	bb 01 00 00 00       	mov    $0x1,%ebx
    for(i=0; i<n; i++){
  fa:	46                   	inc    %esi
  fb:	39 f7                	cmp    %esi,%edi
  fd:	75 cc                	jne    cb <wc+0x47>
  ff:	90                   	nop
 100:	01 7d dc             	add    %edi,-0x24(%ebp)
 103:	eb 9f                	jmp    a4 <wc+0x20>
 105:	8d 76 00             	lea    0x0(%esi),%esi
  if(n < 0){
 108:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 10b:	75 24                	jne    131 <wc+0xad>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 10d:	83 ec 08             	sub    $0x8,%esp
 110:	ff 75 0c             	push   0xc(%ebp)
 113:	ff 75 dc             	push   -0x24(%ebp)
 116:	51                   	push   %ecx
 117:	ff 75 e4             	push   -0x1c(%ebp)
 11a:	68 42 07 00 00       	push   $0x742
 11f:	6a 01                	push   $0x1
 121:	e8 26 03 00 00       	call   44c <printf>
}
 126:	83 c4 20             	add    $0x20,%esp
 129:	8d 65 f4             	lea    -0xc(%ebp),%esp
 12c:	5b                   	pop    %ebx
 12d:	5e                   	pop    %esi
 12e:	5f                   	pop    %edi
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret
    printf(1, "wc: read error\n");
 131:	50                   	push   %eax
 132:	50                   	push   %eax
 133:	68 32 07 00 00       	push   $0x732
 138:	6a 01                	push   $0x1
 13a:	e8 0d 03 00 00       	call   44c <printf>
    exit();
 13f:	e8 c3 01 00 00       	call   307 <exit>

00000144 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	53                   	push   %ebx
 148:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14e:	31 c0                	xor    %eax,%eax
 150:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 153:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 156:	40                   	inc    %eax
 157:	84 d2                	test   %dl,%dl
 159:	75 f5                	jne    150 <strcpy+0xc>
    ;
  return os;
}
 15b:	89 c8                	mov    %ecx,%eax
 15d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 160:	c9                   	leave
 161:	c3                   	ret
 162:	66 90                	xchg   %ax,%ax

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	53                   	push   %ebx
 168:	8b 55 08             	mov    0x8(%ebp),%edx
 16b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 16e:	0f b6 02             	movzbl (%edx),%eax
 171:	84 c0                	test   %al,%al
 173:	75 10                	jne    185 <strcmp+0x21>
 175:	eb 2a                	jmp    1a1 <strcmp+0x3d>
 177:	90                   	nop
    p++, q++;
 178:	42                   	inc    %edx
 179:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 17c:	0f b6 02             	movzbl (%edx),%eax
 17f:	84 c0                	test   %al,%al
 181:	74 11                	je     194 <strcmp+0x30>
 183:	89 cb                	mov    %ecx,%ebx
 185:	0f b6 0b             	movzbl (%ebx),%ecx
 188:	38 c1                	cmp    %al,%cl
 18a:	74 ec                	je     178 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 18c:	29 c8                	sub    %ecx,%eax
}
 18e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 191:	c9                   	leave
 192:	c3                   	ret
 193:	90                   	nop
  return (uchar)*p - (uchar)*q;
 194:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 198:	31 c0                	xor    %eax,%eax
 19a:	29 c8                	sub    %ecx,%eax
}
 19c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19f:	c9                   	leave
 1a0:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1a1:	0f b6 0b             	movzbl (%ebx),%ecx
 1a4:	31 c0                	xor    %eax,%eax
 1a6:	eb e4                	jmp    18c <strcmp+0x28>

000001a8 <strlen>:

uint
strlen(const char *s)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1ae:	80 3a 00             	cmpb   $0x0,(%edx)
 1b1:	74 15                	je     1c8 <strlen+0x20>
 1b3:	31 c0                	xor    %eax,%eax
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
 1b8:	40                   	inc    %eax
 1b9:	89 c1                	mov    %eax,%ecx
 1bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1bf:	75 f7                	jne    1b8 <strlen+0x10>
    ;
  return n;
}
 1c1:	89 c8                	mov    %ecx,%eax
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1c8:	31 c9                	xor    %ecx,%ecx
}
 1ca:	89 c8                	mov    %ecx,%eax
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret
 1ce:	66 90                	xchg   %ax,%ax

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d4:	8b 7d 08             	mov    0x8(%ebp),%edi
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	fc                   	cld
 1de:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1e6:	c9                   	leave
 1e7:	c3                   	ret

000001e8 <strchr>:

char*
strchr(const char *s, char c)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1f1:	8a 10                	mov    (%eax),%dl
 1f3:	84 d2                	test   %dl,%dl
 1f5:	75 0c                	jne    203 <strchr+0x1b>
 1f7:	eb 13                	jmp    20c <strchr+0x24>
 1f9:	8d 76 00             	lea    0x0(%esi),%esi
 1fc:	40                   	inc    %eax
 1fd:	8a 10                	mov    (%eax),%dl
 1ff:	84 d2                	test   %dl,%dl
 201:	74 09                	je     20c <strchr+0x24>
    if(*s == c)
 203:	38 d1                	cmp    %dl,%cl
 205:	75 f5                	jne    1fc <strchr+0x14>
      return (char*)s;
  return 0;
}
 207:	5d                   	pop    %ebp
 208:	c3                   	ret
 209:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 20c:	31 c0                	xor    %eax,%eax
}
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret

00000210 <gets>:

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
 215:	53                   	push   %ebx
 216:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 219:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 21b:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 21e:	eb 24                	jmp    244 <gets+0x34>
    cc = read(0, &c, 1);
 220:	50                   	push   %eax
 221:	6a 01                	push   $0x1
 223:	56                   	push   %esi
 224:	6a 00                	push   $0x0
 226:	e8 f4 00 00 00       	call   31f <read>
    if(cc < 1)
 22b:	83 c4 10             	add    $0x10,%esp
 22e:	85 c0                	test   %eax,%eax
 230:	7e 1a                	jle    24c <gets+0x3c>
      break;
    buf[i++] = c;
 232:	8a 45 e7             	mov    -0x19(%ebp),%al
 235:	8b 55 08             	mov    0x8(%ebp),%edx
 238:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 23c:	3c 0a                	cmp    $0xa,%al
 23e:	74 0e                	je     24e <gets+0x3e>
 240:	3c 0d                	cmp    $0xd,%al
 242:	74 0a                	je     24e <gets+0x3e>
  for(i=0; i+1 < max; ){
 244:	89 df                	mov    %ebx,%edi
 246:	43                   	inc    %ebx
 247:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 24a:	7c d4                	jl     220 <gets+0x10>
 24c:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 255:	8d 65 f4             	lea    -0xc(%ebp),%esp
 258:	5b                   	pop    %ebx
 259:	5e                   	pop    %esi
 25a:	5f                   	pop    %edi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret
 25d:	8d 76 00             	lea    0x0(%esi),%esi

00000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	push   0x8(%ebp)
 26d:	e8 d5 00 00 00       	call   347 <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
 279:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 27b:	83 ec 08             	sub    $0x8,%esp
 27e:	ff 75 0c             	push   0xc(%ebp)
 281:	50                   	push   %eax
 282:	e8 d8 00 00 00       	call   35f <fstat>
 287:	89 c6                	mov    %eax,%esi
  close(fd);
 289:	89 1c 24             	mov    %ebx,(%esp)
 28c:	e8 9e 00 00 00       	call   32f <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
}
 294:	89 f0                	mov    %esi,%eax
 296:	8d 65 f8             	lea    -0x8(%ebp),%esp
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a5:	eb ed                	jmp    294 <stat+0x34>
 2a7:	90                   	nop

000002a8 <atoi>:

int
atoi(const char *s)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	53                   	push   %ebx
 2ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2af:	0f be 01             	movsbl (%ecx),%eax
 2b2:	8d 50 d0             	lea    -0x30(%eax),%edx
 2b5:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2b8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2bd:	77 16                	ja     2d5 <atoi+0x2d>
 2bf:	90                   	nop
    n = n*10 + *s++ - '0';
 2c0:	41                   	inc    %ecx
 2c1:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2c4:	01 d2                	add    %edx,%edx
 2c6:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2ca:	0f be 01             	movsbl (%ecx),%eax
 2cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d0:	80 fb 09             	cmp    $0x9,%bl
 2d3:	76 eb                	jbe    2c0 <atoi+0x18>
  return n;
}
 2d5:	89 d0                	mov    %edx,%eax
 2d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2da:	c9                   	leave
 2db:	c3                   	ret

000002dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	57                   	push   %edi
 2e0:	56                   	push   %esi
 2e1:	8b 55 08             	mov    0x8(%ebp),%edx
 2e4:	8b 75 0c             	mov    0xc(%ebp),%esi
 2e7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ea:	85 c0                	test   %eax,%eax
 2ec:	7e 0b                	jle    2f9 <memmove+0x1d>
 2ee:	01 d0                	add    %edx,%eax
  dst = vdst;
 2f0:	89 d7                	mov    %edx,%edi
 2f2:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2f4:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2f5:	39 f8                	cmp    %edi,%eax
 2f7:	75 fb                	jne    2f4 <memmove+0x18>
  return vdst;
}
 2f9:	89 d0                	mov    %edx,%eax
 2fb:	5e                   	pop    %esi
 2fc:	5f                   	pop    %edi
 2fd:	5d                   	pop    %ebp
 2fe:	c3                   	ret

000002ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ff:	b8 01 00 00 00       	mov    $0x1,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <exit>:
SYSCALL(exit)
 307:	b8 02 00 00 00       	mov    $0x2,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <wait>:
SYSCALL(wait)
 30f:	b8 03 00 00 00       	mov    $0x3,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <pipe>:
SYSCALL(pipe)
 317:	b8 04 00 00 00       	mov    $0x4,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <read>:
SYSCALL(read)
 31f:	b8 05 00 00 00       	mov    $0x5,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <write>:
SYSCALL(write)
 327:	b8 10 00 00 00       	mov    $0x10,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <close>:
SYSCALL(close)
 32f:	b8 15 00 00 00       	mov    $0x15,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <kill>:
SYSCALL(kill)
 337:	b8 06 00 00 00       	mov    $0x6,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <exec>:
SYSCALL(exec)
 33f:	b8 07 00 00 00       	mov    $0x7,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <open>:
SYSCALL(open)
 347:	b8 0f 00 00 00       	mov    $0xf,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <mknod>:
SYSCALL(mknod)
 34f:	b8 11 00 00 00       	mov    $0x11,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret

00000357 <unlink>:
SYSCALL(unlink)
 357:	b8 12 00 00 00       	mov    $0x12,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <fstat>:
SYSCALL(fstat)
 35f:	b8 08 00 00 00       	mov    $0x8,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <link>:
SYSCALL(link)
 367:	b8 13 00 00 00       	mov    $0x13,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <mkdir>:
SYSCALL(mkdir)
 36f:	b8 14 00 00 00       	mov    $0x14,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret

00000377 <chdir>:
SYSCALL(chdir)
 377:	b8 09 00 00 00       	mov    $0x9,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret

0000037f <dup>:
SYSCALL(dup)
 37f:	b8 0a 00 00 00       	mov    $0xa,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret

00000387 <getpid>:
SYSCALL(getpid)
 387:	b8 0b 00 00 00       	mov    $0xb,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret

0000038f <sbrk>:
SYSCALL(sbrk)
 38f:	b8 0c 00 00 00       	mov    $0xc,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret

00000397 <sleep>:
SYSCALL(sleep)
 397:	b8 0d 00 00 00       	mov    $0xd,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret

0000039f <uptime>:
SYSCALL(uptime)
 39f:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret

000003a7 <signal>:
SYSCALL(signal)
 3a7:	b8 16 00 00 00       	mov    $0x16,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret

000003af <custom_fork>:
SYSCALL(custom_fork)
 3af:	b8 17 00 00 00       	mov    $0x17,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret

000003b7 <scheduler_start>:
 3b7:	b8 18 00 00 00       	mov    $0x18,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret
 3bf:	90                   	nop

000003c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 3c             	sub    $0x3c,%esp
 3c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3cc:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3d1:	85 c9                	test   %ecx,%ecx
 3d3:	74 04                	je     3d9 <printint+0x19>
 3d5:	85 d2                	test   %edx,%edx
 3d7:	78 6b                	js     444 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 3dc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 3e3:	31 c9                	xor    %ecx,%ecx
 3e5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3eb:	31 d2                	xor    %edx,%edx
 3ed:	f7 f3                	div    %ebx
 3ef:	89 cf                	mov    %ecx,%edi
 3f1:	8d 49 01             	lea    0x1(%ecx),%ecx
 3f4:	8a 92 c4 07 00 00    	mov    0x7c4(%edx),%dl
 3fa:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 3fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 401:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 404:	39 da                	cmp    %ebx,%edx
 406:	73 e0                	jae    3e8 <printint+0x28>
  if(neg)
 408:	8b 55 08             	mov    0x8(%ebp),%edx
 40b:	85 d2                	test   %edx,%edx
 40d:	74 07                	je     416 <printint+0x56>
    buf[i++] = '-';
 40f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 414:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 416:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 419:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 420:	8a 07                	mov    (%edi),%al
 422:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 425:	50                   	push   %eax
 426:	6a 01                	push   $0x1
 428:	56                   	push   %esi
 429:	ff 75 c0             	push   -0x40(%ebp)
 42c:	e8 f6 fe ff ff       	call   327 <write>
  while(--i >= 0)
 431:	89 f8                	mov    %edi,%eax
 433:	4f                   	dec    %edi
 434:	83 c4 10             	add    $0x10,%esp
 437:	39 d8                	cmp    %ebx,%eax
 439:	75 e5                	jne    420 <printint+0x60>
}
 43b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43e:	5b                   	pop    %ebx
 43f:	5e                   	pop    %esi
 440:	5f                   	pop    %edi
 441:	5d                   	pop    %ebp
 442:	c3                   	ret
 443:	90                   	nop
    x = -xx;
 444:	f7 da                	neg    %edx
 446:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 449:	eb 98                	jmp    3e3 <printint+0x23>
 44b:	90                   	nop

0000044c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	57                   	push   %edi
 450:	56                   	push   %esi
 451:	53                   	push   %ebx
 452:	83 ec 2c             	sub    $0x2c,%esp
 455:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 458:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 45b:	8a 03                	mov    (%ebx),%al
 45d:	84 c0                	test   %al,%al
 45f:	74 2a                	je     48b <printf+0x3f>
 461:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 462:	8d 4d 10             	lea    0x10(%ebp),%ecx
 465:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 468:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 46b:	83 fa 25             	cmp    $0x25,%edx
 46e:	74 24                	je     494 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 470:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 473:	50                   	push   %eax
 474:	6a 01                	push   $0x1
 476:	8d 45 e7             	lea    -0x19(%ebp),%eax
 479:	50                   	push   %eax
 47a:	56                   	push   %esi
 47b:	e8 a7 fe ff ff       	call   327 <write>
  for(i = 0; fmt[i]; i++){
 480:	43                   	inc    %ebx
 481:	8a 43 ff             	mov    -0x1(%ebx),%al
 484:	83 c4 10             	add    $0x10,%esp
 487:	84 c0                	test   %al,%al
 489:	75 dd                	jne    468 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 48b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48e:	5b                   	pop    %ebx
 48f:	5e                   	pop    %esi
 490:	5f                   	pop    %edi
 491:	5d                   	pop    %ebp
 492:	c3                   	ret
 493:	90                   	nop
  for(i = 0; fmt[i]; i++){
 494:	8a 13                	mov    (%ebx),%dl
 496:	84 d2                	test   %dl,%dl
 498:	74 f1                	je     48b <printf+0x3f>
    c = fmt[i] & 0xff;
 49a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 49d:	80 fa 25             	cmp    $0x25,%dl
 4a0:	0f 84 fe 00 00 00    	je     5a4 <printf+0x158>
 4a6:	83 e8 63             	sub    $0x63,%eax
 4a9:	83 f8 15             	cmp    $0x15,%eax
 4ac:	77 0a                	ja     4b8 <printf+0x6c>
 4ae:	ff 24 85 6c 07 00 00 	jmp    *0x76c(,%eax,4)
 4b5:	8d 76 00             	lea    0x0(%esi),%esi
 4b8:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 4bb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4bf:	50                   	push   %eax
 4c0:	6a 01                	push   $0x1
 4c2:	8d 7d e7             	lea    -0x19(%ebp),%edi
 4c5:	57                   	push   %edi
 4c6:	56                   	push   %esi
 4c7:	e8 5b fe ff ff       	call   327 <write>
        putc(fd, c);
 4cc:	8a 55 d0             	mov    -0x30(%ebp),%dl
 4cf:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4d2:	83 c4 0c             	add    $0xc,%esp
 4d5:	6a 01                	push   $0x1
 4d7:	57                   	push   %edi
 4d8:	56                   	push   %esi
 4d9:	e8 49 fe ff ff       	call   327 <write>
  for(i = 0; fmt[i]; i++){
 4de:	83 c3 02             	add    $0x2,%ebx
 4e1:	8a 43 ff             	mov    -0x1(%ebx),%al
 4e4:	83 c4 10             	add    $0x10,%esp
 4e7:	84 c0                	test   %al,%al
 4e9:	0f 85 79 ff ff ff    	jne    468 <printf+0x1c>
}
 4ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f2:	5b                   	pop    %ebx
 4f3:	5e                   	pop    %esi
 4f4:	5f                   	pop    %edi
 4f5:	5d                   	pop    %ebp
 4f6:	c3                   	ret
 4f7:	90                   	nop
        printint(fd, *ap, 16, 0);
 4f8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4fb:	8b 17                	mov    (%edi),%edx
 4fd:	83 ec 0c             	sub    $0xc,%esp
 500:	6a 00                	push   $0x0
 502:	b9 10 00 00 00       	mov    $0x10,%ecx
 507:	89 f0                	mov    %esi,%eax
 509:	e8 b2 fe ff ff       	call   3c0 <printint>
        ap++;
 50e:	83 c7 04             	add    $0x4,%edi
 511:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 514:	eb c8                	jmp    4de <printf+0x92>
 516:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 518:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 51b:	8b 01                	mov    (%ecx),%eax
        ap++;
 51d:	83 c1 04             	add    $0x4,%ecx
 520:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 523:	85 c0                	test   %eax,%eax
 525:	0f 84 89 00 00 00    	je     5b4 <printf+0x168>
        while(*s != 0){
 52b:	8a 10                	mov    (%eax),%dl
 52d:	84 d2                	test   %dl,%dl
 52f:	74 29                	je     55a <printf+0x10e>
 531:	89 c7                	mov    %eax,%edi
 533:	88 d0                	mov    %dl,%al
 535:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 538:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 53b:	89 fb                	mov    %edi,%ebx
 53d:	89 cf                	mov    %ecx,%edi
 53f:	90                   	nop
          putc(fd, *s);
 540:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 543:	50                   	push   %eax
 544:	6a 01                	push   $0x1
 546:	57                   	push   %edi
 547:	56                   	push   %esi
 548:	e8 da fd ff ff       	call   327 <write>
          s++;
 54d:	43                   	inc    %ebx
        while(*s != 0){
 54e:	8a 03                	mov    (%ebx),%al
 550:	83 c4 10             	add    $0x10,%esp
 553:	84 c0                	test   %al,%al
 555:	75 e9                	jne    540 <printf+0xf4>
 557:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 55a:	83 c3 02             	add    $0x2,%ebx
 55d:	8a 43 ff             	mov    -0x1(%ebx),%al
 560:	84 c0                	test   %al,%al
 562:	0f 85 00 ff ff ff    	jne    468 <printf+0x1c>
 568:	e9 1e ff ff ff       	jmp    48b <printf+0x3f>
 56d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 570:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 573:	8b 17                	mov    (%edi),%edx
 575:	83 ec 0c             	sub    $0xc,%esp
 578:	6a 01                	push   $0x1
 57a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 57f:	eb 86                	jmp    507 <printf+0xbb>
 581:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 58c:	51                   	push   %ecx
 58d:	6a 01                	push   $0x1
 58f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 592:	57                   	push   %edi
 593:	56                   	push   %esi
 594:	e8 8e fd ff ff       	call   327 <write>
        ap++;
 599:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 59d:	e9 3c ff ff ff       	jmp    4de <printf+0x92>
 5a2:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 5a4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5a7:	52                   	push   %edx
 5a8:	6a 01                	push   $0x1
 5aa:	8d 7d e7             	lea    -0x19(%ebp),%edi
 5ad:	e9 25 ff ff ff       	jmp    4d7 <printf+0x8b>
 5b2:	66 90                	xchg   %ax,%ax
          s = "(null)";
 5b4:	bf 63 07 00 00       	mov    $0x763,%edi
 5b9:	b0 28                	mov    $0x28,%al
 5bb:	e9 75 ff ff ff       	jmp    535 <printf+0xe9>

000005c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cc:	a1 e0 09 00 00       	mov    0x9e0,%eax
 5d1:	8d 76 00             	lea    0x0(%esi),%esi
 5d4:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d6:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d8:	39 ca                	cmp    %ecx,%edx
 5da:	73 2c                	jae    608 <free+0x48>
 5dc:	39 c1                	cmp    %eax,%ecx
 5de:	72 04                	jb     5e4 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e0:	39 c2                	cmp    %eax,%edx
 5e2:	72 f0                	jb     5d4 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ea:	39 f8                	cmp    %edi,%eax
 5ec:	74 2c                	je     61a <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5ee:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5f1:	8b 42 04             	mov    0x4(%edx),%eax
 5f4:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5f7:	39 f1                	cmp    %esi,%ecx
 5f9:	74 36                	je     631 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5fb:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 5fd:	89 15 e0 09 00 00    	mov    %edx,0x9e0
}
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	39 c2                	cmp    %eax,%edx
 60a:	72 c8                	jb     5d4 <free+0x14>
 60c:	39 c1                	cmp    %eax,%ecx
 60e:	73 c4                	jae    5d4 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 610:	8b 73 fc             	mov    -0x4(%ebx),%esi
 613:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 616:	39 f8                	cmp    %edi,%eax
 618:	75 d4                	jne    5ee <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 61a:	03 70 04             	add    0x4(%eax),%esi
 61d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 620:	8b 02                	mov    (%edx),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 627:	8b 42 04             	mov    0x4(%edx),%eax
 62a:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 62d:	39 f1                	cmp    %esi,%ecx
 62f:	75 ca                	jne    5fb <free+0x3b>
    p->s.size += bp->s.size;
 631:	03 43 fc             	add    -0x4(%ebx),%eax
 634:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 637:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 63a:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 63c:	89 15 e0 09 00 00    	mov    %edx,0x9e0
}
 642:	5b                   	pop    %ebx
 643:	5e                   	pop    %esi
 644:	5f                   	pop    %edi
 645:	5d                   	pop    %ebp
 646:	c3                   	ret
 647:	90                   	nop

00000648 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	57                   	push   %edi
 64c:	56                   	push   %esi
 64d:	53                   	push   %ebx
 64e:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	8d 78 07             	lea    0x7(%eax),%edi
 657:	c1 ef 03             	shr    $0x3,%edi
 65a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 65b:	8b 15 e0 09 00 00    	mov    0x9e0,%edx
 661:	85 d2                	test   %edx,%edx
 663:	0f 84 93 00 00 00    	je     6fc <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 669:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 66b:	8b 48 04             	mov    0x4(%eax),%ecx
 66e:	39 f9                	cmp    %edi,%ecx
 670:	73 62                	jae    6d4 <malloc+0x8c>
  if(nu < 4096)
 672:	89 fb                	mov    %edi,%ebx
 674:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 67a:	72 78                	jb     6f4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 67c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 683:	eb 0e                	jmp    693 <malloc+0x4b>
 685:	8d 76 00             	lea    0x0(%esi),%esi
 688:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 68c:	8b 48 04             	mov    0x4(%eax),%ecx
 68f:	39 f9                	cmp    %edi,%ecx
 691:	73 41                	jae    6d4 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 693:	39 05 e0 09 00 00    	cmp    %eax,0x9e0
 699:	75 ed                	jne    688 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 69b:	83 ec 0c             	sub    $0xc,%esp
 69e:	56                   	push   %esi
 69f:	e8 eb fc ff ff       	call   38f <sbrk>
  if(p == (char*)-1)
 6a4:	83 c4 10             	add    $0x10,%esp
 6a7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6aa:	74 1c                	je     6c8 <malloc+0x80>
  hp->s.size = nu;
 6ac:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6af:	83 ec 0c             	sub    $0xc,%esp
 6b2:	83 c0 08             	add    $0x8,%eax
 6b5:	50                   	push   %eax
 6b6:	e8 05 ff ff ff       	call   5c0 <free>
  return freep;
 6bb:	8b 15 e0 09 00 00    	mov    0x9e0,%edx
      if((p = morecore(nunits)) == 0)
 6c1:	83 c4 10             	add    $0x10,%esp
 6c4:	85 d2                	test   %edx,%edx
 6c6:	75 c2                	jne    68a <malloc+0x42>
        return 0;
 6c8:	31 c0                	xor    %eax,%eax
  }
}
 6ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6cd:	5b                   	pop    %ebx
 6ce:	5e                   	pop    %esi
 6cf:	5f                   	pop    %edi
 6d0:	5d                   	pop    %ebp
 6d1:	c3                   	ret
 6d2:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 6d4:	39 cf                	cmp    %ecx,%edi
 6d6:	74 4c                	je     724 <malloc+0xdc>
        p->s.size -= nunits;
 6d8:	29 f9                	sub    %edi,%ecx
 6da:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6dd:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6e0:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6e3:	89 15 e0 09 00 00    	mov    %edx,0x9e0
      return (void*)(p + 1);
 6e9:	83 c0 08             	add    $0x8,%eax
}
 6ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret
  if(nu < 4096)
 6f4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6f9:	eb 81                	jmp    67c <malloc+0x34>
 6fb:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 6fc:	c7 05 e0 09 00 00 e4 	movl   $0x9e4,0x9e0
 703:	09 00 00 
 706:	c7 05 e4 09 00 00 e4 	movl   $0x9e4,0x9e4
 70d:	09 00 00 
    base.s.size = 0;
 710:	c7 05 e8 09 00 00 00 	movl   $0x0,0x9e8
 717:	00 00 00 
 71a:	b8 e4 09 00 00       	mov    $0x9e4,%eax
 71f:	e9 4e ff ff ff       	jmp    672 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 724:	8b 08                	mov    (%eax),%ecx
 726:	89 0a                	mov    %ecx,(%edx)
 728:	eb b9                	jmp    6e3 <malloc+0x9b>
