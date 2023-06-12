
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 71 10 80       	push   $0x80107140
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 a1 43 00 00       	call   80104400 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 71 10 80       	push   $0x80107147
80100097:	50                   	push   %eax
80100098:	e8 23 42 00 00       	call   801042c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 93 44 00 00       	call   80104580 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 d9 44 00 00       	call   80104640 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 41 00 00       	call   80104300 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 71 10 80       	push   $0x8010714e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 d9 41 00 00       	call   801043a0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 71 10 80       	push   $0x8010715f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 98 41 00 00       	call   801043a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 41 00 00       	call   80104360 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 5c 43 00 00       	call   80104580 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 cb 43 00 00       	jmp    80104640 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 71 10 80       	push   $0x80107166
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 ca 42 00 00       	call   80104580 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 56 3c 00 00       	call   80103f40 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 71 36 00 00       	call   80103970 <myproc>
801002ff:	8b 48 28             	mov    0x28(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 2d 43 00 00       	call   80104640 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 d6 42 00 00       	call   80104640 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 71 10 80       	push   $0x8010716d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 e1 7a 10 80 	movl   $0x80107ae1,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 40 00 00       	call   80104420 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 71 10 80       	push   $0x80107181
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 11 59 00 00       	call   80105d40 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 26 58 00 00       	call   80105d40 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 1a 58 00 00       	call   80105d40 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 0e 58 00 00       	call   80105d40 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ca 41 00 00       	call   80104730 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 41 00 00       	call   80104690 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 71 10 80       	push   $0x80107185
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 b0 71 10 80 	movzbl -0x7fef8e50(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 1c 3f 00 00       	call   80104580 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 a4 3f 00 00       	call   80104640 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 71 10 80       	mov    $0x80107198,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 be 3d 00 00       	call   80104580 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 13 3e 00 00       	call   80104640 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 71 10 80       	push   $0x8010719f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 04 3d 00 00       	call   80104580 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 6c 3c 00 00       	call   80104640 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 ec 37 00 00       	jmp    801041f0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 db 36 00 00       	call   80104100 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 71 10 80       	push   $0x801071a8
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 b7 39 00 00       	call   80104400 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint ustack2[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 db 2e 00 00       	call   80103970 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 ff 02 00 00    	je     80100db5 <exec+0x335>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 7f 63 00 00       	call   80106e90 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a5 02 00 00    	je     80100dd4 <exec+0x354>
  sz2 = 2143299344;
80100b2f:	c7 85 f0 fe ff ff 10 	movl   $0x7fc02710,-0x110(%ebp)
80100b36:	27 c0 7f 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz2 = allocuvm(pgdir, sz2, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 38 61 00 00       	call   80106cb0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 52 60 00 00       	call   80106c00 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 20 62 00 00       	call   80106e10 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 8a 21 00 00       	call   80102db0 <end_op>
  if((sz2 = allocuvm(pgdir, sz2, sz2 + PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 79 60 00 00       	call   80106cb0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz2 - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz2 - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz2 - 2*PGSIZE));
80100c53:	e8 d8 62 00 00       	call   80106f30 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack2[3+argc] = sp2;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack2[3+argc] = sp2;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp2 = (sp2 - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 e8 3b 00 00       	call   80104890 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp2, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp2 = (sp2 - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp2, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 d5 3b 00 00       	call   80104890 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 d4 63 00 00       	call   801070a0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 2a 61 00 00       	call   80106e10 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack2[2] = sp2 - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack2[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack2[2] = sp2 - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp2 -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack2[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp2 -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp2, ustack2, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack2[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack2[2] = sp2 - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp2, ustack2, (3+argc+1)*4) < 0)
80100d33:	e8 68 63 00 00       	call   801070a0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 70             	add    $0x70,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 da 3a 00 00       	call   80104850 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz2;
80100d81:	89 70 04             	mov    %esi,0x4(%eax)
  curproc->pgdir = pgdir;
80100d84:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d87:	89 c1                	mov    %eax,%ecx
80100d89:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8f:	8b 40 1c             	mov    0x1c(%eax),%eax
80100d92:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp2;
80100d95:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100d98:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9b:	89 0c 24             	mov    %ecx,(%esp)
80100d9e:	e8 cd 5c 00 00       	call   80106a70 <switchuvm>
  freevm(oldpgdir);
80100da3:	89 3c 24             	mov    %edi,(%esp)
80100da6:	e8 65 60 00 00       	call   80106e10 <freevm>
  return 0;
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	31 c0                	xor    %eax,%eax
80100db0:	e9 3b fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db5:	e8 f6 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dba:	83 ec 0c             	sub    $0xc,%esp
80100dbd:	68 c1 71 10 80       	push   $0x801071c1
80100dc2:	e8 e9 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dcf:	e9 1c fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd4:	bf 00 30 c0 7f       	mov    $0x7fc03000,%edi
80100dd9:	be 00 40 c0 7f       	mov    $0x7fc04000,%esi
80100dde:	e9 35 fe ff ff       	jmp    80100c18 <exec+0x198>
80100de3:	66 90                	xchg   %ax,%ax
80100de5:	66 90                	xchg   %ax,%ax
80100de7:	66 90                	xchg   %ax,%ax
80100de9:	66 90                	xchg   %ax,%ax
80100deb:	66 90                	xchg   %ax,%ax
80100ded:	66 90                	xchg   %ax,%ax
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 cd 71 10 80       	push   $0x801071cd
80100dff:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e04:	e8 f7 35 00 00       	call   80104400 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e25:	e8 56 37 00 00       	call   80104580 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 ea 37 00 00       	call   80104640 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6a:	e8 d1 37 00 00       	call   80104640 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e93:	e8 e8 36 00 00       	call   80104580 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eb0:	e8 8b 37 00 00       	call   80104640 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 d4 71 10 80       	push   $0x801071d4
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee5:	e8 96 36 00 00       	call   80104580 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 1b 37 00 00       	call   80104640 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 ed 36 00 00       	jmp    80104640 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 dc 71 10 80       	push   $0x801071dc
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 e6 71 10 80       	push   $0x801071e6
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 ef 71 10 80       	push   $0x801071ef
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 f5 71 10 80       	push   $0x801071f5
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 ff 71 10 80       	push   $0x801071ff
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 12 72 10 80       	push   $0x80107212
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 66 33 00 00       	call   80104690 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 09 11 80       	push   $0x801109e0
8010136a:	e8 11 32 00 00       	call   80104580 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 09 11 80       	push   $0x801109e0
801013d7:	e8 64 32 00 00       	call   80104640 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 36 32 00 00       	call   80104640 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 28 72 10 80       	push   $0x80107228
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 38 72 10 80       	push   $0x80107238
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 f6 31 00 00       	call   80104730 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 4b 72 10 80       	push   $0x8010724b
80101565:	68 e0 09 11 80       	push   $0x801109e0
8010156a:	e8 91 2e 00 00       	call   80104400 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 52 72 10 80       	push   $0x80107252
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 34 2d 00 00       	call   801042c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 09 11 80       	push   $0x801109c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015ad:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015b3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015b9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015bf:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015c5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015cb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015d1:	68 b8 72 10 80       	push   $0x801072b8
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 1d 30 00 00       	call   80104690 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 58 72 10 80       	push   $0x80107258
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 16 30 00 00       	call   80104730 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 09 11 80       	push   $0x801109e0
80101753:	e8 28 2e 00 00       	call   80104580 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101763:	e8 d8 2e 00 00       	call   80104640 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 65 2b 00 00       	call   80104300 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 23 2f 00 00       	call   80104730 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 70 72 10 80       	push   $0x80107270
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 6a 72 10 80       	push   $0x8010726a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 34 2b 00 00       	call   801043a0 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 d8 2a 00 00       	jmp    80104360 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 7f 72 10 80       	push   $0x8010727f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 47 2a 00 00       	call   80104300 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 8d 2a 00 00       	call   80104360 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018da:	e8 a1 2c 00 00       	call   80104580 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 47 2d 00 00       	jmp    80104640 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 09 11 80       	push   $0x801109e0
80101908:	e8 73 2c 00 00       	call   80104580 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101917:	e8 24 2d 00 00       	call   80104640 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 14 2c 00 00       	call   80104730 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 18 2b 00 00       	call   80104730 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 e9 2a 00 00       	call   801047a0 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 86 2a 00 00       	call   801047a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 99 72 10 80       	push   $0x80107299
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 87 72 10 80       	push   $0x80107287
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 d1 1b 00 00       	call   80103970 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 09 11 80       	push   $0x801109e0
80101dac:	e8 cf 27 00 00       	call   80104580 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dbc:	e8 7f 28 00 00       	call   80104640 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 04 29 00 00       	call   80104730 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 78 28 00 00       	call   80104730 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 06 28 00 00       	call   801047f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 a8 72 10 80       	push   $0x801072a8
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 7e 78 10 80       	push   $0x8010787e
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 14 73 10 80       	push   $0x80107314
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 0b 73 10 80       	push   $0x8010730b
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 26 73 10 80       	push   $0x80107326
8010216f:	68 80 a5 10 80       	push   $0x8010a580
80102174:	e8 87 22 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 a5 10 80       	push   $0x8010a580
80102202:	e8 79 23 00 00       	call   80104580 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 9e 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 a5 10 80       	push   $0x8010a580
8010227b:	e8 c0 23 00 00       	call   80104640 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 f9 20 00 00       	call   801043a0 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 a5 10 80       	push   $0x8010a580
801022dc:	e8 9f 22 00 00       	call   80104580 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 a5 10 80       	push   $0x8010a580
80102328:	53                   	push   %ebx
80102329:	e8 12 1c 00 00       	call   80103f40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 f5 22 00 00       	jmp    80104640 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 55 73 10 80       	push   $0x80107355
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 40 73 10 80       	push   $0x80107340
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 2a 73 10 80       	push   $0x8010732a
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 74 73 10 80       	push   $0x80107374
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 d5 21 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 26 11 80       	push   $0x80112640
801024f0:	e8 8b 20 00 00       	call   80104580 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 30 21 00 00       	jmp    80104640 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 a6 73 10 80       	push   $0x801073a6
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 ac 73 10 80       	push   $0x801073ac
80102584:	68 40 26 11 80       	push   $0x80112640
80102589:	e8 72 1e 00 00       	call   80104400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 26 11 80       	mov    0x80112674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 26 11 80       	push   $0x80112640
80102673:	e8 08 1f 00 00       	call   80104580 <acquire>
  r = kmem.freelist;
80102678:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010267d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 26 11 80       	push   $0x80112640
801026a1:	e8 9a 1f 00 00       	call   80104640 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a e0 74 10 80 	movzbl -0x7fef8b20(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 e0 73 10 80 	movzbl -0x7fef8c20(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a e0 74 10 80 	movzbl -0x7fef8b20(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 0c 1c 00 00       	call   801046e0 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102be4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 27 1b 00 00       	call   80104730 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 e0 75 10 80       	push   $0x801075e0
80102cb3:	68 80 26 11 80       	push   $0x80112680
80102cb8:	e8 43 17 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102cdb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 26 11 80       	push   $0x80112680
80102d4f:	e8 2c 18 00 00       	call   80104580 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 26 11 80       	push   $0x80112680
80102d68:	68 80 26 11 80       	push   $0x80112680
80102d6d:	e8 ce 11 00 00       	call   80103f40 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d83:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d9f:	68 80 26 11 80       	push   $0x80112680
80102da4:	e8 97 18 00 00       	call   80104640 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 26 11 80       	push   $0x80112680
80102dc2:	e8 b9 17 00 00       	call   80104580 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 26 11 80       	push   $0x80112680
80102e00:	e8 3b 18 00 00       	call   80104640 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 26 11 80       	push   $0x80112680
80102e1a:	e8 61 17 00 00       	call   80104580 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 cb 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e3c:	e8 ff 17 00 00       	call   80104640 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e74:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 97 18 00 00       	call   80104730 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 26 11 80       	push   $0x80112680
80102ee8:	e8 13 12 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ef4:	e8 47 17 00 00       	call   80104640 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 e4 75 10 80       	push   $0x801075e4
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 26 11 80       	push   $0x80112680
80102f62:	e8 19 16 00 00       	call   80104580 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 96 16 00 00       	jmp    80104640 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 f3 75 10 80       	push   $0x801075f3
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 09 76 10 80       	push   $0x80107609
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 54 09 00 00       	call   80103950 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 4d 09 00 00       	call   80103950 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 24 76 10 80       	push   $0x80107624
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 29 29 00 00       	call   80105940 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 c4 08 00 00       	call   801038e0 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 21 0c 00 00       	call   80103c50 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 11 3a 00 00       	call   80106a50 <switchkvm>
  seginit();
8010303f:	e8 7c 39 00 00       	call   801069c0 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 a8 55 11 80       	push   $0x801155a8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 96 3e 00 00       	call   80106f10 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 37 39 00 00       	call   801069c0 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 e3 2b 00 00       	call   80105c80 <uartinit>
  pinit();         // process table
8010309d:	e8 1e 08 00 00       	call   801038c0 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 19 28 00 00       	call   801058c0 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c a4 10 80       	push   $0x8010a48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 63 16 00 00       	call   80104730 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030d7:	00 00 00 
801030da:	05 80 27 11 80       	add    $0x80112780,%eax
801030df:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 27 11 80       	add    $0x80112780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 d2 07 00 00       	call   801038e0 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010312b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 29 08 00 00       	call   801039a0 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 38 76 10 80       	push   $0x80107638
801031b3:	56                   	push   %esi
801031b4:	e8 27 15 00 00       	call   801046e0 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 3d 76 10 80       	push   $0x8010763d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 68 14 00 00       	call   801046e0 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 42 76 10 80       	push   $0x80107642
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 5c 76 10 80       	push   $0x8010765c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 7b 76 10 80       	push   $0x8010767b
8010347c:	50                   	push   %eax
8010347d:	e8 7e 0f 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 58 10 00 00       	call   80104580 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 b8 0b 00 00       	call   80104100 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 d3 10 00 00       	jmp    80104640 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 77 0b 00 00       	call   80104100 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 a7 10 00 00       	call   80104640 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 ba 0f 00 00       	call   80104580 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 63 03 00 00       	call   80103970 <myproc>
8010360d:	8b 48 28             	mov    0x28(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 e3 0a 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 1a 09 00 00       	call   80103f40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 ef 0f 00 00       	call   80104640 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 61 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 99 0f 00 00       	call   80104640 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 b1 0e 00 00       	call   80104580 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 83 02 00 00       	call   80103970 <myproc>
801036ed:	8b 48 28             	mov    0x28(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 3e 08 00 00       	call   80103f40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 95 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 cd 0e 00 00       	call   80104640 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 b2 0e 00 00       	call   80104640 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 ca 0d 00 00       	call   80104580 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 10                	jmp    801037cb <allocproc+0x2b>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	83 eb 80             	sub    $0xffffff80,%ebx
801037c3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801037c9:	74 75                	je     80103840 <allocproc+0xa0>
    if(p->state == UNUSED)
801037cb:	8b 43 10             	mov    0x10(%ebx),%eax
801037ce:	85 c0                	test   %eax,%eax
801037d0:	75 ee                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037da:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801037e1:	89 43 14             	mov    %eax,0x14(%ebx)
801037e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037e7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037ec:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037f2:	e8 49 0e 00 00       	call   80104640 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037f7:	e8 44 ee ff ff       	call   80102640 <kalloc>
801037fc:	83 c4 10             	add    $0x10,%esp
801037ff:	89 43 0c             	mov    %eax,0xc(%ebx)
80103802:	85 c0                	test   %eax,%eax
80103804:	74 53                	je     80103859 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103806:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010380c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010380f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103814:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103817:	c7 40 14 a6 58 10 80 	movl   $0x801058a6,0x14(%eax)
  p->context = (struct context*)sp;
8010381e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103821:	6a 14                	push   $0x14
80103823:	6a 00                	push   $0x0
80103825:	50                   	push   %eax
80103826:	e8 65 0e 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
8010382b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
8010382e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103831:	c7 40 10 70 38 10 80 	movl   $0x80103870,0x10(%eax)
}
80103838:	89 d8                	mov    %ebx,%eax
8010383a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383d:	c9                   	leave  
8010383e:	c3                   	ret    
8010383f:	90                   	nop
  release(&ptable.lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103843:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103845:	68 20 2d 11 80       	push   $0x80112d20
8010384a:	e8 f1 0d 00 00       	call   80104640 <release>
}
8010384f:	89 d8                	mov    %ebx,%eax
  return 0;
80103851:	83 c4 10             	add    $0x10,%esp
}
80103854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103857:	c9                   	leave  
80103858:	c3                   	ret    
    p->state = UNUSED;
80103859:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103860:	31 db                	xor    %ebx,%ebx
}
80103862:	89 d8                	mov    %ebx,%eax
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103870 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103870:	f3 0f 1e fb          	endbr32 
80103874:	55                   	push   %ebp
80103875:	89 e5                	mov    %esp,%ebp
80103877:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010387a:	68 20 2d 11 80       	push   $0x80112d20
8010387f:	e8 bc 0d 00 00       	call   80104640 <release>

  if (first) {
80103884:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	85 c0                	test   %eax,%eax
8010388e:	75 08                	jne    80103898 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103890:	c9                   	leave  
80103891:	c3                   	ret    
80103892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103898:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010389f:	00 00 00 
    iinit(ROOTDEV);
801038a2:	83 ec 0c             	sub    $0xc,%esp
801038a5:	6a 01                	push   $0x1
801038a7:	e8 a4 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
801038ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038b3:	e8 e8 f3 ff ff       	call   80102ca0 <initlog>
}
801038b8:	83 c4 10             	add    $0x10,%esp
801038bb:	c9                   	leave  
801038bc:	c3                   	ret    
801038bd:	8d 76 00             	lea    0x0(%esi),%esi

801038c0 <pinit>:
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038ca:	68 80 76 10 80       	push   $0x80107680
801038cf:	68 20 2d 11 80       	push   $0x80112d20
801038d4:	e8 27 0b 00 00       	call   80104400 <initlock>
}
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax

801038e0 <mycpu>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	56                   	push   %esi
801038e8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038e9:	9c                   	pushf  
801038ea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038eb:	f6 c4 02             	test   $0x2,%ah
801038ee:	75 4a                	jne    8010393a <mycpu+0x5a>
  apicid = lapicid();
801038f0:	e8 bb ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038f5:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
801038fb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801038fd:	85 f6                	test   %esi,%esi
801038ff:	7e 2c                	jle    8010392d <mycpu+0x4d>
80103901:	31 d2                	xor    %edx,%edx
80103903:	eb 0a                	jmp    8010390f <mycpu+0x2f>
80103905:	8d 76 00             	lea    0x0(%esi),%esi
80103908:	83 c2 01             	add    $0x1,%edx
8010390b:	39 f2                	cmp    %esi,%edx
8010390d:	74 1e                	je     8010392d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010390f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103915:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010391c:	39 d8                	cmp    %ebx,%eax
8010391e:	75 e8                	jne    80103908 <mycpu+0x28>
}
80103920:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103923:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103929:	5b                   	pop    %ebx
8010392a:	5e                   	pop    %esi
8010392b:	5d                   	pop    %ebp
8010392c:	c3                   	ret    
  panic("unknown apicid\n");
8010392d:	83 ec 0c             	sub    $0xc,%esp
80103930:	68 87 76 10 80       	push   $0x80107687
80103935:	e8 56 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010393a:	83 ec 0c             	sub    $0xc,%esp
8010393d:	68 64 77 10 80       	push   $0x80107764
80103942:	e8 49 ca ff ff       	call   80100390 <panic>
80103947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394e:	66 90                	xchg   %ax,%ax

80103950 <cpuid>:
cpuid() {
80103950:	f3 0f 1e fb          	endbr32 
80103954:	55                   	push   %ebp
80103955:	89 e5                	mov    %esp,%ebp
80103957:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010395a:	e8 81 ff ff ff       	call   801038e0 <mycpu>
}
8010395f:	c9                   	leave  
  return mycpu()-cpus;
80103960:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103965:	c1 f8 04             	sar    $0x4,%eax
80103968:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010396e:	c3                   	ret    
8010396f:	90                   	nop

80103970 <myproc>:
myproc(void) {
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	53                   	push   %ebx
80103978:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010397b:	e8 00 0b 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103980:	e8 5b ff ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103985:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010398b:	e8 40 0b 00 00       	call   801044d0 <popcli>
}
80103990:	83 c4 04             	add    $0x4,%esp
80103993:	89 d8                	mov    %ebx,%eax
80103995:	5b                   	pop    %ebx
80103996:	5d                   	pop    %ebp
80103997:	c3                   	ret    
80103998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <userinit>:
{
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	53                   	push   %ebx
801039a8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039ab:	e8 f0 fd ff ff       	call   801037a0 <allocproc>
801039b0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039b2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039b7:	e8 d4 34 00 00       	call   80106e90 <setupkvm>
801039bc:	89 43 08             	mov    %eax,0x8(%ebx)
801039bf:	85 c0                	test   %eax,%eax
801039c1:	0f 84 be 00 00 00    	je     80103a85 <userinit+0xe5>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039c7:	83 ec 04             	sub    $0x4,%esp
801039ca:	68 2c 00 00 00       	push   $0x2c
801039cf:	68 60 a4 10 80       	push   $0x8010a460
801039d4:	50                   	push   %eax
801039d5:	e8 a6 31 00 00       	call   80106b80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039da:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039dd:	c7 43 04 00 10 00 00 	movl   $0x1000,0x4(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039e4:	6a 4c                	push   $0x4c
801039e6:	6a 00                	push   $0x0
801039e8:	ff 73 1c             	pushl  0x1c(%ebx)
801039eb:	e8 a0 0c 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039f0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039f3:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f8:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039fb:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a00:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a04:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a07:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a0b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a0e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a12:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a16:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a21:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a24:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a2b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a2e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a35:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a38:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3f:	8d 43 70             	lea    0x70(%ebx),%eax
80103a42:	6a 10                	push   $0x10
80103a44:	68 b0 76 10 80       	push   $0x801076b0
80103a49:	50                   	push   %eax
80103a4a:	e8 01 0e 00 00       	call   80104850 <safestrcpy>
  p->cwd = namei("/");
80103a4f:	c7 04 24 b9 76 10 80 	movl   $0x801076b9,(%esp)
80103a56:	e8 e5 e5 ff ff       	call   80102040 <namei>
80103a5b:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103a5e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a65:	e8 16 0b 00 00       	call   80104580 <acquire>
  p->state = RUNNABLE;
80103a6a:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103a71:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a78:	e8 c3 0b 00 00       	call   80104640 <release>
}
80103a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a80:	83 c4 10             	add    $0x10,%esp
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    
    panic("userinit: out of memory?");
80103a85:	83 ec 0c             	sub    $0xc,%esp
80103a88:	68 97 76 10 80       	push   $0x80107697
80103a8d:	e8 fe c8 ff ff       	call   80100390 <panic>
80103a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103aa0 <growproc>:
{
80103aa0:	f3 0f 1e fb          	endbr32 
80103aa4:	55                   	push   %ebp
80103aa5:	89 e5                	mov    %esp,%ebp
80103aa7:	56                   	push   %esi
80103aa8:	53                   	push   %ebx
80103aa9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aac:	e8 cf 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103ab1:	e8 2a fe ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103ab6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103abc:	e8 0f 0a 00 00       	call   801044d0 <popcli>
  sz = curproc->sz;
80103ac1:	8b 43 04             	mov    0x4(%ebx),%eax
  if(n > 0){
80103ac4:	85 f6                	test   %esi,%esi
80103ac6:	7f 20                	jg     80103ae8 <growproc+0x48>
  } else if(n < 0){
80103ac8:	75 3e                	jne    80103b08 <growproc+0x68>
  switchuvm(curproc);
80103aca:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103acd:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103ad0:	53                   	push   %ebx
80103ad1:	e8 9a 2f 00 00       	call   80106a70 <switchuvm>
  return 0;
80103ad6:	83 c4 10             	add    $0x10,%esp
80103ad9:	31 c0                	xor    %eax,%eax
}
80103adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ade:	5b                   	pop    %ebx
80103adf:	5e                   	pop    %esi
80103ae0:	5d                   	pop    %ebp
80103ae1:	c3                   	ret    
80103ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae8:	83 ec 04             	sub    $0x4,%esp
80103aeb:	01 c6                	add    %eax,%esi
80103aed:	56                   	push   %esi
80103aee:	50                   	push   %eax
80103aef:	ff 73 08             	pushl  0x8(%ebx)
80103af2:	e8 b9 31 00 00       	call   80106cb0 <allocuvm>
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	85 c0                	test   %eax,%eax
80103afc:	75 cc                	jne    80103aca <growproc+0x2a>
      return -1;
80103afe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b03:	eb d6                	jmp    80103adb <growproc+0x3b>
80103b05:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b08:	83 ec 04             	sub    $0x4,%esp
80103b0b:	01 c6                	add    %eax,%esi
80103b0d:	56                   	push   %esi
80103b0e:	50                   	push   %eax
80103b0f:	ff 73 08             	pushl  0x8(%ebx)
80103b12:	e8 c9 32 00 00       	call   80106de0 <deallocuvm>
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	85 c0                	test   %eax,%eax
80103b1c:	75 ac                	jne    80103aca <growproc+0x2a>
80103b1e:	eb de                	jmp    80103afe <growproc+0x5e>

80103b20 <fork>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	57                   	push   %edi
80103b28:	56                   	push   %esi
80103b29:	53                   	push   %ebx
80103b2a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b2d:	e8 4e 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103b32:	e8 a9 fd ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103b37:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b3d:	e8 8e 09 00 00       	call   801044d0 <popcli>
  if((np = allocproc()) == 0){
80103b42:	e8 59 fc ff ff       	call   801037a0 <allocproc>
80103b47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b4a:	85 c0                	test   %eax,%eax
80103b4c:	0f 84 c3 00 00 00    	je     80103c15 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b52:	83 ec 08             	sub    $0x8,%esp
80103b55:	ff 73 04             	pushl  0x4(%ebx)
80103b58:	89 c7                	mov    %eax,%edi
80103b5a:	ff 73 08             	pushl  0x8(%ebx)
80103b5d:	e8 fe 33 00 00       	call   80106f60 <copyuvm>
80103b62:	83 c4 10             	add    $0x10,%esp
80103b65:	89 47 08             	mov    %eax,0x8(%edi)
80103b68:	85 c0                	test   %eax,%eax
80103b6a:	0f 84 ac 00 00 00    	je     80103c1c <fork+0xfc>
  np->stack_pages = 1;
80103b70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b73:	c7 01 01 00 00 00    	movl   $0x1,(%ecx)
  np->sz = curproc->sz;
80103b79:	8b 43 04             	mov    0x4(%ebx),%eax
  *np->tf = *curproc->tf;
80103b7c:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103b7f:	89 59 18             	mov    %ebx,0x18(%ecx)
  np->sz = curproc->sz;
80103b82:	89 41 04             	mov    %eax,0x4(%ecx)
  np->parent = curproc;
80103b85:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b87:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103b8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b91:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b93:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b96:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 cf d2 ff ff       	call   80100e80 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 6c             	pushl  0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 6f db ff ff       	call   80101740 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 70             	lea    0x70(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 6a 0c 00 00       	call   80104850 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf0:	e8 8b 09 00 00       	call   80104580 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c03:	e8 38 0a 00 00       	call   80104640 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
    return -1;
80103c15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c1a:	eb ef                	jmp    80103c0b <fork+0xeb>
    kfree(np->kstack);
80103c1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	ff 73 0c             	pushl  0xc(%ebx)
80103c25:	e8 56 e8 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103c2a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c34:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103c3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c40:	eb c9                	jmp    80103c0b <fork+0xeb>
80103c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c5d:	e8 7e fc ff ff       	call   801038e0 <mycpu>
  c->proc = 0;
80103c62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c69:	00 00 00 
  struct cpu *c = mycpu();
80103c6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6e:	8d 78 04             	lea    0x4(%eax),%edi
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c78:	fb                   	sti    
    acquire(&ptable.lock);
80103c79:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c81:	68 20 2d 11 80       	push   $0x80112d20
80103c86:	e8 f5 08 00 00       	call   80104580 <acquire>
80103c8b:	83 c4 10             	add    $0x10,%esp
80103c8e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c90:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 cb 2d 00 00       	call   80106a70 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 20             	pushl  0x20(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 fc 0b 00 00       	call   801048b3 <swtch>
      switchkvm();
80103cb7:	e8 94 2d 00 00       	call   80106a50 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	83 eb 80             	sub    $0xffffff80,%ebx
80103ccc:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cd2:	75 bc                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 20 2d 11 80       	push   $0x80112d20
80103cdc:	e8 5f 09 00 00       	call   80104640 <release>
    sti();
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	eb 92                	jmp    80103c78 <scheduler+0x28>
80103ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi

80103cf0 <sched>:
{
80103cf0:	f3 0f 1e fb          	endbr32 
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	56                   	push   %esi
80103cf8:	53                   	push   %ebx
  pushcli();
80103cf9:	e8 82 07 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103cfe:	e8 dd fb ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 c2 07 00 00       	call   801044d0 <popcli>
  if(!holding(&ptable.lock))
80103d0e:	83 ec 0c             	sub    $0xc,%esp
80103d11:	68 20 2d 11 80       	push   $0x80112d20
80103d16:	e8 15 08 00 00       	call   80104530 <holding>
80103d1b:	83 c4 10             	add    $0x10,%esp
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	74 4f                	je     80103d71 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d22:	e8 b9 fb ff ff       	call   801038e0 <mycpu>
80103d27:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2e:	75 68                	jne    80103d98 <sched+0xa8>
  if(p->state == RUNNING)
80103d30:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103d34:	74 55                	je     80103d8b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d36:	9c                   	pushf  
80103d37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d38:	f6 c4 02             	test   $0x2,%ah
80103d3b:	75 41                	jne    80103d7e <sched+0x8e>
  intena = mycpu()->intena;
80103d3d:	e8 9e fb ff ff       	call   801038e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d42:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103d45:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d4b:	e8 90 fb ff ff       	call   801038e0 <mycpu>
80103d50:	83 ec 08             	sub    $0x8,%esp
80103d53:	ff 70 04             	pushl  0x4(%eax)
80103d56:	53                   	push   %ebx
80103d57:	e8 57 0b 00 00       	call   801048b3 <swtch>
  mycpu()->intena = intena;
80103d5c:	e8 7f fb ff ff       	call   801038e0 <mycpu>
}
80103d61:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d64:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6d:	5b                   	pop    %ebx
80103d6e:	5e                   	pop    %esi
80103d6f:	5d                   	pop    %ebp
80103d70:	c3                   	ret    
    panic("sched ptable.lock");
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 bb 76 10 80       	push   $0x801076bb
80103d79:	e8 12 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	68 e7 76 10 80       	push   $0x801076e7
80103d86:	e8 05 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	68 d9 76 10 80       	push   $0x801076d9
80103d93:	e8 f8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	68 cd 76 10 80       	push   $0x801076cd
80103da0:	e8 eb c5 ff ff       	call   80100390 <panic>
80103da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103db0 <exit>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	57                   	push   %edi
80103db8:	56                   	push   %esi
80103db9:	53                   	push   %ebx
80103dba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103dbd:	e8 be 06 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103dc2:	e8 19 fb ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103dc7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dcd:	e8 fe 06 00 00       	call   801044d0 <popcli>
  if(curproc == initproc)
80103dd2:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103dd5:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103dd8:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103dde:	0f 84 f3 00 00 00    	je     80103ed7 <exit+0x127>
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103de8:	8b 03                	mov    (%ebx),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 d9 d0 ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c3 04             	add    $0x4,%ebx
80103e03:	39 df                	cmp    %ebx,%edi
80103e05:	75 e1                	jne    80103de8 <exit+0x38>
  begin_op();
80103e07:	e8 34 ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 76 6c             	pushl  0x6c(%esi)
80103e12:	e8 89 da ff ff       	call   801018a0 <iput>
  end_op();
80103e17:	e8 94 ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e2a:	e8 51 07 00 00       	call   80104580 <acquire>
  wakeup1(curproc->parent);
80103e2f:	8b 56 18             	mov    0x18(%esi),%edx
80103e32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e35:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e3a:	eb 0e                	jmp    80103e4a <exit+0x9a>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	83 e8 80             	sub    $0xffffff80,%eax
80103e43:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e48:	74 1c                	je     80103e66 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103e4a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103e4e:	75 f0                	jne    80103e40 <exit+0x90>
80103e50:	3b 50 24             	cmp    0x24(%eax),%edx
80103e53:	75 eb                	jne    80103e40 <exit+0x90>
      p->state = RUNNABLE;
80103e55:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5c:	83 e8 80             	sub    $0xffffff80,%eax
80103e5f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e64:	75 e4                	jne    80103e4a <exit+0x9a>
      p->parent = initproc;
80103e66:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e71:	eb 10                	jmp    80103e83 <exit+0xd3>
80103e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e77:	90                   	nop
80103e78:	83 ea 80             	sub    $0xffffff80,%edx
80103e7b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103e81:	74 3b                	je     80103ebe <exit+0x10e>
    if(p->parent == curproc){
80103e83:	39 72 18             	cmp    %esi,0x18(%edx)
80103e86:	75 f0                	jne    80103e78 <exit+0xc8>
      if(p->state == ZOMBIE)
80103e88:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
80103e8c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
80103e8f:	75 e7                	jne    80103e78 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e91:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e96:	eb 12                	jmp    80103eaa <exit+0xfa>
80103e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9f:	90                   	nop
80103ea0:	83 e8 80             	sub    $0xffffff80,%eax
80103ea3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ea8:	74 ce                	je     80103e78 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103eaa:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103eae:	75 f0                	jne    80103ea0 <exit+0xf0>
80103eb0:	3b 48 24             	cmp    0x24(%eax),%ecx
80103eb3:	75 eb                	jne    80103ea0 <exit+0xf0>
      p->state = RUNNABLE;
80103eb5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103ebc:	eb e2                	jmp    80103ea0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103ebe:	c7 46 10 05 00 00 00 	movl   $0x5,0x10(%esi)
  sched();
80103ec5:	e8 26 fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 08 77 10 80       	push   $0x80107708
80103ed2:	e8 b9 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ed7:	83 ec 0c             	sub    $0xc,%esp
80103eda:	68 fb 76 10 80       	push   $0x801076fb
80103edf:	e8 ac c4 ff ff       	call   80100390 <panic>
80103ee4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop

80103ef0 <yield>:
{
80103ef0:	f3 0f 1e fb          	endbr32 
80103ef4:	55                   	push   %ebp
80103ef5:	89 e5                	mov    %esp,%ebp
80103ef7:	53                   	push   %ebx
80103ef8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103efb:	68 20 2d 11 80       	push   $0x80112d20
80103f00:	e8 7b 06 00 00       	call   80104580 <acquire>
  pushcli();
80103f05:	e8 76 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f0a:	e8 d1 f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103f0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f15:	e8 b6 05 00 00       	call   801044d0 <popcli>
  myproc()->state = RUNNABLE;
80103f1a:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
80103f21:	e8 ca fd ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80103f26:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2d:	e8 0e 07 00 00       	call   80104640 <release>
}
80103f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f35:	83 c4 10             	add    $0x10,%esp
80103f38:	c9                   	leave  
80103f39:	c3                   	ret    
80103f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f40 <sleep>:
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	57                   	push   %edi
80103f48:	56                   	push   %esi
80103f49:	53                   	push   %ebx
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f50:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f53:	e8 28 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f58:	e8 83 f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103f5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f63:	e8 68 05 00 00       	call   801044d0 <popcli>
  if(p == 0)
80103f68:	85 db                	test   %ebx,%ebx
80103f6a:	0f 84 83 00 00 00    	je     80103ff3 <sleep+0xb3>
  if(lk == 0)
80103f70:	85 f6                	test   %esi,%esi
80103f72:	74 72                	je     80103fe6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f74:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f7a:	74 4c                	je     80103fc8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f7c:	83 ec 0c             	sub    $0xc,%esp
80103f7f:	68 20 2d 11 80       	push   $0x80112d20
80103f84:	e8 f7 05 00 00       	call   80104580 <acquire>
    release(lk);
80103f89:	89 34 24             	mov    %esi,(%esp)
80103f8c:	e8 af 06 00 00       	call   80104640 <release>
  p->chan = chan;
80103f91:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103f94:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80103f9b:	e8 50 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fa0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80103fa7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fae:	e8 8d 06 00 00       	call   80104640 <release>
    acquire(lk);
80103fb3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fb6:	83 c4 10             	add    $0x10,%esp
}
80103fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fbc:	5b                   	pop    %ebx
80103fbd:	5e                   	pop    %esi
80103fbe:	5f                   	pop    %edi
80103fbf:	5d                   	pop    %ebp
    acquire(lk);
80103fc0:	e9 bb 05 00 00       	jmp    80104580 <acquire>
80103fc5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103fc8:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103fcb:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80103fd2:	e8 19 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fd7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80103fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe1:	5b                   	pop    %ebx
80103fe2:	5e                   	pop    %esi
80103fe3:	5f                   	pop    %edi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
    panic("sleep without lk");
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	68 1a 77 10 80       	push   $0x8010771a
80103fee:	e8 9d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ff3:	83 ec 0c             	sub    $0xc,%esp
80103ff6:	68 14 77 10 80       	push   $0x80107714
80103ffb:	e8 90 c3 ff ff       	call   80100390 <panic>

80104000 <wait>:
{
80104000:	f3 0f 1e fb          	endbr32 
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	56                   	push   %esi
80104008:	53                   	push   %ebx
  pushcli();
80104009:	e8 72 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010400e:	e8 cd f8 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104019:	e8 b2 04 00 00       	call   801044d0 <popcli>
  acquire(&ptable.lock);
8010401e:	83 ec 0c             	sub    $0xc,%esp
80104021:	68 20 2d 11 80       	push   $0x80112d20
80104026:	e8 55 05 00 00       	call   80104580 <acquire>
8010402b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104030:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104035:	eb 14                	jmp    8010404b <wait+0x4b>
80104037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403e:	66 90                	xchg   %ax,%ax
80104040:	83 eb 80             	sub    $0xffffff80,%ebx
80104043:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104049:	74 1b                	je     80104066 <wait+0x66>
      if(p->parent != curproc)
8010404b:	39 73 18             	cmp    %esi,0x18(%ebx)
8010404e:	75 f0                	jne    80104040 <wait+0x40>
      if(p->state == ZOMBIE){
80104050:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80104054:	74 32                	je     80104088 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104059:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405e:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104064:	75 e5                	jne    8010404b <wait+0x4b>
    if(!havekids || curproc->killed){
80104066:	85 c0                	test   %eax,%eax
80104068:	74 74                	je     801040de <wait+0xde>
8010406a:	8b 46 28             	mov    0x28(%esi),%eax
8010406d:	85 c0                	test   %eax,%eax
8010406f:	75 6d                	jne    801040de <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104071:	83 ec 08             	sub    $0x8,%esp
80104074:	68 20 2d 11 80       	push   $0x80112d20
80104079:	56                   	push   %esi
8010407a:	e8 c1 fe ff ff       	call   80103f40 <sleep>
    havekids = 0;
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	eb aa                	jmp    8010402e <wait+0x2e>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	ff 73 0c             	pushl  0xc(%ebx)
        pid = p->pid;
8010408e:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104091:	e8 ea e3 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
80104096:	5a                   	pop    %edx
80104097:	ff 73 08             	pushl  0x8(%ebx)
        p->kstack = 0;
8010409a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801040a1:	e8 6a 2d 00 00       	call   80106e10 <freevm>
        release(&ptable.lock);
801040a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801040ad:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801040b4:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801040bb:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801040bf:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801040c6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801040cd:	e8 6e 05 00 00       	call   80104640 <release>
        return pid;
801040d2:	83 c4 10             	add    $0x10,%esp
}
801040d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040d8:	89 f0                	mov    %esi,%eax
801040da:	5b                   	pop    %ebx
801040db:	5e                   	pop    %esi
801040dc:	5d                   	pop    %ebp
801040dd:	c3                   	ret    
      release(&ptable.lock);
801040de:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040e6:	68 20 2d 11 80       	push   $0x80112d20
801040eb:	e8 50 05 00 00       	call   80104640 <release>
      return -1;
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	eb e0                	jmp    801040d5 <wait+0xd5>
801040f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 10             	sub    $0x10,%esp
8010410b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410e:	68 20 2d 11 80       	push   $0x80112d20
80104113:	e8 68 04 00 00       	call   80104580 <acquire>
80104118:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104120:	eb 10                	jmp    80104132 <wakeup+0x32>
80104122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104128:	83 e8 80             	sub    $0xffffff80,%eax
8010412b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104130:	74 1c                	je     8010414e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104132:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80104136:	75 f0                	jne    80104128 <wakeup+0x28>
80104138:	3b 58 24             	cmp    0x24(%eax),%ebx
8010413b:	75 eb                	jne    80104128 <wakeup+0x28>
      p->state = RUNNABLE;
8010413d:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104144:	83 e8 80             	sub    $0xffffff80,%eax
80104147:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010414c:	75 e4                	jne    80104132 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010414e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104158:	c9                   	leave  
  release(&ptable.lock);
80104159:	e9 e2 04 00 00       	jmp    80104640 <release>
8010415e:	66 90                	xchg   %ax,%ax

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	53                   	push   %ebx
80104168:	83 ec 10             	sub    $0x10,%esp
8010416b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416e:	68 20 2d 11 80       	push   $0x80112d20
80104173:	e8 08 04 00 00       	call   80104580 <acquire>
80104178:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104180:	eb 10                	jmp    80104192 <kill+0x32>
80104182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104188:	83 e8 80             	sub    $0xffffff80,%eax
8010418b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104190:	74 36                	je     801041c8 <kill+0x68>
    if(p->pid == pid){
80104192:	39 58 14             	cmp    %ebx,0x14(%eax)
80104195:	75 f1                	jne    80104188 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104197:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
8010419b:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801041a2:	75 07                	jne    801041ab <kill+0x4b>
        p->state = RUNNABLE;
801041a4:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801041ab:	83 ec 0c             	sub    $0xc,%esp
801041ae:	68 20 2d 11 80       	push   $0x80112d20
801041b3:	e8 88 04 00 00       	call   80104640 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	31 c0                	xor    %eax,%eax
}
801041c0:	c9                   	leave  
801041c1:	c3                   	ret    
801041c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	68 20 2d 11 80       	push   $0x80112d20
801041d0:	e8 6b 04 00 00       	call   80104640 <release>
}
801041d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    
801041e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	57                   	push   %edi
801041f8:	56                   	push   %esi
801041f9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041fc:	53                   	push   %ebx
801041fd:	bb c4 2d 11 80       	mov    $0x80112dc4,%ebx
80104202:	83 ec 3c             	sub    $0x3c,%esp
80104205:	eb 28                	jmp    8010422f <procdump+0x3f>
80104207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 e1 7a 10 80       	push   $0x80107ae1
80104218:	e8 93 c4 ff ff       	call   801006b0 <cprintf>
8010421d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104220:	83 eb 80             	sub    $0xffffff80,%ebx
80104223:	81 fb c4 4d 11 80    	cmp    $0x80114dc4,%ebx
80104229:	0f 84 81 00 00 00    	je     801042b0 <procdump+0xc0>
    if(p->state == UNUSED)
8010422f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104232:	85 c0                	test   %eax,%eax
80104234:	74 ea                	je     80104220 <procdump+0x30>
      state = "???";
80104236:	ba 2b 77 10 80       	mov    $0x8010772b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010423b:	83 f8 05             	cmp    $0x5,%eax
8010423e:	77 11                	ja     80104251 <procdump+0x61>
80104240:	8b 14 85 8c 77 10 80 	mov    -0x7fef8874(,%eax,4),%edx
      state = "???";
80104247:	b8 2b 77 10 80       	mov    $0x8010772b,%eax
8010424c:	85 d2                	test   %edx,%edx
8010424e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104251:	53                   	push   %ebx
80104252:	52                   	push   %edx
80104253:	ff 73 a4             	pushl  -0x5c(%ebx)
80104256:	68 2f 77 10 80       	push   $0x8010772f
8010425b:	e8 50 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104260:	83 c4 10             	add    $0x10,%esp
80104263:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104267:	75 a7                	jne    80104210 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104269:	83 ec 08             	sub    $0x8,%esp
8010426c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010426f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104272:	50                   	push   %eax
80104273:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104276:	8b 40 0c             	mov    0xc(%eax),%eax
80104279:	83 c0 08             	add    $0x8,%eax
8010427c:	50                   	push   %eax
8010427d:	e8 9e 01 00 00       	call   80104420 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104282:	83 c4 10             	add    $0x10,%esp
80104285:	8d 76 00             	lea    0x0(%esi),%esi
80104288:	8b 17                	mov    (%edi),%edx
8010428a:	85 d2                	test   %edx,%edx
8010428c:	74 82                	je     80104210 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010428e:	83 ec 08             	sub    $0x8,%esp
80104291:	83 c7 04             	add    $0x4,%edi
80104294:	52                   	push   %edx
80104295:	68 81 71 10 80       	push   $0x80107181
8010429a:	e8 11 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	39 fe                	cmp    %edi,%esi
801042a4:	75 e2                	jne    80104288 <procdump+0x98>
801042a6:	e9 65 ff ff ff       	jmp    80104210 <procdump+0x20>
801042ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042af:	90                   	nop
  }
}
801042b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b3:	5b                   	pop    %ebx
801042b4:	5e                   	pop    %esi
801042b5:	5f                   	pop    %edi
801042b6:	5d                   	pop    %ebp
801042b7:	c3                   	ret    
801042b8:	66 90                	xchg   %ax,%ax
801042ba:	66 90                	xchg   %ax,%ax
801042bc:	66 90                	xchg   %ax,%ax
801042be:	66 90                	xchg   %ax,%ax

801042c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	53                   	push   %ebx
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ce:	68 a4 77 10 80       	push   $0x801077a4
801042d3:	8d 43 04             	lea    0x4(%ebx),%eax
801042d6:	50                   	push   %eax
801042d7:	e8 24 01 00 00       	call   80104400 <initlock>
  lk->name = name;
801042dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f5:	c9                   	leave  
801042f6:	c3                   	ret    
801042f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fe:	66 90                	xchg   %ax,%ax

80104300 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	56                   	push   %esi
80104308:	53                   	push   %ebx
80104309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010430c:	8d 73 04             	lea    0x4(%ebx),%esi
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	56                   	push   %esi
80104313:	e8 68 02 00 00       	call   80104580 <acquire>
  while (lk->locked) {
80104318:	8b 13                	mov    (%ebx),%edx
8010431a:	83 c4 10             	add    $0x10,%esp
8010431d:	85 d2                	test   %edx,%edx
8010431f:	74 1a                	je     8010433b <acquiresleep+0x3b>
80104321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104328:	83 ec 08             	sub    $0x8,%esp
8010432b:	56                   	push   %esi
8010432c:	53                   	push   %ebx
8010432d:	e8 0e fc ff ff       	call   80103f40 <sleep>
  while (lk->locked) {
80104332:	8b 03                	mov    (%ebx),%eax
80104334:	83 c4 10             	add    $0x10,%esp
80104337:	85 c0                	test   %eax,%eax
80104339:	75 ed                	jne    80104328 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010433b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104341:	e8 2a f6 ff ff       	call   80103970 <myproc>
80104346:	8b 40 14             	mov    0x14(%eax),%eax
80104349:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010434c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010434f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5d                   	pop    %ebp
  release(&lk->lk);
80104355:	e9 e6 02 00 00       	jmp    80104640 <release>
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104360 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	56                   	push   %esi
80104368:	53                   	push   %ebx
80104369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010436c:	8d 73 04             	lea    0x4(%ebx),%esi
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	56                   	push   %esi
80104373:	e8 08 02 00 00       	call   80104580 <acquire>
  lk->locked = 0;
80104378:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010437e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104385:	89 1c 24             	mov    %ebx,(%esp)
80104388:	e8 73 fd ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
8010438d:	89 75 08             	mov    %esi,0x8(%ebp)
80104390:	83 c4 10             	add    $0x10,%esp
}
80104393:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104396:	5b                   	pop    %ebx
80104397:	5e                   	pop    %esi
80104398:	5d                   	pop    %ebp
  release(&lk->lk);
80104399:	e9 a2 02 00 00       	jmp    80104640 <release>
8010439e:	66 90                	xchg   %ax,%ax

801043a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	57                   	push   %edi
801043a8:	31 ff                	xor    %edi,%edi
801043aa:	56                   	push   %esi
801043ab:	53                   	push   %ebx
801043ac:	83 ec 18             	sub    $0x18,%esp
801043af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043b2:	8d 73 04             	lea    0x4(%ebx),%esi
801043b5:	56                   	push   %esi
801043b6:	e8 c5 01 00 00       	call   80104580 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043bb:	8b 03                	mov    (%ebx),%eax
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	85 c0                	test   %eax,%eax
801043c2:	75 1c                	jne    801043e0 <holdingsleep+0x40>
  release(&lk->lk);
801043c4:	83 ec 0c             	sub    $0xc,%esp
801043c7:	56                   	push   %esi
801043c8:	e8 73 02 00 00       	call   80104640 <release>
  return r;
}
801043cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d0:	89 f8                	mov    %edi,%eax
801043d2:	5b                   	pop    %ebx
801043d3:	5e                   	pop    %esi
801043d4:	5f                   	pop    %edi
801043d5:	5d                   	pop    %ebp
801043d6:	c3                   	ret    
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801043e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043e3:	e8 88 f5 ff ff       	call   80103970 <myproc>
801043e8:	39 58 14             	cmp    %ebx,0x14(%eax)
801043eb:	0f 94 c0             	sete   %al
801043ee:	0f b6 c0             	movzbl %al,%eax
801043f1:	89 c7                	mov    %eax,%edi
801043f3:	eb cf                	jmp    801043c4 <holdingsleep+0x24>
801043f5:	66 90                	xchg   %ax,%ax
801043f7:	66 90                	xchg   %ax,%ax
801043f9:	66 90                	xchg   %ax,%ax
801043fb:	66 90                	xchg   %ax,%ax
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010440a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010440d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104413:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104416:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010441d:	5d                   	pop    %ebp
8010441e:	c3                   	ret    
8010441f:	90                   	nop

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104425:	31 d2                	xor    %edx,%edx
{
80104427:	89 e5                	mov    %esp,%ebp
80104429:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010442a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010442d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104430:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104438:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010443e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104444:	77 1a                	ja     80104460 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104446:	8b 58 04             	mov    0x4(%eax),%ebx
80104449:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010444c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010444f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104451:	83 fa 0a             	cmp    $0xa,%edx
80104454:	75 e2                	jne    80104438 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104456:	5b                   	pop    %ebx
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104460:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104463:	8d 51 28             	lea    0x28(%ecx),%edx
80104466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104476:	83 c0 04             	add    $0x4,%eax
80104479:	39 d0                	cmp    %edx,%eax
8010447b:	75 f3                	jne    80104470 <getcallerpcs+0x50>
}
8010447d:	5b                   	pop    %ebx
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 04             	sub    $0x4,%esp
8010448b:	9c                   	pushf  
8010448c:	5b                   	pop    %ebx
  asm volatile("cli");
8010448d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448e:	e8 4d f4 ff ff       	call   801038e0 <mycpu>
80104493:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104499:	85 c0                	test   %eax,%eax
8010449b:	74 13                	je     801044b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010449d:	e8 3e f4 ff ff       	call   801038e0 <mycpu>
801044a2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044a9:	83 c4 04             	add    $0x4,%esp
801044ac:	5b                   	pop    %ebx
801044ad:	5d                   	pop    %ebp
801044ae:	c3                   	ret    
801044af:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044b0:	e8 2b f4 ff ff       	call   801038e0 <mycpu>
801044b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044c1:	eb da                	jmp    8010449d <pushcli+0x1d>
801044c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <popcli>:

void
popcli(void)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044da:	9c                   	pushf  
801044db:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044dc:	f6 c4 02             	test   $0x2,%ah
801044df:	75 31                	jne    80104512 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044e1:	e8 fa f3 ff ff       	call   801038e0 <mycpu>
801044e6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044ed:	78 30                	js     8010451f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044ef:	e8 ec f3 ff ff       	call   801038e0 <mycpu>
801044f4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044fa:	85 d2                	test   %edx,%edx
801044fc:	74 02                	je     80104500 <popcli+0x30>
    sti();
}
801044fe:	c9                   	leave  
801044ff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104500:	e8 db f3 ff ff       	call   801038e0 <mycpu>
80104505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010450b:	85 c0                	test   %eax,%eax
8010450d:	74 ef                	je     801044fe <popcli+0x2e>
  asm volatile("sti");
8010450f:	fb                   	sti    
}
80104510:	c9                   	leave  
80104511:	c3                   	ret    
    panic("popcli - interruptible");
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	68 af 77 10 80       	push   $0x801077af
8010451a:	e8 71 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	68 c6 77 10 80       	push   $0x801077c6
80104527:	e8 64 be ff ff       	call   80100390 <panic>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <holding>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	56                   	push   %esi
80104538:	53                   	push   %ebx
80104539:	8b 75 08             	mov    0x8(%ebp),%esi
8010453c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010453e:	e8 3d ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104543:	8b 06                	mov    (%esi),%eax
80104545:	85 c0                	test   %eax,%eax
80104547:	75 0f                	jne    80104558 <holding+0x28>
  popcli();
80104549:	e8 82 ff ff ff       	call   801044d0 <popcli>
}
8010454e:	89 d8                	mov    %ebx,%eax
80104550:	5b                   	pop    %ebx
80104551:	5e                   	pop    %esi
80104552:	5d                   	pop    %ebp
80104553:	c3                   	ret    
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104558:	8b 5e 08             	mov    0x8(%esi),%ebx
8010455b:	e8 80 f3 ff ff       	call   801038e0 <mycpu>
80104560:	39 c3                	cmp    %eax,%ebx
80104562:	0f 94 c3             	sete   %bl
  popcli();
80104565:	e8 66 ff ff ff       	call   801044d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010456a:	0f b6 db             	movzbl %bl,%ebx
}
8010456d:	89 d8                	mov    %ebx,%eax
8010456f:	5b                   	pop    %ebx
80104570:	5e                   	pop    %esi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret    
80104573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <acquire>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	56                   	push   %esi
80104588:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104589:	e8 f2 fe ff ff       	call   80104480 <pushcli>
  if(holding(lk))
8010458e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104591:	83 ec 0c             	sub    $0xc,%esp
80104594:	53                   	push   %ebx
80104595:	e8 96 ff ff ff       	call   80104530 <holding>
8010459a:	83 c4 10             	add    $0x10,%esp
8010459d:	85 c0                	test   %eax,%eax
8010459f:	0f 85 7f 00 00 00    	jne    80104624 <acquire+0xa4>
801045a5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801045a7:	ba 01 00 00 00       	mov    $0x1,%edx
801045ac:	eb 05                	jmp    801045b3 <acquire+0x33>
801045ae:	66 90                	xchg   %ax,%ax
801045b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045b3:	89 d0                	mov    %edx,%eax
801045b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045b8:	85 c0                	test   %eax,%eax
801045ba:	75 f4                	jne    801045b0 <acquire+0x30>
  __sync_synchronize();
801045bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c4:	e8 17 f3 ff ff       	call   801038e0 <mycpu>
801045c9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801045cc:	89 e8                	mov    %ebp,%eax
801045ce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801045d6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801045dc:	77 22                	ja     80104600 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801045de:	8b 50 04             	mov    0x4(%eax),%edx
801045e1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801045e5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801045e8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045ea:	83 fe 0a             	cmp    $0xa,%esi
801045ed:	75 e1                	jne    801045d0 <acquire+0x50>
}
801045ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
801045f5:	c3                   	ret    
801045f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104600:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104604:	83 c3 34             	add    $0x34,%ebx
80104607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104616:	83 c0 04             	add    $0x4,%eax
80104619:	39 d8                	cmp    %ebx,%eax
8010461b:	75 f3                	jne    80104610 <acquire+0x90>
}
8010461d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104620:	5b                   	pop    %ebx
80104621:	5e                   	pop    %esi
80104622:	5d                   	pop    %ebp
80104623:	c3                   	ret    
    panic("acquire");
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	68 cd 77 10 80       	push   $0x801077cd
8010462c:	e8 5f bd ff ff       	call   80100390 <panic>
80104631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463f:	90                   	nop

80104640 <release>:
{
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	53                   	push   %ebx
80104648:	83 ec 10             	sub    $0x10,%esp
8010464b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010464e:	53                   	push   %ebx
8010464f:	e8 dc fe ff ff       	call   80104530 <holding>
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	85 c0                	test   %eax,%eax
80104659:	74 22                	je     8010467d <release+0x3d>
  lk->pcs[0] = 0;
8010465b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104662:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104669:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010466e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104677:	c9                   	leave  
  popcli();
80104678:	e9 53 fe ff ff       	jmp    801044d0 <popcli>
    panic("release");
8010467d:	83 ec 0c             	sub    $0xc,%esp
80104680:	68 d5 77 10 80       	push   $0x801077d5
80104685:	e8 06 bd ff ff       	call   80100390 <panic>
8010468a:	66 90                	xchg   %ax,%ax
8010468c:	66 90                	xchg   %ax,%ax
8010468e:	66 90                	xchg   %ax,%ax

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	57                   	push   %edi
80104698:	8b 55 08             	mov    0x8(%ebp),%edx
8010469b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469e:	53                   	push   %ebx
8010469f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046a2:	89 d7                	mov    %edx,%edi
801046a4:	09 cf                	or     %ecx,%edi
801046a6:	83 e7 03             	and    $0x3,%edi
801046a9:	75 25                	jne    801046d0 <memset+0x40>
    c &= 0xFF;
801046ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ae:	c1 e0 18             	shl    $0x18,%eax
801046b1:	89 fb                	mov    %edi,%ebx
801046b3:	c1 e9 02             	shr    $0x2,%ecx
801046b6:	c1 e3 10             	shl    $0x10,%ebx
801046b9:	09 d8                	or     %ebx,%eax
801046bb:	09 f8                	or     %edi,%eax
801046bd:	c1 e7 08             	shl    $0x8,%edi
801046c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046c2:	89 d7                	mov    %edx,%edi
801046c4:	fc                   	cld    
801046c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046c7:	5b                   	pop    %ebx
801046c8:	89 d0                	mov    %edx,%eax
801046ca:	5f                   	pop    %edi
801046cb:	5d                   	pop    %ebp
801046cc:	c3                   	ret    
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801046d0:	89 d7                	mov    %edx,%edi
801046d2:	fc                   	cld    
801046d3:	f3 aa                	rep stos %al,%es:(%edi)
801046d5:	5b                   	pop    %ebx
801046d6:	89 d0                	mov    %edx,%eax
801046d8:	5f                   	pop    %edi
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	8b 75 10             	mov    0x10(%ebp),%esi
801046eb:	8b 55 08             	mov    0x8(%ebp),%edx
801046ee:	53                   	push   %ebx
801046ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046f2:	85 f6                	test   %esi,%esi
801046f4:	74 2a                	je     80104720 <memcmp+0x40>
801046f6:	01 c6                	add    %eax,%esi
801046f8:	eb 10                	jmp    8010470a <memcmp+0x2a>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104706:	39 f0                	cmp    %esi,%eax
80104708:	74 16                	je     80104720 <memcmp+0x40>
    if(*s1 != *s2)
8010470a:	0f b6 0a             	movzbl (%edx),%ecx
8010470d:	0f b6 18             	movzbl (%eax),%ebx
80104710:	38 d9                	cmp    %bl,%cl
80104712:	74 ec                	je     80104700 <memcmp+0x20>
      return *s1 - *s2;
80104714:	0f b6 c1             	movzbl %cl,%eax
80104717:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104719:	5b                   	pop    %ebx
8010471a:	5e                   	pop    %esi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	5b                   	pop    %ebx
  return 0;
80104721:	31 c0                	xor    %eax,%eax
}
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	57                   	push   %edi
80104738:	8b 55 08             	mov    0x8(%ebp),%edx
8010473b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473e:	56                   	push   %esi
8010473f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104742:	39 d6                	cmp    %edx,%esi
80104744:	73 2a                	jae    80104770 <memmove+0x40>
80104746:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104749:	39 fa                	cmp    %edi,%edx
8010474b:	73 23                	jae    80104770 <memmove+0x40>
8010474d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104750:	85 c9                	test   %ecx,%ecx
80104752:	74 13                	je     80104767 <memmove+0x37>
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104758:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010475c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010475f:	83 e8 01             	sub    $0x1,%eax
80104762:	83 f8 ff             	cmp    $0xffffffff,%eax
80104765:	75 f1                	jne    80104758 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104767:	5e                   	pop    %esi
80104768:	89 d0                	mov    %edx,%eax
8010476a:	5f                   	pop    %edi
8010476b:	5d                   	pop    %ebp
8010476c:	c3                   	ret    
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104770:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104773:	89 d7                	mov    %edx,%edi
80104775:	85 c9                	test   %ecx,%ecx
80104777:	74 ee                	je     80104767 <memmove+0x37>
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104780:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104781:	39 f0                	cmp    %esi,%eax
80104783:	75 fb                	jne    80104780 <memmove+0x50>
}
80104785:	5e                   	pop    %esi
80104786:	89 d0                	mov    %edx,%eax
80104788:	5f                   	pop    %edi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104790:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104794:	eb 9a                	jmp    80104730 <memmove>
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	56                   	push   %esi
801047a8:	8b 75 10             	mov    0x10(%ebp),%esi
801047ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ae:	53                   	push   %ebx
801047af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801047b2:	85 f6                	test   %esi,%esi
801047b4:	74 32                	je     801047e8 <strncmp+0x48>
801047b6:	01 c6                	add    %eax,%esi
801047b8:	eb 14                	jmp    801047ce <strncmp+0x2e>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c0:	38 da                	cmp    %bl,%dl
801047c2:	75 14                	jne    801047d8 <strncmp+0x38>
    n--, p++, q++;
801047c4:	83 c0 01             	add    $0x1,%eax
801047c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ca:	39 f0                	cmp    %esi,%eax
801047cc:	74 1a                	je     801047e8 <strncmp+0x48>
801047ce:	0f b6 11             	movzbl (%ecx),%edx
801047d1:	0f b6 18             	movzbl (%eax),%ebx
801047d4:	84 d2                	test   %dl,%dl
801047d6:	75 e8                	jne    801047c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047d8:	0f b6 c2             	movzbl %dl,%eax
801047db:	29 d8                	sub    %ebx,%eax
}
801047dd:	5b                   	pop    %ebx
801047de:	5e                   	pop    %esi
801047df:	5d                   	pop    %ebp
801047e0:	c3                   	ret    
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e8:	5b                   	pop    %ebx
    return 0;
801047e9:	31 c0                	xor    %eax,%eax
}
801047eb:	5e                   	pop    %esi
801047ec:	5d                   	pop    %ebp
801047ed:	c3                   	ret    
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	57                   	push   %edi
801047f8:	56                   	push   %esi
801047f9:	8b 75 08             	mov    0x8(%ebp),%esi
801047fc:	53                   	push   %ebx
801047fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104800:	89 f2                	mov    %esi,%edx
80104802:	eb 1b                	jmp    8010481f <strncpy+0x2f>
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104808:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010480c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010480f:	83 c2 01             	add    $0x1,%edx
80104812:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104816:	89 f9                	mov    %edi,%ecx
80104818:	88 4a ff             	mov    %cl,-0x1(%edx)
8010481b:	84 c9                	test   %cl,%cl
8010481d:	74 09                	je     80104828 <strncpy+0x38>
8010481f:	89 c3                	mov    %eax,%ebx
80104821:	83 e8 01             	sub    $0x1,%eax
80104824:	85 db                	test   %ebx,%ebx
80104826:	7f e0                	jg     80104808 <strncpy+0x18>
    ;
  while(n-- > 0)
80104828:	89 d1                	mov    %edx,%ecx
8010482a:	85 c0                	test   %eax,%eax
8010482c:	7e 15                	jle    80104843 <strncpy+0x53>
8010482e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104830:	83 c1 01             	add    $0x1,%ecx
80104833:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104837:	89 c8                	mov    %ecx,%eax
80104839:	f7 d0                	not    %eax
8010483b:	01 d0                	add    %edx,%eax
8010483d:	01 d8                	add    %ebx,%eax
8010483f:	85 c0                	test   %eax,%eax
80104841:	7f ed                	jg     80104830 <strncpy+0x40>
  return os;
}
80104843:	5b                   	pop    %ebx
80104844:	89 f0                	mov    %esi,%eax
80104846:	5e                   	pop    %esi
80104847:	5f                   	pop    %edi
80104848:	5d                   	pop    %ebp
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	56                   	push   %esi
80104858:	8b 55 10             	mov    0x10(%ebp),%edx
8010485b:	8b 75 08             	mov    0x8(%ebp),%esi
8010485e:	53                   	push   %ebx
8010485f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104862:	85 d2                	test   %edx,%edx
80104864:	7e 21                	jle    80104887 <safestrcpy+0x37>
80104866:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010486a:	89 f2                	mov    %esi,%edx
8010486c:	eb 12                	jmp    80104880 <safestrcpy+0x30>
8010486e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104870:	0f b6 08             	movzbl (%eax),%ecx
80104873:	83 c0 01             	add    $0x1,%eax
80104876:	83 c2 01             	add    $0x1,%edx
80104879:	88 4a ff             	mov    %cl,-0x1(%edx)
8010487c:	84 c9                	test   %cl,%cl
8010487e:	74 04                	je     80104884 <safestrcpy+0x34>
80104880:	39 d8                	cmp    %ebx,%eax
80104882:	75 ec                	jne    80104870 <safestrcpy+0x20>
    ;
  *s = 0;
80104884:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104887:	89 f0                	mov    %esi,%eax
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <strlen>:

int
strlen(const char *s)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104895:	31 c0                	xor    %eax,%eax
{
80104897:	89 e5                	mov    %esp,%ebp
80104899:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010489c:	80 3a 00             	cmpb   $0x0,(%edx)
8010489f:	74 10                	je     801048b1 <strlen+0x21>
801048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a8:	83 c0 01             	add    $0x1,%eax
801048ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048af:	75 f7                	jne    801048a8 <strlen+0x18>
    ;
  return n;
}
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    

801048b3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048b7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048bb:	55                   	push   %ebp
  pushl %ebx
801048bc:	53                   	push   %ebx
  pushl %esi
801048bd:	56                   	push   %esi
  pushl %edi
801048be:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048bf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048c1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048c3:	5f                   	pop    %edi
  popl %esi
801048c4:	5e                   	pop    %esi
  popl %ebx
801048c5:	5b                   	pop    %ebx
  popl %ebp
801048c6:	5d                   	pop    %ebp
  ret
801048c7:	c3                   	ret    
801048c8:	66 90                	xchg   %ax,%ax
801048ca:	66 90                	xchg   %ax,%ax
801048cc:	66 90                	xchg   %ax,%ax
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	53                   	push   %ebx
801048d8:	83 ec 04             	sub    $0x4,%esp
801048db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048de:	e8 8d f0 ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048e3:	8b 40 04             	mov    0x4(%eax),%eax
801048e6:	39 d8                	cmp    %ebx,%eax
801048e8:	76 16                	jbe    80104900 <fetchint+0x30>
801048ea:	8d 53 04             	lea    0x4(%ebx),%edx
801048ed:	39 d0                	cmp    %edx,%eax
801048ef:	72 0f                	jb     80104900 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801048f4:	8b 13                	mov    (%ebx),%edx
801048f6:	89 10                	mov    %edx,(%eax)
  return 0;
801048f8:	31 c0                	xor    %eax,%eax
}
801048fa:	83 c4 04             	add    $0x4,%esp
801048fd:	5b                   	pop    %ebx
801048fe:	5d                   	pop    %ebp
801048ff:	c3                   	ret    
    return -1;
80104900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104905:	eb f3                	jmp    801048fa <fetchint+0x2a>
80104907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490e:	66 90                	xchg   %ax,%ax

80104910 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 04             	sub    $0x4,%esp
8010491b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010491e:	e8 4d f0 ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz)
80104923:	39 58 04             	cmp    %ebx,0x4(%eax)
80104926:	76 30                	jbe    80104958 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104928:	8b 55 0c             	mov    0xc(%ebp),%edx
8010492b:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010492d:	8b 50 04             	mov    0x4(%eax),%edx
  for(s = *pp; s < ep; s++){
80104930:	39 d3                	cmp    %edx,%ebx
80104932:	73 24                	jae    80104958 <fetchstr+0x48>
80104934:	89 d8                	mov    %ebx,%eax
80104936:	eb 0f                	jmp    80104947 <fetchstr+0x37>
80104938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493f:	90                   	nop
80104940:	83 c0 01             	add    $0x1,%eax
80104943:	39 c2                	cmp    %eax,%edx
80104945:	76 11                	jbe    80104958 <fetchstr+0x48>
    if(*s == 0)
80104947:	80 38 00             	cmpb   $0x0,(%eax)
8010494a:	75 f4                	jne    80104940 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010494c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010494f:	29 d8                	sub    %ebx,%eax
}
80104951:	5b                   	pop    %ebx
80104952:	5d                   	pop    %ebp
80104953:	c3                   	ret    
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104958:	83 c4 04             	add    $0x4,%esp
    return -1;
