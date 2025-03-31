
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
80100028:	bc d0 5e 11 80       	mov    $0x80115ed0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 2c 10 80       	mov    $0x80102c70,%eax
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
8010003b:	68 60 6a 10 80       	push   $0x80106a60
80100040:	68 20 a5 10 80       	push   $0x8010a520
80100045:	e8 da 3f 00 00       	call   80104024 <initlock>

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
8010007f:	68 67 6a 10 80       	push   $0x80106a67
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 8b 3e 00 00       	call   80103f18 <initsleeplock>
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
801000c8:	e8 1f 41 00 00       	call   801041ec <acquire>
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
8010013e:	e8 49 40 00 00       	call   8010418c <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 fe 3d 00 00       	call   80103f4c <acquiresleep>
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
80100164:	e8 e7 1e 00 00       	call   80102050 <iderw>
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
80100179:	68 6e 6a 10 80       	push   $0x80106a6e
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
80100192:	e8 45 3e 00 00       	call   80103fdc <holdingsleep>
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
801001a8:	e9 a3 1e 00 00       	jmp    80102050 <iderw>
    panic("bwrite");
801001ad:	83 ec 0c             	sub    $0xc,%esp
801001b0:	68 7f 6a 10 80       	push   $0x80106a7f
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
801001cb:	e8 0c 3e 00 00       	call   80103fdc <holdingsleep>
801001d0:	83 c4 10             	add    $0x10,%esp
801001d3:	85 c0                	test   %eax,%eax
801001d5:	74 61                	je     80100238 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	56                   	push   %esi
801001db:	e8 c0 3d 00 00       	call   80103fa0 <releasesleep>

  acquire(&bcache.lock);
801001e0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001e7:	e8 00 40 00 00       	call   801041ec <acquire>
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
80100233:	e9 54 3f 00 00       	jmp    8010418c <release>
    panic("brelse");
80100238:	83 ec 0c             	sub    $0xc,%esp
8010023b:	68 86 6a 10 80       	push   $0x80106a86
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
80100258:	e8 8b 14 00 00       	call   801016e8 <iunlock>
  target = n;
8010025d:	89 de                	mov    %ebx,%esi
  acquire(&cons.lock);
8010025f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100266:	e8 81 3f 00 00       	call   801041ec <acquire>
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
80100295:	e8 72 38 00 00       	call   80103b0c <sleep>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a8:	75 32                	jne    801002dc <consoleread+0x94>
      if(myproc()->killed){
801002aa:	e8 49 32 00 00       	call   801034f8 <myproc>
801002af:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b2:	85 c0                	test   %eax,%eax
801002b4:	74 d2                	je     80100288 <consoleread+0x40>
        release(&cons.lock);
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 20 ef 10 80       	push   $0x8010ef20
801002be:	e8 c9 3e 00 00       	call   8010418c <release>
        ilock(ip);
801002c3:	89 3c 24             	mov    %edi,(%esp)
801002c6:	e8 55 13 00 00       	call   80101620 <ilock>
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
80100311:	e8 76 3e 00 00       	call   8010418c <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 02 13 00 00       	call   80101620 <ilock>
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
8010034a:	e8 69 22 00 00       	call   801025b8 <lapicid>
8010034f:	83 ec 08             	sub    $0x8,%esp
80100352:	50                   	push   %eax
80100353:	68 8d 6a 10 80       	push   $0x80106a8d
80100358:	e8 c3 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
8010035d:	58                   	pop    %eax
8010035e:	ff 75 08             	push   0x8(%ebp)
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
80100366:	c7 04 24 1e 6f 10 80 	movl   $0x80106f1e,(%esp)
8010036d:	e8 ae 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
80100372:	5a                   	pop    %edx
80100373:	59                   	pop    %ecx
80100374:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100377:	53                   	push   %ebx
80100378:	8d 45 08             	lea    0x8(%ebp),%eax
8010037b:	50                   	push   %eax
8010037c:	e8 bf 3c 00 00       	call   80104040 <getcallerpcs>
  for(i=0; i<10; i++)
80100381:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100384:	83 ec 08             	sub    $0x8,%esp
80100387:	ff 33                	push   (%ebx)
80100389:	68 a1 6a 10 80       	push   $0x80106aa1
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
801003c6:	e8 ed 52 00 00       	call   801056b8 <uartputc>
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
80100475:	e8 3e 52 00 00       	call   801056b8 <uartputc>
8010047a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100481:	e8 32 52 00 00       	call   801056b8 <uartputc>
80100486:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010048d:	e8 26 52 00 00       	call   801056b8 <uartputc>
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
801004d4:	e8 5b 3e 00 00       	call   80104334 <memmove>
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
801004f9:	e8 ba 3d 00 00       	call   801042b8 <memset>
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
80100521:	68 a5 6a 10 80       	push   $0x80106aa5
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
8010053b:	e8 a8 11 00 00       	call   801016e8 <iunlock>
  acquire(&cons.lock);
80100540:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100547:	e8 a0 3c 00 00       	call   801041ec <acquire>
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
8010057d:	e8 0a 3c 00 00       	call   8010418c <release>
  ilock(ip);
80100582:	58                   	pop    %eax
80100583:	ff 75 08             	push   0x8(%ebp)
80100586:	e8 95 10 00 00       	call   80101620 <ilock>

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
801005c3:	8a 92 70 6f 10 80    	mov    -0x7fef9090(%edx),%dl
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
80100738:	e8 af 3a 00 00       	call   801041ec <acquire>
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
8010075b:	e8 2c 3a 00 00       	call   8010418c <release>
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
80100791:	bf b8 6a 10 80       	mov    $0x80106ab8,%edi
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
801007de:	68 bf 6a 10 80       	push   $0x80106abf
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
801007f9:	e8 ee 39 00 00       	call   801041ec <acquire>
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
80100831:	e8 56 39 00 00       	call   8010418c <release>
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
80100936:	e8 8d 32 00 00       	call   80103bc8 <wakeup>
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
801009ac:	e9 eb 32 00 00       	jmp    80103c9c <procdump>
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
801009e6:	68 c8 6a 10 80       	push   $0x80106ac8
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 2f 36 00 00       	call   80104024 <initlock>

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
80100a19:	e8 b2 17 00 00       	call   801021d0 <ioapicenable>
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
80100a30:	e8 c3 2a 00 00       	call   801034f8 <myproc>
80100a35:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a3b:	e8 7c 1f 00 00       	call   801029bc <begin_op>

  if((ip = namei(path)) == 0){
80100a40:	83 ec 0c             	sub    $0xc,%esp
80100a43:	ff 75 08             	push   0x8(%ebp)
80100a46:	e8 29 14 00 00       	call   80101e74 <namei>
80100a4b:	83 c4 10             	add    $0x10,%esp
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	0f 84 14 03 00 00    	je     80100d6a <exec+0x346>
80100a56:	89 c7                	mov    %eax,%edi
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	50                   	push   %eax
80100a5c:	e8 bf 0b 00 00       	call   80101620 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a61:	6a 34                	push   $0x34
80100a63:	6a 00                	push   $0x0
80100a65:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a6b:	50                   	push   %eax
80100a6c:	57                   	push   %edi
80100a6d:	e8 7e 0e 00 00       	call   801018f0 <readi>
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
80100a8e:	e8 e1 5c 00 00       	call   80106774 <setupkvm>
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
80100aaf:	0f 84 85 02 00 00    	je     80100d3a <exec+0x316>
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
80100af9:	e8 e2 5a 00 00       	call   801065e0 <allocuvm>
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
80100b2f:	e8 e8 59 00 00       	call   8010651c <loaduvm>
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
80100b55:	e8 96 0d 00 00       	call   801018f0 <readi>
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
80100b6f:	e8 90 5b 00 00       	call   80106704 <freevm>
  if(ip){
80100b74:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100b77:	83 ec 0c             	sub    $0xc,%esp
80100b7a:	57                   	push   %edi
80100b7b:	e8 f4 0c 00 00       	call   80101874 <iunlockput>
    end_op();
80100b80:	e8 9f 1e 00 00       	call   80102a24 <end_op>
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
80100bb4:	e8 bb 0c 00 00       	call   80101874 <iunlockput>
  end_op();
80100bb9:	e8 66 1e 00 00       	call   80102a24 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bbe:	83 c4 0c             	add    $0xc,%esp
80100bc1:	53                   	push   %ebx
80100bc2:	56                   	push   %esi
80100bc3:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bc9:	56                   	push   %esi
80100bca:	e8 11 5a 00 00       	call   801065e0 <allocuvm>
80100bcf:	89 c7                	mov    %eax,%edi
80100bd1:	83 c4 10             	add    $0x10,%esp
80100bd4:	85 c0                	test   %eax,%eax
80100bd6:	74 7e                	je     80100c56 <exec+0x232>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd8:	83 ec 08             	sub    $0x8,%esp
80100bdb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be1:	50                   	push   %eax
80100be2:	56                   	push   %esi
80100be3:	e8 18 5c 00 00       	call   80106800 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100be8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100beb:	8b 10                	mov    (%eax),%edx
80100bed:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100bf0:	89 fb                	mov    %edi,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100bf2:	85 d2                	test   %edx,%edx
80100bf4:	0f 84 4c 01 00 00    	je     80100d46 <exec+0x322>
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
80100c2a:	e8 05 38 00 00       	call   80104434 <strlen>
80100c2f:	29 c3                	sub    %eax,%ebx
80100c31:	4b                   	dec    %ebx
80100c32:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c35:	5a                   	pop    %edx
80100c36:	ff 34 b7             	push   (%edi,%esi,4)
80100c39:	e8 f6 37 00 00       	call   80104434 <strlen>
80100c3e:	40                   	inc    %eax
80100c3f:	50                   	push   %eax
80100c40:	ff 34 b7             	push   (%edi,%esi,4)
80100c43:	53                   	push   %ebx
80100c44:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c4a:	e8 49 5d 00 00       	call   80106998 <copyout>
80100c4f:	83 c4 20             	add    $0x20,%esp
80100c52:	85 c0                	test   %eax,%eax
80100c54:	79 b2                	jns    80100c08 <exec+0x1e4>
    freevm(pgdir);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c5f:	e8 a0 5a 00 00       	call   80106704 <freevm>
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
80100cbb:	e8 d8 5c 00 00       	call   80106998 <copyout>
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
80100cef:	8d 86 94 00 00 00    	lea    0x94(%esi),%eax
80100cf5:	50                   	push   %eax
80100cf6:	e8 05 37 00 00       	call   80104400 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100cfb:	89 f0                	mov    %esi,%eax
80100cfd:	8b 76 2c             	mov    0x2c(%esi),%esi
  curproc->pgdir = pgdir;
80100d00:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d06:	89 48 2c             	mov    %ecx,0x2c(%eax)
  curproc->sz = sz;
80100d09:	89 78 28             	mov    %edi,0x28(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d0c:	89 c1                	mov    %eax,%ecx
80100d0e:	8b 40 40             	mov    0x40(%eax),%eax
80100d11:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d17:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d1a:	8b 41 40             	mov    0x40(%ecx),%eax
80100d1d:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d20:	89 0c 24             	mov    %ecx,(%esp)
80100d23:	e8 84 56 00 00       	call   801063ac <switchuvm>
  freevm(oldpgdir);
80100d28:	89 34 24             	mov    %esi,(%esp)
80100d2b:	e8 d4 59 00 00       	call   80106704 <freevm>
  return 0;
80100d30:	83 c4 10             	add    $0x10,%esp
80100d33:	31 c0                	xor    %eax,%eax
80100d35:	e9 53 fe ff ff       	jmp    80100b8d <exec+0x169>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d3a:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100d3f:	31 f6                	xor    %esi,%esi
80100d41:	e9 6a fe ff ff       	jmp    80100bb0 <exec+0x18c>
  for(argc = 0; argv[argc]; argc++) {
80100d46:	be 10 00 00 00       	mov    $0x10,%esi
80100d4b:	ba 04 00 00 00       	mov    $0x4,%edx
80100d50:	b8 03 00 00 00       	mov    $0x3,%eax
80100d55:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d5c:	00 00 00 
80100d5f:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d65:	e9 1b ff ff ff       	jmp    80100c85 <exec+0x261>
    end_op();
80100d6a:	e8 b5 1c 00 00       	call   80102a24 <end_op>
    cprintf("exec: fail\n");
80100d6f:	83 ec 0c             	sub    $0xc,%esp
80100d72:	68 d0 6a 10 80       	push   $0x80106ad0
80100d77:	e8 a4 f8 ff ff       	call   80100620 <cprintf>
    return -1;
80100d7c:	83 c4 10             	add    $0x10,%esp
80100d7f:	e9 04 fe ff ff       	jmp    80100b88 <exec+0x164>

80100d84 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d84:	55                   	push   %ebp
80100d85:	89 e5                	mov    %esp,%ebp
80100d87:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d8a:	68 dc 6a 10 80       	push   $0x80106adc
80100d8f:	68 60 ef 10 80       	push   $0x8010ef60
80100d94:	e8 8b 32 00 00       	call   80104024 <initlock>
}
80100d99:	83 c4 10             	add    $0x10,%esp
80100d9c:	c9                   	leave
80100d9d:	c3                   	ret
80100d9e:	66 90                	xchg   %ax,%ax

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
80100da4:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100da7:	68 60 ef 10 80       	push   $0x8010ef60
80100dac:	e8 3b 34 00 00       	call   801041ec <acquire>
80100db1:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100db9:	eb 0c                	jmp    80100dc7 <filealloc+0x27>
80100dbb:	90                   	nop
80100dbc:	83 c3 18             	add    $0x18,%ebx
80100dbf:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100dc5:	74 25                	je     80100dec <filealloc+0x4c>
    if(f->ref == 0){
80100dc7:	8b 43 04             	mov    0x4(%ebx),%eax
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	75 ee                	jne    80100dbc <filealloc+0x1c>
      f->ref = 1;
80100dce:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dd5:	83 ec 0c             	sub    $0xc,%esp
80100dd8:	68 60 ef 10 80       	push   $0x8010ef60
80100ddd:	e8 aa 33 00 00       	call   8010418c <release>
      return f;
80100de2:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de5:	89 d8                	mov    %ebx,%eax
80100de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dea:	c9                   	leave
80100deb:	c3                   	ret
  release(&ftable.lock);
80100dec:	83 ec 0c             	sub    $0xc,%esp
80100def:	68 60 ef 10 80       	push   $0x8010ef60
80100df4:	e8 93 33 00 00       	call   8010418c <release>
  return 0;
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	31 db                	xor    %ebx,%ebx
}
80100dfe:	89 d8                	mov    %ebx,%eax
80100e00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e03:	c9                   	leave
80100e04:	c3                   	ret
80100e05:	8d 76 00             	lea    0x0(%esi),%esi

80100e08 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e08:	55                   	push   %ebp
80100e09:	89 e5                	mov    %esp,%ebp
80100e0b:	53                   	push   %ebx
80100e0c:	83 ec 10             	sub    $0x10,%esp
80100e0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e12:	68 60 ef 10 80       	push   $0x8010ef60
80100e17:	e8 d0 33 00 00       	call   801041ec <acquire>
  if(f->ref < 1)
80100e1c:	8b 43 04             	mov    0x4(%ebx),%eax
80100e1f:	83 c4 10             	add    $0x10,%esp
80100e22:	85 c0                	test   %eax,%eax
80100e24:	7e 18                	jle    80100e3e <filedup+0x36>
    panic("filedup");
  f->ref++;
80100e26:	40                   	inc    %eax
80100e27:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e2a:	83 ec 0c             	sub    $0xc,%esp
80100e2d:	68 60 ef 10 80       	push   $0x8010ef60
80100e32:	e8 55 33 00 00       	call   8010418c <release>
  return f;
}
80100e37:	89 d8                	mov    %ebx,%eax
80100e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3c:	c9                   	leave
80100e3d:	c3                   	ret
    panic("filedup");
80100e3e:	83 ec 0c             	sub    $0xc,%esp
80100e41:	68 e3 6a 10 80       	push   $0x80106ae3
80100e46:	e8 ed f4 ff ff       	call   80100338 <panic>
80100e4b:	90                   	nop

80100e4c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e4c:	55                   	push   %ebp
80100e4d:	89 e5                	mov    %esp,%ebp
80100e4f:	57                   	push   %edi
80100e50:	56                   	push   %esi
80100e51:	53                   	push   %ebx
80100e52:	83 ec 28             	sub    $0x28,%esp
80100e55:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e58:	68 60 ef 10 80       	push   $0x8010ef60
80100e5d:	e8 8a 33 00 00       	call   801041ec <acquire>
  if(f->ref < 1)
80100e62:	8b 57 04             	mov    0x4(%edi),%edx
80100e65:	83 c4 10             	add    $0x10,%esp
80100e68:	85 d2                	test   %edx,%edx
80100e6a:	0f 8e 8d 00 00 00    	jle    80100efd <fileclose+0xb1>
    panic("fileclose");
  if(--f->ref > 0){
80100e70:	4a                   	dec    %edx
80100e71:	89 57 04             	mov    %edx,0x4(%edi)
80100e74:	75 3a                	jne    80100eb0 <fileclose+0x64>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e76:	8b 1f                	mov    (%edi),%ebx
80100e78:	8a 47 09             	mov    0x9(%edi),%al
80100e7b:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e7e:	8b 77 0c             	mov    0xc(%edi),%esi
80100e81:	8b 47 10             	mov    0x10(%edi),%eax
80100e84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
80100e87:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100e8d:	83 ec 0c             	sub    $0xc,%esp
80100e90:	68 60 ef 10 80       	push   $0x8010ef60
80100e95:	e8 f2 32 00 00       	call   8010418c <release>

  if(ff.type == FD_PIPE)
80100e9a:	83 c4 10             	add    $0x10,%esp
80100e9d:	83 fb 01             	cmp    $0x1,%ebx
80100ea0:	74 42                	je     80100ee4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea2:	83 fb 02             	cmp    $0x2,%ebx
80100ea5:	74 1d                	je     80100ec4 <fileclose+0x78>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eaa:	5b                   	pop    %ebx
80100eab:	5e                   	pop    %esi
80100eac:	5f                   	pop    %edi
80100ead:	5d                   	pop    %ebp
80100eae:	c3                   	ret
80100eaf:	90                   	nop
    release(&ftable.lock);
80100eb0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eba:	5b                   	pop    %ebx
80100ebb:	5e                   	pop    %esi
80100ebc:	5f                   	pop    %edi
80100ebd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ebe:	e9 c9 32 00 00       	jmp    8010418c <release>
80100ec3:	90                   	nop
    begin_op();
80100ec4:	e8 f3 1a 00 00       	call   801029bc <begin_op>
    iput(ff.ip);
80100ec9:	83 ec 0c             	sub    $0xc,%esp
80100ecc:	ff 75 e0             	push   -0x20(%ebp)
80100ecf:	e8 58 08 00 00       	call   8010172c <iput>
    end_op();
80100ed4:	83 c4 10             	add    $0x10,%esp
}
80100ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eda:	5b                   	pop    %ebx
80100edb:	5e                   	pop    %esi
80100edc:	5f                   	pop    %edi
80100edd:	5d                   	pop    %ebp
    end_op();
80100ede:	e9 41 1b 00 00       	jmp    80102a24 <end_op>
80100ee3:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100ee4:	83 ec 08             	sub    $0x8,%esp
80100ee7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100eeb:	50                   	push   %eax
80100eec:	56                   	push   %esi
80100eed:	e8 ca 21 00 00       	call   801030bc <pipeclose>
80100ef2:	83 c4 10             	add    $0x10,%esp
}
80100ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef8:	5b                   	pop    %ebx
80100ef9:	5e                   	pop    %esi
80100efa:	5f                   	pop    %edi
80100efb:	5d                   	pop    %ebp
80100efc:	c3                   	ret
    panic("fileclose");
80100efd:	83 ec 0c             	sub    $0xc,%esp
80100f00:	68 eb 6a 10 80       	push   $0x80106aeb
80100f05:	e8 2e f4 ff ff       	call   80100338 <panic>
80100f0a:	66 90                	xchg   %ax,%ax

80100f0c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f0c:	55                   	push   %ebp
80100f0d:	89 e5                	mov    %esp,%ebp
80100f0f:	53                   	push   %ebx
80100f10:	53                   	push   %ebx
80100f11:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f14:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f17:	75 2b                	jne    80100f44 <filestat+0x38>
    ilock(f->ip);
80100f19:	83 ec 0c             	sub    $0xc,%esp
80100f1c:	ff 73 10             	push   0x10(%ebx)
80100f1f:	e8 fc 06 00 00       	call   80101620 <ilock>
    stati(f->ip, st);
80100f24:	58                   	pop    %eax
80100f25:	5a                   	pop    %edx
80100f26:	ff 75 0c             	push   0xc(%ebp)
80100f29:	ff 73 10             	push   0x10(%ebx)
80100f2c:	e8 93 09 00 00       	call   801018c4 <stati>
    iunlock(f->ip);
80100f31:	59                   	pop    %ecx
80100f32:	ff 73 10             	push   0x10(%ebx)
80100f35:	e8 ae 07 00 00       	call   801016e8 <iunlock>
    return 0;
80100f3a:	83 c4 10             	add    $0x10,%esp
80100f3d:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f42:	c9                   	leave
80100f43:	c3                   	ret
  return -1;
80100f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f4c:	c9                   	leave
80100f4d:	c3                   	ret
80100f4e:	66 90                	xchg   %ax,%ax

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 1c             	sub    $0x1c,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 45                	je     80100fb4 <fileread+0x64>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	push   0x10(%ebx)
80100f7a:	e8 a1 06 00 00       	call   80101620 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	push   0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	push   0x10(%ebx)
80100f87:	e8 64 09 00 00       	call   801018f0 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	7e 03                	jle    80100f96 <fileread+0x46>
      f->off += r;
80100f93:	01 43 14             	add    %eax,0x14(%ebx)
80100f96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iunlock(f->ip);
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	ff 73 10             	push   0x10(%ebx)
80100f9f:	e8 44 07 00 00       	call   801016e8 <iunlock>
    return r;
80100fa4:	83 c4 10             	add    $0x10,%esp
80100fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fad:	5b                   	pop    %ebx
80100fae:	5e                   	pop    %esi
80100faf:	5f                   	pop    %edi
80100fb0:	5d                   	pop    %ebp
80100fb1:	c3                   	ret
80100fb2:	66 90                	xchg   %ax,%ax
    return piperead(f->pipe, addr, n);
80100fb4:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb7:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbd:	5b                   	pop    %ebx
80100fbe:	5e                   	pop    %esi
80100fbf:	5f                   	pop    %edi
80100fc0:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fc1:	e9 96 22 00 00       	jmp    8010325c <piperead>
80100fc6:	66 90                	xchg   %ax,%ax
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb db                	jmp    80100faa <fileread+0x5a>
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 f5 6a 10 80       	push   $0x80106af5
80100fd7:	e8 5c f3 ff ff       	call   80100338 <panic>

80100fdc <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fdc:	55                   	push   %ebp
80100fdd:	89 e5                	mov    %esp,%ebp
80100fdf:	57                   	push   %edi
80100fe0:	56                   	push   %esi
80100fe1:	53                   	push   %ebx
80100fe2:	83 ec 1c             	sub    $0x1c,%esp
80100fe5:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
80100feb:	8b 45 10             	mov    0x10(%ebp),%eax
80100fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ff1:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100ff5:	0f 84 ba 00 00 00    	je     801010b5 <filewrite+0xd9>
    return -1;
  if(f->type == FD_PIPE)
80100ffb:	8b 07                	mov    (%edi),%eax
80100ffd:	83 f8 01             	cmp    $0x1,%eax
80101000:	0f 84 be 00 00 00    	je     801010c4 <filewrite+0xe8>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101006:	83 f8 02             	cmp    $0x2,%eax
80101009:	0f 85 c7 00 00 00    	jne    801010d6 <filewrite+0xfa>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
8010100f:	31 db                	xor    %ebx,%ebx
    while(i < n){
80101011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101014:	85 c0                	test   %eax,%eax
80101016:	0f 8e 94 00 00 00    	jle    801010b0 <filewrite+0xd4>
    int i = 0;
8010101c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010101f:	eb 28                	jmp    80101049 <filewrite+0x6d>
80101021:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101024:	01 47 14             	add    %eax,0x14(%edi)
80101027:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	51                   	push   %ecx
8010102e:	e8 b5 06 00 00       	call   801016e8 <iunlock>
      end_op();
80101033:	e8 ec 19 00 00       	call   80102a24 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101038:	83 c4 10             	add    $0x10,%esp
8010103b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010103e:	39 f0                	cmp    %esi,%eax
80101040:	75 60                	jne    801010a2 <filewrite+0xc6>
        panic("short filewrite");
      i += r;
80101042:	01 f3                	add    %esi,%ebx
    while(i < n){
80101044:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80101047:	7e 67                	jle    801010b0 <filewrite+0xd4>
      int n1 = n - i;
80101049:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010104c:	29 de                	sub    %ebx,%esi
      if(n1 > max)
8010104e:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101054:	7e 05                	jle    8010105b <filewrite+0x7f>
80101056:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
8010105b:	e8 5c 19 00 00       	call   801029bc <begin_op>
      ilock(f->ip);
80101060:	83 ec 0c             	sub    $0xc,%esp
80101063:	ff 77 10             	push   0x10(%edi)
80101066:	e8 b5 05 00 00       	call   80101620 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010106b:	56                   	push   %esi
8010106c:	ff 77 14             	push   0x14(%edi)
8010106f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101072:	01 d8                	add    %ebx,%eax
80101074:	50                   	push   %eax
80101075:	ff 77 10             	push   0x10(%edi)
80101078:	e8 73 09 00 00       	call   801019f0 <writei>
      iunlock(f->ip);
8010107d:	8b 4f 10             	mov    0x10(%edi),%ecx
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101080:	83 c4 20             	add    $0x20,%esp
80101083:	85 c0                	test   %eax,%eax
80101085:	7f 9d                	jg     80101024 <filewrite+0x48>
      iunlock(f->ip);
80101087:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	51                   	push   %ecx
8010108e:	e8 55 06 00 00       	call   801016e8 <iunlock>
      end_op();
80101093:	e8 8c 19 00 00       	call   80102a24 <end_op>
      if(r < 0)
80101098:	83 c4 10             	add    $0x10,%esp
8010109b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109e:	85 c0                	test   %eax,%eax
801010a0:	75 0e                	jne    801010b0 <filewrite+0xd4>
        panic("short filewrite");
801010a2:	83 ec 0c             	sub    $0xc,%esp
801010a5:	68 fe 6a 10 80       	push   $0x80106afe
801010aa:	e8 89 f2 ff ff       	call   80100338 <panic>
801010af:	90                   	nop
    }
    return i == n ? n : -1;
801010b0:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801010b3:	74 05                	je     801010ba <filewrite+0xde>
    return -1;
801010b5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  panic("filewrite");
}
801010ba:	89 d8                	mov    %ebx,%eax
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010bf:	5b                   	pop    %ebx
801010c0:	5e                   	pop    %esi
801010c1:	5f                   	pop    %edi
801010c2:	5d                   	pop    %ebp
801010c3:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801010c4:	8b 47 0c             	mov    0xc(%edi),%eax
801010c7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010cd:	5b                   	pop    %ebx
801010ce:	5e                   	pop    %esi
801010cf:	5f                   	pop    %edi
801010d0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010d1:	e9 7e 20 00 00       	jmp    80103154 <pipewrite>
  panic("filewrite");
801010d6:	83 ec 0c             	sub    $0xc,%esp
801010d9:	68 04 6b 10 80       	push   $0x80106b04
801010de:	e8 55 f2 ff ff       	call   80100338 <panic>
801010e3:	90                   	nop

801010e4 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	57                   	push   %edi
801010e8:	56                   	push   %esi
801010e9:	53                   	push   %ebx
801010ea:	83 ec 1c             	sub    $0x1c,%esp
801010ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f0:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
801010f6:	85 c9                	test   %ecx,%ecx
801010f8:	74 7f                	je     80101179 <balloc+0x95>
801010fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801010fc:	83 ec 08             	sub    $0x8,%esp
801010ff:	89 f8                	mov    %edi,%eax
80101101:	c1 f8 0c             	sar    $0xc,%eax
80101104:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010110a:	50                   	push   %eax
8010110b:	ff 75 dc             	push   -0x24(%ebp)
8010110e:	e8 a1 ef ff ff       	call   801000b4 <bread>
80101113:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101115:	a1 b4 15 11 80       	mov    0x801115b4,%eax
8010111a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010111d:	89 fe                	mov    %edi,%esi
8010111f:	83 c4 10             	add    $0x10,%esp
80101122:	31 c0                	xor    %eax,%eax
80101124:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101127:	eb 2c                	jmp    80101155 <balloc+0x71>
80101129:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
8010112c:	89 c1                	mov    %eax,%ecx
8010112e:	83 e1 07             	and    $0x7,%ecx
80101131:	ba 01 00 00 00       	mov    $0x1,%edx
80101136:	d3 e2                	shl    %cl,%edx
80101138:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113b:	89 c1                	mov    %eax,%ecx
8010113d:	c1 f9 03             	sar    $0x3,%ecx
80101140:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101145:	89 fa                	mov    %edi,%edx
80101147:	85 7d e4             	test   %edi,-0x1c(%ebp)
8010114a:	74 3c                	je     80101188 <balloc+0xa4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114c:	40                   	inc    %eax
8010114d:	46                   	inc    %esi
8010114e:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101153:	74 07                	je     8010115c <balloc+0x78>
80101155:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101158:	39 fe                	cmp    %edi,%esi
8010115a:	72 d0                	jb     8010112c <balloc+0x48>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010115c:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	53                   	push   %ebx
80101163:	e8 54 f0 ff ff       	call   801001bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101168:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010116e:	83 c4 10             	add    $0x10,%esp
80101171:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101177:	72 83                	jb     801010fc <balloc+0x18>
  }
  panic("balloc: out of blocks");
80101179:	83 ec 0c             	sub    $0xc,%esp
8010117c:	68 0e 6b 10 80       	push   $0x80106b0e
80101181:	e8 b2 f1 ff ff       	call   80100338 <panic>
80101186:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101188:	0b 55 e4             	or     -0x1c(%ebp),%edx
8010118b:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	53                   	push   %ebx
80101193:	e8 e0 19 00 00       	call   80102b78 <log_write>
        brelse(bp);
80101198:	89 1c 24             	mov    %ebx,(%esp)
8010119b:	e8 1c f0 ff ff       	call   801001bc <brelse>
  bp = bread(dev, bno);
801011a0:	58                   	pop    %eax
801011a1:	5a                   	pop    %edx
801011a2:	56                   	push   %esi
801011a3:	ff 75 dc             	push   -0x24(%ebp)
801011a6:	e8 09 ef ff ff       	call   801000b4 <bread>
801011ab:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011ad:	83 c4 0c             	add    $0xc,%esp
801011b0:	68 00 02 00 00       	push   $0x200
801011b5:	6a 00                	push   $0x0
801011b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ba:	50                   	push   %eax
801011bb:	e8 f8 30 00 00       	call   801042b8 <memset>
  log_write(bp);
801011c0:	89 1c 24             	mov    %ebx,(%esp)
801011c3:	e8 b0 19 00 00       	call   80102b78 <log_write>
  brelse(bp);
801011c8:	89 1c 24             	mov    %ebx,(%esp)
801011cb:	e8 ec ef ff ff       	call   801001bc <brelse>
}
801011d0:	89 f0                	mov    %esi,%eax
801011d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d5:	5b                   	pop    %ebx
801011d6:	5e                   	pop    %esi
801011d7:	5f                   	pop    %edi
801011d8:	5d                   	pop    %ebp
801011d9:	c3                   	ret
801011da:	66 90                	xchg   %ax,%ax

801011dc <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011dc:	55                   	push   %ebp
801011dd:	89 e5                	mov    %esp,%ebp
801011df:	57                   	push   %edi
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	83 ec 28             	sub    $0x28,%esp
801011e5:	89 c6                	mov    %eax,%esi
801011e7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011ea:	68 60 f9 10 80       	push   $0x8010f960
801011ef:	e8 f8 2f 00 00       	call   801041ec <acquire>
801011f4:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801011f7:	31 ff                	xor    %edi,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011f9:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
801011fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101201:	eb 13                	jmp    80101216 <iget+0x3a>
80101203:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101204:	39 33                	cmp    %esi,(%ebx)
80101206:	74 64                	je     8010126c <iget+0x90>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101208:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010120e:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101214:	74 22                	je     80101238 <iget+0x5c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101216:	8b 43 08             	mov    0x8(%ebx),%eax
80101219:	85 c0                	test   %eax,%eax
8010121b:	7f e7                	jg     80101204 <iget+0x28>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010121d:	85 ff                	test   %edi,%edi
8010121f:	75 e7                	jne    80101208 <iget+0x2c>
80101221:	85 c0                	test   %eax,%eax
80101223:	75 6c                	jne    80101291 <iget+0xb5>
      empty = ip;
80101225:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101227:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010122d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101233:	75 e1                	jne    80101216 <iget+0x3a>
80101235:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101238:	85 ff                	test   %edi,%edi
8010123a:	74 73                	je     801012af <iget+0xd3>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
8010123c:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
8010123e:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101241:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80101248:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
8010124f:	83 ec 0c             	sub    $0xc,%esp
80101252:	68 60 f9 10 80       	push   $0x8010f960
80101257:	e8 30 2f 00 00       	call   8010418c <release>

  return ip;
8010125c:	83 c4 10             	add    $0x10,%esp
}
8010125f:	89 f8                	mov    %edi,%eax
80101261:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101264:	5b                   	pop    %ebx
80101265:	5e                   	pop    %esi
80101266:	5f                   	pop    %edi
80101267:	5d                   	pop    %ebp
80101268:	c3                   	ret
80101269:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010126c:	39 53 04             	cmp    %edx,0x4(%ebx)
8010126f:	75 97                	jne    80101208 <iget+0x2c>
      ip->ref++;
80101271:	40                   	inc    %eax
80101272:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101275:	83 ec 0c             	sub    $0xc,%esp
80101278:	68 60 f9 10 80       	push   $0x8010f960
8010127d:	e8 0a 2f 00 00       	call   8010418c <release>
      return ip;
80101282:	83 c4 10             	add    $0x10,%esp
80101285:	89 df                	mov    %ebx,%edi
}
80101287:	89 f8                	mov    %edi,%eax
80101289:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128c:	5b                   	pop    %ebx
8010128d:	5e                   	pop    %esi
8010128e:	5f                   	pop    %edi
8010128f:	5d                   	pop    %ebp
80101290:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101291:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101297:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010129d:	74 10                	je     801012af <iget+0xd3>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010129f:	8b 43 08             	mov    0x8(%ebx),%eax
801012a2:	85 c0                	test   %eax,%eax
801012a4:	0f 8f 5a ff ff ff    	jg     80101204 <iget+0x28>
801012aa:	e9 72 ff ff ff       	jmp    80101221 <iget+0x45>
    panic("iget: no inodes");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 24 6b 10 80       	push   $0x80106b24
801012b7:	e8 7c f0 ff ff       	call   80100338 <panic>

801012bc <bfree>:
{
801012bc:	55                   	push   %ebp
801012bd:	89 e5                	mov    %esp,%ebp
801012bf:	56                   	push   %esi
801012c0:	53                   	push   %ebx
801012c1:	89 c1                	mov    %eax,%ecx
801012c3:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801012c5:	83 ec 08             	sub    $0x8,%esp
801012c8:	89 d0                	mov    %edx,%eax
801012ca:	c1 e8 0c             	shr    $0xc,%eax
801012cd:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801012d3:	50                   	push   %eax
801012d4:	51                   	push   %ecx
801012d5:	e8 da ed ff ff       	call   801000b4 <bread>
801012da:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012dc:	89 d9                	mov    %ebx,%ecx
801012de:	83 e1 07             	and    $0x7,%ecx
801012e1:	b8 01 00 00 00       	mov    $0x1,%eax
801012e6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012e8:	c1 fb 03             	sar    $0x3,%ebx
801012eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801012f1:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801012f6:	83 c4 10             	add    $0x10,%esp
801012f9:	85 c1                	test   %eax,%ecx
801012fb:	74 23                	je     80101320 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801012fd:	f7 d0                	not    %eax
801012ff:	21 c8                	and    %ecx,%eax
80101301:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	56                   	push   %esi
80101309:	e8 6a 18 00 00       	call   80102b78 <log_write>
  brelse(bp);
8010130e:	89 34 24             	mov    %esi,(%esp)
80101311:	e8 a6 ee ff ff       	call   801001bc <brelse>
}
80101316:	83 c4 10             	add    $0x10,%esp
80101319:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5d                   	pop    %ebp
8010131f:	c3                   	ret
    panic("freeing free block");
80101320:	83 ec 0c             	sub    $0xc,%esp
80101323:	68 34 6b 10 80       	push   $0x80106b34
80101328:	e8 0b f0 ff ff       	call   80100338 <panic>
8010132d:	8d 76 00             	lea    0x0(%esi),%esi

80101330 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	83 ec 1c             	sub    $0x1c,%esp
80101339:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010133b:	83 fa 0b             	cmp    $0xb,%edx
8010133e:	76 7c                	jbe    801013bc <bmap+0x8c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101340:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101343:	83 fb 7f             	cmp    $0x7f,%ebx
80101346:	0f 87 8e 00 00 00    	ja     801013da <bmap+0xaa>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010134c:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101352:	85 c0                	test   %eax,%eax
80101354:	74 56                	je     801013ac <bmap+0x7c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101356:	83 ec 08             	sub    $0x8,%esp
80101359:	50                   	push   %eax
8010135a:	ff 36                	push   (%esi)
8010135c:	e8 53 ed ff ff       	call   801000b4 <bread>
80101361:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101363:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
80101367:	8b 03                	mov    (%ebx),%eax
80101369:	83 c4 10             	add    $0x10,%esp
8010136c:	85 c0                	test   %eax,%eax
8010136e:	74 1c                	je     8010138c <bmap+0x5c>
80101370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101373:	83 ec 0c             	sub    $0xc,%esp
80101376:	57                   	push   %edi
80101377:	e8 40 ee ff ff       	call   801001bc <brelse>
8010137c:	83 c4 10             	add    $0x10,%esp
8010137f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101382:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101385:	5b                   	pop    %ebx
80101386:	5e                   	pop    %esi
80101387:	5f                   	pop    %edi
80101388:	5d                   	pop    %ebp
80101389:	c3                   	ret
8010138a:	66 90                	xchg   %ax,%ax
      a[bn] = addr = balloc(ip->dev);
8010138c:	8b 06                	mov    (%esi),%eax
8010138e:	e8 51 fd ff ff       	call   801010e4 <balloc>
80101393:	89 03                	mov    %eax,(%ebx)
80101395:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
80101398:	83 ec 0c             	sub    $0xc,%esp
8010139b:	57                   	push   %edi
8010139c:	e8 d7 17 00 00       	call   80102b78 <log_write>
801013a1:	83 c4 10             	add    $0x10,%esp
801013a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801013a7:	eb c7                	jmp    80101370 <bmap+0x40>
801013a9:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013ac:	8b 06                	mov    (%esi),%eax
801013ae:	e8 31 fd ff ff       	call   801010e4 <balloc>
801013b3:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013b9:	eb 9b                	jmp    80101356 <bmap+0x26>
801013bb:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801013bc:	8d 5a 14             	lea    0x14(%edx),%ebx
801013bf:	8b 44 98 0c          	mov    0xc(%eax,%ebx,4),%eax
801013c3:	85 c0                	test   %eax,%eax
801013c5:	75 bb                	jne    80101382 <bmap+0x52>
      ip->addrs[bn] = addr = balloc(ip->dev);
801013c7:	8b 06                	mov    (%esi),%eax
801013c9:	e8 16 fd ff ff       	call   801010e4 <balloc>
801013ce:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
}
801013d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d5:	5b                   	pop    %ebx
801013d6:	5e                   	pop    %esi
801013d7:	5f                   	pop    %edi
801013d8:	5d                   	pop    %ebp
801013d9:	c3                   	ret
  panic("bmap: out of range");
801013da:	83 ec 0c             	sub    $0xc,%esp
801013dd:	68 47 6b 10 80       	push   $0x80106b47
801013e2:	e8 51 ef ff ff       	call   80100338 <panic>
801013e7:	90                   	nop

801013e8 <readsb>:
{
801013e8:	55                   	push   %ebp
801013e9:	89 e5                	mov    %esp,%ebp
801013eb:	56                   	push   %esi
801013ec:	53                   	push   %ebx
801013ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013f0:	83 ec 08             	sub    $0x8,%esp
801013f3:	6a 01                	push   $0x1
801013f5:	ff 75 08             	push   0x8(%ebp)
801013f8:	e8 b7 ec ff ff       	call   801000b4 <bread>
801013fd:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013ff:	83 c4 0c             	add    $0xc,%esp
80101402:	6a 1c                	push   $0x1c
80101404:	8d 40 5c             	lea    0x5c(%eax),%eax
80101407:	50                   	push   %eax
80101408:	56                   	push   %esi
80101409:	e8 26 2f 00 00       	call   80104334 <memmove>
  brelse(bp);
8010140e:	83 c4 10             	add    $0x10,%esp
80101411:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101417:	5b                   	pop    %ebx
80101418:	5e                   	pop    %esi
80101419:	5d                   	pop    %ebp
  brelse(bp);
8010141a:	e9 9d ed ff ff       	jmp    801001bc <brelse>
8010141f:	90                   	nop

80101420 <iinit>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	53                   	push   %ebx
80101424:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101427:	68 5a 6b 10 80       	push   $0x80106b5a
8010142c:	68 60 f9 10 80       	push   $0x8010f960
80101431:	e8 ee 2b 00 00       	call   80104024 <initlock>
  for(i = 0; i < NINODE; i++) {
80101436:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
8010143b:	83 c4 10             	add    $0x10,%esp
8010143e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101440:	83 ec 08             	sub    $0x8,%esp
80101443:	68 61 6b 10 80       	push   $0x80106b61
80101448:	53                   	push   %ebx
80101449:	e8 ca 2a 00 00       	call   80103f18 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010144e:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101454:	83 c4 10             	add    $0x10,%esp
80101457:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010145d:	75 e1                	jne    80101440 <iinit+0x20>
  bp = bread(dev, 1);
8010145f:	83 ec 08             	sub    $0x8,%esp
80101462:	6a 01                	push   $0x1
80101464:	ff 75 08             	push   0x8(%ebp)
80101467:	e8 48 ec ff ff       	call   801000b4 <bread>
8010146c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010146e:	83 c4 0c             	add    $0xc,%esp
80101471:	6a 1c                	push   $0x1c
80101473:	8d 40 5c             	lea    0x5c(%eax),%eax
80101476:	50                   	push   %eax
80101477:	68 b4 15 11 80       	push   $0x801115b4
8010147c:	e8 b3 2e 00 00       	call   80104334 <memmove>
  brelse(bp);
80101481:	89 1c 24             	mov    %ebx,(%esp)
80101484:	e8 33 ed ff ff       	call   801001bc <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101489:	ff 35 cc 15 11 80    	push   0x801115cc
8010148f:	ff 35 c8 15 11 80    	push   0x801115c8
80101495:	ff 35 c4 15 11 80    	push   0x801115c4
8010149b:	ff 35 c0 15 11 80    	push   0x801115c0
801014a1:	ff 35 bc 15 11 80    	push   0x801115bc
801014a7:	ff 35 b8 15 11 80    	push   0x801115b8
801014ad:	ff 35 b4 15 11 80    	push   0x801115b4
801014b3:	68 84 6f 10 80       	push   $0x80106f84
801014b8:	e8 63 f1 ff ff       	call   80100620 <cprintf>
}
801014bd:	83 c4 30             	add    $0x30,%esp
801014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014c3:	c9                   	leave
801014c4:	c3                   	ret
801014c5:	8d 76 00             	lea    0x0(%esi),%esi

801014c8 <ialloc>:
{
801014c8:	55                   	push   %ebp
801014c9:	89 e5                	mov    %esp,%ebp
801014cb:	57                   	push   %edi
801014cc:	56                   	push   %esi
801014cd:	53                   	push   %ebx
801014ce:	83 ec 1c             	sub    $0x1c,%esp
801014d1:	8b 75 08             	mov    0x8(%ebp),%esi
801014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801014d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801014da:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
801014e1:	0f 86 84 00 00 00    	jbe    8010156b <ialloc+0xa3>
801014e7:	bf 01 00 00 00       	mov    $0x1,%edi
801014ec:	eb 17                	jmp    80101505 <ialloc+0x3d>
801014ee:	66 90                	xchg   %ax,%ax
    brelse(bp);
801014f0:	83 ec 0c             	sub    $0xc,%esp
801014f3:	53                   	push   %ebx
801014f4:	e8 c3 ec ff ff       	call   801001bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	47                   	inc    %edi
801014fa:	83 c4 10             	add    $0x10,%esp
801014fd:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101503:	73 66                	jae    8010156b <ialloc+0xa3>
    bp = bread(dev, IBLOCK(inum, sb));
80101505:	83 ec 08             	sub    $0x8,%esp
80101508:	89 f8                	mov    %edi,%eax
8010150a:	c1 e8 03             	shr    $0x3,%eax
8010150d:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101513:	50                   	push   %eax
80101514:	56                   	push   %esi
80101515:	e8 9a eb ff ff       	call   801000b4 <bread>
8010151a:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	83 e0 07             	and    $0x7,%eax
80101521:	c1 e0 06             	shl    $0x6,%eax
80101524:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101528:	83 c4 10             	add    $0x10,%esp
8010152b:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010152f:	75 bf                	jne    801014f0 <ialloc+0x28>
      memset(dip, 0, sizeof(*dip));
80101531:	50                   	push   %eax
80101532:	6a 40                	push   $0x40
80101534:	6a 00                	push   $0x0
80101536:	51                   	push   %ecx
80101537:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010153a:	e8 79 2d 00 00       	call   801042b8 <memset>
      dip->type = type;
8010153f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101542:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101545:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101548:	89 1c 24             	mov    %ebx,(%esp)
8010154b:	e8 28 16 00 00       	call   80102b78 <log_write>
      brelse(bp);
80101550:	89 1c 24             	mov    %ebx,(%esp)
80101553:	e8 64 ec ff ff       	call   801001bc <brelse>
      return iget(dev, inum);
80101558:	83 c4 10             	add    $0x10,%esp
8010155b:	89 fa                	mov    %edi,%edx
8010155d:	89 f0                	mov    %esi,%eax
}
8010155f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101562:	5b                   	pop    %ebx
80101563:	5e                   	pop    %esi
80101564:	5f                   	pop    %edi
80101565:	5d                   	pop    %ebp
      return iget(dev, inum);
80101566:	e9 71 fc ff ff       	jmp    801011dc <iget>
  panic("ialloc: no inodes");
8010156b:	83 ec 0c             	sub    $0xc,%esp
8010156e:	68 67 6b 10 80       	push   $0x80106b67
80101573:	e8 c0 ed ff ff       	call   80100338 <panic>

80101578 <iupdate>:
{
80101578:	55                   	push   %ebp
80101579:	89 e5                	mov    %esp,%ebp
8010157b:	56                   	push   %esi
8010157c:	53                   	push   %ebx
8010157d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	8b 43 04             	mov    0x4(%ebx),%eax
80101586:	c1 e8 03             	shr    $0x3,%eax
80101589:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010158f:	50                   	push   %eax
80101590:	ff 33                	push   (%ebx)
80101592:	e8 1d eb ff ff       	call   801000b4 <bread>
80101597:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101599:	8b 43 04             	mov    0x4(%ebx),%eax
8010159c:	83 e0 07             	and    $0x7,%eax
8010159f:	c1 e0 06             	shl    $0x6,%eax
801015a2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015a6:	8b 53 50             	mov    0x50(%ebx),%edx
801015a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ac:	66 8b 53 52          	mov    0x52(%ebx),%dx
801015b0:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801015b4:	8b 53 54             	mov    0x54(%ebx),%edx
801015b7:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801015bb:	66 8b 53 56          	mov    0x56(%ebx),%dx
801015bf:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801015c3:	8b 53 58             	mov    0x58(%ebx),%edx
801015c6:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015c9:	83 c4 0c             	add    $0xc,%esp
801015cc:	6a 34                	push   $0x34
801015ce:	83 c3 5c             	add    $0x5c,%ebx
801015d1:	53                   	push   %ebx
801015d2:	83 c0 0c             	add    $0xc,%eax
801015d5:	50                   	push   %eax
801015d6:	e8 59 2d 00 00       	call   80104334 <memmove>
  log_write(bp);
801015db:	89 34 24             	mov    %esi,(%esp)
801015de:	e8 95 15 00 00       	call   80102b78 <log_write>
  brelse(bp);
801015e3:	83 c4 10             	add    $0x10,%esp
801015e6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801015e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ec:	5b                   	pop    %ebx
801015ed:	5e                   	pop    %esi
801015ee:	5d                   	pop    %ebp
  brelse(bp);
801015ef:	e9 c8 eb ff ff       	jmp    801001bc <brelse>

801015f4 <idup>:
{
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	53                   	push   %ebx
801015f8:	83 ec 10             	sub    $0x10,%esp
801015fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015fe:	68 60 f9 10 80       	push   $0x8010f960
80101603:	e8 e4 2b 00 00       	call   801041ec <acquire>
  ip->ref++;
80101608:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
8010160b:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101612:	e8 75 2b 00 00       	call   8010418c <release>
}
80101617:	89 d8                	mov    %ebx,%eax
80101619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010161c:	c9                   	leave
8010161d:	c3                   	ret
8010161e:	66 90                	xchg   %ax,%ax

80101620 <ilock>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101628:	85 db                	test   %ebx,%ebx
8010162a:	0f 84 a9 00 00 00    	je     801016d9 <ilock+0xb9>
80101630:	8b 53 08             	mov    0x8(%ebx),%edx
80101633:	85 d2                	test   %edx,%edx
80101635:	0f 8e 9e 00 00 00    	jle    801016d9 <ilock+0xb9>
  acquiresleep(&ip->lock);
8010163b:	83 ec 0c             	sub    $0xc,%esp
8010163e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101641:	50                   	push   %eax
80101642:	e8 05 29 00 00       	call   80103f4c <acquiresleep>
  if(ip->valid == 0){
80101647:	83 c4 10             	add    $0x10,%esp
8010164a:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010164d:	85 c0                	test   %eax,%eax
8010164f:	74 07                	je     80101658 <ilock+0x38>
}
80101651:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101654:	5b                   	pop    %ebx
80101655:	5e                   	pop    %esi
80101656:	5d                   	pop    %ebp
80101657:	c3                   	ret
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	8b 43 04             	mov    0x4(%ebx),%eax
8010165e:	c1 e8 03             	shr    $0x3,%eax
80101661:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101667:	50                   	push   %eax
80101668:	ff 33                	push   (%ebx)
8010166a:	e8 45 ea ff ff       	call   801000b4 <bread>
8010166f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101671:	8b 43 04             	mov    0x4(%ebx),%eax
80101674:	83 e0 07             	and    $0x7,%eax
80101677:	c1 e0 06             	shl    $0x6,%eax
8010167a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010167e:	8b 10                	mov    (%eax),%edx
80101680:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101684:	66 8b 50 02          	mov    0x2(%eax),%dx
80101688:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010168c:	8b 50 04             	mov    0x4(%eax),%edx
8010168f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101693:	66 8b 50 06          	mov    0x6(%eax),%dx
80101697:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010169b:	8b 50 08             	mov    0x8(%eax),%edx
8010169e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016a1:	83 c4 0c             	add    $0xc,%esp
801016a4:	6a 34                	push   $0x34
801016a6:	83 c0 0c             	add    $0xc,%eax
801016a9:	50                   	push   %eax
801016aa:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016ad:	50                   	push   %eax
801016ae:	e8 81 2c 00 00       	call   80104334 <memmove>
    brelse(bp);
801016b3:	89 34 24             	mov    %esi,(%esp)
801016b6:	e8 01 eb ff ff       	call   801001bc <brelse>
    ip->valid = 1;
801016bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801016c2:	83 c4 10             	add    $0x10,%esp
801016c5:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801016ca:	75 85                	jne    80101651 <ilock+0x31>
      panic("ilock: no type");
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	68 7f 6b 10 80       	push   $0x80106b7f
801016d4:	e8 5f ec ff ff       	call   80100338 <panic>
    panic("ilock");
801016d9:	83 ec 0c             	sub    $0xc,%esp
801016dc:	68 79 6b 10 80       	push   $0x80106b79
801016e1:	e8 52 ec ff ff       	call   80100338 <panic>
801016e6:	66 90                	xchg   %ax,%ax

801016e8 <iunlock>:
{
801016e8:	55                   	push   %ebp
801016e9:	89 e5                	mov    %esp,%ebp
801016eb:	56                   	push   %esi
801016ec:	53                   	push   %ebx
801016ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801016f0:	85 db                	test   %ebx,%ebx
801016f2:	74 28                	je     8010171c <iunlock+0x34>
801016f4:	8d 73 0c             	lea    0xc(%ebx),%esi
801016f7:	83 ec 0c             	sub    $0xc,%esp
801016fa:	56                   	push   %esi
801016fb:	e8 dc 28 00 00       	call   80103fdc <holdingsleep>
80101700:	83 c4 10             	add    $0x10,%esp
80101703:	85 c0                	test   %eax,%eax
80101705:	74 15                	je     8010171c <iunlock+0x34>
80101707:	8b 43 08             	mov    0x8(%ebx),%eax
8010170a:	85 c0                	test   %eax,%eax
8010170c:	7e 0e                	jle    8010171c <iunlock+0x34>
  releasesleep(&ip->lock);
8010170e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101711:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101714:	5b                   	pop    %ebx
80101715:	5e                   	pop    %esi
80101716:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101717:	e9 84 28 00 00       	jmp    80103fa0 <releasesleep>
    panic("iunlock");
8010171c:	83 ec 0c             	sub    $0xc,%esp
8010171f:	68 8e 6b 10 80       	push   $0x80106b8e
80101724:	e8 0f ec ff ff       	call   80100338 <panic>
80101729:	8d 76 00             	lea    0x0(%esi),%esi

8010172c <iput>:
{
8010172c:	55                   	push   %ebp
8010172d:	89 e5                	mov    %esp,%ebp
8010172f:	57                   	push   %edi
80101730:	56                   	push   %esi
80101731:	53                   	push   %ebx
80101732:	83 ec 28             	sub    $0x28,%esp
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101738:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010173b:	57                   	push   %edi
8010173c:	e8 0b 28 00 00       	call   80103f4c <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101741:	83 c4 10             	add    $0x10,%esp
80101744:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101747:	85 c0                	test   %eax,%eax
80101749:	74 07                	je     80101752 <iput+0x26>
8010174b:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101750:	74 2e                	je     80101780 <iput+0x54>
  releasesleep(&ip->lock);
80101752:	83 ec 0c             	sub    $0xc,%esp
80101755:	57                   	push   %edi
80101756:	e8 45 28 00 00       	call   80103fa0 <releasesleep>
  acquire(&icache.lock);
8010175b:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101762:	e8 85 2a 00 00       	call   801041ec <acquire>
  ip->ref--;
80101767:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101774:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101777:	5b                   	pop    %ebx
80101778:	5e                   	pop    %esi
80101779:	5f                   	pop    %edi
8010177a:	5d                   	pop    %ebp
  release(&icache.lock);
8010177b:	e9 0c 2a 00 00       	jmp    8010418c <release>
    acquire(&icache.lock);
80101780:	83 ec 0c             	sub    $0xc,%esp
80101783:	68 60 f9 10 80       	push   $0x8010f960
80101788:	e8 5f 2a 00 00       	call   801041ec <acquire>
    int r = ip->ref;
8010178d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101790:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101797:	e8 f0 29 00 00       	call   8010418c <release>
    if(r == 1){
8010179c:	83 c4 10             	add    $0x10,%esp
8010179f:	4e                   	dec    %esi
801017a0:	75 b0                	jne    80101752 <iput+0x26>
801017a2:	8d 73 5c             	lea    0x5c(%ebx),%esi
801017a5:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801017ab:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801017ae:	89 df                	mov    %ebx,%edi
801017b0:	89 cb                	mov    %ecx,%ebx
801017b2:	eb 07                	jmp    801017bb <iput+0x8f>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017b4:	83 c6 04             	add    $0x4,%esi
801017b7:	39 de                	cmp    %ebx,%esi
801017b9:	74 15                	je     801017d0 <iput+0xa4>
    if(ip->addrs[i]){
801017bb:	8b 16                	mov    (%esi),%edx
801017bd:	85 d2                	test   %edx,%edx
801017bf:	74 f3                	je     801017b4 <iput+0x88>
      bfree(ip->dev, ip->addrs[i]);
801017c1:	8b 07                	mov    (%edi),%eax
801017c3:	e8 f4 fa ff ff       	call   801012bc <bfree>
      ip->addrs[i] = 0;
801017c8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801017ce:	eb e4                	jmp    801017b4 <iput+0x88>
    }
  }

  if(ip->addrs[NDIRECT]){
801017d0:	89 fb                	mov    %edi,%ebx
801017d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801017d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801017db:	85 c0                	test   %eax,%eax
801017dd:	75 2d                	jne    8010180c <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801017df:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	53                   	push   %ebx
801017ea:	e8 89 fd ff ff       	call   80101578 <iupdate>
      ip->type = 0;
801017ef:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801017f5:	89 1c 24             	mov    %ebx,(%esp)
801017f8:	e8 7b fd ff ff       	call   80101578 <iupdate>
      ip->valid = 0;
801017fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	e9 46 ff ff ff       	jmp    80101752 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010180c:	83 ec 08             	sub    $0x8,%esp
8010180f:	50                   	push   %eax
80101810:	ff 33                	push   (%ebx)
80101812:	e8 9d e8 ff ff       	call   801000b4 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101817:	8d 70 5c             	lea    0x5c(%eax),%esi
8010181a:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101820:	83 c4 10             	add    $0x10,%esp
80101823:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101826:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101829:	89 cf                	mov    %ecx,%edi
8010182b:	eb 0a                	jmp    80101837 <iput+0x10b>
8010182d:	8d 76 00             	lea    0x0(%esi),%esi
80101830:	83 c6 04             	add    $0x4,%esi
80101833:	39 fe                	cmp    %edi,%esi
80101835:	74 0f                	je     80101846 <iput+0x11a>
      if(a[j])
80101837:	8b 16                	mov    (%esi),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x104>
        bfree(ip->dev, a[j]);
8010183d:	8b 03                	mov    (%ebx),%eax
8010183f:	e8 78 fa ff ff       	call   801012bc <bfree>
80101844:	eb ea                	jmp    80101830 <iput+0x104>
    brelse(bp);
80101846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101849:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010184c:	83 ec 0c             	sub    $0xc,%esp
8010184f:	50                   	push   %eax
80101850:	e8 67 e9 ff ff       	call   801001bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101855:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010185b:	8b 03                	mov    (%ebx),%eax
8010185d:	e8 5a fa ff ff       	call   801012bc <bfree>
    ip->addrs[NDIRECT] = 0;
80101862:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101869:	00 00 00 
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	e9 6b ff ff ff       	jmp    801017df <iput+0xb3>

80101874 <iunlockput>:
{
80101874:	55                   	push   %ebp
80101875:	89 e5                	mov    %esp,%ebp
80101877:	56                   	push   %esi
80101878:	53                   	push   %ebx
80101879:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010187c:	85 db                	test   %ebx,%ebx
8010187e:	74 34                	je     801018b4 <iunlockput+0x40>
80101880:	8d 73 0c             	lea    0xc(%ebx),%esi
80101883:	83 ec 0c             	sub    $0xc,%esp
80101886:	56                   	push   %esi
80101887:	e8 50 27 00 00       	call   80103fdc <holdingsleep>
8010188c:	83 c4 10             	add    $0x10,%esp
8010188f:	85 c0                	test   %eax,%eax
80101891:	74 21                	je     801018b4 <iunlockput+0x40>
80101893:	8b 43 08             	mov    0x8(%ebx),%eax
80101896:	85 c0                	test   %eax,%eax
80101898:	7e 1a                	jle    801018b4 <iunlockput+0x40>
  releasesleep(&ip->lock);
8010189a:	83 ec 0c             	sub    $0xc,%esp
8010189d:	56                   	push   %esi
8010189e:	e8 fd 26 00 00       	call   80103fa0 <releasesleep>
  iput(ip);
801018a3:	83 c4 10             	add    $0x10,%esp
801018a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  iput(ip);
801018af:	e9 78 fe ff ff       	jmp    8010172c <iput>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 8e 6b 10 80       	push   $0x80106b8e
801018bc:	e8 77 ea ff ff       	call   80100338 <panic>
801018c1:	8d 76 00             	lea    0x0(%esi),%esi

801018c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801018c4:	55                   	push   %ebp
801018c5:	89 e5                	mov    %esp,%ebp
801018c7:	8b 55 08             	mov    0x8(%ebp),%edx
801018ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018cd:	8b 0a                	mov    (%edx),%ecx
801018cf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018d2:	8b 4a 04             	mov    0x4(%edx),%ecx
801018d5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801018d8:	8b 4a 50             	mov    0x50(%edx),%ecx
801018db:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801018de:	66 8b 4a 56          	mov    0x56(%edx),%cx
801018e2:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801018e6:	8b 52 58             	mov    0x58(%edx),%edx
801018e9:	89 50 10             	mov    %edx,0x10(%eax)
}
801018ec:	5d                   	pop    %ebp
801018ed:	c3                   	ret
801018ee:	66 90                	xchg   %ax,%ax

801018f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	53                   	push   %ebx
801018f6:	83 ec 1c             	sub    $0x1c,%esp
801018f9:	8b 45 08             	mov    0x8(%ebp),%eax
801018fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
801018ff:	8b 75 0c             	mov    0xc(%ebp),%esi
80101902:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101905:	8b 7d 10             	mov    0x10(%ebp),%edi
80101908:	8b 75 14             	mov    0x14(%ebp),%esi
8010190b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010190e:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101913:	0f 84 af 00 00 00    	je     801019c8 <readi+0xd8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101919:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010191c:	8b 50 58             	mov    0x58(%eax),%edx
8010191f:	39 fa                	cmp    %edi,%edx
80101921:	0f 82 c2 00 00 00    	jb     801019e9 <readi+0xf9>
80101927:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010192a:	31 c0                	xor    %eax,%eax
8010192c:	01 f9                	add    %edi,%ecx
8010192e:	0f 92 c0             	setb   %al
80101931:	89 c3                	mov    %eax,%ebx
80101933:	0f 82 b0 00 00 00    	jb     801019e9 <readi+0xf9>
    return -1;
  if(off + n > ip->size)
80101939:	39 ca                	cmp    %ecx,%edx
8010193b:	72 7f                	jb     801019bc <readi+0xcc>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010193d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101940:	85 f6                	test   %esi,%esi
80101942:	74 6a                	je     801019ae <readi+0xbe>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101944:	89 de                	mov    %ebx,%esi
80101946:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101948:	89 fa                	mov    %edi,%edx
8010194a:	c1 ea 09             	shr    $0x9,%edx
8010194d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101950:	89 d8                	mov    %ebx,%eax
80101952:	e8 d9 f9 ff ff       	call   80101330 <bmap>
80101957:	83 ec 08             	sub    $0x8,%esp
8010195a:	50                   	push   %eax
8010195b:	ff 33                	push   (%ebx)
8010195d:	e8 52 e7 ff ff       	call   801000b4 <bread>
80101962:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101964:	89 f8                	mov    %edi,%eax
80101966:	25 ff 01 00 00       	and    $0x1ff,%eax
8010196b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010196e:	29 f1                	sub    %esi,%ecx
80101970:	bb 00 02 00 00       	mov    $0x200,%ebx
80101975:	29 c3                	sub    %eax,%ebx
80101977:	83 c4 10             	add    $0x10,%esp
8010197a:	39 d9                	cmp    %ebx,%ecx
8010197c:	73 02                	jae    80101980 <readi+0x90>
8010197e:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101980:	51                   	push   %ecx
80101981:	53                   	push   %ebx
80101982:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101986:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101989:	50                   	push   %eax
8010198a:	ff 75 e0             	push   -0x20(%ebp)
8010198d:	e8 a2 29 00 00       	call   80104334 <memmove>
    brelse(bp);
80101992:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101995:	89 14 24             	mov    %edx,(%esp)
80101998:	e8 1f e8 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	01 de                	add    %ebx,%esi
8010199f:	01 df                	add    %ebx,%edi
801019a1:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019a4:	83 c4 10             	add    $0x10,%esp
801019a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019aa:	39 c6                	cmp    %eax,%esi
801019ac:	72 9a                	jb     80101948 <readi+0x58>
  }
  return n;
801019ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b4:	5b                   	pop    %ebx
801019b5:	5e                   	pop    %esi
801019b6:	5f                   	pop    %edi
801019b7:	5d                   	pop    %ebp
801019b8:	c3                   	ret
801019b9:	8d 76 00             	lea    0x0(%esi),%esi
    n = ip->size - off;
801019bc:	29 fa                	sub    %edi,%edx
801019be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019c1:	e9 77 ff ff ff       	jmp    8010193d <readi+0x4d>
801019c6:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019c8:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019cc:	66 83 f8 09          	cmp    $0x9,%ax
801019d0:	77 17                	ja     801019e9 <readi+0xf9>
801019d2:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
801019d9:	85 c0                	test   %eax,%eax
801019db:	74 0c                	je     801019e9 <readi+0xf9>
    return devsw[ip->major].read(ip, dst, n);
801019dd:	89 75 10             	mov    %esi,0x10(%ebp)
}
801019e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019e3:	5b                   	pop    %ebx
801019e4:	5e                   	pop    %esi
801019e5:	5f                   	pop    %edi
801019e6:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801019e7:	ff e0                	jmp    *%eax
      return -1;
801019e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ee:	eb c1                	jmp    801019b1 <readi+0xc1>

801019f0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ff:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a02:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a05:	8b 7d 10             	mov    0x10(%ebp),%edi
80101a08:	8b 75 14             	mov    0x14(%ebp),%esi
80101a0b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a0e:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a13:	0f 84 b7 00 00 00    	je     80101ad0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a1c:	39 78 58             	cmp    %edi,0x58(%eax)
80101a1f:	0f 82 e0 00 00 00    	jb     80101b05 <writei+0x115>
80101a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a28:	89 f2                	mov    %esi,%edx
80101a2a:	31 c0                	xor    %eax,%eax
80101a2c:	01 fa                	add    %edi,%edx
80101a2e:	0f 92 c0             	setb   %al
80101a31:	0f 82 ce 00 00 00    	jb     80101b05 <writei+0x115>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a37:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101a3d:	0f 87 c2 00 00 00    	ja     80101b05 <writei+0x115>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a43:	85 f6                	test   %esi,%esi
80101a45:	74 7c                	je     80101ac3 <writei+0xd3>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a47:	89 c6                	mov    %eax,%esi
80101a49:	89 7d e0             	mov    %edi,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101a4f:	89 da                	mov    %ebx,%edx
80101a51:	c1 ea 09             	shr    $0x9,%edx
80101a54:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a57:	89 f8                	mov    %edi,%eax
80101a59:	e8 d2 f8 ff ff       	call   80101330 <bmap>
80101a5e:	83 ec 08             	sub    $0x8,%esp
80101a61:	50                   	push   %eax
80101a62:	ff 37                	push   (%edi)
80101a64:	e8 4b e6 ff ff       	call   801000b4 <bread>
80101a69:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6b:	89 d8                	mov    %ebx,%eax
80101a6d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a72:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a75:	29 f1                	sub    %esi,%ecx
80101a77:	bb 00 02 00 00       	mov    $0x200,%ebx
80101a7c:	29 c3                	sub    %eax,%ebx
80101a7e:	83 c4 10             	add    $0x10,%esp
80101a81:	39 d9                	cmp    %ebx,%ecx
80101a83:	73 02                	jae    80101a87 <writei+0x97>
80101a85:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a87:	52                   	push   %edx
80101a88:	53                   	push   %ebx
80101a89:	ff 75 dc             	push   -0x24(%ebp)
80101a8c:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101a90:	50                   	push   %eax
80101a91:	e8 9e 28 00 00       	call   80104334 <memmove>
    log_write(bp);
80101a96:	89 3c 24             	mov    %edi,(%esp)
80101a99:	e8 da 10 00 00       	call   80102b78 <log_write>
    brelse(bp);
80101a9e:	89 3c 24             	mov    %edi,(%esp)
80101aa1:	e8 16 e7 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aa6:	01 de                	add    %ebx,%esi
80101aa8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aab:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aae:	83 c4 10             	add    $0x10,%esp
80101ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ab4:	39 c6                	cmp    %eax,%esi
80101ab6:	72 94                	jb     80101a4c <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
80101ab8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101abb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abe:	39 78 58             	cmp    %edi,0x58(%eax)
80101ac1:	72 31                	jb     80101af4 <writei+0x104>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac9:	5b                   	pop    %ebx
80101aca:	5e                   	pop    %esi
80101acb:	5f                   	pop    %edi
80101acc:	5d                   	pop    %ebp
80101acd:	c3                   	ret
80101ace:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 2b                	ja     80101b05 <writei+0x115>
80101ada:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 20                	je     80101b05 <writei+0x115>
    return devsw[ip->major].write(ip, src, n);
80101ae5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101aef:	ff e0                	jmp    *%eax
80101af1:	8d 76 00             	lea    0x0(%esi),%esi
    ip->size = off;
80101af4:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	50                   	push   %eax
80101afb:	e8 78 fa ff ff       	call   80101578 <iupdate>
80101b00:	83 c4 10             	add    $0x10,%esp
80101b03:	eb be                	jmp    80101ac3 <writei+0xd3>
      return -1;
80101b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b0a:	eb ba                	jmp    80101ac6 <writei+0xd6>

80101b0c <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b0c:	55                   	push   %ebp
80101b0d:	89 e5                	mov    %esp,%ebp
80101b0f:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b12:	6a 0e                	push   $0xe
80101b14:	ff 75 0c             	push   0xc(%ebp)
80101b17:	ff 75 08             	push   0x8(%ebp)
80101b1a:	e8 61 28 00 00       	call   80104380 <strncmp>
}
80101b1f:	c9                   	leave
80101b20:	c3                   	ret
80101b21:	8d 76 00             	lea    0x0(%esi),%esi

80101b24 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b24:	55                   	push   %ebp
80101b25:	89 e5                	mov    %esp,%ebp
80101b27:	57                   	push   %edi
80101b28:	56                   	push   %esi
80101b29:	53                   	push   %ebx
80101b2a:	83 ec 1c             	sub    $0x1c,%esp
80101b2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b35:	75 7d                	jne    80101bb4 <dirlookup+0x90>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b37:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101b3a:	85 c9                	test   %ecx,%ecx
80101b3c:	74 3d                	je     80101b7b <dirlookup+0x57>
80101b3e:	31 ff                	xor    %edi,%edi
80101b40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b43:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b44:	6a 10                	push   $0x10
80101b46:	57                   	push   %edi
80101b47:	56                   	push   %esi
80101b48:	53                   	push   %ebx
80101b49:	e8 a2 fd ff ff       	call   801018f0 <readi>
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	83 f8 10             	cmp    $0x10,%eax
80101b54:	75 51                	jne    80101ba7 <dirlookup+0x83>
      panic("dirlookup read");
    if(de.inum == 0)
80101b56:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b5b:	74 16                	je     80101b73 <dirlookup+0x4f>
  return strncmp(s, t, DIRSIZ);
80101b5d:	52                   	push   %edx
80101b5e:	6a 0e                	push   $0xe
80101b60:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b63:	50                   	push   %eax
80101b64:	ff 75 0c             	push   0xc(%ebp)
80101b67:	e8 14 28 00 00       	call   80104380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101b6c:	83 c4 10             	add    $0x10,%esp
80101b6f:	85 c0                	test   %eax,%eax
80101b71:	74 15                	je     80101b88 <dirlookup+0x64>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b73:	83 c7 10             	add    $0x10,%edi
80101b76:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101b79:	72 c9                	jb     80101b44 <dirlookup+0x20>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101b7b:	31 c0                	xor    %eax,%eax
}
80101b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101b88:	8b 45 10             	mov    0x10(%ebp),%eax
80101b8b:	85 c0                	test   %eax,%eax
80101b8d:	74 05                	je     80101b94 <dirlookup+0x70>
        *poff = off;
80101b8f:	8b 45 10             	mov    0x10(%ebp),%eax
80101b92:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101b94:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101b98:	8b 03                	mov    (%ebx),%eax
80101b9a:	e8 3d f6 ff ff       	call   801011dc <iget>
}
80101b9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba2:	5b                   	pop    %ebx
80101ba3:	5e                   	pop    %esi
80101ba4:	5f                   	pop    %edi
80101ba5:	5d                   	pop    %ebp
80101ba6:	c3                   	ret
      panic("dirlookup read");
80101ba7:	83 ec 0c             	sub    $0xc,%esp
80101baa:	68 a8 6b 10 80       	push   $0x80106ba8
80101baf:	e8 84 e7 ff ff       	call   80100338 <panic>
    panic("dirlookup not DIR");
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	68 96 6b 10 80       	push   $0x80106b96
80101bbc:	e8 77 e7 ff ff       	call   80100338 <panic>
80101bc1:	8d 76 00             	lea    0x0(%esi),%esi

80101bc4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101bc4:	55                   	push   %ebp
80101bc5:	89 e5                	mov    %esp,%ebp
80101bc7:	57                   	push   %edi
80101bc8:	56                   	push   %esi
80101bc9:	53                   	push   %ebx
80101bca:	83 ec 1c             	sub    $0x1c,%esp
80101bcd:	89 c3                	mov    %eax,%ebx
80101bcf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101bd2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101bd5:	80 38 2f             	cmpb   $0x2f,(%eax)
80101bd8:	0f 84 80 01 00 00    	je     80101d5e <namex+0x19a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101bde:	e8 15 19 00 00       	call   801034f8 <myproc>
80101be3:	8b b0 90 00 00 00    	mov    0x90(%eax),%esi
  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 f9 10 80       	push   $0x8010f960
80101bf1:	e8 f6 25 00 00       	call   801041ec <acquire>
  ip->ref++;
80101bf6:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101bf9:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101c00:	e8 87 25 00 00       	call   8010418c <release>
80101c05:	83 c4 10             	add    $0x10,%esp
80101c08:	eb 03                	jmp    80101c0d <namex+0x49>
80101c0a:	66 90                	xchg   %ax,%ax
    path++;
80101c0c:	43                   	inc    %ebx
  while(*path == '/')
80101c0d:	8a 03                	mov    (%ebx),%al
80101c0f:	3c 2f                	cmp    $0x2f,%al
80101c11:	74 f9                	je     80101c0c <namex+0x48>
  if(*path == 0)
80101c13:	84 c0                	test   %al,%al
80101c15:	0f 84 e9 00 00 00    	je     80101d04 <namex+0x140>
  while(*path != '/' && *path != 0)
80101c1b:	8a 03                	mov    (%ebx),%al
80101c1d:	89 df                	mov    %ebx,%edi
80101c1f:	3c 2f                	cmp    $0x2f,%al
80101c21:	75 0c                	jne    80101c2f <namex+0x6b>
80101c23:	e9 2f 01 00 00       	jmp    80101d57 <namex+0x193>
    path++;
80101c28:	47                   	inc    %edi
  while(*path != '/' && *path != 0)
80101c29:	8a 07                	mov    (%edi),%al
80101c2b:	3c 2f                	cmp    $0x2f,%al
80101c2d:	74 04                	je     80101c33 <namex+0x6f>
80101c2f:	84 c0                	test   %al,%al
80101c31:	75 f5                	jne    80101c28 <namex+0x64>
  len = path - s;
80101c33:	89 f8                	mov    %edi,%eax
80101c35:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101c37:	83 f8 0d             	cmp    $0xd,%eax
80101c3a:	0f 8e a0 00 00 00    	jle    80101ce0 <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101c40:	51                   	push   %ecx
80101c41:	6a 0e                	push   $0xe
80101c43:	53                   	push   %ebx
80101c44:	ff 75 e4             	push   -0x1c(%ebp)
80101c47:	e8 e8 26 00 00       	call   80104334 <memmove>
80101c4c:	83 c4 10             	add    $0x10,%esp
80101c4f:	89 fb                	mov    %edi,%ebx
  while(*path == '/')
80101c51:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101c54:	75 08                	jne    80101c5e <namex+0x9a>
80101c56:	66 90                	xchg   %ax,%ax
    path++;
80101c58:	43                   	inc    %ebx
  while(*path == '/')
80101c59:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101c5c:	74 fa                	je     80101c58 <namex+0x94>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
80101c61:	56                   	push   %esi
80101c62:	e8 b9 f9 ff ff       	call   80101620 <ilock>
    if(ip->type != T_DIR){
80101c67:	83 c4 10             	add    $0x10,%esp
80101c6a:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101c6f:	0f 85 a4 00 00 00    	jne    80101d19 <namex+0x155>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101c75:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c78:	85 c0                	test   %eax,%eax
80101c7a:	74 09                	je     80101c85 <namex+0xc1>
80101c7c:	80 3b 00             	cmpb   $0x0,(%ebx)
80101c7f:	0f 84 ef 00 00 00    	je     80101d74 <namex+0x1b0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101c85:	50                   	push   %eax
80101c86:	6a 00                	push   $0x0
80101c88:	ff 75 e4             	push   -0x1c(%ebp)
80101c8b:	56                   	push   %esi
80101c8c:	e8 93 fe ff ff       	call   80101b24 <dirlookup>
80101c91:	89 c7                	mov    %eax,%edi
80101c93:	83 c4 10             	add    $0x10,%esp
80101c96:	85 c0                	test   %eax,%eax
80101c98:	74 7f                	je     80101d19 <namex+0x155>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c9a:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101c9d:	83 ec 0c             	sub    $0xc,%esp
80101ca0:	51                   	push   %ecx
80101ca1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ca4:	e8 33 23 00 00       	call   80103fdc <holdingsleep>
80101ca9:	83 c4 10             	add    $0x10,%esp
80101cac:	85 c0                	test   %eax,%eax
80101cae:	0f 84 00 01 00 00    	je     80101db4 <namex+0x1f0>
80101cb4:	8b 46 08             	mov    0x8(%esi),%eax
80101cb7:	85 c0                	test   %eax,%eax
80101cb9:	0f 8e f5 00 00 00    	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101cbf:	83 ec 0c             	sub    $0xc,%esp
80101cc2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cc5:	51                   	push   %ecx
80101cc6:	e8 d5 22 00 00       	call   80103fa0 <releasesleep>
  iput(ip);
80101ccb:	89 34 24             	mov    %esi,(%esp)
80101cce:	e8 59 fa ff ff       	call   8010172c <iput>
80101cd3:	83 c4 10             	add    $0x10,%esp
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101cd6:	89 fe                	mov    %edi,%esi
  while(*path == '/')
80101cd8:	e9 30 ff ff ff       	jmp    80101c0d <namex+0x49>
80101cdd:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ce0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ce3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ce6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    memmove(name, s, len);
80101ce9:	52                   	push   %edx
80101cea:	50                   	push   %eax
80101ceb:	53                   	push   %ebx
80101cec:	ff 75 e4             	push   -0x1c(%ebp)
80101cef:	e8 40 26 00 00       	call   80104334 <memmove>
    name[len] = 0;
80101cf4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cf7:	c6 01 00             	movb   $0x0,(%ecx)
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	89 fb                	mov    %edi,%ebx
80101cff:	e9 4d ff ff ff       	jmp    80101c51 <namex+0x8d>
  }
  if(nameiparent){
80101d04:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101d07:	85 db                	test   %ebx,%ebx
80101d09:	0f 85 95 00 00 00    	jne    80101da4 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d0f:	89 f0                	mov    %esi,%eax
80101d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d14:	5b                   	pop    %ebx
80101d15:	5e                   	pop    %esi
80101d16:	5f                   	pop    %edi
80101d17:	5d                   	pop    %ebp
80101d18:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d19:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101d1c:	83 ec 0c             	sub    $0xc,%esp
80101d1f:	53                   	push   %ebx
80101d20:	e8 b7 22 00 00       	call   80103fdc <holdingsleep>
80101d25:	83 c4 10             	add    $0x10,%esp
80101d28:	85 c0                	test   %eax,%eax
80101d2a:	0f 84 84 00 00 00    	je     80101db4 <namex+0x1f0>
80101d30:	8b 46 08             	mov    0x8(%esi),%eax
80101d33:	85 c0                	test   %eax,%eax
80101d35:	7e 7d                	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101d37:	83 ec 0c             	sub    $0xc,%esp
80101d3a:	53                   	push   %ebx
80101d3b:	e8 60 22 00 00       	call   80103fa0 <releasesleep>
  iput(ip);
80101d40:	89 34 24             	mov    %esi,(%esp)
80101d43:	e8 e4 f9 ff ff       	call   8010172c <iput>
      return 0;
80101d48:	83 c4 10             	add    $0x10,%esp
      return 0;
80101d4b:	31 f6                	xor    %esi,%esi
}
80101d4d:	89 f0                	mov    %esi,%eax
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret
  while(*path != '/' && *path != 0)
80101d57:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d5a:	31 c0                	xor    %eax,%eax
80101d5c:	eb 88                	jmp    80101ce6 <namex+0x122>
    ip = iget(ROOTDEV, ROOTINO);
80101d5e:	ba 01 00 00 00       	mov    $0x1,%edx
80101d63:	b8 01 00 00 00       	mov    $0x1,%eax
80101d68:	e8 6f f4 ff ff       	call   801011dc <iget>
80101d6d:	89 c6                	mov    %eax,%esi
80101d6f:	e9 99 fe ff ff       	jmp    80101c0d <namex+0x49>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d74:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	53                   	push   %ebx
80101d7b:	e8 5c 22 00 00       	call   80103fdc <holdingsleep>
80101d80:	83 c4 10             	add    $0x10,%esp
80101d83:	85 c0                	test   %eax,%eax
80101d85:	74 2d                	je     80101db4 <namex+0x1f0>
80101d87:	8b 46 08             	mov    0x8(%esi),%eax
80101d8a:	85 c0                	test   %eax,%eax
80101d8c:	7e 26                	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	53                   	push   %ebx
80101d92:	e8 09 22 00 00       	call   80103fa0 <releasesleep>
}
80101d97:	83 c4 10             	add    $0x10,%esp
}
80101d9a:	89 f0                	mov    %esi,%eax
80101d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9f:	5b                   	pop    %ebx
80101da0:	5e                   	pop    %esi
80101da1:	5f                   	pop    %edi
80101da2:	5d                   	pop    %ebp
80101da3:	c3                   	ret
    iput(ip);
80101da4:	83 ec 0c             	sub    $0xc,%esp
80101da7:	56                   	push   %esi
80101da8:	e8 7f f9 ff ff       	call   8010172c <iput>
    return 0;
80101dad:	83 c4 10             	add    $0x10,%esp
      return 0;
80101db0:	31 f6                	xor    %esi,%esi
80101db2:	eb 99                	jmp    80101d4d <namex+0x189>
    panic("iunlock");
80101db4:	83 ec 0c             	sub    $0xc,%esp
80101db7:	68 8e 6b 10 80       	push   $0x80106b8e
80101dbc:	e8 77 e5 ff ff       	call   80100338 <panic>
80101dc1:	8d 76 00             	lea    0x0(%esi),%esi

80101dc4 <dirlink>:
{
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	57                   	push   %edi
80101dc8:	56                   	push   %esi
80101dc9:	53                   	push   %ebx
80101dca:	83 ec 20             	sub    $0x20,%esp
80101dcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dd0:	6a 00                	push   $0x0
80101dd2:	ff 75 0c             	push   0xc(%ebp)
80101dd5:	53                   	push   %ebx
80101dd6:	e8 49 fd ff ff       	call   80101b24 <dirlookup>
80101ddb:	83 c4 10             	add    $0x10,%esp
80101dde:	85 c0                	test   %eax,%eax
80101de0:	75 65                	jne    80101e47 <dirlink+0x83>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101de2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101de5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101de8:	85 ff                	test   %edi,%edi
80101dea:	74 29                	je     80101e15 <dirlink+0x51>
80101dec:	31 ff                	xor    %edi,%edi
80101dee:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101df1:	eb 09                	jmp    80101dfc <dirlink+0x38>
80101df3:	90                   	nop
80101df4:	83 c7 10             	add    $0x10,%edi
80101df7:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dfa:	73 19                	jae    80101e15 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dfc:	6a 10                	push   $0x10
80101dfe:	57                   	push   %edi
80101dff:	56                   	push   %esi
80101e00:	53                   	push   %ebx
80101e01:	e8 ea fa ff ff       	call   801018f0 <readi>
80101e06:	83 c4 10             	add    $0x10,%esp
80101e09:	83 f8 10             	cmp    $0x10,%eax
80101e0c:	75 4c                	jne    80101e5a <dirlink+0x96>
    if(de.inum == 0)
80101e0e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e13:	75 df                	jne    80101df4 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e15:	50                   	push   %eax
80101e16:	6a 0e                	push   $0xe
80101e18:	ff 75 0c             	push   0xc(%ebp)
80101e1b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e1e:	50                   	push   %eax
80101e1f:	e8 94 25 00 00       	call   801043b8 <strncpy>
  de.inum = inum;
80101e24:	8b 45 10             	mov    0x10(%ebp),%eax
80101e27:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e2b:	6a 10                	push   $0x10
80101e2d:	57                   	push   %edi
80101e2e:	56                   	push   %esi
80101e2f:	53                   	push   %ebx
80101e30:	e8 bb fb ff ff       	call   801019f0 <writei>
80101e35:	83 c4 20             	add    $0x20,%esp
80101e38:	83 f8 10             	cmp    $0x10,%eax
80101e3b:	75 2a                	jne    80101e67 <dirlink+0xa3>
  return 0;
80101e3d:	31 c0                	xor    %eax,%eax
}
80101e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e42:	5b                   	pop    %ebx
80101e43:	5e                   	pop    %esi
80101e44:	5f                   	pop    %edi
80101e45:	5d                   	pop    %ebp
80101e46:	c3                   	ret
    iput(ip);
80101e47:	83 ec 0c             	sub    $0xc,%esp
80101e4a:	50                   	push   %eax
80101e4b:	e8 dc f8 ff ff       	call   8010172c <iput>
    return -1;
80101e50:	83 c4 10             	add    $0x10,%esp
80101e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e58:	eb e5                	jmp    80101e3f <dirlink+0x7b>
      panic("dirlink read");
80101e5a:	83 ec 0c             	sub    $0xc,%esp
80101e5d:	68 b7 6b 10 80       	push   $0x80106bb7
80101e62:	e8 d1 e4 ff ff       	call   80100338 <panic>
    panic("dirlink");
80101e67:	83 ec 0c             	sub    $0xc,%esp
80101e6a:	68 22 6e 10 80       	push   $0x80106e22
80101e6f:	e8 c4 e4 ff ff       	call   80100338 <panic>

80101e74 <namei>:

struct inode*
namei(char *path)
{
80101e74:	55                   	push   %ebp
80101e75:	89 e5                	mov    %esp,%ebp
80101e77:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e7a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e7d:	31 d2                	xor    %edx,%edx
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	e8 3d fd ff ff       	call   80101bc4 <namex>
}
80101e87:	c9                   	leave
80101e88:	c3                   	ret
80101e89:	8d 76 00             	lea    0x0(%esi),%esi

80101e8c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101e8c:	55                   	push   %ebp
80101e8d:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e92:	ba 01 00 00 00       	mov    $0x1,%edx
80101e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e9a:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101e9b:	e9 24 fd ff ff       	jmp    80101bc4 <namex>

80101ea0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ea9:	85 c0                	test   %eax,%eax
80101eab:	0f 84 99 00 00 00    	je     80101f4a <idestart+0xaa>
80101eb1:	89 c3                	mov    %eax,%ebx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101eb3:	8b 70 08             	mov    0x8(%eax),%esi
80101eb6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101ebc:	77 7f                	ja     80101f3d <idestart+0x9d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ebe:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101ec3:	90                   	nop
80101ec4:	89 ca                	mov    %ecx,%edx
80101ec6:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ec7:	83 e0 c0             	and    $0xffffffc0,%eax
80101eca:	3c 40                	cmp    $0x40,%al
80101ecc:	75 f6                	jne    80101ec4 <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ece:	31 ff                	xor    %edi,%edi
80101ed0:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ed5:	89 f8                	mov    %edi,%eax
80101ed7:	ee                   	out    %al,(%dx)
80101ed8:	b0 01                	mov    $0x1,%al
80101eda:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101edf:	ee                   	out    %al,(%dx)
80101ee0:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101ee5:	89 f0                	mov    %esi,%eax
80101ee7:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ee8:	89 f0                	mov    %esi,%eax
80101eea:	c1 f8 08             	sar    $0x8,%eax
80101eed:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ef2:	ee                   	out    %al,(%dx)
80101ef3:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101ef8:	89 f8                	mov    %edi,%eax
80101efa:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101efb:	8a 43 04             	mov    0x4(%ebx),%al
80101efe:	c1 e0 04             	shl    $0x4,%eax
80101f01:	83 e0 10             	and    $0x10,%eax
80101f04:	83 c8 e0             	or     $0xffffffe0,%eax
80101f07:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f0c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f0d:	f6 03 04             	testb  $0x4,(%ebx)
80101f10:	75 0e                	jne    80101f20 <idestart+0x80>
80101f12:	b0 20                	mov    $0x20,%al
80101f14:	89 ca                	mov    %ecx,%edx
80101f16:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1a:	5b                   	pop    %ebx
80101f1b:	5e                   	pop    %esi
80101f1c:	5f                   	pop    %edi
80101f1d:	5d                   	pop    %ebp
80101f1e:	c3                   	ret
80101f1f:	90                   	nop
80101f20:	b0 30                	mov    $0x30,%al
80101f22:	89 ca                	mov    %ecx,%edx
80101f24:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101f25:	8d 73 5c             	lea    0x5c(%ebx),%esi
  asm volatile("cld; rep outsl" :
80101f28:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f2d:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f32:	fc                   	cld
80101f33:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f38:	5b                   	pop    %ebx
80101f39:	5e                   	pop    %esi
80101f3a:	5f                   	pop    %edi
80101f3b:	5d                   	pop    %ebp
80101f3c:	c3                   	ret
    panic("incorrect blockno");
80101f3d:	83 ec 0c             	sub    $0xc,%esp
80101f40:	68 cd 6b 10 80       	push   $0x80106bcd
80101f45:	e8 ee e3 ff ff       	call   80100338 <panic>
    panic("idestart");
80101f4a:	83 ec 0c             	sub    $0xc,%esp
80101f4d:	68 c4 6b 10 80       	push   $0x80106bc4
80101f52:	e8 e1 e3 ff ff       	call   80100338 <panic>
80101f57:	90                   	nop

80101f58 <ideinit>:
{
80101f58:	55                   	push   %ebp
80101f59:	89 e5                	mov    %esp,%ebp
80101f5b:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101f5e:	68 df 6b 10 80       	push   $0x80106bdf
80101f63:	68 00 16 11 80       	push   $0x80111600
80101f68:	e8 b7 20 00 00       	call   80104024 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101f6d:	58                   	pop    %eax
80101f6e:	5a                   	pop    %edx
80101f6f:	a1 84 17 11 80       	mov    0x80111784,%eax
80101f74:	48                   	dec    %eax
80101f75:	50                   	push   %eax
80101f76:	6a 0e                	push   $0xe
80101f78:	e8 53 02 00 00       	call   801021d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f7d:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f80:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f85:	8d 76 00             	lea    0x0(%esi),%esi
80101f88:	ec                   	in     (%dx),%al
80101f89:	83 e0 c0             	and    $0xffffffc0,%eax
80101f8c:	3c 40                	cmp    $0x40,%al
80101f8e:	75 f8                	jne    80101f88 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f90:	b0 f0                	mov    $0xf0,%al
80101f92:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f97:	ee                   	out    %al,(%dx)
80101f98:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f9d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa2:	eb 03                	jmp    80101fa7 <ideinit+0x4f>
  for(i=0; i<1000; i++){
80101fa4:	49                   	dec    %ecx
80101fa5:	74 0f                	je     80101fb6 <ideinit+0x5e>
80101fa7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101fa8:	84 c0                	test   %al,%al
80101faa:	74 f8                	je     80101fa4 <ideinit+0x4c>
      havedisk1 = 1;
80101fac:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101fb3:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fb6:	b0 e0                	mov    $0xe0,%al
80101fb8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fbd:	ee                   	out    %al,(%dx)
}
80101fbe:	c9                   	leave
80101fbf:	c3                   	ret

80101fc0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101fc9:	68 00 16 11 80       	push   $0x80111600
80101fce:	e8 19 22 00 00       	call   801041ec <acquire>

  if((b = idequeue) == 0){
80101fd3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101fd9:	83 c4 10             	add    $0x10,%esp
80101fdc:	85 db                	test   %ebx,%ebx
80101fde:	74 5b                	je     8010203b <ideintr+0x7b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101fe0:	8b 43 58             	mov    0x58(%ebx),%eax
80101fe3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101fe8:	8b 33                	mov    (%ebx),%esi
80101fea:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101ff0:	75 27                	jne    80102019 <ideintr+0x59>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ff7:	90                   	nop
80101ff8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff9:	88 c1                	mov    %al,%cl
80101ffb:	83 e1 c0             	and    $0xffffffc0,%ecx
80101ffe:	80 f9 40             	cmp    $0x40,%cl
80102001:	75 f5                	jne    80101ff8 <ideintr+0x38>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102003:	a8 21                	test   $0x21,%al
80102005:	75 12                	jne    80102019 <ideintr+0x59>
    insl(0x1f0, b->data, BSIZE/4);
80102007:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
8010200a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010200f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102014:	fc                   	cld
80102015:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102017:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102019:	83 e6 fb             	and    $0xfffffffb,%esi
8010201c:	83 ce 02             	or     $0x2,%esi
8010201f:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102021:	83 ec 0c             	sub    $0xc,%esp
80102024:	53                   	push   %ebx
80102025:	e8 9e 1b 00 00       	call   80103bc8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010202a:	a1 e4 15 11 80       	mov    0x801115e4,%eax
8010202f:	83 c4 10             	add    $0x10,%esp
80102032:	85 c0                	test   %eax,%eax
80102034:	74 05                	je     8010203b <ideintr+0x7b>
    idestart(idequeue);
80102036:	e8 65 fe ff ff       	call   80101ea0 <idestart>
    release(&idelock);
8010203b:	83 ec 0c             	sub    $0xc,%esp
8010203e:	68 00 16 11 80       	push   $0x80111600
80102043:	e8 44 21 00 00       	call   8010418c <release>

  release(&idelock);
}
80102048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010204b:	5b                   	pop    %ebx
8010204c:	5e                   	pop    %esi
8010204d:	5f                   	pop    %edi
8010204e:	5d                   	pop    %ebp
8010204f:	c3                   	ret

80102050 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	53                   	push   %ebx
80102054:	83 ec 10             	sub    $0x10,%esp
80102057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010205a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010205d:	50                   	push   %eax
8010205e:	e8 79 1f 00 00       	call   80103fdc <holdingsleep>
80102063:	83 c4 10             	add    $0x10,%esp
80102066:	85 c0                	test   %eax,%eax
80102068:	0f 84 b7 00 00 00    	je     80102125 <iderw+0xd5>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010206e:	8b 03                	mov    (%ebx),%eax
80102070:	83 e0 06             	and    $0x6,%eax
80102073:	83 f8 02             	cmp    $0x2,%eax
80102076:	0f 84 9c 00 00 00    	je     80102118 <iderw+0xc8>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010207c:	8b 53 04             	mov    0x4(%ebx),%edx
8010207f:	85 d2                	test   %edx,%edx
80102081:	74 09                	je     8010208c <iderw+0x3c>
80102083:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102088:	85 c0                	test   %eax,%eax
8010208a:	74 7f                	je     8010210b <iderw+0xbb>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010208c:	83 ec 0c             	sub    $0xc,%esp
8010208f:	68 00 16 11 80       	push   $0x80111600
80102094:	e8 53 21 00 00       	call   801041ec <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102099:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020a0:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801020a5:	83 c4 10             	add    $0x10,%esp
801020a8:	85 c0                	test   %eax,%eax
801020aa:	74 58                	je     80102104 <iderw+0xb4>
801020ac:	89 c2                	mov    %eax,%edx
801020ae:	8b 40 58             	mov    0x58(%eax),%eax
801020b1:	85 c0                	test   %eax,%eax
801020b3:	75 f7                	jne    801020ac <iderw+0x5c>
801020b5:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801020b8:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801020ba:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801020c0:	74 36                	je     801020f8 <iderw+0xa8>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020c2:	8b 03                	mov    (%ebx),%eax
801020c4:	83 e0 06             	and    $0x6,%eax
801020c7:	83 f8 02             	cmp    $0x2,%eax
801020ca:	74 1b                	je     801020e7 <iderw+0x97>
    sleep(b, &idelock);
801020cc:	83 ec 08             	sub    $0x8,%esp
801020cf:	68 00 16 11 80       	push   $0x80111600
801020d4:	53                   	push   %ebx
801020d5:	e8 32 1a 00 00       	call   80103b0c <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020da:	8b 03                	mov    (%ebx),%eax
801020dc:	83 e0 06             	and    $0x6,%eax
801020df:	83 c4 10             	add    $0x10,%esp
801020e2:	83 f8 02             	cmp    $0x2,%eax
801020e5:	75 e5                	jne    801020cc <iderw+0x7c>
  }


  release(&idelock);
801020e7:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801020ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020f1:	c9                   	leave
  release(&idelock);
801020f2:	e9 95 20 00 00       	jmp    8010418c <release>
801020f7:	90                   	nop
    idestart(b);
801020f8:	89 d8                	mov    %ebx,%eax
801020fa:	e8 a1 fd ff ff       	call   80101ea0 <idestart>
801020ff:	eb c1                	jmp    801020c2 <iderw+0x72>
80102101:	8d 76 00             	lea    0x0(%esi),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102104:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102109:	eb ad                	jmp    801020b8 <iderw+0x68>
    panic("iderw: ide disk 1 not present");
8010210b:	83 ec 0c             	sub    $0xc,%esp
8010210e:	68 0e 6c 10 80       	push   $0x80106c0e
80102113:	e8 20 e2 ff ff       	call   80100338 <panic>
    panic("iderw: nothing to do");
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	68 f9 6b 10 80       	push   $0x80106bf9
80102120:	e8 13 e2 ff ff       	call   80100338 <panic>
    panic("iderw: buf not locked");
80102125:	83 ec 0c             	sub    $0xc,%esp
80102128:	68 e3 6b 10 80       	push   $0x80106be3
8010212d:	e8 06 e2 ff ff       	call   80100338 <panic>
80102132:	66 90                	xchg   %ax,%ax

80102134 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102134:	55                   	push   %ebp
80102135:	89 e5                	mov    %esp,%ebp
80102137:	56                   	push   %esi
80102138:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102139:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102140:	00 c0 fe 
  ioapic->reg = reg;
80102143:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010214a:	00 00 00 
  return ioapic->data;
8010214d:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80102153:	8b 72 10             	mov    0x10(%edx),%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102156:	c1 ee 10             	shr    $0x10,%esi
80102159:	89 f0                	mov    %esi,%eax
8010215b:	0f b6 f0             	movzbl %al,%esi
  ioapic->reg = reg;
8010215e:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102164:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010216a:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010216d:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  id = ioapicread(REG_ID) >> 24;
80102174:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102177:	39 c2                	cmp    %eax,%edx
80102179:	74 16                	je     80102191 <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010217b:	83 ec 0c             	sub    $0xc,%esp
8010217e:	68 d8 6f 10 80       	push   $0x80106fd8
80102183:	e8 98 e4 ff ff       	call   80100620 <cprintf>
  ioapic->reg = reg;
80102188:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010218e:	83 c4 10             	add    $0x10,%esp
{
80102191:	ba 10 00 00 00       	mov    $0x10,%edx
80102196:	31 c0                	xor    %eax,%eax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102198:	8d 48 20             	lea    0x20(%eax),%ecx
8010219b:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
801021a1:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801021a3:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801021a9:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801021ac:	8d 4a 01             	lea    0x1(%edx),%ecx
801021af:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801021b1:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801021b7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801021be:	40                   	inc    %eax
801021bf:	83 c2 02             	add    $0x2,%edx
801021c2:	39 c6                	cmp    %eax,%esi
801021c4:	7d d2                	jge    80102198 <ioapicinit+0x64>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801021c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021c9:	5b                   	pop    %ebx
801021ca:	5e                   	pop    %esi
801021cb:	5d                   	pop    %ebp
801021cc:	c3                   	ret
801021cd:	8d 76 00             	lea    0x0(%esi),%esi

801021d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801021d6:	8d 50 20             	lea    0x20(%eax),%edx
801021d9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801021dd:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801021e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021e5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801021eb:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801021f1:	c1 e2 18             	shl    $0x18,%edx
801021f4:	40                   	inc    %eax
  ioapic->reg = reg;
801021f5:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021f7:	a1 34 16 11 80       	mov    0x80111634,%eax
801021fc:	89 50 10             	mov    %edx,0x10(%eax)
}
801021ff:	5d                   	pop    %ebp
80102200:	c3                   	ret
80102201:	66 90                	xchg   %ax,%ax
80102203:	90                   	nop

80102204 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	53                   	push   %ebx
80102208:	53                   	push   %ebx
80102209:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010220c:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102212:	75 70                	jne    80102284 <kfree+0x80>
80102214:	81 fb d0 5e 11 80    	cmp    $0x80115ed0,%ebx
8010221a:	72 68                	jb     80102284 <kfree+0x80>
8010221c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102222:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102227:	77 5b                	ja     80102284 <kfree+0x80>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102229:	52                   	push   %edx
8010222a:	68 00 10 00 00       	push   $0x1000
8010222f:	6a 01                	push   $0x1
80102231:	53                   	push   %ebx
80102232:	e8 81 20 00 00       	call   801042b8 <memset>

  if(kmem.use_lock)
80102237:	83 c4 10             	add    $0x10,%esp
8010223a:	8b 0d 74 16 11 80    	mov    0x80111674,%ecx
80102240:	85 c9                	test   %ecx,%ecx
80102242:	75 1c                	jne    80102260 <kfree+0x5c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102244:	a1 78 16 11 80       	mov    0x80111678,%eax
80102249:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
8010224b:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102251:	a1 74 16 11 80       	mov    0x80111674,%eax
80102256:	85 c0                	test   %eax,%eax
80102258:	75 1a                	jne    80102274 <kfree+0x70>
    release(&kmem.lock);
}
8010225a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010225d:	c9                   	leave
8010225e:	c3                   	ret
8010225f:	90                   	nop
    acquire(&kmem.lock);
80102260:	83 ec 0c             	sub    $0xc,%esp
80102263:	68 40 16 11 80       	push   $0x80111640
80102268:	e8 7f 1f 00 00       	call   801041ec <acquire>
8010226d:	83 c4 10             	add    $0x10,%esp
80102270:	eb d2                	jmp    80102244 <kfree+0x40>
80102272:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102274:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010227b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010227e:	c9                   	leave
    release(&kmem.lock);
8010227f:	e9 08 1f 00 00       	jmp    8010418c <release>
    panic("kfree");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 2c 6c 10 80       	push   $0x80106c2c
8010228c:	e8 a7 e0 ff ff       	call   80100338 <panic>
80102291:	8d 76 00             	lea    0x0(%esi),%esi

80102294 <freerange>:
{
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	56                   	push   %esi
80102298:	53                   	push   %ebx
80102299:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010229c:	8b 45 08             	mov    0x8(%ebp),%eax
8010229f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022a5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022b1:	39 de                	cmp    %ebx,%esi
801022b3:	72 1f                	jb     801022d4 <freerange+0x40>
801022b5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801022b8:	83 ec 0c             	sub    $0xc,%esp
801022bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801022c1:	50                   	push   %eax
801022c2:	e8 3d ff ff ff       	call   80102204 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022cd:	83 c4 10             	add    $0x10,%esp
801022d0:	39 de                	cmp    %ebx,%esi
801022d2:	73 e4                	jae    801022b8 <freerange+0x24>
}
801022d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d7:	5b                   	pop    %ebx
801022d8:	5e                   	pop    %esi
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret
801022db:	90                   	nop

801022dc <kinit2>:
{
801022dc:	55                   	push   %ebp
801022dd:	89 e5                	mov    %esp,%ebp
801022df:	56                   	push   %esi
801022e0:	53                   	push   %ebx
801022e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801022e4:	8b 45 08             	mov    0x8(%ebp),%eax
801022e7:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022ed:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022f9:	39 de                	cmp    %ebx,%esi
801022fb:	72 1f                	jb     8010231c <kinit2+0x40>
801022fd:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102309:	50                   	push   %eax
8010230a:	e8 f5 fe ff ff       	call   80102204 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010230f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102315:	83 c4 10             	add    $0x10,%esp
80102318:	39 de                	cmp    %ebx,%esi
8010231a:	73 e4                	jae    80102300 <kinit2+0x24>
  kmem.use_lock = 1;
8010231c:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
80102323:	00 00 00 
}
80102326:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102329:	5b                   	pop    %ebx
8010232a:	5e                   	pop    %esi
8010232b:	5d                   	pop    %ebp
8010232c:	c3                   	ret
8010232d:	8d 76 00             	lea    0x0(%esi),%esi

80102330 <kinit1>:
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	56                   	push   %esi
80102334:	53                   	push   %ebx
80102335:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102338:	83 ec 08             	sub    $0x8,%esp
8010233b:	68 32 6c 10 80       	push   $0x80106c32
80102340:	68 40 16 11 80       	push   $0x80111640
80102345:	e8 da 1c 00 00       	call   80104024 <initlock>
  kmem.use_lock = 0;
8010234a:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102351:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102354:	8b 45 08             	mov    0x8(%ebp),%eax
80102357:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010235d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102363:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	39 de                	cmp    %ebx,%esi
8010236e:	72 1c                	jb     8010238c <kinit1+0x5c>
    kfree(p);
80102370:	83 ec 0c             	sub    $0xc,%esp
80102373:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102379:	50                   	push   %eax
8010237a:	e8 85 fe ff ff       	call   80102204 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010237f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102385:	83 c4 10             	add    $0x10,%esp
80102388:	39 de                	cmp    %ebx,%esi
8010238a:	73 e4                	jae    80102370 <kinit1+0x40>
}
8010238c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010238f:	5b                   	pop    %ebx
80102390:	5e                   	pop    %esi
80102391:	5d                   	pop    %ebp
80102392:	c3                   	ret
80102393:	90                   	nop

80102394 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102394:	a1 74 16 11 80       	mov    0x80111674,%eax
80102399:	85 c0                	test   %eax,%eax
8010239b:	75 17                	jne    801023b4 <kalloc+0x20>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010239d:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
801023a2:	85 c0                	test   %eax,%eax
801023a4:	74 0a                	je     801023b0 <kalloc+0x1c>
    kmem.freelist = r->next;
801023a6:	8b 10                	mov    (%eax),%edx
801023a8:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801023ae:	c3                   	ret
801023af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801023b0:	c3                   	ret
801023b1:	8d 76 00             	lea    0x0(%esi),%esi
{
801023b4:	55                   	push   %ebp
801023b5:	89 e5                	mov    %esp,%ebp
801023b7:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801023ba:	68 40 16 11 80       	push   $0x80111640
801023bf:	e8 28 1e 00 00       	call   801041ec <acquire>
  r = kmem.freelist;
801023c4:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801023c9:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801023cf:	83 c4 10             	add    $0x10,%esp
801023d2:	85 c0                	test   %eax,%eax
801023d4:	74 08                	je     801023de <kalloc+0x4a>
    kmem.freelist = r->next;
801023d6:	8b 08                	mov    (%eax),%ecx
801023d8:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801023de:	85 d2                	test   %edx,%edx
801023e0:	74 16                	je     801023f8 <kalloc+0x64>
801023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&kmem.lock);
801023e5:	83 ec 0c             	sub    $0xc,%esp
801023e8:	68 40 16 11 80       	push   $0x80111640
801023ed:	e8 9a 1d 00 00       	call   8010418c <release>
801023f2:	83 c4 10             	add    $0x10,%esp
801023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023f8:	c9                   	leave
801023f9:	c3                   	ret
801023fa:	66 90                	xchg   %ax,%ax

801023fc <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023fc:	ba 64 00 00 00       	mov    $0x64,%edx
80102401:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102402:	a8 01                	test   $0x1,%al
80102404:	0f 84 ae 00 00 00    	je     801024b8 <kbdgetc+0xbc>
{
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	53                   	push   %ebx
8010240e:	ba 60 00 00 00       	mov    $0x60,%edx
80102413:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102414:	0f b6 d8             	movzbl %al,%ebx

  if(data == 0xE0){
    shift |= E0ESC;
80102417:	8b 0d 7c 16 11 80    	mov    0x8011167c,%ecx
  if(data == 0xE0){
8010241d:	3c e0                	cmp    $0xe0,%al
8010241f:	74 5b                	je     8010247c <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102421:	89 ca                	mov    %ecx,%edx
80102423:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102426:	84 c0                	test   %al,%al
80102428:	78 62                	js     8010248c <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010242a:	85 d2                	test   %edx,%edx
8010242c:	74 09                	je     80102437 <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010242e:	83 c8 80             	or     $0xffffff80,%eax
80102431:	0f b6 d8             	movzbl %al,%ebx
    shift &= ~E0ESC;
80102434:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
80102437:	0f b6 93 20 72 10 80 	movzbl -0x7fef8de0(%ebx),%edx
8010243e:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
80102440:	0f b6 83 20 71 10 80 	movzbl -0x7fef8ee0(%ebx),%eax
80102447:	31 c2                	xor    %eax,%edx
80102449:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
8010244f:	89 d0                	mov    %edx,%eax
80102451:	83 e0 03             	and    $0x3,%eax
80102454:	8b 04 85 00 71 10 80 	mov    -0x7fef8f00(,%eax,4),%eax
8010245b:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
  if(shift & CAPSLOCK){
8010245f:	83 e2 08             	and    $0x8,%edx
80102462:	74 13                	je     80102477 <kbdgetc+0x7b>
    if('a' <= c && c <= 'z')
80102464:	8d 50 9f             	lea    -0x61(%eax),%edx
80102467:	83 fa 19             	cmp    $0x19,%edx
8010246a:	76 44                	jbe    801024b0 <kbdgetc+0xb4>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
8010246c:	8d 50 bf             	lea    -0x41(%eax),%edx
8010246f:	83 fa 19             	cmp    $0x19,%edx
80102472:	77 03                	ja     80102477 <kbdgetc+0x7b>
      c += 'a' - 'A';
80102474:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
80102477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010247a:	c9                   	leave
8010247b:	c3                   	ret
    shift |= E0ESC;
8010247c:	83 c9 40             	or     $0x40,%ecx
8010247f:	89 0d 7c 16 11 80    	mov    %ecx,0x8011167c
    return 0;
80102485:	31 c0                	xor    %eax,%eax
}
80102487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010248a:	c9                   	leave
8010248b:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
8010248c:	85 d2                	test   %edx,%edx
8010248e:	75 05                	jne    80102495 <kbdgetc+0x99>
80102490:	89 c3                	mov    %eax,%ebx
80102492:	83 e3 7f             	and    $0x7f,%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102495:	8a 83 20 72 10 80    	mov    -0x7fef8de0(%ebx),%al
8010249b:	83 c8 40             	or     $0x40,%eax
8010249e:	0f b6 c0             	movzbl %al,%eax
801024a1:	f7 d0                	not    %eax
801024a3:	21 c8                	and    %ecx,%eax
801024a5:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801024aa:	31 c0                	xor    %eax,%eax
801024ac:	eb d9                	jmp    80102487 <kbdgetc+0x8b>
801024ae:	66 90                	xchg   %ax,%ax
      c += 'A' - 'a';
801024b0:	83 e8 20             	sub    $0x20,%eax
}
801024b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024b6:	c9                   	leave
801024b7:	c3                   	ret
    return -1;
801024b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801024bd:	c3                   	ret
801024be:	66 90                	xchg   %ax,%ax

801024c0 <kbdintr>:

void
kbdintr(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801024c6:	68 fc 23 10 80       	push   $0x801023fc
801024cb:	e8 18 e3 ff ff       	call   801007e8 <consoleintr>
}
801024d0:	83 c4 10             	add    $0x10,%esp
801024d3:	c9                   	leave
801024d4:	c3                   	ret
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	90                   	nop

801024d8 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801024d8:	a1 80 16 11 80       	mov    0x80111680,%eax
801024dd:	85 c0                	test   %eax,%eax
801024df:	0f 84 bf 00 00 00    	je     801025a4 <lapicinit+0xcc>
  lapic[index] = value;
801024e5:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801024ec:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024f2:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801024f9:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024ff:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102506:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102509:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010250c:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102513:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102516:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102519:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102520:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102523:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102526:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
8010252d:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102530:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102533:	8b 50 30             	mov    0x30(%eax),%edx
80102536:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
8010253c:	75 6a                	jne    801025a8 <lapicinit+0xd0>
  lapic[index] = value;
8010253e:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102545:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102548:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010254b:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102552:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102555:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102558:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010255f:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102562:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102565:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010256c:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010256f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102572:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102579:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010257c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010257f:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102586:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102589:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
8010258c:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102592:	80 e6 10             	and    $0x10,%dh
80102595:	75 f5                	jne    8010258c <lapicinit+0xb4>
  lapic[index] = value;
80102597:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010259e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025a1:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801025a4:	c3                   	ret
801025a5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
801025a8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801025af:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025b2:	8b 50 20             	mov    0x20(%eax),%edx
}
801025b5:	eb 87                	jmp    8010253e <lapicinit+0x66>
801025b7:	90                   	nop

801025b8 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801025b8:	a1 80 16 11 80       	mov    0x80111680,%eax
801025bd:	85 c0                	test   %eax,%eax
801025bf:	74 07                	je     801025c8 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801025c1:	8b 40 20             	mov    0x20(%eax),%eax
801025c4:	c1 e8 18             	shr    $0x18,%eax
801025c7:	c3                   	ret
801025c8:	31 c0                	xor    %eax,%eax
}
801025ca:	c3                   	ret
801025cb:	90                   	nop

801025cc <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801025cc:	a1 80 16 11 80       	mov    0x80111680,%eax
801025d1:	85 c0                	test   %eax,%eax
801025d3:	74 0d                	je     801025e2 <lapiceoi+0x16>
  lapic[index] = value;
801025d5:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801025dc:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025df:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801025e2:	c3                   	ret
801025e3:	90                   	nop

801025e4 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801025e4:	c3                   	ret
801025e5:	8d 76 00             	lea    0x0(%esi),%esi

801025e8 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801025e8:	55                   	push   %ebp
801025e9:	89 e5                	mov    %esp,%ebp
801025eb:	53                   	push   %ebx
801025ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f2:	b0 0f                	mov    $0xf,%al
801025f4:	ba 70 00 00 00       	mov    $0x70,%edx
801025f9:	ee                   	out    %al,(%dx)
801025fa:	b0 0a                	mov    $0xa,%al
801025fc:	ba 71 00 00 00       	mov    $0x71,%edx
80102601:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102602:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102609:	00 00 
  wrv[1] = addr >> 4;
8010260b:	89 c8                	mov    %ecx,%eax
8010260d:	c1 e8 04             	shr    $0x4,%eax
80102610:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102616:	a1 80 16 11 80       	mov    0x80111680,%eax
8010261b:	c1 e3 18             	shl    $0x18,%ebx
8010261e:	89 da                	mov    %ebx,%edx
80102620:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102626:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102629:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102630:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102633:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102636:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
8010263d:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102640:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102643:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102649:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010264c:	c1 e9 0c             	shr    $0xc,%ecx
8010264f:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
80102652:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102658:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010265b:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102661:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102664:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010266d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102670:	c9                   	leave
80102671:	c3                   	ret
80102672:	66 90                	xchg   %ax,%ax

80102674 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102674:	55                   	push   %ebp
80102675:	89 e5                	mov    %esp,%ebp
80102677:	57                   	push   %edi
80102678:	56                   	push   %esi
80102679:	53                   	push   %ebx
8010267a:	83 ec 4c             	sub    $0x4c,%esp
8010267d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102680:	b0 0b                	mov    $0xb,%al
80102682:	ba 70 00 00 00       	mov    $0x70,%edx
80102687:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102688:	ba 71 00 00 00       	mov    $0x71,%edx
8010268d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010268e:	83 e0 04             	and    $0x4,%eax
80102691:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102693:	89 df                	mov    %ebx,%edi
80102695:	8d 76 00             	lea    0x0(%esi),%esi
80102698:	31 c0                	xor    %eax,%eax
8010269a:	ba 70 00 00 00       	mov    $0x70,%edx
8010269f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a0:	bb 71 00 00 00       	mov    $0x71,%ebx
801026a5:	89 da                	mov    %ebx,%edx
801026a7:	ec                   	in     (%dx),%al
801026a8:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ab:	b0 02                	mov    $0x2,%al
801026ad:	ba 70 00 00 00       	mov    $0x70,%edx
801026b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b3:	89 da                	mov    %ebx,%edx
801026b5:	ec                   	in     (%dx),%al
801026b6:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b9:	b0 04                	mov    $0x4,%al
801026bb:	ba 70 00 00 00       	mov    $0x70,%edx
801026c0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c1:	89 da                	mov    %ebx,%edx
801026c3:	ec                   	in     (%dx),%al
801026c4:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026c7:	b0 07                	mov    $0x7,%al
801026c9:	ba 70 00 00 00       	mov    $0x70,%edx
801026ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026cf:	89 da                	mov    %ebx,%edx
801026d1:	ec                   	in     (%dx),%al
801026d2:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026d5:	b0 08                	mov    $0x8,%al
801026d7:	ba 70 00 00 00       	mov    $0x70,%edx
801026dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026dd:	89 da                	mov    %ebx,%edx
801026df:	ec                   	in     (%dx),%al
801026e0:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026e3:	b0 09                	mov    $0x9,%al
801026e5:	ba 70 00 00 00       	mov    $0x70,%edx
801026ea:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026eb:	89 da                	mov    %ebx,%edx
801026ed:	ec                   	in     (%dx),%al
801026ee:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026f1:	b0 0a                	mov    $0xa,%al
801026f3:	ba 70 00 00 00       	mov    $0x70,%edx
801026f8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f9:	89 da                	mov    %ebx,%edx
801026fb:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801026fc:	84 c0                	test   %al,%al
801026fe:	78 98                	js     80102698 <cmostime+0x24>
  return inb(CMOS_RETURN);
80102700:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102704:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102707:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010270b:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010270e:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102712:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102715:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102719:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010271c:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
80102720:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102723:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102726:	31 c0                	xor    %eax,%eax
80102728:	ba 70 00 00 00       	mov    $0x70,%edx
8010272d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010272e:	89 da                	mov    %ebx,%edx
80102730:	ec                   	in     (%dx),%al
80102731:	0f b6 c0             	movzbl %al,%eax
80102734:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102737:	b0 02                	mov    $0x2,%al
80102739:	ba 70 00 00 00       	mov    $0x70,%edx
8010273e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010273f:	89 da                	mov    %ebx,%edx
80102741:	ec                   	in     (%dx),%al
80102742:	0f b6 c0             	movzbl %al,%eax
80102745:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102748:	b0 04                	mov    $0x4,%al
8010274a:	ba 70 00 00 00       	mov    $0x70,%edx
8010274f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	89 da                	mov    %ebx,%edx
80102752:	ec                   	in     (%dx),%al
80102753:	0f b6 c0             	movzbl %al,%eax
80102756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102759:	b0 07                	mov    $0x7,%al
8010275b:	ba 70 00 00 00       	mov    $0x70,%edx
80102760:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102761:	89 da                	mov    %ebx,%edx
80102763:	ec                   	in     (%dx),%al
80102764:	0f b6 c0             	movzbl %al,%eax
80102767:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010276a:	b0 08                	mov    $0x8,%al
8010276c:	ba 70 00 00 00       	mov    $0x70,%edx
80102771:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102772:	89 da                	mov    %ebx,%edx
80102774:	ec                   	in     (%dx),%al
80102775:	0f b6 c0             	movzbl %al,%eax
80102778:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010277b:	b0 09                	mov    $0x9,%al
8010277d:	ba 70 00 00 00       	mov    $0x70,%edx
80102782:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102783:	89 da                	mov    %ebx,%edx
80102785:	ec                   	in     (%dx),%al
80102786:	0f b6 c0             	movzbl %al,%eax
80102789:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010278c:	50                   	push   %eax
8010278d:	6a 18                	push   $0x18
8010278f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102792:	50                   	push   %eax
80102793:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102796:	50                   	push   %eax
80102797:	e8 60 1b 00 00       	call   801042fc <memcmp>
8010279c:	83 c4 10             	add    $0x10,%esp
8010279f:	85 c0                	test   %eax,%eax
801027a1:	0f 85 f1 fe ff ff    	jne    80102698 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
801027a7:	89 fb                	mov    %edi,%ebx
801027a9:	89 f0                	mov    %esi,%eax
801027ab:	84 c0                	test   %al,%al
801027ad:	75 7e                	jne    8010282d <cmostime+0x1b9>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801027af:	8b 55 b8             	mov    -0x48(%ebp),%edx
801027b2:	89 d0                	mov    %edx,%eax
801027b4:	c1 e8 04             	shr    $0x4,%eax
801027b7:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027ba:	01 c0                	add    %eax,%eax
801027bc:	83 e2 0f             	and    $0xf,%edx
801027bf:	01 d0                	add    %edx,%eax
801027c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801027c4:	8b 55 bc             	mov    -0x44(%ebp),%edx
801027c7:	89 d0                	mov    %edx,%eax
801027c9:	c1 e8 04             	shr    $0x4,%eax
801027cc:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027cf:	01 c0                	add    %eax,%eax
801027d1:	83 e2 0f             	and    $0xf,%edx
801027d4:	01 d0                	add    %edx,%eax
801027d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801027d9:	8b 55 c0             	mov    -0x40(%ebp),%edx
801027dc:	89 d0                	mov    %edx,%eax
801027de:	c1 e8 04             	shr    $0x4,%eax
801027e1:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027e4:	01 c0                	add    %eax,%eax
801027e6:	83 e2 0f             	and    $0xf,%edx
801027e9:	01 d0                	add    %edx,%eax
801027eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801027ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801027f1:	89 d0                	mov    %edx,%eax
801027f3:	c1 e8 04             	shr    $0x4,%eax
801027f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027f9:	01 c0                	add    %eax,%eax
801027fb:	83 e2 0f             	and    $0xf,%edx
801027fe:	01 d0                	add    %edx,%eax
80102800:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102803:	8b 55 c8             	mov    -0x38(%ebp),%edx
80102806:	89 d0                	mov    %edx,%eax
80102808:	c1 e8 04             	shr    $0x4,%eax
8010280b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010280e:	01 c0                	add    %eax,%eax
80102810:	83 e2 0f             	and    $0xf,%edx
80102813:	01 d0                	add    %edx,%eax
80102815:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102818:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010281b:	89 d0                	mov    %edx,%eax
8010281d:	c1 e8 04             	shr    $0x4,%eax
80102820:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102823:	01 c0                	add    %eax,%eax
80102825:	83 e2 0f             	and    $0xf,%edx
80102828:	01 d0                	add    %edx,%eax
8010282a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010282d:	b9 06 00 00 00       	mov    $0x6,%ecx
80102832:	89 df                	mov    %ebx,%edi
80102834:	8d 75 b8             	lea    -0x48(%ebp),%esi
80102837:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102839:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102843:	5b                   	pop    %ebx
80102844:	5e                   	pop    %esi
80102845:	5f                   	pop    %edi
80102846:	5d                   	pop    %ebp
80102847:	c3                   	ret

80102848 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102848:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
8010284e:	85 c9                	test   %ecx,%ecx
80102850:	7e 7e                	jle    801028d0 <install_trans+0x88>
{
80102852:	55                   	push   %ebp
80102853:	89 e5                	mov    %esp,%ebp
80102855:	57                   	push   %edi
80102856:	56                   	push   %esi
80102857:	53                   	push   %ebx
80102858:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010285b:	31 ff                	xor    %edi,%edi
8010285d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102868:	01 f8                	add    %edi,%eax
8010286a:	40                   	inc    %eax
8010286b:	50                   	push   %eax
8010286c:	ff 35 e4 16 11 80    	push   0x801116e4
80102872:	e8 3d d8 ff ff       	call   801000b4 <bread>
80102877:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102879:	58                   	pop    %eax
8010287a:	5a                   	pop    %edx
8010287b:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102882:	ff 35 e4 16 11 80    	push   0x801116e4
80102888:	e8 27 d8 ff ff       	call   801000b4 <bread>
8010288d:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010288f:	83 c4 0c             	add    $0xc,%esp
80102892:	68 00 02 00 00       	push   $0x200
80102897:	8d 46 5c             	lea    0x5c(%esi),%eax
8010289a:	50                   	push   %eax
8010289b:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010289e:	50                   	push   %eax
8010289f:	e8 90 1a 00 00       	call   80104334 <memmove>
    bwrite(dbuf);  // write dst to disk
801028a4:	89 1c 24             	mov    %ebx,(%esp)
801028a7:	e8 d8 d8 ff ff       	call   80100184 <bwrite>
    brelse(lbuf);
801028ac:	89 34 24             	mov    %esi,(%esp)
801028af:	e8 08 d9 ff ff       	call   801001bc <brelse>
    brelse(dbuf);
801028b4:	89 1c 24             	mov    %ebx,(%esp)
801028b7:	e8 00 d9 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801028bc:	47                   	inc    %edi
801028bd:	83 c4 10             	add    $0x10,%esp
801028c0:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
801028c6:	7f 98                	jg     80102860 <install_trans+0x18>
  }
}
801028c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028cb:	5b                   	pop    %ebx
801028cc:	5e                   	pop    %esi
801028cd:	5f                   	pop    %edi
801028ce:	5d                   	pop    %ebp
801028cf:	c3                   	ret
801028d0:	c3                   	ret
801028d1:	8d 76 00             	lea    0x0(%esi),%esi

801028d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801028d4:	55                   	push   %ebp
801028d5:	89 e5                	mov    %esp,%ebp
801028d7:	53                   	push   %ebx
801028d8:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801028db:	ff 35 d4 16 11 80    	push   0x801116d4
801028e1:	ff 35 e4 16 11 80    	push   0x801116e4
801028e7:	e8 c8 d7 ff ff       	call   801000b4 <bread>
801028ec:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801028ee:	a1 e8 16 11 80       	mov    0x801116e8,%eax
801028f3:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801028f6:	83 c4 10             	add    $0x10,%esp
801028f9:	85 c0                	test   %eax,%eax
801028fb:	7e 13                	jle    80102910 <write_head+0x3c>
801028fd:	31 d2                	xor    %edx,%edx
801028ff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102900:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102907:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010290b:	42                   	inc    %edx
8010290c:	39 d0                	cmp    %edx,%eax
8010290e:	75 f0                	jne    80102900 <write_head+0x2c>
  }
  bwrite(buf);
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	53                   	push   %ebx
80102914:	e8 6b d8 ff ff       	call   80100184 <bwrite>
  brelse(buf);
80102919:	89 1c 24             	mov    %ebx,(%esp)
8010291c:	e8 9b d8 ff ff       	call   801001bc <brelse>
}
80102921:	83 c4 10             	add    $0x10,%esp
80102924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102927:	c9                   	leave
80102928:	c3                   	ret
80102929:	8d 76 00             	lea    0x0(%esi),%esi

8010292c <initlog>:
{
8010292c:	55                   	push   %ebp
8010292d:	89 e5                	mov    %esp,%ebp
8010292f:	53                   	push   %ebx
80102930:	83 ec 2c             	sub    $0x2c,%esp
80102933:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102936:	68 37 6c 10 80       	push   $0x80106c37
8010293b:	68 a0 16 11 80       	push   $0x801116a0
80102940:	e8 df 16 00 00       	call   80104024 <initlock>
  readsb(dev, &sb);
80102945:	58                   	pop    %eax
80102946:	5a                   	pop    %edx
80102947:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010294a:	50                   	push   %eax
8010294b:	53                   	push   %ebx
8010294c:	e8 97 ea ff ff       	call   801013e8 <readsb>
  log.start = sb.logstart;
80102951:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102954:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102959:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010295c:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  log.dev = dev;
80102962:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  struct buf *buf = bread(log.dev, log.start);
80102968:	59                   	pop    %ecx
80102969:	5a                   	pop    %edx
8010296a:	50                   	push   %eax
8010296b:	53                   	push   %ebx
8010296c:	e8 43 d7 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
80102971:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102974:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
8010297a:	83 c4 10             	add    $0x10,%esp
8010297d:	85 db                	test   %ebx,%ebx
8010297f:	7e 13                	jle    80102994 <initlog+0x68>
80102981:	31 d2                	xor    %edx,%edx
80102983:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102984:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102988:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010298f:	42                   	inc    %edx
80102990:	39 d3                	cmp    %edx,%ebx
80102992:	75 f0                	jne    80102984 <initlog+0x58>
  brelse(buf);
80102994:	83 ec 0c             	sub    $0xc,%esp
80102997:	50                   	push   %eax
80102998:	e8 1f d8 ff ff       	call   801001bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010299d:	e8 a6 fe ff ff       	call   80102848 <install_trans>
  log.lh.n = 0;
801029a2:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801029a9:	00 00 00 
  write_head(); // clear the log
801029ac:	e8 23 ff ff ff       	call   801028d4 <write_head>
}
801029b1:	83 c4 10             	add    $0x10,%esp
801029b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029b7:	c9                   	leave
801029b8:	c3                   	ret
801029b9:	8d 76 00             	lea    0x0(%esi),%esi

801029bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801029bc:	55                   	push   %ebp
801029bd:	89 e5                	mov    %esp,%ebp
801029bf:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801029c2:	68 a0 16 11 80       	push   $0x801116a0
801029c7:	e8 20 18 00 00       	call   801041ec <acquire>
801029cc:	83 c4 10             	add    $0x10,%esp
801029cf:	eb 18                	jmp    801029e9 <begin_op+0x2d>
801029d1:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801029d4:	83 ec 08             	sub    $0x8,%esp
801029d7:	68 a0 16 11 80       	push   $0x801116a0
801029dc:	68 a0 16 11 80       	push   $0x801116a0
801029e1:	e8 26 11 00 00       	call   80103b0c <sleep>
801029e6:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801029e9:	a1 e0 16 11 80       	mov    0x801116e0,%eax
801029ee:	85 c0                	test   %eax,%eax
801029f0:	75 e2                	jne    801029d4 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801029f2:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801029f7:	8d 50 01             	lea    0x1(%eax),%edx
801029fa:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
801029fe:	01 c0                	add    %eax,%eax
80102a00:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102a06:	83 f8 1e             	cmp    $0x1e,%eax
80102a09:	7f c9                	jg     801029d4 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102a0b:	89 15 dc 16 11 80    	mov    %edx,0x801116dc
      release(&log.lock);
80102a11:	83 ec 0c             	sub    $0xc,%esp
80102a14:	68 a0 16 11 80       	push   $0x801116a0
80102a19:	e8 6e 17 00 00       	call   8010418c <release>
      break;
    }
  }
}
80102a1e:	83 c4 10             	add    $0x10,%esp
80102a21:	c9                   	leave
80102a22:	c3                   	ret
80102a23:	90                   	nop

80102a24 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102a24:	55                   	push   %ebp
80102a25:	89 e5                	mov    %esp,%ebp
80102a27:	57                   	push   %edi
80102a28:	56                   	push   %esi
80102a29:	53                   	push   %ebx
80102a2a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102a2d:	68 a0 16 11 80       	push   $0x801116a0
80102a32:	e8 b5 17 00 00       	call   801041ec <acquire>
  log.outstanding -= 1;
80102a37:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102a3c:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102a3f:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102a45:	83 c4 10             	add    $0x10,%esp
80102a48:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102a4e:	85 f6                	test   %esi,%esi
80102a50:	0f 85 12 01 00 00    	jne    80102b68 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
80102a56:	85 db                	test   %ebx,%ebx
80102a58:	0f 85 e6 00 00 00    	jne    80102b44 <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
80102a5e:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102a65:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102a68:	83 ec 0c             	sub    $0xc,%esp
80102a6b:	68 a0 16 11 80       	push   $0x801116a0
80102a70:	e8 17 17 00 00       	call   8010418c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102a75:	83 c4 10             	add    $0x10,%esp
80102a78:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102a7e:	85 c9                	test   %ecx,%ecx
80102a80:	7f 3a                	jg     80102abc <end_op+0x98>
    acquire(&log.lock);
80102a82:	83 ec 0c             	sub    $0xc,%esp
80102a85:	68 a0 16 11 80       	push   $0x801116a0
80102a8a:	e8 5d 17 00 00       	call   801041ec <acquire>
    log.committing = 0;
80102a8f:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102a96:	00 00 00 
    wakeup(&log);
80102a99:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102aa0:	e8 23 11 00 00       	call   80103bc8 <wakeup>
    release(&log.lock);
80102aa5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102aac:	e8 db 16 00 00       	call   8010418c <release>
80102ab1:	83 c4 10             	add    $0x10,%esp
}
80102ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ab7:	5b                   	pop    %ebx
80102ab8:	5e                   	pop    %esi
80102ab9:	5f                   	pop    %edi
80102aba:	5d                   	pop    %ebp
80102abb:	c3                   	ret
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102abc:	83 ec 08             	sub    $0x8,%esp
80102abf:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ac4:	01 d8                	add    %ebx,%eax
80102ac6:	40                   	inc    %eax
80102ac7:	50                   	push   %eax
80102ac8:	ff 35 e4 16 11 80    	push   0x801116e4
80102ace:	e8 e1 d5 ff ff       	call   801000b4 <bread>
80102ad3:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ad5:	58                   	pop    %eax
80102ad6:	5a                   	pop    %edx
80102ad7:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ade:	ff 35 e4 16 11 80    	push   0x801116e4
80102ae4:	e8 cb d5 ff ff       	call   801000b4 <bread>
80102ae9:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102aeb:	83 c4 0c             	add    $0xc,%esp
80102aee:	68 00 02 00 00       	push   $0x200
80102af3:	8d 40 5c             	lea    0x5c(%eax),%eax
80102af6:	50                   	push   %eax
80102af7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102afa:	50                   	push   %eax
80102afb:	e8 34 18 00 00       	call   80104334 <memmove>
    bwrite(to);  // write the log
80102b00:	89 34 24             	mov    %esi,(%esp)
80102b03:	e8 7c d6 ff ff       	call   80100184 <bwrite>
    brelse(from);
80102b08:	89 3c 24             	mov    %edi,(%esp)
80102b0b:	e8 ac d6 ff ff       	call   801001bc <brelse>
    brelse(to);
80102b10:	89 34 24             	mov    %esi,(%esp)
80102b13:	e8 a4 d6 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b18:	43                   	inc    %ebx
80102b19:	83 c4 10             	add    $0x10,%esp
80102b1c:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102b22:	7c 98                	jl     80102abc <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102b24:	e8 ab fd ff ff       	call   801028d4 <write_head>
    install_trans(); // Now install writes to home locations
80102b29:	e8 1a fd ff ff       	call   80102848 <install_trans>
    log.lh.n = 0;
80102b2e:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102b35:	00 00 00 
    write_head();    // Erase the transaction from the log
80102b38:	e8 97 fd ff ff       	call   801028d4 <write_head>
80102b3d:	e9 40 ff ff ff       	jmp    80102a82 <end_op+0x5e>
80102b42:	66 90                	xchg   %ax,%ax
    wakeup(&log);
80102b44:	83 ec 0c             	sub    $0xc,%esp
80102b47:	68 a0 16 11 80       	push   $0x801116a0
80102b4c:	e8 77 10 00 00       	call   80103bc8 <wakeup>
  release(&log.lock);
80102b51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b58:	e8 2f 16 00 00       	call   8010418c <release>
80102b5d:	83 c4 10             	add    $0x10,%esp
}
80102b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b63:	5b                   	pop    %ebx
80102b64:	5e                   	pop    %esi
80102b65:	5f                   	pop    %edi
80102b66:	5d                   	pop    %ebp
80102b67:	c3                   	ret
    panic("log.committing");
80102b68:	83 ec 0c             	sub    $0xc,%esp
80102b6b:	68 3b 6c 10 80       	push   $0x80106c3b
80102b70:	e8 c3 d7 ff ff       	call   80100338 <panic>
80102b75:	8d 76 00             	lea    0x0(%esi),%esi

80102b78 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102b78:	55                   	push   %ebp
80102b79:	89 e5                	mov    %esp,%ebp
80102b7b:	53                   	push   %ebx
80102b7c:	52                   	push   %edx
80102b7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102b80:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102b86:	83 fa 1d             	cmp    $0x1d,%edx
80102b89:	7f 71                	jg     80102bfc <log_write+0x84>
80102b8b:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102b90:	48                   	dec    %eax
80102b91:	39 c2                	cmp    %eax,%edx
80102b93:	7d 67                	jge    80102bfc <log_write+0x84>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102b95:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102b9a:	85 c0                	test   %eax,%eax
80102b9c:	7e 6b                	jle    80102c09 <log_write+0x91>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102b9e:	83 ec 0c             	sub    $0xc,%esp
80102ba1:	68 a0 16 11 80       	push   $0x801116a0
80102ba6:	e8 41 16 00 00       	call   801041ec <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102bab:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102bb1:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102bb4:	83 c4 10             	add    $0x10,%esp
80102bb7:	31 c0                	xor    %eax,%eax
80102bb9:	85 d2                	test   %edx,%edx
80102bbb:	7f 08                	jg     80102bc5 <log_write+0x4d>
80102bbd:	eb 0f                	jmp    80102bce <log_write+0x56>
80102bbf:	90                   	nop
80102bc0:	40                   	inc    %eax
80102bc1:	39 d0                	cmp    %edx,%eax
80102bc3:	74 27                	je     80102bec <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102bc5:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102bcc:	75 f2                	jne    80102bc0 <log_write+0x48>
  log.lh.block[i] = b->blockno;
80102bce:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102bd5:	39 c2                	cmp    %eax,%edx
80102bd7:	74 1a                	je     80102bf3 <log_write+0x7b>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102bd9:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102bdc:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102be6:	c9                   	leave
  release(&log.lock);
80102be7:	e9 a0 15 00 00       	jmp    8010418c <release>
  log.lh.block[i] = b->blockno;
80102bec:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102bf3:	42                   	inc    %edx
80102bf4:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102bfa:	eb dd                	jmp    80102bd9 <log_write+0x61>
    panic("too big a transaction");
80102bfc:	83 ec 0c             	sub    $0xc,%esp
80102bff:	68 4a 6c 10 80       	push   $0x80106c4a
80102c04:	e8 2f d7 ff ff       	call   80100338 <panic>
    panic("log_write outside of trans");
80102c09:	83 ec 0c             	sub    $0xc,%esp
80102c0c:	68 60 6c 10 80       	push   $0x80106c60
80102c11:	e8 22 d7 ff ff       	call   80100338 <panic>
80102c16:	66 90                	xchg   %ax,%ax

80102c18 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102c18:	55                   	push   %ebp
80102c19:	89 e5                	mov    %esp,%ebp
80102c1b:	53                   	push   %ebx
80102c1c:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102c1d:	e8 a2 08 00 00       	call   801034c4 <cpuid>
80102c22:	89 c3                	mov    %eax,%ebx
80102c24:	e8 9b 08 00 00       	call   801034c4 <cpuid>
80102c29:	52                   	push   %edx
80102c2a:	53                   	push   %ebx
80102c2b:	50                   	push   %eax
80102c2c:	68 7b 6c 10 80       	push   $0x80106c7b
80102c31:	e8 ea d9 ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102c36:	e8 b1 26 00 00       	call   801052ec <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102c3b:	e8 20 08 00 00       	call   80103460 <mycpu>
80102c40:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102c42:	b8 01 00 00 00       	mov    $0x1,%eax
80102c47:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102c4e:	e8 d9 11 00 00       	call   80103e2c <scheduler>
80102c53:	90                   	nop

80102c54 <mpenter>:
{
80102c54:	55                   	push   %ebp
80102c55:	89 e5                	mov    %esp,%ebp
80102c57:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102c5a:	e8 3d 37 00 00       	call   8010639c <switchkvm>
  seginit();
80102c5f:	e8 b4 36 00 00       	call   80106318 <seginit>
  lapicinit();
80102c64:	e8 6f f8 ff ff       	call   801024d8 <lapicinit>
  mpmain();
80102c69:	e8 aa ff ff ff       	call   80102c18 <mpmain>
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <main>:
{
80102c70:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102c74:	83 e4 f0             	and    $0xfffffff0,%esp
80102c77:	ff 71 fc             	push   -0x4(%ecx)
80102c7a:	55                   	push   %ebp
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	53                   	push   %ebx
80102c7e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102c7f:	83 ec 08             	sub    $0x8,%esp
80102c82:	68 00 00 40 80       	push   $0x80400000
80102c87:	68 d0 5e 11 80       	push   $0x80115ed0
80102c8c:	e8 9f f6 ff ff       	call   80102330 <kinit1>
  kvmalloc();      // kernel page table
80102c91:	e8 4e 3b 00 00       	call   801067e4 <kvmalloc>
  mpinit();        // detect other processors
80102c96:	e8 61 01 00 00       	call   80102dfc <mpinit>
  lapicinit();     // interrupt controller
80102c9b:	e8 38 f8 ff ff       	call   801024d8 <lapicinit>
  seginit();       // segment descriptors
80102ca0:	e8 73 36 00 00       	call   80106318 <seginit>
  picinit();       // disable pic
80102ca5:	e8 12 03 00 00       	call   80102fbc <picinit>
  ioapicinit();    // another interrupt controller
80102caa:	e8 85 f4 ff ff       	call   80102134 <ioapicinit>
  consoleinit();   // console hardware
80102caf:	e8 2c dd ff ff       	call   801009e0 <consoleinit>
  uartinit();      // serial port
80102cb4:	e8 3b 29 00 00       	call   801055f4 <uartinit>
  pinit();         // process table
80102cb9:	e8 86 07 00 00       	call   80103444 <pinit>
  tvinit();        // trap vectors
80102cbe:	e8 bd 25 00 00       	call   80105280 <tvinit>
  binit();         // buffer cache
80102cc3:	e8 6c d3 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102cc8:	e8 b7 e0 ff ff       	call   80100d84 <fileinit>
  ideinit();       // disk 
80102ccd:	e8 86 f2 ff ff       	call   80101f58 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102cd2:	83 c4 0c             	add    $0xc,%esp
80102cd5:	68 8a 00 00 00       	push   $0x8a
80102cda:	68 8c a4 10 80       	push   $0x8010a48c
80102cdf:	68 00 70 00 80       	push   $0x80007000
80102ce4:	e8 4b 16 00 00       	call   80104334 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ce9:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102cef:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102cf2:	01 c0                	add    %eax,%eax
80102cf4:	01 d0                	add    %edx,%eax
80102cf6:	c1 e0 04             	shl    $0x4,%eax
80102cf9:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102cfe:	83 c4 10             	add    $0x10,%esp
80102d01:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80102d06:	76 74                	jbe    80102d7c <main+0x10c>
80102d08:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80102d0d:	eb 20                	jmp    80102d2f <main+0xbf>
80102d0f:	90                   	nop
80102d10:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102d16:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102d1c:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102d1f:	01 c0                	add    %eax,%eax
80102d21:	01 d0                	add    %edx,%eax
80102d23:	c1 e0 04             	shl    $0x4,%eax
80102d26:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102d2b:	39 c3                	cmp    %eax,%ebx
80102d2d:	73 4d                	jae    80102d7c <main+0x10c>
    if(c == mycpu())  // We've started already.
80102d2f:	e8 2c 07 00 00       	call   80103460 <mycpu>
80102d34:	39 c3                	cmp    %eax,%ebx
80102d36:	74 d8                	je     80102d10 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102d38:	e8 57 f6 ff ff       	call   80102394 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102d3d:	05 00 10 00 00       	add    $0x1000,%eax
80102d42:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102d47:	c7 05 f8 6f 00 80 54 	movl   $0x80102c54,0x80006ff8
80102d4e:	2c 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102d51:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102d58:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102d5b:	83 ec 08             	sub    $0x8,%esp
80102d5e:	68 00 70 00 00       	push   $0x7000
80102d63:	0f b6 03             	movzbl (%ebx),%eax
80102d66:	50                   	push   %eax
80102d67:	e8 7c f8 ff ff       	call   801025e8 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102d6c:	83 c4 10             	add    $0x10,%esp
80102d6f:	90                   	nop
80102d70:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102d76:	85 c0                	test   %eax,%eax
80102d78:	74 f6                	je     80102d70 <main+0x100>
80102d7a:	eb 94                	jmp    80102d10 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102d7c:	83 ec 08             	sub    $0x8,%esp
80102d7f:	68 00 00 00 8e       	push   $0x8e000000
80102d84:	68 00 00 40 80       	push   $0x80400000
80102d89:	e8 4e f5 ff ff       	call   801022dc <kinit2>
  userinit();      // first user process
80102d8e:	e8 89 07 00 00       	call   8010351c <userinit>
  mpmain();        // finish this processor's setup
80102d93:	e8 80 fe ff ff       	call   80102c18 <mpmain>

80102d98 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102d98:	55                   	push   %ebp
80102d99:	89 e5                	mov    %esp,%ebp
80102d9b:	57                   	push   %edi
80102d9c:	56                   	push   %esi
80102d9d:	53                   	push   %ebx
80102d9e:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102da1:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102da7:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102dae:	39 de                	cmp    %ebx,%esi
80102db0:	72 0b                	jb     80102dbd <mpsearch1+0x25>
80102db2:	eb 3c                	jmp    80102df0 <mpsearch1+0x58>
80102db4:	8d 7e 10             	lea    0x10(%esi),%edi
80102db7:	89 fe                	mov    %edi,%esi
80102db9:	39 df                	cmp    %ebx,%edi
80102dbb:	73 33                	jae    80102df0 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102dbd:	50                   	push   %eax
80102dbe:	6a 04                	push   $0x4
80102dc0:	68 8f 6c 10 80       	push   $0x80106c8f
80102dc5:	56                   	push   %esi
80102dc6:	e8 31 15 00 00       	call   801042fc <memcmp>
80102dcb:	83 c4 10             	add    $0x10,%esp
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	75 e2                	jne    80102db4 <mpsearch1+0x1c>
80102dd2:	89 f2                	mov    %esi,%edx
80102dd4:	8d 7e 10             	lea    0x10(%esi),%edi
80102dd7:	90                   	nop
    sum += addr[i];
80102dd8:	0f b6 0a             	movzbl (%edx),%ecx
80102ddb:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102ddd:	42                   	inc    %edx
80102dde:	39 fa                	cmp    %edi,%edx
80102de0:	75 f6                	jne    80102dd8 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102de2:	84 c0                	test   %al,%al
80102de4:	75 d1                	jne    80102db7 <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102de6:	89 f0                	mov    %esi,%eax
80102de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102deb:	5b                   	pop    %ebx
80102dec:	5e                   	pop    %esi
80102ded:	5f                   	pop    %edi
80102dee:	5d                   	pop    %ebp
80102def:	c3                   	ret
  return 0;
80102df0:	31 f6                	xor    %esi,%esi
}
80102df2:	89 f0                	mov    %esi,%eax
80102df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df7:	5b                   	pop    %ebx
80102df8:	5e                   	pop    %esi
80102df9:	5f                   	pop    %edi
80102dfa:	5d                   	pop    %ebp
80102dfb:	c3                   	ret

80102dfc <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102dfc:	55                   	push   %ebp
80102dfd:	89 e5                	mov    %esp,%ebp
80102dff:	57                   	push   %edi
80102e00:	56                   	push   %esi
80102e01:	53                   	push   %ebx
80102e02:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102e05:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102e0c:	c1 e0 08             	shl    $0x8,%eax
80102e0f:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102e16:	09 d0                	or     %edx,%eax
80102e18:	c1 e0 04             	shl    $0x4,%eax
80102e1b:	75 1b                	jne    80102e38 <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102e1d:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102e24:	c1 e0 08             	shl    $0x8,%eax
80102e27:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102e2e:	09 d0                	or     %edx,%eax
80102e30:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102e33:	2d 00 04 00 00       	sub    $0x400,%eax
80102e38:	ba 00 04 00 00       	mov    $0x400,%edx
80102e3d:	e8 56 ff ff ff       	call   80102d98 <mpsearch1>
80102e42:	85 c0                	test   %eax,%eax
80102e44:	0f 84 26 01 00 00    	je     80102f70 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102e50:	8b 48 04             	mov    0x4(%eax),%ecx
80102e53:	85 c9                	test   %ecx,%ecx
80102e55:	0f 84 a5 00 00 00    	je     80102f00 <mpinit+0x104>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102e5e:	8b 40 04             	mov    0x4(%eax),%eax
80102e61:	05 00 00 00 80       	add    $0x80000000,%eax
80102e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e6c:	52                   	push   %edx
80102e6d:	6a 04                	push   $0x4
80102e6f:	68 ac 6c 10 80       	push   $0x80106cac
80102e74:	50                   	push   %eax
80102e75:	e8 82 14 00 00       	call   801042fc <memcmp>
80102e7a:	89 c2                	mov    %eax,%edx
80102e7c:	83 c4 10             	add    $0x10,%esp
80102e7f:	85 c0                	test   %eax,%eax
80102e81:	75 7d                	jne    80102f00 <mpinit+0x104>
  if(conf->version != 1 && conf->version != 4)
80102e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e86:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80102e8a:	74 09                	je     80102e95 <mpinit+0x99>
80102e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e8f:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
80102e93:	75 6b                	jne    80102f00 <mpinit+0x104>
  if(sum((uchar*)conf, conf->length) != 0)
80102e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e98:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
80102e9f:	66 85 c9             	test   %cx,%cx
80102ea2:	74 12                	je     80102eb6 <mpinit+0xba>
80102ea4:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80102ea7:	90                   	nop
    sum += addr[i];
80102ea8:	0f b6 08             	movzbl (%eax),%ecx
80102eab:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102ead:	40                   	inc    %eax
80102eae:	39 d8                	cmp    %ebx,%eax
80102eb0:	75 f6                	jne    80102ea8 <mpinit+0xac>
  if(sum((uchar*)conf, conf->length) != 0)
80102eb2:	84 d2                	test   %dl,%dl
80102eb4:	75 4a                	jne    80102f00 <mpinit+0x104>
  *pmp = mp;
80102eb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  return conf;
80102eb9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102ebc:	85 c9                	test   %ecx,%ecx
80102ebe:	74 40                	je     80102f00 <mpinit+0x104>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102ec0:	8b 41 24             	mov    0x24(%ecx),%eax
80102ec3:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ec8:	8d 41 2c             	lea    0x2c(%ecx),%eax
80102ecb:	0f b7 51 04          	movzwl 0x4(%ecx),%edx
80102ecf:	01 d1                	add    %edx,%ecx
80102ed1:	39 c8                	cmp    %ecx,%eax
80102ed3:	72 0e                	jb     80102ee3 <mpinit+0xe7>
80102ed5:	eb 49                	jmp    80102f20 <mpinit+0x124>
80102ed7:	90                   	nop
    switch(*p){
80102ed8:	84 d2                	test   %dl,%dl
80102eda:	74 64                	je     80102f40 <mpinit+0x144>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102edc:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102edf:	39 c8                	cmp    %ecx,%eax
80102ee1:	73 3d                	jae    80102f20 <mpinit+0x124>
    switch(*p){
80102ee3:	8a 10                	mov    (%eax),%dl
80102ee5:	80 fa 02             	cmp    $0x2,%dl
80102ee8:	74 26                	je     80102f10 <mpinit+0x114>
80102eea:	76 ec                	jbe    80102ed8 <mpinit+0xdc>
80102eec:	83 ea 03             	sub    $0x3,%edx
80102eef:	80 fa 01             	cmp    $0x1,%dl
80102ef2:	76 e8                	jbe    80102edc <mpinit+0xe0>
80102ef4:	eb fe                	jmp    80102ef4 <mpinit+0xf8>
80102ef6:	66 90                	xchg   %ax,%ax
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ef8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102eff:	90                   	nop
    panic("Expect to run on an SMP");
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 94 6c 10 80       	push   $0x80106c94
80102f08:	e8 2b d4 ff ff       	call   80100338 <panic>
80102f0d:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80102f10:	8a 50 01             	mov    0x1(%eax),%dl
80102f13:	88 15 80 17 11 80    	mov    %dl,0x80111780
      p += sizeof(struct mpioapic);
80102f19:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102f1c:	39 c8                	cmp    %ecx,%eax
80102f1e:	72 c3                	jb     80102ee3 <mpinit+0xe7>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102f20:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80102f24:	74 12                	je     80102f38 <mpinit+0x13c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f26:	b0 70                	mov    $0x70,%al
80102f28:	ba 22 00 00 00       	mov    $0x22,%edx
80102f2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2e:	ba 23 00 00 00       	mov    $0x23,%edx
80102f33:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102f34:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f37:	ee                   	out    %al,(%dx)
  }
}
80102f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3b:	5b                   	pop    %ebx
80102f3c:	5e                   	pop    %esi
80102f3d:	5f                   	pop    %edi
80102f3e:	5d                   	pop    %ebp
80102f3f:	c3                   	ret
      if(ncpu < NCPU) {
80102f40:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102f46:	83 fa 07             	cmp    $0x7,%edx
80102f49:	7f 1a                	jg     80102f65 <mpinit+0x169>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102f4b:	8d 34 92             	lea    (%edx,%edx,4),%esi
80102f4e:	01 f6                	add    %esi,%esi
80102f50:	01 d6                	add    %edx,%esi
80102f52:	c1 e6 04             	shl    $0x4,%esi
80102f55:	8a 58 01             	mov    0x1(%eax),%bl
80102f58:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80102f5e:	42                   	inc    %edx
80102f5f:	89 15 84 17 11 80    	mov    %edx,0x80111784
      p += sizeof(struct mpproc);
80102f65:	83 c0 14             	add    $0x14,%eax
      continue;
80102f68:	e9 72 ff ff ff       	jmp    80102edf <mpinit+0xe3>
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102f70:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80102f75:	eb 12                	jmp    80102f89 <mpinit+0x18d>
80102f77:	90                   	nop
80102f78:	8d 73 10             	lea    0x10(%ebx),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7b:	89 f3                	mov    %esi,%ebx
80102f7d:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80102f83:	0f 84 6f ff ff ff    	je     80102ef8 <mpinit+0xfc>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f89:	56                   	push   %esi
80102f8a:	6a 04                	push   $0x4
80102f8c:	68 8f 6c 10 80       	push   $0x80106c8f
80102f91:	53                   	push   %ebx
80102f92:	e8 65 13 00 00       	call   801042fc <memcmp>
80102f97:	83 c4 10             	add    $0x10,%esp
80102f9a:	85 c0                	test   %eax,%eax
80102f9c:	75 da                	jne    80102f78 <mpinit+0x17c>
80102f9e:	89 da                	mov    %ebx,%edx
80102fa0:	8d 73 10             	lea    0x10(%ebx),%esi
80102fa3:	90                   	nop
    sum += addr[i];
80102fa4:	0f b6 0a             	movzbl (%edx),%ecx
80102fa7:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102fa9:	42                   	inc    %edx
80102faa:	39 d6                	cmp    %edx,%esi
80102fac:	75 f6                	jne    80102fa4 <mpinit+0x1a8>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fae:	84 c0                	test   %al,%al
80102fb0:	75 c9                	jne    80102f7b <mpinit+0x17f>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fb2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102fb5:	e9 93 fe ff ff       	jmp    80102e4d <mpinit+0x51>
80102fba:	66 90                	xchg   %ax,%ax

80102fbc <picinit>:
80102fbc:	b0 ff                	mov    $0xff,%al
80102fbe:	ba 21 00 00 00       	mov    $0x21,%edx
80102fc3:	ee                   	out    %al,(%dx)
80102fc4:	ba a1 00 00 00       	mov    $0xa1,%edx
80102fc9:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102fca:	c3                   	ret
80102fcb:	90                   	nop

80102fcc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102fcc:	55                   	push   %ebp
80102fcd:	89 e5                	mov    %esp,%ebp
80102fcf:	57                   	push   %edi
80102fd0:	56                   	push   %esi
80102fd1:	53                   	push   %ebx
80102fd2:	83 ec 0c             	sub    $0xc,%esp
80102fd5:	8b 75 08             	mov    0x8(%ebp),%esi
80102fd8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102fdb:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80102fe1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102fe7:	e8 b4 dd ff ff       	call   80100da0 <filealloc>
80102fec:	89 06                	mov    %eax,(%esi)
80102fee:	85 c0                	test   %eax,%eax
80102ff0:	0f 84 a5 00 00 00    	je     8010309b <pipealloc+0xcf>
80102ff6:	e8 a5 dd ff ff       	call   80100da0 <filealloc>
80102ffb:	89 07                	mov    %eax,(%edi)
80102ffd:	85 c0                	test   %eax,%eax
80102fff:	0f 84 84 00 00 00    	je     80103089 <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103005:	e8 8a f3 ff ff       	call   80102394 <kalloc>
8010300a:	89 c3                	mov    %eax,%ebx
8010300c:	85 c0                	test   %eax,%eax
8010300e:	0f 84 a0 00 00 00    	je     801030b4 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103014:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010301b:	00 00 00 
  p->writeopen = 1;
8010301e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103025:	00 00 00 
  p->nwrite = 0;
80103028:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010302f:	00 00 00 
  p->nread = 0;
80103032:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103039:	00 00 00 
  initlock(&p->lock, "pipe");
8010303c:	83 ec 08             	sub    $0x8,%esp
8010303f:	68 b1 6c 10 80       	push   $0x80106cb1
80103044:	50                   	push   %eax
80103045:	e8 da 0f 00 00       	call   80104024 <initlock>
  (*f0)->type = FD_PIPE;
8010304a:	8b 06                	mov    (%esi),%eax
8010304c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103052:	8b 06                	mov    (%esi),%eax
80103054:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103058:	8b 06                	mov    (%esi),%eax
8010305a:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010305e:	8b 06                	mov    (%esi),%eax
80103060:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103063:	8b 07                	mov    (%edi),%eax
80103065:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010306b:	8b 07                	mov    (%edi),%eax
8010306d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103071:	8b 07                	mov    (%edi),%eax
80103073:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103077:	8b 07                	mov    (%edi),%eax
80103079:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
8010307c:	83 c4 10             	add    $0x10,%esp
8010307f:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103084:	5b                   	pop    %ebx
80103085:	5e                   	pop    %esi
80103086:	5f                   	pop    %edi
80103087:	5d                   	pop    %ebp
80103088:	c3                   	ret
  if(*f0)
80103089:	8b 06                	mov    (%esi),%eax
8010308b:	85 c0                	test   %eax,%eax
8010308d:	74 1e                	je     801030ad <pipealloc+0xe1>
    fileclose(*f0);
8010308f:	83 ec 0c             	sub    $0xc,%esp
80103092:	50                   	push   %eax
80103093:	e8 b4 dd ff ff       	call   80100e4c <fileclose>
80103098:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010309b:	8b 07                	mov    (%edi),%eax
8010309d:	85 c0                	test   %eax,%eax
8010309f:	74 0c                	je     801030ad <pipealloc+0xe1>
    fileclose(*f1);
801030a1:	83 ec 0c             	sub    $0xc,%esp
801030a4:	50                   	push   %eax
801030a5:	e8 a2 dd ff ff       	call   80100e4c <fileclose>
801030aa:	83 c4 10             	add    $0x10,%esp
  return -1;
801030ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030b2:	eb cd                	jmp    80103081 <pipealloc+0xb5>
  if(*f0)
801030b4:	8b 06                	mov    (%esi),%eax
801030b6:	85 c0                	test   %eax,%eax
801030b8:	75 d5                	jne    8010308f <pipealloc+0xc3>
801030ba:	eb df                	jmp    8010309b <pipealloc+0xcf>

801030bc <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801030bc:	55                   	push   %ebp
801030bd:	89 e5                	mov    %esp,%ebp
801030bf:	56                   	push   %esi
801030c0:	53                   	push   %ebx
801030c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801030c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801030c7:	83 ec 0c             	sub    $0xc,%esp
801030ca:	53                   	push   %ebx
801030cb:	e8 1c 11 00 00       	call   801041ec <acquire>
  if(writable){
801030d0:	83 c4 10             	add    $0x10,%esp
801030d3:	85 f6                	test   %esi,%esi
801030d5:	74 41                	je     80103118 <pipeclose+0x5c>
    p->writeopen = 0;
801030d7:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801030de:	00 00 00 
    wakeup(&p->nread);
801030e1:	83 ec 0c             	sub    $0xc,%esp
801030e4:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801030ea:	50                   	push   %eax
801030eb:	e8 d8 0a 00 00       	call   80103bc8 <wakeup>
801030f0:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801030f3:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801030f9:	85 d2                	test   %edx,%edx
801030fb:	75 0a                	jne    80103107 <pipeclose+0x4b>
801030fd:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103103:	85 c0                	test   %eax,%eax
80103105:	74 31                	je     80103138 <pipeclose+0x7c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103107:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010310a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010310d:	5b                   	pop    %ebx
8010310e:	5e                   	pop    %esi
8010310f:	5d                   	pop    %ebp
    release(&p->lock);
80103110:	e9 77 10 00 00       	jmp    8010418c <release>
80103115:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
80103118:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
8010311f:	00 00 00 
    wakeup(&p->nwrite);
80103122:	83 ec 0c             	sub    $0xc,%esp
80103125:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010312b:	50                   	push   %eax
8010312c:	e8 97 0a 00 00       	call   80103bc8 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
80103134:	eb bd                	jmp    801030f3 <pipeclose+0x37>
80103136:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103138:	83 ec 0c             	sub    $0xc,%esp
8010313b:	53                   	push   %ebx
8010313c:	e8 4b 10 00 00       	call   8010418c <release>
    kfree((char*)p);
80103141:	83 c4 10             	add    $0x10,%esp
80103144:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103147:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010314a:	5b                   	pop    %ebx
8010314b:	5e                   	pop    %esi
8010314c:	5d                   	pop    %ebp
    kfree((char*)p);
8010314d:	e9 b2 f0 ff ff       	jmp    80102204 <kfree>
80103152:	66 90                	xchg   %ax,%ax

80103154 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103154:	55                   	push   %ebp
80103155:	89 e5                	mov    %esp,%ebp
80103157:	57                   	push   %edi
80103158:	56                   	push   %esi
80103159:	53                   	push   %ebx
8010315a:	83 ec 28             	sub    $0x28,%esp
8010315d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103160:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103163:	53                   	push   %ebx
80103164:	e8 83 10 00 00       	call   801041ec <acquire>
  for(i = 0; i < n; i++){
80103169:	83 c4 10             	add    $0x10,%esp
8010316c:	85 ff                	test   %edi,%edi
8010316e:	0f 8e c2 00 00 00    	jle    80103236 <pipewrite+0xe2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103174:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010317a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010317d:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103180:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103183:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010318c:	89 7d 10             	mov    %edi,0x10(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010318f:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103195:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010319b:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801031a1:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801031a4:	0f 85 aa 00 00 00    	jne    80103254 <pipewrite+0x100>
801031aa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801031ad:	eb 37                	jmp    801031e6 <pipewrite+0x92>
801031af:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801031b0:	e8 43 03 00 00       	call   801034f8 <myproc>
801031b5:	8b 48 4c             	mov    0x4c(%eax),%ecx
801031b8:	85 c9                	test   %ecx,%ecx
801031ba:	75 34                	jne    801031f0 <pipewrite+0x9c>
      wakeup(&p->nread);
801031bc:	83 ec 0c             	sub    $0xc,%esp
801031bf:	56                   	push   %esi
801031c0:	e8 03 0a 00 00       	call   80103bc8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801031c5:	58                   	pop    %eax
801031c6:	5a                   	pop    %edx
801031c7:	53                   	push   %ebx
801031c8:	57                   	push   %edi
801031c9:	e8 3e 09 00 00       	call   80103b0c <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801031ce:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801031d4:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801031da:	05 00 02 00 00       	add    $0x200,%eax
801031df:	83 c4 10             	add    $0x10,%esp
801031e2:	39 c2                	cmp    %eax,%edx
801031e4:	75 26                	jne    8010320c <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801031e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 c0                	jne    801031b0 <pipewrite+0x5c>
        release(&p->lock);
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	53                   	push   %ebx
801031f4:	e8 93 0f 00 00       	call   8010418c <release>
        return -1;
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103204:	5b                   	pop    %ebx
80103205:	5e                   	pop    %esi
80103206:	5f                   	pop    %edi
80103207:	5d                   	pop    %ebp
80103208:	c3                   	ret
80103209:	8d 76 00             	lea    0x0(%esi),%esi
8010320c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010320f:	8d 42 01             	lea    0x1(%edx),%eax
80103212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103215:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010321b:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103221:	8a 01                	mov    (%ecx),%al
80103223:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103227:	41                   	inc    %ecx
80103228:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010322b:	39 c1                	cmp    %eax,%ecx
8010322d:	0f 85 5c ff ff ff    	jne    8010318f <pipewrite+0x3b>
80103233:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103236:	83 ec 0c             	sub    $0xc,%esp
80103239:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010323f:	50                   	push   %eax
80103240:	e8 83 09 00 00       	call   80103bc8 <wakeup>
  release(&p->lock);
80103245:	89 1c 24             	mov    %ebx,(%esp)
80103248:	e8 3f 0f 00 00       	call   8010418c <release>
  return n;
8010324d:	83 c4 10             	add    $0x10,%esp
80103250:	89 f8                	mov    %edi,%eax
80103252:	eb ad                	jmp    80103201 <pipewrite+0xad>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103254:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103257:	eb b6                	jmp    8010320f <pipewrite+0xbb>
80103259:	8d 76 00             	lea    0x0(%esi),%esi

8010325c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010325c:	55                   	push   %ebp
8010325d:	89 e5                	mov    %esp,%ebp
8010325f:	57                   	push   %edi
80103260:	56                   	push   %esi
80103261:	53                   	push   %ebx
80103262:	83 ec 18             	sub    $0x18,%esp
80103265:	8b 75 08             	mov    0x8(%ebp),%esi
80103268:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010326b:	56                   	push   %esi
8010326c:	e8 7b 0f 00 00       	call   801041ec <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103271:	83 c4 10             	add    $0x10,%esp
80103274:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010327a:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103280:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103286:	74 2f                	je     801032b7 <piperead+0x5b>
80103288:	eb 37                	jmp    801032c1 <piperead+0x65>
8010328a:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
8010328c:	e8 67 02 00 00       	call   801034f8 <myproc>
80103291:	8b 40 4c             	mov    0x4c(%eax),%eax
80103294:	85 c0                	test   %eax,%eax
80103296:	0f 85 80 00 00 00    	jne    8010331c <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010329c:	83 ec 08             	sub    $0x8,%esp
8010329f:	56                   	push   %esi
801032a0:	53                   	push   %ebx
801032a1:	e8 66 08 00 00       	call   80103b0c <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801032a6:	83 c4 10             	add    $0x10,%esp
801032a9:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801032af:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801032b5:	75 0a                	jne    801032c1 <piperead+0x65>
801032b7:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801032bd:	85 d2                	test   %edx,%edx
801032bf:	75 cb                	jne    8010328c <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801032c1:	31 db                	xor    %ebx,%ebx
801032c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032c6:	85 c9                	test   %ecx,%ecx
801032c8:	7f 23                	jg     801032ed <piperead+0x91>
801032ca:	eb 29                	jmp    801032f5 <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801032cc:	8d 48 01             	lea    0x1(%eax),%ecx
801032cf:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801032d5:	25 ff 01 00 00       	and    $0x1ff,%eax
801032da:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
801032de:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801032e1:	43                   	inc    %ebx
801032e2:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801032e5:	74 0e                	je     801032f5 <piperead+0x99>
801032e7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801032ed:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801032f3:	75 d7                	jne    801032cc <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801032f5:	83 ec 0c             	sub    $0xc,%esp
801032f8:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801032fe:	50                   	push   %eax
801032ff:	e8 c4 08 00 00       	call   80103bc8 <wakeup>
  release(&p->lock);
80103304:	89 34 24             	mov    %esi,(%esp)
80103307:	e8 80 0e 00 00       	call   8010418c <release>
  return i;
8010330c:	83 c4 10             	add    $0x10,%esp
}
8010330f:	89 d8                	mov    %ebx,%eax
80103311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103314:	5b                   	pop    %ebx
80103315:	5e                   	pop    %esi
80103316:	5f                   	pop    %edi
80103317:	5d                   	pop    %ebp
80103318:	c3                   	ret
80103319:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
8010331c:	83 ec 0c             	sub    $0xc,%esp
8010331f:	56                   	push   %esi
80103320:	e8 67 0e 00 00       	call   8010418c <release>
      return -1;
80103325:	83 c4 10             	add    $0x10,%esp
80103328:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
8010332d:	89 d8                	mov    %ebx,%eax
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret
80103337:	90                   	nop

80103338 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103338:	55                   	push   %ebp
80103339:	89 e5                	mov    %esp,%ebp
8010333b:	53                   	push   %ebx
8010333c:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010333f:	68 40 1d 11 80       	push   $0x80111d40
80103344:	e8 a3 0e 00 00       	call   801041ec <acquire>
80103349:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010334c:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
80103351:	eb 0f                	jmp    80103362 <allocproc+0x2a>
80103353:	90                   	nop
80103354:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
8010335a:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
80103360:	74 76                	je     801033d8 <allocproc+0xa0>
    if(p->state == UNUSED)
80103362:	8b 4b 34             	mov    0x34(%ebx),%ecx
80103365:	85 c9                	test   %ecx,%ecx
80103367:	75 eb                	jne    80103354 <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103369:	c7 43 34 01 00 00 00 	movl   $0x1,0x34(%ebx)
  p->pid = nextpid++;
80103370:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103375:	8d 50 01             	lea    0x1(%eax),%edx
80103378:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010337e:	89 43 38             	mov    %eax,0x38(%ebx)

  release(&ptable.lock);
80103381:	83 ec 0c             	sub    $0xc,%esp
80103384:	68 40 1d 11 80       	push   $0x80111d40
80103389:	e8 fe 0d 00 00       	call   8010418c <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010338e:	e8 01 f0 ff ff       	call   80102394 <kalloc>
80103393:	89 43 30             	mov    %eax,0x30(%ebx)
80103396:	83 c4 10             	add    $0x10,%esp
80103399:	85 c0                	test   %eax,%eax
8010339b:	74 54                	je     801033f1 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010339d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
801033a3:	89 53 40             	mov    %edx,0x40(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801033a6:	c7 80 b0 0f 00 00 72 	movl   $0x80105272,0xfb0(%eax)
801033ad:	52 10 80 

  sp -= sizeof *p->context;
801033b0:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801033b5:	89 43 44             	mov    %eax,0x44(%ebx)
  memset(p->context, 0, sizeof *p->context);
801033b8:	52                   	push   %edx
801033b9:	6a 14                	push   $0x14
801033bb:	6a 00                	push   $0x0
801033bd:	50                   	push   %eax
801033be:	e8 f5 0e 00 00       	call   801042b8 <memset>
  p->context->eip = (uint)forkret;
801033c3:	8b 43 44             	mov    0x44(%ebx),%eax
801033c6:	c7 40 10 fc 33 10 80 	movl   $0x801033fc,0x10(%eax)

  return p;
801033cd:	83 c4 10             	add    $0x10,%esp
}
801033d0:	89 d8                	mov    %ebx,%eax
801033d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033d5:	c9                   	leave
801033d6:	c3                   	ret
801033d7:	90                   	nop
  release(&ptable.lock);
801033d8:	83 ec 0c             	sub    $0xc,%esp
801033db:	68 40 1d 11 80       	push   $0x80111d40
801033e0:	e8 a7 0d 00 00       	call   8010418c <release>
  return 0;
801033e5:	83 c4 10             	add    $0x10,%esp
801033e8:	31 db                	xor    %ebx,%ebx
}
801033ea:	89 d8                	mov    %ebx,%eax
801033ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033ef:	c9                   	leave
801033f0:	c3                   	ret
    p->state = UNUSED;
801033f1:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
  return 0;
801033f8:	31 db                	xor    %ebx,%ebx
801033fa:	eb ee                	jmp    801033ea <allocproc+0xb2>

801033fc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801033fc:	55                   	push   %ebp
801033fd:	89 e5                	mov    %esp,%ebp
801033ff:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103402:	68 40 1d 11 80       	push   $0x80111d40
80103407:	e8 80 0d 00 00       	call   8010418c <release>

  if (first) {
8010340c:	83 c4 10             	add    $0x10,%esp
8010340f:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103414:	85 c0                	test   %eax,%eax
80103416:	75 04                	jne    8010341c <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103418:	c9                   	leave
80103419:	c3                   	ret
8010341a:	66 90                	xchg   %ax,%ax
    first = 0;
8010341c:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103423:	00 00 00 
    iinit(ROOTDEV);
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	6a 01                	push   $0x1
8010342b:	e8 f0 df ff ff       	call   80101420 <iinit>
    initlog(ROOTDEV);
80103430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103437:	e8 f0 f4 ff ff       	call   8010292c <initlog>
}
8010343c:	83 c4 10             	add    $0x10,%esp
8010343f:	c9                   	leave
80103440:	c3                   	ret
80103441:	8d 76 00             	lea    0x0(%esi),%esi

80103444 <pinit>:
{
80103444:	55                   	push   %ebp
80103445:	89 e5                	mov    %esp,%ebp
80103447:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010344a:	68 b6 6c 10 80       	push   $0x80106cb6
8010344f:	68 40 1d 11 80       	push   $0x80111d40
80103454:	e8 cb 0b 00 00       	call   80104024 <initlock>
}
80103459:	83 c4 10             	add    $0x10,%esp
8010345c:	c9                   	leave
8010345d:	c3                   	ret
8010345e:	66 90                	xchg   %ax,%ax

80103460 <mycpu>:
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	56                   	push   %esi
80103464:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103465:	9c                   	pushf
80103466:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103467:	f6 c4 02             	test   $0x2,%ah
8010346a:	75 4b                	jne    801034b7 <mycpu+0x57>
  apicid = lapicid();
8010346c:	e8 47 f1 ff ff       	call   801025b8 <lapicid>
80103471:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
80103473:	8b 1d 84 17 11 80    	mov    0x80111784,%ebx
80103479:	85 db                	test   %ebx,%ebx
8010347b:	7e 2d                	jle    801034aa <mycpu+0x4a>
8010347d:	31 d2                	xor    %edx,%edx
8010347f:	eb 08                	jmp    80103489 <mycpu+0x29>
80103481:	8d 76 00             	lea    0x0(%esi),%esi
80103484:	42                   	inc    %edx
80103485:	39 da                	cmp    %ebx,%edx
80103487:	74 21                	je     801034aa <mycpu+0x4a>
    if (cpus[i].apicid == apicid)
80103489:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010348c:	01 c0                	add    %eax,%eax
8010348e:	01 d0                	add    %edx,%eax
80103490:	c1 e0 04             	shl    $0x4,%eax
80103493:	0f b6 b0 a0 17 11 80 	movzbl -0x7feee860(%eax),%esi
8010349a:	39 ce                	cmp    %ecx,%esi
8010349c:	75 e6                	jne    80103484 <mycpu+0x24>
      return &cpus[i];
8010349e:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801034a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a6:	5b                   	pop    %ebx
801034a7:	5e                   	pop    %esi
801034a8:	5d                   	pop    %ebp
801034a9:	c3                   	ret
  panic("unknown apicid\n");
801034aa:	83 ec 0c             	sub    $0xc,%esp
801034ad:	68 bd 6c 10 80       	push   $0x80106cbd
801034b2:	e8 81 ce ff ff       	call   80100338 <panic>
    panic("mycpu called with interrupts enabled\n");
801034b7:	83 ec 0c             	sub    $0xc,%esp
801034ba:	68 0c 70 10 80       	push   $0x8010700c
801034bf:	e8 74 ce ff ff       	call   80100338 <panic>

801034c4 <cpuid>:
cpuid() {
801034c4:	55                   	push   %ebp
801034c5:	89 e5                	mov    %esp,%ebp
801034c7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801034ca:	e8 91 ff ff ff       	call   80103460 <mycpu>
801034cf:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801034d4:	c1 f8 04             	sar    $0x4,%eax
801034d7:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
801034da:	89 ca                	mov    %ecx,%edx
801034dc:	c1 e2 05             	shl    $0x5,%edx
801034df:	29 ca                	sub    %ecx,%edx
801034e1:	8d 14 90             	lea    (%eax,%edx,4),%edx
801034e4:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
801034e7:	89 ca                	mov    %ecx,%edx
801034e9:	c1 e2 0f             	shl    $0xf,%edx
801034ec:	29 ca                	sub    %ecx,%edx
801034ee:	8d 04 90             	lea    (%eax,%edx,4),%eax
801034f1:	f7 d8                	neg    %eax
}
801034f3:	c9                   	leave
801034f4:	c3                   	ret
801034f5:	8d 76 00             	lea    0x0(%esi),%esi

801034f8 <myproc>:
myproc(void) {
801034f8:	55                   	push   %ebp
801034f9:	89 e5                	mov    %esp,%ebp
801034fb:	53                   	push   %ebx
801034fc:	50                   	push   %eax
  pushcli();
801034fd:	e8 a6 0b 00 00       	call   801040a8 <pushcli>
  c = mycpu();
80103502:	e8 59 ff ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103507:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010350d:	e8 e2 0b 00 00       	call   801040f4 <popcli>
}
80103512:	89 d8                	mov    %ebx,%eax
80103514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103517:	c9                   	leave
80103518:	c3                   	ret
80103519:	8d 76 00             	lea    0x0(%esi),%esi

8010351c <userinit>:
{
8010351c:	55                   	push   %ebp
8010351d:	89 e5                	mov    %esp,%ebp
8010351f:	53                   	push   %ebx
80103520:	51                   	push   %ecx
  p = allocproc();
80103521:	e8 12 fe ff ff       	call   80103338 <allocproc>
80103526:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103528:	a3 20 1d 11 80       	mov    %eax,0x80111d20
  if((p->pgdir = setupkvm()) == 0)
8010352d:	e8 42 32 00 00       	call   80106774 <setupkvm>
80103532:	89 43 2c             	mov    %eax,0x2c(%ebx)
80103535:	85 c0                	test   %eax,%eax
80103537:	0f 84 ba 00 00 00    	je     801035f7 <userinit+0xdb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010353d:	52                   	push   %edx
8010353e:	68 2c 00 00 00       	push   $0x2c
80103543:	68 60 a4 10 80       	push   $0x8010a460
80103548:	50                   	push   %eax
80103549:	e8 5a 2f 00 00       	call   801064a8 <inituvm>
  p->sz = PGSIZE;
8010354e:	c7 43 28 00 10 00 00 	movl   $0x1000,0x28(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103555:	83 c4 0c             	add    $0xc,%esp
80103558:	6a 4c                	push   $0x4c
8010355a:	6a 00                	push   $0x0
8010355c:	ff 73 40             	push   0x40(%ebx)
8010355f:	e8 54 0d 00 00       	call   801042b8 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103564:	8b 43 40             	mov    0x40(%ebx),%eax
80103567:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010356d:	8b 43 40             	mov    0x40(%ebx),%eax
80103570:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103576:	8b 43 40             	mov    0x40(%ebx),%eax
80103579:	8b 50 2c             	mov    0x2c(%eax),%edx
8010357c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103580:	8b 43 40             	mov    0x40(%ebx),%eax
80103583:	8b 50 2c             	mov    0x2c(%eax),%edx
80103586:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010358a:	8b 43 40             	mov    0x40(%ebx),%eax
8010358d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103594:	8b 43 40             	mov    0x40(%ebx),%eax
80103597:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010359e:	8b 43 40             	mov    0x40(%ebx),%eax
801035a1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801035a8:	83 c4 0c             	add    $0xc,%esp
801035ab:	6a 10                	push   $0x10
801035ad:	68 e6 6c 10 80       	push   $0x80106ce6
801035b2:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax
801035b8:	50                   	push   %eax
801035b9:	e8 42 0e 00 00       	call   80104400 <safestrcpy>
  p->cwd = namei("/");
801035be:	c7 04 24 ef 6c 10 80 	movl   $0x80106cef,(%esp)
801035c5:	e8 aa e8 ff ff       	call   80101e74 <namei>
801035ca:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  acquire(&ptable.lock);
801035d0:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801035d7:	e8 10 0c 00 00       	call   801041ec <acquire>
  p->state = RUNNABLE;
801035dc:	c7 43 34 04 00 00 00 	movl   $0x4,0x34(%ebx)
  release(&ptable.lock);
801035e3:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801035ea:	e8 9d 0b 00 00       	call   8010418c <release>
}
801035ef:	83 c4 10             	add    $0x10,%esp
801035f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035f5:	c9                   	leave
801035f6:	c3                   	ret
    panic("userinit: out of memory?");
801035f7:	83 ec 0c             	sub    $0xc,%esp
801035fa:	68 cd 6c 10 80       	push   $0x80106ccd
801035ff:	e8 34 cd ff ff       	call   80100338 <panic>

80103604 <growproc>:
{
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	56                   	push   %esi
80103608:	53                   	push   %ebx
80103609:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010360c:	e8 97 0a 00 00       	call   801040a8 <pushcli>
  c = mycpu();
80103611:	e8 4a fe ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103616:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010361c:	e8 d3 0a 00 00       	call   801040f4 <popcli>
  sz = curproc->sz;
80103621:	8b 43 28             	mov    0x28(%ebx),%eax
  if(n > 0){
80103624:	85 f6                	test   %esi,%esi
80103626:	7f 1c                	jg     80103644 <growproc+0x40>
  } else if(n < 0){
80103628:	75 36                	jne    80103660 <growproc+0x5c>
  curproc->sz = sz;
8010362a:	89 43 28             	mov    %eax,0x28(%ebx)
  switchuvm(curproc);
8010362d:	83 ec 0c             	sub    $0xc,%esp
80103630:	53                   	push   %ebx
80103631:	e8 76 2d 00 00       	call   801063ac <switchuvm>
  return 0;
80103636:	83 c4 10             	add    $0x10,%esp
80103639:	31 c0                	xor    %eax,%eax
}
8010363b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010363e:	5b                   	pop    %ebx
8010363f:	5e                   	pop    %esi
80103640:	5d                   	pop    %ebp
80103641:	c3                   	ret
80103642:	66 90                	xchg   %ax,%ax
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103644:	51                   	push   %ecx
80103645:	01 c6                	add    %eax,%esi
80103647:	56                   	push   %esi
80103648:	50                   	push   %eax
80103649:	ff 73 2c             	push   0x2c(%ebx)
8010364c:	e8 8f 2f 00 00       	call   801065e0 <allocuvm>
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	85 c0                	test   %eax,%eax
80103656:	75 d2                	jne    8010362a <growproc+0x26>
      return -1;
80103658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010365d:	eb dc                	jmp    8010363b <growproc+0x37>
8010365f:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103660:	52                   	push   %edx
80103661:	01 c6                	add    %eax,%esi
80103663:	56                   	push   %esi
80103664:	50                   	push   %eax
80103665:	ff 73 2c             	push   0x2c(%ebx)
80103668:	e8 7b 30 00 00       	call   801066e8 <deallocuvm>
8010366d:	83 c4 10             	add    $0x10,%esp
80103670:	85 c0                	test   %eax,%eax
80103672:	75 b6                	jne    8010362a <growproc+0x26>
80103674:	eb e2                	jmp    80103658 <growproc+0x54>
80103676:	66 90                	xchg   %ax,%ax

80103678 <fork>:
{
80103678:	55                   	push   %ebp
80103679:	89 e5                	mov    %esp,%ebp
8010367b:	57                   	push   %edi
8010367c:	56                   	push   %esi
8010367d:	53                   	push   %ebx
8010367e:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103681:	e8 22 0a 00 00       	call   801040a8 <pushcli>
  c = mycpu();
80103686:	e8 d5 fd ff ff       	call   80103460 <mycpu>
  p = c->proc;
8010368b:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103691:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103694:	e8 5b 0a 00 00       	call   801040f4 <popcli>
  if((np = allocproc()) == 0){
80103699:	e8 9a fc ff ff       	call   80103338 <allocproc>
8010369e:	85 c0                	test   %eax,%eax
801036a0:	0f 84 0b 01 00 00    	je     801037b1 <fork+0x139>
801036a6:	89 c3                	mov    %eax,%ebx
np->creation_time = ticks;
801036a8:	a1 74 46 11 80       	mov    0x80114674,%eax
801036ad:	89 43 0c             	mov    %eax,0xc(%ebx)
np->has_started = 0;
801036b0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
np->total_run_time = 0;
801036b7:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
np->total_wait_time = 0;
801036be:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
np->context_switches = 0;
801036c5:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801036cc:	83 ec 08             	sub    $0x8,%esp
801036cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036d2:	ff 72 28             	push   0x28(%edx)
801036d5:	ff 72 2c             	push   0x2c(%edx)
801036d8:	e8 6b 31 00 00       	call   80106848 <copyuvm>
801036dd:	89 43 2c             	mov    %eax,0x2c(%ebx)
801036e0:	83 c4 10             	add    $0x10,%esp
801036e3:	85 c0                	test   %eax,%eax
801036e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036e8:	0f 84 a7 00 00 00    	je     80103795 <fork+0x11d>
  np->sz = curproc->sz;
801036ee:	8b 42 28             	mov    0x28(%edx),%eax
801036f1:	89 43 28             	mov    %eax,0x28(%ebx)
  np->parent = curproc;
801036f4:	89 53 3c             	mov    %edx,0x3c(%ebx)
  *np->tf = *curproc->tf;
801036f7:	8b 72 40             	mov    0x40(%edx),%esi
801036fa:	b9 13 00 00 00       	mov    $0x13,%ecx
801036ff:	8b 7b 40             	mov    0x40(%ebx),%edi
80103702:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103704:	8b 43 40             	mov    0x40(%ebx),%eax
80103707:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010370e:	31 f6                	xor    %esi,%esi
    if(curproc->ofile[i])
80103710:	8b 44 b2 50          	mov    0x50(%edx,%esi,4),%eax
80103714:	85 c0                	test   %eax,%eax
80103716:	74 16                	je     8010372e <fork+0xb6>
80103718:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->ofile[i] = filedup(curproc->ofile[i]);
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	50                   	push   %eax
8010371f:	e8 e4 d6 ff ff       	call   80100e08 <filedup>
80103724:	89 44 b3 50          	mov    %eax,0x50(%ebx,%esi,4)
80103728:	83 c4 10             	add    $0x10,%esp
8010372b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for(i = 0; i < NOFILE; i++)
8010372e:	46                   	inc    %esi
8010372f:	83 fe 10             	cmp    $0x10,%esi
80103732:	75 dc                	jne    80103710 <fork+0x98>
  np->cwd = idup(curproc->cwd);
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	ff b2 90 00 00 00    	push   0x90(%edx)
8010373d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103740:	e8 af de ff ff       	call   801015f4 <idup>
80103745:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010374b:	83 c4 0c             	add    $0xc,%esp
8010374e:	6a 10                	push   $0x10
80103750:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103753:	81 c2 94 00 00 00    	add    $0x94,%edx
80103759:	52                   	push   %edx
8010375a:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax
80103760:	50                   	push   %eax
80103761:	e8 9a 0c 00 00       	call   80104400 <safestrcpy>
  pid = np->pid;
80103766:	8b 73 38             	mov    0x38(%ebx),%esi
  acquire(&ptable.lock);
80103769:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103770:	e8 77 0a 00 00       	call   801041ec <acquire>
  np->state = RUNNABLE;
80103775:	c7 43 34 04 00 00 00 	movl   $0x4,0x34(%ebx)
  release(&ptable.lock);
8010377c:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103783:	e8 04 0a 00 00       	call   8010418c <release>
  return pid;
80103788:	83 c4 10             	add    $0x10,%esp
}
8010378b:	89 f0                	mov    %esi,%eax
8010378d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103790:	5b                   	pop    %ebx
80103791:	5e                   	pop    %esi
80103792:	5f                   	pop    %edi
80103793:	5d                   	pop    %ebp
80103794:	c3                   	ret
    kfree(np->kstack);
80103795:	83 ec 0c             	sub    $0xc,%esp
80103798:	ff 73 30             	push   0x30(%ebx)
8010379b:	e8 64 ea ff ff       	call   80102204 <kfree>
    np->kstack = 0;
801037a0:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
    np->state = UNUSED;
801037a7:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
    return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
    return -1;
801037b1:	be ff ff ff ff       	mov    $0xffffffff,%esi
801037b6:	eb d3                	jmp    8010378b <fork+0x113>

801037b8 <sched>:
{
801037b8:	55                   	push   %ebp
801037b9:	89 e5                	mov    %esp,%ebp
801037bb:	56                   	push   %esi
801037bc:	53                   	push   %ebx
  pushcli();
801037bd:	e8 e6 08 00 00       	call   801040a8 <pushcli>
  c = mycpu();
801037c2:	e8 99 fc ff ff       	call   80103460 <mycpu>
  p = c->proc;
801037c7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037cd:	e8 22 09 00 00       	call   801040f4 <popcli>
  if(!holding(&ptable.lock))
801037d2:	83 ec 0c             	sub    $0xc,%esp
801037d5:	68 40 1d 11 80       	push   $0x80111d40
801037da:	e8 6d 09 00 00       	call   8010414c <holding>
801037df:	83 c4 10             	add    $0x10,%esp
801037e2:	85 c0                	test   %eax,%eax
801037e4:	74 4f                	je     80103835 <sched+0x7d>
  if(mycpu()->ncli != 1)
801037e6:	e8 75 fc ff ff       	call   80103460 <mycpu>
801037eb:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801037f2:	75 68                	jne    8010385c <sched+0xa4>
  if(p->state == RUNNING)
801037f4:	83 7b 34 05          	cmpl   $0x5,0x34(%ebx)
801037f8:	74 55                	je     8010384f <sched+0x97>
801037fa:	9c                   	pushf
801037fb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037fc:	f6 c4 02             	test   $0x2,%ah
801037ff:	75 41                	jne    80103842 <sched+0x8a>
  intena = mycpu()->intena;
80103801:	e8 5a fc ff ff       	call   80103460 <mycpu>
80103806:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010380c:	e8 4f fc ff ff       	call   80103460 <mycpu>
80103811:	83 ec 08             	sub    $0x8,%esp
80103814:	ff 70 04             	push   0x4(%eax)
80103817:	83 c3 44             	add    $0x44,%ebx
8010381a:	53                   	push   %ebx
8010381b:	e8 2d 0c 00 00       	call   8010444d <swtch>
  mycpu()->intena = intena;
80103820:	e8 3b fc ff ff       	call   80103460 <mycpu>
80103825:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010382b:	83 c4 10             	add    $0x10,%esp
8010382e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103831:	5b                   	pop    %ebx
80103832:	5e                   	pop    %esi
80103833:	5d                   	pop    %ebp
80103834:	c3                   	ret
    panic("sched ptable.lock");
80103835:	83 ec 0c             	sub    $0xc,%esp
80103838:	68 f1 6c 10 80       	push   $0x80106cf1
8010383d:	e8 f6 ca ff ff       	call   80100338 <panic>
    panic("sched interruptible");
80103842:	83 ec 0c             	sub    $0xc,%esp
80103845:	68 1d 6d 10 80       	push   $0x80106d1d
8010384a:	e8 e9 ca ff ff       	call   80100338 <panic>
    panic("sched running");
8010384f:	83 ec 0c             	sub    $0xc,%esp
80103852:	68 0f 6d 10 80       	push   $0x80106d0f
80103857:	e8 dc ca ff ff       	call   80100338 <panic>
    panic("sched locks");
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	68 03 6d 10 80       	push   $0x80106d03
80103864:	e8 cf ca ff ff       	call   80100338 <panic>
80103869:	8d 76 00             	lea    0x0(%esi),%esi

8010386c <exit>:
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	57                   	push   %edi
80103870:	56                   	push   %esi
80103871:	53                   	push   %ebx
80103872:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103875:	e8 7e fc ff ff       	call   801034f8 <myproc>
  if(curproc == initproc)
8010387a:	39 05 20 1d 11 80    	cmp    %eax,0x80111d20
80103880:	0f 84 07 01 00 00    	je     8010398d <exit+0x121>
80103886:	89 c3                	mov    %eax,%ebx
80103888:	8d 70 50             	lea    0x50(%eax),%esi
8010388b:	8d b8 90 00 00 00    	lea    0x90(%eax),%edi
80103891:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103894:	8b 06                	mov    (%esi),%eax
80103896:	85 c0                	test   %eax,%eax
80103898:	74 12                	je     801038ac <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010389a:	83 ec 0c             	sub    $0xc,%esp
8010389d:	50                   	push   %eax
8010389e:	e8 a9 d5 ff ff       	call   80100e4c <fileclose>
      curproc->ofile[fd] = 0;
801038a3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038a9:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801038ac:	83 c6 04             	add    $0x4,%esi
801038af:	39 f7                	cmp    %esi,%edi
801038b1:	75 e1                	jne    80103894 <exit+0x28>
  begin_op();
801038b3:	e8 04 f1 ff ff       	call   801029bc <begin_op>
  iput(curproc->cwd);
801038b8:	83 ec 0c             	sub    $0xc,%esp
801038bb:	ff b3 90 00 00 00    	push   0x90(%ebx)
801038c1:	e8 66 de ff ff       	call   8010172c <iput>
  end_op();
801038c6:	e8 59 f1 ff ff       	call   80102a24 <end_op>
  curproc->cwd = 0;
801038cb:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801038d2:	00 00 00 
  acquire(&ptable.lock);
801038d5:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801038dc:	e8 0b 09 00 00       	call   801041ec <acquire>
  wakeup1(curproc->parent);
801038e1:	8b 53 3c             	mov    0x3c(%ebx),%edx
801038e4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e7:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
801038ec:	eb 0e                	jmp    801038fc <exit+0x90>
801038ee:	66 90                	xchg   %ax,%ax
801038f0:	05 a4 00 00 00       	add    $0xa4,%eax
801038f5:	3d 74 46 11 80       	cmp    $0x80114674,%eax
801038fa:	74 1e                	je     8010391a <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801038fc:	83 78 34 02          	cmpl   $0x2,0x34(%eax)
80103900:	75 ee                	jne    801038f0 <exit+0x84>
80103902:	3b 50 48             	cmp    0x48(%eax),%edx
80103905:	75 e9                	jne    801038f0 <exit+0x84>
      p->state = RUNNABLE;
80103907:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010390e:	05 a4 00 00 00       	add    $0xa4,%eax
80103913:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103918:	75 e2                	jne    801038fc <exit+0x90>
      p->parent = initproc;
8010391a:	8b 0d 20 1d 11 80    	mov    0x80111d20,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103920:	ba 74 1d 11 80       	mov    $0x80111d74,%edx
80103925:	eb 0f                	jmp    80103936 <exit+0xca>
80103927:	90                   	nop
80103928:	81 c2 a4 00 00 00    	add    $0xa4,%edx
8010392e:	81 fa 74 46 11 80    	cmp    $0x80114674,%edx
80103934:	74 36                	je     8010396c <exit+0x100>
    if(p->parent == curproc){
80103936:	39 5a 3c             	cmp    %ebx,0x3c(%edx)
80103939:	75 ed                	jne    80103928 <exit+0xbc>
      p->parent = initproc;
8010393b:	89 4a 3c             	mov    %ecx,0x3c(%edx)
      if(p->state == ZOMBIE)
8010393e:	83 7a 34 06          	cmpl   $0x6,0x34(%edx)
80103942:	75 e4                	jne    80103928 <exit+0xbc>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103944:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103949:	eb 0d                	jmp    80103958 <exit+0xec>
8010394b:	90                   	nop
8010394c:	05 a4 00 00 00       	add    $0xa4,%eax
80103951:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103956:	74 d0                	je     80103928 <exit+0xbc>
    if(p->state == SLEEPING && p->chan == chan)
80103958:	83 78 34 02          	cmpl   $0x2,0x34(%eax)
8010395c:	75 ee                	jne    8010394c <exit+0xe0>
8010395e:	3b 48 48             	cmp    0x48(%eax),%ecx
80103961:	75 e9                	jne    8010394c <exit+0xe0>
      p->state = RUNNABLE;
80103963:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
8010396a:	eb e0                	jmp    8010394c <exit+0xe0>
curproc->end_time = ticks;
8010396c:	a1 74 46 11 80       	mov    0x80114674,%eax
80103971:	89 43 10             	mov    %eax,0x10(%ebx)
  curproc->state = ZOMBIE;
80103974:	c7 43 34 06 00 00 00 	movl   $0x6,0x34(%ebx)
  sched();
8010397b:	e8 38 fe ff ff       	call   801037b8 <sched>
  panic("zombie exit");
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	68 3e 6d 10 80       	push   $0x80106d3e
80103988:	e8 ab c9 ff ff       	call   80100338 <panic>
    panic("init exiting");
8010398d:	83 ec 0c             	sub    $0xc,%esp
80103990:	68 31 6d 10 80       	push   $0x80106d31
80103995:	e8 9e c9 ff ff       	call   80100338 <panic>
8010399a:	66 90                	xchg   %ax,%ax

8010399c <wait>:
{
8010399c:	55                   	push   %ebp
8010399d:	89 e5                	mov    %esp,%ebp
8010399f:	56                   	push   %esi
801039a0:	53                   	push   %ebx
  pushcli();
801039a1:	e8 02 07 00 00       	call   801040a8 <pushcli>
  c = mycpu();
801039a6:	e8 b5 fa ff ff       	call   80103460 <mycpu>
  p = c->proc;
801039ab:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801039b1:	e8 3e 07 00 00       	call   801040f4 <popcli>
  acquire(&ptable.lock);
801039b6:	83 ec 0c             	sub    $0xc,%esp
801039b9:	68 40 1d 11 80       	push   $0x80111d40
801039be:	e8 29 08 00 00       	call   801041ec <acquire>
801039c3:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801039c6:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c8:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
801039cd:	eb 0f                	jmp    801039de <wait+0x42>
801039cf:	90                   	nop
801039d0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801039d6:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
801039dc:	74 1e                	je     801039fc <wait+0x60>
      if(p->parent != curproc)
801039de:	39 73 3c             	cmp    %esi,0x3c(%ebx)
801039e1:	75 ed                	jne    801039d0 <wait+0x34>
      if(p->state == ZOMBIE){
801039e3:	83 7b 34 06          	cmpl   $0x6,0x34(%ebx)
801039e7:	74 5b                	je     80103a44 <wait+0xa8>
      havekids = 1;
801039e9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039ee:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801039f4:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
801039fa:	75 e2                	jne    801039de <wait+0x42>
    if(!havekids || curproc->killed){
801039fc:	85 c0                	test   %eax,%eax
801039fe:	0f 84 99 00 00 00    	je     80103a9d <wait+0x101>
80103a04:	8b 46 4c             	mov    0x4c(%esi),%eax
80103a07:	85 c0                	test   %eax,%eax
80103a09:	0f 85 8e 00 00 00    	jne    80103a9d <wait+0x101>
  pushcli();
80103a0f:	e8 94 06 00 00       	call   801040a8 <pushcli>
  c = mycpu();
80103a14:	e8 47 fa ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103a19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a1f:	e8 d0 06 00 00       	call   801040f4 <popcli>
  if(p == 0)
80103a24:	85 db                	test   %ebx,%ebx
80103a26:	0f 84 88 00 00 00    	je     80103ab4 <wait+0x118>
  p->chan = chan;
80103a2c:	89 73 48             	mov    %esi,0x48(%ebx)
  p->state = SLEEPING;
80103a2f:	c7 43 34 02 00 00 00 	movl   $0x2,0x34(%ebx)
  sched();
80103a36:	e8 7d fd ff ff       	call   801037b8 <sched>
  p->chan = 0;
80103a3b:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
}
80103a42:	eb 82                	jmp    801039c6 <wait+0x2a>
        pid = p->pid;
80103a44:	8b 73 38             	mov    0x38(%ebx),%esi
        kfree(p->kstack);
80103a47:	83 ec 0c             	sub    $0xc,%esp
80103a4a:	ff 73 30             	push   0x30(%ebx)
80103a4d:	e8 b2 e7 ff ff       	call   80102204 <kfree>
        p->kstack = 0;
80103a52:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        freevm(p->pgdir);
80103a59:	5a                   	pop    %edx
80103a5a:	ff 73 2c             	push   0x2c(%ebx)
80103a5d:	e8 a2 2c 00 00       	call   80106704 <freevm>
        p->pid = 0;
80103a62:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
        p->parent = 0;
80103a69:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
        p->name[0] = 0;
80103a70:	c6 83 94 00 00 00 00 	movb   $0x0,0x94(%ebx)
        p->killed = 0;
80103a77:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
        p->state = UNUSED;
80103a7e:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
        release(&ptable.lock);
80103a85:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103a8c:	e8 fb 06 00 00       	call   8010418c <release>
        return pid;
80103a91:	83 c4 10             	add    $0x10,%esp
}
80103a94:	89 f0                	mov    %esi,%eax
80103a96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a99:	5b                   	pop    %ebx
80103a9a:	5e                   	pop    %esi
80103a9b:	5d                   	pop    %ebp
80103a9c:	c3                   	ret
      release(&ptable.lock);
80103a9d:	83 ec 0c             	sub    $0xc,%esp
80103aa0:	68 40 1d 11 80       	push   $0x80111d40
80103aa5:	e8 e2 06 00 00       	call   8010418c <release>
      return -1;
80103aaa:	83 c4 10             	add    $0x10,%esp
80103aad:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103ab2:	eb e0                	jmp    80103a94 <wait+0xf8>
    panic("sleep");
80103ab4:	83 ec 0c             	sub    $0xc,%esp
80103ab7:	68 4a 6d 10 80       	push   $0x80106d4a
80103abc:	e8 77 c8 ff ff       	call   80100338 <panic>
80103ac1:	8d 76 00             	lea    0x0(%esi),%esi

80103ac4 <yield>:
{
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	53                   	push   %ebx
80103ac8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103acb:	68 40 1d 11 80       	push   $0x80111d40
80103ad0:	e8 17 07 00 00       	call   801041ec <acquire>
  pushcli();
80103ad5:	e8 ce 05 00 00       	call   801040a8 <pushcli>
  c = mycpu();
80103ada:	e8 81 f9 ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103adf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae5:	e8 0a 06 00 00       	call   801040f4 <popcli>
  myproc()->state = RUNNABLE;
80103aea:	c7 43 34 04 00 00 00 	movl   $0x4,0x34(%ebx)
  sched();
80103af1:	e8 c2 fc ff ff       	call   801037b8 <sched>
  release(&ptable.lock);
80103af6:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103afd:	e8 8a 06 00 00       	call   8010418c <release>
}
80103b02:	83 c4 10             	add    $0x10,%esp
80103b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b08:	c9                   	leave
80103b09:	c3                   	ret
80103b0a:	66 90                	xchg   %ax,%ax

80103b0c <sleep>:
{
80103b0c:	55                   	push   %ebp
80103b0d:	89 e5                	mov    %esp,%ebp
80103b0f:	57                   	push   %edi
80103b10:	56                   	push   %esi
80103b11:	53                   	push   %ebx
80103b12:	83 ec 0c             	sub    $0xc,%esp
80103b15:	8b 7d 08             	mov    0x8(%ebp),%edi
80103b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103b1b:	e8 88 05 00 00       	call   801040a8 <pushcli>
  c = mycpu();
80103b20:	e8 3b f9 ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103b25:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b2b:	e8 c4 05 00 00       	call   801040f4 <popcli>
  if(p == 0)
80103b30:	85 db                	test   %ebx,%ebx
80103b32:	0f 84 83 00 00 00    	je     80103bbb <sleep+0xaf>
  if(lk == 0)
80103b38:	85 f6                	test   %esi,%esi
80103b3a:	74 72                	je     80103bae <sleep+0xa2>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103b3c:	81 fe 40 1d 11 80    	cmp    $0x80111d40,%esi
80103b42:	74 4c                	je     80103b90 <sleep+0x84>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103b44:	83 ec 0c             	sub    $0xc,%esp
80103b47:	68 40 1d 11 80       	push   $0x80111d40
80103b4c:	e8 9b 06 00 00       	call   801041ec <acquire>
    release(lk);
80103b51:	89 34 24             	mov    %esi,(%esp)
80103b54:	e8 33 06 00 00       	call   8010418c <release>
  p->chan = chan;
80103b59:	89 7b 48             	mov    %edi,0x48(%ebx)
  p->state = SLEEPING;
80103b5c:	c7 43 34 02 00 00 00 	movl   $0x2,0x34(%ebx)
  sched();
80103b63:	e8 50 fc ff ff       	call   801037b8 <sched>
  p->chan = 0;
80103b68:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
    release(&ptable.lock);
80103b6f:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103b76:	e8 11 06 00 00       	call   8010418c <release>
    acquire(lk);
80103b7b:	83 c4 10             	add    $0x10,%esp
80103b7e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b84:	5b                   	pop    %ebx
80103b85:	5e                   	pop    %esi
80103b86:	5f                   	pop    %edi
80103b87:	5d                   	pop    %ebp
    acquire(lk);
80103b88:	e9 5f 06 00 00       	jmp    801041ec <acquire>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103b90:	89 7b 48             	mov    %edi,0x48(%ebx)
  p->state = SLEEPING;
80103b93:	c7 43 34 02 00 00 00 	movl   $0x2,0x34(%ebx)
  sched();
80103b9a:	e8 19 fc ff ff       	call   801037b8 <sched>
  p->chan = 0;
80103b9f:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
}
80103ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ba9:	5b                   	pop    %ebx
80103baa:	5e                   	pop    %esi
80103bab:	5f                   	pop    %edi
80103bac:	5d                   	pop    %ebp
80103bad:	c3                   	ret
    panic("sleep without lk");
80103bae:	83 ec 0c             	sub    $0xc,%esp
80103bb1:	68 50 6d 10 80       	push   $0x80106d50
80103bb6:	e8 7d c7 ff ff       	call   80100338 <panic>
    panic("sleep");
80103bbb:	83 ec 0c             	sub    $0xc,%esp
80103bbe:	68 4a 6d 10 80       	push   $0x80106d4a
80103bc3:	e8 70 c7 ff ff       	call   80100338 <panic>

80103bc8 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103bc8:	55                   	push   %ebp
80103bc9:	89 e5                	mov    %esp,%ebp
80103bcb:	53                   	push   %ebx
80103bcc:	83 ec 10             	sub    $0x10,%esp
80103bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103bd2:	68 40 1d 11 80       	push   $0x80111d40
80103bd7:	e8 10 06 00 00       	call   801041ec <acquire>
80103bdc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bdf:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103be4:	eb 0e                	jmp    80103bf4 <wakeup+0x2c>
80103be6:	66 90                	xchg   %ax,%ax
80103be8:	05 a4 00 00 00       	add    $0xa4,%eax
80103bed:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103bf2:	74 1e                	je     80103c12 <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103bf4:	83 78 34 02          	cmpl   $0x2,0x34(%eax)
80103bf8:	75 ee                	jne    80103be8 <wakeup+0x20>
80103bfa:	3b 58 48             	cmp    0x48(%eax),%ebx
80103bfd:	75 e9                	jne    80103be8 <wakeup+0x20>
      p->state = RUNNABLE;
80103bff:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c06:	05 a4 00 00 00       	add    $0xa4,%eax
80103c0b:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103c10:	75 e2                	jne    80103bf4 <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103c12:	c7 45 08 40 1d 11 80 	movl   $0x80111d40,0x8(%ebp)
}
80103c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1c:	c9                   	leave
  release(&ptable.lock);
80103c1d:	e9 6a 05 00 00       	jmp    8010418c <release>
80103c22:	66 90                	xchg   %ax,%ax

80103c24 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103c24:	55                   	push   %ebp
80103c25:	89 e5                	mov    %esp,%ebp
80103c27:	53                   	push   %ebx
80103c28:	83 ec 10             	sub    $0x10,%esp
80103c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103c2e:	68 40 1d 11 80       	push   $0x80111d40
80103c33:	e8 b4 05 00 00       	call   801041ec <acquire>
80103c38:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c3b:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103c40:	eb 0e                	jmp    80103c50 <kill+0x2c>
80103c42:	66 90                	xchg   %ax,%ax
80103c44:	05 a4 00 00 00       	add    $0xa4,%eax
80103c49:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103c4e:	74 30                	je     80103c80 <kill+0x5c>
    if(p->pid == pid){
80103c50:	39 58 38             	cmp    %ebx,0x38(%eax)
80103c53:	75 ef                	jne    80103c44 <kill+0x20>
      p->killed = 1;
80103c55:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103c5c:	83 78 34 02          	cmpl   $0x2,0x34(%eax)
80103c60:	75 07                	jne    80103c69 <kill+0x45>
        p->state = RUNNABLE;
80103c62:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
      release(&ptable.lock);
80103c69:	83 ec 0c             	sub    $0xc,%esp
80103c6c:	68 40 1d 11 80       	push   $0x80111d40
80103c71:	e8 16 05 00 00       	call   8010418c <release>
      return 0;
80103c76:	83 c4 10             	add    $0x10,%esp
80103c79:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7e:	c9                   	leave
80103c7f:	c3                   	ret
  release(&ptable.lock);
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 40 1d 11 80       	push   $0x80111d40
80103c88:	e8 ff 04 00 00       	call   8010418c <release>
  return -1;
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c98:	c9                   	leave
80103c99:	c3                   	ret
80103c9a:	66 90                	xchg   %ax,%ax

80103c9c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103c9c:	55                   	push   %ebp
80103c9d:	89 e5                	mov    %esp,%ebp
80103c9f:	57                   	push   %edi
80103ca0:	56                   	push   %esi
80103ca1:	53                   	push   %ebx
80103ca2:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca5:	bb 08 1e 11 80       	mov    $0x80111e08,%ebx
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103caa:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103cad:	eb 42                	jmp    80103cf1 <procdump+0x55>
80103caf:	90                   	nop
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103cb0:	8b 04 85 20 73 10 80 	mov    -0x7fef8ce0(,%eax,4),%eax
80103cb7:	85 c0                	test   %eax,%eax
80103cb9:	74 42                	je     80103cfd <procdump+0x61>
    cprintf("%d %s %s", p->pid, state, p->name);
80103cbb:	53                   	push   %ebx
80103cbc:	50                   	push   %eax
80103cbd:	ff 73 a4             	push   -0x5c(%ebx)
80103cc0:	68 65 6d 10 80       	push   $0x80106d65
80103cc5:	e8 56 c9 ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
80103cca:	83 c4 10             	add    $0x10,%esp
80103ccd:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103cd1:	74 31                	je     80103d04 <procdump+0x68>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103cd3:	83 ec 0c             	sub    $0xc,%esp
80103cd6:	68 1e 6f 10 80       	push   $0x80106f1e
80103cdb:	e8 40 c9 ff ff       	call   80100620 <cprintf>
80103ce0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce3:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80103ce9:	81 fb 08 47 11 80    	cmp    $0x80114708,%ebx
80103cef:	74 4f                	je     80103d40 <procdump+0xa4>
    if(p->state == UNUSED)
80103cf1:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 eb                	je     80103ce3 <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103cf8:	83 f8 06             	cmp    $0x6,%eax
80103cfb:	76 b3                	jbe    80103cb0 <procdump+0x14>
      state = "???";
80103cfd:	b8 61 6d 10 80       	mov    $0x80106d61,%eax
80103d02:	eb b7                	jmp    80103cbb <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103d04:	83 ec 08             	sub    $0x8,%esp
80103d07:	56                   	push   %esi
80103d08:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103d0b:	8b 40 0c             	mov    0xc(%eax),%eax
80103d0e:	83 c0 08             	add    $0x8,%eax
80103d11:	50                   	push   %eax
80103d12:	e8 29 03 00 00       	call   80104040 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d17:	89 f7                	mov    %esi,%edi
80103d19:	83 c4 10             	add    $0x10,%esp
80103d1c:	8b 07                	mov    (%edi),%eax
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	74 b1                	je     80103cd3 <procdump+0x37>
        cprintf(" %p", pc[i]);
80103d22:	83 ec 08             	sub    $0x8,%esp
80103d25:	50                   	push   %eax
80103d26:	68 a1 6a 10 80       	push   $0x80106aa1
80103d2b:	e8 f0 c8 ff ff       	call   80100620 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d30:	83 c7 04             	add    $0x4,%edi
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103d39:	39 c7                	cmp    %eax,%edi
80103d3b:	75 df                	jne    80103d1c <procdump+0x80>
80103d3d:	eb 94                	jmp    80103cd3 <procdump+0x37>
80103d3f:	90                   	nop
  }
}
80103d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d43:	5b                   	pop    %ebx
80103d44:	5e                   	pop    %esi
80103d45:	5f                   	pop    %edi
80103d46:	5d                   	pop    %ebp
80103d47:	c3                   	ret

80103d48 <sys_custom_fork>:



int sys_custom_fork(void) {
80103d48:	55                   	push   %ebp
80103d49:	89 e5                	mov    %esp,%ebp
80103d4b:	53                   	push   %ebx
80103d4c:	83 ec 1c             	sub    $0x1c,%esp
    int start_later, exec_time;
    if (argint(0, &start_later) < 0 || argint(1, &exec_time) < 0)
80103d4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80103d52:	50                   	push   %eax
80103d53:	6a 00                	push   $0x0
80103d55:	e8 82 07 00 00       	call   801044dc <argint>
80103d5a:	83 c4 10             	add    $0x10,%esp
80103d5d:	85 c0                	test   %eax,%eax
80103d5f:	78 63                	js     80103dc4 <sys_custom_fork+0x7c>
80103d61:	83 ec 08             	sub    $0x8,%esp
80103d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103d67:	50                   	push   %eax
80103d68:	6a 01                	push   $0x1
80103d6a:	e8 6d 07 00 00       	call   801044dc <argint>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	78 4e                	js     80103dc4 <sys_custom_fork+0x7c>
        return -1;

    int pid = fork();
80103d76:	e8 fd f8 ff ff       	call   80103678 <fork>
    if (pid < 0) return -1;
80103d7b:	85 c0                	test   %eax,%eax
80103d7d:	78 45                	js     80103dc4 <sys_custom_fork+0x7c>
    if (pid == 0) return 0; // Child process
80103d7f:	74 2f                	je     80103db0 <sys_custom_fork+0x68>

    // Parent: set flags on child
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d81:	ba 74 1d 11 80       	mov    $0x80111d74,%edx
80103d86:	eb 0e                	jmp    80103d96 <sys_custom_fork+0x4e>
80103d88:	81 c2 a4 00 00 00    	add    $0xa4,%edx
80103d8e:	81 fa 74 46 11 80    	cmp    $0x80114674,%edx
80103d94:	74 1a                	je     80103db0 <sys_custom_fork+0x68>
        if (p->pid == pid) {
80103d96:	39 42 38             	cmp    %eax,0x38(%edx)
80103d99:	75 ed                	jne    80103d88 <sys_custom_fork+0x40>
            p->start_later = start_later;
80103d9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80103d9e:	89 0a                	mov    %ecx,(%edx)
            p->exec_time = exec_time;
80103da0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103da3:	89 5a 04             	mov    %ebx,0x4(%edx)

            if (start_later == 1)
80103da6:	49                   	dec    %ecx
80103da7:	74 0f                	je     80103db8 <sys_custom_fork+0x70>
                p->state = WAITING_TO_START ;  // Mark it so scheduler won’t pick it up
            else
                p->state = RUNNABLE;
80103da9:	c7 42 34 04 00 00 00 	movl   $0x4,0x34(%edx)

            break;
        }
    }
    return pid;
}
80103db0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db3:	c9                   	leave
80103db4:	c3                   	ret
80103db5:	8d 76 00             	lea    0x0(%esi),%esi
                p->state = WAITING_TO_START ;  // Mark it so scheduler won’t pick it up
80103db8:	c7 42 34 03 00 00 00 	movl   $0x3,0x34(%edx)
}
80103dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dc2:	c9                   	leave
80103dc3:	c3                   	ret
        return -1;
80103dc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dc9:	eb e5                	jmp    80103db0 <sys_custom_fork+0x68>
80103dcb:	90                   	nop

80103dcc <sys_scheduler_start>:


int sys_scheduler_start(void) {
80103dcc:	55                   	push   %ebp
80103dcd:	89 e5                	mov    %esp,%ebp
80103dcf:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;
    acquire(&ptable.lock);
80103dd2:	68 40 1d 11 80       	push   $0x80111d40
80103dd7:	e8 10 04 00 00       	call   801041ec <acquire>
80103ddc:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ddf:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103de4:	eb 0e                	jmp    80103df4 <sys_scheduler_start+0x28>
80103de6:	66 90                	xchg   %ax,%ax
80103de8:	05 a4 00 00 00       	add    $0xa4,%eax
80103ded:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103df2:	74 24                	je     80103e18 <sys_scheduler_start+0x4c>
         if(p->start_later == 1 && p->state == WAITING_TO_START) {
80103df4:	83 38 01             	cmpl   $0x1,(%eax)
80103df7:	75 ef                	jne    80103de8 <sys_scheduler_start+0x1c>
80103df9:	83 78 34 03          	cmpl   $0x3,0x34(%eax)
80103dfd:	75 e9                	jne    80103de8 <sys_scheduler_start+0x1c>
              p->state = RUNNABLE;
80103dff:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
              p->start_later = 0;
80103e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e0c:	05 a4 00 00 00       	add    $0xa4,%eax
80103e11:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103e16:	75 dc                	jne    80103df4 <sys_scheduler_start+0x28>
          }

    }
    release(&ptable.lock);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	68 40 1d 11 80       	push   $0x80111d40
80103e20:	e8 67 03 00 00       	call   8010418c <release>
    return 0;
}
80103e25:	31 c0                	xor    %eax,%eax
80103e27:	c9                   	leave
80103e28:	c3                   	ret
80103e29:	8d 76 00             	lea    0x0(%esi),%esi

80103e2c <scheduler>:
// }



void scheduler(void)
{
80103e2c:	55                   	push   %ebp
80103e2d:	89 e5                	mov    %esp,%ebp
80103e2f:	57                   	push   %edi
80103e30:	56                   	push   %esi
80103e31:	53                   	push   %ebx
80103e32:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p, *chosen = 0;
  struct cpu *c = mycpu();
80103e35:	e8 26 f6 ff ff       	call   80103460 <mycpu>
80103e3a:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103e3c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e43:	00 00 00 
80103e46:	8d 70 04             	lea    0x4(%eax),%esi
80103e49:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e4c:	fb                   	sti
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Acquire ptable.lock to scan the process table.
    acquire(&ptable.lock);
80103e4d:	83 ec 0c             	sub    $0xc,%esp
80103e50:	68 40 1d 11 80       	push   $0x80111d40
80103e55:	e8 92 03 00 00       	call   801041ec <acquire>
80103e5a:	83 c4 10             	add    $0x10,%esp

    // First, select one RUNNABLE process to run.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5d:	bf 74 1d 11 80       	mov    $0x80111d74,%edi
      if(p->state != RUNNABLE)
80103e62:	83 7f 34 04          	cmpl   $0x4,0x34(%edi)
80103e66:	74 20                	je     80103e88 <scheduler+0x5c>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e68:	81 c7 a4 00 00 00    	add    $0xa4,%edi
80103e6e:	81 ff 74 46 11 80    	cmp    $0x80114674,%edi
80103e74:	75 ec                	jne    80103e62 <scheduler+0x36>

      // Process is done running for now.
      c->proc = 0;
      chosen = 0; // reset chosen pointer for the next iteration
    }
    release(&ptable.lock);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 40 1d 11 80       	push   $0x80111d40
80103e7e:	e8 09 03 00 00       	call   8010418c <release>
    sti();
80103e83:	83 c4 10             	add    $0x10,%esp
80103e86:	eb c4                	jmp    80103e4c <scheduler+0x20>
      if(p->has_started == 0) {
80103e88:	8b 4f 24             	mov    0x24(%edi),%ecx
80103e8b:	85 c9                	test   %ecx,%ecx
80103e8d:	75 0f                	jne    80103e9e <scheduler+0x72>
        p->first_run_time = ticks;
80103e8f:	a1 74 46 11 80       	mov    0x80114674,%eax
80103e94:	89 47 14             	mov    %eax,0x14(%edi)
        p->has_started = 1;
80103e97:	c7 47 24 01 00 00 00 	movl   $0x1,0x24(%edi)
      p->context_switches++;
80103e9e:	ff 47 20             	incl   0x20(%edi)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea1:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103ea6:	eb 0c                	jmp    80103eb4 <scheduler+0x88>
80103ea8:	05 a4 00 00 00       	add    $0xa4,%eax
80103ead:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103eb2:	74 19                	je     80103ecd <scheduler+0xa1>
        if(p->state == RUNNABLE && p != chosen)
80103eb4:	83 78 34 04          	cmpl   $0x4,0x34(%eax)
80103eb8:	75 ee                	jne    80103ea8 <scheduler+0x7c>
80103eba:	39 f8                	cmp    %edi,%eax
80103ebc:	74 ea                	je     80103ea8 <scheduler+0x7c>
          p->total_wait_time++;
80103ebe:	ff 40 1c             	incl   0x1c(%eax)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec1:	05 a4 00 00 00       	add    $0xa4,%eax
80103ec6:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103ecb:	75 e7                	jne    80103eb4 <scheduler+0x88>
      c->proc = chosen;
80103ecd:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(chosen);
80103ed3:	83 ec 0c             	sub    $0xc,%esp
80103ed6:	57                   	push   %edi
80103ed7:	e8 d0 24 00 00       	call   801063ac <switchuvm>
      chosen->state = RUNNING;
80103edc:	c7 47 34 05 00 00 00 	movl   $0x5,0x34(%edi)
      swtch(&(c->scheduler), chosen->context);
80103ee3:	58                   	pop    %eax
80103ee4:	5a                   	pop    %edx
80103ee5:	ff 77 44             	push   0x44(%edi)
80103ee8:	56                   	push   %esi
80103ee9:	e8 5f 05 00 00       	call   8010444d <swtch>
      switchkvm();
80103eee:	e8 a9 24 00 00       	call   8010639c <switchkvm>
      chosen->total_run_time++;
80103ef3:	ff 47 18             	incl   0x18(%edi)
      c->proc = 0;
80103ef6:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103efd:	00 00 00 
80103f00:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80103f03:	83 ec 0c             	sub    $0xc,%esp
80103f06:	68 40 1d 11 80       	push   $0x80111d40
80103f0b:	e8 7c 02 00 00       	call   8010418c <release>
    sti();
80103f10:	83 c4 10             	add    $0x10,%esp
80103f13:	e9 34 ff ff ff       	jmp    80103e4c <scheduler+0x20>

80103f18 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f18:	55                   	push   %ebp
80103f19:	89 e5                	mov    %esp,%ebp
80103f1b:	53                   	push   %ebx
80103f1c:	83 ec 0c             	sub    $0xc,%esp
80103f1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f22:	68 a7 6d 10 80       	push   $0x80106da7
80103f27:	8d 43 04             	lea    0x4(%ebx),%eax
80103f2a:	50                   	push   %eax
80103f2b:	e8 f4 00 00 00       	call   80104024 <initlock>
  lk->name = name;
80103f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f33:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103f36:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f3c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103f43:	83 c4 10             	add    $0x10,%esp
80103f46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f49:	c9                   	leave
80103f4a:	c3                   	ret
80103f4b:	90                   	nop

80103f4c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f4c:	55                   	push   %ebp
80103f4d:	89 e5                	mov    %esp,%ebp
80103f4f:	56                   	push   %esi
80103f50:	53                   	push   %ebx
80103f51:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f54:	8d 73 04             	lea    0x4(%ebx),%esi
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	56                   	push   %esi
80103f5b:	e8 8c 02 00 00       	call   801041ec <acquire>
  while (lk->locked) {
80103f60:	83 c4 10             	add    $0x10,%esp
80103f63:	8b 13                	mov    (%ebx),%edx
80103f65:	85 d2                	test   %edx,%edx
80103f67:	74 16                	je     80103f7f <acquiresleep+0x33>
80103f69:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	56                   	push   %esi
80103f70:	53                   	push   %ebx
80103f71:	e8 96 fb ff ff       	call   80103b0c <sleep>
  while (lk->locked) {
80103f76:	83 c4 10             	add    $0x10,%esp
80103f79:	8b 03                	mov    (%ebx),%eax
80103f7b:	85 c0                	test   %eax,%eax
80103f7d:	75 ed                	jne    80103f6c <acquiresleep+0x20>
  }
  lk->locked = 1;
80103f7f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103f85:	e8 6e f5 ff ff       	call   801034f8 <myproc>
80103f8a:	8b 40 38             	mov    0x38(%eax),%eax
80103f8d:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103f90:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103f93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f96:	5b                   	pop    %ebx
80103f97:	5e                   	pop    %esi
80103f98:	5d                   	pop    %ebp
  release(&lk->lk);
80103f99:	e9 ee 01 00 00       	jmp    8010418c <release>
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fa8:	8d 73 04             	lea    0x4(%ebx),%esi
80103fab:	83 ec 0c             	sub    $0xc,%esp
80103fae:	56                   	push   %esi
80103faf:	e8 38 02 00 00       	call   801041ec <acquire>
  lk->locked = 0;
80103fb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103fc1:	89 1c 24             	mov    %ebx,(%esp)
80103fc4:	e8 ff fb ff ff       	call   80103bc8 <wakeup>
  release(&lk->lk);
80103fc9:	83 c4 10             	add    $0x10,%esp
80103fcc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5d                   	pop    %ebp
  release(&lk->lk);
80103fd5:	e9 b2 01 00 00       	jmp    8010418c <release>
80103fda:	66 90                	xchg   %ax,%ax

80103fdc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103fdc:	55                   	push   %ebp
80103fdd:	89 e5                	mov    %esp,%ebp
80103fdf:	56                   	push   %esi
80103fe0:	53                   	push   %ebx
80103fe1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103fe4:	8d 73 04             	lea    0x4(%ebx),%esi
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	56                   	push   %esi
80103feb:	e8 fc 01 00 00       	call   801041ec <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103ff0:	83 c4 10             	add    $0x10,%esp
80103ff3:	8b 03                	mov    (%ebx),%eax
80103ff5:	85 c0                	test   %eax,%eax
80103ff7:	75 17                	jne    80104010 <holdingsleep+0x34>
80103ff9:	31 db                	xor    %ebx,%ebx
  release(&lk->lk);
80103ffb:	83 ec 0c             	sub    $0xc,%esp
80103ffe:	56                   	push   %esi
80103fff:	e8 88 01 00 00       	call   8010418c <release>
  return r;
}
80104004:	89 d8                	mov    %ebx,%eax
80104006:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104009:	5b                   	pop    %ebx
8010400a:	5e                   	pop    %esi
8010400b:	5d                   	pop    %ebp
8010400c:	c3                   	ret
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104010:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104013:	e8 e0 f4 ff ff       	call   801034f8 <myproc>
80104018:	39 58 38             	cmp    %ebx,0x38(%eax)
8010401b:	0f 94 c3             	sete   %bl
8010401e:	0f b6 db             	movzbl %bl,%ebx
80104021:	eb d8                	jmp    80103ffb <holdingsleep+0x1f>
80104023:	90                   	nop

80104024 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010402a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010402d:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104036:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010403d:	5d                   	pop    %ebp
8010403e:	c3                   	ret
8010403f:	90                   	nop

80104040 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104047:	8b 45 08             	mov    0x8(%ebp),%eax
8010404a:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010404d:	31 d2                	xor    %edx,%edx
8010404f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104050:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104056:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010405c:	77 16                	ja     80104074 <getcallerpcs+0x34>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010405e:	8b 58 04             	mov    0x4(%eax),%ebx
80104061:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80104064:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104066:	42                   	inc    %edx
80104067:	83 fa 0a             	cmp    $0xa,%edx
8010406a:	75 e4                	jne    80104050 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010406c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010406f:	c9                   	leave
80104070:	c3                   	ret
80104071:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104074:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104077:	83 c1 28             	add    $0x28,%ecx
8010407a:	89 ca                	mov    %ecx,%edx
8010407c:	29 c2                	sub    %eax,%edx
8010407e:	83 e2 04             	and    $0x4,%edx
80104081:	74 0d                	je     80104090 <getcallerpcs+0x50>
    pcs[i] = 0;
80104083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104089:	83 c0 04             	add    $0x4,%eax
8010408c:	39 c8                	cmp    %ecx,%eax
8010408e:	74 dc                	je     8010406c <getcallerpcs+0x2c>
    pcs[i] = 0;
80104090:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104096:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
8010409d:	83 c0 08             	add    $0x8,%eax
801040a0:	39 c8                	cmp    %ecx,%eax
801040a2:	75 ec                	jne    80104090 <getcallerpcs+0x50>
801040a4:	eb c6                	jmp    8010406c <getcallerpcs+0x2c>
801040a6:	66 90                	xchg   %ax,%ax

801040a8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801040a8:	55                   	push   %ebp
801040a9:	89 e5                	mov    %esp,%ebp
801040ab:	53                   	push   %ebx
801040ac:	50                   	push   %eax
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040ad:	9c                   	pushf
801040ae:	5b                   	pop    %ebx
  asm volatile("cli");
801040af:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801040b0:	e8 ab f3 ff ff       	call   80103460 <mycpu>
801040b5:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801040bb:	85 d2                	test   %edx,%edx
801040bd:	74 11                	je     801040d0 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801040bf:	e8 9c f3 ff ff       	call   80103460 <mycpu>
801040c4:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801040ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040cd:	c9                   	leave
801040ce:	c3                   	ret
801040cf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801040d0:	e8 8b f3 ff ff       	call   80103460 <mycpu>
801040d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801040db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801040e1:	e8 7a f3 ff ff       	call   80103460 <mycpu>
801040e6:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801040ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ef:	c9                   	leave
801040f0:	c3                   	ret
801040f1:	8d 76 00             	lea    0x0(%esi),%esi

801040f4 <popcli>:

void
popcli(void)
{
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040fa:	9c                   	pushf
801040fb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040fc:	f6 c4 02             	test   $0x2,%ah
801040ff:	75 31                	jne    80104132 <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104101:	e8 5a f3 ff ff       	call   80103460 <mycpu>
80104106:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
8010410c:	78 31                	js     8010413f <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010410e:	e8 4d f3 ff ff       	call   80103460 <mycpu>
80104113:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104119:	85 d2                	test   %edx,%edx
8010411b:	74 03                	je     80104120 <popcli+0x2c>
    sti();
}
8010411d:	c9                   	leave
8010411e:	c3                   	ret
8010411f:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104120:	e8 3b f3 ff ff       	call   80103460 <mycpu>
80104125:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010412b:	85 c0                	test   %eax,%eax
8010412d:	74 ee                	je     8010411d <popcli+0x29>
  asm volatile("sti");
8010412f:	fb                   	sti
}
80104130:	c9                   	leave
80104131:	c3                   	ret
    panic("popcli - interruptible");
80104132:	83 ec 0c             	sub    $0xc,%esp
80104135:	68 b2 6d 10 80       	push   $0x80106db2
8010413a:	e8 f9 c1 ff ff       	call   80100338 <panic>
    panic("popcli");
8010413f:	83 ec 0c             	sub    $0xc,%esp
80104142:	68 c9 6d 10 80       	push   $0x80106dc9
80104147:	e8 ec c1 ff ff       	call   80100338 <panic>

8010414c <holding>:
{
8010414c:	55                   	push   %ebp
8010414d:	89 e5                	mov    %esp,%ebp
8010414f:	53                   	push   %ebx
80104150:	50                   	push   %eax
80104151:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104154:	e8 4f ff ff ff       	call   801040a8 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104159:	8b 13                	mov    (%ebx),%edx
8010415b:	85 d2                	test   %edx,%edx
8010415d:	75 11                	jne    80104170 <holding+0x24>
8010415f:	31 db                	xor    %ebx,%ebx
  popcli();
80104161:	e8 8e ff ff ff       	call   801040f4 <popcli>
}
80104166:	89 d8                	mov    %ebx,%eax
80104168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010416b:	c9                   	leave
8010416c:	c3                   	ret
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104170:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104173:	e8 e8 f2 ff ff       	call   80103460 <mycpu>
80104178:	39 c3                	cmp    %eax,%ebx
8010417a:	0f 94 c3             	sete   %bl
8010417d:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104180:	e8 6f ff ff ff       	call   801040f4 <popcli>
}
80104185:	89 d8                	mov    %ebx,%eax
80104187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010418a:	c9                   	leave
8010418b:	c3                   	ret

8010418c <release>:
{
8010418c:	55                   	push   %ebp
8010418d:	89 e5                	mov    %esp,%ebp
8010418f:	56                   	push   %esi
80104190:	53                   	push   %ebx
80104191:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104194:	e8 0f ff ff ff       	call   801040a8 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104199:	8b 03                	mov    (%ebx),%eax
8010419b:	85 c0                	test   %eax,%eax
8010419d:	75 15                	jne    801041b4 <release+0x28>
  popcli();
8010419f:	e8 50 ff ff ff       	call   801040f4 <popcli>
    panic("release");
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	68 d0 6d 10 80       	push   $0x80106dd0
801041ac:	e8 87 c1 ff ff       	call   80100338 <panic>
801041b1:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801041b4:	8b 73 08             	mov    0x8(%ebx),%esi
801041b7:	e8 a4 f2 ff ff       	call   80103460 <mycpu>
801041bc:	39 c6                	cmp    %eax,%esi
801041be:	75 df                	jne    8010419f <release+0x13>
  popcli();
801041c0:	e8 2f ff ff ff       	call   801040f4 <popcli>
  lk->pcs[0] = 0;
801041c5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801041cc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801041d3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801041d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801041de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e1:	5b                   	pop    %ebx
801041e2:	5e                   	pop    %esi
801041e3:	5d                   	pop    %ebp
  popcli();
801041e4:	e9 0b ff ff ff       	jmp    801040f4 <popcli>
801041e9:	8d 76 00             	lea    0x0(%esi),%esi

801041ec <acquire>:
{
801041ec:	55                   	push   %ebp
801041ed:	89 e5                	mov    %esp,%ebp
801041ef:	53                   	push   %ebx
801041f0:	50                   	push   %eax
  pushcli(); // disable interrupts to avoid deadlock.
801041f1:	e8 b2 fe ff ff       	call   801040a8 <pushcli>
  if(holding(lk))
801041f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801041f9:	e8 aa fe ff ff       	call   801040a8 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801041fe:	8b 13                	mov    (%ebx),%edx
80104200:	85 d2                	test   %edx,%edx
80104202:	0f 85 8c 00 00 00    	jne    80104294 <acquire+0xa8>
  popcli();
80104208:	e8 e7 fe ff ff       	call   801040f4 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010420d:	b9 01 00 00 00       	mov    $0x1,%ecx
80104212:	66 90                	xchg   %ax,%ax
  while(xchg(&lk->locked, 1) != 0)
80104214:	8b 55 08             	mov    0x8(%ebp),%edx
80104217:	89 c8                	mov    %ecx,%eax
80104219:	f0 87 02             	lock xchg %eax,(%edx)
8010421c:	85 c0                	test   %eax,%eax
8010421e:	75 f4                	jne    80104214 <acquire+0x28>
  __sync_synchronize();
80104220:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104225:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104228:	e8 33 f2 ff ff       	call   80103460 <mycpu>
8010422d:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104230:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104233:	31 c0                	xor    %eax,%eax
  ebp = (uint*)v - 2;
80104235:	89 ea                	mov    %ebp,%edx
80104237:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104238:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010423e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104244:	77 16                	ja     8010425c <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104246:	8b 5a 04             	mov    0x4(%edx),%ebx
80104249:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
8010424d:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010424f:	40                   	inc    %eax
80104250:	83 f8 0a             	cmp    $0xa,%eax
80104253:	75 e3                	jne    80104238 <acquire+0x4c>
}
80104255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104258:	c9                   	leave
80104259:	c3                   	ret
8010425a:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
8010425c:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104260:	83 c1 34             	add    $0x34,%ecx
80104263:	89 ca                	mov    %ecx,%edx
80104265:	29 c2                	sub    %eax,%edx
80104267:	83 e2 04             	and    $0x4,%edx
8010426a:	74 10                	je     8010427c <acquire+0x90>
    pcs[i] = 0;
8010426c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104272:	83 c0 04             	add    $0x4,%eax
80104275:	39 c8                	cmp    %ecx,%eax
80104277:	74 dc                	je     80104255 <acquire+0x69>
80104279:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
8010427c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
80104289:	83 c0 08             	add    $0x8,%eax
8010428c:	39 c8                	cmp    %ecx,%eax
8010428e:	75 ec                	jne    8010427c <acquire+0x90>
80104290:	eb c3                	jmp    80104255 <acquire+0x69>
80104292:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104294:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104297:	e8 c4 f1 ff ff       	call   80103460 <mycpu>
8010429c:	39 c3                	cmp    %eax,%ebx
8010429e:	0f 85 64 ff ff ff    	jne    80104208 <acquire+0x1c>
  popcli();
801042a4:	e8 4b fe ff ff       	call   801040f4 <popcli>
    panic("acquire");
801042a9:	83 ec 0c             	sub    $0xc,%esp
801042ac:	68 d8 6d 10 80       	push   $0x80106dd8
801042b1:	e8 82 c0 ff ff       	call   80100338 <panic>
801042b6:	66 90                	xchg   %ax,%ax

801042b8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042b8:	55                   	push   %ebp
801042b9:	89 e5                	mov    %esp,%ebp
801042bb:	57                   	push   %edi
801042bc:	8b 55 08             	mov    0x8(%ebp),%edx
801042bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801042c2:	89 d0                	mov    %edx,%eax
801042c4:	09 c8                	or     %ecx,%eax
801042c6:	a8 03                	test   $0x3,%al
801042c8:	75 22                	jne    801042ec <memset+0x34>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042ca:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
801042cd:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042d1:	89 f8                	mov    %edi,%eax
801042d3:	c1 e0 08             	shl    $0x8,%eax
801042d6:	01 f8                	add    %edi,%eax
801042d8:	89 c7                	mov    %eax,%edi
801042da:	c1 e7 10             	shl    $0x10,%edi
801042dd:	01 f8                	add    %edi,%eax
  asm volatile("cld; rep stosl" :
801042df:	89 d7                	mov    %edx,%edi
801042e1:	fc                   	cld
801042e2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801042e4:	89 d0                	mov    %edx,%eax
801042e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
801042e9:	c9                   	leave
801042ea:	c3                   	ret
801042eb:	90                   	nop
  asm volatile("cld; rep stosb" :
801042ec:	89 d7                	mov    %edx,%edi
801042ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f1:	fc                   	cld
801042f2:	f3 aa                	rep stos %al,%es:(%edi)
801042f4:	89 d0                	mov    %edx,%eax
801042f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
801042f9:	c9                   	leave
801042fa:	c3                   	ret
801042fb:	90                   	nop

801042fc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042fc:	55                   	push   %ebp
801042fd:	89 e5                	mov    %esp,%ebp
801042ff:	56                   	push   %esi
80104300:	53                   	push   %ebx
80104301:	8b 45 08             	mov    0x8(%ebp),%eax
80104304:	8b 55 0c             	mov    0xc(%ebp),%edx
80104307:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010430a:	85 f6                	test   %esi,%esi
8010430c:	74 1e                	je     8010432c <memcmp+0x30>
8010430e:	01 c6                	add    %eax,%esi
80104310:	eb 08                	jmp    8010431a <memcmp+0x1e>
80104312:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104314:	40                   	inc    %eax
80104315:	42                   	inc    %edx
  while(n-- > 0){
80104316:	39 f0                	cmp    %esi,%eax
80104318:	74 12                	je     8010432c <memcmp+0x30>
    if(*s1 != *s2)
8010431a:	8a 08                	mov    (%eax),%cl
8010431c:	0f b6 1a             	movzbl (%edx),%ebx
8010431f:	38 d9                	cmp    %bl,%cl
80104321:	74 f1                	je     80104314 <memcmp+0x18>
      return *s1 - *s2;
80104323:	0f b6 c1             	movzbl %cl,%eax
80104326:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104328:	5b                   	pop    %ebx
80104329:	5e                   	pop    %esi
8010432a:	5d                   	pop    %ebp
8010432b:	c3                   	ret
  return 0;
8010432c:	31 c0                	xor    %eax,%eax
}
8010432e:	5b                   	pop    %ebx
8010432f:	5e                   	pop    %esi
80104330:	5d                   	pop    %ebp
80104331:	c3                   	ret
80104332:	66 90                	xchg   %ax,%ax

80104334 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	57                   	push   %edi
80104338:	56                   	push   %esi
80104339:	8b 55 08             	mov    0x8(%ebp),%edx
8010433c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010433f:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104342:	39 d6                	cmp    %edx,%esi
80104344:	73 22                	jae    80104368 <memmove+0x34>
80104346:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104349:	39 ca                	cmp    %ecx,%edx
8010434b:	73 1b                	jae    80104368 <memmove+0x34>
    s += n;
    d += n;
    while(n-- > 0)
8010434d:	85 c0                	test   %eax,%eax
8010434f:	74 0e                	je     8010435f <memmove+0x2b>
80104351:	48                   	dec    %eax
80104352:	66 90                	xchg   %ax,%ax
      *--d = *--s;
80104354:	8a 0c 06             	mov    (%esi,%eax,1),%cl
80104357:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010435a:	83 e8 01             	sub    $0x1,%eax
8010435d:	73 f5                	jae    80104354 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010435f:	89 d0                	mov    %edx,%eax
80104361:	5e                   	pop    %esi
80104362:	5f                   	pop    %edi
80104363:	5d                   	pop    %ebp
80104364:	c3                   	ret
80104365:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104368:	85 c0                	test   %eax,%eax
8010436a:	74 f3                	je     8010435f <memmove+0x2b>
8010436c:	01 f0                	add    %esi,%eax
8010436e:	89 d7                	mov    %edx,%edi
      *d++ = *s++;
80104370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104371:	39 f0                	cmp    %esi,%eax
80104373:	75 fb                	jne    80104370 <memmove+0x3c>
}
80104375:	89 d0                	mov    %edx,%eax
80104377:	5e                   	pop    %esi
80104378:	5f                   	pop    %edi
80104379:	5d                   	pop    %ebp
8010437a:	c3                   	ret
8010437b:	90                   	nop

8010437c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
8010437c:	eb b6                	jmp    80104334 <memmove>
8010437e:	66 90                	xchg   %ax,%ax

80104380 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	8b 45 08             	mov    0x8(%ebp),%eax
80104387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010438a:	8b 55 10             	mov    0x10(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010438d:	85 d2                	test   %edx,%edx
8010438f:	75 0c                	jne    8010439d <strncmp+0x1d>
80104391:	eb 1d                	jmp    801043b0 <strncmp+0x30>
80104393:	90                   	nop
80104394:	3a 19                	cmp    (%ecx),%bl
80104396:	75 0b                	jne    801043a3 <strncmp+0x23>
    n--, p++, q++;
80104398:	40                   	inc    %eax
80104399:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
8010439a:	4a                   	dec    %edx
8010439b:	74 13                	je     801043b0 <strncmp+0x30>
8010439d:	8a 18                	mov    (%eax),%bl
8010439f:	84 db                	test   %bl,%bl
801043a1:	75 f1                	jne    80104394 <strncmp+0x14>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801043a3:	0f b6 00             	movzbl (%eax),%eax
801043a6:	0f b6 11             	movzbl (%ecx),%edx
801043a9:	29 d0                	sub    %edx,%eax
}
801043ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ae:	c9                   	leave
801043af:	c3                   	ret
    return 0;
801043b0:	31 c0                	xor    %eax,%eax
}
801043b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b5:	c9                   	leave
801043b6:	c3                   	ret
801043b7:	90                   	nop

801043b8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801043b8:	55                   	push   %ebp
801043b9:	89 e5                	mov    %esp,%ebp
801043bb:	56                   	push   %esi
801043bc:	53                   	push   %ebx
801043bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801043c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801043c3:	8b 55 08             	mov    0x8(%ebp),%edx
801043c6:	eb 0c                	jmp    801043d4 <strncpy+0x1c>
801043c8:	43                   	inc    %ebx
801043c9:	42                   	inc    %edx
801043ca:	8a 43 ff             	mov    -0x1(%ebx),%al
801043cd:	88 42 ff             	mov    %al,-0x1(%edx)
801043d0:	84 c0                	test   %al,%al
801043d2:	74 10                	je     801043e4 <strncpy+0x2c>
801043d4:	89 ce                	mov    %ecx,%esi
801043d6:	49                   	dec    %ecx
801043d7:	85 f6                	test   %esi,%esi
801043d9:	7f ed                	jg     801043c8 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801043db:	8b 45 08             	mov    0x8(%ebp),%eax
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5d                   	pop    %ebp
801043e1:	c3                   	ret
801043e2:	66 90                	xchg   %ax,%ax
  while(n-- > 0)
801043e4:	8d 5c 32 ff          	lea    -0x1(%edx,%esi,1),%ebx
801043e8:	85 c9                	test   %ecx,%ecx
801043ea:	74 ef                	je     801043db <strncpy+0x23>
    *s++ = 0;
801043ec:	42                   	inc    %edx
801043ed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801043f1:	89 d9                	mov    %ebx,%ecx
801043f3:	29 d1                	sub    %edx,%ecx
801043f5:	85 c9                	test   %ecx,%ecx
801043f7:	7f f3                	jg     801043ec <strncpy+0x34>
}
801043f9:	8b 45 08             	mov    0x8(%ebp),%eax
801043fc:	5b                   	pop    %ebx
801043fd:	5e                   	pop    %esi
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret

80104400 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 45 08             	mov    0x8(%ebp),%eax
80104408:	8b 55 0c             	mov    0xc(%ebp),%edx
8010440b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
8010440e:	85 c9                	test   %ecx,%ecx
80104410:	7e 1d                	jle    8010442f <safestrcpy+0x2f>
80104412:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104416:	89 c1                	mov    %eax,%ecx
80104418:	eb 0e                	jmp    80104428 <safestrcpy+0x28>
8010441a:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
8010441c:	42                   	inc    %edx
8010441d:	41                   	inc    %ecx
8010441e:	8a 5a ff             	mov    -0x1(%edx),%bl
80104421:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104424:	84 db                	test   %bl,%bl
80104426:	74 04                	je     8010442c <safestrcpy+0x2c>
80104428:	39 f2                	cmp    %esi,%edx
8010442a:	75 f0                	jne    8010441c <safestrcpy+0x1c>
    ;
  *s = 0;
8010442c:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
8010442f:	5b                   	pop    %ebx
80104430:	5e                   	pop    %esi
80104431:	5d                   	pop    %ebp
80104432:	c3                   	ret
80104433:	90                   	nop

80104434 <strlen>:

int
strlen(const char *s)
{
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
8010443a:	31 c0                	xor    %eax,%eax
8010443c:	80 3a 00             	cmpb   $0x0,(%edx)
8010443f:	74 0a                	je     8010444b <strlen+0x17>
80104441:	8d 76 00             	lea    0x0(%esi),%esi
80104444:	40                   	inc    %eax
80104445:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104449:	75 f9                	jne    80104444 <strlen+0x10>
    ;
  return n;
}
8010444b:	5d                   	pop    %ebp
8010444c:	c3                   	ret

8010444d <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010444d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104451:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104455:	55                   	push   %ebp
  pushl %ebx
80104456:	53                   	push   %ebx
  pushl %esi
80104457:	56                   	push   %esi
  pushl %edi
80104458:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104459:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010445b:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010445d:	5f                   	pop    %edi
  popl %esi
8010445e:	5e                   	pop    %esi
  popl %ebx
8010445f:	5b                   	pop    %ebx
  popl %ebp
80104460:	5d                   	pop    %ebp
  ret
80104461:	c3                   	ret
80104462:	66 90                	xchg   %ax,%ax

80104464 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104464:	55                   	push   %ebp
80104465:	89 e5                	mov    %esp,%ebp
80104467:	53                   	push   %ebx
80104468:	50                   	push   %eax
80104469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010446c:	e8 87 f0 ff ff       	call   801034f8 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104471:	8b 40 28             	mov    0x28(%eax),%eax
80104474:	39 c3                	cmp    %eax,%ebx
80104476:	73 18                	jae    80104490 <fetchint+0x2c>
80104478:	8d 53 04             	lea    0x4(%ebx),%edx
8010447b:	39 d0                	cmp    %edx,%eax
8010447d:	72 11                	jb     80104490 <fetchint+0x2c>
    return -1;
  *ip = *(int*)(addr);
8010447f:	8b 13                	mov    (%ebx),%edx
80104481:	8b 45 0c             	mov    0xc(%ebp),%eax
80104484:	89 10                	mov    %edx,(%eax)
  return 0;
80104486:	31 c0                	xor    %eax,%eax
}
80104488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010448b:	c9                   	leave
8010448c:	c3                   	ret
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104495:	eb f1                	jmp    80104488 <fetchint+0x24>
80104497:	90                   	nop

80104498 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104498:	55                   	push   %ebp
80104499:	89 e5                	mov    %esp,%ebp
8010449b:	53                   	push   %ebx
8010449c:	50                   	push   %eax
8010449d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801044a0:	e8 53 f0 ff ff       	call   801034f8 <myproc>

  if(addr >= curproc->sz)
801044a5:	3b 58 28             	cmp    0x28(%eax),%ebx
801044a8:	73 26                	jae    801044d0 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
801044aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801044ad:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801044af:	8b 50 28             	mov    0x28(%eax),%edx
  for(s = *pp; s < ep; s++){
801044b2:	39 d3                	cmp    %edx,%ebx
801044b4:	73 1a                	jae    801044d0 <fetchstr+0x38>
801044b6:	89 d8                	mov    %ebx,%eax
801044b8:	eb 07                	jmp    801044c1 <fetchstr+0x29>
801044ba:	66 90                	xchg   %ax,%ax
801044bc:	40                   	inc    %eax
801044bd:	39 d0                	cmp    %edx,%eax
801044bf:	73 0f                	jae    801044d0 <fetchstr+0x38>
    if(*s == 0)
801044c1:	80 38 00             	cmpb   $0x0,(%eax)
801044c4:	75 f6                	jne    801044bc <fetchstr+0x24>
      return s - *pp;
801044c6:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801044c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044cb:	c9                   	leave
801044cc:	c3                   	ret
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801044d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d8:	c9                   	leave
801044d9:	c3                   	ret
801044da:	66 90                	xchg   %ax,%ax

801044dc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801044dc:	55                   	push   %ebp
801044dd:	89 e5                	mov    %esp,%ebp
801044df:	56                   	push   %esi
801044e0:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801044e1:	e8 12 f0 ff ff       	call   801034f8 <myproc>
801044e6:	8b 40 40             	mov    0x40(%eax),%eax
801044e9:	8b 40 44             	mov    0x44(%eax),%eax
801044ec:	8b 55 08             	mov    0x8(%ebp),%edx
801044ef:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801044f2:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
801044f5:	e8 fe ef ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801044fa:	8b 40 28             	mov    0x28(%eax),%eax
801044fd:	39 c6                	cmp    %eax,%esi
801044ff:	73 17                	jae    80104518 <argint+0x3c>
80104501:	8d 53 08             	lea    0x8(%ebx),%edx
80104504:	39 d0                	cmp    %edx,%eax
80104506:	72 10                	jb     80104518 <argint+0x3c>
  *ip = *(int*)(addr);
80104508:	8b 53 04             	mov    0x4(%ebx),%edx
8010450b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010450e:	89 10                	mov    %edx,(%eax)
  return 0;
80104510:	31 c0                	xor    %eax,%eax
}
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret
80104516:	66 90                	xchg   %ax,%ax
    return -1;
80104518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010451d:	eb f3                	jmp    80104512 <argint+0x36>
8010451f:	90                   	nop

80104520 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104529:	e8 ca ef ff ff       	call   801034f8 <myproc>
8010452e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104530:	e8 c3 ef ff ff       	call   801034f8 <myproc>
80104535:	8b 40 40             	mov    0x40(%eax),%eax
80104538:	8b 40 44             	mov    0x44(%eax),%eax
8010453b:	8b 55 08             	mov    0x8(%ebp),%edx
8010453e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104541:	8d 7b 04             	lea    0x4(%ebx),%edi
  struct proc *curproc = myproc();
80104544:	e8 af ef ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104549:	8b 40 28             	mov    0x28(%eax),%eax
8010454c:	39 c7                	cmp    %eax,%edi
8010454e:	73 30                	jae    80104580 <argptr+0x60>
80104550:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104553:	39 c8                	cmp    %ecx,%eax
80104555:	72 29                	jb     80104580 <argptr+0x60>
  *ip = *(int*)(addr);
80104557:	8b 43 04             	mov    0x4(%ebx),%eax
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010455a:	8b 55 10             	mov    0x10(%ebp),%edx
8010455d:	85 d2                	test   %edx,%edx
8010455f:	78 1f                	js     80104580 <argptr+0x60>
80104561:	8b 56 28             	mov    0x28(%esi),%edx
80104564:	39 d0                	cmp    %edx,%eax
80104566:	73 18                	jae    80104580 <argptr+0x60>
80104568:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010456b:	01 c3                	add    %eax,%ebx
8010456d:	39 da                	cmp    %ebx,%edx
8010456f:	72 0f                	jb     80104580 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104571:	8b 55 0c             	mov    0xc(%ebp),%edx
80104574:	89 02                	mov    %eax,(%edx)
  return 0;
80104576:	31 c0                	xor    %eax,%eax
}
80104578:	83 c4 0c             	add    $0xc,%esp
8010457b:	5b                   	pop    %ebx
8010457c:	5e                   	pop    %esi
8010457d:	5f                   	pop    %edi
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret
    return -1;
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104585:	eb f1                	jmp    80104578 <argptr+0x58>
80104587:	90                   	nop

80104588 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104588:	55                   	push   %ebp
80104589:	89 e5                	mov    %esp,%ebp
8010458b:	56                   	push   %esi
8010458c:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010458d:	e8 66 ef ff ff       	call   801034f8 <myproc>
80104592:	8b 40 40             	mov    0x40(%eax),%eax
80104595:	8b 40 44             	mov    0x44(%eax),%eax
80104598:	8b 55 08             	mov    0x8(%ebp),%edx
8010459b:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
8010459e:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
801045a1:	e8 52 ef ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045a6:	8b 40 28             	mov    0x28(%eax),%eax
801045a9:	39 c6                	cmp    %eax,%esi
801045ab:	73 37                	jae    801045e4 <argstr+0x5c>
801045ad:	8d 53 08             	lea    0x8(%ebx),%edx
801045b0:	39 d0                	cmp    %edx,%eax
801045b2:	72 30                	jb     801045e4 <argstr+0x5c>
  *ip = *(int*)(addr);
801045b4:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801045b7:	e8 3c ef ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz)
801045bc:	3b 58 28             	cmp    0x28(%eax),%ebx
801045bf:	73 23                	jae    801045e4 <argstr+0x5c>
  *pp = (char*)addr;
801045c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801045c4:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801045c6:	8b 50 28             	mov    0x28(%eax),%edx
  for(s = *pp; s < ep; s++){
801045c9:	39 d3                	cmp    %edx,%ebx
801045cb:	73 17                	jae    801045e4 <argstr+0x5c>
801045cd:	89 d8                	mov    %ebx,%eax
801045cf:	eb 08                	jmp    801045d9 <argstr+0x51>
801045d1:	8d 76 00             	lea    0x0(%esi),%esi
801045d4:	40                   	inc    %eax
801045d5:	39 d0                	cmp    %edx,%eax
801045d7:	73 0b                	jae    801045e4 <argstr+0x5c>
    if(*s == 0)
801045d9:	80 38 00             	cmpb   $0x0,(%eax)
801045dc:	75 f6                	jne    801045d4 <argstr+0x4c>
      return s - *pp;
801045de:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801045e0:	5b                   	pop    %ebx
801045e1:	5e                   	pop    %esi
801045e2:	5d                   	pop    %ebp
801045e3:	c3                   	ret
    return -1;
801045e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045e9:	5b                   	pop    %ebx
801045ea:	5e                   	pop    %esi
801045eb:	5d                   	pop    %ebp
801045ec:	c3                   	ret
801045ed:	8d 76 00             	lea    0x0(%esi),%esi

801045f0 <syscall>:
[SYS_scheduler_start] sys_scheduler_start
};

void
syscall(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
801045f5:	e8 fe ee ff ff       	call   801034f8 <myproc>
801045fa:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801045fc:	8b 40 40             	mov    0x40(%eax),%eax
801045ff:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104602:	8d 50 ff             	lea    -0x1(%eax),%edx
80104605:	83 fa 17             	cmp    $0x17,%edx
80104608:	77 1a                	ja     80104624 <syscall+0x34>
8010460a:	8b 14 85 40 73 10 80 	mov    -0x7fef8cc0(,%eax,4),%edx
80104611:	85 d2                	test   %edx,%edx
80104613:	74 0f                	je     80104624 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104615:	ff d2                	call   *%edx
80104617:	89 c2                	mov    %eax,%edx
80104619:	8b 43 40             	mov    0x40(%ebx),%eax
8010461c:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010461f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104622:	c9                   	leave
80104623:	c3                   	ret
    cprintf("%d %s: unknown sys call %d\n",
80104624:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104625:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010462b:	50                   	push   %eax
8010462c:	ff 73 38             	push   0x38(%ebx)
8010462f:	68 e0 6d 10 80       	push   $0x80106de0
80104634:	e8 e7 bf ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
80104639:	8b 43 40             	mov    0x40(%ebx),%eax
8010463c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104643:	83 c4 10             	add    $0x10,%esp
}
80104646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104649:	c9                   	leave
8010464a:	c3                   	ret
8010464b:	90                   	nop

8010464c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010464c:	55                   	push   %ebp
8010464d:	89 e5                	mov    %esp,%ebp
8010464f:	57                   	push   %edi
80104650:	56                   	push   %esi
80104651:	53                   	push   %ebx
80104652:	83 ec 34             	sub    $0x34,%esp
80104655:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104658:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010465b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010465e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104661:	8d 7d da             	lea    -0x26(%ebp),%edi
80104664:	57                   	push   %edi
80104665:	50                   	push   %eax
80104666:	e8 21 d8 ff ff       	call   80101e8c <nameiparent>
8010466b:	83 c4 10             	add    $0x10,%esp
8010466e:	85 c0                	test   %eax,%eax
80104670:	74 5a                	je     801046cc <create+0x80>
80104672:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	50                   	push   %eax
80104678:	e8 a3 cf ff ff       	call   80101620 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010467d:	83 c4 0c             	add    $0xc,%esp
80104680:	6a 00                	push   $0x0
80104682:	57                   	push   %edi
80104683:	53                   	push   %ebx
80104684:	e8 9b d4 ff ff       	call   80101b24 <dirlookup>
80104689:	89 c6                	mov    %eax,%esi
8010468b:	83 c4 10             	add    $0x10,%esp
8010468e:	85 c0                	test   %eax,%eax
80104690:	74 46                	je     801046d8 <create+0x8c>
    iunlockput(dp);
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	53                   	push   %ebx
80104696:	e8 d9 d1 ff ff       	call   80101874 <iunlockput>
    ilock(ip);
8010469b:	89 34 24             	mov    %esi,(%esp)
8010469e:	e8 7d cf ff ff       	call   80101620 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801046ab:	75 13                	jne    801046c0 <create+0x74>
801046ad:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801046b2:	75 0c                	jne    801046c0 <create+0x74>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801046b4:	89 f0                	mov    %esi,%eax
801046b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b9:	5b                   	pop    %ebx
801046ba:	5e                   	pop    %esi
801046bb:	5f                   	pop    %edi
801046bc:	5d                   	pop    %ebp
801046bd:	c3                   	ret
801046be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801046c0:	83 ec 0c             	sub    $0xc,%esp
801046c3:	56                   	push   %esi
801046c4:	e8 ab d1 ff ff       	call   80101874 <iunlockput>
    return 0;
801046c9:	83 c4 10             	add    $0x10,%esp
    return 0;
801046cc:	31 f6                	xor    %esi,%esi
}
801046ce:	89 f0                	mov    %esi,%eax
801046d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046d3:	5b                   	pop    %ebx
801046d4:	5e                   	pop    %esi
801046d5:	5f                   	pop    %edi
801046d6:	5d                   	pop    %ebp
801046d7:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
801046d8:	83 ec 08             	sub    $0x8,%esp
801046db:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801046df:	50                   	push   %eax
801046e0:	ff 33                	push   (%ebx)
801046e2:	e8 e1 cd ff ff       	call   801014c8 <ialloc>
801046e7:	89 c6                	mov    %eax,%esi
801046e9:	83 c4 10             	add    $0x10,%esp
801046ec:	85 c0                	test   %eax,%eax
801046ee:	0f 84 a0 00 00 00    	je     80104794 <create+0x148>
  ilock(ip);
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	50                   	push   %eax
801046f8:	e8 23 cf ff ff       	call   80101620 <ilock>
  ip->major = major;
801046fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104700:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104704:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104707:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
8010470b:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
80104711:	89 34 24             	mov    %esi,(%esp)
80104714:	e8 5f ce ff ff       	call   80101578 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104719:	83 c4 10             	add    $0x10,%esp
8010471c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104721:	74 29                	je     8010474c <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
80104723:	50                   	push   %eax
80104724:	ff 76 04             	push   0x4(%esi)
80104727:	57                   	push   %edi
80104728:	53                   	push   %ebx
80104729:	e8 96 d6 ff ff       	call   80101dc4 <dirlink>
8010472e:	83 c4 10             	add    $0x10,%esp
80104731:	85 c0                	test   %eax,%eax
80104733:	78 6c                	js     801047a1 <create+0x155>
  iunlockput(dp);
80104735:	83 ec 0c             	sub    $0xc,%esp
80104738:	53                   	push   %ebx
80104739:	e8 36 d1 ff ff       	call   80101874 <iunlockput>
  return ip;
8010473e:	83 c4 10             	add    $0x10,%esp
}
80104741:	89 f0                	mov    %esi,%eax
80104743:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104746:	5b                   	pop    %ebx
80104747:	5e                   	pop    %esi
80104748:	5f                   	pop    %edi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret
8010474b:	90                   	nop
    dp->nlink++;  // for ".."
8010474c:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	53                   	push   %ebx
80104754:	e8 1f ce ff ff       	call   80101578 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104759:	83 c4 0c             	add    $0xc,%esp
8010475c:	ff 76 04             	push   0x4(%esi)
8010475f:	68 18 6e 10 80       	push   $0x80106e18
80104764:	56                   	push   %esi
80104765:	e8 5a d6 ff ff       	call   80101dc4 <dirlink>
8010476a:	83 c4 10             	add    $0x10,%esp
8010476d:	85 c0                	test   %eax,%eax
8010476f:	78 16                	js     80104787 <create+0x13b>
80104771:	52                   	push   %edx
80104772:	ff 73 04             	push   0x4(%ebx)
80104775:	68 17 6e 10 80       	push   $0x80106e17
8010477a:	56                   	push   %esi
8010477b:	e8 44 d6 ff ff       	call   80101dc4 <dirlink>
80104780:	83 c4 10             	add    $0x10,%esp
80104783:	85 c0                	test   %eax,%eax
80104785:	79 9c                	jns    80104723 <create+0xd7>
      panic("create dots");
80104787:	83 ec 0c             	sub    $0xc,%esp
8010478a:	68 0b 6e 10 80       	push   $0x80106e0b
8010478f:	e8 a4 bb ff ff       	call   80100338 <panic>
    panic("create: ialloc");
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	68 fc 6d 10 80       	push   $0x80106dfc
8010479c:	e8 97 bb ff ff       	call   80100338 <panic>
    panic("create: dirlink");
801047a1:	83 ec 0c             	sub    $0xc,%esp
801047a4:	68 1a 6e 10 80       	push   $0x80106e1a
801047a9:	e8 8a bb ff ff       	call   80100338 <panic>
801047ae:	66 90                	xchg   %ax,%ax

801047b0 <sys_dup>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801047b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047bb:	50                   	push   %eax
801047bc:	6a 00                	push   $0x0
801047be:	e8 19 fd ff ff       	call   801044dc <argint>
801047c3:	83 c4 10             	add    $0x10,%esp
801047c6:	85 c0                	test   %eax,%eax
801047c8:	78 2c                	js     801047f6 <sys_dup+0x46>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801047ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801047ce:	77 26                	ja     801047f6 <sys_dup+0x46>
801047d0:	e8 23 ed ff ff       	call   801034f8 <myproc>
801047d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047d8:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
801047dc:	85 f6                	test   %esi,%esi
801047de:	74 16                	je     801047f6 <sys_dup+0x46>
  struct proc *curproc = myproc();
801047e0:	e8 13 ed ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801047e5:	31 db                	xor    %ebx,%ebx
801047e7:	90                   	nop
    if(curproc->ofile[fd] == 0){
801047e8:	8b 54 98 50          	mov    0x50(%eax,%ebx,4),%edx
801047ec:	85 d2                	test   %edx,%edx
801047ee:	74 10                	je     80104800 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801047f0:	43                   	inc    %ebx
801047f1:	83 fb 10             	cmp    $0x10,%ebx
801047f4:	75 f2                	jne    801047e8 <sys_dup+0x38>
    return -1;
801047f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047fb:	eb 13                	jmp    80104810 <sys_dup+0x60>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104800:	89 74 98 50          	mov    %esi,0x50(%eax,%ebx,4)
  filedup(f);
80104804:	83 ec 0c             	sub    $0xc,%esp
80104807:	56                   	push   %esi
80104808:	e8 fb c5 ff ff       	call   80100e08 <filedup>
  return fd;
8010480d:	83 c4 10             	add    $0x10,%esp
}
80104810:	89 d8                	mov    %ebx,%eax
80104812:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104815:	5b                   	pop    %ebx
80104816:	5e                   	pop    %esi
80104817:	5d                   	pop    %ebp
80104818:	c3                   	ret
80104819:	8d 76 00             	lea    0x0(%esi),%esi

8010481c <sys_read>:
{
8010481c:	55                   	push   %ebp
8010481d:	89 e5                	mov    %esp,%ebp
8010481f:	56                   	push   %esi
80104820:	53                   	push   %ebx
80104821:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104824:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104827:	53                   	push   %ebx
80104828:	6a 00                	push   $0x0
8010482a:	e8 ad fc ff ff       	call   801044dc <argint>
8010482f:	83 c4 10             	add    $0x10,%esp
80104832:	85 c0                	test   %eax,%eax
80104834:	78 56                	js     8010488c <sys_read+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104836:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010483a:	77 50                	ja     8010488c <sys_read+0x70>
8010483c:	e8 b7 ec ff ff       	call   801034f8 <myproc>
80104841:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104844:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
80104848:	85 f6                	test   %esi,%esi
8010484a:	74 40                	je     8010488c <sys_read+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010484c:	83 ec 08             	sub    $0x8,%esp
8010484f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104852:	50                   	push   %eax
80104853:	6a 02                	push   $0x2
80104855:	e8 82 fc ff ff       	call   801044dc <argint>
8010485a:	83 c4 10             	add    $0x10,%esp
8010485d:	85 c0                	test   %eax,%eax
8010485f:	78 2b                	js     8010488c <sys_read+0x70>
80104861:	52                   	push   %edx
80104862:	ff 75 f0             	push   -0x10(%ebp)
80104865:	53                   	push   %ebx
80104866:	6a 01                	push   $0x1
80104868:	e8 b3 fc ff ff       	call   80104520 <argptr>
8010486d:	83 c4 10             	add    $0x10,%esp
80104870:	85 c0                	test   %eax,%eax
80104872:	78 18                	js     8010488c <sys_read+0x70>
  return fileread(f, p, n);
80104874:	50                   	push   %eax
80104875:	ff 75 f0             	push   -0x10(%ebp)
80104878:	ff 75 f4             	push   -0xc(%ebp)
8010487b:	56                   	push   %esi
8010487c:	e8 cf c6 ff ff       	call   80100f50 <fileread>
80104881:	83 c4 10             	add    $0x10,%esp
}
80104884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret
8010488b:	90                   	nop
    return -1;
8010488c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104891:	eb f1                	jmp    80104884 <sys_read+0x68>
80104893:	90                   	nop

80104894 <sys_write>:
{
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	56                   	push   %esi
80104898:	53                   	push   %ebx
80104899:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010489c:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010489f:	53                   	push   %ebx
801048a0:	6a 00                	push   $0x0
801048a2:	e8 35 fc ff ff       	call   801044dc <argint>
801048a7:	83 c4 10             	add    $0x10,%esp
801048aa:	85 c0                	test   %eax,%eax
801048ac:	78 56                	js     80104904 <sys_write+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048b2:	77 50                	ja     80104904 <sys_write+0x70>
801048b4:	e8 3f ec ff ff       	call   801034f8 <myproc>
801048b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048bc:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
801048c0:	85 f6                	test   %esi,%esi
801048c2:	74 40                	je     80104904 <sys_write+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048c4:	83 ec 08             	sub    $0x8,%esp
801048c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048ca:	50                   	push   %eax
801048cb:	6a 02                	push   $0x2
801048cd:	e8 0a fc ff ff       	call   801044dc <argint>
801048d2:	83 c4 10             	add    $0x10,%esp
801048d5:	85 c0                	test   %eax,%eax
801048d7:	78 2b                	js     80104904 <sys_write+0x70>
801048d9:	52                   	push   %edx
801048da:	ff 75 f0             	push   -0x10(%ebp)
801048dd:	53                   	push   %ebx
801048de:	6a 01                	push   $0x1
801048e0:	e8 3b fc ff ff       	call   80104520 <argptr>
801048e5:	83 c4 10             	add    $0x10,%esp
801048e8:	85 c0                	test   %eax,%eax
801048ea:	78 18                	js     80104904 <sys_write+0x70>
  return filewrite(f, p, n);
801048ec:	50                   	push   %eax
801048ed:	ff 75 f0             	push   -0x10(%ebp)
801048f0:	ff 75 f4             	push   -0xc(%ebp)
801048f3:	56                   	push   %esi
801048f4:	e8 e3 c6 ff ff       	call   80100fdc <filewrite>
801048f9:	83 c4 10             	add    $0x10,%esp
}
801048fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ff:	5b                   	pop    %ebx
80104900:	5e                   	pop    %esi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret
80104903:	90                   	nop
    return -1;
80104904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104909:	eb f1                	jmp    801048fc <sys_write+0x68>
8010490b:	90                   	nop

8010490c <sys_close>:
{
8010490c:	55                   	push   %ebp
8010490d:	89 e5                	mov    %esp,%ebp
8010490f:	56                   	push   %esi
80104910:	53                   	push   %ebx
80104911:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104914:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104917:	50                   	push   %eax
80104918:	6a 00                	push   $0x0
8010491a:	e8 bd fb ff ff       	call   801044dc <argint>
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	85 c0                	test   %eax,%eax
80104924:	78 3a                	js     80104960 <sys_close+0x54>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104926:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010492a:	77 34                	ja     80104960 <sys_close+0x54>
8010492c:	e8 c7 eb ff ff       	call   801034f8 <myproc>
80104931:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104934:	8d 5a 14             	lea    0x14(%edx),%ebx
80104937:	8b 34 98             	mov    (%eax,%ebx,4),%esi
8010493a:	85 f6                	test   %esi,%esi
8010493c:	74 22                	je     80104960 <sys_close+0x54>
  myproc()->ofile[fd] = 0;
8010493e:	e8 b5 eb ff ff       	call   801034f8 <myproc>
80104943:	c7 04 98 00 00 00 00 	movl   $0x0,(%eax,%ebx,4)
  fileclose(f);
8010494a:	83 ec 0c             	sub    $0xc,%esp
8010494d:	56                   	push   %esi
8010494e:	e8 f9 c4 ff ff       	call   80100e4c <fileclose>
  return 0;
80104953:	83 c4 10             	add    $0x10,%esp
80104956:	31 c0                	xor    %eax,%eax
}
80104958:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010495b:	5b                   	pop    %ebx
8010495c:	5e                   	pop    %esi
8010495d:	5d                   	pop    %ebp
8010495e:	c3                   	ret
8010495f:	90                   	nop
    return -1;
80104960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104965:	eb f1                	jmp    80104958 <sys_close+0x4c>
80104967:	90                   	nop

80104968 <sys_fstat>:
{
80104968:	55                   	push   %ebp
80104969:	89 e5                	mov    %esp,%ebp
8010496b:	56                   	push   %esi
8010496c:	53                   	push   %ebx
8010496d:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104970:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104973:	53                   	push   %ebx
80104974:	6a 00                	push   $0x0
80104976:	e8 61 fb ff ff       	call   801044dc <argint>
8010497b:	83 c4 10             	add    $0x10,%esp
8010497e:	85 c0                	test   %eax,%eax
80104980:	78 3e                	js     801049c0 <sys_fstat+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104982:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104986:	77 38                	ja     801049c0 <sys_fstat+0x58>
80104988:	e8 6b eb ff ff       	call   801034f8 <myproc>
8010498d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104990:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
80104994:	85 f6                	test   %esi,%esi
80104996:	74 28                	je     801049c0 <sys_fstat+0x58>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104998:	50                   	push   %eax
80104999:	6a 14                	push   $0x14
8010499b:	53                   	push   %ebx
8010499c:	6a 01                	push   $0x1
8010499e:	e8 7d fb ff ff       	call   80104520 <argptr>
801049a3:	83 c4 10             	add    $0x10,%esp
801049a6:	85 c0                	test   %eax,%eax
801049a8:	78 16                	js     801049c0 <sys_fstat+0x58>
  return filestat(f, st);
801049aa:	83 ec 08             	sub    $0x8,%esp
801049ad:	ff 75 f4             	push   -0xc(%ebp)
801049b0:	56                   	push   %esi
801049b1:	e8 56 c5 ff ff       	call   80100f0c <filestat>
801049b6:	83 c4 10             	add    $0x10,%esp
}
801049b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049bc:	5b                   	pop    %ebx
801049bd:	5e                   	pop    %esi
801049be:	5d                   	pop    %ebp
801049bf:	c3                   	ret
    return -1;
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049c5:	eb f2                	jmp    801049b9 <sys_fstat+0x51>
801049c7:	90                   	nop

801049c8 <sys_link>:
{
801049c8:	55                   	push   %ebp
801049c9:	89 e5                	mov    %esp,%ebp
801049cb:	57                   	push   %edi
801049cc:	56                   	push   %esi
801049cd:	53                   	push   %ebx
801049ce:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801049d1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801049d4:	50                   	push   %eax
801049d5:	6a 00                	push   $0x0
801049d7:	e8 ac fb ff ff       	call   80104588 <argstr>
801049dc:	83 c4 10             	add    $0x10,%esp
801049df:	85 c0                	test   %eax,%eax
801049e1:	0f 88 f2 00 00 00    	js     80104ad9 <sys_link+0x111>
801049e7:	83 ec 08             	sub    $0x8,%esp
801049ea:	8d 45 d0             	lea    -0x30(%ebp),%eax
801049ed:	50                   	push   %eax
801049ee:	6a 01                	push   $0x1
801049f0:	e8 93 fb ff ff       	call   80104588 <argstr>
801049f5:	83 c4 10             	add    $0x10,%esp
801049f8:	85 c0                	test   %eax,%eax
801049fa:	0f 88 d9 00 00 00    	js     80104ad9 <sys_link+0x111>
  begin_op();
80104a00:	e8 b7 df ff ff       	call   801029bc <begin_op>
  if((ip = namei(old)) == 0){
80104a05:	83 ec 0c             	sub    $0xc,%esp
80104a08:	ff 75 d4             	push   -0x2c(%ebp)
80104a0b:	e8 64 d4 ff ff       	call   80101e74 <namei>
80104a10:	89 c3                	mov    %eax,%ebx
80104a12:	83 c4 10             	add    $0x10,%esp
80104a15:	85 c0                	test   %eax,%eax
80104a17:	0f 84 d6 00 00 00    	je     80104af3 <sys_link+0x12b>
  ilock(ip);
80104a1d:	83 ec 0c             	sub    $0xc,%esp
80104a20:	50                   	push   %eax
80104a21:	e8 fa cb ff ff       	call   80101620 <ilock>
  if(ip->type == T_DIR){
80104a26:	83 c4 10             	add    $0x10,%esp
80104a29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104a2e:	0f 84 ac 00 00 00    	je     80104ae0 <sys_link+0x118>
  ip->nlink++;
80104a34:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	53                   	push   %ebx
80104a3c:	e8 37 cb ff ff       	call   80101578 <iupdate>
  iunlock(ip);
80104a41:	89 1c 24             	mov    %ebx,(%esp)
80104a44:	e8 9f cc ff ff       	call   801016e8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104a49:	5a                   	pop    %edx
80104a4a:	59                   	pop    %ecx
80104a4b:	8d 7d da             	lea    -0x26(%ebp),%edi
80104a4e:	57                   	push   %edi
80104a4f:	ff 75 d0             	push   -0x30(%ebp)
80104a52:	e8 35 d4 ff ff       	call   80101e8c <nameiparent>
80104a57:	89 c6                	mov    %eax,%esi
80104a59:	83 c4 10             	add    $0x10,%esp
80104a5c:	85 c0                	test   %eax,%eax
80104a5e:	74 54                	je     80104ab4 <sys_link+0xec>
  ilock(dp);
80104a60:	83 ec 0c             	sub    $0xc,%esp
80104a63:	50                   	push   %eax
80104a64:	e8 b7 cb ff ff       	call   80101620 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104a69:	83 c4 10             	add    $0x10,%esp
80104a6c:	8b 03                	mov    (%ebx),%eax
80104a6e:	39 06                	cmp    %eax,(%esi)
80104a70:	75 36                	jne    80104aa8 <sys_link+0xe0>
80104a72:	50                   	push   %eax
80104a73:	ff 73 04             	push   0x4(%ebx)
80104a76:	57                   	push   %edi
80104a77:	56                   	push   %esi
80104a78:	e8 47 d3 ff ff       	call   80101dc4 <dirlink>
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 24                	js     80104aa8 <sys_link+0xe0>
  iunlockput(dp);
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	56                   	push   %esi
80104a88:	e8 e7 cd ff ff       	call   80101874 <iunlockput>
  iput(ip);
80104a8d:	89 1c 24             	mov    %ebx,(%esp)
80104a90:	e8 97 cc ff ff       	call   8010172c <iput>
  end_op();
80104a95:	e8 8a df ff ff       	call   80102a24 <end_op>
  return 0;
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	31 c0                	xor    %eax,%eax
}
80104a9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa2:	5b                   	pop    %ebx
80104aa3:	5e                   	pop    %esi
80104aa4:	5f                   	pop    %edi
80104aa5:	5d                   	pop    %ebp
80104aa6:	c3                   	ret
80104aa7:	90                   	nop
    iunlockput(dp);
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	56                   	push   %esi
80104aac:	e8 c3 cd ff ff       	call   80101874 <iunlockput>
    goto bad;
80104ab1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ab4:	83 ec 0c             	sub    $0xc,%esp
80104ab7:	53                   	push   %ebx
80104ab8:	e8 63 cb ff ff       	call   80101620 <ilock>
  ip->nlink--;
80104abd:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104ac1:	89 1c 24             	mov    %ebx,(%esp)
80104ac4:	e8 af ca ff ff       	call   80101578 <iupdate>
  iunlockput(ip);
80104ac9:	89 1c 24             	mov    %ebx,(%esp)
80104acc:	e8 a3 cd ff ff       	call   80101874 <iunlockput>
  end_op();
80104ad1:	e8 4e df ff ff       	call   80102a24 <end_op>
  return -1;
80104ad6:	83 c4 10             	add    $0x10,%esp
    return -1;
80104ad9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ade:	eb bf                	jmp    80104a9f <sys_link+0xd7>
    iunlockput(ip);
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	53                   	push   %ebx
80104ae4:	e8 8b cd ff ff       	call   80101874 <iunlockput>
    end_op();
80104ae9:	e8 36 df ff ff       	call   80102a24 <end_op>
    return -1;
80104aee:	83 c4 10             	add    $0x10,%esp
80104af1:	eb e6                	jmp    80104ad9 <sys_link+0x111>
    end_op();
80104af3:	e8 2c df ff ff       	call   80102a24 <end_op>
    return -1;
80104af8:	eb df                	jmp    80104ad9 <sys_link+0x111>
80104afa:	66 90                	xchg   %ax,%ax

80104afc <sys_unlink>:
{
80104afc:	55                   	push   %ebp
80104afd:	89 e5                	mov    %esp,%ebp
80104aff:	57                   	push   %edi
80104b00:	56                   	push   %esi
80104b01:	53                   	push   %ebx
80104b02:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104b05:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b08:	50                   	push   %eax
80104b09:	6a 00                	push   $0x0
80104b0b:	e8 78 fa ff ff       	call   80104588 <argstr>
80104b10:	83 c4 10             	add    $0x10,%esp
80104b13:	85 c0                	test   %eax,%eax
80104b15:	0f 88 50 01 00 00    	js     80104c6b <sys_unlink+0x16f>
  begin_op();
80104b1b:	e8 9c de ff ff       	call   801029bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104b20:	83 ec 08             	sub    $0x8,%esp
80104b23:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104b26:	53                   	push   %ebx
80104b27:	ff 75 c0             	push   -0x40(%ebp)
80104b2a:	e8 5d d3 ff ff       	call   80101e8c <nameiparent>
80104b2f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104b32:	83 c4 10             	add    $0x10,%esp
80104b35:	85 c0                	test   %eax,%eax
80104b37:	0f 84 4f 01 00 00    	je     80104c8c <sys_unlink+0x190>
  ilock(dp);
80104b3d:	83 ec 0c             	sub    $0xc,%esp
80104b40:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80104b43:	57                   	push   %edi
80104b44:	e8 d7 ca ff ff       	call   80101620 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104b49:	59                   	pop    %ecx
80104b4a:	5e                   	pop    %esi
80104b4b:	68 18 6e 10 80       	push   $0x80106e18
80104b50:	53                   	push   %ebx
80104b51:	e8 b6 cf ff ff       	call   80101b0c <namecmp>
80104b56:	83 c4 10             	add    $0x10,%esp
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	0f 84 f7 00 00 00    	je     80104c58 <sys_unlink+0x15c>
80104b61:	83 ec 08             	sub    $0x8,%esp
80104b64:	68 17 6e 10 80       	push   $0x80106e17
80104b69:	53                   	push   %ebx
80104b6a:	e8 9d cf ff ff       	call   80101b0c <namecmp>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	0f 84 de 00 00 00    	je     80104c58 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104b7a:	52                   	push   %edx
80104b7b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104b7e:	50                   	push   %eax
80104b7f:	53                   	push   %ebx
80104b80:	57                   	push   %edi
80104b81:	e8 9e cf ff ff       	call   80101b24 <dirlookup>
80104b86:	89 c3                	mov    %eax,%ebx
80104b88:	83 c4 10             	add    $0x10,%esp
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	0f 84 c5 00 00 00    	je     80104c58 <sys_unlink+0x15c>
  ilock(ip);
80104b93:	83 ec 0c             	sub    $0xc,%esp
80104b96:	50                   	push   %eax
80104b97:	e8 84 ca ff ff       	call   80101620 <ilock>
  if(ip->nlink < 1)
80104b9c:	83 c4 10             	add    $0x10,%esp
80104b9f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ba4:	0f 8e f6 00 00 00    	jle    80104ca0 <sys_unlink+0x1a4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104baa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104baf:	74 67                	je     80104c18 <sys_unlink+0x11c>
80104bb1:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
80104bb4:	50                   	push   %eax
80104bb5:	6a 10                	push   $0x10
80104bb7:	6a 00                	push   $0x0
80104bb9:	57                   	push   %edi
80104bba:	e8 f9 f6 ff ff       	call   801042b8 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104bbf:	6a 10                	push   $0x10
80104bc1:	ff 75 c4             	push   -0x3c(%ebp)
80104bc4:	57                   	push   %edi
80104bc5:	ff 75 b4             	push   -0x4c(%ebp)
80104bc8:	e8 23 ce ff ff       	call   801019f0 <writei>
80104bcd:	83 c4 20             	add    $0x20,%esp
80104bd0:	83 f8 10             	cmp    $0x10,%eax
80104bd3:	0f 85 d4 00 00 00    	jne    80104cad <sys_unlink+0x1b1>
  if(ip->type == T_DIR){
80104bd9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104bde:	0f 84 90 00 00 00    	je     80104c74 <sys_unlink+0x178>
  iunlockput(dp);
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	ff 75 b4             	push   -0x4c(%ebp)
80104bea:	e8 85 cc ff ff       	call   80101874 <iunlockput>
  ip->nlink--;
80104bef:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104bf3:	89 1c 24             	mov    %ebx,(%esp)
80104bf6:	e8 7d c9 ff ff       	call   80101578 <iupdate>
  iunlockput(ip);
80104bfb:	89 1c 24             	mov    %ebx,(%esp)
80104bfe:	e8 71 cc ff ff       	call   80101874 <iunlockput>
  end_op();
80104c03:	e8 1c de ff ff       	call   80102a24 <end_op>
  return 0;
80104c08:	83 c4 10             	add    $0x10,%esp
80104c0b:	31 c0                	xor    %eax,%eax
}
80104c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c10:	5b                   	pop    %ebx
80104c11:	5e                   	pop    %esi
80104c12:	5f                   	pop    %edi
80104c13:	5d                   	pop    %ebp
80104c14:	c3                   	ret
80104c15:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104c18:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104c1c:	76 93                	jbe    80104bb1 <sys_unlink+0xb5>
80104c1e:	be 20 00 00 00       	mov    $0x20,%esi
80104c23:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104c26:	eb 08                	jmp    80104c30 <sys_unlink+0x134>
80104c28:	83 c6 10             	add    $0x10,%esi
80104c2b:	3b 73 58             	cmp    0x58(%ebx),%esi
80104c2e:	73 84                	jae    80104bb4 <sys_unlink+0xb8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c30:	6a 10                	push   $0x10
80104c32:	56                   	push   %esi
80104c33:	57                   	push   %edi
80104c34:	53                   	push   %ebx
80104c35:	e8 b6 cc ff ff       	call   801018f0 <readi>
80104c3a:	83 c4 10             	add    $0x10,%esp
80104c3d:	83 f8 10             	cmp    $0x10,%eax
80104c40:	75 51                	jne    80104c93 <sys_unlink+0x197>
    if(de.inum != 0)
80104c42:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104c47:	74 df                	je     80104c28 <sys_unlink+0x12c>
    iunlockput(ip);
80104c49:	83 ec 0c             	sub    $0xc,%esp
80104c4c:	53                   	push   %ebx
80104c4d:	e8 22 cc ff ff       	call   80101874 <iunlockput>
    goto bad;
80104c52:	83 c4 10             	add    $0x10,%esp
80104c55:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	ff 75 b4             	push   -0x4c(%ebp)
80104c5e:	e8 11 cc ff ff       	call   80101874 <iunlockput>
  end_op();
80104c63:	e8 bc dd ff ff       	call   80102a24 <end_op>
  return -1;
80104c68:	83 c4 10             	add    $0x10,%esp
    return -1;
80104c6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c70:	eb 9b                	jmp    80104c0d <sys_unlink+0x111>
80104c72:	66 90                	xchg   %ax,%ax
    dp->nlink--;
80104c74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c77:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
80104c7b:	83 ec 0c             	sub    $0xc,%esp
80104c7e:	50                   	push   %eax
80104c7f:	e8 f4 c8 ff ff       	call   80101578 <iupdate>
80104c84:	83 c4 10             	add    $0x10,%esp
80104c87:	e9 58 ff ff ff       	jmp    80104be4 <sys_unlink+0xe8>
    end_op();
80104c8c:	e8 93 dd ff ff       	call   80102a24 <end_op>
    return -1;
80104c91:	eb d8                	jmp    80104c6b <sys_unlink+0x16f>
      panic("isdirempty: readi");
80104c93:	83 ec 0c             	sub    $0xc,%esp
80104c96:	68 3c 6e 10 80       	push   $0x80106e3c
80104c9b:	e8 98 b6 ff ff       	call   80100338 <panic>
    panic("unlink: nlink < 1");
80104ca0:	83 ec 0c             	sub    $0xc,%esp
80104ca3:	68 2a 6e 10 80       	push   $0x80106e2a
80104ca8:	e8 8b b6 ff ff       	call   80100338 <panic>
    panic("unlink: writei");
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	68 4e 6e 10 80       	push   $0x80106e4e
80104cb5:	e8 7e b6 ff ff       	call   80100338 <panic>
80104cba:	66 90                	xchg   %ax,%ax

80104cbc <sys_open>:

int
sys_open(void)
{
80104cbc:	55                   	push   %ebp
80104cbd:	89 e5                	mov    %esp,%ebp
80104cbf:	57                   	push   %edi
80104cc0:	56                   	push   %esi
80104cc1:	53                   	push   %ebx
80104cc2:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104cc5:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104cc8:	50                   	push   %eax
80104cc9:	6a 00                	push   $0x0
80104ccb:	e8 b8 f8 ff ff       	call   80104588 <argstr>
80104cd0:	83 c4 10             	add    $0x10,%esp
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	0f 88 8c 00 00 00    	js     80104d67 <sys_open+0xab>
80104cdb:	83 ec 08             	sub    $0x8,%esp
80104cde:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ce1:	50                   	push   %eax
80104ce2:	6a 01                	push   $0x1
80104ce4:	e8 f3 f7 ff ff       	call   801044dc <argint>
80104ce9:	83 c4 10             	add    $0x10,%esp
80104cec:	85 c0                	test   %eax,%eax
80104cee:	78 77                	js     80104d67 <sys_open+0xab>
    return -1;

  begin_op();
80104cf0:	e8 c7 dc ff ff       	call   801029bc <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
80104cf8:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104cfc:	75 72                	jne    80104d70 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104cfe:	83 ec 0c             	sub    $0xc,%esp
80104d01:	50                   	push   %eax
80104d02:	e8 6d d1 ff ff       	call   80101e74 <namei>
80104d07:	89 c6                	mov    %eax,%esi
80104d09:	83 c4 10             	add    $0x10,%esp
80104d0c:	85 c0                	test   %eax,%eax
80104d0e:	74 7a                	je     80104d8a <sys_open+0xce>
      end_op();
      return -1;
    }
    ilock(ip);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	50                   	push   %eax
80104d14:	e8 07 c9 ff ff       	call   80101620 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104d19:	83 c4 10             	add    $0x10,%esp
80104d1c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104d21:	0f 84 b1 00 00 00    	je     80104dd8 <sys_open+0x11c>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104d27:	e8 74 c0 ff ff       	call   80100da0 <filealloc>
80104d2c:	89 c7                	mov    %eax,%edi
80104d2e:	85 c0                	test   %eax,%eax
80104d30:	74 24                	je     80104d56 <sys_open+0x9a>
  struct proc *curproc = myproc();
80104d32:	e8 c1 e7 ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d37:	31 db                	xor    %ebx,%ebx
80104d39:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104d3c:	8b 54 98 50          	mov    0x50(%eax,%ebx,4),%edx
80104d40:	85 d2                	test   %edx,%edx
80104d42:	74 50                	je     80104d94 <sys_open+0xd8>
  for(fd = 0; fd < NOFILE; fd++){
80104d44:	43                   	inc    %ebx
80104d45:	83 fb 10             	cmp    $0x10,%ebx
80104d48:	75 f2                	jne    80104d3c <sys_open+0x80>
    if(f)
      fileclose(f);
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	57                   	push   %edi
80104d4e:	e8 f9 c0 ff ff       	call   80100e4c <fileclose>
80104d53:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104d56:	83 ec 0c             	sub    $0xc,%esp
80104d59:	56                   	push   %esi
80104d5a:	e8 15 cb ff ff       	call   80101874 <iunlockput>
    end_op();
80104d5f:	e8 c0 dc ff ff       	call   80102a24 <end_op>
    return -1;
80104d64:	83 c4 10             	add    $0x10,%esp
    return -1;
80104d67:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d6c:	eb 5f                	jmp    80104dcd <sys_open+0x111>
80104d6e:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	6a 00                	push   $0x0
80104d75:	31 c9                	xor    %ecx,%ecx
80104d77:	ba 02 00 00 00       	mov    $0x2,%edx
80104d7c:	e8 cb f8 ff ff       	call   8010464c <create>
80104d81:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	75 9d                	jne    80104d27 <sys_open+0x6b>
      end_op();
80104d8a:	e8 95 dc ff ff       	call   80102a24 <end_op>
      return -1;
80104d8f:	eb d6                	jmp    80104d67 <sys_open+0xab>
80104d91:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d94:	89 7c 98 50          	mov    %edi,0x50(%eax,%ebx,4)
  }
  iunlock(ip);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	56                   	push   %esi
80104d9c:	e8 47 c9 ff ff       	call   801016e8 <iunlock>
  end_op();
80104da1:	e8 7e dc ff ff       	call   80102a24 <end_op>

  f->type = FD_INODE;
80104da6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
80104dac:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80104daf:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104db6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104db9:	89 d0                	mov    %edx,%eax
80104dbb:	f7 d0                	not    %eax
80104dbd:	83 e0 01             	and    $0x1,%eax
80104dc0:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	83 e2 03             	and    $0x3,%edx
80104dc9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80104dcd:	89 d8                	mov    %ebx,%eax
80104dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dd2:	5b                   	pop    %ebx
80104dd3:	5e                   	pop    %esi
80104dd4:	5f                   	pop    %edi
80104dd5:	5d                   	pop    %ebp
80104dd6:	c3                   	ret
80104dd7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80104dd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104ddb:	85 c9                	test   %ecx,%ecx
80104ddd:	0f 84 44 ff ff ff    	je     80104d27 <sys_open+0x6b>
80104de3:	e9 6e ff ff ff       	jmp    80104d56 <sys_open+0x9a>

80104de8 <sys_mkdir>:

int
sys_mkdir(void)
{
80104de8:	55                   	push   %ebp
80104de9:	89 e5                	mov    %esp,%ebp
80104deb:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104dee:	e8 c9 db ff ff       	call   801029bc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104df3:	83 ec 08             	sub    $0x8,%esp
80104df6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104df9:	50                   	push   %eax
80104dfa:	6a 00                	push   $0x0
80104dfc:	e8 87 f7 ff ff       	call   80104588 <argstr>
80104e01:	83 c4 10             	add    $0x10,%esp
80104e04:	85 c0                	test   %eax,%eax
80104e06:	78 30                	js     80104e38 <sys_mkdir+0x50>
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	6a 00                	push   $0x0
80104e0d:	31 c9                	xor    %ecx,%ecx
80104e0f:	ba 01 00 00 00       	mov    $0x1,%edx
80104e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e17:	e8 30 f8 ff ff       	call   8010464c <create>
80104e1c:	83 c4 10             	add    $0x10,%esp
80104e1f:	85 c0                	test   %eax,%eax
80104e21:	74 15                	je     80104e38 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104e23:	83 ec 0c             	sub    $0xc,%esp
80104e26:	50                   	push   %eax
80104e27:	e8 48 ca ff ff       	call   80101874 <iunlockput>
  end_op();
80104e2c:	e8 f3 db ff ff       	call   80102a24 <end_op>
  return 0;
80104e31:	83 c4 10             	add    $0x10,%esp
80104e34:	31 c0                	xor    %eax,%eax
}
80104e36:	c9                   	leave
80104e37:	c3                   	ret
    end_op();
80104e38:	e8 e7 db ff ff       	call   80102a24 <end_op>
    return -1;
80104e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e42:	c9                   	leave
80104e43:	c3                   	ret

80104e44 <sys_mknod>:

int
sys_mknod(void)
{
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104e4a:	e8 6d db ff ff       	call   801029bc <begin_op>
  if((argstr(0, &path)) < 0 ||
80104e4f:	83 ec 08             	sub    $0x8,%esp
80104e52:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e55:	50                   	push   %eax
80104e56:	6a 00                	push   $0x0
80104e58:	e8 2b f7 ff ff       	call   80104588 <argstr>
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 60                	js     80104ec4 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e6a:	50                   	push   %eax
80104e6b:	6a 01                	push   $0x1
80104e6d:	e8 6a f6 ff ff       	call   801044dc <argint>
  if((argstr(0, &path)) < 0 ||
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 4b                	js     80104ec4 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104e79:	83 ec 08             	sub    $0x8,%esp
80104e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7f:	50                   	push   %eax
80104e80:	6a 02                	push   $0x2
80104e82:	e8 55 f6 ff ff       	call   801044dc <argint>
     argint(1, &major) < 0 ||
80104e87:	83 c4 10             	add    $0x10,%esp
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	78 36                	js     80104ec4 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104e8e:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104e92:	83 ec 0c             	sub    $0xc,%esp
80104e95:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104e99:	50                   	push   %eax
80104e9a:	ba 03 00 00 00       	mov    $0x3,%edx
80104e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ea2:	e8 a5 f7 ff ff       	call   8010464c <create>
     argint(2, &minor) < 0 ||
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	85 c0                	test   %eax,%eax
80104eac:	74 16                	je     80104ec4 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	50                   	push   %eax
80104eb2:	e8 bd c9 ff ff       	call   80101874 <iunlockput>
  end_op();
80104eb7:	e8 68 db ff ff       	call   80102a24 <end_op>
  return 0;
80104ebc:	83 c4 10             	add    $0x10,%esp
80104ebf:	31 c0                	xor    %eax,%eax
}
80104ec1:	c9                   	leave
80104ec2:	c3                   	ret
80104ec3:	90                   	nop
    end_op();
80104ec4:	e8 5b db ff ff       	call   80102a24 <end_op>
    return -1;
80104ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ece:	c9                   	leave
80104ecf:	c3                   	ret

80104ed0 <sys_chdir>:

int
sys_chdir(void)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
80104ed5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104ed8:	e8 1b e6 ff ff       	call   801034f8 <myproc>
80104edd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104edf:	e8 d8 da ff ff       	call   801029bc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104ee4:	83 ec 08             	sub    $0x8,%esp
80104ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eea:	50                   	push   %eax
80104eeb:	6a 00                	push   $0x0
80104eed:	e8 96 f6 ff ff       	call   80104588 <argstr>
80104ef2:	83 c4 10             	add    $0x10,%esp
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	78 6b                	js     80104f64 <sys_chdir+0x94>
80104ef9:	83 ec 0c             	sub    $0xc,%esp
80104efc:	ff 75 f4             	push   -0xc(%ebp)
80104eff:	e8 70 cf ff ff       	call   80101e74 <namei>
80104f04:	89 c3                	mov    %eax,%ebx
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	74 57                	je     80104f64 <sys_chdir+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
80104f0d:	83 ec 0c             	sub    $0xc,%esp
80104f10:	50                   	push   %eax
80104f11:	e8 0a c7 ff ff       	call   80101620 <ilock>
  if(ip->type != T_DIR){
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f1e:	75 2c                	jne    80104f4c <sys_chdir+0x7c>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f20:	83 ec 0c             	sub    $0xc,%esp
80104f23:	53                   	push   %ebx
80104f24:	e8 bf c7 ff ff       	call   801016e8 <iunlock>
  iput(curproc->cwd);
80104f29:	58                   	pop    %eax
80104f2a:	ff b6 90 00 00 00    	push   0x90(%esi)
80104f30:	e8 f7 c7 ff ff       	call   8010172c <iput>
  end_op();
80104f35:	e8 ea da ff ff       	call   80102a24 <end_op>
  curproc->cwd = ip;
80104f3a:	89 9e 90 00 00 00    	mov    %ebx,0x90(%esi)
  return 0;
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f48:	5b                   	pop    %ebx
80104f49:	5e                   	pop    %esi
80104f4a:	5d                   	pop    %ebp
80104f4b:	c3                   	ret
    iunlockput(ip);
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	53                   	push   %ebx
80104f50:	e8 1f c9 ff ff       	call   80101874 <iunlockput>
    end_op();
80104f55:	e8 ca da ff ff       	call   80102a24 <end_op>
    return -1;
80104f5a:	83 c4 10             	add    $0x10,%esp
    return -1;
80104f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f62:	eb e1                	jmp    80104f45 <sys_chdir+0x75>
    end_op();
80104f64:	e8 bb da ff ff       	call   80102a24 <end_op>
    return -1;
80104f69:	eb f2                	jmp    80104f5d <sys_chdir+0x8d>
80104f6b:	90                   	nop

80104f6c <sys_exec>:

int
sys_exec(void)
{
80104f6c:	55                   	push   %ebp
80104f6d:	89 e5                	mov    %esp,%ebp
80104f6f:	57                   	push   %edi
80104f70:	56                   	push   %esi
80104f71:	53                   	push   %ebx
80104f72:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104f78:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104f7e:	50                   	push   %eax
80104f7f:	6a 00                	push   $0x0
80104f81:	e8 02 f6 ff ff       	call   80104588 <argstr>
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	78 79                	js     80105006 <sys_exec+0x9a>
80104f8d:	83 ec 08             	sub    $0x8,%esp
80104f90:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104f96:	50                   	push   %eax
80104f97:	6a 01                	push   $0x1
80104f99:	e8 3e f5 ff ff       	call   801044dc <argint>
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 61                	js     80105006 <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104fa5:	50                   	push   %eax
80104fa6:	68 80 00 00 00       	push   $0x80
80104fab:	6a 00                	push   $0x0
80104fad:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80104fb3:	57                   	push   %edi
80104fb4:	e8 ff f2 ff ff       	call   801042b8 <memset>
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
80104fbe:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104fc9:	50                   	push   %eax
80104fca:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104fd0:	01 d8                	add    %ebx,%eax
80104fd2:	50                   	push   %eax
80104fd3:	e8 8c f4 ff ff       	call   80104464 <fetchint>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	78 27                	js     80105006 <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
80104fdf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	74 2b                	je     80105014 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104fe9:	83 ec 08             	sub    $0x8,%esp
80104fec:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80104fef:	52                   	push   %edx
80104ff0:	50                   	push   %eax
80104ff1:	e8 a2 f4 ff ff       	call   80104498 <fetchstr>
80104ff6:	83 c4 10             	add    $0x10,%esp
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	78 09                	js     80105006 <sys_exec+0x9a>
  for(i=0;; i++){
80104ffd:	46                   	inc    %esi
    if(i >= NELEM(argv))
80104ffe:	83 c3 04             	add    $0x4,%ebx
80105001:	83 fe 20             	cmp    $0x20,%esi
80105004:	75 ba                	jne    80104fc0 <sys_exec+0x54>
    return -1;
80105006:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
8010500b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010500e:	5b                   	pop    %ebx
8010500f:	5e                   	pop    %esi
80105010:	5f                   	pop    %edi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret
80105013:	90                   	nop
      argv[i] = 0;
80105014:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
8010501b:	00 00 00 00 
  return exec(path, argv);
8010501f:	83 ec 08             	sub    $0x8,%esp
80105022:	57                   	push   %edi
80105023:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105029:	e8 f6 b9 ff ff       	call   80100a24 <exec>
8010502e:	83 c4 10             	add    $0x10,%esp
}
80105031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105034:	5b                   	pop    %ebx
80105035:	5e                   	pop    %esi
80105036:	5f                   	pop    %edi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret
80105039:	8d 76 00             	lea    0x0(%esi),%esi

8010503c <sys_pipe>:

int
sys_pipe(void)
{
8010503c:	55                   	push   %ebp
8010503d:	89 e5                	mov    %esp,%ebp
8010503f:	57                   	push   %edi
80105040:	56                   	push   %esi
80105041:	53                   	push   %ebx
80105042:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105045:	6a 08                	push   $0x8
80105047:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010504a:	50                   	push   %eax
8010504b:	6a 00                	push   $0x0
8010504d:	e8 ce f4 ff ff       	call   80104520 <argptr>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	78 7c                	js     801050d5 <sys_pipe+0x99>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010505f:	50                   	push   %eax
80105060:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105063:	50                   	push   %eax
80105064:	e8 63 df ff ff       	call   80102fcc <pipealloc>
80105069:	83 c4 10             	add    $0x10,%esp
8010506c:	85 c0                	test   %eax,%eax
8010506e:	78 65                	js     801050d5 <sys_pipe+0x99>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105070:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
80105073:	e8 80 e4 ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105078:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
8010507a:	8b 74 98 50          	mov    0x50(%eax,%ebx,4),%esi
8010507e:	85 f6                	test   %esi,%esi
80105080:	74 10                	je     80105092 <sys_pipe+0x56>
80105082:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
80105084:	43                   	inc    %ebx
80105085:	83 fb 10             	cmp    $0x10,%ebx
80105088:	74 34                	je     801050be <sys_pipe+0x82>
    if(curproc->ofile[fd] == 0){
8010508a:	8b 74 98 50          	mov    0x50(%eax,%ebx,4),%esi
8010508e:	85 f6                	test   %esi,%esi
80105090:	75 f2                	jne    80105084 <sys_pipe+0x48>
      curproc->ofile[fd] = f;
80105092:	8d 73 14             	lea    0x14(%ebx),%esi
80105095:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105098:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010509b:	e8 58 e4 ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050a0:	31 d2                	xor    %edx,%edx
801050a2:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801050a4:	8b 4c 90 50          	mov    0x50(%eax,%edx,4),%ecx
801050a8:	85 c9                	test   %ecx,%ecx
801050aa:	74 30                	je     801050dc <sys_pipe+0xa0>
  for(fd = 0; fd < NOFILE; fd++){
801050ac:	42                   	inc    %edx
801050ad:	83 fa 10             	cmp    $0x10,%edx
801050b0:	75 f2                	jne    801050a4 <sys_pipe+0x68>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801050b2:	e8 41 e4 ff ff       	call   801034f8 <myproc>
801050b7:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
    fileclose(rf);
801050be:	83 ec 0c             	sub    $0xc,%esp
801050c1:	ff 75 e0             	push   -0x20(%ebp)
801050c4:	e8 83 bd ff ff       	call   80100e4c <fileclose>
    fileclose(wf);
801050c9:	58                   	pop    %eax
801050ca:	ff 75 e4             	push   -0x1c(%ebp)
801050cd:	e8 7a bd ff ff       	call   80100e4c <fileclose>
    return -1;
801050d2:	83 c4 10             	add    $0x10,%esp
    return -1;
801050d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050da:	eb 11                	jmp    801050ed <sys_pipe+0xb1>
      curproc->ofile[fd] = f;
801050dc:	89 7c 90 50          	mov    %edi,0x50(%eax,%edx,4)
  }
  fd[0] = fd0;
801050e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801050e3:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801050e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801050e8:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801050eb:	31 c0                	xor    %eax,%eax
}
801050ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050f0:	5b                   	pop    %ebx
801050f1:	5e                   	pop    %esi
801050f2:	5f                   	pop    %edi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret
801050f5:	66 90                	xchg   %ax,%ax
801050f7:	90                   	nop

801050f8 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801050f8:	e9 7b e5 ff ff       	jmp    80103678 <fork>
801050fd:	8d 76 00             	lea    0x0(%esi),%esi

80105100 <sys_exit>:
}

int
sys_exit(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 08             	sub    $0x8,%esp
  exit();
80105106:	e8 61 e7 ff ff       	call   8010386c <exit>
  return 0;  // not reached
}
8010510b:	31 c0                	xor    %eax,%eax
8010510d:	c9                   	leave
8010510e:	c3                   	ret
8010510f:	90                   	nop

80105110 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105110:	e9 87 e8 ff ff       	jmp    8010399c <wait>
80105115:	8d 76 00             	lea    0x0(%esi),%esi

80105118 <sys_kill>:
}

int
sys_kill(void)
{
80105118:	55                   	push   %ebp
80105119:	89 e5                	mov    %esp,%ebp
8010511b:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010511e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105121:	50                   	push   %eax
80105122:	6a 00                	push   $0x0
80105124:	e8 b3 f3 ff ff       	call   801044dc <argint>
80105129:	83 c4 10             	add    $0x10,%esp
8010512c:	85 c0                	test   %eax,%eax
8010512e:	78 10                	js     80105140 <sys_kill+0x28>
    return -1;
  return kill(pid);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	ff 75 f4             	push   -0xc(%ebp)
80105136:	e8 e9 ea ff ff       	call   80103c24 <kill>
8010513b:	83 c4 10             	add    $0x10,%esp
}
8010513e:	c9                   	leave
8010513f:	c3                   	ret
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105145:	c9                   	leave
80105146:	c3                   	ret
80105147:	90                   	nop

80105148 <sys_getpid>:

int
sys_getpid(void)
{
80105148:	55                   	push   %ebp
80105149:	89 e5                	mov    %esp,%ebp
8010514b:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010514e:	e8 a5 e3 ff ff       	call   801034f8 <myproc>
80105153:	8b 40 38             	mov    0x38(%eax),%eax
}
80105156:	c9                   	leave
80105157:	c3                   	ret

80105158 <sys_sbrk>:

int
sys_sbrk(void)
{
80105158:	55                   	push   %ebp
80105159:	89 e5                	mov    %esp,%ebp
8010515b:	53                   	push   %ebx
8010515c:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010515f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105162:	50                   	push   %eax
80105163:	6a 00                	push   $0x0
80105165:	e8 72 f3 ff ff       	call   801044dc <argint>
8010516a:	83 c4 10             	add    $0x10,%esp
8010516d:	85 c0                	test   %eax,%eax
8010516f:	78 23                	js     80105194 <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80105171:	e8 82 e3 ff ff       	call   801034f8 <myproc>
80105176:	8b 58 28             	mov    0x28(%eax),%ebx
  if(growproc(n) < 0)
80105179:	83 ec 0c             	sub    $0xc,%esp
8010517c:	ff 75 f4             	push   -0xc(%ebp)
8010517f:	e8 80 e4 ff ff       	call   80103604 <growproc>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	78 09                	js     80105194 <sys_sbrk+0x3c>
    return -1;
  return addr;
}
8010518b:	89 d8                	mov    %ebx,%eax
8010518d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105190:	c9                   	leave
80105191:	c3                   	ret
80105192:	66 90                	xchg   %ax,%ax
    return -1;
80105194:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105199:	eb f0                	jmp    8010518b <sys_sbrk+0x33>
8010519b:	90                   	nop

8010519c <sys_sleep>:

int
sys_sleep(void)
{
8010519c:	55                   	push   %ebp
8010519d:	89 e5                	mov    %esp,%ebp
8010519f:	53                   	push   %ebx
801051a0:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801051a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051a6:	50                   	push   %eax
801051a7:	6a 00                	push   $0x0
801051a9:	e8 2e f3 ff ff       	call   801044dc <argint>
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	85 c0                	test   %eax,%eax
801051b3:	78 5c                	js     80105211 <sys_sleep+0x75>
    return -1;
  acquire(&tickslock);
801051b5:	83 ec 0c             	sub    $0xc,%esp
801051b8:	68 80 46 11 80       	push   $0x80114680
801051bd:	e8 2a f0 ff ff       	call   801041ec <acquire>
  ticks0 = ticks;
801051c2:	8b 1d 74 46 11 80    	mov    0x80114674,%ebx
  while(ticks - ticks0 < n){
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051ce:	85 d2                	test   %edx,%edx
801051d0:	75 23                	jne    801051f5 <sys_sleep+0x59>
801051d2:	eb 44                	jmp    80105218 <sys_sleep+0x7c>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	68 80 46 11 80       	push   $0x80114680
801051dc:	68 74 46 11 80       	push   $0x80114674
801051e1:	e8 26 e9 ff ff       	call   80103b0c <sleep>
  while(ticks - ticks0 < n){
801051e6:	a1 74 46 11 80       	mov    0x80114674,%eax
801051eb:	29 d8                	sub    %ebx,%eax
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801051f3:	73 23                	jae    80105218 <sys_sleep+0x7c>
    if(myproc()->killed){
801051f5:	e8 fe e2 ff ff       	call   801034f8 <myproc>
801051fa:	8b 40 4c             	mov    0x4c(%eax),%eax
801051fd:	85 c0                	test   %eax,%eax
801051ff:	74 d3                	je     801051d4 <sys_sleep+0x38>
      release(&tickslock);
80105201:	83 ec 0c             	sub    $0xc,%esp
80105204:	68 80 46 11 80       	push   $0x80114680
80105209:	e8 7e ef ff ff       	call   8010418c <release>
      return -1;
8010520e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105216:	eb 12                	jmp    8010522a <sys_sleep+0x8e>
  }
  release(&tickslock);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	68 80 46 11 80       	push   $0x80114680
80105220:	e8 67 ef ff ff       	call   8010418c <release>
  return 0;
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	31 c0                	xor    %eax,%eax
}
8010522a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010522d:	c9                   	leave
8010522e:	c3                   	ret
8010522f:	90                   	nop

80105230 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105237:	68 80 46 11 80       	push   $0x80114680
8010523c:	e8 ab ef ff ff       	call   801041ec <acquire>
  xticks = ticks;
80105241:	8b 1d 74 46 11 80    	mov    0x80114674,%ebx
  release(&tickslock);
80105247:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
8010524e:	e8 39 ef ff ff       	call   8010418c <release>
  return xticks;
}
80105253:	89 d8                	mov    %ebx,%eax
80105255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105258:	c9                   	leave
80105259:	c3                   	ret

8010525a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010525a:	1e                   	push   %ds
  pushl %es
8010525b:	06                   	push   %es
  pushl %fs
8010525c:	0f a0                	push   %fs
  pushl %gs
8010525e:	0f a8                	push   %gs
  pushal
80105260:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105261:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105265:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105267:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105269:	54                   	push   %esp
  call trap
8010526a:	e8 a1 00 00 00       	call   80105310 <trap>
  addl $4, %esp
8010526f:	83 c4 04             	add    $0x4,%esp

80105272 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105272:	61                   	popa
  popl %gs
80105273:	0f a9                	pop    %gs
  popl %fs
80105275:	0f a1                	pop    %fs
  popl %es
80105277:	07                   	pop    %es
  popl %ds
80105278:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105279:	83 c4 08             	add    $0x8,%esp
  iret
8010527c:	cf                   	iret
8010527d:	66 90                	xchg   %ax,%ax
8010527f:	90                   	nop

80105280 <tvinit>:
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;
void
tvinit(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80105286:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105288:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010528f:	66 89 14 c5 c0 46 11 	mov    %dx,-0x7feeb940(,%eax,8)
80105296:	80 
80105297:	c7 04 c5 c2 46 11 80 	movl   $0x8e000008,-0x7feeb93e(,%eax,8)
8010529e:	08 00 00 8e 
801052a2:	c1 ea 10             	shr    $0x10,%edx
801052a5:	66 89 14 c5 c6 46 11 	mov    %dx,-0x7feeb93a(,%eax,8)
801052ac:	80 
  for(i = 0; i < 256; i++)
801052ad:	40                   	inc    %eax
801052ae:	3d 00 01 00 00       	cmp    $0x100,%eax
801052b3:	75 d3                	jne    80105288 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801052b5:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801052ba:	66 a3 c0 48 11 80    	mov    %ax,0x801148c0
801052c0:	c7 05 c2 48 11 80 08 	movl   $0xef000008,0x801148c2
801052c7:	00 00 ef 
801052ca:	c1 e8 10             	shr    $0x10,%eax
801052cd:	66 a3 c6 48 11 80    	mov    %ax,0x801148c6

  initlock(&tickslock, "time");
801052d3:	83 ec 08             	sub    $0x8,%esp
801052d6:	68 5d 6e 10 80       	push   $0x80106e5d
801052db:	68 80 46 11 80       	push   $0x80114680
801052e0:	e8 3f ed ff ff       	call   80104024 <initlock>
}
801052e5:	83 c4 10             	add    $0x10,%esp
801052e8:	c9                   	leave
801052e9:	c3                   	ret
801052ea:	66 90                	xchg   %ax,%ax

801052ec <idtinit>:

void
idtinit(void)
{
801052ec:	55                   	push   %ebp
801052ed:	89 e5                	mov    %esp,%ebp
801052ef:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801052f2:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801052f8:	b8 c0 46 11 80       	mov    $0x801146c0,%eax
801052fd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105301:	c1 e8 10             	shr    $0x10,%eax
80105304:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105308:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010530b:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
8010530e:	c9                   	leave
8010530f:	c3                   	ret

80105310 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
80105316:	83 ec 1c             	sub    $0x1c,%esp
80105319:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010531c:	8b 43 30             	mov    0x30(%ebx),%eax
8010531f:	83 f8 40             	cmp    $0x40,%eax
80105322:	0f 84 90 01 00 00    	je     801054b8 <trap+0x1a8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105328:	83 e8 20             	sub    $0x20,%eax
8010532b:	83 f8 1f             	cmp    $0x1f,%eax
8010532e:	0f 87 b8 00 00 00    	ja     801053ec <trap+0xdc>
80105334:	ff 24 85 a4 73 10 80 	jmp    *-0x7fef8c5c(,%eax,4)
8010533b:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010533c:	e8 83 e1 ff ff       	call   801034c4 <cpuid>
80105341:	85 c0                	test   %eax,%eax
80105343:	0f 84 0b 02 00 00    	je     80105554 <trap+0x244>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
     acquire(&ptable.lock);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	68 40 1d 11 80       	push   $0x80111d40
80105351:	e8 96 ee ff ff       	call   801041ec <acquire>
    if (myproc() && myproc()->state == RUNNING) {
80105356:	e8 9d e1 ff ff       	call   801034f8 <myproc>
8010535b:	83 c4 10             	add    $0x10,%esp
8010535e:	85 c0                	test   %eax,%eax
80105360:	74 0f                	je     80105371 <trap+0x61>
80105362:	e8 91 e1 ff ff       	call   801034f8 <myproc>
80105367:	83 78 34 05          	cmpl   $0x5,0x34(%eax)
8010536b:	0f 84 23 02 00 00    	je     80105594 <trap+0x284>
        myproc()->total_run_time++;
    }
    release(&ptable.lock);
80105371:	83 ec 0c             	sub    $0xc,%esp
80105374:	68 40 1d 11 80       	push   $0x80111d40
80105379:	e8 0e ee ff ff       	call   8010418c <release>

    lapiceoi();
8010537e:	e8 49 d2 ff ff       	call   801025cc <lapiceoi>
    break;
80105383:	83 c4 10             	add    $0x10,%esp
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105386:	e8 6d e1 ff ff       	call   801034f8 <myproc>
8010538b:	85 c0                	test   %eax,%eax
8010538d:	74 19                	je     801053a8 <trap+0x98>
8010538f:	e8 64 e1 ff ff       	call   801034f8 <myproc>
80105394:	8b 50 4c             	mov    0x4c(%eax),%edx
80105397:	85 d2                	test   %edx,%edx
80105399:	74 0d                	je     801053a8 <trap+0x98>
8010539b:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010539e:	f7 d0                	not    %eax
801053a0:	a8 03                	test   $0x3,%al
801053a2:	0f 84 a0 01 00 00    	je     80105548 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801053a8:	e8 4b e1 ff ff       	call   801034f8 <myproc>
801053ad:	85 c0                	test   %eax,%eax
801053af:	74 0f                	je     801053c0 <trap+0xb0>
801053b1:	e8 42 e1 ff ff       	call   801034f8 <myproc>
801053b6:	83 78 34 05          	cmpl   $0x5,0x34(%eax)
801053ba:	0f 84 b0 00 00 00    	je     80105470 <trap+0x160>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801053c0:	e8 33 e1 ff ff       	call   801034f8 <myproc>
801053c5:	85 c0                	test   %eax,%eax
801053c7:	74 19                	je     801053e2 <trap+0xd2>
801053c9:	e8 2a e1 ff ff       	call   801034f8 <myproc>
801053ce:	8b 40 4c             	mov    0x4c(%eax),%eax
801053d1:	85 c0                	test   %eax,%eax
801053d3:	74 0d                	je     801053e2 <trap+0xd2>
801053d5:	8b 43 3c             	mov    0x3c(%ebx),%eax
801053d8:	f7 d0                	not    %eax
801053da:	a8 03                	test   $0x3,%al
801053dc:	0f 84 03 01 00 00    	je     801054e5 <trap+0x1d5>
    exit();
}
801053e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e5:	5b                   	pop    %ebx
801053e6:	5e                   	pop    %esi
801053e7:	5f                   	pop    %edi
801053e8:	5d                   	pop    %ebp
801053e9:	c3                   	ret
801053ea:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
801053ec:	e8 07 e1 ff ff       	call   801034f8 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801053f1:	8b 7b 38             	mov    0x38(%ebx),%edi
    if(myproc() == 0 || (tf->cs&3) == 0){
801053f4:	85 c0                	test   %eax,%eax
801053f6:	0f 84 a5 01 00 00    	je     801055a1 <trap+0x291>
801053fc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105400:	0f 84 9b 01 00 00    	je     801055a1 <trap+0x291>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105406:	0f 20 d1             	mov    %cr2,%ecx
80105409:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010540c:	e8 b3 e0 ff ff       	call   801034c4 <cpuid>
80105411:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105414:	8b 43 34             	mov    0x34(%ebx),%eax
80105417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010541a:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
8010541d:	e8 d6 e0 ff ff       	call   801034f8 <myproc>
80105422:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105425:	e8 ce e0 ff ff       	call   801034f8 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010542a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010542d:	51                   	push   %ecx
8010542e:	57                   	push   %edi
8010542f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105432:	52                   	push   %edx
80105433:	ff 75 e4             	push   -0x1c(%ebp)
80105436:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105437:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010543a:	81 c6 94 00 00 00    	add    $0x94,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105440:	56                   	push   %esi
80105441:	ff 70 38             	push   0x38(%eax)
80105444:	68 8c 70 10 80       	push   $0x8010708c
80105449:	e8 d2 b1 ff ff       	call   80100620 <cprintf>
    myproc()->killed = 1;
8010544e:	83 c4 20             	add    $0x20,%esp
80105451:	e8 a2 e0 ff ff       	call   801034f8 <myproc>
80105456:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010545d:	e8 96 e0 ff ff       	call   801034f8 <myproc>
80105462:	85 c0                	test   %eax,%eax
80105464:	0f 85 25 ff ff ff    	jne    8010538f <trap+0x7f>
8010546a:	e9 39 ff ff ff       	jmp    801053a8 <trap+0x98>
8010546f:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80105470:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105474:	0f 85 46 ff ff ff    	jne    801053c0 <trap+0xb0>
    yield();
8010547a:	e8 45 e6 ff ff       	call   80103ac4 <yield>
8010547f:	e9 3c ff ff ff       	jmp    801053c0 <trap+0xb0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105484:	8b 7b 38             	mov    0x38(%ebx),%edi
80105487:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010548b:	e8 34 e0 ff ff       	call   801034c4 <cpuid>
80105490:	57                   	push   %edi
80105491:	56                   	push   %esi
80105492:	50                   	push   %eax
80105493:	68 34 70 10 80       	push   $0x80107034
80105498:	e8 83 b1 ff ff       	call   80100620 <cprintf>
    lapiceoi();
8010549d:	e8 2a d1 ff ff       	call   801025cc <lapiceoi>
    break;
801054a2:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054a5:	e8 4e e0 ff ff       	call   801034f8 <myproc>
801054aa:	85 c0                	test   %eax,%eax
801054ac:	0f 85 dd fe ff ff    	jne    8010538f <trap+0x7f>
801054b2:	e9 f1 fe ff ff       	jmp    801053a8 <trap+0x98>
801054b7:	90                   	nop
    if(myproc()->killed)
801054b8:	e8 3b e0 ff ff       	call   801034f8 <myproc>
801054bd:	8b 70 4c             	mov    0x4c(%eax),%esi
801054c0:	85 f6                	test   %esi,%esi
801054c2:	0f 85 c0 00 00 00    	jne    80105588 <trap+0x278>
    myproc()->tf = tf;
801054c8:	e8 2b e0 ff ff       	call   801034f8 <myproc>
801054cd:	89 58 40             	mov    %ebx,0x40(%eax)
    syscall();
801054d0:	e8 1b f1 ff ff       	call   801045f0 <syscall>
    if(myproc()->killed)
801054d5:	e8 1e e0 ff ff       	call   801034f8 <myproc>
801054da:	8b 48 4c             	mov    0x4c(%eax),%ecx
801054dd:	85 c9                	test   %ecx,%ecx
801054df:	0f 84 fd fe ff ff    	je     801053e2 <trap+0xd2>
}
801054e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e8:	5b                   	pop    %ebx
801054e9:	5e                   	pop    %esi
801054ea:	5f                   	pop    %edi
801054eb:	5d                   	pop    %ebp
      exit();
801054ec:	e9 7b e3 ff ff       	jmp    8010386c <exit>
801054f1:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
801054f4:	e8 07 02 00 00       	call   80105700 <uartintr>
    lapiceoi();
801054f9:	e8 ce d0 ff ff       	call   801025cc <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054fe:	e8 f5 df ff ff       	call   801034f8 <myproc>
80105503:	85 c0                	test   %eax,%eax
80105505:	0f 85 84 fe ff ff    	jne    8010538f <trap+0x7f>
8010550b:	e9 98 fe ff ff       	jmp    801053a8 <trap+0x98>
    kbdintr();
80105510:	e8 ab cf ff ff       	call   801024c0 <kbdintr>
    lapiceoi();
80105515:	e8 b2 d0 ff ff       	call   801025cc <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010551a:	e8 d9 df ff ff       	call   801034f8 <myproc>
8010551f:	85 c0                	test   %eax,%eax
80105521:	0f 85 68 fe ff ff    	jne    8010538f <trap+0x7f>
80105527:	e9 7c fe ff ff       	jmp    801053a8 <trap+0x98>
    ideintr();
8010552c:	e8 8f ca ff ff       	call   80101fc0 <ideintr>
    lapiceoi();
80105531:	e8 96 d0 ff ff       	call   801025cc <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105536:	e8 bd df ff ff       	call   801034f8 <myproc>
8010553b:	85 c0                	test   %eax,%eax
8010553d:	0f 85 4c fe ff ff    	jne    8010538f <trap+0x7f>
80105543:	e9 60 fe ff ff       	jmp    801053a8 <trap+0x98>
    exit();
80105548:	e8 1f e3 ff ff       	call   8010386c <exit>
8010554d:	e9 56 fe ff ff       	jmp    801053a8 <trap+0x98>
80105552:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	68 80 46 11 80       	push   $0x80114680
8010555c:	e8 8b ec ff ff       	call   801041ec <acquire>
      ticks++;
80105561:	ff 05 74 46 11 80    	incl   0x80114674
      wakeup(&ticks);
80105567:	c7 04 24 74 46 11 80 	movl   $0x80114674,(%esp)
8010556e:	e8 55 e6 ff ff       	call   80103bc8 <wakeup>
      release(&tickslock);
80105573:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
8010557a:	e8 0d ec ff ff       	call   8010418c <release>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	e9 c2 fd ff ff       	jmp    80105349 <trap+0x39>
80105587:	90                   	nop
      exit();
80105588:	e8 df e2 ff ff       	call   8010386c <exit>
8010558d:	e9 36 ff ff ff       	jmp    801054c8 <trap+0x1b8>
80105592:	66 90                	xchg   %ax,%ax
        myproc()->total_run_time++;
80105594:	e8 5f df ff ff       	call   801034f8 <myproc>
80105599:	ff 40 18             	incl   0x18(%eax)
8010559c:	e9 d0 fd ff ff       	jmp    80105371 <trap+0x61>
801055a1:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801055a4:	e8 1b df ff ff       	call   801034c4 <cpuid>
801055a9:	83 ec 0c             	sub    $0xc,%esp
801055ac:	56                   	push   %esi
801055ad:	57                   	push   %edi
801055ae:	50                   	push   %eax
801055af:	ff 73 30             	push   0x30(%ebx)
801055b2:	68 58 70 10 80       	push   $0x80107058
801055b7:	e8 64 b0 ff ff       	call   80100620 <cprintf>
      panic("trap");
801055bc:	83 c4 14             	add    $0x14,%esp
801055bf:	68 62 6e 10 80       	push   $0x80106e62
801055c4:	e8 6f ad ff ff       	call   80100338 <panic>
801055c9:	66 90                	xchg   %ax,%ax
801055cb:	90                   	nop

801055cc <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801055cc:	a1 c0 4e 11 80       	mov    0x80114ec0,%eax
801055d1:	85 c0                	test   %eax,%eax
801055d3:	74 17                	je     801055ec <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801055d5:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055da:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801055db:	a8 01                	test   $0x1,%al
801055dd:	74 0d                	je     801055ec <uartgetc+0x20>
801055df:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055e4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801055e5:	0f b6 c0             	movzbl %al,%eax
801055e8:	c3                   	ret
801055e9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f1:	c3                   	ret
801055f2:	66 90                	xchg   %ax,%ax

801055f4 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801055f4:	31 c9                	xor    %ecx,%ecx
801055f6:	88 c8                	mov    %cl,%al
801055f8:	ba fa 03 00 00       	mov    $0x3fa,%edx
801055fd:	ee                   	out    %al,(%dx)
801055fe:	b0 80                	mov    $0x80,%al
80105600:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105605:	ee                   	out    %al,(%dx)
80105606:	b0 0c                	mov    $0xc,%al
80105608:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010560d:	ee                   	out    %al,(%dx)
8010560e:	88 c8                	mov    %cl,%al
80105610:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105615:	ee                   	out    %al,(%dx)
80105616:	b0 03                	mov    $0x3,%al
80105618:	ba fb 03 00 00       	mov    $0x3fb,%edx
8010561d:	ee                   	out    %al,(%dx)
8010561e:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105623:	88 c8                	mov    %cl,%al
80105625:	ee                   	out    %al,(%dx)
80105626:	b0 01                	mov    $0x1,%al
80105628:	ba f9 03 00 00       	mov    $0x3f9,%edx
8010562d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010562e:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105633:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105634:	fe c0                	inc    %al
80105636:	74 7e                	je     801056b6 <uartinit+0xc2>
{
80105638:	55                   	push   %ebp
80105639:	89 e5                	mov    %esp,%ebp
8010563b:	57                   	push   %edi
8010563c:	56                   	push   %esi
8010563d:	53                   	push   %ebx
8010563e:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
80105641:	c7 05 c0 4e 11 80 01 	movl   $0x1,0x80114ec0
80105648:	00 00 00 
8010564b:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105650:	ec                   	in     (%dx),%al
80105651:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105656:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105657:	6a 00                	push   $0x0
80105659:	6a 04                	push   $0x4
8010565b:	e8 70 cb ff ff       	call   801021d0 <ioapicenable>
80105660:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105663:	bf 67 6e 10 80       	mov    $0x80106e67,%edi
80105668:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010566c:	be fd 03 00 00       	mov    $0x3fd,%esi
80105671:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105674:	a1 c0 4e 11 80       	mov    0x80114ec0,%eax
80105679:	85 c0                	test   %eax,%eax
8010567b:	74 27                	je     801056a4 <uartinit+0xb0>
8010567d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105682:	eb 10                	jmp    80105694 <uartinit+0xa0>
    microdelay(10);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	6a 0a                	push   $0xa
80105689:	e8 56 cf ff ff       	call   801025e4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	4b                   	dec    %ebx
80105692:	74 07                	je     8010569b <uartinit+0xa7>
80105694:	89 f2                	mov    %esi,%edx
80105696:	ec                   	in     (%dx),%al
80105697:	a8 20                	test   $0x20,%al
80105699:	74 e9                	je     80105684 <uartinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010569b:	8a 45 e7             	mov    -0x19(%ebp),%al
8010569e:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056a3:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801056a4:	47                   	inc    %edi
801056a5:	8a 07                	mov    (%edi),%al
801056a7:	88 45 e7             	mov    %al,-0x19(%ebp)
801056aa:	84 c0                	test   %al,%al
801056ac:	75 c6                	jne    80105674 <uartinit+0x80>
}
801056ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b1:	5b                   	pop    %ebx
801056b2:	5e                   	pop    %esi
801056b3:	5f                   	pop    %edi
801056b4:	5d                   	pop    %ebp
801056b5:	c3                   	ret
801056b6:	c3                   	ret
801056b7:	90                   	nop

801056b8 <uartputc>:
  if(!uart)
801056b8:	a1 c0 4e 11 80       	mov    0x80114ec0,%eax
801056bd:	85 c0                	test   %eax,%eax
801056bf:	74 3b                	je     801056fc <uartputc+0x44>
{
801056c1:	55                   	push   %ebp
801056c2:	89 e5                	mov    %esp,%ebp
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
801056c6:	bb 80 00 00 00       	mov    $0x80,%ebx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056cb:	be fd 03 00 00       	mov    $0x3fd,%esi
801056d0:	eb 12                	jmp    801056e4 <uartputc+0x2c>
801056d2:	66 90                	xchg   %ax,%ax
    microdelay(10);
801056d4:	83 ec 0c             	sub    $0xc,%esp
801056d7:	6a 0a                	push   $0xa
801056d9:	e8 06 cf ff ff       	call   801025e4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	4b                   	dec    %ebx
801056e2:	74 07                	je     801056eb <uartputc+0x33>
801056e4:	89 f2                	mov    %esi,%edx
801056e6:	ec                   	in     (%dx),%al
801056e7:	a8 20                	test   $0x20,%al
801056e9:	74 e9                	je     801056d4 <uartputc+0x1c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801056eb:	8b 45 08             	mov    0x8(%ebp),%eax
801056ee:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056f3:	ee                   	out    %al,(%dx)
}
801056f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056f7:	5b                   	pop    %ebx
801056f8:	5e                   	pop    %esi
801056f9:	5d                   	pop    %ebp
801056fa:	c3                   	ret
801056fb:	90                   	nop
801056fc:	c3                   	ret
801056fd:	8d 76 00             	lea    0x0(%esi),%esi

80105700 <uartintr>:

void
uartintr(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105706:	68 cc 55 10 80       	push   $0x801055cc
8010570b:	e8 d8 b0 ff ff       	call   801007e8 <consoleintr>
}
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	c9                   	leave
80105714:	c3                   	ret

80105715 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105715:	6a 00                	push   $0x0
  pushl $0
80105717:	6a 00                	push   $0x0
  jmp alltraps
80105719:	e9 3c fb ff ff       	jmp    8010525a <alltraps>

8010571e <vector1>:
.globl vector1
vector1:
  pushl $0
8010571e:	6a 00                	push   $0x0
  pushl $1
80105720:	6a 01                	push   $0x1
  jmp alltraps
80105722:	e9 33 fb ff ff       	jmp    8010525a <alltraps>

80105727 <vector2>:
.globl vector2
vector2:
  pushl $0
80105727:	6a 00                	push   $0x0
  pushl $2
80105729:	6a 02                	push   $0x2
  jmp alltraps
8010572b:	e9 2a fb ff ff       	jmp    8010525a <alltraps>

80105730 <vector3>:
.globl vector3
vector3:
  pushl $0
80105730:	6a 00                	push   $0x0
  pushl $3
80105732:	6a 03                	push   $0x3
  jmp alltraps
80105734:	e9 21 fb ff ff       	jmp    8010525a <alltraps>

80105739 <vector4>:
.globl vector4
vector4:
  pushl $0
80105739:	6a 00                	push   $0x0
  pushl $4
8010573b:	6a 04                	push   $0x4
  jmp alltraps
8010573d:	e9 18 fb ff ff       	jmp    8010525a <alltraps>

80105742 <vector5>:
.globl vector5
vector5:
  pushl $0
80105742:	6a 00                	push   $0x0
  pushl $5
80105744:	6a 05                	push   $0x5
  jmp alltraps
80105746:	e9 0f fb ff ff       	jmp    8010525a <alltraps>

8010574b <vector6>:
.globl vector6
vector6:
  pushl $0
8010574b:	6a 00                	push   $0x0
  pushl $6
8010574d:	6a 06                	push   $0x6
  jmp alltraps
8010574f:	e9 06 fb ff ff       	jmp    8010525a <alltraps>

80105754 <vector7>:
.globl vector7
vector7:
  pushl $0
80105754:	6a 00                	push   $0x0
  pushl $7
80105756:	6a 07                	push   $0x7
  jmp alltraps
80105758:	e9 fd fa ff ff       	jmp    8010525a <alltraps>

8010575d <vector8>:
.globl vector8
vector8:
  pushl $8
8010575d:	6a 08                	push   $0x8
  jmp alltraps
8010575f:	e9 f6 fa ff ff       	jmp    8010525a <alltraps>

80105764 <vector9>:
.globl vector9
vector9:
  pushl $0
80105764:	6a 00                	push   $0x0
  pushl $9
80105766:	6a 09                	push   $0x9
  jmp alltraps
80105768:	e9 ed fa ff ff       	jmp    8010525a <alltraps>

8010576d <vector10>:
.globl vector10
vector10:
  pushl $10
8010576d:	6a 0a                	push   $0xa
  jmp alltraps
8010576f:	e9 e6 fa ff ff       	jmp    8010525a <alltraps>

80105774 <vector11>:
.globl vector11
vector11:
  pushl $11
80105774:	6a 0b                	push   $0xb
  jmp alltraps
80105776:	e9 df fa ff ff       	jmp    8010525a <alltraps>

8010577b <vector12>:
.globl vector12
vector12:
  pushl $12
8010577b:	6a 0c                	push   $0xc
  jmp alltraps
8010577d:	e9 d8 fa ff ff       	jmp    8010525a <alltraps>

80105782 <vector13>:
.globl vector13
vector13:
  pushl $13
80105782:	6a 0d                	push   $0xd
  jmp alltraps
80105784:	e9 d1 fa ff ff       	jmp    8010525a <alltraps>

80105789 <vector14>:
.globl vector14
vector14:
  pushl $14
80105789:	6a 0e                	push   $0xe
  jmp alltraps
8010578b:	e9 ca fa ff ff       	jmp    8010525a <alltraps>

80105790 <vector15>:
.globl vector15
vector15:
  pushl $0
80105790:	6a 00                	push   $0x0
  pushl $15
80105792:	6a 0f                	push   $0xf
  jmp alltraps
80105794:	e9 c1 fa ff ff       	jmp    8010525a <alltraps>

80105799 <vector16>:
.globl vector16
vector16:
  pushl $0
80105799:	6a 00                	push   $0x0
  pushl $16
8010579b:	6a 10                	push   $0x10
  jmp alltraps
8010579d:	e9 b8 fa ff ff       	jmp    8010525a <alltraps>

801057a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801057a2:	6a 11                	push   $0x11
  jmp alltraps
801057a4:	e9 b1 fa ff ff       	jmp    8010525a <alltraps>

801057a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801057a9:	6a 00                	push   $0x0
  pushl $18
801057ab:	6a 12                	push   $0x12
  jmp alltraps
801057ad:	e9 a8 fa ff ff       	jmp    8010525a <alltraps>

801057b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801057b2:	6a 00                	push   $0x0
  pushl $19
801057b4:	6a 13                	push   $0x13
  jmp alltraps
801057b6:	e9 9f fa ff ff       	jmp    8010525a <alltraps>

801057bb <vector20>:
.globl vector20
vector20:
  pushl $0
801057bb:	6a 00                	push   $0x0
  pushl $20
801057bd:	6a 14                	push   $0x14
  jmp alltraps
801057bf:	e9 96 fa ff ff       	jmp    8010525a <alltraps>

801057c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801057c4:	6a 00                	push   $0x0
  pushl $21
801057c6:	6a 15                	push   $0x15
  jmp alltraps
801057c8:	e9 8d fa ff ff       	jmp    8010525a <alltraps>

801057cd <vector22>:
.globl vector22
vector22:
  pushl $0
801057cd:	6a 00                	push   $0x0
  pushl $22
801057cf:	6a 16                	push   $0x16
  jmp alltraps
801057d1:	e9 84 fa ff ff       	jmp    8010525a <alltraps>

801057d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801057d6:	6a 00                	push   $0x0
  pushl $23
801057d8:	6a 17                	push   $0x17
  jmp alltraps
801057da:	e9 7b fa ff ff       	jmp    8010525a <alltraps>

801057df <vector24>:
.globl vector24
vector24:
  pushl $0
801057df:	6a 00                	push   $0x0
  pushl $24
801057e1:	6a 18                	push   $0x18
  jmp alltraps
801057e3:	e9 72 fa ff ff       	jmp    8010525a <alltraps>

801057e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801057e8:	6a 00                	push   $0x0
  pushl $25
801057ea:	6a 19                	push   $0x19
  jmp alltraps
801057ec:	e9 69 fa ff ff       	jmp    8010525a <alltraps>

801057f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801057f1:	6a 00                	push   $0x0
  pushl $26
801057f3:	6a 1a                	push   $0x1a
  jmp alltraps
801057f5:	e9 60 fa ff ff       	jmp    8010525a <alltraps>

801057fa <vector27>:
.globl vector27
vector27:
  pushl $0
801057fa:	6a 00                	push   $0x0
  pushl $27
801057fc:	6a 1b                	push   $0x1b
  jmp alltraps
801057fe:	e9 57 fa ff ff       	jmp    8010525a <alltraps>

80105803 <vector28>:
.globl vector28
vector28:
  pushl $0
80105803:	6a 00                	push   $0x0
  pushl $28
80105805:	6a 1c                	push   $0x1c
  jmp alltraps
80105807:	e9 4e fa ff ff       	jmp    8010525a <alltraps>

8010580c <vector29>:
.globl vector29
vector29:
  pushl $0
8010580c:	6a 00                	push   $0x0
  pushl $29
8010580e:	6a 1d                	push   $0x1d
  jmp alltraps
80105810:	e9 45 fa ff ff       	jmp    8010525a <alltraps>

80105815 <vector30>:
.globl vector30
vector30:
  pushl $0
80105815:	6a 00                	push   $0x0
  pushl $30
80105817:	6a 1e                	push   $0x1e
  jmp alltraps
80105819:	e9 3c fa ff ff       	jmp    8010525a <alltraps>

8010581e <vector31>:
.globl vector31
vector31:
  pushl $0
8010581e:	6a 00                	push   $0x0
  pushl $31
80105820:	6a 1f                	push   $0x1f
  jmp alltraps
80105822:	e9 33 fa ff ff       	jmp    8010525a <alltraps>

80105827 <vector32>:
.globl vector32
vector32:
  pushl $0
80105827:	6a 00                	push   $0x0
  pushl $32
80105829:	6a 20                	push   $0x20
  jmp alltraps
8010582b:	e9 2a fa ff ff       	jmp    8010525a <alltraps>

80105830 <vector33>:
.globl vector33
vector33:
  pushl $0
80105830:	6a 00                	push   $0x0
  pushl $33
80105832:	6a 21                	push   $0x21
  jmp alltraps
80105834:	e9 21 fa ff ff       	jmp    8010525a <alltraps>

80105839 <vector34>:
.globl vector34
vector34:
  pushl $0
80105839:	6a 00                	push   $0x0
  pushl $34
8010583b:	6a 22                	push   $0x22
  jmp alltraps
8010583d:	e9 18 fa ff ff       	jmp    8010525a <alltraps>

80105842 <vector35>:
.globl vector35
vector35:
  pushl $0
80105842:	6a 00                	push   $0x0
  pushl $35
80105844:	6a 23                	push   $0x23
  jmp alltraps
80105846:	e9 0f fa ff ff       	jmp    8010525a <alltraps>

8010584b <vector36>:
.globl vector36
vector36:
  pushl $0
8010584b:	6a 00                	push   $0x0
  pushl $36
8010584d:	6a 24                	push   $0x24
  jmp alltraps
8010584f:	e9 06 fa ff ff       	jmp    8010525a <alltraps>

80105854 <vector37>:
.globl vector37
vector37:
  pushl $0
80105854:	6a 00                	push   $0x0
  pushl $37
80105856:	6a 25                	push   $0x25
  jmp alltraps
80105858:	e9 fd f9 ff ff       	jmp    8010525a <alltraps>

8010585d <vector38>:
.globl vector38
vector38:
  pushl $0
8010585d:	6a 00                	push   $0x0
  pushl $38
8010585f:	6a 26                	push   $0x26
  jmp alltraps
80105861:	e9 f4 f9 ff ff       	jmp    8010525a <alltraps>

80105866 <vector39>:
.globl vector39
vector39:
  pushl $0
80105866:	6a 00                	push   $0x0
  pushl $39
80105868:	6a 27                	push   $0x27
  jmp alltraps
8010586a:	e9 eb f9 ff ff       	jmp    8010525a <alltraps>

8010586f <vector40>:
.globl vector40
vector40:
  pushl $0
8010586f:	6a 00                	push   $0x0
  pushl $40
80105871:	6a 28                	push   $0x28
  jmp alltraps
80105873:	e9 e2 f9 ff ff       	jmp    8010525a <alltraps>

80105878 <vector41>:
.globl vector41
vector41:
  pushl $0
80105878:	6a 00                	push   $0x0
  pushl $41
8010587a:	6a 29                	push   $0x29
  jmp alltraps
8010587c:	e9 d9 f9 ff ff       	jmp    8010525a <alltraps>

80105881 <vector42>:
.globl vector42
vector42:
  pushl $0
80105881:	6a 00                	push   $0x0
  pushl $42
80105883:	6a 2a                	push   $0x2a
  jmp alltraps
80105885:	e9 d0 f9 ff ff       	jmp    8010525a <alltraps>

8010588a <vector43>:
.globl vector43
vector43:
  pushl $0
8010588a:	6a 00                	push   $0x0
  pushl $43
8010588c:	6a 2b                	push   $0x2b
  jmp alltraps
8010588e:	e9 c7 f9 ff ff       	jmp    8010525a <alltraps>

80105893 <vector44>:
.globl vector44
vector44:
  pushl $0
80105893:	6a 00                	push   $0x0
  pushl $44
80105895:	6a 2c                	push   $0x2c
  jmp alltraps
80105897:	e9 be f9 ff ff       	jmp    8010525a <alltraps>

8010589c <vector45>:
.globl vector45
vector45:
  pushl $0
8010589c:	6a 00                	push   $0x0
  pushl $45
8010589e:	6a 2d                	push   $0x2d
  jmp alltraps
801058a0:	e9 b5 f9 ff ff       	jmp    8010525a <alltraps>

801058a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801058a5:	6a 00                	push   $0x0
  pushl $46
801058a7:	6a 2e                	push   $0x2e
  jmp alltraps
801058a9:	e9 ac f9 ff ff       	jmp    8010525a <alltraps>

801058ae <vector47>:
.globl vector47
vector47:
  pushl $0
801058ae:	6a 00                	push   $0x0
  pushl $47
801058b0:	6a 2f                	push   $0x2f
  jmp alltraps
801058b2:	e9 a3 f9 ff ff       	jmp    8010525a <alltraps>

801058b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801058b7:	6a 00                	push   $0x0
  pushl $48
801058b9:	6a 30                	push   $0x30
  jmp alltraps
801058bb:	e9 9a f9 ff ff       	jmp    8010525a <alltraps>

801058c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801058c0:	6a 00                	push   $0x0
  pushl $49
801058c2:	6a 31                	push   $0x31
  jmp alltraps
801058c4:	e9 91 f9 ff ff       	jmp    8010525a <alltraps>

801058c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801058c9:	6a 00                	push   $0x0
  pushl $50
801058cb:	6a 32                	push   $0x32
  jmp alltraps
801058cd:	e9 88 f9 ff ff       	jmp    8010525a <alltraps>

801058d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801058d2:	6a 00                	push   $0x0
  pushl $51
801058d4:	6a 33                	push   $0x33
  jmp alltraps
801058d6:	e9 7f f9 ff ff       	jmp    8010525a <alltraps>

801058db <vector52>:
.globl vector52
vector52:
  pushl $0
801058db:	6a 00                	push   $0x0
  pushl $52
801058dd:	6a 34                	push   $0x34
  jmp alltraps
801058df:	e9 76 f9 ff ff       	jmp    8010525a <alltraps>

801058e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801058e4:	6a 00                	push   $0x0
  pushl $53
801058e6:	6a 35                	push   $0x35
  jmp alltraps
801058e8:	e9 6d f9 ff ff       	jmp    8010525a <alltraps>

801058ed <vector54>:
.globl vector54
vector54:
  pushl $0
801058ed:	6a 00                	push   $0x0
  pushl $54
801058ef:	6a 36                	push   $0x36
  jmp alltraps
801058f1:	e9 64 f9 ff ff       	jmp    8010525a <alltraps>

801058f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801058f6:	6a 00                	push   $0x0
  pushl $55
801058f8:	6a 37                	push   $0x37
  jmp alltraps
801058fa:	e9 5b f9 ff ff       	jmp    8010525a <alltraps>

801058ff <vector56>:
.globl vector56
vector56:
  pushl $0
801058ff:	6a 00                	push   $0x0
  pushl $56
80105901:	6a 38                	push   $0x38
  jmp alltraps
80105903:	e9 52 f9 ff ff       	jmp    8010525a <alltraps>

80105908 <vector57>:
.globl vector57
vector57:
  pushl $0
80105908:	6a 00                	push   $0x0
  pushl $57
8010590a:	6a 39                	push   $0x39
  jmp alltraps
8010590c:	e9 49 f9 ff ff       	jmp    8010525a <alltraps>

80105911 <vector58>:
.globl vector58
vector58:
  pushl $0
80105911:	6a 00                	push   $0x0
  pushl $58
80105913:	6a 3a                	push   $0x3a
  jmp alltraps
80105915:	e9 40 f9 ff ff       	jmp    8010525a <alltraps>

8010591a <vector59>:
.globl vector59
vector59:
  pushl $0
8010591a:	6a 00                	push   $0x0
  pushl $59
8010591c:	6a 3b                	push   $0x3b
  jmp alltraps
8010591e:	e9 37 f9 ff ff       	jmp    8010525a <alltraps>

80105923 <vector60>:
.globl vector60
vector60:
  pushl $0
80105923:	6a 00                	push   $0x0
  pushl $60
80105925:	6a 3c                	push   $0x3c
  jmp alltraps
80105927:	e9 2e f9 ff ff       	jmp    8010525a <alltraps>

8010592c <vector61>:
.globl vector61
vector61:
  pushl $0
8010592c:	6a 00                	push   $0x0
  pushl $61
8010592e:	6a 3d                	push   $0x3d
  jmp alltraps
80105930:	e9 25 f9 ff ff       	jmp    8010525a <alltraps>

80105935 <vector62>:
.globl vector62
vector62:
  pushl $0
80105935:	6a 00                	push   $0x0
  pushl $62
80105937:	6a 3e                	push   $0x3e
  jmp alltraps
80105939:	e9 1c f9 ff ff       	jmp    8010525a <alltraps>

8010593e <vector63>:
.globl vector63
vector63:
  pushl $0
8010593e:	6a 00                	push   $0x0
  pushl $63
80105940:	6a 3f                	push   $0x3f
  jmp alltraps
80105942:	e9 13 f9 ff ff       	jmp    8010525a <alltraps>

80105947 <vector64>:
.globl vector64
vector64:
  pushl $0
80105947:	6a 00                	push   $0x0
  pushl $64
80105949:	6a 40                	push   $0x40
  jmp alltraps
8010594b:	e9 0a f9 ff ff       	jmp    8010525a <alltraps>

80105950 <vector65>:
.globl vector65
vector65:
  pushl $0
80105950:	6a 00                	push   $0x0
  pushl $65
80105952:	6a 41                	push   $0x41
  jmp alltraps
80105954:	e9 01 f9 ff ff       	jmp    8010525a <alltraps>

80105959 <vector66>:
.globl vector66
vector66:
  pushl $0
80105959:	6a 00                	push   $0x0
  pushl $66
8010595b:	6a 42                	push   $0x42
  jmp alltraps
8010595d:	e9 f8 f8 ff ff       	jmp    8010525a <alltraps>

80105962 <vector67>:
.globl vector67
vector67:
  pushl $0
80105962:	6a 00                	push   $0x0
  pushl $67
80105964:	6a 43                	push   $0x43
  jmp alltraps
80105966:	e9 ef f8 ff ff       	jmp    8010525a <alltraps>

8010596b <vector68>:
.globl vector68
vector68:
  pushl $0
8010596b:	6a 00                	push   $0x0
  pushl $68
8010596d:	6a 44                	push   $0x44
  jmp alltraps
8010596f:	e9 e6 f8 ff ff       	jmp    8010525a <alltraps>

80105974 <vector69>:
.globl vector69
vector69:
  pushl $0
80105974:	6a 00                	push   $0x0
  pushl $69
80105976:	6a 45                	push   $0x45
  jmp alltraps
80105978:	e9 dd f8 ff ff       	jmp    8010525a <alltraps>

8010597d <vector70>:
.globl vector70
vector70:
  pushl $0
8010597d:	6a 00                	push   $0x0
  pushl $70
8010597f:	6a 46                	push   $0x46
  jmp alltraps
80105981:	e9 d4 f8 ff ff       	jmp    8010525a <alltraps>

80105986 <vector71>:
.globl vector71
vector71:
  pushl $0
80105986:	6a 00                	push   $0x0
  pushl $71
80105988:	6a 47                	push   $0x47
  jmp alltraps
8010598a:	e9 cb f8 ff ff       	jmp    8010525a <alltraps>

8010598f <vector72>:
.globl vector72
vector72:
  pushl $0
8010598f:	6a 00                	push   $0x0
  pushl $72
80105991:	6a 48                	push   $0x48
  jmp alltraps
80105993:	e9 c2 f8 ff ff       	jmp    8010525a <alltraps>

80105998 <vector73>:
.globl vector73
vector73:
  pushl $0
80105998:	6a 00                	push   $0x0
  pushl $73
8010599a:	6a 49                	push   $0x49
  jmp alltraps
8010599c:	e9 b9 f8 ff ff       	jmp    8010525a <alltraps>

801059a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $74
801059a3:	6a 4a                	push   $0x4a
  jmp alltraps
801059a5:	e9 b0 f8 ff ff       	jmp    8010525a <alltraps>

801059aa <vector75>:
.globl vector75
vector75:
  pushl $0
801059aa:	6a 00                	push   $0x0
  pushl $75
801059ac:	6a 4b                	push   $0x4b
  jmp alltraps
801059ae:	e9 a7 f8 ff ff       	jmp    8010525a <alltraps>

801059b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $76
801059b5:	6a 4c                	push   $0x4c
  jmp alltraps
801059b7:	e9 9e f8 ff ff       	jmp    8010525a <alltraps>

801059bc <vector77>:
.globl vector77
vector77:
  pushl $0
801059bc:	6a 00                	push   $0x0
  pushl $77
801059be:	6a 4d                	push   $0x4d
  jmp alltraps
801059c0:	e9 95 f8 ff ff       	jmp    8010525a <alltraps>

801059c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $78
801059c7:	6a 4e                	push   $0x4e
  jmp alltraps
801059c9:	e9 8c f8 ff ff       	jmp    8010525a <alltraps>

801059ce <vector79>:
.globl vector79
vector79:
  pushl $0
801059ce:	6a 00                	push   $0x0
  pushl $79
801059d0:	6a 4f                	push   $0x4f
  jmp alltraps
801059d2:	e9 83 f8 ff ff       	jmp    8010525a <alltraps>

801059d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $80
801059d9:	6a 50                	push   $0x50
  jmp alltraps
801059db:	e9 7a f8 ff ff       	jmp    8010525a <alltraps>

801059e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801059e0:	6a 00                	push   $0x0
  pushl $81
801059e2:	6a 51                	push   $0x51
  jmp alltraps
801059e4:	e9 71 f8 ff ff       	jmp    8010525a <alltraps>

801059e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $82
801059eb:	6a 52                	push   $0x52
  jmp alltraps
801059ed:	e9 68 f8 ff ff       	jmp    8010525a <alltraps>

801059f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801059f2:	6a 00                	push   $0x0
  pushl $83
801059f4:	6a 53                	push   $0x53
  jmp alltraps
801059f6:	e9 5f f8 ff ff       	jmp    8010525a <alltraps>

801059fb <vector84>:
.globl vector84
vector84:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $84
801059fd:	6a 54                	push   $0x54
  jmp alltraps
801059ff:	e9 56 f8 ff ff       	jmp    8010525a <alltraps>

80105a04 <vector85>:
.globl vector85
vector85:
  pushl $0
80105a04:	6a 00                	push   $0x0
  pushl $85
80105a06:	6a 55                	push   $0x55
  jmp alltraps
80105a08:	e9 4d f8 ff ff       	jmp    8010525a <alltraps>

80105a0d <vector86>:
.globl vector86
vector86:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $86
80105a0f:	6a 56                	push   $0x56
  jmp alltraps
80105a11:	e9 44 f8 ff ff       	jmp    8010525a <alltraps>

80105a16 <vector87>:
.globl vector87
vector87:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $87
80105a18:	6a 57                	push   $0x57
  jmp alltraps
80105a1a:	e9 3b f8 ff ff       	jmp    8010525a <alltraps>

80105a1f <vector88>:
.globl vector88
vector88:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $88
80105a21:	6a 58                	push   $0x58
  jmp alltraps
80105a23:	e9 32 f8 ff ff       	jmp    8010525a <alltraps>

80105a28 <vector89>:
.globl vector89
vector89:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $89
80105a2a:	6a 59                	push   $0x59
  jmp alltraps
80105a2c:	e9 29 f8 ff ff       	jmp    8010525a <alltraps>

80105a31 <vector90>:
.globl vector90
vector90:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $90
80105a33:	6a 5a                	push   $0x5a
  jmp alltraps
80105a35:	e9 20 f8 ff ff       	jmp    8010525a <alltraps>

80105a3a <vector91>:
.globl vector91
vector91:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $91
80105a3c:	6a 5b                	push   $0x5b
  jmp alltraps
80105a3e:	e9 17 f8 ff ff       	jmp    8010525a <alltraps>

80105a43 <vector92>:
.globl vector92
vector92:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $92
80105a45:	6a 5c                	push   $0x5c
  jmp alltraps
80105a47:	e9 0e f8 ff ff       	jmp    8010525a <alltraps>

80105a4c <vector93>:
.globl vector93
vector93:
  pushl $0
80105a4c:	6a 00                	push   $0x0
  pushl $93
80105a4e:	6a 5d                	push   $0x5d
  jmp alltraps
80105a50:	e9 05 f8 ff ff       	jmp    8010525a <alltraps>

80105a55 <vector94>:
.globl vector94
vector94:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $94
80105a57:	6a 5e                	push   $0x5e
  jmp alltraps
80105a59:	e9 fc f7 ff ff       	jmp    8010525a <alltraps>

80105a5e <vector95>:
.globl vector95
vector95:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $95
80105a60:	6a 5f                	push   $0x5f
  jmp alltraps
80105a62:	e9 f3 f7 ff ff       	jmp    8010525a <alltraps>

80105a67 <vector96>:
.globl vector96
vector96:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $96
80105a69:	6a 60                	push   $0x60
  jmp alltraps
80105a6b:	e9 ea f7 ff ff       	jmp    8010525a <alltraps>

80105a70 <vector97>:
.globl vector97
vector97:
  pushl $0
80105a70:	6a 00                	push   $0x0
  pushl $97
80105a72:	6a 61                	push   $0x61
  jmp alltraps
80105a74:	e9 e1 f7 ff ff       	jmp    8010525a <alltraps>

80105a79 <vector98>:
.globl vector98
vector98:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $98
80105a7b:	6a 62                	push   $0x62
  jmp alltraps
80105a7d:	e9 d8 f7 ff ff       	jmp    8010525a <alltraps>

80105a82 <vector99>:
.globl vector99
vector99:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $99
80105a84:	6a 63                	push   $0x63
  jmp alltraps
80105a86:	e9 cf f7 ff ff       	jmp    8010525a <alltraps>

80105a8b <vector100>:
.globl vector100
vector100:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $100
80105a8d:	6a 64                	push   $0x64
  jmp alltraps
80105a8f:	e9 c6 f7 ff ff       	jmp    8010525a <alltraps>

80105a94 <vector101>:
.globl vector101
vector101:
  pushl $0
80105a94:	6a 00                	push   $0x0
  pushl $101
80105a96:	6a 65                	push   $0x65
  jmp alltraps
80105a98:	e9 bd f7 ff ff       	jmp    8010525a <alltraps>

80105a9d <vector102>:
.globl vector102
vector102:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $102
80105a9f:	6a 66                	push   $0x66
  jmp alltraps
80105aa1:	e9 b4 f7 ff ff       	jmp    8010525a <alltraps>

80105aa6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $103
80105aa8:	6a 67                	push   $0x67
  jmp alltraps
80105aaa:	e9 ab f7 ff ff       	jmp    8010525a <alltraps>

80105aaf <vector104>:
.globl vector104
vector104:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $104
80105ab1:	6a 68                	push   $0x68
  jmp alltraps
80105ab3:	e9 a2 f7 ff ff       	jmp    8010525a <alltraps>

80105ab8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $105
80105aba:	6a 69                	push   $0x69
  jmp alltraps
80105abc:	e9 99 f7 ff ff       	jmp    8010525a <alltraps>

80105ac1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $106
80105ac3:	6a 6a                	push   $0x6a
  jmp alltraps
80105ac5:	e9 90 f7 ff ff       	jmp    8010525a <alltraps>

80105aca <vector107>:
.globl vector107
vector107:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $107
80105acc:	6a 6b                	push   $0x6b
  jmp alltraps
80105ace:	e9 87 f7 ff ff       	jmp    8010525a <alltraps>

80105ad3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $108
80105ad5:	6a 6c                	push   $0x6c
  jmp alltraps
80105ad7:	e9 7e f7 ff ff       	jmp    8010525a <alltraps>

80105adc <vector109>:
.globl vector109
vector109:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $109
80105ade:	6a 6d                	push   $0x6d
  jmp alltraps
80105ae0:	e9 75 f7 ff ff       	jmp    8010525a <alltraps>

80105ae5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $110
80105ae7:	6a 6e                	push   $0x6e
  jmp alltraps
80105ae9:	e9 6c f7 ff ff       	jmp    8010525a <alltraps>

80105aee <vector111>:
.globl vector111
vector111:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $111
80105af0:	6a 6f                	push   $0x6f
  jmp alltraps
80105af2:	e9 63 f7 ff ff       	jmp    8010525a <alltraps>

80105af7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $112
80105af9:	6a 70                	push   $0x70
  jmp alltraps
80105afb:	e9 5a f7 ff ff       	jmp    8010525a <alltraps>

80105b00 <vector113>:
.globl vector113
vector113:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $113
80105b02:	6a 71                	push   $0x71
  jmp alltraps
80105b04:	e9 51 f7 ff ff       	jmp    8010525a <alltraps>

80105b09 <vector114>:
.globl vector114
vector114:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $114
80105b0b:	6a 72                	push   $0x72
  jmp alltraps
80105b0d:	e9 48 f7 ff ff       	jmp    8010525a <alltraps>

80105b12 <vector115>:
.globl vector115
vector115:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $115
80105b14:	6a 73                	push   $0x73
  jmp alltraps
80105b16:	e9 3f f7 ff ff       	jmp    8010525a <alltraps>

80105b1b <vector116>:
.globl vector116
vector116:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $116
80105b1d:	6a 74                	push   $0x74
  jmp alltraps
80105b1f:	e9 36 f7 ff ff       	jmp    8010525a <alltraps>

80105b24 <vector117>:
.globl vector117
vector117:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $117
80105b26:	6a 75                	push   $0x75
  jmp alltraps
80105b28:	e9 2d f7 ff ff       	jmp    8010525a <alltraps>

80105b2d <vector118>:
.globl vector118
vector118:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $118
80105b2f:	6a 76                	push   $0x76
  jmp alltraps
80105b31:	e9 24 f7 ff ff       	jmp    8010525a <alltraps>

80105b36 <vector119>:
.globl vector119
vector119:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $119
80105b38:	6a 77                	push   $0x77
  jmp alltraps
80105b3a:	e9 1b f7 ff ff       	jmp    8010525a <alltraps>

80105b3f <vector120>:
.globl vector120
vector120:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $120
80105b41:	6a 78                	push   $0x78
  jmp alltraps
80105b43:	e9 12 f7 ff ff       	jmp    8010525a <alltraps>

80105b48 <vector121>:
.globl vector121
vector121:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $121
80105b4a:	6a 79                	push   $0x79
  jmp alltraps
80105b4c:	e9 09 f7 ff ff       	jmp    8010525a <alltraps>

80105b51 <vector122>:
.globl vector122
vector122:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $122
80105b53:	6a 7a                	push   $0x7a
  jmp alltraps
80105b55:	e9 00 f7 ff ff       	jmp    8010525a <alltraps>

80105b5a <vector123>:
.globl vector123
vector123:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $123
80105b5c:	6a 7b                	push   $0x7b
  jmp alltraps
80105b5e:	e9 f7 f6 ff ff       	jmp    8010525a <alltraps>

80105b63 <vector124>:
.globl vector124
vector124:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $124
80105b65:	6a 7c                	push   $0x7c
  jmp alltraps
80105b67:	e9 ee f6 ff ff       	jmp    8010525a <alltraps>

80105b6c <vector125>:
.globl vector125
vector125:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $125
80105b6e:	6a 7d                	push   $0x7d
  jmp alltraps
80105b70:	e9 e5 f6 ff ff       	jmp    8010525a <alltraps>

80105b75 <vector126>:
.globl vector126
vector126:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $126
80105b77:	6a 7e                	push   $0x7e
  jmp alltraps
80105b79:	e9 dc f6 ff ff       	jmp    8010525a <alltraps>

80105b7e <vector127>:
.globl vector127
vector127:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $127
80105b80:	6a 7f                	push   $0x7f
  jmp alltraps
80105b82:	e9 d3 f6 ff ff       	jmp    8010525a <alltraps>

80105b87 <vector128>:
.globl vector128
vector128:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $128
80105b89:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105b8e:	e9 c7 f6 ff ff       	jmp    8010525a <alltraps>

80105b93 <vector129>:
.globl vector129
vector129:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $129
80105b95:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105b9a:	e9 bb f6 ff ff       	jmp    8010525a <alltraps>

80105b9f <vector130>:
.globl vector130
vector130:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $130
80105ba1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ba6:	e9 af f6 ff ff       	jmp    8010525a <alltraps>

80105bab <vector131>:
.globl vector131
vector131:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $131
80105bad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105bb2:	e9 a3 f6 ff ff       	jmp    8010525a <alltraps>

80105bb7 <vector132>:
.globl vector132
vector132:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $132
80105bb9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105bbe:	e9 97 f6 ff ff       	jmp    8010525a <alltraps>

80105bc3 <vector133>:
.globl vector133
vector133:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $133
80105bc5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105bca:	e9 8b f6 ff ff       	jmp    8010525a <alltraps>

80105bcf <vector134>:
.globl vector134
vector134:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $134
80105bd1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105bd6:	e9 7f f6 ff ff       	jmp    8010525a <alltraps>

80105bdb <vector135>:
.globl vector135
vector135:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $135
80105bdd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105be2:	e9 73 f6 ff ff       	jmp    8010525a <alltraps>

80105be7 <vector136>:
.globl vector136
vector136:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $136
80105be9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105bee:	e9 67 f6 ff ff       	jmp    8010525a <alltraps>

80105bf3 <vector137>:
.globl vector137
vector137:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $137
80105bf5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105bfa:	e9 5b f6 ff ff       	jmp    8010525a <alltraps>

80105bff <vector138>:
.globl vector138
vector138:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $138
80105c01:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c06:	e9 4f f6 ff ff       	jmp    8010525a <alltraps>

80105c0b <vector139>:
.globl vector139
vector139:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $139
80105c0d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c12:	e9 43 f6 ff ff       	jmp    8010525a <alltraps>

80105c17 <vector140>:
.globl vector140
vector140:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $140
80105c19:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c1e:	e9 37 f6 ff ff       	jmp    8010525a <alltraps>

80105c23 <vector141>:
.globl vector141
vector141:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $141
80105c25:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105c2a:	e9 2b f6 ff ff       	jmp    8010525a <alltraps>

80105c2f <vector142>:
.globl vector142
vector142:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $142
80105c31:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105c36:	e9 1f f6 ff ff       	jmp    8010525a <alltraps>

80105c3b <vector143>:
.globl vector143
vector143:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $143
80105c3d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105c42:	e9 13 f6 ff ff       	jmp    8010525a <alltraps>

80105c47 <vector144>:
.globl vector144
vector144:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $144
80105c49:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105c4e:	e9 07 f6 ff ff       	jmp    8010525a <alltraps>

80105c53 <vector145>:
.globl vector145
vector145:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $145
80105c55:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c5a:	e9 fb f5 ff ff       	jmp    8010525a <alltraps>

80105c5f <vector146>:
.globl vector146
vector146:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $146
80105c61:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c66:	e9 ef f5 ff ff       	jmp    8010525a <alltraps>

80105c6b <vector147>:
.globl vector147
vector147:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $147
80105c6d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105c72:	e9 e3 f5 ff ff       	jmp    8010525a <alltraps>

80105c77 <vector148>:
.globl vector148
vector148:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $148
80105c79:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105c7e:	e9 d7 f5 ff ff       	jmp    8010525a <alltraps>

80105c83 <vector149>:
.globl vector149
vector149:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $149
80105c85:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105c8a:	e9 cb f5 ff ff       	jmp    8010525a <alltraps>

80105c8f <vector150>:
.globl vector150
vector150:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $150
80105c91:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105c96:	e9 bf f5 ff ff       	jmp    8010525a <alltraps>

80105c9b <vector151>:
.globl vector151
vector151:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $151
80105c9d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105ca2:	e9 b3 f5 ff ff       	jmp    8010525a <alltraps>

80105ca7 <vector152>:
.globl vector152
vector152:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $152
80105ca9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105cae:	e9 a7 f5 ff ff       	jmp    8010525a <alltraps>

80105cb3 <vector153>:
.globl vector153
vector153:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $153
80105cb5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105cba:	e9 9b f5 ff ff       	jmp    8010525a <alltraps>

80105cbf <vector154>:
.globl vector154
vector154:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $154
80105cc1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105cc6:	e9 8f f5 ff ff       	jmp    8010525a <alltraps>

80105ccb <vector155>:
.globl vector155
vector155:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $155
80105ccd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105cd2:	e9 83 f5 ff ff       	jmp    8010525a <alltraps>

80105cd7 <vector156>:
.globl vector156
vector156:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $156
80105cd9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105cde:	e9 77 f5 ff ff       	jmp    8010525a <alltraps>

80105ce3 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $157
80105ce5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105cea:	e9 6b f5 ff ff       	jmp    8010525a <alltraps>

80105cef <vector158>:
.globl vector158
vector158:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $158
80105cf1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105cf6:	e9 5f f5 ff ff       	jmp    8010525a <alltraps>

80105cfb <vector159>:
.globl vector159
vector159:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $159
80105cfd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105d02:	e9 53 f5 ff ff       	jmp    8010525a <alltraps>

80105d07 <vector160>:
.globl vector160
vector160:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $160
80105d09:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d0e:	e9 47 f5 ff ff       	jmp    8010525a <alltraps>

80105d13 <vector161>:
.globl vector161
vector161:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $161
80105d15:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105d1a:	e9 3b f5 ff ff       	jmp    8010525a <alltraps>

80105d1f <vector162>:
.globl vector162
vector162:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $162
80105d21:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d26:	e9 2f f5 ff ff       	jmp    8010525a <alltraps>

80105d2b <vector163>:
.globl vector163
vector163:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $163
80105d2d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105d32:	e9 23 f5 ff ff       	jmp    8010525a <alltraps>

80105d37 <vector164>:
.globl vector164
vector164:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $164
80105d39:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105d3e:	e9 17 f5 ff ff       	jmp    8010525a <alltraps>

80105d43 <vector165>:
.globl vector165
vector165:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $165
80105d45:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105d4a:	e9 0b f5 ff ff       	jmp    8010525a <alltraps>

80105d4f <vector166>:
.globl vector166
vector166:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $166
80105d51:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d56:	e9 ff f4 ff ff       	jmp    8010525a <alltraps>

80105d5b <vector167>:
.globl vector167
vector167:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $167
80105d5d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d62:	e9 f3 f4 ff ff       	jmp    8010525a <alltraps>

80105d67 <vector168>:
.globl vector168
vector168:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $168
80105d69:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105d6e:	e9 e7 f4 ff ff       	jmp    8010525a <alltraps>

80105d73 <vector169>:
.globl vector169
vector169:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $169
80105d75:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105d7a:	e9 db f4 ff ff       	jmp    8010525a <alltraps>

80105d7f <vector170>:
.globl vector170
vector170:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $170
80105d81:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105d86:	e9 cf f4 ff ff       	jmp    8010525a <alltraps>

80105d8b <vector171>:
.globl vector171
vector171:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $171
80105d8d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105d92:	e9 c3 f4 ff ff       	jmp    8010525a <alltraps>

80105d97 <vector172>:
.globl vector172
vector172:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $172
80105d99:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105d9e:	e9 b7 f4 ff ff       	jmp    8010525a <alltraps>

80105da3 <vector173>:
.globl vector173
vector173:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $173
80105da5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105daa:	e9 ab f4 ff ff       	jmp    8010525a <alltraps>

80105daf <vector174>:
.globl vector174
vector174:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $174
80105db1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105db6:	e9 9f f4 ff ff       	jmp    8010525a <alltraps>

80105dbb <vector175>:
.globl vector175
vector175:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $175
80105dbd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105dc2:	e9 93 f4 ff ff       	jmp    8010525a <alltraps>

80105dc7 <vector176>:
.globl vector176
vector176:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $176
80105dc9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105dce:	e9 87 f4 ff ff       	jmp    8010525a <alltraps>

80105dd3 <vector177>:
.globl vector177
vector177:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $177
80105dd5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105dda:	e9 7b f4 ff ff       	jmp    8010525a <alltraps>

80105ddf <vector178>:
.globl vector178
vector178:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $178
80105de1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105de6:	e9 6f f4 ff ff       	jmp    8010525a <alltraps>

80105deb <vector179>:
.globl vector179
vector179:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $179
80105ded:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105df2:	e9 63 f4 ff ff       	jmp    8010525a <alltraps>

80105df7 <vector180>:
.globl vector180
vector180:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $180
80105df9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105dfe:	e9 57 f4 ff ff       	jmp    8010525a <alltraps>

80105e03 <vector181>:
.globl vector181
vector181:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $181
80105e05:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e0a:	e9 4b f4 ff ff       	jmp    8010525a <alltraps>

80105e0f <vector182>:
.globl vector182
vector182:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $182
80105e11:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e16:	e9 3f f4 ff ff       	jmp    8010525a <alltraps>

80105e1b <vector183>:
.globl vector183
vector183:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $183
80105e1d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e22:	e9 33 f4 ff ff       	jmp    8010525a <alltraps>

80105e27 <vector184>:
.globl vector184
vector184:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $184
80105e29:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105e2e:	e9 27 f4 ff ff       	jmp    8010525a <alltraps>

80105e33 <vector185>:
.globl vector185
vector185:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $185
80105e35:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105e3a:	e9 1b f4 ff ff       	jmp    8010525a <alltraps>

80105e3f <vector186>:
.globl vector186
vector186:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $186
80105e41:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105e46:	e9 0f f4 ff ff       	jmp    8010525a <alltraps>

80105e4b <vector187>:
.globl vector187
vector187:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $187
80105e4d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105e52:	e9 03 f4 ff ff       	jmp    8010525a <alltraps>

80105e57 <vector188>:
.globl vector188
vector188:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $188
80105e59:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e5e:	e9 f7 f3 ff ff       	jmp    8010525a <alltraps>

80105e63 <vector189>:
.globl vector189
vector189:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $189
80105e65:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105e6a:	e9 eb f3 ff ff       	jmp    8010525a <alltraps>

80105e6f <vector190>:
.globl vector190
vector190:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $190
80105e71:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105e76:	e9 df f3 ff ff       	jmp    8010525a <alltraps>

80105e7b <vector191>:
.globl vector191
vector191:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $191
80105e7d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105e82:	e9 d3 f3 ff ff       	jmp    8010525a <alltraps>

80105e87 <vector192>:
.globl vector192
vector192:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $192
80105e89:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105e8e:	e9 c7 f3 ff ff       	jmp    8010525a <alltraps>

80105e93 <vector193>:
.globl vector193
vector193:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $193
80105e95:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105e9a:	e9 bb f3 ff ff       	jmp    8010525a <alltraps>

80105e9f <vector194>:
.globl vector194
vector194:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $194
80105ea1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ea6:	e9 af f3 ff ff       	jmp    8010525a <alltraps>

80105eab <vector195>:
.globl vector195
vector195:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $195
80105ead:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105eb2:	e9 a3 f3 ff ff       	jmp    8010525a <alltraps>

80105eb7 <vector196>:
.globl vector196
vector196:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $196
80105eb9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105ebe:	e9 97 f3 ff ff       	jmp    8010525a <alltraps>

80105ec3 <vector197>:
.globl vector197
vector197:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $197
80105ec5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105eca:	e9 8b f3 ff ff       	jmp    8010525a <alltraps>

80105ecf <vector198>:
.globl vector198
vector198:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $198
80105ed1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105ed6:	e9 7f f3 ff ff       	jmp    8010525a <alltraps>

80105edb <vector199>:
.globl vector199
vector199:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $199
80105edd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105ee2:	e9 73 f3 ff ff       	jmp    8010525a <alltraps>

80105ee7 <vector200>:
.globl vector200
vector200:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $200
80105ee9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105eee:	e9 67 f3 ff ff       	jmp    8010525a <alltraps>

80105ef3 <vector201>:
.globl vector201
vector201:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $201
80105ef5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105efa:	e9 5b f3 ff ff       	jmp    8010525a <alltraps>

80105eff <vector202>:
.globl vector202
vector202:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $202
80105f01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f06:	e9 4f f3 ff ff       	jmp    8010525a <alltraps>

80105f0b <vector203>:
.globl vector203
vector203:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $203
80105f0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f12:	e9 43 f3 ff ff       	jmp    8010525a <alltraps>

80105f17 <vector204>:
.globl vector204
vector204:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $204
80105f19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f1e:	e9 37 f3 ff ff       	jmp    8010525a <alltraps>

80105f23 <vector205>:
.globl vector205
vector205:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $205
80105f25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105f2a:	e9 2b f3 ff ff       	jmp    8010525a <alltraps>

80105f2f <vector206>:
.globl vector206
vector206:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $206
80105f31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105f36:	e9 1f f3 ff ff       	jmp    8010525a <alltraps>

80105f3b <vector207>:
.globl vector207
vector207:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $207
80105f3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105f42:	e9 13 f3 ff ff       	jmp    8010525a <alltraps>

80105f47 <vector208>:
.globl vector208
vector208:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $208
80105f49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105f4e:	e9 07 f3 ff ff       	jmp    8010525a <alltraps>

80105f53 <vector209>:
.globl vector209
vector209:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $209
80105f55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f5a:	e9 fb f2 ff ff       	jmp    8010525a <alltraps>

80105f5f <vector210>:
.globl vector210
vector210:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $210
80105f61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f66:	e9 ef f2 ff ff       	jmp    8010525a <alltraps>

80105f6b <vector211>:
.globl vector211
vector211:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $211
80105f6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105f72:	e9 e3 f2 ff ff       	jmp    8010525a <alltraps>

80105f77 <vector212>:
.globl vector212
vector212:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $212
80105f79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105f7e:	e9 d7 f2 ff ff       	jmp    8010525a <alltraps>

80105f83 <vector213>:
.globl vector213
vector213:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $213
80105f85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105f8a:	e9 cb f2 ff ff       	jmp    8010525a <alltraps>

80105f8f <vector214>:
.globl vector214
vector214:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $214
80105f91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105f96:	e9 bf f2 ff ff       	jmp    8010525a <alltraps>

80105f9b <vector215>:
.globl vector215
vector215:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $215
80105f9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105fa2:	e9 b3 f2 ff ff       	jmp    8010525a <alltraps>

80105fa7 <vector216>:
.globl vector216
vector216:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $216
80105fa9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105fae:	e9 a7 f2 ff ff       	jmp    8010525a <alltraps>

80105fb3 <vector217>:
.globl vector217
vector217:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $217
80105fb5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105fba:	e9 9b f2 ff ff       	jmp    8010525a <alltraps>

80105fbf <vector218>:
.globl vector218
vector218:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $218
80105fc1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105fc6:	e9 8f f2 ff ff       	jmp    8010525a <alltraps>

80105fcb <vector219>:
.globl vector219
vector219:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $219
80105fcd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105fd2:	e9 83 f2 ff ff       	jmp    8010525a <alltraps>

80105fd7 <vector220>:
.globl vector220
vector220:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $220
80105fd9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105fde:	e9 77 f2 ff ff       	jmp    8010525a <alltraps>

80105fe3 <vector221>:
.globl vector221
vector221:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $221
80105fe5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105fea:	e9 6b f2 ff ff       	jmp    8010525a <alltraps>

80105fef <vector222>:
.globl vector222
vector222:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $222
80105ff1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105ff6:	e9 5f f2 ff ff       	jmp    8010525a <alltraps>

80105ffb <vector223>:
.globl vector223
vector223:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $223
80105ffd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106002:	e9 53 f2 ff ff       	jmp    8010525a <alltraps>

80106007 <vector224>:
.globl vector224
vector224:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $224
80106009:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010600e:	e9 47 f2 ff ff       	jmp    8010525a <alltraps>

80106013 <vector225>:
.globl vector225
vector225:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $225
80106015:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010601a:	e9 3b f2 ff ff       	jmp    8010525a <alltraps>

8010601f <vector226>:
.globl vector226
vector226:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $226
80106021:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106026:	e9 2f f2 ff ff       	jmp    8010525a <alltraps>

8010602b <vector227>:
.globl vector227
vector227:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $227
8010602d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106032:	e9 23 f2 ff ff       	jmp    8010525a <alltraps>

80106037 <vector228>:
.globl vector228
vector228:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $228
80106039:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010603e:	e9 17 f2 ff ff       	jmp    8010525a <alltraps>

80106043 <vector229>:
.globl vector229
vector229:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $229
80106045:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010604a:	e9 0b f2 ff ff       	jmp    8010525a <alltraps>

8010604f <vector230>:
.globl vector230
vector230:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $230
80106051:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106056:	e9 ff f1 ff ff       	jmp    8010525a <alltraps>

8010605b <vector231>:
.globl vector231
vector231:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $231
8010605d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106062:	e9 f3 f1 ff ff       	jmp    8010525a <alltraps>

80106067 <vector232>:
.globl vector232
vector232:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $232
80106069:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010606e:	e9 e7 f1 ff ff       	jmp    8010525a <alltraps>

80106073 <vector233>:
.globl vector233
vector233:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $233
80106075:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010607a:	e9 db f1 ff ff       	jmp    8010525a <alltraps>

8010607f <vector234>:
.globl vector234
vector234:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $234
80106081:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106086:	e9 cf f1 ff ff       	jmp    8010525a <alltraps>

8010608b <vector235>:
.globl vector235
vector235:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $235
8010608d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106092:	e9 c3 f1 ff ff       	jmp    8010525a <alltraps>

80106097 <vector236>:
.globl vector236
vector236:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $236
80106099:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010609e:	e9 b7 f1 ff ff       	jmp    8010525a <alltraps>

801060a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $237
801060a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801060aa:	e9 ab f1 ff ff       	jmp    8010525a <alltraps>

801060af <vector238>:
.globl vector238
vector238:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $238
801060b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801060b6:	e9 9f f1 ff ff       	jmp    8010525a <alltraps>

801060bb <vector239>:
.globl vector239
vector239:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $239
801060bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801060c2:	e9 93 f1 ff ff       	jmp    8010525a <alltraps>

801060c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $240
801060c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801060ce:	e9 87 f1 ff ff       	jmp    8010525a <alltraps>

801060d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $241
801060d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801060da:	e9 7b f1 ff ff       	jmp    8010525a <alltraps>

801060df <vector242>:
.globl vector242
vector242:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $242
801060e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801060e6:	e9 6f f1 ff ff       	jmp    8010525a <alltraps>

801060eb <vector243>:
.globl vector243
vector243:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $243
801060ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801060f2:	e9 63 f1 ff ff       	jmp    8010525a <alltraps>

801060f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $244
801060f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801060fe:	e9 57 f1 ff ff       	jmp    8010525a <alltraps>

80106103 <vector245>:
.globl vector245
vector245:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $245
80106105:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010610a:	e9 4b f1 ff ff       	jmp    8010525a <alltraps>

8010610f <vector246>:
.globl vector246
vector246:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $246
80106111:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106116:	e9 3f f1 ff ff       	jmp    8010525a <alltraps>

8010611b <vector247>:
.globl vector247
vector247:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $247
8010611d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106122:	e9 33 f1 ff ff       	jmp    8010525a <alltraps>

80106127 <vector248>:
.globl vector248
vector248:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $248
80106129:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010612e:	e9 27 f1 ff ff       	jmp    8010525a <alltraps>

80106133 <vector249>:
.globl vector249
vector249:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $249
80106135:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010613a:	e9 1b f1 ff ff       	jmp    8010525a <alltraps>

8010613f <vector250>:
.globl vector250
vector250:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $250
80106141:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106146:	e9 0f f1 ff ff       	jmp    8010525a <alltraps>

8010614b <vector251>:
.globl vector251
vector251:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $251
8010614d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106152:	e9 03 f1 ff ff       	jmp    8010525a <alltraps>

80106157 <vector252>:
.globl vector252
vector252:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $252
80106159:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010615e:	e9 f7 f0 ff ff       	jmp    8010525a <alltraps>

80106163 <vector253>:
.globl vector253
vector253:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $253
80106165:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010616a:	e9 eb f0 ff ff       	jmp    8010525a <alltraps>

8010616f <vector254>:
.globl vector254
vector254:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $254
80106171:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106176:	e9 df f0 ff ff       	jmp    8010525a <alltraps>

8010617b <vector255>:
.globl vector255
vector255:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $255
8010617d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106182:	e9 d3 f0 ff ff       	jmp    8010525a <alltraps>
80106187:	90                   	nop

80106188 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106188:	55                   	push   %ebp
80106189:	89 e5                	mov    %esp,%ebp
8010618b:	57                   	push   %edi
8010618c:	56                   	push   %esi
8010618d:	53                   	push   %ebx
8010618e:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106191:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106197:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010619d:	39 d3                	cmp    %edx,%ebx
8010619f:	73 50                	jae    801061f1 <deallocuvm.part.0+0x69>
801061a1:	89 c6                	mov    %eax,%esi
801061a3:	89 d7                	mov    %edx,%edi
801061a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801061a8:	eb 0c                	jmp    801061b6 <deallocuvm.part.0+0x2e>
801061aa:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801061ac:	42                   	inc    %edx
801061ad:	89 d3                	mov    %edx,%ebx
801061af:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801061b2:	39 fb                	cmp    %edi,%ebx
801061b4:	73 38                	jae    801061ee <deallocuvm.part.0+0x66>
  pde = &pgdir[PDX(va)];
801061b6:	89 da                	mov    %ebx,%edx
801061b8:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801061bb:	8b 04 96             	mov    (%esi,%edx,4),%eax
801061be:	a8 01                	test   $0x1,%al
801061c0:	74 ea                	je     801061ac <deallocuvm.part.0+0x24>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801061c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801061c7:	89 d9                	mov    %ebx,%ecx
801061c9:	c1 e9 0a             	shr    $0xa,%ecx
801061cc:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801061d2:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801061d9:	85 c0                	test   %eax,%eax
801061db:	74 cf                	je     801061ac <deallocuvm.part.0+0x24>
    else if((*pte & PTE_P) != 0){
801061dd:	8b 10                	mov    (%eax),%edx
801061df:	f6 c2 01             	test   $0x1,%dl
801061e2:	75 18                	jne    801061fc <deallocuvm.part.0+0x74>
  for(; a  < oldsz; a += PGSIZE){
801061e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061ea:	39 fb                	cmp    %edi,%ebx
801061ec:	72 c8                	jb     801061b6 <deallocuvm.part.0+0x2e>
801061ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801061f1:	89 c8                	mov    %ecx,%eax
801061f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f6:	5b                   	pop    %ebx
801061f7:	5e                   	pop    %esi
801061f8:	5f                   	pop    %edi
801061f9:	5d                   	pop    %ebp
801061fa:	c3                   	ret
801061fb:	90                   	nop
      if(pa == 0)
801061fc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106202:	74 26                	je     8010622a <deallocuvm.part.0+0xa2>
80106204:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106207:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010620a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106210:	52                   	push   %edx
80106211:	e8 ee bf ff ff       	call   80102204 <kfree>
      *pte = 0;
80106216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106219:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
8010621f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106225:	83 c4 10             	add    $0x10,%esp
80106228:	eb 88                	jmp    801061b2 <deallocuvm.part.0+0x2a>
        panic("kfree");
8010622a:	83 ec 0c             	sub    $0xc,%esp
8010622d:	68 2c 6c 10 80       	push   $0x80106c2c
80106232:	e8 01 a1 ff ff       	call   80100338 <panic>
80106237:	90                   	nop

80106238 <mappages>:
{
80106238:	55                   	push   %ebp
80106239:	89 e5                	mov    %esp,%ebp
8010623b:	57                   	push   %edi
8010623c:	56                   	push   %esi
8010623d:	53                   	push   %ebx
8010623e:	83 ec 1c             	sub    $0x1c,%esp
80106241:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106244:	89 d3                	mov    %edx,%ebx
80106246:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010624c:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106250:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106255:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106258:	8b 45 08             	mov    0x8(%ebp),%eax
8010625b:	29 d8                	sub    %ebx,%eax
8010625d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106260:	eb 3b                	jmp    8010629d <mappages+0x65>
80106262:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106264:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106269:	89 da                	mov    %ebx,%edx
8010626b:	c1 ea 0a             	shr    $0xa,%edx
8010626e:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106274:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010627b:	85 c0                	test   %eax,%eax
8010627d:	74 71                	je     801062f0 <mappages+0xb8>
    if(*pte & PTE_P)
8010627f:	f6 00 01             	testb  $0x1,(%eax)
80106282:	0f 85 82 00 00 00    	jne    8010630a <mappages+0xd2>
    *pte = pa | perm | PTE_P;
80106288:	0b 75 0c             	or     0xc(%ebp),%esi
8010628b:	83 ce 01             	or     $0x1,%esi
8010628e:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106290:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106293:	39 c3                	cmp    %eax,%ebx
80106295:	74 69                	je     80106300 <mappages+0xc8>
    a += PGSIZE;
80106297:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
8010629d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062a0:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  pde = &pgdir[PDX(va)];
801062a3:	89 d8                	mov    %ebx,%eax
801062a5:	c1 e8 16             	shr    $0x16,%eax
801062a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801062ab:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801062ae:	8b 07                	mov    (%edi),%eax
801062b0:	a8 01                	test   $0x1,%al
801062b2:	75 b0                	jne    80106264 <mappages+0x2c>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801062b4:	e8 db c0 ff ff       	call   80102394 <kalloc>
801062b9:	89 c2                	mov    %eax,%edx
801062bb:	85 c0                	test   %eax,%eax
801062bd:	74 31                	je     801062f0 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
801062bf:	50                   	push   %eax
801062c0:	68 00 10 00 00       	push   $0x1000
801062c5:	6a 00                	push   $0x0
801062c7:	52                   	push   %edx
801062c8:	89 55 d8             	mov    %edx,-0x28(%ebp)
801062cb:	e8 e8 df ff ff       	call   801042b8 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801062d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
801062d3:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801062d9:	83 c8 07             	or     $0x7,%eax
801062dc:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801062de:	89 d8                	mov    %ebx,%eax
801062e0:	c1 e8 0a             	shr    $0xa,%eax
801062e3:	25 fc 0f 00 00       	and    $0xffc,%eax
801062e8:	01 d0                	add    %edx,%eax
801062ea:	83 c4 10             	add    $0x10,%esp
801062ed:	eb 90                	jmp    8010627f <mappages+0x47>
801062ef:	90                   	nop
      return -1;
801062f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f8:	5b                   	pop    %ebx
801062f9:	5e                   	pop    %esi
801062fa:	5f                   	pop    %edi
801062fb:	5d                   	pop    %ebp
801062fc:	c3                   	ret
801062fd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
80106300:	31 c0                	xor    %eax,%eax
}
80106302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106305:	5b                   	pop    %ebx
80106306:	5e                   	pop    %esi
80106307:	5f                   	pop    %edi
80106308:	5d                   	pop    %ebp
80106309:	c3                   	ret
      panic("remap");
8010630a:	83 ec 0c             	sub    $0xc,%esp
8010630d:	68 6f 6e 10 80       	push   $0x80106e6f
80106312:	e8 21 a0 ff ff       	call   80100338 <panic>
80106317:	90                   	nop

80106318 <seginit>:
{
80106318:	55                   	push   %ebp
80106319:	89 e5                	mov    %esp,%ebp
8010631b:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010631e:	e8 a1 d1 ff ff       	call   801034c4 <cpuid>
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106323:	8d 14 80             	lea    (%eax,%eax,4),%edx
80106326:	01 d2                	add    %edx,%edx
80106328:	01 d0                	add    %edx,%eax
8010632a:	c1 e0 04             	shl    $0x4,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010632d:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106334:	ff 00 00 
80106337:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
8010633e:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106341:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106348:	ff 00 00 
8010634b:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106352:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106355:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
8010635c:	ff 00 00 
8010635f:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106366:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106369:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106370:	ff 00 00 
80106373:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
8010637a:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010637d:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[0] = size-1;
80106382:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106388:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010638c:	c1 e8 10             	shr    $0x10,%eax
8010638f:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106393:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106396:	0f 01 10             	lgdtl  (%eax)
}
80106399:	c9                   	leave
8010639a:	c3                   	ret
8010639b:	90                   	nop

8010639c <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010639c:	a1 c4 4e 11 80       	mov    0x80114ec4,%eax
801063a1:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801063a6:	0f 22 d8             	mov    %eax,%cr3
}
801063a9:	c3                   	ret
801063aa:	66 90                	xchg   %ax,%ax

801063ac <switchuvm>:
{
801063ac:	55                   	push   %ebp
801063ad:	89 e5                	mov    %esp,%ebp
801063af:	57                   	push   %edi
801063b0:	56                   	push   %esi
801063b1:	53                   	push   %ebx
801063b2:	83 ec 1c             	sub    $0x1c,%esp
801063b5:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801063b8:	85 f6                	test   %esi,%esi
801063ba:	0f 84 bf 00 00 00    	je     8010647f <switchuvm+0xd3>
  if(p->kstack == 0)
801063c0:	8b 56 30             	mov    0x30(%esi),%edx
801063c3:	85 d2                	test   %edx,%edx
801063c5:	0f 84 ce 00 00 00    	je     80106499 <switchuvm+0xed>
  if(p->pgdir == 0)
801063cb:	8b 46 2c             	mov    0x2c(%esi),%eax
801063ce:	85 c0                	test   %eax,%eax
801063d0:	0f 84 b6 00 00 00    	je     8010648c <switchuvm+0xe0>
  pushcli();
801063d6:	e8 cd dc ff ff       	call   801040a8 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801063db:	e8 80 d0 ff ff       	call   80103460 <mycpu>
801063e0:	89 c3                	mov    %eax,%ebx
801063e2:	e8 79 d0 ff ff       	call   80103460 <mycpu>
801063e7:	89 c7                	mov    %eax,%edi
801063e9:	e8 72 d0 ff ff       	call   80103460 <mycpu>
801063ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063f1:	e8 6a d0 ff ff       	call   80103460 <mycpu>
801063f6:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801063fd:	67 00 
801063ff:	83 c7 08             	add    $0x8,%edi
80106402:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106409:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010640c:	83 c1 08             	add    $0x8,%ecx
8010640f:	c1 e9 10             	shr    $0x10,%ecx
80106412:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106418:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
8010641f:	99 40 
80106421:	83 c0 08             	add    $0x8,%eax
80106424:	c1 e8 18             	shr    $0x18,%eax
80106427:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
8010642d:	e8 2e d0 ff ff       	call   80103460 <mycpu>
80106432:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106439:	e8 22 d0 ff ff       	call   80103460 <mycpu>
8010643e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106444:	8b 5e 30             	mov    0x30(%esi),%ebx
80106447:	e8 14 d0 ff ff       	call   80103460 <mycpu>
8010644c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106452:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106455:	e8 06 d0 ff ff       	call   80103460 <mycpu>
8010645a:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106460:	b8 28 00 00 00       	mov    $0x28,%eax
80106465:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106468:	8b 46 2c             	mov    0x2c(%esi),%eax
8010646b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106470:	0f 22 d8             	mov    %eax,%cr3
}
80106473:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106476:	5b                   	pop    %ebx
80106477:	5e                   	pop    %esi
80106478:	5f                   	pop    %edi
80106479:	5d                   	pop    %ebp
  popcli();
8010647a:	e9 75 dc ff ff       	jmp    801040f4 <popcli>
    panic("switchuvm: no process");
8010647f:	83 ec 0c             	sub    $0xc,%esp
80106482:	68 75 6e 10 80       	push   $0x80106e75
80106487:	e8 ac 9e ff ff       	call   80100338 <panic>
    panic("switchuvm: no pgdir");
8010648c:	83 ec 0c             	sub    $0xc,%esp
8010648f:	68 a0 6e 10 80       	push   $0x80106ea0
80106494:	e8 9f 9e ff ff       	call   80100338 <panic>
    panic("switchuvm: no kstack");
80106499:	83 ec 0c             	sub    $0xc,%esp
8010649c:	68 8b 6e 10 80       	push   $0x80106e8b
801064a1:	e8 92 9e ff ff       	call   80100338 <panic>
801064a6:	66 90                	xchg   %ax,%ax

801064a8 <inituvm>:
{
801064a8:	55                   	push   %ebp
801064a9:	89 e5                	mov    %esp,%ebp
801064ab:	57                   	push   %edi
801064ac:	56                   	push   %esi
801064ad:	53                   	push   %ebx
801064ae:	83 ec 1c             	sub    $0x1c,%esp
801064b1:	8b 45 08             	mov    0x8(%ebp),%eax
801064b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801064ba:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
801064bd:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801064c3:	77 47                	ja     8010650c <inituvm+0x64>
  mem = kalloc();
801064c5:	e8 ca be ff ff       	call   80102394 <kalloc>
801064ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801064cc:	50                   	push   %eax
801064cd:	68 00 10 00 00       	push   $0x1000
801064d2:	6a 00                	push   $0x0
801064d4:	53                   	push   %ebx
801064d5:	e8 de dd ff ff       	call   801042b8 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801064da:	5a                   	pop    %edx
801064db:	59                   	pop    %ecx
801064dc:	6a 06                	push   $0x6
801064de:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064e4:	50                   	push   %eax
801064e5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801064ea:	31 d2                	xor    %edx,%edx
801064ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ef:	e8 44 fd ff ff       	call   80106238 <mappages>
  memmove(mem, init, sz);
801064f4:	83 c4 10             	add    $0x10,%esp
801064f7:	89 75 10             	mov    %esi,0x10(%ebp)
801064fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
801064fd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106503:	5b                   	pop    %ebx
80106504:	5e                   	pop    %esi
80106505:	5f                   	pop    %edi
80106506:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106507:	e9 28 de ff ff       	jmp    80104334 <memmove>
    panic("inituvm: more than a page");
8010650c:	83 ec 0c             	sub    $0xc,%esp
8010650f:	68 b4 6e 10 80       	push   $0x80106eb4
80106514:	e8 1f 9e ff ff       	call   80100338 <panic>
80106519:	8d 76 00             	lea    0x0(%esi),%esi

8010651c <loaduvm>:
{
8010651c:	55                   	push   %ebp
8010651d:	89 e5                	mov    %esp,%ebp
8010651f:	57                   	push   %edi
80106520:	56                   	push   %esi
80106521:	53                   	push   %ebx
80106522:	83 ec 0c             	sub    $0xc,%esp
80106525:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106528:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010652b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106531:	0f 85 9a 00 00 00    	jne    801065d1 <loaduvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
80106537:	85 ff                	test   %edi,%edi
80106539:	74 7c                	je     801065b7 <loaduvm+0x9b>
8010653b:	90                   	nop
  pde = &pgdir[PDX(va)];
8010653c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010653f:	01 d8                	add    %ebx,%eax
80106541:	89 c2                	mov    %eax,%edx
80106543:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106546:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106549:	8b 14 91             	mov    (%ecx,%edx,4),%edx
8010654c:	f6 c2 01             	test   $0x1,%dl
8010654f:	75 0f                	jne    80106560 <loaduvm+0x44>
      panic("loaduvm: address should exist");
80106551:	83 ec 0c             	sub    $0xc,%esp
80106554:	68 ce 6e 10 80       	push   $0x80106ece
80106559:	e8 da 9d ff ff       	call   80100338 <panic>
8010655e:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106560:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106566:	c1 e8 0a             	shr    $0xa,%eax
80106569:	25 fc 0f 00 00       	and    $0xffc,%eax
8010656e:	8d 8c 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106575:	85 c9                	test   %ecx,%ecx
80106577:	74 d8                	je     80106551 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106579:	89 fe                	mov    %edi,%esi
8010657b:	29 de                	sub    %ebx,%esi
8010657d:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106583:	76 05                	jbe    8010658a <loaduvm+0x6e>
80106585:	be 00 10 00 00       	mov    $0x1000,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010658a:	56                   	push   %esi
8010658b:	8b 45 14             	mov    0x14(%ebp),%eax
8010658e:	01 d8                	add    %ebx,%eax
80106590:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106591:	8b 01                	mov    (%ecx),%eax
80106593:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106598:	05 00 00 00 80       	add    $0x80000000,%eax
8010659d:	50                   	push   %eax
8010659e:	ff 75 10             	push   0x10(%ebp)
801065a1:	e8 4a b3 ff ff       	call   801018f0 <readi>
801065a6:	83 c4 10             	add    $0x10,%esp
801065a9:	39 f0                	cmp    %esi,%eax
801065ab:	75 17                	jne    801065c4 <loaduvm+0xa8>
  for(i = 0; i < sz; i += PGSIZE){
801065ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065b3:	39 fb                	cmp    %edi,%ebx
801065b5:	72 85                	jb     8010653c <loaduvm+0x20>
  return 0;
801065b7:	31 c0                	xor    %eax,%eax
}
801065b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065bc:	5b                   	pop    %ebx
801065bd:	5e                   	pop    %esi
801065be:	5f                   	pop    %edi
801065bf:	5d                   	pop    %ebp
801065c0:	c3                   	ret
801065c1:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
801065c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065cc:	5b                   	pop    %ebx
801065cd:	5e                   	pop    %esi
801065ce:	5f                   	pop    %edi
801065cf:	5d                   	pop    %ebp
801065d0:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801065d1:	83 ec 0c             	sub    $0xc,%esp
801065d4:	68 d0 70 10 80       	push   $0x801070d0
801065d9:	e8 5a 9d ff ff       	call   80100338 <panic>
801065de:	66 90                	xchg   %ax,%ax

801065e0 <allocuvm>:
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
801065e6:	83 ec 1c             	sub    $0x1c,%esp
801065e9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
801065ec:	85 f6                	test   %esi,%esi
801065ee:	0f 88 91 00 00 00    	js     80106685 <allocuvm+0xa5>
801065f4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
801065f6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801065f9:	0f 82 95 00 00 00    	jb     80106694 <allocuvm+0xb4>
  a = PGROUNDUP(oldsz);
801065ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106602:	05 ff 0f 00 00       	add    $0xfff,%eax
80106607:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010660c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010660e:	39 f0                	cmp    %esi,%eax
80106610:	0f 83 81 00 00 00    	jae    80106697 <allocuvm+0xb7>
80106616:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106619:	eb 3d                	jmp    80106658 <allocuvm+0x78>
8010661b:	90                   	nop
    memset(mem, 0, PGSIZE);
8010661c:	50                   	push   %eax
8010661d:	68 00 10 00 00       	push   $0x1000
80106622:	6a 00                	push   $0x0
80106624:	53                   	push   %ebx
80106625:	e8 8e dc ff ff       	call   801042b8 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010662a:	5a                   	pop    %edx
8010662b:	59                   	pop    %ecx
8010662c:	6a 06                	push   $0x6
8010662e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106634:	50                   	push   %eax
80106635:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010663a:	89 fa                	mov    %edi,%edx
8010663c:	8b 45 08             	mov    0x8(%ebp),%eax
8010663f:	e8 f4 fb ff ff       	call   80106238 <mappages>
80106644:	83 c4 10             	add    $0x10,%esp
80106647:	40                   	inc    %eax
80106648:	74 5a                	je     801066a4 <allocuvm+0xc4>
  for(; a < newsz; a += PGSIZE){
8010664a:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106650:	39 f7                	cmp    %esi,%edi
80106652:	0f 83 80 00 00 00    	jae    801066d8 <allocuvm+0xf8>
    mem = kalloc();
80106658:	e8 37 bd ff ff       	call   80102394 <kalloc>
8010665d:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010665f:	85 c0                	test   %eax,%eax
80106661:	75 b9                	jne    8010661c <allocuvm+0x3c>
      cprintf("allocuvm out of memory\n");
80106663:	83 ec 0c             	sub    $0xc,%esp
80106666:	68 ec 6e 10 80       	push   $0x80106eec
8010666b:	e8 b0 9f ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106670:	83 c4 10             	add    $0x10,%esp
80106673:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106676:	74 0d                	je     80106685 <allocuvm+0xa5>
80106678:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010667b:	89 f2                	mov    %esi,%edx
8010667d:	8b 45 08             	mov    0x8(%ebp),%eax
80106680:	e8 03 fb ff ff       	call   80106188 <deallocuvm.part.0>
    return 0;
80106685:	31 d2                	xor    %edx,%edx
}
80106687:	89 d0                	mov    %edx,%eax
80106689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010668c:	5b                   	pop    %ebx
8010668d:	5e                   	pop    %esi
8010668e:	5f                   	pop    %edi
8010668f:	5d                   	pop    %ebp
80106690:	c3                   	ret
80106691:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80106694:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106697:	89 d0                	mov    %edx,%eax
80106699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010669c:	5b                   	pop    %ebx
8010669d:	5e                   	pop    %esi
8010669e:	5f                   	pop    %edi
8010669f:	5d                   	pop    %ebp
801066a0:	c3                   	ret
801066a1:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801066a4:	83 ec 0c             	sub    $0xc,%esp
801066a7:	68 04 6f 10 80       	push   $0x80106f04
801066ac:	e8 6f 9f ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
801066b1:	83 c4 10             	add    $0x10,%esp
801066b4:	3b 75 0c             	cmp    0xc(%ebp),%esi
801066b7:	74 0d                	je     801066c6 <allocuvm+0xe6>
801066b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801066bc:	89 f2                	mov    %esi,%edx
801066be:	8b 45 08             	mov    0x8(%ebp),%eax
801066c1:	e8 c2 fa ff ff       	call   80106188 <deallocuvm.part.0>
      kfree(mem);
801066c6:	83 ec 0c             	sub    $0xc,%esp
801066c9:	53                   	push   %ebx
801066ca:	e8 35 bb ff ff       	call   80102204 <kfree>
      return 0;
801066cf:	83 c4 10             	add    $0x10,%esp
    return 0;
801066d2:	31 d2                	xor    %edx,%edx
801066d4:	eb b1                	jmp    80106687 <allocuvm+0xa7>
801066d6:	66 90                	xchg   %ax,%ax
801066d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
801066db:	89 d0                	mov    %edx,%eax
801066dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066e0:	5b                   	pop    %ebx
801066e1:	5e                   	pop    %esi
801066e2:	5f                   	pop    %edi
801066e3:	5d                   	pop    %ebp
801066e4:	c3                   	ret
801066e5:	8d 76 00             	lea    0x0(%esi),%esi

801066e8 <deallocuvm>:
{
801066e8:	55                   	push   %ebp
801066e9:	89 e5                	mov    %esp,%ebp
801066eb:	8b 45 08             	mov    0x8(%ebp),%eax
801066ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801066f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
801066f4:	39 d1                	cmp    %edx,%ecx
801066f6:	73 08                	jae    80106700 <deallocuvm+0x18>
}
801066f8:	5d                   	pop    %ebp
801066f9:	e9 8a fa ff ff       	jmp    80106188 <deallocuvm.part.0>
801066fe:	66 90                	xchg   %ax,%ax
80106700:	89 d0                	mov    %edx,%eax
80106702:	5d                   	pop    %ebp
80106703:	c3                   	ret

80106704 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106704:	55                   	push   %ebp
80106705:	89 e5                	mov    %esp,%ebp
80106707:	57                   	push   %edi
80106708:	56                   	push   %esi
80106709:	53                   	push   %ebx
8010670a:	83 ec 0c             	sub    $0xc,%esp
8010670d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106710:	85 f6                	test   %esi,%esi
80106712:	74 51                	je     80106765 <freevm+0x61>
  if(newsz >= oldsz)
80106714:	31 c9                	xor    %ecx,%ecx
80106716:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010671b:	89 f0                	mov    %esi,%eax
8010671d:	e8 66 fa ff ff       	call   80106188 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106722:	89 f3                	mov    %esi,%ebx
80106724:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010672a:	eb 07                	jmp    80106733 <freevm+0x2f>
8010672c:	83 c3 04             	add    $0x4,%ebx
8010672f:	39 fb                	cmp    %edi,%ebx
80106731:	74 23                	je     80106756 <freevm+0x52>
    if(pgdir[i] & PTE_P){
80106733:	8b 03                	mov    (%ebx),%eax
80106735:	a8 01                	test   $0x1,%al
80106737:	74 f3                	je     8010672c <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106739:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010673c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106741:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106746:	50                   	push   %eax
80106747:	e8 b8 ba ff ff       	call   80102204 <kfree>
8010674c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010674f:	83 c3 04             	add    $0x4,%ebx
80106752:	39 fb                	cmp    %edi,%ebx
80106754:	75 dd                	jne    80106733 <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
80106756:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010675c:	5b                   	pop    %ebx
8010675d:	5e                   	pop    %esi
8010675e:	5f                   	pop    %edi
8010675f:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106760:	e9 9f ba ff ff       	jmp    80102204 <kfree>
    panic("freevm: no pgdir");
80106765:	83 ec 0c             	sub    $0xc,%esp
80106768:	68 20 6f 10 80       	push   $0x80106f20
8010676d:	e8 c6 9b ff ff       	call   80100338 <panic>
80106772:	66 90                	xchg   %ax,%ax

80106774 <setupkvm>:
{
80106774:	55                   	push   %ebp
80106775:	89 e5                	mov    %esp,%ebp
80106777:	56                   	push   %esi
80106778:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106779:	e8 16 bc ff ff       	call   80102394 <kalloc>
8010677e:	85 c0                	test   %eax,%eax
80106780:	74 56                	je     801067d8 <setupkvm+0x64>
80106782:	89 c6                	mov    %eax,%esi
  memset(pgdir, 0, PGSIZE);
80106784:	50                   	push   %eax
80106785:	68 00 10 00 00       	push   $0x1000
8010678a:	6a 00                	push   $0x0
8010678c:	56                   	push   %esi
8010678d:	e8 26 db ff ff       	call   801042b8 <memset>
80106792:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106795:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010679a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010679d:	8b 4b 08             	mov    0x8(%ebx),%ecx
801067a0:	29 c1                	sub    %eax,%ecx
801067a2:	8b 13                	mov    (%ebx),%edx
801067a4:	83 ec 08             	sub    $0x8,%esp
801067a7:	ff 73 0c             	push   0xc(%ebx)
801067aa:	50                   	push   %eax
801067ab:	89 f0                	mov    %esi,%eax
801067ad:	e8 86 fa ff ff       	call   80106238 <mappages>
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	40                   	inc    %eax
801067b6:	74 14                	je     801067cc <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801067b8:	83 c3 10             	add    $0x10,%ebx
801067bb:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801067c1:	75 d7                	jne    8010679a <setupkvm+0x26>
}
801067c3:	89 f0                	mov    %esi,%eax
801067c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067c8:	5b                   	pop    %ebx
801067c9:	5e                   	pop    %esi
801067ca:	5d                   	pop    %ebp
801067cb:	c3                   	ret
      freevm(pgdir);
801067cc:	83 ec 0c             	sub    $0xc,%esp
801067cf:	56                   	push   %esi
801067d0:	e8 2f ff ff ff       	call   80106704 <freevm>
      return 0;
801067d5:	83 c4 10             	add    $0x10,%esp
    return 0;
801067d8:	31 f6                	xor    %esi,%esi
}
801067da:	89 f0                	mov    %esi,%eax
801067dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067df:	5b                   	pop    %ebx
801067e0:	5e                   	pop    %esi
801067e1:	5d                   	pop    %ebp
801067e2:	c3                   	ret
801067e3:	90                   	nop

801067e4 <kvmalloc>:
{
801067e4:	55                   	push   %ebp
801067e5:	89 e5                	mov    %esp,%ebp
801067e7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801067ea:	e8 85 ff ff ff       	call   80106774 <setupkvm>
801067ef:	a3 c4 4e 11 80       	mov    %eax,0x80114ec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801067f4:	05 00 00 00 80       	add    $0x80000000,%eax
801067f9:	0f 22 d8             	mov    %eax,%cr3
}
801067fc:	c9                   	leave
801067fd:	c3                   	ret
801067fe:	66 90                	xchg   %ax,%ax

80106800 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	83 ec 08             	sub    $0x8,%esp
  pde = &pgdir[PDX(va)];
80106806:	8b 55 0c             	mov    0xc(%ebp),%edx
80106809:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010680c:	8b 45 08             	mov    0x8(%ebp),%eax
8010680f:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106812:	a8 01                	test   $0x1,%al
80106814:	75 0e                	jne    80106824 <clearpteu+0x24>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106816:	83 ec 0c             	sub    $0xc,%esp
80106819:	68 31 6f 10 80       	push   $0x80106f31
8010681e:	e8 15 9b ff ff       	call   80100338 <panic>
80106823:	90                   	nop
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106829:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
8010682b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010682e:	c1 e8 0a             	shr    $0xa,%eax
80106831:	25 fc 0f 00 00       	and    $0xffc,%eax
80106836:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
8010683d:	85 c0                	test   %eax,%eax
8010683f:	74 d5                	je     80106816 <clearpteu+0x16>
  *pte &= ~PTE_U;
80106841:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106844:	c9                   	leave
80106845:	c3                   	ret
80106846:	66 90                	xchg   %ax,%ax

80106848 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106848:	55                   	push   %ebp
80106849:	89 e5                	mov    %esp,%ebp
8010684b:	57                   	push   %edi
8010684c:	56                   	push   %esi
8010684d:	53                   	push   %ebx
8010684e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106851:	e8 1e ff ff ff       	call   80106774 <setupkvm>
80106856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106859:	85 c0                	test   %eax,%eax
8010685b:	0f 84 d5 00 00 00    	je     80106936 <copyuvm+0xee>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106861:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106864:	85 db                	test   %ebx,%ebx
80106866:	0f 84 a4 00 00 00    	je     80106910 <copyuvm+0xc8>
8010686c:	31 ff                	xor    %edi,%edi
8010686e:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
80106870:	89 f8                	mov    %edi,%eax
80106872:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106875:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106878:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010687b:	a8 01                	test   $0x1,%al
8010687d:	75 0d                	jne    8010688c <copyuvm+0x44>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010687f:	83 ec 0c             	sub    $0xc,%esp
80106882:	68 3b 6f 10 80       	push   $0x80106f3b
80106887:	e8 ac 9a ff ff       	call   80100338 <panic>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010688c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106891:	89 fa                	mov    %edi,%edx
80106893:	c1 ea 0a             	shr    $0xa,%edx
80106896:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
8010689c:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801068a3:	85 c0                	test   %eax,%eax
801068a5:	74 d8                	je     8010687f <copyuvm+0x37>
    if(!(*pte & PTE_P))
801068a7:	8b 18                	mov    (%eax),%ebx
801068a9:	f6 c3 01             	test   $0x1,%bl
801068ac:	0f 84 8d 00 00 00    	je     8010693f <copyuvm+0xf7>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801068b2:	89 d8                	mov    %ebx,%eax
801068b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
801068bc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
801068c2:	e8 cd ba ff ff       	call   80102394 <kalloc>
801068c7:	89 c6                	mov    %eax,%esi
801068c9:	85 c0                	test   %eax,%eax
801068cb:	74 5b                	je     80106928 <copyuvm+0xe0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801068cd:	50                   	push   %eax
801068ce:	68 00 10 00 00       	push   $0x1000
801068d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068d6:	05 00 00 00 80       	add    $0x80000000,%eax
801068db:	50                   	push   %eax
801068dc:	56                   	push   %esi
801068dd:	e8 52 da ff ff       	call   80104334 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801068e2:	5a                   	pop    %edx
801068e3:	59                   	pop    %ecx
801068e4:	53                   	push   %ebx
801068e5:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801068eb:	50                   	push   %eax
801068ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
801068f1:	89 fa                	mov    %edi,%edx
801068f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068f6:	e8 3d f9 ff ff       	call   80106238 <mappages>
801068fb:	83 c4 10             	add    $0x10,%esp
801068fe:	40                   	inc    %eax
801068ff:	74 1b                	je     8010691c <copyuvm+0xd4>
  for(i = 0; i < sz; i += PGSIZE){
80106901:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106907:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010690a:	0f 82 60 ff ff ff    	jb     80106870 <copyuvm+0x28>
  return d;

bad:
  freevm(d);
  return 0;
}
80106910:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106913:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106916:	5b                   	pop    %ebx
80106917:	5e                   	pop    %esi
80106918:	5f                   	pop    %edi
80106919:	5d                   	pop    %ebp
8010691a:	c3                   	ret
8010691b:	90                   	nop
      kfree(mem);
8010691c:	83 ec 0c             	sub    $0xc,%esp
8010691f:	56                   	push   %esi
80106920:	e8 df b8 ff ff       	call   80102204 <kfree>
      goto bad;
80106925:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80106928:	83 ec 0c             	sub    $0xc,%esp
8010692b:	ff 75 e0             	push   -0x20(%ebp)
8010692e:	e8 d1 fd ff ff       	call   80106704 <freevm>
  return 0;
80106933:	83 c4 10             	add    $0x10,%esp
    return 0;
80106936:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010693d:	eb d1                	jmp    80106910 <copyuvm+0xc8>
      panic("copyuvm: page not present");
8010693f:	83 ec 0c             	sub    $0xc,%esp
80106942:	68 55 6f 10 80       	push   $0x80106f55
80106947:	e8 ec 99 ff ff       	call   80100338 <panic>

8010694c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010694c:	55                   	push   %ebp
8010694d:	89 e5                	mov    %esp,%ebp
  pde = &pgdir[PDX(va)];
8010694f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106952:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106955:	8b 45 08             	mov    0x8(%ebp),%eax
80106958:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010695b:	a8 01                	test   $0x1,%al
8010695d:	0f 84 e3 00 00 00    	je     80106a46 <uva2ka.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106963:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106968:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
8010696a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010696d:	c1 e8 0c             	shr    $0xc,%eax
80106970:	25 ff 03 00 00       	and    $0x3ff,%eax
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
80106975:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    return 0;
  if((*pte & PTE_U) == 0)
8010697c:	89 c2                	mov    %eax,%edx
8010697e:	f7 d2                	not    %edx
80106980:	83 e2 05             	and    $0x5,%edx
80106983:	75 0f                	jne    80106994 <uva2ka+0x48>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106985:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010698a:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010698f:	5d                   	pop    %ebp
80106990:	c3                   	ret
80106991:	8d 76 00             	lea    0x0(%esi),%esi
80106994:	31 c0                	xor    %eax,%eax
80106996:	5d                   	pop    %ebp
80106997:	c3                   	ret

80106998 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106998:	55                   	push   %ebp
80106999:	89 e5                	mov    %esp,%ebp
8010699b:	57                   	push   %edi
8010699c:	56                   	push   %esi
8010699d:	53                   	push   %ebx
8010699e:	83 ec 0c             	sub    $0xc,%esp
801069a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069a4:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801069a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
801069aa:	85 db                	test   %ebx,%ebx
801069ac:	0f 84 8a 00 00 00    	je     80106a3c <copyout+0xa4>
801069b2:	89 fe                	mov    %edi,%esi
801069b4:	eb 3d                	jmp    801069f3 <copyout+0x5b>
801069b6:	66 90                	xchg   %ax,%ax
  return (char*)P2V(PTE_ADDR(*pte));
801069b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801069bd:	05 00 00 00 80       	add    $0x80000000,%eax
801069c2:	74 6a                	je     80106a2e <copyout+0x96>
      return -1;
    n = PGSIZE - (va - va0);
801069c4:	89 fb                	mov    %edi,%ebx
801069c6:	29 cb                	sub    %ecx,%ebx
    if(n > len)
801069c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069ce:	39 5d 14             	cmp    %ebx,0x14(%ebp)
801069d1:	73 03                	jae    801069d6 <copyout+0x3e>
801069d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801069d6:	52                   	push   %edx
801069d7:	53                   	push   %ebx
801069d8:	56                   	push   %esi
801069d9:	29 f9                	sub    %edi,%ecx
801069db:	01 c8                	add    %ecx,%eax
801069dd:	50                   	push   %eax
801069de:	e8 51 d9 ff ff       	call   80104334 <memmove>
    len -= n;
    buf += n;
801069e3:	01 de                	add    %ebx,%esi
    va = va0 + PGSIZE;
801069e5:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
801069eb:	83 c4 10             	add    $0x10,%esp
801069ee:	29 5d 14             	sub    %ebx,0x14(%ebp)
801069f1:	74 49                	je     80106a3c <copyout+0xa4>
    va0 = (uint)PGROUNDDOWN(va);
801069f3:	89 cf                	mov    %ecx,%edi
801069f5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pde = &pgdir[PDX(va)];
801069fb:	89 c8                	mov    %ecx,%eax
801069fd:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a00:	8b 55 08             	mov    0x8(%ebp),%edx
80106a03:	8b 04 82             	mov    (%edx,%eax,4),%eax
80106a06:	a8 01                	test   $0x1,%al
80106a08:	0f 84 3f 00 00 00    	je     80106a4d <copyout.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a13:	89 fb                	mov    %edi,%ebx
80106a15:	c1 eb 0c             	shr    $0xc,%ebx
80106a18:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106a1e:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80106a25:	89 c3                	mov    %eax,%ebx
80106a27:	f7 d3                	not    %ebx
80106a29:	83 e3 05             	and    $0x5,%ebx
80106a2c:	74 8a                	je     801069b8 <copyout+0x20>
      return -1;
80106a2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106a33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a36:	5b                   	pop    %ebx
80106a37:	5e                   	pop    %esi
80106a38:	5f                   	pop    %edi
80106a39:	5d                   	pop    %ebp
80106a3a:	c3                   	ret
80106a3b:	90                   	nop
  return 0;
80106a3c:	31 c0                	xor    %eax,%eax
}
80106a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a41:	5b                   	pop    %ebx
80106a42:	5e                   	pop    %esi
80106a43:	5f                   	pop    %edi
80106a44:	5d                   	pop    %ebp
80106a45:	c3                   	ret

80106a46 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106a46:	a1 00 00 00 00       	mov    0x0,%eax
80106a4b:	0f 0b                	ud2

80106a4d <copyout.cold>:
80106a4d:	a1 00 00 00 00       	mov    0x0,%eax
80106a52:	0f 0b                	ud2
