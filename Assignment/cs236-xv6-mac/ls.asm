
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 1e                	jle    3c <main+0x3c>
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	90                   	nop
    ls(argv[i]);
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 34 9f             	push   (%edi,%ebx,4)
  2a:	e8 b1 00 00 00       	call   e0 <ls>
  for(i=1; i<argc; i++)
  2f:	43                   	inc    %ebx
  30:	83 c4 10             	add    $0x10,%esp
  33:	39 de                	cmp    %ebx,%esi
  35:	75 ed                	jne    24 <main+0x24>
  exit();
  37:	e8 6f 04 00 00       	call   4ab <exit>
    ls(".");
  3c:	83 ec 0c             	sub    $0xc,%esp
  3f:	68 00 09 00 00       	push   $0x900
  44:	e8 97 00 00 00       	call   e0 <ls>
    exit();
  49:	e8 5d 04 00 00       	call   4ab <exit>
  4e:	66 90                	xchg   %ax,%ax

00000050 <fmtname>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	56                   	push   %esi
  5c:	e8 eb 02 00 00       	call   34c <strlen>
  61:	83 c4 10             	add    $0x10,%esp
  64:	01 f0                	add    %esi,%eax
  66:	89 c3                	mov    %eax,%ebx
  68:	73 0b                	jae    75 <fmtname+0x25>
  6a:	eb 0e                	jmp    7a <fmtname+0x2a>
  6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  6f:	39 f0                	cmp    %esi,%eax
  71:	72 08                	jb     7b <fmtname+0x2b>
  73:	89 c3                	mov    %eax,%ebx
  75:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  78:	75 f2                	jne    6c <fmtname+0x1c>
  p++;
  7a:	43                   	inc    %ebx
  if(strlen(p) >= DIRSIZ)
  7b:	83 ec 0c             	sub    $0xc,%esp
  7e:	53                   	push   %ebx
  7f:	e8 c8 02 00 00       	call   34c <strlen>
  84:	83 c4 10             	add    $0x10,%esp
  87:	83 f8 0d             	cmp    $0xd,%eax
  8a:	77 4a                	ja     d6 <fmtname+0x86>
  memmove(buf, p, strlen(p));
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	e8 b7 02 00 00       	call   34c <strlen>
  95:	83 c4 0c             	add    $0xc,%esp
  98:	50                   	push   %eax
  99:	53                   	push   %ebx
  9a:	68 78 09 00 00       	push   $0x978
  9f:	e8 dc 03 00 00       	call   480 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  a4:	89 1c 24             	mov    %ebx,(%esp)
  a7:	e8 a0 02 00 00       	call   34c <strlen>
  ac:	89 c6                	mov    %eax,%esi
  ae:	89 1c 24             	mov    %ebx,(%esp)
  b1:	e8 96 02 00 00       	call   34c <strlen>
  b6:	83 c4 0c             	add    $0xc,%esp
  b9:	ba 0e 00 00 00       	mov    $0xe,%edx
  be:	29 f2                	sub    %esi,%edx
  c0:	52                   	push   %edx
  c1:	6a 20                	push   $0x20
  c3:	05 78 09 00 00       	add    $0x978,%eax
  c8:	50                   	push   %eax
  c9:	e8 a6 02 00 00       	call   374 <memset>
  return buf;
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	bb 78 09 00 00       	mov    $0x978,%ebx
}
  d6:	89 d8                	mov    %ebx,%eax
  d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  db:	5b                   	pop    %ebx
  dc:	5e                   	pop    %esi
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret
  df:	90                   	nop

