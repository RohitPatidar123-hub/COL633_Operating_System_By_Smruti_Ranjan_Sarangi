
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
80100028:	bc d0 58 11 80       	mov    $0x801158d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2d 10 80       	mov    $0x80102d10,%eax
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
8010003b:	68 00 6b 10 80       	push   $0x80106b00
80100040:	68 20 a5 10 80       	push   $0x8010a520
80100045:	e8 5a 40 00 00       	call   801040a4 <initlock>

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
8010007f:	68 07 6b 10 80       	push   $0x80106b07
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 0b 3f 00 00       	call   80103f98 <initsleeplock>
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
801000c8:	e8 9f 41 00 00       	call   8010426c <acquire>
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
8010013e:	e8 c9 40 00 00       	call   8010420c <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 7e 3e 00 00       	call   80103fcc <acquiresleep>
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
80100164:	e8 df 1e 00 00       	call   80102048 <iderw>
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
80100179:	68 0e 6b 10 80       	push   $0x80106b0e
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
80100192:	e8 c5 3e 00 00       	call   8010405c <holdingsleep>
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
801001a8:	e9 9b 1e 00 00       	jmp    80102048 <iderw>
    panic("bwrite");
801001ad:	83 ec 0c             	sub    $0xc,%esp
801001b0:	68 1f 6b 10 80       	push   $0x80106b1f
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
801001cb:	e8 8c 3e 00 00       	call   8010405c <holdingsleep>
801001d0:	83 c4 10             	add    $0x10,%esp
801001d3:	85 c0                	test   %eax,%eax
801001d5:	74 61                	je     80100238 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	56                   	push   %esi
801001db:	e8 40 3e 00 00       	call   80104020 <releasesleep>

  acquire(&bcache.lock);
801001e0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001e7:	e8 80 40 00 00       	call   8010426c <acquire>
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
80100233:	e9 d4 3f 00 00       	jmp    8010420c <release>
    panic("brelse");
80100238:	83 ec 0c             	sub    $0xc,%esp
8010023b:	68 26 6b 10 80       	push   $0x80106b26
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
80100258:	e8 87 14 00 00       	call   801016e4 <iunlock>
  target = n;
8010025d:	89 de                	mov    %ebx,%esi
  acquire(&cons.lock);
8010025f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100266:	e8 01 40 00 00       	call   8010426c <acquire>
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
80100295:	e8 aa 39 00 00       	call   80103c44 <sleep>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a8:	75 32                	jne    801002dc <consoleread+0x94>
      if(myproc()->killed){
801002aa:	e8 e9 32 00 00       	call   80103598 <myproc>
801002af:	8b 40 34             	mov    0x34(%eax),%eax
801002b2:	85 c0                	test   %eax,%eax
801002b4:	74 d2                	je     80100288 <consoleread+0x40>
        release(&cons.lock);
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 20 ef 10 80       	push   $0x8010ef20
801002be:	e8 49 3f 00 00       	call   8010420c <release>
        ilock(ip);
801002c3:	89 3c 24             	mov    %edi,(%esp)
801002c6:	e8 51 13 00 00       	call   8010161c <ilock>
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
80100311:	e8 f6 3e 00 00       	call   8010420c <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 fe 12 00 00       	call   8010161c <ilock>
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
8010034a:	e8 09 23 00 00       	call   80102658 <lapicid>
8010034f:	83 ec 08             	sub    $0x8,%esp
80100352:	50                   	push   %eax
80100353:	68 2d 6b 10 80       	push   $0x80106b2d
80100358:	e8 c3 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
8010035d:	58                   	pop    %eax
8010035e:	ff 75 08             	push   0x8(%ebp)
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
80100366:	c7 04 24 61 70 10 80 	movl   $0x80107061,(%esp)
8010036d:	e8 ae 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
80100372:	5a                   	pop    %edx
80100373:	59                   	pop    %ecx
80100374:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100377:	53                   	push   %ebx
80100378:	8d 45 08             	lea    0x8(%ebp),%eax
8010037b:	50                   	push   %eax
8010037c:	e8 3f 3d 00 00       	call   801040c0 <getcallerpcs>
  for(i=0; i<10; i++)
80100381:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100384:	83 ec 08             	sub    $0x8,%esp
80100387:	ff 33                	push   (%ebx)
80100389:	68 41 6b 10 80       	push   $0x80106b41
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
801003c6:	e8 99 53 00 00       	call   80105764 <uartputc>
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
80100475:	e8 ea 52 00 00       	call   80105764 <uartputc>
8010047a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100481:	e8 de 52 00 00       	call   80105764 <uartputc>
80100486:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010048d:	e8 d2 52 00 00       	call   80105764 <uartputc>
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
801004d4:	e8 db 3e 00 00       	call   801043b4 <memmove>
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
801004f9:	e8 3a 3e 00 00       	call   80104338 <memset>
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
80100521:	68 45 6b 10 80       	push   $0x80106b45
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
8010053b:	e8 a4 11 00 00       	call   801016e4 <iunlock>
  acquire(&cons.lock);
80100540:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100547:	e8 20 3d 00 00       	call   8010426c <acquire>
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
8010057d:	e8 8a 3c 00 00       	call   8010420c <release>
  ilock(ip);
80100582:	58                   	pop    %eax
80100583:	ff 75 08             	push   0x8(%ebp)
80100586:	e8 91 10 00 00       	call   8010161c <ilock>

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
801005c3:	8a 92 b4 70 10 80    	mov    -0x7fef8f4c(%edx),%dl
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
80100738:	e8 2f 3b 00 00       	call   8010426c <acquire>
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
8010075b:	e8 ac 3a 00 00       	call   8010420c <release>
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
80100791:	bf 58 6b 10 80       	mov    $0x80106b58,%edi
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
801007de:	68 5f 6b 10 80       	push   $0x80106b5f
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
801007f9:	e8 6e 3a 00 00       	call   8010426c <acquire>
  while((c = getc()) >= 0){
801007fe:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100801:	31 ff                	xor    %edi,%edi
  while((c = getc()) >= 0){
80100803:	ff d6                	call   *%esi
80100805:	85 c0                	test   %eax,%eax
80100807:	78 20                	js     80100829 <consoleintr+0x41>
    switch(c){
80100809:	83 f8 15             	cmp    $0x15,%eax
8010080c:	74 3e                	je     8010084c <consoleintr+0x64>
8010080e:	7f 6c                	jg     8010087c <consoleintr+0x94>
80100810:	83 f8 08             	cmp    $0x8,%eax
80100813:	74 6c                	je     80100881 <consoleintr+0x99>
80100815:	83 f8 10             	cmp    $0x10,%eax
80100818:	0f 85 25 01 00 00    	jne    80100943 <consoleintr+0x15b>
8010081e:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
80100823:	ff d6                	call   *%esi
80100825:	85 c0                	test   %eax,%eax
80100827:	79 e0                	jns    80100809 <consoleintr+0x21>
  release(&cons.lock);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 20 ef 10 80       	push   $0x8010ef20
80100831:	e8 d6 39 00 00       	call   8010420c <release>
  if(doprocdump) {
80100836:	83 c4 10             	add    $0x10,%esp
80100839:	85 ff                	test   %edi,%edi
8010083b:	0f 85 64 01 00 00    	jne    801009a5 <consoleintr+0x1bd>
}
80100841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100844:	5b                   	pop    %ebx
80100845:	5e                   	pop    %esi
80100846:	5f                   	pop    %edi
80100847:	5d                   	pop    %ebp
80100848:	c3                   	ret
80100849:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
8010084c:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100851:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100857:	74 aa                	je     80100803 <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100859:	48                   	dec    %eax
8010085a:	89 c2                	mov    %eax,%edx
8010085c:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010085f:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100866:	74 9b                	je     80100803 <consoleintr+0x1b>
        input.e--;
80100868:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010086d:	8b 1d 58 ef 10 80    	mov    0x8010ef58,%ebx
80100873:	85 db                	test   %ebx,%ebx
80100875:	74 35                	je     801008ac <consoleintr+0xc4>
80100877:	fa                   	cli
    for(;;)
80100878:	eb fe                	jmp    80100878 <consoleintr+0x90>
8010087a:	66 90                	xchg   %ax,%ax
    switch(c){
8010087c:	83 f8 7f             	cmp    $0x7f,%eax
8010087f:	75 47                	jne    801008c8 <consoleintr+0xe0>
      if(input.e != input.w){
80100881:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100886:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010088c:	0f 84 71 ff ff ff    	je     80100803 <consoleintr+0x1b>
        input.e--;
80100892:	48                   	dec    %eax
80100893:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100898:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
8010089e:	85 c9                	test   %ecx,%ecx
801008a0:	0f 84 f0 00 00 00    	je     80100996 <consoleintr+0x1ae>
801008a6:	fa                   	cli
    for(;;)
801008a7:	eb fe                	jmp    801008a7 <consoleintr+0xbf>
801008a9:	8d 76 00             	lea    0x0(%esi),%esi
801008ac:	b8 00 01 00 00       	mov    $0x100,%eax
801008b1:	e8 f6 fa ff ff       	call   801003ac <consputc.part.0>
      while(input.e != input.w &&
801008b6:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008bb:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801008c1:	75 96                	jne    80100859 <consoleintr+0x71>
801008c3:	e9 3b ff ff ff       	jmp    80100803 <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008c8:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
801008ce:	89 ca                	mov    %ecx,%edx
801008d0:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008d6:	83 fa 7f             	cmp    $0x7f,%edx
801008d9:	0f 87 24 ff ff ff    	ja     80100803 <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801008df:	8d 51 01             	lea    0x1(%ecx),%edx
801008e2:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801008e8:	83 e1 7f             	and    $0x7f,%ecx
801008eb:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
801008f1:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801008f7:	85 d2                	test   %edx,%edx
801008f9:	0f 85 b2 00 00 00    	jne    801009b1 <consoleintr+0x1c9>
801008ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100902:	e8 a5 fa ff ff       	call   801003ac <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100907:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
8010090d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100910:	83 f8 04             	cmp    $0x4,%eax
80100913:	74 13                	je     80100928 <consoleintr+0x140>
80100915:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010091a:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100920:	39 ca                	cmp    %ecx,%edx
80100922:	0f 85 db fe ff ff    	jne    80100803 <consoleintr+0x1b>
          input.w = input.e;
80100928:	89 0d 04 ef 10 80    	mov    %ecx,0x8010ef04
          wakeup(&input.r);
8010092e:	83 ec 0c             	sub    $0xc,%esp
80100931:	68 00 ef 10 80       	push   $0x8010ef00
80100936:	e8 dd 34 00 00       	call   80103e18 <wakeup>
8010093b:	83 c4 10             	add    $0x10,%esp
8010093e:	e9 c0 fe ff ff       	jmp    80100803 <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100943:	85 c0                	test   %eax,%eax
80100945:	0f 84 b8 fe ff ff    	je     80100803 <consoleintr+0x1b>
8010094b:	8b 1d 08 ef 10 80    	mov    0x8010ef08,%ebx
80100951:	89 da                	mov    %ebx,%edx
80100953:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100959:	83 fa 7f             	cmp    $0x7f,%edx
8010095c:	0f 87 a1 fe ff ff    	ja     80100803 <consoleintr+0x1b>
  if(panicked){
80100962:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100968:	8d 4b 01             	lea    0x1(%ebx),%ecx
8010096b:	83 e3 7f             	and    $0x7f,%ebx
8010096e:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100974:	83 f8 0d             	cmp    $0xd,%eax
80100977:	75 3b                	jne    801009b4 <consoleintr+0x1cc>
        input.buf[input.e++ % INPUT_BUF] = c;
80100979:	c6 83 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ebx)
  if(panicked){
80100980:	85 d2                	test   %edx,%edx
80100982:	75 2d                	jne    801009b1 <consoleintr+0x1c9>
80100984:	b8 0a 00 00 00       	mov    $0xa,%eax
80100989:	e8 1e fa ff ff       	call   801003ac <consputc.part.0>
          input.w = input.e;
8010098e:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100994:	eb 92                	jmp    80100928 <consoleintr+0x140>
80100996:	b8 00 01 00 00       	mov    $0x100,%eax
8010099b:	e8 0c fa ff ff       	call   801003ac <consputc.part.0>
801009a0:	e9 5e fe ff ff       	jmp    80100803 <consoleintr+0x1b>
}
801009a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009a8:	5b                   	pop    %ebx
801009a9:	5e                   	pop    %esi
801009aa:	5f                   	pop    %edi
801009ab:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ac:	e9 3b 35 00 00       	jmp    80103eec <procdump>
801009b1:	fa                   	cli
    for(;;)
801009b2:	eb fe                	jmp    801009b2 <consoleintr+0x1ca>
        input.buf[input.e++ % INPUT_BUF] = c;
801009b4:	88 83 80 ee 10 80    	mov    %al,-0x7fef1180(%ebx)
  if(panicked){
801009ba:	85 d2                	test   %edx,%edx
801009bc:	75 f3                	jne    801009b1 <consoleintr+0x1c9>
801009be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801009c1:	e8 e6 f9 ff ff       	call   801003ac <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009c6:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
801009cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009cf:	83 f8 0a             	cmp    $0xa,%eax
801009d2:	0f 85 38 ff ff ff    	jne    80100910 <consoleintr+0x128>
801009d8:	e9 4b ff ff ff       	jmp    80100928 <consoleintr+0x140>
801009dd:	8d 76 00             	lea    0x0(%esi),%esi

801009e0 <consoleinit>:

void
consoleinit(void)
{
801009e0:	55                   	push   %ebp
801009e1:	89 e5                	mov    %esp,%ebp
801009e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009e6:	68 68 6b 10 80       	push   $0x80106b68
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 af 36 00 00       	call   801040a4 <initlock>

  devsw[CONSOLE].write = consolewrite;
801009f5:	c7 05 0c f9 10 80 2c 	movl   $0x8010052c,0x8010f90c
801009fc:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801009ff:	c7 05 08 f9 10 80 48 	movl   $0x80100248,0x8010f908
80100a06:	02 10 80 
  cons.locking = 1;
80100a09:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a10:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100a13:	58                   	pop    %eax
80100a14:	5a                   	pop    %edx
80100a15:	6a 00                	push   $0x0
80100a17:	6a 01                	push   $0x1
80100a19:	e8 aa 17 00 00       	call   801021c8 <ioapicenable>
}
80100a1e:	83 c4 10             	add    $0x10,%esp
80100a21:	c9                   	leave
80100a22:	c3                   	ret
80100a23:	90                   	nop

80100a24 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a24:	55                   	push   %ebp
80100a25:	89 e5                	mov    %esp,%ebp
80100a27:	57                   	push   %edi
80100a28:	56                   	push   %esi
80100a29:	53                   	push   %ebx
80100a2a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a30:	e8 63 2b 00 00       	call   80103598 <myproc>
80100a35:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a3b:	e8 1c 20 00 00       	call   80102a5c <begin_op>

  if((ip = namei(path)) == 0){
80100a40:	83 ec 0c             	sub    $0xc,%esp
80100a43:	ff 75 08             	push   0x8(%ebp)
80100a46:	e8 21 14 00 00       	call   80101e6c <namei>
80100a4b:	83 c4 10             	add    $0x10,%esp
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	0f 84 10 03 00 00    	je     80100d66 <exec+0x342>
80100a56:	89 c7                	mov    %eax,%edi
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	50                   	push   %eax
80100a5c:	e8 bb 0b 00 00       	call   8010161c <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a61:	6a 34                	push   $0x34
80100a63:	6a 00                	push   $0x0
80100a65:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a6b:	50                   	push   %eax
80100a6c:	57                   	push   %edi
80100a6d:	e8 7a 0e 00 00       	call   801018ec <readi>
80100a72:	83 c4 20             	add    $0x20,%esp
80100a75:	83 f8 34             	cmp    $0x34,%eax
80100a78:	0f 85 f9 00 00 00    	jne    80100b77 <exec+0x153>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a7e:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a85:	45 4c 46 
80100a88:	0f 85 e9 00 00 00    	jne    80100b77 <exec+0x153>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a8e:	e8 8d 5d 00 00       	call   80106820 <setupkvm>
80100a93:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	0f 84 d6 00 00 00    	je     80100b77 <exec+0x153>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa1:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100aa7:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aae:	00 
80100aaf:	0f 84 81 02 00 00    	je     80100d36 <exec+0x312>
  sz = 0;
80100ab5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100abc:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100abf:	31 db                	xor    %ebx,%ebx
80100ac1:	e9 84 00 00 00       	jmp    80100b4a <exec+0x126>
80100ac6:	66 90                	xchg   %ax,%ax
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 6a                	jne    80100b3b <exec+0x117>
      continue;
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 83 00 00 00    	jb     80100b66 <exec+0x142>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7b                	jb     80100b66 <exec+0x142>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	51                   	push   %ecx
80100aec:	50                   	push   %eax
80100aed:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100af3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100af9:	e8 8e 5b 00 00       	call   8010668c <allocuvm>
80100afe:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b04:	83 c4 10             	add    $0x10,%esp
80100b07:	85 c0                	test   %eax,%eax
80100b09:	74 5b                	je     80100b66 <exec+0x142>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b0b:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b11:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b16:	75 4e                	jne    80100b66 <exec+0x142>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b18:	83 ec 0c             	sub    $0xc,%esp
80100b1b:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100b21:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100b27:	57                   	push   %edi
80100b28:	50                   	push   %eax
80100b29:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b2f:	e8 94 5a 00 00       	call   801065c8 <loaduvm>
80100b34:	83 c4 20             	add    $0x20,%esp
80100b37:	85 c0                	test   %eax,%eax
80100b39:	78 2b                	js     80100b66 <exec+0x142>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b3b:	43                   	inc    %ebx
80100b3c:	83 c6 20             	add    $0x20,%esi
80100b3f:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b46:	39 d8                	cmp    %ebx,%eax
80100b48:	7e 4e                	jle    80100b98 <exec+0x174>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b4a:	6a 20                	push   $0x20
80100b4c:	56                   	push   %esi
80100b4d:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b53:	50                   	push   %eax
80100b54:	57                   	push   %edi
80100b55:	e8 92 0d 00 00       	call   801018ec <readi>
80100b5a:	83 c4 10             	add    $0x10,%esp
80100b5d:	83 f8 20             	cmp    $0x20,%eax
80100b60:	0f 84 62 ff ff ff    	je     80100ac8 <exec+0xa4>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b6f:	e8 3c 5c 00 00       	call   801067b0 <freevm>
  if(ip){
80100b74:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100b77:	83 ec 0c             	sub    $0xc,%esp
80100b7a:	57                   	push   %edi
80100b7b:	e8 f0 0c 00 00       	call   80101870 <iunlockput>
    end_op();
80100b80:	e8 3f 1f 00 00       	call   80102ac4 <end_op>
80100b85:	83 c4 10             	add    $0x10,%esp
    return -1;
80100b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b90:	5b                   	pop    %ebx
80100b91:	5e                   	pop    %esi
80100b92:	5f                   	pop    %edi
80100b93:	5d                   	pop    %ebp
80100b94:	c3                   	ret
80100b95:	8d 76 00             	lea    0x0(%esi),%esi
  sz = PGROUNDUP(sz);
80100b98:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b9e:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100ba4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100baa:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	57                   	push   %edi
80100bb4:	e8 b7 0c 00 00       	call   80101870 <iunlockput>
  end_op();
80100bb9:	e8 06 1f 00 00       	call   80102ac4 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bbe:	83 c4 0c             	add    $0xc,%esp
80100bc1:	53                   	push   %ebx
80100bc2:	56                   	push   %esi
80100bc3:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bc9:	56                   	push   %esi
80100bca:	e8 bd 5a 00 00       	call   8010668c <allocuvm>
80100bcf:	89 c7                	mov    %eax,%edi
80100bd1:	83 c4 10             	add    $0x10,%esp
80100bd4:	85 c0                	test   %eax,%eax
80100bd6:	74 7e                	je     80100c56 <exec+0x232>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd8:	83 ec 08             	sub    $0x8,%esp
80100bdb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be1:	50                   	push   %eax
80100be2:	56                   	push   %esi
80100be3:	e8 c4 5c 00 00       	call   801068ac <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100be8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100beb:	8b 10                	mov    (%eax),%edx
80100bed:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100bf0:	89 fb                	mov    %edi,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100bf2:	85 d2                	test   %edx,%edx
80100bf4:	0f 84 48 01 00 00    	je     80100d42 <exec+0x31e>
80100bfa:	31 f6                	xor    %esi,%esi
80100bfc:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c02:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100c05:	eb 1f                	jmp    80100c26 <exec+0x202>
80100c07:	90                   	nop
    ustack[3+argc] = sp;
80100c08:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c0e:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c15:	8d 46 01             	lea    0x1(%esi),%eax
80100c18:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100c1b:	85 d2                	test   %edx,%edx
80100c1d:	74 4d                	je     80100c6c <exec+0x248>
    if(argc >= MAXARG)
80100c1f:	83 f8 20             	cmp    $0x20,%eax
80100c22:	74 32                	je     80100c56 <exec+0x232>
80100c24:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c26:	83 ec 0c             	sub    $0xc,%esp
80100c29:	52                   	push   %edx
80100c2a:	e8 85 38 00 00       	call   801044b4 <strlen>
80100c2f:	29 c3                	sub    %eax,%ebx
80100c31:	4b                   	dec    %ebx
80100c32:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c35:	5a                   	pop    %edx
80100c36:	ff 34 b7             	push   (%edi,%esi,4)
80100c39:	e8 76 38 00 00       	call   801044b4 <strlen>
80100c3e:	40                   	inc    %eax
80100c3f:	50                   	push   %eax
80100c40:	ff 34 b7             	push   (%edi,%esi,4)
80100c43:	53                   	push   %ebx
80100c44:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c4a:	e8 f5 5d 00 00       	call   80106a44 <copyout>
80100c4f:	83 c4 20             	add    $0x20,%esp
80100c52:	85 c0                	test   %eax,%eax
80100c54:	79 b2                	jns    80100c08 <exec+0x1e4>
    freevm(pgdir);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c5f:	e8 4c 5b 00 00       	call   801067b0 <freevm>
80100c64:	83 c4 10             	add    $0x10,%esp
80100c67:	e9 1c ff ff ff       	jmp    80100b88 <exec+0x164>
  ustack[3+argc] = 0;
80100c6c:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c72:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c78:	8d 46 04             	lea    0x4(%esi),%eax
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7b:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  sp -= (3+argc+1) * 4;
80100c82:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100c85:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100c8c:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c90:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c97:	ff ff ff 
  ustack[1] = argc;
80100c9a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ca0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca6:	89 d8                	mov    %ebx,%eax
80100ca8:	29 d0                	sub    %edx,%eax
80100caa:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100cb0:	29 f3                	sub    %esi,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb2:	56                   	push   %esi
80100cb3:	51                   	push   %ecx
80100cb4:	53                   	push   %ebx
80100cb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cbb:	e8 84 5d 00 00       	call   80106a44 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	78 8f                	js     80100c56 <exec+0x232>
  for(last=s=path; *s; s++)
80100cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cca:	8a 00                	mov    (%eax),%al
80100ccc:	8b 55 08             	mov    0x8(%ebp),%edx
80100ccf:	84 c0                	test   %al,%al
80100cd1:	74 12                	je     80100ce5 <exec+0x2c1>
80100cd3:	89 d1                	mov    %edx,%ecx
80100cd5:	8d 76 00             	lea    0x0(%esi),%esi
      last = s+1;
80100cd8:	41                   	inc    %ecx
    if(*s == '/')
80100cd9:	3c 2f                	cmp    $0x2f,%al
80100cdb:	75 02                	jne    80100cdf <exec+0x2bb>
      last = s+1;
80100cdd:	89 ca                	mov    %ecx,%edx
  for(last=s=path; *s; s++)
80100cdf:	8a 01                	mov    (%ecx),%al
80100ce1:	84 c0                	test   %al,%al
80100ce3:	75 f3                	jne    80100cd8 <exec+0x2b4>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ce5:	50                   	push   %eax
80100ce6:	6a 10                	push   $0x10
80100ce8:	52                   	push   %edx
80100ce9:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100cef:	8d 46 7c             	lea    0x7c(%esi),%eax
80100cf2:	50                   	push   %eax
80100cf3:	e8 88 37 00 00       	call   80104480 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100cf8:	89 f0                	mov    %esi,%eax
80100cfa:	8b 76 14             	mov    0x14(%esi),%esi
  curproc->pgdir = pgdir;
80100cfd:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d03:	89 48 14             	mov    %ecx,0x14(%eax)
  curproc->sz = sz;
80100d06:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d08:	89 c1                	mov    %eax,%ecx
80100d0a:	8b 40 28             	mov    0x28(%eax),%eax
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 41 28             	mov    0x28(%ecx),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 0c 24             	mov    %ecx,(%esp)
80100d1f:	e8 34 57 00 00       	call   80106458 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 84 5a 00 00       	call   801067b0 <freevm>
  return 0;
80100d2c:	83 c4 10             	add    $0x10,%esp
80100d2f:	31 c0                	xor    %eax,%eax
80100d31:	e9 57 fe ff ff       	jmp    80100b8d <exec+0x169>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d36:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100d3b:	31 f6                	xor    %esi,%esi
80100d3d:	e9 6e fe ff ff       	jmp    80100bb0 <exec+0x18c>
  for(argc = 0; argv[argc]; argc++) {
80100d42:	be 10 00 00 00       	mov    $0x10,%esi
80100d47:	ba 04 00 00 00       	mov    $0x4,%edx
80100d4c:	b8 03 00 00 00       	mov    $0x3,%eax
80100d51:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d58:	00 00 00 
80100d5b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d61:	e9 1f ff ff ff       	jmp    80100c85 <exec+0x261>
    end_op();
80100d66:	e8 59 1d 00 00       	call   80102ac4 <end_op>
    cprintf("exec: fail\n");
80100d6b:	83 ec 0c             	sub    $0xc,%esp
80100d6e:	68 70 6b 10 80       	push   $0x80106b70
80100d73:	e8 a8 f8 ff ff       	call   80100620 <cprintf>
    return -1;
80100d78:	83 c4 10             	add    $0x10,%esp
80100d7b:	e9 08 fe ff ff       	jmp    80100b88 <exec+0x164>

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	68 7c 6b 10 80       	push   $0x80106b7c
80100d8b:	68 60 ef 10 80       	push   $0x8010ef60
80100d90:	e8 0f 33 00 00       	call   801040a4 <initlock>
}
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	c9                   	leave
80100d99:	c3                   	ret
80100d9a:	66 90                	xchg   %ax,%ax

80100d9c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d9c:	55                   	push   %ebp
80100d9d:	89 e5                	mov    %esp,%ebp
80100d9f:	53                   	push   %ebx
80100da0:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100da3:	68 60 ef 10 80       	push   $0x8010ef60
80100da8:	e8 bf 34 00 00       	call   8010426c <acquire>
80100dad:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db0:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100db5:	eb 0c                	jmp    80100dc3 <filealloc+0x27>
80100db7:	90                   	nop
80100db8:	83 c3 18             	add    $0x18,%ebx
80100dbb:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100dc1:	74 25                	je     80100de8 <filealloc+0x4c>
    if(f->ref == 0){
80100dc3:	8b 43 04             	mov    0x4(%ebx),%eax
80100dc6:	85 c0                	test   %eax,%eax
80100dc8:	75 ee                	jne    80100db8 <filealloc+0x1c>
      f->ref = 1;
80100dca:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dd1:	83 ec 0c             	sub    $0xc,%esp
80100dd4:	68 60 ef 10 80       	push   $0x8010ef60
80100dd9:	e8 2e 34 00 00       	call   8010420c <release>
      return f;
80100dde:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de1:	89 d8                	mov    %ebx,%eax
80100de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de6:	c9                   	leave
80100de7:	c3                   	ret
  release(&ftable.lock);
80100de8:	83 ec 0c             	sub    $0xc,%esp
80100deb:	68 60 ef 10 80       	push   $0x8010ef60
80100df0:	e8 17 34 00 00       	call   8010420c <release>
  return 0;
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	31 db                	xor    %ebx,%ebx
}
80100dfa:	89 d8                	mov    %ebx,%eax
80100dfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dff:	c9                   	leave
80100e00:	c3                   	ret
80100e01:	8d 76 00             	lea    0x0(%esi),%esi

80100e04 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
80100e08:	83 ec 10             	sub    $0x10,%esp
80100e0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e0e:	68 60 ef 10 80       	push   $0x8010ef60
80100e13:	e8 54 34 00 00       	call   8010426c <acquire>
  if(f->ref < 1)
80100e18:	8b 43 04             	mov    0x4(%ebx),%eax
80100e1b:	83 c4 10             	add    $0x10,%esp
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	7e 18                	jle    80100e3a <filedup+0x36>
    panic("filedup");
  f->ref++;
80100e22:	40                   	inc    %eax
80100e23:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e26:	83 ec 0c             	sub    $0xc,%esp
80100e29:	68 60 ef 10 80       	push   $0x8010ef60
80100e2e:	e8 d9 33 00 00       	call   8010420c <release>
  return f;
}
80100e33:	89 d8                	mov    %ebx,%eax
80100e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e38:	c9                   	leave
80100e39:	c3                   	ret
    panic("filedup");
80100e3a:	83 ec 0c             	sub    $0xc,%esp
80100e3d:	68 83 6b 10 80       	push   $0x80106b83
80100e42:	e8 f1 f4 ff ff       	call   80100338 <panic>
80100e47:	90                   	nop

80100e48 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e48:	55                   	push   %ebp
80100e49:	89 e5                	mov    %esp,%ebp
80100e4b:	57                   	push   %edi
80100e4c:	56                   	push   %esi
80100e4d:	53                   	push   %ebx
80100e4e:	83 ec 28             	sub    $0x28,%esp
80100e51:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e54:	68 60 ef 10 80       	push   $0x8010ef60
80100e59:	e8 0e 34 00 00       	call   8010426c <acquire>
  if(f->ref < 1)
80100e5e:	8b 57 04             	mov    0x4(%edi),%edx
80100e61:	83 c4 10             	add    $0x10,%esp
80100e64:	85 d2                	test   %edx,%edx
80100e66:	0f 8e 8d 00 00 00    	jle    80100ef9 <fileclose+0xb1>
    panic("fileclose");
  if(--f->ref > 0){
80100e6c:	4a                   	dec    %edx
80100e6d:	89 57 04             	mov    %edx,0x4(%edi)
80100e70:	75 3a                	jne    80100eac <fileclose+0x64>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e72:	8b 1f                	mov    (%edi),%ebx
80100e74:	8a 47 09             	mov    0x9(%edi),%al
80100e77:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e7a:	8b 77 0c             	mov    0xc(%edi),%esi
80100e7d:	8b 47 10             	mov    0x10(%edi),%eax
80100e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
80100e83:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100e89:	83 ec 0c             	sub    $0xc,%esp
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 76 33 00 00       	call   8010420c <release>

  if(ff.type == FD_PIPE)
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	83 fb 01             	cmp    $0x1,%ebx
80100e9c:	74 42                	je     80100ee0 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e9e:	83 fb 02             	cmp    $0x2,%ebx
80100ea1:	74 1d                	je     80100ec0 <fileclose+0x78>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea6:	5b                   	pop    %ebx
80100ea7:	5e                   	pop    %esi
80100ea8:	5f                   	pop    %edi
80100ea9:	5d                   	pop    %ebp
80100eaa:	c3                   	ret
80100eab:	90                   	nop
    release(&ftable.lock);
80100eac:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb6:	5b                   	pop    %ebx
80100eb7:	5e                   	pop    %esi
80100eb8:	5f                   	pop    %edi
80100eb9:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eba:	e9 4d 33 00 00       	jmp    8010420c <release>
80100ebf:	90                   	nop
    begin_op();
80100ec0:	e8 97 1b 00 00       	call   80102a5c <begin_op>
    iput(ff.ip);
80100ec5:	83 ec 0c             	sub    $0xc,%esp
80100ec8:	ff 75 e0             	push   -0x20(%ebp)
80100ecb:	e8 58 08 00 00       	call   80101728 <iput>
    end_op();
80100ed0:	83 c4 10             	add    $0x10,%esp
}
80100ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed6:	5b                   	pop    %ebx
80100ed7:	5e                   	pop    %esi
80100ed8:	5f                   	pop    %edi
80100ed9:	5d                   	pop    %ebp
    end_op();
80100eda:	e9 e5 1b 00 00       	jmp    80102ac4 <end_op>
80100edf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100ee0:	83 ec 08             	sub    $0x8,%esp
80100ee3:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100ee7:	50                   	push   %eax
80100ee8:	56                   	push   %esi
80100ee9:	e8 6e 22 00 00       	call   8010315c <pipeclose>
80100eee:	83 c4 10             	add    $0x10,%esp
}
80100ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef4:	5b                   	pop    %ebx
80100ef5:	5e                   	pop    %esi
80100ef6:	5f                   	pop    %edi
80100ef7:	5d                   	pop    %ebp
80100ef8:	c3                   	ret
    panic("fileclose");
80100ef9:	83 ec 0c             	sub    $0xc,%esp
80100efc:	68 8b 6b 10 80       	push   $0x80106b8b
80100f01:	e8 32 f4 ff ff       	call   80100338 <panic>
80100f06:	66 90                	xchg   %ax,%ax

80100f08 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f08:	55                   	push   %ebp
80100f09:	89 e5                	mov    %esp,%ebp
80100f0b:	53                   	push   %ebx
80100f0c:	53                   	push   %ebx
80100f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f10:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f13:	75 2b                	jne    80100f40 <filestat+0x38>
    ilock(f->ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 73 10             	push   0x10(%ebx)
80100f1b:	e8 fc 06 00 00       	call   8010161c <ilock>
    stati(f->ip, st);
80100f20:	58                   	pop    %eax
80100f21:	5a                   	pop    %edx
80100f22:	ff 75 0c             	push   0xc(%ebp)
80100f25:	ff 73 10             	push   0x10(%ebx)
80100f28:	e8 93 09 00 00       	call   801018c0 <stati>
    iunlock(f->ip);
80100f2d:	59                   	pop    %ecx
80100f2e:	ff 73 10             	push   0x10(%ebx)
80100f31:	e8 ae 07 00 00       	call   801016e4 <iunlock>
    return 0;
80100f36:	83 c4 10             	add    $0x10,%esp
80100f39:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f3e:	c9                   	leave
80100f3f:	c3                   	ret
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave
80100f49:	c3                   	ret
80100f4a:	66 90                	xchg   %ax,%ax

80100f4c <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f4c:	55                   	push   %ebp
80100f4d:	89 e5                	mov    %esp,%ebp
80100f4f:	57                   	push   %edi
80100f50:	56                   	push   %esi
80100f51:	53                   	push   %ebx
80100f52:	83 ec 1c             	sub    $0x1c,%esp
80100f55:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f58:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5b:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f5e:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f62:	74 60                	je     80100fc4 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f64:	8b 03                	mov    (%ebx),%eax
80100f66:	83 f8 01             	cmp    $0x1,%eax
80100f69:	74 45                	je     80100fb0 <fileread+0x64>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6b:	83 f8 02             	cmp    $0x2,%eax
80100f6e:	75 5b                	jne    80100fcb <fileread+0x7f>
    ilock(f->ip);
80100f70:	83 ec 0c             	sub    $0xc,%esp
80100f73:	ff 73 10             	push   0x10(%ebx)
80100f76:	e8 a1 06 00 00       	call   8010161c <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7b:	57                   	push   %edi
80100f7c:	ff 73 14             	push   0x14(%ebx)
80100f7f:	56                   	push   %esi
80100f80:	ff 73 10             	push   0x10(%ebx)
80100f83:	e8 64 09 00 00       	call   801018ec <readi>
80100f88:	83 c4 20             	add    $0x20,%esp
80100f8b:	85 c0                	test   %eax,%eax
80100f8d:	7e 03                	jle    80100f92 <fileread+0x46>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
80100f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iunlock(f->ip);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	ff 73 10             	push   0x10(%ebx)
80100f9b:	e8 44 07 00 00       	call   801016e4 <iunlock>
    return r;
80100fa0:	83 c4 10             	add    $0x10,%esp
80100fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa9:	5b                   	pop    %ebx
80100faa:	5e                   	pop    %esi
80100fab:	5f                   	pop    %edi
80100fac:	5d                   	pop    %ebp
80100fad:	c3                   	ret
80100fae:	66 90                	xchg   %ax,%ax
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fbd:	e9 3a 23 00 00       	jmp    801032fc <piperead>
80100fc2:	66 90                	xchg   %ax,%ax
    return -1;
80100fc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc9:	eb db                	jmp    80100fa6 <fileread+0x5a>
  panic("fileread");
80100fcb:	83 ec 0c             	sub    $0xc,%esp
80100fce:	68 95 6b 10 80       	push   $0x80106b95
80100fd3:	e8 60 f3 ff ff       	call   80100338 <panic>

80100fd8 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd8:	55                   	push   %ebp
80100fd9:	89 e5                	mov    %esp,%ebp
80100fdb:	57                   	push   %edi
80100fdc:	56                   	push   %esi
80100fdd:	53                   	push   %ebx
80100fde:	83 ec 1c             	sub    $0x1c,%esp
80100fe1:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
80100fe7:	8b 45 10             	mov    0x10(%ebp),%eax
80100fea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fed:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100ff1:	0f 84 ba 00 00 00    	je     801010b1 <filewrite+0xd9>
    return -1;
  if(f->type == FD_PIPE)
80100ff7:	8b 07                	mov    (%edi),%eax
80100ff9:	83 f8 01             	cmp    $0x1,%eax
80100ffc:	0f 84 be 00 00 00    	je     801010c0 <filewrite+0xe8>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101002:	83 f8 02             	cmp    $0x2,%eax
80101005:	0f 85 c7 00 00 00    	jne    801010d2 <filewrite+0xfa>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
8010100b:	31 db                	xor    %ebx,%ebx
    while(i < n){
8010100d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101010:	85 c0                	test   %eax,%eax
80101012:	0f 8e 94 00 00 00    	jle    801010ac <filewrite+0xd4>
    int i = 0;
80101018:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010101b:	eb 28                	jmp    80101045 <filewrite+0x6d>
8010101d:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101020:	01 47 14             	add    %eax,0x14(%edi)
80101023:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	51                   	push   %ecx
8010102a:	e8 b5 06 00 00       	call   801016e4 <iunlock>
      end_op();
8010102f:	e8 90 1a 00 00       	call   80102ac4 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101034:	83 c4 10             	add    $0x10,%esp
80101037:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010103a:	39 f0                	cmp    %esi,%eax
8010103c:	75 60                	jne    8010109e <filewrite+0xc6>
        panic("short filewrite");
      i += r;
8010103e:	01 f3                	add    %esi,%ebx
    while(i < n){
80101040:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80101043:	7e 67                	jle    801010ac <filewrite+0xd4>
      int n1 = n - i;
80101045:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101048:	29 de                	sub    %ebx,%esi
      if(n1 > max)
8010104a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101050:	7e 05                	jle    80101057 <filewrite+0x7f>
80101052:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
80101057:	e8 00 1a 00 00       	call   80102a5c <begin_op>
      ilock(f->ip);
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	ff 77 10             	push   0x10(%edi)
80101062:	e8 b5 05 00 00       	call   8010161c <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101067:	56                   	push   %esi
80101068:	ff 77 14             	push   0x14(%edi)
8010106b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010106e:	01 d8                	add    %ebx,%eax
80101070:	50                   	push   %eax
80101071:	ff 77 10             	push   0x10(%edi)
80101074:	e8 73 09 00 00       	call   801019ec <writei>
      iunlock(f->ip);
80101079:	8b 4f 10             	mov    0x10(%edi),%ecx
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	85 c0                	test   %eax,%eax
80101081:	7f 9d                	jg     80101020 <filewrite+0x48>
      iunlock(f->ip);
80101083:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	51                   	push   %ecx
8010108a:	e8 55 06 00 00       	call   801016e4 <iunlock>
      end_op();
8010108f:	e8 30 1a 00 00       	call   80102ac4 <end_op>
      if(r < 0)
80101094:	83 c4 10             	add    $0x10,%esp
80101097:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109a:	85 c0                	test   %eax,%eax
8010109c:	75 0e                	jne    801010ac <filewrite+0xd4>
        panic("short filewrite");
8010109e:	83 ec 0c             	sub    $0xc,%esp
801010a1:	68 9e 6b 10 80       	push   $0x80106b9e
801010a6:	e8 8d f2 ff ff       	call   80100338 <panic>
801010ab:	90                   	nop
    }
    return i == n ? n : -1;
801010ac:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801010af:	74 05                	je     801010b6 <filewrite+0xde>
    return -1;
801010b1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  panic("filewrite");
}
801010b6:	89 d8                	mov    %ebx,%eax
801010b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010bb:	5b                   	pop    %ebx
801010bc:	5e                   	pop    %esi
801010bd:	5f                   	pop    %edi
801010be:	5d                   	pop    %ebp
801010bf:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801010c0:	8b 47 0c             	mov    0xc(%edi),%eax
801010c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	5b                   	pop    %ebx
801010ca:	5e                   	pop    %esi
801010cb:	5f                   	pop    %edi
801010cc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010cd:	e9 22 21 00 00       	jmp    801031f4 <pipewrite>
  panic("filewrite");
801010d2:	83 ec 0c             	sub    $0xc,%esp
801010d5:	68 a4 6b 10 80       	push   $0x80106ba4
801010da:	e8 59 f2 ff ff       	call   80100338 <panic>
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
801010e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010ec:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	74 7f                	je     80101175 <balloc+0x95>
801010f6:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801010f8:	83 ec 08             	sub    $0x8,%esp
801010fb:	89 f8                	mov    %edi,%eax
801010fd:	c1 f8 0c             	sar    $0xc,%eax
80101100:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101106:	50                   	push   %eax
80101107:	ff 75 dc             	push   -0x24(%ebp)
8010110a:	e8 a5 ef ff ff       	call   801000b4 <bread>
8010110f:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101111:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101116:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101119:	89 fe                	mov    %edi,%esi
8010111b:	83 c4 10             	add    $0x10,%esp
8010111e:	31 c0                	xor    %eax,%eax
80101120:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101123:	eb 2c                	jmp    80101151 <balloc+0x71>
80101125:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101128:	89 c1                	mov    %eax,%ecx
8010112a:	83 e1 07             	and    $0x7,%ecx
8010112d:	ba 01 00 00 00       	mov    $0x1,%edx
80101132:	d3 e2                	shl    %cl,%edx
80101134:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	89 c1                	mov    %eax,%ecx
80101139:	c1 f9 03             	sar    $0x3,%ecx
8010113c:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101141:	89 fa                	mov    %edi,%edx
80101143:	85 7d e4             	test   %edi,-0x1c(%ebp)
80101146:	74 3c                	je     80101184 <balloc+0xa4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	40                   	inc    %eax
80101149:	46                   	inc    %esi
8010114a:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010114f:	74 07                	je     80101158 <balloc+0x78>
80101151:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101154:	39 fe                	cmp    %edi,%esi
80101156:	72 d0                	jb     80101128 <balloc+0x48>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101158:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	53                   	push   %ebx
8010115f:	e8 58 f0 ff ff       	call   801001bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101164:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010116a:	83 c4 10             	add    $0x10,%esp
8010116d:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101173:	72 83                	jb     801010f8 <balloc+0x18>
  }
  panic("balloc: out of blocks");
80101175:	83 ec 0c             	sub    $0xc,%esp
80101178:	68 ae 6b 10 80       	push   $0x80106bae
8010117d:	e8 b6 f1 ff ff       	call   80100338 <panic>
80101182:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101184:	0b 55 e4             	or     -0x1c(%ebp),%edx
80101187:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
8010118b:	83 ec 0c             	sub    $0xc,%esp
8010118e:	53                   	push   %ebx
8010118f:	e8 84 1a 00 00       	call   80102c18 <log_write>
        brelse(bp);
80101194:	89 1c 24             	mov    %ebx,(%esp)
80101197:	e8 20 f0 ff ff       	call   801001bc <brelse>
  bp = bread(dev, bno);
8010119c:	58                   	pop    %eax
8010119d:	5a                   	pop    %edx
8010119e:	56                   	push   %esi
8010119f:	ff 75 dc             	push   -0x24(%ebp)
801011a2:	e8 0d ef ff ff       	call   801000b4 <bread>
801011a7:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011a9:	83 c4 0c             	add    $0xc,%esp
801011ac:	68 00 02 00 00       	push   $0x200
801011b1:	6a 00                	push   $0x0
801011b3:	8d 40 5c             	lea    0x5c(%eax),%eax
801011b6:	50                   	push   %eax
801011b7:	e8 7c 31 00 00       	call   80104338 <memset>
  log_write(bp);
801011bc:	89 1c 24             	mov    %ebx,(%esp)
801011bf:	e8 54 1a 00 00       	call   80102c18 <log_write>
  brelse(bp);
801011c4:	89 1c 24             	mov    %ebx,(%esp)
801011c7:	e8 f0 ef ff ff       	call   801001bc <brelse>
}
801011cc:	89 f0                	mov    %esi,%eax
801011ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d1:	5b                   	pop    %ebx
801011d2:	5e                   	pop    %esi
801011d3:	5f                   	pop    %edi
801011d4:	5d                   	pop    %ebp
801011d5:	c3                   	ret
801011d6:	66 90                	xchg   %ax,%ax

801011d8 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011d8:	55                   	push   %ebp
801011d9:	89 e5                	mov    %esp,%ebp
801011db:	57                   	push   %edi
801011dc:	56                   	push   %esi
801011dd:	53                   	push   %ebx
801011de:	83 ec 28             	sub    $0x28,%esp
801011e1:	89 c6                	mov    %eax,%esi
801011e3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011e6:	68 60 f9 10 80       	push   $0x8010f960
801011eb:	e8 7c 30 00 00       	call   8010426c <acquire>
801011f0:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801011f3:	31 ff                	xor    %edi,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011f5:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
801011fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801011fd:	eb 13                	jmp    80101212 <iget+0x3a>
801011ff:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101200:	39 33                	cmp    %esi,(%ebx)
80101202:	74 64                	je     80101268 <iget+0x90>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101204:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010120a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101210:	74 22                	je     80101234 <iget+0x5c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101212:	8b 43 08             	mov    0x8(%ebx),%eax
80101215:	85 c0                	test   %eax,%eax
80101217:	7f e7                	jg     80101200 <iget+0x28>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101219:	85 ff                	test   %edi,%edi
8010121b:	75 e7                	jne    80101204 <iget+0x2c>
8010121d:	85 c0                	test   %eax,%eax
8010121f:	75 6c                	jne    8010128d <iget+0xb5>
      empty = ip;
80101221:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101223:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101229:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010122f:	75 e1                	jne    80101212 <iget+0x3a>
80101231:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101234:	85 ff                	test   %edi,%edi
80101236:	74 73                	je     801012ab <iget+0xd3>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101238:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
8010123a:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
8010123d:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80101244:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
8010124b:	83 ec 0c             	sub    $0xc,%esp
8010124e:	68 60 f9 10 80       	push   $0x8010f960
80101253:	e8 b4 2f 00 00       	call   8010420c <release>

  return ip;
80101258:	83 c4 10             	add    $0x10,%esp
}
8010125b:	89 f8                	mov    %edi,%eax
8010125d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101260:	5b                   	pop    %ebx
80101261:	5e                   	pop    %esi
80101262:	5f                   	pop    %edi
80101263:	5d                   	pop    %ebp
80101264:	c3                   	ret
80101265:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101268:	39 53 04             	cmp    %edx,0x4(%ebx)
8010126b:	75 97                	jne    80101204 <iget+0x2c>
      ip->ref++;
8010126d:	40                   	inc    %eax
8010126e:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101271:	83 ec 0c             	sub    $0xc,%esp
80101274:	68 60 f9 10 80       	push   $0x8010f960
80101279:	e8 8e 2f 00 00       	call   8010420c <release>
      return ip;
8010127e:	83 c4 10             	add    $0x10,%esp
80101281:	89 df                	mov    %ebx,%edi
}
80101283:	89 f8                	mov    %edi,%eax
80101285:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101288:	5b                   	pop    %ebx
80101289:	5e                   	pop    %esi
8010128a:	5f                   	pop    %edi
8010128b:	5d                   	pop    %ebp
8010128c:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101299:	74 10                	je     801012ab <iget+0xd3>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010129b:	8b 43 08             	mov    0x8(%ebx),%eax
8010129e:	85 c0                	test   %eax,%eax
801012a0:	0f 8f 5a ff ff ff    	jg     80101200 <iget+0x28>
801012a6:	e9 72 ff ff ff       	jmp    8010121d <iget+0x45>
    panic("iget: no inodes");
801012ab:	83 ec 0c             	sub    $0xc,%esp
801012ae:	68 c4 6b 10 80       	push   $0x80106bc4
801012b3:	e8 80 f0 ff ff       	call   80100338 <panic>

801012b8 <bfree>:
{
801012b8:	55                   	push   %ebp
801012b9:	89 e5                	mov    %esp,%ebp
801012bb:	56                   	push   %esi
801012bc:	53                   	push   %ebx
801012bd:	89 c1                	mov    %eax,%ecx
801012bf:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801012c1:	83 ec 08             	sub    $0x8,%esp
801012c4:	89 d0                	mov    %edx,%eax
801012c6:	c1 e8 0c             	shr    $0xc,%eax
801012c9:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801012cf:	50                   	push   %eax
801012d0:	51                   	push   %ecx
801012d1:	e8 de ed ff ff       	call   801000b4 <bread>
801012d6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012d8:	89 d9                	mov    %ebx,%ecx
801012da:	83 e1 07             	and    $0x7,%ecx
801012dd:	b8 01 00 00 00       	mov    $0x1,%eax
801012e2:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012e4:	c1 fb 03             	sar    $0x3,%ebx
801012e7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801012ed:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801012f2:	83 c4 10             	add    $0x10,%esp
801012f5:	85 c1                	test   %eax,%ecx
801012f7:	74 23                	je     8010131c <bfree+0x64>
  bp->data[bi/8] &= ~m;
801012f9:	f7 d0                	not    %eax
801012fb:	21 c8                	and    %ecx,%eax
801012fd:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	56                   	push   %esi
80101305:	e8 0e 19 00 00       	call   80102c18 <log_write>
  brelse(bp);
8010130a:	89 34 24             	mov    %esi,(%esp)
8010130d:	e8 aa ee ff ff       	call   801001bc <brelse>
}
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101318:	5b                   	pop    %ebx
80101319:	5e                   	pop    %esi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
    panic("freeing free block");
8010131c:	83 ec 0c             	sub    $0xc,%esp
8010131f:	68 d4 6b 10 80       	push   $0x80106bd4
80101324:	e8 0f f0 ff ff       	call   80100338 <panic>
80101329:	8d 76 00             	lea    0x0(%esi),%esi

8010132c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8010132c:	55                   	push   %ebp
8010132d:	89 e5                	mov    %esp,%ebp
8010132f:	57                   	push   %edi
80101330:	56                   	push   %esi
80101331:	53                   	push   %ebx
80101332:	83 ec 1c             	sub    $0x1c,%esp
80101335:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101337:	83 fa 0b             	cmp    $0xb,%edx
8010133a:	76 7c                	jbe    801013b8 <bmap+0x8c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
8010133c:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010133f:	83 fb 7f             	cmp    $0x7f,%ebx
80101342:	0f 87 8e 00 00 00    	ja     801013d6 <bmap+0xaa>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101348:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010134e:	85 c0                	test   %eax,%eax
80101350:	74 56                	je     801013a8 <bmap+0x7c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101352:	83 ec 08             	sub    $0x8,%esp
80101355:	50                   	push   %eax
80101356:	ff 36                	push   (%esi)
80101358:	e8 57 ed ff ff       	call   801000b4 <bread>
8010135d:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010135f:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
80101363:	8b 03                	mov    (%ebx),%eax
80101365:	83 c4 10             	add    $0x10,%esp
80101368:	85 c0                	test   %eax,%eax
8010136a:	74 1c                	je     80101388 <bmap+0x5c>
8010136c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	57                   	push   %edi
80101373:	e8 44 ee ff ff       	call   801001bc <brelse>
80101378:	83 c4 10             	add    $0x10,%esp
8010137b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101381:	5b                   	pop    %ebx
80101382:	5e                   	pop    %esi
80101383:	5f                   	pop    %edi
80101384:	5d                   	pop    %ebp
80101385:	c3                   	ret
80101386:	66 90                	xchg   %ax,%ax
      a[bn] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 51 fd ff ff       	call   801010e0 <balloc>
8010138f:	89 03                	mov    %eax,(%ebx)
80101391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
80101394:	83 ec 0c             	sub    $0xc,%esp
80101397:	57                   	push   %edi
80101398:	e8 7b 18 00 00       	call   80102c18 <log_write>
8010139d:	83 c4 10             	add    $0x10,%esp
801013a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801013a3:	eb c7                	jmp    8010136c <bmap+0x40>
801013a5:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	e8 31 fd ff ff       	call   801010e0 <balloc>
801013af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013b5:	eb 9b                	jmp    80101352 <bmap+0x26>
801013b7:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801013b8:	8d 5a 14             	lea    0x14(%edx),%ebx
801013bb:	8b 44 98 0c          	mov    0xc(%eax,%ebx,4),%eax
801013bf:	85 c0                	test   %eax,%eax
801013c1:	75 bb                	jne    8010137e <bmap+0x52>
      ip->addrs[bn] = addr = balloc(ip->dev);
801013c3:	8b 06                	mov    (%esi),%eax
801013c5:	e8 16 fd ff ff       	call   801010e0 <balloc>
801013ca:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
}
801013ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d1:	5b                   	pop    %ebx
801013d2:	5e                   	pop    %esi
801013d3:	5f                   	pop    %edi
801013d4:	5d                   	pop    %ebp
801013d5:	c3                   	ret
  panic("bmap: out of range");
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	68 e7 6b 10 80       	push   $0x80106be7
801013de:	e8 55 ef ff ff       	call   80100338 <panic>
801013e3:	90                   	nop

801013e4 <readsb>:
{
801013e4:	55                   	push   %ebp
801013e5:	89 e5                	mov    %esp,%ebp
801013e7:	56                   	push   %esi
801013e8:	53                   	push   %ebx
801013e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013ec:	83 ec 08             	sub    $0x8,%esp
801013ef:	6a 01                	push   $0x1
801013f1:	ff 75 08             	push   0x8(%ebp)
801013f4:	e8 bb ec ff ff       	call   801000b4 <bread>
801013f9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013fb:	83 c4 0c             	add    $0xc,%esp
801013fe:	6a 1c                	push   $0x1c
80101400:	8d 40 5c             	lea    0x5c(%eax),%eax
80101403:	50                   	push   %eax
80101404:	56                   	push   %esi
80101405:	e8 aa 2f 00 00       	call   801043b4 <memmove>
  brelse(bp);
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101410:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101413:	5b                   	pop    %ebx
80101414:	5e                   	pop    %esi
80101415:	5d                   	pop    %ebp
  brelse(bp);
80101416:	e9 a1 ed ff ff       	jmp    801001bc <brelse>
8010141b:	90                   	nop

8010141c <iinit>:
{
8010141c:	55                   	push   %ebp
8010141d:	89 e5                	mov    %esp,%ebp
8010141f:	53                   	push   %ebx
80101420:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101423:	68 fa 6b 10 80       	push   $0x80106bfa
80101428:	68 60 f9 10 80       	push   $0x8010f960
8010142d:	e8 72 2c 00 00       	call   801040a4 <initlock>
  for(i = 0; i < NINODE; i++) {
80101432:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101437:	83 c4 10             	add    $0x10,%esp
8010143a:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
8010143c:	83 ec 08             	sub    $0x8,%esp
8010143f:	68 01 6c 10 80       	push   $0x80106c01
80101444:	53                   	push   %ebx
80101445:	e8 4e 2b 00 00       	call   80103f98 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010144a:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101450:	83 c4 10             	add    $0x10,%esp
80101453:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
80101459:	75 e1                	jne    8010143c <iinit+0x20>
  bp = bread(dev, 1);
8010145b:	83 ec 08             	sub    $0x8,%esp
8010145e:	6a 01                	push   $0x1
80101460:	ff 75 08             	push   0x8(%ebp)
80101463:	e8 4c ec ff ff       	call   801000b4 <bread>
80101468:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010146a:	83 c4 0c             	add    $0xc,%esp
8010146d:	6a 1c                	push   $0x1c
8010146f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101472:	50                   	push   %eax
80101473:	68 b4 15 11 80       	push   $0x801115b4
80101478:	e8 37 2f 00 00       	call   801043b4 <memmove>
  brelse(bp);
8010147d:	89 1c 24             	mov    %ebx,(%esp)
80101480:	e8 37 ed ff ff       	call   801001bc <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101485:	ff 35 cc 15 11 80    	push   0x801115cc
8010148b:	ff 35 c8 15 11 80    	push   0x801115c8
80101491:	ff 35 c4 15 11 80    	push   0x801115c4
80101497:	ff 35 c0 15 11 80    	push   0x801115c0
8010149d:	ff 35 bc 15 11 80    	push   0x801115bc
801014a3:	ff 35 b8 15 11 80    	push   0x801115b8
801014a9:	ff 35 b4 15 11 80    	push   0x801115b4
801014af:	68 c8 70 10 80       	push   $0x801070c8
801014b4:	e8 67 f1 ff ff       	call   80100620 <cprintf>
}
801014b9:	83 c4 30             	add    $0x30,%esp
801014bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014bf:	c9                   	leave
801014c0:	c3                   	ret
801014c1:	8d 76 00             	lea    0x0(%esi),%esi

801014c4 <ialloc>:
{
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	57                   	push   %edi
801014c8:	56                   	push   %esi
801014c9:	53                   	push   %ebx
801014ca:	83 ec 1c             	sub    $0x1c,%esp
801014cd:	8b 75 08             	mov    0x8(%ebp),%esi
801014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801014d6:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
801014dd:	0f 86 84 00 00 00    	jbe    80101567 <ialloc+0xa3>
801014e3:	bf 01 00 00 00       	mov    $0x1,%edi
801014e8:	eb 17                	jmp    80101501 <ialloc+0x3d>
801014ea:	66 90                	xchg   %ax,%ax
    brelse(bp);
801014ec:	83 ec 0c             	sub    $0xc,%esp
801014ef:	53                   	push   %ebx
801014f0:	e8 c7 ec ff ff       	call   801001bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801014f5:	47                   	inc    %edi
801014f6:	83 c4 10             	add    $0x10,%esp
801014f9:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801014ff:	73 66                	jae    80101567 <ialloc+0xa3>
    bp = bread(dev, IBLOCK(inum, sb));
80101501:	83 ec 08             	sub    $0x8,%esp
80101504:	89 f8                	mov    %edi,%eax
80101506:	c1 e8 03             	shr    $0x3,%eax
80101509:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010150f:	50                   	push   %eax
80101510:	56                   	push   %esi
80101511:	e8 9e eb ff ff       	call   801000b4 <bread>
80101516:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101518:	89 f8                	mov    %edi,%eax
8010151a:	83 e0 07             	and    $0x7,%eax
8010151d:	c1 e0 06             	shl    $0x6,%eax
80101520:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101524:	83 c4 10             	add    $0x10,%esp
80101527:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010152b:	75 bf                	jne    801014ec <ialloc+0x28>
      memset(dip, 0, sizeof(*dip));
8010152d:	50                   	push   %eax
8010152e:	6a 40                	push   $0x40
80101530:	6a 00                	push   $0x0
80101532:	51                   	push   %ecx
80101533:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101536:	e8 fd 2d 00 00       	call   80104338 <memset>
      dip->type = type;
8010153b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010153e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101541:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101544:	89 1c 24             	mov    %ebx,(%esp)
80101547:	e8 cc 16 00 00       	call   80102c18 <log_write>
      brelse(bp);
8010154c:	89 1c 24             	mov    %ebx,(%esp)
8010154f:	e8 68 ec ff ff       	call   801001bc <brelse>
      return iget(dev, inum);
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	89 fa                	mov    %edi,%edx
80101559:	89 f0                	mov    %esi,%eax
}
8010155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155e:	5b                   	pop    %ebx
8010155f:	5e                   	pop    %esi
80101560:	5f                   	pop    %edi
80101561:	5d                   	pop    %ebp
      return iget(dev, inum);
80101562:	e9 71 fc ff ff       	jmp    801011d8 <iget>
  panic("ialloc: no inodes");
80101567:	83 ec 0c             	sub    $0xc,%esp
8010156a:	68 07 6c 10 80       	push   $0x80106c07
8010156f:	e8 c4 ed ff ff       	call   80100338 <panic>

80101574 <iupdate>:
{
80101574:	55                   	push   %ebp
80101575:	89 e5                	mov    %esp,%ebp
80101577:	56                   	push   %esi
80101578:	53                   	push   %ebx
80101579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010157c:	83 ec 08             	sub    $0x8,%esp
8010157f:	8b 43 04             	mov    0x4(%ebx),%eax
80101582:	c1 e8 03             	shr    $0x3,%eax
80101585:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010158b:	50                   	push   %eax
8010158c:	ff 33                	push   (%ebx)
8010158e:	e8 21 eb ff ff       	call   801000b4 <bread>
80101593:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101595:	8b 43 04             	mov    0x4(%ebx),%eax
80101598:	83 e0 07             	and    $0x7,%eax
8010159b:	c1 e0 06             	shl    $0x6,%eax
8010159e:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015a2:	8b 53 50             	mov    0x50(%ebx),%edx
801015a5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015a8:	66 8b 53 52          	mov    0x52(%ebx),%dx
801015ac:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801015b0:	8b 53 54             	mov    0x54(%ebx),%edx
801015b3:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801015b7:	66 8b 53 56          	mov    0x56(%ebx),%dx
801015bb:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801015bf:	8b 53 58             	mov    0x58(%ebx),%edx
801015c2:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015c5:	83 c4 0c             	add    $0xc,%esp
801015c8:	6a 34                	push   $0x34
801015ca:	83 c3 5c             	add    $0x5c,%ebx
801015cd:	53                   	push   %ebx
801015ce:	83 c0 0c             	add    $0xc,%eax
801015d1:	50                   	push   %eax
801015d2:	e8 dd 2d 00 00       	call   801043b4 <memmove>
  log_write(bp);
801015d7:	89 34 24             	mov    %esi,(%esp)
801015da:	e8 39 16 00 00       	call   80102c18 <log_write>
  brelse(bp);
801015df:	83 c4 10             	add    $0x10,%esp
801015e2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801015e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e8:	5b                   	pop    %ebx
801015e9:	5e                   	pop    %esi
801015ea:	5d                   	pop    %ebp
  brelse(bp);
801015eb:	e9 cc eb ff ff       	jmp    801001bc <brelse>

801015f0 <idup>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	53                   	push   %ebx
801015f4:	83 ec 10             	sub    $0x10,%esp
801015f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015fa:	68 60 f9 10 80       	push   $0x8010f960
801015ff:	e8 68 2c 00 00       	call   8010426c <acquire>
  ip->ref++;
80101604:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
80101607:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010160e:	e8 f9 2b 00 00       	call   8010420c <release>
}
80101613:	89 d8                	mov    %ebx,%eax
80101615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101618:	c9                   	leave
80101619:	c3                   	ret
8010161a:	66 90                	xchg   %ax,%ax

8010161c <ilock>:
{
8010161c:	55                   	push   %ebp
8010161d:	89 e5                	mov    %esp,%ebp
8010161f:	56                   	push   %esi
80101620:	53                   	push   %ebx
80101621:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101624:	85 db                	test   %ebx,%ebx
80101626:	0f 84 a9 00 00 00    	je     801016d5 <ilock+0xb9>
8010162c:	8b 53 08             	mov    0x8(%ebx),%edx
8010162f:	85 d2                	test   %edx,%edx
80101631:	0f 8e 9e 00 00 00    	jle    801016d5 <ilock+0xb9>
  acquiresleep(&ip->lock);
80101637:	83 ec 0c             	sub    $0xc,%esp
8010163a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010163d:	50                   	push   %eax
8010163e:	e8 89 29 00 00       	call   80103fcc <acquiresleep>
  if(ip->valid == 0){
80101643:	83 c4 10             	add    $0x10,%esp
80101646:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101649:	85 c0                	test   %eax,%eax
8010164b:	74 07                	je     80101654 <ilock+0x38>
}
8010164d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101650:	5b                   	pop    %ebx
80101651:	5e                   	pop    %esi
80101652:	5d                   	pop    %ebp
80101653:	c3                   	ret
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101654:	83 ec 08             	sub    $0x8,%esp
80101657:	8b 43 04             	mov    0x4(%ebx),%eax
8010165a:	c1 e8 03             	shr    $0x3,%eax
8010165d:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101663:	50                   	push   %eax
80101664:	ff 33                	push   (%ebx)
80101666:	e8 49 ea ff ff       	call   801000b4 <bread>
8010166b:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010166d:	8b 43 04             	mov    0x4(%ebx),%eax
80101670:	83 e0 07             	and    $0x7,%eax
80101673:	c1 e0 06             	shl    $0x6,%eax
80101676:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010167a:	8b 10                	mov    (%eax),%edx
8010167c:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101680:	66 8b 50 02          	mov    0x2(%eax),%dx
80101684:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101688:	8b 50 04             	mov    0x4(%eax),%edx
8010168b:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010168f:	66 8b 50 06          	mov    0x6(%eax),%dx
80101693:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101697:	8b 50 08             	mov    0x8(%eax),%edx
8010169a:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010169d:	83 c4 0c             	add    $0xc,%esp
801016a0:	6a 34                	push   $0x34
801016a2:	83 c0 0c             	add    $0xc,%eax
801016a5:	50                   	push   %eax
801016a6:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016a9:	50                   	push   %eax
801016aa:	e8 05 2d 00 00       	call   801043b4 <memmove>
    brelse(bp);
801016af:	89 34 24             	mov    %esi,(%esp)
801016b2:	e8 05 eb ff ff       	call   801001bc <brelse>
    ip->valid = 1;
801016b7:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801016be:	83 c4 10             	add    $0x10,%esp
801016c1:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801016c6:	75 85                	jne    8010164d <ilock+0x31>
      panic("ilock: no type");
801016c8:	83 ec 0c             	sub    $0xc,%esp
801016cb:	68 1f 6c 10 80       	push   $0x80106c1f
801016d0:	e8 63 ec ff ff       	call   80100338 <panic>
    panic("ilock");
801016d5:	83 ec 0c             	sub    $0xc,%esp
801016d8:	68 19 6c 10 80       	push   $0x80106c19
801016dd:	e8 56 ec ff ff       	call   80100338 <panic>
801016e2:	66 90                	xchg   %ax,%ax

801016e4 <iunlock>:
{
801016e4:	55                   	push   %ebp
801016e5:	89 e5                	mov    %esp,%ebp
801016e7:	56                   	push   %esi
801016e8:	53                   	push   %ebx
801016e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801016ec:	85 db                	test   %ebx,%ebx
801016ee:	74 28                	je     80101718 <iunlock+0x34>
801016f0:	8d 73 0c             	lea    0xc(%ebx),%esi
801016f3:	83 ec 0c             	sub    $0xc,%esp
801016f6:	56                   	push   %esi
801016f7:	e8 60 29 00 00       	call   8010405c <holdingsleep>
801016fc:	83 c4 10             	add    $0x10,%esp
801016ff:	85 c0                	test   %eax,%eax
80101701:	74 15                	je     80101718 <iunlock+0x34>
80101703:	8b 43 08             	mov    0x8(%ebx),%eax
80101706:	85 c0                	test   %eax,%eax
80101708:	7e 0e                	jle    80101718 <iunlock+0x34>
  releasesleep(&ip->lock);
8010170a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010170d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101710:	5b                   	pop    %ebx
80101711:	5e                   	pop    %esi
80101712:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101713:	e9 08 29 00 00       	jmp    80104020 <releasesleep>
    panic("iunlock");
80101718:	83 ec 0c             	sub    $0xc,%esp
8010171b:	68 2e 6c 10 80       	push   $0x80106c2e
80101720:	e8 13 ec ff ff       	call   80100338 <panic>
80101725:	8d 76 00             	lea    0x0(%esi),%esi

80101728 <iput>:
{
80101728:	55                   	push   %ebp
80101729:	89 e5                	mov    %esp,%ebp
8010172b:	57                   	push   %edi
8010172c:	56                   	push   %esi
8010172d:	53                   	push   %ebx
8010172e:	83 ec 28             	sub    $0x28,%esp
80101731:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101734:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101737:	57                   	push   %edi
80101738:	e8 8f 28 00 00       	call   80103fcc <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010173d:	83 c4 10             	add    $0x10,%esp
80101740:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101743:	85 c0                	test   %eax,%eax
80101745:	74 07                	je     8010174e <iput+0x26>
80101747:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010174c:	74 2e                	je     8010177c <iput+0x54>
  releasesleep(&ip->lock);
8010174e:	83 ec 0c             	sub    $0xc,%esp
80101751:	57                   	push   %edi
80101752:	e8 c9 28 00 00       	call   80104020 <releasesleep>
  acquire(&icache.lock);
80101757:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010175e:	e8 09 2b 00 00       	call   8010426c <acquire>
  ip->ref--;
80101763:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
80101766:	83 c4 10             	add    $0x10,%esp
80101769:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101770:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101773:	5b                   	pop    %ebx
80101774:	5e                   	pop    %esi
80101775:	5f                   	pop    %edi
80101776:	5d                   	pop    %ebp
  release(&icache.lock);
80101777:	e9 90 2a 00 00       	jmp    8010420c <release>
    acquire(&icache.lock);
8010177c:	83 ec 0c             	sub    $0xc,%esp
8010177f:	68 60 f9 10 80       	push   $0x8010f960
80101784:	e8 e3 2a 00 00       	call   8010426c <acquire>
    int r = ip->ref;
80101789:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
8010178c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101793:	e8 74 2a 00 00       	call   8010420c <release>
    if(r == 1){
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	4e                   	dec    %esi
8010179c:	75 b0                	jne    8010174e <iput+0x26>
8010179e:	8d 73 5c             	lea    0x5c(%ebx),%esi
801017a1:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801017a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801017aa:	89 df                	mov    %ebx,%edi
801017ac:	89 cb                	mov    %ecx,%ebx
801017ae:	eb 07                	jmp    801017b7 <iput+0x8f>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017b0:	83 c6 04             	add    $0x4,%esi
801017b3:	39 de                	cmp    %ebx,%esi
801017b5:	74 15                	je     801017cc <iput+0xa4>
    if(ip->addrs[i]){
801017b7:	8b 16                	mov    (%esi),%edx
801017b9:	85 d2                	test   %edx,%edx
801017bb:	74 f3                	je     801017b0 <iput+0x88>
      bfree(ip->dev, ip->addrs[i]);
801017bd:	8b 07                	mov    (%edi),%eax
801017bf:	e8 f4 fa ff ff       	call   801012b8 <bfree>
      ip->addrs[i] = 0;
801017c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801017ca:	eb e4                	jmp    801017b0 <iput+0x88>
    }
  }

  if(ip->addrs[NDIRECT]){
801017cc:	89 fb                	mov    %edi,%ebx
801017ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801017d1:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801017d7:	85 c0                	test   %eax,%eax
801017d9:	75 2d                	jne    80101808 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801017db:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801017e2:	83 ec 0c             	sub    $0xc,%esp
801017e5:	53                   	push   %ebx
801017e6:	e8 89 fd ff ff       	call   80101574 <iupdate>
      ip->type = 0;
801017eb:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801017f1:	89 1c 24             	mov    %ebx,(%esp)
801017f4:	e8 7b fd ff ff       	call   80101574 <iupdate>
      ip->valid = 0;
801017f9:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101800:	83 c4 10             	add    $0x10,%esp
80101803:	e9 46 ff ff ff       	jmp    8010174e <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101808:	83 ec 08             	sub    $0x8,%esp
8010180b:	50                   	push   %eax
8010180c:	ff 33                	push   (%ebx)
8010180e:	e8 a1 e8 ff ff       	call   801000b4 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101813:	8d 70 5c             	lea    0x5c(%eax),%esi
80101816:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010181c:	83 c4 10             	add    $0x10,%esp
8010181f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101822:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101825:	89 cf                	mov    %ecx,%edi
80101827:	eb 0a                	jmp    80101833 <iput+0x10b>
80101829:	8d 76 00             	lea    0x0(%esi),%esi
8010182c:	83 c6 04             	add    $0x4,%esi
8010182f:	39 fe                	cmp    %edi,%esi
80101831:	74 0f                	je     80101842 <iput+0x11a>
      if(a[j])
80101833:	8b 16                	mov    (%esi),%edx
80101835:	85 d2                	test   %edx,%edx
80101837:	74 f3                	je     8010182c <iput+0x104>
        bfree(ip->dev, a[j]);
80101839:	8b 03                	mov    (%ebx),%eax
8010183b:	e8 78 fa ff ff       	call   801012b8 <bfree>
80101840:	eb ea                	jmp    8010182c <iput+0x104>
    brelse(bp);
80101842:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101845:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	50                   	push   %eax
8010184c:	e8 6b e9 ff ff       	call   801001bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101851:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101857:	8b 03                	mov    (%ebx),%eax
80101859:	e8 5a fa ff ff       	call   801012b8 <bfree>
    ip->addrs[NDIRECT] = 0;
8010185e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101865:	00 00 00 
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	e9 6b ff ff ff       	jmp    801017db <iput+0xb3>

80101870 <iunlockput>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 34                	je     801018b0 <iunlockput+0x40>
8010187c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010187f:	83 ec 0c             	sub    $0xc,%esp
80101882:	56                   	push   %esi
80101883:	e8 d4 27 00 00       	call   8010405c <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 21                	je     801018b0 <iunlockput+0x40>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 1a                	jle    801018b0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	56                   	push   %esi
8010189a:	e8 81 27 00 00       	call   80104020 <releasesleep>
  iput(ip);
8010189f:	83 c4 10             	add    $0x10,%esp
801018a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801018a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a8:	5b                   	pop    %ebx
801018a9:	5e                   	pop    %esi
801018aa:	5d                   	pop    %ebp
  iput(ip);
801018ab:	e9 78 fe ff ff       	jmp    80101728 <iput>
    panic("iunlock");
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	68 2e 6c 10 80       	push   $0x80106c2e
801018b8:	e8 7b ea ff ff       	call   80100338 <panic>
801018bd:	8d 76 00             	lea    0x0(%esi),%esi

801018c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	8b 55 08             	mov    0x8(%ebp),%edx
801018c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018c9:	8b 0a                	mov    (%edx),%ecx
801018cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801018d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801018d4:	8b 4a 50             	mov    0x50(%edx),%ecx
801018d7:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801018da:	66 8b 4a 56          	mov    0x56(%edx),%cx
801018de:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801018e2:	8b 52 58             	mov    0x58(%edx),%edx
801018e5:	89 50 10             	mov    %edx,0x10(%eax)
}
801018e8:	5d                   	pop    %ebp
801018e9:	c3                   	ret
801018ea:	66 90                	xchg   %ax,%ax

801018ec <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801018ec:	55                   	push   %ebp
801018ed:	89 e5                	mov    %esp,%ebp
801018ef:	57                   	push   %edi
801018f0:	56                   	push   %esi
801018f1:	53                   	push   %ebx
801018f2:	83 ec 1c             	sub    $0x1c,%esp
801018f5:	8b 45 08             	mov    0x8(%ebp),%eax
801018f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
801018fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801018fe:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101901:	8b 7d 10             	mov    0x10(%ebp),%edi
80101904:	8b 75 14             	mov    0x14(%ebp),%esi
80101907:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010190a:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010190f:	0f 84 af 00 00 00    	je     801019c4 <readi+0xd8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101915:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101918:	8b 50 58             	mov    0x58(%eax),%edx
8010191b:	39 fa                	cmp    %edi,%edx
8010191d:	0f 82 c2 00 00 00    	jb     801019e5 <readi+0xf9>
80101923:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101926:	31 c0                	xor    %eax,%eax
80101928:	01 f9                	add    %edi,%ecx
8010192a:	0f 92 c0             	setb   %al
8010192d:	89 c3                	mov    %eax,%ebx
8010192f:	0f 82 b0 00 00 00    	jb     801019e5 <readi+0xf9>
    return -1;
  if(off + n > ip->size)
80101935:	39 ca                	cmp    %ecx,%edx
80101937:	72 7f                	jb     801019b8 <readi+0xcc>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101939:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010193c:	85 f6                	test   %esi,%esi
8010193e:	74 6a                	je     801019aa <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101940:	89 de                	mov    %ebx,%esi
80101942:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101944:	89 fa                	mov    %edi,%edx
80101946:	c1 ea 09             	shr    $0x9,%edx
80101949:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010194c:	89 d8                	mov    %ebx,%eax
8010194e:	e8 d9 f9 ff ff       	call   8010132c <bmap>
80101953:	83 ec 08             	sub    $0x8,%esp
80101956:	50                   	push   %eax
80101957:	ff 33                	push   (%ebx)
80101959:	e8 56 e7 ff ff       	call   801000b4 <bread>
8010195e:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101960:	89 f8                	mov    %edi,%eax
80101962:	25 ff 01 00 00       	and    $0x1ff,%eax
80101967:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010196a:	29 f1                	sub    %esi,%ecx
8010196c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101971:	29 c3                	sub    %eax,%ebx
80101973:	83 c4 10             	add    $0x10,%esp
80101976:	39 d9                	cmp    %ebx,%ecx
80101978:	73 02                	jae    8010197c <readi+0x90>
8010197a:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010197c:	51                   	push   %ecx
8010197d:	53                   	push   %ebx
8010197e:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101982:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101985:	50                   	push   %eax
80101986:	ff 75 e0             	push   -0x20(%ebp)
80101989:	e8 26 2a 00 00       	call   801043b4 <memmove>
    brelse(bp);
8010198e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101991:	89 14 24             	mov    %edx,(%esp)
80101994:	e8 23 e8 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101999:	01 de                	add    %ebx,%esi
8010199b:	01 df                	add    %ebx,%edi
8010199d:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019a0:	83 c4 10             	add    $0x10,%esp
801019a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019a6:	39 c6                	cmp    %eax,%esi
801019a8:	72 9a                	jb     80101944 <readi+0x58>
  }
  return n;
801019aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b0:	5b                   	pop    %ebx
801019b1:	5e                   	pop    %esi
801019b2:	5f                   	pop    %edi
801019b3:	5d                   	pop    %ebp
801019b4:	c3                   	ret
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    n = ip->size - off;
801019b8:	29 fa                	sub    %edi,%edx
801019ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019bd:	e9 77 ff ff ff       	jmp    80101939 <readi+0x4d>
801019c2:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019c4:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019c8:	66 83 f8 09          	cmp    $0x9,%ax
801019cc:	77 17                	ja     801019e5 <readi+0xf9>
801019ce:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
801019d5:	85 c0                	test   %eax,%eax
801019d7:	74 0c                	je     801019e5 <readi+0xf9>
    return devsw[ip->major].read(ip, dst, n);
801019d9:	89 75 10             	mov    %esi,0x10(%ebp)
}
801019dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019df:	5b                   	pop    %ebx
801019e0:	5e                   	pop    %esi
801019e1:	5f                   	pop    %edi
801019e2:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801019e3:	ff e0                	jmp    *%eax
      return -1;
801019e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ea:	eb c1                	jmp    801019ad <readi+0xc1>

801019ec <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801019ec:	55                   	push   %ebp
801019ed:	89 e5                	mov    %esp,%ebp
801019ef:	57                   	push   %edi
801019f0:	56                   	push   %esi
801019f1:	53                   	push   %ebx
801019f2:	83 ec 1c             	sub    $0x1c,%esp
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801019fe:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a01:	8b 7d 10             	mov    0x10(%ebp),%edi
80101a04:	8b 75 14             	mov    0x14(%ebp),%esi
80101a07:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a0a:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a0f:	0f 84 b7 00 00 00    	je     80101acc <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a15:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a18:	39 78 58             	cmp    %edi,0x58(%eax)
80101a1b:	0f 82 e0 00 00 00    	jb     80101b01 <writei+0x115>
80101a21:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a24:	89 f2                	mov    %esi,%edx
80101a26:	31 c0                	xor    %eax,%eax
80101a28:	01 fa                	add    %edi,%edx
80101a2a:	0f 92 c0             	setb   %al
80101a2d:	0f 82 ce 00 00 00    	jb     80101b01 <writei+0x115>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a33:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101a39:	0f 87 c2 00 00 00    	ja     80101b01 <writei+0x115>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a3f:	85 f6                	test   %esi,%esi
80101a41:	74 7c                	je     80101abf <writei+0xd3>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a43:	89 c6                	mov    %eax,%esi
80101a45:	89 7d e0             	mov    %edi,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a48:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101a4b:	89 da                	mov    %ebx,%edx
80101a4d:	c1 ea 09             	shr    $0x9,%edx
80101a50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a53:	89 f8                	mov    %edi,%eax
80101a55:	e8 d2 f8 ff ff       	call   8010132c <bmap>
80101a5a:	83 ec 08             	sub    $0x8,%esp
80101a5d:	50                   	push   %eax
80101a5e:	ff 37                	push   (%edi)
80101a60:	e8 4f e6 ff ff       	call   801000b4 <bread>
80101a65:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a67:	89 d8                	mov    %ebx,%eax
80101a69:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a6e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a71:	29 f1                	sub    %esi,%ecx
80101a73:	bb 00 02 00 00       	mov    $0x200,%ebx
80101a78:	29 c3                	sub    %eax,%ebx
80101a7a:	83 c4 10             	add    $0x10,%esp
80101a7d:	39 d9                	cmp    %ebx,%ecx
80101a7f:	73 02                	jae    80101a83 <writei+0x97>
80101a81:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a83:	52                   	push   %edx
80101a84:	53                   	push   %ebx
80101a85:	ff 75 dc             	push   -0x24(%ebp)
80101a88:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101a8c:	50                   	push   %eax
80101a8d:	e8 22 29 00 00       	call   801043b4 <memmove>
    log_write(bp);
80101a92:	89 3c 24             	mov    %edi,(%esp)
80101a95:	e8 7e 11 00 00       	call   80102c18 <log_write>
    brelse(bp);
80101a9a:	89 3c 24             	mov    %edi,(%esp)
80101a9d:	e8 1a e7 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aa2:	01 de                	add    %ebx,%esi
80101aa4:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aa7:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ab0:	39 c6                	cmp    %eax,%esi
80101ab2:	72 94                	jb     80101a48 <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
80101ab4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aba:	39 78 58             	cmp    %edi,0x58(%eax)
80101abd:	72 31                	jb     80101af0 <writei+0x104>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac5:	5b                   	pop    %ebx
80101ac6:	5e                   	pop    %esi
80101ac7:	5f                   	pop    %edi
80101ac8:	5d                   	pop    %ebp
80101ac9:	c3                   	ret
80101aca:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101acc:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad0:	66 83 f8 09          	cmp    $0x9,%ax
80101ad4:	77 2b                	ja     80101b01 <writei+0x115>
80101ad6:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101add:	85 c0                	test   %eax,%eax
80101adf:	74 20                	je     80101b01 <writei+0x115>
    return devsw[ip->major].write(ip, src, n);
80101ae1:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ae4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae7:	5b                   	pop    %ebx
80101ae8:	5e                   	pop    %esi
80101ae9:	5f                   	pop    %edi
80101aea:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101aeb:	ff e0                	jmp    *%eax
80101aed:	8d 76 00             	lea    0x0(%esi),%esi
    ip->size = off;
80101af0:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101af3:	83 ec 0c             	sub    $0xc,%esp
80101af6:	50                   	push   %eax
80101af7:	e8 78 fa ff ff       	call   80101574 <iupdate>
80101afc:	83 c4 10             	add    $0x10,%esp
80101aff:	eb be                	jmp    80101abf <writei+0xd3>
      return -1;
80101b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b06:	eb ba                	jmp    80101ac2 <writei+0xd6>

80101b08 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b08:	55                   	push   %ebp
80101b09:	89 e5                	mov    %esp,%ebp
80101b0b:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b0e:	6a 0e                	push   $0xe
80101b10:	ff 75 0c             	push   0xc(%ebp)
80101b13:	ff 75 08             	push   0x8(%ebp)
80101b16:	e8 e5 28 00 00       	call   80104400 <strncmp>
}
80101b1b:	c9                   	leave
80101b1c:	c3                   	ret
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi

80101b20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b31:	75 7d                	jne    80101bb0 <dirlookup+0x90>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b33:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101b36:	85 c9                	test   %ecx,%ecx
80101b38:	74 3d                	je     80101b77 <dirlookup+0x57>
80101b3a:	31 ff                	xor    %edi,%edi
80101b3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b3f:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b40:	6a 10                	push   $0x10
80101b42:	57                   	push   %edi
80101b43:	56                   	push   %esi
80101b44:	53                   	push   %ebx
80101b45:	e8 a2 fd ff ff       	call   801018ec <readi>
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	83 f8 10             	cmp    $0x10,%eax
80101b50:	75 51                	jne    80101ba3 <dirlookup+0x83>
      panic("dirlookup read");
    if(de.inum == 0)
80101b52:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b57:	74 16                	je     80101b6f <dirlookup+0x4f>
  return strncmp(s, t, DIRSIZ);
80101b59:	52                   	push   %edx
80101b5a:	6a 0e                	push   $0xe
80101b5c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b5f:	50                   	push   %eax
80101b60:	ff 75 0c             	push   0xc(%ebp)
80101b63:	e8 98 28 00 00       	call   80104400 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	85 c0                	test   %eax,%eax
80101b6d:	74 15                	je     80101b84 <dirlookup+0x64>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b6f:	83 c7 10             	add    $0x10,%edi
80101b72:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101b75:	72 c9                	jb     80101b40 <dirlookup+0x20>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101b77:	31 c0                	xor    %eax,%eax
}
80101b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7c:	5b                   	pop    %ebx
80101b7d:	5e                   	pop    %esi
80101b7e:	5f                   	pop    %edi
80101b7f:	5d                   	pop    %ebp
80101b80:	c3                   	ret
80101b81:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101b84:	8b 45 10             	mov    0x10(%ebp),%eax
80101b87:	85 c0                	test   %eax,%eax
80101b89:	74 05                	je     80101b90 <dirlookup+0x70>
        *poff = off;
80101b8b:	8b 45 10             	mov    0x10(%ebp),%eax
80101b8e:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101b90:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101b94:	8b 03                	mov    (%ebx),%eax
80101b96:	e8 3d f6 ff ff       	call   801011d8 <iget>
}
80101b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9e:	5b                   	pop    %ebx
80101b9f:	5e                   	pop    %esi
80101ba0:	5f                   	pop    %edi
80101ba1:	5d                   	pop    %ebp
80101ba2:	c3                   	ret
      panic("dirlookup read");
80101ba3:	83 ec 0c             	sub    $0xc,%esp
80101ba6:	68 48 6c 10 80       	push   $0x80106c48
80101bab:	e8 88 e7 ff ff       	call   80100338 <panic>
    panic("dirlookup not DIR");
80101bb0:	83 ec 0c             	sub    $0xc,%esp
80101bb3:	68 36 6c 10 80       	push   $0x80106c36
80101bb8:	e8 7b e7 ff ff       	call   80100338 <panic>
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi

80101bc0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	89 c3                	mov    %eax,%ebx
80101bcb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101bce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101bd1:	80 38 2f             	cmpb   $0x2f,(%eax)
80101bd4:	0f 84 7c 01 00 00    	je     80101d56 <namex+0x196>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101bda:	e8 b9 19 00 00       	call   80103598 <myproc>
80101bdf:	8b 70 78             	mov    0x78(%eax),%esi
  acquire(&icache.lock);
80101be2:	83 ec 0c             	sub    $0xc,%esp
80101be5:	68 60 f9 10 80       	push   $0x8010f960
80101bea:	e8 7d 26 00 00       	call   8010426c <acquire>
  ip->ref++;
80101bef:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101bf2:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101bf9:	e8 0e 26 00 00       	call   8010420c <release>
80101bfe:	83 c4 10             	add    $0x10,%esp
80101c01:	eb 02                	jmp    80101c05 <namex+0x45>
80101c03:	90                   	nop
    path++;
80101c04:	43                   	inc    %ebx
  while(*path == '/')
80101c05:	8a 03                	mov    (%ebx),%al
80101c07:	3c 2f                	cmp    $0x2f,%al
80101c09:	74 f9                	je     80101c04 <namex+0x44>
  if(*path == 0)
80101c0b:	84 c0                	test   %al,%al
80101c0d:	0f 84 e9 00 00 00    	je     80101cfc <namex+0x13c>
  while(*path != '/' && *path != 0)
80101c13:	8a 03                	mov    (%ebx),%al
80101c15:	89 df                	mov    %ebx,%edi
80101c17:	3c 2f                	cmp    $0x2f,%al
80101c19:	75 0c                	jne    80101c27 <namex+0x67>
80101c1b:	e9 2f 01 00 00       	jmp    80101d4f <namex+0x18f>
    path++;
80101c20:	47                   	inc    %edi
  while(*path != '/' && *path != 0)
80101c21:	8a 07                	mov    (%edi),%al
80101c23:	3c 2f                	cmp    $0x2f,%al
80101c25:	74 04                	je     80101c2b <namex+0x6b>
80101c27:	84 c0                	test   %al,%al
80101c29:	75 f5                	jne    80101c20 <namex+0x60>
  len = path - s;
80101c2b:	89 f8                	mov    %edi,%eax
80101c2d:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101c2f:	83 f8 0d             	cmp    $0xd,%eax
80101c32:	0f 8e a0 00 00 00    	jle    80101cd8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101c38:	51                   	push   %ecx
80101c39:	6a 0e                	push   $0xe
80101c3b:	53                   	push   %ebx
80101c3c:	ff 75 e4             	push   -0x1c(%ebp)
80101c3f:	e8 70 27 00 00       	call   801043b4 <memmove>
80101c44:	83 c4 10             	add    $0x10,%esp
80101c47:	89 fb                	mov    %edi,%ebx
  while(*path == '/')
80101c49:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101c4c:	75 08                	jne    80101c56 <namex+0x96>
80101c4e:	66 90                	xchg   %ax,%ax
    path++;
80101c50:	43                   	inc    %ebx
  while(*path == '/')
80101c51:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101c54:	74 fa                	je     80101c50 <namex+0x90>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101c56:	83 ec 0c             	sub    $0xc,%esp
80101c59:	56                   	push   %esi
80101c5a:	e8 bd f9 ff ff       	call   8010161c <ilock>
    if(ip->type != T_DIR){
80101c5f:	83 c4 10             	add    $0x10,%esp
80101c62:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101c67:	0f 85 a4 00 00 00    	jne    80101d11 <namex+0x151>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101c6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c70:	85 c0                	test   %eax,%eax
80101c72:	74 09                	je     80101c7d <namex+0xbd>
80101c74:	80 3b 00             	cmpb   $0x0,(%ebx)
80101c77:	0f 84 ef 00 00 00    	je     80101d6c <namex+0x1ac>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101c7d:	50                   	push   %eax
80101c7e:	6a 00                	push   $0x0
80101c80:	ff 75 e4             	push   -0x1c(%ebp)
80101c83:	56                   	push   %esi
80101c84:	e8 97 fe ff ff       	call   80101b20 <dirlookup>
80101c89:	89 c7                	mov    %eax,%edi
80101c8b:	83 c4 10             	add    $0x10,%esp
80101c8e:	85 c0                	test   %eax,%eax
80101c90:	74 7f                	je     80101d11 <namex+0x151>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c92:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101c95:	83 ec 0c             	sub    $0xc,%esp
80101c98:	51                   	push   %ecx
80101c99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101c9c:	e8 bb 23 00 00       	call   8010405c <holdingsleep>
80101ca1:	83 c4 10             	add    $0x10,%esp
80101ca4:	85 c0                	test   %eax,%eax
80101ca6:	0f 84 00 01 00 00    	je     80101dac <namex+0x1ec>
80101cac:	8b 46 08             	mov    0x8(%esi),%eax
80101caf:	85 c0                	test   %eax,%eax
80101cb1:	0f 8e f5 00 00 00    	jle    80101dac <namex+0x1ec>
  releasesleep(&ip->lock);
80101cb7:	83 ec 0c             	sub    $0xc,%esp
80101cba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cbd:	51                   	push   %ecx
80101cbe:	e8 5d 23 00 00       	call   80104020 <releasesleep>
  iput(ip);
80101cc3:	89 34 24             	mov    %esi,(%esp)
80101cc6:	e8 5d fa ff ff       	call   80101728 <iput>
80101ccb:	83 c4 10             	add    $0x10,%esp
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101cce:	89 fe                	mov    %edi,%esi
  while(*path == '/')
80101cd0:	e9 30 ff ff ff       	jmp    80101c05 <namex+0x45>
80101cd5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101cd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cdb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101cde:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    memmove(name, s, len);
80101ce1:	52                   	push   %edx
80101ce2:	50                   	push   %eax
80101ce3:	53                   	push   %ebx
80101ce4:	ff 75 e4             	push   -0x1c(%ebp)
80101ce7:	e8 c8 26 00 00       	call   801043b4 <memmove>
    name[len] = 0;
80101cec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cef:	c6 01 00             	movb   $0x0,(%ecx)
80101cf2:	83 c4 10             	add    $0x10,%esp
80101cf5:	89 fb                	mov    %edi,%ebx
80101cf7:	e9 4d ff ff ff       	jmp    80101c49 <namex+0x89>
  }
  if(nameiparent){
80101cfc:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101cff:	85 db                	test   %ebx,%ebx
80101d01:	0f 85 95 00 00 00    	jne    80101d9c <namex+0x1dc>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d07:	89 f0                	mov    %esi,%eax
80101d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0c:	5b                   	pop    %ebx
80101d0d:	5e                   	pop    %esi
80101d0e:	5f                   	pop    %edi
80101d0f:	5d                   	pop    %ebp
80101d10:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d11:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101d14:	83 ec 0c             	sub    $0xc,%esp
80101d17:	53                   	push   %ebx
80101d18:	e8 3f 23 00 00       	call   8010405c <holdingsleep>
80101d1d:	83 c4 10             	add    $0x10,%esp
80101d20:	85 c0                	test   %eax,%eax
80101d22:	0f 84 84 00 00 00    	je     80101dac <namex+0x1ec>
80101d28:	8b 46 08             	mov    0x8(%esi),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	7e 7d                	jle    80101dac <namex+0x1ec>
  releasesleep(&ip->lock);
80101d2f:	83 ec 0c             	sub    $0xc,%esp
80101d32:	53                   	push   %ebx
80101d33:	e8 e8 22 00 00       	call   80104020 <releasesleep>
  iput(ip);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 e8 f9 ff ff       	call   80101728 <iput>
      return 0;
80101d40:	83 c4 10             	add    $0x10,%esp
      return 0;
80101d43:	31 f6                	xor    %esi,%esi
}
80101d45:	89 f0                	mov    %esi,%eax
80101d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4a:	5b                   	pop    %ebx
80101d4b:	5e                   	pop    %esi
80101d4c:	5f                   	pop    %edi
80101d4d:	5d                   	pop    %ebp
80101d4e:	c3                   	ret
  while(*path != '/' && *path != 0)
80101d4f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d52:	31 c0                	xor    %eax,%eax
80101d54:	eb 88                	jmp    80101cde <namex+0x11e>
    ip = iget(ROOTDEV, ROOTINO);
80101d56:	ba 01 00 00 00       	mov    $0x1,%edx
80101d5b:	b8 01 00 00 00       	mov    $0x1,%eax
80101d60:	e8 73 f4 ff ff       	call   801011d8 <iget>
80101d65:	89 c6                	mov    %eax,%esi
80101d67:	e9 99 fe ff ff       	jmp    80101c05 <namex+0x45>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d6c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	53                   	push   %ebx
80101d73:	e8 e4 22 00 00       	call   8010405c <holdingsleep>
80101d78:	83 c4 10             	add    $0x10,%esp
80101d7b:	85 c0                	test   %eax,%eax
80101d7d:	74 2d                	je     80101dac <namex+0x1ec>
80101d7f:	8b 46 08             	mov    0x8(%esi),%eax
80101d82:	85 c0                	test   %eax,%eax
80101d84:	7e 26                	jle    80101dac <namex+0x1ec>
  releasesleep(&ip->lock);
80101d86:	83 ec 0c             	sub    $0xc,%esp
80101d89:	53                   	push   %ebx
80101d8a:	e8 91 22 00 00       	call   80104020 <releasesleep>
}
80101d8f:	83 c4 10             	add    $0x10,%esp
}
80101d92:	89 f0                	mov    %esi,%eax
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	5b                   	pop    %ebx
80101d98:	5e                   	pop    %esi
80101d99:	5f                   	pop    %edi
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret
    iput(ip);
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	56                   	push   %esi
80101da0:	e8 83 f9 ff ff       	call   80101728 <iput>
    return 0;
80101da5:	83 c4 10             	add    $0x10,%esp
      return 0;
80101da8:	31 f6                	xor    %esi,%esi
80101daa:	eb 99                	jmp    80101d45 <namex+0x185>
    panic("iunlock");
80101dac:	83 ec 0c             	sub    $0xc,%esp
80101daf:	68 2e 6c 10 80       	push   $0x80106c2e
80101db4:	e8 7f e5 ff ff       	call   80100338 <panic>
80101db9:	8d 76 00             	lea    0x0(%esi),%esi

80101dbc <dirlink>:
{
80101dbc:	55                   	push   %ebp
80101dbd:	89 e5                	mov    %esp,%ebp
80101dbf:	57                   	push   %edi
80101dc0:	56                   	push   %esi
80101dc1:	53                   	push   %ebx
80101dc2:	83 ec 20             	sub    $0x20,%esp
80101dc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dc8:	6a 00                	push   $0x0
80101dca:	ff 75 0c             	push   0xc(%ebp)
80101dcd:	53                   	push   %ebx
80101dce:	e8 4d fd ff ff       	call   80101b20 <dirlookup>
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	85 c0                	test   %eax,%eax
80101dd8:	75 65                	jne    80101e3f <dirlink+0x83>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dda:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ddd:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101de0:	85 ff                	test   %edi,%edi
80101de2:	74 29                	je     80101e0d <dirlink+0x51>
80101de4:	31 ff                	xor    %edi,%edi
80101de6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101de9:	eb 09                	jmp    80101df4 <dirlink+0x38>
80101deb:	90                   	nop
80101dec:	83 c7 10             	add    $0x10,%edi
80101def:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101df2:	73 19                	jae    80101e0d <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df4:	6a 10                	push   $0x10
80101df6:	57                   	push   %edi
80101df7:	56                   	push   %esi
80101df8:	53                   	push   %ebx
80101df9:	e8 ee fa ff ff       	call   801018ec <readi>
80101dfe:	83 c4 10             	add    $0x10,%esp
80101e01:	83 f8 10             	cmp    $0x10,%eax
80101e04:	75 4c                	jne    80101e52 <dirlink+0x96>
    if(de.inum == 0)
80101e06:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e0b:	75 df                	jne    80101dec <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e0d:	50                   	push   %eax
80101e0e:	6a 0e                	push   $0xe
80101e10:	ff 75 0c             	push   0xc(%ebp)
80101e13:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e16:	50                   	push   %eax
80101e17:	e8 1c 26 00 00       	call   80104438 <strncpy>
  de.inum = inum;
80101e1c:	8b 45 10             	mov    0x10(%ebp),%eax
80101e1f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e23:	6a 10                	push   $0x10
80101e25:	57                   	push   %edi
80101e26:	56                   	push   %esi
80101e27:	53                   	push   %ebx
80101e28:	e8 bf fb ff ff       	call   801019ec <writei>
80101e2d:	83 c4 20             	add    $0x20,%esp
80101e30:	83 f8 10             	cmp    $0x10,%eax
80101e33:	75 2a                	jne    80101e5f <dirlink+0xa3>
  return 0;
80101e35:	31 c0                	xor    %eax,%eax
}
80101e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e3a:	5b                   	pop    %ebx
80101e3b:	5e                   	pop    %esi
80101e3c:	5f                   	pop    %edi
80101e3d:	5d                   	pop    %ebp
80101e3e:	c3                   	ret
    iput(ip);
80101e3f:	83 ec 0c             	sub    $0xc,%esp
80101e42:	50                   	push   %eax
80101e43:	e8 e0 f8 ff ff       	call   80101728 <iput>
    return -1;
80101e48:	83 c4 10             	add    $0x10,%esp
80101e4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e50:	eb e5                	jmp    80101e37 <dirlink+0x7b>
      panic("dirlink read");
80101e52:	83 ec 0c             	sub    $0xc,%esp
80101e55:	68 57 6c 10 80       	push   $0x80106c57
80101e5a:	e8 d9 e4 ff ff       	call   80100338 <panic>
    panic("dirlink");
80101e5f:	83 ec 0c             	sub    $0xc,%esp
80101e62:	68 65 6f 10 80       	push   $0x80106f65
80101e67:	e8 cc e4 ff ff       	call   80100338 <panic>

80101e6c <namei>:

struct inode*
namei(char *path)
{
80101e6c:	55                   	push   %ebp
80101e6d:	89 e5                	mov    %esp,%ebp
80101e6f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e72:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e75:	31 d2                	xor    %edx,%edx
80101e77:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7a:	e8 41 fd ff ff       	call   80101bc0 <namex>
}
80101e7f:	c9                   	leave
80101e80:	c3                   	ret
80101e81:	8d 76 00             	lea    0x0(%esi),%esi

80101e84 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101e84:	55                   	push   %ebp
80101e85:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e8a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e92:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101e93:	e9 28 fd ff ff       	jmp    80101bc0 <namex>

80101e98 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e98:	55                   	push   %ebp
80101e99:	89 e5                	mov    %esp,%ebp
80101e9b:	57                   	push   %edi
80101e9c:	56                   	push   %esi
80101e9d:	53                   	push   %ebx
80101e9e:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ea1:	85 c0                	test   %eax,%eax
80101ea3:	0f 84 99 00 00 00    	je     80101f42 <idestart+0xaa>
80101ea9:	89 c3                	mov    %eax,%ebx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101eab:	8b 70 08             	mov    0x8(%eax),%esi
80101eae:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101eb4:	77 7f                	ja     80101f35 <idestart+0x9d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101eb6:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101ebb:	90                   	nop
80101ebc:	89 ca                	mov    %ecx,%edx
80101ebe:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ebf:	83 e0 c0             	and    $0xffffffc0,%eax
80101ec2:	3c 40                	cmp    $0x40,%al
80101ec4:	75 f6                	jne    80101ebc <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ec6:	31 ff                	xor    %edi,%edi
80101ec8:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ecd:	89 f8                	mov    %edi,%eax
80101ecf:	ee                   	out    %al,(%dx)
80101ed0:	b0 01                	mov    $0x1,%al
80101ed2:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ed7:	ee                   	out    %al,(%dx)
80101ed8:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101edd:	89 f0                	mov    %esi,%eax
80101edf:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ee0:	89 f0                	mov    %esi,%eax
80101ee2:	c1 f8 08             	sar    $0x8,%eax
80101ee5:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101eea:	ee                   	out    %al,(%dx)
80101eeb:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101ef0:	89 f8                	mov    %edi,%eax
80101ef2:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101ef3:	8a 43 04             	mov    0x4(%ebx),%al
80101ef6:	c1 e0 04             	shl    $0x4,%eax
80101ef9:	83 e0 10             	and    $0x10,%eax
80101efc:	83 c8 e0             	or     $0xffffffe0,%eax
80101eff:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f04:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f05:	f6 03 04             	testb  $0x4,(%ebx)
80101f08:	75 0e                	jne    80101f18 <idestart+0x80>
80101f0a:	b0 20                	mov    $0x20,%al
80101f0c:	89 ca                	mov    %ecx,%edx
80101f0e:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f12:	5b                   	pop    %ebx
80101f13:	5e                   	pop    %esi
80101f14:	5f                   	pop    %edi
80101f15:	5d                   	pop    %ebp
80101f16:	c3                   	ret
80101f17:	90                   	nop
80101f18:	b0 30                	mov    $0x30,%al
80101f1a:	89 ca                	mov    %ecx,%edx
80101f1c:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101f1d:	8d 73 5c             	lea    0x5c(%ebx),%esi
  asm volatile("cld; rep outsl" :
80101f20:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f25:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f2a:	fc                   	cld
80101f2b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f30:	5b                   	pop    %ebx
80101f31:	5e                   	pop    %esi
80101f32:	5f                   	pop    %edi
80101f33:	5d                   	pop    %ebp
80101f34:	c3                   	ret
    panic("incorrect blockno");
80101f35:	83 ec 0c             	sub    $0xc,%esp
80101f38:	68 6d 6c 10 80       	push   $0x80106c6d
80101f3d:	e8 f6 e3 ff ff       	call   80100338 <panic>
    panic("idestart");
80101f42:	83 ec 0c             	sub    $0xc,%esp
80101f45:	68 64 6c 10 80       	push   $0x80106c64
80101f4a:	e8 e9 e3 ff ff       	call   80100338 <panic>
80101f4f:	90                   	nop

80101f50 <ideinit>:
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101f56:	68 7f 6c 10 80       	push   $0x80106c7f
80101f5b:	68 00 16 11 80       	push   $0x80111600
80101f60:	e8 3f 21 00 00       	call   801040a4 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101f65:	58                   	pop    %eax
80101f66:	5a                   	pop    %edx
80101f67:	a1 84 17 11 80       	mov    0x80111784,%eax
80101f6c:	48                   	dec    %eax
80101f6d:	50                   	push   %eax
80101f6e:	6a 0e                	push   $0xe
80101f70:	e8 53 02 00 00       	call   801021c8 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f75:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f78:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7d:	8d 76 00             	lea    0x0(%esi),%esi
80101f80:	ec                   	in     (%dx),%al
80101f81:	83 e0 c0             	and    $0xffffffc0,%eax
80101f84:	3c 40                	cmp    $0x40,%al
80101f86:	75 f8                	jne    80101f80 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f88:	b0 f0                	mov    $0xf0,%al
80101f8a:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f8f:	ee                   	out    %al,(%dx)
80101f90:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f95:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f9a:	eb 03                	jmp    80101f9f <ideinit+0x4f>
  for(i=0; i<1000; i++){
80101f9c:	49                   	dec    %ecx
80101f9d:	74 0f                	je     80101fae <ideinit+0x5e>
80101f9f:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101fa0:	84 c0                	test   %al,%al
80101fa2:	74 f8                	je     80101f9c <ideinit+0x4c>
      havedisk1 = 1;
80101fa4:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101fab:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fae:	b0 e0                	mov    $0xe0,%al
80101fb0:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fb5:	ee                   	out    %al,(%dx)
}
80101fb6:	c9                   	leave
80101fb7:	c3                   	ret

80101fb8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101fb8:	55                   	push   %ebp
80101fb9:	89 e5                	mov    %esp,%ebp
80101fbb:	57                   	push   %edi
80101fbc:	56                   	push   %esi
80101fbd:	53                   	push   %ebx
80101fbe:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101fc1:	68 00 16 11 80       	push   $0x80111600
80101fc6:	e8 a1 22 00 00       	call   8010426c <acquire>

  if((b = idequeue) == 0){
80101fcb:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101fd1:	83 c4 10             	add    $0x10,%esp
80101fd4:	85 db                	test   %ebx,%ebx
80101fd6:	74 5b                	je     80102033 <ideintr+0x7b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101fd8:	8b 43 58             	mov    0x58(%ebx),%eax
80101fdb:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101fe0:	8b 33                	mov    (%ebx),%esi
80101fe2:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101fe8:	75 27                	jne    80102011 <ideintr+0x59>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fef:	90                   	nop
80101ff0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff1:	88 c1                	mov    %al,%cl
80101ff3:	83 e1 c0             	and    $0xffffffc0,%ecx
80101ff6:	80 f9 40             	cmp    $0x40,%cl
80101ff9:	75 f5                	jne    80101ff0 <ideintr+0x38>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101ffb:	a8 21                	test   $0x21,%al
80101ffd:	75 12                	jne    80102011 <ideintr+0x59>
    insl(0x1f0, b->data, BSIZE/4);
80101fff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102002:	b9 80 00 00 00       	mov    $0x80,%ecx
80102007:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010200c:	fc                   	cld
8010200d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010200f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102011:	83 e6 fb             	and    $0xfffffffb,%esi
80102014:	83 ce 02             	or     $0x2,%esi
80102017:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102019:	83 ec 0c             	sub    $0xc,%esp
8010201c:	53                   	push   %ebx
8010201d:	e8 f6 1d 00 00       	call   80103e18 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102022:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	85 c0                	test   %eax,%eax
8010202c:	74 05                	je     80102033 <ideintr+0x7b>
    idestart(idequeue);
8010202e:	e8 65 fe ff ff       	call   80101e98 <idestart>
    release(&idelock);
80102033:	83 ec 0c             	sub    $0xc,%esp
80102036:	68 00 16 11 80       	push   $0x80111600
8010203b:	e8 cc 21 00 00       	call   8010420c <release>

  release(&idelock);
}
80102040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102043:	5b                   	pop    %ebx
80102044:	5e                   	pop    %esi
80102045:	5f                   	pop    %edi
80102046:	5d                   	pop    %ebp
80102047:	c3                   	ret

80102048 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102048:	55                   	push   %ebp
80102049:	89 e5                	mov    %esp,%ebp
8010204b:	53                   	push   %ebx
8010204c:	83 ec 10             	sub    $0x10,%esp
8010204f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102052:	8d 43 0c             	lea    0xc(%ebx),%eax
80102055:	50                   	push   %eax
80102056:	e8 01 20 00 00       	call   8010405c <holdingsleep>
8010205b:	83 c4 10             	add    $0x10,%esp
8010205e:	85 c0                	test   %eax,%eax
80102060:	0f 84 b7 00 00 00    	je     8010211d <iderw+0xd5>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102066:	8b 03                	mov    (%ebx),%eax
80102068:	83 e0 06             	and    $0x6,%eax
8010206b:	83 f8 02             	cmp    $0x2,%eax
8010206e:	0f 84 9c 00 00 00    	je     80102110 <iderw+0xc8>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102074:	8b 53 04             	mov    0x4(%ebx),%edx
80102077:	85 d2                	test   %edx,%edx
80102079:	74 09                	je     80102084 <iderw+0x3c>
8010207b:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102080:	85 c0                	test   %eax,%eax
80102082:	74 7f                	je     80102103 <iderw+0xbb>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102084:	83 ec 0c             	sub    $0xc,%esp
80102087:	68 00 16 11 80       	push   $0x80111600
8010208c:	e8 db 21 00 00       	call   8010426c <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102091:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102098:	a1 e4 15 11 80       	mov    0x801115e4,%eax
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	85 c0                	test   %eax,%eax
801020a2:	74 58                	je     801020fc <iderw+0xb4>
801020a4:	89 c2                	mov    %eax,%edx
801020a6:	8b 40 58             	mov    0x58(%eax),%eax
801020a9:	85 c0                	test   %eax,%eax
801020ab:	75 f7                	jne    801020a4 <iderw+0x5c>
801020ad:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801020b0:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801020b2:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801020b8:	74 36                	je     801020f0 <iderw+0xa8>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020ba:	8b 03                	mov    (%ebx),%eax
801020bc:	83 e0 06             	and    $0x6,%eax
801020bf:	83 f8 02             	cmp    $0x2,%eax
801020c2:	74 1b                	je     801020df <iderw+0x97>
    sleep(b, &idelock);
801020c4:	83 ec 08             	sub    $0x8,%esp
801020c7:	68 00 16 11 80       	push   $0x80111600
801020cc:	53                   	push   %ebx
801020cd:	e8 72 1b 00 00       	call   80103c44 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020d2:	8b 03                	mov    (%ebx),%eax
801020d4:	83 e0 06             	and    $0x6,%eax
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	83 f8 02             	cmp    $0x2,%eax
801020dd:	75 e5                	jne    801020c4 <iderw+0x7c>
  }


  release(&idelock);
801020df:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801020e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020e9:	c9                   	leave
  release(&idelock);
801020ea:	e9 1d 21 00 00       	jmp    8010420c <release>
801020ef:	90                   	nop
    idestart(b);
801020f0:	89 d8                	mov    %ebx,%eax
801020f2:	e8 a1 fd ff ff       	call   80101e98 <idestart>
801020f7:	eb c1                	jmp    801020ba <iderw+0x72>
801020f9:	8d 76 00             	lea    0x0(%esi),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020fc:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102101:	eb ad                	jmp    801020b0 <iderw+0x68>
    panic("iderw: ide disk 1 not present");
80102103:	83 ec 0c             	sub    $0xc,%esp
80102106:	68 ae 6c 10 80       	push   $0x80106cae
8010210b:	e8 28 e2 ff ff       	call   80100338 <panic>
    panic("iderw: nothing to do");
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	68 99 6c 10 80       	push   $0x80106c99
80102118:	e8 1b e2 ff ff       	call   80100338 <panic>
    panic("iderw: buf not locked");
8010211d:	83 ec 0c             	sub    $0xc,%esp
80102120:	68 83 6c 10 80       	push   $0x80106c83
80102125:	e8 0e e2 ff ff       	call   80100338 <panic>
8010212a:	66 90                	xchg   %ax,%ax

8010212c <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010212c:	55                   	push   %ebp
8010212d:	89 e5                	mov    %esp,%ebp
8010212f:	56                   	push   %esi
80102130:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102131:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102138:	00 c0 fe 
  ioapic->reg = reg;
8010213b:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102142:	00 00 00 
  return ioapic->data;
80102145:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010214b:	8b 72 10             	mov    0x10(%edx),%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010214e:	c1 ee 10             	shr    $0x10,%esi
80102151:	89 f0                	mov    %esi,%eax
80102153:	0f b6 f0             	movzbl %al,%esi
  ioapic->reg = reg;
80102156:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010215c:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
80102162:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102165:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  id = ioapicread(REG_ID) >> 24;
8010216c:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
8010216f:	39 c2                	cmp    %eax,%edx
80102171:	74 16                	je     80102189 <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102173:	83 ec 0c             	sub    $0xc,%esp
80102176:	68 1c 71 10 80       	push   $0x8010711c
8010217b:	e8 a0 e4 ff ff       	call   80100620 <cprintf>
  ioapic->reg = reg;
80102180:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
80102186:	83 c4 10             	add    $0x10,%esp
{
80102189:	ba 10 00 00 00       	mov    $0x10,%edx
8010218e:	31 c0                	xor    %eax,%eax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102190:	8d 48 20             	lea    0x20(%eax),%ecx
80102193:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
80102199:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010219b:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801021a1:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801021a4:	8d 4a 01             	lea    0x1(%edx),%ecx
801021a7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801021a9:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801021af:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801021b6:	40                   	inc    %eax
801021b7:	83 c2 02             	add    $0x2,%edx
801021ba:	39 c6                	cmp    %eax,%esi
801021bc:	7d d2                	jge    80102190 <ioapicinit+0x64>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801021be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021c1:	5b                   	pop    %ebx
801021c2:	5e                   	pop    %esi
801021c3:	5d                   	pop    %ebp
801021c4:	c3                   	ret
801021c5:	8d 76 00             	lea    0x0(%esi),%esi

801021c8 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801021c8:	55                   	push   %ebp
801021c9:	89 e5                	mov    %esp,%ebp
801021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801021ce:	8d 50 20             	lea    0x20(%eax),%edx
801021d1:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801021d5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801021db:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021dd:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801021e3:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021e6:	8b 55 0c             	mov    0xc(%ebp),%edx
801021e9:	c1 e2 18             	shl    $0x18,%edx
801021ec:	40                   	inc    %eax
  ioapic->reg = reg;
801021ed:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021ef:	a1 34 16 11 80       	mov    0x80111634,%eax
801021f4:	89 50 10             	mov    %edx,0x10(%eax)
}
801021f7:	5d                   	pop    %ebp
801021f8:	c3                   	ret
801021f9:	66 90                	xchg   %ax,%ax
801021fb:	90                   	nop

801021fc <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801021fc:	55                   	push   %ebp
801021fd:	89 e5                	mov    %esp,%ebp
801021ff:	53                   	push   %ebx
80102200:	53                   	push   %ebx
80102201:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102204:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010220a:	75 70                	jne    8010227c <kfree+0x80>
8010220c:	81 fb d0 58 11 80    	cmp    $0x801158d0,%ebx
80102212:	72 68                	jb     8010227c <kfree+0x80>
80102214:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010221a:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010221f:	77 5b                	ja     8010227c <kfree+0x80>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102221:	52                   	push   %edx
80102222:	68 00 10 00 00       	push   $0x1000
80102227:	6a 01                	push   $0x1
80102229:	53                   	push   %ebx
8010222a:	e8 09 21 00 00       	call   80104338 <memset>

  if(kmem.use_lock)
8010222f:	83 c4 10             	add    $0x10,%esp
80102232:	8b 0d 74 16 11 80    	mov    0x80111674,%ecx
80102238:	85 c9                	test   %ecx,%ecx
8010223a:	75 1c                	jne    80102258 <kfree+0x5c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010223c:	a1 78 16 11 80       	mov    0x80111678,%eax
80102241:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102243:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102249:	a1 74 16 11 80       	mov    0x80111674,%eax
8010224e:	85 c0                	test   %eax,%eax
80102250:	75 1a                	jne    8010226c <kfree+0x70>
    release(&kmem.lock);
}
80102252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102255:	c9                   	leave
80102256:	c3                   	ret
80102257:	90                   	nop
    acquire(&kmem.lock);
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	68 40 16 11 80       	push   $0x80111640
80102260:	e8 07 20 00 00       	call   8010426c <acquire>
80102265:	83 c4 10             	add    $0x10,%esp
80102268:	eb d2                	jmp    8010223c <kfree+0x40>
8010226a:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
8010226c:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
80102273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102276:	c9                   	leave
    release(&kmem.lock);
80102277:	e9 90 1f 00 00       	jmp    8010420c <release>
    panic("kfree");
8010227c:	83 ec 0c             	sub    $0xc,%esp
8010227f:	68 cc 6c 10 80       	push   $0x80106ccc
80102284:	e8 af e0 ff ff       	call   80100338 <panic>
80102289:	8d 76 00             	lea    0x0(%esi),%esi

8010228c <freerange>:
{
8010228c:	55                   	push   %ebp
8010228d:	89 e5                	mov    %esp,%ebp
8010228f:	56                   	push   %esi
80102290:	53                   	push   %ebx
80102291:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102294:	8b 45 08             	mov    0x8(%ebp),%eax
80102297:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010229d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022a9:	39 de                	cmp    %ebx,%esi
801022ab:	72 1f                	jb     801022cc <freerange+0x40>
801022ad:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801022b0:	83 ec 0c             	sub    $0xc,%esp
801022b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801022b9:	50                   	push   %eax
801022ba:	e8 3d ff ff ff       	call   801021fc <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022c5:	83 c4 10             	add    $0x10,%esp
801022c8:	39 de                	cmp    %ebx,%esi
801022ca:	73 e4                	jae    801022b0 <freerange+0x24>
}
801022cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022cf:	5b                   	pop    %ebx
801022d0:	5e                   	pop    %esi
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret
801022d3:	90                   	nop

801022d4 <kinit2>:
{
801022d4:	55                   	push   %ebp
801022d5:	89 e5                	mov    %esp,%ebp
801022d7:	56                   	push   %esi
801022d8:	53                   	push   %ebx
801022d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801022dc:	8b 45 08             	mov    0x8(%ebp),%eax
801022df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022f1:	39 de                	cmp    %ebx,%esi
801022f3:	72 1f                	jb     80102314 <kinit2+0x40>
801022f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801022f8:	83 ec 0c             	sub    $0xc,%esp
801022fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102301:	50                   	push   %eax
80102302:	e8 f5 fe ff ff       	call   801021fc <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102307:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	39 de                	cmp    %ebx,%esi
80102312:	73 e4                	jae    801022f8 <kinit2+0x24>
  kmem.use_lock = 1;
80102314:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010231b:	00 00 00 
}
8010231e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102321:	5b                   	pop    %ebx
80102322:	5e                   	pop    %esi
80102323:	5d                   	pop    %ebp
80102324:	c3                   	ret
80102325:	8d 76 00             	lea    0x0(%esi),%esi

80102328 <kinit1>:
{
80102328:	55                   	push   %ebp
80102329:	89 e5                	mov    %esp,%ebp
8010232b:	56                   	push   %esi
8010232c:	53                   	push   %ebx
8010232d:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102330:	83 ec 08             	sub    $0x8,%esp
80102333:	68 d2 6c 10 80       	push   $0x80106cd2
80102338:	68 40 16 11 80       	push   $0x80111640
8010233d:	e8 62 1d 00 00       	call   801040a4 <initlock>
  kmem.use_lock = 0;
80102342:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102349:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010234c:	8b 45 08             	mov    0x8(%ebp),%eax
8010234f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102355:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010235b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	39 de                	cmp    %ebx,%esi
80102366:	72 1c                	jb     80102384 <kinit1+0x5c>
    kfree(p);
80102368:	83 ec 0c             	sub    $0xc,%esp
8010236b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102371:	50                   	push   %eax
80102372:	e8 85 fe ff ff       	call   801021fc <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102377:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	39 de                	cmp    %ebx,%esi
80102382:	73 e4                	jae    80102368 <kinit1+0x40>
}
80102384:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102387:	5b                   	pop    %ebx
80102388:	5e                   	pop    %esi
80102389:	5d                   	pop    %ebp
8010238a:	c3                   	ret
8010238b:	90                   	nop

8010238c <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
8010238c:	a1 74 16 11 80       	mov    0x80111674,%eax
80102391:	85 c0                	test   %eax,%eax
80102393:	75 17                	jne    801023ac <kalloc+0x20>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102395:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010239a:	85 c0                	test   %eax,%eax
8010239c:	74 0a                	je     801023a8 <kalloc+0x1c>
    kmem.freelist = r->next;
8010239e:	8b 10                	mov    (%eax),%edx
801023a0:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801023a6:	c3                   	ret
801023a7:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801023a8:	c3                   	ret
801023a9:	8d 76 00             	lea    0x0(%esi),%esi
{
801023ac:	55                   	push   %ebp
801023ad:	89 e5                	mov    %esp,%ebp
801023af:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801023b2:	68 40 16 11 80       	push   $0x80111640
801023b7:	e8 b0 1e 00 00       	call   8010426c <acquire>
  r = kmem.freelist;
801023bc:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801023c1:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801023c7:	83 c4 10             	add    $0x10,%esp
801023ca:	85 c0                	test   %eax,%eax
801023cc:	74 08                	je     801023d6 <kalloc+0x4a>
    kmem.freelist = r->next;
801023ce:	8b 08                	mov    (%eax),%ecx
801023d0:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801023d6:	85 d2                	test   %edx,%edx
801023d8:	74 16                	je     801023f0 <kalloc+0x64>
801023da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&kmem.lock);
801023dd:	83 ec 0c             	sub    $0xc,%esp
801023e0:	68 40 16 11 80       	push   $0x80111640
801023e5:	e8 22 1e 00 00       	call   8010420c <release>
801023ea:	83 c4 10             	add    $0x10,%esp
801023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023f0:	c9                   	leave
801023f1:	c3                   	ret
801023f2:	66 90                	xchg   %ax,%ax

801023f4 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023f4:	ba 64 00 00 00       	mov    $0x64,%edx
801023f9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801023fa:	a8 01                	test   $0x1,%al
801023fc:	0f 84 ae 00 00 00    	je     801024b0 <kbdgetc+0xbc>
{
80102402:	55                   	push   %ebp
80102403:	89 e5                	mov    %esp,%ebp
80102405:	53                   	push   %ebx
80102406:	ba 60 00 00 00       	mov    $0x60,%edx
8010240b:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010240c:	0f b6 d8             	movzbl %al,%ebx

  if(data == 0xE0){
    shift |= E0ESC;
8010240f:	8b 0d 7c 16 11 80    	mov    0x8011167c,%ecx
  if(data == 0xE0){
80102415:	3c e0                	cmp    $0xe0,%al
80102417:	74 5b                	je     80102474 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102419:	89 ca                	mov    %ecx,%edx
8010241b:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010241e:	84 c0                	test   %al,%al
80102420:	78 62                	js     80102484 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102422:	85 d2                	test   %edx,%edx
80102424:	74 09                	je     8010242f <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102426:	83 c8 80             	or     $0xffffff80,%eax
80102429:	0f b6 d8             	movzbl %al,%ebx
    shift &= ~E0ESC;
8010242c:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
8010242f:	0f b6 93 a0 73 10 80 	movzbl -0x7fef8c60(%ebx),%edx
80102436:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
80102438:	0f b6 83 a0 72 10 80 	movzbl -0x7fef8d60(%ebx),%eax
8010243f:	31 c2                	xor    %eax,%edx
80102441:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102447:	89 d0                	mov    %edx,%eax
80102449:	83 e0 03             	and    $0x3,%eax
8010244c:	8b 04 85 80 72 10 80 	mov    -0x7fef8d80(,%eax,4),%eax
80102453:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
  if(shift & CAPSLOCK){
80102457:	83 e2 08             	and    $0x8,%edx
8010245a:	74 13                	je     8010246f <kbdgetc+0x7b>
    if('a' <= c && c <= 'z')
8010245c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010245f:	83 fa 19             	cmp    $0x19,%edx
80102462:	76 44                	jbe    801024a8 <kbdgetc+0xb4>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102464:	8d 50 bf             	lea    -0x41(%eax),%edx
80102467:	83 fa 19             	cmp    $0x19,%edx
8010246a:	77 03                	ja     8010246f <kbdgetc+0x7b>
      c += 'a' - 'A';
8010246c:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
8010246f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102472:	c9                   	leave
80102473:	c3                   	ret
    shift |= E0ESC;
80102474:	83 c9 40             	or     $0x40,%ecx
80102477:	89 0d 7c 16 11 80    	mov    %ecx,0x8011167c
    return 0;
8010247d:	31 c0                	xor    %eax,%eax
}
8010247f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102482:	c9                   	leave
80102483:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102484:	85 d2                	test   %edx,%edx
80102486:	75 05                	jne    8010248d <kbdgetc+0x99>
80102488:	89 c3                	mov    %eax,%ebx
8010248a:	83 e3 7f             	and    $0x7f,%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010248d:	8a 83 a0 73 10 80    	mov    -0x7fef8c60(%ebx),%al
80102493:	83 c8 40             	or     $0x40,%eax
80102496:	0f b6 c0             	movzbl %al,%eax
80102499:	f7 d0                	not    %eax
8010249b:	21 c8                	and    %ecx,%eax
8010249d:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801024a2:	31 c0                	xor    %eax,%eax
801024a4:	eb d9                	jmp    8010247f <kbdgetc+0x8b>
801024a6:	66 90                	xchg   %ax,%ax
      c += 'A' - 'a';
801024a8:	83 e8 20             	sub    $0x20,%eax
}
801024ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ae:	c9                   	leave
801024af:	c3                   	ret
    return -1;
801024b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801024b5:	c3                   	ret
801024b6:	66 90                	xchg   %ax,%ax

801024b8 <kbdintr>:
// {
//   consoleintr(kbdgetc);

// }

void kbdintr(void) {
801024b8:	55                   	push   %ebp
801024b9:	89 e5                	mov    %esp,%ebp
801024bb:	83 ec 08             	sub    $0x8,%esp
  uchar c;
  // extern struct { struct spinlock lock; int locking; } cons;
  // acquire(&cons.lock);
  c = kbdgetc();
801024be:	e8 31 ff ff ff       	call   801023f4 <kbdgetc>
  if(c == 0){
801024c3:	84 c0                	test   %al,%al
801024c5:	74 34                	je     801024fb <kbdintr+0x43>
    // release(&cons.lock);
    return;
  }

  switch(c){
801024c7:	0f b6 c0             	movzbl %al,%eax
801024ca:	83 f8 06             	cmp    $0x6,%eax
801024cd:	74 75                	je     80102544 <kbdintr+0x8c>
801024cf:	7f 2f                	jg     80102500 <kbdintr+0x48>
801024d1:	83 f8 02             	cmp    $0x2,%eax
801024d4:	74 4e                	je     80102524 <kbdintr+0x6c>
801024d6:	83 f8 03             	cmp    $0x3,%eax
801024d9:	0f 85 85 00 00 00    	jne    80102564 <kbdintr+0xac>
        case 0x03: // Ctrl+C
            cprintf("Ctrl -C is detected by xv6\n");
801024df:	83 ec 0c             	sub    $0xc,%esp
801024e2:	68 d7 6c 10 80       	push   $0x80106cd7
801024e7:	e8 34 e1 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGINT);
801024ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801024f3:	e8 24 13 00 00       	call   8010381c <send_signal_to_all>
            break;
801024f8:	83 c4 10             	add    $0x10,%esp
        default:
            consoleintr(kbdgetc);
            break;
    }
  //  release(&cons.lock);
}
801024fb:	c9                   	leave
801024fc:	c3                   	ret
801024fd:	8d 76 00             	lea    0x0(%esi),%esi
  switch(c){
80102500:	83 f8 07             	cmp    $0x7,%eax
80102503:	75 5f                	jne    80102564 <kbdintr+0xac>
            cprintf("Ctrl -G is detected by xv6\n");
80102505:	83 ec 0c             	sub    $0xc,%esp
80102508:	68 2b 6d 10 80       	push   $0x80106d2b
8010250d:	e8 0e e1 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGCUSTOM);
80102512:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80102519:	e8 fe 12 00 00       	call   8010381c <send_signal_to_all>
            break;
8010251e:	83 c4 10             	add    $0x10,%esp
}
80102521:	c9                   	leave
80102522:	c3                   	ret
80102523:	90                   	nop
            cprintf("Ctrl -B is detected by xv6\n");
80102524:	83 ec 0c             	sub    $0xc,%esp
80102527:	68 f3 6c 10 80       	push   $0x80106cf3
8010252c:	e8 ef e0 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGBG);
80102531:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80102538:	e8 df 12 00 00       	call   8010381c <send_signal_to_all>
            break;
8010253d:	83 c4 10             	add    $0x10,%esp
}
80102540:	c9                   	leave
80102541:	c3                   	ret
80102542:	66 90                	xchg   %ax,%ax
            cprintf("Ctrl -F is detected by xv6\n");
80102544:	83 ec 0c             	sub    $0xc,%esp
80102547:	68 0f 6d 10 80       	push   $0x80106d0f
8010254c:	e8 cf e0 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGFG);
80102551:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80102558:	e8 bf 12 00 00       	call   8010381c <send_signal_to_all>
            break;
8010255d:	83 c4 10             	add    $0x10,%esp
}
80102560:	c9                   	leave
80102561:	c3                   	ret
80102562:	66 90                	xchg   %ax,%ax
            consoleintr(kbdgetc);
80102564:	83 ec 0c             	sub    $0xc,%esp
80102567:	68 f4 23 10 80       	push   $0x801023f4
8010256c:	e8 77 e2 ff ff       	call   801007e8 <consoleintr>
            break;
80102571:	83 c4 10             	add    $0x10,%esp
}
80102574:	c9                   	leave
80102575:	c3                   	ret
80102576:	66 90                	xchg   %ax,%ax

80102578 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102578:	a1 80 16 11 80       	mov    0x80111680,%eax
8010257d:	85 c0                	test   %eax,%eax
8010257f:	0f 84 bf 00 00 00    	je     80102644 <lapicinit+0xcc>
  lapic[index] = value;
80102585:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
8010258c:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010258f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102592:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102599:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010259c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010259f:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801025a6:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801025a9:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025ac:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801025b3:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801025b6:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025b9:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801025c0:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025c6:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801025cd:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801025d3:	8b 50 30             	mov    0x30(%eax),%edx
801025d6:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801025dc:	75 6a                	jne    80102648 <lapicinit+0xd0>
  lapic[index] = value;
801025de:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801025e5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025eb:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801025f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025f8:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801025ff:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102602:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102605:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010260c:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102612:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102619:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010261f:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102626:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102629:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
8010262c:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102632:	80 e6 10             	and    $0x10,%dh
80102635:	75 f5                	jne    8010262c <lapicinit+0xb4>
  lapic[index] = value;
80102637:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010263e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102641:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102644:	c3                   	ret
80102645:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
80102648:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010264f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102652:	8b 50 20             	mov    0x20(%eax),%edx
}
80102655:	eb 87                	jmp    801025de <lapicinit+0x66>
80102657:	90                   	nop

80102658 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102658:	a1 80 16 11 80       	mov    0x80111680,%eax
8010265d:	85 c0                	test   %eax,%eax
8010265f:	74 07                	je     80102668 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102661:	8b 40 20             	mov    0x20(%eax),%eax
80102664:	c1 e8 18             	shr    $0x18,%eax
80102667:	c3                   	ret
80102668:	31 c0                	xor    %eax,%eax
}
8010266a:	c3                   	ret
8010266b:	90                   	nop

8010266c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
8010266c:	a1 80 16 11 80       	mov    0x80111680,%eax
80102671:	85 c0                	test   %eax,%eax
80102673:	74 0d                	je     80102682 <lapiceoi+0x16>
  lapic[index] = value;
80102675:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010267c:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267f:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102682:	c3                   	ret
80102683:	90                   	nop

80102684 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102684:	c3                   	ret
80102685:	8d 76 00             	lea    0x0(%esi),%esi

80102688 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102688:	55                   	push   %ebp
80102689:	89 e5                	mov    %esp,%ebp
8010268b:	53                   	push   %ebx
8010268c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010268f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102692:	b0 0f                	mov    $0xf,%al
80102694:	ba 70 00 00 00       	mov    $0x70,%edx
80102699:	ee                   	out    %al,(%dx)
8010269a:	b0 0a                	mov    $0xa,%al
8010269c:	ba 71 00 00 00       	mov    $0x71,%edx
801026a1:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801026a2:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801026a9:	00 00 
  wrv[1] = addr >> 4;
801026ab:	89 c8                	mov    %ecx,%eax
801026ad:	c1 e8 04             	shr    $0x4,%eax
801026b0:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801026b6:	a1 80 16 11 80       	mov    0x80111680,%eax
801026bb:	c1 e3 18             	shl    $0x18,%ebx
801026be:	89 da                	mov    %ebx,%edx
801026c0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026c9:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801026d0:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026d6:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801026dd:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026e3:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026e9:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801026ec:	c1 e9 0c             	shr    $0xc,%ecx
801026ef:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
801026f2:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026f8:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026fb:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102701:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102704:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010270d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102710:	c9                   	leave
80102711:	c3                   	ret
80102712:	66 90                	xchg   %ax,%ax

80102714 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102714:	55                   	push   %ebp
80102715:	89 e5                	mov    %esp,%ebp
80102717:	57                   	push   %edi
80102718:	56                   	push   %esi
80102719:	53                   	push   %ebx
8010271a:	83 ec 4c             	sub    $0x4c,%esp
8010271d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102720:	b0 0b                	mov    $0xb,%al
80102722:	ba 70 00 00 00       	mov    $0x70,%edx
80102727:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102728:	ba 71 00 00 00       	mov    $0x71,%edx
8010272d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010272e:	83 e0 04             	and    $0x4,%eax
80102731:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102733:	89 df                	mov    %ebx,%edi
80102735:	8d 76 00             	lea    0x0(%esi),%esi
80102738:	31 c0                	xor    %eax,%eax
8010273a:	ba 70 00 00 00       	mov    $0x70,%edx
8010273f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102740:	bb 71 00 00 00       	mov    $0x71,%ebx
80102745:	89 da                	mov    %ebx,%edx
80102747:	ec                   	in     (%dx),%al
80102748:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010274b:	b0 02                	mov    $0x2,%al
8010274d:	ba 70 00 00 00       	mov    $0x70,%edx
80102752:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102753:	89 da                	mov    %ebx,%edx
80102755:	ec                   	in     (%dx),%al
80102756:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102759:	b0 04                	mov    $0x4,%al
8010275b:	ba 70 00 00 00       	mov    $0x70,%edx
80102760:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102761:	89 da                	mov    %ebx,%edx
80102763:	ec                   	in     (%dx),%al
80102764:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102767:	b0 07                	mov    $0x7,%al
80102769:	ba 70 00 00 00       	mov    $0x70,%edx
8010276e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010276f:	89 da                	mov    %ebx,%edx
80102771:	ec                   	in     (%dx),%al
80102772:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102775:	b0 08                	mov    $0x8,%al
80102777:	ba 70 00 00 00       	mov    $0x70,%edx
8010277c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010277d:	89 da                	mov    %ebx,%edx
8010277f:	ec                   	in     (%dx),%al
80102780:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102783:	b0 09                	mov    $0x9,%al
80102785:	ba 70 00 00 00       	mov    $0x70,%edx
8010278a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010278b:	89 da                	mov    %ebx,%edx
8010278d:	ec                   	in     (%dx),%al
8010278e:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	b0 0a                	mov    $0xa,%al
80102793:	ba 70 00 00 00       	mov    $0x70,%edx
80102798:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102799:	89 da                	mov    %ebx,%edx
8010279b:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010279c:	84 c0                	test   %al,%al
8010279e:	78 98                	js     80102738 <cmostime+0x24>
  return inb(CMOS_RETURN);
801027a0:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801027a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
801027a7:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801027ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
801027ae:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801027b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
801027b5:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801027b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801027bc:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
801027c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
801027c3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c6:	31 c0                	xor    %eax,%eax
801027c8:	ba 70 00 00 00       	mov    $0x70,%edx
801027cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027ce:	89 da                	mov    %ebx,%edx
801027d0:	ec                   	in     (%dx),%al
801027d1:	0f b6 c0             	movzbl %al,%eax
801027d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d7:	b0 02                	mov    $0x2,%al
801027d9:	ba 70 00 00 00       	mov    $0x70,%edx
801027de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027df:	89 da                	mov    %ebx,%edx
801027e1:	ec                   	in     (%dx),%al
801027e2:	0f b6 c0             	movzbl %al,%eax
801027e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e8:	b0 04                	mov    $0x4,%al
801027ea:	ba 70 00 00 00       	mov    $0x70,%edx
801027ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f0:	89 da                	mov    %ebx,%edx
801027f2:	ec                   	in     (%dx),%al
801027f3:	0f b6 c0             	movzbl %al,%eax
801027f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f9:	b0 07                	mov    $0x7,%al
801027fb:	ba 70 00 00 00       	mov    $0x70,%edx
80102800:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102801:	89 da                	mov    %ebx,%edx
80102803:	ec                   	in     (%dx),%al
80102804:	0f b6 c0             	movzbl %al,%eax
80102807:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010280a:	b0 08                	mov    $0x8,%al
8010280c:	ba 70 00 00 00       	mov    $0x70,%edx
80102811:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102812:	89 da                	mov    %ebx,%edx
80102814:	ec                   	in     (%dx),%al
80102815:	0f b6 c0             	movzbl %al,%eax
80102818:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010281b:	b0 09                	mov    $0x9,%al
8010281d:	ba 70 00 00 00       	mov    $0x70,%edx
80102822:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102823:	89 da                	mov    %ebx,%edx
80102825:	ec                   	in     (%dx),%al
80102826:	0f b6 c0             	movzbl %al,%eax
80102829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010282c:	50                   	push   %eax
8010282d:	6a 18                	push   $0x18
8010282f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102832:	50                   	push   %eax
80102833:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102836:	50                   	push   %eax
80102837:	e8 40 1b 00 00       	call   8010437c <memcmp>
8010283c:	83 c4 10             	add    $0x10,%esp
8010283f:	85 c0                	test   %eax,%eax
80102841:	0f 85 f1 fe ff ff    	jne    80102738 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
80102847:	89 fb                	mov    %edi,%ebx
80102849:	89 f0                	mov    %esi,%eax
8010284b:	84 c0                	test   %al,%al
8010284d:	75 7e                	jne    801028cd <cmostime+0x1b9>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010284f:	8b 55 b8             	mov    -0x48(%ebp),%edx
80102852:	89 d0                	mov    %edx,%eax
80102854:	c1 e8 04             	shr    $0x4,%eax
80102857:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010285a:	01 c0                	add    %eax,%eax
8010285c:	83 e2 0f             	and    $0xf,%edx
8010285f:	01 d0                	add    %edx,%eax
80102861:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102864:	8b 55 bc             	mov    -0x44(%ebp),%edx
80102867:	89 d0                	mov    %edx,%eax
80102869:	c1 e8 04             	shr    $0x4,%eax
8010286c:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010286f:	01 c0                	add    %eax,%eax
80102871:	83 e2 0f             	and    $0xf,%edx
80102874:	01 d0                	add    %edx,%eax
80102876:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102879:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010287c:	89 d0                	mov    %edx,%eax
8010287e:	c1 e8 04             	shr    $0x4,%eax
80102881:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102884:	01 c0                	add    %eax,%eax
80102886:	83 e2 0f             	and    $0xf,%edx
80102889:	01 d0                	add    %edx,%eax
8010288b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010288e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80102891:	89 d0                	mov    %edx,%eax
80102893:	c1 e8 04             	shr    $0x4,%eax
80102896:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102899:	01 c0                	add    %eax,%eax
8010289b:	83 e2 0f             	and    $0xf,%edx
8010289e:	01 d0                	add    %edx,%eax
801028a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
801028a6:	89 d0                	mov    %edx,%eax
801028a8:	c1 e8 04             	shr    $0x4,%eax
801028ab:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028ae:	01 c0                	add    %eax,%eax
801028b0:	83 e2 0f             	and    $0xf,%edx
801028b3:	01 d0                	add    %edx,%eax
801028b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
801028bb:	89 d0                	mov    %edx,%eax
801028bd:	c1 e8 04             	shr    $0x4,%eax
801028c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028c3:	01 c0                	add    %eax,%eax
801028c5:	83 e2 0f             	and    $0xf,%edx
801028c8:	01 d0                	add    %edx,%eax
801028ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801028cd:	b9 06 00 00 00       	mov    $0x6,%ecx
801028d2:	89 df                	mov    %ebx,%edi
801028d4:	8d 75 b8             	lea    -0x48(%ebp),%esi
801028d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801028d9:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
801028e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028e3:	5b                   	pop    %ebx
801028e4:	5e                   	pop    %esi
801028e5:	5f                   	pop    %edi
801028e6:	5d                   	pop    %ebp
801028e7:	c3                   	ret

801028e8 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801028e8:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
801028ee:	85 c9                	test   %ecx,%ecx
801028f0:	7e 7e                	jle    80102970 <install_trans+0x88>
{
801028f2:	55                   	push   %ebp
801028f3:	89 e5                	mov    %esp,%ebp
801028f5:	57                   	push   %edi
801028f6:	56                   	push   %esi
801028f7:	53                   	push   %ebx
801028f8:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801028fb:	31 ff                	xor    %edi,%edi
801028fd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102900:	83 ec 08             	sub    $0x8,%esp
80102903:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102908:	01 f8                	add    %edi,%eax
8010290a:	40                   	inc    %eax
8010290b:	50                   	push   %eax
8010290c:	ff 35 e4 16 11 80    	push   0x801116e4
80102912:	e8 9d d7 ff ff       	call   801000b4 <bread>
80102917:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102919:	58                   	pop    %eax
8010291a:	5a                   	pop    %edx
8010291b:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102922:	ff 35 e4 16 11 80    	push   0x801116e4
80102928:	e8 87 d7 ff ff       	call   801000b4 <bread>
8010292d:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010292f:	83 c4 0c             	add    $0xc,%esp
80102932:	68 00 02 00 00       	push   $0x200
80102937:	8d 46 5c             	lea    0x5c(%esi),%eax
8010293a:	50                   	push   %eax
8010293b:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010293e:	50                   	push   %eax
8010293f:	e8 70 1a 00 00       	call   801043b4 <memmove>
    bwrite(dbuf);  // write dst to disk
80102944:	89 1c 24             	mov    %ebx,(%esp)
80102947:	e8 38 d8 ff ff       	call   80100184 <bwrite>
    brelse(lbuf);
8010294c:	89 34 24             	mov    %esi,(%esp)
8010294f:	e8 68 d8 ff ff       	call   801001bc <brelse>
    brelse(dbuf);
80102954:	89 1c 24             	mov    %ebx,(%esp)
80102957:	e8 60 d8 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010295c:	47                   	inc    %edi
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102966:	7f 98                	jg     80102900 <install_trans+0x18>
  }
}
80102968:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010296b:	5b                   	pop    %ebx
8010296c:	5e                   	pop    %esi
8010296d:	5f                   	pop    %edi
8010296e:	5d                   	pop    %ebp
8010296f:	c3                   	ret
80102970:	c3                   	ret
80102971:	8d 76 00             	lea    0x0(%esi),%esi

80102974 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102974:	55                   	push   %ebp
80102975:	89 e5                	mov    %esp,%ebp
80102977:	53                   	push   %ebx
80102978:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010297b:	ff 35 d4 16 11 80    	push   0x801116d4
80102981:	ff 35 e4 16 11 80    	push   0x801116e4
80102987:	e8 28 d7 ff ff       	call   801000b4 <bread>
8010298c:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010298e:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102993:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102996:	83 c4 10             	add    $0x10,%esp
80102999:	85 c0                	test   %eax,%eax
8010299b:	7e 13                	jle    801029b0 <write_head+0x3c>
8010299d:	31 d2                	xor    %edx,%edx
8010299f:	90                   	nop
    hb->block[i] = log.lh.block[i];
801029a0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
801029a7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801029ab:	42                   	inc    %edx
801029ac:	39 d0                	cmp    %edx,%eax
801029ae:	75 f0                	jne    801029a0 <write_head+0x2c>
  }
  bwrite(buf);
801029b0:	83 ec 0c             	sub    $0xc,%esp
801029b3:	53                   	push   %ebx
801029b4:	e8 cb d7 ff ff       	call   80100184 <bwrite>
  brelse(buf);
801029b9:	89 1c 24             	mov    %ebx,(%esp)
801029bc:	e8 fb d7 ff ff       	call   801001bc <brelse>
}
801029c1:	83 c4 10             	add    $0x10,%esp
801029c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c7:	c9                   	leave
801029c8:	c3                   	ret
801029c9:	8d 76 00             	lea    0x0(%esi),%esi

801029cc <initlog>:
{
801029cc:	55                   	push   %ebp
801029cd:	89 e5                	mov    %esp,%ebp
801029cf:	53                   	push   %ebx
801029d0:	83 ec 2c             	sub    $0x2c,%esp
801029d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801029d6:	68 47 6d 10 80       	push   $0x80106d47
801029db:	68 a0 16 11 80       	push   $0x801116a0
801029e0:	e8 bf 16 00 00       	call   801040a4 <initlock>
  readsb(dev, &sb);
801029e5:	58                   	pop    %eax
801029e6:	5a                   	pop    %edx
801029e7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801029ea:	50                   	push   %eax
801029eb:	53                   	push   %ebx
801029ec:	e8 f3 e9 ff ff       	call   801013e4 <readsb>
  log.start = sb.logstart;
801029f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029f4:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
801029f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801029fc:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  log.dev = dev;
80102a02:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  struct buf *buf = bread(log.dev, log.start);
80102a08:	59                   	pop    %ecx
80102a09:	5a                   	pop    %edx
80102a0a:	50                   	push   %eax
80102a0b:	53                   	push   %ebx
80102a0c:	e8 a3 d6 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
80102a11:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102a14:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102a1a:	83 c4 10             	add    $0x10,%esp
80102a1d:	85 db                	test   %ebx,%ebx
80102a1f:	7e 13                	jle    80102a34 <initlog+0x68>
80102a21:	31 d2                	xor    %edx,%edx
80102a23:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102a24:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102a28:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a2f:	42                   	inc    %edx
80102a30:	39 d3                	cmp    %edx,%ebx
80102a32:	75 f0                	jne    80102a24 <initlog+0x58>
  brelse(buf);
80102a34:	83 ec 0c             	sub    $0xc,%esp
80102a37:	50                   	push   %eax
80102a38:	e8 7f d7 ff ff       	call   801001bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102a3d:	e8 a6 fe ff ff       	call   801028e8 <install_trans>
  log.lh.n = 0;
80102a42:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102a49:	00 00 00 
  write_head(); // clear the log
80102a4c:	e8 23 ff ff ff       	call   80102974 <write_head>
}
80102a51:	83 c4 10             	add    $0x10,%esp
80102a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a57:	c9                   	leave
80102a58:	c3                   	ret
80102a59:	8d 76 00             	lea    0x0(%esi),%esi

80102a5c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102a5c:	55                   	push   %ebp
80102a5d:	89 e5                	mov    %esp,%ebp
80102a5f:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102a62:	68 a0 16 11 80       	push   $0x801116a0
80102a67:	e8 00 18 00 00       	call   8010426c <acquire>
80102a6c:	83 c4 10             	add    $0x10,%esp
80102a6f:	eb 18                	jmp    80102a89 <begin_op+0x2d>
80102a71:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102a74:	83 ec 08             	sub    $0x8,%esp
80102a77:	68 a0 16 11 80       	push   $0x801116a0
80102a7c:	68 a0 16 11 80       	push   $0x801116a0
80102a81:	e8 be 11 00 00       	call   80103c44 <sleep>
80102a86:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102a89:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102a8e:	85 c0                	test   %eax,%eax
80102a90:	75 e2                	jne    80102a74 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102a92:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102a97:	8d 50 01             	lea    0x1(%eax),%edx
80102a9a:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
80102a9e:	01 c0                	add    %eax,%eax
80102aa0:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102aa6:	83 f8 1e             	cmp    $0x1e,%eax
80102aa9:	7f c9                	jg     80102a74 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102aab:	89 15 dc 16 11 80    	mov    %edx,0x801116dc
      release(&log.lock);
80102ab1:	83 ec 0c             	sub    $0xc,%esp
80102ab4:	68 a0 16 11 80       	push   $0x801116a0
80102ab9:	e8 4e 17 00 00       	call   8010420c <release>
      break;
    }
  }
}
80102abe:	83 c4 10             	add    $0x10,%esp
80102ac1:	c9                   	leave
80102ac2:	c3                   	ret
80102ac3:	90                   	nop

80102ac4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ac4:	55                   	push   %ebp
80102ac5:	89 e5                	mov    %esp,%ebp
80102ac7:	57                   	push   %edi
80102ac8:	56                   	push   %esi
80102ac9:	53                   	push   %ebx
80102aca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102acd:	68 a0 16 11 80       	push   $0x801116a0
80102ad2:	e8 95 17 00 00       	call   8010426c <acquire>
  log.outstanding -= 1;
80102ad7:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102adc:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102adf:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102ae5:	83 c4 10             	add    $0x10,%esp
80102ae8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102aee:	85 f6                	test   %esi,%esi
80102af0:	0f 85 12 01 00 00    	jne    80102c08 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
80102af6:	85 db                	test   %ebx,%ebx
80102af8:	0f 85 e6 00 00 00    	jne    80102be4 <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
80102afe:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102b05:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b08:	83 ec 0c             	sub    $0xc,%esp
80102b0b:	68 a0 16 11 80       	push   $0x801116a0
80102b10:	e8 f7 16 00 00       	call   8010420c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b15:	83 c4 10             	add    $0x10,%esp
80102b18:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102b1e:	85 c9                	test   %ecx,%ecx
80102b20:	7f 3a                	jg     80102b5c <end_op+0x98>
    acquire(&log.lock);
80102b22:	83 ec 0c             	sub    $0xc,%esp
80102b25:	68 a0 16 11 80       	push   $0x801116a0
80102b2a:	e8 3d 17 00 00       	call   8010426c <acquire>
    log.committing = 0;
80102b2f:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102b36:	00 00 00 
    wakeup(&log);
80102b39:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b40:	e8 d3 12 00 00       	call   80103e18 <wakeup>
    release(&log.lock);
80102b45:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b4c:	e8 bb 16 00 00       	call   8010420c <release>
80102b51:	83 c4 10             	add    $0x10,%esp
}
80102b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b57:	5b                   	pop    %ebx
80102b58:	5e                   	pop    %esi
80102b59:	5f                   	pop    %edi
80102b5a:	5d                   	pop    %ebp
80102b5b:	c3                   	ret
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102b5c:	83 ec 08             	sub    $0x8,%esp
80102b5f:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102b64:	01 d8                	add    %ebx,%eax
80102b66:	40                   	inc    %eax
80102b67:	50                   	push   %eax
80102b68:	ff 35 e4 16 11 80    	push   0x801116e4
80102b6e:	e8 41 d5 ff ff       	call   801000b4 <bread>
80102b73:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b75:	58                   	pop    %eax
80102b76:	5a                   	pop    %edx
80102b77:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102b7e:	ff 35 e4 16 11 80    	push   0x801116e4
80102b84:	e8 2b d5 ff ff       	call   801000b4 <bread>
80102b89:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102b8b:	83 c4 0c             	add    $0xc,%esp
80102b8e:	68 00 02 00 00       	push   $0x200
80102b93:	8d 40 5c             	lea    0x5c(%eax),%eax
80102b96:	50                   	push   %eax
80102b97:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b9a:	50                   	push   %eax
80102b9b:	e8 14 18 00 00       	call   801043b4 <memmove>
    bwrite(to);  // write the log
80102ba0:	89 34 24             	mov    %esi,(%esp)
80102ba3:	e8 dc d5 ff ff       	call   80100184 <bwrite>
    brelse(from);
80102ba8:	89 3c 24             	mov    %edi,(%esp)
80102bab:	e8 0c d6 ff ff       	call   801001bc <brelse>
    brelse(to);
80102bb0:	89 34 24             	mov    %esi,(%esp)
80102bb3:	e8 04 d6 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb8:	43                   	inc    %ebx
80102bb9:	83 c4 10             	add    $0x10,%esp
80102bbc:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102bc2:	7c 98                	jl     80102b5c <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102bc4:	e8 ab fd ff ff       	call   80102974 <write_head>
    install_trans(); // Now install writes to home locations
80102bc9:	e8 1a fd ff ff       	call   801028e8 <install_trans>
    log.lh.n = 0;
80102bce:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102bd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102bd8:	e8 97 fd ff ff       	call   80102974 <write_head>
80102bdd:	e9 40 ff ff ff       	jmp    80102b22 <end_op+0x5e>
80102be2:	66 90                	xchg   %ax,%ax
    wakeup(&log);
80102be4:	83 ec 0c             	sub    $0xc,%esp
80102be7:	68 a0 16 11 80       	push   $0x801116a0
80102bec:	e8 27 12 00 00       	call   80103e18 <wakeup>
  release(&log.lock);
80102bf1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102bf8:	e8 0f 16 00 00       	call   8010420c <release>
80102bfd:	83 c4 10             	add    $0x10,%esp
}
80102c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c03:	5b                   	pop    %ebx
80102c04:	5e                   	pop    %esi
80102c05:	5f                   	pop    %edi
80102c06:	5d                   	pop    %ebp
80102c07:	c3                   	ret
    panic("log.committing");
80102c08:	83 ec 0c             	sub    $0xc,%esp
80102c0b:	68 4b 6d 10 80       	push   $0x80106d4b
80102c10:	e8 23 d7 ff ff       	call   80100338 <panic>
80102c15:	8d 76 00             	lea    0x0(%esi),%esi

80102c18 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c18:	55                   	push   %ebp
80102c19:	89 e5                	mov    %esp,%ebp
80102c1b:	53                   	push   %ebx
80102c1c:	52                   	push   %edx
80102c1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c20:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102c26:	83 fa 1d             	cmp    $0x1d,%edx
80102c29:	7f 71                	jg     80102c9c <log_write+0x84>
80102c2b:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102c30:	48                   	dec    %eax
80102c31:	39 c2                	cmp    %eax,%edx
80102c33:	7d 67                	jge    80102c9c <log_write+0x84>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102c35:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102c3a:	85 c0                	test   %eax,%eax
80102c3c:	7e 6b                	jle    80102ca9 <log_write+0x91>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102c3e:	83 ec 0c             	sub    $0xc,%esp
80102c41:	68 a0 16 11 80       	push   $0x801116a0
80102c46:	e8 21 16 00 00       	call   8010426c <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102c4b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102c51:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c54:	83 c4 10             	add    $0x10,%esp
80102c57:	31 c0                	xor    %eax,%eax
80102c59:	85 d2                	test   %edx,%edx
80102c5b:	7f 08                	jg     80102c65 <log_write+0x4d>
80102c5d:	eb 0f                	jmp    80102c6e <log_write+0x56>
80102c5f:	90                   	nop
80102c60:	40                   	inc    %eax
80102c61:	39 d0                	cmp    %edx,%eax
80102c63:	74 27                	je     80102c8c <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102c65:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102c6c:	75 f2                	jne    80102c60 <log_write+0x48>
  log.lh.block[i] = b->blockno;
80102c6e:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102c75:	39 c2                	cmp    %eax,%edx
80102c77:	74 1a                	je     80102c93 <log_write+0x7b>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102c79:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102c7c:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	c9                   	leave
  release(&log.lock);
80102c87:	e9 80 15 00 00       	jmp    8010420c <release>
  log.lh.block[i] = b->blockno;
80102c8c:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102c93:	42                   	inc    %edx
80102c94:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102c9a:	eb dd                	jmp    80102c79 <log_write+0x61>
    panic("too big a transaction");
80102c9c:	83 ec 0c             	sub    $0xc,%esp
80102c9f:	68 5a 6d 10 80       	push   $0x80106d5a
80102ca4:	e8 8f d6 ff ff       	call   80100338 <panic>
    panic("log_write outside of trans");
80102ca9:	83 ec 0c             	sub    $0xc,%esp
80102cac:	68 70 6d 10 80       	push   $0x80106d70
80102cb1:	e8 82 d6 ff ff       	call   80100338 <panic>
80102cb6:	66 90                	xchg   %ax,%ax

80102cb8 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102cb8:	55                   	push   %ebp
80102cb9:	89 e5                	mov    %esp,%ebp
80102cbb:	53                   	push   %ebx
80102cbc:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102cbd:	e8 a2 08 00 00       	call   80103564 <cpuid>
80102cc2:	89 c3                	mov    %eax,%ebx
80102cc4:	e8 9b 08 00 00       	call   80103564 <cpuid>
80102cc9:	52                   	push   %edx
80102cca:	53                   	push   %ebx
80102ccb:	50                   	push   %eax
80102ccc:	68 8b 6d 10 80       	push   $0x80106d8b
80102cd1:	e8 4a d9 ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102cd6:	e8 b9 26 00 00       	call   80105394 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102cdb:	e8 20 08 00 00       	call   80103500 <mycpu>
80102ce0:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ce2:	b8 01 00 00 00       	mov    $0x1,%eax
80102ce7:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102cee:	e8 59 0c 00 00       	call   8010394c <scheduler>
80102cf3:	90                   	nop

80102cf4 <mpenter>:
{
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102cfa:	e8 49 37 00 00       	call   80106448 <switchkvm>
  seginit();
80102cff:	e8 c0 36 00 00       	call   801063c4 <seginit>
  lapicinit();
80102d04:	e8 6f f8 ff ff       	call   80102578 <lapicinit>
  mpmain();
80102d09:	e8 aa ff ff ff       	call   80102cb8 <mpmain>
80102d0e:	66 90                	xchg   %ax,%ax

80102d10 <main>:
{
80102d10:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102d14:	83 e4 f0             	and    $0xfffffff0,%esp
80102d17:	ff 71 fc             	push   -0x4(%ecx)
80102d1a:	55                   	push   %ebp
80102d1b:	89 e5                	mov    %esp,%ebp
80102d1d:	53                   	push   %ebx
80102d1e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102d1f:	83 ec 08             	sub    $0x8,%esp
80102d22:	68 00 00 40 80       	push   $0x80400000
80102d27:	68 d0 58 11 80       	push   $0x801158d0
80102d2c:	e8 f7 f5 ff ff       	call   80102328 <kinit1>
  kvmalloc();      // kernel page table
80102d31:	e8 5a 3b 00 00       	call   80106890 <kvmalloc>
  mpinit();        // detect other processors
80102d36:	e8 61 01 00 00       	call   80102e9c <mpinit>
  lapicinit();     // interrupt controller
80102d3b:	e8 38 f8 ff ff       	call   80102578 <lapicinit>
  seginit();       // segment descriptors
80102d40:	e8 7f 36 00 00       	call   801063c4 <seginit>
  picinit();       // disable pic
80102d45:	e8 12 03 00 00       	call   8010305c <picinit>
  ioapicinit();    // another interrupt controller
80102d4a:	e8 dd f3 ff ff       	call   8010212c <ioapicinit>
  consoleinit();   // console hardware
80102d4f:	e8 8c dc ff ff       	call   801009e0 <consoleinit>
  uartinit();      // serial port
80102d54:	e8 47 29 00 00       	call   801056a0 <uartinit>
  pinit();         // process table
80102d59:	e8 86 07 00 00       	call   801034e4 <pinit>
  tvinit();        // trap vectors
80102d5e:	e8 c5 25 00 00       	call   80105328 <tvinit>
  binit();         // buffer cache
80102d63:	e8 cc d2 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102d68:	e8 13 e0 ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80102d6d:	e8 de f1 ff ff       	call   80101f50 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102d72:	83 c4 0c             	add    $0xc,%esp
80102d75:	68 8a 00 00 00       	push   $0x8a
80102d7a:	68 8c a4 10 80       	push   $0x8010a48c
80102d7f:	68 00 70 00 80       	push   $0x80007000
80102d84:	e8 2b 16 00 00       	call   801043b4 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102d89:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102d8f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102d92:	01 c0                	add    %eax,%eax
80102d94:	01 d0                	add    %edx,%eax
80102d96:	c1 e0 04             	shl    $0x4,%eax
80102d99:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102d9e:	83 c4 10             	add    $0x10,%esp
80102da1:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80102da6:	76 74                	jbe    80102e1c <main+0x10c>
80102da8:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80102dad:	eb 20                	jmp    80102dcf <main+0xbf>
80102daf:	90                   	nop
80102db0:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102db6:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102dbc:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102dbf:	01 c0                	add    %eax,%eax
80102dc1:	01 d0                	add    %edx,%eax
80102dc3:	c1 e0 04             	shl    $0x4,%eax
80102dc6:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102dcb:	39 c3                	cmp    %eax,%ebx
80102dcd:	73 4d                	jae    80102e1c <main+0x10c>
    if(c == mycpu())  // We've started already.
80102dcf:	e8 2c 07 00 00       	call   80103500 <mycpu>
80102dd4:	39 c3                	cmp    %eax,%ebx
80102dd6:	74 d8                	je     80102db0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102dd8:	e8 af f5 ff ff       	call   8010238c <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ddd:	05 00 10 00 00       	add    $0x1000,%eax
80102de2:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102de7:	c7 05 f8 6f 00 80 f4 	movl   $0x80102cf4,0x80006ff8
80102dee:	2c 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102df1:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102df8:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102dfb:	83 ec 08             	sub    $0x8,%esp
80102dfe:	68 00 70 00 00       	push   $0x7000
80102e03:	0f b6 03             	movzbl (%ebx),%eax
80102e06:	50                   	push   %eax
80102e07:	e8 7c f8 ff ff       	call   80102688 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e0c:	83 c4 10             	add    $0x10,%esp
80102e0f:	90                   	nop
80102e10:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e16:	85 c0                	test   %eax,%eax
80102e18:	74 f6                	je     80102e10 <main+0x100>
80102e1a:	eb 94                	jmp    80102db0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102e1c:	83 ec 08             	sub    $0x8,%esp
80102e1f:	68 00 00 00 8e       	push   $0x8e000000
80102e24:	68 00 00 40 80       	push   $0x80400000
80102e29:	e8 a6 f4 ff ff       	call   801022d4 <kinit2>
  userinit();      // first user process
80102e2e:	e8 89 07 00 00       	call   801035bc <userinit>
  mpmain();        // finish this processor's setup
80102e33:	e8 80 fe ff ff       	call   80102cb8 <mpmain>

80102e38 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102e38:	55                   	push   %ebp
80102e39:	89 e5                	mov    %esp,%ebp
80102e3b:	57                   	push   %edi
80102e3c:	56                   	push   %esi
80102e3d:	53                   	push   %ebx
80102e3e:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102e41:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102e47:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102e4e:	39 de                	cmp    %ebx,%esi
80102e50:	72 0b                	jb     80102e5d <mpsearch1+0x25>
80102e52:	eb 3c                	jmp    80102e90 <mpsearch1+0x58>
80102e54:	8d 7e 10             	lea    0x10(%esi),%edi
80102e57:	89 fe                	mov    %edi,%esi
80102e59:	39 df                	cmp    %ebx,%edi
80102e5b:	73 33                	jae    80102e90 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102e5d:	50                   	push   %eax
80102e5e:	6a 04                	push   $0x4
80102e60:	68 9f 6d 10 80       	push   $0x80106d9f
80102e65:	56                   	push   %esi
80102e66:	e8 11 15 00 00       	call   8010437c <memcmp>
80102e6b:	83 c4 10             	add    $0x10,%esp
80102e6e:	85 c0                	test   %eax,%eax
80102e70:	75 e2                	jne    80102e54 <mpsearch1+0x1c>
80102e72:	89 f2                	mov    %esi,%edx
80102e74:	8d 7e 10             	lea    0x10(%esi),%edi
80102e77:	90                   	nop
    sum += addr[i];
80102e78:	0f b6 0a             	movzbl (%edx),%ecx
80102e7b:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102e7d:	42                   	inc    %edx
80102e7e:	39 fa                	cmp    %edi,%edx
80102e80:	75 f6                	jne    80102e78 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102e82:	84 c0                	test   %al,%al
80102e84:	75 d1                	jne    80102e57 <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102e86:	89 f0                	mov    %esi,%eax
80102e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e8b:	5b                   	pop    %ebx
80102e8c:	5e                   	pop    %esi
80102e8d:	5f                   	pop    %edi
80102e8e:	5d                   	pop    %ebp
80102e8f:	c3                   	ret
  return 0;
80102e90:	31 f6                	xor    %esi,%esi
}
80102e92:	89 f0                	mov    %esi,%eax
80102e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e97:	5b                   	pop    %ebx
80102e98:	5e                   	pop    %esi
80102e99:	5f                   	pop    %edi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret

80102e9c <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102e9c:	55                   	push   %ebp
80102e9d:	89 e5                	mov    %esp,%ebp
80102e9f:	57                   	push   %edi
80102ea0:	56                   	push   %esi
80102ea1:	53                   	push   %ebx
80102ea2:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ea5:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102eac:	c1 e0 08             	shl    $0x8,%eax
80102eaf:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102eb6:	09 d0                	or     %edx,%eax
80102eb8:	c1 e0 04             	shl    $0x4,%eax
80102ebb:	75 1b                	jne    80102ed8 <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102ebd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ec4:	c1 e0 08             	shl    $0x8,%eax
80102ec7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ece:	09 d0                	or     %edx,%eax
80102ed0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102ed3:	2d 00 04 00 00       	sub    $0x400,%eax
80102ed8:	ba 00 04 00 00       	mov    $0x400,%edx
80102edd:	e8 56 ff ff ff       	call   80102e38 <mpsearch1>
80102ee2:	85 c0                	test   %eax,%eax
80102ee4:	0f 84 26 01 00 00    	je     80103010 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102eea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102ef0:	8b 48 04             	mov    0x4(%eax),%ecx
80102ef3:	85 c9                	test   %ecx,%ecx
80102ef5:	0f 84 a5 00 00 00    	je     80102fa0 <mpinit+0x104>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102efe:	8b 40 04             	mov    0x4(%eax),%eax
80102f01:	05 00 00 00 80       	add    $0x80000000,%eax
80102f06:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f0c:	52                   	push   %edx
80102f0d:	6a 04                	push   $0x4
80102f0f:	68 bc 6d 10 80       	push   $0x80106dbc
80102f14:	50                   	push   %eax
80102f15:	e8 62 14 00 00       	call   8010437c <memcmp>
80102f1a:	89 c2                	mov    %eax,%edx
80102f1c:	83 c4 10             	add    $0x10,%esp
80102f1f:	85 c0                	test   %eax,%eax
80102f21:	75 7d                	jne    80102fa0 <mpinit+0x104>
  if(conf->version != 1 && conf->version != 4)
80102f23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f26:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80102f2a:	74 09                	je     80102f35 <mpinit+0x99>
80102f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f2f:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
80102f33:	75 6b                	jne    80102fa0 <mpinit+0x104>
  if(sum((uchar*)conf, conf->length) != 0)
80102f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f38:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
80102f3f:	66 85 c9             	test   %cx,%cx
80102f42:	74 12                	je     80102f56 <mpinit+0xba>
80102f44:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80102f47:	90                   	nop
    sum += addr[i];
80102f48:	0f b6 08             	movzbl (%eax),%ecx
80102f4b:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102f4d:	40                   	inc    %eax
80102f4e:	39 d8                	cmp    %ebx,%eax
80102f50:	75 f6                	jne    80102f48 <mpinit+0xac>
  if(sum((uchar*)conf, conf->length) != 0)
80102f52:	84 d2                	test   %dl,%dl
80102f54:	75 4a                	jne    80102fa0 <mpinit+0x104>
  *pmp = mp;
80102f56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  return conf;
80102f59:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102f5c:	85 c9                	test   %ecx,%ecx
80102f5e:	74 40                	je     80102fa0 <mpinit+0x104>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102f60:	8b 41 24             	mov    0x24(%ecx),%eax
80102f63:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102f68:	8d 41 2c             	lea    0x2c(%ecx),%eax
80102f6b:	0f b7 51 04          	movzwl 0x4(%ecx),%edx
80102f6f:	01 d1                	add    %edx,%ecx
80102f71:	39 c8                	cmp    %ecx,%eax
80102f73:	72 0e                	jb     80102f83 <mpinit+0xe7>
80102f75:	eb 49                	jmp    80102fc0 <mpinit+0x124>
80102f77:	90                   	nop
    switch(*p){
80102f78:	84 d2                	test   %dl,%dl
80102f7a:	74 64                	je     80102fe0 <mpinit+0x144>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102f7c:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102f7f:	39 c8                	cmp    %ecx,%eax
80102f81:	73 3d                	jae    80102fc0 <mpinit+0x124>
    switch(*p){
80102f83:	8a 10                	mov    (%eax),%dl
80102f85:	80 fa 02             	cmp    $0x2,%dl
80102f88:	74 26                	je     80102fb0 <mpinit+0x114>
80102f8a:	76 ec                	jbe    80102f78 <mpinit+0xdc>
80102f8c:	83 ea 03             	sub    $0x3,%edx
80102f8f:	80 fa 01             	cmp    $0x1,%dl
80102f92:	76 e8                	jbe    80102f7c <mpinit+0xe0>
80102f94:	eb fe                	jmp    80102f94 <mpinit+0xf8>
80102f96:	66 90                	xchg   %ax,%ax
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102f98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102f9f:	90                   	nop
    panic("Expect to run on an SMP");
80102fa0:	83 ec 0c             	sub    $0xc,%esp
80102fa3:	68 a4 6d 10 80       	push   $0x80106da4
80102fa8:	e8 8b d3 ff ff       	call   80100338 <panic>
80102fad:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80102fb0:	8a 50 01             	mov    0x1(%eax),%dl
80102fb3:	88 15 80 17 11 80    	mov    %dl,0x80111780
      p += sizeof(struct mpioapic);
80102fb9:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fbc:	39 c8                	cmp    %ecx,%eax
80102fbe:	72 c3                	jb     80102f83 <mpinit+0xe7>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102fc0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80102fc4:	74 12                	je     80102fd8 <mpinit+0x13c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fc6:	b0 70                	mov    $0x70,%al
80102fc8:	ba 22 00 00 00       	mov    $0x22,%edx
80102fcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fce:	ba 23 00 00 00       	mov    $0x23,%edx
80102fd3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102fd4:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd7:	ee                   	out    %al,(%dx)
  }
}
80102fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdb:	5b                   	pop    %ebx
80102fdc:	5e                   	pop    %esi
80102fdd:	5f                   	pop    %edi
80102fde:	5d                   	pop    %ebp
80102fdf:	c3                   	ret
      if(ncpu < NCPU) {
80102fe0:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102fe6:	83 fa 07             	cmp    $0x7,%edx
80102fe9:	7f 1a                	jg     80103005 <mpinit+0x169>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102feb:	8d 34 92             	lea    (%edx,%edx,4),%esi
80102fee:	01 f6                	add    %esi,%esi
80102ff0:	01 d6                	add    %edx,%esi
80102ff2:	c1 e6 04             	shl    $0x4,%esi
80102ff5:	8a 58 01             	mov    0x1(%eax),%bl
80102ff8:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80102ffe:	42                   	inc    %edx
80102fff:	89 15 84 17 11 80    	mov    %edx,0x80111784
      p += sizeof(struct mpproc);
80103005:	83 c0 14             	add    $0x14,%eax
      continue;
80103008:	e9 72 ff ff ff       	jmp    80102f7f <mpinit+0xe3>
8010300d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103010:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103015:	eb 12                	jmp    80103029 <mpinit+0x18d>
80103017:	90                   	nop
80103018:	8d 73 10             	lea    0x10(%ebx),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
8010301b:	89 f3                	mov    %esi,%ebx
8010301d:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103023:	0f 84 6f ff ff ff    	je     80102f98 <mpinit+0xfc>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103029:	56                   	push   %esi
8010302a:	6a 04                	push   $0x4
8010302c:	68 9f 6d 10 80       	push   $0x80106d9f
80103031:	53                   	push   %ebx
80103032:	e8 45 13 00 00       	call   8010437c <memcmp>
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	85 c0                	test   %eax,%eax
8010303c:	75 da                	jne    80103018 <mpinit+0x17c>
8010303e:	89 da                	mov    %ebx,%edx
80103040:	8d 73 10             	lea    0x10(%ebx),%esi
80103043:	90                   	nop
    sum += addr[i];
80103044:	0f b6 0a             	movzbl (%edx),%ecx
80103047:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103049:	42                   	inc    %edx
8010304a:	39 d6                	cmp    %edx,%esi
8010304c:	75 f6                	jne    80103044 <mpinit+0x1a8>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010304e:	84 c0                	test   %al,%al
80103050:	75 c9                	jne    8010301b <mpinit+0x17f>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103052:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103055:	e9 93 fe ff ff       	jmp    80102eed <mpinit+0x51>
8010305a:	66 90                	xchg   %ax,%ax

8010305c <picinit>:
8010305c:	b0 ff                	mov    $0xff,%al
8010305e:	ba 21 00 00 00       	mov    $0x21,%edx
80103063:	ee                   	out    %al,(%dx)
80103064:	ba a1 00 00 00       	mov    $0xa1,%edx
80103069:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
8010306a:	c3                   	ret
8010306b:	90                   	nop

8010306c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010306c:	55                   	push   %ebp
8010306d:	89 e5                	mov    %esp,%ebp
8010306f:	57                   	push   %edi
80103070:	56                   	push   %esi
80103071:	53                   	push   %ebx
80103072:	83 ec 0c             	sub    $0xc,%esp
80103075:	8b 75 08             	mov    0x8(%ebp),%esi
80103078:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010307b:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103081:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103087:	e8 10 dd ff ff       	call   80100d9c <filealloc>
8010308c:	89 06                	mov    %eax,(%esi)
8010308e:	85 c0                	test   %eax,%eax
80103090:	0f 84 a5 00 00 00    	je     8010313b <pipealloc+0xcf>
80103096:	e8 01 dd ff ff       	call   80100d9c <filealloc>
8010309b:	89 07                	mov    %eax,(%edi)
8010309d:	85 c0                	test   %eax,%eax
8010309f:	0f 84 84 00 00 00    	je     80103129 <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801030a5:	e8 e2 f2 ff ff       	call   8010238c <kalloc>
801030aa:	89 c3                	mov    %eax,%ebx
801030ac:	85 c0                	test   %eax,%eax
801030ae:	0f 84 a0 00 00 00    	je     80103154 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801030b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801030bb:	00 00 00 
  p->writeopen = 1;
801030be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801030c5:	00 00 00 
  p->nwrite = 0;
801030c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801030cf:	00 00 00 
  p->nread = 0;
801030d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801030d9:	00 00 00 
  initlock(&p->lock, "pipe");
801030dc:	83 ec 08             	sub    $0x8,%esp
801030df:	68 c1 6d 10 80       	push   $0x80106dc1
801030e4:	50                   	push   %eax
801030e5:	e8 ba 0f 00 00       	call   801040a4 <initlock>
  (*f0)->type = FD_PIPE;
801030ea:	8b 06                	mov    (%esi),%eax
801030ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801030f2:	8b 06                	mov    (%esi),%eax
801030f4:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801030f8:	8b 06                	mov    (%esi),%eax
801030fa:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801030fe:	8b 06                	mov    (%esi),%eax
80103100:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103103:	8b 07                	mov    (%edi),%eax
80103105:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010310b:	8b 07                	mov    (%edi),%eax
8010310d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103111:	8b 07                	mov    (%edi),%eax
80103113:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103117:	8b 07                	mov    (%edi),%eax
80103119:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
8010311c:	83 c4 10             	add    $0x10,%esp
8010311f:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103121:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103124:	5b                   	pop    %ebx
80103125:	5e                   	pop    %esi
80103126:	5f                   	pop    %edi
80103127:	5d                   	pop    %ebp
80103128:	c3                   	ret
  if(*f0)
80103129:	8b 06                	mov    (%esi),%eax
8010312b:	85 c0                	test   %eax,%eax
8010312d:	74 1e                	je     8010314d <pipealloc+0xe1>
    fileclose(*f0);
8010312f:	83 ec 0c             	sub    $0xc,%esp
80103132:	50                   	push   %eax
80103133:	e8 10 dd ff ff       	call   80100e48 <fileclose>
80103138:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010313b:	8b 07                	mov    (%edi),%eax
8010313d:	85 c0                	test   %eax,%eax
8010313f:	74 0c                	je     8010314d <pipealloc+0xe1>
    fileclose(*f1);
80103141:	83 ec 0c             	sub    $0xc,%esp
80103144:	50                   	push   %eax
80103145:	e8 fe dc ff ff       	call   80100e48 <fileclose>
8010314a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010314d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103152:	eb cd                	jmp    80103121 <pipealloc+0xb5>
  if(*f0)
80103154:	8b 06                	mov    (%esi),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	75 d5                	jne    8010312f <pipealloc+0xc3>
8010315a:	eb df                	jmp    8010313b <pipealloc+0xcf>

8010315c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010315c:	55                   	push   %ebp
8010315d:	89 e5                	mov    %esp,%ebp
8010315f:	56                   	push   %esi
80103160:	53                   	push   %ebx
80103161:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103164:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103167:	83 ec 0c             	sub    $0xc,%esp
8010316a:	53                   	push   %ebx
8010316b:	e8 fc 10 00 00       	call   8010426c <acquire>
  if(writable){
80103170:	83 c4 10             	add    $0x10,%esp
80103173:	85 f6                	test   %esi,%esi
80103175:	74 41                	je     801031b8 <pipeclose+0x5c>
    p->writeopen = 0;
80103177:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010317e:	00 00 00 
    wakeup(&p->nread);
80103181:	83 ec 0c             	sub    $0xc,%esp
80103184:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010318a:	50                   	push   %eax
8010318b:	e8 88 0c 00 00       	call   80103e18 <wakeup>
80103190:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103193:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103199:	85 d2                	test   %edx,%edx
8010319b:	75 0a                	jne    801031a7 <pipeclose+0x4b>
8010319d:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801031a3:	85 c0                	test   %eax,%eax
801031a5:	74 31                	je     801031d8 <pipeclose+0x7c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801031a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801031aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031ad:	5b                   	pop    %ebx
801031ae:	5e                   	pop    %esi
801031af:	5d                   	pop    %ebp
    release(&p->lock);
801031b0:	e9 57 10 00 00       	jmp    8010420c <release>
801031b5:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
801031b8:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801031bf:	00 00 00 
    wakeup(&p->nwrite);
801031c2:	83 ec 0c             	sub    $0xc,%esp
801031c5:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801031cb:	50                   	push   %eax
801031cc:	e8 47 0c 00 00       	call   80103e18 <wakeup>
801031d1:	83 c4 10             	add    $0x10,%esp
801031d4:	eb bd                	jmp    80103193 <pipeclose+0x37>
801031d6:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801031d8:	83 ec 0c             	sub    $0xc,%esp
801031db:	53                   	push   %ebx
801031dc:	e8 2b 10 00 00       	call   8010420c <release>
    kfree((char*)p);
801031e1:	83 c4 10             	add    $0x10,%esp
801031e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801031e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031ea:	5b                   	pop    %ebx
801031eb:	5e                   	pop    %esi
801031ec:	5d                   	pop    %ebp
    kfree((char*)p);
801031ed:	e9 0a f0 ff ff       	jmp    801021fc <kfree>
801031f2:	66 90                	xchg   %ax,%ax

801031f4 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 28             	sub    $0x28,%esp
801031fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103200:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103203:	53                   	push   %ebx
80103204:	e8 63 10 00 00       	call   8010426c <acquire>
  for(i = 0; i < n; i++){
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 ff                	test   %edi,%edi
8010320e:	0f 8e c2 00 00 00    	jle    801032d6 <pipewrite+0xe2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103214:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010321a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010321d:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103220:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103223:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010322c:	89 7d 10             	mov    %edi,0x10(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010322f:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103235:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010323b:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103241:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103244:	0f 85 aa 00 00 00    	jne    801032f4 <pipewrite+0x100>
8010324a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010324d:	eb 37                	jmp    80103286 <pipewrite+0x92>
8010324f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103250:	e8 43 03 00 00       	call   80103598 <myproc>
80103255:	8b 48 34             	mov    0x34(%eax),%ecx
80103258:	85 c9                	test   %ecx,%ecx
8010325a:	75 34                	jne    80103290 <pipewrite+0x9c>
      wakeup(&p->nread);
8010325c:	83 ec 0c             	sub    $0xc,%esp
8010325f:	56                   	push   %esi
80103260:	e8 b3 0b 00 00       	call   80103e18 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103265:	58                   	pop    %eax
80103266:	5a                   	pop    %edx
80103267:	53                   	push   %ebx
80103268:	57                   	push   %edi
80103269:	e8 d6 09 00 00       	call   80103c44 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010326e:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103274:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010327a:	05 00 02 00 00       	add    $0x200,%eax
8010327f:	83 c4 10             	add    $0x10,%esp
80103282:	39 c2                	cmp    %eax,%edx
80103284:	75 26                	jne    801032ac <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103286:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010328c:	85 c0                	test   %eax,%eax
8010328e:	75 c0                	jne    80103250 <pipewrite+0x5c>
        release(&p->lock);
80103290:	83 ec 0c             	sub    $0xc,%esp
80103293:	53                   	push   %ebx
80103294:	e8 73 0f 00 00       	call   8010420c <release>
        return -1;
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801032a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032a4:	5b                   	pop    %ebx
801032a5:	5e                   	pop    %esi
801032a6:	5f                   	pop    %edi
801032a7:	5d                   	pop    %ebp
801032a8:	c3                   	ret
801032a9:	8d 76 00             	lea    0x0(%esi),%esi
801032ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801032af:	8d 42 01             	lea    0x1(%edx),%eax
801032b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032b5:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801032bb:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801032c1:	8a 01                	mov    (%ecx),%al
801032c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801032c7:	41                   	inc    %ecx
801032c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032cb:	39 c1                	cmp    %eax,%ecx
801032cd:	0f 85 5c ff ff ff    	jne    8010322f <pipewrite+0x3b>
801032d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801032df:	50                   	push   %eax
801032e0:	e8 33 0b 00 00       	call   80103e18 <wakeup>
  release(&p->lock);
801032e5:	89 1c 24             	mov    %ebx,(%esp)
801032e8:	e8 1f 0f 00 00       	call   8010420c <release>
  return n;
801032ed:	83 c4 10             	add    $0x10,%esp
801032f0:	89 f8                	mov    %edi,%eax
801032f2:	eb ad                	jmp    801032a1 <pipewrite+0xad>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032f7:	eb b6                	jmp    801032af <pipewrite+0xbb>
801032f9:	8d 76 00             	lea    0x0(%esi),%esi

801032fc <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801032fc:	55                   	push   %ebp
801032fd:	89 e5                	mov    %esp,%ebp
801032ff:	57                   	push   %edi
80103300:	56                   	push   %esi
80103301:	53                   	push   %ebx
80103302:	83 ec 18             	sub    $0x18,%esp
80103305:	8b 75 08             	mov    0x8(%ebp),%esi
80103308:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010330b:	56                   	push   %esi
8010330c:	e8 5b 0f 00 00       	call   8010426c <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103311:	83 c4 10             	add    $0x10,%esp
80103314:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010331a:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103320:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103326:	74 2f                	je     80103357 <piperead+0x5b>
80103328:	eb 37                	jmp    80103361 <piperead+0x65>
8010332a:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
8010332c:	e8 67 02 00 00       	call   80103598 <myproc>
80103331:	8b 40 34             	mov    0x34(%eax),%eax
80103334:	85 c0                	test   %eax,%eax
80103336:	0f 85 80 00 00 00    	jne    801033bc <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010333c:	83 ec 08             	sub    $0x8,%esp
8010333f:	56                   	push   %esi
80103340:	53                   	push   %ebx
80103341:	e8 fe 08 00 00       	call   80103c44 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103346:	83 c4 10             	add    $0x10,%esp
80103349:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010334f:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103355:	75 0a                	jne    80103361 <piperead+0x65>
80103357:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
8010335d:	85 d2                	test   %edx,%edx
8010335f:	75 cb                	jne    8010332c <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103361:	31 db                	xor    %ebx,%ebx
80103363:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103366:	85 c9                	test   %ecx,%ecx
80103368:	7f 23                	jg     8010338d <piperead+0x91>
8010336a:	eb 29                	jmp    80103395 <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010336c:	8d 48 01             	lea    0x1(%eax),%ecx
8010336f:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103375:	25 ff 01 00 00       	and    $0x1ff,%eax
8010337a:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
8010337e:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103381:	43                   	inc    %ebx
80103382:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103385:	74 0e                	je     80103395 <piperead+0x99>
80103387:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
8010338d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103393:	75 d7                	jne    8010336c <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103395:	83 ec 0c             	sub    $0xc,%esp
80103398:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
8010339e:	50                   	push   %eax
8010339f:	e8 74 0a 00 00       	call   80103e18 <wakeup>
  release(&p->lock);
801033a4:	89 34 24             	mov    %esi,(%esp)
801033a7:	e8 60 0e 00 00       	call   8010420c <release>
  return i;
801033ac:	83 c4 10             	add    $0x10,%esp
}
801033af:	89 d8                	mov    %ebx,%eax
801033b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033b4:	5b                   	pop    %ebx
801033b5:	5e                   	pop    %esi
801033b6:	5f                   	pop    %edi
801033b7:	5d                   	pop    %ebp
801033b8:	c3                   	ret
801033b9:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
801033bc:	83 ec 0c             	sub    $0xc,%esp
801033bf:	56                   	push   %esi
801033c0:	e8 47 0e 00 00       	call   8010420c <release>
      return -1;
801033c5:	83 c4 10             	add    $0x10,%esp
801033c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801033cd:	89 d8                	mov    %ebx,%eax
801033cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033d2:	5b                   	pop    %ebx
801033d3:	5e                   	pop    %esi
801033d4:	5f                   	pop    %edi
801033d5:	5d                   	pop    %ebp
801033d6:	c3                   	ret
801033d7:	90                   	nop

801033d8 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801033d8:	55                   	push   %ebp
801033d9:	89 e5                	mov    %esp,%ebp
801033db:	53                   	push   %ebx
801033dc:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801033df:	68 20 1d 11 80       	push   $0x80111d20
801033e4:	e8 83 0e 00 00       	call   8010426c <acquire>
801033e9:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801033ec:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801033f1:	eb 0f                	jmp    80103402 <allocproc+0x2a>
801033f3:	90                   	nop
801033f4:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801033fa:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103400:	74 76                	je     80103478 <allocproc+0xa0>
    if(p->state == UNUSED)
80103402:	8b 4b 1c             	mov    0x1c(%ebx),%ecx
80103405:	85 c9                	test   %ecx,%ecx
80103407:	75 eb                	jne    801033f4 <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103409:	c7 43 1c 01 00 00 00 	movl   $0x1,0x1c(%ebx)
  p->pid = nextpid++;
80103410:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103415:	8d 50 01             	lea    0x1(%eax),%edx
80103418:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010341e:	89 43 20             	mov    %eax,0x20(%ebx)

  release(&ptable.lock);
80103421:	83 ec 0c             	sub    $0xc,%esp
80103424:	68 20 1d 11 80       	push   $0x80111d20
80103429:	e8 de 0d 00 00       	call   8010420c <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010342e:	e8 59 ef ff ff       	call   8010238c <kalloc>
80103433:	89 43 18             	mov    %eax,0x18(%ebx)
80103436:	83 c4 10             	add    $0x10,%esp
80103439:	85 c0                	test   %eax,%eax
8010343b:	74 54                	je     80103491 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010343d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103443:	89 53 28             	mov    %edx,0x28(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103446:	c7 80 b0 0f 00 00 1a 	movl   $0x8010531a,0xfb0(%eax)
8010344d:	53 10 80 

  sp -= sizeof *p->context;
80103450:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103455:	89 43 2c             	mov    %eax,0x2c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103458:	52                   	push   %edx
80103459:	6a 14                	push   $0x14
8010345b:	6a 00                	push   $0x0
8010345d:	50                   	push   %eax
8010345e:	e8 d5 0e 00 00       	call   80104338 <memset>
  p->context->eip = (uint)forkret;
80103463:	8b 43 2c             	mov    0x2c(%ebx),%eax
80103466:	c7 40 10 9c 34 10 80 	movl   $0x8010349c,0x10(%eax)

  return p;
8010346d:	83 c4 10             	add    $0x10,%esp
}
80103470:	89 d8                	mov    %ebx,%eax
80103472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103475:	c9                   	leave
80103476:	c3                   	ret
80103477:	90                   	nop
  release(&ptable.lock);
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	68 20 1d 11 80       	push   $0x80111d20
80103480:	e8 87 0d 00 00       	call   8010420c <release>
  return 0;
80103485:	83 c4 10             	add    $0x10,%esp
80103488:	31 db                	xor    %ebx,%ebx
}
8010348a:	89 d8                	mov    %ebx,%eax
8010348c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010348f:	c9                   	leave
80103490:	c3                   	ret
    p->state = UNUSED;
80103491:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  return 0;
80103498:	31 db                	xor    %ebx,%ebx
8010349a:	eb ee                	jmp    8010348a <allocproc+0xb2>

8010349c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010349c:	55                   	push   %ebp
8010349d:	89 e5                	mov    %esp,%ebp
8010349f:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801034a2:	68 20 1d 11 80       	push   $0x80111d20
801034a7:	e8 60 0d 00 00       	call   8010420c <release>

  if (first) {
801034ac:	83 c4 10             	add    $0x10,%esp
801034af:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801034b4:	85 c0                	test   %eax,%eax
801034b6:	75 04                	jne    801034bc <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801034b8:	c9                   	leave
801034b9:	c3                   	ret
801034ba:	66 90                	xchg   %ax,%ax
    first = 0;
801034bc:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801034c3:	00 00 00 
    iinit(ROOTDEV);
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	6a 01                	push   $0x1
801034cb:	e8 4c df ff ff       	call   8010141c <iinit>
    initlog(ROOTDEV);
801034d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801034d7:	e8 f0 f4 ff ff       	call   801029cc <initlog>
}
801034dc:	83 c4 10             	add    $0x10,%esp
801034df:	c9                   	leave
801034e0:	c3                   	ret
801034e1:	8d 76 00             	lea    0x0(%esi),%esi

801034e4 <pinit>:
{
801034e4:	55                   	push   %ebp
801034e5:	89 e5                	mov    %esp,%ebp
801034e7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801034ea:	68 c6 6d 10 80       	push   $0x80106dc6
801034ef:	68 20 1d 11 80       	push   $0x80111d20
801034f4:	e8 ab 0b 00 00       	call   801040a4 <initlock>
}
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	c9                   	leave
801034fd:	c3                   	ret
801034fe:	66 90                	xchg   %ax,%ax

80103500 <mycpu>:
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103505:	9c                   	pushf
80103506:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103507:	f6 c4 02             	test   $0x2,%ah
8010350a:	75 4b                	jne    80103557 <mycpu+0x57>
  apicid = lapicid();
8010350c:	e8 47 f1 ff ff       	call   80102658 <lapicid>
80103511:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
80103513:	8b 1d 84 17 11 80    	mov    0x80111784,%ebx
80103519:	85 db                	test   %ebx,%ebx
8010351b:	7e 2d                	jle    8010354a <mycpu+0x4a>
8010351d:	31 d2                	xor    %edx,%edx
8010351f:	eb 08                	jmp    80103529 <mycpu+0x29>
80103521:	8d 76 00             	lea    0x0(%esi),%esi
80103524:	42                   	inc    %edx
80103525:	39 da                	cmp    %ebx,%edx
80103527:	74 21                	je     8010354a <mycpu+0x4a>
    if (cpus[i].apicid == apicid)
80103529:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010352c:	01 c0                	add    %eax,%eax
8010352e:	01 d0                	add    %edx,%eax
80103530:	c1 e0 04             	shl    $0x4,%eax
80103533:	0f b6 b0 a0 17 11 80 	movzbl -0x7feee860(%eax),%esi
8010353a:	39 ce                	cmp    %ecx,%esi
8010353c:	75 e6                	jne    80103524 <mycpu+0x24>
      return &cpus[i];
8010353e:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
80103543:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103546:	5b                   	pop    %ebx
80103547:	5e                   	pop    %esi
80103548:	5d                   	pop    %ebp
80103549:	c3                   	ret
  panic("unknown apicid\n");
8010354a:	83 ec 0c             	sub    $0xc,%esp
8010354d:	68 cd 6d 10 80       	push   $0x80106dcd
80103552:	e8 e1 cd ff ff       	call   80100338 <panic>
    panic("mycpu called with interrupts enabled\n");
80103557:	83 ec 0c             	sub    $0xc,%esp
8010355a:	68 50 71 10 80       	push   $0x80107150
8010355f:	e8 d4 cd ff ff       	call   80100338 <panic>

80103564 <cpuid>:
cpuid() {
80103564:	55                   	push   %ebp
80103565:	89 e5                	mov    %esp,%ebp
80103567:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010356a:	e8 91 ff ff ff       	call   80103500 <mycpu>
8010356f:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103574:	c1 f8 04             	sar    $0x4,%eax
80103577:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
8010357a:	89 ca                	mov    %ecx,%edx
8010357c:	c1 e2 05             	shl    $0x5,%edx
8010357f:	29 ca                	sub    %ecx,%edx
80103581:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103584:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103587:	89 ca                	mov    %ecx,%edx
80103589:	c1 e2 0f             	shl    $0xf,%edx
8010358c:	29 ca                	sub    %ecx,%edx
8010358e:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103591:	f7 d8                	neg    %eax
}
80103593:	c9                   	leave
80103594:	c3                   	ret
80103595:	8d 76 00             	lea    0x0(%esi),%esi

80103598 <myproc>:
myproc(void) {
80103598:	55                   	push   %ebp
80103599:	89 e5                	mov    %esp,%ebp
8010359b:	53                   	push   %ebx
8010359c:	50                   	push   %eax
  pushcli();
8010359d:	e8 86 0b 00 00       	call   80104128 <pushcli>
  c = mycpu();
801035a2:	e8 59 ff ff ff       	call   80103500 <mycpu>
  p = c->proc;
801035a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801035ad:	e8 c2 0b 00 00       	call   80104174 <popcli>
}
801035b2:	89 d8                	mov    %ebx,%eax
801035b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035b7:	c9                   	leave
801035b8:	c3                   	ret
801035b9:	8d 76 00             	lea    0x0(%esi),%esi

801035bc <userinit>:
{
801035bc:	55                   	push   %ebp
801035bd:	89 e5                	mov    %esp,%ebp
801035bf:	53                   	push   %ebx
801035c0:	51                   	push   %ecx
  p = allocproc();
801035c1:	e8 12 fe ff ff       	call   801033d8 <allocproc>
801035c6:	89 c3                	mov    %eax,%ebx
  initproc = p;
801035c8:	a3 54 40 11 80       	mov    %eax,0x80114054
  if((p->pgdir = setupkvm()) == 0)
801035cd:	e8 4e 32 00 00       	call   80106820 <setupkvm>
801035d2:	89 43 14             	mov    %eax,0x14(%ebx)
801035d5:	85 c0                	test   %eax,%eax
801035d7:	0f 84 b3 00 00 00    	je     80103690 <userinit+0xd4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801035dd:	52                   	push   %edx
801035de:	68 2c 00 00 00       	push   $0x2c
801035e3:	68 60 a4 10 80       	push   $0x8010a460
801035e8:	50                   	push   %eax
801035e9:	e8 66 2f 00 00       	call   80106554 <inituvm>
  p->sz = PGSIZE;
801035ee:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801035f4:	83 c4 0c             	add    $0xc,%esp
801035f7:	6a 4c                	push   $0x4c
801035f9:	6a 00                	push   $0x0
801035fb:	ff 73 28             	push   0x28(%ebx)
801035fe:	e8 35 0d 00 00       	call   80104338 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103603:	8b 43 28             	mov    0x28(%ebx),%eax
80103606:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010360c:	8b 43 28             	mov    0x28(%ebx),%eax
8010360f:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103615:	8b 43 28             	mov    0x28(%ebx),%eax
80103618:	8b 50 2c             	mov    0x2c(%eax),%edx
8010361b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010361f:	8b 43 28             	mov    0x28(%ebx),%eax
80103622:	8b 50 2c             	mov    0x2c(%eax),%edx
80103625:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103629:	8b 43 28             	mov    0x28(%ebx),%eax
8010362c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103633:	8b 43 28             	mov    0x28(%ebx),%eax
80103636:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010363d:	8b 43 28             	mov    0x28(%ebx),%eax
80103640:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103647:	83 c4 0c             	add    $0xc,%esp
8010364a:	6a 10                	push   $0x10
8010364c:	68 f6 6d 10 80       	push   $0x80106df6
80103651:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103654:	50                   	push   %eax
80103655:	e8 26 0e 00 00       	call   80104480 <safestrcpy>
  p->cwd = namei("/");
8010365a:	c7 04 24 ff 6d 10 80 	movl   $0x80106dff,(%esp)
80103661:	e8 06 e8 ff ff       	call   80101e6c <namei>
80103666:	89 43 78             	mov    %eax,0x78(%ebx)
  acquire(&ptable.lock);
80103669:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103670:	e8 f7 0b 00 00       	call   8010426c <acquire>
  p->state = RUNNABLE;
80103675:	c7 43 1c 03 00 00 00 	movl   $0x3,0x1c(%ebx)
  release(&ptable.lock);
8010367c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103683:	e8 84 0b 00 00       	call   8010420c <release>
}
80103688:	83 c4 10             	add    $0x10,%esp
8010368b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010368e:	c9                   	leave
8010368f:	c3                   	ret
    panic("userinit: out of memory?");
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	68 dd 6d 10 80       	push   $0x80106ddd
80103698:	e8 9b cc ff ff       	call   80100338 <panic>
8010369d:	8d 76 00             	lea    0x0(%esi),%esi

801036a0 <growproc>:
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	56                   	push   %esi
801036a4:	53                   	push   %ebx
801036a5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801036a8:	e8 7b 0a 00 00       	call   80104128 <pushcli>
  c = mycpu();
801036ad:	e8 4e fe ff ff       	call   80103500 <mycpu>
  p = c->proc;
801036b2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036b8:	e8 b7 0a 00 00       	call   80104174 <popcli>
  sz = curproc->sz;
801036bd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801036bf:	85 f6                	test   %esi,%esi
801036c1:	7f 19                	jg     801036dc <growproc+0x3c>
  } else if(n < 0){
801036c3:	75 33                	jne    801036f8 <growproc+0x58>
  curproc->sz = sz;
801036c5:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801036c7:	83 ec 0c             	sub    $0xc,%esp
801036ca:	53                   	push   %ebx
801036cb:	e8 88 2d 00 00       	call   80106458 <switchuvm>
  return 0;
801036d0:	83 c4 10             	add    $0x10,%esp
801036d3:	31 c0                	xor    %eax,%eax
}
801036d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d8:	5b                   	pop    %ebx
801036d9:	5e                   	pop    %esi
801036da:	5d                   	pop    %ebp
801036db:	c3                   	ret
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801036dc:	51                   	push   %ecx
801036dd:	01 c6                	add    %eax,%esi
801036df:	56                   	push   %esi
801036e0:	50                   	push   %eax
801036e1:	ff 73 14             	push   0x14(%ebx)
801036e4:	e8 a3 2f 00 00       	call   8010668c <allocuvm>
801036e9:	83 c4 10             	add    $0x10,%esp
801036ec:	85 c0                	test   %eax,%eax
801036ee:	75 d5                	jne    801036c5 <growproc+0x25>
      return -1;
801036f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036f5:	eb de                	jmp    801036d5 <growproc+0x35>
801036f7:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801036f8:	52                   	push   %edx
801036f9:	01 c6                	add    %eax,%esi
801036fb:	56                   	push   %esi
801036fc:	50                   	push   %eax
801036fd:	ff 73 14             	push   0x14(%ebx)
80103700:	e8 8f 30 00 00       	call   80106794 <deallocuvm>
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 b9                	jne    801036c5 <growproc+0x25>
8010370c:	eb e2                	jmp    801036f0 <growproc+0x50>
8010370e:	66 90                	xchg   %ax,%ax

80103710 <fork>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	57                   	push   %edi
80103714:	56                   	push   %esi
80103715:	53                   	push   %ebx
80103716:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103719:	e8 0a 0a 00 00       	call   80104128 <pushcli>
  c = mycpu();
8010371e:	e8 dd fd ff ff       	call   80103500 <mycpu>
  p = c->proc;
80103723:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103729:	e8 46 0a 00 00       	call   80104174 <popcli>
  if((np = allocproc()) == 0){
8010372e:	e8 a5 fc ff ff       	call   801033d8 <allocproc>
80103733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103736:	85 c0                	test   %eax,%eax
80103738:	0f 84 d4 00 00 00    	je     80103812 <fork+0x102>
8010373e:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103740:	83 ec 08             	sub    $0x8,%esp
80103743:	ff 33                	push   (%ebx)
80103745:	ff 73 14             	push   0x14(%ebx)
80103748:	e8 a7 31 00 00       	call   801068f4 <copyuvm>
8010374d:	89 47 14             	mov    %eax,0x14(%edi)
80103750:	83 c4 10             	add    $0x10,%esp
80103753:	85 c0                	test   %eax,%eax
80103755:	0f 84 98 00 00 00    	je     801037f3 <fork+0xe3>
  np->sz = curproc->sz;
8010375b:	8b 03                	mov    (%ebx),%eax
8010375d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103760:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103762:	89 c8                	mov    %ecx,%eax
80103764:	89 59 24             	mov    %ebx,0x24(%ecx)
  *np->tf = *curproc->tf;
80103767:	8b 73 28             	mov    0x28(%ebx),%esi
8010376a:	8b 79 28             	mov    0x28(%ecx),%edi
8010376d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103772:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103774:	8b 40 28             	mov    0x28(%eax),%eax
80103777:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010377e:	31 f6                	xor    %esi,%esi
    if(curproc->ofile[i])
80103780:	8b 44 b3 38          	mov    0x38(%ebx,%esi,4),%eax
80103784:	85 c0                	test   %eax,%eax
80103786:	74 13                	je     8010379b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103788:	83 ec 0c             	sub    $0xc,%esp
8010378b:	50                   	push   %eax
8010378c:	e8 73 d6 ff ff       	call   80100e04 <filedup>
80103791:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103794:	89 44 b2 38          	mov    %eax,0x38(%edx,%esi,4)
80103798:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
8010379b:	46                   	inc    %esi
8010379c:	83 fe 10             	cmp    $0x10,%esi
8010379f:	75 df                	jne    80103780 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801037a1:	83 ec 0c             	sub    $0xc,%esp
801037a4:	ff 73 78             	push   0x78(%ebx)
801037a7:	e8 44 de ff ff       	call   801015f0 <idup>
801037ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801037af:	89 47 78             	mov    %eax,0x78(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801037b2:	83 c4 0c             	add    $0xc,%esp
801037b5:	6a 10                	push   $0x10
801037b7:	83 c3 7c             	add    $0x7c,%ebx
801037ba:	53                   	push   %ebx
801037bb:	8d 47 7c             	lea    0x7c(%edi),%eax
801037be:	50                   	push   %eax
801037bf:	e8 bc 0c 00 00       	call   80104480 <safestrcpy>
  pid = np->pid;
801037c4:	8b 5f 20             	mov    0x20(%edi),%ebx
  acquire(&ptable.lock);
801037c7:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801037ce:	e8 99 0a 00 00       	call   8010426c <acquire>
  np->state = RUNNABLE;
801037d3:	c7 47 1c 03 00 00 00 	movl   $0x3,0x1c(%edi)
  release(&ptable.lock);
801037da:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801037e1:	e8 26 0a 00 00       	call   8010420c <release>
  return pid;
801037e6:	83 c4 10             	add    $0x10,%esp
}
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ee:	5b                   	pop    %ebx
801037ef:	5e                   	pop    %esi
801037f0:	5f                   	pop    %edi
801037f1:	5d                   	pop    %ebp
801037f2:	c3                   	ret
    kfree(np->kstack);
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801037f9:	ff 73 18             	push   0x18(%ebx)
801037fc:	e8 fb e9 ff ff       	call   801021fc <kfree>
    np->kstack = 0;
80103801:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    np->state = UNUSED;
80103808:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    return -1;
8010380f:	83 c4 10             	add    $0x10,%esp
    return -1;
80103812:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103817:	eb d0                	jmp    801037e9 <fork+0xd9>
80103819:	8d 76 00             	lea    0x0(%esi),%esi

8010381c <send_signal_to_all>:
void send_signal_to_all(int sig){
8010381c:	55                   	push   %ebp
8010381d:	89 e5                	mov    %esp,%ebp
8010381f:	56                   	push   %esi
80103820:	53                   	push   %ebx
80103821:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
80103824:	83 ec 0c             	sub    $0xc,%esp
80103827:	68 20 1d 11 80       	push   $0x80111d20
8010382c:	e8 3b 0a 00 00       	call   8010426c <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103831:	bb d0 1d 11 80       	mov    $0x80111dd0,%ebx
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 2f                	jmp    8010386a <send_signal_to_all+0x4e>
8010383b:	90                   	nop
          switch(sig) {
8010383c:	83 fe 01             	cmp    $0x1,%esi
8010383f:	0f 84 93 00 00 00    	je     801038d8 <send_signal_to_all+0xbc>
80103845:	83 fe 02             	cmp    $0x2,%esi
80103848:	75 12                	jne    8010385c <send_signal_to_all+0x40>
                  if(p->state == RUNNING || p->state == RUNNABLE){
8010384a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010384d:	83 e8 03             	sub    $0x3,%eax
80103850:	83 f8 01             	cmp    $0x1,%eax
80103853:	0f 86 d3 00 00 00    	jbe    8010392c <send_signal_to_all+0x110>
80103859:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010385c:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103862:	81 fb d0 40 11 80    	cmp    $0x801140d0,%ebx
80103868:	74 5b                	je     801038c5 <send_signal_to_all+0xa9>
         if (p->pid == 1 || p->pid == 2) continue;
8010386a:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010386d:	8d 50 ff             	lea    -0x1(%eax),%edx
80103870:	83 fa 01             	cmp    $0x1,%edx
80103873:	76 e7                	jbe    8010385c <send_signal_to_all+0x40>
         if(p->state == UNUSED) continue;
80103875:	8b 53 a0             	mov    -0x60(%ebx),%edx
80103878:	85 d2                	test   %edx,%edx
8010387a:	74 e0                	je     8010385c <send_signal_to_all+0x40>
         cprintf("SIG %d to pid=%d name=%s state=%d\n", sig, p->pid, p->name, p->state);
8010387c:	83 ec 0c             	sub    $0xc,%esp
8010387f:	52                   	push   %edx
80103880:	53                   	push   %ebx
80103881:	50                   	push   %eax
80103882:	56                   	push   %esi
80103883:	68 78 71 10 80       	push   $0x80107178
80103888:	e8 93 cd ff ff       	call   80100620 <cprintf>
          switch(sig) {
8010388d:	83 c4 20             	add    $0x20,%esp
80103890:	83 fe 03             	cmp    $0x3,%esi
80103893:	74 6f                	je     80103904 <send_signal_to_all+0xe8>
80103895:	7e a5                	jle    8010383c <send_signal_to_all+0x20>
80103897:	83 fe 04             	cmp    $0x4,%esi
8010389a:	75 c0                	jne    8010385c <send_signal_to_all+0x40>
                 if(p->signal_handler){
8010389c:	8b 43 8c             	mov    -0x74(%ebx),%eax
8010389f:	85 c0                	test   %eax,%eax
801038a1:	74 b9                	je     8010385c <send_signal_to_all+0x40>
                     p->pending_signal = SIGCUSTOM;
801038a3:	c7 43 88 04 00 00 00 	movl   $0x4,-0x78(%ebx)
                     if(p->state == SLEEPING)
801038aa:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801038ae:	75 ac                	jne    8010385c <send_signal_to_all+0x40>
                        p->state = RUNNABLE;
801038b0:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038b7:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801038bd:	81 fb d0 40 11 80    	cmp    $0x801140d0,%ebx
801038c3:	75 a5                	jne    8010386a <send_signal_to_all+0x4e>
    release(&ptable.lock);
801038c5:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
801038cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038cf:	5b                   	pop    %ebx
801038d0:	5e                   	pop    %esi
801038d1:	5d                   	pop    %ebp
    release(&ptable.lock);
801038d2:	e9 35 09 00 00       	jmp    8010420c <release>
801038d7:	90                   	nop
                p->killed = 1;   // terminate the process
801038d8:	c7 43 b8 01 00 00 00 	movl   $0x1,-0x48(%ebx)
                if(p->state == SLEEPING)
801038df:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801038e3:	75 07                	jne    801038ec <send_signal_to_all+0xd0>
                    p->state = RUNNABLE; // explicitly wake up to terminate
801038e5:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
                cprintf(" -> Terminatedc pid=%d name=%s\n", p->pid, p->name);    
801038ec:	50                   	push   %eax
801038ed:	53                   	push   %ebx
801038ee:	ff 73 a4             	push   -0x5c(%ebx)
801038f1:	68 9c 71 10 80       	push   $0x8010719c
801038f6:	e8 25 cd ff ff       	call   80100620 <cprintf>
                break;
801038fb:	83 c4 10             	add    $0x10,%esp
801038fe:	e9 59 ff ff ff       	jmp    8010385c <send_signal_to_all+0x40>
80103903:	90                   	nop
                  if(p->state == SLEEPING)
80103904:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103908:	0f 85 4e ff ff ff    	jne    8010385c <send_signal_to_all+0x40>
                    cprintf(" -> Resumed pid=%d name=%s\n", p->pid, p->name);  
8010390e:	52                   	push   %edx
8010390f:	53                   	push   %ebx
80103910:	ff 73 a4             	push   -0x5c(%ebx)
80103913:	68 1f 6e 10 80       	push   $0x80106e1f
80103918:	e8 03 cd ff ff       	call   80100620 <cprintf>
                    p->state = RUNNABLE;  // resume suspended process
8010391d:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
80103924:	83 c4 10             	add    $0x10,%esp
80103927:	e9 30 ff ff ff       	jmp    8010385c <send_signal_to_all+0x40>
                      p->state = SLEEPING;
8010392c:	c7 43 a0 02 00 00 00 	movl   $0x2,-0x60(%ebx)
                      cprintf(" -> Suspended pid=%d name=%s\n", p->pid, p->name);
80103933:	51                   	push   %ecx
80103934:	53                   	push   %ebx
80103935:	ff 73 a4             	push   -0x5c(%ebx)
80103938:	68 01 6e 10 80       	push   $0x80106e01
8010393d:	e8 de cc ff ff       	call   80100620 <cprintf>
80103942:	83 c4 10             	add    $0x10,%esp
80103945:	e9 12 ff ff ff       	jmp    8010385c <send_signal_to_all+0x40>
8010394a:	66 90                	xchg   %ax,%ax

8010394c <scheduler>:
{
8010394c:	55                   	push   %ebp
8010394d:	89 e5                	mov    %esp,%ebp
8010394f:	57                   	push   %edi
80103950:	56                   	push   %esi
80103951:	53                   	push   %ebx
80103952:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103955:	e8 a6 fb ff ff       	call   80103500 <mycpu>
8010395a:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010395c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103963:	00 00 00 
80103966:	8d 78 04             	lea    0x4(%eax),%edi
80103969:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
8010396c:	fb                   	sti
    acquire(&ptable.lock);
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 20 1d 11 80       	push   $0x80111d20
80103975:	e8 f2 08 00 00       	call   8010426c <acquire>
8010397a:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010397d:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103982:	eb 56                	jmp    801039da <scheduler+0x8e>
      else if(p->pending_signal == SIGBG){
80103984:	83 f8 02             	cmp    $0x2,%eax
80103987:	0f 84 8f 00 00 00    	je     80103a1c <scheduler+0xd0>
      else if(p->pending_signal == SIGFG){
8010398d:	83 f8 03             	cmp    $0x3,%eax
80103990:	75 07                	jne    80103999 <scheduler+0x4d>
        p->pending_signal = 0;
80103992:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      c->proc = p;
80103999:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010399f:	83 ec 0c             	sub    $0xc,%esp
801039a2:	53                   	push   %ebx
801039a3:	e8 b0 2a 00 00       	call   80106458 <switchuvm>
      p->state = RUNNING;
801039a8:	c7 43 1c 04 00 00 00 	movl   $0x4,0x1c(%ebx)
      swtch(&(c->scheduler), p->context);
801039af:	58                   	pop    %eax
801039b0:	5a                   	pop    %edx
801039b1:	ff 73 2c             	push   0x2c(%ebx)
801039b4:	57                   	push   %edi
801039b5:	e8 13 0b 00 00       	call   801044cd <swtch>
      switchkvm();
801039ba:	e8 89 2a 00 00       	call   80106448 <switchkvm>
      c->proc = 0;
801039bf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039c6:	00 00 00 
801039c9:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039cc:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801039d2:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
801039d8:	74 2a                	je     80103a04 <scheduler+0xb8>
      if(p->state != RUNNABLE  )
801039da:	83 7b 1c 03          	cmpl   $0x3,0x1c(%ebx)
801039de:	75 ec                	jne    801039cc <scheduler+0x80>
      if(p->pending_signal == SIGINT){
801039e0:	8b 43 04             	mov    0x4(%ebx),%eax
801039e3:	83 f8 01             	cmp    $0x1,%eax
801039e6:	75 9c                	jne    80103984 <scheduler+0x38>
        p->killed = 1; 
801039e8:	c7 43 34 01 00 00 00 	movl   $0x1,0x34(%ebx)
        p->pending_signal = 0;
801039ef:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f6:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801039fc:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103a02:	75 d6                	jne    801039da <scheduler+0x8e>
    release(&ptable.lock);
80103a04:	83 ec 0c             	sub    $0xc,%esp
80103a07:	68 20 1d 11 80       	push   $0x80111d20
80103a0c:	e8 fb 07 00 00       	call   8010420c <release>
    sti();
80103a11:	83 c4 10             	add    $0x10,%esp
80103a14:	e9 53 ff ff ff       	jmp    8010396c <scheduler+0x20>
80103a19:	8d 76 00             	lea    0x0(%esi),%esi
        p->state = SLEEPING; 
80103a1c:	c7 43 1c 02 00 00 00 	movl   $0x2,0x1c(%ebx)
        p->pending_signal = 0;
80103a23:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        continue; // Process suspended
80103a2a:	eb a0                	jmp    801039cc <scheduler+0x80>

80103a2c <sched>:
{
80103a2c:	55                   	push   %ebp
80103a2d:	89 e5                	mov    %esp,%ebp
80103a2f:	56                   	push   %esi
80103a30:	53                   	push   %ebx
  pushcli();
80103a31:	e8 f2 06 00 00       	call   80104128 <pushcli>
  c = mycpu();
80103a36:	e8 c5 fa ff ff       	call   80103500 <mycpu>
  p = c->proc;
80103a3b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a41:	e8 2e 07 00 00       	call   80104174 <popcli>
  if(!holding(&ptable.lock))
80103a46:	83 ec 0c             	sub    $0xc,%esp
80103a49:	68 20 1d 11 80       	push   $0x80111d20
80103a4e:	e8 79 07 00 00       	call   801041cc <holding>
80103a53:	83 c4 10             	add    $0x10,%esp
80103a56:	85 c0                	test   %eax,%eax
80103a58:	74 4f                	je     80103aa9 <sched+0x7d>
  if(mycpu()->ncli != 1)
80103a5a:	e8 a1 fa ff ff       	call   80103500 <mycpu>
80103a5f:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a66:	75 68                	jne    80103ad0 <sched+0xa4>
  if(p->state == RUNNING)
80103a68:	83 7b 1c 04          	cmpl   $0x4,0x1c(%ebx)
80103a6c:	74 55                	je     80103ac3 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a6e:	9c                   	pushf
80103a6f:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a70:	f6 c4 02             	test   $0x2,%ah
80103a73:	75 41                	jne    80103ab6 <sched+0x8a>
  intena = mycpu()->intena;
80103a75:	e8 86 fa ff ff       	call   80103500 <mycpu>
80103a7a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a80:	e8 7b fa ff ff       	call   80103500 <mycpu>
80103a85:	83 ec 08             	sub    $0x8,%esp
80103a88:	ff 70 04             	push   0x4(%eax)
80103a8b:	83 c3 2c             	add    $0x2c,%ebx
80103a8e:	53                   	push   %ebx
80103a8f:	e8 39 0a 00 00       	call   801044cd <swtch>
  mycpu()->intena = intena;
80103a94:	e8 67 fa ff ff       	call   80103500 <mycpu>
80103a99:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa5:	5b                   	pop    %ebx
80103aa6:	5e                   	pop    %esi
80103aa7:	5d                   	pop    %ebp
80103aa8:	c3                   	ret
    panic("sched ptable.lock");
80103aa9:	83 ec 0c             	sub    $0xc,%esp
80103aac:	68 3b 6e 10 80       	push   $0x80106e3b
80103ab1:	e8 82 c8 ff ff       	call   80100338 <panic>
    panic("sched interruptible");
80103ab6:	83 ec 0c             	sub    $0xc,%esp
80103ab9:	68 67 6e 10 80       	push   $0x80106e67
80103abe:	e8 75 c8 ff ff       	call   80100338 <panic>
    panic("sched running");
80103ac3:	83 ec 0c             	sub    $0xc,%esp
80103ac6:	68 59 6e 10 80       	push   $0x80106e59
80103acb:	e8 68 c8 ff ff       	call   80100338 <panic>
    panic("sched locks");
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	68 4d 6e 10 80       	push   $0x80106e4d
80103ad8:	e8 5b c8 ff ff       	call   80100338 <panic>
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <exit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ae9:	e8 aa fa ff ff       	call   80103598 <myproc>
  if(curproc == initproc)
80103aee:	39 05 54 40 11 80    	cmp    %eax,0x80114054
80103af4:	0f 84 f3 00 00 00    	je     80103bed <exit+0x10d>
80103afa:	89 c3                	mov    %eax,%ebx
80103afc:	8d 70 38             	lea    0x38(%eax),%esi
80103aff:	8d 78 78             	lea    0x78(%eax),%edi
80103b02:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103b04:	8b 06                	mov    (%esi),%eax
80103b06:	85 c0                	test   %eax,%eax
80103b08:	74 12                	je     80103b1c <exit+0x3c>
      fileclose(curproc->ofile[fd]);
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	50                   	push   %eax
80103b0e:	e8 35 d3 ff ff       	call   80100e48 <fileclose>
      curproc->ofile[fd] = 0;
80103b13:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103b19:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103b1c:	83 c6 04             	add    $0x4,%esi
80103b1f:	39 f7                	cmp    %esi,%edi
80103b21:	75 e1                	jne    80103b04 <exit+0x24>
  begin_op();
80103b23:	e8 34 ef ff ff       	call   80102a5c <begin_op>
  iput(curproc->cwd);
80103b28:	83 ec 0c             	sub    $0xc,%esp
80103b2b:	ff 73 78             	push   0x78(%ebx)
80103b2e:	e8 f5 db ff ff       	call   80101728 <iput>
  end_op();
80103b33:	e8 8c ef ff ff       	call   80102ac4 <end_op>
  curproc->cwd = 0;
80103b38:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
  acquire(&ptable.lock);
80103b3f:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b46:	e8 21 07 00 00       	call   8010426c <acquire>
  wakeup1(curproc->parent);
80103b4b:	8b 53 24             	mov    0x24(%ebx),%edx
80103b4e:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b51:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103b56:	eb 0c                	jmp    80103b64 <exit+0x84>
80103b58:	05 8c 00 00 00       	add    $0x8c,%eax
80103b5d:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103b62:	74 1e                	je     80103b82 <exit+0xa2>
    if(p->state == SLEEPING && p->chan == chan)
80103b64:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103b68:	75 ee                	jne    80103b58 <exit+0x78>
80103b6a:	3b 50 30             	cmp    0x30(%eax),%edx
80103b6d:	75 e9                	jne    80103b58 <exit+0x78>
      p->state = RUNNABLE;
80103b6f:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b76:	05 8c 00 00 00       	add    $0x8c,%eax
80103b7b:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103b80:	75 e2                	jne    80103b64 <exit+0x84>
      p->parent = initproc;
80103b82:	8b 0d 54 40 11 80    	mov    0x80114054,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b88:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103b8d:	eb 0f                	jmp    80103b9e <exit+0xbe>
80103b8f:	90                   	nop
80103b90:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103b96:	81 fa 54 40 11 80    	cmp    $0x80114054,%edx
80103b9c:	74 36                	je     80103bd4 <exit+0xf4>
    if(p->parent == curproc){
80103b9e:	39 5a 24             	cmp    %ebx,0x24(%edx)
80103ba1:	75 ed                	jne    80103b90 <exit+0xb0>
      p->parent = initproc;
80103ba3:	89 4a 24             	mov    %ecx,0x24(%edx)
      if(p->state == ZOMBIE)
80103ba6:	83 7a 1c 05          	cmpl   $0x5,0x1c(%edx)
80103baa:	75 e4                	jne    80103b90 <exit+0xb0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bac:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103bb1:	eb 0d                	jmp    80103bc0 <exit+0xe0>
80103bb3:	90                   	nop
80103bb4:	05 8c 00 00 00       	add    $0x8c,%eax
80103bb9:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103bbe:	74 d0                	je     80103b90 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103bc0:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103bc4:	75 ee                	jne    80103bb4 <exit+0xd4>
80103bc6:	3b 48 30             	cmp    0x30(%eax),%ecx
80103bc9:	75 e9                	jne    80103bb4 <exit+0xd4>
      p->state = RUNNABLE;
80103bcb:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
80103bd2:	eb e0                	jmp    80103bb4 <exit+0xd4>
  curproc->state = ZOMBIE;
80103bd4:	c7 43 1c 05 00 00 00 	movl   $0x5,0x1c(%ebx)
  sched();
80103bdb:	e8 4c fe ff ff       	call   80103a2c <sched>
  panic("zombie exit");
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	68 88 6e 10 80       	push   $0x80106e88
80103be8:	e8 4b c7 ff ff       	call   80100338 <panic>
    panic("init exiting");
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	68 7b 6e 10 80       	push   $0x80106e7b
80103bf5:	e8 3e c7 ff ff       	call   80100338 <panic>
80103bfa:	66 90                	xchg   %ax,%ax

80103bfc <yield>:
{
80103bfc:	55                   	push   %ebp
80103bfd:	89 e5                	mov    %esp,%ebp
80103bff:	53                   	push   %ebx
80103c00:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c03:	68 20 1d 11 80       	push   $0x80111d20
80103c08:	e8 5f 06 00 00       	call   8010426c <acquire>
  pushcli();
80103c0d:	e8 16 05 00 00       	call   80104128 <pushcli>
  c = mycpu();
80103c12:	e8 e9 f8 ff ff       	call   80103500 <mycpu>
  p = c->proc;
80103c17:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c1d:	e8 52 05 00 00       	call   80104174 <popcli>
  myproc()->state = RUNNABLE;
80103c22:	c7 43 1c 03 00 00 00 	movl   $0x3,0x1c(%ebx)
  sched();
80103c29:	e8 fe fd ff ff       	call   80103a2c <sched>
  release(&ptable.lock);
80103c2e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c35:	e8 d2 05 00 00       	call   8010420c <release>
}
80103c3a:	83 c4 10             	add    $0x10,%esp
80103c3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c40:	c9                   	leave
80103c41:	c3                   	ret
80103c42:	66 90                	xchg   %ax,%ax

80103c44 <sleep>:
{
80103c44:	55                   	push   %ebp
80103c45:	89 e5                	mov    %esp,%ebp
80103c47:	57                   	push   %edi
80103c48:	56                   	push   %esi
80103c49:	53                   	push   %ebx
80103c4a:	83 ec 0c             	sub    $0xc,%esp
80103c4d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c50:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103c53:	e8 d0 04 00 00       	call   80104128 <pushcli>
  c = mycpu();
80103c58:	e8 a3 f8 ff ff       	call   80103500 <mycpu>
  p = c->proc;
80103c5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c63:	e8 0c 05 00 00       	call   80104174 <popcli>
  if(p == 0)
80103c68:	85 db                	test   %ebx,%ebx
80103c6a:	0f 84 96 00 00 00    	je     80103d06 <sleep+0xc2>
  if(lk == 0)
80103c70:	85 f6                	test   %esi,%esi
80103c72:	0f 84 81 00 00 00    	je     80103cf9 <sleep+0xb5>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c78:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103c7e:	74 54                	je     80103cd4 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 20 1d 11 80       	push   $0x80111d20
80103c88:	e8 df 05 00 00       	call   8010426c <acquire>
    release(lk);
80103c8d:	89 34 24             	mov    %esi,(%esp)
80103c90:	e8 77 05 00 00       	call   8010420c <release>
  p->chan = chan;
80103c95:	89 7b 30             	mov    %edi,0x30(%ebx)
  p->state = SLEEPING;
80103c98:	c7 43 1c 02 00 00 00 	movl   $0x2,0x1c(%ebx)
  sched();
80103c9f:	e8 88 fd ff ff       	call   80103a2c <sched>
  p->chan = 0;
80103ca4:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
   if(p->killed){
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	8b 53 34             	mov    0x34(%ebx),%edx
80103cb1:	85 d2                	test   %edx,%edx
80103cb3:	75 5e                	jne    80103d13 <sleep+0xcf>
    release(&ptable.lock);
80103cb5:	83 ec 0c             	sub    $0xc,%esp
80103cb8:	68 20 1d 11 80       	push   $0x80111d20
80103cbd:	e8 4a 05 00 00       	call   8010420c <release>
    acquire(lk);
80103cc2:	83 c4 10             	add    $0x10,%esp
80103cc5:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ccb:	5b                   	pop    %ebx
80103ccc:	5e                   	pop    %esi
80103ccd:	5f                   	pop    %edi
80103cce:	5d                   	pop    %ebp
    acquire(lk);
80103ccf:	e9 98 05 00 00       	jmp    8010426c <acquire>
  p->chan = chan;
80103cd4:	89 7b 30             	mov    %edi,0x30(%ebx)
  p->state = SLEEPING;
80103cd7:	c7 43 1c 02 00 00 00 	movl   $0x2,0x1c(%ebx)
  sched();
80103cde:	e8 49 fd ff ff       	call   80103a2c <sched>
  p->chan = 0;
80103ce3:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
   if(p->killed){
80103cea:	8b 43 34             	mov    0x34(%ebx),%eax
80103ced:	85 c0                	test   %eax,%eax
80103cef:	75 22                	jne    80103d13 <sleep+0xcf>
}
80103cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cf4:	5b                   	pop    %ebx
80103cf5:	5e                   	pop    %esi
80103cf6:	5f                   	pop    %edi
80103cf7:	5d                   	pop    %ebp
80103cf8:	c3                   	ret
    panic("sleep without lk");
80103cf9:	83 ec 0c             	sub    $0xc,%esp
80103cfc:	68 9a 6e 10 80       	push   $0x80106e9a
80103d01:	e8 32 c6 ff ff       	call   80100338 <panic>
    panic("sleep");
80103d06:	83 ec 0c             	sub    $0xc,%esp
80103d09:	68 94 6e 10 80       	push   $0x80106e94
80103d0e:	e8 25 c6 ff ff       	call   80100338 <panic>
        release(&ptable.lock);
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	68 20 1d 11 80       	push   $0x80111d20
80103d1b:	e8 ec 04 00 00       	call   8010420c <release>
        exit();
80103d20:	e8 bb fd ff ff       	call   80103ae0 <exit>
80103d25:	8d 76 00             	lea    0x0(%esi),%esi

80103d28 <wait>:
{
80103d28:	55                   	push   %ebp
80103d29:	89 e5                	mov    %esp,%ebp
80103d2b:	56                   	push   %esi
80103d2c:	53                   	push   %ebx
  pushcli();
80103d2d:	e8 f6 03 00 00       	call   80104128 <pushcli>
  c = mycpu();
80103d32:	e8 c9 f7 ff ff       	call   80103500 <mycpu>
  p = c->proc;
80103d37:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d3d:	e8 32 04 00 00       	call   80104174 <popcli>
  acquire(&ptable.lock);
80103d42:	83 ec 0c             	sub    $0xc,%esp
80103d45:	68 20 1d 11 80       	push   $0x80111d20
80103d4a:	e8 1d 05 00 00       	call   8010426c <acquire>
80103d4f:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103d52:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d54:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103d59:	eb 0f                	jmp    80103d6a <wait+0x42>
80103d5b:	90                   	nop
80103d5c:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103d62:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103d68:	74 1e                	je     80103d88 <wait+0x60>
      if(p->parent != curproc)
80103d6a:	39 73 24             	cmp    %esi,0x24(%ebx)
80103d6d:	75 ed                	jne    80103d5c <wait+0x34>
      if(p->state == ZOMBIE){
80103d6f:	83 7b 1c 05          	cmpl   $0x5,0x1c(%ebx)
80103d73:	74 33                	je     80103da8 <wait+0x80>
      havekids = 1;
80103d75:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d7a:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103d80:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103d86:	75 e2                	jne    80103d6a <wait+0x42>
    if(!havekids || curproc->killed){
80103d88:	85 c0                	test   %eax,%eax
80103d8a:	74 72                	je     80103dfe <wait+0xd6>
80103d8c:	8b 46 34             	mov    0x34(%esi),%eax
80103d8f:	85 c0                	test   %eax,%eax
80103d91:	75 6b                	jne    80103dfe <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d93:	83 ec 08             	sub    $0x8,%esp
80103d96:	68 20 1d 11 80       	push   $0x80111d20
80103d9b:	56                   	push   %esi
80103d9c:	e8 a3 fe ff ff       	call   80103c44 <sleep>
    havekids = 0;
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	eb ac                	jmp    80103d52 <wait+0x2a>
80103da6:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80103da8:	8b 73 20             	mov    0x20(%ebx),%esi
        kfree(p->kstack);
80103dab:	83 ec 0c             	sub    $0xc,%esp
80103dae:	ff 73 18             	push   0x18(%ebx)
80103db1:	e8 46 e4 ff ff       	call   801021fc <kfree>
        p->kstack = 0;
80103db6:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        freevm(p->pgdir);
80103dbd:	5a                   	pop    %edx
80103dbe:	ff 73 14             	push   0x14(%ebx)
80103dc1:	e8 ea 29 00 00       	call   801067b0 <freevm>
        p->pid = 0;
80103dc6:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        p->parent = 0;
80103dcd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->name[0] = 0;
80103dd4:	c6 43 7c 00          	movb   $0x0,0x7c(%ebx)
        p->killed = 0;
80103dd8:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
        p->state = UNUSED;
80103ddf:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        release(&ptable.lock);
80103de6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ded:	e8 1a 04 00 00       	call   8010420c <release>
        return pid;
80103df2:	83 c4 10             	add    $0x10,%esp
}
80103df5:	89 f0                	mov    %esi,%eax
80103df7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dfa:	5b                   	pop    %ebx
80103dfb:	5e                   	pop    %esi
80103dfc:	5d                   	pop    %ebp
80103dfd:	c3                   	ret
      release(&ptable.lock);
80103dfe:	83 ec 0c             	sub    $0xc,%esp
80103e01:	68 20 1d 11 80       	push   $0x80111d20
80103e06:	e8 01 04 00 00       	call   8010420c <release>
      return -1;
80103e0b:	83 c4 10             	add    $0x10,%esp
80103e0e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103e13:	eb e0                	jmp    80103df5 <wait+0xcd>
80103e15:	8d 76 00             	lea    0x0(%esi),%esi

80103e18 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e18:	55                   	push   %ebp
80103e19:	89 e5                	mov    %esp,%ebp
80103e1b:	53                   	push   %ebx
80103e1c:	83 ec 10             	sub    $0x10,%esp
80103e1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e22:	68 20 1d 11 80       	push   $0x80111d20
80103e27:	e8 40 04 00 00       	call   8010426c <acquire>
80103e2c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2f:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e34:	eb 0e                	jmp    80103e44 <wakeup+0x2c>
80103e36:	66 90                	xchg   %ax,%ax
80103e38:	05 8c 00 00 00       	add    $0x8c,%eax
80103e3d:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103e42:	74 1e                	je     80103e62 <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103e44:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103e48:	75 ee                	jne    80103e38 <wakeup+0x20>
80103e4a:	3b 58 30             	cmp    0x30(%eax),%ebx
80103e4d:	75 e9                	jne    80103e38 <wakeup+0x20>
      p->state = RUNNABLE;
80103e4f:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e56:	05 8c 00 00 00       	add    $0x8c,%eax
80103e5b:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103e60:	75 e2                	jne    80103e44 <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103e62:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80103e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e6c:	c9                   	leave
  release(&ptable.lock);
80103e6d:	e9 9a 03 00 00       	jmp    8010420c <release>
80103e72:	66 90                	xchg   %ax,%ax

80103e74 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	53                   	push   %ebx
80103e78:	83 ec 10             	sub    $0x10,%esp
80103e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e7e:	68 20 1d 11 80       	push   $0x80111d20
80103e83:	e8 e4 03 00 00       	call   8010426c <acquire>
80103e88:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8b:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e90:	eb 0e                	jmp    80103ea0 <kill+0x2c>
80103e92:	66 90                	xchg   %ax,%ax
80103e94:	05 8c 00 00 00       	add    $0x8c,%eax
80103e99:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103e9e:	74 30                	je     80103ed0 <kill+0x5c>
    if(p->pid == pid){
80103ea0:	39 58 20             	cmp    %ebx,0x20(%eax)
80103ea3:	75 ef                	jne    80103e94 <kill+0x20>
      p->killed = 1;
80103ea5:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103eac:	83 78 1c 02          	cmpl   $0x2,0x1c(%eax)
80103eb0:	75 07                	jne    80103eb9 <kill+0x45>
        p->state = RUNNABLE;
80103eb2:	c7 40 1c 03 00 00 00 	movl   $0x3,0x1c(%eax)
      release(&ptable.lock);
80103eb9:	83 ec 0c             	sub    $0xc,%esp
80103ebc:	68 20 1d 11 80       	push   $0x80111d20
80103ec1:	e8 46 03 00 00       	call   8010420c <release>
      return 0;
80103ec6:	83 c4 10             	add    $0x10,%esp
80103ec9:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ece:	c9                   	leave
80103ecf:	c3                   	ret
  release(&ptable.lock);
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	68 20 1d 11 80       	push   $0x80111d20
80103ed8:	e8 2f 03 00 00       	call   8010420c <release>
  return -1;
80103edd:	83 c4 10             	add    $0x10,%esp
80103ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee8:	c9                   	leave
80103ee9:	c3                   	ret
80103eea:	66 90                	xchg   %ax,%ax

80103eec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103eec:	55                   	push   %ebp
80103eed:	89 e5                	mov    %esp,%ebp
80103eef:	57                   	push   %edi
80103ef0:	56                   	push   %esi
80103ef1:	53                   	push   %ebx
80103ef2:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef5:	bb d0 1d 11 80       	mov    $0x80111dd0,%ebx
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103efa:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103efd:	eb 42                	jmp    80103f41 <procdump+0x55>
80103eff:	90                   	nop
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f00:	8b 04 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%eax
80103f07:	85 c0                	test   %eax,%eax
80103f09:	74 42                	je     80103f4d <procdump+0x61>
    cprintf("%d %s %s", p->pid, state, p->name);
80103f0b:	53                   	push   %ebx
80103f0c:	50                   	push   %eax
80103f0d:	ff 73 a4             	push   -0x5c(%ebx)
80103f10:	68 af 6e 10 80       	push   $0x80106eaf
80103f15:	e8 06 c7 ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
80103f1a:	83 c4 10             	add    $0x10,%esp
80103f1d:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f21:	74 31                	je     80103f54 <procdump+0x68>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f23:	83 ec 0c             	sub    $0xc,%esp
80103f26:	68 61 70 10 80       	push   $0x80107061
80103f2b:	e8 f0 c6 ff ff       	call   80100620 <cprintf>
80103f30:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f33:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103f39:	81 fb d0 40 11 80    	cmp    $0x801140d0,%ebx
80103f3f:	74 4f                	je     80103f90 <procdump+0xa4>
    if(p->state == UNUSED)
80103f41:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f44:	85 c0                	test   %eax,%eax
80103f46:	74 eb                	je     80103f33 <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f48:	83 f8 06             	cmp    $0x6,%eax
80103f4b:	76 b3                	jbe    80103f00 <procdump+0x14>
      state = "???";
80103f4d:	b8 ab 6e 10 80       	mov    $0x80106eab,%eax
80103f52:	eb b7                	jmp    80103f0b <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f54:	83 ec 08             	sub    $0x8,%esp
80103f57:	56                   	push   %esi
80103f58:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f5b:	8b 40 0c             	mov    0xc(%eax),%eax
80103f5e:	83 c0 08             	add    $0x8,%eax
80103f61:	50                   	push   %eax
80103f62:	e8 59 01 00 00       	call   801040c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f67:	89 f7                	mov    %esi,%edi
80103f69:	83 c4 10             	add    $0x10,%esp
80103f6c:	8b 07                	mov    (%edi),%eax
80103f6e:	85 c0                	test   %eax,%eax
80103f70:	74 b1                	je     80103f23 <procdump+0x37>
        cprintf(" %p", pc[i]);
80103f72:	83 ec 08             	sub    $0x8,%esp
80103f75:	50                   	push   %eax
80103f76:	68 41 6b 10 80       	push   $0x80106b41
80103f7b:	e8 a0 c6 ff ff       	call   80100620 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f80:	83 c7 04             	add    $0x4,%edi
80103f83:	83 c4 10             	add    $0x10,%esp
80103f86:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103f89:	39 c7                	cmp    %eax,%edi
80103f8b:	75 df                	jne    80103f6c <procdump+0x80>
80103f8d:	eb 94                	jmp    80103f23 <procdump+0x37>
80103f8f:	90                   	nop
  }
}
80103f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f93:	5b                   	pop    %ebx
80103f94:	5e                   	pop    %esi
80103f95:	5f                   	pop    %edi
80103f96:	5d                   	pop    %ebp
80103f97:	c3                   	ret

80103f98 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f98:	55                   	push   %ebp
80103f99:	89 e5                	mov    %esp,%ebp
80103f9b:	53                   	push   %ebx
80103f9c:	83 ec 0c             	sub    $0xc,%esp
80103f9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103fa2:	68 ea 6e 10 80       	push   $0x80106eea
80103fa7:	8d 43 04             	lea    0x4(%ebx),%eax
80103faa:	50                   	push   %eax
80103fab:	e8 f4 00 00 00       	call   801040a4 <initlock>
  lk->name = name;
80103fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fb3:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103fb6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fbc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103fc3:	83 c4 10             	add    $0x10,%esp
80103fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc9:	c9                   	leave
80103fca:	c3                   	ret
80103fcb:	90                   	nop

80103fcc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fcc:	55                   	push   %ebp
80103fcd:	89 e5                	mov    %esp,%ebp
80103fcf:	56                   	push   %esi
80103fd0:	53                   	push   %ebx
80103fd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fd4:	8d 73 04             	lea    0x4(%ebx),%esi
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	56                   	push   %esi
80103fdb:	e8 8c 02 00 00       	call   8010426c <acquire>
  while (lk->locked) {
80103fe0:	83 c4 10             	add    $0x10,%esp
80103fe3:	8b 13                	mov    (%ebx),%edx
80103fe5:	85 d2                	test   %edx,%edx
80103fe7:	74 16                	je     80103fff <acquiresleep+0x33>
80103fe9:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103fec:	83 ec 08             	sub    $0x8,%esp
80103fef:	56                   	push   %esi
80103ff0:	53                   	push   %ebx
80103ff1:	e8 4e fc ff ff       	call   80103c44 <sleep>
  while (lk->locked) {
80103ff6:	83 c4 10             	add    $0x10,%esp
80103ff9:	8b 03                	mov    (%ebx),%eax
80103ffb:	85 c0                	test   %eax,%eax
80103ffd:	75 ed                	jne    80103fec <acquiresleep+0x20>
  }
  lk->locked = 1;
80103fff:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104005:	e8 8e f5 ff ff       	call   80103598 <myproc>
8010400a:	8b 40 20             	mov    0x20(%eax),%eax
8010400d:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104010:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104013:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104016:	5b                   	pop    %ebx
80104017:	5e                   	pop    %esi
80104018:	5d                   	pop    %ebp
  release(&lk->lk);
80104019:	e9 ee 01 00 00       	jmp    8010420c <release>
8010401e:	66 90                	xchg   %ax,%ax

80104020 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
80104025:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104028:	8d 73 04             	lea    0x4(%ebx),%esi
8010402b:	83 ec 0c             	sub    $0xc,%esp
8010402e:	56                   	push   %esi
8010402f:	e8 38 02 00 00       	call   8010426c <acquire>
  lk->locked = 0;
80104034:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010403a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104041:	89 1c 24             	mov    %ebx,(%esp)
80104044:	e8 cf fd ff ff       	call   80103e18 <wakeup>
  release(&lk->lk);
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010404f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104052:	5b                   	pop    %ebx
80104053:	5e                   	pop    %esi
80104054:	5d                   	pop    %ebp
  release(&lk->lk);
80104055:	e9 b2 01 00 00       	jmp    8010420c <release>
8010405a:	66 90                	xchg   %ax,%ax

8010405c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010405c:	55                   	push   %ebp
8010405d:	89 e5                	mov    %esp,%ebp
8010405f:	56                   	push   %esi
80104060:	53                   	push   %ebx
80104061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104064:	8d 73 04             	lea    0x4(%ebx),%esi
80104067:	83 ec 0c             	sub    $0xc,%esp
8010406a:	56                   	push   %esi
8010406b:	e8 fc 01 00 00       	call   8010426c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	8b 03                	mov    (%ebx),%eax
80104075:	85 c0                	test   %eax,%eax
80104077:	75 17                	jne    80104090 <holdingsleep+0x34>
80104079:	31 db                	xor    %ebx,%ebx
  release(&lk->lk);
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	56                   	push   %esi
8010407f:	e8 88 01 00 00       	call   8010420c <release>
  return r;
}
80104084:	89 d8                	mov    %ebx,%eax
80104086:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret
8010408d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104090:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104093:	e8 00 f5 ff ff       	call   80103598 <myproc>
80104098:	39 58 20             	cmp    %ebx,0x20(%eax)
8010409b:	0f 94 c3             	sete   %bl
8010409e:	0f b6 db             	movzbl %bl,%ebx
801040a1:	eb d8                	jmp    8010407b <holdingsleep+0x1f>
801040a3:	90                   	nop

801040a4 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801040ad:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801040b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801040b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040bd:	5d                   	pop    %ebp
801040be:	c3                   	ret
801040bf:	90                   	nop

801040c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040c7:	8b 45 08             	mov    0x8(%ebp),%eax
801040ca:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801040cd:	31 d2                	xor    %edx,%edx
801040cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040d0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801040d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040dc:	77 16                	ja     801040f4 <getcallerpcs+0x34>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040de:	8b 58 04             	mov    0x4(%eax),%ebx
801040e1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801040e4:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801040e6:	42                   	inc    %edx
801040e7:	83 fa 0a             	cmp    $0xa,%edx
801040ea:	75 e4                	jne    801040d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ef:	c9                   	leave
801040f0:	c3                   	ret
801040f1:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801040f4:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801040f7:	83 c1 28             	add    $0x28,%ecx
801040fa:	89 ca                	mov    %ecx,%edx
801040fc:	29 c2                	sub    %eax,%edx
801040fe:	83 e2 04             	and    $0x4,%edx
80104101:	74 0d                	je     80104110 <getcallerpcs+0x50>
    pcs[i] = 0;
80104103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104109:	83 c0 04             	add    $0x4,%eax
8010410c:	39 c8                	cmp    %ecx,%eax
8010410e:	74 dc                	je     801040ec <getcallerpcs+0x2c>
    pcs[i] = 0;
80104110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104116:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
8010411d:	83 c0 08             	add    $0x8,%eax
80104120:	39 c8                	cmp    %ecx,%eax
80104122:	75 ec                	jne    80104110 <getcallerpcs+0x50>
80104124:	eb c6                	jmp    801040ec <getcallerpcs+0x2c>
80104126:	66 90                	xchg   %ax,%ax

80104128 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104128:	55                   	push   %ebp
80104129:	89 e5                	mov    %esp,%ebp
8010412b:	53                   	push   %ebx
8010412c:	50                   	push   %eax
8010412d:	9c                   	pushf
8010412e:	5b                   	pop    %ebx
  asm volatile("cli");
8010412f:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104130:	e8 cb f3 ff ff       	call   80103500 <mycpu>
80104135:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010413b:	85 d2                	test   %edx,%edx
8010413d:	74 11                	je     80104150 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010413f:	e8 bc f3 ff ff       	call   80103500 <mycpu>
80104144:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
8010414a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010414d:	c9                   	leave
8010414e:	c3                   	ret
8010414f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104150:	e8 ab f3 ff ff       	call   80103500 <mycpu>
80104155:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010415b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104161:	e8 9a f3 ff ff       	call   80103500 <mycpu>
80104166:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
8010416c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010416f:	c9                   	leave
80104170:	c3                   	ret
80104171:	8d 76 00             	lea    0x0(%esi),%esi

80104174 <popcli>:

void
popcli(void)
{
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010417a:	9c                   	pushf
8010417b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010417c:	f6 c4 02             	test   $0x2,%ah
8010417f:	75 31                	jne    801041b2 <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104181:	e8 7a f3 ff ff       	call   80103500 <mycpu>
80104186:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
8010418c:	78 31                	js     801041bf <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010418e:	e8 6d f3 ff ff       	call   80103500 <mycpu>
80104193:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104199:	85 d2                	test   %edx,%edx
8010419b:	74 03                	je     801041a0 <popcli+0x2c>
    sti();
}
8010419d:	c9                   	leave
8010419e:	c3                   	ret
8010419f:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041a0:	e8 5b f3 ff ff       	call   80103500 <mycpu>
801041a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041ab:	85 c0                	test   %eax,%eax
801041ad:	74 ee                	je     8010419d <popcli+0x29>
  asm volatile("sti");
801041af:	fb                   	sti
}
801041b0:	c9                   	leave
801041b1:	c3                   	ret
    panic("popcli - interruptible");
801041b2:	83 ec 0c             	sub    $0xc,%esp
801041b5:	68 f5 6e 10 80       	push   $0x80106ef5
801041ba:	e8 79 c1 ff ff       	call   80100338 <panic>
    panic("popcli");
801041bf:	83 ec 0c             	sub    $0xc,%esp
801041c2:	68 0c 6f 10 80       	push   $0x80106f0c
801041c7:	e8 6c c1 ff ff       	call   80100338 <panic>

801041cc <holding>:
{
801041cc:	55                   	push   %ebp
801041cd:	89 e5                	mov    %esp,%ebp
801041cf:	53                   	push   %ebx
801041d0:	50                   	push   %eax
801041d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801041d4:	e8 4f ff ff ff       	call   80104128 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801041d9:	8b 13                	mov    (%ebx),%edx
801041db:	85 d2                	test   %edx,%edx
801041dd:	75 11                	jne    801041f0 <holding+0x24>
801041df:	31 db                	xor    %ebx,%ebx
  popcli();
801041e1:	e8 8e ff ff ff       	call   80104174 <popcli>
}
801041e6:	89 d8                	mov    %ebx,%eax
801041e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041eb:	c9                   	leave
801041ec:	c3                   	ret
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801041f0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801041f3:	e8 08 f3 ff ff       	call   80103500 <mycpu>
801041f8:	39 c3                	cmp    %eax,%ebx
801041fa:	0f 94 c3             	sete   %bl
801041fd:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104200:	e8 6f ff ff ff       	call   80104174 <popcli>
}
80104205:	89 d8                	mov    %ebx,%eax
80104207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010420a:	c9                   	leave
8010420b:	c3                   	ret

8010420c <release>:
{
8010420c:	55                   	push   %ebp
8010420d:	89 e5                	mov    %esp,%ebp
8010420f:	56                   	push   %esi
80104210:	53                   	push   %ebx
80104211:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104214:	e8 0f ff ff ff       	call   80104128 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104219:	8b 03                	mov    (%ebx),%eax
8010421b:	85 c0                	test   %eax,%eax
8010421d:	75 15                	jne    80104234 <release+0x28>
  popcli();
8010421f:	e8 50 ff ff ff       	call   80104174 <popcli>
    panic("release");
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 13 6f 10 80       	push   $0x80106f13
8010422c:	e8 07 c1 ff ff       	call   80100338 <panic>
80104231:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104234:	8b 73 08             	mov    0x8(%ebx),%esi
80104237:	e8 c4 f2 ff ff       	call   80103500 <mycpu>
8010423c:	39 c6                	cmp    %eax,%esi
8010423e:	75 df                	jne    8010421f <release+0x13>
  popcli();
80104240:	e8 2f ff ff ff       	call   80104174 <popcli>
  lk->pcs[0] = 0;
80104245:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010424c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104253:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104258:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010425e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104261:	5b                   	pop    %ebx
80104262:	5e                   	pop    %esi
80104263:	5d                   	pop    %ebp
  popcli();
80104264:	e9 0b ff ff ff       	jmp    80104174 <popcli>
80104269:	8d 76 00             	lea    0x0(%esi),%esi

8010426c <acquire>:
{
8010426c:	55                   	push   %ebp
8010426d:	89 e5                	mov    %esp,%ebp
8010426f:	53                   	push   %ebx
80104270:	50                   	push   %eax
  pushcli(); // disable interrupts to avoid deadlock.
80104271:	e8 b2 fe ff ff       	call   80104128 <pushcli>
  if(holding(lk))
80104276:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104279:	e8 aa fe ff ff       	call   80104128 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010427e:	8b 13                	mov    (%ebx),%edx
80104280:	85 d2                	test   %edx,%edx
80104282:	0f 85 8c 00 00 00    	jne    80104314 <acquire+0xa8>
  popcli();
80104288:	e8 e7 fe ff ff       	call   80104174 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010428d:	b9 01 00 00 00       	mov    $0x1,%ecx
80104292:	66 90                	xchg   %ax,%ax
  while(xchg(&lk->locked, 1) != 0)
80104294:	8b 55 08             	mov    0x8(%ebp),%edx
80104297:	89 c8                	mov    %ecx,%eax
80104299:	f0 87 02             	lock xchg %eax,(%edx)
8010429c:	85 c0                	test   %eax,%eax
8010429e:	75 f4                	jne    80104294 <acquire+0x28>
  __sync_synchronize();
801042a0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801042a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042a8:	e8 53 f2 ff ff       	call   80103500 <mycpu>
801042ad:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801042b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801042b3:	31 c0                	xor    %eax,%eax
  ebp = (uint*)v - 2;
801042b5:	89 ea                	mov    %ebp,%edx
801042b7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042c4:	77 16                	ja     801042dc <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801042c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801042c9:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801042cd:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801042cf:	40                   	inc    %eax
801042d0:	83 f8 0a             	cmp    $0xa,%eax
801042d3:	75 e3                	jne    801042b8 <acquire+0x4c>
}
801042d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d8:	c9                   	leave
801042d9:	c3                   	ret
801042da:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
801042dc:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801042e0:	83 c1 34             	add    $0x34,%ecx
801042e3:	89 ca                	mov    %ecx,%edx
801042e5:	29 c2                	sub    %eax,%edx
801042e7:	83 e2 04             	and    $0x4,%edx
801042ea:	74 10                	je     801042fc <acquire+0x90>
    pcs[i] = 0;
801042ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801042f2:	83 c0 04             	add    $0x4,%eax
801042f5:	39 c8                	cmp    %ecx,%eax
801042f7:	74 dc                	je     801042d5 <acquire+0x69>
801042f9:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801042fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
80104309:	83 c0 08             	add    $0x8,%eax
8010430c:	39 c8                	cmp    %ecx,%eax
8010430e:	75 ec                	jne    801042fc <acquire+0x90>
80104310:	eb c3                	jmp    801042d5 <acquire+0x69>
80104312:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104314:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104317:	e8 e4 f1 ff ff       	call   80103500 <mycpu>
8010431c:	39 c3                	cmp    %eax,%ebx
8010431e:	0f 85 64 ff ff ff    	jne    80104288 <acquire+0x1c>
  popcli();
80104324:	e8 4b fe ff ff       	call   80104174 <popcli>
    panic("acquire");
80104329:	83 ec 0c             	sub    $0xc,%esp
8010432c:	68 1b 6f 10 80       	push   $0x80106f1b
80104331:	e8 02 c0 ff ff       	call   80100338 <panic>
80104336:	66 90                	xchg   %ax,%ax

80104338 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104338:	55                   	push   %ebp
80104339:	89 e5                	mov    %esp,%ebp
8010433b:	57                   	push   %edi
8010433c:	8b 55 08             	mov    0x8(%ebp),%edx
8010433f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104342:	89 d0                	mov    %edx,%eax
80104344:	09 c8                	or     %ecx,%eax
80104346:	a8 03                	test   $0x3,%al
80104348:	75 22                	jne    8010436c <memset+0x34>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010434a:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
8010434d:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104351:	89 f8                	mov    %edi,%eax
80104353:	c1 e0 08             	shl    $0x8,%eax
80104356:	01 f8                	add    %edi,%eax
80104358:	89 c7                	mov    %eax,%edi
8010435a:	c1 e7 10             	shl    $0x10,%edi
8010435d:	01 f8                	add    %edi,%eax
  asm volatile("cld; rep stosl" :
8010435f:	89 d7                	mov    %edx,%edi
80104361:	fc                   	cld
80104362:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104364:	89 d0                	mov    %edx,%eax
80104366:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104369:	c9                   	leave
8010436a:	c3                   	ret
8010436b:	90                   	nop
  asm volatile("cld; rep stosb" :
8010436c:	89 d7                	mov    %edx,%edi
8010436e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104371:	fc                   	cld
80104372:	f3 aa                	rep stos %al,%es:(%edi)
80104374:	89 d0                	mov    %edx,%eax
80104376:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104379:	c9                   	leave
8010437a:	c3                   	ret
8010437b:	90                   	nop

8010437c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010437c:	55                   	push   %ebp
8010437d:	89 e5                	mov    %esp,%ebp
8010437f:	56                   	push   %esi
80104380:	53                   	push   %ebx
80104381:	8b 45 08             	mov    0x8(%ebp),%eax
80104384:	8b 55 0c             	mov    0xc(%ebp),%edx
80104387:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010438a:	85 f6                	test   %esi,%esi
8010438c:	74 1e                	je     801043ac <memcmp+0x30>
8010438e:	01 c6                	add    %eax,%esi
80104390:	eb 08                	jmp    8010439a <memcmp+0x1e>
80104392:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104394:	40                   	inc    %eax
80104395:	42                   	inc    %edx
  while(n-- > 0){
80104396:	39 f0                	cmp    %esi,%eax
80104398:	74 12                	je     801043ac <memcmp+0x30>
    if(*s1 != *s2)
8010439a:	8a 08                	mov    (%eax),%cl
8010439c:	0f b6 1a             	movzbl (%edx),%ebx
8010439f:	38 d9                	cmp    %bl,%cl
801043a1:	74 f1                	je     80104394 <memcmp+0x18>
      return *s1 - *s2;
801043a3:	0f b6 c1             	movzbl %cl,%eax
801043a6:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801043a8:	5b                   	pop    %ebx
801043a9:	5e                   	pop    %esi
801043aa:	5d                   	pop    %ebp
801043ab:	c3                   	ret
  return 0;
801043ac:	31 c0                	xor    %eax,%eax
}
801043ae:	5b                   	pop    %ebx
801043af:	5e                   	pop    %esi
801043b0:	5d                   	pop    %ebp
801043b1:	c3                   	ret
801043b2:	66 90                	xchg   %ax,%ax

801043b4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	57                   	push   %edi
801043b8:	56                   	push   %esi
801043b9:	8b 55 08             	mov    0x8(%ebp),%edx
801043bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801043bf:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043c2:	39 d6                	cmp    %edx,%esi
801043c4:	73 22                	jae    801043e8 <memmove+0x34>
801043c6:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801043c9:	39 ca                	cmp    %ecx,%edx
801043cb:	73 1b                	jae    801043e8 <memmove+0x34>
    s += n;
    d += n;
    while(n-- > 0)
801043cd:	85 c0                	test   %eax,%eax
801043cf:	74 0e                	je     801043df <memmove+0x2b>
801043d1:	48                   	dec    %eax
801043d2:	66 90                	xchg   %ax,%ax
      *--d = *--s;
801043d4:	8a 0c 06             	mov    (%esi,%eax,1),%cl
801043d7:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801043da:	83 e8 01             	sub    $0x1,%eax
801043dd:	73 f5                	jae    801043d4 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043df:	89 d0                	mov    %edx,%eax
801043e1:	5e                   	pop    %esi
801043e2:	5f                   	pop    %edi
801043e3:	5d                   	pop    %ebp
801043e4:	c3                   	ret
801043e5:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801043e8:	85 c0                	test   %eax,%eax
801043ea:	74 f3                	je     801043df <memmove+0x2b>
801043ec:	01 f0                	add    %esi,%eax
801043ee:	89 d7                	mov    %edx,%edi
      *d++ = *s++;
801043f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801043f1:	39 f0                	cmp    %esi,%eax
801043f3:	75 fb                	jne    801043f0 <memmove+0x3c>
}
801043f5:	89 d0                	mov    %edx,%eax
801043f7:	5e                   	pop    %esi
801043f8:	5f                   	pop    %edi
801043f9:	5d                   	pop    %ebp
801043fa:	c3                   	ret
801043fb:	90                   	nop

801043fc <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801043fc:	eb b6                	jmp    801043b4 <memmove>
801043fe:	66 90                	xchg   %ax,%ax

80104400 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	8b 45 08             	mov    0x8(%ebp),%eax
80104407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010440a:	8b 55 10             	mov    0x10(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010440d:	85 d2                	test   %edx,%edx
8010440f:	75 0c                	jne    8010441d <strncmp+0x1d>
80104411:	eb 1d                	jmp    80104430 <strncmp+0x30>
80104413:	90                   	nop
80104414:	3a 19                	cmp    (%ecx),%bl
80104416:	75 0b                	jne    80104423 <strncmp+0x23>
    n--, p++, q++;
80104418:	40                   	inc    %eax
80104419:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
8010441a:	4a                   	dec    %edx
8010441b:	74 13                	je     80104430 <strncmp+0x30>
8010441d:	8a 18                	mov    (%eax),%bl
8010441f:	84 db                	test   %bl,%bl
80104421:	75 f1                	jne    80104414 <strncmp+0x14>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104423:	0f b6 00             	movzbl (%eax),%eax
80104426:	0f b6 11             	movzbl (%ecx),%edx
80104429:	29 d0                	sub    %edx,%eax
}
8010442b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010442e:	c9                   	leave
8010442f:	c3                   	ret
    return 0;
80104430:	31 c0                	xor    %eax,%eax
}
80104432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104435:	c9                   	leave
80104436:	c3                   	ret
80104437:	90                   	nop

80104438 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104438:	55                   	push   %ebp
80104439:	89 e5                	mov    %esp,%ebp
8010443b:	56                   	push   %esi
8010443c:	53                   	push   %ebx
8010443d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104440:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104443:	8b 55 08             	mov    0x8(%ebp),%edx
80104446:	eb 0c                	jmp    80104454 <strncpy+0x1c>
80104448:	43                   	inc    %ebx
80104449:	42                   	inc    %edx
8010444a:	8a 43 ff             	mov    -0x1(%ebx),%al
8010444d:	88 42 ff             	mov    %al,-0x1(%edx)
80104450:	84 c0                	test   %al,%al
80104452:	74 10                	je     80104464 <strncpy+0x2c>
80104454:	89 ce                	mov    %ecx,%esi
80104456:	49                   	dec    %ecx
80104457:	85 f6                	test   %esi,%esi
80104459:	7f ed                	jg     80104448 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010445b:	8b 45 08             	mov    0x8(%ebp),%eax
8010445e:	5b                   	pop    %ebx
8010445f:	5e                   	pop    %esi
80104460:	5d                   	pop    %ebp
80104461:	c3                   	ret
80104462:	66 90                	xchg   %ax,%ax
  while(n-- > 0)
80104464:	8d 5c 32 ff          	lea    -0x1(%edx,%esi,1),%ebx
80104468:	85 c9                	test   %ecx,%ecx
8010446a:	74 ef                	je     8010445b <strncpy+0x23>
    *s++ = 0;
8010446c:	42                   	inc    %edx
8010446d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104471:	89 d9                	mov    %ebx,%ecx
80104473:	29 d1                	sub    %edx,%ecx
80104475:	85 c9                	test   %ecx,%ecx
80104477:	7f f3                	jg     8010446c <strncpy+0x34>
}
80104479:	8b 45 08             	mov    0x8(%ebp),%eax
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret

80104480 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 45 08             	mov    0x8(%ebp),%eax
80104488:	8b 55 0c             	mov    0xc(%ebp),%edx
8010448b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
8010448e:	85 c9                	test   %ecx,%ecx
80104490:	7e 1d                	jle    801044af <safestrcpy+0x2f>
80104492:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104496:	89 c1                	mov    %eax,%ecx
80104498:	eb 0e                	jmp    801044a8 <safestrcpy+0x28>
8010449a:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
8010449c:	42                   	inc    %edx
8010449d:	41                   	inc    %ecx
8010449e:	8a 5a ff             	mov    -0x1(%edx),%bl
801044a1:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044a4:	84 db                	test   %bl,%bl
801044a6:	74 04                	je     801044ac <safestrcpy+0x2c>
801044a8:	39 f2                	cmp    %esi,%edx
801044aa:	75 f0                	jne    8010449c <safestrcpy+0x1c>
    ;
  *s = 0;
801044ac:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044af:	5b                   	pop    %ebx
801044b0:	5e                   	pop    %esi
801044b1:	5d                   	pop    %ebp
801044b2:	c3                   	ret
801044b3:	90                   	nop

801044b4 <strlen>:

int
strlen(const char *s)
{
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801044ba:	31 c0                	xor    %eax,%eax
801044bc:	80 3a 00             	cmpb   $0x0,(%edx)
801044bf:	74 0a                	je     801044cb <strlen+0x17>
801044c1:	8d 76 00             	lea    0x0(%esi),%esi
801044c4:	40                   	inc    %eax
801044c5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044c9:	75 f9                	jne    801044c4 <strlen+0x10>
    ;
  return n;
}
801044cb:	5d                   	pop    %ebp
801044cc:	c3                   	ret

801044cd <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044cd:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044d1:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801044d5:	55                   	push   %ebp
  pushl %ebx
801044d6:	53                   	push   %ebx
  pushl %esi
801044d7:	56                   	push   %esi
  pushl %edi
801044d8:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044d9:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044db:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801044dd:	5f                   	pop    %edi
  popl %esi
801044de:	5e                   	pop    %esi
  popl %ebx
801044df:	5b                   	pop    %ebx
  popl %ebp
801044e0:	5d                   	pop    %ebp
  ret
801044e1:	c3                   	ret
801044e2:	66 90                	xchg   %ax,%ax

801044e4 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	53                   	push   %ebx
801044e8:	50                   	push   %eax
801044e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801044ec:	e8 a7 f0 ff ff       	call   80103598 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801044f1:	8b 00                	mov    (%eax),%eax
801044f3:	39 c3                	cmp    %eax,%ebx
801044f5:	73 15                	jae    8010450c <fetchint+0x28>
801044f7:	8d 53 04             	lea    0x4(%ebx),%edx
801044fa:	39 d0                	cmp    %edx,%eax
801044fc:	72 0e                	jb     8010450c <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801044fe:	8b 13                	mov    (%ebx),%edx
80104500:	8b 45 0c             	mov    0xc(%ebp),%eax
80104503:	89 10                	mov    %edx,(%eax)
  return 0;
80104505:	31 c0                	xor    %eax,%eax
}
80104507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010450a:	c9                   	leave
8010450b:	c3                   	ret
    return -1;
8010450c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104511:	eb f4                	jmp    80104507 <fetchint+0x23>
80104513:	90                   	nop

80104514 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	53                   	push   %ebx
80104518:	50                   	push   %eax
80104519:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010451c:	e8 77 f0 ff ff       	call   80103598 <myproc>

  if(addr >= curproc->sz)
80104521:	3b 18                	cmp    (%eax),%ebx
80104523:	73 23                	jae    80104548 <fetchstr+0x34>
    return -1;
  *pp = (char*)addr;
80104525:	8b 55 0c             	mov    0xc(%ebp),%edx
80104528:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010452a:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010452c:	39 d3                	cmp    %edx,%ebx
8010452e:	73 18                	jae    80104548 <fetchstr+0x34>
80104530:	89 d8                	mov    %ebx,%eax
80104532:	eb 05                	jmp    80104539 <fetchstr+0x25>
80104534:	40                   	inc    %eax
80104535:	39 d0                	cmp    %edx,%eax
80104537:	73 0f                	jae    80104548 <fetchstr+0x34>
    if(*s == 0)
80104539:	80 38 00             	cmpb   $0x0,(%eax)
8010453c:	75 f6                	jne    80104534 <fetchstr+0x20>
      return s - *pp;
8010453e:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104543:	c9                   	leave
80104544:	c3                   	ret
80104545:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010454d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104550:	c9                   	leave
80104551:	c3                   	ret
80104552:	66 90                	xchg   %ax,%ax

80104554 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	56                   	push   %esi
80104558:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104559:	e8 3a f0 ff ff       	call   80103598 <myproc>
8010455e:	8b 40 28             	mov    0x28(%eax),%eax
80104561:	8b 40 44             	mov    0x44(%eax),%eax
80104564:	8b 55 08             	mov    0x8(%ebp),%edx
80104567:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
8010456a:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
8010456d:	e8 26 f0 ff ff       	call   80103598 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104572:	8b 00                	mov    (%eax),%eax
80104574:	39 c6                	cmp    %eax,%esi
80104576:	73 18                	jae    80104590 <argint+0x3c>
80104578:	8d 53 08             	lea    0x8(%ebx),%edx
8010457b:	39 d0                	cmp    %edx,%eax
8010457d:	72 11                	jb     80104590 <argint+0x3c>
  *ip = *(int*)(addr);
8010457f:	8b 53 04             	mov    0x4(%ebx),%edx
80104582:	8b 45 0c             	mov    0xc(%ebp),%eax
80104585:	89 10                	mov    %edx,(%eax)
  return 0;
80104587:	31 c0                	xor    %eax,%eax
}
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104595:	eb f2                	jmp    80104589 <argint+0x35>
80104597:	90                   	nop

80104598 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104598:	55                   	push   %ebp
80104599:	89 e5                	mov    %esp,%ebp
8010459b:	57                   	push   %edi
8010459c:	56                   	push   %esi
8010459d:	53                   	push   %ebx
8010459e:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801045a1:	e8 f2 ef ff ff       	call   80103598 <myproc>
801045a6:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045a8:	e8 eb ef ff ff       	call   80103598 <myproc>
801045ad:	8b 40 28             	mov    0x28(%eax),%eax
801045b0:	8b 40 44             	mov    0x44(%eax),%eax
801045b3:	8b 55 08             	mov    0x8(%ebp),%edx
801045b6:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801045b9:	8d 7b 04             	lea    0x4(%ebx),%edi
  struct proc *curproc = myproc();
801045bc:	e8 d7 ef ff ff       	call   80103598 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045c1:	8b 00                	mov    (%eax),%eax
801045c3:	39 c7                	cmp    %eax,%edi
801045c5:	73 31                	jae    801045f8 <argptr+0x60>
801045c7:	8d 4b 08             	lea    0x8(%ebx),%ecx
801045ca:	39 c8                	cmp    %ecx,%eax
801045cc:	72 2a                	jb     801045f8 <argptr+0x60>
  *ip = *(int*)(addr);
801045ce:	8b 43 04             	mov    0x4(%ebx),%eax
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801045d1:	8b 55 10             	mov    0x10(%ebp),%edx
801045d4:	85 d2                	test   %edx,%edx
801045d6:	78 20                	js     801045f8 <argptr+0x60>
801045d8:	8b 16                	mov    (%esi),%edx
801045da:	39 d0                	cmp    %edx,%eax
801045dc:	73 1a                	jae    801045f8 <argptr+0x60>
801045de:	8b 5d 10             	mov    0x10(%ebp),%ebx
801045e1:	01 c3                	add    %eax,%ebx
801045e3:	39 da                	cmp    %ebx,%edx
801045e5:	72 11                	jb     801045f8 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801045e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801045ea:	89 02                	mov    %eax,(%edx)
  return 0;
801045ec:	31 c0                	xor    %eax,%eax
}
801045ee:	83 c4 0c             	add    $0xc,%esp
801045f1:	5b                   	pop    %ebx
801045f2:	5e                   	pop    %esi
801045f3:	5f                   	pop    %edi
801045f4:	5d                   	pop    %ebp
801045f5:	c3                   	ret
801045f6:	66 90                	xchg   %ax,%ax
    return -1;
801045f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fd:	eb ef                	jmp    801045ee <argptr+0x56>
801045ff:	90                   	nop

80104600 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104605:	e8 8e ef ff ff       	call   80103598 <myproc>
8010460a:	8b 40 28             	mov    0x28(%eax),%eax
8010460d:	8b 40 44             	mov    0x44(%eax),%eax
80104610:	8b 55 08             	mov    0x8(%ebp),%edx
80104613:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104616:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
80104619:	e8 7a ef ff ff       	call   80103598 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010461e:	8b 00                	mov    (%eax),%eax
80104620:	39 c6                	cmp    %eax,%esi
80104622:	73 34                	jae    80104658 <argstr+0x58>
80104624:	8d 53 08             	lea    0x8(%ebx),%edx
80104627:	39 d0                	cmp    %edx,%eax
80104629:	72 2d                	jb     80104658 <argstr+0x58>
  *ip = *(int*)(addr);
8010462b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010462e:	e8 65 ef ff ff       	call   80103598 <myproc>
  if(addr >= curproc->sz)
80104633:	3b 18                	cmp    (%eax),%ebx
80104635:	73 21                	jae    80104658 <argstr+0x58>
  *pp = (char*)addr;
80104637:	8b 55 0c             	mov    0xc(%ebp),%edx
8010463a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010463c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010463e:	39 d3                	cmp    %edx,%ebx
80104640:	73 16                	jae    80104658 <argstr+0x58>
80104642:	89 d8                	mov    %ebx,%eax
80104644:	eb 07                	jmp    8010464d <argstr+0x4d>
80104646:	66 90                	xchg   %ax,%ax
80104648:	40                   	inc    %eax
80104649:	39 d0                	cmp    %edx,%eax
8010464b:	73 0b                	jae    80104658 <argstr+0x58>
    if(*s == 0)
8010464d:	80 38 00             	cmpb   $0x0,(%eax)
80104650:	75 f6                	jne    80104648 <argstr+0x48>
      return s - *pp;
80104652:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104654:	5b                   	pop    %ebx
80104655:	5e                   	pop    %esi
80104656:	5d                   	pop    %ebp
80104657:	c3                   	ret
    return -1;
80104658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010465d:	5b                   	pop    %ebx
8010465e:	5e                   	pop    %esi
8010465f:	5d                   	pop    %ebp
80104660:	c3                   	ret
80104661:	8d 76 00             	lea    0x0(%esi),%esi

80104664 <syscall>:
[SYS_signal] sys_signal,
};

void
syscall(void)
{
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	53                   	push   %ebx
80104668:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
80104669:	e8 2a ef ff ff       	call   80103598 <myproc>
8010466e:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104670:	8b 40 28             	mov    0x28(%eax),%eax
80104673:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104676:	8d 50 ff             	lea    -0x1(%eax),%edx
80104679:	83 fa 15             	cmp    $0x15,%edx
8010467c:	77 1a                	ja     80104698 <syscall+0x34>
8010467e:	8b 14 85 c0 74 10 80 	mov    -0x7fef8b40(,%eax,4),%edx
80104685:	85 d2                	test   %edx,%edx
80104687:	74 0f                	je     80104698 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104689:	ff d2                	call   *%edx
8010468b:	89 c2                	mov    %eax,%edx
8010468d:	8b 43 28             	mov    0x28(%ebx),%eax
80104690:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104696:	c9                   	leave
80104697:	c3                   	ret
    cprintf("%d %s: unknown sys call %d\n",
80104698:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104699:	8d 43 7c             	lea    0x7c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010469c:	50                   	push   %eax
8010469d:	ff 73 20             	push   0x20(%ebx)
801046a0:	68 23 6f 10 80       	push   $0x80106f23
801046a5:	e8 76 bf ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
801046aa:	8b 43 28             	mov    0x28(%ebx),%eax
801046ad:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801046b4:	83 c4 10             	add    $0x10,%esp
}
801046b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ba:	c9                   	leave
801046bb:	c3                   	ret

801046bc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046bc:	55                   	push   %ebp
801046bd:	89 e5                	mov    %esp,%ebp
801046bf:	57                   	push   %edi
801046c0:	56                   	push   %esi
801046c1:	53                   	push   %ebx
801046c2:	83 ec 34             	sub    $0x34,%esp
801046c5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801046c8:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801046cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046ce:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046d1:	8d 7d da             	lea    -0x26(%ebp),%edi
801046d4:	57                   	push   %edi
801046d5:	50                   	push   %eax
801046d6:	e8 a9 d7 ff ff       	call   80101e84 <nameiparent>
801046db:	83 c4 10             	add    $0x10,%esp
801046de:	85 c0                	test   %eax,%eax
801046e0:	74 5a                	je     8010473c <create+0x80>
801046e2:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	50                   	push   %eax
801046e8:	e8 2f cf ff ff       	call   8010161c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801046ed:	83 c4 0c             	add    $0xc,%esp
801046f0:	6a 00                	push   $0x0
801046f2:	57                   	push   %edi
801046f3:	53                   	push   %ebx
801046f4:	e8 27 d4 ff ff       	call   80101b20 <dirlookup>
801046f9:	89 c6                	mov    %eax,%esi
801046fb:	83 c4 10             	add    $0x10,%esp
801046fe:	85 c0                	test   %eax,%eax
80104700:	74 46                	je     80104748 <create+0x8c>
    iunlockput(dp);
80104702:	83 ec 0c             	sub    $0xc,%esp
80104705:	53                   	push   %ebx
80104706:	e8 65 d1 ff ff       	call   80101870 <iunlockput>
    ilock(ip);
8010470b:	89 34 24             	mov    %esi,(%esp)
8010470e:	e8 09 cf ff ff       	call   8010161c <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104713:	83 c4 10             	add    $0x10,%esp
80104716:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010471b:	75 13                	jne    80104730 <create+0x74>
8010471d:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104722:	75 0c                	jne    80104730 <create+0x74>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104724:	89 f0                	mov    %esi,%eax
80104726:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104729:	5b                   	pop    %ebx
8010472a:	5e                   	pop    %esi
8010472b:	5f                   	pop    %edi
8010472c:	5d                   	pop    %ebp
8010472d:	c3                   	ret
8010472e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	56                   	push   %esi
80104734:	e8 37 d1 ff ff       	call   80101870 <iunlockput>
    return 0;
80104739:	83 c4 10             	add    $0x10,%esp
    return 0;
8010473c:	31 f6                	xor    %esi,%esi
}
8010473e:	89 f0                	mov    %esi,%eax
80104740:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104743:	5b                   	pop    %ebx
80104744:	5e                   	pop    %esi
80104745:	5f                   	pop    %edi
80104746:	5d                   	pop    %ebp
80104747:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104748:	83 ec 08             	sub    $0x8,%esp
8010474b:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
8010474f:	50                   	push   %eax
80104750:	ff 33                	push   (%ebx)
80104752:	e8 6d cd ff ff       	call   801014c4 <ialloc>
80104757:	89 c6                	mov    %eax,%esi
80104759:	83 c4 10             	add    $0x10,%esp
8010475c:	85 c0                	test   %eax,%eax
8010475e:	0f 84 a0 00 00 00    	je     80104804 <create+0x148>
  ilock(ip);
80104764:	83 ec 0c             	sub    $0xc,%esp
80104767:	50                   	push   %eax
80104768:	e8 af ce ff ff       	call   8010161c <ilock>
  ip->major = major;
8010476d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104770:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104774:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104777:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
8010477b:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
80104781:	89 34 24             	mov    %esi,(%esp)
80104784:	e8 eb cd ff ff       	call   80101574 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104789:	83 c4 10             	add    $0x10,%esp
8010478c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104791:	74 29                	je     801047bc <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
80104793:	50                   	push   %eax
80104794:	ff 76 04             	push   0x4(%esi)
80104797:	57                   	push   %edi
80104798:	53                   	push   %ebx
80104799:	e8 1e d6 ff ff       	call   80101dbc <dirlink>
8010479e:	83 c4 10             	add    $0x10,%esp
801047a1:	85 c0                	test   %eax,%eax
801047a3:	78 6c                	js     80104811 <create+0x155>
  iunlockput(dp);
801047a5:	83 ec 0c             	sub    $0xc,%esp
801047a8:	53                   	push   %ebx
801047a9:	e8 c2 d0 ff ff       	call   80101870 <iunlockput>
  return ip;
801047ae:	83 c4 10             	add    $0x10,%esp
}
801047b1:	89 f0                	mov    %esi,%eax
801047b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047b6:	5b                   	pop    %ebx
801047b7:	5e                   	pop    %esi
801047b8:	5f                   	pop    %edi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret
801047bb:	90                   	nop
    dp->nlink++;  // for ".."
801047bc:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
801047c0:	83 ec 0c             	sub    $0xc,%esp
801047c3:	53                   	push   %ebx
801047c4:	e8 ab cd ff ff       	call   80101574 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047c9:	83 c4 0c             	add    $0xc,%esp
801047cc:	ff 76 04             	push   0x4(%esi)
801047cf:	68 5b 6f 10 80       	push   $0x80106f5b
801047d4:	56                   	push   %esi
801047d5:	e8 e2 d5 ff ff       	call   80101dbc <dirlink>
801047da:	83 c4 10             	add    $0x10,%esp
801047dd:	85 c0                	test   %eax,%eax
801047df:	78 16                	js     801047f7 <create+0x13b>
801047e1:	52                   	push   %edx
801047e2:	ff 73 04             	push   0x4(%ebx)
801047e5:	68 5a 6f 10 80       	push   $0x80106f5a
801047ea:	56                   	push   %esi
801047eb:	e8 cc d5 ff ff       	call   80101dbc <dirlink>
801047f0:	83 c4 10             	add    $0x10,%esp
801047f3:	85 c0                	test   %eax,%eax
801047f5:	79 9c                	jns    80104793 <create+0xd7>
      panic("create dots");
801047f7:	83 ec 0c             	sub    $0xc,%esp
801047fa:	68 4e 6f 10 80       	push   $0x80106f4e
801047ff:	e8 34 bb ff ff       	call   80100338 <panic>
    panic("create: ialloc");
80104804:	83 ec 0c             	sub    $0xc,%esp
80104807:	68 3f 6f 10 80       	push   $0x80106f3f
8010480c:	e8 27 bb ff ff       	call   80100338 <panic>
    panic("create: dirlink");
80104811:	83 ec 0c             	sub    $0xc,%esp
80104814:	68 5d 6f 10 80       	push   $0x80106f5d
80104819:	e8 1a bb ff ff       	call   80100338 <panic>
8010481e:	66 90                	xchg   %ax,%ax

80104820 <sys_dup>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104828:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010482b:	50                   	push   %eax
8010482c:	6a 00                	push   $0x0
8010482e:	e8 21 fd ff ff       	call   80104554 <argint>
80104833:	83 c4 10             	add    $0x10,%esp
80104836:	85 c0                	test   %eax,%eax
80104838:	78 2c                	js     80104866 <sys_dup+0x46>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010483a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010483e:	77 26                	ja     80104866 <sys_dup+0x46>
80104840:	e8 53 ed ff ff       	call   80103598 <myproc>
80104845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104848:	8b 74 90 38          	mov    0x38(%eax,%edx,4),%esi
8010484c:	85 f6                	test   %esi,%esi
8010484e:	74 16                	je     80104866 <sys_dup+0x46>
  struct proc *curproc = myproc();
80104850:	e8 43 ed ff ff       	call   80103598 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104855:	31 db                	xor    %ebx,%ebx
80104857:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104858:	8b 54 98 38          	mov    0x38(%eax,%ebx,4),%edx
8010485c:	85 d2                	test   %edx,%edx
8010485e:	74 10                	je     80104870 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104860:	43                   	inc    %ebx
80104861:	83 fb 10             	cmp    $0x10,%ebx
80104864:	75 f2                	jne    80104858 <sys_dup+0x38>
    return -1;
80104866:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010486b:	eb 13                	jmp    80104880 <sys_dup+0x60>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104870:	89 74 98 38          	mov    %esi,0x38(%eax,%ebx,4)
  filedup(f);
80104874:	83 ec 0c             	sub    $0xc,%esp
80104877:	56                   	push   %esi
80104878:	e8 87 c5 ff ff       	call   80100e04 <filedup>
  return fd;
8010487d:	83 c4 10             	add    $0x10,%esp
}
80104880:	89 d8                	mov    %ebx,%eax
80104882:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104885:	5b                   	pop    %ebx
80104886:	5e                   	pop    %esi
80104887:	5d                   	pop    %ebp
80104888:	c3                   	ret
80104889:	8d 76 00             	lea    0x0(%esi),%esi

8010488c <sys_read>:
{
8010488c:	55                   	push   %ebp
8010488d:	89 e5                	mov    %esp,%ebp
8010488f:	56                   	push   %esi
80104890:	53                   	push   %ebx
80104891:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104894:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104897:	53                   	push   %ebx
80104898:	6a 00                	push   $0x0
8010489a:	e8 b5 fc ff ff       	call   80104554 <argint>
8010489f:	83 c4 10             	add    $0x10,%esp
801048a2:	85 c0                	test   %eax,%eax
801048a4:	78 56                	js     801048fc <sys_read+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048a6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048aa:	77 50                	ja     801048fc <sys_read+0x70>
801048ac:	e8 e7 ec ff ff       	call   80103598 <myproc>
801048b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048b4:	8b 74 90 38          	mov    0x38(%eax,%edx,4),%esi
801048b8:	85 f6                	test   %esi,%esi
801048ba:	74 40                	je     801048fc <sys_read+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048bc:	83 ec 08             	sub    $0x8,%esp
801048bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048c2:	50                   	push   %eax
801048c3:	6a 02                	push   $0x2
801048c5:	e8 8a fc ff ff       	call   80104554 <argint>
801048ca:	83 c4 10             	add    $0x10,%esp
801048cd:	85 c0                	test   %eax,%eax
801048cf:	78 2b                	js     801048fc <sys_read+0x70>
801048d1:	52                   	push   %edx
801048d2:	ff 75 f0             	push   -0x10(%ebp)
801048d5:	53                   	push   %ebx
801048d6:	6a 01                	push   $0x1
801048d8:	e8 bb fc ff ff       	call   80104598 <argptr>
801048dd:	83 c4 10             	add    $0x10,%esp
801048e0:	85 c0                	test   %eax,%eax
801048e2:	78 18                	js     801048fc <sys_read+0x70>
  return fileread(f, p, n);
801048e4:	50                   	push   %eax
801048e5:	ff 75 f0             	push   -0x10(%ebp)
801048e8:	ff 75 f4             	push   -0xc(%ebp)
801048eb:	56                   	push   %esi
801048ec:	e8 5b c6 ff ff       	call   80100f4c <fileread>
801048f1:	83 c4 10             	add    $0x10,%esp
}
801048f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f7:	5b                   	pop    %ebx
801048f8:	5e                   	pop    %esi
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret
801048fb:	90                   	nop
    return -1;
801048fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104901:	eb f1                	jmp    801048f4 <sys_read+0x68>
80104903:	90                   	nop

80104904 <sys_write>:
{
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	56                   	push   %esi
80104908:	53                   	push   %ebx
80104909:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010490c:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010490f:	53                   	push   %ebx
80104910:	6a 00                	push   $0x0
80104912:	e8 3d fc ff ff       	call   80104554 <argint>
80104917:	83 c4 10             	add    $0x10,%esp
8010491a:	85 c0                	test   %eax,%eax
8010491c:	78 56                	js     80104974 <sys_write+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010491e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104922:	77 50                	ja     80104974 <sys_write+0x70>
80104924:	e8 6f ec ff ff       	call   80103598 <myproc>
80104929:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010492c:	8b 74 90 38          	mov    0x38(%eax,%edx,4),%esi
80104930:	85 f6                	test   %esi,%esi
80104932:	74 40                	je     80104974 <sys_write+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104934:	83 ec 08             	sub    $0x8,%esp
80104937:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010493a:	50                   	push   %eax
8010493b:	6a 02                	push   $0x2
8010493d:	e8 12 fc ff ff       	call   80104554 <argint>
80104942:	83 c4 10             	add    $0x10,%esp
80104945:	85 c0                	test   %eax,%eax
80104947:	78 2b                	js     80104974 <sys_write+0x70>
80104949:	52                   	push   %edx
8010494a:	ff 75 f0             	push   -0x10(%ebp)
8010494d:	53                   	push   %ebx
8010494e:	6a 01                	push   $0x1
80104950:	e8 43 fc ff ff       	call   80104598 <argptr>
80104955:	83 c4 10             	add    $0x10,%esp
80104958:	85 c0                	test   %eax,%eax
8010495a:	78 18                	js     80104974 <sys_write+0x70>
  return filewrite(f, p, n);
8010495c:	50                   	push   %eax
8010495d:	ff 75 f0             	push   -0x10(%ebp)
80104960:	ff 75 f4             	push   -0xc(%ebp)
80104963:	56                   	push   %esi
80104964:	e8 6f c6 ff ff       	call   80100fd8 <filewrite>
80104969:	83 c4 10             	add    $0x10,%esp
}
8010496c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010496f:	5b                   	pop    %ebx
80104970:	5e                   	pop    %esi
80104971:	5d                   	pop    %ebp
80104972:	c3                   	ret
80104973:	90                   	nop
    return -1;
80104974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104979:	eb f1                	jmp    8010496c <sys_write+0x68>
8010497b:	90                   	nop

8010497c <sys_close>:
{
8010497c:	55                   	push   %ebp
8010497d:	89 e5                	mov    %esp,%ebp
8010497f:	56                   	push   %esi
80104980:	53                   	push   %ebx
80104981:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104984:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104987:	50                   	push   %eax
80104988:	6a 00                	push   $0x0
8010498a:	e8 c5 fb ff ff       	call   80104554 <argint>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	78 3e                	js     801049d4 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104996:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010499a:	77 38                	ja     801049d4 <sys_close+0x58>
8010499c:	e8 f7 eb ff ff       	call   80103598 <myproc>
801049a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049a4:	8d 5a 0c             	lea    0xc(%edx),%ebx
801049a7:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801049ab:	85 f6                	test   %esi,%esi
801049ad:	74 25                	je     801049d4 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801049af:	e8 e4 eb ff ff       	call   80103598 <myproc>
801049b4:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801049bb:	00 
  fileclose(f);
801049bc:	83 ec 0c             	sub    $0xc,%esp
801049bf:	56                   	push   %esi
801049c0:	e8 83 c4 ff ff       	call   80100e48 <fileclose>
  return 0;
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	31 c0                	xor    %eax,%eax
}
801049ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049cd:	5b                   	pop    %ebx
801049ce:	5e                   	pop    %esi
801049cf:	5d                   	pop    %ebp
801049d0:	c3                   	ret
801049d1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d9:	eb ef                	jmp    801049ca <sys_close+0x4e>
801049db:	90                   	nop

801049dc <sys_fstat>:
{
801049dc:	55                   	push   %ebp
801049dd:	89 e5                	mov    %esp,%ebp
801049df:	56                   	push   %esi
801049e0:	53                   	push   %ebx
801049e1:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801049e4:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801049e7:	53                   	push   %ebx
801049e8:	6a 00                	push   $0x0
801049ea:	e8 65 fb ff ff       	call   80104554 <argint>
801049ef:	83 c4 10             	add    $0x10,%esp
801049f2:	85 c0                	test   %eax,%eax
801049f4:	78 3e                	js     80104a34 <sys_fstat+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049f6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049fa:	77 38                	ja     80104a34 <sys_fstat+0x58>
801049fc:	e8 97 eb ff ff       	call   80103598 <myproc>
80104a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a04:	8b 74 90 38          	mov    0x38(%eax,%edx,4),%esi
80104a08:	85 f6                	test   %esi,%esi
80104a0a:	74 28                	je     80104a34 <sys_fstat+0x58>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a0c:	50                   	push   %eax
80104a0d:	6a 14                	push   $0x14
80104a0f:	53                   	push   %ebx
80104a10:	6a 01                	push   $0x1
80104a12:	e8 81 fb ff ff       	call   80104598 <argptr>
80104a17:	83 c4 10             	add    $0x10,%esp
80104a1a:	85 c0                	test   %eax,%eax
80104a1c:	78 16                	js     80104a34 <sys_fstat+0x58>
  return filestat(f, st);
80104a1e:	83 ec 08             	sub    $0x8,%esp
80104a21:	ff 75 f4             	push   -0xc(%ebp)
80104a24:	56                   	push   %esi
80104a25:	e8 de c4 ff ff       	call   80100f08 <filestat>
80104a2a:	83 c4 10             	add    $0x10,%esp
}
80104a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a30:	5b                   	pop    %ebx
80104a31:	5e                   	pop    %esi
80104a32:	5d                   	pop    %ebp
80104a33:	c3                   	ret
    return -1;
80104a34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a39:	eb f2                	jmp    80104a2d <sys_fstat+0x51>
80104a3b:	90                   	nop

80104a3c <sys_link>:
{
80104a3c:	55                   	push   %ebp
80104a3d:	89 e5                	mov    %esp,%ebp
80104a3f:	57                   	push   %edi
80104a40:	56                   	push   %esi
80104a41:	53                   	push   %ebx
80104a42:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a45:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a48:	50                   	push   %eax
80104a49:	6a 00                	push   $0x0
80104a4b:	e8 b0 fb ff ff       	call   80104600 <argstr>
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	85 c0                	test   %eax,%eax
80104a55:	0f 88 f2 00 00 00    	js     80104b4d <sys_link+0x111>
80104a5b:	83 ec 08             	sub    $0x8,%esp
80104a5e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a61:	50                   	push   %eax
80104a62:	6a 01                	push   $0x1
80104a64:	e8 97 fb ff ff       	call   80104600 <argstr>
80104a69:	83 c4 10             	add    $0x10,%esp
80104a6c:	85 c0                	test   %eax,%eax
80104a6e:	0f 88 d9 00 00 00    	js     80104b4d <sys_link+0x111>
  begin_op();
80104a74:	e8 e3 df ff ff       	call   80102a5c <begin_op>
  if((ip = namei(old)) == 0){
80104a79:	83 ec 0c             	sub    $0xc,%esp
80104a7c:	ff 75 d4             	push   -0x2c(%ebp)
80104a7f:	e8 e8 d3 ff ff       	call   80101e6c <namei>
80104a84:	89 c3                	mov    %eax,%ebx
80104a86:	83 c4 10             	add    $0x10,%esp
80104a89:	85 c0                	test   %eax,%eax
80104a8b:	0f 84 d6 00 00 00    	je     80104b67 <sys_link+0x12b>
  ilock(ip);
80104a91:	83 ec 0c             	sub    $0xc,%esp
80104a94:	50                   	push   %eax
80104a95:	e8 82 cb ff ff       	call   8010161c <ilock>
  if(ip->type == T_DIR){
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104aa2:	0f 84 ac 00 00 00    	je     80104b54 <sys_link+0x118>
  ip->nlink++;
80104aa8:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104aac:	83 ec 0c             	sub    $0xc,%esp
80104aaf:	53                   	push   %ebx
80104ab0:	e8 bf ca ff ff       	call   80101574 <iupdate>
  iunlock(ip);
80104ab5:	89 1c 24             	mov    %ebx,(%esp)
80104ab8:	e8 27 cc ff ff       	call   801016e4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104abd:	5a                   	pop    %edx
80104abe:	59                   	pop    %ecx
80104abf:	8d 7d da             	lea    -0x26(%ebp),%edi
80104ac2:	57                   	push   %edi
80104ac3:	ff 75 d0             	push   -0x30(%ebp)
80104ac6:	e8 b9 d3 ff ff       	call   80101e84 <nameiparent>
80104acb:	89 c6                	mov    %eax,%esi
80104acd:	83 c4 10             	add    $0x10,%esp
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	74 54                	je     80104b28 <sys_link+0xec>
  ilock(dp);
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	50                   	push   %eax
80104ad8:	e8 3f cb ff ff       	call   8010161c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	8b 03                	mov    (%ebx),%eax
80104ae2:	39 06                	cmp    %eax,(%esi)
80104ae4:	75 36                	jne    80104b1c <sys_link+0xe0>
80104ae6:	50                   	push   %eax
80104ae7:	ff 73 04             	push   0x4(%ebx)
80104aea:	57                   	push   %edi
80104aeb:	56                   	push   %esi
80104aec:	e8 cb d2 ff ff       	call   80101dbc <dirlink>
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	85 c0                	test   %eax,%eax
80104af6:	78 24                	js     80104b1c <sys_link+0xe0>
  iunlockput(dp);
80104af8:	83 ec 0c             	sub    $0xc,%esp
80104afb:	56                   	push   %esi
80104afc:	e8 6f cd ff ff       	call   80101870 <iunlockput>
  iput(ip);
80104b01:	89 1c 24             	mov    %ebx,(%esp)
80104b04:	e8 1f cc ff ff       	call   80101728 <iput>
  end_op();
80104b09:	e8 b6 df ff ff       	call   80102ac4 <end_op>
  return 0;
80104b0e:	83 c4 10             	add    $0x10,%esp
80104b11:	31 c0                	xor    %eax,%eax
}
80104b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b16:	5b                   	pop    %ebx
80104b17:	5e                   	pop    %esi
80104b18:	5f                   	pop    %edi
80104b19:	5d                   	pop    %ebp
80104b1a:	c3                   	ret
80104b1b:	90                   	nop
    iunlockput(dp);
80104b1c:	83 ec 0c             	sub    $0xc,%esp
80104b1f:	56                   	push   %esi
80104b20:	e8 4b cd ff ff       	call   80101870 <iunlockput>
    goto bad;
80104b25:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	53                   	push   %ebx
80104b2c:	e8 eb ca ff ff       	call   8010161c <ilock>
  ip->nlink--;
80104b31:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104b35:	89 1c 24             	mov    %ebx,(%esp)
80104b38:	e8 37 ca ff ff       	call   80101574 <iupdate>
  iunlockput(ip);
80104b3d:	89 1c 24             	mov    %ebx,(%esp)
80104b40:	e8 2b cd ff ff       	call   80101870 <iunlockput>
  end_op();
80104b45:	e8 7a df ff ff       	call   80102ac4 <end_op>
  return -1;
80104b4a:	83 c4 10             	add    $0x10,%esp
    return -1;
80104b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b52:	eb bf                	jmp    80104b13 <sys_link+0xd7>
    iunlockput(ip);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	53                   	push   %ebx
80104b58:	e8 13 cd ff ff       	call   80101870 <iunlockput>
    end_op();
80104b5d:	e8 62 df ff ff       	call   80102ac4 <end_op>
    return -1;
80104b62:	83 c4 10             	add    $0x10,%esp
80104b65:	eb e6                	jmp    80104b4d <sys_link+0x111>
    end_op();
80104b67:	e8 58 df ff ff       	call   80102ac4 <end_op>
    return -1;
80104b6c:	eb df                	jmp    80104b4d <sys_link+0x111>
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <sys_unlink>:
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104b79:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b7c:	50                   	push   %eax
80104b7d:	6a 00                	push   $0x0
80104b7f:	e8 7c fa ff ff       	call   80104600 <argstr>
80104b84:	83 c4 10             	add    $0x10,%esp
80104b87:	85 c0                	test   %eax,%eax
80104b89:	0f 88 50 01 00 00    	js     80104cdf <sys_unlink+0x16f>
  begin_op();
80104b8f:	e8 c8 de ff ff       	call   80102a5c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104b94:	83 ec 08             	sub    $0x8,%esp
80104b97:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104b9a:	53                   	push   %ebx
80104b9b:	ff 75 c0             	push   -0x40(%ebp)
80104b9e:	e8 e1 d2 ff ff       	call   80101e84 <nameiparent>
80104ba3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104ba6:	83 c4 10             	add    $0x10,%esp
80104ba9:	85 c0                	test   %eax,%eax
80104bab:	0f 84 4f 01 00 00    	je     80104d00 <sys_unlink+0x190>
  ilock(dp);
80104bb1:	83 ec 0c             	sub    $0xc,%esp
80104bb4:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80104bb7:	57                   	push   %edi
80104bb8:	e8 5f ca ff ff       	call   8010161c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bbd:	59                   	pop    %ecx
80104bbe:	5e                   	pop    %esi
80104bbf:	68 5b 6f 10 80       	push   $0x80106f5b
80104bc4:	53                   	push   %ebx
80104bc5:	e8 3e cf ff ff       	call   80101b08 <namecmp>
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	0f 84 f7 00 00 00    	je     80104ccc <sys_unlink+0x15c>
80104bd5:	83 ec 08             	sub    $0x8,%esp
80104bd8:	68 5a 6f 10 80       	push   $0x80106f5a
80104bdd:	53                   	push   %ebx
80104bde:	e8 25 cf ff ff       	call   80101b08 <namecmp>
80104be3:	83 c4 10             	add    $0x10,%esp
80104be6:	85 c0                	test   %eax,%eax
80104be8:	0f 84 de 00 00 00    	je     80104ccc <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104bee:	52                   	push   %edx
80104bef:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104bf2:	50                   	push   %eax
80104bf3:	53                   	push   %ebx
80104bf4:	57                   	push   %edi
80104bf5:	e8 26 cf ff ff       	call   80101b20 <dirlookup>
80104bfa:	89 c3                	mov    %eax,%ebx
80104bfc:	83 c4 10             	add    $0x10,%esp
80104bff:	85 c0                	test   %eax,%eax
80104c01:	0f 84 c5 00 00 00    	je     80104ccc <sys_unlink+0x15c>
  ilock(ip);
80104c07:	83 ec 0c             	sub    $0xc,%esp
80104c0a:	50                   	push   %eax
80104c0b:	e8 0c ca ff ff       	call   8010161c <ilock>
  if(ip->nlink < 1)
80104c10:	83 c4 10             	add    $0x10,%esp
80104c13:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c18:	0f 8e f6 00 00 00    	jle    80104d14 <sys_unlink+0x1a4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c1e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c23:	74 67                	je     80104c8c <sys_unlink+0x11c>
80104c25:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
80104c28:	50                   	push   %eax
80104c29:	6a 10                	push   $0x10
80104c2b:	6a 00                	push   $0x0
80104c2d:	57                   	push   %edi
80104c2e:	e8 05 f7 ff ff       	call   80104338 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c33:	6a 10                	push   $0x10
80104c35:	ff 75 c4             	push   -0x3c(%ebp)
80104c38:	57                   	push   %edi
80104c39:	ff 75 b4             	push   -0x4c(%ebp)
80104c3c:	e8 ab cd ff ff       	call   801019ec <writei>
80104c41:	83 c4 20             	add    $0x20,%esp
80104c44:	83 f8 10             	cmp    $0x10,%eax
80104c47:	0f 85 d4 00 00 00    	jne    80104d21 <sys_unlink+0x1b1>
  if(ip->type == T_DIR){
80104c4d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c52:	0f 84 90 00 00 00    	je     80104ce8 <sys_unlink+0x178>
  iunlockput(dp);
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	ff 75 b4             	push   -0x4c(%ebp)
80104c5e:	e8 0d cc ff ff       	call   80101870 <iunlockput>
  ip->nlink--;
80104c63:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104c67:	89 1c 24             	mov    %ebx,(%esp)
80104c6a:	e8 05 c9 ff ff       	call   80101574 <iupdate>
  iunlockput(ip);
80104c6f:	89 1c 24             	mov    %ebx,(%esp)
80104c72:	e8 f9 cb ff ff       	call   80101870 <iunlockput>
  end_op();
80104c77:	e8 48 de ff ff       	call   80102ac4 <end_op>
  return 0;
80104c7c:	83 c4 10             	add    $0x10,%esp
80104c7f:	31 c0                	xor    %eax,%eax
}
80104c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c84:	5b                   	pop    %ebx
80104c85:	5e                   	pop    %esi
80104c86:	5f                   	pop    %edi
80104c87:	5d                   	pop    %ebp
80104c88:	c3                   	ret
80104c89:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104c8c:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104c90:	76 93                	jbe    80104c25 <sys_unlink+0xb5>
80104c92:	be 20 00 00 00       	mov    $0x20,%esi
80104c97:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104c9a:	eb 08                	jmp    80104ca4 <sys_unlink+0x134>
80104c9c:	83 c6 10             	add    $0x10,%esi
80104c9f:	3b 73 58             	cmp    0x58(%ebx),%esi
80104ca2:	73 84                	jae    80104c28 <sys_unlink+0xb8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ca4:	6a 10                	push   $0x10
80104ca6:	56                   	push   %esi
80104ca7:	57                   	push   %edi
80104ca8:	53                   	push   %ebx
80104ca9:	e8 3e cc ff ff       	call   801018ec <readi>
80104cae:	83 c4 10             	add    $0x10,%esp
80104cb1:	83 f8 10             	cmp    $0x10,%eax
80104cb4:	75 51                	jne    80104d07 <sys_unlink+0x197>
    if(de.inum != 0)
80104cb6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104cbb:	74 df                	je     80104c9c <sys_unlink+0x12c>
    iunlockput(ip);
80104cbd:	83 ec 0c             	sub    $0xc,%esp
80104cc0:	53                   	push   %ebx
80104cc1:	e8 aa cb ff ff       	call   80101870 <iunlockput>
    goto bad;
80104cc6:	83 c4 10             	add    $0x10,%esp
80104cc9:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	ff 75 b4             	push   -0x4c(%ebp)
80104cd2:	e8 99 cb ff ff       	call   80101870 <iunlockput>
  end_op();
80104cd7:	e8 e8 dd ff ff       	call   80102ac4 <end_op>
  return -1;
80104cdc:	83 c4 10             	add    $0x10,%esp
    return -1;
80104cdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce4:	eb 9b                	jmp    80104c81 <sys_unlink+0x111>
80104ce6:	66 90                	xchg   %ax,%ax
    dp->nlink--;
80104ce8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ceb:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
80104cef:	83 ec 0c             	sub    $0xc,%esp
80104cf2:	50                   	push   %eax
80104cf3:	e8 7c c8 ff ff       	call   80101574 <iupdate>
80104cf8:	83 c4 10             	add    $0x10,%esp
80104cfb:	e9 58 ff ff ff       	jmp    80104c58 <sys_unlink+0xe8>
    end_op();
80104d00:	e8 bf dd ff ff       	call   80102ac4 <end_op>
    return -1;
80104d05:	eb d8                	jmp    80104cdf <sys_unlink+0x16f>
      panic("isdirempty: readi");
80104d07:	83 ec 0c             	sub    $0xc,%esp
80104d0a:	68 7f 6f 10 80       	push   $0x80106f7f
80104d0f:	e8 24 b6 ff ff       	call   80100338 <panic>
    panic("unlink: nlink < 1");
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	68 6d 6f 10 80       	push   $0x80106f6d
80104d1c:	e8 17 b6 ff ff       	call   80100338 <panic>
    panic("unlink: writei");
80104d21:	83 ec 0c             	sub    $0xc,%esp
80104d24:	68 91 6f 10 80       	push   $0x80106f91
80104d29:	e8 0a b6 ff ff       	call   80100338 <panic>
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <sys_open>:

int
sys_open(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
80104d36:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d39:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d3c:	50                   	push   %eax
80104d3d:	6a 00                	push   $0x0
80104d3f:	e8 bc f8 ff ff       	call   80104600 <argstr>
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	85 c0                	test   %eax,%eax
80104d49:	0f 88 8c 00 00 00    	js     80104ddb <sys_open+0xab>
80104d4f:	83 ec 08             	sub    $0x8,%esp
80104d52:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d55:	50                   	push   %eax
80104d56:	6a 01                	push   $0x1
80104d58:	e8 f7 f7 ff ff       	call   80104554 <argint>
80104d5d:	83 c4 10             	add    $0x10,%esp
80104d60:	85 c0                	test   %eax,%eax
80104d62:	78 77                	js     80104ddb <sys_open+0xab>
    return -1;

  begin_op();
80104d64:	e8 f3 dc ff ff       	call   80102a5c <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104d69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
80104d6c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104d70:	75 72                	jne    80104de4 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104d72:	83 ec 0c             	sub    $0xc,%esp
80104d75:	50                   	push   %eax
80104d76:	e8 f1 d0 ff ff       	call   80101e6c <namei>
80104d7b:	89 c6                	mov    %eax,%esi
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	85 c0                	test   %eax,%eax
80104d82:	74 7a                	je     80104dfe <sys_open+0xce>
      end_op();
      return -1;
    }
    ilock(ip);
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	50                   	push   %eax
80104d88:	e8 8f c8 ff ff       	call   8010161c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104d95:	0f 84 b1 00 00 00    	je     80104e4c <sys_open+0x11c>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104d9b:	e8 fc bf ff ff       	call   80100d9c <filealloc>
80104da0:	89 c7                	mov    %eax,%edi
80104da2:	85 c0                	test   %eax,%eax
80104da4:	74 24                	je     80104dca <sys_open+0x9a>
  struct proc *curproc = myproc();
80104da6:	e8 ed e7 ff ff       	call   80103598 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104dab:	31 db                	xor    %ebx,%ebx
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104db0:	8b 54 98 38          	mov    0x38(%eax,%ebx,4),%edx
80104db4:	85 d2                	test   %edx,%edx
80104db6:	74 50                	je     80104e08 <sys_open+0xd8>
  for(fd = 0; fd < NOFILE; fd++){
80104db8:	43                   	inc    %ebx
80104db9:	83 fb 10             	cmp    $0x10,%ebx
80104dbc:	75 f2                	jne    80104db0 <sys_open+0x80>
    if(f)
      fileclose(f);
80104dbe:	83 ec 0c             	sub    $0xc,%esp
80104dc1:	57                   	push   %edi
80104dc2:	e8 81 c0 ff ff       	call   80100e48 <fileclose>
80104dc7:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	56                   	push   %esi
80104dce:	e8 9d ca ff ff       	call   80101870 <iunlockput>
    end_op();
80104dd3:	e8 ec dc ff ff       	call   80102ac4 <end_op>
    return -1;
80104dd8:	83 c4 10             	add    $0x10,%esp
    return -1;
80104ddb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104de0:	eb 5f                	jmp    80104e41 <sys_open+0x111>
80104de2:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	6a 00                	push   $0x0
80104de9:	31 c9                	xor    %ecx,%ecx
80104deb:	ba 02 00 00 00       	mov    $0x2,%edx
80104df0:	e8 c7 f8 ff ff       	call   801046bc <create>
80104df5:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	75 9d                	jne    80104d9b <sys_open+0x6b>
      end_op();
80104dfe:	e8 c1 dc ff ff       	call   80102ac4 <end_op>
      return -1;
80104e03:	eb d6                	jmp    80104ddb <sys_open+0xab>
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e08:	89 7c 98 38          	mov    %edi,0x38(%eax,%ebx,4)
  }
  iunlock(ip);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	56                   	push   %esi
80104e10:	e8 cf c8 ff ff       	call   801016e4 <iunlock>
  end_op();
80104e15:	e8 aa dc ff ff       	call   80102ac4 <end_op>

  f->type = FD_INODE;
80104e1a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
80104e20:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80104e23:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e2d:	89 d0                	mov    %edx,%eax
80104e2f:	f7 d0                	not    %eax
80104e31:	83 e0 01             	and    $0x1,%eax
80104e34:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	83 e2 03             	and    $0x3,%edx
80104e3d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80104e41:	89 d8                	mov    %ebx,%eax
80104e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e46:	5b                   	pop    %ebx
80104e47:	5e                   	pop    %esi
80104e48:	5f                   	pop    %edi
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret
80104e4b:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e4c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104e4f:	85 c9                	test   %ecx,%ecx
80104e51:	0f 84 44 ff ff ff    	je     80104d9b <sys_open+0x6b>
80104e57:	e9 6e ff ff ff       	jmp    80104dca <sys_open+0x9a>

80104e5c <sys_mkdir>:

int
sys_mkdir(void)
{
80104e5c:	55                   	push   %ebp
80104e5d:	89 e5                	mov    %esp,%ebp
80104e5f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104e62:	e8 f5 db ff ff       	call   80102a5c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104e67:	83 ec 08             	sub    $0x8,%esp
80104e6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e6d:	50                   	push   %eax
80104e6e:	6a 00                	push   $0x0
80104e70:	e8 8b f7 ff ff       	call   80104600 <argstr>
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	85 c0                	test   %eax,%eax
80104e7a:	78 30                	js     80104eac <sys_mkdir+0x50>
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	6a 00                	push   $0x0
80104e81:	31 c9                	xor    %ecx,%ecx
80104e83:	ba 01 00 00 00       	mov    $0x1,%edx
80104e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8b:	e8 2c f8 ff ff       	call   801046bc <create>
80104e90:	83 c4 10             	add    $0x10,%esp
80104e93:	85 c0                	test   %eax,%eax
80104e95:	74 15                	je     80104eac <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104e97:	83 ec 0c             	sub    $0xc,%esp
80104e9a:	50                   	push   %eax
80104e9b:	e8 d0 c9 ff ff       	call   80101870 <iunlockput>
  end_op();
80104ea0:	e8 1f dc ff ff       	call   80102ac4 <end_op>
  return 0;
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	31 c0                	xor    %eax,%eax
}
80104eaa:	c9                   	leave
80104eab:	c3                   	ret
    end_op();
80104eac:	e8 13 dc ff ff       	call   80102ac4 <end_op>
    return -1;
80104eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb6:	c9                   	leave
80104eb7:	c3                   	ret

80104eb8 <sys_mknod>:

int
sys_mknod(void)
{
80104eb8:	55                   	push   %ebp
80104eb9:	89 e5                	mov    %esp,%ebp
80104ebb:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104ebe:	e8 99 db ff ff       	call   80102a5c <begin_op>
  if((argstr(0, &path)) < 0 ||
80104ec3:	83 ec 08             	sub    $0x8,%esp
80104ec6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ec9:	50                   	push   %eax
80104eca:	6a 00                	push   $0x0
80104ecc:	e8 2f f7 ff ff       	call   80104600 <argstr>
80104ed1:	83 c4 10             	add    $0x10,%esp
80104ed4:	85 c0                	test   %eax,%eax
80104ed6:	78 60                	js     80104f38 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104ed8:	83 ec 08             	sub    $0x8,%esp
80104edb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ede:	50                   	push   %eax
80104edf:	6a 01                	push   $0x1
80104ee1:	e8 6e f6 ff ff       	call   80104554 <argint>
  if((argstr(0, &path)) < 0 ||
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	78 4b                	js     80104f38 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104eed:	83 ec 08             	sub    $0x8,%esp
80104ef0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef3:	50                   	push   %eax
80104ef4:	6a 02                	push   $0x2
80104ef6:	e8 59 f6 ff ff       	call   80104554 <argint>
     argint(1, &major) < 0 ||
80104efb:	83 c4 10             	add    $0x10,%esp
80104efe:	85 c0                	test   %eax,%eax
80104f00:	78 36                	js     80104f38 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f02:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f06:	83 ec 0c             	sub    $0xc,%esp
80104f09:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104f0d:	50                   	push   %eax
80104f0e:	ba 03 00 00 00       	mov    $0x3,%edx
80104f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f16:	e8 a1 f7 ff ff       	call   801046bc <create>
     argint(2, &minor) < 0 ||
80104f1b:	83 c4 10             	add    $0x10,%esp
80104f1e:	85 c0                	test   %eax,%eax
80104f20:	74 16                	je     80104f38 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f22:	83 ec 0c             	sub    $0xc,%esp
80104f25:	50                   	push   %eax
80104f26:	e8 45 c9 ff ff       	call   80101870 <iunlockput>
  end_op();
80104f2b:	e8 94 db ff ff       	call   80102ac4 <end_op>
  return 0;
80104f30:	83 c4 10             	add    $0x10,%esp
80104f33:	31 c0                	xor    %eax,%eax
}
80104f35:	c9                   	leave
80104f36:	c3                   	ret
80104f37:	90                   	nop
    end_op();
80104f38:	e8 87 db ff ff       	call   80102ac4 <end_op>
    return -1;
80104f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f42:	c9                   	leave
80104f43:	c3                   	ret

80104f44 <sys_chdir>:

int
sys_chdir(void)
{
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	56                   	push   %esi
80104f48:	53                   	push   %ebx
80104f49:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104f4c:	e8 47 e6 ff ff       	call   80103598 <myproc>
80104f51:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104f53:	e8 04 db ff ff       	call   80102a5c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104f58:	83 ec 08             	sub    $0x8,%esp
80104f5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5e:	50                   	push   %eax
80104f5f:	6a 00                	push   $0x0
80104f61:	e8 9a f6 ff ff       	call   80104600 <argstr>
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	85 c0                	test   %eax,%eax
80104f6b:	78 67                	js     80104fd4 <sys_chdir+0x90>
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	ff 75 f4             	push   -0xc(%ebp)
80104f73:	e8 f4 ce ff ff       	call   80101e6c <namei>
80104f78:	89 c3                	mov    %eax,%ebx
80104f7a:	83 c4 10             	add    $0x10,%esp
80104f7d:	85 c0                	test   %eax,%eax
80104f7f:	74 53                	je     80104fd4 <sys_chdir+0x90>
    end_op();
    return -1;
  }
  ilock(ip);
80104f81:	83 ec 0c             	sub    $0xc,%esp
80104f84:	50                   	push   %eax
80104f85:	e8 92 c6 ff ff       	call   8010161c <ilock>
  if(ip->type != T_DIR){
80104f8a:	83 c4 10             	add    $0x10,%esp
80104f8d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f92:	75 28                	jne    80104fbc <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	53                   	push   %ebx
80104f98:	e8 47 c7 ff ff       	call   801016e4 <iunlock>
  iput(curproc->cwd);
80104f9d:	58                   	pop    %eax
80104f9e:	ff 76 78             	push   0x78(%esi)
80104fa1:	e8 82 c7 ff ff       	call   80101728 <iput>
  end_op();
80104fa6:	e8 19 db ff ff       	call   80102ac4 <end_op>
  curproc->cwd = ip;
80104fab:	89 5e 78             	mov    %ebx,0x78(%esi)
  return 0;
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	31 c0                	xor    %eax,%eax
}
80104fb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb6:	5b                   	pop    %ebx
80104fb7:	5e                   	pop    %esi
80104fb8:	5d                   	pop    %ebp
80104fb9:	c3                   	ret
80104fba:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	53                   	push   %ebx
80104fc0:	e8 ab c8 ff ff       	call   80101870 <iunlockput>
    end_op();
80104fc5:	e8 fa da ff ff       	call   80102ac4 <end_op>
    return -1;
80104fca:	83 c4 10             	add    $0x10,%esp
    return -1;
80104fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd2:	eb df                	jmp    80104fb3 <sys_chdir+0x6f>
    end_op();
80104fd4:	e8 eb da ff ff       	call   80102ac4 <end_op>
    return -1;
80104fd9:	eb f2                	jmp    80104fcd <sys_chdir+0x89>
80104fdb:	90                   	nop

80104fdc <sys_exec>:

int
sys_exec(void)
{
80104fdc:	55                   	push   %ebp
80104fdd:	89 e5                	mov    %esp,%ebp
80104fdf:	57                   	push   %edi
80104fe0:	56                   	push   %esi
80104fe1:	53                   	push   %ebx
80104fe2:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104fe8:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104fee:	50                   	push   %eax
80104fef:	6a 00                	push   $0x0
80104ff1:	e8 0a f6 ff ff       	call   80104600 <argstr>
80104ff6:	83 c4 10             	add    $0x10,%esp
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	78 79                	js     80105076 <sys_exec+0x9a>
80104ffd:	83 ec 08             	sub    $0x8,%esp
80105000:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105006:	50                   	push   %eax
80105007:	6a 01                	push   $0x1
80105009:	e8 46 f5 ff ff       	call   80104554 <argint>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	85 c0                	test   %eax,%eax
80105013:	78 61                	js     80105076 <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105015:	50                   	push   %eax
80105016:	68 80 00 00 00       	push   $0x80
8010501b:	6a 00                	push   $0x0
8010501d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80105023:	57                   	push   %edi
80105024:	e8 0f f3 ff ff       	call   80104338 <memset>
80105029:	83 c4 10             	add    $0x10,%esp
8010502c:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
8010502e:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105030:	83 ec 08             	sub    $0x8,%esp
80105033:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105039:	50                   	push   %eax
8010503a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105040:	01 d8                	add    %ebx,%eax
80105042:	50                   	push   %eax
80105043:	e8 9c f4 ff ff       	call   801044e4 <fetchint>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	78 27                	js     80105076 <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
8010504f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105055:	85 c0                	test   %eax,%eax
80105057:	74 2b                	je     80105084 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
8010505f:	52                   	push   %edx
80105060:	50                   	push   %eax
80105061:	e8 ae f4 ff ff       	call   80104514 <fetchstr>
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	85 c0                	test   %eax,%eax
8010506b:	78 09                	js     80105076 <sys_exec+0x9a>
  for(i=0;; i++){
8010506d:	46                   	inc    %esi
    if(i >= NELEM(argv))
8010506e:	83 c3 04             	add    $0x4,%ebx
80105071:	83 fe 20             	cmp    $0x20,%esi
80105074:	75 ba                	jne    80105030 <sys_exec+0x54>
    return -1;
80105076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
8010507b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010507e:	5b                   	pop    %ebx
8010507f:	5e                   	pop    %esi
80105080:	5f                   	pop    %edi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret
80105083:	90                   	nop
      argv[i] = 0;
80105084:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
8010508b:	00 00 00 00 
  return exec(path, argv);
8010508f:	83 ec 08             	sub    $0x8,%esp
80105092:	57                   	push   %edi
80105093:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105099:	e8 86 b9 ff ff       	call   80100a24 <exec>
8010509e:	83 c4 10             	add    $0x10,%esp
}
801050a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a4:	5b                   	pop    %ebx
801050a5:	5e                   	pop    %esi
801050a6:	5f                   	pop    %edi
801050a7:	5d                   	pop    %ebp
801050a8:	c3                   	ret
801050a9:	8d 76 00             	lea    0x0(%esi),%esi

801050ac <sys_pipe>:

int
sys_pipe(void)
{
801050ac:	55                   	push   %ebp
801050ad:	89 e5                	mov    %esp,%ebp
801050af:	57                   	push   %edi
801050b0:	56                   	push   %esi
801050b1:	53                   	push   %ebx
801050b2:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801050b5:	6a 08                	push   $0x8
801050b7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801050ba:	50                   	push   %eax
801050bb:	6a 00                	push   $0x0
801050bd:	e8 d6 f4 ff ff       	call   80104598 <argptr>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 7d                	js     80105146 <sys_pipe+0x9a>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801050c9:	83 ec 08             	sub    $0x8,%esp
801050cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050cf:	50                   	push   %eax
801050d0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801050d3:	50                   	push   %eax
801050d4:	e8 93 df ff ff       	call   8010306c <pipealloc>
801050d9:	83 c4 10             	add    $0x10,%esp
801050dc:	85 c0                	test   %eax,%eax
801050de:	78 66                	js     80105146 <sys_pipe+0x9a>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801050e0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
801050e3:	e8 b0 e4 ff ff       	call   80103598 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050e8:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801050ea:	8b 74 98 38          	mov    0x38(%eax,%ebx,4),%esi
801050ee:	85 f6                	test   %esi,%esi
801050f0:	74 10                	je     80105102 <sys_pipe+0x56>
801050f2:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
801050f4:	43                   	inc    %ebx
801050f5:	83 fb 10             	cmp    $0x10,%ebx
801050f8:	74 35                	je     8010512f <sys_pipe+0x83>
    if(curproc->ofile[fd] == 0){
801050fa:	8b 74 98 38          	mov    0x38(%eax,%ebx,4),%esi
801050fe:	85 f6                	test   %esi,%esi
80105100:	75 f2                	jne    801050f4 <sys_pipe+0x48>
      curproc->ofile[fd] = f;
80105102:	8d 73 0c             	lea    0xc(%ebx),%esi
80105105:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105109:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010510c:	e8 87 e4 ff ff       	call   80103598 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105111:	31 d2                	xor    %edx,%edx
80105113:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105114:	8b 4c 90 38          	mov    0x38(%eax,%edx,4),%ecx
80105118:	85 c9                	test   %ecx,%ecx
8010511a:	74 34                	je     80105150 <sys_pipe+0xa4>
  for(fd = 0; fd < NOFILE; fd++){
8010511c:	42                   	inc    %edx
8010511d:	83 fa 10             	cmp    $0x10,%edx
80105120:	75 f2                	jne    80105114 <sys_pipe+0x68>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105122:	e8 71 e4 ff ff       	call   80103598 <myproc>
80105127:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010512e:	00 
    fileclose(rf);
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	ff 75 e0             	push   -0x20(%ebp)
80105135:	e8 0e bd ff ff       	call   80100e48 <fileclose>
    fileclose(wf);
8010513a:	58                   	pop    %eax
8010513b:	ff 75 e4             	push   -0x1c(%ebp)
8010513e:	e8 05 bd ff ff       	call   80100e48 <fileclose>
    return -1;
80105143:	83 c4 10             	add    $0x10,%esp
    return -1;
80105146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514b:	eb 14                	jmp    80105161 <sys_pipe+0xb5>
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105150:	89 7c 90 38          	mov    %edi,0x38(%eax,%edx,4)
  }
  fd[0] = fd0;
80105154:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105157:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105159:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010515c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010515f:	31 c0                	xor    %eax,%eax
}
80105161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105164:	5b                   	pop    %ebx
80105165:	5e                   	pop    %esi
80105166:	5f                   	pop    %edi
80105167:	5d                   	pop    %ebp
80105168:	c3                   	ret
80105169:	66 90                	xchg   %ax,%ax
8010516b:	90                   	nop

8010516c <sys_signal>:

//     myproc()->signal_handler = (void*)handler;
//     return 0;
// }

int sys_signal(void) {
8010516c:	55                   	push   %ebp
8010516d:	89 e5                	mov    %esp,%ebp
8010516f:	83 ec 1c             	sub    $0x1c,%esp
    void (*handler)(void);
    
    if (argptr(0, (void*)&handler, sizeof(void*)) < 0)
80105172:	6a 04                	push   $0x4
80105174:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105177:	50                   	push   %eax
80105178:	6a 00                	push   $0x0
8010517a:	e8 19 f4 ff ff       	call   80104598 <argptr>
8010517f:	83 c4 10             	add    $0x10,%esp
80105182:	85 c0                	test   %eax,%eax
80105184:	78 12                	js     80105198 <sys_signal+0x2c>
        return -1;

    myproc()->signal_handler = handler;
80105186:	e8 0d e4 ff ff       	call   80103598 <myproc>
8010518b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010518e:	89 50 08             	mov    %edx,0x8(%eax)
    return 0;
80105191:	31 c0                	xor    %eax,%eax
}
80105193:	c9                   	leave
80105194:	c3                   	ret
80105195:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010519d:	c9                   	leave
8010519e:	c3                   	ret
8010519f:	90                   	nop

801051a0 <sys_fork>:


int
sys_fork(void)
{
  return fork();
801051a0:	e9 6b e5 ff ff       	jmp    80103710 <fork>
801051a5:	8d 76 00             	lea    0x0(%esi),%esi

801051a8 <sys_exit>:
}

int
sys_exit(void)
{
801051a8:	55                   	push   %ebp
801051a9:	89 e5                	mov    %esp,%ebp
801051ab:	83 ec 08             	sub    $0x8,%esp
  exit();
801051ae:	e8 2d e9 ff ff       	call   80103ae0 <exit>
  return 0;  // not reached
}
801051b3:	31 c0                	xor    %eax,%eax
801051b5:	c9                   	leave
801051b6:	c3                   	ret
801051b7:	90                   	nop

801051b8 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801051b8:	e9 6b eb ff ff       	jmp    80103d28 <wait>
801051bd:	8d 76 00             	lea    0x0(%esi),%esi

801051c0 <sys_kill>:
}

int
sys_kill(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801051c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c9:	50                   	push   %eax
801051ca:	6a 00                	push   $0x0
801051cc:	e8 83 f3 ff ff       	call   80104554 <argint>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	85 c0                	test   %eax,%eax
801051d6:	78 10                	js     801051e8 <sys_kill+0x28>
    return -1;
  return kill(pid);
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	ff 75 f4             	push   -0xc(%ebp)
801051de:	e8 91 ec ff ff       	call   80103e74 <kill>
801051e3:	83 c4 10             	add    $0x10,%esp
}
801051e6:	c9                   	leave
801051e7:	c3                   	ret
    return -1;
801051e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ed:	c9                   	leave
801051ee:	c3                   	ret
801051ef:	90                   	nop

801051f0 <sys_getpid>:

int
sys_getpid(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801051f6:	e8 9d e3 ff ff       	call   80103598 <myproc>
801051fb:	8b 40 20             	mov    0x20(%eax),%eax
}
801051fe:	c9                   	leave
801051ff:	c3                   	ret

80105200 <sys_sbrk>:

int
sys_sbrk(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	53                   	push   %ebx
80105204:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105207:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520a:	50                   	push   %eax
8010520b:	6a 00                	push   $0x0
8010520d:	e8 42 f3 ff ff       	call   80104554 <argint>
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	85 c0                	test   %eax,%eax
80105217:	78 23                	js     8010523c <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80105219:	e8 7a e3 ff ff       	call   80103598 <myproc>
8010521e:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	ff 75 f4             	push   -0xc(%ebp)
80105226:	e8 75 e4 ff ff       	call   801036a0 <growproc>
8010522b:	83 c4 10             	add    $0x10,%esp
8010522e:	85 c0                	test   %eax,%eax
80105230:	78 0a                	js     8010523c <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80105232:	89 d8                	mov    %ebx,%eax
80105234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105237:	c9                   	leave
80105238:	c3                   	ret
80105239:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
8010523c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105241:	eb ef                	jmp    80105232 <sys_sbrk+0x32>
80105243:	90                   	nop

80105244 <sys_sleep>:

int
sys_sleep(void)
{
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	53                   	push   %ebx
80105248:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010524b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524e:	50                   	push   %eax
8010524f:	6a 00                	push   $0x0
80105251:	e8 fe f2 ff ff       	call   80104554 <argint>
80105256:	83 c4 10             	add    $0x10,%esp
80105259:	85 c0                	test   %eax,%eax
8010525b:	78 5c                	js     801052b9 <sys_sleep+0x75>
    return -1;
  acquire(&tickslock);
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	68 80 40 11 80       	push   $0x80114080
80105265:	e8 02 f0 ff ff       	call   8010426c <acquire>
  ticks0 = ticks;
8010526a:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  while(ticks - ticks0 < n){
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105276:	85 d2                	test   %edx,%edx
80105278:	75 23                	jne    8010529d <sys_sleep+0x59>
8010527a:	eb 44                	jmp    801052c0 <sys_sleep+0x7c>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
8010527c:	83 ec 08             	sub    $0x8,%esp
8010527f:	68 80 40 11 80       	push   $0x80114080
80105284:	68 60 40 11 80       	push   $0x80114060
80105289:	e8 b6 e9 ff ff       	call   80103c44 <sleep>
  while(ticks - ticks0 < n){
8010528e:	a1 60 40 11 80       	mov    0x80114060,%eax
80105293:	29 d8                	sub    %ebx,%eax
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010529b:	73 23                	jae    801052c0 <sys_sleep+0x7c>
    if(myproc()->killed){
8010529d:	e8 f6 e2 ff ff       	call   80103598 <myproc>
801052a2:	8b 40 34             	mov    0x34(%eax),%eax
801052a5:	85 c0                	test   %eax,%eax
801052a7:	74 d3                	je     8010527c <sys_sleep+0x38>
      release(&tickslock);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	68 80 40 11 80       	push   $0x80114080
801052b1:	e8 56 ef ff ff       	call   8010420c <release>
      return -1;
801052b6:	83 c4 10             	add    $0x10,%esp
    return -1;
801052b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052be:	eb 12                	jmp    801052d2 <sys_sleep+0x8e>
  }
  release(&tickslock);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	68 80 40 11 80       	push   $0x80114080
801052c8:	e8 3f ef ff ff       	call   8010420c <release>
  return 0;
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	31 c0                	xor    %eax,%eax
}
801052d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052d5:	c9                   	leave
801052d6:	c3                   	ret
801052d7:	90                   	nop

801052d8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801052d8:	55                   	push   %ebp
801052d9:	89 e5                	mov    %esp,%ebp
801052db:	53                   	push   %ebx
801052dc:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801052df:	68 80 40 11 80       	push   $0x80114080
801052e4:	e8 83 ef ff ff       	call   8010426c <acquire>
  xticks = ticks;
801052e9:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  release(&tickslock);
801052ef:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
801052f6:	e8 11 ef ff ff       	call   8010420c <release>
  return xticks;
}
801052fb:	89 d8                	mov    %ebx,%eax
801052fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105300:	c9                   	leave
80105301:	c3                   	ret

80105302 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105302:	1e                   	push   %ds
  pushl %es
80105303:	06                   	push   %es
  pushl %fs
80105304:	0f a0                	push   %fs
  pushl %gs
80105306:	0f a8                	push   %gs
  pushal
80105308:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105309:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010530d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010530f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105311:	54                   	push   %esp
  call trap
80105312:	e8 a1 00 00 00       	call   801053b8 <trap>
  addl $4, %esp
80105317:	83 c4 04             	add    $0x4,%esp

8010531a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010531a:	61                   	popa
  popl %gs
8010531b:	0f a9                	pop    %gs
  popl %fs
8010531d:	0f a1                	pop    %fs
  popl %es
8010531f:	07                   	pop    %es
  popl %ds
80105320:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105321:	83 c4 08             	add    $0x8,%esp
  iret
80105324:	cf                   	iret
80105325:	66 90                	xchg   %ax,%ax
80105327:	90                   	nop

80105328 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105328:	55                   	push   %ebp
80105329:	89 e5                	mov    %esp,%ebp
8010532b:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010532e:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105330:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105337:	66 89 14 c5 c0 40 11 	mov    %dx,-0x7feebf40(,%eax,8)
8010533e:	80 
8010533f:	c7 04 c5 c2 40 11 80 	movl   $0x8e000008,-0x7feebf3e(,%eax,8)
80105346:	08 00 00 8e 
8010534a:	c1 ea 10             	shr    $0x10,%edx
8010534d:	66 89 14 c5 c6 40 11 	mov    %dx,-0x7feebf3a(,%eax,8)
80105354:	80 
  for(i = 0; i < 256; i++)
80105355:	40                   	inc    %eax
80105356:	3d 00 01 00 00       	cmp    $0x100,%eax
8010535b:	75 d3                	jne    80105330 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010535d:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105362:	66 a3 c0 42 11 80    	mov    %ax,0x801142c0
80105368:	c7 05 c2 42 11 80 08 	movl   $0xef000008,0x801142c2
8010536f:	00 00 ef 
80105372:	c1 e8 10             	shr    $0x10,%eax
80105375:	66 a3 c6 42 11 80    	mov    %ax,0x801142c6

  initlock(&tickslock, "time");
8010537b:	83 ec 08             	sub    $0x8,%esp
8010537e:	68 a0 6f 10 80       	push   $0x80106fa0
80105383:	68 80 40 11 80       	push   $0x80114080
80105388:	e8 17 ed ff ff       	call   801040a4 <initlock>
}
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	c9                   	leave
80105391:	c3                   	ret
80105392:	66 90                	xchg   %ax,%ax

80105394 <idtinit>:

void
idtinit(void)
{
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010539a:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801053a0:	b8 c0 40 11 80       	mov    $0x801140c0,%eax
801053a5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801053a9:	c1 e8 10             	shr    $0x10,%eax
801053ac:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801053b0:	8d 45 fa             	lea    -0x6(%ebp),%eax
801053b3:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801053b6:	c9                   	leave
801053b7:	c3                   	ret

801053b8 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801053b8:	55                   	push   %ebp
801053b9:	89 e5                	mov    %esp,%ebp
801053bb:	57                   	push   %edi
801053bc:	56                   	push   %esi
801053bd:	53                   	push   %ebx
801053be:	83 ec 1c             	sub    $0x1c,%esp
801053c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801053c4:	8b 43 30             	mov    0x30(%ebx),%eax
801053c7:	83 f8 40             	cmp    $0x40,%eax
801053ca:	0f 84 00 02 00 00    	je     801055d0 <trap+0x218>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801053d0:	83 e8 20             	sub    $0x20,%eax
801053d3:	83 f8 1f             	cmp    $0x1f,%eax
801053d6:	0f 87 9c 00 00 00    	ja     80105478 <trap+0xc0>
801053dc:	ff 24 85 1c 75 10 80 	jmp    *-0x7fef8ae4(,%eax,4)
801053e3:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801053e4:	e8 7b e1 ff ff       	call   80103564 <cpuid>
801053e9:	85 c0                	test   %eax,%eax
801053eb:	0f 84 23 02 00 00    	je     80105614 <trap+0x25c>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801053f1:	e8 76 d2 ff ff       	call   8010266c <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801053f6:	e8 9d e1 ff ff       	call   80103598 <myproc>
801053fb:	85 c0                	test   %eax,%eax
801053fd:	74 19                	je     80105418 <trap+0x60>
801053ff:	e8 94 e1 ff ff       	call   80103598 <myproc>
80105404:	8b 48 34             	mov    0x34(%eax),%ecx
80105407:	85 c9                	test   %ecx,%ecx
80105409:	74 0d                	je     80105418 <trap+0x60>
8010540b:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010540e:	f7 d0                	not    %eax
80105410:	a8 03                	test   $0x3,%al
80105412:	0f 84 f0 01 00 00    	je     80105608 <trap+0x250>
//     // Set eip to start executing signal handler
//     myproc()->tf->eip = (uint)myproc()->signal_handler;
// }


  if(myproc() && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
80105418:	e8 7b e1 ff ff       	call   80103598 <myproc>
8010541d:	85 c0                	test   %eax,%eax
8010541f:	74 0f                	je     80105430 <trap+0x78>
80105421:	e8 72 e1 ff ff       	call   80103598 <myproc>
80105426:	83 78 04 04          	cmpl   $0x4,0x4(%eax)
8010542a:	0f 84 e0 00 00 00    	je     80105510 <trap+0x158>
    myproc()->tf->eip = (uint)myproc()->signal_handler;
}



  if (myproc() && myproc()->signal_handler) {
80105430:	e8 63 e1 ff ff       	call   80103598 <myproc>
80105435:	85 c0                	test   %eax,%eax
80105437:	74 1f                	je     80105458 <trap+0xa0>
80105439:	e8 5a e1 ff ff       	call   80103598 <myproc>
8010543e:	8b 40 08             	mov    0x8(%eax),%eax
80105441:	85 c0                	test   %eax,%eax
80105443:	74 13                	je     80105458 <trap+0xa0>
    myproc()->tf->eip = (uint)myproc()->signal_handler;
80105445:	e8 4e e1 ff ff       	call   80103598 <myproc>
8010544a:	8b 70 08             	mov    0x8(%eax),%esi
8010544d:	e8 46 e1 ff ff       	call   80103598 <myproc>
80105452:	8b 40 28             	mov    0x28(%eax),%eax
80105455:	89 70 38             	mov    %esi,0x38(%eax)
}


  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105458:	e8 3b e1 ff ff       	call   80103598 <myproc>
8010545d:	85 c0                	test   %eax,%eax
8010545f:	74 0f                	je     80105470 <trap+0xb8>
80105461:	e8 32 e1 ff ff       	call   80103598 <myproc>
80105466:	83 78 1c 04          	cmpl   $0x4,0x1c(%eax)
8010546a:	0f 84 88 00 00 00    	je     801054f8 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

}
80105470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105473:	5b                   	pop    %ebx
80105474:	5e                   	pop    %esi
80105475:	5f                   	pop    %edi
80105476:	5d                   	pop    %ebp
80105477:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105478:	e8 1b e1 ff ff       	call   80103598 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010547d:	8b 7b 38             	mov    0x38(%ebx),%edi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105480:	85 c0                	test   %eax,%eax
80105482:	0f 84 c7 01 00 00    	je     8010564f <trap+0x297>
80105488:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010548c:	0f 84 bd 01 00 00    	je     8010564f <trap+0x297>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105492:	0f 20 d1             	mov    %cr2,%ecx
80105495:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105498:	e8 c7 e0 ff ff       	call   80103564 <cpuid>
8010549d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801054a0:	8b 43 34             	mov    0x34(%ebx),%eax
801054a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801054a6:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801054a9:	e8 ea e0 ff ff       	call   80103598 <myproc>
801054ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801054b1:	e8 e2 e0 ff ff       	call   80103598 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054b6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801054b9:	51                   	push   %ecx
801054ba:	57                   	push   %edi
801054bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
801054be:	52                   	push   %edx
801054bf:	ff 75 e4             	push   -0x1c(%ebp)
801054c2:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801054c3:	8b 75 e0             	mov    -0x20(%ebp),%esi
801054c6:	83 c6 7c             	add    $0x7c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054c9:	56                   	push   %esi
801054ca:	ff 70 20             	push   0x20(%eax)
801054cd:	68 14 72 10 80       	push   $0x80107214
801054d2:	e8 49 b1 ff ff       	call   80100620 <cprintf>
    myproc()->killed = 1;
801054d7:	83 c4 20             	add    $0x20,%esp
801054da:	e8 b9 e0 ff ff       	call   80103598 <myproc>
801054df:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054e6:	e8 ad e0 ff ff       	call   80103598 <myproc>
801054eb:	85 c0                	test   %eax,%eax
801054ed:	0f 85 0c ff ff ff    	jne    801053ff <trap+0x47>
801054f3:	e9 20 ff ff ff       	jmp    80105418 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801054f8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801054fc:	0f 85 6e ff ff ff    	jne    80105470 <trap+0xb8>
}
80105502:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105505:	5b                   	pop    %ebx
80105506:	5e                   	pop    %esi
80105507:	5f                   	pop    %edi
80105508:	5d                   	pop    %ebp
    yield();
80105509:	e9 ee e6 ff ff       	jmp    80103bfc <yield>
8010550e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
80105510:	e8 83 e0 ff ff       	call   80103598 <myproc>
80105515:	8b 50 08             	mov    0x8(%eax),%edx
80105518:	85 d2                	test   %edx,%edx
8010551a:	0f 84 10 ff ff ff    	je     80105430 <trap+0x78>
    myproc()->pending_signal = 0; // clear pending signal
80105520:	e8 73 e0 ff ff       	call   80103598 <myproc>
80105525:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    myproc()->backup_eip = myproc()->tf->eip;
8010552c:	e8 67 e0 ff ff       	call   80103598 <myproc>
80105531:	8b 70 28             	mov    0x28(%eax),%esi
80105534:	e8 5f e0 ff ff       	call   80103598 <myproc>
80105539:	8b 56 38             	mov    0x38(%esi),%edx
8010553c:	89 50 0c             	mov    %edx,0xc(%eax)
    myproc()->tf->eip = (uint)myproc()->signal_handler;
8010553f:	e8 54 e0 ff ff       	call   80103598 <myproc>
80105544:	8b 70 08             	mov    0x8(%eax),%esi
80105547:	e8 4c e0 ff ff       	call   80103598 <myproc>
8010554c:	8b 40 28             	mov    0x28(%eax),%eax
8010554f:	89 70 38             	mov    %esi,0x38(%eax)
80105552:	e9 d9 fe ff ff       	jmp    80105430 <trap+0x78>
80105557:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105558:	8b 7b 38             	mov    0x38(%ebx),%edi
8010555b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010555f:	e8 00 e0 ff ff       	call   80103564 <cpuid>
80105564:	57                   	push   %edi
80105565:	56                   	push   %esi
80105566:	50                   	push   %eax
80105567:	68 bc 71 10 80       	push   $0x801071bc
8010556c:	e8 af b0 ff ff       	call   80100620 <cprintf>
    lapiceoi();
80105571:	e8 f6 d0 ff ff       	call   8010266c <lapiceoi>
    break;
80105576:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105579:	e8 1a e0 ff ff       	call   80103598 <myproc>
8010557e:	85 c0                	test   %eax,%eax
80105580:	0f 85 79 fe ff ff    	jne    801053ff <trap+0x47>
80105586:	e9 8d fe ff ff       	jmp    80105418 <trap+0x60>
8010558b:	90                   	nop
    uartintr();
8010558c:	e8 1b 02 00 00       	call   801057ac <uartintr>
    lapiceoi();
80105591:	e8 d6 d0 ff ff       	call   8010266c <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105596:	e8 fd df ff ff       	call   80103598 <myproc>
8010559b:	85 c0                	test   %eax,%eax
8010559d:	0f 85 5c fe ff ff    	jne    801053ff <trap+0x47>
801055a3:	e9 70 fe ff ff       	jmp    80105418 <trap+0x60>
    kbdintr();
801055a8:	e8 0b cf ff ff       	call   801024b8 <kbdintr>
    lapiceoi();
801055ad:	e8 ba d0 ff ff       	call   8010266c <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055b2:	e8 e1 df ff ff       	call   80103598 <myproc>
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 85 40 fe ff ff    	jne    801053ff <trap+0x47>
801055bf:	e9 54 fe ff ff       	jmp    80105418 <trap+0x60>
    ideintr();
801055c4:	e8 ef c9 ff ff       	call   80101fb8 <ideintr>
801055c9:	e9 23 fe ff ff       	jmp    801053f1 <trap+0x39>
801055ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed)
801055d0:	e8 c3 df ff ff       	call   80103598 <myproc>
801055d5:	8b 70 34             	mov    0x34(%eax),%esi
801055d8:	85 f6                	test   %esi,%esi
801055da:	75 6c                	jne    80105648 <trap+0x290>
    myproc()->tf = tf;
801055dc:	e8 b7 df ff ff       	call   80103598 <myproc>
801055e1:	89 58 28             	mov    %ebx,0x28(%eax)
    syscall();
801055e4:	e8 7b f0 ff ff       	call   80104664 <syscall>
    if(myproc()->killed)
801055e9:	e8 aa df ff ff       	call   80103598 <myproc>
801055ee:	8b 58 34             	mov    0x34(%eax),%ebx
801055f1:	85 db                	test   %ebx,%ebx
801055f3:	0f 84 77 fe ff ff    	je     80105470 <trap+0xb8>
}
801055f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055fc:	5b                   	pop    %ebx
801055fd:	5e                   	pop    %esi
801055fe:	5f                   	pop    %edi
801055ff:	5d                   	pop    %ebp
      exit();
80105600:	e9 db e4 ff ff       	jmp    80103ae0 <exit>
80105605:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105608:	e8 d3 e4 ff ff       	call   80103ae0 <exit>
8010560d:	e9 06 fe ff ff       	jmp    80105418 <trap+0x60>
80105612:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
80105614:	83 ec 0c             	sub    $0xc,%esp
80105617:	68 80 40 11 80       	push   $0x80114080
8010561c:	e8 4b ec ff ff       	call   8010426c <acquire>
      ticks++;
80105621:	ff 05 60 40 11 80    	incl   0x80114060
      wakeup(&ticks);
80105627:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
8010562e:	e8 e5 e7 ff ff       	call   80103e18 <wakeup>
      release(&tickslock);
80105633:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
8010563a:	e8 cd eb ff ff       	call   8010420c <release>
8010563f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105642:	e9 aa fd ff ff       	jmp    801053f1 <trap+0x39>
80105647:	90                   	nop
      exit();
80105648:	e8 93 e4 ff ff       	call   80103ae0 <exit>
8010564d:	eb 8d                	jmp    801055dc <trap+0x224>
8010564f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105652:	e8 0d df ff ff       	call   80103564 <cpuid>
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	56                   	push   %esi
8010565b:	57                   	push   %edi
8010565c:	50                   	push   %eax
8010565d:	ff 73 30             	push   0x30(%ebx)
80105660:	68 e0 71 10 80       	push   $0x801071e0
80105665:	e8 b6 af ff ff       	call   80100620 <cprintf>
      panic("trap");
8010566a:	83 c4 14             	add    $0x14,%esp
8010566d:	68 a5 6f 10 80       	push   $0x80106fa5
80105672:	e8 c1 ac ff ff       	call   80100338 <panic>
80105677:	90                   	nop

80105678 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105678:	a1 c0 48 11 80       	mov    0x801148c0,%eax
8010567d:	85 c0                	test   %eax,%eax
8010567f:	74 17                	je     80105698 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105681:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105686:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105687:	a8 01                	test   $0x1,%al
80105689:	74 0d                	je     80105698 <uartgetc+0x20>
8010568b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105690:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105691:	0f b6 c0             	movzbl %al,%eax
80105694:	c3                   	ret
80105695:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569d:	c3                   	ret
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801056a0:	31 c9                	xor    %ecx,%ecx
801056a2:	88 c8                	mov    %cl,%al
801056a4:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056a9:	ee                   	out    %al,(%dx)
801056aa:	b0 80                	mov    $0x80,%al
801056ac:	ba fb 03 00 00       	mov    $0x3fb,%edx
801056b1:	ee                   	out    %al,(%dx)
801056b2:	b0 0c                	mov    $0xc,%al
801056b4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056b9:	ee                   	out    %al,(%dx)
801056ba:	88 c8                	mov    %cl,%al
801056bc:	ba f9 03 00 00       	mov    $0x3f9,%edx
801056c1:	ee                   	out    %al,(%dx)
801056c2:	b0 03                	mov    $0x3,%al
801056c4:	ba fb 03 00 00       	mov    $0x3fb,%edx
801056c9:	ee                   	out    %al,(%dx)
801056ca:	ba fc 03 00 00       	mov    $0x3fc,%edx
801056cf:	88 c8                	mov    %cl,%al
801056d1:	ee                   	out    %al,(%dx)
801056d2:	b0 01                	mov    $0x1,%al
801056d4:	ba f9 03 00 00       	mov    $0x3f9,%edx
801056d9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056da:	ba fd 03 00 00       	mov    $0x3fd,%edx
801056df:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801056e0:	fe c0                	inc    %al
801056e2:	74 7e                	je     80105762 <uartinit+0xc2>
{
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	57                   	push   %edi
801056e8:	56                   	push   %esi
801056e9:	53                   	push   %ebx
801056ea:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
801056ed:	c7 05 c0 48 11 80 01 	movl   $0x1,0x801148c0
801056f4:	00 00 00 
801056f7:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056fc:	ec                   	in     (%dx),%al
801056fd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105702:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105703:	6a 00                	push   $0x0
80105705:	6a 04                	push   $0x4
80105707:	e8 bc ca ff ff       	call   801021c8 <ioapicenable>
8010570c:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010570f:	bf aa 6f 10 80       	mov    $0x80106faa,%edi
80105714:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105718:	be fd 03 00 00       	mov    $0x3fd,%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105720:	a1 c0 48 11 80       	mov    0x801148c0,%eax
80105725:	85 c0                	test   %eax,%eax
80105727:	74 27                	je     80105750 <uartinit+0xb0>
80105729:	bb 80 00 00 00       	mov    $0x80,%ebx
8010572e:	eb 10                	jmp    80105740 <uartinit+0xa0>
    microdelay(10);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	6a 0a                	push   $0xa
80105735:	e8 4a cf ff ff       	call   80102684 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	4b                   	dec    %ebx
8010573e:	74 07                	je     80105747 <uartinit+0xa7>
80105740:	89 f2                	mov    %esi,%edx
80105742:	ec                   	in     (%dx),%al
80105743:	a8 20                	test   $0x20,%al
80105745:	74 e9                	je     80105730 <uartinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105747:	8a 45 e7             	mov    -0x19(%ebp),%al
8010574a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010574f:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105750:	47                   	inc    %edi
80105751:	8a 07                	mov    (%edi),%al
80105753:	88 45 e7             	mov    %al,-0x19(%ebp)
80105756:	84 c0                	test   %al,%al
80105758:	75 c6                	jne    80105720 <uartinit+0x80>
}
8010575a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010575d:	5b                   	pop    %ebx
8010575e:	5e                   	pop    %esi
8010575f:	5f                   	pop    %edi
80105760:	5d                   	pop    %ebp
80105761:	c3                   	ret
80105762:	c3                   	ret
80105763:	90                   	nop

80105764 <uartputc>:
  if(!uart)
80105764:	a1 c0 48 11 80       	mov    0x801148c0,%eax
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 3b                	je     801057a8 <uartputc+0x44>
{
8010576d:	55                   	push   %ebp
8010576e:	89 e5                	mov    %esp,%ebp
80105770:	56                   	push   %esi
80105771:	53                   	push   %ebx
80105772:	bb 80 00 00 00       	mov    $0x80,%ebx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105777:	be fd 03 00 00       	mov    $0x3fd,%esi
8010577c:	eb 12                	jmp    80105790 <uartputc+0x2c>
8010577e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	6a 0a                	push   $0xa
80105785:	e8 fa ce ff ff       	call   80102684 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	4b                   	dec    %ebx
8010578e:	74 07                	je     80105797 <uartputc+0x33>
80105790:	89 f2                	mov    %esi,%edx
80105792:	ec                   	in     (%dx),%al
80105793:	a8 20                	test   $0x20,%al
80105795:	74 e9                	je     80105780 <uartputc+0x1c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105797:	8b 45 08             	mov    0x8(%ebp),%eax
8010579a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010579f:	ee                   	out    %al,(%dx)
}
801057a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a3:	5b                   	pop    %ebx
801057a4:	5e                   	pop    %esi
801057a5:	5d                   	pop    %ebp
801057a6:	c3                   	ret
801057a7:	90                   	nop
801057a8:	c3                   	ret
801057a9:	8d 76 00             	lea    0x0(%esi),%esi

801057ac <uartintr>:

void
uartintr(void)
{
801057ac:	55                   	push   %ebp
801057ad:	89 e5                	mov    %esp,%ebp
801057af:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801057b2:	68 78 56 10 80       	push   $0x80105678
801057b7:	e8 2c b0 ff ff       	call   801007e8 <consoleintr>
}
801057bc:	83 c4 10             	add    $0x10,%esp
801057bf:	c9                   	leave
801057c0:	c3                   	ret

801057c1 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $0
801057c3:	6a 00                	push   $0x0
  jmp alltraps
801057c5:	e9 38 fb ff ff       	jmp    80105302 <alltraps>

801057ca <vector1>:
.globl vector1
vector1:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $1
801057cc:	6a 01                	push   $0x1
  jmp alltraps
801057ce:	e9 2f fb ff ff       	jmp    80105302 <alltraps>

801057d3 <vector2>:
.globl vector2
vector2:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $2
801057d5:	6a 02                	push   $0x2
  jmp alltraps
801057d7:	e9 26 fb ff ff       	jmp    80105302 <alltraps>

801057dc <vector3>:
.globl vector3
vector3:
  pushl $0
801057dc:	6a 00                	push   $0x0
  pushl $3
801057de:	6a 03                	push   $0x3
  jmp alltraps
801057e0:	e9 1d fb ff ff       	jmp    80105302 <alltraps>

801057e5 <vector4>:
.globl vector4
vector4:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $4
801057e7:	6a 04                	push   $0x4
  jmp alltraps
801057e9:	e9 14 fb ff ff       	jmp    80105302 <alltraps>

801057ee <vector5>:
.globl vector5
vector5:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $5
801057f0:	6a 05                	push   $0x5
  jmp alltraps
801057f2:	e9 0b fb ff ff       	jmp    80105302 <alltraps>

801057f7 <vector6>:
.globl vector6
vector6:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $6
801057f9:	6a 06                	push   $0x6
  jmp alltraps
801057fb:	e9 02 fb ff ff       	jmp    80105302 <alltraps>

80105800 <vector7>:
.globl vector7
vector7:
  pushl $0
80105800:	6a 00                	push   $0x0
  pushl $7
80105802:	6a 07                	push   $0x7
  jmp alltraps
80105804:	e9 f9 fa ff ff       	jmp    80105302 <alltraps>

80105809 <vector8>:
.globl vector8
vector8:
  pushl $8
80105809:	6a 08                	push   $0x8
  jmp alltraps
8010580b:	e9 f2 fa ff ff       	jmp    80105302 <alltraps>

80105810 <vector9>:
.globl vector9
vector9:
  pushl $0
80105810:	6a 00                	push   $0x0
  pushl $9
80105812:	6a 09                	push   $0x9
  jmp alltraps
80105814:	e9 e9 fa ff ff       	jmp    80105302 <alltraps>

80105819 <vector10>:
.globl vector10
vector10:
  pushl $10
80105819:	6a 0a                	push   $0xa
  jmp alltraps
8010581b:	e9 e2 fa ff ff       	jmp    80105302 <alltraps>

80105820 <vector11>:
.globl vector11
vector11:
  pushl $11
80105820:	6a 0b                	push   $0xb
  jmp alltraps
80105822:	e9 db fa ff ff       	jmp    80105302 <alltraps>

80105827 <vector12>:
.globl vector12
vector12:
  pushl $12
80105827:	6a 0c                	push   $0xc
  jmp alltraps
80105829:	e9 d4 fa ff ff       	jmp    80105302 <alltraps>

8010582e <vector13>:
.globl vector13
vector13:
  pushl $13
8010582e:	6a 0d                	push   $0xd
  jmp alltraps
80105830:	e9 cd fa ff ff       	jmp    80105302 <alltraps>

80105835 <vector14>:
.globl vector14
vector14:
  pushl $14
80105835:	6a 0e                	push   $0xe
  jmp alltraps
80105837:	e9 c6 fa ff ff       	jmp    80105302 <alltraps>

8010583c <vector15>:
.globl vector15
vector15:
  pushl $0
8010583c:	6a 00                	push   $0x0
  pushl $15
8010583e:	6a 0f                	push   $0xf
  jmp alltraps
80105840:	e9 bd fa ff ff       	jmp    80105302 <alltraps>

80105845 <vector16>:
.globl vector16
vector16:
  pushl $0
80105845:	6a 00                	push   $0x0
  pushl $16
80105847:	6a 10                	push   $0x10
  jmp alltraps
80105849:	e9 b4 fa ff ff       	jmp    80105302 <alltraps>

8010584e <vector17>:
.globl vector17
vector17:
  pushl $17
8010584e:	6a 11                	push   $0x11
  jmp alltraps
80105850:	e9 ad fa ff ff       	jmp    80105302 <alltraps>

80105855 <vector18>:
.globl vector18
vector18:
  pushl $0
80105855:	6a 00                	push   $0x0
  pushl $18
80105857:	6a 12                	push   $0x12
  jmp alltraps
80105859:	e9 a4 fa ff ff       	jmp    80105302 <alltraps>

8010585e <vector19>:
.globl vector19
vector19:
  pushl $0
8010585e:	6a 00                	push   $0x0
  pushl $19
80105860:	6a 13                	push   $0x13
  jmp alltraps
80105862:	e9 9b fa ff ff       	jmp    80105302 <alltraps>

80105867 <vector20>:
.globl vector20
vector20:
  pushl $0
80105867:	6a 00                	push   $0x0
  pushl $20
80105869:	6a 14                	push   $0x14
  jmp alltraps
8010586b:	e9 92 fa ff ff       	jmp    80105302 <alltraps>

80105870 <vector21>:
.globl vector21
vector21:
  pushl $0
80105870:	6a 00                	push   $0x0
  pushl $21
80105872:	6a 15                	push   $0x15
  jmp alltraps
80105874:	e9 89 fa ff ff       	jmp    80105302 <alltraps>

80105879 <vector22>:
.globl vector22
vector22:
  pushl $0
80105879:	6a 00                	push   $0x0
  pushl $22
8010587b:	6a 16                	push   $0x16
  jmp alltraps
8010587d:	e9 80 fa ff ff       	jmp    80105302 <alltraps>

80105882 <vector23>:
.globl vector23
vector23:
  pushl $0
80105882:	6a 00                	push   $0x0
  pushl $23
80105884:	6a 17                	push   $0x17
  jmp alltraps
80105886:	e9 77 fa ff ff       	jmp    80105302 <alltraps>

8010588b <vector24>:
.globl vector24
vector24:
  pushl $0
8010588b:	6a 00                	push   $0x0
  pushl $24
8010588d:	6a 18                	push   $0x18
  jmp alltraps
8010588f:	e9 6e fa ff ff       	jmp    80105302 <alltraps>

80105894 <vector25>:
.globl vector25
vector25:
  pushl $0
80105894:	6a 00                	push   $0x0
  pushl $25
80105896:	6a 19                	push   $0x19
  jmp alltraps
80105898:	e9 65 fa ff ff       	jmp    80105302 <alltraps>

8010589d <vector26>:
.globl vector26
vector26:
  pushl $0
8010589d:	6a 00                	push   $0x0
  pushl $26
8010589f:	6a 1a                	push   $0x1a
  jmp alltraps
801058a1:	e9 5c fa ff ff       	jmp    80105302 <alltraps>

801058a6 <vector27>:
.globl vector27
vector27:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $27
801058a8:	6a 1b                	push   $0x1b
  jmp alltraps
801058aa:	e9 53 fa ff ff       	jmp    80105302 <alltraps>

801058af <vector28>:
.globl vector28
vector28:
  pushl $0
801058af:	6a 00                	push   $0x0
  pushl $28
801058b1:	6a 1c                	push   $0x1c
  jmp alltraps
801058b3:	e9 4a fa ff ff       	jmp    80105302 <alltraps>

801058b8 <vector29>:
.globl vector29
vector29:
  pushl $0
801058b8:	6a 00                	push   $0x0
  pushl $29
801058ba:	6a 1d                	push   $0x1d
  jmp alltraps
801058bc:	e9 41 fa ff ff       	jmp    80105302 <alltraps>

801058c1 <vector30>:
.globl vector30
vector30:
  pushl $0
801058c1:	6a 00                	push   $0x0
  pushl $30
801058c3:	6a 1e                	push   $0x1e
  jmp alltraps
801058c5:	e9 38 fa ff ff       	jmp    80105302 <alltraps>

801058ca <vector31>:
.globl vector31
vector31:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $31
801058cc:	6a 1f                	push   $0x1f
  jmp alltraps
801058ce:	e9 2f fa ff ff       	jmp    80105302 <alltraps>

801058d3 <vector32>:
.globl vector32
vector32:
  pushl $0
801058d3:	6a 00                	push   $0x0
  pushl $32
801058d5:	6a 20                	push   $0x20
  jmp alltraps
801058d7:	e9 26 fa ff ff       	jmp    80105302 <alltraps>

801058dc <vector33>:
.globl vector33
vector33:
  pushl $0
801058dc:	6a 00                	push   $0x0
  pushl $33
801058de:	6a 21                	push   $0x21
  jmp alltraps
801058e0:	e9 1d fa ff ff       	jmp    80105302 <alltraps>

801058e5 <vector34>:
.globl vector34
vector34:
  pushl $0
801058e5:	6a 00                	push   $0x0
  pushl $34
801058e7:	6a 22                	push   $0x22
  jmp alltraps
801058e9:	e9 14 fa ff ff       	jmp    80105302 <alltraps>

801058ee <vector35>:
.globl vector35
vector35:
  pushl $0
801058ee:	6a 00                	push   $0x0
  pushl $35
801058f0:	6a 23                	push   $0x23
  jmp alltraps
801058f2:	e9 0b fa ff ff       	jmp    80105302 <alltraps>

801058f7 <vector36>:
.globl vector36
vector36:
  pushl $0
801058f7:	6a 00                	push   $0x0
  pushl $36
801058f9:	6a 24                	push   $0x24
  jmp alltraps
801058fb:	e9 02 fa ff ff       	jmp    80105302 <alltraps>

80105900 <vector37>:
.globl vector37
vector37:
  pushl $0
80105900:	6a 00                	push   $0x0
  pushl $37
80105902:	6a 25                	push   $0x25
  jmp alltraps
80105904:	e9 f9 f9 ff ff       	jmp    80105302 <alltraps>

80105909 <vector38>:
.globl vector38
vector38:
  pushl $0
80105909:	6a 00                	push   $0x0
  pushl $38
8010590b:	6a 26                	push   $0x26
  jmp alltraps
8010590d:	e9 f0 f9 ff ff       	jmp    80105302 <alltraps>

80105912 <vector39>:
.globl vector39
vector39:
  pushl $0
80105912:	6a 00                	push   $0x0
  pushl $39
80105914:	6a 27                	push   $0x27
  jmp alltraps
80105916:	e9 e7 f9 ff ff       	jmp    80105302 <alltraps>

8010591b <vector40>:
.globl vector40
vector40:
  pushl $0
8010591b:	6a 00                	push   $0x0
  pushl $40
8010591d:	6a 28                	push   $0x28
  jmp alltraps
8010591f:	e9 de f9 ff ff       	jmp    80105302 <alltraps>

80105924 <vector41>:
.globl vector41
vector41:
  pushl $0
80105924:	6a 00                	push   $0x0
  pushl $41
80105926:	6a 29                	push   $0x29
  jmp alltraps
80105928:	e9 d5 f9 ff ff       	jmp    80105302 <alltraps>

8010592d <vector42>:
.globl vector42
vector42:
  pushl $0
8010592d:	6a 00                	push   $0x0
  pushl $42
8010592f:	6a 2a                	push   $0x2a
  jmp alltraps
80105931:	e9 cc f9 ff ff       	jmp    80105302 <alltraps>

80105936 <vector43>:
.globl vector43
vector43:
  pushl $0
80105936:	6a 00                	push   $0x0
  pushl $43
80105938:	6a 2b                	push   $0x2b
  jmp alltraps
8010593a:	e9 c3 f9 ff ff       	jmp    80105302 <alltraps>

8010593f <vector44>:
.globl vector44
vector44:
  pushl $0
8010593f:	6a 00                	push   $0x0
  pushl $44
80105941:	6a 2c                	push   $0x2c
  jmp alltraps
80105943:	e9 ba f9 ff ff       	jmp    80105302 <alltraps>

80105948 <vector45>:
.globl vector45
vector45:
  pushl $0
80105948:	6a 00                	push   $0x0
  pushl $45
8010594a:	6a 2d                	push   $0x2d
  jmp alltraps
8010594c:	e9 b1 f9 ff ff       	jmp    80105302 <alltraps>

80105951 <vector46>:
.globl vector46
vector46:
  pushl $0
80105951:	6a 00                	push   $0x0
  pushl $46
80105953:	6a 2e                	push   $0x2e
  jmp alltraps
80105955:	e9 a8 f9 ff ff       	jmp    80105302 <alltraps>

8010595a <vector47>:
.globl vector47
vector47:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $47
8010595c:	6a 2f                	push   $0x2f
  jmp alltraps
8010595e:	e9 9f f9 ff ff       	jmp    80105302 <alltraps>

80105963 <vector48>:
.globl vector48
vector48:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $48
80105965:	6a 30                	push   $0x30
  jmp alltraps
80105967:	e9 96 f9 ff ff       	jmp    80105302 <alltraps>

8010596c <vector49>:
.globl vector49
vector49:
  pushl $0
8010596c:	6a 00                	push   $0x0
  pushl $49
8010596e:	6a 31                	push   $0x31
  jmp alltraps
80105970:	e9 8d f9 ff ff       	jmp    80105302 <alltraps>

80105975 <vector50>:
.globl vector50
vector50:
  pushl $0
80105975:	6a 00                	push   $0x0
  pushl $50
80105977:	6a 32                	push   $0x32
  jmp alltraps
80105979:	e9 84 f9 ff ff       	jmp    80105302 <alltraps>

8010597e <vector51>:
.globl vector51
vector51:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $51
80105980:	6a 33                	push   $0x33
  jmp alltraps
80105982:	e9 7b f9 ff ff       	jmp    80105302 <alltraps>

80105987 <vector52>:
.globl vector52
vector52:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $52
80105989:	6a 34                	push   $0x34
  jmp alltraps
8010598b:	e9 72 f9 ff ff       	jmp    80105302 <alltraps>

80105990 <vector53>:
.globl vector53
vector53:
  pushl $0
80105990:	6a 00                	push   $0x0
  pushl $53
80105992:	6a 35                	push   $0x35
  jmp alltraps
80105994:	e9 69 f9 ff ff       	jmp    80105302 <alltraps>

80105999 <vector54>:
.globl vector54
vector54:
  pushl $0
80105999:	6a 00                	push   $0x0
  pushl $54
8010599b:	6a 36                	push   $0x36
  jmp alltraps
8010599d:	e9 60 f9 ff ff       	jmp    80105302 <alltraps>

801059a2 <vector55>:
.globl vector55
vector55:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $55
801059a4:	6a 37                	push   $0x37
  jmp alltraps
801059a6:	e9 57 f9 ff ff       	jmp    80105302 <alltraps>

801059ab <vector56>:
.globl vector56
vector56:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $56
801059ad:	6a 38                	push   $0x38
  jmp alltraps
801059af:	e9 4e f9 ff ff       	jmp    80105302 <alltraps>

801059b4 <vector57>:
.globl vector57
vector57:
  pushl $0
801059b4:	6a 00                	push   $0x0
  pushl $57
801059b6:	6a 39                	push   $0x39
  jmp alltraps
801059b8:	e9 45 f9 ff ff       	jmp    80105302 <alltraps>

801059bd <vector58>:
.globl vector58
vector58:
  pushl $0
801059bd:	6a 00                	push   $0x0
  pushl $58
801059bf:	6a 3a                	push   $0x3a
  jmp alltraps
801059c1:	e9 3c f9 ff ff       	jmp    80105302 <alltraps>

801059c6 <vector59>:
.globl vector59
vector59:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $59
801059c8:	6a 3b                	push   $0x3b
  jmp alltraps
801059ca:	e9 33 f9 ff ff       	jmp    80105302 <alltraps>

801059cf <vector60>:
.globl vector60
vector60:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $60
801059d1:	6a 3c                	push   $0x3c
  jmp alltraps
801059d3:	e9 2a f9 ff ff       	jmp    80105302 <alltraps>

801059d8 <vector61>:
.globl vector61
vector61:
  pushl $0
801059d8:	6a 00                	push   $0x0
  pushl $61
801059da:	6a 3d                	push   $0x3d
  jmp alltraps
801059dc:	e9 21 f9 ff ff       	jmp    80105302 <alltraps>

801059e1 <vector62>:
.globl vector62
vector62:
  pushl $0
801059e1:	6a 00                	push   $0x0
  pushl $62
801059e3:	6a 3e                	push   $0x3e
  jmp alltraps
801059e5:	e9 18 f9 ff ff       	jmp    80105302 <alltraps>

801059ea <vector63>:
.globl vector63
vector63:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $63
801059ec:	6a 3f                	push   $0x3f
  jmp alltraps
801059ee:	e9 0f f9 ff ff       	jmp    80105302 <alltraps>

801059f3 <vector64>:
.globl vector64
vector64:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $64
801059f5:	6a 40                	push   $0x40
  jmp alltraps
801059f7:	e9 06 f9 ff ff       	jmp    80105302 <alltraps>

801059fc <vector65>:
.globl vector65
vector65:
  pushl $0
801059fc:	6a 00                	push   $0x0
  pushl $65
801059fe:	6a 41                	push   $0x41
  jmp alltraps
80105a00:	e9 fd f8 ff ff       	jmp    80105302 <alltraps>

80105a05 <vector66>:
.globl vector66
vector66:
  pushl $0
80105a05:	6a 00                	push   $0x0
  pushl $66
80105a07:	6a 42                	push   $0x42
  jmp alltraps
80105a09:	e9 f4 f8 ff ff       	jmp    80105302 <alltraps>

80105a0e <vector67>:
.globl vector67
vector67:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $67
80105a10:	6a 43                	push   $0x43
  jmp alltraps
80105a12:	e9 eb f8 ff ff       	jmp    80105302 <alltraps>

80105a17 <vector68>:
.globl vector68
vector68:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $68
80105a19:	6a 44                	push   $0x44
  jmp alltraps
80105a1b:	e9 e2 f8 ff ff       	jmp    80105302 <alltraps>

80105a20 <vector69>:
.globl vector69
vector69:
  pushl $0
80105a20:	6a 00                	push   $0x0
  pushl $69
80105a22:	6a 45                	push   $0x45
  jmp alltraps
80105a24:	e9 d9 f8 ff ff       	jmp    80105302 <alltraps>

80105a29 <vector70>:
.globl vector70
vector70:
  pushl $0
80105a29:	6a 00                	push   $0x0
  pushl $70
80105a2b:	6a 46                	push   $0x46
  jmp alltraps
80105a2d:	e9 d0 f8 ff ff       	jmp    80105302 <alltraps>

80105a32 <vector71>:
.globl vector71
vector71:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $71
80105a34:	6a 47                	push   $0x47
  jmp alltraps
80105a36:	e9 c7 f8 ff ff       	jmp    80105302 <alltraps>

80105a3b <vector72>:
.globl vector72
vector72:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $72
80105a3d:	6a 48                	push   $0x48
  jmp alltraps
80105a3f:	e9 be f8 ff ff       	jmp    80105302 <alltraps>

80105a44 <vector73>:
.globl vector73
vector73:
  pushl $0
80105a44:	6a 00                	push   $0x0
  pushl $73
80105a46:	6a 49                	push   $0x49
  jmp alltraps
80105a48:	e9 b5 f8 ff ff       	jmp    80105302 <alltraps>

80105a4d <vector74>:
.globl vector74
vector74:
  pushl $0
80105a4d:	6a 00                	push   $0x0
  pushl $74
80105a4f:	6a 4a                	push   $0x4a
  jmp alltraps
80105a51:	e9 ac f8 ff ff       	jmp    80105302 <alltraps>

80105a56 <vector75>:
.globl vector75
vector75:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $75
80105a58:	6a 4b                	push   $0x4b
  jmp alltraps
80105a5a:	e9 a3 f8 ff ff       	jmp    80105302 <alltraps>

80105a5f <vector76>:
.globl vector76
vector76:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $76
80105a61:	6a 4c                	push   $0x4c
  jmp alltraps
80105a63:	e9 9a f8 ff ff       	jmp    80105302 <alltraps>

80105a68 <vector77>:
.globl vector77
vector77:
  pushl $0
80105a68:	6a 00                	push   $0x0
  pushl $77
80105a6a:	6a 4d                	push   $0x4d
  jmp alltraps
80105a6c:	e9 91 f8 ff ff       	jmp    80105302 <alltraps>

80105a71 <vector78>:
.globl vector78
vector78:
  pushl $0
80105a71:	6a 00                	push   $0x0
  pushl $78
80105a73:	6a 4e                	push   $0x4e
  jmp alltraps
80105a75:	e9 88 f8 ff ff       	jmp    80105302 <alltraps>

80105a7a <vector79>:
.globl vector79
vector79:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $79
80105a7c:	6a 4f                	push   $0x4f
  jmp alltraps
80105a7e:	e9 7f f8 ff ff       	jmp    80105302 <alltraps>

80105a83 <vector80>:
.globl vector80
vector80:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $80
80105a85:	6a 50                	push   $0x50
  jmp alltraps
80105a87:	e9 76 f8 ff ff       	jmp    80105302 <alltraps>

80105a8c <vector81>:
.globl vector81
vector81:
  pushl $0
80105a8c:	6a 00                	push   $0x0
  pushl $81
80105a8e:	6a 51                	push   $0x51
  jmp alltraps
80105a90:	e9 6d f8 ff ff       	jmp    80105302 <alltraps>

80105a95 <vector82>:
.globl vector82
vector82:
  pushl $0
80105a95:	6a 00                	push   $0x0
  pushl $82
80105a97:	6a 52                	push   $0x52
  jmp alltraps
80105a99:	e9 64 f8 ff ff       	jmp    80105302 <alltraps>

80105a9e <vector83>:
.globl vector83
vector83:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $83
80105aa0:	6a 53                	push   $0x53
  jmp alltraps
80105aa2:	e9 5b f8 ff ff       	jmp    80105302 <alltraps>

80105aa7 <vector84>:
.globl vector84
vector84:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $84
80105aa9:	6a 54                	push   $0x54
  jmp alltraps
80105aab:	e9 52 f8 ff ff       	jmp    80105302 <alltraps>

80105ab0 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ab0:	6a 00                	push   $0x0
  pushl $85
80105ab2:	6a 55                	push   $0x55
  jmp alltraps
80105ab4:	e9 49 f8 ff ff       	jmp    80105302 <alltraps>

80105ab9 <vector86>:
.globl vector86
vector86:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $86
80105abb:	6a 56                	push   $0x56
  jmp alltraps
80105abd:	e9 40 f8 ff ff       	jmp    80105302 <alltraps>

80105ac2 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $87
80105ac4:	6a 57                	push   $0x57
  jmp alltraps
80105ac6:	e9 37 f8 ff ff       	jmp    80105302 <alltraps>

80105acb <vector88>:
.globl vector88
vector88:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $88
80105acd:	6a 58                	push   $0x58
  jmp alltraps
80105acf:	e9 2e f8 ff ff       	jmp    80105302 <alltraps>

80105ad4 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $89
80105ad6:	6a 59                	push   $0x59
  jmp alltraps
80105ad8:	e9 25 f8 ff ff       	jmp    80105302 <alltraps>

80105add <vector90>:
.globl vector90
vector90:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $90
80105adf:	6a 5a                	push   $0x5a
  jmp alltraps
80105ae1:	e9 1c f8 ff ff       	jmp    80105302 <alltraps>

80105ae6 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $91
80105ae8:	6a 5b                	push   $0x5b
  jmp alltraps
80105aea:	e9 13 f8 ff ff       	jmp    80105302 <alltraps>

80105aef <vector92>:
.globl vector92
vector92:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $92
80105af1:	6a 5c                	push   $0x5c
  jmp alltraps
80105af3:	e9 0a f8 ff ff       	jmp    80105302 <alltraps>

80105af8 <vector93>:
.globl vector93
vector93:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $93
80105afa:	6a 5d                	push   $0x5d
  jmp alltraps
80105afc:	e9 01 f8 ff ff       	jmp    80105302 <alltraps>

80105b01 <vector94>:
.globl vector94
vector94:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $94
80105b03:	6a 5e                	push   $0x5e
  jmp alltraps
80105b05:	e9 f8 f7 ff ff       	jmp    80105302 <alltraps>

80105b0a <vector95>:
.globl vector95
vector95:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $95
80105b0c:	6a 5f                	push   $0x5f
  jmp alltraps
80105b0e:	e9 ef f7 ff ff       	jmp    80105302 <alltraps>

80105b13 <vector96>:
.globl vector96
vector96:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $96
80105b15:	6a 60                	push   $0x60
  jmp alltraps
80105b17:	e9 e6 f7 ff ff       	jmp    80105302 <alltraps>

80105b1c <vector97>:
.globl vector97
vector97:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $97
80105b1e:	6a 61                	push   $0x61
  jmp alltraps
80105b20:	e9 dd f7 ff ff       	jmp    80105302 <alltraps>

80105b25 <vector98>:
.globl vector98
vector98:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $98
80105b27:	6a 62                	push   $0x62
  jmp alltraps
80105b29:	e9 d4 f7 ff ff       	jmp    80105302 <alltraps>

80105b2e <vector99>:
.globl vector99
vector99:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $99
80105b30:	6a 63                	push   $0x63
  jmp alltraps
80105b32:	e9 cb f7 ff ff       	jmp    80105302 <alltraps>

80105b37 <vector100>:
.globl vector100
vector100:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $100
80105b39:	6a 64                	push   $0x64
  jmp alltraps
80105b3b:	e9 c2 f7 ff ff       	jmp    80105302 <alltraps>

80105b40 <vector101>:
.globl vector101
vector101:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $101
80105b42:	6a 65                	push   $0x65
  jmp alltraps
80105b44:	e9 b9 f7 ff ff       	jmp    80105302 <alltraps>

80105b49 <vector102>:
.globl vector102
vector102:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $102
80105b4b:	6a 66                	push   $0x66
  jmp alltraps
80105b4d:	e9 b0 f7 ff ff       	jmp    80105302 <alltraps>

80105b52 <vector103>:
.globl vector103
vector103:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $103
80105b54:	6a 67                	push   $0x67
  jmp alltraps
80105b56:	e9 a7 f7 ff ff       	jmp    80105302 <alltraps>

80105b5b <vector104>:
.globl vector104
vector104:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $104
80105b5d:	6a 68                	push   $0x68
  jmp alltraps
80105b5f:	e9 9e f7 ff ff       	jmp    80105302 <alltraps>

80105b64 <vector105>:
.globl vector105
vector105:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $105
80105b66:	6a 69                	push   $0x69
  jmp alltraps
80105b68:	e9 95 f7 ff ff       	jmp    80105302 <alltraps>

80105b6d <vector106>:
.globl vector106
vector106:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $106
80105b6f:	6a 6a                	push   $0x6a
  jmp alltraps
80105b71:	e9 8c f7 ff ff       	jmp    80105302 <alltraps>

80105b76 <vector107>:
.globl vector107
vector107:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $107
80105b78:	6a 6b                	push   $0x6b
  jmp alltraps
80105b7a:	e9 83 f7 ff ff       	jmp    80105302 <alltraps>

80105b7f <vector108>:
.globl vector108
vector108:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $108
80105b81:	6a 6c                	push   $0x6c
  jmp alltraps
80105b83:	e9 7a f7 ff ff       	jmp    80105302 <alltraps>

80105b88 <vector109>:
.globl vector109
vector109:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $109
80105b8a:	6a 6d                	push   $0x6d
  jmp alltraps
80105b8c:	e9 71 f7 ff ff       	jmp    80105302 <alltraps>

80105b91 <vector110>:
.globl vector110
vector110:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $110
80105b93:	6a 6e                	push   $0x6e
  jmp alltraps
80105b95:	e9 68 f7 ff ff       	jmp    80105302 <alltraps>

80105b9a <vector111>:
.globl vector111
vector111:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $111
80105b9c:	6a 6f                	push   $0x6f
  jmp alltraps
80105b9e:	e9 5f f7 ff ff       	jmp    80105302 <alltraps>

80105ba3 <vector112>:
.globl vector112
vector112:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $112
80105ba5:	6a 70                	push   $0x70
  jmp alltraps
80105ba7:	e9 56 f7 ff ff       	jmp    80105302 <alltraps>

80105bac <vector113>:
.globl vector113
vector113:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $113
80105bae:	6a 71                	push   $0x71
  jmp alltraps
80105bb0:	e9 4d f7 ff ff       	jmp    80105302 <alltraps>

80105bb5 <vector114>:
.globl vector114
vector114:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $114
80105bb7:	6a 72                	push   $0x72
  jmp alltraps
80105bb9:	e9 44 f7 ff ff       	jmp    80105302 <alltraps>

80105bbe <vector115>:
.globl vector115
vector115:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $115
80105bc0:	6a 73                	push   $0x73
  jmp alltraps
80105bc2:	e9 3b f7 ff ff       	jmp    80105302 <alltraps>

80105bc7 <vector116>:
.globl vector116
vector116:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $116
80105bc9:	6a 74                	push   $0x74
  jmp alltraps
80105bcb:	e9 32 f7 ff ff       	jmp    80105302 <alltraps>

80105bd0 <vector117>:
.globl vector117
vector117:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $117
80105bd2:	6a 75                	push   $0x75
  jmp alltraps
80105bd4:	e9 29 f7 ff ff       	jmp    80105302 <alltraps>

80105bd9 <vector118>:
.globl vector118
vector118:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $118
80105bdb:	6a 76                	push   $0x76
  jmp alltraps
80105bdd:	e9 20 f7 ff ff       	jmp    80105302 <alltraps>

80105be2 <vector119>:
.globl vector119
vector119:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $119
80105be4:	6a 77                	push   $0x77
  jmp alltraps
80105be6:	e9 17 f7 ff ff       	jmp    80105302 <alltraps>

80105beb <vector120>:
.globl vector120
vector120:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $120
80105bed:	6a 78                	push   $0x78
  jmp alltraps
80105bef:	e9 0e f7 ff ff       	jmp    80105302 <alltraps>

80105bf4 <vector121>:
.globl vector121
vector121:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $121
80105bf6:	6a 79                	push   $0x79
  jmp alltraps
80105bf8:	e9 05 f7 ff ff       	jmp    80105302 <alltraps>

80105bfd <vector122>:
.globl vector122
vector122:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $122
80105bff:	6a 7a                	push   $0x7a
  jmp alltraps
80105c01:	e9 fc f6 ff ff       	jmp    80105302 <alltraps>

80105c06 <vector123>:
.globl vector123
vector123:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $123
80105c08:	6a 7b                	push   $0x7b
  jmp alltraps
80105c0a:	e9 f3 f6 ff ff       	jmp    80105302 <alltraps>

80105c0f <vector124>:
.globl vector124
vector124:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $124
80105c11:	6a 7c                	push   $0x7c
  jmp alltraps
80105c13:	e9 ea f6 ff ff       	jmp    80105302 <alltraps>

80105c18 <vector125>:
.globl vector125
vector125:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $125
80105c1a:	6a 7d                	push   $0x7d
  jmp alltraps
80105c1c:	e9 e1 f6 ff ff       	jmp    80105302 <alltraps>

80105c21 <vector126>:
.globl vector126
vector126:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $126
80105c23:	6a 7e                	push   $0x7e
  jmp alltraps
80105c25:	e9 d8 f6 ff ff       	jmp    80105302 <alltraps>

80105c2a <vector127>:
.globl vector127
vector127:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $127
80105c2c:	6a 7f                	push   $0x7f
  jmp alltraps
80105c2e:	e9 cf f6 ff ff       	jmp    80105302 <alltraps>

80105c33 <vector128>:
.globl vector128
vector128:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $128
80105c35:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105c3a:	e9 c3 f6 ff ff       	jmp    80105302 <alltraps>

80105c3f <vector129>:
.globl vector129
vector129:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $129
80105c41:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105c46:	e9 b7 f6 ff ff       	jmp    80105302 <alltraps>

80105c4b <vector130>:
.globl vector130
vector130:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $130
80105c4d:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105c52:	e9 ab f6 ff ff       	jmp    80105302 <alltraps>

80105c57 <vector131>:
.globl vector131
vector131:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $131
80105c59:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105c5e:	e9 9f f6 ff ff       	jmp    80105302 <alltraps>

80105c63 <vector132>:
.globl vector132
vector132:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $132
80105c65:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105c6a:	e9 93 f6 ff ff       	jmp    80105302 <alltraps>

80105c6f <vector133>:
.globl vector133
vector133:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $133
80105c71:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105c76:	e9 87 f6 ff ff       	jmp    80105302 <alltraps>

80105c7b <vector134>:
.globl vector134
vector134:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $134
80105c7d:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105c82:	e9 7b f6 ff ff       	jmp    80105302 <alltraps>

80105c87 <vector135>:
.globl vector135
vector135:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $135
80105c89:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105c8e:	e9 6f f6 ff ff       	jmp    80105302 <alltraps>

80105c93 <vector136>:
.globl vector136
vector136:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $136
80105c95:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105c9a:	e9 63 f6 ff ff       	jmp    80105302 <alltraps>

80105c9f <vector137>:
.globl vector137
vector137:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $137
80105ca1:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105ca6:	e9 57 f6 ff ff       	jmp    80105302 <alltraps>

80105cab <vector138>:
.globl vector138
vector138:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $138
80105cad:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105cb2:	e9 4b f6 ff ff       	jmp    80105302 <alltraps>

80105cb7 <vector139>:
.globl vector139
vector139:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $139
80105cb9:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105cbe:	e9 3f f6 ff ff       	jmp    80105302 <alltraps>

80105cc3 <vector140>:
.globl vector140
vector140:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $140
80105cc5:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105cca:	e9 33 f6 ff ff       	jmp    80105302 <alltraps>

80105ccf <vector141>:
.globl vector141
vector141:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $141
80105cd1:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105cd6:	e9 27 f6 ff ff       	jmp    80105302 <alltraps>

80105cdb <vector142>:
.globl vector142
vector142:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $142
80105cdd:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ce2:	e9 1b f6 ff ff       	jmp    80105302 <alltraps>

80105ce7 <vector143>:
.globl vector143
vector143:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $143
80105ce9:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105cee:	e9 0f f6 ff ff       	jmp    80105302 <alltraps>

80105cf3 <vector144>:
.globl vector144
vector144:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $144
80105cf5:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105cfa:	e9 03 f6 ff ff       	jmp    80105302 <alltraps>

80105cff <vector145>:
.globl vector145
vector145:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $145
80105d01:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105d06:	e9 f7 f5 ff ff       	jmp    80105302 <alltraps>

80105d0b <vector146>:
.globl vector146
vector146:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $146
80105d0d:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105d12:	e9 eb f5 ff ff       	jmp    80105302 <alltraps>

80105d17 <vector147>:
.globl vector147
vector147:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $147
80105d19:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105d1e:	e9 df f5 ff ff       	jmp    80105302 <alltraps>

80105d23 <vector148>:
.globl vector148
vector148:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $148
80105d25:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105d2a:	e9 d3 f5 ff ff       	jmp    80105302 <alltraps>

80105d2f <vector149>:
.globl vector149
vector149:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $149
80105d31:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105d36:	e9 c7 f5 ff ff       	jmp    80105302 <alltraps>

80105d3b <vector150>:
.globl vector150
vector150:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $150
80105d3d:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105d42:	e9 bb f5 ff ff       	jmp    80105302 <alltraps>

80105d47 <vector151>:
.globl vector151
vector151:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $151
80105d49:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105d4e:	e9 af f5 ff ff       	jmp    80105302 <alltraps>

80105d53 <vector152>:
.globl vector152
vector152:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $152
80105d55:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105d5a:	e9 a3 f5 ff ff       	jmp    80105302 <alltraps>

80105d5f <vector153>:
.globl vector153
vector153:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $153
80105d61:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105d66:	e9 97 f5 ff ff       	jmp    80105302 <alltraps>

80105d6b <vector154>:
.globl vector154
vector154:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $154
80105d6d:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105d72:	e9 8b f5 ff ff       	jmp    80105302 <alltraps>

80105d77 <vector155>:
.globl vector155
vector155:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $155
80105d79:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105d7e:	e9 7f f5 ff ff       	jmp    80105302 <alltraps>

80105d83 <vector156>:
.globl vector156
vector156:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $156
80105d85:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105d8a:	e9 73 f5 ff ff       	jmp    80105302 <alltraps>

80105d8f <vector157>:
.globl vector157
vector157:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $157
80105d91:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105d96:	e9 67 f5 ff ff       	jmp    80105302 <alltraps>

80105d9b <vector158>:
.globl vector158
vector158:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $158
80105d9d:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105da2:	e9 5b f5 ff ff       	jmp    80105302 <alltraps>

80105da7 <vector159>:
.globl vector159
vector159:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $159
80105da9:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105dae:	e9 4f f5 ff ff       	jmp    80105302 <alltraps>

80105db3 <vector160>:
.globl vector160
vector160:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $160
80105db5:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105dba:	e9 43 f5 ff ff       	jmp    80105302 <alltraps>

80105dbf <vector161>:
.globl vector161
vector161:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $161
80105dc1:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105dc6:	e9 37 f5 ff ff       	jmp    80105302 <alltraps>

80105dcb <vector162>:
.globl vector162
vector162:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $162
80105dcd:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105dd2:	e9 2b f5 ff ff       	jmp    80105302 <alltraps>

80105dd7 <vector163>:
.globl vector163
vector163:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $163
80105dd9:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105dde:	e9 1f f5 ff ff       	jmp    80105302 <alltraps>

80105de3 <vector164>:
.globl vector164
vector164:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $164
80105de5:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105dea:	e9 13 f5 ff ff       	jmp    80105302 <alltraps>

80105def <vector165>:
.globl vector165
vector165:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $165
80105df1:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105df6:	e9 07 f5 ff ff       	jmp    80105302 <alltraps>

80105dfb <vector166>:
.globl vector166
vector166:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $166
80105dfd:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105e02:	e9 fb f4 ff ff       	jmp    80105302 <alltraps>

80105e07 <vector167>:
.globl vector167
vector167:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $167
80105e09:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105e0e:	e9 ef f4 ff ff       	jmp    80105302 <alltraps>

80105e13 <vector168>:
.globl vector168
vector168:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $168
80105e15:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105e1a:	e9 e3 f4 ff ff       	jmp    80105302 <alltraps>

80105e1f <vector169>:
.globl vector169
vector169:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $169
80105e21:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105e26:	e9 d7 f4 ff ff       	jmp    80105302 <alltraps>

80105e2b <vector170>:
.globl vector170
vector170:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $170
80105e2d:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105e32:	e9 cb f4 ff ff       	jmp    80105302 <alltraps>

80105e37 <vector171>:
.globl vector171
vector171:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $171
80105e39:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105e3e:	e9 bf f4 ff ff       	jmp    80105302 <alltraps>

80105e43 <vector172>:
.globl vector172
vector172:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $172
80105e45:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105e4a:	e9 b3 f4 ff ff       	jmp    80105302 <alltraps>

80105e4f <vector173>:
.globl vector173
vector173:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $173
80105e51:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105e56:	e9 a7 f4 ff ff       	jmp    80105302 <alltraps>

80105e5b <vector174>:
.globl vector174
vector174:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $174
80105e5d:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105e62:	e9 9b f4 ff ff       	jmp    80105302 <alltraps>

80105e67 <vector175>:
.globl vector175
vector175:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $175
80105e69:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105e6e:	e9 8f f4 ff ff       	jmp    80105302 <alltraps>

80105e73 <vector176>:
.globl vector176
vector176:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $176
80105e75:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105e7a:	e9 83 f4 ff ff       	jmp    80105302 <alltraps>

80105e7f <vector177>:
.globl vector177
vector177:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $177
80105e81:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105e86:	e9 77 f4 ff ff       	jmp    80105302 <alltraps>

80105e8b <vector178>:
.globl vector178
vector178:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $178
80105e8d:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105e92:	e9 6b f4 ff ff       	jmp    80105302 <alltraps>

80105e97 <vector179>:
.globl vector179
vector179:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $179
80105e99:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105e9e:	e9 5f f4 ff ff       	jmp    80105302 <alltraps>

80105ea3 <vector180>:
.globl vector180
vector180:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $180
80105ea5:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105eaa:	e9 53 f4 ff ff       	jmp    80105302 <alltraps>

80105eaf <vector181>:
.globl vector181
vector181:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $181
80105eb1:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105eb6:	e9 47 f4 ff ff       	jmp    80105302 <alltraps>

80105ebb <vector182>:
.globl vector182
vector182:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $182
80105ebd:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105ec2:	e9 3b f4 ff ff       	jmp    80105302 <alltraps>

80105ec7 <vector183>:
.globl vector183
vector183:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $183
80105ec9:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105ece:	e9 2f f4 ff ff       	jmp    80105302 <alltraps>

80105ed3 <vector184>:
.globl vector184
vector184:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $184
80105ed5:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105eda:	e9 23 f4 ff ff       	jmp    80105302 <alltraps>

80105edf <vector185>:
.globl vector185
vector185:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $185
80105ee1:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105ee6:	e9 17 f4 ff ff       	jmp    80105302 <alltraps>

80105eeb <vector186>:
.globl vector186
vector186:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $186
80105eed:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105ef2:	e9 0b f4 ff ff       	jmp    80105302 <alltraps>

80105ef7 <vector187>:
.globl vector187
vector187:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $187
80105ef9:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105efe:	e9 ff f3 ff ff       	jmp    80105302 <alltraps>

80105f03 <vector188>:
.globl vector188
vector188:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $188
80105f05:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105f0a:	e9 f3 f3 ff ff       	jmp    80105302 <alltraps>

80105f0f <vector189>:
.globl vector189
vector189:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $189
80105f11:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105f16:	e9 e7 f3 ff ff       	jmp    80105302 <alltraps>

80105f1b <vector190>:
.globl vector190
vector190:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $190
80105f1d:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105f22:	e9 db f3 ff ff       	jmp    80105302 <alltraps>

80105f27 <vector191>:
.globl vector191
vector191:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $191
80105f29:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105f2e:	e9 cf f3 ff ff       	jmp    80105302 <alltraps>

80105f33 <vector192>:
.globl vector192
vector192:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $192
80105f35:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105f3a:	e9 c3 f3 ff ff       	jmp    80105302 <alltraps>

80105f3f <vector193>:
.globl vector193
vector193:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $193
80105f41:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105f46:	e9 b7 f3 ff ff       	jmp    80105302 <alltraps>

80105f4b <vector194>:
.globl vector194
vector194:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $194
80105f4d:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105f52:	e9 ab f3 ff ff       	jmp    80105302 <alltraps>

80105f57 <vector195>:
.globl vector195
vector195:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $195
80105f59:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105f5e:	e9 9f f3 ff ff       	jmp    80105302 <alltraps>

80105f63 <vector196>:
.globl vector196
vector196:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $196
80105f65:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105f6a:	e9 93 f3 ff ff       	jmp    80105302 <alltraps>

80105f6f <vector197>:
.globl vector197
vector197:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $197
80105f71:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105f76:	e9 87 f3 ff ff       	jmp    80105302 <alltraps>

80105f7b <vector198>:
.globl vector198
vector198:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $198
80105f7d:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105f82:	e9 7b f3 ff ff       	jmp    80105302 <alltraps>

80105f87 <vector199>:
.globl vector199
vector199:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $199
80105f89:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105f8e:	e9 6f f3 ff ff       	jmp    80105302 <alltraps>

80105f93 <vector200>:
.globl vector200
vector200:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $200
80105f95:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105f9a:	e9 63 f3 ff ff       	jmp    80105302 <alltraps>

80105f9f <vector201>:
.globl vector201
vector201:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $201
80105fa1:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105fa6:	e9 57 f3 ff ff       	jmp    80105302 <alltraps>

80105fab <vector202>:
.globl vector202
vector202:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $202
80105fad:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105fb2:	e9 4b f3 ff ff       	jmp    80105302 <alltraps>

80105fb7 <vector203>:
.globl vector203
vector203:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $203
80105fb9:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105fbe:	e9 3f f3 ff ff       	jmp    80105302 <alltraps>

80105fc3 <vector204>:
.globl vector204
vector204:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $204
80105fc5:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105fca:	e9 33 f3 ff ff       	jmp    80105302 <alltraps>

80105fcf <vector205>:
.globl vector205
vector205:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $205
80105fd1:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105fd6:	e9 27 f3 ff ff       	jmp    80105302 <alltraps>

80105fdb <vector206>:
.globl vector206
vector206:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $206
80105fdd:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105fe2:	e9 1b f3 ff ff       	jmp    80105302 <alltraps>

80105fe7 <vector207>:
.globl vector207
vector207:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $207
80105fe9:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105fee:	e9 0f f3 ff ff       	jmp    80105302 <alltraps>

80105ff3 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $208
80105ff5:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105ffa:	e9 03 f3 ff ff       	jmp    80105302 <alltraps>

80105fff <vector209>:
.globl vector209
vector209:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $209
80106001:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106006:	e9 f7 f2 ff ff       	jmp    80105302 <alltraps>

8010600b <vector210>:
.globl vector210
vector210:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $210
8010600d:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106012:	e9 eb f2 ff ff       	jmp    80105302 <alltraps>

80106017 <vector211>:
.globl vector211
vector211:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $211
80106019:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010601e:	e9 df f2 ff ff       	jmp    80105302 <alltraps>

80106023 <vector212>:
.globl vector212
vector212:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $212
80106025:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010602a:	e9 d3 f2 ff ff       	jmp    80105302 <alltraps>

8010602f <vector213>:
.globl vector213
vector213:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $213
80106031:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106036:	e9 c7 f2 ff ff       	jmp    80105302 <alltraps>

8010603b <vector214>:
.globl vector214
vector214:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $214
8010603d:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106042:	e9 bb f2 ff ff       	jmp    80105302 <alltraps>

80106047 <vector215>:
.globl vector215
vector215:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $215
80106049:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010604e:	e9 af f2 ff ff       	jmp    80105302 <alltraps>

80106053 <vector216>:
.globl vector216
vector216:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $216
80106055:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010605a:	e9 a3 f2 ff ff       	jmp    80105302 <alltraps>

8010605f <vector217>:
.globl vector217
vector217:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $217
80106061:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106066:	e9 97 f2 ff ff       	jmp    80105302 <alltraps>

8010606b <vector218>:
.globl vector218
vector218:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $218
8010606d:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106072:	e9 8b f2 ff ff       	jmp    80105302 <alltraps>

80106077 <vector219>:
.globl vector219
vector219:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $219
80106079:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010607e:	e9 7f f2 ff ff       	jmp    80105302 <alltraps>

80106083 <vector220>:
.globl vector220
vector220:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $220
80106085:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010608a:	e9 73 f2 ff ff       	jmp    80105302 <alltraps>

8010608f <vector221>:
.globl vector221
vector221:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $221
80106091:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106096:	e9 67 f2 ff ff       	jmp    80105302 <alltraps>

8010609b <vector222>:
.globl vector222
vector222:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $222
8010609d:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801060a2:	e9 5b f2 ff ff       	jmp    80105302 <alltraps>

801060a7 <vector223>:
.globl vector223
vector223:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $223
801060a9:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801060ae:	e9 4f f2 ff ff       	jmp    80105302 <alltraps>

801060b3 <vector224>:
.globl vector224
vector224:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $224
801060b5:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801060ba:	e9 43 f2 ff ff       	jmp    80105302 <alltraps>

801060bf <vector225>:
.globl vector225
vector225:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $225
801060c1:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801060c6:	e9 37 f2 ff ff       	jmp    80105302 <alltraps>

801060cb <vector226>:
.globl vector226
vector226:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $226
801060cd:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801060d2:	e9 2b f2 ff ff       	jmp    80105302 <alltraps>

801060d7 <vector227>:
.globl vector227
vector227:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $227
801060d9:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801060de:	e9 1f f2 ff ff       	jmp    80105302 <alltraps>

801060e3 <vector228>:
.globl vector228
vector228:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $228
801060e5:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801060ea:	e9 13 f2 ff ff       	jmp    80105302 <alltraps>

801060ef <vector229>:
.globl vector229
vector229:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $229
801060f1:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801060f6:	e9 07 f2 ff ff       	jmp    80105302 <alltraps>

801060fb <vector230>:
.globl vector230
vector230:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $230
801060fd:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106102:	e9 fb f1 ff ff       	jmp    80105302 <alltraps>

80106107 <vector231>:
.globl vector231
vector231:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $231
80106109:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010610e:	e9 ef f1 ff ff       	jmp    80105302 <alltraps>

80106113 <vector232>:
.globl vector232
vector232:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $232
80106115:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010611a:	e9 e3 f1 ff ff       	jmp    80105302 <alltraps>

8010611f <vector233>:
.globl vector233
vector233:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $233
80106121:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106126:	e9 d7 f1 ff ff       	jmp    80105302 <alltraps>

8010612b <vector234>:
.globl vector234
vector234:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $234
8010612d:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106132:	e9 cb f1 ff ff       	jmp    80105302 <alltraps>

80106137 <vector235>:
.globl vector235
vector235:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $235
80106139:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010613e:	e9 bf f1 ff ff       	jmp    80105302 <alltraps>

80106143 <vector236>:
.globl vector236
vector236:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $236
80106145:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010614a:	e9 b3 f1 ff ff       	jmp    80105302 <alltraps>

8010614f <vector237>:
.globl vector237
vector237:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $237
80106151:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106156:	e9 a7 f1 ff ff       	jmp    80105302 <alltraps>

8010615b <vector238>:
.globl vector238
vector238:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $238
8010615d:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106162:	e9 9b f1 ff ff       	jmp    80105302 <alltraps>

80106167 <vector239>:
.globl vector239
vector239:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $239
80106169:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010616e:	e9 8f f1 ff ff       	jmp    80105302 <alltraps>

80106173 <vector240>:
.globl vector240
vector240:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $240
80106175:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010617a:	e9 83 f1 ff ff       	jmp    80105302 <alltraps>

8010617f <vector241>:
.globl vector241
vector241:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $241
80106181:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106186:	e9 77 f1 ff ff       	jmp    80105302 <alltraps>

8010618b <vector242>:
.globl vector242
vector242:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $242
8010618d:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106192:	e9 6b f1 ff ff       	jmp    80105302 <alltraps>

80106197 <vector243>:
.globl vector243
vector243:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $243
80106199:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010619e:	e9 5f f1 ff ff       	jmp    80105302 <alltraps>

801061a3 <vector244>:
.globl vector244
vector244:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $244
801061a5:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801061aa:	e9 53 f1 ff ff       	jmp    80105302 <alltraps>

801061af <vector245>:
.globl vector245
vector245:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $245
801061b1:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801061b6:	e9 47 f1 ff ff       	jmp    80105302 <alltraps>

801061bb <vector246>:
.globl vector246
vector246:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $246
801061bd:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801061c2:	e9 3b f1 ff ff       	jmp    80105302 <alltraps>

801061c7 <vector247>:
.globl vector247
vector247:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $247
801061c9:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801061ce:	e9 2f f1 ff ff       	jmp    80105302 <alltraps>

801061d3 <vector248>:
.globl vector248
vector248:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $248
801061d5:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801061da:	e9 23 f1 ff ff       	jmp    80105302 <alltraps>

801061df <vector249>:
.globl vector249
vector249:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $249
801061e1:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801061e6:	e9 17 f1 ff ff       	jmp    80105302 <alltraps>

801061eb <vector250>:
.globl vector250
vector250:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $250
801061ed:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801061f2:	e9 0b f1 ff ff       	jmp    80105302 <alltraps>

801061f7 <vector251>:
.globl vector251
vector251:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $251
801061f9:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801061fe:	e9 ff f0 ff ff       	jmp    80105302 <alltraps>

80106203 <vector252>:
.globl vector252
vector252:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $252
80106205:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010620a:	e9 f3 f0 ff ff       	jmp    80105302 <alltraps>

8010620f <vector253>:
.globl vector253
vector253:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $253
80106211:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106216:	e9 e7 f0 ff ff       	jmp    80105302 <alltraps>

8010621b <vector254>:
.globl vector254
vector254:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $254
8010621d:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106222:	e9 db f0 ff ff       	jmp    80105302 <alltraps>

80106227 <vector255>:
.globl vector255
vector255:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $255
80106229:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010622e:	e9 cf f0 ff ff       	jmp    80105302 <alltraps>
80106233:	90                   	nop

80106234 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	57                   	push   %edi
80106238:	56                   	push   %esi
80106239:	53                   	push   %ebx
8010623a:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010623d:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106243:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106249:	39 d3                	cmp    %edx,%ebx
8010624b:	73 50                	jae    8010629d <deallocuvm.part.0+0x69>
8010624d:	89 c6                	mov    %eax,%esi
8010624f:	89 d7                	mov    %edx,%edi
80106251:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106254:	eb 0c                	jmp    80106262 <deallocuvm.part.0+0x2e>
80106256:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106258:	42                   	inc    %edx
80106259:	89 d3                	mov    %edx,%ebx
8010625b:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010625e:	39 fb                	cmp    %edi,%ebx
80106260:	73 38                	jae    8010629a <deallocuvm.part.0+0x66>
  pde = &pgdir[PDX(va)];
80106262:	89 da                	mov    %ebx,%edx
80106264:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106267:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010626a:	a8 01                	test   $0x1,%al
8010626c:	74 ea                	je     80106258 <deallocuvm.part.0+0x24>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010626e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106273:	89 d9                	mov    %ebx,%ecx
80106275:	c1 e9 0a             	shr    $0xa,%ecx
80106278:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
8010627e:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106285:	85 c0                	test   %eax,%eax
80106287:	74 cf                	je     80106258 <deallocuvm.part.0+0x24>
    else if((*pte & PTE_P) != 0){
80106289:	8b 10                	mov    (%eax),%edx
8010628b:	f6 c2 01             	test   $0x1,%dl
8010628e:	75 18                	jne    801062a8 <deallocuvm.part.0+0x74>
  for(; a  < oldsz; a += PGSIZE){
80106290:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106296:	39 fb                	cmp    %edi,%ebx
80106298:	72 c8                	jb     80106262 <deallocuvm.part.0+0x2e>
8010629a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010629d:	89 c8                	mov    %ecx,%eax
8010629f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a2:	5b                   	pop    %ebx
801062a3:	5e                   	pop    %esi
801062a4:	5f                   	pop    %edi
801062a5:	5d                   	pop    %ebp
801062a6:	c3                   	ret
801062a7:	90                   	nop
      if(pa == 0)
801062a8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801062ae:	74 26                	je     801062d6 <deallocuvm.part.0+0xa2>
801062b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801062b3:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801062b6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801062bc:	52                   	push   %edx
801062bd:	e8 3a bf ff ff       	call   801021fc <kfree>
      *pte = 0;
801062c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801062cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801062d1:	83 c4 10             	add    $0x10,%esp
801062d4:	eb 88                	jmp    8010625e <deallocuvm.part.0+0x2a>
        panic("kfree");
801062d6:	83 ec 0c             	sub    $0xc,%esp
801062d9:	68 cc 6c 10 80       	push   $0x80106ccc
801062de:	e8 55 a0 ff ff       	call   80100338 <panic>
801062e3:	90                   	nop

801062e4 <mappages>:
{
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	57                   	push   %edi
801062e8:	56                   	push   %esi
801062e9:	53                   	push   %ebx
801062ea:	83 ec 1c             	sub    $0x1c,%esp
801062ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
801062f0:	89 d3                	mov    %edx,%ebx
801062f2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801062f8:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801062fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106301:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106304:	8b 45 08             	mov    0x8(%ebp),%eax
80106307:	29 d8                	sub    %ebx,%eax
80106309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010630c:	eb 3b                	jmp    80106349 <mappages+0x65>
8010630e:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106310:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106315:	89 da                	mov    %ebx,%edx
80106317:	c1 ea 0a             	shr    $0xa,%edx
8010631a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106320:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106327:	85 c0                	test   %eax,%eax
80106329:	74 71                	je     8010639c <mappages+0xb8>
    if(*pte & PTE_P)
8010632b:	f6 00 01             	testb  $0x1,(%eax)
8010632e:	0f 85 82 00 00 00    	jne    801063b6 <mappages+0xd2>
    *pte = pa | perm | PTE_P;
80106334:	0b 75 0c             	or     0xc(%ebp),%esi
80106337:	83 ce 01             	or     $0x1,%esi
8010633a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010633c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010633f:	39 c3                	cmp    %eax,%ebx
80106341:	74 69                	je     801063ac <mappages+0xc8>
    a += PGSIZE;
80106343:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010634c:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  pde = &pgdir[PDX(va)];
8010634f:	89 d8                	mov    %ebx,%eax
80106351:	c1 e8 16             	shr    $0x16,%eax
80106354:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106357:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010635a:	8b 07                	mov    (%edi),%eax
8010635c:	a8 01                	test   $0x1,%al
8010635e:	75 b0                	jne    80106310 <mappages+0x2c>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106360:	e8 27 c0 ff ff       	call   8010238c <kalloc>
80106365:	89 c2                	mov    %eax,%edx
80106367:	85 c0                	test   %eax,%eax
80106369:	74 31                	je     8010639c <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
8010636b:	50                   	push   %eax
8010636c:	68 00 10 00 00       	push   $0x1000
80106371:	6a 00                	push   $0x0
80106373:	52                   	push   %edx
80106374:	89 55 d8             	mov    %edx,-0x28(%ebp)
80106377:	e8 bc df ff ff       	call   80104338 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010637c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010637f:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106385:	83 c8 07             	or     $0x7,%eax
80106388:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010638a:	89 d8                	mov    %ebx,%eax
8010638c:	c1 e8 0a             	shr    $0xa,%eax
8010638f:	25 fc 0f 00 00       	and    $0xffc,%eax
80106394:	01 d0                	add    %edx,%eax
80106396:	83 c4 10             	add    $0x10,%esp
80106399:	eb 90                	jmp    8010632b <mappages+0x47>
8010639b:	90                   	nop
      return -1;
8010639c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
801063a8:	c3                   	ret
801063a9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
801063ac:	31 c0                	xor    %eax,%eax
}
801063ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b1:	5b                   	pop    %ebx
801063b2:	5e                   	pop    %esi
801063b3:	5f                   	pop    %edi
801063b4:	5d                   	pop    %ebp
801063b5:	c3                   	ret
      panic("remap");
801063b6:	83 ec 0c             	sub    $0xc,%esp
801063b9:	68 b2 6f 10 80       	push   $0x80106fb2
801063be:	e8 75 9f ff ff       	call   80100338 <panic>
801063c3:	90                   	nop

801063c4 <seginit>:
{
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801063ca:	e8 95 d1 ff ff       	call   80103564 <cpuid>
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801063cf:	8d 14 80             	lea    (%eax,%eax,4),%edx
801063d2:	01 d2                	add    %edx,%edx
801063d4:	01 d0                	add    %edx,%eax
801063d6:	c1 e0 04             	shl    $0x4,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801063d9:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801063e0:	ff 00 00 
801063e3:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801063ea:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801063ed:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
801063f4:	ff 00 00 
801063f7:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
801063fe:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106401:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106408:	ff 00 00 
8010640b:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106412:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106415:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
8010641c:	ff 00 00 
8010641f:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106426:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106429:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[0] = size-1;
8010642e:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106434:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106438:	c1 e8 10             	shr    $0x10,%eax
8010643b:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010643f:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106442:	0f 01 10             	lgdtl  (%eax)
}
80106445:	c9                   	leave
80106446:	c3                   	ret
80106447:	90                   	nop

80106448 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106448:	a1 c4 48 11 80       	mov    0x801148c4,%eax
8010644d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106452:	0f 22 d8             	mov    %eax,%cr3
}
80106455:	c3                   	ret
80106456:	66 90                	xchg   %ax,%ax

80106458 <switchuvm>:
{
80106458:	55                   	push   %ebp
80106459:	89 e5                	mov    %esp,%ebp
8010645b:	57                   	push   %edi
8010645c:	56                   	push   %esi
8010645d:	53                   	push   %ebx
8010645e:	83 ec 1c             	sub    $0x1c,%esp
80106461:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106464:	85 f6                	test   %esi,%esi
80106466:	0f 84 bf 00 00 00    	je     8010652b <switchuvm+0xd3>
  if(p->kstack == 0)
8010646c:	8b 56 18             	mov    0x18(%esi),%edx
8010646f:	85 d2                	test   %edx,%edx
80106471:	0f 84 ce 00 00 00    	je     80106545 <switchuvm+0xed>
  if(p->pgdir == 0)
80106477:	8b 46 14             	mov    0x14(%esi),%eax
8010647a:	85 c0                	test   %eax,%eax
8010647c:	0f 84 b6 00 00 00    	je     80106538 <switchuvm+0xe0>
  pushcli();
80106482:	e8 a1 dc ff ff       	call   80104128 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106487:	e8 74 d0 ff ff       	call   80103500 <mycpu>
8010648c:	89 c3                	mov    %eax,%ebx
8010648e:	e8 6d d0 ff ff       	call   80103500 <mycpu>
80106493:	89 c7                	mov    %eax,%edi
80106495:	e8 66 d0 ff ff       	call   80103500 <mycpu>
8010649a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010649d:	e8 5e d0 ff ff       	call   80103500 <mycpu>
801064a2:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801064a9:	67 00 
801064ab:	83 c7 08             	add    $0x8,%edi
801064ae:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801064b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801064b8:	83 c1 08             	add    $0x8,%ecx
801064bb:	c1 e9 10             	shr    $0x10,%ecx
801064be:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801064c4:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
801064cb:	99 40 
801064cd:	83 c0 08             	add    $0x8,%eax
801064d0:	c1 e8 18             	shr    $0x18,%eax
801064d3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
801064d9:	e8 22 d0 ff ff       	call   80103500 <mycpu>
801064de:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801064e5:	e8 16 d0 ff ff       	call   80103500 <mycpu>
801064ea:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801064f0:	8b 5e 18             	mov    0x18(%esi),%ebx
801064f3:	e8 08 d0 ff ff       	call   80103500 <mycpu>
801064f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064fe:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106501:	e8 fa cf ff ff       	call   80103500 <mycpu>
80106506:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010650c:	b8 28 00 00 00       	mov    $0x28,%eax
80106511:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106514:	8b 46 14             	mov    0x14(%esi),%eax
80106517:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010651c:	0f 22 d8             	mov    %eax,%cr3
}
8010651f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106522:	5b                   	pop    %ebx
80106523:	5e                   	pop    %esi
80106524:	5f                   	pop    %edi
80106525:	5d                   	pop    %ebp
  popcli();
80106526:	e9 49 dc ff ff       	jmp    80104174 <popcli>
    panic("switchuvm: no process");
8010652b:	83 ec 0c             	sub    $0xc,%esp
8010652e:	68 b8 6f 10 80       	push   $0x80106fb8
80106533:	e8 00 9e ff ff       	call   80100338 <panic>
    panic("switchuvm: no pgdir");
80106538:	83 ec 0c             	sub    $0xc,%esp
8010653b:	68 e3 6f 10 80       	push   $0x80106fe3
80106540:	e8 f3 9d ff ff       	call   80100338 <panic>
    panic("switchuvm: no kstack");
80106545:	83 ec 0c             	sub    $0xc,%esp
80106548:	68 ce 6f 10 80       	push   $0x80106fce
8010654d:	e8 e6 9d ff ff       	call   80100338 <panic>
80106552:	66 90                	xchg   %ax,%ax

80106554 <inituvm>:
{
80106554:	55                   	push   %ebp
80106555:	89 e5                	mov    %esp,%ebp
80106557:	57                   	push   %edi
80106558:	56                   	push   %esi
80106559:	53                   	push   %ebx
8010655a:	83 ec 1c             	sub    $0x1c,%esp
8010655d:	8b 45 08             	mov    0x8(%ebp),%eax
80106560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106563:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106566:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
80106569:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010656f:	77 47                	ja     801065b8 <inituvm+0x64>
  mem = kalloc();
80106571:	e8 16 be ff ff       	call   8010238c <kalloc>
80106576:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106578:	50                   	push   %eax
80106579:	68 00 10 00 00       	push   $0x1000
8010657e:	6a 00                	push   $0x0
80106580:	53                   	push   %ebx
80106581:	e8 b2 dd ff ff       	call   80104338 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106586:	5a                   	pop    %edx
80106587:	59                   	pop    %ecx
80106588:	6a 06                	push   $0x6
8010658a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106590:	50                   	push   %eax
80106591:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106596:	31 d2                	xor    %edx,%edx
80106598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010659b:	e8 44 fd ff ff       	call   801062e4 <mappages>
  memmove(mem, init, sz);
801065a0:	83 c4 10             	add    $0x10,%esp
801065a3:	89 75 10             	mov    %esi,0x10(%ebp)
801065a6:	89 7d 0c             	mov    %edi,0xc(%ebp)
801065a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801065ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065af:	5b                   	pop    %ebx
801065b0:	5e                   	pop    %esi
801065b1:	5f                   	pop    %edi
801065b2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801065b3:	e9 fc dd ff ff       	jmp    801043b4 <memmove>
    panic("inituvm: more than a page");
801065b8:	83 ec 0c             	sub    $0xc,%esp
801065bb:	68 f7 6f 10 80       	push   $0x80106ff7
801065c0:	e8 73 9d ff ff       	call   80100338 <panic>
801065c5:	8d 76 00             	lea    0x0(%esi),%esi

801065c8 <loaduvm>:
{
801065c8:	55                   	push   %ebp
801065c9:	89 e5                	mov    %esp,%ebp
801065cb:	57                   	push   %edi
801065cc:	56                   	push   %esi
801065cd:	53                   	push   %ebx
801065ce:	83 ec 0c             	sub    $0xc,%esp
801065d1:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
801065d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801065d7:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801065dd:	0f 85 9a 00 00 00    	jne    8010667d <loaduvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
801065e3:	85 ff                	test   %edi,%edi
801065e5:	74 7c                	je     80106663 <loaduvm+0x9b>
801065e7:	90                   	nop
  pde = &pgdir[PDX(va)];
801065e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801065eb:	01 d8                	add    %ebx,%eax
801065ed:	89 c2                	mov    %eax,%edx
801065ef:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801065f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801065f5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801065f8:	f6 c2 01             	test   $0x1,%dl
801065fb:	75 0f                	jne    8010660c <loaduvm+0x44>
      panic("loaduvm: address should exist");
801065fd:	83 ec 0c             	sub    $0xc,%esp
80106600:	68 11 70 10 80       	push   $0x80107011
80106605:	e8 2e 9d ff ff       	call   80100338 <panic>
8010660a:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010660c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106612:	c1 e8 0a             	shr    $0xa,%eax
80106615:	25 fc 0f 00 00       	and    $0xffc,%eax
8010661a:	8d 8c 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106621:	85 c9                	test   %ecx,%ecx
80106623:	74 d8                	je     801065fd <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106625:	89 fe                	mov    %edi,%esi
80106627:	29 de                	sub    %ebx,%esi
80106629:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
8010662f:	76 05                	jbe    80106636 <loaduvm+0x6e>
80106631:	be 00 10 00 00       	mov    $0x1000,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106636:	56                   	push   %esi
80106637:	8b 45 14             	mov    0x14(%ebp),%eax
8010663a:	01 d8                	add    %ebx,%eax
8010663c:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
8010663d:	8b 01                	mov    (%ecx),%eax
8010663f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106644:	05 00 00 00 80       	add    $0x80000000,%eax
80106649:	50                   	push   %eax
8010664a:	ff 75 10             	push   0x10(%ebp)
8010664d:	e8 9a b2 ff ff       	call   801018ec <readi>
80106652:	83 c4 10             	add    $0x10,%esp
80106655:	39 f0                	cmp    %esi,%eax
80106657:	75 17                	jne    80106670 <loaduvm+0xa8>
  for(i = 0; i < sz; i += PGSIZE){
80106659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010665f:	39 fb                	cmp    %edi,%ebx
80106661:	72 85                	jb     801065e8 <loaduvm+0x20>
  return 0;
80106663:	31 c0                	xor    %eax,%eax
}
80106665:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106668:	5b                   	pop    %ebx
80106669:	5e                   	pop    %esi
8010666a:	5f                   	pop    %edi
8010666b:	5d                   	pop    %ebp
8010666c:	c3                   	ret
8010666d:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
80106670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106675:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106678:	5b                   	pop    %ebx
80106679:	5e                   	pop    %esi
8010667a:	5f                   	pop    %edi
8010667b:	5d                   	pop    %ebp
8010667c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010667d:	83 ec 0c             	sub    $0xc,%esp
80106680:	68 58 72 10 80       	push   $0x80107258
80106685:	e8 ae 9c ff ff       	call   80100338 <panic>
8010668a:	66 90                	xchg   %ax,%ax

8010668c <allocuvm>:
{
8010668c:	55                   	push   %ebp
8010668d:	89 e5                	mov    %esp,%ebp
8010668f:	57                   	push   %edi
80106690:	56                   	push   %esi
80106691:	53                   	push   %ebx
80106692:	83 ec 1c             	sub    $0x1c,%esp
80106695:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106698:	85 f6                	test   %esi,%esi
8010669a:	0f 88 91 00 00 00    	js     80106731 <allocuvm+0xa5>
801066a0:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
801066a2:	3b 75 0c             	cmp    0xc(%ebp),%esi
801066a5:	0f 82 95 00 00 00    	jb     80106740 <allocuvm+0xb4>
  a = PGROUNDUP(oldsz);
801066ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801066ae:	05 ff 0f 00 00       	add    $0xfff,%eax
801066b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066b8:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
801066ba:	39 f0                	cmp    %esi,%eax
801066bc:	0f 83 81 00 00 00    	jae    80106743 <allocuvm+0xb7>
801066c2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801066c5:	eb 3d                	jmp    80106704 <allocuvm+0x78>
801066c7:	90                   	nop
    memset(mem, 0, PGSIZE);
801066c8:	50                   	push   %eax
801066c9:	68 00 10 00 00       	push   $0x1000
801066ce:	6a 00                	push   $0x0
801066d0:	53                   	push   %ebx
801066d1:	e8 62 dc ff ff       	call   80104338 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801066d6:	5a                   	pop    %edx
801066d7:	59                   	pop    %ecx
801066d8:	6a 06                	push   $0x6
801066da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066e0:	50                   	push   %eax
801066e1:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066e6:	89 fa                	mov    %edi,%edx
801066e8:	8b 45 08             	mov    0x8(%ebp),%eax
801066eb:	e8 f4 fb ff ff       	call   801062e4 <mappages>
801066f0:	83 c4 10             	add    $0x10,%esp
801066f3:	40                   	inc    %eax
801066f4:	74 5a                	je     80106750 <allocuvm+0xc4>
  for(; a < newsz; a += PGSIZE){
801066f6:	81 c7 00 10 00 00    	add    $0x1000,%edi
801066fc:	39 f7                	cmp    %esi,%edi
801066fe:	0f 83 80 00 00 00    	jae    80106784 <allocuvm+0xf8>
    mem = kalloc();
80106704:	e8 83 bc ff ff       	call   8010238c <kalloc>
80106709:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010670b:	85 c0                	test   %eax,%eax
8010670d:	75 b9                	jne    801066c8 <allocuvm+0x3c>
      cprintf("allocuvm out of memory\n");
8010670f:	83 ec 0c             	sub    $0xc,%esp
80106712:	68 2f 70 10 80       	push   $0x8010702f
80106717:	e8 04 9f ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
8010671c:	83 c4 10             	add    $0x10,%esp
8010671f:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106722:	74 0d                	je     80106731 <allocuvm+0xa5>
80106724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106727:	89 f2                	mov    %esi,%edx
80106729:	8b 45 08             	mov    0x8(%ebp),%eax
8010672c:	e8 03 fb ff ff       	call   80106234 <deallocuvm.part.0>
    return 0;
80106731:	31 d2                	xor    %edx,%edx
}
80106733:	89 d0                	mov    %edx,%eax
80106735:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106738:	5b                   	pop    %ebx
80106739:	5e                   	pop    %esi
8010673a:	5f                   	pop    %edi
8010673b:	5d                   	pop    %ebp
8010673c:	c3                   	ret
8010673d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80106740:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106743:	89 d0                	mov    %edx,%eax
80106745:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106748:	5b                   	pop    %ebx
80106749:	5e                   	pop    %esi
8010674a:	5f                   	pop    %edi
8010674b:	5d                   	pop    %ebp
8010674c:	c3                   	ret
8010674d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106750:	83 ec 0c             	sub    $0xc,%esp
80106753:	68 47 70 10 80       	push   $0x80107047
80106758:	e8 c3 9e ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
8010675d:	83 c4 10             	add    $0x10,%esp
80106760:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106763:	74 0d                	je     80106772 <allocuvm+0xe6>
80106765:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106768:	89 f2                	mov    %esi,%edx
8010676a:	8b 45 08             	mov    0x8(%ebp),%eax
8010676d:	e8 c2 fa ff ff       	call   80106234 <deallocuvm.part.0>
      kfree(mem);
80106772:	83 ec 0c             	sub    $0xc,%esp
80106775:	53                   	push   %ebx
80106776:	e8 81 ba ff ff       	call   801021fc <kfree>
      return 0;
8010677b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010677e:	31 d2                	xor    %edx,%edx
80106780:	eb b1                	jmp    80106733 <allocuvm+0xa7>
80106782:	66 90                	xchg   %ax,%ax
80106784:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106787:	89 d0                	mov    %edx,%eax
80106789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010678c:	5b                   	pop    %ebx
8010678d:	5e                   	pop    %esi
8010678e:	5f                   	pop    %edi
8010678f:	5d                   	pop    %ebp
80106790:	c3                   	ret
80106791:	8d 76 00             	lea    0x0(%esi),%esi

80106794 <deallocuvm>:
{
80106794:	55                   	push   %ebp
80106795:	89 e5                	mov    %esp,%ebp
80106797:	8b 45 08             	mov    0x8(%ebp),%eax
8010679a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010679d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
801067a0:	39 d1                	cmp    %edx,%ecx
801067a2:	73 08                	jae    801067ac <deallocuvm+0x18>
}
801067a4:	5d                   	pop    %ebp
801067a5:	e9 8a fa ff ff       	jmp    80106234 <deallocuvm.part.0>
801067aa:	66 90                	xchg   %ax,%ax
801067ac:	89 d0                	mov    %edx,%eax
801067ae:	5d                   	pop    %ebp
801067af:	c3                   	ret

801067b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
801067b6:	83 ec 0c             	sub    $0xc,%esp
801067b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801067bc:	85 f6                	test   %esi,%esi
801067be:	74 51                	je     80106811 <freevm+0x61>
  if(newsz >= oldsz)
801067c0:	31 c9                	xor    %ecx,%ecx
801067c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801067c7:	89 f0                	mov    %esi,%eax
801067c9:	e8 66 fa ff ff       	call   80106234 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801067ce:	89 f3                	mov    %esi,%ebx
801067d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801067d6:	eb 07                	jmp    801067df <freevm+0x2f>
801067d8:	83 c3 04             	add    $0x4,%ebx
801067db:	39 fb                	cmp    %edi,%ebx
801067dd:	74 23                	je     80106802 <freevm+0x52>
    if(pgdir[i] & PTE_P){
801067df:	8b 03                	mov    (%ebx),%eax
801067e1:	a8 01                	test   $0x1,%al
801067e3:	74 f3                	je     801067d8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801067e5:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801067e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067ed:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801067f2:	50                   	push   %eax
801067f3:	e8 04 ba ff ff       	call   801021fc <kfree>
801067f8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801067fb:	83 c3 04             	add    $0x4,%ebx
801067fe:	39 fb                	cmp    %edi,%ebx
80106800:	75 dd                	jne    801067df <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
80106802:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106805:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106808:	5b                   	pop    %ebx
80106809:	5e                   	pop    %esi
8010680a:	5f                   	pop    %edi
8010680b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
8010680c:	e9 eb b9 ff ff       	jmp    801021fc <kfree>
    panic("freevm: no pgdir");
80106811:	83 ec 0c             	sub    $0xc,%esp
80106814:	68 63 70 10 80       	push   $0x80107063
80106819:	e8 1a 9b ff ff       	call   80100338 <panic>
8010681e:	66 90                	xchg   %ax,%ax

80106820 <setupkvm>:
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	56                   	push   %esi
80106824:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106825:	e8 62 bb ff ff       	call   8010238c <kalloc>
8010682a:	85 c0                	test   %eax,%eax
8010682c:	74 56                	je     80106884 <setupkvm+0x64>
8010682e:	89 c6                	mov    %eax,%esi
  memset(pgdir, 0, PGSIZE);
80106830:	50                   	push   %eax
80106831:	68 00 10 00 00       	push   $0x1000
80106836:	6a 00                	push   $0x0
80106838:	56                   	push   %esi
80106839:	e8 fa da ff ff       	call   80104338 <memset>
8010683e:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106841:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
80106846:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106849:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010684c:	29 c1                	sub    %eax,%ecx
8010684e:	8b 13                	mov    (%ebx),%edx
80106850:	83 ec 08             	sub    $0x8,%esp
80106853:	ff 73 0c             	push   0xc(%ebx)
80106856:	50                   	push   %eax
80106857:	89 f0                	mov    %esi,%eax
80106859:	e8 86 fa ff ff       	call   801062e4 <mappages>
8010685e:	83 c4 10             	add    $0x10,%esp
80106861:	40                   	inc    %eax
80106862:	74 14                	je     80106878 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106864:	83 c3 10             	add    $0x10,%ebx
80106867:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010686d:	75 d7                	jne    80106846 <setupkvm+0x26>
}
8010686f:	89 f0                	mov    %esi,%eax
80106871:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106874:	5b                   	pop    %ebx
80106875:	5e                   	pop    %esi
80106876:	5d                   	pop    %ebp
80106877:	c3                   	ret
      freevm(pgdir);
80106878:	83 ec 0c             	sub    $0xc,%esp
8010687b:	56                   	push   %esi
8010687c:	e8 2f ff ff ff       	call   801067b0 <freevm>
      return 0;
80106881:	83 c4 10             	add    $0x10,%esp
    return 0;
80106884:	31 f6                	xor    %esi,%esi
}
80106886:	89 f0                	mov    %esi,%eax
80106888:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010688b:	5b                   	pop    %ebx
8010688c:	5e                   	pop    %esi
8010688d:	5d                   	pop    %ebp
8010688e:	c3                   	ret
8010688f:	90                   	nop

80106890 <kvmalloc>:
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106896:	e8 85 ff ff ff       	call   80106820 <setupkvm>
8010689b:	a3 c4 48 11 80       	mov    %eax,0x801148c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068a0:	05 00 00 00 80       	add    $0x80000000,%eax
801068a5:	0f 22 d8             	mov    %eax,%cr3
}
801068a8:	c9                   	leave
801068a9:	c3                   	ret
801068aa:	66 90                	xchg   %ax,%ax

801068ac <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801068ac:	55                   	push   %ebp
801068ad:	89 e5                	mov    %esp,%ebp
801068af:	83 ec 08             	sub    $0x8,%esp
  pde = &pgdir[PDX(va)];
801068b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801068b5:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801068b8:	8b 45 08             	mov    0x8(%ebp),%eax
801068bb:	8b 04 90             	mov    (%eax,%edx,4),%eax
801068be:	a8 01                	test   $0x1,%al
801068c0:	75 0e                	jne    801068d0 <clearpteu+0x24>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801068c2:	83 ec 0c             	sub    $0xc,%esp
801068c5:	68 74 70 10 80       	push   $0x80107074
801068ca:	e8 69 9a ff ff       	call   80100338 <panic>
801068cf:	90                   	nop
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068d5:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
801068d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801068da:	c1 e8 0a             	shr    $0xa,%eax
801068dd:	25 fc 0f 00 00       	and    $0xffc,%eax
801068e2:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801068e9:	85 c0                	test   %eax,%eax
801068eb:	74 d5                	je     801068c2 <clearpteu+0x16>
  *pte &= ~PTE_U;
801068ed:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801068f0:	c9                   	leave
801068f1:	c3                   	ret
801068f2:	66 90                	xchg   %ax,%ax

801068f4 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801068f4:	55                   	push   %ebp
801068f5:	89 e5                	mov    %esp,%ebp
801068f7:	57                   	push   %edi
801068f8:	56                   	push   %esi
801068f9:	53                   	push   %ebx
801068fa:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801068fd:	e8 1e ff ff ff       	call   80106820 <setupkvm>
80106902:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106905:	85 c0                	test   %eax,%eax
80106907:	0f 84 d5 00 00 00    	je     801069e2 <copyuvm+0xee>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010690d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106910:	85 db                	test   %ebx,%ebx
80106912:	0f 84 a4 00 00 00    	je     801069bc <copyuvm+0xc8>
80106918:	31 ff                	xor    %edi,%edi
8010691a:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
8010691c:	89 f8                	mov    %edi,%eax
8010691e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106921:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106924:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106927:	a8 01                	test   $0x1,%al
80106929:	75 0d                	jne    80106938 <copyuvm+0x44>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010692b:	83 ec 0c             	sub    $0xc,%esp
8010692e:	68 7e 70 10 80       	push   $0x8010707e
80106933:	e8 00 9a ff ff       	call   80100338 <panic>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106938:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010693d:	89 fa                	mov    %edi,%edx
8010693f:	c1 ea 0a             	shr    $0xa,%edx
80106942:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106948:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010694f:	85 c0                	test   %eax,%eax
80106951:	74 d8                	je     8010692b <copyuvm+0x37>
    if(!(*pte & PTE_P))
80106953:	8b 18                	mov    (%eax),%ebx
80106955:	f6 c3 01             	test   $0x1,%bl
80106958:	0f 84 8d 00 00 00    	je     801069eb <copyuvm+0xf7>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010695e:	89 d8                	mov    %ebx,%eax
80106960:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106968:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
8010696e:	e8 19 ba ff ff       	call   8010238c <kalloc>
80106973:	89 c6                	mov    %eax,%esi
80106975:	85 c0                	test   %eax,%eax
80106977:	74 5b                	je     801069d4 <copyuvm+0xe0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106979:	50                   	push   %eax
8010697a:	68 00 10 00 00       	push   $0x1000
8010697f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106982:	05 00 00 00 80       	add    $0x80000000,%eax
80106987:	50                   	push   %eax
80106988:	56                   	push   %esi
80106989:	e8 26 da ff ff       	call   801043b4 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010698e:	5a                   	pop    %edx
8010698f:	59                   	pop    %ecx
80106990:	53                   	push   %ebx
80106991:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106997:	50                   	push   %eax
80106998:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010699d:	89 fa                	mov    %edi,%edx
8010699f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069a2:	e8 3d f9 ff ff       	call   801062e4 <mappages>
801069a7:	83 c4 10             	add    $0x10,%esp
801069aa:	40                   	inc    %eax
801069ab:	74 1b                	je     801069c8 <copyuvm+0xd4>
  for(i = 0; i < sz; i += PGSIZE){
801069ad:	81 c7 00 10 00 00    	add    $0x1000,%edi
801069b3:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069b6:	0f 82 60 ff ff ff    	jb     8010691c <copyuvm+0x28>
  return d;

bad:
  freevm(d);
  return 0;
}
801069bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069c2:	5b                   	pop    %ebx
801069c3:	5e                   	pop    %esi
801069c4:	5f                   	pop    %edi
801069c5:	5d                   	pop    %ebp
801069c6:	c3                   	ret
801069c7:	90                   	nop
      kfree(mem);
801069c8:	83 ec 0c             	sub    $0xc,%esp
801069cb:	56                   	push   %esi
801069cc:	e8 2b b8 ff ff       	call   801021fc <kfree>
      goto bad;
801069d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801069d4:	83 ec 0c             	sub    $0xc,%esp
801069d7:	ff 75 e0             	push   -0x20(%ebp)
801069da:	e8 d1 fd ff ff       	call   801067b0 <freevm>
  return 0;
801069df:	83 c4 10             	add    $0x10,%esp
    return 0;
801069e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801069e9:	eb d1                	jmp    801069bc <copyuvm+0xc8>
      panic("copyuvm: page not present");
801069eb:	83 ec 0c             	sub    $0xc,%esp
801069ee:	68 98 70 10 80       	push   $0x80107098
801069f3:	e8 40 99 ff ff       	call   80100338 <panic>

801069f8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801069f8:	55                   	push   %ebp
801069f9:	89 e5                	mov    %esp,%ebp
  pde = &pgdir[PDX(va)];
801069fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801069fe:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106a01:	8b 45 08             	mov    0x8(%ebp),%eax
80106a04:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106a07:	a8 01                	test   $0x1,%al
80106a09:	0f 84 e3 00 00 00    	je     80106af2 <uva2ka.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a14:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
80106a16:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a19:	c1 e8 0c             	shr    $0xc,%eax
80106a1c:	25 ff 03 00 00       	and    $0x3ff,%eax
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
80106a21:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106a28:	89 c2                	mov    %eax,%edx
80106a2a:	f7 d2                	not    %edx
80106a2c:	83 e2 05             	and    $0x5,%edx
80106a2f:	75 0f                	jne    80106a40 <uva2ka+0x48>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106a31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a36:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106a3b:	5d                   	pop    %ebp
80106a3c:	c3                   	ret
80106a3d:	8d 76 00             	lea    0x0(%esi),%esi
80106a40:	31 c0                	xor    %eax,%eax
80106a42:	5d                   	pop    %ebp
80106a43:	c3                   	ret

80106a44 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106a44:	55                   	push   %ebp
80106a45:	89 e5                	mov    %esp,%ebp
80106a47:	57                   	push   %edi
80106a48:	56                   	push   %esi
80106a49:	53                   	push   %ebx
80106a4a:	83 ec 0c             	sub    $0xc,%esp
80106a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a50:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106a53:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106a56:	85 db                	test   %ebx,%ebx
80106a58:	0f 84 8a 00 00 00    	je     80106ae8 <copyout+0xa4>
80106a5e:	89 fe                	mov    %edi,%esi
80106a60:	eb 3d                	jmp    80106a9f <copyout+0x5b>
80106a62:	66 90                	xchg   %ax,%ax
  return (char*)P2V(PTE_ADDR(*pte));
80106a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80106a69:	05 00 00 00 80       	add    $0x80000000,%eax
80106a6e:	74 6a                	je     80106ada <copyout+0x96>
      return -1;
    n = PGSIZE - (va - va0);
80106a70:	89 fb                	mov    %edi,%ebx
80106a72:	29 cb                	sub    %ecx,%ebx
    if(n > len)
80106a74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a7a:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80106a7d:	73 03                	jae    80106a82 <copyout+0x3e>
80106a7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106a82:	52                   	push   %edx
80106a83:	53                   	push   %ebx
80106a84:	56                   	push   %esi
80106a85:	29 f9                	sub    %edi,%ecx
80106a87:	01 c8                	add    %ecx,%eax
80106a89:	50                   	push   %eax
80106a8a:	e8 25 d9 ff ff       	call   801043b4 <memmove>
    len -= n;
    buf += n;
80106a8f:	01 de                	add    %ebx,%esi
    va = va0 + PGSIZE;
80106a91:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
80106a97:	83 c4 10             	add    $0x10,%esp
80106a9a:	29 5d 14             	sub    %ebx,0x14(%ebp)
80106a9d:	74 49                	je     80106ae8 <copyout+0xa4>
    va0 = (uint)PGROUNDDOWN(va);
80106a9f:	89 cf                	mov    %ecx,%edi
80106aa1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pde = &pgdir[PDX(va)];
80106aa7:	89 c8                	mov    %ecx,%eax
80106aa9:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106aac:	8b 55 08             	mov    0x8(%ebp),%edx
80106aaf:	8b 04 82             	mov    (%edx,%eax,4),%eax
80106ab2:	a8 01                	test   $0x1,%al
80106ab4:	0f 84 3f 00 00 00    	je     80106af9 <copyout.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106aba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106abf:	89 fb                	mov    %edi,%ebx
80106ac1:	c1 eb 0c             	shr    $0xc,%ebx
80106ac4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106aca:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80106ad1:	89 c3                	mov    %eax,%ebx
80106ad3:	f7 d3                	not    %ebx
80106ad5:	83 e3 05             	and    $0x5,%ebx
80106ad8:	74 8a                	je     80106a64 <copyout+0x20>
      return -1;
80106ada:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106adf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ae2:	5b                   	pop    %ebx
80106ae3:	5e                   	pop    %esi
80106ae4:	5f                   	pop    %edi
80106ae5:	5d                   	pop    %ebp
80106ae6:	c3                   	ret
80106ae7:	90                   	nop
  return 0;
80106ae8:	31 c0                	xor    %eax,%eax
}
80106aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aed:	5b                   	pop    %ebx
80106aee:	5e                   	pop    %esi
80106aef:	5f                   	pop    %edi
80106af0:	5d                   	pop    %ebp
80106af1:	c3                   	ret

80106af2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106af2:	a1 00 00 00 00       	mov    0x0,%eax
80106af7:	0f 0b                	ud2

80106af9 <copyout.cold>:
80106af9:	a1 00 00 00 00       	mov    0x0,%eax
80106afe:	0f 0b                	ud2
