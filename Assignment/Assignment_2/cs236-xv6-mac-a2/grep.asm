
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
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
  16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 61                	jle    80 <main+0x80>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  1f:	8b 7b 04             	mov    0x4(%ebx),%edi

  if(argc <= 2){
  22:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  26:	74 6b                	je     93 <main+0x93>
  28:	83 c3 08             	add    $0x8,%ebx
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	push   (%ebx)
  37:	e8 bb 04 00 00       	call   4f7 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	78 29                	js     6c <main+0x6c>
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  43:	83 ec 08             	sub    $0x8,%esp
  46:	50                   	push   %eax
  47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  4a:	57                   	push   %edi
  4b:	e8 3c 01 00 00       	call   18c <grep>
    close(fd);
  50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  53:	89 04 24             	mov    %eax,(%esp)
  56:	e8 84 04 00 00       	call   4df <close>
  for(i = 2; i < argc; i++){
  5b:	46                   	inc    %esi
  5c:	83 c3 04             	add    $0x4,%ebx
  5f:	83 c4 10             	add    $0x10,%esp
  62:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  65:	7f c9                	jg     30 <main+0x30>
  }
  exit();
  67:	e8 4b 04 00 00       	call   4b7 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
  6c:	50                   	push   %eax
  6d:	ff 33                	push   (%ebx)
  6f:	68 fc 08 00 00       	push   $0x8fc
  74:	6a 01                	push   $0x1
  76:	e8 81 05 00 00       	call   5fc <printf>
      exit();
  7b:	e8 37 04 00 00       	call   4b7 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  80:	51                   	push   %ecx
  81:	51                   	push   %ecx
  82:	68 dc 08 00 00       	push   $0x8dc
  87:	6a 02                	push   $0x2
  89:	e8 6e 05 00 00       	call   5fc <printf>
    exit();
  8e:	e8 24 04 00 00       	call   4b7 <exit>
    grep(pattern, 0);
  93:	52                   	push   %edx
  94:	52                   	push   %edx
  95:	6a 00                	push   $0x0
  97:	57                   	push   %edi
  98:	e8 ef 00 00 00       	call   18c <grep>
    exit();
  9d:	e8 15 04 00 00       	call   4b7 <exit>
  a2:	66 90                	xchg   %ax,%ax

000000a4 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	56                   	push   %esi
  a8:	53                   	push   %ebx
  a9:	83 ec 10             	sub    $0x10,%esp
  ac:	8b 75 08             	mov    0x8(%ebp),%esi
  af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '\0')
  b2:	8a 16                	mov    (%esi),%dl
  b4:	84 d2                	test   %dl,%dl
  b6:	74 70                	je     128 <matchhere+0x84>
    return 1;
  if(re[1] == '*')
  b8:	8a 46 01             	mov    0x1(%esi),%al
  bb:	3c 2a                	cmp    $0x2a,%al
  bd:	74 24                	je     e3 <matchhere+0x3f>
  bf:	90                   	nop
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  c0:	8a 0b                	mov    (%ebx),%cl
  if(re[0] == '$' && re[1] == '\0')
  c2:	80 fa 24             	cmp    $0x24,%dl
  c5:	74 4d                	je     114 <matchhere+0x70>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  c7:	84 c9                	test   %cl,%cl
  c9:	74 69                	je     134 <matchhere+0x90>
  cb:	80 fa 2e             	cmp    $0x2e,%dl
  ce:	74 04                	je     d4 <matchhere+0x30>
  d0:	38 d1                	cmp    %dl,%cl
  d2:	75 60                	jne    134 <matchhere+0x90>
    return matchhere(re+1, text+1);
  d4:	43                   	inc    %ebx
  d5:	46                   	inc    %esi
  if(re[0] == '\0')
  d6:	84 c0                	test   %al,%al
  d8:	74 4e                	je     128 <matchhere+0x84>
{
  da:	88 c2                	mov    %al,%dl
  if(re[1] == '*')
  dc:	8a 46 01             	mov    0x1(%esi),%al
  df:	3c 2a                	cmp    $0x2a,%al
  e1:	75 dd                	jne    c0 <matchhere+0x1c>
    return matchstar(re[0], re+2, text);
  e3:	83 c6 02             	add    $0x2,%esi
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
  e6:	66 90                	xchg   %ax,%ax
  e8:	88 55 f7             	mov    %dl,-0x9(%ebp)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	53                   	push   %ebx
  ef:	56                   	push   %esi
  f0:	e8 af ff ff ff       	call   a4 <matchhere>
  f5:	83 c4 10             	add    $0x10,%esp
  f8:	85 c0                	test   %eax,%eax
  fa:	75 31                	jne    12d <matchhere+0x89>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  fc:	8a 0b                	mov    (%ebx),%cl
  fe:	84 c9                	test   %cl,%cl
 100:	74 2b                	je     12d <matchhere+0x89>
 102:	43                   	inc    %ebx
 103:	8a 55 f7             	mov    -0x9(%ebp),%dl
 106:	38 ca                	cmp    %cl,%dl
 108:	74 de                	je     e8 <matchhere+0x44>
 10a:	80 fa 2e             	cmp    $0x2e,%dl
 10d:	74 d9                	je     e8 <matchhere+0x44>
 10f:	eb 1c                	jmp    12d <matchhere+0x89>
 111:	8d 76 00             	lea    0x0(%esi),%esi
  if(re[0] == '$' && re[1] == '\0')
 114:	84 c0                	test   %al,%al
 116:	74 25                	je     13d <matchhere+0x99>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 118:	84 c9                	test   %cl,%cl
 11a:	74 18                	je     134 <matchhere+0x90>
 11c:	80 f9 24             	cmp    $0x24,%cl
 11f:	75 13                	jne    134 <matchhere+0x90>
    return matchhere(re+1, text+1);
 121:	43                   	inc    %ebx
 122:	46                   	inc    %esi
{
 123:	88 c2                	mov    %al,%dl
 125:	eb b5                	jmp    dc <matchhere+0x38>
 127:	90                   	nop
    return 1;
 128:	b8 01 00 00 00       	mov    $0x1,%eax
}
 12d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 130:	5b                   	pop    %ebx
 131:	5e                   	pop    %esi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret
  return 0;
 134:	31 c0                	xor    %eax,%eax
}
 136:	8d 65 f8             	lea    -0x8(%ebp),%esp
 139:	5b                   	pop    %ebx
 13a:	5e                   	pop    %esi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret
    return *text == '\0';
 13d:	31 c0                	xor    %eax,%eax
 13f:	84 c9                	test   %cl,%cl
 141:	0f 94 c0             	sete   %al
 144:	eb e7                	jmp    12d <matchhere+0x89>
 146:	66 90                	xchg   %ax,%ax