000000e0 <ls>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	81 ec 64 02 00 00    	sub    $0x264,%esp
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
  ef:	6a 00                	push   $0x0
  f1:	57                   	push   %edi
  f2:	e8 f4 03 00 00       	call   4eb <open>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	0f 88 76 01 00 00    	js     278 <ls+0x198>
 102:	89 c3                	mov    %eax,%ebx
  if(fstat(fd, &st) < 0){
 104:	83 ec 08             	sub    $0x8,%esp
 107:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 10d:	56                   	push   %esi
 10e:	50                   	push   %eax
 10f:	e8 ef 03 00 00       	call   503 <fstat>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	0f 88 8d 01 00 00    	js     2ac <ls+0x1cc>
  switch(st.type){
 11f:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 125:	66 83 f8 01          	cmp    $0x1,%ax
 129:	74 51                	je     17c <ls+0x9c>
 12b:	66 83 f8 02          	cmp    $0x2,%ax
 12f:	75 37                	jne    168 <ls+0x88>
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 131:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 137:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 13d:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 143:	83 ec 0c             	sub    $0xc,%esp
 146:	57                   	push   %edi
 147:	e8 04 ff ff ff       	call   50 <fmtname>
 14c:	59                   	pop    %ecx
 14d:	5f                   	pop    %edi
 14e:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 154:	52                   	push   %edx
 155:	56                   	push   %esi
 156:	6a 02                	push   $0x2
 158:	50                   	push   %eax
 159:	68 e0 08 00 00       	push   $0x8e0
 15e:	6a 01                	push   $0x1
 160:	e8 73 04 00 00       	call   5d8 <printf>
    break;
 165:	83 c4 20             	add    $0x20,%esp
  close(fd);
 168:	83 ec 0c             	sub    $0xc,%esp
 16b:	53                   	push   %ebx
 16c:	e8 62 03 00 00       	call   4d3 <close>
 171:	83 c4 10             	add    $0x10,%esp
}
 174:	8d 65 f4             	lea    -0xc(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5f                   	pop    %edi
 17a:	5d                   	pop    %ebp
 17b:	c3                   	ret
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17c:	83 ec 0c             	sub    $0xc,%esp
 17f:	57                   	push   %edi
 180:	e8 c7 01 00 00       	call   34c <strlen>
 185:	83 c0 10             	add    $0x10,%eax
 188:	83 c4 10             	add    $0x10,%esp
 18b:	3d 00 02 00 00       	cmp    $0x200,%eax
 190:	0f 87 fe 00 00 00    	ja     294 <ls+0x1b4>
    strcpy(buf, path);
 196:	83 ec 08             	sub    $0x8,%esp
 199:	57                   	push   %edi
 19a:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1a0:	57                   	push   %edi
 1a1:	e8 42 01 00 00       	call   2e8 <strcpy>
    p = buf+strlen(buf);
 1a6:	89 3c 24             	mov    %edi,(%esp)
 1a9:	e8 9e 01 00 00       	call   34c <strlen>
 1ae:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
 1b1:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
    *p++ = '/';
 1b7:	8d 44 07 01          	lea    0x1(%edi,%eax,1),%eax
 1bb:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 1c1:	c6 01 2f             	movb   $0x2f,(%ecx)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	90                   	nop
 1c8:	50                   	push   %eax
 1c9:	6a 10                	push   $0x10
 1cb:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	53                   	push   %ebx
 1d3:	e8 eb 02 00 00       	call   4c3 <read>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	83 f8 10             	cmp    $0x10,%eax
 1de:	75 88                	jne    168 <ls+0x88>
      if(de.inum == 0)
 1e0:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 1e7:	00 
 1e8:	74 de                	je     1c8 <ls+0xe8>
      memmove(p, de.name, DIRSIZ);
 1ea:	50                   	push   %eax
 1eb:	6a 0e                	push   $0xe
 1ed:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 1f3:	50                   	push   %eax
 1f4:	ff b5 a4 fd ff ff    	push   -0x25c(%ebp)
 1fa:	e8 81 02 00 00       	call   480 <memmove>
      p[DIRSIZ] = 0;
 1ff:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 205:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 209:	58                   	pop    %eax
 20a:	5a                   	pop    %edx
 20b:	56                   	push   %esi
 20c:	57                   	push   %edi
 20d:	e8 f2 01 00 00       	call   404 <stat>
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	0f 88 b3 00 00 00    	js     2d0 <ls+0x1f0>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 21d:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 223:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 229:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 22f:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 235:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 23c:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	57                   	push   %edi
 246:	e8 05 fe ff ff       	call   50 <fmtname>
 24b:	5a                   	pop    %edx
 24c:	59                   	pop    %ecx
 24d:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 253:	51                   	push   %ecx
 254:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 25a:	52                   	push   %edx
 25b:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 261:	50                   	push   %eax
 262:	68 e0 08 00 00       	push   $0x8e0
 267:	6a 01                	push   $0x1
 269:	e8 6a 03 00 00       	call   5d8 <printf>
 26e:	83 c4 20             	add    $0x20,%esp
 271:	e9 52 ff ff ff       	jmp    1c8 <ls+0xe8>
 276:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot open %s\n", path);
 278:	50                   	push   %eax
 279:	57                   	push   %edi
 27a:	68 b8 08 00 00       	push   $0x8b8
 27f:	6a 02                	push   $0x2
 281:	e8 52 03 00 00       	call   5d8 <printf>
    return;
 286:	83 c4 10             	add    $0x10,%esp
}
 289:	8d 65 f4             	lea    -0xc(%ebp),%esp
 28c:	5b                   	pop    %ebx
 28d:	5e                   	pop    %esi
 28e:	5f                   	pop    %edi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret
 291:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "ls: path too long\n");
 294:	83 ec 08             	sub    $0x8,%esp
 297:	68 ed 08 00 00       	push   $0x8ed
 29c:	6a 01                	push   $0x1
 29e:	e8 35 03 00 00       	call   5d8 <printf>
      break;
 2a3:	83 c4 10             	add    $0x10,%esp
 2a6:	e9 bd fe ff ff       	jmp    168 <ls+0x88>
 2ab:	90                   	nop
    printf(2, "ls: cannot stat %s\n", path);
 2ac:	50                   	push   %eax
 2ad:	57                   	push   %edi
 2ae:	68 cc 08 00 00       	push   $0x8cc
 2b3:	6a 02                	push   $0x2
 2b5:	e8 1e 03 00 00       	call   5d8 <printf>
    close(fd);
 2ba:	89 1c 24             	mov    %ebx,(%esp)
 2bd:	e8 11 02 00 00       	call   4d3 <close>
    return;
 2c2:	83 c4 10             	add    $0x10,%esp
}
 2c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c8:	5b                   	pop    %ebx
 2c9:	5e                   	pop    %esi
 2ca:	5f                   	pop    %edi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 2d0:	50                   	push   %eax
 2d1:	57                   	push   %edi
 2d2:	68 cc 08 00 00       	push   $0x8cc
 2d7:	6a 01                	push   $0x1
 2d9:	e8 fa 02 00 00       	call   5d8 <printf>
        continue;
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	e9 e2 fe ff ff       	jmp    1c8 <ls+0xe8>
 2e6:	66 90                	xchg   %ax,%ax