8010495b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104960:	5b                   	pop    %ebx
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
80104963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	56                   	push   %esi
80104978:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104979:	e8 f2 ef ff ff       	call   80103970 <myproc>
8010497e:	8b 55 08             	mov    0x8(%ebp),%edx
80104981:	8b 40 1c             	mov    0x1c(%eax),%eax
80104984:	8b 40 44             	mov    0x44(%eax),%eax
80104987:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010498a:	e8 e1 ef ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010498f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104992:	8b 40 04             	mov    0x4(%eax),%eax
80104995:	39 c6                	cmp    %eax,%esi
80104997:	73 17                	jae    801049b0 <argint+0x40>
80104999:	8d 53 08             	lea    0x8(%ebx),%edx
8010499c:	39 d0                	cmp    %edx,%eax
8010499e:	72 10                	jb     801049b0 <argint+0x40>
  *ip = *(int*)(addr);
801049a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049a3:	8b 53 04             	mov    0x4(%ebx),%edx
801049a6:	89 10                	mov    %edx,(%eax)
  return 0;
801049a8:	31 c0                	xor    %eax,%eax
}
801049aa:	5b                   	pop    %ebx
801049ab:	5e                   	pop    %esi
801049ac:	5d                   	pop    %ebp
801049ad:	c3                   	ret    
801049ae:	66 90                	xchg   %ax,%ax
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b5:	eb f3                	jmp    801049aa <argint+0x3a>
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	56                   	push   %esi
801049c8:	53                   	push   %ebx
801049c9:	83 ec 10             	sub    $0x10,%esp
801049cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049cf:	e8 9c ef ff ff       	call   80103970 <myproc>
 
  if(argint(n, &i) < 0)
