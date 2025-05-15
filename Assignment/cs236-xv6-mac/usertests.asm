
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
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
       e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
      11:	68 76 49 00 00       	push   $0x4976
      16:	6a 01                	push   $0x1
      18:	e8 8b 36 00 00       	call   36a8 <printf>

  if(open("usertests.ran", 0) >= 0){
      1d:	59                   	pop    %ecx
      1e:	58                   	pop    %eax
      1f:	6a 00                	push   $0x0
      21:	68 8a 49 00 00       	push   $0x498a
      26:	e8 90 35 00 00       	call   35bb <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	85 c0                	test   %eax,%eax
      30:	78 13                	js     45 <main+0x45>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      32:	52                   	push   %edx
      33:	52                   	push   %edx
      34:	68 fc 50 00 00       	push   $0x50fc
      39:	6a 01                	push   $0x1
      3b:	e8 68 36 00 00       	call   36a8 <printf>
    exit();
      40:	e8 36 35 00 00       	call   357b <exit>
  }
  close(open("usertests.ran", O_CREATE));
      45:	50                   	push   %eax
      46:	50                   	push   %eax
      47:	68 00 02 00 00       	push   $0x200
      4c:	68 8a 49 00 00       	push   $0x498a
      51:	e8 65 35 00 00       	call   35bb <open>
      56:	89 04 24             	mov    %eax,(%esp)
      59:	e8 45 35 00 00       	call   35a3 <close>

  argptest();
      5e:	e8 c9 32 00 00       	call   332c <argptest>
  createdelete();
      63:	e8 7c 10 00 00       	call   10e4 <createdelete>
  linkunlink();
      68:	e8 77 18 00 00       	call   18e4 <linkunlink>
  concreate();
      6d:	e8 ba 15 00 00       	call   162c <concreate>
  fourfiles();
      72:	e8 a1 0e 00 00       	call   f18 <fourfiles>
  sharedfd();
      77:	e8 f8 0c 00 00       	call   d74 <sharedfd>

  bigargtest();
      7c:	e8 93 2f 00 00       	call   3014 <bigargtest>
  bigwrite();
      81:	e8 7e 21 00 00       	call   2204 <bigwrite>
  bigargtest();
      86:	e8 89 2f 00 00       	call   3014 <bigargtest>
  bsstest();
      8b:	e8 24 2f 00 00       	call   2fb4 <bsstest>
  sbrktest();
      90:	e8 4f 2a 00 00       	call   2ae4 <sbrktest>
  validatetest();
      95:	e8 6e 2e 00 00       	call   2f08 <validatetest>

  opentest();
      9a:	e8 35 03 00 00       	call   3d4 <opentest>
  writetest();
      9f:	e8 bc 03 00 00       	call   460 <writetest>
  writetest1();
      a4:	e8 73 05 00 00       	call   61c <writetest1>
  createtest();
      a9:	e8 16 07 00 00       	call   7c4 <createtest>

  openiputtest();
      ae:	e8 31 02 00 00       	call   2e4 <openiputtest>
  exitiputtest();
      b3:	e8 38 01 00 00       	call   1f0 <exitiputtest>
  iputtest();
      b8:	e8 57 00 00 00       	call   114 <iputtest>

  mem();
      bd:	e8 fa 0b 00 00       	call   cbc <mem>
  pipe1();
      c2:	e8 c1 08 00 00       	call   988 <pipe1>
  preempt();
      c7:	e8 38 0a 00 00       	call   b04 <preempt>
  exitwait();
      cc:	e8 73 0b 00 00       	call   c44 <exitwait>

  rmdot();
      d1:	e8 ee 24 00 00       	call   25c4 <rmdot>
  fourteen();
      d6:	e8 b5 23 00 00       	call   2490 <fourteen>
  bigfile();
      db:	e8 f8 21 00 00       	call   22d8 <bigfile>
  subdir();
      e0:	e8 47 1a 00 00       	call   1b2c <subdir>
  linktest();
      e5:	e8 36 13 00 00       	call   1420 <linktest>
  unlinkread();
      ea:	e8 ad 11 00 00       	call   129c <unlinkread>
  dirfile();
      ef:	e8 44 26 00 00       	call   2738 <dirfile>
  iref();
      f4:	e8 37 28 00 00       	call   2930 <iref>
  forktest();
      f9:	e8 4a 29 00 00       	call   2a48 <forktest>
  bigdir(); // slow
      fe:	e8 fd 18 00 00       	call   1a00 <bigdir>

  uio();
     103:	e8 b4 31 00 00       	call   32bc <uio>

  exectest();
     108:	e8 33 08 00 00       	call   940 <exectest>

  exit();
     10d:	e8 69 34 00 00       	call   357b <exit>
     112:	66 90                	xchg   %ax,%ax