000002e8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	53                   	push   %ebx
 2ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f2:	31 c0                	xor    %eax,%eax
 2f4:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 2f7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2fa:	40                   	inc    %eax
 2fb:	84 d2                	test   %dl,%dl
 2fd:	75 f5                	jne    2f4 <strcpy+0xc>
    ;
  return os;
}
 2ff:	89 c8                	mov    %ecx,%eax
 301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 304:	c9                   	leave
 305:	c3                   	ret
 306:	66 90                	xchg   %ax,%ax

00000308 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	53                   	push   %ebx
 30c:	8b 55 08             	mov    0x8(%ebp),%edx
 30f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 312:	0f b6 02             	movzbl (%edx),%eax
 315:	84 c0                	test   %al,%al
 317:	75 10                	jne    329 <strcmp+0x21>
 319:	eb 2a                	jmp    345 <strcmp+0x3d>
 31b:	90                   	nop
    p++, q++;
 31c:	42                   	inc    %edx
 31d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 320:	0f b6 02             	movzbl (%edx),%eax
 323:	84 c0                	test   %al,%al
 325:	74 11                	je     338 <strcmp+0x30>
 327:	89 cb                	mov    %ecx,%ebx
 329:	0f b6 0b             	movzbl (%ebx),%ecx
 32c:	38 c1                	cmp    %al,%cl
 32e:	74 ec                	je     31c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 330:	29 c8                	sub    %ecx,%eax
}
 332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 335:	c9                   	leave
 336:	c3                   	ret
 337:	90                   	nop
  return (uchar)*p - (uchar)*q;
 338:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 33c:	31 c0                	xor    %eax,%eax
 33e:	29 c8                	sub    %ecx,%eax
}
 340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 343:	c9                   	leave
 344:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 345:	0f b6 0b             	movzbl (%ebx),%ecx
 348:	31 c0                	xor    %eax,%eax
 34a:	eb e4                	jmp    330 <strcmp+0x28>

0000034c <strlen>:

uint
strlen(const char *s)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 352:	80 3a 00             	cmpb   $0x0,(%edx)
 355:	74 15                	je     36c <strlen+0x20>
 357:	31 c0                	xor    %eax,%eax
 359:	8d 76 00             	lea    0x0(%esi),%esi
 35c:	40                   	inc    %eax
 35d:	89 c1                	mov    %eax,%ecx
 35f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 363:	75 f7                	jne    35c <strlen+0x10>
    ;
  return n;
}
 365:	89 c8                	mov    %ecx,%eax
 367:	5d                   	pop    %ebp
 368:	c3                   	ret
 369:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 36c:	31 c9                	xor    %ecx,%ecx
}
 36e:	89 c8                	mov    %ecx,%eax
 370:	5d                   	pop    %ebp
 371:	c3                   	ret
 372:	66 90                	xchg   %ax,%ax

00000374 <memset>:

void*
memset(void *dst, int c, uint n)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 378:	8b 7d 08             	mov    0x8(%ebp),%edi
 37b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	fc                   	cld
 382:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	8b 7d fc             	mov    -0x4(%ebp),%edi
 38a:	c9                   	leave
 38b:	c3                   	ret

