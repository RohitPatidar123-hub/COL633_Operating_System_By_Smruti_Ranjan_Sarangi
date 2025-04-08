
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
8010003b:	68 e0 6a 10 80       	push   $0x80106ae0
80100040:	68 20 a5 10 80       	push   $0x8010a520
80100045:	e8 62 40 00 00       	call   801040ac <initlock>

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
8010007f:	68 e7 6a 10 80       	push   $0x80106ae7
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 13 3f 00 00       	call   80103fa0 <initsleeplock>
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
801000c8:	e8 a7 41 00 00       	call   80104274 <acquire>
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
8010013e:	e8 d1 40 00 00       	call   80104214 <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 86 3e 00 00       	call   80103fd4 <acquiresleep>
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
80100179:	68 ee 6a 10 80       	push   $0x80106aee
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
80100192:	e8 cd 3e 00 00       	call   80104064 <holdingsleep>
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
801001b0:	68 ff 6a 10 80       	push   $0x80106aff
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
801001cb:	e8 94 3e 00 00       	call   80104064 <holdingsleep>
801001d0:	83 c4 10             	add    $0x10,%esp
801001d3:	85 c0                	test   %eax,%eax
801001d5:	74 61                	je     80100238 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	56                   	push   %esi
801001db:	e8 48 3e 00 00       	call   80104028 <releasesleep>

  acquire(&bcache.lock);
801001e0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001e7:	e8 88 40 00 00       	call   80104274 <acquire>
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
80100233:	e9 dc 3f 00 00       	jmp    80104214 <release>
    panic("brelse");
80100238:	83 ec 0c             	sub    $0xc,%esp
8010023b:	68 06 6b 10 80       	push   $0x80106b06
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
80100266:	e8 09 40 00 00       	call   80104274 <acquire>
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
80100295:	e8 fa 38 00 00       	call   80103b94 <sleep>
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
801002be:	e8 51 3f 00 00       	call   80104214 <release>
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
80100311:	e8 fe 3e 00 00       	call   80104214 <release>
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
80100353:	68 0d 6b 10 80       	push   $0x80106b0d
80100358:	e8 c3 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
8010035d:	58                   	pop    %eax
8010035e:	ff 75 08             	push   0x8(%ebp)
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
80100366:	c7 04 24 eb 6f 10 80 	movl   $0x80106feb,(%esp)
8010036d:	e8 ae 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
80100372:	5a                   	pop    %edx
80100373:	59                   	pop    %ecx
80100374:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100377:	53                   	push   %ebx
80100378:	8d 45 08             	lea    0x8(%ebp),%eax
8010037b:	50                   	push   %eax
8010037c:	e8 47 3d 00 00       	call   801040c8 <getcallerpcs>
  for(i=0; i<10; i++)
80100381:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100384:	83 ec 08             	sub    $0x8,%esp
80100387:	ff 33                	push   (%ebx)
80100389:	68 21 6b 10 80       	push   $0x80106b21
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
801003c6:	e8 75 53 00 00       	call   80105740 <uartputc>
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
80100475:	e8 c6 52 00 00       	call   80105740 <uartputc>
8010047a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100481:	e8 ba 52 00 00       	call   80105740 <uartputc>
80100486:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010048d:	e8 ae 52 00 00       	call   80105740 <uartputc>
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
801004d4:	e8 e3 3e 00 00       	call   801043bc <memmove>
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
801004f9:	e8 42 3e 00 00       	call   80104340 <memset>
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
80100521:	68 25 6b 10 80       	push   $0x80106b25
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
80100547:	e8 28 3d 00 00       	call   80104274 <acquire>
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
8010057d:	e8 92 3c 00 00       	call   80104214 <release>
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
801005c3:	8a 92 3c 70 10 80    	mov    -0x7fef8fc4(%edx),%dl
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
80100738:	e8 37 3b 00 00       	call   80104274 <acquire>
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
8010075b:	e8 b4 3a 00 00       	call   80104214 <release>
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
80100791:	bf 38 6b 10 80       	mov    $0x80106b38,%edi
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
801007de:	68 3f 6b 10 80       	push   $0x80106b3f
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
801007f9:	e8 76 3a 00 00       	call   80104274 <acquire>
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
80100831:	e8 de 39 00 00       	call   80104214 <release>
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
80100936:	e8 15 33 00 00       	call   80103c50 <wakeup>
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
801009ac:	e9 73 33 00 00       	jmp    80103d24 <procdump>
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
801009e6:	68 48 6b 10 80       	push   $0x80106b48
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 b7 36 00 00       	call   801040ac <initlock>

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
80100a8e:	e8 69 5d 00 00       	call   801067fc <setupkvm>
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
80100af9:	e8 6a 5b 00 00       	call   80106668 <allocuvm>
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
80100b2f:	e8 70 5a 00 00       	call   801065a4 <loaduvm>
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
80100b6f:	e8 18 5c 00 00       	call   8010678c <freevm>
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
80100bca:	e8 99 5a 00 00       	call   80106668 <allocuvm>
80100bcf:	89 c7                	mov    %eax,%edi
80100bd1:	83 c4 10             	add    $0x10,%esp
80100bd4:	85 c0                	test   %eax,%eax
80100bd6:	74 7e                	je     80100c56 <exec+0x232>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd8:	83 ec 08             	sub    $0x8,%esp
80100bdb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be1:	50                   	push   %eax
80100be2:	56                   	push   %esi
80100be3:	e8 a0 5c 00 00       	call   80106888 <clearpteu>
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
80100c2a:	e8 8d 38 00 00       	call   801044bc <strlen>
80100c2f:	29 c3                	sub    %eax,%ebx
80100c31:	4b                   	dec    %ebx
80100c32:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c35:	5a                   	pop    %edx
80100c36:	ff 34 b7             	push   (%edi,%esi,4)
80100c39:	e8 7e 38 00 00       	call   801044bc <strlen>
80100c3e:	40                   	inc    %eax
80100c3f:	50                   	push   %eax
80100c40:	ff 34 b7             	push   (%edi,%esi,4)
80100c43:	53                   	push   %ebx
80100c44:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c4a:	e8 d1 5d 00 00       	call   80106a20 <copyout>
80100c4f:	83 c4 20             	add    $0x20,%esp
80100c52:	85 c0                	test   %eax,%eax
80100c54:	79 b2                	jns    80100c08 <exec+0x1e4>
    freevm(pgdir);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c5f:	e8 28 5b 00 00       	call   8010678c <freevm>
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
80100cbb:	e8 60 5d 00 00       	call   80106a20 <copyout>
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
80100cf6:	e8 8d 37 00 00       	call   80104488 <safestrcpy>
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
80100d23:	e8 0c 57 00 00       	call   80106434 <switchuvm>
  freevm(oldpgdir);
80100d28:	89 34 24             	mov    %esi,(%esp)
80100d2b:	e8 5c 5a 00 00       	call   8010678c <freevm>
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
80100d72:	68 50 6b 10 80       	push   $0x80106b50
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
80100d8a:	68 5c 6b 10 80       	push   $0x80106b5c
80100d8f:	68 60 ef 10 80       	push   $0x8010ef60
80100d94:	e8 13 33 00 00       	call   801040ac <initlock>
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
80100dac:	e8 c3 34 00 00       	call   80104274 <acquire>
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
80100ddd:	e8 32 34 00 00       	call   80104214 <release>
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
80100df4:	e8 1b 34 00 00       	call   80104214 <release>
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
80100e17:	e8 58 34 00 00       	call   80104274 <acquire>
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
80100e32:	e8 dd 33 00 00       	call   80104214 <release>
  return f;
}
80100e37:	89 d8                	mov    %ebx,%eax
80100e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3c:	c9                   	leave
80100e3d:	c3                   	ret
    panic("filedup");