801049d4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801049d7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801049d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049dc:	50                   	push   %eax
801049dd:	ff 75 08             	pushl  0x8(%ebp)
801049e0:	e8 8b ff ff ff       	call   80104970 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049e5:	83 c4 10             	add    $0x10,%esp
801049e8:	85 c0                	test   %eax,%eax
801049ea:	78 24                	js     80104a10 <argptr+0x50>
801049ec:	85 db                	test   %ebx,%ebx
801049ee:	78 20                	js     80104a10 <argptr+0x50>
801049f0:	8b 56 04             	mov    0x4(%esi),%edx
801049f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f6:	39 c2                	cmp    %eax,%edx
801049f8:	76 16                	jbe    80104a10 <argptr+0x50>
801049fa:	01 c3                	add    %eax,%ebx
801049fc:	39 da                	cmp    %ebx,%edx
801049fe:	72 10                	jb     80104a10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a00:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a03:	89 02                	mov    %eax,(%edx)
  return 0;
80104a05:	31 c0                	xor    %eax,%eax
}
80104a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0a:	5b                   	pop    %ebx
80104a0b:	5e                   	pop    %esi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a15:	eb f0                	jmp    80104a07 <argptr+0x47>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a2d:	50                   	push   %eax
80104a2e:	ff 75 08             	pushl  0x8(%ebp)
80104a31:	e8 3a ff ff ff       	call   80104970 <argint>
80104a36:	83 c4 10             	add    $0x10,%esp
80104a39:	85 c0                	test   %eax,%eax
80104a3b:	78 13                	js     80104a50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a3d:	83 ec 08             	sub    $0x8,%esp
80104a40:	ff 75 0c             	pushl  0xc(%ebp)
80104a43:	ff 75 f4             	pushl  -0xc(%ebp)
80104a46:	e8 c5 fe ff ff       	call   80104910 <fetchstr>
80104a4b:	83 c4 10             	add    $0x10,%esp
}
80104a4e:	c9                   	leave  
80104a4f:	c3                   	ret    
80104a50:	c9                   	leave  
    return -1;
80104a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a56:	c3                   	ret    
80104a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	53                   	push   %ebx
80104a68:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a6b:	e8 00 ef ff ff       	call   80103970 <myproc>
80104a70:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a72:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a75:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a78:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a7b:	83 fa 14             	cmp    $0x14,%edx
80104a7e:	77 20                	ja     80104aa0 <syscall+0x40>
80104a80:	8b 14 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%edx
80104a87:	85 d2                	test   %edx,%edx
80104a89:	74 15                	je     80104aa0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a8b:	ff d2                	call   *%edx
80104a8d:	89 c2                	mov    %eax,%edx
80104a8f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104a92:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a98:	c9                   	leave  
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104aa0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104aa1:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104aa4:	50                   	push   %eax
80104aa5:	ff 73 14             	pushl  0x14(%ebx)
80104aa8:	68 dd 77 10 80       	push   $0x801077dd
80104aad:	e8 fe bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ab2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104ab5:	83 c4 10             	add    $0x10,%esp
80104ab8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	66 90                	xchg   %ax,%ax
80104ac6:	66 90                	xchg   %ax,%ax
80104ac8:	66 90                	xchg   %ax,%ax
80104aca:	66 90                	xchg   %ax,%ax
80104acc:	66 90                	xchg   %ax,%ax
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ad5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ad8:	53                   	push   %ebx
80104ad9:	83 ec 34             	sub    $0x34,%esp
80104adc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ae2:	57                   	push   %edi
80104ae3:	50                   	push   %eax
{
80104ae4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ae7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104aea:	e8 71 d5 ff ff       	call   80102060 <nameiparent>
80104aef:	83 c4 10             	add    $0x10,%esp
80104af2:	85 c0                	test   %eax,%eax
80104af4:	0f 84 46 01 00 00    	je     80104c40 <create+0x170>
    return 0;
  ilock(dp);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	89 c3                	mov    %eax,%ebx
80104aff:	50                   	push   %eax
80104b00:	e8 6b cc ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b05:	83 c4 0c             	add    $0xc,%esp
80104b08:	6a 00                	push   $0x0
80104b0a:	57                   	push   %edi
80104b0b:	53                   	push   %ebx
80104b0c:	e8 af d1 ff ff       	call   80101cc0 <dirlookup>
80104b11:	83 c4 10             	add    $0x10,%esp
80104b14:	89 c6                	mov    %eax,%esi
80104b16:	85 c0                	test   %eax,%eax
80104b18:	74 56                	je     80104b70 <create+0xa0>
    iunlockput(dp);
80104b1a:	83 ec 0c             	sub    $0xc,%esp
80104b1d:	53                   	push   %ebx
80104b1e:	e8 ed ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b23:	89 34 24             	mov    %esi,(%esp)
80104b26:	e8 45 cc ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b2b:	83 c4 10             	add    $0x10,%esp
80104b2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b33:	75 1b                	jne    80104b50 <create+0x80>
80104b35:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b3a:	75 14                	jne    80104b50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b3f:	89 f0                	mov    %esi,%eax
80104b41:	5b                   	pop    %ebx
80104b42:	5e                   	pop    %esi
80104b43:	5f                   	pop    %edi
80104b44:	5d                   	pop    %ebp
80104b45:	c3                   	ret    
80104b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	56                   	push   %esi
    return 0;
80104b54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b56:	e8 b5 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104b5b:	83 c4 10             	add    $0x10,%esp
}
80104b5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b61:	89 f0                	mov    %esi,%eax
80104b63:	5b                   	pop    %ebx
80104b64:	5e                   	pop    %esi
80104b65:	5f                   	pop    %edi
80104b66:	5d                   	pop    %ebp
80104b67:	c3                   	ret    
80104b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b74:	83 ec 08             	sub    $0x8,%esp
80104b77:	50                   	push   %eax
80104b78:	ff 33                	pushl  (%ebx)
80104b7a:	e8 71 ca ff ff       	call   801015f0 <ialloc>
80104b7f:	83 c4 10             	add    $0x10,%esp
80104b82:	89 c6                	mov    %eax,%esi
80104b84:	85 c0                	test   %eax,%eax
80104b86:	0f 84 cd 00 00 00    	je     80104c59 <create+0x189>
  ilock(ip);
80104b8c:	83 ec 0c             	sub    $0xc,%esp
80104b8f:	50                   	push   %eax
80104b90:	e8 db cb ff ff       	call   80101770 <ilock>
  ip->major = major;
80104b95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ba1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ba5:	b8 01 00 00 00       	mov    $0x1,%eax
80104baa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bae:	89 34 24             	mov    %esi,(%esp)
80104bb1:	e8 fa ca ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bb6:	83 c4 10             	add    $0x10,%esp
80104bb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bbe:	74 30                	je     80104bf0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bc0:	83 ec 04             	sub    $0x4,%esp
80104bc3:	ff 76 04             	pushl  0x4(%esi)
80104bc6:	57                   	push   %edi
80104bc7:	53                   	push   %ebx
80104bc8:	e8 b3 d3 ff ff       	call   80101f80 <dirlink>
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 78                	js     80104c4c <create+0x17c>
  iunlockput(dp);
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	53                   	push   %ebx
80104bd8:	e8 33 ce ff ff       	call   80101a10 <iunlockput>
  return ip;
80104bdd:	83 c4 10             	add    $0x10,%esp
}
80104be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be3:	89 f0                	mov    %esi,%eax
80104be5:	5b                   	pop    %ebx
80104be6:	5e                   	pop    %esi
80104be7:	5f                   	pop    %edi
80104be8:	5d                   	pop    %ebp
80104be9:	c3                   	ret    
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104bf0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104bf3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104bf8:	53                   	push   %ebx
80104bf9:	e8 b2 ca ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bfe:	83 c4 0c             	add    $0xc,%esp
80104c01:	ff 76 04             	pushl  0x4(%esi)
80104c04:	68 74 78 10 80       	push   $0x80107874
80104c09:	56                   	push   %esi
80104c0a:	e8 71 d3 ff ff       	call   80101f80 <dirlink>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	78 18                	js     80104c2e <create+0x15e>
80104c16:	83 ec 04             	sub    $0x4,%esp
80104c19:	ff 73 04             	pushl  0x4(%ebx)
80104c1c:	68 73 78 10 80       	push   $0x80107873
80104c21:	56                   	push   %esi
80104c22:	e8 59 d3 ff ff       	call   80101f80 <dirlink>
80104c27:	83 c4 10             	add    $0x10,%esp
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	79 92                	jns    80104bc0 <create+0xf0>
      panic("create dots");
80104c2e:	83 ec 0c             	sub    $0xc,%esp
80104c31:	68 67 78 10 80       	push   $0x80107867
80104c36:	e8 55 b7 ff ff       	call   80100390 <panic>
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
}
80104c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c43:	31 f6                	xor    %esi,%esi
}
80104c45:	5b                   	pop    %ebx
80104c46:	89 f0                	mov    %esi,%eax
80104c48:	5e                   	pop    %esi
80104c49:	5f                   	pop    %edi
80104c4a:	5d                   	pop    %ebp
80104c4b:	c3                   	ret    
    panic("create: dirlink");
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	68 76 78 10 80       	push   $0x80107876
80104c54:	e8 37 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c59:	83 ec 0c             	sub    $0xc,%esp
80104c5c:	68 58 78 10 80       	push   $0x80107858
80104c61:	e8 2a b7 ff ff       	call   80100390 <panic>
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	89 d6                	mov    %edx,%esi
80104c76:	53                   	push   %ebx
80104c77:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c79:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c7f:	50                   	push   %eax
80104c80:	6a 00                	push   $0x0
80104c82:	e8 e9 fc ff ff       	call   80104970 <argint>
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 2a                	js     80104cb8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c92:	77 24                	ja     80104cb8 <argfd.constprop.0+0x48>
80104c94:	e8 d7 ec ff ff       	call   80103970 <myproc>
80104c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c9c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	74 14                	je     80104cb8 <argfd.constprop.0+0x48>
  if(pfd)
80104ca4:	85 db                	test   %ebx,%ebx
80104ca6:	74 02                	je     80104caa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ca8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104caa:	89 06                	mov    %eax,(%esi)
  return 0;