0000038c <strchr>:

char*
strchr(const char *s, char c)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 395:	8a 10                	mov    (%eax),%dl
 397:	84 d2                	test   %dl,%dl
 399:	75 0c                	jne    3a7 <strchr+0x1b>
 39b:	eb 13                	jmp    3b0 <strchr+0x24>
 39d:	8d 76 00             	lea    0x0(%esi),%esi
 3a0:	40                   	inc    %eax
 3a1:	8a 10                	mov    (%eax),%dl
 3a3:	84 d2                	test   %dl,%dl
 3a5:	74 09                	je     3b0 <strchr+0x24>
    if(*s == c)
 3a7:	38 d1                	cmp    %dl,%cl
 3a9:	75 f5                	jne    3a0 <strchr+0x14>
      return (char*)s;
  return 0;
}
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3b0:	31 c0                	xor    %eax,%eax
}
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret

000003b4 <gets>:

char*
gets(char *buf, int max)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	57                   	push   %edi
 3b8:	56                   	push   %esi
 3b9:	53                   	push   %ebx
 3ba:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3bd:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 3bf:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 3c2:	eb 24                	jmp    3e8 <gets+0x34>
    cc = read(0, &c, 1);
 3c4:	50                   	push   %eax
 3c5:	6a 01                	push   $0x1
 3c7:	56                   	push   %esi
 3c8:	6a 00                	push   $0x0
 3ca:	e8 f4 00 00 00       	call   4c3 <read>
    if(cc < 1)
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	85 c0                	test   %eax,%eax
 3d4:	7e 1a                	jle    3f0 <gets+0x3c>
      break;
    buf[i++] = c;
 3d6:	8a 45 e7             	mov    -0x19(%ebp),%al
 3d9:	8b 55 08             	mov    0x8(%ebp),%edx
 3dc:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3e0:	3c 0a                	cmp    $0xa,%al
 3e2:	74 0e                	je     3f2 <gets+0x3e>
 3e4:	3c 0d                	cmp    $0xd,%al
 3e6:	74 0a                	je     3f2 <gets+0x3e>
  for(i=0; i+1 < max; ){
 3e8:	89 df                	mov    %ebx,%edi
 3ea:	43                   	inc    %ebx
 3eb:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ee:	7c d4                	jl     3c4 <gets+0x10>
 3f0:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
 3f5:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 3f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fc:	5b                   	pop    %ebx
 3fd:	5e                   	pop    %esi
 3fe:	5f                   	pop    %edi
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret
 401:	8d 76 00             	lea    0x0(%esi),%esi

00000404 <stat>:

int
stat(const char *n, struct stat *st)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	56                   	push   %esi
 408:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 409:	83 ec 08             	sub    $0x8,%esp
 40c:	6a 00                	push   $0x0
 40e:	ff 75 08             	push   0x8(%ebp)
 411:	e8 d5 00 00 00       	call   4eb <open>
  if(fd < 0)
 416:	83 c4 10             	add    $0x10,%esp
 419:	85 c0                	test   %eax,%eax
 41b:	78 27                	js     444 <stat+0x40>
 41d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 41f:	83 ec 08             	sub    $0x8,%esp
 422:	ff 75 0c             	push   0xc(%ebp)
 425:	50                   	push   %eax
 426:	e8 d8 00 00 00       	call   503 <fstat>
 42b:	89 c6                	mov    %eax,%esi
  close(fd);
 42d:	89 1c 24             	mov    %ebx,(%esp)
 430:	e8 9e 00 00 00       	call   4d3 <close>
  return r;
 435:	83 c4 10             	add    $0x10,%esp
}
 438:	89 f0                	mov    %esi,%eax
 43a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 43d:	5b                   	pop    %ebx
 43e:	5e                   	pop    %esi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret
 441:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 444:	be ff ff ff ff       	mov    $0xffffffff,%esi
 449:	eb ed                	jmp    438 <stat+0x34>
 44b:	90                   	nop

0000044c <atoi>:

int
atoi(const char *s)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	53                   	push   %ebx
 450:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 453:	0f be 01             	movsbl (%ecx),%eax
 456:	8d 50 d0             	lea    -0x30(%eax),%edx
 459:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 45c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 461:	77 16                	ja     479 <atoi+0x2d>
 463:	90                   	nop
    n = n*10 + *s++ - '0';
 464:	41                   	inc    %ecx
 465:	8d 14 92             	lea    (%edx,%edx,4),%edx
 468:	01 d2                	add    %edx,%edx
 46a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 46e:	0f be 01             	movsbl (%ecx),%eax
 471:	8d 58 d0             	lea    -0x30(%eax),%ebx
 474:	80 fb 09             	cmp    $0x9,%bl
 477:	76 eb                	jbe    464 <atoi+0x18>
  return n;
}
 479:	89 d0                	mov    %edx,%eax
 47b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 47e:	c9                   	leave
 47f:	c3                   	ret