80100e3e:	83 ec 0c             	sub    $0xc,%esp
80100e41:	68 63 6b 10 80       	push   $0x80106b63
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
80100e5d:	e8 12 34 00 00       	call   80104274 <acquire>
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
80100e95:	e8 7a 33 00 00       	call   80104214 <release>

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
80100ebe:	e9 51 33 00 00       	jmp    80104214 <release>
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
80100f00:	68 6b 6b 10 80       	push   $0x80106b6b
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
80100fd2:	68 75 6b 10 80       	push   $0x80106b75
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
801010a5:	68 7e 6b 10 80       	push   $0x80106b7e
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
801010d9:	68 84 6b 10 80       	push   $0x80106b84
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
8010117c:	68 8e 6b 10 80       	push   $0x80106b8e
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
801011bb:	e8 80 31 00 00       	call   80104340 <memset>
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
801011ef:	e8 80 30 00 00       	call   80104274 <acquire>
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
80101257:	e8 b8 2f 00 00       	call   80104214 <release>

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
8010127d:	e8 92 2f 00 00       	call   80104214 <release>
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
801012b2:	68 a4 6b 10 80       	push   $0x80106ba4
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
80101323:	68 b4 6b 10 80       	push   $0x80106bb4
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
801013dd:	68 c7 6b 10 80       	push   $0x80106bc7
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
80101409:	e8 ae 2f 00 00       	call   801043bc <memmove>
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
80101427:	68 da 6b 10 80       	push   $0x80106bda
8010142c:	68 60 f9 10 80       	push   $0x8010f960
80101431:	e8 76 2c 00 00       	call   801040ac <initlock>
  for(i = 0; i < NINODE; i++) {
80101436:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
8010143b:	83 c4 10             	add    $0x10,%esp
8010143e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101440:	83 ec 08             	sub    $0x8,%esp
80101443:	68 e1 6b 10 80       	push   $0x80106be1
80101448:	53                   	push   %ebx
80101449:	e8 52 2b 00 00       	call   80103fa0 <initsleeplock>
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
8010147c:	e8 3b 2f 00 00       	call   801043bc <memmove>
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
801014b3:	68 50 70 10 80       	push   $0x80107050
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
8010153a:	e8 01 2e 00 00       	call   80104340 <memset>
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
8010156e:	68 e7 6b 10 80       	push   $0x80106be7
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
801015d6:	e8 e1 2d 00 00       	call   801043bc <memmove>
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
80101603:	e8 6c 2c 00 00       	call   80104274 <acquire>
  ip->ref++;
80101608:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
8010160b:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101612:	e8 fd 2b 00 00       	call   80104214 <release>
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
80101642:	e8 8d 29 00 00       	call   80103fd4 <acquiresleep>
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
801016ae:	e8 09 2d 00 00       	call   801043bc <memmove>
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
801016cf:	68 ff 6b 10 80       	push   $0x80106bff
801016d4:	e8 5f ec ff ff       	call   80100338 <panic>
    panic("ilock");
801016d9:	83 ec 0c             	sub    $0xc,%esp
801016dc:	68 f9 6b 10 80       	push   $0x80106bf9
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
801016fb:	e8 64 29 00 00       	call   80104064 <holdingsleep>
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
80101717:	e9 0c 29 00 00       	jmp    80104028 <releasesleep>
    panic("iunlock");
8010171c:	83 ec 0c             	sub    $0xc,%esp
8010171f:	68 0e 6c 10 80       	push   $0x80106c0e
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
8010173c:	e8 93 28 00 00       	call   80103fd4 <acquiresleep>
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
80101756:	e8 cd 28 00 00       	call   80104028 <releasesleep>
  acquire(&icache.lock);
8010175b:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101762:	e8 0d 2b 00 00       	call   80104274 <acquire>
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
8010177b:	e9 94 2a 00 00       	jmp    80104214 <release>
    acquire(&icache.lock);
80101780:	83 ec 0c             	sub    $0xc,%esp
80101783:	68 60 f9 10 80       	push   $0x8010f960
80101788:	e8 e7 2a 00 00       	call   80104274 <acquire>
    int r = ip->ref;
8010178d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101790:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101797:	e8 78 2a 00 00       	call   80104214 <release>
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
80101887:	e8 d8 27 00 00       	call   80104064 <holdingsleep>
8010188c:	83 c4 10             	add    $0x10,%esp
8010188f:	85 c0                	test   %eax,%eax
80101891:	74 21                	je     801018b4 <iunlockput+0x40>
80101893:	8b 43 08             	mov    0x8(%ebx),%eax
80101896:	85 c0                	test   %eax,%eax
80101898:	7e 1a                	jle    801018b4 <iunlockput+0x40>
  releasesleep(&ip->lock);
8010189a:	83 ec 0c             	sub    $0xc,%esp
8010189d:	56                   	push   %esi
8010189e:	e8 85 27 00 00       	call   80104028 <releasesleep>
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
801018b7:	68 0e 6c 10 80       	push   $0x80106c0e
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
8010198d:	e8 2a 2a 00 00       	call   801043bc <memmove>
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
80101a91:	e8 26 29 00 00       	call   801043bc <memmove>
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
80101b1a:	e8 e9 28 00 00       	call   80104408 <strncmp>
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
80101b67:	e8 9c 28 00 00       	call   80104408 <strncmp>
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
80101baa:	68 28 6c 10 80       	push   $0x80106c28
80101baf:	e8 84 e7 ff ff       	call   80100338 <panic>
    panic("dirlookup not DIR");
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	68 16 6c 10 80       	push   $0x80106c16
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
80101bf1:	e8 7e 26 00 00       	call   80104274 <acquire>
  ip->ref++;
80101bf6:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101bf9:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101c00:	e8 0f 26 00 00       	call   80104214 <release>
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
80101c47:	e8 70 27 00 00       	call   801043bc <memmove>
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
80101ca4:	e8 bb 23 00 00       	call   80104064 <holdingsleep>
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
80101cc6:	e8 5d 23 00 00       	call   80104028 <releasesleep>
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
80101cef:	e8 c8 26 00 00       	call   801043bc <memmove>
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
80101d20:	e8 3f 23 00 00       	call   80104064 <holdingsleep>
80101d25:	83 c4 10             	add    $0x10,%esp
80101d28:	85 c0                	test   %eax,%eax
80101d2a:	0f 84 84 00 00 00    	je     80101db4 <namex+0x1f0>
80101d30:	8b 46 08             	mov    0x8(%esi),%eax
80101d33:	85 c0                	test   %eax,%eax
80101d35:	7e 7d                	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101d37:	83 ec 0c             	sub    $0xc,%esp
80101d3a:	53                   	push   %ebx
80101d3b:	e8 e8 22 00 00       	call   80104028 <releasesleep>
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
80101d7b:	e8 e4 22 00 00       	call   80104064 <holdingsleep>
80101d80:	83 c4 10             	add    $0x10,%esp
80101d83:	85 c0                	test   %eax,%eax
80101d85:	74 2d                	je     80101db4 <namex+0x1f0>
80101d87:	8b 46 08             	mov    0x8(%esi),%eax
80101d8a:	85 c0                	test   %eax,%eax
80101d8c:	7e 26                	jle    80101db4 <namex+0x1f0>
  releasesleep(&ip->lock);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	53                   	push   %ebx
80101d92:	e8 91 22 00 00       	call   80104028 <releasesleep>
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
80101db7:	68 0e 6c 10 80       	push   $0x80106c0e
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
80101e1f:	e8 1c 26 00 00       	call   80104440 <strncpy>
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
80101e5d:	68 37 6c 10 80       	push   $0x80106c37
80101e62:	e8 d1 e4 ff ff       	call   80100338 <panic>
    panic("dirlink");
80101e67:	83 ec 0c             	sub    $0xc,%esp
80101e6a:	68 ef 6e 10 80       	push   $0x80106eef
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
80101f40:	68 4d 6c 10 80       	push   $0x80106c4d
80101f45:	e8 ee e3 ff ff       	call   80100338 <panic>
    panic("idestart");
80101f4a:	83 ec 0c             	sub    $0xc,%esp
80101f4d:	68 44 6c 10 80       	push   $0x80106c44
80101f52:	e8 e1 e3 ff ff       	call   80100338 <panic>
80101f57:	90                   	nop

80101f58 <ideinit>:
{
80101f58:	55                   	push   %ebp
80101f59:	89 e5                	mov    %esp,%ebp
80101f5b:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101f5e:	68 5f 6c 10 80       	push   $0x80106c5f
80101f63:	68 00 16 11 80       	push   $0x80111600
80101f68:	e8 3f 21 00 00       	call   801040ac <initlock>
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
80101fce:	e8 a1 22 00 00       	call   80104274 <acquire>

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
80102025:	e8 26 1c 00 00       	call   80103c50 <wakeup>

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
80102043:	e8 cc 21 00 00       	call   80104214 <release>

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
8010205e:	e8 01 20 00 00       	call   80104064 <holdingsleep>
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
80102094:	e8 db 21 00 00       	call   80104274 <acquire>

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
801020d5:	e8 ba 1a 00 00       	call   80103b94 <sleep>
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
801020f2:	e9 1d 21 00 00       	jmp    80104214 <release>
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
8010210e:	68 8e 6c 10 80       	push   $0x80106c8e
80102113:	e8 20 e2 ff ff       	call   80100338 <panic>
    panic("iderw: nothing to do");
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	68 79 6c 10 80       	push   $0x80106c79
80102120:	e8 13 e2 ff ff       	call   80100338 <panic>
    panic("iderw: buf not locked");
80102125:	83 ec 0c             	sub    $0xc,%esp
80102128:	68 63 6c 10 80       	push   $0x80106c63
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
8010217e:	68 a4 70 10 80       	push   $0x801070a4
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
80102232:	e8 09 21 00 00       	call   80104340 <memset>

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
80102268:	e8 07 20 00 00       	call   80104274 <acquire>
8010226d:	83 c4 10             	add    $0x10,%esp
80102270:	eb d2                	jmp    80102244 <kfree+0x40>
80102272:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102274:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010227b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010227e:	c9                   	leave
    release(&kmem.lock);
8010227f:	e9 90 1f 00 00       	jmp    80104214 <release>
    panic("kfree");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 ac 6c 10 80       	push   $0x80106cac
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
8010233b:	68 b2 6c 10 80       	push   $0x80106cb2
80102340:	68 40 16 11 80       	push   $0x80111640
80102345:	e8 62 1d 00 00       	call   801040ac <initlock>
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
801023bf:	e8 b0 1e 00 00       	call   80104274 <acquire>
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
801023ed:	e8 22 1e 00 00       	call   80104214 <release>
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
80102437:	0f b6 93 e0 72 10 80 	movzbl -0x7fef8d20(%ebx),%edx
8010243e:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
80102440:	0f b6 83 e0 71 10 80 	movzbl -0x7fef8e20(%ebx),%eax
80102447:	31 c2                	xor    %eax,%edx
80102449:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
8010244f:	89 d0                	mov    %edx,%eax
80102451:	83 e0 03             	and    $0x3,%eax
80102454:	8b 04 85 c0 71 10 80 	mov    -0x7fef8e40(,%eax,4),%eax
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
80102495:	8a 83 e0 72 10 80    	mov    -0x7fef8d20(%ebx),%al
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
80102797:	e8 e8 1b 00 00       	call   80104384 <memcmp>
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
8010289f:	e8 18 1b 00 00       	call   801043bc <memmove>
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
80102936:	68 b7 6c 10 80       	push   $0x80106cb7
8010293b:	68 a0 16 11 80       	push   $0x801116a0
80102940:	e8 67 17 00 00       	call   801040ac <initlock>
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
801029c7:	e8 a8 18 00 00       	call   80104274 <acquire>
801029cc:	83 c4 10             	add    $0x10,%esp
801029cf:	eb 18                	jmp    801029e9 <begin_op+0x2d>
801029d1:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801029d4:	83 ec 08             	sub    $0x8,%esp
801029d7:	68 a0 16 11 80       	push   $0x801116a0
801029dc:	68 a0 16 11 80       	push   $0x801116a0
801029e1:	e8 ae 11 00 00       	call   80103b94 <sleep>
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
80102a19:	e8 f6 17 00 00       	call   80104214 <release>
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
80102a32:	e8 3d 18 00 00       	call   80104274 <acquire>
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
80102a70:	e8 9f 17 00 00       	call   80104214 <release>
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
80102a8a:	e8 e5 17 00 00       	call   80104274 <acquire>
    log.committing = 0;
80102a8f:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102a96:	00 00 00 
    wakeup(&log);
80102a99:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102aa0:	e8 ab 11 00 00       	call   80103c50 <wakeup>
    release(&log.lock);
80102aa5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102aac:	e8 63 17 00 00       	call   80104214 <release>
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
80102afb:	e8 bc 18 00 00       	call   801043bc <memmove>
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
80102b4c:	e8 ff 10 00 00       	call   80103c50 <wakeup>
  release(&log.lock);
80102b51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b58:	e8 b7 16 00 00       	call   80104214 <release>
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
80102b6b:	68 bb 6c 10 80       	push   $0x80106cbb
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
80102ba6:	e8 c9 16 00 00       	call   80104274 <acquire>
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
80102be7:	e9 28 16 00 00       	jmp    80104214 <release>
  log.lh.block[i] = b->blockno;
80102bec:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102bf3:	42                   	inc    %edx
80102bf4:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102bfa:	eb dd                	jmp    80102bd9 <log_write+0x61>
    panic("too big a transaction");
80102bfc:	83 ec 0c             	sub    $0xc,%esp
80102bff:	68 ca 6c 10 80       	push   $0x80106cca
80102c04:	e8 2f d7 ff ff       	call   80100338 <panic>
    panic("log_write outside of trans");
80102c09:	83 ec 0c             	sub    $0xc,%esp
80102c0c:	68 e0 6c 10 80       	push   $0x80106ce0
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
80102c2c:	68 fb 6c 10 80       	push   $0x80106cfb
80102c31:	e8 ea d9 ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102c36:	e8 39 27 00 00       	call   80105374 <idtinit>
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
80102c4e:	e8 61 12 00 00       	call   80103eb4 <scheduler>
80102c53:	90                   	nop

80102c54 <mpenter>:
{
80102c54:	55                   	push   %ebp
80102c55:	89 e5                	mov    %esp,%ebp
80102c57:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102c5a:	e8 c5 37 00 00       	call   80106424 <switchkvm>
  seginit();
80102c5f:	e8 3c 37 00 00       	call   801063a0 <seginit>
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
80102c91:	e8 d6 3b 00 00       	call   8010686c <kvmalloc>
  mpinit();        // detect other processors
80102c96:	e8 61 01 00 00       	call   80102dfc <mpinit>
  lapicinit();     // interrupt controller
80102c9b:	e8 38 f8 ff ff       	call   801024d8 <lapicinit>
  seginit();       // segment descriptors
80102ca0:	e8 fb 36 00 00       	call   801063a0 <seginit>
  picinit();       // disable pic
80102ca5:	e8 12 03 00 00       	call   80102fbc <picinit>
  ioapicinit();    // another interrupt controller
80102caa:	e8 85 f4 ff ff       	call   80102134 <ioapicinit>
  consoleinit();   // console hardware
80102caf:	e8 2c dd ff ff       	call   801009e0 <consoleinit>
  uartinit();      // serial port
80102cb4:	e8 c3 29 00 00       	call   8010567c <uartinit>
  pinit();         // process table
80102cb9:	e8 86 07 00 00       	call   80103444 <pinit>
  tvinit();        // trap vectors
80102cbe:	e8 45 26 00 00       	call   80105308 <tvinit>
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
80102ce4:	e8 d3 16 00 00       	call   801043bc <memmove>

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
80102dc0:	68 0f 6d 10 80       	push   $0x80106d0f
80102dc5:	56                   	push   %esi
80102dc6:	e8 b9 15 00 00       	call   80104384 <memcmp>
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
80102e6f:	68 2c 6d 10 80       	push   $0x80106d2c
80102e74:	50                   	push   %eax
80102e75:	e8 0a 15 00 00       	call   80104384 <memcmp>
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
80102f03:	68 14 6d 10 80       	push   $0x80106d14
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
80102f8c:	68 0f 6d 10 80       	push   $0x80106d0f
80102f91:	53                   	push   %ebx
80102f92:	e8 ed 13 00 00       	call   80104384 <memcmp>
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
8010303f:	68 31 6d 10 80       	push   $0x80106d31
80103044:	50                   	push   %eax
80103045:	e8 62 10 00 00       	call   801040ac <initlock>
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
801030cb:	e8 a4 11 00 00       	call   80104274 <acquire>
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
801030eb:	e8 60 0b 00 00       	call   80103c50 <wakeup>
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
80103110:	e9 ff 10 00 00       	jmp    80104214 <release>
80103115:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
80103118:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
8010311f:	00 00 00 
    wakeup(&p->nwrite);
80103122:	83 ec 0c             	sub    $0xc,%esp
80103125:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010312b:	50                   	push   %eax
8010312c:	e8 1f 0b 00 00       	call   80103c50 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
80103134:	eb bd                	jmp    801030f3 <pipeclose+0x37>
80103136:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103138:	83 ec 0c             	sub    $0xc,%esp
8010313b:	53                   	push   %ebx
8010313c:	e8 d3 10 00 00       	call   80104214 <release>
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
80103164:	e8 0b 11 00 00       	call   80104274 <acquire>
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
801031c0:	e8 8b 0a 00 00       	call   80103c50 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801031c5:	58                   	pop    %eax
801031c6:	5a                   	pop    %edx
801031c7:	53                   	push   %ebx
801031c8:	57                   	push   %edi
801031c9:	e8 c6 09 00 00       	call   80103b94 <sleep>
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
801031f4:	e8 1b 10 00 00       	call   80104214 <release>
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
80103240:	e8 0b 0a 00 00       	call   80103c50 <wakeup>
  release(&p->lock);
80103245:	89 1c 24             	mov    %ebx,(%esp)
80103248:	e8 c7 0f 00 00       	call   80104214 <release>
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
8010326c:	e8 03 10 00 00       	call   80104274 <acquire>
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
801032a1:	e8 ee 08 00 00       	call   80103b94 <sleep>
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
801032ff:	e8 4c 09 00 00       	call   80103c50 <wakeup>
  release(&p->lock);
80103304:	89 34 24             	mov    %esi,(%esp)
80103307:	e8 08 0f 00 00       	call   80104214 <release>
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
80103320:	e8 ef 0e 00 00       	call   80104214 <release>
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
80103344:	e8 2b 0f 00 00       	call   80104274 <acquire>
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
80103389:	e8 86 0e 00 00       	call   80104214 <release>

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
801033a6:	c7 80 b0 0f 00 00 fa 	movl   $0x801052fa,0xfb0(%eax)
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
801033be:	e8 7d 0f 00 00       	call   80104340 <memset>
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
801033e0:	e8 2f 0e 00 00       	call   80104214 <release>
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
80103407:	e8 08 0e 00 00       	call   80104214 <release>

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
8010344a:	68 36 6d 10 80       	push   $0x80106d36
8010344f:	68 40 1d 11 80       	push   $0x80111d40
80103454:	e8 53 0c 00 00       	call   801040ac <initlock>
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
801034ad:	68 3d 6d 10 80       	push   $0x80106d3d
801034b2:	e8 81 ce ff ff       	call   80100338 <panic>
    panic("mycpu called with interrupts enabled\n");
801034b7:	83 ec 0c             	sub    $0xc,%esp
801034ba:	68 d8 70 10 80       	push   $0x801070d8
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
801034fd:	e8 2e 0c 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103502:	e8 59 ff ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103507:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010350d:	e8 6a 0c 00 00       	call   8010417c <popcli>
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
8010352d:	e8 ca 32 00 00       	call   801067fc <setupkvm>
80103532:	89 43 2c             	mov    %eax,0x2c(%ebx)
80103535:	85 c0                	test   %eax,%eax
80103537:	0f 84 ba 00 00 00    	je     801035f7 <userinit+0xdb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010353d:	52                   	push   %edx
8010353e:	68 2c 00 00 00       	push   $0x2c
80103543:	68 60 a4 10 80       	push   $0x8010a460
80103548:	50                   	push   %eax
80103549:	e8 e2 2f 00 00       	call   80106530 <inituvm>
  p->sz = PGSIZE;
8010354e:	c7 43 28 00 10 00 00 	movl   $0x1000,0x28(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103555:	83 c4 0c             	add    $0xc,%esp
80103558:	6a 4c                	push   $0x4c
8010355a:	6a 00                	push   $0x0
8010355c:	ff 73 40             	push   0x40(%ebx)
8010355f:	e8 dc 0d 00 00       	call   80104340 <memset>
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
801035ad:	68 66 6d 10 80       	push   $0x80106d66
801035b2:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax
801035b8:	50                   	push   %eax
801035b9:	e8 ca 0e 00 00       	call   80104488 <safestrcpy>
  p->cwd = namei("/");
801035be:	c7 04 24 6f 6d 10 80 	movl   $0x80106d6f,(%esp)
801035c5:	e8 aa e8 ff ff       	call   80101e74 <namei>
801035ca:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  acquire(&ptable.lock);
801035d0:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801035d7:	e8 98 0c 00 00       	call   80104274 <acquire>
  p->state = RUNNABLE;
801035dc:	c7 43 34 04 00 00 00 	movl   $0x4,0x34(%ebx)
  release(&ptable.lock);
801035e3:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801035ea:	e8 25 0c 00 00       	call   80104214 <release>
}
801035ef:	83 c4 10             	add    $0x10,%esp
801035f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035f5:	c9                   	leave
801035f6:	c3                   	ret
    panic("userinit: out of memory?");
801035f7:	83 ec 0c             	sub    $0xc,%esp
801035fa:	68 4d 6d 10 80       	push   $0x80106d4d
801035ff:	e8 34 cd ff ff       	call   80100338 <panic>

80103604 <growproc>:
{
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	56                   	push   %esi
80103608:	53                   	push   %ebx
80103609:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010360c:	e8 1f 0b 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103611:	e8 4a fe ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103616:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010361c:	e8 5b 0b 00 00       	call   8010417c <popcli>
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
80103631:	e8 fe 2d 00 00       	call   80106434 <switchuvm>
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
8010364c:	e8 17 30 00 00       	call   80106668 <allocuvm>
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
80103668:	e8 03 31 00 00       	call   80106770 <deallocuvm>
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
80103681:	e8 aa 0a 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103686:	e8 d5 fd ff ff       	call   80103460 <mycpu>
  p = c->proc;
8010368b:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103691:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103694:	e8 e3 0a 00 00       	call   8010417c <popcli>
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
801036d8:	e8 f3 31 00 00       	call   801068d0 <copyuvm>
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
80103761:	e8 22 0d 00 00       	call   80104488 <safestrcpy>
  pid = np->pid;
80103766:	8b 73 38             	mov    0x38(%ebx),%esi
  acquire(&ptable.lock);
80103769:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103770:	e8 ff 0a 00 00       	call   80104274 <acquire>
  np->state = RUNNABLE;
80103775:	c7 43 34 04 00 00 00 	movl   $0x4,0x34(%ebx)
  release(&ptable.lock);
8010377c:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103783:	e8 8c 0a 00 00       	call   80104214 <release>
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
801037bd:	e8 6e 09 00 00       	call   80104130 <pushcli>
  c = mycpu();
801037c2:	e8 99 fc ff ff       	call   80103460 <mycpu>
  p = c->proc;
801037c7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037cd:	e8 aa 09 00 00       	call   8010417c <popcli>
  if(!holding(&ptable.lock))
801037d2:	83 ec 0c             	sub    $0xc,%esp
801037d5:	68 40 1d 11 80       	push   $0x80111d40
801037da:	e8 f5 09 00 00       	call   801041d4 <holding>
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
8010381b:	e8 b5 0c 00 00       	call   801044d5 <swtch>
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
80103838:	68 71 6d 10 80       	push   $0x80106d71
8010383d:	e8 f6 ca ff ff       	call   80100338 <panic>
    panic("sched interruptible");
80103842:	83 ec 0c             	sub    $0xc,%esp
80103845:	68 9d 6d 10 80       	push   $0x80106d9d
8010384a:	e8 e9 ca ff ff       	call   80100338 <panic>
    panic("sched running");
8010384f:	83 ec 0c             	sub    $0xc,%esp
80103852:	68 8f 6d 10 80       	push   $0x80106d8f
80103857:	e8 dc ca ff ff       	call   80100338 <panic>
    panic("sched locks");
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	68 83 6d 10 80       	push   $0x80106d83
80103864:	e8 cf ca ff ff       	call   80100338 <panic>
80103869:	8d 76 00             	lea    0x0(%esi),%esi

8010386c <exit>:
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	57                   	push   %edi
80103870:	56                   	push   %esi
80103871:	53                   	push   %ebx
80103872:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103875:	e8 7e fc ff ff       	call   801034f8 <myproc>
  if(curproc == initproc)
8010387a:	39 05 20 1d 11 80    	cmp    %eax,0x80111d20
80103880:	0f 84 8f 01 00 00    	je     80103a15 <exit+0x1a9>
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
801038dc:	e8 93 09 00 00       	call   80104274 <acquire>
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
8010396c:	8b 35 74 46 11 80    	mov    0x80114674,%esi
80103972:	89 73 10             	mov    %esi,0x10(%ebx)
int tat = curproc->end_time - curproc->creation_time;
80103975:	8b 53 0c             	mov    0xc(%ebx),%edx
80103978:	89 f0                	mov    %esi,%eax
8010397a:	29 d0                	sub    %edx,%eax
8010397c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
int wt = curproc->total_wait_time;
8010397f:	8b 4b 1c             	mov    0x1c(%ebx),%ecx
80103982:	89 4d d8             	mov    %ecx,-0x28(%ebp)
int rt = curproc->first_run_time - curproc->creation_time;
80103985:	8b 7b 14             	mov    0x14(%ebx),%edi
80103988:	89 f9                	mov    %edi,%ecx
8010398a:	29 d1                	sub    %edx,%ecx
8010398c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
int cs = curproc->context_switches;
8010398f:	8b 53 20             	mov    0x20(%ebx),%edx
80103992:	89 55 dc             	mov    %edx,-0x24(%ebp)
cprintf("PID: %d\n", curproc->pid);
80103995:	83 ec 08             	sub    $0x8,%esp
80103998:	ff 73 38             	push   0x38(%ebx)
8010399b:	68 be 6d 10 80       	push   $0x80106dbe
801039a0:	e8 7b cc ff ff       	call   80100620 <cprintf>
cprintf("TAT: %d\n", tat);
801039a5:	58                   	pop    %eax
801039a6:	5a                   	pop    %edx
801039a7:	ff 75 e4             	push   -0x1c(%ebp)
801039aa:	68 c7 6d 10 80       	push   $0x80106dc7
801039af:	e8 6c cc ff ff       	call   80100620 <cprintf>
cprintf("WT: %d\n", wt);
801039b4:	59                   	pop    %ecx
801039b5:	58                   	pop    %eax
801039b6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801039b9:	51                   	push   %ecx
801039ba:	68 d0 6d 10 80       	push   $0x80106dd0
801039bf:	e8 5c cc ff ff       	call   80100620 <cprintf>
cprintf("RT: %d\n", rt);
801039c4:	58                   	pop    %eax
801039c5:	5a                   	pop    %edx
801039c6:	ff 75 e0             	push   -0x20(%ebp)
801039c9:	68 d8 6d 10 80       	push   $0x80106dd8
801039ce:	e8 4d cc ff ff       	call   80100620 <cprintf>
cprintf("#CS: %d\n", cs);
801039d3:	59                   	pop    %ecx
801039d4:	58                   	pop    %eax
801039d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801039d8:	52                   	push   %edx
801039d9:	68 e0 6d 10 80       	push   $0x80106de0
801039de:	e8 3d cc ff ff       	call   80100620 <cprintf>
cprintf("First Run Time: %d\n", first_run);
801039e3:	58                   	pop    %eax
801039e4:	5a                   	pop    %edx
801039e5:	57                   	push   %edi
801039e6:	68 e9 6d 10 80       	push   $0x80106de9
801039eb:	e8 30 cc ff ff       	call   80100620 <cprintf>
cprintf("End Time: %d\n", end_time);
801039f0:	59                   	pop    %ecx
801039f1:	5f                   	pop    %edi
801039f2:	56                   	push   %esi
801039f3:	68 fd 6d 10 80       	push   $0x80106dfd
801039f8:	e8 23 cc ff ff       	call   80100620 <cprintf>
  curproc->state = ZOMBIE;
801039fd:	c7 43 34 06 00 00 00 	movl   $0x6,0x34(%ebx)
  sched();
80103a04:	e8 af fd ff ff       	call   801037b8 <sched>
  panic("zombie exit");
80103a09:	c7 04 24 0b 6e 10 80 	movl   $0x80106e0b,(%esp)
80103a10:	e8 23 c9 ff ff       	call   80100338 <panic>
    panic("init exiting");
80103a15:	83 ec 0c             	sub    $0xc,%esp
80103a18:	68 b1 6d 10 80       	push   $0x80106db1
80103a1d:	e8 16 c9 ff ff       	call   80100338 <panic>
80103a22:	66 90                	xchg   %ax,%ax

80103a24 <wait>:
{
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	56                   	push   %esi
80103a28:	53                   	push   %ebx
  pushcli();
80103a29:	e8 02 07 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103a2e:	e8 2d fa ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103a33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103a39:	e8 3e 07 00 00       	call   8010417c <popcli>
  acquire(&ptable.lock);
80103a3e:	83 ec 0c             	sub    $0xc,%esp
80103a41:	68 40 1d 11 80       	push   $0x80111d40
80103a46:	e8 29 08 00 00       	call   80104274 <acquire>
80103a4b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103a4e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a50:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
80103a55:	eb 0f                	jmp    80103a66 <wait+0x42>
80103a57:	90                   	nop
80103a58:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80103a5e:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
80103a64:	74 1e                	je     80103a84 <wait+0x60>
      if(p->parent != curproc)
80103a66:	39 73 3c             	cmp    %esi,0x3c(%ebx)
80103a69:	75 ed                	jne    80103a58 <wait+0x34>
      if(p->state == ZOMBIE){
80103a6b:	83 7b 34 06          	cmpl   $0x6,0x34(%ebx)
80103a6f:	74 5b                	je     80103acc <wait+0xa8>
      havekids = 1;
80103a71:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a76:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80103a7c:	81 fb 74 46 11 80    	cmp    $0x80114674,%ebx
80103a82:	75 e2                	jne    80103a66 <wait+0x42>
    if(!havekids || curproc->killed){
80103a84:	85 c0                	test   %eax,%eax
80103a86:	0f 84 99 00 00 00    	je     80103b25 <wait+0x101>
80103a8c:	8b 46 4c             	mov    0x4c(%esi),%eax
80103a8f:	85 c0                	test   %eax,%eax
80103a91:	0f 85 8e 00 00 00    	jne    80103b25 <wait+0x101>
  pushcli();
80103a97:	e8 94 06 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103a9c:	e8 bf f9 ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103aa1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa7:	e8 d0 06 00 00       	call   8010417c <popcli>
  if(p == 0)
80103aac:	85 db                	test   %ebx,%ebx
80103aae:	0f 84 88 00 00 00    	je     80103b3c <wait+0x118>
  p->chan = chan;
80103ab4:	89 73 48             	mov    %esi,0x48(%ebx)
  p->state = SLEEPING;
80103ab7:	c7 43 34 02 00 00 00 	movl   $0x2,0x34(%ebx)
  sched();
80103abe:	e8 f5 fc ff ff       	call   801037b8 <sched>
  p->chan = 0;
80103ac3:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
}
80103aca:	eb 82                	jmp    80103a4e <wait+0x2a>
        pid = p->pid;
80103acc:	8b 73 38             	mov    0x38(%ebx),%esi
        kfree(p->kstack);
80103acf:	83 ec 0c             	sub    $0xc,%esp
80103ad2:	ff 73 30             	push   0x30(%ebx)
80103ad5:	e8 2a e7 ff ff       	call   80102204 <kfree>
        p->kstack = 0;
80103ada:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        freevm(p->pgdir);
80103ae1:	5a                   	pop    %edx
80103ae2:	ff 73 2c             	push   0x2c(%ebx)
80103ae5:	e8 a2 2c 00 00       	call   8010678c <freevm>
        p->pid = 0;
80103aea:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
        p->parent = 0;
80103af1:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
        p->name[0] = 0;
80103af8:	c6 83 94 00 00 00 00 	movb   $0x0,0x94(%ebx)
        p->killed = 0;
80103aff:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
        p->state = UNUSED;
80103b06:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
        release(&ptable.lock);
80103b0d:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103b14:	e8 fb 06 00 00       	call   80104214 <release>
        return pid;
80103b19:	83 c4 10             	add    $0x10,%esp
}
80103b1c:	89 f0                	mov    %esi,%eax
80103b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b21:	5b                   	pop    %ebx
80103b22:	5e                   	pop    %esi
80103b23:	5d                   	pop    %ebp
80103b24:	c3                   	ret
      release(&ptable.lock);
80103b25:	83 ec 0c             	sub    $0xc,%esp
80103b28:	68 40 1d 11 80       	push   $0x80111d40
80103b2d:	e8 e2 06 00 00       	call   80104214 <release>
      return -1;
80103b32:	83 c4 10             	add    $0x10,%esp
80103b35:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103b3a:	eb e0                	jmp    80103b1c <wait+0xf8>
    panic("sleep");
80103b3c:	83 ec 0c             	sub    $0xc,%esp
80103b3f:	68 17 6e 10 80       	push   $0x80106e17
80103b44:	e8 ef c7 ff ff       	call   80100338 <panic>
80103b49:	8d 76 00             	lea    0x0(%esi),%esi

80103b4c <yield>:
{
80103b4c:	55                   	push   %ebp
80103b4d:	89 e5                	mov    %esp,%ebp
80103b4f:	53                   	push   %ebx
80103b50:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103b53:	68 40 1d 11 80       	push   $0x80111d40
80103b58:	e8 17 07 00 00       	call   80104274 <acquire>
  pushcli();
80103b5d:	e8 ce 05 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103b62:	e8 f9 f8 ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103b67:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b6d:	e8 0a 06 00 00       	call   8010417c <popcli>
  myproc()->state = RUNNABLE;
80103b72:	c7 43 34 04 00 00 00 	movl   $0x4,0x34(%ebx)
  sched();
80103b79:	e8 3a fc ff ff       	call   801037b8 <sched>
  release(&ptable.lock);
80103b7e:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103b85:	e8 8a 06 00 00       	call   80104214 <release>
}
80103b8a:	83 c4 10             	add    $0x10,%esp
80103b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b90:	c9                   	leave
80103b91:	c3                   	ret
80103b92:	66 90                	xchg   %ax,%ax

80103b94 <sleep>:
{
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	57                   	push   %edi
80103b98:	56                   	push   %esi
80103b99:	53                   	push   %ebx
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ba0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103ba3:	e8 88 05 00 00       	call   80104130 <pushcli>
  c = mycpu();
80103ba8:	e8 b3 f8 ff ff       	call   80103460 <mycpu>
  p = c->proc;
80103bad:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb3:	e8 c4 05 00 00       	call   8010417c <popcli>
  if(p == 0)
80103bb8:	85 db                	test   %ebx,%ebx
80103bba:	0f 84 83 00 00 00    	je     80103c43 <sleep+0xaf>
  if(lk == 0)
80103bc0:	85 f6                	test   %esi,%esi
80103bc2:	74 72                	je     80103c36 <sleep+0xa2>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103bc4:	81 fe 40 1d 11 80    	cmp    $0x80111d40,%esi
80103bca:	74 4c                	je     80103c18 <sleep+0x84>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103bcc:	83 ec 0c             	sub    $0xc,%esp
80103bcf:	68 40 1d 11 80       	push   $0x80111d40
80103bd4:	e8 9b 06 00 00       	call   80104274 <acquire>
    release(lk);
80103bd9:	89 34 24             	mov    %esi,(%esp)
80103bdc:	e8 33 06 00 00       	call   80104214 <release>
  p->chan = chan;
80103be1:	89 7b 48             	mov    %edi,0x48(%ebx)
  p->state = SLEEPING;
80103be4:	c7 43 34 02 00 00 00 	movl   $0x2,0x34(%ebx)
  sched();
80103beb:	e8 c8 fb ff ff       	call   801037b8 <sched>
  p->chan = 0;
80103bf0:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
    release(&ptable.lock);
80103bf7:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103bfe:	e8 11 06 00 00       	call   80104214 <release>
    acquire(lk);
80103c03:	83 c4 10             	add    $0x10,%esp
80103c06:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0c:	5b                   	pop    %ebx
80103c0d:	5e                   	pop    %esi
80103c0e:	5f                   	pop    %edi
80103c0f:	5d                   	pop    %ebp
    acquire(lk);
80103c10:	e9 5f 06 00 00       	jmp    80104274 <acquire>
80103c15:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103c18:	89 7b 48             	mov    %edi,0x48(%ebx)
  p->state = SLEEPING;
80103c1b:	c7 43 34 02 00 00 00 	movl   $0x2,0x34(%ebx)
  sched();
80103c22:	e8 91 fb ff ff       	call   801037b8 <sched>
  p->chan = 0;
80103c27:	c7 43 48 00 00 00 00 	movl   $0x0,0x48(%ebx)
}
80103c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c31:	5b                   	pop    %ebx
80103c32:	5e                   	pop    %esi
80103c33:	5f                   	pop    %edi
80103c34:	5d                   	pop    %ebp
80103c35:	c3                   	ret
    panic("sleep without lk");
80103c36:	83 ec 0c             	sub    $0xc,%esp
80103c39:	68 1d 6e 10 80       	push   $0x80106e1d
80103c3e:	e8 f5 c6 ff ff       	call   80100338 <panic>
    panic("sleep");
80103c43:	83 ec 0c             	sub    $0xc,%esp
80103c46:	68 17 6e 10 80       	push   $0x80106e17
80103c4b:	e8 e8 c6 ff ff       	call   80100338 <panic>

80103c50 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	53                   	push   %ebx
80103c54:	83 ec 10             	sub    $0x10,%esp
80103c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103c5a:	68 40 1d 11 80       	push   $0x80111d40
80103c5f:	e8 10 06 00 00       	call   80104274 <acquire>
80103c64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c67:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103c6c:	eb 0e                	jmp    80103c7c <wakeup+0x2c>
80103c6e:	66 90                	xchg   %ax,%ax
80103c70:	05 a4 00 00 00       	add    $0xa4,%eax
80103c75:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103c7a:	74 1e                	je     80103c9a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103c7c:	83 78 34 02          	cmpl   $0x2,0x34(%eax)
80103c80:	75 ee                	jne    80103c70 <wakeup+0x20>
80103c82:	3b 58 48             	cmp    0x48(%eax),%ebx
80103c85:	75 e9                	jne    80103c70 <wakeup+0x20>
      p->state = RUNNABLE;
80103c87:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c8e:	05 a4 00 00 00       	add    $0xa4,%eax
80103c93:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103c98:	75 e2                	jne    80103c7c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103c9a:	c7 45 08 40 1d 11 80 	movl   $0x80111d40,0x8(%ebp)
}
80103ca1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ca4:	c9                   	leave
  release(&ptable.lock);
80103ca5:	e9 6a 05 00 00       	jmp    80104214 <release>
80103caa:	66 90                	xchg   %ax,%ax

80103cac <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103cac:	55                   	push   %ebp
80103cad:	89 e5                	mov    %esp,%ebp
80103caf:	53                   	push   %ebx
80103cb0:	83 ec 10             	sub    $0x10,%esp
80103cb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103cb6:	68 40 1d 11 80       	push   $0x80111d40
80103cbb:	e8 b4 05 00 00       	call   80104274 <acquire>
80103cc0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc3:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103cc8:	eb 0e                	jmp    80103cd8 <kill+0x2c>
80103cca:	66 90                	xchg   %ax,%ax
80103ccc:	05 a4 00 00 00       	add    $0xa4,%eax
80103cd1:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103cd6:	74 30                	je     80103d08 <kill+0x5c>
    if(p->pid == pid){
80103cd8:	39 58 38             	cmp    %ebx,0x38(%eax)
80103cdb:	75 ef                	jne    80103ccc <kill+0x20>
      p->killed = 1;
80103cdd:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ce4:	83 78 34 02          	cmpl   $0x2,0x34(%eax)
80103ce8:	75 07                	jne    80103cf1 <kill+0x45>
        p->state = RUNNABLE;
80103cea:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
      release(&ptable.lock);
80103cf1:	83 ec 0c             	sub    $0xc,%esp
80103cf4:	68 40 1d 11 80       	push   $0x80111d40
80103cf9:	e8 16 05 00 00       	call   80104214 <release>
      return 0;
80103cfe:	83 c4 10             	add    $0x10,%esp
80103d01:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d06:	c9                   	leave
80103d07:	c3                   	ret
  release(&ptable.lock);
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	68 40 1d 11 80       	push   $0x80111d40
80103d10:	e8 ff 04 00 00       	call   80104214 <release>
  return -1;
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d20:	c9                   	leave
80103d21:	c3                   	ret
80103d22:	66 90                	xchg   %ax,%ax

80103d24 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	57                   	push   %edi
80103d28:	56                   	push   %esi
80103d29:	53                   	push   %ebx
80103d2a:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d2d:	bb 08 1e 11 80       	mov    $0x80111e08,%ebx
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103d32:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103d35:	eb 42                	jmp    80103d79 <procdump+0x55>
80103d37:	90                   	nop
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103d38:	8b 04 85 e0 73 10 80 	mov    -0x7fef8c20(,%eax,4),%eax
80103d3f:	85 c0                	test   %eax,%eax
80103d41:	74 42                	je     80103d85 <procdump+0x61>
    cprintf("%d %s %s", p->pid, state, p->name);
80103d43:	53                   	push   %ebx
80103d44:	50                   	push   %eax
80103d45:	ff 73 a4             	push   -0x5c(%ebx)
80103d48:	68 32 6e 10 80       	push   $0x80106e32
80103d4d:	e8 ce c8 ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
80103d52:	83 c4 10             	add    $0x10,%esp
80103d55:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103d59:	74 31                	je     80103d8c <procdump+0x68>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103d5b:	83 ec 0c             	sub    $0xc,%esp
80103d5e:	68 eb 6f 10 80       	push   $0x80106feb
80103d63:	e8 b8 c8 ff ff       	call   80100620 <cprintf>
80103d68:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d6b:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80103d71:	81 fb 08 47 11 80    	cmp    $0x80114708,%ebx
80103d77:	74 4f                	je     80103dc8 <procdump+0xa4>
    if(p->state == UNUSED)
80103d79:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103d7c:	85 c0                	test   %eax,%eax
80103d7e:	74 eb                	je     80103d6b <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103d80:	83 f8 06             	cmp    $0x6,%eax
80103d83:	76 b3                	jbe    80103d38 <procdump+0x14>
      state = "???";
80103d85:	b8 2e 6e 10 80       	mov    $0x80106e2e,%eax
80103d8a:	eb b7                	jmp    80103d43 <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103d8c:	83 ec 08             	sub    $0x8,%esp
80103d8f:	56                   	push   %esi
80103d90:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103d93:	8b 40 0c             	mov    0xc(%eax),%eax
80103d96:	83 c0 08             	add    $0x8,%eax
80103d99:	50                   	push   %eax
80103d9a:	e8 29 03 00 00       	call   801040c8 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d9f:	89 f7                	mov    %esi,%edi
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	8b 07                	mov    (%edi),%eax
80103da6:	85 c0                	test   %eax,%eax
80103da8:	74 b1                	je     80103d5b <procdump+0x37>
        cprintf(" %p", pc[i]);
80103daa:	83 ec 08             	sub    $0x8,%esp
80103dad:	50                   	push   %eax
80103dae:	68 21 6b 10 80       	push   $0x80106b21
80103db3:	e8 68 c8 ff ff       	call   80100620 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103db8:	83 c7 04             	add    $0x4,%edi
80103dbb:	83 c4 10             	add    $0x10,%esp
80103dbe:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103dc1:	39 c7                	cmp    %eax,%edi
80103dc3:	75 df                	jne    80103da4 <procdump+0x80>
80103dc5:	eb 94                	jmp    80103d5b <procdump+0x37>
80103dc7:	90                   	nop
  }
}
80103dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dcb:	5b                   	pop    %ebx
80103dcc:	5e                   	pop    %esi
80103dcd:	5f                   	pop    %edi
80103dce:	5d                   	pop    %ebp
80103dcf:	c3                   	ret

80103dd0 <sys_custom_fork>:



int sys_custom_fork(void) {
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 1c             	sub    $0x1c,%esp
    int start_later, exec_time;
    if (argint(0, &start_later) < 0 || argint(1, &exec_time) < 0)
80103dd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80103dda:	50                   	push   %eax
80103ddb:	6a 00                	push   $0x0
80103ddd:	e8 82 07 00 00       	call   80104564 <argint>
80103de2:	83 c4 10             	add    $0x10,%esp
80103de5:	85 c0                	test   %eax,%eax
80103de7:	78 63                	js     80103e4c <sys_custom_fork+0x7c>
80103de9:	83 ec 08             	sub    $0x8,%esp
80103dec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103def:	50                   	push   %eax
80103df0:	6a 01                	push   $0x1
80103df2:	e8 6d 07 00 00       	call   80104564 <argint>
80103df7:	83 c4 10             	add    $0x10,%esp
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	78 4e                	js     80103e4c <sys_custom_fork+0x7c>
        return -1;

    int pid = fork();
80103dfe:	e8 75 f8 ff ff       	call   80103678 <fork>
    if (pid < 0) return -1;
80103e03:	85 c0                	test   %eax,%eax
80103e05:	78 45                	js     80103e4c <sys_custom_fork+0x7c>
    if (pid == 0) return 0; // Child process
80103e07:	74 2f                	je     80103e38 <sys_custom_fork+0x68>

    // Parent: set flags on child
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e09:	ba 74 1d 11 80       	mov    $0x80111d74,%edx
80103e0e:	eb 0e                	jmp    80103e1e <sys_custom_fork+0x4e>
80103e10:	81 c2 a4 00 00 00    	add    $0xa4,%edx
80103e16:	81 fa 74 46 11 80    	cmp    $0x80114674,%edx
80103e1c:	74 1a                	je     80103e38 <sys_custom_fork+0x68>
        if (p->pid == pid) {
80103e1e:	39 42 38             	cmp    %eax,0x38(%edx)
80103e21:	75 ed                	jne    80103e10 <sys_custom_fork+0x40>
            p->start_later = start_later;
80103e23:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80103e26:	89 0a                	mov    %ecx,(%edx)
            p->exec_time = exec_time;
80103e28:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103e2b:	89 5a 04             	mov    %ebx,0x4(%edx)

            if (start_later == 1)
80103e2e:	49                   	dec    %ecx
80103e2f:	74 0f                	je     80103e40 <sys_custom_fork+0x70>
                p->state = WAITING_TO_START ;  // Mark it so scheduler won’t pick it up
            else
                p->state = RUNNABLE;
80103e31:	c7 42 34 04 00 00 00 	movl   $0x4,0x34(%edx)

            break;
        }
    }
    return pid;
}
80103e38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e3b:	c9                   	leave
80103e3c:	c3                   	ret
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
                p->state = WAITING_TO_START ;  // Mark it so scheduler won’t pick it up
80103e40:	c7 42 34 03 00 00 00 	movl   $0x3,0x34(%edx)
}
80103e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e4a:	c9                   	leave
80103e4b:	c3                   	ret
        return -1;
80103e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e51:	eb e5                	jmp    80103e38 <sys_custom_fork+0x68>
80103e53:	90                   	nop

80103e54 <sys_scheduler_start>:


int sys_scheduler_start(void) {
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;
    acquire(&ptable.lock);
80103e5a:	68 40 1d 11 80       	push   $0x80111d40
80103e5f:	e8 10 04 00 00       	call   80104274 <acquire>
80103e64:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e67:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103e6c:	eb 0e                	jmp    80103e7c <sys_scheduler_start+0x28>
80103e6e:	66 90                	xchg   %ax,%ax
80103e70:	05 a4 00 00 00       	add    $0xa4,%eax
80103e75:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103e7a:	74 24                	je     80103ea0 <sys_scheduler_start+0x4c>
         if(p->start_later == 1 && p->state == WAITING_TO_START) {
80103e7c:	83 38 01             	cmpl   $0x1,(%eax)
80103e7f:	75 ef                	jne    80103e70 <sys_scheduler_start+0x1c>
80103e81:	83 78 34 03          	cmpl   $0x3,0x34(%eax)
80103e85:	75 e9                	jne    80103e70 <sys_scheduler_start+0x1c>
              p->state = RUNNABLE;
80103e87:	c7 40 34 04 00 00 00 	movl   $0x4,0x34(%eax)
              p->start_later = 0;
80103e8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e94:	05 a4 00 00 00       	add    $0xa4,%eax
80103e99:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103e9e:	75 dc                	jne    80103e7c <sys_scheduler_start+0x28>
          }

    }
    release(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 40 1d 11 80       	push   $0x80111d40
80103ea8:	e8 67 03 00 00       	call   80104214 <release>
    return 0;
}
80103ead:	31 c0                	xor    %eax,%eax
80103eaf:	c9                   	leave
80103eb0:	c3                   	ret
80103eb1:	8d 76 00             	lea    0x0(%esi),%esi

80103eb4 <scheduler>:
// }



void scheduler(void)
{
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	57                   	push   %edi
80103eb8:	56                   	push   %esi
80103eb9:	53                   	push   %ebx
80103eba:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p, *chosen = 0;
  struct cpu *c = mycpu();
80103ebd:	e8 9e f5 ff ff       	call   80103460 <mycpu>
80103ec2:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103ec4:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ecb:	00 00 00 
80103ece:	8d 70 04             	lea    0x4(%eax),%esi
80103ed1:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ed4:	fb                   	sti
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Acquire ptable.lock to scan the process table.
    acquire(&ptable.lock);
80103ed5:	83 ec 0c             	sub    $0xc,%esp
80103ed8:	68 40 1d 11 80       	push   $0x80111d40
80103edd:	e8 92 03 00 00       	call   80104274 <acquire>
80103ee2:	83 c4 10             	add    $0x10,%esp

    // First, select one RUNNABLE process to run.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee5:	bf 74 1d 11 80       	mov    $0x80111d74,%edi
      if(p->state != RUNNABLE)
80103eea:	83 7f 34 04          	cmpl   $0x4,0x34(%edi)
80103eee:	74 20                	je     80103f10 <scheduler+0x5c>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef0:	81 c7 a4 00 00 00    	add    $0xa4,%edi
80103ef6:	81 ff 74 46 11 80    	cmp    $0x80114674,%edi
80103efc:	75 ec                	jne    80103eea <scheduler+0x36>

      // Process is done running for now.
      c->proc = 0;
      chosen = 0; // reset chosen pointer for the next iteration
    }
    release(&ptable.lock);
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	68 40 1d 11 80       	push   $0x80111d40
80103f06:	e8 09 03 00 00       	call   80104214 <release>
    sti();
80103f0b:	83 c4 10             	add    $0x10,%esp
80103f0e:	eb c4                	jmp    80103ed4 <scheduler+0x20>
      if(p->has_started == 0) {
80103f10:	8b 4f 24             	mov    0x24(%edi),%ecx
80103f13:	85 c9                	test   %ecx,%ecx
80103f15:	75 0f                	jne    80103f26 <scheduler+0x72>
        p->first_run_time = ticks;
80103f17:	a1 74 46 11 80       	mov    0x80114674,%eax
80103f1c:	89 47 14             	mov    %eax,0x14(%edi)
        p->has_started = 1;
80103f1f:	c7 47 24 01 00 00 00 	movl   $0x1,0x24(%edi)
      p->context_switches++;
80103f26:	ff 47 20             	incl   0x20(%edi)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f29:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103f2e:	eb 0c                	jmp    80103f3c <scheduler+0x88>
80103f30:	05 a4 00 00 00       	add    $0xa4,%eax
80103f35:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103f3a:	74 19                	je     80103f55 <scheduler+0xa1>
        if(p->state == RUNNABLE && p != chosen)
80103f3c:	83 78 34 04          	cmpl   $0x4,0x34(%eax)
80103f40:	75 ee                	jne    80103f30 <scheduler+0x7c>
80103f42:	39 f8                	cmp    %edi,%eax
80103f44:	74 ea                	je     80103f30 <scheduler+0x7c>
          p->total_wait_time++;
80103f46:	ff 40 1c             	incl   0x1c(%eax)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f49:	05 a4 00 00 00       	add    $0xa4,%eax
80103f4e:	3d 74 46 11 80       	cmp    $0x80114674,%eax
80103f53:	75 e7                	jne    80103f3c <scheduler+0x88>
      c->proc = chosen;
80103f55:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(chosen);
80103f5b:	83 ec 0c             	sub    $0xc,%esp
80103f5e:	57                   	push   %edi
80103f5f:	e8 d0 24 00 00       	call   80106434 <switchuvm>
      chosen->state = RUNNING;
80103f64:	c7 47 34 05 00 00 00 	movl   $0x5,0x34(%edi)
      swtch(&(c->scheduler), chosen->context);
80103f6b:	58                   	pop    %eax
80103f6c:	5a                   	pop    %edx
80103f6d:	ff 77 44             	push   0x44(%edi)
80103f70:	56                   	push   %esi
80103f71:	e8 5f 05 00 00       	call   801044d5 <swtch>
      switchkvm();
80103f76:	e8 a9 24 00 00       	call   80106424 <switchkvm>
      chosen->total_run_time++;
80103f7b:	ff 47 18             	incl   0x18(%edi)
      c->proc = 0;
80103f7e:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103f85:	00 00 00 
80103f88:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80103f8b:	83 ec 0c             	sub    $0xc,%esp
80103f8e:	68 40 1d 11 80       	push   $0x80111d40
80103f93:	e8 7c 02 00 00       	call   80104214 <release>
    sti();
80103f98:	83 c4 10             	add    $0x10,%esp
80103f9b:	e9 34 ff ff ff       	jmp    80103ed4 <scheduler+0x20>

80103fa0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 0c             	sub    $0xc,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103faa:	68 74 6e 10 80       	push   $0x80106e74
80103faf:	8d 43 04             	lea    0x4(%ebx),%eax
80103fb2:	50                   	push   %eax
80103fb3:	e8 f4 00 00 00       	call   801040ac <initlock>
  lk->name = name;
80103fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fbb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103fbe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fc4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103fcb:	83 c4 10             	add    $0x10,%esp
80103fce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd1:	c9                   	leave
80103fd2:	c3                   	ret
80103fd3:	90                   	nop

80103fd4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fd4:	55                   	push   %ebp
80103fd5:	89 e5                	mov    %esp,%ebp
80103fd7:	56                   	push   %esi
80103fd8:	53                   	push   %ebx
80103fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fdc:	8d 73 04             	lea    0x4(%ebx),%esi
80103fdf:	83 ec 0c             	sub    $0xc,%esp
80103fe2:	56                   	push   %esi
80103fe3:	e8 8c 02 00 00       	call   80104274 <acquire>
  while (lk->locked) {
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	8b 13                	mov    (%ebx),%edx
80103fed:	85 d2                	test   %edx,%edx
80103fef:	74 16                	je     80104007 <acquiresleep+0x33>
80103ff1:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103ff4:	83 ec 08             	sub    $0x8,%esp
80103ff7:	56                   	push   %esi
80103ff8:	53                   	push   %ebx
80103ff9:	e8 96 fb ff ff       	call   80103b94 <sleep>
  while (lk->locked) {
80103ffe:	83 c4 10             	add    $0x10,%esp
80104001:	8b 03                	mov    (%ebx),%eax
80104003:	85 c0                	test   %eax,%eax
80104005:	75 ed                	jne    80103ff4 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104007:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
8010400d:	e8 e6 f4 ff ff       	call   801034f8 <myproc>
80104012:	8b 40 38             	mov    0x38(%eax),%eax
80104015:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104018:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010401b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010401e:	5b                   	pop    %ebx
8010401f:	5e                   	pop    %esi
80104020:	5d                   	pop    %ebp
  release(&lk->lk);
80104021:	e9 ee 01 00 00       	jmp    80104214 <release>
80104026:	66 90                	xchg   %ax,%ax

80104028 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104028:	55                   	push   %ebp
80104029:	89 e5                	mov    %esp,%ebp
8010402b:	56                   	push   %esi
8010402c:	53                   	push   %ebx
8010402d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104030:	8d 73 04             	lea    0x4(%ebx),%esi
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	56                   	push   %esi
80104037:	e8 38 02 00 00       	call   80104274 <acquire>
  lk->locked = 0;
8010403c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104042:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104049:	89 1c 24             	mov    %ebx,(%esp)
8010404c:	e8 ff fb ff ff       	call   80103c50 <wakeup>
  release(&lk->lk);
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104057:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010405a:	5b                   	pop    %ebx
8010405b:	5e                   	pop    %esi
8010405c:	5d                   	pop    %ebp
  release(&lk->lk);
8010405d:	e9 b2 01 00 00       	jmp    80104214 <release>
80104062:	66 90                	xchg   %ax,%ax

80104064 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	56                   	push   %esi
80104068:	53                   	push   %ebx
80104069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010406c:	8d 73 04             	lea    0x4(%ebx),%esi
8010406f:	83 ec 0c             	sub    $0xc,%esp
80104072:	56                   	push   %esi
80104073:	e8 fc 01 00 00       	call   80104274 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104078:	83 c4 10             	add    $0x10,%esp
8010407b:	8b 03                	mov    (%ebx),%eax
8010407d:	85 c0                	test   %eax,%eax
8010407f:	75 17                	jne    80104098 <holdingsleep+0x34>
80104081:	31 db                	xor    %ebx,%ebx
  release(&lk->lk);
80104083:	83 ec 0c             	sub    $0xc,%esp
80104086:	56                   	push   %esi
80104087:	e8 88 01 00 00       	call   80104214 <release>
  return r;
}
8010408c:	89 d8                	mov    %ebx,%eax
8010408e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104091:	5b                   	pop    %ebx
80104092:	5e                   	pop    %esi
80104093:	5d                   	pop    %ebp
80104094:	c3                   	ret
80104095:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104098:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010409b:	e8 58 f4 ff ff       	call   801034f8 <myproc>
801040a0:	39 58 38             	cmp    %ebx,0x38(%eax)
801040a3:	0f 94 c3             	sete   %bl
801040a6:	0f b6 db             	movzbl %bl,%ebx
801040a9:	eb d8                	jmp    80104083 <holdingsleep+0x1f>
801040ab:	90                   	nop

801040ac <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040ac:	55                   	push   %ebp
801040ad:	89 e5                	mov    %esp,%ebp
801040af:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801040b5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801040b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801040be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040c5:	5d                   	pop    %ebp
801040c6:	c3                   	ret
801040c7:	90                   	nop

801040c8 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040c8:	55                   	push   %ebp
801040c9:	89 e5                	mov    %esp,%ebp
801040cb:	53                   	push   %ebx
801040cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040cf:	8b 45 08             	mov    0x8(%ebp),%eax
801040d2:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801040d5:	31 d2                	xor    %edx,%edx
801040d7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040d8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801040de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040e4:	77 16                	ja     801040fc <getcallerpcs+0x34>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040e6:	8b 58 04             	mov    0x4(%eax),%ebx
801040e9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801040ec:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801040ee:	42                   	inc    %edx
801040ef:	83 fa 0a             	cmp    $0xa,%edx
801040f2:	75 e4                	jne    801040d8 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f7:	c9                   	leave
801040f8:	c3                   	ret
801040f9:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801040fc:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801040ff:	83 c1 28             	add    $0x28,%ecx
80104102:	89 ca                	mov    %ecx,%edx
80104104:	29 c2                	sub    %eax,%edx
80104106:	83 e2 04             	and    $0x4,%edx
80104109:	74 0d                	je     80104118 <getcallerpcs+0x50>
    pcs[i] = 0;
8010410b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104111:	83 c0 04             	add    $0x4,%eax
80104114:	39 c8                	cmp    %ecx,%eax
80104116:	74 dc                	je     801040f4 <getcallerpcs+0x2c>
    pcs[i] = 0;
80104118:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010411e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
80104125:	83 c0 08             	add    $0x8,%eax
80104128:	39 c8                	cmp    %ecx,%eax
8010412a:	75 ec                	jne    80104118 <getcallerpcs+0x50>
8010412c:	eb c6                	jmp    801040f4 <getcallerpcs+0x2c>
8010412e:	66 90                	xchg   %ax,%ax

80104130 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	50                   	push   %eax
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104135:	9c                   	pushf
80104136:	5b                   	pop    %ebx
  asm volatile("cli");
80104137:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104138:	e8 23 f3 ff ff       	call   80103460 <mycpu>
8010413d:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104143:	85 d2                	test   %edx,%edx
80104145:	74 11                	je     80104158 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104147:	e8 14 f3 ff ff       	call   80103460 <mycpu>
8010414c:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80104152:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104155:	c9                   	leave
80104156:	c3                   	ret
80104157:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104158:	e8 03 f3 ff ff       	call   80103460 <mycpu>
8010415d:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104163:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104169:	e8 f2 f2 ff ff       	call   80103460 <mycpu>
8010416e:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80104174:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104177:	c9                   	leave
80104178:	c3                   	ret
80104179:	8d 76 00             	lea    0x0(%esi),%esi

8010417c <popcli>:

void
popcli(void)
{
8010417c:	55                   	push   %ebp
8010417d:	89 e5                	mov    %esp,%ebp
8010417f:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104182:	9c                   	pushf
80104183:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104184:	f6 c4 02             	test   $0x2,%ah
80104187:	75 31                	jne    801041ba <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104189:	e8 d2 f2 ff ff       	call   80103460 <mycpu>
8010418e:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80104194:	78 31                	js     801041c7 <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104196:	e8 c5 f2 ff ff       	call   80103460 <mycpu>
8010419b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801041a1:	85 d2                	test   %edx,%edx
801041a3:	74 03                	je     801041a8 <popcli+0x2c>
    sti();
}
801041a5:	c9                   	leave
801041a6:	c3                   	ret
801041a7:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041a8:	e8 b3 f2 ff ff       	call   80103460 <mycpu>
801041ad:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041b3:	85 c0                	test   %eax,%eax
801041b5:	74 ee                	je     801041a5 <popcli+0x29>
  asm volatile("sti");
801041b7:	fb                   	sti
}
801041b8:	c9                   	leave
801041b9:	c3                   	ret
    panic("popcli - interruptible");
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 7f 6e 10 80       	push   $0x80106e7f
801041c2:	e8 71 c1 ff ff       	call   80100338 <panic>
    panic("popcli");
801041c7:	83 ec 0c             	sub    $0xc,%esp
801041ca:	68 96 6e 10 80       	push   $0x80106e96
801041cf:	e8 64 c1 ff ff       	call   80100338 <panic>

801041d4 <holding>:
{
801041d4:	55                   	push   %ebp
801041d5:	89 e5                	mov    %esp,%ebp
801041d7:	53                   	push   %ebx
801041d8:	50                   	push   %eax
801041d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801041dc:	e8 4f ff ff ff       	call   80104130 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801041e1:	8b 13                	mov    (%ebx),%edx
801041e3:	85 d2                	test   %edx,%edx
801041e5:	75 11                	jne    801041f8 <holding+0x24>
801041e7:	31 db                	xor    %ebx,%ebx
  popcli();
801041e9:	e8 8e ff ff ff       	call   8010417c <popcli>
}
801041ee:	89 d8                	mov    %ebx,%eax
801041f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041f3:	c9                   	leave
801041f4:	c3                   	ret
801041f5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801041f8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801041fb:	e8 60 f2 ff ff       	call   80103460 <mycpu>
80104200:	39 c3                	cmp    %eax,%ebx
80104202:	0f 94 c3             	sete   %bl
80104205:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104208:	e8 6f ff ff ff       	call   8010417c <popcli>
}
8010420d:	89 d8                	mov    %ebx,%eax
8010420f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104212:	c9                   	leave
80104213:	c3                   	ret

80104214 <release>:
{
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	56                   	push   %esi
80104218:	53                   	push   %ebx
80104219:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010421c:	e8 0f ff ff ff       	call   80104130 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104221:	8b 03                	mov    (%ebx),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	75 15                	jne    8010423c <release+0x28>
  popcli();
80104227:	e8 50 ff ff ff       	call   8010417c <popcli>
    panic("release");
8010422c:	83 ec 0c             	sub    $0xc,%esp
8010422f:	68 9d 6e 10 80       	push   $0x80106e9d
80104234:	e8 ff c0 ff ff       	call   80100338 <panic>
80104239:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
8010423c:	8b 73 08             	mov    0x8(%ebx),%esi
8010423f:	e8 1c f2 ff ff       	call   80103460 <mycpu>
80104244:	39 c6                	cmp    %eax,%esi
80104246:	75 df                	jne    80104227 <release+0x13>
  popcli();
80104248:	e8 2f ff ff ff       	call   8010417c <popcli>
  lk->pcs[0] = 0;
8010424d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104254:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010425b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104260:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104269:	5b                   	pop    %ebx
8010426a:	5e                   	pop    %esi
8010426b:	5d                   	pop    %ebp
  popcli();
8010426c:	e9 0b ff ff ff       	jmp    8010417c <popcli>
80104271:	8d 76 00             	lea    0x0(%esi),%esi

80104274 <acquire>:
{
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	53                   	push   %ebx
80104278:	50                   	push   %eax
  pushcli(); // disable interrupts to avoid deadlock.
80104279:	e8 b2 fe ff ff       	call   80104130 <pushcli>
  if(holding(lk))
8010427e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104281:	e8 aa fe ff ff       	call   80104130 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104286:	8b 13                	mov    (%ebx),%edx
80104288:	85 d2                	test   %edx,%edx
8010428a:	0f 85 8c 00 00 00    	jne    8010431c <acquire+0xa8>
  popcli();
80104290:	e8 e7 fe ff ff       	call   8010417c <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104295:	b9 01 00 00 00       	mov    $0x1,%ecx
8010429a:	66 90                	xchg   %ax,%ax
  while(xchg(&lk->locked, 1) != 0)
8010429c:	8b 55 08             	mov    0x8(%ebp),%edx
8010429f:	89 c8                	mov    %ecx,%eax
801042a1:	f0 87 02             	lock xchg %eax,(%edx)
801042a4:	85 c0                	test   %eax,%eax
801042a6:	75 f4                	jne    8010429c <acquire+0x28>
  __sync_synchronize();
801042a8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801042ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042b0:	e8 ab f1 ff ff       	call   80103460 <mycpu>
801042b5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801042b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801042bb:	31 c0                	xor    %eax,%eax
  ebp = (uint*)v - 2;
801042bd:	89 ea                	mov    %ebp,%edx
801042bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042cc:	77 16                	ja     801042e4 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801042ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801042d1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801042d5:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801042d7:	40                   	inc    %eax
801042d8:	83 f8 0a             	cmp    $0xa,%eax
801042db:	75 e3                	jne    801042c0 <acquire+0x4c>
}
801042dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e0:	c9                   	leave
801042e1:	c3                   	ret
801042e2:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
801042e4:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801042e8:	83 c1 34             	add    $0x34,%ecx
801042eb:	89 ca                	mov    %ecx,%edx
801042ed:	29 c2                	sub    %eax,%edx
801042ef:	83 e2 04             	and    $0x4,%edx
801042f2:	74 10                	je     80104304 <acquire+0x90>
    pcs[i] = 0;
801042f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801042fa:	83 c0 04             	add    $0x4,%eax
801042fd:	39 c8                	cmp    %ecx,%eax
801042ff:	74 dc                	je     801042dd <acquire+0x69>
80104301:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104304:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010430a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for(; i < 10; i++)
80104311:	83 c0 08             	add    $0x8,%eax
80104314:	39 c8                	cmp    %ecx,%eax
80104316:	75 ec                	jne    80104304 <acquire+0x90>
80104318:	eb c3                	jmp    801042dd <acquire+0x69>
8010431a:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
8010431c:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010431f:	e8 3c f1 ff ff       	call   80103460 <mycpu>
80104324:	39 c3                	cmp    %eax,%ebx
80104326:	0f 85 64 ff ff ff    	jne    80104290 <acquire+0x1c>
  popcli();
8010432c:	e8 4b fe ff ff       	call   8010417c <popcli>
    panic("acquire");
80104331:	83 ec 0c             	sub    $0xc,%esp
80104334:	68 a5 6e 10 80       	push   $0x80106ea5
80104339:	e8 fa bf ff ff       	call   80100338 <panic>
8010433e:	66 90                	xchg   %ax,%ax

80104340 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	8b 55 08             	mov    0x8(%ebp),%edx
80104347:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010434a:	89 d0                	mov    %edx,%eax
8010434c:	09 c8                	or     %ecx,%eax
8010434e:	a8 03                	test   $0x3,%al
80104350:	75 22                	jne    80104374 <memset+0x34>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104352:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
80104355:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104359:	89 f8                	mov    %edi,%eax
8010435b:	c1 e0 08             	shl    $0x8,%eax
8010435e:	01 f8                	add    %edi,%eax
80104360:	89 c7                	mov    %eax,%edi
80104362:	c1 e7 10             	shl    $0x10,%edi
80104365:	01 f8                	add    %edi,%eax
  asm volatile("cld; rep stosl" :
80104367:	89 d7                	mov    %edx,%edi
80104369:	fc                   	cld
8010436a:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
8010436c:	89 d0                	mov    %edx,%eax
8010436e:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104371:	c9                   	leave
80104372:	c3                   	ret
80104373:	90                   	nop
  asm volatile("cld; rep stosb" :
80104374:	89 d7                	mov    %edx,%edi
80104376:	8b 45 0c             	mov    0xc(%ebp),%eax
80104379:	fc                   	cld
8010437a:	f3 aa                	rep stos %al,%es:(%edi)
8010437c:	89 d0                	mov    %edx,%eax
8010437e:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104381:	c9                   	leave
80104382:	c3                   	ret
80104383:	90                   	nop

80104384 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104384:	55                   	push   %ebp
80104385:	89 e5                	mov    %esp,%ebp
80104387:	56                   	push   %esi
80104388:	53                   	push   %ebx
80104389:	8b 45 08             	mov    0x8(%ebp),%eax
8010438c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010438f:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104392:	85 f6                	test   %esi,%esi
80104394:	74 1e                	je     801043b4 <memcmp+0x30>
80104396:	01 c6                	add    %eax,%esi
80104398:	eb 08                	jmp    801043a2 <memcmp+0x1e>
8010439a:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
8010439c:	40                   	inc    %eax
8010439d:	42                   	inc    %edx
  while(n-- > 0){
8010439e:	39 f0                	cmp    %esi,%eax
801043a0:	74 12                	je     801043b4 <memcmp+0x30>
    if(*s1 != *s2)
801043a2:	8a 08                	mov    (%eax),%cl
801043a4:	0f b6 1a             	movzbl (%edx),%ebx
801043a7:	38 d9                	cmp    %bl,%cl
801043a9:	74 f1                	je     8010439c <memcmp+0x18>
      return *s1 - *s2;
801043ab:	0f b6 c1             	movzbl %cl,%eax
801043ae:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801043b0:	5b                   	pop    %ebx
801043b1:	5e                   	pop    %esi
801043b2:	5d                   	pop    %ebp
801043b3:	c3                   	ret
  return 0;
801043b4:	31 c0                	xor    %eax,%eax
}
801043b6:	5b                   	pop    %ebx
801043b7:	5e                   	pop    %esi
801043b8:	5d                   	pop    %ebp
801043b9:	c3                   	ret
801043ba:	66 90                	xchg   %ax,%ax

801043bc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043bc:	55                   	push   %ebp
801043bd:	89 e5                	mov    %esp,%ebp
801043bf:	57                   	push   %edi
801043c0:	56                   	push   %esi
801043c1:	8b 55 08             	mov    0x8(%ebp),%edx
801043c4:	8b 75 0c             	mov    0xc(%ebp),%esi
801043c7:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043ca:	39 d6                	cmp    %edx,%esi
801043cc:	73 22                	jae    801043f0 <memmove+0x34>
801043ce:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801043d1:	39 ca                	cmp    %ecx,%edx
801043d3:	73 1b                	jae    801043f0 <memmove+0x34>
    s += n;
    d += n;
    while(n-- > 0)
801043d5:	85 c0                	test   %eax,%eax
801043d7:	74 0e                	je     801043e7 <memmove+0x2b>
801043d9:	48                   	dec    %eax
801043da:	66 90                	xchg   %ax,%ax
      *--d = *--s;
801043dc:	8a 0c 06             	mov    (%esi,%eax,1),%cl
801043df:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801043e2:	83 e8 01             	sub    $0x1,%eax
801043e5:	73 f5                	jae    801043dc <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043e7:	89 d0                	mov    %edx,%eax
801043e9:	5e                   	pop    %esi
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801043f0:	85 c0                	test   %eax,%eax
801043f2:	74 f3                	je     801043e7 <memmove+0x2b>
801043f4:	01 f0                	add    %esi,%eax
801043f6:	89 d7                	mov    %edx,%edi
      *d++ = *s++;
801043f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801043f9:	39 f0                	cmp    %esi,%eax
801043fb:	75 fb                	jne    801043f8 <memmove+0x3c>
}
801043fd:	89 d0                	mov    %edx,%eax
801043ff:	5e                   	pop    %esi
80104400:	5f                   	pop    %edi
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret
80104403:	90                   	nop

80104404 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104404:	eb b6                	jmp    801043bc <memmove>
80104406:	66 90                	xchg   %ax,%ax

80104408 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104408:	55                   	push   %ebp
80104409:	89 e5                	mov    %esp,%ebp
8010440b:	53                   	push   %ebx
8010440c:	8b 45 08             	mov    0x8(%ebp),%eax
8010440f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104412:	8b 55 10             	mov    0x10(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104415:	85 d2                	test   %edx,%edx
80104417:	75 0c                	jne    80104425 <strncmp+0x1d>
80104419:	eb 1d                	jmp    80104438 <strncmp+0x30>
8010441b:	90                   	nop
8010441c:	3a 19                	cmp    (%ecx),%bl
8010441e:	75 0b                	jne    8010442b <strncmp+0x23>
    n--, p++, q++;
80104420:	40                   	inc    %eax
80104421:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80104422:	4a                   	dec    %edx
80104423:	74 13                	je     80104438 <strncmp+0x30>
80104425:	8a 18                	mov    (%eax),%bl
80104427:	84 db                	test   %bl,%bl
80104429:	75 f1                	jne    8010441c <strncmp+0x14>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010442b:	0f b6 00             	movzbl (%eax),%eax
8010442e:	0f b6 11             	movzbl (%ecx),%edx
80104431:	29 d0                	sub    %edx,%eax
}
80104433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104436:	c9                   	leave
80104437:	c3                   	ret
    return 0;
80104438:	31 c0                	xor    %eax,%eax
}
8010443a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010443d:	c9                   	leave
8010443e:	c3                   	ret
8010443f:	90                   	nop

80104440 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104448:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010444b:	8b 55 08             	mov    0x8(%ebp),%edx
8010444e:	eb 0c                	jmp    8010445c <strncpy+0x1c>
80104450:	43                   	inc    %ebx
80104451:	42                   	inc    %edx
80104452:	8a 43 ff             	mov    -0x1(%ebx),%al
80104455:	88 42 ff             	mov    %al,-0x1(%edx)
80104458:	84 c0                	test   %al,%al
8010445a:	74 10                	je     8010446c <strncpy+0x2c>
8010445c:	89 ce                	mov    %ecx,%esi
8010445e:	49                   	dec    %ecx
8010445f:	85 f6                	test   %esi,%esi
80104461:	7f ed                	jg     80104450 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
80104466:	5b                   	pop    %ebx
80104467:	5e                   	pop    %esi
80104468:	5d                   	pop    %ebp
80104469:	c3                   	ret
8010446a:	66 90                	xchg   %ax,%ax
  while(n-- > 0)
8010446c:	8d 5c 32 ff          	lea    -0x1(%edx,%esi,1),%ebx
80104470:	85 c9                	test   %ecx,%ecx
80104472:	74 ef                	je     80104463 <strncpy+0x23>
    *s++ = 0;
80104474:	42                   	inc    %edx
80104475:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104479:	89 d9                	mov    %ebx,%ecx
8010447b:	29 d1                	sub    %edx,%ecx
8010447d:	85 c9                	test   %ecx,%ecx
8010447f:	7f f3                	jg     80104474 <strncpy+0x34>
}
80104481:	8b 45 08             	mov    0x8(%ebp),%eax
80104484:	5b                   	pop    %ebx
80104485:	5e                   	pop    %esi
80104486:	5d                   	pop    %ebp
80104487:	c3                   	ret

80104488 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104488:	55                   	push   %ebp
80104489:	89 e5                	mov    %esp,%ebp
8010448b:	56                   	push   %esi
8010448c:	53                   	push   %ebx
8010448d:	8b 45 08             	mov    0x8(%ebp),%eax
80104490:	8b 55 0c             	mov    0xc(%ebp),%edx
80104493:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80104496:	85 c9                	test   %ecx,%ecx
80104498:	7e 1d                	jle    801044b7 <safestrcpy+0x2f>
8010449a:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
8010449e:	89 c1                	mov    %eax,%ecx
801044a0:	eb 0e                	jmp    801044b0 <safestrcpy+0x28>
801044a2:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044a4:	42                   	inc    %edx
801044a5:	41                   	inc    %ecx
801044a6:	8a 5a ff             	mov    -0x1(%edx),%bl
801044a9:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044ac:	84 db                	test   %bl,%bl
801044ae:	74 04                	je     801044b4 <safestrcpy+0x2c>
801044b0:	39 f2                	cmp    %esi,%edx
801044b2:	75 f0                	jne    801044a4 <safestrcpy+0x1c>
    ;
  *s = 0;
801044b4:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044b7:	5b                   	pop    %ebx
801044b8:	5e                   	pop    %esi
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret
801044bb:	90                   	nop

801044bc <strlen>:

int
strlen(const char *s)
{
801044bc:	55                   	push   %ebp
801044bd:	89 e5                	mov    %esp,%ebp
801044bf:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801044c2:	31 c0                	xor    %eax,%eax
801044c4:	80 3a 00             	cmpb   $0x0,(%edx)
801044c7:	74 0a                	je     801044d3 <strlen+0x17>
801044c9:	8d 76 00             	lea    0x0(%esi),%esi
801044cc:	40                   	inc    %eax
801044cd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044d1:	75 f9                	jne    801044cc <strlen+0x10>
    ;
  return n;
}
801044d3:	5d                   	pop    %ebp
801044d4:	c3                   	ret

801044d5 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044d5:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044d9:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801044dd:	55                   	push   %ebp
  pushl %ebx
801044de:	53                   	push   %ebx
  pushl %esi
801044df:	56                   	push   %esi
  pushl %edi
801044e0:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044e1:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044e3:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801044e5:	5f                   	pop    %edi
  popl %esi
801044e6:	5e                   	pop    %esi
  popl %ebx
801044e7:	5b                   	pop    %ebx
  popl %ebp
801044e8:	5d                   	pop    %ebp
  ret
801044e9:	c3                   	ret
801044ea:	66 90                	xchg   %ax,%ax

801044ec <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044ec:	55                   	push   %ebp
801044ed:	89 e5                	mov    %esp,%ebp
801044ef:	53                   	push   %ebx
801044f0:	50                   	push   %eax
801044f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801044f4:	e8 ff ef ff ff       	call   801034f8 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801044f9:	8b 40 28             	mov    0x28(%eax),%eax
801044fc:	39 c3                	cmp    %eax,%ebx
801044fe:	73 18                	jae    80104518 <fetchint+0x2c>
80104500:	8d 53 04             	lea    0x4(%ebx),%edx
80104503:	39 d0                	cmp    %edx,%eax
80104505:	72 11                	jb     80104518 <fetchint+0x2c>
    return -1;
  *ip = *(int*)(addr);
80104507:	8b 13                	mov    (%ebx),%edx
80104509:	8b 45 0c             	mov    0xc(%ebp),%eax
8010450c:	89 10                	mov    %edx,(%eax)
  return 0;
8010450e:	31 c0                	xor    %eax,%eax
}
80104510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104513:	c9                   	leave
80104514:	c3                   	ret
80104515:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010451d:	eb f1                	jmp    80104510 <fetchint+0x24>
8010451f:	90                   	nop