00000148 <match>:
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	56                   	push   %esi
 14c:	53                   	push   %ebx
 14d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 150:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 153:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 156:	75 0b                	jne    163 <match+0x1b>
 158:	eb 22                	jmp    17c <match+0x34>
 15a:	66 90                	xchg   %ax,%ax
  }while(*text++ != '\0');
 15c:	46                   	inc    %esi
 15d:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 161:	74 11                	je     174 <match+0x2c>
    if(matchhere(re, text))
 163:	83 ec 08             	sub    $0x8,%esp
 166:	56                   	push   %esi
 167:	53                   	push   %ebx
 168:	e8 37 ff ff ff       	call   a4 <matchhere>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	74 e8                	je     15c <match+0x14>
}
 174:	8d 65 f8             	lea    -0x8(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret
 17b:	90                   	nop
    return matchhere(re+1, text);
 17c:	43                   	inc    %ebx
 17d:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 180:	8d 65 f8             	lea    -0x8(%ebp),%esp
 183:	5b                   	pop    %ebx
 184:	5e                   	pop    %esi
 185:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 186:	e9 19 ff ff ff       	jmp    a4 <matchhere>
 18b:	90                   	nop

0000018c <grep>:
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
 190:	56                   	push   %esi
 191:	53                   	push   %ebx
 192:	83 ec 1c             	sub    $0x1c,%esp
 195:	8b 5d 08             	mov    0x8(%ebp),%ebx
  m = 0;
 198:	31 ff                	xor    %edi,%edi
    return matchhere(re+1, text);
 19a:	8d 43 01             	lea    0x1(%ebx),%eax
 19d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 1a0:	89 7d e0             	mov    %edi,-0x20(%ebp)
 1a3:	90                   	nop
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 1a4:	50                   	push   %eax
 1a5:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 1aa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 1ad:	29 c8                	sub    %ecx,%eax
 1af:	50                   	push   %eax
 1b0:	8d 81 a0 09 00 00    	lea    0x9a0(%ecx),%eax
 1b6:	50                   	push   %eax
 1b7:	ff 75 0c             	push   0xc(%ebp)
 1ba:	e8 10 03 00 00       	call   4cf <read>
 1bf:	83 c4 10             	add    $0x10,%esp
 1c2:	85 c0                	test   %eax,%eax
 1c4:	0f 8e e1 00 00 00    	jle    2ab <grep+0x11f>
    m += n;
 1ca:	01 45 e0             	add    %eax,-0x20(%ebp)
 1cd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    buf[m] = '\0';
 1d0:	c6 81 a0 09 00 00 00 	movb   $0x0,0x9a0(%ecx)
    while((q = strchr(p, '\n')) != 0){
 1d7:	bf a0 09 00 00       	mov    $0x9a0,%edi
 1dc:	89 de                	mov    %ebx,%esi
 1de:	66 90                	xchg   %ax,%ax
 1e0:	83 ec 08             	sub    $0x8,%esp
 1e3:	6a 0a                	push   $0xa
 1e5:	57                   	push   %edi
 1e6:	e8 ad 01 00 00       	call   398 <strchr>
 1eb:	89 c2                	mov    %eax,%edx
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	85 c0                	test   %eax,%eax
 1f2:	74 74                	je     268 <grep+0xdc>
      *q = 0;
 1f4:	c6 02 00             	movb   $0x0,(%edx)
  if(re[0] == '^')
 1f7:	80 3e 5e             	cmpb   $0x5e,(%esi)
 1fa:	74 48                	je     244 <grep+0xb8>
 1fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 1ff:	89 d3                	mov    %edx,%ebx
 201:	eb 08                	jmp    20b <grep+0x7f>
 203:	90                   	nop
  }while(*text++ != '\0');
 204:	47                   	inc    %edi
 205:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
 209:	74 31                	je     23c <grep+0xb0>
    if(matchhere(re, text))
 20b:	83 ec 08             	sub    $0x8,%esp
 20e:	57                   	push   %edi
 20f:	56                   	push   %esi
 210:	e8 8f fe ff ff       	call   a4 <matchhere>
 215:	83 c4 10             	add    $0x10,%esp
 218:	85 c0                	test   %eax,%eax
 21a:	74 e8                	je     204 <grep+0x78>
        write(1, p, q+1 - p);
 21c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 21f:	89 da                	mov    %ebx,%edx
 221:	8d 5b 01             	lea    0x1(%ebx),%ebx
        *q = '\n';
 224:	c6 02 0a             	movb   $0xa,(%edx)
        write(1, p, q+1 - p);
 227:	50                   	push   %eax
 228:	89 d8                	mov    %ebx,%eax
 22a:	29 f8                	sub    %edi,%eax
 22c:	50                   	push   %eax
 22d:	57                   	push   %edi
 22e:	6a 01                	push   $0x1
 230:	e8 a2 02 00 00       	call   4d7 <write>
 235:	83 c4 10             	add    $0x10,%esp
 238:	89 df                	mov    %ebx,%edi
 23a:	eb a4                	jmp    1e0 <grep+0x54>
 23c:	8d 7b 01             	lea    0x1(%ebx),%edi
      p = q+1;
 23f:	eb 9f                	jmp    1e0 <grep+0x54>
 241:	8d 76 00             	lea    0x0(%esi),%esi
 244:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return matchhere(re+1, text);
 247:	83 ec 08             	sub    $0x8,%esp
 24a:	57                   	push   %edi
 24b:	ff 75 dc             	push   -0x24(%ebp)
 24e:	e8 51 fe ff ff       	call   a4 <matchhere>
 253:	83 c4 10             	add    $0x10,%esp
        write(1, p, q+1 - p);
 256:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 259:	8d 5a 01             	lea    0x1(%edx),%ebx
      if(match(pattern, p)){
 25c:	85 c0                	test   %eax,%eax
 25e:	75 c4                	jne    224 <grep+0x98>
        write(1, p, q+1 - p);
 260:	89 df                	mov    %ebx,%edi
 262:	e9 79 ff ff ff       	jmp    1e0 <grep+0x54>
 267:	90                   	nop
    if(p == buf)
 268:	89 f3                	mov    %esi,%ebx
 26a:	81 ff a0 09 00 00    	cmp    $0x9a0,%edi
 270:	74 2d                	je     29f <grep+0x113>
    if(m > 0){
 272:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 275:	85 c9                	test   %ecx,%ecx
 277:	0f 8e 27 ff ff ff    	jle    1a4 <grep+0x18>
      m -= p - buf;
 27d:	89 f8                	mov    %edi,%eax
 27f:	2d a0 09 00 00       	sub    $0x9a0,%eax
 284:	29 45 e0             	sub    %eax,-0x20(%ebp)
 287:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      memmove(buf, p, m);
 28a:	52                   	push   %edx
 28b:	51                   	push   %ecx
 28c:	57                   	push   %edi
 28d:	68 a0 09 00 00       	push   $0x9a0
 292:	e8 f5 01 00 00       	call   48c <memmove>
 297:	83 c4 10             	add    $0x10,%esp
 29a:	e9 05 ff ff ff       	jmp    1a4 <grep+0x18>
      m = 0;
 29f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 2a6:	e9 f9 fe ff ff       	jmp    1a4 <grep+0x18>
}
 2ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret
 2b3:	90                   	nop

000002b4 <matchstar>:
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	57                   	push   %edi
 2b8:	56                   	push   %esi
 2b9:	53                   	push   %ebx
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2c0:	8b 75 0c             	mov    0xc(%ebp),%esi
 2c3:	8b 7d 10             	mov    0x10(%ebp),%edi
 2c6:	66 90                	xchg   %ax,%ax
    if(matchhere(re, text))
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	57                   	push   %edi
 2cc:	56                   	push   %esi
 2cd:	e8 d2 fd ff ff       	call   a4 <matchhere>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	75 11                	jne    2ea <matchstar+0x36>
  }while(*text!='\0' && (*text++==c || c=='.'));
 2d9:	0f be 17             	movsbl (%edi),%edx
 2dc:	84 d2                	test   %dl,%dl
 2de:	74 0a                	je     2ea <matchstar+0x36>
 2e0:	47                   	inc    %edi
 2e1:	39 da                	cmp    %ebx,%edx
 2e3:	74 e3                	je     2c8 <matchstar+0x14>
 2e5:	83 fb 2e             	cmp    $0x2e,%ebx
 2e8:	74 de                	je     2c8 <matchstar+0x14>
}
 2ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ed:	5b                   	pop    %ebx
 2ee:	5e                   	pop    %esi
 2ef:	5f                   	pop    %edi
 2f0:	5d                   	pop    %ebp
 2f1:	c3                   	ret
 2f2:	66 90                	xchg   %ax,%ax