00000480 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	8b 55 08             	mov    0x8(%ebp),%edx
 488:	8b 75 0c             	mov    0xc(%ebp),%esi
 48b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 c0                	test   %eax,%eax
 490:	7e 0b                	jle    49d <memmove+0x1d>
 492:	01 d0                	add    %edx,%eax
  dst = vdst;
 494:	89 d7                	mov    %edx,%edi
 496:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 498:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 499:	39 f8                	cmp    %edi,%eax
 49b:	75 fb                	jne    498 <memmove+0x18>
  return vdst;
}
 49d:	89 d0                	mov    %edx,%eax
 49f:	5e                   	pop    %esi
 4a0:	5f                   	pop    %edi
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret

000004a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4a3:	b8 01 00 00 00       	mov    $0x1,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <exit>:
SYSCALL(exit)
 4ab:	b8 02 00 00 00       	mov    $0x2,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <wait>:
SYSCALL(wait)
 4b3:	b8 03 00 00 00       	mov    $0x3,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <pipe>:
SYSCALL(pipe)
 4bb:	b8 04 00 00 00       	mov    $0x4,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <read>:
SYSCALL(read)
 4c3:	b8 05 00 00 00       	mov    $0x5,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <write>:
SYSCALL(write)
 4cb:	b8 10 00 00 00       	mov    $0x10,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <close>:
SYSCALL(close)
 4d3:	b8 15 00 00 00       	mov    $0x15,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <kill>:
SYSCALL(kill)
 4db:	b8 06 00 00 00       	mov    $0x6,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <exec>:
SYSCALL(exec)
 4e3:	b8 07 00 00 00       	mov    $0x7,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <open>:
SYSCALL(open)
 4eb:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <mknod>:
SYSCALL(mknod)
 4f3:	b8 11 00 00 00       	mov    $0x11,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <unlink>:
SYSCALL(unlink)
 4fb:	b8 12 00 00 00       	mov    $0x12,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <fstat>:
SYSCALL(fstat)
 503:	b8 08 00 00 00       	mov    $0x8,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <link>:
SYSCALL(link)
 50b:	b8 13 00 00 00       	mov    $0x13,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <mkdir>:
SYSCALL(mkdir)
 513:	b8 14 00 00 00       	mov    $0x14,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <chdir>:
SYSCALL(chdir)
 51b:	b8 09 00 00 00       	mov    $0x9,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <dup>:
SYSCALL(dup)
 523:	b8 0a 00 00 00       	mov    $0xa,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <getpid>:
SYSCALL(getpid)
 52b:	b8 0b 00 00 00       	mov    $0xb,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <sbrk>:
SYSCALL(sbrk)
 533:	b8 0c 00 00 00       	mov    $0xc,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <sleep>:
SYSCALL(sleep)
 53b:	b8 0d 00 00 00       	mov    $0xd,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <uptime>:
SYSCALL(uptime)
 543:	b8 0e 00 00 00       	mov    $0xe,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret
 54b:	90                   	nop

0000054c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	57                   	push   %edi
 550:	56                   	push   %esi
 551:	53                   	push   %ebx
 552:	83 ec 3c             	sub    $0x3c,%esp
 555:	89 45 c0             	mov    %eax,-0x40(%ebp)
 558:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 55d:	85 c9                	test   %ecx,%ecx
 55f:	74 04                	je     565 <printint+0x19>
 561:	85 d2                	test   %edx,%edx
 563:	78 6b                	js     5d0 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 565:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 568:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 56f:	31 c9                	xor    %ecx,%ecx
 571:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 574:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 577:	31 d2                	xor    %edx,%edx
 579:	f7 f3                	div    %ebx
 57b:	89 cf                	mov    %ecx,%edi
 57d:	8d 49 01             	lea    0x1(%ecx),%ecx
 580:	8a 92 64 09 00 00    	mov    0x964(%edx),%dl
 586:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 58a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 58d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 590:	39 da                	cmp    %ebx,%edx
 592:	73 e0                	jae    574 <printint+0x28>
  if(neg)
 594:	8b 55 08             	mov    0x8(%ebp),%edx
 597:	85 d2                	test   %edx,%edx
 599:	74 07                	je     5a2 <printint+0x56>
    buf[i++] = '-';
 59b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 5a0:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 5a2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 5a5:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 5a9:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 5ac:	8a 07                	mov    (%edi),%al
 5ae:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 5b1:	50                   	push   %eax
 5b2:	6a 01                	push   $0x1
 5b4:	56                   	push   %esi
 5b5:	ff 75 c0             	push   -0x40(%ebp)
 5b8:	e8 0e ff ff ff       	call   4cb <write>
  while(--i >= 0)
 5bd:	89 f8                	mov    %edi,%eax
 5bf:	4f                   	dec    %edi
 5c0:	83 c4 10             	add    $0x10,%esp
 5c3:	39 d8                	cmp    %ebx,%eax
 5c5:	75 e5                	jne    5ac <printint+0x60>
}
 5c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5f                   	pop    %edi
 5cd:	5d                   	pop    %ebp
 5ce:	c3                   	ret
 5cf:	90                   	nop
    x = -xx;
 5d0:	f7 da                	neg    %edx
 5d2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 5d5:	eb 98                	jmp    56f <printint+0x23>
 5d7:	90                   	nop