80104520 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	50                   	push   %eax
80104525:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104528:	e8 cb ef ff ff       	call   801034f8 <myproc>

  if(addr >= curproc->sz)
8010452d:	3b 58 28             	cmp    0x28(%eax),%ebx
80104530:	73 26                	jae    80104558 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
80104532:	8b 55 0c             	mov    0xc(%ebp),%edx
80104535:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104537:	8b 50 28             	mov    0x28(%eax),%edx
  for(s = *pp; s < ep; s++){
8010453a:	39 d3                	cmp    %edx,%ebx
8010453c:	73 1a                	jae    80104558 <fetchstr+0x38>
8010453e:	89 d8                	mov    %ebx,%eax
80104540:	eb 07                	jmp    80104549 <fetchstr+0x29>
80104542:	66 90                	xchg   %ax,%ax
80104544:	40                   	inc    %eax
80104545:	39 d0                	cmp    %edx,%eax
80104547:	73 0f                	jae    80104558 <fetchstr+0x38>
    if(*s == 0)
80104549:	80 38 00             	cmpb   $0x0,(%eax)
8010454c:	75 f6                	jne    80104544 <fetchstr+0x24>
      return s - *pp;
8010454e:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104553:	c9                   	leave
80104554:	c3                   	ret
80104555:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010455d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104560:	c9                   	leave
80104561:	c3                   	ret
80104562:	66 90                	xchg   %ax,%ax

80104564 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	56                   	push   %esi
80104568:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104569:	e8 8a ef ff ff       	call   801034f8 <myproc>
8010456e:	8b 40 40             	mov    0x40(%eax),%eax
80104571:	8b 40 44             	mov    0x44(%eax),%eax
80104574:	8b 55 08             	mov    0x8(%ebp),%edx
80104577:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
8010457a:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
8010457d:	e8 76 ef ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104582:	8b 40 28             	mov    0x28(%eax),%eax
80104585:	39 c6                	cmp    %eax,%esi
80104587:	73 17                	jae    801045a0 <argint+0x3c>
80104589:	8d 53 08             	lea    0x8(%ebx),%edx
8010458c:	39 d0                	cmp    %edx,%eax
8010458e:	72 10                	jb     801045a0 <argint+0x3c>
  *ip = *(int*)(addr);
80104590:	8b 53 04             	mov    0x4(%ebx),%edx
80104593:	8b 45 0c             	mov    0xc(%ebp),%eax
80104596:	89 10                	mov    %edx,(%eax)
  return 0;
80104598:	31 c0                	xor    %eax,%eax
}
8010459a:	5b                   	pop    %ebx
8010459b:	5e                   	pop    %esi
8010459c:	5d                   	pop    %ebp
8010459d:	c3                   	ret
8010459e:	66 90                	xchg   %ax,%ax
    return -1;
801045a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045a5:	eb f3                	jmp    8010459a <argint+0x36>
801045a7:	90                   	nop

801045a8 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801045a8:	55                   	push   %ebp
801045a9:	89 e5                	mov    %esp,%ebp
801045ab:	57                   	push   %edi
801045ac:	56                   	push   %esi
801045ad:	53                   	push   %ebx
801045ae:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801045b1:	e8 42 ef ff ff       	call   801034f8 <myproc>
801045b6:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045b8:	e8 3b ef ff ff       	call   801034f8 <myproc>
801045bd:	8b 40 40             	mov    0x40(%eax),%eax
801045c0:	8b 40 44             	mov    0x44(%eax),%eax
801045c3:	8b 55 08             	mov    0x8(%ebp),%edx
801045c6:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801045c9:	8d 7b 04             	lea    0x4(%ebx),%edi
  struct proc *curproc = myproc();
801045cc:	e8 27 ef ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045d1:	8b 40 28             	mov    0x28(%eax),%eax
801045d4:	39 c7                	cmp    %eax,%edi
801045d6:	73 30                	jae    80104608 <argptr+0x60>
801045d8:	8d 4b 08             	lea    0x8(%ebx),%ecx
801045db:	39 c8                	cmp    %ecx,%eax
801045dd:	72 29                	jb     80104608 <argptr+0x60>
  *ip = *(int*)(addr);
801045df:	8b 43 04             	mov    0x4(%ebx),%eax
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801045e2:	8b 55 10             	mov    0x10(%ebp),%edx
801045e5:	85 d2                	test   %edx,%edx
801045e7:	78 1f                	js     80104608 <argptr+0x60>
801045e9:	8b 56 28             	mov    0x28(%esi),%edx
801045ec:	39 d0                	cmp    %edx,%eax
801045ee:	73 18                	jae    80104608 <argptr+0x60>
801045f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
801045f3:	01 c3                	add    %eax,%ebx
801045f5:	39 da                	cmp    %ebx,%edx
801045f7:	72 0f                	jb     80104608 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801045f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801045fc:	89 02                	mov    %eax,(%edx)
  return 0;
801045fe:	31 c0                	xor    %eax,%eax
}
80104600:	83 c4 0c             	add    $0xc,%esp
80104603:	5b                   	pop    %ebx
80104604:	5e                   	pop    %esi
80104605:	5f                   	pop    %edi
80104606:	5d                   	pop    %ebp
80104607:	c3                   	ret
    return -1;
80104608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010460d:	eb f1                	jmp    80104600 <argptr+0x58>
8010460f:	90                   	nop

80104610 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104615:	e8 de ee ff ff       	call   801034f8 <myproc>
8010461a:	8b 40 40             	mov    0x40(%eax),%eax
8010461d:	8b 40 44             	mov    0x44(%eax),%eax
80104620:	8b 55 08             	mov    0x8(%ebp),%edx
80104623:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104626:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
80104629:	e8 ca ee ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010462e:	8b 40 28             	mov    0x28(%eax),%eax
80104631:	39 c6                	cmp    %eax,%esi
80104633:	73 37                	jae    8010466c <argstr+0x5c>
80104635:	8d 53 08             	lea    0x8(%ebx),%edx
80104638:	39 d0                	cmp    %edx,%eax
8010463a:	72 30                	jb     8010466c <argstr+0x5c>
  *ip = *(int*)(addr);
8010463c:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010463f:	e8 b4 ee ff ff       	call   801034f8 <myproc>
  if(addr >= curproc->sz)
80104644:	3b 58 28             	cmp    0x28(%eax),%ebx
80104647:	73 23                	jae    8010466c <argstr+0x5c>
  *pp = (char*)addr;
80104649:	8b 55 0c             	mov    0xc(%ebp),%edx
8010464c:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010464e:	8b 50 28             	mov    0x28(%eax),%edx
  for(s = *pp; s < ep; s++){
80104651:	39 d3                	cmp    %edx,%ebx
80104653:	73 17                	jae    8010466c <argstr+0x5c>
80104655:	89 d8                	mov    %ebx,%eax
80104657:	eb 08                	jmp    80104661 <argstr+0x51>
80104659:	8d 76 00             	lea    0x0(%esi),%esi
8010465c:	40                   	inc    %eax
8010465d:	39 d0                	cmp    %edx,%eax
8010465f:	73 0b                	jae    8010466c <argstr+0x5c>
    if(*s == 0)
80104661:	80 38 00             	cmpb   $0x0,(%eax)
80104664:	75 f6                	jne    8010465c <argstr+0x4c>
      return s - *pp;
80104666:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret
    return -1;
8010466c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104671:	5b                   	pop    %ebx
80104672:	5e                   	pop    %esi
80104673:	5d                   	pop    %ebp
80104674:	c3                   	ret
80104675:	8d 76 00             	lea    0x0(%esi),%esi

80104678 <syscall>:
[SYS_scheduler_start] sys_scheduler_start
};

void
syscall(void)
{
80104678:	55                   	push   %ebp
80104679:	89 e5                	mov    %esp,%ebp
8010467b:	53                   	push   %ebx
8010467c:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
8010467d:	e8 76 ee ff ff       	call   801034f8 <myproc>
80104682:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104684:	8b 40 40             	mov    0x40(%eax),%eax
80104687:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010468a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010468d:	83 fa 17             	cmp    $0x17,%edx
80104690:	77 1a                	ja     801046ac <syscall+0x34>
80104692:	8b 14 85 00 74 10 80 	mov    -0x7fef8c00(,%eax,4),%edx
80104699:	85 d2                	test   %edx,%edx
8010469b:	74 0f                	je     801046ac <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
8010469d:	ff d2                	call   *%edx
8010469f:	89 c2                	mov    %eax,%edx
801046a1:	8b 43 40             	mov    0x40(%ebx),%eax
801046a4:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046aa:	c9                   	leave
801046ab:	c3                   	ret
    cprintf("%d %s: unknown sys call %d\n",
801046ac:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801046ad:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801046b3:	50                   	push   %eax
801046b4:	ff 73 38             	push   0x38(%ebx)
801046b7:	68 ad 6e 10 80       	push   $0x80106ead
801046bc:	e8 5f bf ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
801046c1:	8b 43 40             	mov    0x40(%ebx),%eax
801046c4:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801046cb:	83 c4 10             	add    $0x10,%esp
}
801046ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d1:	c9                   	leave
801046d2:	c3                   	ret
801046d3:	90                   	nop

801046d4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	56                   	push   %esi
801046d9:	53                   	push   %ebx
801046da:	83 ec 34             	sub    $0x34,%esp
801046dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801046e0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801046e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046e6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046e9:	8d 7d da             	lea    -0x26(%ebp),%edi
801046ec:	57                   	push   %edi
801046ed:	50                   	push   %eax
801046ee:	e8 99 d7 ff ff       	call   80101e8c <nameiparent>
801046f3:	83 c4 10             	add    $0x10,%esp
801046f6:	85 c0                	test   %eax,%eax
801046f8:	74 5a                	je     80104754 <create+0x80>
801046fa:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
801046fc:	83 ec 0c             	sub    $0xc,%esp
801046ff:	50                   	push   %eax
80104700:	e8 1b cf ff ff       	call   80101620 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104705:	83 c4 0c             	add    $0xc,%esp
80104708:	6a 00                	push   $0x0
8010470a:	57                   	push   %edi
8010470b:	53                   	push   %ebx
8010470c:	e8 13 d4 ff ff       	call   80101b24 <dirlookup>
80104711:	89 c6                	mov    %eax,%esi
80104713:	83 c4 10             	add    $0x10,%esp
80104716:	85 c0                	test   %eax,%eax
80104718:	74 46                	je     80104760 <create+0x8c>
    iunlockput(dp);
8010471a:	83 ec 0c             	sub    $0xc,%esp
8010471d:	53                   	push   %ebx
8010471e:	e8 51 d1 ff ff       	call   80101874 <iunlockput>
    ilock(ip);
80104723:	89 34 24             	mov    %esi,(%esp)
80104726:	e8 f5 ce ff ff       	call   80101620 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010472b:	83 c4 10             	add    $0x10,%esp
8010472e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104733:	75 13                	jne    80104748 <create+0x74>
80104735:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010473a:	75 0c                	jne    80104748 <create+0x74>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010473c:	89 f0                	mov    %esi,%eax
8010473e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104741:	5b                   	pop    %ebx
80104742:	5e                   	pop    %esi
80104743:	5f                   	pop    %edi
80104744:	5d                   	pop    %ebp
80104745:	c3                   	ret
80104746:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	56                   	push   %esi
8010474c:	e8 23 d1 ff ff       	call   80101874 <iunlockput>
    return 0;
80104751:	83 c4 10             	add    $0x10,%esp
    return 0;
80104754:	31 f6                	xor    %esi,%esi
}
80104756:	89 f0                	mov    %esi,%eax
80104758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475b:	5b                   	pop    %ebx
8010475c:	5e                   	pop    %esi
8010475d:	5f                   	pop    %edi
8010475e:	5d                   	pop    %ebp
8010475f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104760:	83 ec 08             	sub    $0x8,%esp
80104763:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104767:	50                   	push   %eax
80104768:	ff 33                	push   (%ebx)
8010476a:	e8 59 cd ff ff       	call   801014c8 <ialloc>
8010476f:	89 c6                	mov    %eax,%esi
80104771:	83 c4 10             	add    $0x10,%esp
80104774:	85 c0                	test   %eax,%eax
80104776:	0f 84 a0 00 00 00    	je     8010481c <create+0x148>
  ilock(ip);