000002f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fe:	31 c0                	xor    %eax,%eax
 300:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 303:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 306:	40                   	inc    %eax
 307:	84 d2                	test   %dl,%dl
 309:	75 f5                	jne    300 <strcpy+0xc>
    ;
  return os;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 310:	c9                   	leave
 311:	c3                   	ret
 312:	66 90                	xchg   %ax,%ax

00000314 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
 318:	8b 55 08             	mov    0x8(%ebp),%edx
 31b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 31e:	0f b6 02             	movzbl (%edx),%eax
 321:	84 c0                	test   %al,%al
 323:	75 10                	jne    335 <strcmp+0x21>
 325:	eb 2a                	jmp    351 <strcmp+0x3d>
 327:	90                   	nop
    p++, q++;
 328:	42                   	inc    %edx
 329:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 32c:	0f b6 02             	movzbl (%edx),%eax
 32f:	84 c0                	test   %al,%al
 331:	74 11                	je     344 <strcmp+0x30>
 333:	89 cb                	mov    %ecx,%ebx
 335:	0f b6 0b             	movzbl (%ebx),%ecx
 338:	38 c1                	cmp    %al,%cl
 33a:	74 ec                	je     328 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 33c:	29 c8                	sub    %ecx,%eax
}
 33e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 341:	c9                   	leave
 342:	c3                   	ret
 343:	90                   	nop
  return (uchar)*p - (uchar)*q;
 344:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 348:	31 c0                	xor    %eax,%eax
 34a:	29 c8                	sub    %ecx,%eax
}
 34c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 34f:	c9                   	leave
 350:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 351:	0f b6 0b             	movzbl (%ebx),%ecx
 354:	31 c0                	xor    %eax,%eax
 356:	eb e4                	jmp    33c <strcmp+0x28>