80104cac:	31 c0                	xor    %eax,%eax
}
80104cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb1:	5b                   	pop    %ebx
80104cb2:	5e                   	pop    %esi
80104cb3:	5d                   	pop    %ebp
80104cb4:	c3                   	ret    
80104cb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbd:	eb ef                	jmp    80104cae <argfd.constprop.0+0x3e>
80104cbf:	90                   	nop

80104cc0 <sys_dup>:
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104cc5:	31 c0                	xor    %eax,%eax
{
80104cc7:	89 e5                	mov    %esp,%ebp
80104cc9:	56                   	push   %esi
80104cca:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104ccb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104cce:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104cd1:	e8 9a ff ff ff       	call   80104c70 <argfd.constprop.0>
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	78 1e                	js     80104cf8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104cda:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104cdd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104cdf:	e8 8c ec ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104ce8:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104cec:	85 d2                	test   %edx,%edx
80104cee:	74 20                	je     80104d10 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104cf0:	83 c3 01             	add    $0x1,%ebx
80104cf3:	83 fb 10             	cmp    $0x10,%ebx
80104cf6:	75 f0                	jne    80104ce8 <sys_dup+0x28>
}
80104cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104cfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d00:	89 d8                	mov    %ebx,%eax
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5d                   	pop    %ebp
80104d05:	c3                   	ret    
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d10:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	ff 75 f4             	pushl  -0xc(%ebp)
80104d1a:	e8 61 c1 ff ff       	call   80100e80 <filedup>
  return fd;
80104d1f:	83 c4 10             	add    $0x10,%esp
}
80104d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d25:	89 d8                	mov    %ebx,%eax
80104d27:	5b                   	pop    %ebx
80104d28:	5e                   	pop    %esi
80104d29:	5d                   	pop    %ebp
80104d2a:	c3                   	ret    
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop

80104d30 <sys_read>:
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d35:	31 c0                	xor    %eax,%eax
{
80104d37:	89 e5                	mov    %esp,%ebp
80104d39:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d3c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3f:	e8 2c ff ff ff       	call   80104c70 <argfd.constprop.0>
80104d44:	85 c0                	test   %eax,%eax
80104d46:	78 48                	js     80104d90 <sys_read+0x60>
80104d48:	83 ec 08             	sub    $0x8,%esp
80104d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d4e:	50                   	push   %eax
80104d4f:	6a 02                	push   $0x2
80104d51:	e8 1a fc ff ff       	call   80104970 <argint>
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	78 33                	js     80104d90 <sys_read+0x60>
80104d5d:	83 ec 04             	sub    $0x4,%esp
80104d60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d63:	ff 75 f0             	pushl  -0x10(%ebp)
80104d66:	50                   	push   %eax
80104d67:	6a 01                	push   $0x1
80104d69:	e8 52 fc ff ff       	call   801049c0 <argptr>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 1b                	js     80104d90 <sys_read+0x60>
  return fileread(f, p, n);
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	pushl  -0x10(%ebp)
80104d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d81:	e8 7a c2 ff ff       	call   80101000 <fileread>
80104d86:	83 c4 10             	add    $0x10,%esp
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop
80104d90:	c9                   	leave  
    return -1;
80104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_write>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da5:	31 c0                	xor    %eax,%eax
{
80104da7:	89 e5                	mov    %esp,%ebp
80104da9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dac:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104daf:	e8 bc fe ff ff       	call   80104c70 <argfd.constprop.0>
80104db4:	85 c0                	test   %eax,%eax
80104db6:	78 48                	js     80104e00 <sys_write+0x60>
80104db8:	83 ec 08             	sub    $0x8,%esp
80104dbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dbe:	50                   	push   %eax
80104dbf:	6a 02                	push   $0x2
80104dc1:	e8 aa fb ff ff       	call   80104970 <argint>
80104dc6:	83 c4 10             	add    $0x10,%esp
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	78 33                	js     80104e00 <sys_write+0x60>
80104dcd:	83 ec 04             	sub    $0x4,%esp
80104dd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd3:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd6:	50                   	push   %eax
80104dd7:	6a 01                	push   $0x1
80104dd9:	e8 e2 fb ff ff       	call   801049c0 <argptr>
80104dde:	83 c4 10             	add    $0x10,%esp
80104de1:	85 c0                	test   %eax,%eax
80104de3:	78 1b                	js     80104e00 <sys_write+0x60>
  return filewrite(f, p, n);
80104de5:	83 ec 04             	sub    $0x4,%esp
80104de8:	ff 75 f0             	pushl  -0x10(%ebp)
80104deb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dee:	ff 75 ec             	pushl  -0x14(%ebp)
80104df1:	e8 aa c2 ff ff       	call   801010a0 <filewrite>
80104df6:	83 c4 10             	add    $0x10,%esp
}
80104df9:	c9                   	leave  
80104dfa:	c3                   	ret    
80104dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop
80104e00:	c9                   	leave  
    return -1;
80104e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e06:	c3                   	ret    
80104e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <sys_close>:
{
80104e10:	f3 0f 1e fb          	endbr32 
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e1a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e20:	e8 4b fe ff ff       	call   80104c70 <argfd.constprop.0>
80104e25:	85 c0                	test   %eax,%eax
80104e27:	78 27                	js     80104e50 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e29:	e8 42 eb ff ff       	call   80103970 <myproc>
80104e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e31:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e34:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104e3b:	00 
  fileclose(f);
80104e3c:	ff 75 f4             	pushl  -0xc(%ebp)
80104e3f:	e8 8c c0 ff ff       	call   80100ed0 <fileclose>
  return 0;
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	31 c0                	xor    %eax,%eax
}
80104e49:	c9                   	leave  
80104e4a:	c3                   	ret    
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop
80104e50:	c9                   	leave  
    return -1;
80104e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e56:	c3                   	ret    
80104e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <sys_fstat>:
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e65:	31 c0                	xor    %eax,%eax
{
80104e67:	89 e5                	mov    %esp,%ebp
80104e69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e6c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e6f:	e8 fc fd ff ff       	call   80104c70 <argfd.constprop.0>
80104e74:	85 c0                	test   %eax,%eax
80104e76:	78 30                	js     80104ea8 <sys_fstat+0x48>
80104e78:	83 ec 04             	sub    $0x4,%esp
80104e7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7e:	6a 14                	push   $0x14
80104e80:	50                   	push   %eax
80104e81:	6a 01                	push   $0x1
80104e83:	e8 38 fb ff ff       	call   801049c0 <argptr>
80104e88:	83 c4 10             	add    $0x10,%esp
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	78 19                	js     80104ea8 <sys_fstat+0x48>
  return filestat(f, st);
80104e8f:	83 ec 08             	sub    $0x8,%esp
80104e92:	ff 75 f4             	pushl  -0xc(%ebp)
80104e95:	ff 75 f0             	pushl  -0x10(%ebp)
80104e98:	e8 13 c1 ff ff       	call   80100fb0 <filestat>
80104e9d:	83 c4 10             	add    $0x10,%esp
}
80104ea0:	c9                   	leave  
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ea8:	c9                   	leave  
    return -1;
80104ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eae:	c3                   	ret    
80104eaf:	90                   	nop

80104eb0 <sys_link>:
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	57                   	push   %edi
80104eb8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104eb9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ebc:	53                   	push   %ebx
80104ebd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ec0:	50                   	push   %eax
80104ec1:	6a 00                	push   $0x0
80104ec3:	e8 58 fb ff ff       	call   80104a20 <argstr>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	0f 88 ff 00 00 00    	js     80104fd2 <sys_link+0x122>
80104ed3:	83 ec 08             	sub    $0x8,%esp
80104ed6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ed9:	50                   	push   %eax
80104eda:	6a 01                	push   $0x1
80104edc:	e8 3f fb ff ff       	call   80104a20 <argstr>
80104ee1:	83 c4 10             	add    $0x10,%esp
80104ee4:	85 c0                	test   %eax,%eax
80104ee6:	0f 88 e6 00 00 00    	js     80104fd2 <sys_link+0x122>
  begin_op();
80104eec:	e8 4f de ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80104ef1:	83 ec 0c             	sub    $0xc,%esp
80104ef4:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ef7:	e8 44 d1 ff ff       	call   80102040 <namei>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	89 c3                	mov    %eax,%ebx
80104f01:	85 c0                	test   %eax,%eax
80104f03:	0f 84 e8 00 00 00    	je     80104ff1 <sys_link+0x141>
  ilock(ip);
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	50                   	push   %eax
80104f0d:	e8 5e c8 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f1a:	0f 84 b9 00 00 00    	je     80104fd9 <sys_link+0x129>
  iupdate(ip);
80104f20:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f28:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f2b:	53                   	push   %ebx
80104f2c:	e8 7f c7 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80104f31:	89 1c 24             	mov    %ebx,(%esp)
80104f34:	e8 17 c9 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f39:	58                   	pop    %eax
80104f3a:	5a                   	pop    %edx
80104f3b:	57                   	push   %edi
80104f3c:	ff 75 d0             	pushl  -0x30(%ebp)
80104f3f:	e8 1c d1 ff ff       	call   80102060 <nameiparent>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	89 c6                	mov    %eax,%esi
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	74 5f                	je     80104fac <sys_link+0xfc>
  ilock(dp);
80104f4d:	83 ec 0c             	sub    $0xc,%esp
80104f50:	50                   	push   %eax
80104f51:	e8 1a c8 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f56:	8b 03                	mov    (%ebx),%eax
80104f58:	83 c4 10             	add    $0x10,%esp
80104f5b:	39 06                	cmp    %eax,(%esi)
80104f5d:	75 41                	jne    80104fa0 <sys_link+0xf0>
80104f5f:	83 ec 04             	sub    $0x4,%esp
80104f62:	ff 73 04             	pushl  0x4(%ebx)
80104f65:	57                   	push   %edi
80104f66:	56                   	push   %esi
80104f67:	e8 14 d0 ff ff       	call   80101f80 <dirlink>
80104f6c:	83 c4 10             	add    $0x10,%esp
80104f6f:	85 c0                	test   %eax,%eax
80104f71:	78 2d                	js     80104fa0 <sys_link+0xf0>
  iunlockput(dp);
80104f73:	83 ec 0c             	sub    $0xc,%esp
80104f76:	56                   	push   %esi
80104f77:	e8 94 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104f7c:	89 1c 24             	mov    %ebx,(%esp)
80104f7f:	e8 1c c9 ff ff       	call   801018a0 <iput>
  end_op();
80104f84:	e8 27 de ff ff       	call   80102db0 <end_op>
  return 0;
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	31 c0                	xor    %eax,%eax
}
80104f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f91:	5b                   	pop    %ebx
80104f92:	5e                   	pop    %esi
80104f93:	5f                   	pop    %edi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
80104fa3:	56                   	push   %esi
80104fa4:	e8 67 ca ff ff       	call   80101a10 <iunlockput>
    goto bad;
80104fa9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fac:	83 ec 0c             	sub    $0xc,%esp
80104faf:	53                   	push   %ebx
80104fb0:	e8 bb c7 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80104fb5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fba:	89 1c 24             	mov    %ebx,(%esp)
80104fbd:	e8 ee c6 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80104fc2:	89 1c 24             	mov    %ebx,(%esp)
80104fc5:	e8 46 ca ff ff       	call   80101a10 <iunlockput>
  end_op();
80104fca:	e8 e1 dd ff ff       	call   80102db0 <end_op>
  return -1;
80104fcf:	83 c4 10             	add    $0x10,%esp
80104fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd7:	eb b5                	jmp    80104f8e <sys_link+0xde>
    iunlockput(ip);
80104fd9:	83 ec 0c             	sub    $0xc,%esp
80104fdc:	53                   	push   %ebx
80104fdd:	e8 2e ca ff ff       	call   80101a10 <iunlockput>
    end_op();
80104fe2:	e8 c9 dd ff ff       	call   80102db0 <end_op>
    return -1;
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fef:	eb 9d                	jmp    80104f8e <sys_link+0xde>
    end_op();
80104ff1:	e8 ba dd ff ff       	call   80102db0 <end_op>
    return -1;
80104ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffb:	eb 91                	jmp    80104f8e <sys_link+0xde>
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <sys_unlink>:
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	57                   	push   %edi
80105008:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105009:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010500c:	53                   	push   %ebx
8010500d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105010:	50                   	push   %eax
80105011:	6a 00                	push   $0x0
80105013:	e8 08 fa ff ff       	call   80104a20 <argstr>
80105018:	83 c4 10             	add    $0x10,%esp
8010501b:	85 c0                	test   %eax,%eax
8010501d:	0f 88 7d 01 00 00    	js     801051a0 <sys_unlink+0x1a0>
  begin_op();
80105023:	e8 18 dd ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105028:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010502b:	83 ec 08             	sub    $0x8,%esp
8010502e:	53                   	push   %ebx
8010502f:	ff 75 c0             	pushl  -0x40(%ebp)
80105032:	e8 29 d0 ff ff       	call   80102060 <nameiparent>
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	89 c6                	mov    %eax,%esi
8010503c:	85 c0                	test   %eax,%eax
8010503e:	0f 84 66 01 00 00    	je     801051aa <sys_unlink+0x1aa>
  ilock(dp);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	50                   	push   %eax
80105048:	e8 23 c7 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010504d:	58                   	pop    %eax
8010504e:	5a                   	pop    %edx
8010504f:	68 74 78 10 80       	push   $0x80107874
80105054:	53                   	push   %ebx
80105055:	e8 46 cc ff ff       	call   80101ca0 <namecmp>
8010505a:	83 c4 10             	add    $0x10,%esp
8010505d:	85 c0                	test   %eax,%eax
8010505f:	0f 84 03 01 00 00    	je     80105168 <sys_unlink+0x168>
80105065:	83 ec 08             	sub    $0x8,%esp
80105068:	68 73 78 10 80       	push   $0x80107873
8010506d:	53                   	push   %ebx
8010506e:	e8 2d cc ff ff       	call   80101ca0 <namecmp>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	0f 84 ea 00 00 00    	je     80105168 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010507e:	83 ec 04             	sub    $0x4,%esp
80105081:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105084:	50                   	push   %eax
80105085:	53                   	push   %ebx
80105086:	56                   	push   %esi
80105087:	e8 34 cc ff ff       	call   80101cc0 <dirlookup>
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	89 c3                	mov    %eax,%ebx
80105091:	85 c0                	test   %eax,%eax
80105093:	0f 84 cf 00 00 00    	je     80105168 <sys_unlink+0x168>
  ilock(ip);
80105099:	83 ec 0c             	sub    $0xc,%esp
8010509c:	50                   	push   %eax
8010509d:	e8 ce c6 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050aa:	0f 8e 23 01 00 00    	jle    801051d3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050b8:	74 66                	je     80105120 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050ba:	83 ec 04             	sub    $0x4,%esp
801050bd:	6a 10                	push   $0x10
801050bf:	6a 00                	push   $0x0
801050c1:	57                   	push   %edi
801050c2:	e8 c9 f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050c7:	6a 10                	push   $0x10
801050c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801050cc:	57                   	push   %edi
801050cd:	56                   	push   %esi
801050ce:	e8 9d ca ff ff       	call   80101b70 <writei>
801050d3:	83 c4 20             	add    $0x20,%esp
801050d6:	83 f8 10             	cmp    $0x10,%eax
801050d9:	0f 85 e7 00 00 00    	jne    801051c6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801050df:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050e4:	0f 84 96 00 00 00    	je     80105180 <sys_unlink+0x180>
  iunlockput(dp);
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	56                   	push   %esi
801050ee:	e8 1d c9 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801050f3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050f8:	89 1c 24             	mov    %ebx,(%esp)
801050fb:	e8 b0 c5 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105100:	89 1c 24             	mov    %ebx,(%esp)
80105103:	e8 08 c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105108:	e8 a3 dc ff ff       	call   80102db0 <end_op>
  return 0;
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	31 c0                	xor    %eax,%eax
}
80105112:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105115:	5b                   	pop    %ebx
80105116:	5e                   	pop    %esi
80105117:	5f                   	pop    %edi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret    
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105120:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105124:	76 94                	jbe    801050ba <sys_unlink+0xba>
80105126:	ba 20 00 00 00       	mov    $0x20,%edx
8010512b:	eb 0b                	jmp    80105138 <sys_unlink+0x138>
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c2 10             	add    $0x10,%edx
80105133:	39 53 58             	cmp    %edx,0x58(%ebx)
80105136:	76 82                	jbe    801050ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105138:	6a 10                	push   $0x10
8010513a:	52                   	push   %edx
8010513b:	57                   	push   %edi
8010513c:	53                   	push   %ebx
8010513d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105140:	e8 2b c9 ff ff       	call   80101a70 <readi>
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010514b:	83 f8 10             	cmp    $0x10,%eax
8010514e:	75 69                	jne    801051b9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105150:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105155:	74 d9                	je     80105130 <sys_unlink+0x130>
    iunlockput(ip);
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	53                   	push   %ebx
8010515b:	e8 b0 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105167:	90                   	nop
  iunlockput(dp);
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	56                   	push   %esi
8010516c:	e8 9f c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105171:	e8 3a dc ff ff       	call   80102db0 <end_op>
  return -1;
80105176:	83 c4 10             	add    $0x10,%esp
80105179:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517e:	eb 92                	jmp    80105112 <sys_unlink+0x112>
    iupdate(dp);
80105180:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105183:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105188:	56                   	push   %esi
80105189:	e8 22 c5 ff ff       	call   801016b0 <iupdate>
8010518e:	83 c4 10             	add    $0x10,%esp
80105191:	e9 54 ff ff ff       	jmp    801050ea <sys_unlink+0xea>
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a5:	e9 68 ff ff ff       	jmp    80105112 <sys_unlink+0x112>
    end_op();
801051aa:	e8 01 dc ff ff       	call   80102db0 <end_op>
    return -1;
801051af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b4:	e9 59 ff ff ff       	jmp    80105112 <sys_unlink+0x112>
      panic("isdirempty: readi");
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	68 98 78 10 80       	push   $0x80107898
801051c1:	e8 ca b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801051c6:	83 ec 0c             	sub    $0xc,%esp
801051c9:	68 aa 78 10 80       	push   $0x801078aa
801051ce:	e8 bd b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801051d3:	83 ec 0c             	sub    $0xc,%esp
801051d6:	68 86 78 10 80       	push   $0x80107886
801051db:	e8 b0 b1 ff ff       	call   80100390 <panic>

801051e0 <sys_open>:

int
sys_open(void)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	57                   	push   %edi
801051e8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801051ec:	53                   	push   %ebx
801051ed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051f0:	50                   	push   %eax
801051f1:	6a 00                	push   $0x0
801051f3:	e8 28 f8 ff ff       	call   80104a20 <argstr>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	0f 88 8a 00 00 00    	js     8010528d <sys_open+0xad>
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105209:	50                   	push   %eax
8010520a:	6a 01                	push   $0x1
8010520c:	e8 5f f7 ff ff       	call   80104970 <argint>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	85 c0                	test   %eax,%eax
80105216:	78 75                	js     8010528d <sys_open+0xad>
    return -1;

  begin_op();
80105218:	e8 23 db ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010521d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105221:	75 75                	jne    80105298 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105223:	83 ec 0c             	sub    $0xc,%esp
80105226:	ff 75 e0             	pushl  -0x20(%ebp)
80105229:	e8 12 ce ff ff       	call   80102040 <namei>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	89 c6                	mov    %eax,%esi
80105233:	85 c0                	test   %eax,%eax
80105235:	74 7e                	je     801052b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	50                   	push   %eax
8010523b:	e8 30 c5 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105248:	0f 84 c2 00 00 00    	je     80105310 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010524e:	e8 bd bb ff ff       	call   80100e10 <filealloc>
80105253:	89 c7                	mov    %eax,%edi
80105255:	85 c0                	test   %eax,%eax
80105257:	74 23                	je     8010527c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105259:	e8 12 e7 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010525e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105260:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105264:	85 d2                	test   %edx,%edx
80105266:	74 60                	je     801052c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105268:	83 c3 01             	add    $0x1,%ebx
8010526b:	83 fb 10             	cmp    $0x10,%ebx
8010526e:	75 f0                	jne    80105260 <sys_open+0x80>
    if(f)
      fileclose(f);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	57                   	push   %edi
80105274:	e8 57 bc ff ff       	call   80100ed0 <fileclose>
80105279:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	56                   	push   %esi
80105280:	e8 8b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105285:	e8 26 db ff ff       	call   80102db0 <end_op>
    return -1;
8010528a:	83 c4 10             	add    $0x10,%esp
8010528d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105292:	eb 6d                	jmp    80105301 <sys_open+0x121>
80105294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010529e:	31 c9                	xor    %ecx,%ecx
801052a0:	ba 02 00 00 00       	mov    $0x2,%edx
801052a5:	6a 00                	push   $0x0
801052a7:	e8 24 f8 ff ff       	call   80104ad0 <create>
    if(ip == 0){
801052ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052b1:	85 c0                	test   %eax,%eax
801052b3:	75 99                	jne    8010524e <sys_open+0x6e>
      end_op();
801052b5:	e8 f6 da ff ff       	call   80102db0 <end_op>
      return -1;
801052ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052bf:	eb 40                	jmp    80105301 <sys_open+0x121>
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052cb:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
801052cf:	56                   	push   %esi
801052d0:	e8 7b c5 ff ff       	call   80101850 <iunlock>
  end_op();
801052d5:	e8 d6 da ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
801052da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801052e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801052e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801052eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801052f2:	f7 d0                	not    %eax
801052f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801052fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105304:	89 d8                	mov    %ebx,%eax
80105306:	5b                   	pop    %ebx
80105307:	5e                   	pop    %esi
80105308:	5f                   	pop    %edi
80105309:	5d                   	pop    %ebp
8010530a:	c3                   	ret    
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105313:	85 c9                	test   %ecx,%ecx
80105315:	0f 84 33 ff ff ff    	je     8010524e <sys_open+0x6e>
8010531b:	e9 5c ff ff ff       	jmp    8010527c <sys_open+0x9c>

80105320 <sys_mkdir>:

int
sys_mkdir(void)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010532a:	e8 11 da ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010532f:	83 ec 08             	sub    $0x8,%esp
80105332:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105335:	50                   	push   %eax
80105336:	6a 00                	push   $0x0
80105338:	e8 e3 f6 ff ff       	call   80104a20 <argstr>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	85 c0                	test   %eax,%eax
80105342:	78 34                	js     80105378 <sys_mkdir+0x58>
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534a:	31 c9                	xor    %ecx,%ecx
8010534c:	ba 01 00 00 00       	mov    $0x1,%edx
80105351:	6a 00                	push   $0x0
80105353:	e8 78 f7 ff ff       	call   80104ad0 <create>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	74 19                	je     80105378 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	50                   	push   %eax
80105363:	e8 a8 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105368:	e8 43 da ff ff       	call   80102db0 <end_op>
  return 0;
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	31 c0                	xor    %eax,%eax
}
80105372:	c9                   	leave  
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105378:	e8 33 da ff ff       	call   80102db0 <end_op>
    return -1;
8010537d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105382:	c9                   	leave  
80105383:	c3                   	ret    
80105384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop

80105390 <sys_mknod>:

int
sys_mknod(void)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010539a:	e8 a1 d9 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010539f:	83 ec 08             	sub    $0x8,%esp
801053a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053a5:	50                   	push   %eax
801053a6:	6a 00                	push   $0x0
801053a8:	e8 73 f6 ff ff       	call   80104a20 <argstr>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	78 64                	js     80105418 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801053b4:	83 ec 08             	sub    $0x8,%esp
801053b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ba:	50                   	push   %eax
801053bb:	6a 01                	push   $0x1
801053bd:	e8 ae f5 ff ff       	call   80104970 <argint>
  if((argstr(0, &path)) < 0 ||
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	85 c0                	test   %eax,%eax
801053c7:	78 4f                	js     80105418 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801053c9:	83 ec 08             	sub    $0x8,%esp
801053cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053cf:	50                   	push   %eax
801053d0:	6a 02                	push   $0x2
801053d2:	e8 99 f5 ff ff       	call   80104970 <argint>
     argint(1, &major) < 0 ||
801053d7:	83 c4 10             	add    $0x10,%esp
801053da:	85 c0                	test   %eax,%eax
801053dc:	78 3a                	js     80105418 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053de:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053e2:	83 ec 0c             	sub    $0xc,%esp
801053e5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053e9:	ba 03 00 00 00       	mov    $0x3,%edx
801053ee:	50                   	push   %eax
801053ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053f2:	e8 d9 f6 ff ff       	call   80104ad0 <create>
     argint(2, &minor) < 0 ||
801053f7:	83 c4 10             	add    $0x10,%esp
801053fa:	85 c0                	test   %eax,%eax
801053fc:	74 1a                	je     80105418 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053fe:	83 ec 0c             	sub    $0xc,%esp
80105401:	50                   	push   %eax
80105402:	e8 09 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105407:	e8 a4 d9 ff ff       	call   80102db0 <end_op>
  return 0;
8010540c:	83 c4 10             	add    $0x10,%esp
8010540f:	31 c0                	xor    %eax,%eax
}
80105411:	c9                   	leave  
80105412:	c3                   	ret    
80105413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105417:	90                   	nop
    end_op();
80105418:	e8 93 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010541d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105422:	c9                   	leave  
80105423:	c3                   	ret    
80105424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop

80105430 <sys_chdir>:

int
sys_chdir(void)
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	56                   	push   %esi
80105438:	53                   	push   %ebx
80105439:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010543c:	e8 2f e5 ff ff       	call   80103970 <myproc>
80105441:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105443:	e8 f8 d8 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105448:	83 ec 08             	sub    $0x8,%esp
8010544b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544e:	50                   	push   %eax
8010544f:	6a 00                	push   $0x0
80105451:	e8 ca f5 ff ff       	call   80104a20 <argstr>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 73                	js     801054d0 <sys_chdir+0xa0>
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	ff 75 f4             	pushl  -0xc(%ebp)
80105463:	e8 d8 cb ff ff       	call   80102040 <namei>
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	89 c3                	mov    %eax,%ebx
8010546d:	85 c0                	test   %eax,%eax
8010546f:	74 5f                	je     801054d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105471:	83 ec 0c             	sub    $0xc,%esp
80105474:	50                   	push   %eax
80105475:	e8 f6 c2 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105482:	75 2c                	jne    801054b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	53                   	push   %ebx
80105488:	e8 c3 c3 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
8010548d:	58                   	pop    %eax
8010548e:	ff 76 6c             	pushl  0x6c(%esi)
80105491:	e8 0a c4 ff ff       	call   801018a0 <iput>
  end_op();
80105496:	e8 15 d9 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
8010549b:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	31 c0                	xor    %eax,%eax
}
801054a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a6:	5b                   	pop    %ebx
801054a7:	5e                   	pop    %esi
801054a8:	5d                   	pop    %ebp
801054a9:	c3                   	ret    
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 57 c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054b9:	e8 f2 d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c6:	eb db                	jmp    801054a3 <sys_chdir+0x73>
801054c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop
    end_op();
801054d0:	e8 db d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054da:	eb c7                	jmp    801054a3 <sys_chdir+0x73>
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_exec>:

int
sys_exec(void)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	57                   	push   %edi
801054e8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054e9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054ef:	53                   	push   %ebx
801054f0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054f6:	50                   	push   %eax
801054f7:	6a 00                	push   $0x0
801054f9:	e8 22 f5 ff ff       	call   80104a20 <argstr>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	0f 88 8b 00 00 00    	js     80105594 <sys_exec+0xb4>
80105509:	83 ec 08             	sub    $0x8,%esp
8010550c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105512:	50                   	push   %eax
80105513:	6a 01                	push   $0x1
80105515:	e8 56 f4 ff ff       	call   80104970 <argint>
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	85 c0                	test   %eax,%eax
8010551f:	78 73                	js     80105594 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105521:	83 ec 04             	sub    $0x4,%esp
80105524:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010552a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010552c:	68 80 00 00 00       	push   $0x80
80105531:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105537:	6a 00                	push   $0x0
80105539:	50                   	push   %eax
8010553a:	e8 51 f1 ff ff       	call   80104690 <memset>
8010553f:	83 c4 10             	add    $0x10,%esp
80105542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105548:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010554e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	57                   	push   %edi
80105559:	01 f0                	add    %esi,%eax
8010555b:	50                   	push   %eax
8010555c:	e8 6f f3 ff ff       	call   801048d0 <fetchint>
80105561:	83 c4 10             	add    $0x10,%esp
80105564:	85 c0                	test   %eax,%eax
80105566:	78 2c                	js     80105594 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105568:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010556e:	85 c0                	test   %eax,%eax
80105570:	74 36                	je     801055a8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105572:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105578:	83 ec 08             	sub    $0x8,%esp
8010557b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010557e:	52                   	push   %edx
8010557f:	50                   	push   %eax
80105580:	e8 8b f3 ff ff       	call   80104910 <fetchstr>
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	85 c0                	test   %eax,%eax
8010558a:	78 08                	js     80105594 <sys_exec+0xb4>
  for(i=0;; i++){
8010558c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010558f:	83 fb 20             	cmp    $0x20,%ebx
80105592:	75 b4                	jne    80105548 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105594:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010559c:	5b                   	pop    %ebx
8010559d:	5e                   	pop    %esi
8010559e:	5f                   	pop    %edi
8010559f:	5d                   	pop    %ebp
801055a0:	c3                   	ret    
801055a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055a8:	83 ec 08             	sub    $0x8,%esp
801055ab:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801055b1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055b8:	00 00 00 00 
  return exec(path, argv);
801055bc:	50                   	push   %eax
801055bd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055c3:	e8 b8 b4 ff ff       	call   80100a80 <exec>
801055c8:	83 c4 10             	add    $0x10,%esp
}
801055cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055ce:	5b                   	pop    %ebx
801055cf:	5e                   	pop    %esi
801055d0:	5f                   	pop    %edi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055e0 <sys_pipe>:

int
sys_pipe(void)
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	57                   	push   %edi
801055e8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055e9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055ec:	53                   	push   %ebx
801055ed:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055f0:	6a 08                	push   $0x8
801055f2:	50                   	push   %eax
801055f3:	6a 00                	push   $0x0
801055f5:	e8 c6 f3 ff ff       	call   801049c0 <argptr>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	78 4e                	js     8010564f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105601:	83 ec 08             	sub    $0x8,%esp
80105604:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105607:	50                   	push   %eax
80105608:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010560b:	50                   	push   %eax
8010560c:	e8 ef dd ff ff       	call   80103400 <pipealloc>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	78 37                	js     8010564f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105618:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010561b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010561d:	e8 4e e3 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105628:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
8010562c:	85 f6                	test   %esi,%esi
8010562e:	74 30                	je     80105660 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105630:	83 c3 01             	add    $0x1,%ebx
80105633:	83 fb 10             	cmp    $0x10,%ebx
80105636:	75 f0                	jne    80105628 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	ff 75 e0             	pushl  -0x20(%ebp)
8010563e:	e8 8d b8 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105643:	58                   	pop    %eax
80105644:	ff 75 e4             	pushl  -0x1c(%ebp)
80105647:	e8 84 b8 ff ff       	call   80100ed0 <fileclose>
    return -1;
8010564c:	83 c4 10             	add    $0x10,%esp
8010564f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105654:	eb 5b                	jmp    801056b1 <sys_pipe+0xd1>
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105660:	8d 73 08             	lea    0x8(%ebx),%esi
80105663:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010566a:	e8 01 e3 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010566f:	31 d2                	xor    %edx,%edx
80105671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105678:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010567c:	85 c9                	test   %ecx,%ecx
8010567e:	74 20                	je     801056a0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105680:	83 c2 01             	add    $0x1,%edx
80105683:	83 fa 10             	cmp    $0x10,%edx
80105686:	75 f0                	jne    80105678 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105688:	e8 e3 e2 ff ff       	call   80103970 <myproc>
8010568d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105694:	00 
80105695:	eb a1                	jmp    80105638 <sys_pipe+0x58>
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056a0:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
801056a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056af:	31 c0                	xor    %eax,%eax
}
801056b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b4:	5b                   	pop    %ebx
801056b5:	5e                   	pop    %esi
801056b6:	5f                   	pop    %edi
801056b7:	5d                   	pop    %ebp
801056b8:	c3                   	ret    
801056b9:	66 90                	xchg   %ax,%ax
801056bb:	66 90                	xchg   %ax,%ax
801056bd:	66 90                	xchg   %ax,%ax
801056bf:	90                   	nop

801056c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
  return fork();
801056c4:	e9 57 e4 ff ff       	jmp    80103b20 <fork>
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_exit>:
}

int
sys_exit(void)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 08             	sub    $0x8,%esp
  exit();
801056da:	e8 d1 e6 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
801056df:	31 c0                	xor    %eax,%eax
801056e1:	c9                   	leave  
801056e2:	c3                   	ret    
801056e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056f0 <sys_wait>:

int
sys_wait(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
  return wait();
801056f4:	e9 07 e9 ff ff       	jmp    80104000 <wait>
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_kill>:
}

int
sys_kill(void)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010570a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010570d:	50                   	push   %eax
8010570e:	6a 00                	push   $0x0
80105710:	e8 5b f2 ff ff       	call   80104970 <argint>
80105715:	83 c4 10             	add    $0x10,%esp
80105718:	85 c0                	test   %eax,%eax
8010571a:	78 14                	js     80105730 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010571c:	83 ec 0c             	sub    $0xc,%esp
8010571f:	ff 75 f4             	pushl  -0xc(%ebp)
80105722:	e8 39 ea ff ff       	call   80104160 <kill>
80105727:	83 c4 10             	add    $0x10,%esp
}
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105730:	c9                   	leave  
    return -1;
80105731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105736:	c3                   	ret    
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax

80105740 <sys_getpid>:

int
sys_getpid(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010574a:	e8 21 e2 ff ff       	call   80103970 <myproc>
8010574f:	8b 40 14             	mov    0x14(%eax),%eax
}
80105752:	c9                   	leave  
80105753:	c3                   	ret    
80105754:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop

80105760 <sys_sbrk>:

int
sys_sbrk(void)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105768:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010576b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010576e:	50                   	push   %eax
8010576f:	6a 00                	push   $0x0
80105771:	e8 fa f1 ff ff       	call   80104970 <argint>
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 23                	js     801057a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010577d:	e8 ee e1 ff ff       	call   80103970 <myproc>
  if(growproc(n) < 0)
80105782:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105785:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
80105788:	ff 75 f4             	pushl  -0xc(%ebp)
8010578b:	e8 10 e3 ff ff       	call   80103aa0 <growproc>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	85 c0                	test   %eax,%eax
80105795:	78 09                	js     801057a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105797:	89 d8                	mov    %ebx,%eax
80105799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010579c:	c9                   	leave  
8010579d:	c3                   	ret    
8010579e:	66 90                	xchg   %ax,%ax
    return -1;
801057a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057a5:	eb f0                	jmp    80105797 <sys_sbrk+0x37>
801057a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_sleep>:

int
sys_sleep(void)
{
801057b0:	f3 0f 1e fb          	endbr32 
801057b4:	55                   	push   %ebp
801057b5:	89 e5                	mov    %esp,%ebp
801057b7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057bb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057be:	50                   	push   %eax
801057bf:	6a 00                	push   $0x0
801057c1:	e8 aa f1 ff ff       	call   80104970 <argint>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	0f 88 86 00 00 00    	js     80105857 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057d1:	83 ec 0c             	sub    $0xc,%esp
801057d4:	68 60 4d 11 80       	push   $0x80114d60
801057d9:	e8 a2 ed ff ff       	call   80104580 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057e1:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
801057e7:	83 c4 10             	add    $0x10,%esp
801057ea:	85 d2                	test   %edx,%edx
801057ec:	75 23                	jne    80105811 <sys_sleep+0x61>
801057ee:	eb 50                	jmp    80105840 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	68 60 4d 11 80       	push   $0x80114d60
801057f8:	68 a0 55 11 80       	push   $0x801155a0
801057fd:	e8 3e e7 ff ff       	call   80103f40 <sleep>
  while(ticks - ticks0 < n){
80105802:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	29 d8                	sub    %ebx,%eax
8010580c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010580f:	73 2f                	jae    80105840 <sys_sleep+0x90>
    if(myproc()->killed){
80105811:	e8 5a e1 ff ff       	call   80103970 <myproc>
80105816:	8b 40 28             	mov    0x28(%eax),%eax
80105819:	85 c0                	test   %eax,%eax
8010581b:	74 d3                	je     801057f0 <sys_sleep+0x40>
      release(&tickslock);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	68 60 4d 11 80       	push   $0x80114d60
80105825:	e8 16 ee ff ff       	call   80104640 <release>
  }
  release(&tickslock);
  return 0;
}
8010582a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	68 60 4d 11 80       	push   $0x80114d60
80105848:	e8 f3 ed ff ff       	call   80104640 <release>
  return 0;
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	31 c0                	xor    %eax,%eax
}
80105852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105855:	c9                   	leave  
80105856:	c3                   	ret    
    return -1;
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	eb f4                	jmp    80105852 <sys_sleep+0xa2>
8010585e:	66 90                	xchg   %ax,%ax

80105860 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	53                   	push   %ebx
80105868:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010586b:	68 60 4d 11 80       	push   $0x80114d60
80105870:	e8 0b ed ff ff       	call   80104580 <acquire>
  xticks = ticks;
80105875:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
8010587b:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105882:	e8 b9 ed ff ff       	call   80104640 <release>
  return xticks;
}
80105887:	89 d8                	mov    %ebx,%eax
80105889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010588c:	c9                   	leave  
8010588d:	c3                   	ret    

8010588e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010588e:	1e                   	push   %ds
  pushl %es
8010588f:	06                   	push   %es
  pushl %fs
80105890:	0f a0                	push   %fs
  pushl %gs
80105892:	0f a8                	push   %gs
  pushal
80105894:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105895:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105899:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010589b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010589d:	54                   	push   %esp
  call trap
8010589e:	e8 cd 00 00 00       	call   80105970 <trap>
  addl $4, %esp
801058a3:	83 c4 04             	add    $0x4,%esp

801058a6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058a6:	61                   	popa   
  popl %gs
801058a7:	0f a9                	pop    %gs
  popl %fs
801058a9:	0f a1                	pop    %fs
  popl %es
801058ab:	07                   	pop    %es
  popl %ds
801058ac:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058ad:	83 c4 08             	add    $0x8,%esp
  iret
801058b0:	cf                   	iret   
801058b1:	66 90                	xchg   %ax,%ax
801058b3:	66 90                	xchg   %ax,%ax
801058b5:	66 90                	xchg   %ax,%ax
801058b7:	66 90                	xchg   %ax,%ax
801058b9:	66 90                	xchg   %ax,%ax
801058bb:	66 90                	xchg   %ax,%ax
801058bd:	66 90                	xchg   %ax,%ax
801058bf:	90                   	nop

801058c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058c5:	31 c0                	xor    %eax,%eax
{
801058c7:	89 e5                	mov    %esp,%ebp
801058c9:	83 ec 08             	sub    $0x8,%esp
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058d0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058d7:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
801058de:	08 00 00 8e 
801058e2:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801058e9:	80 
801058ea:	c1 ea 10             	shr    $0x10,%edx
801058ed:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801058f4:	80 
  for(i = 0; i < 256; i++)
801058f5:	83 c0 01             	add    $0x1,%eax
801058f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801058fd:	75 d1                	jne    801058d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801058ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105902:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105907:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
8010590e:	00 00 ef 
  initlock(&tickslock, "time");
80105911:	68 b9 78 10 80       	push   $0x801078b9
80105916:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010591b:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105921:	c1 e8 10             	shr    $0x10,%eax
80105924:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010592a:	e8 d1 ea ff ff       	call   80104400 <initlock>
}
8010592f:	83 c4 10             	add    $0x10,%esp
80105932:	c9                   	leave  
80105933:	c3                   	ret    
80105934:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop

80105940 <idtinit>:

void
idtinit(void)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
  pd[0] = size-1;
80105945:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010594a:	89 e5                	mov    %esp,%ebp
8010594c:	83 ec 10             	sub    $0x10,%esp
8010594f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105953:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105958:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010595c:	c1 e8 10             	shr    $0x10,%eax
8010595f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105963:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105966:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105969:	c9                   	leave  
8010596a:	c3                   	ret    
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop

80105970 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	57                   	push   %edi
80105978:	56                   	push   %esi
80105979:	53                   	push   %ebx
8010597a:	83 ec 1c             	sub    $0x1c,%esp
8010597d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105980:	8b 43 30             	mov    0x30(%ebx),%eax
80105983:	83 f8 40             	cmp    $0x40,%eax
80105986:	0f 84 fc 01 00 00    	je     80105b88 <trap+0x218>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010598c:	83 e8 0e             	sub    $0xe,%eax
8010598f:	83 f8 31             	cmp    $0x31,%eax
80105992:	77 42                	ja     801059d6 <trap+0x66>
80105994:	3e ff 24 85 80 79 10 	notrack jmp *-0x7fef8680(,%eax,4)
8010599b:	80 
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  
  case T_PGFLT:
    myproc()->sz = myproc()->sz + 4096;
8010599c:	e8 cf df ff ff       	call   80103970 <myproc>
801059a1:	8b 70 04             	mov    0x4(%eax),%esi
801059a4:	e8 c7 df ff ff       	call   80103970 <myproc>
801059a9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801059af:	89 70 04             	mov    %esi,0x4(%eax)
    myproc()->stack_pages++;
801059b2:	e8 b9 df ff ff       	call   80103970 <myproc>
801059b7:	83 00 01             	addl   $0x1,(%eax)
    cprintf("\nnumber of stack pages is %d\n", myproc()->stack_pages);
801059ba:	e8 b1 df ff ff       	call   80103970 <myproc>
801059bf:	83 ec 08             	sub    $0x8,%esp
801059c2:	ff 30                	pushl  (%eax)
801059c4:	68 be 78 10 80       	push   $0x801078be
801059c9:	e8 e2 ac ff ff       	call   801006b0 <cprintf>
    sched();
801059ce:	e8 1d e3 ff ff       	call   80103cf0 <sched>
801059d3:	83 c4 10             	add    $0x10,%esp
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059d6:	e8 95 df ff ff       	call   80103970 <myproc>
801059db:	8b 7b 38             	mov    0x38(%ebx),%edi
801059de:	85 c0                	test   %eax,%eax
801059e0:	0f 84 f1 01 00 00    	je     80105bd7 <trap+0x267>
801059e6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801059ea:	0f 84 e7 01 00 00    	je     80105bd7 <trap+0x267>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059f0:	0f 20 d1             	mov    %cr2,%ecx
801059f3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059f6:	e8 55 df ff ff       	call   80103950 <cpuid>
801059fb:	8b 73 30             	mov    0x30(%ebx),%esi
801059fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a01:	8b 43 34             	mov    0x34(%ebx),%eax
80105a04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a07:	e8 64 df ff ff       	call   80103970 <myproc>
80105a0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a0f:	e8 5c df ff ff       	call   80103970 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a14:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a17:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a1a:	51                   	push   %ecx
80105a1b:	57                   	push   %edi
80105a1c:	52                   	push   %edx
80105a1d:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a20:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a21:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a24:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a27:	56                   	push   %esi
80105a28:	ff 70 14             	pushl  0x14(%eax)
80105a2b:	68 3c 79 10 80       	push   $0x8010793c
80105a30:	e8 7b ac ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a35:	83 c4 20             	add    $0x20,%esp
80105a38:	e8 33 df ff ff       	call   80103970 <myproc>
80105a3d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a44:	e8 27 df ff ff       	call   80103970 <myproc>
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	74 1d                	je     80105a6a <trap+0xfa>
80105a4d:	e8 1e df ff ff       	call   80103970 <myproc>
80105a52:	8b 50 28             	mov    0x28(%eax),%edx
80105a55:	85 d2                	test   %edx,%edx
80105a57:	74 11                	je     80105a6a <trap+0xfa>
80105a59:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a5d:	83 e0 03             	and    $0x3,%eax
80105a60:	66 83 f8 03          	cmp    $0x3,%ax
80105a64:	0f 84 56 01 00 00    	je     80105bc0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a6a:	e8 01 df ff ff       	call   80103970 <myproc>
80105a6f:	85 c0                	test   %eax,%eax
80105a71:	74 0f                	je     80105a82 <trap+0x112>
80105a73:	e8 f8 de ff ff       	call   80103970 <myproc>
80105a78:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105a7c:	0f 84 ee 00 00 00    	je     80105b70 <trap+0x200>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a82:	e8 e9 de ff ff       	call   80103970 <myproc>
80105a87:	85 c0                	test   %eax,%eax
80105a89:	74 1d                	je     80105aa8 <trap+0x138>
80105a8b:	e8 e0 de ff ff       	call   80103970 <myproc>
80105a90:	8b 40 28             	mov    0x28(%eax),%eax
80105a93:	85 c0                	test   %eax,%eax
80105a95:	74 11                	je     80105aa8 <trap+0x138>
80105a97:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a9b:	83 e0 03             	and    $0x3,%eax
80105a9e:	66 83 f8 03          	cmp    $0x3,%ax
80105aa2:	0f 84 09 01 00 00    	je     80105bb1 <trap+0x241>
    exit();
}
80105aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aab:	5b                   	pop    %ebx
80105aac:	5e                   	pop    %esi
80105aad:	5f                   	pop    %edi
80105aae:	5d                   	pop    %ebp
80105aaf:	c3                   	ret    
    ideintr();
80105ab0:	e8 3b c7 ff ff       	call   801021f0 <ideintr>
    lapiceoi();
80105ab5:	e8 16 ce ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aba:	e8 b1 de ff ff       	call   80103970 <myproc>
80105abf:	85 c0                	test   %eax,%eax
80105ac1:	75 8a                	jne    80105a4d <trap+0xdd>
80105ac3:	eb a5                	jmp    80105a6a <trap+0xfa>
    if(cpuid() == 0){
80105ac5:	e8 86 de ff ff       	call   80103950 <cpuid>
80105aca:	85 c0                	test   %eax,%eax
80105acc:	75 e7                	jne    80105ab5 <trap+0x145>
      acquire(&tickslock);
80105ace:	83 ec 0c             	sub    $0xc,%esp
80105ad1:	68 60 4d 11 80       	push   $0x80114d60
80105ad6:	e8 a5 ea ff ff       	call   80104580 <acquire>
      wakeup(&ticks);
80105adb:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105ae2:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105ae9:	e8 12 e6 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80105aee:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105af5:	e8 46 eb ff ff       	call   80104640 <release>
80105afa:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105afd:	eb b6                	jmp    80105ab5 <trap+0x145>
    kbdintr();
80105aff:	e8 8c cc ff ff       	call   80102790 <kbdintr>
    lapiceoi();
80105b04:	e8 c7 cd ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b09:	e8 62 de ff ff       	call   80103970 <myproc>
80105b0e:	85 c0                	test   %eax,%eax
80105b10:	0f 85 37 ff ff ff    	jne    80105a4d <trap+0xdd>
80105b16:	e9 4f ff ff ff       	jmp    80105a6a <trap+0xfa>
    uartintr();
80105b1b:	e8 50 02 00 00       	call   80105d70 <uartintr>
    lapiceoi();
80105b20:	e8 ab cd ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b25:	e8 46 de ff ff       	call   80103970 <myproc>
80105b2a:	85 c0                	test   %eax,%eax
80105b2c:	0f 85 1b ff ff ff    	jne    80105a4d <trap+0xdd>
80105b32:	e9 33 ff ff ff       	jmp    80105a6a <trap+0xfa>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b37:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b3a:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b3e:	e8 0d de ff ff       	call   80103950 <cpuid>
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	50                   	push   %eax
80105b46:	68 e4 78 10 80       	push   $0x801078e4
80105b4b:	e8 60 ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105b50:	e8 7b cd ff ff       	call   801028d0 <lapiceoi>
    break;
80105b55:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b58:	e8 13 de ff ff       	call   80103970 <myproc>
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	0f 85 e8 fe ff ff    	jne    80105a4d <trap+0xdd>
80105b65:	e9 00 ff ff ff       	jmp    80105a6a <trap+0xfa>
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105b70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b74:	0f 85 08 ff ff ff    	jne    80105a82 <trap+0x112>
    yield();
80105b7a:	e8 71 e3 ff ff       	call   80103ef0 <yield>
80105b7f:	e9 fe fe ff ff       	jmp    80105a82 <trap+0x112>
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b88:	e8 e3 dd ff ff       	call   80103970 <myproc>
80105b8d:	8b 70 28             	mov    0x28(%eax),%esi
80105b90:	85 f6                	test   %esi,%esi
80105b92:	75 3c                	jne    80105bd0 <trap+0x260>
    myproc()->tf = tf;
80105b94:	e8 d7 dd ff ff       	call   80103970 <myproc>
80105b99:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105b9c:	e8 bf ee ff ff       	call   80104a60 <syscall>
    if(myproc()->killed)
80105ba1:	e8 ca dd ff ff       	call   80103970 <myproc>
80105ba6:	8b 48 28             	mov    0x28(%eax),%ecx
80105ba9:	85 c9                	test   %ecx,%ecx
80105bab:	0f 84 f7 fe ff ff    	je     80105aa8 <trap+0x138>
}
80105bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb4:	5b                   	pop    %ebx
80105bb5:	5e                   	pop    %esi
80105bb6:	5f                   	pop    %edi
80105bb7:	5d                   	pop    %ebp
      exit();
80105bb8:	e9 f3 e1 ff ff       	jmp    80103db0 <exit>
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105bc0:	e8 eb e1 ff ff       	call   80103db0 <exit>
80105bc5:	e9 a0 fe ff ff       	jmp    80105a6a <trap+0xfa>
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105bd0:	e8 db e1 ff ff       	call   80103db0 <exit>
80105bd5:	eb bd                	jmp    80105b94 <trap+0x224>
80105bd7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bda:	e8 71 dd ff ff       	call   80103950 <cpuid>
80105bdf:	83 ec 0c             	sub    $0xc,%esp
80105be2:	56                   	push   %esi
80105be3:	57                   	push   %edi
80105be4:	50                   	push   %eax
80105be5:	ff 73 30             	pushl  0x30(%ebx)
80105be8:	68 08 79 10 80       	push   $0x80107908
80105bed:	e8 be aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105bf2:	83 c4 14             	add    $0x14,%esp
80105bf5:	68 dc 78 10 80       	push   $0x801078dc
80105bfa:	e8 91 a7 ff ff       	call   80100390 <panic>
80105bff:	90                   	nop

80105c00 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c00:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105c04:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	74 1b                	je     80105c28 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c0d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c12:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c13:	a8 01                	test   $0x1,%al
80105c15:	74 11                	je     80105c28 <uartgetc+0x28>
80105c17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c1d:	0f b6 c0             	movzbl %al,%eax
80105c20:	c3                   	ret    
80105c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c2d:	c3                   	ret    
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <uartputc.part.0>:
uartputc(int c)
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	89 c7                	mov    %eax,%edi
80105c36:	56                   	push   %esi
80105c37:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c3c:	53                   	push   %ebx
80105c3d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	eb 1b                	jmp    80105c62 <uartputc.part.0+0x32>
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	6a 0a                	push   $0xa
80105c55:	e8 96 cc ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	83 eb 01             	sub    $0x1,%ebx
80105c60:	74 07                	je     80105c69 <uartputc.part.0+0x39>
80105c62:	89 f2                	mov    %esi,%edx
80105c64:	ec                   	in     (%dx),%al
80105c65:	a8 20                	test   $0x20,%al
80105c67:	74 e7                	je     80105c50 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c6e:	89 f8                	mov    %edi,%eax
80105c70:	ee                   	out    %al,(%dx)
}
80105c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c74:	5b                   	pop    %ebx
80105c75:	5e                   	pop    %esi
80105c76:	5f                   	pop    %edi
80105c77:	5d                   	pop    %ebp
80105c78:	c3                   	ret    
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <uartinit>:
{
80105c80:	f3 0f 1e fb          	endbr32 
80105c84:	55                   	push   %ebp
80105c85:	31 c9                	xor    %ecx,%ecx
80105c87:	89 c8                	mov    %ecx,%eax
80105c89:	89 e5                	mov    %esp,%ebp
80105c8b:	57                   	push   %edi
80105c8c:	56                   	push   %esi
80105c8d:	53                   	push   %ebx
80105c8e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105c93:	89 da                	mov    %ebx,%edx
80105c95:	83 ec 0c             	sub    $0xc,%esp
80105c98:	ee                   	out    %al,(%dx)
80105c99:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105c9e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ca3:	89 fa                	mov    %edi,%edx
80105ca5:	ee                   	out    %al,(%dx)
80105ca6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cab:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cb0:	ee                   	out    %al,(%dx)
80105cb1:	be f9 03 00 00       	mov    $0x3f9,%esi
80105cb6:	89 c8                	mov    %ecx,%eax
80105cb8:	89 f2                	mov    %esi,%edx
80105cba:	ee                   	out    %al,(%dx)
80105cbb:	b8 03 00 00 00       	mov    $0x3,%eax
80105cc0:	89 fa                	mov    %edi,%edx
80105cc2:	ee                   	out    %al,(%dx)
80105cc3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cc8:	89 c8                	mov    %ecx,%eax
80105cca:	ee                   	out    %al,(%dx)
80105ccb:	b8 01 00 00 00       	mov    $0x1,%eax
80105cd0:	89 f2                	mov    %esi,%edx
80105cd2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cd3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cd8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105cd9:	3c ff                	cmp    $0xff,%al
80105cdb:	74 52                	je     80105d2f <uartinit+0xaf>
  uart = 1;
80105cdd:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ce4:	00 00 00 
80105ce7:	89 da                	mov    %ebx,%edx
80105ce9:	ec                   	in     (%dx),%al
80105cea:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105cf0:	83 ec 08             	sub    $0x8,%esp
80105cf3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105cf8:	bb 48 7a 10 80       	mov    $0x80107a48,%ebx
  ioapicenable(IRQ_COM1, 0);
80105cfd:	6a 00                	push   $0x0
80105cff:	6a 04                	push   $0x4
80105d01:	e8 3a c7 ff ff       	call   80102440 <ioapicenable>
80105d06:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d09:	b8 78 00 00 00       	mov    $0x78,%eax
80105d0e:	eb 04                	jmp    80105d14 <uartinit+0x94>
80105d10:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105d14:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d1a:	85 d2                	test   %edx,%edx
80105d1c:	74 08                	je     80105d26 <uartinit+0xa6>
    uartputc(*p);
80105d1e:	0f be c0             	movsbl %al,%eax
80105d21:	e8 0a ff ff ff       	call   80105c30 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105d26:	89 f0                	mov    %esi,%eax
80105d28:	83 c3 01             	add    $0x1,%ebx
80105d2b:	84 c0                	test   %al,%al
80105d2d:	75 e1                	jne    80105d10 <uartinit+0x90>
}
80105d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d32:	5b                   	pop    %ebx
80105d33:	5e                   	pop    %esi
80105d34:	5f                   	pop    %edi
80105d35:	5d                   	pop    %ebp
80105d36:	c3                   	ret    
80105d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <uartputc>:
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
  if(!uart)