8010477c:	83 ec 0c             	sub    $0xc,%esp
8010477f:	50                   	push   %eax
80104780:	e8 9b ce ff ff       	call   80101620 <ilock>
  ip->major = major;
80104785:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104788:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010478c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010478f:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104793:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
80104799:	89 34 24             	mov    %esi,(%esp)
8010479c:	e8 d7 cd ff ff       	call   80101578 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801047a1:	83 c4 10             	add    $0x10,%esp
801047a4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801047a9:	74 29                	je     801047d4 <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
801047ab:	50                   	push   %eax
801047ac:	ff 76 04             	push   0x4(%esi)
801047af:	57                   	push   %edi
801047b0:	53                   	push   %ebx
801047b1:	e8 0e d6 ff ff       	call   80101dc4 <dirlink>
801047b6:	83 c4 10             	add    $0x10,%esp
801047b9:	85 c0                	test   %eax,%eax
801047bb:	78 6c                	js     80104829 <create+0x155>
  iunlockput(dp);
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	53                   	push   %ebx
801047c1:	e8 ae d0 ff ff       	call   80101874 <iunlockput>
  return ip;
801047c6:	83 c4 10             	add    $0x10,%esp
}
801047c9:	89 f0                	mov    %esi,%eax
801047cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ce:	5b                   	pop    %ebx
801047cf:	5e                   	pop    %esi
801047d0:	5f                   	pop    %edi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret
801047d3:	90                   	nop
    dp->nlink++;  // for ".."
801047d4:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
801047d8:	83 ec 0c             	sub    $0xc,%esp
801047db:	53                   	push   %ebx
801047dc:	e8 97 cd ff ff       	call   80101578 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047e1:	83 c4 0c             	add    $0xc,%esp
801047e4:	ff 76 04             	push   0x4(%esi)
801047e7:	68 e5 6e 10 80       	push   $0x80106ee5
801047ec:	56                   	push   %esi
801047ed:	e8 d2 d5 ff ff       	call   80101dc4 <dirlink>
801047f2:	83 c4 10             	add    $0x10,%esp
801047f5:	85 c0                	test   %eax,%eax
801047f7:	78 16                	js     8010480f <create+0x13b>
801047f9:	52                   	push   %edx
801047fa:	ff 73 04             	push   0x4(%ebx)
801047fd:	68 e4 6e 10 80       	push   $0x80106ee4
80104802:	56                   	push   %esi
80104803:	e8 bc d5 ff ff       	call   80101dc4 <dirlink>
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	85 c0                	test   %eax,%eax
8010480d:	79 9c                	jns    801047ab <create+0xd7>
      panic("create dots");
8010480f:	83 ec 0c             	sub    $0xc,%esp
80104812:	68 d8 6e 10 80       	push   $0x80106ed8
80104817:	e8 1c bb ff ff       	call   80100338 <panic>
    panic("create: ialloc");
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 c9 6e 10 80       	push   $0x80106ec9
80104824:	e8 0f bb ff ff       	call   80100338 <panic>
    panic("create: dirlink");
80104829:	83 ec 0c             	sub    $0xc,%esp
8010482c:	68 e7 6e 10 80       	push   $0x80106ee7
80104831:	e8 02 bb ff ff       	call   80100338 <panic>
80104836:	66 90                	xchg   %ax,%ax

80104838 <sys_dup>:
{
80104838:	55                   	push   %ebp
80104839:	89 e5                	mov    %esp,%ebp
8010483b:	56                   	push   %esi
8010483c:	53                   	push   %ebx
8010483d:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104840:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104843:	50                   	push   %eax
80104844:	6a 00                	push   $0x0
80104846:	e8 19 fd ff ff       	call   80104564 <argint>
8010484b:	83 c4 10             	add    $0x10,%esp
8010484e:	85 c0                	test   %eax,%eax
80104850:	78 2c                	js     8010487e <sys_dup+0x46>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104852:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104856:	77 26                	ja     8010487e <sys_dup+0x46>
80104858:	e8 9b ec ff ff       	call   801034f8 <myproc>
8010485d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104860:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
80104864:	85 f6                	test   %esi,%esi
80104866:	74 16                	je     8010487e <sys_dup+0x46>
  struct proc *curproc = myproc();
80104868:	e8 8b ec ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010486d:	31 db                	xor    %ebx,%ebx
8010486f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104870:	8b 54 98 50          	mov    0x50(%eax,%ebx,4),%edx
80104874:	85 d2                	test   %edx,%edx
80104876:	74 10                	je     80104888 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104878:	43                   	inc    %ebx
80104879:	83 fb 10             	cmp    $0x10,%ebx
8010487c:	75 f2                	jne    80104870 <sys_dup+0x38>
    return -1;
8010487e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104883:	eb 13                	jmp    80104898 <sys_dup+0x60>
80104885:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104888:	89 74 98 50          	mov    %esi,0x50(%eax,%ebx,4)
  filedup(f);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	56                   	push   %esi
80104890:	e8 73 c5 ff ff       	call   80100e08 <filedup>
  return fd;
80104895:	83 c4 10             	add    $0x10,%esp
}
80104898:	89 d8                	mov    %ebx,%eax
8010489a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010489d:	5b                   	pop    %ebx
8010489e:	5e                   	pop    %esi
8010489f:	5d                   	pop    %ebp
801048a0:	c3                   	ret
801048a1:	8d 76 00             	lea    0x0(%esi),%esi

801048a4 <sys_read>:
{
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
801048a9:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801048ac:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801048af:	53                   	push   %ebx
801048b0:	6a 00                	push   $0x0
801048b2:	e8 ad fc ff ff       	call   80104564 <argint>
801048b7:	83 c4 10             	add    $0x10,%esp
801048ba:	85 c0                	test   %eax,%eax
801048bc:	78 56                	js     80104914 <sys_read+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048be:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048c2:	77 50                	ja     80104914 <sys_read+0x70>
801048c4:	e8 2f ec ff ff       	call   801034f8 <myproc>
801048c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048cc:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
801048d0:	85 f6                	test   %esi,%esi
801048d2:	74 40                	je     80104914 <sys_read+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048d4:	83 ec 08             	sub    $0x8,%esp
801048d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048da:	50                   	push   %eax
801048db:	6a 02                	push   $0x2
801048dd:	e8 82 fc ff ff       	call   80104564 <argint>
801048e2:	83 c4 10             	add    $0x10,%esp
801048e5:	85 c0                	test   %eax,%eax
801048e7:	78 2b                	js     80104914 <sys_read+0x70>
801048e9:	52                   	push   %edx
801048ea:	ff 75 f0             	push   -0x10(%ebp)
801048ed:	53                   	push   %ebx
801048ee:	6a 01                	push   $0x1
801048f0:	e8 b3 fc ff ff       	call   801045a8 <argptr>
801048f5:	83 c4 10             	add    $0x10,%esp
801048f8:	85 c0                	test   %eax,%eax
801048fa:	78 18                	js     80104914 <sys_read+0x70>
  return fileread(f, p, n);
801048fc:	50                   	push   %eax
801048fd:	ff 75 f0             	push   -0x10(%ebp)
80104900:	ff 75 f4             	push   -0xc(%ebp)
80104903:	56                   	push   %esi
80104904:	e8 47 c6 ff ff       	call   80100f50 <fileread>
80104909:	83 c4 10             	add    $0x10,%esp
}
8010490c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010490f:	5b                   	pop    %ebx
80104910:	5e                   	pop    %esi
80104911:	5d                   	pop    %ebp
80104912:	c3                   	ret
80104913:	90                   	nop
    return -1;
80104914:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104919:	eb f1                	jmp    8010490c <sys_read+0x68>
8010491b:	90                   	nop

8010491c <sys_write>:
{
8010491c:	55                   	push   %ebp
8010491d:	89 e5                	mov    %esp,%ebp
8010491f:	56                   	push   %esi
80104920:	53                   	push   %ebx
80104921:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104924:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104927:	53                   	push   %ebx
80104928:	6a 00                	push   $0x0
8010492a:	e8 35 fc ff ff       	call   80104564 <argint>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	78 56                	js     8010498c <sys_write+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104936:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010493a:	77 50                	ja     8010498c <sys_write+0x70>
8010493c:	e8 b7 eb ff ff       	call   801034f8 <myproc>
80104941:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104944:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
80104948:	85 f6                	test   %esi,%esi
8010494a:	74 40                	je     8010498c <sys_write+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010494c:	83 ec 08             	sub    $0x8,%esp
8010494f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104952:	50                   	push   %eax
80104953:	6a 02                	push   $0x2
80104955:	e8 0a fc ff ff       	call   80104564 <argint>
8010495a:	83 c4 10             	add    $0x10,%esp
8010495d:	85 c0                	test   %eax,%eax
8010495f:	78 2b                	js     8010498c <sys_write+0x70>
80104961:	52                   	push   %edx
80104962:	ff 75 f0             	push   -0x10(%ebp)
80104965:	53                   	push   %ebx
80104966:	6a 01                	push   $0x1
80104968:	e8 3b fc ff ff       	call   801045a8 <argptr>
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	85 c0                	test   %eax,%eax
80104972:	78 18                	js     8010498c <sys_write+0x70>
  return filewrite(f, p, n);
80104974:	50                   	push   %eax
80104975:	ff 75 f0             	push   -0x10(%ebp)
80104978:	ff 75 f4             	push   -0xc(%ebp)
8010497b:	56                   	push   %esi
8010497c:	e8 5b c6 ff ff       	call   80100fdc <filewrite>
80104981:	83 c4 10             	add    $0x10,%esp
}
80104984:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104987:	5b                   	pop    %ebx
80104988:	5e                   	pop    %esi
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret
8010498b:	90                   	nop
    return -1;
8010498c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104991:	eb f1                	jmp    80104984 <sys_write+0x68>
80104993:	90                   	nop

80104994 <sys_close>:
{
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	56                   	push   %esi
80104998:	53                   	push   %ebx
80104999:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010499c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499f:	50                   	push   %eax
801049a0:	6a 00                	push   $0x0
801049a2:	e8 bd fb ff ff       	call   80104564 <argint>
801049a7:	83 c4 10             	add    $0x10,%esp
801049aa:	85 c0                	test   %eax,%eax
801049ac:	78 3a                	js     801049e8 <sys_close+0x54>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049b2:	77 34                	ja     801049e8 <sys_close+0x54>
801049b4:	e8 3f eb ff ff       	call   801034f8 <myproc>
801049b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049bc:	8d 5a 14             	lea    0x14(%edx),%ebx
801049bf:	8b 34 98             	mov    (%eax,%ebx,4),%esi
801049c2:	85 f6                	test   %esi,%esi
801049c4:	74 22                	je     801049e8 <sys_close+0x54>
  myproc()->ofile[fd] = 0;
801049c6:	e8 2d eb ff ff       	call   801034f8 <myproc>
801049cb:	c7 04 98 00 00 00 00 	movl   $0x0,(%eax,%ebx,4)
  fileclose(f);
801049d2:	83 ec 0c             	sub    $0xc,%esp
801049d5:	56                   	push   %esi
801049d6:	e8 71 c4 ff ff       	call   80100e4c <fileclose>
  return 0;
801049db:	83 c4 10             	add    $0x10,%esp
801049de:	31 c0                	xor    %eax,%eax
}
801049e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049e3:	5b                   	pop    %ebx
801049e4:	5e                   	pop    %esi
801049e5:	5d                   	pop    %ebp
801049e6:	c3                   	ret
801049e7:	90                   	nop
    return -1;
801049e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ed:	eb f1                	jmp    801049e0 <sys_close+0x4c>
801049ef:	90                   	nop

801049f0 <sys_fstat>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801049f8:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801049fb:	53                   	push   %ebx
801049fc:	6a 00                	push   $0x0
801049fe:	e8 61 fb ff ff       	call   80104564 <argint>
80104a03:	83 c4 10             	add    $0x10,%esp
80104a06:	85 c0                	test   %eax,%eax
80104a08:	78 3e                	js     80104a48 <sys_fstat+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a0e:	77 38                	ja     80104a48 <sys_fstat+0x58>
80104a10:	e8 e3 ea ff ff       	call   801034f8 <myproc>
80104a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a18:	8b 74 90 50          	mov    0x50(%eax,%edx,4),%esi
80104a1c:	85 f6                	test   %esi,%esi
80104a1e:	74 28                	je     80104a48 <sys_fstat+0x58>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a20:	50                   	push   %eax
80104a21:	6a 14                	push   $0x14
80104a23:	53                   	push   %ebx
80104a24:	6a 01                	push   $0x1
80104a26:	e8 7d fb ff ff       	call   801045a8 <argptr>
80104a2b:	83 c4 10             	add    $0x10,%esp
80104a2e:	85 c0                	test   %eax,%eax
80104a30:	78 16                	js     80104a48 <sys_fstat+0x58>
  return filestat(f, st);
80104a32:	83 ec 08             	sub    $0x8,%esp
80104a35:	ff 75 f4             	push   -0xc(%ebp)
80104a38:	56                   	push   %esi
80104a39:	e8 ce c4 ff ff       	call   80100f0c <filestat>
80104a3e:	83 c4 10             	add    $0x10,%esp
}
80104a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a44:	5b                   	pop    %ebx
80104a45:	5e                   	pop    %esi
80104a46:	5d                   	pop    %ebp
80104a47:	c3                   	ret
    return -1;
80104a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4d:	eb f2                	jmp    80104a41 <sys_fstat+0x51>
80104a4f:	90                   	nop

80104a50 <sys_link>:
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	56                   	push   %esi
80104a55:	53                   	push   %ebx
80104a56:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a5c:	50                   	push   %eax
80104a5d:	6a 00                	push   $0x0
80104a5f:	e8 ac fb ff ff       	call   80104610 <argstr>
80104a64:	83 c4 10             	add    $0x10,%esp
80104a67:	85 c0                	test   %eax,%eax
80104a69:	0f 88 f2 00 00 00    	js     80104b61 <sys_link+0x111>
80104a6f:	83 ec 08             	sub    $0x8,%esp
80104a72:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a75:	50                   	push   %eax
80104a76:	6a 01                	push   $0x1
80104a78:	e8 93 fb ff ff       	call   80104610 <argstr>
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	85 c0                	test   %eax,%eax
80104a82:	0f 88 d9 00 00 00    	js     80104b61 <sys_link+0x111>
  begin_op();
