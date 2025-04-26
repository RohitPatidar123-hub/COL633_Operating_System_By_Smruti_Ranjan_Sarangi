
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 67 11 80       	mov    $0x801167d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 78 2d 10 80       	mov    $0x80102d78,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 c0 6e 10 80       	push   $0x80106ec0
80100040:	68 20 a5 10 80       	push   $0x8010a520
80100045:	e8 f6 43 00 00       	call   80104440 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
80100051:	ec 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
8010005b:	ec 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
80100061:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100066:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
8010006b:	eb 05                	jmp    80100072 <binit+0x3e>
8010006d:	8d 76 00             	lea    0x0(%esi),%esi
80100070:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100072:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100075:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010007c:	83 ec 08             	sub    $0x8,%esp
8010007f:	68 c7 6e 10 80       	push   $0x80106ec7
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 a7 42 00 00       	call   80104334 <initsleeplock>
    bcache.head.next->prev = b;
8010008d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100092:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100095:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009b:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a1:	89 d8                	mov    %ebx,%eax
801000a3:	83 c4 10             	add    $0x10,%esp
801000a6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000ac:	75 c2                	jne    80100070 <binit+0x3c>
  }
}
801000ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000b1:	c9                   	leave
801000b2:	c3                   	ret
801000b3:	90                   	nop

801000b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	57                   	push   %edi
801000b8:	56                   	push   %esi
801000b9:	53                   	push   %ebx
801000ba:	83 ec 18             	sub    $0x18,%esp
801000bd:	8b 75 08             	mov    0x8(%ebp),%esi
801000c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 3b 45 00 00       	call   80104608 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000cd:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000d3:	83 c4 10             	add    $0x10,%esp
801000d6:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000dc:	75 0d                	jne    801000eb <bread+0x37>
801000de:	eb 1c                	jmp    801000fc <bread+0x48>
801000e0:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000e3:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000e9:	74 11                	je     801000fc <bread+0x48>
    if(b->dev == dev && b->blockno == blockno){
801000eb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000ee:	75 f0                	jne    801000e0 <bread+0x2c>
801000f0:	3b 7b 08             	cmp    0x8(%ebx),%edi
801000f3:	75 eb                	jne    801000e0 <bread+0x2c>
      b->refcnt++;
801000f5:	ff 43 4c             	incl   0x4c(%ebx)
      release(&bcache.lock);
801000f8:	eb 3c                	jmp    80100136 <bread+0x82>
801000fa:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000fc:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100102:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100108:	75 0d                	jne    80100117 <bread+0x63>
8010010a:	eb 6a                	jmp    80100176 <bread+0xc2>
8010010c:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010010f:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100115:	74 5f                	je     80100176 <bread+0xc2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100117:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010011a:	85 c0                	test   %eax,%eax
8010011c:	75 ee                	jne    8010010c <bread+0x58>
8010011e:	f6 03 04             	testb  $0x4,(%ebx)
80100121:	75 e9                	jne    8010010c <bread+0x58>
      b->dev = dev;
80100123:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100126:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010012f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100136:	83 ec 0c             	sub    $0xc,%esp
80100139:	68 20 a5 10 80       	push   $0x8010a520
8010013e:	e8 65 44 00 00       	call   801045a8 <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 1a 42 00 00       	call   80104368 <acquiresleep>
      return b;
8010014e:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100151:	f6 03 02             	testb  $0x2,(%ebx)
80100154:	74 0a                	je     80100160 <bread+0xac>
    iderw(b);
  }
  return b;
}
80100156:	89 d8                	mov    %ebx,%eax
80100158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010015b:	5b                   	pop    %ebx
8010015c:	5e                   	pop    %esi
8010015d:	5f                   	pop    %edi
8010015e:	5d                   	pop    %ebp
8010015f:	c3                   	ret
    iderw(b);
80100160:	83 ec 0c             	sub    $0xc,%esp
80100163:	53                   	push   %ebx
80100164:	e8 ef 1f 00 00       	call   80102158 <iderw>
80100169:	83 c4 10             	add    $0x10,%esp
}
8010016c:	89 d8                	mov    %ebx,%eax
8010016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100171:	5b                   	pop    %ebx
80100172:	5e                   	pop    %esi
80100173:	5f                   	pop    %edi
80100174:	5d                   	pop    %ebp
80100175:	c3                   	ret
  panic("bget: no buffers");
80100176:	83 ec 0c             	sub    $0xc,%esp
80100179:	68 ce 6e 10 80       	push   $0x80106ece
8010017e:	e8 b5 01 00 00       	call   80100338 <panic>
80100183:	90                   	nop

80100184 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100184:	55                   	push   %ebp
80100185:	89 e5                	mov    %esp,%ebp
80100187:	53                   	push   %ebx
80100188:	83 ec 10             	sub    $0x10,%esp
8010018b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010018e:	8d 43 0c             	lea    0xc(%ebx),%eax
80100191:	50                   	push   %eax
80100192:	e8 61 42 00 00       	call   801043f8 <holdingsleep>
80100197:	83 c4 10             	add    $0x10,%esp
8010019a:	85 c0                	test   %eax,%eax
8010019c:	74 0f                	je     801001ad <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
8010019e:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001a7:	c9                   	leave
  iderw(b);
801001a8:	e9 ab 1f 00 00       	jmp    80102158 <iderw>
    panic("bwrite");
801001ad:	83 ec 0c             	sub    $0xc,%esp
801001b0:	68 df 6e 10 80       	push   $0x80106edf
801001b5:	e8 7e 01 00 00       	call   80100338 <panic>
801001ba:	66 90                	xchg   %ax,%ax

801001bc <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001bc:	55                   	push   %ebp
801001bd:	89 e5                	mov    %esp,%ebp
801001bf:	56                   	push   %esi
801001c0:	53                   	push   %ebx
801001c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c4:	8d 73 0c             	lea    0xc(%ebx),%esi
801001c7:	83 ec 0c             	sub    $0xc,%esp
801001ca:	56                   	push   %esi
801001cb:	e8 28 42 00 00       	call   801043f8 <holdingsleep>
801001d0:	83 c4 10             	add    $0x10,%esp
801001d3:	85 c0                	test   %eax,%eax
801001d5:	74 61                	je     80100238 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	56                   	push   %esi
801001db:	e8 dc 41 00 00       	call   801043bc <releasesleep>

  acquire(&bcache.lock);
801001e0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001e7:	e8 1c 44 00 00       	call   80104608 <acquire>
  b->refcnt--;
801001ec:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001ef:	48                   	dec    %eax
801001f0:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001f3:	83 c4 10             	add    $0x10,%esp
801001f6:	85 c0                	test   %eax,%eax
801001f8:	75 2c                	jne    80100226 <brelse+0x6a>
    // no one is waiting for it.
    b->next->prev = b->prev;
801001fa:	8b 53 54             	mov    0x54(%ebx),%edx
801001fd:	8b 43 50             	mov    0x50(%ebx),%eax
80100200:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100203:	8b 53 54             	mov    0x54(%ebx),%edx
80100206:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100209:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010020e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100211:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100218:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010021d:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100220:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100226:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
8010022d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100230:	5b                   	pop    %ebx
80100231:	5e                   	pop    %esi
80100232:	5d                   	pop    %ebp
  release(&bcache.lock);
80100233:	e9 70 43 00 00       	jmp    801045a8 <release>
    panic("brelse");
80100238:	83 ec 0c             	sub    $0xc,%esp
8010023b:	68 e6 6e 10 80       	push   $0x80106ee6
80100240:	e8 f3 00 00 00       	call   80100338 <panic>
80100245:	66 90                	xchg   %ax,%ax
80100247:	90                   	nop

80100248 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100248:	55                   	push   %ebp
80100249:	89 e5                	mov    %esp,%ebp
8010024b:	57                   	push   %edi
8010024c:	56                   	push   %esi
8010024d:	53                   	push   %ebx
8010024e:	83 ec 18             	sub    $0x18,%esp
80100251:	8b 7d 08             	mov    0x8(%ebp),%edi
80100254:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100257:	57                   	push   %edi
80100258:	e8 93 15 00 00       	call   801017f0 <iunlock>
  target = n;
8010025d:	89 de                	mov    %ebx,%esi
  acquire(&cons.lock);
8010025f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100266:	e8 9d 43 00 00       	call   80104608 <acquire>
  while(n > 0){
8010026b:	83 c4 10             	add    $0x10,%esp
8010026e:	85 db                	test   %ebx,%ebx
80100270:	0f 8e 93 00 00 00    	jle    80100309 <consoleread+0xc1>
    while(input.r == input.w){
80100276:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010027b:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100281:	74 27                	je     801002aa <consoleread+0x62>
80100283:	eb 57                	jmp    801002dc <consoleread+0x94>
80100285:	8d 76 00             	lea    0x0(%esi),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100288:	83 ec 08             	sub    $0x8,%esp
8010028b:	68 20 ef 10 80       	push   $0x8010ef20
80100290:	68 00 ef 10 80       	push   $0x8010ef00
80100295:	e8 3a 39 00 00       	call   80103bd4 <sleep>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a8:	75 32                	jne    801002dc <consoleread+0x94>
      if(myproc()->killed){
801002aa:	e8 59 33 00 00       	call   80103608 <myproc>
801002af:	8b 40 70             	mov    0x70(%eax),%eax
801002b2:	85 c0                	test   %eax,%eax
801002b4:	74 d2                	je     80100288 <consoleread+0x40>
        release(&cons.lock);
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 20 ef 10 80       	push   $0x8010ef20
801002be:	e8 e5 42 00 00       	call   801045a8 <release>
        ilock(ip);
801002c3:	89 3c 24             	mov    %edi,(%esp)
801002c6:	e8 5d 14 00 00       	call   80101728 <ilock>
        return -1;
801002cb:	83 c4 10             	add    $0x10,%esp
801002ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002d6:	5b                   	pop    %ebx
801002d7:	5e                   	pop    %esi
801002d8:	5f                   	pop    %edi
801002d9:	5d                   	pop    %ebp
801002da:	c3                   	ret
801002db:	90                   	nop
    c = input.buf[input.r++ % INPUT_BUF];
801002dc:	8d 50 01             	lea    0x1(%eax),%edx
801002df:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	83 e2 7f             	and    $0x7f,%edx
801002ea:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
801002f1:	80 f9 04             	cmp    $0x4,%cl
801002f4:	74 37                	je     8010032d <consoleread+0xe5>
    *dst++ = c;
801002f6:	ff 45 0c             	incl   0xc(%ebp)
801002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fc:	88 48 ff             	mov    %cl,-0x1(%eax)
    --n;
801002ff:	4b                   	dec    %ebx
    if(c == '\n')
80100300:	83 f9 0a             	cmp    $0xa,%ecx
80100303:	0f 85 65 ff ff ff    	jne    8010026e <consoleread+0x26>
  release(&cons.lock);
80100309:	83 ec 0c             	sub    $0xc,%esp
8010030c:	68 20 ef 10 80       	push   $0x8010ef20
80100311:	e8 92 42 00 00       	call   801045a8 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 0a 14 00 00       	call   80101728 <ilock>
  return target - n;
8010031e:	89 f0                	mov    %esi,%eax
80100320:	29 d8                	sub    %ebx,%eax
80100322:	83 c4 10             	add    $0x10,%esp
}
80100325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100328:	5b                   	pop    %ebx
80100329:	5e                   	pop    %esi
8010032a:	5f                   	pop    %edi
8010032b:	5d                   	pop    %ebp
8010032c:	c3                   	ret
      if(n < target){
8010032d:	39 f3                	cmp    %esi,%ebx
8010032f:	73 d8                	jae    80100309 <consoleread+0xc1>
        input.r--;
80100331:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100336:	eb d1                	jmp    80100309 <consoleread+0xc1>

80100338 <panic>:
{
80100338:	55                   	push   %ebp
80100339:	89 e5                	mov    %esp,%ebp
8010033b:	53                   	push   %ebx
8010033c:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010033f:	fa                   	cli
  cons.locking = 0;
80100340:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100347:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010034a:	e8 71 23 00 00       	call   801026c0 <lapicid>
8010034f:	83 ec 08             	sub    $0x8,%esp
80100352:	50                   	push   %eax
80100353:	68 ed 6e 10 80       	push   $0x80106eed
80100358:	e8 c3 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
8010035d:	58                   	pop    %eax
8010035e:	ff 75 08             	push   0x8(%ebp)
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
80100366:	c7 04 24 3f 74 10 80 	movl   $0x8010743f,(%esp)
8010036d:	e8 ae 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
80100372:	5a                   	pop    %edx
80100373:	59                   	pop    %ecx
80100374:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100377:	53                   	push   %ebx
80100378:	8d 45 08             	lea    0x8(%ebp),%eax
8010037b:	50                   	push   %eax
8010037c:	e8 db 40 00 00       	call   8010445c <getcallerpcs>
  for(i=0; i<10; i++)
80100381:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100384:	83 ec 08             	sub    $0x8,%esp
80100387:	ff 33                	push   (%ebx)
80100389:	68 01 6f 10 80       	push   $0x80106f01
8010038e:	e8 8d 02 00 00       	call   80100620 <cprintf>
  for(i=0; i<10; i++)
80100393:	83 c3 04             	add    $0x4,%ebx
80100396:	83 c4 10             	add    $0x10,%esp
80100399:	8d 45 f8             	lea    -0x8(%ebp),%eax
8010039c:	39 c3                	cmp    %eax,%ebx
8010039e:	75 e4                	jne    80100384 <panic+0x4c>
  panicked = 1; // freeze other CPU
801003a0:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003a7:	00 00 00 
  for(;;)
801003aa:	eb fe                	jmp    801003aa <panic+0x72>

801003ac <consputc.part.0>:
consputc(int c)
801003ac:	55                   	push   %ebp
801003ad:	89 e5                	mov    %esp,%ebp
801003af:	57                   	push   %edi
801003b0:	56                   	push   %esi
801003b1:	53                   	push   %ebx
801003b2:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
801003b5:	3d 00 01 00 00       	cmp    $0x100,%eax
801003ba:	0f 84 b0 00 00 00    	je     80100470 <consputc.part.0+0xc4>
801003c0:	89 c6                	mov    %eax,%esi
    uartputc(c);
801003c2:	83 ec 0c             	sub    $0xc,%esp
801003c5:	50                   	push   %eax
801003c6:	e8 51 57 00 00       	call   80105b1c <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003cb:	b0 0e                	mov    $0xe,%al
801003cd:	ba d4 03 00 00       	mov    $0x3d4,%edx
801003d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003d8:	89 ca                	mov    %ecx,%edx
801003da:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003db:	0f b6 d8             	movzbl %al,%ebx
801003de:	c1 e3 08             	shl    $0x8,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e1:	b0 0f                	mov    $0xf,%al
801003e3:	ba d4 03 00 00       	mov    $0x3d4,%edx
801003e8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e9:	89 ca                	mov    %ecx,%edx
801003eb:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003ec:	0f b6 c8             	movzbl %al,%ecx
801003ef:	09 d9                	or     %ebx,%ecx
  if(c == '\n')
801003f1:	83 c4 10             	add    $0x10,%esp
801003f4:	83 fe 0a             	cmp    $0xa,%esi
801003f7:	75 5f                	jne    80100458 <consputc.part.0+0xac>
    pos += 80 - pos%80;
801003f9:	bb 50 00 00 00       	mov    $0x50,%ebx
801003fe:	89 c8                	mov    %ecx,%eax
80100400:	99                   	cltd
80100401:	f7 fb                	idiv   %ebx
80100403:	29 d3                	sub    %edx,%ebx
80100405:	01 cb                	add    %ecx,%ebx
  if(pos < 0 || pos > 25*80)
80100407:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010040d:	0f 8f 0b 01 00 00    	jg     8010051e <consputc.part.0+0x172>
  if((pos/80) >= 24){  // Scroll up.
80100413:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100419:	0f 8f a5 00 00 00    	jg     801004c4 <consputc.part.0+0x118>
  outb(CRTPORT+1, pos>>8);
8010041f:	0f b6 f7             	movzbl %bh,%esi
  outb(CRTPORT+1, pos);
80100422:	88 d9                	mov    %bl,%cl
  crt[pos] = ' ' | 0x0700;
80100424:	01 db                	add    %ebx,%ebx
80100426:	81 eb 00 80 f4 7f    	sub    $0x7ff48000,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010042c:	b0 0e                	mov    $0xe,%al
8010042e:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100433:	ee                   	out    %al,(%dx)
80100434:	bf d5 03 00 00       	mov    $0x3d5,%edi
80100439:	89 f0                	mov    %esi,%eax
8010043b:	89 fa                	mov    %edi,%edx
8010043d:	ee                   	out    %al,(%dx)
8010043e:	b0 0f                	mov    $0xf,%al
80100440:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100445:	ee                   	out    %al,(%dx)
80100446:	88 c8                	mov    %cl,%al
80100448:	89 fa                	mov    %edi,%edx
8010044a:	ee                   	out    %al,(%dx)
8010044b:	66 c7 03 20 07       	movw   $0x720,(%ebx)
}
80100450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100453:	5b                   	pop    %ebx
80100454:	5e                   	pop    %esi
80100455:	5f                   	pop    %edi
80100456:	5d                   	pop    %ebp
80100457:	c3                   	ret
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100458:	8d 59 01             	lea    0x1(%ecx),%ebx
8010045b:	89 f0                	mov    %esi,%eax
8010045d:	0f b6 f0             	movzbl %al,%esi
80100460:	81 ce 00 07 00 00    	or     $0x700,%esi
80100466:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
8010046d:	80 
8010046e:	eb 97                	jmp    80100407 <consputc.part.0+0x5b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100470:	83 ec 0c             	sub    $0xc,%esp
80100473:	6a 08                	push   $0x8
80100475:	e8 a2 56 00 00       	call   80105b1c <uartputc>
8010047a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100481:	e8 96 56 00 00       	call   80105b1c <uartputc>
80100486:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010048d:	e8 8a 56 00 00       	call   80105b1c <uartputc>
80100492:	b0 0e                	mov    $0xe,%al
80100494:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100499:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010049a:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010049f:	89 da                	mov    %ebx,%edx
801004a1:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801004a2:	0f b6 c8             	movzbl %al,%ecx
801004a5:	c1 e1 08             	shl    $0x8,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	b0 0f                	mov    $0xf,%al
801004aa:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004b0:	89 da                	mov    %ebx,%edx
801004b2:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801004b3:	0f b6 d8             	movzbl %al,%ebx
    if(pos > 0) --pos;
801004b6:	83 c4 10             	add    $0x10,%esp
801004b9:	09 cb                	or     %ecx,%ebx
801004bb:	74 53                	je     80100510 <consputc.part.0+0x164>
801004bd:	4b                   	dec    %ebx
801004be:	e9 44 ff ff ff       	jmp    80100407 <consputc.part.0+0x5b>
801004c3:	90                   	nop
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004c4:	50                   	push   %eax
801004c5:	68 60 0e 00 00       	push   $0xe60
801004ca:	68 a0 80 0b 80       	push   $0x800b80a0
801004cf:	68 00 80 0b 80       	push   $0x800b8000
801004d4:	e8 77 42 00 00       	call   80104750 <memmove>
    pos -= 80;
801004d9:	8d 73 b0             	lea    -0x50(%ebx),%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004dc:	8d 9c 1b 60 ff ff ff 	lea    -0xa0(%ebx,%ebx,1),%ebx
801004e3:	81 eb 00 80 f4 7f    	sub    $0x7ff48000,%ebx
801004e9:	83 c4 0c             	add    $0xc,%esp
801004ec:	b8 80 07 00 00       	mov    $0x780,%eax
801004f1:	29 f0                	sub    %esi,%eax
801004f3:	01 c0                	add    %eax,%eax
801004f5:	50                   	push   %eax
801004f6:	6a 00                	push   $0x0
801004f8:	53                   	push   %ebx
801004f9:	e8 d6 41 00 00       	call   801046d4 <memset>
  outb(CRTPORT+1, pos);
801004fe:	89 f1                	mov    %esi,%ecx
80100500:	83 c4 10             	add    $0x10,%esp
80100503:	be 07 00 00 00       	mov    $0x7,%esi
80100508:	e9 1f ff ff ff       	jmp    8010042c <consputc.part.0+0x80>
8010050d:	8d 76 00             	lea    0x0(%esi),%esi
80100510:	bb 00 80 0b 80       	mov    $0x800b8000,%ebx
80100515:	31 c9                	xor    %ecx,%ecx
80100517:	31 f6                	xor    %esi,%esi
80100519:	e9 0e ff ff ff       	jmp    8010042c <consputc.part.0+0x80>
    panic("pos under/overflow");
8010051e:	83 ec 0c             	sub    $0xc,%esp
80100521:	68 05 6f 10 80       	push   $0x80106f05
80100526:	e8 0d fe ff ff       	call   80100338 <panic>
8010052b:	90                   	nop

8010052c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010052c:	55                   	push   %ebp
8010052d:	89 e5                	mov    %esp,%ebp
8010052f:	57                   	push   %edi
80100530:	56                   	push   %esi
80100531:	53                   	push   %ebx
80100532:	83 ec 18             	sub    $0x18,%esp
80100535:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
80100538:	ff 75 08             	push   0x8(%ebp)
8010053b:	e8 b0 12 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100540:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100547:	e8 bc 40 00 00       	call   80104608 <acquire>
  for(i = 0; i < n; i++)
8010054c:	83 c4 10             	add    $0x10,%esp
8010054f:	85 f6                	test   %esi,%esi
80100551:	7e 22                	jle    80100575 <consolewrite+0x49>
80100553:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100556:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
80100559:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010055f:	85 d2                	test   %edx,%edx
80100561:	74 05                	je     80100568 <consolewrite+0x3c>
  asm volatile("cli");
80100563:	fa                   	cli
    for(;;)
80100564:	eb fe                	jmp    80100564 <consolewrite+0x38>
80100566:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100568:	0f b6 03             	movzbl (%ebx),%eax
8010056b:	e8 3c fe ff ff       	call   801003ac <consputc.part.0>
  for(i = 0; i < n; i++)
80100570:	43                   	inc    %ebx
80100571:	39 fb                	cmp    %edi,%ebx
80100573:	75 e4                	jne    80100559 <consolewrite+0x2d>
  release(&cons.lock);
80100575:	83 ec 0c             	sub    $0xc,%esp
80100578:	68 20 ef 10 80       	push   $0x8010ef20
8010057d:	e8 26 40 00 00       	call   801045a8 <release>
  ilock(ip);
80100582:	58                   	pop    %eax
80100583:	ff 75 08             	push   0x8(%ebp)
80100586:	e8 9d 11 00 00       	call   80101728 <ilock>

  return n;
}
8010058b:	89 f0                	mov    %esi,%eax
8010058d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100590:	5b                   	pop    %ebx
80100591:	5e                   	pop    %esi
80100592:	5f                   	pop    %edi
80100593:	5d                   	pop    %ebp
80100594:	c3                   	ret
80100595:	8d 76 00             	lea    0x0(%esi),%esi

80100598 <printint>:
{
80100598:	55                   	push   %ebp
80100599:	89 e5                	mov    %esp,%ebp
8010059b:	57                   	push   %edi
8010059c:	56                   	push   %esi
8010059d:	53                   	push   %ebx
8010059e:	83 ec 2c             	sub    $0x2c,%esp
801005a1:	89 c6                	mov    %eax,%esi
801005a3:	89 d3                	mov    %edx,%ebx
  if(sign && (sign = xx < 0))
801005a5:	85 c9                	test   %ecx,%ecx
801005a7:	74 04                	je     801005ad <printint+0x15>
801005a9:	85 c0                	test   %eax,%eax
801005ab:	78 62                	js     8010060f <printint+0x77>
    x = xx;
801005ad:	89 f1                	mov    %esi,%ecx
801005af:	31 c0                	xor    %eax,%eax
  i = 0;
801005b1:	31 f6                	xor    %esi,%esi
801005b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005b6:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
801005b8:	89 c8                	mov    %ecx,%eax
801005ba:	31 d2                	xor    %edx,%edx
801005bc:	f7 f3                	div    %ebx
801005be:	89 f7                	mov    %esi,%edi
801005c0:	8d 76 01             	lea    0x1(%esi),%esi
801005c3:	8a 92 e8 74 10 80    	mov    -0x7fef8b18(%edx),%dl
801005c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
801005cc:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d0:	89 ca                	mov    %ecx,%edx
801005d2:	89 c1                	mov    %eax,%ecx
801005d4:	39 da                	cmp    %ebx,%edx
801005d6:	73 e0                	jae    801005b8 <printint+0x20>
  if(sign)
801005d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801005db:	85 c0                	test   %eax,%eax
801005dd:	74 07                	je     801005e6 <printint+0x4e>
    buf[i++] = '-';
801005df:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
801005e4:	89 f7                	mov    %esi,%edi
  while(--i >= 0)
801005e6:	8d 75 d8             	lea    -0x28(%ebp),%esi
801005e9:	8d 5c 3d d8          	lea    -0x28(%ebp,%edi,1),%ebx
  if(panicked){
801005ed:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801005f2:	85 c0                	test   %eax,%eax
801005f4:	74 06                	je     801005fc <printint+0x64>
801005f6:	fa                   	cli
    for(;;)
801005f7:	eb fe                	jmp    801005f7 <printint+0x5f>
801005f9:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005fc:	0f be 03             	movsbl (%ebx),%eax
801005ff:	e8 a8 fd ff ff       	call   801003ac <consputc.part.0>
  while(--i >= 0)
80100604:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100607:	39 f3                	cmp    %esi,%ebx
80100609:	74 0c                	je     80100617 <printint+0x7f>
8010060b:	89 c3                	mov    %eax,%ebx
8010060d:	eb de                	jmp    801005ed <printint+0x55>
8010060f:	89 c8                	mov    %ecx,%eax
    x = -xx;
80100611:	f7 de                	neg    %esi
80100613:	89 f1                	mov    %esi,%ecx
80100615:	eb 9a                	jmp    801005b1 <printint+0x19>
}
80100617:	83 c4 2c             	add    $0x2c,%esp
8010061a:	5b                   	pop    %ebx
8010061b:	5e                   	pop    %esi
8010061c:	5f                   	pop    %edi
8010061d:	5d                   	pop    %ebp
8010061e:	c3                   	ret
8010061f:	90                   	nop

80100620 <cprintf>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100629:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
8010062f:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
80100632:	85 ff                	test   %edi,%edi
80100634:	0f 85 f6 00 00 00    	jne    80100730 <cprintf+0x110>
  if (fmt == 0)
8010063a:	85 f6                	test   %esi,%esi
8010063c:	0f 84 99 01 00 00    	je     801007db <cprintf+0x1bb>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100642:	0f b6 06             	movzbl (%esi),%eax
80100645:	85 c0                	test   %eax,%eax
80100647:	74 5b                	je     801006a4 <cprintf+0x84>
  argp = (uint*)(void*)(&fmt + 1);
80100649:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064c:	31 db                	xor    %ebx,%ebx
8010064e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80100651:	89 d7                	mov    %edx,%edi
    if(c != '%'){
80100653:	83 f8 25             	cmp    $0x25,%eax
80100656:	75 54                	jne    801006ac <cprintf+0x8c>
    c = fmt[++i] & 0xff;
80100658:	43                   	inc    %ebx
80100659:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
8010065d:	85 c9                	test   %ecx,%ecx
8010065f:	74 38                	je     80100699 <cprintf+0x79>
    switch(c){
80100661:	83 f9 70             	cmp    $0x70,%ecx
80100664:	0f 84 aa 00 00 00    	je     80100714 <cprintf+0xf4>
8010066a:	7f 6c                	jg     801006d8 <cprintf+0xb8>
8010066c:	83 f9 25             	cmp    $0x25,%ecx
8010066f:	74 4b                	je     801006bc <cprintf+0x9c>
80100671:	83 f9 64             	cmp    $0x64,%ecx
80100674:	75 70                	jne    801006e6 <cprintf+0xc6>
      printint(*argp++, 10, 1);
80100676:	8d 47 04             	lea    0x4(%edi),%eax
80100679:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010067c:	8b 07                	mov    (%edi),%eax
8010067e:	b9 01 00 00 00       	mov    $0x1,%ecx
80100683:	ba 0a 00 00 00       	mov    $0xa,%edx
80100688:	e8 0b ff ff ff       	call   80100598 <printint>
8010068d:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100690:	43                   	inc    %ebx
80100691:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100695:	85 c0                	test   %eax,%eax
80100697:	75 ba                	jne    80100653 <cprintf+0x33>
80100699:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010069c:	85 ff                	test   %edi,%edi
8010069e:	0f 85 af 00 00 00    	jne    80100753 <cprintf+0x133>
}
801006a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a7:	5b                   	pop    %ebx
801006a8:	5e                   	pop    %esi
801006a9:	5f                   	pop    %edi
801006aa:	5d                   	pop    %ebp
801006ab:	c3                   	ret
  if(panicked){
801006ac:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801006b2:	85 c9                	test   %ecx,%ecx
801006b4:	74 19                	je     801006cf <cprintf+0xaf>
801006b6:	fa                   	cli
    for(;;)
801006b7:	eb fe                	jmp    801006b7 <cprintf+0x97>
801006b9:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801006bc:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801006c2:	85 c9                	test   %ecx,%ecx
801006c4:	0f 85 fa 00 00 00    	jne    801007c4 <cprintf+0x1a4>
801006ca:	b8 25 00 00 00       	mov    $0x25,%eax
801006cf:	e8 d8 fc ff ff       	call   801003ac <consputc.part.0>
      break;
801006d4:	eb ba                	jmp    80100690 <cprintf+0x70>
801006d6:	66 90                	xchg   %ax,%ax
    switch(c){
801006d8:	83 f9 73             	cmp    $0x73,%ecx
801006db:	0f 84 87 00 00 00    	je     80100768 <cprintf+0x148>
801006e1:	83 f9 78             	cmp    $0x78,%ecx
801006e4:	74 2e                	je     80100714 <cprintf+0xf4>
  if(panicked){
801006e6:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801006ec:	85 d2                	test   %edx,%edx
801006ee:	0f 85 ca 00 00 00    	jne    801007be <cprintf+0x19e>
801006f4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801006f7:	b8 25 00 00 00       	mov    $0x25,%eax
801006fc:	e8 ab fc ff ff       	call   801003ac <consputc.part.0>
80100701:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100706:	85 c0                	test   %eax,%eax
80100708:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010070b:	0f 84 b7 00 00 00    	je     801007c8 <cprintf+0x1a8>
80100711:	fa                   	cli
    for(;;)
80100712:	eb fe                	jmp    80100712 <cprintf+0xf2>
      printint(*argp++, 16, 0);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010071a:	8b 07                	mov    (%edi),%eax
8010071c:	31 c9                	xor    %ecx,%ecx
8010071e:	ba 10 00 00 00       	mov    $0x10,%edx
80100723:	e8 70 fe ff ff       	call   80100598 <printint>
80100728:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
8010072b:	e9 60 ff ff ff       	jmp    80100690 <cprintf+0x70>
    acquire(&cons.lock);
80100730:	83 ec 0c             	sub    $0xc,%esp
80100733:	68 20 ef 10 80       	push   $0x8010ef20
80100738:	e8 cb 3e 00 00       	call   80104608 <acquire>
  if (fmt == 0)
8010073d:	83 c4 10             	add    $0x10,%esp
80100740:	85 f6                	test   %esi,%esi
80100742:	0f 84 93 00 00 00    	je     801007db <cprintf+0x1bb>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100748:	0f b6 06             	movzbl (%esi),%eax
8010074b:	85 c0                	test   %eax,%eax
8010074d:	0f 85 f6 fe ff ff    	jne    80100649 <cprintf+0x29>
    release(&cons.lock);
80100753:	83 ec 0c             	sub    $0xc,%esp
80100756:	68 20 ef 10 80       	push   $0x8010ef20
8010075b:	e8 48 3e 00 00       	call   801045a8 <release>
80100760:	83 c4 10             	add    $0x10,%esp
80100763:	e9 3c ff ff ff       	jmp    801006a4 <cprintf+0x84>
      if((s = (char*)*argp++) == 0)
80100768:	8d 4f 04             	lea    0x4(%edi),%ecx
8010076b:	8b 17                	mov    (%edi),%edx
8010076d:	85 d2                	test   %edx,%edx
8010076f:	74 1b                	je     8010078c <cprintf+0x16c>
80100771:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100773:	0f be 02             	movsbl (%edx),%eax
80100776:	84 c0                	test   %al,%al
80100778:	74 5a                	je     801007d4 <cprintf+0x1b4>
8010077a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010077d:	89 cb                	mov    %ecx,%ebx
  if(panicked){
8010077f:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 1c                	je     801007a5 <cprintf+0x185>
80100789:	fa                   	cli
    for(;;)
8010078a:	eb fe                	jmp    8010078a <cprintf+0x16a>
8010078c:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
80100791:	bf 18 6f 10 80       	mov    $0x80106f18,%edi
80100796:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100799:	89 cb                	mov    %ecx,%ebx
  if(panicked){
8010079b:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801007a1:	85 d2                	test   %edx,%edx
801007a3:	75 e4                	jne    80100789 <cprintf+0x169>
801007a5:	e8 02 fc ff ff       	call   801003ac <consputc.part.0>
      for(; *s; s++)
801007aa:	47                   	inc    %edi
801007ab:	0f be 07             	movsbl (%edi),%eax
801007ae:	84 c0                	test   %al,%al
801007b0:	75 cd                	jne    8010077f <cprintf+0x15f>
      if((s = (char*)*argp++) == 0)
801007b2:	89 d9                	mov    %ebx,%ecx
801007b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801007b7:	89 cf                	mov    %ecx,%edi
801007b9:	e9 d2 fe ff ff       	jmp    80100690 <cprintf+0x70>
801007be:	fa                   	cli
    for(;;)
801007bf:	eb fe                	jmp    801007bf <cprintf+0x19f>
801007c1:	8d 76 00             	lea    0x0(%esi),%esi
801007c4:	fa                   	cli
801007c5:	eb fe                	jmp    801007c5 <cprintf+0x1a5>
801007c7:	90                   	nop
801007c8:	89 c8                	mov    %ecx,%eax
801007ca:	e8 dd fb ff ff       	call   801003ac <consputc.part.0>
      break;
801007cf:	e9 bc fe ff ff       	jmp    80100690 <cprintf+0x70>
      if((s = (char*)*argp++) == 0)
801007d4:	89 cf                	mov    %ecx,%edi
801007d6:	e9 b5 fe ff ff       	jmp    80100690 <cprintf+0x70>
    panic("null fmt");
801007db:	83 ec 0c             	sub    $0xc,%esp
801007de:	68 1f 6f 10 80       	push   $0x80106f1f
801007e3:	e8 50 fb ff ff       	call   80100338 <panic>

801007e8 <consoleintr>:
{
801007e8:	55                   	push   %ebp
801007e9:	89 e5                	mov    %esp,%ebp
801007eb:	57                   	push   %edi
801007ec:	56                   	push   %esi
801007ed:	53                   	push   %ebx
801007ee:	83 ec 28             	sub    $0x28,%esp
801007f1:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801007f4:	68 20 ef 10 80       	push   $0x8010ef20
801007f9:	e8 0a 3e 00 00       	call   80104608 <acquire>
  while((c = getc()) >= 0){
801007fe:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100801:	31 ff                	xor    %edi,%edi
  while((c = getc()) >= 0){
80100803:	ff d6                	call   *%esi
80100805:	85 c0                	test   %eax,%eax
80100807:	0f 88 17 01 00 00    	js     80100924 <consoleintr+0x13c>
    switch(c){
8010080d:	83 f8 15             	cmp    $0x15,%eax
80100810:	0f 8f e6 01 00 00    	jg     801009fc <consoleintr+0x214>
80100816:	83 f8 01             	cmp    $0x1,%eax
80100819:	7e 0d                	jle    80100828 <consoleintr+0x40>
8010081b:	83 f8 15             	cmp    $0x15,%eax
8010081e:	77 08                	ja     80100828 <consoleintr+0x40>
80100820:	ff 24 85 90 74 10 80 	jmp    *-0x7fef8b70(,%eax,4)
80100827:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100828:	85 c0                	test   %eax,%eax
8010082a:	74 d7                	je     80100803 <consoleintr+0x1b>
8010082c:	8b 1d 08 ef 10 80    	mov    0x8010ef08,%ebx
80100832:	89 da                	mov    %ebx,%edx
80100834:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010083a:	83 fa 7f             	cmp    $0x7f,%edx
8010083d:	77 c4                	ja     80100803 <consoleintr+0x1b>
  if(panicked){
8010083f:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100845:	8d 4b 01             	lea    0x1(%ebx),%ecx
80100848:	83 e3 7f             	and    $0x7f,%ebx
8010084b:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100851:	83 f8 0d             	cmp    $0xd,%eax
80100854:	0f 85 62 02 00 00    	jne    80100abc <consoleintr+0x2d4>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085a:	c6 83 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ebx)
  if(panicked){
80100861:	85 d2                	test   %edx,%edx
80100863:	0f 85 42 02 00 00    	jne    80100aab <consoleintr+0x2c3>
80100869:	b8 0a 00 00 00       	mov    $0xa,%eax
8010086e:	e8 39 fb ff ff       	call   801003ac <consputc.part.0>
          input.w = input.e;
80100873:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100879:	e9 e3 01 00 00       	jmp    80100a61 <consoleintr+0x279>
8010087e:	66 90                	xchg   %ax,%ax
      while(input.e != input.w &&
80100880:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100885:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010088b:	0f 84 72 ff ff ff    	je     80100803 <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100891:	48                   	dec    %eax
80100892:	89 c2                	mov    %eax,%edx
80100894:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100897:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010089e:	0f 84 5f ff ff ff    	je     80100803 <consoleintr+0x1b>
        input.e--;
801008a4:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801008a9:	8b 1d 58 ef 10 80    	mov    0x8010ef58,%ebx
801008af:	85 db                	test   %ebx,%ebx
801008b1:	0f 84 c5 01 00 00    	je     80100a7c <consoleintr+0x294>
801008b7:	fa                   	cli
    for(;;)
801008b8:	eb fe                	jmp    801008b8 <consoleintr+0xd0>
801008ba:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
801008bc:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008c1:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801008c7:	0f 84 36 ff ff ff    	je     80100803 <consoleintr+0x1b>
        input.e--;
801008cd:	48                   	dec    %eax
801008ce:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801008d3:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801008d9:	85 c9                	test   %ecx,%ecx
801008db:	0f 84 bb 01 00 00    	je     80100a9c <consoleintr+0x2b4>
801008e1:	fa                   	cli
    for(;;)
801008e2:	eb fe                	jmp    801008e2 <consoleintr+0xfa>
      release(&cons.lock);
801008e4:	83 ec 0c             	sub    $0xc,%esp
801008e7:	68 20 ef 10 80       	push   $0x8010ef20
801008ec:	e8 b7 3c 00 00       	call   801045a8 <release>
      cprintf("Ctrl-G is detected by xv6\n");
801008f1:	c7 04 24 79 6f 10 80 	movl   $0x80106f79,(%esp)
801008f8:	e8 23 fd ff ff       	call   80100620 <cprintf>
      send_signal_to_all(SIGCUSTOM);
801008fd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80100904:	e8 33 37 00 00       	call   8010403c <send_signal_to_all>
      acquire(&cons.lock);
80100909:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100910:	e8 f3 3c 00 00       	call   80104608 <acquire>
      break;
80100915:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100918:	ff d6                	call   *%esi
8010091a:	85 c0                	test   %eax,%eax
8010091c:	0f 89 eb fe ff ff    	jns    8010080d <consoleintr+0x25>
80100922:	66 90                	xchg   %ax,%ax
  release(&cons.lock);
80100924:	83 ec 0c             	sub    $0xc,%esp
80100927:	68 20 ef 10 80       	push   $0x8010ef20
8010092c:	e8 77 3c 00 00       	call   801045a8 <release>
  if(doprocdump) {
80100931:	83 c4 10             	add    $0x10,%esp
80100934:	85 ff                	test   %edi,%edi
80100936:	0f 85 74 01 00 00    	jne    80100ab0 <consoleintr+0x2c8>
}
8010093c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010093f:	5b                   	pop    %ebx
80100940:	5e                   	pop    %esi
80100941:	5f                   	pop    %edi
80100942:	5d                   	pop    %ebp
80100943:	c3                   	ret
      release(&cons.lock);
80100944:	83 ec 0c             	sub    $0xc,%esp
80100947:	68 20 ef 10 80       	push   $0x8010ef20
8010094c:	e8 57 3c 00 00       	call   801045a8 <release>
      cprintf("Ctrl-F is detected by xv6\n");
80100951:	c7 04 24 5e 6f 10 80 	movl   $0x80106f5e,(%esp)
80100958:	e8 c3 fc ff ff       	call   80100620 <cprintf>
      send_signal_to_all(SIGFG);
8010095d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80100964:	e8 d3 36 00 00       	call   8010403c <send_signal_to_all>
      acquire(&cons.lock);
80100969:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100970:	e8 93 3c 00 00       	call   80104608 <acquire>
      break;
80100975:	83 c4 10             	add    $0x10,%esp
80100978:	e9 86 fe ff ff       	jmp    80100803 <consoleintr+0x1b>
      release(&cons.lock);
8010097d:	83 ec 0c             	sub    $0xc,%esp
80100980:	68 20 ef 10 80       	push   $0x8010ef20
80100985:	e8 1e 3c 00 00       	call   801045a8 <release>
      cprintf("Ctrl-C is detected by xv6\n");
8010098a:	c7 04 24 28 6f 10 80 	movl   $0x80106f28,(%esp)
80100991:	e8 8a fc ff ff       	call   80100620 <cprintf>
      send_signal_to_all(SIGINT);
80100996:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010099d:	e8 9a 36 00 00       	call   8010403c <send_signal_to_all>
      acquire(&cons.lock);
801009a2:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801009a9:	e8 5a 3c 00 00       	call   80104608 <acquire>
      break;
801009ae:	83 c4 10             	add    $0x10,%esp
801009b1:	e9 4d fe ff ff       	jmp    80100803 <consoleintr+0x1b>
        release(&cons.lock);
801009b6:	83 ec 0c             	sub    $0xc,%esp
801009b9:	68 20 ef 10 80       	push   $0x8010ef20
801009be:	e8 e5 3b 00 00       	call   801045a8 <release>
        cprintf("Ctrl-B is detected by xv6\n");
801009c3:	c7 04 24 43 6f 10 80 	movl   $0x80106f43,(%esp)
801009ca:	e8 51 fc ff ff       	call   80100620 <cprintf>
        send_signal_to_all(SIGBG);
801009cf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801009d6:	e8 61 36 00 00       	call   8010403c <send_signal_to_all>
        acquire(&cons.lock);
801009db:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801009e2:	e8 21 3c 00 00       	call   80104608 <acquire>
        break;
801009e7:	83 c4 10             	add    $0x10,%esp
801009ea:	e9 14 fe ff ff       	jmp    80100803 <consoleintr+0x1b>
    switch(c){
801009ef:	bf 01 00 00 00       	mov    $0x1,%edi
801009f4:	e9 0a fe ff ff       	jmp    80100803 <consoleintr+0x1b>
801009f9:	8d 76 00             	lea    0x0(%esi),%esi
801009fc:	83 f8 7f             	cmp    $0x7f,%eax
801009ff:	0f 84 b7 fe ff ff    	je     801008bc <consoleintr+0xd4>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a05:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100a0b:	89 ca                	mov    %ecx,%edx
80100a0d:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a13:	83 fa 7f             	cmp    $0x7f,%edx
80100a16:	0f 87 e7 fd ff ff    	ja     80100803 <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a1c:	8d 51 01             	lea    0x1(%ecx),%edx
80100a1f:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a25:	83 e1 7f             	and    $0x7f,%ecx
80100a28:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
80100a2e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100a34:	85 d2                	test   %edx,%edx
80100a36:	75 73                	jne    80100aab <consoleintr+0x2c3>
80100a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100a3b:	e8 6c f9 ff ff       	call   801003ac <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a40:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100a49:	83 f8 04             	cmp    $0x4,%eax
80100a4c:	74 13                	je     80100a61 <consoleintr+0x279>
80100a4e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100a53:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100a59:	39 ca                	cmp    %ecx,%edx
80100a5b:	0f 85 a2 fd ff ff    	jne    80100803 <consoleintr+0x1b>
          input.w = input.e;
80100a61:	89 0d 04 ef 10 80    	mov    %ecx,0x8010ef04
          wakeup(&input.r);
80100a67:	83 ec 0c             	sub    $0xc,%esp
80100a6a:	68 00 ef 10 80       	push   $0x8010ef00
80100a6f:	e8 5c 33 00 00       	call   80103dd0 <wakeup>
80100a74:	83 c4 10             	add    $0x10,%esp
80100a77:	e9 87 fd ff ff       	jmp    80100803 <consoleintr+0x1b>
80100a7c:	b8 00 01 00 00       	mov    $0x100,%eax
80100a81:	e8 26 f9 ff ff       	call   801003ac <consputc.part.0>
      while(input.e != input.w &&
80100a86:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a8b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a91:	0f 85 fa fd ff ff    	jne    80100891 <consoleintr+0xa9>
80100a97:	e9 67 fd ff ff       	jmp    80100803 <consoleintr+0x1b>
80100a9c:	b8 00 01 00 00       	mov    $0x100,%eax
80100aa1:	e8 06 f9 ff ff       	call   801003ac <consputc.part.0>
80100aa6:	e9 58 fd ff ff       	jmp    80100803 <consoleintr+0x1b>
80100aab:	fa                   	cli
    for(;;)
80100aac:	eb fe                	jmp    80100aac <consoleintr+0x2c4>
80100aae:	66 90                	xchg   %ax,%ax
}
80100ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ab3:	5b                   	pop    %ebx
80100ab4:	5e                   	pop    %esi
80100ab5:	5f                   	pop    %edi
80100ab6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100ab7:	e9 f0 33 00 00       	jmp    80103eac <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100abc:	88 83 80 ee 10 80    	mov    %al,-0x7fef1180(%ebx)
  if(panicked){
80100ac2:	85 d2                	test   %edx,%edx
80100ac4:	75 e5                	jne    80100aab <consoleintr+0x2c3>
80100ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ac9:	e8 de f8 ff ff       	call   801003ac <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100ace:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ad7:	83 f8 0a             	cmp    $0xa,%eax
80100ada:	0f 85 69 ff ff ff    	jne    80100a49 <consoleintr+0x261>
80100ae0:	e9 7c ff ff ff       	jmp    80100a61 <consoleintr+0x279>
80100ae5:	8d 76 00             	lea    0x0(%esi),%esi

80100ae8 <consoleinit>:

void
consoleinit(void)
{
80100ae8:	55                   	push   %ebp
80100ae9:	89 e5                	mov    %esp,%ebp
80100aeb:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100aee:	68 94 6f 10 80       	push   $0x80106f94
80100af3:	68 20 ef 10 80       	push   $0x8010ef20
80100af8:	e8 43 39 00 00       	call   80104440 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100afd:	c7 05 0c f9 10 80 2c 	movl   $0x8010052c,0x8010f90c
80100b04:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100b07:	c7 05 08 f9 10 80 48 	movl   $0x80100248,0x8010f908
80100b0e:	02 10 80 
  cons.locking = 1;
80100b11:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100b18:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b1b:	58                   	pop    %eax
80100b1c:	5a                   	pop    %edx
80100b1d:	6a 00                	push   $0x0
80100b1f:	6a 01                	push   $0x1
80100b21:	e8 b2 17 00 00       	call   801022d8 <ioapicenable>
}
80100b26:	83 c4 10             	add    $0x10,%esp
80100b29:	c9                   	leave
80100b2a:	c3                   	ret
80100b2b:	90                   	nop

80100b2c <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b2c:	55                   	push   %ebp
80100b2d:	89 e5                	mov    %esp,%ebp
80100b2f:	57                   	push   %edi
80100b30:	56                   	push   %esi
80100b31:	53                   	push   %ebx
80100b32:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b38:	e8 cb 2a 00 00       	call   80103608 <myproc>
80100b3d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b43:	e8 7c 1f 00 00       	call   80102ac4 <begin_op>

  if((ip = namei(path)) == 0){
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	ff 75 08             	push   0x8(%ebp)
80100b4e:	e8 29 14 00 00       	call   80101f7c <namei>
80100b53:	83 c4 10             	add    $0x10,%esp
80100b56:	85 c0                	test   %eax,%eax
80100b58:	0f 84 13 03 00 00    	je     80100e71 <exec+0x345>
80100b5e:	89 c7                	mov    %eax,%edi
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b60:	83 ec 0c             	sub    $0xc,%esp
80100b63:	50                   	push   %eax
80100b64:	e8 bf 0b 00 00       	call   80101728 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b69:	6a 34                	push   $0x34
80100b6b:	6a 00                	push   $0x0
80100b6d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b73:	50                   	push   %eax
80100b74:	57                   	push   %edi
80100b75:	e8 7e 0e 00 00       	call   801019f8 <readi>
80100b7a:	83 c4 20             	add    $0x20,%esp
80100b7d:	83 f8 34             	cmp    $0x34,%eax
80100b80:	0f 85 f9 00 00 00    	jne    80100c7f <exec+0x153>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b86:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b8d:	45 4c 46 
80100b90:	0f 85 e9 00 00 00    	jne    80100c7f <exec+0x153>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b96:	e8 3d 60 00 00       	call   80106bd8 <setupkvm>
80100b9b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	0f 84 d6 00 00 00    	je     80100c7f <exec+0x153>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba9:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100baf:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bb6:	00 
80100bb7:	0f 84 84 02 00 00    	je     80100e41 <exec+0x315>
  sz = 0;
80100bbd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100bc4:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc7:	31 db                	xor    %ebx,%ebx
80100bc9:	e9 84 00 00 00       	jmp    80100c52 <exec+0x126>
80100bce:	66 90                	xchg   %ax,%ax
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bd0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bd7:	75 6a                	jne    80100c43 <exec+0x117>
      continue;
    if(ph.memsz < ph.filesz)
80100bd9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bdf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100be5:	0f 82 83 00 00 00    	jb     80100c6e <exec+0x142>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100beb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bf1:	72 7b                	jb     80100c6e <exec+0x142>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf3:	51                   	push   %ecx
80100bf4:	50                   	push   %eax
80100bf5:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bfb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c01:	e8 3e 5e 00 00       	call   80106a44 <allocuvm>
80100c06:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c0c:	83 c4 10             	add    $0x10,%esp
80100c0f:	85 c0                	test   %eax,%eax
80100c11:	74 5b                	je     80100c6e <exec+0x142>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100c13:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c19:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c1e:	75 4e                	jne    80100c6e <exec+0x142>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c20:	83 ec 0c             	sub    $0xc,%esp
80100c23:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c29:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c2f:	57                   	push   %edi
80100c30:	50                   	push   %eax
80100c31:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c37:	e8 44 5d 00 00       	call   80106980 <loaduvm>
80100c3c:	83 c4 20             	add    $0x20,%esp
80100c3f:	85 c0                	test   %eax,%eax
80100c41:	78 2b                	js     80100c6e <exec+0x142>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c43:	43                   	inc    %ebx
80100c44:	83 c6 20             	add    $0x20,%esi
80100c47:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c4e:	39 d8                	cmp    %ebx,%eax
80100c50:	7e 4e                	jle    80100ca0 <exec+0x174>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c52:	6a 20                	push   $0x20
80100c54:	56                   	push   %esi
80100c55:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c5b:	50                   	push   %eax
80100c5c:	57                   	push   %edi
80100c5d:	e8 96 0d 00 00       	call   801019f8 <readi>
80100c62:	83 c4 10             	add    $0x10,%esp
80100c65:	83 f8 20             	cmp    $0x20,%eax
80100c68:	0f 84 62 ff ff ff    	je     80100bd0 <exec+0xa4>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c6e:	83 ec 0c             	sub    $0xc,%esp
80100c71:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c77:	e8 ec 5e 00 00       	call   80106b68 <freevm>
  if(ip){
80100c7c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c7f:	83 ec 0c             	sub    $0xc,%esp
80100c82:	57                   	push   %edi
80100c83:	e8 f4 0c 00 00       	call   8010197c <iunlockput>
    end_op();
80100c88:	e8 9f 1e 00 00       	call   80102b2c <end_op>
80100c8d:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c98:	5b                   	pop    %ebx
80100c99:	5e                   	pop    %esi
80100c9a:	5f                   	pop    %edi
80100c9b:	5d                   	pop    %ebp
80100c9c:	c3                   	ret
80100c9d:	8d 76 00             	lea    0x0(%esi),%esi
  sz = PGROUNDUP(sz);
80100ca0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100ca6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100cac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 4*PGSIZE)) == 0)
80100cb2:	8d 9e 00 40 00 00    	lea    0x4000(%esi),%ebx
  iunlockput(ip);
80100cb8:	83 ec 0c             	sub    $0xc,%esp
80100cbb:	57                   	push   %edi
80100cbc:	e8 bb 0c 00 00       	call   8010197c <iunlockput>
  end_op();
80100cc1:	e8 66 1e 00 00       	call   80102b2c <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 4*PGSIZE)) == 0)
80100cc6:	83 c4 0c             	add    $0xc,%esp
80100cc9:	53                   	push   %ebx
80100cca:	56                   	push   %esi
80100ccb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cd1:	56                   	push   %esi
80100cd2:	e8 6d 5d 00 00       	call   80106a44 <allocuvm>
80100cd7:	89 c7                	mov    %eax,%edi
80100cd9:	83 c4 10             	add    $0x10,%esp
80100cdc:	85 c0                	test   %eax,%eax
80100cde:	74 7e                	je     80100d5e <exec+0x232>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce0:	83 ec 08             	sub    $0x8,%esp
80100ce3:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ce9:	50                   	push   %eax
80100cea:	56                   	push   %esi
80100ceb:	e8 74 5f 00 00       	call   80106c64 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	8b 10                	mov    (%eax),%edx
80100cf5:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100cf8:	89 fb                	mov    %edi,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100cfa:	85 d2                	test   %edx,%edx
80100cfc:	0f 84 4b 01 00 00    	je     80100e4d <exec+0x321>
80100d02:	31 f6                	xor    %esi,%esi
80100d04:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100d0a:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d0d:	eb 1f                	jmp    80100d2e <exec+0x202>
80100d0f:	90                   	nop
    ustack[3+argc] = sp;
80100d10:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d16:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d1d:	8d 46 01             	lea    0x1(%esi),%eax
80100d20:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d23:	85 d2                	test   %edx,%edx
80100d25:	74 4d                	je     80100d74 <exec+0x248>
    if(argc >= MAXARG)
80100d27:	83 f8 20             	cmp    $0x20,%eax
80100d2a:	74 32                	je     80100d5e <exec+0x232>
80100d2c:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d2e:	83 ec 0c             	sub    $0xc,%esp
80100d31:	52                   	push   %edx
80100d32:	e8 19 3b 00 00       	call   80104850 <strlen>
80100d37:	29 c3                	sub    %eax,%ebx
80100d39:	4b                   	dec    %ebx
80100d3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3d:	5a                   	pop    %edx
80100d3e:	ff 34 b7             	push   (%edi,%esi,4)
80100d41:	e8 0a 3b 00 00       	call   80104850 <strlen>
80100d46:	40                   	inc    %eax
80100d47:	50                   	push   %eax
80100d48:	ff 34 b7             	push   (%edi,%esi,4)
80100d4b:	53                   	push   %ebx
80100d4c:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d52:	e8 a5 60 00 00       	call   80106dfc <copyout>
80100d57:	83 c4 20             	add    $0x20,%esp
80100d5a:	85 c0                	test   %eax,%eax
80100d5c:	79 b2                	jns    80100d10 <exec+0x1e4>
    freevm(pgdir);
80100d5e:	83 ec 0c             	sub    $0xc,%esp
80100d61:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d67:	e8 fc 5d 00 00       	call   80106b68 <freevm>
80100d6c:	83 c4 10             	add    $0x10,%esp
80100d6f:	e9 1c ff ff ff       	jmp    80100c90 <exec+0x164>
  ustack[3+argc] = 0;
80100d74:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d7a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d80:	8d 46 04             	lea    0x4(%esi),%eax
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d83:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  sp -= (3+argc+1) * 4;
80100d8a:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d8d:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d94:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d98:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d9f:	ff ff ff 
  ustack[1] = argc;
80100da2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100da8:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dae:	89 d8                	mov    %ebx,%eax
80100db0:	29 d0                	sub    %edx,%eax
80100db2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100db8:	29 f3                	sub    %esi,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dba:	56                   	push   %esi
80100dbb:	51                   	push   %ecx
80100dbc:	53                   	push   %ebx
80100dbd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dc3:	e8 34 60 00 00       	call   80106dfc <copyout>
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	85 c0                	test   %eax,%eax
80100dcd:	78 8f                	js     80100d5e <exec+0x232>
  for(last=s=path; *s; s++)
80100dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80100dd2:	8a 00                	mov    (%eax),%al
80100dd4:	8b 55 08             	mov    0x8(%ebp),%edx
80100dd7:	84 c0                	test   %al,%al
80100dd9:	74 12                	je     80100ded <exec+0x2c1>
80100ddb:	89 d1                	mov    %edx,%ecx
80100ddd:	8d 76 00             	lea    0x0(%esi),%esi
      last = s+1;
80100de0:	41                   	inc    %ecx
    if(*s == '/')
80100de1:	3c 2f                	cmp    $0x2f,%al
80100de3:	75 02                	jne    80100de7 <exec+0x2bb>
      last = s+1;
80100de5:	89 ca                	mov    %ecx,%edx
  for(last=s=path; *s; s++)
80100de7:	8a 01                	mov    (%ecx),%al
80100de9:	84 c0                	test   %al,%al
80100deb:	75 f3                	jne    80100de0 <exec+0x2b4>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ded:	50                   	push   %eax
80100dee:	6a 10                	push   $0x10
80100df0:	52                   	push   %edx
80100df1:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100df7:	8d 86 b8 00 00 00    	lea    0xb8(%esi),%eax
80100dfd:	50                   	push   %eax
80100dfe:	e8 19 3a 00 00       	call   8010481c <safestrcpy>
  oldpgdir = curproc->pgdir;
80100e03:	89 f0                	mov    %esi,%eax
80100e05:	8b 76 50             	mov    0x50(%esi),%esi
  curproc->pgdir = pgdir;
80100e08:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100e0e:	89 48 50             	mov    %ecx,0x50(%eax)
  curproc->sz = sz;
80100e11:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e13:	89 c1                	mov    %eax,%ecx
80100e15:	8b 40 64             	mov    0x64(%eax),%eax
80100e18:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e1e:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e21:	8b 41 64             	mov    0x64(%ecx),%eax
80100e24:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e27:	89 0c 24             	mov    %ecx,(%esp)
80100e2a:	e8 e1 59 00 00       	call   80106810 <switchuvm>
  freevm(oldpgdir);
80100e2f:	89 34 24             	mov    %esi,(%esp)
80100e32:	e8 31 5d 00 00       	call   80106b68 <freevm>
  return 0;
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	31 c0                	xor    %eax,%eax
80100e3c:	e9 54 fe ff ff       	jmp    80100c95 <exec+0x169>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e41:	bb 00 40 00 00       	mov    $0x4000,%ebx
80100e46:	31 f6                	xor    %esi,%esi
80100e48:	e9 6b fe ff ff       	jmp    80100cb8 <exec+0x18c>
  for(argc = 0; argv[argc]; argc++) {
80100e4d:	be 10 00 00 00       	mov    $0x10,%esi
80100e52:	ba 04 00 00 00       	mov    $0x4,%edx
80100e57:	b8 03 00 00 00       	mov    $0x3,%eax
80100e5c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e63:	00 00 00 
80100e66:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e6c:	e9 1c ff ff ff       	jmp    80100d8d <exec+0x261>
    end_op();
80100e71:	e8 b6 1c 00 00       	call   80102b2c <end_op>
    cprintf("exec: fail\n");
80100e76:	83 ec 0c             	sub    $0xc,%esp
80100e79:	68 9c 6f 10 80       	push   $0x80106f9c
80100e7e:	e8 9d f7 ff ff       	call   80100620 <cprintf>
    return -1;
80100e83:	83 c4 10             	add    $0x10,%esp
80100e86:	e9 05 fe ff ff       	jmp    80100c90 <exec+0x164>
80100e8b:	90                   	nop

80100e8c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e8c:	55                   	push   %ebp
80100e8d:	89 e5                	mov    %esp,%ebp
80100e8f:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e92:	68 a8 6f 10 80       	push   $0x80106fa8
80100e97:	68 60 ef 10 80       	push   $0x8010ef60
80100e9c:	e8 9f 35 00 00       	call   80104440 <initlock>
}
80100ea1:	83 c4 10             	add    $0x10,%esp
80100ea4:	c9                   	leave
80100ea5:	c3                   	ret
80100ea6:	66 90                	xchg   %ax,%ax

80100ea8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea8:	55                   	push   %ebp
80100ea9:	89 e5                	mov    %esp,%ebp
80100eab:	53                   	push   %ebx
80100eac:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100eaf:	68 60 ef 10 80       	push   $0x8010ef60
80100eb4:	e8 4f 37 00 00       	call   80104608 <acquire>
80100eb9:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ebc:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100ec1:	eb 0c                	jmp    80100ecf <filealloc+0x27>
80100ec3:	90                   	nop
80100ec4:	83 c3 18             	add    $0x18,%ebx
80100ec7:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ecd:	74 25                	je     80100ef4 <filealloc+0x4c>
    if(f->ref == 0){
80100ecf:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed2:	85 c0                	test   %eax,%eax
80100ed4:	75 ee                	jne    80100ec4 <filealloc+0x1c>
      f->ref = 1;
80100ed6:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edd:	83 ec 0c             	sub    $0xc,%esp
80100ee0:	68 60 ef 10 80       	push   $0x8010ef60
80100ee5:	e8 be 36 00 00       	call   801045a8 <release>
      return f;
80100eea:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100eed:	89 d8                	mov    %ebx,%eax
80100eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef2:	c9                   	leave
80100ef3:	c3                   	ret
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
80100ef7:	68 60 ef 10 80       	push   $0x8010ef60
80100efc:	e8 a7 36 00 00       	call   801045a8 <release>
  return 0;
80100f01:	83 c4 10             	add    $0x10,%esp
80100f04:	31 db                	xor    %ebx,%ebx
}
80100f06:	89 d8                	mov    %ebx,%eax
80100f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0b:	c9                   	leave
80100f0c:	c3                   	ret
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 60 ef 10 80       	push   $0x8010ef60
80100f1f:	e8 e4 36 00 00       	call   80104608 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 18                	jle    80100f46 <filedup+0x36>
    panic("filedup");
  f->ref++;
80100f2e:	40                   	inc    %eax
80100f2f:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f32:	83 ec 0c             	sub    $0xc,%esp
80100f35:	68 60 ef 10 80       	push   $0x8010ef60
80100f3a:	e8 69 36 00 00       	call   801045a8 <release>
  return f;
}
80100f3f:	89 d8                	mov    %ebx,%eax
80100f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f44:	c9                   	leave
80100f45:	c3                   	ret
    panic("filedup");
80100f46:	83 ec 0c             	sub    $0xc,%esp
80100f49:	68 af 6f 10 80       	push   $0x80106faf
80100f4e:	e8 e5 f3 ff ff       	call   80100338 <panic>
80100f53:	90                   	nop

80100f54 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f54:	55                   	push   %ebp
80100f55:	89 e5                	mov    %esp,%ebp
80100f57:	57                   	push   %edi
80100f58:	56                   	push   %esi
80100f59:	53                   	push   %ebx
80100f5a:	83 ec 28             	sub    $0x28,%esp
80100f5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100f60:	68 60 ef 10 80       	push   $0x8010ef60
80100f65:	e8 9e 36 00 00       	call   80104608 <acquire>
  if(f->ref < 1)
80100f6a:	8b 57 04             	mov    0x4(%edi),%edx
80100f6d:	83 c4 10             	add    $0x10,%esp
80100f70:	85 d2                	test   %edx,%edx
80100f72:	0f 8e 8d 00 00 00    	jle    80101005 <fileclose+0xb1>
    panic("fileclose");
  if(--f->ref > 0){
80100f78:	4a                   	dec    %edx
80100f79:	89 57 04             	mov    %edx,0x4(%edi)
80100f7c:	75 3a                	jne    80100fb8 <fileclose+0x64>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f7e:	8b 1f                	mov    (%edi),%ebx
80100f80:	8a 47 09             	mov    0x9(%edi),%al
80100f83:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f86:	8b 77 0c             	mov    0xc(%edi),%esi
80100f89:	8b 47 10             	mov    0x10(%edi),%eax
80100f8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
80100f8f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	68 60 ef 10 80       	push   $0x8010ef60
80100f9d:	e8 06 36 00 00       	call   801045a8 <release>

  if(ff.type == FD_PIPE)
80100fa2:	83 c4 10             	add    $0x10,%esp
80100fa5:	83 fb 01             	cmp    $0x1,%ebx
80100fa8:	74 42                	je     80100fec <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100faa:	83 fb 02             	cmp    $0x2,%ebx
80100fad:	74 1d                	je     80100fcc <fileclose+0x78>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb2:	5b                   	pop    %ebx
80100fb3:	5e                   	pop    %esi
80100fb4:	5f                   	pop    %edi
80100fb5:	5d                   	pop    %ebp
80100fb6:	c3                   	ret
80100fb7:	90                   	nop
    release(&ftable.lock);
80100fb8:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc2:	5b                   	pop    %ebx
80100fc3:	5e                   	pop    %esi
80100fc4:	5f                   	pop    %edi
80100fc5:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fc6:	e9 dd 35 00 00       	jmp    801045a8 <release>
80100fcb:	90                   	nop
    begin_op();
80100fcc:	e8 f3 1a 00 00       	call   80102ac4 <begin_op>
    iput(ff.ip);
80100fd1:	83 ec 0c             	sub    $0xc,%esp
80100fd4:	ff 75 e0             	push   -0x20(%ebp)
80100fd7:	e8 58 08 00 00       	call   80101834 <iput>
    end_op();
80100fdc:	83 c4 10             	add    $0x10,%esp
}
80100fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe2:	5b                   	pop    %ebx
80100fe3:	5e                   	pop    %esi
80100fe4:	5f                   	pop    %edi
80100fe5:	5d                   	pop    %ebp
    end_op();
80100fe6:	e9 41 1b 00 00       	jmp    80102b2c <end_op>
80100feb:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fec:	83 ec 08             	sub    $0x8,%esp
80100fef:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100ff3:	50                   	push   %eax
80100ff4:	56                   	push   %esi
80100ff5:	e8 ca 21 00 00       	call   801031c4 <pipeclose>
80100ffa:	83 c4 10             	add    $0x10,%esp
}
80100ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101000:	5b                   	pop    %ebx
80101001:	5e                   	pop    %esi
80101002:	5f                   	pop    %edi
80101003:	5d                   	pop    %ebp
80101004:	c3                   	ret
    panic("fileclose");
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	68 b7 6f 10 80       	push   $0x80106fb7
8010100d:	e8 26 f3 ff ff       	call   80100338 <panic>
80101012:	66 90                	xchg   %ax,%ax

80101014 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101014:	55                   	push   %ebp
80101015:	89 e5                	mov    %esp,%ebp
80101017:	53                   	push   %ebx
80101018:	53                   	push   %ebx
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010101c:	83 3b 02             	cmpl   $0x2,(%ebx)
8010101f:	75 2b                	jne    8010104c <filestat+0x38>
    ilock(f->ip);
80101021:	83 ec 0c             	sub    $0xc,%esp
80101024:	ff 73 10             	push   0x10(%ebx)
80101027:	e8 fc 06 00 00       	call   80101728 <ilock>
    stati(f->ip, st);
8010102c:	58                   	pop    %eax
8010102d:	5a                   	pop    %edx
8010102e:	ff 75 0c             	push   0xc(%ebp)
80101031:	ff 73 10             	push   0x10(%ebx)
80101034:	e8 93 09 00 00       	call   801019cc <stati>
    iunlock(f->ip);
80101039:	59                   	pop    %ecx
8010103a:	ff 73 10             	push   0x10(%ebx)
8010103d:	e8 ae 07 00 00       	call   801017f0 <iunlock>
    return 0;
80101042:	83 c4 10             	add    $0x10,%esp
80101045:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010104a:	c9                   	leave
8010104b:	c3                   	ret
  return -1;
8010104c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101054:	c9                   	leave
80101055:	c3                   	ret
80101056:	66 90                	xchg   %ax,%ax

80101058 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101058:	55                   	push   %ebp
80101059:	89 e5                	mov    %esp,%ebp
8010105b:	57                   	push   %edi
8010105c:	56                   	push   %esi
8010105d:	53                   	push   %ebx
8010105e:	83 ec 1c             	sub    $0x1c,%esp
80101061:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101064:	8b 75 0c             	mov    0xc(%ebp),%esi
80101067:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
8010106a:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010106e:	74 60                	je     801010d0 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101070:	8b 03                	mov    (%ebx),%eax
80101072:	83 f8 01             	cmp    $0x1,%eax
80101075:	74 45                	je     801010bc <fileread+0x64>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101077:	83 f8 02             	cmp    $0x2,%eax
8010107a:	75 5b                	jne    801010d7 <fileread+0x7f>
    ilock(f->ip);
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	ff 73 10             	push   0x10(%ebx)
80101082:	e8 a1 06 00 00       	call   80101728 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101087:	57                   	push   %edi
80101088:	ff 73 14             	push   0x14(%ebx)
8010108b:	56                   	push   %esi
8010108c:	ff 73 10             	push   0x10(%ebx)
8010108f:	e8 64 09 00 00       	call   801019f8 <readi>
80101094:	83 c4 20             	add    $0x20,%esp
80101097:	85 c0                	test   %eax,%eax
80101099:	7e 03                	jle    8010109e <fileread+0x46>
      f->off += r;
8010109b:	01 43 14             	add    %eax,0x14(%ebx)
8010109e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iunlock(f->ip);
801010a1:	83 ec 0c             	sub    $0xc,%esp
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 44 07 00 00       	call   801017f0 <iunlock>
    return r;
801010ac:	83 c4 10             	add    $0x10,%esp
801010af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
801010b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b5:	5b                   	pop    %ebx
801010b6:	5e                   	pop    %esi
801010b7:	5f                   	pop    %edi
801010b8:	5d                   	pop    %ebp
801010b9:	c3                   	ret
801010ba:	66 90                	xchg   %ax,%ax
    return piperead(f->pipe, addr, n);
801010bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801010bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c5:	5b                   	pop    %ebx
801010c6:	5e                   	pop    %esi
801010c7:	5f                   	pop    %edi
801010c8:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010c9:	e9 96 22 00 00       	jmp    80103364 <piperead>
801010ce:	66 90                	xchg   %ax,%ax
    return -1;
801010d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010d5:	eb db                	jmp    801010b2 <fileread+0x5a>
  panic("fileread");
801010d7:	83 ec 0c             	sub    $0xc,%esp
801010da:	68 c1 6f 10 80       	push   $0x80106fc1
801010df:	e8 54 f2 ff ff       	call   80100338 <panic>

801010e4 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	57                   	push   %edi
801010e8:	56                   	push   %esi
801010e9:	53                   	push   %ebx
801010ea:	83 ec 1c             	sub    $0x1c,%esp
801010ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801010f3:	8b 45 10             	mov    0x10(%ebp),%eax
801010f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
801010f9:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
801010fd:	0f 84 ba 00 00 00    	je     801011bd <filewrite+0xd9>
    return -1;
  if(f->type == FD_PIPE)
80101103:	8b 07                	mov    (%edi),%eax
80101105:	83 f8 01             	cmp    $0x1,%eax
80101108:	0f 84 be 00 00 00    	je     801011cc <filewrite+0xe8>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010110e:	83 f8 02             	cmp    $0x2,%eax
80101111:	0f 85 c7 00 00 00    	jne    801011de <filewrite+0xfa>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80101117:	31 db                	xor    %ebx,%ebx
    while(i < n){
80101119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010111c:	85 c0                	test   %eax,%eax
8010111e:	0f 8e 94 00 00 00    	jle    801011b8 <filewrite+0xd4>
    int i = 0;
80101124:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101127:	eb 28                	jmp    80101151 <filewrite+0x6d>
80101129:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010112c:	01 47 14             	add    %eax,0x14(%edi)
8010112f:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	51                   	push   %ecx
80101136:	e8 b5 06 00 00       	call   801017f0 <iunlock>
      end_op();
8010113b:	e8 ec 19 00 00       	call   80102b2c <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101140:	83 c4 10             	add    $0x10,%esp
80101143:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101146:	39 f0                	cmp    %esi,%eax
80101148:	75 60                	jne    801011aa <filewrite+0xc6>
        panic("short filewrite");
      i += r;
8010114a:	01 f3                	add    %esi,%ebx
    while(i < n){
8010114c:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010114f:	7e 67                	jle    801011b8 <filewrite+0xd4>
      int n1 = n - i;
80101151:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101154:	29 de                	sub    %ebx,%esi
      if(n1 > max)
80101156:	81 fe 00 06 00 00    	cmp    $0x600,%esi
8010115c:	7e 05                	jle    80101163 <filewrite+0x7f>
8010115e:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
80101163:	e8 5c 19 00 00       	call   80102ac4 <begin_op>
      ilock(f->ip);
80101168:	83 ec 0c             	sub    $0xc,%esp
8010116b:	ff 77 10             	push   0x10(%edi)
8010116e:	e8 b5 05 00 00       	call   80101728 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101173:	56                   	push   %esi
80101174:	ff 77 14             	push   0x14(%edi)
80101177:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010117a:	01 d8                	add    %ebx,%eax
8010117c:	50                   	push   %eax
8010117d:	ff 77 10             	push   0x10(%edi)
80101180:	e8 73 09 00 00       	call   80101af8 <writei>
      iunlock(f->ip);
80101185:	8b 4f 10             	mov    0x10(%edi),%ecx
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101188:	83 c4 20             	add    $0x20,%esp
8010118b:	85 c0                	test   %eax,%eax
8010118d:	7f 9d                	jg     8010112c <filewrite+0x48>
      iunlock(f->ip);
8010118f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	51                   	push   %ecx
80101196:	e8 55 06 00 00       	call   801017f0 <iunlock>
      end_op();
8010119b:	e8 8c 19 00 00       	call   80102b2c <end_op>
      if(r < 0)
801011a0:	83 c4 10             	add    $0x10,%esp
801011a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a6:	85 c0                	test   %eax,%eax
801011a8:	75 0e                	jne    801011b8 <filewrite+0xd4>
        panic("short filewrite");
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	68 ca 6f 10 80       	push   $0x80106fca
801011b2:	e8 81 f1 ff ff       	call   80100338 <panic>
801011b7:	90                   	nop
    }
    return i == n ? n : -1;
801011b8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801011bb:	74 05                	je     801011c2 <filewrite+0xde>
    return -1;
801011bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  panic("filewrite");
}
801011c2:	89 d8                	mov    %ebx,%eax
801011c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c7:	5b                   	pop    %ebx
801011c8:	5e                   	pop    %esi
801011c9:	5f                   	pop    %edi
801011ca:	5d                   	pop    %ebp
801011cb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011cc:	8b 47 0c             	mov    0xc(%edi),%eax
801011cf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d5:	5b                   	pop    %ebx
801011d6:	5e                   	pop    %esi
801011d7:	5f                   	pop    %edi
801011d8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011d9:	e9 7e 20 00 00       	jmp    8010325c <pipewrite>
  panic("filewrite");
801011de:	83 ec 0c             	sub    $0xc,%esp
801011e1:	68 d0 6f 10 80       	push   $0x80106fd0
801011e6:	e8 4d f1 ff ff       	call   80100338 <panic>
801011eb:	90                   	nop

801011ec <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011ec:	55                   	push   %ebp
801011ed:	89 e5                	mov    %esp,%ebp
801011ef:	57                   	push   %edi
801011f0:	56                   	push   %esi
801011f1:	53                   	push   %ebx
801011f2:	83 ec 1c             	sub    $0x1c,%esp
801011f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011f8:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
801011fe:	85 c9                	test   %ecx,%ecx
80101200:	74 7f                	je     80101281 <balloc+0x95>
80101202:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	89 f8                	mov    %edi,%eax
80101209:	c1 f8 0c             	sar    $0xc,%eax
8010120c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101212:	50                   	push   %eax
80101213:	ff 75 dc             	push   -0x24(%ebp)
80101216:	e8 99 ee ff ff       	call   801000b4 <bread>
8010121b:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121d:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101222:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101225:	89 fe                	mov    %edi,%esi
80101227:	83 c4 10             	add    $0x10,%esp
8010122a:	31 c0                	xor    %eax,%eax
8010122c:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010122f:	eb 2c                	jmp    8010125d <balloc+0x71>
80101231:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101234:	89 c1                	mov    %eax,%ecx
80101236:	83 e1 07             	and    $0x7,%ecx
80101239:	ba 01 00 00 00       	mov    $0x1,%edx
8010123e:	d3 e2                	shl    %cl,%edx
80101240:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101243:	89 c1                	mov    %eax,%ecx
80101245:	c1 f9 03             	sar    $0x3,%ecx
80101248:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
8010124d:	89 fa                	mov    %edi,%edx
8010124f:	85 7d e4             	test   %edi,-0x1c(%ebp)
80101252:	74 3c                	je     80101290 <balloc+0xa4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101254:	40                   	inc    %eax
80101255:	46                   	inc    %esi
80101256:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125b:	74 07                	je     80101264 <balloc+0x78>
8010125d:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101260:	39 fe                	cmp    %edi,%esi
80101262:	72 d0                	jb     80101234 <balloc+0x48>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101264:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101267:	83 ec 0c             	sub    $0xc,%esp
8010126a:	53                   	push   %ebx
8010126b:	e8 4c ef ff ff       	call   801001bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101270:	81 c7 00 10 00 00    	add    $0x1000,%edi
80101276:	83 c4 10             	add    $0x10,%esp
80101279:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
8010127f:	72 83                	jb     80101204 <balloc+0x18>
  }
  panic("balloc: out of blocks");
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	68 da 6f 10 80       	push   $0x80106fda
80101289:	e8 aa f0 ff ff       	call   80100338 <panic>
8010128e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101290:	0b 55 e4             	or     -0x1c(%ebp),%edx
80101293:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
80101297:	83 ec 0c             	sub    $0xc,%esp
8010129a:	53                   	push   %ebx
8010129b:	e8 e0 19 00 00       	call   80102c80 <log_write>
        brelse(bp);
801012a0:	89 1c 24             	mov    %ebx,(%esp)
801012a3:	e8 14 ef ff ff       	call   801001bc <brelse>
  bp = bread(dev, bno);
801012a8:	58                   	pop    %eax
801012a9:	5a                   	pop    %edx
801012aa:	56                   	push   %esi
801012ab:	ff 75 dc             	push   -0x24(%ebp)
801012ae:	e8 01 ee ff ff       	call   801000b4 <bread>
801012b3:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012b5:	83 c4 0c             	add    $0xc,%esp
801012b8:	68 00 02 00 00       	push   $0x200
801012bd:	6a 00                	push   $0x0
801012bf:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c2:	50                   	push   %eax
801012c3:	e8 0c 34 00 00       	call   801046d4 <memset>
  log_write(bp);
801012c8:	89 1c 24             	mov    %ebx,(%esp)
801012cb:	e8 b0 19 00 00       	call   80102c80 <log_write>
  brelse(bp);
801012d0:	89 1c 24             	mov    %ebx,(%esp)
801012d3:	e8 e4 ee ff ff       	call   801001bc <brelse>
}
801012d8:	89 f0                	mov    %esi,%eax
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret
801012e2:	66 90                	xchg   %ax,%ax

801012e4 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012e4:	55                   	push   %ebp
801012e5:	89 e5                	mov    %esp,%ebp
801012e7:	57                   	push   %edi
801012e8:	56                   	push   %esi
801012e9:	53                   	push   %ebx
801012ea:	83 ec 28             	sub    $0x28,%esp
801012ed:	89 c6                	mov    %eax,%esi
801012ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012f2:	68 60 f9 10 80       	push   $0x8010f960
801012f7:	e8 0c 33 00 00       	call   80104608 <acquire>
801012fc:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801012ff:	31 ff                	xor    %edi,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101301:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
80101306:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101309:	eb 13                	jmp    8010131e <iget+0x3a>
8010130b:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130c:	39 33                	cmp    %esi,(%ebx)
8010130e:	74 64                	je     80101374 <iget+0x90>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101310:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101316:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010131c:	74 22                	je     80101340 <iget+0x5c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010131e:	8b 43 08             	mov    0x8(%ebx),%eax
80101321:	85 c0                	test   %eax,%eax
80101323:	7f e7                	jg     8010130c <iget+0x28>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101325:	85 ff                	test   %edi,%edi
80101327:	75 e7                	jne    80101310 <iget+0x2c>
80101329:	85 c0                	test   %eax,%eax
8010132b:	75 6c                	jne    80101399 <iget+0xb5>
      empty = ip;
8010132d:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101335:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010133b:	75 e1                	jne    8010131e <iget+0x3a>
8010133d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101340:	85 ff                	test   %edi,%edi
80101342:	74 73                	je     801013b7 <iget+0xd3>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101344:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101346:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101349:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80101350:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101357:	83 ec 0c             	sub    $0xc,%esp
8010135a:	68 60 f9 10 80       	push   $0x8010f960
8010135f:	e8 44 32 00 00       	call   801045a8 <release>

  return ip;
80101364:	83 c4 10             	add    $0x10,%esp
}
80101367:	89 f8                	mov    %edi,%eax
80101369:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136c:	5b                   	pop    %ebx
8010136d:	5e                   	pop    %esi
8010136e:	5f                   	pop    %edi
8010136f:	5d                   	pop    %ebp
80101370:	c3                   	ret
80101371:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101374:	39 53 04             	cmp    %edx,0x4(%ebx)
80101377:	75 97                	jne    80101310 <iget+0x2c>
      ip->ref++;
80101379:	40                   	inc    %eax
8010137a:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010137d:	83 ec 0c             	sub    $0xc,%esp
80101380:	68 60 f9 10 80       	push   $0x8010f960
80101385:	e8 1e 32 00 00       	call   801045a8 <release>
      return ip;
8010138a:	83 c4 10             	add    $0x10,%esp
8010138d:	89 df                	mov    %ebx,%edi
}
8010138f:	89 f8                	mov    %edi,%eax
80101391:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101394:	5b                   	pop    %ebx
80101395:	5e                   	pop    %esi
80101396:	5f                   	pop    %edi
80101397:	5d                   	pop    %ebp
80101398:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101399:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139f:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013a5:	74 10                	je     801013b7 <iget+0xd3>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a7:	8b 43 08             	mov    0x8(%ebx),%eax
801013aa:	85 c0                	test   %eax,%eax
801013ac:	0f 8f 5a ff ff ff    	jg     8010130c <iget+0x28>
801013b2:	e9 72 ff ff ff       	jmp    80101329 <iget+0x45>
    panic("iget: no inodes");
801013b7:	83 ec 0c             	sub    $0xc,%esp
801013ba:	68 f0 6f 10 80       	push   $0x80106ff0
801013bf:	e8 74 ef ff ff       	call   80100338 <panic>

801013c4 <bfree>:
{
801013c4:	55                   	push   %ebp
801013c5:	89 e5                	mov    %esp,%ebp
801013c7:	56                   	push   %esi
801013c8:	53                   	push   %ebx
801013c9:	89 c1                	mov    %eax,%ecx
801013cb:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801013cd:	83 ec 08             	sub    $0x8,%esp
801013d0:	89 d0                	mov    %edx,%eax
801013d2:	c1 e8 0c             	shr    $0xc,%eax
801013d5:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801013db:	50                   	push   %eax
801013dc:	51                   	push   %ecx
801013dd:	e8 d2 ec ff ff       	call   801000b4 <bread>
801013e2:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801013e4:	89 d9                	mov    %ebx,%ecx
801013e6:	83 e1 07             	and    $0x7,%ecx
801013e9:	b8 01 00 00 00       	mov    $0x1,%eax
801013ee:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801013f0:	c1 fb 03             	sar    $0x3,%ebx
801013f3:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801013f9:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801013fe:	83 c4 10             	add    $0x10,%esp
80101401:	85 c1                	test   %eax,%ecx
80101403:	74 23                	je     80101428 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101405:	f7 d0                	not    %eax
80101407:	21 c8                	and    %ecx,%eax
80101409:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010140d:	83 ec 0c             	sub    $0xc,%esp
80101410:	56                   	push   %esi
80101411:	e8 6a 18 00 00       	call   80102c80 <log_write>
  brelse(bp);
80101416:	89 34 24             	mov    %esi,(%esp)
80101419:	e8 9e ed ff ff       	call   801001bc <brelse>
}
8010141e:	83 c4 10             	add    $0x10,%esp
80101421:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101424:	5b                   	pop    %ebx
80101425:	5e                   	pop    %esi
80101426:	5d                   	pop    %ebp
80101427:	c3                   	ret
    panic("freeing free block");
80101428:	83 ec 0c             	sub    $0xc,%esp
8010142b:	68 00 70 10 80       	push   $0x80107000
80101430:	e8 03 ef ff ff       	call   80100338 <panic>
80101435:	8d 76 00             	lea    0x0(%esi),%esi

80101438 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101438:	55                   	push   %ebp
80101439:	89 e5                	mov    %esp,%ebp
8010143b:	57                   	push   %edi
8010143c:	56                   	push   %esi
8010143d:	53                   	push   %ebx
8010143e:	83 ec 1c             	sub    $0x1c,%esp
80101441:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101443:	83 fa 0b             	cmp    $0xb,%edx
80101446:	76 7c                	jbe    801014c4 <bmap+0x8c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101448:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010144b:	83 fb 7f             	cmp    $0x7f,%ebx
8010144e:	0f 87 8e 00 00 00    	ja     801014e2 <bmap+0xaa>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101454:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010145a:	85 c0                	test   %eax,%eax
8010145c:	74 56                	je     801014b4 <bmap+0x7c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145e:	83 ec 08             	sub    $0x8,%esp
80101461:	50                   	push   %eax
80101462:	ff 36                	push   (%esi)
80101464:	e8 4b ec ff ff       	call   801000b4 <bread>
80101469:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010146b:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
8010146f:	8b 03                	mov    (%ebx),%eax
80101471:	83 c4 10             	add    $0x10,%esp
80101474:	85 c0                	test   %eax,%eax
80101476:	74 1c                	je     80101494 <bmap+0x5c>
80101478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
8010147b:	83 ec 0c             	sub    $0xc,%esp
8010147e:	57                   	push   %edi
8010147f:	e8 38 ed ff ff       	call   801001bc <brelse>
80101484:	83 c4 10             	add    $0x10,%esp
80101487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010148a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148d:	5b                   	pop    %ebx
8010148e:	5e                   	pop    %esi
8010148f:	5f                   	pop    %edi
80101490:	5d                   	pop    %ebp
80101491:	c3                   	ret
80101492:	66 90                	xchg   %ax,%ax
      a[bn] = addr = balloc(ip->dev);
80101494:	8b 06                	mov    (%esi),%eax
80101496:	e8 51 fd ff ff       	call   801011ec <balloc>
8010149b:	89 03                	mov    %eax,(%ebx)
8010149d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
801014a0:	83 ec 0c             	sub    $0xc,%esp
801014a3:	57                   	push   %edi
801014a4:	e8 d7 17 00 00       	call   80102c80 <log_write>
801014a9:	83 c4 10             	add    $0x10,%esp
801014ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014af:	eb c7                	jmp    80101478 <bmap+0x40>
801014b1:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b4:	8b 06                	mov    (%esi),%eax
801014b6:	e8 31 fd ff ff       	call   801011ec <balloc>
801014bb:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014c1:	eb 9b                	jmp    8010145e <bmap+0x26>
801014c3:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801014c4:	8d 5a 14             	lea    0x14(%edx),%ebx
801014c7:	8b 44 98 0c          	mov    0xc(%eax,%ebx,4),%eax
801014cb:	85 c0                	test   %eax,%eax
801014cd:	75 bb                	jne    8010148a <bmap+0x52>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014cf:	8b 06                	mov    (%esi),%eax
801014d1:	e8 16 fd ff ff       	call   801011ec <balloc>
801014d6:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
}
801014da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014dd:	5b                   	pop    %ebx
801014de:	5e                   	pop    %esi
801014df:	5f                   	pop    %edi
801014e0:	5d                   	pop    %ebp
801014e1:	c3                   	ret
  panic("bmap: out of range");
801014e2:	83 ec 0c             	sub    $0xc,%esp
801014e5:	68 13 70 10 80       	push   $0x80107013
801014ea:	e8 49 ee ff ff       	call   80100338 <panic>
801014ef:	90                   	nop

801014f0 <readsb>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	56                   	push   %esi
801014f4:	53                   	push   %ebx
801014f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014f8:	83 ec 08             	sub    $0x8,%esp
801014fb:	6a 01                	push   $0x1
801014fd:	ff 75 08             	push   0x8(%ebp)
80101500:	e8 af eb ff ff       	call   801000b4 <bread>
80101505:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101507:	83 c4 0c             	add    $0xc,%esp
8010150a:	6a 1c                	push   $0x1c
8010150c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010150f:	50                   	push   %eax
80101510:	56                   	push   %esi
80101511:	e8 3a 32 00 00       	call   80104750 <memmove>
  brelse(bp);
80101516:	83 c4 10             	add    $0x10,%esp
80101519:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151f:	5b                   	pop    %ebx
80101520:	5e                   	pop    %esi
80101521:	5d                   	pop    %ebp
  brelse(bp);
80101522:	e9 95 ec ff ff       	jmp    801001bc <brelse>
80101527:	90                   	nop

80101528 <iinit>:
{
80101528:	55                   	push   %ebp
80101529:	89 e5                	mov    %esp,%ebp
8010152b:	53                   	push   %ebx
8010152c:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152f:	68 26 70 10 80       	push   $0x80107026
80101534:	68 60 f9 10 80       	push   $0x8010f960
80101539:	e8 02 2f 00 00       	call   80104440 <initlock>
  for(i = 0; i < NINODE; i++) {
8010153e:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101543:	83 c4 10             	add    $0x10,%esp
80101546:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	68 2d 70 10 80       	push   $0x8010702d
80101550:	53                   	push   %ebx
80101551:	e8 de 2d 00 00       	call   80104334 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101556:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
80101565:	75 e1                	jne    80101548 <iinit+0x20>
  bp = bread(dev, 1);
80101567:	83 ec 08             	sub    $0x8,%esp
8010156a:	6a 01                	push   $0x1
8010156c:	ff 75 08             	push   0x8(%ebp)
8010156f:	e8 40 eb ff ff       	call   801000b4 <bread>
80101574:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101576:	83 c4 0c             	add    $0xc,%esp
80101579:	6a 1c                	push   $0x1c
8010157b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010157e:	50                   	push   %eax
8010157f:	68 b4 15 11 80       	push   $0x801115b4
80101584:	e8 c7 31 00 00       	call   80104750 <memmove>
  brelse(bp);
80101589:	89 1c 24             	mov    %ebx,(%esp)
8010158c:	e8 2b ec ff ff       	call   801001bc <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101591:	ff 35 cc 15 11 80    	push   0x801115cc
80101597:	ff 35 c8 15 11 80    	push   0x801115c8
8010159d:	ff 35 c4 15 11 80    	push   0x801115c4
801015a3:	ff 35 c0 15 11 80    	push   0x801115c0
801015a9:	ff 35 bc 15 11 80    	push   0x801115bc
801015af:	ff 35 b8 15 11 80    	push   0x801115b8
801015b5:	ff 35 b4 15 11 80    	push   0x801115b4
801015bb:	68 fc 74 10 80       	push   $0x801074fc
801015c0:	e8 5b f0 ff ff       	call   80100620 <cprintf>
}
801015c5:	83 c4 30             	add    $0x30,%esp
801015c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015cb:	c9                   	leave
801015cc:	c3                   	ret
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <ialloc>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 1c             	sub    $0x1c,%esp
801015d9:	8b 75 08             	mov    0x8(%ebp),%esi
801015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801015df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015e2:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
801015e9:	0f 86 84 00 00 00    	jbe    80101673 <ialloc+0xa3>
801015ef:	bf 01 00 00 00       	mov    $0x1,%edi
801015f4:	eb 17                	jmp    8010160d <ialloc+0x3d>
801015f6:	66 90                	xchg   %ax,%ax
    brelse(bp);
801015f8:	83 ec 0c             	sub    $0xc,%esp
801015fb:	53                   	push   %ebx
801015fc:	e8 bb eb ff ff       	call   801001bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101601:	47                   	inc    %edi
80101602:	83 c4 10             	add    $0x10,%esp
80101605:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
8010160b:	73 66                	jae    80101673 <ialloc+0xa3>
    bp = bread(dev, IBLOCK(inum, sb));
8010160d:	83 ec 08             	sub    $0x8,%esp
80101610:	89 f8                	mov    %edi,%eax
80101612:	c1 e8 03             	shr    $0x3,%eax
80101615:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010161b:	50                   	push   %eax
8010161c:	56                   	push   %esi
8010161d:	e8 92 ea ff ff       	call   801000b4 <bread>
80101622:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101624:	89 f8                	mov    %edi,%eax
80101626:	83 e0 07             	and    $0x7,%eax
80101629:	c1 e0 06             	shl    $0x6,%eax
8010162c:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101630:	83 c4 10             	add    $0x10,%esp
80101633:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101637:	75 bf                	jne    801015f8 <ialloc+0x28>
      memset(dip, 0, sizeof(*dip));
80101639:	50                   	push   %eax
8010163a:	6a 40                	push   $0x40
8010163c:	6a 00                	push   $0x0
8010163e:	51                   	push   %ecx
8010163f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101642:	e8 8d 30 00 00       	call   801046d4 <memset>
      dip->type = type;
80101647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010164a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010164d:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101650:	89 1c 24             	mov    %ebx,(%esp)
80101653:	e8 28 16 00 00       	call   80102c80 <log_write>
      brelse(bp);
80101658:	89 1c 24             	mov    %ebx,(%esp)
8010165b:	e8 5c eb ff ff       	call   801001bc <brelse>
      return iget(dev, inum);
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	89 fa                	mov    %edi,%edx
80101665:	89 f0                	mov    %esi,%eax
}
80101667:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166a:	5b                   	pop    %ebx
8010166b:	5e                   	pop    %esi
8010166c:	5f                   	pop    %edi
8010166d:	5d                   	pop    %ebp
      return iget(dev, inum);
8010166e:	e9 71 fc ff ff       	jmp    801012e4 <iget>
  panic("ialloc: no inodes");
80101673:	83 ec 0c             	sub    $0xc,%esp
80101676:	68 33 70 10 80       	push   $0x80107033
8010167b:	e8 b8 ec ff ff       	call   80100338 <panic>

80101680 <iupdate>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101688:	83 ec 08             	sub    $0x8,%esp
8010168b:	8b 43 04             	mov    0x4(%ebx),%eax
8010168e:	c1 e8 03             	shr    $0x3,%eax
80101691:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101697:	50                   	push   %eax
80101698:	ff 33                	push   (%ebx)
8010169a:	e8 15 ea ff ff       	call   801000b4 <bread>
8010169f:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a1:	8b 43 04             	mov    0x4(%ebx),%eax
801016a4:	83 e0 07             	and    $0x7,%eax
801016a7:	c1 e0 06             	shl    $0x6,%eax
801016aa:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ae:	8b 53 50             	mov    0x50(%ebx),%edx
801016b1:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016b4:	66 8b 53 52          	mov    0x52(%ebx),%dx
801016b8:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801016bc:	8b 53 54             	mov    0x54(%ebx),%edx
801016bf:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801016c3:	66 8b 53 56          	mov    0x56(%ebx),%dx
801016c7:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801016cb:	8b 53 58             	mov    0x58(%ebx),%edx
801016ce:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016d1:	83 c4 0c             	add    $0xc,%esp
801016d4:	6a 34                	push   $0x34
801016d6:	83 c3 5c             	add    $0x5c,%ebx
801016d9:	53                   	push   %ebx
801016da:	83 c0 0c             	add    $0xc,%eax
801016dd:	50                   	push   %eax
801016de:	e8 6d 30 00 00       	call   80104750 <memmove>
  log_write(bp);
801016e3:	89 34 24             	mov    %esi,(%esp)
801016e6:	e8 95 15 00 00       	call   80102c80 <log_write>
  brelse(bp);
801016eb:	83 c4 10             	add    $0x10,%esp
801016ee:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
  brelse(bp);
801016f7:	e9 c0 ea ff ff       	jmp    801001bc <brelse>

801016fc <idup>:
{
801016fc:	55                   	push   %ebp
801016fd:	89 e5                	mov    %esp,%ebp
801016ff:	53                   	push   %ebx
80101700:	83 ec 10             	sub    $0x10,%esp
80101703:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101706:	68 60 f9 10 80       	push   $0x8010f960
8010170b:	e8 f8 2e 00 00       	call   80104608 <acquire>
  ip->ref++;
80101710:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
80101713:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010171a:	e8 89 2e 00 00       	call   801045a8 <release>
}
8010171f:	89 d8                	mov    %ebx,%eax
80101721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101724:	c9                   	leave
80101725:	c3                   	ret
80101726:	66 90                	xchg   %ax,%ax

80101728 <ilock>:
{
80101728:	55                   	push   %ebp
80101729:	89 e5                	mov    %esp,%ebp
8010172b:	56                   	push   %esi
8010172c:	53                   	push   %ebx
8010172d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101730:	85 db                	test   %ebx,%ebx
80101732:	0f 84 a9 00 00 00    	je     801017e1 <ilock+0xb9>
80101738:	8b 53 08             	mov    0x8(%ebx),%edx
8010173b:	85 d2                	test   %edx,%edx
8010173d:	0f 8e 9e 00 00 00    	jle    801017e1 <ilock+0xb9>
  acquiresleep(&ip->lock);
80101743:	83 ec 0c             	sub    $0xc,%esp
80101746:	8d 43 0c             	lea    0xc(%ebx),%eax
80101749:	50                   	push   %eax
8010174a:	e8 19 2c 00 00       	call   80104368 <acquiresleep>
  if(ip->valid == 0){
8010174f:	83 c4 10             	add    $0x10,%esp
80101752:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101755:	85 c0                	test   %eax,%eax
80101757:	74 07                	je     80101760 <ilock+0x38>
}
80101759:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010175c:	5b                   	pop    %ebx
8010175d:	5e                   	pop    %esi
8010175e:	5d                   	pop    %ebp
8010175f:	c3                   	ret
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	83 ec 08             	sub    $0x8,%esp
80101763:	8b 43 04             	mov    0x4(%ebx),%eax
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	push   (%ebx)
80101772:	e8 3d e9 ff ff       	call   801000b4 <bread>
80101777:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101779:	8b 43 04             	mov    0x4(%ebx),%eax
8010177c:	83 e0 07             	and    $0x7,%eax
8010177f:	c1 e0 06             	shl    $0x6,%eax
80101782:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101786:	8b 10                	mov    (%eax),%edx
80101788:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010178c:	66 8b 50 02          	mov    0x2(%eax),%dx
80101790:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101794:	8b 50 04             	mov    0x4(%eax),%edx
80101797:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010179b:	66 8b 50 06          	mov    0x6(%eax),%dx
8010179f:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017a3:	8b 50 08             	mov    0x8(%eax),%edx
801017a6:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a9:	83 c4 0c             	add    $0xc,%esp
801017ac:	6a 34                	push   $0x34
801017ae:	83 c0 0c             	add    $0xc,%eax
801017b1:	50                   	push   %eax
801017b2:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b5:	50                   	push   %eax
801017b6:	e8 95 2f 00 00       	call   80104750 <memmove>
    brelse(bp);
801017bb:	89 34 24             	mov    %esi,(%esp)
801017be:	e8 f9 e9 ff ff       	call   801001bc <brelse>
    ip->valid = 1;
801017c3:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801017d2:	75 85                	jne    80101759 <ilock+0x31>
      panic("ilock: no type");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 4b 70 10 80       	push   $0x8010704b
801017dc:	e8 57 eb ff ff       	call   80100338 <panic>
    panic("ilock");
801017e1:	83 ec 0c             	sub    $0xc,%esp
801017e4:	68 45 70 10 80       	push   $0x80107045
801017e9:	e8 4a eb ff ff       	call   80100338 <panic>
801017ee:	66 90                	xchg   %ax,%ax

801017f0 <iunlock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	74 28                	je     80101824 <iunlock+0x34>
801017fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801017ff:	83 ec 0c             	sub    $0xc,%esp
80101802:	56                   	push   %esi
80101803:	e8 f0 2b 00 00       	call   801043f8 <holdingsleep>
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 c0                	test   %eax,%eax
8010180d:	74 15                	je     80101824 <iunlock+0x34>
8010180f:	8b 43 08             	mov    0x8(%ebx),%eax
80101812:	85 c0                	test   %eax,%eax
80101814:	7e 0e                	jle    80101824 <iunlock+0x34>
  releasesleep(&ip->lock);
80101816:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101819:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010181f:	e9 98 2b 00 00       	jmp    801043bc <releasesleep>
    panic("iunlock");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 5a 70 10 80       	push   $0x8010705a
8010182c:	e8 07 eb ff ff       	call   80100338 <panic>
80101831:	8d 76 00             	lea    0x0(%esi),%esi

80101834 <iput>:
{
80101834:	55                   	push   %ebp
80101835:	89 e5                	mov    %esp,%ebp
80101837:	57                   	push   %edi
80101838:	56                   	push   %esi
80101839:	53                   	push   %ebx
8010183a:	83 ec 28             	sub    $0x28,%esp
8010183d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101840:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101843:	57                   	push   %edi
80101844:	e8 1f 2b 00 00       	call   80104368 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101849:	83 c4 10             	add    $0x10,%esp
8010184c:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010184f:	85 c0                	test   %eax,%eax
80101851:	74 07                	je     8010185a <iput+0x26>
80101853:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101858:	74 2e                	je     80101888 <iput+0x54>
  releasesleep(&ip->lock);
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	57                   	push   %edi
8010185e:	e8 59 2b 00 00       	call   801043bc <releasesleep>
  acquire(&icache.lock);
80101863:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010186a:	e8 99 2d 00 00       	call   80104608 <acquire>
  ip->ref--;
8010186f:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
80101872:	83 c4 10             	add    $0x10,%esp
80101875:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
8010187c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010187f:	5b                   	pop    %ebx
80101880:	5e                   	pop    %esi
80101881:	5f                   	pop    %edi
80101882:	5d                   	pop    %ebp
  release(&icache.lock);
80101883:	e9 20 2d 00 00       	jmp    801045a8 <release>
    acquire(&icache.lock);
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 60 f9 10 80       	push   $0x8010f960
80101890:	e8 73 2d 00 00       	call   80104608 <acquire>
    int r = ip->ref;
80101895:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101898:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010189f:	e8 04 2d 00 00       	call   801045a8 <release>
    if(r == 1){
801018a4:	83 c4 10             	add    $0x10,%esp
801018a7:	4e                   	dec    %esi
801018a8:	75 b0                	jne    8010185a <iput+0x26>
801018aa:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018ad:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018b3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018b6:	89 df                	mov    %ebx,%edi
801018b8:	89 cb                	mov    %ecx,%ebx
801018ba:	eb 07                	jmp    801018c3 <iput+0x8f>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018bc:	83 c6 04             	add    $0x4,%esi
801018bf:	39 de                	cmp    %ebx,%esi
801018c1:	74 15                	je     801018d8 <iput+0xa4>
    if(ip->addrs[i]){
801018c3:	8b 16                	mov    (%esi),%edx
801018c5:	85 d2                	test   %edx,%edx
801018c7:	74 f3                	je     801018bc <iput+0x88>
      bfree(ip->dev, ip->addrs[i]);
801018c9:	8b 07                	mov    (%edi),%eax
801018cb:	e8 f4 fa ff ff       	call   801013c4 <bfree>
      ip->addrs[i] = 0;
801018d0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018d6:	eb e4                	jmp    801018bc <iput+0x88>
    }
  }

  if(ip->addrs[NDIRECT]){
801018d8:	89 fb                	mov    %edi,%ebx
801018da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018dd:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018e3:	85 c0                	test   %eax,%eax
801018e5:	75 2d                	jne    80101914 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018e7:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	53                   	push   %ebx
801018f2:	e8 89 fd ff ff       	call   80101680 <iupdate>
      ip->type = 0;
801018f7:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801018fd:	89 1c 24             	mov    %ebx,(%esp)
80101900:	e8 7b fd ff ff       	call   80101680 <iupdate>
      ip->valid = 0;
80101905:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	e9 46 ff ff ff       	jmp    8010185a <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101914:	83 ec 08             	sub    $0x8,%esp
80101917:	50                   	push   %eax
80101918:	ff 33                	push   (%ebx)
8010191a:	e8 95 e7 ff ff       	call   801000b4 <bread>
    for(j = 0; j < NINDIRECT; j++){
8010191f:	8d 70 5c             	lea    0x5c(%eax),%esi
80101922:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101928:	83 c4 10             	add    $0x10,%esp
8010192b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101931:	89 cf                	mov    %ecx,%edi
80101933:	eb 0a                	jmp    8010193f <iput+0x10b>
80101935:	8d 76 00             	lea    0x0(%esi),%esi
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 0f                	je     8010194e <iput+0x11a>
      if(a[j])
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x104>
        bfree(ip->dev, a[j]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 78 fa ff ff       	call   801013c4 <bfree>
8010194c:	eb ea                	jmp    80101938 <iput+0x104>
    brelse(bp);
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101954:	83 ec 0c             	sub    $0xc,%esp
80101957:	50                   	push   %eax
80101958:	e8 5f e8 ff ff       	call   801001bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010195d:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101963:	8b 03                	mov    (%ebx),%eax
80101965:	e8 5a fa ff ff       	call   801013c4 <bfree>
    ip->addrs[NDIRECT] = 0;
8010196a:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101971:	00 00 00 
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	e9 6b ff ff ff       	jmp    801018e7 <iput+0xb3>

8010197c <iunlockput>:
{
8010197c:	55                   	push   %ebp
8010197d:	89 e5                	mov    %esp,%ebp
8010197f:	56                   	push   %esi
80101980:	53                   	push   %ebx
80101981:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101984:	85 db                	test   %ebx,%ebx
80101986:	74 34                	je     801019bc <iunlockput+0x40>
80101988:	8d 73 0c             	lea    0xc(%ebx),%esi
8010198b:	83 ec 0c             	sub    $0xc,%esp
8010198e:	56                   	push   %esi
8010198f:	e8 64 2a 00 00       	call   801043f8 <holdingsleep>
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	85 c0                	test   %eax,%eax
80101999:	74 21                	je     801019bc <iunlockput+0x40>
8010199b:	8b 43 08             	mov    0x8(%ebx),%eax
8010199e:	85 c0                	test   %eax,%eax
801019a0:	7e 1a                	jle    801019bc <iunlockput+0x40>
  releasesleep(&ip->lock);
801019a2:	83 ec 0c             	sub    $0xc,%esp
801019a5:	56                   	push   %esi
801019a6:	e8 11 2a 00 00       	call   801043bc <releasesleep>
  iput(ip);
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801019b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019b4:	5b                   	pop    %ebx
801019b5:	5e                   	pop    %esi
801019b6:	5d                   	pop    %ebp
  iput(ip);
801019b7:	e9 78 fe ff ff       	jmp    80101834 <iput>
    panic("iunlock");
801019bc:	83 ec 0c             	sub    $0xc,%esp
801019bf:	68 5a 70 10 80       	push   $0x8010705a
801019c4:	e8 6f e9 ff ff       	call   80100338 <panic>
801019c9:	8d 76 00             	lea    0x0(%esi),%esi

801019cc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019cc:	55                   	push   %ebp
801019cd:	89 e5                	mov    %esp,%ebp
801019cf:	8b 55 08             	mov    0x8(%ebp),%edx
801019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d5:	8b 0a                	mov    (%edx),%ecx
801019d7:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019da:	8b 4a 04             	mov    0x4(%edx),%ecx
801019dd:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e0:	8b 4a 50             	mov    0x50(%edx),%ecx
801019e3:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019e6:	66 8b 4a 56          	mov    0x56(%edx),%cx
801019ea:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019ee:	8b 52 58             	mov    0x58(%edx),%edx
801019f1:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f4:	5d                   	pop    %ebp
801019f5:	c3                   	ret
801019f6:	66 90                	xchg   %ax,%ax

801019f8 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f8:	55                   	push   %ebp
801019f9:	89 e5                	mov    %esp,%ebp
801019fb:	57                   	push   %edi
801019fc:	56                   	push   %esi
801019fd:	53                   	push   %ebx
801019fe:	83 ec 1c             	sub    $0x1c,%esp
80101a01:	8b 45 08             	mov    0x8(%ebp),%eax
80101a04:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a07:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a0a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a0d:	8b 7d 10             	mov    0x10(%ebp),%edi
80101a10:	8b 75 14             	mov    0x14(%ebp),%esi
80101a13:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a16:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a1b:	0f 84 af 00 00 00    	je     80101ad0 <readi+0xd8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a21:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a24:	8b 50 58             	mov    0x58(%eax),%edx
80101a27:	39 fa                	cmp    %edi,%edx
80101a29:	0f 82 c2 00 00 00    	jb     80101af1 <readi+0xf9>
80101a2f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a32:	31 c0                	xor    %eax,%eax
80101a34:	01 f9                	add    %edi,%ecx
80101a36:	0f 92 c0             	setb   %al
80101a39:	89 c3                	mov    %eax,%ebx
80101a3b:	0f 82 b0 00 00 00    	jb     80101af1 <readi+0xf9>
    return -1;
  if(off + n > ip->size)
80101a41:	39 ca                	cmp    %ecx,%edx
80101a43:	72 7f                	jb     80101ac4 <readi+0xcc>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	85 f6                	test   %esi,%esi
80101a4a:	74 6a                	je     80101ab6 <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a4c:	89 de                	mov    %ebx,%esi
80101a4e:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a50:	89 fa                	mov    %edi,%edx
80101a52:	c1 ea 09             	shr    $0x9,%edx
80101a55:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a58:	89 d8                	mov    %ebx,%eax
80101a5a:	e8 d9 f9 ff ff       	call   80101438 <bmap>
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	50                   	push   %eax
80101a63:	ff 33                	push   (%ebx)
80101a65:	e8 4a e6 ff ff       	call   801000b4 <bread>
80101a6a:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6c:	89 f8                	mov    %edi,%eax
80101a6e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a73:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a76:	29 f1                	sub    %esi,%ecx
80101a78:	bb 00 02 00 00       	mov    $0x200,%ebx
80101a7d:	29 c3                	sub    %eax,%ebx
80101a7f:	83 c4 10             	add    $0x10,%esp
80101a82:	39 d9                	cmp    %ebx,%ecx
80101a84:	73 02                	jae    80101a88 <readi+0x90>
80101a86:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a88:	51                   	push   %ecx
80101a89:	53                   	push   %ebx
80101a8a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a91:	50                   	push   %eax
80101a92:	ff 75 e0             	push   -0x20(%ebp)
80101a95:	e8 b6 2c 00 00       	call   80104750 <memmove>
    brelse(bp);
80101a9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a9d:	89 14 24             	mov    %edx,(%esp)
80101aa0:	e8 17 e7 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa5:	01 de                	add    %ebx,%esi
80101aa7:	01 df                	add    %ebx,%edi
80101aa9:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aac:	83 c4 10             	add    $0x10,%esp
80101aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ab2:	39 c6                	cmp    %eax,%esi
80101ab4:	72 9a                	jb     80101a50 <readi+0x58>
  }
  return n;
80101ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5f                   	pop    %edi
80101abf:	5d                   	pop    %ebp
80101ac0:	c3                   	ret
80101ac1:	8d 76 00             	lea    0x0(%esi),%esi
    n = ip->size - off;
80101ac4:	29 fa                	sub    %edi,%edx
80101ac6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ac9:	e9 77 ff ff ff       	jmp    80101a45 <readi+0x4d>
80101ace:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf9>
80101ada:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf9>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb c1                	jmp    80101ab9 <readi+0xc1>

80101af8 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af8:	55                   	push   %ebp
80101af9:	89 e5                	mov    %esp,%ebp
80101afb:	57                   	push   %edi
80101afc:	56                   	push   %esi
80101afd:	53                   	push   %ebx
80101afe:	83 ec 1c             	sub    $0x1c,%esp
80101b01:	8b 45 08             	mov    0x8(%ebp),%eax
80101b04:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b07:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0a:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b0d:	8b 7d 10             	mov    0x10(%ebp),%edi
80101b10:	8b 75 14             	mov    0x14(%ebp),%esi
80101b13:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b16:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101b1b:	0f 84 b7 00 00 00    	je     80101bd8 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b24:	39 78 58             	cmp    %edi,0x58(%eax)
80101b27:	0f 82 e0 00 00 00    	jb     80101c0d <writei+0x115>
80101b2d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b30:	89 f2                	mov    %esi,%edx
80101b32:	31 c0                	xor    %eax,%eax
80101b34:	01 fa                	add    %edi,%edx
80101b36:	0f 92 c0             	setb   %al
80101b39:	0f 82 ce 00 00 00    	jb     80101c0d <writei+0x115>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b3f:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101b45:	0f 87 c2 00 00 00    	ja     80101c0d <writei+0x115>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4b:	85 f6                	test   %esi,%esi
80101b4d:	74 7c                	je     80101bcb <writei+0xd3>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b4f:	89 c6                	mov    %eax,%esi
80101b51:	89 7d e0             	mov    %edi,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b54:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b57:	89 da                	mov    %ebx,%edx
80101b59:	c1 ea 09             	shr    $0x9,%edx
80101b5c:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b5f:	89 f8                	mov    %edi,%eax
80101b61:	e8 d2 f8 ff ff       	call   80101438 <bmap>
80101b66:	83 ec 08             	sub    $0x8,%esp
80101b69:	50                   	push   %eax
80101b6a:	ff 37                	push   (%edi)
80101b6c:	e8 43 e5 ff ff       	call   801000b4 <bread>
80101b71:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	89 d8                	mov    %ebx,%eax
80101b75:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b7a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101b7d:	29 f1                	sub    %esi,%ecx
80101b7f:	bb 00 02 00 00       	mov    $0x200,%ebx
80101b84:	29 c3                	sub    %eax,%ebx
80101b86:	83 c4 10             	add    $0x10,%esp
80101b89:	39 d9                	cmp    %ebx,%ecx
80101b8b:	73 02                	jae    80101b8f <writei+0x97>
80101b8d:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b8f:	52                   	push   %edx
80101b90:	53                   	push   %ebx
80101b91:	ff 75 dc             	push   -0x24(%ebp)
80101b94:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101b98:	50                   	push   %eax
80101b99:	e8 b2 2b 00 00       	call   80104750 <memmove>
    log_write(bp);
80101b9e:	89 3c 24             	mov    %edi,(%esp)
80101ba1:	e8 da 10 00 00       	call   80102c80 <log_write>
    brelse(bp);
80101ba6:	89 3c 24             	mov    %edi,(%esp)
80101ba9:	e8 0e e6 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bae:	01 de                	add    %ebx,%esi
80101bb0:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bb3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bb6:	83 c4 10             	add    $0x10,%esp
80101bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bbc:	39 c6                	cmp    %eax,%esi
80101bbe:	72 94                	jb     80101b54 <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
80101bc0:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bc6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bc9:	72 31                	jb     80101bfc <writei+0x104>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd1:	5b                   	pop    %ebx
80101bd2:	5e                   	pop    %esi
80101bd3:	5f                   	pop    %edi
80101bd4:	5d                   	pop    %ebp
80101bd5:	c3                   	ret
80101bd6:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bd8:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bdc:	66 83 f8 09          	cmp    $0x9,%ax
80101be0:	77 2b                	ja     80101c0d <writei+0x115>
80101be2:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101be9:	85 c0                	test   %eax,%eax
80101beb:	74 20                	je     80101c0d <writei+0x115>
    return devsw[ip->major].write(ip, src, n);
80101bed:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf3:	5b                   	pop    %ebx
80101bf4:	5e                   	pop    %esi
80101bf5:	5f                   	pop    %edi
80101bf6:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bf7:	ff e0                	jmp    *%eax
80101bf9:	8d 76 00             	lea    0x0(%esi),%esi
    ip->size = off;
80101bfc:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101bff:	83 ec 0c             	sub    $0xc,%esp
80101c02:	50                   	push   %eax
80101c03:	e8 78 fa ff ff       	call   80101680 <iupdate>
80101c08:	83 c4 10             	add    $0x10,%esp
80101c0b:	eb be                	jmp    80101bcb <writei+0xd3>
      return -1;
80101c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c12:	eb ba                	jmp    80101bce <writei+0xd6>

80101c14 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c14:	55                   	push   %ebp
80101c15:	89 e5                	mov    %esp,%ebp
80101c17:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c1a:	6a 0e                	push   $0xe
80101c1c:	ff 75 0c             	push   0xc(%ebp)
80101c1f:	ff 75 08             	push   0x8(%ebp)
80101c22:	e8 75 2b 00 00       	call   8010479c <strncmp>
}
80101c27:	c9                   	leave
80101c28:	c3                   	ret
80101c29:	8d 76 00             	lea    0x0(%esi),%esi

80101c2c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c2c:	55                   	push   %ebp
80101c2d:	89 e5                	mov    %esp,%ebp
80101c2f:	57                   	push   %edi
80101c30:	56                   	push   %esi
80101c31:	53                   	push   %ebx
80101c32:	83 ec 1c             	sub    $0x1c,%esp
80101c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c38:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c3d:	75 7d                	jne    80101cbc <dirlookup+0x90>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c3f:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101c42:	85 c9                	test   %ecx,%ecx
80101c44:	74 3d                	je     80101c83 <dirlookup+0x57>
80101c46:	31 ff                	xor    %edi,%edi
80101c48:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c4b:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c4c:	6a 10                	push   $0x10
80101c4e:	57                   	push   %edi
80101c4f:	56                   	push   %esi
80101c50:	53                   	push   %ebx
80101c51:	e8 a2 fd ff ff       	call   801019f8 <readi>
80101c56:	83 c4 10             	add    $0x10,%esp
80101c59:	83 f8 10             	cmp    $0x10,%eax
80101c5c:	75 51                	jne    80101caf <dirlookup+0x83>
      panic("dirlookup read");
    if(de.inum == 0)
80101c5e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c63:	74 16                	je     80101c7b <dirlookup+0x4f>
  return strncmp(s, t, DIRSIZ);
80101c65:	52                   	push   %edx
80101c66:	6a 0e                	push   $0xe
80101c68:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c6b:	50                   	push   %eax
80101c6c:	ff 75 0c             	push   0xc(%ebp)
80101c6f:	e8 28 2b 00 00       	call   8010479c <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c74:	83 c4 10             	add    $0x10,%esp
80101c77:	85 c0                	test   %eax,%eax
80101c79:	74 15                	je     80101c90 <dirlookup+0x64>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c7b:	83 c7 10             	add    $0x10,%edi
80101c7e:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c81:	72 c9                	jb     80101c4c <dirlookup+0x20>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c83:	31 c0                	xor    %eax,%eax
}
80101c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c88:	5b                   	pop    %ebx
80101c89:	5e                   	pop    %esi
80101c8a:	5f                   	pop    %edi
80101c8b:	5d                   	pop    %ebp
80101c8c:	c3                   	ret
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101c90:	8b 45 10             	mov    0x10(%ebp),%eax
80101c93:	85 c0                	test   %eax,%eax
80101c95:	74 05                	je     80101c9c <dirlookup+0x70>
        *poff = off;
80101c97:	8b 45 10             	mov    0x10(%ebp),%eax
80101c9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ca0:	8b 03                	mov    (%ebx),%eax
80101ca2:	e8 3d f6 ff ff       	call   801012e4 <iget>
}
80101ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101caa:	5b                   	pop    %ebx
80101cab:	5e                   	pop    %esi
80101cac:	5f                   	pop    %edi
80101cad:	5d                   	pop    %ebp
80101cae:	c3                   	ret
      panic("dirlookup read");
80101caf:	83 ec 0c             	sub    $0xc,%esp
80101cb2:	68 74 70 10 80       	push   $0x80107074
80101cb7:	e8 7c e6 ff ff       	call   80100338 <panic>
    panic("dirlookup not DIR");
80101cbc:	83 ec 0c             	sub    $0xc,%esp
80101cbf:	68 62 70 10 80       	push   $0x80107062
80101cc4:	e8 6f e6 ff ff       	call   80100338 <panic>
80101cc9:	8d 76 00             	lea    0x0(%esi),%esi

80101ccc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ccc:	55                   	push   %ebp
80101ccd:	89 e5                	mov    %esp,%ebp
80101ccf:	57                   	push   %edi
80101cd0:	56                   	push   %esi
80101cd1:	53                   	push   %ebx
80101cd2:	83 ec 1c             	sub    $0x1c,%esp
80101cd5:	89 c3                	mov    %eax,%ebx
80101cd7:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101cda:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ce0:	0f 84 80 01 00 00    	je     80101e66 <namex+0x19a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ce6:	e8 1d 19 00 00       	call   80103608 <myproc>
80101ceb:	8b b0 b4 00 00 00    	mov    0xb4(%eax),%esi
  acquire(&icache.lock);
80101cf1:	83 ec 0c             	sub    $0xc,%esp
80101cf4:	68 60 f9 10 80       	push   $0x8010f960
80101cf9:	e8 0a 29 00 00       	call   80104608 <acquire>
  ip->ref++;
80101cfe:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101d01:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101d08:	e8 9b 28 00 00       	call   801045a8 <release>
80101d0d:	83 c4 10             	add    $0x10,%esp
80101d10:	eb 03                	jmp    80101d15 <namex+0x49>
80101d12:	66 90                	xchg   %ax,%ax
    path++;
80101d14:	43                   	inc    %ebx
  while(*path == '/')
80101d15:	8a 03                	mov    (%ebx),%al
80101d17:	3c 2f                	cmp    $0x2f,%al
80101d19:	74 f9                	je     80101d14 <namex+0x48>
  if(*path == 0)
80101d1b:	84 c0                	test   %al,%al
80101d1d:	0f 84 e9 00 00 00    	je     80101e0c <namex+0x140>
  while(*path != '/' && *path != 0)
80101d23:	8a 03                	mov    (%ebx),%al
80101d25:	89 df                	mov    %ebx,%edi
80101d27:	3c 2f                	cmp    $0x2f,%al
80101d29:	75 0c                	jne    80101d37 <namex+0x6b>
80101d2b:	e9 2f 01 00 00       	jmp    80101e5f <namex+0x193>
    path++;
80101d30:	47                   	inc    %edi
  while(*path != '/' && *path != 0)
80101d31:	8a 07                	mov    (%edi),%al
80101d33:	3c 2f                	cmp    $0x2f,%al
80101d35:	74 04                	je     80101d3b <namex+0x6f>
80101d37:	84 c0                	test   %al,%al
80101d39:	75 f5                	jne    80101d30 <namex+0x64>
  len = path - s;
80101d3b:	89 f8                	mov    %edi,%eax
80101d3d:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101d3f:	83 f8 0d             	cmp    $0xd,%eax
80101d42:	0f 8e a0 00 00 00    	jle    80101de8 <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d48:	51                   	push   %ecx
80101d49:	6a 0e                	push   $0xe
80101d4b:	53                   	push   %ebx
80101d4c:	ff 75 e4             	push   -0x1c(%ebp)
80101d4f:	e8 fc 29 00 00       	call   80104750 <memmove>
80101d54:	83 c4 10             	add    $0x10,%esp
80101d57:	89 fb                	mov    %edi,%ebx
  while(*path == '/')
80101d59:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101d5c:	75 08                	jne    80101d66 <namex+0x9a>
80101d5e:	66 90                	xchg   %ax,%ax
    path++;
80101d60:	43                   	inc    %ebx
  while(*path == '/')
80101d61:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d64:	74 fa                	je     80101d60 <namex+0x94>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d66:	83 ec 0c             	sub    $0xc,%esp
80101d69:	56                   	push   %esi
80101d6a:	e8 b9 f9 ff ff       	call   80101728 <ilock>
    if(ip->type != T_DIR){
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d77:	0f 85 a4 00 00 00    	jne    80101e21 <namex+0x155>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101d80:	85 c0                	test   %eax,%eax
80101d82:	74 09                	je     80101d8d <namex+0xc1>
80101d84:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d87:	0f 84 ef 00 00 00    	je     80101e7c <namex+0x1b0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d8d:	50                   	push   %eax
80101d8e:	6a 00                	push   $0x0
80101d90:	ff 75 e4             	push   -0x1c(%ebp)
80101d93:	56                   	push   %esi
80101d94:	e8 93 fe ff ff       	call   80101c2c <dirlookup>
80101d99:	89 c7                	mov    %eax,%edi
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	85 c0                	test   %eax,%eax
80101da0:	74 7f                	je     80101e21 <namex+0x155>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101da2:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101da5:	83 ec 0c             	sub    $0xc,%esp
80101da8:	51                   	push   %ecx
80101da9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101dac:	e8 47 26 00 00       	call   801043f8 <holdingsleep>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	85 c0                	test   %eax,%eax
80101db6:	0f 84 00 01 00 00    	je     80101ebc <namex+0x1f0>
80101dbc:	8b 46 08             	mov    0x8(%esi),%eax
80101dbf:	85 c0                	test   %eax,%eax
80101dc1:	0f 8e f5 00 00 00    	jle    80101ebc <namex+0x1f0>
  releasesleep(&ip->lock);
80101dc7:	83 ec 0c             	sub    $0xc,%esp
80101dca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101dcd:	51                   	push   %ecx
80101dce:	e8 e9 25 00 00       	call   801043bc <releasesleep>
  iput(ip);
80101dd3:	89 34 24             	mov    %esi,(%esp)
80101dd6:	e8 59 fa ff ff       	call   80101834 <iput>
80101ddb:	83 c4 10             	add    $0x10,%esp
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101dde:	89 fe                	mov    %edi,%esi
  while(*path == '/')
80101de0:	e9 30 ff ff ff       	jmp    80101d15 <namex+0x49>
80101de5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101de8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101deb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101dee:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    memmove(name, s, len);
80101df1:	52                   	push   %edx
80101df2:	50                   	push   %eax
80101df3:	53                   	push   %ebx
80101df4:	ff 75 e4             	push   -0x1c(%ebp)
80101df7:	e8 54 29 00 00       	call   80104750 <memmove>
    name[len] = 0;
80101dfc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101dff:	c6 01 00             	movb   $0x0,(%ecx)
80101e02:	83 c4 10             	add    $0x10,%esp
80101e05:	89 fb                	mov    %edi,%ebx
80101e07:	e9 4d ff ff ff       	jmp    80101d59 <namex+0x8d>
  }
  if(nameiparent){
80101e0c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101e0f:	85 db                	test   %ebx,%ebx
80101e11:	0f 85 95 00 00 00    	jne    80101eac <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e17:	89 f0                	mov    %esi,%eax
80101e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e1c:	5b                   	pop    %ebx
80101e1d:	5e                   	pop    %esi
80101e1e:	5f                   	pop    %edi
80101e1f:	5d                   	pop    %ebp
80101e20:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101e24:	83 ec 0c             	sub    $0xc,%esp
80101e27:	53                   	push   %ebx
80101e28:	e8 cb 25 00 00       	call   801043f8 <holdingsleep>
80101e2d:	83 c4 10             	add    $0x10,%esp
80101e30:	85 c0                	test   %eax,%eax
80101e32:	0f 84 84 00 00 00    	je     80101ebc <namex+0x1f0>
80101e38:	8b 46 08             	mov    0x8(%esi),%eax
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	7e 7d                	jle    80101ebc <namex+0x1f0>
  releasesleep(&ip->lock);
80101e3f:	83 ec 0c             	sub    $0xc,%esp
80101e42:	53                   	push   %ebx
80101e43:	e8 74 25 00 00       	call   801043bc <releasesleep>
  iput(ip);
80101e48:	89 34 24             	mov    %esi,(%esp)
80101e4b:	e8 e4 f9 ff ff       	call   80101834 <iput>
      return 0;
80101e50:	83 c4 10             	add    $0x10,%esp
      return 0;
80101e53:	31 f6                	xor    %esi,%esi
}
80101e55:	89 f0                	mov    %esi,%eax
80101e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5a:	5b                   	pop    %ebx
80101e5b:	5e                   	pop    %esi
80101e5c:	5f                   	pop    %edi
80101e5d:	5d                   	pop    %ebp
80101e5e:	c3                   	ret
  while(*path != '/' && *path != 0)
80101e5f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e62:	31 c0                	xor    %eax,%eax
80101e64:	eb 88                	jmp    80101dee <namex+0x122>
    ip = iget(ROOTDEV, ROOTINO);
80101e66:	ba 01 00 00 00       	mov    $0x1,%edx
80101e6b:	b8 01 00 00 00       	mov    $0x1,%eax
80101e70:	e8 6f f4 ff ff       	call   801012e4 <iget>
80101e75:	89 c6                	mov    %eax,%esi
80101e77:	e9 99 fe ff ff       	jmp    80101d15 <namex+0x49>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e7c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	53                   	push   %ebx
80101e83:	e8 70 25 00 00       	call   801043f8 <holdingsleep>
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	85 c0                	test   %eax,%eax
80101e8d:	74 2d                	je     80101ebc <namex+0x1f0>
80101e8f:	8b 46 08             	mov    0x8(%esi),%eax
80101e92:	85 c0                	test   %eax,%eax
80101e94:	7e 26                	jle    80101ebc <namex+0x1f0>
  releasesleep(&ip->lock);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	53                   	push   %ebx
80101e9a:	e8 1d 25 00 00       	call   801043bc <releasesleep>
}
80101e9f:	83 c4 10             	add    $0x10,%esp
}
80101ea2:	89 f0                	mov    %esi,%eax
80101ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea7:	5b                   	pop    %ebx
80101ea8:	5e                   	pop    %esi
80101ea9:	5f                   	pop    %edi
80101eaa:	5d                   	pop    %ebp
80101eab:	c3                   	ret
    iput(ip);
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	56                   	push   %esi
80101eb0:	e8 7f f9 ff ff       	call   80101834 <iput>
    return 0;
80101eb5:	83 c4 10             	add    $0x10,%esp
      return 0;
80101eb8:	31 f6                	xor    %esi,%esi
80101eba:	eb 99                	jmp    80101e55 <namex+0x189>
    panic("iunlock");
80101ebc:	83 ec 0c             	sub    $0xc,%esp
80101ebf:	68 5a 70 10 80       	push   $0x8010705a
80101ec4:	e8 6f e4 ff ff       	call   80100338 <panic>
80101ec9:	8d 76 00             	lea    0x0(%esi),%esi

80101ecc <dirlink>:
{
80101ecc:	55                   	push   %ebp
80101ecd:	89 e5                	mov    %esp,%ebp
80101ecf:	57                   	push   %edi
80101ed0:	56                   	push   %esi
80101ed1:	53                   	push   %ebx
80101ed2:	83 ec 20             	sub    $0x20,%esp
80101ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ed8:	6a 00                	push   $0x0
80101eda:	ff 75 0c             	push   0xc(%ebp)
80101edd:	53                   	push   %ebx
80101ede:	e8 49 fd ff ff       	call   80101c2c <dirlookup>
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	85 c0                	test   %eax,%eax
80101ee8:	75 65                	jne    80101f4f <dirlink+0x83>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eea:	8b 7b 58             	mov    0x58(%ebx),%edi
80101eed:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ef0:	85 ff                	test   %edi,%edi
80101ef2:	74 29                	je     80101f1d <dirlink+0x51>
80101ef4:	31 ff                	xor    %edi,%edi
80101ef6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ef9:	eb 09                	jmp    80101f04 <dirlink+0x38>
80101efb:	90                   	nop
80101efc:	83 c7 10             	add    $0x10,%edi
80101eff:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f02:	73 19                	jae    80101f1d <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f04:	6a 10                	push   $0x10
80101f06:	57                   	push   %edi
80101f07:	56                   	push   %esi
80101f08:	53                   	push   %ebx
80101f09:	e8 ea fa ff ff       	call   801019f8 <readi>
80101f0e:	83 c4 10             	add    $0x10,%esp
80101f11:	83 f8 10             	cmp    $0x10,%eax
80101f14:	75 4c                	jne    80101f62 <dirlink+0x96>
    if(de.inum == 0)
80101f16:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1b:	75 df                	jne    80101efc <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f1d:	50                   	push   %eax
80101f1e:	6a 0e                	push   $0xe
80101f20:	ff 75 0c             	push   0xc(%ebp)
80101f23:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f26:	50                   	push   %eax
80101f27:	e8 a8 28 00 00       	call   801047d4 <strncpy>
  de.inum = inum;
80101f2c:	8b 45 10             	mov    0x10(%ebp),%eax
80101f2f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f33:	6a 10                	push   $0x10
80101f35:	57                   	push   %edi
80101f36:	56                   	push   %esi
80101f37:	53                   	push   %ebx
80101f38:	e8 bb fb ff ff       	call   80101af8 <writei>
80101f3d:	83 c4 20             	add    $0x20,%esp
80101f40:	83 f8 10             	cmp    $0x10,%eax
80101f43:	75 2a                	jne    80101f6f <dirlink+0xa3>
  return 0;
80101f45:	31 c0                	xor    %eax,%eax
}
80101f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4a:	5b                   	pop    %ebx
80101f4b:	5e                   	pop    %esi
80101f4c:	5f                   	pop    %edi
80101f4d:	5d                   	pop    %ebp
80101f4e:	c3                   	ret
    iput(ip);
80101f4f:	83 ec 0c             	sub    $0xc,%esp
80101f52:	50                   	push   %eax
80101f53:	e8 dc f8 ff ff       	call   80101834 <iput>
    return -1;
80101f58:	83 c4 10             	add    $0x10,%esp
80101f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f60:	eb e5                	jmp    80101f47 <dirlink+0x7b>
      panic("dirlink read");
80101f62:	83 ec 0c             	sub    $0xc,%esp
80101f65:	68 83 70 10 80       	push   $0x80107083
80101f6a:	e8 c9 e3 ff ff       	call   80100338 <panic>
    panic("dirlink");
80101f6f:	83 ec 0c             	sub    $0xc,%esp
80101f72:	68 43 73 10 80       	push   $0x80107343
80101f77:	e8 bc e3 ff ff       	call   80100338 <panic>

80101f7c <namei>:

struct inode*
namei(char *path)
{
80101f7c:	55                   	push   %ebp
80101f7d:	89 e5                	mov    %esp,%ebp
80101f7f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f82:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f85:	31 d2                	xor    %edx,%edx
80101f87:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8a:	e8 3d fd ff ff       	call   80101ccc <namex>
}
80101f8f:	c9                   	leave
80101f90:	c3                   	ret
80101f91:	8d 76 00             	lea    0x0(%esi),%esi

80101f94 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f94:	55                   	push   %ebp
80101f95:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f9a:	ba 01 00 00 00       	mov    $0x1,%edx
80101f9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fa2:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fa3:	e9 24 fd ff ff       	jmp    80101ccc <namex>

80101fa8 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fa8:	55                   	push   %ebp
80101fa9:	89 e5                	mov    %esp,%ebp
80101fab:	57                   	push   %edi
80101fac:	56                   	push   %esi
80101fad:	53                   	push   %ebx
80101fae:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101fb1:	85 c0                	test   %eax,%eax
80101fb3:	0f 84 99 00 00 00    	je     80102052 <idestart+0xaa>
80101fb9:	89 c3                	mov    %eax,%ebx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fbb:	8b 70 08             	mov    0x8(%eax),%esi
80101fbe:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101fc4:	77 7f                	ja     80102045 <idestart+0x9d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fc6:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101fcb:	90                   	nop
80101fcc:	89 ca                	mov    %ecx,%edx
80101fce:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fcf:	83 e0 c0             	and    $0xffffffc0,%eax
80101fd2:	3c 40                	cmp    $0x40,%al
80101fd4:	75 f6                	jne    80101fcc <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fd6:	31 ff                	xor    %edi,%edi
80101fd8:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fdd:	89 f8                	mov    %edi,%eax
80101fdf:	ee                   	out    %al,(%dx)
80101fe0:	b0 01                	mov    $0x1,%al
80101fe2:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fe7:	ee                   	out    %al,(%dx)
80101fe8:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fed:	89 f0                	mov    %esi,%eax
80101fef:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ff0:	89 f0                	mov    %esi,%eax
80101ff2:	c1 f8 08             	sar    $0x8,%eax
80101ff5:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ffa:	ee                   	out    %al,(%dx)
80101ffb:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102000:	89 f8                	mov    %edi,%eax
80102002:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102003:	8a 43 04             	mov    0x4(%ebx),%al
80102006:	c1 e0 04             	shl    $0x4,%eax
80102009:	83 e0 10             	and    $0x10,%eax
8010200c:	83 c8 e0             	or     $0xffffffe0,%eax
8010200f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102014:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102015:	f6 03 04             	testb  $0x4,(%ebx)
80102018:	75 0e                	jne    80102028 <idestart+0x80>
8010201a:	b0 20                	mov    $0x20,%al
8010201c:	89 ca                	mov    %ecx,%edx
8010201e:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010201f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102022:	5b                   	pop    %ebx
80102023:	5e                   	pop    %esi
80102024:	5f                   	pop    %edi
80102025:	5d                   	pop    %ebp
80102026:	c3                   	ret
80102027:	90                   	nop
80102028:	b0 30                	mov    $0x30,%al
8010202a:	89 ca                	mov    %ecx,%edx
8010202c:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
8010202d:	8d 73 5c             	lea    0x5c(%ebx),%esi
  asm volatile("cld; rep outsl" :
80102030:	b9 80 00 00 00       	mov    $0x80,%ecx
80102035:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010203a:	fc                   	cld
8010203b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    panic("incorrect blockno");
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	68 99 70 10 80       	push   $0x80107099
8010204d:	e8 e6 e2 ff ff       	call   80100338 <panic>
    panic("idestart");
80102052:	83 ec 0c             	sub    $0xc,%esp
80102055:	68 90 70 10 80       	push   $0x80107090
8010205a:	e8 d9 e2 ff ff       	call   80100338 <panic>
8010205f:	90                   	nop

80102060 <ideinit>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102066:	68 ab 70 10 80       	push   $0x801070ab
8010206b:	68 00 16 11 80       	push   $0x80111600
80102070:	e8 cb 23 00 00       	call   80104440 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102075:	58                   	pop    %eax
80102076:	5a                   	pop    %edx
80102077:	a1 84 17 11 80       	mov    0x80111784,%eax
8010207c:	48                   	dec    %eax
8010207d:	50                   	push   %eax
8010207e:	6a 0e                	push   $0xe
80102080:	e8 53 02 00 00       	call   801022d8 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102085:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102088:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010208d:	8d 76 00             	lea    0x0(%esi),%esi
80102090:	ec                   	in     (%dx),%al
80102091:	83 e0 c0             	and    $0xffffffc0,%eax
80102094:	3c 40                	cmp    $0x40,%al
80102096:	75 f8                	jne    80102090 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102098:	b0 f0                	mov    $0xf0,%al
8010209a:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010209f:	ee                   	out    %al,(%dx)
801020a0:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a5:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020aa:	eb 03                	jmp    801020af <ideinit+0x4f>
  for(i=0; i<1000; i++){
801020ac:	49                   	dec    %ecx
801020ad:	74 0f                	je     801020be <ideinit+0x5e>
801020af:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020b0:	84 c0                	test   %al,%al
801020b2:	74 f8                	je     801020ac <ideinit+0x4c>
      havedisk1 = 1;
801020b4:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
801020bb:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020be:	b0 e0                	mov    $0xe0,%al
801020c0:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020c5:	ee                   	out    %al,(%dx)
}
801020c6:	c9                   	leave
801020c7:	c3                   	ret

801020c8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020c8:	55                   	push   %ebp
801020c9:	89 e5                	mov    %esp,%ebp
801020cb:	57                   	push   %edi
801020cc:	56                   	push   %esi
801020cd:	53                   	push   %ebx
801020ce:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020d1:	68 00 16 11 80       	push   $0x80111600
801020d6:	e8 2d 25 00 00       	call   80104608 <acquire>

  if((b = idequeue) == 0){
801020db:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801020e1:	83 c4 10             	add    $0x10,%esp
801020e4:	85 db                	test   %ebx,%ebx
801020e6:	74 5b                	je     80102143 <ideintr+0x7b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020e8:	8b 43 58             	mov    0x58(%ebx),%eax
801020eb:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020f0:	8b 33                	mov    (%ebx),%esi
801020f2:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020f8:	75 27                	jne    80102121 <ideintr+0x59>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ff:	90                   	nop
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	88 c1                	mov    %al,%cl
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x38>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 12                	jne    80102121 <ideintr+0x59>
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010211f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102121:	83 e6 fb             	and    $0xfffffffb,%esi
80102124:	83 ce 02             	or     $0x2,%esi
80102127:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102129:	83 ec 0c             	sub    $0xc,%esp
8010212c:	53                   	push   %ebx
8010212d:	e8 9e 1c 00 00       	call   80103dd0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102132:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102137:	83 c4 10             	add    $0x10,%esp
8010213a:	85 c0                	test   %eax,%eax
8010213c:	74 05                	je     80102143 <ideintr+0x7b>
    idestart(idequeue);
8010213e:	e8 65 fe ff ff       	call   80101fa8 <idestart>
    release(&idelock);
80102143:	83 ec 0c             	sub    $0xc,%esp
80102146:	68 00 16 11 80       	push   $0x80111600
8010214b:	e8 58 24 00 00       	call   801045a8 <release>

  release(&idelock);
}
80102150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102153:	5b                   	pop    %ebx
80102154:	5e                   	pop    %esi
80102155:	5f                   	pop    %edi
80102156:	5d                   	pop    %ebp
80102157:	c3                   	ret

80102158 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102158:	55                   	push   %ebp
80102159:	89 e5                	mov    %esp,%ebp
8010215b:	53                   	push   %ebx
8010215c:	83 ec 10             	sub    $0x10,%esp
8010215f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102162:	8d 43 0c             	lea    0xc(%ebx),%eax
80102165:	50                   	push   %eax
80102166:	e8 8d 22 00 00       	call   801043f8 <holdingsleep>
8010216b:	83 c4 10             	add    $0x10,%esp
8010216e:	85 c0                	test   %eax,%eax
80102170:	0f 84 b7 00 00 00    	je     8010222d <iderw+0xd5>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102176:	8b 03                	mov    (%ebx),%eax
80102178:	83 e0 06             	and    $0x6,%eax
8010217b:	83 f8 02             	cmp    $0x2,%eax
8010217e:	0f 84 9c 00 00 00    	je     80102220 <iderw+0xc8>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102184:	8b 53 04             	mov    0x4(%ebx),%edx
80102187:	85 d2                	test   %edx,%edx
80102189:	74 09                	je     80102194 <iderw+0x3c>
8010218b:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102190:	85 c0                	test   %eax,%eax
80102192:	74 7f                	je     80102213 <iderw+0xbb>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102194:	83 ec 0c             	sub    $0xc,%esp
80102197:	68 00 16 11 80       	push   $0x80111600
8010219c:	e8 67 24 00 00       	call   80104608 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801021a1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021a8:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801021ad:	83 c4 10             	add    $0x10,%esp
801021b0:	85 c0                	test   %eax,%eax
801021b2:	74 58                	je     8010220c <iderw+0xb4>
801021b4:	89 c2                	mov    %eax,%edx
801021b6:	8b 40 58             	mov    0x58(%eax),%eax
801021b9:	85 c0                	test   %eax,%eax
801021bb:	75 f7                	jne    801021b4 <iderw+0x5c>
801021bd:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021c0:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c2:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801021c8:	74 36                	je     80102200 <iderw+0xa8>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ca:	8b 03                	mov    (%ebx),%eax
801021cc:	83 e0 06             	and    $0x6,%eax
801021cf:	83 f8 02             	cmp    $0x2,%eax
801021d2:	74 1b                	je     801021ef <iderw+0x97>
    sleep(b, &idelock);
801021d4:	83 ec 08             	sub    $0x8,%esp
801021d7:	68 00 16 11 80       	push   $0x80111600
801021dc:	53                   	push   %ebx
801021dd:	e8 f2 19 00 00       	call   80103bd4 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021e2:	8b 03                	mov    (%ebx),%eax
801021e4:	83 e0 06             	and    $0x6,%eax
801021e7:	83 c4 10             	add    $0x10,%esp
801021ea:	83 f8 02             	cmp    $0x2,%eax
801021ed:	75 e5                	jne    801021d4 <iderw+0x7c>
  }


  release(&idelock);
801021ef:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801021f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021f9:	c9                   	leave
  release(&idelock);
801021fa:	e9 a9 23 00 00       	jmp    801045a8 <release>
801021ff:	90                   	nop
    idestart(b);
80102200:	89 d8                	mov    %ebx,%eax
80102202:	e8 a1 fd ff ff       	call   80101fa8 <idestart>
80102207:	eb c1                	jmp    801021ca <iderw+0x72>
80102209:	8d 76 00             	lea    0x0(%esi),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010220c:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102211:	eb ad                	jmp    801021c0 <iderw+0x68>
    panic("iderw: ide disk 1 not present");
80102213:	83 ec 0c             	sub    $0xc,%esp
80102216:	68 da 70 10 80       	push   $0x801070da
8010221b:	e8 18 e1 ff ff       	call   80100338 <panic>
    panic("iderw: nothing to do");
80102220:	83 ec 0c             	sub    $0xc,%esp
80102223:	68 c5 70 10 80       	push   $0x801070c5
80102228:	e8 0b e1 ff ff       	call   80100338 <panic>
    panic("iderw: buf not locked");
8010222d:	83 ec 0c             	sub    $0xc,%esp
80102230:	68 af 70 10 80       	push   $0x801070af
80102235:	e8 fe e0 ff ff       	call   80100338 <panic>
8010223a:	66 90                	xchg   %ax,%ax

8010223c <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010223c:	55                   	push   %ebp
8010223d:	89 e5                	mov    %esp,%ebp
8010223f:	56                   	push   %esi
80102240:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102241:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102248:	00 c0 fe 
  ioapic->reg = reg;
8010224b:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102252:	00 00 00 
  return ioapic->data;
80102255:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010225b:	8b 72 10             	mov    0x10(%edx),%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225e:	c1 ee 10             	shr    $0x10,%esi
80102261:	89 f0                	mov    %esi,%eax
80102263:	0f b6 f0             	movzbl %al,%esi
  ioapic->reg = reg;
80102266:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010226c:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
80102272:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102275:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  id = ioapicread(REG_ID) >> 24;
8010227c:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
8010227f:	39 c2                	cmp    %eax,%edx
80102281:	74 16                	je     80102299 <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102283:	83 ec 0c             	sub    $0xc,%esp
80102286:	68 50 75 10 80       	push   $0x80107550
8010228b:	e8 90 e3 ff ff       	call   80100620 <cprintf>
  ioapic->reg = reg;
80102290:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
80102296:	83 c4 10             	add    $0x10,%esp
{
80102299:	ba 10 00 00 00       	mov    $0x10,%edx
8010229e:	31 c0                	xor    %eax,%eax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a0:	8d 48 20             	lea    0x20(%eax),%ecx
801022a3:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
801022a9:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022ab:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801022b1:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801022b4:	8d 4a 01             	lea    0x1(%edx),%ecx
801022b7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022b9:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801022bf:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801022c6:	40                   	inc    %eax
801022c7:	83 c2 02             	add    $0x2,%edx
801022ca:	39 c6                	cmp    %eax,%esi
801022cc:	7d d2                	jge    801022a0 <ioapicinit+0x64>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d1:	5b                   	pop    %ebx
801022d2:	5e                   	pop    %esi
801022d3:	5d                   	pop    %ebp
801022d4:	c3                   	ret
801022d5:	8d 76 00             	lea    0x0(%esi),%esi

801022d8 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d8:	55                   	push   %ebp
801022d9:	89 e5                	mov    %esp,%ebp
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022de:	8d 50 20             	lea    0x20(%eax),%edx
801022e1:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801022eb:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022ed:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801022f3:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801022f9:	c1 e2 18             	shl    $0x18,%edx
801022fc:	40                   	inc    %eax
  ioapic->reg = reg;
801022fd:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022ff:	a1 34 16 11 80       	mov    0x80111634,%eax
80102304:	89 50 10             	mov    %edx,0x10(%eax)
}
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret
80102309:	66 90                	xchg   %ax,%ax
8010230b:	90                   	nop

8010230c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010230c:	55                   	push   %ebp
8010230d:	89 e5                	mov    %esp,%ebp
8010230f:	53                   	push   %ebx
80102310:	53                   	push   %ebx
80102311:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102314:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010231a:	75 70                	jne    8010238c <kfree+0x80>
8010231c:	81 fb d0 67 11 80    	cmp    $0x801167d0,%ebx
80102322:	72 68                	jb     8010238c <kfree+0x80>
80102324:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010232a:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010232f:	77 5b                	ja     8010238c <kfree+0x80>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102331:	52                   	push   %edx
80102332:	68 00 10 00 00       	push   $0x1000
80102337:	6a 01                	push   $0x1
80102339:	53                   	push   %ebx
8010233a:	e8 95 23 00 00       	call   801046d4 <memset>

  if(kmem.use_lock)
8010233f:	83 c4 10             	add    $0x10,%esp
80102342:	8b 0d 74 16 11 80    	mov    0x80111674,%ecx
80102348:	85 c9                	test   %ecx,%ecx
8010234a:	75 1c                	jne    80102368 <kfree+0x5c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010234c:	a1 78 16 11 80       	mov    0x80111678,%eax
80102351:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102353:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102359:	a1 74 16 11 80       	mov    0x80111674,%eax
8010235e:	85 c0                	test   %eax,%eax
80102360:	75 1a                	jne    8010237c <kfree+0x70>
    release(&kmem.lock);
}
80102362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102365:	c9                   	leave
80102366:	c3                   	ret
80102367:	90                   	nop
    acquire(&kmem.lock);
80102368:	83 ec 0c             	sub    $0xc,%esp
8010236b:	68 40 16 11 80       	push   $0x80111640
80102370:	e8 93 22 00 00       	call   80104608 <acquire>
80102375:	83 c4 10             	add    $0x10,%esp
80102378:	eb d2                	jmp    8010234c <kfree+0x40>
8010237a:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
8010237c:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
80102383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102386:	c9                   	leave
    release(&kmem.lock);
80102387:	e9 1c 22 00 00       	jmp    801045a8 <release>
    panic("kfree");
8010238c:	83 ec 0c             	sub    $0xc,%esp
8010238f:	68 f8 70 10 80       	push   $0x801070f8
80102394:	e8 9f df ff ff       	call   80100338 <panic>
80102399:	8d 76 00             	lea    0x0(%esi),%esi

8010239c <freerange>:
{
8010239c:	55                   	push   %ebp
8010239d:	89 e5                	mov    %esp,%ebp
8010239f:	56                   	push   %esi
801023a0:	53                   	push   %ebx
801023a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023a4:	8b 45 08             	mov    0x8(%ebp),%eax
801023a7:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023ad:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023b9:	39 de                	cmp    %ebx,%esi
801023bb:	72 1f                	jb     801023dc <freerange+0x40>
801023bd:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023c9:	50                   	push   %eax
801023ca:	e8 3d ff ff ff       	call   8010230c <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023d5:	83 c4 10             	add    $0x10,%esp
801023d8:	39 de                	cmp    %ebx,%esi
801023da:	73 e4                	jae    801023c0 <freerange+0x24>
}
801023dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023df:	5b                   	pop    %ebx
801023e0:	5e                   	pop    %esi
801023e1:	5d                   	pop    %ebp
801023e2:	c3                   	ret
801023e3:	90                   	nop

801023e4 <kinit2>:
{
801023e4:	55                   	push   %ebp
801023e5:	89 e5                	mov    %esp,%ebp
801023e7:	56                   	push   %esi
801023e8:	53                   	push   %ebx
801023e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ec:	8b 45 08             	mov    0x8(%ebp),%eax
801023ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102401:	39 de                	cmp    %ebx,%esi
80102403:	72 1f                	jb     80102424 <kinit2+0x40>
80102405:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102411:	50                   	push   %eax
80102412:	e8 f5 fe ff ff       	call   8010230c <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102417:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 de                	cmp    %ebx,%esi
80102422:	73 e4                	jae    80102408 <kinit2+0x24>
  kmem.use_lock = 1;
80102424:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010242b:	00 00 00 
}
8010242e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret
80102435:	8d 76 00             	lea    0x0(%esi),%esi

80102438 <kinit1>:
{
80102438:	55                   	push   %ebp
80102439:	89 e5                	mov    %esp,%ebp
8010243b:	56                   	push   %esi
8010243c:	53                   	push   %ebx
8010243d:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	68 fe 70 10 80       	push   $0x801070fe
80102448:	68 40 16 11 80       	push   $0x80111640
8010244d:	e8 ee 1f 00 00       	call   80104440 <initlock>
  kmem.use_lock = 0;
80102452:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102459:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245c:	8b 45 08             	mov    0x8(%ebp),%eax
8010245f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102465:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102471:	83 c4 10             	add    $0x10,%esp
80102474:	39 de                	cmp    %ebx,%esi
80102476:	72 1c                	jb     80102494 <kinit1+0x5c>
    kfree(p);
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102481:	50                   	push   %eax
80102482:	e8 85 fe ff ff       	call   8010230c <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	83 c4 10             	add    $0x10,%esp
80102490:	39 de                	cmp    %ebx,%esi
80102492:	73 e4                	jae    80102478 <kinit1+0x40>
}
80102494:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102497:	5b                   	pop    %ebx
80102498:	5e                   	pop    %esi
80102499:	5d                   	pop    %ebp
8010249a:	c3                   	ret
8010249b:	90                   	nop

8010249c <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
8010249c:	a1 74 16 11 80       	mov    0x80111674,%eax
801024a1:	85 c0                	test   %eax,%eax
801024a3:	75 17                	jne    801024bc <kalloc+0x20>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a5:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
801024aa:	85 c0                	test   %eax,%eax
801024ac:	74 0a                	je     801024b8 <kalloc+0x1c>
    kmem.freelist = r->next;
801024ae:	8b 10                	mov    (%eax),%edx
801024b0:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801024b6:	c3                   	ret
801024b7:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801024b8:	c3                   	ret
801024b9:	8d 76 00             	lea    0x0(%esi),%esi
{
801024bc:	55                   	push   %ebp
801024bd:	89 e5                	mov    %esp,%ebp
801024bf:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024c2:	68 40 16 11 80       	push   $0x80111640
801024c7:	e8 3c 21 00 00       	call   80104608 <acquire>
  r = kmem.freelist;
801024cc:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801024d1:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801024d7:	83 c4 10             	add    $0x10,%esp
801024da:	85 c0                	test   %eax,%eax
801024dc:	74 08                	je     801024e6 <kalloc+0x4a>
    kmem.freelist = r->next;
801024de:	8b 08                	mov    (%eax),%ecx
801024e0:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801024e6:	85 d2                	test   %edx,%edx
801024e8:	74 16                	je     80102500 <kalloc+0x64>
801024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&kmem.lock);
801024ed:	83 ec 0c             	sub    $0xc,%esp
801024f0:	68 40 16 11 80       	push   $0x80111640
801024f5:	e8 ae 20 00 00       	call   801045a8 <release>
801024fa:	83 c4 10             	add    $0x10,%esp
801024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102500:	c9                   	leave
80102501:	c3                   	ret
80102502:	66 90                	xchg   %ax,%ax

80102504 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102504:	ba 64 00 00 00       	mov    $0x64,%edx
80102509:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010250a:	a8 01                	test   $0x1,%al
8010250c:	0f 84 ae 00 00 00    	je     801025c0 <kbdgetc+0xbc>
{
80102512:	55                   	push   %ebp
80102513:	89 e5                	mov    %esp,%ebp
80102515:	53                   	push   %ebx
80102516:	ba 60 00 00 00       	mov    $0x60,%edx
8010251b:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010251c:	0f b6 d8             	movzbl %al,%ebx

  if(data == 0xE0){
    shift |= E0ESC;
8010251f:	8b 0d 7c 16 11 80    	mov    0x8011167c,%ecx
  if(data == 0xE0){
80102525:	3c e0                	cmp    $0xe0,%al
80102527:	74 5b                	je     80102584 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102529:	89 ca                	mov    %ecx,%edx
8010252b:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010252e:	84 c0                	test   %al,%al
80102530:	78 62                	js     80102594 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102532:	85 d2                	test   %edx,%edx
80102534:	74 09                	je     8010253f <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102536:	83 c8 80             	or     $0xffffff80,%eax
80102539:	0f b6 d8             	movzbl %al,%ebx
    shift &= ~E0ESC;
8010253c:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
8010253f:	0f b6 93 c0 77 10 80 	movzbl -0x7fef8840(%ebx),%edx
80102546:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
80102548:	0f b6 83 c0 76 10 80 	movzbl -0x7fef8940(%ebx),%eax
8010254f:	31 c2                	xor    %eax,%edx
80102551:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102557:	89 d0                	mov    %edx,%eax
80102559:	83 e0 03             	and    $0x3,%eax
8010255c:	8b 04 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%eax
80102563:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
  if(shift & CAPSLOCK){
80102567:	83 e2 08             	and    $0x8,%edx
8010256a:	74 13                	je     8010257f <kbdgetc+0x7b>
    if('a' <= c && c <= 'z')
8010256c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010256f:	83 fa 19             	cmp    $0x19,%edx
80102572:	76 44                	jbe    801025b8 <kbdgetc+0xb4>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102574:	8d 50 bf             	lea    -0x41(%eax),%edx
80102577:	83 fa 19             	cmp    $0x19,%edx
8010257a:	77 03                	ja     8010257f <kbdgetc+0x7b>
      c += 'a' - 'A';
8010257c:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
8010257f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102582:	c9                   	leave
80102583:	c3                   	ret
    shift |= E0ESC;
80102584:	83 c9 40             	or     $0x40,%ecx
80102587:	89 0d 7c 16 11 80    	mov    %ecx,0x8011167c
    return 0;
8010258d:	31 c0                	xor    %eax,%eax
}
8010258f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102592:	c9                   	leave
80102593:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102594:	85 d2                	test   %edx,%edx
80102596:	75 05                	jne    8010259d <kbdgetc+0x99>
80102598:	89 c3                	mov    %eax,%ebx
8010259a:	83 e3 7f             	and    $0x7f,%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010259d:	8a 83 c0 77 10 80    	mov    -0x7fef8840(%ebx),%al
801025a3:	83 c8 40             	or     $0x40,%eax
801025a6:	0f b6 c0             	movzbl %al,%eax
801025a9:	f7 d0                	not    %eax
801025ab:	21 c8                	and    %ecx,%eax
801025ad:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801025b2:	31 c0                	xor    %eax,%eax
801025b4:	eb d9                	jmp    8010258f <kbdgetc+0x8b>
801025b6:	66 90                	xchg   %ax,%ax
      c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
}
801025bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025be:	c9                   	leave
801025bf:	c3                   	ret
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801025c5:	c3                   	ret
801025c6:	66 90                	xchg   %ax,%ax

801025c8 <kbdintr>:

void
kbdintr(void)
{
801025c8:	55                   	push   %ebp
801025c9:	89 e5                	mov    %esp,%ebp
801025cb:	83 ec 14             	sub    $0x14,%esp
   consoleintr(kbdgetc);
801025ce:	68 04 25 10 80       	push   $0x80102504
801025d3:	e8 10 e2 ff ff       	call   801007e8 <consoleintr>
}
801025d8:	83 c4 10             	add    $0x10,%esp
801025db:	c9                   	leave
801025dc:	c3                   	ret
801025dd:	66 90                	xchg   %ax,%ax
801025df:	90                   	nop

801025e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025e0:	a1 80 16 11 80       	mov    0x80111680,%eax
801025e5:	85 c0                	test   %eax,%eax
801025e7:	0f 84 bf 00 00 00    	je     801026ac <lapicinit+0xcc>
  lapic[index] = value;
801025ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102601:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102604:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102607:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010260e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102611:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102614:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010261b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010261e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102621:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102628:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010262e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102635:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102638:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010263b:	8b 50 30             	mov    0x30(%eax),%edx
8010263e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102644:	75 6a                	jne    801026b0 <lapicinit+0xd0>
  lapic[index] = value;
80102646:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010264d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102650:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102653:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102660:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102667:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102681:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102687:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010268e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102691:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102694:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010269a:	80 e6 10             	and    $0x10,%dh
8010269d:	75 f5                	jne    80102694 <lapicinit+0xb4>
  lapic[index] = value;
8010269f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026a6:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a9:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026ac:	c3                   	ret
801026ad:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
801026b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
}
801026bd:	eb 87                	jmp    80102646 <lapicinit+0x66>
801026bf:	90                   	nop

801026c0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801026c0:	a1 80 16 11 80       	mov    0x80111680,%eax
801026c5:	85 c0                	test   %eax,%eax
801026c7:	74 07                	je     801026d0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801026c9:	8b 40 20             	mov    0x20(%eax),%eax
801026cc:	c1 e8 18             	shr    $0x18,%eax
801026cf:	c3                   	ret
801026d0:	31 c0                	xor    %eax,%eax
}
801026d2:	c3                   	ret
801026d3:	90                   	nop

801026d4 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801026d4:	a1 80 16 11 80       	mov    0x80111680,%eax
801026d9:	85 c0                	test   %eax,%eax
801026db:	74 0d                	je     801026ea <lapiceoi+0x16>
  lapic[index] = value;
801026dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801026ea:	c3                   	ret
801026eb:	90                   	nop

801026ec <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801026ec:	c3                   	ret
801026ed:	8d 76 00             	lea    0x0(%esi),%esi

801026f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	53                   	push   %ebx
801026f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801026f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026fa:	b0 0f                	mov    $0xf,%al
801026fc:	ba 70 00 00 00       	mov    $0x70,%edx
80102701:	ee                   	out    %al,(%dx)
80102702:	b0 0a                	mov    $0xa,%al
80102704:	ba 71 00 00 00       	mov    $0x71,%edx
80102709:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010270a:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102711:	00 00 
  wrv[1] = addr >> 4;
80102713:	89 c8                	mov    %ecx,%eax
80102715:	c1 e8 04             	shr    $0x4,%eax
80102718:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010271e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102723:	c1 e3 18             	shl    $0x18,%ebx
80102726:	89 da                	mov    %ebx,%edx
80102728:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010272e:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102731:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102738:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273b:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010273e:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102745:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102748:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010274b:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102751:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102754:	c1 e9 0c             	shr    $0xc,%ecx
80102757:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
8010275a:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102760:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102763:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102769:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276c:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102772:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102778:	c9                   	leave
80102779:	c3                   	ret
8010277a:	66 90                	xchg   %ax,%ax

8010277c <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010277c:	55                   	push   %ebp
8010277d:	89 e5                	mov    %esp,%ebp
8010277f:	57                   	push   %edi
80102780:	56                   	push   %esi
80102781:	53                   	push   %ebx
80102782:	83 ec 4c             	sub    $0x4c,%esp
80102785:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102788:	b0 0b                	mov    $0xb,%al
8010278a:	ba 70 00 00 00       	mov    $0x70,%edx
8010278f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102790:	ba 71 00 00 00       	mov    $0x71,%edx
80102795:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102796:	83 e0 04             	and    $0x4,%eax
80102799:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010279b:	89 df                	mov    %ebx,%edi
8010279d:	8d 76 00             	lea    0x0(%esi),%esi
801027a0:	31 c0                	xor    %eax,%eax
801027a2:	ba 70 00 00 00       	mov    $0x70,%edx
801027a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a8:	bb 71 00 00 00       	mov    $0x71,%ebx
801027ad:	89 da                	mov    %ebx,%edx
801027af:	ec                   	in     (%dx),%al
801027b0:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b3:	b0 02                	mov    $0x2,%al
801027b5:	ba 70 00 00 00       	mov    $0x70,%edx
801027ba:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027bb:	89 da                	mov    %ebx,%edx
801027bd:	ec                   	in     (%dx),%al
801027be:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	b0 04                	mov    $0x4,%al
801027c3:	ba 70 00 00 00       	mov    $0x70,%edx
801027c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c9:	89 da                	mov    %ebx,%edx
801027cb:	ec                   	in     (%dx),%al
801027cc:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027cf:	b0 07                	mov    $0x7,%al
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d7:	89 da                	mov    %ebx,%edx
801027d9:	ec                   	in     (%dx),%al
801027da:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027dd:	b0 08                	mov    $0x8,%al
801027df:	ba 70 00 00 00       	mov    $0x70,%edx
801027e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e5:	89 da                	mov    %ebx,%edx
801027e7:	ec                   	in     (%dx),%al
801027e8:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027eb:	b0 09                	mov    $0x9,%al
801027ed:	ba 70 00 00 00       	mov    $0x70,%edx
801027f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f3:	89 da                	mov    %ebx,%edx
801027f5:	ec                   	in     (%dx),%al
801027f6:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f9:	b0 0a                	mov    $0xa,%al
801027fb:	ba 70 00 00 00       	mov    $0x70,%edx
80102800:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102801:	89 da                	mov    %ebx,%edx
80102803:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102804:	84 c0                	test   %al,%al
80102806:	78 98                	js     801027a0 <cmostime+0x24>
  return inb(CMOS_RETURN);
80102808:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010280c:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010280f:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102813:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102816:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010281a:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010281d:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102821:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102824:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
80102828:	89 45 c8             	mov    %eax,-0x38(%ebp)
8010282b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282e:	31 c0                	xor    %eax,%eax
80102830:	ba 70 00 00 00       	mov    $0x70,%edx
80102835:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102836:	89 da                	mov    %ebx,%edx
80102838:	ec                   	in     (%dx),%al
80102839:	0f b6 c0             	movzbl %al,%eax
8010283c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283f:	b0 02                	mov    $0x2,%al
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102847:	89 da                	mov    %ebx,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	0f b6 c0             	movzbl %al,%eax
8010284d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102850:	b0 04                	mov    $0x4,%al
80102852:	ba 70 00 00 00       	mov    $0x70,%edx
80102857:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	ec                   	in     (%dx),%al
8010285b:	0f b6 c0             	movzbl %al,%eax
8010285e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102861:	b0 07                	mov    $0x7,%al
80102863:	ba 70 00 00 00       	mov    $0x70,%edx
80102868:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102869:	89 da                	mov    %ebx,%edx
8010286b:	ec                   	in     (%dx),%al
8010286c:	0f b6 c0             	movzbl %al,%eax
8010286f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	b0 08                	mov    $0x8,%al
80102874:	ba 70 00 00 00       	mov    $0x70,%edx
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	0f b6 c0             	movzbl %al,%eax
80102880:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102883:	b0 09                	mov    $0x9,%al
80102885:	ba 70 00 00 00       	mov    $0x70,%edx
8010288a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288b:	89 da                	mov    %ebx,%edx
8010288d:	ec                   	in     (%dx),%al
8010288e:	0f b6 c0             	movzbl %al,%eax
80102891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102894:	50                   	push   %eax
80102895:	6a 18                	push   $0x18
80102897:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010289a:	50                   	push   %eax
8010289b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010289e:	50                   	push   %eax
8010289f:	e8 74 1e 00 00       	call   80104718 <memcmp>
801028a4:	83 c4 10             	add    $0x10,%esp
801028a7:	85 c0                	test   %eax,%eax
801028a9:	0f 85 f1 fe ff ff    	jne    801027a0 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
801028af:	89 fb                	mov    %edi,%ebx
801028b1:	89 f0                	mov    %esi,%eax
801028b3:	84 c0                	test   %al,%al
801028b5:	75 7e                	jne    80102935 <cmostime+0x1b9>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028b7:	8b 55 b8             	mov    -0x48(%ebp),%edx
801028ba:	89 d0                	mov    %edx,%eax
801028bc:	c1 e8 04             	shr    $0x4,%eax
801028bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028c2:	01 c0                	add    %eax,%eax
801028c4:	83 e2 0f             	and    $0xf,%edx
801028c7:	01 d0                	add    %edx,%eax
801028c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cc:	8b 55 bc             	mov    -0x44(%ebp),%edx
801028cf:	89 d0                	mov    %edx,%eax
801028d1:	c1 e8 04             	shr    $0x4,%eax
801028d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028d7:	01 c0                	add    %eax,%eax
801028d9:	83 e2 0f             	and    $0xf,%edx
801028dc:	01 d0                	add    %edx,%eax
801028de:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e1:	8b 55 c0             	mov    -0x40(%ebp),%edx
801028e4:	89 d0                	mov    %edx,%eax
801028e6:	c1 e8 04             	shr    $0x4,%eax
801028e9:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028ec:	01 c0                	add    %eax,%eax
801028ee:	83 e2 0f             	and    $0xf,%edx
801028f1:	01 d0                	add    %edx,%eax
801028f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801028f9:	89 d0                	mov    %edx,%eax
801028fb:	c1 e8 04             	shr    $0x4,%eax
801028fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102901:	01 c0                	add    %eax,%eax
80102903:	83 e2 0f             	and    $0xf,%edx
80102906:	01 d0                	add    %edx,%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 55 c8             	mov    -0x38(%ebp),%edx
8010290e:	89 d0                	mov    %edx,%eax
80102910:	c1 e8 04             	shr    $0x4,%eax
80102913:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102916:	01 c0                	add    %eax,%eax
80102918:	83 e2 0f             	and    $0xf,%edx
8010291b:	01 d0                	add    %edx,%eax
8010291d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102920:	8b 55 cc             	mov    -0x34(%ebp),%edx
80102923:	89 d0                	mov    %edx,%eax
80102925:	c1 e8 04             	shr    $0x4,%eax
80102928:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010292b:	01 c0                	add    %eax,%eax
8010292d:	83 e2 0f             	and    $0xf,%edx
80102930:	01 d0                	add    %edx,%eax
80102932:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102935:	b9 06 00 00 00       	mov    $0x6,%ecx
8010293a:	89 df                	mov    %ebx,%edi
8010293c:	8d 75 b8             	lea    -0x48(%ebp),%esi
8010293f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102941:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102948:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010294b:	5b                   	pop    %ebx
8010294c:	5e                   	pop    %esi
8010294d:	5f                   	pop    %edi
8010294e:	5d                   	pop    %ebp
8010294f:	c3                   	ret

80102950 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102950:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102956:	85 c9                	test   %ecx,%ecx
80102958:	7e 7e                	jle    801029d8 <install_trans+0x88>
{
8010295a:	55                   	push   %ebp
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	57                   	push   %edi
8010295e:	56                   	push   %esi
8010295f:	53                   	push   %ebx
80102960:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102963:	31 ff                	xor    %edi,%edi
80102965:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102968:	83 ec 08             	sub    $0x8,%esp
8010296b:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102970:	01 f8                	add    %edi,%eax
80102972:	40                   	inc    %eax
80102973:	50                   	push   %eax
80102974:	ff 35 e4 16 11 80    	push   0x801116e4
8010297a:	e8 35 d7 ff ff       	call   801000b4 <bread>
8010297f:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102981:	58                   	pop    %eax
80102982:	5a                   	pop    %edx
80102983:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
8010298a:	ff 35 e4 16 11 80    	push   0x801116e4
80102990:	e8 1f d7 ff ff       	call   801000b4 <bread>
80102995:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102997:	83 c4 0c             	add    $0xc,%esp
8010299a:	68 00 02 00 00       	push   $0x200
8010299f:	8d 46 5c             	lea    0x5c(%esi),%eax
801029a2:	50                   	push   %eax
801029a3:	8d 43 5c             	lea    0x5c(%ebx),%eax
801029a6:	50                   	push   %eax
801029a7:	e8 a4 1d 00 00       	call   80104750 <memmove>
    bwrite(dbuf);  // write dst to disk
801029ac:	89 1c 24             	mov    %ebx,(%esp)
801029af:	e8 d0 d7 ff ff       	call   80100184 <bwrite>
    brelse(lbuf);
801029b4:	89 34 24             	mov    %esi,(%esp)
801029b7:	e8 00 d8 ff ff       	call   801001bc <brelse>
    brelse(dbuf);
801029bc:	89 1c 24             	mov    %ebx,(%esp)
801029bf:	e8 f8 d7 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029c4:	47                   	inc    %edi
801029c5:	83 c4 10             	add    $0x10,%esp
801029c8:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
801029ce:	7f 98                	jg     80102968 <install_trans+0x18>
  }
}
801029d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029d3:	5b                   	pop    %ebx
801029d4:	5e                   	pop    %esi
801029d5:	5f                   	pop    %edi
801029d6:	5d                   	pop    %ebp
801029d7:	c3                   	ret
801029d8:	c3                   	ret
801029d9:	8d 76 00             	lea    0x0(%esi),%esi

801029dc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029dc:	55                   	push   %ebp
801029dd:	89 e5                	mov    %esp,%ebp
801029df:	53                   	push   %ebx
801029e0:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801029e3:	ff 35 d4 16 11 80    	push   0x801116d4
801029e9:	ff 35 e4 16 11 80    	push   0x801116e4
801029ef:	e8 c0 d6 ff ff       	call   801000b4 <bread>
801029f4:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801029f6:	a1 e8 16 11 80       	mov    0x801116e8,%eax
801029fb:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801029fe:	83 c4 10             	add    $0x10,%esp
80102a01:	85 c0                	test   %eax,%eax
80102a03:	7e 13                	jle    80102a18 <write_head+0x3c>
80102a05:	31 d2                	xor    %edx,%edx
80102a07:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102a08:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102a0f:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a13:	42                   	inc    %edx
80102a14:	39 d0                	cmp    %edx,%eax
80102a16:	75 f0                	jne    80102a08 <write_head+0x2c>
  }
  bwrite(buf);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	53                   	push   %ebx
80102a1c:	e8 63 d7 ff ff       	call   80100184 <bwrite>
  brelse(buf);
80102a21:	89 1c 24             	mov    %ebx,(%esp)
80102a24:	e8 93 d7 ff ff       	call   801001bc <brelse>
}
80102a29:	83 c4 10             	add    $0x10,%esp
80102a2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a2f:	c9                   	leave
80102a30:	c3                   	ret
80102a31:	8d 76 00             	lea    0x0(%esi),%esi

80102a34 <initlog>:
{
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
80102a37:	53                   	push   %ebx
80102a38:	83 ec 2c             	sub    $0x2c,%esp
80102a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a3e:	68 03 71 10 80       	push   $0x80107103
80102a43:	68 a0 16 11 80       	push   $0x801116a0
80102a48:	e8 f3 19 00 00       	call   80104440 <initlock>
  readsb(dev, &sb);
80102a4d:	58                   	pop    %eax
80102a4e:	5a                   	pop    %edx
80102a4f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a52:	50                   	push   %eax
80102a53:	53                   	push   %ebx
80102a54:	e8 97 ea ff ff       	call   801014f0 <readsb>
  log.start = sb.logstart;
80102a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a5c:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102a61:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102a64:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  log.dev = dev;
80102a6a:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  struct buf *buf = bread(log.dev, log.start);
80102a70:	59                   	pop    %ecx
80102a71:	5a                   	pop    %edx
80102a72:	50                   	push   %eax
80102a73:	53                   	push   %ebx
80102a74:	e8 3b d6 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
80102a79:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102a7c:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102a82:	83 c4 10             	add    $0x10,%esp
80102a85:	85 db                	test   %ebx,%ebx
80102a87:	7e 13                	jle    80102a9c <initlog+0x68>
80102a89:	31 d2                	xor    %edx,%edx
80102a8b:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102a8c:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102a90:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a97:	42                   	inc    %edx
80102a98:	39 d3                	cmp    %edx,%ebx
80102a9a:	75 f0                	jne    80102a8c <initlog+0x58>
  brelse(buf);
80102a9c:	83 ec 0c             	sub    $0xc,%esp
80102a9f:	50                   	push   %eax
80102aa0:	e8 17 d7 ff ff       	call   801001bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102aa5:	e8 a6 fe ff ff       	call   80102950 <install_trans>
  log.lh.n = 0;
80102aaa:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ab1:	00 00 00 
  write_head(); // clear the log
80102ab4:	e8 23 ff ff ff       	call   801029dc <write_head>
}
80102ab9:	83 c4 10             	add    $0x10,%esp
80102abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102abf:	c9                   	leave
80102ac0:	c3                   	ret
80102ac1:	8d 76 00             	lea    0x0(%esi),%esi

80102ac4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ac4:	55                   	push   %ebp
80102ac5:	89 e5                	mov    %esp,%ebp
80102ac7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102aca:	68 a0 16 11 80       	push   $0x801116a0
80102acf:	e8 34 1b 00 00       	call   80104608 <acquire>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	eb 18                	jmp    80102af1 <begin_op+0x2d>
80102ad9:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102adc:	83 ec 08             	sub    $0x8,%esp
80102adf:	68 a0 16 11 80       	push   $0x801116a0
80102ae4:	68 a0 16 11 80       	push   $0x801116a0
80102ae9:	e8 e6 10 00 00       	call   80103bd4 <sleep>
80102aee:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102af1:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102af6:	85 c0                	test   %eax,%eax
80102af8:	75 e2                	jne    80102adc <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102afa:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102aff:	8d 50 01             	lea    0x1(%eax),%edx
80102b02:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
80102b06:	01 c0                	add    %eax,%eax
80102b08:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102b0e:	83 f8 1e             	cmp    $0x1e,%eax
80102b11:	7f c9                	jg     80102adc <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b13:	89 15 dc 16 11 80    	mov    %edx,0x801116dc
      release(&log.lock);
80102b19:	83 ec 0c             	sub    $0xc,%esp
80102b1c:	68 a0 16 11 80       	push   $0x801116a0
80102b21:	e8 82 1a 00 00       	call   801045a8 <release>
      break;
    }
  }
}
80102b26:	83 c4 10             	add    $0x10,%esp
80102b29:	c9                   	leave
80102b2a:	c3                   	ret
80102b2b:	90                   	nop

80102b2c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b2c:	55                   	push   %ebp
80102b2d:	89 e5                	mov    %esp,%ebp
80102b2f:	57                   	push   %edi
80102b30:	56                   	push   %esi
80102b31:	53                   	push   %ebx
80102b32:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b35:	68 a0 16 11 80       	push   $0x801116a0
80102b3a:	e8 c9 1a 00 00       	call   80104608 <acquire>
  log.outstanding -= 1;
80102b3f:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102b44:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102b47:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102b4d:	83 c4 10             	add    $0x10,%esp
80102b50:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102b56:	85 f6                	test   %esi,%esi
80102b58:	0f 85 12 01 00 00    	jne    80102c70 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
80102b5e:	85 db                	test   %ebx,%ebx
80102b60:	0f 85 e6 00 00 00    	jne    80102c4c <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
80102b66:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102b6d:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b70:	83 ec 0c             	sub    $0xc,%esp
80102b73:	68 a0 16 11 80       	push   $0x801116a0
80102b78:	e8 2b 1a 00 00       	call   801045a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b7d:	83 c4 10             	add    $0x10,%esp
80102b80:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102b86:	85 c9                	test   %ecx,%ecx
80102b88:	7f 3a                	jg     80102bc4 <end_op+0x98>
    acquire(&log.lock);
80102b8a:	83 ec 0c             	sub    $0xc,%esp
80102b8d:	68 a0 16 11 80       	push   $0x801116a0
80102b92:	e8 71 1a 00 00       	call   80104608 <acquire>
    log.committing = 0;
80102b97:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102b9e:	00 00 00 
    wakeup(&log);
80102ba1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ba8:	e8 23 12 00 00       	call   80103dd0 <wakeup>
    release(&log.lock);
80102bad:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102bb4:	e8 ef 19 00 00       	call   801045a8 <release>
80102bb9:	83 c4 10             	add    $0x10,%esp
}
80102bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bbf:	5b                   	pop    %ebx
80102bc0:	5e                   	pop    %esi
80102bc1:	5f                   	pop    %edi
80102bc2:	5d                   	pop    %ebp
80102bc3:	c3                   	ret
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bc4:	83 ec 08             	sub    $0x8,%esp
80102bc7:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102bcc:	01 d8                	add    %ebx,%eax
80102bce:	40                   	inc    %eax
80102bcf:	50                   	push   %eax
80102bd0:	ff 35 e4 16 11 80    	push   0x801116e4
80102bd6:	e8 d9 d4 ff ff       	call   801000b4 <bread>
80102bdb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bdd:	58                   	pop    %eax
80102bde:	5a                   	pop    %edx
80102bdf:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102be6:	ff 35 e4 16 11 80    	push   0x801116e4
80102bec:	e8 c3 d4 ff ff       	call   801000b4 <bread>
80102bf1:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102bf3:	83 c4 0c             	add    $0xc,%esp
80102bf6:	68 00 02 00 00       	push   $0x200
80102bfb:	8d 40 5c             	lea    0x5c(%eax),%eax
80102bfe:	50                   	push   %eax
80102bff:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c02:	50                   	push   %eax
80102c03:	e8 48 1b 00 00       	call   80104750 <memmove>
    bwrite(to);  // write the log
80102c08:	89 34 24             	mov    %esi,(%esp)
80102c0b:	e8 74 d5 ff ff       	call   80100184 <bwrite>
    brelse(from);
80102c10:	89 3c 24             	mov    %edi,(%esp)
80102c13:	e8 a4 d5 ff ff       	call   801001bc <brelse>
    brelse(to);
80102c18:	89 34 24             	mov    %esi,(%esp)
80102c1b:	e8 9c d5 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c20:	43                   	inc    %ebx
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102c2a:	7c 98                	jl     80102bc4 <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c2c:	e8 ab fd ff ff       	call   801029dc <write_head>
    install_trans(); // Now install writes to home locations
80102c31:	e8 1a fd ff ff       	call   80102950 <install_trans>
    log.lh.n = 0;
80102c36:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102c3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c40:	e8 97 fd ff ff       	call   801029dc <write_head>
80102c45:	e9 40 ff ff ff       	jmp    80102b8a <end_op+0x5e>
80102c4a:	66 90                	xchg   %ax,%ax
    wakeup(&log);
80102c4c:	83 ec 0c             	sub    $0xc,%esp
80102c4f:	68 a0 16 11 80       	push   $0x801116a0
80102c54:	e8 77 11 00 00       	call   80103dd0 <wakeup>
  release(&log.lock);
80102c59:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102c60:	e8 43 19 00 00       	call   801045a8 <release>
80102c65:	83 c4 10             	add    $0x10,%esp
}
80102c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6b:	5b                   	pop    %ebx
80102c6c:	5e                   	pop    %esi
80102c6d:	5f                   	pop    %edi
80102c6e:	5d                   	pop    %ebp
80102c6f:	c3                   	ret
    panic("log.committing");
80102c70:	83 ec 0c             	sub    $0xc,%esp
80102c73:	68 07 71 10 80       	push   $0x80107107
80102c78:	e8 bb d6 ff ff       	call   80100338 <panic>
80102c7d:	8d 76 00             	lea    0x0(%esi),%esi

80102c80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	52                   	push   %edx
80102c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c88:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102c8e:	83 fa 1d             	cmp    $0x1d,%edx
80102c91:	7f 71                	jg     80102d04 <log_write+0x84>
80102c93:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102c98:	48                   	dec    %eax
80102c99:	39 c2                	cmp    %eax,%edx
80102c9b:	7d 67                	jge    80102d04 <log_write+0x84>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102c9d:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102ca2:	85 c0                	test   %eax,%eax
80102ca4:	7e 6b                	jle    80102d11 <log_write+0x91>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ca6:	83 ec 0c             	sub    $0xc,%esp
80102ca9:	68 a0 16 11 80       	push   $0x801116a0
80102cae:	e8 55 19 00 00       	call   80104608 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102cb3:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102cb9:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cbc:	83 c4 10             	add    $0x10,%esp
80102cbf:	31 c0                	xor    %eax,%eax
80102cc1:	85 d2                	test   %edx,%edx
80102cc3:	7f 08                	jg     80102ccd <log_write+0x4d>
80102cc5:	eb 0f                	jmp    80102cd6 <log_write+0x56>
80102cc7:	90                   	nop
80102cc8:	40                   	inc    %eax
80102cc9:	39 d0                	cmp    %edx,%eax
80102ccb:	74 27                	je     80102cf4 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ccd:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102cd4:	75 f2                	jne    80102cc8 <log_write+0x48>
  log.lh.block[i] = b->blockno;
80102cd6:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102cdd:	39 c2                	cmp    %eax,%edx
80102cdf:	74 1a                	je     80102cfb <log_write+0x7b>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ce1:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ce4:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cee:	c9                   	leave
  release(&log.lock);
80102cef:	e9 b4 18 00 00       	jmp    801045a8 <release>
  log.lh.block[i] = b->blockno;
80102cf4:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102cfb:	42                   	inc    %edx
80102cfc:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102d02:	eb dd                	jmp    80102ce1 <log_write+0x61>
    panic("too big a transaction");
80102d04:	83 ec 0c             	sub    $0xc,%esp
80102d07:	68 16 71 10 80       	push   $0x80107116
80102d0c:	e8 27 d6 ff ff       	call   80100338 <panic>
    panic("log_write outside of trans");
80102d11:	83 ec 0c             	sub    $0xc,%esp
80102d14:	68 2c 71 10 80       	push   $0x8010712c
80102d19:	e8 1a d6 ff ff       	call   80100338 <panic>
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d25:	e8 aa 08 00 00       	call   801035d4 <cpuid>
80102d2a:	89 c3                	mov    %eax,%ebx
80102d2c:	e8 a3 08 00 00       	call   801035d4 <cpuid>
80102d31:	52                   	push   %edx
80102d32:	53                   	push   %ebx
80102d33:	50                   	push   %eax
80102d34:	68 47 71 10 80       	push   $0x80107147
80102d39:	e8 e2 d8 ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102d3e:	e8 f5 29 00 00       	call   80105738 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d43:	e8 28 08 00 00       	call   80103570 <mycpu>
80102d48:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102d4a:	b8 01 00 00 00       	mov    $0x1,%eax
80102d4f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d56:	e8 81 14 00 00       	call   801041dc <scheduler>
80102d5b:	90                   	nop

80102d5c <mpenter>:
{
80102d5c:	55                   	push   %ebp
80102d5d:	89 e5                	mov    %esp,%ebp
80102d5f:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102d62:	e8 99 3a 00 00       	call   80106800 <switchkvm>
  seginit();
80102d67:	e8 10 3a 00 00       	call   8010677c <seginit>
  lapicinit();
80102d6c:	e8 6f f8 ff ff       	call   801025e0 <lapicinit>
  mpmain();
80102d71:	e8 aa ff ff ff       	call   80102d20 <mpmain>
80102d76:	66 90                	xchg   %ax,%ax

80102d78 <main>:
{
80102d78:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102d7c:	83 e4 f0             	and    $0xfffffff0,%esp
80102d7f:	ff 71 fc             	push   -0x4(%ecx)
80102d82:	55                   	push   %ebp
80102d83:	89 e5                	mov    %esp,%ebp
80102d85:	53                   	push   %ebx
80102d86:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102d87:	83 ec 08             	sub    $0x8,%esp
80102d8a:	68 00 00 40 80       	push   $0x80400000
80102d8f:	68 d0 67 11 80       	push   $0x801167d0
80102d94:	e8 9f f6 ff ff       	call   80102438 <kinit1>
  kvmalloc();      // kernel page table
80102d99:	e8 aa 3e 00 00       	call   80106c48 <kvmalloc>
  mpinit();        // detect other processors
80102d9e:	e8 61 01 00 00       	call   80102f04 <mpinit>
  lapicinit();     // interrupt controller
80102da3:	e8 38 f8 ff ff       	call   801025e0 <lapicinit>
  seginit();       // segment descriptors
80102da8:	e8 cf 39 00 00       	call   8010677c <seginit>
  picinit();       // disable pic
80102dad:	e8 12 03 00 00       	call   801030c4 <picinit>
  ioapicinit();    // another interrupt controller
80102db2:	e8 85 f4 ff ff       	call   8010223c <ioapicinit>
  consoleinit();   // console hardware
80102db7:	e8 2c dd ff ff       	call   80100ae8 <consoleinit>
  uartinit();      // serial port
80102dbc:	e8 97 2c 00 00       	call   80105a58 <uartinit>
  pinit();         // process table
80102dc1:	e8 8e 07 00 00       	call   80103554 <pinit>
  tvinit();        // trap vectors
80102dc6:	e8 01 29 00 00       	call   801056cc <tvinit>
  binit();         // buffer cache
80102dcb:	e8 64 d2 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102dd0:	e8 b7 e0 ff ff       	call   80100e8c <fileinit>
  ideinit();       // disk 
80102dd5:	e8 86 f2 ff ff       	call   80102060 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102dda:	83 c4 0c             	add    $0xc,%esp
80102ddd:	68 8a 00 00 00       	push   $0x8a
80102de2:	68 8c a4 10 80       	push   $0x8010a48c
80102de7:	68 00 70 00 80       	push   $0x80007000
80102dec:	e8 5f 19 00 00       	call   80104750 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102df1:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102df7:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102dfa:	01 c0                	add    %eax,%eax
80102dfc:	01 d0                	add    %edx,%eax
80102dfe:	c1 e0 04             	shl    $0x4,%eax
80102e01:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102e06:	83 c4 10             	add    $0x10,%esp
80102e09:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80102e0e:	76 74                	jbe    80102e84 <main+0x10c>
80102e10:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80102e15:	eb 20                	jmp    80102e37 <main+0xbf>
80102e17:	90                   	nop
80102e18:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102e1e:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102e24:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102e27:	01 c0                	add    %eax,%eax
80102e29:	01 d0                	add    %edx,%eax
80102e2b:	c1 e0 04             	shl    $0x4,%eax
80102e2e:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102e33:	39 c3                	cmp    %eax,%ebx
80102e35:	73 4d                	jae    80102e84 <main+0x10c>
    if(c == mycpu())  // We've started already.
80102e37:	e8 34 07 00 00       	call   80103570 <mycpu>
80102e3c:	39 c3                	cmp    %eax,%ebx
80102e3e:	74 d8                	je     80102e18 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e40:	e8 57 f6 ff ff       	call   8010249c <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e45:	05 00 10 00 00       	add    $0x1000,%eax
80102e4a:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102e4f:	c7 05 f8 6f 00 80 5c 	movl   $0x80102d5c,0x80006ff8
80102e56:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e59:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e60:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102e63:	83 ec 08             	sub    $0x8,%esp
80102e66:	68 00 70 00 00       	push   $0x7000
80102e6b:	0f b6 03             	movzbl (%ebx),%eax
80102e6e:	50                   	push   %eax
80102e6f:	e8 7c f8 ff ff       	call   801026f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e74:	83 c4 10             	add    $0x10,%esp
80102e77:	90                   	nop
80102e78:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e7e:	85 c0                	test   %eax,%eax
80102e80:	74 f6                	je     80102e78 <main+0x100>
80102e82:	eb 94                	jmp    80102e18 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102e84:	83 ec 08             	sub    $0x8,%esp
80102e87:	68 00 00 00 8e       	push   $0x8e000000
80102e8c:	68 00 00 40 80       	push   $0x80400000
80102e91:	e8 4e f5 ff ff       	call   801023e4 <kinit2>
  userinit();      // first user process
80102e96:	e8 91 07 00 00       	call   8010362c <userinit>
  mpmain();        // finish this processor's setup
80102e9b:	e8 80 fe ff ff       	call   80102d20 <mpmain>

80102ea0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	57                   	push   %edi
80102ea4:	56                   	push   %esi
80102ea5:	53                   	push   %ebx
80102ea6:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ea9:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102eaf:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102eb6:	39 de                	cmp    %ebx,%esi
80102eb8:	72 0b                	jb     80102ec5 <mpsearch1+0x25>
80102eba:	eb 3c                	jmp    80102ef8 <mpsearch1+0x58>
80102ebc:	8d 7e 10             	lea    0x10(%esi),%edi
80102ebf:	89 fe                	mov    %edi,%esi
80102ec1:	39 df                	cmp    %ebx,%edi
80102ec3:	73 33                	jae    80102ef8 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ec5:	50                   	push   %eax
80102ec6:	6a 04                	push   $0x4
80102ec8:	68 5b 71 10 80       	push   $0x8010715b
80102ecd:	56                   	push   %esi
80102ece:	e8 45 18 00 00       	call   80104718 <memcmp>
80102ed3:	83 c4 10             	add    $0x10,%esp
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	75 e2                	jne    80102ebc <mpsearch1+0x1c>
80102eda:	89 f2                	mov    %esi,%edx
80102edc:	8d 7e 10             	lea    0x10(%esi),%edi
80102edf:	90                   	nop
    sum += addr[i];
80102ee0:	0f b6 0a             	movzbl (%edx),%ecx
80102ee3:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102ee5:	42                   	inc    %edx
80102ee6:	39 fa                	cmp    %edi,%edx
80102ee8:	75 f6                	jne    80102ee0 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102eea:	84 c0                	test   %al,%al
80102eec:	75 d1                	jne    80102ebf <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102eee:	89 f0                	mov    %esi,%eax
80102ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef3:	5b                   	pop    %ebx
80102ef4:	5e                   	pop    %esi
80102ef5:	5f                   	pop    %edi
80102ef6:	5d                   	pop    %ebp
80102ef7:	c3                   	ret
  return 0;
80102ef8:	31 f6                	xor    %esi,%esi
}
80102efa:	89 f0                	mov    %esi,%eax
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret

80102f04 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f04:	55                   	push   %ebp
80102f05:	89 e5                	mov    %esp,%ebp
80102f07:	57                   	push   %edi
80102f08:	56                   	push   %esi
80102f09:	53                   	push   %ebx
80102f0a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f0d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f14:	c1 e0 08             	shl    $0x8,%eax
80102f17:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f1e:	09 d0                	or     %edx,%eax
80102f20:	c1 e0 04             	shl    $0x4,%eax
80102f23:	75 1b                	jne    80102f40 <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102f25:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f2c:	c1 e0 08             	shl    $0x8,%eax
80102f2f:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102f36:	09 d0                	or     %edx,%eax
80102f38:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102f3b:	2d 00 04 00 00       	sub    $0x400,%eax
80102f40:	ba 00 04 00 00       	mov    $0x400,%edx
80102f45:	e8 56 ff ff ff       	call   80102ea0 <mpsearch1>
80102f4a:	85 c0                	test   %eax,%eax
80102f4c:	0f 84 26 01 00 00    	je     80103078 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f58:	8b 48 04             	mov    0x4(%eax),%ecx
80102f5b:	85 c9                	test   %ecx,%ecx
80102f5d:	0f 84 a5 00 00 00    	je     80103008 <mpinit+0x104>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f66:	8b 40 04             	mov    0x4(%eax),%eax
80102f69:	05 00 00 00 80       	add    $0x80000000,%eax
80102f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f74:	52                   	push   %edx
80102f75:	6a 04                	push   $0x4
80102f77:	68 78 71 10 80       	push   $0x80107178
80102f7c:	50                   	push   %eax
80102f7d:	e8 96 17 00 00       	call   80104718 <memcmp>
80102f82:	89 c2                	mov    %eax,%edx
80102f84:	83 c4 10             	add    $0x10,%esp
80102f87:	85 c0                	test   %eax,%eax
80102f89:	75 7d                	jne    80103008 <mpinit+0x104>
  if(conf->version != 1 && conf->version != 4)
80102f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f8e:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80102f92:	74 09                	je     80102f9d <mpinit+0x99>
80102f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f97:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
80102f9b:	75 6b                	jne    80103008 <mpinit+0x104>
  if(sum((uchar*)conf, conf->length) != 0)
80102f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102fa0:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
80102fa7:	66 85 c9             	test   %cx,%cx
80102faa:	74 12                	je     80102fbe <mpinit+0xba>
80102fac:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80102faf:	90                   	nop
    sum += addr[i];
80102fb0:	0f b6 08             	movzbl (%eax),%ecx
80102fb3:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102fb5:	40                   	inc    %eax
80102fb6:	39 d8                	cmp    %ebx,%eax
80102fb8:	75 f6                	jne    80102fb0 <mpinit+0xac>
  if(sum((uchar*)conf, conf->length) != 0)
80102fba:	84 d2                	test   %dl,%dl
80102fbc:	75 4a                	jne    80103008 <mpinit+0x104>
  *pmp = mp;
80102fbe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  return conf;
80102fc1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102fc4:	85 c9                	test   %ecx,%ecx
80102fc6:	74 40                	je     80103008 <mpinit+0x104>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102fc8:	8b 41 24             	mov    0x24(%ecx),%eax
80102fcb:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fd0:	8d 41 2c             	lea    0x2c(%ecx),%eax
80102fd3:	0f b7 51 04          	movzwl 0x4(%ecx),%edx
80102fd7:	01 d1                	add    %edx,%ecx
80102fd9:	39 c8                	cmp    %ecx,%eax
80102fdb:	72 0e                	jb     80102feb <mpinit+0xe7>
80102fdd:	eb 49                	jmp    80103028 <mpinit+0x124>
80102fdf:	90                   	nop
    switch(*p){
80102fe0:	84 d2                	test   %dl,%dl
80102fe2:	74 64                	je     80103048 <mpinit+0x144>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102fe4:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fe7:	39 c8                	cmp    %ecx,%eax
80102fe9:	73 3d                	jae    80103028 <mpinit+0x124>
    switch(*p){
80102feb:	8a 10                	mov    (%eax),%dl
80102fed:	80 fa 02             	cmp    $0x2,%dl
80102ff0:	74 26                	je     80103018 <mpinit+0x114>
80102ff2:	76 ec                	jbe    80102fe0 <mpinit+0xdc>
80102ff4:	83 ea 03             	sub    $0x3,%edx
80102ff7:	80 fa 01             	cmp    $0x1,%dl
80102ffa:	76 e8                	jbe    80102fe4 <mpinit+0xe0>
80102ffc:	eb fe                	jmp    80102ffc <mpinit+0xf8>
80102ffe:	66 90                	xchg   %ax,%ax
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103000:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103007:	90                   	nop
    panic("Expect to run on an SMP");
80103008:	83 ec 0c             	sub    $0xc,%esp
8010300b:	68 60 71 10 80       	push   $0x80107160
80103010:	e8 23 d3 ff ff       	call   80100338 <panic>
80103015:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103018:	8a 50 01             	mov    0x1(%eax),%dl
8010301b:	88 15 80 17 11 80    	mov    %dl,0x80111780
      p += sizeof(struct mpioapic);
80103021:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103024:	39 c8                	cmp    %ecx,%eax
80103026:	72 c3                	jb     80102feb <mpinit+0xe7>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103028:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010302c:	74 12                	je     80103040 <mpinit+0x13c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010302e:	b0 70                	mov    $0x70,%al
80103030:	ba 22 00 00 00       	mov    $0x22,%edx
80103035:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103036:	ba 23 00 00 00       	mov    $0x23,%edx
8010303b:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010303c:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303f:	ee                   	out    %al,(%dx)
  }
}
80103040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103043:	5b                   	pop    %ebx
80103044:	5e                   	pop    %esi
80103045:	5f                   	pop    %edi
80103046:	5d                   	pop    %ebp
80103047:	c3                   	ret
      if(ncpu < NCPU) {
80103048:	8b 15 84 17 11 80    	mov    0x80111784,%edx
8010304e:	83 fa 07             	cmp    $0x7,%edx
80103051:	7f 1a                	jg     8010306d <mpinit+0x169>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103053:	8d 34 92             	lea    (%edx,%edx,4),%esi
80103056:	01 f6                	add    %esi,%esi
80103058:	01 d6                	add    %edx,%esi
8010305a:	c1 e6 04             	shl    $0x4,%esi
8010305d:	8a 58 01             	mov    0x1(%eax),%bl
80103060:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80103066:	42                   	inc    %edx
80103067:	89 15 84 17 11 80    	mov    %edx,0x80111784
      p += sizeof(struct mpproc);
8010306d:	83 c0 14             	add    $0x14,%eax
      continue;
80103070:	e9 72 ff ff ff       	jmp    80102fe7 <mpinit+0xe3>
80103075:	8d 76 00             	lea    0x0(%esi),%esi
{
80103078:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010307d:	eb 12                	jmp    80103091 <mpinit+0x18d>
8010307f:	90                   	nop
80103080:	8d 73 10             	lea    0x10(%ebx),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80103083:	89 f3                	mov    %esi,%ebx
80103085:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
8010308b:	0f 84 6f ff ff ff    	je     80103000 <mpinit+0xfc>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103091:	56                   	push   %esi
80103092:	6a 04                	push   $0x4
80103094:	68 5b 71 10 80       	push   $0x8010715b
80103099:	53                   	push   %ebx
8010309a:	e8 79 16 00 00       	call   80104718 <memcmp>
8010309f:	83 c4 10             	add    $0x10,%esp
801030a2:	85 c0                	test   %eax,%eax
801030a4:	75 da                	jne    80103080 <mpinit+0x17c>
801030a6:	89 da                	mov    %ebx,%edx
801030a8:	8d 73 10             	lea    0x10(%ebx),%esi
801030ab:	90                   	nop
    sum += addr[i];
801030ac:	0f b6 0a             	movzbl (%edx),%ecx
801030af:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801030b1:	42                   	inc    %edx
801030b2:	39 d6                	cmp    %edx,%esi
801030b4:	75 f6                	jne    801030ac <mpinit+0x1a8>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030b6:	84 c0                	test   %al,%al
801030b8:	75 c9                	jne    80103083 <mpinit+0x17f>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030ba:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801030bd:	e9 93 fe ff ff       	jmp    80102f55 <mpinit+0x51>
801030c2:	66 90                	xchg   %ax,%ax

801030c4 <picinit>:
801030c4:	b0 ff                	mov    $0xff,%al
801030c6:	ba 21 00 00 00       	mov    $0x21,%edx
801030cb:	ee                   	out    %al,(%dx)
801030cc:	ba a1 00 00 00       	mov    $0xa1,%edx
801030d1:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801030d2:	c3                   	ret
801030d3:	90                   	nop

801030d4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801030d4:	55                   	push   %ebp
801030d5:	89 e5                	mov    %esp,%ebp
801030d7:	57                   	push   %edi
801030d8:	56                   	push   %esi
801030d9:	53                   	push   %ebx
801030da:	83 ec 0c             	sub    $0xc,%esp
801030dd:	8b 75 08             	mov    0x8(%ebp),%esi
801030e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801030e3:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801030e9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801030ef:	e8 b4 dd ff ff       	call   80100ea8 <filealloc>
801030f4:	89 06                	mov    %eax,(%esi)
801030f6:	85 c0                	test   %eax,%eax
801030f8:	0f 84 a5 00 00 00    	je     801031a3 <pipealloc+0xcf>
801030fe:	e8 a5 dd ff ff       	call   80100ea8 <filealloc>
80103103:	89 07                	mov    %eax,(%edi)
80103105:	85 c0                	test   %eax,%eax
80103107:	0f 84 84 00 00 00    	je     80103191 <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010310d:	e8 8a f3 ff ff       	call   8010249c <kalloc>
80103112:	89 c3                	mov    %eax,%ebx
80103114:	85 c0                	test   %eax,%eax
80103116:	0f 84 a0 00 00 00    	je     801031bc <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
8010311c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103123:	00 00 00 
  p->writeopen = 1;
80103126:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010312d:	00 00 00 
  p->nwrite = 0;
80103130:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103137:	00 00 00 
  p->nread = 0;
8010313a:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103141:	00 00 00 
  initlock(&p->lock, "pipe");
80103144:	83 ec 08             	sub    $0x8,%esp
80103147:	68 7d 71 10 80       	push   $0x8010717d
8010314c:	50                   	push   %eax
8010314d:	e8 ee 12 00 00       	call   80104440 <initlock>
  (*f0)->type = FD_PIPE;
80103152:	8b 06                	mov    (%esi),%eax
80103154:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010315a:	8b 06                	mov    (%esi),%eax
8010315c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103160:	8b 06                	mov    (%esi),%eax
80103162:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103166:	8b 06                	mov    (%esi),%eax
80103168:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010316b:	8b 07                	mov    (%edi),%eax
8010316d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103173:	8b 07                	mov    (%edi),%eax
80103175:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103179:	8b 07                	mov    (%edi),%eax
8010317b:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010317f:	8b 07                	mov    (%edi),%eax
80103181:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103184:	83 c4 10             	add    $0x10,%esp
80103187:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103189:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318c:	5b                   	pop    %ebx
8010318d:	5e                   	pop    %esi
8010318e:	5f                   	pop    %edi
8010318f:	5d                   	pop    %ebp
80103190:	c3                   	ret
  if(*f0)
80103191:	8b 06                	mov    (%esi),%eax
80103193:	85 c0                	test   %eax,%eax
80103195:	74 1e                	je     801031b5 <pipealloc+0xe1>
    fileclose(*f0);
80103197:	83 ec 0c             	sub    $0xc,%esp
8010319a:	50                   	push   %eax
8010319b:	e8 b4 dd ff ff       	call   80100f54 <fileclose>
801031a0:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801031a3:	8b 07                	mov    (%edi),%eax
801031a5:	85 c0                	test   %eax,%eax
801031a7:	74 0c                	je     801031b5 <pipealloc+0xe1>
    fileclose(*f1);
801031a9:	83 ec 0c             	sub    $0xc,%esp
801031ac:	50                   	push   %eax
801031ad:	e8 a2 dd ff ff       	call   80100f54 <fileclose>
801031b2:	83 c4 10             	add    $0x10,%esp
  return -1;
801031b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031ba:	eb cd                	jmp    80103189 <pipealloc+0xb5>
  if(*f0)
801031bc:	8b 06                	mov    (%esi),%eax
801031be:	85 c0                	test   %eax,%eax
801031c0:	75 d5                	jne    80103197 <pipealloc+0xc3>
801031c2:	eb df                	jmp    801031a3 <pipealloc+0xcf>

801031c4 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801031c4:	55                   	push   %ebp
801031c5:	89 e5                	mov    %esp,%ebp
801031c7:	56                   	push   %esi
801031c8:	53                   	push   %ebx
801031c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801031cf:	83 ec 0c             	sub    $0xc,%esp
801031d2:	53                   	push   %ebx
801031d3:	e8 30 14 00 00       	call   80104608 <acquire>
  if(writable){
801031d8:	83 c4 10             	add    $0x10,%esp
801031db:	85 f6                	test   %esi,%esi
801031dd:	74 41                	je     80103220 <pipeclose+0x5c>
    p->writeopen = 0;
801031df:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801031e6:	00 00 00 
    wakeup(&p->nread);
801031e9:	83 ec 0c             	sub    $0xc,%esp
801031ec:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801031f2:	50                   	push   %eax
801031f3:	e8 d8 0b 00 00       	call   80103dd0 <wakeup>
801031f8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801031fb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103201:	85 d2                	test   %edx,%edx
80103203:	75 0a                	jne    8010320f <pipeclose+0x4b>
80103205:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010320b:	85 c0                	test   %eax,%eax
8010320d:	74 31                	je     80103240 <pipeclose+0x7c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010320f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103212:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103215:	5b                   	pop    %ebx
80103216:	5e                   	pop    %esi
80103217:	5d                   	pop    %ebp
    release(&p->lock);
80103218:	e9 8b 13 00 00       	jmp    801045a8 <release>
8010321d:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
80103220:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103227:	00 00 00 
    wakeup(&p->nwrite);
8010322a:	83 ec 0c             	sub    $0xc,%esp
8010322d:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103233:	50                   	push   %eax
80103234:	e8 97 0b 00 00       	call   80103dd0 <wakeup>
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	eb bd                	jmp    801031fb <pipeclose+0x37>
8010323e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103240:	83 ec 0c             	sub    $0xc,%esp
80103243:	53                   	push   %ebx
80103244:	e8 5f 13 00 00       	call   801045a8 <release>
    kfree((char*)p);
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010324f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103252:	5b                   	pop    %ebx
80103253:	5e                   	pop    %esi
80103254:	5d                   	pop    %ebp
    kfree((char*)p);
80103255:	e9 b2 f0 ff ff       	jmp    8010230c <kfree>
8010325a:	66 90                	xchg   %ax,%ax

8010325c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010325c:	55                   	push   %ebp
8010325d:	89 e5                	mov    %esp,%ebp
8010325f:	57                   	push   %edi
80103260:	56                   	push   %esi
80103261:	53                   	push   %ebx
80103262:	83 ec 28             	sub    $0x28,%esp
80103265:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103268:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010326b:	53                   	push   %ebx
8010326c:	e8 97 13 00 00       	call   80104608 <acquire>
  for(i = 0; i < n; i++){
80103271:	83 c4 10             	add    $0x10,%esp
80103274:	85 ff                	test   %edi,%edi
80103276:	0f 8e c2 00 00 00    	jle    8010333e <pipewrite+0xe2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010327c:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103285:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103288:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010328b:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103291:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103294:	89 7d 10             	mov    %edi,0x10(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103297:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010329d:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032a3:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032a9:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801032ac:	0f 85 aa 00 00 00    	jne    8010335c <pipewrite+0x100>
801032b2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801032b5:	eb 37                	jmp    801032ee <pipewrite+0x92>
801032b7:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801032b8:	e8 4b 03 00 00       	call   80103608 <myproc>
801032bd:	8b 48 70             	mov    0x70(%eax),%ecx
801032c0:	85 c9                	test   %ecx,%ecx
801032c2:	75 34                	jne    801032f8 <pipewrite+0x9c>
      wakeup(&p->nread);
801032c4:	83 ec 0c             	sub    $0xc,%esp
801032c7:	56                   	push   %esi
801032c8:	e8 03 0b 00 00       	call   80103dd0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032cd:	58                   	pop    %eax
801032ce:	5a                   	pop    %edx
801032cf:	53                   	push   %ebx
801032d0:	57                   	push   %edi
801032d1:	e8 fe 08 00 00       	call   80103bd4 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032d6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801032dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801032e2:	05 00 02 00 00       	add    $0x200,%eax
801032e7:	83 c4 10             	add    $0x10,%esp
801032ea:	39 c2                	cmp    %eax,%edx
801032ec:	75 26                	jne    80103314 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801032ee:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801032f4:	85 c0                	test   %eax,%eax
801032f6:	75 c0                	jne    801032b8 <pipewrite+0x5c>
        release(&p->lock);
801032f8:	83 ec 0c             	sub    $0xc,%esp
801032fb:	53                   	push   %ebx
801032fc:	e8 a7 12 00 00       	call   801045a8 <release>
        return -1;
80103301:	83 c4 10             	add    $0x10,%esp
80103304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103309:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330c:	5b                   	pop    %ebx
8010330d:	5e                   	pop    %esi
8010330e:	5f                   	pop    %edi
8010330f:	5d                   	pop    %ebp
80103310:	c3                   	ret
80103311:	8d 76 00             	lea    0x0(%esi),%esi
80103314:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103317:	8d 42 01             	lea    0x1(%edx),%eax
8010331a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010331d:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103323:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103329:	8a 01                	mov    (%ecx),%al
8010332b:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010332f:	41                   	inc    %ecx
80103330:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103333:	39 c1                	cmp    %eax,%ecx
80103335:	0f 85 5c ff ff ff    	jne    80103297 <pipewrite+0x3b>
8010333b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010333e:	83 ec 0c             	sub    $0xc,%esp
80103341:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103347:	50                   	push   %eax
80103348:	e8 83 0a 00 00       	call   80103dd0 <wakeup>
  release(&p->lock);
8010334d:	89 1c 24             	mov    %ebx,(%esp)
80103350:	e8 53 12 00 00       	call   801045a8 <release>
  return n;
80103355:	83 c4 10             	add    $0x10,%esp
80103358:	89 f8                	mov    %edi,%eax
8010335a:	eb ad                	jmp    80103309 <pipewrite+0xad>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010335c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010335f:	eb b6                	jmp    80103317 <pipewrite+0xbb>
80103361:	8d 76 00             	lea    0x0(%esi),%esi

80103364 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	57                   	push   %edi
80103368:	56                   	push   %esi
80103369:	53                   	push   %ebx
8010336a:	83 ec 18             	sub    $0x18,%esp
8010336d:	8b 75 08             	mov    0x8(%ebp),%esi
80103370:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103373:	56                   	push   %esi
80103374:	e8 8f 12 00 00       	call   80104608 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103382:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103388:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010338e:	74 2f                	je     801033bf <piperead+0x5b>
80103390:	eb 37                	jmp    801033c9 <piperead+0x65>
80103392:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103394:	e8 6f 02 00 00       	call   80103608 <myproc>
80103399:	8b 40 70             	mov    0x70(%eax),%eax
8010339c:	85 c0                	test   %eax,%eax
8010339e:	0f 85 80 00 00 00    	jne    80103424 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033a4:	83 ec 08             	sub    $0x8,%esp
801033a7:	56                   	push   %esi
801033a8:	53                   	push   %ebx
801033a9:	e8 26 08 00 00       	call   80103bd4 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033ae:	83 c4 10             	add    $0x10,%esp
801033b1:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033b7:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033bd:	75 0a                	jne    801033c9 <piperead+0x65>
801033bf:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801033c5:	85 d2                	test   %edx,%edx
801033c7:	75 cb                	jne    80103394 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801033c9:	31 db                	xor    %ebx,%ebx
801033cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801033ce:	85 c9                	test   %ecx,%ecx
801033d0:	7f 23                	jg     801033f5 <piperead+0x91>
801033d2:	eb 29                	jmp    801033fd <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801033d4:	8d 48 01             	lea    0x1(%eax),%ecx
801033d7:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801033dd:	25 ff 01 00 00       	and    $0x1ff,%eax
801033e2:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
801033e6:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801033e9:	43                   	inc    %ebx
801033ea:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801033ed:	74 0e                	je     801033fd <piperead+0x99>
801033ef:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801033f5:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033fb:	75 d7                	jne    801033d4 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801033fd:	83 ec 0c             	sub    $0xc,%esp
80103400:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103406:	50                   	push   %eax
80103407:	e8 c4 09 00 00       	call   80103dd0 <wakeup>
  release(&p->lock);
8010340c:	89 34 24             	mov    %esi,(%esp)
8010340f:	e8 94 11 00 00       	call   801045a8 <release>
  return i;
80103414:	83 c4 10             	add    $0x10,%esp
}
80103417:	89 d8                	mov    %ebx,%eax
80103419:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341c:	5b                   	pop    %ebx
8010341d:	5e                   	pop    %esi
8010341e:	5f                   	pop    %edi
8010341f:	5d                   	pop    %ebp
80103420:	c3                   	ret
80103421:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
80103424:	83 ec 0c             	sub    $0xc,%esp
80103427:	56                   	push   %esi
80103428:	e8 7b 11 00 00       	call   801045a8 <release>
      return -1;
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80103435:	89 d8                	mov    %ebx,%eax
80103437:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010343a:	5b                   	pop    %ebx
8010343b:	5e                   	pop    %esi
8010343c:	5f                   	pop    %edi
8010343d:	5d                   	pop    %ebp
8010343e:	c3                   	ret
8010343f:	90                   	nop

80103440 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	53                   	push   %ebx
80103444:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103447:	68 20 1d 11 80       	push   $0x80111d20
8010344c:	e8 b7 11 00 00       	call   80104608 <acquire>
80103451:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103454:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103459:	eb 0f                	jmp    8010346a <allocproc+0x2a>
8010345b:	90                   	nop
8010345c:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103462:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103468:	74 7e                	je     801034e8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010346a:	8b 4b 58             	mov    0x58(%ebx),%ecx
8010346d:	85 c9                	test   %ecx,%ecx
8010346f:	75 eb                	jne    8010345c <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103471:	c7 43 58 01 00 00 00 	movl   $0x1,0x58(%ebx)
  p->pid = nextpid++;
80103478:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010347d:	8d 50 01             	lea    0x1(%eax),%edx
80103480:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103486:	89 43 5c             	mov    %eax,0x5c(%ebx)
  p->suspended=0;
80103489:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)


//.............................................................................


  release(&ptable.lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	68 20 1d 11 80       	push   $0x80111d20
80103498:	e8 0b 11 00 00       	call   801045a8 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010349d:	e8 fa ef ff ff       	call   8010249c <kalloc>
801034a2:	89 43 54             	mov    %eax,0x54(%ebx)
801034a5:	83 c4 10             	add    $0x10,%esp
801034a8:	85 c0                	test   %eax,%eax
801034aa:	74 55                	je     80103501 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801034ac:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
801034b2:	89 53 64             	mov    %edx,0x64(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801034b5:	c7 80 b0 0f 00 00 be 	movl   $0x801056be,0xfb0(%eax)
801034bc:	56 10 80 

  sp -= sizeof *p->context;
801034bf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801034c4:	89 43 68             	mov    %eax,0x68(%ebx)
  memset(p->context, 0, sizeof *p->context);
801034c7:	52                   	push   %edx
801034c8:	6a 14                	push   $0x14
801034ca:	6a 00                	push   $0x0
801034cc:	50                   	push   %eax
801034cd:	e8 02 12 00 00       	call   801046d4 <memset>
  p->context->eip = (uint)forkret;
801034d2:	8b 43 68             	mov    0x68(%ebx),%eax
801034d5:	c7 40 10 0c 35 10 80 	movl   $0x8010350c,0x10(%eax)

  return p;
801034dc:	83 c4 10             	add    $0x10,%esp
}
801034df:	89 d8                	mov    %ebx,%eax
801034e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034e4:	c9                   	leave
801034e5:	c3                   	ret
801034e6:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801034e8:	83 ec 0c             	sub    $0xc,%esp
801034eb:	68 20 1d 11 80       	push   $0x80111d20
801034f0:	e8 b3 10 00 00       	call   801045a8 <release>
  return 0;
801034f5:	83 c4 10             	add    $0x10,%esp
801034f8:	31 db                	xor    %ebx,%ebx
}
801034fa:	89 d8                	mov    %ebx,%eax
801034fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034ff:	c9                   	leave
80103500:	c3                   	ret
    p->state = UNUSED;
80103501:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  return 0;
80103508:	31 db                	xor    %ebx,%ebx
8010350a:	eb ee                	jmp    801034fa <allocproc+0xba>

8010350c <forkret>:
}
// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010350c:	55                   	push   %ebp
8010350d:	89 e5                	mov    %esp,%ebp
8010350f:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103512:	68 20 1d 11 80       	push   $0x80111d20
80103517:	e8 8c 10 00 00       	call   801045a8 <release>

  if (first) {
8010351c:	83 c4 10             	add    $0x10,%esp
8010351f:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103524:	85 c0                	test   %eax,%eax
80103526:	75 04                	jne    8010352c <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103528:	c9                   	leave
80103529:	c3                   	ret
8010352a:	66 90                	xchg   %ax,%ax
    first = 0;
8010352c:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103533:	00 00 00 
    iinit(ROOTDEV);
80103536:	83 ec 0c             	sub    $0xc,%esp
80103539:	6a 01                	push   $0x1
8010353b:	e8 e8 df ff ff       	call   80101528 <iinit>
    initlog(ROOTDEV);
80103540:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103547:	e8 e8 f4 ff ff       	call   80102a34 <initlog>
}
8010354c:	83 c4 10             	add    $0x10,%esp
8010354f:	c9                   	leave
80103550:	c3                   	ret
80103551:	8d 76 00             	lea    0x0(%esi),%esi

80103554 <pinit>:
{
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010355a:	68 82 71 10 80       	push   $0x80107182
8010355f:	68 20 1d 11 80       	push   $0x80111d20
80103564:	e8 d7 0e 00 00       	call   80104440 <initlock>
}
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	c9                   	leave
8010356d:	c3                   	ret
8010356e:	66 90                	xchg   %ax,%ax

80103570 <mycpu>:
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103575:	9c                   	pushf
80103576:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103577:	f6 c4 02             	test   $0x2,%ah
8010357a:	75 4b                	jne    801035c7 <mycpu+0x57>
  apicid = lapicid();
8010357c:	e8 3f f1 ff ff       	call   801026c0 <lapicid>
80103581:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
80103583:	8b 1d 84 17 11 80    	mov    0x80111784,%ebx
80103589:	85 db                	test   %ebx,%ebx
8010358b:	7e 2d                	jle    801035ba <mycpu+0x4a>
8010358d:	31 d2                	xor    %edx,%edx
8010358f:	eb 08                	jmp    80103599 <mycpu+0x29>
80103591:	8d 76 00             	lea    0x0(%esi),%esi
80103594:	42                   	inc    %edx
80103595:	39 da                	cmp    %ebx,%edx
80103597:	74 21                	je     801035ba <mycpu+0x4a>
    if (cpus[i].apicid == apicid)
80103599:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010359c:	01 c0                	add    %eax,%eax
8010359e:	01 d0                	add    %edx,%eax
801035a0:	c1 e0 04             	shl    $0x4,%eax
801035a3:	0f b6 b0 a0 17 11 80 	movzbl -0x7feee860(%eax),%esi
801035aa:	39 ce                	cmp    %ecx,%esi
801035ac:	75 e6                	jne    80103594 <mycpu+0x24>
      return &cpus[i];
801035ae:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801035b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b6:	5b                   	pop    %ebx
801035b7:	5e                   	pop    %esi
801035b8:	5d                   	pop    %ebp
801035b9:	c3                   	ret
  panic("unknown apicid\n");
801035ba:	83 ec 0c             	sub    $0xc,%esp
801035bd:	68 89 71 10 80       	push   $0x80107189
801035c2:	e8 71 cd ff ff       	call   80100338 <panic>
    panic("mycpu called with interrupts enabled\n");
801035c7:	83 ec 0c             	sub    $0xc,%esp
801035ca:	68 84 75 10 80       	push   $0x80107584
801035cf:	e8 64 cd ff ff       	call   80100338 <panic>

801035d4 <cpuid>:
cpuid() {
801035d4:	55                   	push   %ebp
801035d5:	89 e5                	mov    %esp,%ebp
801035d7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801035da:	e8 91 ff ff ff       	call   80103570 <mycpu>
801035df:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801035e4:	c1 f8 04             	sar    $0x4,%eax
801035e7:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
801035ea:	89 ca                	mov    %ecx,%edx
801035ec:	c1 e2 05             	shl    $0x5,%edx
801035ef:	29 ca                	sub    %ecx,%edx
801035f1:	8d 14 90             	lea    (%eax,%edx,4),%edx
801035f4:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
801035f7:	89 ca                	mov    %ecx,%edx
801035f9:	c1 e2 0f             	shl    $0xf,%edx
801035fc:	29 ca                	sub    %ecx,%edx
801035fe:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103601:	f7 d8                	neg    %eax
}
80103603:	c9                   	leave
80103604:	c3                   	ret
80103605:	8d 76 00             	lea    0x0(%esi),%esi

80103608 <myproc>:
myproc(void) {
80103608:	55                   	push   %ebp
80103609:	89 e5                	mov    %esp,%ebp
8010360b:	53                   	push   %ebx
8010360c:	50                   	push   %eax
  pushcli();
8010360d:	e8 b2 0e 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103612:	e8 59 ff ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103617:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010361d:	e8 ee 0e 00 00       	call   80104510 <popcli>
}
80103622:	89 d8                	mov    %ebx,%eax
80103624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103627:	c9                   	leave
80103628:	c3                   	ret
80103629:	8d 76 00             	lea    0x0(%esi),%esi

8010362c <userinit>:
{
8010362c:	55                   	push   %ebp
8010362d:	89 e5                	mov    %esp,%ebp
8010362f:	53                   	push   %ebx
80103630:	51                   	push   %ecx
  p = allocproc();
80103631:	e8 0a fe ff ff       	call   80103440 <allocproc>
80103636:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103638:	a3 54 4f 11 80       	mov    %eax,0x80114f54
  if((p->pgdir = setupkvm()) == 0)
8010363d:	e8 96 35 00 00       	call   80106bd8 <setupkvm>
80103642:	89 43 50             	mov    %eax,0x50(%ebx)
80103645:	85 c0                	test   %eax,%eax
80103647:	0f 84 b9 00 00 00    	je     80103706 <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010364d:	52                   	push   %edx
8010364e:	68 2c 00 00 00       	push   $0x2c
80103653:	68 60 a4 10 80       	push   $0x8010a460
80103658:	50                   	push   %eax
80103659:	e8 ae 32 00 00       	call   8010690c <inituvm>
  p->sz = PGSIZE;
8010365e:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103664:	83 c4 0c             	add    $0xc,%esp
80103667:	6a 4c                	push   $0x4c
80103669:	6a 00                	push   $0x0
8010366b:	ff 73 64             	push   0x64(%ebx)
8010366e:	e8 61 10 00 00       	call   801046d4 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103673:	8b 43 64             	mov    0x64(%ebx),%eax
80103676:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010367c:	8b 43 64             	mov    0x64(%ebx),%eax
8010367f:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103685:	8b 43 64             	mov    0x64(%ebx),%eax
80103688:	8b 50 2c             	mov    0x2c(%eax),%edx
8010368b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010368f:	8b 43 64             	mov    0x64(%ebx),%eax
80103692:	8b 50 2c             	mov    0x2c(%eax),%edx
80103695:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103699:	8b 43 64             	mov    0x64(%ebx),%eax
8010369c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801036a3:	8b 43 64             	mov    0x64(%ebx),%eax
801036a6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801036ad:	8b 43 64             	mov    0x64(%ebx),%eax
801036b0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801036b7:	83 c4 0c             	add    $0xc,%esp
801036ba:	6a 10                	push   $0x10
801036bc:	68 b2 71 10 80       	push   $0x801071b2
801036c1:	8d 83 b8 00 00 00    	lea    0xb8(%ebx),%eax
801036c7:	50                   	push   %eax
801036c8:	e8 4f 11 00 00       	call   8010481c <safestrcpy>
  p->cwd = namei("/");
801036cd:	c7 04 24 bb 71 10 80 	movl   $0x801071bb,(%esp)
801036d4:	e8 a3 e8 ff ff       	call   80101f7c <namei>
801036d9:	89 83 b4 00 00 00    	mov    %eax,0xb4(%ebx)
  acquire(&ptable.lock);
801036df:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036e6:	e8 1d 0f 00 00       	call   80104608 <acquire>
  p->state = RUNNABLE;
801036eb:	c7 43 58 04 00 00 00 	movl   $0x4,0x58(%ebx)
  release(&ptable.lock);
801036f2:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036f9:	e8 aa 0e 00 00       	call   801045a8 <release>
}
801036fe:	83 c4 10             	add    $0x10,%esp
80103701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103704:	c9                   	leave
80103705:	c3                   	ret
    panic("userinit: out of memory?");
80103706:	83 ec 0c             	sub    $0xc,%esp
80103709:	68 99 71 10 80       	push   $0x80107199
8010370e:	e8 25 cc ff ff       	call   80100338 <panic>
80103713:	90                   	nop

80103714 <growproc>:
{
80103714:	55                   	push   %ebp
80103715:	89 e5                	mov    %esp,%ebp
80103717:	56                   	push   %esi
80103718:	53                   	push   %ebx
80103719:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010371c:	e8 a3 0d 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103721:	e8 4a fe ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103726:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010372c:	e8 df 0d 00 00       	call   80104510 <popcli>
  sz = curproc->sz;
80103731:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103733:	85 f6                	test   %esi,%esi
80103735:	7f 19                	jg     80103750 <growproc+0x3c>
  } else if(n < 0){
80103737:	75 33                	jne    8010376c <growproc+0x58>
  curproc->sz = sz;
80103739:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	53                   	push   %ebx
8010373f:	e8 cc 30 00 00       	call   80106810 <switchuvm>
  return 0;
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	31 c0                	xor    %eax,%eax
}
80103749:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010374c:	5b                   	pop    %ebx
8010374d:	5e                   	pop    %esi
8010374e:	5d                   	pop    %ebp
8010374f:	c3                   	ret
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103750:	51                   	push   %ecx
80103751:	01 c6                	add    %eax,%esi
80103753:	56                   	push   %esi
80103754:	50                   	push   %eax
80103755:	ff 73 50             	push   0x50(%ebx)
80103758:	e8 e7 32 00 00       	call   80106a44 <allocuvm>
8010375d:	83 c4 10             	add    $0x10,%esp
80103760:	85 c0                	test   %eax,%eax
80103762:	75 d5                	jne    80103739 <growproc+0x25>
      return -1;
80103764:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103769:	eb de                	jmp    80103749 <growproc+0x35>
8010376b:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010376c:	52                   	push   %edx
8010376d:	01 c6                	add    %eax,%esi
8010376f:	56                   	push   %esi
80103770:	50                   	push   %eax
80103771:	ff 73 50             	push   0x50(%ebx)
80103774:	e8 d3 33 00 00       	call   80106b4c <deallocuvm>
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	85 c0                	test   %eax,%eax
8010377e:	75 b9                	jne    80103739 <growproc+0x25>
80103780:	eb e2                	jmp    80103764 <growproc+0x50>
80103782:	66 90                	xchg   %ax,%ax

80103784 <fork>:
{
80103784:	55                   	push   %ebp
80103785:	89 e5                	mov    %esp,%ebp
80103787:	57                   	push   %edi
80103788:	56                   	push   %esi
80103789:	53                   	push   %ebx
8010378a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010378d:	e8 32 0d 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103792:	e8 d9 fd ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103797:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010379d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
801037a0:	e8 6b 0d 00 00       	call   80104510 <popcli>
  if((np = allocproc()) == 0){
801037a5:	e8 96 fc ff ff       	call   80103440 <allocproc>
801037aa:	85 c0                	test   %eax,%eax
801037ac:	0f 84 27 01 00 00    	je     801038d9 <fork+0x155>
801037b2:	89 c3                	mov    %eax,%ebx
np->creation_time = ticks;
801037b4:	a1 60 4f 11 80       	mov    0x80114f60,%eax
801037b9:	89 43 2c             	mov    %eax,0x2c(%ebx)
np->has_started = 0;
801037bc:	c7 43 44 00 00 00 00 	movl   $0x0,0x44(%ebx)
np->total_run_time = 0;
801037c3:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
np->total_wait_time = 0;
801037ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
np->context_switches = 0;
801037d1:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
np->total_sleeping_time = 0;
801037d8:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
np->start_run_tick = 0;
801037df:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
np->exec_time = -1;
801037e6:	c7 43 24 ff ff ff ff 	movl   $0xffffffff,0x24(%ebx)
np->backup_eip=0xFFFFFFF;
801037ed:	c7 43 18 ff ff ff 0f 	movl   $0xfffffff,0x18(%ebx)
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801037f4:	83 ec 08             	sub    $0x8,%esp
801037f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801037fa:	ff 32                	push   (%edx)
801037fc:	ff 72 50             	push   0x50(%edx)
801037ff:	e8 a8 34 00 00       	call   80106cac <copyuvm>
80103804:	89 43 50             	mov    %eax,0x50(%ebx)
80103807:	83 c4 10             	add    $0x10,%esp
8010380a:	85 c0                	test   %eax,%eax
8010380c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010380f:	0f 84 a8 00 00 00    	je     801038bd <fork+0x139>
  np->sz = curproc->sz;
80103815:	8b 02                	mov    (%edx),%eax
80103817:	89 03                	mov    %eax,(%ebx)
  np->parent = curproc;
80103819:	89 53 60             	mov    %edx,0x60(%ebx)
  *np->tf = *curproc->tf;
8010381c:	8b 72 64             	mov    0x64(%edx),%esi
8010381f:	b9 13 00 00 00       	mov    $0x13,%ecx
80103824:	8b 7b 64             	mov    0x64(%ebx),%edi
80103827:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103829:	8b 43 64             	mov    0x64(%ebx),%eax
8010382c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103833:	31 f6                	xor    %esi,%esi
80103835:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103838:	8b 44 b2 74          	mov    0x74(%edx,%esi,4),%eax
8010383c:	85 c0                	test   %eax,%eax
8010383e:	74 16                	je     80103856 <fork+0xd2>
80103840:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->ofile[i] = filedup(curproc->ofile[i]);
80103843:	83 ec 0c             	sub    $0xc,%esp
80103846:	50                   	push   %eax
80103847:	e8 c4 d6 ff ff       	call   80100f10 <filedup>
8010384c:	89 44 b3 74          	mov    %eax,0x74(%ebx,%esi,4)
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for(i = 0; i < NOFILE; i++)
80103856:	46                   	inc    %esi
80103857:	83 fe 10             	cmp    $0x10,%esi
8010385a:	75 dc                	jne    80103838 <fork+0xb4>
  np->cwd = idup(curproc->cwd);
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	ff b2 b4 00 00 00    	push   0xb4(%edx)
80103865:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103868:	e8 8f de ff ff       	call   801016fc <idup>
8010386d:	89 83 b4 00 00 00    	mov    %eax,0xb4(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103873:	83 c4 0c             	add    $0xc,%esp
80103876:	6a 10                	push   $0x10
80103878:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010387b:	81 c2 b8 00 00 00    	add    $0xb8,%edx
80103881:	52                   	push   %edx
80103882:	8d 83 b8 00 00 00    	lea    0xb8(%ebx),%eax
80103888:	50                   	push   %eax
80103889:	e8 8e 0f 00 00       	call   8010481c <safestrcpy>
  pid = np->pid;
8010388e:	8b 73 5c             	mov    0x5c(%ebx),%esi
  acquire(&ptable.lock);
80103891:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103898:	e8 6b 0d 00 00       	call   80104608 <acquire>
  np->state = RUNNABLE;
8010389d:	c7 43 58 04 00 00 00 	movl   $0x4,0x58(%ebx)
  release(&ptable.lock);
801038a4:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801038ab:	e8 f8 0c 00 00       	call   801045a8 <release>
  return pid;
801038b0:	83 c4 10             	add    $0x10,%esp
}
801038b3:	89 f0                	mov    %esi,%eax
801038b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b8:	5b                   	pop    %ebx
801038b9:	5e                   	pop    %esi
801038ba:	5f                   	pop    %edi
801038bb:	5d                   	pop    %ebp
801038bc:	c3                   	ret
    kfree(np->kstack);
801038bd:	83 ec 0c             	sub    $0xc,%esp
801038c0:	ff 73 54             	push   0x54(%ebx)
801038c3:	e8 44 ea ff ff       	call   8010230c <kfree>
    np->kstack = 0;
801038c8:	c7 43 54 00 00 00 00 	movl   $0x0,0x54(%ebx)
    np->state = UNUSED;
801038cf:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    return -1;
801038d6:	83 c4 10             	add    $0x10,%esp
    return -1;
801038d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
801038de:	eb d3                	jmp    801038b3 <fork+0x12f>

801038e0 <sched>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
  pushcli();
801038e5:	e8 da 0b 00 00       	call   801044c4 <pushcli>
  c = mycpu();
801038ea:	e8 81 fc ff ff       	call   80103570 <mycpu>
  p = c->proc;
801038ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038f5:	e8 16 0c 00 00       	call   80104510 <popcli>
  if(!holding(&ptable.lock))
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	68 20 1d 11 80       	push   $0x80111d20
80103902:	e8 61 0c 00 00       	call   80104568 <holding>
80103907:	83 c4 10             	add    $0x10,%esp
8010390a:	85 c0                	test   %eax,%eax
8010390c:	74 4f                	je     8010395d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010390e:	e8 5d fc ff ff       	call   80103570 <mycpu>
80103913:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010391a:	75 68                	jne    80103984 <sched+0xa4>
  if(p->state == RUNNING)
8010391c:	83 7b 58 05          	cmpl   $0x5,0x58(%ebx)
80103920:	74 55                	je     80103977 <sched+0x97>
80103922:	9c                   	pushf
80103923:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103924:	f6 c4 02             	test   $0x2,%ah
80103927:	75 41                	jne    8010396a <sched+0x8a>
  intena = mycpu()->intena;
80103929:	e8 42 fc ff ff       	call   80103570 <mycpu>
8010392e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103934:	e8 37 fc ff ff       	call   80103570 <mycpu>
80103939:	83 ec 08             	sub    $0x8,%esp
8010393c:	ff 70 04             	push   0x4(%eax)
8010393f:	83 c3 68             	add    $0x68,%ebx
80103942:	53                   	push   %ebx
80103943:	e8 21 0f 00 00       	call   80104869 <swtch>
  mycpu()->intena = intena;
80103948:	e8 23 fc ff ff       	call   80103570 <mycpu>
8010394d:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103953:	83 c4 10             	add    $0x10,%esp
80103956:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5d                   	pop    %ebp
8010395c:	c3                   	ret
    panic("sched ptable.lock");
8010395d:	83 ec 0c             	sub    $0xc,%esp
80103960:	68 bd 71 10 80       	push   $0x801071bd
80103965:	e8 ce c9 ff ff       	call   80100338 <panic>
    panic("sched interruptible");
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	68 e9 71 10 80       	push   $0x801071e9
80103972:	e8 c1 c9 ff ff       	call   80100338 <panic>
    panic("sched running");
80103977:	83 ec 0c             	sub    $0xc,%esp
8010397a:	68 db 71 10 80       	push   $0x801071db
8010397f:	e8 b4 c9 ff ff       	call   80100338 <panic>
    panic("sched locks");
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	68 cf 71 10 80       	push   $0x801071cf
8010398c:	e8 a7 c9 ff ff       	call   80100338 <panic>
80103991:	8d 76 00             	lea    0x0(%esi),%esi

80103994 <exit>:
{
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	57                   	push   %edi
80103998:	56                   	push   %esi
80103999:	53                   	push   %ebx
8010399a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010399d:	e8 66 fc ff ff       	call   80103608 <myproc>
  if(curproc == initproc)
801039a2:	39 05 54 4f 11 80    	cmp    %eax,0x80114f54
801039a8:	0f 84 b1 01 00 00    	je     80103b5f <exit+0x1cb>
801039ae:	89 c3                	mov    %eax,%ebx
801039b0:	8d 70 74             	lea    0x74(%eax),%esi
801039b3:	8d b8 b4 00 00 00    	lea    0xb4(%eax),%edi
801039b9:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801039bc:	8b 06                	mov    (%esi),%eax
801039be:	85 c0                	test   %eax,%eax
801039c0:	74 12                	je     801039d4 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801039c2:	83 ec 0c             	sub    $0xc,%esp
801039c5:	50                   	push   %eax
801039c6:	e8 89 d5 ff ff       	call   80100f54 <fileclose>
      curproc->ofile[fd] = 0;
801039cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801039d1:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801039d4:	83 c6 04             	add    $0x4,%esi
801039d7:	39 fe                	cmp    %edi,%esi
801039d9:	75 e1                	jne    801039bc <exit+0x28>
  begin_op();
801039db:	e8 e4 f0 ff ff       	call   80102ac4 <begin_op>
  iput(curproc->cwd);
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
801039e9:	e8 46 de ff ff       	call   80101834 <iput>
  end_op();
801039ee:	e8 39 f1 ff ff       	call   80102b2c <end_op>
  curproc->cwd = 0;
801039f3:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
801039fa:	00 00 00 
  acquire(&ptable.lock);
801039fd:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a04:	e8 ff 0b 00 00       	call   80104608 <acquire>
  wakeup1(curproc->parent);
80103a09:	8b 53 60             	mov    0x60(%ebx),%edx
80103a0c:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a0f:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103a14:	eb 0e                	jmp    80103a24 <exit+0x90>
80103a16:	66 90                	xchg   %ax,%ax
80103a18:	05 c8 00 00 00       	add    $0xc8,%eax
80103a1d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103a22:	74 25                	je     80103a49 <exit+0xb5>
   { 
          if(p->state == SLEEPING && p->chan == chan && !p->suspended)
80103a24:	83 78 58 02          	cmpl   $0x2,0x58(%eax)
80103a28:	75 ee                	jne    80103a18 <exit+0x84>
80103a2a:	3b 50 6c             	cmp    0x6c(%eax),%edx
80103a2d:	75 e9                	jne    80103a18 <exit+0x84>
80103a2f:	8b 78 10             	mov    0x10(%eax),%edi
80103a32:	85 ff                	test   %edi,%edi
80103a34:	75 e2                	jne    80103a18 <exit+0x84>
             {   
               p->state = RUNNABLE;
80103a36:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a3d:	05 c8 00 00 00       	add    $0xc8,%eax
80103a42:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103a47:	75 db                	jne    80103a24 <exit+0x90>
      p->parent = initproc;
80103a49:	8b 0d 54 4f 11 80    	mov    0x80114f54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a4f:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103a54:	eb 10                	jmp    80103a66 <exit+0xd2>
80103a56:	66 90                	xchg   %ax,%ax
80103a58:	81 c2 c8 00 00 00    	add    $0xc8,%edx
80103a5e:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103a64:	74 3d                	je     80103aa3 <exit+0x10f>
    if(p->parent == curproc){
80103a66:	39 5a 60             	cmp    %ebx,0x60(%edx)
80103a69:	75 ed                	jne    80103a58 <exit+0xc4>
      p->parent = initproc;
80103a6b:	89 4a 60             	mov    %ecx,0x60(%edx)
      if(p->state == ZOMBIE)
80103a6e:	83 7a 58 06          	cmpl   $0x6,0x58(%edx)
80103a72:	75 e4                	jne    80103a58 <exit+0xc4>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a74:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103a79:	eb 0d                	jmp    80103a88 <exit+0xf4>
80103a7b:	90                   	nop
80103a7c:	05 c8 00 00 00       	add    $0xc8,%eax
80103a81:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103a86:	74 d0                	je     80103a58 <exit+0xc4>
          if(p->state == SLEEPING && p->chan == chan && !p->suspended)
80103a88:	83 78 58 02          	cmpl   $0x2,0x58(%eax)
80103a8c:	75 ee                	jne    80103a7c <exit+0xe8>
80103a8e:	3b 48 6c             	cmp    0x6c(%eax),%ecx
80103a91:	75 e9                	jne    80103a7c <exit+0xe8>
80103a93:	8b 70 10             	mov    0x10(%eax),%esi
80103a96:	85 f6                	test   %esi,%esi
80103a98:	75 e2                	jne    80103a7c <exit+0xe8>
               p->state = RUNNABLE;
80103a9a:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
80103aa1:	eb d9                	jmp    80103a7c <exit+0xe8>
curproc->end_time = ticks;
80103aa3:	8b 35 60 4f 11 80    	mov    0x80114f60,%esi
80103aa9:	89 73 30             	mov    %esi,0x30(%ebx)
int tat = curproc->end_time - curproc->creation_time;
80103aac:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103aaf:	29 c6                	sub    %eax,%esi
int wt = tat - curproc->total_run_time - curproc->total_sleeping_time;
80103ab1:	89 f2                	mov    %esi,%edx
80103ab3:	2b 53 38             	sub    0x38(%ebx),%edx
80103ab6:	2b 53 4c             	sub    0x4c(%ebx),%edx
80103ab9:	89 55 e0             	mov    %edx,-0x20(%ebp)
int rt = curproc->first_run_time - curproc->creation_time;
80103abc:	8b 7b 34             	mov    0x34(%ebx),%edi
80103abf:	29 c7                	sub    %eax,%edi
80103ac1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
int cs = curproc->context_switches-1;
80103ac4:	8b 43 40             	mov    0x40(%ebx),%eax
80103ac7:	8d 78 ff             	lea    -0x1(%eax),%edi
cprintf("PID: %d\n", curproc->pid);
80103aca:	83 ec 08             	sub    $0x8,%esp
80103acd:	ff 73 5c             	push   0x5c(%ebx)
80103ad0:	68 0a 72 10 80       	push   $0x8010720a
80103ad5:	e8 46 cb ff ff       	call   80100620 <cprintf>
cprintf("TAT: %d\n", tat);
80103ada:	5a                   	pop    %edx
80103adb:	59                   	pop    %ecx
80103adc:	56                   	push   %esi
80103add:	68 13 72 10 80       	push   $0x80107213
80103ae2:	e8 39 cb ff ff       	call   80100620 <cprintf>
cprintf("WT: %d\n", wt);
80103ae7:	5e                   	pop    %esi
80103ae8:	58                   	pop    %eax
80103ae9:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103aec:	52                   	push   %edx
80103aed:	68 1c 72 10 80       	push   $0x8010721c
80103af2:	e8 29 cb ff ff       	call   80100620 <cprintf>
cprintf("RT: %d\n", rt);
80103af7:	58                   	pop    %eax
80103af8:	5a                   	pop    %edx
80103af9:	ff 75 e4             	push   -0x1c(%ebp)
80103afc:	68 24 72 10 80       	push   $0x80107224
80103b01:	e8 1a cb ff ff       	call   80100620 <cprintf>
cprintf("#CS: %d\n", cs);
80103b06:	59                   	pop    %ecx
80103b07:	5e                   	pop    %esi
80103b08:	57                   	push   %edi
80103b09:	68 2c 72 10 80       	push   $0x8010722c
80103b0e:	e8 0d cb ff ff       	call   80100620 <cprintf>
cprintf("Sleeping Time: %d\n", curproc->total_sleeping_time);
80103b13:	5f                   	pop    %edi
80103b14:	58                   	pop    %eax
80103b15:	ff 73 4c             	push   0x4c(%ebx)
80103b18:	68 35 72 10 80       	push   $0x80107235
80103b1d:	e8 fe ca ff ff       	call   80100620 <cprintf>
  if(curproc->state == ZOMBIE) {
80103b22:	83 c4 10             	add    $0x10,%esp
80103b25:	83 7b 58 06          	cmpl   $0x6,0x58(%ebx)
80103b29:	74 19                	je     80103b44 <exit+0x1b0>
  curproc->state = ZOMBIE;
80103b2b:	c7 43 58 06 00 00 00 	movl   $0x6,0x58(%ebx)
  sched();
80103b32:	e8 a9 fd ff ff       	call   801038e0 <sched>
  panic("zombie exit");
80103b37:	83 ec 0c             	sub    $0xc,%esp
80103b3a:	68 48 72 10 80       	push   $0x80107248
80103b3f:	e8 f4 c7 ff ff       	call   80100338 <panic>
    cprintf("exit(): process %d already zombie, panic!\n", curproc->pid);
80103b44:	50                   	push   %eax
80103b45:	50                   	push   %eax
80103b46:	ff 73 5c             	push   0x5c(%ebx)
80103b49:	68 ac 75 10 80       	push   $0x801075ac
80103b4e:	e8 cd ca ff ff       	call   80100620 <cprintf>
    panic("zombie exit");
80103b53:	c7 04 24 48 72 10 80 	movl   $0x80107248,(%esp)
80103b5a:	e8 d9 c7 ff ff       	call   80100338 <panic>
    panic("init exiting");
80103b5f:	83 ec 0c             	sub    $0xc,%esp
80103b62:	68 fd 71 10 80       	push   $0x801071fd
80103b67:	e8 cc c7 ff ff       	call   80100338 <panic>

80103b6c <yield>:
{
80103b6c:	55                   	push   %ebp
80103b6d:	89 e5                	mov    %esp,%ebp
80103b6f:	53                   	push   %ebx
80103b70:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103b73:	68 20 1d 11 80       	push   $0x80111d20
80103b78:	e8 8b 0a 00 00       	call   80104608 <acquire>
  pushcli();
80103b7d:	e8 42 09 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103b82:	e8 e9 f9 ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103b87:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b8d:	e8 7e 09 00 00       	call   80104510 <popcli>
  if(myproc()->state == SUSPENDED){
80103b92:	83 c4 10             	add    $0x10,%esp
80103b95:	83 7b 58 08          	cmpl   $0x8,0x58(%ebx)
80103b99:	74 1c                	je     80103bb7 <yield+0x4b>
  pushcli();
80103b9b:	e8 24 09 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103ba0:	e8 cb f9 ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103ba5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bab:	e8 60 09 00 00       	call   80104510 <popcli>
    myproc()->state = RUNNABLE;
80103bb0:	c7 43 58 04 00 00 00 	movl   $0x4,0x58(%ebx)
    sched();
80103bb7:	e8 24 fd ff ff       	call   801038e0 <sched>
  release(&ptable.lock);
80103bbc:	83 ec 0c             	sub    $0xc,%esp
80103bbf:	68 20 1d 11 80       	push   $0x80111d20
80103bc4:	e8 df 09 00 00       	call   801045a8 <release>
}
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bcf:	c9                   	leave
80103bd0:	c3                   	ret
80103bd1:	8d 76 00             	lea    0x0(%esi),%esi

80103bd4 <sleep>:
{
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 1c             	sub    $0x1c,%esp
80103bdd:	8b 7d 08             	mov    0x8(%ebp),%edi
80103be0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103be3:	e8 dc 08 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103be8:	e8 83 f9 ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103bed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf3:	e8 18 09 00 00       	call   80104510 <popcli>
  if(p == 0)
80103bf8:	85 db                	test   %ebx,%ebx
80103bfa:	0f 84 be 00 00 00    	je     80103cbe <sleep+0xea>
  if(lk == 0)
80103c00:	85 f6                	test   %esi,%esi
80103c02:	0f 84 a9 00 00 00    	je     80103cb1 <sleep+0xdd>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c08:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103c0e:	74 6c                	je     80103c7c <sleep+0xa8>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	68 20 1d 11 80       	push   $0x80111d20
80103c18:	e8 eb 09 00 00       	call   80104608 <acquire>
    release(lk);
80103c1d:	89 34 24             	mov    %esi,(%esp)
80103c20:	e8 83 09 00 00       	call   801045a8 <release>
  int sleep_start_tick=ticks;
80103c25:	8b 15 60 4f 11 80    	mov    0x80114f60,%edx
80103c2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  p->chan = chan;
80103c2e:	89 7b 6c             	mov    %edi,0x6c(%ebx)
  p->state = SLEEPING;
80103c31:	c7 43 58 02 00 00 00 	movl   $0x2,0x58(%ebx)
  sched();
80103c38:	e8 a3 fc ff ff       	call   801038e0 <sched>
  p->total_sleeping_time += (ticks - sleep_start_tick);
80103c3d:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80103c42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c45:	29 d0                	sub    %edx,%eax
80103c47:	01 43 4c             	add    %eax,0x4c(%ebx)
  p->chan = 0;
80103c4a:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
   if(p->killed){
80103c51:	83 c4 10             	add    $0x10,%esp
80103c54:	8b 53 70             	mov    0x70(%ebx),%edx
80103c57:	85 d2                	test   %edx,%edx
80103c59:	75 70                	jne    80103ccb <sleep+0xf7>
    release(&ptable.lock);
80103c5b:	83 ec 0c             	sub    $0xc,%esp
80103c5e:	68 20 1d 11 80       	push   $0x80111d20
80103c63:	e8 40 09 00 00       	call   801045a8 <release>
    acquire(lk);
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c71:	5b                   	pop    %ebx
80103c72:	5e                   	pop    %esi
80103c73:	5f                   	pop    %edi
80103c74:	5d                   	pop    %ebp
    acquire(lk);
80103c75:	e9 8e 09 00 00       	jmp    80104608 <acquire>
80103c7a:	66 90                	xchg   %ax,%ax
  int sleep_start_tick=ticks;
80103c7c:	8b 35 60 4f 11 80    	mov    0x80114f60,%esi
  p->chan = chan;
80103c82:	89 7b 6c             	mov    %edi,0x6c(%ebx)
  p->state = SLEEPING;
80103c85:	c7 43 58 02 00 00 00 	movl   $0x2,0x58(%ebx)
  sched();
80103c8c:	e8 4f fc ff ff       	call   801038e0 <sched>
  p->total_sleeping_time += (ticks - sleep_start_tick);
80103c91:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80103c96:	29 f0                	sub    %esi,%eax
80103c98:	01 43 4c             	add    %eax,0x4c(%ebx)
  p->chan = 0;
80103c9b:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
   if(p->killed){
80103ca2:	8b 43 70             	mov    0x70(%ebx),%eax
80103ca5:	85 c0                	test   %eax,%eax
80103ca7:	75 22                	jne    80103ccb <sleep+0xf7>
}
80103ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cac:	5b                   	pop    %ebx
80103cad:	5e                   	pop    %esi
80103cae:	5f                   	pop    %edi
80103caf:	5d                   	pop    %ebp
80103cb0:	c3                   	ret
    panic("sleep without lk");
80103cb1:	83 ec 0c             	sub    $0xc,%esp
80103cb4:	68 5a 72 10 80       	push   $0x8010725a
80103cb9:	e8 7a c6 ff ff       	call   80100338 <panic>
    panic("sleep");
80103cbe:	83 ec 0c             	sub    $0xc,%esp
80103cc1:	68 54 72 10 80       	push   $0x80107254
80103cc6:	e8 6d c6 ff ff       	call   80100338 <panic>
        release(&ptable.lock);
80103ccb:	83 ec 0c             	sub    $0xc,%esp
80103cce:	68 20 1d 11 80       	push   $0x80111d20
80103cd3:	e8 d0 08 00 00       	call   801045a8 <release>
        exit();
80103cd8:	e8 b7 fc ff ff       	call   80103994 <exit>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi

80103ce0 <wait>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 da 07 00 00       	call   801044c4 <pushcli>
  c = mycpu();
80103cea:	e8 81 f8 ff ff       	call   80103570 <mycpu>
  p = c->proc;
80103cef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cf5:	e8 16 08 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 20 1d 11 80       	push   $0x80111d20
80103d02:	e8 01 09 00 00       	call   80104608 <acquire>
80103d07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103d0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103d11:	eb 0f                	jmp    80103d22 <wait+0x42>
80103d13:	90                   	nop
80103d14:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103d1a:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103d20:	74 1e                	je     80103d40 <wait+0x60>
      if(p->parent != curproc)
80103d22:	39 73 60             	cmp    %esi,0x60(%ebx)
80103d25:	75 ed                	jne    80103d14 <wait+0x34>
      if(p->state == ZOMBIE){
80103d27:	83 7b 58 06          	cmpl   $0x6,0x58(%ebx)
80103d2b:	74 33                	je     80103d60 <wait+0x80>
      havekids = 1;
80103d2d:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d32:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103d38:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103d3e:	75 e2                	jne    80103d22 <wait+0x42>
    if(!havekids || curproc->killed){
80103d40:	85 c0                	test   %eax,%eax
80103d42:	74 75                	je     80103db9 <wait+0xd9>
80103d44:	8b 46 70             	mov    0x70(%esi),%eax
80103d47:	85 c0                	test   %eax,%eax
80103d49:	75 6e                	jne    80103db9 <wait+0xd9>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d4b:	83 ec 08             	sub    $0x8,%esp
80103d4e:	68 20 1d 11 80       	push   $0x80111d20
80103d53:	56                   	push   %esi
80103d54:	e8 7b fe ff ff       	call   80103bd4 <sleep>
    havekids = 0;
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	eb ac                	jmp    80103d0a <wait+0x2a>
80103d5e:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80103d60:	8b 73 5c             	mov    0x5c(%ebx),%esi
        kfree(p->kstack);
80103d63:	83 ec 0c             	sub    $0xc,%esp
80103d66:	ff 73 54             	push   0x54(%ebx)
80103d69:	e8 9e e5 ff ff       	call   8010230c <kfree>
        p->kstack = 0;
80103d6e:	c7 43 54 00 00 00 00 	movl   $0x0,0x54(%ebx)
        freevm(p->pgdir);
80103d75:	5a                   	pop    %edx
80103d76:	ff 73 50             	push   0x50(%ebx)
80103d79:	e8 ea 2d 00 00       	call   80106b68 <freevm>
        p->pid = 0;
80103d7e:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
        p->parent = 0;
80103d85:	c7 43 60 00 00 00 00 	movl   $0x0,0x60(%ebx)
        p->name[0] = 0;
80103d8c:	c6 83 b8 00 00 00 00 	movb   $0x0,0xb8(%ebx)
        p->killed = 0;
80103d93:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
        p->state = UNUSED;
80103d9a:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
        release(&ptable.lock);
80103da1:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103da8:	e8 fb 07 00 00       	call   801045a8 <release>
        return pid;
80103dad:	83 c4 10             	add    $0x10,%esp
}
80103db0:	89 f0                	mov    %esi,%eax
80103db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db5:	5b                   	pop    %ebx
80103db6:	5e                   	pop    %esi
80103db7:	5d                   	pop    %ebp
80103db8:	c3                   	ret
      release(&ptable.lock);
80103db9:	83 ec 0c             	sub    $0xc,%esp
80103dbc:	68 20 1d 11 80       	push   $0x80111d20
80103dc1:	e8 e2 07 00 00       	call   801045a8 <release>
      return -1;
80103dc6:	83 c4 10             	add    $0x10,%esp
80103dc9:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103dce:	eb e0                	jmp    80103db0 <wait+0xd0>

80103dd0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 10             	sub    $0x10,%esp
80103dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dda:	68 20 1d 11 80       	push   $0x80111d20
80103ddf:	e8 24 08 00 00       	call   80104608 <acquire>
80103de4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103dec:	eb 0e                	jmp    80103dfc <wakeup+0x2c>
80103dee:	66 90                	xchg   %ax,%ax
80103df0:	05 c8 00 00 00       	add    $0xc8,%eax
80103df5:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103dfa:	74 25                	je     80103e21 <wakeup+0x51>
          if(p->state == SLEEPING && p->chan == chan && !p->suspended)
80103dfc:	83 78 58 02          	cmpl   $0x2,0x58(%eax)
80103e00:	75 ee                	jne    80103df0 <wakeup+0x20>
80103e02:	3b 58 6c             	cmp    0x6c(%eax),%ebx
80103e05:	75 e9                	jne    80103df0 <wakeup+0x20>
80103e07:	8b 50 10             	mov    0x10(%eax),%edx
80103e0a:	85 d2                	test   %edx,%edx
80103e0c:	75 e2                	jne    80103df0 <wakeup+0x20>
               p->state = RUNNABLE;
80103e0e:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e15:	05 c8 00 00 00       	add    $0xc8,%eax
80103e1a:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103e1f:	75 db                	jne    80103dfc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103e21:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80103e28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e2b:	c9                   	leave
  release(&ptable.lock);
80103e2c:	e9 77 07 00 00       	jmp    801045a8 <release>
80103e31:	8d 76 00             	lea    0x0(%esi),%esi

80103e34 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	53                   	push   %ebx
80103e38:	83 ec 10             	sub    $0x10,%esp
80103e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e3e:	68 20 1d 11 80       	push   $0x80111d20
80103e43:	e8 c0 07 00 00       	call   80104608 <acquire>
80103e48:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4b:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e50:	eb 0e                	jmp    80103e60 <kill+0x2c>
80103e52:	66 90                	xchg   %ax,%ax
80103e54:	05 c8 00 00 00       	add    $0xc8,%eax
80103e59:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103e5e:	74 30                	je     80103e90 <kill+0x5c>
    if(p->pid == pid){
80103e60:	39 58 5c             	cmp    %ebx,0x5c(%eax)
80103e63:	75 ef                	jne    80103e54 <kill+0x20>
      p->killed = 1;
80103e65:	c7 40 70 01 00 00 00 	movl   $0x1,0x70(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e6c:	83 78 58 02          	cmpl   $0x2,0x58(%eax)
80103e70:	75 07                	jne    80103e79 <kill+0x45>
        p->state = RUNNABLE;
80103e72:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
      release(&ptable.lock);
80103e79:	83 ec 0c             	sub    $0xc,%esp
80103e7c:	68 20 1d 11 80       	push   $0x80111d20
80103e81:	e8 22 07 00 00       	call   801045a8 <release>
      return 0;
80103e86:	83 c4 10             	add    $0x10,%esp
80103e89:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e8e:	c9                   	leave
80103e8f:	c3                   	ret
  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 20 1d 11 80       	push   $0x80111d20
80103e98:	e8 0b 07 00 00       	call   801045a8 <release>
  return -1;
80103e9d:	83 c4 10             	add    $0x10,%esp
80103ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ea8:	c9                   	leave
80103ea9:	c3                   	ret
80103eaa:	66 90                	xchg   %ax,%ax

80103eac <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103eac:	55                   	push   %ebp
80103ead:	89 e5                	mov    %esp,%ebp
80103eaf:	57                   	push   %edi
80103eb0:	56                   	push   %esi
80103eb1:	53                   	push   %ebx
80103eb2:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb5:	bb 0c 1e 11 80       	mov    $0x80111e0c,%ebx
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103eba:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103ebd:	eb 42                	jmp    80103f01 <procdump+0x55>
80103ebf:	90                   	nop
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ec0:	8b 04 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%eax
80103ec7:	85 c0                	test   %eax,%eax
80103ec9:	74 42                	je     80103f0d <procdump+0x61>
    cprintf("%d %s %s", p->pid, state, p->name);
80103ecb:	53                   	push   %ebx
80103ecc:	50                   	push   %eax
80103ecd:	ff 73 a4             	push   -0x5c(%ebx)
80103ed0:	68 6f 72 10 80       	push   $0x8010726f
80103ed5:	e8 46 c7 ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
80103eda:	83 c4 10             	add    $0x10,%esp
80103edd:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ee1:	74 31                	je     80103f14 <procdump+0x68>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ee3:	83 ec 0c             	sub    $0xc,%esp
80103ee6:	68 3f 74 10 80       	push   $0x8010743f
80103eeb:	e8 30 c7 ff ff       	call   80100620 <cprintf>
80103ef0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef3:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103ef9:	81 fb 0c 50 11 80    	cmp    $0x8011500c,%ebx
80103eff:	74 4f                	je     80103f50 <procdump+0xa4>
    if(p->state == UNUSED)
80103f01:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	74 eb                	je     80103ef3 <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f08:	83 f8 08             	cmp    $0x8,%eax
80103f0b:	76 b3                	jbe    80103ec0 <procdump+0x14>
      state = "???";
80103f0d:	b8 6b 72 10 80       	mov    $0x8010726b,%eax
80103f12:	eb b7                	jmp    80103ecb <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f14:	83 ec 08             	sub    $0x8,%esp
80103f17:	56                   	push   %esi
80103f18:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f1b:	8b 40 0c             	mov    0xc(%eax),%eax
80103f1e:	83 c0 08             	add    $0x8,%eax
80103f21:	50                   	push   %eax
80103f22:	e8 35 05 00 00       	call   8010445c <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f27:	89 f7                	mov    %esi,%edi
80103f29:	83 c4 10             	add    $0x10,%esp
80103f2c:	8b 07                	mov    (%edi),%eax
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	74 b1                	je     80103ee3 <procdump+0x37>
        cprintf(" %p", pc[i]);
80103f32:	83 ec 08             	sub    $0x8,%esp
80103f35:	50                   	push   %eax
80103f36:	68 01 6f 10 80       	push   $0x80106f01
80103f3b:	e8 e0 c6 ff ff       	call   80100620 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f40:	83 c7 04             	add    $0x4,%edi
80103f43:	83 c4 10             	add    $0x10,%esp
80103f46:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103f49:	39 c7                	cmp    %eax,%edi
80103f4b:	75 df                	jne    80103f2c <procdump+0x80>
80103f4d:	eb 94                	jmp    80103ee3 <procdump+0x37>
80103f4f:	90                   	nop
  }
}
80103f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f53:	5b                   	pop    %ebx
80103f54:	5e                   	pop    %esi
80103f55:	5f                   	pop    %edi
80103f56:	5d                   	pop    %ebp
80103f57:	c3                   	ret

80103f58 <sys_custom_fork>:

//..........................................................

int sys_custom_fork(void) {
80103f58:	55                   	push   %ebp
80103f59:	89 e5                	mov    %esp,%ebp
80103f5b:	53                   	push   %ebx
80103f5c:	83 ec 1c             	sub    $0x1c,%esp
    int start_later, exec_time;
    if (argint(0, &start_later) < 0 || argint(1, &exec_time) < -1)
80103f5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80103f62:	50                   	push   %eax
80103f63:	6a 00                	push   $0x0
80103f65:	e8 86 09 00 00       	call   801048f0 <argint>
80103f6a:	83 c4 10             	add    $0x10,%esp
80103f6d:	85 c0                	test   %eax,%eax
80103f6f:	78 63                	js     80103fd4 <sys_custom_fork+0x7c>
80103f71:	83 ec 08             	sub    $0x8,%esp
80103f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103f77:	50                   	push   %eax
80103f78:	6a 01                	push   $0x1
80103f7a:	e8 71 09 00 00       	call   801048f0 <argint>
80103f7f:	83 c4 10             	add    $0x10,%esp
80103f82:	40                   	inc    %eax
80103f83:	7c 4f                	jl     80103fd4 <sys_custom_fork+0x7c>
        return -1;

    int pid = fork();
80103f85:	e8 fa f7 ff ff       	call   80103784 <fork>
    if (pid < 0) return -1;
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	78 46                	js     80103fd4 <sys_custom_fork+0x7c>
    if (pid == 0) return 0; 
80103f8e:	74 31                	je     80103fc1 <sys_custom_fork+0x69>
   
    
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f90:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f95:	eb 0f                	jmp    80103fa6 <sys_custom_fork+0x4e>
80103f97:	90                   	nop
80103f98:	81 c2 c8 00 00 00    	add    $0xc8,%edx
80103f9e:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103fa4:	74 1b                	je     80103fc1 <sys_custom_fork+0x69>
        if (p->pid == pid) {
80103fa6:	39 42 5c             	cmp    %eax,0x5c(%edx)
80103fa9:	75 ed                	jne    80103f98 <sys_custom_fork+0x40>
            p->start_later = start_later;
80103fab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80103fae:	89 4a 20             	mov    %ecx,0x20(%edx)
            p->exec_time = exec_time;
80103fb1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103fb4:	89 5a 24             	mov    %ebx,0x24(%edx)
            // acquire(&ptable.lock);
            if (start_later == 1)
80103fb7:	49                   	dec    %ecx
80103fb8:	74 0e                	je     80103fc8 <sys_custom_fork+0x70>
                p->state = WAITING_TO_START ;  
            else
                p->state = RUNNABLE;
80103fba:	c7 42 58 04 00 00 00 	movl   $0x4,0x58(%edx)
            // release(&ptable.lock);
            break;
        }
    }
    return pid;
}
80103fc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc4:	c9                   	leave
80103fc5:	c3                   	ret
80103fc6:	66 90                	xchg   %ax,%ax
                p->state = WAITING_TO_START ;  
80103fc8:	c7 42 58 03 00 00 00 	movl   $0x3,0x58(%edx)
}
80103fcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd2:	c9                   	leave
80103fd3:	c3                   	ret
        return -1;
80103fd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd9:	eb e6                	jmp    80103fc1 <sys_custom_fork+0x69>
80103fdb:	90                   	nop

80103fdc <sys_scheduler_start>:


int sys_scheduler_start(void) {
80103fdc:	55                   	push   %ebp
80103fdd:	89 e5                	mov    %esp,%ebp
80103fdf:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;
    acquire(&ptable.lock);
80103fe2:	68 20 1d 11 80       	push   $0x80111d20
80103fe7:	e8 1c 06 00 00       	call   80104608 <acquire>
80103fec:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fef:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103ff4:	eb 0e                	jmp    80104004 <sys_scheduler_start+0x28>
80103ff6:	66 90                	xchg   %ax,%ax
80103ff8:	05 c8 00 00 00       	add    $0xc8,%eax
80103ffd:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104002:	74 26                	je     8010402a <sys_scheduler_start+0x4e>
         if(p->start_later == 1 && p->state == WAITING_TO_START) {
80104004:	83 78 20 01          	cmpl   $0x1,0x20(%eax)
80104008:	75 ee                	jne    80103ff8 <sys_scheduler_start+0x1c>
8010400a:	83 78 58 03          	cmpl   $0x3,0x58(%eax)
8010400e:	75 e8                	jne    80103ff8 <sys_scheduler_start+0x1c>
              p->state = RUNNABLE;
80104010:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
              p->start_later = 0;
80104017:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010401e:	05 c8 00 00 00       	add    $0xc8,%eax
80104023:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104028:	75 da                	jne    80104004 <sys_scheduler_start+0x28>
          }

    }
    release(&ptable.lock);
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 20 1d 11 80       	push   $0x80111d20
80104032:	e8 71 05 00 00       	call   801045a8 <release>
    return 0;
}
80104037:	31 c0                	xor    %eax,%eax
80104039:	c9                   	leave
8010403a:	c3                   	ret
8010403b:	90                   	nop

8010403c <send_signal_to_all>:
//   }
//   release(&ptable.lock);
// }


void send_signal_to_all(int sig){
8010403c:	55                   	push   %ebp
8010403d:	89 e5                	mov    %esp,%ebp
8010403f:	56                   	push   %esi
80104040:	53                   	push   %ebx
80104041:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;
    acquire(&ptable.lock);
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	68 20 1d 11 80       	push   $0x80111d20
8010404c:	e8 b7 05 00 00       	call   80104608 <acquire>

                    }
                    struct proc *itr;
                    for(itr = ptable.proc; itr < &ptable.proc[NPROC]; itr++){
                      if(itr->pid > 2 ){
                        itr->parent = initproc;
80104051:	8b 0d 54 4f 11 80    	mov    0x80114f54,%ecx
80104057:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405a:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
8010405f:	90                   	nop
         if (p->pid == 1 ) continue;
80104060:	8b 42 5c             	mov    0x5c(%edx),%eax
80104063:	83 f8 01             	cmp    $0x1,%eax
80104066:	74 64                	je     801040cc <send_signal_to_all+0x90>
         if (p->pid == 2){
80104068:	83 f8 02             	cmp    $0x2,%eax
8010406b:	0f 84 c3 00 00 00    	je     80104134 <send_signal_to_all+0xf8>
         if(p->state == UNUSED ){
80104071:	8b 42 58             	mov    0x58(%edx),%eax
80104074:	85 c0                	test   %eax,%eax
80104076:	74 54                	je     801040cc <send_signal_to_all+0x90>
          switch(sig) {
80104078:	83 fb 03             	cmp    $0x3,%ebx
8010407b:	0f 84 ab 00 00 00    	je     8010412c <send_signal_to_all+0xf0>
80104081:	0f 8f d1 00 00 00    	jg     80104158 <send_signal_to_all+0x11c>
80104087:	83 fb 01             	cmp    $0x1,%ebx
8010408a:	0f 84 0c 01 00 00    	je     8010419c <send_signal_to_all+0x160>
80104090:	83 fb 02             	cmp    $0x2,%ebx
80104093:	75 37                	jne    801040cc <send_signal_to_all+0x90>
                  if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING || p->state == WAITING_TO_START || p->state == STOPPED){
80104095:	8d 70 fe             	lea    -0x2(%eax),%esi
80104098:	83 fe 03             	cmp    $0x3,%esi
8010409b:	0f 86 27 01 00 00    	jbe    801041c8 <send_signal_to_all+0x18c>
801040a1:	83 f8 07             	cmp    $0x7,%eax
801040a4:	0f 84 1e 01 00 00    	je     801041c8 <send_signal_to_all+0x18c>
801040aa:	66 90                	xchg   %ax,%ax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ac:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801040b1:	8d 76 00             	lea    0x0(%esi),%esi
                      if(itr->pid > 2 ){
801040b4:	83 78 5c 02          	cmpl   $0x2,0x5c(%eax)
801040b8:	7e 03                	jle    801040bd <send_signal_to_all+0x81>
                        itr->parent = initproc;
801040ba:	89 48 60             	mov    %ecx,0x60(%eax)
                    for(itr = ptable.proc; itr < &ptable.proc[NPROC]; itr++){
801040bd:	05 c8 00 00 00       	add    $0xc8,%eax
801040c2:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801040c7:	75 eb                	jne    801040b4 <send_signal_to_all+0x78>
801040c9:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040cc:	81 c2 c8 00 00 00    	add    $0xc8,%edx
801040d2:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
801040d8:	75 86                	jne    80104060 <send_signal_to_all+0x24>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040da:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801040df:	eb 0f                	jmp    801040f0 <send_signal_to_all+0xb4>
801040e1:	8d 76 00             	lea    0x0(%esi),%esi
801040e4:	05 c8 00 00 00       	add    $0xc8,%eax
801040e9:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801040ee:	74 29                	je     80104119 <send_signal_to_all+0xdd>
          if(p->state == SLEEPING && p->chan == chan && !p->suspended)
801040f0:	83 78 58 02          	cmpl   $0x2,0x58(%eax)
801040f4:	75 ee                	jne    801040e4 <send_signal_to_all+0xa8>
801040f6:	81 78 6c 1c 1e 11 80 	cmpl   $0x80111e1c,0x6c(%eax)
801040fd:	75 e5                	jne    801040e4 <send_signal_to_all+0xa8>
801040ff:	8b 50 10             	mov    0x10(%eax),%edx
80104102:	85 d2                	test   %edx,%edx
80104104:	75 de                	jne    801040e4 <send_signal_to_all+0xa8>
               p->state = RUNNABLE;
80104106:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410d:	05 c8 00 00 00       	add    $0xc8,%eax
80104112:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104117:	75 d7                	jne    801040f0 <send_signal_to_all+0xb4>
                break;
        }       
    }
   wakeup1(ptable.proc+1);// wake up shell
   
    release(&ptable.lock);
80104119:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80104120:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104123:	5b                   	pop    %ebx
80104124:	5e                   	pop    %esi
80104125:	5d                   	pop    %ebp
    release(&ptable.lock);
80104126:	e9 7d 04 00 00       	jmp    801045a8 <release>
8010412b:	90                   	nop
                  if(p->state == SUSPENDED)
8010412c:	83 f8 08             	cmp    $0x8,%eax
8010412f:	75 9b                	jne    801040cc <send_signal_to_all+0x90>
80104131:	8d 76 00             	lea    0x0(%esi),%esi
                     p->suspended = 0;  
80104134:	c7 42 10 00 00 00 00 	movl   $0x0,0x10(%edx)
                     p->state = RUNNABLE;  
8010413b:	c7 42 58 04 00 00 00 	movl   $0x4,0x58(%edx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104142:	81 c2 c8 00 00 00    	add    $0xc8,%edx
80104148:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
8010414e:	0f 85 0c ff ff ff    	jne    80104060 <send_signal_to_all+0x24>
80104154:	eb 84                	jmp    801040da <send_signal_to_all+0x9e>
80104156:	66 90                	xchg   %ax,%ax
          switch(sig) {
80104158:	83 fb 04             	cmp    $0x4,%ebx
8010415b:	0f 85 6b ff ff ff    	jne    801040cc <send_signal_to_all+0x90>
                 if(p->signal_handler){
80104161:	8b 72 0c             	mov    0xc(%edx),%esi
80104164:	85 f6                	test   %esi,%esi
80104166:	0f 84 60 ff ff ff    	je     801040cc <send_signal_to_all+0x90>
                     p->pending_signal = SIGCUSTOM;
8010416c:	c7 42 08 04 00 00 00 	movl   $0x4,0x8(%edx)
                     if(p->state == SLEEPING)
80104173:	83 f8 02             	cmp    $0x2,%eax
80104176:	0f 85 50 ff ff ff    	jne    801040cc <send_signal_to_all+0x90>
                        p->state = RUNNABLE;
8010417c:	c7 42 58 04 00 00 00 	movl   $0x4,0x58(%edx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104183:	81 c2 c8 00 00 00    	add    $0xc8,%edx
80104189:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
8010418f:	0f 85 cb fe ff ff    	jne    80104060 <send_signal_to_all+0x24>
80104195:	e9 40 ff ff ff       	jmp    801040da <send_signal_to_all+0x9e>
8010419a:	66 90                	xchg   %ax,%ax
                p->killed = 1;   
8010419c:	c7 42 70 01 00 00 00 	movl   $0x1,0x70(%edx)
                if(p->state == SLEEPING || p->state == SUSPENDED || p->state == WAITING_TO_START  || p->state == RUNNABLE)
801041a3:	8d 70 fe             	lea    -0x2(%eax),%esi
801041a6:	83 fe 02             	cmp    $0x2,%esi
801041a9:	76 d1                	jbe    8010417c <send_signal_to_all+0x140>
801041ab:	83 f8 08             	cmp    $0x8,%eax
801041ae:	74 cc                	je     8010417c <send_signal_to_all+0x140>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b0:	81 c2 c8 00 00 00    	add    $0xc8,%edx
801041b6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
801041bc:	0f 85 9e fe ff ff    	jne    80104060 <send_signal_to_all+0x24>
801041c2:	e9 13 ff ff ff       	jmp    801040da <send_signal_to_all+0x9e>
801041c7:	90                   	nop
                      p->state = SUSPENDED;
801041c8:	c7 42 58 08 00 00 00 	movl   $0x8,0x58(%edx)
                      p->suspended = 1;
801041cf:	c7 42 10 01 00 00 00 	movl   $0x1,0x10(%edx)
801041d6:	e9 d1 fe ff ff       	jmp    801040ac <send_signal_to_all+0x70>
801041db:	90                   	nop

801041dc <scheduler>:



void scheduler(void)
{
801041dc:	55                   	push   %ebp
801041dd:	89 e5                	mov    %esp,%ebp
801041df:	57                   	push   %edi
801041e0:	56                   	push   %esi
801041e1:	53                   	push   %ebx
801041e2:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p, *chosen = 0;
  struct proc * previous_process = 0;
  struct cpu *c = mycpu();
801041e5:	e8 86 f3 ff ff       	call   80103570 <mycpu>
801041ea:	89 c2                	mov    %eax,%edx
  // int best_priority = -1000000000;
  // int dynamic_priority;
  c->proc = 0;
801041ec:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041f3:	00 00 00 
  struct proc * previous_process = 0;
801041f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801041fd:	8d 40 04             	lea    0x4(%eax),%eax
80104200:	89 45 d8             	mov    %eax,-0x28(%ebp)
                   
                    int tat =ticks - p->creation_time ;
                    int wt = tat - p->total_run_time-p->total_sleeping_time;
                      
                    // cprintf("total sleep time : %d ....%d \n", p->total_sleeping_time,p->pid);
                    dynamic_priority = INIT_PRIORITY - ALPHA * p->total_run_time + BETA * wt;
80104203:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104206:	66 90                	xchg   %ax,%ax
  asm volatile("sti");
80104208:	fb                   	sti
          acquire(&ptable.lock);
80104209:	83 ec 0c             	sub    $0xc,%esp
8010420c:	68 20 1d 11 80       	push   $0x80111d20
80104211:	e8 f2 03 00 00       	call   80104608 <acquire>
                            p->first_run_time = ticks;
80104216:	8b 35 60 4f 11 80    	mov    0x80114f60,%esi
8010421c:	83 c4 10             	add    $0x10,%esp
           int best_priority = -1000000000;
8010421f:	bf 00 36 65 c4       	mov    $0xc4653600,%edi
                            p->first_run_time = ticks;
80104224:	31 db                	xor    %ebx,%ebx
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104226:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010422b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010422e:	eb 14                	jmp    80104244 <scheduler+0x68>
                    if(dynamic_priority > best_priority ||
80104230:	0f 84 e2 00 00 00    	je     80104318 <scheduler+0x13c>
80104236:	66 90                	xchg   %ax,%ax
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104238:	05 c8 00 00 00       	add    $0xc8,%eax
8010423d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104242:	74 4a                	je     8010428e <scheduler+0xb2>
                    if(p->state != RUNNABLE)
80104244:	83 78 58 04          	cmpl   $0x4,0x58(%eax)
80104248:	75 ee                	jne    80104238 <scheduler+0x5c>
                    if(p->suspended == 1 || p->state == SUSPENDED)
8010424a:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
8010424e:	74 e8                	je     80104238 <scheduler+0x5c>
                    if(p->has_started == 0) 
80104250:	8b 48 44             	mov    0x44(%eax),%ecx
80104253:	85 c9                	test   %ecx,%ecx
80104255:	75 0a                	jne    80104261 <scheduler+0x85>
                            p->first_run_time = ticks;
80104257:	89 70 34             	mov    %esi,0x34(%eax)
                            p->has_started = 1;
8010425a:	c7 40 44 01 00 00 00 	movl   $0x1,0x44(%eax)
                    int wt = tat - p->total_run_time-p->total_sleeping_time;
80104261:	8b 48 38             	mov    0x38(%eax),%ecx
                    int tat =ticks - p->creation_time ;
80104264:	89 f2                	mov    %esi,%edx
80104266:	2b 50 2c             	sub    0x2c(%eax),%edx
                    int wt = tat - p->total_run_time-p->total_sleeping_time;
80104269:	29 ca                	sub    %ecx,%edx
8010426b:	2b 50 4c             	sub    0x4c(%eax),%edx
                    dynamic_priority = INIT_PRIORITY - ALPHA * p->total_run_time + BETA * wt;
8010426e:	01 d2                	add    %edx,%edx
80104270:	bb 32 00 00 00       	mov    $0x32,%ebx
80104275:	29 cb                	sub    %ecx,%ebx
80104277:	01 da                	add    %ebx,%edx
                    if(dynamic_priority > best_priority ||
80104279:	39 fa                	cmp    %edi,%edx
8010427b:	7e b3                	jle    80104230 <scheduler+0x54>
                      (dynamic_priority == best_priority && chosen && p->pid < chosen->pid)) {
                      best_priority = dynamic_priority;
8010427d:	89 d7                	mov    %edx,%edi
                      chosen = p;
8010427f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104282:	05 c8 00 00 00       	add    $0xc8,%eax
80104287:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010428c:	75 b6                	jne    80104244 <scheduler+0x68>
          }
          
          // cprintf("best_priority : %d...p->pid\n",best_priority,p->pid);
          best_priority = -1000000;

          if(chosen)
8010428e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104291:	85 db                	test   %ebx,%ebx
80104293:	74 6b                	je     80104300 <scheduler+0x124>
          {
                  chosen->start_run_tick = ticks;
80104295:	89 73 48             	mov    %esi,0x48(%ebx)
                  if(previous_process != chosen || previous_process==0)
80104298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010429b:	39 c3                	cmp    %eax,%ebx
8010429d:	74 03                	je     801042a2 <scheduler+0xc6>
                  {
                          chosen->context_switches++;
8010429f:	ff 43 40             	incl   0x40(%ebx)
                  }
                  
                  c->proc = chosen;
801042a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042a5:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
                  switchuvm(chosen);
801042ab:	83 ec 0c             	sub    $0xc,%esp
801042ae:	53                   	push   %ebx
801042af:	e8 5c 25 00 00       	call   80106810 <switchuvm>
                  chosen->state = RUNNING;
801042b4:	c7 43 58 05 00 00 00 	movl   $0x5,0x58(%ebx)
                  swtch(&(c->scheduler), chosen->context);
801042bb:	58                   	pop    %eax
801042bc:	5a                   	pop    %edx
801042bd:	ff 73 68             	push   0x68(%ebx)
801042c0:	ff 75 d8             	push   -0x28(%ebp)
801042c3:	e8 a1 05 00 00       	call   80104869 <swtch>
                  switchkvm();
801042c8:	e8 33 25 00 00       	call   80106800 <switchkvm>
                  chosen->total_run_time += (ticks - chosen->start_run_tick);
801042cd:	a1 60 4f 11 80       	mov    0x80114f60,%eax
801042d2:	03 43 38             	add    0x38(%ebx),%eax
801042d5:	2b 43 48             	sub    0x48(%ebx),%eax
801042d8:	89 43 38             	mov    %eax,0x38(%ebx)
                  if (chosen->exec_time > 0 && chosen->total_run_time >= chosen->exec_time)
801042db:	8b 53 24             	mov    0x24(%ebx),%edx
801042de:	83 c4 10             	add    $0x10,%esp
801042e1:	85 d2                	test   %edx,%edx
801042e3:	7e 0b                	jle    801042f0 <scheduler+0x114>
801042e5:	39 d0                	cmp    %edx,%eax
801042e7:	7c 07                	jl     801042f0 <scheduler+0x114>
                  {
                        chosen->killed = 1;
801042e9:	c7 43 70 01 00 00 00 	movl   $0x1,0x70(%ebx)
                    }
                  c->proc = 0;
801042f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042f3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042fa:	00 00 00 
                  
                  previous_process = chosen ; 
801042fd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
                  chosen = 0 ;
          }
             release(&ptable.lock);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 20 1d 11 80       	push   $0x80111d20
80104308:	e8 9b 02 00 00       	call   801045a8 <release>
  {
8010430d:	83 c4 10             	add    $0x10,%esp
80104310:	e9 f3 fe ff ff       	jmp    80104208 <scheduler+0x2c>
80104315:	8d 76 00             	lea    0x0(%esi),%esi
                      (dynamic_priority == best_priority && chosen && p->pid < chosen->pid)) {
80104318:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010431b:	85 c9                	test   %ecx,%ecx
8010431d:	0f 84 15 ff ff ff    	je     80104238 <scheduler+0x5c>
80104323:	8b 49 5c             	mov    0x5c(%ecx),%ecx
80104326:	39 48 5c             	cmp    %ecx,0x5c(%eax)
80104329:	0f 8d 09 ff ff ff    	jge    80104238 <scheduler+0x5c>
8010432f:	e9 4b ff ff ff       	jmp    8010427f <scheduler+0xa3>

80104334 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	53                   	push   %ebx
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010433e:	68 c8 72 10 80       	push   $0x801072c8
80104343:	8d 43 04             	lea    0x4(%ebx),%eax
80104346:	50                   	push   %eax
80104347:	e8 f4 00 00 00       	call   80104440 <initlock>
  lk->name = name;
8010434c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010434f:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80104352:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104358:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
8010435f:	83 c4 10             	add    $0x10,%esp
80104362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104365:	c9                   	leave
80104366:	c3                   	ret
80104367:	90                   	nop

80104368 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104368:	55                   	push   %ebp
80104369:	89 e5                	mov    %esp,%ebp
8010436b:	56                   	push   %esi
8010436c:	53                   	push   %ebx
8010436d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104370:	8d 73 04             	lea    0x4(%ebx),%esi
80104373:	83 ec 0c             	sub    $0xc,%esp
80104376:	56                   	push   %esi
80104377:	e8 8c 02 00 00       	call   80104608 <acquire>
  while (lk->locked) {
8010437c:	83 c4 10             	add    $0x10,%esp
8010437f:	8b 13                	mov    (%ebx),%edx
80104381:	85 d2                	test   %edx,%edx
80104383:	74 16                	je     8010439b <acquiresleep+0x33>
80104385:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104388:	83 ec 08             	sub    $0x8,%esp
8010438b:	56                   	push   %esi
8010438c:	53                   	push   %ebx
8010438d:	e8 42 f8 ff ff       	call   80103bd4 <sleep>
  while (lk->locked) {
80104392:	83 c4 10             	add    $0x10,%esp
80104395:	8b 03                	mov    (%ebx),%eax
80104397:	85 c0                	test   %eax,%eax
80104399:	75 ed                	jne    80104388 <acquiresleep+0x20>
  }
  lk->locked = 1;
8010439b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043a1:	e8 62 f2 ff ff       	call   80103608 <myproc>
801043a6:	8b 40 5c             	mov    0x5c(%eax),%eax
801043a9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043ac:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b2:	5b                   	pop    %ebx
801043b3:	5e                   	pop    %esi
801043b4:	5d                   	pop    %ebp
  release(&lk->lk);
801043b5:	e9 ee 01 00 00       	jmp    801045a8 <release>
801043ba:	66 90                	xchg   %ax,%ax

801043bc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043bc:	55                   	push   %ebp
801043bd:	89 e5                	mov    %esp,%ebp
801043bf:	56                   	push   %esi
801043c0:	53                   	push   %ebx
801043c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043c4:	8d 73 04             	lea    0x4(%ebx),%esi
801043c7:	83 ec 0c             	sub    $0xc,%esp
801043ca:	56                   	push   %esi
801043cb:	e8 38 02 00 00       	call   80104608 <acquire>
  lk->locked = 0;
801043d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043d6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043dd:	89 1c 24             	mov    %ebx,(%esp)
801043e0:	e8 eb f9 ff ff       	call   80103dd0 <wakeup>
  release(&lk->lk);
801043e5:	83 c4 10             	add    $0x10,%esp
801043e8:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ee:	5b                   	pop    %ebx
801043ef:	5e                   	pop    %esi
801043f0:	5d                   	pop    %ebp
  release(&lk->lk);
801043f1:	e9 b2 01 00 00       	jmp    801045a8 <release>
801043f6:	66 90                	xchg   %ax,%ax

801043f8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043f8:	55                   	push   %ebp
801043f9:	89 e5                	mov    %esp,%ebp
801043fb:	56                   	push   %esi
801043fc:	53                   	push   %ebx
801043fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104400:	8d 73 04             	lea    0x4(%ebx),%esi
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	56                   	push   %esi
80104407:	e8 fc 01 00 00       	call   80104608 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	8b 03                	mov    (%ebx),%eax
80104411:	85 c0                	test   %eax,%eax
80104413:	75 17                	jne    8010442c <holdingsleep+0x34>
80104415:	31 db                	xor    %ebx,%ebx
  release(&lk->lk);
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	56                   	push   %esi
8010441b:	e8 88 01 00 00       	call   801045a8 <release>
  return r;
}
80104420:	89 d8                	mov    %ebx,%eax
80104422:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104425:	5b                   	pop    %ebx
80104426:	5e                   	pop    %esi
80104427:	5d                   	pop    %ebp
80104428:	c3                   	ret
80104429:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
8010442c:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010442f:	e8 d4 f1 ff ff       	call   80103608 <myproc>
80104434:	39 58 5c             	cmp    %ebx,0x5c(%eax)
80104437:	0f 94 c3             	sete   %bl
8010443a:	0f b6 db             	movzbl %bl,%ebx
8010443d:	eb d8                	jmp    80104417 <holdingsleep+0x1f>
8010443f:	90                   	nop

80104440 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104446:	8b 55 0c             	mov    0xc(%ebp),%edx
80104449:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010444c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104452:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret
8010445b:	90                   	nop

8010445c <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010445c:	55                   	push   %ebp
8010445d:	89 e5                	mov    %esp,%ebp
8010445f:	53                   	push   %ebx
80104460:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
80104466:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104469:	31 d2                	xor    %edx,%edx
8010446b:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010446c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104472:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104478:	77 16                	ja     80104490 <getcallerpcs+0x34>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010447a:	8b 58 04             	mov    0x4(%eax),%ebx
8010447d:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80104480:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104482:	42                   	inc    %edx
80104483:	83 fa 0a             	cmp    $0xa,%edx
80104486:	75 e4                	jne    8010446c <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010448b:	c9                   	leave
8010448c:	c3                   	ret
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104490:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104493:	83 c1 28             	add    $0x28,%ecx
80104496:	89 ca                	mov    %ecx,%edx
80104498:	29 c2                	sub    %eax,%edx
8010449a:	83 e2 04             	and    $0x4,%edx
8010449d:	74 0d                	je     801044ac <getcallerpcs+0x50>
    pcs[i] = 0;
8010449f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044a5:	83 c0 04             	add    $0x4,%eax
801044a8:	39 c8                	cmp    %ecx,%eax
801044aa:	74 dc                	je     80104488 <getcallerpcs+0x2c>
    pcs[i] = 0;
801044ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
801044b9:	83 c0 08             	add    $0x8,%eax
801044bc:	39 c8                	cmp    %ecx,%eax
801044be:	75 ec                	jne    801044ac <getcallerpcs+0x50>
801044c0:	eb c6                	jmp    80104488 <getcallerpcs+0x2c>
801044c2:	66 90                	xchg   %ax,%ax

801044c4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	53                   	push   %ebx
801044c8:	50                   	push   %eax
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044c9:	9c                   	pushf
801044ca:	5b                   	pop    %ebx
  asm volatile("cli");
801044cb:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044cc:	e8 9f f0 ff ff       	call   80103570 <mycpu>
801044d1:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044d7:	85 d2                	test   %edx,%edx
801044d9:	74 11                	je     801044ec <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044db:	e8 90 f0 ff ff       	call   80103570 <mycpu>
801044e0:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801044e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e9:	c9                   	leave
801044ea:	c3                   	ret
801044eb:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044ec:	e8 7f f0 ff ff       	call   80103570 <mycpu>
801044f1:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044f7:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801044fd:	e8 6e f0 ff ff       	call   80103570 <mycpu>
80104502:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80104508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010450b:	c9                   	leave
8010450c:	c3                   	ret
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <popcli>:

void
popcli(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104516:	9c                   	pushf
80104517:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104518:	f6 c4 02             	test   $0x2,%ah
8010451b:	75 31                	jne    8010454e <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010451d:	e8 4e f0 ff ff       	call   80103570 <mycpu>
80104522:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80104528:	78 31                	js     8010455b <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010452a:	e8 41 f0 ff ff       	call   80103570 <mycpu>
8010452f:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104535:	85 d2                	test   %edx,%edx
80104537:	74 03                	je     8010453c <popcli+0x2c>
    sti();
}
80104539:	c9                   	leave
8010453a:	c3                   	ret
8010453b:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010453c:	e8 2f f0 ff ff       	call   80103570 <mycpu>
80104541:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104547:	85 c0                	test   %eax,%eax
80104549:	74 ee                	je     80104539 <popcli+0x29>
  asm volatile("sti");
8010454b:	fb                   	sti
}
8010454c:	c9                   	leave
8010454d:	c3                   	ret
    panic("popcli - interruptible");
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	68 d3 72 10 80       	push   $0x801072d3
80104556:	e8 dd bd ff ff       	call   80100338 <panic>
    panic("popcli");
8010455b:	83 ec 0c             	sub    $0xc,%esp
8010455e:	68 ea 72 10 80       	push   $0x801072ea
80104563:	e8 d0 bd ff ff       	call   80100338 <panic>

80104568 <holding>:
{
80104568:	55                   	push   %ebp
80104569:	89 e5                	mov    %esp,%ebp
8010456b:	53                   	push   %ebx
8010456c:	50                   	push   %eax
8010456d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104570:	e8 4f ff ff ff       	call   801044c4 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104575:	8b 13                	mov    (%ebx),%edx
80104577:	85 d2                	test   %edx,%edx
80104579:	75 11                	jne    8010458c <holding+0x24>
8010457b:	31 db                	xor    %ebx,%ebx
  popcli();
8010457d:	e8 8e ff ff ff       	call   80104510 <popcli>
}
80104582:	89 d8                	mov    %ebx,%eax
80104584:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104587:	c9                   	leave
80104588:	c3                   	ret
80104589:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
8010458c:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010458f:	e8 dc ef ff ff       	call   80103570 <mycpu>
80104594:	39 c3                	cmp    %eax,%ebx
80104596:	0f 94 c3             	sete   %bl
80104599:	0f b6 db             	movzbl %bl,%ebx
  popcli();
8010459c:	e8 6f ff ff ff       	call   80104510 <popcli>
}
801045a1:	89 d8                	mov    %ebx,%eax
801045a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a6:	c9                   	leave
801045a7:	c3                   	ret

801045a8 <release>:
{
801045a8:	55                   	push   %ebp
801045a9:	89 e5                	mov    %esp,%ebp
801045ab:	56                   	push   %esi
801045ac:	53                   	push   %ebx
801045ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045b0:	e8 0f ff ff ff       	call   801044c4 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045b5:	8b 03                	mov    (%ebx),%eax
801045b7:	85 c0                	test   %eax,%eax
801045b9:	75 15                	jne    801045d0 <release+0x28>
  popcli();
801045bb:	e8 50 ff ff ff       	call   80104510 <popcli>
    panic("release");
801045c0:	83 ec 0c             	sub    $0xc,%esp
801045c3:	68 f1 72 10 80       	push   $0x801072f1
801045c8:	e8 6b bd ff ff       	call   80100338 <panic>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045d0:	8b 73 08             	mov    0x8(%ebx),%esi
801045d3:	e8 98 ef ff ff       	call   80103570 <mycpu>
801045d8:	39 c6                	cmp    %eax,%esi
801045da:	75 df                	jne    801045bb <release+0x13>
  popcli();
801045dc:	e8 2f ff ff ff       	call   80104510 <popcli>
  lk->pcs[0] = 0;
801045e1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045e8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045ef:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045fd:	5b                   	pop    %ebx
801045fe:	5e                   	pop    %esi
801045ff:	5d                   	pop    %ebp
  popcli();
80104600:	e9 0b ff ff ff       	jmp    80104510 <popcli>
80104605:	8d 76 00             	lea    0x0(%esi),%esi

80104608 <acquire>:
{
80104608:	55                   	push   %ebp
80104609:	89 e5                	mov    %esp,%ebp
8010460b:	53                   	push   %ebx
8010460c:	50                   	push   %eax
  pushcli(); // disable interrupts to avoid deadlock.
8010460d:	e8 b2 fe ff ff       	call   801044c4 <pushcli>
  if(holding(lk))
80104612:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104615:	e8 aa fe ff ff       	call   801044c4 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010461a:	8b 13                	mov    (%ebx),%edx
8010461c:	85 d2                	test   %edx,%edx
8010461e:	0f 85 8c 00 00 00    	jne    801046b0 <acquire+0xa8>
  popcli();
80104624:	e8 e7 fe ff ff       	call   80104510 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104629:	b9 01 00 00 00       	mov    $0x1,%ecx
8010462e:	66 90                	xchg   %ax,%ax
  while(xchg(&lk->locked, 1) != 0)
80104630:	8b 55 08             	mov    0x8(%ebp),%edx
80104633:	89 c8                	mov    %ecx,%eax
80104635:	f0 87 02             	lock xchg %eax,(%edx)
80104638:	85 c0                	test   %eax,%eax
8010463a:	75 f4                	jne    80104630 <acquire+0x28>
  __sync_synchronize();
8010463c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104641:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104644:	e8 27 ef ff ff       	call   80103570 <mycpu>
80104649:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010464c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010464f:	31 c0                	xor    %eax,%eax
  ebp = (uint*)v - 2;
80104651:	89 ea                	mov    %ebp,%edx
80104653:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104654:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010465a:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104660:	77 16                	ja     80104678 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104662:	8b 5a 04             	mov    0x4(%edx),%ebx
80104665:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80104669:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010466b:	40                   	inc    %eax
8010466c:	83 f8 0a             	cmp    $0xa,%eax
8010466f:	75 e3                	jne    80104654 <acquire+0x4c>
}
80104671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104674:	c9                   	leave
80104675:	c3                   	ret
80104676:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
80104678:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010467c:	83 c1 34             	add    $0x34,%ecx
8010467f:	89 ca                	mov    %ecx,%edx
80104681:	29 c2                	sub    %eax,%edx
80104683:	83 e2 04             	and    $0x4,%edx
80104686:	74 10                	je     80104698 <acquire+0x90>
    pcs[i] = 0;
80104688:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010468e:	83 c0 04             	add    $0x4,%eax
80104691:	39 c8                	cmp    %ecx,%eax
80104693:	74 dc                	je     80104671 <acquire+0x69>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010469e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
801046a5:	83 c0 08             	add    $0x8,%eax
801046a8:	39 c8                	cmp    %ecx,%eax
801046aa:	75 ec                	jne    80104698 <acquire+0x90>
801046ac:	eb c3                	jmp    80104671 <acquire+0x69>
801046ae:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801046b0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046b3:	e8 b8 ee ff ff       	call   80103570 <mycpu>
801046b8:	39 c3                	cmp    %eax,%ebx
801046ba:	0f 85 64 ff ff ff    	jne    80104624 <acquire+0x1c>
  popcli();
801046c0:	e8 4b fe ff ff       	call   80104510 <popcli>
    panic("acquire");
801046c5:	83 ec 0c             	sub    $0xc,%esp
801046c8:	68 f9 72 10 80       	push   $0x801072f9
801046cd:	e8 66 bc ff ff       	call   80100338 <panic>
801046d2:	66 90                	xchg   %ax,%ax

801046d4 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	8b 55 08             	mov    0x8(%ebp),%edx
801046db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046de:	89 d0                	mov    %edx,%eax
801046e0:	09 c8                	or     %ecx,%eax
801046e2:	a8 03                	test   $0x3,%al
801046e4:	75 22                	jne    80104708 <memset+0x34>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046e6:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
801046e9:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ed:	89 f8                	mov    %edi,%eax
801046ef:	c1 e0 08             	shl    $0x8,%eax
801046f2:	01 f8                	add    %edi,%eax
801046f4:	89 c7                	mov    %eax,%edi
801046f6:	c1 e7 10             	shl    $0x10,%edi
801046f9:	01 f8                	add    %edi,%eax
  asm volatile("cld; rep stosl" :
801046fb:	89 d7                	mov    %edx,%edi
801046fd:	fc                   	cld
801046fe:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104700:	89 d0                	mov    %edx,%eax
80104702:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104705:	c9                   	leave
80104706:	c3                   	ret
80104707:	90                   	nop
  asm volatile("cld; rep stosb" :
80104708:	89 d7                	mov    %edx,%edi
8010470a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470d:	fc                   	cld
8010470e:	f3 aa                	rep stos %al,%es:(%edi)
80104710:	89 d0                	mov    %edx,%eax
80104712:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104715:	c9                   	leave
80104716:	c3                   	ret
80104717:	90                   	nop

80104718 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104718:	55                   	push   %ebp
80104719:	89 e5                	mov    %esp,%ebp
8010471b:	56                   	push   %esi
8010471c:	53                   	push   %ebx
8010471d:	8b 45 08             	mov    0x8(%ebp),%eax
80104720:	8b 55 0c             	mov    0xc(%ebp),%edx
80104723:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104726:	85 f6                	test   %esi,%esi
80104728:	74 1e                	je     80104748 <memcmp+0x30>
8010472a:	01 c6                	add    %eax,%esi
8010472c:	eb 08                	jmp    80104736 <memcmp+0x1e>
8010472e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104730:	40                   	inc    %eax
80104731:	42                   	inc    %edx
  while(n-- > 0){
80104732:	39 f0                	cmp    %esi,%eax
80104734:	74 12                	je     80104748 <memcmp+0x30>
    if(*s1 != *s2)
80104736:	8a 08                	mov    (%eax),%cl
80104738:	0f b6 1a             	movzbl (%edx),%ebx
8010473b:	38 d9                	cmp    %bl,%cl
8010473d:	74 f1                	je     80104730 <memcmp+0x18>
      return *s1 - *s2;
8010473f:	0f b6 c1             	movzbl %cl,%eax
80104742:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104744:	5b                   	pop    %ebx
80104745:	5e                   	pop    %esi
80104746:	5d                   	pop    %ebp
80104747:	c3                   	ret
  return 0;
80104748:	31 c0                	xor    %eax,%eax
}
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5d                   	pop    %ebp
8010474d:	c3                   	ret
8010474e:	66 90                	xchg   %ax,%ax

80104750 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	8b 55 08             	mov    0x8(%ebp),%edx
80104758:	8b 75 0c             	mov    0xc(%ebp),%esi
8010475b:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010475e:	39 d6                	cmp    %edx,%esi
80104760:	73 22                	jae    80104784 <memmove+0x34>
80104762:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104765:	39 ca                	cmp    %ecx,%edx
80104767:	73 1b                	jae    80104784 <memmove+0x34>
    s += n;
    d += n;
    while(n-- > 0)
80104769:	85 c0                	test   %eax,%eax
8010476b:	74 0e                	je     8010477b <memmove+0x2b>
8010476d:	48                   	dec    %eax
8010476e:	66 90                	xchg   %ax,%ax
      *--d = *--s;
80104770:	8a 0c 06             	mov    (%esi,%eax,1),%cl
80104773:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104776:	83 e8 01             	sub    $0x1,%eax
80104779:	73 f5                	jae    80104770 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010477b:	89 d0                	mov    %edx,%eax
8010477d:	5e                   	pop    %esi
8010477e:	5f                   	pop    %edi
8010477f:	5d                   	pop    %ebp
80104780:	c3                   	ret
80104781:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104784:	85 c0                	test   %eax,%eax
80104786:	74 f3                	je     8010477b <memmove+0x2b>
80104788:	01 f0                	add    %esi,%eax
8010478a:	89 d7                	mov    %edx,%edi
      *d++ = *s++;
8010478c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
8010478d:	39 f0                	cmp    %esi,%eax
8010478f:	75 fb                	jne    8010478c <memmove+0x3c>
}
80104791:	89 d0                	mov    %edx,%eax
80104793:	5e                   	pop    %esi
80104794:	5f                   	pop    %edi
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret
80104797:	90                   	nop

80104798 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104798:	eb b6                	jmp    80104750 <memmove>
8010479a:	66 90                	xchg   %ax,%ax

8010479c <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
8010479c:	55                   	push   %ebp
8010479d:	89 e5                	mov    %esp,%ebp
8010479f:	53                   	push   %ebx
801047a0:	8b 45 08             	mov    0x8(%ebp),%eax
801047a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801047a6:	8b 55 10             	mov    0x10(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047a9:	85 d2                	test   %edx,%edx
801047ab:	75 0c                	jne    801047b9 <strncmp+0x1d>
801047ad:	eb 1d                	jmp    801047cc <strncmp+0x30>
801047af:	90                   	nop
801047b0:	3a 19                	cmp    (%ecx),%bl
801047b2:	75 0b                	jne    801047bf <strncmp+0x23>
    n--, p++, q++;
801047b4:	40                   	inc    %eax
801047b5:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
801047b6:	4a                   	dec    %edx
801047b7:	74 13                	je     801047cc <strncmp+0x30>
801047b9:	8a 18                	mov    (%eax),%bl
801047bb:	84 db                	test   %bl,%bl
801047bd:	75 f1                	jne    801047b0 <strncmp+0x14>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047bf:	0f b6 00             	movzbl (%eax),%eax
801047c2:	0f b6 11             	movzbl (%ecx),%edx
801047c5:	29 d0                	sub    %edx,%eax
}
801047c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ca:	c9                   	leave
801047cb:	c3                   	ret
    return 0;
801047cc:	31 c0                	xor    %eax,%eax
}
801047ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d1:	c9                   	leave
801047d2:	c3                   	ret
801047d3:	90                   	nop

801047d4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	56                   	push   %esi
801047d8:	53                   	push   %ebx
801047d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047df:	8b 55 08             	mov    0x8(%ebp),%edx
801047e2:	eb 0c                	jmp    801047f0 <strncpy+0x1c>
801047e4:	43                   	inc    %ebx
801047e5:	42                   	inc    %edx
801047e6:	8a 43 ff             	mov    -0x1(%ebx),%al
801047e9:	88 42 ff             	mov    %al,-0x1(%edx)
801047ec:	84 c0                	test   %al,%al
801047ee:	74 10                	je     80104800 <strncpy+0x2c>
801047f0:	89 ce                	mov    %ecx,%esi
801047f2:	49                   	dec    %ecx
801047f3:	85 f6                	test   %esi,%esi
801047f5:	7f ed                	jg     801047e4 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801047f7:	8b 45 08             	mov    0x8(%ebp),%eax
801047fa:	5b                   	pop    %ebx
801047fb:	5e                   	pop    %esi
801047fc:	5d                   	pop    %ebp
801047fd:	c3                   	ret
801047fe:	66 90                	xchg   %ax,%ax
  while(n-- > 0)
80104800:	8d 5c 32 ff          	lea    -0x1(%edx,%esi,1),%ebx
80104804:	85 c9                	test   %ecx,%ecx
80104806:	74 ef                	je     801047f7 <strncpy+0x23>
    *s++ = 0;
80104808:	42                   	inc    %edx
80104809:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
8010480d:	89 d9                	mov    %ebx,%ecx
8010480f:	29 d1                	sub    %edx,%ecx
80104811:	85 c9                	test   %ecx,%ecx
80104813:	7f f3                	jg     80104808 <strncpy+0x34>
}
80104815:	8b 45 08             	mov    0x8(%ebp),%eax
80104818:	5b                   	pop    %ebx
80104819:	5e                   	pop    %esi
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret

8010481c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010481c:	55                   	push   %ebp
8010481d:	89 e5                	mov    %esp,%ebp
8010481f:	56                   	push   %esi
80104820:	53                   	push   %ebx
80104821:	8b 45 08             	mov    0x8(%ebp),%eax
80104824:	8b 55 0c             	mov    0xc(%ebp),%edx
80104827:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
8010482a:	85 c9                	test   %ecx,%ecx
8010482c:	7e 1d                	jle    8010484b <safestrcpy+0x2f>
8010482e:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104832:	89 c1                	mov    %eax,%ecx
80104834:	eb 0e                	jmp    80104844 <safestrcpy+0x28>
80104836:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104838:	42                   	inc    %edx
80104839:	41                   	inc    %ecx
8010483a:	8a 5a ff             	mov    -0x1(%edx),%bl
8010483d:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104840:	84 db                	test   %bl,%bl
80104842:	74 04                	je     80104848 <safestrcpy+0x2c>
80104844:	39 f2                	cmp    %esi,%edx
80104846:	75 f0                	jne    80104838 <safestrcpy+0x1c>
    ;
  *s = 0;
80104848:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
8010484b:	5b                   	pop    %ebx
8010484c:	5e                   	pop    %esi
8010484d:	5d                   	pop    %ebp
8010484e:	c3                   	ret
8010484f:	90                   	nop

80104850 <strlen>:

int
strlen(const char *s)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104856:	31 c0                	xor    %eax,%eax
80104858:	80 3a 00             	cmpb   $0x0,(%edx)
8010485b:	74 0a                	je     80104867 <strlen+0x17>
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	40                   	inc    %eax
80104861:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104865:	75 f9                	jne    80104860 <strlen+0x10>
    ;
  return n;
}
80104867:	5d                   	pop    %ebp
80104868:	c3                   	ret

80104869 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104869:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010486d:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104871:	55                   	push   %ebp
  pushl %ebx
80104872:	53                   	push   %ebx
  pushl %esi
80104873:	56                   	push   %esi
  pushl %edi
80104874:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104875:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104877:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104879:	5f                   	pop    %edi
  popl %esi
8010487a:	5e                   	pop    %esi
  popl %ebx
8010487b:	5b                   	pop    %ebx
  popl %ebp
8010487c:	5d                   	pop    %ebp
  ret
8010487d:	c3                   	ret
8010487e:	66 90                	xchg   %ax,%ax

80104880 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	50                   	push   %eax
80104885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104888:	e8 7b ed ff ff       	call   80103608 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010488d:	8b 00                	mov    (%eax),%eax
8010488f:	39 c3                	cmp    %eax,%ebx
80104891:	73 15                	jae    801048a8 <fetchint+0x28>
80104893:	8d 53 04             	lea    0x4(%ebx),%edx
80104896:	39 d0                	cmp    %edx,%eax
80104898:	72 0e                	jb     801048a8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010489a:	8b 13                	mov    (%ebx),%edx
8010489c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010489f:	89 10                	mov    %edx,(%eax)
  return 0;
801048a1:	31 c0                	xor    %eax,%eax
}
801048a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a6:	c9                   	leave
801048a7:	c3                   	ret
    return -1;
801048a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ad:	eb f4                	jmp    801048a3 <fetchint+0x23>
801048af:	90                   	nop

801048b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	50                   	push   %eax
801048b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048b8:	e8 4b ed ff ff       	call   80103608 <myproc>

  if(addr >= curproc->sz)
801048bd:	3b 18                	cmp    (%eax),%ebx
801048bf:	73 23                	jae    801048e4 <fetchstr+0x34>
    return -1;
  *pp = (char*)addr;
801048c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801048c4:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801048c6:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801048c8:	39 d3                	cmp    %edx,%ebx
801048ca:	73 18                	jae    801048e4 <fetchstr+0x34>
801048cc:	89 d8                	mov    %ebx,%eax
801048ce:	eb 05                	jmp    801048d5 <fetchstr+0x25>
801048d0:	40                   	inc    %eax
801048d1:	39 d0                	cmp    %edx,%eax
801048d3:	73 0f                	jae    801048e4 <fetchstr+0x34>
    if(*s == 0)
801048d5:	80 38 00             	cmpb   $0x0,(%eax)
801048d8:	75 f6                	jne    801048d0 <fetchstr+0x20>
      return s - *pp;
801048da:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801048dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048df:	c9                   	leave
801048e0:	c3                   	ret
801048e1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801048e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048ec:	c9                   	leave
801048ed:	c3                   	ret
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048f5:	e8 0e ed ff ff       	call   80103608 <myproc>
801048fa:	8b 40 64             	mov    0x64(%eax),%eax
801048fd:	8b 40 44             	mov    0x44(%eax),%eax
80104900:	8b 55 08             	mov    0x8(%ebp),%edx
80104903:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104906:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
80104909:	e8 fa ec ff ff       	call   80103608 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010490e:	8b 00                	mov    (%eax),%eax
80104910:	39 c6                	cmp    %eax,%esi
80104912:	73 18                	jae    8010492c <argint+0x3c>
80104914:	8d 53 08             	lea    0x8(%ebx),%edx
80104917:	39 d0                	cmp    %edx,%eax
80104919:	72 11                	jb     8010492c <argint+0x3c>
  *ip = *(int*)(addr);
8010491b:	8b 53 04             	mov    0x4(%ebx),%edx
8010491e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104921:	89 10                	mov    %edx,(%eax)
  return 0;
80104923:	31 c0                	xor    %eax,%eax
}
80104925:	5b                   	pop    %ebx
80104926:	5e                   	pop    %esi
80104927:	5d                   	pop    %ebp
80104928:	c3                   	ret
80104929:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
8010492c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104931:	eb f2                	jmp    80104925 <argint+0x35>
80104933:	90                   	nop

80104934 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	57                   	push   %edi
80104938:	56                   	push   %esi
80104939:	53                   	push   %ebx
8010493a:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
8010493d:	e8 c6 ec ff ff       	call   80103608 <myproc>
80104942:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104944:	e8 bf ec ff ff       	call   80103608 <myproc>
80104949:	8b 40 64             	mov    0x64(%eax),%eax
8010494c:	8b 40 44             	mov    0x44(%eax),%eax
8010494f:	8b 55 08             	mov    0x8(%ebp),%edx
80104952:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104955:	8d 7b 04             	lea    0x4(%ebx),%edi
  struct proc *curproc = myproc();
80104958:	e8 ab ec ff ff       	call   80103608 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010495d:	8b 00                	mov    (%eax),%eax
8010495f:	39 c7                	cmp    %eax,%edi
80104961:	73 31                	jae    80104994 <argptr+0x60>
80104963:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104966:	39 c8                	cmp    %ecx,%eax
80104968:	72 2a                	jb     80104994 <argptr+0x60>
  *ip = *(int*)(addr);
8010496a:	8b 43 04             	mov    0x4(%ebx),%eax
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010496d:	8b 55 10             	mov    0x10(%ebp),%edx
80104970:	85 d2                	test   %edx,%edx
80104972:	78 20                	js     80104994 <argptr+0x60>
80104974:	8b 16                	mov    (%esi),%edx
80104976:	39 d0                	cmp    %edx,%eax
80104978:	73 1a                	jae    80104994 <argptr+0x60>
8010497a:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010497d:	01 c3                	add    %eax,%ebx
8010497f:	39 da                	cmp    %ebx,%edx
80104981:	72 11                	jb     80104994 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104983:	8b 55 0c             	mov    0xc(%ebp),%edx
80104986:	89 02                	mov    %eax,(%edx)
  return 0;
80104988:	31 c0                	xor    %eax,%eax
}
8010498a:	83 c4 0c             	add    $0xc,%esp
8010498d:	5b                   	pop    %ebx
8010498e:	5e                   	pop    %esi
8010498f:	5f                   	pop    %edi
80104990:	5d                   	pop    %ebp
80104991:	c3                   	ret
80104992:	66 90                	xchg   %ax,%ax
    return -1;
80104994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104999:	eb ef                	jmp    8010498a <argptr+0x56>
8010499b:	90                   	nop

8010499c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010499c:	55                   	push   %ebp
8010499d:	89 e5                	mov    %esp,%ebp
8010499f:	56                   	push   %esi
801049a0:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a1:	e8 62 ec ff ff       	call   80103608 <myproc>
801049a6:	8b 40 64             	mov    0x64(%eax),%eax
801049a9:	8b 40 44             	mov    0x44(%eax),%eax
801049ac:	8b 55 08             	mov    0x8(%ebp),%edx
801049af:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801049b2:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
801049b5:	e8 4e ec ff ff       	call   80103608 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ba:	8b 00                	mov    (%eax),%eax
801049bc:	39 c6                	cmp    %eax,%esi
801049be:	73 34                	jae    801049f4 <argstr+0x58>
801049c0:	8d 53 08             	lea    0x8(%ebx),%edx
801049c3:	39 d0                	cmp    %edx,%eax
801049c5:	72 2d                	jb     801049f4 <argstr+0x58>
  *ip = *(int*)(addr);
801049c7:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801049ca:	e8 39 ec ff ff       	call   80103608 <myproc>
  if(addr >= curproc->sz)
801049cf:	3b 18                	cmp    (%eax),%ebx
801049d1:	73 21                	jae    801049f4 <argstr+0x58>
  *pp = (char*)addr;
801049d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801049d6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801049d8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801049da:	39 d3                	cmp    %edx,%ebx
801049dc:	73 16                	jae    801049f4 <argstr+0x58>
801049de:	89 d8                	mov    %ebx,%eax
801049e0:	eb 07                	jmp    801049e9 <argstr+0x4d>
801049e2:	66 90                	xchg   %ax,%ax
801049e4:	40                   	inc    %eax
801049e5:	39 d0                	cmp    %edx,%eax
801049e7:	73 0b                	jae    801049f4 <argstr+0x58>
    if(*s == 0)
801049e9:	80 38 00             	cmpb   $0x0,(%eax)
801049ec:	75 f6                	jne    801049e4 <argstr+0x48>
      return s - *pp;
801049ee:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801049f0:	5b                   	pop    %ebx
801049f1:	5e                   	pop    %esi
801049f2:	5d                   	pop    %ebp
801049f3:	c3                   	ret
    return -1;
801049f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049f9:	5b                   	pop    %ebx
801049fa:	5e                   	pop    %esi
801049fb:	5d                   	pop    %ebp
801049fc:	c3                   	ret
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <syscall>:
[SYS_scheduler_start] sys_scheduler_start
};

void
syscall(void)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
80104a05:	e8 fe eb ff ff       	call   80103608 <myproc>
80104a0a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a0c:	8b 40 64             	mov    0x64(%eax),%eax
80104a0f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a12:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a15:	83 fa 17             	cmp    $0x17,%edx
80104a18:	77 1a                	ja     80104a34 <syscall+0x34>
80104a1a:	8b 14 85 00 79 10 80 	mov    -0x7fef8700(,%eax,4),%edx
80104a21:	85 d2                	test   %edx,%edx
80104a23:	74 0f                	je     80104a34 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104a25:	ff d2                	call   *%edx
80104a27:	89 c2                	mov    %eax,%edx
80104a29:	8b 43 64             	mov    0x64(%ebx),%eax
80104a2c:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a32:	c9                   	leave
80104a33:	c3                   	ret
    cprintf("%d %s: unknown sys call %d\n",
80104a34:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a35:	8d 83 b8 00 00 00    	lea    0xb8(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a3b:	50                   	push   %eax
80104a3c:	ff 73 5c             	push   0x5c(%ebx)
80104a3f:	68 01 73 10 80       	push   $0x80107301
80104a44:	e8 d7 bb ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
80104a49:	8b 43 64             	mov    0x64(%ebx),%eax
80104a4c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104a53:	83 c4 10             	add    $0x10,%esp
}
80104a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a59:	c9                   	leave
80104a5a:	c3                   	ret
80104a5b:	90                   	nop

80104a5c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a5c:	55                   	push   %ebp
80104a5d:	89 e5                	mov    %esp,%ebp
80104a5f:	57                   	push   %edi
80104a60:	56                   	push   %esi
80104a61:	53                   	push   %ebx
80104a62:	83 ec 34             	sub    $0x34,%esp
80104a65:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a68:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a71:	8d 7d da             	lea    -0x26(%ebp),%edi
80104a74:	57                   	push   %edi
80104a75:	50                   	push   %eax
80104a76:	e8 19 d5 ff ff       	call   80101f94 <nameiparent>
80104a7b:	83 c4 10             	add    $0x10,%esp
80104a7e:	85 c0                	test   %eax,%eax
80104a80:	74 5a                	je     80104adc <create+0x80>
80104a82:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	50                   	push   %eax
80104a88:	e8 9b cc ff ff       	call   80101728 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a8d:	83 c4 0c             	add    $0xc,%esp
80104a90:	6a 00                	push   $0x0
80104a92:	57                   	push   %edi
80104a93:	53                   	push   %ebx
80104a94:	e8 93 d1 ff ff       	call   80101c2c <dirlookup>
80104a99:	89 c6                	mov    %eax,%esi
80104a9b:	83 c4 10             	add    $0x10,%esp
80104a9e:	85 c0                	test   %eax,%eax
80104aa0:	74 46                	je     80104ae8 <create+0x8c>
    iunlockput(dp);
80104aa2:	83 ec 0c             	sub    $0xc,%esp
80104aa5:	53                   	push   %ebx
80104aa6:	e8 d1 ce ff ff       	call   8010197c <iunlockput>
    ilock(ip);
80104aab:	89 34 24             	mov    %esi,(%esp)
80104aae:	e8 75 cc ff ff       	call   80101728 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ab3:	83 c4 10             	add    $0x10,%esp
80104ab6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104abb:	75 13                	jne    80104ad0 <create+0x74>
80104abd:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104ac2:	75 0c                	jne    80104ad0 <create+0x74>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ac4:	89 f0                	mov    %esi,%eax
80104ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac9:	5b                   	pop    %ebx
80104aca:	5e                   	pop    %esi
80104acb:	5f                   	pop    %edi
80104acc:	5d                   	pop    %ebp
80104acd:	c3                   	ret
80104ace:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	56                   	push   %esi
80104ad4:	e8 a3 ce ff ff       	call   8010197c <iunlockput>
    return 0;
80104ad9:	83 c4 10             	add    $0x10,%esp
    return 0;
80104adc:	31 f6                	xor    %esi,%esi
}
80104ade:	89 f0                	mov    %esi,%eax
80104ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae3:	5b                   	pop    %ebx
80104ae4:	5e                   	pop    %esi
80104ae5:	5f                   	pop    %edi
80104ae6:	5d                   	pop    %ebp
80104ae7:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104ae8:	83 ec 08             	sub    $0x8,%esp
80104aeb:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104aef:	50                   	push   %eax
80104af0:	ff 33                	push   (%ebx)
80104af2:	e8 d9 ca ff ff       	call   801015d0 <ialloc>
80104af7:	89 c6                	mov    %eax,%esi
80104af9:	83 c4 10             	add    $0x10,%esp
80104afc:	85 c0                	test   %eax,%eax
80104afe:	0f 84 a0 00 00 00    	je     80104ba4 <create+0x148>
  ilock(ip);
80104b04:	83 ec 0c             	sub    $0xc,%esp
80104b07:	50                   	push   %eax
80104b08:	e8 1b cc ff ff       	call   80101728 <ilock>
  ip->major = major;
80104b0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b10:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104b17:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b1b:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
80104b21:	89 34 24             	mov    %esi,(%esp)
80104b24:	e8 57 cb ff ff       	call   80101680 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b29:	83 c4 10             	add    $0x10,%esp
80104b2c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104b31:	74 29                	je     80104b5c <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
80104b33:	50                   	push   %eax
80104b34:	ff 76 04             	push   0x4(%esi)
80104b37:	57                   	push   %edi
80104b38:	53                   	push   %ebx
80104b39:	e8 8e d3 ff ff       	call   80101ecc <dirlink>
80104b3e:	83 c4 10             	add    $0x10,%esp
80104b41:	85 c0                	test   %eax,%eax
80104b43:	78 6c                	js     80104bb1 <create+0x155>
  iunlockput(dp);
80104b45:	83 ec 0c             	sub    $0xc,%esp
80104b48:	53                   	push   %ebx
80104b49:	e8 2e ce ff ff       	call   8010197c <iunlockput>
  return ip;
80104b4e:	83 c4 10             	add    $0x10,%esp
}
80104b51:	89 f0                	mov    %esi,%eax
80104b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b56:	5b                   	pop    %ebx
80104b57:	5e                   	pop    %esi
80104b58:	5f                   	pop    %edi
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret
80104b5b:	90                   	nop
    dp->nlink++;  // for ".."
80104b5c:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80104b60:	83 ec 0c             	sub    $0xc,%esp
80104b63:	53                   	push   %ebx
80104b64:	e8 17 cb ff ff       	call   80101680 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b69:	83 c4 0c             	add    $0xc,%esp
80104b6c:	ff 76 04             	push   0x4(%esi)
80104b6f:	68 39 73 10 80       	push   $0x80107339
80104b74:	56                   	push   %esi
80104b75:	e8 52 d3 ff ff       	call   80101ecc <dirlink>
80104b7a:	83 c4 10             	add    $0x10,%esp
80104b7d:	85 c0                	test   %eax,%eax
80104b7f:	78 16                	js     80104b97 <create+0x13b>
80104b81:	52                   	push   %edx
80104b82:	ff 73 04             	push   0x4(%ebx)
80104b85:	68 38 73 10 80       	push   $0x80107338
80104b8a:	56                   	push   %esi
80104b8b:	e8 3c d3 ff ff       	call   80101ecc <dirlink>
80104b90:	83 c4 10             	add    $0x10,%esp
80104b93:	85 c0                	test   %eax,%eax
80104b95:	79 9c                	jns    80104b33 <create+0xd7>
      panic("create dots");
80104b97:	83 ec 0c             	sub    $0xc,%esp
80104b9a:	68 2c 73 10 80       	push   $0x8010732c
80104b9f:	e8 94 b7 ff ff       	call   80100338 <panic>
    panic("create: ialloc");
80104ba4:	83 ec 0c             	sub    $0xc,%esp
80104ba7:	68 1d 73 10 80       	push   $0x8010731d
80104bac:	e8 87 b7 ff ff       	call   80100338 <panic>
    panic("create: dirlink");
80104bb1:	83 ec 0c             	sub    $0xc,%esp
80104bb4:	68 3b 73 10 80       	push   $0x8010733b
80104bb9:	e8 7a b7 ff ff       	call   80100338 <panic>
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <sys_dup>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcb:	50                   	push   %eax
80104bcc:	6a 00                	push   $0x0
80104bce:	e8 1d fd ff ff       	call   801048f0 <argint>
80104bd3:	83 c4 10             	add    $0x10,%esp
80104bd6:	85 c0                	test   %eax,%eax
80104bd8:	78 2c                	js     80104c06 <sys_dup+0x46>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104bde:	77 26                	ja     80104c06 <sys_dup+0x46>
80104be0:	e8 23 ea ff ff       	call   80103608 <myproc>
80104be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104be8:	8b 74 90 74          	mov    0x74(%eax,%edx,4),%esi
80104bec:	85 f6                	test   %esi,%esi
80104bee:	74 16                	je     80104c06 <sys_dup+0x46>
  struct proc *curproc = myproc();
80104bf0:	e8 13 ea ff ff       	call   80103608 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104bf5:	31 db                	xor    %ebx,%ebx
80104bf7:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104bf8:	8b 54 98 74          	mov    0x74(%eax,%ebx,4),%edx
80104bfc:	85 d2                	test   %edx,%edx
80104bfe:	74 10                	je     80104c10 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104c00:	43                   	inc    %ebx
80104c01:	83 fb 10             	cmp    $0x10,%ebx
80104c04:	75 f2                	jne    80104bf8 <sys_dup+0x38>
    return -1;
80104c06:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c0b:	eb 13                	jmp    80104c20 <sys_dup+0x60>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104c10:	89 74 98 74          	mov    %esi,0x74(%eax,%ebx,4)
  filedup(f);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	56                   	push   %esi
80104c18:	e8 f3 c2 ff ff       	call   80100f10 <filedup>
  return fd;
80104c1d:	83 c4 10             	add    $0x10,%esp
}
80104c20:	89 d8                	mov    %ebx,%eax
80104c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5d                   	pop    %ebp
80104c28:	c3                   	ret
80104c29:	8d 76 00             	lea    0x0(%esi),%esi

80104c2c <sys_read>:
{
80104c2c:	55                   	push   %ebp
80104c2d:	89 e5                	mov    %esp,%ebp
80104c2f:	56                   	push   %esi
80104c30:	53                   	push   %ebx
80104c31:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c34:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104c37:	53                   	push   %ebx
80104c38:	6a 00                	push   $0x0
80104c3a:	e8 b1 fc ff ff       	call   801048f0 <argint>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	78 56                	js     80104c9c <sys_read+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c46:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c4a:	77 50                	ja     80104c9c <sys_read+0x70>
80104c4c:	e8 b7 e9 ff ff       	call   80103608 <myproc>
80104c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c54:	8b 74 90 74          	mov    0x74(%eax,%edx,4),%esi
80104c58:	85 f6                	test   %esi,%esi
80104c5a:	74 40                	je     80104c9c <sys_read+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c5c:	83 ec 08             	sub    $0x8,%esp
80104c5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c62:	50                   	push   %eax
80104c63:	6a 02                	push   $0x2
80104c65:	e8 86 fc ff ff       	call   801048f0 <argint>
80104c6a:	83 c4 10             	add    $0x10,%esp
80104c6d:	85 c0                	test   %eax,%eax
80104c6f:	78 2b                	js     80104c9c <sys_read+0x70>
80104c71:	52                   	push   %edx
80104c72:	ff 75 f0             	push   -0x10(%ebp)
80104c75:	53                   	push   %ebx
80104c76:	6a 01                	push   $0x1
80104c78:	e8 b7 fc ff ff       	call   80104934 <argptr>
80104c7d:	83 c4 10             	add    $0x10,%esp
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 18                	js     80104c9c <sys_read+0x70>
  return fileread(f, p, n);
80104c84:	50                   	push   %eax
80104c85:	ff 75 f0             	push   -0x10(%ebp)
80104c88:	ff 75 f4             	push   -0xc(%ebp)
80104c8b:	56                   	push   %esi
80104c8c:	e8 c7 c3 ff ff       	call   80101058 <fileread>
80104c91:	83 c4 10             	add    $0x10,%esp
}
80104c94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c97:	5b                   	pop    %ebx
80104c98:	5e                   	pop    %esi
80104c99:	5d                   	pop    %ebp
80104c9a:	c3                   	ret
80104c9b:	90                   	nop
    return -1;
80104c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca1:	eb f1                	jmp    80104c94 <sys_read+0x68>
80104ca3:	90                   	nop

80104ca4 <sys_write>:
{
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	56                   	push   %esi
80104ca8:	53                   	push   %ebx
80104ca9:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cac:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104caf:	53                   	push   %ebx
80104cb0:	6a 00                	push   $0x0
80104cb2:	e8 39 fc ff ff       	call   801048f0 <argint>
80104cb7:	83 c4 10             	add    $0x10,%esp
80104cba:	85 c0                	test   %eax,%eax
80104cbc:	78 56                	js     80104d14 <sys_write+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cbe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cc2:	77 50                	ja     80104d14 <sys_write+0x70>
80104cc4:	e8 3f e9 ff ff       	call   80103608 <myproc>
80104cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccc:	8b 74 90 74          	mov    0x74(%eax,%edx,4),%esi
80104cd0:	85 f6                	test   %esi,%esi
80104cd2:	74 40                	je     80104d14 <sys_write+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cd4:	83 ec 08             	sub    $0x8,%esp
80104cd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cda:	50                   	push   %eax
80104cdb:	6a 02                	push   $0x2
80104cdd:	e8 0e fc ff ff       	call   801048f0 <argint>
80104ce2:	83 c4 10             	add    $0x10,%esp
80104ce5:	85 c0                	test   %eax,%eax
80104ce7:	78 2b                	js     80104d14 <sys_write+0x70>
80104ce9:	52                   	push   %edx
80104cea:	ff 75 f0             	push   -0x10(%ebp)
80104ced:	53                   	push   %ebx
80104cee:	6a 01                	push   $0x1
80104cf0:	e8 3f fc ff ff       	call   80104934 <argptr>
80104cf5:	83 c4 10             	add    $0x10,%esp
80104cf8:	85 c0                	test   %eax,%eax
80104cfa:	78 18                	js     80104d14 <sys_write+0x70>
  return filewrite(f, p, n);
80104cfc:	50                   	push   %eax
80104cfd:	ff 75 f0             	push   -0x10(%ebp)
80104d00:	ff 75 f4             	push   -0xc(%ebp)
80104d03:	56                   	push   %esi
80104d04:	e8 db c3 ff ff       	call   801010e4 <filewrite>
80104d09:	83 c4 10             	add    $0x10,%esp
}
80104d0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d0f:	5b                   	pop    %ebx
80104d10:	5e                   	pop    %esi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret
80104d13:	90                   	nop
    return -1;
80104d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d19:	eb f1                	jmp    80104d0c <sys_write+0x68>
80104d1b:	90                   	nop

80104d1c <sys_close>:
{
80104d1c:	55                   	push   %ebp
80104d1d:	89 e5                	mov    %esp,%ebp
80104d1f:	56                   	push   %esi
80104d20:	53                   	push   %ebx
80104d21:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d27:	50                   	push   %eax
80104d28:	6a 00                	push   $0x0
80104d2a:	e8 c1 fb ff ff       	call   801048f0 <argint>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	85 c0                	test   %eax,%eax
80104d34:	78 3e                	js     80104d74 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d36:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d3a:	77 38                	ja     80104d74 <sys_close+0x58>
80104d3c:	e8 c7 e8 ff ff       	call   80103608 <myproc>
80104d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d44:	8d 5a 1c             	lea    0x1c(%edx),%ebx
80104d47:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
80104d4b:	85 f6                	test   %esi,%esi
80104d4d:	74 25                	je     80104d74 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104d4f:	e8 b4 e8 ff ff       	call   80103608 <myproc>
80104d54:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80104d5b:	00 
  fileclose(f);
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	56                   	push   %esi
80104d60:	e8 ef c1 ff ff       	call   80100f54 <fileclose>
  return 0;
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	31 c0                	xor    %eax,%eax
}
80104d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d6d:	5b                   	pop    %ebx
80104d6e:	5e                   	pop    %esi
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret
80104d71:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d79:	eb ef                	jmp    80104d6a <sys_close+0x4e>
80104d7b:	90                   	nop

80104d7c <sys_fstat>:
{
80104d7c:	55                   	push   %ebp
80104d7d:	89 e5                	mov    %esp,%ebp
80104d7f:	56                   	push   %esi
80104d80:	53                   	push   %ebx
80104d81:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d84:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104d87:	53                   	push   %ebx
80104d88:	6a 00                	push   $0x0
80104d8a:	e8 61 fb ff ff       	call   801048f0 <argint>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	85 c0                	test   %eax,%eax
80104d94:	78 3e                	js     80104dd4 <sys_fstat+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d96:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d9a:	77 38                	ja     80104dd4 <sys_fstat+0x58>
80104d9c:	e8 67 e8 ff ff       	call   80103608 <myproc>
80104da1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104da4:	8b 74 90 74          	mov    0x74(%eax,%edx,4),%esi
80104da8:	85 f6                	test   %esi,%esi
80104daa:	74 28                	je     80104dd4 <sys_fstat+0x58>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dac:	50                   	push   %eax
80104dad:	6a 14                	push   $0x14
80104daf:	53                   	push   %ebx
80104db0:	6a 01                	push   $0x1
80104db2:	e8 7d fb ff ff       	call   80104934 <argptr>
80104db7:	83 c4 10             	add    $0x10,%esp
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	78 16                	js     80104dd4 <sys_fstat+0x58>
  return filestat(f, st);
80104dbe:	83 ec 08             	sub    $0x8,%esp
80104dc1:	ff 75 f4             	push   -0xc(%ebp)
80104dc4:	56                   	push   %esi
80104dc5:	e8 4a c2 ff ff       	call   80101014 <filestat>
80104dca:	83 c4 10             	add    $0x10,%esp
}
80104dcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd0:	5b                   	pop    %ebx
80104dd1:	5e                   	pop    %esi
80104dd2:	5d                   	pop    %ebp
80104dd3:	c3                   	ret
    return -1;
80104dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd9:	eb f2                	jmp    80104dcd <sys_fstat+0x51>
80104ddb:	90                   	nop

80104ddc <sys_link>:
{
80104ddc:	55                   	push   %ebp
80104ddd:	89 e5                	mov    %esp,%ebp
80104ddf:	57                   	push   %edi
80104de0:	56                   	push   %esi
80104de1:	53                   	push   %ebx
80104de2:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104de5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104de8:	50                   	push   %eax
80104de9:	6a 00                	push   $0x0
80104deb:	e8 ac fb ff ff       	call   8010499c <argstr>
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	85 c0                	test   %eax,%eax
80104df5:	0f 88 f2 00 00 00    	js     80104eed <sys_link+0x111>
80104dfb:	83 ec 08             	sub    $0x8,%esp
80104dfe:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e01:	50                   	push   %eax
80104e02:	6a 01                	push   $0x1
80104e04:	e8 93 fb ff ff       	call   8010499c <argstr>
80104e09:	83 c4 10             	add    $0x10,%esp
80104e0c:	85 c0                	test   %eax,%eax
80104e0e:	0f 88 d9 00 00 00    	js     80104eed <sys_link+0x111>
  begin_op();
80104e14:	e8 ab dc ff ff       	call   80102ac4 <begin_op>
  if((ip = namei(old)) == 0){
80104e19:	83 ec 0c             	sub    $0xc,%esp
80104e1c:	ff 75 d4             	push   -0x2c(%ebp)
80104e1f:	e8 58 d1 ff ff       	call   80101f7c <namei>
80104e24:	89 c3                	mov    %eax,%ebx
80104e26:	83 c4 10             	add    $0x10,%esp
80104e29:	85 c0                	test   %eax,%eax
80104e2b:	0f 84 d6 00 00 00    	je     80104f07 <sys_link+0x12b>
  ilock(ip);
80104e31:	83 ec 0c             	sub    $0xc,%esp
80104e34:	50                   	push   %eax
80104e35:	e8 ee c8 ff ff       	call   80101728 <ilock>
  if(ip->type == T_DIR){
80104e3a:	83 c4 10             	add    $0x10,%esp
80104e3d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e42:	0f 84 ac 00 00 00    	je     80104ef4 <sys_link+0x118>
  ip->nlink++;
80104e48:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	53                   	push   %ebx
80104e50:	e8 2b c8 ff ff       	call   80101680 <iupdate>
  iunlock(ip);
80104e55:	89 1c 24             	mov    %ebx,(%esp)
80104e58:	e8 93 c9 ff ff       	call   801017f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e5d:	5a                   	pop    %edx
80104e5e:	59                   	pop    %ecx
80104e5f:	8d 7d da             	lea    -0x26(%ebp),%edi
80104e62:	57                   	push   %edi
80104e63:	ff 75 d0             	push   -0x30(%ebp)
80104e66:	e8 29 d1 ff ff       	call   80101f94 <nameiparent>
80104e6b:	89 c6                	mov    %eax,%esi
80104e6d:	83 c4 10             	add    $0x10,%esp
80104e70:	85 c0                	test   %eax,%eax
80104e72:	74 54                	je     80104ec8 <sys_link+0xec>
  ilock(dp);
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	50                   	push   %eax
80104e78:	e8 ab c8 ff ff       	call   80101728 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	8b 03                	mov    (%ebx),%eax
80104e82:	39 06                	cmp    %eax,(%esi)
80104e84:	75 36                	jne    80104ebc <sys_link+0xe0>
80104e86:	50                   	push   %eax
80104e87:	ff 73 04             	push   0x4(%ebx)
80104e8a:	57                   	push   %edi
80104e8b:	56                   	push   %esi
80104e8c:	e8 3b d0 ff ff       	call   80101ecc <dirlink>
80104e91:	83 c4 10             	add    $0x10,%esp
80104e94:	85 c0                	test   %eax,%eax
80104e96:	78 24                	js     80104ebc <sys_link+0xe0>
  iunlockput(dp);
80104e98:	83 ec 0c             	sub    $0xc,%esp
80104e9b:	56                   	push   %esi
80104e9c:	e8 db ca ff ff       	call   8010197c <iunlockput>
  iput(ip);
80104ea1:	89 1c 24             	mov    %ebx,(%esp)
80104ea4:	e8 8b c9 ff ff       	call   80101834 <iput>
  end_op();
80104ea9:	e8 7e dc ff ff       	call   80102b2c <end_op>
  return 0;
80104eae:	83 c4 10             	add    $0x10,%esp
80104eb1:	31 c0                	xor    %eax,%eax
}
80104eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb6:	5b                   	pop    %ebx
80104eb7:	5e                   	pop    %esi
80104eb8:	5f                   	pop    %edi
80104eb9:	5d                   	pop    %ebp
80104eba:	c3                   	ret
80104ebb:	90                   	nop
    iunlockput(dp);
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	56                   	push   %esi
80104ec0:	e8 b7 ca ff ff       	call   8010197c <iunlockput>
    goto bad;
80104ec5:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	53                   	push   %ebx
80104ecc:	e8 57 c8 ff ff       	call   80101728 <ilock>
  ip->nlink--;
80104ed1:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104ed5:	89 1c 24             	mov    %ebx,(%esp)
80104ed8:	e8 a3 c7 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
80104edd:	89 1c 24             	mov    %ebx,(%esp)
80104ee0:	e8 97 ca ff ff       	call   8010197c <iunlockput>
  end_op();
80104ee5:	e8 42 dc ff ff       	call   80102b2c <end_op>
  return -1;
80104eea:	83 c4 10             	add    $0x10,%esp
    return -1;
80104eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef2:	eb bf                	jmp    80104eb3 <sys_link+0xd7>
    iunlockput(ip);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	53                   	push   %ebx
80104ef8:	e8 7f ca ff ff       	call   8010197c <iunlockput>
    end_op();
80104efd:	e8 2a dc ff ff       	call   80102b2c <end_op>
    return -1;
80104f02:	83 c4 10             	add    $0x10,%esp
80104f05:	eb e6                	jmp    80104eed <sys_link+0x111>
    end_op();
80104f07:	e8 20 dc ff ff       	call   80102b2c <end_op>
    return -1;
80104f0c:	eb df                	jmp    80104eed <sys_link+0x111>
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <sys_unlink>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
80104f16:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f19:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f1c:	50                   	push   %eax
80104f1d:	6a 00                	push   $0x0
80104f1f:	e8 78 fa ff ff       	call   8010499c <argstr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	0f 88 50 01 00 00    	js     8010507f <sys_unlink+0x16f>
  begin_op();
80104f2f:	e8 90 db ff ff       	call   80102ac4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f34:	83 ec 08             	sub    $0x8,%esp
80104f37:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f3a:	53                   	push   %ebx
80104f3b:	ff 75 c0             	push   -0x40(%ebp)
80104f3e:	e8 51 d0 ff ff       	call   80101f94 <nameiparent>
80104f43:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	0f 84 4f 01 00 00    	je     801050a0 <sys_unlink+0x190>
  ilock(dp);
80104f51:	83 ec 0c             	sub    $0xc,%esp
80104f54:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80104f57:	57                   	push   %edi
80104f58:	e8 cb c7 ff ff       	call   80101728 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f5d:	59                   	pop    %ecx
80104f5e:	5e                   	pop    %esi
80104f5f:	68 39 73 10 80       	push   $0x80107339
80104f64:	53                   	push   %ebx
80104f65:	e8 aa cc ff ff       	call   80101c14 <namecmp>
80104f6a:	83 c4 10             	add    $0x10,%esp
80104f6d:	85 c0                	test   %eax,%eax
80104f6f:	0f 84 f7 00 00 00    	je     8010506c <sys_unlink+0x15c>
80104f75:	83 ec 08             	sub    $0x8,%esp
80104f78:	68 38 73 10 80       	push   $0x80107338
80104f7d:	53                   	push   %ebx
80104f7e:	e8 91 cc ff ff       	call   80101c14 <namecmp>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	0f 84 de 00 00 00    	je     8010506c <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f8e:	52                   	push   %edx
80104f8f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f92:	50                   	push   %eax
80104f93:	53                   	push   %ebx
80104f94:	57                   	push   %edi
80104f95:	e8 92 cc ff ff       	call   80101c2c <dirlookup>
80104f9a:	89 c3                	mov    %eax,%ebx
80104f9c:	83 c4 10             	add    $0x10,%esp
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	0f 84 c5 00 00 00    	je     8010506c <sys_unlink+0x15c>
  ilock(ip);
80104fa7:	83 ec 0c             	sub    $0xc,%esp
80104faa:	50                   	push   %eax
80104fab:	e8 78 c7 ff ff       	call   80101728 <ilock>
  if(ip->nlink < 1)
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104fb8:	0f 8e f6 00 00 00    	jle    801050b4 <sys_unlink+0x1a4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104fbe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fc3:	74 67                	je     8010502c <sys_unlink+0x11c>
80104fc5:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
80104fc8:	50                   	push   %eax
80104fc9:	6a 10                	push   $0x10
80104fcb:	6a 00                	push   $0x0
80104fcd:	57                   	push   %edi
80104fce:	e8 01 f7 ff ff       	call   801046d4 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fd3:	6a 10                	push   $0x10
80104fd5:	ff 75 c4             	push   -0x3c(%ebp)
80104fd8:	57                   	push   %edi
80104fd9:	ff 75 b4             	push   -0x4c(%ebp)
80104fdc:	e8 17 cb ff ff       	call   80101af8 <writei>
80104fe1:	83 c4 20             	add    $0x20,%esp
80104fe4:	83 f8 10             	cmp    $0x10,%eax
80104fe7:	0f 85 d4 00 00 00    	jne    801050c1 <sys_unlink+0x1b1>
  if(ip->type == T_DIR){
80104fed:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ff2:	0f 84 90 00 00 00    	je     80105088 <sys_unlink+0x178>
  iunlockput(dp);
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	ff 75 b4             	push   -0x4c(%ebp)
80104ffe:	e8 79 c9 ff ff       	call   8010197c <iunlockput>
  ip->nlink--;
80105003:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80105007:	89 1c 24             	mov    %ebx,(%esp)
8010500a:	e8 71 c6 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
8010500f:	89 1c 24             	mov    %ebx,(%esp)
80105012:	e8 65 c9 ff ff       	call   8010197c <iunlockput>
  end_op();
80105017:	e8 10 db ff ff       	call   80102b2c <end_op>
  return 0;
8010501c:	83 c4 10             	add    $0x10,%esp
8010501f:	31 c0                	xor    %eax,%eax
}
80105021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105024:	5b                   	pop    %ebx
80105025:	5e                   	pop    %esi
80105026:	5f                   	pop    %edi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret
80105029:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010502c:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105030:	76 93                	jbe    80104fc5 <sys_unlink+0xb5>
80105032:	be 20 00 00 00       	mov    $0x20,%esi
80105037:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010503a:	eb 08                	jmp    80105044 <sys_unlink+0x134>
8010503c:	83 c6 10             	add    $0x10,%esi
8010503f:	3b 73 58             	cmp    0x58(%ebx),%esi
80105042:	73 84                	jae    80104fc8 <sys_unlink+0xb8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105044:	6a 10                	push   $0x10
80105046:	56                   	push   %esi
80105047:	57                   	push   %edi
80105048:	53                   	push   %ebx
80105049:	e8 aa c9 ff ff       	call   801019f8 <readi>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	83 f8 10             	cmp    $0x10,%eax
80105054:	75 51                	jne    801050a7 <sys_unlink+0x197>
    if(de.inum != 0)
80105056:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010505b:	74 df                	je     8010503c <sys_unlink+0x12c>
    iunlockput(ip);
8010505d:	83 ec 0c             	sub    $0xc,%esp
80105060:	53                   	push   %ebx
80105061:	e8 16 c9 ff ff       	call   8010197c <iunlockput>
    goto bad;
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
8010506c:	83 ec 0c             	sub    $0xc,%esp
8010506f:	ff 75 b4             	push   -0x4c(%ebp)
80105072:	e8 05 c9 ff ff       	call   8010197c <iunlockput>
  end_op();
80105077:	e8 b0 da ff ff       	call   80102b2c <end_op>
  return -1;
8010507c:	83 c4 10             	add    $0x10,%esp
    return -1;
8010507f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105084:	eb 9b                	jmp    80105021 <sys_unlink+0x111>
80105086:	66 90                	xchg   %ax,%ax
    dp->nlink--;
80105088:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010508b:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
8010508f:	83 ec 0c             	sub    $0xc,%esp
80105092:	50                   	push   %eax
80105093:	e8 e8 c5 ff ff       	call   80101680 <iupdate>
80105098:	83 c4 10             	add    $0x10,%esp
8010509b:	e9 58 ff ff ff       	jmp    80104ff8 <sys_unlink+0xe8>
    end_op();
801050a0:	e8 87 da ff ff       	call   80102b2c <end_op>
    return -1;
801050a5:	eb d8                	jmp    8010507f <sys_unlink+0x16f>
      panic("isdirempty: readi");
801050a7:	83 ec 0c             	sub    $0xc,%esp
801050aa:	68 5d 73 10 80       	push   $0x8010735d
801050af:	e8 84 b2 ff ff       	call   80100338 <panic>
    panic("unlink: nlink < 1");
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	68 4b 73 10 80       	push   $0x8010734b
801050bc:	e8 77 b2 ff ff       	call   80100338 <panic>
    panic("unlink: writei");
801050c1:	83 ec 0c             	sub    $0xc,%esp
801050c4:	68 6f 73 10 80       	push   $0x8010736f
801050c9:	e8 6a b2 ff ff       	call   80100338 <panic>
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <sys_open>:

int
sys_open(void)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
801050d5:	53                   	push   %ebx
801050d6:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801050dc:	50                   	push   %eax
801050dd:	6a 00                	push   $0x0
801050df:	e8 b8 f8 ff ff       	call   8010499c <argstr>
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	85 c0                	test   %eax,%eax
801050e9:	0f 88 8c 00 00 00    	js     8010517b <sys_open+0xab>
801050ef:	83 ec 08             	sub    $0x8,%esp
801050f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050f5:	50                   	push   %eax
801050f6:	6a 01                	push   $0x1
801050f8:	e8 f3 f7 ff ff       	call   801048f0 <argint>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	78 77                	js     8010517b <sys_open+0xab>
    return -1;

  begin_op();
80105104:	e8 bb d9 ff ff       	call   80102ac4 <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105109:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
8010510c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105110:	75 72                	jne    80105184 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105112:	83 ec 0c             	sub    $0xc,%esp
80105115:	50                   	push   %eax
80105116:	e8 61 ce ff ff       	call   80101f7c <namei>
8010511b:	89 c6                	mov    %eax,%esi
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	85 c0                	test   %eax,%eax
80105122:	74 7a                	je     8010519e <sys_open+0xce>
      end_op();
      return -1;
    }
    ilock(ip);
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	50                   	push   %eax
80105128:	e8 fb c5 ff ff       	call   80101728 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105135:	0f 84 b1 00 00 00    	je     801051ec <sys_open+0x11c>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010513b:	e8 68 bd ff ff       	call   80100ea8 <filealloc>
80105140:	89 c7                	mov    %eax,%edi
80105142:	85 c0                	test   %eax,%eax
80105144:	74 24                	je     8010516a <sys_open+0x9a>
  struct proc *curproc = myproc();
80105146:	e8 bd e4 ff ff       	call   80103608 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010514b:	31 db                	xor    %ebx,%ebx
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105150:	8b 54 98 74          	mov    0x74(%eax,%ebx,4),%edx
80105154:	85 d2                	test   %edx,%edx
80105156:	74 50                	je     801051a8 <sys_open+0xd8>
  for(fd = 0; fd < NOFILE; fd++){
80105158:	43                   	inc    %ebx
80105159:	83 fb 10             	cmp    $0x10,%ebx
8010515c:	75 f2                	jne    80105150 <sys_open+0x80>
    if(f)
      fileclose(f);
8010515e:	83 ec 0c             	sub    $0xc,%esp
80105161:	57                   	push   %edi
80105162:	e8 ed bd ff ff       	call   80100f54 <fileclose>
80105167:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010516a:	83 ec 0c             	sub    $0xc,%esp
8010516d:	56                   	push   %esi
8010516e:	e8 09 c8 ff ff       	call   8010197c <iunlockput>
    end_op();
80105173:	e8 b4 d9 ff ff       	call   80102b2c <end_op>
    return -1;
80105178:	83 c4 10             	add    $0x10,%esp
    return -1;
8010517b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105180:	eb 5f                	jmp    801051e1 <sys_open+0x111>
80105182:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80105184:	83 ec 0c             	sub    $0xc,%esp
80105187:	6a 00                	push   $0x0
80105189:	31 c9                	xor    %ecx,%ecx
8010518b:	ba 02 00 00 00       	mov    $0x2,%edx
80105190:	e8 c7 f8 ff ff       	call   80104a5c <create>
80105195:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	85 c0                	test   %eax,%eax
8010519c:	75 9d                	jne    8010513b <sys_open+0x6b>
      end_op();
8010519e:	e8 89 d9 ff ff       	call   80102b2c <end_op>
      return -1;
801051a3:	eb d6                	jmp    8010517b <sys_open+0xab>
801051a5:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801051a8:	89 7c 98 74          	mov    %edi,0x74(%eax,%ebx,4)
  }
  iunlock(ip);
801051ac:	83 ec 0c             	sub    $0xc,%esp
801051af:	56                   	push   %esi
801051b0:	e8 3b c6 ff ff       	call   801017f0 <iunlock>
  end_op();
801051b5:	e8 72 d9 ff ff       	call   80102b2c <end_op>

  f->type = FD_INODE;
801051ba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
801051c0:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801051c3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801051ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801051cd:	89 d0                	mov    %edx,%eax
801051cf:	f7 d0                	not    %eax
801051d1:	83 e0 01             	and    $0x1,%eax
801051d4:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051d7:	83 c4 10             	add    $0x10,%esp
801051da:	83 e2 03             	and    $0x3,%edx
801051dd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801051e1:	89 d8                	mov    %ebx,%eax
801051e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e6:	5b                   	pop    %ebx
801051e7:	5e                   	pop    %esi
801051e8:	5f                   	pop    %edi
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret
801051eb:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801051ec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051ef:	85 c9                	test   %ecx,%ecx
801051f1:	0f 84 44 ff ff ff    	je     8010513b <sys_open+0x6b>
801051f7:	e9 6e ff ff ff       	jmp    8010516a <sys_open+0x9a>

801051fc <sys_mkdir>:

int
sys_mkdir(void)
{
801051fc:	55                   	push   %ebp
801051fd:	89 e5                	mov    %esp,%ebp
801051ff:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105202:	e8 bd d8 ff ff       	call   80102ac4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105207:	83 ec 08             	sub    $0x8,%esp
8010520a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520d:	50                   	push   %eax
8010520e:	6a 00                	push   $0x0
80105210:	e8 87 f7 ff ff       	call   8010499c <argstr>
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	85 c0                	test   %eax,%eax
8010521a:	78 30                	js     8010524c <sys_mkdir+0x50>
8010521c:	83 ec 0c             	sub    $0xc,%esp
8010521f:	6a 00                	push   $0x0
80105221:	31 c9                	xor    %ecx,%ecx
80105223:	ba 01 00 00 00       	mov    $0x1,%edx
80105228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010522b:	e8 2c f8 ff ff       	call   80104a5c <create>
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	85 c0                	test   %eax,%eax
80105235:	74 15                	je     8010524c <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	50                   	push   %eax
8010523b:	e8 3c c7 ff ff       	call   8010197c <iunlockput>
  end_op();
80105240:	e8 e7 d8 ff ff       	call   80102b2c <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	c9                   	leave
8010524b:	c3                   	ret
    end_op();
8010524c:	e8 db d8 ff ff       	call   80102b2c <end_op>
    return -1;
80105251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105256:	c9                   	leave
80105257:	c3                   	ret

80105258 <sys_mknod>:

int
sys_mknod(void)
{
80105258:	55                   	push   %ebp
80105259:	89 e5                	mov    %esp,%ebp
8010525b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010525e:	e8 61 d8 ff ff       	call   80102ac4 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105263:	83 ec 08             	sub    $0x8,%esp
80105266:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105269:	50                   	push   %eax
8010526a:	6a 00                	push   $0x0
8010526c:	e8 2b f7 ff ff       	call   8010499c <argstr>
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	85 c0                	test   %eax,%eax
80105276:	78 60                	js     801052d8 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105278:	83 ec 08             	sub    $0x8,%esp
8010527b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010527e:	50                   	push   %eax
8010527f:	6a 01                	push   $0x1
80105281:	e8 6a f6 ff ff       	call   801048f0 <argint>
  if((argstr(0, &path)) < 0 ||
80105286:	83 c4 10             	add    $0x10,%esp
80105289:	85 c0                	test   %eax,%eax
8010528b:	78 4b                	js     801052d8 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010528d:	83 ec 08             	sub    $0x8,%esp
80105290:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105293:	50                   	push   %eax
80105294:	6a 02                	push   $0x2
80105296:	e8 55 f6 ff ff       	call   801048f0 <argint>
     argint(1, &major) < 0 ||
8010529b:	83 c4 10             	add    $0x10,%esp
8010529e:	85 c0                	test   %eax,%eax
801052a0:	78 36                	js     801052d8 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801052a2:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801052a6:	83 ec 0c             	sub    $0xc,%esp
801052a9:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801052ad:	50                   	push   %eax
801052ae:	ba 03 00 00 00       	mov    $0x3,%edx
801052b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052b6:	e8 a1 f7 ff ff       	call   80104a5c <create>
     argint(2, &minor) < 0 ||
801052bb:	83 c4 10             	add    $0x10,%esp
801052be:	85 c0                	test   %eax,%eax
801052c0:	74 16                	je     801052d8 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052c2:	83 ec 0c             	sub    $0xc,%esp
801052c5:	50                   	push   %eax
801052c6:	e8 b1 c6 ff ff       	call   8010197c <iunlockput>
  end_op();
801052cb:	e8 5c d8 ff ff       	call   80102b2c <end_op>
  return 0;
801052d0:	83 c4 10             	add    $0x10,%esp
801052d3:	31 c0                	xor    %eax,%eax
}
801052d5:	c9                   	leave
801052d6:	c3                   	ret
801052d7:	90                   	nop
    end_op();
801052d8:	e8 4f d8 ff ff       	call   80102b2c <end_op>
    return -1;
801052dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052e2:	c9                   	leave
801052e3:	c3                   	ret

801052e4 <sys_chdir>:

int
sys_chdir(void)
{
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	56                   	push   %esi
801052e8:	53                   	push   %ebx
801052e9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052ec:	e8 17 e3 ff ff       	call   80103608 <myproc>
801052f1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052f3:	e8 cc d7 ff ff       	call   80102ac4 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052f8:	83 ec 08             	sub    $0x8,%esp
801052fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fe:	50                   	push   %eax
801052ff:	6a 00                	push   $0x0
80105301:	e8 96 f6 ff ff       	call   8010499c <argstr>
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	85 c0                	test   %eax,%eax
8010530b:	78 6b                	js     80105378 <sys_chdir+0x94>
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	ff 75 f4             	push   -0xc(%ebp)
80105313:	e8 64 cc ff ff       	call   80101f7c <namei>
80105318:	89 c3                	mov    %eax,%ebx
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	74 57                	je     80105378 <sys_chdir+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
80105321:	83 ec 0c             	sub    $0xc,%esp
80105324:	50                   	push   %eax
80105325:	e8 fe c3 ff ff       	call   80101728 <ilock>
  if(ip->type != T_DIR){
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105332:	75 2c                	jne    80105360 <sys_chdir+0x7c>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105334:	83 ec 0c             	sub    $0xc,%esp
80105337:	53                   	push   %ebx
80105338:	e8 b3 c4 ff ff       	call   801017f0 <iunlock>
  iput(curproc->cwd);
8010533d:	58                   	pop    %eax
8010533e:	ff b6 b4 00 00 00    	push   0xb4(%esi)
80105344:	e8 eb c4 ff ff       	call   80101834 <iput>
  end_op();
80105349:	e8 de d7 ff ff       	call   80102b2c <end_op>
  curproc->cwd = ip;
8010534e:	89 9e b4 00 00 00    	mov    %ebx,0xb4(%esi)
  return 0;
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	31 c0                	xor    %eax,%eax
}
80105359:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010535c:	5b                   	pop    %ebx
8010535d:	5e                   	pop    %esi
8010535e:	5d                   	pop    %ebp
8010535f:	c3                   	ret
    iunlockput(ip);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	53                   	push   %ebx
80105364:	e8 13 c6 ff ff       	call   8010197c <iunlockput>
    end_op();
80105369:	e8 be d7 ff ff       	call   80102b2c <end_op>
    return -1;
8010536e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105371:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105376:	eb e1                	jmp    80105359 <sys_chdir+0x75>
    end_op();
80105378:	e8 af d7 ff ff       	call   80102b2c <end_op>
    return -1;
8010537d:	eb f2                	jmp    80105371 <sys_chdir+0x8d>
8010537f:	90                   	nop

80105380 <sys_exec>:

int
sys_exec(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	53                   	push   %ebx
80105386:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010538c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105392:	50                   	push   %eax
80105393:	6a 00                	push   $0x0
80105395:	e8 02 f6 ff ff       	call   8010499c <argstr>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	78 79                	js     8010541a <sys_exec+0x9a>
801053a1:	83 ec 08             	sub    $0x8,%esp
801053a4:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053aa:	50                   	push   %eax
801053ab:	6a 01                	push   $0x1
801053ad:	e8 3e f5 ff ff       	call   801048f0 <argint>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 61                	js     8010541a <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053b9:	50                   	push   %eax
801053ba:	68 80 00 00 00       	push   $0x80
801053bf:	6a 00                	push   $0x0
801053c1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
801053c7:	57                   	push   %edi
801053c8:	e8 07 f3 ff ff       	call   801046d4 <memset>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
801053d2:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053d4:	83 ec 08             	sub    $0x8,%esp
801053d7:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801053dd:	50                   	push   %eax
801053de:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053e4:	01 d8                	add    %ebx,%eax
801053e6:	50                   	push   %eax
801053e7:	e8 94 f4 ff ff       	call   80104880 <fetchint>
801053ec:	83 c4 10             	add    $0x10,%esp
801053ef:	85 c0                	test   %eax,%eax
801053f1:	78 27                	js     8010541a <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
801053f3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053f9:	85 c0                	test   %eax,%eax
801053fb:	74 2b                	je     80105428 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053fd:	83 ec 08             	sub    $0x8,%esp
80105400:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80105403:	52                   	push   %edx
80105404:	50                   	push   %eax
80105405:	e8 a6 f4 ff ff       	call   801048b0 <fetchstr>
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	85 c0                	test   %eax,%eax
8010540f:	78 09                	js     8010541a <sys_exec+0x9a>
  for(i=0;; i++){
80105411:	46                   	inc    %esi
    if(i >= NELEM(argv))
80105412:	83 c3 04             	add    $0x4,%ebx
80105415:	83 fe 20             	cmp    $0x20,%esi
80105418:	75 ba                	jne    801053d4 <sys_exec+0x54>
    return -1;
8010541a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
8010541f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105422:	5b                   	pop    %ebx
80105423:	5e                   	pop    %esi
80105424:	5f                   	pop    %edi
80105425:	5d                   	pop    %ebp
80105426:	c3                   	ret
80105427:	90                   	nop
      argv[i] = 0;
80105428:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
8010542f:	00 00 00 00 
  return exec(path, argv);
80105433:	83 ec 08             	sub    $0x8,%esp
80105436:	57                   	push   %edi
80105437:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
8010543d:	e8 ea b6 ff ff       	call   80100b2c <exec>
80105442:	83 c4 10             	add    $0x10,%esp
}
80105445:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105448:	5b                   	pop    %ebx
80105449:	5e                   	pop    %esi
8010544a:	5f                   	pop    %edi
8010544b:	5d                   	pop    %ebp
8010544c:	c3                   	ret
8010544d:	8d 76 00             	lea    0x0(%esi),%esi

80105450 <sys_pipe>:

int
sys_pipe(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
80105456:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105459:	6a 08                	push   $0x8
8010545b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010545e:	50                   	push   %eax
8010545f:	6a 00                	push   $0x0
80105461:	e8 ce f4 ff ff       	call   80104934 <argptr>
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 7d                	js     801054ea <sys_pipe+0x9a>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010546d:	83 ec 08             	sub    $0x8,%esp
80105470:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105473:	50                   	push   %eax
80105474:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105477:	50                   	push   %eax
80105478:	e8 57 dc ff ff       	call   801030d4 <pipealloc>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	78 66                	js     801054ea <sys_pipe+0x9a>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105484:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
80105487:	e8 7c e1 ff ff       	call   80103608 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010548c:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
8010548e:	8b 74 98 74          	mov    0x74(%eax,%ebx,4),%esi
80105492:	85 f6                	test   %esi,%esi
80105494:	74 10                	je     801054a6 <sys_pipe+0x56>
80105496:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
80105498:	43                   	inc    %ebx
80105499:	83 fb 10             	cmp    $0x10,%ebx
8010549c:	74 35                	je     801054d3 <sys_pipe+0x83>
    if(curproc->ofile[fd] == 0){
8010549e:	8b 74 98 74          	mov    0x74(%eax,%ebx,4),%esi
801054a2:	85 f6                	test   %esi,%esi
801054a4:	75 f2                	jne    80105498 <sys_pipe+0x48>
      curproc->ofile[fd] = f;
801054a6:	8d 73 1c             	lea    0x1c(%ebx),%esi
801054a9:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801054b0:	e8 53 e1 ff ff       	call   80103608 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054b5:	31 d2                	xor    %edx,%edx
801054b7:	90                   	nop
    if(curproc->ofile[fd] == 0){
801054b8:	8b 4c 90 74          	mov    0x74(%eax,%edx,4),%ecx
801054bc:	85 c9                	test   %ecx,%ecx
801054be:	74 34                	je     801054f4 <sys_pipe+0xa4>
  for(fd = 0; fd < NOFILE; fd++){
801054c0:	42                   	inc    %edx
801054c1:	83 fa 10             	cmp    $0x10,%edx
801054c4:	75 f2                	jne    801054b8 <sys_pipe+0x68>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801054c6:	e8 3d e1 ff ff       	call   80103608 <myproc>
801054cb:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
801054d2:	00 
    fileclose(rf);
801054d3:	83 ec 0c             	sub    $0xc,%esp
801054d6:	ff 75 e0             	push   -0x20(%ebp)
801054d9:	e8 76 ba ff ff       	call   80100f54 <fileclose>
    fileclose(wf);
801054de:	58                   	pop    %eax
801054df:	ff 75 e4             	push   -0x1c(%ebp)
801054e2:	e8 6d ba ff ff       	call   80100f54 <fileclose>
    return -1;
801054e7:	83 c4 10             	add    $0x10,%esp
    return -1;
801054ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ef:	eb 14                	jmp    80105505 <sys_pipe+0xb5>
801054f1:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801054f4:	89 7c 90 74          	mov    %edi,0x74(%eax,%edx,4)
  }
  fd[0] = fd0;
801054f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054fb:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105500:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105503:	31 c0                	xor    %eax,%eax
}
80105505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105508:	5b                   	pop    %ebx
80105509:	5e                   	pop    %esi
8010550a:	5f                   	pop    %edi
8010550b:	5d                   	pop    %ebp
8010550c:	c3                   	ret
8010550d:	66 90                	xchg   %ax,%ax
8010550f:	90                   	nop

80105510 <sys_signal>:

//     myproc()->signal_handler = (void*)handler;
//     return 0;
// }

int sys_signal(void) {
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 1c             	sub    $0x1c,%esp
    void (*handler)(void);
    
    if (argptr(0, (void*)&handler, sizeof(void*)) < 0)
80105516:	6a 04                	push   $0x4
80105518:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551b:	50                   	push   %eax
8010551c:	6a 00                	push   $0x0
8010551e:	e8 11 f4 ff ff       	call   80104934 <argptr>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 12                	js     8010553c <sys_signal+0x2c>
        return -1;

    myproc()->signal_handler = handler;
8010552a:	e8 d9 e0 ff ff       	call   80103608 <myproc>
8010552f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105532:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
80105535:	31 c0                	xor    %eax,%eax
}
80105537:	c9                   	leave
80105538:	c3                   	ret
80105539:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
8010553c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105541:	c9                   	leave
80105542:	c3                   	ret
80105543:	90                   	nop

80105544 <sys_fork>:

 
int
sys_fork(void)
{
  return fork();
80105544:	e9 3b e2 ff ff       	jmp    80103784 <fork>
80105549:	8d 76 00             	lea    0x0(%esi),%esi

8010554c <sys_exit>:
}

int
sys_exit(void)
{
8010554c:	55                   	push   %ebp
8010554d:	89 e5                	mov    %esp,%ebp
8010554f:	83 ec 08             	sub    $0x8,%esp
  exit();
80105552:	e8 3d e4 ff ff       	call   80103994 <exit>
  return 0;  // not reached
}
80105557:	31 c0                	xor    %eax,%eax
80105559:	c9                   	leave
8010555a:	c3                   	ret
8010555b:	90                   	nop

8010555c <sys_wait>:

int
sys_wait(void)
{
  return wait();
8010555c:	e9 7f e7 ff ff       	jmp    80103ce0 <wait>
80105561:	8d 76 00             	lea    0x0(%esi),%esi

80105564 <sys_kill>:
}

int
sys_kill(void)
{
80105564:	55                   	push   %ebp
80105565:	89 e5                	mov    %esp,%ebp
80105567:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010556a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010556d:	50                   	push   %eax
8010556e:	6a 00                	push   $0x0
80105570:	e8 7b f3 ff ff       	call   801048f0 <argint>
80105575:	83 c4 10             	add    $0x10,%esp
80105578:	85 c0                	test   %eax,%eax
8010557a:	78 10                	js     8010558c <sys_kill+0x28>
    return -1;
  return kill(pid);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	ff 75 f4             	push   -0xc(%ebp)
80105582:	e8 ad e8 ff ff       	call   80103e34 <kill>
80105587:	83 c4 10             	add    $0x10,%esp
}
8010558a:	c9                   	leave
8010558b:	c3                   	ret
    return -1;
8010558c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105591:	c9                   	leave
80105592:	c3                   	ret
80105593:	90                   	nop

80105594 <sys_getpid>:

int
sys_getpid(void)
{
80105594:	55                   	push   %ebp
80105595:	89 e5                	mov    %esp,%ebp
80105597:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010559a:	e8 69 e0 ff ff       	call   80103608 <myproc>
8010559f:	8b 40 5c             	mov    0x5c(%eax),%eax
}
801055a2:	c9                   	leave
801055a3:	c3                   	ret

801055a4 <sys_sbrk>:

int
sys_sbrk(void)
{
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	53                   	push   %ebx
801055a8:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ae:	50                   	push   %eax
801055af:	6a 00                	push   $0x0
801055b1:	e8 3a f3 ff ff       	call   801048f0 <argint>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	78 23                	js     801055e0 <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
801055bd:	e8 46 e0 ff ff       	call   80103608 <myproc>
801055c2:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055c4:	83 ec 0c             	sub    $0xc,%esp
801055c7:	ff 75 f4             	push   -0xc(%ebp)
801055ca:	e8 45 e1 ff ff       	call   80103714 <growproc>
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	85 c0                	test   %eax,%eax
801055d4:	78 0a                	js     801055e0 <sys_sbrk+0x3c>
    return -1;
  return addr;
}
801055d6:	89 d8                	mov    %ebx,%eax
801055d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055db:	c9                   	leave
801055dc:	c3                   	ret
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055e5:	eb ef                	jmp    801055d6 <sys_sbrk+0x32>
801055e7:	90                   	nop

801055e8 <sys_sleep>:

int
sys_sleep(void)
{
801055e8:	55                   	push   %ebp
801055e9:	89 e5                	mov    %esp,%ebp
801055eb:	53                   	push   %ebx
801055ec:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f2:	50                   	push   %eax
801055f3:	6a 00                	push   $0x0
801055f5:	e8 f6 f2 ff ff       	call   801048f0 <argint>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	78 5c                	js     8010565d <sys_sleep+0x75>
    return -1;
  acquire(&tickslock);
80105601:	83 ec 0c             	sub    $0xc,%esp
80105604:	68 80 4f 11 80       	push   $0x80114f80
80105609:	e8 fa ef ff ff       	call   80104608 <acquire>
  ticks0 = ticks;
8010560e:	8b 1d 60 4f 11 80    	mov    0x80114f60,%ebx
  while(ticks - ticks0 < n){
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010561a:	85 d2                	test   %edx,%edx
8010561c:	75 23                	jne    80105641 <sys_sleep+0x59>
8010561e:	eb 44                	jmp    80105664 <sys_sleep+0x7c>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	68 80 4f 11 80       	push   $0x80114f80
80105628:	68 60 4f 11 80       	push   $0x80114f60
8010562d:	e8 a2 e5 ff ff       	call   80103bd4 <sleep>
  while(ticks - ticks0 < n){
80105632:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80105637:	29 d8                	sub    %ebx,%eax
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010563f:	73 23                	jae    80105664 <sys_sleep+0x7c>
    if(myproc()->killed){
80105641:	e8 c2 df ff ff       	call   80103608 <myproc>
80105646:	8b 40 70             	mov    0x70(%eax),%eax
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 d3                	je     80105620 <sys_sleep+0x38>
      release(&tickslock);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	68 80 4f 11 80       	push   $0x80114f80
80105655:	e8 4e ef ff ff       	call   801045a8 <release>
      return -1;
8010565a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105662:	eb 12                	jmp    80105676 <sys_sleep+0x8e>
  }
  release(&tickslock);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	68 80 4f 11 80       	push   $0x80114f80
8010566c:	e8 37 ef ff ff       	call   801045a8 <release>
  return 0;
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	31 c0                	xor    %eax,%eax
}
80105676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105679:	c9                   	leave
8010567a:	c3                   	ret
8010567b:	90                   	nop

8010567c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010567c:	55                   	push   %ebp
8010567d:	89 e5                	mov    %esp,%ebp
8010567f:	53                   	push   %ebx
80105680:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105683:	68 80 4f 11 80       	push   $0x80114f80
80105688:	e8 7b ef ff ff       	call   80104608 <acquire>
  xticks = ticks;
8010568d:	8b 1d 60 4f 11 80    	mov    0x80114f60,%ebx
  release(&tickslock);
80105693:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
8010569a:	e8 09 ef ff ff       	call   801045a8 <release>
  return xticks;
}
8010569f:	89 d8                	mov    %ebx,%eax
801056a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a4:	c9                   	leave
801056a5:	c3                   	ret

801056a6 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801056a6:	1e                   	push   %ds
  pushl %es
801056a7:	06                   	push   %es
  pushl %fs
801056a8:	0f a0                	push   %fs
  pushl %gs
801056aa:	0f a8                	push   %gs
  pushal
801056ac:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801056ad:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801056b1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801056b3:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801056b5:	54                   	push   %esp
  call trap
801056b6:	e8 a1 00 00 00       	call   8010575c <trap>
  addl $4, %esp
801056bb:	83 c4 04             	add    $0x4,%esp

801056be <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056be:	61                   	popa
  popl %gs
801056bf:	0f a9                	pop    %gs
  popl %fs
801056c1:	0f a1                	pop    %fs
  popl %es
801056c3:	07                   	pop    %es
  popl %ds
801056c4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056c5:	83 c4 08             	add    $0x8,%esp
  iret
801056c8:	cf                   	iret
801056c9:	66 90                	xchg   %ax,%ax
801056cb:	90                   	nop

801056cc <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056cc:	55                   	push   %ebp
801056cd:	89 e5                	mov    %esp,%ebp
801056cf:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
801056d2:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056d4:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801056db:	66 89 14 c5 c0 4f 11 	mov    %dx,-0x7feeb040(,%eax,8)
801056e2:	80 
801056e3:	c7 04 c5 c2 4f 11 80 	movl   $0x8e000008,-0x7feeb03e(,%eax,8)
801056ea:	08 00 00 8e 
801056ee:	c1 ea 10             	shr    $0x10,%edx
801056f1:	66 89 14 c5 c6 4f 11 	mov    %dx,-0x7feeb03a(,%eax,8)
801056f8:	80 
  for(i = 0; i < 256; i++)
801056f9:	40                   	inc    %eax
801056fa:	3d 00 01 00 00       	cmp    $0x100,%eax
801056ff:	75 d3                	jne    801056d4 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105701:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105706:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
8010570c:	c7 05 c2 51 11 80 08 	movl   $0xef000008,0x801151c2
80105713:	00 00 ef 
80105716:	c1 e8 10             	shr    $0x10,%eax
80105719:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6

  initlock(&tickslock, "time");
8010571f:	83 ec 08             	sub    $0x8,%esp
80105722:	68 7e 73 10 80       	push   $0x8010737e
80105727:	68 80 4f 11 80       	push   $0x80114f80
8010572c:	e8 0f ed ff ff       	call   80104440 <initlock>
}
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	c9                   	leave
80105735:	c3                   	ret
80105736:	66 90                	xchg   %ax,%ax

80105738 <idtinit>:

void
idtinit(void)
{
80105738:	55                   	push   %ebp
80105739:	89 e5                	mov    %esp,%ebp
8010573b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010573e:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105744:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
80105749:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010574d:	c1 e8 10             	shr    $0x10,%eax
80105750:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105754:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105757:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
8010575a:	c9                   	leave
8010575b:	c3                   	ret

8010575c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010575c:	55                   	push   %ebp
8010575d:	89 e5                	mov    %esp,%ebp
8010575f:	57                   	push   %edi
80105760:	56                   	push   %esi
80105761:	53                   	push   %ebx
80105762:	83 ec 1c             	sub    $0x1c,%esp
80105765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105768:	8b 43 30             	mov    0x30(%ebx),%eax
8010576b:	83 f8 40             	cmp    $0x40,%eax
8010576e:	0f 84 f0 01 00 00    	je     80105964 <trap+0x208>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105774:	83 e8 20             	sub    $0x20,%eax
80105777:	83 f8 1f             	cmp    $0x1f,%eax
8010577a:	0f 87 a8 00 00 00    	ja     80105828 <trap+0xcc>
80105780:	ff 24 85 64 79 10 80 	jmp    *-0x7fef869c(,%eax,4)
80105787:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105788:	e8 47 de ff ff       	call   801035d4 <cpuid>
8010578d:	85 c0                	test   %eax,%eax
8010578f:	0f 84 33 02 00 00    	je     801059c8 <trap+0x26c>

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105795:	e8 3a cf ff ff       	call   801026d4 <lapiceoi>
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  if(myproc() && myproc()->suspended && myproc()->pid > 2 && (tf->cs&3) ==  DPL_USER){
8010579a:	e8 69 de ff ff       	call   80103608 <myproc>
8010579f:	85 c0                	test   %eax,%eax
801057a1:	74 0c                	je     801057af <trap+0x53>
801057a3:	e8 60 de ff ff       	call   80103608 <myproc>
801057a8:	8b 48 10             	mov    0x10(%eax),%ecx
801057ab:	85 c9                	test   %ecx,%ecx
801057ad:	75 59                	jne    80105808 <trap+0xac>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057af:	e8 54 de ff ff       	call   80103608 <myproc>
801057b4:	85 c0                	test   %eax,%eax
801057b6:	74 19                	je     801057d1 <trap+0x75>
801057b8:	e8 4b de ff ff       	call   80103608 <myproc>
801057bd:	8b 50 70             	mov    0x70(%eax),%edx
801057c0:	85 d2                	test   %edx,%edx
801057c2:	74 0d                	je     801057d1 <trap+0x75>
801057c4:	8b 43 3c             	mov    0x3c(%ebx),%eax
801057c7:	f7 d0                	not    %eax
801057c9:	a8 03                	test   $0x3,%al
801057cb:	0f 84 cf 01 00 00    	je     801059a0 <trap+0x244>
    exit();

     if(myproc() && (tf->cs & 3) == DPL_USER && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
801057d1:	e8 32 de ff ff       	call   80103608 <myproc>
801057d6:	85 c0                	test   %eax,%eax
801057d8:	74 0d                	je     801057e7 <trap+0x8b>
801057da:	8b 43 3c             	mov    0x3c(%ebx),%eax
801057dd:	f7 d0                	not    %eax
801057df:	a8 03                	test   $0x3,%al
801057e1:	0f 84 cd 00 00 00    	je     801058b4 <trap+0x158>
// }


  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057e7:	e8 1c de ff ff       	call   80103608 <myproc>
801057ec:	85 c0                	test   %eax,%eax
801057ee:	74 0f                	je     801057ff <trap+0xa3>
801057f0:	e8 13 de ff ff       	call   80103608 <myproc>
801057f5:	83 78 58 05          	cmpl   $0x5,0x58(%eax)
801057f9:	0f 84 a1 00 00 00    	je     801058a0 <trap+0x144>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

}
801057ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105802:	5b                   	pop    %ebx
80105803:	5e                   	pop    %esi
80105804:	5f                   	pop    %edi
80105805:	5d                   	pop    %ebp
80105806:	c3                   	ret
80105807:	90                   	nop
  if(myproc() && myproc()->suspended && myproc()->pid > 2 && (tf->cs&3) ==  DPL_USER){
80105808:	e8 fb dd ff ff       	call   80103608 <myproc>
8010580d:	83 78 5c 02          	cmpl   $0x2,0x5c(%eax)
80105811:	7e 9c                	jle    801057af <trap+0x53>
80105813:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105816:	f7 d0                	not    %eax
80105818:	a8 03                	test   $0x3,%al
8010581a:	75 93                	jne    801057af <trap+0x53>
}
8010581c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010581f:	5b                   	pop    %ebx
80105820:	5e                   	pop    %esi
80105821:	5f                   	pop    %edi
80105822:	5d                   	pop    %ebp
     yield();
80105823:	e9 44 e3 ff ff       	jmp    80103b6c <yield>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105828:	e8 db dd ff ff       	call   80103608 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010582d:	8b 7b 38             	mov    0x38(%ebx),%edi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105830:	85 c0                	test   %eax,%eax
80105832:	0f 84 ce 01 00 00    	je     80105a06 <trap+0x2aa>
80105838:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010583c:	0f 84 c4 01 00 00    	je     80105a06 <trap+0x2aa>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105842:	0f 20 d1             	mov    %cr2,%ecx
80105845:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105848:	e8 87 dd ff ff       	call   801035d4 <cpuid>
8010584d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105850:	8b 43 34             	mov    0x34(%ebx),%eax
80105853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105856:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105859:	e8 aa dd ff ff       	call   80103608 <myproc>
8010585e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105861:	e8 a2 dd ff ff       	call   80103608 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105866:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105869:	51                   	push   %ecx
8010586a:	57                   	push   %edi
8010586b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010586e:	52                   	push   %edx
8010586f:	ff 75 e4             	push   -0x1c(%ebp)
80105872:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105873:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105876:	81 c6 b8 00 00 00    	add    $0xb8,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010587c:	56                   	push   %esi
8010587d:	ff 70 5c             	push   0x5c(%eax)
80105880:	68 30 76 10 80       	push   $0x80107630
80105885:	e8 96 ad ff ff       	call   80100620 <cprintf>
    myproc()->killed = 1;
8010588a:	83 c4 20             	add    $0x20,%esp
8010588d:	e8 76 dd ff ff       	call   80103608 <myproc>
80105892:	c7 40 70 01 00 00 00 	movl   $0x1,0x70(%eax)
80105899:	e9 fc fe ff ff       	jmp    8010579a <trap+0x3e>
8010589e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
801058a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801058a4:	0f 84 72 ff ff ff    	je     8010581c <trap+0xc0>
}
801058aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ad:	5b                   	pop    %ebx
801058ae:	5e                   	pop    %esi
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
801058b1:	c3                   	ret
801058b2:	66 90                	xchg   %ax,%ax
     if(myproc() && (tf->cs & 3) == DPL_USER && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
801058b4:	e8 4f dd ff ff       	call   80103608 <myproc>
801058b9:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
801058bd:	0f 85 24 ff ff ff    	jne    801057e7 <trap+0x8b>
801058c3:	e8 40 dd ff ff       	call   80103608 <myproc>
801058c8:	8b 40 0c             	mov    0xc(%eax),%eax
801058cb:	85 c0                	test   %eax,%eax
801058cd:	0f 84 14 ff ff ff    	je     801057e7 <trap+0x8b>
    myproc()->pending_signal = 0;         // Clear the pending signal flag.
801058d3:	e8 30 dd ff ff       	call   80103608 <myproc>
801058d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    myproc()->backup_eip = tf->eip;         // Backup current eip for sigreturn.
801058df:	e8 24 dd ff ff       	call   80103608 <myproc>
801058e4:	8b 53 38             	mov    0x38(%ebx),%edx
801058e7:	89 50 18             	mov    %edx,0x18(%eax)
    tf->eip = (uint)myproc()->signal_handler;
801058ea:	e8 19 dd ff ff       	call   80103608 <myproc>
801058ef:	8b 40 0c             	mov    0xc(%eax),%eax
801058f2:	89 43 38             	mov    %eax,0x38(%ebx)
801058f5:	e9 ed fe ff ff       	jmp    801057e7 <trap+0x8b>
801058fa:	66 90                	xchg   %ax,%ax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058fc:	8b 7b 38             	mov    0x38(%ebx),%edi
801058ff:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105903:	e8 cc dc ff ff       	call   801035d4 <cpuid>
80105908:	57                   	push   %edi
80105909:	56                   	push   %esi
8010590a:	50                   	push   %eax
8010590b:	68 d8 75 10 80       	push   $0x801075d8
80105910:	e8 0b ad ff ff       	call   80100620 <cprintf>
    lapiceoi();
80105915:	e8 ba cd ff ff       	call   801026d4 <lapiceoi>
    break;
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	e9 78 fe ff ff       	jmp    8010579a <trap+0x3e>
80105922:	66 90                	xchg   %ax,%ax
    if(myproc() && myproc()->suspended && myproc()->state == SLEEPING){
80105924:	e8 df dc ff ff       	call   80103608 <myproc>
80105929:	85 c0                	test   %eax,%eax
8010592b:	74 0c                	je     80105939 <trap+0x1dd>
8010592d:	e8 d6 dc ff ff       	call   80103608 <myproc>
80105932:	8b 70 10             	mov    0x10(%eax),%esi
80105935:	85 f6                	test   %esi,%esi
80105937:	75 73                	jne    801059ac <trap+0x250>
    uartintr();
80105939:	e8 26 02 00 00       	call   80105b64 <uartintr>
    lapiceoi();
8010593e:	e8 91 cd ff ff       	call   801026d4 <lapiceoi>
    break;
80105943:	e9 52 fe ff ff       	jmp    8010579a <trap+0x3e>
    kbdintr();
80105948:	e8 7b cc ff ff       	call   801025c8 <kbdintr>
    lapiceoi();
8010594d:	e8 82 cd ff ff       	call   801026d4 <lapiceoi>
    break;
80105952:	e9 43 fe ff ff       	jmp    8010579a <trap+0x3e>
80105957:	90                   	nop
    ideintr();
80105958:	e8 6b c7 ff ff       	call   801020c8 <ideintr>
8010595d:	e9 33 fe ff ff       	jmp    80105795 <trap+0x39>
80105962:	66 90                	xchg   %ax,%ax
    if(myproc()->killed)
80105964:	e8 9f dc ff ff       	call   80103608 <myproc>
80105969:	8b 40 70             	mov    0x70(%eax),%eax
8010596c:	85 c0                	test   %eax,%eax
8010596e:	0f 85 88 00 00 00    	jne    801059fc <trap+0x2a0>
    myproc()->tf = tf;
80105974:	e8 8f dc ff ff       	call   80103608 <myproc>
80105979:	89 58 64             	mov    %ebx,0x64(%eax)
    syscall();
8010597c:	e8 7f f0 ff ff       	call   80104a00 <syscall>
    if(myproc()->killed)
80105981:	e8 82 dc ff ff       	call   80103608 <myproc>
80105986:	8b 78 70             	mov    0x70(%eax),%edi
80105989:	85 ff                	test   %edi,%edi
8010598b:	0f 84 6e fe ff ff    	je     801057ff <trap+0xa3>
}
80105991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105994:	5b                   	pop    %ebx
80105995:	5e                   	pop    %esi
80105996:	5f                   	pop    %edi
80105997:	5d                   	pop    %ebp
      exit();
80105998:	e9 f7 df ff ff       	jmp    80103994 <exit>
8010599d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801059a0:	e8 ef df ff ff       	call   80103994 <exit>
801059a5:	e9 27 fe ff ff       	jmp    801057d1 <trap+0x75>
801059aa:	66 90                	xchg   %ax,%ax
    if(myproc() && myproc()->suspended && myproc()->state == SLEEPING){
801059ac:	e8 57 dc ff ff       	call   80103608 <myproc>
801059b1:	83 78 58 02          	cmpl   $0x2,0x58(%eax)
801059b5:	75 82                	jne    80105939 <trap+0x1dd>
      myproc()->state = RUNNABLE;
801059b7:	e8 4c dc ff ff       	call   80103608 <myproc>
801059bc:	c7 40 58 04 00 00 00 	movl   $0x4,0x58(%eax)
801059c3:	e9 71 ff ff ff       	jmp    80105939 <trap+0x1dd>
      acquire(&tickslock);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	68 80 4f 11 80       	push   $0x80114f80
801059d0:	e8 33 ec ff ff       	call   80104608 <acquire>
      ticks++;
801059d5:	ff 05 60 4f 11 80    	incl   0x80114f60
      wakeup(&ticks);
801059db:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
801059e2:	e8 e9 e3 ff ff       	call   80103dd0 <wakeup>
      release(&tickslock);
801059e7:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801059ee:	e8 b5 eb ff ff       	call   801045a8 <release>
801059f3:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801059f6:	e9 9a fd ff ff       	jmp    80105795 <trap+0x39>
801059fb:	90                   	nop
      exit();
801059fc:	e8 93 df ff ff       	call   80103994 <exit>
80105a01:	e9 6e ff ff ff       	jmp    80105974 <trap+0x218>
80105a06:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a09:	e8 c6 db ff ff       	call   801035d4 <cpuid>
80105a0e:	83 ec 0c             	sub    $0xc,%esp
80105a11:	56                   	push   %esi
80105a12:	57                   	push   %edi
80105a13:	50                   	push   %eax
80105a14:	ff 73 30             	push   0x30(%ebx)
80105a17:	68 fc 75 10 80       	push   $0x801075fc
80105a1c:	e8 ff ab ff ff       	call   80100620 <cprintf>
      panic("trap");
80105a21:	83 c4 14             	add    $0x14,%esp
80105a24:	68 83 73 10 80       	push   $0x80107383
80105a29:	e8 0a a9 ff ff       	call   80100338 <panic>
80105a2e:	66 90                	xchg   %ax,%ax

80105a30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a30:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80105a35:	85 c0                	test   %eax,%eax
80105a37:	74 17                	je     80105a50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a3f:	a8 01                	test   $0x1,%al
80105a41:	74 0d                	je     80105a50 <uartgetc+0x20>
80105a43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a49:	0f b6 c0             	movzbl %al,%eax
80105a4c:	c3                   	ret
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a55:	c3                   	ret
80105a56:	66 90                	xchg   %ax,%ax

80105a58 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a58:	31 c9                	xor    %ecx,%ecx
80105a5a:	88 c8                	mov    %cl,%al
80105a5c:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105a61:	ee                   	out    %al,(%dx)
80105a62:	b0 80                	mov    $0x80,%al
80105a64:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105a69:	ee                   	out    %al,(%dx)
80105a6a:	b0 0c                	mov    $0xc,%al
80105a6c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a71:	ee                   	out    %al,(%dx)
80105a72:	88 c8                	mov    %cl,%al
80105a74:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105a79:	ee                   	out    %al,(%dx)
80105a7a:	b0 03                	mov    $0x3,%al
80105a7c:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105a81:	ee                   	out    %al,(%dx)
80105a82:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105a87:	88 c8                	mov    %cl,%al
80105a89:	ee                   	out    %al,(%dx)
80105a8a:	b0 01                	mov    $0x1,%al
80105a8c:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105a91:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a92:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a97:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105a98:	fe c0                	inc    %al
80105a9a:	74 7e                	je     80105b1a <uartinit+0xc2>
{
80105a9c:	55                   	push   %ebp
80105a9d:	89 e5                	mov    %esp,%ebp
80105a9f:	57                   	push   %edi
80105aa0:	56                   	push   %esi
80105aa1:	53                   	push   %ebx
80105aa2:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
80105aa5:	c7 05 c0 57 11 80 01 	movl   $0x1,0x801157c0
80105aac:	00 00 00 
80105aaf:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105ab4:	ec                   	in     (%dx),%al
80105ab5:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aba:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105abb:	6a 00                	push   $0x0
80105abd:	6a 04                	push   $0x4
80105abf:	e8 14 c8 ff ff       	call   801022d8 <ioapicenable>
80105ac4:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ac7:	bf 88 73 10 80       	mov    $0x80107388,%edi
80105acc:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105ad0:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ad5:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ad8:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80105add:	85 c0                	test   %eax,%eax
80105adf:	74 27                	je     80105b08 <uartinit+0xb0>
80105ae1:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ae6:	eb 10                	jmp    80105af8 <uartinit+0xa0>
    microdelay(10);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	6a 0a                	push   $0xa
80105aed:	e8 fa cb ff ff       	call   801026ec <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	4b                   	dec    %ebx
80105af6:	74 07                	je     80105aff <uartinit+0xa7>
80105af8:	89 f2                	mov    %esi,%edx
80105afa:	ec                   	in     (%dx),%al
80105afb:	a8 20                	test   $0x20,%al
80105afd:	74 e9                	je     80105ae8 <uartinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105aff:	8a 45 e7             	mov    -0x19(%ebp),%al
80105b02:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b07:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105b08:	47                   	inc    %edi
80105b09:	8a 07                	mov    (%edi),%al
80105b0b:	88 45 e7             	mov    %al,-0x19(%ebp)
80105b0e:	84 c0                	test   %al,%al
80105b10:	75 c6                	jne    80105ad8 <uartinit+0x80>
}
80105b12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b15:	5b                   	pop    %ebx
80105b16:	5e                   	pop    %esi
80105b17:	5f                   	pop    %edi
80105b18:	5d                   	pop    %ebp
80105b19:	c3                   	ret
80105b1a:	c3                   	ret
80105b1b:	90                   	nop

80105b1c <uartputc>:
  if(!uart)
80105b1c:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80105b21:	85 c0                	test   %eax,%eax
80105b23:	74 3b                	je     80105b60 <uartputc+0x44>
{
80105b25:	55                   	push   %ebp
80105b26:	89 e5                	mov    %esp,%ebp
80105b28:	56                   	push   %esi
80105b29:	53                   	push   %ebx
80105b2a:	bb 80 00 00 00       	mov    $0x80,%ebx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b2f:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b34:	eb 12                	jmp    80105b48 <uartputc+0x2c>
80105b36:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	6a 0a                	push   $0xa
80105b3d:	e8 aa cb ff ff       	call   801026ec <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b42:	83 c4 10             	add    $0x10,%esp
80105b45:	4b                   	dec    %ebx
80105b46:	74 07                	je     80105b4f <uartputc+0x33>
80105b48:	89 f2                	mov    %esi,%edx
80105b4a:	ec                   	in     (%dx),%al
80105b4b:	a8 20                	test   $0x20,%al
80105b4d:	74 e9                	je     80105b38 <uartputc+0x1c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b52:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b57:	ee                   	out    %al,(%dx)
}
80105b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b5b:	5b                   	pop    %ebx
80105b5c:	5e                   	pop    %esi
80105b5d:	5d                   	pop    %ebp
80105b5e:	c3                   	ret
80105b5f:	90                   	nop
80105b60:	c3                   	ret
80105b61:	8d 76 00             	lea    0x0(%esi),%esi

80105b64 <uartintr>:

void
uartintr(void)
{
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b6a:	68 30 5a 10 80       	push   $0x80105a30
80105b6f:	e8 74 ac ff ff       	call   801007e8 <consoleintr>
}
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	c9                   	leave
80105b78:	c3                   	ret

80105b79 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b79:	6a 00                	push   $0x0
  pushl $0
80105b7b:	6a 00                	push   $0x0
  jmp alltraps
80105b7d:	e9 24 fb ff ff       	jmp    801056a6 <alltraps>

80105b82 <vector1>:
.globl vector1
vector1:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $1
80105b84:	6a 01                	push   $0x1
  jmp alltraps
80105b86:	e9 1b fb ff ff       	jmp    801056a6 <alltraps>

80105b8b <vector2>:
.globl vector2
vector2:
  pushl $0
80105b8b:	6a 00                	push   $0x0
  pushl $2
80105b8d:	6a 02                	push   $0x2
  jmp alltraps
80105b8f:	e9 12 fb ff ff       	jmp    801056a6 <alltraps>

80105b94 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b94:	6a 00                	push   $0x0
  pushl $3
80105b96:	6a 03                	push   $0x3
  jmp alltraps
80105b98:	e9 09 fb ff ff       	jmp    801056a6 <alltraps>

80105b9d <vector4>:
.globl vector4
vector4:
  pushl $0
80105b9d:	6a 00                	push   $0x0
  pushl $4
80105b9f:	6a 04                	push   $0x4
  jmp alltraps
80105ba1:	e9 00 fb ff ff       	jmp    801056a6 <alltraps>

80105ba6 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $5
80105ba8:	6a 05                	push   $0x5
  jmp alltraps
80105baa:	e9 f7 fa ff ff       	jmp    801056a6 <alltraps>

80105baf <vector6>:
.globl vector6
vector6:
  pushl $0
80105baf:	6a 00                	push   $0x0
  pushl $6
80105bb1:	6a 06                	push   $0x6
  jmp alltraps
80105bb3:	e9 ee fa ff ff       	jmp    801056a6 <alltraps>

80105bb8 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bb8:	6a 00                	push   $0x0
  pushl $7
80105bba:	6a 07                	push   $0x7
  jmp alltraps
80105bbc:	e9 e5 fa ff ff       	jmp    801056a6 <alltraps>

80105bc1 <vector8>:
.globl vector8
vector8:
  pushl $8
80105bc1:	6a 08                	push   $0x8
  jmp alltraps
80105bc3:	e9 de fa ff ff       	jmp    801056a6 <alltraps>

80105bc8 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $9
80105bca:	6a 09                	push   $0x9
  jmp alltraps
80105bcc:	e9 d5 fa ff ff       	jmp    801056a6 <alltraps>

80105bd1 <vector10>:
.globl vector10
vector10:
  pushl $10
80105bd1:	6a 0a                	push   $0xa
  jmp alltraps
80105bd3:	e9 ce fa ff ff       	jmp    801056a6 <alltraps>

80105bd8 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bd8:	6a 0b                	push   $0xb
  jmp alltraps
80105bda:	e9 c7 fa ff ff       	jmp    801056a6 <alltraps>

80105bdf <vector12>:
.globl vector12
vector12:
  pushl $12
80105bdf:	6a 0c                	push   $0xc
  jmp alltraps
80105be1:	e9 c0 fa ff ff       	jmp    801056a6 <alltraps>

80105be6 <vector13>:
.globl vector13
vector13:
  pushl $13
80105be6:	6a 0d                	push   $0xd
  jmp alltraps
80105be8:	e9 b9 fa ff ff       	jmp    801056a6 <alltraps>

80105bed <vector14>:
.globl vector14
vector14:
  pushl $14
80105bed:	6a 0e                	push   $0xe
  jmp alltraps
80105bef:	e9 b2 fa ff ff       	jmp    801056a6 <alltraps>

80105bf4 <vector15>:
.globl vector15
vector15:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $15
80105bf6:	6a 0f                	push   $0xf
  jmp alltraps
80105bf8:	e9 a9 fa ff ff       	jmp    801056a6 <alltraps>

80105bfd <vector16>:
.globl vector16
vector16:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $16
80105bff:	6a 10                	push   $0x10
  jmp alltraps
80105c01:	e9 a0 fa ff ff       	jmp    801056a6 <alltraps>

80105c06 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c06:	6a 11                	push   $0x11
  jmp alltraps
80105c08:	e9 99 fa ff ff       	jmp    801056a6 <alltraps>

80105c0d <vector18>:
.globl vector18
vector18:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $18
80105c0f:	6a 12                	push   $0x12
  jmp alltraps
80105c11:	e9 90 fa ff ff       	jmp    801056a6 <alltraps>

80105c16 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $19
80105c18:	6a 13                	push   $0x13
  jmp alltraps
80105c1a:	e9 87 fa ff ff       	jmp    801056a6 <alltraps>

80105c1f <vector20>:
.globl vector20
vector20:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $20
80105c21:	6a 14                	push   $0x14
  jmp alltraps
80105c23:	e9 7e fa ff ff       	jmp    801056a6 <alltraps>

80105c28 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $21
80105c2a:	6a 15                	push   $0x15
  jmp alltraps
80105c2c:	e9 75 fa ff ff       	jmp    801056a6 <alltraps>

80105c31 <vector22>:
.globl vector22
vector22:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $22
80105c33:	6a 16                	push   $0x16
  jmp alltraps
80105c35:	e9 6c fa ff ff       	jmp    801056a6 <alltraps>

80105c3a <vector23>:
.globl vector23
vector23:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $23
80105c3c:	6a 17                	push   $0x17
  jmp alltraps
80105c3e:	e9 63 fa ff ff       	jmp    801056a6 <alltraps>

80105c43 <vector24>:
.globl vector24
vector24:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $24
80105c45:	6a 18                	push   $0x18
  jmp alltraps
80105c47:	e9 5a fa ff ff       	jmp    801056a6 <alltraps>

80105c4c <vector25>:
.globl vector25
vector25:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $25
80105c4e:	6a 19                	push   $0x19
  jmp alltraps
80105c50:	e9 51 fa ff ff       	jmp    801056a6 <alltraps>

80105c55 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $26
80105c57:	6a 1a                	push   $0x1a
  jmp alltraps
80105c59:	e9 48 fa ff ff       	jmp    801056a6 <alltraps>

80105c5e <vector27>:
.globl vector27
vector27:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $27
80105c60:	6a 1b                	push   $0x1b
  jmp alltraps
80105c62:	e9 3f fa ff ff       	jmp    801056a6 <alltraps>

80105c67 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $28
80105c69:	6a 1c                	push   $0x1c
  jmp alltraps
80105c6b:	e9 36 fa ff ff       	jmp    801056a6 <alltraps>

80105c70 <vector29>:
.globl vector29
vector29:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $29
80105c72:	6a 1d                	push   $0x1d
  jmp alltraps
80105c74:	e9 2d fa ff ff       	jmp    801056a6 <alltraps>

80105c79 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $30
80105c7b:	6a 1e                	push   $0x1e
  jmp alltraps
80105c7d:	e9 24 fa ff ff       	jmp    801056a6 <alltraps>

80105c82 <vector31>:
.globl vector31
vector31:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $31
80105c84:	6a 1f                	push   $0x1f
  jmp alltraps
80105c86:	e9 1b fa ff ff       	jmp    801056a6 <alltraps>

80105c8b <vector32>:
.globl vector32
vector32:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $32
80105c8d:	6a 20                	push   $0x20
  jmp alltraps
80105c8f:	e9 12 fa ff ff       	jmp    801056a6 <alltraps>

80105c94 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $33
80105c96:	6a 21                	push   $0x21
  jmp alltraps
80105c98:	e9 09 fa ff ff       	jmp    801056a6 <alltraps>

80105c9d <vector34>:
.globl vector34
vector34:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $34
80105c9f:	6a 22                	push   $0x22
  jmp alltraps
80105ca1:	e9 00 fa ff ff       	jmp    801056a6 <alltraps>

80105ca6 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $35
80105ca8:	6a 23                	push   $0x23
  jmp alltraps
80105caa:	e9 f7 f9 ff ff       	jmp    801056a6 <alltraps>

80105caf <vector36>:
.globl vector36
vector36:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $36
80105cb1:	6a 24                	push   $0x24
  jmp alltraps
80105cb3:	e9 ee f9 ff ff       	jmp    801056a6 <alltraps>

80105cb8 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $37
80105cba:	6a 25                	push   $0x25
  jmp alltraps
80105cbc:	e9 e5 f9 ff ff       	jmp    801056a6 <alltraps>

80105cc1 <vector38>:
.globl vector38
vector38:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $38
80105cc3:	6a 26                	push   $0x26
  jmp alltraps
80105cc5:	e9 dc f9 ff ff       	jmp    801056a6 <alltraps>

80105cca <vector39>:
.globl vector39
vector39:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $39
80105ccc:	6a 27                	push   $0x27
  jmp alltraps
80105cce:	e9 d3 f9 ff ff       	jmp    801056a6 <alltraps>

80105cd3 <vector40>:
.globl vector40
vector40:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $40
80105cd5:	6a 28                	push   $0x28
  jmp alltraps
80105cd7:	e9 ca f9 ff ff       	jmp    801056a6 <alltraps>

80105cdc <vector41>:
.globl vector41
vector41:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $41
80105cde:	6a 29                	push   $0x29
  jmp alltraps
80105ce0:	e9 c1 f9 ff ff       	jmp    801056a6 <alltraps>

80105ce5 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $42
80105ce7:	6a 2a                	push   $0x2a
  jmp alltraps
80105ce9:	e9 b8 f9 ff ff       	jmp    801056a6 <alltraps>

80105cee <vector43>:
.globl vector43
vector43:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $43
80105cf0:	6a 2b                	push   $0x2b
  jmp alltraps
80105cf2:	e9 af f9 ff ff       	jmp    801056a6 <alltraps>

80105cf7 <vector44>:
.globl vector44
vector44:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $44
80105cf9:	6a 2c                	push   $0x2c
  jmp alltraps
80105cfb:	e9 a6 f9 ff ff       	jmp    801056a6 <alltraps>

80105d00 <vector45>:
.globl vector45
vector45:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $45
80105d02:	6a 2d                	push   $0x2d
  jmp alltraps
80105d04:	e9 9d f9 ff ff       	jmp    801056a6 <alltraps>

80105d09 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $46
80105d0b:	6a 2e                	push   $0x2e
  jmp alltraps
80105d0d:	e9 94 f9 ff ff       	jmp    801056a6 <alltraps>

80105d12 <vector47>:
.globl vector47
vector47:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $47
80105d14:	6a 2f                	push   $0x2f
  jmp alltraps
80105d16:	e9 8b f9 ff ff       	jmp    801056a6 <alltraps>

80105d1b <vector48>:
.globl vector48
vector48:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $48
80105d1d:	6a 30                	push   $0x30
  jmp alltraps
80105d1f:	e9 82 f9 ff ff       	jmp    801056a6 <alltraps>

80105d24 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $49
80105d26:	6a 31                	push   $0x31
  jmp alltraps
80105d28:	e9 79 f9 ff ff       	jmp    801056a6 <alltraps>

80105d2d <vector50>:
.globl vector50
vector50:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $50
80105d2f:	6a 32                	push   $0x32
  jmp alltraps
80105d31:	e9 70 f9 ff ff       	jmp    801056a6 <alltraps>

80105d36 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $51
80105d38:	6a 33                	push   $0x33
  jmp alltraps
80105d3a:	e9 67 f9 ff ff       	jmp    801056a6 <alltraps>

80105d3f <vector52>:
.globl vector52
vector52:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $52
80105d41:	6a 34                	push   $0x34
  jmp alltraps
80105d43:	e9 5e f9 ff ff       	jmp    801056a6 <alltraps>

80105d48 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $53
80105d4a:	6a 35                	push   $0x35
  jmp alltraps
80105d4c:	e9 55 f9 ff ff       	jmp    801056a6 <alltraps>

80105d51 <vector54>:
.globl vector54
vector54:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $54
80105d53:	6a 36                	push   $0x36
  jmp alltraps
80105d55:	e9 4c f9 ff ff       	jmp    801056a6 <alltraps>

80105d5a <vector55>:
.globl vector55
vector55:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $55
80105d5c:	6a 37                	push   $0x37
  jmp alltraps
80105d5e:	e9 43 f9 ff ff       	jmp    801056a6 <alltraps>

80105d63 <vector56>:
.globl vector56
vector56:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $56
80105d65:	6a 38                	push   $0x38
  jmp alltraps
80105d67:	e9 3a f9 ff ff       	jmp    801056a6 <alltraps>

80105d6c <vector57>:
.globl vector57
vector57:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $57
80105d6e:	6a 39                	push   $0x39
  jmp alltraps
80105d70:	e9 31 f9 ff ff       	jmp    801056a6 <alltraps>

80105d75 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $58
80105d77:	6a 3a                	push   $0x3a
  jmp alltraps
80105d79:	e9 28 f9 ff ff       	jmp    801056a6 <alltraps>

80105d7e <vector59>:
.globl vector59
vector59:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $59
80105d80:	6a 3b                	push   $0x3b
  jmp alltraps
80105d82:	e9 1f f9 ff ff       	jmp    801056a6 <alltraps>

80105d87 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $60
80105d89:	6a 3c                	push   $0x3c
  jmp alltraps
80105d8b:	e9 16 f9 ff ff       	jmp    801056a6 <alltraps>

80105d90 <vector61>:
.globl vector61
vector61:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $61
80105d92:	6a 3d                	push   $0x3d
  jmp alltraps
80105d94:	e9 0d f9 ff ff       	jmp    801056a6 <alltraps>

80105d99 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $62
80105d9b:	6a 3e                	push   $0x3e
  jmp alltraps
80105d9d:	e9 04 f9 ff ff       	jmp    801056a6 <alltraps>

80105da2 <vector63>:
.globl vector63
vector63:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $63
80105da4:	6a 3f                	push   $0x3f
  jmp alltraps
80105da6:	e9 fb f8 ff ff       	jmp    801056a6 <alltraps>

80105dab <vector64>:
.globl vector64
vector64:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $64
80105dad:	6a 40                	push   $0x40
  jmp alltraps
80105daf:	e9 f2 f8 ff ff       	jmp    801056a6 <alltraps>

80105db4 <vector65>:
.globl vector65
vector65:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $65
80105db6:	6a 41                	push   $0x41
  jmp alltraps
80105db8:	e9 e9 f8 ff ff       	jmp    801056a6 <alltraps>

80105dbd <vector66>:
.globl vector66
vector66:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $66
80105dbf:	6a 42                	push   $0x42
  jmp alltraps
80105dc1:	e9 e0 f8 ff ff       	jmp    801056a6 <alltraps>

80105dc6 <vector67>:
.globl vector67
vector67:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $67
80105dc8:	6a 43                	push   $0x43
  jmp alltraps
80105dca:	e9 d7 f8 ff ff       	jmp    801056a6 <alltraps>

80105dcf <vector68>:
.globl vector68
vector68:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $68
80105dd1:	6a 44                	push   $0x44
  jmp alltraps
80105dd3:	e9 ce f8 ff ff       	jmp    801056a6 <alltraps>

80105dd8 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $69
80105dda:	6a 45                	push   $0x45
  jmp alltraps
80105ddc:	e9 c5 f8 ff ff       	jmp    801056a6 <alltraps>

80105de1 <vector70>:
.globl vector70
vector70:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $70
80105de3:	6a 46                	push   $0x46
  jmp alltraps
80105de5:	e9 bc f8 ff ff       	jmp    801056a6 <alltraps>

80105dea <vector71>:
.globl vector71
vector71:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $71
80105dec:	6a 47                	push   $0x47
  jmp alltraps
80105dee:	e9 b3 f8 ff ff       	jmp    801056a6 <alltraps>

80105df3 <vector72>:
.globl vector72
vector72:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $72
80105df5:	6a 48                	push   $0x48
  jmp alltraps
80105df7:	e9 aa f8 ff ff       	jmp    801056a6 <alltraps>

80105dfc <vector73>:
.globl vector73
vector73:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $73
80105dfe:	6a 49                	push   $0x49
  jmp alltraps
80105e00:	e9 a1 f8 ff ff       	jmp    801056a6 <alltraps>

80105e05 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $74
80105e07:	6a 4a                	push   $0x4a
  jmp alltraps
80105e09:	e9 98 f8 ff ff       	jmp    801056a6 <alltraps>

80105e0e <vector75>:
.globl vector75
vector75:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $75
80105e10:	6a 4b                	push   $0x4b
  jmp alltraps
80105e12:	e9 8f f8 ff ff       	jmp    801056a6 <alltraps>

80105e17 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $76
80105e19:	6a 4c                	push   $0x4c
  jmp alltraps
80105e1b:	e9 86 f8 ff ff       	jmp    801056a6 <alltraps>

80105e20 <vector77>:
.globl vector77
vector77:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $77
80105e22:	6a 4d                	push   $0x4d
  jmp alltraps
80105e24:	e9 7d f8 ff ff       	jmp    801056a6 <alltraps>

80105e29 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $78
80105e2b:	6a 4e                	push   $0x4e
  jmp alltraps
80105e2d:	e9 74 f8 ff ff       	jmp    801056a6 <alltraps>

80105e32 <vector79>:
.globl vector79
vector79:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $79
80105e34:	6a 4f                	push   $0x4f
  jmp alltraps
80105e36:	e9 6b f8 ff ff       	jmp    801056a6 <alltraps>

80105e3b <vector80>:
.globl vector80
vector80:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $80
80105e3d:	6a 50                	push   $0x50
  jmp alltraps
80105e3f:	e9 62 f8 ff ff       	jmp    801056a6 <alltraps>

80105e44 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $81
80105e46:	6a 51                	push   $0x51
  jmp alltraps
80105e48:	e9 59 f8 ff ff       	jmp    801056a6 <alltraps>

80105e4d <vector82>:
.globl vector82
vector82:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $82
80105e4f:	6a 52                	push   $0x52
  jmp alltraps
80105e51:	e9 50 f8 ff ff       	jmp    801056a6 <alltraps>

80105e56 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $83
80105e58:	6a 53                	push   $0x53
  jmp alltraps
80105e5a:	e9 47 f8 ff ff       	jmp    801056a6 <alltraps>

80105e5f <vector84>:
.globl vector84
vector84:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $84
80105e61:	6a 54                	push   $0x54
  jmp alltraps
80105e63:	e9 3e f8 ff ff       	jmp    801056a6 <alltraps>

80105e68 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $85
80105e6a:	6a 55                	push   $0x55
  jmp alltraps
80105e6c:	e9 35 f8 ff ff       	jmp    801056a6 <alltraps>

80105e71 <vector86>:
.globl vector86
vector86:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $86
80105e73:	6a 56                	push   $0x56
  jmp alltraps
80105e75:	e9 2c f8 ff ff       	jmp    801056a6 <alltraps>

80105e7a <vector87>:
.globl vector87
vector87:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $87
80105e7c:	6a 57                	push   $0x57
  jmp alltraps
80105e7e:	e9 23 f8 ff ff       	jmp    801056a6 <alltraps>

80105e83 <vector88>:
.globl vector88
vector88:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $88
80105e85:	6a 58                	push   $0x58
  jmp alltraps
80105e87:	e9 1a f8 ff ff       	jmp    801056a6 <alltraps>

80105e8c <vector89>:
.globl vector89
vector89:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $89
80105e8e:	6a 59                	push   $0x59
  jmp alltraps
80105e90:	e9 11 f8 ff ff       	jmp    801056a6 <alltraps>

80105e95 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $90
80105e97:	6a 5a                	push   $0x5a
  jmp alltraps
80105e99:	e9 08 f8 ff ff       	jmp    801056a6 <alltraps>

80105e9e <vector91>:
.globl vector91
vector91:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $91
80105ea0:	6a 5b                	push   $0x5b
  jmp alltraps
80105ea2:	e9 ff f7 ff ff       	jmp    801056a6 <alltraps>

80105ea7 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $92
80105ea9:	6a 5c                	push   $0x5c
  jmp alltraps
80105eab:	e9 f6 f7 ff ff       	jmp    801056a6 <alltraps>

80105eb0 <vector93>:
.globl vector93
vector93:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $93
80105eb2:	6a 5d                	push   $0x5d
  jmp alltraps
80105eb4:	e9 ed f7 ff ff       	jmp    801056a6 <alltraps>

80105eb9 <vector94>:
.globl vector94
vector94:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $94
80105ebb:	6a 5e                	push   $0x5e
  jmp alltraps
80105ebd:	e9 e4 f7 ff ff       	jmp    801056a6 <alltraps>

80105ec2 <vector95>:
.globl vector95
vector95:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $95
80105ec4:	6a 5f                	push   $0x5f
  jmp alltraps
80105ec6:	e9 db f7 ff ff       	jmp    801056a6 <alltraps>

80105ecb <vector96>:
.globl vector96
vector96:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $96
80105ecd:	6a 60                	push   $0x60
  jmp alltraps
80105ecf:	e9 d2 f7 ff ff       	jmp    801056a6 <alltraps>

80105ed4 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $97
80105ed6:	6a 61                	push   $0x61
  jmp alltraps
80105ed8:	e9 c9 f7 ff ff       	jmp    801056a6 <alltraps>

80105edd <vector98>:
.globl vector98
vector98:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $98
80105edf:	6a 62                	push   $0x62
  jmp alltraps
80105ee1:	e9 c0 f7 ff ff       	jmp    801056a6 <alltraps>

80105ee6 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $99
80105ee8:	6a 63                	push   $0x63
  jmp alltraps
80105eea:	e9 b7 f7 ff ff       	jmp    801056a6 <alltraps>

80105eef <vector100>:
.globl vector100
vector100:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $100
80105ef1:	6a 64                	push   $0x64
  jmp alltraps
80105ef3:	e9 ae f7 ff ff       	jmp    801056a6 <alltraps>

80105ef8 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $101
80105efa:	6a 65                	push   $0x65
  jmp alltraps
80105efc:	e9 a5 f7 ff ff       	jmp    801056a6 <alltraps>

80105f01 <vector102>:
.globl vector102
vector102:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $102
80105f03:	6a 66                	push   $0x66
  jmp alltraps
80105f05:	e9 9c f7 ff ff       	jmp    801056a6 <alltraps>

80105f0a <vector103>:
.globl vector103
vector103:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $103
80105f0c:	6a 67                	push   $0x67
  jmp alltraps
80105f0e:	e9 93 f7 ff ff       	jmp    801056a6 <alltraps>

80105f13 <vector104>:
.globl vector104
vector104:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $104
80105f15:	6a 68                	push   $0x68
  jmp alltraps
80105f17:	e9 8a f7 ff ff       	jmp    801056a6 <alltraps>

80105f1c <vector105>:
.globl vector105
vector105:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $105
80105f1e:	6a 69                	push   $0x69
  jmp alltraps
80105f20:	e9 81 f7 ff ff       	jmp    801056a6 <alltraps>

80105f25 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $106
80105f27:	6a 6a                	push   $0x6a
  jmp alltraps
80105f29:	e9 78 f7 ff ff       	jmp    801056a6 <alltraps>

80105f2e <vector107>:
.globl vector107
vector107:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $107
80105f30:	6a 6b                	push   $0x6b
  jmp alltraps
80105f32:	e9 6f f7 ff ff       	jmp    801056a6 <alltraps>

80105f37 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $108
80105f39:	6a 6c                	push   $0x6c
  jmp alltraps
80105f3b:	e9 66 f7 ff ff       	jmp    801056a6 <alltraps>

80105f40 <vector109>:
.globl vector109
vector109:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $109
80105f42:	6a 6d                	push   $0x6d
  jmp alltraps
80105f44:	e9 5d f7 ff ff       	jmp    801056a6 <alltraps>

80105f49 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $110
80105f4b:	6a 6e                	push   $0x6e
  jmp alltraps
80105f4d:	e9 54 f7 ff ff       	jmp    801056a6 <alltraps>

80105f52 <vector111>:
.globl vector111
vector111:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $111
80105f54:	6a 6f                	push   $0x6f
  jmp alltraps
80105f56:	e9 4b f7 ff ff       	jmp    801056a6 <alltraps>

80105f5b <vector112>:
.globl vector112
vector112:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $112
80105f5d:	6a 70                	push   $0x70
  jmp alltraps
80105f5f:	e9 42 f7 ff ff       	jmp    801056a6 <alltraps>

80105f64 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $113
80105f66:	6a 71                	push   $0x71
  jmp alltraps
80105f68:	e9 39 f7 ff ff       	jmp    801056a6 <alltraps>

80105f6d <vector114>:
.globl vector114
vector114:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $114
80105f6f:	6a 72                	push   $0x72
  jmp alltraps
80105f71:	e9 30 f7 ff ff       	jmp    801056a6 <alltraps>

80105f76 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $115
80105f78:	6a 73                	push   $0x73
  jmp alltraps
80105f7a:	e9 27 f7 ff ff       	jmp    801056a6 <alltraps>

80105f7f <vector116>:
.globl vector116
vector116:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $116
80105f81:	6a 74                	push   $0x74
  jmp alltraps
80105f83:	e9 1e f7 ff ff       	jmp    801056a6 <alltraps>

80105f88 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $117
80105f8a:	6a 75                	push   $0x75
  jmp alltraps
80105f8c:	e9 15 f7 ff ff       	jmp    801056a6 <alltraps>

80105f91 <vector118>:
.globl vector118
vector118:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $118
80105f93:	6a 76                	push   $0x76
  jmp alltraps
80105f95:	e9 0c f7 ff ff       	jmp    801056a6 <alltraps>

80105f9a <vector119>:
.globl vector119
vector119:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $119
80105f9c:	6a 77                	push   $0x77
  jmp alltraps
80105f9e:	e9 03 f7 ff ff       	jmp    801056a6 <alltraps>

80105fa3 <vector120>:
.globl vector120
vector120:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $120
80105fa5:	6a 78                	push   $0x78
  jmp alltraps
80105fa7:	e9 fa f6 ff ff       	jmp    801056a6 <alltraps>

80105fac <vector121>:
.globl vector121
vector121:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $121
80105fae:	6a 79                	push   $0x79
  jmp alltraps
80105fb0:	e9 f1 f6 ff ff       	jmp    801056a6 <alltraps>

80105fb5 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $122
80105fb7:	6a 7a                	push   $0x7a
  jmp alltraps
80105fb9:	e9 e8 f6 ff ff       	jmp    801056a6 <alltraps>

80105fbe <vector123>:
.globl vector123
vector123:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $123
80105fc0:	6a 7b                	push   $0x7b
  jmp alltraps
80105fc2:	e9 df f6 ff ff       	jmp    801056a6 <alltraps>

80105fc7 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $124
80105fc9:	6a 7c                	push   $0x7c
  jmp alltraps
80105fcb:	e9 d6 f6 ff ff       	jmp    801056a6 <alltraps>

80105fd0 <vector125>:
.globl vector125
vector125:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $125
80105fd2:	6a 7d                	push   $0x7d
  jmp alltraps
80105fd4:	e9 cd f6 ff ff       	jmp    801056a6 <alltraps>

80105fd9 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $126
80105fdb:	6a 7e                	push   $0x7e
  jmp alltraps
80105fdd:	e9 c4 f6 ff ff       	jmp    801056a6 <alltraps>

80105fe2 <vector127>:
.globl vector127
vector127:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $127
80105fe4:	6a 7f                	push   $0x7f
  jmp alltraps
80105fe6:	e9 bb f6 ff ff       	jmp    801056a6 <alltraps>

80105feb <vector128>:
.globl vector128
vector128:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $128
80105fed:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105ff2:	e9 af f6 ff ff       	jmp    801056a6 <alltraps>

80105ff7 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $129
80105ff9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ffe:	e9 a3 f6 ff ff       	jmp    801056a6 <alltraps>

80106003 <vector130>:
.globl vector130
vector130:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $130
80106005:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010600a:	e9 97 f6 ff ff       	jmp    801056a6 <alltraps>

8010600f <vector131>:
.globl vector131
vector131:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $131
80106011:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106016:	e9 8b f6 ff ff       	jmp    801056a6 <alltraps>

8010601b <vector132>:
.globl vector132
vector132:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $132
8010601d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106022:	e9 7f f6 ff ff       	jmp    801056a6 <alltraps>

80106027 <vector133>:
.globl vector133
vector133:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $133
80106029:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010602e:	e9 73 f6 ff ff       	jmp    801056a6 <alltraps>

80106033 <vector134>:
.globl vector134
vector134:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $134
80106035:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010603a:	e9 67 f6 ff ff       	jmp    801056a6 <alltraps>

8010603f <vector135>:
.globl vector135
vector135:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $135
80106041:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106046:	e9 5b f6 ff ff       	jmp    801056a6 <alltraps>

8010604b <vector136>:
.globl vector136
vector136:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $136
8010604d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106052:	e9 4f f6 ff ff       	jmp    801056a6 <alltraps>

80106057 <vector137>:
.globl vector137
vector137:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $137
80106059:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010605e:	e9 43 f6 ff ff       	jmp    801056a6 <alltraps>

80106063 <vector138>:
.globl vector138
vector138:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $138
80106065:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010606a:	e9 37 f6 ff ff       	jmp    801056a6 <alltraps>

8010606f <vector139>:
.globl vector139
vector139:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $139
80106071:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106076:	e9 2b f6 ff ff       	jmp    801056a6 <alltraps>

8010607b <vector140>:
.globl vector140
vector140:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $140
8010607d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106082:	e9 1f f6 ff ff       	jmp    801056a6 <alltraps>

80106087 <vector141>:
.globl vector141
vector141:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $141
80106089:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010608e:	e9 13 f6 ff ff       	jmp    801056a6 <alltraps>

80106093 <vector142>:
.globl vector142
vector142:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $142
80106095:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010609a:	e9 07 f6 ff ff       	jmp    801056a6 <alltraps>

8010609f <vector143>:
.globl vector143
vector143:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $143
801060a1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060a6:	e9 fb f5 ff ff       	jmp    801056a6 <alltraps>

801060ab <vector144>:
.globl vector144
vector144:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $144
801060ad:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060b2:	e9 ef f5 ff ff       	jmp    801056a6 <alltraps>

801060b7 <vector145>:
.globl vector145
vector145:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $145
801060b9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060be:	e9 e3 f5 ff ff       	jmp    801056a6 <alltraps>

801060c3 <vector146>:
.globl vector146
vector146:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $146
801060c5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060ca:	e9 d7 f5 ff ff       	jmp    801056a6 <alltraps>

801060cf <vector147>:
.globl vector147
vector147:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $147
801060d1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060d6:	e9 cb f5 ff ff       	jmp    801056a6 <alltraps>

801060db <vector148>:
.globl vector148
vector148:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $148
801060dd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060e2:	e9 bf f5 ff ff       	jmp    801056a6 <alltraps>

801060e7 <vector149>:
.globl vector149
vector149:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $149
801060e9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060ee:	e9 b3 f5 ff ff       	jmp    801056a6 <alltraps>

801060f3 <vector150>:
.globl vector150
vector150:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $150
801060f5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060fa:	e9 a7 f5 ff ff       	jmp    801056a6 <alltraps>

801060ff <vector151>:
.globl vector151
vector151:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $151
80106101:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106106:	e9 9b f5 ff ff       	jmp    801056a6 <alltraps>

8010610b <vector152>:
.globl vector152
vector152:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $152
8010610d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106112:	e9 8f f5 ff ff       	jmp    801056a6 <alltraps>

80106117 <vector153>:
.globl vector153
vector153:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $153
80106119:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010611e:	e9 83 f5 ff ff       	jmp    801056a6 <alltraps>

80106123 <vector154>:
.globl vector154
vector154:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $154
80106125:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010612a:	e9 77 f5 ff ff       	jmp    801056a6 <alltraps>

8010612f <vector155>:
.globl vector155
vector155:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $155
80106131:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106136:	e9 6b f5 ff ff       	jmp    801056a6 <alltraps>

8010613b <vector156>:
.globl vector156
vector156:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $156
8010613d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106142:	e9 5f f5 ff ff       	jmp    801056a6 <alltraps>

80106147 <vector157>:
.globl vector157
vector157:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $157
80106149:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010614e:	e9 53 f5 ff ff       	jmp    801056a6 <alltraps>

80106153 <vector158>:
.globl vector158
vector158:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $158
80106155:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010615a:	e9 47 f5 ff ff       	jmp    801056a6 <alltraps>

8010615f <vector159>:
.globl vector159
vector159:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $159
80106161:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106166:	e9 3b f5 ff ff       	jmp    801056a6 <alltraps>

8010616b <vector160>:
.globl vector160
vector160:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $160
8010616d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106172:	e9 2f f5 ff ff       	jmp    801056a6 <alltraps>

80106177 <vector161>:
.globl vector161
vector161:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $161
80106179:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010617e:	e9 23 f5 ff ff       	jmp    801056a6 <alltraps>

80106183 <vector162>:
.globl vector162
vector162:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $162
80106185:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010618a:	e9 17 f5 ff ff       	jmp    801056a6 <alltraps>

8010618f <vector163>:
.globl vector163
vector163:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $163
80106191:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106196:	e9 0b f5 ff ff       	jmp    801056a6 <alltraps>

8010619b <vector164>:
.globl vector164
vector164:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $164
8010619d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061a2:	e9 ff f4 ff ff       	jmp    801056a6 <alltraps>

801061a7 <vector165>:
.globl vector165
vector165:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $165
801061a9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061ae:	e9 f3 f4 ff ff       	jmp    801056a6 <alltraps>

801061b3 <vector166>:
.globl vector166
vector166:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $166
801061b5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061ba:	e9 e7 f4 ff ff       	jmp    801056a6 <alltraps>

801061bf <vector167>:
.globl vector167
vector167:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $167
801061c1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061c6:	e9 db f4 ff ff       	jmp    801056a6 <alltraps>

801061cb <vector168>:
.globl vector168
vector168:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $168
801061cd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061d2:	e9 cf f4 ff ff       	jmp    801056a6 <alltraps>

801061d7 <vector169>:
.globl vector169
vector169:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $169
801061d9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061de:	e9 c3 f4 ff ff       	jmp    801056a6 <alltraps>

801061e3 <vector170>:
.globl vector170
vector170:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $170
801061e5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061ea:	e9 b7 f4 ff ff       	jmp    801056a6 <alltraps>

801061ef <vector171>:
.globl vector171
vector171:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $171
801061f1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061f6:	e9 ab f4 ff ff       	jmp    801056a6 <alltraps>

801061fb <vector172>:
.globl vector172
vector172:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $172
801061fd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106202:	e9 9f f4 ff ff       	jmp    801056a6 <alltraps>

80106207 <vector173>:
.globl vector173
vector173:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $173
80106209:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010620e:	e9 93 f4 ff ff       	jmp    801056a6 <alltraps>

80106213 <vector174>:
.globl vector174
vector174:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $174
80106215:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010621a:	e9 87 f4 ff ff       	jmp    801056a6 <alltraps>

8010621f <vector175>:
.globl vector175
vector175:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $175
80106221:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106226:	e9 7b f4 ff ff       	jmp    801056a6 <alltraps>

8010622b <vector176>:
.globl vector176
vector176:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $176
8010622d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106232:	e9 6f f4 ff ff       	jmp    801056a6 <alltraps>

80106237 <vector177>:
.globl vector177
vector177:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $177
80106239:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010623e:	e9 63 f4 ff ff       	jmp    801056a6 <alltraps>

80106243 <vector178>:
.globl vector178
vector178:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $178
80106245:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010624a:	e9 57 f4 ff ff       	jmp    801056a6 <alltraps>

8010624f <vector179>:
.globl vector179
vector179:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $179
80106251:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106256:	e9 4b f4 ff ff       	jmp    801056a6 <alltraps>

8010625b <vector180>:
.globl vector180
vector180:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $180
8010625d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106262:	e9 3f f4 ff ff       	jmp    801056a6 <alltraps>

80106267 <vector181>:
.globl vector181
vector181:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $181
80106269:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010626e:	e9 33 f4 ff ff       	jmp    801056a6 <alltraps>

80106273 <vector182>:
.globl vector182
vector182:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $182
80106275:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010627a:	e9 27 f4 ff ff       	jmp    801056a6 <alltraps>

8010627f <vector183>:
.globl vector183
vector183:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $183
80106281:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106286:	e9 1b f4 ff ff       	jmp    801056a6 <alltraps>

8010628b <vector184>:
.globl vector184
vector184:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $184
8010628d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106292:	e9 0f f4 ff ff       	jmp    801056a6 <alltraps>

80106297 <vector185>:
.globl vector185
vector185:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $185
80106299:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010629e:	e9 03 f4 ff ff       	jmp    801056a6 <alltraps>

801062a3 <vector186>:
.globl vector186
vector186:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $186
801062a5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062aa:	e9 f7 f3 ff ff       	jmp    801056a6 <alltraps>

801062af <vector187>:
.globl vector187
vector187:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $187
801062b1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062b6:	e9 eb f3 ff ff       	jmp    801056a6 <alltraps>

801062bb <vector188>:
.globl vector188
vector188:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $188
801062bd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062c2:	e9 df f3 ff ff       	jmp    801056a6 <alltraps>

801062c7 <vector189>:
.globl vector189
vector189:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $189
801062c9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ce:	e9 d3 f3 ff ff       	jmp    801056a6 <alltraps>

801062d3 <vector190>:
.globl vector190
vector190:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $190
801062d5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062da:	e9 c7 f3 ff ff       	jmp    801056a6 <alltraps>

801062df <vector191>:
.globl vector191
vector191:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $191
801062e1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062e6:	e9 bb f3 ff ff       	jmp    801056a6 <alltraps>

801062eb <vector192>:
.globl vector192
vector192:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $192
801062ed:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062f2:	e9 af f3 ff ff       	jmp    801056a6 <alltraps>

801062f7 <vector193>:
.globl vector193
vector193:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $193
801062f9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062fe:	e9 a3 f3 ff ff       	jmp    801056a6 <alltraps>

80106303 <vector194>:
.globl vector194
vector194:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $194
80106305:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010630a:	e9 97 f3 ff ff       	jmp    801056a6 <alltraps>

8010630f <vector195>:
.globl vector195
vector195:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $195
80106311:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106316:	e9 8b f3 ff ff       	jmp    801056a6 <alltraps>

8010631b <vector196>:
.globl vector196
vector196:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $196
8010631d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106322:	e9 7f f3 ff ff       	jmp    801056a6 <alltraps>

80106327 <vector197>:
.globl vector197
vector197:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $197
80106329:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010632e:	e9 73 f3 ff ff       	jmp    801056a6 <alltraps>

80106333 <vector198>:
.globl vector198
vector198:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $198
80106335:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010633a:	e9 67 f3 ff ff       	jmp    801056a6 <alltraps>

8010633f <vector199>:
.globl vector199
vector199:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $199
80106341:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106346:	e9 5b f3 ff ff       	jmp    801056a6 <alltraps>

8010634b <vector200>:
.globl vector200
vector200:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $200
8010634d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106352:	e9 4f f3 ff ff       	jmp    801056a6 <alltraps>

80106357 <vector201>:
.globl vector201
vector201:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $201
80106359:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010635e:	e9 43 f3 ff ff       	jmp    801056a6 <alltraps>

80106363 <vector202>:
.globl vector202
vector202:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $202
80106365:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010636a:	e9 37 f3 ff ff       	jmp    801056a6 <alltraps>

8010636f <vector203>:
.globl vector203
vector203:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $203
80106371:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106376:	e9 2b f3 ff ff       	jmp    801056a6 <alltraps>

8010637b <vector204>:
.globl vector204
vector204:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $204
8010637d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106382:	e9 1f f3 ff ff       	jmp    801056a6 <alltraps>

80106387 <vector205>:
.globl vector205
vector205:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $205
80106389:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010638e:	e9 13 f3 ff ff       	jmp    801056a6 <alltraps>

80106393 <vector206>:
.globl vector206
vector206:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $206
80106395:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010639a:	e9 07 f3 ff ff       	jmp    801056a6 <alltraps>

8010639f <vector207>:
.globl vector207
vector207:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $207
801063a1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063a6:	e9 fb f2 ff ff       	jmp    801056a6 <alltraps>

801063ab <vector208>:
.globl vector208
vector208:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $208
801063ad:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063b2:	e9 ef f2 ff ff       	jmp    801056a6 <alltraps>

801063b7 <vector209>:
.globl vector209
vector209:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $209
801063b9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063be:	e9 e3 f2 ff ff       	jmp    801056a6 <alltraps>

801063c3 <vector210>:
.globl vector210
vector210:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $210
801063c5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063ca:	e9 d7 f2 ff ff       	jmp    801056a6 <alltraps>

801063cf <vector211>:
.globl vector211
vector211:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $211
801063d1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063d6:	e9 cb f2 ff ff       	jmp    801056a6 <alltraps>

801063db <vector212>:
.globl vector212
vector212:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $212
801063dd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063e2:	e9 bf f2 ff ff       	jmp    801056a6 <alltraps>

801063e7 <vector213>:
.globl vector213
vector213:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $213
801063e9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063ee:	e9 b3 f2 ff ff       	jmp    801056a6 <alltraps>

801063f3 <vector214>:
.globl vector214
vector214:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $214
801063f5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063fa:	e9 a7 f2 ff ff       	jmp    801056a6 <alltraps>

801063ff <vector215>:
.globl vector215
vector215:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $215
80106401:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106406:	e9 9b f2 ff ff       	jmp    801056a6 <alltraps>

8010640b <vector216>:
.globl vector216
vector216:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $216
8010640d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106412:	e9 8f f2 ff ff       	jmp    801056a6 <alltraps>

80106417 <vector217>:
.globl vector217
vector217:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $217
80106419:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010641e:	e9 83 f2 ff ff       	jmp    801056a6 <alltraps>

80106423 <vector218>:
.globl vector218
vector218:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $218
80106425:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010642a:	e9 77 f2 ff ff       	jmp    801056a6 <alltraps>

8010642f <vector219>:
.globl vector219
vector219:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $219
80106431:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106436:	e9 6b f2 ff ff       	jmp    801056a6 <alltraps>

8010643b <vector220>:
.globl vector220
vector220:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $220
8010643d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106442:	e9 5f f2 ff ff       	jmp    801056a6 <alltraps>

80106447 <vector221>:
.globl vector221
vector221:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $221
80106449:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010644e:	e9 53 f2 ff ff       	jmp    801056a6 <alltraps>

80106453 <vector222>:
.globl vector222
vector222:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $222
80106455:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010645a:	e9 47 f2 ff ff       	jmp    801056a6 <alltraps>

8010645f <vector223>:
.globl vector223
vector223:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $223
80106461:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106466:	e9 3b f2 ff ff       	jmp    801056a6 <alltraps>

8010646b <vector224>:
.globl vector224
vector224:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $224
8010646d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106472:	e9 2f f2 ff ff       	jmp    801056a6 <alltraps>

80106477 <vector225>:
.globl vector225
vector225:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $225
80106479:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010647e:	e9 23 f2 ff ff       	jmp    801056a6 <alltraps>

80106483 <vector226>:
.globl vector226
vector226:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $226
80106485:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010648a:	e9 17 f2 ff ff       	jmp    801056a6 <alltraps>

8010648f <vector227>:
.globl vector227
vector227:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $227
80106491:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106496:	e9 0b f2 ff ff       	jmp    801056a6 <alltraps>

8010649b <vector228>:
.globl vector228
vector228:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $228
8010649d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064a2:	e9 ff f1 ff ff       	jmp    801056a6 <alltraps>

801064a7 <vector229>:
.globl vector229
vector229:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $229
801064a9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064ae:	e9 f3 f1 ff ff       	jmp    801056a6 <alltraps>

801064b3 <vector230>:
.globl vector230
vector230:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $230
801064b5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064ba:	e9 e7 f1 ff ff       	jmp    801056a6 <alltraps>

801064bf <vector231>:
.globl vector231
vector231:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $231
801064c1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064c6:	e9 db f1 ff ff       	jmp    801056a6 <alltraps>

801064cb <vector232>:
.globl vector232
vector232:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $232
801064cd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064d2:	e9 cf f1 ff ff       	jmp    801056a6 <alltraps>

801064d7 <vector233>:
.globl vector233
vector233:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $233
801064d9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064de:	e9 c3 f1 ff ff       	jmp    801056a6 <alltraps>

801064e3 <vector234>:
.globl vector234
vector234:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $234
801064e5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064ea:	e9 b7 f1 ff ff       	jmp    801056a6 <alltraps>

801064ef <vector235>:
.globl vector235
vector235:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $235
801064f1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064f6:	e9 ab f1 ff ff       	jmp    801056a6 <alltraps>

801064fb <vector236>:
.globl vector236
vector236:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $236
801064fd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106502:	e9 9f f1 ff ff       	jmp    801056a6 <alltraps>

80106507 <vector237>:
.globl vector237
vector237:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $237
80106509:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010650e:	e9 93 f1 ff ff       	jmp    801056a6 <alltraps>

80106513 <vector238>:
.globl vector238
vector238:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $238
80106515:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010651a:	e9 87 f1 ff ff       	jmp    801056a6 <alltraps>

8010651f <vector239>:
.globl vector239
vector239:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $239
80106521:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106526:	e9 7b f1 ff ff       	jmp    801056a6 <alltraps>

8010652b <vector240>:
.globl vector240
vector240:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $240
8010652d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106532:	e9 6f f1 ff ff       	jmp    801056a6 <alltraps>

80106537 <vector241>:
.globl vector241
vector241:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $241
80106539:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010653e:	e9 63 f1 ff ff       	jmp    801056a6 <alltraps>

80106543 <vector242>:
.globl vector242
vector242:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $242
80106545:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010654a:	e9 57 f1 ff ff       	jmp    801056a6 <alltraps>

8010654f <vector243>:
.globl vector243
vector243:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $243
80106551:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106556:	e9 4b f1 ff ff       	jmp    801056a6 <alltraps>

8010655b <vector244>:
.globl vector244
vector244:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $244
8010655d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106562:	e9 3f f1 ff ff       	jmp    801056a6 <alltraps>

80106567 <vector245>:
.globl vector245
vector245:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $245
80106569:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010656e:	e9 33 f1 ff ff       	jmp    801056a6 <alltraps>

80106573 <vector246>:
.globl vector246
vector246:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $246
80106575:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010657a:	e9 27 f1 ff ff       	jmp    801056a6 <alltraps>

8010657f <vector247>:
.globl vector247
vector247:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $247
80106581:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106586:	e9 1b f1 ff ff       	jmp    801056a6 <alltraps>

8010658b <vector248>:
.globl vector248
vector248:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $248
8010658d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106592:	e9 0f f1 ff ff       	jmp    801056a6 <alltraps>

80106597 <vector249>:
.globl vector249
vector249:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $249
80106599:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010659e:	e9 03 f1 ff ff       	jmp    801056a6 <alltraps>

801065a3 <vector250>:
.globl vector250
vector250:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $250
801065a5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065aa:	e9 f7 f0 ff ff       	jmp    801056a6 <alltraps>

801065af <vector251>:
.globl vector251
vector251:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $251
801065b1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065b6:	e9 eb f0 ff ff       	jmp    801056a6 <alltraps>

801065bb <vector252>:
.globl vector252
vector252:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $252
801065bd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065c2:	e9 df f0 ff ff       	jmp    801056a6 <alltraps>

801065c7 <vector253>:
.globl vector253
vector253:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $253
801065c9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ce:	e9 d3 f0 ff ff       	jmp    801056a6 <alltraps>

801065d3 <vector254>:
.globl vector254
vector254:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $254
801065d5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065da:	e9 c7 f0 ff ff       	jmp    801056a6 <alltraps>

801065df <vector255>:
.globl vector255
vector255:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $255
801065e1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065e6:	e9 bb f0 ff ff       	jmp    801056a6 <alltraps>
801065eb:	90                   	nop

801065ec <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065ec:	55                   	push   %ebp
801065ed:	89 e5                	mov    %esp,%ebp
801065ef:	57                   	push   %edi
801065f0:	56                   	push   %esi
801065f1:	53                   	push   %ebx
801065f2:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065f5:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801065fb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106601:	39 d3                	cmp    %edx,%ebx
80106603:	73 50                	jae    80106655 <deallocuvm.part.0+0x69>
80106605:	89 c6                	mov    %eax,%esi
80106607:	89 d7                	mov    %edx,%edi
80106609:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010660c:	eb 0c                	jmp    8010661a <deallocuvm.part.0+0x2e>
8010660e:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106610:	42                   	inc    %edx
80106611:	89 d3                	mov    %edx,%ebx
80106613:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106616:	39 fb                	cmp    %edi,%ebx
80106618:	73 38                	jae    80106652 <deallocuvm.part.0+0x66>
  pde = &pgdir[PDX(va)];
8010661a:	89 da                	mov    %ebx,%edx
8010661c:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010661f:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106622:	a8 01                	test   $0x1,%al
80106624:	74 ea                	je     80106610 <deallocuvm.part.0+0x24>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106626:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010662b:	89 d9                	mov    %ebx,%ecx
8010662d:	c1 e9 0a             	shr    $0xa,%ecx
80106630:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106636:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
8010663d:	85 c0                	test   %eax,%eax
8010663f:	74 cf                	je     80106610 <deallocuvm.part.0+0x24>
    else if((*pte & PTE_P) != 0){
80106641:	8b 10                	mov    (%eax),%edx
80106643:	f6 c2 01             	test   $0x1,%dl
80106646:	75 18                	jne    80106660 <deallocuvm.part.0+0x74>
  for(; a  < oldsz; a += PGSIZE){
80106648:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010664e:	39 fb                	cmp    %edi,%ebx
80106650:	72 c8                	jb     8010661a <deallocuvm.part.0+0x2e>
80106652:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106655:	89 c8                	mov    %ecx,%eax
80106657:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010665a:	5b                   	pop    %ebx
8010665b:	5e                   	pop    %esi
8010665c:	5f                   	pop    %edi
8010665d:	5d                   	pop    %ebp
8010665e:	c3                   	ret
8010665f:	90                   	nop
      if(pa == 0)
80106660:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106666:	74 26                	je     8010668e <deallocuvm.part.0+0xa2>
80106668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010666b:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010666e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106674:	52                   	push   %edx
80106675:	e8 92 bc ff ff       	call   8010230c <kfree>
      *pte = 0;
8010667a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010667d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106683:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106689:	83 c4 10             	add    $0x10,%esp
8010668c:	eb 88                	jmp    80106616 <deallocuvm.part.0+0x2a>
        panic("kfree");
8010668e:	83 ec 0c             	sub    $0xc,%esp
80106691:	68 f8 70 10 80       	push   $0x801070f8
80106696:	e8 9d 9c ff ff       	call   80100338 <panic>
8010669b:	90                   	nop

8010669c <mappages>:
{
8010669c:	55                   	push   %ebp
8010669d:	89 e5                	mov    %esp,%ebp
8010669f:	57                   	push   %edi
801066a0:	56                   	push   %esi
801066a1:	53                   	push   %ebx
801066a2:	83 ec 1c             	sub    $0x1c,%esp
801066a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
801066a8:	89 d3                	mov    %edx,%ebx
801066aa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066b0:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801066b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066bc:	8b 45 08             	mov    0x8(%ebp),%eax
801066bf:	29 d8                	sub    %ebx,%eax
801066c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066c4:	eb 3b                	jmp    80106701 <mappages+0x65>
801066c6:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801066cd:	89 da                	mov    %ebx,%edx
801066cf:	c1 ea 0a             	shr    $0xa,%edx
801066d2:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066d8:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066df:	85 c0                	test   %eax,%eax
801066e1:	74 71                	je     80106754 <mappages+0xb8>
    if(*pte & PTE_P)
801066e3:	f6 00 01             	testb  $0x1,(%eax)
801066e6:	0f 85 82 00 00 00    	jne    8010676e <mappages+0xd2>
    *pte = pa | perm | PTE_P;
801066ec:	0b 75 0c             	or     0xc(%ebp),%esi
801066ef:	83 ce 01             	or     $0x1,%esi
801066f2:	89 30                	mov    %esi,(%eax)
    if(a == last)
801066f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066f7:	39 c3                	cmp    %eax,%ebx
801066f9:	74 69                	je     80106764 <mappages+0xc8>
    a += PGSIZE;
801066fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106704:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  pde = &pgdir[PDX(va)];
80106707:	89 d8                	mov    %ebx,%eax
80106709:	c1 e8 16             	shr    $0x16,%eax
8010670c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010670f:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106712:	8b 07                	mov    (%edi),%eax
80106714:	a8 01                	test   $0x1,%al
80106716:	75 b0                	jne    801066c8 <mappages+0x2c>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106718:	e8 7f bd ff ff       	call   8010249c <kalloc>
8010671d:	89 c2                	mov    %eax,%edx
8010671f:	85 c0                	test   %eax,%eax
80106721:	74 31                	je     80106754 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
80106723:	50                   	push   %eax
80106724:	68 00 10 00 00       	push   $0x1000
80106729:	6a 00                	push   $0x0
8010672b:	52                   	push   %edx
8010672c:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010672f:	e8 a0 df ff ff       	call   801046d4 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106734:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106737:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
8010673d:	83 c8 07             	or     $0x7,%eax
80106740:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106742:	89 d8                	mov    %ebx,%eax
80106744:	c1 e8 0a             	shr    $0xa,%eax
80106747:	25 fc 0f 00 00       	and    $0xffc,%eax
8010674c:	01 d0                	add    %edx,%eax
8010674e:	83 c4 10             	add    $0x10,%esp
80106751:	eb 90                	jmp    801066e3 <mappages+0x47>
80106753:	90                   	nop
      return -1;
80106754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010675c:	5b                   	pop    %ebx
8010675d:	5e                   	pop    %esi
8010675e:	5f                   	pop    %edi
8010675f:	5d                   	pop    %ebp
80106760:	c3                   	ret
80106761:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
80106764:	31 c0                	xor    %eax,%eax
}
80106766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106769:	5b                   	pop    %ebx
8010676a:	5e                   	pop    %esi
8010676b:	5f                   	pop    %edi
8010676c:	5d                   	pop    %ebp
8010676d:	c3                   	ret
      panic("remap");
8010676e:	83 ec 0c             	sub    $0xc,%esp
80106771:	68 90 73 10 80       	push   $0x80107390
80106776:	e8 bd 9b ff ff       	call   80100338 <panic>
8010677b:	90                   	nop

8010677c <seginit>:
{
8010677c:	55                   	push   %ebp
8010677d:	89 e5                	mov    %esp,%ebp
8010677f:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106782:	e8 4d ce ff ff       	call   801035d4 <cpuid>
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106787:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010678a:	01 d2                	add    %edx,%edx
8010678c:	01 d0                	add    %edx,%eax
8010678e:	c1 e0 04             	shl    $0x4,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106791:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106798:	ff 00 00 
8010679b:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801067a2:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067a5:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
801067ac:	ff 00 00 
801067af:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
801067b6:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067b9:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
801067c0:	ff 00 00 
801067c3:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
801067ca:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067cd:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
801067d4:	ff 00 00 
801067d7:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
801067de:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801067e1:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[0] = size-1;
801067e6:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801067ec:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067f0:	c1 e8 10             	shr    $0x10,%eax
801067f3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801067f7:	8d 45 f2             	lea    -0xe(%ebp),%eax
801067fa:	0f 01 10             	lgdtl  (%eax)
}
801067fd:	c9                   	leave
801067fe:	c3                   	ret
801067ff:	90                   	nop

80106800 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106800:	a1 c4 57 11 80       	mov    0x801157c4,%eax
80106805:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010680a:	0f 22 d8             	mov    %eax,%cr3
}
8010680d:	c3                   	ret
8010680e:	66 90                	xchg   %ax,%ax

80106810 <switchuvm>:
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	57                   	push   %edi
80106814:	56                   	push   %esi
80106815:	53                   	push   %ebx
80106816:	83 ec 1c             	sub    $0x1c,%esp
80106819:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010681c:	85 f6                	test   %esi,%esi
8010681e:	0f 84 bf 00 00 00    	je     801068e3 <switchuvm+0xd3>
  if(p->kstack == 0)
80106824:	8b 56 54             	mov    0x54(%esi),%edx
80106827:	85 d2                	test   %edx,%edx
80106829:	0f 84 ce 00 00 00    	je     801068fd <switchuvm+0xed>
  if(p->pgdir == 0)
8010682f:	8b 46 50             	mov    0x50(%esi),%eax
80106832:	85 c0                	test   %eax,%eax
80106834:	0f 84 b6 00 00 00    	je     801068f0 <switchuvm+0xe0>
  pushcli();
8010683a:	e8 85 dc ff ff       	call   801044c4 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010683f:	e8 2c cd ff ff       	call   80103570 <mycpu>
80106844:	89 c3                	mov    %eax,%ebx
80106846:	e8 25 cd ff ff       	call   80103570 <mycpu>
8010684b:	89 c7                	mov    %eax,%edi
8010684d:	e8 1e cd ff ff       	call   80103570 <mycpu>
80106852:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106855:	e8 16 cd ff ff       	call   80103570 <mycpu>
8010685a:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106861:	67 00 
80106863:	83 c7 08             	add    $0x8,%edi
80106866:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010686d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106870:	83 c1 08             	add    $0x8,%ecx
80106873:	c1 e9 10             	shr    $0x10,%ecx
80106876:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010687c:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
80106883:	99 40 
80106885:	83 c0 08             	add    $0x8,%eax
80106888:	c1 e8 18             	shr    $0x18,%eax
8010688b:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
80106891:	e8 da cc ff ff       	call   80103570 <mycpu>
80106896:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010689d:	e8 ce cc ff ff       	call   80103570 <mycpu>
801068a2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068a8:	8b 5e 54             	mov    0x54(%esi),%ebx
801068ab:	e8 c0 cc ff ff       	call   80103570 <mycpu>
801068b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068b6:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801068b9:	e8 b2 cc ff ff       	call   80103570 <mycpu>
801068be:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801068c4:	b8 28 00 00 00       	mov    $0x28,%eax
801068c9:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801068cc:	8b 46 50             	mov    0x50(%esi),%eax
801068cf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068d4:	0f 22 d8             	mov    %eax,%cr3
}
801068d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068da:	5b                   	pop    %ebx
801068db:	5e                   	pop    %esi
801068dc:	5f                   	pop    %edi
801068dd:	5d                   	pop    %ebp
  popcli();
801068de:	e9 2d dc ff ff       	jmp    80104510 <popcli>
    panic("switchuvm: no process");
801068e3:	83 ec 0c             	sub    $0xc,%esp
801068e6:	68 96 73 10 80       	push   $0x80107396
801068eb:	e8 48 9a ff ff       	call   80100338 <panic>
    panic("switchuvm: no pgdir");
801068f0:	83 ec 0c             	sub    $0xc,%esp
801068f3:	68 c1 73 10 80       	push   $0x801073c1
801068f8:	e8 3b 9a ff ff       	call   80100338 <panic>
    panic("switchuvm: no kstack");
801068fd:	83 ec 0c             	sub    $0xc,%esp
80106900:	68 ac 73 10 80       	push   $0x801073ac
80106905:	e8 2e 9a ff ff       	call   80100338 <panic>
8010690a:	66 90                	xchg   %ax,%ax

8010690c <inituvm>:
{
8010690c:	55                   	push   %ebp
8010690d:	89 e5                	mov    %esp,%ebp
8010690f:	57                   	push   %edi
80106910:	56                   	push   %esi
80106911:	53                   	push   %ebx
80106912:	83 ec 1c             	sub    $0x1c,%esp
80106915:	8b 45 08             	mov    0x8(%ebp),%eax
80106918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010691b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010691e:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
80106921:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106927:	77 47                	ja     80106970 <inituvm+0x64>
  mem = kalloc();
80106929:	e8 6e bb ff ff       	call   8010249c <kalloc>
8010692e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106930:	50                   	push   %eax
80106931:	68 00 10 00 00       	push   $0x1000
80106936:	6a 00                	push   $0x0
80106938:	53                   	push   %ebx
80106939:	e8 96 dd ff ff       	call   801046d4 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010693e:	5a                   	pop    %edx
8010693f:	59                   	pop    %ecx
80106940:	6a 06                	push   $0x6
80106942:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106948:	50                   	push   %eax
80106949:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010694e:	31 d2                	xor    %edx,%edx
80106950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106953:	e8 44 fd ff ff       	call   8010669c <mappages>
  memmove(mem, init, sz);
80106958:	83 c4 10             	add    $0x10,%esp
8010695b:	89 75 10             	mov    %esi,0x10(%ebp)
8010695e:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106961:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106964:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106967:	5b                   	pop    %ebx
80106968:	5e                   	pop    %esi
80106969:	5f                   	pop    %edi
8010696a:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010696b:	e9 e0 dd ff ff       	jmp    80104750 <memmove>
    panic("inituvm: more than a page");
80106970:	83 ec 0c             	sub    $0xc,%esp
80106973:	68 d5 73 10 80       	push   $0x801073d5
80106978:	e8 bb 99 ff ff       	call   80100338 <panic>
8010697d:	8d 76 00             	lea    0x0(%esi),%esi

80106980 <loaduvm>:
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	56                   	push   %esi
80106985:	53                   	push   %ebx
80106986:	83 ec 0c             	sub    $0xc,%esp
80106989:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010698c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010698f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106995:	0f 85 9a 00 00 00    	jne    80106a35 <loaduvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
8010699b:	85 ff                	test   %edi,%edi
8010699d:	74 7c                	je     80106a1b <loaduvm+0x9b>
8010699f:	90                   	nop
  pde = &pgdir[PDX(va)];
801069a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801069a3:	01 d8                	add    %ebx,%eax
801069a5:	89 c2                	mov    %eax,%edx
801069a7:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801069aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801069ad:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801069b0:	f6 c2 01             	test   $0x1,%dl
801069b3:	75 0f                	jne    801069c4 <loaduvm+0x44>
      panic("loaduvm: address should exist");
801069b5:	83 ec 0c             	sub    $0xc,%esp
801069b8:	68 ef 73 10 80       	push   $0x801073ef
801069bd:	e8 76 99 ff ff       	call   80100338 <panic>
801069c2:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801069ca:	c1 e8 0a             	shr    $0xa,%eax
801069cd:	25 fc 0f 00 00       	and    $0xffc,%eax
801069d2:	8d 8c 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069d9:	85 c9                	test   %ecx,%ecx
801069db:	74 d8                	je     801069b5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801069dd:	89 fe                	mov    %edi,%esi
801069df:	29 de                	sub    %ebx,%esi
801069e1:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801069e7:	76 05                	jbe    801069ee <loaduvm+0x6e>
801069e9:	be 00 10 00 00       	mov    $0x1000,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069ee:	56                   	push   %esi
801069ef:	8b 45 14             	mov    0x14(%ebp),%eax
801069f2:	01 d8                	add    %ebx,%eax
801069f4:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801069f5:	8b 01                	mov    (%ecx),%eax
801069f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069fc:	05 00 00 00 80       	add    $0x80000000,%eax
80106a01:	50                   	push   %eax
80106a02:	ff 75 10             	push   0x10(%ebp)
80106a05:	e8 ee af ff ff       	call   801019f8 <readi>
80106a0a:	83 c4 10             	add    $0x10,%esp
80106a0d:	39 f0                	cmp    %esi,%eax
80106a0f:	75 17                	jne    80106a28 <loaduvm+0xa8>
  for(i = 0; i < sz; i += PGSIZE){
80106a11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a17:	39 fb                	cmp    %edi,%ebx
80106a19:	72 85                	jb     801069a0 <loaduvm+0x20>
  return 0;
80106a1b:	31 c0                	xor    %eax,%eax
}
80106a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a20:	5b                   	pop    %ebx
80106a21:	5e                   	pop    %esi
80106a22:	5f                   	pop    %edi
80106a23:	5d                   	pop    %ebp
80106a24:	c3                   	ret
80106a25:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
80106a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a30:	5b                   	pop    %ebx
80106a31:	5e                   	pop    %esi
80106a32:	5f                   	pop    %edi
80106a33:	5d                   	pop    %ebp
80106a34:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106a35:	83 ec 0c             	sub    $0xc,%esp
80106a38:	68 74 76 10 80       	push   $0x80107674
80106a3d:	e8 f6 98 ff ff       	call   80100338 <panic>
80106a42:	66 90                	xchg   %ax,%ax

80106a44 <allocuvm>:
{
80106a44:	55                   	push   %ebp
80106a45:	89 e5                	mov    %esp,%ebp
80106a47:	57                   	push   %edi
80106a48:	56                   	push   %esi
80106a49:	53                   	push   %ebx
80106a4a:	83 ec 1c             	sub    $0x1c,%esp
80106a4d:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106a50:	85 f6                	test   %esi,%esi
80106a52:	0f 88 91 00 00 00    	js     80106ae9 <allocuvm+0xa5>
80106a58:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106a5a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106a5d:	0f 82 95 00 00 00    	jb     80106af8 <allocuvm+0xb4>
  a = PGROUNDUP(oldsz);
80106a63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a66:	05 ff 0f 00 00       	add    $0xfff,%eax
80106a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a70:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106a72:	39 f0                	cmp    %esi,%eax
80106a74:	0f 83 81 00 00 00    	jae    80106afb <allocuvm+0xb7>
80106a7a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106a7d:	eb 3d                	jmp    80106abc <allocuvm+0x78>
80106a7f:	90                   	nop
    memset(mem, 0, PGSIZE);
80106a80:	50                   	push   %eax
80106a81:	68 00 10 00 00       	push   $0x1000
80106a86:	6a 00                	push   $0x0
80106a88:	53                   	push   %ebx
80106a89:	e8 46 dc ff ff       	call   801046d4 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a8e:	5a                   	pop    %edx
80106a8f:	59                   	pop    %ecx
80106a90:	6a 06                	push   $0x6
80106a92:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a98:	50                   	push   %eax
80106a99:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a9e:	89 fa                	mov    %edi,%edx
80106aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa3:	e8 f4 fb ff ff       	call   8010669c <mappages>
80106aa8:	83 c4 10             	add    $0x10,%esp
80106aab:	40                   	inc    %eax
80106aac:	74 5a                	je     80106b08 <allocuvm+0xc4>
  for(; a < newsz; a += PGSIZE){
80106aae:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ab4:	39 f7                	cmp    %esi,%edi
80106ab6:	0f 83 80 00 00 00    	jae    80106b3c <allocuvm+0xf8>
    mem = kalloc();
80106abc:	e8 db b9 ff ff       	call   8010249c <kalloc>
80106ac1:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106ac3:	85 c0                	test   %eax,%eax
80106ac5:	75 b9                	jne    80106a80 <allocuvm+0x3c>
      cprintf("allocuvm out of memory\n");
80106ac7:	83 ec 0c             	sub    $0xc,%esp
80106aca:	68 0d 74 10 80       	push   $0x8010740d
80106acf:	e8 4c 9b ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106ad4:	83 c4 10             	add    $0x10,%esp
80106ad7:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106ada:	74 0d                	je     80106ae9 <allocuvm+0xa5>
80106adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106adf:	89 f2                	mov    %esi,%edx
80106ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae4:	e8 03 fb ff ff       	call   801065ec <deallocuvm.part.0>
    return 0;
80106ae9:	31 d2                	xor    %edx,%edx
}
80106aeb:	89 d0                	mov    %edx,%eax
80106aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106af0:	5b                   	pop    %ebx
80106af1:	5e                   	pop    %esi
80106af2:	5f                   	pop    %edi
80106af3:	5d                   	pop    %ebp
80106af4:	c3                   	ret
80106af5:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80106af8:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106afb:	89 d0                	mov    %edx,%eax
80106afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b00:	5b                   	pop    %ebx
80106b01:	5e                   	pop    %esi
80106b02:	5f                   	pop    %edi
80106b03:	5d                   	pop    %ebp
80106b04:	c3                   	ret
80106b05:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106b08:	83 ec 0c             	sub    $0xc,%esp
80106b0b:	68 25 74 10 80       	push   $0x80107425
80106b10:	e8 0b 9b ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106b15:	83 c4 10             	add    $0x10,%esp
80106b18:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106b1b:	74 0d                	je     80106b2a <allocuvm+0xe6>
80106b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b20:	89 f2                	mov    %esi,%edx
80106b22:	8b 45 08             	mov    0x8(%ebp),%eax
80106b25:	e8 c2 fa ff ff       	call   801065ec <deallocuvm.part.0>
      kfree(mem);
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	53                   	push   %ebx
80106b2e:	e8 d9 b7 ff ff       	call   8010230c <kfree>
      return 0;
80106b33:	83 c4 10             	add    $0x10,%esp
    return 0;
80106b36:	31 d2                	xor    %edx,%edx
80106b38:	eb b1                	jmp    80106aeb <allocuvm+0xa7>
80106b3a:	66 90                	xchg   %ax,%ax
80106b3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106b3f:	89 d0                	mov    %edx,%eax
80106b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b44:	5b                   	pop    %ebx
80106b45:	5e                   	pop    %esi
80106b46:	5f                   	pop    %edi
80106b47:	5d                   	pop    %ebp
80106b48:	c3                   	ret
80106b49:	8d 76 00             	lea    0x0(%esi),%esi

80106b4c <deallocuvm>:
{
80106b4c:	55                   	push   %ebp
80106b4d:	89 e5                	mov    %esp,%ebp
80106b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b52:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
80106b58:	39 d1                	cmp    %edx,%ecx
80106b5a:	73 08                	jae    80106b64 <deallocuvm+0x18>
}
80106b5c:	5d                   	pop    %ebp
80106b5d:	e9 8a fa ff ff       	jmp    801065ec <deallocuvm.part.0>
80106b62:	66 90                	xchg   %ax,%ax
80106b64:	89 d0                	mov    %edx,%eax
80106b66:	5d                   	pop    %ebp
80106b67:	c3                   	ret

80106b68 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b68:	55                   	push   %ebp
80106b69:	89 e5                	mov    %esp,%ebp
80106b6b:	57                   	push   %edi
80106b6c:	56                   	push   %esi
80106b6d:	53                   	push   %ebx
80106b6e:	83 ec 0c             	sub    $0xc,%esp
80106b71:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b74:	85 f6                	test   %esi,%esi
80106b76:	74 51                	je     80106bc9 <freevm+0x61>
  if(newsz >= oldsz)
80106b78:	31 c9                	xor    %ecx,%ecx
80106b7a:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b7f:	89 f0                	mov    %esi,%eax
80106b81:	e8 66 fa ff ff       	call   801065ec <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b86:	89 f3                	mov    %esi,%ebx
80106b88:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106b8e:	eb 07                	jmp    80106b97 <freevm+0x2f>
80106b90:	83 c3 04             	add    $0x4,%ebx
80106b93:	39 fb                	cmp    %edi,%ebx
80106b95:	74 23                	je     80106bba <freevm+0x52>
    if(pgdir[i] & PTE_P){
80106b97:	8b 03                	mov    (%ebx),%eax
80106b99:	a8 01                	test   $0x1,%al
80106b9b:	74 f3                	je     80106b90 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106b9d:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ba0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ba5:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106baa:	50                   	push   %eax
80106bab:	e8 5c b7 ff ff       	call   8010230c <kfree>
80106bb0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106bb3:	83 c3 04             	add    $0x4,%ebx
80106bb6:	39 fb                	cmp    %edi,%ebx
80106bb8:	75 dd                	jne    80106b97 <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
80106bba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc0:	5b                   	pop    %ebx
80106bc1:	5e                   	pop    %esi
80106bc2:	5f                   	pop    %edi
80106bc3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106bc4:	e9 43 b7 ff ff       	jmp    8010230c <kfree>
    panic("freevm: no pgdir");
80106bc9:	83 ec 0c             	sub    $0xc,%esp
80106bcc:	68 41 74 10 80       	push   $0x80107441
80106bd1:	e8 62 97 ff ff       	call   80100338 <panic>
80106bd6:	66 90                	xchg   %ax,%ax

80106bd8 <setupkvm>:
{
80106bd8:	55                   	push   %ebp
80106bd9:	89 e5                	mov    %esp,%ebp
80106bdb:	56                   	push   %esi
80106bdc:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106bdd:	e8 ba b8 ff ff       	call   8010249c <kalloc>
80106be2:	85 c0                	test   %eax,%eax
80106be4:	74 56                	je     80106c3c <setupkvm+0x64>
80106be6:	89 c6                	mov    %eax,%esi
  memset(pgdir, 0, PGSIZE);
80106be8:	50                   	push   %eax
80106be9:	68 00 10 00 00       	push   $0x1000
80106bee:	6a 00                	push   $0x0
80106bf0:	56                   	push   %esi
80106bf1:	e8 de da ff ff       	call   801046d4 <memset>
80106bf6:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106bf9:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
80106bfe:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106c01:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106c04:	29 c1                	sub    %eax,%ecx
80106c06:	8b 13                	mov    (%ebx),%edx
80106c08:	83 ec 08             	sub    $0x8,%esp
80106c0b:	ff 73 0c             	push   0xc(%ebx)
80106c0e:	50                   	push   %eax
80106c0f:	89 f0                	mov    %esi,%eax
80106c11:	e8 86 fa ff ff       	call   8010669c <mappages>
80106c16:	83 c4 10             	add    $0x10,%esp
80106c19:	40                   	inc    %eax
80106c1a:	74 14                	je     80106c30 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c1c:	83 c3 10             	add    $0x10,%ebx
80106c1f:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c25:	75 d7                	jne    80106bfe <setupkvm+0x26>
}
80106c27:	89 f0                	mov    %esi,%eax
80106c29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c2c:	5b                   	pop    %ebx
80106c2d:	5e                   	pop    %esi
80106c2e:	5d                   	pop    %ebp
80106c2f:	c3                   	ret
      freevm(pgdir);
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	56                   	push   %esi
80106c34:	e8 2f ff ff ff       	call   80106b68 <freevm>
      return 0;
80106c39:	83 c4 10             	add    $0x10,%esp
    return 0;
80106c3c:	31 f6                	xor    %esi,%esi
}
80106c3e:	89 f0                	mov    %esi,%eax
80106c40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c43:	5b                   	pop    %ebx
80106c44:	5e                   	pop    %esi
80106c45:	5d                   	pop    %ebp
80106c46:	c3                   	ret
80106c47:	90                   	nop

80106c48 <kvmalloc>:
{
80106c48:	55                   	push   %ebp
80106c49:	89 e5                	mov    %esp,%ebp
80106c4b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c4e:	e8 85 ff ff ff       	call   80106bd8 <setupkvm>
80106c53:	a3 c4 57 11 80       	mov    %eax,0x801157c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c58:	05 00 00 00 80       	add    $0x80000000,%eax
80106c5d:	0f 22 d8             	mov    %eax,%cr3
}
80106c60:	c9                   	leave
80106c61:	c3                   	ret
80106c62:	66 90                	xchg   %ax,%ax

80106c64 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c64:	55                   	push   %ebp
80106c65:	89 e5                	mov    %esp,%ebp
80106c67:	83 ec 08             	sub    $0x8,%esp
  pde = &pgdir[PDX(va)];
80106c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c6d:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c70:	8b 45 08             	mov    0x8(%ebp),%eax
80106c73:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106c76:	a8 01                	test   $0x1,%al
80106c78:	75 0e                	jne    80106c88 <clearpteu+0x24>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	68 52 74 10 80       	push   $0x80107452
80106c82:	e8 b1 96 ff ff       	call   80100338 <panic>
80106c87:	90                   	nop
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c8d:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
80106c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c92:	c1 e8 0a             	shr    $0xa,%eax
80106c95:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c9a:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106ca1:	85 c0                	test   %eax,%eax
80106ca3:	74 d5                	je     80106c7a <clearpteu+0x16>
  *pte &= ~PTE_U;
80106ca5:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ca8:	c9                   	leave
80106ca9:	c3                   	ret
80106caa:	66 90                	xchg   %ax,%ax

80106cac <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106cac:	55                   	push   %ebp
80106cad:	89 e5                	mov    %esp,%ebp
80106caf:	57                   	push   %edi
80106cb0:	56                   	push   %esi
80106cb1:	53                   	push   %ebx
80106cb2:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106cb5:	e8 1e ff ff ff       	call   80106bd8 <setupkvm>
80106cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cbd:	85 c0                	test   %eax,%eax
80106cbf:	0f 84 d5 00 00 00    	je     80106d9a <copyuvm+0xee>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106cc5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106cc8:	85 db                	test   %ebx,%ebx
80106cca:	0f 84 a4 00 00 00    	je     80106d74 <copyuvm+0xc8>
80106cd0:	31 ff                	xor    %edi,%edi
80106cd2:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
80106cd4:	89 f8                	mov    %edi,%eax
80106cd6:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106cd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106cdc:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106cdf:	a8 01                	test   $0x1,%al
80106ce1:	75 0d                	jne    80106cf0 <copyuvm+0x44>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106ce3:	83 ec 0c             	sub    $0xc,%esp
80106ce6:	68 5c 74 10 80       	push   $0x8010745c
80106ceb:	e8 48 96 ff ff       	call   80100338 <panic>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cf5:	89 fa                	mov    %edi,%edx
80106cf7:	c1 ea 0a             	shr    $0xa,%edx
80106cfa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d07:	85 c0                	test   %eax,%eax
80106d09:	74 d8                	je     80106ce3 <copyuvm+0x37>
    if(!(*pte & PTE_P))
80106d0b:	8b 18                	mov    (%eax),%ebx
80106d0d:	f6 c3 01             	test   $0x1,%bl
80106d10:	0f 84 8d 00 00 00    	je     80106da3 <copyuvm+0xf7>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d16:	89 d8                	mov    %ebx,%eax
80106d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106d20:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
80106d26:	e8 71 b7 ff ff       	call   8010249c <kalloc>
80106d2b:	89 c6                	mov    %eax,%esi
80106d2d:	85 c0                	test   %eax,%eax
80106d2f:	74 5b                	je     80106d8c <copyuvm+0xe0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106d31:	50                   	push   %eax
80106d32:	68 00 10 00 00       	push   $0x1000
80106d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d3a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d3f:	50                   	push   %eax
80106d40:	56                   	push   %esi
80106d41:	e8 0a da ff ff       	call   80104750 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106d46:	5a                   	pop    %edx
80106d47:	59                   	pop    %ecx
80106d48:	53                   	push   %ebx
80106d49:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d4f:	50                   	push   %eax
80106d50:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d55:	89 fa                	mov    %edi,%edx
80106d57:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d5a:	e8 3d f9 ff ff       	call   8010669c <mappages>
80106d5f:	83 c4 10             	add    $0x10,%esp
80106d62:	40                   	inc    %eax
80106d63:	74 1b                	je     80106d80 <copyuvm+0xd4>
  for(i = 0; i < sz; i += PGSIZE){
80106d65:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106d6b:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d6e:	0f 82 60 ff ff ff    	jb     80106cd4 <copyuvm+0x28>
  return d;

bad:
  freevm(d);
  return 0;
}
80106d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d7a:	5b                   	pop    %ebx
80106d7b:	5e                   	pop    %esi
80106d7c:	5f                   	pop    %edi
80106d7d:	5d                   	pop    %ebp
80106d7e:	c3                   	ret
80106d7f:	90                   	nop
      kfree(mem);
80106d80:	83 ec 0c             	sub    $0xc,%esp
80106d83:	56                   	push   %esi
80106d84:	e8 83 b5 ff ff       	call   8010230c <kfree>
      goto bad;
80106d89:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80106d8c:	83 ec 0c             	sub    $0xc,%esp
80106d8f:	ff 75 e0             	push   -0x20(%ebp)
80106d92:	e8 d1 fd ff ff       	call   80106b68 <freevm>
  return 0;
80106d97:	83 c4 10             	add    $0x10,%esp
    return 0;
80106d9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106da1:	eb d1                	jmp    80106d74 <copyuvm+0xc8>
      panic("copyuvm: page not present");
80106da3:	83 ec 0c             	sub    $0xc,%esp
80106da6:	68 76 74 10 80       	push   $0x80107476
80106dab:	e8 88 95 ff ff       	call   80100338 <panic>

80106db0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
  pde = &pgdir[PDX(va)];
80106db3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106db6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106db9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbc:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106dbf:	a8 01                	test   $0x1,%al
80106dc1:	0f 84 e3 00 00 00    	je     80106eaa <uva2ka.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dcc:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
80106dce:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dd1:	c1 e8 0c             	shr    $0xc,%eax
80106dd4:	25 ff 03 00 00       	and    $0x3ff,%eax
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
80106dd9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106de0:	89 c2                	mov    %eax,%edx
80106de2:	f7 d2                	not    %edx
80106de4:	83 e2 05             	and    $0x5,%edx
80106de7:	75 0f                	jne    80106df8 <uva2ka+0x48>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106de9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dee:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106df3:	5d                   	pop    %ebp
80106df4:	c3                   	ret
80106df5:	8d 76 00             	lea    0x0(%esi),%esi
80106df8:	31 c0                	xor    %eax,%eax
80106dfa:	5d                   	pop    %ebp
80106dfb:	c3                   	ret

80106dfc <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106dfc:	55                   	push   %ebp
80106dfd:	89 e5                	mov    %esp,%ebp
80106dff:	57                   	push   %edi
80106e00:	56                   	push   %esi
80106e01:	53                   	push   %ebx
80106e02:	83 ec 0c             	sub    $0xc,%esp
80106e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e08:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e0b:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106e0e:	85 db                	test   %ebx,%ebx
80106e10:	0f 84 8a 00 00 00    	je     80106ea0 <copyout+0xa4>
80106e16:	89 fe                	mov    %edi,%esi
80106e18:	eb 3d                	jmp    80106e57 <copyout+0x5b>
80106e1a:	66 90                	xchg   %ax,%ax
  return (char*)P2V(PTE_ADDR(*pte));
80106e1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80106e21:	05 00 00 00 80       	add    $0x80000000,%eax
80106e26:	74 6a                	je     80106e92 <copyout+0x96>
      return -1;
    n = PGSIZE - (va - va0);
80106e28:	89 fb                	mov    %edi,%ebx
80106e2a:	29 cb                	sub    %ecx,%ebx
    if(n > len)
80106e2c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e32:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80106e35:	73 03                	jae    80106e3a <copyout+0x3e>
80106e37:	8b 5d 14             	mov    0x14(%ebp),%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e3a:	52                   	push   %edx
80106e3b:	53                   	push   %ebx
80106e3c:	56                   	push   %esi
80106e3d:	29 f9                	sub    %edi,%ecx
80106e3f:	01 c8                	add    %ecx,%eax
80106e41:	50                   	push   %eax
80106e42:	e8 09 d9 ff ff       	call   80104750 <memmove>
    len -= n;
    buf += n;
80106e47:	01 de                	add    %ebx,%esi
    va = va0 + PGSIZE;
80106e49:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
80106e4f:	83 c4 10             	add    $0x10,%esp
80106e52:	29 5d 14             	sub    %ebx,0x14(%ebp)
80106e55:	74 49                	je     80106ea0 <copyout+0xa4>
    va0 = (uint)PGROUNDDOWN(va);
80106e57:	89 cf                	mov    %ecx,%edi
80106e59:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pde = &pgdir[PDX(va)];
80106e5f:	89 c8                	mov    %ecx,%eax
80106e61:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106e64:	8b 55 08             	mov    0x8(%ebp),%edx
80106e67:	8b 04 82             	mov    (%edx,%eax,4),%eax
80106e6a:	a8 01                	test   $0x1,%al
80106e6c:	0f 84 3f 00 00 00    	je     80106eb1 <copyout.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e77:	89 fb                	mov    %edi,%ebx
80106e79:	c1 eb 0c             	shr    $0xc,%ebx
80106e7c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106e82:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80106e89:	89 c3                	mov    %eax,%ebx
80106e8b:	f7 d3                	not    %ebx
80106e8d:	83 e3 05             	and    $0x5,%ebx
80106e90:	74 8a                	je     80106e1c <copyout+0x20>
      return -1;
80106e92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9a:	5b                   	pop    %ebx
80106e9b:	5e                   	pop    %esi
80106e9c:	5f                   	pop    %edi
80106e9d:	5d                   	pop    %ebp
80106e9e:	c3                   	ret
80106e9f:	90                   	nop
  return 0;
80106ea0:	31 c0                	xor    %eax,%eax
}
80106ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret

80106eaa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106eaa:	a1 00 00 00 00       	mov    0x0,%eax
80106eaf:	0f 0b                	ud2

80106eb1 <copyout.cold>:
80106eb1:	a1 00 00 00 00       	mov    0x0,%eax
80106eb6:	0f 0b                	ud2
