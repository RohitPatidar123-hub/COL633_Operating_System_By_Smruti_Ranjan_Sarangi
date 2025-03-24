
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
80100028:	bc d0 5b 11 80       	mov    $0x80115bd0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 18 2d 10 80       	mov    $0x80102d18,%eax
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
8010003b:	68 e0 6b 10 80       	push   $0x80106be0
80100040:	68 20 a5 10 80       	push   $0x8010a520
80100045:	e8 3e 41 00 00       	call   80104188 <initlock>

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
8010007f:	68 e7 6b 10 80       	push   $0x80106be7
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 ef 3f 00 00       	call   8010407c <initsleeplock>
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
801000c8:	e8 83 42 00 00       	call   80104350 <acquire>
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
8010013e:	e8 ad 41 00 00       	call   801042f0 <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 62 3f 00 00       	call   801040b0 <acquiresleep>
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
80100179:	68 ee 6b 10 80       	push   $0x80106bee
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
80100192:	e8 a9 3f 00 00       	call   80104140 <holdingsleep>
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
801001b0:	68 ff 6b 10 80       	push   $0x80106bff
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
801001cb:	e8 70 3f 00 00       	call   80104140 <holdingsleep>
801001d0:	83 c4 10             	add    $0x10,%esp
801001d3:	85 c0                	test   %eax,%eax
801001d5:	74 61                	je     80100238 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	56                   	push   %esi
801001db:	e8 24 3f 00 00       	call   80104104 <releasesleep>

  acquire(&bcache.lock);
801001e0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001e7:	e8 64 41 00 00       	call   80104350 <acquire>
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
80100233:	e9 b8 40 00 00       	jmp    801042f0 <release>
    panic("brelse");
80100238:	83 ec 0c             	sub    $0xc,%esp
8010023b:	68 06 6c 10 80       	push   $0x80106c06
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
80100266:	e8 e5 40 00 00       	call   80104350 <acquire>
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
80100295:	e8 32 3a 00 00       	call   80103ccc <sleep>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a8:	75 32                	jne    801002dc <consoleread+0x94>
      if(myproc()->killed){
801002aa:	e8 f1 32 00 00       	call   801035a0 <myproc>
801002af:	8b 40 40             	mov    0x40(%eax),%eax
801002b2:	85 c0                	test   %eax,%eax
801002b4:	74 d2                	je     80100288 <consoleread+0x40>
        release(&cons.lock);
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 20 ef 10 80       	push   $0x8010ef20
801002be:	e8 2d 40 00 00       	call   801042f0 <release>
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
80100311:	e8 da 3f 00 00       	call   801042f0 <release>
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
8010034a:	e8 11 23 00 00       	call   80102660 <lapicid>
8010034f:	83 ec 08             	sub    $0x8,%esp
80100352:	50                   	push   %eax
80100353:	68 0d 6c 10 80       	push   $0x80106c0d
80100358:	e8 c3 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
8010035d:	58                   	pop    %eax
8010035e:	ff 75 08             	push   0x8(%ebp)
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
80100366:	c7 04 24 11 71 10 80 	movl   $0x80107111,(%esp)
8010036d:	e8 ae 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
80100372:	5a                   	pop    %edx
80100373:	59                   	pop    %ecx
80100374:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100377:	53                   	push   %ebx
80100378:	8d 45 08             	lea    0x8(%ebp),%eax
8010037b:	50                   	push   %eax
8010037c:	e8 23 3e 00 00       	call   801041a4 <getcallerpcs>
  for(i=0; i<10; i++)
80100381:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100384:	83 ec 08             	sub    $0x8,%esp
80100387:	ff 33                	push   (%ebx)
80100389:	68 21 6c 10 80       	push   $0x80106c21
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
801003c6:	e8 5d 54 00 00       	call   80105828 <uartputc>
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
80100475:	e8 ae 53 00 00       	call   80105828 <uartputc>
8010047a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100481:	e8 a2 53 00 00       	call   80105828 <uartputc>
80100486:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010048d:	e8 96 53 00 00       	call   80105828 <uartputc>
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
801004d4:	e8 bf 3f 00 00       	call   80104498 <memmove>
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
801004f9:	e8 1e 3f 00 00       	call   8010441c <memset>
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
80100521:	68 25 6c 10 80       	push   $0x80106c25
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
80100547:	e8 04 3e 00 00       	call   80104350 <acquire>
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
8010057d:	e8 6e 3d 00 00       	call   801042f0 <release>
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
801005c3:	8a 92 64 71 10 80    	mov    -0x7fef8e9c(%edx),%dl
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
80100738:	e8 13 3c 00 00       	call   80104350 <acquire>
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
8010075b:	e8 90 3b 00 00       	call   801042f0 <release>
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
80100791:	bf 38 6c 10 80       	mov    $0x80106c38,%edi
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
801007de:	68 3f 6c 10 80       	push   $0x80106c3f
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
801007f9:	e8 52 3b 00 00       	call   80104350 <acquire>
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
80100831:	e8 ba 3a 00 00       	call   801042f0 <release>
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
80100936:	e8 65 35 00 00       	call   80103ea0 <wakeup>
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
801009ac:	e9 c3 35 00 00       	jmp    80103f74 <procdump>
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
801009e6:	68 48 6c 10 80       	push   $0x80106c48
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 93 37 00 00       	call   80104188 <initlock>

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
80100a30:	e8 6b 2b 00 00       	call   801035a0 <myproc>
80100a35:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a3b:	e8 24 20 00 00       	call   80102a64 <begin_op>

  if((ip = namei(path)) == 0){
80100a40:	83 ec 0c             	sub    $0xc,%esp
80100a43:	ff 75 08             	push   0x8(%ebp)
80100a46:	e8 29 14 00 00       	call   80101e74 <namei>
80100a4b:	83 c4 10             	add    $0x10,%esp
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	0f 84 13 03 00 00    	je     80100d69 <exec+0x345>
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
80100a8e:	e8 51 5e 00 00       	call   801068e4 <setupkvm>
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
80100aaf:	0f 84 84 02 00 00    	je     80100d39 <exec+0x315>
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
80100af9:	e8 52 5c 00 00       	call   80106750 <allocuvm>
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
80100b2f:	e8 58 5b 00 00       	call   8010668c <loaduvm>
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
80100b6f:	e8 00 5d 00 00       	call   80106874 <freevm>
  if(ip){
80100b74:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100b77:	83 ec 0c             	sub    $0xc,%esp
80100b7a:	57                   	push   %edi
80100b7b:	e8 f4 0c 00 00       	call   80101874 <iunlockput>
    end_op();
80100b80:	e8 47 1f 00 00       	call   80102acc <end_op>
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
80100bb9:	e8 0e 1f 00 00       	call   80102acc <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bbe:	83 c4 0c             	add    $0xc,%esp
80100bc1:	53                   	push   %ebx
80100bc2:	56                   	push   %esi
80100bc3:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bc9:	56                   	push   %esi
80100bca:	e8 81 5b 00 00       	call   80106750 <allocuvm>
80100bcf:	89 c7                	mov    %eax,%edi
80100bd1:	83 c4 10             	add    $0x10,%esp
80100bd4:	85 c0                	test   %eax,%eax
80100bd6:	74 7e                	je     80100c56 <exec+0x232>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd8:	83 ec 08             	sub    $0x8,%esp
80100bdb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be1:	50                   	push   %eax
80100be2:	56                   	push   %esi
80100be3:	e8 88 5d 00 00       	call   80106970 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100be8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100beb:	8b 10                	mov    (%eax),%edx
80100bed:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100bf0:	89 fb                	mov    %edi,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100bf2:	85 d2                	test   %edx,%edx
80100bf4:	0f 84 4b 01 00 00    	je     80100d45 <exec+0x321>
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
80100c2a:	e8 69 39 00 00       	call   80104598 <strlen>
80100c2f:	29 c3                	sub    %eax,%ebx
80100c31:	4b                   	dec    %ebx
80100c32:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c35:	5a                   	pop    %edx
80100c36:	ff 34 b7             	push   (%edi,%esi,4)
80100c39:	e8 5a 39 00 00       	call   80104598 <strlen>
80100c3e:	40                   	inc    %eax
80100c3f:	50                   	push   %eax
80100c40:	ff 34 b7             	push   (%edi,%esi,4)
80100c43:	53                   	push   %ebx
80100c44:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c4a:	e8 b9 5e 00 00       	call   80106b08 <copyout>
80100c4f:	83 c4 20             	add    $0x20,%esp
80100c52:	85 c0                	test   %eax,%eax
80100c54:	79 b2                	jns    80100c08 <exec+0x1e4>
    freevm(pgdir);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c5f:	e8 10 5c 00 00       	call   80106874 <freevm>
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
80100cbb:	e8 48 5e 00 00       	call   80106b08 <copyout>
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
80100cef:	8d 86 88 00 00 00    	lea    0x88(%esi),%eax
80100cf5:	50                   	push   %eax
80100cf6:	e8 69 38 00 00       	call   80104564 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100cfb:	89 f0                	mov    %esi,%eax
80100cfd:	8b 76 20             	mov    0x20(%esi),%esi
  curproc->pgdir = pgdir;
80100d00:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d06:	89 48 20             	mov    %ecx,0x20(%eax)
  curproc->sz = sz;
80100d09:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d0b:	89 c1                	mov    %eax,%ecx
80100d0d:	8b 40 34             	mov    0x34(%eax),%eax
80100d10:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d16:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d19:	8b 41 34             	mov    0x34(%ecx),%eax
80100d1c:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1f:	89 0c 24             	mov    %ecx,(%esp)
80100d22:	e8 f5 57 00 00       	call   8010651c <switchuvm>
  freevm(oldpgdir);
80100d27:	89 34 24             	mov    %esi,(%esp)
80100d2a:	e8 45 5b 00 00       	call   80106874 <freevm>
  return 0;
80100d2f:	83 c4 10             	add    $0x10,%esp
80100d32:	31 c0                	xor    %eax,%eax
80100d34:	e9 54 fe ff ff       	jmp    80100b8d <exec+0x169>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d39:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100d3e:	31 f6                	xor    %esi,%esi
80100d40:	e9 6b fe ff ff       	jmp    80100bb0 <exec+0x18c>
  for(argc = 0; argv[argc]; argc++) {
80100d45:	be 10 00 00 00       	mov    $0x10,%esi
80100d4a:	ba 04 00 00 00       	mov    $0x4,%edx
80100d4f:	b8 03 00 00 00       	mov    $0x3,%eax
80100d54:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d5b:	00 00 00 
80100d5e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d64:	e9 1c ff ff ff       	jmp    80100c85 <exec+0x261>
    end_op();
80100d69:	e8 5e 1d 00 00       	call   80102acc <end_op>
    cprintf("exec: fail\n");
80100d6e:	83 ec 0c             	sub    $0xc,%esp
80100d71:	68 50 6c 10 80       	push   $0x80106c50
80100d76:	e8 a5 f8 ff ff       	call   80100620 <cprintf>
    return -1;
80100d7b:	83 c4 10             	add    $0x10,%esp
80100d7e:	e9 05 fe ff ff       	jmp    80100b88 <exec+0x164>
80100d83:	90                   	nop

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
80100d8a:	68 5c 6c 10 80       	push   $0x80106c5c
80100d8f:	68 60 ef 10 80       	push   $0x8010ef60
80100d94:	e8 ef 33 00 00       	call   80104188 <initlock>
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
80100dac:	e8 9f 35 00 00       	call   80104350 <acquire>
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
80100ddd:	e8 0e 35 00 00       	call   801042f0 <release>
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
80100df4:	e8 f7 34 00 00       	call   801042f0 <release>
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
80100e17:	e8 34 35 00 00       	call   80104350 <acquire>
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
80100e32:	e8 b9 34 00 00       	call   801042f0 <release>
  return f;
}
80100e37:	89 d8                	mov    %ebx,%eax
80100e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3c:	c9                   	leave
80100e3d:	c3                   	ret
    panic("filedup");
80100e3e:	83 ec 0c             	sub    $0xc,%esp
80100e41:	68 63 6c 10 80       	push   $0x80106c63
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
80100e5d:	e8 ee 34 00 00       	call   80104350 <acquire>
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
80100e95:	e8 56 34 00 00       	call   801042f0 <release>

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
80100ebe:	e9 2d 34 00 00       	jmp    801042f0 <release>
80100ec3:	90                   	nop
    begin_op();
80100ec4:	e8 9b 1b 00 00       	call   80102a64 <begin_op>
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
80100ede:	e9 e9 1b 00 00       	jmp    80102acc <end_op>
80100ee3:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100ee4:	83 ec 08             	sub    $0x8,%esp
80100ee7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100eeb:	50                   	push   %eax
80100eec:	56                   	push   %esi
80100eed:	e8 72 22 00 00       	call   80103164 <pipeclose>
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
80100f00:	68 6b 6c 10 80       	push   $0x80106c6b
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
80100fc1:	e9 3e 23 00 00       	jmp    80103304 <piperead>
80100fc6:	66 90                	xchg   %ax,%ax
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb db                	jmp    80100faa <fileread+0x5a>
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 75 6c 10 80       	push   $0x80106c75
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
80101033:	e8 94 1a 00 00       	call   80102acc <end_op>

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
8010105b:	e8 04 1a 00 00       	call   80102a64 <begin_op>
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
80101093:	e8 34 1a 00 00       	call   80102acc <end_op>
      if(r < 0)
80101098:	83 c4 10             	add    $0x10,%esp
8010109b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109e:	85 c0                	test   %eax,%eax
801010a0:	75 0e                	jne    801010b0 <filewrite+0xd4>
        panic("short filewrite");
801010a2:	83 ec 0c             	sub    $0xc,%esp
801010a5:	68 7e 6c 10 80       	push   $0x80106c7e
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
801010d1:	e9 26 21 00 00       	jmp    801031fc <pipewrite>
  panic("filewrite");
801010d6:	83 ec 0c             	sub    $0xc,%esp
801010d9:	68 84 6c 10 80       	push   $0x80106c84
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
8010117c:	68 8e 6c 10 80       	push   $0x80106c8e
80101181:	e8 b2 f1 ff ff       	call   80100338 <panic>
80101186:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101188:	0b 55 e4             	or     -0x1c(%ebp),%edx
8010118b:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	53                   	push   %ebx
80101193:	e8 88 1a 00 00       	call   80102c20 <log_write>
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
801011bb:	e8 5c 32 00 00       	call   8010441c <memset>
  log_write(bp);
801011c0:	89 1c 24             	mov    %ebx,(%esp)
801011c3:	e8 58 1a 00 00       	call   80102c20 <log_write>
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
801011ef:	e8 5c 31 00 00       	call   80104350 <acquire>
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
80101257:	e8 94 30 00 00       	call   801042f0 <release>

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
8010127d:	e8 6e 30 00 00       	call   801042f0 <release>
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
801012b2:	68 a4 6c 10 80       	push   $0x80106ca4
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
80101309:	e8 12 19 00 00       	call   80102c20 <log_write>
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
80101323:	68 b4 6c 10 80       	push   $0x80106cb4
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
8010139c:	e8 7f 18 00 00       	call   80102c20 <log_write>
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
801013dd:	68 c7 6c 10 80       	push   $0x80106cc7
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
80101409:	e8 8a 30 00 00       	call   80104498 <memmove>
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
80101427:	68 da 6c 10 80       	push   $0x80106cda
8010142c:	68 60 f9 10 80       	push   $0x8010f960
80101431:	e8 52 2d 00 00       	call   80104188 <initlock>
  for(i = 0; i < NINODE; i++) {
80101436:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
8010143b:	83 c4 10             	add    $0x10,%esp
8010143e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101440:	83 ec 08             	sub    $0x8,%esp
80101443:	68 e1 6c 10 80       	push   $0x80106ce1
80101448:	53                   	push   %ebx
80101449:	e8 2e 2c 00 00       	call   8010407c <initsleeplock>
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
8010147c:	e8 17 30 00 00       	call   80104498 <memmove>
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
801014b3:	68 78 71 10 80       	push   $0x80107178
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
8010153a:	e8 dd 2e 00 00       	call   8010441c <memset>
      dip->type = type;
8010153f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101542:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101545:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101548:	89 1c 24             	mov    %ebx,(%esp)
8010154b:	e8 d0 16 00 00       	call   80102c20 <log_write>
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
8010156e:	68 e7 6c 10 80       	push   $0x80106ce7
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
801015d6:	e8 bd 2e 00 00       	call   80104498 <memmove>
  log_write(bp);
801015db:	89 34 24             	mov    %esi,(%esp)
801015de:	e8 3d 16 00 00       	call   80102c20 <log_write>
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
80101603:	e8 48 2d 00 00       	call   80104350 <acquire>
  ip->ref++;
80101608:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
8010160b:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101612:	e8 d9 2c 00 00       	call   801042f0 <release>
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
80101642:	e8 69 2a 00 00       	call   801040b0 <acquiresleep>
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
801016ae:	e8 e5 2d 00 00       	call   80104498 <memmove>
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
801016cf:	68 ff 6c 10 80       	push   $0x80106cff
801016d4:	e8 5f ec ff ff       	call   80100338 <panic>
    panic("ilock");
801016d9:	83 ec 0c             	sub    $0xc,%esp
801016dc:	68 f9 6c 10 80       	push   $0x80106cf9
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
801016fb:	e8 40 2a 00 00       	call   80104140 <holdingsleep>
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
80101717:	e9 e8 29 00 00       	jmp    80104104 <releasesleep>
    panic("iunlock");
8010171c:	83 ec 0c             	sub    $0xc,%esp
8010171f:	68 0e 6d 10 80       	push   $0x80106d0e
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
8010173c:	e8 6f 29 00 00       	call   801040b0 <acquiresleep>
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
80101756:	e8 a9 29 00 00       	call   80104104 <releasesleep>
  acquire(&icache.lock);
8010175b:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101762:	e8 e9 2b 00 00       	call   80104350 <acquire>
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
8010177b:	e9 70 2b 00 00       	jmp    801042f0 <release>
    acquire(&icache.lock);
80101780:	83 ec 0c             	sub    $0xc,%esp
80101783:	68 60 f9 10 80       	push   $0x8010f960
80101788:	e8 c3 2b 00 00       	call   80104350 <acquire>
    int r = ip->ref;
8010178d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101790:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101797:	e8 54 2b 00 00       	call   801042f0 <release>
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
80101887:	e8 b4 28 00 00       	call   80104140 <holdingsleep>
8010188c:	83 c4 10             	add    $0x10,%esp
8010188f:	85 c0                	test   %eax,%eax
80101891:	74 21                	je     801018b4 <iunlockput+0x40>
80101893:	8b 43 08             	mov    0x8(%ebx),%eax
80101896:	85 c0                	test   %eax,%eax
80101898:	7e 1a                	jle    801018b4 <iunlockput+0x40>
  releasesleep(&ip->lock);
8010189a:	83 ec 0c             	sub    $0xc,%esp
8010189d:	56                   	push   %esi
8010189e:	e8 61 28 00 00       	call   80104104 <releasesleep>
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
801018b7:	68 0e 6d 10 80       	push   $0x80106d0e
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
8010198d:	e8 06 2b 00 00       	call   80104498 <memmove>
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
80101a91:	e8 02 2a 00 00       	call   80104498 <memmove>
    log_write(bp);
80101a96:	89 3c 24             	mov    %edi,(%esp)
80101a99:	e8 82 11 00 00       	call   80102c20 <log_write>
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
80101b1a:	e8 c5 29 00 00       	call   801044e4 <strncmp>
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
80101b67:	e8 78 29 00 00       	call   801044e4 <strncmp>
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
80101baa:	68 28 6d 10 80       	push   $0x80106d28
80101baf:	e8 84 e7 ff ff       	call   80100338 <panic>
    panic("dirlookup not DIR");
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	68 16 6d 10 80       	push   $0x80106d16
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
80101bde:	e8 bd 19 00 00       	call   801035a0 <myproc>
80101be3:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 f9 10 80       	push   $0x8010f960
80101bf1:	e8 5a 27 00 00       	call   80104350 <acquire>
  ip->ref++;
80101bf6:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101bf9:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101c00:	e8 eb 26 00 00       	call   801042f0 <release>
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
80101c47:	e8 4c 28 00 00       	call   80104498 <memmove>
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
80101ca4:	e8 97 24 00 00       	call   80104140 <holdingsleep>
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
80101cc6:	e8 39 24 00 00       	call   80104104 <releasesleep>
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
80101cef:	e8 a4 27 00 00       	call   80104498 <memmove>
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
80101d20:	e8 1b 24 00 00       	call   80104140 <holdingsleep>
80101d25:	83 c4 10             	add    $0x10,%esp
80101d28:	85 c0                	test   %eax,%eax
80101d2a:	0f 84 84 00 00 00    	je     80101db4 <namex+0x1f0>
80101d30:	8b 46 08             	mov    0x8(%esi),%eax
80101d33:	85 c0                	test   %eax,%eax
80101d35:	7e 7d                	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101d37:	83 ec 0c             	sub    $0xc,%esp
80101d3a:	53                   	push   %ebx
80101d3b:	e8 c4 23 00 00       	call   80104104 <releasesleep>
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
80101d7b:	e8 c0 23 00 00       	call   80104140 <holdingsleep>
80101d80:	83 c4 10             	add    $0x10,%esp
80101d83:	85 c0                	test   %eax,%eax
80101d85:	74 2d                	je     80101db4 <namex+0x1f0>
80101d87:	8b 46 08             	mov    0x8(%esi),%eax
80101d8a:	85 c0                	test   %eax,%eax
80101d8c:	7e 26                	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	53                   	push   %ebx
80101d92:	e8 6d 23 00 00       	call   80104104 <releasesleep>
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
80101db7:	68 0e 6d 10 80       	push   $0x80106d0e
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
80101e1f:	e8 f8 26 00 00       	call   8010451c <strncpy>
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
80101e5d:	68 37 6d 10 80       	push   $0x80106d37
80101e62:	e8 d1 e4 ff ff       	call   80100338 <panic>
    panic("dirlink");
80101e67:	83 ec 0c             	sub    $0xc,%esp
80101e6a:	68 15 70 10 80       	push   $0x80107015
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
80101f40:	68 4d 6d 10 80       	push   $0x80106d4d
80101f45:	e8 ee e3 ff ff       	call   80100338 <panic>
    panic("idestart");
80101f4a:	83 ec 0c             	sub    $0xc,%esp
80101f4d:	68 44 6d 10 80       	push   $0x80106d44
80101f52:	e8 e1 e3 ff ff       	call   80100338 <panic>
80101f57:	90                   	nop

80101f58 <ideinit>:
{
80101f58:	55                   	push   %ebp
80101f59:	89 e5                	mov    %esp,%ebp
80101f5b:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101f5e:	68 5f 6d 10 80       	push   $0x80106d5f
80101f63:	68 00 16 11 80       	push   $0x80111600
80101f68:	e8 1b 22 00 00       	call   80104188 <initlock>
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
80101fce:	e8 7d 23 00 00       	call   80104350 <acquire>

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
80102025:	e8 76 1e 00 00       	call   80103ea0 <wakeup>

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
80102043:	e8 a8 22 00 00       	call   801042f0 <release>

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
8010205e:	e8 dd 20 00 00       	call   80104140 <holdingsleep>
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
80102094:	e8 b7 22 00 00       	call   80104350 <acquire>

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
801020d5:	e8 f2 1b 00 00       	call   80103ccc <sleep>
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
801020f2:	e9 f9 21 00 00       	jmp    801042f0 <release>
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
8010210e:	68 8e 6d 10 80       	push   $0x80106d8e
80102113:	e8 20 e2 ff ff       	call   80100338 <panic>
    panic("iderw: nothing to do");
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	68 79 6d 10 80       	push   $0x80106d79
80102120:	e8 13 e2 ff ff       	call   80100338 <panic>
    panic("iderw: buf not locked");
80102125:	83 ec 0c             	sub    $0xc,%esp
80102128:	68 63 6d 10 80       	push   $0x80106d63
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
8010217e:	68 cc 71 10 80       	push   $0x801071cc
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
80102214:	81 fb d0 5b 11 80    	cmp    $0x80115bd0,%ebx
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
80102232:	e8 e5 21 00 00       	call   8010441c <memset>

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
80102268:	e8 e3 20 00 00       	call   80104350 <acquire>
8010226d:	83 c4 10             	add    $0x10,%esp
80102270:	eb d2                	jmp    80102244 <kfree+0x40>
80102272:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102274:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010227b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010227e:	c9                   	leave
    release(&kmem.lock);
8010227f:	e9 6c 20 00 00       	jmp    801042f0 <release>
    panic("kfree");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 ac 6d 10 80       	push   $0x80106dac
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
8010233b:	68 b2 6d 10 80       	push   $0x80106db2
80102340:	68 40 16 11 80       	push   $0x80111640
80102345:	e8 3e 1e 00 00       	call   80104188 <initlock>
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
801023bf:	e8 8c 1f 00 00       	call   80104350 <acquire>
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
801023ed:	e8 fe 1e 00 00       	call   801042f0 <release>
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
80102437:	0f b6 93 c0 74 10 80 	movzbl -0x7fef8b40(%ebx),%edx
8010243e:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
80102440:	0f b6 83 c0 73 10 80 	movzbl -0x7fef8c40(%ebx),%eax
80102447:	31 c2                	xor    %eax,%edx
80102449:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
8010244f:	89 d0                	mov    %edx,%eax
80102451:	83 e0 03             	and    $0x3,%eax
80102454:	8b 04 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%eax
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
80102495:	8a 83 c0 74 10 80    	mov    -0x7fef8b40(%ebx),%al
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
// {
//   consoleintr(kbdgetc);

// }

void kbdintr(void) {
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 08             	sub    $0x8,%esp
  uchar c;
  // extern struct { struct spinlock lock; int locking; } cons;
  // acquire(&cons.lock);
  c = kbdgetc();
801024c6:	e8 31 ff ff ff       	call   801023fc <kbdgetc>
  if(c == 0){
801024cb:	84 c0                	test   %al,%al
801024cd:	74 34                	je     80102503 <kbdintr+0x43>
    // release(&cons.lock);
    return;
  }

  switch(c){
801024cf:	0f b6 c0             	movzbl %al,%eax
801024d2:	83 f8 06             	cmp    $0x6,%eax
801024d5:	74 75                	je     8010254c <kbdintr+0x8c>
801024d7:	7f 2f                	jg     80102508 <kbdintr+0x48>
801024d9:	83 f8 02             	cmp    $0x2,%eax
801024dc:	74 4e                	je     8010252c <kbdintr+0x6c>
801024de:	83 f8 03             	cmp    $0x3,%eax
801024e1:	0f 85 85 00 00 00    	jne    8010256c <kbdintr+0xac>
        case 0x03: // Ctrl+C
            cprintf("Ctrl -C is detected by xv6\n");
801024e7:	83 ec 0c             	sub    $0xc,%esp
801024ea:	68 b7 6d 10 80       	push   $0x80106db7
801024ef:	e8 2c e1 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGINT);
801024f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801024fb:	e8 34 13 00 00       	call   80103834 <send_signal_to_all>
            break;
80102500:	83 c4 10             	add    $0x10,%esp
        default:
            consoleintr(kbdgetc);
            break;
    }
  //  release(&cons.lock);
}
80102503:	c9                   	leave
80102504:	c3                   	ret
80102505:	8d 76 00             	lea    0x0(%esi),%esi
  switch(c){
80102508:	83 f8 07             	cmp    $0x7,%eax
8010250b:	75 5f                	jne    8010256c <kbdintr+0xac>
            cprintf("Ctrl -G is detected by xv6\n");
8010250d:	83 ec 0c             	sub    $0xc,%esp
80102510:	68 0b 6e 10 80       	push   $0x80106e0b
80102515:	e8 06 e1 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGCUSTOM);
8010251a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80102521:	e8 0e 13 00 00       	call   80103834 <send_signal_to_all>
            break;
80102526:	83 c4 10             	add    $0x10,%esp
}
80102529:	c9                   	leave
8010252a:	c3                   	ret
8010252b:	90                   	nop
            cprintf("Ctrl -B is detected by xv6\n");
8010252c:	83 ec 0c             	sub    $0xc,%esp
8010252f:	68 d3 6d 10 80       	push   $0x80106dd3
80102534:	e8 e7 e0 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGBG);
80102539:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80102540:	e8 ef 12 00 00       	call   80103834 <send_signal_to_all>
            break;
80102545:	83 c4 10             	add    $0x10,%esp
}
80102548:	c9                   	leave
80102549:	c3                   	ret
8010254a:	66 90                	xchg   %ax,%ax
            cprintf("Ctrl -F is detected by xv6\n");
8010254c:	83 ec 0c             	sub    $0xc,%esp
8010254f:	68 ef 6d 10 80       	push   $0x80106def
80102554:	e8 c7 e0 ff ff       	call   80100620 <cprintf>
            send_signal_to_all(SIGFG);
80102559:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80102560:	e8 cf 12 00 00       	call   80103834 <send_signal_to_all>
            break;
80102565:	83 c4 10             	add    $0x10,%esp
}
80102568:	c9                   	leave
80102569:	c3                   	ret
8010256a:	66 90                	xchg   %ax,%ax
            consoleintr(kbdgetc);
8010256c:	83 ec 0c             	sub    $0xc,%esp
8010256f:	68 fc 23 10 80       	push   $0x801023fc
80102574:	e8 6f e2 ff ff       	call   801007e8 <consoleintr>
            break;
80102579:	83 c4 10             	add    $0x10,%esp
}
8010257c:	c9                   	leave
8010257d:	c3                   	ret
8010257e:	66 90                	xchg   %ax,%ax

80102580 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102580:	a1 80 16 11 80       	mov    0x80111680,%eax
80102585:	85 c0                	test   %eax,%eax
80102587:	0f 84 bf 00 00 00    	je     8010264c <lapicinit+0xcc>
  lapic[index] = value;
8010258d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102594:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102597:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010259a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025a7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801025ae:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801025b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025b4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801025bb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801025be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025c1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801025c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025ce:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801025d5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801025db:	8b 50 30             	mov    0x30(%eax),%edx
801025de:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801025e4:	75 6a                	jne    80102650 <lapicinit+0xd0>
  lapic[index] = value;
801025e6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801025ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801025f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801025fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102600:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102607:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010260d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102614:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102617:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010261a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102621:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102624:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102627:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010262e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102631:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102634:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010263a:	80 e6 10             	and    $0x10,%dh
8010263d:	75 f5                	jne    80102634 <lapicinit+0xb4>
  lapic[index] = value;
8010263f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102646:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102649:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
8010264c:	c3                   	ret
8010264d:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
80102650:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102657:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010265d:	eb 87                	jmp    801025e6 <lapicinit+0x66>
8010265f:	90                   	nop

80102660 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102660:	a1 80 16 11 80       	mov    0x80111680,%eax
80102665:	85 c0                	test   %eax,%eax
80102667:	74 07                	je     80102670 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102669:	8b 40 20             	mov    0x20(%eax),%eax
8010266c:	c1 e8 18             	shr    $0x18,%eax
8010266f:	c3                   	ret
80102670:	31 c0                	xor    %eax,%eax
}
80102672:	c3                   	ret
80102673:	90                   	nop

80102674 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102674:	a1 80 16 11 80       	mov    0x80111680,%eax
80102679:	85 c0                	test   %eax,%eax
8010267b:	74 0d                	je     8010268a <lapiceoi+0x16>
  lapic[index] = value;
8010267d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010268a:	c3                   	ret
8010268b:	90                   	nop

8010268c <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
8010268c:	c3                   	ret
8010268d:	8d 76 00             	lea    0x0(%esi),%esi

80102690 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	53                   	push   %ebx
80102694:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102697:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269a:	b0 0f                	mov    $0xf,%al
8010269c:	ba 70 00 00 00       	mov    $0x70,%edx
801026a1:	ee                   	out    %al,(%dx)
801026a2:	b0 0a                	mov    $0xa,%al
801026a4:	ba 71 00 00 00       	mov    $0x71,%edx
801026a9:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801026aa:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801026b1:	00 00 
  wrv[1] = addr >> 4;
801026b3:	89 c8                	mov    %ecx,%eax
801026b5:	c1 e8 04             	shr    $0x4,%eax
801026b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801026be:	a1 80 16 11 80       	mov    0x80111680,%eax
801026c3:	c1 e3 18             	shl    $0x18,%ebx
801026c6:	89 da                	mov    %ebx,%edx
801026c8:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026d1:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801026d8:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026de:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801026e5:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e8:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801026eb:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026f1:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801026f4:	c1 e9 0c             	shr    $0xc,%ecx
801026f7:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
801026fa:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102703:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102709:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270c:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102712:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102718:	c9                   	leave
80102719:	c3                   	ret
8010271a:	66 90                	xchg   %ax,%ax

8010271c <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010271c:	55                   	push   %ebp
8010271d:	89 e5                	mov    %esp,%ebp
8010271f:	57                   	push   %edi
80102720:	56                   	push   %esi
80102721:	53                   	push   %ebx
80102722:	83 ec 4c             	sub    $0x4c,%esp
80102725:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102728:	b0 0b                	mov    $0xb,%al
8010272a:	ba 70 00 00 00       	mov    $0x70,%edx
8010272f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102730:	ba 71 00 00 00       	mov    $0x71,%edx
80102735:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102736:	83 e0 04             	and    $0x4,%eax
80102739:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010273b:	89 df                	mov    %ebx,%edi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi
80102740:	31 c0                	xor    %eax,%eax
80102742:	ba 70 00 00 00       	mov    $0x70,%edx
80102747:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102748:	bb 71 00 00 00       	mov    $0x71,%ebx
8010274d:	89 da                	mov    %ebx,%edx
8010274f:	ec                   	in     (%dx),%al
80102750:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102753:	b0 02                	mov    $0x2,%al
80102755:	ba 70 00 00 00       	mov    $0x70,%edx
8010275a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010275b:	89 da                	mov    %ebx,%edx
8010275d:	ec                   	in     (%dx),%al
8010275e:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102761:	b0 04                	mov    $0x4,%al
80102763:	ba 70 00 00 00       	mov    $0x70,%edx
80102768:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102769:	89 da                	mov    %ebx,%edx
8010276b:	ec                   	in     (%dx),%al
8010276c:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010276f:	b0 07                	mov    $0x7,%al
80102771:	ba 70 00 00 00       	mov    $0x70,%edx
80102776:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102777:	89 da                	mov    %ebx,%edx
80102779:	ec                   	in     (%dx),%al
8010277a:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010277d:	b0 08                	mov    $0x8,%al
8010277f:	ba 70 00 00 00       	mov    $0x70,%edx
80102784:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102785:	89 da                	mov    %ebx,%edx
80102787:	ec                   	in     (%dx),%al
80102788:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010278b:	b0 09                	mov    $0x9,%al
8010278d:	ba 70 00 00 00       	mov    $0x70,%edx
80102792:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102793:	89 da                	mov    %ebx,%edx
80102795:	ec                   	in     (%dx),%al
80102796:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102799:	b0 0a                	mov    $0xa,%al
8010279b:	ba 70 00 00 00       	mov    $0x70,%edx
801027a0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a1:	89 da                	mov    %ebx,%edx
801027a3:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801027a4:	84 c0                	test   %al,%al
801027a6:	78 98                	js     80102740 <cmostime+0x24>
  return inb(CMOS_RETURN);
801027a8:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801027ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
801027af:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801027b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801027b6:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801027ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
801027bd:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801027c1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801027c4:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
801027c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
801027cb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027ce:	31 c0                	xor    %eax,%eax
801027d0:	ba 70 00 00 00       	mov    $0x70,%edx
801027d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d6:	89 da                	mov    %ebx,%edx
801027d8:	ec                   	in     (%dx),%al
801027d9:	0f b6 c0             	movzbl %al,%eax
801027dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027df:	b0 02                	mov    $0x2,%al
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e7:	89 da                	mov    %ebx,%edx
801027e9:	ec                   	in     (%dx),%al
801027ea:	0f b6 c0             	movzbl %al,%eax
801027ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	b0 04                	mov    $0x4,%al
801027f2:	ba 70 00 00 00       	mov    $0x70,%edx
801027f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f8:	89 da                	mov    %ebx,%edx
801027fa:	ec                   	in     (%dx),%al
801027fb:	0f b6 c0             	movzbl %al,%eax
801027fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102801:	b0 07                	mov    $0x7,%al
80102803:	ba 70 00 00 00       	mov    $0x70,%edx
80102808:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102809:	89 da                	mov    %ebx,%edx
8010280b:	ec                   	in     (%dx),%al
8010280c:	0f b6 c0             	movzbl %al,%eax
8010280f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102812:	b0 08                	mov    $0x8,%al
80102814:	ba 70 00 00 00       	mov    $0x70,%edx
80102819:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281a:	89 da                	mov    %ebx,%edx
8010281c:	ec                   	in     (%dx),%al
8010281d:	0f b6 c0             	movzbl %al,%eax
80102820:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102823:	b0 09                	mov    $0x9,%al
80102825:	ba 70 00 00 00       	mov    $0x70,%edx
8010282a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282b:	89 da                	mov    %ebx,%edx
8010282d:	ec                   	in     (%dx),%al
8010282e:	0f b6 c0             	movzbl %al,%eax
80102831:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102834:	50                   	push   %eax
80102835:	6a 18                	push   $0x18
80102837:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010283a:	50                   	push   %eax
8010283b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010283e:	50                   	push   %eax
8010283f:	e8 1c 1c 00 00       	call   80104460 <memcmp>
80102844:	83 c4 10             	add    $0x10,%esp
80102847:	85 c0                	test   %eax,%eax
80102849:	0f 85 f1 fe ff ff    	jne    80102740 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
8010284f:	89 fb                	mov    %edi,%ebx
80102851:	89 f0                	mov    %esi,%eax
80102853:	84 c0                	test   %al,%al
80102855:	75 7e                	jne    801028d5 <cmostime+0x1b9>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102857:	8b 55 b8             	mov    -0x48(%ebp),%edx
8010285a:	89 d0                	mov    %edx,%eax
8010285c:	c1 e8 04             	shr    $0x4,%eax
8010285f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102862:	01 c0                	add    %eax,%eax
80102864:	83 e2 0f             	and    $0xf,%edx
80102867:	01 d0                	add    %edx,%eax
80102869:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010286c:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010286f:	89 d0                	mov    %edx,%eax
80102871:	c1 e8 04             	shr    $0x4,%eax
80102874:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102877:	01 c0                	add    %eax,%eax
80102879:	83 e2 0f             	and    $0xf,%edx
8010287c:	01 d0                	add    %edx,%eax
8010287e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102881:	8b 55 c0             	mov    -0x40(%ebp),%edx
80102884:	89 d0                	mov    %edx,%eax
80102886:	c1 e8 04             	shr    $0x4,%eax
80102889:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010288c:	01 c0                	add    %eax,%eax
8010288e:	83 e2 0f             	and    $0xf,%edx
80102891:	01 d0                	add    %edx,%eax
80102893:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102896:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80102899:	89 d0                	mov    %edx,%eax
8010289b:	c1 e8 04             	shr    $0x4,%eax
8010289e:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028a1:	01 c0                	add    %eax,%eax
801028a3:	83 e2 0f             	and    $0xf,%edx
801028a6:	01 d0                	add    %edx,%eax
801028a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
801028ae:	89 d0                	mov    %edx,%eax
801028b0:	c1 e8 04             	shr    $0x4,%eax
801028b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028b6:	01 c0                	add    %eax,%eax
801028b8:	83 e2 0f             	and    $0xf,%edx
801028bb:	01 d0                	add    %edx,%eax
801028bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
801028c3:	89 d0                	mov    %edx,%eax
801028c5:	c1 e8 04             	shr    $0x4,%eax
801028c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
801028cb:	01 c0                	add    %eax,%eax
801028cd:	83 e2 0f             	and    $0xf,%edx
801028d0:	01 d0                	add    %edx,%eax
801028d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801028d5:	b9 06 00 00 00       	mov    $0x6,%ecx
801028da:	89 df                	mov    %ebx,%edi
801028dc:	8d 75 b8             	lea    -0x48(%ebp),%esi
801028df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801028e1:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
801028e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028eb:	5b                   	pop    %ebx
801028ec:	5e                   	pop    %esi
801028ed:	5f                   	pop    %edi
801028ee:	5d                   	pop    %ebp
801028ef:	c3                   	ret

801028f0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801028f0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
801028f6:	85 c9                	test   %ecx,%ecx
801028f8:	7e 7e                	jle    80102978 <install_trans+0x88>
{
801028fa:	55                   	push   %ebp
801028fb:	89 e5                	mov    %esp,%ebp
801028fd:	57                   	push   %edi
801028fe:	56                   	push   %esi
801028ff:	53                   	push   %ebx
80102900:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102903:	31 ff                	xor    %edi,%edi
80102905:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102908:	83 ec 08             	sub    $0x8,%esp
8010290b:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102910:	01 f8                	add    %edi,%eax
80102912:	40                   	inc    %eax
80102913:	50                   	push   %eax
80102914:	ff 35 e4 16 11 80    	push   0x801116e4
8010291a:	e8 95 d7 ff ff       	call   801000b4 <bread>
8010291f:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102921:	58                   	pop    %eax
80102922:	5a                   	pop    %edx
80102923:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
8010292a:	ff 35 e4 16 11 80    	push   0x801116e4
80102930:	e8 7f d7 ff ff       	call   801000b4 <bread>
80102935:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102937:	83 c4 0c             	add    $0xc,%esp
8010293a:	68 00 02 00 00       	push   $0x200
8010293f:	8d 46 5c             	lea    0x5c(%esi),%eax
80102942:	50                   	push   %eax
80102943:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102946:	50                   	push   %eax
80102947:	e8 4c 1b 00 00       	call   80104498 <memmove>
    bwrite(dbuf);  // write dst to disk
8010294c:	89 1c 24             	mov    %ebx,(%esp)
8010294f:	e8 30 d8 ff ff       	call   80100184 <bwrite>
    brelse(lbuf);
80102954:	89 34 24             	mov    %esi,(%esp)
80102957:	e8 60 d8 ff ff       	call   801001bc <brelse>
    brelse(dbuf);
8010295c:	89 1c 24             	mov    %ebx,(%esp)
8010295f:	e8 58 d8 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102964:	47                   	inc    %edi
80102965:	83 c4 10             	add    $0x10,%esp
80102968:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
8010296e:	7f 98                	jg     80102908 <install_trans+0x18>
  }
}
80102970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102973:	5b                   	pop    %ebx
80102974:	5e                   	pop    %esi
80102975:	5f                   	pop    %edi
80102976:	5d                   	pop    %ebp
80102977:	c3                   	ret
80102978:	c3                   	ret
80102979:	8d 76 00             	lea    0x0(%esi),%esi

8010297c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010297c:	55                   	push   %ebp
8010297d:	89 e5                	mov    %esp,%ebp
8010297f:	53                   	push   %ebx
80102980:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102983:	ff 35 d4 16 11 80    	push   0x801116d4
80102989:	ff 35 e4 16 11 80    	push   0x801116e4
8010298f:	e8 20 d7 ff ff       	call   801000b4 <bread>
80102994:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102996:	a1 e8 16 11 80       	mov    0x801116e8,%eax
8010299b:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
8010299e:	83 c4 10             	add    $0x10,%esp
801029a1:	85 c0                	test   %eax,%eax
801029a3:	7e 13                	jle    801029b8 <write_head+0x3c>
801029a5:	31 d2                	xor    %edx,%edx
801029a7:	90                   	nop
    hb->block[i] = log.lh.block[i];
801029a8:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
801029af:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801029b3:	42                   	inc    %edx
801029b4:	39 d0                	cmp    %edx,%eax
801029b6:	75 f0                	jne    801029a8 <write_head+0x2c>
  }
  bwrite(buf);
801029b8:	83 ec 0c             	sub    $0xc,%esp
801029bb:	53                   	push   %ebx
801029bc:	e8 c3 d7 ff ff       	call   80100184 <bwrite>
  brelse(buf);
801029c1:	89 1c 24             	mov    %ebx,(%esp)
801029c4:	e8 f3 d7 ff ff       	call   801001bc <brelse>
}
801029c9:	83 c4 10             	add    $0x10,%esp
801029cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cf:	c9                   	leave
801029d0:	c3                   	ret
801029d1:	8d 76 00             	lea    0x0(%esi),%esi

801029d4 <initlog>:
{
801029d4:	55                   	push   %ebp
801029d5:	89 e5                	mov    %esp,%ebp
801029d7:	53                   	push   %ebx
801029d8:	83 ec 2c             	sub    $0x2c,%esp
801029db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801029de:	68 27 6e 10 80       	push   $0x80106e27
801029e3:	68 a0 16 11 80       	push   $0x801116a0
801029e8:	e8 9b 17 00 00       	call   80104188 <initlock>
  readsb(dev, &sb);
801029ed:	58                   	pop    %eax
801029ee:	5a                   	pop    %edx
801029ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
801029f2:	50                   	push   %eax
801029f3:	53                   	push   %ebx
801029f4:	e8 ef e9 ff ff       	call   801013e8 <readsb>
  log.start = sb.logstart;
801029f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029fc:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102a01:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102a04:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  log.dev = dev;
80102a0a:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  struct buf *buf = bread(log.dev, log.start);
80102a10:	59                   	pop    %ecx
80102a11:	5a                   	pop    %edx
80102a12:	50                   	push   %eax
80102a13:	53                   	push   %ebx
80102a14:	e8 9b d6 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
80102a19:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102a1c:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102a22:	83 c4 10             	add    $0x10,%esp
80102a25:	85 db                	test   %ebx,%ebx
80102a27:	7e 13                	jle    80102a3c <initlog+0x68>
80102a29:	31 d2                	xor    %edx,%edx
80102a2b:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102a2c:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102a30:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a37:	42                   	inc    %edx
80102a38:	39 d3                	cmp    %edx,%ebx
80102a3a:	75 f0                	jne    80102a2c <initlog+0x58>
  brelse(buf);
80102a3c:	83 ec 0c             	sub    $0xc,%esp
80102a3f:	50                   	push   %eax
80102a40:	e8 77 d7 ff ff       	call   801001bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102a45:	e8 a6 fe ff ff       	call   801028f0 <install_trans>
  log.lh.n = 0;
80102a4a:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102a51:	00 00 00 
  write_head(); // clear the log
80102a54:	e8 23 ff ff ff       	call   8010297c <write_head>
}
80102a59:	83 c4 10             	add    $0x10,%esp
80102a5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a5f:	c9                   	leave
80102a60:	c3                   	ret
80102a61:	8d 76 00             	lea    0x0(%esi),%esi

80102a64 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102a64:	55                   	push   %ebp
80102a65:	89 e5                	mov    %esp,%ebp
80102a67:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102a6a:	68 a0 16 11 80       	push   $0x801116a0
80102a6f:	e8 dc 18 00 00       	call   80104350 <acquire>
80102a74:	83 c4 10             	add    $0x10,%esp
80102a77:	eb 18                	jmp    80102a91 <begin_op+0x2d>
80102a79:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102a7c:	83 ec 08             	sub    $0x8,%esp
80102a7f:	68 a0 16 11 80       	push   $0x801116a0
80102a84:	68 a0 16 11 80       	push   $0x801116a0
80102a89:	e8 3e 12 00 00       	call   80103ccc <sleep>
80102a8e:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102a91:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102a96:	85 c0                	test   %eax,%eax
80102a98:	75 e2                	jne    80102a7c <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102a9a:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102a9f:	8d 50 01             	lea    0x1(%eax),%edx
80102aa2:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
80102aa6:	01 c0                	add    %eax,%eax
80102aa8:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102aae:	83 f8 1e             	cmp    $0x1e,%eax
80102ab1:	7f c9                	jg     80102a7c <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102ab3:	89 15 dc 16 11 80    	mov    %edx,0x801116dc
      release(&log.lock);
80102ab9:	83 ec 0c             	sub    $0xc,%esp
80102abc:	68 a0 16 11 80       	push   $0x801116a0
80102ac1:	e8 2a 18 00 00       	call   801042f0 <release>
      break;
    }
  }
}
80102ac6:	83 c4 10             	add    $0x10,%esp
80102ac9:	c9                   	leave
80102aca:	c3                   	ret
80102acb:	90                   	nop

80102acc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102acc:	55                   	push   %ebp
80102acd:	89 e5                	mov    %esp,%ebp
80102acf:	57                   	push   %edi
80102ad0:	56                   	push   %esi
80102ad1:	53                   	push   %ebx
80102ad2:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ad5:	68 a0 16 11 80       	push   $0x801116a0
80102ada:	e8 71 18 00 00       	call   80104350 <acquire>
  log.outstanding -= 1;
80102adf:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102ae4:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ae7:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102aed:	83 c4 10             	add    $0x10,%esp
80102af0:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102af6:	85 f6                	test   %esi,%esi
80102af8:	0f 85 12 01 00 00    	jne    80102c10 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
80102afe:	85 db                	test   %ebx,%ebx
80102b00:	0f 85 e6 00 00 00    	jne    80102bec <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
80102b06:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102b0d:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	68 a0 16 11 80       	push   $0x801116a0
80102b18:	e8 d3 17 00 00       	call   801042f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b1d:	83 c4 10             	add    $0x10,%esp
80102b20:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102b26:	85 c9                	test   %ecx,%ecx
80102b28:	7f 3a                	jg     80102b64 <end_op+0x98>
    acquire(&log.lock);
80102b2a:	83 ec 0c             	sub    $0xc,%esp
80102b2d:	68 a0 16 11 80       	push   $0x801116a0
80102b32:	e8 19 18 00 00       	call   80104350 <acquire>
    log.committing = 0;
80102b37:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102b3e:	00 00 00 
    wakeup(&log);
80102b41:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b48:	e8 53 13 00 00       	call   80103ea0 <wakeup>
    release(&log.lock);
80102b4d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b54:	e8 97 17 00 00       	call   801042f0 <release>
80102b59:	83 c4 10             	add    $0x10,%esp
}
80102b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b5f:	5b                   	pop    %ebx
80102b60:	5e                   	pop    %esi
80102b61:	5f                   	pop    %edi
80102b62:	5d                   	pop    %ebp
80102b63:	c3                   	ret
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102b64:	83 ec 08             	sub    $0x8,%esp
80102b67:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102b6c:	01 d8                	add    %ebx,%eax
80102b6e:	40                   	inc    %eax
80102b6f:	50                   	push   %eax
80102b70:	ff 35 e4 16 11 80    	push   0x801116e4
80102b76:	e8 39 d5 ff ff       	call   801000b4 <bread>
80102b7b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b7d:	58                   	pop    %eax
80102b7e:	5a                   	pop    %edx
80102b7f:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102b86:	ff 35 e4 16 11 80    	push   0x801116e4
80102b8c:	e8 23 d5 ff ff       	call   801000b4 <bread>
80102b91:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102b93:	83 c4 0c             	add    $0xc,%esp
80102b96:	68 00 02 00 00       	push   $0x200
80102b9b:	8d 40 5c             	lea    0x5c(%eax),%eax
80102b9e:	50                   	push   %eax
80102b9f:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ba2:	50                   	push   %eax
80102ba3:	e8 f0 18 00 00       	call   80104498 <memmove>
    bwrite(to);  // write the log
80102ba8:	89 34 24             	mov    %esi,(%esp)
80102bab:	e8 d4 d5 ff ff       	call   80100184 <bwrite>
    brelse(from);
80102bb0:	89 3c 24             	mov    %edi,(%esp)
80102bb3:	e8 04 d6 ff ff       	call   801001bc <brelse>
    brelse(to);
80102bb8:	89 34 24             	mov    %esi,(%esp)
80102bbb:	e8 fc d5 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	43                   	inc    %ebx
80102bc1:	83 c4 10             	add    $0x10,%esp
80102bc4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102bca:	7c 98                	jl     80102b64 <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102bcc:	e8 ab fd ff ff       	call   8010297c <write_head>
    install_trans(); // Now install writes to home locations
80102bd1:	e8 1a fd ff ff       	call   801028f0 <install_trans>
    log.lh.n = 0;
80102bd6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102bdd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102be0:	e8 97 fd ff ff       	call   8010297c <write_head>
80102be5:	e9 40 ff ff ff       	jmp    80102b2a <end_op+0x5e>
80102bea:	66 90                	xchg   %ax,%ax
    wakeup(&log);
80102bec:	83 ec 0c             	sub    $0xc,%esp
80102bef:	68 a0 16 11 80       	push   $0x801116a0
80102bf4:	e8 a7 12 00 00       	call   80103ea0 <wakeup>
  release(&log.lock);
80102bf9:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102c00:	e8 eb 16 00 00       	call   801042f0 <release>
80102c05:	83 c4 10             	add    $0x10,%esp
}
80102c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0b:	5b                   	pop    %ebx
80102c0c:	5e                   	pop    %esi
80102c0d:	5f                   	pop    %edi
80102c0e:	5d                   	pop    %ebp
80102c0f:	c3                   	ret
    panic("log.committing");
80102c10:	83 ec 0c             	sub    $0xc,%esp
80102c13:	68 2b 6e 10 80       	push   $0x80106e2b
80102c18:	e8 1b d7 ff ff       	call   80100338 <panic>
80102c1d:	8d 76 00             	lea    0x0(%esi),%esi

80102c20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	52                   	push   %edx
80102c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c28:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102c2e:	83 fa 1d             	cmp    $0x1d,%edx
80102c31:	7f 71                	jg     80102ca4 <log_write+0x84>
80102c33:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102c38:	48                   	dec    %eax
80102c39:	39 c2                	cmp    %eax,%edx
80102c3b:	7d 67                	jge    80102ca4 <log_write+0x84>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102c3d:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102c42:	85 c0                	test   %eax,%eax
80102c44:	7e 6b                	jle    80102cb1 <log_write+0x91>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102c46:	83 ec 0c             	sub    $0xc,%esp
80102c49:	68 a0 16 11 80       	push   $0x801116a0
80102c4e:	e8 fd 16 00 00       	call   80104350 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102c53:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102c59:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c5c:	83 c4 10             	add    $0x10,%esp
80102c5f:	31 c0                	xor    %eax,%eax
80102c61:	85 d2                	test   %edx,%edx
80102c63:	7f 08                	jg     80102c6d <log_write+0x4d>
80102c65:	eb 0f                	jmp    80102c76 <log_write+0x56>
80102c67:	90                   	nop
80102c68:	40                   	inc    %eax
80102c69:	39 d0                	cmp    %edx,%eax
80102c6b:	74 27                	je     80102c94 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102c6d:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102c74:	75 f2                	jne    80102c68 <log_write+0x48>
  log.lh.block[i] = b->blockno;
80102c76:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102c7d:	39 c2                	cmp    %eax,%edx
80102c7f:	74 1a                	je     80102c9b <log_write+0x7b>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102c81:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102c84:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c8e:	c9                   	leave
  release(&log.lock);
80102c8f:	e9 5c 16 00 00       	jmp    801042f0 <release>
  log.lh.block[i] = b->blockno;
80102c94:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102c9b:	42                   	inc    %edx
80102c9c:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102ca2:	eb dd                	jmp    80102c81 <log_write+0x61>
    panic("too big a transaction");
80102ca4:	83 ec 0c             	sub    $0xc,%esp
80102ca7:	68 3a 6e 10 80       	push   $0x80106e3a
80102cac:	e8 87 d6 ff ff       	call   80100338 <panic>
    panic("log_write outside of trans");
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	68 50 6e 10 80       	push   $0x80106e50
80102cb9:	e8 7a d6 ff ff       	call   80100338 <panic>
80102cbe:	66 90                	xchg   %ax,%ax

80102cc0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102cc5:	e8 a2 08 00 00       	call   8010356c <cpuid>
80102cca:	89 c3                	mov    %eax,%ebx
80102ccc:	e8 9b 08 00 00       	call   8010356c <cpuid>
80102cd1:	52                   	push   %edx
80102cd2:	53                   	push   %ebx
80102cd3:	50                   	push   %eax
80102cd4:	68 6b 6e 10 80       	push   $0x80106e6b
80102cd9:	e8 42 d9 ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102cde:	e8 9d 27 00 00       	call   80105480 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ce3:	e8 20 08 00 00       	call   80103508 <mycpu>
80102ce8:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102cea:	b8 01 00 00 00       	mov    $0x1,%eax
80102cef:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102cf6:	e8 95 0c 00 00       	call   80103990 <scheduler>
80102cfb:	90                   	nop

80102cfc <mpenter>:
{
80102cfc:	55                   	push   %ebp
80102cfd:	89 e5                	mov    %esp,%ebp
80102cff:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102d02:	e8 05 38 00 00       	call   8010650c <switchkvm>
  seginit();
80102d07:	e8 7c 37 00 00       	call   80106488 <seginit>
  lapicinit();
80102d0c:	e8 6f f8 ff ff       	call   80102580 <lapicinit>
  mpmain();
80102d11:	e8 aa ff ff ff       	call   80102cc0 <mpmain>
80102d16:	66 90                	xchg   %ax,%ax

80102d18 <main>:
{
80102d18:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102d1c:	83 e4 f0             	and    $0xfffffff0,%esp
80102d1f:	ff 71 fc             	push   -0x4(%ecx)
80102d22:	55                   	push   %ebp
80102d23:	89 e5                	mov    %esp,%ebp
80102d25:	53                   	push   %ebx
80102d26:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102d27:	83 ec 08             	sub    $0x8,%esp
80102d2a:	68 00 00 40 80       	push   $0x80400000
80102d2f:	68 d0 5b 11 80       	push   $0x80115bd0
80102d34:	e8 f7 f5 ff ff       	call   80102330 <kinit1>
  kvmalloc();      // kernel page table
80102d39:	e8 16 3c 00 00       	call   80106954 <kvmalloc>
  mpinit();        // detect other processors
80102d3e:	e8 61 01 00 00       	call   80102ea4 <mpinit>
  lapicinit();     // interrupt controller
80102d43:	e8 38 f8 ff ff       	call   80102580 <lapicinit>
  seginit();       // segment descriptors
80102d48:	e8 3b 37 00 00       	call   80106488 <seginit>
  picinit();       // disable pic
80102d4d:	e8 12 03 00 00       	call   80103064 <picinit>
  ioapicinit();    // another interrupt controller
80102d52:	e8 dd f3 ff ff       	call   80102134 <ioapicinit>
  consoleinit();   // console hardware
80102d57:	e8 84 dc ff ff       	call   801009e0 <consoleinit>
  uartinit();      // serial port
80102d5c:	e8 03 2a 00 00       	call   80105764 <uartinit>
  pinit();         // process table
80102d61:	e8 86 07 00 00       	call   801034ec <pinit>
  tvinit();        // trap vectors
80102d66:	e8 a9 26 00 00       	call   80105414 <tvinit>
  binit();         // buffer cache
80102d6b:	e8 c4 d2 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102d70:	e8 0f e0 ff ff       	call   80100d84 <fileinit>
  ideinit();       // disk 
80102d75:	e8 de f1 ff ff       	call   80101f58 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102d7a:	83 c4 0c             	add    $0xc,%esp
80102d7d:	68 8a 00 00 00       	push   $0x8a
80102d82:	68 8c a4 10 80       	push   $0x8010a48c
80102d87:	68 00 70 00 80       	push   $0x80007000
80102d8c:	e8 07 17 00 00       	call   80104498 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102d91:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102d97:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102d9a:	01 c0                	add    %eax,%eax
80102d9c:	01 d0                	add    %edx,%eax
80102d9e:	c1 e0 04             	shl    $0x4,%eax
80102da1:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102da6:	83 c4 10             	add    $0x10,%esp
80102da9:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80102dae:	76 74                	jbe    80102e24 <main+0x10c>
80102db0:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80102db5:	eb 20                	jmp    80102dd7 <main+0xbf>
80102db7:	90                   	nop
80102db8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102dbe:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102dc4:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102dc7:	01 c0                	add    %eax,%eax
80102dc9:	01 d0                	add    %edx,%eax
80102dcb:	c1 e0 04             	shl    $0x4,%eax
80102dce:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102dd3:	39 c3                	cmp    %eax,%ebx
80102dd5:	73 4d                	jae    80102e24 <main+0x10c>
    if(c == mycpu())  // We've started already.
80102dd7:	e8 2c 07 00 00       	call   80103508 <mycpu>
80102ddc:	39 c3                	cmp    %eax,%ebx
80102dde:	74 d8                	je     80102db8 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102de0:	e8 af f5 ff ff       	call   80102394 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102de5:	05 00 10 00 00       	add    $0x1000,%eax
80102dea:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102def:	c7 05 f8 6f 00 80 fc 	movl   $0x80102cfc,0x80006ff8
80102df6:	2c 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102df9:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e00:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102e03:	83 ec 08             	sub    $0x8,%esp
80102e06:	68 00 70 00 00       	push   $0x7000
80102e0b:	0f b6 03             	movzbl (%ebx),%eax
80102e0e:	50                   	push   %eax
80102e0f:	e8 7c f8 ff ff       	call   80102690 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e14:	83 c4 10             	add    $0x10,%esp
80102e17:	90                   	nop
80102e18:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	74 f6                	je     80102e18 <main+0x100>
80102e22:	eb 94                	jmp    80102db8 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102e24:	83 ec 08             	sub    $0x8,%esp
80102e27:	68 00 00 00 8e       	push   $0x8e000000
80102e2c:	68 00 00 40 80       	push   $0x80400000
80102e31:	e8 a6 f4 ff ff       	call   801022dc <kinit2>
  userinit();      // first user process
80102e36:	e8 89 07 00 00       	call   801035c4 <userinit>
  mpmain();        // finish this processor's setup
80102e3b:	e8 80 fe ff ff       	call   80102cc0 <mpmain>

80102e40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	57                   	push   %edi
80102e44:	56                   	push   %esi
80102e45:	53                   	push   %ebx
80102e46:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102e49:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102e4f:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102e56:	39 de                	cmp    %ebx,%esi
80102e58:	72 0b                	jb     80102e65 <mpsearch1+0x25>
80102e5a:	eb 3c                	jmp    80102e98 <mpsearch1+0x58>
80102e5c:	8d 7e 10             	lea    0x10(%esi),%edi
80102e5f:	89 fe                	mov    %edi,%esi
80102e61:	39 df                	cmp    %ebx,%edi
80102e63:	73 33                	jae    80102e98 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102e65:	50                   	push   %eax
80102e66:	6a 04                	push   $0x4
80102e68:	68 7f 6e 10 80       	push   $0x80106e7f
80102e6d:	56                   	push   %esi
80102e6e:	e8 ed 15 00 00       	call   80104460 <memcmp>
80102e73:	83 c4 10             	add    $0x10,%esp
80102e76:	85 c0                	test   %eax,%eax
80102e78:	75 e2                	jne    80102e5c <mpsearch1+0x1c>
80102e7a:	89 f2                	mov    %esi,%edx
80102e7c:	8d 7e 10             	lea    0x10(%esi),%edi
80102e7f:	90                   	nop
    sum += addr[i];
80102e80:	0f b6 0a             	movzbl (%edx),%ecx
80102e83:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102e85:	42                   	inc    %edx
80102e86:	39 fa                	cmp    %edi,%edx
80102e88:	75 f6                	jne    80102e80 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102e8a:	84 c0                	test   %al,%al
80102e8c:	75 d1                	jne    80102e5f <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102e8e:	89 f0                	mov    %esi,%eax
80102e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e93:	5b                   	pop    %ebx
80102e94:	5e                   	pop    %esi
80102e95:	5f                   	pop    %edi
80102e96:	5d                   	pop    %ebp
80102e97:	c3                   	ret
  return 0;
80102e98:	31 f6                	xor    %esi,%esi
}
80102e9a:	89 f0                	mov    %esi,%eax
80102e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e9f:	5b                   	pop    %ebx
80102ea0:	5e                   	pop    %esi
80102ea1:	5f                   	pop    %edi
80102ea2:	5d                   	pop    %ebp
80102ea3:	c3                   	ret

80102ea4 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ea4:	55                   	push   %ebp
80102ea5:	89 e5                	mov    %esp,%ebp
80102ea7:	57                   	push   %edi
80102ea8:	56                   	push   %esi
80102ea9:	53                   	push   %ebx
80102eaa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ead:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102eb4:	c1 e0 08             	shl    $0x8,%eax
80102eb7:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ebe:	09 d0                	or     %edx,%eax
80102ec0:	c1 e0 04             	shl    $0x4,%eax
80102ec3:	75 1b                	jne    80102ee0 <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102ec5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ecc:	c1 e0 08             	shl    $0x8,%eax
80102ecf:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ed6:	09 d0                	or     %edx,%eax
80102ed8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102edb:	2d 00 04 00 00       	sub    $0x400,%eax
80102ee0:	ba 00 04 00 00       	mov    $0x400,%edx
80102ee5:	e8 56 ff ff ff       	call   80102e40 <mpsearch1>
80102eea:	85 c0                	test   %eax,%eax
80102eec:	0f 84 26 01 00 00    	je     80103018 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102ef8:	8b 48 04             	mov    0x4(%eax),%ecx
80102efb:	85 c9                	test   %ecx,%ecx
80102efd:	0f 84 a5 00 00 00    	je     80102fa8 <mpinit+0x104>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f06:	8b 40 04             	mov    0x4(%eax),%eax
80102f09:	05 00 00 00 80       	add    $0x80000000,%eax
80102f0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f14:	52                   	push   %edx
80102f15:	6a 04                	push   $0x4
80102f17:	68 9c 6e 10 80       	push   $0x80106e9c
80102f1c:	50                   	push   %eax
80102f1d:	e8 3e 15 00 00       	call   80104460 <memcmp>
80102f22:	89 c2                	mov    %eax,%edx
80102f24:	83 c4 10             	add    $0x10,%esp
80102f27:	85 c0                	test   %eax,%eax
80102f29:	75 7d                	jne    80102fa8 <mpinit+0x104>
  if(conf->version != 1 && conf->version != 4)
80102f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f2e:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80102f32:	74 09                	je     80102f3d <mpinit+0x99>
80102f34:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f37:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
80102f3b:	75 6b                	jne    80102fa8 <mpinit+0x104>
  if(sum((uchar*)conf, conf->length) != 0)
80102f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f40:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
80102f47:	66 85 c9             	test   %cx,%cx
80102f4a:	74 12                	je     80102f5e <mpinit+0xba>
80102f4c:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80102f4f:	90                   	nop
    sum += addr[i];
80102f50:	0f b6 08             	movzbl (%eax),%ecx
80102f53:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102f55:	40                   	inc    %eax
80102f56:	39 d8                	cmp    %ebx,%eax
80102f58:	75 f6                	jne    80102f50 <mpinit+0xac>
  if(sum((uchar*)conf, conf->length) != 0)
80102f5a:	84 d2                	test   %dl,%dl
80102f5c:	75 4a                	jne    80102fa8 <mpinit+0x104>
  *pmp = mp;
80102f5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  return conf;
80102f61:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102f64:	85 c9                	test   %ecx,%ecx
80102f66:	74 40                	je     80102fa8 <mpinit+0x104>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102f68:	8b 41 24             	mov    0x24(%ecx),%eax
80102f6b:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102f70:	8d 41 2c             	lea    0x2c(%ecx),%eax
80102f73:	0f b7 51 04          	movzwl 0x4(%ecx),%edx
80102f77:	01 d1                	add    %edx,%ecx
80102f79:	39 c8                	cmp    %ecx,%eax
80102f7b:	72 0e                	jb     80102f8b <mpinit+0xe7>
80102f7d:	eb 49                	jmp    80102fc8 <mpinit+0x124>
80102f7f:	90                   	nop
    switch(*p){
80102f80:	84 d2                	test   %dl,%dl
80102f82:	74 64                	je     80102fe8 <mpinit+0x144>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102f84:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102f87:	39 c8                	cmp    %ecx,%eax
80102f89:	73 3d                	jae    80102fc8 <mpinit+0x124>
    switch(*p){
80102f8b:	8a 10                	mov    (%eax),%dl
80102f8d:	80 fa 02             	cmp    $0x2,%dl
80102f90:	74 26                	je     80102fb8 <mpinit+0x114>
80102f92:	76 ec                	jbe    80102f80 <mpinit+0xdc>
80102f94:	83 ea 03             	sub    $0x3,%edx
80102f97:	80 fa 01             	cmp    $0x1,%dl
80102f9a:	76 e8                	jbe    80102f84 <mpinit+0xe0>
80102f9c:	eb fe                	jmp    80102f9c <mpinit+0xf8>
80102f9e:	66 90                	xchg   %ax,%ax
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fa0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102fa7:	90                   	nop
    panic("Expect to run on an SMP");
80102fa8:	83 ec 0c             	sub    $0xc,%esp
80102fab:	68 84 6e 10 80       	push   $0x80106e84
80102fb0:	e8 83 d3 ff ff       	call   80100338 <panic>
80102fb5:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80102fb8:	8a 50 01             	mov    0x1(%eax),%dl
80102fbb:	88 15 80 17 11 80    	mov    %dl,0x80111780
      p += sizeof(struct mpioapic);
80102fc1:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fc4:	39 c8                	cmp    %ecx,%eax
80102fc6:	72 c3                	jb     80102f8b <mpinit+0xe7>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102fc8:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80102fcc:	74 12                	je     80102fe0 <mpinit+0x13c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fce:	b0 70                	mov    $0x70,%al
80102fd0:	ba 22 00 00 00       	mov    $0x22,%edx
80102fd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fd6:	ba 23 00 00 00       	mov    $0x23,%edx
80102fdb:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102fdc:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fdf:	ee                   	out    %al,(%dx)
  }
}
80102fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret
      if(ncpu < NCPU) {
80102fe8:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102fee:	83 fa 07             	cmp    $0x7,%edx
80102ff1:	7f 1a                	jg     8010300d <mpinit+0x169>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102ff3:	8d 34 92             	lea    (%edx,%edx,4),%esi
80102ff6:	01 f6                	add    %esi,%esi
80102ff8:	01 d6                	add    %edx,%esi
80102ffa:	c1 e6 04             	shl    $0x4,%esi
80102ffd:	8a 58 01             	mov    0x1(%eax),%bl
80103000:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80103006:	42                   	inc    %edx
80103007:	89 15 84 17 11 80    	mov    %edx,0x80111784
      p += sizeof(struct mpproc);
8010300d:	83 c0 14             	add    $0x14,%eax
      continue;
80103010:	e9 72 ff ff ff       	jmp    80102f87 <mpinit+0xe3>
80103015:	8d 76 00             	lea    0x0(%esi),%esi
{
80103018:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010301d:	eb 12                	jmp    80103031 <mpinit+0x18d>
8010301f:	90                   	nop
80103020:	8d 73 10             	lea    0x10(%ebx),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80103023:	89 f3                	mov    %esi,%ebx
80103025:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
8010302b:	0f 84 6f ff ff ff    	je     80102fa0 <mpinit+0xfc>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103031:	56                   	push   %esi
80103032:	6a 04                	push   $0x4
80103034:	68 7f 6e 10 80       	push   $0x80106e7f
80103039:	53                   	push   %ebx
8010303a:	e8 21 14 00 00       	call   80104460 <memcmp>
8010303f:	83 c4 10             	add    $0x10,%esp
80103042:	85 c0                	test   %eax,%eax
80103044:	75 da                	jne    80103020 <mpinit+0x17c>
80103046:	89 da                	mov    %ebx,%edx
80103048:	8d 73 10             	lea    0x10(%ebx),%esi
8010304b:	90                   	nop
    sum += addr[i];
8010304c:	0f b6 0a             	movzbl (%edx),%ecx
8010304f:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103051:	42                   	inc    %edx
80103052:	39 d6                	cmp    %edx,%esi
80103054:	75 f6                	jne    8010304c <mpinit+0x1a8>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103056:	84 c0                	test   %al,%al
80103058:	75 c9                	jne    80103023 <mpinit+0x17f>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010305a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010305d:	e9 93 fe ff ff       	jmp    80102ef5 <mpinit+0x51>
80103062:	66 90                	xchg   %ax,%ax

80103064 <picinit>:
80103064:	b0 ff                	mov    $0xff,%al
80103066:	ba 21 00 00 00       	mov    $0x21,%edx
8010306b:	ee                   	out    %al,(%dx)
8010306c:	ba a1 00 00 00       	mov    $0xa1,%edx
80103071:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103072:	c3                   	ret
80103073:	90                   	nop

80103074 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103074:	55                   	push   %ebp
80103075:	89 e5                	mov    %esp,%ebp
80103077:	57                   	push   %edi
80103078:	56                   	push   %esi
80103079:	53                   	push   %ebx
8010307a:	83 ec 0c             	sub    $0xc,%esp
8010307d:	8b 75 08             	mov    0x8(%ebp),%esi
80103080:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103083:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103089:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010308f:	e8 0c dd ff ff       	call   80100da0 <filealloc>
80103094:	89 06                	mov    %eax,(%esi)
80103096:	85 c0                	test   %eax,%eax
80103098:	0f 84 a5 00 00 00    	je     80103143 <pipealloc+0xcf>
8010309e:	e8 fd dc ff ff       	call   80100da0 <filealloc>
801030a3:	89 07                	mov    %eax,(%edi)
801030a5:	85 c0                	test   %eax,%eax
801030a7:	0f 84 84 00 00 00    	je     80103131 <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801030ad:	e8 e2 f2 ff ff       	call   80102394 <kalloc>
801030b2:	89 c3                	mov    %eax,%ebx
801030b4:	85 c0                	test   %eax,%eax
801030b6:	0f 84 a0 00 00 00    	je     8010315c <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801030bc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801030c3:	00 00 00 
  p->writeopen = 1;
801030c6:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801030cd:	00 00 00 
  p->nwrite = 0;
801030d0:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801030d7:	00 00 00 
  p->nread = 0;
801030da:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801030e1:	00 00 00 
  initlock(&p->lock, "pipe");
801030e4:	83 ec 08             	sub    $0x8,%esp
801030e7:	68 a1 6e 10 80       	push   $0x80106ea1
801030ec:	50                   	push   %eax
801030ed:	e8 96 10 00 00       	call   80104188 <initlock>
  (*f0)->type = FD_PIPE;
801030f2:	8b 06                	mov    (%esi),%eax
801030f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801030fa:	8b 06                	mov    (%esi),%eax
801030fc:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103100:	8b 06                	mov    (%esi),%eax
80103102:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103106:	8b 06                	mov    (%esi),%eax
80103108:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010310b:	8b 07                	mov    (%edi),%eax
8010310d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103113:	8b 07                	mov    (%edi),%eax
80103115:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103119:	8b 07                	mov    (%edi),%eax
8010311b:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010311f:	8b 07                	mov    (%edi),%eax
80103121:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103124:	83 c4 10             	add    $0x10,%esp
80103127:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312c:	5b                   	pop    %ebx
8010312d:	5e                   	pop    %esi
8010312e:	5f                   	pop    %edi
8010312f:	5d                   	pop    %ebp
80103130:	c3                   	ret
  if(*f0)
80103131:	8b 06                	mov    (%esi),%eax
80103133:	85 c0                	test   %eax,%eax
80103135:	74 1e                	je     80103155 <pipealloc+0xe1>
    fileclose(*f0);
80103137:	83 ec 0c             	sub    $0xc,%esp
8010313a:	50                   	push   %eax
8010313b:	e8 0c dd ff ff       	call   80100e4c <fileclose>
80103140:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103143:	8b 07                	mov    (%edi),%eax
80103145:	85 c0                	test   %eax,%eax
80103147:	74 0c                	je     80103155 <pipealloc+0xe1>
    fileclose(*f1);
80103149:	83 ec 0c             	sub    $0xc,%esp
8010314c:	50                   	push   %eax
8010314d:	e8 fa dc ff ff       	call   80100e4c <fileclose>
80103152:	83 c4 10             	add    $0x10,%esp
  return -1;
80103155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010315a:	eb cd                	jmp    80103129 <pipealloc+0xb5>
  if(*f0)
8010315c:	8b 06                	mov    (%esi),%eax
8010315e:	85 c0                	test   %eax,%eax
80103160:	75 d5                	jne    80103137 <pipealloc+0xc3>
80103162:	eb df                	jmp    80103143 <pipealloc+0xcf>

80103164 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103164:	55                   	push   %ebp
80103165:	89 e5                	mov    %esp,%ebp
80103167:	56                   	push   %esi
80103168:	53                   	push   %ebx
80103169:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010316c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010316f:	83 ec 0c             	sub    $0xc,%esp
80103172:	53                   	push   %ebx
80103173:	e8 d8 11 00 00       	call   80104350 <acquire>
  if(writable){
80103178:	83 c4 10             	add    $0x10,%esp
8010317b:	85 f6                	test   %esi,%esi
8010317d:	74 41                	je     801031c0 <pipeclose+0x5c>
    p->writeopen = 0;
8010317f:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103186:	00 00 00 
    wakeup(&p->nread);
80103189:	83 ec 0c             	sub    $0xc,%esp
8010318c:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103192:	50                   	push   %eax
80103193:	e8 08 0d 00 00       	call   80103ea0 <wakeup>
80103198:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010319b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801031a1:	85 d2                	test   %edx,%edx
801031a3:	75 0a                	jne    801031af <pipeclose+0x4b>
801031a5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801031ab:	85 c0                	test   %eax,%eax
801031ad:	74 31                	je     801031e0 <pipeclose+0x7c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801031af:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801031b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031b5:	5b                   	pop    %ebx
801031b6:	5e                   	pop    %esi
801031b7:	5d                   	pop    %ebp
    release(&p->lock);
801031b8:	e9 33 11 00 00       	jmp    801042f0 <release>
801031bd:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
801031c0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801031c7:	00 00 00 
    wakeup(&p->nwrite);
801031ca:	83 ec 0c             	sub    $0xc,%esp
801031cd:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801031d3:	50                   	push   %eax
801031d4:	e8 c7 0c 00 00       	call   80103ea0 <wakeup>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	eb bd                	jmp    8010319b <pipeclose+0x37>
801031de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801031e0:	83 ec 0c             	sub    $0xc,%esp
801031e3:	53                   	push   %ebx
801031e4:	e8 07 11 00 00       	call   801042f0 <release>
    kfree((char*)p);
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801031ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031f2:	5b                   	pop    %ebx
801031f3:	5e                   	pop    %esi
801031f4:	5d                   	pop    %ebp
    kfree((char*)p);
801031f5:	e9 0a f0 ff ff       	jmp    80102204 <kfree>
801031fa:	66 90                	xchg   %ax,%ax

801031fc <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801031fc:	55                   	push   %ebp
801031fd:	89 e5                	mov    %esp,%ebp
801031ff:	57                   	push   %edi
80103200:	56                   	push   %esi
80103201:	53                   	push   %ebx
80103202:	83 ec 28             	sub    $0x28,%esp
80103205:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103208:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010320b:	53                   	push   %ebx
8010320c:	e8 3f 11 00 00       	call   80104350 <acquire>
  for(i = 0; i < n; i++){
80103211:	83 c4 10             	add    $0x10,%esp
80103214:	85 ff                	test   %edi,%edi
80103216:	0f 8e c2 00 00 00    	jle    801032de <pipewrite+0xe2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010321c:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103225:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103228:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010322b:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103231:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103234:	89 7d 10             	mov    %edi,0x10(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103237:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010323d:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103243:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103249:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
8010324c:	0f 85 aa 00 00 00    	jne    801032fc <pipewrite+0x100>
80103252:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103255:	eb 37                	jmp    8010328e <pipewrite+0x92>
80103257:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103258:	e8 43 03 00 00       	call   801035a0 <myproc>
8010325d:	8b 48 40             	mov    0x40(%eax),%ecx
80103260:	85 c9                	test   %ecx,%ecx
80103262:	75 34                	jne    80103298 <pipewrite+0x9c>
      wakeup(&p->nread);
80103264:	83 ec 0c             	sub    $0xc,%esp
80103267:	56                   	push   %esi
80103268:	e8 33 0c 00 00       	call   80103ea0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010326d:	58                   	pop    %eax
8010326e:	5a                   	pop    %edx
8010326f:	53                   	push   %ebx
80103270:	57                   	push   %edi
80103271:	e8 56 0a 00 00       	call   80103ccc <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103276:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010327c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103282:	05 00 02 00 00       	add    $0x200,%eax
80103287:	83 c4 10             	add    $0x10,%esp
8010328a:	39 c2                	cmp    %eax,%edx
8010328c:	75 26                	jne    801032b4 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010328e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103294:	85 c0                	test   %eax,%eax
80103296:	75 c0                	jne    80103258 <pipewrite+0x5c>
        release(&p->lock);
80103298:	83 ec 0c             	sub    $0xc,%esp
8010329b:	53                   	push   %ebx
8010329c:	e8 4f 10 00 00       	call   801042f0 <release>
        return -1;
801032a1:	83 c4 10             	add    $0x10,%esp
801032a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801032a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5f                   	pop    %edi
801032af:	5d                   	pop    %ebp
801032b0:	c3                   	ret
801032b1:	8d 76 00             	lea    0x0(%esi),%esi
801032b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801032b7:	8d 42 01             	lea    0x1(%edx),%eax
801032ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032bd:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801032c3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801032c9:	8a 01                	mov    (%ecx),%al
801032cb:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801032cf:	41                   	inc    %ecx
801032d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032d3:	39 c1                	cmp    %eax,%ecx
801032d5:	0f 85 5c ff ff ff    	jne    80103237 <pipewrite+0x3b>
801032db:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801032de:	83 ec 0c             	sub    $0xc,%esp
801032e1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801032e7:	50                   	push   %eax
801032e8:	e8 b3 0b 00 00       	call   80103ea0 <wakeup>
  release(&p->lock);
801032ed:	89 1c 24             	mov    %ebx,(%esp)
801032f0:	e8 fb 0f 00 00       	call   801042f0 <release>
  return n;
801032f5:	83 c4 10             	add    $0x10,%esp
801032f8:	89 f8                	mov    %edi,%eax
801032fa:	eb ad                	jmp    801032a9 <pipewrite+0xad>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032ff:	eb b6                	jmp    801032b7 <pipewrite+0xbb>
80103301:	8d 76 00             	lea    0x0(%esi),%esi

80103304 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103304:	55                   	push   %ebp
80103305:	89 e5                	mov    %esp,%ebp
80103307:	57                   	push   %edi
80103308:	56                   	push   %esi
80103309:	53                   	push   %ebx
8010330a:	83 ec 18             	sub    $0x18,%esp
8010330d:	8b 75 08             	mov    0x8(%ebp),%esi
80103310:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103313:	56                   	push   %esi
80103314:	e8 37 10 00 00       	call   80104350 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103319:	83 c4 10             	add    $0x10,%esp
8010331c:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103322:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103328:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010332e:	74 2f                	je     8010335f <piperead+0x5b>
80103330:	eb 37                	jmp    80103369 <piperead+0x65>
80103332:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103334:	e8 67 02 00 00       	call   801035a0 <myproc>
80103339:	8b 40 40             	mov    0x40(%eax),%eax
8010333c:	85 c0                	test   %eax,%eax
8010333e:	0f 85 80 00 00 00    	jne    801033c4 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103344:	83 ec 08             	sub    $0x8,%esp
80103347:	56                   	push   %esi
80103348:	53                   	push   %ebx
80103349:	e8 7e 09 00 00       	call   80103ccc <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010334e:	83 c4 10             	add    $0x10,%esp
80103351:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103357:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010335d:	75 0a                	jne    80103369 <piperead+0x65>
8010335f:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103365:	85 d2                	test   %edx,%edx
80103367:	75 cb                	jne    80103334 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103369:	31 db                	xor    %ebx,%ebx
8010336b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010336e:	85 c9                	test   %ecx,%ecx
80103370:	7f 23                	jg     80103395 <piperead+0x91>
80103372:	eb 29                	jmp    8010339d <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103374:	8d 48 01             	lea    0x1(%eax),%ecx
80103377:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010337d:	25 ff 01 00 00       	and    $0x1ff,%eax
80103382:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
80103386:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103389:	43                   	inc    %ebx
8010338a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010338d:	74 0e                	je     8010339d <piperead+0x99>
8010338f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103395:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010339b:	75 d7                	jne    80103374 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010339d:	83 ec 0c             	sub    $0xc,%esp
801033a0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801033a6:	50                   	push   %eax
801033a7:	e8 f4 0a 00 00       	call   80103ea0 <wakeup>
  release(&p->lock);
801033ac:	89 34 24             	mov    %esi,(%esp)
801033af:	e8 3c 0f 00 00       	call   801042f0 <release>
  return i;
801033b4:	83 c4 10             	add    $0x10,%esp
}
801033b7:	89 d8                	mov    %ebx,%eax
801033b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bc:	5b                   	pop    %ebx
801033bd:	5e                   	pop    %esi
801033be:	5f                   	pop    %edi
801033bf:	5d                   	pop    %ebp
801033c0:	c3                   	ret
801033c1:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
801033c4:	83 ec 0c             	sub    $0xc,%esp
801033c7:	56                   	push   %esi
801033c8:	e8 23 0f 00 00       	call   801042f0 <release>
      return -1;
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801033d5:	89 d8                	mov    %ebx,%eax
801033d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033da:	5b                   	pop    %ebx
801033db:	5e                   	pop    %esi
801033dc:	5f                   	pop    %edi
801033dd:	5d                   	pop    %ebp
801033de:	c3                   	ret
801033df:	90                   	nop

801033e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	53                   	push   %ebx
801033e4:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801033e7:	68 20 1d 11 80       	push   $0x80111d20
801033ec:	e8 5f 0f 00 00       	call   80104350 <acquire>
801033f1:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801033f4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801033f9:	eb 0f                	jmp    8010340a <allocproc+0x2a>
801033fb:	90                   	nop
801033fc:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103402:	81 fb 54 43 11 80    	cmp    $0x80114354,%ebx
80103408:	74 76                	je     80103480 <allocproc+0xa0>
    if(p->state == UNUSED)
8010340a:	8b 4b 28             	mov    0x28(%ebx),%ecx
8010340d:	85 c9                	test   %ecx,%ecx
8010340f:	75 eb                	jne    801033fc <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103411:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  p->pid = nextpid++;
80103418:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010341d:	8d 50 01             	lea    0x1(%eax),%edx
80103420:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103426:	89 43 2c             	mov    %eax,0x2c(%ebx)

  release(&ptable.lock);
80103429:	83 ec 0c             	sub    $0xc,%esp
8010342c:	68 20 1d 11 80       	push   $0x80111d20
80103431:	e8 ba 0e 00 00       	call   801042f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103436:	e8 59 ef ff ff       	call   80102394 <kalloc>
8010343b:	89 43 24             	mov    %eax,0x24(%ebx)
8010343e:	83 c4 10             	add    $0x10,%esp
80103441:	85 c0                	test   %eax,%eax
80103443:	74 54                	je     80103499 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103445:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
8010344b:	89 53 34             	mov    %edx,0x34(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010344e:	c7 80 b0 0f 00 00 06 	movl   $0x80105406,0xfb0(%eax)
80103455:	54 10 80 

  sp -= sizeof *p->context;
80103458:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010345d:	89 43 38             	mov    %eax,0x38(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103460:	52                   	push   %edx
80103461:	6a 14                	push   $0x14
80103463:	6a 00                	push   $0x0
80103465:	50                   	push   %eax
80103466:	e8 b1 0f 00 00       	call   8010441c <memset>
  p->context->eip = (uint)forkret;
8010346b:	8b 43 38             	mov    0x38(%ebx),%eax
8010346e:	c7 40 10 a4 34 10 80 	movl   $0x801034a4,0x10(%eax)

  return p;
80103475:	83 c4 10             	add    $0x10,%esp
}
80103478:	89 d8                	mov    %ebx,%eax
8010347a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010347d:	c9                   	leave
8010347e:	c3                   	ret
8010347f:	90                   	nop
  release(&ptable.lock);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	68 20 1d 11 80       	push   $0x80111d20
80103488:	e8 63 0e 00 00       	call   801042f0 <release>
  return 0;
8010348d:	83 c4 10             	add    $0x10,%esp
80103490:	31 db                	xor    %ebx,%ebx
}
80103492:	89 d8                	mov    %ebx,%eax
80103494:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103497:	c9                   	leave
80103498:	c3                   	ret
    p->state = UNUSED;
80103499:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
  return 0;
801034a0:	31 db                	xor    %ebx,%ebx
801034a2:	eb ee                	jmp    80103492 <allocproc+0xb2>

801034a4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801034a4:	55                   	push   %ebp
801034a5:	89 e5                	mov    %esp,%ebp
801034a7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801034aa:	68 20 1d 11 80       	push   $0x80111d20
801034af:	e8 3c 0e 00 00       	call   801042f0 <release>

  if (first) {
801034b4:	83 c4 10             	add    $0x10,%esp
801034b7:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801034bc:	85 c0                	test   %eax,%eax
801034be:	75 04                	jne    801034c4 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801034c0:	c9                   	leave
801034c1:	c3                   	ret
801034c2:	66 90                	xchg   %ax,%ax
    first = 0;
801034c4:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801034cb:	00 00 00 
    iinit(ROOTDEV);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	6a 01                	push   $0x1
801034d3:	e8 48 df ff ff       	call   80101420 <iinit>
    initlog(ROOTDEV);
801034d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801034df:	e8 f0 f4 ff ff       	call   801029d4 <initlog>
}
801034e4:	83 c4 10             	add    $0x10,%esp
801034e7:	c9                   	leave
801034e8:	c3                   	ret
801034e9:	8d 76 00             	lea    0x0(%esi),%esi

801034ec <pinit>:
{
801034ec:	55                   	push   %ebp
801034ed:	89 e5                	mov    %esp,%ebp
801034ef:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801034f2:	68 a6 6e 10 80       	push   $0x80106ea6
801034f7:	68 20 1d 11 80       	push   $0x80111d20
801034fc:	e8 87 0c 00 00       	call   80104188 <initlock>
}
80103501:	83 c4 10             	add    $0x10,%esp
80103504:	c9                   	leave
80103505:	c3                   	ret
80103506:	66 90                	xchg   %ax,%ax

80103508 <mycpu>:
{
80103508:	55                   	push   %ebp
80103509:	89 e5                	mov    %esp,%ebp
8010350b:	56                   	push   %esi
8010350c:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010350d:	9c                   	pushf
8010350e:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010350f:	f6 c4 02             	test   $0x2,%ah
80103512:	75 4b                	jne    8010355f <mycpu+0x57>
  apicid = lapicid();
80103514:	e8 47 f1 ff ff       	call   80102660 <lapicid>
80103519:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
8010351b:	8b 1d 84 17 11 80    	mov    0x80111784,%ebx
80103521:	85 db                	test   %ebx,%ebx
80103523:	7e 2d                	jle    80103552 <mycpu+0x4a>
80103525:	31 d2                	xor    %edx,%edx
80103527:	eb 08                	jmp    80103531 <mycpu+0x29>
80103529:	8d 76 00             	lea    0x0(%esi),%esi
8010352c:	42                   	inc    %edx
8010352d:	39 da                	cmp    %ebx,%edx
8010352f:	74 21                	je     80103552 <mycpu+0x4a>
    if (cpus[i].apicid == apicid)
80103531:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103534:	01 c0                	add    %eax,%eax
80103536:	01 d0                	add    %edx,%eax
80103538:	c1 e0 04             	shl    $0x4,%eax
8010353b:	0f b6 b0 a0 17 11 80 	movzbl -0x7feee860(%eax),%esi
80103542:	39 ce                	cmp    %ecx,%esi
80103544:	75 e6                	jne    8010352c <mycpu+0x24>
      return &cpus[i];
80103546:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
8010354b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010354e:	5b                   	pop    %ebx
8010354f:	5e                   	pop    %esi
80103550:	5d                   	pop    %ebp
80103551:	c3                   	ret
  panic("unknown apicid\n");
80103552:	83 ec 0c             	sub    $0xc,%esp
80103555:	68 ad 6e 10 80       	push   $0x80106ead
8010355a:	e8 d9 cd ff ff       	call   80100338 <panic>
    panic("mycpu called with interrupts enabled\n");
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	68 00 72 10 80       	push   $0x80107200
80103567:	e8 cc cd ff ff       	call   80100338 <panic>

8010356c <cpuid>:
cpuid() {
8010356c:	55                   	push   %ebp
8010356d:	89 e5                	mov    %esp,%ebp
8010356f:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103572:	e8 91 ff ff ff       	call   80103508 <mycpu>
80103577:	2d a0 17 11 80       	sub    $0x801117a0,%eax
8010357c:	c1 f8 04             	sar    $0x4,%eax
8010357f:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103582:	89 ca                	mov    %ecx,%edx
80103584:	c1 e2 05             	shl    $0x5,%edx
80103587:	29 ca                	sub    %ecx,%edx
80103589:	8d 14 90             	lea    (%eax,%edx,4),%edx
8010358c:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010358f:	89 ca                	mov    %ecx,%edx
80103591:	c1 e2 0f             	shl    $0xf,%edx
80103594:	29 ca                	sub    %ecx,%edx
80103596:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103599:	f7 d8                	neg    %eax
}
8010359b:	c9                   	leave
8010359c:	c3                   	ret
8010359d:	8d 76 00             	lea    0x0(%esi),%esi

801035a0 <myproc>:
myproc(void) {
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
801035a4:	50                   	push   %eax
  pushcli();
801035a5:	e8 62 0c 00 00       	call   8010420c <pushcli>
  c = mycpu();
801035aa:	e8 59 ff ff ff       	call   80103508 <mycpu>
  p = c->proc;
801035af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801035b5:	e8 9e 0c 00 00       	call   80104258 <popcli>
}
801035ba:	89 d8                	mov    %ebx,%eax
801035bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035bf:	c9                   	leave
801035c0:	c3                   	ret
801035c1:	8d 76 00             	lea    0x0(%esi),%esi

801035c4 <userinit>:
{
801035c4:	55                   	push   %ebp
801035c5:	89 e5                	mov    %esp,%ebp
801035c7:	53                   	push   %ebx
801035c8:	51                   	push   %ecx
  p = allocproc();
801035c9:	e8 12 fe ff ff       	call   801033e0 <allocproc>
801035ce:	89 c3                	mov    %eax,%ebx
  initproc = p;
801035d0:	a3 54 43 11 80       	mov    %eax,0x80114354
  if((p->pgdir = setupkvm()) == 0)
801035d5:	e8 0a 33 00 00       	call   801068e4 <setupkvm>
801035da:	89 43 20             	mov    %eax,0x20(%ebx)
801035dd:	85 c0                	test   %eax,%eax
801035df:	0f 84 b9 00 00 00    	je     8010369e <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801035e5:	52                   	push   %edx
801035e6:	68 2c 00 00 00       	push   $0x2c
801035eb:	68 60 a4 10 80       	push   $0x8010a460
801035f0:	50                   	push   %eax
801035f1:	e8 22 30 00 00       	call   80106618 <inituvm>
  p->sz = PGSIZE;
801035f6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801035fc:	83 c4 0c             	add    $0xc,%esp
801035ff:	6a 4c                	push   $0x4c
80103601:	6a 00                	push   $0x0
80103603:	ff 73 34             	push   0x34(%ebx)
80103606:	e8 11 0e 00 00       	call   8010441c <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010360b:	8b 43 34             	mov    0x34(%ebx),%eax
8010360e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103614:	8b 43 34             	mov    0x34(%ebx),%eax
80103617:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010361d:	8b 43 34             	mov    0x34(%ebx),%eax
80103620:	8b 50 2c             	mov    0x2c(%eax),%edx
80103623:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103627:	8b 43 34             	mov    0x34(%ebx),%eax
8010362a:	8b 50 2c             	mov    0x2c(%eax),%edx
8010362d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103631:	8b 43 34             	mov    0x34(%ebx),%eax
80103634:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010363b:	8b 43 34             	mov    0x34(%ebx),%eax
8010363e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103645:	8b 43 34             	mov    0x34(%ebx),%eax
80103648:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010364f:	83 c4 0c             	add    $0xc,%esp
80103652:	6a 10                	push   $0x10
80103654:	68 d6 6e 10 80       	push   $0x80106ed6
80103659:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
8010365f:	50                   	push   %eax
80103660:	e8 ff 0e 00 00       	call   80104564 <safestrcpy>
  p->cwd = namei("/");
80103665:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
8010366c:	e8 03 e8 ff ff       	call   80101e74 <namei>
80103671:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  acquire(&ptable.lock);
80103677:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010367e:	e8 cd 0c 00 00       	call   80104350 <acquire>
  p->state = RUNNABLE;
80103683:	c7 43 28 03 00 00 00 	movl   $0x3,0x28(%ebx)
  release(&ptable.lock);
8010368a:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103691:	e8 5a 0c 00 00       	call   801042f0 <release>
}
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010369c:	c9                   	leave
8010369d:	c3                   	ret
    panic("userinit: out of memory?");
8010369e:	83 ec 0c             	sub    $0xc,%esp
801036a1:	68 bd 6e 10 80       	push   $0x80106ebd
801036a6:	e8 8d cc ff ff       	call   80100338 <panic>
801036ab:	90                   	nop

801036ac <growproc>:
{
801036ac:	55                   	push   %ebp
801036ad:	89 e5                	mov    %esp,%ebp
801036af:	56                   	push   %esi
801036b0:	53                   	push   %ebx
801036b1:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801036b4:	e8 53 0b 00 00       	call   8010420c <pushcli>
  c = mycpu();
801036b9:	e8 4a fe ff ff       	call   80103508 <mycpu>
  p = c->proc;
801036be:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036c4:	e8 8f 0b 00 00       	call   80104258 <popcli>
  sz = curproc->sz;
801036c9:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801036cb:	85 f6                	test   %esi,%esi
801036cd:	7f 19                	jg     801036e8 <growproc+0x3c>
  } else if(n < 0){
801036cf:	75 33                	jne    80103704 <growproc+0x58>
  curproc->sz = sz;
801036d1:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	53                   	push   %ebx
801036d7:	e8 40 2e 00 00       	call   8010651c <switchuvm>
  return 0;
801036dc:	83 c4 10             	add    $0x10,%esp
801036df:	31 c0                	xor    %eax,%eax
}
801036e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036e4:	5b                   	pop    %ebx
801036e5:	5e                   	pop    %esi
801036e6:	5d                   	pop    %ebp
801036e7:	c3                   	ret
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801036e8:	51                   	push   %ecx
801036e9:	01 c6                	add    %eax,%esi
801036eb:	56                   	push   %esi
801036ec:	50                   	push   %eax
801036ed:	ff 73 20             	push   0x20(%ebx)
801036f0:	e8 5b 30 00 00       	call   80106750 <allocuvm>
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	75 d5                	jne    801036d1 <growproc+0x25>
      return -1;
801036fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103701:	eb de                	jmp    801036e1 <growproc+0x35>
80103703:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103704:	52                   	push   %edx
80103705:	01 c6                	add    %eax,%esi
80103707:	56                   	push   %esi
80103708:	50                   	push   %eax
80103709:	ff 73 20             	push   0x20(%ebx)
8010370c:	e8 47 31 00 00       	call   80106858 <deallocuvm>
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	85 c0                	test   %eax,%eax
80103716:	75 b9                	jne    801036d1 <growproc+0x25>
80103718:	eb e2                	jmp    801036fc <growproc+0x50>
8010371a:	66 90                	xchg   %ax,%ax

8010371c <fork>:
{
8010371c:	55                   	push   %ebp
8010371d:	89 e5                	mov    %esp,%ebp
8010371f:	57                   	push   %edi
80103720:	56                   	push   %esi
80103721:	53                   	push   %ebx
80103722:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103725:	e8 e2 0a 00 00       	call   8010420c <pushcli>
  c = mycpu();
8010372a:	e8 d9 fd ff ff       	call   80103508 <mycpu>
  p = c->proc;
8010372f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103735:	e8 1e 0b 00 00       	call   80104258 <popcli>
  if((np = allocproc()) == 0){
8010373a:	e8 a1 fc ff ff       	call   801033e0 <allocproc>
8010373f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103742:	85 c0                	test   %eax,%eax
80103744:	0f 84 e0 00 00 00    	je     8010382a <fork+0x10e>
8010374a:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010374c:	83 ec 08             	sub    $0x8,%esp
8010374f:	ff 33                	push   (%ebx)
80103751:	ff 73 20             	push   0x20(%ebx)
80103754:	e8 5f 32 00 00       	call   801069b8 <copyuvm>
80103759:	89 47 20             	mov    %eax,0x20(%edi)
8010375c:	83 c4 10             	add    $0x10,%esp
8010375f:	85 c0                	test   %eax,%eax
80103761:	0f 84 a4 00 00 00    	je     8010380b <fork+0xef>
  np->sz = curproc->sz;
80103767:	8b 03                	mov    (%ebx),%eax
80103769:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010376c:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010376e:	89 c8                	mov    %ecx,%eax
80103770:	89 59 30             	mov    %ebx,0x30(%ecx)
  *np->tf = *curproc->tf;
80103773:	8b 73 34             	mov    0x34(%ebx),%esi
80103776:	8b 79 34             	mov    0x34(%ecx),%edi
80103779:	b9 13 00 00 00       	mov    $0x13,%ecx
8010377e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103780:	8b 40 34             	mov    0x34(%eax),%eax
80103783:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010378a:	31 f6                	xor    %esi,%esi
    if(curproc->ofile[i])
8010378c:	8b 44 b3 44          	mov    0x44(%ebx,%esi,4),%eax
80103790:	85 c0                	test   %eax,%eax
80103792:	74 13                	je     801037a7 <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103794:	83 ec 0c             	sub    $0xc,%esp
80103797:	50                   	push   %eax
80103798:	e8 6b d6 ff ff       	call   80100e08 <filedup>
8010379d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801037a0:	89 44 b2 44          	mov    %eax,0x44(%edx,%esi,4)
801037a4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801037a7:	46                   	inc    %esi
801037a8:	83 fe 10             	cmp    $0x10,%esi
801037ab:	75 df                	jne    8010378c <fork+0x70>
  np->cwd = idup(curproc->cwd);
801037ad:	83 ec 0c             	sub    $0xc,%esp
801037b0:	ff b3 84 00 00 00    	push   0x84(%ebx)
801037b6:	e8 39 de ff ff       	call   801015f4 <idup>
801037bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801037be:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801037c4:	83 c4 0c             	add    $0xc,%esp
801037c7:	6a 10                	push   $0x10
801037c9:	81 c3 88 00 00 00    	add    $0x88,%ebx
801037cf:	53                   	push   %ebx
801037d0:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
801037d6:	50                   	push   %eax
801037d7:	e8 88 0d 00 00       	call   80104564 <safestrcpy>
  pid = np->pid;
801037dc:	8b 5f 2c             	mov    0x2c(%edi),%ebx
  acquire(&ptable.lock);
801037df:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801037e6:	e8 65 0b 00 00       	call   80104350 <acquire>
  np->state = RUNNABLE;
801037eb:	c7 47 28 03 00 00 00 	movl   $0x3,0x28(%edi)
  release(&ptable.lock);
801037f2:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801037f9:	e8 f2 0a 00 00       	call   801042f0 <release>
  return pid;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	89 d8                	mov    %ebx,%eax
80103803:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret
    kfree(np->kstack);
8010380b:	83 ec 0c             	sub    $0xc,%esp
8010380e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103811:	ff 73 24             	push   0x24(%ebx)
80103814:	e8 eb e9 ff ff       	call   80102204 <kfree>
    np->kstack = 0;
80103819:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    np->state = UNUSED;
80103820:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    return -1;
80103827:	83 c4 10             	add    $0x10,%esp
    return -1;
8010382a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010382f:	eb d0                	jmp    80103801 <fork+0xe5>
80103831:	8d 76 00             	lea    0x0(%esi),%esi

80103834 <send_signal_to_all>:
void send_signal_to_all(int sig){
80103834:	55                   	push   %ebp
80103835:	89 e5                	mov    %esp,%ebp
80103837:	56                   	push   %esi
80103838:	53                   	push   %ebx
80103839:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
8010383c:	83 ec 0c             	sub    $0xc,%esp
8010383f:	68 20 1d 11 80       	push   $0x80111d20
80103844:	e8 07 0b 00 00       	call   80104350 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103849:	bb dc 1d 11 80       	mov    $0x80111ddc,%ebx
8010384e:	83 c4 10             	add    $0x10,%esp
80103851:	eb 53                	jmp    801038a6 <send_signal_to_all+0x72>
80103853:	90                   	nop
         if(p->state == UNUSED) continue;
80103854:	8b 53 a0             	mov    -0x60(%ebx),%edx
80103857:	85 d2                	test   %edx,%edx
80103859:	74 3d                	je     80103898 <send_signal_to_all+0x64>
         cprintf("SIG %d to pid=%d name=%s state=%d\n", sig, p->pid, p->name, p->state);
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	52                   	push   %edx
8010385f:	53                   	push   %ebx
80103860:	50                   	push   %eax
80103861:	56                   	push   %esi
80103862:	68 28 72 10 80       	push   $0x80107228
80103867:	e8 b4 cd ff ff       	call   80100620 <cprintf>
          switch(sig) {
8010386c:	83 c4 20             	add    $0x20,%esp
8010386f:	83 fe 03             	cmp    $0x3,%esi
80103872:	0f 84 98 00 00 00    	je     80103910 <send_signal_to_all+0xdc>
80103878:	7f 72                	jg     801038ec <send_signal_to_all+0xb8>
8010387a:	83 fe 01             	cmp    $0x1,%esi
8010387d:	0f 84 b9 00 00 00    	je     8010393c <send_signal_to_all+0x108>
80103883:	83 fe 02             	cmp    $0x2,%esi
80103886:	75 10                	jne    80103898 <send_signal_to_all+0x64>
                  if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING){
80103888:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010388b:	83 e8 02             	sub    $0x2,%eax
8010388e:	83 f8 02             	cmp    $0x2,%eax
80103891:	0f 86 d1 00 00 00    	jbe    80103968 <send_signal_to_all+0x134>
80103897:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103898:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010389e:	81 fb dc 43 11 80    	cmp    $0x801143dc,%ebx
801038a4:	74 34                	je     801038da <send_signal_to_all+0xa6>
         if (p->pid == 1 || p->pid == 2) 
801038a6:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801038a9:	8d 50 ff             	lea    -0x1(%eax),%edx
801038ac:	83 fa 01             	cmp    $0x1,%edx
801038af:	77 a3                	ja     80103854 <send_signal_to_all+0x20>
                 if(p->pid==2 && sig==SIGBG)
801038b1:	83 f8 02             	cmp    $0x2,%eax
801038b4:	75 e2                	jne    80103898 <send_signal_to_all+0x64>
801038b6:	83 fe 02             	cmp    $0x2,%esi
801038b9:	75 dd                	jne    80103898 <send_signal_to_all+0x64>
                      p->control_flag=1;
801038bb:	c7 83 7c ff ff ff 01 	movl   $0x1,-0x84(%ebx)
801038c2:	00 00 00 
                      p->state=RUNNABLE ;
801038c5:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038cc:	81 c3 98 00 00 00    	add    $0x98,%ebx
801038d2:	81 fb dc 43 11 80    	cmp    $0x801143dc,%ebx
801038d8:	75 cc                	jne    801038a6 <send_signal_to_all+0x72>
    release(&ptable.lock);
801038da:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
801038e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e4:	5b                   	pop    %ebx
801038e5:	5e                   	pop    %esi
801038e6:	5d                   	pop    %ebp
    release(&ptable.lock);
801038e7:	e9 04 0a 00 00       	jmp    801042f0 <release>
          switch(sig) {
801038ec:	83 fe 04             	cmp    $0x4,%esi
801038ef:	75 a7                	jne    80103898 <send_signal_to_all+0x64>
                 if(p->signal_handler){
801038f1:	8b 43 84             	mov    -0x7c(%ebx),%eax
801038f4:	85 c0                	test   %eax,%eax
801038f6:	74 a0                	je     80103898 <send_signal_to_all+0x64>
                     p->pending_signal = SIGCUSTOM;
801038f8:	c7 43 80 04 00 00 00 	movl   $0x4,-0x80(%ebx)
                     if(p->state == SLEEPING)
801038ff:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103903:	75 93                	jne    80103898 <send_signal_to_all+0x64>
                        p->state = RUNNABLE;
80103905:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
8010390c:	eb 8a                	jmp    80103898 <send_signal_to_all+0x64>
8010390e:	66 90                	xchg   %ax,%ax
                  if(p->state == SUSPENDED)
80103910:	83 7b a0 07          	cmpl   $0x7,-0x60(%ebx)
80103914:	75 82                	jne    80103898 <send_signal_to_all+0x64>
                     p->suspended = 0;  
80103916:	c7 43 88 00 00 00 00 	movl   $0x0,-0x78(%ebx)
                    cprintf(" -> Resumed pid=%d name=%s state=%d\n", p->pid, p->name,p->state);  
8010391d:	6a 07                	push   $0x7
8010391f:	53                   	push   %ebx
80103920:	ff 73 a4             	push   -0x5c(%ebx)
80103923:	68 94 72 10 80       	push   $0x80107294
80103928:	e8 f3 cc ff ff       	call   80100620 <cprintf>
                    p->state = RUNNABLE;  // resume suspended process
8010392d:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
80103934:	83 c4 10             	add    $0x10,%esp
80103937:	e9 5c ff ff ff       	jmp    80103898 <send_signal_to_all+0x64>
                p->killed = 1;   // terminate the process
8010393c:	c7 43 b8 01 00 00 00 	movl   $0x1,-0x48(%ebx)
                if(p->state == SLEEPING)
80103943:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103947:	75 07                	jne    80103950 <send_signal_to_all+0x11c>
                    p->state = RUNNABLE; // explicitly wake up to terminate
80103949:	c7 43 a0 03 00 00 00 	movl   $0x3,-0x60(%ebx)
                cprintf(" -> Terminatedc pid=%d name=%s\n", p->pid, p->name);    
80103950:	52                   	push   %edx
80103951:	53                   	push   %ebx
80103952:	ff 73 a4             	push   -0x5c(%ebx)
80103955:	68 4c 72 10 80       	push   $0x8010724c
8010395a:	e8 c1 cc ff ff       	call   80100620 <cprintf>
                break;
8010395f:	83 c4 10             	add    $0x10,%esp
80103962:	e9 31 ff ff ff       	jmp    80103898 <send_signal_to_all+0x64>
80103967:	90                   	nop
                      p->state = SUSPENDED;
80103968:	c7 43 a0 07 00 00 00 	movl   $0x7,-0x60(%ebx)
                      p->suspended = 1;
8010396f:	c7 43 88 01 00 00 00 	movl   $0x1,-0x78(%ebx)
                      cprintf(" -> Suspended pid=%d name=%s state=%d\n", p->pid, p->name,p->state);
80103976:	6a 07                	push   $0x7
80103978:	53                   	push   %ebx
80103979:	ff 73 a4             	push   -0x5c(%ebx)
8010397c:	68 6c 72 10 80       	push   $0x8010726c
80103981:	e8 9a cc ff ff       	call   80100620 <cprintf>
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	e9 0a ff ff ff       	jmp    80103898 <send_signal_to_all+0x64>
8010398e:	66 90                	xchg   %ax,%ax

80103990 <scheduler>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103999:	e8 6a fb ff ff       	call   80103508 <mycpu>
8010399e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039a0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039a7:	00 00 00 
801039aa:	8d 78 04             	lea    0x4(%eax),%edi
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039b0:	fb                   	sti
    acquire(&ptable.lock);
801039b1:	83 ec 0c             	sub    $0xc,%esp
801039b4:	68 20 1d 11 80       	push   $0x80111d20
801039b9:	e8 92 09 00 00       	call   80104350 <acquire>
801039be:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c1:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801039c6:	eb 0e                	jmp    801039d6 <scheduler+0x46>
801039c8:	81 c3 98 00 00 00    	add    $0x98,%ebx
801039ce:	81 fb 54 43 11 80    	cmp    $0x80114354,%ebx
801039d4:	74 6e                	je     80103a44 <scheduler+0xb4>
      if(p->state != RUNNABLE || p->suspended )
801039d6:	83 7b 28 03          	cmpl   $0x3,0x28(%ebx)
801039da:	75 ec                	jne    801039c8 <scheduler+0x38>
801039dc:	8b 4b 10             	mov    0x10(%ebx),%ecx
801039df:	85 c9                	test   %ecx,%ecx
801039e1:	75 e5                	jne    801039c8 <scheduler+0x38>
      if(p->pending_signal == SIGINT){
801039e3:	8b 43 08             	mov    0x8(%ebx),%eax
801039e6:	83 f8 01             	cmp    $0x1,%eax
801039e9:	0f 84 91 00 00 00    	je     80103a80 <scheduler+0xf0>
      else if(p->pending_signal == SIGBG){
801039ef:	83 f8 02             	cmp    $0x2,%eax
801039f2:	0f 84 9c 00 00 00    	je     80103a94 <scheduler+0x104>
      else if(p->pending_signal == SIGFG){
801039f8:	83 f8 03             	cmp    $0x3,%eax
801039fb:	74 7a                	je     80103a77 <scheduler+0xe7>
      else if(p->pending_signal == SIGCUSTOM){
801039fd:	83 f8 04             	cmp    $0x4,%eax
80103a00:	74 5a                	je     80103a5c <scheduler+0xcc>
      c->proc = p;
80103a02:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	53                   	push   %ebx
80103a0c:	e8 0b 2b 00 00       	call   8010651c <switchuvm>
      p->state = RUNNING;
80103a11:	c7 43 28 04 00 00 00 	movl   $0x4,0x28(%ebx)
      swtch(&(c->scheduler), p->context);
80103a18:	58                   	pop    %eax
80103a19:	5a                   	pop    %edx
80103a1a:	ff 73 38             	push   0x38(%ebx)
80103a1d:	57                   	push   %edi
80103a1e:	e8 8e 0b 00 00       	call   801045b1 <swtch>
      switchkvm();
80103a23:	e8 e4 2a 00 00       	call   8010650c <switchkvm>
      c->proc = 0;
80103a28:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a2f:	00 00 00 
80103a32:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a35:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103a3b:	81 fb 54 43 11 80    	cmp    $0x80114354,%ebx
80103a41:	75 93                	jne    801039d6 <scheduler+0x46>
80103a43:	90                   	nop
    release(&ptable.lock);
80103a44:	83 ec 0c             	sub    $0xc,%esp
80103a47:	68 20 1d 11 80       	push   $0x80111d20
80103a4c:	e8 9f 08 00 00       	call   801042f0 <release>
    sti();
80103a51:	83 c4 10             	add    $0x10,%esp
80103a54:	e9 57 ff ff ff       	jmp    801039b0 <scheduler+0x20>
80103a59:	8d 76 00             	lea    0x0(%esi),%esi
        p->tf->eip = (uint)p->signal_handler;
80103a5c:	8b 43 34             	mov    0x34(%ebx),%eax
80103a5f:	8b 53 0c             	mov    0xc(%ebx),%edx
80103a62:	89 50 38             	mov    %edx,0x38(%eax)
        p->tf->esp -= 4;
80103a65:	8b 43 34             	mov    0x34(%ebx),%eax
80103a68:	83 68 44 04          	subl   $0x4,0x44(%eax)
        *(uint*)p->tf->esp = p->tf->eip;
80103a6c:	8b 43 34             	mov    0x34(%ebx),%eax
80103a6f:	8b 50 38             	mov    0x38(%eax),%edx
80103a72:	8b 40 44             	mov    0x44(%eax),%eax
80103a75:	89 10                	mov    %edx,(%eax)
        p->pending_signal = 0;
80103a77:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103a7e:	eb 82                	jmp    80103a02 <scheduler+0x72>
        p->killed = 1; 
80103a80:	c7 43 40 01 00 00 00 	movl   $0x1,0x40(%ebx)
        p->pending_signal = 0;
80103a87:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        continue; // Process killed
80103a8e:	e9 35 ff ff ff       	jmp    801039c8 <scheduler+0x38>
80103a93:	90                   	nop
        p->state = SUSPENDED; 
80103a94:	c7 43 28 07 00 00 00 	movl   $0x7,0x28(%ebx)
        p->pending_signal = 1;
80103a9b:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
        continue; // Process suspended
80103aa2:	e9 21 ff ff ff       	jmp    801039c8 <scheduler+0x38>
80103aa7:	90                   	nop

80103aa8 <sched>:
{
80103aa8:	55                   	push   %ebp
80103aa9:	89 e5                	mov    %esp,%ebp
80103aab:	56                   	push   %esi
80103aac:	53                   	push   %ebx
  pushcli();
80103aad:	e8 5a 07 00 00       	call   8010420c <pushcli>
  c = mycpu();
80103ab2:	e8 51 fa ff ff       	call   80103508 <mycpu>
  p = c->proc;
80103ab7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103abd:	e8 96 07 00 00       	call   80104258 <popcli>
  if(!holding(&ptable.lock))
80103ac2:	83 ec 0c             	sub    $0xc,%esp
80103ac5:	68 20 1d 11 80       	push   $0x80111d20
80103aca:	e8 e1 07 00 00       	call   801042b0 <holding>
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	74 4f                	je     80103b25 <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ad6:	e8 2d fa ff ff       	call   80103508 <mycpu>
80103adb:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ae2:	75 68                	jne    80103b4c <sched+0xa4>
  if(p->state == RUNNING)
80103ae4:	83 7b 28 04          	cmpl   $0x4,0x28(%ebx)
80103ae8:	74 55                	je     80103b3f <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aea:	9c                   	pushf
80103aeb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aec:	f6 c4 02             	test   $0x2,%ah
80103aef:	75 41                	jne    80103b32 <sched+0x8a>
  intena = mycpu()->intena;
80103af1:	e8 12 fa ff ff       	call   80103508 <mycpu>
80103af6:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103afc:	e8 07 fa ff ff       	call   80103508 <mycpu>
80103b01:	83 ec 08             	sub    $0x8,%esp
80103b04:	ff 70 04             	push   0x4(%eax)
80103b07:	83 c3 38             	add    $0x38,%ebx
80103b0a:	53                   	push   %ebx
80103b0b:	e8 a1 0a 00 00       	call   801045b1 <swtch>
  mycpu()->intena = intena;
80103b10:	e8 f3 f9 ff ff       	call   80103508 <mycpu>
80103b15:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b1b:	83 c4 10             	add    $0x10,%esp
80103b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b21:	5b                   	pop    %ebx
80103b22:	5e                   	pop    %esi
80103b23:	5d                   	pop    %ebp
80103b24:	c3                   	ret
    panic("sched ptable.lock");
80103b25:	83 ec 0c             	sub    $0xc,%esp
80103b28:	68 e1 6e 10 80       	push   $0x80106ee1
80103b2d:	e8 06 c8 ff ff       	call   80100338 <panic>
    panic("sched interruptible");
80103b32:	83 ec 0c             	sub    $0xc,%esp
80103b35:	68 0d 6f 10 80       	push   $0x80106f0d
80103b3a:	e8 f9 c7 ff ff       	call   80100338 <panic>
    panic("sched running");
80103b3f:	83 ec 0c             	sub    $0xc,%esp
80103b42:	68 ff 6e 10 80       	push   $0x80106eff
80103b47:	e8 ec c7 ff ff       	call   80100338 <panic>
    panic("sched locks");
80103b4c:	83 ec 0c             	sub    $0xc,%esp
80103b4f:	68 f3 6e 10 80       	push   $0x80106ef3
80103b54:	e8 df c7 ff ff       	call   80100338 <panic>
80103b59:	8d 76 00             	lea    0x0(%esi),%esi

80103b5c <exit>:
{
80103b5c:	55                   	push   %ebp
80103b5d:	89 e5                	mov    %esp,%ebp
80103b5f:	57                   	push   %edi
80103b60:	56                   	push   %esi
80103b61:	53                   	push   %ebx
80103b62:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103b65:	e8 36 fa ff ff       	call   801035a0 <myproc>
  if(curproc == initproc)
80103b6a:	39 05 54 43 11 80    	cmp    %eax,0x80114354
80103b70:	0f 84 ff 00 00 00    	je     80103c75 <exit+0x119>
80103b76:	89 c3                	mov    %eax,%ebx
80103b78:	8d 70 44             	lea    0x44(%eax),%esi
80103b7b:	8d b8 84 00 00 00    	lea    0x84(%eax),%edi
80103b81:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b84:	8b 06                	mov    (%esi),%eax
80103b86:	85 c0                	test   %eax,%eax
80103b88:	74 12                	je     80103b9c <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	50                   	push   %eax
80103b8e:	e8 b9 d2 ff ff       	call   80100e4c <fileclose>
      curproc->ofile[fd] = 0;
80103b93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103b99:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103b9c:	83 c6 04             	add    $0x4,%esi
80103b9f:	39 f7                	cmp    %esi,%edi
80103ba1:	75 e1                	jne    80103b84 <exit+0x28>
  begin_op();
80103ba3:	e8 bc ee ff ff       	call   80102a64 <begin_op>
  iput(curproc->cwd);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	ff b3 84 00 00 00    	push   0x84(%ebx)
80103bb1:	e8 76 db ff ff       	call   8010172c <iput>
  end_op();
80103bb6:	e8 11 ef ff ff       	call   80102acc <end_op>
  curproc->cwd = 0;
80103bbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103bc2:	00 00 00 
  acquire(&ptable.lock);
80103bc5:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bcc:	e8 7f 07 00 00       	call   80104350 <acquire>
  wakeup1(curproc->parent);
80103bd1:	8b 53 30             	mov    0x30(%ebx),%edx
80103bd4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103bdc:	eb 0e                	jmp    80103bec <exit+0x90>
80103bde:	66 90                	xchg   %ax,%ax
80103be0:	05 98 00 00 00       	add    $0x98,%eax
80103be5:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80103bea:	74 1e                	je     80103c0a <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103bec:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80103bf0:	75 ee                	jne    80103be0 <exit+0x84>
80103bf2:	3b 50 3c             	cmp    0x3c(%eax),%edx
80103bf5:	75 e9                	jne    80103be0 <exit+0x84>
      p->state = RUNNABLE;
80103bf7:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bfe:	05 98 00 00 00       	add    $0x98,%eax
80103c03:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80103c08:	75 e2                	jne    80103bec <exit+0x90>
      p->parent = initproc;
80103c0a:	8b 0d 54 43 11 80    	mov    0x80114354,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c10:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103c15:	eb 0f                	jmp    80103c26 <exit+0xca>
80103c17:	90                   	nop
80103c18:	81 c2 98 00 00 00    	add    $0x98,%edx
80103c1e:	81 fa 54 43 11 80    	cmp    $0x80114354,%edx
80103c24:	74 36                	je     80103c5c <exit+0x100>
    if(p->parent == curproc){
80103c26:	39 5a 30             	cmp    %ebx,0x30(%edx)
80103c29:	75 ed                	jne    80103c18 <exit+0xbc>
      p->parent = initproc;
80103c2b:	89 4a 30             	mov    %ecx,0x30(%edx)
      if(p->state == ZOMBIE)
80103c2e:	83 7a 28 05          	cmpl   $0x5,0x28(%edx)
80103c32:	75 e4                	jne    80103c18 <exit+0xbc>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c34:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103c39:	eb 0d                	jmp    80103c48 <exit+0xec>
80103c3b:	90                   	nop
80103c3c:	05 98 00 00 00       	add    $0x98,%eax
80103c41:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80103c46:	74 d0                	je     80103c18 <exit+0xbc>
    if(p->state == SLEEPING && p->chan == chan)
80103c48:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80103c4c:	75 ee                	jne    80103c3c <exit+0xe0>
80103c4e:	3b 48 3c             	cmp    0x3c(%eax),%ecx
80103c51:	75 e9                	jne    80103c3c <exit+0xe0>
      p->state = RUNNABLE;
80103c53:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
80103c5a:	eb e0                	jmp    80103c3c <exit+0xe0>
  curproc->state = ZOMBIE;
80103c5c:	c7 43 28 05 00 00 00 	movl   $0x5,0x28(%ebx)
  sched();
80103c63:	e8 40 fe ff ff       	call   80103aa8 <sched>
  panic("zombie exit");
80103c68:	83 ec 0c             	sub    $0xc,%esp
80103c6b:	68 2e 6f 10 80       	push   $0x80106f2e
80103c70:	e8 c3 c6 ff ff       	call   80100338 <panic>
    panic("init exiting");
80103c75:	83 ec 0c             	sub    $0xc,%esp
80103c78:	68 21 6f 10 80       	push   $0x80106f21
80103c7d:	e8 b6 c6 ff ff       	call   80100338 <panic>
80103c82:	66 90                	xchg   %ax,%ax

80103c84 <yield>:
{
80103c84:	55                   	push   %ebp
80103c85:	89 e5                	mov    %esp,%ebp
80103c87:	53                   	push   %ebx
80103c88:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c8b:	68 20 1d 11 80       	push   $0x80111d20
80103c90:	e8 bb 06 00 00       	call   80104350 <acquire>
  pushcli();
80103c95:	e8 72 05 00 00       	call   8010420c <pushcli>
  c = mycpu();
80103c9a:	e8 69 f8 ff ff       	call   80103508 <mycpu>
  p = c->proc;
80103c9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca5:	e8 ae 05 00 00       	call   80104258 <popcli>
  myproc()->state = RUNNABLE;
80103caa:	c7 43 28 03 00 00 00 	movl   $0x3,0x28(%ebx)
  sched();
80103cb1:	e8 f2 fd ff ff       	call   80103aa8 <sched>
  release(&ptable.lock);
80103cb6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103cbd:	e8 2e 06 00 00       	call   801042f0 <release>
}
80103cc2:	83 c4 10             	add    $0x10,%esp
80103cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cc8:	c9                   	leave
80103cc9:	c3                   	ret
80103cca:	66 90                	xchg   %ax,%ax

80103ccc <sleep>:
{
80103ccc:	55                   	push   %ebp
80103ccd:	89 e5                	mov    %esp,%ebp
80103ccf:	57                   	push   %edi
80103cd0:	56                   	push   %esi
80103cd1:	53                   	push   %ebx
80103cd2:	83 ec 0c             	sub    $0xc,%esp
80103cd5:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103cdb:	e8 2c 05 00 00       	call   8010420c <pushcli>
  c = mycpu();
80103ce0:	e8 23 f8 ff ff       	call   80103508 <mycpu>
  p = c->proc;
80103ce5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ceb:	e8 68 05 00 00       	call   80104258 <popcli>
  if(p == 0)
80103cf0:	85 db                	test   %ebx,%ebx
80103cf2:	0f 84 96 00 00 00    	je     80103d8e <sleep+0xc2>
  if(lk == 0)
80103cf8:	85 f6                	test   %esi,%esi
80103cfa:	0f 84 81 00 00 00    	je     80103d81 <sleep+0xb5>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d00:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103d06:	74 54                	je     80103d5c <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	68 20 1d 11 80       	push   $0x80111d20
80103d10:	e8 3b 06 00 00       	call   80104350 <acquire>
    release(lk);
80103d15:	89 34 24             	mov    %esi,(%esp)
80103d18:	e8 d3 05 00 00       	call   801042f0 <release>
  p->chan = chan;
80103d1d:	89 7b 3c             	mov    %edi,0x3c(%ebx)
  p->state = SLEEPING;
80103d20:	c7 43 28 02 00 00 00 	movl   $0x2,0x28(%ebx)
  sched();
80103d27:	e8 7c fd ff ff       	call   80103aa8 <sched>
  p->chan = 0;
80103d2c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
   if(p->killed){
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	8b 53 40             	mov    0x40(%ebx),%edx
80103d39:	85 d2                	test   %edx,%edx
80103d3b:	75 5e                	jne    80103d9b <sleep+0xcf>
    release(&ptable.lock);
80103d3d:	83 ec 0c             	sub    $0xc,%esp
80103d40:	68 20 1d 11 80       	push   $0x80111d20
80103d45:	e8 a6 05 00 00       	call   801042f0 <release>
    acquire(lk);
80103d4a:	83 c4 10             	add    $0x10,%esp
80103d4d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d53:	5b                   	pop    %ebx
80103d54:	5e                   	pop    %esi
80103d55:	5f                   	pop    %edi
80103d56:	5d                   	pop    %ebp
    acquire(lk);
80103d57:	e9 f4 05 00 00       	jmp    80104350 <acquire>
  p->chan = chan;
80103d5c:	89 7b 3c             	mov    %edi,0x3c(%ebx)
  p->state = SLEEPING;
80103d5f:	c7 43 28 02 00 00 00 	movl   $0x2,0x28(%ebx)
  sched();
80103d66:	e8 3d fd ff ff       	call   80103aa8 <sched>
  p->chan = 0;
80103d6b:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
   if(p->killed){
80103d72:	8b 43 40             	mov    0x40(%ebx),%eax
80103d75:	85 c0                	test   %eax,%eax
80103d77:	75 22                	jne    80103d9b <sleep+0xcf>
}
80103d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d7c:	5b                   	pop    %ebx
80103d7d:	5e                   	pop    %esi
80103d7e:	5f                   	pop    %edi
80103d7f:	5d                   	pop    %ebp
80103d80:	c3                   	ret
    panic("sleep without lk");
80103d81:	83 ec 0c             	sub    $0xc,%esp
80103d84:	68 40 6f 10 80       	push   $0x80106f40
80103d89:	e8 aa c5 ff ff       	call   80100338 <panic>
    panic("sleep");
80103d8e:	83 ec 0c             	sub    $0xc,%esp
80103d91:	68 3a 6f 10 80       	push   $0x80106f3a
80103d96:	e8 9d c5 ff ff       	call   80100338 <panic>
        release(&ptable.lock);
80103d9b:	83 ec 0c             	sub    $0xc,%esp
80103d9e:	68 20 1d 11 80       	push   $0x80111d20
80103da3:	e8 48 05 00 00       	call   801042f0 <release>
        exit();
80103da8:	e8 af fd ff ff       	call   80103b5c <exit>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi

80103db0 <wait>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
  pushcli();
80103db5:	e8 52 04 00 00       	call   8010420c <pushcli>
  c = mycpu();
80103dba:	e8 49 f7 ff ff       	call   80103508 <mycpu>
  p = c->proc;
80103dbf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dc5:	e8 8e 04 00 00       	call   80104258 <popcli>
  acquire(&ptable.lock);
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 20 1d 11 80       	push   $0x80111d20
80103dd2:	e8 79 05 00 00       	call   80104350 <acquire>
80103dd7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103dda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ddc:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103de1:	eb 0f                	jmp    80103df2 <wait+0x42>
80103de3:	90                   	nop
80103de4:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103dea:	81 fb 54 43 11 80    	cmp    $0x80114354,%ebx
80103df0:	74 1e                	je     80103e10 <wait+0x60>
      if(p->parent != curproc)
80103df2:	39 73 30             	cmp    %esi,0x30(%ebx)
80103df5:	75 ed                	jne    80103de4 <wait+0x34>
      if(p->state == ZOMBIE){
80103df7:	83 7b 28 05          	cmpl   $0x5,0x28(%ebx)
80103dfb:	74 33                	je     80103e30 <wait+0x80>
      havekids = 1;
80103dfd:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e02:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103e08:	81 fb 54 43 11 80    	cmp    $0x80114354,%ebx
80103e0e:	75 e2                	jne    80103df2 <wait+0x42>
    if(!havekids || curproc->killed){
80103e10:	85 c0                	test   %eax,%eax
80103e12:	74 75                	je     80103e89 <wait+0xd9>
80103e14:	8b 46 40             	mov    0x40(%esi),%eax
80103e17:	85 c0                	test   %eax,%eax
80103e19:	75 6e                	jne    80103e89 <wait+0xd9>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e1b:	83 ec 08             	sub    $0x8,%esp
80103e1e:	68 20 1d 11 80       	push   $0x80111d20
80103e23:	56                   	push   %esi
80103e24:	e8 a3 fe ff ff       	call   80103ccc <sleep>
    havekids = 0;
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	eb ac                	jmp    80103dda <wait+0x2a>
80103e2e:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80103e30:	8b 73 2c             	mov    0x2c(%ebx),%esi
        kfree(p->kstack);
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	ff 73 24             	push   0x24(%ebx)
80103e39:	e8 c6 e3 ff ff       	call   80102204 <kfree>
        p->kstack = 0;
80103e3e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        freevm(p->pgdir);
80103e45:	5a                   	pop    %edx
80103e46:	ff 73 20             	push   0x20(%ebx)
80103e49:	e8 26 2a 00 00       	call   80106874 <freevm>
        p->pid = 0;
80103e4e:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->parent = 0;
80103e55:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->name[0] = 0;
80103e5c:	c6 83 88 00 00 00 00 	movb   $0x0,0x88(%ebx)
        p->killed = 0;
80103e63:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
        p->state = UNUSED;
80103e6a:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        release(&ptable.lock);
80103e71:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e78:	e8 73 04 00 00       	call   801042f0 <release>
        return pid;
80103e7d:	83 c4 10             	add    $0x10,%esp
}
80103e80:	89 f0                	mov    %esi,%eax
80103e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e85:	5b                   	pop    %ebx
80103e86:	5e                   	pop    %esi
80103e87:	5d                   	pop    %ebp
80103e88:	c3                   	ret
      release(&ptable.lock);
80103e89:	83 ec 0c             	sub    $0xc,%esp
80103e8c:	68 20 1d 11 80       	push   $0x80111d20
80103e91:	e8 5a 04 00 00       	call   801042f0 <release>
      return -1;
80103e96:	83 c4 10             	add    $0x10,%esp
80103e99:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103e9e:	eb e0                	jmp    80103e80 <wait+0xd0>

80103ea0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 10             	sub    $0x10,%esp
80103ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eaa:	68 20 1d 11 80       	push   $0x80111d20
80103eaf:	e8 9c 04 00 00       	call   80104350 <acquire>
80103eb4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103ebc:	eb 0e                	jmp    80103ecc <wakeup+0x2c>
80103ebe:	66 90                	xchg   %ax,%ax
80103ec0:	05 98 00 00 00       	add    $0x98,%eax
80103ec5:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80103eca:	74 1e                	je     80103eea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103ecc:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80103ed0:	75 ee                	jne    80103ec0 <wakeup+0x20>
80103ed2:	3b 58 3c             	cmp    0x3c(%eax),%ebx
80103ed5:	75 e9                	jne    80103ec0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ed7:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ede:	05 98 00 00 00       	add    $0x98,%eax
80103ee3:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80103ee8:	75 e2                	jne    80103ecc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103eea:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80103ef1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef4:	c9                   	leave
  release(&ptable.lock);
80103ef5:	e9 f6 03 00 00       	jmp    801042f0 <release>
80103efa:	66 90                	xchg   %ax,%ax

80103efc <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103efc:	55                   	push   %ebp
80103efd:	89 e5                	mov    %esp,%ebp
80103eff:	53                   	push   %ebx
80103f00:	83 ec 10             	sub    $0x10,%esp
80103f03:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f06:	68 20 1d 11 80       	push   $0x80111d20
80103f0b:	e8 40 04 00 00       	call   80104350 <acquire>
80103f10:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f13:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f18:	eb 0e                	jmp    80103f28 <kill+0x2c>
80103f1a:	66 90                	xchg   %ax,%ax
80103f1c:	05 98 00 00 00       	add    $0x98,%eax
80103f21:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80103f26:	74 30                	je     80103f58 <kill+0x5c>
    if(p->pid == pid){
80103f28:	39 58 2c             	cmp    %ebx,0x2c(%eax)
80103f2b:	75 ef                	jne    80103f1c <kill+0x20>
      p->killed = 1;
80103f2d:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f34:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80103f38:	75 07                	jne    80103f41 <kill+0x45>
        p->state = RUNNABLE;
80103f3a:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
      release(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 20 1d 11 80       	push   $0x80111d20
80103f49:	e8 a2 03 00 00       	call   801042f0 <release>
      return 0;
80103f4e:	83 c4 10             	add    $0x10,%esp
80103f51:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f56:	c9                   	leave
80103f57:	c3                   	ret
  release(&ptable.lock);
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	68 20 1d 11 80       	push   $0x80111d20
80103f60:	e8 8b 03 00 00       	call   801042f0 <release>
  return -1;
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f70:	c9                   	leave
80103f71:	c3                   	ret
80103f72:	66 90                	xchg   %ax,%ax

80103f74 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	57                   	push   %edi
80103f78:	56                   	push   %esi
80103f79:	53                   	push   %ebx
80103f7a:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7d:	bb dc 1d 11 80       	mov    $0x80111ddc,%ebx
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f82:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103f85:	eb 42                	jmp    80103fc9 <procdump+0x55>
80103f87:	90                   	nop
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f88:	8b 04 85 c0 75 10 80 	mov    -0x7fef8a40(,%eax,4),%eax
80103f8f:	85 c0                	test   %eax,%eax
80103f91:	74 42                	je     80103fd5 <procdump+0x61>
    cprintf("%d %s %s", p->pid, state, p->name);
80103f93:	53                   	push   %ebx
80103f94:	50                   	push   %eax
80103f95:	ff 73 a4             	push   -0x5c(%ebx)
80103f98:	68 55 6f 10 80       	push   $0x80106f55
80103f9d:	e8 7e c6 ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
80103fa2:	83 c4 10             	add    $0x10,%esp
80103fa5:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fa9:	74 31                	je     80103fdc <procdump+0x68>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fab:	83 ec 0c             	sub    $0xc,%esp
80103fae:	68 11 71 10 80       	push   $0x80107111
80103fb3:	e8 68 c6 ff ff       	call   80100620 <cprintf>
80103fb8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbb:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103fc1:	81 fb dc 43 11 80    	cmp    $0x801143dc,%ebx
80103fc7:	74 4f                	je     80104018 <procdump+0xa4>
    if(p->state == UNUSED)
80103fc9:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fcc:	85 c0                	test   %eax,%eax
80103fce:	74 eb                	je     80103fbb <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fd0:	83 f8 07             	cmp    $0x7,%eax
80103fd3:	76 b3                	jbe    80103f88 <procdump+0x14>
      state = "???";
80103fd5:	b8 51 6f 10 80       	mov    $0x80106f51,%eax
80103fda:	eb b7                	jmp    80103f93 <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fdc:	83 ec 08             	sub    $0x8,%esp
80103fdf:	56                   	push   %esi
80103fe0:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103fe3:	8b 40 0c             	mov    0xc(%eax),%eax
80103fe6:	83 c0 08             	add    $0x8,%eax
80103fe9:	50                   	push   %eax
80103fea:	e8 b5 01 00 00       	call   801041a4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103fef:	89 f7                	mov    %esi,%edi
80103ff1:	83 c4 10             	add    $0x10,%esp
80103ff4:	8b 07                	mov    (%edi),%eax
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	74 b1                	je     80103fab <procdump+0x37>
        cprintf(" %p", pc[i]);
80103ffa:	83 ec 08             	sub    $0x8,%esp
80103ffd:	50                   	push   %eax
80103ffe:	68 21 6c 10 80       	push   $0x80106c21
80104003:	e8 18 c6 ff ff       	call   80100620 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104008:	83 c7 04             	add    $0x4,%edi
8010400b:	83 c4 10             	add    $0x10,%esp
8010400e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104011:	39 c7                	cmp    %eax,%edi
80104013:	75 df                	jne    80103ff4 <procdump+0x80>
80104015:	eb 94                	jmp    80103fab <procdump+0x37>
80104017:	90                   	nop
  }
}
80104018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010401b:	5b                   	pop    %ebx
8010401c:	5e                   	pop    %esi
8010401d:	5f                   	pop    %edi
8010401e:	5d                   	pop    %ebp
8010401f:	c3                   	ret

80104020 <wakeup_shell>:



void wakeup_shell(void) {
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  acquire(&ptable.lock);
80104026:	68 20 1d 11 80       	push   $0x80111d20
8010402b:	e8 20 03 00 00       	call   80104350 <acquire>
80104030:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104033:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104038:	eb 0e                	jmp    80104048 <wakeup_shell+0x28>
8010403a:	66 90                	xchg   %ax,%ax
8010403c:	05 98 00 00 00       	add    $0x98,%eax
80104041:	3d 54 43 11 80       	cmp    $0x80114354,%eax
80104046:	74 1f                	je     80104067 <wakeup_shell+0x47>
    if(p->pid == 2){  // shell is typically pid 2
80104048:	83 78 2c 02          	cmpl   $0x2,0x2c(%eax)
8010404c:	75 ee                	jne    8010403c <wakeup_shell+0x1c>
      p->state = RUNNABLE;
8010404e:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
      cprintf("Shell (pid=%d) explicitly woken up\n", p->pid);
80104055:	83 ec 08             	sub    $0x8,%esp
80104058:	6a 02                	push   $0x2
8010405a:	68 bc 72 10 80       	push   $0x801072bc
8010405f:	e8 bc c5 ff ff       	call   80100620 <cprintf>
      break;
80104064:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
80104067:	83 ec 0c             	sub    $0xc,%esp
8010406a:	68 20 1d 11 80       	push   $0x80111d20
8010406f:	e8 7c 02 00 00       	call   801042f0 <release>
80104074:	83 c4 10             	add    $0x10,%esp
80104077:	c9                   	leave
80104078:	c3                   	ret
80104079:	66 90                	xchg   %ax,%ax
8010407b:	90                   	nop

8010407c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010407c:	55                   	push   %ebp
8010407d:	89 e5                	mov    %esp,%ebp
8010407f:	53                   	push   %ebx
80104080:	83 ec 0c             	sub    $0xc,%esp
80104083:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104086:	68 9a 6f 10 80       	push   $0x80106f9a
8010408b:	8d 43 04             	lea    0x4(%ebx),%eax
8010408e:	50                   	push   %eax
8010408f:	e8 f4 00 00 00       	call   80104188 <initlock>
  lk->name = name;
80104094:	8b 45 0c             	mov    0xc(%ebp),%eax
80104097:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
8010409a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040a0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ad:	c9                   	leave
801040ae:	c3                   	ret
801040af:	90                   	nop

801040b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040b8:	8d 73 04             	lea    0x4(%ebx),%esi
801040bb:	83 ec 0c             	sub    $0xc,%esp
801040be:	56                   	push   %esi
801040bf:	e8 8c 02 00 00       	call   80104350 <acquire>
  while (lk->locked) {
801040c4:	83 c4 10             	add    $0x10,%esp
801040c7:	8b 13                	mov    (%ebx),%edx
801040c9:	85 d2                	test   %edx,%edx
801040cb:	74 16                	je     801040e3 <acquiresleep+0x33>
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801040d0:	83 ec 08             	sub    $0x8,%esp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	e8 f2 fb ff ff       	call   80103ccc <sleep>
  while (lk->locked) {
801040da:	83 c4 10             	add    $0x10,%esp
801040dd:	8b 03                	mov    (%ebx),%eax
801040df:	85 c0                	test   %eax,%eax
801040e1:	75 ed                	jne    801040d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801040e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040e9:	e8 b2 f4 ff ff       	call   801035a0 <myproc>
801040ee:	8b 40 2c             	mov    0x2c(%eax),%eax
801040f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040fa:	5b                   	pop    %ebx
801040fb:	5e                   	pop    %esi
801040fc:	5d                   	pop    %ebp
  release(&lk->lk);
801040fd:	e9 ee 01 00 00       	jmp    801042f0 <release>
80104102:	66 90                	xchg   %ax,%ax

80104104 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	56                   	push   %esi
80104108:	53                   	push   %ebx
80104109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010410c:	8d 73 04             	lea    0x4(%ebx),%esi
8010410f:	83 ec 0c             	sub    $0xc,%esp
80104112:	56                   	push   %esi
80104113:	e8 38 02 00 00       	call   80104350 <acquire>
  lk->locked = 0;
80104118:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010411e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104125:	89 1c 24             	mov    %ebx,(%esp)
80104128:	e8 73 fd ff ff       	call   80103ea0 <wakeup>
  release(&lk->lk);
8010412d:	83 c4 10             	add    $0x10,%esp
80104130:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104133:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104136:	5b                   	pop    %ebx
80104137:	5e                   	pop    %esi
80104138:	5d                   	pop    %ebp
  release(&lk->lk);
80104139:	e9 b2 01 00 00       	jmp    801042f0 <release>
8010413e:	66 90                	xchg   %ax,%ax

80104140 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
80104145:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104148:	8d 73 04             	lea    0x4(%ebx),%esi
8010414b:	83 ec 0c             	sub    $0xc,%esp
8010414e:	56                   	push   %esi
8010414f:	e8 fc 01 00 00       	call   80104350 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104154:	83 c4 10             	add    $0x10,%esp
80104157:	8b 03                	mov    (%ebx),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	75 17                	jne    80104174 <holdingsleep+0x34>
8010415d:	31 db                	xor    %ebx,%ebx
  release(&lk->lk);
8010415f:	83 ec 0c             	sub    $0xc,%esp
80104162:	56                   	push   %esi
80104163:	e8 88 01 00 00       	call   801042f0 <release>
  return r;
}
80104168:	89 d8                	mov    %ebx,%eax
8010416a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010416d:	5b                   	pop    %ebx
8010416e:	5e                   	pop    %esi
8010416f:	5d                   	pop    %ebp
80104170:	c3                   	ret
80104171:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104174:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104177:	e8 24 f4 ff ff       	call   801035a0 <myproc>
8010417c:	39 58 2c             	cmp    %ebx,0x2c(%eax)
8010417f:	0f 94 c3             	sete   %bl
80104182:	0f b6 db             	movzbl %bl,%ebx
80104185:	eb d8                	jmp    8010415f <holdingsleep+0x1f>
80104187:	90                   	nop

80104188 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104188:	55                   	push   %ebp
80104189:	89 e5                	mov    %esp,%ebp
8010418b:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010418e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104191:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104194:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010419a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801041a1:	5d                   	pop    %ebp
801041a2:	c3                   	ret
801041a3:	90                   	nop

801041a4 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	53                   	push   %ebx
801041a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801041b1:	31 d2                	xor    %edx,%edx
801041b3:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041b4:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801041ba:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041c0:	77 16                	ja     801041d8 <getcallerpcs+0x34>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041c2:	8b 58 04             	mov    0x4(%eax),%ebx
801041c5:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801041c8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801041ca:	42                   	inc    %edx
801041cb:	83 fa 0a             	cmp    $0xa,%edx
801041ce:	75 e4                	jne    801041b4 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d3:	c9                   	leave
801041d4:	c3                   	ret
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801041d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801041db:	83 c1 28             	add    $0x28,%ecx
801041de:	89 ca                	mov    %ecx,%edx
801041e0:	29 c2                	sub    %eax,%edx
801041e2:	83 e2 04             	and    $0x4,%edx
801041e5:	74 0d                	je     801041f4 <getcallerpcs+0x50>
    pcs[i] = 0;
801041e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801041ed:	83 c0 04             	add    $0x4,%eax
801041f0:	39 c8                	cmp    %ecx,%eax
801041f2:	74 dc                	je     801041d0 <getcallerpcs+0x2c>
    pcs[i] = 0;
801041f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801041fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
80104201:	83 c0 08             	add    $0x8,%eax
80104204:	39 c8                	cmp    %ecx,%eax
80104206:	75 ec                	jne    801041f4 <getcallerpcs+0x50>
80104208:	eb c6                	jmp    801041d0 <getcallerpcs+0x2c>
8010420a:	66 90                	xchg   %ax,%ax

8010420c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010420c:	55                   	push   %ebp
8010420d:	89 e5                	mov    %esp,%ebp
8010420f:	53                   	push   %ebx
80104210:	50                   	push   %eax
80104211:	9c                   	pushf
80104212:	5b                   	pop    %ebx
  asm volatile("cli");
80104213:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104214:	e8 ef f2 ff ff       	call   80103508 <mycpu>
80104219:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010421f:	85 d2                	test   %edx,%edx
80104221:	74 11                	je     80104234 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104223:	e8 e0 f2 ff ff       	call   80103508 <mycpu>
80104228:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
8010422e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104231:	c9                   	leave
80104232:	c3                   	ret
80104233:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104234:	e8 cf f2 ff ff       	call   80103508 <mycpu>
80104239:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010423f:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104245:	e8 be f2 ff ff       	call   80103508 <mycpu>
8010424a:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80104250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104253:	c9                   	leave
80104254:	c3                   	ret
80104255:	8d 76 00             	lea    0x0(%esi),%esi

80104258 <popcli>:

void
popcli(void)
{
80104258:	55                   	push   %ebp
80104259:	89 e5                	mov    %esp,%ebp
8010425b:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010425e:	9c                   	pushf
8010425f:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104260:	f6 c4 02             	test   $0x2,%ah
80104263:	75 31                	jne    80104296 <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104265:	e8 9e f2 ff ff       	call   80103508 <mycpu>
8010426a:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80104270:	78 31                	js     801042a3 <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104272:	e8 91 f2 ff ff       	call   80103508 <mycpu>
80104277:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010427d:	85 d2                	test   %edx,%edx
8010427f:	74 03                	je     80104284 <popcli+0x2c>
    sti();
}
80104281:	c9                   	leave
80104282:	c3                   	ret
80104283:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104284:	e8 7f f2 ff ff       	call   80103508 <mycpu>
80104289:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010428f:	85 c0                	test   %eax,%eax
80104291:	74 ee                	je     80104281 <popcli+0x29>
  asm volatile("sti");
80104293:	fb                   	sti
}
80104294:	c9                   	leave
80104295:	c3                   	ret
    panic("popcli - interruptible");
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	68 a5 6f 10 80       	push   $0x80106fa5
8010429e:	e8 95 c0 ff ff       	call   80100338 <panic>
    panic("popcli");
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	68 bc 6f 10 80       	push   $0x80106fbc
801042ab:	e8 88 c0 ff ff       	call   80100338 <panic>

801042b0 <holding>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	50                   	push   %eax
801042b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801042b8:	e8 4f ff ff ff       	call   8010420c <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801042bd:	8b 13                	mov    (%ebx),%edx
801042bf:	85 d2                	test   %edx,%edx
801042c1:	75 11                	jne    801042d4 <holding+0x24>
801042c3:	31 db                	xor    %ebx,%ebx
  popcli();
801042c5:	e8 8e ff ff ff       	call   80104258 <popcli>
}
801042ca:	89 d8                	mov    %ebx,%eax
801042cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042cf:	c9                   	leave
801042d0:	c3                   	ret
801042d1:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801042d4:	8b 5b 08             	mov    0x8(%ebx),%ebx
801042d7:	e8 2c f2 ff ff       	call   80103508 <mycpu>
801042dc:	39 c3                	cmp    %eax,%ebx
801042de:	0f 94 c3             	sete   %bl
801042e1:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801042e4:	e8 6f ff ff ff       	call   80104258 <popcli>
}
801042e9:	89 d8                	mov    %ebx,%eax
801042eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ee:	c9                   	leave
801042ef:	c3                   	ret

801042f0 <release>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801042f8:	e8 0f ff ff ff       	call   8010420c <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801042fd:	8b 03                	mov    (%ebx),%eax
801042ff:	85 c0                	test   %eax,%eax
80104301:	75 15                	jne    80104318 <release+0x28>
  popcli();
80104303:	e8 50 ff ff ff       	call   80104258 <popcli>
    panic("release");
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	68 c3 6f 10 80       	push   $0x80106fc3
80104310:	e8 23 c0 ff ff       	call   80100338 <panic>
80104315:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104318:	8b 73 08             	mov    0x8(%ebx),%esi
8010431b:	e8 e8 f1 ff ff       	call   80103508 <mycpu>
80104320:	39 c6                	cmp    %eax,%esi
80104322:	75 df                	jne    80104303 <release+0x13>
  popcli();
80104324:	e8 2f ff ff ff       	call   80104258 <popcli>
  lk->pcs[0] = 0;
80104329:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104330:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104337:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010433c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104342:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104345:	5b                   	pop    %ebx
80104346:	5e                   	pop    %esi
80104347:	5d                   	pop    %ebp
  popcli();
80104348:	e9 0b ff ff ff       	jmp    80104258 <popcli>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

80104350 <acquire>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	50                   	push   %eax
  pushcli(); // disable interrupts to avoid deadlock.
80104355:	e8 b2 fe ff ff       	call   8010420c <pushcli>
  if(holding(lk))
8010435a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010435d:	e8 aa fe ff ff       	call   8010420c <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104362:	8b 13                	mov    (%ebx),%edx
80104364:	85 d2                	test   %edx,%edx
80104366:	0f 85 8c 00 00 00    	jne    801043f8 <acquire+0xa8>
  popcli();
8010436c:	e8 e7 fe ff ff       	call   80104258 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104371:	b9 01 00 00 00       	mov    $0x1,%ecx
80104376:	66 90                	xchg   %ax,%ax
  while(xchg(&lk->locked, 1) != 0)
80104378:	8b 55 08             	mov    0x8(%ebp),%edx
8010437b:	89 c8                	mov    %ecx,%eax
8010437d:	f0 87 02             	lock xchg %eax,(%edx)
80104380:	85 c0                	test   %eax,%eax
80104382:	75 f4                	jne    80104378 <acquire+0x28>
  __sync_synchronize();
80104384:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104389:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010438c:	e8 77 f1 ff ff       	call   80103508 <mycpu>
80104391:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104397:	31 c0                	xor    %eax,%eax
  ebp = (uint*)v - 2;
80104399:	89 ea                	mov    %ebp,%edx
8010439b:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010439c:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043a2:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043a8:	77 16                	ja     801043c0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801043aa:	8b 5a 04             	mov    0x4(%edx),%ebx
801043ad:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801043b1:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801043b3:	40                   	inc    %eax
801043b4:	83 f8 0a             	cmp    $0xa,%eax
801043b7:	75 e3                	jne    8010439c <acquire+0x4c>
}
801043b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043bc:	c9                   	leave
801043bd:	c3                   	ret
801043be:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
801043c0:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801043c4:	83 c1 34             	add    $0x34,%ecx
801043c7:	89 ca                	mov    %ecx,%edx
801043c9:	29 c2                	sub    %eax,%edx
801043cb:	83 e2 04             	and    $0x4,%edx
801043ce:	74 10                	je     801043e0 <acquire+0x90>
    pcs[i] = 0;
801043d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801043d6:	83 c0 04             	add    $0x4,%eax
801043d9:	39 c8                	cmp    %ecx,%eax
801043db:	74 dc                	je     801043b9 <acquire+0x69>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801043e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
801043ed:	83 c0 08             	add    $0x8,%eax
801043f0:	39 c8                	cmp    %ecx,%eax
801043f2:	75 ec                	jne    801043e0 <acquire+0x90>
801043f4:	eb c3                	jmp    801043b9 <acquire+0x69>
801043f6:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801043f8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801043fb:	e8 08 f1 ff ff       	call   80103508 <mycpu>
80104400:	39 c3                	cmp    %eax,%ebx
80104402:	0f 85 64 ff ff ff    	jne    8010436c <acquire+0x1c>
  popcli();
80104408:	e8 4b fe ff ff       	call   80104258 <popcli>
    panic("acquire");
8010440d:	83 ec 0c             	sub    $0xc,%esp
80104410:	68 cb 6f 10 80       	push   $0x80106fcb
80104415:	e8 1e bf ff ff       	call   80100338 <panic>
8010441a:	66 90                	xchg   %ax,%ax

8010441c <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010441c:	55                   	push   %ebp
8010441d:	89 e5                	mov    %esp,%ebp
8010441f:	57                   	push   %edi
80104420:	8b 55 08             	mov    0x8(%ebp),%edx
80104423:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104426:	89 d0                	mov    %edx,%eax
80104428:	09 c8                	or     %ecx,%eax
8010442a:	a8 03                	test   $0x3,%al
8010442c:	75 22                	jne    80104450 <memset+0x34>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010442e:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
80104431:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104435:	89 f8                	mov    %edi,%eax
80104437:	c1 e0 08             	shl    $0x8,%eax
8010443a:	01 f8                	add    %edi,%eax
8010443c:	89 c7                	mov    %eax,%edi
8010443e:	c1 e7 10             	shl    $0x10,%edi
80104441:	01 f8                	add    %edi,%eax
  asm volatile("cld; rep stosl" :
80104443:	89 d7                	mov    %edx,%edi
80104445:	fc                   	cld
80104446:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104448:	89 d0                	mov    %edx,%eax
8010444a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010444d:	c9                   	leave
8010444e:	c3                   	ret
8010444f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104450:	89 d7                	mov    %edx,%edi
80104452:	8b 45 0c             	mov    0xc(%ebp),%eax
80104455:	fc                   	cld
80104456:	f3 aa                	rep stos %al,%es:(%edi)
80104458:	89 d0                	mov    %edx,%eax
8010445a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010445d:	c9                   	leave
8010445e:	c3                   	ret
8010445f:	90                   	nop

80104460 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	8b 45 08             	mov    0x8(%ebp),%eax
80104468:	8b 55 0c             	mov    0xc(%ebp),%edx
8010446b:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010446e:	85 f6                	test   %esi,%esi
80104470:	74 1e                	je     80104490 <memcmp+0x30>
80104472:	01 c6                	add    %eax,%esi
80104474:	eb 08                	jmp    8010447e <memcmp+0x1e>
80104476:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104478:	40                   	inc    %eax
80104479:	42                   	inc    %edx
  while(n-- > 0){
8010447a:	39 f0                	cmp    %esi,%eax
8010447c:	74 12                	je     80104490 <memcmp+0x30>
    if(*s1 != *s2)
8010447e:	8a 08                	mov    (%eax),%cl
80104480:	0f b6 1a             	movzbl (%edx),%ebx
80104483:	38 d9                	cmp    %bl,%cl
80104485:	74 f1                	je     80104478 <memcmp+0x18>
      return *s1 - *s2;
80104487:	0f b6 c1             	movzbl %cl,%eax
8010448a:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
8010448c:	5b                   	pop    %ebx
8010448d:	5e                   	pop    %esi
8010448e:	5d                   	pop    %ebp
8010448f:	c3                   	ret
  return 0;
80104490:	31 c0                	xor    %eax,%eax
}
80104492:	5b                   	pop    %ebx
80104493:	5e                   	pop    %esi
80104494:	5d                   	pop    %ebp
80104495:	c3                   	ret
80104496:	66 90                	xchg   %ax,%ax

80104498 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104498:	55                   	push   %ebp
80104499:	89 e5                	mov    %esp,%ebp
8010449b:	57                   	push   %edi
8010449c:	56                   	push   %esi
8010449d:	8b 55 08             	mov    0x8(%ebp),%edx
801044a0:	8b 75 0c             	mov    0xc(%ebp),%esi
801044a3:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044a6:	39 d6                	cmp    %edx,%esi
801044a8:	73 22                	jae    801044cc <memmove+0x34>
801044aa:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801044ad:	39 ca                	cmp    %ecx,%edx
801044af:	73 1b                	jae    801044cc <memmove+0x34>
    s += n;
    d += n;
    while(n-- > 0)
801044b1:	85 c0                	test   %eax,%eax
801044b3:	74 0e                	je     801044c3 <memmove+0x2b>
801044b5:	48                   	dec    %eax
801044b6:	66 90                	xchg   %ax,%ax
      *--d = *--s;
801044b8:	8a 0c 06             	mov    (%esi,%eax,1),%cl
801044bb:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801044be:	83 e8 01             	sub    $0x1,%eax
801044c1:	73 f5                	jae    801044b8 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044c3:	89 d0                	mov    %edx,%eax
801044c5:	5e                   	pop    %esi
801044c6:	5f                   	pop    %edi
801044c7:	5d                   	pop    %ebp
801044c8:	c3                   	ret
801044c9:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801044cc:	85 c0                	test   %eax,%eax
801044ce:	74 f3                	je     801044c3 <memmove+0x2b>
801044d0:	01 f0                	add    %esi,%eax
801044d2:	89 d7                	mov    %edx,%edi
      *d++ = *s++;
801044d4:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801044d5:	39 f0                	cmp    %esi,%eax
801044d7:	75 fb                	jne    801044d4 <memmove+0x3c>
}
801044d9:	89 d0                	mov    %edx,%eax
801044db:	5e                   	pop    %esi
801044dc:	5f                   	pop    %edi
801044dd:	5d                   	pop    %ebp
801044de:	c3                   	ret
801044df:	90                   	nop

801044e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044e0:	eb b6                	jmp    80104498 <memmove>
801044e2:	66 90                	xchg   %ax,%ax

801044e4 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	53                   	push   %ebx
801044e8:	8b 45 08             	mov    0x8(%ebp),%eax
801044eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801044ee:	8b 55 10             	mov    0x10(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801044f1:	85 d2                	test   %edx,%edx
801044f3:	75 0c                	jne    80104501 <strncmp+0x1d>
801044f5:	eb 1d                	jmp    80104514 <strncmp+0x30>
801044f7:	90                   	nop
801044f8:	3a 19                	cmp    (%ecx),%bl
801044fa:	75 0b                	jne    80104507 <strncmp+0x23>
    n--, p++, q++;
801044fc:	40                   	inc    %eax
801044fd:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
801044fe:	4a                   	dec    %edx
801044ff:	74 13                	je     80104514 <strncmp+0x30>
80104501:	8a 18                	mov    (%eax),%bl
80104503:	84 db                	test   %bl,%bl
80104505:	75 f1                	jne    801044f8 <strncmp+0x14>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104507:	0f b6 00             	movzbl (%eax),%eax
8010450a:	0f b6 11             	movzbl (%ecx),%edx
8010450d:	29 d0                	sub    %edx,%eax
}
8010450f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104512:	c9                   	leave
80104513:	c3                   	ret
    return 0;
80104514:	31 c0                	xor    %eax,%eax
}
80104516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104519:	c9                   	leave
8010451a:	c3                   	ret
8010451b:	90                   	nop

8010451c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010451c:	55                   	push   %ebp
8010451d:	89 e5                	mov    %esp,%ebp
8010451f:	56                   	push   %esi
80104520:	53                   	push   %ebx
80104521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104524:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104527:	8b 55 08             	mov    0x8(%ebp),%edx
8010452a:	eb 0c                	jmp    80104538 <strncpy+0x1c>
8010452c:	43                   	inc    %ebx
8010452d:	42                   	inc    %edx
8010452e:	8a 43 ff             	mov    -0x1(%ebx),%al
80104531:	88 42 ff             	mov    %al,-0x1(%edx)
80104534:	84 c0                	test   %al,%al
80104536:	74 10                	je     80104548 <strncpy+0x2c>
80104538:	89 ce                	mov    %ecx,%esi
8010453a:	49                   	dec    %ecx
8010453b:	85 f6                	test   %esi,%esi
8010453d:	7f ed                	jg     8010452c <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010453f:	8b 45 08             	mov    0x8(%ebp),%eax
80104542:	5b                   	pop    %ebx
80104543:	5e                   	pop    %esi
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret
80104546:	66 90                	xchg   %ax,%ax
  while(n-- > 0)
80104548:	8d 5c 32 ff          	lea    -0x1(%edx,%esi,1),%ebx
8010454c:	85 c9                	test   %ecx,%ecx
8010454e:	74 ef                	je     8010453f <strncpy+0x23>
    *s++ = 0;
80104550:	42                   	inc    %edx
80104551:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104555:	89 d9                	mov    %ebx,%ecx
80104557:	29 d1                	sub    %edx,%ecx
80104559:	85 c9                	test   %ecx,%ecx
8010455b:	7f f3                	jg     80104550 <strncpy+0x34>
}
8010455d:	8b 45 08             	mov    0x8(%ebp),%eax
80104560:	5b                   	pop    %ebx
80104561:	5e                   	pop    %esi
80104562:	5d                   	pop    %ebp
80104563:	c3                   	ret

80104564 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	56                   	push   %esi
80104568:	53                   	push   %ebx
80104569:	8b 45 08             	mov    0x8(%ebp),%eax
8010456c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010456f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80104572:	85 c9                	test   %ecx,%ecx
80104574:	7e 1d                	jle    80104593 <safestrcpy+0x2f>
80104576:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
8010457a:	89 c1                	mov    %eax,%ecx
8010457c:	eb 0e                	jmp    8010458c <safestrcpy+0x28>
8010457e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104580:	42                   	inc    %edx
80104581:	41                   	inc    %ecx
80104582:	8a 5a ff             	mov    -0x1(%edx),%bl
80104585:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104588:	84 db                	test   %bl,%bl
8010458a:	74 04                	je     80104590 <safestrcpy+0x2c>
8010458c:	39 f2                	cmp    %esi,%edx
8010458e:	75 f0                	jne    80104580 <safestrcpy+0x1c>
    ;
  *s = 0;
80104590:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104593:	5b                   	pop    %ebx
80104594:	5e                   	pop    %esi
80104595:	5d                   	pop    %ebp
80104596:	c3                   	ret
80104597:	90                   	nop

80104598 <strlen>:

int
strlen(const char *s)
{
80104598:	55                   	push   %ebp
80104599:	89 e5                	mov    %esp,%ebp
8010459b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
8010459e:	31 c0                	xor    %eax,%eax
801045a0:	80 3a 00             	cmpb   $0x0,(%edx)
801045a3:	74 0a                	je     801045af <strlen+0x17>
801045a5:	8d 76 00             	lea    0x0(%esi),%esi
801045a8:	40                   	inc    %eax
801045a9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045ad:	75 f9                	jne    801045a8 <strlen+0x10>
    ;
  return n;
}
801045af:	5d                   	pop    %ebp
801045b0:	c3                   	ret

801045b1 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045b5:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801045b9:	55                   	push   %ebp
  pushl %ebx
801045ba:	53                   	push   %ebx
  pushl %esi
801045bb:	56                   	push   %esi
  pushl %edi
801045bc:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045bd:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045bf:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801045c1:	5f                   	pop    %edi
  popl %esi
801045c2:	5e                   	pop    %esi
  popl %ebx
801045c3:	5b                   	pop    %ebx
  popl %ebp
801045c4:	5d                   	pop    %ebp
  ret
801045c5:	c3                   	ret
801045c6:	66 90                	xchg   %ax,%ax

801045c8 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045c8:	55                   	push   %ebp
801045c9:	89 e5                	mov    %esp,%ebp
801045cb:	53                   	push   %ebx
801045cc:	50                   	push   %eax
801045cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801045d0:	e8 cb ef ff ff       	call   801035a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045d5:	8b 00                	mov    (%eax),%eax
801045d7:	39 c3                	cmp    %eax,%ebx
801045d9:	73 15                	jae    801045f0 <fetchint+0x28>
801045db:	8d 53 04             	lea    0x4(%ebx),%edx
801045de:	39 d0                	cmp    %edx,%eax
801045e0:	72 0e                	jb     801045f0 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801045e2:	8b 13                	mov    (%ebx),%edx
801045e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801045e7:	89 10                	mov    %edx,(%eax)
  return 0;
801045e9:	31 c0                	xor    %eax,%eax
}
801045eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045ee:	c9                   	leave
801045ef:	c3                   	ret
    return -1;
801045f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f5:	eb f4                	jmp    801045eb <fetchint+0x23>
801045f7:	90                   	nop

801045f8 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801045f8:	55                   	push   %ebp
801045f9:	89 e5                	mov    %esp,%ebp
801045fb:	53                   	push   %ebx
801045fc:	50                   	push   %eax
801045fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104600:	e8 9b ef ff ff       	call   801035a0 <myproc>

  if(addr >= curproc->sz)
80104605:	3b 18                	cmp    (%eax),%ebx
80104607:	73 23                	jae    8010462c <fetchstr+0x34>
    return -1;
  *pp = (char*)addr;
80104609:	8b 55 0c             	mov    0xc(%ebp),%edx
8010460c:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010460e:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104610:	39 d3                	cmp    %edx,%ebx
80104612:	73 18                	jae    8010462c <fetchstr+0x34>
80104614:	89 d8                	mov    %ebx,%eax
80104616:	eb 05                	jmp    8010461d <fetchstr+0x25>
80104618:	40                   	inc    %eax
80104619:	39 d0                	cmp    %edx,%eax
8010461b:	73 0f                	jae    8010462c <fetchstr+0x34>
    if(*s == 0)
8010461d:	80 38 00             	cmpb   $0x0,(%eax)
80104620:	75 f6                	jne    80104618 <fetchstr+0x20>
      return s - *pp;
80104622:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104627:	c9                   	leave
80104628:	c3                   	ret
80104629:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
8010462c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104634:	c9                   	leave
80104635:	c3                   	ret
80104636:	66 90                	xchg   %ax,%ax

80104638 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104638:	55                   	push   %ebp
80104639:	89 e5                	mov    %esp,%ebp
8010463b:	56                   	push   %esi
8010463c:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010463d:	e8 5e ef ff ff       	call   801035a0 <myproc>
80104642:	8b 40 34             	mov    0x34(%eax),%eax
80104645:	8b 40 44             	mov    0x44(%eax),%eax
80104648:	8b 55 08             	mov    0x8(%ebp),%edx
8010464b:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
8010464e:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
80104651:	e8 4a ef ff ff       	call   801035a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104656:	8b 00                	mov    (%eax),%eax
80104658:	39 c6                	cmp    %eax,%esi
8010465a:	73 18                	jae    80104674 <argint+0x3c>
8010465c:	8d 53 08             	lea    0x8(%ebx),%edx
8010465f:	39 d0                	cmp    %edx,%eax
80104661:	72 11                	jb     80104674 <argint+0x3c>
  *ip = *(int*)(addr);
80104663:	8b 53 04             	mov    0x4(%ebx),%edx
80104666:	8b 45 0c             	mov    0xc(%ebp),%eax
80104669:	89 10                	mov    %edx,(%eax)
  return 0;
8010466b:	31 c0                	xor    %eax,%eax
}
8010466d:	5b                   	pop    %ebx
8010466e:	5e                   	pop    %esi
8010466f:	5d                   	pop    %ebp
80104670:	c3                   	ret
80104671:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104679:	eb f2                	jmp    8010466d <argint+0x35>
8010467b:	90                   	nop

8010467c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010467c:	55                   	push   %ebp
8010467d:	89 e5                	mov    %esp,%ebp
8010467f:	57                   	push   %edi
80104680:	56                   	push   %esi
80104681:	53                   	push   %ebx
80104682:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104685:	e8 16 ef ff ff       	call   801035a0 <myproc>
8010468a:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010468c:	e8 0f ef ff ff       	call   801035a0 <myproc>
80104691:	8b 40 34             	mov    0x34(%eax),%eax
80104694:	8b 40 44             	mov    0x44(%eax),%eax
80104697:	8b 55 08             	mov    0x8(%ebp),%edx
8010469a:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
8010469d:	8d 7b 04             	lea    0x4(%ebx),%edi
  struct proc *curproc = myproc();
801046a0:	e8 fb ee ff ff       	call   801035a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046a5:	8b 00                	mov    (%eax),%eax
801046a7:	39 c7                	cmp    %eax,%edi
801046a9:	73 31                	jae    801046dc <argptr+0x60>
801046ab:	8d 4b 08             	lea    0x8(%ebx),%ecx
801046ae:	39 c8                	cmp    %ecx,%eax
801046b0:	72 2a                	jb     801046dc <argptr+0x60>
  *ip = *(int*)(addr);
801046b2:	8b 43 04             	mov    0x4(%ebx),%eax
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801046b5:	8b 55 10             	mov    0x10(%ebp),%edx
801046b8:	85 d2                	test   %edx,%edx
801046ba:	78 20                	js     801046dc <argptr+0x60>
801046bc:	8b 16                	mov    (%esi),%edx
801046be:	39 d0                	cmp    %edx,%eax
801046c0:	73 1a                	jae    801046dc <argptr+0x60>
801046c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046c5:	01 c3                	add    %eax,%ebx
801046c7:	39 da                	cmp    %ebx,%edx
801046c9:	72 11                	jb     801046dc <argptr+0x60>
    return -1;
  *pp = (char*)i;
801046cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801046ce:	89 02                	mov    %eax,(%edx)
  return 0;
801046d0:	31 c0                	xor    %eax,%eax
}
801046d2:	83 c4 0c             	add    $0xc,%esp
801046d5:	5b                   	pop    %ebx
801046d6:	5e                   	pop    %esi
801046d7:	5f                   	pop    %edi
801046d8:	5d                   	pop    %ebp
801046d9:	c3                   	ret
801046da:	66 90                	xchg   %ax,%ax
    return -1;
801046dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e1:	eb ef                	jmp    801046d2 <argptr+0x56>
801046e3:	90                   	nop

801046e4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046e9:	e8 b2 ee ff ff       	call   801035a0 <myproc>
801046ee:	8b 40 34             	mov    0x34(%eax),%eax
801046f1:	8b 40 44             	mov    0x44(%eax),%eax
801046f4:	8b 55 08             	mov    0x8(%ebp),%edx
801046f7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801046fa:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
801046fd:	e8 9e ee ff ff       	call   801035a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104702:	8b 00                	mov    (%eax),%eax
80104704:	39 c6                	cmp    %eax,%esi
80104706:	73 34                	jae    8010473c <argstr+0x58>
80104708:	8d 53 08             	lea    0x8(%ebx),%edx
8010470b:	39 d0                	cmp    %edx,%eax
8010470d:	72 2d                	jb     8010473c <argstr+0x58>
  *ip = *(int*)(addr);
8010470f:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104712:	e8 89 ee ff ff       	call   801035a0 <myproc>
  if(addr >= curproc->sz)
80104717:	3b 18                	cmp    (%eax),%ebx
80104719:	73 21                	jae    8010473c <argstr+0x58>
  *pp = (char*)addr;
8010471b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010471e:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104720:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104722:	39 d3                	cmp    %edx,%ebx
80104724:	73 16                	jae    8010473c <argstr+0x58>
80104726:	89 d8                	mov    %ebx,%eax
80104728:	eb 07                	jmp    80104731 <argstr+0x4d>
8010472a:	66 90                	xchg   %ax,%ax
8010472c:	40                   	inc    %eax
8010472d:	39 d0                	cmp    %edx,%eax
8010472f:	73 0b                	jae    8010473c <argstr+0x58>
    if(*s == 0)
80104731:	80 38 00             	cmpb   $0x0,(%eax)
80104734:	75 f6                	jne    8010472c <argstr+0x48>
      return s - *pp;
80104736:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104738:	5b                   	pop    %ebx
80104739:	5e                   	pop    %esi
8010473a:	5d                   	pop    %ebp
8010473b:	c3                   	ret
    return -1;
8010473c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104741:	5b                   	pop    %ebx
80104742:	5e                   	pop    %esi
80104743:	5d                   	pop    %ebp
80104744:	c3                   	ret
80104745:	8d 76 00             	lea    0x0(%esi),%esi

80104748 <syscall>:
[SYS_signal] sys_signal,
};

void
syscall(void)
{
80104748:	55                   	push   %ebp
80104749:	89 e5                	mov    %esp,%ebp
8010474b:	53                   	push   %ebx
8010474c:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
8010474d:	e8 4e ee ff ff       	call   801035a0 <myproc>
80104752:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104754:	8b 40 34             	mov    0x34(%eax),%eax
80104757:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010475a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010475d:	83 fa 15             	cmp    $0x15,%edx
80104760:	77 1a                	ja     8010477c <syscall+0x34>
80104762:	8b 14 85 e0 75 10 80 	mov    -0x7fef8a20(,%eax,4),%edx
80104769:	85 d2                	test   %edx,%edx
8010476b:	74 0f                	je     8010477c <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
8010476d:	ff d2                	call   *%edx
8010476f:	89 c2                	mov    %eax,%edx
80104771:	8b 43 34             	mov    0x34(%ebx),%eax
80104774:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010477a:	c9                   	leave
8010477b:	c3                   	ret
    cprintf("%d %s: unknown sys call %d\n",
8010477c:	50                   	push   %eax
            curproc->pid, curproc->name, num);
8010477d:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104783:	50                   	push   %eax
80104784:	ff 73 2c             	push   0x2c(%ebx)
80104787:	68 d3 6f 10 80       	push   $0x80106fd3
8010478c:	e8 8f be ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
80104791:	8b 43 34             	mov    0x34(%ebx),%eax
80104794:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010479b:	83 c4 10             	add    $0x10,%esp
}
8010479e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a1:	c9                   	leave
801047a2:	c3                   	ret
801047a3:	90                   	nop

801047a4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	57                   	push   %edi
801047a8:	56                   	push   %esi
801047a9:	53                   	push   %ebx
801047aa:	83 ec 34             	sub    $0x34,%esp
801047ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801047b0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801047b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047b6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047b9:	8d 7d da             	lea    -0x26(%ebp),%edi
801047bc:	57                   	push   %edi
801047bd:	50                   	push   %eax
801047be:	e8 c9 d6 ff ff       	call   80101e8c <nameiparent>
801047c3:	83 c4 10             	add    $0x10,%esp
801047c6:	85 c0                	test   %eax,%eax
801047c8:	74 5a                	je     80104824 <create+0x80>
801047ca:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
801047cc:	83 ec 0c             	sub    $0xc,%esp
801047cf:	50                   	push   %eax
801047d0:	e8 4b ce ff ff       	call   80101620 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801047d5:	83 c4 0c             	add    $0xc,%esp
801047d8:	6a 00                	push   $0x0
801047da:	57                   	push   %edi
801047db:	53                   	push   %ebx
801047dc:	e8 43 d3 ff ff       	call   80101b24 <dirlookup>
801047e1:	89 c6                	mov    %eax,%esi
801047e3:	83 c4 10             	add    $0x10,%esp
801047e6:	85 c0                	test   %eax,%eax
801047e8:	74 46                	je     80104830 <create+0x8c>
    iunlockput(dp);
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	53                   	push   %ebx
801047ee:	e8 81 d0 ff ff       	call   80101874 <iunlockput>
    ilock(ip);
801047f3:	89 34 24             	mov    %esi,(%esp)
801047f6:	e8 25 ce ff ff       	call   80101620 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104803:	75 13                	jne    80104818 <create+0x74>
80104805:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010480a:	75 0c                	jne    80104818 <create+0x74>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010480c:	89 f0                	mov    %esi,%eax
8010480e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104811:	5b                   	pop    %ebx
80104812:	5e                   	pop    %esi
80104813:	5f                   	pop    %edi
80104814:	5d                   	pop    %ebp
80104815:	c3                   	ret
80104816:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	56                   	push   %esi
8010481c:	e8 53 d0 ff ff       	call   80101874 <iunlockput>
    return 0;
80104821:	83 c4 10             	add    $0x10,%esp
    return 0;
80104824:	31 f6                	xor    %esi,%esi
}
80104826:	89 f0                	mov    %esi,%eax
80104828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010482b:	5b                   	pop    %ebx
8010482c:	5e                   	pop    %esi
8010482d:	5f                   	pop    %edi
8010482e:	5d                   	pop    %ebp
8010482f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104830:	83 ec 08             	sub    $0x8,%esp
80104833:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104837:	50                   	push   %eax
80104838:	ff 33                	push   (%ebx)
8010483a:	e8 89 cc ff ff       	call   801014c8 <ialloc>
8010483f:	89 c6                	mov    %eax,%esi
80104841:	83 c4 10             	add    $0x10,%esp
80104844:	85 c0                	test   %eax,%eax
80104846:	0f 84 a0 00 00 00    	je     801048ec <create+0x148>
  ilock(ip);
8010484c:	83 ec 0c             	sub    $0xc,%esp
8010484f:	50                   	push   %eax
80104850:	e8 cb cd ff ff       	call   80101620 <ilock>
  ip->major = major;
80104855:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104858:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010485c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010485f:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104863:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
80104869:	89 34 24             	mov    %esi,(%esp)
8010486c:	e8 07 cd ff ff       	call   80101578 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104871:	83 c4 10             	add    $0x10,%esp
80104874:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104879:	74 29                	je     801048a4 <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
8010487b:	50                   	push   %eax
8010487c:	ff 76 04             	push   0x4(%esi)
8010487f:	57                   	push   %edi
80104880:	53                   	push   %ebx
80104881:	e8 3e d5 ff ff       	call   80101dc4 <dirlink>
80104886:	83 c4 10             	add    $0x10,%esp
80104889:	85 c0                	test   %eax,%eax
8010488b:	78 6c                	js     801048f9 <create+0x155>
  iunlockput(dp);
8010488d:	83 ec 0c             	sub    $0xc,%esp
80104890:	53                   	push   %ebx
80104891:	e8 de cf ff ff       	call   80101874 <iunlockput>
  return ip;
80104896:	83 c4 10             	add    $0x10,%esp
}
80104899:	89 f0                	mov    %esi,%eax
8010489b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010489e:	5b                   	pop    %ebx
8010489f:	5e                   	pop    %esi
801048a0:	5f                   	pop    %edi
801048a1:	5d                   	pop    %ebp
801048a2:	c3                   	ret
801048a3:	90                   	nop
    dp->nlink++;  // for ".."
801048a4:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	53                   	push   %ebx
801048ac:	e8 c7 cc ff ff       	call   80101578 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801048b1:	83 c4 0c             	add    $0xc,%esp
801048b4:	ff 76 04             	push   0x4(%esi)
801048b7:	68 0b 70 10 80       	push   $0x8010700b
801048bc:	56                   	push   %esi
801048bd:	e8 02 d5 ff ff       	call   80101dc4 <dirlink>
801048c2:	83 c4 10             	add    $0x10,%esp
801048c5:	85 c0                	test   %eax,%eax
801048c7:	78 16                	js     801048df <create+0x13b>
801048c9:	52                   	push   %edx
801048ca:	ff 73 04             	push   0x4(%ebx)
801048cd:	68 0a 70 10 80       	push   $0x8010700a
801048d2:	56                   	push   %esi
801048d3:	e8 ec d4 ff ff       	call   80101dc4 <dirlink>
801048d8:	83 c4 10             	add    $0x10,%esp
801048db:	85 c0                	test   %eax,%eax
801048dd:	79 9c                	jns    8010487b <create+0xd7>
      panic("create dots");
801048df:	83 ec 0c             	sub    $0xc,%esp
801048e2:	68 fe 6f 10 80       	push   $0x80106ffe
801048e7:	e8 4c ba ff ff       	call   80100338 <panic>
    panic("create: ialloc");
801048ec:	83 ec 0c             	sub    $0xc,%esp
801048ef:	68 ef 6f 10 80       	push   $0x80106fef
801048f4:	e8 3f ba ff ff       	call   80100338 <panic>
    panic("create: dirlink");
801048f9:	83 ec 0c             	sub    $0xc,%esp
801048fc:	68 0d 70 10 80       	push   $0x8010700d
80104901:	e8 32 ba ff ff       	call   80100338 <panic>
80104906:	66 90                	xchg   %ax,%ax

80104908 <sys_dup>:
{
80104908:	55                   	push   %ebp
80104909:	89 e5                	mov    %esp,%ebp
8010490b:	56                   	push   %esi
8010490c:	53                   	push   %ebx
8010490d:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104910:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104913:	50                   	push   %eax
80104914:	6a 00                	push   $0x0
80104916:	e8 1d fd ff ff       	call   80104638 <argint>
8010491b:	83 c4 10             	add    $0x10,%esp
8010491e:	85 c0                	test   %eax,%eax
80104920:	78 2c                	js     8010494e <sys_dup+0x46>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104922:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104926:	77 26                	ja     8010494e <sys_dup+0x46>
80104928:	e8 73 ec ff ff       	call   801035a0 <myproc>
8010492d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104930:	8b 74 90 44          	mov    0x44(%eax,%edx,4),%esi
80104934:	85 f6                	test   %esi,%esi
80104936:	74 16                	je     8010494e <sys_dup+0x46>
  struct proc *curproc = myproc();
80104938:	e8 63 ec ff ff       	call   801035a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010493d:	31 db                	xor    %ebx,%ebx
8010493f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104940:	8b 54 98 44          	mov    0x44(%eax,%ebx,4),%edx
80104944:	85 d2                	test   %edx,%edx
80104946:	74 10                	je     80104958 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104948:	43                   	inc    %ebx
80104949:	83 fb 10             	cmp    $0x10,%ebx
8010494c:	75 f2                	jne    80104940 <sys_dup+0x38>
    return -1;
8010494e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104953:	eb 13                	jmp    80104968 <sys_dup+0x60>
80104955:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104958:	89 74 98 44          	mov    %esi,0x44(%eax,%ebx,4)
  filedup(f);
8010495c:	83 ec 0c             	sub    $0xc,%esp
8010495f:	56                   	push   %esi
80104960:	e8 a3 c4 ff ff       	call   80100e08 <filedup>
  return fd;
80104965:	83 c4 10             	add    $0x10,%esp
}
80104968:	89 d8                	mov    %ebx,%eax
8010496a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010496d:	5b                   	pop    %ebx
8010496e:	5e                   	pop    %esi
8010496f:	5d                   	pop    %ebp
80104970:	c3                   	ret
80104971:	8d 76 00             	lea    0x0(%esi),%esi

80104974 <sys_read>:
{
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	56                   	push   %esi
80104978:	53                   	push   %ebx
80104979:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010497c:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010497f:	53                   	push   %ebx
80104980:	6a 00                	push   $0x0
80104982:	e8 b1 fc ff ff       	call   80104638 <argint>
80104987:	83 c4 10             	add    $0x10,%esp
8010498a:	85 c0                	test   %eax,%eax
8010498c:	78 56                	js     801049e4 <sys_read+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010498e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104992:	77 50                	ja     801049e4 <sys_read+0x70>
80104994:	e8 07 ec ff ff       	call   801035a0 <myproc>
80104999:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010499c:	8b 74 90 44          	mov    0x44(%eax,%edx,4),%esi
801049a0:	85 f6                	test   %esi,%esi
801049a2:	74 40                	je     801049e4 <sys_read+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049a4:	83 ec 08             	sub    $0x8,%esp
801049a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049aa:	50                   	push   %eax
801049ab:	6a 02                	push   $0x2
801049ad:	e8 86 fc ff ff       	call   80104638 <argint>
801049b2:	83 c4 10             	add    $0x10,%esp
801049b5:	85 c0                	test   %eax,%eax
801049b7:	78 2b                	js     801049e4 <sys_read+0x70>
801049b9:	52                   	push   %edx
801049ba:	ff 75 f0             	push   -0x10(%ebp)
801049bd:	53                   	push   %ebx
801049be:	6a 01                	push   $0x1
801049c0:	e8 b7 fc ff ff       	call   8010467c <argptr>
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	85 c0                	test   %eax,%eax
801049ca:	78 18                	js     801049e4 <sys_read+0x70>
  return fileread(f, p, n);
801049cc:	50                   	push   %eax
801049cd:	ff 75 f0             	push   -0x10(%ebp)
801049d0:	ff 75 f4             	push   -0xc(%ebp)
801049d3:	56                   	push   %esi
801049d4:	e8 77 c5 ff ff       	call   80100f50 <fileread>
801049d9:	83 c4 10             	add    $0x10,%esp
}
801049dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049df:	5b                   	pop    %ebx
801049e0:	5e                   	pop    %esi
801049e1:	5d                   	pop    %ebp
801049e2:	c3                   	ret
801049e3:	90                   	nop
    return -1;
801049e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e9:	eb f1                	jmp    801049dc <sys_read+0x68>
801049eb:	90                   	nop

801049ec <sys_write>:
{
801049ec:	55                   	push   %ebp
801049ed:	89 e5                	mov    %esp,%ebp
801049ef:	56                   	push   %esi
801049f0:	53                   	push   %ebx
801049f1:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801049f4:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801049f7:	53                   	push   %ebx
801049f8:	6a 00                	push   $0x0
801049fa:	e8 39 fc ff ff       	call   80104638 <argint>
801049ff:	83 c4 10             	add    $0x10,%esp
80104a02:	85 c0                	test   %eax,%eax
80104a04:	78 56                	js     80104a5c <sys_write+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a06:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a0a:	77 50                	ja     80104a5c <sys_write+0x70>
80104a0c:	e8 8f eb ff ff       	call   801035a0 <myproc>
80104a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a14:	8b 74 90 44          	mov    0x44(%eax,%edx,4),%esi
80104a18:	85 f6                	test   %esi,%esi
80104a1a:	74 40                	je     80104a5c <sys_write+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a1c:	83 ec 08             	sub    $0x8,%esp
80104a1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a22:	50                   	push   %eax
80104a23:	6a 02                	push   $0x2
80104a25:	e8 0e fc ff ff       	call   80104638 <argint>
80104a2a:	83 c4 10             	add    $0x10,%esp
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	78 2b                	js     80104a5c <sys_write+0x70>
80104a31:	52                   	push   %edx
80104a32:	ff 75 f0             	push   -0x10(%ebp)
80104a35:	53                   	push   %ebx
80104a36:	6a 01                	push   $0x1
80104a38:	e8 3f fc ff ff       	call   8010467c <argptr>
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	85 c0                	test   %eax,%eax
80104a42:	78 18                	js     80104a5c <sys_write+0x70>
  return filewrite(f, p, n);
80104a44:	50                   	push   %eax
80104a45:	ff 75 f0             	push   -0x10(%ebp)
80104a48:	ff 75 f4             	push   -0xc(%ebp)
80104a4b:	56                   	push   %esi
80104a4c:	e8 8b c5 ff ff       	call   80100fdc <filewrite>
80104a51:	83 c4 10             	add    $0x10,%esp
}
80104a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a57:	5b                   	pop    %ebx
80104a58:	5e                   	pop    %esi
80104a59:	5d                   	pop    %ebp
80104a5a:	c3                   	ret
80104a5b:	90                   	nop
    return -1;
80104a5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a61:	eb f1                	jmp    80104a54 <sys_write+0x68>
80104a63:	90                   	nop

80104a64 <sys_close>:
{
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	53                   	push   %ebx
80104a69:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104a6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6f:	50                   	push   %eax
80104a70:	6a 00                	push   $0x0
80104a72:	e8 c1 fb ff ff       	call   80104638 <argint>
80104a77:	83 c4 10             	add    $0x10,%esp
80104a7a:	85 c0                	test   %eax,%eax
80104a7c:	78 3e                	js     80104abc <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a82:	77 38                	ja     80104abc <sys_close+0x58>
80104a84:	e8 17 eb ff ff       	call   801035a0 <myproc>
80104a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a8c:	8d 5a 10             	lea    0x10(%edx),%ebx
80104a8f:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
80104a93:	85 f6                	test   %esi,%esi
80104a95:	74 25                	je     80104abc <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104a97:	e8 04 eb ff ff       	call   801035a0 <myproc>
80104a9c:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80104aa3:	00 
  fileclose(f);
80104aa4:	83 ec 0c             	sub    $0xc,%esp
80104aa7:	56                   	push   %esi
80104aa8:	e8 9f c3 ff ff       	call   80100e4c <fileclose>
  return 0;
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	31 c0                	xor    %eax,%eax
}
80104ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab5:	5b                   	pop    %ebx
80104ab6:	5e                   	pop    %esi
80104ab7:	5d                   	pop    %ebp
80104ab8:	c3                   	ret
80104ab9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac1:	eb ef                	jmp    80104ab2 <sys_close+0x4e>
80104ac3:	90                   	nop

80104ac4 <sys_fstat>:
{
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	53                   	push   %ebx
80104ac9:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104acc:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104acf:	53                   	push   %ebx
80104ad0:	6a 00                	push   $0x0
80104ad2:	e8 61 fb ff ff       	call   80104638 <argint>
80104ad7:	83 c4 10             	add    $0x10,%esp
80104ada:	85 c0                	test   %eax,%eax
80104adc:	78 3e                	js     80104b1c <sys_fstat+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ae2:	77 38                	ja     80104b1c <sys_fstat+0x58>
80104ae4:	e8 b7 ea ff ff       	call   801035a0 <myproc>
80104ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aec:	8b 74 90 44          	mov    0x44(%eax,%edx,4),%esi
80104af0:	85 f6                	test   %esi,%esi
80104af2:	74 28                	je     80104b1c <sys_fstat+0x58>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104af4:	50                   	push   %eax
80104af5:	6a 14                	push   $0x14
80104af7:	53                   	push   %ebx
80104af8:	6a 01                	push   $0x1
80104afa:	e8 7d fb ff ff       	call   8010467c <argptr>
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	85 c0                	test   %eax,%eax
80104b04:	78 16                	js     80104b1c <sys_fstat+0x58>
  return filestat(f, st);
80104b06:	83 ec 08             	sub    $0x8,%esp
80104b09:	ff 75 f4             	push   -0xc(%ebp)
80104b0c:	56                   	push   %esi
80104b0d:	e8 fa c3 ff ff       	call   80100f0c <filestat>
80104b12:	83 c4 10             	add    $0x10,%esp
}
80104b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret
    return -1;
80104b1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b21:	eb f2                	jmp    80104b15 <sys_fstat+0x51>
80104b23:	90                   	nop

80104b24 <sys_link>:
{
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	57                   	push   %edi
80104b28:	56                   	push   %esi
80104b29:	53                   	push   %ebx
80104b2a:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b2d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b30:	50                   	push   %eax
80104b31:	6a 00                	push   $0x0
80104b33:	e8 ac fb ff ff       	call   801046e4 <argstr>
80104b38:	83 c4 10             	add    $0x10,%esp
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	0f 88 f2 00 00 00    	js     80104c35 <sys_link+0x111>
80104b43:	83 ec 08             	sub    $0x8,%esp
80104b46:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104b49:	50                   	push   %eax
80104b4a:	6a 01                	push   $0x1
80104b4c:	e8 93 fb ff ff       	call   801046e4 <argstr>
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	85 c0                	test   %eax,%eax
80104b56:	0f 88 d9 00 00 00    	js     80104c35 <sys_link+0x111>
  begin_op();
80104b5c:	e8 03 df ff ff       	call   80102a64 <begin_op>
  if((ip = namei(old)) == 0){
80104b61:	83 ec 0c             	sub    $0xc,%esp
80104b64:	ff 75 d4             	push   -0x2c(%ebp)
80104b67:	e8 08 d3 ff ff       	call   80101e74 <namei>
80104b6c:	89 c3                	mov    %eax,%ebx
80104b6e:	83 c4 10             	add    $0x10,%esp
80104b71:	85 c0                	test   %eax,%eax
80104b73:	0f 84 d6 00 00 00    	je     80104c4f <sys_link+0x12b>
  ilock(ip);
80104b79:	83 ec 0c             	sub    $0xc,%esp
80104b7c:	50                   	push   %eax
80104b7d:	e8 9e ca ff ff       	call   80101620 <ilock>
  if(ip->type == T_DIR){
80104b82:	83 c4 10             	add    $0x10,%esp
80104b85:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b8a:	0f 84 ac 00 00 00    	je     80104c3c <sys_link+0x118>
  ip->nlink++;
80104b90:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	53                   	push   %ebx
80104b98:	e8 db c9 ff ff       	call   80101578 <iupdate>
  iunlock(ip);
80104b9d:	89 1c 24             	mov    %ebx,(%esp)
80104ba0:	e8 43 cb ff ff       	call   801016e8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ba5:	5a                   	pop    %edx
80104ba6:	59                   	pop    %ecx
80104ba7:	8d 7d da             	lea    -0x26(%ebp),%edi
80104baa:	57                   	push   %edi
80104bab:	ff 75 d0             	push   -0x30(%ebp)
80104bae:	e8 d9 d2 ff ff       	call   80101e8c <nameiparent>
80104bb3:	89 c6                	mov    %eax,%esi
80104bb5:	83 c4 10             	add    $0x10,%esp
80104bb8:	85 c0                	test   %eax,%eax
80104bba:	74 54                	je     80104c10 <sys_link+0xec>
  ilock(dp);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	50                   	push   %eax
80104bc0:	e8 5b ca ff ff       	call   80101620 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	8b 03                	mov    (%ebx),%eax
80104bca:	39 06                	cmp    %eax,(%esi)
80104bcc:	75 36                	jne    80104c04 <sys_link+0xe0>
80104bce:	50                   	push   %eax
80104bcf:	ff 73 04             	push   0x4(%ebx)
80104bd2:	57                   	push   %edi
80104bd3:	56                   	push   %esi
80104bd4:	e8 eb d1 ff ff       	call   80101dc4 <dirlink>
80104bd9:	83 c4 10             	add    $0x10,%esp
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	78 24                	js     80104c04 <sys_link+0xe0>
  iunlockput(dp);
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	56                   	push   %esi
80104be4:	e8 8b cc ff ff       	call   80101874 <iunlockput>
  iput(ip);
80104be9:	89 1c 24             	mov    %ebx,(%esp)
80104bec:	e8 3b cb ff ff       	call   8010172c <iput>
  end_op();
80104bf1:	e8 d6 de ff ff       	call   80102acc <end_op>
  return 0;
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	31 c0                	xor    %eax,%eax
}
80104bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bfe:	5b                   	pop    %ebx
80104bff:	5e                   	pop    %esi
80104c00:	5f                   	pop    %edi
80104c01:	5d                   	pop    %ebp
80104c02:	c3                   	ret
80104c03:	90                   	nop
    iunlockput(dp);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	56                   	push   %esi
80104c08:	e8 67 cc ff ff       	call   80101874 <iunlockput>
    goto bad;
80104c0d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104c10:	83 ec 0c             	sub    $0xc,%esp
80104c13:	53                   	push   %ebx
80104c14:	e8 07 ca ff ff       	call   80101620 <ilock>
  ip->nlink--;
80104c19:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104c1d:	89 1c 24             	mov    %ebx,(%esp)
80104c20:	e8 53 c9 ff ff       	call   80101578 <iupdate>
  iunlockput(ip);
80104c25:	89 1c 24             	mov    %ebx,(%esp)
80104c28:	e8 47 cc ff ff       	call   80101874 <iunlockput>
  end_op();
80104c2d:	e8 9a de ff ff       	call   80102acc <end_op>
  return -1;
80104c32:	83 c4 10             	add    $0x10,%esp
    return -1;
80104c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3a:	eb bf                	jmp    80104bfb <sys_link+0xd7>
    iunlockput(ip);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	53                   	push   %ebx
80104c40:	e8 2f cc ff ff       	call   80101874 <iunlockput>
    end_op();
80104c45:	e8 82 de ff ff       	call   80102acc <end_op>
    return -1;
80104c4a:	83 c4 10             	add    $0x10,%esp
80104c4d:	eb e6                	jmp    80104c35 <sys_link+0x111>
    end_op();
80104c4f:	e8 78 de ff ff       	call   80102acc <end_op>
    return -1;
80104c54:	eb df                	jmp    80104c35 <sys_link+0x111>
80104c56:	66 90                	xchg   %ax,%ax

80104c58 <sys_unlink>:
{
80104c58:	55                   	push   %ebp
80104c59:	89 e5                	mov    %esp,%ebp
80104c5b:	57                   	push   %edi
80104c5c:	56                   	push   %esi
80104c5d:	53                   	push   %ebx
80104c5e:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104c61:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c64:	50                   	push   %eax
80104c65:	6a 00                	push   $0x0
80104c67:	e8 78 fa ff ff       	call   801046e4 <argstr>
80104c6c:	83 c4 10             	add    $0x10,%esp
80104c6f:	85 c0                	test   %eax,%eax
80104c71:	0f 88 50 01 00 00    	js     80104dc7 <sys_unlink+0x16f>
  begin_op();
80104c77:	e8 e8 dd ff ff       	call   80102a64 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c7c:	83 ec 08             	sub    $0x8,%esp
80104c7f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c82:	53                   	push   %ebx
80104c83:	ff 75 c0             	push   -0x40(%ebp)
80104c86:	e8 01 d2 ff ff       	call   80101e8c <nameiparent>
80104c8b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c8e:	83 c4 10             	add    $0x10,%esp
80104c91:	85 c0                	test   %eax,%eax
80104c93:	0f 84 4f 01 00 00    	je     80104de8 <sys_unlink+0x190>
  ilock(dp);
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80104c9f:	57                   	push   %edi
80104ca0:	e8 7b c9 ff ff       	call   80101620 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ca5:	59                   	pop    %ecx
80104ca6:	5e                   	pop    %esi
80104ca7:	68 0b 70 10 80       	push   $0x8010700b
80104cac:	53                   	push   %ebx
80104cad:	e8 5a ce ff ff       	call   80101b0c <namecmp>
80104cb2:	83 c4 10             	add    $0x10,%esp
80104cb5:	85 c0                	test   %eax,%eax
80104cb7:	0f 84 f7 00 00 00    	je     80104db4 <sys_unlink+0x15c>
80104cbd:	83 ec 08             	sub    $0x8,%esp
80104cc0:	68 0a 70 10 80       	push   $0x8010700a
80104cc5:	53                   	push   %ebx
80104cc6:	e8 41 ce ff ff       	call   80101b0c <namecmp>
80104ccb:	83 c4 10             	add    $0x10,%esp
80104cce:	85 c0                	test   %eax,%eax
80104cd0:	0f 84 de 00 00 00    	je     80104db4 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104cd6:	52                   	push   %edx
80104cd7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104cda:	50                   	push   %eax
80104cdb:	53                   	push   %ebx
80104cdc:	57                   	push   %edi
80104cdd:	e8 42 ce ff ff       	call   80101b24 <dirlookup>
80104ce2:	89 c3                	mov    %eax,%ebx
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	0f 84 c5 00 00 00    	je     80104db4 <sys_unlink+0x15c>
  ilock(ip);
80104cef:	83 ec 0c             	sub    $0xc,%esp
80104cf2:	50                   	push   %eax
80104cf3:	e8 28 c9 ff ff       	call   80101620 <ilock>
  if(ip->nlink < 1)
80104cf8:	83 c4 10             	add    $0x10,%esp
80104cfb:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d00:	0f 8e f6 00 00 00    	jle    80104dfc <sys_unlink+0x1a4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d06:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d0b:	74 67                	je     80104d74 <sys_unlink+0x11c>
80104d0d:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
80104d10:	50                   	push   %eax
80104d11:	6a 10                	push   $0x10
80104d13:	6a 00                	push   $0x0
80104d15:	57                   	push   %edi
80104d16:	e8 01 f7 ff ff       	call   8010441c <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d1b:	6a 10                	push   $0x10
80104d1d:	ff 75 c4             	push   -0x3c(%ebp)
80104d20:	57                   	push   %edi
80104d21:	ff 75 b4             	push   -0x4c(%ebp)
80104d24:	e8 c7 cc ff ff       	call   801019f0 <writei>
80104d29:	83 c4 20             	add    $0x20,%esp
80104d2c:	83 f8 10             	cmp    $0x10,%eax
80104d2f:	0f 85 d4 00 00 00    	jne    80104e09 <sys_unlink+0x1b1>
  if(ip->type == T_DIR){
80104d35:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d3a:	0f 84 90 00 00 00    	je     80104dd0 <sys_unlink+0x178>
  iunlockput(dp);
80104d40:	83 ec 0c             	sub    $0xc,%esp
80104d43:	ff 75 b4             	push   -0x4c(%ebp)
80104d46:	e8 29 cb ff ff       	call   80101874 <iunlockput>
  ip->nlink--;
80104d4b:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104d4f:	89 1c 24             	mov    %ebx,(%esp)
80104d52:	e8 21 c8 ff ff       	call   80101578 <iupdate>
  iunlockput(ip);
80104d57:	89 1c 24             	mov    %ebx,(%esp)
80104d5a:	e8 15 cb ff ff       	call   80101874 <iunlockput>
  end_op();
80104d5f:	e8 68 dd ff ff       	call   80102acc <end_op>
  return 0;
80104d64:	83 c4 10             	add    $0x10,%esp
80104d67:	31 c0                	xor    %eax,%eax
}
80104d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d6c:	5b                   	pop    %ebx
80104d6d:	5e                   	pop    %esi
80104d6e:	5f                   	pop    %edi
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret
80104d71:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d74:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d78:	76 93                	jbe    80104d0d <sys_unlink+0xb5>
80104d7a:	be 20 00 00 00       	mov    $0x20,%esi
80104d7f:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104d82:	eb 08                	jmp    80104d8c <sys_unlink+0x134>
80104d84:	83 c6 10             	add    $0x10,%esi
80104d87:	3b 73 58             	cmp    0x58(%ebx),%esi
80104d8a:	73 84                	jae    80104d10 <sys_unlink+0xb8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d8c:	6a 10                	push   $0x10
80104d8e:	56                   	push   %esi
80104d8f:	57                   	push   %edi
80104d90:	53                   	push   %ebx
80104d91:	e8 5a cb ff ff       	call   801018f0 <readi>
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	83 f8 10             	cmp    $0x10,%eax
80104d9c:	75 51                	jne    80104def <sys_unlink+0x197>
    if(de.inum != 0)
80104d9e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104da3:	74 df                	je     80104d84 <sys_unlink+0x12c>
    iunlockput(ip);
80104da5:	83 ec 0c             	sub    $0xc,%esp
80104da8:	53                   	push   %ebx
80104da9:	e8 c6 ca ff ff       	call   80101874 <iunlockput>
    goto bad;
80104dae:	83 c4 10             	add    $0x10,%esp
80104db1:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80104db4:	83 ec 0c             	sub    $0xc,%esp
80104db7:	ff 75 b4             	push   -0x4c(%ebp)
80104dba:	e8 b5 ca ff ff       	call   80101874 <iunlockput>
  end_op();
80104dbf:	e8 08 dd ff ff       	call   80102acc <end_op>
  return -1;
80104dc4:	83 c4 10             	add    $0x10,%esp
    return -1;
80104dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dcc:	eb 9b                	jmp    80104d69 <sys_unlink+0x111>
80104dce:	66 90                	xchg   %ax,%ax
    dp->nlink--;
80104dd0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dd3:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
80104dd7:	83 ec 0c             	sub    $0xc,%esp
80104dda:	50                   	push   %eax
80104ddb:	e8 98 c7 ff ff       	call   80101578 <iupdate>
80104de0:	83 c4 10             	add    $0x10,%esp
80104de3:	e9 58 ff ff ff       	jmp    80104d40 <sys_unlink+0xe8>
    end_op();
80104de8:	e8 df dc ff ff       	call   80102acc <end_op>
    return -1;
80104ded:	eb d8                	jmp    80104dc7 <sys_unlink+0x16f>
      panic("isdirempty: readi");
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	68 2f 70 10 80       	push   $0x8010702f
80104df7:	e8 3c b5 ff ff       	call   80100338 <panic>
    panic("unlink: nlink < 1");
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	68 1d 70 10 80       	push   $0x8010701d
80104e04:	e8 2f b5 ff ff       	call   80100338 <panic>
    panic("unlink: writei");
80104e09:	83 ec 0c             	sub    $0xc,%esp
80104e0c:	68 41 70 10 80       	push   $0x80107041
80104e11:	e8 22 b5 ff ff       	call   80100338 <panic>
80104e16:	66 90                	xchg   %ax,%ax

80104e18 <sys_open>:

int
sys_open(void)
{
80104e18:	55                   	push   %ebp
80104e19:	89 e5                	mov    %esp,%ebp
80104e1b:	57                   	push   %edi
80104e1c:	56                   	push   %esi
80104e1d:	53                   	push   %ebx
80104e1e:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e21:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e24:	50                   	push   %eax
80104e25:	6a 00                	push   $0x0
80104e27:	e8 b8 f8 ff ff       	call   801046e4 <argstr>
80104e2c:	83 c4 10             	add    $0x10,%esp
80104e2f:	85 c0                	test   %eax,%eax
80104e31:	0f 88 8c 00 00 00    	js     80104ec3 <sys_open+0xab>
80104e37:	83 ec 08             	sub    $0x8,%esp
80104e3a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e3d:	50                   	push   %eax
80104e3e:	6a 01                	push   $0x1
80104e40:	e8 f3 f7 ff ff       	call   80104638 <argint>
80104e45:	83 c4 10             	add    $0x10,%esp
80104e48:	85 c0                	test   %eax,%eax
80104e4a:	78 77                	js     80104ec3 <sys_open+0xab>
    return -1;

  begin_op();
80104e4c:	e8 13 dc ff ff       	call   80102a64 <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
80104e54:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e58:	75 72                	jne    80104ecc <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e5a:	83 ec 0c             	sub    $0xc,%esp
80104e5d:	50                   	push   %eax
80104e5e:	e8 11 d0 ff ff       	call   80101e74 <namei>
80104e63:	89 c6                	mov    %eax,%esi
80104e65:	83 c4 10             	add    $0x10,%esp
80104e68:	85 c0                	test   %eax,%eax
80104e6a:	74 7a                	je     80104ee6 <sys_open+0xce>
      end_op();
      return -1;
    }
    ilock(ip);
80104e6c:	83 ec 0c             	sub    $0xc,%esp
80104e6f:	50                   	push   %eax
80104e70:	e8 ab c7 ff ff       	call   80101620 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e7d:	0f 84 b1 00 00 00    	je     80104f34 <sys_open+0x11c>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e83:	e8 18 bf ff ff       	call   80100da0 <filealloc>
80104e88:	89 c7                	mov    %eax,%edi
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	74 24                	je     80104eb2 <sys_open+0x9a>
  struct proc *curproc = myproc();
80104e8e:	e8 0d e7 ff ff       	call   801035a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e93:	31 db                	xor    %ebx,%ebx
80104e95:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104e98:	8b 54 98 44          	mov    0x44(%eax,%ebx,4),%edx
80104e9c:	85 d2                	test   %edx,%edx
80104e9e:	74 50                	je     80104ef0 <sys_open+0xd8>
  for(fd = 0; fd < NOFILE; fd++){
80104ea0:	43                   	inc    %ebx
80104ea1:	83 fb 10             	cmp    $0x10,%ebx
80104ea4:	75 f2                	jne    80104e98 <sys_open+0x80>
    if(f)
      fileclose(f);
80104ea6:	83 ec 0c             	sub    $0xc,%esp
80104ea9:	57                   	push   %edi
80104eaa:	e8 9d bf ff ff       	call   80100e4c <fileclose>
80104eaf:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104eb2:	83 ec 0c             	sub    $0xc,%esp
80104eb5:	56                   	push   %esi
80104eb6:	e8 b9 c9 ff ff       	call   80101874 <iunlockput>
    end_op();
80104ebb:	e8 0c dc ff ff       	call   80102acc <end_op>
    return -1;
80104ec0:	83 c4 10             	add    $0x10,%esp
    return -1;
80104ec3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ec8:	eb 5f                	jmp    80104f29 <sys_open+0x111>
80104eca:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104ecc:	83 ec 0c             	sub    $0xc,%esp
80104ecf:	6a 00                	push   $0x0
80104ed1:	31 c9                	xor    %ecx,%ecx
80104ed3:	ba 02 00 00 00       	mov    $0x2,%edx
80104ed8:	e8 c7 f8 ff ff       	call   801047a4 <create>
80104edd:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	75 9d                	jne    80104e83 <sys_open+0x6b>
      end_op();
80104ee6:	e8 e1 db ff ff       	call   80102acc <end_op>
      return -1;
80104eeb:	eb d6                	jmp    80104ec3 <sys_open+0xab>
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104ef0:	89 7c 98 44          	mov    %edi,0x44(%eax,%ebx,4)
  }
  iunlock(ip);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	56                   	push   %esi
80104ef8:	e8 eb c7 ff ff       	call   801016e8 <iunlock>
  end_op();
80104efd:	e8 ca db ff ff       	call   80102acc <end_op>

  f->type = FD_INODE;
80104f02:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
80104f08:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80104f0b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104f12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f15:	89 d0                	mov    %edx,%eax
80104f17:	f7 d0                	not    %eax
80104f19:	83 e0 01             	and    $0x1,%eax
80104f1c:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	83 e2 03             	and    $0x3,%edx
80104f25:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80104f29:	89 d8                	mov    %ebx,%eax
80104f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f2e:	5b                   	pop    %ebx
80104f2f:	5e                   	pop    %esi
80104f30:	5f                   	pop    %edi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret
80104f33:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104f37:	85 c9                	test   %ecx,%ecx
80104f39:	0f 84 44 ff ff ff    	je     80104e83 <sys_open+0x6b>
80104f3f:	e9 6e ff ff ff       	jmp    80104eb2 <sys_open+0x9a>

80104f44 <sys_mkdir>:

int
sys_mkdir(void)
{
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f4a:	e8 15 db ff ff       	call   80102a64 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f4f:	83 ec 08             	sub    $0x8,%esp
80104f52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f55:	50                   	push   %eax
80104f56:	6a 00                	push   $0x0
80104f58:	e8 87 f7 ff ff       	call   801046e4 <argstr>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	78 30                	js     80104f94 <sys_mkdir+0x50>
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	6a 00                	push   $0x0
80104f69:	31 c9                	xor    %ecx,%ecx
80104f6b:	ba 01 00 00 00       	mov    $0x1,%edx
80104f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f73:	e8 2c f8 ff ff       	call   801047a4 <create>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	74 15                	je     80104f94 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	50                   	push   %eax
80104f83:	e8 ec c8 ff ff       	call   80101874 <iunlockput>
  end_op();
80104f88:	e8 3f db ff ff       	call   80102acc <end_op>
  return 0;
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	31 c0                	xor    %eax,%eax
}
80104f92:	c9                   	leave
80104f93:	c3                   	ret
    end_op();
80104f94:	e8 33 db ff ff       	call   80102acc <end_op>
    return -1;
80104f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f9e:	c9                   	leave
80104f9f:	c3                   	ret

80104fa0 <sys_mknod>:

int
sys_mknod(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104fa6:	e8 b9 da ff ff       	call   80102a64 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104fab:	83 ec 08             	sub    $0x8,%esp
80104fae:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104fb1:	50                   	push   %eax
80104fb2:	6a 00                	push   $0x0
80104fb4:	e8 2b f7 ff ff       	call   801046e4 <argstr>
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	85 c0                	test   %eax,%eax
80104fbe:	78 60                	js     80105020 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fc6:	50                   	push   %eax
80104fc7:	6a 01                	push   $0x1
80104fc9:	e8 6a f6 ff ff       	call   80104638 <argint>
  if((argstr(0, &path)) < 0 ||
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	85 c0                	test   %eax,%eax
80104fd3:	78 4b                	js     80105020 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104fd5:	83 ec 08             	sub    $0x8,%esp
80104fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fdb:	50                   	push   %eax
80104fdc:	6a 02                	push   $0x2
80104fde:	e8 55 f6 ff ff       	call   80104638 <argint>
     argint(1, &major) < 0 ||
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 36                	js     80105020 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fea:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104fee:	83 ec 0c             	sub    $0xc,%esp
80104ff1:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104ff5:	50                   	push   %eax
80104ff6:	ba 03 00 00 00       	mov    $0x3,%edx
80104ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ffe:	e8 a1 f7 ff ff       	call   801047a4 <create>
     argint(2, &minor) < 0 ||
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	74 16                	je     80105020 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010500a:	83 ec 0c             	sub    $0xc,%esp
8010500d:	50                   	push   %eax
8010500e:	e8 61 c8 ff ff       	call   80101874 <iunlockput>
  end_op();
80105013:	e8 b4 da ff ff       	call   80102acc <end_op>
  return 0;
80105018:	83 c4 10             	add    $0x10,%esp
8010501b:	31 c0                	xor    %eax,%eax
}
8010501d:	c9                   	leave
8010501e:	c3                   	ret
8010501f:	90                   	nop
    end_op();
80105020:	e8 a7 da ff ff       	call   80102acc <end_op>
    return -1;
80105025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010502a:	c9                   	leave
8010502b:	c3                   	ret

8010502c <sys_chdir>:

int
sys_chdir(void)
{
8010502c:	55                   	push   %ebp
8010502d:	89 e5                	mov    %esp,%ebp
8010502f:	56                   	push   %esi
80105030:	53                   	push   %ebx
80105031:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105034:	e8 67 e5 ff ff       	call   801035a0 <myproc>
80105039:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010503b:	e8 24 da ff ff       	call   80102a64 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105040:	83 ec 08             	sub    $0x8,%esp
80105043:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105046:	50                   	push   %eax
80105047:	6a 00                	push   $0x0
80105049:	e8 96 f6 ff ff       	call   801046e4 <argstr>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	85 c0                	test   %eax,%eax
80105053:	78 6b                	js     801050c0 <sys_chdir+0x94>
80105055:	83 ec 0c             	sub    $0xc,%esp
80105058:	ff 75 f4             	push   -0xc(%ebp)
8010505b:	e8 14 ce ff ff       	call   80101e74 <namei>
80105060:	89 c3                	mov    %eax,%ebx
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	74 57                	je     801050c0 <sys_chdir+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
80105069:	83 ec 0c             	sub    $0xc,%esp
8010506c:	50                   	push   %eax
8010506d:	e8 ae c5 ff ff       	call   80101620 <ilock>
  if(ip->type != T_DIR){
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010507a:	75 2c                	jne    801050a8 <sys_chdir+0x7c>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010507c:	83 ec 0c             	sub    $0xc,%esp
8010507f:	53                   	push   %ebx
80105080:	e8 63 c6 ff ff       	call   801016e8 <iunlock>
  iput(curproc->cwd);
80105085:	58                   	pop    %eax
80105086:	ff b6 84 00 00 00    	push   0x84(%esi)
8010508c:	e8 9b c6 ff ff       	call   8010172c <iput>
  end_op();
80105091:	e8 36 da ff ff       	call   80102acc <end_op>
  curproc->cwd = ip;
80105096:	89 9e 84 00 00 00    	mov    %ebx,0x84(%esi)
  return 0;
8010509c:	83 c4 10             	add    $0x10,%esp
8010509f:	31 c0                	xor    %eax,%eax
}
801050a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a4:	5b                   	pop    %ebx
801050a5:	5e                   	pop    %esi
801050a6:	5d                   	pop    %ebp
801050a7:	c3                   	ret
    iunlockput(ip);
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	53                   	push   %ebx
801050ac:	e8 c3 c7 ff ff       	call   80101874 <iunlockput>
    end_op();
801050b1:	e8 16 da ff ff       	call   80102acc <end_op>
    return -1;
801050b6:	83 c4 10             	add    $0x10,%esp
    return -1;
801050b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050be:	eb e1                	jmp    801050a1 <sys_chdir+0x75>
    end_op();
801050c0:	e8 07 da ff ff       	call   80102acc <end_op>
    return -1;
801050c5:	eb f2                	jmp    801050b9 <sys_chdir+0x8d>
801050c7:	90                   	nop

801050c8 <sys_exec>:

int
sys_exec(void)
{
801050c8:	55                   	push   %ebp
801050c9:	89 e5                	mov    %esp,%ebp
801050cb:	57                   	push   %edi
801050cc:	56                   	push   %esi
801050cd:	53                   	push   %ebx
801050ce:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801050d4:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801050da:	50                   	push   %eax
801050db:	6a 00                	push   $0x0
801050dd:	e8 02 f6 ff ff       	call   801046e4 <argstr>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 79                	js     80105162 <sys_exec+0x9a>
801050e9:	83 ec 08             	sub    $0x8,%esp
801050ec:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801050f2:	50                   	push   %eax
801050f3:	6a 01                	push   $0x1
801050f5:	e8 3e f5 ff ff       	call   80104638 <argint>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	78 61                	js     80105162 <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105101:	50                   	push   %eax
80105102:	68 80 00 00 00       	push   $0x80
80105107:	6a 00                	push   $0x0
80105109:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
8010510f:	57                   	push   %edi
80105110:	e8 07 f3 ff ff       	call   8010441c <memset>
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
8010511a:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010511c:	83 ec 08             	sub    $0x8,%esp
8010511f:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105125:	50                   	push   %eax
80105126:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010512c:	01 d8                	add    %ebx,%eax
8010512e:	50                   	push   %eax
8010512f:	e8 94 f4 ff ff       	call   801045c8 <fetchint>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	78 27                	js     80105162 <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
8010513b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105141:	85 c0                	test   %eax,%eax
80105143:	74 2b                	je     80105170 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105145:	83 ec 08             	sub    $0x8,%esp
80105148:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
8010514b:	52                   	push   %edx
8010514c:	50                   	push   %eax
8010514d:	e8 a6 f4 ff ff       	call   801045f8 <fetchstr>
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	85 c0                	test   %eax,%eax
80105157:	78 09                	js     80105162 <sys_exec+0x9a>
  for(i=0;; i++){
80105159:	46                   	inc    %esi
    if(i >= NELEM(argv))
8010515a:	83 c3 04             	add    $0x4,%ebx
8010515d:	83 fe 20             	cmp    $0x20,%esi
80105160:	75 ba                	jne    8010511c <sys_exec+0x54>
    return -1;
80105162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80105167:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010516a:	5b                   	pop    %ebx
8010516b:	5e                   	pop    %esi
8010516c:	5f                   	pop    %edi
8010516d:	5d                   	pop    %ebp
8010516e:	c3                   	ret
8010516f:	90                   	nop
      argv[i] = 0;
80105170:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
80105177:	00 00 00 00 
  return exec(path, argv);
8010517b:	83 ec 08             	sub    $0x8,%esp
8010517e:	57                   	push   %edi
8010517f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105185:	e8 9a b8 ff ff       	call   80100a24 <exec>
8010518a:	83 c4 10             	add    $0x10,%esp
}
8010518d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105190:	5b                   	pop    %ebx
80105191:	5e                   	pop    %esi
80105192:	5f                   	pop    %edi
80105193:	5d                   	pop    %ebp
80105194:	c3                   	ret
80105195:	8d 76 00             	lea    0x0(%esi),%esi

80105198 <sys_pipe>:

int
sys_pipe(void)
{
80105198:	55                   	push   %ebp
80105199:	89 e5                	mov    %esp,%ebp
8010519b:	57                   	push   %edi
8010519c:	56                   	push   %esi
8010519d:	53                   	push   %ebx
8010519e:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801051a1:	6a 08                	push   $0x8
801051a3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801051a6:	50                   	push   %eax
801051a7:	6a 00                	push   $0x0
801051a9:	e8 ce f4 ff ff       	call   8010467c <argptr>
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	85 c0                	test   %eax,%eax
801051b3:	78 7d                	js     80105232 <sys_pipe+0x9a>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801051b5:	83 ec 08             	sub    $0x8,%esp
801051b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051bb:	50                   	push   %eax
801051bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801051bf:	50                   	push   %eax
801051c0:	e8 af de ff ff       	call   80103074 <pipealloc>
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	85 c0                	test   %eax,%eax
801051ca:	78 66                	js     80105232 <sys_pipe+0x9a>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
801051cf:	e8 cc e3 ff ff       	call   801035a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051d4:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051d6:	8b 74 98 44          	mov    0x44(%eax,%ebx,4),%esi
801051da:	85 f6                	test   %esi,%esi
801051dc:	74 10                	je     801051ee <sys_pipe+0x56>
801051de:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
801051e0:	43                   	inc    %ebx
801051e1:	83 fb 10             	cmp    $0x10,%ebx
801051e4:	74 35                	je     8010521b <sys_pipe+0x83>
    if(curproc->ofile[fd] == 0){
801051e6:	8b 74 98 44          	mov    0x44(%eax,%ebx,4),%esi
801051ea:	85 f6                	test   %esi,%esi
801051ec:	75 f2                	jne    801051e0 <sys_pipe+0x48>
      curproc->ofile[fd] = f;
801051ee:	8d 73 10             	lea    0x10(%ebx),%esi
801051f1:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801051f8:	e8 a3 e3 ff ff       	call   801035a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051fd:	31 d2                	xor    %edx,%edx
801051ff:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105200:	8b 4c 90 44          	mov    0x44(%eax,%edx,4),%ecx
80105204:	85 c9                	test   %ecx,%ecx
80105206:	74 34                	je     8010523c <sys_pipe+0xa4>
  for(fd = 0; fd < NOFILE; fd++){
80105208:	42                   	inc    %edx
80105209:	83 fa 10             	cmp    $0x10,%edx
8010520c:	75 f2                	jne    80105200 <sys_pipe+0x68>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
8010520e:	e8 8d e3 ff ff       	call   801035a0 <myproc>
80105213:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
8010521a:	00 
    fileclose(rf);
8010521b:	83 ec 0c             	sub    $0xc,%esp
8010521e:	ff 75 e0             	push   -0x20(%ebp)
80105221:	e8 26 bc ff ff       	call   80100e4c <fileclose>
    fileclose(wf);
80105226:	58                   	pop    %eax
80105227:	ff 75 e4             	push   -0x1c(%ebp)
8010522a:	e8 1d bc ff ff       	call   80100e4c <fileclose>
    return -1;
8010522f:	83 c4 10             	add    $0x10,%esp
    return -1;
80105232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105237:	eb 14                	jmp    8010524d <sys_pipe+0xb5>
80105239:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
8010523c:	89 7c 90 44          	mov    %edi,0x44(%eax,%edx,4)
  }
  fd[0] = fd0;
80105240:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105243:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105245:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105248:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010524b:	31 c0                	xor    %eax,%eax
}
8010524d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105250:	5b                   	pop    %ebx
80105251:	5e                   	pop    %esi
80105252:	5f                   	pop    %edi
80105253:	5d                   	pop    %ebp
80105254:	c3                   	ret
80105255:	66 90                	xchg   %ax,%ax
80105257:	90                   	nop

80105258 <sys_signal>:

//     myproc()->signal_handler = (void*)handler;
//     return 0;
// }

int sys_signal(void) {
80105258:	55                   	push   %ebp
80105259:	89 e5                	mov    %esp,%ebp
8010525b:	83 ec 1c             	sub    $0x1c,%esp
    void (*handler)(void);
    
    if (argptr(0, (void*)&handler, sizeof(void*)) < 0)
8010525e:	6a 04                	push   $0x4
80105260:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105263:	50                   	push   %eax
80105264:	6a 00                	push   $0x0
80105266:	e8 11 f4 ff ff       	call   8010467c <argptr>
8010526b:	83 c4 10             	add    $0x10,%esp
8010526e:	85 c0                	test   %eax,%eax
80105270:	78 12                	js     80105284 <sys_signal+0x2c>
        return -1;

    myproc()->signal_handler = handler;
80105272:	e8 29 e3 ff ff       	call   801035a0 <myproc>
80105277:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010527a:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
8010527d:	31 c0                	xor    %eax,%eax
}
8010527f:	c9                   	leave
80105280:	c3                   	ret
80105281:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105289:	c9                   	leave
8010528a:	c3                   	ret
8010528b:	90                   	nop

8010528c <sys_fork>:


int
sys_fork(void)
{
  return fork();
8010528c:	e9 8b e4 ff ff       	jmp    8010371c <fork>
80105291:	8d 76 00             	lea    0x0(%esi),%esi

80105294 <sys_exit>:
}

int
sys_exit(void)
{
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	83 ec 08             	sub    $0x8,%esp
  exit();
8010529a:	e8 bd e8 ff ff       	call   80103b5c <exit>
  return 0;  // not reached
}
8010529f:	31 c0                	xor    %eax,%eax
801052a1:	c9                   	leave
801052a2:	c3                   	ret
801052a3:	90                   	nop

801052a4 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801052a4:	e9 07 eb ff ff       	jmp    80103db0 <wait>
801052a9:	8d 76 00             	lea    0x0(%esi),%esi

801052ac <sys_kill>:
}

int
sys_kill(void)
{
801052ac:	55                   	push   %ebp
801052ad:	89 e5                	mov    %esp,%ebp
801052af:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b5:	50                   	push   %eax
801052b6:	6a 00                	push   $0x0
801052b8:	e8 7b f3 ff ff       	call   80104638 <argint>
801052bd:	83 c4 10             	add    $0x10,%esp
801052c0:	85 c0                	test   %eax,%eax
801052c2:	78 10                	js     801052d4 <sys_kill+0x28>
    return -1;
  return kill(pid);
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	ff 75 f4             	push   -0xc(%ebp)
801052ca:	e8 2d ec ff ff       	call   80103efc <kill>
801052cf:	83 c4 10             	add    $0x10,%esp
}
801052d2:	c9                   	leave
801052d3:	c3                   	ret
    return -1;
801052d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d9:	c9                   	leave
801052da:	c3                   	ret
801052db:	90                   	nop

801052dc <sys_getpid>:

int
sys_getpid(void)
{
801052dc:	55                   	push   %ebp
801052dd:	89 e5                	mov    %esp,%ebp
801052df:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052e2:	e8 b9 e2 ff ff       	call   801035a0 <myproc>
801052e7:	8b 40 2c             	mov    0x2c(%eax),%eax
}
801052ea:	c9                   	leave
801052eb:	c3                   	ret

801052ec <sys_sbrk>:

int
sys_sbrk(void)
{
801052ec:	55                   	push   %ebp
801052ed:	89 e5                	mov    %esp,%ebp
801052ef:	53                   	push   %ebx
801052f0:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801052f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f6:	50                   	push   %eax
801052f7:	6a 00                	push   $0x0
801052f9:	e8 3a f3 ff ff       	call   80104638 <argint>
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	85 c0                	test   %eax,%eax
80105303:	78 23                	js     80105328 <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80105305:	e8 96 e2 ff ff       	call   801035a0 <myproc>
8010530a:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	ff 75 f4             	push   -0xc(%ebp)
80105312:	e8 95 e3 ff ff       	call   801036ac <growproc>
80105317:	83 c4 10             	add    $0x10,%esp
8010531a:	85 c0                	test   %eax,%eax
8010531c:	78 0a                	js     80105328 <sys_sbrk+0x3c>
    return -1;
  return addr;
}
8010531e:	89 d8                	mov    %ebx,%eax
80105320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105323:	c9                   	leave
80105324:	c3                   	ret
80105325:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105328:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010532d:	eb ef                	jmp    8010531e <sys_sbrk+0x32>
8010532f:	90                   	nop

80105330 <sys_sleep>:

int
sys_sleep(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	50                   	push   %eax
8010533b:	6a 00                	push   $0x0
8010533d:	e8 f6 f2 ff ff       	call   80104638 <argint>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	85 c0                	test   %eax,%eax
80105347:	78 5c                	js     801053a5 <sys_sleep+0x75>
    return -1;
  acquire(&tickslock);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	68 80 43 11 80       	push   $0x80114380
80105351:	e8 fa ef ff ff       	call   80104350 <acquire>
  ticks0 = ticks;
80105356:	8b 1d 60 43 11 80    	mov    0x80114360,%ebx
  while(ticks - ticks0 < n){
8010535c:	83 c4 10             	add    $0x10,%esp
8010535f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105362:	85 d2                	test   %edx,%edx
80105364:	75 23                	jne    80105389 <sys_sleep+0x59>
80105366:	eb 44                	jmp    801053ac <sys_sleep+0x7c>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105368:	83 ec 08             	sub    $0x8,%esp
8010536b:	68 80 43 11 80       	push   $0x80114380
80105370:	68 60 43 11 80       	push   $0x80114360
80105375:	e8 52 e9 ff ff       	call   80103ccc <sleep>
  while(ticks - ticks0 < n){
8010537a:	a1 60 43 11 80       	mov    0x80114360,%eax
8010537f:	29 d8                	sub    %ebx,%eax
80105381:	83 c4 10             	add    $0x10,%esp
80105384:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105387:	73 23                	jae    801053ac <sys_sleep+0x7c>
    if(myproc()->killed){
80105389:	e8 12 e2 ff ff       	call   801035a0 <myproc>
8010538e:	8b 40 40             	mov    0x40(%eax),%eax
80105391:	85 c0                	test   %eax,%eax
80105393:	74 d3                	je     80105368 <sys_sleep+0x38>
      release(&tickslock);
80105395:	83 ec 0c             	sub    $0xc,%esp
80105398:	68 80 43 11 80       	push   $0x80114380
8010539d:	e8 4e ef ff ff       	call   801042f0 <release>
      return -1;
801053a2:	83 c4 10             	add    $0x10,%esp
    return -1;
801053a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053aa:	eb 12                	jmp    801053be <sys_sleep+0x8e>
  }
  release(&tickslock);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	68 80 43 11 80       	push   $0x80114380
801053b4:	e8 37 ef ff ff       	call   801042f0 <release>
  return 0;
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053c1:	c9                   	leave
801053c2:	c3                   	ret
801053c3:	90                   	nop

801053c4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	53                   	push   %ebx
801053c8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801053cb:	68 80 43 11 80       	push   $0x80114380
801053d0:	e8 7b ef ff ff       	call   80104350 <acquire>
  xticks = ticks;
801053d5:	8b 1d 60 43 11 80    	mov    0x80114360,%ebx
  release(&tickslock);
801053db:	c7 04 24 80 43 11 80 	movl   $0x80114380,(%esp)
801053e2:	e8 09 ef ff ff       	call   801042f0 <release>
  return xticks;
}
801053e7:	89 d8                	mov    %ebx,%eax
801053e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053ec:	c9                   	leave
801053ed:	c3                   	ret

801053ee <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801053ee:	1e                   	push   %ds
  pushl %es
801053ef:	06                   	push   %es
  pushl %fs
801053f0:	0f a0                	push   %fs
  pushl %gs
801053f2:	0f a8                	push   %gs
  pushal
801053f4:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801053f5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801053f9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801053fb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801053fd:	54                   	push   %esp
  call trap
801053fe:	e8 a1 00 00 00       	call   801054a4 <trap>
  addl $4, %esp
80105403:	83 c4 04             	add    $0x4,%esp

80105406 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105406:	61                   	popa
  popl %gs
80105407:	0f a9                	pop    %gs
  popl %fs
80105409:	0f a1                	pop    %fs
  popl %es
8010540b:	07                   	pop    %es
  popl %ds
8010540c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010540d:	83 c4 08             	add    $0x8,%esp
  iret
80105410:	cf                   	iret
80105411:	66 90                	xchg   %ax,%ax
80105413:	90                   	nop

80105414 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010541a:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010541c:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105423:	66 89 14 c5 c0 43 11 	mov    %dx,-0x7feebc40(,%eax,8)
8010542a:	80 
8010542b:	c7 04 c5 c2 43 11 80 	movl   $0x8e000008,-0x7feebc3e(,%eax,8)
80105432:	08 00 00 8e 
80105436:	c1 ea 10             	shr    $0x10,%edx
80105439:	66 89 14 c5 c6 43 11 	mov    %dx,-0x7feebc3a(,%eax,8)
80105440:	80 
  for(i = 0; i < 256; i++)
80105441:	40                   	inc    %eax
80105442:	3d 00 01 00 00       	cmp    $0x100,%eax
80105447:	75 d3                	jne    8010541c <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105449:	a1 08 a1 10 80       	mov    0x8010a108,%eax
8010544e:	66 a3 c0 45 11 80    	mov    %ax,0x801145c0
80105454:	c7 05 c2 45 11 80 08 	movl   $0xef000008,0x801145c2
8010545b:	00 00 ef 
8010545e:	c1 e8 10             	shr    $0x10,%eax
80105461:	66 a3 c6 45 11 80    	mov    %ax,0x801145c6

  initlock(&tickslock, "time");
80105467:	83 ec 08             	sub    $0x8,%esp
8010546a:	68 50 70 10 80       	push   $0x80107050
8010546f:	68 80 43 11 80       	push   $0x80114380
80105474:	e8 0f ed ff ff       	call   80104188 <initlock>
}
80105479:	83 c4 10             	add    $0x10,%esp
8010547c:	c9                   	leave
8010547d:	c3                   	ret
8010547e:	66 90                	xchg   %ax,%ax

80105480 <idtinit>:

void
idtinit(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105486:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
8010548c:	b8 c0 43 11 80       	mov    $0x801143c0,%eax
80105491:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105495:	c1 e8 10             	shr    $0x10,%eax
80105498:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010549c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010549f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801054a2:	c9                   	leave
801054a3:	c3                   	ret

801054a4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	57                   	push   %edi
801054a8:	56                   	push   %esi
801054a9:	53                   	push   %ebx
801054aa:	83 ec 1c             	sub    $0x1c,%esp
801054ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801054b0:	8b 43 30             	mov    0x30(%ebx),%eax
801054b3:	83 f8 40             	cmp    $0x40,%eax
801054b6:	0f 84 d8 01 00 00    	je     80105694 <trap+0x1f0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801054bc:	83 e8 20             	sub    $0x20,%eax
801054bf:	83 f8 1f             	cmp    $0x1f,%eax
801054c2:	77 74                	ja     80105538 <trap+0x94>
801054c4:	ff 24 85 3c 76 10 80 	jmp    *-0x7fef89c4(,%eax,4)
801054cb:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801054cc:	e8 9b e0 ff ff       	call   8010356c <cpuid>
801054d1:	85 c0                	test   %eax,%eax
801054d3:	0f 84 ff 01 00 00    	je     801056d8 <trap+0x234>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801054d9:	e8 96 d1 ff ff       	call   80102674 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054de:	e8 bd e0 ff ff       	call   801035a0 <myproc>
801054e3:	85 c0                	test   %eax,%eax
801054e5:	74 19                	je     80105500 <trap+0x5c>
801054e7:	e8 b4 e0 ff ff       	call   801035a0 <myproc>
801054ec:	8b 50 40             	mov    0x40(%eax),%edx
801054ef:	85 d2                	test   %edx,%edx
801054f1:	74 0d                	je     80105500 <trap+0x5c>
801054f3:	8b 43 3c             	mov    0x3c(%ebx),%eax
801054f6:	f7 d0                	not    %eax
801054f8:	a8 03                	test   $0x3,%al
801054fa:	0f 84 cc 01 00 00    	je     801056cc <trap+0x228>





  if(myproc() && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
80105500:	e8 9b e0 ff ff       	call   801035a0 <myproc>
80105505:	85 c0                	test   %eax,%eax
80105507:	74 0f                	je     80105518 <trap+0x74>
80105509:	e8 92 e0 ff ff       	call   801035a0 <myproc>
8010550e:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80105512:	0f 84 bc 00 00 00    	je     801055d4 <trap+0x130>
// }


  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105518:	e8 83 e0 ff ff       	call   801035a0 <myproc>
8010551d:	85 c0                	test   %eax,%eax
8010551f:	74 0f                	je     80105530 <trap+0x8c>
80105521:	e8 7a e0 ff ff       	call   801035a0 <myproc>
80105526:	83 78 28 04          	cmpl   $0x4,0x28(%eax)
8010552a:	0f 84 8c 00 00 00    	je     801055bc <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

}
80105530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105533:	5b                   	pop    %ebx
80105534:	5e                   	pop    %esi
80105535:	5f                   	pop    %edi
80105536:	5d                   	pop    %ebp
80105537:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105538:	e8 63 e0 ff ff       	call   801035a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010553d:	8b 7b 38             	mov    0x38(%ebx),%edi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105540:	85 c0                	test   %eax,%eax
80105542:	0f 84 cb 01 00 00    	je     80105713 <trap+0x26f>
80105548:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010554c:	0f 84 c1 01 00 00    	je     80105713 <trap+0x26f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105552:	0f 20 d1             	mov    %cr2,%ecx
80105555:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105558:	e8 0f e0 ff ff       	call   8010356c <cpuid>
8010555d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105560:	8b 43 34             	mov    0x34(%ebx),%eax
80105563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105566:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105569:	e8 32 e0 ff ff       	call   801035a0 <myproc>
8010556e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105571:	e8 2a e0 ff ff       	call   801035a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105576:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105579:	51                   	push   %ecx
8010557a:	57                   	push   %edi
8010557b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010557e:	52                   	push   %edx
8010557f:	ff 75 e4             	push   -0x1c(%ebp)
80105582:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105583:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105586:	81 c6 88 00 00 00    	add    $0x88,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010558c:	56                   	push   %esi
8010558d:	ff 70 2c             	push   0x2c(%eax)
80105590:	68 38 73 10 80       	push   $0x80107338
80105595:	e8 86 b0 ff ff       	call   80100620 <cprintf>
    myproc()->killed = 1;
8010559a:	83 c4 20             	add    $0x20,%esp
8010559d:	e8 fe df ff ff       	call   801035a0 <myproc>
801055a2:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055a9:	e8 f2 df ff ff       	call   801035a0 <myproc>
801055ae:	85 c0                	test   %eax,%eax
801055b0:	0f 85 31 ff ff ff    	jne    801054e7 <trap+0x43>
801055b6:	e9 45 ff ff ff       	jmp    80105500 <trap+0x5c>
801055bb:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
801055bc:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801055c0:	0f 85 6a ff ff ff    	jne    80105530 <trap+0x8c>
}
801055c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c9:	5b                   	pop    %ebx
801055ca:	5e                   	pop    %esi
801055cb:	5f                   	pop    %edi
801055cc:	5d                   	pop    %ebp
    yield();
801055cd:	e9 b2 e6 ff ff       	jmp    80103c84 <yield>
801055d2:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
801055d4:	e8 c7 df ff ff       	call   801035a0 <myproc>
801055d9:	8b 40 0c             	mov    0xc(%eax),%eax
801055dc:	85 c0                	test   %eax,%eax
801055de:	0f 84 34 ff ff ff    	je     80105518 <trap+0x74>
    myproc()->pending_signal = 0; // clear pending signal
801055e4:	e8 b7 df ff ff       	call   801035a0 <myproc>
801055e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    myproc()->backup_eip = myproc()->tf->eip;
801055f0:	e8 ab df ff ff       	call   801035a0 <myproc>
801055f5:	8b 70 34             	mov    0x34(%eax),%esi
801055f8:	e8 a3 df ff ff       	call   801035a0 <myproc>
801055fd:	8b 56 38             	mov    0x38(%esi),%edx
80105600:	89 50 18             	mov    %edx,0x18(%eax)
    myproc()->tf->eip = (uint)myproc()->signal_handler;
80105603:	e8 98 df ff ff       	call   801035a0 <myproc>
80105608:	8b 70 0c             	mov    0xc(%eax),%esi
8010560b:	e8 90 df ff ff       	call   801035a0 <myproc>
80105610:	8b 40 34             	mov    0x34(%eax),%eax
80105613:	89 70 38             	mov    %esi,0x38(%eax)
80105616:	e9 fd fe ff ff       	jmp    80105518 <trap+0x74>
8010561b:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010561c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010561f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105623:	e8 44 df ff ff       	call   8010356c <cpuid>
80105628:	57                   	push   %edi
80105629:	56                   	push   %esi
8010562a:	50                   	push   %eax
8010562b:	68 e0 72 10 80       	push   $0x801072e0
80105630:	e8 eb af ff ff       	call   80100620 <cprintf>
    lapiceoi();
80105635:	e8 3a d0 ff ff       	call   80102674 <lapiceoi>
    break;
8010563a:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010563d:	e8 5e df ff ff       	call   801035a0 <myproc>
80105642:	85 c0                	test   %eax,%eax
80105644:	0f 85 9d fe ff ff    	jne    801054e7 <trap+0x43>
8010564a:	e9 b1 fe ff ff       	jmp    80105500 <trap+0x5c>
8010564f:	90                   	nop
    uartintr();
80105650:	e8 1b 02 00 00       	call   80105870 <uartintr>
    lapiceoi();
80105655:	e8 1a d0 ff ff       	call   80102674 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010565a:	e8 41 df ff ff       	call   801035a0 <myproc>
8010565f:	85 c0                	test   %eax,%eax
80105661:	0f 85 80 fe ff ff    	jne    801054e7 <trap+0x43>
80105667:	e9 94 fe ff ff       	jmp    80105500 <trap+0x5c>
    kbdintr();
8010566c:	e8 4f ce ff ff       	call   801024c0 <kbdintr>
    lapiceoi();
80105671:	e8 fe cf ff ff       	call   80102674 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105676:	e8 25 df ff ff       	call   801035a0 <myproc>
8010567b:	85 c0                	test   %eax,%eax
8010567d:	0f 85 64 fe ff ff    	jne    801054e7 <trap+0x43>
80105683:	e9 78 fe ff ff       	jmp    80105500 <trap+0x5c>
    ideintr();
80105688:	e8 33 c9 ff ff       	call   80101fc0 <ideintr>
8010568d:	e9 47 fe ff ff       	jmp    801054d9 <trap+0x35>
80105692:	66 90                	xchg   %ax,%ax
    if(myproc()->killed)
80105694:	e8 07 df ff ff       	call   801035a0 <myproc>
80105699:	8b 70 40             	mov    0x40(%eax),%esi
8010569c:	85 f6                	test   %esi,%esi
8010569e:	75 6c                	jne    8010570c <trap+0x268>
    myproc()->tf = tf;
801056a0:	e8 fb de ff ff       	call   801035a0 <myproc>
801056a5:	89 58 34             	mov    %ebx,0x34(%eax)
    syscall();
801056a8:	e8 9b f0 ff ff       	call   80104748 <syscall>
    if(myproc()->killed)
801056ad:	e8 ee de ff ff       	call   801035a0 <myproc>
801056b2:	8b 48 40             	mov    0x40(%eax),%ecx
801056b5:	85 c9                	test   %ecx,%ecx
801056b7:	0f 84 73 fe ff ff    	je     80105530 <trap+0x8c>
}
801056bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c0:	5b                   	pop    %ebx
801056c1:	5e                   	pop    %esi
801056c2:	5f                   	pop    %edi
801056c3:	5d                   	pop    %ebp
      exit();
801056c4:	e9 93 e4 ff ff       	jmp    80103b5c <exit>
801056c9:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801056cc:	e8 8b e4 ff ff       	call   80103b5c <exit>
801056d1:	e9 2a fe ff ff       	jmp    80105500 <trap+0x5c>
801056d6:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
801056d8:	83 ec 0c             	sub    $0xc,%esp
801056db:	68 80 43 11 80       	push   $0x80114380
801056e0:	e8 6b ec ff ff       	call   80104350 <acquire>
      ticks++;
801056e5:	ff 05 60 43 11 80    	incl   0x80114360
      wakeup(&ticks);
801056eb:	c7 04 24 60 43 11 80 	movl   $0x80114360,(%esp)
801056f2:	e8 a9 e7 ff ff       	call   80103ea0 <wakeup>
      release(&tickslock);
801056f7:	c7 04 24 80 43 11 80 	movl   $0x80114380,(%esp)
801056fe:	e8 ed eb ff ff       	call   801042f0 <release>
80105703:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105706:	e9 ce fd ff ff       	jmp    801054d9 <trap+0x35>
8010570b:	90                   	nop
      exit();
8010570c:	e8 4b e4 ff ff       	call   80103b5c <exit>
80105711:	eb 8d                	jmp    801056a0 <trap+0x1fc>
80105713:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105716:	e8 51 de ff ff       	call   8010356c <cpuid>
8010571b:	83 ec 0c             	sub    $0xc,%esp
8010571e:	56                   	push   %esi
8010571f:	57                   	push   %edi
80105720:	50                   	push   %eax
80105721:	ff 73 30             	push   0x30(%ebx)
80105724:	68 04 73 10 80       	push   $0x80107304
80105729:	e8 f2 ae ff ff       	call   80100620 <cprintf>
      panic("trap");
8010572e:	83 c4 14             	add    $0x14,%esp
80105731:	68 55 70 10 80       	push   $0x80107055
80105736:	e8 fd ab ff ff       	call   80100338 <panic>
8010573b:	90                   	nop

8010573c <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
8010573c:	a1 c0 4b 11 80       	mov    0x80114bc0,%eax
80105741:	85 c0                	test   %eax,%eax
80105743:	74 17                	je     8010575c <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105745:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010574a:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010574b:	a8 01                	test   $0x1,%al
8010574d:	74 0d                	je     8010575c <uartgetc+0x20>
8010574f:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105754:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105755:	0f b6 c0             	movzbl %al,%eax
80105758:	c3                   	ret
80105759:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
8010575c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105761:	c3                   	ret
80105762:	66 90                	xchg   %ax,%ax

80105764 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105764:	31 c9                	xor    %ecx,%ecx
80105766:	88 c8                	mov    %cl,%al
80105768:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010576d:	ee                   	out    %al,(%dx)
8010576e:	b0 80                	mov    $0x80,%al
80105770:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105775:	ee                   	out    %al,(%dx)
80105776:	b0 0c                	mov    $0xc,%al
80105778:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010577d:	ee                   	out    %al,(%dx)
8010577e:	88 c8                	mov    %cl,%al
80105780:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105785:	ee                   	out    %al,(%dx)
80105786:	b0 03                	mov    $0x3,%al
80105788:	ba fb 03 00 00       	mov    $0x3fb,%edx
8010578d:	ee                   	out    %al,(%dx)
8010578e:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105793:	88 c8                	mov    %cl,%al
80105795:	ee                   	out    %al,(%dx)
80105796:	b0 01                	mov    $0x1,%al
80105798:	ba f9 03 00 00       	mov    $0x3f9,%edx
8010579d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010579e:	ba fd 03 00 00       	mov    $0x3fd,%edx
801057a3:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801057a4:	fe c0                	inc    %al
801057a6:	74 7e                	je     80105826 <uartinit+0xc2>
{
801057a8:	55                   	push   %ebp
801057a9:	89 e5                	mov    %esp,%ebp
801057ab:	57                   	push   %edi
801057ac:	56                   	push   %esi
801057ad:	53                   	push   %ebx
801057ae:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
801057b1:	c7 05 c0 4b 11 80 01 	movl   $0x1,0x80114bc0
801057b8:	00 00 00 
801057bb:	ba fa 03 00 00       	mov    $0x3fa,%edx
801057c0:	ec                   	in     (%dx),%al
801057c1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801057c6:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801057c7:	6a 00                	push   $0x0
801057c9:	6a 04                	push   $0x4
801057cb:	e8 00 ca ff ff       	call   801021d0 <ioapicenable>
801057d0:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801057d3:	bf 5a 70 10 80       	mov    $0x8010705a,%edi
801057d8:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801057dc:	be fd 03 00 00       	mov    $0x3fd,%esi
801057e1:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801057e4:	a1 c0 4b 11 80       	mov    0x80114bc0,%eax
801057e9:	85 c0                	test   %eax,%eax
801057eb:	74 27                	je     80105814 <uartinit+0xb0>
801057ed:	bb 80 00 00 00       	mov    $0x80,%ebx
801057f2:	eb 10                	jmp    80105804 <uartinit+0xa0>
    microdelay(10);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	6a 0a                	push   $0xa
801057f9:	e8 8e ce ff ff       	call   8010268c <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	4b                   	dec    %ebx
80105802:	74 07                	je     8010580b <uartinit+0xa7>
80105804:	89 f2                	mov    %esi,%edx
80105806:	ec                   	in     (%dx),%al
80105807:	a8 20                	test   $0x20,%al
80105809:	74 e9                	je     801057f4 <uartinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010580b:	8a 45 e7             	mov    -0x19(%ebp),%al
8010580e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105813:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105814:	47                   	inc    %edi
80105815:	8a 07                	mov    (%edi),%al
80105817:	88 45 e7             	mov    %al,-0x19(%ebp)
8010581a:	84 c0                	test   %al,%al
8010581c:	75 c6                	jne    801057e4 <uartinit+0x80>
}
8010581e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105821:	5b                   	pop    %ebx
80105822:	5e                   	pop    %esi
80105823:	5f                   	pop    %edi
80105824:	5d                   	pop    %ebp
80105825:	c3                   	ret
80105826:	c3                   	ret
80105827:	90                   	nop

80105828 <uartputc>:
  if(!uart)
80105828:	a1 c0 4b 11 80       	mov    0x80114bc0,%eax
8010582d:	85 c0                	test   %eax,%eax
8010582f:	74 3b                	je     8010586c <uartputc+0x44>
{
80105831:	55                   	push   %ebp
80105832:	89 e5                	mov    %esp,%ebp
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	bb 80 00 00 00       	mov    $0x80,%ebx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010583b:	be fd 03 00 00       	mov    $0x3fd,%esi
80105840:	eb 12                	jmp    80105854 <uartputc+0x2c>
80105842:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	6a 0a                	push   $0xa
80105849:	e8 3e ce ff ff       	call   8010268c <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010584e:	83 c4 10             	add    $0x10,%esp
80105851:	4b                   	dec    %ebx
80105852:	74 07                	je     8010585b <uartputc+0x33>
80105854:	89 f2                	mov    %esi,%edx
80105856:	ec                   	in     (%dx),%al
80105857:	a8 20                	test   $0x20,%al
80105859:	74 e9                	je     80105844 <uartputc+0x1c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010585b:	8b 45 08             	mov    0x8(%ebp),%eax
8010585e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105863:	ee                   	out    %al,(%dx)
}
80105864:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105867:	5b                   	pop    %ebx
80105868:	5e                   	pop    %esi
80105869:	5d                   	pop    %ebp
8010586a:	c3                   	ret
8010586b:	90                   	nop
8010586c:	c3                   	ret
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <uartintr>:

void
uartintr(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105876:	68 3c 57 10 80       	push   $0x8010573c
8010587b:	e8 68 af ff ff       	call   801007e8 <consoleintr>
}
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	c9                   	leave
80105884:	c3                   	ret

80105885 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105885:	6a 00                	push   $0x0
  pushl $0
80105887:	6a 00                	push   $0x0
  jmp alltraps
80105889:	e9 60 fb ff ff       	jmp    801053ee <alltraps>

8010588e <vector1>:
.globl vector1
vector1:
  pushl $0
8010588e:	6a 00                	push   $0x0
  pushl $1
80105890:	6a 01                	push   $0x1
  jmp alltraps
80105892:	e9 57 fb ff ff       	jmp    801053ee <alltraps>

80105897 <vector2>:
.globl vector2
vector2:
  pushl $0
80105897:	6a 00                	push   $0x0
  pushl $2
80105899:	6a 02                	push   $0x2
  jmp alltraps
8010589b:	e9 4e fb ff ff       	jmp    801053ee <alltraps>

801058a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801058a0:	6a 00                	push   $0x0
  pushl $3
801058a2:	6a 03                	push   $0x3
  jmp alltraps
801058a4:	e9 45 fb ff ff       	jmp    801053ee <alltraps>

801058a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801058a9:	6a 00                	push   $0x0
  pushl $4
801058ab:	6a 04                	push   $0x4
  jmp alltraps
801058ad:	e9 3c fb ff ff       	jmp    801053ee <alltraps>

801058b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801058b2:	6a 00                	push   $0x0
  pushl $5
801058b4:	6a 05                	push   $0x5
  jmp alltraps
801058b6:	e9 33 fb ff ff       	jmp    801053ee <alltraps>

801058bb <vector6>:
.globl vector6
vector6:
  pushl $0
801058bb:	6a 00                	push   $0x0
  pushl $6
801058bd:	6a 06                	push   $0x6
  jmp alltraps
801058bf:	e9 2a fb ff ff       	jmp    801053ee <alltraps>

801058c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801058c4:	6a 00                	push   $0x0
  pushl $7
801058c6:	6a 07                	push   $0x7
  jmp alltraps
801058c8:	e9 21 fb ff ff       	jmp    801053ee <alltraps>

801058cd <vector8>:
.globl vector8
vector8:
  pushl $8
801058cd:	6a 08                	push   $0x8
  jmp alltraps
801058cf:	e9 1a fb ff ff       	jmp    801053ee <alltraps>

801058d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801058d4:	6a 00                	push   $0x0
  pushl $9
801058d6:	6a 09                	push   $0x9
  jmp alltraps
801058d8:	e9 11 fb ff ff       	jmp    801053ee <alltraps>

801058dd <vector10>:
.globl vector10
vector10:
  pushl $10
801058dd:	6a 0a                	push   $0xa
  jmp alltraps
801058df:	e9 0a fb ff ff       	jmp    801053ee <alltraps>

801058e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801058e4:	6a 0b                	push   $0xb
  jmp alltraps
801058e6:	e9 03 fb ff ff       	jmp    801053ee <alltraps>

801058eb <vector12>:
.globl vector12
vector12:
  pushl $12
801058eb:	6a 0c                	push   $0xc
  jmp alltraps
801058ed:	e9 fc fa ff ff       	jmp    801053ee <alltraps>

801058f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801058f2:	6a 0d                	push   $0xd
  jmp alltraps
801058f4:	e9 f5 fa ff ff       	jmp    801053ee <alltraps>

801058f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801058f9:	6a 0e                	push   $0xe
  jmp alltraps
801058fb:	e9 ee fa ff ff       	jmp    801053ee <alltraps>

80105900 <vector15>:
.globl vector15
vector15:
  pushl $0
80105900:	6a 00                	push   $0x0
  pushl $15
80105902:	6a 0f                	push   $0xf
  jmp alltraps
80105904:	e9 e5 fa ff ff       	jmp    801053ee <alltraps>

80105909 <vector16>:
.globl vector16
vector16:
  pushl $0
80105909:	6a 00                	push   $0x0
  pushl $16
8010590b:	6a 10                	push   $0x10
  jmp alltraps
8010590d:	e9 dc fa ff ff       	jmp    801053ee <alltraps>

80105912 <vector17>:
.globl vector17
vector17:
  pushl $17
80105912:	6a 11                	push   $0x11
  jmp alltraps
80105914:	e9 d5 fa ff ff       	jmp    801053ee <alltraps>

80105919 <vector18>:
.globl vector18
vector18:
  pushl $0
80105919:	6a 00                	push   $0x0
  pushl $18
8010591b:	6a 12                	push   $0x12
  jmp alltraps
8010591d:	e9 cc fa ff ff       	jmp    801053ee <alltraps>

80105922 <vector19>:
.globl vector19
vector19:
  pushl $0
80105922:	6a 00                	push   $0x0
  pushl $19
80105924:	6a 13                	push   $0x13
  jmp alltraps
80105926:	e9 c3 fa ff ff       	jmp    801053ee <alltraps>

8010592b <vector20>:
.globl vector20
vector20:
  pushl $0
8010592b:	6a 00                	push   $0x0
  pushl $20
8010592d:	6a 14                	push   $0x14
  jmp alltraps
8010592f:	e9 ba fa ff ff       	jmp    801053ee <alltraps>

80105934 <vector21>:
.globl vector21
vector21:
  pushl $0
80105934:	6a 00                	push   $0x0
  pushl $21
80105936:	6a 15                	push   $0x15
  jmp alltraps
80105938:	e9 b1 fa ff ff       	jmp    801053ee <alltraps>

8010593d <vector22>:
.globl vector22
vector22:
  pushl $0
8010593d:	6a 00                	push   $0x0
  pushl $22
8010593f:	6a 16                	push   $0x16
  jmp alltraps
80105941:	e9 a8 fa ff ff       	jmp    801053ee <alltraps>

80105946 <vector23>:
.globl vector23
vector23:
  pushl $0
80105946:	6a 00                	push   $0x0
  pushl $23
80105948:	6a 17                	push   $0x17
  jmp alltraps
8010594a:	e9 9f fa ff ff       	jmp    801053ee <alltraps>

8010594f <vector24>:
.globl vector24
vector24:
  pushl $0
8010594f:	6a 00                	push   $0x0
  pushl $24
80105951:	6a 18                	push   $0x18
  jmp alltraps
80105953:	e9 96 fa ff ff       	jmp    801053ee <alltraps>

80105958 <vector25>:
.globl vector25
vector25:
  pushl $0
80105958:	6a 00                	push   $0x0
  pushl $25
8010595a:	6a 19                	push   $0x19
  jmp alltraps
8010595c:	e9 8d fa ff ff       	jmp    801053ee <alltraps>

80105961 <vector26>:
.globl vector26
vector26:
  pushl $0
80105961:	6a 00                	push   $0x0
  pushl $26
80105963:	6a 1a                	push   $0x1a
  jmp alltraps
80105965:	e9 84 fa ff ff       	jmp    801053ee <alltraps>

8010596a <vector27>:
.globl vector27
vector27:
  pushl $0
8010596a:	6a 00                	push   $0x0
  pushl $27
8010596c:	6a 1b                	push   $0x1b
  jmp alltraps
8010596e:	e9 7b fa ff ff       	jmp    801053ee <alltraps>

80105973 <vector28>:
.globl vector28
vector28:
  pushl $0
80105973:	6a 00                	push   $0x0
  pushl $28
80105975:	6a 1c                	push   $0x1c
  jmp alltraps
80105977:	e9 72 fa ff ff       	jmp    801053ee <alltraps>

8010597c <vector29>:
.globl vector29
vector29:
  pushl $0
8010597c:	6a 00                	push   $0x0
  pushl $29
8010597e:	6a 1d                	push   $0x1d
  jmp alltraps
80105980:	e9 69 fa ff ff       	jmp    801053ee <alltraps>

80105985 <vector30>:
.globl vector30
vector30:
  pushl $0
80105985:	6a 00                	push   $0x0
  pushl $30
80105987:	6a 1e                	push   $0x1e
  jmp alltraps
80105989:	e9 60 fa ff ff       	jmp    801053ee <alltraps>

8010598e <vector31>:
.globl vector31
vector31:
  pushl $0
8010598e:	6a 00                	push   $0x0
  pushl $31
80105990:	6a 1f                	push   $0x1f
  jmp alltraps
80105992:	e9 57 fa ff ff       	jmp    801053ee <alltraps>

80105997 <vector32>:
.globl vector32
vector32:
  pushl $0
80105997:	6a 00                	push   $0x0
  pushl $32
80105999:	6a 20                	push   $0x20
  jmp alltraps
8010599b:	e9 4e fa ff ff       	jmp    801053ee <alltraps>

801059a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801059a0:	6a 00                	push   $0x0
  pushl $33
801059a2:	6a 21                	push   $0x21
  jmp alltraps
801059a4:	e9 45 fa ff ff       	jmp    801053ee <alltraps>

801059a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801059a9:	6a 00                	push   $0x0
  pushl $34
801059ab:	6a 22                	push   $0x22
  jmp alltraps
801059ad:	e9 3c fa ff ff       	jmp    801053ee <alltraps>

801059b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801059b2:	6a 00                	push   $0x0
  pushl $35
801059b4:	6a 23                	push   $0x23
  jmp alltraps
801059b6:	e9 33 fa ff ff       	jmp    801053ee <alltraps>

801059bb <vector36>:
.globl vector36
vector36:
  pushl $0
801059bb:	6a 00                	push   $0x0
  pushl $36
801059bd:	6a 24                	push   $0x24
  jmp alltraps
801059bf:	e9 2a fa ff ff       	jmp    801053ee <alltraps>

801059c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801059c4:	6a 00                	push   $0x0
  pushl $37
801059c6:	6a 25                	push   $0x25
  jmp alltraps
801059c8:	e9 21 fa ff ff       	jmp    801053ee <alltraps>

801059cd <vector38>:
.globl vector38
vector38:
  pushl $0
801059cd:	6a 00                	push   $0x0
  pushl $38
801059cf:	6a 26                	push   $0x26
  jmp alltraps
801059d1:	e9 18 fa ff ff       	jmp    801053ee <alltraps>

801059d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801059d6:	6a 00                	push   $0x0
  pushl $39
801059d8:	6a 27                	push   $0x27
  jmp alltraps
801059da:	e9 0f fa ff ff       	jmp    801053ee <alltraps>

801059df <vector40>:
.globl vector40
vector40:
  pushl $0
801059df:	6a 00                	push   $0x0
  pushl $40
801059e1:	6a 28                	push   $0x28
  jmp alltraps
801059e3:	e9 06 fa ff ff       	jmp    801053ee <alltraps>

801059e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801059e8:	6a 00                	push   $0x0
  pushl $41
801059ea:	6a 29                	push   $0x29
  jmp alltraps
801059ec:	e9 fd f9 ff ff       	jmp    801053ee <alltraps>

801059f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801059f1:	6a 00                	push   $0x0
  pushl $42
801059f3:	6a 2a                	push   $0x2a
  jmp alltraps
801059f5:	e9 f4 f9 ff ff       	jmp    801053ee <alltraps>

801059fa <vector43>:
.globl vector43
vector43:
  pushl $0
801059fa:	6a 00                	push   $0x0
  pushl $43
801059fc:	6a 2b                	push   $0x2b
  jmp alltraps
801059fe:	e9 eb f9 ff ff       	jmp    801053ee <alltraps>

80105a03 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a03:	6a 00                	push   $0x0
  pushl $44
80105a05:	6a 2c                	push   $0x2c
  jmp alltraps
80105a07:	e9 e2 f9 ff ff       	jmp    801053ee <alltraps>

80105a0c <vector45>:
.globl vector45
vector45:
  pushl $0
80105a0c:	6a 00                	push   $0x0
  pushl $45
80105a0e:	6a 2d                	push   $0x2d
  jmp alltraps
80105a10:	e9 d9 f9 ff ff       	jmp    801053ee <alltraps>

80105a15 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a15:	6a 00                	push   $0x0
  pushl $46
80105a17:	6a 2e                	push   $0x2e
  jmp alltraps
80105a19:	e9 d0 f9 ff ff       	jmp    801053ee <alltraps>

80105a1e <vector47>:
.globl vector47
vector47:
  pushl $0
80105a1e:	6a 00                	push   $0x0
  pushl $47
80105a20:	6a 2f                	push   $0x2f
  jmp alltraps
80105a22:	e9 c7 f9 ff ff       	jmp    801053ee <alltraps>

80105a27 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a27:	6a 00                	push   $0x0
  pushl $48
80105a29:	6a 30                	push   $0x30
  jmp alltraps
80105a2b:	e9 be f9 ff ff       	jmp    801053ee <alltraps>

80105a30 <vector49>:
.globl vector49
vector49:
  pushl $0
80105a30:	6a 00                	push   $0x0
  pushl $49
80105a32:	6a 31                	push   $0x31
  jmp alltraps
80105a34:	e9 b5 f9 ff ff       	jmp    801053ee <alltraps>

80105a39 <vector50>:
.globl vector50
vector50:
  pushl $0
80105a39:	6a 00                	push   $0x0
  pushl $50
80105a3b:	6a 32                	push   $0x32
  jmp alltraps
80105a3d:	e9 ac f9 ff ff       	jmp    801053ee <alltraps>

80105a42 <vector51>:
.globl vector51
vector51:
  pushl $0
80105a42:	6a 00                	push   $0x0
  pushl $51
80105a44:	6a 33                	push   $0x33
  jmp alltraps
80105a46:	e9 a3 f9 ff ff       	jmp    801053ee <alltraps>

80105a4b <vector52>:
.globl vector52
vector52:
  pushl $0
80105a4b:	6a 00                	push   $0x0
  pushl $52
80105a4d:	6a 34                	push   $0x34
  jmp alltraps
80105a4f:	e9 9a f9 ff ff       	jmp    801053ee <alltraps>

80105a54 <vector53>:
.globl vector53
vector53:
  pushl $0
80105a54:	6a 00                	push   $0x0
  pushl $53
80105a56:	6a 35                	push   $0x35
  jmp alltraps
80105a58:	e9 91 f9 ff ff       	jmp    801053ee <alltraps>

80105a5d <vector54>:
.globl vector54
vector54:
  pushl $0
80105a5d:	6a 00                	push   $0x0
  pushl $54
80105a5f:	6a 36                	push   $0x36
  jmp alltraps
80105a61:	e9 88 f9 ff ff       	jmp    801053ee <alltraps>

80105a66 <vector55>:
.globl vector55
vector55:
  pushl $0
80105a66:	6a 00                	push   $0x0
  pushl $55
80105a68:	6a 37                	push   $0x37
  jmp alltraps
80105a6a:	e9 7f f9 ff ff       	jmp    801053ee <alltraps>

80105a6f <vector56>:
.globl vector56
vector56:
  pushl $0
80105a6f:	6a 00                	push   $0x0
  pushl $56
80105a71:	6a 38                	push   $0x38
  jmp alltraps
80105a73:	e9 76 f9 ff ff       	jmp    801053ee <alltraps>

80105a78 <vector57>:
.globl vector57
vector57:
  pushl $0
80105a78:	6a 00                	push   $0x0
  pushl $57
80105a7a:	6a 39                	push   $0x39
  jmp alltraps
80105a7c:	e9 6d f9 ff ff       	jmp    801053ee <alltraps>

80105a81 <vector58>:
.globl vector58
vector58:
  pushl $0
80105a81:	6a 00                	push   $0x0
  pushl $58
80105a83:	6a 3a                	push   $0x3a
  jmp alltraps
80105a85:	e9 64 f9 ff ff       	jmp    801053ee <alltraps>

80105a8a <vector59>:
.globl vector59
vector59:
  pushl $0
80105a8a:	6a 00                	push   $0x0
  pushl $59
80105a8c:	6a 3b                	push   $0x3b
  jmp alltraps
80105a8e:	e9 5b f9 ff ff       	jmp    801053ee <alltraps>

80105a93 <vector60>:
.globl vector60
vector60:
  pushl $0
80105a93:	6a 00                	push   $0x0
  pushl $60
80105a95:	6a 3c                	push   $0x3c
  jmp alltraps
80105a97:	e9 52 f9 ff ff       	jmp    801053ee <alltraps>

80105a9c <vector61>:
.globl vector61
vector61:
  pushl $0
80105a9c:	6a 00                	push   $0x0
  pushl $61
80105a9e:	6a 3d                	push   $0x3d
  jmp alltraps
80105aa0:	e9 49 f9 ff ff       	jmp    801053ee <alltraps>

80105aa5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105aa5:	6a 00                	push   $0x0
  pushl $62
80105aa7:	6a 3e                	push   $0x3e
  jmp alltraps
80105aa9:	e9 40 f9 ff ff       	jmp    801053ee <alltraps>

80105aae <vector63>:
.globl vector63
vector63:
  pushl $0
80105aae:	6a 00                	push   $0x0
  pushl $63
80105ab0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ab2:	e9 37 f9 ff ff       	jmp    801053ee <alltraps>

80105ab7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ab7:	6a 00                	push   $0x0
  pushl $64
80105ab9:	6a 40                	push   $0x40
  jmp alltraps
80105abb:	e9 2e f9 ff ff       	jmp    801053ee <alltraps>

80105ac0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ac0:	6a 00                	push   $0x0
  pushl $65
80105ac2:	6a 41                	push   $0x41
  jmp alltraps
80105ac4:	e9 25 f9 ff ff       	jmp    801053ee <alltraps>

80105ac9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ac9:	6a 00                	push   $0x0
  pushl $66
80105acb:	6a 42                	push   $0x42
  jmp alltraps
80105acd:	e9 1c f9 ff ff       	jmp    801053ee <alltraps>

80105ad2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ad2:	6a 00                	push   $0x0
  pushl $67
80105ad4:	6a 43                	push   $0x43
  jmp alltraps
80105ad6:	e9 13 f9 ff ff       	jmp    801053ee <alltraps>

80105adb <vector68>:
.globl vector68
vector68:
  pushl $0
80105adb:	6a 00                	push   $0x0
  pushl $68
80105add:	6a 44                	push   $0x44
  jmp alltraps
80105adf:	e9 0a f9 ff ff       	jmp    801053ee <alltraps>

80105ae4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105ae4:	6a 00                	push   $0x0
  pushl $69
80105ae6:	6a 45                	push   $0x45
  jmp alltraps
80105ae8:	e9 01 f9 ff ff       	jmp    801053ee <alltraps>

80105aed <vector70>:
.globl vector70
vector70:
  pushl $0
80105aed:	6a 00                	push   $0x0
  pushl $70
80105aef:	6a 46                	push   $0x46
  jmp alltraps
80105af1:	e9 f8 f8 ff ff       	jmp    801053ee <alltraps>

80105af6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105af6:	6a 00                	push   $0x0
  pushl $71
80105af8:	6a 47                	push   $0x47
  jmp alltraps
80105afa:	e9 ef f8 ff ff       	jmp    801053ee <alltraps>

80105aff <vector72>:
.globl vector72
vector72:
  pushl $0
80105aff:	6a 00                	push   $0x0
  pushl $72
80105b01:	6a 48                	push   $0x48
  jmp alltraps
80105b03:	e9 e6 f8 ff ff       	jmp    801053ee <alltraps>

80105b08 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b08:	6a 00                	push   $0x0
  pushl $73
80105b0a:	6a 49                	push   $0x49
  jmp alltraps
80105b0c:	e9 dd f8 ff ff       	jmp    801053ee <alltraps>

80105b11 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b11:	6a 00                	push   $0x0
  pushl $74
80105b13:	6a 4a                	push   $0x4a
  jmp alltraps
80105b15:	e9 d4 f8 ff ff       	jmp    801053ee <alltraps>

80105b1a <vector75>:
.globl vector75
vector75:
  pushl $0
80105b1a:	6a 00                	push   $0x0
  pushl $75
80105b1c:	6a 4b                	push   $0x4b
  jmp alltraps
80105b1e:	e9 cb f8 ff ff       	jmp    801053ee <alltraps>

80105b23 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $76
80105b25:	6a 4c                	push   $0x4c
  jmp alltraps
80105b27:	e9 c2 f8 ff ff       	jmp    801053ee <alltraps>

80105b2c <vector77>:
.globl vector77
vector77:
  pushl $0
80105b2c:	6a 00                	push   $0x0
  pushl $77
80105b2e:	6a 4d                	push   $0x4d
  jmp alltraps
80105b30:	e9 b9 f8 ff ff       	jmp    801053ee <alltraps>

80105b35 <vector78>:
.globl vector78
vector78:
  pushl $0
80105b35:	6a 00                	push   $0x0
  pushl $78
80105b37:	6a 4e                	push   $0x4e
  jmp alltraps
80105b39:	e9 b0 f8 ff ff       	jmp    801053ee <alltraps>

80105b3e <vector79>:
.globl vector79
vector79:
  pushl $0
80105b3e:	6a 00                	push   $0x0
  pushl $79
80105b40:	6a 4f                	push   $0x4f
  jmp alltraps
80105b42:	e9 a7 f8 ff ff       	jmp    801053ee <alltraps>

80105b47 <vector80>:
.globl vector80
vector80:
  pushl $0
80105b47:	6a 00                	push   $0x0
  pushl $80
80105b49:	6a 50                	push   $0x50
  jmp alltraps
80105b4b:	e9 9e f8 ff ff       	jmp    801053ee <alltraps>

80105b50 <vector81>:
.globl vector81
vector81:
  pushl $0
80105b50:	6a 00                	push   $0x0
  pushl $81
80105b52:	6a 51                	push   $0x51
  jmp alltraps
80105b54:	e9 95 f8 ff ff       	jmp    801053ee <alltraps>

80105b59 <vector82>:
.globl vector82
vector82:
  pushl $0
80105b59:	6a 00                	push   $0x0
  pushl $82
80105b5b:	6a 52                	push   $0x52
  jmp alltraps
80105b5d:	e9 8c f8 ff ff       	jmp    801053ee <alltraps>

80105b62 <vector83>:
.globl vector83
vector83:
  pushl $0
80105b62:	6a 00                	push   $0x0
  pushl $83
80105b64:	6a 53                	push   $0x53
  jmp alltraps
80105b66:	e9 83 f8 ff ff       	jmp    801053ee <alltraps>

80105b6b <vector84>:
.globl vector84
vector84:
  pushl $0
80105b6b:	6a 00                	push   $0x0
  pushl $84
80105b6d:	6a 54                	push   $0x54
  jmp alltraps
80105b6f:	e9 7a f8 ff ff       	jmp    801053ee <alltraps>

80105b74 <vector85>:
.globl vector85
vector85:
  pushl $0
80105b74:	6a 00                	push   $0x0
  pushl $85
80105b76:	6a 55                	push   $0x55
  jmp alltraps
80105b78:	e9 71 f8 ff ff       	jmp    801053ee <alltraps>

80105b7d <vector86>:
.globl vector86
vector86:
  pushl $0
80105b7d:	6a 00                	push   $0x0
  pushl $86
80105b7f:	6a 56                	push   $0x56
  jmp alltraps
80105b81:	e9 68 f8 ff ff       	jmp    801053ee <alltraps>

80105b86 <vector87>:
.globl vector87
vector87:
  pushl $0
80105b86:	6a 00                	push   $0x0
  pushl $87
80105b88:	6a 57                	push   $0x57
  jmp alltraps
80105b8a:	e9 5f f8 ff ff       	jmp    801053ee <alltraps>

80105b8f <vector88>:
.globl vector88
vector88:
  pushl $0
80105b8f:	6a 00                	push   $0x0
  pushl $88
80105b91:	6a 58                	push   $0x58
  jmp alltraps
80105b93:	e9 56 f8 ff ff       	jmp    801053ee <alltraps>

80105b98 <vector89>:
.globl vector89
vector89:
  pushl $0
80105b98:	6a 00                	push   $0x0
  pushl $89
80105b9a:	6a 59                	push   $0x59
  jmp alltraps
80105b9c:	e9 4d f8 ff ff       	jmp    801053ee <alltraps>

80105ba1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ba1:	6a 00                	push   $0x0
  pushl $90
80105ba3:	6a 5a                	push   $0x5a
  jmp alltraps
80105ba5:	e9 44 f8 ff ff       	jmp    801053ee <alltraps>

80105baa <vector91>:
.globl vector91
vector91:
  pushl $0
80105baa:	6a 00                	push   $0x0
  pushl $91
80105bac:	6a 5b                	push   $0x5b
  jmp alltraps
80105bae:	e9 3b f8 ff ff       	jmp    801053ee <alltraps>

80105bb3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105bb3:	6a 00                	push   $0x0
  pushl $92
80105bb5:	6a 5c                	push   $0x5c
  jmp alltraps
80105bb7:	e9 32 f8 ff ff       	jmp    801053ee <alltraps>

80105bbc <vector93>:
.globl vector93
vector93:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $93
80105bbe:	6a 5d                	push   $0x5d
  jmp alltraps
80105bc0:	e9 29 f8 ff ff       	jmp    801053ee <alltraps>

80105bc5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105bc5:	6a 00                	push   $0x0
  pushl $94
80105bc7:	6a 5e                	push   $0x5e
  jmp alltraps
80105bc9:	e9 20 f8 ff ff       	jmp    801053ee <alltraps>

80105bce <vector95>:
.globl vector95
vector95:
  pushl $0
80105bce:	6a 00                	push   $0x0
  pushl $95
80105bd0:	6a 5f                	push   $0x5f
  jmp alltraps
80105bd2:	e9 17 f8 ff ff       	jmp    801053ee <alltraps>

80105bd7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105bd7:	6a 00                	push   $0x0
  pushl $96
80105bd9:	6a 60                	push   $0x60
  jmp alltraps
80105bdb:	e9 0e f8 ff ff       	jmp    801053ee <alltraps>

80105be0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $97
80105be2:	6a 61                	push   $0x61
  jmp alltraps
80105be4:	e9 05 f8 ff ff       	jmp    801053ee <alltraps>

80105be9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $98
80105beb:	6a 62                	push   $0x62
  jmp alltraps
80105bed:	e9 fc f7 ff ff       	jmp    801053ee <alltraps>

80105bf2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $99
80105bf4:	6a 63                	push   $0x63
  jmp alltraps
80105bf6:	e9 f3 f7 ff ff       	jmp    801053ee <alltraps>

80105bfb <vector100>:
.globl vector100
vector100:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $100
80105bfd:	6a 64                	push   $0x64
  jmp alltraps
80105bff:	e9 ea f7 ff ff       	jmp    801053ee <alltraps>

80105c04 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $101
80105c06:	6a 65                	push   $0x65
  jmp alltraps
80105c08:	e9 e1 f7 ff ff       	jmp    801053ee <alltraps>

80105c0d <vector102>:
.globl vector102
vector102:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $102
80105c0f:	6a 66                	push   $0x66
  jmp alltraps
80105c11:	e9 d8 f7 ff ff       	jmp    801053ee <alltraps>

80105c16 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $103
80105c18:	6a 67                	push   $0x67
  jmp alltraps
80105c1a:	e9 cf f7 ff ff       	jmp    801053ee <alltraps>

80105c1f <vector104>:
.globl vector104
vector104:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $104
80105c21:	6a 68                	push   $0x68
  jmp alltraps
80105c23:	e9 c6 f7 ff ff       	jmp    801053ee <alltraps>

80105c28 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $105
80105c2a:	6a 69                	push   $0x69
  jmp alltraps
80105c2c:	e9 bd f7 ff ff       	jmp    801053ee <alltraps>

80105c31 <vector106>:
.globl vector106
vector106:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $106
80105c33:	6a 6a                	push   $0x6a
  jmp alltraps
80105c35:	e9 b4 f7 ff ff       	jmp    801053ee <alltraps>

80105c3a <vector107>:
.globl vector107
vector107:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $107
80105c3c:	6a 6b                	push   $0x6b
  jmp alltraps
80105c3e:	e9 ab f7 ff ff       	jmp    801053ee <alltraps>

80105c43 <vector108>:
.globl vector108
vector108:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $108
80105c45:	6a 6c                	push   $0x6c
  jmp alltraps
80105c47:	e9 a2 f7 ff ff       	jmp    801053ee <alltraps>

80105c4c <vector109>:
.globl vector109
vector109:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $109
80105c4e:	6a 6d                	push   $0x6d
  jmp alltraps
80105c50:	e9 99 f7 ff ff       	jmp    801053ee <alltraps>

80105c55 <vector110>:
.globl vector110
vector110:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $110
80105c57:	6a 6e                	push   $0x6e
  jmp alltraps
80105c59:	e9 90 f7 ff ff       	jmp    801053ee <alltraps>

80105c5e <vector111>:
.globl vector111
vector111:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $111
80105c60:	6a 6f                	push   $0x6f
  jmp alltraps
80105c62:	e9 87 f7 ff ff       	jmp    801053ee <alltraps>

80105c67 <vector112>:
.globl vector112
vector112:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $112
80105c69:	6a 70                	push   $0x70
  jmp alltraps
80105c6b:	e9 7e f7 ff ff       	jmp    801053ee <alltraps>

80105c70 <vector113>:
.globl vector113
vector113:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $113
80105c72:	6a 71                	push   $0x71
  jmp alltraps
80105c74:	e9 75 f7 ff ff       	jmp    801053ee <alltraps>

80105c79 <vector114>:
.globl vector114
vector114:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $114
80105c7b:	6a 72                	push   $0x72
  jmp alltraps
80105c7d:	e9 6c f7 ff ff       	jmp    801053ee <alltraps>

80105c82 <vector115>:
.globl vector115
vector115:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $115
80105c84:	6a 73                	push   $0x73
  jmp alltraps
80105c86:	e9 63 f7 ff ff       	jmp    801053ee <alltraps>

80105c8b <vector116>:
.globl vector116
vector116:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $116
80105c8d:	6a 74                	push   $0x74
  jmp alltraps
80105c8f:	e9 5a f7 ff ff       	jmp    801053ee <alltraps>

80105c94 <vector117>:
.globl vector117
vector117:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $117
80105c96:	6a 75                	push   $0x75
  jmp alltraps
80105c98:	e9 51 f7 ff ff       	jmp    801053ee <alltraps>

80105c9d <vector118>:
.globl vector118
vector118:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $118
80105c9f:	6a 76                	push   $0x76
  jmp alltraps
80105ca1:	e9 48 f7 ff ff       	jmp    801053ee <alltraps>

80105ca6 <vector119>:
.globl vector119
vector119:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $119
80105ca8:	6a 77                	push   $0x77
  jmp alltraps
80105caa:	e9 3f f7 ff ff       	jmp    801053ee <alltraps>

80105caf <vector120>:
.globl vector120
vector120:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $120
80105cb1:	6a 78                	push   $0x78
  jmp alltraps
80105cb3:	e9 36 f7 ff ff       	jmp    801053ee <alltraps>

80105cb8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $121
80105cba:	6a 79                	push   $0x79
  jmp alltraps
80105cbc:	e9 2d f7 ff ff       	jmp    801053ee <alltraps>

80105cc1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $122
80105cc3:	6a 7a                	push   $0x7a
  jmp alltraps
80105cc5:	e9 24 f7 ff ff       	jmp    801053ee <alltraps>

80105cca <vector123>:
.globl vector123
vector123:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $123
80105ccc:	6a 7b                	push   $0x7b
  jmp alltraps
80105cce:	e9 1b f7 ff ff       	jmp    801053ee <alltraps>

80105cd3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $124
80105cd5:	6a 7c                	push   $0x7c
  jmp alltraps
80105cd7:	e9 12 f7 ff ff       	jmp    801053ee <alltraps>

80105cdc <vector125>:
.globl vector125
vector125:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $125
80105cde:	6a 7d                	push   $0x7d
  jmp alltraps
80105ce0:	e9 09 f7 ff ff       	jmp    801053ee <alltraps>

80105ce5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $126
80105ce7:	6a 7e                	push   $0x7e
  jmp alltraps
80105ce9:	e9 00 f7 ff ff       	jmp    801053ee <alltraps>

80105cee <vector127>:
.globl vector127
vector127:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $127
80105cf0:	6a 7f                	push   $0x7f
  jmp alltraps
80105cf2:	e9 f7 f6 ff ff       	jmp    801053ee <alltraps>

80105cf7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $128
80105cf9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105cfe:	e9 eb f6 ff ff       	jmp    801053ee <alltraps>

80105d03 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $129
80105d05:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d0a:	e9 df f6 ff ff       	jmp    801053ee <alltraps>

80105d0f <vector130>:
.globl vector130
vector130:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $130
80105d11:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d16:	e9 d3 f6 ff ff       	jmp    801053ee <alltraps>

80105d1b <vector131>:
.globl vector131
vector131:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $131
80105d1d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d22:	e9 c7 f6 ff ff       	jmp    801053ee <alltraps>

80105d27 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $132
80105d29:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d2e:	e9 bb f6 ff ff       	jmp    801053ee <alltraps>

80105d33 <vector133>:
.globl vector133
vector133:
  pushl $0
80105d33:	6a 00                	push   $0x0
  pushl $133
80105d35:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105d3a:	e9 af f6 ff ff       	jmp    801053ee <alltraps>

80105d3f <vector134>:
.globl vector134
vector134:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $134
80105d41:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105d46:	e9 a3 f6 ff ff       	jmp    801053ee <alltraps>

80105d4b <vector135>:
.globl vector135
vector135:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $135
80105d4d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105d52:	e9 97 f6 ff ff       	jmp    801053ee <alltraps>

80105d57 <vector136>:
.globl vector136
vector136:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $136
80105d59:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105d5e:	e9 8b f6 ff ff       	jmp    801053ee <alltraps>

80105d63 <vector137>:
.globl vector137
vector137:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $137
80105d65:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105d6a:	e9 7f f6 ff ff       	jmp    801053ee <alltraps>

80105d6f <vector138>:
.globl vector138
vector138:
  pushl $0
80105d6f:	6a 00                	push   $0x0
  pushl $138
80105d71:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105d76:	e9 73 f6 ff ff       	jmp    801053ee <alltraps>

80105d7b <vector139>:
.globl vector139
vector139:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $139
80105d7d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105d82:	e9 67 f6 ff ff       	jmp    801053ee <alltraps>

80105d87 <vector140>:
.globl vector140
vector140:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $140
80105d89:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105d8e:	e9 5b f6 ff ff       	jmp    801053ee <alltraps>

80105d93 <vector141>:
.globl vector141
vector141:
  pushl $0
80105d93:	6a 00                	push   $0x0
  pushl $141
80105d95:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105d9a:	e9 4f f6 ff ff       	jmp    801053ee <alltraps>

80105d9f <vector142>:
.globl vector142
vector142:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $142
80105da1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105da6:	e9 43 f6 ff ff       	jmp    801053ee <alltraps>

80105dab <vector143>:
.globl vector143
vector143:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $143
80105dad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105db2:	e9 37 f6 ff ff       	jmp    801053ee <alltraps>

80105db7 <vector144>:
.globl vector144
vector144:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $144
80105db9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105dbe:	e9 2b f6 ff ff       	jmp    801053ee <alltraps>

80105dc3 <vector145>:
.globl vector145
vector145:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $145
80105dc5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105dca:	e9 1f f6 ff ff       	jmp    801053ee <alltraps>

80105dcf <vector146>:
.globl vector146
vector146:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $146
80105dd1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105dd6:	e9 13 f6 ff ff       	jmp    801053ee <alltraps>

80105ddb <vector147>:
.globl vector147
vector147:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $147
80105ddd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105de2:	e9 07 f6 ff ff       	jmp    801053ee <alltraps>

80105de7 <vector148>:
.globl vector148
vector148:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $148
80105de9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105dee:	e9 fb f5 ff ff       	jmp    801053ee <alltraps>

80105df3 <vector149>:
.globl vector149
vector149:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $149
80105df5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105dfa:	e9 ef f5 ff ff       	jmp    801053ee <alltraps>

80105dff <vector150>:
.globl vector150
vector150:
  pushl $0
80105dff:	6a 00                	push   $0x0
  pushl $150
80105e01:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e06:	e9 e3 f5 ff ff       	jmp    801053ee <alltraps>

80105e0b <vector151>:
.globl vector151
vector151:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $151
80105e0d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e12:	e9 d7 f5 ff ff       	jmp    801053ee <alltraps>

80105e17 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $152
80105e19:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e1e:	e9 cb f5 ff ff       	jmp    801053ee <alltraps>

80105e23 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e23:	6a 00                	push   $0x0
  pushl $153
80105e25:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e2a:	e9 bf f5 ff ff       	jmp    801053ee <alltraps>

80105e2f <vector154>:
.globl vector154
vector154:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $154
80105e31:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105e36:	e9 b3 f5 ff ff       	jmp    801053ee <alltraps>

80105e3b <vector155>:
.globl vector155
vector155:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $155
80105e3d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105e42:	e9 a7 f5 ff ff       	jmp    801053ee <alltraps>

80105e47 <vector156>:
.globl vector156
vector156:
  pushl $0
80105e47:	6a 00                	push   $0x0
  pushl $156
80105e49:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105e4e:	e9 9b f5 ff ff       	jmp    801053ee <alltraps>

80105e53 <vector157>:
.globl vector157
vector157:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $157
80105e55:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105e5a:	e9 8f f5 ff ff       	jmp    801053ee <alltraps>

80105e5f <vector158>:
.globl vector158
vector158:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $158
80105e61:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105e66:	e9 83 f5 ff ff       	jmp    801053ee <alltraps>

80105e6b <vector159>:
.globl vector159
vector159:
  pushl $0
80105e6b:	6a 00                	push   $0x0
  pushl $159
80105e6d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105e72:	e9 77 f5 ff ff       	jmp    801053ee <alltraps>

80105e77 <vector160>:
.globl vector160
vector160:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $160
80105e79:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105e7e:	e9 6b f5 ff ff       	jmp    801053ee <alltraps>

80105e83 <vector161>:
.globl vector161
vector161:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $161
80105e85:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105e8a:	e9 5f f5 ff ff       	jmp    801053ee <alltraps>

80105e8f <vector162>:
.globl vector162
vector162:
  pushl $0
80105e8f:	6a 00                	push   $0x0
  pushl $162
80105e91:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105e96:	e9 53 f5 ff ff       	jmp    801053ee <alltraps>

80105e9b <vector163>:
.globl vector163
vector163:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $163
80105e9d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105ea2:	e9 47 f5 ff ff       	jmp    801053ee <alltraps>

80105ea7 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $164
80105ea9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105eae:	e9 3b f5 ff ff       	jmp    801053ee <alltraps>

80105eb3 <vector165>:
.globl vector165
vector165:
  pushl $0
80105eb3:	6a 00                	push   $0x0
  pushl $165
80105eb5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105eba:	e9 2f f5 ff ff       	jmp    801053ee <alltraps>

80105ebf <vector166>:
.globl vector166
vector166:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $166
80105ec1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ec6:	e9 23 f5 ff ff       	jmp    801053ee <alltraps>

80105ecb <vector167>:
.globl vector167
vector167:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $167
80105ecd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ed2:	e9 17 f5 ff ff       	jmp    801053ee <alltraps>

80105ed7 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ed7:	6a 00                	push   $0x0
  pushl $168
80105ed9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ede:	e9 0b f5 ff ff       	jmp    801053ee <alltraps>

80105ee3 <vector169>:
.globl vector169
vector169:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $169
80105ee5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105eea:	e9 ff f4 ff ff       	jmp    801053ee <alltraps>

80105eef <vector170>:
.globl vector170
vector170:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $170
80105ef1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105ef6:	e9 f3 f4 ff ff       	jmp    801053ee <alltraps>

80105efb <vector171>:
.globl vector171
vector171:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $171
80105efd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f02:	e9 e7 f4 ff ff       	jmp    801053ee <alltraps>

80105f07 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $172
80105f09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f0e:	e9 db f4 ff ff       	jmp    801053ee <alltraps>

80105f13 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $173
80105f15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f1a:	e9 cf f4 ff ff       	jmp    801053ee <alltraps>

80105f1f <vector174>:
.globl vector174
vector174:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $174
80105f21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f26:	e9 c3 f4 ff ff       	jmp    801053ee <alltraps>

80105f2b <vector175>:
.globl vector175
vector175:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $175
80105f2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105f32:	e9 b7 f4 ff ff       	jmp    801053ee <alltraps>

80105f37 <vector176>:
.globl vector176
vector176:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $176
80105f39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105f3e:	e9 ab f4 ff ff       	jmp    801053ee <alltraps>

80105f43 <vector177>:
.globl vector177
vector177:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $177
80105f45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105f4a:	e9 9f f4 ff ff       	jmp    801053ee <alltraps>

80105f4f <vector178>:
.globl vector178
vector178:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $178
80105f51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105f56:	e9 93 f4 ff ff       	jmp    801053ee <alltraps>

80105f5b <vector179>:
.globl vector179
vector179:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $179
80105f5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105f62:	e9 87 f4 ff ff       	jmp    801053ee <alltraps>

80105f67 <vector180>:
.globl vector180
vector180:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $180
80105f69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105f6e:	e9 7b f4 ff ff       	jmp    801053ee <alltraps>

80105f73 <vector181>:
.globl vector181
vector181:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $181
80105f75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105f7a:	e9 6f f4 ff ff       	jmp    801053ee <alltraps>

80105f7f <vector182>:
.globl vector182
vector182:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $182
80105f81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105f86:	e9 63 f4 ff ff       	jmp    801053ee <alltraps>

80105f8b <vector183>:
.globl vector183
vector183:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $183
80105f8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105f92:	e9 57 f4 ff ff       	jmp    801053ee <alltraps>

80105f97 <vector184>:
.globl vector184
vector184:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $184
80105f99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105f9e:	e9 4b f4 ff ff       	jmp    801053ee <alltraps>

80105fa3 <vector185>:
.globl vector185
vector185:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $185
80105fa5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105faa:	e9 3f f4 ff ff       	jmp    801053ee <alltraps>

80105faf <vector186>:
.globl vector186
vector186:
  pushl $0
80105faf:	6a 00                	push   $0x0
  pushl $186
80105fb1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105fb6:	e9 33 f4 ff ff       	jmp    801053ee <alltraps>

80105fbb <vector187>:
.globl vector187
vector187:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $187
80105fbd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105fc2:	e9 27 f4 ff ff       	jmp    801053ee <alltraps>

80105fc7 <vector188>:
.globl vector188
vector188:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $188
80105fc9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105fce:	e9 1b f4 ff ff       	jmp    801053ee <alltraps>

80105fd3 <vector189>:
.globl vector189
vector189:
  pushl $0
80105fd3:	6a 00                	push   $0x0
  pushl $189
80105fd5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105fda:	e9 0f f4 ff ff       	jmp    801053ee <alltraps>

80105fdf <vector190>:
.globl vector190
vector190:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $190
80105fe1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105fe6:	e9 03 f4 ff ff       	jmp    801053ee <alltraps>

80105feb <vector191>:
.globl vector191
vector191:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $191
80105fed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105ff2:	e9 f7 f3 ff ff       	jmp    801053ee <alltraps>

80105ff7 <vector192>:
.globl vector192
vector192:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $192
80105ff9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105ffe:	e9 eb f3 ff ff       	jmp    801053ee <alltraps>

80106003 <vector193>:
.globl vector193
vector193:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $193
80106005:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010600a:	e9 df f3 ff ff       	jmp    801053ee <alltraps>

8010600f <vector194>:
.globl vector194
vector194:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $194
80106011:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106016:	e9 d3 f3 ff ff       	jmp    801053ee <alltraps>

8010601b <vector195>:
.globl vector195
vector195:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $195
8010601d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106022:	e9 c7 f3 ff ff       	jmp    801053ee <alltraps>

80106027 <vector196>:
.globl vector196
vector196:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $196
80106029:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010602e:	e9 bb f3 ff ff       	jmp    801053ee <alltraps>

80106033 <vector197>:
.globl vector197
vector197:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $197
80106035:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010603a:	e9 af f3 ff ff       	jmp    801053ee <alltraps>

8010603f <vector198>:
.globl vector198
vector198:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $198
80106041:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106046:	e9 a3 f3 ff ff       	jmp    801053ee <alltraps>

8010604b <vector199>:
.globl vector199
vector199:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $199
8010604d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106052:	e9 97 f3 ff ff       	jmp    801053ee <alltraps>

80106057 <vector200>:
.globl vector200
vector200:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $200
80106059:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010605e:	e9 8b f3 ff ff       	jmp    801053ee <alltraps>

80106063 <vector201>:
.globl vector201
vector201:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $201
80106065:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010606a:	e9 7f f3 ff ff       	jmp    801053ee <alltraps>

8010606f <vector202>:
.globl vector202
vector202:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $202
80106071:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106076:	e9 73 f3 ff ff       	jmp    801053ee <alltraps>

8010607b <vector203>:
.globl vector203
vector203:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $203
8010607d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106082:	e9 67 f3 ff ff       	jmp    801053ee <alltraps>

80106087 <vector204>:
.globl vector204
vector204:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $204
80106089:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010608e:	e9 5b f3 ff ff       	jmp    801053ee <alltraps>

80106093 <vector205>:
.globl vector205
vector205:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $205
80106095:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010609a:	e9 4f f3 ff ff       	jmp    801053ee <alltraps>

8010609f <vector206>:
.globl vector206
vector206:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $206
801060a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801060a6:	e9 43 f3 ff ff       	jmp    801053ee <alltraps>

801060ab <vector207>:
.globl vector207
vector207:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $207
801060ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801060b2:	e9 37 f3 ff ff       	jmp    801053ee <alltraps>

801060b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $208
801060b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801060be:	e9 2b f3 ff ff       	jmp    801053ee <alltraps>

801060c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $209
801060c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801060ca:	e9 1f f3 ff ff       	jmp    801053ee <alltraps>

801060cf <vector210>:
.globl vector210
vector210:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $210
801060d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801060d6:	e9 13 f3 ff ff       	jmp    801053ee <alltraps>

801060db <vector211>:
.globl vector211
vector211:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $211
801060dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801060e2:	e9 07 f3 ff ff       	jmp    801053ee <alltraps>

801060e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $212
801060e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801060ee:	e9 fb f2 ff ff       	jmp    801053ee <alltraps>

801060f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $213
801060f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801060fa:	e9 ef f2 ff ff       	jmp    801053ee <alltraps>

801060ff <vector214>:
.globl vector214
vector214:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $214
80106101:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106106:	e9 e3 f2 ff ff       	jmp    801053ee <alltraps>

8010610b <vector215>:
.globl vector215
vector215:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $215
8010610d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106112:	e9 d7 f2 ff ff       	jmp    801053ee <alltraps>

80106117 <vector216>:
.globl vector216
vector216:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $216
80106119:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010611e:	e9 cb f2 ff ff       	jmp    801053ee <alltraps>

80106123 <vector217>:
.globl vector217
vector217:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $217
80106125:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010612a:	e9 bf f2 ff ff       	jmp    801053ee <alltraps>

8010612f <vector218>:
.globl vector218
vector218:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $218
80106131:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106136:	e9 b3 f2 ff ff       	jmp    801053ee <alltraps>

8010613b <vector219>:
.globl vector219
vector219:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $219
8010613d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106142:	e9 a7 f2 ff ff       	jmp    801053ee <alltraps>

80106147 <vector220>:
.globl vector220
vector220:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $220
80106149:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010614e:	e9 9b f2 ff ff       	jmp    801053ee <alltraps>

80106153 <vector221>:
.globl vector221
vector221:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $221
80106155:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010615a:	e9 8f f2 ff ff       	jmp    801053ee <alltraps>

8010615f <vector222>:
.globl vector222
vector222:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $222
80106161:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106166:	e9 83 f2 ff ff       	jmp    801053ee <alltraps>

8010616b <vector223>:
.globl vector223
vector223:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $223
8010616d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106172:	e9 77 f2 ff ff       	jmp    801053ee <alltraps>

80106177 <vector224>:
.globl vector224
vector224:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $224
80106179:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010617e:	e9 6b f2 ff ff       	jmp    801053ee <alltraps>

80106183 <vector225>:
.globl vector225
vector225:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $225
80106185:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010618a:	e9 5f f2 ff ff       	jmp    801053ee <alltraps>

8010618f <vector226>:
.globl vector226
vector226:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $226
80106191:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106196:	e9 53 f2 ff ff       	jmp    801053ee <alltraps>

8010619b <vector227>:
.globl vector227
vector227:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $227
8010619d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801061a2:	e9 47 f2 ff ff       	jmp    801053ee <alltraps>

801061a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $228
801061a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801061ae:	e9 3b f2 ff ff       	jmp    801053ee <alltraps>

801061b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $229
801061b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801061ba:	e9 2f f2 ff ff       	jmp    801053ee <alltraps>

801061bf <vector230>:
.globl vector230
vector230:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $230
801061c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801061c6:	e9 23 f2 ff ff       	jmp    801053ee <alltraps>

801061cb <vector231>:
.globl vector231
vector231:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $231
801061cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801061d2:	e9 17 f2 ff ff       	jmp    801053ee <alltraps>

801061d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $232
801061d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801061de:	e9 0b f2 ff ff       	jmp    801053ee <alltraps>

801061e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $233
801061e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801061ea:	e9 ff f1 ff ff       	jmp    801053ee <alltraps>

801061ef <vector234>:
.globl vector234
vector234:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $234
801061f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801061f6:	e9 f3 f1 ff ff       	jmp    801053ee <alltraps>

801061fb <vector235>:
.globl vector235
vector235:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $235
801061fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106202:	e9 e7 f1 ff ff       	jmp    801053ee <alltraps>

80106207 <vector236>:
.globl vector236
vector236:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $236
80106209:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010620e:	e9 db f1 ff ff       	jmp    801053ee <alltraps>

80106213 <vector237>:
.globl vector237
vector237:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $237
80106215:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010621a:	e9 cf f1 ff ff       	jmp    801053ee <alltraps>

8010621f <vector238>:
.globl vector238
vector238:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $238
80106221:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106226:	e9 c3 f1 ff ff       	jmp    801053ee <alltraps>

8010622b <vector239>:
.globl vector239
vector239:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $239
8010622d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106232:	e9 b7 f1 ff ff       	jmp    801053ee <alltraps>

80106237 <vector240>:
.globl vector240
vector240:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $240
80106239:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010623e:	e9 ab f1 ff ff       	jmp    801053ee <alltraps>

80106243 <vector241>:
.globl vector241
vector241:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $241
80106245:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010624a:	e9 9f f1 ff ff       	jmp    801053ee <alltraps>

8010624f <vector242>:
.globl vector242
vector242:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $242
80106251:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106256:	e9 93 f1 ff ff       	jmp    801053ee <alltraps>

8010625b <vector243>:
.globl vector243
vector243:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $243
8010625d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106262:	e9 87 f1 ff ff       	jmp    801053ee <alltraps>

80106267 <vector244>:
.globl vector244
vector244:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $244
80106269:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010626e:	e9 7b f1 ff ff       	jmp    801053ee <alltraps>

80106273 <vector245>:
.globl vector245
vector245:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $245
80106275:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010627a:	e9 6f f1 ff ff       	jmp    801053ee <alltraps>

8010627f <vector246>:
.globl vector246
vector246:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $246
80106281:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106286:	e9 63 f1 ff ff       	jmp    801053ee <alltraps>

8010628b <vector247>:
.globl vector247
vector247:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $247
8010628d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106292:	e9 57 f1 ff ff       	jmp    801053ee <alltraps>

80106297 <vector248>:
.globl vector248
vector248:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $248
80106299:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010629e:	e9 4b f1 ff ff       	jmp    801053ee <alltraps>

801062a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $249
801062a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801062aa:	e9 3f f1 ff ff       	jmp    801053ee <alltraps>

801062af <vector250>:
.globl vector250
vector250:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $250
801062b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801062b6:	e9 33 f1 ff ff       	jmp    801053ee <alltraps>

801062bb <vector251>:
.globl vector251
vector251:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $251
801062bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801062c2:	e9 27 f1 ff ff       	jmp    801053ee <alltraps>

801062c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $252
801062c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801062ce:	e9 1b f1 ff ff       	jmp    801053ee <alltraps>

801062d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $253
801062d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801062da:	e9 0f f1 ff ff       	jmp    801053ee <alltraps>

801062df <vector254>:
.globl vector254
vector254:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $254
801062e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801062e6:	e9 03 f1 ff ff       	jmp    801053ee <alltraps>

801062eb <vector255>:
.globl vector255
vector255:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $255
801062ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801062f2:	e9 f7 f0 ff ff       	jmp    801053ee <alltraps>
801062f7:	90                   	nop

801062f8 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801062f8:	55                   	push   %ebp
801062f9:	89 e5                	mov    %esp,%ebp
801062fb:	57                   	push   %edi
801062fc:	56                   	push   %esi
801062fd:	53                   	push   %ebx
801062fe:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106301:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106307:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010630d:	39 d3                	cmp    %edx,%ebx
8010630f:	73 50                	jae    80106361 <deallocuvm.part.0+0x69>
80106311:	89 c6                	mov    %eax,%esi
80106313:	89 d7                	mov    %edx,%edi
80106315:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106318:	eb 0c                	jmp    80106326 <deallocuvm.part.0+0x2e>
8010631a:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010631c:	42                   	inc    %edx
8010631d:	89 d3                	mov    %edx,%ebx
8010631f:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106322:	39 fb                	cmp    %edi,%ebx
80106324:	73 38                	jae    8010635e <deallocuvm.part.0+0x66>
  pde = &pgdir[PDX(va)];
80106326:	89 da                	mov    %ebx,%edx
80106328:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010632b:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010632e:	a8 01                	test   $0x1,%al
80106330:	74 ea                	je     8010631c <deallocuvm.part.0+0x24>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106337:	89 d9                	mov    %ebx,%ecx
80106339:	c1 e9 0a             	shr    $0xa,%ecx
8010633c:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106342:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106349:	85 c0                	test   %eax,%eax
8010634b:	74 cf                	je     8010631c <deallocuvm.part.0+0x24>
    else if((*pte & PTE_P) != 0){
8010634d:	8b 10                	mov    (%eax),%edx
8010634f:	f6 c2 01             	test   $0x1,%dl
80106352:	75 18                	jne    8010636c <deallocuvm.part.0+0x74>
  for(; a  < oldsz; a += PGSIZE){
80106354:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010635a:	39 fb                	cmp    %edi,%ebx
8010635c:	72 c8                	jb     80106326 <deallocuvm.part.0+0x2e>
8010635e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106361:	89 c8                	mov    %ecx,%eax
80106363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106366:	5b                   	pop    %ebx
80106367:	5e                   	pop    %esi
80106368:	5f                   	pop    %edi
80106369:	5d                   	pop    %ebp
8010636a:	c3                   	ret
8010636b:	90                   	nop
      if(pa == 0)
8010636c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106372:	74 26                	je     8010639a <deallocuvm.part.0+0xa2>
80106374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106377:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010637a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106380:	52                   	push   %edx
80106381:	e8 7e be ff ff       	call   80102204 <kfree>
      *pte = 0;
80106386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
8010638f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106395:	83 c4 10             	add    $0x10,%esp
80106398:	eb 88                	jmp    80106322 <deallocuvm.part.0+0x2a>
        panic("kfree");
8010639a:	83 ec 0c             	sub    $0xc,%esp
8010639d:	68 ac 6d 10 80       	push   $0x80106dac
801063a2:	e8 91 9f ff ff       	call   80100338 <panic>
801063a7:	90                   	nop

801063a8 <mappages>:
{
801063a8:	55                   	push   %ebp
801063a9:	89 e5                	mov    %esp,%ebp
801063ab:	57                   	push   %edi
801063ac:	56                   	push   %esi
801063ad:	53                   	push   %ebx
801063ae:	83 ec 1c             	sub    $0x1c,%esp
801063b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
801063b4:	89 d3                	mov    %edx,%ebx
801063b6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801063bc:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801063c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801063c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063c8:	8b 45 08             	mov    0x8(%ebp),%eax
801063cb:	29 d8                	sub    %ebx,%eax
801063cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063d0:	eb 3b                	jmp    8010640d <mappages+0x65>
801063d2:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801063d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801063d9:	89 da                	mov    %ebx,%edx
801063db:	c1 ea 0a             	shr    $0xa,%edx
801063de:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063e4:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801063eb:	85 c0                	test   %eax,%eax
801063ed:	74 71                	je     80106460 <mappages+0xb8>
    if(*pte & PTE_P)
801063ef:	f6 00 01             	testb  $0x1,(%eax)
801063f2:	0f 85 82 00 00 00    	jne    8010647a <mappages+0xd2>
    *pte = pa | perm | PTE_P;
801063f8:	0b 75 0c             	or     0xc(%ebp),%esi
801063fb:	83 ce 01             	or     $0x1,%esi
801063fe:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106400:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106403:	39 c3                	cmp    %eax,%ebx
80106405:	74 69                	je     80106470 <mappages+0xc8>
    a += PGSIZE;
80106407:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
8010640d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106410:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  pde = &pgdir[PDX(va)];
80106413:	89 d8                	mov    %ebx,%eax
80106415:	c1 e8 16             	shr    $0x16,%eax
80106418:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010641b:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010641e:	8b 07                	mov    (%edi),%eax
80106420:	a8 01                	test   $0x1,%al
80106422:	75 b0                	jne    801063d4 <mappages+0x2c>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106424:	e8 6b bf ff ff       	call   80102394 <kalloc>
80106429:	89 c2                	mov    %eax,%edx
8010642b:	85 c0                	test   %eax,%eax
8010642d:	74 31                	je     80106460 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
8010642f:	50                   	push   %eax
80106430:	68 00 10 00 00       	push   $0x1000
80106435:	6a 00                	push   $0x0
80106437:	52                   	push   %edx
80106438:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010643b:	e8 dc df ff ff       	call   8010441c <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106440:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106443:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106449:	83 c8 07             	or     $0x7,%eax
8010644c:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010644e:	89 d8                	mov    %ebx,%eax
80106450:	c1 e8 0a             	shr    $0xa,%eax
80106453:	25 fc 0f 00 00       	and    $0xffc,%eax
80106458:	01 d0                	add    %edx,%eax
8010645a:	83 c4 10             	add    $0x10,%esp
8010645d:	eb 90                	jmp    801063ef <mappages+0x47>
8010645f:	90                   	nop
      return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106468:	5b                   	pop    %ebx
80106469:	5e                   	pop    %esi
8010646a:	5f                   	pop    %edi
8010646b:	5d                   	pop    %ebp
8010646c:	c3                   	ret
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
80106470:	31 c0                	xor    %eax,%eax
}
80106472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106475:	5b                   	pop    %ebx
80106476:	5e                   	pop    %esi
80106477:	5f                   	pop    %edi
80106478:	5d                   	pop    %ebp
80106479:	c3                   	ret
      panic("remap");
8010647a:	83 ec 0c             	sub    $0xc,%esp
8010647d:	68 62 70 10 80       	push   $0x80107062
80106482:	e8 b1 9e ff ff       	call   80100338 <panic>
80106487:	90                   	nop

80106488 <seginit>:
{
80106488:	55                   	push   %ebp
80106489:	89 e5                	mov    %esp,%ebp
8010648b:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010648e:	e8 d9 d0 ff ff       	call   8010356c <cpuid>
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106493:	8d 14 80             	lea    (%eax,%eax,4),%edx
80106496:	01 d2                	add    %edx,%edx
80106498:	01 d0                	add    %edx,%eax
8010649a:	c1 e0 04             	shl    $0x4,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010649d:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801064a4:	ff 00 00 
801064a7:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801064ae:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064b1:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
801064b8:	ff 00 00 
801064bb:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
801064c2:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064c5:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
801064cc:	ff 00 00 
801064cf:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
801064d6:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064d9:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
801064e0:	ff 00 00 
801064e3:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
801064ea:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801064ed:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[0] = size-1;
801064f2:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801064f8:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801064fc:	c1 e8 10             	shr    $0x10,%eax
801064ff:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106503:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106506:	0f 01 10             	lgdtl  (%eax)
}
80106509:	c9                   	leave
8010650a:	c3                   	ret
8010650b:	90                   	nop

8010650c <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010650c:	a1 c4 4b 11 80       	mov    0x80114bc4,%eax
80106511:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106516:	0f 22 d8             	mov    %eax,%cr3
}
80106519:	c3                   	ret
8010651a:	66 90                	xchg   %ax,%ax

8010651c <switchuvm>:
{
8010651c:	55                   	push   %ebp
8010651d:	89 e5                	mov    %esp,%ebp
8010651f:	57                   	push   %edi
80106520:	56                   	push   %esi
80106521:	53                   	push   %ebx
80106522:	83 ec 1c             	sub    $0x1c,%esp
80106525:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106528:	85 f6                	test   %esi,%esi
8010652a:	0f 84 bf 00 00 00    	je     801065ef <switchuvm+0xd3>
  if(p->kstack == 0)
80106530:	8b 56 24             	mov    0x24(%esi),%edx
80106533:	85 d2                	test   %edx,%edx
80106535:	0f 84 ce 00 00 00    	je     80106609 <switchuvm+0xed>
  if(p->pgdir == 0)
8010653b:	8b 46 20             	mov    0x20(%esi),%eax
8010653e:	85 c0                	test   %eax,%eax
80106540:	0f 84 b6 00 00 00    	je     801065fc <switchuvm+0xe0>
  pushcli();
80106546:	e8 c1 dc ff ff       	call   8010420c <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010654b:	e8 b8 cf ff ff       	call   80103508 <mycpu>
80106550:	89 c3                	mov    %eax,%ebx
80106552:	e8 b1 cf ff ff       	call   80103508 <mycpu>
80106557:	89 c7                	mov    %eax,%edi
80106559:	e8 aa cf ff ff       	call   80103508 <mycpu>
8010655e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106561:	e8 a2 cf ff ff       	call   80103508 <mycpu>
80106566:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010656d:	67 00 
8010656f:	83 c7 08             	add    $0x8,%edi
80106572:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106579:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010657c:	83 c1 08             	add    $0x8,%ecx
8010657f:	c1 e9 10             	shr    $0x10,%ecx
80106582:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106588:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
8010658f:	99 40 
80106591:	83 c0 08             	add    $0x8,%eax
80106594:	c1 e8 18             	shr    $0x18,%eax
80106597:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
8010659d:	e8 66 cf ff ff       	call   80103508 <mycpu>
801065a2:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801065a9:	e8 5a cf ff ff       	call   80103508 <mycpu>
801065ae:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801065b4:	8b 5e 24             	mov    0x24(%esi),%ebx
801065b7:	e8 4c cf ff ff       	call   80103508 <mycpu>
801065bc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065c2:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801065c5:	e8 3e cf ff ff       	call   80103508 <mycpu>
801065ca:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801065d0:	b8 28 00 00 00       	mov    $0x28,%eax
801065d5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801065d8:	8b 46 20             	mov    0x20(%esi),%eax
801065db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065e0:	0f 22 d8             	mov    %eax,%cr3
}
801065e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065e6:	5b                   	pop    %ebx
801065e7:	5e                   	pop    %esi
801065e8:	5f                   	pop    %edi
801065e9:	5d                   	pop    %ebp
  popcli();
801065ea:	e9 69 dc ff ff       	jmp    80104258 <popcli>
    panic("switchuvm: no process");
801065ef:	83 ec 0c             	sub    $0xc,%esp
801065f2:	68 68 70 10 80       	push   $0x80107068
801065f7:	e8 3c 9d ff ff       	call   80100338 <panic>
    panic("switchuvm: no pgdir");
801065fc:	83 ec 0c             	sub    $0xc,%esp
801065ff:	68 93 70 10 80       	push   $0x80107093
80106604:	e8 2f 9d ff ff       	call   80100338 <panic>
    panic("switchuvm: no kstack");
80106609:	83 ec 0c             	sub    $0xc,%esp
8010660c:	68 7e 70 10 80       	push   $0x8010707e
80106611:	e8 22 9d ff ff       	call   80100338 <panic>
80106616:	66 90                	xchg   %ax,%ax

80106618 <inituvm>:
{
80106618:	55                   	push   %ebp
80106619:	89 e5                	mov    %esp,%ebp
8010661b:	57                   	push   %edi
8010661c:	56                   	push   %esi
8010661d:	53                   	push   %ebx
8010661e:	83 ec 1c             	sub    $0x1c,%esp
80106621:	8b 45 08             	mov    0x8(%ebp),%eax
80106624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010662a:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
8010662d:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106633:	77 47                	ja     8010667c <inituvm+0x64>
  mem = kalloc();
80106635:	e8 5a bd ff ff       	call   80102394 <kalloc>
8010663a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010663c:	50                   	push   %eax
8010663d:	68 00 10 00 00       	push   $0x1000
80106642:	6a 00                	push   $0x0
80106644:	53                   	push   %ebx
80106645:	e8 d2 dd ff ff       	call   8010441c <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010664a:	5a                   	pop    %edx
8010664b:	59                   	pop    %ecx
8010664c:	6a 06                	push   $0x6
8010664e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106654:	50                   	push   %eax
80106655:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010665a:	31 d2                	xor    %edx,%edx
8010665c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010665f:	e8 44 fd ff ff       	call   801063a8 <mappages>
  memmove(mem, init, sz);
80106664:	83 c4 10             	add    $0x10,%esp
80106667:	89 75 10             	mov    %esi,0x10(%ebp)
8010666a:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010666d:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106673:	5b                   	pop    %ebx
80106674:	5e                   	pop    %esi
80106675:	5f                   	pop    %edi
80106676:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106677:	e9 1c de ff ff       	jmp    80104498 <memmove>
    panic("inituvm: more than a page");
8010667c:	83 ec 0c             	sub    $0xc,%esp
8010667f:	68 a7 70 10 80       	push   $0x801070a7
80106684:	e8 af 9c ff ff       	call   80100338 <panic>
80106689:	8d 76 00             	lea    0x0(%esi),%esi

8010668c <loaduvm>:
{
8010668c:	55                   	push   %ebp
8010668d:	89 e5                	mov    %esp,%ebp
8010668f:	57                   	push   %edi
80106690:	56                   	push   %esi
80106691:	53                   	push   %ebx
80106692:	83 ec 0c             	sub    $0xc,%esp
80106695:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106698:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010669b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801066a1:	0f 85 9a 00 00 00    	jne    80106741 <loaduvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
801066a7:	85 ff                	test   %edi,%edi
801066a9:	74 7c                	je     80106727 <loaduvm+0x9b>
801066ab:	90                   	nop
  pde = &pgdir[PDX(va)];
801066ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801066af:	01 d8                	add    %ebx,%eax
801066b1:	89 c2                	mov    %eax,%edx
801066b3:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801066b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801066b9:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801066bc:	f6 c2 01             	test   $0x1,%dl
801066bf:	75 0f                	jne    801066d0 <loaduvm+0x44>
      panic("loaduvm: address should exist");
801066c1:	83 ec 0c             	sub    $0xc,%esp
801066c4:	68 c1 70 10 80       	push   $0x801070c1
801066c9:	e8 6a 9c ff ff       	call   80100338 <panic>
801066ce:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066d0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801066d6:	c1 e8 0a             	shr    $0xa,%eax
801066d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801066de:	8d 8c 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801066e5:	85 c9                	test   %ecx,%ecx
801066e7:	74 d8                	je     801066c1 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801066e9:	89 fe                	mov    %edi,%esi
801066eb:	29 de                	sub    %ebx,%esi
801066ed:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801066f3:	76 05                	jbe    801066fa <loaduvm+0x6e>
801066f5:	be 00 10 00 00       	mov    $0x1000,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801066fa:	56                   	push   %esi
801066fb:	8b 45 14             	mov    0x14(%ebp),%eax
801066fe:	01 d8                	add    %ebx,%eax
80106700:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106701:	8b 01                	mov    (%ecx),%eax
80106703:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106708:	05 00 00 00 80       	add    $0x80000000,%eax
8010670d:	50                   	push   %eax
8010670e:	ff 75 10             	push   0x10(%ebp)
80106711:	e8 da b1 ff ff       	call   801018f0 <readi>
80106716:	83 c4 10             	add    $0x10,%esp
80106719:	39 f0                	cmp    %esi,%eax
8010671b:	75 17                	jne    80106734 <loaduvm+0xa8>
  for(i = 0; i < sz; i += PGSIZE){
8010671d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106723:	39 fb                	cmp    %edi,%ebx
80106725:	72 85                	jb     801066ac <loaduvm+0x20>
  return 0;
80106727:	31 c0                	xor    %eax,%eax
}
80106729:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010672c:	5b                   	pop    %ebx
8010672d:	5e                   	pop    %esi
8010672e:	5f                   	pop    %edi
8010672f:	5d                   	pop    %ebp
80106730:	c3                   	ret
80106731:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
80106734:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010673c:	5b                   	pop    %ebx
8010673d:	5e                   	pop    %esi
8010673e:	5f                   	pop    %edi
8010673f:	5d                   	pop    %ebp
80106740:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106741:	83 ec 0c             	sub    $0xc,%esp
80106744:	68 7c 73 10 80       	push   $0x8010737c
80106749:	e8 ea 9b ff ff       	call   80100338 <panic>
8010674e:	66 90                	xchg   %ax,%ax

80106750 <allocuvm>:
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	83 ec 1c             	sub    $0x1c,%esp
80106759:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010675c:	85 f6                	test   %esi,%esi
8010675e:	0f 88 91 00 00 00    	js     801067f5 <allocuvm+0xa5>
80106764:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106766:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106769:	0f 82 95 00 00 00    	jb     80106804 <allocuvm+0xb4>
  a = PGROUNDUP(oldsz);
8010676f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106772:	05 ff 0f 00 00       	add    $0xfff,%eax
80106777:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010677c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010677e:	39 f0                	cmp    %esi,%eax
80106780:	0f 83 81 00 00 00    	jae    80106807 <allocuvm+0xb7>
80106786:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106789:	eb 3d                	jmp    801067c8 <allocuvm+0x78>
8010678b:	90                   	nop
    memset(mem, 0, PGSIZE);
8010678c:	50                   	push   %eax
8010678d:	68 00 10 00 00       	push   $0x1000
80106792:	6a 00                	push   $0x0
80106794:	53                   	push   %ebx
80106795:	e8 82 dc ff ff       	call   8010441c <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010679a:	5a                   	pop    %edx
8010679b:	59                   	pop    %ecx
8010679c:	6a 06                	push   $0x6
8010679e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067a4:	50                   	push   %eax
801067a5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801067aa:	89 fa                	mov    %edi,%edx
801067ac:	8b 45 08             	mov    0x8(%ebp),%eax
801067af:	e8 f4 fb ff ff       	call   801063a8 <mappages>
801067b4:	83 c4 10             	add    $0x10,%esp
801067b7:	40                   	inc    %eax
801067b8:	74 5a                	je     80106814 <allocuvm+0xc4>
  for(; a < newsz; a += PGSIZE){
801067ba:	81 c7 00 10 00 00    	add    $0x1000,%edi
801067c0:	39 f7                	cmp    %esi,%edi
801067c2:	0f 83 80 00 00 00    	jae    80106848 <allocuvm+0xf8>
    mem = kalloc();
801067c8:	e8 c7 bb ff ff       	call   80102394 <kalloc>
801067cd:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801067cf:	85 c0                	test   %eax,%eax
801067d1:	75 b9                	jne    8010678c <allocuvm+0x3c>
      cprintf("allocuvm out of memory\n");
801067d3:	83 ec 0c             	sub    $0xc,%esp
801067d6:	68 df 70 10 80       	push   $0x801070df
801067db:	e8 40 9e ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
801067e0:	83 c4 10             	add    $0x10,%esp
801067e3:	3b 75 0c             	cmp    0xc(%ebp),%esi
801067e6:	74 0d                	je     801067f5 <allocuvm+0xa5>
801067e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801067eb:	89 f2                	mov    %esi,%edx
801067ed:	8b 45 08             	mov    0x8(%ebp),%eax
801067f0:	e8 03 fb ff ff       	call   801062f8 <deallocuvm.part.0>
    return 0;
801067f5:	31 d2                	xor    %edx,%edx
}
801067f7:	89 d0                	mov    %edx,%eax
801067f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067fc:	5b                   	pop    %ebx
801067fd:	5e                   	pop    %esi
801067fe:	5f                   	pop    %edi
801067ff:	5d                   	pop    %ebp
80106800:	c3                   	ret
80106801:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80106804:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106807:	89 d0                	mov    %edx,%eax
80106809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010680c:	5b                   	pop    %ebx
8010680d:	5e                   	pop    %esi
8010680e:	5f                   	pop    %edi
8010680f:	5d                   	pop    %ebp
80106810:	c3                   	ret
80106811:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106814:	83 ec 0c             	sub    $0xc,%esp
80106817:	68 f7 70 10 80       	push   $0x801070f7
8010681c:	e8 ff 9d ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106821:	83 c4 10             	add    $0x10,%esp
80106824:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106827:	74 0d                	je     80106836 <allocuvm+0xe6>
80106829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010682c:	89 f2                	mov    %esi,%edx
8010682e:	8b 45 08             	mov    0x8(%ebp),%eax
80106831:	e8 c2 fa ff ff       	call   801062f8 <deallocuvm.part.0>
      kfree(mem);
80106836:	83 ec 0c             	sub    $0xc,%esp
80106839:	53                   	push   %ebx
8010683a:	e8 c5 b9 ff ff       	call   80102204 <kfree>
      return 0;
8010683f:	83 c4 10             	add    $0x10,%esp
    return 0;
80106842:	31 d2                	xor    %edx,%edx
80106844:	eb b1                	jmp    801067f7 <allocuvm+0xa7>
80106846:	66 90                	xchg   %ax,%ax
80106848:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010684b:	89 d0                	mov    %edx,%eax
8010684d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106850:	5b                   	pop    %ebx
80106851:	5e                   	pop    %esi
80106852:	5f                   	pop    %edi
80106853:	5d                   	pop    %ebp
80106854:	c3                   	ret
80106855:	8d 76 00             	lea    0x0(%esi),%esi

80106858 <deallocuvm>:
{
80106858:	55                   	push   %ebp
80106859:	89 e5                	mov    %esp,%ebp
8010685b:	8b 45 08             	mov    0x8(%ebp),%eax
8010685e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106861:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
80106864:	39 d1                	cmp    %edx,%ecx
80106866:	73 08                	jae    80106870 <deallocuvm+0x18>
}
80106868:	5d                   	pop    %ebp
80106869:	e9 8a fa ff ff       	jmp    801062f8 <deallocuvm.part.0>
8010686e:	66 90                	xchg   %ax,%ax
80106870:	89 d0                	mov    %edx,%eax
80106872:	5d                   	pop    %ebp
80106873:	c3                   	ret

80106874 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106874:	55                   	push   %ebp
80106875:	89 e5                	mov    %esp,%ebp
80106877:	57                   	push   %edi
80106878:	56                   	push   %esi
80106879:	53                   	push   %ebx
8010687a:	83 ec 0c             	sub    $0xc,%esp
8010687d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106880:	85 f6                	test   %esi,%esi
80106882:	74 51                	je     801068d5 <freevm+0x61>
  if(newsz >= oldsz)
80106884:	31 c9                	xor    %ecx,%ecx
80106886:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010688b:	89 f0                	mov    %esi,%eax
8010688d:	e8 66 fa ff ff       	call   801062f8 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106892:	89 f3                	mov    %esi,%ebx
80106894:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010689a:	eb 07                	jmp    801068a3 <freevm+0x2f>
8010689c:	83 c3 04             	add    $0x4,%ebx
8010689f:	39 fb                	cmp    %edi,%ebx
801068a1:	74 23                	je     801068c6 <freevm+0x52>
    if(pgdir[i] & PTE_P){
801068a3:	8b 03                	mov    (%ebx),%eax
801068a5:	a8 01                	test   $0x1,%al
801068a7:	74 f3                	je     8010689c <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801068a9:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801068ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068b1:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801068b6:	50                   	push   %eax
801068b7:	e8 48 b9 ff ff       	call   80102204 <kfree>
801068bc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801068bf:	83 c3 04             	add    $0x4,%ebx
801068c2:	39 fb                	cmp    %edi,%ebx
801068c4:	75 dd                	jne    801068a3 <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
801068c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801068c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068cc:	5b                   	pop    %ebx
801068cd:	5e                   	pop    %esi
801068ce:	5f                   	pop    %edi
801068cf:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801068d0:	e9 2f b9 ff ff       	jmp    80102204 <kfree>
    panic("freevm: no pgdir");
801068d5:	83 ec 0c             	sub    $0xc,%esp
801068d8:	68 13 71 10 80       	push   $0x80107113
801068dd:	e8 56 9a ff ff       	call   80100338 <panic>
801068e2:	66 90                	xchg   %ax,%ax

801068e4 <setupkvm>:
{
801068e4:	55                   	push   %ebp
801068e5:	89 e5                	mov    %esp,%ebp
801068e7:	56                   	push   %esi
801068e8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801068e9:	e8 a6 ba ff ff       	call   80102394 <kalloc>
801068ee:	85 c0                	test   %eax,%eax
801068f0:	74 56                	je     80106948 <setupkvm+0x64>
801068f2:	89 c6                	mov    %eax,%esi
  memset(pgdir, 0, PGSIZE);
801068f4:	50                   	push   %eax
801068f5:	68 00 10 00 00       	push   $0x1000
801068fa:	6a 00                	push   $0x0
801068fc:	56                   	push   %esi
801068fd:	e8 1a db ff ff       	call   8010441c <memset>
80106902:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106905:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010690a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010690d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106910:	29 c1                	sub    %eax,%ecx
80106912:	8b 13                	mov    (%ebx),%edx
80106914:	83 ec 08             	sub    $0x8,%esp
80106917:	ff 73 0c             	push   0xc(%ebx)
8010691a:	50                   	push   %eax
8010691b:	89 f0                	mov    %esi,%eax
8010691d:	e8 86 fa ff ff       	call   801063a8 <mappages>
80106922:	83 c4 10             	add    $0x10,%esp
80106925:	40                   	inc    %eax
80106926:	74 14                	je     8010693c <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106928:	83 c3 10             	add    $0x10,%ebx
8010692b:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106931:	75 d7                	jne    8010690a <setupkvm+0x26>
}
80106933:	89 f0                	mov    %esi,%eax
80106935:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106938:	5b                   	pop    %ebx
80106939:	5e                   	pop    %esi
8010693a:	5d                   	pop    %ebp
8010693b:	c3                   	ret
      freevm(pgdir);
8010693c:	83 ec 0c             	sub    $0xc,%esp
8010693f:	56                   	push   %esi
80106940:	e8 2f ff ff ff       	call   80106874 <freevm>
      return 0;
80106945:	83 c4 10             	add    $0x10,%esp
    return 0;
80106948:	31 f6                	xor    %esi,%esi
}
8010694a:	89 f0                	mov    %esi,%eax
8010694c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010694f:	5b                   	pop    %ebx
80106950:	5e                   	pop    %esi
80106951:	5d                   	pop    %ebp
80106952:	c3                   	ret
80106953:	90                   	nop

80106954 <kvmalloc>:
{
80106954:	55                   	push   %ebp
80106955:	89 e5                	mov    %esp,%ebp
80106957:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010695a:	e8 85 ff ff ff       	call   801068e4 <setupkvm>
8010695f:	a3 c4 4b 11 80       	mov    %eax,0x80114bc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106964:	05 00 00 00 80       	add    $0x80000000,%eax
80106969:	0f 22 d8             	mov    %eax,%cr3
}
8010696c:	c9                   	leave
8010696d:	c3                   	ret
8010696e:	66 90                	xchg   %ax,%ax

80106970 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	83 ec 08             	sub    $0x8,%esp
  pde = &pgdir[PDX(va)];
80106976:	8b 55 0c             	mov    0xc(%ebp),%edx
80106979:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010697c:	8b 45 08             	mov    0x8(%ebp),%eax
8010697f:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106982:	a8 01                	test   $0x1,%al
80106984:	75 0e                	jne    80106994 <clearpteu+0x24>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106986:	83 ec 0c             	sub    $0xc,%esp
80106989:	68 24 71 10 80       	push   $0x80107124
8010698e:	e8 a5 99 ff ff       	call   80100338 <panic>
80106993:	90                   	nop
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106994:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106999:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
8010699b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010699e:	c1 e8 0a             	shr    $0xa,%eax
801069a1:	25 fc 0f 00 00       	and    $0xffc,%eax
801069a6:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801069ad:	85 c0                	test   %eax,%eax
801069af:	74 d5                	je     80106986 <clearpteu+0x16>
  *pte &= ~PTE_U;
801069b1:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801069b4:	c9                   	leave
801069b5:	c3                   	ret
801069b6:	66 90                	xchg   %ax,%ax

801069b8 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801069b8:	55                   	push   %ebp
801069b9:	89 e5                	mov    %esp,%ebp
801069bb:	57                   	push   %edi
801069bc:	56                   	push   %esi
801069bd:	53                   	push   %ebx
801069be:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801069c1:	e8 1e ff ff ff       	call   801068e4 <setupkvm>
801069c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801069c9:	85 c0                	test   %eax,%eax
801069cb:	0f 84 d5 00 00 00    	je     80106aa6 <copyuvm+0xee>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801069d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801069d4:	85 db                	test   %ebx,%ebx
801069d6:	0f 84 a4 00 00 00    	je     80106a80 <copyuvm+0xc8>
801069dc:	31 ff                	xor    %edi,%edi
801069de:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
801069e0:	89 f8                	mov    %edi,%eax
801069e2:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801069e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801069e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801069eb:	a8 01                	test   $0x1,%al
801069ed:	75 0d                	jne    801069fc <copyuvm+0x44>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801069ef:	83 ec 0c             	sub    $0xc,%esp
801069f2:	68 2e 71 10 80       	push   $0x8010712e
801069f7:	e8 3c 99 ff ff       	call   80100338 <panic>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a01:	89 fa                	mov    %edi,%edx
80106a03:	c1 ea 0a             	shr    $0xa,%edx
80106a06:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a0c:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106a13:	85 c0                	test   %eax,%eax
80106a15:	74 d8                	je     801069ef <copyuvm+0x37>
    if(!(*pte & PTE_P))
80106a17:	8b 18                	mov    (%eax),%ebx
80106a19:	f6 c3 01             	test   $0x1,%bl
80106a1c:	0f 84 8d 00 00 00    	je     80106aaf <copyuvm+0xf7>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106a22:	89 d8                	mov    %ebx,%eax
80106a24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106a2c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
80106a32:	e8 5d b9 ff ff       	call   80102394 <kalloc>
80106a37:	89 c6                	mov    %eax,%esi
80106a39:	85 c0                	test   %eax,%eax
80106a3b:	74 5b                	je     80106a98 <copyuvm+0xe0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106a3d:	50                   	push   %eax
80106a3e:	68 00 10 00 00       	push   $0x1000
80106a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a46:	05 00 00 00 80       	add    $0x80000000,%eax
80106a4b:	50                   	push   %eax
80106a4c:	56                   	push   %esi
80106a4d:	e8 46 da ff ff       	call   80104498 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106a52:	5a                   	pop    %edx
80106a53:	59                   	pop    %ecx
80106a54:	53                   	push   %ebx
80106a55:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a5b:	50                   	push   %eax
80106a5c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a61:	89 fa                	mov    %edi,%edx
80106a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a66:	e8 3d f9 ff ff       	call   801063a8 <mappages>
80106a6b:	83 c4 10             	add    $0x10,%esp
80106a6e:	40                   	inc    %eax
80106a6f:	74 1b                	je     80106a8c <copyuvm+0xd4>
  for(i = 0; i < sz; i += PGSIZE){
80106a71:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106a77:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a7a:	0f 82 60 ff ff ff    	jb     801069e0 <copyuvm+0x28>
  return d;

bad:
  freevm(d);
  return 0;
}
80106a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a86:	5b                   	pop    %ebx
80106a87:	5e                   	pop    %esi
80106a88:	5f                   	pop    %edi
80106a89:	5d                   	pop    %ebp
80106a8a:	c3                   	ret
80106a8b:	90                   	nop
      kfree(mem);
80106a8c:	83 ec 0c             	sub    $0xc,%esp
80106a8f:	56                   	push   %esi
80106a90:	e8 6f b7 ff ff       	call   80102204 <kfree>
      goto bad;
80106a95:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80106a98:	83 ec 0c             	sub    $0xc,%esp
80106a9b:	ff 75 e0             	push   -0x20(%ebp)
80106a9e:	e8 d1 fd ff ff       	call   80106874 <freevm>
  return 0;
80106aa3:	83 c4 10             	add    $0x10,%esp
    return 0;
80106aa6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106aad:	eb d1                	jmp    80106a80 <copyuvm+0xc8>
      panic("copyuvm: page not present");
80106aaf:	83 ec 0c             	sub    $0xc,%esp
80106ab2:	68 48 71 10 80       	push   $0x80107148
80106ab7:	e8 7c 98 ff ff       	call   80100338 <panic>

80106abc <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106abc:	55                   	push   %ebp
80106abd:	89 e5                	mov    %esp,%ebp
  pde = &pgdir[PDX(va)];
80106abf:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ac2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac8:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106acb:	a8 01                	test   $0x1,%al
80106acd:	0f 84 e3 00 00 00    	je     80106bb6 <uva2ka.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ad3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ad8:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
80106ada:	8b 45 0c             	mov    0xc(%ebp),%eax
80106add:	c1 e8 0c             	shr    $0xc,%eax
80106ae0:	25 ff 03 00 00       	and    $0x3ff,%eax
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
80106ae5:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106aec:	89 c2                	mov    %eax,%edx
80106aee:	f7 d2                	not    %edx
80106af0:	83 e2 05             	and    $0x5,%edx
80106af3:	75 0f                	jne    80106b04 <uva2ka+0x48>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106af5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106afa:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106aff:	5d                   	pop    %ebp
80106b00:	c3                   	ret
80106b01:	8d 76 00             	lea    0x0(%esi),%esi
80106b04:	31 c0                	xor    %eax,%eax
80106b06:	5d                   	pop    %ebp
80106b07:	c3                   	ret

80106b08 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106b08:	55                   	push   %ebp
80106b09:	89 e5                	mov    %esp,%ebp
80106b0b:	57                   	push   %edi
80106b0c:	56                   	push   %esi
80106b0d:	53                   	push   %ebx
80106b0e:	83 ec 0c             	sub    $0xc,%esp
80106b11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b14:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106b17:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106b1a:	85 db                	test   %ebx,%ebx
80106b1c:	0f 84 8a 00 00 00    	je     80106bac <copyout+0xa4>
80106b22:	89 fe                	mov    %edi,%esi
80106b24:	eb 3d                	jmp    80106b63 <copyout+0x5b>
80106b26:	66 90                	xchg   %ax,%ax
  return (char*)P2V(PTE_ADDR(*pte));
80106b28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80106b2d:	05 00 00 00 80       	add    $0x80000000,%eax
80106b32:	74 6a                	je     80106b9e <copyout+0x96>
      return -1;
    n = PGSIZE - (va - va0);
80106b34:	89 fb                	mov    %edi,%ebx
80106b36:	29 cb                	sub    %ecx,%ebx
    if(n > len)
80106b38:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b3e:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80106b41:	73 03                	jae    80106b46 <copyout+0x3e>
80106b43:	8b 5d 14             	mov    0x14(%ebp),%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106b46:	52                   	push   %edx
80106b47:	53                   	push   %ebx
80106b48:	56                   	push   %esi
80106b49:	29 f9                	sub    %edi,%ecx
80106b4b:	01 c8                	add    %ecx,%eax
80106b4d:	50                   	push   %eax
80106b4e:	e8 45 d9 ff ff       	call   80104498 <memmove>
    len -= n;
    buf += n;
80106b53:	01 de                	add    %ebx,%esi
    va = va0 + PGSIZE;
80106b55:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
80106b5b:	83 c4 10             	add    $0x10,%esp
80106b5e:	29 5d 14             	sub    %ebx,0x14(%ebp)
80106b61:	74 49                	je     80106bac <copyout+0xa4>
    va0 = (uint)PGROUNDDOWN(va);
80106b63:	89 cf                	mov    %ecx,%edi
80106b65:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pde = &pgdir[PDX(va)];
80106b6b:	89 c8                	mov    %ecx,%eax
80106b6d:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b70:	8b 55 08             	mov    0x8(%ebp),%edx
80106b73:	8b 04 82             	mov    (%edx,%eax,4),%eax
80106b76:	a8 01                	test   $0x1,%al
80106b78:	0f 84 3f 00 00 00    	je     80106bbd <copyout.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b83:	89 fb                	mov    %edi,%ebx
80106b85:	c1 eb 0c             	shr    $0xc,%ebx
80106b88:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106b8e:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80106b95:	89 c3                	mov    %eax,%ebx
80106b97:	f7 d3                	not    %ebx
80106b99:	83 e3 05             	and    $0x5,%ebx
80106b9c:	74 8a                	je     80106b28 <copyout+0x20>
      return -1;
80106b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ba6:	5b                   	pop    %ebx
80106ba7:	5e                   	pop    %esi
80106ba8:	5f                   	pop    %edi
80106ba9:	5d                   	pop    %ebp
80106baa:	c3                   	ret
80106bab:	90                   	nop
  return 0;
80106bac:	31 c0                	xor    %eax,%eax
}
80106bae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb1:	5b                   	pop    %ebx
80106bb2:	5e                   	pop    %esi
80106bb3:	5f                   	pop    %edi
80106bb4:	5d                   	pop    %ebp
80106bb5:	c3                   	ret

80106bb6 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106bb6:	a1 00 00 00 00       	mov    0x0,%eax
80106bbb:	0f 0b                	ud2

80106bbd <copyout.cold>:
80106bbd:	a1 00 00 00 00       	mov    0x0,%eax
80106bc2:	0f 0b                	ud2