000005d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	57                   	push   %edi
 5dc:	56                   	push   %esi
 5dd:	53                   	push   %ebx
 5de:	83 ec 2c             	sub    $0x2c,%esp
 5e1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 5e7:	8a 03                	mov    (%ebx),%al
 5e9:	84 c0                	test   %al,%al
 5eb:	74 2a                	je     617 <printf+0x3f>
 5ed:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 5ee:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5f1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 5f4:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 5f7:	83 fa 25             	cmp    $0x25,%edx
 5fa:	74 24                	je     620 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 5fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5ff:	50                   	push   %eax
 600:	6a 01                	push   $0x1
 602:	8d 45 e7             	lea    -0x19(%ebp),%eax
 605:	50                   	push   %eax
 606:	56                   	push   %esi
 607:	e8 bf fe ff ff       	call   4cb <write>
  for(i = 0; fmt[i]; i++){
 60c:	43                   	inc    %ebx
 60d:	8a 43 ff             	mov    -0x1(%ebx),%al
 610:	83 c4 10             	add    $0x10,%esp
 613:	84 c0                	test   %al,%al
 615:	75 dd                	jne    5f4 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 617:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61a:	5b                   	pop    %ebx
 61b:	5e                   	pop    %esi
 61c:	5f                   	pop    %edi
 61d:	5d                   	pop    %ebp
 61e:	c3                   	ret
 61f:	90                   	nop
  for(i = 0; fmt[i]; i++){
 620:	8a 13                	mov    (%ebx),%dl
 622:	84 d2                	test   %dl,%dl
 624:	74 f1                	je     617 <printf+0x3f>
    c = fmt[i] & 0xff;
 626:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 629:	80 fa 25             	cmp    $0x25,%dl
 62c:	0f 84 fe 00 00 00    	je     730 <printf+0x158>
 632:	83 e8 63             	sub    $0x63,%eax
 635:	83 f8 15             	cmp    $0x15,%eax
 638:	77 0a                	ja     644 <printf+0x6c>
 63a:	ff 24 85 0c 09 00 00 	jmp    *0x90c(,%eax,4)
 641:	8d 76 00             	lea    0x0(%esi),%esi
 644:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 647:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 64b:	50                   	push   %eax
 64c:	6a 01                	push   $0x1
 64e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 651:	57                   	push   %edi
 652:	56                   	push   %esi
 653:	e8 73 fe ff ff       	call   4cb <write>
        putc(fd, c);
 658:	8a 55 d0             	mov    -0x30(%ebp),%dl
 65b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 65e:	83 c4 0c             	add    $0xc,%esp
 661:	6a 01                	push   $0x1
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	e8 61 fe ff ff       	call   4cb <write>
  for(i = 0; fmt[i]; i++){
 66a:	83 c3 02             	add    $0x2,%ebx
 66d:	8a 43 ff             	mov    -0x1(%ebx),%al
 670:	83 c4 10             	add    $0x10,%esp
 673:	84 c0                	test   %al,%al
 675:	0f 85 79 ff ff ff    	jne    5f4 <printf+0x1c>
}
 67b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67e:	5b                   	pop    %ebx
 67f:	5e                   	pop    %esi
 680:	5f                   	pop    %edi
 681:	5d                   	pop    %ebp
 682:	c3                   	ret
 683:	90                   	nop
        printint(fd, *ap, 16, 0);
 684:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 687:	8b 17                	mov    (%edi),%edx
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	6a 00                	push   $0x0
 68e:	b9 10 00 00 00       	mov    $0x10,%ecx
 693:	89 f0                	mov    %esi,%eax
 695:	e8 b2 fe ff ff       	call   54c <printint>
        ap++;
 69a:	83 c7 04             	add    $0x4,%edi
 69d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 6a0:	eb c8                	jmp    66a <printf+0x92>
 6a2:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 6a4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 6a7:	8b 01                	mov    (%ecx),%eax
        ap++;
 6a9:	83 c1 04             	add    $0x4,%ecx
 6ac:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 6af:	85 c0                	test   %eax,%eax
 6b1:	0f 84 89 00 00 00    	je     740 <printf+0x168>
        while(*s != 0){
 6b7:	8a 10                	mov    (%eax),%dl
 6b9:	84 d2                	test   %dl,%dl
 6bb:	74 29                	je     6e6 <printf+0x10e>
 6bd:	89 c7                	mov    %eax,%edi
 6bf:	88 d0                	mov    %dl,%al
 6c1:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 6c4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6c7:	89 fb                	mov    %edi,%ebx
 6c9:	89 cf                	mov    %ecx,%edi
 6cb:	90                   	nop
          putc(fd, *s);
 6cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6cf:	50                   	push   %eax
 6d0:	6a 01                	push   $0x1
 6d2:	57                   	push   %edi
 6d3:	56                   	push   %esi
 6d4:	e8 f2 fd ff ff       	call   4cb <write>
          s++;
 6d9:	43                   	inc    %ebx
        while(*s != 0){
 6da:	8a 03                	mov    (%ebx),%al
 6dc:	83 c4 10             	add    $0x10,%esp
 6df:	84 c0                	test   %al,%al
 6e1:	75 e9                	jne    6cc <printf+0xf4>
 6e3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 6e6:	83 c3 02             	add    $0x2,%ebx
 6e9:	8a 43 ff             	mov    -0x1(%ebx),%al
 6ec:	84 c0                	test   %al,%al
 6ee:	0f 85 00 ff ff ff    	jne    5f4 <printf+0x1c>
 6f4:	e9 1e ff ff ff       	jmp    617 <printf+0x3f>
 6f9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6fc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6ff:	8b 17                	mov    (%edi),%edx
 701:	83 ec 0c             	sub    $0xc,%esp
 704:	6a 01                	push   $0x1
 706:	b9 0a 00 00 00       	mov    $0xa,%ecx
 70b:	eb 86                	jmp    693 <printf+0xbb>
 70d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 718:	51                   	push   %ecx
 719:	6a 01                	push   $0x1
 71b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 71e:	57                   	push   %edi
 71f:	56                   	push   %esi
 720:	e8 a6 fd ff ff       	call   4cb <write>
        ap++;
 725:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 729:	e9 3c ff ff ff       	jmp    66a <printf+0x92>
 72e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 730:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 733:	52                   	push   %edx
 734:	6a 01                	push   $0x1
 736:	8d 7d e7             	lea    -0x19(%ebp),%edi
 739:	e9 25 ff ff ff       	jmp    663 <printf+0x8b>
 73e:	66 90                	xchg   %ax,%ax
          s = "(null)";
 740:	bf 02 09 00 00       	mov    $0x902,%edi
 745:	b0 28                	mov    $0x28,%al
 747:	e9 75 ff ff ff       	jmp    6c1 <printf+0xe9>

0000074c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	57                   	push   %edi
 750:	56                   	push   %esi
 751:	53                   	push   %ebx
 752:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 755:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	a1 88 09 00 00       	mov    0x988,%eax
 75d:	8d 76 00             	lea    0x0(%esi),%esi
 760:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	39 ca                	cmp    %ecx,%edx
 766:	73 2c                	jae    794 <free+0x48>
 768:	39 c1                	cmp    %eax,%ecx
 76a:	72 04                	jb     770 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	39 c2                	cmp    %eax,%edx
 76e:	72 f0                	jb     760 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 770:	8b 73 fc             	mov    -0x4(%ebx),%esi
 773:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 776:	39 f8                	cmp    %edi,%eax
 778:	74 2c                	je     7a6 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 77d:	8b 42 04             	mov    0x4(%edx),%eax
 780:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 783:	39 f1                	cmp    %esi,%ecx
 785:	74 36                	je     7bd <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 787:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 789:	89 15 88 09 00 00    	mov    %edx,0x988
}
 78f:	5b                   	pop    %ebx
 790:	5e                   	pop    %esi
 791:	5f                   	pop    %edi
 792:	5d                   	pop    %ebp
 793:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	39 c2                	cmp    %eax,%edx
 796:	72 c8                	jb     760 <free+0x14>
 798:	39 c1                	cmp    %eax,%ecx
 79a:	73 c4                	jae    760 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 79c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 79f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7a2:	39 f8                	cmp    %edi,%eax
 7a4:	75 d4                	jne    77a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 7a6:	03 70 04             	add    0x4(%eax),%esi
 7a9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	8b 02                	mov    (%edx),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7b3:	8b 42 04             	mov    0x4(%edx),%eax
 7b6:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7b9:	39 f1                	cmp    %esi,%ecx
 7bb:	75 ca                	jne    787 <free+0x3b>
    p->s.size += bp->s.size;
 7bd:	03 43 fc             	add    -0x4(%ebx),%eax
 7c0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7c3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7c6:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 7c8:	89 15 88 09 00 00    	mov    %edx,0x988
}
 7ce:	5b                   	pop    %ebx
 7cf:	5e                   	pop    %esi
 7d0:	5f                   	pop    %edi
 7d1:	5d                   	pop    %ebp
 7d2:	c3                   	ret
 7d3:	90                   	nop

000007d4 <malloc>:
}


void*
malloc(uint nbytes)
{
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	57                   	push   %edi
 7d8:	56                   	push   %esi
 7d9:	53                   	push   %ebx
 7da:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dd:	8b 45 08             	mov    0x8(%ebp),%eax
 7e0:	8d 78 07             	lea    0x7(%eax),%edi
 7e3:	c1 ef 03             	shr    $0x3,%edi
 7e6:	47                   	inc    %edi
  if((prevp = freep) == 0){
 7e7:	8b 15 88 09 00 00    	mov    0x988,%edx
 7ed:	85 d2                	test   %edx,%edx
 7ef:	0f 84 93 00 00 00    	je     888 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f7:	8b 48 04             	mov    0x4(%eax),%ecx
 7fa:	39 f9                	cmp    %edi,%ecx
 7fc:	73 62                	jae    860 <malloc+0x8c>
  if(nu < 4096)
 7fe:	89 fb                	mov    %edi,%ebx
 800:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 806:	72 78                	jb     880 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 808:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 80f:	eb 0e                	jmp    81f <malloc+0x4b>
 811:	8d 76 00             	lea    0x0(%esi),%esi
 814:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 818:	8b 48 04             	mov    0x4(%eax),%ecx
 81b:	39 f9                	cmp    %edi,%ecx
 81d:	73 41                	jae    860 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81f:	39 05 88 09 00 00    	cmp    %eax,0x988
 825:	75 ed                	jne    814 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
 827:	83 ec 0c             	sub    $0xc,%esp
 82a:	56                   	push   %esi
 82b:	e8 03 fd ff ff       	call   533 <sbrk>
  if(p == (char*)-1)
 830:	83 c4 10             	add    $0x10,%esp
 833:	83 f8 ff             	cmp    $0xffffffff,%eax
 836:	74 1c                	je     854 <malloc+0x80>
  hp->s.size = nu;
 838:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	83 c0 08             	add    $0x8,%eax
 841:	50                   	push   %eax
 842:	e8 05 ff ff ff       	call   74c <free>
  return freep;
 847:	8b 15 88 09 00 00    	mov    0x988,%edx
      if((p = morecore(nunits)) == 0)
 84d:	83 c4 10             	add    $0x10,%esp
 850:	85 d2                	test   %edx,%edx
 852:	75 c2                	jne    816 <malloc+0x42>
        return 0;
 854:	31 c0                	xor    %eax,%eax
  }
}
 856:	8d 65 f4             	lea    -0xc(%ebp),%esp
 859:	5b                   	pop    %ebx
 85a:	5e                   	pop    %esi
 85b:	5f                   	pop    %edi
 85c:	5d                   	pop    %ebp
 85d:	c3                   	ret
 85e:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 860:	39 cf                	cmp    %ecx,%edi
 862:	74 4c                	je     8b0 <malloc+0xdc>
        p->s.size -= nunits;
 864:	29 f9                	sub    %edi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 86c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 86f:	89 15 88 09 00 00    	mov    %edx,0x988
      return (void*)(p + 1);
 875:	83 c0 08             	add    $0x8,%eax
}
 878:	8d 65 f4             	lea    -0xc(%ebp),%esp
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret
  if(nu < 4096)
 880:	bb 00 10 00 00       	mov    $0x1000,%ebx
 885:	eb 81                	jmp    808 <malloc+0x34>
 887:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 888:	c7 05 88 09 00 00 8c 	movl   $0x98c,0x988
 88f:	09 00 00 
 892:	c7 05 8c 09 00 00 8c 	movl   $0x98c,0x98c
 899:	09 00 00 
    base.s.size = 0;
 89c:	c7 05 90 09 00 00 00 	movl   $0x0,0x990
 8a3:	00 00 00 
 8a6:	b8 8c 09 00 00       	mov    $0x98c,%eax
 8ab:	e9 4e ff ff ff       	jmp    7fe <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b9                	jmp    86f <malloc+0x9b>