80104a88:	e8 2f df ff ff       	call   801029bc <begin_op>
  if((ip = namei(old)) == 0){
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	ff 75 d4             	push   -0x2c(%ebp)
80104a93:	e8 dc d3 ff ff       	call   80101e74 <namei>
80104a98:	89 c3                	mov    %eax,%ebx
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	85 c0                	test   %eax,%eax
80104a9f:	0f 84 d6 00 00 00    	je     80104b7b <sys_link+0x12b>
  ilock(ip);
80104aa5:	83 ec 0c             	sub    $0xc,%esp
80104aa8:	50                   	push   %eax
80104aa9:	e8 72 cb ff ff       	call   80101620 <ilock>
  if(ip->type == T_DIR){
80104aae:	83 c4 10             	add    $0x10,%esp
80104ab1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ab6:	0f 84 ac 00 00 00    	je     80104b68 <sys_link+0x118>
  ip->nlink++;
80104abc:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104ac0:	83 ec 0c             	sub    $0xc,%esp
80104ac3:	53                   	push   %ebx
80104ac4:	e8 af ca ff ff       	call   80101578 <iupdate>
  iunlock(ip);
80104ac9:	89 1c 24             	mov    %ebx,(%esp)
80104acc:	e8 17 cc ff ff       	call   801016e8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ad1:	5a                   	pop    %edx
80104ad2:	59                   	pop    %ecx
80104ad3:	8d 7d da             	lea    -0x26(%ebp),%edi
80104ad6:	57                   	push   %edi
80104ad7:	ff 75 d0             	push   -0x30(%ebp)
80104ada:	e8 ad d3 ff ff       	call   80101e8c <nameiparent>
80104adf:	89 c6                	mov    %eax,%esi
80104ae1:	83 c4 10             	add    $0x10,%esp
80104ae4:	85 c0                	test   %eax,%eax
80104ae6:	74 54                	je     80104b3c <sys_link+0xec>
  ilock(dp);
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	50                   	push   %eax
80104aec:	e8 2f cb ff ff       	call   80101620 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	8b 03                	mov    (%ebx),%eax
80104af6:	39 06                	cmp    %eax,(%esi)
80104af8:	75 36                	jne    80104b30 <sys_link+0xe0>
80104afa:	50                   	push   %eax
80104afb:	ff 73 04             	push   0x4(%ebx)
80104afe:	57                   	push   %edi
80104aff:	56                   	push   %esi
80104b00:	e8 bf d2 ff ff       	call   80101dc4 <dirlink>
80104b05:	83 c4 10             	add    $0x10,%esp
80104b08:	85 c0                	test   %eax,%eax
80104b0a:	78 24                	js     80104b30 <sys_link+0xe0>
  iunlockput(dp);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	56                   	push   %esi
80104b10:	e8 5f cd ff ff       	call   80101874 <iunlockput>
  iput(ip);
80104b15:	89 1c 24             	mov    %ebx,(%esp)
80104b18:	e8 0f cc ff ff       	call   8010172c <iput>
  end_op();
80104b1d:	e8 02 df ff ff       	call   80102a24 <end_op>
  return 0;
80104b22:	83 c4 10             	add    $0x10,%esp
80104b25:	31 c0                	xor    %eax,%eax
}
80104b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b2a:	5b                   	pop    %ebx
80104b2b:	5e                   	pop    %esi
80104b2c:	5f                   	pop    %edi
80104b2d:	5d                   	pop    %ebp
80104b2e:	c3                   	ret
80104b2f:	90                   	nop
    iunlockput(dp);
80104b30:	83 ec 0c             	sub    $0xc,%esp
80104b33:	56                   	push   %esi
80104b34:	e8 3b cd ff ff       	call   80101874 <iunlockput>
    goto bad;
80104b39:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	53                   	push   %ebx
80104b40:	e8 db ca ff ff       	call   80101620 <ilock>
  ip->nlink--;
80104b45:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104b49:	89 1c 24             	mov    %ebx,(%esp)
80104b4c:	e8 27 ca ff ff       	call   80101578 <iupdate>
  iunlockput(ip);
80104b51:	89 1c 24             	mov    %ebx,(%esp)
80104b54:	e8 1b cd ff ff       	call   80101874 <iunlockput>
  end_op();
80104b59:	e8 c6 de ff ff       	call   80102a24 <end_op>
  return -1;
80104b5e:	83 c4 10             	add    $0x10,%esp
    return -1;
80104b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b66:	eb bf                	jmp    80104b27 <sys_link+0xd7>
    iunlockput(ip);
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	53                   	push   %ebx
80104b6c:	e8 03 cd ff ff       	call   80101874 <iunlockput>
    end_op();
80104b71:	e8 ae de ff ff       	call   80102a24 <end_op>
    return -1;
80104b76:	83 c4 10             	add    $0x10,%esp
80104b79:	eb e6                	jmp    80104b61 <sys_link+0x111>
    end_op();
80104b7b:	e8 a4 de ff ff       	call   80102a24 <end_op>
    return -1;
80104b80:	eb df                	jmp    80104b61 <sys_link+0x111>
80104b82:	66 90                	xchg   %ax,%ax

80104b84 <sys_unlink>:
{
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	57                   	push   %edi
80104b88:	56                   	push   %esi
80104b89:	53                   	push   %ebx
80104b8a:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104b8d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b90:	50                   	push   %eax
80104b91:	6a 00                	push   $0x0
80104b93:	e8 78 fa ff ff       	call   80104610 <argstr>
80104b98:	83 c4 10             	add    $0x10,%esp
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	0f 88 50 01 00 00    	js     80104cf3 <sys_unlink+0x16f>
  begin_op();
80104ba3:	e8 14 de ff ff       	call   801029bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ba8:	83 ec 08             	sub    $0x8,%esp
80104bab:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104bae:	53                   	push   %ebx
80104baf:	ff 75 c0             	push   -0x40(%ebp)
80104bb2:	e8 d5 d2 ff ff       	call   80101e8c <nameiparent>
80104bb7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bba:	83 c4 10             	add    $0x10,%esp
80104bbd:	85 c0                	test   %eax,%eax
80104bbf:	0f 84 4f 01 00 00    	je     80104d14 <sys_unlink+0x190>
  ilock(dp);
80104bc5:	83 ec 0c             	sub    $0xc,%esp
80104bc8:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80104bcb:	57                   	push   %edi
80104bcc:	e8 4f ca ff ff       	call   80101620 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bd1:	59                   	pop    %ecx
80104bd2:	5e                   	pop    %esi
80104bd3:	68 e5 6e 10 80       	push   $0x80106ee5
80104bd8:	53                   	push   %ebx
80104bd9:	e8 2e cf ff ff       	call   80101b0c <namecmp>
80104bde:	83 c4 10             	add    $0x10,%esp
80104be1:	85 c0                	test   %eax,%eax
80104be3:	0f 84 f7 00 00 00    	je     80104ce0 <sys_unlink+0x15c>
80104be9:	83 ec 08             	sub    $0x8,%esp
80104bec:	68 e4 6e 10 80       	push   $0x80106ee4
80104bf1:	53                   	push   %ebx
80104bf2:	e8 15 cf ff ff       	call   80101b0c <namecmp>
80104bf7:	83 c4 10             	add    $0x10,%esp
80104bfa:	85 c0                	test   %eax,%eax
80104bfc:	0f 84 de 00 00 00    	je     80104ce0 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c02:	52                   	push   %edx
80104c03:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c06:	50                   	push   %eax
80104c07:	53                   	push   %ebx
80104c08:	57                   	push   %edi
80104c09:	e8 16 cf ff ff       	call   80101b24 <dirlookup>
80104c0e:	89 c3                	mov    %eax,%ebx
80104c10:	83 c4 10             	add    $0x10,%esp
80104c13:	85 c0                	test   %eax,%eax
80104c15:	0f 84 c5 00 00 00    	je     80104ce0 <sys_unlink+0x15c>
  ilock(ip);
80104c1b:	83 ec 0c             	sub    $0xc,%esp
80104c1e:	50                   	push   %eax
80104c1f:	e8 fc c9 ff ff       	call   80101620 <ilock>
  if(ip->nlink < 1)
80104c24:	83 c4 10             	add    $0x10,%esp
80104c27:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c2c:	0f 8e f6 00 00 00    	jle    80104d28 <sys_unlink+0x1a4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c32:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c37:	74 67                	je     80104ca0 <sys_unlink+0x11c>
80104c39:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
80104c3c:	50                   	push   %eax
80104c3d:	6a 10                	push   $0x10
80104c3f:	6a 00                	push   $0x0
80104c41:	57                   	push   %edi
80104c42:	e8 f9 f6 ff ff       	call   80104340 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c47:	6a 10                	push   $0x10
80104c49:	ff 75 c4             	push   -0x3c(%ebp)
80104c4c:	57                   	push   %edi
80104c4d:	ff 75 b4             	push   -0x4c(%ebp)
80104c50:	e8 9b cd ff ff       	call   801019f0 <writei>
80104c55:	83 c4 20             	add    $0x20,%esp
80104c58:	83 f8 10             	cmp    $0x10,%eax
80104c5b:	0f 85 d4 00 00 00    	jne    80104d35 <sys_unlink+0x1b1>
  if(ip->type == T_DIR){
80104c61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c66:	0f 84 90 00 00 00    	je     80104cfc <sys_unlink+0x178>
  iunlockput(dp);
80104c6c:	83 ec 0c             	sub    $0xc,%esp
80104c6f:	ff 75 b4             	push   -0x4c(%ebp)
80104c72:	e8 fd cb ff ff       	call   80101874 <iunlockput>
  ip->nlink--;
80104c77:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104c7b:	89 1c 24             	mov    %ebx,(%esp)
80104c7e:	e8 f5 c8 ff ff       	call   80101578 <iupdate>
  iunlockput(ip);
80104c83:	89 1c 24             	mov    %ebx,(%esp)
80104c86:	e8 e9 cb ff ff       	call   80101874 <iunlockput>
  end_op();
80104c8b:	e8 94 dd ff ff       	call   80102a24 <end_op>
  return 0;
80104c90:	83 c4 10             	add    $0x10,%esp
80104c93:	31 c0                	xor    %eax,%eax
}
80104c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c98:	5b                   	pop    %ebx
80104c99:	5e                   	pop    %esi
80104c9a:	5f                   	pop    %edi
80104c9b:	5d                   	pop    %ebp
80104c9c:	c3                   	ret
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ca0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104ca4:	76 93                	jbe    80104c39 <sys_unlink+0xb5>
80104ca6:	be 20 00 00 00       	mov    $0x20,%esi
80104cab:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104cae:	eb 08                	jmp    80104cb8 <sys_unlink+0x134>
80104cb0:	83 c6 10             	add    $0x10,%esi
80104cb3:	3b 73 58             	cmp    0x58(%ebx),%esi
80104cb6:	73 84                	jae    80104c3c <sys_unlink+0xb8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cb8:	6a 10                	push   $0x10
80104cba:	56                   	push   %esi
80104cbb:	57                   	push   %edi
80104cbc:	53                   	push   %ebx
80104cbd:	e8 2e cc ff ff       	call   801018f0 <readi>
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	83 f8 10             	cmp    $0x10,%eax
80104cc8:	75 51                	jne    80104d1b <sys_unlink+0x197>
    if(de.inum != 0)
80104cca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ccf:	74 df                	je     80104cb0 <sys_unlink+0x12c>
    iunlockput(ip);
80104cd1:	83 ec 0c             	sub    $0xc,%esp
80104cd4:	53                   	push   %ebx
80104cd5:	e8 9a cb ff ff       	call   80101874 <iunlockput>
    goto bad;
80104cda:	83 c4 10             	add    $0x10,%esp
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80104ce0:	83 ec 0c             	sub    $0xc,%esp
80104ce3:	ff 75 b4             	push   -0x4c(%ebp)
80104ce6:	e8 89 cb ff ff       	call   80101874 <iunlockput>
  end_op();
80104ceb:	e8 34 dd ff ff       	call   80102a24 <end_op>
  return -1;
80104cf0:	83 c4 10             	add    $0x10,%esp
    return -1;
80104cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf8:	eb 9b                	jmp    80104c95 <sys_unlink+0x111>
80104cfa:	66 90                	xchg   %ax,%ax
    dp->nlink--;
80104cfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cff:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
80104d03:	83 ec 0c             	sub    $0xc,%esp
80104d06:	50                   	push   %eax
80104d07:	e8 6c c8 ff ff       	call   80101578 <iupdate>
80104d0c:	83 c4 10             	add    $0x10,%esp
80104d0f:	e9 58 ff ff ff       	jmp    80104c6c <sys_unlink+0xe8>
    end_op();
80104d14:	e8 0b dd ff ff       	call   80102a24 <end_op>
    return -1;
80104d19:	eb d8                	jmp    80104cf3 <sys_unlink+0x16f>
      panic("isdirempty: readi");
80104d1b:	83 ec 0c             	sub    $0xc,%esp
80104d1e:	68 09 6f 10 80       	push   $0x80106f09
80104d23:	e8 10 b6 ff ff       	call   80100338 <panic>
    panic("unlink: nlink < 1");
80104d28:	83 ec 0c             	sub    $0xc,%esp
80104d2b:	68 f7 6e 10 80       	push   $0x80106ef7
80104d30:	e8 03 b6 ff ff       	call   80100338 <panic>
    panic("unlink: writei");
80104d35:	83 ec 0c             	sub    $0xc,%esp
80104d38:	68 1b 6f 10 80       	push   $0x80106f1b
80104d3d:	e8 f6 b5 ff ff       	call   80100338 <panic>
80104d42:	66 90                	xchg   %ax,%ax

80104d44 <sys_open>:

int
sys_open(void)
{
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	57                   	push   %edi
80104d48:	56                   	push   %esi
80104d49:	53                   	push   %ebx
80104d4a:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d4d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d50:	50                   	push   %eax
80104d51:	6a 00                	push   $0x0
80104d53:	e8 b8 f8 ff ff       	call   80104610 <argstr>
80104d58:	83 c4 10             	add    $0x10,%esp
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	0f 88 8c 00 00 00    	js     80104def <sys_open+0xab>
80104d63:	83 ec 08             	sub    $0x8,%esp
80104d66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d69:	50                   	push   %eax
80104d6a:	6a 01                	push   $0x1
80104d6c:	e8 f3 f7 ff ff       	call   80104564 <argint>
80104d71:	83 c4 10             	add    $0x10,%esp
80104d74:	85 c0                	test   %eax,%eax
80104d76:	78 77                	js     80104def <sys_open+0xab>
    return -1;

  begin_op();
80104d78:	e8 3f dc ff ff       	call   801029bc <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
80104d80:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104d84:	75 72                	jne    80104df8 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104d86:	83 ec 0c             	sub    $0xc,%esp
80104d89:	50                   	push   %eax
80104d8a:	e8 e5 d0 ff ff       	call   80101e74 <namei>
80104d8f:	89 c6                	mov    %eax,%esi
80104d91:	83 c4 10             	add    $0x10,%esp
80104d94:	85 c0                	test   %eax,%eax
80104d96:	74 7a                	je     80104e12 <sys_open+0xce>
      end_op();
      return -1;
    }
    ilock(ip);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	50                   	push   %eax
80104d9c:	e8 7f c8 ff ff       	call   80101620 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104da1:	83 c4 10             	add    $0x10,%esp
80104da4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104da9:	0f 84 b1 00 00 00    	je     80104e60 <sys_open+0x11c>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104daf:	e8 ec bf ff ff       	call   80100da0 <filealloc>
80104db4:	89 c7                	mov    %eax,%edi
80104db6:	85 c0                	test   %eax,%eax
80104db8:	74 24                	je     80104dde <sys_open+0x9a>
  struct proc *curproc = myproc();
80104dba:	e8 39 e7 ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104dbf:	31 db                	xor    %ebx,%ebx
80104dc1:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104dc4:	8b 54 98 50          	mov    0x50(%eax,%ebx,4),%edx
80104dc8:	85 d2                	test   %edx,%edx
80104dca:	74 50                	je     80104e1c <sys_open+0xd8>
  for(fd = 0; fd < NOFILE; fd++){
80104dcc:	43                   	inc    %ebx
80104dcd:	83 fb 10             	cmp    $0x10,%ebx
80104dd0:	75 f2                	jne    80104dc4 <sys_open+0x80>
    if(f)
      fileclose(f);
80104dd2:	83 ec 0c             	sub    $0xc,%esp
80104dd5:	57                   	push   %edi
80104dd6:	e8 71 c0 ff ff       	call   80100e4c <fileclose>
80104ddb:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104dde:	83 ec 0c             	sub    $0xc,%esp
80104de1:	56                   	push   %esi
80104de2:	e8 8d ca ff ff       	call   80101874 <iunlockput>
    end_op();
80104de7:	e8 38 dc ff ff       	call   80102a24 <end_op>
    return -1;
80104dec:	83 c4 10             	add    $0x10,%esp
    return -1;
80104def:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104df4:	eb 5f                	jmp    80104e55 <sys_open+0x111>
80104df6:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104df8:	83 ec 0c             	sub    $0xc,%esp
80104dfb:	6a 00                	push   $0x0
80104dfd:	31 c9                	xor    %ecx,%ecx
80104dff:	ba 02 00 00 00       	mov    $0x2,%edx
80104e04:	e8 cb f8 ff ff       	call   801046d4 <create>
80104e09:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e0b:	83 c4 10             	add    $0x10,%esp
80104e0e:	85 c0                	test   %eax,%eax
80104e10:	75 9d                	jne    80104daf <sys_open+0x6b>
      end_op();
80104e12:	e8 0d dc ff ff       	call   80102a24 <end_op>
      return -1;
80104e17:	eb d6                	jmp    80104def <sys_open+0xab>
80104e19:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e1c:	89 7c 98 50          	mov    %edi,0x50(%eax,%ebx,4)
  }
  iunlock(ip);
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	56                   	push   %esi
80104e24:	e8 bf c8 ff ff       	call   801016e8 <iunlock>
  end_op();
80104e29:	e8 f6 db ff ff       	call   80102a24 <end_op>

  f->type = FD_INODE;
80104e2e:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
80104e34:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80104e37:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104e3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e41:	89 d0                	mov    %edx,%eax
80104e43:	f7 d0                	not    %eax
80104e45:	83 e0 01             	and    $0x1,%eax
80104e48:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e4b:	83 c4 10             	add    $0x10,%esp
80104e4e:	83 e2 03             	and    $0x3,%edx
80104e51:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80104e55:	89 d8                	mov    %ebx,%eax
80104e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e5a:	5b                   	pop    %ebx
80104e5b:	5e                   	pop    %esi
80104e5c:	5f                   	pop    %edi
80104e5d:	5d                   	pop    %ebp
80104e5e:	c3                   	ret
80104e5f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104e63:	85 c9                	test   %ecx,%ecx
80104e65:	0f 84 44 ff ff ff    	je     80104daf <sys_open+0x6b>
80104e6b:	e9 6e ff ff ff       	jmp    80104dde <sys_open+0x9a>

80104e70 <sys_mkdir>:

int
sys_mkdir(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104e76:	e8 41 db ff ff       	call   801029bc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104e7b:	83 ec 08             	sub    $0x8,%esp
80104e7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e81:	50                   	push   %eax
80104e82:	6a 00                	push   $0x0
80104e84:	e8 87 f7 ff ff       	call   80104610 <argstr>
80104e89:	83 c4 10             	add    $0x10,%esp
80104e8c:	85 c0                	test   %eax,%eax
80104e8e:	78 30                	js     80104ec0 <sys_mkdir+0x50>
80104e90:	83 ec 0c             	sub    $0xc,%esp
80104e93:	6a 00                	push   $0x0
80104e95:	31 c9                	xor    %ecx,%ecx
80104e97:	ba 01 00 00 00       	mov    $0x1,%edx
80104e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9f:	e8 30 f8 ff ff       	call   801046d4 <create>
80104ea4:	83 c4 10             	add    $0x10,%esp
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	74 15                	je     80104ec0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104eab:	83 ec 0c             	sub    $0xc,%esp
80104eae:	50                   	push   %eax
80104eaf:	e8 c0 c9 ff ff       	call   80101874 <iunlockput>
  end_op();
80104eb4:	e8 6b db ff ff       	call   80102a24 <end_op>
  return 0;
80104eb9:	83 c4 10             	add    $0x10,%esp
80104ebc:	31 c0                	xor    %eax,%eax
}
80104ebe:	c9                   	leave
80104ebf:	c3                   	ret
    end_op();
80104ec0:	e8 5f db ff ff       	call   80102a24 <end_op>
    return -1;
80104ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eca:	c9                   	leave
80104ecb:	c3                   	ret

80104ecc <sys_mknod>:

int
sys_mknod(void)
{
80104ecc:	55                   	push   %ebp
80104ecd:	89 e5                	mov    %esp,%ebp
80104ecf:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104ed2:	e8 e5 da ff ff       	call   801029bc <begin_op>
  if((argstr(0, &path)) < 0 ||
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104edd:	50                   	push   %eax
80104ede:	6a 00                	push   $0x0
80104ee0:	e8 2b f7 ff ff       	call   80104610 <argstr>
80104ee5:	83 c4 10             	add    $0x10,%esp
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	78 60                	js     80104f4c <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104eec:	83 ec 08             	sub    $0x8,%esp
80104eef:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef2:	50                   	push   %eax
80104ef3:	6a 01                	push   $0x1
80104ef5:	e8 6a f6 ff ff       	call   80104564 <argint>
  if((argstr(0, &path)) < 0 ||
80104efa:	83 c4 10             	add    $0x10,%esp
80104efd:	85 c0                	test   %eax,%eax
80104eff:	78 4b                	js     80104f4c <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f01:	83 ec 08             	sub    $0x8,%esp
80104f04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f07:	50                   	push   %eax
80104f08:	6a 02                	push   $0x2
80104f0a:	e8 55 f6 ff ff       	call   80104564 <argint>
     argint(1, &major) < 0 ||
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	78 36                	js     80104f4c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f16:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104f21:	50                   	push   %eax
80104f22:	ba 03 00 00 00       	mov    $0x3,%edx
80104f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f2a:	e8 a5 f7 ff ff       	call   801046d4 <create>
     argint(2, &minor) < 0 ||
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	74 16                	je     80104f4c <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f36:	83 ec 0c             	sub    $0xc,%esp
80104f39:	50                   	push   %eax
80104f3a:	e8 35 c9 ff ff       	call   80101874 <iunlockput>
  end_op();
80104f3f:	e8 e0 da ff ff       	call   80102a24 <end_op>
  return 0;
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	31 c0                	xor    %eax,%eax
}
80104f49:	c9                   	leave
80104f4a:	c3                   	ret
80104f4b:	90                   	nop
    end_op();
80104f4c:	e8 d3 da ff ff       	call   80102a24 <end_op>
    return -1;
80104f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f56:	c9                   	leave
80104f57:	c3                   	ret

80104f58 <sys_chdir>:

int
sys_chdir(void)
{
80104f58:	55                   	push   %ebp
80104f59:	89 e5                	mov    %esp,%ebp
80104f5b:	56                   	push   %esi
80104f5c:	53                   	push   %ebx
80104f5d:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104f60:	e8 93 e5 ff ff       	call   801034f8 <myproc>
80104f65:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104f67:	e8 50 da ff ff       	call   801029bc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104f6c:	83 ec 08             	sub    $0x8,%esp
80104f6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f72:	50                   	push   %eax
80104f73:	6a 00                	push   $0x0
80104f75:	e8 96 f6 ff ff       	call   80104610 <argstr>
80104f7a:	83 c4 10             	add    $0x10,%esp
80104f7d:	85 c0                	test   %eax,%eax
80104f7f:	78 6b                	js     80104fec <sys_chdir+0x94>
80104f81:	83 ec 0c             	sub    $0xc,%esp
80104f84:	ff 75 f4             	push   -0xc(%ebp)
80104f87:	e8 e8 ce ff ff       	call   80101e74 <namei>
80104f8c:	89 c3                	mov    %eax,%ebx
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	85 c0                	test   %eax,%eax
80104f93:	74 57                	je     80104fec <sys_chdir+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	50                   	push   %eax
80104f99:	e8 82 c6 ff ff       	call   80101620 <ilock>
  if(ip->type != T_DIR){
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fa6:	75 2c                	jne    80104fd4 <sys_chdir+0x7c>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	53                   	push   %ebx
80104fac:	e8 37 c7 ff ff       	call   801016e8 <iunlock>
  iput(curproc->cwd);
80104fb1:	58                   	pop    %eax
80104fb2:	ff b6 90 00 00 00    	push   0x90(%esi)
80104fb8:	e8 6f c7 ff ff       	call   8010172c <iput>
  end_op();
80104fbd:	e8 62 da ff ff       	call   80102a24 <end_op>
  curproc->cwd = ip;
80104fc2:	89 9e 90 00 00 00    	mov    %ebx,0x90(%esi)
  return 0;
80104fc8:	83 c4 10             	add    $0x10,%esp
80104fcb:	31 c0                	xor    %eax,%eax
}
80104fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd0:	5b                   	pop    %ebx
80104fd1:	5e                   	pop    %esi
80104fd2:	5d                   	pop    %ebp
80104fd3:	c3                   	ret
    iunlockput(ip);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	53                   	push   %ebx
80104fd8:	e8 97 c8 ff ff       	call   80101874 <iunlockput>
    end_op();
80104fdd:	e8 42 da ff ff       	call   80102a24 <end_op>
    return -1;
80104fe2:	83 c4 10             	add    $0x10,%esp
    return -1;
80104fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fea:	eb e1                	jmp    80104fcd <sys_chdir+0x75>
    end_op();
80104fec:	e8 33 da ff ff       	call   80102a24 <end_op>
    return -1;
80104ff1:	eb f2                	jmp    80104fe5 <sys_chdir+0x8d>
80104ff3:	90                   	nop

80104ff4 <sys_exec>:

int
sys_exec(void)
{
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	57                   	push   %edi
80104ff8:	56                   	push   %esi
80104ff9:	53                   	push   %ebx
80104ffa:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105000:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105006:	50                   	push   %eax
80105007:	6a 00                	push   $0x0
80105009:	e8 02 f6 ff ff       	call   80104610 <argstr>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	85 c0                	test   %eax,%eax
80105013:	78 79                	js     8010508e <sys_exec+0x9a>
80105015:	83 ec 08             	sub    $0x8,%esp
80105018:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010501e:	50                   	push   %eax
8010501f:	6a 01                	push   $0x1
80105021:	e8 3e f5 ff ff       	call   80104564 <argint>
80105026:	83 c4 10             	add    $0x10,%esp
80105029:	85 c0                	test   %eax,%eax
8010502b:	78 61                	js     8010508e <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010502d:	50                   	push   %eax
8010502e:	68 80 00 00 00       	push   $0x80
80105033:	6a 00                	push   $0x0
80105035:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
8010503b:	57                   	push   %edi
8010503c:	e8 ff f2 ff ff       	call   80104340 <memset>
80105041:	83 c4 10             	add    $0x10,%esp
80105044:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
80105046:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105048:	83 ec 08             	sub    $0x8,%esp
8010504b:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105051:	50                   	push   %eax
80105052:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105058:	01 d8                	add    %ebx,%eax
8010505a:	50                   	push   %eax
8010505b:	e8 8c f4 ff ff       	call   801044ec <fetchint>
80105060:	83 c4 10             	add    $0x10,%esp
80105063:	85 c0                	test   %eax,%eax
80105065:	78 27                	js     8010508e <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
80105067:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010506d:	85 c0                	test   %eax,%eax
8010506f:	74 2b                	je     8010509c <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105071:	83 ec 08             	sub    $0x8,%esp
80105074:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80105077:	52                   	push   %edx
80105078:	50                   	push   %eax
80105079:	e8 a2 f4 ff ff       	call   80104520 <fetchstr>
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	85 c0                	test   %eax,%eax
80105083:	78 09                	js     8010508e <sys_exec+0x9a>
  for(i=0;; i++){
80105085:	46                   	inc    %esi
    if(i >= NELEM(argv))
80105086:	83 c3 04             	add    $0x4,%ebx
80105089:	83 fe 20             	cmp    $0x20,%esi
8010508c:	75 ba                	jne    80105048 <sys_exec+0x54>
    return -1;
8010508e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80105093:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105096:	5b                   	pop    %ebx
80105097:	5e                   	pop    %esi
80105098:	5f                   	pop    %edi
80105099:	5d                   	pop    %ebp
8010509a:	c3                   	ret
8010509b:	90                   	nop
      argv[i] = 0;
8010509c:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
801050a3:	00 00 00 00 
  return exec(path, argv);
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	57                   	push   %edi
801050ab:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801050b1:	e8 6e b9 ff ff       	call   80100a24 <exec>
801050b6:	83 c4 10             	add    $0x10,%esp
}
801050b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050bc:	5b                   	pop    %ebx
801050bd:	5e                   	pop    %esi
801050be:	5f                   	pop    %edi
801050bf:	5d                   	pop    %ebp
801050c0:	c3                   	ret
801050c1:	8d 76 00             	lea    0x0(%esi),%esi

801050c4 <sys_pipe>:

int
sys_pipe(void)
{
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	57                   	push   %edi
801050c8:	56                   	push   %esi
801050c9:	53                   	push   %ebx
801050ca:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801050cd:	6a 08                	push   $0x8
801050cf:	8d 45 dc             	lea    -0x24(%ebp),%eax
801050d2:	50                   	push   %eax
801050d3:	6a 00                	push   $0x0
801050d5:	e8 ce f4 ff ff       	call   801045a8 <argptr>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	78 7c                	js     8010515d <sys_pipe+0x99>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801050e1:	83 ec 08             	sub    $0x8,%esp
801050e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050e7:	50                   	push   %eax
801050e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801050eb:	50                   	push   %eax
801050ec:	e8 db de ff ff       	call   80102fcc <pipealloc>
801050f1:	83 c4 10             	add    $0x10,%esp
801050f4:	85 c0                	test   %eax,%eax
801050f6:	78 65                	js     8010515d <sys_pipe+0x99>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801050f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
801050fb:	e8 f8 e3 ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105100:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105102:	8b 74 98 50          	mov    0x50(%eax,%ebx,4),%esi
80105106:	85 f6                	test   %esi,%esi
80105108:	74 10                	je     8010511a <sys_pipe+0x56>
8010510a:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
8010510c:	43                   	inc    %ebx
8010510d:	83 fb 10             	cmp    $0x10,%ebx
80105110:	74 34                	je     80105146 <sys_pipe+0x82>
    if(curproc->ofile[fd] == 0){
80105112:	8b 74 98 50          	mov    0x50(%eax,%ebx,4),%esi
80105116:	85 f6                	test   %esi,%esi
80105118:	75 f2                	jne    8010510c <sys_pipe+0x48>
      curproc->ofile[fd] = f;
8010511a:	8d 73 14             	lea    0x14(%ebx),%esi
8010511d:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105120:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105123:	e8 d0 e3 ff ff       	call   801034f8 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105128:	31 d2                	xor    %edx,%edx
8010512a:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
8010512c:	8b 4c 90 50          	mov    0x50(%eax,%edx,4),%ecx
80105130:	85 c9                	test   %ecx,%ecx
80105132:	74 30                	je     80105164 <sys_pipe+0xa0>
  for(fd = 0; fd < NOFILE; fd++){
80105134:	42                   	inc    %edx
80105135:	83 fa 10             	cmp    $0x10,%edx
80105138:	75 f2                	jne    8010512c <sys_pipe+0x68>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
8010513a:	e8 b9 e3 ff ff       	call   801034f8 <myproc>
8010513f:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
    fileclose(rf);
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	ff 75 e0             	push   -0x20(%ebp)
8010514c:	e8 fb bc ff ff       	call   80100e4c <fileclose>
    fileclose(wf);
80105151:	58                   	pop    %eax
80105152:	ff 75 e4             	push   -0x1c(%ebp)
80105155:	e8 f2 bc ff ff       	call   80100e4c <fileclose>
    return -1;
8010515a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010515d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105162:	eb 11                	jmp    80105175 <sys_pipe+0xb1>
      curproc->ofile[fd] = f;
80105164:	89 7c 90 50          	mov    %edi,0x50(%eax,%edx,4)
  }
  fd[0] = fd0;
80105168:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010516b:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
8010516d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105170:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105173:	31 c0                	xor    %eax,%eax
}
80105175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105178:	5b                   	pop    %ebx
80105179:	5e                   	pop    %esi
8010517a:	5f                   	pop    %edi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret
8010517d:	66 90                	xchg   %ax,%ax
8010517f:	90                   	nop

80105180 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105180:	e9 f3 e4 ff ff       	jmp    80103678 <fork>
80105185:	8d 76 00             	lea    0x0(%esi),%esi

80105188 <sys_exit>:
}

int
sys_exit(void)
{
80105188:	55                   	push   %ebp
80105189:	89 e5                	mov    %esp,%ebp
8010518b:	83 ec 08             	sub    $0x8,%esp
  exit();
8010518e:	e8 d9 e6 ff ff       	call   8010386c <exit>
  return 0;  // not reached
}
80105193:	31 c0                	xor    %eax,%eax
80105195:	c9                   	leave
80105196:	c3                   	ret
80105197:	90                   	nop

80105198 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105198:	e9 87 e8 ff ff       	jmp    80103a24 <wait>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi

801051a0 <sys_kill>:
}

int
sys_kill(void)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801051a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051a9:	50                   	push   %eax
801051aa:	6a 00                	push   $0x0
801051ac:	e8 b3 f3 ff ff       	call   80104564 <argint>
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	85 c0                	test   %eax,%eax
801051b6:	78 10                	js     801051c8 <sys_kill+0x28>
    return -1;
  return kill(pid);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	ff 75 f4             	push   -0xc(%ebp)
801051be:	e8 e9 ea ff ff       	call   80103cac <kill>
801051c3:	83 c4 10             	add    $0x10,%esp
}
801051c6:	c9                   	leave
801051c7:	c3                   	ret
    return -1;
801051c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051cd:	c9                   	leave
801051ce:	c3                   	ret
801051cf:	90                   	nop

801051d0 <sys_getpid>:

int
sys_getpid(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801051d6:	e8 1d e3 ff ff       	call   801034f8 <myproc>
801051db:	8b 40 38             	mov    0x38(%eax),%eax
}
801051de:	c9                   	leave
801051df:	c3                   	ret

801051e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	53                   	push   %ebx
801051e4:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801051e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ea:	50                   	push   %eax
801051eb:	6a 00                	push   $0x0
801051ed:	e8 72 f3 ff ff       	call   80104564 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 23                	js     8010521c <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
801051f9:	e8 fa e2 ff ff       	call   801034f8 <myproc>
801051fe:	8b 58 28             	mov    0x28(%eax),%ebx
  if(growproc(n) < 0)
80105201:	83 ec 0c             	sub    $0xc,%esp
80105204:	ff 75 f4             	push   -0xc(%ebp)
80105207:	e8 f8 e3 ff ff       	call   80103604 <growproc>
8010520c:	83 c4 10             	add    $0x10,%esp
8010520f:	85 c0                	test   %eax,%eax
80105211:	78 09                	js     8010521c <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80105213:	89 d8                	mov    %ebx,%eax
80105215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105218:	c9                   	leave
80105219:	c3                   	ret
8010521a:	66 90                	xchg   %ax,%ax
    return -1;
8010521c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105221:	eb f0                	jmp    80105213 <sys_sbrk+0x33>
80105223:	90                   	nop

80105224 <sys_sleep>:

int
sys_sleep(void)
{
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	53                   	push   %ebx
80105228:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010522b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010522e:	50                   	push   %eax
8010522f:	6a 00                	push   $0x0
80105231:	e8 2e f3 ff ff       	call   80104564 <argint>
80105236:	83 c4 10             	add    $0x10,%esp
80105239:	85 c0                	test   %eax,%eax
8010523b:	78 5c                	js     80105299 <sys_sleep+0x75>
    return -1;
  acquire(&tickslock);
8010523d:	83 ec 0c             	sub    $0xc,%esp
80105240:	68 80 46 11 80       	push   $0x80114680
80105245:	e8 2a f0 ff ff       	call   80104274 <acquire>
  ticks0 = ticks;
8010524a:	8b 1d 74 46 11 80    	mov    0x80114674,%ebx
  while(ticks - ticks0 < n){
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105256:	85 d2                	test   %edx,%edx
80105258:	75 23                	jne    8010527d <sys_sleep+0x59>
8010525a:	eb 44                	jmp    801052a0 <sys_sleep+0x7c>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
8010525c:	83 ec 08             	sub    $0x8,%esp
8010525f:	68 80 46 11 80       	push   $0x80114680
80105264:	68 74 46 11 80       	push   $0x80114674
80105269:	e8 26 e9 ff ff       	call   80103b94 <sleep>
  while(ticks - ticks0 < n){
8010526e:	a1 74 46 11 80       	mov    0x80114674,%eax
80105273:	29 d8                	sub    %ebx,%eax
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010527b:	73 23                	jae    801052a0 <sys_sleep+0x7c>
    if(myproc()->killed){
8010527d:	e8 76 e2 ff ff       	call   801034f8 <myproc>
80105282:	8b 40 4c             	mov    0x4c(%eax),%eax
80105285:	85 c0                	test   %eax,%eax
80105287:	74 d3                	je     8010525c <sys_sleep+0x38>
      release(&tickslock);
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	68 80 46 11 80       	push   $0x80114680
80105291:	e8 7e ef ff ff       	call   80104214 <release>
      return -1;
80105296:	83 c4 10             	add    $0x10,%esp
    return -1;
80105299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529e:	eb 12                	jmp    801052b2 <sys_sleep+0x8e>
  }
  release(&tickslock);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	68 80 46 11 80       	push   $0x80114680
801052a8:	e8 67 ef ff ff       	call   80104214 <release>
  return 0;
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	31 c0                	xor    %eax,%eax
}
801052b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b5:	c9                   	leave
801052b6:	c3                   	ret
801052b7:	90                   	nop

801052b8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801052b8:	55                   	push   %ebp
801052b9:	89 e5                	mov    %esp,%ebp
801052bb:	53                   	push   %ebx
801052bc:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801052bf:	68 80 46 11 80       	push   $0x80114680
801052c4:	e8 ab ef ff ff       	call   80104274 <acquire>
  xticks = ticks;
801052c9:	8b 1d 74 46 11 80    	mov    0x80114674,%ebx
  release(&tickslock);
801052cf:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
801052d6:	e8 39 ef ff ff       	call   80104214 <release>
  return xticks;
}
801052db:	89 d8                	mov    %ebx,%eax
801052dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052e0:	c9                   	leave
801052e1:	c3                   	ret

801052e2 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801052e2:	1e                   	push   %ds
  pushl %es
801052e3:	06                   	push   %es
  pushl %fs
801052e4:	0f a0                	push   %fs
  pushl %gs
801052e6:	0f a8                	push   %gs
  pushal
801052e8:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801052e9:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801052ed:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801052ef:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801052f1:	54                   	push   %esp
  call trap
801052f2:	e8 a1 00 00 00       	call   80105398 <trap>
  addl $4, %esp
801052f7:	83 c4 04             	add    $0x4,%esp

801052fa <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801052fa:	61                   	popa
  popl %gs
801052fb:	0f a9                	pop    %gs
  popl %fs
801052fd:	0f a1                	pop    %fs
  popl %es
801052ff:	07                   	pop    %es
  popl %ds
80105300:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105301:	83 c4 08             	add    $0x8,%esp
  iret
80105304:	cf                   	iret
80105305:	66 90                	xchg   %ax,%ax
80105307:	90                   	nop

80105308 <tvinit>:
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;
void
tvinit(void)
{
80105308:	55                   	push   %ebp
80105309:	89 e5                	mov    %esp,%ebp
8010530b:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010530e:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105310:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105317:	66 89 14 c5 c0 46 11 	mov    %dx,-0x7feeb940(,%eax,8)
8010531e:	80 
8010531f:	c7 04 c5 c2 46 11 80 	movl   $0x8e000008,-0x7feeb93e(,%eax,8)
80105326:	08 00 00 8e 
8010532a:	c1 ea 10             	shr    $0x10,%edx
8010532d:	66 89 14 c5 c6 46 11 	mov    %dx,-0x7feeb93a(,%eax,8)
80105334:	80 
  for(i = 0; i < 256; i++)
80105335:	40                   	inc    %eax
80105336:	3d 00 01 00 00       	cmp    $0x100,%eax
8010533b:	75 d3                	jne    80105310 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010533d:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105342:	66 a3 c0 48 11 80    	mov    %ax,0x801148c0
80105348:	c7 05 c2 48 11 80 08 	movl   $0xef000008,0x801148c2
8010534f:	00 00 ef 
80105352:	c1 e8 10             	shr    $0x10,%eax
80105355:	66 a3 c6 48 11 80    	mov    %ax,0x801148c6

  initlock(&tickslock, "time");
8010535b:	83 ec 08             	sub    $0x8,%esp
8010535e:	68 2a 6f 10 80       	push   $0x80106f2a
80105363:	68 80 46 11 80       	push   $0x80114680
80105368:	e8 3f ed ff ff       	call   801040ac <initlock>
}
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	c9                   	leave
80105371:	c3                   	ret
80105372:	66 90                	xchg   %ax,%ax

80105374 <idtinit>:

void
idtinit(void)
{
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010537a:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105380:	b8 c0 46 11 80       	mov    $0x801146c0,%eax
80105385:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105389:	c1 e8 10             	shr    $0x10,%eax
8010538c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105390:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105393:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105396:	c9                   	leave
80105397:	c3                   	ret

80105398 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105398:	55                   	push   %ebp
80105399:	89 e5                	mov    %esp,%ebp
8010539b:	57                   	push   %edi
8010539c:	56                   	push   %esi
8010539d:	53                   	push   %ebx
8010539e:	83 ec 1c             	sub    $0x1c,%esp
801053a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801053a4:	8b 43 30             	mov    0x30(%ebx),%eax
801053a7:	83 f8 40             	cmp    $0x40,%eax
801053aa:	0f 84 90 01 00 00    	je     80105540 <trap+0x1a8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801053b0:	83 e8 20             	sub    $0x20,%eax
801053b3:	83 f8 1f             	cmp    $0x1f,%eax
801053b6:	0f 87 b8 00 00 00    	ja     80105474 <trap+0xdc>
801053bc:	ff 24 85 64 74 10 80 	jmp    *-0x7fef8b9c(,%eax,4)
801053c3:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801053c4:	e8 fb e0 ff ff       	call   801034c4 <cpuid>
801053c9:	85 c0                	test   %eax,%eax
801053cb:	0f 84 0b 02 00 00    	je     801055dc <trap+0x244>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
     acquire(&ptable.lock);
801053d1:	83 ec 0c             	sub    $0xc,%esp
801053d4:	68 40 1d 11 80       	push   $0x80111d40
801053d9:	e8 96 ee ff ff       	call   80104274 <acquire>
    if (myproc() && myproc()->state == RUNNING) {
801053de:	e8 15 e1 ff ff       	call   801034f8 <myproc>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	74 0f                	je     801053f9 <trap+0x61>
801053ea:	e8 09 e1 ff ff       	call   801034f8 <myproc>
801053ef:	83 78 34 05          	cmpl   $0x5,0x34(%eax)
801053f3:	0f 84 23 02 00 00    	je     8010561c <trap+0x284>
        myproc()->total_run_time++;
    }
    release(&ptable.lock);
801053f9:	83 ec 0c             	sub    $0xc,%esp
801053fc:	68 40 1d 11 80       	push   $0x80111d40
80105401:	e8 0e ee ff ff       	call   80104214 <release>

    lapiceoi();
80105406:	e8 c1 d1 ff ff       	call   801025cc <lapiceoi>
    break;
8010540b:	83 c4 10             	add    $0x10,%esp
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010540e:	e8 e5 e0 ff ff       	call   801034f8 <myproc>
80105413:	85 c0                	test   %eax,%eax
80105415:	74 19                	je     80105430 <trap+0x98>
80105417:	e8 dc e0 ff ff       	call   801034f8 <myproc>
8010541c:	8b 50 4c             	mov    0x4c(%eax),%edx
8010541f:	85 d2                	test   %edx,%edx
80105421:	74 0d                	je     80105430 <trap+0x98>
80105423:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105426:	f7 d0                	not    %eax
80105428:	a8 03                	test   $0x3,%al
8010542a:	0f 84 a0 01 00 00    	je     801055d0 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105430:	e8 c3 e0 ff ff       	call   801034f8 <myproc>
80105435:	85 c0                	test   %eax,%eax
80105437:	74 0f                	je     80105448 <trap+0xb0>
80105439:	e8 ba e0 ff ff       	call   801034f8 <myproc>
8010543e:	83 78 34 05          	cmpl   $0x5,0x34(%eax)
80105442:	0f 84 b0 00 00 00    	je     801054f8 <trap+0x160>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105448:	e8 ab e0 ff ff       	call   801034f8 <myproc>
8010544d:	85 c0                	test   %eax,%eax
8010544f:	74 19                	je     8010546a <trap+0xd2>
80105451:	e8 a2 e0 ff ff       	call   801034f8 <myproc>
80105456:	8b 40 4c             	mov    0x4c(%eax),%eax
80105459:	85 c0                	test   %eax,%eax
8010545b:	74 0d                	je     8010546a <trap+0xd2>
8010545d:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105460:	f7 d0                	not    %eax
80105462:	a8 03                	test   $0x3,%al
80105464:	0f 84 03 01 00 00    	je     8010556d <trap+0x1d5>
    exit();
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546d:	5b                   	pop    %ebx
8010546e:	5e                   	pop    %esi
8010546f:	5f                   	pop    %edi
80105470:	5d                   	pop    %ebp
80105471:	c3                   	ret
80105472:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105474:	e8 7f e0 ff ff       	call   801034f8 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105479:	8b 7b 38             	mov    0x38(%ebx),%edi
    if(myproc() == 0 || (tf->cs&3) == 0){
8010547c:	85 c0                	test   %eax,%eax
8010547e:	0f 84 a5 01 00 00    	je     80105629 <trap+0x291>
80105484:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105488:	0f 84 9b 01 00 00    	je     80105629 <trap+0x291>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010548e:	0f 20 d1             	mov    %cr2,%ecx
80105491:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105494:	e8 2b e0 ff ff       	call   801034c4 <cpuid>
80105499:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010549c:	8b 43 34             	mov    0x34(%ebx),%eax
8010549f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801054a2:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801054a5:	e8 4e e0 ff ff       	call   801034f8 <myproc>
801054aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801054ad:	e8 46 e0 ff ff       	call   801034f8 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054b2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801054b5:	51                   	push   %ecx
801054b6:	57                   	push   %edi
801054b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
801054ba:	52                   	push   %edx
801054bb:	ff 75 e4             	push   -0x1c(%ebp)
801054be:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801054bf:	8b 75 e0             	mov    -0x20(%ebp),%esi
801054c2:	81 c6 94 00 00 00    	add    $0x94,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054c8:	56                   	push   %esi
801054c9:	ff 70 38             	push   0x38(%eax)
801054cc:	68 58 71 10 80       	push   $0x80107158
801054d1:	e8 4a b1 ff ff       	call   80100620 <cprintf>
    myproc()->killed = 1;
801054d6:	83 c4 20             	add    $0x20,%esp
801054d9:	e8 1a e0 ff ff       	call   801034f8 <myproc>
801054de:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054e5:	e8 0e e0 ff ff       	call   801034f8 <myproc>
801054ea:	85 c0                	test   %eax,%eax
801054ec:	0f 85 25 ff ff ff    	jne    80105417 <trap+0x7f>
801054f2:	e9 39 ff ff ff       	jmp    80105430 <trap+0x98>
801054f7:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
801054f8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801054fc:	0f 85 46 ff ff ff    	jne    80105448 <trap+0xb0>
    yield();
80105502:	e8 45 e6 ff ff       	call   80103b4c <yield>
80105507:	e9 3c ff ff ff       	jmp    80105448 <trap+0xb0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010550c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010550f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105513:	e8 ac df ff ff       	call   801034c4 <cpuid>
80105518:	57                   	push   %edi
80105519:	56                   	push   %esi
8010551a:	50                   	push   %eax
8010551b:	68 00 71 10 80       	push   $0x80107100
80105520:	e8 fb b0 ff ff       	call   80100620 <cprintf>
    lapiceoi();
80105525:	e8 a2 d0 ff ff       	call   801025cc <lapiceoi>
    break;
8010552a:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010552d:	e8 c6 df ff ff       	call   801034f8 <myproc>
80105532:	85 c0                	test   %eax,%eax
80105534:	0f 85 dd fe ff ff    	jne    80105417 <trap+0x7f>
8010553a:	e9 f1 fe ff ff       	jmp    80105430 <trap+0x98>
8010553f:	90                   	nop
    if(myproc()->killed)
80105540:	e8 b3 df ff ff       	call   801034f8 <myproc>
80105545:	8b 70 4c             	mov    0x4c(%eax),%esi
80105548:	85 f6                	test   %esi,%esi
8010554a:	0f 85 c0 00 00 00    	jne    80105610 <trap+0x278>
    myproc()->tf = tf;
80105550:	e8 a3 df ff ff       	call   801034f8 <myproc>
80105555:	89 58 40             	mov    %ebx,0x40(%eax)
    syscall();
80105558:	e8 1b f1 ff ff       	call   80104678 <syscall>
    if(myproc()->killed)
8010555d:	e8 96 df ff ff       	call   801034f8 <myproc>
80105562:	8b 48 4c             	mov    0x4c(%eax),%ecx
80105565:	85 c9                	test   %ecx,%ecx
80105567:	0f 84 fd fe ff ff    	je     8010546a <trap+0xd2>
}
8010556d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105570:	5b                   	pop    %ebx
80105571:	5e                   	pop    %esi
80105572:	5f                   	pop    %edi
80105573:	5d                   	pop    %ebp
      exit();
80105574:	e9 f3 e2 ff ff       	jmp    8010386c <exit>
80105579:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
8010557c:	e8 07 02 00 00       	call   80105788 <uartintr>
    lapiceoi();
80105581:	e8 46 d0 ff ff       	call   801025cc <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105586:	e8 6d df ff ff       	call   801034f8 <myproc>
8010558b:	85 c0                	test   %eax,%eax
8010558d:	0f 85 84 fe ff ff    	jne    80105417 <trap+0x7f>
80105593:	e9 98 fe ff ff       	jmp    80105430 <trap+0x98>
    kbdintr();
80105598:	e8 23 cf ff ff       	call   801024c0 <kbdintr>
    lapiceoi();
8010559d:	e8 2a d0 ff ff       	call   801025cc <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055a2:	e8 51 df ff ff       	call   801034f8 <myproc>
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 85 68 fe ff ff    	jne    80105417 <trap+0x7f>
801055af:	e9 7c fe ff ff       	jmp    80105430 <trap+0x98>
    ideintr();
801055b4:	e8 07 ca ff ff       	call   80101fc0 <ideintr>
    lapiceoi();
801055b9:	e8 0e d0 ff ff       	call   801025cc <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055be:	e8 35 df ff ff       	call   801034f8 <myproc>
801055c3:	85 c0                	test   %eax,%eax
801055c5:	0f 85 4c fe ff ff    	jne    80105417 <trap+0x7f>
801055cb:	e9 60 fe ff ff       	jmp    80105430 <trap+0x98>
    exit();
801055d0:	e8 97 e2 ff ff       	call   8010386c <exit>
801055d5:	e9 56 fe ff ff       	jmp    80105430 <trap+0x98>
801055da:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	68 80 46 11 80       	push   $0x80114680
801055e4:	e8 8b ec ff ff       	call   80104274 <acquire>
      ticks++;
801055e9:	ff 05 74 46 11 80    	incl   0x80114674
      wakeup(&ticks);
801055ef:	c7 04 24 74 46 11 80 	movl   $0x80114674,(%esp)
801055f6:	e8 55 e6 ff ff       	call   80103c50 <wakeup>
      release(&tickslock);
801055fb:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
80105602:	e8 0d ec ff ff       	call   80104214 <release>
80105607:	83 c4 10             	add    $0x10,%esp
8010560a:	e9 c2 fd ff ff       	jmp    801053d1 <trap+0x39>
8010560f:	90                   	nop
      exit();
80105610:	e8 57 e2 ff ff       	call   8010386c <exit>
80105615:	e9 36 ff ff ff       	jmp    80105550 <trap+0x1b8>
8010561a:	66 90                	xchg   %ax,%ax
        myproc()->total_run_time++;
8010561c:	e8 d7 de ff ff       	call   801034f8 <myproc>
80105621:	ff 40 18             	incl   0x18(%eax)
80105624:	e9 d0 fd ff ff       	jmp    801053f9 <trap+0x61>
80105629:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010562c:	e8 93 de ff ff       	call   801034c4 <cpuid>
80105631:	83 ec 0c             	sub    $0xc,%esp
80105634:	56                   	push   %esi
80105635:	57                   	push   %edi
80105636:	50                   	push   %eax
80105637:	ff 73 30             	push   0x30(%ebx)
8010563a:	68 24 71 10 80       	push   $0x80107124
8010563f:	e8 dc af ff ff       	call   80100620 <cprintf>
      panic("trap");
80105644:	83 c4 14             	add    $0x14,%esp
80105647:	68 2f 6f 10 80       	push   $0x80106f2f
8010564c:	e8 e7 ac ff ff       	call   80100338 <panic>
80105651:	66 90                	xchg   %ax,%ax
80105653:	90                   	nop

80105654 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105654:	a1 c0 4e 11 80       	mov    0x80114ec0,%eax
80105659:	85 c0                	test   %eax,%eax
8010565b:	74 17                	je     80105674 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010565d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105662:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105663:	a8 01                	test   $0x1,%al
80105665:	74 0d                	je     80105674 <uartgetc+0x20>
80105667:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010566c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010566d:	0f b6 c0             	movzbl %al,%eax
80105670:	c3                   	ret
80105671:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105679:	c3                   	ret
8010567a:	66 90                	xchg   %ax,%ax

8010567c <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010567c:	31 c9                	xor    %ecx,%ecx
8010567e:	88 c8                	mov    %cl,%al
80105680:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105685:	ee                   	out    %al,(%dx)
80105686:	b0 80                	mov    $0x80,%al
80105688:	ba fb 03 00 00       	mov    $0x3fb,%edx
8010568d:	ee                   	out    %al,(%dx)
8010568e:	b0 0c                	mov    $0xc,%al
80105690:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105695:	ee                   	out    %al,(%dx)
80105696:	88 c8                	mov    %cl,%al
80105698:	ba f9 03 00 00       	mov    $0x3f9,%edx
8010569d:	ee                   	out    %al,(%dx)
8010569e:	b0 03                	mov    $0x3,%al
801056a0:	ba fb 03 00 00       	mov    $0x3fb,%edx
801056a5:	ee                   	out    %al,(%dx)
801056a6:	ba fc 03 00 00       	mov    $0x3fc,%edx
801056ab:	88 c8                	mov    %cl,%al
801056ad:	ee                   	out    %al,(%dx)
801056ae:	b0 01                	mov    $0x1,%al
801056b0:	ba f9 03 00 00       	mov    $0x3f9,%edx
801056b5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056b6:	ba fd 03 00 00       	mov    $0x3fd,%edx
801056bb:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801056bc:	fe c0                	inc    %al
801056be:	74 7e                	je     8010573e <uartinit+0xc2>
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
801056c6:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
801056c9:	c7 05 c0 4e 11 80 01 	movl   $0x1,0x80114ec0
801056d0:	00 00 00 
801056d3:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056d8:	ec                   	in     (%dx),%al
801056d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056de:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801056df:	6a 00                	push   $0x0
801056e1:	6a 04                	push   $0x4
801056e3:	e8 e8 ca ff ff       	call   801021d0 <ioapicenable>
801056e8:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801056eb:	bf 34 6f 10 80       	mov    $0x80106f34,%edi
801056f0:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801056f4:	be fd 03 00 00       	mov    $0x3fd,%esi
801056f9:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801056fc:	a1 c0 4e 11 80       	mov    0x80114ec0,%eax
80105701:	85 c0                	test   %eax,%eax
80105703:	74 27                	je     8010572c <uartinit+0xb0>
80105705:	bb 80 00 00 00       	mov    $0x80,%ebx
8010570a:	eb 10                	jmp    8010571c <uartinit+0xa0>
    microdelay(10);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	6a 0a                	push   $0xa
80105711:	e8 ce ce ff ff       	call   801025e4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	4b                   	dec    %ebx
8010571a:	74 07                	je     80105723 <uartinit+0xa7>
8010571c:	89 f2                	mov    %esi,%edx
8010571e:	ec                   	in     (%dx),%al
8010571f:	a8 20                	test   $0x20,%al
80105721:	74 e9                	je     8010570c <uartinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105723:	8a 45 e7             	mov    -0x19(%ebp),%al
80105726:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010572b:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010572c:	47                   	inc    %edi
8010572d:	8a 07                	mov    (%edi),%al
8010572f:	88 45 e7             	mov    %al,-0x19(%ebp)
80105732:	84 c0                	test   %al,%al
80105734:	75 c6                	jne    801056fc <uartinit+0x80>
}
80105736:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105739:	5b                   	pop    %ebx
8010573a:	5e                   	pop    %esi
8010573b:	5f                   	pop    %edi
8010573c:	5d                   	pop    %ebp
8010573d:	c3                   	ret
8010573e:	c3                   	ret
8010573f:	90                   	nop

80105740 <uartputc>:
  if(!uart)
80105740:	a1 c0 4e 11 80       	mov    0x80114ec0,%eax
80105745:	85 c0                	test   %eax,%eax
80105747:	74 3b                	je     80105784 <uartputc+0x44>
{
80105749:	55                   	push   %ebp
8010574a:	89 e5                	mov    %esp,%ebp
8010574c:	56                   	push   %esi
8010574d:	53                   	push   %ebx
8010574e:	bb 80 00 00 00       	mov    $0x80,%ebx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105753:	be fd 03 00 00       	mov    $0x3fd,%esi
80105758:	eb 12                	jmp    8010576c <uartputc+0x2c>
8010575a:	66 90                	xchg   %ax,%ax
    microdelay(10);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	6a 0a                	push   $0xa
80105761:	e8 7e ce ff ff       	call   801025e4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	4b                   	dec    %ebx
8010576a:	74 07                	je     80105773 <uartputc+0x33>
8010576c:	89 f2                	mov    %esi,%edx
8010576e:	ec                   	in     (%dx),%al
8010576f:	a8 20                	test   $0x20,%al
80105771:	74 e9                	je     8010575c <uartputc+0x1c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105773:	8b 45 08             	mov    0x8(%ebp),%eax
80105776:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010577b:	ee                   	out    %al,(%dx)
}
8010577c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010577f:	5b                   	pop    %ebx
80105780:	5e                   	pop    %esi
80105781:	5d                   	pop    %ebp
80105782:	c3                   	ret
80105783:	90                   	nop
80105784:	c3                   	ret
80105785:	8d 76 00             	lea    0x0(%esi),%esi

80105788 <uartintr>:

void
uartintr(void)
{
80105788:	55                   	push   %ebp
80105789:	89 e5                	mov    %esp,%ebp
8010578b:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010578e:	68 54 56 10 80       	push   $0x80105654
80105793:	e8 50 b0 ff ff       	call   801007e8 <consoleintr>
}
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	c9                   	leave
8010579c:	c3                   	ret

8010579d <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $0
8010579f:	6a 00                	push   $0x0
  jmp alltraps
801057a1:	e9 3c fb ff ff       	jmp    801052e2 <alltraps>

801057a6 <vector1>:
.globl vector1
vector1:
  pushl $0
801057a6:	6a 00                	push   $0x0
  pushl $1
801057a8:	6a 01                	push   $0x1
  jmp alltraps
801057aa:	e9 33 fb ff ff       	jmp    801052e2 <alltraps>

801057af <vector2>:
.globl vector2
vector2:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $2
801057b1:	6a 02                	push   $0x2
  jmp alltraps
801057b3:	e9 2a fb ff ff       	jmp    801052e2 <alltraps>

801057b8 <vector3>:
.globl vector3
vector3:
  pushl $0
801057b8:	6a 00                	push   $0x0
  pushl $3
801057ba:	6a 03                	push   $0x3
  jmp alltraps
801057bc:	e9 21 fb ff ff       	jmp    801052e2 <alltraps>

801057c1 <vector4>:
.globl vector4
vector4:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $4
801057c3:	6a 04                	push   $0x4
  jmp alltraps
801057c5:	e9 18 fb ff ff       	jmp    801052e2 <alltraps>

801057ca <vector5>:
.globl vector5
vector5:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $5
801057cc:	6a 05                	push   $0x5
  jmp alltraps
801057ce:	e9 0f fb ff ff       	jmp    801052e2 <alltraps>

801057d3 <vector6>:
.globl vector6
vector6:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $6
801057d5:	6a 06                	push   $0x6
  jmp alltraps
801057d7:	e9 06 fb ff ff       	jmp    801052e2 <alltraps>

801057dc <vector7>:
.globl vector7
vector7:
  pushl $0
801057dc:	6a 00                	push   $0x0
  pushl $7
801057de:	6a 07                	push   $0x7
  jmp alltraps
801057e0:	e9 fd fa ff ff       	jmp    801052e2 <alltraps>

801057e5 <vector8>:
.globl vector8
vector8:
  pushl $8
801057e5:	6a 08                	push   $0x8
  jmp alltraps
801057e7:	e9 f6 fa ff ff       	jmp    801052e2 <alltraps>

801057ec <vector9>:
.globl vector9
vector9:
  pushl $0
801057ec:	6a 00                	push   $0x0
  pushl $9
801057ee:	6a 09                	push   $0x9
  jmp alltraps
801057f0:	e9 ed fa ff ff       	jmp    801052e2 <alltraps>

801057f5 <vector10>:
.globl vector10
vector10:
  pushl $10
801057f5:	6a 0a                	push   $0xa
  jmp alltraps
801057f7:	e9 e6 fa ff ff       	jmp    801052e2 <alltraps>

801057fc <vector11>:
.globl vector11
vector11:
  pushl $11
801057fc:	6a 0b                	push   $0xb
  jmp alltraps
801057fe:	e9 df fa ff ff       	jmp    801052e2 <alltraps>

80105803 <vector12>:
.globl vector12
vector12:
  pushl $12
80105803:	6a 0c                	push   $0xc
  jmp alltraps
80105805:	e9 d8 fa ff ff       	jmp    801052e2 <alltraps>

8010580a <vector13>:
.globl vector13
vector13:
  pushl $13
8010580a:	6a 0d                	push   $0xd
  jmp alltraps
8010580c:	e9 d1 fa ff ff       	jmp    801052e2 <alltraps>

80105811 <vector14>:
.globl vector14
vector14:
  pushl $14
80105811:	6a 0e                	push   $0xe
  jmp alltraps
80105813:	e9 ca fa ff ff       	jmp    801052e2 <alltraps>

80105818 <vector15>:
.globl vector15
vector15:
  pushl $0
80105818:	6a 00                	push   $0x0
  pushl $15
8010581a:	6a 0f                	push   $0xf
  jmp alltraps
8010581c:	e9 c1 fa ff ff       	jmp    801052e2 <alltraps>

80105821 <vector16>:
.globl vector16
vector16:
  pushl $0
80105821:	6a 00                	push   $0x0
  pushl $16
80105823:	6a 10                	push   $0x10
  jmp alltraps
80105825:	e9 b8 fa ff ff       	jmp    801052e2 <alltraps>

8010582a <vector17>:
.globl vector17
vector17:
  pushl $17
8010582a:	6a 11                	push   $0x11
  jmp alltraps
8010582c:	e9 b1 fa ff ff       	jmp    801052e2 <alltraps>

80105831 <vector18>:
.globl vector18
vector18:
  pushl $0
80105831:	6a 00                	push   $0x0
  pushl $18
80105833:	6a 12                	push   $0x12
  jmp alltraps
80105835:	e9 a8 fa ff ff       	jmp    801052e2 <alltraps>

8010583a <vector19>:
.globl vector19
vector19:
  pushl $0
8010583a:	6a 00                	push   $0x0
  pushl $19
8010583c:	6a 13                	push   $0x13
  jmp alltraps
8010583e:	e9 9f fa ff ff       	jmp    801052e2 <alltraps>

80105843 <vector20>:
.globl vector20
vector20:
  pushl $0
80105843:	6a 00                	push   $0x0
  pushl $20
80105845:	6a 14                	push   $0x14
  jmp alltraps
80105847:	e9 96 fa ff ff       	jmp    801052e2 <alltraps>

8010584c <vector21>:
.globl vector21
vector21:
  pushl $0
8010584c:	6a 00                	push   $0x0
  pushl $21
8010584e:	6a 15                	push   $0x15
  jmp alltraps
80105850:	e9 8d fa ff ff       	jmp    801052e2 <alltraps>

80105855 <vector22>:
.globl vector22
vector22:
  pushl $0
80105855:	6a 00                	push   $0x0
  pushl $22
80105857:	6a 16                	push   $0x16
  jmp alltraps
80105859:	e9 84 fa ff ff       	jmp    801052e2 <alltraps>

8010585e <vector23>:
.globl vector23
vector23:
  pushl $0
8010585e:	6a 00                	push   $0x0
  pushl $23
80105860:	6a 17                	push   $0x17
  jmp alltraps
80105862:	e9 7b fa ff ff       	jmp    801052e2 <alltraps>

80105867 <vector24>:
.globl vector24
vector24:
  pushl $0
80105867:	6a 00                	push   $0x0
  pushl $24
80105869:	6a 18                	push   $0x18
  jmp alltraps
8010586b:	e9 72 fa ff ff       	jmp    801052e2 <alltraps>

80105870 <vector25>:
.globl vector25
vector25:
  pushl $0
80105870:	6a 00                	push   $0x0
  pushl $25
80105872:	6a 19                	push   $0x19
  jmp alltraps
80105874:	e9 69 fa ff ff       	jmp    801052e2 <alltraps>

80105879 <vector26>:
.globl vector26
vector26:
  pushl $0
80105879:	6a 00                	push   $0x0
  pushl $26
8010587b:	6a 1a                	push   $0x1a
  jmp alltraps
8010587d:	e9 60 fa ff ff       	jmp    801052e2 <alltraps>

80105882 <vector27>:
.globl vector27
vector27:
  pushl $0
80105882:	6a 00                	push   $0x0
  pushl $27
80105884:	6a 1b                	push   $0x1b
  jmp alltraps
80105886:	e9 57 fa ff ff       	jmp    801052e2 <alltraps>

8010588b <vector28>:
.globl vector28
vector28:
  pushl $0
8010588b:	6a 00                	push   $0x0
  pushl $28
8010588d:	6a 1c                	push   $0x1c
  jmp alltraps
8010588f:	e9 4e fa ff ff       	jmp    801052e2 <alltraps>

80105894 <vector29>:
.globl vector29
vector29:
  pushl $0
80105894:	6a 00                	push   $0x0
  pushl $29
80105896:	6a 1d                	push   $0x1d
  jmp alltraps
80105898:	e9 45 fa ff ff       	jmp    801052e2 <alltraps>

8010589d <vector30>:
.globl vector30
vector30:
  pushl $0
8010589d:	6a 00                	push   $0x0
  pushl $30
8010589f:	6a 1e                	push   $0x1e
  jmp alltraps
801058a1:	e9 3c fa ff ff       	jmp    801052e2 <alltraps>

801058a6 <vector31>:
.globl vector31
vector31:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $31
801058a8:	6a 1f                	push   $0x1f
  jmp alltraps
801058aa:	e9 33 fa ff ff       	jmp    801052e2 <alltraps>

801058af <vector32>:
.globl vector32
vector32:
  pushl $0
801058af:	6a 00                	push   $0x0
  pushl $32
801058b1:	6a 20                	push   $0x20
  jmp alltraps
801058b3:	e9 2a fa ff ff       	jmp    801052e2 <alltraps>

801058b8 <vector33>:
.globl vector33
vector33:
  pushl $0
801058b8:	6a 00                	push   $0x0
  pushl $33
801058ba:	6a 21                	push   $0x21
  jmp alltraps
801058bc:	e9 21 fa ff ff       	jmp    801052e2 <alltraps>

801058c1 <vector34>:
.globl vector34
vector34:
  pushl $0
801058c1:	6a 00                	push   $0x0
  pushl $34
801058c3:	6a 22                	push   $0x22
  jmp alltraps
801058c5:	e9 18 fa ff ff       	jmp    801052e2 <alltraps>

801058ca <vector35>:
.globl vector35
vector35:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $35
801058cc:	6a 23                	push   $0x23
  jmp alltraps
801058ce:	e9 0f fa ff ff       	jmp    801052e2 <alltraps>

801058d3 <vector36>:
.globl vector36
vector36:
  pushl $0
801058d3:	6a 00                	push   $0x0
  pushl $36
801058d5:	6a 24                	push   $0x24
  jmp alltraps
801058d7:	e9 06 fa ff ff       	jmp    801052e2 <alltraps>

801058dc <vector37>:
.globl vector37
vector37:
  pushl $0
801058dc:	6a 00                	push   $0x0
  pushl $37
801058de:	6a 25                	push   $0x25
  jmp alltraps
801058e0:	e9 fd f9 ff ff       	jmp    801052e2 <alltraps>

801058e5 <vector38>:
.globl vector38
vector38:
  pushl $0
801058e5:	6a 00                	push   $0x0
  pushl $38
801058e7:	6a 26                	push   $0x26
  jmp alltraps
801058e9:	e9 f4 f9 ff ff       	jmp    801052e2 <alltraps>

801058ee <vector39>:
.globl vector39
vector39:
  pushl $0
801058ee:	6a 00                	push   $0x0
  pushl $39
801058f0:	6a 27                	push   $0x27
  jmp alltraps
801058f2:	e9 eb f9 ff ff       	jmp    801052e2 <alltraps>

801058f7 <vector40>:
.globl vector40
vector40:
  pushl $0
801058f7:	6a 00                	push   $0x0
  pushl $40
801058f9:	6a 28                	push   $0x28
  jmp alltraps
801058fb:	e9 e2 f9 ff ff       	jmp    801052e2 <alltraps>

80105900 <vector41>:
.globl vector41
vector41:
  pushl $0
80105900:	6a 00                	push   $0x0
  pushl $41
80105902:	6a 29                	push   $0x29
  jmp alltraps
80105904:	e9 d9 f9 ff ff       	jmp    801052e2 <alltraps>

80105909 <vector42>:
.globl vector42
vector42:
  pushl $0
80105909:	6a 00                	push   $0x0
  pushl $42
8010590b:	6a 2a                	push   $0x2a
  jmp alltraps
8010590d:	e9 d0 f9 ff ff       	jmp    801052e2 <alltraps>

80105912 <vector43>:
.globl vector43
vector43:
  pushl $0
80105912:	6a 00                	push   $0x0
  pushl $43
80105914:	6a 2b                	push   $0x2b
  jmp alltraps
80105916:	e9 c7 f9 ff ff       	jmp    801052e2 <alltraps>

8010591b <vector44>:
.globl vector44
vector44:
  pushl $0
8010591b:	6a 00                	push   $0x0
  pushl $44
8010591d:	6a 2c                	push   $0x2c
  jmp alltraps
8010591f:	e9 be f9 ff ff       	jmp    801052e2 <alltraps>

80105924 <vector45>:
.globl vector45
vector45:
  pushl $0
80105924:	6a 00                	push   $0x0
  pushl $45
80105926:	6a 2d                	push   $0x2d
  jmp alltraps
80105928:	e9 b5 f9 ff ff       	jmp    801052e2 <alltraps>

8010592d <vector46>:
.globl vector46
vector46:
  pushl $0
8010592d:	6a 00                	push   $0x0
  pushl $46
8010592f:	6a 2e                	push   $0x2e
  jmp alltraps
80105931:	e9 ac f9 ff ff       	jmp    801052e2 <alltraps>

80105936 <vector47>:
.globl vector47
vector47:
  pushl $0
80105936:	6a 00                	push   $0x0
  pushl $47
80105938:	6a 2f                	push   $0x2f
  jmp alltraps
8010593a:	e9 a3 f9 ff ff       	jmp    801052e2 <alltraps>

8010593f <vector48>:
.globl vector48
vector48:
  pushl $0
8010593f:	6a 00                	push   $0x0
  pushl $48
80105941:	6a 30                	push   $0x30
  jmp alltraps
80105943:	e9 9a f9 ff ff       	jmp    801052e2 <alltraps>

80105948 <vector49>:
.globl vector49
vector49:
  pushl $0
80105948:	6a 00                	push   $0x0
  pushl $49
8010594a:	6a 31                	push   $0x31
  jmp alltraps
8010594c:	e9 91 f9 ff ff       	jmp    801052e2 <alltraps>

80105951 <vector50>:
.globl vector50
vector50:
  pushl $0
80105951:	6a 00                	push   $0x0
  pushl $50
80105953:	6a 32                	push   $0x32
  jmp alltraps
80105955:	e9 88 f9 ff ff       	jmp    801052e2 <alltraps>

8010595a <vector51>:
.globl vector51
vector51:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $51
8010595c:	6a 33                	push   $0x33
  jmp alltraps
8010595e:	e9 7f f9 ff ff       	jmp    801052e2 <alltraps>

80105963 <vector52>:
.globl vector52
vector52:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $52
80105965:	6a 34                	push   $0x34
  jmp alltraps
80105967:	e9 76 f9 ff ff       	jmp    801052e2 <alltraps>

8010596c <vector53>:
.globl vector53
vector53:
  pushl $0
8010596c:	6a 00                	push   $0x0
  pushl $53
8010596e:	6a 35                	push   $0x35
  jmp alltraps
80105970:	e9 6d f9 ff ff       	jmp    801052e2 <alltraps>

80105975 <vector54>:
.globl vector54
vector54:
  pushl $0
80105975:	6a 00                	push   $0x0
  pushl $54
80105977:	6a 36                	push   $0x36
  jmp alltraps
80105979:	e9 64 f9 ff ff       	jmp    801052e2 <alltraps>

8010597e <vector55>:
.globl vector55
vector55:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $55
80105980:	6a 37                	push   $0x37
  jmp alltraps
80105982:	e9 5b f9 ff ff       	jmp    801052e2 <alltraps>

80105987 <vector56>:
.globl vector56
vector56:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $56
80105989:	6a 38                	push   $0x38
  jmp alltraps
8010598b:	e9 52 f9 ff ff       	jmp    801052e2 <alltraps>

80105990 <vector57>:
.globl vector57
vector57:
  pushl $0
80105990:	6a 00                	push   $0x0
  pushl $57
80105992:	6a 39                	push   $0x39
  jmp alltraps
80105994:	e9 49 f9 ff ff       	jmp    801052e2 <alltraps>

80105999 <vector58>:
.globl vector58
vector58:
  pushl $0
80105999:	6a 00                	push   $0x0
  pushl $58
8010599b:	6a 3a                	push   $0x3a
  jmp alltraps
8010599d:	e9 40 f9 ff ff       	jmp    801052e2 <alltraps>

801059a2 <vector59>:
.globl vector59
vector59:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $59
801059a4:	6a 3b                	push   $0x3b
  jmp alltraps
801059a6:	e9 37 f9 ff ff       	jmp    801052e2 <alltraps>

801059ab <vector60>:
.globl vector60
vector60:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $60
801059ad:	6a 3c                	push   $0x3c
  jmp alltraps
801059af:	e9 2e f9 ff ff       	jmp    801052e2 <alltraps>

801059b4 <vector61>:
.globl vector61
vector61:
  pushl $0
801059b4:	6a 00                	push   $0x0
  pushl $61
801059b6:	6a 3d                	push   $0x3d
  jmp alltraps
801059b8:	e9 25 f9 ff ff       	jmp    801052e2 <alltraps>

801059bd <vector62>:
.globl vector62
vector62:
  pushl $0
801059bd:	6a 00                	push   $0x0
  pushl $62
801059bf:	6a 3e                	push   $0x3e
  jmp alltraps
801059c1:	e9 1c f9 ff ff       	jmp    801052e2 <alltraps>

801059c6 <vector63>:
.globl vector63
vector63:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $63
801059c8:	6a 3f                	push   $0x3f
  jmp alltraps
801059ca:	e9 13 f9 ff ff       	jmp    801052e2 <alltraps>

801059cf <vector64>:
.globl vector64
vector64:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $64
801059d1:	6a 40                	push   $0x40
  jmp alltraps
801059d3:	e9 0a f9 ff ff       	jmp    801052e2 <alltraps>

801059d8 <vector65>:
.globl vector65
vector65:
  pushl $0
801059d8:	6a 00                	push   $0x0
  pushl $65
801059da:	6a 41                	push   $0x41
  jmp alltraps
801059dc:	e9 01 f9 ff ff       	jmp    801052e2 <alltraps>

801059e1 <vector66>:
.globl vector66
vector66:
  pushl $0
801059e1:	6a 00                	push   $0x0
  pushl $66
801059e3:	6a 42                	push   $0x42
  jmp alltraps
801059e5:	e9 f8 f8 ff ff       	jmp    801052e2 <alltraps>

801059ea <vector67>:
.globl vector67
vector67:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $67
801059ec:	6a 43                	push   $0x43
  jmp alltraps
801059ee:	e9 ef f8 ff ff       	jmp    801052e2 <alltraps>

801059f3 <vector68>:
.globl vector68
vector68:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $68
801059f5:	6a 44                	push   $0x44
  jmp alltraps
801059f7:	e9 e6 f8 ff ff       	jmp    801052e2 <alltraps>

801059fc <vector69>:
.globl vector69
vector69:
  pushl $0
801059fc:	6a 00                	push   $0x0
  pushl $69
801059fe:	6a 45                	push   $0x45
  jmp alltraps
80105a00:	e9 dd f8 ff ff       	jmp    801052e2 <alltraps>

80105a05 <vector70>:
.globl vector70
vector70:
  pushl $0
80105a05:	6a 00                	push   $0x0
  pushl $70
80105a07:	6a 46                	push   $0x46
  jmp alltraps
80105a09:	e9 d4 f8 ff ff       	jmp    801052e2 <alltraps>

80105a0e <vector71>:
.globl vector71
vector71:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $71
80105a10:	6a 47                	push   $0x47
  jmp alltraps
80105a12:	e9 cb f8 ff ff       	jmp    801052e2 <alltraps>

80105a17 <vector72>:
.globl vector72
vector72:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $72
80105a19:	6a 48                	push   $0x48
  jmp alltraps
80105a1b:	e9 c2 f8 ff ff       	jmp    801052e2 <alltraps>

80105a20 <vector73>:
.globl vector73
vector73:
  pushl $0
80105a20:	6a 00                	push   $0x0
  pushl $73
80105a22:	6a 49                	push   $0x49
  jmp alltraps
80105a24:	e9 b9 f8 ff ff       	jmp    801052e2 <alltraps>

80105a29 <vector74>:
.globl vector74
vector74:
  pushl $0
80105a29:	6a 00                	push   $0x0
  pushl $74
80105a2b:	6a 4a                	push   $0x4a
  jmp alltraps
80105a2d:	e9 b0 f8 ff ff       	jmp    801052e2 <alltraps>

80105a32 <vector75>:
.globl vector75
vector75:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $75
80105a34:	6a 4b                	push   $0x4b
  jmp alltraps
80105a36:	e9 a7 f8 ff ff       	jmp    801052e2 <alltraps>

80105a3b <vector76>:
.globl vector76
vector76:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $76
80105a3d:	6a 4c                	push   $0x4c
  jmp alltraps
80105a3f:	e9 9e f8 ff ff       	jmp    801052e2 <alltraps>

80105a44 <vector77>:
.globl vector77
vector77:
  pushl $0
80105a44:	6a 00                	push   $0x0
  pushl $77
80105a46:	6a 4d                	push   $0x4d
  jmp alltraps
80105a48:	e9 95 f8 ff ff       	jmp    801052e2 <alltraps>

80105a4d <vector78>:
.globl vector78
vector78:
  pushl $0
80105a4d:	6a 00                	push   $0x0
  pushl $78
80105a4f:	6a 4e                	push   $0x4e
  jmp alltraps
80105a51:	e9 8c f8 ff ff       	jmp    801052e2 <alltraps>

80105a56 <vector79>:
.globl vector79
vector79:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $79
80105a58:	6a 4f                	push   $0x4f
  jmp alltraps
80105a5a:	e9 83 f8 ff ff       	jmp    801052e2 <alltraps>

80105a5f <vector80>:
.globl vector80
vector80:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $80
80105a61:	6a 50                	push   $0x50
  jmp alltraps
80105a63:	e9 7a f8 ff ff       	jmp    801052e2 <alltraps>

80105a68 <vector81>:
.globl vector81
vector81:
  pushl $0
80105a68:	6a 00                	push   $0x0
  pushl $81
80105a6a:	6a 51                	push   $0x51
  jmp alltraps
80105a6c:	e9 71 f8 ff ff       	jmp    801052e2 <alltraps>

80105a71 <vector82>:
.globl vector82
vector82:
  pushl $0
80105a71:	6a 00                	push   $0x0
  pushl $82
80105a73:	6a 52                	push   $0x52
  jmp alltraps
80105a75:	e9 68 f8 ff ff       	jmp    801052e2 <alltraps>

80105a7a <vector83>:
.globl vector83
vector83:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $83
80105a7c:	6a 53                	push   $0x53
  jmp alltraps
80105a7e:	e9 5f f8 ff ff       	jmp    801052e2 <alltraps>

80105a83 <vector84>:
.globl vector84
vector84:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $84
80105a85:	6a 54                	push   $0x54
  jmp alltraps
80105a87:	e9 56 f8 ff ff       	jmp    801052e2 <alltraps>

80105a8c <vector85>:
.globl vector85
vector85:
  pushl $0
80105a8c:	6a 00                	push   $0x0
  pushl $85
80105a8e:	6a 55                	push   $0x55
  jmp alltraps
80105a90:	e9 4d f8 ff ff       	jmp    801052e2 <alltraps>

80105a95 <vector86>:
.globl vector86
vector86:
  pushl $0
80105a95:	6a 00                	push   $0x0
  pushl $86
80105a97:	6a 56                	push   $0x56
  jmp alltraps
80105a99:	e9 44 f8 ff ff       	jmp    801052e2 <alltraps>

80105a9e <vector87>:
.globl vector87
vector87:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $87
80105aa0:	6a 57                	push   $0x57
  jmp alltraps
80105aa2:	e9 3b f8 ff ff       	jmp    801052e2 <alltraps>

80105aa7 <vector88>:
.globl vector88
vector88:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $88
80105aa9:	6a 58                	push   $0x58
  jmp alltraps
80105aab:	e9 32 f8 ff ff       	jmp    801052e2 <alltraps>

80105ab0 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ab0:	6a 00                	push   $0x0
  pushl $89
80105ab2:	6a 59                	push   $0x59
  jmp alltraps
80105ab4:	e9 29 f8 ff ff       	jmp    801052e2 <alltraps>

80105ab9 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $90
80105abb:	6a 5a                	push   $0x5a
  jmp alltraps
80105abd:	e9 20 f8 ff ff       	jmp    801052e2 <alltraps>

80105ac2 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $91
80105ac4:	6a 5b                	push   $0x5b
  jmp alltraps
80105ac6:	e9 17 f8 ff ff       	jmp    801052e2 <alltraps>

80105acb <vector92>:
.globl vector92
vector92:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $92
80105acd:	6a 5c                	push   $0x5c
  jmp alltraps
80105acf:	e9 0e f8 ff ff       	jmp    801052e2 <alltraps>

80105ad4 <vector93>:
.globl vector93
vector93:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $93
80105ad6:	6a 5d                	push   $0x5d
  jmp alltraps
80105ad8:	e9 05 f8 ff ff       	jmp    801052e2 <alltraps>

80105add <vector94>:
.globl vector94
vector94:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $94
80105adf:	6a 5e                	push   $0x5e
  jmp alltraps
80105ae1:	e9 fc f7 ff ff       	jmp    801052e2 <alltraps>

80105ae6 <vector95>:
.globl vector95
vector95:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $95
80105ae8:	6a 5f                	push   $0x5f
  jmp alltraps
80105aea:	e9 f3 f7 ff ff       	jmp    801052e2 <alltraps>

80105aef <vector96>:
.globl vector96
vector96:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $96
80105af1:	6a 60                	push   $0x60
  jmp alltraps
80105af3:	e9 ea f7 ff ff       	jmp    801052e2 <alltraps>

80105af8 <vector97>:
.globl vector97
vector97:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $97
80105afa:	6a 61                	push   $0x61
  jmp alltraps
80105afc:	e9 e1 f7 ff ff       	jmp    801052e2 <alltraps>

80105b01 <vector98>:
.globl vector98
vector98:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $98
80105b03:	6a 62                	push   $0x62
  jmp alltraps
80105b05:	e9 d8 f7 ff ff       	jmp    801052e2 <alltraps>

80105b0a <vector99>:
.globl vector99
vector99:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $99
80105b0c:	6a 63                	push   $0x63
  jmp alltraps
80105b0e:	e9 cf f7 ff ff       	jmp    801052e2 <alltraps>

80105b13 <vector100>:
.globl vector100
vector100:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $100
80105b15:	6a 64                	push   $0x64
  jmp alltraps
80105b17:	e9 c6 f7 ff ff       	jmp    801052e2 <alltraps>

80105b1c <vector101>:
.globl vector101
vector101:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $101
80105b1e:	6a 65                	push   $0x65
  jmp alltraps
80105b20:	e9 bd f7 ff ff       	jmp    801052e2 <alltraps>

80105b25 <vector102>:
.globl vector102
vector102:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $102
80105b27:	6a 66                	push   $0x66
  jmp alltraps
80105b29:	e9 b4 f7 ff ff       	jmp    801052e2 <alltraps>

80105b2e <vector103>:
.globl vector103
vector103:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $103
80105b30:	6a 67                	push   $0x67
  jmp alltraps
80105b32:	e9 ab f7 ff ff       	jmp    801052e2 <alltraps>

80105b37 <vector104>:
.globl vector104
vector104:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $104
80105b39:	6a 68                	push   $0x68
  jmp alltraps
80105b3b:	e9 a2 f7 ff ff       	jmp    801052e2 <alltraps>

80105b40 <vector105>:
.globl vector105
vector105:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $105
80105b42:	6a 69                	push   $0x69
  jmp alltraps
80105b44:	e9 99 f7 ff ff       	jmp    801052e2 <alltraps>

80105b49 <vector106>:
.globl vector106
vector106:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $106
80105b4b:	6a 6a                	push   $0x6a
  jmp alltraps
80105b4d:	e9 90 f7 ff ff       	jmp    801052e2 <alltraps>

80105b52 <vector107>:
.globl vector107
vector107:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $107
80105b54:	6a 6b                	push   $0x6b
  jmp alltraps
80105b56:	e9 87 f7 ff ff       	jmp    801052e2 <alltraps>

80105b5b <vector108>:
.globl vector108
vector108:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $108
80105b5d:	6a 6c                	push   $0x6c
  jmp alltraps
80105b5f:	e9 7e f7 ff ff       	jmp    801052e2 <alltraps>

80105b64 <vector109>:
.globl vector109
vector109:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $109
80105b66:	6a 6d                	push   $0x6d
  jmp alltraps
80105b68:	e9 75 f7 ff ff       	jmp    801052e2 <alltraps>

80105b6d <vector110>:
.globl vector110
vector110:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $110
80105b6f:	6a 6e                	push   $0x6e
  jmp alltraps
80105b71:	e9 6c f7 ff ff       	jmp    801052e2 <alltraps>

80105b76 <vector111>:
.globl vector111
vector111:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $111
80105b78:	6a 6f                	push   $0x6f
  jmp alltraps
80105b7a:	e9 63 f7 ff ff       	jmp    801052e2 <alltraps>

80105b7f <vector112>:
.globl vector112
vector112:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $112
80105b81:	6a 70                	push   $0x70
  jmp alltraps
80105b83:	e9 5a f7 ff ff       	jmp    801052e2 <alltraps>

80105b88 <vector113>:
.globl vector113
vector113:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $113
80105b8a:	6a 71                	push   $0x71
  jmp alltraps
80105b8c:	e9 51 f7 ff ff       	jmp    801052e2 <alltraps>

80105b91 <vector114>:
.globl vector114
vector114:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $114
80105b93:	6a 72                	push   $0x72
  jmp alltraps
80105b95:	e9 48 f7 ff ff       	jmp    801052e2 <alltraps>

80105b9a <vector115>:
.globl vector115
vector115:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $115
80105b9c:	6a 73                	push   $0x73
  jmp alltraps
80105b9e:	e9 3f f7 ff ff       	jmp    801052e2 <alltraps>

80105ba3 <vector116>:
.globl vector116
vector116:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $116
80105ba5:	6a 74                	push   $0x74
  jmp alltraps
80105ba7:	e9 36 f7 ff ff       	jmp    801052e2 <alltraps>

80105bac <vector117>:
.globl vector117
vector117:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $117
80105bae:	6a 75                	push   $0x75
  jmp alltraps
80105bb0:	e9 2d f7 ff ff       	jmp    801052e2 <alltraps>

80105bb5 <vector118>:
.globl vector118
vector118:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $118
80105bb7:	6a 76                	push   $0x76
  jmp alltraps
80105bb9:	e9 24 f7 ff ff       	jmp    801052e2 <alltraps>

80105bbe <vector119>:
.globl vector119
vector119:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $119
80105bc0:	6a 77                	push   $0x77
  jmp alltraps
80105bc2:	e9 1b f7 ff ff       	jmp    801052e2 <alltraps>

80105bc7 <vector120>:
.globl vector120
vector120:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $120
80105bc9:	6a 78                	push   $0x78
  jmp alltraps
80105bcb:	e9 12 f7 ff ff       	jmp    801052e2 <alltraps>

80105bd0 <vector121>:
.globl vector121
vector121:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $121
80105bd2:	6a 79                	push   $0x79
  jmp alltraps
80105bd4:	e9 09 f7 ff ff       	jmp    801052e2 <alltraps>

80105bd9 <vector122>:
.globl vector122
vector122:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $122
80105bdb:	6a 7a                	push   $0x7a
  jmp alltraps
80105bdd:	e9 00 f7 ff ff       	jmp    801052e2 <alltraps>

80105be2 <vector123>:
.globl vector123
vector123:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $123
80105be4:	6a 7b                	push   $0x7b
  jmp alltraps
80105be6:	e9 f7 f6 ff ff       	jmp    801052e2 <alltraps>

80105beb <vector124>:
.globl vector124
vector124:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $124
80105bed:	6a 7c                	push   $0x7c
  jmp alltraps
80105bef:	e9 ee f6 ff ff       	jmp    801052e2 <alltraps>

80105bf4 <vector125>:
.globl vector125
vector125:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $125
80105bf6:	6a 7d                	push   $0x7d
  jmp alltraps
80105bf8:	e9 e5 f6 ff ff       	jmp    801052e2 <alltraps>

80105bfd <vector126>:
.globl vector126
vector126:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $126
80105bff:	6a 7e                	push   $0x7e
  jmp alltraps
80105c01:	e9 dc f6 ff ff       	jmp    801052e2 <alltraps>

80105c06 <vector127>:
.globl vector127
vector127:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $127
80105c08:	6a 7f                	push   $0x7f
  jmp alltraps
80105c0a:	e9 d3 f6 ff ff       	jmp    801052e2 <alltraps>

80105c0f <vector128>:
.globl vector128
vector128:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $128
80105c11:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105c16:	e9 c7 f6 ff ff       	jmp    801052e2 <alltraps>

80105c1b <vector129>:
.globl vector129
vector129:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $129
80105c1d:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105c22:	e9 bb f6 ff ff       	jmp    801052e2 <alltraps>

80105c27 <vector130>:
.globl vector130
vector130:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $130
80105c29:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105c2e:	e9 af f6 ff ff       	jmp    801052e2 <alltraps>

80105c33 <vector131>:
.globl vector131
vector131:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $131
80105c35:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105c3a:	e9 a3 f6 ff ff       	jmp    801052e2 <alltraps>

80105c3f <vector132>:
.globl vector132
vector132:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $132
80105c41:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105c46:	e9 97 f6 ff ff       	jmp    801052e2 <alltraps>

80105c4b <vector133>:
.globl vector133
vector133:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $133
80105c4d:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105c52:	e9 8b f6 ff ff       	jmp    801052e2 <alltraps>

80105c57 <vector134>:
.globl vector134
vector134:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $134
80105c59:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105c5e:	e9 7f f6 ff ff       	jmp    801052e2 <alltraps>

80105c63 <vector135>:
.globl vector135
vector135:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $135
80105c65:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105c6a:	e9 73 f6 ff ff       	jmp    801052e2 <alltraps>

80105c6f <vector136>:
.globl vector136
vector136:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $136
80105c71:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105c76:	e9 67 f6 ff ff       	jmp    801052e2 <alltraps>

80105c7b <vector137>:
.globl vector137
vector137:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $137
80105c7d:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105c82:	e9 5b f6 ff ff       	jmp    801052e2 <alltraps>

80105c87 <vector138>:
.globl vector138
vector138:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $138
80105c89:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c8e:	e9 4f f6 ff ff       	jmp    801052e2 <alltraps>

80105c93 <vector139>:
.globl vector139
vector139:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $139
80105c95:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c9a:	e9 43 f6 ff ff       	jmp    801052e2 <alltraps>

80105c9f <vector140>:
.globl vector140
vector140:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $140
80105ca1:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105ca6:	e9 37 f6 ff ff       	jmp    801052e2 <alltraps>

80105cab <vector141>:
.globl vector141
vector141:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $141
80105cad:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105cb2:	e9 2b f6 ff ff       	jmp    801052e2 <alltraps>

80105cb7 <vector142>:
.globl vector142
vector142:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $142
80105cb9:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105cbe:	e9 1f f6 ff ff       	jmp    801052e2 <alltraps>

80105cc3 <vector143>:
.globl vector143
vector143:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $143
80105cc5:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105cca:	e9 13 f6 ff ff       	jmp    801052e2 <alltraps>

80105ccf <vector144>:
.globl vector144
vector144:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $144
80105cd1:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105cd6:	e9 07 f6 ff ff       	jmp    801052e2 <alltraps>

80105cdb <vector145>:
.globl vector145
vector145:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $145
80105cdd:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ce2:	e9 fb f5 ff ff       	jmp    801052e2 <alltraps>

80105ce7 <vector146>:
.globl vector146
vector146:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $146
80105ce9:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105cee:	e9 ef f5 ff ff       	jmp    801052e2 <alltraps>

80105cf3 <vector147>:
.globl vector147
vector147:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $147
80105cf5:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105cfa:	e9 e3 f5 ff ff       	jmp    801052e2 <alltraps>

80105cff <vector148>:
.globl vector148
vector148:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $148
80105d01:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105d06:	e9 d7 f5 ff ff       	jmp    801052e2 <alltraps>

80105d0b <vector149>:
.globl vector149
vector149:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $149
80105d0d:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105d12:	e9 cb f5 ff ff       	jmp    801052e2 <alltraps>

80105d17 <vector150>:
.globl vector150
vector150:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $150
80105d19:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105d1e:	e9 bf f5 ff ff       	jmp    801052e2 <alltraps>

80105d23 <vector151>:
.globl vector151
vector151:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $151
80105d25:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105d2a:	e9 b3 f5 ff ff       	jmp    801052e2 <alltraps>

80105d2f <vector152>:
.globl vector152
vector152:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $152
80105d31:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105d36:	e9 a7 f5 ff ff       	jmp    801052e2 <alltraps>

80105d3b <vector153>:
.globl vector153
vector153:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $153
80105d3d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105d42:	e9 9b f5 ff ff       	jmp    801052e2 <alltraps>

80105d47 <vector154>:
.globl vector154
vector154:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $154
80105d49:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105d4e:	e9 8f f5 ff ff       	jmp    801052e2 <alltraps>

80105d53 <vector155>:
.globl vector155
vector155:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $155
80105d55:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105d5a:	e9 83 f5 ff ff       	jmp    801052e2 <alltraps>

80105d5f <vector156>:
.globl vector156
vector156:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $156
80105d61:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105d66:	e9 77 f5 ff ff       	jmp    801052e2 <alltraps>

80105d6b <vector157>:
.globl vector157
vector157:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $157
80105d6d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105d72:	e9 6b f5 ff ff       	jmp    801052e2 <alltraps>

80105d77 <vector158>:
.globl vector158
vector158:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $158
80105d79:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105d7e:	e9 5f f5 ff ff       	jmp    801052e2 <alltraps>

80105d83 <vector159>:
.globl vector159
vector159:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $159
80105d85:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105d8a:	e9 53 f5 ff ff       	jmp    801052e2 <alltraps>

80105d8f <vector160>:
.globl vector160
vector160:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $160
80105d91:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d96:	e9 47 f5 ff ff       	jmp    801052e2 <alltraps>

80105d9b <vector161>:
.globl vector161
vector161:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $161
80105d9d:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105da2:	e9 3b f5 ff ff       	jmp    801052e2 <alltraps>

80105da7 <vector162>:
.globl vector162
vector162:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $162
80105da9:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105dae:	e9 2f f5 ff ff       	jmp    801052e2 <alltraps>

80105db3 <vector163>:
.globl vector163
vector163:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $163
80105db5:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105dba:	e9 23 f5 ff ff       	jmp    801052e2 <alltraps>

80105dbf <vector164>:
.globl vector164
vector164:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $164
80105dc1:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105dc6:	e9 17 f5 ff ff       	jmp    801052e2 <alltraps>

80105dcb <vector165>:
.globl vector165
vector165:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $165
80105dcd:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105dd2:	e9 0b f5 ff ff       	jmp    801052e2 <alltraps>

80105dd7 <vector166>:
.globl vector166
vector166:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $166
80105dd9:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105dde:	e9 ff f4 ff ff       	jmp    801052e2 <alltraps>

80105de3 <vector167>:
.globl vector167
vector167:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $167
80105de5:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105dea:	e9 f3 f4 ff ff       	jmp    801052e2 <alltraps>

80105def <vector168>:
.globl vector168
vector168:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $168
80105df1:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105df6:	e9 e7 f4 ff ff       	jmp    801052e2 <alltraps>

80105dfb <vector169>:
.globl vector169
vector169:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $169
80105dfd:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105e02:	e9 db f4 ff ff       	jmp    801052e2 <alltraps>

80105e07 <vector170>:
.globl vector170
vector170:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $170
80105e09:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105e0e:	e9 cf f4 ff ff       	jmp    801052e2 <alltraps>

80105e13 <vector171>:
.globl vector171
vector171:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $171
80105e15:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105e1a:	e9 c3 f4 ff ff       	jmp    801052e2 <alltraps>

80105e1f <vector172>:
.globl vector172
vector172:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $172
80105e21:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105e26:	e9 b7 f4 ff ff       	jmp    801052e2 <alltraps>

80105e2b <vector173>:
.globl vector173
vector173:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $173
80105e2d:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105e32:	e9 ab f4 ff ff       	jmp    801052e2 <alltraps>

80105e37 <vector174>:
.globl vector174
vector174:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $174
80105e39:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105e3e:	e9 9f f4 ff ff       	jmp    801052e2 <alltraps>

80105e43 <vector175>:
.globl vector175
vector175:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $175
80105e45:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105e4a:	e9 93 f4 ff ff       	jmp    801052e2 <alltraps>

80105e4f <vector176>:
.globl vector176
vector176:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $176
80105e51:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105e56:	e9 87 f4 ff ff       	jmp    801052e2 <alltraps>

80105e5b <vector177>:
.globl vector177
vector177:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $177
80105e5d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105e62:	e9 7b f4 ff ff       	jmp    801052e2 <alltraps>

80105e67 <vector178>:
.globl vector178
vector178:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $178
80105e69:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105e6e:	e9 6f f4 ff ff       	jmp    801052e2 <alltraps>

80105e73 <vector179>:
.globl vector179
vector179:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $179
80105e75:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105e7a:	e9 63 f4 ff ff       	jmp    801052e2 <alltraps>

80105e7f <vector180>:
.globl vector180
vector180:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $180
80105e81:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105e86:	e9 57 f4 ff ff       	jmp    801052e2 <alltraps>

80105e8b <vector181>:
.globl vector181
vector181:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $181
80105e8d:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e92:	e9 4b f4 ff ff       	jmp    801052e2 <alltraps>

80105e97 <vector182>:
.globl vector182
vector182:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $182
80105e99:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e9e:	e9 3f f4 ff ff       	jmp    801052e2 <alltraps>

80105ea3 <vector183>:
.globl vector183
vector183:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $183
80105ea5:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105eaa:	e9 33 f4 ff ff       	jmp    801052e2 <alltraps>

80105eaf <vector184>:
.globl vector184
vector184:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $184
80105eb1:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105eb6:	e9 27 f4 ff ff       	jmp    801052e2 <alltraps>

80105ebb <vector185>:
.globl vector185
vector185:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $185
80105ebd:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105ec2:	e9 1b f4 ff ff       	jmp    801052e2 <alltraps>

80105ec7 <vector186>:
.globl vector186
vector186:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $186
80105ec9:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105ece:	e9 0f f4 ff ff       	jmp    801052e2 <alltraps>

80105ed3 <vector187>:
.globl vector187
vector187:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $187
80105ed5:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105eda:	e9 03 f4 ff ff       	jmp    801052e2 <alltraps>

80105edf <vector188>:
.globl vector188
vector188:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $188
80105ee1:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105ee6:	e9 f7 f3 ff ff       	jmp    801052e2 <alltraps>

80105eeb <vector189>:
.globl vector189
vector189:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $189
80105eed:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ef2:	e9 eb f3 ff ff       	jmp    801052e2 <alltraps>

80105ef7 <vector190>:
.globl vector190
vector190:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $190
80105ef9:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105efe:	e9 df f3 ff ff       	jmp    801052e2 <alltraps>

80105f03 <vector191>:
.globl vector191
vector191:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $191
80105f05:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105f0a:	e9 d3 f3 ff ff       	jmp    801052e2 <alltraps>

80105f0f <vector192>:
.globl vector192
vector192:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $192
80105f11:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105f16:	e9 c7 f3 ff ff       	jmp    801052e2 <alltraps>

80105f1b <vector193>:
.globl vector193
vector193:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $193
80105f1d:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105f22:	e9 bb f3 ff ff       	jmp    801052e2 <alltraps>

80105f27 <vector194>:
.globl vector194
vector194:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $194
80105f29:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105f2e:	e9 af f3 ff ff       	jmp    801052e2 <alltraps>

80105f33 <vector195>:
.globl vector195
vector195:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $195
80105f35:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105f3a:	e9 a3 f3 ff ff       	jmp    801052e2 <alltraps>

80105f3f <vector196>:
.globl vector196
vector196:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $196
80105f41:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105f46:	e9 97 f3 ff ff       	jmp    801052e2 <alltraps>

80105f4b <vector197>:
.globl vector197
vector197:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $197
80105f4d:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105f52:	e9 8b f3 ff ff       	jmp    801052e2 <alltraps>

80105f57 <vector198>:
.globl vector198
vector198:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $198
80105f59:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105f5e:	e9 7f f3 ff ff       	jmp    801052e2 <alltraps>

80105f63 <vector199>:
.globl vector199
vector199:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $199
80105f65:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105f6a:	e9 73 f3 ff ff       	jmp    801052e2 <alltraps>

80105f6f <vector200>:
.globl vector200
vector200:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $200
80105f71:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105f76:	e9 67 f3 ff ff       	jmp    801052e2 <alltraps>

80105f7b <vector201>:
.globl vector201
vector201:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $201
80105f7d:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105f82:	e9 5b f3 ff ff       	jmp    801052e2 <alltraps>

80105f87 <vector202>:
.globl vector202
vector202:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $202
80105f89:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f8e:	e9 4f f3 ff ff       	jmp    801052e2 <alltraps>

80105f93 <vector203>:
.globl vector203
vector203:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $203
80105f95:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f9a:	e9 43 f3 ff ff       	jmp    801052e2 <alltraps>

80105f9f <vector204>:
.globl vector204
vector204:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $204
80105fa1:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105fa6:	e9 37 f3 ff ff       	jmp    801052e2 <alltraps>

80105fab <vector205>:
.globl vector205
vector205:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $205
80105fad:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105fb2:	e9 2b f3 ff ff       	jmp    801052e2 <alltraps>

80105fb7 <vector206>:
.globl vector206
vector206:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $206
80105fb9:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105fbe:	e9 1f f3 ff ff       	jmp    801052e2 <alltraps>

80105fc3 <vector207>:
.globl vector207
vector207:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $207
80105fc5:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105fca:	e9 13 f3 ff ff       	jmp    801052e2 <alltraps>

80105fcf <vector208>:
.globl vector208
vector208:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $208
80105fd1:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105fd6:	e9 07 f3 ff ff       	jmp    801052e2 <alltraps>

80105fdb <vector209>:
.globl vector209
vector209:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $209
80105fdd:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105fe2:	e9 fb f2 ff ff       	jmp    801052e2 <alltraps>

80105fe7 <vector210>:
.globl vector210
vector210:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $210
80105fe9:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105fee:	e9 ef f2 ff ff       	jmp    801052e2 <alltraps>

80105ff3 <vector211>:
.globl vector211
vector211:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $211
80105ff5:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105ffa:	e9 e3 f2 ff ff       	jmp    801052e2 <alltraps>

80105fff <vector212>:
.globl vector212
vector212:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $212
80106001:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106006:	e9 d7 f2 ff ff       	jmp    801052e2 <alltraps>

8010600b <vector213>:
.globl vector213
vector213:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $213
8010600d:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106012:	e9 cb f2 ff ff       	jmp    801052e2 <alltraps>

80106017 <vector214>:
.globl vector214
vector214:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $214
80106019:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010601e:	e9 bf f2 ff ff       	jmp    801052e2 <alltraps>

80106023 <vector215>:
.globl vector215
vector215:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $215
80106025:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010602a:	e9 b3 f2 ff ff       	jmp    801052e2 <alltraps>

8010602f <vector216>:
.globl vector216
vector216:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $216
80106031:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106036:	e9 a7 f2 ff ff       	jmp    801052e2 <alltraps>

8010603b <vector217>:
.globl vector217
vector217:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $217
8010603d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106042:	e9 9b f2 ff ff       	jmp    801052e2 <alltraps>

80106047 <vector218>:
.globl vector218
vector218:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $218
80106049:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010604e:	e9 8f f2 ff ff       	jmp    801052e2 <alltraps>

80106053 <vector219>:
.globl vector219
vector219:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $219
80106055:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010605a:	e9 83 f2 ff ff       	jmp    801052e2 <alltraps>

8010605f <vector220>:
.globl vector220
vector220:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $220
80106061:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106066:	e9 77 f2 ff ff       	jmp    801052e2 <alltraps>

8010606b <vector221>:
.globl vector221
vector221:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $221
8010606d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106072:	e9 6b f2 ff ff       	jmp    801052e2 <alltraps>

80106077 <vector222>:
.globl vector222
vector222:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $222
80106079:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010607e:	e9 5f f2 ff ff       	jmp    801052e2 <alltraps>

80106083 <vector223>:
.globl vector223
vector223:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $223
80106085:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010608a:	e9 53 f2 ff ff       	jmp    801052e2 <alltraps>

8010608f <vector224>:
.globl vector224
vector224:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $224
80106091:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106096:	e9 47 f2 ff ff       	jmp    801052e2 <alltraps>

8010609b <vector225>:
.globl vector225
vector225:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $225
8010609d:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801060a2:	e9 3b f2 ff ff       	jmp    801052e2 <alltraps>

801060a7 <vector226>:
.globl vector226
vector226:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $226
801060a9:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801060ae:	e9 2f f2 ff ff       	jmp    801052e2 <alltraps>

801060b3 <vector227>:
.globl vector227
vector227:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $227
801060b5:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801060ba:	e9 23 f2 ff ff       	jmp    801052e2 <alltraps>

801060bf <vector228>:
.globl vector228
vector228:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $228
801060c1:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801060c6:	e9 17 f2 ff ff       	jmp    801052e2 <alltraps>

801060cb <vector229>:
.globl vector229
vector229:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $229
801060cd:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801060d2:	e9 0b f2 ff ff       	jmp    801052e2 <alltraps>

801060d7 <vector230>:
.globl vector230
vector230:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $230
801060d9:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801060de:	e9 ff f1 ff ff       	jmp    801052e2 <alltraps>

801060e3 <vector231>:
.globl vector231
vector231:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $231
801060e5:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801060ea:	e9 f3 f1 ff ff       	jmp    801052e2 <alltraps>

801060ef <vector232>:
.globl vector232
vector232:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $232
801060f1:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801060f6:	e9 e7 f1 ff ff       	jmp    801052e2 <alltraps>

801060fb <vector233>:
.globl vector233
vector233:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $233
801060fd:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106102:	e9 db f1 ff ff       	jmp    801052e2 <alltraps>

80106107 <vector234>:
.globl vector234
vector234:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $234
80106109:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010610e:	e9 cf f1 ff ff       	jmp    801052e2 <alltraps>

80106113 <vector235>:
.globl vector235
vector235:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $235
80106115:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010611a:	e9 c3 f1 ff ff       	jmp    801052e2 <alltraps>

8010611f <vector236>:
.globl vector236
vector236:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $236
80106121:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106126:	e9 b7 f1 ff ff       	jmp    801052e2 <alltraps>

8010612b <vector237>:
.globl vector237
vector237:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $237
8010612d:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106132:	e9 ab f1 ff ff       	jmp    801052e2 <alltraps>

80106137 <vector238>:
.globl vector238
vector238:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $238
80106139:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010613e:	e9 9f f1 ff ff       	jmp    801052e2 <alltraps>

80106143 <vector239>:
.globl vector239
vector239:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $239
80106145:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010614a:	e9 93 f1 ff ff       	jmp    801052e2 <alltraps>

8010614f <vector240>:
.globl vector240
vector240:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $240
80106151:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106156:	e9 87 f1 ff ff       	jmp    801052e2 <alltraps>

8010615b <vector241>:
.globl vector241
vector241:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $241
8010615d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106162:	e9 7b f1 ff ff       	jmp    801052e2 <alltraps>

80106167 <vector242>:
.globl vector242
vector242:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $242
80106169:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010616e:	e9 6f f1 ff ff       	jmp    801052e2 <alltraps>

80106173 <vector243>:
.globl vector243
vector243:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $243
80106175:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010617a:	e9 63 f1 ff ff       	jmp    801052e2 <alltraps>

8010617f <vector244>:
.globl vector244
vector244:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $244
80106181:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106186:	e9 57 f1 ff ff       	jmp    801052e2 <alltraps>

8010618b <vector245>:
.globl vector245
vector245:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $245
8010618d:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106192:	e9 4b f1 ff ff       	jmp    801052e2 <alltraps>

80106197 <vector246>:
.globl vector246
vector246:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $246
80106199:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010619e:	e9 3f f1 ff ff       	jmp    801052e2 <alltraps>

801061a3 <vector247>:
.globl vector247
vector247:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $247
801061a5:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801061aa:	e9 33 f1 ff ff       	jmp    801052e2 <alltraps>

801061af <vector248>:
.globl vector248
vector248:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $248
801061b1:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801061b6:	e9 27 f1 ff ff       	jmp    801052e2 <alltraps>

801061bb <vector249>:
.globl vector249
vector249:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $249
801061bd:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801061c2:	e9 1b f1 ff ff       	jmp    801052e2 <alltraps>

801061c7 <vector250>:
.globl vector250
vector250:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $250
801061c9:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801061ce:	e9 0f f1 ff ff       	jmp    801052e2 <alltraps>

801061d3 <vector251>:
.globl vector251
vector251:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $251
801061d5:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801061da:	e9 03 f1 ff ff       	jmp    801052e2 <alltraps>

801061df <vector252>:
.globl vector252
vector252:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $252
801061e1:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801061e6:	e9 f7 f0 ff ff       	jmp    801052e2 <alltraps>

801061eb <vector253>:
.globl vector253
vector253:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $253
801061ed:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801061f2:	e9 eb f0 ff ff       	jmp    801052e2 <alltraps>

801061f7 <vector254>:
.globl vector254
vector254:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $254
801061f9:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801061fe:	e9 df f0 ff ff       	jmp    801052e2 <alltraps>

80106203 <vector255>:
.globl vector255
vector255:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $255
80106205:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010620a:	e9 d3 f0 ff ff       	jmp    801052e2 <alltraps>
8010620f:	90                   	nop

80106210 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	57                   	push   %edi
80106214:	56                   	push   %esi
80106215:	53                   	push   %ebx
80106216:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106219:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010621f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106225:	39 d3                	cmp    %edx,%ebx
80106227:	73 50                	jae    80106279 <deallocuvm.part.0+0x69>
80106229:	89 c6                	mov    %eax,%esi
8010622b:	89 d7                	mov    %edx,%edi
8010622d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106230:	eb 0c                	jmp    8010623e <deallocuvm.part.0+0x2e>
80106232:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106234:	42                   	inc    %edx
80106235:	89 d3                	mov    %edx,%ebx
80106237:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010623a:	39 fb                	cmp    %edi,%ebx
8010623c:	73 38                	jae    80106276 <deallocuvm.part.0+0x66>
  pde = &pgdir[PDX(va)];
8010623e:	89 da                	mov    %ebx,%edx
80106240:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106243:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106246:	a8 01                	test   $0x1,%al
80106248:	74 ea                	je     80106234 <deallocuvm.part.0+0x24>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010624a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010624f:	89 d9                	mov    %ebx,%ecx
80106251:	c1 e9 0a             	shr    $0xa,%ecx
80106254:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
8010625a:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106261:	85 c0                	test   %eax,%eax
80106263:	74 cf                	je     80106234 <deallocuvm.part.0+0x24>
    else if((*pte & PTE_P) != 0){
80106265:	8b 10                	mov    (%eax),%edx
80106267:	f6 c2 01             	test   $0x1,%dl
8010626a:	75 18                	jne    80106284 <deallocuvm.part.0+0x74>
  for(; a  < oldsz; a += PGSIZE){
8010626c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106272:	39 fb                	cmp    %edi,%ebx
80106274:	72 c8                	jb     8010623e <deallocuvm.part.0+0x2e>
80106276:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106279:	89 c8                	mov    %ecx,%eax
8010627b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010627e:	5b                   	pop    %ebx
8010627f:	5e                   	pop    %esi
80106280:	5f                   	pop    %edi
80106281:	5d                   	pop    %ebp
80106282:	c3                   	ret
80106283:	90                   	nop
      if(pa == 0)
80106284:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010628a:	74 26                	je     801062b2 <deallocuvm.part.0+0xa2>
8010628c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010628f:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106292:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106298:	52                   	push   %edx
80106299:	e8 66 bf ff ff       	call   80102204 <kfree>
      *pte = 0;
8010629e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801062a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801062ad:	83 c4 10             	add    $0x10,%esp
801062b0:	eb 88                	jmp    8010623a <deallocuvm.part.0+0x2a>
        panic("kfree");
801062b2:	83 ec 0c             	sub    $0xc,%esp
801062b5:	68 ac 6c 10 80       	push   $0x80106cac
801062ba:	e8 79 a0 ff ff       	call   80100338 <panic>
801062bf:	90                   	nop

801062c0 <mappages>:
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
801062c6:	83 ec 1c             	sub    $0x1c,%esp
801062c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
801062cc:	89 d3                	mov    %edx,%ebx
801062ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801062d4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801062d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801062dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062e0:	8b 45 08             	mov    0x8(%ebp),%eax
801062e3:	29 d8                	sub    %ebx,%eax
801062e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801062e8:	eb 3b                	jmp    80106325 <mappages+0x65>
801062ea:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801062ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801062f1:	89 da                	mov    %ebx,%edx
801062f3:	c1 ea 0a             	shr    $0xa,%edx
801062f6:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801062fc:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106303:	85 c0                	test   %eax,%eax
80106305:	74 71                	je     80106378 <mappages+0xb8>
    if(*pte & PTE_P)
80106307:	f6 00 01             	testb  $0x1,(%eax)
8010630a:	0f 85 82 00 00 00    	jne    80106392 <mappages+0xd2>
    *pte = pa | perm | PTE_P;
80106310:	0b 75 0c             	or     0xc(%ebp),%esi
80106313:	83 ce 01             	or     $0x1,%esi
80106316:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106318:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010631b:	39 c3                	cmp    %eax,%ebx
8010631d:	74 69                	je     80106388 <mappages+0xc8>
    a += PGSIZE;
8010631f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106328:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  pde = &pgdir[PDX(va)];
8010632b:	89 d8                	mov    %ebx,%eax
8010632d:	c1 e8 16             	shr    $0x16,%eax
80106330:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106333:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106336:	8b 07                	mov    (%edi),%eax
80106338:	a8 01                	test   $0x1,%al
8010633a:	75 b0                	jne    801062ec <mappages+0x2c>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010633c:	e8 53 c0 ff ff       	call   80102394 <kalloc>
80106341:	89 c2                	mov    %eax,%edx
80106343:	85 c0                	test   %eax,%eax
80106345:	74 31                	je     80106378 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
80106347:	50                   	push   %eax
80106348:	68 00 10 00 00       	push   $0x1000
8010634d:	6a 00                	push   $0x0
8010634f:	52                   	push   %edx
80106350:	89 55 d8             	mov    %edx,-0x28(%ebp)
80106353:	e8 e8 df ff ff       	call   80104340 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106358:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010635b:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106361:	83 c8 07             	or     $0x7,%eax
80106364:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106366:	89 d8                	mov    %ebx,%eax
80106368:	c1 e8 0a             	shr    $0xa,%eax
8010636b:	25 fc 0f 00 00       	and    $0xffc,%eax
80106370:	01 d0                	add    %edx,%eax
80106372:	83 c4 10             	add    $0x10,%esp
80106375:	eb 90                	jmp    80106307 <mappages+0x47>
80106377:	90                   	nop
      return -1;
80106378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010637d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106380:	5b                   	pop    %ebx
80106381:	5e                   	pop    %esi
80106382:	5f                   	pop    %edi
80106383:	5d                   	pop    %ebp
80106384:	c3                   	ret
80106385:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
80106388:	31 c0                	xor    %eax,%eax
}
8010638a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010638d:	5b                   	pop    %ebx
8010638e:	5e                   	pop    %esi
8010638f:	5f                   	pop    %edi
80106390:	5d                   	pop    %ebp
80106391:	c3                   	ret
      panic("remap");
80106392:	83 ec 0c             	sub    $0xc,%esp
80106395:	68 3c 6f 10 80       	push   $0x80106f3c
8010639a:	e8 99 9f ff ff       	call   80100338 <panic>
8010639f:	90                   	nop

801063a0 <seginit>:
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801063a6:	e8 19 d1 ff ff       	call   801034c4 <cpuid>
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801063ab:	8d 14 80             	lea    (%eax,%eax,4),%edx
801063ae:	01 d2                	add    %edx,%edx
801063b0:	01 d0                	add    %edx,%eax
801063b2:	c1 e0 04             	shl    $0x4,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801063b5:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801063bc:	ff 00 00 
801063bf:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801063c6:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801063c9:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
801063d0:	ff 00 00 
801063d3:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
801063da:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801063dd:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
801063e4:	ff 00 00 
801063e7:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
801063ee:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801063f1:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
801063f8:	ff 00 00 
801063fb:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106402:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106405:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[0] = size-1;
8010640a:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106410:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106414:	c1 e8 10             	shr    $0x10,%eax
80106417:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010641b:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010641e:	0f 01 10             	lgdtl  (%eax)
}
80106421:	c9                   	leave
80106422:	c3                   	ret
80106423:	90                   	nop

80106424 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106424:	a1 c4 4e 11 80       	mov    0x80114ec4,%eax
80106429:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010642e:	0f 22 d8             	mov    %eax,%cr3
}
80106431:	c3                   	ret
80106432:	66 90                	xchg   %ax,%ax

80106434 <switchuvm>:
{
80106434:	55                   	push   %ebp
80106435:	89 e5                	mov    %esp,%ebp
80106437:	57                   	push   %edi
80106438:	56                   	push   %esi
80106439:	53                   	push   %ebx
8010643a:	83 ec 1c             	sub    $0x1c,%esp
8010643d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106440:	85 f6                	test   %esi,%esi
80106442:	0f 84 bf 00 00 00    	je     80106507 <switchuvm+0xd3>
  if(p->kstack == 0)
80106448:	8b 56 30             	mov    0x30(%esi),%edx
8010644b:	85 d2                	test   %edx,%edx
8010644d:	0f 84 ce 00 00 00    	je     80106521 <switchuvm+0xed>
  if(p->pgdir == 0)
80106453:	8b 46 2c             	mov    0x2c(%esi),%eax
80106456:	85 c0                	test   %eax,%eax
80106458:	0f 84 b6 00 00 00    	je     80106514 <switchuvm+0xe0>
  pushcli();
8010645e:	e8 cd dc ff ff       	call   80104130 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106463:	e8 f8 cf ff ff       	call   80103460 <mycpu>
80106468:	89 c3                	mov    %eax,%ebx
8010646a:	e8 f1 cf ff ff       	call   80103460 <mycpu>
8010646f:	89 c7                	mov    %eax,%edi
80106471:	e8 ea cf ff ff       	call   80103460 <mycpu>
80106476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106479:	e8 e2 cf ff ff       	call   80103460 <mycpu>
8010647e:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106485:	67 00 
80106487:	83 c7 08             	add    $0x8,%edi
8010648a:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106491:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106494:	83 c1 08             	add    $0x8,%ecx
80106497:	c1 e9 10             	shr    $0x10,%ecx
8010649a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801064a0:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
801064a7:	99 40 
801064a9:	83 c0 08             	add    $0x8,%eax
801064ac:	c1 e8 18             	shr    $0x18,%eax
801064af:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
801064b5:	e8 a6 cf ff ff       	call   80103460 <mycpu>
801064ba:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801064c1:	e8 9a cf ff ff       	call   80103460 <mycpu>
801064c6:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801064cc:	8b 5e 30             	mov    0x30(%esi),%ebx
801064cf:	e8 8c cf ff ff       	call   80103460 <mycpu>
801064d4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064da:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801064dd:	e8 7e cf ff ff       	call   80103460 <mycpu>
801064e2:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801064e8:	b8 28 00 00 00       	mov    $0x28,%eax
801064ed:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801064f0:	8b 46 2c             	mov    0x2c(%esi),%eax
801064f3:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801064f8:	0f 22 d8             	mov    %eax,%cr3
}
801064fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064fe:	5b                   	pop    %ebx
801064ff:	5e                   	pop    %esi
80106500:	5f                   	pop    %edi
80106501:	5d                   	pop    %ebp
  popcli();
80106502:	e9 75 dc ff ff       	jmp    8010417c <popcli>
    panic("switchuvm: no process");
80106507:	83 ec 0c             	sub    $0xc,%esp
8010650a:	68 42 6f 10 80       	push   $0x80106f42
8010650f:	e8 24 9e ff ff       	call   80100338 <panic>
    panic("switchuvm: no pgdir");
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	68 6d 6f 10 80       	push   $0x80106f6d
8010651c:	e8 17 9e ff ff       	call   80100338 <panic>
    panic("switchuvm: no kstack");
80106521:	83 ec 0c             	sub    $0xc,%esp
80106524:	68 58 6f 10 80       	push   $0x80106f58
80106529:	e8 0a 9e ff ff       	call   80100338 <panic>
8010652e:	66 90                	xchg   %ax,%ax

80106530 <inituvm>:
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	57                   	push   %edi
80106534:	56                   	push   %esi
80106535:	53                   	push   %ebx
80106536:	83 ec 1c             	sub    $0x1c,%esp
80106539:	8b 45 08             	mov    0x8(%ebp),%eax
8010653c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010653f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106542:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
80106545:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010654b:	77 47                	ja     80106594 <inituvm+0x64>
  mem = kalloc();
8010654d:	e8 42 be ff ff       	call   80102394 <kalloc>
80106552:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106554:	50                   	push   %eax
80106555:	68 00 10 00 00       	push   $0x1000
8010655a:	6a 00                	push   $0x0
8010655c:	53                   	push   %ebx
8010655d:	e8 de dd ff ff       	call   80104340 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106562:	5a                   	pop    %edx
80106563:	59                   	pop    %ecx
80106564:	6a 06                	push   $0x6
80106566:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010656c:	50                   	push   %eax
8010656d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106572:	31 d2                	xor    %edx,%edx
80106574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106577:	e8 44 fd ff ff       	call   801062c0 <mappages>
  memmove(mem, init, sz);
8010657c:	83 c4 10             	add    $0x10,%esp
8010657f:	89 75 10             	mov    %esi,0x10(%ebp)
80106582:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106585:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106588:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010658b:	5b                   	pop    %ebx
8010658c:	5e                   	pop    %esi
8010658d:	5f                   	pop    %edi
8010658e:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010658f:	e9 28 de ff ff       	jmp    801043bc <memmove>
    panic("inituvm: more than a page");
80106594:	83 ec 0c             	sub    $0xc,%esp
80106597:	68 81 6f 10 80       	push   $0x80106f81
8010659c:	e8 97 9d ff ff       	call   80100338 <panic>
801065a1:	8d 76 00             	lea    0x0(%esi),%esi

801065a4 <loaduvm>:
{
801065a4:	55                   	push   %ebp
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	57                   	push   %edi
801065a8:	56                   	push   %esi
801065a9:	53                   	push   %ebx
801065aa:	83 ec 0c             	sub    $0xc,%esp
801065ad:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
801065b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801065b3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801065b9:	0f 85 9a 00 00 00    	jne    80106659 <loaduvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
801065bf:	85 ff                	test   %edi,%edi
801065c1:	74 7c                	je     8010663f <loaduvm+0x9b>
801065c3:	90                   	nop
  pde = &pgdir[PDX(va)];
801065c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801065c7:	01 d8                	add    %ebx,%eax
801065c9:	89 c2                	mov    %eax,%edx
801065cb:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801065ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801065d1:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801065d4:	f6 c2 01             	test   $0x1,%dl
801065d7:	75 0f                	jne    801065e8 <loaduvm+0x44>
      panic("loaduvm: address should exist");
801065d9:	83 ec 0c             	sub    $0xc,%esp
801065dc:	68 9b 6f 10 80       	push   $0x80106f9b
801065e1:	e8 52 9d ff ff       	call   80100338 <panic>
801065e6:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801065e8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801065ee:	c1 e8 0a             	shr    $0xa,%eax
801065f1:	25 fc 0f 00 00       	and    $0xffc,%eax
801065f6:	8d 8c 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801065fd:	85 c9                	test   %ecx,%ecx
801065ff:	74 d8                	je     801065d9 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106601:	89 fe                	mov    %edi,%esi
80106603:	29 de                	sub    %ebx,%esi
80106605:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
8010660b:	76 05                	jbe    80106612 <loaduvm+0x6e>
8010660d:	be 00 10 00 00       	mov    $0x1000,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106612:	56                   	push   %esi
80106613:	8b 45 14             	mov    0x14(%ebp),%eax
80106616:	01 d8                	add    %ebx,%eax
80106618:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106619:	8b 01                	mov    (%ecx),%eax
8010661b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106620:	05 00 00 00 80       	add    $0x80000000,%eax
80106625:	50                   	push   %eax
80106626:	ff 75 10             	push   0x10(%ebp)
80106629:	e8 c2 b2 ff ff       	call   801018f0 <readi>
8010662e:	83 c4 10             	add    $0x10,%esp
80106631:	39 f0                	cmp    %esi,%eax
80106633:	75 17                	jne    8010664c <loaduvm+0xa8>
  for(i = 0; i < sz; i += PGSIZE){
80106635:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010663b:	39 fb                	cmp    %edi,%ebx
8010663d:	72 85                	jb     801065c4 <loaduvm+0x20>
  return 0;
8010663f:	31 c0                	xor    %eax,%eax
}
80106641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106644:	5b                   	pop    %ebx
80106645:	5e                   	pop    %esi
80106646:	5f                   	pop    %edi
80106647:	5d                   	pop    %ebp
80106648:	c3                   	ret
80106649:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
8010664c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106654:	5b                   	pop    %ebx
80106655:	5e                   	pop    %esi
80106656:	5f                   	pop    %edi
80106657:	5d                   	pop    %ebp
80106658:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	68 9c 71 10 80       	push   $0x8010719c
80106661:	e8 d2 9c ff ff       	call   80100338 <panic>
80106666:	66 90                	xchg   %ax,%ax

80106668 <allocuvm>:
{
80106668:	55                   	push   %ebp
80106669:	89 e5                	mov    %esp,%ebp
8010666b:	57                   	push   %edi
8010666c:	56                   	push   %esi
8010666d:	53                   	push   %ebx
8010666e:	83 ec 1c             	sub    $0x1c,%esp
80106671:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106674:	85 f6                	test   %esi,%esi
80106676:	0f 88 91 00 00 00    	js     8010670d <allocuvm+0xa5>
8010667c:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
8010667e:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106681:	0f 82 95 00 00 00    	jb     8010671c <allocuvm+0xb4>
  a = PGROUNDUP(oldsz);
80106687:	8b 45 0c             	mov    0xc(%ebp),%eax
8010668a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010668f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106694:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106696:	39 f0                	cmp    %esi,%eax
80106698:	0f 83 81 00 00 00    	jae    8010671f <allocuvm+0xb7>
8010669e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801066a1:	eb 3d                	jmp    801066e0 <allocuvm+0x78>
801066a3:	90                   	nop
    memset(mem, 0, PGSIZE);
801066a4:	50                   	push   %eax
801066a5:	68 00 10 00 00       	push   $0x1000
801066aa:	6a 00                	push   $0x0
801066ac:	53                   	push   %ebx
801066ad:	e8 8e dc ff ff       	call   80104340 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801066b2:	5a                   	pop    %edx
801066b3:	59                   	pop    %ecx
801066b4:	6a 06                	push   $0x6
801066b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066bc:	50                   	push   %eax
801066bd:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066c2:	89 fa                	mov    %edi,%edx
801066c4:	8b 45 08             	mov    0x8(%ebp),%eax
801066c7:	e8 f4 fb ff ff       	call   801062c0 <mappages>
801066cc:	83 c4 10             	add    $0x10,%esp
801066cf:	40                   	inc    %eax
801066d0:	74 5a                	je     8010672c <allocuvm+0xc4>
  for(; a < newsz; a += PGSIZE){
801066d2:	81 c7 00 10 00 00    	add    $0x1000,%edi
801066d8:	39 f7                	cmp    %esi,%edi
801066da:	0f 83 80 00 00 00    	jae    80106760 <allocuvm+0xf8>
    mem = kalloc();
801066e0:	e8 af bc ff ff       	call   80102394 <kalloc>
801066e5:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801066e7:	85 c0                	test   %eax,%eax
801066e9:	75 b9                	jne    801066a4 <allocuvm+0x3c>
      cprintf("allocuvm out of memory\n");
801066eb:	83 ec 0c             	sub    $0xc,%esp
801066ee:	68 b9 6f 10 80       	push   $0x80106fb9
801066f3:	e8 28 9f ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
801066f8:	83 c4 10             	add    $0x10,%esp
801066fb:	3b 75 0c             	cmp    0xc(%ebp),%esi
801066fe:	74 0d                	je     8010670d <allocuvm+0xa5>
80106700:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106703:	89 f2                	mov    %esi,%edx
80106705:	8b 45 08             	mov    0x8(%ebp),%eax
80106708:	e8 03 fb ff ff       	call   80106210 <deallocuvm.part.0>
    return 0;
8010670d:	31 d2                	xor    %edx,%edx
}
8010670f:	89 d0                	mov    %edx,%eax
80106711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106714:	5b                   	pop    %ebx
80106715:	5e                   	pop    %esi
80106716:	5f                   	pop    %edi
80106717:	5d                   	pop    %ebp
80106718:	c3                   	ret
80106719:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
8010671c:	8b 55 0c             	mov    0xc(%ebp),%edx
}
8010671f:	89 d0                	mov    %edx,%eax
80106721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106724:	5b                   	pop    %ebx
80106725:	5e                   	pop    %esi
80106726:	5f                   	pop    %edi
80106727:	5d                   	pop    %ebp
80106728:	c3                   	ret
80106729:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
8010672c:	83 ec 0c             	sub    $0xc,%esp
8010672f:	68 d1 6f 10 80       	push   $0x80106fd1
80106734:	e8 e7 9e ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106739:	83 c4 10             	add    $0x10,%esp
8010673c:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010673f:	74 0d                	je     8010674e <allocuvm+0xe6>
80106741:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106744:	89 f2                	mov    %esi,%edx
80106746:	8b 45 08             	mov    0x8(%ebp),%eax
80106749:	e8 c2 fa ff ff       	call   80106210 <deallocuvm.part.0>
      kfree(mem);
8010674e:	83 ec 0c             	sub    $0xc,%esp
80106751:	53                   	push   %ebx
80106752:	e8 ad ba ff ff       	call   80102204 <kfree>
      return 0;
80106757:	83 c4 10             	add    $0x10,%esp
    return 0;
8010675a:	31 d2                	xor    %edx,%edx
8010675c:	eb b1                	jmp    8010670f <allocuvm+0xa7>
8010675e:	66 90                	xchg   %ax,%ax
80106760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106763:	89 d0                	mov    %edx,%eax
80106765:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106768:	5b                   	pop    %ebx
80106769:	5e                   	pop    %esi
8010676a:	5f                   	pop    %edi
8010676b:	5d                   	pop    %ebp
8010676c:	c3                   	ret
8010676d:	8d 76 00             	lea    0x0(%esi),%esi

80106770 <deallocuvm>:
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	8b 45 08             	mov    0x8(%ebp),%eax
80106776:	8b 55 0c             	mov    0xc(%ebp),%edx
80106779:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
8010677c:	39 d1                	cmp    %edx,%ecx
8010677e:	73 08                	jae    80106788 <deallocuvm+0x18>
}
80106780:	5d                   	pop    %ebp
80106781:	e9 8a fa ff ff       	jmp    80106210 <deallocuvm.part.0>
80106786:	66 90                	xchg   %ax,%ax
80106788:	89 d0                	mov    %edx,%eax
8010678a:	5d                   	pop    %ebp
8010678b:	c3                   	ret

8010678c <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010678c:	55                   	push   %ebp
8010678d:	89 e5                	mov    %esp,%ebp
8010678f:	57                   	push   %edi
80106790:	56                   	push   %esi
80106791:	53                   	push   %ebx
80106792:	83 ec 0c             	sub    $0xc,%esp
80106795:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106798:	85 f6                	test   %esi,%esi
8010679a:	74 51                	je     801067ed <freevm+0x61>
  if(newsz >= oldsz)
8010679c:	31 c9                	xor    %ecx,%ecx
8010679e:	ba 00 00 00 80       	mov    $0x80000000,%edx
801067a3:	89 f0                	mov    %esi,%eax
801067a5:	e8 66 fa ff ff       	call   80106210 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801067aa:	89 f3                	mov    %esi,%ebx
801067ac:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801067b2:	eb 07                	jmp    801067bb <freevm+0x2f>
801067b4:	83 c3 04             	add    $0x4,%ebx
801067b7:	39 fb                	cmp    %edi,%ebx
801067b9:	74 23                	je     801067de <freevm+0x52>
    if(pgdir[i] & PTE_P){
801067bb:	8b 03                	mov    (%ebx),%eax
801067bd:	a8 01                	test   $0x1,%al
801067bf:	74 f3                	je     801067b4 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801067c1:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801067c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067c9:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801067ce:	50                   	push   %eax
801067cf:	e8 30 ba ff ff       	call   80102204 <kfree>
801067d4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801067d7:	83 c3 04             	add    $0x4,%ebx
801067da:	39 fb                	cmp    %edi,%ebx
801067dc:	75 dd                	jne    801067bb <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
801067de:	89 75 08             	mov    %esi,0x8(%ebp)
}
801067e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067e4:	5b                   	pop    %ebx
801067e5:	5e                   	pop    %esi
801067e6:	5f                   	pop    %edi
801067e7:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801067e8:	e9 17 ba ff ff       	jmp    80102204 <kfree>
    panic("freevm: no pgdir");
801067ed:	83 ec 0c             	sub    $0xc,%esp
801067f0:	68 ed 6f 10 80       	push   $0x80106fed
801067f5:	e8 3e 9b ff ff       	call   80100338 <panic>
801067fa:	66 90                	xchg   %ax,%ax

801067fc <setupkvm>:
{
801067fc:	55                   	push   %ebp
801067fd:	89 e5                	mov    %esp,%ebp
801067ff:	56                   	push   %esi
80106800:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106801:	e8 8e bb ff ff       	call   80102394 <kalloc>
80106806:	85 c0                	test   %eax,%eax
80106808:	74 56                	je     80106860 <setupkvm+0x64>
8010680a:	89 c6                	mov    %eax,%esi
  memset(pgdir, 0, PGSIZE);
8010680c:	50                   	push   %eax
8010680d:	68 00 10 00 00       	push   $0x1000
80106812:	6a 00                	push   $0x0
80106814:	56                   	push   %esi
80106815:	e8 26 db ff ff       	call   80104340 <memset>
8010681a:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010681d:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
80106822:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106825:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106828:	29 c1                	sub    %eax,%ecx
8010682a:	8b 13                	mov    (%ebx),%edx
8010682c:	83 ec 08             	sub    $0x8,%esp
8010682f:	ff 73 0c             	push   0xc(%ebx)
80106832:	50                   	push   %eax
80106833:	89 f0                	mov    %esi,%eax
80106835:	e8 86 fa ff ff       	call   801062c0 <mappages>
8010683a:	83 c4 10             	add    $0x10,%esp
8010683d:	40                   	inc    %eax
8010683e:	74 14                	je     80106854 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106840:	83 c3 10             	add    $0x10,%ebx
80106843:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106849:	75 d7                	jne    80106822 <setupkvm+0x26>
}
8010684b:	89 f0                	mov    %esi,%eax
8010684d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106850:	5b                   	pop    %ebx
80106851:	5e                   	pop    %esi
80106852:	5d                   	pop    %ebp
80106853:	c3                   	ret
      freevm(pgdir);
80106854:	83 ec 0c             	sub    $0xc,%esp
80106857:	56                   	push   %esi
80106858:	e8 2f ff ff ff       	call   8010678c <freevm>
      return 0;
8010685d:	83 c4 10             	add    $0x10,%esp
    return 0;
80106860:	31 f6                	xor    %esi,%esi
}
80106862:	89 f0                	mov    %esi,%eax
80106864:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106867:	5b                   	pop    %ebx
80106868:	5e                   	pop    %esi
80106869:	5d                   	pop    %ebp
8010686a:	c3                   	ret
8010686b:	90                   	nop

8010686c <kvmalloc>:
{
8010686c:	55                   	push   %ebp
8010686d:	89 e5                	mov    %esp,%ebp
8010686f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106872:	e8 85 ff ff ff       	call   801067fc <setupkvm>
80106877:	a3 c4 4e 11 80       	mov    %eax,0x80114ec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010687c:	05 00 00 00 80       	add    $0x80000000,%eax
80106881:	0f 22 d8             	mov    %eax,%cr3
}
80106884:	c9                   	leave
80106885:	c3                   	ret
80106886:	66 90                	xchg   %ax,%ax

80106888 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106888:	55                   	push   %ebp
80106889:	89 e5                	mov    %esp,%ebp
8010688b:	83 ec 08             	sub    $0x8,%esp
  pde = &pgdir[PDX(va)];
8010688e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106891:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106894:	8b 45 08             	mov    0x8(%ebp),%eax
80106897:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010689a:	a8 01                	test   $0x1,%al
8010689c:	75 0e                	jne    801068ac <clearpteu+0x24>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010689e:	83 ec 0c             	sub    $0xc,%esp
801068a1:	68 fe 6f 10 80       	push   $0x80106ffe
801068a6:	e8 8d 9a ff ff       	call   80100338 <panic>
801068ab:	90                   	nop
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068b1:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
801068b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801068b6:	c1 e8 0a             	shr    $0xa,%eax
801068b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801068be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801068c5:	85 c0                	test   %eax,%eax
801068c7:	74 d5                	je     8010689e <clearpteu+0x16>
  *pte &= ~PTE_U;
801068c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801068cc:	c9                   	leave
801068cd:	c3                   	ret
801068ce:	66 90                	xchg   %ax,%ax

801068d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
801068d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801068d9:	e8 1e ff ff ff       	call   801067fc <setupkvm>
801068de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068e1:	85 c0                	test   %eax,%eax
801068e3:	0f 84 d5 00 00 00    	je     801069be <copyuvm+0xee>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801068e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801068ec:	85 db                	test   %ebx,%ebx
801068ee:	0f 84 a4 00 00 00    	je     80106998 <copyuvm+0xc8>
801068f4:	31 ff                	xor    %edi,%edi
801068f6:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
801068f8:	89 f8                	mov    %edi,%eax
801068fa:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801068fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106900:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106903:	a8 01                	test   $0x1,%al
80106905:	75 0d                	jne    80106914 <copyuvm+0x44>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106907:	83 ec 0c             	sub    $0xc,%esp
8010690a:	68 08 70 10 80       	push   $0x80107008
8010690f:	e8 24 9a ff ff       	call   80100338 <panic>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106914:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106919:	89 fa                	mov    %edi,%edx
8010691b:	c1 ea 0a             	shr    $0xa,%edx
8010691e:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106924:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010692b:	85 c0                	test   %eax,%eax
8010692d:	74 d8                	je     80106907 <copyuvm+0x37>
    if(!(*pte & PTE_P))
8010692f:	8b 18                	mov    (%eax),%ebx
80106931:	f6 c3 01             	test   $0x1,%bl
80106934:	0f 84 8d 00 00 00    	je     801069c7 <copyuvm+0xf7>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010693a:	89 d8                	mov    %ebx,%eax
8010693c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106944:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
8010694a:	e8 45 ba ff ff       	call   80102394 <kalloc>
8010694f:	89 c6                	mov    %eax,%esi
80106951:	85 c0                	test   %eax,%eax
80106953:	74 5b                	je     801069b0 <copyuvm+0xe0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106955:	50                   	push   %eax
80106956:	68 00 10 00 00       	push   $0x1000
8010695b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010695e:	05 00 00 00 80       	add    $0x80000000,%eax
80106963:	50                   	push   %eax
80106964:	56                   	push   %esi
80106965:	e8 52 da ff ff       	call   801043bc <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010696a:	5a                   	pop    %edx
8010696b:	59                   	pop    %ecx
8010696c:	53                   	push   %ebx
8010696d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106973:	50                   	push   %eax
80106974:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106979:	89 fa                	mov    %edi,%edx
8010697b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010697e:	e8 3d f9 ff ff       	call   801062c0 <mappages>
80106983:	83 c4 10             	add    $0x10,%esp
80106986:	40                   	inc    %eax
80106987:	74 1b                	je     801069a4 <copyuvm+0xd4>
  for(i = 0; i < sz; i += PGSIZE){
80106989:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010698f:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106992:	0f 82 60 ff ff ff    	jb     801068f8 <copyuvm+0x28>
  return d;

bad:
  freevm(d);
  return 0;
}
80106998:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010699b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010699e:	5b                   	pop    %ebx
8010699f:	5e                   	pop    %esi
801069a0:	5f                   	pop    %edi
801069a1:	5d                   	pop    %ebp
801069a2:	c3                   	ret
801069a3:	90                   	nop
      kfree(mem);
801069a4:	83 ec 0c             	sub    $0xc,%esp
801069a7:	56                   	push   %esi
801069a8:	e8 57 b8 ff ff       	call   80102204 <kfree>
      goto bad;
801069ad:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801069b0:	83 ec 0c             	sub    $0xc,%esp
801069b3:	ff 75 e0             	push   -0x20(%ebp)
801069b6:	e8 d1 fd ff ff       	call   8010678c <freevm>
  return 0;
801069bb:	83 c4 10             	add    $0x10,%esp
    return 0;
801069be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801069c5:	eb d1                	jmp    80106998 <copyuvm+0xc8>
      panic("copyuvm: page not present");
801069c7:	83 ec 0c             	sub    $0xc,%esp
801069ca:	68 22 70 10 80       	push   $0x80107022
801069cf:	e8 64 99 ff ff       	call   80100338 <panic>

801069d4 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801069d4:	55                   	push   %ebp
801069d5:	89 e5                	mov    %esp,%ebp
  pde = &pgdir[PDX(va)];
801069d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801069da:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801069dd:	8b 45 08             	mov    0x8(%ebp),%eax
801069e0:	8b 04 90             	mov    (%eax,%edx,4),%eax
801069e3:	a8 01                	test   $0x1,%al
801069e5:	0f 84 e3 00 00 00    	je     80106ace <uva2ka.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069f0:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
801069f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801069f5:	c1 e8 0c             	shr    $0xc,%eax
801069f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
801069fd:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106a04:	89 c2                	mov    %eax,%edx
80106a06:	f7 d2                	not    %edx
80106a08:	83 e2 05             	and    $0x5,%edx
80106a0b:	75 0f                	jne    80106a1c <uva2ka+0x48>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106a0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a12:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106a17:	5d                   	pop    %ebp
80106a18:	c3                   	ret
80106a19:	8d 76 00             	lea    0x0(%esi),%esi
80106a1c:	31 c0                	xor    %eax,%eax
80106a1e:	5d                   	pop    %ebp
80106a1f:	c3                   	ret

80106a20 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 0c             	sub    $0xc,%esp
80106a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a2c:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106a2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106a32:	85 db                	test   %ebx,%ebx
80106a34:	0f 84 8a 00 00 00    	je     80106ac4 <copyout+0xa4>
80106a3a:	89 fe                	mov    %edi,%esi
80106a3c:	eb 3d                	jmp    80106a7b <copyout+0x5b>
80106a3e:	66 90                	xchg   %ax,%ax
  return (char*)P2V(PTE_ADDR(*pte));
80106a40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80106a45:	05 00 00 00 80       	add    $0x80000000,%eax
80106a4a:	74 6a                	je     80106ab6 <copyout+0x96>
      return -1;
    n = PGSIZE - (va - va0);
80106a4c:	89 fb                	mov    %edi,%ebx
80106a4e:	29 cb                	sub    %ecx,%ebx
    if(n > len)
80106a50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a56:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80106a59:	73 03                	jae    80106a5e <copyout+0x3e>
80106a5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106a5e:	52                   	push   %edx
80106a5f:	53                   	push   %ebx
80106a60:	56                   	push   %esi
80106a61:	29 f9                	sub    %edi,%ecx
80106a63:	01 c8                	add    %ecx,%eax
80106a65:	50                   	push   %eax
80106a66:	e8 51 d9 ff ff       	call   801043bc <memmove>
    len -= n;
    buf += n;
80106a6b:	01 de                	add    %ebx,%esi
    va = va0 + PGSIZE;
80106a6d:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
80106a73:	83 c4 10             	add    $0x10,%esp
80106a76:	29 5d 14             	sub    %ebx,0x14(%ebp)
80106a79:	74 49                	je     80106ac4 <copyout+0xa4>
    va0 = (uint)PGROUNDDOWN(va);
80106a7b:	89 cf                	mov    %ecx,%edi
80106a7d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pde = &pgdir[PDX(va)];
80106a83:	89 c8                	mov    %ecx,%eax
80106a85:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a88:	8b 55 08             	mov    0x8(%ebp),%edx
80106a8b:	8b 04 82             	mov    (%edx,%eax,4),%eax
80106a8e:	a8 01                	test   $0x1,%al
80106a90:	0f 84 3f 00 00 00    	je     80106ad5 <copyout.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a9b:	89 fb                	mov    %edi,%ebx
80106a9d:	c1 eb 0c             	shr    $0xc,%ebx
80106aa0:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106aa6:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80106aad:	89 c3                	mov    %eax,%ebx
80106aaf:	f7 d3                	not    %ebx
80106ab1:	83 e3 05             	and    $0x5,%ebx
80106ab4:	74 8a                	je     80106a40 <copyout+0x20>
      return -1;
80106ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106abe:	5b                   	pop    %ebx
80106abf:	5e                   	pop    %esi
80106ac0:	5f                   	pop    %edi
80106ac1:	5d                   	pop    %ebp
80106ac2:	c3                   	ret
80106ac3:	90                   	nop
  return 0;
80106ac4:	31 c0                	xor    %eax,%eax
}
80106ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ac9:	5b                   	pop    %ebx
80106aca:	5e                   	pop    %esi
80106acb:	5f                   	pop    %edi
80106acc:	5d                   	pop    %ebp
80106acd:	c3                   	ret

80106ace <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106ace:	a1 00 00 00 00       	mov    0x0,%eax
80106ad3:	0f 0b                	ud2

80106ad5 <copyout.cold>:
80106ad5:	a1 00 00 00 00       	mov    0x0,%eax
80106ada:	0f 0b                	ud2