80105d45:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105d4b:	89 e5                	mov    %esp,%ebp
80105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105d50:	85 d2                	test   %edx,%edx
80105d52:	74 0c                	je     80105d60 <uartputc+0x20>
}
80105d54:	5d                   	pop    %ebp
80105d55:	e9 d6 fe ff ff       	jmp    80105c30 <uartputc.part.0>
80105d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d60:	5d                   	pop    %ebp
80105d61:	c3                   	ret    
80105d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <uartintr>:

void
uartintr(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d7a:	68 00 5c 10 80       	push   $0x80105c00
80105d7f:	e8 dc aa ff ff       	call   80100860 <consoleintr>
}
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	c9                   	leave  
80105d88:	c3                   	ret    

80105d89 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $0
80105d8b:	6a 00                	push   $0x0
  jmp alltraps
80105d8d:	e9 fc fa ff ff       	jmp    8010588e <alltraps>

80105d92 <vector1>:
.globl vector1
vector1:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $1
80105d94:	6a 01                	push   $0x1
  jmp alltraps
80105d96:	e9 f3 fa ff ff       	jmp    8010588e <alltraps>

80105d9b <vector2>:
.globl vector2
vector2:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $2
80105d9d:	6a 02                	push   $0x2
  jmp alltraps
80105d9f:	e9 ea fa ff ff       	jmp    8010588e <alltraps>

80105da4 <vector3>:
.globl vector3
vector3:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $3
80105da6:	6a 03                	push   $0x3
  jmp alltraps
80105da8:	e9 e1 fa ff ff       	jmp    8010588e <alltraps>

80105dad <vector4>:
.globl vector4
vector4:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $4
80105daf:	6a 04                	push   $0x4
  jmp alltraps
80105db1:	e9 d8 fa ff ff       	jmp    8010588e <alltraps>

80105db6 <vector5>:
.globl vector5
vector5:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $5
80105db8:	6a 05                	push   $0x5
  jmp alltraps
80105dba:	e9 cf fa ff ff       	jmp    8010588e <alltraps>

80105dbf <vector6>:
.globl vector6
vector6:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $6
80105dc1:	6a 06                	push   $0x6
  jmp alltraps
80105dc3:	e9 c6 fa ff ff       	jmp    8010588e <alltraps>

80105dc8 <vector7>:
.globl vector7
vector7:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $7
80105dca:	6a 07                	push   $0x7
  jmp alltraps
80105dcc:	e9 bd fa ff ff       	jmp    8010588e <alltraps>

80105dd1 <vector8>:
.globl vector8
vector8:
  pushl $8
80105dd1:	6a 08                	push   $0x8
  jmp alltraps
80105dd3:	e9 b6 fa ff ff       	jmp    8010588e <alltraps>

80105dd8 <vector9>:
.globl vector9
vector9:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $9
80105dda:	6a 09                	push   $0x9
  jmp alltraps
80105ddc:	e9 ad fa ff ff       	jmp    8010588e <alltraps>

80105de1 <vector10>:
.globl vector10
vector10:
  pushl $10
80105de1:	6a 0a                	push   $0xa
  jmp alltraps
80105de3:	e9 a6 fa ff ff       	jmp    8010588e <alltraps>

80105de8 <vector11>:
.globl vector11
vector11:
  pushl $11
80105de8:	6a 0b                	push   $0xb
  jmp alltraps
80105dea:	e9 9f fa ff ff       	jmp    8010588e <alltraps>

80105def <vector12>:
.globl vector12
vector12:
  pushl $12
80105def:	6a 0c                	push   $0xc
  jmp alltraps
80105df1:	e9 98 fa ff ff       	jmp    8010588e <alltraps>

80105df6 <vector13>:
.globl vector13
vector13:
  pushl $13
80105df6:	6a 0d                	push   $0xd
  jmp alltraps
80105df8:	e9 91 fa ff ff       	jmp    8010588e <alltraps>

80105dfd <vector14>:
.globl vector14
vector14:
  pushl $14
80105dfd:	6a 0e                	push   $0xe
  jmp alltraps
80105dff:	e9 8a fa ff ff       	jmp    8010588e <alltraps>

80105e04 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $15
80105e06:	6a 0f                	push   $0xf
  jmp alltraps
80105e08:	e9 81 fa ff ff       	jmp    8010588e <alltraps>

80105e0d <vector16>:
.globl vector16
vector16:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $16
80105e0f:	6a 10                	push   $0x10
  jmp alltraps
80105e11:	e9 78 fa ff ff       	jmp    8010588e <alltraps>

80105e16 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e16:	6a 11                	push   $0x11
  jmp alltraps
80105e18:	e9 71 fa ff ff       	jmp    8010588e <alltraps>

80105e1d <vector18>:
.globl vector18
vector18:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $18
80105e1f:	6a 12                	push   $0x12
  jmp alltraps
80105e21:	e9 68 fa ff ff       	jmp    8010588e <alltraps>

80105e26 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $19
80105e28:	6a 13                	push   $0x13
  jmp alltraps
80105e2a:	e9 5f fa ff ff       	jmp    8010588e <alltraps>

80105e2f <vector20>:
.globl vector20
vector20:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $20
80105e31:	6a 14                	push   $0x14
  jmp alltraps
80105e33:	e9 56 fa ff ff       	jmp    8010588e <alltraps>

80105e38 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $21
80105e3a:	6a 15                	push   $0x15
  jmp alltraps
80105e3c:	e9 4d fa ff ff       	jmp    8010588e <alltraps>

80105e41 <vector22>:
.globl vector22
vector22:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $22
80105e43:	6a 16                	push   $0x16
  jmp alltraps
80105e45:	e9 44 fa ff ff       	jmp    8010588e <alltraps>

80105e4a <vector23>:
.globl vector23
vector23:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $23
80105e4c:	6a 17                	push   $0x17
  jmp alltraps
80105e4e:	e9 3b fa ff ff       	jmp    8010588e <alltraps>

80105e53 <vector24>:
.globl vector24
vector24:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $24
80105e55:	6a 18                	push   $0x18
  jmp alltraps
80105e57:	e9 32 fa ff ff       	jmp    8010588e <alltraps>

80105e5c <vector25>:
.globl vector25
vector25:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $25
80105e5e:	6a 19                	push   $0x19
  jmp alltraps
80105e60:	e9 29 fa ff ff       	jmp    8010588e <alltraps>

80105e65 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $26
80105e67:	6a 1a                	push   $0x1a
  jmp alltraps
80105e69:	e9 20 fa ff ff       	jmp    8010588e <alltraps>

80105e6e <vector27>:
.globl vector27
vector27:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $27
80105e70:	6a 1b                	push   $0x1b
  jmp alltraps
80105e72:	e9 17 fa ff ff       	jmp    8010588e <alltraps>

80105e77 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $28
80105e79:	6a 1c                	push   $0x1c
  jmp alltraps
80105e7b:	e9 0e fa ff ff       	jmp    8010588e <alltraps>

80105e80 <vector29>:
.globl vector29
vector29:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $29
80105e82:	6a 1d                	push   $0x1d
  jmp alltraps
80105e84:	e9 05 fa ff ff       	jmp    8010588e <alltraps>

80105e89 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $30
80105e8b:	6a 1e                	push   $0x1e
  jmp alltraps
80105e8d:	e9 fc f9 ff ff       	jmp    8010588e <alltraps>

80105e92 <vector31>:
.globl vector31
vector31:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $31
80105e94:	6a 1f                	push   $0x1f
  jmp alltraps
80105e96:	e9 f3 f9 ff ff       	jmp    8010588e <alltraps>

80105e9b <vector32>:
.globl vector32
vector32:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $32
80105e9d:	6a 20                	push   $0x20
  jmp alltraps
80105e9f:	e9 ea f9 ff ff       	jmp    8010588e <alltraps>

80105ea4 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $33
80105ea6:	6a 21                	push   $0x21
  jmp alltraps
80105ea8:	e9 e1 f9 ff ff       	jmp    8010588e <alltraps>

80105ead <vector34>:
.globl vector34
vector34:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $34
80105eaf:	6a 22                	push   $0x22
  jmp alltraps
80105eb1:	e9 d8 f9 ff ff       	jmp    8010588e <alltraps>

80105eb6 <vector35>:
.globl vector35
vector35:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $35
80105eb8:	6a 23                	push   $0x23
  jmp alltraps
80105eba:	e9 cf f9 ff ff       	jmp    8010588e <alltraps>

80105ebf <vector36>:
.globl vector36
vector36:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $36
80105ec1:	6a 24                	push   $0x24
  jmp alltraps
80105ec3:	e9 c6 f9 ff ff       	jmp    8010588e <alltraps>

80105ec8 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $37
80105eca:	6a 25                	push   $0x25
  jmp alltraps
80105ecc:	e9 bd f9 ff ff       	jmp    8010588e <alltraps>

80105ed1 <vector38>:
.globl vector38
vector38:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $38
80105ed3:	6a 26                	push   $0x26
  jmp alltraps
80105ed5:	e9 b4 f9 ff ff       	jmp    8010588e <alltraps>

80105eda <vector39>:
.globl vector39
vector39:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $39
80105edc:	6a 27                	push   $0x27
  jmp alltraps
80105ede:	e9 ab f9 ff ff       	jmp    8010588e <alltraps>

80105ee3 <vector40>:
.globl vector40
vector40:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $40
80105ee5:	6a 28                	push   $0x28
  jmp alltraps
80105ee7:	e9 a2 f9 ff ff       	jmp    8010588e <alltraps>

80105eec <vector41>:
.globl vector41
vector41:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $41
80105eee:	6a 29                	push   $0x29
  jmp alltraps
80105ef0:	e9 99 f9 ff ff       	jmp    8010588e <alltraps>

80105ef5 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $42
80105ef7:	6a 2a                	push   $0x2a
  jmp alltraps
80105ef9:	e9 90 f9 ff ff       	jmp    8010588e <alltraps>

80105efe <vector43>:
.globl vector43
vector43:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $43
80105f00:	6a 2b                	push   $0x2b
  jmp alltraps
80105f02:	e9 87 f9 ff ff       	jmp    8010588e <alltraps>

80105f07 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $44
80105f09:	6a 2c                	push   $0x2c
  jmp alltraps
80105f0b:	e9 7e f9 ff ff       	jmp    8010588e <alltraps>

80105f10 <vector45>:
.globl vector45
vector45:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $45
80105f12:	6a 2d                	push   $0x2d
  jmp alltraps
80105f14:	e9 75 f9 ff ff       	jmp    8010588e <alltraps>

80105f19 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $46
80105f1b:	6a 2e                	push   $0x2e
  jmp alltraps
80105f1d:	e9 6c f9 ff ff       	jmp    8010588e <alltraps>

80105f22 <vector47>:
.globl vector47
vector47:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $47
80105f24:	6a 2f                	push   $0x2f
  jmp alltraps
80105f26:	e9 63 f9 ff ff       	jmp    8010588e <alltraps>

80105f2b <vector48>:
.globl vector48
vector48:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $48
80105f2d:	6a 30                	push   $0x30
  jmp alltraps
80105f2f:	e9 5a f9 ff ff       	jmp    8010588e <alltraps>

80105f34 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $49
80105f36:	6a 31                	push   $0x31
  jmp alltraps
80105f38:	e9 51 f9 ff ff       	jmp    8010588e <alltraps>

80105f3d <vector50>:
.globl vector50
vector50:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $50
80105f3f:	6a 32                	push   $0x32
  jmp alltraps
80105f41:	e9 48 f9 ff ff       	jmp    8010588e <alltraps>

80105f46 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $51
80105f48:	6a 33                	push   $0x33
  jmp alltraps
80105f4a:	e9 3f f9 ff ff       	jmp    8010588e <alltraps>

80105f4f <vector52>:
.globl vector52
vector52:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $52
80105f51:	6a 34                	push   $0x34
  jmp alltraps
80105f53:	e9 36 f9 ff ff       	jmp    8010588e <alltraps>

80105f58 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $53
80105f5a:	6a 35                	push   $0x35
  jmp alltraps
80105f5c:	e9 2d f9 ff ff       	jmp    8010588e <alltraps>

80105f61 <vector54>:
.globl vector54
vector54:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $54
80105f63:	6a 36                	push   $0x36
  jmp alltraps
80105f65:	e9 24 f9 ff ff       	jmp    8010588e <alltraps>

80105f6a <vector55>:
.globl vector55
vector55:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $55
80105f6c:	6a 37                	push   $0x37
  jmp alltraps
80105f6e:	e9 1b f9 ff ff       	jmp    8010588e <alltraps>

80105f73 <vector56>:
.globl vector56
vector56:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $56
80105f75:	6a 38                	push   $0x38
  jmp alltraps
80105f77:	e9 12 f9 ff ff       	jmp    8010588e <alltraps>

80105f7c <vector57>:
.globl vector57
vector57:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $57
80105f7e:	6a 39                	push   $0x39
  jmp alltraps
80105f80:	e9 09 f9 ff ff       	jmp    8010588e <alltraps>

80105f85 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $58
80105f87:	6a 3a                	push   $0x3a
  jmp alltraps
80105f89:	e9 00 f9 ff ff       	jmp    8010588e <alltraps>

80105f8e <vector59>:
.globl vector59
vector59:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $59
80105f90:	6a 3b                	push   $0x3b
  jmp alltraps
80105f92:	e9 f7 f8 ff ff       	jmp    8010588e <alltraps>

80105f97 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $60
80105f99:	6a 3c                	push   $0x3c
  jmp alltraps
80105f9b:	e9 ee f8 ff ff       	jmp    8010588e <alltraps>

80105fa0 <vector61>:
.globl vector61
vector61:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $61
80105fa2:	6a 3d                	push   $0x3d
  jmp alltraps
80105fa4:	e9 e5 f8 ff ff       	jmp    8010588e <alltraps>

80105fa9 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $62
80105fab:	6a 3e                	push   $0x3e
  jmp alltraps
80105fad:	e9 dc f8 ff ff       	jmp    8010588e <alltraps>

80105fb2 <vector63>:
.globl vector63
vector63:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $63
80105fb4:	6a 3f                	push   $0x3f
  jmp alltraps
80105fb6:	e9 d3 f8 ff ff       	jmp    8010588e <alltraps>

80105fbb <vector64>:
.globl vector64
vector64:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $64
80105fbd:	6a 40                	push   $0x40
  jmp alltraps
80105fbf:	e9 ca f8 ff ff       	jmp    8010588e <alltraps>

80105fc4 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $65
80105fc6:	6a 41                	push   $0x41
  jmp alltraps
80105fc8:	e9 c1 f8 ff ff       	jmp    8010588e <alltraps>

80105fcd <vector66>:
.globl vector66
vector66:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $66
80105fcf:	6a 42                	push   $0x42
  jmp alltraps
80105fd1:	e9 b8 f8 ff ff       	jmp    8010588e <alltraps>

80105fd6 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $67
80105fd8:	6a 43                	push   $0x43
  jmp alltraps
80105fda:	e9 af f8 ff ff       	jmp    8010588e <alltraps>

80105fdf <vector68>:
.globl vector68
vector68:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $68
80105fe1:	6a 44                	push   $0x44
  jmp alltraps
80105fe3:	e9 a6 f8 ff ff       	jmp    8010588e <alltraps>

80105fe8 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $69
80105fea:	6a 45                	push   $0x45
  jmp alltraps
80105fec:	e9 9d f8 ff ff       	jmp    8010588e <alltraps>

80105ff1 <vector70>:
.globl vector70
vector70:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $70
80105ff3:	6a 46                	push   $0x46
  jmp alltraps
80105ff5:	e9 94 f8 ff ff       	jmp    8010588e <alltraps>

80105ffa <vector71>:
.globl vector71
vector71:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $71
80105ffc:	6a 47                	push   $0x47
  jmp alltraps
80105ffe:	e9 8b f8 ff ff       	jmp    8010588e <alltraps>

80106003 <vector72>:
.globl vector72
vector72:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $72
80106005:	6a 48                	push   $0x48
  jmp alltraps
80106007:	e9 82 f8 ff ff       	jmp    8010588e <alltraps>

8010600c <vector73>:
.globl vector73
vector73:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $73
8010600e:	6a 49                	push   $0x49
  jmp alltraps
80106010:	e9 79 f8 ff ff       	jmp    8010588e <alltraps>

80106015 <vector74>:
.globl vector74
vector74:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $74
80106017:	6a 4a                	push   $0x4a
  jmp alltraps
80106019:	e9 70 f8 ff ff       	jmp    8010588e <alltraps>

8010601e <vector75>:
.globl vector75
vector75:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $75
80106020:	6a 4b                	push   $0x4b
  jmp alltraps
80106022:	e9 67 f8 ff ff       	jmp    8010588e <alltraps>

80106027 <vector76>:
.globl vector76
vector76:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $76
80106029:	6a 4c                	push   $0x4c
  jmp alltraps
8010602b:	e9 5e f8 ff ff       	jmp    8010588e <alltraps>

80106030 <vector77>:
.globl vector77
vector77:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $77
80106032:	6a 4d                	push   $0x4d
  jmp alltraps
80106034:	e9 55 f8 ff ff       	jmp    8010588e <alltraps>

80106039 <vector78>:
.globl vector78
vector78:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $78
8010603b:	6a 4e                	push   $0x4e
  jmp alltraps
8010603d:	e9 4c f8 ff ff       	jmp    8010588e <alltraps>

80106042 <vector79>:
.globl vector79
vector79:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $79
80106044:	6a 4f                	push   $0x4f
  jmp alltraps
80106046:	e9 43 f8 ff ff       	jmp    8010588e <alltraps>

8010604b <vector80>:
.globl vector80
vector80:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $80
8010604d:	6a 50                	push   $0x50
  jmp alltraps
8010604f:	e9 3a f8 ff ff       	jmp    8010588e <alltraps>

80106054 <vector81>:
.globl vector81
vector81:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $81
80106056:	6a 51                	push   $0x51
  jmp alltraps
80106058:	e9 31 f8 ff ff       	jmp    8010588e <alltraps>

8010605d <vector82>:
.globl vector82
vector82:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $82
8010605f:	6a 52                	push   $0x52
  jmp alltraps
80106061:	e9 28 f8 ff ff       	jmp    8010588e <alltraps>

80106066 <vector83>:
.globl vector83
vector83:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $83
80106068:	6a 53                	push   $0x53
  jmp alltraps
8010606a:	e9 1f f8 ff ff       	jmp    8010588e <alltraps>

8010606f <vector84>:
.globl vector84
vector84:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $84
80106071:	6a 54                	push   $0x54
  jmp alltraps
80106073:	e9 16 f8 ff ff       	jmp    8010588e <alltraps>

80106078 <vector85>:
.globl vector85
vector85:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $85
8010607a:	6a 55                	push   $0x55
  jmp alltraps
8010607c:	e9 0d f8 ff ff       	jmp    8010588e <alltraps>

80106081 <vector86>:
.globl vector86
vector86:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $86
80106083:	6a 56                	push   $0x56
  jmp alltraps
80106085:	e9 04 f8 ff ff       	jmp    8010588e <alltraps>

8010608a <vector87>:
.globl vector87
vector87:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $87
8010608c:	6a 57                	push   $0x57
  jmp alltraps
8010608e:	e9 fb f7 ff ff       	jmp    8010588e <alltraps>

80106093 <vector88>:
.globl vector88
vector88:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $88
80106095:	6a 58                	push   $0x58
  jmp alltraps
80106097:	e9 f2 f7 ff ff       	jmp    8010588e <alltraps>

8010609c <vector89>:
.globl vector89
vector89:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $89
8010609e:	6a 59                	push   $0x59
  jmp alltraps
801060a0:	e9 e9 f7 ff ff       	jmp    8010588e <alltraps>

801060a5 <vector90>:
.globl vector90
vector90:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $90
801060a7:	6a 5a                	push   $0x5a
  jmp alltraps
801060a9:	e9 e0 f7 ff ff       	jmp    8010588e <alltraps>

801060ae <vector91>:
.globl vector91
vector91:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $91
801060b0:	6a 5b                	push   $0x5b
  jmp alltraps
801060b2:	e9 d7 f7 ff ff       	jmp    8010588e <alltraps>

801060b7 <vector92>:
.globl vector92
vector92:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $92
801060b9:	6a 5c                	push   $0x5c
  jmp alltraps
801060bb:	e9 ce f7 ff ff       	jmp    8010588e <alltraps>

801060c0 <vector93>:
.globl vector93
vector93:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $93
801060c2:	6a 5d                	push   $0x5d
  jmp alltraps
801060c4:	e9 c5 f7 ff ff       	jmp    8010588e <alltraps>

801060c9 <vector94>:
.globl vector94
vector94:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $94
801060cb:	6a 5e                	push   $0x5e
  jmp alltraps
801060cd:	e9 bc f7 ff ff       	jmp    8010588e <alltraps>

801060d2 <vector95>:
.globl vector95
vector95:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $95
801060d4:	6a 5f                	push   $0x5f
  jmp alltraps
801060d6:	e9 b3 f7 ff ff       	jmp    8010588e <alltraps>

801060db <vector96>:
.globl vector96
vector96:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $96
801060dd:	6a 60                	push   $0x60
  jmp alltraps
801060df:	e9 aa f7 ff ff       	jmp    8010588e <alltraps>

801060e4 <vector97>:
.globl vector97
vector97:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $97
801060e6:	6a 61                	push   $0x61
  jmp alltraps
801060e8:	e9 a1 f7 ff ff       	jmp    8010588e <alltraps>

801060ed <vector98>:
.globl vector98
vector98:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $98
801060ef:	6a 62                	push   $0x62
  jmp alltraps
801060f1:	e9 98 f7 ff ff       	jmp    8010588e <alltraps>

801060f6 <vector99>:
.globl vector99
vector99:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $99
801060f8:	6a 63                	push   $0x63
  jmp alltraps
801060fa:	e9 8f f7 ff ff       	jmp    8010588e <alltraps>

801060ff <vector100>:
.globl vector100
vector100:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $100
80106101:	6a 64                	push   $0x64
  jmp alltraps
80106103:	e9 86 f7 ff ff       	jmp    8010588e <alltraps>

80106108 <vector101>:
.globl vector101
vector101:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $101
8010610a:	6a 65                	push   $0x65
  jmp alltraps
8010610c:	e9 7d f7 ff ff       	jmp    8010588e <alltraps>

80106111 <vector102>:
.globl vector102
vector102:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $102
80106113:	6a 66                	push   $0x66
  jmp alltraps
80106115:	e9 74 f7 ff ff       	jmp    8010588e <alltraps>

8010611a <vector103>:
.globl vector103
vector103:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $103
8010611c:	6a 67                	push   $0x67
  jmp alltraps
8010611e:	e9 6b f7 ff ff       	jmp    8010588e <alltraps>

80106123 <vector104>:
.globl vector104
vector104:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $104
80106125:	6a 68                	push   $0x68
  jmp alltraps
80106127:	e9 62 f7 ff ff       	jmp    8010588e <alltraps>

8010612c <vector105>:
.globl vector105
vector105:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $105
8010612e:	6a 69                	push   $0x69
  jmp alltraps
80106130:	e9 59 f7 ff ff       	jmp    8010588e <alltraps>

80106135 <vector106>:
.globl vector106
vector106:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $106
80106137:	6a 6a                	push   $0x6a
  jmp alltraps
80106139:	e9 50 f7 ff ff       	jmp    8010588e <alltraps>

8010613e <vector107>:
.globl vector107
vector107:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $107
80106140:	6a 6b                	push   $0x6b
  jmp alltraps
80106142:	e9 47 f7 ff ff       	jmp    8010588e <alltraps>

80106147 <vector108>:
.globl vector108
vector108:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $108
80106149:	6a 6c                	push   $0x6c
  jmp alltraps
8010614b:	e9 3e f7 ff ff       	jmp    8010588e <alltraps>

80106150 <vector109>:
.globl vector109
vector109:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $109
80106152:	6a 6d                	push   $0x6d
  jmp alltraps
80106154:	e9 35 f7 ff ff       	jmp    8010588e <alltraps>

80106159 <vector110>:
.globl vector110
vector110:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $110
8010615b:	6a 6e                	push   $0x6e
  jmp alltraps
8010615d:	e9 2c f7 ff ff       	jmp    8010588e <alltraps>

80106162 <vector111>:
.globl vector111
vector111:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $111
80106164:	6a 6f                	push   $0x6f
  jmp alltraps
80106166:	e9 23 f7 ff ff       	jmp    8010588e <alltraps>

8010616b <vector112>:
.globl vector112
vector112:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $112
8010616d:	6a 70                	push   $0x70
  jmp alltraps
8010616f:	e9 1a f7 ff ff       	jmp    8010588e <alltraps>

80106174 <vector113>:
.globl vector113
vector113:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $113
80106176:	6a 71                	push   $0x71
  jmp alltraps
80106178:	e9 11 f7 ff ff       	jmp    8010588e <alltraps>

8010617d <vector114>:
.globl vector114
vector114:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $114
8010617f:	6a 72                	push   $0x72
  jmp alltraps
80106181:	e9 08 f7 ff ff       	jmp    8010588e <alltraps>

80106186 <vector115>:
.globl vector115
vector115:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $115
80106188:	6a 73                	push   $0x73
  jmp alltraps
8010618a:	e9 ff f6 ff ff       	jmp    8010588e <alltraps>

8010618f <vector116>:
.globl vector116
vector116:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $116
80106191:	6a 74                	push   $0x74
  jmp alltraps
80106193:	e9 f6 f6 ff ff       	jmp    8010588e <alltraps>

80106198 <vector117>:
.globl vector117
vector117:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $117
8010619a:	6a 75                	push   $0x75
  jmp alltraps
8010619c:	e9 ed f6 ff ff       	jmp    8010588e <alltraps>

801061a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $118
801061a3:	6a 76                	push   $0x76
  jmp alltraps
801061a5:	e9 e4 f6 ff ff       	jmp    8010588e <alltraps>

801061aa <vector119>:
.globl vector119
vector119:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $119
801061ac:	6a 77                	push   $0x77
  jmp alltraps
801061ae:	e9 db f6 ff ff       	jmp    8010588e <alltraps>

801061b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $120
801061b5:	6a 78                	push   $0x78
  jmp alltraps