00000114 <iputtest>:
{
     114:	55                   	push   %ebp
     115:	89 e5                	mov    %esp,%ebp
     117:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
     11a:	68 1c 3a 00 00       	push   $0x3a1c
     11f:	ff 35 a8 51 00 00    	push   0x51a8
     125:	e8 7e 35 00 00       	call   36a8 <printf>
  if(mkdir("iputdir") < 0){
     12a:	c7 04 24 af 39 00 00 	movl   $0x39af,(%esp)
     131:	e8 ad 34 00 00       	call   35e3 <mkdir>
     136:	83 c4 10             	add    $0x10,%esp
     139:	85 c0                	test   %eax,%eax
     13b:	78 5a                	js     197 <iputtest+0x83>
  if(chdir("iputdir") < 0){
     13d:	83 ec 0c             	sub    $0xc,%esp
     140:	68 af 39 00 00       	push   $0x39af
     145:	e8 a1 34 00 00       	call   35eb <chdir>
     14a:	83 c4 10             	add    $0x10,%esp
     14d:	85 c0                	test   %eax,%eax
     14f:	0f 88 82 00 00 00    	js     1d7 <iputtest+0xc3>
  if(unlink("../iputdir") < 0){
     155:	83 ec 0c             	sub    $0xc,%esp
     158:	68 ac 39 00 00       	push   $0x39ac
     15d:	e8 69 34 00 00       	call   35cb <unlink>
     162:	83 c4 10             	add    $0x10,%esp
     165:	85 c0                	test   %eax,%eax
     167:	78 57                	js     1c0 <iputtest+0xac>
  if(chdir("/") < 0){
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	68 d1 39 00 00       	push   $0x39d1
     171:	e8 75 34 00 00       	call   35eb <chdir>
     176:	89 c2                	mov    %eax,%edx
    printf(stdout, "chdir / failed\n");
     178:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(chdir("/") < 0){
     17d:	83 c4 10             	add    $0x10,%esp
     180:	85 d2                	test   %edx,%edx
     182:	78 2a                	js     1ae <iputtest+0x9a>
  printf(stdout, "iput test ok\n");
     184:	83 ec 08             	sub    $0x8,%esp
     187:	68 54 3a 00 00       	push   $0x3a54
     18c:	50                   	push   %eax
     18d:	e8 16 35 00 00       	call   36a8 <printf>
}
     192:	83 c4 10             	add    $0x10,%esp
     195:	c9                   	leave
     196:	c3                   	ret
    printf(stdout, "mkdir failed\n");
     197:	50                   	push   %eax
     198:	50                   	push   %eax
     199:	68 88 39 00 00       	push   $0x3988
     19e:	ff 35 a8 51 00 00    	push   0x51a8
     1a4:	e8 ff 34 00 00       	call   36a8 <printf>
    exit();
     1a9:	e8 cd 33 00 00       	call   357b <exit>
    printf(stdout, "chdir / failed\n");
     1ae:	52                   	push   %edx
     1af:	52                   	push   %edx
     1b0:	68 d3 39 00 00       	push   $0x39d3
     1b5:	50                   	push   %eax
     1b6:	e8 ed 34 00 00       	call   36a8 <printf>
    exit();
     1bb:	e8 bb 33 00 00       	call   357b <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1c0:	51                   	push   %ecx
     1c1:	51                   	push   %ecx
     1c2:	68 b7 39 00 00       	push   $0x39b7
     1c7:	ff 35 a8 51 00 00    	push   0x51a8
     1cd:	e8 d6 34 00 00       	call   36a8 <printf>
    exit();
     1d2:	e8 a4 33 00 00       	call   357b <exit>
    printf(stdout, "chdir iputdir failed\n");
     1d7:	50                   	push   %eax
     1d8:	50                   	push   %eax
     1d9:	68 96 39 00 00       	push   $0x3996
     1de:	ff 35 a8 51 00 00    	push   0x51a8
     1e4:	e8 bf 34 00 00       	call   36a8 <printf>
    exit();
     1e9:	e8 8d 33 00 00       	call   357b <exit>
     1ee:	66 90                	xchg   %ax,%ax

000001f0 <exitiputtest>:
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     1f6:	68 e3 39 00 00       	push   $0x39e3
     1fb:	ff 35 a8 51 00 00    	push   0x51a8
     201:	e8 a2 34 00 00       	call   36a8 <printf>
  pid = fork();
     206:	e8 68 33 00 00       	call   3573 <fork>
  if(pid < 0){
     20b:	83 c4 10             	add    $0x10,%esp
     20e:	85 c0                	test   %eax,%eax
     210:	0f 88 86 00 00 00    	js     29c <exitiputtest+0xac>
  if(pid == 0){
     216:	75 4c                	jne    264 <exitiputtest+0x74>
    if(mkdir("iputdir") < 0){
     218:	83 ec 0c             	sub    $0xc,%esp
     21b:	68 af 39 00 00       	push   $0x39af
     220:	e8 be 33 00 00       	call   35e3 <mkdir>
     225:	83 c4 10             	add    $0x10,%esp
     228:	85 c0                	test   %eax,%eax
     22a:	0f 88 83 00 00 00    	js     2b3 <exitiputtest+0xc3>
    if(chdir("iputdir") < 0){
     230:	83 ec 0c             	sub    $0xc,%esp
     233:	68 af 39 00 00       	push   $0x39af
     238:	e8 ae 33 00 00       	call   35eb <chdir>
     23d:	83 c4 10             	add    $0x10,%esp
     240:	85 c0                	test   %eax,%eax
     242:	0f 88 82 00 00 00    	js     2ca <exitiputtest+0xda>
    if(unlink("../iputdir") < 0){
     248:	83 ec 0c             	sub    $0xc,%esp
     24b:	68 ac 39 00 00       	push   $0x39ac
     250:	e8 76 33 00 00       	call   35cb <unlink>
     255:	83 c4 10             	add    $0x10,%esp
     258:	85 c0                	test   %eax,%eax
     25a:	78 28                	js     284 <exitiputtest+0x94>
    exit();
     25c:	e8 1a 33 00 00       	call   357b <exit>
     261:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     264:	e8 1a 33 00 00       	call   3583 <wait>
  printf(stdout, "exitiput test ok\n");
     269:	83 ec 08             	sub    $0x8,%esp
     26c:	68 06 3a 00 00       	push   $0x3a06
     271:	ff 35 a8 51 00 00    	push   0x51a8
     277:	e8 2c 34 00 00       	call   36a8 <printf>
}
     27c:	83 c4 10             	add    $0x10,%esp
     27f:	c9                   	leave
     280:	c3                   	ret
     281:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     284:	83 ec 08             	sub    $0x8,%esp
     287:	68 b7 39 00 00       	push   $0x39b7
     28c:	ff 35 a8 51 00 00    	push   0x51a8
     292:	e8 11 34 00 00       	call   36a8 <printf>
      exit();
     297:	e8 df 32 00 00       	call   357b <exit>
    printf(stdout, "fork failed\n");
     29c:	51                   	push   %ecx
     29d:	51                   	push   %ecx
     29e:	68 c9 48 00 00       	push   $0x48c9
     2a3:	ff 35 a8 51 00 00    	push   0x51a8
     2a9:	e8 fa 33 00 00       	call   36a8 <printf>
    exit();
     2ae:	e8 c8 32 00 00       	call   357b <exit>
      printf(stdout, "mkdir failed\n");
     2b3:	52                   	push   %edx
     2b4:	52                   	push   %edx
     2b5:	68 88 39 00 00       	push   $0x3988
     2ba:	ff 35 a8 51 00 00    	push   0x51a8
     2c0:	e8 e3 33 00 00       	call   36a8 <printf>
      exit();
     2c5:	e8 b1 32 00 00       	call   357b <exit>
      printf(stdout, "child chdir failed\n");
     2ca:	50                   	push   %eax
     2cb:	50                   	push   %eax
     2cc:	68 f2 39 00 00       	push   $0x39f2
     2d1:	ff 35 a8 51 00 00    	push   0x51a8
     2d7:	e8 cc 33 00 00       	call   36a8 <printf>
      exit();
     2dc:	e8 9a 32 00 00       	call   357b <exit>
     2e1:	8d 76 00             	lea    0x0(%esi),%esi

000002e4 <openiputtest>:
{
     2e4:	55                   	push   %ebp
     2e5:	89 e5                	mov    %esp,%ebp
     2e7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     2ea:	68 18 3a 00 00       	push   $0x3a18
     2ef:	ff 35 a8 51 00 00    	push   0x51a8
     2f5:	e8 ae 33 00 00       	call   36a8 <printf>
  if(mkdir("oidir") < 0){
     2fa:	c7 04 24 27 3a 00 00 	movl   $0x3a27,(%esp)
     301:	e8 dd 32 00 00       	call   35e3 <mkdir>
     306:	83 c4 10             	add    $0x10,%esp
     309:	85 c0                	test   %eax,%eax
     30b:	0f 88 93 00 00 00    	js     3a4 <openiputtest+0xc0>
  pid = fork();
     311:	e8 5d 32 00 00       	call   3573 <fork>
  if(pid < 0){
     316:	85 c0                	test   %eax,%eax
     318:	78 73                	js     38d <openiputtest+0xa9>
  if(pid == 0){
     31a:	75 30                	jne    34c <openiputtest+0x68>
    int fd = open("oidir", O_RDWR);
     31c:	83 ec 08             	sub    $0x8,%esp
     31f:	6a 02                	push   $0x2
     321:	68 27 3a 00 00       	push   $0x3a27
     326:	e8 90 32 00 00       	call   35bb <open>
    if(fd >= 0){
     32b:	83 c4 10             	add    $0x10,%esp
     32e:	85 c0                	test   %eax,%eax
     330:	78 56                	js     388 <openiputtest+0xa4>
      printf(stdout, "open directory for write succeeded\n");
     332:	83 ec 08             	sub    $0x8,%esp
     335:	68 b0 49 00 00       	push   $0x49b0
     33a:	ff 35 a8 51 00 00    	push   0x51a8
     340:	e8 63 33 00 00       	call   36a8 <printf>
      exit();
     345:	e8 31 32 00 00       	call   357b <exit>
     34a:	66 90                	xchg   %ax,%ax
  sleep(1);
     34c:	83 ec 0c             	sub    $0xc,%esp
     34f:	6a 01                	push   $0x1
     351:	e8 b5 32 00 00       	call   360b <sleep>
  if(unlink("oidir") != 0){
     356:	c7 04 24 27 3a 00 00 	movl   $0x3a27,(%esp)
     35d:	e8 69 32 00 00       	call   35cb <unlink>
     362:	83 c4 10             	add    $0x10,%esp
     365:	85 c0                	test   %eax,%eax
     367:	75 52                	jne    3bb <openiputtest+0xd7>
  wait();
     369:	e8 15 32 00 00       	call   3583 <wait>
  printf(stdout, "openiput test ok\n");
     36e:	83 ec 08             	sub    $0x8,%esp
     371:	68 50 3a 00 00       	push   $0x3a50
     376:	ff 35 a8 51 00 00    	push   0x51a8
     37c:	e8 27 33 00 00       	call   36a8 <printf>
}
     381:	83 c4 10             	add    $0x10,%esp
     384:	c9                   	leave
     385:	c3                   	ret
     386:	66 90                	xchg   %ax,%ax
    exit();
     388:	e8 ee 31 00 00       	call   357b <exit>
    printf(stdout, "fork failed\n");
     38d:	52                   	push   %edx
     38e:	52                   	push   %edx
     38f:	68 c9 48 00 00       	push   $0x48c9
     394:	ff 35 a8 51 00 00    	push   0x51a8
     39a:	e8 09 33 00 00       	call   36a8 <printf>
    exit();
     39f:	e8 d7 31 00 00       	call   357b <exit>
    printf(stdout, "mkdir oidir failed\n");
     3a4:	51                   	push   %ecx
     3a5:	51                   	push   %ecx
     3a6:	68 2d 3a 00 00       	push   $0x3a2d
     3ab:	ff 35 a8 51 00 00    	push   0x51a8
     3b1:	e8 f2 32 00 00       	call   36a8 <printf>
    exit();
     3b6:	e8 c0 31 00 00       	call   357b <exit>
    printf(stdout, "unlink failed\n");
     3bb:	50                   	push   %eax
     3bc:	50                   	push   %eax
     3bd:	68 41 3a 00 00       	push   $0x3a41
     3c2:	ff 35 a8 51 00 00    	push   0x51a8
     3c8:	e8 db 32 00 00       	call   36a8 <printf>
    exit();
     3cd:	e8 a9 31 00 00       	call   357b <exit>
     3d2:	66 90                	xchg   %ax,%ax

000003d4 <opentest>:
{
     3d4:	55                   	push   %ebp
     3d5:	89 e5                	mov    %esp,%ebp
     3d7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     3da:	68 62 3a 00 00       	push   $0x3a62
     3df:	ff 35 a8 51 00 00    	push   0x51a8
     3e5:	e8 be 32 00 00       	call   36a8 <printf>
  fd = open("echo", 0);
     3ea:	58                   	pop    %eax
     3eb:	5a                   	pop    %edx
     3ec:	6a 00                	push   $0x0
     3ee:	68 6d 3a 00 00       	push   $0x3a6d
     3f3:	e8 c3 31 00 00       	call   35bb <open>
  if(fd < 0){
     3f8:	83 c4 10             	add    $0x10,%esp
     3fb:	85 c0                	test   %eax,%eax
     3fd:	78 38                	js     437 <opentest+0x63>
  close(fd);
     3ff:	83 ec 0c             	sub    $0xc,%esp
     402:	50                   	push   %eax
     403:	e8 9b 31 00 00       	call   35a3 <close>
  fd = open("doesnotexist", 0);
     408:	59                   	pop    %ecx
     409:	58                   	pop    %eax
     40a:	6a 00                	push   $0x0
     40c:	68 85 3a 00 00       	push   $0x3a85
     411:	e8 a5 31 00 00       	call   35bb <open>
     416:	89 c2                	mov    %eax,%edx
    printf(stdout, "open doesnotexist succeeded!\n");
     418:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(fd >= 0){
     41d:	83 c4 10             	add    $0x10,%esp
     420:	85 d2                	test   %edx,%edx
     422:	79 2a                	jns    44e <opentest+0x7a>
  printf(stdout, "open test ok\n");
     424:	83 ec 08             	sub    $0x8,%esp
     427:	68 b0 3a 00 00       	push   $0x3ab0
     42c:	50                   	push   %eax
     42d:	e8 76 32 00 00       	call   36a8 <printf>
}
     432:	83 c4 10             	add    $0x10,%esp
     435:	c9                   	leave
     436:	c3                   	ret
    printf(stdout, "open echo failed!\n");
     437:	50                   	push   %eax
     438:	50                   	push   %eax
     439:	68 72 3a 00 00       	push   $0x3a72
     43e:	ff 35 a8 51 00 00    	push   0x51a8
     444:	e8 5f 32 00 00       	call   36a8 <printf>
    exit();
     449:	e8 2d 31 00 00       	call   357b <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     44e:	52                   	push   %edx
     44f:	52                   	push   %edx
     450:	68 92 3a 00 00       	push   $0x3a92
     455:	50                   	push   %eax
     456:	e8 4d 32 00 00       	call   36a8 <printf>
    exit();
     45b:	e8 1b 31 00 00       	call   357b <exit>

00000460 <writetest>:
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	56                   	push   %esi
     464:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     465:	83 ec 08             	sub    $0x8,%esp
     468:	68 be 3a 00 00       	push   $0x3abe
     46d:	ff 35 a8 51 00 00    	push   0x51a8
     473:	e8 30 32 00 00       	call   36a8 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     478:	59                   	pop    %ecx
     479:	5b                   	pop    %ebx
     47a:	68 02 02 00 00       	push   $0x202
     47f:	68 cf 3a 00 00       	push   $0x3acf
     484:	e8 32 31 00 00       	call   35bb <open>
     489:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     48b:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(fd >= 0){
     490:	83 c4 10             	add    $0x10,%esp
     493:	85 f6                	test   %esi,%esi
     495:	0f 88 6d 01 00 00    	js     608 <writetest+0x1a8>
    printf(stdout, "creat small succeeded; ok\n");
     49b:	83 ec 08             	sub    $0x8,%esp
     49e:	68 d5 3a 00 00       	push   $0x3ad5
     4a3:	50                   	push   %eax
     4a4:	e8 ff 31 00 00       	call   36a8 <printf>
     4a9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
     4ac:	31 db                	xor    %ebx,%ebx
     4ae:	66 90                	xchg   %ax,%ax
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4b0:	50                   	push   %eax
     4b1:	6a 0a                	push   $0xa
     4b3:	68 0c 3b 00 00       	push   $0x3b0c
     4b8:	56                   	push   %esi
     4b9:	e8 dd 30 00 00       	call   359b <write>
     4be:	83 c4 10             	add    $0x10,%esp
     4c1:	83 f8 0a             	cmp    $0xa,%eax
     4c4:	0f 85 da 00 00 00    	jne    5a4 <writetest+0x144>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     4ca:	50                   	push   %eax
     4cb:	6a 0a                	push   $0xa
     4cd:	68 17 3b 00 00       	push   $0x3b17
     4d2:	56                   	push   %esi
     4d3:	e8 c3 30 00 00       	call   359b <write>
     4d8:	83 c4 10             	add    $0x10,%esp
     4db:	83 f8 0a             	cmp    $0xa,%eax
     4de:	0f 85 d7 00 00 00    	jne    5bb <writetest+0x15b>
  for(i = 0; i < 100; i++){
     4e4:	43                   	inc    %ebx
     4e5:	83 fb 64             	cmp    $0x64,%ebx
     4e8:	75 c6                	jne    4b0 <writetest+0x50>
  printf(stdout, "writes ok\n");
     4ea:	83 ec 08             	sub    $0x8,%esp
     4ed:	68 22 3b 00 00       	push   $0x3b22
     4f2:	ff 35 a8 51 00 00    	push   0x51a8
     4f8:	e8 ab 31 00 00       	call   36a8 <printf>
  close(fd);
     4fd:	89 34 24             	mov    %esi,(%esp)
     500:	e8 9e 30 00 00       	call   35a3 <close>
  fd = open("small", O_RDONLY);
     505:	5e                   	pop    %esi
     506:	58                   	pop    %eax
     507:	6a 00                	push   $0x0
     509:	68 cf 3a 00 00       	push   $0x3acf
     50e:	e8 a8 30 00 00       	call   35bb <open>
     513:	89 c3                	mov    %eax,%ebx
    printf(stdout, "open small succeeded ok\n");
     515:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(fd >= 0){
     51a:	83 c4 10             	add    $0x10,%esp
     51d:	85 db                	test   %ebx,%ebx
     51f:	0f 88 ad 00 00 00    	js     5d2 <writetest+0x172>
    printf(stdout, "open small succeeded ok\n");
     525:	83 ec 08             	sub    $0x8,%esp
     528:	68 2d 3b 00 00       	push   $0x3b2d
     52d:	50                   	push   %eax
     52e:	e8 75 31 00 00       	call   36a8 <printf>
  i = read(fd, buf, 2000);
     533:	83 c4 0c             	add    $0xc,%esp
     536:	68 d0 07 00 00       	push   $0x7d0
     53b:	68 e0 78 00 00       	push   $0x78e0
     540:	53                   	push   %ebx
     541:	e8 4d 30 00 00       	call   3593 <read>
     546:	89 c2                	mov    %eax,%edx
    printf(stdout, "read succeeded ok\n");
     548:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(i == 2000){
     54d:	83 c4 10             	add    $0x10,%esp
     550:	81 fa d0 07 00 00    	cmp    $0x7d0,%edx
     556:	0f 85 88 00 00 00    	jne    5e4 <writetest+0x184>
    printf(stdout, "read succeeded ok\n");
     55c:	83 ec 08             	sub    $0x8,%esp
     55f:	68 61 3b 00 00       	push   $0x3b61
     564:	50                   	push   %eax
     565:	e8 3e 31 00 00       	call   36a8 <printf>
  close(fd);
     56a:	89 1c 24             	mov    %ebx,(%esp)
     56d:	e8 31 30 00 00       	call   35a3 <close>
  if(unlink("small") < 0){
     572:	c7 04 24 cf 3a 00 00 	movl   $0x3acf,(%esp)
     579:	e8 4d 30 00 00       	call   35cb <unlink>
     57e:	89 c2                	mov    %eax,%edx
    printf(stdout, "unlink small failed\n");
     580:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(unlink("small") < 0){
     585:	83 c4 10             	add    $0x10,%esp
     588:	85 d2                	test   %edx,%edx
     58a:	78 6a                	js     5f6 <writetest+0x196>
  printf(stdout, "small file test ok\n");
     58c:	83 ec 08             	sub    $0x8,%esp
     58f:	68 89 3b 00 00       	push   $0x3b89
     594:	50                   	push   %eax
     595:	e8 0e 31 00 00       	call   36a8 <printf>
}
     59a:	83 c4 10             	add    $0x10,%esp
     59d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5a0:	5b                   	pop    %ebx
     5a1:	5e                   	pop    %esi
     5a2:	5d                   	pop    %ebp
     5a3:	c3                   	ret
      printf(stdout, "error: write aa %d new file failed\n", i);
     5a4:	50                   	push   %eax
     5a5:	53                   	push   %ebx
     5a6:	68 d4 49 00 00       	push   $0x49d4
     5ab:	ff 35 a8 51 00 00    	push   0x51a8
     5b1:	e8 f2 30 00 00       	call   36a8 <printf>
      exit();
     5b6:	e8 c0 2f 00 00       	call   357b <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     5bb:	50                   	push   %eax
     5bc:	53                   	push   %ebx
     5bd:	68 f8 49 00 00       	push   $0x49f8
     5c2:	ff 35 a8 51 00 00    	push   0x51a8
     5c8:	e8 db 30 00 00       	call   36a8 <printf>
      exit();
     5cd:	e8 a9 2f 00 00       	call   357b <exit>
    printf(stdout, "error: open small failed!\n");
     5d2:	53                   	push   %ebx
     5d3:	53                   	push   %ebx
     5d4:	68 46 3b 00 00       	push   $0x3b46
     5d9:	50                   	push   %eax
     5da:	e8 c9 30 00 00       	call   36a8 <printf>
    exit();
     5df:	e8 97 2f 00 00       	call   357b <exit>
    printf(stdout, "read failed\n");
     5e4:	51                   	push   %ecx
     5e5:	51                   	push   %ecx
     5e6:	68 8d 3e 00 00       	push   $0x3e8d
     5eb:	50                   	push   %eax
     5ec:	e8 b7 30 00 00       	call   36a8 <printf>
    exit();
     5f1:	e8 85 2f 00 00       	call   357b <exit>
    printf(stdout, "unlink small failed\n");
     5f6:	52                   	push   %edx
     5f7:	52                   	push   %edx
     5f8:	68 74 3b 00 00       	push   $0x3b74
     5fd:	50                   	push   %eax
     5fe:	e8 a5 30 00 00       	call   36a8 <printf>
    exit();
     603:	e8 73 2f 00 00       	call   357b <exit>
    printf(stdout, "error: creat small failed!\n");
     608:	52                   	push   %edx
     609:	52                   	push   %edx
     60a:	68 f0 3a 00 00       	push   $0x3af0
     60f:	50                   	push   %eax
     610:	e8 93 30 00 00       	call   36a8 <printf>
    exit();
     615:	e8 61 2f 00 00       	call   357b <exit>
     61a:	66 90                	xchg   %ax,%ax

0000061c <writetest1>:
{
     61c:	55                   	push   %ebp
     61d:	89 e5                	mov    %esp,%ebp
     61f:	56                   	push   %esi
     620:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     621:	83 ec 08             	sub    $0x8,%esp
     624:	68 9d 3b 00 00       	push   $0x3b9d
     629:	ff 35 a8 51 00 00    	push   0x51a8
     62f:	e8 74 30 00 00       	call   36a8 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     634:	58                   	pop    %eax
     635:	5a                   	pop    %edx
     636:	68 02 02 00 00       	push   $0x202
     63b:	68 17 3c 00 00       	push   $0x3c17
     640:	e8 76 2f 00 00       	call   35bb <open>
  if(fd < 0){
     645:	83 c4 10             	add    $0x10,%esp
     648:	85 c0                	test   %eax,%eax
     64a:	0f 88 4b 01 00 00    	js     79b <writetest1+0x17f>
     650:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     652:	31 db                	xor    %ebx,%ebx
    ((int*)buf)[0] = i;
     654:	89 1d e0 78 00 00    	mov    %ebx,0x78e0
    if(write(fd, buf, 512) != 512){
     65a:	50                   	push   %eax
     65b:	68 00 02 00 00       	push   $0x200
     660:	68 e0 78 00 00       	push   $0x78e0
     665:	56                   	push   %esi
     666:	e8 30 2f 00 00       	call   359b <write>
     66b:	83 c4 10             	add    $0x10,%esp
     66e:	3d 00 02 00 00       	cmp    $0x200,%eax
     673:	0f 85 ab 00 00 00    	jne    724 <writetest1+0x108>
  for(i = 0; i < MAXFILE; i++){
     679:	43                   	inc    %ebx
     67a:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     680:	75 d2                	jne    654 <writetest1+0x38>
  close(fd);
     682:	83 ec 0c             	sub    $0xc,%esp
     685:	56                   	push   %esi
     686:	e8 18 2f 00 00       	call   35a3 <close>
  fd = open("big", O_RDONLY);
     68b:	58                   	pop    %eax
     68c:	5a                   	pop    %edx
     68d:	6a 00                	push   $0x0
     68f:	68 17 3c 00 00       	push   $0x3c17
     694:	e8 22 2f 00 00       	call   35bb <open>
     699:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     69b:	83 c4 10             	add    $0x10,%esp
     69e:	85 c0                	test   %eax,%eax
     6a0:	0f 88 de 00 00 00    	js     784 <writetest1+0x168>
  n = 0;
     6a6:	31 db                	xor    %ebx,%ebx
     6a8:	eb 17                	jmp    6c1 <writetest1+0xa5>
     6aa:	66 90                	xchg   %ax,%ax
    } else if(i != 512){
     6ac:	3d 00 02 00 00       	cmp    $0x200,%eax
     6b1:	0f 85 9b 00 00 00    	jne    752 <writetest1+0x136>
    if(((int*)buf)[0] != n){
     6b7:	a1 e0 78 00 00       	mov    0x78e0,%eax
     6bc:	39 d8                	cmp    %ebx,%eax
     6be:	75 7b                	jne    73b <writetest1+0x11f>
    n++;
     6c0:	43                   	inc    %ebx
    i = read(fd, buf, 512);
     6c1:	50                   	push   %eax
     6c2:	68 00 02 00 00       	push   $0x200
     6c7:	68 e0 78 00 00       	push   $0x78e0
     6cc:	56                   	push   %esi
     6cd:	e8 c1 2e 00 00       	call   3593 <read>
    if(i == 0){
     6d2:	83 c4 10             	add    $0x10,%esp
     6d5:	85 c0                	test   %eax,%eax
     6d7:	75 d3                	jne    6ac <writetest1+0x90>
      if(n == MAXFILE - 1){
     6d9:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     6df:	0f 84 84 00 00 00    	je     769 <writetest1+0x14d>
  close(fd);
     6e5:	83 ec 0c             	sub    $0xc,%esp
     6e8:	56                   	push   %esi
     6e9:	e8 b5 2e 00 00       	call   35a3 <close>
  if(unlink("big") < 0){
     6ee:	c7 04 24 17 3c 00 00 	movl   $0x3c17,(%esp)
     6f5:	e8 d1 2e 00 00       	call   35cb <unlink>
     6fa:	89 c2                	mov    %eax,%edx
    printf(stdout, "unlink big failed\n");
     6fc:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(unlink("big") < 0){
     701:	83 c4 10             	add    $0x10,%esp
     704:	85 d2                	test   %edx,%edx
     706:	0f 88 a6 00 00 00    	js     7b2 <writetest1+0x196>
  printf(stdout, "big files ok\n");
     70c:	83 ec 08             	sub    $0x8,%esp
     70f:	68 3e 3c 00 00       	push   $0x3c3e
     714:	50                   	push   %eax
     715:	e8 8e 2f 00 00       	call   36a8 <printf>
}
     71a:	83 c4 10             	add    $0x10,%esp
     71d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     720:	5b                   	pop    %ebx
     721:	5e                   	pop    %esi
     722:	5d                   	pop    %ebp
     723:	c3                   	ret
      printf(stdout, "error: write big file failed\n", i);
     724:	51                   	push   %ecx
     725:	53                   	push   %ebx
     726:	68 c7 3b 00 00       	push   $0x3bc7
     72b:	ff 35 a8 51 00 00    	push   0x51a8
     731:	e8 72 2f 00 00       	call   36a8 <printf>
      exit();
     736:	e8 40 2e 00 00       	call   357b <exit>
      printf(stdout, "read content of block %d is %d\n",
     73b:	50                   	push   %eax
     73c:	53                   	push   %ebx
     73d:	68 1c 4a 00 00       	push   $0x4a1c
     742:	ff 35 a8 51 00 00    	push   0x51a8
     748:	e8 5b 2f 00 00       	call   36a8 <printf>
      exit();
     74d:	e8 29 2e 00 00       	call   357b <exit>
      printf(stdout, "read failed %d\n", i);
     752:	51                   	push   %ecx
     753:	50                   	push   %eax
     754:	68 1b 3c 00 00       	push   $0x3c1b
     759:	ff 35 a8 51 00 00    	push   0x51a8
     75f:	e8 44 2f 00 00       	call   36a8 <printf>
      exit();
     764:	e8 12 2e 00 00       	call   357b <exit>
        printf(stdout, "read only %d blocks from big", n);
     769:	53                   	push   %ebx
     76a:	68 8b 00 00 00       	push   $0x8b
     76f:	68 fe 3b 00 00       	push   $0x3bfe
     774:	ff 35 a8 51 00 00    	push   0x51a8
     77a:	e8 29 2f 00 00       	call   36a8 <printf>
        exit();
     77f:	e8 f7 2d 00 00       	call   357b <exit>
    printf(stdout, "error: open big failed!\n");
     784:	50                   	push   %eax
     785:	50                   	push   %eax
     786:	68 e5 3b 00 00       	push   $0x3be5
     78b:	ff 35 a8 51 00 00    	push   0x51a8
     791:	e8 12 2f 00 00       	call   36a8 <printf>
    exit();
     796:	e8 e0 2d 00 00       	call   357b <exit>
    printf(stdout, "error: creat big failed!\n");
     79b:	50                   	push   %eax
     79c:	50                   	push   %eax
     79d:	68 ad 3b 00 00       	push   $0x3bad
     7a2:	ff 35 a8 51 00 00    	push   0x51a8
     7a8:	e8 fb 2e 00 00       	call   36a8 <printf>
    exit();
     7ad:	e8 c9 2d 00 00       	call   357b <exit>
    printf(stdout, "unlink big failed\n");
     7b2:	52                   	push   %edx
     7b3:	52                   	push   %edx
     7b4:	68 2b 3c 00 00       	push   $0x3c2b
     7b9:	50                   	push   %eax
     7ba:	e8 e9 2e 00 00       	call   36a8 <printf>
    exit();
     7bf:	e8 b7 2d 00 00       	call   357b <exit>

000007c4 <createtest>:
{
     7c4:	55                   	push   %ebp
     7c5:	89 e5                	mov    %esp,%ebp
     7c7:	53                   	push   %ebx
     7c8:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     7cb:	68 3c 4a 00 00       	push   $0x4a3c
     7d0:	ff 35 a8 51 00 00    	push   0x51a8
     7d6:	e8 cd 2e 00 00       	call   36a8 <printf>
  name[0] = 'a';
     7db:	c6 05 d0 78 00 00 61 	movb   $0x61,0x78d0
  name[2] = '\0';
     7e2:	c6 05 d2 78 00 00 00 	movb   $0x0,0x78d2
     7e9:	83 c4 10             	add    $0x10,%esp
     7ec:	b3 30                	mov    $0x30,%bl
     7ee:	66 90                	xchg   %ax,%ax
    name[1] = '0' + i;
     7f0:	88 1d d1 78 00 00    	mov    %bl,0x78d1
    fd = open(name, O_CREATE|O_RDWR);
     7f6:	83 ec 08             	sub    $0x8,%esp
     7f9:	68 02 02 00 00       	push   $0x202
     7fe:	68 d0 78 00 00       	push   $0x78d0
     803:	e8 b3 2d 00 00       	call   35bb <open>
    close(fd);
     808:	89 04 24             	mov    %eax,(%esp)
     80b:	e8 93 2d 00 00       	call   35a3 <close>
  for(i = 0; i < 52; i++){
     810:	43                   	inc    %ebx
     811:	83 c4 10             	add    $0x10,%esp
     814:	80 fb 64             	cmp    $0x64,%bl
     817:	75 d7                	jne    7f0 <createtest+0x2c>
  name[0] = 'a';
     819:	c6 05 d0 78 00 00 61 	movb   $0x61,0x78d0
  name[2] = '\0';
     820:	c6 05 d2 78 00 00 00 	movb   $0x0,0x78d2
     827:	b3 30                	mov    $0x30,%bl
     829:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + i;
     82c:	88 1d d1 78 00 00    	mov    %bl,0x78d1
    unlink(name);
     832:	83 ec 0c             	sub    $0xc,%esp
     835:	68 d0 78 00 00       	push   $0x78d0
     83a:	e8 8c 2d 00 00       	call   35cb <unlink>
  for(i = 0; i < 52; i++){
     83f:	43                   	inc    %ebx
     840:	83 c4 10             	add    $0x10,%esp
     843:	80 fb 64             	cmp    $0x64,%bl
     846:	75 e4                	jne    82c <createtest+0x68>
  printf(stdout, "many creates, followed by unlink; ok\n");
     848:	83 ec 08             	sub    $0x8,%esp
     84b:	68 68 4a 00 00       	push   $0x4a68
     850:	ff 35 a8 51 00 00    	push   0x51a8
     856:	e8 4d 2e 00 00       	call   36a8 <printf>
}
     85b:	83 c4 10             	add    $0x10,%esp
     85e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     861:	c9                   	leave
     862:	c3                   	ret
     863:	90                   	nop

00000864 <dirtest>:
{
     864:	55                   	push   %ebp
     865:	89 e5                	mov    %esp,%ebp
     867:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     86a:	68 4c 3c 00 00       	push   $0x3c4c
     86f:	ff 35 a8 51 00 00    	push   0x51a8
     875:	e8 2e 2e 00 00       	call   36a8 <printf>
  if(mkdir("dir0") < 0){
     87a:	c7 04 24 58 3c 00 00 	movl   $0x3c58,(%esp)
     881:	e8 5d 2d 00 00       	call   35e3 <mkdir>
     886:	83 c4 10             	add    $0x10,%esp
     889:	85 c0                	test   %eax,%eax
     88b:	78 5a                	js     8e7 <dirtest+0x83>
  if(chdir("dir0") < 0){
     88d:	83 ec 0c             	sub    $0xc,%esp
     890:	68 58 3c 00 00       	push   $0x3c58
     895:	e8 51 2d 00 00       	call   35eb <chdir>
     89a:	83 c4 10             	add    $0x10,%esp
     89d:	85 c0                	test   %eax,%eax
     89f:	0f 88 82 00 00 00    	js     927 <dirtest+0xc3>
  if(chdir("..") < 0){
     8a5:	83 ec 0c             	sub    $0xc,%esp
     8a8:	68 fd 41 00 00       	push   $0x41fd
     8ad:	e8 39 2d 00 00       	call   35eb <chdir>
     8b2:	83 c4 10             	add    $0x10,%esp
     8b5:	85 c0                	test   %eax,%eax
     8b7:	78 57                	js     910 <dirtest+0xac>
  if(unlink("dir0") < 0){
     8b9:	83 ec 0c             	sub    $0xc,%esp
     8bc:	68 58 3c 00 00       	push   $0x3c58
     8c1:	e8 05 2d 00 00       	call   35cb <unlink>
     8c6:	89 c2                	mov    %eax,%edx
    printf(stdout, "unlink dir0 failed\n");
     8c8:	a1 a8 51 00 00       	mov    0x51a8,%eax
  if(unlink("dir0") < 0){
     8cd:	83 c4 10             	add    $0x10,%esp
     8d0:	85 d2                	test   %edx,%edx
     8d2:	78 2a                	js     8fe <dirtest+0x9a>
  printf(stdout, "mkdir test ok\n");
     8d4:	83 ec 08             	sub    $0x8,%esp
     8d7:	68 95 3c 00 00       	push   $0x3c95
     8dc:	50                   	push   %eax
     8dd:	e8 c6 2d 00 00       	call   36a8 <printf>
}
     8e2:	83 c4 10             	add    $0x10,%esp
     8e5:	c9                   	leave
     8e6:	c3                   	ret
    printf(stdout, "mkdir failed\n");
     8e7:	50                   	push   %eax
     8e8:	50                   	push   %eax
     8e9:	68 88 39 00 00       	push   $0x3988
     8ee:	ff 35 a8 51 00 00    	push   0x51a8
     8f4:	e8 af 2d 00 00       	call   36a8 <printf>
    exit();
     8f9:	e8 7d 2c 00 00       	call   357b <exit>
    printf(stdout, "unlink dir0 failed\n");
     8fe:	52                   	push   %edx
     8ff:	52                   	push   %edx
     900:	68 81 3c 00 00       	push   $0x3c81
     905:	50                   	push   %eax
     906:	e8 9d 2d 00 00       	call   36a8 <printf>
    exit();
     90b:	e8 6b 2c 00 00       	call   357b <exit>
    printf(stdout, "chdir .. failed\n");
     910:	51                   	push   %ecx
     911:	51                   	push   %ecx
     912:	68 70 3c 00 00       	push   $0x3c70
     917:	ff 35 a8 51 00 00    	push   0x51a8
     91d:	e8 86 2d 00 00       	call   36a8 <printf>
    exit();
     922:	e8 54 2c 00 00       	call   357b <exit>
    printf(stdout, "chdir dir0 failed\n");
     927:	50                   	push   %eax
     928:	50                   	push   %eax
     929:	68 5d 3c 00 00       	push   $0x3c5d
     92e:	ff 35 a8 51 00 00    	push   0x51a8
     934:	e8 6f 2d 00 00       	call   36a8 <printf>
    exit();
     939:	e8 3d 2c 00 00       	call   357b <exit>
     93e:	66 90                	xchg   %ax,%ax

00000940 <exectest>:
{
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     946:	68 a4 3c 00 00       	push   $0x3ca4
     94b:	ff 35 a8 51 00 00    	push   0x51a8
     951:	e8 52 2d 00 00       	call   36a8 <printf>
  if(exec("echo", echoargv) < 0){
     956:	5a                   	pop    %edx
     957:	59                   	pop    %ecx
     958:	68 ac 51 00 00       	push   $0x51ac
     95d:	68 6d 3a 00 00       	push   $0x3a6d
     962:	e8 4c 2c 00 00       	call   35b3 <exec>
     967:	83 c4 10             	add    $0x10,%esp
     96a:	85 c0                	test   %eax,%eax
     96c:	78 02                	js     970 <exectest+0x30>
}
     96e:	c9                   	leave
     96f:	c3                   	ret
    printf(stdout, "exec echo failed\n");
     970:	50                   	push   %eax
     971:	50                   	push   %eax
     972:	68 af 3c 00 00       	push   $0x3caf
     977:	ff 35 a8 51 00 00    	push   0x51a8
     97d:	e8 26 2d 00 00       	call   36a8 <printf>
    exit();
     982:	e8 f4 2b 00 00       	call   357b <exit>
     987:	90                   	nop

00000988 <pipe1>:
{
     988:	55                   	push   %ebp
     989:	89 e5                	mov    %esp,%ebp
     98b:	57                   	push   %edi
     98c:	56                   	push   %esi
     98d:	53                   	push   %ebx
     98e:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     991:	8d 45 e0             	lea    -0x20(%ebp),%eax
     994:	50                   	push   %eax
     995:	e8 f1 2b 00 00       	call   358b <pipe>
     99a:	83 c4 10             	add    $0x10,%esp
     99d:	85 c0                	test   %eax,%eax
     99f:	0f 85 24 01 00 00    	jne    ac9 <pipe1+0x141>
  pid = fork();
     9a5:	e8 c9 2b 00 00       	call   3573 <fork>
  if(pid == 0){
     9aa:	85 c0                	test   %eax,%eax
     9ac:	0f 84 80 00 00 00    	je     a32 <pipe1+0xaa>
  } else if(pid > 0){
     9b2:	0f 8e 24 01 00 00    	jle    adc <pipe1+0x154>
    close(fds[1]);
     9b8:	83 ec 0c             	sub    $0xc,%esp
     9bb:	ff 75 e4             	push   -0x1c(%ebp)
     9be:	e8 e0 2b 00 00       	call   35a3 <close>
    while((n = read(fds[0], buf, cc)) > 0){
     9c3:	83 c4 10             	add    $0x10,%esp
    total = 0;
     9c6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  seq = 0;
     9cd:	31 db                	xor    %ebx,%ebx
    cc = 1;
     9cf:	be 01 00 00 00       	mov    $0x1,%esi
    while((n = read(fds[0], buf, cc)) > 0){
     9d4:	57                   	push   %edi
     9d5:	56                   	push   %esi
     9d6:	68 e0 78 00 00       	push   $0x78e0
     9db:	ff 75 e0             	push   -0x20(%ebp)
     9de:	e8 b0 2b 00 00       	call   3593 <read>
     9e3:	83 c4 10             	add    $0x10,%esp
     9e6:	85 c0                	test   %eax,%eax
     9e8:	0f 8e 97 00 00 00    	jle    a85 <pipe1+0xfd>
     9ee:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
      for(i = 0; i < n; i++){
     9f1:	31 d2                	xor    %edx,%edx
     9f3:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     9f4:	89 d9                	mov    %ebx,%ecx
     9f6:	43                   	inc    %ebx
     9f7:	38 8a e0 78 00 00    	cmp    %cl,0x78e0(%edx)
     9fd:	75 19                	jne    a18 <pipe1+0x90>
      for(i = 0; i < n; i++){
     9ff:	42                   	inc    %edx
     a00:	39 fb                	cmp    %edi,%ebx
     a02:	75 f0                	jne    9f4 <pipe1+0x6c>
      total += n;
     a04:	01 45 d4             	add    %eax,-0x2c(%ebp)
      if(cc > sizeof(buf))
     a07:	01 f6                	add    %esi,%esi
     a09:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
     a0f:	7e c3                	jle    9d4 <pipe1+0x4c>
     a11:	be 00 20 00 00       	mov    $0x2000,%esi
     a16:	eb bc                	jmp    9d4 <pipe1+0x4c>
          printf(1, "pipe1 oops 2\n");
     a18:	83 ec 08             	sub    $0x8,%esp
     a1b:	68 de 3c 00 00       	push   $0x3cde
     a20:	6a 01                	push   $0x1
     a22:	e8 81 2c 00 00       	call   36a8 <printf>
     a27:	83 c4 10             	add    $0x10,%esp
}
     a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a2d:	5b                   	pop    %ebx
     a2e:	5e                   	pop    %esi
     a2f:	5f                   	pop    %edi
     a30:	5d                   	pop    %ebp
     a31:	c3                   	ret
    close(fds[0]);
     a32:	83 ec 0c             	sub    $0xc,%esp
     a35:	ff 75 e0             	push   -0x20(%ebp)
     a38:	e8 66 2b 00 00       	call   35a3 <close>
     a3d:	83 c4 10             	add    $0x10,%esp
  seq = 0;
     a40:	31 db                	xor    %ebx,%ebx
      for(i = 0; i < 1033; i++)
     a42:	31 c0                	xor    %eax,%eax
        buf[i] = seq++;
     a44:	8d 14 18             	lea    (%eax,%ebx,1),%edx
     a47:	88 90 e0 78 00 00    	mov    %dl,0x78e0(%eax)
      for(i = 0; i < 1033; i++)
     a4d:	40                   	inc    %eax
     a4e:	3d 09 04 00 00       	cmp    $0x409,%eax
     a53:	75 ef                	jne    a44 <pipe1+0xbc>
     a55:	81 c3 09 04 00 00    	add    $0x409,%ebx
      if(write(fds[1], buf, 1033) != 1033){
     a5b:	50                   	push   %eax
     a5c:	68 09 04 00 00       	push   $0x409
     a61:	68 e0 78 00 00       	push   $0x78e0
     a66:	ff 75 e4             	push   -0x1c(%ebp)
     a69:	e8 2d 2b 00 00       	call   359b <write>
     a6e:	83 c4 10             	add    $0x10,%esp
     a71:	3d 09 04 00 00       	cmp    $0x409,%eax
     a76:	75 77                	jne    aef <pipe1+0x167>
    for(n = 0; n < 5; n++){
     a78:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     a7e:	75 c2                	jne    a42 <pipe1+0xba>
    exit();
     a80:	e8 f6 2a 00 00       	call   357b <exit>
    if(total != 5 * 1033){
     a85:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     a8c:	75 26                	jne    ab4 <pipe1+0x12c>
    close(fds[0]);
     a8e:	83 ec 0c             	sub    $0xc,%esp
     a91:	ff 75 e0             	push   -0x20(%ebp)
     a94:	e8 0a 2b 00 00       	call   35a3 <close>
    wait();
     a99:	e8 e5 2a 00 00       	call   3583 <wait>
  printf(1, "pipe1 ok\n");
     a9e:	5a                   	pop    %edx
     a9f:	59                   	pop    %ecx
     aa0:	68 03 3d 00 00       	push   $0x3d03
     aa5:	6a 01                	push   $0x1
     aa7:	e8 fc 2b 00 00       	call   36a8 <printf>
     aac:	83 c4 10             	add    $0x10,%esp
     aaf:	e9 76 ff ff ff       	jmp    a2a <pipe1+0xa2>
      printf(1, "pipe1 oops 3 total %d\n", total);
     ab4:	53                   	push   %ebx
     ab5:	ff 75 d4             	push   -0x2c(%ebp)
     ab8:	68 ec 3c 00 00       	push   $0x3cec
     abd:	6a 01                	push   $0x1
     abf:	e8 e4 2b 00 00       	call   36a8 <printf>
      exit();
     ac4:	e8 b2 2a 00 00       	call   357b <exit>
    printf(1, "pipe() failed\n");
     ac9:	50                   	push   %eax
     aca:	50                   	push   %eax
     acb:	68 c1 3c 00 00       	push   $0x3cc1
     ad0:	6a 01                	push   $0x1
     ad2:	e8 d1 2b 00 00       	call   36a8 <printf>
    exit();
     ad7:	e8 9f 2a 00 00       	call   357b <exit>
    printf(1, "fork() failed\n");
     adc:	50                   	push   %eax
     add:	50                   	push   %eax
     ade:	68 0d 3d 00 00       	push   $0x3d0d
     ae3:	6a 01                	push   $0x1
     ae5:	e8 be 2b 00 00       	call   36a8 <printf>
    exit();
     aea:	e8 8c 2a 00 00       	call   357b <exit>
        printf(1, "pipe1 oops 1\n");
     aef:	50                   	push   %eax
     af0:	50                   	push   %eax
     af1:	68 d0 3c 00 00       	push   $0x3cd0
     af6:	6a 01                	push   $0x1
     af8:	e8 ab 2b 00 00       	call   36a8 <printf>
        exit();
     afd:	e8 79 2a 00 00       	call   357b <exit>
     b02:	66 90                	xchg   %ax,%ax

00000b04 <preempt>:
{
     b04:	55                   	push   %ebp
     b05:	89 e5                	mov    %esp,%ebp
     b07:	57                   	push   %edi
     b08:	56                   	push   %esi
     b09:	53                   	push   %ebx
     b0a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     b0d:	68 1c 3d 00 00       	push   $0x3d1c
     b12:	6a 01                	push   $0x1
     b14:	e8 8f 2b 00 00       	call   36a8 <printf>
  pid1 = fork();
     b19:	e8 55 2a 00 00       	call   3573 <fork>
  if(pid1 == 0)
     b1e:	83 c4 10             	add    $0x10,%esp
     b21:	85 c0                	test   %eax,%eax
     b23:	75 03                	jne    b28 <preempt+0x24>
    for(;;)
     b25:	eb fe                	jmp    b25 <preempt+0x21>
     b27:	90                   	nop
     b28:	89 c3                	mov    %eax,%ebx
  pid2 = fork();
     b2a:	e8 44 2a 00 00       	call   3573 <fork>
     b2f:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     b31:	85 c0                	test   %eax,%eax
     b33:	75 03                	jne    b38 <preempt+0x34>
    for(;;)
     b35:	eb fe                	jmp    b35 <preempt+0x31>
     b37:	90                   	nop
  pipe(pfds);
     b38:	83 ec 0c             	sub    $0xc,%esp
     b3b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b3e:	50                   	push   %eax
     b3f:	e8 47 2a 00 00       	call   358b <pipe>
  pid3 = fork();
     b44:	e8 2a 2a 00 00       	call   3573 <fork>
     b49:	89 c7                	mov    %eax,%edi
  if(pid3 == 0){
     b4b:	83 c4 10             	add    $0x10,%esp
     b4e:	85 c0                	test   %eax,%eax
     b50:	75 3a                	jne    b8c <preempt+0x88>
    close(pfds[0]);
     b52:	83 ec 0c             	sub    $0xc,%esp
     b55:	ff 75 e0             	push   -0x20(%ebp)
     b58:	e8 46 2a 00 00       	call   35a3 <close>
    if(write(pfds[1], "x", 1) != 1)
     b5d:	83 c4 0c             	add    $0xc,%esp
     b60:	6a 01                	push   $0x1
     b62:	68 e1 42 00 00       	push   $0x42e1
     b67:	ff 75 e4             	push   -0x1c(%ebp)
     b6a:	e8 2c 2a 00 00       	call   359b <write>
     b6f:	83 c4 10             	add    $0x10,%esp
     b72:	48                   	dec    %eax
     b73:	0f 85 b4 00 00 00    	jne    c2d <preempt+0x129>
    close(pfds[1]);
     b79:	83 ec 0c             	sub    $0xc,%esp
     b7c:	ff 75 e4             	push   -0x1c(%ebp)
     b7f:	e8 1f 2a 00 00       	call   35a3 <close>
     b84:	83 c4 10             	add    $0x10,%esp
    for(;;)
     b87:	eb fe                	jmp    b87 <preempt+0x83>
     b89:	8d 76 00             	lea    0x0(%esi),%esi
  close(pfds[1]);
     b8c:	83 ec 0c             	sub    $0xc,%esp
     b8f:	ff 75 e4             	push   -0x1c(%ebp)
     b92:	e8 0c 2a 00 00       	call   35a3 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     b97:	83 c4 0c             	add    $0xc,%esp
     b9a:	68 00 20 00 00       	push   $0x2000
     b9f:	68 e0 78 00 00       	push   $0x78e0
     ba4:	ff 75 e0             	push   -0x20(%ebp)
     ba7:	e8 e7 29 00 00       	call   3593 <read>
     bac:	83 c4 10             	add    $0x10,%esp
     baf:	48                   	dec    %eax
     bb0:	75 67                	jne    c19 <preempt+0x115>
  close(pfds[0]);
     bb2:	83 ec 0c             	sub    $0xc,%esp
     bb5:	ff 75 e0             	push   -0x20(%ebp)
     bb8:	e8 e6 29 00 00       	call   35a3 <close>
  printf(1, "kill... ");
     bbd:	58                   	pop    %eax
     bbe:	5a                   	pop    %edx
     bbf:	68 4d 3d 00 00       	push   $0x3d4d
     bc4:	6a 01                	push   $0x1
     bc6:	e8 dd 2a 00 00       	call   36a8 <printf>
  kill(pid1);
     bcb:	89 1c 24             	mov    %ebx,(%esp)
     bce:	e8 d8 29 00 00       	call   35ab <kill>
  kill(pid2);
     bd3:	89 34 24             	mov    %esi,(%esp)
     bd6:	e8 d0 29 00 00       	call   35ab <kill>
  kill(pid3);
     bdb:	89 3c 24             	mov    %edi,(%esp)
     bde:	e8 c8 29 00 00       	call   35ab <kill>
  printf(1, "wait... ");
     be3:	59                   	pop    %ecx
     be4:	5b                   	pop    %ebx
     be5:	68 56 3d 00 00       	push   $0x3d56
     bea:	6a 01                	push   $0x1
     bec:	e8 b7 2a 00 00       	call   36a8 <printf>
  wait();
     bf1:	e8 8d 29 00 00       	call   3583 <wait>
  wait();
     bf6:	e8 88 29 00 00       	call   3583 <wait>
  wait();
     bfb:	e8 83 29 00 00       	call   3583 <wait>
  printf(1, "preempt ok\n");
     c00:	5e                   	pop    %esi
     c01:	5f                   	pop    %edi
     c02:	68 5f 3d 00 00       	push   $0x3d5f
     c07:	6a 01                	push   $0x1
     c09:	e8 9a 2a 00 00       	call   36a8 <printf>
     c0e:	83 c4 10             	add    $0x10,%esp
}
     c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c14:	5b                   	pop    %ebx
     c15:	5e                   	pop    %esi
     c16:	5f                   	pop    %edi
     c17:	5d                   	pop    %ebp
     c18:	c3                   	ret
    printf(1, "preempt read error");
     c19:	83 ec 08             	sub    $0x8,%esp
     c1c:	68 3a 3d 00 00       	push   $0x3d3a
     c21:	6a 01                	push   $0x1
     c23:	e8 80 2a 00 00       	call   36a8 <printf>
     c28:	83 c4 10             	add    $0x10,%esp
     c2b:	eb e4                	jmp    c11 <preempt+0x10d>
      printf(1, "preempt write error");
     c2d:	83 ec 08             	sub    $0x8,%esp
     c30:	68 26 3d 00 00       	push   $0x3d26
     c35:	6a 01                	push   $0x1
     c37:	e8 6c 2a 00 00       	call   36a8 <printf>
     c3c:	83 c4 10             	add    $0x10,%esp
     c3f:	e9 35 ff ff ff       	jmp    b79 <preempt+0x75>

00000c44 <exitwait>:
{
     c44:	55                   	push   %ebp
     c45:	89 e5                	mov    %esp,%ebp
     c47:	56                   	push   %esi
     c48:	53                   	push   %ebx
     c49:	be 64 00 00 00       	mov    $0x64,%esi
     c4e:	eb 0e                	jmp    c5e <exitwait+0x1a>
    if(pid){
     c50:	74 64                	je     cb6 <exitwait+0x72>
      if(wait() != pid){
     c52:	e8 2c 29 00 00       	call   3583 <wait>
     c57:	39 d8                	cmp    %ebx,%eax
     c59:	75 29                	jne    c84 <exitwait+0x40>
  for(i = 0; i < 100; i++){
     c5b:	4e                   	dec    %esi
     c5c:	74 3f                	je     c9d <exitwait+0x59>
    pid = fork();
     c5e:	e8 10 29 00 00       	call   3573 <fork>
     c63:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     c65:	85 c0                	test   %eax,%eax
     c67:	79 e7                	jns    c50 <exitwait+0xc>
      printf(1, "fork failed\n");
     c69:	83 ec 08             	sub    $0x8,%esp
     c6c:	68 c9 48 00 00       	push   $0x48c9
     c71:	6a 01                	push   $0x1
     c73:	e8 30 2a 00 00       	call   36a8 <printf>
      return;
     c78:	83 c4 10             	add    $0x10,%esp
}
     c7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c7e:	5b                   	pop    %ebx
     c7f:	5e                   	pop    %esi
     c80:	5d                   	pop    %ebp
     c81:	c3                   	ret
     c82:	66 90                	xchg   %ax,%ax
        printf(1, "wait wrong pid\n");
     c84:	83 ec 08             	sub    $0x8,%esp
     c87:	68 6b 3d 00 00       	push   $0x3d6b
     c8c:	6a 01                	push   $0x1
     c8e:	e8 15 2a 00 00       	call   36a8 <printf>
        return;
     c93:	83 c4 10             	add    $0x10,%esp
}
     c96:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c99:	5b                   	pop    %ebx
     c9a:	5e                   	pop    %esi
     c9b:	5d                   	pop    %ebp
     c9c:	c3                   	ret
  printf(1, "exitwait ok\n");
     c9d:	83 ec 08             	sub    $0x8,%esp
     ca0:	68 7b 3d 00 00       	push   $0x3d7b
     ca5:	6a 01                	push   $0x1
     ca7:	e8 fc 29 00 00       	call   36a8 <printf>
     cac:	83 c4 10             	add    $0x10,%esp
}
     caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cb2:	5b                   	pop    %ebx
     cb3:	5e                   	pop    %esi
     cb4:	5d                   	pop    %ebp
     cb5:	c3                   	ret
      exit();
     cb6:	e8 c0 28 00 00       	call   357b <exit>
     cbb:	90                   	nop

00000cbc <mem>:
{
     cbc:	55                   	push   %ebp
     cbd:	89 e5                	mov    %esp,%ebp
     cbf:	56                   	push   %esi
     cc0:	53                   	push   %ebx
  printf(1, "mem test\n");
     cc1:	83 ec 08             	sub    $0x8,%esp
     cc4:	68 88 3d 00 00       	push   $0x3d88
     cc9:	6a 01                	push   $0x1
     ccb:	e8 d8 29 00 00       	call   36a8 <printf>
  ppid = getpid();
     cd0:	e8 26 29 00 00       	call   35fb <getpid>
     cd5:	89 c3                	mov    %eax,%ebx
  if((pid = fork()) == 0){
     cd7:	e8 97 28 00 00       	call   3573 <fork>
     cdc:	83 c4 10             	add    $0x10,%esp
     cdf:	85 c0                	test   %eax,%eax
     ce1:	0f 85 81 00 00 00    	jne    d68 <mem+0xac>
    m1 = 0;
     ce7:	31 f6                	xor    %esi,%esi
     ce9:	eb 05                	jmp    cf0 <mem+0x34>
     ceb:	90                   	nop
      *(char**)m2 = m1;
     cec:	89 30                	mov    %esi,(%eax)
      m1 = m2;
     cee:	89 c6                	mov    %eax,%esi
    while((m2 = malloc(10001)) != 0){
     cf0:	83 ec 0c             	sub    $0xc,%esp
     cf3:	68 11 27 00 00       	push   $0x2711
     cf8:	e8 a7 2b 00 00       	call   38a4 <malloc>
     cfd:	83 c4 10             	add    $0x10,%esp
     d00:	85 c0                	test   %eax,%eax
     d02:	75 e8                	jne    cec <mem+0x30>
    while(m1){
     d04:	85 f6                	test   %esi,%esi
     d06:	74 14                	je     d1c <mem+0x60>
      m2 = *(char**)m1;
     d08:	89 f0                	mov    %esi,%eax
     d0a:	8b 36                	mov    (%esi),%esi
      free(m1);
     d0c:	83 ec 0c             	sub    $0xc,%esp
     d0f:	50                   	push   %eax
     d10:	e8 07 2b 00 00       	call   381c <free>
    while(m1){
     d15:	83 c4 10             	add    $0x10,%esp
     d18:	85 f6                	test   %esi,%esi
     d1a:	75 ec                	jne    d08 <mem+0x4c>
    m1 = malloc(1024*20);
     d1c:	83 ec 0c             	sub    $0xc,%esp
     d1f:	68 00 50 00 00       	push   $0x5000
     d24:	e8 7b 2b 00 00       	call   38a4 <malloc>
    if(m1 == 0){
     d29:	83 c4 10             	add    $0x10,%esp
     d2c:	85 c0                	test   %eax,%eax
     d2e:	74 1c                	je     d4c <mem+0x90>
    free(m1);
     d30:	83 ec 0c             	sub    $0xc,%esp
     d33:	50                   	push   %eax
     d34:	e8 e3 2a 00 00       	call   381c <free>
    printf(1, "mem ok\n");
     d39:	58                   	pop    %eax
     d3a:	5a                   	pop    %edx
     d3b:	68 ac 3d 00 00       	push   $0x3dac
     d40:	6a 01                	push   $0x1
     d42:	e8 61 29 00 00       	call   36a8 <printf>
    exit();
     d47:	e8 2f 28 00 00       	call   357b <exit>
      printf(1, "couldn't allocate mem?!!\n");
     d4c:	83 ec 08             	sub    $0x8,%esp
     d4f:	68 92 3d 00 00       	push   $0x3d92
     d54:	6a 01                	push   $0x1
     d56:	e8 4d 29 00 00       	call   36a8 <printf>
      kill(ppid);
     d5b:	89 1c 24             	mov    %ebx,(%esp)
     d5e:	e8 48 28 00 00       	call   35ab <kill>
      exit();
     d63:	e8 13 28 00 00       	call   357b <exit>
}
     d68:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d6b:	5b                   	pop    %ebx
     d6c:	5e                   	pop    %esi
     d6d:	5d                   	pop    %ebp
    wait();
     d6e:	e9 10 28 00 00       	jmp    3583 <wait>
     d73:	90                   	nop

00000d74 <sharedfd>:
{
     d74:	55                   	push   %ebp
     d75:	89 e5                	mov    %esp,%ebp
     d77:	57                   	push   %edi
     d78:	56                   	push   %esi
     d79:	53                   	push   %ebx
     d7a:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     d7d:	68 b4 3d 00 00       	push   $0x3db4
     d82:	6a 01                	push   $0x1
     d84:	e8 1f 29 00 00       	call   36a8 <printf>
  unlink("sharedfd");
     d89:	c7 04 24 c3 3d 00 00 	movl   $0x3dc3,(%esp)
     d90:	e8 36 28 00 00       	call   35cb <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     d95:	59                   	pop    %ecx
     d96:	5b                   	pop    %ebx
     d97:	68 02 02 00 00       	push   $0x202
     d9c:	68 c3 3d 00 00       	push   $0x3dc3
     da1:	e8 15 28 00 00       	call   35bb <open>
  if(fd < 0){
     da6:	83 c4 10             	add    $0x10,%esp
     da9:	85 c0                	test   %eax,%eax
     dab:	0f 88 1a 01 00 00    	js     ecb <sharedfd+0x157>
     db1:	89 c7                	mov    %eax,%edi
  pid = fork();
     db3:	e8 bb 27 00 00       	call   3573 <fork>
     db8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     dbb:	85 c0                	test   %eax,%eax
     dbd:	0f 84 b4 00 00 00    	je     e77 <sharedfd+0x103>
     dc3:	b8 70 00 00 00       	mov    $0x70,%eax
     dc8:	52                   	push   %edx
     dc9:	6a 0a                	push   $0xa
     dcb:	50                   	push   %eax
     dcc:	8d 75 dc             	lea    -0x24(%ebp),%esi
     dcf:	56                   	push   %esi
     dd0:	e8 6f 26 00 00       	call   3444 <memset>
     dd5:	83 c4 10             	add    $0x10,%esp
     dd8:	bb e8 03 00 00       	mov    $0x3e8,%ebx
     ddd:	eb 04                	jmp    de3 <sharedfd+0x6f>
     ddf:	90                   	nop
  for(i = 0; i < 1000; i++){
     de0:	4b                   	dec    %ebx
     de1:	74 24                	je     e07 <sharedfd+0x93>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     de3:	50                   	push   %eax
     de4:	6a 0a                	push   $0xa
     de6:	56                   	push   %esi
     de7:	57                   	push   %edi
     de8:	e8 ae 27 00 00       	call   359b <write>
     ded:	83 c4 10             	add    $0x10,%esp
     df0:	83 f8 0a             	cmp    $0xa,%eax
     df3:	74 eb                	je     de0 <sharedfd+0x6c>
      printf(1, "fstests: write sharedfd failed\n");
     df5:	83 ec 08             	sub    $0x8,%esp
     df8:	68 bc 4a 00 00       	push   $0x4abc
     dfd:	6a 01                	push   $0x1
     dff:	e8 a4 28 00 00       	call   36a8 <printf>
      break;
     e04:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     e07:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
     e0a:	85 db                	test   %ebx,%ebx
     e0c:	0f 84 ed 00 00 00    	je     eff <sharedfd+0x18b>
    wait();
     e12:	e8 6c 27 00 00       	call   3583 <wait>
  close(fd);
     e17:	83 ec 0c             	sub    $0xc,%esp
     e1a:	57                   	push   %edi
     e1b:	e8 83 27 00 00       	call   35a3 <close>
  fd = open("sharedfd", 0);
     e20:	5a                   	pop    %edx
     e21:	59                   	pop    %ecx
     e22:	6a 00                	push   $0x0
     e24:	68 c3 3d 00 00       	push   $0x3dc3
     e29:	e8 8d 27 00 00       	call   35bb <open>
     e2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
     e31:	83 c4 10             	add    $0x10,%esp
     e34:	85 c0                	test   %eax,%eax
     e36:	0f 88 a9 00 00 00    	js     ee5 <sharedfd+0x171>
  nc = np = 0;
     e3c:	31 d2                	xor    %edx,%edx
     e3e:	31 ff                	xor    %edi,%edi
     e40:	8d 5d e6             	lea    -0x1a(%ebp),%ebx
     e43:	90                   	nop
     e44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     e47:	50                   	push   %eax
     e48:	6a 0a                	push   $0xa
     e4a:	56                   	push   %esi
     e4b:	ff 75 d0             	push   -0x30(%ebp)
     e4e:	e8 40 27 00 00       	call   3593 <read>
     e53:	83 c4 10             	add    $0x10,%esp
     e56:	85 c0                	test   %eax,%eax
     e58:	7e 2a                	jle    e84 <sharedfd+0x110>
     e5a:	89 f1                	mov    %esi,%ecx
     e5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     e5f:	eb 0d                	jmp    e6e <sharedfd+0xfa>
     e61:	8d 76 00             	lea    0x0(%esi),%esi
      if(buf[i] == 'p')
     e64:	3c 70                	cmp    $0x70,%al
     e66:	75 01                	jne    e69 <sharedfd+0xf5>
        np++;
     e68:	42                   	inc    %edx
    for(i = 0; i < sizeof(buf); i++){
     e69:	41                   	inc    %ecx
     e6a:	39 d9                	cmp    %ebx,%ecx
     e6c:	74 d6                	je     e44 <sharedfd+0xd0>
      if(buf[i] == 'c')
     e6e:	8a 01                	mov    (%ecx),%al
     e70:	3c 63                	cmp    $0x63,%al
     e72:	75 f0                	jne    e64 <sharedfd+0xf0>
        nc++;
     e74:	47                   	inc    %edi
      if(buf[i] == 'p')
     e75:	eb f2                	jmp    e69 <sharedfd+0xf5>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e77:	b8 63 00 00 00       	mov    $0x63,%eax
     e7c:	e9 47 ff ff ff       	jmp    dc8 <sharedfd+0x54>
     e81:	8d 76 00             	lea    0x0(%esi),%esi
  close(fd);
     e84:	83 ec 0c             	sub    $0xc,%esp
     e87:	ff 75 d0             	push   -0x30(%ebp)
     e8a:	e8 14 27 00 00       	call   35a3 <close>
  unlink("sharedfd");
     e8f:	c7 04 24 c3 3d 00 00 	movl   $0x3dc3,(%esp)
     e96:	e8 30 27 00 00       	call   35cb <unlink>
  if(nc == 10000 && np == 10000){
     e9b:	83 c4 10             	add    $0x10,%esp
     e9e:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     ea4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     ea7:	75 5b                	jne    f04 <sharedfd+0x190>
     ea9:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
     eaf:	75 53                	jne    f04 <sharedfd+0x190>
    printf(1, "sharedfd ok\n");
     eb1:	83 ec 08             	sub    $0x8,%esp
     eb4:	68 cc 3d 00 00       	push   $0x3dcc
     eb9:	6a 01                	push   $0x1
     ebb:	e8 e8 27 00 00       	call   36a8 <printf>
     ec0:	83 c4 10             	add    $0x10,%esp
}
     ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ec6:	5b                   	pop    %ebx
     ec7:	5e                   	pop    %esi
     ec8:	5f                   	pop    %edi
     ec9:	5d                   	pop    %ebp
     eca:	c3                   	ret
    printf(1, "fstests: cannot open sharedfd for writing");
     ecb:	83 ec 08             	sub    $0x8,%esp
     ece:	68 90 4a 00 00       	push   $0x4a90
     ed3:	6a 01                	push   $0x1
     ed5:	e8 ce 27 00 00       	call   36a8 <printf>
    return;
     eda:	83 c4 10             	add    $0x10,%esp
}
     edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ee0:	5b                   	pop    %ebx
     ee1:	5e                   	pop    %esi
     ee2:	5f                   	pop    %edi
     ee3:	5d                   	pop    %ebp
     ee4:	c3                   	ret
    printf(1, "fstests: cannot open sharedfd for reading\n");
     ee5:	83 ec 08             	sub    $0x8,%esp
     ee8:	68 dc 4a 00 00       	push   $0x4adc
     eed:	6a 01                	push   $0x1
     eef:	e8 b4 27 00 00       	call   36a8 <printf>
    return;
     ef4:	83 c4 10             	add    $0x10,%esp
}
     ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     efa:	5b                   	pop    %ebx
     efb:	5e                   	pop    %esi
     efc:	5f                   	pop    %edi
     efd:	5d                   	pop    %ebp
     efe:	c3                   	ret
    exit();
     eff:	e8 77 26 00 00       	call   357b <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
     f04:	52                   	push   %edx
     f05:	57                   	push   %edi
     f06:	68 d9 3d 00 00       	push   $0x3dd9
     f0b:	6a 01                	push   $0x1
     f0d:	e8 96 27 00 00       	call   36a8 <printf>
    exit();
     f12:	e8 64 26 00 00       	call   357b <exit>
     f17:	90                   	nop

00000f18 <fourfiles>:
{
     f18:	55                   	push   %ebp
     f19:	89 e5                	mov    %esp,%ebp
     f1b:	57                   	push   %edi
     f1c:	56                   	push   %esi
     f1d:	53                   	push   %ebx
     f1e:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
     f21:	be 28 51 00 00       	mov    $0x5128,%esi
     f26:	b9 04 00 00 00       	mov    $0x4,%ecx
     f2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
     f2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  printf(1, "fourfiles test\n");
     f30:	68 ee 3d 00 00       	push   $0x3dee
     f35:	6a 01                	push   $0x1
     f37:	e8 6c 27 00 00       	call   36a8 <printf>
     f3c:	83 c4 10             	add    $0x10,%esp
  for(pi = 0; pi < 4; pi++){
     f3f:	31 db                	xor    %ebx,%ebx
    fname = names[pi];
     f41:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
     f45:	83 ec 0c             	sub    $0xc,%esp
     f48:	56                   	push   %esi
     f49:	e8 7d 26 00 00       	call   35cb <unlink>
    pid = fork();
     f4e:	e8 20 26 00 00       	call   3573 <fork>
    if(pid < 0){
     f53:	83 c4 10             	add    $0x10,%esp
     f56:	85 c0                	test   %eax,%eax
     f58:	0f 88 4a 01 00 00    	js     10a8 <fourfiles+0x190>
    if(pid == 0){
     f5e:	0f 84 d8 00 00 00    	je     103c <fourfiles+0x124>
  for(pi = 0; pi < 4; pi++){
     f64:	43                   	inc    %ebx
     f65:	83 fb 04             	cmp    $0x4,%ebx
     f68:	75 d7                	jne    f41 <fourfiles+0x29>
    wait();
     f6a:	e8 14 26 00 00       	call   3583 <wait>
     f6f:	e8 0f 26 00 00       	call   3583 <wait>
     f74:	e8 0a 26 00 00       	call   3583 <wait>
     f79:	e8 05 26 00 00       	call   3583 <wait>
  for(i = 0; i < 2; i++){
     f7e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    fname = names[i];
     f85:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
     f88:	8b 44 9d d8          	mov    -0x28(%ebp,%ebx,4),%eax
     f8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
     f8f:	83 ec 08             	sub    $0x8,%esp
     f92:	6a 00                	push   $0x0
     f94:	50                   	push   %eax
     f95:	e8 21 26 00 00       	call   35bb <open>
     f9a:	89 c7                	mov    %eax,%edi
        if(buf[j] != '0'+i){
     f9c:	83 c4 10             	add    $0x10,%esp
     f9f:	8d 73 30             	lea    0x30(%ebx),%esi
    total = 0;
     fa2:	31 db                	xor    %ebx,%ebx
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fa4:	52                   	push   %edx
     fa5:	68 00 20 00 00       	push   $0x2000
     faa:	68 e0 78 00 00       	push   $0x78e0
     faf:	57                   	push   %edi
     fb0:	e8 de 25 00 00       	call   3593 <read>
     fb5:	83 c4 10             	add    $0x10,%esp
     fb8:	85 c0                	test   %eax,%eax
     fba:	7e 18                	jle    fd4 <fourfiles+0xbc>
      for(j = 0; j < n; j++){
     fbc:	31 d2                	xor    %edx,%edx
     fbe:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
     fc0:	0f be 8a e0 78 00 00 	movsbl 0x78e0(%edx),%ecx
     fc7:	39 f1                	cmp    %esi,%ecx
     fc9:	75 5d                	jne    1028 <fourfiles+0x110>
      for(j = 0; j < n; j++){
     fcb:	42                   	inc    %edx
     fcc:	39 d0                	cmp    %edx,%eax
     fce:	75 f0                	jne    fc0 <fourfiles+0xa8>
      total += n;
     fd0:	01 c3                	add    %eax,%ebx
     fd2:	eb d0                	jmp    fa4 <fourfiles+0x8c>
    close(fd);
     fd4:	83 ec 0c             	sub    $0xc,%esp
     fd7:	57                   	push   %edi
     fd8:	e8 c6 25 00 00       	call   35a3 <close>
    if(total != 12*500){
     fdd:	83 c4 10             	add    $0x10,%esp
     fe0:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
     fe6:	0f 85 d0 00 00 00    	jne    10bc <fourfiles+0x1a4>
    unlink(fname);
     fec:	83 ec 0c             	sub    $0xc,%esp
     fef:	ff 75 d0             	push   -0x30(%ebp)
     ff2:	e8 d4 25 00 00       	call   35cb <unlink>
  for(i = 0; i < 2; i++){
     ff7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     ffa:	40                   	inc    %eax
     ffb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    1002:	83 c4 10             	add    $0x10,%esp
    1005:	83 f8 02             	cmp    $0x2,%eax
    1008:	0f 85 77 ff ff ff    	jne    f85 <fourfiles+0x6d>
  printf(1, "fourfiles ok\n");
    100e:	83 ec 08             	sub    $0x8,%esp
    1011:	68 2c 3e 00 00       	push   $0x3e2c
    1016:	6a 01                	push   $0x1
    1018:	e8 8b 26 00 00       	call   36a8 <printf>
}
    101d:	83 c4 10             	add    $0x10,%esp
    1020:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1023:	5b                   	pop    %ebx
    1024:	5e                   	pop    %esi
    1025:	5f                   	pop    %edi
    1026:	5d                   	pop    %ebp
    1027:	c3                   	ret
          printf(1, "wrong char\n");
    1028:	83 ec 08             	sub    $0x8,%esp
    102b:	68 0f 3e 00 00       	push   $0x3e0f
    1030:	6a 01                	push   $0x1
    1032:	e8 71 26 00 00       	call   36a8 <printf>
          exit();
    1037:	e8 3f 25 00 00       	call   357b <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    103c:	83 ec 08             	sub    $0x8,%esp
    103f:	68 02 02 00 00       	push   $0x202
    1044:	56                   	push   %esi
    1045:	e8 71 25 00 00       	call   35bb <open>
    104a:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    104c:	83 c4 10             	add    $0x10,%esp
    104f:	85 c0                	test   %eax,%eax
    1051:	78 3f                	js     1092 <fourfiles+0x17a>
      memset(buf, '0'+pi, 512);
    1053:	50                   	push   %eax
    1054:	68 00 02 00 00       	push   $0x200
    1059:	83 c3 30             	add    $0x30,%ebx
    105c:	53                   	push   %ebx
    105d:	68 e0 78 00 00       	push   $0x78e0
    1062:	e8 dd 23 00 00       	call   3444 <memset>
    1067:	83 c4 10             	add    $0x10,%esp
    106a:	bb 0c 00 00 00       	mov    $0xc,%ebx
        if((n = write(fd, buf, 500)) != 500){
    106f:	57                   	push   %edi
    1070:	68 f4 01 00 00       	push   $0x1f4
    1075:	68 e0 78 00 00       	push   $0x78e0
    107a:	56                   	push   %esi
    107b:	e8 1b 25 00 00       	call   359b <write>
    1080:	83 c4 10             	add    $0x10,%esp
    1083:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1088:	75 45                	jne    10cf <fourfiles+0x1b7>
      for(i = 0; i < 12; i++){
    108a:	4b                   	dec    %ebx
    108b:	75 e2                	jne    106f <fourfiles+0x157>
      exit();
    108d:	e8 e9 24 00 00       	call   357b <exit>
        printf(1, "create failed\n");
    1092:	50                   	push   %eax
    1093:	50                   	push   %eax
    1094:	68 8f 40 00 00       	push   $0x408f
    1099:	6a 01                	push   $0x1
    109b:	e8 08 26 00 00       	call   36a8 <printf>
        exit();
    10a0:	e8 d6 24 00 00       	call   357b <exit>
    10a5:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
    10a8:	83 ec 08             	sub    $0x8,%esp
    10ab:	68 c9 48 00 00       	push   $0x48c9
    10b0:	6a 01                	push   $0x1
    10b2:	e8 f1 25 00 00       	call   36a8 <printf>
      exit();
    10b7:	e8 bf 24 00 00       	call   357b <exit>
      printf(1, "wrong length %d\n", total);
    10bc:	50                   	push   %eax
    10bd:	53                   	push   %ebx
    10be:	68 1b 3e 00 00       	push   $0x3e1b
    10c3:	6a 01                	push   $0x1
    10c5:	e8 de 25 00 00       	call   36a8 <printf>
      exit();
    10ca:	e8 ac 24 00 00       	call   357b <exit>
          printf(1, "write failed %d\n", n);
    10cf:	51                   	push   %ecx
    10d0:	50                   	push   %eax
    10d1:	68 fe 3d 00 00       	push   $0x3dfe
    10d6:	6a 01                	push   $0x1
    10d8:	e8 cb 25 00 00       	call   36a8 <printf>
          exit();
    10dd:	e8 99 24 00 00       	call   357b <exit>
    10e2:	66 90                	xchg   %ax,%ax

000010e4 <createdelete>:
{
    10e4:	55                   	push   %ebp
    10e5:	89 e5                	mov    %esp,%ebp
    10e7:	57                   	push   %edi
    10e8:	56                   	push   %esi
    10e9:	53                   	push   %ebx
    10ea:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    10ed:	68 40 3e 00 00       	push   $0x3e40
    10f2:	6a 01                	push   $0x1
    10f4:	e8 af 25 00 00       	call   36a8 <printf>
    10f9:	83 c4 10             	add    $0x10,%esp
  for(pi = 0; pi < 4; pi++){
    10fc:	31 f6                	xor    %esi,%esi
    pid = fork();
    10fe:	e8 70 24 00 00       	call   3573 <fork>
    1103:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    1105:	85 c0                	test   %eax,%eax
    1107:	0f 88 52 01 00 00    	js     125f <createdelete+0x17b>
    if(pid == 0){
    110d:	0f 84 c9 00 00 00    	je     11dc <createdelete+0xf8>
  for(pi = 0; pi < 4; pi++){
    1113:	46                   	inc    %esi
    1114:	83 fe 04             	cmp    $0x4,%esi
    1117:	75 e5                	jne    10fe <createdelete+0x1a>
    wait();
    1119:	e8 65 24 00 00       	call   3583 <wait>
    111e:	e8 60 24 00 00       	call   3583 <wait>
    1123:	e8 5b 24 00 00       	call   3583 <wait>
    1128:	e8 56 24 00 00       	call   3583 <wait>
  name[0] = name[1] = name[2] = 0;
    112d:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    1131:	31 f6                	xor    %esi,%esi
    1133:	8d 7d c8             	lea    -0x38(%ebp),%edi
    1136:	66 90                	xchg   %ax,%ax
      name[1] = '0' + i;
    1138:	8d 46 30             	lea    0x30(%esi),%eax
    113b:	88 45 c7             	mov    %al,-0x39(%ebp)
    113e:	b3 70                	mov    $0x70,%bl
      name[0] = 'p' + pi;
    1140:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    1143:	8a 45 c7             	mov    -0x39(%ebp),%al
    1146:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1149:	83 ec 08             	sub    $0x8,%esp
    114c:	6a 00                	push   $0x0
    114e:	57                   	push   %edi
    114f:	e8 67 24 00 00       	call   35bb <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1154:	83 c4 10             	add    $0x10,%esp
    1157:	85 f6                	test   %esi,%esi
    1159:	74 05                	je     1160 <createdelete+0x7c>
    115b:	83 fe 09             	cmp    $0x9,%esi
    115e:	7e 64                	jle    11c4 <createdelete+0xe0>
    1160:	85 c0                	test   %eax,%eax
    1162:	0f 88 e4 00 00 00    	js     124c <createdelete+0x168>
        close(fd);
    1168:	83 ec 0c             	sub    $0xc,%esp
    116b:	50                   	push   %eax
    116c:	e8 32 24 00 00       	call   35a3 <close>
    1171:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1174:	43                   	inc    %ebx
    1175:	80 fb 74             	cmp    $0x74,%bl
    1178:	75 c6                	jne    1140 <createdelete+0x5c>
  for(i = 0; i < N; i++){
    117a:	46                   	inc    %esi
    117b:	83 fe 14             	cmp    $0x14,%esi
    117e:	75 b8                	jne    1138 <createdelete+0x54>
    1180:	b3 70                	mov    $0x70,%bl
    1182:	66 90                	xchg   %ax,%ax
      name[1] = '0' + i;
    1184:	8d 43 c0             	lea    -0x40(%ebx),%eax
    1187:	88 45 c7             	mov    %al,-0x39(%ebp)
    118a:	be 04 00 00 00       	mov    $0x4,%esi
      name[0] = 'p' + i;
    118f:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    1192:	8a 45 c7             	mov    -0x39(%ebp),%al
    1195:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    1198:	83 ec 0c             	sub    $0xc,%esp
    119b:	57                   	push   %edi
    119c:	e8 2a 24 00 00       	call   35cb <unlink>
    for(pi = 0; pi < 4; pi++){
    11a1:	83 c4 10             	add    $0x10,%esp
    11a4:	4e                   	dec    %esi
    11a5:	75 e8                	jne    118f <createdelete+0xab>
  for(i = 0; i < N; i++){
    11a7:	43                   	inc    %ebx
    11a8:	80 fb 84             	cmp    $0x84,%bl
    11ab:	75 d7                	jne    1184 <createdelete+0xa0>
  printf(1, "createdelete ok\n");
    11ad:	83 ec 08             	sub    $0x8,%esp
    11b0:	68 53 3e 00 00       	push   $0x3e53
    11b5:	6a 01                	push   $0x1
    11b7:	e8 ec 24 00 00       	call   36a8 <printf>
}
    11bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11bf:	5b                   	pop    %ebx
    11c0:	5e                   	pop    %esi
    11c1:	5f                   	pop    %edi
    11c2:	5d                   	pop    %ebp
    11c3:	c3                   	ret
      } else if((i >= 1 && i < N/2) && fd >= 0){
    11c4:	85 c0                	test   %eax,%eax
    11c6:	78 ac                	js     1174 <createdelete+0x90>
        printf(1, "oops createdelete %s did exist\n", name);
    11c8:	50                   	push   %eax
    11c9:	57                   	push   %edi
    11ca:	68 2c 4b 00 00       	push   $0x4b2c
    11cf:	6a 01                	push   $0x1
    11d1:	e8 d2 24 00 00       	call   36a8 <printf>
        exit();
    11d6:	e8 a0 23 00 00       	call   357b <exit>
    11db:	90                   	nop
      name[0] = 'p' + pi;
    11dc:	8d 46 70             	lea    0x70(%esi),%eax
    11df:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    11e2:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    11e6:	8d 7d c8             	lea    -0x38(%ebp),%edi
    11e9:	8d 76 00             	lea    0x0(%esi),%esi
        name[1] = '0' + i;
    11ec:	8d 43 30             	lea    0x30(%ebx),%eax
    11ef:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    11f2:	83 ec 08             	sub    $0x8,%esp
    11f5:	68 02 02 00 00       	push   $0x202
    11fa:	57                   	push   %edi
    11fb:	e8 bb 23 00 00       	call   35bb <open>
        if(fd < 0){
    1200:	83 c4 10             	add    $0x10,%esp
    1203:	85 c0                	test   %eax,%eax
    1205:	78 7f                	js     1286 <createdelete+0x1a2>
        close(fd);
    1207:	83 ec 0c             	sub    $0xc,%esp
    120a:	50                   	push   %eax
    120b:	e8 93 23 00 00       	call   35a3 <close>
        if(i > 0 && (i % 2 ) == 0){
    1210:	83 c4 10             	add    $0x10,%esp
    1213:	85 db                	test   %ebx,%ebx
    1215:	74 11                	je     1228 <createdelete+0x144>
    1217:	f6 c3 01             	test   $0x1,%bl
    121a:	74 13                	je     122f <createdelete+0x14b>
      for(i = 0; i < N; i++){
    121c:	43                   	inc    %ebx
    121d:	83 fb 14             	cmp    $0x14,%ebx
    1220:	75 ca                	jne    11ec <createdelete+0x108>
      exit();
    1222:	e8 54 23 00 00       	call   357b <exit>
    1227:	90                   	nop
      for(i = 0; i < N; i++){
    1228:	bb 01 00 00 00       	mov    $0x1,%ebx
    122d:	eb bd                	jmp    11ec <createdelete+0x108>
          name[1] = '0' + (i / 2);
    122f:	89 d8                	mov    %ebx,%eax
    1231:	d1 f8                	sar    $1,%eax
    1233:	83 c0 30             	add    $0x30,%eax
    1236:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1239:	83 ec 0c             	sub    $0xc,%esp
    123c:	57                   	push   %edi
    123d:	e8 89 23 00 00       	call   35cb <unlink>
    1242:	83 c4 10             	add    $0x10,%esp
    1245:	85 c0                	test   %eax,%eax
    1247:	78 2a                	js     1273 <createdelete+0x18f>
      for(i = 0; i < N; i++){
    1249:	43                   	inc    %ebx
    124a:	eb a0                	jmp    11ec <createdelete+0x108>
        printf(1, "oops createdelete %s didn't exist\n", name);
    124c:	52                   	push   %edx
    124d:	57                   	push   %edi
    124e:	68 08 4b 00 00       	push   $0x4b08
    1253:	6a 01                	push   $0x1
    1255:	e8 4e 24 00 00       	call   36a8 <printf>
        exit();
    125a:	e8 1c 23 00 00       	call   357b <exit>
      printf(1, "fork failed\n");
    125f:	83 ec 08             	sub    $0x8,%esp
    1262:	68 c9 48 00 00       	push   $0x48c9
    1267:	6a 01                	push   $0x1
    1269:	e8 3a 24 00 00       	call   36a8 <printf>
      exit();
    126e:	e8 08 23 00 00       	call   357b <exit>
            printf(1, "unlink failed\n");
    1273:	51                   	push   %ecx
    1274:	51                   	push   %ecx
    1275:	68 41 3a 00 00       	push   $0x3a41
    127a:	6a 01                	push   $0x1
    127c:	e8 27 24 00 00       	call   36a8 <printf>
            exit();
    1281:	e8 f5 22 00 00       	call   357b <exit>
          printf(1, "create failed\n");
    1286:	83 ec 08             	sub    $0x8,%esp
    1289:	68 8f 40 00 00       	push   $0x408f
    128e:	6a 01                	push   $0x1
    1290:	e8 13 24 00 00       	call   36a8 <printf>
          exit();
    1295:	e8 e1 22 00 00       	call   357b <exit>
    129a:	66 90                	xchg   %ax,%ax

0000129c <unlinkread>:
{
    129c:	55                   	push   %ebp
    129d:	89 e5                	mov    %esp,%ebp
    129f:	56                   	push   %esi
    12a0:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    12a1:	83 ec 08             	sub    $0x8,%esp
    12a4:	68 64 3e 00 00       	push   $0x3e64
    12a9:	6a 01                	push   $0x1
    12ab:	e8 f8 23 00 00       	call   36a8 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    12b0:	5e                   	pop    %esi
    12b1:	58                   	pop    %eax
    12b2:	68 02 02 00 00       	push   $0x202
    12b7:	68 75 3e 00 00       	push   $0x3e75
    12bc:	e8 fa 22 00 00       	call   35bb <open>
  if(fd < 0){
    12c1:	83 c4 10             	add    $0x10,%esp
    12c4:	85 c0                	test   %eax,%eax
    12c6:	0f 88 e2 00 00 00    	js     13ae <unlinkread+0x112>
    12cc:	89 c3                	mov    %eax,%ebx
  write(fd, "hello", 5);
    12ce:	50                   	push   %eax
    12cf:	6a 05                	push   $0x5
    12d1:	68 9a 3e 00 00       	push   $0x3e9a
    12d6:	53                   	push   %ebx
    12d7:	e8 bf 22 00 00       	call   359b <write>
  close(fd);
    12dc:	89 1c 24             	mov    %ebx,(%esp)
    12df:	e8 bf 22 00 00       	call   35a3 <close>
  fd = open("unlinkread", O_RDWR);
    12e4:	5a                   	pop    %edx
    12e5:	59                   	pop    %ecx
    12e6:	6a 02                	push   $0x2
    12e8:	68 75 3e 00 00       	push   $0x3e75
    12ed:	e8 c9 22 00 00       	call   35bb <open>
    12f2:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    12f4:	83 c4 10             	add    $0x10,%esp
    12f7:	85 c0                	test   %eax,%eax
    12f9:	0f 88 0e 01 00 00    	js     140d <unlinkread+0x171>
  if(unlink("unlinkread") != 0){
    12ff:	83 ec 0c             	sub    $0xc,%esp
    1302:	68 75 3e 00 00       	push   $0x3e75
    1307:	e8 bf 22 00 00       	call   35cb <unlink>
    130c:	83 c4 10             	add    $0x10,%esp
    130f:	85 c0                	test   %eax,%eax
    1311:	0f 85 e3 00 00 00    	jne    13fa <unlinkread+0x15e>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1317:	83 ec 08             	sub    $0x8,%esp
    131a:	68 02 02 00 00       	push   $0x202
    131f:	68 75 3e 00 00       	push   $0x3e75
    1324:	e8 92 22 00 00       	call   35bb <open>
    1329:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    132b:	83 c4 0c             	add    $0xc,%esp
    132e:	6a 03                	push   $0x3
    1330:	68 d2 3e 00 00       	push   $0x3ed2
    1335:	50                   	push   %eax
    1336:	e8 60 22 00 00       	call   359b <write>
  close(fd1);
    133b:	89 34 24             	mov    %esi,(%esp)
    133e:	e8 60 22 00 00       	call   35a3 <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    1343:	83 c4 0c             	add    $0xc,%esp
    1346:	68 00 20 00 00       	push   $0x2000
    134b:	68 e0 78 00 00       	push   $0x78e0
    1350:	53                   	push   %ebx
    1351:	e8 3d 22 00 00       	call   3593 <read>
    1356:	83 c4 10             	add    $0x10,%esp
    1359:	83 f8 05             	cmp    $0x5,%eax
    135c:	0f 85 85 00 00 00    	jne    13e7 <unlinkread+0x14b>
  if(buf[0] != 'h'){
    1362:	80 3d e0 78 00 00 68 	cmpb   $0x68,0x78e0
    1369:	75 69                	jne    13d4 <unlinkread+0x138>
  if(write(fd, buf, 10) != 10){
    136b:	56                   	push   %esi
    136c:	6a 0a                	push   $0xa
    136e:	68 e0 78 00 00       	push   $0x78e0
    1373:	53                   	push   %ebx
    1374:	e8 22 22 00 00       	call   359b <write>
    1379:	83 c4 10             	add    $0x10,%esp
    137c:	83 f8 0a             	cmp    $0xa,%eax
    137f:	75 40                	jne    13c1 <unlinkread+0x125>
  close(fd);
    1381:	83 ec 0c             	sub    $0xc,%esp
    1384:	53                   	push   %ebx
    1385:	e8 19 22 00 00       	call   35a3 <close>
  unlink("unlinkread");
    138a:	c7 04 24 75 3e 00 00 	movl   $0x3e75,(%esp)
    1391:	e8 35 22 00 00       	call   35cb <unlink>
  printf(1, "unlinkread ok\n");
    1396:	58                   	pop    %eax
    1397:	5a                   	pop    %edx
    1398:	68 1d 3f 00 00       	push   $0x3f1d
    139d:	6a 01                	push   $0x1
    139f:	e8 04 23 00 00       	call   36a8 <printf>
}
    13a4:	83 c4 10             	add    $0x10,%esp
    13a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
    13aa:	5b                   	pop    %ebx
    13ab:	5e                   	pop    %esi
    13ac:	5d                   	pop    %ebp
    13ad:	c3                   	ret
    printf(1, "create unlinkread failed\n");
    13ae:	53                   	push   %ebx
    13af:	53                   	push   %ebx
    13b0:	68 80 3e 00 00       	push   $0x3e80
    13b5:	6a 01                	push   $0x1
    13b7:	e8 ec 22 00 00       	call   36a8 <printf>
    exit();
    13bc:	e8 ba 21 00 00       	call   357b <exit>
    printf(1, "unlinkread write failed\n");
    13c1:	51                   	push   %ecx
    13c2:	51                   	push   %ecx
    13c3:	68 04 3f 00 00       	push   $0x3f04
    13c8:	6a 01                	push   $0x1
    13ca:	e8 d9 22 00 00       	call   36a8 <printf>
    exit();
    13cf:	e8 a7 21 00 00       	call   357b <exit>
    printf(1, "unlinkread wrong data\n");
    13d4:	50                   	push   %eax
    13d5:	50                   	push   %eax
    13d6:	68 ed 3e 00 00       	push   $0x3eed
    13db:	6a 01                	push   $0x1
    13dd:	e8 c6 22 00 00       	call   36a8 <printf>
    exit();
    13e2:	e8 94 21 00 00       	call   357b <exit>
    printf(1, "unlinkread read failed");
    13e7:	50                   	push   %eax
    13e8:	50                   	push   %eax
    13e9:	68 d6 3e 00 00       	push   $0x3ed6
    13ee:	6a 01                	push   $0x1
    13f0:	e8 b3 22 00 00       	call   36a8 <printf>
    exit();
    13f5:	e8 81 21 00 00       	call   357b <exit>
    printf(1, "unlink unlinkread failed\n");
    13fa:	50                   	push   %eax
    13fb:	50                   	push   %eax
    13fc:	68 b8 3e 00 00       	push   $0x3eb8
    1401:	6a 01                	push   $0x1
    1403:	e8 a0 22 00 00       	call   36a8 <printf>
    exit();
    1408:	e8 6e 21 00 00       	call   357b <exit>
    printf(1, "open unlinkread failed\n");
    140d:	50                   	push   %eax
    140e:	50                   	push   %eax
    140f:	68 a0 3e 00 00       	push   $0x3ea0
    1414:	6a 01                	push   $0x1
    1416:	e8 8d 22 00 00       	call   36a8 <printf>
    exit();
    141b:	e8 5b 21 00 00       	call   357b <exit>

00001420 <linktest>:
{
    1420:	55                   	push   %ebp
    1421:	89 e5                	mov    %esp,%ebp
    1423:	53                   	push   %ebx
    1424:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    1427:	68 2c 3f 00 00       	push   $0x3f2c
    142c:	6a 01                	push   $0x1
    142e:	e8 75 22 00 00       	call   36a8 <printf>
  unlink("lf1");
    1433:	c7 04 24 36 3f 00 00 	movl   $0x3f36,(%esp)
    143a:	e8 8c 21 00 00       	call   35cb <unlink>
  unlink("lf2");
    143f:	c7 04 24 3a 3f 00 00 	movl   $0x3f3a,(%esp)
    1446:	e8 80 21 00 00       	call   35cb <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    144b:	58                   	pop    %eax
    144c:	5a                   	pop    %edx
    144d:	68 02 02 00 00       	push   $0x202
    1452:	68 36 3f 00 00       	push   $0x3f36
    1457:	e8 5f 21 00 00       	call   35bb <open>
  if(fd < 0){
    145c:	83 c4 10             	add    $0x10,%esp
    145f:	85 c0                	test   %eax,%eax
    1461:	0f 88 1a 01 00 00    	js     1581 <linktest+0x161>
    1467:	89 c3                	mov    %eax,%ebx
  if(write(fd, "hello", 5) != 5){
    1469:	50                   	push   %eax
    146a:	6a 05                	push   $0x5
    146c:	68 9a 3e 00 00       	push   $0x3e9a
    1471:	53                   	push   %ebx
    1472:	e8 24 21 00 00       	call   359b <write>
    1477:	83 c4 10             	add    $0x10,%esp
    147a:	83 f8 05             	cmp    $0x5,%eax
    147d:	0f 85 96 01 00 00    	jne    1619 <linktest+0x1f9>
  close(fd);
    1483:	83 ec 0c             	sub    $0xc,%esp
    1486:	53                   	push   %ebx
    1487:	e8 17 21 00 00       	call   35a3 <close>
  if(link("lf1", "lf2") < 0){
    148c:	5b                   	pop    %ebx
    148d:	58                   	pop    %eax
    148e:	68 3a 3f 00 00       	push   $0x3f3a
    1493:	68 36 3f 00 00       	push   $0x3f36
    1498:	e8 3e 21 00 00       	call   35db <link>
    149d:	83 c4 10             	add    $0x10,%esp
    14a0:	85 c0                	test   %eax,%eax
    14a2:	0f 88 5e 01 00 00    	js     1606 <linktest+0x1e6>
  unlink("lf1");
    14a8:	83 ec 0c             	sub    $0xc,%esp
    14ab:	68 36 3f 00 00       	push   $0x3f36
    14b0:	e8 16 21 00 00       	call   35cb <unlink>
  if(open("lf1", 0) >= 0){
    14b5:	58                   	pop    %eax
    14b6:	5a                   	pop    %edx
    14b7:	6a 00                	push   $0x0
    14b9:	68 36 3f 00 00       	push   $0x3f36
    14be:	e8 f8 20 00 00       	call   35bb <open>
    14c3:	83 c4 10             	add    $0x10,%esp
    14c6:	85 c0                	test   %eax,%eax
    14c8:	0f 89 25 01 00 00    	jns    15f3 <linktest+0x1d3>
  fd = open("lf2", 0);
    14ce:	83 ec 08             	sub    $0x8,%esp
    14d1:	6a 00                	push   $0x0
    14d3:	68 3a 3f 00 00       	push   $0x3f3a
    14d8:	e8 de 20 00 00       	call   35bb <open>
    14dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    14df:	83 c4 10             	add    $0x10,%esp
    14e2:	85 c0                	test   %eax,%eax
    14e4:	0f 88 f6 00 00 00    	js     15e0 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != 5){
    14ea:	50                   	push   %eax
    14eb:	68 00 20 00 00       	push   $0x2000
    14f0:	68 e0 78 00 00       	push   $0x78e0
    14f5:	53                   	push   %ebx
    14f6:	e8 98 20 00 00       	call   3593 <read>
    14fb:	83 c4 10             	add    $0x10,%esp
    14fe:	83 f8 05             	cmp    $0x5,%eax
    1501:	0f 85 c6 00 00 00    	jne    15cd <linktest+0x1ad>
  close(fd);
    1507:	83 ec 0c             	sub    $0xc,%esp
    150a:	53                   	push   %ebx
    150b:	e8 93 20 00 00       	call   35a3 <close>
  if(link("lf2", "lf2") >= 0){
    1510:	58                   	pop    %eax
    1511:	5a                   	pop    %edx
    1512:	68 3a 3f 00 00       	push   $0x3f3a
    1517:	68 3a 3f 00 00       	push   $0x3f3a
    151c:	e8 ba 20 00 00       	call   35db <link>
    1521:	83 c4 10             	add    $0x10,%esp
    1524:	85 c0                	test   %eax,%eax
    1526:	0f 89 8e 00 00 00    	jns    15ba <linktest+0x19a>
  unlink("lf2");
    152c:	83 ec 0c             	sub    $0xc,%esp
    152f:	68 3a 3f 00 00       	push   $0x3f3a
    1534:	e8 92 20 00 00       	call   35cb <unlink>
  if(link("lf2", "lf1") >= 0){
    1539:	59                   	pop    %ecx
    153a:	5b                   	pop    %ebx
    153b:	68 36 3f 00 00       	push   $0x3f36
    1540:	68 3a 3f 00 00       	push   $0x3f3a
    1545:	e8 91 20 00 00       	call   35db <link>
    154a:	83 c4 10             	add    $0x10,%esp
    154d:	85 c0                	test   %eax,%eax
    154f:	79 56                	jns    15a7 <linktest+0x187>
  if(link(".", "lf1") >= 0){
    1551:	83 ec 08             	sub    $0x8,%esp
    1554:	68 36 3f 00 00       	push   $0x3f36
    1559:	68 fe 41 00 00       	push   $0x41fe
    155e:	e8 78 20 00 00       	call   35db <link>
    1563:	83 c4 10             	add    $0x10,%esp
    1566:	85 c0                	test   %eax,%eax
    1568:	79 2a                	jns    1594 <linktest+0x174>
  printf(1, "linktest ok\n");
    156a:	83 ec 08             	sub    $0x8,%esp
    156d:	68 d4 3f 00 00       	push   $0x3fd4
    1572:	6a 01                	push   $0x1
    1574:	e8 2f 21 00 00       	call   36a8 <printf>
}
    1579:	83 c4 10             	add    $0x10,%esp
    157c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    157f:	c9                   	leave
    1580:	c3                   	ret
    printf(1, "create lf1 failed\n");
    1581:	50                   	push   %eax
    1582:	50                   	push   %eax
    1583:	68 3e 3f 00 00       	push   $0x3f3e
    1588:	6a 01                	push   $0x1
    158a:	e8 19 21 00 00       	call   36a8 <printf>
    exit();
    158f:	e8 e7 1f 00 00       	call   357b <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    1594:	50                   	push   %eax
    1595:	50                   	push   %eax
    1596:	68 b8 3f 00 00       	push   $0x3fb8
    159b:	6a 01                	push   $0x1
    159d:	e8 06 21 00 00       	call   36a8 <printf>
    exit();
    15a2:	e8 d4 1f 00 00       	call   357b <exit>
    printf(1, "link non-existant succeeded! oops\n");
    15a7:	52                   	push   %edx
    15a8:	52                   	push   %edx
    15a9:	68 74 4b 00 00       	push   $0x4b74
    15ae:	6a 01                	push   $0x1
    15b0:	e8 f3 20 00 00       	call   36a8 <printf>
    exit();
    15b5:	e8 c1 1f 00 00       	call   357b <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15ba:	50                   	push   %eax
    15bb:	50                   	push   %eax
    15bc:	68 9a 3f 00 00       	push   $0x3f9a
    15c1:	6a 01                	push   $0x1
    15c3:	e8 e0 20 00 00       	call   36a8 <printf>
    exit();
    15c8:	e8 ae 1f 00 00       	call   357b <exit>
    printf(1, "read lf2 failed\n");
    15cd:	51                   	push   %ecx
    15ce:	51                   	push   %ecx
    15cf:	68 89 3f 00 00       	push   $0x3f89
    15d4:	6a 01                	push   $0x1
    15d6:	e8 cd 20 00 00       	call   36a8 <printf>
    exit();
    15db:	e8 9b 1f 00 00       	call   357b <exit>
    printf(1, "open lf2 failed\n");
    15e0:	50                   	push   %eax
    15e1:	50                   	push   %eax
    15e2:	68 78 3f 00 00       	push   $0x3f78
    15e7:	6a 01                	push   $0x1
    15e9:	e8 ba 20 00 00       	call   36a8 <printf>
    exit();
    15ee:	e8 88 1f 00 00       	call   357b <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    15f3:	50                   	push   %eax
    15f4:	50                   	push   %eax
    15f5:	68 4c 4b 00 00       	push   $0x4b4c
    15fa:	6a 01                	push   $0x1
    15fc:	e8 a7 20 00 00       	call   36a8 <printf>
    exit();
    1601:	e8 75 1f 00 00       	call   357b <exit>
    printf(1, "link lf1 lf2 failed\n");
    1606:	51                   	push   %ecx
    1607:	51                   	push   %ecx
    1608:	68 63 3f 00 00       	push   $0x3f63
    160d:	6a 01                	push   $0x1
    160f:	e8 94 20 00 00       	call   36a8 <printf>
    exit();
    1614:	e8 62 1f 00 00       	call   357b <exit>
    printf(1, "write lf1 failed\n");
    1619:	50                   	push   %eax
    161a:	50                   	push   %eax
    161b:	68 51 3f 00 00       	push   $0x3f51
    1620:	6a 01                	push   $0x1
    1622:	e8 81 20 00 00       	call   36a8 <printf>
    exit();
    1627:	e8 4f 1f 00 00       	call   357b <exit>

0000162c <concreate>:
{
    162c:	55                   	push   %ebp
    162d:	89 e5                	mov    %esp,%ebp
    162f:	57                   	push   %edi
    1630:	56                   	push   %esi
    1631:	53                   	push   %ebx
    1632:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1635:	68 e1 3f 00 00       	push   $0x3fe1
    163a:	6a 01                	push   $0x1
    163c:	e8 67 20 00 00       	call   36a8 <printf>
  file[0] = 'C';
    1641:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1645:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
    1649:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    164c:	31 f6                	xor    %esi,%esi
    164e:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    1651:	bf 03 00 00 00       	mov    $0x3,%edi
    1656:	eb 38                	jmp    1690 <concreate+0x64>
    1658:	89 f0                	mov    %esi,%eax
    165a:	99                   	cltd
    165b:	f7 ff                	idiv   %edi
    if(pid && (i % 3) == 1){
    165d:	4a                   	dec    %edx
    165e:	0f 84 84 00 00 00    	je     16e8 <concreate+0xbc>
      fd = open(file, O_CREATE | O_RDWR);
    1664:	83 ec 08             	sub    $0x8,%esp
    1667:	68 02 02 00 00       	push   $0x202
    166c:	53                   	push   %ebx
    166d:	e8 49 1f 00 00       	call   35bb <open>
      if(fd < 0){
    1672:	83 c4 10             	add    $0x10,%esp
    1675:	85 c0                	test   %eax,%eax
    1677:	78 5c                	js     16d5 <concreate+0xa9>
      close(fd);
    1679:	83 ec 0c             	sub    $0xc,%esp
    167c:	50                   	push   %eax
    167d:	e8 21 1f 00 00       	call   35a3 <close>
    1682:	83 c4 10             	add    $0x10,%esp
      wait();
    1685:	e8 f9 1e 00 00       	call   3583 <wait>
  for(i = 0; i < 40; i++){
    168a:	46                   	inc    %esi
    168b:	83 fe 28             	cmp    $0x28,%esi
    168e:	74 74                	je     1704 <concreate+0xd8>
    file[1] = '0' + i;
    1690:	8d 46 30             	lea    0x30(%esi),%eax
    1693:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    1696:	83 ec 0c             	sub    $0xc,%esp
    1699:	53                   	push   %ebx
    169a:	e8 2c 1f 00 00       	call   35cb <unlink>
    pid = fork();
    169f:	e8 cf 1e 00 00       	call   3573 <fork>
    if(pid && (i % 3) == 1){
    16a4:	83 c4 10             	add    $0x10,%esp
    16a7:	85 c0                	test   %eax,%eax
    16a9:	75 ad                	jne    1658 <concreate+0x2c>
      link("C0", file);
    16ab:	b9 05 00 00 00       	mov    $0x5,%ecx
    16b0:	89 f0                	mov    %esi,%eax
    16b2:	99                   	cltd
    16b3:	f7 f9                	idiv   %ecx
    } else if(pid == 0 && (i % 5) == 1){
    16b5:	4a                   	dec    %edx
    16b6:	0f 84 c0 00 00 00    	je     177c <concreate+0x150>
      fd = open(file, O_CREATE | O_RDWR);
    16bc:	83 ec 08             	sub    $0x8,%esp
    16bf:	68 02 02 00 00       	push   $0x202
    16c4:	53                   	push   %ebx
    16c5:	e8 f1 1e 00 00       	call   35bb <open>
      if(fd < 0){
    16ca:	83 c4 10             	add    $0x10,%esp
    16cd:	85 c0                	test   %eax,%eax
    16cf:	0f 89 be 01 00 00    	jns    1893 <concreate+0x267>
        printf(1, "concreate create %s failed\n", file);
    16d5:	51                   	push   %ecx
    16d6:	53                   	push   %ebx
    16d7:	68 f4 3f 00 00       	push   $0x3ff4
    16dc:	6a 01                	push   $0x1
    16de:	e8 c5 1f 00 00       	call   36a8 <printf>
        exit();
    16e3:	e8 93 1e 00 00       	call   357b <exit>
      link("C0", file);
    16e8:	83 ec 08             	sub    $0x8,%esp
    16eb:	53                   	push   %ebx
    16ec:	68 f1 3f 00 00       	push   $0x3ff1
    16f1:	e8 e5 1e 00 00       	call   35db <link>
    16f6:	83 c4 10             	add    $0x10,%esp
      wait();
    16f9:	e8 85 1e 00 00       	call   3583 <wait>
  for(i = 0; i < 40; i++){
    16fe:	46                   	inc    %esi
    16ff:	83 fe 28             	cmp    $0x28,%esi
    1702:	75 8c                	jne    1690 <concreate+0x64>
  memset(fa, 0, sizeof(fa));
    1704:	50                   	push   %eax
    1705:	6a 28                	push   $0x28
    1707:	6a 00                	push   $0x0
    1709:	8d 45 c0             	lea    -0x40(%ebp),%eax
    170c:	50                   	push   %eax
    170d:	e8 32 1d 00 00       	call   3444 <memset>
  fd = open(".", 0);
    1712:	58                   	pop    %eax
    1713:	5a                   	pop    %edx
    1714:	6a 00                	push   $0x0
    1716:	68 fe 41 00 00       	push   $0x41fe
    171b:	e8 9b 1e 00 00       	call   35bb <open>
    1720:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    1722:	83 c4 10             	add    $0x10,%esp
  n = 0;
    1725:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    172c:	8d 7d b0             	lea    -0x50(%ebp),%edi
    172f:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    1730:	50                   	push   %eax
    1731:	6a 10                	push   $0x10
    1733:	57                   	push   %edi
    1734:	56                   	push   %esi
    1735:	e8 59 1e 00 00       	call   3593 <read>
    173a:	83 c4 10             	add    $0x10,%esp
    173d:	85 c0                	test   %eax,%eax
    173f:	7e 53                	jle    1794 <concreate+0x168>
    if(de.inum == 0)
    1741:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    1746:	74 e8                	je     1730 <concreate+0x104>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1748:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    174c:	75 e2                	jne    1730 <concreate+0x104>
    174e:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    1752:	75 dc                	jne    1730 <concreate+0x104>
      i = de.name[1] - '0';
    1754:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    1758:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    175b:	83 f8 27             	cmp    $0x27,%eax
    175e:	0f 87 40 01 00 00    	ja     18a4 <concreate+0x278>
      if(fa[i]){
    1764:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    1769:	0f 85 5e 01 00 00    	jne    18cd <concreate+0x2a1>
      fa[i] = 1;
    176f:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    1774:	ff 45 a4             	incl   -0x5c(%ebp)
    1777:	eb b7                	jmp    1730 <concreate+0x104>
    1779:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    177c:	83 ec 08             	sub    $0x8,%esp
    177f:	53                   	push   %ebx
    1780:	68 f1 3f 00 00       	push   $0x3ff1
    1785:	e8 51 1e 00 00       	call   35db <link>
    178a:	83 c4 10             	add    $0x10,%esp
      exit();
    178d:	e8 e9 1d 00 00       	call   357b <exit>
    1792:	66 90                	xchg   %ax,%ax
  close(fd);
    1794:	83 ec 0c             	sub    $0xc,%esp
    1797:	56                   	push   %esi
    1798:	e8 06 1e 00 00       	call   35a3 <close>
  if(n != 40){
    179d:	83 c4 10             	add    $0x10,%esp
    17a0:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    17a4:	0f 85 10 01 00 00    	jne    18ba <concreate+0x28e>
  for(i = 0; i < 40; i++){
    17aa:	31 f6                	xor    %esi,%esi
    17ac:	eb 65                	jmp    1813 <concreate+0x1e7>
    17ae:	66 90                	xchg   %ax,%ax
    if(((i % 3) == 0 && pid == 0) ||
    17b0:	85 ff                	test   %edi,%edi
    17b2:	0f 85 89 00 00 00    	jne    1841 <concreate+0x215>
      close(open(file, 0));
    17b8:	83 ec 08             	sub    $0x8,%esp
    17bb:	6a 00                	push   $0x0
    17bd:	53                   	push   %ebx
    17be:	e8 f8 1d 00 00       	call   35bb <open>
    17c3:	89 04 24             	mov    %eax,(%esp)
    17c6:	e8 d8 1d 00 00       	call   35a3 <close>
      close(open(file, 0));
    17cb:	58                   	pop    %eax
    17cc:	5a                   	pop    %edx
    17cd:	6a 00                	push   $0x0
    17cf:	53                   	push   %ebx
    17d0:	e8 e6 1d 00 00       	call   35bb <open>
    17d5:	89 04 24             	mov    %eax,(%esp)
    17d8:	e8 c6 1d 00 00       	call   35a3 <close>
      close(open(file, 0));
    17dd:	59                   	pop    %ecx
    17de:	58                   	pop    %eax
    17df:	6a 00                	push   $0x0
    17e1:	53                   	push   %ebx
    17e2:	e8 d4 1d 00 00       	call   35bb <open>
    17e7:	89 04 24             	mov    %eax,(%esp)
    17ea:	e8 b4 1d 00 00       	call   35a3 <close>
      close(open(file, 0));
    17ef:	58                   	pop    %eax
    17f0:	5a                   	pop    %edx
    17f1:	6a 00                	push   $0x0
    17f3:	53                   	push   %ebx
    17f4:	e8 c2 1d 00 00       	call   35bb <open>
    17f9:	89 04 24             	mov    %eax,(%esp)
    17fc:	e8 a2 1d 00 00       	call   35a3 <close>
    1801:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    1804:	85 ff                	test   %edi,%edi
    1806:	74 85                	je     178d <concreate+0x161>
      wait();
    1808:	e8 76 1d 00 00       	call   3583 <wait>
  for(i = 0; i < 40; i++){
    180d:	46                   	inc    %esi
    180e:	83 fe 28             	cmp    $0x28,%esi
    1811:	74 55                	je     1868 <concreate+0x23c>
    file[1] = '0' + i;
    1813:	8d 46 30             	lea    0x30(%esi),%eax
    1816:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1819:	e8 55 1d 00 00       	call   3573 <fork>
    181e:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1820:	85 c0                	test   %eax,%eax
    1822:	78 5b                	js     187f <concreate+0x253>
    if(((i % 3) == 0 && pid == 0) ||
    1824:	89 f0                	mov    %esi,%eax
    1826:	b9 03 00 00 00       	mov    $0x3,%ecx
    182b:	99                   	cltd
    182c:	f7 f9                	idiv   %ecx
    182e:	85 d2                	test   %edx,%edx
    1830:	0f 84 7a ff ff ff    	je     17b0 <concreate+0x184>
    1836:	4a                   	dec    %edx
    1837:	75 08                	jne    1841 <concreate+0x215>
       ((i % 3) == 1 && pid != 0)){
    1839:	85 ff                	test   %edi,%edi
    183b:	0f 85 77 ff ff ff    	jne    17b8 <concreate+0x18c>
      unlink(file);
    1841:	83 ec 0c             	sub    $0xc,%esp
    1844:	53                   	push   %ebx
    1845:	e8 81 1d 00 00       	call   35cb <unlink>
      unlink(file);
    184a:	89 1c 24             	mov    %ebx,(%esp)
    184d:	e8 79 1d 00 00       	call   35cb <unlink>
      unlink(file);
    1852:	89 1c 24             	mov    %ebx,(%esp)
    1855:	e8 71 1d 00 00       	call   35cb <unlink>
      unlink(file);
    185a:	89 1c 24             	mov    %ebx,(%esp)
    185d:	e8 69 1d 00 00       	call   35cb <unlink>
    1862:	83 c4 10             	add    $0x10,%esp
    1865:	eb 9d                	jmp    1804 <concreate+0x1d8>
    1867:	90                   	nop
  printf(1, "concreate ok\n");
    1868:	83 ec 08             	sub    $0x8,%esp
    186b:	68 46 40 00 00       	push   $0x4046
    1870:	6a 01                	push   $0x1
    1872:	e8 31 1e 00 00       	call   36a8 <printf>
}
    1877:	8d 65 f4             	lea    -0xc(%ebp),%esp
    187a:	5b                   	pop    %ebx
    187b:	5e                   	pop    %esi
    187c:	5f                   	pop    %edi
    187d:	5d                   	pop    %ebp
    187e:	c3                   	ret
      printf(1, "fork failed\n");
    187f:	83 ec 08             	sub    $0x8,%esp
    1882:	68 c9 48 00 00       	push   $0x48c9
    1887:	6a 01                	push   $0x1
    1889:	e8 1a 1e 00 00       	call   36a8 <printf>
      exit();
    188e:	e8 e8 1c 00 00       	call   357b <exit>
      close(fd);
    1893:	83 ec 0c             	sub    $0xc,%esp
    1896:	50                   	push   %eax
    1897:	e8 07 1d 00 00       	call   35a3 <close>
    189c:	83 c4 10             	add    $0x10,%esp
    189f:	e9 e9 fe ff ff       	jmp    178d <concreate+0x161>
        printf(1, "concreate weird file %s\n", de.name);
    18a4:	50                   	push   %eax
    18a5:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    18a8:	50                   	push   %eax
    18a9:	68 10 40 00 00       	push   $0x4010
    18ae:	6a 01                	push   $0x1
    18b0:	e8 f3 1d 00 00       	call   36a8 <printf>
        exit();
    18b5:	e8 c1 1c 00 00       	call   357b <exit>
    printf(1, "concreate not enough files in directory listing\n");
    18ba:	51                   	push   %ecx
    18bb:	51                   	push   %ecx
    18bc:	68 98 4b 00 00       	push   $0x4b98
    18c1:	6a 01                	push   $0x1
    18c3:	e8 e0 1d 00 00       	call   36a8 <printf>
    exit();
    18c8:	e8 ae 1c 00 00       	call   357b <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    18cd:	50                   	push   %eax
    18ce:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    18d1:	50                   	push   %eax
    18d2:	68 29 40 00 00       	push   $0x4029
    18d7:	6a 01                	push   $0x1
    18d9:	e8 ca 1d 00 00       	call   36a8 <printf>
        exit();
    18de:	e8 98 1c 00 00       	call   357b <exit>
    18e3:	90                   	nop

000018e4 <linkunlink>:
{
    18e4:	55                   	push   %ebp
    18e5:	89 e5                	mov    %esp,%ebp
    18e7:	57                   	push   %edi
    18e8:	56                   	push   %esi
    18e9:	53                   	push   %ebx
    18ea:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    18ed:	68 54 40 00 00       	push   $0x4054
    18f2:	6a 01                	push   $0x1
    18f4:	e8 af 1d 00 00       	call   36a8 <printf>
  unlink("x");
    18f9:	c7 04 24 e1 42 00 00 	movl   $0x42e1,(%esp)
    1900:	e8 c6 1c 00 00       	call   35cb <unlink>
  pid = fork();
    1905:	e8 69 1c 00 00       	call   3573 <fork>
    190a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    190d:	83 c4 10             	add    $0x10,%esp
    1910:	85 c0                	test   %eax,%eax
    1912:	0f 88 d3 00 00 00    	js     19eb <linkunlink+0x107>
  unsigned int x = (pid ? 1 : 97);
    1918:	0f 85 a1 00 00 00    	jne    19bf <linkunlink+0xdb>
    191e:	bf 61 00 00 00       	mov    $0x61,%edi
    1923:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1928:	be 03 00 00 00       	mov    $0x3,%esi
    192d:	eb 1b                	jmp    194a <linkunlink+0x66>
    192f:	90                   	nop
    } else if((x % 3) == 1){
    1930:	4a                   	dec    %edx
    1931:	0f 84 95 00 00 00    	je     19cc <linkunlink+0xe8>
      unlink("x");
    1937:	83 ec 0c             	sub    $0xc,%esp
    193a:	68 e1 42 00 00       	push   $0x42e1
    193f:	e8 87 1c 00 00       	call   35cb <unlink>
    1944:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1947:	4b                   	dec    %ebx
    1948:	74 52                	je     199c <linkunlink+0xb8>
    x = x * 1103515245 + 12345;
    194a:	89 f8                	mov    %edi,%eax
    194c:	c1 e0 09             	shl    $0x9,%eax
    194f:	29 f8                	sub    %edi,%eax
    1951:	8d 14 87             	lea    (%edi,%eax,4),%edx
    1954:	89 d0                	mov    %edx,%eax
    1956:	c1 e0 09             	shl    $0x9,%eax
    1959:	29 d0                	sub    %edx,%eax
    195b:	01 c0                	add    %eax,%eax
    195d:	01 f8                	add    %edi,%eax
    195f:	89 c2                	mov    %eax,%edx
    1961:	c1 e2 05             	shl    $0x5,%edx
    1964:	01 d0                	add    %edx,%eax
    1966:	c1 e0 02             	shl    $0x2,%eax
    1969:	29 f8                	sub    %edi,%eax
    196b:	8d bc 87 39 30 00 00 	lea    0x3039(%edi,%eax,4),%edi
    if((x % 3) == 0){
    1972:	89 f8                	mov    %edi,%eax
    1974:	31 d2                	xor    %edx,%edx
    1976:	f7 f6                	div    %esi
    1978:	85 d2                	test   %edx,%edx
    197a:	75 b4                	jne    1930 <linkunlink+0x4c>
      close(open("x", O_RDWR | O_CREATE));
    197c:	83 ec 08             	sub    $0x8,%esp
    197f:	68 02 02 00 00       	push   $0x202
    1984:	68 e1 42 00 00       	push   $0x42e1
    1989:	e8 2d 1c 00 00       	call   35bb <open>
    198e:	89 04 24             	mov    %eax,(%esp)
    1991:	e8 0d 1c 00 00       	call   35a3 <close>
    1996:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1999:	4b                   	dec    %ebx
    199a:	75 ae                	jne    194a <linkunlink+0x66>
  if(pid)
    199c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    199f:	85 c0                	test   %eax,%eax
    19a1:	74 43                	je     19e6 <linkunlink+0x102>
    wait();
    19a3:	e8 db 1b 00 00       	call   3583 <wait>
  printf(1, "linkunlink ok\n");
    19a8:	83 ec 08             	sub    $0x8,%esp
    19ab:	68 69 40 00 00       	push   $0x4069
    19b0:	6a 01                	push   $0x1
    19b2:	e8 f1 1c 00 00       	call   36a8 <printf>
}
    19b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19ba:	5b                   	pop    %ebx
    19bb:	5e                   	pop    %esi
    19bc:	5f                   	pop    %edi
    19bd:	5d                   	pop    %ebp
    19be:	c3                   	ret
  unsigned int x = (pid ? 1 : 97);
    19bf:	bf 01 00 00 00       	mov    $0x1,%edi
    19c4:	e9 5a ff ff ff       	jmp    1923 <linkunlink+0x3f>
    19c9:	8d 76 00             	lea    0x0(%esi),%esi
      link("cat", "x");
    19cc:	83 ec 08             	sub    $0x8,%esp
    19cf:	68 e1 42 00 00       	push   $0x42e1
    19d4:	68 65 40 00 00       	push   $0x4065
    19d9:	e8 fd 1b 00 00       	call   35db <link>
    19de:	83 c4 10             	add    $0x10,%esp
    19e1:	e9 61 ff ff ff       	jmp    1947 <linkunlink+0x63>
    exit();
    19e6:	e8 90 1b 00 00       	call   357b <exit>
    printf(1, "fork failed\n");
    19eb:	52                   	push   %edx
    19ec:	52                   	push   %edx
    19ed:	68 c9 48 00 00       	push   $0x48c9
    19f2:	6a 01                	push   $0x1
    19f4:	e8 af 1c 00 00       	call   36a8 <printf>
    exit();
    19f9:	e8 7d 1b 00 00       	call   357b <exit>
    19fe:	66 90                	xchg   %ax,%ax

00001a00 <bigdir>:
{
    1a00:	55                   	push   %ebp
    1a01:	89 e5                	mov    %esp,%ebp
    1a03:	57                   	push   %edi
    1a04:	56                   	push   %esi
    1a05:	53                   	push   %ebx
    1a06:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1a09:	68 78 40 00 00       	push   $0x4078
    1a0e:	6a 01                	push   $0x1
    1a10:	e8 93 1c 00 00       	call   36a8 <printf>
  unlink("bd");
    1a15:	c7 04 24 85 40 00 00 	movl   $0x4085,(%esp)
    1a1c:	e8 aa 1b 00 00       	call   35cb <unlink>
  fd = open("bd", O_CREATE);
    1a21:	5a                   	pop    %edx
    1a22:	59                   	pop    %ecx
    1a23:	68 00 02 00 00       	push   $0x200
    1a28:	68 85 40 00 00       	push   $0x4085
    1a2d:	e8 89 1b 00 00       	call   35bb <open>
  if(fd < 0){
    1a32:	83 c4 10             	add    $0x10,%esp
    1a35:	85 c0                	test   %eax,%eax
    1a37:	0f 88 dc 00 00 00    	js     1b19 <bigdir+0x119>
  close(fd);
    1a3d:	83 ec 0c             	sub    $0xc,%esp
    1a40:	50                   	push   %eax
    1a41:	e8 5d 1b 00 00       	call   35a3 <close>
    1a46:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1a49:	31 f6                	xor    %esi,%esi
    1a4b:	8d 7d de             	lea    -0x22(%ebp),%edi
    1a4e:	66 90                	xchg   %ax,%ax
    name[0] = 'x';
    1a50:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1a54:	89 f0                	mov    %esi,%eax
    1a56:	c1 f8 06             	sar    $0x6,%eax
    1a59:	83 c0 30             	add    $0x30,%eax
    1a5c:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1a5f:	89 f0                	mov    %esi,%eax
    1a61:	83 e0 3f             	and    $0x3f,%eax
    1a64:	83 c0 30             	add    $0x30,%eax
    1a67:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1a6a:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(link("bd", name) != 0){
    1a6e:	83 ec 08             	sub    $0x8,%esp
    1a71:	57                   	push   %edi
    1a72:	68 85 40 00 00       	push   $0x4085
    1a77:	e8 5f 1b 00 00       	call   35db <link>
    1a7c:	89 c3                	mov    %eax,%ebx
    1a7e:	83 c4 10             	add    $0x10,%esp
    1a81:	85 c0                	test   %eax,%eax
    1a83:	75 6c                	jne    1af1 <bigdir+0xf1>
  for(i = 0; i < 500; i++){
    1a85:	46                   	inc    %esi
    1a86:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1a8c:	75 c2                	jne    1a50 <bigdir+0x50>
  unlink("bd");
    1a8e:	83 ec 0c             	sub    $0xc,%esp
    1a91:	68 85 40 00 00       	push   $0x4085
    1a96:	e8 30 1b 00 00       	call   35cb <unlink>
    1a9b:	83 c4 10             	add    $0x10,%esp
    1a9e:	66 90                	xchg   %ax,%ax
    name[0] = 'x';
    1aa0:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1aa4:	89 d8                	mov    %ebx,%eax
    1aa6:	c1 f8 06             	sar    $0x6,%eax
    1aa9:	83 c0 30             	add    $0x30,%eax
    1aac:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1aaf:	89 d8                	mov    %ebx,%eax
    1ab1:	83 e0 3f             	and    $0x3f,%eax
    1ab4:	83 c0 30             	add    $0x30,%eax
    1ab7:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    1aba:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(unlink(name) != 0){
    1abe:	83 ec 0c             	sub    $0xc,%esp
    1ac1:	57                   	push   %edi
    1ac2:	e8 04 1b 00 00       	call   35cb <unlink>
    1ac7:	83 c4 10             	add    $0x10,%esp
    1aca:	85 c0                	test   %eax,%eax
    1acc:	75 37                	jne    1b05 <bigdir+0x105>
  for(i = 0; i < 500; i++){
    1ace:	43                   	inc    %ebx
    1acf:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1ad5:	75 c9                	jne    1aa0 <bigdir+0xa0>
  printf(1, "bigdir ok\n");
    1ad7:	83 ec 08             	sub    $0x8,%esp
    1ada:	68 c7 40 00 00       	push   $0x40c7
    1adf:	6a 01                	push   $0x1
    1ae1:	e8 c2 1b 00 00       	call   36a8 <printf>
    1ae6:	83 c4 10             	add    $0x10,%esp
}
    1ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1aec:	5b                   	pop    %ebx
    1aed:	5e                   	pop    %esi
    1aee:	5f                   	pop    %edi
    1aef:	5d                   	pop    %ebp
    1af0:	c3                   	ret
      printf(1, "bigdir link failed\n");
    1af1:	83 ec 08             	sub    $0x8,%esp
    1af4:	68 9e 40 00 00       	push   $0x409e
    1af9:	6a 01                	push   $0x1
    1afb:	e8 a8 1b 00 00       	call   36a8 <printf>
      exit();
    1b00:	e8 76 1a 00 00       	call   357b <exit>
      printf(1, "bigdir unlink failed");
    1b05:	83 ec 08             	sub    $0x8,%esp
    1b08:	68 b2 40 00 00       	push   $0x40b2
    1b0d:	6a 01                	push   $0x1
    1b0f:	e8 94 1b 00 00       	call   36a8 <printf>
      exit();
    1b14:	e8 62 1a 00 00       	call   357b <exit>
    printf(1, "bigdir create failed\n");
    1b19:	50                   	push   %eax
    1b1a:	50                   	push   %eax
    1b1b:	68 88 40 00 00       	push   $0x4088
    1b20:	6a 01                	push   $0x1
    1b22:	e8 81 1b 00 00       	call   36a8 <printf>
    exit();
    1b27:	e8 4f 1a 00 00       	call   357b <exit>

00001b2c <subdir>:
{
    1b2c:	55                   	push   %ebp
    1b2d:	89 e5                	mov    %esp,%ebp
    1b2f:	53                   	push   %ebx
    1b30:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1b33:	68 d2 40 00 00       	push   $0x40d2
    1b38:	6a 01                	push   $0x1
    1b3a:	e8 69 1b 00 00       	call   36a8 <printf>
  unlink("ff");
    1b3f:	c7 04 24 5b 41 00 00 	movl   $0x415b,(%esp)
    1b46:	e8 80 1a 00 00       	call   35cb <unlink>
  if(mkdir("dd") != 0){
    1b4b:	c7 04 24 f8 41 00 00 	movl   $0x41f8,(%esp)
    1b52:	e8 8c 1a 00 00       	call   35e3 <mkdir>
    1b57:	83 c4 10             	add    $0x10,%esp
    1b5a:	85 c0                	test   %eax,%eax
    1b5c:	0f 85 ab 05 00 00    	jne    210d <subdir+0x5e1>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b62:	83 ec 08             	sub    $0x8,%esp
    1b65:	68 02 02 00 00       	push   $0x202
    1b6a:	68 31 41 00 00       	push   $0x4131
    1b6f:	e8 47 1a 00 00       	call   35bb <open>
    1b74:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b76:	83 c4 10             	add    $0x10,%esp
    1b79:	85 c0                	test   %eax,%eax
    1b7b:	0f 88 79 05 00 00    	js     20fa <subdir+0x5ce>
  write(fd, "ff", 2);
    1b81:	50                   	push   %eax
    1b82:	6a 02                	push   $0x2
    1b84:	68 5b 41 00 00       	push   $0x415b
    1b89:	53                   	push   %ebx
    1b8a:	e8 0c 1a 00 00       	call   359b <write>
  close(fd);
    1b8f:	89 1c 24             	mov    %ebx,(%esp)
    1b92:	e8 0c 1a 00 00       	call   35a3 <close>
  if(unlink("dd") >= 0){
    1b97:	c7 04 24 f8 41 00 00 	movl   $0x41f8,(%esp)
    1b9e:	e8 28 1a 00 00       	call   35cb <unlink>
    1ba3:	83 c4 10             	add    $0x10,%esp
    1ba6:	85 c0                	test   %eax,%eax
    1ba8:	0f 89 39 05 00 00    	jns    20e7 <subdir+0x5bb>
  if(mkdir("/dd/dd") != 0){
    1bae:	83 ec 0c             	sub    $0xc,%esp
    1bb1:	68 0c 41 00 00       	push   $0x410c
    1bb6:	e8 28 1a 00 00       	call   35e3 <mkdir>
    1bbb:	83 c4 10             	add    $0x10,%esp
    1bbe:	85 c0                	test   %eax,%eax
    1bc0:	0f 85 0e 05 00 00    	jne    20d4 <subdir+0x5a8>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1bc6:	83 ec 08             	sub    $0x8,%esp
    1bc9:	68 02 02 00 00       	push   $0x202
    1bce:	68 2e 41 00 00       	push   $0x412e
    1bd3:	e8 e3 19 00 00       	call   35bb <open>
    1bd8:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bda:	83 c4 10             	add    $0x10,%esp
    1bdd:	85 c0                	test   %eax,%eax
    1bdf:	0f 88 1e 04 00 00    	js     2003 <subdir+0x4d7>
  write(fd, "FF", 2);
    1be5:	50                   	push   %eax
    1be6:	6a 02                	push   $0x2
    1be8:	68 4f 41 00 00       	push   $0x414f
    1bed:	53                   	push   %ebx
    1bee:	e8 a8 19 00 00       	call   359b <write>
  close(fd);
    1bf3:	89 1c 24             	mov    %ebx,(%esp)
    1bf6:	e8 a8 19 00 00       	call   35a3 <close>
  fd = open("dd/dd/../ff", 0);
    1bfb:	58                   	pop    %eax
    1bfc:	5a                   	pop    %edx
    1bfd:	6a 00                	push   $0x0
    1bff:	68 52 41 00 00       	push   $0x4152
    1c04:	e8 b2 19 00 00       	call   35bb <open>
    1c09:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1c0b:	83 c4 10             	add    $0x10,%esp
    1c0e:	85 c0                	test   %eax,%eax
    1c10:	0f 88 da 03 00 00    	js     1ff0 <subdir+0x4c4>
  cc = read(fd, buf, sizeof(buf));
    1c16:	50                   	push   %eax
    1c17:	68 00 20 00 00       	push   $0x2000
    1c1c:	68 e0 78 00 00       	push   $0x78e0
    1c21:	53                   	push   %ebx
    1c22:	e8 6c 19 00 00       	call   3593 <read>
  if(cc != 2 || buf[0] != 'f'){
    1c27:	83 c4 10             	add    $0x10,%esp
    1c2a:	83 f8 02             	cmp    $0x2,%eax
    1c2d:	0f 85 38 03 00 00    	jne    1f6b <subdir+0x43f>
    1c33:	80 3d e0 78 00 00 66 	cmpb   $0x66,0x78e0
    1c3a:	0f 85 2b 03 00 00    	jne    1f6b <subdir+0x43f>
  close(fd);
    1c40:	83 ec 0c             	sub    $0xc,%esp
    1c43:	53                   	push   %ebx
    1c44:	e8 5a 19 00 00       	call   35a3 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c49:	58                   	pop    %eax
    1c4a:	5a                   	pop    %edx
    1c4b:	68 92 41 00 00       	push   $0x4192
    1c50:	68 2e 41 00 00       	push   $0x412e
    1c55:	e8 81 19 00 00       	call   35db <link>
    1c5a:	83 c4 10             	add    $0x10,%esp
    1c5d:	85 c0                	test   %eax,%eax
    1c5f:	0f 85 c4 03 00 00    	jne    2029 <subdir+0x4fd>
  if(unlink("dd/dd/ff") != 0){
    1c65:	83 ec 0c             	sub    $0xc,%esp
    1c68:	68 2e 41 00 00       	push   $0x412e
    1c6d:	e8 59 19 00 00       	call   35cb <unlink>
    1c72:	83 c4 10             	add    $0x10,%esp
    1c75:	85 c0                	test   %eax,%eax
    1c77:	0f 85 14 03 00 00    	jne    1f91 <subdir+0x465>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1c7d:	83 ec 08             	sub    $0x8,%esp
    1c80:	6a 00                	push   $0x0
    1c82:	68 2e 41 00 00       	push   $0x412e
    1c87:	e8 2f 19 00 00       	call   35bb <open>
    1c8c:	83 c4 10             	add    $0x10,%esp
    1c8f:	85 c0                	test   %eax,%eax
    1c91:	0f 89 2a 04 00 00    	jns    20c1 <subdir+0x595>
  if(chdir("dd") != 0){
    1c97:	83 ec 0c             	sub    $0xc,%esp
    1c9a:	68 f8 41 00 00       	push   $0x41f8
    1c9f:	e8 47 19 00 00       	call   35eb <chdir>
    1ca4:	83 c4 10             	add    $0x10,%esp
    1ca7:	85 c0                	test   %eax,%eax
    1ca9:	0f 85 ff 03 00 00    	jne    20ae <subdir+0x582>
  if(chdir("dd/../../dd") != 0){
    1caf:	83 ec 0c             	sub    $0xc,%esp
    1cb2:	68 c6 41 00 00       	push   $0x41c6
    1cb7:	e8 2f 19 00 00       	call   35eb <chdir>
    1cbc:	83 c4 10             	add    $0x10,%esp
    1cbf:	85 c0                	test   %eax,%eax
    1cc1:	0f 85 b7 02 00 00    	jne    1f7e <subdir+0x452>
  if(chdir("dd/../../../dd") != 0){
    1cc7:	83 ec 0c             	sub    $0xc,%esp
    1cca:	68 ec 41 00 00       	push   $0x41ec
    1ccf:	e8 17 19 00 00       	call   35eb <chdir>
    1cd4:	83 c4 10             	add    $0x10,%esp
    1cd7:	85 c0                	test   %eax,%eax
    1cd9:	0f 85 9f 02 00 00    	jne    1f7e <subdir+0x452>
  if(chdir("./..") != 0){
    1cdf:	83 ec 0c             	sub    $0xc,%esp
    1ce2:	68 fb 41 00 00       	push   $0x41fb
    1ce7:	e8 ff 18 00 00       	call   35eb <chdir>
    1cec:	83 c4 10             	add    $0x10,%esp
    1cef:	85 c0                	test   %eax,%eax
    1cf1:	0f 85 1f 03 00 00    	jne    2016 <subdir+0x4ea>
  fd = open("dd/dd/ffff", 0);
    1cf7:	83 ec 08             	sub    $0x8,%esp
    1cfa:	6a 00                	push   $0x0
    1cfc:	68 92 41 00 00       	push   $0x4192
    1d01:	e8 b5 18 00 00       	call   35bb <open>
    1d06:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d08:	83 c4 10             	add    $0x10,%esp
    1d0b:	85 c0                	test   %eax,%eax
    1d0d:	0f 88 de 04 00 00    	js     21f1 <subdir+0x6c5>
  if(read(fd, buf, sizeof(buf)) != 2){
    1d13:	50                   	push   %eax
    1d14:	68 00 20 00 00       	push   $0x2000
    1d19:	68 e0 78 00 00       	push   $0x78e0
    1d1e:	53                   	push   %ebx
    1d1f:	e8 6f 18 00 00       	call   3593 <read>
    1d24:	83 c4 10             	add    $0x10,%esp
    1d27:	83 f8 02             	cmp    $0x2,%eax
    1d2a:	0f 85 ae 04 00 00    	jne    21de <subdir+0x6b2>
  close(fd);
    1d30:	83 ec 0c             	sub    $0xc,%esp
    1d33:	53                   	push   %ebx
    1d34:	e8 6a 18 00 00       	call   35a3 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1d39:	58                   	pop    %eax
    1d3a:	5a                   	pop    %edx
    1d3b:	6a 00                	push   $0x0
    1d3d:	68 2e 41 00 00       	push   $0x412e
    1d42:	e8 74 18 00 00       	call   35bb <open>
    1d47:	83 c4 10             	add    $0x10,%esp
    1d4a:	85 c0                	test   %eax,%eax
    1d4c:	0f 89 65 02 00 00    	jns    1fb7 <subdir+0x48b>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1d52:	83 ec 08             	sub    $0x8,%esp
    1d55:	68 02 02 00 00       	push   $0x202
    1d5a:	68 46 42 00 00       	push   $0x4246
    1d5f:	e8 57 18 00 00       	call   35bb <open>
    1d64:	83 c4 10             	add    $0x10,%esp
    1d67:	85 c0                	test   %eax,%eax
    1d69:	0f 89 35 02 00 00    	jns    1fa4 <subdir+0x478>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1d6f:	83 ec 08             	sub    $0x8,%esp
    1d72:	68 02 02 00 00       	push   $0x202
    1d77:	68 6b 42 00 00       	push   $0x426b
    1d7c:	e8 3a 18 00 00       	call   35bb <open>
    1d81:	83 c4 10             	add    $0x10,%esp
    1d84:	85 c0                	test   %eax,%eax
    1d86:	0f 89 0f 03 00 00    	jns    209b <subdir+0x56f>
  if(open("dd", O_CREATE) >= 0){
    1d8c:	83 ec 08             	sub    $0x8,%esp
    1d8f:	68 00 02 00 00       	push   $0x200
    1d94:	68 f8 41 00 00       	push   $0x41f8
    1d99:	e8 1d 18 00 00       	call   35bb <open>
    1d9e:	83 c4 10             	add    $0x10,%esp
    1da1:	85 c0                	test   %eax,%eax
    1da3:	0f 89 df 02 00 00    	jns    2088 <subdir+0x55c>
  if(open("dd", O_RDWR) >= 0){
    1da9:	83 ec 08             	sub    $0x8,%esp
    1dac:	6a 02                	push   $0x2
    1dae:	68 f8 41 00 00       	push   $0x41f8
    1db3:	e8 03 18 00 00       	call   35bb <open>
    1db8:	83 c4 10             	add    $0x10,%esp
    1dbb:	85 c0                	test   %eax,%eax
    1dbd:	0f 89 b2 02 00 00    	jns    2075 <subdir+0x549>
  if(open("dd", O_WRONLY) >= 0){
    1dc3:	83 ec 08             	sub    $0x8,%esp
    1dc6:	6a 01                	push   $0x1
    1dc8:	68 f8 41 00 00       	push   $0x41f8
    1dcd:	e8 e9 17 00 00       	call   35bb <open>
    1dd2:	83 c4 10             	add    $0x10,%esp
    1dd5:	85 c0                	test   %eax,%eax
    1dd7:	0f 89 85 02 00 00    	jns    2062 <subdir+0x536>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1ddd:	83 ec 08             	sub    $0x8,%esp
    1de0:	68 da 42 00 00       	push   $0x42da
    1de5:	68 46 42 00 00       	push   $0x4246
    1dea:	e8 ec 17 00 00       	call   35db <link>
    1def:	83 c4 10             	add    $0x10,%esp
    1df2:	85 c0                	test   %eax,%eax
    1df4:	0f 84 55 02 00 00    	je     204f <subdir+0x523>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1dfa:	83 ec 08             	sub    $0x8,%esp
    1dfd:	68 da 42 00 00       	push   $0x42da
    1e02:	68 6b 42 00 00       	push   $0x426b
    1e07:	e8 cf 17 00 00       	call   35db <link>
    1e0c:	83 c4 10             	add    $0x10,%esp
    1e0f:	85 c0                	test   %eax,%eax
    1e11:	0f 84 25 02 00 00    	je     203c <subdir+0x510>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1e17:	83 ec 08             	sub    $0x8,%esp
    1e1a:	68 92 41 00 00       	push   $0x4192
    1e1f:	68 31 41 00 00       	push   $0x4131
    1e24:	e8 b2 17 00 00       	call   35db <link>
    1e29:	83 c4 10             	add    $0x10,%esp
    1e2c:	85 c0                	test   %eax,%eax
    1e2e:	0f 84 a9 01 00 00    	je     1fdd <subdir+0x4b1>
  if(mkdir("dd/ff/ff") == 0){
    1e34:	83 ec 0c             	sub    $0xc,%esp
    1e37:	68 46 42 00 00       	push   $0x4246
    1e3c:	e8 a2 17 00 00       	call   35e3 <mkdir>
    1e41:	83 c4 10             	add    $0x10,%esp
    1e44:	85 c0                	test   %eax,%eax
    1e46:	0f 84 7e 01 00 00    	je     1fca <subdir+0x49e>
  if(mkdir("dd/xx/ff") == 0){
    1e4c:	83 ec 0c             	sub    $0xc,%esp
    1e4f:	68 6b 42 00 00       	push   $0x426b
    1e54:	e8 8a 17 00 00       	call   35e3 <mkdir>
    1e59:	83 c4 10             	add    $0x10,%esp
    1e5c:	85 c0                	test   %eax,%eax
    1e5e:	0f 84 67 03 00 00    	je     21cb <subdir+0x69f>
  if(mkdir("dd/dd/ffff") == 0){
    1e64:	83 ec 0c             	sub    $0xc,%esp
    1e67:	68 92 41 00 00       	push   $0x4192
    1e6c:	e8 72 17 00 00       	call   35e3 <mkdir>
    1e71:	83 c4 10             	add    $0x10,%esp
    1e74:	85 c0                	test   %eax,%eax
    1e76:	0f 84 3c 03 00 00    	je     21b8 <subdir+0x68c>
  if(unlink("dd/xx/ff") == 0){
    1e7c:	83 ec 0c             	sub    $0xc,%esp
    1e7f:	68 6b 42 00 00       	push   $0x426b
    1e84:	e8 42 17 00 00       	call   35cb <unlink>
    1e89:	83 c4 10             	add    $0x10,%esp
    1e8c:	85 c0                	test   %eax,%eax
    1e8e:	0f 84 11 03 00 00    	je     21a5 <subdir+0x679>
  if(unlink("dd/ff/ff") == 0){
    1e94:	83 ec 0c             	sub    $0xc,%esp
    1e97:	68 46 42 00 00       	push   $0x4246
    1e9c:	e8 2a 17 00 00       	call   35cb <unlink>
    1ea1:	83 c4 10             	add    $0x10,%esp
    1ea4:	85 c0                	test   %eax,%eax
    1ea6:	0f 84 e6 02 00 00    	je     2192 <subdir+0x666>
  if(chdir("dd/ff") == 0){
    1eac:	83 ec 0c             	sub    $0xc,%esp
    1eaf:	68 31 41 00 00       	push   $0x4131
    1eb4:	e8 32 17 00 00       	call   35eb <chdir>
    1eb9:	83 c4 10             	add    $0x10,%esp
    1ebc:	85 c0                	test   %eax,%eax
    1ebe:	0f 84 bb 02 00 00    	je     217f <subdir+0x653>
  if(chdir("dd/xx") == 0){
    1ec4:	83 ec 0c             	sub    $0xc,%esp
    1ec7:	68 dd 42 00 00       	push   $0x42dd
    1ecc:	e8 1a 17 00 00       	call   35eb <chdir>
    1ed1:	83 c4 10             	add    $0x10,%esp
    1ed4:	85 c0                	test   %eax,%eax
    1ed6:	0f 84 90 02 00 00    	je     216c <subdir+0x640>
  if(unlink("dd/dd/ffff") != 0){
    1edc:	83 ec 0c             	sub    $0xc,%esp
    1edf:	68 92 41 00 00       	push   $0x4192
    1ee4:	e8 e2 16 00 00       	call   35cb <unlink>
    1ee9:	83 c4 10             	add    $0x10,%esp
    1eec:	85 c0                	test   %eax,%eax
    1eee:	0f 85 9d 00 00 00    	jne    1f91 <subdir+0x465>
  if(unlink("dd/ff") != 0){
    1ef4:	83 ec 0c             	sub    $0xc,%esp
    1ef7:	68 31 41 00 00       	push   $0x4131
    1efc:	e8 ca 16 00 00       	call   35cb <unlink>
    1f01:	83 c4 10             	add    $0x10,%esp
    1f04:	85 c0                	test   %eax,%eax
    1f06:	0f 85 4d 02 00 00    	jne    2159 <subdir+0x62d>
  if(unlink("dd") == 0){
    1f0c:	83 ec 0c             	sub    $0xc,%esp
    1f0f:	68 f8 41 00 00       	push   $0x41f8
    1f14:	e8 b2 16 00 00       	call   35cb <unlink>
    1f19:	83 c4 10             	add    $0x10,%esp
    1f1c:	85 c0                	test   %eax,%eax
    1f1e:	0f 84 22 02 00 00    	je     2146 <subdir+0x61a>
  if(unlink("dd/dd") < 0){
    1f24:	83 ec 0c             	sub    $0xc,%esp
    1f27:	68 0d 41 00 00       	push   $0x410d
    1f2c:	e8 9a 16 00 00       	call   35cb <unlink>
    1f31:	83 c4 10             	add    $0x10,%esp
    1f34:	85 c0                	test   %eax,%eax
    1f36:	0f 88 f7 01 00 00    	js     2133 <subdir+0x607>
  if(unlink("dd") < 0){
    1f3c:	83 ec 0c             	sub    $0xc,%esp
    1f3f:	68 f8 41 00 00       	push   $0x41f8
    1f44:	e8 82 16 00 00       	call   35cb <unlink>
    1f49:	83 c4 10             	add    $0x10,%esp
    1f4c:	85 c0                	test   %eax,%eax
    1f4e:	0f 88 cc 01 00 00    	js     2120 <subdir+0x5f4>
  printf(1, "subdir ok\n");
    1f54:	83 ec 08             	sub    $0x8,%esp
    1f57:	68 da 43 00 00       	push   $0x43da
    1f5c:	6a 01                	push   $0x1
    1f5e:	e8 45 17 00 00       	call   36a8 <printf>
}
    1f63:	83 c4 10             	add    $0x10,%esp
    1f66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f69:	c9                   	leave
    1f6a:	c3                   	ret
    printf(1, "dd/dd/../ff wrong content\n");
    1f6b:	51                   	push   %ecx
    1f6c:	51                   	push   %ecx
    1f6d:	68 77 41 00 00       	push   $0x4177
    1f72:	6a 01                	push   $0x1
    1f74:	e8 2f 17 00 00       	call   36a8 <printf>
    exit();
    1f79:	e8 fd 15 00 00       	call   357b <exit>
    printf(1, "chdir dd/../../dd failed\n");
    1f7e:	50                   	push   %eax
    1f7f:	50                   	push   %eax
    1f80:	68 d2 41 00 00       	push   $0x41d2
    1f85:	6a 01                	push   $0x1
    1f87:	e8 1c 17 00 00       	call   36a8 <printf>
    exit();
    1f8c:	e8 ea 15 00 00       	call   357b <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    1f91:	51                   	push   %ecx
    1f92:	51                   	push   %ecx
    1f93:	68 9d 41 00 00       	push   $0x419d
    1f98:	6a 01                	push   $0x1
    1f9a:	e8 09 17 00 00       	call   36a8 <printf>
    exit();
    1f9f:	e8 d7 15 00 00       	call   357b <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    1fa4:	51                   	push   %ecx
    1fa5:	51                   	push   %ecx
    1fa6:	68 4f 42 00 00       	push   $0x424f
    1fab:	6a 01                	push   $0x1
    1fad:	e8 f6 16 00 00       	call   36a8 <printf>
    exit();
    1fb2:	e8 c4 15 00 00       	call   357b <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    1fb7:	53                   	push   %ebx
    1fb8:	53                   	push   %ebx
    1fb9:	68 3c 4c 00 00       	push   $0x4c3c
    1fbe:	6a 01                	push   $0x1
    1fc0:	e8 e3 16 00 00       	call   36a8 <printf>
    exit();
    1fc5:	e8 b1 15 00 00       	call   357b <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    1fca:	51                   	push   %ecx
    1fcb:	51                   	push   %ecx
    1fcc:	68 e3 42 00 00       	push   $0x42e3
    1fd1:	6a 01                	push   $0x1
    1fd3:	e8 d0 16 00 00       	call   36a8 <printf>
    exit();
    1fd8:	e8 9e 15 00 00       	call   357b <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    1fdd:	53                   	push   %ebx
    1fde:	53                   	push   %ebx
    1fdf:	68 ac 4c 00 00       	push   $0x4cac
    1fe4:	6a 01                	push   $0x1
    1fe6:	e8 bd 16 00 00       	call   36a8 <printf>
    exit();
    1feb:	e8 8b 15 00 00       	call   357b <exit>
    printf(1, "open dd/dd/../ff failed\n");
    1ff0:	50                   	push   %eax
    1ff1:	50                   	push   %eax
    1ff2:	68 5e 41 00 00       	push   $0x415e
    1ff7:	6a 01                	push   $0x1
    1ff9:	e8 aa 16 00 00       	call   36a8 <printf>
    exit();
    1ffe:	e8 78 15 00 00       	call   357b <exit>
    printf(1, "create dd/dd/ff failed\n");
    2003:	51                   	push   %ecx
    2004:	51                   	push   %ecx
    2005:	68 37 41 00 00       	push   $0x4137
    200a:	6a 01                	push   $0x1
    200c:	e8 97 16 00 00       	call   36a8 <printf>
    exit();
    2011:	e8 65 15 00 00       	call   357b <exit>
    printf(1, "chdir ./.. failed\n");
    2016:	50                   	push   %eax
    2017:	50                   	push   %eax
    2018:	68 00 42 00 00       	push   $0x4200
    201d:	6a 01                	push   $0x1
    201f:	e8 84 16 00 00       	call   36a8 <printf>
    exit();
    2024:	e8 52 15 00 00       	call   357b <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2029:	53                   	push   %ebx
    202a:	53                   	push   %ebx
    202b:	68 f4 4b 00 00       	push   $0x4bf4
    2030:	6a 01                	push   $0x1
    2032:	e8 71 16 00 00       	call   36a8 <printf>
    exit();
    2037:	e8 3f 15 00 00       	call   357b <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    203c:	50                   	push   %eax
    203d:	50                   	push   %eax
    203e:	68 88 4c 00 00       	push   $0x4c88
    2043:	6a 01                	push   $0x1
    2045:	e8 5e 16 00 00       	call   36a8 <printf>
    exit();
    204a:	e8 2c 15 00 00       	call   357b <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    204f:	50                   	push   %eax
    2050:	50                   	push   %eax
    2051:	68 64 4c 00 00       	push   $0x4c64
    2056:	6a 01                	push   $0x1
    2058:	e8 4b 16 00 00       	call   36a8 <printf>
    exit();
    205d:	e8 19 15 00 00       	call   357b <exit>
    printf(1, "open dd wronly succeeded!\n");
    2062:	50                   	push   %eax
    2063:	50                   	push   %eax
    2064:	68 bf 42 00 00       	push   $0x42bf
    2069:	6a 01                	push   $0x1
    206b:	e8 38 16 00 00       	call   36a8 <printf>
    exit();
    2070:	e8 06 15 00 00       	call   357b <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2075:	50                   	push   %eax
    2076:	50                   	push   %eax
    2077:	68 a6 42 00 00       	push   $0x42a6
    207c:	6a 01                	push   $0x1
    207e:	e8 25 16 00 00       	call   36a8 <printf>
    exit();
    2083:	e8 f3 14 00 00       	call   357b <exit>
    printf(1, "create dd succeeded!\n");
    2088:	50                   	push   %eax
    2089:	50                   	push   %eax
    208a:	68 90 42 00 00       	push   $0x4290
    208f:	6a 01                	push   $0x1
    2091:	e8 12 16 00 00       	call   36a8 <printf>
    exit();
    2096:	e8 e0 14 00 00       	call   357b <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    209b:	52                   	push   %edx
    209c:	52                   	push   %edx
    209d:	68 74 42 00 00       	push   $0x4274
    20a2:	6a 01                	push   $0x1
    20a4:	e8 ff 15 00 00       	call   36a8 <printf>
    exit();
    20a9:	e8 cd 14 00 00       	call   357b <exit>
    printf(1, "chdir dd failed\n");
    20ae:	50                   	push   %eax
    20af:	50                   	push   %eax
    20b0:	68 b5 41 00 00       	push   $0x41b5
    20b5:	6a 01                	push   $0x1
    20b7:	e8 ec 15 00 00       	call   36a8 <printf>
    exit();
    20bc:	e8 ba 14 00 00       	call   357b <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    20c1:	52                   	push   %edx
    20c2:	52                   	push   %edx
    20c3:	68 18 4c 00 00       	push   $0x4c18
    20c8:	6a 01                	push   $0x1
    20ca:	e8 d9 15 00 00       	call   36a8 <printf>
    exit();
    20cf:	e8 a7 14 00 00       	call   357b <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    20d4:	53                   	push   %ebx
    20d5:	53                   	push   %ebx
    20d6:	68 13 41 00 00       	push   $0x4113
    20db:	6a 01                	push   $0x1
    20dd:	e8 c6 15 00 00       	call   36a8 <printf>
    exit();
    20e2:	e8 94 14 00 00       	call   357b <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    20e7:	50                   	push   %eax
    20e8:	50                   	push   %eax
    20e9:	68 cc 4b 00 00       	push   $0x4bcc
    20ee:	6a 01                	push   $0x1
    20f0:	e8 b3 15 00 00       	call   36a8 <printf>
    exit();
    20f5:	e8 81 14 00 00       	call   357b <exit>
    printf(1, "create dd/ff failed\n");
    20fa:	50                   	push   %eax
    20fb:	50                   	push   %eax
    20fc:	68 f7 40 00 00       	push   $0x40f7
    2101:	6a 01                	push   $0x1
    2103:	e8 a0 15 00 00       	call   36a8 <printf>
    exit();
    2108:	e8 6e 14 00 00       	call   357b <exit>
    printf(1, "subdir mkdir dd failed\n");
    210d:	50                   	push   %eax
    210e:	50                   	push   %eax
    210f:	68 df 40 00 00       	push   $0x40df
    2114:	6a 01                	push   $0x1
    2116:	e8 8d 15 00 00       	call   36a8 <printf>
    exit();
    211b:	e8 5b 14 00 00       	call   357b <exit>
    printf(1, "unlink dd failed\n");
    2120:	50                   	push   %eax
    2121:	50                   	push   %eax
    2122:	68 c8 43 00 00       	push   $0x43c8
    2127:	6a 01                	push   $0x1
    2129:	e8 7a 15 00 00       	call   36a8 <printf>
    exit();
    212e:	e8 48 14 00 00       	call   357b <exit>
    printf(1, "unlink dd/dd failed\n");
    2133:	52                   	push   %edx
    2134:	52                   	push   %edx
    2135:	68 b3 43 00 00       	push   $0x43b3
    213a:	6a 01                	push   $0x1
    213c:	e8 67 15 00 00       	call   36a8 <printf>
    exit();
    2141:	e8 35 14 00 00       	call   357b <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2146:	51                   	push   %ecx
    2147:	51                   	push   %ecx
    2148:	68 d0 4c 00 00       	push   $0x4cd0
    214d:	6a 01                	push   $0x1
    214f:	e8 54 15 00 00       	call   36a8 <printf>
    exit();
    2154:	e8 22 14 00 00       	call   357b <exit>
    printf(1, "unlink dd/ff failed\n");
    2159:	53                   	push   %ebx
    215a:	53                   	push   %ebx
    215b:	68 9e 43 00 00       	push   $0x439e
    2160:	6a 01                	push   $0x1
    2162:	e8 41 15 00 00       	call   36a8 <printf>
    exit();
    2167:	e8 0f 14 00 00       	call   357b <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    216c:	50                   	push   %eax
    216d:	50                   	push   %eax
    216e:	68 86 43 00 00       	push   $0x4386
    2173:	6a 01                	push   $0x1
    2175:	e8 2e 15 00 00       	call   36a8 <printf>
    exit();
    217a:	e8 fc 13 00 00       	call   357b <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    217f:	50                   	push   %eax
    2180:	50                   	push   %eax
    2181:	68 6e 43 00 00       	push   $0x436e
    2186:	6a 01                	push   $0x1
    2188:	e8 1b 15 00 00       	call   36a8 <printf>
    exit();
    218d:	e8 e9 13 00 00       	call   357b <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2192:	50                   	push   %eax
    2193:	50                   	push   %eax
    2194:	68 52 43 00 00       	push   $0x4352
    2199:	6a 01                	push   $0x1
    219b:	e8 08 15 00 00       	call   36a8 <printf>
    exit();
    21a0:	e8 d6 13 00 00       	call   357b <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    21a5:	50                   	push   %eax
    21a6:	50                   	push   %eax
    21a7:	68 36 43 00 00       	push   $0x4336
    21ac:	6a 01                	push   $0x1
    21ae:	e8 f5 14 00 00       	call   36a8 <printf>
    exit();
    21b3:	e8 c3 13 00 00       	call   357b <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    21b8:	50                   	push   %eax
    21b9:	50                   	push   %eax
    21ba:	68 19 43 00 00       	push   $0x4319
    21bf:	6a 01                	push   $0x1
    21c1:	e8 e2 14 00 00       	call   36a8 <printf>
    exit();
    21c6:	e8 b0 13 00 00       	call   357b <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    21cb:	52                   	push   %edx
    21cc:	52                   	push   %edx
    21cd:	68 fe 42 00 00       	push   $0x42fe
    21d2:	6a 01                	push   $0x1
    21d4:	e8 cf 14 00 00       	call   36a8 <printf>
    exit();
    21d9:	e8 9d 13 00 00       	call   357b <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    21de:	51                   	push   %ecx
    21df:	51                   	push   %ecx
    21e0:	68 2b 42 00 00       	push   $0x422b
    21e5:	6a 01                	push   $0x1
    21e7:	e8 bc 14 00 00       	call   36a8 <printf>
    exit();
    21ec:	e8 8a 13 00 00       	call   357b <exit>
    printf(1, "open dd/dd/ffff failed\n");
    21f1:	50                   	push   %eax
    21f2:	50                   	push   %eax
    21f3:	68 13 42 00 00       	push   $0x4213
    21f8:	6a 01                	push   $0x1
    21fa:	e8 a9 14 00 00       	call   36a8 <printf>
    exit();
    21ff:	e8 77 13 00 00       	call   357b <exit>

00002204 <bigwrite>:
{
    2204:	55                   	push   %ebp
    2205:	89 e5                	mov    %esp,%ebp
    2207:	56                   	push   %esi
    2208:	53                   	push   %ebx
  printf(1, "bigwrite test\n");
    2209:	83 ec 08             	sub    $0x8,%esp
    220c:	68 e5 43 00 00       	push   $0x43e5
    2211:	6a 01                	push   $0x1
    2213:	e8 90 14 00 00       	call   36a8 <printf>
  unlink("bigwrite");
    2218:	c7 04 24 f4 43 00 00 	movl   $0x43f4,(%esp)
    221f:	e8 a7 13 00 00       	call   35cb <unlink>
    2224:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2227:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    fd = open("bigwrite", O_CREATE | O_RDWR);
    222c:	83 ec 08             	sub    $0x8,%esp
    222f:	68 02 02 00 00       	push   $0x202
    2234:	68 f4 43 00 00       	push   $0x43f4
    2239:	e8 7d 13 00 00       	call   35bb <open>
    223e:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2240:	83 c4 10             	add    $0x10,%esp
    2243:	85 c0                	test   %eax,%eax
    2245:	78 7a                	js     22c1 <bigwrite+0xbd>
      int cc = write(fd, buf, sz);
    2247:	52                   	push   %edx
    2248:	53                   	push   %ebx
    2249:	68 e0 78 00 00       	push   $0x78e0
    224e:	50                   	push   %eax
    224f:	e8 47 13 00 00       	call   359b <write>
      if(cc != sz){
    2254:	83 c4 10             	add    $0x10,%esp
    2257:	39 c3                	cmp    %eax,%ebx
    2259:	75 53                	jne    22ae <bigwrite+0xaa>
      int cc = write(fd, buf, sz);
    225b:	50                   	push   %eax
    225c:	53                   	push   %ebx
    225d:	68 e0 78 00 00       	push   $0x78e0
    2262:	56                   	push   %esi
    2263:	e8 33 13 00 00       	call   359b <write>
      if(cc != sz){
    2268:	83 c4 10             	add    $0x10,%esp
    226b:	39 c3                	cmp    %eax,%ebx
    226d:	75 3f                	jne    22ae <bigwrite+0xaa>
    close(fd);
    226f:	83 ec 0c             	sub    $0xc,%esp
    2272:	56                   	push   %esi
    2273:	e8 2b 13 00 00       	call   35a3 <close>
    unlink("bigwrite");
    2278:	c7 04 24 f4 43 00 00 	movl   $0x43f4,(%esp)
    227f:	e8 47 13 00 00       	call   35cb <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2284:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    228a:	83 c4 10             	add    $0x10,%esp
    228d:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    2293:	75 97                	jne    222c <bigwrite+0x28>
  printf(1, "bigwrite ok\n");
    2295:	83 ec 08             	sub    $0x8,%esp
    2298:	68 27 44 00 00       	push   $0x4427
    229d:	6a 01                	push   $0x1
    229f:	e8 04 14 00 00       	call   36a8 <printf>
}
    22a4:	83 c4 10             	add    $0x10,%esp
    22a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
    22aa:	5b                   	pop    %ebx
    22ab:	5e                   	pop    %esi
    22ac:	5d                   	pop    %ebp
    22ad:	c3                   	ret
        printf(1, "write(%d) ret %d\n", sz, cc);
    22ae:	50                   	push   %eax
    22af:	53                   	push   %ebx
    22b0:	68 15 44 00 00       	push   $0x4415
    22b5:	6a 01                	push   $0x1
    22b7:	e8 ec 13 00 00       	call   36a8 <printf>
        exit();
    22bc:	e8 ba 12 00 00       	call   357b <exit>
      printf(1, "cannot create bigwrite\n");
    22c1:	83 ec 08             	sub    $0x8,%esp
    22c4:	68 fd 43 00 00       	push   $0x43fd
    22c9:	6a 01                	push   $0x1
    22cb:	e8 d8 13 00 00       	call   36a8 <printf>
      exit();
    22d0:	e8 a6 12 00 00       	call   357b <exit>
    22d5:	8d 76 00             	lea    0x0(%esi),%esi

000022d8 <bigfile>:
{
    22d8:	55                   	push   %ebp
    22d9:	89 e5                	mov    %esp,%ebp
    22db:	57                   	push   %edi
    22dc:	56                   	push   %esi
    22dd:	53                   	push   %ebx
    22de:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    22e1:	68 34 44 00 00       	push   $0x4434
    22e6:	6a 01                	push   $0x1
    22e8:	e8 bb 13 00 00       	call   36a8 <printf>
  unlink("bigfile");
    22ed:	c7 04 24 50 44 00 00 	movl   $0x4450,(%esp)
    22f4:	e8 d2 12 00 00       	call   35cb <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    22f9:	5e                   	pop    %esi
    22fa:	5f                   	pop    %edi
    22fb:	68 02 02 00 00       	push   $0x202
    2300:	68 50 44 00 00       	push   $0x4450
    2305:	e8 b1 12 00 00       	call   35bb <open>
  if(fd < 0){
    230a:	83 c4 10             	add    $0x10,%esp
    230d:	85 c0                	test   %eax,%eax
    230f:	0f 88 52 01 00 00    	js     2467 <bigfile+0x18f>
    2315:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    2317:	31 db                	xor    %ebx,%ebx
    2319:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    231c:	51                   	push   %ecx
    231d:	68 58 02 00 00       	push   $0x258
    2322:	53                   	push   %ebx
    2323:	68 e0 78 00 00       	push   $0x78e0
    2328:	e8 17 11 00 00       	call   3444 <memset>
    if(write(fd, buf, 600) != 600){
    232d:	83 c4 0c             	add    $0xc,%esp
    2330:	68 58 02 00 00       	push   $0x258
    2335:	68 e0 78 00 00       	push   $0x78e0
    233a:	56                   	push   %esi
    233b:	e8 5b 12 00 00       	call   359b <write>
    2340:	83 c4 10             	add    $0x10,%esp
    2343:	3d 58 02 00 00       	cmp    $0x258,%eax
    2348:	0f 85 f2 00 00 00    	jne    2440 <bigfile+0x168>
  for(i = 0; i < 20; i++){
    234e:	43                   	inc    %ebx
    234f:	83 fb 14             	cmp    $0x14,%ebx
    2352:	75 c8                	jne    231c <bigfile+0x44>
  close(fd);
    2354:	83 ec 0c             	sub    $0xc,%esp
    2357:	56                   	push   %esi
    2358:	e8 46 12 00 00       	call   35a3 <close>
  fd = open("bigfile", 0);
    235d:	58                   	pop    %eax
    235e:	5a                   	pop    %edx
    235f:	6a 00                	push   $0x0
    2361:	68 50 44 00 00       	push   $0x4450
    2366:	e8 50 12 00 00       	call   35bb <open>
    236b:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    236d:	83 c4 10             	add    $0x10,%esp
    2370:	85 c0                	test   %eax,%eax
    2372:	0f 88 dc 00 00 00    	js     2454 <bigfile+0x17c>
  total = 0;
    2378:	31 f6                	xor    %esi,%esi
  for(i = 0; ; i++){
    237a:	31 db                	xor    %ebx,%ebx
    237c:	eb 2e                	jmp    23ac <bigfile+0xd4>
    237e:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    2380:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2385:	0f 85 8d 00 00 00    	jne    2418 <bigfile+0x140>
    if(buf[0] != i/2 || buf[299] != i/2){
    238b:	89 da                	mov    %ebx,%edx
    238d:	d1 fa                	sar    $1,%edx
    238f:	0f be 05 e0 78 00 00 	movsbl 0x78e0,%eax
    2396:	39 d0                	cmp    %edx,%eax
    2398:	75 6a                	jne    2404 <bigfile+0x12c>
    239a:	0f be 15 0b 7a 00 00 	movsbl 0x7a0b,%edx
    23a1:	39 d0                	cmp    %edx,%eax
    23a3:	75 5f                	jne    2404 <bigfile+0x12c>
    total += cc;
    23a5:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  for(i = 0; ; i++){
    23ab:	43                   	inc    %ebx
    cc = read(fd, buf, 300);
    23ac:	50                   	push   %eax
    23ad:	68 2c 01 00 00       	push   $0x12c
    23b2:	68 e0 78 00 00       	push   $0x78e0
    23b7:	57                   	push   %edi
    23b8:	e8 d6 11 00 00       	call   3593 <read>
    if(cc < 0){
    23bd:	83 c4 10             	add    $0x10,%esp
    23c0:	85 c0                	test   %eax,%eax
    23c2:	78 68                	js     242c <bigfile+0x154>
    if(cc == 0)
    23c4:	75 ba                	jne    2380 <bigfile+0xa8>
  close(fd);
    23c6:	83 ec 0c             	sub    $0xc,%esp
    23c9:	57                   	push   %edi
    23ca:	e8 d4 11 00 00       	call   35a3 <close>
  if(total != 20*600){
    23cf:	83 c4 10             	add    $0x10,%esp
    23d2:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    23d8:	0f 85 9c 00 00 00    	jne    247a <bigfile+0x1a2>
  unlink("bigfile");
    23de:	83 ec 0c             	sub    $0xc,%esp
    23e1:	68 50 44 00 00       	push   $0x4450
    23e6:	e8 e0 11 00 00       	call   35cb <unlink>
  printf(1, "bigfile test ok\n");
    23eb:	58                   	pop    %eax
    23ec:	5a                   	pop    %edx
    23ed:	68 df 44 00 00       	push   $0x44df
    23f2:	6a 01                	push   $0x1
    23f4:	e8 af 12 00 00       	call   36a8 <printf>
}
    23f9:	83 c4 10             	add    $0x10,%esp
    23fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    23ff:	5b                   	pop    %ebx
    2400:	5e                   	pop    %esi
    2401:	5f                   	pop    %edi
    2402:	5d                   	pop    %ebp
    2403:	c3                   	ret
      printf(1, "read bigfile wrong data\n");
    2404:	83 ec 08             	sub    $0x8,%esp
    2407:	68 ac 44 00 00       	push   $0x44ac
    240c:	6a 01                	push   $0x1
    240e:	e8 95 12 00 00       	call   36a8 <printf>
      exit();
    2413:	e8 63 11 00 00       	call   357b <exit>
      printf(1, "short read bigfile\n");
    2418:	83 ec 08             	sub    $0x8,%esp
    241b:	68 98 44 00 00       	push   $0x4498
    2420:	6a 01                	push   $0x1
    2422:	e8 81 12 00 00       	call   36a8 <printf>
      exit();
    2427:	e8 4f 11 00 00       	call   357b <exit>
      printf(1, "read bigfile failed\n");
    242c:	83 ec 08             	sub    $0x8,%esp
    242f:	68 83 44 00 00       	push   $0x4483
    2434:	6a 01                	push   $0x1
    2436:	e8 6d 12 00 00       	call   36a8 <printf>
      exit();
    243b:	e8 3b 11 00 00       	call   357b <exit>
      printf(1, "write bigfile failed\n");
    2440:	83 ec 08             	sub    $0x8,%esp
    2443:	68 58 44 00 00       	push   $0x4458
    2448:	6a 01                	push   $0x1
    244a:	e8 59 12 00 00       	call   36a8 <printf>
      exit();
    244f:	e8 27 11 00 00       	call   357b <exit>
    printf(1, "cannot open bigfile\n");
    2454:	50                   	push   %eax
    2455:	50                   	push   %eax
    2456:	68 6e 44 00 00       	push   $0x446e
    245b:	6a 01                	push   $0x1
    245d:	e8 46 12 00 00       	call   36a8 <printf>
    exit();
    2462:	e8 14 11 00 00       	call   357b <exit>
    printf(1, "cannot create bigfile");
    2467:	53                   	push   %ebx
    2468:	53                   	push   %ebx
    2469:	68 42 44 00 00       	push   $0x4442
    246e:	6a 01                	push   $0x1
    2470:	e8 33 12 00 00       	call   36a8 <printf>
    exit();
    2475:	e8 01 11 00 00       	call   357b <exit>
    printf(1, "read bigfile wrong total\n");
    247a:	51                   	push   %ecx
    247b:	51                   	push   %ecx
    247c:	68 c5 44 00 00       	push   $0x44c5
    2481:	6a 01                	push   $0x1
    2483:	e8 20 12 00 00       	call   36a8 <printf>
    exit();
    2488:	e8 ee 10 00 00       	call   357b <exit>
    248d:	8d 76 00             	lea    0x0(%esi),%esi

00002490 <fourteen>:
{
    2490:	55                   	push   %ebp
    2491:	89 e5                	mov    %esp,%ebp
    2493:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    2496:	68 f0 44 00 00       	push   $0x44f0
    249b:	6a 01                	push   $0x1
    249d:	e8 06 12 00 00       	call   36a8 <printf>
  if(mkdir("12345678901234") != 0){
    24a2:	c7 04 24 2b 45 00 00 	movl   $0x452b,(%esp)
    24a9:	e8 35 11 00 00       	call   35e3 <mkdir>
    24ae:	83 c4 10             	add    $0x10,%esp
    24b1:	85 c0                	test   %eax,%eax
    24b3:	0f 85 97 00 00 00    	jne    2550 <fourteen+0xc0>
  if(mkdir("12345678901234/123456789012345") != 0){
    24b9:	83 ec 0c             	sub    $0xc,%esp
    24bc:	68 f0 4c 00 00       	push   $0x4cf0
    24c1:	e8 1d 11 00 00       	call   35e3 <mkdir>
    24c6:	83 c4 10             	add    $0x10,%esp
    24c9:	85 c0                	test   %eax,%eax
    24cb:	0f 85 de 00 00 00    	jne    25af <fourteen+0x11f>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    24d1:	83 ec 08             	sub    $0x8,%esp
    24d4:	68 00 02 00 00       	push   $0x200
    24d9:	68 40 4d 00 00       	push   $0x4d40
    24de:	e8 d8 10 00 00       	call   35bb <open>
  if(fd < 0){
    24e3:	83 c4 10             	add    $0x10,%esp
    24e6:	85 c0                	test   %eax,%eax
    24e8:	0f 88 ae 00 00 00    	js     259c <fourteen+0x10c>
  close(fd);
    24ee:	83 ec 0c             	sub    $0xc,%esp
    24f1:	50                   	push   %eax
    24f2:	e8 ac 10 00 00       	call   35a3 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    24f7:	58                   	pop    %eax
    24f8:	5a                   	pop    %edx
    24f9:	6a 00                	push   $0x0
    24fb:	68 b0 4d 00 00       	push   $0x4db0
    2500:	e8 b6 10 00 00       	call   35bb <open>
  if(fd < 0){
    2505:	83 c4 10             	add    $0x10,%esp
    2508:	85 c0                	test   %eax,%eax
    250a:	78 7d                	js     2589 <fourteen+0xf9>
  close(fd);
    250c:	83 ec 0c             	sub    $0xc,%esp
    250f:	50                   	push   %eax
    2510:	e8 8e 10 00 00       	call   35a3 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2515:	c7 04 24 1c 45 00 00 	movl   $0x451c,(%esp)
    251c:	e8 c2 10 00 00       	call   35e3 <mkdir>
    2521:	83 c4 10             	add    $0x10,%esp
    2524:	85 c0                	test   %eax,%eax
    2526:	74 4e                	je     2576 <fourteen+0xe6>
  if(mkdir("123456789012345/12345678901234") == 0){
    2528:	83 ec 0c             	sub    $0xc,%esp
    252b:	68 4c 4e 00 00       	push   $0x4e4c
    2530:	e8 ae 10 00 00       	call   35e3 <mkdir>
    2535:	83 c4 10             	add    $0x10,%esp
    2538:	85 c0                	test   %eax,%eax
    253a:	74 27                	je     2563 <fourteen+0xd3>
  printf(1, "fourteen ok\n");
    253c:	83 ec 08             	sub    $0x8,%esp
    253f:	68 3a 45 00 00       	push   $0x453a
    2544:	6a 01                	push   $0x1
    2546:	e8 5d 11 00 00       	call   36a8 <printf>
}
    254b:	83 c4 10             	add    $0x10,%esp
    254e:	c9                   	leave
    254f:	c3                   	ret
    printf(1, "mkdir 12345678901234 failed\n");
    2550:	50                   	push   %eax
    2551:	50                   	push   %eax
    2552:	68 ff 44 00 00       	push   $0x44ff
    2557:	6a 01                	push   $0x1
    2559:	e8 4a 11 00 00       	call   36a8 <printf>
    exit();
    255e:	e8 18 10 00 00       	call   357b <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2563:	50                   	push   %eax
    2564:	50                   	push   %eax
    2565:	68 6c 4e 00 00       	push   $0x4e6c
    256a:	6a 01                	push   $0x1
    256c:	e8 37 11 00 00       	call   36a8 <printf>
    exit();
    2571:	e8 05 10 00 00       	call   357b <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2576:	52                   	push   %edx
    2577:	52                   	push   %edx
    2578:	68 1c 4e 00 00       	push   $0x4e1c
    257d:	6a 01                	push   $0x1
    257f:	e8 24 11 00 00       	call   36a8 <printf>
    exit();
    2584:	e8 f2 0f 00 00       	call   357b <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2589:	51                   	push   %ecx
    258a:	51                   	push   %ecx
    258b:	68 e0 4d 00 00       	push   $0x4de0
    2590:	6a 01                	push   $0x1
    2592:	e8 11 11 00 00       	call   36a8 <printf>
    exit();
    2597:	e8 df 0f 00 00       	call   357b <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    259c:	51                   	push   %ecx
    259d:	51                   	push   %ecx
    259e:	68 70 4d 00 00       	push   $0x4d70
    25a3:	6a 01                	push   $0x1
    25a5:	e8 fe 10 00 00       	call   36a8 <printf>
    exit();
    25aa:	e8 cc 0f 00 00       	call   357b <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    25af:	50                   	push   %eax
    25b0:	50                   	push   %eax
    25b1:	68 10 4d 00 00       	push   $0x4d10
    25b6:	6a 01                	push   $0x1
    25b8:	e8 eb 10 00 00       	call   36a8 <printf>
    exit();
    25bd:	e8 b9 0f 00 00       	call   357b <exit>
    25c2:	66 90                	xchg   %ax,%ax

000025c4 <rmdot>:
{
    25c4:	55                   	push   %ebp
    25c5:	89 e5                	mov    %esp,%ebp
    25c7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    25ca:	68 47 45 00 00       	push   $0x4547
    25cf:	6a 01                	push   $0x1
    25d1:	e8 d2 10 00 00       	call   36a8 <printf>
  if(mkdir("dots") != 0){
    25d6:	c7 04 24 53 45 00 00 	movl   $0x4553,(%esp)
    25dd:	e8 01 10 00 00       	call   35e3 <mkdir>
    25e2:	83 c4 10             	add    $0x10,%esp
    25e5:	85 c0                	test   %eax,%eax
    25e7:	0f 85 b0 00 00 00    	jne    269d <rmdot+0xd9>
  if(chdir("dots") != 0){
    25ed:	83 ec 0c             	sub    $0xc,%esp
    25f0:	68 53 45 00 00       	push   $0x4553
    25f5:	e8 f1 0f 00 00       	call   35eb <chdir>
    25fa:	83 c4 10             	add    $0x10,%esp
    25fd:	85 c0                	test   %eax,%eax
    25ff:	0f 85 1d 01 00 00    	jne    2722 <rmdot+0x15e>
  if(unlink(".") == 0){
    2605:	83 ec 0c             	sub    $0xc,%esp
    2608:	68 fe 41 00 00       	push   $0x41fe
    260d:	e8 b9 0f 00 00       	call   35cb <unlink>
    2612:	83 c4 10             	add    $0x10,%esp
    2615:	85 c0                	test   %eax,%eax
    2617:	0f 84 f2 00 00 00    	je     270f <rmdot+0x14b>
  if(unlink("..") == 0){
    261d:	83 ec 0c             	sub    $0xc,%esp
    2620:	68 fd 41 00 00       	push   $0x41fd
    2625:	e8 a1 0f 00 00       	call   35cb <unlink>
    262a:	83 c4 10             	add    $0x10,%esp
    262d:	85 c0                	test   %eax,%eax
    262f:	0f 84 c7 00 00 00    	je     26fc <rmdot+0x138>
  if(chdir("/") != 0){
    2635:	83 ec 0c             	sub    $0xc,%esp
    2638:	68 d1 39 00 00       	push   $0x39d1
    263d:	e8 a9 0f 00 00       	call   35eb <chdir>
    2642:	83 c4 10             	add    $0x10,%esp
    2645:	85 c0                	test   %eax,%eax
    2647:	0f 85 9c 00 00 00    	jne    26e9 <rmdot+0x125>
  if(unlink("dots/.") == 0){
    264d:	83 ec 0c             	sub    $0xc,%esp
    2650:	68 9b 45 00 00       	push   $0x459b
    2655:	e8 71 0f 00 00       	call   35cb <unlink>
    265a:	83 c4 10             	add    $0x10,%esp
    265d:	85 c0                	test   %eax,%eax
    265f:	74 75                	je     26d6 <rmdot+0x112>
  if(unlink("dots/..") == 0){
    2661:	83 ec 0c             	sub    $0xc,%esp
    2664:	68 b9 45 00 00       	push   $0x45b9
    2669:	e8 5d 0f 00 00       	call   35cb <unlink>
    266e:	83 c4 10             	add    $0x10,%esp
    2671:	85 c0                	test   %eax,%eax
    2673:	74 4e                	je     26c3 <rmdot+0xff>
  if(unlink("dots") != 0){
    2675:	83 ec 0c             	sub    $0xc,%esp
    2678:	68 53 45 00 00       	push   $0x4553
    267d:	e8 49 0f 00 00       	call   35cb <unlink>
    2682:	83 c4 10             	add    $0x10,%esp
    2685:	85 c0                	test   %eax,%eax
    2687:	75 27                	jne    26b0 <rmdot+0xec>
  printf(1, "rmdot ok\n");
    2689:	83 ec 08             	sub    $0x8,%esp
    268c:	68 ee 45 00 00       	push   $0x45ee
    2691:	6a 01                	push   $0x1
    2693:	e8 10 10 00 00       	call   36a8 <printf>
}
    2698:	83 c4 10             	add    $0x10,%esp
    269b:	c9                   	leave
    269c:	c3                   	ret
    printf(1, "mkdir dots failed\n");
    269d:	50                   	push   %eax
    269e:	50                   	push   %eax
    269f:	68 58 45 00 00       	push   $0x4558
    26a4:	6a 01                	push   $0x1
    26a6:	e8 fd 0f 00 00       	call   36a8 <printf>
    exit();
    26ab:	e8 cb 0e 00 00       	call   357b <exit>
    printf(1, "unlink dots failed!\n");
    26b0:	50                   	push   %eax
    26b1:	50                   	push   %eax
    26b2:	68 d9 45 00 00       	push   $0x45d9
    26b7:	6a 01                	push   $0x1
    26b9:	e8 ea 0f 00 00       	call   36a8 <printf>
    exit();
    26be:	e8 b8 0e 00 00       	call   357b <exit>
    printf(1, "unlink dots/.. worked!\n");
    26c3:	52                   	push   %edx
    26c4:	52                   	push   %edx
    26c5:	68 c1 45 00 00       	push   $0x45c1
    26ca:	6a 01                	push   $0x1
    26cc:	e8 d7 0f 00 00       	call   36a8 <printf>
    exit();
    26d1:	e8 a5 0e 00 00       	call   357b <exit>
    printf(1, "unlink dots/. worked!\n");
    26d6:	51                   	push   %ecx
    26d7:	51                   	push   %ecx
    26d8:	68 a2 45 00 00       	push   $0x45a2
    26dd:	6a 01                	push   $0x1
    26df:	e8 c4 0f 00 00       	call   36a8 <printf>
    exit();
    26e4:	e8 92 0e 00 00       	call   357b <exit>
    printf(1, "chdir / failed\n");
    26e9:	50                   	push   %eax
    26ea:	50                   	push   %eax
    26eb:	68 d3 39 00 00       	push   $0x39d3
    26f0:	6a 01                	push   $0x1
    26f2:	e8 b1 0f 00 00       	call   36a8 <printf>
    exit();
    26f7:	e8 7f 0e 00 00       	call   357b <exit>
    printf(1, "rm .. worked!\n");
    26fc:	50                   	push   %eax
    26fd:	50                   	push   %eax
    26fe:	68 8c 45 00 00       	push   $0x458c
    2703:	6a 01                	push   $0x1
    2705:	e8 9e 0f 00 00       	call   36a8 <printf>
    exit();
    270a:	e8 6c 0e 00 00       	call   357b <exit>
    printf(1, "rm . worked!\n");
    270f:	50                   	push   %eax
    2710:	50                   	push   %eax
    2711:	68 7e 45 00 00       	push   $0x457e
    2716:	6a 01                	push   $0x1
    2718:	e8 8b 0f 00 00       	call   36a8 <printf>
    exit();
    271d:	e8 59 0e 00 00       	call   357b <exit>
    printf(1, "chdir dots failed\n");
    2722:	50                   	push   %eax
    2723:	50                   	push   %eax
    2724:	68 6b 45 00 00       	push   $0x456b
    2729:	6a 01                	push   $0x1
    272b:	e8 78 0f 00 00       	call   36a8 <printf>
    exit();
    2730:	e8 46 0e 00 00       	call   357b <exit>
    2735:	8d 76 00             	lea    0x0(%esi),%esi

00002738 <dirfile>:
{
    2738:	55                   	push   %ebp
    2739:	89 e5                	mov    %esp,%ebp
    273b:	53                   	push   %ebx
    273c:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    273f:	68 f8 45 00 00       	push   $0x45f8
    2744:	6a 01                	push   $0x1
    2746:	e8 5d 0f 00 00       	call   36a8 <printf>
  fd = open("dirfile", O_CREATE);
    274b:	5b                   	pop    %ebx
    274c:	58                   	pop    %eax
    274d:	68 00 02 00 00       	push   $0x200
    2752:	68 05 46 00 00       	push   $0x4605
    2757:	e8 5f 0e 00 00       	call   35bb <open>
  if(fd < 0){
    275c:	83 c4 10             	add    $0x10,%esp
    275f:	85 c0                	test   %eax,%eax
    2761:	0f 88 43 01 00 00    	js     28aa <dirfile+0x172>
  close(fd);
    2767:	83 ec 0c             	sub    $0xc,%esp
    276a:	50                   	push   %eax
    276b:	e8 33 0e 00 00       	call   35a3 <close>
  if(chdir("dirfile") == 0){
    2770:	c7 04 24 05 46 00 00 	movl   $0x4605,(%esp)
    2777:	e8 6f 0e 00 00       	call   35eb <chdir>
    277c:	83 c4 10             	add    $0x10,%esp
    277f:	85 c0                	test   %eax,%eax
    2781:	0f 84 10 01 00 00    	je     2897 <dirfile+0x15f>
  fd = open("dirfile/xx", 0);
    2787:	83 ec 08             	sub    $0x8,%esp
    278a:	6a 00                	push   $0x0
    278c:	68 3e 46 00 00       	push   $0x463e
    2791:	e8 25 0e 00 00       	call   35bb <open>
  if(fd >= 0){
    2796:	83 c4 10             	add    $0x10,%esp
    2799:	85 c0                	test   %eax,%eax
    279b:	0f 89 e3 00 00 00    	jns    2884 <dirfile+0x14c>
  fd = open("dirfile/xx", O_CREATE);
    27a1:	83 ec 08             	sub    $0x8,%esp
    27a4:	68 00 02 00 00       	push   $0x200
    27a9:	68 3e 46 00 00       	push   $0x463e
    27ae:	e8 08 0e 00 00       	call   35bb <open>
  if(fd >= 0){
    27b3:	83 c4 10             	add    $0x10,%esp
    27b6:	85 c0                	test   %eax,%eax
    27b8:	0f 89 c6 00 00 00    	jns    2884 <dirfile+0x14c>
  if(mkdir("dirfile/xx") == 0){
    27be:	83 ec 0c             	sub    $0xc,%esp
    27c1:	68 3e 46 00 00       	push   $0x463e
    27c6:	e8 18 0e 00 00       	call   35e3 <mkdir>
    27cb:	83 c4 10             	add    $0x10,%esp
    27ce:	85 c0                	test   %eax,%eax
    27d0:	0f 84 46 01 00 00    	je     291c <dirfile+0x1e4>
  if(unlink("dirfile/xx") == 0){
    27d6:	83 ec 0c             	sub    $0xc,%esp
    27d9:	68 3e 46 00 00       	push   $0x463e
    27de:	e8 e8 0d 00 00       	call   35cb <unlink>
    27e3:	83 c4 10             	add    $0x10,%esp
    27e6:	85 c0                	test   %eax,%eax
    27e8:	0f 84 1b 01 00 00    	je     2909 <dirfile+0x1d1>
  if(link("README", "dirfile/xx") == 0){
    27ee:	83 ec 08             	sub    $0x8,%esp
    27f1:	68 3e 46 00 00       	push   $0x463e
    27f6:	68 a2 46 00 00       	push   $0x46a2
    27fb:	e8 db 0d 00 00       	call   35db <link>
    2800:	83 c4 10             	add    $0x10,%esp
    2803:	85 c0                	test   %eax,%eax
    2805:	0f 84 eb 00 00 00    	je     28f6 <dirfile+0x1be>
  if(unlink("dirfile") != 0){
    280b:	83 ec 0c             	sub    $0xc,%esp
    280e:	68 05 46 00 00       	push   $0x4605
    2813:	e8 b3 0d 00 00       	call   35cb <unlink>
    2818:	83 c4 10             	add    $0x10,%esp
    281b:	85 c0                	test   %eax,%eax
    281d:	0f 85 c0 00 00 00    	jne    28e3 <dirfile+0x1ab>
  fd = open(".", O_RDWR);
    2823:	83 ec 08             	sub    $0x8,%esp
    2826:	6a 02                	push   $0x2
    2828:	68 fe 41 00 00       	push   $0x41fe
    282d:	e8 89 0d 00 00       	call   35bb <open>
  if(fd >= 0){
    2832:	83 c4 10             	add    $0x10,%esp
    2835:	85 c0                	test   %eax,%eax
    2837:	0f 89 93 00 00 00    	jns    28d0 <dirfile+0x198>
  fd = open(".", 0);
    283d:	83 ec 08             	sub    $0x8,%esp
    2840:	6a 00                	push   $0x0
    2842:	68 fe 41 00 00       	push   $0x41fe
    2847:	e8 6f 0d 00 00       	call   35bb <open>
    284c:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    284e:	83 c4 0c             	add    $0xc,%esp
    2851:	6a 01                	push   $0x1
    2853:	68 e1 42 00 00       	push   $0x42e1
    2858:	50                   	push   %eax
    2859:	e8 3d 0d 00 00       	call   359b <write>
    285e:	83 c4 10             	add    $0x10,%esp
    2861:	85 c0                	test   %eax,%eax
    2863:	7f 58                	jg     28bd <dirfile+0x185>
  close(fd);
    2865:	83 ec 0c             	sub    $0xc,%esp
    2868:	53                   	push   %ebx
    2869:	e8 35 0d 00 00       	call   35a3 <close>
  printf(1, "dir vs file OK\n");
    286e:	58                   	pop    %eax
    286f:	5a                   	pop    %edx
    2870:	68 d5 46 00 00       	push   $0x46d5
    2875:	6a 01                	push   $0x1
    2877:	e8 2c 0e 00 00       	call   36a8 <printf>
}
    287c:	83 c4 10             	add    $0x10,%esp
    287f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2882:	c9                   	leave
    2883:	c3                   	ret
    printf(1, "create dirfile/xx succeeded!\n");
    2884:	50                   	push   %eax
    2885:	50                   	push   %eax
    2886:	68 49 46 00 00       	push   $0x4649
    288b:	6a 01                	push   $0x1
    288d:	e8 16 0e 00 00       	call   36a8 <printf>
    exit();
    2892:	e8 e4 0c 00 00       	call   357b <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2897:	52                   	push   %edx
    2898:	52                   	push   %edx
    2899:	68 24 46 00 00       	push   $0x4624
    289e:	6a 01                	push   $0x1
    28a0:	e8 03 0e 00 00       	call   36a8 <printf>
    exit();
    28a5:	e8 d1 0c 00 00       	call   357b <exit>
    printf(1, "create dirfile failed\n");
    28aa:	51                   	push   %ecx
    28ab:	51                   	push   %ecx
    28ac:	68 0d 46 00 00       	push   $0x460d
    28b1:	6a 01                	push   $0x1
    28b3:	e8 f0 0d 00 00       	call   36a8 <printf>
    exit();
    28b8:	e8 be 0c 00 00       	call   357b <exit>
    printf(1, "write . succeeded!\n");
    28bd:	51                   	push   %ecx
    28be:	51                   	push   %ecx
    28bf:	68 c1 46 00 00       	push   $0x46c1
    28c4:	6a 01                	push   $0x1
    28c6:	e8 dd 0d 00 00       	call   36a8 <printf>
    exit();
    28cb:	e8 ab 0c 00 00       	call   357b <exit>
    printf(1, "open . for writing succeeded!\n");
    28d0:	53                   	push   %ebx
    28d1:	53                   	push   %ebx
    28d2:	68 c0 4e 00 00       	push   $0x4ec0
    28d7:	6a 01                	push   $0x1
    28d9:	e8 ca 0d 00 00       	call   36a8 <printf>
    exit();
    28de:	e8 98 0c 00 00       	call   357b <exit>
    printf(1, "unlink dirfile failed!\n");
    28e3:	50                   	push   %eax
    28e4:	50                   	push   %eax
    28e5:	68 a9 46 00 00       	push   $0x46a9
    28ea:	6a 01                	push   $0x1
    28ec:	e8 b7 0d 00 00       	call   36a8 <printf>
    exit();
    28f1:	e8 85 0c 00 00       	call   357b <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    28f6:	50                   	push   %eax
    28f7:	50                   	push   %eax
    28f8:	68 a0 4e 00 00       	push   $0x4ea0
    28fd:	6a 01                	push   $0x1
    28ff:	e8 a4 0d 00 00       	call   36a8 <printf>
    exit();
    2904:	e8 72 0c 00 00       	call   357b <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2909:	50                   	push   %eax
    290a:	50                   	push   %eax
    290b:	68 84 46 00 00       	push   $0x4684
    2910:	6a 01                	push   $0x1
    2912:	e8 91 0d 00 00       	call   36a8 <printf>
    exit();
    2917:	e8 5f 0c 00 00       	call   357b <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    291c:	50                   	push   %eax
    291d:	50                   	push   %eax
    291e:	68 67 46 00 00       	push   $0x4667
    2923:	6a 01                	push   $0x1
    2925:	e8 7e 0d 00 00       	call   36a8 <printf>
    exit();
    292a:	e8 4c 0c 00 00       	call   357b <exit>
    292f:	90                   	nop

00002930 <iref>:
{
    2930:	55                   	push   %ebp
    2931:	89 e5                	mov    %esp,%ebp
    2933:	53                   	push   %ebx
    2934:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2937:	68 e5 46 00 00       	push   $0x46e5
    293c:	6a 01                	push   $0x1
    293e:	e8 65 0d 00 00       	call   36a8 <printf>
    2943:	83 c4 10             	add    $0x10,%esp
    2946:	bb 33 00 00 00       	mov    $0x33,%ebx
    294b:	90                   	nop
    if(mkdir("irefd") != 0){
    294c:	83 ec 0c             	sub    $0xc,%esp
    294f:	68 f6 46 00 00       	push   $0x46f6
    2954:	e8 8a 0c 00 00       	call   35e3 <mkdir>
    2959:	83 c4 10             	add    $0x10,%esp
    295c:	85 c0                	test   %eax,%eax
    295e:	0f 85 b9 00 00 00    	jne    2a1d <iref+0xed>
    if(chdir("irefd") != 0){
    2964:	83 ec 0c             	sub    $0xc,%esp
    2967:	68 f6 46 00 00       	push   $0x46f6
    296c:	e8 7a 0c 00 00       	call   35eb <chdir>
    2971:	83 c4 10             	add    $0x10,%esp
    2974:	85 c0                	test   %eax,%eax
    2976:	0f 85 b5 00 00 00    	jne    2a31 <iref+0x101>
    mkdir("");
    297c:	83 ec 0c             	sub    $0xc,%esp
    297f:	68 ab 3d 00 00       	push   $0x3dab
    2984:	e8 5a 0c 00 00       	call   35e3 <mkdir>
    link("README", "");
    2989:	59                   	pop    %ecx
    298a:	58                   	pop    %eax
    298b:	68 ab 3d 00 00       	push   $0x3dab
    2990:	68 a2 46 00 00       	push   $0x46a2
    2995:	e8 41 0c 00 00       	call   35db <link>
    fd = open("", O_CREATE);
    299a:	58                   	pop    %eax
    299b:	5a                   	pop    %edx
    299c:	68 00 02 00 00       	push   $0x200
    29a1:	68 ab 3d 00 00       	push   $0x3dab
    29a6:	e8 10 0c 00 00       	call   35bb <open>
    if(fd >= 0)
    29ab:	83 c4 10             	add    $0x10,%esp
    29ae:	85 c0                	test   %eax,%eax
    29b0:	78 0c                	js     29be <iref+0x8e>
      close(fd);
    29b2:	83 ec 0c             	sub    $0xc,%esp
    29b5:	50                   	push   %eax
    29b6:	e8 e8 0b 00 00       	call   35a3 <close>
    29bb:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    29be:	83 ec 08             	sub    $0x8,%esp
    29c1:	68 00 02 00 00       	push   $0x200
    29c6:	68 e0 42 00 00       	push   $0x42e0
    29cb:	e8 eb 0b 00 00       	call   35bb <open>
    if(fd >= 0)
    29d0:	83 c4 10             	add    $0x10,%esp
    29d3:	85 c0                	test   %eax,%eax
    29d5:	78 0c                	js     29e3 <iref+0xb3>
      close(fd);
    29d7:	83 ec 0c             	sub    $0xc,%esp
    29da:	50                   	push   %eax
    29db:	e8 c3 0b 00 00       	call   35a3 <close>
    29e0:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    29e3:	83 ec 0c             	sub    $0xc,%esp
    29e6:	68 e0 42 00 00       	push   $0x42e0
    29eb:	e8 db 0b 00 00       	call   35cb <unlink>
  for(i = 0; i < 50 + 1; i++){
    29f0:	83 c4 10             	add    $0x10,%esp
    29f3:	4b                   	dec    %ebx
    29f4:	0f 85 52 ff ff ff    	jne    294c <iref+0x1c>
  chdir("/");
    29fa:	83 ec 0c             	sub    $0xc,%esp
    29fd:	68 d1 39 00 00       	push   $0x39d1
    2a02:	e8 e4 0b 00 00       	call   35eb <chdir>
  printf(1, "empty file name OK\n");
    2a07:	58                   	pop    %eax
    2a08:	5a                   	pop    %edx
    2a09:	68 24 47 00 00       	push   $0x4724
    2a0e:	6a 01                	push   $0x1
    2a10:	e8 93 0c 00 00       	call   36a8 <printf>
}
    2a15:	83 c4 10             	add    $0x10,%esp
    2a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2a1b:	c9                   	leave
    2a1c:	c3                   	ret
      printf(1, "mkdir irefd failed\n");
    2a1d:	83 ec 08             	sub    $0x8,%esp
    2a20:	68 fc 46 00 00       	push   $0x46fc
    2a25:	6a 01                	push   $0x1
    2a27:	e8 7c 0c 00 00       	call   36a8 <printf>
      exit();
    2a2c:	e8 4a 0b 00 00       	call   357b <exit>
      printf(1, "chdir irefd failed\n");
    2a31:	83 ec 08             	sub    $0x8,%esp
    2a34:	68 10 47 00 00       	push   $0x4710
    2a39:	6a 01                	push   $0x1
    2a3b:	e8 68 0c 00 00       	call   36a8 <printf>
      exit();
    2a40:	e8 36 0b 00 00       	call   357b <exit>
    2a45:	8d 76 00             	lea    0x0(%esi),%esi

00002a48 <forktest>:
{
    2a48:	55                   	push   %ebp
    2a49:	89 e5                	mov    %esp,%ebp
    2a4b:	53                   	push   %ebx
    2a4c:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2a4f:	68 38 47 00 00       	push   $0x4738
    2a54:	6a 01                	push   $0x1
    2a56:	e8 4d 0c 00 00       	call   36a8 <printf>
    2a5b:	83 c4 10             	add    $0x10,%esp
  for(n=0; n<1000; n++){
    2a5e:	31 db                	xor    %ebx,%ebx
    2a60:	eb 0d                	jmp    2a6f <forktest+0x27>
    2a62:	66 90                	xchg   %ax,%ax
    if(pid == 0)
    2a64:	74 3e                	je     2aa4 <forktest+0x5c>
  for(n=0; n<1000; n++){
    2a66:	43                   	inc    %ebx
    2a67:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2a6d:	74 61                	je     2ad0 <forktest+0x88>
    pid = fork();
    2a6f:	e8 ff 0a 00 00       	call   3573 <fork>
    if(pid < 0)
    2a74:	85 c0                	test   %eax,%eax
    2a76:	79 ec                	jns    2a64 <forktest+0x1c>
  for(; n > 0; n--){
    2a78:	85 db                	test   %ebx,%ebx
    2a7a:	74 0c                	je     2a88 <forktest+0x40>
    if(wait() < 0){
    2a7c:	e8 02 0b 00 00       	call   3583 <wait>
    2a81:	85 c0                	test   %eax,%eax
    2a83:	78 24                	js     2aa9 <forktest+0x61>
  for(; n > 0; n--){
    2a85:	4b                   	dec    %ebx
    2a86:	75 f4                	jne    2a7c <forktest+0x34>
  if(wait() != -1){
    2a88:	e8 f6 0a 00 00       	call   3583 <wait>
    2a8d:	40                   	inc    %eax
    2a8e:	75 2d                	jne    2abd <forktest+0x75>
  printf(1, "fork test OK\n");
    2a90:	83 ec 08             	sub    $0x8,%esp
    2a93:	68 6a 47 00 00       	push   $0x476a
    2a98:	6a 01                	push   $0x1
    2a9a:	e8 09 0c 00 00       	call   36a8 <printf>
}
    2a9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2aa2:	c9                   	leave
    2aa3:	c3                   	ret
      exit();
    2aa4:	e8 d2 0a 00 00       	call   357b <exit>
      printf(1, "wait stopped early\n");
    2aa9:	83 ec 08             	sub    $0x8,%esp
    2aac:	68 43 47 00 00       	push   $0x4743
    2ab1:	6a 01                	push   $0x1
    2ab3:	e8 f0 0b 00 00       	call   36a8 <printf>
      exit();
    2ab8:	e8 be 0a 00 00       	call   357b <exit>
    printf(1, "wait got too many\n");
    2abd:	52                   	push   %edx
    2abe:	52                   	push   %edx
    2abf:	68 57 47 00 00       	push   $0x4757
    2ac4:	6a 01                	push   $0x1
    2ac6:	e8 dd 0b 00 00       	call   36a8 <printf>
    exit();
    2acb:	e8 ab 0a 00 00       	call   357b <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    2ad0:	50                   	push   %eax
    2ad1:	50                   	push   %eax
    2ad2:	68 e0 4e 00 00       	push   $0x4ee0
    2ad7:	6a 01                	push   $0x1
    2ad9:	e8 ca 0b 00 00       	call   36a8 <printf>
    exit();
    2ade:	e8 98 0a 00 00       	call   357b <exit>
    2ae3:	90                   	nop

00002ae4 <sbrktest>:
{
    2ae4:	55                   	push   %ebp
    2ae5:	89 e5                	mov    %esp,%ebp
    2ae7:	57                   	push   %edi
    2ae8:	56                   	push   %esi
    2ae9:	53                   	push   %ebx
    2aea:	83 ec 64             	sub    $0x64,%esp
  printf(stdout, "sbrk test\n");
    2aed:	68 78 47 00 00       	push   $0x4778
    2af2:	ff 35 a8 51 00 00    	push   0x51a8
    2af8:	e8 ab 0b 00 00       	call   36a8 <printf>
  oldbrk = sbrk(0);
    2afd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b04:	e8 fa 0a 00 00       	call   3603 <sbrk>
    2b09:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  a = sbrk(0);
    2b0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b13:	e8 eb 0a 00 00       	call   3603 <sbrk>
    2b18:	89 c3                	mov    %eax,%ebx
    2b1a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 5000; i++){
    2b1d:	31 f6                	xor    %esi,%esi
    2b1f:	eb 05                	jmp    2b26 <sbrktest+0x42>
    2b21:	8d 76 00             	lea    0x0(%esi),%esi
    2b24:	89 c3                	mov    %eax,%ebx
    b = sbrk(1);
    2b26:	83 ec 0c             	sub    $0xc,%esp
    2b29:	6a 01                	push   $0x1
    2b2b:	e8 d3 0a 00 00       	call   3603 <sbrk>
    if(b != a){
    2b30:	83 c4 10             	add    $0x10,%esp
    2b33:	39 d8                	cmp    %ebx,%eax
    2b35:	0f 85 88 02 00 00    	jne    2dc3 <sbrktest+0x2df>
    *b = 1;
    2b3b:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    2b3e:	8d 43 01             	lea    0x1(%ebx),%eax
  for(i = 0; i < 5000; i++){
    2b41:	46                   	inc    %esi
    2b42:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
    2b48:	75 da                	jne    2b24 <sbrktest+0x40>
  pid = fork();
    2b4a:	e8 24 0a 00 00       	call   3573 <fork>
    2b4f:	89 c6                	mov    %eax,%esi
  if(pid < 0){
    2b51:	85 c0                	test   %eax,%eax
    2b53:	0f 88 f0 02 00 00    	js     2e49 <sbrktest+0x365>
  c = sbrk(1);
    2b59:	83 ec 0c             	sub    $0xc,%esp
    2b5c:	6a 01                	push   $0x1
    2b5e:	e8 a0 0a 00 00       	call   3603 <sbrk>
  c = sbrk(1);
    2b63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b6a:	e8 94 0a 00 00       	call   3603 <sbrk>
  if(c != a + 1){
    2b6f:	83 c3 02             	add    $0x2,%ebx
    2b72:	83 c4 10             	add    $0x10,%esp
    2b75:	39 c3                	cmp    %eax,%ebx
    2b77:	0f 85 29 03 00 00    	jne    2ea6 <sbrktest+0x3c2>
  if(pid == 0)
    2b7d:	85 f6                	test   %esi,%esi
    2b7f:	0f 84 1c 03 00 00    	je     2ea1 <sbrktest+0x3bd>
  wait();
    2b85:	e8 f9 09 00 00       	call   3583 <wait>
  a = sbrk(0);
    2b8a:	83 ec 0c             	sub    $0xc,%esp
    2b8d:	6a 00                	push   $0x0
    2b8f:	e8 6f 0a 00 00       	call   3603 <sbrk>
    2b94:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    2b96:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2b9b:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    2b9d:	89 04 24             	mov    %eax,(%esp)
    2ba0:	e8 5e 0a 00 00       	call   3603 <sbrk>
  if (p != a) {
    2ba5:	83 c4 10             	add    $0x10,%esp
    2ba8:	39 c3                	cmp    %eax,%ebx
    2baa:	0f 85 82 02 00 00    	jne    2e32 <sbrktest+0x34e>
  *lastaddr = 99;
    2bb0:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2bb7:	83 ec 0c             	sub    $0xc,%esp
    2bba:	6a 00                	push   $0x0
    2bbc:	e8 42 0a 00 00       	call   3603 <sbrk>
    2bc1:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2bc3:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2bca:	e8 34 0a 00 00       	call   3603 <sbrk>
  if(c == (char*)0xffffffff){
    2bcf:	83 c4 10             	add    $0x10,%esp
    2bd2:	40                   	inc    %eax
    2bd3:	0f 84 12 03 00 00    	je     2eeb <sbrktest+0x407>
  c = sbrk(0);
    2bd9:	83 ec 0c             	sub    $0xc,%esp
    2bdc:	6a 00                	push   $0x0
    2bde:	e8 20 0a 00 00       	call   3603 <sbrk>
  if(c != a - 4096){
    2be3:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2be9:	83 c4 10             	add    $0x10,%esp
    2bec:	39 d0                	cmp    %edx,%eax
    2bee:	0f 85 e0 02 00 00    	jne    2ed4 <sbrktest+0x3f0>
  a = sbrk(0);
    2bf4:	83 ec 0c             	sub    $0xc,%esp
    2bf7:	6a 00                	push   $0x0
    2bf9:	e8 05 0a 00 00       	call   3603 <sbrk>
    2bfe:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    2c00:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2c07:	e8 f7 09 00 00       	call   3603 <sbrk>
    2c0c:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    2c0e:	83 c4 10             	add    $0x10,%esp
    2c11:	39 c3                	cmp    %eax,%ebx
    2c13:	0f 85 a4 02 00 00    	jne    2ebd <sbrktest+0x3d9>
    2c19:	83 ec 0c             	sub    $0xc,%esp
    2c1c:	6a 00                	push   $0x0
    2c1e:	e8 e0 09 00 00       	call   3603 <sbrk>
    2c23:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2c29:	83 c4 10             	add    $0x10,%esp
    2c2c:	39 c2                	cmp    %eax,%edx
    2c2e:	0f 85 89 02 00 00    	jne    2ebd <sbrktest+0x3d9>
  if(*lastaddr == 99){
    2c34:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2c3b:	0f 84 1f 02 00 00    	je     2e60 <sbrktest+0x37c>
  a = sbrk(0);
    2c41:	83 ec 0c             	sub    $0xc,%esp
    2c44:	6a 00                	push   $0x0
    2c46:	e8 b8 09 00 00       	call   3603 <sbrk>
    2c4b:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    2c4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2c54:	e8 aa 09 00 00       	call   3603 <sbrk>
    2c59:	89 c2                	mov    %eax,%edx
    2c5b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    2c5e:	29 d0                	sub    %edx,%eax
    2c60:	89 04 24             	mov    %eax,(%esp)
    2c63:	e8 9b 09 00 00       	call   3603 <sbrk>
  if(c != a){
    2c68:	83 c4 10             	add    $0x10,%esp
    2c6b:	39 c3                	cmp    %eax,%ebx
    2c6d:	0f 85 a8 01 00 00    	jne    2e1b <sbrktest+0x337>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2c73:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    ppid = getpid();
    2c78:	e8 7e 09 00 00       	call   35fb <getpid>
    2c7d:	89 c6                	mov    %eax,%esi
    pid = fork();
    2c7f:	e8 ef 08 00 00       	call   3573 <fork>
    if(pid < 0){
    2c84:	85 c0                	test   %eax,%eax
    2c86:	0f 88 55 01 00 00    	js     2de1 <sbrktest+0x2fd>
    if(pid == 0){
    2c8c:	0f 84 67 01 00 00    	je     2df9 <sbrktest+0x315>
    wait();
    2c92:	e8 ec 08 00 00       	call   3583 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2c97:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    2c9d:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
    2ca3:	75 d3                	jne    2c78 <sbrktest+0x194>
  if(pipe(fds) != 0){
    2ca5:	83 ec 0c             	sub    $0xc,%esp
    2ca8:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2cab:	50                   	push   %eax
    2cac:	e8 da 08 00 00       	call   358b <pipe>
    2cb1:	83 c4 10             	add    $0x10,%esp
    2cb4:	85 c0                	test   %eax,%eax
    2cb6:	0f 85 d2 01 00 00    	jne    2e8e <sbrktest+0x3aa>
    2cbc:	8d 5d c0             	lea    -0x40(%ebp),%ebx
    2cbf:	89 de                	mov    %ebx,%esi
      read(fds[0], &scratch, 1);
    2cc1:	8d 7d b7             	lea    -0x49(%ebp),%edi
    if((pids[i] = fork()) == 0){
    2cc4:	e8 aa 08 00 00       	call   3573 <fork>
    2cc9:	89 06                	mov    %eax,(%esi)
    2ccb:	85 c0                	test   %eax,%eax
    2ccd:	0f 84 8a 00 00 00    	je     2d5d <sbrktest+0x279>
    if(pids[i] != -1)
    2cd3:	40                   	inc    %eax
    2cd4:	74 0f                	je     2ce5 <sbrktest+0x201>
      read(fds[0], &scratch, 1);
    2cd6:	52                   	push   %edx
    2cd7:	6a 01                	push   $0x1
    2cd9:	57                   	push   %edi
    2cda:	ff 75 b8             	push   -0x48(%ebp)
    2cdd:	e8 b1 08 00 00       	call   3593 <read>
    2ce2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2ce5:	83 c6 04             	add    $0x4,%esi
    2ce8:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2ceb:	39 c6                	cmp    %eax,%esi
    2ced:	75 d5                	jne    2cc4 <sbrktest+0x1e0>
  c = sbrk(4096);
    2cef:	83 ec 0c             	sub    $0xc,%esp
    2cf2:	68 00 10 00 00       	push   $0x1000
    2cf7:	e8 07 09 00 00       	call   3603 <sbrk>
    2cfc:	89 c6                	mov    %eax,%esi
    2cfe:	83 c4 10             	add    $0x10,%esp
    2d01:	8d 76 00             	lea    0x0(%esi),%esi
    if(pids[i] == -1)
    2d04:	8b 03                	mov    (%ebx),%eax
    2d06:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d09:	74 11                	je     2d1c <sbrktest+0x238>
    kill(pids[i]);
    2d0b:	83 ec 0c             	sub    $0xc,%esp
    2d0e:	50                   	push   %eax
    2d0f:	e8 97 08 00 00       	call   35ab <kill>
    wait();
    2d14:	e8 6a 08 00 00       	call   3583 <wait>
    2d19:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2d1c:	83 c3 04             	add    $0x4,%ebx
    2d1f:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2d22:	39 c3                	cmp    %eax,%ebx
    2d24:	75 de                	jne    2d04 <sbrktest+0x220>
  if(c == (char*)0xffffffff){
    2d26:	46                   	inc    %esi
    2d27:	0f 84 4a 01 00 00    	je     2e77 <sbrktest+0x393>
  if(sbrk(0) > oldbrk)
    2d2d:	83 ec 0c             	sub    $0xc,%esp
    2d30:	6a 00                	push   $0x0
    2d32:	e8 cc 08 00 00       	call   3603 <sbrk>
    2d37:	83 c4 10             	add    $0x10,%esp
    2d3a:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    2d3d:	72 63                	jb     2da2 <sbrktest+0x2be>
  printf(stdout, "sbrk test OK\n");
    2d3f:	83 ec 08             	sub    $0x8,%esp
    2d42:	68 20 48 00 00       	push   $0x4820
    2d47:	ff 35 a8 51 00 00    	push   0x51a8
    2d4d:	e8 56 09 00 00       	call   36a8 <printf>
}
    2d52:	83 c4 10             	add    $0x10,%esp
    2d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2d58:	5b                   	pop    %ebx
    2d59:	5e                   	pop    %esi
    2d5a:	5f                   	pop    %edi
    2d5b:	5d                   	pop    %ebp
    2d5c:	c3                   	ret
      sbrk(BIG - (uint)sbrk(0));
    2d5d:	83 ec 0c             	sub    $0xc,%esp
    2d60:	6a 00                	push   $0x0
    2d62:	e8 9c 08 00 00       	call   3603 <sbrk>
    2d67:	89 c2                	mov    %eax,%edx
    2d69:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2d6e:	29 d0                	sub    %edx,%eax
    2d70:	89 04 24             	mov    %eax,(%esp)
    2d73:	e8 8b 08 00 00       	call   3603 <sbrk>
      write(fds[1], "x", 1);
    2d78:	83 c4 0c             	add    $0xc,%esp
    2d7b:	6a 01                	push   $0x1
    2d7d:	68 e1 42 00 00       	push   $0x42e1
    2d82:	ff 75 bc             	push   -0x44(%ebp)
    2d85:	e8 11 08 00 00       	call   359b <write>
    2d8a:	83 c4 10             	add    $0x10,%esp
    2d8d:	8d 76 00             	lea    0x0(%esi),%esi
      for(;;) sleep(1000);
    2d90:	83 ec 0c             	sub    $0xc,%esp
    2d93:	68 e8 03 00 00       	push   $0x3e8
    2d98:	e8 6e 08 00 00       	call   360b <sleep>
    2d9d:	83 c4 10             	add    $0x10,%esp
    2da0:	eb ee                	jmp    2d90 <sbrktest+0x2ac>
    sbrk(-(sbrk(0) - oldbrk));
    2da2:	83 ec 0c             	sub    $0xc,%esp
    2da5:	6a 00                	push   $0x0
    2da7:	e8 57 08 00 00       	call   3603 <sbrk>
    2dac:	89 c2                	mov    %eax,%edx
    2dae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    2db1:	29 d0                	sub    %edx,%eax
    2db3:	89 04 24             	mov    %eax,(%esp)
    2db6:	e8 48 08 00 00       	call   3603 <sbrk>
    2dbb:	83 c4 10             	add    $0x10,%esp
    2dbe:	e9 7c ff ff ff       	jmp    2d3f <sbrktest+0x25b>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2dc3:	83 ec 0c             	sub    $0xc,%esp
    2dc6:	50                   	push   %eax
    2dc7:	53                   	push   %ebx
    2dc8:	56                   	push   %esi
    2dc9:	68 83 47 00 00       	push   $0x4783
    2dce:	ff 35 a8 51 00 00    	push   0x51a8
    2dd4:	e8 cf 08 00 00       	call   36a8 <printf>
      exit();
    2dd9:	83 c4 20             	add    $0x20,%esp
    2ddc:	e8 9a 07 00 00       	call   357b <exit>
      printf(stdout, "fork failed\n");
    2de1:	83 ec 08             	sub    $0x8,%esp
    2de4:	68 c9 48 00 00       	push   $0x48c9
    2de9:	ff 35 a8 51 00 00    	push   0x51a8
    2def:	e8 b4 08 00 00       	call   36a8 <printf>
      exit();
    2df4:	e8 82 07 00 00       	call   357b <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2df9:	0f be 03             	movsbl (%ebx),%eax
    2dfc:	50                   	push   %eax
    2dfd:	53                   	push   %ebx
    2dfe:	68 ec 47 00 00       	push   $0x47ec
    2e03:	ff 35 a8 51 00 00    	push   0x51a8
    2e09:	e8 9a 08 00 00       	call   36a8 <printf>
      kill(ppid);
    2e0e:	89 34 24             	mov    %esi,(%esp)
    2e11:	e8 95 07 00 00       	call   35ab <kill>
      exit();
    2e16:	e8 60 07 00 00       	call   357b <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2e1b:	50                   	push   %eax
    2e1c:	53                   	push   %ebx
    2e1d:	68 d4 4f 00 00       	push   $0x4fd4
    2e22:	ff 35 a8 51 00 00    	push   0x51a8
    2e28:	e8 7b 08 00 00       	call   36a8 <printf>
    exit();
    2e2d:	e8 49 07 00 00       	call   357b <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2e32:	57                   	push   %edi
    2e33:	57                   	push   %edi
    2e34:	68 04 4f 00 00       	push   $0x4f04
    2e39:	ff 35 a8 51 00 00    	push   0x51a8
    2e3f:	e8 64 08 00 00       	call   36a8 <printf>
    exit();
    2e44:	e8 32 07 00 00       	call   357b <exit>
    printf(stdout, "sbrk test fork failed\n");
    2e49:	50                   	push   %eax
    2e4a:	50                   	push   %eax
    2e4b:	68 9e 47 00 00       	push   $0x479e
    2e50:	ff 35 a8 51 00 00    	push   0x51a8
    2e56:	e8 4d 08 00 00       	call   36a8 <printf>
    exit();
    2e5b:	e8 1b 07 00 00       	call   357b <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2e60:	53                   	push   %ebx
    2e61:	53                   	push   %ebx
    2e62:	68 a4 4f 00 00       	push   $0x4fa4
    2e67:	ff 35 a8 51 00 00    	push   0x51a8
    2e6d:	e8 36 08 00 00       	call   36a8 <printf>
    exit();
    2e72:	e8 04 07 00 00       	call   357b <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    2e77:	50                   	push   %eax
    2e78:	50                   	push   %eax
    2e79:	68 05 48 00 00       	push   $0x4805
    2e7e:	ff 35 a8 51 00 00    	push   0x51a8
    2e84:	e8 1f 08 00 00       	call   36a8 <printf>
    exit();
    2e89:	e8 ed 06 00 00       	call   357b <exit>
    printf(1, "pipe() failed\n");
    2e8e:	51                   	push   %ecx
    2e8f:	51                   	push   %ecx
    2e90:	68 c1 3c 00 00       	push   $0x3cc1
    2e95:	6a 01                	push   $0x1
    2e97:	e8 0c 08 00 00       	call   36a8 <printf>
    exit();
    2e9c:	e8 da 06 00 00       	call   357b <exit>
    exit();
    2ea1:	e8 d5 06 00 00       	call   357b <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    2ea6:	50                   	push   %eax
    2ea7:	50                   	push   %eax
    2ea8:	68 b5 47 00 00       	push   $0x47b5
    2ead:	ff 35 a8 51 00 00    	push   0x51a8
    2eb3:	e8 f0 07 00 00       	call   36a8 <printf>
    exit();
    2eb8:	e8 be 06 00 00       	call   357b <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2ebd:	56                   	push   %esi
    2ebe:	53                   	push   %ebx
    2ebf:	68 7c 4f 00 00       	push   $0x4f7c
    2ec4:	ff 35 a8 51 00 00    	push   0x51a8
    2eca:	e8 d9 07 00 00       	call   36a8 <printf>
    exit();
    2ecf:	e8 a7 06 00 00       	call   357b <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2ed4:	50                   	push   %eax
    2ed5:	53                   	push   %ebx
    2ed6:	68 44 4f 00 00       	push   $0x4f44
    2edb:	ff 35 a8 51 00 00    	push   0x51a8
    2ee1:	e8 c2 07 00 00       	call   36a8 <printf>
    exit();
    2ee6:	e8 90 06 00 00       	call   357b <exit>
    printf(stdout, "sbrk could not deallocate\n");
    2eeb:	56                   	push   %esi
    2eec:	56                   	push   %esi
    2eed:	68 d1 47 00 00       	push   $0x47d1
    2ef2:	ff 35 a8 51 00 00    	push   0x51a8
    2ef8:	e8 ab 07 00 00       	call   36a8 <printf>
    exit();
    2efd:	e8 79 06 00 00       	call   357b <exit>
    2f02:	66 90                	xchg   %ax,%ax

00002f04 <validateint>:
}
    2f04:	c3                   	ret
    2f05:	8d 76 00             	lea    0x0(%esi),%esi

00002f08 <validatetest>:
{
    2f08:	55                   	push   %ebp
    2f09:	89 e5                	mov    %esp,%ebp
    2f0b:	56                   	push   %esi
    2f0c:	53                   	push   %ebx
  printf(stdout, "validate test\n");
    2f0d:	83 ec 08             	sub    $0x8,%esp
    2f10:	68 2e 48 00 00       	push   $0x482e
    2f15:	ff 35 a8 51 00 00    	push   0x51a8
    2f1b:	e8 88 07 00 00       	call   36a8 <printf>
    2f20:	83 c4 10             	add    $0x10,%esp
  for(p = 0; p <= (uint)hi; p += 4096){
    2f23:	31 f6                	xor    %esi,%esi
    2f25:	8d 76 00             	lea    0x0(%esi),%esi
    if((pid = fork()) == 0){
    2f28:	e8 46 06 00 00       	call   3573 <fork>
    2f2d:	89 c3                	mov    %eax,%ebx
    2f2f:	85 c0                	test   %eax,%eax
    2f31:	74 61                	je     2f94 <validatetest+0x8c>
    sleep(0);
    2f33:	83 ec 0c             	sub    $0xc,%esp
    2f36:	6a 00                	push   $0x0
    2f38:	e8 ce 06 00 00       	call   360b <sleep>
    sleep(0);
    2f3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f44:	e8 c2 06 00 00       	call   360b <sleep>
    kill(pid);
    2f49:	89 1c 24             	mov    %ebx,(%esp)
    2f4c:	e8 5a 06 00 00       	call   35ab <kill>
    wait();
    2f51:	e8 2d 06 00 00       	call   3583 <wait>
    if(link("nosuchfile", (char*)p) != -1){
    2f56:	58                   	pop    %eax
    2f57:	5a                   	pop    %edx
    2f58:	56                   	push   %esi
    2f59:	68 3d 48 00 00       	push   $0x483d
    2f5e:	e8 78 06 00 00       	call   35db <link>
    2f63:	83 c4 10             	add    $0x10,%esp
    2f66:	40                   	inc    %eax
    2f67:	75 30                	jne    2f99 <validatetest+0x91>
  for(p = 0; p <= (uint)hi; p += 4096){
    2f69:	81 c6 00 10 00 00    	add    $0x1000,%esi
    2f6f:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    2f75:	75 b1                	jne    2f28 <validatetest+0x20>
  printf(stdout, "validate ok\n");
    2f77:	83 ec 08             	sub    $0x8,%esp
    2f7a:	68 61 48 00 00       	push   $0x4861
    2f7f:	ff 35 a8 51 00 00    	push   0x51a8
    2f85:	e8 1e 07 00 00       	call   36a8 <printf>
}
    2f8a:	83 c4 10             	add    $0x10,%esp
    2f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2f90:	5b                   	pop    %ebx
    2f91:	5e                   	pop    %esi
    2f92:	5d                   	pop    %ebp
    2f93:	c3                   	ret
      exit();
    2f94:	e8 e2 05 00 00       	call   357b <exit>
      printf(stdout, "link should not succeed\n");
    2f99:	83 ec 08             	sub    $0x8,%esp
    2f9c:	68 48 48 00 00       	push   $0x4848
    2fa1:	ff 35 a8 51 00 00    	push   0x51a8
    2fa7:	e8 fc 06 00 00       	call   36a8 <printf>
      exit();
    2fac:	e8 ca 05 00 00       	call   357b <exit>
    2fb1:	8d 76 00             	lea    0x0(%esi),%esi

00002fb4 <bsstest>:
{
    2fb4:	55                   	push   %ebp
    2fb5:	89 e5                	mov    %esp,%ebp
    2fb7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    2fba:	68 6e 48 00 00       	push   $0x486e
    2fbf:	ff 35 a8 51 00 00    	push   0x51a8
    2fc5:	e8 de 06 00 00       	call   36a8 <printf>
    2fca:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    2fcd:	31 c0                	xor    %eax,%eax
    2fcf:	90                   	nop
    if(uninit[i] != '\0'){
    2fd0:	80 b8 c0 51 00 00 00 	cmpb   $0x0,0x51c0(%eax)
    2fd7:	75 20                	jne    2ff9 <bsstest+0x45>
  for(i = 0; i < sizeof(uninit); i++){
    2fd9:	40                   	inc    %eax
    2fda:	3d 10 27 00 00       	cmp    $0x2710,%eax
    2fdf:	75 ef                	jne    2fd0 <bsstest+0x1c>
  printf(stdout, "bss test ok\n");
    2fe1:	83 ec 08             	sub    $0x8,%esp
    2fe4:	68 89 48 00 00       	push   $0x4889
    2fe9:	ff 35 a8 51 00 00    	push   0x51a8
    2fef:	e8 b4 06 00 00       	call   36a8 <printf>
}
    2ff4:	83 c4 10             	add    $0x10,%esp
    2ff7:	c9                   	leave
    2ff8:	c3                   	ret
      printf(stdout, "bss test failed\n");
    2ff9:	83 ec 08             	sub    $0x8,%esp
    2ffc:	68 78 48 00 00       	push   $0x4878
    3001:	ff 35 a8 51 00 00    	push   0x51a8
    3007:	e8 9c 06 00 00       	call   36a8 <printf>
      exit();
    300c:	e8 6a 05 00 00       	call   357b <exit>
    3011:	8d 76 00             	lea    0x0(%esi),%esi

00003014 <bigargtest>:
{
    3014:	55                   	push   %ebp
    3015:	89 e5                	mov    %esp,%ebp
    3017:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    301a:	68 96 48 00 00       	push   $0x4896
    301f:	e8 a7 05 00 00       	call   35cb <unlink>
  pid = fork();
    3024:	e8 4a 05 00 00       	call   3573 <fork>
  if(pid == 0){
    3029:	83 c4 10             	add    $0x10,%esp
    302c:	85 c0                	test   %eax,%eax
    302e:	74 3f                	je     306f <bigargtest+0x5b>
  } else if(pid < 0){
    3030:	0f 88 d9 00 00 00    	js     310f <bigargtest+0xfb>
  wait();
    3036:	e8 48 05 00 00       	call   3583 <wait>
  fd = open("bigarg-ok", 0);
    303b:	83 ec 08             	sub    $0x8,%esp
    303e:	6a 00                	push   $0x0
    3040:	68 96 48 00 00       	push   $0x4896
    3045:	e8 71 05 00 00       	call   35bb <open>
  if(fd < 0){
    304a:	83 c4 10             	add    $0x10,%esp
    304d:	85 c0                	test   %eax,%eax
    304f:	0f 88 a3 00 00 00    	js     30f8 <bigargtest+0xe4>
  close(fd);
    3055:	83 ec 0c             	sub    $0xc,%esp
    3058:	50                   	push   %eax
    3059:	e8 45 05 00 00       	call   35a3 <close>
  unlink("bigarg-ok");
    305e:	c7 04 24 96 48 00 00 	movl   $0x4896,(%esp)
    3065:	e8 61 05 00 00       	call   35cb <unlink>
}
    306a:	83 c4 10             	add    $0x10,%esp
    306d:	c9                   	leave
    306e:	c3                   	ret
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    306f:	c7 04 85 e0 98 00 00 	movl   $0x4ff8,0x98e0(,%eax,4)
    3076:	f8 4f 00 00 
    for(i = 0; i < MAXARG-1; i++)
    307a:	b8 01 00 00 00       	mov    $0x1,%eax
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    307f:	c7 04 85 e0 98 00 00 	movl   $0x4ff8,0x98e0(,%eax,4)
    3086:	f8 4f 00 00 
    308a:	c7 04 85 e4 98 00 00 	movl   $0x4ff8,0x98e4(,%eax,4)
    3091:	f8 4f 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3095:	83 c0 02             	add    $0x2,%eax
    3098:	83 f8 1f             	cmp    $0x1f,%eax
    309b:	75 e2                	jne    307f <bigargtest+0x6b>
    args[MAXARG-1] = 0;
    309d:	31 c9                	xor    %ecx,%ecx
    309f:	89 0d 5c 99 00 00    	mov    %ecx,0x995c
    printf(stdout, "bigarg test\n");
    30a5:	50                   	push   %eax
    30a6:	50                   	push   %eax
    30a7:	68 a0 48 00 00       	push   $0x48a0
    30ac:	ff 35 a8 51 00 00    	push   0x51a8
    30b2:	e8 f1 05 00 00       	call   36a8 <printf>
    exec("echo", args);
    30b7:	58                   	pop    %eax
    30b8:	5a                   	pop    %edx
    30b9:	68 e0 98 00 00       	push   $0x98e0
    30be:	68 6d 3a 00 00       	push   $0x3a6d
    30c3:	e8 eb 04 00 00       	call   35b3 <exec>
    printf(stdout, "bigarg test ok\n");
    30c8:	59                   	pop    %ecx
    30c9:	58                   	pop    %eax
    30ca:	68 ad 48 00 00       	push   $0x48ad
    30cf:	ff 35 a8 51 00 00    	push   0x51a8
    30d5:	e8 ce 05 00 00       	call   36a8 <printf>
    fd = open("bigarg-ok", O_CREATE);
    30da:	58                   	pop    %eax
    30db:	5a                   	pop    %edx
    30dc:	68 00 02 00 00       	push   $0x200
    30e1:	68 96 48 00 00       	push   $0x4896
    30e6:	e8 d0 04 00 00       	call   35bb <open>
    close(fd);
    30eb:	89 04 24             	mov    %eax,(%esp)
    30ee:	e8 b0 04 00 00       	call   35a3 <close>
    exit();
    30f3:	e8 83 04 00 00       	call   357b <exit>
    printf(stdout, "bigarg test failed!\n");
    30f8:	50                   	push   %eax
    30f9:	50                   	push   %eax
    30fa:	68 d6 48 00 00       	push   $0x48d6
    30ff:	ff 35 a8 51 00 00    	push   0x51a8
    3105:	e8 9e 05 00 00       	call   36a8 <printf>
    exit();
    310a:	e8 6c 04 00 00       	call   357b <exit>
    printf(stdout, "bigargtest: fork failed\n");
    310f:	52                   	push   %edx
    3110:	52                   	push   %edx
    3111:	68 bd 48 00 00       	push   $0x48bd
    3116:	ff 35 a8 51 00 00    	push   0x51a8
    311c:	e8 87 05 00 00       	call   36a8 <printf>
    exit();
    3121:	e8 55 04 00 00       	call   357b <exit>
    3126:	66 90                	xchg   %ax,%ax

00003128 <fsfull>:
{
    3128:	55                   	push   %ebp
    3129:	89 e5                	mov    %esp,%ebp
    312b:	57                   	push   %edi
    312c:	56                   	push   %esi
    312d:	53                   	push   %ebx
    312e:	83 ec 64             	sub    $0x64,%esp
  printf(1, "fsfull test\n");
    3131:	68 eb 48 00 00       	push   $0x48eb
    3136:	6a 01                	push   $0x1
    3138:	e8 6b 05 00 00       	call   36a8 <printf>
    313d:	83 c4 10             	add    $0x10,%esp
  for(nfiles = 0; ; nfiles++){
    3140:	31 db                	xor    %ebx,%ebx
    3142:	8d 7d a8             	lea    -0x58(%ebp),%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    3145:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    name[0] = 'f';
    3148:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    314c:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3151:	8b 75 a4             	mov    -0x5c(%ebp),%esi
    3154:	f7 e6                	mul    %esi
    3156:	c1 ea 06             	shr    $0x6,%edx
    3159:	83 c2 30             	add    $0x30,%edx
    315c:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    315f:	89 f0                	mov    %esi,%eax
    3161:	bb e8 03 00 00       	mov    $0x3e8,%ebx
    3166:	99                   	cltd
    3167:	f7 fb                	idiv   %ebx
    3169:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    316e:	f7 e2                	mul    %edx
    3170:	c1 ea 05             	shr    $0x5,%edx
    3173:	83 c2 30             	add    $0x30,%edx
    3176:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3179:	b9 64 00 00 00       	mov    $0x64,%ecx
    317e:	89 f0                	mov    %esi,%eax
    3180:	99                   	cltd
    3181:	f7 f9                	idiv   %ecx
    3183:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    3188:	f7 e2                	mul    %edx
    318a:	c1 ea 03             	shr    $0x3,%edx
    318d:	83 c2 30             	add    $0x30,%edx
    3190:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3193:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3198:	89 f0                	mov    %esi,%eax
    319a:	99                   	cltd
    319b:	f7 f9                	idiv   %ecx
    319d:	83 c2 30             	add    $0x30,%edx
    31a0:	88 55 ac             	mov    %dl,-0x54(%ebp)
    name[5] = '\0';
    31a3:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    31a7:	53                   	push   %ebx
    31a8:	57                   	push   %edi
    31a9:	68 f8 48 00 00       	push   $0x48f8
    31ae:	6a 01                	push   $0x1
    31b0:	e8 f3 04 00 00       	call   36a8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    31b5:	5e                   	pop    %esi
    31b6:	58                   	pop    %eax
    31b7:	68 02 02 00 00       	push   $0x202
    31bc:	57                   	push   %edi
    31bd:	e8 f9 03 00 00       	call   35bb <open>
    31c2:	89 c3                	mov    %eax,%ebx
    if(fd < 0){
    31c4:	83 c4 10             	add    $0x10,%esp
    31c7:	85 c0                	test   %eax,%eax
    31c9:	0f 89 9d 00 00 00    	jns    326c <fsfull+0x144>
      printf(1, "open %s failed\n", name);
    31cf:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
    31d2:	51                   	push   %ecx
    31d3:	57                   	push   %edi
    31d4:	68 04 49 00 00       	push   $0x4904
    31d9:	6a 01                	push   $0x1
    31db:	e8 c8 04 00 00       	call   36a8 <printf>
      break;
    31e0:	83 c4 10             	add    $0x10,%esp
    name[2] = '0' + (nfiles % 1000) / 100;
    31e3:	be e8 03 00 00       	mov    $0x3e8,%esi
    name[0] = 'f';
    31e8:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    31ec:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    31f1:	f7 e3                	mul    %ebx
    31f3:	c1 ea 06             	shr    $0x6,%edx
    31f6:	83 c2 30             	add    $0x30,%edx
    31f9:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    31fc:	89 d8                	mov    %ebx,%eax
    31fe:	99                   	cltd
    31ff:	f7 fe                	idiv   %esi
    3201:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3206:	f7 e2                	mul    %edx
    3208:	c1 ea 05             	shr    $0x5,%edx
    320b:	83 c2 30             	add    $0x30,%edx
    320e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3211:	b9 64 00 00 00       	mov    $0x64,%ecx
    3216:	89 d8                	mov    %ebx,%eax
    3218:	99                   	cltd
    3219:	f7 f9                	idiv   %ecx
    321b:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    3220:	f7 e2                	mul    %edx
    3222:	c1 ea 03             	shr    $0x3,%edx
    3225:	83 c2 30             	add    $0x30,%edx
    3228:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    322b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3230:	89 d8                	mov    %ebx,%eax
    3232:	99                   	cltd
    3233:	f7 f9                	idiv   %ecx
    3235:	83 c2 30             	add    $0x30,%edx
    3238:	88 55 ac             	mov    %dl,-0x54(%ebp)
    name[5] = '\0';
    323b:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    323f:	83 ec 0c             	sub    $0xc,%esp
    3242:	57                   	push   %edi
    3243:	e8 83 03 00 00       	call   35cb <unlink>
    nfiles--;
    3248:	4b                   	dec    %ebx
  while(nfiles >= 0){
    3249:	83 c4 10             	add    $0x10,%esp
    324c:	83 fb ff             	cmp    $0xffffffff,%ebx
    324f:	75 97                	jne    31e8 <fsfull+0xc0>
  printf(1, "fsfull test finished\n");
    3251:	83 ec 08             	sub    $0x8,%esp
    3254:	68 24 49 00 00       	push   $0x4924
    3259:	6a 01                	push   $0x1
    325b:	e8 48 04 00 00       	call   36a8 <printf>
}
    3260:	83 c4 10             	add    $0x10,%esp
    3263:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3266:	5b                   	pop    %ebx
    3267:	5e                   	pop    %esi
    3268:	5f                   	pop    %edi
    3269:	5d                   	pop    %ebp
    326a:	c3                   	ret
    326b:	90                   	nop
    int total = 0;
    326c:	31 f6                	xor    %esi,%esi
    326e:	eb 02                	jmp    3272 <fsfull+0x14a>
      total += cc;
    3270:	01 c6                	add    %eax,%esi
      int cc = write(fd, buf, 512);
    3272:	52                   	push   %edx
    3273:	68 00 02 00 00       	push   $0x200
    3278:	68 e0 78 00 00       	push   $0x78e0
    327d:	53                   	push   %ebx
    327e:	e8 18 03 00 00       	call   359b <write>
      if(cc < 512)
    3283:	83 c4 10             	add    $0x10,%esp
    3286:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    328b:	7f e3                	jg     3270 <fsfull+0x148>
    printf(1, "wrote %d bytes\n", total);
    328d:	50                   	push   %eax
    328e:	56                   	push   %esi
    328f:	68 14 49 00 00       	push   $0x4914
    3294:	6a 01                	push   $0x1
    3296:	e8 0d 04 00 00       	call   36a8 <printf>
    close(fd);
    329b:	89 1c 24             	mov    %ebx,(%esp)
    329e:	e8 00 03 00 00       	call   35a3 <close>
    if(total == 0)
    32a3:	83 c4 10             	add    $0x10,%esp
    32a6:	85 f6                	test   %esi,%esi
    32a8:	74 08                	je     32b2 <fsfull+0x18a>
  for(nfiles = 0; ; nfiles++){
    32aa:	ff 45 a4             	incl   -0x5c(%ebp)
    32ad:	e9 96 fe ff ff       	jmp    3148 <fsfull+0x20>
    32b2:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
    32b5:	e9 29 ff ff ff       	jmp    31e3 <fsfull+0xbb>
    32ba:	66 90                	xchg   %ax,%ax

000032bc <uio>:
{
    32bc:	55                   	push   %ebp
    32bd:	89 e5                	mov    %esp,%ebp
    32bf:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    32c2:	68 3a 49 00 00       	push   $0x493a
    32c7:	6a 01                	push   $0x1
    32c9:	e8 da 03 00 00       	call   36a8 <printf>
  pid = fork();
    32ce:	e8 a0 02 00 00       	call   3573 <fork>
  if(pid == 0){
    32d3:	83 c4 10             	add    $0x10,%esp
    32d6:	85 c0                	test   %eax,%eax
    32d8:	74 1b                	je     32f5 <uio+0x39>
  } else if(pid < 0){
    32da:	78 3a                	js     3316 <uio+0x5a>
  wait();
    32dc:	e8 a2 02 00 00       	call   3583 <wait>
  printf(1, "uio test done\n");
    32e1:	83 ec 08             	sub    $0x8,%esp
    32e4:	68 44 49 00 00       	push   $0x4944
    32e9:	6a 01                	push   $0x1
    32eb:	e8 b8 03 00 00       	call   36a8 <printf>
}
    32f0:	83 c4 10             	add    $0x10,%esp
    32f3:	c9                   	leave
    32f4:	c3                   	ret
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    32f5:	b0 09                	mov    $0x9,%al
    32f7:	ba 70 00 00 00       	mov    $0x70,%edx
    32fc:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    32fd:	ba 71 00 00 00       	mov    $0x71,%edx
    3302:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3303:	52                   	push   %edx
    3304:	52                   	push   %edx
    3305:	68 d8 50 00 00       	push   $0x50d8
    330a:	6a 01                	push   $0x1
    330c:	e8 97 03 00 00       	call   36a8 <printf>
    exit();
    3311:	e8 65 02 00 00       	call   357b <exit>
    printf (1, "fork failed\n");
    3316:	50                   	push   %eax
    3317:	50                   	push   %eax
    3318:	68 c9 48 00 00       	push   $0x48c9
    331d:	6a 01                	push   $0x1
    331f:	e8 84 03 00 00       	call   36a8 <printf>
    exit();
    3324:	e8 52 02 00 00       	call   357b <exit>
    3329:	8d 76 00             	lea    0x0(%esi),%esi

0000332c <argptest>:
{
    332c:	55                   	push   %ebp
    332d:	89 e5                	mov    %esp,%ebp
    332f:	53                   	push   %ebx
    3330:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    3333:	6a 00                	push   $0x0
    3335:	68 53 49 00 00       	push   $0x4953
    333a:	e8 7c 02 00 00       	call   35bb <open>
  if (fd < 0) {
    333f:	83 c4 10             	add    $0x10,%esp
    3342:	85 c0                	test   %eax,%eax
    3344:	78 37                	js     337d <argptest+0x51>
    3346:	89 c3                	mov    %eax,%ebx
  read(fd, sbrk(0) - 1, -1);
    3348:	83 ec 0c             	sub    $0xc,%esp
    334b:	6a 00                	push   $0x0
    334d:	e8 b1 02 00 00       	call   3603 <sbrk>
    3352:	83 c4 0c             	add    $0xc,%esp
    3355:	6a ff                	push   $0xffffffff
    3357:	48                   	dec    %eax
    3358:	50                   	push   %eax
    3359:	53                   	push   %ebx
    335a:	e8 34 02 00 00       	call   3593 <read>
  close(fd);
    335f:	89 1c 24             	mov    %ebx,(%esp)
    3362:	e8 3c 02 00 00       	call   35a3 <close>
  printf(1, "arg test passed\n");
    3367:	58                   	pop    %eax
    3368:	5a                   	pop    %edx
    3369:	68 65 49 00 00       	push   $0x4965
    336e:	6a 01                	push   $0x1
    3370:	e8 33 03 00 00       	call   36a8 <printf>
}
    3375:	83 c4 10             	add    $0x10,%esp
    3378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    337b:	c9                   	leave
    337c:	c3                   	ret
    printf(2, "open failed\n");
    337d:	51                   	push   %ecx
    337e:	51                   	push   %ecx
    337f:	68 58 49 00 00       	push   $0x4958
    3384:	6a 02                	push   $0x2
    3386:	e8 1d 03 00 00       	call   36a8 <printf>
    exit();
    338b:	e8 eb 01 00 00       	call   357b <exit>

00003390 <rand>:
  randstate = randstate * 1664525 + 1013904223;
    3390:	a1 a4 51 00 00       	mov    0x51a4,%eax
    3395:	8d 14 00             	lea    (%eax,%eax,1),%edx
    3398:	01 c2                	add    %eax,%edx
    339a:	8d 14 90             	lea    (%eax,%edx,4),%edx
    339d:	c1 e2 08             	shl    $0x8,%edx
    33a0:	01 c2                	add    %eax,%edx
    33a2:	8d 14 92             	lea    (%edx,%edx,4),%edx
    33a5:	8d 04 90             	lea    (%eax,%edx,4),%eax
    33a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
    33ab:	8d 84 80 5f f3 6e 3c 	lea    0x3c6ef35f(%eax,%eax,4),%eax
    33b2:	a3 a4 51 00 00       	mov    %eax,0x51a4
}
    33b7:	c3                   	ret

000033b8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    33b8:	55                   	push   %ebp
    33b9:	89 e5                	mov    %esp,%ebp
    33bb:	53                   	push   %ebx
    33bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
    33bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    33c2:	31 c0                	xor    %eax,%eax
    33c4:	8a 14 03             	mov    (%ebx,%eax,1),%dl
    33c7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    33ca:	40                   	inc    %eax
    33cb:	84 d2                	test   %dl,%dl
    33cd:	75 f5                	jne    33c4 <strcpy+0xc>
    ;
  return os;
}
    33cf:	89 c8                	mov    %ecx,%eax
    33d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    33d4:	c9                   	leave
    33d5:	c3                   	ret
    33d6:	66 90                	xchg   %ax,%ax

000033d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    33d8:	55                   	push   %ebp
    33d9:	89 e5                	mov    %esp,%ebp
    33db:	53                   	push   %ebx
    33dc:	8b 55 08             	mov    0x8(%ebp),%edx
    33df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
    33e2:	0f b6 02             	movzbl (%edx),%eax
    33e5:	84 c0                	test   %al,%al
    33e7:	75 10                	jne    33f9 <strcmp+0x21>
    33e9:	eb 2a                	jmp    3415 <strcmp+0x3d>
    33eb:	90                   	nop
    p++, q++;
    33ec:	42                   	inc    %edx
    33ed:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
    33f0:	0f b6 02             	movzbl (%edx),%eax
    33f3:	84 c0                	test   %al,%al
    33f5:	74 11                	je     3408 <strcmp+0x30>
    33f7:	89 cb                	mov    %ecx,%ebx
    33f9:	0f b6 0b             	movzbl (%ebx),%ecx
    33fc:	38 c1                	cmp    %al,%cl
    33fe:	74 ec                	je     33ec <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    3400:	29 c8                	sub    %ecx,%eax
}
    3402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3405:	c9                   	leave
    3406:	c3                   	ret
    3407:	90                   	nop
  return (uchar)*p - (uchar)*q;
    3408:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
    340c:	31 c0                	xor    %eax,%eax
    340e:	29 c8                	sub    %ecx,%eax
}
    3410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3413:	c9                   	leave
    3414:	c3                   	ret
  return (uchar)*p - (uchar)*q;
    3415:	0f b6 0b             	movzbl (%ebx),%ecx
    3418:	31 c0                	xor    %eax,%eax
    341a:	eb e4                	jmp    3400 <strcmp+0x28>

0000341c <strlen>:

uint
strlen(const char *s)
{
    341c:	55                   	push   %ebp
    341d:	89 e5                	mov    %esp,%ebp
    341f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    3422:	80 3a 00             	cmpb   $0x0,(%edx)
    3425:	74 15                	je     343c <strlen+0x20>
    3427:	31 c0                	xor    %eax,%eax
    3429:	8d 76 00             	lea    0x0(%esi),%esi
    342c:	40                   	inc    %eax
    342d:	89 c1                	mov    %eax,%ecx
    342f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    3433:	75 f7                	jne    342c <strlen+0x10>
    ;
  return n;
}
    3435:	89 c8                	mov    %ecx,%eax
    3437:	5d                   	pop    %ebp
    3438:	c3                   	ret
    3439:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    343c:	31 c9                	xor    %ecx,%ecx
}
    343e:	89 c8                	mov    %ecx,%eax
    3440:	5d                   	pop    %ebp
    3441:	c3                   	ret
    3442:	66 90                	xchg   %ax,%ax

00003444 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3444:	55                   	push   %ebp
    3445:	89 e5                	mov    %esp,%ebp
    3447:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3448:	8b 7d 08             	mov    0x8(%ebp),%edi
    344b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    344e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3451:	fc                   	cld
    3452:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3454:	8b 45 08             	mov    0x8(%ebp),%eax
    3457:	8b 7d fc             	mov    -0x4(%ebp),%edi
    345a:	c9                   	leave
    345b:	c3                   	ret

0000345c <strchr>:

char*
strchr(const char *s, char c)
{
    345c:	55                   	push   %ebp
    345d:	89 e5                	mov    %esp,%ebp
    345f:	8b 45 08             	mov    0x8(%ebp),%eax
    3462:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
    3465:	8a 10                	mov    (%eax),%dl
    3467:	84 d2                	test   %dl,%dl
    3469:	75 0c                	jne    3477 <strchr+0x1b>
    346b:	eb 13                	jmp    3480 <strchr+0x24>
    346d:	8d 76 00             	lea    0x0(%esi),%esi
    3470:	40                   	inc    %eax
    3471:	8a 10                	mov    (%eax),%dl
    3473:	84 d2                	test   %dl,%dl
    3475:	74 09                	je     3480 <strchr+0x24>
    if(*s == c)
    3477:	38 d1                	cmp    %dl,%cl
    3479:	75 f5                	jne    3470 <strchr+0x14>
      return (char*)s;
  return 0;
}
    347b:	5d                   	pop    %ebp
    347c:	c3                   	ret
    347d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
    3480:	31 c0                	xor    %eax,%eax
}
    3482:	5d                   	pop    %ebp
    3483:	c3                   	ret

00003484 <gets>:

char*
gets(char *buf, int max)
{
    3484:	55                   	push   %ebp
    3485:	89 e5                	mov    %esp,%ebp
    3487:	57                   	push   %edi
    3488:	56                   	push   %esi
    3489:	53                   	push   %ebx
    348a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    348d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
    348f:	8d 75 e7             	lea    -0x19(%ebp),%esi
  for(i=0; i+1 < max; ){
    3492:	eb 24                	jmp    34b8 <gets+0x34>
    cc = read(0, &c, 1);
    3494:	50                   	push   %eax
    3495:	6a 01                	push   $0x1
    3497:	56                   	push   %esi
    3498:	6a 00                	push   $0x0
    349a:	e8 f4 00 00 00       	call   3593 <read>
    if(cc < 1)
    349f:	83 c4 10             	add    $0x10,%esp
    34a2:	85 c0                	test   %eax,%eax
    34a4:	7e 1a                	jle    34c0 <gets+0x3c>
      break;
    buf[i++] = c;
    34a6:	8a 45 e7             	mov    -0x19(%ebp),%al
    34a9:	8b 55 08             	mov    0x8(%ebp),%edx
    34ac:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    34b0:	3c 0a                	cmp    $0xa,%al
    34b2:	74 0e                	je     34c2 <gets+0x3e>
    34b4:	3c 0d                	cmp    $0xd,%al
    34b6:	74 0a                	je     34c2 <gets+0x3e>
  for(i=0; i+1 < max; ){
    34b8:	89 df                	mov    %ebx,%edi
    34ba:	43                   	inc    %ebx
    34bb:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    34be:	7c d4                	jl     3494 <gets+0x10>
    34c0:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
    34c2:	8b 45 08             	mov    0x8(%ebp),%eax
    34c5:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
    34c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    34cc:	5b                   	pop    %ebx
    34cd:	5e                   	pop    %esi
    34ce:	5f                   	pop    %edi
    34cf:	5d                   	pop    %ebp
    34d0:	c3                   	ret
    34d1:	8d 76 00             	lea    0x0(%esi),%esi

000034d4 <stat>:

int
stat(const char *n, struct stat *st)
{
    34d4:	55                   	push   %ebp
    34d5:	89 e5                	mov    %esp,%ebp
    34d7:	56                   	push   %esi
    34d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    34d9:	83 ec 08             	sub    $0x8,%esp
    34dc:	6a 00                	push   $0x0
    34de:	ff 75 08             	push   0x8(%ebp)
    34e1:	e8 d5 00 00 00       	call   35bb <open>
  if(fd < 0)
    34e6:	83 c4 10             	add    $0x10,%esp
    34e9:	85 c0                	test   %eax,%eax
    34eb:	78 27                	js     3514 <stat+0x40>
    34ed:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    34ef:	83 ec 08             	sub    $0x8,%esp
    34f2:	ff 75 0c             	push   0xc(%ebp)
    34f5:	50                   	push   %eax
    34f6:	e8 d8 00 00 00       	call   35d3 <fstat>
    34fb:	89 c6                	mov    %eax,%esi
  close(fd);
    34fd:	89 1c 24             	mov    %ebx,(%esp)
    3500:	e8 9e 00 00 00       	call   35a3 <close>
  return r;
    3505:	83 c4 10             	add    $0x10,%esp
}
    3508:	89 f0                	mov    %esi,%eax
    350a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    350d:	5b                   	pop    %ebx
    350e:	5e                   	pop    %esi
    350f:	5d                   	pop    %ebp
    3510:	c3                   	ret
    3511:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    3514:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3519:	eb ed                	jmp    3508 <stat+0x34>
    351b:	90                   	nop

0000351c <atoi>:

int
atoi(const char *s)
{
    351c:	55                   	push   %ebp
    351d:	89 e5                	mov    %esp,%ebp
    351f:	53                   	push   %ebx
    3520:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3523:	0f be 01             	movsbl (%ecx),%eax
    3526:	8d 50 d0             	lea    -0x30(%eax),%edx
    3529:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
    352c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    3531:	77 16                	ja     3549 <atoi+0x2d>
    3533:	90                   	nop
    n = n*10 + *s++ - '0';
    3534:	41                   	inc    %ecx
    3535:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3538:	01 d2                	add    %edx,%edx
    353a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
    353e:	0f be 01             	movsbl (%ecx),%eax
    3541:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3544:	80 fb 09             	cmp    $0x9,%bl
    3547:	76 eb                	jbe    3534 <atoi+0x18>
  return n;
}
    3549:	89 d0                	mov    %edx,%eax
    354b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    354e:	c9                   	leave
    354f:	c3                   	ret

00003550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3550:	55                   	push   %ebp
    3551:	89 e5                	mov    %esp,%ebp
    3553:	57                   	push   %edi
    3554:	56                   	push   %esi
    3555:	8b 55 08             	mov    0x8(%ebp),%edx
    3558:	8b 75 0c             	mov    0xc(%ebp),%esi
    355b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    355e:	85 c0                	test   %eax,%eax
    3560:	7e 0b                	jle    356d <memmove+0x1d>
    3562:	01 d0                	add    %edx,%eax
  dst = vdst;
    3564:	89 d7                	mov    %edx,%edi
    3566:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
    3568:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    3569:	39 f8                	cmp    %edi,%eax
    356b:	75 fb                	jne    3568 <memmove+0x18>
  return vdst;
}
    356d:	89 d0                	mov    %edx,%eax
    356f:	5e                   	pop    %esi
    3570:	5f                   	pop    %edi
    3571:	5d                   	pop    %ebp
    3572:	c3                   	ret

00003573 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3573:	b8 01 00 00 00       	mov    $0x1,%eax
    3578:	cd 40                	int    $0x40
    357a:	c3                   	ret

0000357b <exit>:
SYSCALL(exit)
    357b:	b8 02 00 00 00       	mov    $0x2,%eax
    3580:	cd 40                	int    $0x40
    3582:	c3                   	ret

00003583 <wait>:
SYSCALL(wait)
    3583:	b8 03 00 00 00       	mov    $0x3,%eax
    3588:	cd 40                	int    $0x40
    358a:	c3                   	ret

0000358b <pipe>:
SYSCALL(pipe)
    358b:	b8 04 00 00 00       	mov    $0x4,%eax
    3590:	cd 40                	int    $0x40
    3592:	c3                   	ret

00003593 <read>:
SYSCALL(read)
    3593:	b8 05 00 00 00       	mov    $0x5,%eax
    3598:	cd 40                	int    $0x40
    359a:	c3                   	ret

0000359b <write>:
SYSCALL(write)
    359b:	b8 10 00 00 00       	mov    $0x10,%eax
    35a0:	cd 40                	int    $0x40
    35a2:	c3                   	ret

000035a3 <close>:
SYSCALL(close)
    35a3:	b8 15 00 00 00       	mov    $0x15,%eax
    35a8:	cd 40                	int    $0x40
    35aa:	c3                   	ret

000035ab <kill>:
SYSCALL(kill)
    35ab:	b8 06 00 00 00       	mov    $0x6,%eax
    35b0:	cd 40                	int    $0x40
    35b2:	c3                   	ret

000035b3 <exec>:
SYSCALL(exec)
    35b3:	b8 07 00 00 00       	mov    $0x7,%eax
    35b8:	cd 40                	int    $0x40
    35ba:	c3                   	ret

000035bb <open>:
SYSCALL(open)
    35bb:	b8 0f 00 00 00       	mov    $0xf,%eax
    35c0:	cd 40                	int    $0x40
    35c2:	c3                   	ret

000035c3 <mknod>:
SYSCALL(mknod)
    35c3:	b8 11 00 00 00       	mov    $0x11,%eax
    35c8:	cd 40                	int    $0x40
    35ca:	c3                   	ret

000035cb <unlink>:
SYSCALL(unlink)
    35cb:	b8 12 00 00 00       	mov    $0x12,%eax
    35d0:	cd 40                	int    $0x40
    35d2:	c3                   	ret

000035d3 <fstat>:
SYSCALL(fstat)
    35d3:	b8 08 00 00 00       	mov    $0x8,%eax
    35d8:	cd 40                	int    $0x40
    35da:	c3                   	ret

000035db <link>:
SYSCALL(link)
    35db:	b8 13 00 00 00       	mov    $0x13,%eax
    35e0:	cd 40                	int    $0x40
    35e2:	c3                   	ret

000035e3 <mkdir>:
SYSCALL(mkdir)
    35e3:	b8 14 00 00 00       	mov    $0x14,%eax
    35e8:	cd 40                	int    $0x40
    35ea:	c3                   	ret

000035eb <chdir>:
SYSCALL(chdir)
    35eb:	b8 09 00 00 00       	mov    $0x9,%eax
    35f0:	cd 40                	int    $0x40
    35f2:	c3                   	ret

000035f3 <dup>:
SYSCALL(dup)
    35f3:	b8 0a 00 00 00       	mov    $0xa,%eax
    35f8:	cd 40                	int    $0x40
    35fa:	c3                   	ret

000035fb <getpid>:
SYSCALL(getpid)
    35fb:	b8 0b 00 00 00       	mov    $0xb,%eax
    3600:	cd 40                	int    $0x40
    3602:	c3                   	ret

00003603 <sbrk>:
SYSCALL(sbrk)
    3603:	b8 0c 00 00 00       	mov    $0xc,%eax
    3608:	cd 40                	int    $0x40
    360a:	c3                   	ret

0000360b <sleep>:
SYSCALL(sleep)
    360b:	b8 0d 00 00 00       	mov    $0xd,%eax
    3610:	cd 40                	int    $0x40
    3612:	c3                   	ret

00003613 <uptime>:
SYSCALL(uptime)
    3613:	b8 0e 00 00 00       	mov    $0xe,%eax
    3618:	cd 40                	int    $0x40
    361a:	c3                   	ret
    361b:	90                   	nop

0000361c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    361c:	55                   	push   %ebp
    361d:	89 e5                	mov    %esp,%ebp
    361f:	57                   	push   %edi
    3620:	56                   	push   %esi
    3621:	53                   	push   %ebx
    3622:	83 ec 3c             	sub    $0x3c,%esp
    3625:	89 45 c0             	mov    %eax,-0x40(%ebp)
    3628:	89 cb                	mov    %ecx,%ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    362a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    362d:	85 c9                	test   %ecx,%ecx
    362f:	74 04                	je     3635 <printint+0x19>
    3631:	85 d2                	test   %edx,%edx
    3633:	78 6b                	js     36a0 <printint+0x84>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    3635:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  neg = 0;
    3638:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  }

  i = 0;
    363f:	31 c9                	xor    %ecx,%ecx
    3641:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
    3644:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    3647:	31 d2                	xor    %edx,%edx
    3649:	f7 f3                	div    %ebx
    364b:	89 cf                	mov    %ecx,%edi
    364d:	8d 49 01             	lea    0x1(%ecx),%ecx
    3650:	8a 92 90 51 00 00    	mov    0x5190(%edx),%dl
    3656:	88 54 3e 01          	mov    %dl,0x1(%esi,%edi,1)
  }while((x /= base) != 0);
    365a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    365d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    3660:	39 da                	cmp    %ebx,%edx
    3662:	73 e0                	jae    3644 <printint+0x28>
  if(neg)
    3664:	8b 55 08             	mov    0x8(%ebp),%edx
    3667:	85 d2                	test   %edx,%edx
    3669:	74 07                	je     3672 <printint+0x56>
    buf[i++] = '-';
    366b:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
    3670:	89 cf                	mov    %ecx,%edi

  while(--i >= 0)
    3672:	8d 5d d8             	lea    -0x28(%ebp),%ebx
    3675:	8d 7c 3d d8          	lea    -0x28(%ebp,%edi,1),%edi
    3679:	8d 76 00             	lea    0x0(%esi),%esi
    putc(fd, buf[i]);
    367c:	8a 07                	mov    (%edi),%al
    367e:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
    3681:	50                   	push   %eax
    3682:	6a 01                	push   $0x1
    3684:	56                   	push   %esi
    3685:	ff 75 c0             	push   -0x40(%ebp)
    3688:	e8 0e ff ff ff       	call   359b <write>
  while(--i >= 0)
    368d:	89 f8                	mov    %edi,%eax
    368f:	4f                   	dec    %edi
    3690:	83 c4 10             	add    $0x10,%esp
    3693:	39 d8                	cmp    %ebx,%eax
    3695:	75 e5                	jne    367c <printint+0x60>
}
    3697:	8d 65 f4             	lea    -0xc(%ebp),%esp
    369a:	5b                   	pop    %ebx
    369b:	5e                   	pop    %esi
    369c:	5f                   	pop    %edi
    369d:	5d                   	pop    %ebp
    369e:	c3                   	ret
    369f:	90                   	nop
    x = -xx;
    36a0:	f7 da                	neg    %edx
    36a2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    36a5:	eb 98                	jmp    363f <printint+0x23>
    36a7:	90                   	nop

000036a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    36a8:	55                   	push   %ebp
    36a9:	89 e5                	mov    %esp,%ebp
    36ab:	57                   	push   %edi
    36ac:	56                   	push   %esi
    36ad:	53                   	push   %ebx
    36ae:	83 ec 2c             	sub    $0x2c,%esp
    36b1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    36b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    36b7:	8a 03                	mov    (%ebx),%al
    36b9:	84 c0                	test   %al,%al
    36bb:	74 2a                	je     36e7 <printf+0x3f>
    36bd:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
    36be:	8d 4d 10             	lea    0x10(%ebp),%ecx
    36c1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    36c4:	0f b6 d0             	movzbl %al,%edx
    if(state == 0){
      if(c == '%'){
    36c7:	83 fa 25             	cmp    $0x25,%edx
    36ca:	74 24                	je     36f0 <printf+0x48>
        state = '%';
      } else {
        putc(fd, c);
    36cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    36cf:	50                   	push   %eax
    36d0:	6a 01                	push   $0x1
    36d2:	8d 45 e7             	lea    -0x19(%ebp),%eax
    36d5:	50                   	push   %eax
    36d6:	56                   	push   %esi
    36d7:	e8 bf fe ff ff       	call   359b <write>
  for(i = 0; fmt[i]; i++){
    36dc:	43                   	inc    %ebx
    36dd:	8a 43 ff             	mov    -0x1(%ebx),%al
    36e0:	83 c4 10             	add    $0x10,%esp
    36e3:	84 c0                	test   %al,%al
    36e5:	75 dd                	jne    36c4 <printf+0x1c>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    36e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    36ea:	5b                   	pop    %ebx
    36eb:	5e                   	pop    %esi
    36ec:	5f                   	pop    %edi
    36ed:	5d                   	pop    %ebp
    36ee:	c3                   	ret
    36ef:	90                   	nop
  for(i = 0; fmt[i]; i++){
    36f0:	8a 13                	mov    (%ebx),%dl
    36f2:	84 d2                	test   %dl,%dl
    36f4:	74 f1                	je     36e7 <printf+0x3f>
    c = fmt[i] & 0xff;
    36f6:	0f b6 c2             	movzbl %dl,%eax
      if(c == 'd'){
    36f9:	80 fa 25             	cmp    $0x25,%dl
    36fc:	0f 84 fe 00 00 00    	je     3800 <printf+0x158>
    3702:	83 e8 63             	sub    $0x63,%eax
    3705:	83 f8 15             	cmp    $0x15,%eax
    3708:	77 0a                	ja     3714 <printf+0x6c>
    370a:	ff 24 85 38 51 00 00 	jmp    *0x5138(,%eax,4)
    3711:	8d 76 00             	lea    0x0(%esi),%esi
    3714:	88 55 d0             	mov    %dl,-0x30(%ebp)
        putc(fd, '%');
    3717:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    371b:	50                   	push   %eax
    371c:	6a 01                	push   $0x1
    371e:	8d 7d e7             	lea    -0x19(%ebp),%edi
    3721:	57                   	push   %edi
    3722:	56                   	push   %esi
    3723:	e8 73 fe ff ff       	call   359b <write>
        putc(fd, c);
    3728:	8a 55 d0             	mov    -0x30(%ebp),%dl
    372b:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    372e:	83 c4 0c             	add    $0xc,%esp
    3731:	6a 01                	push   $0x1
    3733:	57                   	push   %edi
    3734:	56                   	push   %esi
    3735:	e8 61 fe ff ff       	call   359b <write>
  for(i = 0; fmt[i]; i++){
    373a:	83 c3 02             	add    $0x2,%ebx
    373d:	8a 43 ff             	mov    -0x1(%ebx),%al
    3740:	83 c4 10             	add    $0x10,%esp
    3743:	84 c0                	test   %al,%al
    3745:	0f 85 79 ff ff ff    	jne    36c4 <printf+0x1c>
}
    374b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    374e:	5b                   	pop    %ebx
    374f:	5e                   	pop    %esi
    3750:	5f                   	pop    %edi
    3751:	5d                   	pop    %ebp
    3752:	c3                   	ret
    3753:	90                   	nop
        printint(fd, *ap, 16, 0);
    3754:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3757:	8b 17                	mov    (%edi),%edx
    3759:	83 ec 0c             	sub    $0xc,%esp
    375c:	6a 00                	push   $0x0
    375e:	b9 10 00 00 00       	mov    $0x10,%ecx
    3763:	89 f0                	mov    %esi,%eax
    3765:	e8 b2 fe ff ff       	call   361c <printint>
        ap++;
    376a:	83 c7 04             	add    $0x4,%edi
    376d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    3770:	eb c8                	jmp    373a <printf+0x92>
    3772:	66 90                	xchg   %ax,%ax
        s = (char*)*ap;
    3774:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    3777:	8b 01                	mov    (%ecx),%eax
        ap++;
    3779:	83 c1 04             	add    $0x4,%ecx
    377c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    377f:	85 c0                	test   %eax,%eax
    3781:	0f 84 89 00 00 00    	je     3810 <printf+0x168>
        while(*s != 0){
    3787:	8a 10                	mov    (%eax),%dl
    3789:	84 d2                	test   %dl,%dl
    378b:	74 29                	je     37b6 <printf+0x10e>
    378d:	89 c7                	mov    %eax,%edi
    378f:	88 d0                	mov    %dl,%al
    3791:	8d 4d e7             	lea    -0x19(%ebp),%ecx
    3794:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3797:	89 fb                	mov    %edi,%ebx
    3799:	89 cf                	mov    %ecx,%edi
    379b:	90                   	nop
          putc(fd, *s);
    379c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    379f:	50                   	push   %eax
    37a0:	6a 01                	push   $0x1
    37a2:	57                   	push   %edi
    37a3:	56                   	push   %esi
    37a4:	e8 f2 fd ff ff       	call   359b <write>
          s++;
    37a9:	43                   	inc    %ebx
        while(*s != 0){
    37aa:	8a 03                	mov    (%ebx),%al
    37ac:	83 c4 10             	add    $0x10,%esp
    37af:	84 c0                	test   %al,%al
    37b1:	75 e9                	jne    379c <printf+0xf4>
    37b3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
    37b6:	83 c3 02             	add    $0x2,%ebx
    37b9:	8a 43 ff             	mov    -0x1(%ebx),%al
    37bc:	84 c0                	test   %al,%al
    37be:	0f 85 00 ff ff ff    	jne    36c4 <printf+0x1c>
    37c4:	e9 1e ff ff ff       	jmp    36e7 <printf+0x3f>
    37c9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    37cc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    37cf:	8b 17                	mov    (%edi),%edx
    37d1:	83 ec 0c             	sub    $0xc,%esp
    37d4:	6a 01                	push   $0x1
    37d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
    37db:	eb 86                	jmp    3763 <printf+0xbb>
    37dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
    37e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    37e3:	8b 00                	mov    (%eax),%eax
    37e5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    37e8:	51                   	push   %ecx
    37e9:	6a 01                	push   $0x1
    37eb:	8d 7d e7             	lea    -0x19(%ebp),%edi
    37ee:	57                   	push   %edi
    37ef:	56                   	push   %esi
    37f0:	e8 a6 fd ff ff       	call   359b <write>
        ap++;
    37f5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    37f9:	e9 3c ff ff ff       	jmp    373a <printf+0x92>
    37fe:	66 90                	xchg   %ax,%ax
        putc(fd, c);
    3800:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    3803:	52                   	push   %edx
    3804:	6a 01                	push   $0x1
    3806:	8d 7d e7             	lea    -0x19(%ebp),%edi
    3809:	e9 25 ff ff ff       	jmp    3733 <printf+0x8b>
    380e:	66 90                	xchg   %ax,%ax
          s = "(null)";
    3810:	bf a9 49 00 00       	mov    $0x49a9,%edi
    3815:	b0 28                	mov    $0x28,%al
    3817:	e9 75 ff ff ff       	jmp    3791 <printf+0xe9>

0000381c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    381c:	55                   	push   %ebp
    381d:	89 e5                	mov    %esp,%ebp
    381f:	57                   	push   %edi
    3820:	56                   	push   %esi
    3821:	53                   	push   %ebx
    3822:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3825:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3828:	a1 60 99 00 00       	mov    0x9960,%eax
    382d:	8d 76 00             	lea    0x0(%esi),%esi
    3830:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3832:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3834:	39 ca                	cmp    %ecx,%edx
    3836:	73 2c                	jae    3864 <free+0x48>
    3838:	39 c1                	cmp    %eax,%ecx
    383a:	72 04                	jb     3840 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    383c:	39 c2                	cmp    %eax,%edx
    383e:	72 f0                	jb     3830 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3840:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3843:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3846:	39 f8                	cmp    %edi,%eax
    3848:	74 2c                	je     3876 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    384a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    384d:	8b 42 04             	mov    0x4(%edx),%eax
    3850:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    3853:	39 f1                	cmp    %esi,%ecx
    3855:	74 36                	je     388d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    3857:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
    3859:	89 15 60 99 00 00    	mov    %edx,0x9960
}
    385f:	5b                   	pop    %ebx
    3860:	5e                   	pop    %esi
    3861:	5f                   	pop    %edi
    3862:	5d                   	pop    %ebp
    3863:	c3                   	ret
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3864:	39 c2                	cmp    %eax,%edx
    3866:	72 c8                	jb     3830 <free+0x14>
    3868:	39 c1                	cmp    %eax,%ecx
    386a:	73 c4                	jae    3830 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
    386c:	8b 73 fc             	mov    -0x4(%ebx),%esi
    386f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3872:	39 f8                	cmp    %edi,%eax
    3874:	75 d4                	jne    384a <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
    3876:	03 70 04             	add    0x4(%eax),%esi
    3879:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    387c:	8b 02                	mov    (%edx),%eax
    387e:	8b 00                	mov    (%eax),%eax
    3880:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    3883:	8b 42 04             	mov    0x4(%edx),%eax
    3886:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    3889:	39 f1                	cmp    %esi,%ecx
    388b:	75 ca                	jne    3857 <free+0x3b>
    p->s.size += bp->s.size;
    388d:	03 43 fc             	add    -0x4(%ebx),%eax
    3890:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    3893:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    3896:	89 0a                	mov    %ecx,(%edx)
  freep = p;
    3898:	89 15 60 99 00 00    	mov    %edx,0x9960
}
    389e:	5b                   	pop    %ebx
    389f:	5e                   	pop    %esi
    38a0:	5f                   	pop    %edi
    38a1:	5d                   	pop    %ebp
    38a2:	c3                   	ret
    38a3:	90                   	nop

000038a4 <malloc>:
}


void*
malloc(uint nbytes)
{
    38a4:	55                   	push   %ebp
    38a5:	89 e5                	mov    %esp,%ebp
    38a7:	57                   	push   %edi
    38a8:	56                   	push   %esi
    38a9:	53                   	push   %ebx
    38aa:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    38ad:	8b 45 08             	mov    0x8(%ebp),%eax
    38b0:	8d 78 07             	lea    0x7(%eax),%edi
    38b3:	c1 ef 03             	shr    $0x3,%edi
    38b6:	47                   	inc    %edi
  if((prevp = freep) == 0){
    38b7:	8b 15 60 99 00 00    	mov    0x9960,%edx
    38bd:	85 d2                	test   %edx,%edx
    38bf:	0f 84 93 00 00 00    	je     3958 <malloc+0xb4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    38c5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    38c7:	8b 48 04             	mov    0x4(%eax),%ecx
    38ca:	39 f9                	cmp    %edi,%ecx
    38cc:	73 62                	jae    3930 <malloc+0x8c>
  if(nu < 4096)
    38ce:	89 fb                	mov    %edi,%ebx
    38d0:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    38d6:	72 78                	jb     3950 <malloc+0xac>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
    38d8:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    38df:	eb 0e                	jmp    38ef <malloc+0x4b>
    38e1:	8d 76 00             	lea    0x0(%esi),%esi
    38e4:	89 c2                	mov    %eax,%edx
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    38e6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    38e8:	8b 48 04             	mov    0x4(%eax),%ecx
    38eb:	39 f9                	cmp    %edi,%ecx
    38ed:	73 41                	jae    3930 <malloc+0x8c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    38ef:	39 05 60 99 00 00    	cmp    %eax,0x9960
    38f5:	75 ed                	jne    38e4 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));   // sbrk(n) asks the kernel for n more bytes.
    38f7:	83 ec 0c             	sub    $0xc,%esp
    38fa:	56                   	push   %esi
    38fb:	e8 03 fd ff ff       	call   3603 <sbrk>
  if(p == (char*)-1)
    3900:	83 c4 10             	add    $0x10,%esp
    3903:	83 f8 ff             	cmp    $0xffffffff,%eax
    3906:	74 1c                	je     3924 <malloc+0x80>
  hp->s.size = nu;
    3908:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    390b:	83 ec 0c             	sub    $0xc,%esp
    390e:	83 c0 08             	add    $0x8,%eax
    3911:	50                   	push   %eax
    3912:	e8 05 ff ff ff       	call   381c <free>
  return freep;
    3917:	8b 15 60 99 00 00    	mov    0x9960,%edx
      if((p = morecore(nunits)) == 0)
    391d:	83 c4 10             	add    $0x10,%esp
    3920:	85 d2                	test   %edx,%edx
    3922:	75 c2                	jne    38e6 <malloc+0x42>
        return 0;
    3924:	31 c0                	xor    %eax,%eax
  }
}
    3926:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3929:	5b                   	pop    %ebx
    392a:	5e                   	pop    %esi
    392b:	5f                   	pop    %edi
    392c:	5d                   	pop    %ebp
    392d:	c3                   	ret
    392e:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
    3930:	39 cf                	cmp    %ecx,%edi
    3932:	74 4c                	je     3980 <malloc+0xdc>
        p->s.size -= nunits;
    3934:	29 f9                	sub    %edi,%ecx
    3936:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3939:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    393c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    393f:	89 15 60 99 00 00    	mov    %edx,0x9960
      return (void*)(p + 1);
    3945:	83 c0 08             	add    $0x8,%eax
}
    3948:	8d 65 f4             	lea    -0xc(%ebp),%esp
    394b:	5b                   	pop    %ebx
    394c:	5e                   	pop    %esi
    394d:	5f                   	pop    %edi
    394e:	5d                   	pop    %ebp
    394f:	c3                   	ret
  if(nu < 4096)
    3950:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3955:	eb 81                	jmp    38d8 <malloc+0x34>
    3957:	90                   	nop
    base.s.ptr = freep = prevp = &base;
    3958:	c7 05 60 99 00 00 64 	movl   $0x9964,0x9960
    395f:	99 00 00 
    3962:	c7 05 64 99 00 00 64 	movl   $0x9964,0x9964
    3969:	99 00 00 
    base.s.size = 0;
    396c:	c7 05 68 99 00 00 00 	movl   $0x0,0x9968
    3973:	00 00 00 
    3976:	b8 64 99 00 00       	mov    $0x9964,%eax
    397b:	e9 4e ff ff ff       	jmp    38ce <malloc+0x2a>
        prevp->s.ptr = p->s.ptr;
    3980:	8b 08                	mov    (%eax),%ecx
    3982:	89 0a                	mov    %ecx,(%edx)
    3984:	eb b9                	jmp    393f <malloc+0x9b>