00000358 <strlen>:

uint
strlen(const char *s)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 35e:	80 3a 00             	cmpb   $0x0,(%edx)
 361:	74 15                	je     378 <strlen+0x20>
 363:	31 c0                	xor    %eax,%eax
 365:	8d 76 00             	lea    0x0(%esi),%esi
 368:	40                   	inc    %eax
 369:	89 c1                	mov    %eax,%ecx
 36b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 36f:	75 f7                	jne    368 <strlen+0x10>
    ;
  return n;
}
 371:	89 c8                	mov    %ecx,%eax
 373:	5d                   	pop    %ebp
 374:	c3                   	ret
 375:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 378:	31 c9                	xor    %ecx,%ecx
}
 37a:	89 c8                	mov    %ecx,%eax
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret
 37e:	66 90                	xchg   %ax,%ax

00000380 <memset>:

void*
memset(void *dst, int c, uint n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 384:	8b 7d 08             	mov    0x8(%ebp),%edi
 387:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	fc                   	cld
 38e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8b 7d fc             	mov    -0x4(%ebp),%edi
 396:	c9                   	leave
 397:	c3                   	ret

00000398 <strchr>:

char*
strchr(const char *s, char c)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 3a1:	8a 10                	mov    (%eax),%dl
 3a3:	84 d2                	test   %dl,%dl
 3a5:	75 0c                	jne    3b3 <strchr+0x1b>
 3a7:	eb 13                	jmp    3bc <strchr+0x24>
 3a9:	8d 76 00             	lea    0x0(%esi),%esi
 3ac:	40                   	inc    %eax
 3ad:	8a 10                	mov    (%eax),%dl
 3af:	84 d2                	test   %dl,%dl
 3b1:	74 09                	je     3bc <strchr+0x24>
    if(*s == c)
 3b3:	38 d1                	cmp    %dl,%cl
 3b5:	75 f5                	jne    3ac <strchr+0x14>
      return (char*)s;
  return 0;
}
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret
 3b9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3bc:	31 c0                	xor    %eax,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c9:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 3cb:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
 3ce:	eb 24                	jmp    3f4 <gets+0x34>
    cc = read(0, &c, 1);
 3d0:	50                   	push   %eax
 3d1:	6a 01                	push   $0x1
 3d3:	56                   	push   %esi
 3d4:	6a 00                	push   $0x0
 3d6:	e8 f4 00 00 00       	call   4cf <read>
    if(cc < 1)
 3db:	83 c4 10             	add    $0x10,%esp
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 1a                	jle    3fc <gets+0x3c>
      break;
    buf[i++] = c;
 3e2:	8a 45 e7             	mov    -0x19(%ebp),%al
 3e5:	8b 55 08             	mov    0x8(%ebp),%edx
 3e8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3ec:	3c 0a                	cmp    $0xa,%al
 3ee:	74 0e                	je     3fe <gets+0x3e>
 3f0:	3c 0d                	cmp    $0xd,%al
 3f2:	74 0a                	je     3fe <gets+0x3e>
  for(i=0; i+1 < max; ){
 3f4:	89 df                	mov    %ebx,%edi
 3f6:	43                   	inc    %ebx
 3f7:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3fa:	7c d4                	jl     3d0 <gets+0x10>
 3fc:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 405:	8d 65 f4             	lea    -0xc(%ebp),%esp
 408:	5b                   	pop    %ebx
 409:	5e                   	pop    %esi
 40a:	5f                   	pop    %edi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret
 40d:	8d 76 00             	lea    0x0(%esi),%esi

00000410 <stat>:

int
stat(const char *n, struct stat *st)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 415:	83 ec 08             	sub    $0x8,%esp
 418:	6a 00                	push   $0x0
 41a:	ff 75 08             	push   0x8(%ebp)
 41d:	e8 d5 00 00 00       	call   4f7 <open>
  if(fd < 0)
 422:	83 c4 10             	add    $0x10,%esp
 425:	85 c0                	test   %eax,%eax
 427:	78 27                	js     450 <stat+0x40>
 429:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 42b:	83 ec 08             	sub    $0x8,%esp
 42e:	ff 75 0c             	push   0xc(%ebp)
 431:	50                   	push   %eax
 432:	e8 d8 00 00 00       	call   50f <fstat>
 437:	89 c6                	mov    %eax,%esi
  close(fd);
 439:	89 1c 24             	mov    %ebx,(%esp)
 43c:	e8 9e 00 00 00       	call   4df <close>
  return r;
 441:	83 c4 10             	add    $0x10,%esp
}
 444:	89 f0                	mov    %esi,%eax
 446:	8d 65 f8             	lea    -0x8(%ebp),%esp
 449:	5b                   	pop    %ebx
 44a:	5e                   	pop    %esi
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 450:	be ff ff ff ff       	mov    $0xffffffff,%esi
 455:	eb ed                	jmp    444 <stat+0x34>
 457:	90                   	nop