801061b7:	e9 d2 f6 ff ff       	jmp    8010588e <alltraps>

801061bc <vector121>:
.globl vector121
vector121:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $121
801061be:	6a 79                	push   $0x79
  jmp alltraps
801061c0:	e9 c9 f6 ff ff       	jmp    8010588e <alltraps>

801061c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $122
801061c7:	6a 7a                	push   $0x7a
  jmp alltraps
801061c9:	e9 c0 f6 ff ff       	jmp    8010588e <alltraps>

801061ce <vector123>:
.globl vector123
vector123:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $123
801061d0:	6a 7b                	push   $0x7b
  jmp alltraps
801061d2:	e9 b7 f6 ff ff       	jmp    8010588e <alltraps>

801061d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $124
801061d9:	6a 7c                	push   $0x7c
  jmp alltraps
801061db:	e9 ae f6 ff ff       	jmp    8010588e <alltraps>

801061e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $125
801061e2:	6a 7d                	push   $0x7d
  jmp alltraps
801061e4:	e9 a5 f6 ff ff       	jmp    8010588e <alltraps>

801061e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $126
801061eb:	6a 7e                	push   $0x7e
  jmp alltraps
801061ed:	e9 9c f6 ff ff       	jmp    8010588e <alltraps>

801061f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $127
801061f4:	6a 7f                	push   $0x7f
  jmp alltraps
801061f6:	e9 93 f6 ff ff       	jmp    8010588e <alltraps>

801061fb <vector128>:
.globl vector128
vector128:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $128
801061fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106202:	e9 87 f6 ff ff       	jmp    8010588e <alltraps>

80106207 <vector129>:
.globl vector129
vector129:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $129
80106209:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010620e:	e9 7b f6 ff ff       	jmp    8010588e <alltraps>

80106213 <vector130>:
.globl vector130
vector130:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $130
80106215:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010621a:	e9 6f f6 ff ff       	jmp    8010588e <alltraps>

8010621f <vector131>:
.globl vector131
vector131:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $131
80106221:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106226:	e9 63 f6 ff ff       	jmp    8010588e <alltraps>

8010622b <vector132>:
.globl vector132
vector132:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $132
8010622d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106232:	e9 57 f6 ff ff       	jmp    8010588e <alltraps>

80106237 <vector133>:
.globl vector133
vector133:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $133
80106239:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010623e:	e9 4b f6 ff ff       	jmp    8010588e <alltraps>

80106243 <vector134>:
.globl vector134
vector134:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $134
80106245:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010624a:	e9 3f f6 ff ff       	jmp    8010588e <alltraps>

8010624f <vector135>:
.globl vector135
vector135:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $135
80106251:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106256:	e9 33 f6 ff ff       	jmp    8010588e <alltraps>

8010625b <vector136>:
.globl vector136
vector136:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $136
8010625d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106262:	e9 27 f6 ff ff       	jmp    8010588e <alltraps>

80106267 <vector137>:
.globl vector137
vector137:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $137
80106269:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010626e:	e9 1b f6 ff ff       	jmp    8010588e <alltraps>

80106273 <vector138>:
.globl vector138
vector138:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $138
80106275:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010627a:	e9 0f f6 ff ff       	jmp    8010588e <alltraps>

8010627f <vector139>:
.globl vector139
vector139:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $139
80106281:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106286:	e9 03 f6 ff ff       	jmp    8010588e <alltraps>

8010628b <vector140>:
.globl vector140
vector140:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $140
8010628d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106292:	e9 f7 f5 ff ff       	jmp    8010588e <alltraps>

80106297 <vector141>:
.globl vector141
vector141:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $141
80106299:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010629e:	e9 eb f5 ff ff       	jmp    8010588e <alltraps>

801062a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $142
801062a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062aa:	e9 df f5 ff ff       	jmp    8010588e <alltraps>

801062af <vector143>:
.globl vector143
vector143:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $143
801062b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062b6:	e9 d3 f5 ff ff       	jmp    8010588e <alltraps>

801062bb <vector144>:
.globl vector144
vector144:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $144
801062bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062c2:	e9 c7 f5 ff ff       	jmp    8010588e <alltraps>

801062c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $145
801062c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ce:	e9 bb f5 ff ff       	jmp    8010588e <alltraps>

801062d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $146
801062d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062da:	e9 af f5 ff ff       	jmp    8010588e <alltraps>

801062df <vector147>:
.globl vector147
vector147:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $147
801062e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062e6:	e9 a3 f5 ff ff       	jmp    8010588e <alltraps>

801062eb <vector148>:
.globl vector148
vector148:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $148
801062ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062f2:	e9 97 f5 ff ff       	jmp    8010588e <alltraps>

801062f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $149
801062f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062fe:	e9 8b f5 ff ff       	jmp    8010588e <alltraps>

80106303 <vector150>:
.globl vector150
vector150:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $150
80106305:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010630a:	e9 7f f5 ff ff       	jmp    8010588e <alltraps>

8010630f <vector151>:
.globl vector151
vector151:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $151
80106311:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106316:	e9 73 f5 ff ff       	jmp    8010588e <alltraps>

8010631b <vector152>:
.globl vector152
vector152:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $152
8010631d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106322:	e9 67 f5 ff ff       	jmp    8010588e <alltraps>

80106327 <vector153>:
.globl vector153
vector153:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $153
80106329:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010632e:	e9 5b f5 ff ff       	jmp    8010588e <alltraps>

80106333 <vector154>:
.globl vector154
vector154:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $154
80106335:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010633a:	e9 4f f5 ff ff       	jmp    8010588e <alltraps>

8010633f <vector155>:
.globl vector155
vector155:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $155
80106341:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106346:	e9 43 f5 ff ff       	jmp    8010588e <alltraps>

8010634b <vector156>:
.globl vector156
vector156:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $156
8010634d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106352:	e9 37 f5 ff ff       	jmp    8010588e <alltraps>

80106357 <vector157>:
.globl vector157
vector157:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $157
80106359:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010635e:	e9 2b f5 ff ff       	jmp    8010588e <alltraps>

80106363 <vector158>:
.globl vector158
vector158:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $158
80106365:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010636a:	e9 1f f5 ff ff       	jmp    8010588e <alltraps>

8010636f <vector159>:
.globl vector159
vector159:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $159
80106371:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106376:	e9 13 f5 ff ff       	jmp    8010588e <alltraps>

8010637b <vector160>:
.globl vector160
vector160:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $160
8010637d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106382:	e9 07 f5 ff ff       	jmp    8010588e <alltraps>

80106387 <vector161>:
.globl vector161
vector161:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $161
80106389:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010638e:	e9 fb f4 ff ff       	jmp    8010588e <alltraps>

80106393 <vector162>:
.globl vector162
vector162:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $162
80106395:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010639a:	e9 ef f4 ff ff       	jmp    8010588e <alltraps>

8010639f <vector163>:
.globl vector163
vector163:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $163
801063a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063a6:	e9 e3 f4 ff ff       	jmp    8010588e <alltraps>

801063ab <vector164>:
.globl vector164
vector164:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $164
801063ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063b2:	e9 d7 f4 ff ff       	jmp    8010588e <alltraps>

801063b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $165
801063b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063be:	e9 cb f4 ff ff       	jmp    8010588e <alltraps>

801063c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $166
801063c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063ca:	e9 bf f4 ff ff       	jmp    8010588e <alltraps>

801063cf <vector167>:
.globl vector167
vector167:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $167
801063d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063d6:	e9 b3 f4 ff ff       	jmp    8010588e <alltraps>

801063db <vector168>:
.globl vector168
vector168:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $168
801063dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063e2:	e9 a7 f4 ff ff       	jmp    8010588e <alltraps>

801063e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $169
801063e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063ee:	e9 9b f4 ff ff       	jmp    8010588e <alltraps>

801063f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $170
801063f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063fa:	e9 8f f4 ff ff       	jmp    8010588e <alltraps>

801063ff <vector171>:
.globl vector171
vector171:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $171
80106401:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106406:	e9 83 f4 ff ff       	jmp    8010588e <alltraps>

8010640b <vector172>:
.globl vector172
vector172:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $172
8010640d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106412:	e9 77 f4 ff ff       	jmp    8010588e <alltraps>

80106417 <vector173>:
.globl vector173
vector173:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $173
80106419:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010641e:	e9 6b f4 ff ff       	jmp    8010588e <alltraps>

80106423 <vector174>:
.globl vector174
vector174:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $174
80106425:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010642a:	e9 5f f4 ff ff       	jmp    8010588e <alltraps>

8010642f <vector175>:
.globl vector175
vector175:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $175
80106431:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106436:	e9 53 f4 ff ff       	jmp    8010588e <alltraps>

8010643b <vector176>:
.globl vector176
vector176:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $176
8010643d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106442:	e9 47 f4 ff ff       	jmp    8010588e <alltraps>

80106447 <vector177>:
.globl vector177
vector177:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $177
80106449:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010644e:	e9 3b f4 ff ff       	jmp    8010588e <alltraps>

80106453 <vector178>:
.globl vector178
vector178:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $178
80106455:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010645a:	e9 2f f4 ff ff       	jmp    8010588e <alltraps>

8010645f <vector179>:
.globl vector179
vector179:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $179
80106461:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106466:	e9 23 f4 ff ff       	jmp    8010588e <alltraps>

8010646b <vector180>:
.globl vector180
vector180:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $180
8010646d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106472:	e9 17 f4 ff ff       	jmp    8010588e <alltraps>

80106477 <vector181>:
.globl vector181
vector181:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $181
80106479:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010647e:	e9 0b f4 ff ff       	jmp    8010588e <alltraps>

80106483 <vector182>:
.globl vector182
vector182:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $182
80106485:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010648a:	e9 ff f3 ff ff       	jmp    8010588e <alltraps>

8010648f <vector183>:
.globl vector183
vector183:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $183
80106491:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106496:	e9 f3 f3 ff ff       	jmp    8010588e <alltraps>

8010649b <vector184>:
.globl vector184
vector184:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $184
8010649d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064a2:	e9 e7 f3 ff ff       	jmp    8010588e <alltraps>

801064a7 <vector185>:
.globl vector185
vector185:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $185
801064a9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064ae:	e9 db f3 ff ff       	jmp    8010588e <alltraps>

801064b3 <vector186>:
.globl vector186
vector186:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $186
801064b5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064ba:	e9 cf f3 ff ff       	jmp    8010588e <alltraps>

801064bf <vector187>:
.globl vector187
vector187:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $187
801064c1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064c6:	e9 c3 f3 ff ff       	jmp    8010588e <alltraps>

801064cb <vector188>:
.globl vector188
vector188:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $188
801064cd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064d2:	e9 b7 f3 ff ff       	jmp    8010588e <alltraps>

801064d7 <vector189>:
.globl vector189
vector189:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $189
801064d9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064de:	e9 ab f3 ff ff       	jmp    8010588e <alltraps>

801064e3 <vector190>:
.globl vector190
vector190:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $190
801064e5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064ea:	e9 9f f3 ff ff       	jmp    8010588e <alltraps>

801064ef <vector191>:
.globl vector191
vector191:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $191
801064f1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064f6:	e9 93 f3 ff ff       	jmp    8010588e <alltraps>

801064fb <vector192>:
.globl vector192
vector192:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $192
801064fd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106502:	e9 87 f3 ff ff       	jmp    8010588e <alltraps>

80106507 <vector193>:
.globl vector193
vector193:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $193
80106509:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010650e:	e9 7b f3 ff ff       	jmp    8010588e <alltraps>

80106513 <vector194>:
.globl vector194
vector194:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $194
80106515:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010651a:	e9 6f f3 ff ff       	jmp    8010588e <alltraps>

8010651f <vector195>:
.globl vector195
vector195:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $195
80106521:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106526:	e9 63 f3 ff ff       	jmp    8010588e <alltraps>

8010652b <vector196>:
.globl vector196
vector196:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $196
8010652d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106532:	e9 57 f3 ff ff       	jmp    8010588e <alltraps>

80106537 <vector197>:
.globl vector197
vector197:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $197
80106539:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010653e:	e9 4b f3 ff ff       	jmp    8010588e <alltraps>

80106543 <vector198>:
.globl vector198
vector198:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $198
80106545:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010654a:	e9 3f f3 ff ff       	jmp    8010588e <alltraps>

8010654f <vector199>:
.globl vector199
vector199:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $199
80106551:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106556:	e9 33 f3 ff ff       	jmp    8010588e <alltraps>

8010655b <vector200>:
.globl vector200
vector200:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $200
8010655d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106562:	e9 27 f3 ff ff       	jmp    8010588e <alltraps>

80106567 <vector201>:
.globl vector201
vector201:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $201
80106569:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010656e:	e9 1b f3 ff ff       	jmp    8010588e <alltraps>

80106573 <vector202>:
.globl vector202
vector202:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $202
80106575:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010657a:	e9 0f f3 ff ff       	jmp    8010588e <alltraps>

8010657f <vector203>:
.globl vector203
vector203:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $203
80106581:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106586:	e9 03 f3 ff ff       	jmp    8010588e <alltraps>

8010658b <vector204>:
.globl vector204
vector204:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $204
8010658d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106592:	e9 f7 f2 ff ff       	jmp    8010588e <alltraps>

80106597 <vector205>:
.globl vector205
vector205:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $205
80106599:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010659e:	e9 eb f2 ff ff       	jmp    8010588e <alltraps>

801065a3 <vector206>:
.globl vector206
vector206:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $206
801065a5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065aa:	e9 df f2 ff ff       	jmp    8010588e <alltraps>

801065af <vector207>:
.globl vector207
vector207:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $207
801065b1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065b6:	e9 d3 f2 ff ff       	jmp    8010588e <alltraps>

801065bb <vector208>:
.globl vector208
vector208:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $208
801065bd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065c2:	e9 c7 f2 ff ff       	jmp    8010588e <alltraps>

801065c7 <vector209>:
.globl vector209
vector209:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $209
801065c9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ce:	e9 bb f2 ff ff       	jmp    8010588e <alltraps>

801065d3 <vector210>:
.globl vector210
vector210:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $210
801065d5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065da:	e9 af f2 ff ff       	jmp    8010588e <alltraps>

801065df <vector211>:
.globl vector211
vector211:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $211
801065e1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065e6:	e9 a3 f2 ff ff       	jmp    8010588e <alltraps>

801065eb <vector212>:
.globl vector212
vector212:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $212
801065ed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065f2:	e9 97 f2 ff ff       	jmp    8010588e <alltraps>

801065f7 <vector213>:
.globl vector213
vector213:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $213
801065f9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065fe:	e9 8b f2 ff ff       	jmp    8010588e <alltraps>

80106603 <vector214>:
.globl vector214
vector214:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $214
80106605:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010660a:	e9 7f f2 ff ff       	jmp    8010588e <alltraps>

8010660f <vector215>:
.globl vector215
vector215:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $215
80106611:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106616:	e9 73 f2 ff ff       	jmp    8010588e <alltraps>

8010661b <vector216>:
.globl vector216
vector216:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $216
8010661d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106622:	e9 67 f2 ff ff       	jmp    8010588e <alltraps>

80106627 <vector217>:
.globl vector217
vector217:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $217
80106629:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010662e:	e9 5b f2 ff ff       	jmp    8010588e <alltraps>

80106633 <vector218>:
.globl vector218
vector218:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $218
80106635:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010663a:	e9 4f f2 ff ff       	jmp    8010588e <alltraps>

8010663f <vector219>:
.globl vector219
vector219:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $219
80106641:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106646:	e9 43 f2 ff ff       	jmp    8010588e <alltraps>

8010664b <vector220>:
.globl vector220
vector220:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $220
8010664d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106652:	e9 37 f2 ff ff       	jmp    8010588e <alltraps>

80106657 <vector221>:
.globl vector221
vector221:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $221
80106659:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010665e:	e9 2b f2 ff ff       	jmp    8010588e <alltraps>

80106663 <vector222>:
.globl vector222
vector222:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $222
80106665:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010666a:	e9 1f f2 ff ff       	jmp    8010588e <alltraps>

8010666f <vector223>:
.globl vector223
vector223:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $223
80106671:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106676:	e9 13 f2 ff ff       	jmp    8010588e <alltraps>

8010667b <vector224>:
.globl vector224
vector224:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $224
8010667d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106682:	e9 07 f2 ff ff       	jmp    8010588e <alltraps>

80106687 <vector225>:
.globl vector225
vector225:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $225
80106689:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010668e:	e9 fb f1 ff ff       	jmp    8010588e <alltraps>

80106693 <vector226>:
.globl vector226
vector226:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $226
80106695:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010669a:	e9 ef f1 ff ff       	jmp    8010588e <alltraps>

8010669f <vector227>:
.globl vector227
vector227:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $227
801066a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066a6:	e9 e3 f1 ff ff       	jmp    8010588e <alltraps>

801066ab <vector228>:
.globl vector228
vector228:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $228
801066ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066b2:	e9 d7 f1 ff ff       	jmp    8010588e <alltraps>

801066b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $229
801066b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066be:	e9 cb f1 ff ff       	jmp    8010588e <alltraps>

801066c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $230
801066c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066ca:	e9 bf f1 ff ff       	jmp    8010588e <alltraps>

801066cf <vector231>:
.globl vector231
vector231:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $231
801066d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066d6:	e9 b3 f1 ff ff       	jmp    8010588e <alltraps>

801066db <vector232>:
.globl vector232
vector232:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $232
801066dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066e2:	e9 a7 f1 ff ff       	jmp    8010588e <alltraps>

801066e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $233
801066e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066ee:	e9 9b f1 ff ff       	jmp    8010588e <alltraps>

801066f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $234
801066f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066fa:	e9 8f f1 ff ff       	jmp    8010588e <alltraps>

801066ff <vector235>:
.globl vector235
vector235:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $235
80106701:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106706:	e9 83 f1 ff ff       	jmp    8010588e <alltraps>

8010670b <vector236>:
.globl vector236
vector236:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $236
8010670d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106712:	e9 77 f1 ff ff       	jmp    8010588e <alltraps>

80106717 <vector237>:
.globl vector237
vector237:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $237
80106719:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010671e:	e9 6b f1 ff ff       	jmp    8010588e <alltraps>

80106723 <vector238>:
.globl vector238
vector238:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $238
80106725:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010672a:	e9 5f f1 ff ff       	jmp    8010588e <alltraps>

8010672f <vector239>:
.globl vector239
vector239:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $239
80106731:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106736:	e9 53 f1 ff ff       	jmp    8010588e <alltraps>

8010673b <vector240>:
.globl vector240
vector240:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $240
8010673d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106742:	e9 47 f1 ff ff       	jmp    8010588e <alltraps>

80106747 <vector241>:
.globl vector241
vector241:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $241
80106749:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010674e:	e9 3b f1 ff ff       	jmp    8010588e <alltraps>

80106753 <vector242>:
.globl vector242
vector242:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $242
80106755:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010675a:	e9 2f f1 ff ff       	jmp    8010588e <alltraps>

8010675f <vector243>:
.globl vector243
vector243:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $243
80106761:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106766:	e9 23 f1 ff ff       	jmp    8010588e <alltraps>

8010676b <vector244>:
.globl vector244
vector244:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $244
8010676d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106772:	e9 17 f1 ff ff       	jmp    8010588e <alltraps>

80106777 <vector245>:
.globl vector245
vector245:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $245
80106779:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010677e:	e9 0b f1 ff ff       	jmp    8010588e <alltraps>

80106783 <vector246>:
.globl vector246
vector246:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $246
80106785:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010678a:	e9 ff f0 ff ff       	jmp    8010588e <alltraps>

8010678f <vector247>:
.globl vector247
vector247:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $247
80106791:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106796:	e9 f3 f0 ff ff       	jmp    8010588e <alltraps>

8010679b <vector248>:
.globl vector248
vector248:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $248
8010679d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067a2:	e9 e7 f0 ff ff       	jmp    8010588e <alltraps>

801067a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $249
801067a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067ae:	e9 db f0 ff ff       	jmp    8010588e <alltraps>

801067b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $250
801067b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067ba:	e9 cf f0 ff ff       	jmp    8010588e <alltraps>

801067bf <vector251>:
.globl vector251
vector251:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $251
801067c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067c6:	e9 c3 f0 ff ff       	jmp    8010588e <alltraps>

801067cb <vector252>:
.globl vector252
vector252:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $252
801067cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067d2:	e9 b7 f0 ff ff       	jmp    8010588e <alltraps>

801067d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $253
801067d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067de:	e9 ab f0 ff ff       	jmp    8010588e <alltraps>

801067e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $254
801067e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067ea:	e9 9f f0 ff ff       	jmp    8010588e <alltraps>

801067ef <vector255>:
.globl vector255
vector255:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $255
801067f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067f6:	e9 93 f0 ff ff       	jmp    8010588e <alltraps>
801067fb:	66 90                	xchg   %ax,%ax
801067fd:	66 90                	xchg   %ax,%ax
801067ff:	90                   	nop

80106800 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106807:	c1 ea 16             	shr    $0x16,%edx
{
8010680a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010680b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010680e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106811:	8b 1f                	mov    (%edi),%ebx
80106813:	f6 c3 01             	test   $0x1,%bl
80106816:	74 28                	je     80106840 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106818:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010681e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106824:	89 f0                	mov    %esi,%eax
}
80106826:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106829:	c1 e8 0a             	shr    $0xa,%eax
8010682c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106831:	01 d8                	add    %ebx,%eax
}
80106833:	5b                   	pop    %ebx
80106834:	5e                   	pop    %esi
80106835:	5f                   	pop    %edi
80106836:	5d                   	pop    %ebp
80106837:	c3                   	ret    
80106838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010683f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106840:	85 c9                	test   %ecx,%ecx
80106842:	74 2c                	je     80106870 <walkpgdir+0x70>
80106844:	e8 f7 bd ff ff       	call   80102640 <kalloc>
80106849:	89 c3                	mov    %eax,%ebx
8010684b:	85 c0                	test   %eax,%eax
8010684d:	74 21                	je     80106870 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010684f:	83 ec 04             	sub    $0x4,%esp
80106852:	68 00 10 00 00       	push   $0x1000
80106857:	6a 00                	push   $0x0
80106859:	50                   	push   %eax
8010685a:	e8 31 de ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010685f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106865:	83 c4 10             	add    $0x10,%esp
80106868:	83 c8 07             	or     $0x7,%eax
8010686b:	89 07                	mov    %eax,(%edi)
8010686d:	eb b5                	jmp    80106824 <walkpgdir+0x24>
8010686f:	90                   	nop
}
80106870:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106873:	31 c0                	xor    %eax,%eax
}
80106875:	5b                   	pop    %ebx
80106876:	5e                   	pop    %esi
80106877:	5f                   	pop    %edi
80106878:	5d                   	pop    %ebp
80106879:	c3                   	ret    
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106880 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106886:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010688a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010688b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106890:	89 d6                	mov    %edx,%esi
{
80106892:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106893:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106899:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010689c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010689f:	8b 45 08             	mov    0x8(%ebp),%eax
801068a2:	29 f0                	sub    %esi,%eax
801068a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068a7:	eb 1f                	jmp    801068c8 <mappages+0x48>
801068a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801068b0:	f6 00 01             	testb  $0x1,(%eax)
801068b3:	75 45                	jne    801068fa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801068b5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801068b8:	83 cb 01             	or     $0x1,%ebx
801068bb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801068bd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801068c0:	74 2e                	je     801068f0 <mappages+0x70>
      break;
    a += PGSIZE;
801068c2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801068c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068cb:	b9 01 00 00 00       	mov    $0x1,%ecx
801068d0:	89 f2                	mov    %esi,%edx
801068d2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801068d5:	89 f8                	mov    %edi,%eax
801068d7:	e8 24 ff ff ff       	call   80106800 <walkpgdir>
801068dc:	85 c0                	test   %eax,%eax
801068de:	75 d0                	jne    801068b0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801068e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801068e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068e8:	5b                   	pop    %ebx
801068e9:	5e                   	pop    %esi
801068ea:	5f                   	pop    %edi
801068eb:	5d                   	pop    %ebp
801068ec:	c3                   	ret    
801068ed:	8d 76 00             	lea    0x0(%esi),%esi
801068f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801068f3:	31 c0                	xor    %eax,%eax
}
801068f5:	5b                   	pop    %ebx
801068f6:	5e                   	pop    %esi
801068f7:	5f                   	pop    %edi
801068f8:	5d                   	pop    %ebp
801068f9:	c3                   	ret    
      panic("remap");
801068fa:	83 ec 0c             	sub    $0xc,%esp
801068fd:	68 50 7a 10 80       	push   $0x80107a50
80106902:	e8 89 9a ff ff       	call   80100390 <panic>
80106907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010690e:	66 90                	xchg   %ax,%ax

80106910 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	89 c6                	mov    %eax,%esi
80106917:	53                   	push   %ebx
80106918:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010691a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106920:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106926:	83 ec 1c             	sub    $0x1c,%esp
80106929:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010692c:	39 da                	cmp    %ebx,%edx
8010692e:	73 5b                	jae    8010698b <deallocuvm.part.0+0x7b>
80106930:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106933:	89 d7                	mov    %edx,%edi
80106935:	eb 14                	jmp    8010694b <deallocuvm.part.0+0x3b>
80106937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010693e:	66 90                	xchg   %ax,%ax
80106940:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106946:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106949:	76 40                	jbe    8010698b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010694b:	31 c9                	xor    %ecx,%ecx
8010694d:	89 fa                	mov    %edi,%edx
8010694f:	89 f0                	mov    %esi,%eax
80106951:	e8 aa fe ff ff       	call   80106800 <walkpgdir>
80106956:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 44                	je     801069a0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010695c:	8b 00                	mov    (%eax),%eax
8010695e:	a8 01                	test   $0x1,%al
80106960:	74 de                	je     80106940 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106967:	74 47                	je     801069b0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106969:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010696c:	05 00 00 00 80       	add    $0x80000000,%eax
80106971:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106977:	50                   	push   %eax
80106978:	e8 03 bb ff ff       	call   80102480 <kfree>
      *pte = 0;
8010697d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106983:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106986:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106989:	77 c0                	ja     8010694b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010698b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010698e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106991:	5b                   	pop    %ebx
80106992:	5e                   	pop    %esi
80106993:	5f                   	pop    %edi
80106994:	5d                   	pop    %ebp
80106995:	c3                   	ret    
80106996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069a0:	89 fa                	mov    %edi,%edx
801069a2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801069a8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801069ae:	eb 96                	jmp    80106946 <deallocuvm.part.0+0x36>
        panic("kfree");
801069b0:	83 ec 0c             	sub    $0xc,%esp
801069b3:	68 a6 73 10 80       	push   $0x801073a6
801069b8:	e8 d3 99 ff ff       	call   80100390 <panic>
801069bd:	8d 76 00             	lea    0x0(%esi),%esi

801069c0 <seginit>:
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069ca:	e8 81 cf ff ff       	call   80103950 <cpuid>
  pd[0] = size-1;
801069cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069de:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801069e5:	ff 00 00 
801069e8:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801069ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069f2:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801069f9:	ff 00 00 
801069fc:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106a03:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a06:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106a0d:	ff 00 00 
80106a10:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106a17:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a1a:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106a21:	ff 00 00 
80106a24:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106a2b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a2e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106a33:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a37:	c1 e8 10             	shr    $0x10,%eax
80106a3a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a3e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a41:	0f 01 10             	lgdtl  (%eax)
}
80106a44:	c9                   	leave  
80106a45:	c3                   	ret    
80106a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4d:	8d 76 00             	lea    0x0(%esi),%esi

80106a50 <switchkvm>:
{
80106a50:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a54:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106a59:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a5e:	0f 22 d8             	mov    %eax,%cr3
}
80106a61:	c3                   	ret    
80106a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a70 <switchuvm>:
{
80106a70:	f3 0f 1e fb          	endbr32 
80106a74:	55                   	push   %ebp
80106a75:	89 e5                	mov    %esp,%ebp
80106a77:	57                   	push   %edi
80106a78:	56                   	push   %esi
80106a79:	53                   	push   %ebx
80106a7a:	83 ec 1c             	sub    $0x1c,%esp
80106a7d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a80:	85 f6                	test   %esi,%esi
80106a82:	0f 84 cb 00 00 00    	je     80106b53 <switchuvm+0xe3>
  if(p->kstack == 0)
80106a88:	8b 46 0c             	mov    0xc(%esi),%eax
80106a8b:	85 c0                	test   %eax,%eax
80106a8d:	0f 84 da 00 00 00    	je     80106b6d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106a93:	8b 46 08             	mov    0x8(%esi),%eax
80106a96:	85 c0                	test   %eax,%eax
80106a98:	0f 84 c2 00 00 00    	je     80106b60 <switchuvm+0xf0>
  pushcli();
80106a9e:	e8 dd d9 ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aa3:	e8 38 ce ff ff       	call   801038e0 <mycpu>
80106aa8:	89 c3                	mov    %eax,%ebx
80106aaa:	e8 31 ce ff ff       	call   801038e0 <mycpu>
80106aaf:	89 c7                	mov    %eax,%edi
80106ab1:	e8 2a ce ff ff       	call   801038e0 <mycpu>
80106ab6:	83 c7 08             	add    $0x8,%edi
80106ab9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106abc:	e8 1f ce ff ff       	call   801038e0 <mycpu>
80106ac1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ac4:	ba 67 00 00 00       	mov    $0x67,%edx
80106ac9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ad0:	83 c0 08             	add    $0x8,%eax
80106ad3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ada:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106adf:	83 c1 08             	add    $0x8,%ecx
80106ae2:	c1 e8 18             	shr    $0x18,%eax
80106ae5:	c1 e9 10             	shr    $0x10,%ecx
80106ae8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106aee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106af4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106af9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b00:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b05:	e8 d6 cd ff ff       	call   801038e0 <mycpu>
80106b0a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b11:	e8 ca cd ff ff       	call   801038e0 <mycpu>
80106b16:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b1a:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106b1d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b23:	e8 b8 cd ff ff       	call   801038e0 <mycpu>
80106b28:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b2b:	e8 b0 cd ff ff       	call   801038e0 <mycpu>
80106b30:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b34:	b8 28 00 00 00       	mov    $0x28,%eax
80106b39:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b3c:	8b 46 08             	mov    0x8(%esi),%eax
80106b3f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b44:	0f 22 d8             	mov    %eax,%cr3
}
80106b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b4a:	5b                   	pop    %ebx
80106b4b:	5e                   	pop    %esi
80106b4c:	5f                   	pop    %edi
80106b4d:	5d                   	pop    %ebp
  popcli();
80106b4e:	e9 7d d9 ff ff       	jmp    801044d0 <popcli>
    panic("switchuvm: no process");
80106b53:	83 ec 0c             	sub    $0xc,%esp
80106b56:	68 56 7a 10 80       	push   $0x80107a56
80106b5b:	e8 30 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106b60:	83 ec 0c             	sub    $0xc,%esp
80106b63:	68 81 7a 10 80       	push   $0x80107a81
80106b68:	e8 23 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106b6d:	83 ec 0c             	sub    $0xc,%esp
80106b70:	68 6c 7a 10 80       	push   $0x80107a6c
80106b75:	e8 16 98 ff ff       	call   80100390 <panic>
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b80 <inituvm>:
{
80106b80:	f3 0f 1e fb          	endbr32 
80106b84:	55                   	push   %ebp
80106b85:	89 e5                	mov    %esp,%ebp
80106b87:	57                   	push   %edi
80106b88:	56                   	push   %esi
80106b89:	53                   	push   %ebx
80106b8a:	83 ec 1c             	sub    $0x1c,%esp
80106b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b90:	8b 75 10             	mov    0x10(%ebp),%esi
80106b93:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b99:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b9f:	77 4b                	ja     80106bec <inituvm+0x6c>
  mem = kalloc();
80106ba1:	e8 9a ba ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80106ba6:	83 ec 04             	sub    $0x4,%esp
80106ba9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106bae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bb0:	6a 00                	push   $0x0
80106bb2:	50                   	push   %eax
80106bb3:	e8 d8 da ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bb8:	58                   	pop    %eax
80106bb9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bbf:	5a                   	pop    %edx
80106bc0:	6a 06                	push   $0x6
80106bc2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bc7:	31 d2                	xor    %edx,%edx
80106bc9:	50                   	push   %eax
80106bca:	89 f8                	mov    %edi,%eax
80106bcc:	e8 af fc ff ff       	call   80106880 <mappages>
  memmove(mem, init, sz);
80106bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bd4:	89 75 10             	mov    %esi,0x10(%ebp)
80106bd7:	83 c4 10             	add    $0x10,%esp
80106bda:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106bdd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be3:	5b                   	pop    %ebx
80106be4:	5e                   	pop    %esi
80106be5:	5f                   	pop    %edi
80106be6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106be7:	e9 44 db ff ff       	jmp    80104730 <memmove>
    panic("inituvm: more than a page");
80106bec:	83 ec 0c             	sub    $0xc,%esp
80106bef:	68 95 7a 10 80       	push   $0x80107a95
80106bf4:	e8 97 97 ff ff       	call   80100390 <panic>
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <loaduvm>:
{
80106c00:	f3 0f 1e fb          	endbr32 
80106c04:	55                   	push   %ebp
80106c05:	89 e5                	mov    %esp,%ebp
80106c07:	57                   	push   %edi
80106c08:	56                   	push   %esi
80106c09:	53                   	push   %ebx
80106c0a:	83 ec 1c             	sub    $0x1c,%esp
80106c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c10:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c13:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c18:	0f 85 84 00 00 00    	jne    80106ca2 <loaduvm+0xa2>
  for(i = 0; i < sz; i += PGSIZE){
80106c1e:	01 f0                	add    %esi,%eax
80106c20:	89 f3                	mov    %esi,%ebx
80106c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c25:	8b 45 14             	mov    0x14(%ebp),%eax
80106c28:	01 f0                	add    %esi,%eax
80106c2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c2d:	85 f6                	test   %esi,%esi
80106c2f:	75 15                	jne    80106c46 <loaduvm+0x46>
80106c31:	eb 65                	jmp    80106c98 <loaduvm+0x98>
80106c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c37:	90                   	nop
80106c38:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106c3e:	89 f0                	mov    %esi,%eax
80106c40:	29 d8                	sub    %ebx,%eax
80106c42:	39 c6                	cmp    %eax,%esi
80106c44:	76 52                	jbe    80106c98 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0) {
80106c46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c49:	8b 45 08             	mov    0x8(%ebp),%eax
80106c4c:	31 c9                	xor    %ecx,%ecx
    if(sz - i < PGSIZE)
80106c4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0) {
80106c53:	29 da                	sub    %ebx,%edx
80106c55:	e8 a6 fb ff ff       	call   80106800 <walkpgdir>
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c5a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106c5d:	8b 00                	mov    (%eax),%eax
80106c5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c64:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106c6a:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c6d:	29 d9                	sub    %ebx,%ecx
80106c6f:	05 00 00 00 80       	add    $0x80000000,%eax
80106c74:	57                   	push   %edi
80106c75:	51                   	push   %ecx
80106c76:	50                   	push   %eax
80106c77:	ff 75 10             	pushl  0x10(%ebp)
80106c7a:	e8 f1 ad ff ff       	call   80101a70 <readi>
80106c7f:	83 c4 10             	add    $0x10,%esp
80106c82:	39 f8                	cmp    %edi,%eax
80106c84:	74 b2                	je     80106c38 <loaduvm+0x38>
}
80106c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c8e:	5b                   	pop    %ebx
80106c8f:	5e                   	pop    %esi
80106c90:	5f                   	pop    %edi
80106c91:	5d                   	pop    %ebp
80106c92:	c3                   	ret    
80106c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c97:	90                   	nop
80106c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c9b:	31 c0                	xor    %eax,%eax
}
80106c9d:	5b                   	pop    %ebx
80106c9e:	5e                   	pop    %esi
80106c9f:	5f                   	pop    %edi
80106ca0:	5d                   	pop    %ebp
80106ca1:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106ca2:	83 ec 0c             	sub    $0xc,%esp
80106ca5:	68 34 7b 10 80       	push   $0x80107b34
80106caa:	e8 e1 96 ff ff       	call   80100390 <panic>
80106caf:	90                   	nop

80106cb0 <allocuvm>:
{
80106cb0:	f3 0f 1e fb          	endbr32 
80106cb4:	55                   	push   %ebp
80106cb5:	89 e5                	mov    %esp,%ebp
80106cb7:	57                   	push   %edi
80106cb8:	56                   	push   %esi
80106cb9:	53                   	push   %ebx
80106cba:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106cbd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106cc0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106cc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cc6:	85 c0                	test   %eax,%eax
80106cc8:	0f 88 b2 00 00 00    	js     80106d80 <allocuvm+0xd0>
  if(newsz < oldsz)
80106cce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106cd4:	0f 82 96 00 00 00    	jb     80106d70 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106cda:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106ce0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106ce6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ce9:	77 40                	ja     80106d2b <allocuvm+0x7b>
80106ceb:	e9 83 00 00 00       	jmp    80106d73 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106cf0:	83 ec 04             	sub    $0x4,%esp
80106cf3:	68 00 10 00 00       	push   $0x1000
80106cf8:	6a 00                	push   $0x0
80106cfa:	50                   	push   %eax
80106cfb:	e8 90 d9 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d00:	58                   	pop    %eax
80106d01:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d07:	5a                   	pop    %edx
80106d08:	6a 06                	push   $0x6
80106d0a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d0f:	89 f2                	mov    %esi,%edx
80106d11:	50                   	push   %eax
80106d12:	89 f8                	mov    %edi,%eax
80106d14:	e8 67 fb ff ff       	call   80106880 <mappages>
80106d19:	83 c4 10             	add    $0x10,%esp
80106d1c:	85 c0                	test   %eax,%eax
80106d1e:	78 78                	js     80106d98 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106d20:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d26:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d29:	76 48                	jbe    80106d73 <allocuvm+0xc3>
    mem = kalloc();
80106d2b:	e8 10 b9 ff ff       	call   80102640 <kalloc>
80106d30:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d32:	85 c0                	test   %eax,%eax
80106d34:	75 ba                	jne    80106cf0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d36:	83 ec 0c             	sub    $0xc,%esp
80106d39:	68 af 7a 10 80       	push   $0x80107aaf
80106d3e:	e8 6d 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d43:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d46:	83 c4 10             	add    $0x10,%esp
80106d49:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d4c:	74 32                	je     80106d80 <allocuvm+0xd0>
80106d4e:	8b 55 10             	mov    0x10(%ebp),%edx
80106d51:	89 c1                	mov    %eax,%ecx
80106d53:	89 f8                	mov    %edi,%eax
80106d55:	e8 b6 fb ff ff       	call   80106910 <deallocuvm.part.0>
      return 0;
80106d5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d67:	5b                   	pop    %ebx
80106d68:	5e                   	pop    %esi
80106d69:	5f                   	pop    %edi
80106d6a:	5d                   	pop    %ebp
80106d6b:	c3                   	ret    
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106d70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d79:	5b                   	pop    %ebx
80106d7a:	5e                   	pop    %esi
80106d7b:	5f                   	pop    %edi
80106d7c:	5d                   	pop    %ebp
80106d7d:	c3                   	ret    
80106d7e:	66 90                	xchg   %ax,%ax
    return 0;
80106d80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d8d:	5b                   	pop    %ebx
80106d8e:	5e                   	pop    %esi
80106d8f:	5f                   	pop    %edi
80106d90:	5d                   	pop    %ebp
80106d91:	c3                   	ret    
80106d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106d98:	83 ec 0c             	sub    $0xc,%esp
80106d9b:	68 c7 7a 10 80       	push   $0x80107ac7
80106da0:	e8 0b 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106da5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da8:	83 c4 10             	add    $0x10,%esp
80106dab:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dae:	74 0c                	je     80106dbc <allocuvm+0x10c>
80106db0:	8b 55 10             	mov    0x10(%ebp),%edx
80106db3:	89 c1                	mov    %eax,%ecx
80106db5:	89 f8                	mov    %edi,%eax
80106db7:	e8 54 fb ff ff       	call   80106910 <deallocuvm.part.0>
      kfree(mem);
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	53                   	push   %ebx
80106dc0:	e8 bb b6 ff ff       	call   80102480 <kfree>
      return 0;
80106dc5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106dcc:	83 c4 10             	add    $0x10,%esp
}
80106dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd5:	5b                   	pop    %ebx
80106dd6:	5e                   	pop    %esi
80106dd7:	5f                   	pop    %edi
80106dd8:	5d                   	pop    %ebp
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <deallocuvm>:
{
80106de0:	f3 0f 1e fb          	endbr32 
80106de4:	55                   	push   %ebp
80106de5:	89 e5                	mov    %esp,%ebp
80106de7:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ded:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106df0:	39 d1                	cmp    %edx,%ecx
80106df2:	73 0c                	jae    80106e00 <deallocuvm+0x20>
}
80106df4:	5d                   	pop    %ebp
80106df5:	e9 16 fb ff ff       	jmp    80106910 <deallocuvm.part.0>
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e00:	89 d0                	mov    %edx,%eax
80106e02:	5d                   	pop    %ebp
80106e03:	c3                   	ret    
80106e04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e0f:	90                   	nop

80106e10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e10:	f3 0f 1e fb          	endbr32 
80106e14:	55                   	push   %ebp
80106e15:	89 e5                	mov    %esp,%ebp
80106e17:	57                   	push   %edi
80106e18:	56                   	push   %esi
80106e19:	53                   	push   %ebx
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e20:	85 f6                	test   %esi,%esi
80106e22:	74 55                	je     80106e79 <freevm+0x69>
  if(newsz >= oldsz)
80106e24:	31 c9                	xor    %ecx,%ecx
80106e26:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e2b:	89 f0                	mov    %esi,%eax
80106e2d:	89 f3                	mov    %esi,%ebx
80106e2f:	e8 dc fa ff ff       	call   80106910 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e34:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e3a:	eb 0b                	jmp    80106e47 <freevm+0x37>
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e40:	83 c3 04             	add    $0x4,%ebx
80106e43:	39 df                	cmp    %ebx,%edi
80106e45:	74 23                	je     80106e6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e47:	8b 03                	mov    (%ebx),%eax
80106e49:	a8 01                	test   $0x1,%al
80106e4b:	74 f3                	je     80106e40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e52:	83 ec 0c             	sub    $0xc,%esp
80106e55:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e58:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e5d:	50                   	push   %eax
80106e5e:	e8 1d b6 ff ff       	call   80102480 <kfree>
80106e63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e66:	39 df                	cmp    %ebx,%edi
80106e68:	75 dd                	jne    80106e47 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e70:	5b                   	pop    %ebx
80106e71:	5e                   	pop    %esi
80106e72:	5f                   	pop    %edi
80106e73:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e74:	e9 07 b6 ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80106e79:	83 ec 0c             	sub    $0xc,%esp
80106e7c:	68 e3 7a 10 80       	push   $0x80107ae3
80106e81:	e8 0a 95 ff ff       	call   80100390 <panic>
80106e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi

80106e90 <setupkvm>:
{
80106e90:	f3 0f 1e fb          	endbr32 
80106e94:	55                   	push   %ebp
80106e95:	89 e5                	mov    %esp,%ebp
80106e97:	56                   	push   %esi
80106e98:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e99:	e8 a2 b7 ff ff       	call   80102640 <kalloc>
80106e9e:	89 c6                	mov    %eax,%esi
80106ea0:	85 c0                	test   %eax,%eax
80106ea2:	74 42                	je     80106ee6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106ea4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ea7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106eac:	68 00 10 00 00       	push   $0x1000
80106eb1:	6a 00                	push   $0x0
80106eb3:	50                   	push   %eax
80106eb4:	e8 d7 d7 ff ff       	call   80104690 <memset>
80106eb9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ebc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ebf:	83 ec 08             	sub    $0x8,%esp
80106ec2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ec5:	ff 73 0c             	pushl  0xc(%ebx)
80106ec8:	8b 13                	mov    (%ebx),%edx
80106eca:	50                   	push   %eax
80106ecb:	29 c1                	sub    %eax,%ecx
80106ecd:	89 f0                	mov    %esi,%eax
80106ecf:	e8 ac f9 ff ff       	call   80106880 <mappages>
80106ed4:	83 c4 10             	add    $0x10,%esp
80106ed7:	85 c0                	test   %eax,%eax
80106ed9:	78 15                	js     80106ef0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106edb:	83 c3 10             	add    $0x10,%ebx
80106ede:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ee4:	75 d6                	jne    80106ebc <setupkvm+0x2c>
}
80106ee6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ee9:	89 f0                	mov    %esi,%eax
80106eeb:	5b                   	pop    %ebx
80106eec:	5e                   	pop    %esi
80106eed:	5d                   	pop    %ebp
80106eee:	c3                   	ret    
80106eef:	90                   	nop
      freevm(pgdir);
80106ef0:	83 ec 0c             	sub    $0xc,%esp
80106ef3:	56                   	push   %esi
      return 0;
80106ef4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106ef6:	e8 15 ff ff ff       	call   80106e10 <freevm>
      return 0;
80106efb:	83 c4 10             	add    $0x10,%esp
}
80106efe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f01:	89 f0                	mov    %esi,%eax
80106f03:	5b                   	pop    %ebx
80106f04:	5e                   	pop    %esi
80106f05:	5d                   	pop    %ebp
80106f06:	c3                   	ret    
80106f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0e:	66 90                	xchg   %ax,%ax

80106f10 <kvmalloc>:
{
80106f10:	f3 0f 1e fb          	endbr32 
80106f14:	55                   	push   %ebp
80106f15:	89 e5                	mov    %esp,%ebp
80106f17:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f1a:	e8 71 ff ff ff       	call   80106e90 <setupkvm>
80106f1f:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f24:	05 00 00 00 80       	add    $0x80000000,%eax
80106f29:	0f 22 d8             	mov    %eax,%cr3
}
80106f2c:	c9                   	leave  
80106f2d:	c3                   	ret    
80106f2e:	66 90                	xchg   %ax,%ax

80106f30 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f30:	f3 0f 1e fb          	endbr32 
80106f34:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f35:	31 c9                	xor    %ecx,%ecx
{
80106f37:	89 e5                	mov    %esp,%ebp
80106f39:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f42:	e8 b9 f8 ff ff       	call   80106800 <walkpgdir>
  if(pte == 0)
80106f47:	85 c0                	test   %eax,%eax
80106f49:	74 05                	je     80106f50 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f4b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f4e:	c9                   	leave  
80106f4f:	c3                   	ret    
    panic("clearpteu");
80106f50:	83 ec 0c             	sub    $0xc,%esp
80106f53:	68 f4 7a 10 80       	push   $0x80107af4
80106f58:	e8 33 94 ff ff       	call   80100390 <panic>
80106f5d:	8d 76 00             	lea    0x0(%esi),%esi

80106f60 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f60:	f3 0f 1e fb          	endbr32 
80106f64:	55                   	push   %ebp
80106f65:	89 e5                	mov    %esp,%ebp
80106f67:	57                   	push   %edi
80106f68:	56                   	push   %esi
80106f69:	53                   	push   %ebx
80106f6a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f6d:	e8 1e ff ff ff       	call   80106e90 <setupkvm>
80106f72:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f75:	85 c0                	test   %eax,%eax
80106f77:	0f 84 a3 00 00 00    	je     80107020 <copyuvm+0xc0>
    return 0;

  //I modified
  for(i = 2143299344; i > sz; i -= PGSIZE){
80106f7d:	81 7d 0c 0f 27 c0 7f 	cmpl   $0x7fc0270f,0xc(%ebp)
80106f84:	0f 87 96 00 00 00    	ja     80107020 <copyuvm+0xc0>
80106f8a:	be 10 27 c0 7f       	mov    $0x7fc02710,%esi
80106f8f:	eb 49                	jmp    80106fda <copyuvm+0x7a>
80106f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f98:	83 ec 04             	sub    $0x4,%esp
80106f9b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fa1:	68 00 10 00 00       	push   $0x1000
80106fa6:	57                   	push   %edi
80106fa7:	50                   	push   %eax
80106fa8:	e8 83 d7 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106fad:	58                   	pop    %eax
80106fae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fb4:	5a                   	pop    %edx
80106fb5:	ff 75 e4             	pushl  -0x1c(%ebp)
80106fb8:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fbd:	89 f2                	mov    %esi,%edx
80106fbf:	50                   	push   %eax
80106fc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fc3:	e8 b8 f8 ff ff       	call   80106880 <mappages>
80106fc8:	83 c4 10             	add    $0x10,%esp
80106fcb:	85 c0                	test   %eax,%eax
80106fcd:	78 61                	js     80107030 <copyuvm+0xd0>
  for(i = 2143299344; i > sz; i -= PGSIZE){
80106fcf:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fd5:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106fd8:	73 46                	jae    80107020 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fda:	8b 45 08             	mov    0x8(%ebp),%eax
80106fdd:	31 c9                	xor    %ecx,%ecx
80106fdf:	89 f2                	mov    %esi,%edx
80106fe1:	e8 1a f8 ff ff       	call   80106800 <walkpgdir>
80106fe6:	85 c0                	test   %eax,%eax
80106fe8:	74 61                	je     8010704b <copyuvm+0xeb>
    if(!(*pte & PTE_P))
80106fea:	8b 00                	mov    (%eax),%eax
80106fec:	a8 01                	test   $0x1,%al
80106fee:	74 4e                	je     8010703e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80106ff0:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106ff2:	25 ff 0f 00 00       	and    $0xfff,%eax
80106ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106ffa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107000:	e8 3b b6 ff ff       	call   80102640 <kalloc>
80107005:	89 c3                	mov    %eax,%ebx
80107007:	85 c0                	test   %eax,%eax
80107009:	75 8d                	jne    80106f98 <copyuvm+0x38>
    }
  }
  return d;

bad:
  freevm(d);
8010700b:	83 ec 0c             	sub    $0xc,%esp
8010700e:	ff 75 e0             	pushl  -0x20(%ebp)
80107011:	e8 fa fd ff ff       	call   80106e10 <freevm>
  return 0;
80107016:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010701d:	83 c4 10             	add    $0x10,%esp
}
80107020:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107026:	5b                   	pop    %ebx
80107027:	5e                   	pop    %esi
80107028:	5f                   	pop    %edi
80107029:	5d                   	pop    %ebp
8010702a:	c3                   	ret    
8010702b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010702f:	90                   	nop
      kfree(mem);
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	53                   	push   %ebx
80107034:	e8 47 b4 ff ff       	call   80102480 <kfree>
      goto bad;
80107039:	83 c4 10             	add    $0x10,%esp
8010703c:	eb cd                	jmp    8010700b <copyuvm+0xab>
      panic("copyuvm: page not present");
8010703e:	83 ec 0c             	sub    $0xc,%esp
80107041:	68 18 7b 10 80       	push   $0x80107b18
80107046:	e8 45 93 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010704b:	83 ec 0c             	sub    $0xc,%esp
8010704e:	68 fe 7a 10 80       	push   $0x80107afe
80107053:	e8 38 93 ff ff       	call   80100390 <panic>
80107058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop

80107060 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107060:	f3 0f 1e fb          	endbr32 
80107064:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107065:	31 c9                	xor    %ecx,%ecx
{
80107067:	89 e5                	mov    %esp,%ebp
80107069:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010706c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010706f:	8b 45 08             	mov    0x8(%ebp),%eax
80107072:	e8 89 f7 ff ff       	call   80106800 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107077:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107079:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010707a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010707c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107081:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107084:	05 00 00 00 80       	add    $0x80000000,%eax
80107089:	83 fa 05             	cmp    $0x5,%edx
8010708c:	ba 00 00 00 00       	mov    $0x0,%edx
80107091:	0f 45 c2             	cmovne %edx,%eax
}
80107094:	c3                   	ret    
80107095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
801070a5:	89 e5                	mov    %esp,%ebp
801070a7:	57                   	push   %edi
801070a8:	56                   	push   %esi
801070a9:	53                   	push   %ebx
801070aa:	83 ec 0c             	sub    $0xc,%esp
801070ad:	8b 75 14             	mov    0x14(%ebp),%esi
801070b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070b3:	85 f6                	test   %esi,%esi
801070b5:	75 3c                	jne    801070f3 <copyout+0x53>
801070b7:	eb 67                	jmp    80107120 <copyout+0x80>
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801070c3:	89 fb                	mov    %edi,%ebx
801070c5:	29 d3                	sub    %edx,%ebx
801070c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801070cd:	39 f3                	cmp    %esi,%ebx
801070cf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070d2:	29 fa                	sub    %edi,%edx
801070d4:	83 ec 04             	sub    $0x4,%esp
801070d7:	01 c2                	add    %eax,%edx
801070d9:	53                   	push   %ebx
801070da:	ff 75 10             	pushl  0x10(%ebp)
801070dd:	52                   	push   %edx
801070de:	e8 4d d6 ff ff       	call   80104730 <memmove>
    len -= n;
    buf += n;
801070e3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801070e6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801070ec:	83 c4 10             	add    $0x10,%esp
801070ef:	29 de                	sub    %ebx,%esi
801070f1:	74 2d                	je     80107120 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801070f3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801070f5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801070f8:	89 55 0c             	mov    %edx,0xc(%ebp)
801070fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107101:	57                   	push   %edi
80107102:	ff 75 08             	pushl  0x8(%ebp)
80107105:	e8 56 ff ff ff       	call   80107060 <uva2ka>
    if(pa0 == 0)
8010710a:	83 c4 10             	add    $0x10,%esp
8010710d:	85 c0                	test   %eax,%eax
8010710f:	75 af                	jne    801070c0 <copyout+0x20>
  }
  return 0;
}
80107111:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107119:	5b                   	pop    %ebx
8010711a:	5e                   	pop    %esi
8010711b:	5f                   	pop    %edi
8010711c:	5d                   	pop    %ebp
8010711d:	c3                   	ret    
8010711e:	66 90                	xchg   %ax,%ax
80107120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107123:	31 c0                	xor    %eax,%eax
}
80107125:	5b                   	pop    %ebx
80107126:	5e                   	pop    %esi
80107127:	5f                   	pop    %edi
80107128:	5d                   	pop    %ebp
80107129:	c3                   	ret    