00000458 <atoi>:

int
atoi(const char *s)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	53                   	push   %ebx
 45c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 45f:	0f be 01             	movsbl (%ecx),%eax
 462:	8d 50 d0             	lea    -0x30(%eax),%edx
 465:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 468:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 46d:	77 16                	ja     485 <atoi+0x2d>
 46f:	90                   	nop
    n = n*10 + *s++ - '0';
 470:	41                   	inc    %ecx
 471:	8d 14 92             	lea    (%edx,%edx,4),%edx
 474:	01 d2                	add    %edx,%edx
 476:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 47a:	0f be 01             	movsbl (%ecx),%eax
 47d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x18>
  return n;
}
 485:	89 d0                	mov    %edx,%eax
 487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 48a:	c9                   	leave
 48b:	c3                   	ret

0000048c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	57                   	push   %edi
 490:	56                   	push   %esi
 491:	8b 55 08             	mov    0x8(%ebp),%edx
 494:	8b 75 0c             	mov    0xc(%ebp),%esi
 497:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49a:	85 c0                	test   %eax,%eax
 49c:	7e 0b                	jle    4a9 <memmove+0x1d>
 49e:	01 d0                	add    %edx,%eax
  dst = vdst;
 4a0:	89 d7                	mov    %edx,%edi
 4a2:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4a4:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4a5:	39 f8                	cmp    %edi,%eax
 4a7:	75 fb                	jne    4a4 <memmove+0x18>
  return vdst;
}
 4a9:	89 d0                	mov    %edx,%eax
 4ab:	5e                   	pop    %esi
 4ac:	5f                   	pop    %edi
 4ad:	5d                   	pop    %ebp
 4ae:	c3                   	ret

000004af <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4af:	b8 01 00 00 00       	mov    $0x1,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret

000004b7 <exit>:
SYSCALL(exit)
 4b7:	b8 02 00 00 00       	mov    $0x2,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret

000004bf <wait>:
SYSCALL(wait)
 4bf:	b8 03 00 00 00       	mov    $0x3,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret

000004c7 <pipe>:
SYSCALL(pipe)
 4c7:	b8 04 00 00 00       	mov    $0x4,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret

000004cf <read>:
SYSCALL(read)
 4cf:	b8 05 00 00 00       	mov    $0x5,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret

000004d7 <write>:
SYSCALL(write)
 4d7:	b8 10 00 00 00       	mov    $0x10,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret

000004df <close>:
SYSCALL(close)
 4df:	b8 15 00 00 00       	mov    $0x15,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret

000004e7 <kill>:
SYSCALL(kill)
 4e7:	b8 06 00 00 00       	mov    $0x6,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret

000004ef <exec>:
SYSCALL(exec)
 4ef:	b8 07 00 00 00       	mov    $0x7,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret

000004f7 <open>:
SYSCALL(open)
 4f7:	b8 0f 00 00 00       	mov    $0xf,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret

000004ff <mknod>:
SYSCALL(mknod)
 4ff:	b8 11 00 00 00       	mov    $0x11,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret

00000507 <unlink>:
SYSCALL(unlink)
 507:	b8 12 00 00 00       	mov    $0x12,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret

0000050f <fstat>:
SYSCALL(fstat)
 50f:	b8 08 00 00 00       	mov    $0x8,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret

00000517 <link>:
SYSCALL(link)
 517:	b8 13 00 00 00       	mov    $0x13,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret

0000051f <mkdir>:
SYSCALL(mkdir)
 51f:	b8 14 00 00 00       	mov    $0x14,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret

00000527 <chdir>:
SYSCALL(chdir)
 527:	b8 09 00 00 00       	mov    $0x9,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret

0000052f <dup>:
SYSCALL(dup)
 52f:	b8 0a 00 00 00       	mov    $0xa,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret

00000537 <getpid>:
SYSCALL(getpid)
 537:	b8 0b 00 00 00       	mov    $0xb,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret

0000053f <sbrk>:
SYSCALL(sbrk)
 53f:	b8 0c 00 00 00       	mov    $0xc,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret

00000547 <sleep>:
SYSCALL(sleep)
 547:	b8 0d 00 00 00       	mov    $0xd,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret

0000054f <uptime>:
SYSCALL(uptime)
 54f:	b8 0e 00 00 00       	mov    $0xe,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret

00000557 <signal>:
SYSCALL(signal)
 557:	b8 16 00 00 00       	mov    $0x16,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret

0000055f <custom_fork>:
SYSCALL(custom_fork)
 55f:	b8 17 00 00 00       	mov    $0x17,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret

00000567 <scheduler_start>:
 567:	b8 18 00 00 00       	mov    $0x18,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret
 56f:	90                   	nop

00000570 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 3c             	sub    $0x3c,%esp
 579:	89 45 c0             	mov    %eax,-0x40(%ebp)
 57c:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 57e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 581:	85 c9                	test   %ecx,%ecx
 583:	74 04                	je     589 <printint+0x19>
 585:	85 d2                	test   %edx,%edx
 587:	78 6b                	js     5f4 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 589:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
 58c:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
 593:	31 c9                	xor    %ecx,%ecx
 595:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 598:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 59b:	31 d2                	xor    %edx,%edx
 59d:	f7 f3                	div    %ebx
 59f:	89 cf                	mov    %ecx,%edi
 5a1:	8d 49 01             	lea    0x1(%ecx),%ecx
 5a4:	8a 92 74 09 00 00    	mov    0x974(%edx),%dl
 5aa:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
 5ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 5b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5b4:	39 da                	cmp    %ebx,%edx
 5b6:	73 e0                	jae    598 <printint+0x28>
  if(neg)
 5b8:	8b 55 08             	mov    0x8(%ebp),%edx
 5bb:	85 d2                	test   %edx,%edx
 5bd:	74 07                	je     5c6 <printint+0x56>
    buf[i++] = '-';
 5bf:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 5c4:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
 5c6:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 5c9:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
 5d0:	8a 07                	mov    (%edi),%al
 5d2:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 5d5:	50                   	push   %eax
 5d6:	6a 01                	push   $0x1
 5d8:	56                   	push   %esi
 5d9:	ff 75 c0             	push   -0x40(%ebp)
 5dc:	e8 f6 fe ff ff       	call   4d7 <write>
  while(--i >= 0)
 5e1:	89 f8                	mov    %edi,%eax
 5e3:	4f                   	dec    %edi
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	39 d8                	cmp    %ebx,%eax
 5e9:	75 e5                	jne    5d0 <printint+0x60>
}
 5eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ee:	5b                   	pop    %ebx
 5ef:	5e                   	pop    %esi
 5f0:	5f                   	pop    %edi
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret
 5f3:	90                   	nop
    x = -xx;
 5f4:	f7 da                	neg    %edx
 5f6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 5f9:	eb 98                	jmp    593 <printint+0x23>
 5fb:	90                   	nop

000005fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	57                   	push   %edi
 600:	56                   	push   %esi
 601:	53                   	push   %ebx
 602:	83 ec 2c             	sub    $0x2c,%esp
 605:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 608:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 60b:	8a 03                	mov    (%ebx),%al
 60d:	84 c0                	test   %al,%al
 60f:	74 2a                	je     63b <printf+0x3f>
 611:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 612:	8d 4d 10             	lea    0x10(%ebp),%ecx
 615:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 618:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
 61b:	83 fa 25             	cmp    $0x25,%edx
 61e:	74 24                	je     644 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
 620:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 623:	50                   	push   %eax
 624:	6a 01                	push   $0x1
 626:	8d 45 e7             	lea    -0x19(%ebp),%eax
 629:	50                   	push   %eax
 62a:	56                   	push   %esi
 62b:	e8 a7 fe ff ff       	call   4d7 <write>
  for(i = 0; fmt[i]; i++){
 630:	43                   	inc    %ebx
 631:	8a 43 ff             	mov    -0x1(%ebx),%al
 634:	83 c4 10             	add    $0x10,%esp
 637:	84 c0                	test   %al,%al
 639:	75 dd                	jne    618 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63e:	5b                   	pop    %ebx
 63f:	5e                   	pop    %esi
 640:	5f                   	pop    %edi
 641:	5d                   	pop    %ebp
 642:	c3                   	ret
 643:	90                   	nop
  for(i = 0; fmt[i]; i++){
 644:	8a 13                	mov    (%ebx),%dl
 646:	84 d2                	test   %dl,%dl
 648:	74 f1                	je     63b <printf+0x3f>
    c = fmt[i] & 0xff;
 64a:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
 64d:	80 fa 25             	cmp    $0x25,%dl
 650:	0f 84 fe 00 00 00    	je     754 <printf+0x158>
 656:	83 e8 63             	sub    $0x63,%eax
 659:	83 f8 15             	cmp    $0x15,%eax
 65c:	77 0a                	ja     668 <printf+0x6c>
 65e:	ff 24 85 1c 09 00 00 	jmp    *0x91c(,%eax,4)
 665:	8d 76 00             	lea    0x0(%esi),%esi
 668:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
 66b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 66f:	50                   	push   %eax
 670:	6a 01                	push   $0x1
 672:	8d 7d e7             	lea    -0x19(%ebp),%edi
 675:	57                   	push   %edi
 676:	56                   	push   %esi
 677:	e8 5b fe ff ff       	call   4d7 <write>
        putc(fd, c);
 67c:	8a 55 d0             	mov    -0x30(%ebp),%dl
 67f:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 682:	83 c4 0c             	add    $0xc,%esp
 685:	6a 01                	push   $0x1
 687:	57                   	push   %edi
 688:	56                   	push   %esi
 689:	e8 49 fe ff ff       	call   4d7 <write>
  for(i = 0; fmt[i]; i++){
 68e:	83 c3 02             	add    $0x2,%ebx
 691:	8a 43 ff             	mov    -0x1(%ebx),%al
 694:	83 c4 10             	add    $0x10,%esp
 697:	84 c0                	test   %al,%al
 699:	0f 85 79 ff ff ff    	jne    618 <printf+0x1c>
}
 69f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a2:	5b                   	pop    %ebx
 6a3:	5e                   	pop    %esi
 6a4:	5f                   	pop    %edi
 6a5:	5d                   	pop    %ebp
 6a6:	c3                   	ret
 6a7:	90                   	nop
        printint(fd, *ap, 16, 0);
 6a8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6ab:	8b 17                	mov    (%edi),%edx
 6ad:	83 ec 0c             	sub    $0xc,%esp
 6b0:	6a 00                	push   $0x0
 6b2:	b9 10 00 00 00       	mov    $0x10,%ecx
 6b7:	89 f0                	mov    %esi,%eax
 6b9:	e8 b2 fe ff ff       	call   570 <printint>
        ap++;
 6be:	83 c7 04             	add    $0x4,%edi
 6c1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 6c4:	eb c8                	jmp    68e <printf+0x92>
 6c6:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
 6c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 6cb:	8b 01                	mov    (%ecx),%eax
        ap++;
 6cd:	83 c1 04             	add    $0x4,%ecx
 6d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 6d3:	85 c0                	test   %eax,%eax
 6d5:	0f 84 89 00 00 00    	je     764 <printf+0x168>
        while(*s != 0){
 6db:	8a 10                	mov    (%eax),%dl
 6dd:	84 d2                	test   %dl,%dl
 6df:	74 29                	je     70a <printf+0x10e>
 6e1:	89 c7                	mov    %eax,%edi
 6e3:	88 d0                	mov    %dl,%al
 6e5:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 6e8:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6eb:	89 fb                	mov    %edi,%ebx
 6ed:	89 cf                	mov    %ecx,%edi
 6ef:	90                   	nop
          putc(fd, *s);
 6f0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f3:	50                   	push   %eax
 6f4:	6a 01                	push   $0x1
 6f6:	57                   	push   %edi
 6f7:	56                   	push   %esi
 6f8:	e8 da fd ff ff       	call   4d7 <write>
          s++;
 6fd:	43                   	inc    %ebx
        while(*s != 0){
 6fe:	8a 03                	mov    (%ebx),%al
 700:	83 c4 10             	add    $0x10,%esp
 703:	84 c0                	test   %al,%al
 705:	75 e9                	jne    6f0 <printf+0xf4>
 707:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 70a:	83 c3 02             	add    $0x2,%ebx
 70d:	8a 43 ff             	mov    -0x1(%ebx),%al
 710:	84 c0                	test   %al,%al
 712:	0f 85 00 ff ff ff    	jne    618 <printf+0x1c>
 718:	e9 1e ff ff ff       	jmp    63b <printf+0x3f>
 71d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 720:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 723:	8b 17                	mov    (%edi),%edx
 725:	83 ec 0c             	sub    $0xc,%esp
 728:	6a 01                	push   $0x1
 72a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 72f:	eb 86                	jmp    6b7 <printf+0xbb>
 731:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 734:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 73c:	51                   	push   %ecx
 73d:	6a 01                	push   $0x1
 73f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 742:	57                   	push   %edi
 743:	56                   	push   %esi
 744:	e8 8e fd ff ff       	call   4d7 <write>
        ap++;
 749:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 74d:	e9 3c ff ff ff       	jmp    68e <printf+0x92>
 752:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 754:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 757:	52                   	push   %edx
 758:	6a 01                	push   $0x1
 75a:	8d 7d e7             	lea    -0x19(%ebp),%edi
 75d:	e9 25 ff ff ff       	jmp    687 <printf+0x8b>
 762:	66 90                	xchg   %ax,%ax
          s = "(null)";
 764:	bf 12 09 00 00       	mov    $0x912,%edi
 769:	b0 28                	mov    $0x28,%al
 76b:	e9 75 ff ff ff       	jmp    6e5 <printf+0xe9>

00000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 779:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77c:	a1 a0 0d 00 00       	mov    0xda0,%eax
 781:	8d 76 00             	lea    0x0(%esi),%esi
 784:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 786:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	39 ca                	cmp    %ecx,%edx
 78a:	73 2c                	jae    7b8 <free+0x48>
 78c:	39 c1                	cmp    %eax,%ecx
 78e:	72 04                	jb     794 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 c2                	cmp    %eax,%edx
 792:	72 f0                	jb     784 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 794:	8b 73 fc             	mov    -0x4(%ebx),%esi
 797:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 79a:	39 f8                	cmp    %edi,%eax
 79c:	74 2c                	je     7ca <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a1:	8b 42 04             	mov    0x4(%edx),%eax
 7a4:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7a7:	39 f1                	cmp    %esi,%ecx
 7a9:	74 36                	je     7e1 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ab:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 7ad:	89 15 a0 0d 00 00    	mov    %edx,0xda0
}
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	39 c2                	cmp    %eax,%edx
 7ba:	72 c8                	jb     784 <free+0x14>
 7bc:	39 c1                	cmp    %eax,%ecx
 7be:	73 c4                	jae    784 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 7c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7c3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7c6:	39 f8                	cmp    %edi,%eax
 7c8:	75 d4                	jne    79e <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 7ca:	03 70 04             	add    0x4(%eax),%esi
 7cd:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	8b 02                	mov    (%edx),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7d7:	8b 42 04             	mov    0x4(%edx),%eax
 7da:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7dd:	39 f1                	cmp    %esi,%ecx
 7df:	75 ca                	jne    7ab <free+0x3b>
    p->s.size += bp->s.size;
 7e1:	03 43 fc             	add    -0x4(%ebx),%eax
 7e4:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7e7:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7ea:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 7ec:	89 15 a0 0d 00 00    	mov    %edx,0xda0
}
 7f2:	5b                   	pop    %ebx
 7f3:	5e                   	pop    %esi
 7f4:	5f                   	pop    %edi
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret
 7f7:	90                   	nop

000007f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f8:	55                   	push   %ebp
 7f9:	89 e5                	mov    %esp,%ebp
 7fb:	57                   	push   %edi
 7fc:	56                   	push   %esi
 7fd:	53                   	push   %ebx
 7fe:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	8d 78 07             	lea    0x7(%eax),%edi
 807:	c1 ef 03             	shr    $0x3,%edi
 80a:	47                   	inc    %edi
  if((prevp = freep) == 0){
 80b:	8b 15 a0 0d 00 00    	mov    0xda0,%edx
 811:	85 d2                	test   %edx,%edx
 813:	0f 84 93 00 00 00    	je     8ac <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 819:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 81b:	8b 48 04             	mov    0x4(%eax),%ecx
 81e:	39 f9                	cmp    %edi,%ecx
 820:	73 62                	jae    884 <malloc+0x8c>
  if(nu < 4096)
 822:	89 fb                	mov    %edi,%ebx
 824:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 82a:	72 78                	jb     8a4 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));
 82c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 833:	eb 0e                	jmp    843 <malloc+0x4b>
 835:	8d 76 00             	lea    0x0(%esi),%esi
 838:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 83c:	8b 48 04             	mov    0x4(%eax),%ecx
 83f:	39 f9                	cmp    %edi,%ecx
 841:	73 41                	jae    884 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 843:	39 05 a0 0d 00 00    	cmp    %eax,0xda0
 849:	75 ed                	jne    838 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 84b:	83 ec 0c             	sub    $0xc,%esp
 84e:	56                   	push   %esi
 84f:	e8 eb fc ff ff       	call   53f <sbrk>
  if(p == (char*)-1)
 854:	83 c4 10             	add    $0x10,%esp
 857:	83 f8 ff             	cmp    $0xffffffff,%eax
 85a:	74 1c                	je     878 <malloc+0x80>
  hp->s.size = nu;
 85c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 85f:	83 ec 0c             	sub    $0xc,%esp
 862:	83 c0 08             	add    $0x8,%eax
 865:	50                   	push   %eax
 866:	e8 05 ff ff ff       	call   770 <free>
  return freep;
 86b:	8b 15 a0 0d 00 00    	mov    0xda0,%edx
      if((p = morecore(nunits)) == 0)
 871:	83 c4 10             	add    $0x10,%esp
 874:	85 d2                	test   %edx,%edx
 876:	75 c2                	jne    83a <malloc+0x42>
        return 0;
 878:	31 c0                	xor    %eax,%eax
  }
}
 87a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 87d:	5b                   	pop    %ebx
 87e:	5e                   	pop    %esi
 87f:	5f                   	pop    %edi
 880:	5d                   	pop    %ebp
 881:	c3                   	ret
 882:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 884:	39 cf                	cmp    %ecx,%edi
 886:	74 4c                	je     8d4 <malloc+0xdc>
        p->s.size -= nunits;
 888:	29 f9                	sub    %edi,%ecx
 88a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 88d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 890:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 893:	89 15 a0 0d 00 00    	mov    %edx,0xda0
      return (void*)(p + 1);
 899:	83 c0 08             	add    $0x8,%eax
}
 89c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 89f:	5b                   	pop    %ebx
 8a0:	5e                   	pop    %esi
 8a1:	5f                   	pop    %edi
 8a2:	5d                   	pop    %ebp
 8a3:	c3                   	ret
  if(nu < 4096)
 8a4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a9:	eb 81                	jmp    82c <malloc+0x34>
 8ab:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 8ac:	c7 05 a0 0d 00 00 a4 	movl   $0xda4,0xda0
 8b3:	0d 00 00 
 8b6:	c7 05 a4 0d 00 00 a4 	movl   $0xda4,0xda4
 8bd:	0d 00 00 
    base.s.size = 0;
 8c0:	c7 05 a8 0d 00 00 00 	movl   $0x0,0xda8
 8c7:	00 00 00 
 8ca:	b8 a4 0d 00 00       	mov    $0xda4,%eax
 8cf:	e9 4e ff ff ff       	jmp    822 <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
 8d4:	8b 08                	mov    (%eax),%ecx
 8d6:	89 0a                	mov    %ecx,(%edx)
 8d8:	eb b9                	jmp    893 <malloc+0x9b>
