
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c6 10 80       	mov    $0x8010c6c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 32 10 80       	mov    $0x80103240,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c6 10 80       	mov    $0x8010c6f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 80 10 80       	push   $0x80108080
80100051:	68 c0 c6 10 80       	push   $0x8010c6c0
80100056:	e8 95 45 00 00       	call   801045f0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0e 11 80 bc 	movl   $0x80110dbc,0x80110e0c
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0e 11 80 bc 	movl   $0x80110dbc,0x80110e10
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0d 11 80       	mov    $0x80110dbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0d 11 80 	movl   $0x80110dbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 80 10 80       	push   $0x80108087
80100097:	50                   	push   %eax
80100098:	e8 23 44 00 00       	call   801044c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0e 11 80       	mov    0x80110e10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0e 11 80    	mov    %ebx,0x80110e10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0d 11 80       	cmp    $0x80110dbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c6 10 80       	push   $0x8010c6c0
801000e4:	e8 47 46 00 00       	call   80104730 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0e 11 80    	mov    0x80110e10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0d 11 80    	cmp    $0x80110dbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0d 11 80    	cmp    $0x80110dbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0e 11 80    	mov    0x80110e0c,%ebx
80100126:	81 fb bc 0d 11 80    	cmp    $0x80110dbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0d 11 80    	cmp    $0x80110dbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c6 10 80       	push   $0x8010c6c0
80100162:	e8 89 46 00 00       	call   801047f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 43 00 00       	call   80104500 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 21 00 00       	call   80102360 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 80 10 80       	push   $0x8010808e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 43 00 00       	call   801045a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 97 21 00 00       	jmp    80102360 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 80 10 80       	push   $0x8010809f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 43 00 00       	call   801045a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 43 00 00       	call   80104560 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c6 10 80 	movl   $0x8010c6c0,(%esp)
8010020b:	e8 20 45 00 00       	call   80104730 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0e 11 80       	mov    0x80110e10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0d 11 80 	movl   $0x80110dbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0e 11 80       	mov    0x80110e10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0e 11 80    	mov    %ebx,0x80110e10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c6 10 80 	movl   $0x8010c6c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 45 00 00       	jmp    801047f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 80 10 80       	push   $0x801080a6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int off, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 8b 16 00 00       	call   80101910 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 9f 44 00 00       	call   80104730 <acquire>
  while(n > 0){
80100291:	8b 5d 14             	mov    0x14(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 10 11 80    	mov    0x801110a0,%edx
801002a7:	39 15 a4 10 11 80    	cmp    %edx,0x801110a4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 10 11 80       	push   $0x801110a0
801002c5:	e8 66 3e 00 00       	call   80104130 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 10 11 80    	mov    0x801110a0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 10 11 80    	cmp    0x801110a4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 b0 38 00 00       	call   80103b90 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 fc 44 00 00       	call   801047f0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 34 15 00 00       	call   80101830 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 10 11 80       	mov    %eax,0x801110a0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 10 11 80 	movsbl -0x7feeefe0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 14             	mov    0x14(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 9e 44 00 00       	call   801047f0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 d6 14 00 00       	call   80101830 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 14             	mov    0x14(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 14             	cmp    0x14(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 10 11 80    	mov    %edx,0x801110a0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 14             	mov    0x14(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 27 00 00       	call   80102ad0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 80 10 80       	push   $0x801080ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 17 8a 10 80 	movl   $0x80108a17,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 42 00 00       	call   80104610 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 80 10 80       	push   $0x801080c1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 71 5a 00 00       	call   80105eb0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 bf 59 00 00       	call   80105eb0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 59 00 00       	call   80105eb0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 59 00 00       	call   80105eb0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 c7 43 00 00       	call   801048f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 fa 42 00 00       	call   80104840 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 80 10 80       	push   $0x801080c5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 f0 80 10 80 	movzbl -0x7fef7f10(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 fc 12 00 00       	call   80101910 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 10 41 00 00       	call   80104730 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 a4 41 00 00       	call   801047f0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 db 11 00 00       	call   80101830 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 cc 40 00 00       	call   801047f0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba d8 80 10 80       	mov    $0x801080d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 3b 3f 00 00       	call   80104730 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 80 10 80       	push   $0x801080df
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 08 3f 00 00       	call   80104730 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 10 11 80       	mov    0x801110a8,%eax
80100856:	3b 05 a4 10 11 80    	cmp    0x801110a4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 10 11 80       	mov    %eax,0x801110a8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 63 3f 00 00       	call   801047f0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 10 11 80       	mov    0x801110a8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 10 11 80    	sub    0x801110a0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 10 11 80    	mov    %edx,0x801110a8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 10 11 80    	mov    %cl,-0x7feeefe0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 10 11 80       	mov    0x801110a0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 10 11 80    	cmp    %eax,0x801110a8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 10 11 80       	mov    %eax,0x801110a4
          wakeup(&input.r);
80100911:	68 a0 10 11 80       	push   $0x801110a0
80100916:	e8 c5 39 00 00       	call   801042e0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 10 11 80       	mov    0x801110a8,%eax
8010093d:	39 05 a4 10 11 80    	cmp    %eax,0x801110a4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 10 11 80       	mov    %eax,0x801110a8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 10 11 80       	mov    0x801110a8,%eax
80100964:	3b 05 a4 10 11 80    	cmp    0x801110a4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 10 11 80 0a 	cmpb   $0xa,-0x7feeefe0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 24 3a 00 00       	jmp    801043c0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 10 11 80 0a 	movb   $0xa,-0x7feeefe0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 10 11 80       	mov    0x801110a8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 e8 80 10 80       	push   $0x801080e8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 1b 3c 00 00       	call   801045f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 7c 1a 11 80 00 	movl   $0x80100600,0x80111a7c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 78 1a 11 80 70 	movl   $0x80100270,0x80111a78
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 72 1c 00 00       	call   80102670 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 6f 31 00 00       	call   80103b90 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 14 25 00 00       	call   80102f40 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 e9 16 00 00       	call   80102120 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 e3 0d 00 00       	call   80101830 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 b2 10 00 00       	call   80101b10 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 51 10 00 00       	call   80101ac0 <iunlockput>
    end_op();
80100a6f:	e8 3c 25 00 00       	call   80102fb0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 67 65 00 00       	call   80107000 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 25 63 00 00       	call   80106e20 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 33 62 00 00       	call   80106d60 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 b3 0f 00 00       	call   80101b10 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 09 64 00 00       	call   80106f80 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 26 0f 00 00       	call   80101ac0 <iunlockput>
  end_op();
80100b9a:	e8 11 24 00 00       	call   80102fb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 71 62 00 00       	call   80106e20 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ba 63 00 00       	call   80106f80 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 23 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 81 10 80       	push   $0x80108101
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 95 64 00 00       	call   801070a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 22 3e 00 00       	call   80104a60 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 0f 3e 00 00       	call   80104a60 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 65 00 00       	call   80107200 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 34 65 00 00       	call   80107200 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 11 3d 00 00       	call   80104a20 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 97 5e 00 00       	call   80106bd0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 3f 62 00 00       	call   80106f80 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 0d 81 10 80       	push   $0x8010810d
80100d6b:	68 c0 10 11 80       	push   $0x801110c0
80100d70:	e8 7b 38 00 00       	call   801045f0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 10 11 80       	mov    $0x801110f4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 10 11 80       	push   $0x801110c0
80100d91:	e8 9a 39 00 00       	call   80104730 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 1a 11 80    	cmp    $0x80111a54,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 10 11 80       	push   $0x801110c0
80100dc1:	e8 2a 3a 00 00       	call   801047f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 10 11 80       	push   $0x801110c0
80100dda:	e8 11 3a 00 00       	call   801047f0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 10 11 80       	push   $0x801110c0
80100dff:	e8 2c 39 00 00       	call   80104730 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 10 11 80       	push   $0x801110c0
80100e1c:	e8 cf 39 00 00       	call   801047f0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 14 81 10 80       	push   $0x80108114
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 10 11 80       	push   $0x801110c0
80100e51:	e8 da 38 00 00       	call   80104730 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 10 11 80 	movl   $0x801110c0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 6f 39 00 00       	jmp    801047f0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 10 11 80       	push   $0x801110c0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 43 39 00 00       	call   801047f0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 1a 28 00 00       	call   801036f0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 5b 20 00 00       	call   80102f40 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 70 0a 00 00       	call   80101960 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 b1 20 00 00       	jmp    80102fb0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 1c 81 10 80       	push   $0x8010811c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 06 09 00 00       	call   80101830 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 a9 0b 00 00       	call   80101ae0 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 d0 09 00 00       	call   80101910 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 a1 08 00 00       	call   80101830 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 74 0b 00 00       	call   80101b10 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 5d 09 00 00       	call   80101910 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 28 00 00       	jmp    801038a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 26 81 10 80       	push   $0x80108126
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 c7 08 00 00       	call   80101910 <iunlock>
      end_op();
80101049:	e8 62 1f 00 00       	call   80102fb0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 c5 1e 00 00       	call   80102f40 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 aa 07 00 00       	call   80101830 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 78 0b 00 00       	call   80101c10 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 63 08 00 00       	call   80101910 <iunlock>
      end_op();
801010ad:	e8 fe 1e 00 00       	call   80102fb0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 9e 26 00 00       	jmp    80103790 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 2f 81 10 80       	push   $0x8010812f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 35 81 10 80       	push   $0x80108135
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101110 <get_free_fds>:

// functions for filestat
int
get_free_fds(void)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101114:	31 db                	xor    %ebx,%ebx
{
80101116:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101119:	68 c0 10 11 80       	push   $0x801110c0
8010111e:	e8 0d 36 00 00       	call   80104730 <acquire>
80101123:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101126:	ba f4 10 11 80       	mov    $0x801110f4,%edx
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->ref == 0){
      counter++;
80101130:	83 7a 04 01          	cmpl   $0x1,0x4(%edx)
80101134:	83 d3 00             	adc    $0x0,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101137:	83 c2 18             	add    $0x18,%edx
8010113a:	81 fa 54 1a 11 80    	cmp    $0x80111a54,%edx
80101140:	72 ee                	jb     80101130 <get_free_fds+0x20>
    }
  }
  release(&ftable.lock);
80101142:	83 ec 0c             	sub    $0xc,%esp
80101145:	68 c0 10 11 80       	push   $0x801110c0
8010114a:	e8 a1 36 00 00       	call   801047f0 <release>
  return counter;
}
8010114f:	89 d8                	mov    %ebx,%eax
80101151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101154:	c9                   	leave  
80101155:	c3                   	ret    
80101156:	8d 76 00             	lea    0x0(%esi),%esi
80101159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101160 <get_unique_inode_fds>:

// TODO:
int
get_unique_inode_fds(void)
{
80101160:	55                   	push   %ebp
  return 0;
}
80101161:	31 c0                	xor    %eax,%eax
{
80101163:	89 e5                	mov    %esp,%ebp
}
80101165:	5d                   	pop    %ebp
80101166:	c3                   	ret    
80101167:	89 f6                	mov    %esi,%esi
80101169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101170 <get_writeable_fds>:

int
get_writeable_fds(void)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101174:	31 db                	xor    %ebx,%ebx
{
80101176:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101179:	68 c0 10 11 80       	push   $0x801110c0
8010117e:	e8 ad 35 00 00       	call   80104730 <acquire>
80101183:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101186:	ba f4 10 11 80       	mov    $0x801110f4,%edx
8010118b:	90                   	nop
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->writable){
      counter++;
80101190:	80 7a 09 01          	cmpb   $0x1,0x9(%edx)
80101194:	83 db ff             	sbb    $0xffffffff,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101197:	83 c2 18             	add    $0x18,%edx
8010119a:	81 fa 54 1a 11 80    	cmp    $0x80111a54,%edx
801011a0:	72 ee                	jb     80101190 <get_writeable_fds+0x20>
    }
  }
  release(&ftable.lock);
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	68 c0 10 11 80       	push   $0x801110c0
801011aa:	e8 41 36 00 00       	call   801047f0 <release>
  return counter;
}
801011af:	89 d8                	mov    %ebx,%eax
801011b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011b4:	c9                   	leave  
801011b5:	c3                   	ret    
801011b6:	8d 76 00             	lea    0x0(%esi),%esi
801011b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011c0 <get_readable_fds>:

int
get_readable_fds(void)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
801011c4:	31 db                	xor    %ebx,%ebx
{
801011c6:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
801011c9:	68 c0 10 11 80       	push   $0x801110c0
801011ce:	e8 5d 35 00 00       	call   80104730 <acquire>
801011d3:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d6:	ba f4 10 11 80       	mov    $0x801110f4,%edx
801011db:	90                   	nop
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->readable){
      counter++;
801011e0:	80 7a 08 01          	cmpb   $0x1,0x8(%edx)
801011e4:	83 db ff             	sbb    $0xffffffff,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e7:	83 c2 18             	add    $0x18,%edx
801011ea:	81 fa 54 1a 11 80    	cmp    $0x80111a54,%edx
801011f0:	72 ee                	jb     801011e0 <get_readable_fds+0x20>
    }
  }
  release(&ftable.lock);
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	68 c0 10 11 80       	push   $0x801110c0
801011fa:	e8 f1 35 00 00       	call   801047f0 <release>
  return counter;
}
801011ff:	89 d8                	mov    %ebx,%eax
80101201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101204:	c9                   	leave  
80101205:	c3                   	ret    
80101206:	8d 76 00             	lea    0x0(%esi),%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <get_total_refs>:

int
get_total_refs(void)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101214:	31 db                	xor    %ebx,%ebx
{
80101216:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101219:	68 c0 10 11 80       	push   $0x801110c0
8010121e:	e8 0d 35 00 00       	call   80104730 <acquire>
80101223:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101226:	ba f4 10 11 80       	mov    $0x801110f4,%edx
8010122b:	90                   	nop
8010122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    counter = counter + f->ref;
80101230:	03 5a 04             	add    0x4(%edx),%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101233:	83 c2 18             	add    $0x18,%edx
80101236:	81 fa 54 1a 11 80    	cmp    $0x80111a54,%edx
8010123c:	72 f2                	jb     80101230 <get_total_refs+0x20>
  }
  release(&ftable.lock);
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 c0 10 11 80       	push   $0x801110c0
80101246:	e8 a5 35 00 00       	call   801047f0 <release>
  return counter;
}
8010124b:	89 d8                	mov    %ebx,%eax
8010124d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101250:	c9                   	leave  
80101251:	c3                   	ret    
80101252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <get_used_fds>:

// TODO: check if pipes also counted
int
get_used_fds(void)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101264:	31 db                	xor    %ebx,%ebx
{
80101266:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101269:	68 c0 10 11 80       	push   $0x801110c0
8010126e:	e8 bd 34 00 00       	call   80104730 <acquire>
80101273:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101276:	ba f4 10 11 80       	mov    $0x801110f4,%edx
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->type == FD_INODE){
      counter++;
80101280:	31 c0                	xor    %eax,%eax
80101282:	83 3a 02             	cmpl   $0x2,(%edx)
80101285:	0f 94 c0             	sete   %al
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101288:	83 c2 18             	add    $0x18,%edx
      counter++;
8010128b:	01 c3                	add    %eax,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010128d:	81 fa 54 1a 11 80    	cmp    $0x80111a54,%edx
80101293:	72 eb                	jb     80101280 <get_used_fds+0x20>
    }
  }
  release(&ftable.lock);
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	68 c0 10 11 80       	push   $0x801110c0
8010129d:	e8 4e 35 00 00       	call   801047f0 <release>
  return counter;
}
801012a2:	89 d8                	mov    %ebx,%eax
801012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012a7:	c9                   	leave  
801012a8:	c3                   	ret    
801012a9:	66 90                	xchg   %ax,%ax
801012ab:	66 90                	xchg   %ax,%ax
801012ad:	66 90                	xchg   %ax,%ax
801012af:	90                   	nop

801012b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012b9:	8b 0d 00 1b 11 80    	mov    0x80111b00,%ecx
{
801012bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012c2:	85 c9                	test   %ecx,%ecx
801012c4:	0f 84 87 00 00 00    	je     80101351 <balloc+0xa1>
801012ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012d4:	83 ec 08             	sub    $0x8,%esp
801012d7:	89 f0                	mov    %esi,%eax
801012d9:	c1 f8 0c             	sar    $0xc,%eax
801012dc:	03 05 18 1b 11 80    	add    0x80111b18,%eax
801012e2:	50                   	push   %eax
801012e3:	ff 75 d8             	pushl  -0x28(%ebp)
801012e6:	e8 e5 ed ff ff       	call   801000d0 <bread>
801012eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ee:	a1 00 1b 11 80       	mov    0x80111b00,%eax
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012f9:	31 c0                	xor    %eax,%eax
801012fb:	eb 2f                	jmp    8010132c <balloc+0x7c>
801012fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101300:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101302:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101305:	bb 01 00 00 00       	mov    $0x1,%ebx
8010130a:	83 e1 07             	and    $0x7,%ecx
8010130d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010130f:	89 c1                	mov    %eax,%ecx
80101311:	c1 f9 03             	sar    $0x3,%ecx
80101314:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101319:	85 df                	test   %ebx,%edi
8010131b:	89 fa                	mov    %edi,%edx
8010131d:	74 41                	je     80101360 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010131f:	83 c0 01             	add    $0x1,%eax
80101322:	83 c6 01             	add    $0x1,%esi
80101325:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010132a:	74 05                	je     80101331 <balloc+0x81>
8010132c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010132f:	77 cf                	ja     80101300 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101331:	83 ec 0c             	sub    $0xc,%esp
80101334:	ff 75 e4             	pushl  -0x1c(%ebp)
80101337:	e8 a4 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010133c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101343:	83 c4 10             	add    $0x10,%esp
80101346:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101349:	39 05 00 1b 11 80    	cmp    %eax,0x80111b00
8010134f:	77 80                	ja     801012d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	68 3f 81 10 80       	push   $0x8010813f
80101359:	e8 32 f0 ff ff       	call   80100390 <panic>
8010135e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101363:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101366:	09 da                	or     %ebx,%edx
80101368:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010136c:	57                   	push   %edi
8010136d:	e8 9e 1d 00 00       	call   80103110 <log_write>
        brelse(bp);
80101372:	89 3c 24             	mov    %edi,(%esp)
80101375:	e8 66 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010137a:	58                   	pop    %eax
8010137b:	5a                   	pop    %edx
8010137c:	56                   	push   %esi
8010137d:	ff 75 d8             	pushl  -0x28(%ebp)
80101380:	e8 4b ed ff ff       	call   801000d0 <bread>
80101385:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101387:	8d 40 5c             	lea    0x5c(%eax),%eax
8010138a:	83 c4 0c             	add    $0xc,%esp
8010138d:	68 00 02 00 00       	push   $0x200
80101392:	6a 00                	push   $0x0
80101394:	50                   	push   %eax
80101395:	e8 a6 34 00 00       	call   80104840 <memset>
  log_write(bp);
8010139a:	89 1c 24             	mov    %ebx,(%esp)
8010139d:	e8 6e 1d 00 00       	call   80103110 <log_write>
  brelse(bp);
801013a2:	89 1c 24             	mov    %ebx,(%esp)
801013a5:	e8 36 ee ff ff       	call   801001e0 <brelse>
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	89 f0                	mov    %esi,%eax
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	bb 54 1b 11 80       	mov    $0x80111b54,%ebx
{
801013cf:	83 ec 28             	sub    $0x28,%esp
801013d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013d5:	68 20 1b 11 80       	push   $0x80111b20
801013da:	e8 51 33 00 00       	call   80104730 <acquire>
801013df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013e5:	eb 17                	jmp    801013fe <iget+0x3e>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801013f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013f6:	81 fb 74 37 11 80    	cmp    $0x80113774,%ebx
801013fc:	73 22                	jae    80101420 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101401:	85 c9                	test   %ecx,%ecx
80101403:	7e 04                	jle    80101409 <iget+0x49>
80101405:	39 3b                	cmp    %edi,(%ebx)
80101407:	74 4f                	je     80101458 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101409:	85 f6                	test   %esi,%esi
8010140b:	75 e3                	jne    801013f0 <iget+0x30>
8010140d:	85 c9                	test   %ecx,%ecx
8010140f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101412:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101418:	81 fb 74 37 11 80    	cmp    $0x80113774,%ebx
8010141e:	72 de                	jb     801013fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101420:	85 f6                	test   %esi,%esi
80101422:	74 5b                	je     8010147f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101424:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101427:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101429:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010142c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101433:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010143a:	68 20 1b 11 80       	push   $0x80111b20
8010143f:	e8 ac 33 00 00       	call   801047f0 <release>

  return ip;
80101444:	83 c4 10             	add    $0x10,%esp
}
80101447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144a:	89 f0                	mov    %esi,%eax
8010144c:	5b                   	pop    %ebx
8010144d:	5e                   	pop    %esi
8010144e:	5f                   	pop    %edi
8010144f:	5d                   	pop    %ebp
80101450:	c3                   	ret    
80101451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101458:	39 53 04             	cmp    %edx,0x4(%ebx)
8010145b:	75 ac                	jne    80101409 <iget+0x49>
      release(&icache.lock);
8010145d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101460:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101463:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101465:	68 20 1b 11 80       	push   $0x80111b20
      ip->ref++;
8010146a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010146d:	e8 7e 33 00 00       	call   801047f0 <release>
      return ip;
80101472:	83 c4 10             	add    $0x10,%esp
}
80101475:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101478:	89 f0                	mov    %esi,%eax
8010147a:	5b                   	pop    %ebx
8010147b:	5e                   	pop    %esi
8010147c:	5f                   	pop    %edi
8010147d:	5d                   	pop    %ebp
8010147e:	c3                   	ret    
    panic("iget: no inodes");
8010147f:	83 ec 0c             	sub    $0xc,%esp
80101482:	68 55 81 10 80       	push   $0x80108155
80101487:	e8 04 ef ff ff       	call   80100390 <panic>
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101490 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	57                   	push   %edi
80101494:	56                   	push   %esi
80101495:	53                   	push   %ebx
80101496:	89 c6                	mov    %eax,%esi
80101498:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010149b:	83 fa 0b             	cmp    $0xb,%edx
8010149e:	77 18                	ja     801014b8 <bmap+0x28>
801014a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801014a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014a6:	85 db                	test   %ebx,%ebx
801014a8:	74 76                	je     80101520 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801014aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ad:	89 d8                	mov    %ebx,%eax
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5f                   	pop    %edi
801014b2:	5d                   	pop    %ebp
801014b3:	c3                   	ret    
801014b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801014b8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801014bb:	83 fb 7f             	cmp    $0x7f,%ebx
801014be:	0f 87 90 00 00 00    	ja     80101554 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801014ca:	8b 00                	mov    (%eax),%eax
801014cc:	85 d2                	test   %edx,%edx
801014ce:	74 70                	je     80101540 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	52                   	push   %edx
801014d4:	50                   	push   %eax
801014d5:	e8 f6 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801014da:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801014de:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801014e1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014e3:	8b 1a                	mov    (%edx),%ebx
801014e5:	85 db                	test   %ebx,%ebx
801014e7:	75 1d                	jne    80101506 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801014e9:	8b 06                	mov    (%esi),%eax
801014eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014ee:	e8 bd fd ff ff       	call   801012b0 <balloc>
801014f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014f6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014f9:	89 c3                	mov    %eax,%ebx
801014fb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014fd:	57                   	push   %edi
801014fe:	e8 0d 1c 00 00       	call   80103110 <log_write>
80101503:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101506:	83 ec 0c             	sub    $0xc,%esp
80101509:	57                   	push   %edi
8010150a:	e8 d1 ec ff ff       	call   801001e0 <brelse>
8010150f:	83 c4 10             	add    $0x10,%esp
}
80101512:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101515:	89 d8                	mov    %ebx,%eax
80101517:	5b                   	pop    %ebx
80101518:	5e                   	pop    %esi
80101519:	5f                   	pop    %edi
8010151a:	5d                   	pop    %ebp
8010151b:	c3                   	ret    
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101520:	8b 00                	mov    (%eax),%eax
80101522:	e8 89 fd ff ff       	call   801012b0 <balloc>
80101527:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010152d:	89 c3                	mov    %eax,%ebx
}
8010152f:	89 d8                	mov    %ebx,%eax
80101531:	5b                   	pop    %ebx
80101532:	5e                   	pop    %esi
80101533:	5f                   	pop    %edi
80101534:	5d                   	pop    %ebp
80101535:	c3                   	ret    
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101540:	e8 6b fd ff ff       	call   801012b0 <balloc>
80101545:	89 c2                	mov    %eax,%edx
80101547:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010154d:	8b 06                	mov    (%esi),%eax
8010154f:	e9 7c ff ff ff       	jmp    801014d0 <bmap+0x40>
  panic("bmap: out of range");
80101554:	83 ec 0c             	sub    $0xc,%esp
80101557:	68 65 81 10 80       	push   $0x80108165
8010155c:	e8 2f ee ff ff       	call   80100390 <panic>
80101561:	eb 0d                	jmp    80101570 <readsb>
80101563:	90                   	nop
80101564:	90                   	nop
80101565:	90                   	nop
80101566:	90                   	nop
80101567:	90                   	nop
80101568:	90                   	nop
80101569:	90                   	nop
8010156a:	90                   	nop
8010156b:	90                   	nop
8010156c:	90                   	nop
8010156d:	90                   	nop
8010156e:	90                   	nop
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	pushl  0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
80101585:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101587:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158a:	83 c4 0c             	add    $0xc,%esp
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 5a 33 00 00       	call   801048f0 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 39 ec ff ff       	jmp    801001e0 <brelse>
801015a7:	89 f6                	mov    %esi,%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015b0 <bfree>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	89 d3                	mov    %edx,%ebx
801015b7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801015b9:	83 ec 08             	sub    $0x8,%esp
801015bc:	68 00 1b 11 80       	push   $0x80111b00
801015c1:	50                   	push   %eax
801015c2:	e8 a9 ff ff ff       	call   80101570 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801015c7:	58                   	pop    %eax
801015c8:	5a                   	pop    %edx
801015c9:	89 da                	mov    %ebx,%edx
801015cb:	c1 ea 0c             	shr    $0xc,%edx
801015ce:	03 15 18 1b 11 80    	add    0x80111b18,%edx
801015d4:	52                   	push   %edx
801015d5:	56                   	push   %esi
801015d6:	e8 f5 ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801015db:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801015dd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801015e0:	ba 01 00 00 00       	mov    $0x1,%edx
801015e5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801015e8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801015ee:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801015f1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801015f3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801015f8:	85 d1                	test   %edx,%ecx
801015fa:	74 25                	je     80101621 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801015fc:	f7 d2                	not    %edx
801015fe:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101600:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101603:	21 ca                	and    %ecx,%edx
80101605:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101609:	56                   	push   %esi
8010160a:	e8 01 1b 00 00       	call   80103110 <log_write>
  brelse(bp);
8010160f:	89 34 24             	mov    %esi,(%esp)
80101612:	e8 c9 eb ff ff       	call   801001e0 <brelse>
}
80101617:	83 c4 10             	add    $0x10,%esp
8010161a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010161d:	5b                   	pop    %ebx
8010161e:	5e                   	pop    %esi
8010161f:	5d                   	pop    %ebp
80101620:	c3                   	ret    
    panic("freeing free block");
80101621:	83 ec 0c             	sub    $0xc,%esp
80101624:	68 78 81 10 80       	push   $0x80108178
80101629:	e8 62 ed ff ff       	call   80100390 <panic>
8010162e:	66 90                	xchg   %ax,%ax

80101630 <iinit>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	bb 60 1b 11 80       	mov    $0x80111b60,%ebx
80101639:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010163c:	68 8b 81 10 80       	push   $0x8010818b
80101641:	68 20 1b 11 80       	push   $0x80111b20
80101646:	e8 a5 2f 00 00       	call   801045f0 <initlock>
8010164b:	83 c4 10             	add    $0x10,%esp
8010164e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 92 81 10 80       	push   $0x80108192
80101658:	53                   	push   %ebx
80101659:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010165f:	e8 5c 2e 00 00       	call   801044c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101664:	83 c4 10             	add    $0x10,%esp
80101667:	81 fb 80 37 11 80    	cmp    $0x80113780,%ebx
8010166d:	75 e1                	jne    80101650 <iinit+0x20>
  readsb(dev, &sb);
8010166f:	83 ec 08             	sub    $0x8,%esp
80101672:	68 00 1b 11 80       	push   $0x80111b00
80101677:	ff 75 08             	pushl  0x8(%ebp)
8010167a:	e8 f1 fe ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010167f:	ff 35 18 1b 11 80    	pushl  0x80111b18
80101685:	ff 35 14 1b 11 80    	pushl  0x80111b14
8010168b:	ff 35 10 1b 11 80    	pushl  0x80111b10
80101691:	ff 35 0c 1b 11 80    	pushl  0x80111b0c
80101697:	ff 35 08 1b 11 80    	pushl  0x80111b08
8010169d:	ff 35 04 1b 11 80    	pushl  0x80111b04
801016a3:	ff 35 00 1b 11 80    	pushl  0x80111b00
801016a9:	68 f8 81 10 80       	push   $0x801081f8
801016ae:	e8 ad ef ff ff       	call   80100660 <cprintf>
}
801016b3:	83 c4 30             	add    $0x30,%esp
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ialloc>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	57                   	push   %edi
801016c4:	56                   	push   %esi
801016c5:	53                   	push   %ebx
801016c6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016c9:	83 3d 08 1b 11 80 01 	cmpl   $0x1,0x80111b08
{
801016d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016d3:	8b 75 08             	mov    0x8(%ebp),%esi
801016d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016d9:	0f 86 91 00 00 00    	jbe    80101770 <ialloc+0xb0>
801016df:	bb 01 00 00 00       	mov    $0x1,%ebx
801016e4:	eb 21                	jmp    80101707 <ialloc+0x47>
801016e6:	8d 76 00             	lea    0x0(%esi),%esi
801016e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801016f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016f3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801016f6:	57                   	push   %edi
801016f7:	e8 e4 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016fc:	83 c4 10             	add    $0x10,%esp
801016ff:	39 1d 08 1b 11 80    	cmp    %ebx,0x80111b08
80101705:	76 69                	jbe    80101770 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101707:	89 d8                	mov    %ebx,%eax
80101709:	83 ec 08             	sub    $0x8,%esp
8010170c:	c1 e8 03             	shr    $0x3,%eax
8010170f:	03 05 14 1b 11 80    	add    0x80111b14,%eax
80101715:	50                   	push   %eax
80101716:	56                   	push   %esi
80101717:	e8 b4 e9 ff ff       	call   801000d0 <bread>
8010171c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010171e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101720:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101723:	83 e0 07             	and    $0x7,%eax
80101726:	c1 e0 06             	shl    $0x6,%eax
80101729:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010172d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101731:	75 bd                	jne    801016f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101733:	83 ec 04             	sub    $0x4,%esp
80101736:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101739:	6a 40                	push   $0x40
8010173b:	6a 00                	push   $0x0
8010173d:	51                   	push   %ecx
8010173e:	e8 fd 30 00 00       	call   80104840 <memset>
      dip->type = type;
80101743:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101747:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010174a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010174d:	89 3c 24             	mov    %edi,(%esp)
80101750:	e8 bb 19 00 00       	call   80103110 <log_write>
      brelse(bp);
80101755:	89 3c 24             	mov    %edi,(%esp)
80101758:	e8 83 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010175d:	83 c4 10             	add    $0x10,%esp
}
80101760:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101763:	89 da                	mov    %ebx,%edx
80101765:	89 f0                	mov    %esi,%eax
}
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5f                   	pop    %edi
8010176a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010176b:	e9 50 fc ff ff       	jmp    801013c0 <iget>
  panic("ialloc: no inodes");
80101770:	83 ec 0c             	sub    $0xc,%esp
80101773:	68 98 81 10 80       	push   $0x80108198
80101778:	e8 13 ec ff ff       	call   80100390 <panic>
8010177d:	8d 76 00             	lea    0x0(%esi),%esi

80101780 <iupdate>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101788:	83 ec 08             	sub    $0x8,%esp
8010178b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010178e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101791:	c1 e8 03             	shr    $0x3,%eax
80101794:	03 05 14 1b 11 80    	add    0x80111b14,%eax
8010179a:	50                   	push   %eax
8010179b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010179e:	e8 2d e9 ff ff       	call   801000d0 <bread>
801017a3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017a5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801017a8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ac:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017af:	83 e0 07             	and    $0x7,%eax
801017b2:	c1 e0 06             	shl    $0x6,%eax
801017b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017c0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017dd:	6a 34                	push   $0x34
801017df:	53                   	push   %ebx
801017e0:	50                   	push   %eax
801017e1:	e8 0a 31 00 00       	call   801048f0 <memmove>
  log_write(bp);
801017e6:	89 34 24             	mov    %esi,(%esp)
801017e9:	e8 22 19 00 00       	call   80103110 <log_write>
  brelse(bp);
801017ee:	89 75 08             	mov    %esi,0x8(%ebp)
801017f1:	83 c4 10             	add    $0x10,%esp
}
801017f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5d                   	pop    %ebp
  brelse(bp);
801017fa:	e9 e1 e9 ff ff       	jmp    801001e0 <brelse>
801017ff:	90                   	nop

80101800 <idup>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	53                   	push   %ebx
80101804:	83 ec 10             	sub    $0x10,%esp
80101807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010180a:	68 20 1b 11 80       	push   $0x80111b20
8010180f:	e8 1c 2f 00 00       	call   80104730 <acquire>
  ip->ref++;
80101814:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101818:	c7 04 24 20 1b 11 80 	movl   $0x80111b20,(%esp)
8010181f:	e8 cc 2f 00 00       	call   801047f0 <release>
}
80101824:	89 d8                	mov    %ebx,%eax
80101826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101829:	c9                   	leave  
8010182a:	c3                   	ret    
8010182b:	90                   	nop
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101830 <ilock>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101838:	85 db                	test   %ebx,%ebx
8010183a:	0f 84 b7 00 00 00    	je     801018f7 <ilock+0xc7>
80101840:	8b 53 08             	mov    0x8(%ebx),%edx
80101843:	85 d2                	test   %edx,%edx
80101845:	0f 8e ac 00 00 00    	jle    801018f7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010184b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010184e:	83 ec 0c             	sub    $0xc,%esp
80101851:	50                   	push   %eax
80101852:	e8 a9 2c 00 00       	call   80104500 <acquiresleep>
  if(ip->valid == 0){
80101857:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010185a:	83 c4 10             	add    $0x10,%esp
8010185d:	85 c0                	test   %eax,%eax
8010185f:	74 0f                	je     80101870 <ilock+0x40>
}
80101861:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101864:	5b                   	pop    %ebx
80101865:	5e                   	pop    %esi
80101866:	5d                   	pop    %ebp
80101867:	c3                   	ret    
80101868:	90                   	nop
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101870:	8b 43 04             	mov    0x4(%ebx),%eax
80101873:	83 ec 08             	sub    $0x8,%esp
80101876:	c1 e8 03             	shr    $0x3,%eax
80101879:	03 05 14 1b 11 80    	add    0x80111b14,%eax
8010187f:	50                   	push   %eax
80101880:	ff 33                	pushl  (%ebx)
80101882:	e8 49 e8 ff ff       	call   801000d0 <bread>
80101887:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101889:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010188c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010188f:	83 e0 07             	and    $0x7,%eax
80101892:	c1 e0 06             	shl    $0x6,%eax
80101895:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101899:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010189c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010189f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018be:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018c1:	6a 34                	push   $0x34
801018c3:	50                   	push   %eax
801018c4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018c7:	50                   	push   %eax
801018c8:	e8 23 30 00 00       	call   801048f0 <memmove>
    brelse(bp);
801018cd:	89 34 24             	mov    %esi,(%esp)
801018d0:	e8 0b e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801018d5:	83 c4 10             	add    $0x10,%esp
801018d8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018dd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018e4:	0f 85 77 ff ff ff    	jne    80101861 <ilock+0x31>
      panic("ilock: no type");
801018ea:	83 ec 0c             	sub    $0xc,%esp
801018ed:	68 b0 81 10 80       	push   $0x801081b0
801018f2:	e8 99 ea ff ff       	call   80100390 <panic>
    panic("ilock");
801018f7:	83 ec 0c             	sub    $0xc,%esp
801018fa:	68 aa 81 10 80       	push   $0x801081aa
801018ff:	e8 8c ea ff ff       	call   80100390 <panic>
80101904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010190a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101910 <iunlock>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	56                   	push   %esi
80101914:	53                   	push   %ebx
80101915:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101918:	85 db                	test   %ebx,%ebx
8010191a:	74 28                	je     80101944 <iunlock+0x34>
8010191c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010191f:	83 ec 0c             	sub    $0xc,%esp
80101922:	56                   	push   %esi
80101923:	e8 78 2c 00 00       	call   801045a0 <holdingsleep>
80101928:	83 c4 10             	add    $0x10,%esp
8010192b:	85 c0                	test   %eax,%eax
8010192d:	74 15                	je     80101944 <iunlock+0x34>
8010192f:	8b 43 08             	mov    0x8(%ebx),%eax
80101932:	85 c0                	test   %eax,%eax
80101934:	7e 0e                	jle    80101944 <iunlock+0x34>
  releasesleep(&ip->lock);
80101936:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101939:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010193c:	5b                   	pop    %ebx
8010193d:	5e                   	pop    %esi
8010193e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010193f:	e9 1c 2c 00 00       	jmp    80104560 <releasesleep>
    panic("iunlock");
80101944:	83 ec 0c             	sub    $0xc,%esp
80101947:	68 bf 81 10 80       	push   $0x801081bf
8010194c:	e8 3f ea ff ff       	call   80100390 <panic>
80101951:	eb 0d                	jmp    80101960 <iput>
80101953:	90                   	nop
80101954:	90                   	nop
80101955:	90                   	nop
80101956:	90                   	nop
80101957:	90                   	nop
80101958:	90                   	nop
80101959:	90                   	nop
8010195a:	90                   	nop
8010195b:	90                   	nop
8010195c:	90                   	nop
8010195d:	90                   	nop
8010195e:	90                   	nop
8010195f:	90                   	nop

80101960 <iput>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 28             	sub    $0x28,%esp
80101969:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010196c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010196f:	57                   	push   %edi
80101970:	e8 8b 2b 00 00       	call   80104500 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101975:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	85 d2                	test   %edx,%edx
8010197d:	74 07                	je     80101986 <iput+0x26>
8010197f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101984:	74 32                	je     801019b8 <iput+0x58>
  releasesleep(&ip->lock);
80101986:	83 ec 0c             	sub    $0xc,%esp
80101989:	57                   	push   %edi
8010198a:	e8 d1 2b 00 00       	call   80104560 <releasesleep>
  acquire(&icache.lock);
8010198f:	c7 04 24 20 1b 11 80 	movl   $0x80111b20,(%esp)
80101996:	e8 95 2d 00 00       	call   80104730 <acquire>
  ip->ref--;
8010199b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010199f:	83 c4 10             	add    $0x10,%esp
801019a2:	c7 45 08 20 1b 11 80 	movl   $0x80111b20,0x8(%ebp)
}
801019a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ac:	5b                   	pop    %ebx
801019ad:	5e                   	pop    %esi
801019ae:	5f                   	pop    %edi
801019af:	5d                   	pop    %ebp
  release(&icache.lock);
801019b0:	e9 3b 2e 00 00       	jmp    801047f0 <release>
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019b8:	83 ec 0c             	sub    $0xc,%esp
801019bb:	68 20 1b 11 80       	push   $0x80111b20
801019c0:	e8 6b 2d 00 00       	call   80104730 <acquire>
    int r = ip->ref;
801019c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019c8:	c7 04 24 20 1b 11 80 	movl   $0x80111b20,(%esp)
801019cf:	e8 1c 2e 00 00       	call   801047f0 <release>
    if(r == 1){
801019d4:	83 c4 10             	add    $0x10,%esp
801019d7:	83 fe 01             	cmp    $0x1,%esi
801019da:	75 aa                	jne    80101986 <iput+0x26>
801019dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019e8:	89 cf                	mov    %ecx,%edi
801019ea:	eb 0b                	jmp    801019f7 <iput+0x97>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019f0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019f3:	39 fe                	cmp    %edi,%esi
801019f5:	74 19                	je     80101a10 <iput+0xb0>
    if(ip->addrs[i]){
801019f7:	8b 16                	mov    (%esi),%edx
801019f9:	85 d2                	test   %edx,%edx
801019fb:	74 f3                	je     801019f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019fd:	8b 03                	mov    (%ebx),%eax
801019ff:	e8 ac fb ff ff       	call   801015b0 <bfree>
      ip->addrs[i] = 0;
80101a04:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a0a:	eb e4                	jmp    801019f0 <iput+0x90>
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a10:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a19:	85 c0                	test   %eax,%eax
80101a1b:	75 33                	jne    80101a50 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a1d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a20:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a27:	53                   	push   %ebx
80101a28:	e8 53 fd ff ff       	call   80101780 <iupdate>
      ip->type = 0;
80101a2d:	31 c0                	xor    %eax,%eax
80101a2f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a33:	89 1c 24             	mov    %ebx,(%esp)
80101a36:	e8 45 fd ff ff       	call   80101780 <iupdate>
      ip->valid = 0;
80101a3b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	e9 3c ff ff ff       	jmp    80101986 <iput+0x26>
80101a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a50:	83 ec 08             	sub    $0x8,%esp
80101a53:	50                   	push   %eax
80101a54:	ff 33                	pushl  (%ebx)
80101a56:	e8 75 e6 ff ff       	call   801000d0 <bread>
80101a5b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a61:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a67:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a6a:	83 c4 10             	add    $0x10,%esp
80101a6d:	89 cf                	mov    %ecx,%edi
80101a6f:	eb 0e                	jmp    80101a7f <iput+0x11f>
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a78:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101a7b:	39 fe                	cmp    %edi,%esi
80101a7d:	74 0f                	je     80101a8e <iput+0x12e>
      if(a[j])
80101a7f:	8b 16                	mov    (%esi),%edx
80101a81:	85 d2                	test   %edx,%edx
80101a83:	74 f3                	je     80101a78 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a85:	8b 03                	mov    (%ebx),%eax
80101a87:	e8 24 fb ff ff       	call   801015b0 <bfree>
80101a8c:	eb ea                	jmp    80101a78 <iput+0x118>
    brelse(bp);
80101a8e:	83 ec 0c             	sub    $0xc,%esp
80101a91:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a94:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a97:	e8 44 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a9c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101aa2:	8b 03                	mov    (%ebx),%eax
80101aa4:	e8 07 fb ff ff       	call   801015b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101aa9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ab0:	00 00 00 
80101ab3:	83 c4 10             	add    $0x10,%esp
80101ab6:	e9 62 ff ff ff       	jmp    80101a1d <iput+0xbd>
80101abb:	90                   	nop
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ac0 <iunlockput>:
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	53                   	push   %ebx
80101ac4:	83 ec 10             	sub    $0x10,%esp
80101ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aca:	53                   	push   %ebx
80101acb:	e8 40 fe ff ff       	call   80101910 <iunlock>
  iput(ip);
80101ad0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ad3:	83 c4 10             	add    $0x10,%esp
}
80101ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ad9:	c9                   	leave  
  iput(ip);
80101ada:	e9 81 fe ff ff       	jmp    80101960 <iput>
80101adf:	90                   	nop

80101ae0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ae9:	8b 0a                	mov    (%edx),%ecx
80101aeb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101aee:	8b 4a 04             	mov    0x4(%edx),%ecx
80101af1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101af4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101af8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101afb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b03:	8b 52 58             	mov    0x58(%edx),%edx
80101b06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b09:	5d                   	pop    %ebp
80101b0a:	c3                   	ret    
80101b0b:	90                   	nop
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b27:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 a7 00 00 00    	je     80101be0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, off, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	8b 40 58             	mov    0x58(%eax),%eax
80101b3f:	39 c6                	cmp    %eax,%esi
80101b41:	0f 87 b9 00 00 00    	ja     80101c00 <readi+0xf0>
80101b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b4a:	89 f9                	mov    %edi,%ecx
80101b4c:	01 f1                	add    %esi,%ecx
80101b4e:	0f 82 ac 00 00 00    	jb     80101c00 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b54:	89 c2                	mov    %eax,%edx
80101b56:	29 f2                	sub    %esi,%edx
80101b58:	39 c8                	cmp    %ecx,%eax
80101b5a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b5d:	31 ff                	xor    %edi,%edi
80101b5f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b64:	74 6c                	je     80101bd2 <readi+0xc2>
80101b66:	8d 76 00             	lea    0x0(%esi),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 d8                	mov    %ebx,%eax
80101b7a:	e8 11 f9 ff ff       	call   80101490 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 33                	pushl  (%ebx)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b8d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8f:	89 f0                	mov    %esi,%eax
80101b91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b96:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b9b:	83 c4 0c             	add    $0xc,%esp
80101b9e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ba4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	29 fb                	sub    %edi,%ebx
80101ba9:	39 d9                	cmp    %ebx,%ecx
80101bab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bae:	53                   	push   %ebx
80101baf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb7:	e8 34 2d 00 00       	call   801048f0 <memmove>
    brelse(bp);
80101bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bbf:	89 14 24             	mov    %edx,(%esp)
80101bc2:	e8 19 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bd0:	77 9e                	ja     80101b70 <readi+0x60>
  }
  return n;
80101bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd8:	5b                   	pop    %ebx
80101bd9:	5e                   	pop    %esi
80101bda:	5f                   	pop    %edi
80101bdb:	5d                   	pop    %ebp
80101bdc:	c3                   	ret    
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 16                	ja     80101c00 <readi+0xf0>
80101bea:	c1 e0 04             	shl    $0x4,%eax
80101bed:	8b 80 68 1a 11 80    	mov    -0x7feee598(%eax),%eax
80101bf3:	85 c0                	test   %eax,%eax
80101bf5:	74 09                	je     80101c00 <readi+0xf0>
}
80101bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfa:	5b                   	pop    %ebx
80101bfb:	5e                   	pop    %esi
80101bfc:	5f                   	pop    %edi
80101bfd:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, off, n);
80101bfe:	ff e0                	jmp    *%eax
      return -1;
80101c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c05:	eb ce                	jmp    80101bd5 <readi+0xc5>
80101c07:	89 f6                	mov    %esi,%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 1c             	sub    $0x1c,%esp
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c33:	0f 84 b7 00 00 00    	je     80101cf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c3f:	0f 82 eb 00 00 00    	jb     80101d30 <writei+0x120>
80101c45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c48:	31 d2                	xor    %edx,%edx
80101c4a:	89 f8                	mov    %edi,%eax
80101c4c:	01 f0                	add    %esi,%eax
80101c4e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c51:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c56:	0f 87 d4 00 00 00    	ja     80101d30 <writei+0x120>
80101c5c:	85 d2                	test   %edx,%edx
80101c5e:	0f 85 cc 00 00 00    	jne    80101d30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c64:	85 ff                	test   %edi,%edi
80101c66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c6d:	74 72                	je     80101ce1 <writei+0xd1>
80101c6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c73:	89 f2                	mov    %esi,%edx
80101c75:	c1 ea 09             	shr    $0x9,%edx
80101c78:	89 f8                	mov    %edi,%eax
80101c7a:	e8 11 f8 ff ff       	call   80101490 <bmap>
80101c7f:	83 ec 08             	sub    $0x8,%esp
80101c82:	50                   	push   %eax
80101c83:	ff 37                	pushl  (%edi)
80101c85:	e8 46 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c8d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c92:	89 f0                	mov    %esi,%eax
80101c94:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c99:	83 c4 0c             	add    $0xc,%esp
80101c9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ca1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca7:	39 d9                	cmp    %ebx,%ecx
80101ca9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cac:	53                   	push   %ebx
80101cad:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cb0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cb2:	50                   	push   %eax
80101cb3:	e8 38 2c 00 00       	call   801048f0 <memmove>
    log_write(bp);
80101cb8:	89 3c 24             	mov    %edi,(%esp)
80101cbb:	e8 50 14 00 00       	call   80103110 <log_write>
    brelse(bp);
80101cc0:	89 3c 24             	mov    %edi,(%esp)
80101cc3:	e8 18 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ccb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cd7:	77 97                	ja     80101c70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cdf:	77 37                	ja     80101d18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce7:	5b                   	pop    %ebx
80101ce8:	5e                   	pop    %esi
80101ce9:	5f                   	pop    %edi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 36                	ja     80101d30 <writei+0x120>
80101cfa:	c1 e0 04             	shl    $0x4,%eax
80101cfd:	8b 80 6c 1a 11 80    	mov    -0x7feee594(%eax),%eax
80101d03:	85 c0                	test   %eax,%eax
80101d05:	74 29                	je     80101d30 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d07:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0d:	5b                   	pop    %ebx
80101d0e:	5e                   	pop    %esi
80101d0f:	5f                   	pop    %edi
80101d10:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d11:	ff e0                	jmp    *%eax
80101d13:	90                   	nop
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d21:	50                   	push   %eax
80101d22:	e8 59 fa ff ff       	call   80101780 <iupdate>
80101d27:	83 c4 10             	add    $0x10,%esp
80101d2a:	eb b5                	jmp    80101ce1 <writei+0xd1>
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d35:	eb ad                	jmp    80101ce4 <writei+0xd4>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d46:	6a 0e                	push   $0xe
80101d48:	ff 75 0c             	pushl  0xc(%ebp)
80101d4b:	ff 75 08             	pushl  0x8(%ebp)
80101d4e:	e8 0d 2c 00 00       	call   80104960 <strncmp>
}
80101d53:	c9                   	leave  
80101d54:	c3                   	ret    
80101d55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 2c             	sub    $0x2c,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;
  struct inode *ip;

  if(dp->type != T_DIR && !IS_DEV_DIR(dp))
80101d6c:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80101d70:	66 83 f8 01          	cmp    $0x1,%ax
80101d74:	74 30                	je     80101da6 <dirlookup+0x46>
80101d76:	66 83 f8 03          	cmp    $0x3,%ax
80101d7a:	0f 85 d0 00 00 00    	jne    80101e50 <dirlookup+0xf0>
80101d80:	0f bf 43 52          	movswl 0x52(%ebx),%eax
80101d84:	c1 e0 04             	shl    $0x4,%eax
80101d87:	8b 80 60 1a 11 80    	mov    -0x7feee5a0(%eax),%eax
80101d8d:	85 c0                	test   %eax,%eax
80101d8f:	0f 84 bb 00 00 00    	je     80101e50 <dirlookup+0xf0>
80101d95:	83 ec 0c             	sub    $0xc,%esp
80101d98:	53                   	push   %ebx
80101d99:	ff d0                	call   *%eax
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	85 c0                	test   %eax,%eax
80101da0:	0f 84 aa 00 00 00    	je     80101e50 <dirlookup+0xf0>
{
80101da6:	31 ff                	xor    %edi,%edi
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size || dp->type == T_DEV ; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101da8:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dab:	eb 25                	jmp    80101dd2 <dirlookup+0x72>
80101dad:	8d 76 00             	lea    0x0(%esi),%esi
      if (dp->type == T_DEV)
        return 0;
      panic("dirlookup read");
    }
    if(de.inum == 0)
80101db0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101db5:	74 18                	je     80101dcf <dirlookup+0x6f>
  return strncmp(s, t, DIRSIZ);
80101db7:	8d 45 da             	lea    -0x26(%ebp),%eax
80101dba:	83 ec 04             	sub    $0x4,%esp
80101dbd:	6a 0e                	push   $0xe
80101dbf:	50                   	push   %eax
80101dc0:	ff 75 0c             	pushl  0xc(%ebp)
80101dc3:	e8 98 2b 00 00       	call   80104960 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101dc8:	83 c4 10             	add    $0x10,%esp
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	74 39                	je     80101e08 <dirlookup+0xa8>
  for(off = 0; off < dp->size || dp->type == T_DEV ; off += sizeof(de)){
80101dcf:	83 c7 10             	add    $0x10,%edi
80101dd2:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101dd5:	77 07                	ja     80101dde <dirlookup+0x7e>
80101dd7:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101ddc:	75 19                	jne    80101df7 <dirlookup+0x97>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101dde:	6a 10                	push   $0x10
80101de0:	57                   	push   %edi
80101de1:	56                   	push   %esi
80101de2:	53                   	push   %ebx
80101de3:	e8 28 fd ff ff       	call   80101b10 <readi>
80101de8:	83 c4 10             	add    $0x10,%esp
80101deb:	83 f8 10             	cmp    $0x10,%eax
80101dee:	74 c0                	je     80101db0 <dirlookup+0x50>
      if (dp->type == T_DEV)
80101df0:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101df5:	75 66                	jne    80101e5d <dirlookup+0xfd>
        return 0;
80101df7:	31 c0                	xor    %eax,%eax
      return ip;
    }
  }

  return 0;
}
80101df9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfc:	5b                   	pop    %ebx
80101dfd:	5e                   	pop    %esi
80101dfe:	5f                   	pop    %edi
80101dff:	5d                   	pop    %ebp
80101e00:	c3                   	ret    
80101e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101e08:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101e0b:	85 c9                	test   %ecx,%ecx
80101e0d:	74 05                	je     80101e14 <dirlookup+0xb4>
        *poff = off;
80101e0f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e12:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e14:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      ip = iget(dp->dev, inum);
80101e18:	8b 03                	mov    (%ebx),%eax
80101e1a:	e8 a1 f5 ff ff       	call   801013c0 <iget>
      if (ip->valid == 0 && dp->type == T_DEV && devsw[dp->major].iread) {
80101e1f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e22:	85 d2                	test   %edx,%edx
80101e24:	75 d3                	jne    80101df9 <dirlookup+0x99>
80101e26:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101e2b:	75 cc                	jne    80101df9 <dirlookup+0x99>
80101e2d:	0f bf 53 52          	movswl 0x52(%ebx),%edx
80101e31:	c1 e2 04             	shl    $0x4,%edx
80101e34:	8b 92 64 1a 11 80    	mov    -0x7feee59c(%edx),%edx
80101e3a:	85 d2                	test   %edx,%edx
80101e3c:	74 bb                	je     80101df9 <dirlookup+0x99>
        devsw[dp->major].iread(dp, ip);
80101e3e:	83 ec 08             	sub    $0x8,%esp
80101e41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101e44:	50                   	push   %eax
80101e45:	53                   	push   %ebx
80101e46:	ff d2                	call   *%edx
80101e48:	83 c4 10             	add    $0x10,%esp
80101e4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101e4e:	eb a9                	jmp    80101df9 <dirlookup+0x99>
    panic("dirlookup not DIR");
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	68 c7 81 10 80       	push   $0x801081c7
80101e58:	e8 33 e5 ff ff       	call   80100390 <panic>
      panic("dirlookup read");
80101e5d:	83 ec 0c             	sub    $0xc,%esp
80101e60:	68 d9 81 10 80       	push   $0x801081d9
80101e65:	e8 26 e5 ff ff       	call   80100390 <panic>
80101e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	89 cf                	mov    %ecx,%edi
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e83:	0f 84 97 01 00 00    	je     80102020 <namex+0x1b0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e89:	e8 02 1d 00 00       	call   80103b90 <myproc>
  acquire(&icache.lock);
80101e8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e94:	68 20 1b 11 80       	push   $0x80111b20
80101e99:	e8 92 28 00 00       	call   80104730 <acquire>
  ip->ref++;
80101e9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ea2:	c7 04 24 20 1b 11 80 	movl   $0x80111b20,(%esp)
80101ea9:	e8 42 29 00 00       	call   801047f0 <release>
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	eb 08                	jmp    80101ebb <namex+0x4b>
80101eb3:	90                   	nop
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	0f b6 03             	movzbl (%ebx),%eax
80101ebe:	3c 2f                	cmp    $0x2f,%al
80101ec0:	74 f6                	je     80101eb8 <namex+0x48>
  if(*path == 0)
80101ec2:	84 c0                	test   %al,%al
80101ec4:	0f 84 1e 01 00 00    	je     80101fe8 <namex+0x178>
  while(*path != '/' && *path != 0)
80101eca:	0f b6 03             	movzbl (%ebx),%eax
80101ecd:	3c 2f                	cmp    $0x2f,%al
80101ecf:	0f 84 e3 00 00 00    	je     80101fb8 <namex+0x148>
80101ed5:	84 c0                	test   %al,%al
80101ed7:	89 da                	mov    %ebx,%edx
80101ed9:	75 09                	jne    80101ee4 <namex+0x74>
80101edb:	e9 d8 00 00 00       	jmp    80101fb8 <namex+0x148>
80101ee0:	84 c0                	test   %al,%al
80101ee2:	74 0a                	je     80101eee <namex+0x7e>
    path++;
80101ee4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ee7:	0f b6 02             	movzbl (%edx),%eax
80101eea:	3c 2f                	cmp    $0x2f,%al
80101eec:	75 f2                	jne    80101ee0 <namex+0x70>
80101eee:	89 d1                	mov    %edx,%ecx
80101ef0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ef2:	83 f9 0d             	cmp    $0xd,%ecx
80101ef5:	0f 8e c1 00 00 00    	jle    80101fbc <namex+0x14c>
    memmove(name, s, DIRSIZ);
80101efb:	83 ec 04             	sub    $0x4,%esp
80101efe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f01:	6a 0e                	push   $0xe
80101f03:	53                   	push   %ebx
80101f04:	57                   	push   %edi
80101f05:	e8 e6 29 00 00       	call   801048f0 <memmove>
    path++;
80101f0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101f0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101f10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101f12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f15:	75 11                	jne    80101f28 <namex+0xb8>
80101f17:	89 f6                	mov    %esi,%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f26:	74 f8                	je     80101f20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	56                   	push   %esi
80101f2c:	e8 ff f8 ff ff       	call   80101830 <ilock>
    if(ip->type != T_DIR && !IS_DEV_DIR(ip)){
80101f31:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80101f35:	83 c4 10             	add    $0x10,%esp
80101f38:	66 83 f8 01          	cmp    $0x1,%ax
80101f3c:	74 30                	je     80101f6e <namex+0xfe>
80101f3e:	66 83 f8 03          	cmp    $0x3,%ax
80101f42:	0f 85 b8 00 00 00    	jne    80102000 <namex+0x190>
80101f48:	0f bf 46 52          	movswl 0x52(%esi),%eax
80101f4c:	c1 e0 04             	shl    $0x4,%eax
80101f4f:	8b 80 60 1a 11 80    	mov    -0x7feee5a0(%eax),%eax
80101f55:	85 c0                	test   %eax,%eax
80101f57:	0f 84 a3 00 00 00    	je     80102000 <namex+0x190>
80101f5d:	83 ec 0c             	sub    $0xc,%esp
80101f60:	56                   	push   %esi
80101f61:	ff d0                	call   *%eax
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	85 c0                	test   %eax,%eax
80101f68:	0f 84 92 00 00 00    	je     80102000 <namex+0x190>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f71:	85 d2                	test   %edx,%edx
80101f73:	74 09                	je     80101f7e <namex+0x10e>
80101f75:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f78:	0f 84 b8 00 00 00    	je     80102036 <namex+0x1c6>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7e:	83 ec 04             	sub    $0x4,%esp
80101f81:	6a 00                	push   $0x0
80101f83:	57                   	push   %edi
80101f84:	56                   	push   %esi
80101f85:	e8 d6 fd ff ff       	call   80101d60 <dirlookup>
80101f8a:	83 c4 10             	add    $0x10,%esp
80101f8d:	85 c0                	test   %eax,%eax
80101f8f:	74 6f                	je     80102000 <namex+0x190>
  iunlock(ip);
80101f91:	83 ec 0c             	sub    $0xc,%esp
80101f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f97:	56                   	push   %esi
80101f98:	e8 73 f9 ff ff       	call   80101910 <iunlock>
  iput(ip);
80101f9d:	89 34 24             	mov    %esi,(%esp)
80101fa0:	e8 bb f9 ff ff       	call   80101960 <iput>
80101fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	89 c6                	mov    %eax,%esi
80101fad:	e9 09 ff ff ff       	jmp    80101ebb <namex+0x4b>
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101fb8:	89 da                	mov    %ebx,%edx
80101fba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101fbc:	83 ec 04             	sub    $0x4,%esp
80101fbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101fc5:	51                   	push   %ecx
80101fc6:	53                   	push   %ebx
80101fc7:	57                   	push   %edi
80101fc8:	e8 23 29 00 00       	call   801048f0 <memmove>
    name[len] = 0;
80101fcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fd3:	83 c4 10             	add    $0x10,%esp
80101fd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101fda:	89 d3                	mov    %edx,%ebx
80101fdc:	e9 31 ff ff ff       	jmp    80101f12 <namex+0xa2>
80101fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101feb:	85 c0                	test   %eax,%eax
80101fed:	75 5d                	jne    8010204c <namex+0x1dc>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff2:	89 f0                	mov    %esi,%eax
80101ff4:	5b                   	pop    %ebx
80101ff5:	5e                   	pop    %esi
80101ff6:	5f                   	pop    %edi
80101ff7:	5d                   	pop    %ebp
80101ff8:	c3                   	ret    
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102000:	83 ec 0c             	sub    $0xc,%esp
80102003:	56                   	push   %esi
80102004:	e8 07 f9 ff ff       	call   80101910 <iunlock>
  iput(ip);
80102009:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010200c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010200e:	e8 4d f9 ff ff       	call   80101960 <iput>
      return 0;
80102013:	83 c4 10             	add    $0x10,%esp
}
80102016:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102019:	89 f0                	mov    %esi,%eax
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5f                   	pop    %edi
8010201e:	5d                   	pop    %ebp
8010201f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102020:	ba 01 00 00 00       	mov    $0x1,%edx
80102025:	b8 01 00 00 00       	mov    $0x1,%eax
8010202a:	e8 91 f3 ff ff       	call   801013c0 <iget>
8010202f:	89 c6                	mov    %eax,%esi
80102031:	e9 85 fe ff ff       	jmp    80101ebb <namex+0x4b>
      iunlock(ip);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	56                   	push   %esi
8010203a:	e8 d1 f8 ff ff       	call   80101910 <iunlock>
      return ip;
8010203f:	83 c4 10             	add    $0x10,%esp
}
80102042:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102045:	89 f0                	mov    %esi,%eax
80102047:	5b                   	pop    %ebx
80102048:	5e                   	pop    %esi
80102049:	5f                   	pop    %edi
8010204a:	5d                   	pop    %ebp
8010204b:	c3                   	ret    
    iput(ip);
8010204c:	83 ec 0c             	sub    $0xc,%esp
8010204f:	56                   	push   %esi
    return 0;
80102050:	31 f6                	xor    %esi,%esi
    iput(ip);
80102052:	e8 09 f9 ff ff       	call   80101960 <iput>
    return 0;
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	eb 93                	jmp    80101fef <namex+0x17f>
8010205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102060 <dirlink>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 20             	sub    $0x20,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010206c:	6a 00                	push   $0x0
8010206e:	ff 75 0c             	pushl  0xc(%ebp)
80102071:	53                   	push   %ebx
80102072:	e8 e9 fc ff ff       	call   80101d60 <dirlookup>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	75 67                	jne    801020e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010207e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102081:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102084:	85 ff                	test   %edi,%edi
80102086:	74 29                	je     801020b1 <dirlink+0x51>
80102088:	31 ff                	xor    %edi,%edi
8010208a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010208d:	eb 09                	jmp    80102098 <dirlink+0x38>
8010208f:	90                   	nop
80102090:	83 c7 10             	add    $0x10,%edi
80102093:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102096:	73 19                	jae    801020b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102098:	6a 10                	push   $0x10
8010209a:	57                   	push   %edi
8010209b:	56                   	push   %esi
8010209c:	53                   	push   %ebx
8010209d:	e8 6e fa ff ff       	call   80101b10 <readi>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	83 f8 10             	cmp    $0x10,%eax
801020a8:	75 4e                	jne    801020f8 <dirlink+0x98>
    if(de.inum == 0)
801020aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020af:	75 df                	jne    80102090 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020b1:	8d 45 da             	lea    -0x26(%ebp),%eax
801020b4:	83 ec 04             	sub    $0x4,%esp
801020b7:	6a 0e                	push   $0xe
801020b9:	ff 75 0c             	pushl  0xc(%ebp)
801020bc:	50                   	push   %eax
801020bd:	e8 fe 28 00 00       	call   801049c0 <strncpy>
  de.inum = inum;
801020c2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c5:	6a 10                	push   $0x10
801020c7:	57                   	push   %edi
801020c8:	56                   	push   %esi
801020c9:	53                   	push   %ebx
  de.inum = inum;
801020ca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ce:	e8 3d fb ff ff       	call   80101c10 <writei>
801020d3:	83 c4 20             	add    $0x20,%esp
801020d6:	83 f8 10             	cmp    $0x10,%eax
801020d9:	75 2a                	jne    80102105 <dirlink+0xa5>
  return 0;
801020db:	31 c0                	xor    %eax,%eax
}
801020dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret    
    iput(ip);
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	50                   	push   %eax
801020e9:	e8 72 f8 ff ff       	call   80101960 <iput>
    return -1;
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f6:	eb e5                	jmp    801020dd <dirlink+0x7d>
      panic("dirlink read");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 e8 81 10 80       	push   $0x801081e8
80102100:	e8 8b e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 fe 87 10 80       	push   $0x801087fe
8010210d:	e8 7e e2 ff ff       	call   80100390 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <namei>:

struct inode*
namei(char *path)
{
80102120:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102121:	31 d2                	xor    %edx,%edx
{
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010212e:	e8 3d fd ff ff       	call   80101e70 <namex>
}
80102133:	c9                   	leave  
80102134:	c3                   	ret    
80102135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102140 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102140:	55                   	push   %ebp
  return namex(path, 1, name);
80102141:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102146:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010214e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010214f:	e9 1c fd ff ff       	jmp    80101e70 <namex>
80102154:	66 90                	xchg   %ax,%ax
80102156:	66 90                	xchg   %ax,%ax
80102158:	66 90                	xchg   %ax,%ax
8010215a:	66 90                	xchg   %ax,%ax
8010215c:	66 90                	xchg   %ax,%ax
8010215e:	66 90                	xchg   %ax,%ax

80102160 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102169:	85 c0                	test   %eax,%eax
8010216b:	0f 84 b4 00 00 00    	je     80102225 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102171:	8b 58 08             	mov    0x8(%eax),%ebx
80102174:	89 c6                	mov    %eax,%esi
80102176:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010217c:	0f 87 96 00 00 00    	ja     80102218 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102187:	89 f6                	mov    %esi,%esi
80102189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102190:	89 ca                	mov    %ecx,%edx
80102192:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102193:	83 e0 c0             	and    $0xffffffc0,%eax
80102196:	3c 40                	cmp    $0x40,%al
80102198:	75 f6                	jne    80102190 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	ee                   	out    %al,(%dx)
801021a4:	b8 01 00 00 00       	mov    $0x1,%eax
801021a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ae:	ee                   	out    %al,(%dx)
801021af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b4:	89 d8                	mov    %ebx,%eax
801021b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021b7:	89 d8                	mov    %ebx,%eax
801021b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021be:	c1 f8 08             	sar    $0x8,%eax
801021c1:	ee                   	out    %al,(%dx)
801021c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801021ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d3:	c1 e0 04             	shl    $0x4,%eax
801021d6:	83 e0 10             	and    $0x10,%eax
801021d9:	83 c8 e0             	or     $0xffffffe0,%eax
801021dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021dd:	f6 06 04             	testb  $0x4,(%esi)
801021e0:	75 16                	jne    801021f8 <idestart+0x98>
801021e2:	b8 20 00 00 00       	mov    $0x20,%eax
801021e7:	89 ca                	mov    %ecx,%edx
801021e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ed:	5b                   	pop    %ebx
801021ee:	5e                   	pop    %esi
801021ef:	5f                   	pop    %edi
801021f0:	5d                   	pop    %ebp
801021f1:	c3                   	ret    
801021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f8:	b8 30 00 00 00       	mov    $0x30,%eax
801021fd:	89 ca                	mov    %ecx,%edx
801021ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102200:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102205:	83 c6 5c             	add    $0x5c,%esi
80102208:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010220d:	fc                   	cld    
8010220e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102213:	5b                   	pop    %ebx
80102214:	5e                   	pop    %esi
80102215:	5f                   	pop    %edi
80102216:	5d                   	pop    %ebp
80102217:	c3                   	ret    
    panic("incorrect blockno");
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	68 54 82 10 80       	push   $0x80108254
80102220:	e8 6b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	68 4b 82 10 80       	push   $0x8010824b
8010222d:	e8 5e e1 ff ff       	call   80100390 <panic>
80102232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102240 <ideinit>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102246:	68 66 82 10 80       	push   $0x80108266
8010224b:	68 80 b5 10 80       	push   $0x8010b580
80102250:	e8 9b 23 00 00       	call   801045f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 40 3e 11 80       	mov    0x80113e40,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 09 04 00 00       	call   80102670 <ioapicenable>
80102267:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	83 e0 c0             	and    $0xffffffc0,%eax
80102274:	3c 40                	cmp    $0x40,%al
80102276:	75 f8                	jne    80102270 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102278:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010227d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102282:	ee                   	out    %al,(%dx)
80102283:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102288:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010228d:	eb 06                	jmp    80102295 <ideinit+0x55>
8010228f:	90                   	nop
  for(i=0; i<1000; i++){
80102290:	83 e9 01             	sub    $0x1,%ecx
80102293:	74 0f                	je     801022a4 <ideinit+0x64>
80102295:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102296:	84 c0                	test   %al,%al
80102298:	74 f6                	je     80102290 <ideinit+0x50>
      havedisk1 = 1;
8010229a:	c7 05 6c b5 10 80 01 	movl   $0x1,0x8010b56c
801022a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ae:	ee                   	out    %al,(%dx)
}
801022af:	c9                   	leave  
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ideintr>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022c9:	68 80 b5 10 80       	push   $0x8010b580
801022ce:	e8 5d 24 00 00       	call   80104730 <acquire>

  if((b = idequeue) == 0){
801022d3:	8b 1d 70 b5 10 80    	mov    0x8010b570,%ebx
801022d9:	83 c4 10             	add    $0x10,%esp
801022dc:	85 db                	test   %ebx,%ebx
801022de:	74 67                	je     80102347 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022e0:	8b 43 58             	mov    0x58(%ebx),%eax
801022e3:	a3 70 b5 10 80       	mov    %eax,0x8010b570

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022e8:	8b 3b                	mov    (%ebx),%edi
801022ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801022f0:	75 31                	jne    80102323 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022f7:	89 f6                	mov    %esi,%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102300:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102301:	89 c6                	mov    %eax,%esi
80102303:	83 e6 c0             	and    $0xffffffc0,%esi
80102306:	89 f1                	mov    %esi,%ecx
80102308:	80 f9 40             	cmp    $0x40,%cl
8010230b:	75 f3                	jne    80102300 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010230d:	a8 21                	test   $0x21,%al
8010230f:	75 12                	jne    80102323 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102311:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102314:	b9 80 00 00 00       	mov    $0x80,%ecx
80102319:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010231e:	fc                   	cld    
8010231f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102321:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102323:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102326:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102329:	89 f9                	mov    %edi,%ecx
8010232b:	83 c9 02             	or     $0x2,%ecx
8010232e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102330:	53                   	push   %ebx
80102331:	e8 aa 1f 00 00       	call   801042e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102336:	a1 70 b5 10 80       	mov    0x8010b570,%eax
8010233b:	83 c4 10             	add    $0x10,%esp
8010233e:	85 c0                	test   %eax,%eax
80102340:	74 05                	je     80102347 <ideintr+0x87>
    idestart(idequeue);
80102342:	e8 19 fe ff ff       	call   80102160 <idestart>
    release(&idelock);
80102347:	83 ec 0c             	sub    $0xc,%esp
8010234a:	68 80 b5 10 80       	push   $0x8010b580
8010234f:	e8 9c 24 00 00       	call   801047f0 <release>

  release(&idelock);
}
80102354:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102357:	5b                   	pop    %ebx
80102358:	5e                   	pop    %esi
80102359:	5f                   	pop    %edi
8010235a:	5d                   	pop    %ebp
8010235b:	c3                   	ret    
8010235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102360 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 10             	sub    $0x10,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010236a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010236d:	50                   	push   %eax
8010236e:	e8 2d 22 00 00       	call   801045a0 <holdingsleep>
80102373:	83 c4 10             	add    $0x10,%esp
80102376:	85 c0                	test   %eax,%eax
80102378:	0f 84 c6 00 00 00    	je     80102444 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 e0 06             	and    $0x6,%eax
80102383:	83 f8 02             	cmp    $0x2,%eax
80102386:	0f 84 ab 00 00 00    	je     80102437 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010238c:	8b 53 04             	mov    0x4(%ebx),%edx
8010238f:	85 d2                	test   %edx,%edx
80102391:	74 0d                	je     801023a0 <iderw+0x40>
80102393:	a1 6c b5 10 80       	mov    0x8010b56c,%eax
80102398:	85 c0                	test   %eax,%eax
8010239a:	0f 84 b1 00 00 00    	je     80102451 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 80 b5 10 80       	push   $0x8010b580
801023a8:	e8 83 23 00 00       	call   80104730 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ad:	8b 15 70 b5 10 80    	mov    0x8010b570,%edx
801023b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801023b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023bd:	85 d2                	test   %edx,%edx
801023bf:	75 09                	jne    801023ca <iderw+0x6a>
801023c1:	eb 6d                	jmp    80102430 <iderw+0xd0>
801023c3:	90                   	nop
801023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c8:	89 c2                	mov    %eax,%edx
801023ca:	8b 42 58             	mov    0x58(%edx),%eax
801023cd:	85 c0                	test   %eax,%eax
801023cf:	75 f7                	jne    801023c8 <iderw+0x68>
801023d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023d6:	39 1d 70 b5 10 80    	cmp    %ebx,0x8010b570
801023dc:	74 42                	je     80102420 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	74 23                	je     8010240b <iderw+0xab>
801023e8:	90                   	nop
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023f0:	83 ec 08             	sub    $0x8,%esp
801023f3:	68 80 b5 10 80       	push   $0x8010b580
801023f8:	53                   	push   %ebx
801023f9:	e8 32 1d 00 00       	call   80104130 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 c4 10             	add    $0x10,%esp
80102403:	83 e0 06             	and    $0x6,%eax
80102406:	83 f8 02             	cmp    $0x2,%eax
80102409:	75 e5                	jne    801023f0 <iderw+0x90>
  }

  release(&idelock);
8010240b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102415:	c9                   	leave  
  release(&idelock);
80102416:	e9 d5 23 00 00       	jmp    801047f0 <release>
8010241b:	90                   	nop
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102420:	89 d8                	mov    %ebx,%eax
80102422:	e8 39 fd ff ff       	call   80102160 <idestart>
80102427:	eb b5                	jmp    801023de <iderw+0x7e>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102430:	ba 70 b5 10 80       	mov    $0x8010b570,%edx
80102435:	eb 9d                	jmp    801023d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 80 82 10 80       	push   $0x80108280
8010243f:	e8 4c df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	68 6a 82 10 80       	push   $0x8010826a
8010244c:	e8 3f df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102451:	83 ec 0c             	sub    $0xc,%esp
80102454:	68 95 82 10 80       	push   $0x80108295
80102459:	e8 32 df ff ff       	call   80100390 <panic>
8010245e:	66 90                	xchg   %ax,%ax

80102460 <get_waiting_ops>:

// functions for ideinfo
int
get_waiting_ops(void)
{
80102460:	55                   	push   %ebp
  return 0;
}
80102461:	31 c0                	xor    %eax,%eax
{
80102463:	89 e5                	mov    %esp,%ebp
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	89 f6                	mov    %esi,%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <get_read_wait_ops>:

// TODO: check what is IDE_CMD_RDMUL flag
int
get_read_wait_ops(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	53                   	push   %ebx
  int counter = 0;
80102474:	31 db                	xor    %ebx,%ebx
{
80102476:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&idelock);
80102479:	68 80 b5 10 80       	push   $0x8010b580
8010247e:	e8 ad 22 00 00       	call   80104730 <acquire>
  for(b = idequeue; b != 0; b = b->next){
80102483:	8b 15 70 b5 10 80    	mov    0x8010b570,%edx
80102489:	83 c4 10             	add    $0x10,%esp
8010248c:	85 d2                	test   %edx,%edx
8010248e:	74 12                	je     801024a2 <get_read_wait_ops+0x32>
    if(b->flags & IDE_CMD_READ){
80102490:	8b 0a                	mov    (%edx),%ecx
  for(b = idequeue; b != 0; b = b->next){
80102492:	8b 52 54             	mov    0x54(%edx),%edx
    if(b->flags & IDE_CMD_READ){
80102495:	83 e1 20             	and    $0x20,%ecx
      counter++;
80102498:	83 f9 01             	cmp    $0x1,%ecx
8010249b:	83 db ff             	sbb    $0xffffffff,%ebx
  for(b = idequeue; b != 0; b = b->next){
8010249e:	85 d2                	test   %edx,%edx
801024a0:	75 ee                	jne    80102490 <get_read_wait_ops+0x20>
    }
    /*if(b->flags & IDE_CMD_RDMUL){
      counter++;
    }*/
  }
  release(&idelock);
801024a2:	83 ec 0c             	sub    $0xc,%esp
801024a5:	68 80 b5 10 80       	push   $0x8010b580
801024aa:	e8 41 23 00 00       	call   801047f0 <release>
  return counter;
}
801024af:	89 d8                	mov    %ebx,%eax
801024b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024b4:	c9                   	leave  
801024b5:	c3                   	ret    
801024b6:	8d 76 00             	lea    0x0(%esi),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <get_write_wait_ops>:

// TODO: check what is IDE_CMD_WRMUL flag
int
get_write_wait_ops(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
  int counter = 0;
801024c4:	31 db                	xor    %ebx,%ebx
{
801024c6:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&idelock);
801024c9:	68 80 b5 10 80       	push   $0x8010b580
801024ce:	e8 5d 22 00 00       	call   80104730 <acquire>
  for(b = idequeue; b != 0; b = b->next){
801024d3:	8b 15 70 b5 10 80    	mov    0x8010b570,%edx
801024d9:	83 c4 10             	add    $0x10,%esp
801024dc:	85 d2                	test   %edx,%edx
801024de:	74 12                	je     801024f2 <get_write_wait_ops+0x32>
    if(b->flags & IDE_CMD_WRITE){
801024e0:	8b 0a                	mov    (%edx),%ecx
  for(b = idequeue; b != 0; b = b->next){
801024e2:	8b 52 54             	mov    0x54(%edx),%edx
    if(b->flags & IDE_CMD_WRITE){
801024e5:	83 e1 30             	and    $0x30,%ecx
      counter++;
801024e8:	83 f9 01             	cmp    $0x1,%ecx
801024eb:	83 db ff             	sbb    $0xffffffff,%ebx
  for(b = idequeue; b != 0; b = b->next){
801024ee:	85 d2                	test   %edx,%edx
801024f0:	75 ee                	jne    801024e0 <get_write_wait_ops+0x20>
    }
  }
  release(&idelock);
801024f2:	83 ec 0c             	sub    $0xc,%esp
801024f5:	68 80 b5 10 80       	push   $0x8010b580
801024fa:	e8 f1 22 00 00       	call   801047f0 <release>
  return counter;
}
801024ff:	89 d8                	mov    %ebx,%eax
80102501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102504:	c9                   	leave  
80102505:	c3                   	ret    
80102506:	8d 76 00             	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <get_working_blocks>:
struct tempbuf headLink = {0,0,0};
struct tempbuf *head = &headLink; // list head

struct tempbuf *
get_working_blocks(void)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	57                   	push   %edi
80102514:	56                   	push   %esi
80102515:	53                   	push   %ebx
80102516:	83 ec 28             	sub    $0x28,%esp
  struct tempbuf *tempLink = head;
80102519:	8b 1d 00 90 10 80    	mov    0x80109000,%ebx
  struct buf *b;

  acquire(&idelock);
8010251f:	68 80 b5 10 80       	push   $0x8010b580
80102524:	e8 07 22 00 00       	call   80104730 <acquire>
  for(b = idequeue; b != 0; b = b->next){ // go over the idequeue and create a tempbuf list
80102529:	8b 35 70 b5 10 80    	mov    0x8010b570,%esi
8010252f:	83 c4 10             	add    $0x10,%esp
80102532:	85 f6                	test   %esi,%esi
80102534:	74 66                	je     8010259c <get_working_blocks+0x8c>
    } else {
      struct tempbuf newLink = {0,0,0};
      newLink.device_num = b->dev;
      newLink.block_num = b->blockno;
      newLink.next = 0;
      tempLink->next = &newLink;
80102536:	8d 7d dc             	lea    -0x24(%ebp),%edi
80102539:	eb 11                	jmp    8010254c <get_working_blocks+0x3c>
8010253b:	90                   	nop
8010253c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102540:	89 7b 08             	mov    %edi,0x8(%ebx)
  for(b = idequeue; b != 0; b = b->next){ // go over the idequeue and create a tempbuf list
80102543:	8b 76 54             	mov    0x54(%esi),%esi
      tempLink = tempLink->next;
80102546:	89 fb                	mov    %edi,%ebx
  for(b = idequeue; b != 0; b = b->next){ // go over the idequeue and create a tempbuf list
80102548:	85 f6                	test   %esi,%esi
8010254a:	74 50                	je     8010259c <get_working_blocks+0x8c>
    if(tempLink->device_num == 0 && tempLink->block_num == 0){
8010254c:	8b 0b                	mov    (%ebx),%ecx
8010254e:	85 c9                	test   %ecx,%ecx
80102550:	75 ee                	jne    80102540 <get_working_blocks+0x30>
80102552:	8b 53 04             	mov    0x4(%ebx),%edx
80102555:	85 d2                	test   %edx,%edx
80102557:	75 e7                	jne    80102540 <get_working_blocks+0x30>
      tempLink->device_num = b->dev;
80102559:	8b 46 04             	mov    0x4(%esi),%eax
      cprintf("device_num=%d, block_num=%d\n", tempLink->device_num, tempLink->block_num);
8010255c:	83 ec 04             	sub    $0x4,%esp
      tempLink->device_num = b->dev;
8010255f:	89 03                	mov    %eax,(%ebx)
      tempLink->block_num = b->blockno;
80102561:	8b 56 08             	mov    0x8(%esi),%edx
      tempLink->next = 0;
80102564:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
      tempLink->block_num = b->blockno;
8010256b:	89 53 04             	mov    %edx,0x4(%ebx)
      cprintf("device_num=%d, block_num=%d\n", tempLink->device_num, tempLink->block_num);
8010256e:	52                   	push   %edx
8010256f:	50                   	push   %eax
80102570:	68 b3 82 10 80       	push   $0x801082b3
80102575:	e8 e6 e0 ff ff       	call   80100660 <cprintf>
      char x[3] = "abc";
8010257a:	b8 61 62 00 00       	mov    $0x6261,%eax
8010257f:	c6 45 db 63          	movb   $0x63,-0x25(%ebp)
80102583:	66 89 45 d9          	mov    %ax,-0x27(%ebp)
      cprintf(x);
80102587:	8d 45 d9             	lea    -0x27(%ebp),%eax
8010258a:	89 04 24             	mov    %eax,(%esp)
8010258d:	e8 ce e0 ff ff       	call   80100660 <cprintf>
  for(b = idequeue; b != 0; b = b->next){ // go over the idequeue and create a tempbuf list
80102592:	8b 76 54             	mov    0x54(%esi),%esi
    if(tempLink->device_num == 0 && tempLink->block_num == 0){
80102595:	83 c4 10             	add    $0x10,%esp
  for(b = idequeue; b != 0; b = b->next){ // go over the idequeue and create a tempbuf list
80102598:	85 f6                	test   %esi,%esi
8010259a:	75 b0                	jne    8010254c <get_working_blocks+0x3c>
    }
  }
  release(&idelock);
8010259c:	83 ec 0c             	sub    $0xc,%esp
8010259f:	68 80 b5 10 80       	push   $0x8010b580
801025a4:	e8 47 22 00 00       	call   801047f0 <release>
  return head;
801025a9:	a1 00 90 10 80       	mov    0x80109000,%eax
801025ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025b1:	5b                   	pop    %ebx
801025b2:	5e                   	pop    %esi
801025b3:	5f                   	pop    %edi
801025b4:	5d                   	pop    %ebp
801025b5:	c3                   	ret    
801025b6:	66 90                	xchg   %ax,%ax
801025b8:	66 90                	xchg   %ax,%ax
801025ba:	66 90                	xchg   %ax,%ax
801025bc:	66 90                	xchg   %ax,%ax
801025be:	66 90                	xchg   %ax,%ax

801025c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025c1:	c7 05 74 37 11 80 00 	movl   $0xfec00000,0x80113774
801025c8:	00 c0 fe 
{
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	56                   	push   %esi
801025ce:	53                   	push   %ebx
  ioapic->reg = reg;
801025cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025d6:	00 00 00 
  return ioapic->data;
801025d9:	a1 74 37 11 80       	mov    0x80113774,%eax
801025de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025e7:	8b 0d 74 37 11 80    	mov    0x80113774,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ed:	0f b6 15 a0 38 11 80 	movzbl 0x801138a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801025f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801025fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102600:	39 c2                	cmp    %eax,%edx
80102602:	74 16                	je     8010261a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102604:	83 ec 0c             	sub    $0xc,%esp
80102607:	68 d0 82 10 80       	push   $0x801082d0
8010260c:	e8 4f e0 ff ff       	call   80100660 <cprintf>
80102611:	8b 0d 74 37 11 80    	mov    0x80113774,%ecx
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	83 c3 21             	add    $0x21,%ebx
{
8010261d:	ba 10 00 00 00       	mov    $0x10,%edx
80102622:	b8 20 00 00 00       	mov    $0x20,%eax
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102630:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102632:	8b 0d 74 37 11 80    	mov    0x80113774,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102638:	89 c6                	mov    %eax,%esi
8010263a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102640:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102643:	89 71 10             	mov    %esi,0x10(%ecx)
80102646:	8d 72 01             	lea    0x1(%edx),%esi
80102649:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010264c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010264e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102650:	8b 0d 74 37 11 80    	mov    0x80113774,%ecx
80102656:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010265d:	75 d1                	jne    80102630 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010265f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102662:	5b                   	pop    %ebx
80102663:	5e                   	pop    %esi
80102664:	5d                   	pop    %ebp
80102665:	c3                   	ret    
80102666:	8d 76 00             	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102670:	55                   	push   %ebp
  ioapic->reg = reg;
80102671:	8b 0d 74 37 11 80    	mov    0x80113774,%ecx
{
80102677:	89 e5                	mov    %esp,%ebp
80102679:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010267c:	8d 50 20             	lea    0x20(%eax),%edx
8010267f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102683:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102685:	8b 0d 74 37 11 80    	mov    0x80113774,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010268e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102691:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102694:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102696:	a1 74 37 11 80       	mov    0x80113774,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010269b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010269e:	89 50 10             	mov    %edx,0x10(%eax)
}
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	66 90                	xchg   %ax,%ax
801026a5:	66 90                	xchg   %ax,%ax
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
801026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026c0:	75 70                	jne    80102732 <kfree+0x82>
801026c2:	81 fb 40 6d 11 80    	cmp    $0x80116d40,%ebx
801026c8:	72 68                	jb     80102732 <kfree+0x82>
801026ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026d5:	77 5b                	ja     80102732 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026d7:	83 ec 04             	sub    $0x4,%esp
801026da:	68 00 10 00 00       	push   $0x1000
801026df:	6a 01                	push   $0x1
801026e1:	53                   	push   %ebx
801026e2:	e8 59 21 00 00       	call   80104840 <memset>

  if(kmem.use_lock)
801026e7:	8b 15 b4 37 11 80    	mov    0x801137b4,%edx
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 d2                	test   %edx,%edx
801026f2:	75 2c                	jne    80102720 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026f4:	a1 b8 37 11 80       	mov    0x801137b8,%eax
801026f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026fb:	a1 b4 37 11 80       	mov    0x801137b4,%eax
  kmem.freelist = r;
80102700:	89 1d b8 37 11 80    	mov    %ebx,0x801137b8
  if(kmem.use_lock)
80102706:	85 c0                	test   %eax,%eax
80102708:	75 06                	jne    80102710 <kfree+0x60>
    release(&kmem.lock);
}
8010270a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270d:	c9                   	leave  
8010270e:	c3                   	ret    
8010270f:	90                   	nop
    release(&kmem.lock);
80102710:	c7 45 08 80 37 11 80 	movl   $0x80113780,0x8(%ebp)
}
80102717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271a:	c9                   	leave  
    release(&kmem.lock);
8010271b:	e9 d0 20 00 00       	jmp    801047f0 <release>
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 80 37 11 80       	push   $0x80113780
80102728:	e8 03 20 00 00       	call   80104730 <acquire>
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	eb c2                	jmp    801026f4 <kfree+0x44>
    panic("kfree");
80102732:	83 ec 0c             	sub    $0xc,%esp
80102735:	68 02 83 10 80       	push   $0x80108302
8010273a:	e8 51 dc ff ff       	call   80100390 <panic>
8010273f:	90                   	nop

80102740 <freerange>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102748:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <freerange+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010276e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 33 ff ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 f3                	cmp    %esi,%ebx
80102782:	76 e4                	jbe    80102768 <freerange+0x28>
}
80102784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102787:	5b                   	pop    %ebx
80102788:	5e                   	pop    %esi
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <kinit1>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
80102795:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102798:	83 ec 08             	sub    $0x8,%esp
8010279b:	68 08 83 10 80       	push   $0x80108308
801027a0:	68 80 37 11 80       	push   $0x80113780
801027a5:	e8 46 1e 00 00       	call   801045f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027b0:	c7 05 b4 37 11 80 00 	movl   $0x0,0x801137b4
801027b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cc:	39 de                	cmp    %ebx,%esi
801027ce:	72 1c                	jb     801027ec <kinit1+0x5c>
    kfree(p);
801027d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027d6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027df:	50                   	push   %eax
801027e0:	e8 cb fe ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e5:	83 c4 10             	add    $0x10,%esp
801027e8:	39 de                	cmp    %ebx,%esi
801027ea:	73 e4                	jae    801027d0 <kinit1+0x40>
}
801027ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027ef:	5b                   	pop    %ebx
801027f0:	5e                   	pop    %esi
801027f1:	5d                   	pop    %ebp
801027f2:	c3                   	ret    
801027f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <kinit2>:
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
80102804:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102808:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010280b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102811:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102817:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010281d:	39 de                	cmp    %ebx,%esi
8010281f:	72 23                	jb     80102844 <kinit2+0x44>
80102821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102828:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010282e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102837:	50                   	push   %eax
80102838:	e8 73 fe ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	39 de                	cmp    %ebx,%esi
80102842:	73 e4                	jae    80102828 <kinit2+0x28>
  kmem.use_lock = 1;
80102844:	c7 05 b4 37 11 80 01 	movl   $0x1,0x801137b4
8010284b:	00 00 00 
}
8010284e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102851:	5b                   	pop    %ebx
80102852:	5e                   	pop    %esi
80102853:	5d                   	pop    %ebp
80102854:	c3                   	ret    
80102855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102860:	a1 b4 37 11 80       	mov    0x801137b4,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 1f                	jne    80102888 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102869:	a1 b8 37 11 80       	mov    0x801137b8,%eax
  if(r)
8010286e:	85 c0                	test   %eax,%eax
80102870:	74 0e                	je     80102880 <kalloc+0x20>
    kmem.freelist = r->next;
80102872:	8b 10                	mov    (%eax),%edx
80102874:	89 15 b8 37 11 80    	mov    %edx,0x801137b8
8010287a:	c3                   	ret    
8010287b:	90                   	nop
8010287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102880:	f3 c3                	repz ret 
80102882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
8010288b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010288e:	68 80 37 11 80       	push   $0x80113780
80102893:	e8 98 1e 00 00       	call   80104730 <acquire>
  r = kmem.freelist;
80102898:	a1 b8 37 11 80       	mov    0x801137b8,%eax
  if(r)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	8b 15 b4 37 11 80    	mov    0x801137b4,%edx
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 08                	je     801028b2 <kalloc+0x52>
    kmem.freelist = r->next;
801028aa:	8b 08                	mov    (%eax),%ecx
801028ac:	89 0d b8 37 11 80    	mov    %ecx,0x801137b8
  if(kmem.use_lock)
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 16                	je     801028cc <kalloc+0x6c>
    release(&kmem.lock);
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	68 80 37 11 80       	push   $0x80113780
801028c1:	e8 2a 1f 00 00       	call   801047f0 <release>
  return (char*)r;
801028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	c9                   	leave  
801028cd:	c3                   	ret    
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba 64 00 00 00       	mov    $0x64,%edx
801028d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d6:	a8 01                	test   $0x1,%al
801028d8:	0f 84 c2 00 00 00    	je     801029a0 <kbdgetc+0xd0>
801028de:	ba 60 00 00 00       	mov    $0x60,%edx
801028e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028e4:	0f b6 d0             	movzbl %al,%edx
801028e7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801028ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028f3:	0f 84 7f 00 00 00    	je     80102978 <kbdgetc+0xa8>
{
801028f9:	55                   	push   %ebp
801028fa:	89 e5                	mov    %esp,%ebp
801028fc:	53                   	push   %ebx
801028fd:	89 cb                	mov    %ecx,%ebx
801028ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102902:	84 c0                	test   %al,%al
80102904:	78 4a                	js     80102950 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102906:	85 db                	test   %ebx,%ebx
80102908:	74 09                	je     80102913 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010290a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010290d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102910:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102913:	0f b6 82 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%eax
8010291a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010291c:	0f b6 82 40 83 10 80 	movzbl -0x7fef7cc0(%edx),%eax
80102923:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102927:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010292d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102930:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102933:	8b 04 85 20 83 10 80 	mov    -0x7fef7ce0(,%eax,4),%eax
8010293a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010293e:	74 31                	je     80102971 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102940:	8d 50 9f             	lea    -0x61(%eax),%edx
80102943:	83 fa 19             	cmp    $0x19,%edx
80102946:	77 40                	ja     80102988 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102948:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010294b:	5b                   	pop    %ebx
8010294c:	5d                   	pop    %ebp
8010294d:	c3                   	ret    
8010294e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102950:	83 e0 7f             	and    $0x7f,%eax
80102953:	85 db                	test   %ebx,%ebx
80102955:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102958:	0f b6 82 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%eax
8010295f:	83 c8 40             	or     $0x40,%eax
80102962:	0f b6 c0             	movzbl %al,%eax
80102965:	f7 d0                	not    %eax
80102967:	21 c1                	and    %eax,%ecx
    return 0;
80102969:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010296b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102971:	5b                   	pop    %ebx
80102972:	5d                   	pop    %ebp
80102973:	c3                   	ret    
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102978:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010297b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010297d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102983:	c3                   	ret    
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102988:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010298b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010298e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010298f:	83 f9 1a             	cmp    $0x1a,%ecx
80102992:	0f 42 c2             	cmovb  %edx,%eax
}
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	89 f6                	mov    %esi,%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801029a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029a5:	c3                   	ret    
801029a6:	8d 76 00             	lea    0x0(%esi),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <kbdintr>:

void
kbdintr(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029b6:	68 d0 28 10 80       	push   $0x801028d0
801029bb:	e8 50 de ff ff       	call   80100810 <consoleintr>
}
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029d0:	a1 bc 37 11 80       	mov    0x801137bc,%eax
{
801029d5:	55                   	push   %ebp
801029d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029d8:	85 c0                	test   %eax,%eax
801029da:	0f 84 c8 00 00 00    	je     80102aa8 <lapicinit+0xd8>
  lapic[index] = value;
801029e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a01:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a07:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a0e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a14:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a1b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a28:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a2e:	8b 50 30             	mov    0x30(%eax),%edx
80102a31:	c1 ea 10             	shr    $0x10,%edx
80102a34:	80 fa 03             	cmp    $0x3,%dl
80102a37:	77 77                	ja     80102ab0 <lapicinit+0xe0>
  lapic[index] = value;
80102a39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
80102a87:	89 f6                	mov    %esi,%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a96:	80 e6 10             	and    $0x10,%dh
80102a99:	75 f5                	jne    80102a90 <lapicinit+0xc0>
  lapic[index] = value;
80102a9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102aa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102aa8:	5d                   	pop    %ebp
80102aa9:	c3                   	ret    
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102ab0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ab7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aba:	8b 50 20             	mov    0x20(%eax),%edx
80102abd:	e9 77 ff ff ff       	jmp    80102a39 <lapicinit+0x69>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ad0:	8b 15 bc 37 11 80    	mov    0x801137bc,%edx
{
80102ad6:	55                   	push   %ebp
80102ad7:	31 c0                	xor    %eax,%eax
80102ad9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102adb:	85 d2                	test   %edx,%edx
80102add:	74 06                	je     80102ae5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102adf:	8b 42 20             	mov    0x20(%edx),%eax
80102ae2:	c1 e8 18             	shr    $0x18,%eax
}
80102ae5:	5d                   	pop    %ebp
80102ae6:	c3                   	ret    
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102af0:	a1 bc 37 11 80       	mov    0x801137bc,%eax
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102af8:	85 c0                	test   %eax,%eax
80102afa:	74 0d                	je     80102b09 <lapiceoi+0x19>
  lapic[index] = value;
80102afc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b03:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b06:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b09:	5d                   	pop    %ebp
80102b0a:	c3                   	ret    
80102b0b:	90                   	nop
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
}
80102b13:	5d                   	pop    %ebp
80102b14:	c3                   	ret    
80102b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	53                   	push   %ebx
80102b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b34:	ee                   	out    %al,(%dx)
80102b35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b4d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102b50:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102b53:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b5e:	a1 bc 37 11 80       	mov    0x801137bc,%eax
80102b63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102baa:	5b                   	pop    %ebx
80102bab:	5d                   	pop    %ebp
80102bac:	c3                   	ret    
80102bad:	8d 76 00             	lea    0x0(%esi),%esi

80102bb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bb0:	55                   	push   %ebp
80102bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	57                   	push   %edi
80102bbe:	56                   	push   %esi
80102bbf:	53                   	push   %ebx
80102bc0:	83 ec 4c             	sub    $0x4c,%esp
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc9:	ec                   	in     (%dx),%al
80102bca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
80102bd8:	31 c0                	xor    %eax,%eax
80102bda:	89 da                	mov    %ebx,%edx
80102bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be8:	89 da                	mov    %ebx,%edx
80102bea:	b8 02 00 00 00       	mov    $0x2,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 da                	mov    %ebx,%edx
80102c14:	b8 08 00 00 00       	mov    $0x8,%eax
80102c19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	89 ca                	mov    %ecx,%edx
80102c1c:	ec                   	in     (%dx),%al
80102c1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1f:	89 da                	mov    %ebx,%edx
80102c21:	b8 09 00 00 00       	mov    $0x9,%eax
80102c26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	89 ca                	mov    %ecx,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2c:	89 da                	mov    %ebx,%edx
80102c2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c34:	89 ca                	mov    %ecx,%edx
80102c36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c37:	84 c0                	test   %al,%al
80102c39:	78 9d                	js     80102bd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	0f b6 fa             	movzbl %dl,%edi
80102c44:	89 f2                	mov    %esi,%edx
80102c46:	0f b6 f2             	movzbl %dl,%esi
80102c49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4c:	89 da                	mov    %ebx,%edx
80102c4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c69:	31 c0                	xor    %eax,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c77:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 da                	mov    %ebx,%edx
80102c85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c88:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
80102c91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 da                	mov    %ebx,%edx
80102c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c99:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
80102ca2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 da                	mov    %ebx,%edx
80102ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102caa:	b8 08 00 00 00       	mov    $0x8,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc1:	89 ca                	mov    %ecx,%edx
80102cc3:	ec                   	in     (%dx),%al
80102cc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cd0:	6a 18                	push   $0x18
80102cd2:	50                   	push   %eax
80102cd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd6:	50                   	push   %eax
80102cd7:	e8 b4 1b 00 00       	call   80104890 <memcmp>
80102cdc:	83 c4 10             	add    $0x10,%esp
80102cdf:	85 c0                	test   %eax,%eax
80102ce1:	0f 85 f1 fe ff ff    	jne    80102bd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ce7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ceb:	75 78                	jne    80102d65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ced:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf0:	89 c2                	mov    %eax,%edx
80102cf2:	83 e0 0f             	and    $0xf,%eax
80102cf5:	c1 ea 04             	shr    $0x4,%edx
80102cf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d04:	89 c2                	mov    %eax,%edx
80102d06:	83 e0 0f             	and    $0xf,%eax
80102d09:	c1 ea 04             	shr    $0x4,%edx
80102d0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d18:	89 c2                	mov    %eax,%edx
80102d1a:	83 e0 0f             	and    $0xf,%eax
80102d1d:	c1 ea 04             	shr    $0x4,%edx
80102d20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d2c:	89 c2                	mov    %eax,%edx
80102d2e:	83 e0 0f             	and    $0xf,%eax
80102d31:	c1 ea 04             	shr    $0x4,%edx
80102d34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	83 e0 0f             	and    $0xf,%eax
80102d45:	c1 ea 04             	shr    $0x4,%edx
80102d48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	c1 ea 04             	shr    $0x4,%edx
80102d5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d65:	8b 75 08             	mov    0x8(%ebp),%esi
80102d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6b:	89 06                	mov    %eax,(%esi)
80102d6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d70:	89 46 04             	mov    %eax,0x4(%esi)
80102d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d76:	89 46 08             	mov    %eax,0x8(%esi)
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d82:	89 46 10             	mov    %eax,0x10(%esi)
80102d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	5b                   	pop    %ebx
80102d96:	5e                   	pop    %esi
80102d97:	5f                   	pop    %edi
80102d98:	5d                   	pop    %ebp
80102d99:	c3                   	ret    
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d 08 38 11 80    	mov    0x80113808,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 8a 00 00 00    	jle    80102e38 <install_trans+0x98>
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
80102db2:	56                   	push   %esi
80102db3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102db4:	31 db                	xor    %ebx,%ebx
{
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 f4 37 11 80       	mov    0x801137f4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 d8                	add    %ebx,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 04 38 11 80    	pushl  0x80113804
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 9d 0c 38 11 80 	pushl  -0x7feec7f4(,%ebx,4)
80102de4:	ff 35 04 38 11 80    	pushl  0x80113804
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
80102df2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102df7:	83 c4 0c             	add    $0xc,%esp
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 e7 1a 00 00       	call   801048f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 8f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e11:	89 3c 24             	mov    %edi,(%esp)
80102e14:	e8 c7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e19:	89 34 24             	mov    %esi,(%esp)
80102e1c:	e8 bf d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 1d 08 38 11 80    	cmp    %ebx,0x80113808
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e38:	f3 c3                	repz ret 
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	56                   	push   %esi
80102e44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	ff 35 f4 37 11 80    	pushl  0x801137f4
80102e4e:	ff 35 04 38 11 80    	pushl  0x80113804
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e59:	8b 1d 08 38 11 80    	mov    0x80113808,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102e64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102e66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e69:	7e 16                	jle    80102e81 <write_head+0x41>
80102e6b:	c1 e3 02             	shl    $0x2,%ebx
80102e6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102e70:	8b 8a 0c 38 11 80    	mov    -0x7feec7f4(%edx),%ecx
80102e76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102e7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102e7d:	39 da                	cmp    %ebx,%edx
80102e7f:	75 ef                	jne    80102e70 <write_head+0x30>
  }
  bwrite(buf);
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	56                   	push   %esi
80102e85:	e8 16 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e8a:	89 34 24             	mov    %esi,(%esp)
80102e8d:	e8 4e d3 ff ff       	call   801001e0 <brelse>
}
80102e92:	83 c4 10             	add    $0x10,%esp
80102e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e98:	5b                   	pop    %ebx
80102e99:	5e                   	pop    %esi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ea0 <initlog>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 2c             	sub    $0x2c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eaa:	68 40 85 10 80       	push   $0x80108540
80102eaf:	68 c0 37 11 80       	push   $0x801137c0
80102eb4:	e8 37 17 00 00       	call   801045f0 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 ab e6 ff ff       	call   80101570 <readsb>
  log.size = sb.nlog;
80102ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ecb:	59                   	pop    %ecx
  log.dev = dev;
80102ecc:	89 1d 04 38 11 80    	mov    %ebx,0x80113804
  log.size = sb.nlog;
80102ed2:	89 15 f8 37 11 80    	mov    %edx,0x801137f8
  log.start = sb.logstart;
80102ed8:	a3 f4 37 11 80       	mov    %eax,0x801137f4
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ee5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102eed:	89 1d 08 38 11 80    	mov    %ebx,0x80113808
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	7e 1c                	jle    80102f11 <initlog+0x71>
80102ef5:	c1 e3 02             	shl    $0x2,%ebx
80102ef8:	31 d2                	xor    %edx,%edx
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f04:	83 c2 04             	add    $0x4,%edx
80102f07:	89 8a 08 38 11 80    	mov    %ecx,-0x7feec7f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f0d:	39 d3                	cmp    %edx,%ebx
80102f0f:	75 ef                	jne    80102f00 <initlog+0x60>
  brelse(buf);
80102f11:	83 ec 0c             	sub    $0xc,%esp
80102f14:	50                   	push   %eax
80102f15:	e8 c6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1a:	e8 81 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f1f:	c7 05 08 38 11 80 00 	movl   $0x0,0x80113808
80102f26:	00 00 00 
  write_head(); // clear the log
80102f29:	e8 12 ff ff ff       	call   80102e40 <write_head>
}
80102f2e:	83 c4 10             	add    $0x10,%esp
80102f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f34:	c9                   	leave  
80102f35:	c3                   	ret    
80102f36:	8d 76 00             	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 c0 37 11 80       	push   $0x801137c0
80102f4b:	e8 e0 17 00 00       	call   80104730 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 c0 37 11 80       	push   $0x801137c0
80102f60:	68 c0 37 11 80       	push   $0x801137c0
80102f65:	e8 c6 11 00 00       	call   80104130 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 00 38 11 80       	mov    0x80113800,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 fc 37 11 80       	mov    0x801137fc,%eax
80102f7b:	8b 15 08 38 11 80    	mov    0x80113808,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f92:	a3 fc 37 11 80       	mov    %eax,0x801137fc
      release(&log.lock);
80102f97:	68 c0 37 11 80       	push   $0x801137c0
80102f9c:	e8 4f 18 00 00       	call   801047f0 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 c0 37 11 80       	push   $0x801137c0
80102fbe:	e8 6d 17 00 00       	call   80104730 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 fc 37 11 80       	mov    0x801137fc,%eax
  if(log.committing)
80102fc8:	8b 35 00 38 11 80    	mov    0x80113800,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102fd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102fd6:	89 1d fc 37 11 80    	mov    %ebx,0x801137fc
  if(log.committing)
80102fdc:	0f 85 1a 01 00 00    	jne    801030fc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe2:	85 db                	test   %ebx,%ebx
80102fe4:	0f 85 ee 00 00 00    	jne    801030d8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102fed:	c7 05 00 38 11 80 01 	movl   $0x1,0x80113800
80102ff4:	00 00 00 
  release(&log.lock);
80102ff7:	68 c0 37 11 80       	push   $0x801137c0
80102ffc:	e8 ef 17 00 00       	call   801047f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d 08 38 11 80    	mov    0x80113808,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	0f 8e 85 00 00 00    	jle    80103097 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103012:	a1 f4 37 11 80       	mov    0x801137f4,%eax
80103017:	83 ec 08             	sub    $0x8,%esp
8010301a:	01 d8                	add    %ebx,%eax
8010301c:	83 c0 01             	add    $0x1,%eax
8010301f:	50                   	push   %eax
80103020:	ff 35 04 38 11 80    	pushl  0x80113804
80103026:	e8 a5 d0 ff ff       	call   801000d0 <bread>
8010302b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302d:	58                   	pop    %eax
8010302e:	5a                   	pop    %edx
8010302f:	ff 34 9d 0c 38 11 80 	pushl  -0x7feec7f4(,%ebx,4)
80103036:	ff 35 04 38 11 80    	pushl  0x80113804
  for (tail = 0; tail < log.lh.n; tail++) {
8010303c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303f:	e8 8c d0 ff ff       	call   801000d0 <bread>
80103044:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103046:	8d 40 5c             	lea    0x5c(%eax),%eax
80103049:	83 c4 0c             	add    $0xc,%esp
8010304c:	68 00 02 00 00       	push   $0x200
80103051:	50                   	push   %eax
80103052:	8d 46 5c             	lea    0x5c(%esi),%eax
80103055:	50                   	push   %eax
80103056:	e8 95 18 00 00       	call   801048f0 <memmove>
    bwrite(to);  // write the log
8010305b:	89 34 24             	mov    %esi,(%esp)
8010305e:	e8 3d d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103063:	89 3c 24             	mov    %edi,(%esp)
80103066:	e8 75 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010306b:	89 34 24             	mov    %esi,(%esp)
8010306e:	e8 6d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103073:	83 c4 10             	add    $0x10,%esp
80103076:	3b 1d 08 38 11 80    	cmp    0x80113808,%ebx
8010307c:	7c 94                	jl     80103012 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010307e:	e8 bd fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
80103083:	e8 18 fd ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
80103088:	c7 05 08 38 11 80 00 	movl   $0x0,0x80113808
8010308f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103092:	e8 a9 fd ff ff       	call   80102e40 <write_head>
    acquire(&log.lock);
80103097:	83 ec 0c             	sub    $0xc,%esp
8010309a:	68 c0 37 11 80       	push   $0x801137c0
8010309f:	e8 8c 16 00 00       	call   80104730 <acquire>
    wakeup(&log);
801030a4:	c7 04 24 c0 37 11 80 	movl   $0x801137c0,(%esp)
    log.committing = 0;
801030ab:	c7 05 00 38 11 80 00 	movl   $0x0,0x80113800
801030b2:	00 00 00 
    wakeup(&log);
801030b5:	e8 26 12 00 00       	call   801042e0 <wakeup>
    release(&log.lock);
801030ba:	c7 04 24 c0 37 11 80 	movl   $0x801137c0,(%esp)
801030c1:	e8 2a 17 00 00       	call   801047f0 <release>
801030c6:	83 c4 10             	add    $0x10,%esp
}
801030c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cc:	5b                   	pop    %ebx
801030cd:	5e                   	pop    %esi
801030ce:	5f                   	pop    %edi
801030cf:	5d                   	pop    %ebp
801030d0:	c3                   	ret    
801030d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801030d8:	83 ec 0c             	sub    $0xc,%esp
801030db:	68 c0 37 11 80       	push   $0x801137c0
801030e0:	e8 fb 11 00 00       	call   801042e0 <wakeup>
  release(&log.lock);
801030e5:	c7 04 24 c0 37 11 80 	movl   $0x801137c0,(%esp)
801030ec:	e8 ff 16 00 00       	call   801047f0 <release>
801030f1:	83 c4 10             	add    $0x10,%esp
}
801030f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f7:	5b                   	pop    %ebx
801030f8:	5e                   	pop    %esi
801030f9:	5f                   	pop    %edi
801030fa:	5d                   	pop    %ebp
801030fb:	c3                   	ret    
    panic("log.committing");
801030fc:	83 ec 0c             	sub    $0xc,%esp
801030ff:	68 44 85 10 80       	push   $0x80108544
80103104:	e8 87 d2 ff ff       	call   80100390 <panic>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103110 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103117:	8b 15 08 38 11 80    	mov    0x80113808,%edx
{
8010311d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103120:	83 fa 1d             	cmp    $0x1d,%edx
80103123:	0f 8f 9d 00 00 00    	jg     801031c6 <log_write+0xb6>
80103129:	a1 f8 37 11 80       	mov    0x801137f8,%eax
8010312e:	83 e8 01             	sub    $0x1,%eax
80103131:	39 c2                	cmp    %eax,%edx
80103133:	0f 8d 8d 00 00 00    	jge    801031c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103139:	a1 fc 37 11 80       	mov    0x801137fc,%eax
8010313e:	85 c0                	test   %eax,%eax
80103140:	0f 8e 8d 00 00 00    	jle    801031d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	68 c0 37 11 80       	push   $0x801137c0
8010314e:	e8 dd 15 00 00       	call   80104730 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103153:	8b 0d 08 38 11 80    	mov    0x80113808,%ecx
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	83 f9 00             	cmp    $0x0,%ecx
8010315f:	7e 57                	jle    801031b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103161:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103164:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103166:	3b 15 0c 38 11 80    	cmp    0x8011380c,%edx
8010316c:	75 0b                	jne    80103179 <log_write+0x69>
8010316e:	eb 38                	jmp    801031a8 <log_write+0x98>
80103170:	39 14 85 0c 38 11 80 	cmp    %edx,-0x7feec7f4(,%eax,4)
80103177:	74 2f                	je     801031a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103179:	83 c0 01             	add    $0x1,%eax
8010317c:	39 c1                	cmp    %eax,%ecx
8010317e:	75 f0                	jne    80103170 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 14 85 0c 38 11 80 	mov    %edx,-0x7feec7f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103187:	83 c0 01             	add    $0x1,%eax
8010318a:	a3 08 38 11 80       	mov    %eax,0x80113808
  b->flags |= B_DIRTY; // prevent eviction
8010318f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103192:	c7 45 08 c0 37 11 80 	movl   $0x801137c0,0x8(%ebp)
}
80103199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010319c:	c9                   	leave  
  release(&log.lock);
8010319d:	e9 4e 16 00 00       	jmp    801047f0 <release>
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031a8:	89 14 85 0c 38 11 80 	mov    %edx,-0x7feec7f4(,%eax,4)
801031af:	eb de                	jmp    8010318f <log_write+0x7f>
801031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b8:	8b 43 08             	mov    0x8(%ebx),%eax
801031bb:	a3 0c 38 11 80       	mov    %eax,0x8011380c
  if (i == log.lh.n)
801031c0:	75 cd                	jne    8010318f <log_write+0x7f>
801031c2:	31 c0                	xor    %eax,%eax
801031c4:	eb c1                	jmp    80103187 <log_write+0x77>
    panic("too big a transaction");
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	68 53 85 10 80       	push   $0x80108553
801031ce:	e8 bd d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031d3:	83 ec 0c             	sub    $0xc,%esp
801031d6:	68 69 85 10 80       	push   $0x80108569
801031db:	e8 b0 d1 ff ff       	call   80100390 <panic>

801031e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031e7:	e8 84 09 00 00       	call   80103b70 <cpuid>
801031ec:	89 c3                	mov    %eax,%ebx
801031ee:	e8 7d 09 00 00       	call   80103b70 <cpuid>
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	53                   	push   %ebx
801031f7:	50                   	push   %eax
801031f8:	68 84 85 10 80       	push   $0x80108584
801031fd:	e8 5e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103202:	e8 b9 28 00 00       	call   80105ac0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103207:	e8 e4 08 00 00       	call   80103af0 <mycpu>
8010320c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010320e:	b8 01 00 00 00       	mov    $0x1,%eax
80103213:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010321a:	e8 31 0c 00 00       	call   80103e50 <scheduler>
8010321f:	90                   	nop

80103220 <mpenter>:
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103226:	e8 85 39 00 00       	call   80106bb0 <switchkvm>
  seginit();
8010322b:	e8 f0 38 00 00       	call   80106b20 <seginit>
  lapicinit();
80103230:	e8 9b f7 ff ff       	call   801029d0 <lapicinit>
  mpmain();
80103235:	e8 a6 ff ff ff       	call   801031e0 <mpmain>
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <main>:
{
80103240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103244:	83 e4 f0             	and    $0xfffffff0,%esp
80103247:	ff 71 fc             	pushl  -0x4(%ecx)
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	53                   	push   %ebx
8010324e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010324f:	83 ec 08             	sub    $0x8,%esp
80103252:	68 00 00 40 80       	push   $0x80400000
80103257:	68 40 6d 11 80       	push   $0x80116d40
8010325c:	e8 2f f5 ff ff       	call   80102790 <kinit1>
  kvmalloc();      // kernel page table
80103261:	e8 1a 3e 00 00       	call   80107080 <kvmalloc>
  mpinit();        // detect other processors
80103266:	e8 75 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010326b:	e8 60 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103270:	e8 ab 38 00 00       	call   80106b20 <seginit>
  picinit();       // disable pic
80103275:	e8 46 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010327a:	e8 41 f3 ff ff       	call   801025c0 <ioapicinit>
  procfsinit();    // procfs file system
8010327f:	e8 ac 40 00 00       	call   80107330 <procfsinit>
  consoleinit();   // console hardware
80103284:	e8 37 d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103289:	e8 62 2b 00 00       	call   80105df0 <uartinit>
  pinit();         // process table
8010328e:	e8 3d 08 00 00       	call   80103ad0 <pinit>
  tvinit();        // trap vectors
80103293:	e8 a8 27 00 00       	call   80105a40 <tvinit>
  binit();         // buffer cache
80103298:	e8 a3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010329d:	e8 be da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
801032a2:	e8 99 ef ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032a7:	83 c4 0c             	add    $0xc,%esp
801032aa:	68 8a 00 00 00       	push   $0x8a
801032af:	68 8c b4 10 80       	push   $0x8010b48c
801032b4:	68 00 70 00 80       	push   $0x80007000
801032b9:	e8 32 16 00 00       	call   801048f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032be:	69 05 40 3e 11 80 b0 	imul   $0xb0,0x80113e40,%eax
801032c5:	00 00 00 
801032c8:	83 c4 10             	add    $0x10,%esp
801032cb:	05 c0 38 11 80       	add    $0x801138c0,%eax
801032d0:	3d c0 38 11 80       	cmp    $0x801138c0,%eax
801032d5:	76 6c                	jbe    80103343 <main+0x103>
801032d7:	bb c0 38 11 80       	mov    $0x801138c0,%ebx
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801032e0:	e8 0b 08 00 00       	call   80103af0 <mycpu>
801032e5:	39 d8                	cmp    %ebx,%eax
801032e7:	74 41                	je     8010332a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032e9:	e8 72 f5 ff ff       	call   80102860 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801032f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103220,0x80006ff8
801032fa:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032fd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103304:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103307:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010330c:	0f b6 03             	movzbl (%ebx),%eax
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	68 00 70 00 00       	push   $0x7000
80103317:	50                   	push   %eax
80103318:	e8 03 f8 ff ff       	call   80102b20 <lapicstartap>
8010331d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103320:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103326:	85 c0                	test   %eax,%eax
80103328:	74 f6                	je     80103320 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010332a:	69 05 40 3e 11 80 b0 	imul   $0xb0,0x80113e40,%eax
80103331:	00 00 00 
80103334:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010333a:	05 c0 38 11 80       	add    $0x801138c0,%eax
8010333f:	39 c3                	cmp    %eax,%ebx
80103341:	72 9d                	jb     801032e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103343:	83 ec 08             	sub    $0x8,%esp
80103346:	68 00 00 00 8e       	push   $0x8e000000
8010334b:	68 00 00 40 80       	push   $0x80400000
80103350:	e8 ab f4 ff ff       	call   80102800 <kinit2>
  userinit();      // first user process
80103355:	e8 66 08 00 00       	call   80103bc0 <userinit>
  mpmain();        // finish this processor's setup
8010335a:	e8 81 fe ff ff       	call   801031e0 <mpmain>
8010335f:	90                   	nop

80103360 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103365:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010336b:	53                   	push   %ebx
  e = addr+len;
8010336c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010336f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103372:	39 de                	cmp    %ebx,%esi
80103374:	72 10                	jb     80103386 <mpsearch1+0x26>
80103376:	eb 50                	jmp    801033c8 <mpsearch1+0x68>
80103378:	90                   	nop
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103380:	39 fb                	cmp    %edi,%ebx
80103382:	89 fe                	mov    %edi,%esi
80103384:	76 42                	jbe    801033c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103386:	83 ec 04             	sub    $0x4,%esp
80103389:	8d 7e 10             	lea    0x10(%esi),%edi
8010338c:	6a 04                	push   $0x4
8010338e:	68 98 85 10 80       	push   $0x80108598
80103393:	56                   	push   %esi
80103394:	e8 f7 14 00 00       	call   80104890 <memcmp>
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	85 c0                	test   %eax,%eax
8010339e:	75 e0                	jne    80103380 <mpsearch1+0x20>
801033a0:	89 f1                	mov    %esi,%ecx
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 11             	movzbl (%ecx),%edx
801033ab:	83 c1 01             	add    $0x1,%ecx
801033ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801033b0:	39 f9                	cmp    %edi,%ecx
801033b2:	75 f4                	jne    801033a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b4:	84 c0                	test   %al,%al
801033b6:	75 c8                	jne    80103380 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret    
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033cb:	31 f6                	xor    %esi,%esi
}
801033cd:	89 f0                	mov    %esi,%eax
801033cf:	5b                   	pop    %ebx
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
801033d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801033e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033f7:	c1 e0 08             	shl    $0x8,%eax
801033fa:	09 d0                	or     %edx,%eax
801033fc:	c1 e0 04             	shl    $0x4,%eax
801033ff:	85 c0                	test   %eax,%eax
80103401:	75 1b                	jne    8010341e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103403:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010340a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103411:	c1 e0 08             	shl    $0x8,%eax
80103414:	09 d0                	or     %edx,%eax
80103416:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103419:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010341e:	ba 00 04 00 00       	mov    $0x400,%edx
80103423:	e8 38 ff ff ff       	call   80103360 <mpsearch1>
80103428:	85 c0                	test   %eax,%eax
8010342a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010342d:	0f 84 3d 01 00 00    	je     80103570 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103436:	8b 58 04             	mov    0x4(%eax),%ebx
80103439:	85 db                	test   %ebx,%ebx
8010343b:	0f 84 4f 01 00 00    	je     80103590 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103441:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103447:	83 ec 04             	sub    $0x4,%esp
8010344a:	6a 04                	push   $0x4
8010344c:	68 b5 85 10 80       	push   $0x801085b5
80103451:	56                   	push   %esi
80103452:	e8 39 14 00 00       	call   80104890 <memcmp>
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	85 c0                	test   %eax,%eax
8010345c:	0f 85 2e 01 00 00    	jne    80103590 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103462:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103469:	3c 01                	cmp    $0x1,%al
8010346b:	0f 95 c2             	setne  %dl
8010346e:	3c 04                	cmp    $0x4,%al
80103470:	0f 95 c0             	setne  %al
80103473:	20 c2                	and    %al,%dl
80103475:	0f 85 15 01 00 00    	jne    80103590 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010347b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103482:	66 85 ff             	test   %di,%di
80103485:	74 1a                	je     801034a1 <mpinit+0xc1>
80103487:	89 f0                	mov    %esi,%eax
80103489:	01 f7                	add    %esi,%edi
  sum = 0;
8010348b:	31 d2                	xor    %edx,%edx
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103490:	0f b6 08             	movzbl (%eax),%ecx
80103493:	83 c0 01             	add    $0x1,%eax
80103496:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103498:	39 c7                	cmp    %eax,%edi
8010349a:	75 f4                	jne    80103490 <mpinit+0xb0>
8010349c:	84 d2                	test   %dl,%dl
8010349e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801034a1:	85 f6                	test   %esi,%esi
801034a3:	0f 84 e7 00 00 00    	je     80103590 <mpinit+0x1b0>
801034a9:	84 d2                	test   %dl,%dl
801034ab:	0f 85 df 00 00 00    	jne    80103590 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034b7:	a3 bc 37 11 80       	mov    %eax,0x801137bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801034c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ce:	01 d6                	add    %edx,%esi
801034d0:	39 c6                	cmp    %eax,%esi
801034d2:	76 23                	jbe    801034f7 <mpinit+0x117>
    switch(*p){
801034d4:	0f b6 10             	movzbl (%eax),%edx
801034d7:	80 fa 04             	cmp    $0x4,%dl
801034da:	0f 87 ca 00 00 00    	ja     801035aa <mpinit+0x1ca>
801034e0:	ff 24 95 dc 85 10 80 	jmp    *-0x7fef7a24(,%edx,4)
801034e7:	89 f6                	mov    %esi,%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f3:	39 c6                	cmp    %eax,%esi
801034f5:	77 dd                	ja     801034d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034f7:	85 db                	test   %ebx,%ebx
801034f9:	0f 84 9e 00 00 00    	je     8010359d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103502:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103506:	74 15                	je     8010351d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103508:	b8 70 00 00 00       	mov    $0x70,%eax
8010350d:	ba 22 00 00 00       	mov    $0x22,%edx
80103512:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103513:	ba 23 00 00 00       	mov    $0x23,%edx
80103518:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103519:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351c:	ee                   	out    %al,(%dx)
  }
}
8010351d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103520:	5b                   	pop    %ebx
80103521:	5e                   	pop    %esi
80103522:	5f                   	pop    %edi
80103523:	5d                   	pop    %ebp
80103524:	c3                   	ret    
80103525:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103528:	8b 0d 40 3e 11 80    	mov    0x80113e40,%ecx
8010352e:	83 f9 07             	cmp    $0x7,%ecx
80103531:	7f 19                	jg     8010354c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103533:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103537:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010353d:	83 c1 01             	add    $0x1,%ecx
80103540:	89 0d 40 3e 11 80    	mov    %ecx,0x80113e40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103546:	88 97 c0 38 11 80    	mov    %dl,-0x7feec740(%edi)
      p += sizeof(struct mpproc);
8010354c:	83 c0 14             	add    $0x14,%eax
      continue;
8010354f:	e9 7c ff ff ff       	jmp    801034d0 <mpinit+0xf0>
80103554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103558:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010355c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010355f:	88 15 a0 38 11 80    	mov    %dl,0x801138a0
      continue;
80103565:	e9 66 ff ff ff       	jmp    801034d0 <mpinit+0xf0>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103570:	ba 00 00 01 00       	mov    $0x10000,%edx
80103575:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010357a:	e8 e1 fd ff ff       	call   80103360 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010357f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103584:	0f 85 a9 fe ff ff    	jne    80103433 <mpinit+0x53>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	68 9d 85 10 80       	push   $0x8010859d
80103598:	e8 f3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010359d:	83 ec 0c             	sub    $0xc,%esp
801035a0:	68 bc 85 10 80       	push   $0x801085bc
801035a5:	e8 e6 cd ff ff       	call   80100390 <panic>
      ismp = 0;
801035aa:	31 db                	xor    %ebx,%ebx
801035ac:	e9 26 ff ff ff       	jmp    801034d7 <mpinit+0xf7>
801035b1:	66 90                	xchg   %ax,%ax
801035b3:	66 90                	xchg   %ax,%ax
801035b5:	66 90                	xchg   %ax,%ax
801035b7:	66 90                	xchg   %ax,%ax
801035b9:	66 90                	xchg   %ax,%ax
801035bb:	66 90                	xchg   %ax,%ax
801035bd:	66 90                	xchg   %ax,%ax
801035bf:	90                   	nop

801035c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035c0:	55                   	push   %ebp
801035c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c6:	ba 21 00 00 00       	mov    $0x21,%edx
801035cb:	89 e5                	mov    %esp,%ebp
801035cd:	ee                   	out    %al,(%dx)
801035ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801035d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035d4:	5d                   	pop    %ebp
801035d5:	c3                   	ret    
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035fb:	e8 80 d7 ff ff       	call   80100d80 <filealloc>
80103600:	85 c0                	test   %eax,%eax
80103602:	89 03                	mov    %eax,(%ebx)
80103604:	74 22                	je     80103628 <pipealloc+0x48>
80103606:	e8 75 d7 ff ff       	call   80100d80 <filealloc>
8010360b:	85 c0                	test   %eax,%eax
8010360d:	89 06                	mov    %eax,(%esi)
8010360f:	74 3f                	je     80103650 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103611:	e8 4a f2 ff ff       	call   80102860 <kalloc>
80103616:	85 c0                	test   %eax,%eax
80103618:	89 c7                	mov    %eax,%edi
8010361a:	75 54                	jne    80103670 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010361c:	8b 03                	mov    (%ebx),%eax
8010361e:	85 c0                	test   %eax,%eax
80103620:	75 34                	jne    80103656 <pipealloc+0x76>
80103622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103628:	8b 06                	mov    (%esi),%eax
8010362a:	85 c0                	test   %eax,%eax
8010362c:	74 0c                	je     8010363a <pipealloc+0x5a>
    fileclose(*f1);
8010362e:	83 ec 0c             	sub    $0xc,%esp
80103631:	50                   	push   %eax
80103632:	e8 09 d8 ff ff       	call   80100e40 <fileclose>
80103637:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010363a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010363d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103642:	5b                   	pop    %ebx
80103643:	5e                   	pop    %esi
80103644:	5f                   	pop    %edi
80103645:	5d                   	pop    %ebp
80103646:	c3                   	ret    
80103647:	89 f6                	mov    %esi,%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103650:	8b 03                	mov    (%ebx),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 e4                	je     8010363a <pipealloc+0x5a>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 e1 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010365f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103661:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c6                	jne    8010362e <pipealloc+0x4e>
80103668:	eb d0                	jmp    8010363a <pipealloc+0x5a>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103670:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103673:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010367a:	00 00 00 
  p->writeopen = 1;
8010367d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103684:	00 00 00 
  p->nwrite = 0;
80103687:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010368e:	00 00 00 
  p->nread = 0;
80103691:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103698:	00 00 00 
  initlock(&p->lock, "pipe");
8010369b:	68 f0 85 10 80       	push   $0x801085f0
801036a0:	50                   	push   %eax
801036a1:	e8 4a 0f 00 00       	call   801045f0 <initlock>
  (*f0)->type = FD_PIPE;
801036a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801036a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036b1:	8b 03                	mov    (%ebx),%eax
801036b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036b7:	8b 03                	mov    (%ebx),%eax
801036b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036bd:	8b 03                	mov    (%ebx),%eax
801036bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036ca:	8b 06                	mov    (%esi),%eax
801036cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036d0:	8b 06                	mov    (%esi),%eax
801036d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036d6:	8b 06                	mov    (%esi),%eax
801036d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801036db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036de:	31 c0                	xor    %eax,%eax
}
801036e0:	5b                   	pop    %ebx
801036e1:	5e                   	pop    %esi
801036e2:	5f                   	pop    %edi
801036e3:	5d                   	pop    %ebp
801036e4:	c3                   	ret    
801036e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
801036f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	53                   	push   %ebx
801036ff:	e8 2c 10 00 00       	call   80104730 <acquire>
  if(writable){
80103704:	83 c4 10             	add    $0x10,%esp
80103707:	85 f6                	test   %esi,%esi
80103709:	74 45                	je     80103750 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010370b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103711:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103714:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010371b:	00 00 00 
    wakeup(&p->nread);
8010371e:	50                   	push   %eax
8010371f:	e8 bc 0b 00 00       	call   801042e0 <wakeup>
80103724:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103727:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010372d:	85 d2                	test   %edx,%edx
8010372f:	75 0a                	jne    8010373b <pipeclose+0x4b>
80103731:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	74 35                	je     80103770 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010373b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	5b                   	pop    %ebx
80103742:	5e                   	pop    %esi
80103743:	5d                   	pop    %ebp
    release(&p->lock);
80103744:	e9 a7 10 00 00       	jmp    801047f0 <release>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103750:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103756:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103759:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103760:	00 00 00 
    wakeup(&p->nwrite);
80103763:	50                   	push   %eax
80103764:	e8 77 0b 00 00       	call   801042e0 <wakeup>
80103769:	83 c4 10             	add    $0x10,%esp
8010376c:	eb b9                	jmp    80103727 <pipeclose+0x37>
8010376e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	53                   	push   %ebx
80103774:	e8 77 10 00 00       	call   801047f0 <release>
    kfree((char*)p);
80103779:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010377c:	83 c4 10             	add    $0x10,%esp
}
8010377f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103782:	5b                   	pop    %ebx
80103783:	5e                   	pop    %esi
80103784:	5d                   	pop    %ebp
    kfree((char*)p);
80103785:	e9 26 ef ff ff       	jmp    801026b0 <kfree>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103790 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 28             	sub    $0x28,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010379c:	53                   	push   %ebx
8010379d:	e8 8e 0f 00 00       	call   80104730 <acquire>
  for(i = 0; i < n; i++){
801037a2:	8b 45 10             	mov    0x10(%ebp),%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	0f 8e c9 00 00 00    	jle    80103879 <pipewrite+0xe9>
801037b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037c2:	03 4d 10             	add    0x10(%ebp),%ecx
801037c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037d4:	39 d0                	cmp    %edx,%eax
801037d6:	75 71                	jne    80103849 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801037d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037de:	85 c0                	test   %eax,%eax
801037e0:	74 4e                	je     80103830 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037e8:	eb 3a                	jmp    80103824 <pipewrite+0x94>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	57                   	push   %edi
801037f4:	e8 e7 0a 00 00       	call   801042e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037f9:	5a                   	pop    %edx
801037fa:	59                   	pop    %ecx
801037fb:	53                   	push   %ebx
801037fc:	56                   	push   %esi
801037fd:	e8 2e 09 00 00       	call   80104130 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103802:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103808:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	05 00 02 00 00       	add    $0x200,%eax
80103816:	39 c2                	cmp    %eax,%edx
80103818:	75 36                	jne    80103850 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010381a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103820:	85 c0                	test   %eax,%eax
80103822:	74 0c                	je     80103830 <pipewrite+0xa0>
80103824:	e8 67 03 00 00       	call   80103b90 <myproc>
80103829:	8b 40 24             	mov    0x24(%eax),%eax
8010382c:	85 c0                	test   %eax,%eax
8010382e:	74 c0                	je     801037f0 <pipewrite+0x60>
        release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	53                   	push   %ebx
80103834:	e8 b7 0f 00 00       	call   801047f0 <release>
        return -1;
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103844:	5b                   	pop    %ebx
80103845:	5e                   	pop    %esi
80103846:	5f                   	pop    %edi
80103847:	5d                   	pop    %ebp
80103848:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103849:	89 c2                	mov    %eax,%edx
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103850:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103853:	8d 42 01             	lea    0x1(%edx),%eax
80103856:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010385c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103862:	83 c6 01             	add    $0x1,%esi
80103865:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103869:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010386c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010386f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103873:	0f 85 4f ff ff ff    	jne    801037c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103879:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010387f:	83 ec 0c             	sub    $0xc,%esp
80103882:	50                   	push   %eax
80103883:	e8 58 0a 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
80103888:	89 1c 24             	mov    %ebx,(%esp)
8010388b:	e8 60 0f 00 00       	call   801047f0 <release>
  return n;
80103890:	83 c4 10             	add    $0x10,%esp
80103893:	8b 45 10             	mov    0x10(%ebp),%eax
80103896:	eb a9                	jmp    80103841 <pipewrite+0xb1>
80103898:	90                   	nop
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 18             	sub    $0x18,%esp
801038a9:	8b 75 08             	mov    0x8(%ebp),%esi
801038ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038af:	56                   	push   %esi
801038b0:	e8 7b 0e 00 00       	call   80104730 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038c4:	75 6a                	jne    80103930 <piperead+0x90>
801038c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801038cc:	85 db                	test   %ebx,%ebx
801038ce:	0f 84 c4 00 00 00    	je     80103998 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038da:	eb 2d                	jmp    80103909 <piperead+0x69>
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038e0:	83 ec 08             	sub    $0x8,%esp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	e8 46 08 00 00       	call   80104130 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ea:	83 c4 10             	add    $0x10,%esp
801038ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038f9:	75 35                	jne    80103930 <piperead+0x90>
801038fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103901:	85 d2                	test   %edx,%edx
80103903:	0f 84 8f 00 00 00    	je     80103998 <piperead+0xf8>
    if(myproc()->killed){
80103909:	e8 82 02 00 00       	call   80103b90 <myproc>
8010390e:	8b 48 24             	mov    0x24(%eax),%ecx
80103911:	85 c9                	test   %ecx,%ecx
80103913:	74 cb                	je     801038e0 <piperead+0x40>
      release(&p->lock);
80103915:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103918:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010391d:	56                   	push   %esi
8010391e:	e8 cd 0e 00 00       	call   801047f0 <release>
      return -1;
80103923:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103926:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103929:	89 d8                	mov    %ebx,%eax
8010392b:	5b                   	pop    %ebx
8010392c:	5e                   	pop    %esi
8010392d:	5f                   	pop    %edi
8010392e:	5d                   	pop    %ebp
8010392f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103930:	8b 45 10             	mov    0x10(%ebp),%eax
80103933:	85 c0                	test   %eax,%eax
80103935:	7e 61                	jle    80103998 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103937:	31 db                	xor    %ebx,%ebx
80103939:	eb 13                	jmp    8010394e <piperead+0xae>
8010393b:	90                   	nop
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103946:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010394c:	74 1f                	je     8010396d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010394e:	8d 41 01             	lea    0x1(%ecx),%eax
80103951:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103957:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010395d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103962:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103965:	83 c3 01             	add    $0x1,%ebx
80103968:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010396b:	75 d3                	jne    80103940 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103973:	83 ec 0c             	sub    $0xc,%esp
80103976:	50                   	push   %eax
80103977:	e8 64 09 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
8010397c:	89 34 24             	mov    %esi,(%esp)
8010397f:	e8 6c 0e 00 00       	call   801047f0 <release>
  return i;
80103984:	83 c4 10             	add    $0x10,%esp
}
80103987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010398a:	89 d8                	mov    %ebx,%eax
8010398c:	5b                   	pop    %ebx
8010398d:	5e                   	pop    %esi
8010398e:	5f                   	pop    %edi
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103998:	31 db                	xor    %ebx,%ebx
8010399a:	eb d1                	jmp    8010396d <piperead+0xcd>
8010399c:	66 90                	xchg   %ax,%ax
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb 94 3e 11 80       	mov    $0x80113e94,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 60 3e 11 80       	push   $0x80113e60
801039b1:	e8 7a 0d 00 00       	call   80104730 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 14                	jmp    801039cf <allocproc+0x2f>
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	83 c3 7c             	add    $0x7c,%ebx
801039c3:	81 fb 94 5d 11 80    	cmp    $0x80115d94,%ebx
801039c9:	0f 83 89 00 00 00    	jae    80103a58 <allocproc+0xb8>
    if(p->state == UNUSED)
801039cf:	8b 4b 0c             	mov    0xc(%ebx),%ecx
801039d2:	85 c9                	test   %ecx,%ecx
801039d4:	75 ea                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d6:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039db:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039e5:	8d 50 01             	lea    0x1(%eax),%edx
801039e8:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801039eb:	68 60 3e 11 80       	push   $0x80113e60
  p->pid = nextpid++;
801039f0:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039f6:	e8 f5 0d 00 00       	call   801047f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039fb:	e8 60 ee ff ff       	call   80102860 <kalloc>
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	85 c0                	test   %eax,%eax
80103a05:	89 43 08             	mov    %eax,0x8(%ebx)
80103a08:	74 67                	je     80103a71 <allocproc+0xd1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a0a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a10:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a13:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a18:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a1b:	c7 40 14 32 5a 10 80 	movl   $0x80105a32,0x14(%eax)
  p->context = (struct context*)sp;
80103a22:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a25:	6a 14                	push   $0x14
80103a27:	6a 00                	push   $0x0
80103a29:	50                   	push   %eax
80103a2a:	e8 11 0e 00 00       	call   80104840 <memset>
  p->context->eip = (uint)forkret;
80103a2f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a32:	c7 40 10 80 3a 10 80 	movl   $0x80103a80,0x10(%eax)

  procfs_add_proc(p->pid, "/");
80103a39:	58                   	pop    %eax
80103a3a:	5a                   	pop    %edx
80103a3b:	68 f5 85 10 80       	push   $0x801085f5
80103a40:	ff 73 10             	pushl  0x10(%ebx)
80103a43:	e8 e8 39 00 00       	call   80107430 <procfs_add_proc>

  return p;
80103a48:	83 c4 10             	add    $0x10,%esp
}
80103a4b:	89 d8                	mov    %ebx,%eax
80103a4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a50:	c9                   	leave  
80103a51:	c3                   	ret    
80103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a58:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a5b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a5d:	68 60 3e 11 80       	push   $0x80113e60
80103a62:	e8 89 0d 00 00       	call   801047f0 <release>
}
80103a67:	89 d8                	mov    %ebx,%eax
  return 0;
80103a69:	83 c4 10             	add    $0x10,%esp
}
80103a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a6f:	c9                   	leave  
80103a70:	c3                   	ret    
    p->state = UNUSED;
80103a71:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a78:	31 db                	xor    %ebx,%ebx
80103a7a:	eb cf                	jmp    80103a4b <allocproc+0xab>
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a86:	68 60 3e 11 80       	push   $0x80113e60
80103a8b:	e8 60 0d 00 00       	call   801047f0 <release>

  if (first) {
80103a90:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	85 c0                	test   %eax,%eax
80103a9a:	75 04                	jne    80103aa0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a9c:	c9                   	leave  
80103a9d:	c3                   	ret    
80103a9e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103aa3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103aaa:	00 00 00 
    iinit(ROOTDEV);
80103aad:	6a 01                	push   $0x1
80103aaf:	e8 7c db ff ff       	call   80101630 <iinit>
    initlog(ROOTDEV);
80103ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103abb:	e8 e0 f3 ff ff       	call   80102ea0 <initlog>
80103ac0:	83 c4 10             	add    $0x10,%esp
}
80103ac3:	c9                   	leave  
80103ac4:	c3                   	ret    
80103ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <pinit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ad6:	68 f7 85 10 80       	push   $0x801085f7
80103adb:	68 60 3e 11 80       	push   $0x80113e60
80103ae0:	e8 0b 0b 00 00       	call   801045f0 <initlock>
}
80103ae5:	83 c4 10             	add    $0x10,%esp
80103ae8:	c9                   	leave  
80103ae9:	c3                   	ret    
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103af0 <mycpu>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103af5:	9c                   	pushf  
80103af6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103af7:	f6 c4 02             	test   $0x2,%ah
80103afa:	75 5e                	jne    80103b5a <mycpu+0x6a>
  apicid = lapicid();
80103afc:	e8 cf ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b01:	8b 35 40 3e 11 80    	mov    0x80113e40,%esi
80103b07:	85 f6                	test   %esi,%esi
80103b09:	7e 42                	jle    80103b4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b0b:	0f b6 15 c0 38 11 80 	movzbl 0x801138c0,%edx
80103b12:	39 d0                	cmp    %edx,%eax
80103b14:	74 30                	je     80103b46 <mycpu+0x56>
80103b16:	b9 70 39 11 80       	mov    $0x80113970,%ecx
  for (i = 0; i < ncpu; ++i) {
80103b1b:	31 d2                	xor    %edx,%edx
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
80103b20:	83 c2 01             	add    $0x1,%edx
80103b23:	39 f2                	cmp    %esi,%edx
80103b25:	74 26                	je     80103b4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b27:	0f b6 19             	movzbl (%ecx),%ebx
80103b2a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b30:	39 c3                	cmp    %eax,%ebx
80103b32:	75 ec                	jne    80103b20 <mycpu+0x30>
80103b34:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b3a:	05 c0 38 11 80       	add    $0x801138c0,%eax
}
80103b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b42:	5b                   	pop    %ebx
80103b43:	5e                   	pop    %esi
80103b44:	5d                   	pop    %ebp
80103b45:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b46:	b8 c0 38 11 80       	mov    $0x801138c0,%eax
      return &cpus[i];
80103b4b:	eb f2                	jmp    80103b3f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 fe 85 10 80       	push   $0x801085fe
80103b55:	e8 36 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 e8 86 10 80       	push   $0x801086e8
80103b62:	e8 29 c8 ff ff       	call   80100390 <panic>
80103b67:	89 f6                	mov    %esi,%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b70 <cpuid>:
cpuid() {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b76:	e8 75 ff ff ff       	call   80103af0 <mycpu>
80103b7b:	2d c0 38 11 80       	sub    $0x801138c0,%eax
}
80103b80:	c9                   	leave  
  return mycpu()-cpus;
80103b81:	c1 f8 04             	sar    $0x4,%eax
80103b84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b8a:	c3                   	ret    
80103b8b:	90                   	nop
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b90 <myproc>:
myproc(void) {
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b97:	e8 c4 0a 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103b9c:	e8 4f ff ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103ba1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba7:	e8 f4 0a 00 00       	call   801046a0 <popcli>
}
80103bac:	83 c4 04             	add    $0x4,%esp
80103baf:	89 d8                	mov    %ebx,%eax
80103bb1:	5b                   	pop    %ebx
80103bb2:	5d                   	pop    %ebp
80103bb3:	c3                   	ret    
80103bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bc0 <userinit>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bc7:	e8 d4 fd ff ff       	call   801039a0 <allocproc>
80103bcc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bce:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103bd3:	e8 28 34 00 00       	call   80107000 <setupkvm>
80103bd8:	85 c0                	test   %eax,%eax
80103bda:	89 43 04             	mov    %eax,0x4(%ebx)
80103bdd:	0f 84 bd 00 00 00    	je     80103ca0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103be3:	83 ec 04             	sub    $0x4,%esp
80103be6:	68 2c 00 00 00       	push   $0x2c
80103beb:	68 60 b4 10 80       	push   $0x8010b460
80103bf0:	50                   	push   %eax
80103bf1:	e8 ea 30 00 00       	call   80106ce0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bf6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bf9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bff:	6a 4c                	push   $0x4c
80103c01:	6a 00                	push   $0x0
80103c03:	ff 73 18             	pushl  0x18(%ebx)
80103c06:	e8 35 0c 00 00       	call   80104840 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c13:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c18:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c26:	8b 43 18             	mov    0x18(%ebx),%eax
80103c29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c31:	8b 43 18             	mov    0x18(%ebx),%eax
80103c34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c46:	8b 43 18             	mov    0x18(%ebx),%eax
80103c49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c50:	8b 43 18             	mov    0x18(%ebx),%eax
80103c53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c5d:	6a 10                	push   $0x10
80103c5f:	68 27 86 10 80       	push   $0x80108627
80103c64:	50                   	push   %eax
80103c65:	e8 b6 0d 00 00       	call   80104a20 <safestrcpy>
  p->cwd = namei("/");
80103c6a:	c7 04 24 f5 85 10 80 	movl   $0x801085f5,(%esp)
80103c71:	e8 aa e4 ff ff       	call   80102120 <namei>
80103c76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c79:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80103c80:	e8 ab 0a 00 00       	call   80104730 <acquire>
  p->state = RUNNABLE;
80103c85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c8c:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80103c93:	e8 58 0b 00 00       	call   801047f0 <release>
}
80103c98:	83 c4 10             	add    $0x10,%esp
80103c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9e:	c9                   	leave  
80103c9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	68 0e 86 10 80       	push   $0x8010860e
80103ca8:	e8 e3 c6 ff ff       	call   80100390 <panic>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi

80103cb0 <growproc>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
80103cb5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cb8:	e8 a3 09 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103cbd:	e8 2e fe ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103cc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc8:	e8 d3 09 00 00       	call   801046a0 <popcli>
  if(n > 0){
80103ccd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103cd0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cd2:	7f 1c                	jg     80103cf0 <growproc+0x40>
  } else if(n < 0){
80103cd4:	75 3a                	jne    80103d10 <growproc+0x60>
  switchuvm(curproc);
80103cd6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cd9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cdb:	53                   	push   %ebx
80103cdc:	e8 ef 2e 00 00       	call   80106bd0 <switchuvm>
  return 0;
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	31 c0                	xor    %eax,%eax
}
80103ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce9:	5b                   	pop    %ebx
80103cea:	5e                   	pop    %esi
80103ceb:	5d                   	pop    %ebp
80103cec:	c3                   	ret    
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 04             	pushl  0x4(%ebx)
80103cfa:	e8 21 31 00 00       	call   80106e20 <allocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 d0                	jne    80103cd6 <growproc+0x26>
      return -1;
80103d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d0b:	eb d9                	jmp    80103ce6 <growproc+0x36>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d10:	83 ec 04             	sub    $0x4,%esp
80103d13:	01 c6                	add    %eax,%esi
80103d15:	56                   	push   %esi
80103d16:	50                   	push   %eax
80103d17:	ff 73 04             	pushl  0x4(%ebx)
80103d1a:	e8 31 32 00 00       	call   80106f50 <deallocuvm>
80103d1f:	83 c4 10             	add    $0x10,%esp
80103d22:	85 c0                	test   %eax,%eax
80103d24:	75 b0                	jne    80103cd6 <growproc+0x26>
80103d26:	eb de                	jmp    80103d06 <growproc+0x56>
80103d28:	90                   	nop
80103d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d30 <fork>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	57                   	push   %edi
80103d34:	56                   	push   %esi
80103d35:	53                   	push   %ebx
80103d36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d39:	e8 22 09 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103d3e:	e8 ad fd ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103d43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d49:	e8 52 09 00 00       	call   801046a0 <popcli>
  if((np = allocproc()) == 0){
80103d4e:	e8 4d fc ff ff       	call   801039a0 <allocproc>
80103d53:	85 c0                	test   %eax,%eax
80103d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d58:	0f 84 b7 00 00 00    	je     80103e15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d5e:	83 ec 08             	sub    $0x8,%esp
80103d61:	ff 33                	pushl  (%ebx)
80103d63:	ff 73 04             	pushl  0x4(%ebx)
80103d66:	89 c7                	mov    %eax,%edi
80103d68:	e8 63 33 00 00       	call   801070d0 <copyuvm>
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	85 c0                	test   %eax,%eax
80103d72:	89 47 04             	mov    %eax,0x4(%edi)
80103d75:	0f 84 a1 00 00 00    	je     80103e1c <fork+0xec>
  np->sz = curproc->sz;
80103d7b:	8b 03                	mov    (%ebx),%eax
80103d7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d80:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d82:	89 59 14             	mov    %ebx,0x14(%ecx)
80103d85:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103d87:	8b 79 18             	mov    0x18(%ecx),%edi
80103d8a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d8d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d96:	8b 40 18             	mov    0x18(%eax),%eax
80103d99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103da0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103da4:	85 c0                	test   %eax,%eax
80103da6:	74 13                	je     80103dbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103da8:	83 ec 0c             	sub    $0xc,%esp
80103dab:	50                   	push   %eax
80103dac:	e8 3f d0 ff ff       	call   80100df0 <filedup>
80103db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103db4:	83 c4 10             	add    $0x10,%esp
80103db7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dbb:	83 c6 01             	add    $0x1,%esi
80103dbe:	83 fe 10             	cmp    $0x10,%esi
80103dc1:	75 dd                	jne    80103da0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dcc:	e8 2f da ff ff       	call   80101800 <idup>
80103dd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103dd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ddd:	6a 10                	push   $0x10
80103ddf:	53                   	push   %ebx
80103de0:	50                   	push   %eax
80103de1:	e8 3a 0c 00 00       	call   80104a20 <safestrcpy>
  pid = np->pid;
80103de6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103de9:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80103df0:	e8 3b 09 00 00       	call   80104730 <acquire>
  np->state = RUNNABLE;
80103df5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dfc:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80103e03:	e8 e8 09 00 00       	call   801047f0 <release>
  return pid;
80103e08:	83 c4 10             	add    $0x10,%esp
}
80103e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e0e:	89 d8                	mov    %ebx,%eax
80103e10:	5b                   	pop    %ebx
80103e11:	5e                   	pop    %esi
80103e12:	5f                   	pop    %edi
80103e13:	5d                   	pop    %ebp
80103e14:	c3                   	ret    
    return -1;
80103e15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e1a:	eb ef                	jmp    80103e0b <fork+0xdb>
    kfree(np->kstack);
80103e1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e1f:	83 ec 0c             	sub    $0xc,%esp
80103e22:	ff 73 08             	pushl  0x8(%ebx)
80103e25:	e8 86 e8 ff ff       	call   801026b0 <kfree>
    np->kstack = 0;
80103e2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103e31:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e40:	eb c9                	jmp    80103e0b <fork+0xdb>
80103e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <scheduler>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e59:	e8 92 fc ff ff       	call   80103af0 <mycpu>
80103e5e:	8d 78 04             	lea    0x4(%eax),%edi
80103e61:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e63:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e6a:	00 00 00 
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e70:	fb                   	sti    
    acquire(&ptable.lock);
80103e71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e74:	bb 94 3e 11 80       	mov    $0x80113e94,%ebx
    acquire(&ptable.lock);
80103e79:	68 60 3e 11 80       	push   $0x80113e60
80103e7e:	e8 ad 08 00 00       	call   80104730 <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp
80103e86:	8d 76 00             	lea    0x0(%esi),%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103e90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e94:	75 33                	jne    80103ec9 <scheduler+0x79>
      switchuvm(p);
80103e96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e9f:	53                   	push   %ebx
80103ea0:	e8 2b 2d 00 00       	call   80106bd0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ea5:	58                   	pop    %eax
80103ea6:	5a                   	pop    %edx
80103ea7:	ff 73 1c             	pushl  0x1c(%ebx)
80103eaa:	57                   	push   %edi
      p->state = RUNNING;
80103eab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103eb2:	e8 c4 0b 00 00       	call   80104a7b <swtch>
      switchkvm();
80103eb7:	e8 f4 2c 00 00       	call   80106bb0 <switchkvm>
      c->proc = 0;
80103ebc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ec3:	00 00 00 
80103ec6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec9:	83 c3 7c             	add    $0x7c,%ebx
80103ecc:	81 fb 94 5d 11 80    	cmp    $0x80115d94,%ebx
80103ed2:	72 bc                	jb     80103e90 <scheduler+0x40>
    release(&ptable.lock);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 60 3e 11 80       	push   $0x80113e60
80103edc:	e8 0f 09 00 00       	call   801047f0 <release>
    sti();
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	eb 8a                	jmp    80103e70 <scheduler+0x20>
80103ee6:	8d 76 00             	lea    0x0(%esi),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <sched>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 66 07 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103efa:	e8 f1 fb ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103eff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f05:	e8 96 07 00 00       	call   801046a0 <popcli>
  if(!holding(&ptable.lock))
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 60 3e 11 80       	push   $0x80113e60
80103f12:	e8 e9 07 00 00       	call   80104700 <holding>
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 4f                	je     80103f6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f1e:	e8 cd fb ff ff       	call   80103af0 <mycpu>
80103f23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f2a:	75 68                	jne    80103f94 <sched+0xa4>
  if(p->state == RUNNING)
80103f2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f30:	74 55                	je     80103f87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f32:	9c                   	pushf  
80103f33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f34:	f6 c4 02             	test   $0x2,%ah
80103f37:	75 41                	jne    80103f7a <sched+0x8a>
  intena = mycpu()->intena;
80103f39:	e8 b2 fb ff ff       	call   80103af0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f47:	e8 a4 fb ff ff       	call   80103af0 <mycpu>
80103f4c:	83 ec 08             	sub    $0x8,%esp
80103f4f:	ff 70 04             	pushl  0x4(%eax)
80103f52:	53                   	push   %ebx
80103f53:	e8 23 0b 00 00       	call   80104a7b <swtch>
  mycpu()->intena = intena;
80103f58:	e8 93 fb ff ff       	call   80103af0 <mycpu>
}
80103f5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f69:	5b                   	pop    %ebx
80103f6a:	5e                   	pop    %esi
80103f6b:	5d                   	pop    %ebp
80103f6c:	c3                   	ret    
    panic("sched ptable.lock");
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	68 30 86 10 80       	push   $0x80108630
80103f75:	e8 16 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 5c 86 10 80       	push   $0x8010865c
80103f82:	e8 09 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f87:	83 ec 0c             	sub    $0xc,%esp
80103f8a:	68 4e 86 10 80       	push   $0x8010864e
80103f8f:	e8 fc c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	68 42 86 10 80       	push   $0x80108642
80103f9c:	e8 ef c3 ff ff       	call   80100390 <panic>
80103fa1:	eb 0d                	jmp    80103fb0 <exit>
80103fa3:	90                   	nop
80103fa4:	90                   	nop
80103fa5:	90                   	nop
80103fa6:	90                   	nop
80103fa7:	90                   	nop
80103fa8:	90                   	nop
80103fa9:	90                   	nop
80103faa:	90                   	nop
80103fab:	90                   	nop
80103fac:	90                   	nop
80103fad:	90                   	nop
80103fae:	90                   	nop
80103faf:	90                   	nop

80103fb0 <exit>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103fb9:	e8 a2 06 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103fbe:	e8 2d fb ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103fc3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fc9:	e8 d2 06 00 00       	call   801046a0 <popcli>
  if(curproc == initproc)
80103fce:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103fd4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103fd7:	8d 7e 68             	lea    0x68(%esi),%edi
80103fda:	0f 84 f1 00 00 00    	je     801040d1 <exit+0x121>
    if(curproc->ofile[fd]){
80103fe0:	8b 03                	mov    (%ebx),%eax
80103fe2:	85 c0                	test   %eax,%eax
80103fe4:	74 12                	je     80103ff8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	50                   	push   %eax
80103fea:	e8 51 ce ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103fef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ff5:	83 c4 10             	add    $0x10,%esp
80103ff8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103ffb:	39 fb                	cmp    %edi,%ebx
80103ffd:	75 e1                	jne    80103fe0 <exit+0x30>
  begin_op();
80103fff:	e8 3c ef ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	ff 76 68             	pushl  0x68(%esi)
8010400a:	e8 51 d9 ff ff       	call   80101960 <iput>
  end_op();
8010400f:	e8 9c ef ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
80104014:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010401b:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80104022:	e8 09 07 00 00       	call   80104730 <acquire>
  wakeup1(curproc->parent);
80104027:	8b 56 14             	mov    0x14(%esi),%edx
8010402a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402d:	b8 94 3e 11 80       	mov    $0x80113e94,%eax
80104032:	eb 0e                	jmp    80104042 <exit+0x92>
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104038:	83 c0 7c             	add    $0x7c,%eax
8010403b:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
80104040:	73 1c                	jae    8010405e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104042:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104046:	75 f0                	jne    80104038 <exit+0x88>
80104048:	3b 50 20             	cmp    0x20(%eax),%edx
8010404b:	75 eb                	jne    80104038 <exit+0x88>
      p->state = RUNNABLE;
8010404d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104054:	83 c0 7c             	add    $0x7c,%eax
80104057:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
8010405c:	72 e4                	jb     80104042 <exit+0x92>
      p->parent = initproc;
8010405e:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104064:	ba 94 3e 11 80       	mov    $0x80113e94,%edx
80104069:	eb 10                	jmp    8010407b <exit+0xcb>
8010406b:	90                   	nop
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104070:	83 c2 7c             	add    $0x7c,%edx
80104073:	81 fa 94 5d 11 80    	cmp    $0x80115d94,%edx
80104079:	73 33                	jae    801040ae <exit+0xfe>
    if(p->parent == curproc){
8010407b:	39 72 14             	cmp    %esi,0x14(%edx)
8010407e:	75 f0                	jne    80104070 <exit+0xc0>
      if(p->state == ZOMBIE)
80104080:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104084:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104087:	75 e7                	jne    80104070 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104089:	b8 94 3e 11 80       	mov    $0x80113e94,%eax
8010408e:	eb 0a                	jmp    8010409a <exit+0xea>
80104090:	83 c0 7c             	add    $0x7c,%eax
80104093:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
80104098:	73 d6                	jae    80104070 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010409a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010409e:	75 f0                	jne    80104090 <exit+0xe0>
801040a0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040a3:	75 eb                	jne    80104090 <exit+0xe0>
      p->state = RUNNABLE;
801040a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040ac:	eb e2                	jmp    80104090 <exit+0xe0>
  procfs_remove_proc(curproc->pid);
801040ae:	83 ec 0c             	sub    $0xc,%esp
  curproc->state = ZOMBIE;
801040b1:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  procfs_remove_proc(curproc->pid);
801040b8:	ff 76 10             	pushl  0x10(%esi)
801040bb:	e8 c0 33 00 00       	call   80107480 <procfs_remove_proc>
  sched();
801040c0:	e8 2b fe ff ff       	call   80103ef0 <sched>
  panic("zombie exit");
801040c5:	c7 04 24 7d 86 10 80 	movl   $0x8010867d,(%esp)
801040cc:	e8 bf c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040d1:	83 ec 0c             	sub    $0xc,%esp
801040d4:	68 70 86 10 80       	push   $0x80108670
801040d9:	e8 b2 c2 ff ff       	call   80100390 <panic>
801040de:	66 90                	xchg   %ax,%ax

801040e0 <yield>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040e7:	68 60 3e 11 80       	push   $0x80113e60
801040ec:	e8 3f 06 00 00       	call   80104730 <acquire>
  pushcli();
801040f1:	e8 6a 05 00 00       	call   80104660 <pushcli>
  c = mycpu();
801040f6:	e8 f5 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801040fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104101:	e8 9a 05 00 00       	call   801046a0 <popcli>
  myproc()->state = RUNNABLE;
80104106:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010410d:	e8 de fd ff ff       	call   80103ef0 <sched>
  release(&ptable.lock);
80104112:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80104119:	e8 d2 06 00 00       	call   801047f0 <release>
}
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104124:	c9                   	leave  
80104125:	c3                   	ret    
80104126:	8d 76 00             	lea    0x0(%esi),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <sleep>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	8b 7d 08             	mov    0x8(%ebp),%edi
8010413c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010413f:	e8 1c 05 00 00       	call   80104660 <pushcli>
  c = mycpu();
80104144:	e8 a7 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80104149:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010414f:	e8 4c 05 00 00       	call   801046a0 <popcli>
  if(p == 0)
80104154:	85 db                	test   %ebx,%ebx
80104156:	0f 84 87 00 00 00    	je     801041e3 <sleep+0xb3>
  if(lk == 0)
8010415c:	85 f6                	test   %esi,%esi
8010415e:	74 76                	je     801041d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104160:	81 fe 60 3e 11 80    	cmp    $0x80113e60,%esi
80104166:	74 50                	je     801041b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	68 60 3e 11 80       	push   $0x80113e60
80104170:	e8 bb 05 00 00       	call   80104730 <acquire>
    release(lk);
80104175:	89 34 24             	mov    %esi,(%esp)
80104178:	e8 73 06 00 00       	call   801047f0 <release>
  p->chan = chan;
8010417d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104180:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104187:	e8 64 fd ff ff       	call   80103ef0 <sched>
  p->chan = 0;
8010418c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104193:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
8010419a:	e8 51 06 00 00       	call   801047f0 <release>
    acquire(lk);
8010419f:	89 75 08             	mov    %esi,0x8(%ebp)
801041a2:	83 c4 10             	add    $0x10,%esp
}
801041a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a8:	5b                   	pop    %ebx
801041a9:	5e                   	pop    %esi
801041aa:	5f                   	pop    %edi
801041ab:	5d                   	pop    %ebp
    acquire(lk);
801041ac:	e9 7f 05 00 00       	jmp    80104730 <acquire>
801041b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041c2:	e8 29 fd ff ff       	call   80103ef0 <sched>
  p->chan = 0;
801041c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041d1:	5b                   	pop    %ebx
801041d2:	5e                   	pop    %esi
801041d3:	5f                   	pop    %edi
801041d4:	5d                   	pop    %ebp
801041d5:	c3                   	ret    
    panic("sleep without lk");
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	68 8f 86 10 80       	push   $0x8010868f
801041de:	e8 ad c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	68 89 86 10 80       	push   $0x80108689
801041eb:	e8 a0 c1 ff ff       	call   80100390 <panic>

801041f0 <wait>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
  pushcli();
801041f5:	e8 66 04 00 00       	call   80104660 <pushcli>
  c = mycpu();
801041fa:	e8 f1 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801041ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104205:	e8 96 04 00 00       	call   801046a0 <popcli>
  acquire(&ptable.lock);
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 60 3e 11 80       	push   $0x80113e60
80104212:	e8 19 05 00 00       	call   80104730 <acquire>
80104217:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010421a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421c:	bb 94 3e 11 80       	mov    $0x80113e94,%ebx
80104221:	eb 10                	jmp    80104233 <wait+0x43>
80104223:	90                   	nop
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104228:	83 c3 7c             	add    $0x7c,%ebx
8010422b:	81 fb 94 5d 11 80    	cmp    $0x80115d94,%ebx
80104231:	73 1b                	jae    8010424e <wait+0x5e>
      if(p->parent != curproc)
80104233:	39 73 14             	cmp    %esi,0x14(%ebx)
80104236:	75 f0                	jne    80104228 <wait+0x38>
      if(p->state == ZOMBIE){
80104238:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010423c:	74 32                	je     80104270 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104241:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104246:	81 fb 94 5d 11 80    	cmp    $0x80115d94,%ebx
8010424c:	72 e5                	jb     80104233 <wait+0x43>
    if(!havekids || curproc->killed){
8010424e:	85 c0                	test   %eax,%eax
80104250:	74 74                	je     801042c6 <wait+0xd6>
80104252:	8b 46 24             	mov    0x24(%esi),%eax
80104255:	85 c0                	test   %eax,%eax
80104257:	75 6d                	jne    801042c6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104259:	83 ec 08             	sub    $0x8,%esp
8010425c:	68 60 3e 11 80       	push   $0x80113e60
80104261:	56                   	push   %esi
80104262:	e8 c9 fe ff ff       	call   80104130 <sleep>
    havekids = 0;
80104267:	83 c4 10             	add    $0x10,%esp
8010426a:	eb ae                	jmp    8010421a <wait+0x2a>
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104276:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104279:	e8 32 e4 ff ff       	call   801026b0 <kfree>
        freevm(p->pgdir);
8010427e:	5a                   	pop    %edx
8010427f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104282:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104289:	e8 f2 2c 00 00       	call   80106f80 <freevm>
        release(&ptable.lock);
8010428e:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
        p->pid = 0;
80104295:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010429c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042a3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042a7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042b5:	e8 36 05 00 00       	call   801047f0 <release>
        return pid;
801042ba:	83 c4 10             	add    $0x10,%esp
}
801042bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c0:	89 f0                	mov    %esi,%eax
801042c2:	5b                   	pop    %ebx
801042c3:	5e                   	pop    %esi
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
      release(&ptable.lock);
801042c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042ce:	68 60 3e 11 80       	push   $0x80113e60
801042d3:	e8 18 05 00 00       	call   801047f0 <release>
      return -1;
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	eb e0                	jmp    801042bd <wait+0xcd>
801042dd:	8d 76 00             	lea    0x0(%esi),%esi

801042e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ea:	68 60 3e 11 80       	push   $0x80113e60
801042ef:	e8 3c 04 00 00       	call   80104730 <acquire>
801042f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f7:	b8 94 3e 11 80       	mov    $0x80113e94,%eax
801042fc:	eb 0c                	jmp    8010430a <wakeup+0x2a>
801042fe:	66 90                	xchg   %ax,%ax
80104300:	83 c0 7c             	add    $0x7c,%eax
80104303:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
80104308:	73 1c                	jae    80104326 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010430a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010430e:	75 f0                	jne    80104300 <wakeup+0x20>
80104310:	3b 58 20             	cmp    0x20(%eax),%ebx
80104313:	75 eb                	jne    80104300 <wakeup+0x20>
      p->state = RUNNABLE;
80104315:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010431c:	83 c0 7c             	add    $0x7c,%eax
8010431f:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
80104324:	72 e4                	jb     8010430a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104326:	c7 45 08 60 3e 11 80 	movl   $0x80113e60,0x8(%ebp)
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104330:	c9                   	leave  
  release(&ptable.lock);
80104331:	e9 ba 04 00 00       	jmp    801047f0 <release>
80104336:	8d 76 00             	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010434a:	68 60 3e 11 80       	push   $0x80113e60
8010434f:	e8 dc 03 00 00       	call   80104730 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104357:	b8 94 3e 11 80       	mov    $0x80113e94,%eax
8010435c:	eb 0c                	jmp    8010436a <kill+0x2a>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	83 c0 7c             	add    $0x7c,%eax
80104363:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
80104368:	73 36                	jae    801043a0 <kill+0x60>
    if(p->pid == pid){
8010436a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010436d:	75 f1                	jne    80104360 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010436f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104373:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010437a:	75 07                	jne    80104383 <kill+0x43>
        p->state = RUNNABLE;
8010437c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104383:	83 ec 0c             	sub    $0xc,%esp
80104386:	68 60 3e 11 80       	push   $0x80113e60
8010438b:	e8 60 04 00 00       	call   801047f0 <release>
      return 0;
80104390:	83 c4 10             	add    $0x10,%esp
80104393:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104398:	c9                   	leave  
80104399:	c3                   	ret    
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 60 3e 11 80       	push   $0x80113e60
801043a8:	e8 43 04 00 00       	call   801047f0 <release>
  return -1;
801043ad:	83 c4 10             	add    $0x10,%esp
801043b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b8:	c9                   	leave  
801043b9:	c3                   	ret    
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	53                   	push   %ebx
801043c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c9:	bb 94 3e 11 80       	mov    $0x80113e94,%ebx
{
801043ce:	83 ec 3c             	sub    $0x3c,%esp
801043d1:	eb 24                	jmp    801043f7 <procdump+0x37>
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 17 8a 10 80       	push   $0x80108a17
801043e0:	e8 7b c2 ff ff       	call   80100660 <cprintf>
801043e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e8:	83 c3 7c             	add    $0x7c,%ebx
801043eb:	81 fb 94 5d 11 80    	cmp    $0x80115d94,%ebx
801043f1:	0f 83 81 00 00 00    	jae    80104478 <procdump+0xb8>
    if(p->state == UNUSED)
801043f7:	8b 43 0c             	mov    0xc(%ebx),%eax
801043fa:	85 c0                	test   %eax,%eax
801043fc:	74 ea                	je     801043e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043fe:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104401:	ba a0 86 10 80       	mov    $0x801086a0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104406:	77 11                	ja     80104419 <procdump+0x59>
80104408:	8b 14 85 10 87 10 80 	mov    -0x7fef78f0(,%eax,4),%edx
      state = "???";
8010440f:	b8 a0 86 10 80       	mov    $0x801086a0,%eax
80104414:	85 d2                	test   %edx,%edx
80104416:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104419:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010441c:	50                   	push   %eax
8010441d:	52                   	push   %edx
8010441e:	ff 73 10             	pushl  0x10(%ebx)
80104421:	68 a4 86 10 80       	push   $0x801086a4
80104426:	e8 35 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010442b:	83 c4 10             	add    $0x10,%esp
8010442e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104432:	75 a4                	jne    801043d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104434:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104437:	83 ec 08             	sub    $0x8,%esp
8010443a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010443d:	50                   	push   %eax
8010443e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104441:	8b 40 0c             	mov    0xc(%eax),%eax
80104444:	83 c0 08             	add    $0x8,%eax
80104447:	50                   	push   %eax
80104448:	e8 c3 01 00 00       	call   80104610 <getcallerpcs>
8010444d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104450:	8b 17                	mov    (%edi),%edx
80104452:	85 d2                	test   %edx,%edx
80104454:	74 82                	je     801043d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104456:	83 ec 08             	sub    $0x8,%esp
80104459:	83 c7 04             	add    $0x4,%edi
8010445c:	52                   	push   %edx
8010445d:	68 c1 80 10 80       	push   $0x801080c1
80104462:	e8 f9 c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104467:	83 c4 10             	add    $0x10,%esp
8010446a:	39 fe                	cmp    %edi,%esi
8010446c:	75 e2                	jne    80104450 <procdump+0x90>
8010446e:	e9 65 ff ff ff       	jmp    801043d8 <procdump+0x18>
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447b:	5b                   	pop    %ebx
8010447c:	5e                   	pop    %esi
8010447d:	5f                   	pop    %edi
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <find_proc_by_pid>:

struct proc* find_proc_by_pid(int pid) {
80104480:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104481:	b8 94 3e 11 80       	mov    $0x80113e94,%eax
struct proc* find_proc_by_pid(int pid) {
80104486:	89 e5                	mov    %esp,%ebp
80104488:	83 ec 08             	sub    $0x8,%esp
8010448b:	8b 55 08             	mov    0x8(%ebp),%edx
8010448e:	eb 0a                	jmp    8010449a <find_proc_by_pid+0x1a>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104490:	83 c0 7c             	add    $0x7c,%eax
80104493:	3d 94 5d 11 80       	cmp    $0x80115d94,%eax
80104498:	73 0e                	jae    801044a8 <find_proc_by_pid+0x28>
    if (p->pid == pid)
8010449a:	39 50 10             	cmp    %edx,0x10(%eax)
8010449d:	75 f1                	jne    80104490 <find_proc_by_pid+0x10>
      return p;
  }
  panic("didn't find pid");
}
8010449f:	c9                   	leave  
801044a0:	c3                   	ret    
801044a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  panic("didn't find pid");
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	68 ad 86 10 80       	push   $0x801086ad
801044b0:	e8 db be ff ff       	call   80100390 <panic>
801044b5:	66 90                	xchg   %ax,%ax
801044b7:	66 90                	xchg   %ax,%ax
801044b9:	66 90                	xchg   %ax,%ax
801044bb:	66 90                	xchg   %ax,%ax
801044bd:	66 90                	xchg   %ax,%ax
801044bf:	90                   	nop

801044c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ca:	68 28 87 10 80       	push   $0x80108728
801044cf:	8d 43 04             	lea    0x4(%ebx),%eax
801044d2:	50                   	push   %eax
801044d3:	e8 18 01 00 00       	call   801045f0 <initlock>
  lk->name = name;
801044d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	c9                   	leave  
801044f2:	c3                   	ret    
801044f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104508:	83 ec 0c             	sub    $0xc,%esp
8010450b:	8d 73 04             	lea    0x4(%ebx),%esi
8010450e:	56                   	push   %esi
8010450f:	e8 1c 02 00 00       	call   80104730 <acquire>
  while (lk->locked) {
80104514:	8b 13                	mov    (%ebx),%edx
80104516:	83 c4 10             	add    $0x10,%esp
80104519:	85 d2                	test   %edx,%edx
8010451b:	74 16                	je     80104533 <acquiresleep+0x33>
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104520:	83 ec 08             	sub    $0x8,%esp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	e8 06 fc ff ff       	call   80104130 <sleep>
  while (lk->locked) {
8010452a:	8b 03                	mov    (%ebx),%eax
8010452c:	83 c4 10             	add    $0x10,%esp
8010452f:	85 c0                	test   %eax,%eax
80104531:	75 ed                	jne    80104520 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104533:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104539:	e8 52 f6 ff ff       	call   80103b90 <myproc>
8010453e:	8b 40 10             	mov    0x10(%eax),%eax
80104541:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104544:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104547:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010454a:	5b                   	pop    %ebx
8010454b:	5e                   	pop    %esi
8010454c:	5d                   	pop    %ebp
  release(&lk->lk);
8010454d:	e9 9e 02 00 00       	jmp    801047f0 <release>
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	8d 73 04             	lea    0x4(%ebx),%esi
8010456e:	56                   	push   %esi
8010456f:	e8 bc 01 00 00       	call   80104730 <acquire>
  lk->locked = 0;
80104574:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010457a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104581:	89 1c 24             	mov    %ebx,(%esp)
80104584:	e8 57 fd ff ff       	call   801042e0 <wakeup>
  release(&lk->lk);
80104589:	89 75 08             	mov    %esi,0x8(%ebp)
8010458c:	83 c4 10             	add    $0x10,%esp
}
8010458f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104592:	5b                   	pop    %ebx
80104593:	5e                   	pop    %esi
80104594:	5d                   	pop    %ebp
  release(&lk->lk);
80104595:	e9 56 02 00 00       	jmp    801047f0 <release>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	31 ff                	xor    %edi,%edi
801045a8:	83 ec 18             	sub    $0x18,%esp
801045ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045ae:	8d 73 04             	lea    0x4(%ebx),%esi
801045b1:	56                   	push   %esi
801045b2:	e8 79 01 00 00       	call   80104730 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045b7:	8b 03                	mov    (%ebx),%eax
801045b9:	83 c4 10             	add    $0x10,%esp
801045bc:	85 c0                	test   %eax,%eax
801045be:	74 13                	je     801045d3 <holdingsleep+0x33>
801045c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045c3:	e8 c8 f5 ff ff       	call   80103b90 <myproc>
801045c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801045cb:	0f 94 c0             	sete   %al
801045ce:	0f b6 c0             	movzbl %al,%eax
801045d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801045d3:	83 ec 0c             	sub    $0xc,%esp
801045d6:	56                   	push   %esi
801045d7:	e8 14 02 00 00       	call   801047f0 <release>
  return r;
}
801045dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045df:	89 f8                	mov    %edi,%eax
801045e1:	5b                   	pop    %ebx
801045e2:	5e                   	pop    %esi
801045e3:	5f                   	pop    %edi
801045e4:	5d                   	pop    %ebp
801045e5:	c3                   	ret    
801045e6:	66 90                	xchg   %ax,%ax
801045e8:	66 90                	xchg   %ax,%ax
801045ea:	66 90                	xchg   %ax,%ax
801045ec:	66 90                	xchg   %ax,%ax
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104602:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret    
8010460b:	90                   	nop
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104610:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104611:	31 d2                	xor    %edx,%edx
{
80104613:	89 e5                	mov    %esp,%ebp
80104615:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104616:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104619:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010461c:	83 e8 08             	sub    $0x8,%eax
8010461f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104620:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104626:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010462c:	77 1a                	ja     80104648 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010462e:	8b 58 04             	mov    0x4(%eax),%ebx
80104631:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104634:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104637:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104639:	83 fa 0a             	cmp    $0xa,%edx
8010463c:	75 e2                	jne    80104620 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010463e:	5b                   	pop    %ebx
8010463f:	5d                   	pop    %ebp
80104640:	c3                   	ret    
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104648:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010464b:	83 c1 28             	add    $0x28,%ecx
8010464e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104656:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104659:	39 c1                	cmp    %eax,%ecx
8010465b:	75 f3                	jne    80104650 <getcallerpcs+0x40>
}
8010465d:	5b                   	pop    %ebx
8010465e:	5d                   	pop    %ebp
8010465f:	c3                   	ret    

80104660 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 04             	sub    $0x4,%esp
80104667:	9c                   	pushf  
80104668:	5b                   	pop    %ebx
  asm volatile("cli");
80104669:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010466a:	e8 81 f4 ff ff       	call   80103af0 <mycpu>
8010466f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104675:	85 c0                	test   %eax,%eax
80104677:	75 11                	jne    8010468a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104679:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010467f:	e8 6c f4 ff ff       	call   80103af0 <mycpu>
80104684:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010468a:	e8 61 f4 ff ff       	call   80103af0 <mycpu>
8010468f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104696:	83 c4 04             	add    $0x4,%esp
80104699:	5b                   	pop    %ebx
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <popcli>:

void
popcli(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046a6:	9c                   	pushf  
801046a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046a8:	f6 c4 02             	test   $0x2,%ah
801046ab:	75 35                	jne    801046e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046ad:	e8 3e f4 ff ff       	call   80103af0 <mycpu>
801046b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046b9:	78 34                	js     801046ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046bb:	e8 30 f4 ff ff       	call   80103af0 <mycpu>
801046c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046c6:	85 d2                	test   %edx,%edx
801046c8:	74 06                	je     801046d0 <popcli+0x30>
    sti();
}
801046ca:	c9                   	leave  
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046d0:	e8 1b f4 ff ff       	call   80103af0 <mycpu>
801046d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046db:	85 c0                	test   %eax,%eax
801046dd:	74 eb                	je     801046ca <popcli+0x2a>
  asm volatile("sti");
801046df:	fb                   	sti    
}
801046e0:	c9                   	leave  
801046e1:	c3                   	ret    
    panic("popcli - interruptible");
801046e2:	83 ec 0c             	sub    $0xc,%esp
801046e5:	68 33 87 10 80       	push   $0x80108733
801046ea:	e8 a1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046ef:	83 ec 0c             	sub    $0xc,%esp
801046f2:	68 4a 87 10 80       	push   $0x8010874a
801046f7:	e8 94 bc ff ff       	call   80100390 <panic>
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104700 <holding>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 75 08             	mov    0x8(%ebp),%esi
80104708:	31 db                	xor    %ebx,%ebx
  pushcli();
8010470a:	e8 51 ff ff ff       	call   80104660 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010470f:	8b 06                	mov    (%esi),%eax
80104711:	85 c0                	test   %eax,%eax
80104713:	74 10                	je     80104725 <holding+0x25>
80104715:	8b 5e 08             	mov    0x8(%esi),%ebx
80104718:	e8 d3 f3 ff ff       	call   80103af0 <mycpu>
8010471d:	39 c3                	cmp    %eax,%ebx
8010471f:	0f 94 c3             	sete   %bl
80104722:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104725:	e8 76 ff ff ff       	call   801046a0 <popcli>
}
8010472a:	89 d8                	mov    %ebx,%eax
8010472c:	5b                   	pop    %ebx
8010472d:	5e                   	pop    %esi
8010472e:	5d                   	pop    %ebp
8010472f:	c3                   	ret    

80104730 <acquire>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104735:	e8 26 ff ff ff       	call   80104660 <pushcli>
  if(holding(lk))
8010473a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010473d:	83 ec 0c             	sub    $0xc,%esp
80104740:	53                   	push   %ebx
80104741:	e8 ba ff ff ff       	call   80104700 <holding>
80104746:	83 c4 10             	add    $0x10,%esp
80104749:	85 c0                	test   %eax,%eax
8010474b:	0f 85 83 00 00 00    	jne    801047d4 <acquire+0xa4>
80104751:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104753:	ba 01 00 00 00       	mov    $0x1,%edx
80104758:	eb 09                	jmp    80104763 <acquire+0x33>
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104760:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104763:	89 d0                	mov    %edx,%eax
80104765:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104768:	85 c0                	test   %eax,%eax
8010476a:	75 f4                	jne    80104760 <acquire+0x30>
  __sync_synchronize();
8010476c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104771:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104774:	e8 77 f3 ff ff       	call   80103af0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104779:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010477c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010477f:	89 e8                	mov    %ebp,%eax
80104781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104788:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010478e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104794:	77 1a                	ja     801047b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104796:	8b 48 04             	mov    0x4(%eax),%ecx
80104799:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010479c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010479f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047a1:	83 fe 0a             	cmp    $0xa,%esi
801047a4:	75 e2                	jne    80104788 <acquire+0x58>
}
801047a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a9:	5b                   	pop    %ebx
801047aa:	5e                   	pop    %esi
801047ab:	5d                   	pop    %ebp
801047ac:	c3                   	ret    
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
801047b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801047b3:	83 c2 28             	add    $0x28,%edx
801047b6:	8d 76 00             	lea    0x0(%esi),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801047c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801047c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801047c9:	39 d0                	cmp    %edx,%eax
801047cb:	75 f3                	jne    801047c0 <acquire+0x90>
}
801047cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d0:	5b                   	pop    %ebx
801047d1:	5e                   	pop    %esi
801047d2:	5d                   	pop    %ebp
801047d3:	c3                   	ret    
    panic("acquire");
801047d4:	83 ec 0c             	sub    $0xc,%esp
801047d7:	68 51 87 10 80       	push   $0x80108751
801047dc:	e8 af bb ff ff       	call   80100390 <panic>
801047e1:	eb 0d                	jmp    801047f0 <release>
801047e3:	90                   	nop
801047e4:	90                   	nop
801047e5:	90                   	nop
801047e6:	90                   	nop
801047e7:	90                   	nop
801047e8:	90                   	nop
801047e9:	90                   	nop
801047ea:	90                   	nop
801047eb:	90                   	nop
801047ec:	90                   	nop
801047ed:	90                   	nop
801047ee:	90                   	nop
801047ef:	90                   	nop

801047f0 <release>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 10             	sub    $0x10,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801047fa:	53                   	push   %ebx
801047fb:	e8 00 ff ff ff       	call   80104700 <holding>
80104800:	83 c4 10             	add    $0x10,%esp
80104803:	85 c0                	test   %eax,%eax
80104805:	74 22                	je     80104829 <release+0x39>
  lk->pcs[0] = 0;
80104807:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010480e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104815:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010481a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104823:	c9                   	leave  
  popcli();
80104824:	e9 77 fe ff ff       	jmp    801046a0 <popcli>
    panic("release");
80104829:	83 ec 0c             	sub    $0xc,%esp
8010482c:	68 59 87 10 80       	push   $0x80108759
80104831:	e8 5a bb ff ff       	call   80100390 <panic>
80104836:	66 90                	xchg   %ax,%ax
80104838:	66 90                	xchg   %ax,%ax
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	53                   	push   %ebx
80104845:	8b 55 08             	mov    0x8(%ebp),%edx
80104848:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010484b:	f6 c2 03             	test   $0x3,%dl
8010484e:	75 05                	jne    80104855 <memset+0x15>
80104850:	f6 c1 03             	test   $0x3,%cl
80104853:	74 13                	je     80104868 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104855:	89 d7                	mov    %edx,%edi
80104857:	8b 45 0c             	mov    0xc(%ebp),%eax
8010485a:	fc                   	cld    
8010485b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010485d:	5b                   	pop    %ebx
8010485e:	89 d0                	mov    %edx,%eax
80104860:	5f                   	pop    %edi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret    
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104868:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010486c:	c1 e9 02             	shr    $0x2,%ecx
8010486f:	89 f8                	mov    %edi,%eax
80104871:	89 fb                	mov    %edi,%ebx
80104873:	c1 e0 18             	shl    $0x18,%eax
80104876:	c1 e3 10             	shl    $0x10,%ebx
80104879:	09 d8                	or     %ebx,%eax
8010487b:	09 f8                	or     %edi,%eax
8010487d:	c1 e7 08             	shl    $0x8,%edi
80104880:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104882:	89 d7                	mov    %edx,%edi
80104884:	fc                   	cld    
80104885:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104887:	5b                   	pop    %ebx
80104888:	89 d0                	mov    %edx,%eax
8010488a:	5f                   	pop    %edi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	53                   	push   %ebx
80104896:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104899:	8b 75 08             	mov    0x8(%ebp),%esi
8010489c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010489f:	85 db                	test   %ebx,%ebx
801048a1:	74 29                	je     801048cc <memcmp+0x3c>
    if(*s1 != *s2)
801048a3:	0f b6 16             	movzbl (%esi),%edx
801048a6:	0f b6 0f             	movzbl (%edi),%ecx
801048a9:	38 d1                	cmp    %dl,%cl
801048ab:	75 2b                	jne    801048d8 <memcmp+0x48>
801048ad:	b8 01 00 00 00       	mov    $0x1,%eax
801048b2:	eb 14                	jmp    801048c8 <memcmp+0x38>
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048b8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801048bc:	83 c0 01             	add    $0x1,%eax
801048bf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801048c4:	38 ca                	cmp    %cl,%dl
801048c6:	75 10                	jne    801048d8 <memcmp+0x48>
  while(n-- > 0){
801048c8:	39 d8                	cmp    %ebx,%eax
801048ca:	75 ec                	jne    801048b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801048cc:	5b                   	pop    %ebx
  return 0;
801048cd:	31 c0                	xor    %eax,%eax
}
801048cf:	5e                   	pop    %esi
801048d0:	5f                   	pop    %edi
801048d1:	5d                   	pop    %ebp
801048d2:	c3                   	ret    
801048d3:	90                   	nop
801048d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801048d8:	0f b6 c2             	movzbl %dl,%eax
}
801048db:	5b                   	pop    %ebx
      return *s1 - *s2;
801048dc:	29 c8                	sub    %ecx,%eax
}
801048de:	5e                   	pop    %esi
801048df:	5f                   	pop    %edi
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret    
801048e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	8b 45 08             	mov    0x8(%ebp),%eax
801048f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048fe:	39 c3                	cmp    %eax,%ebx
80104900:	73 26                	jae    80104928 <memmove+0x38>
80104902:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104905:	39 c8                	cmp    %ecx,%eax
80104907:	73 1f                	jae    80104928 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104909:	85 f6                	test   %esi,%esi
8010490b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010490e:	74 0f                	je     8010491f <memmove+0x2f>
      *--d = *--s;
80104910:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104914:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104917:	83 ea 01             	sub    $0x1,%edx
8010491a:	83 fa ff             	cmp    $0xffffffff,%edx
8010491d:	75 f1                	jne    80104910 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010491f:	5b                   	pop    %ebx
80104920:	5e                   	pop    %esi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	90                   	nop
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104928:	31 d2                	xor    %edx,%edx
8010492a:	85 f6                	test   %esi,%esi
8010492c:	74 f1                	je     8010491f <memmove+0x2f>
8010492e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104930:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104934:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104937:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010493a:	39 d6                	cmp    %edx,%esi
8010493c:	75 f2                	jne    80104930 <memmove+0x40>
}
8010493e:	5b                   	pop    %ebx
8010493f:	5e                   	pop    %esi
80104940:	5d                   	pop    %ebp
80104941:	c3                   	ret    
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104953:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104954:	eb 9a                	jmp    801048f0 <memmove>
80104956:	8d 76 00             	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104960 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	8b 7d 10             	mov    0x10(%ebp),%edi
80104968:	53                   	push   %ebx
80104969:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010496c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010496f:	85 ff                	test   %edi,%edi
80104971:	74 2f                	je     801049a2 <strncmp+0x42>
80104973:	0f b6 01             	movzbl (%ecx),%eax
80104976:	0f b6 1e             	movzbl (%esi),%ebx
80104979:	84 c0                	test   %al,%al
8010497b:	74 37                	je     801049b4 <strncmp+0x54>
8010497d:	38 c3                	cmp    %al,%bl
8010497f:	75 33                	jne    801049b4 <strncmp+0x54>
80104981:	01 f7                	add    %esi,%edi
80104983:	eb 13                	jmp    80104998 <strncmp+0x38>
80104985:	8d 76 00             	lea    0x0(%esi),%esi
80104988:	0f b6 01             	movzbl (%ecx),%eax
8010498b:	84 c0                	test   %al,%al
8010498d:	74 21                	je     801049b0 <strncmp+0x50>
8010498f:	0f b6 1a             	movzbl (%edx),%ebx
80104992:	89 d6                	mov    %edx,%esi
80104994:	38 d8                	cmp    %bl,%al
80104996:	75 1c                	jne    801049b4 <strncmp+0x54>
    n--, p++, q++;
80104998:	8d 56 01             	lea    0x1(%esi),%edx
8010499b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010499e:	39 fa                	cmp    %edi,%edx
801049a0:	75 e6                	jne    80104988 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801049a2:	5b                   	pop    %ebx
    return 0;
801049a3:	31 c0                	xor    %eax,%eax
}
801049a5:	5e                   	pop    %esi
801049a6:	5f                   	pop    %edi
801049a7:	5d                   	pop    %ebp
801049a8:	c3                   	ret    
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801049b4:	29 d8                	sub    %ebx,%eax
}
801049b6:	5b                   	pop    %ebx
801049b7:	5e                   	pop    %esi
801049b8:	5f                   	pop    %edi
801049b9:	5d                   	pop    %ebp
801049ba:	c3                   	ret    
801049bb:	90                   	nop
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 45 08             	mov    0x8(%ebp),%eax
801049c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049ce:	89 c2                	mov    %eax,%edx
801049d0:	eb 19                	jmp    801049eb <strncpy+0x2b>
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d8:	83 c3 01             	add    $0x1,%ebx
801049db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801049df:	83 c2 01             	add    $0x1,%edx
801049e2:	84 c9                	test   %cl,%cl
801049e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801049e7:	74 09                	je     801049f2 <strncpy+0x32>
801049e9:	89 f1                	mov    %esi,%ecx
801049eb:	85 c9                	test   %ecx,%ecx
801049ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801049f0:	7f e6                	jg     801049d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801049f2:	31 c9                	xor    %ecx,%ecx
801049f4:	85 f6                	test   %esi,%esi
801049f6:	7e 17                	jle    80104a0f <strncpy+0x4f>
801049f8:	90                   	nop
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a00:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104a04:	89 f3                	mov    %esi,%ebx
80104a06:	83 c1 01             	add    $0x1,%ecx
80104a09:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104a0b:	85 db                	test   %ebx,%ebx
80104a0d:	7f f1                	jg     80104a00 <strncpy+0x40>
  return os;
}
80104a0f:	5b                   	pop    %ebx
80104a10:	5e                   	pop    %esi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a28:	8b 45 08             	mov    0x8(%ebp),%eax
80104a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104a2e:	85 c9                	test   %ecx,%ecx
80104a30:	7e 26                	jle    80104a58 <safestrcpy+0x38>
80104a32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104a36:	89 c1                	mov    %eax,%ecx
80104a38:	eb 17                	jmp    80104a51 <safestrcpy+0x31>
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a40:	83 c2 01             	add    $0x1,%edx
80104a43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104a47:	83 c1 01             	add    $0x1,%ecx
80104a4a:	84 db                	test   %bl,%bl
80104a4c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104a4f:	74 04                	je     80104a55 <safestrcpy+0x35>
80104a51:	39 f2                	cmp    %esi,%edx
80104a53:	75 eb                	jne    80104a40 <safestrcpy+0x20>
    ;
  *s = 0;
80104a55:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104a58:	5b                   	pop    %ebx
80104a59:	5e                   	pop    %esi
80104a5a:	5d                   	pop    %ebp
80104a5b:	c3                   	ret    
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a60 <strlen>:

int
strlen(const char *s)
{
80104a60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a61:	31 c0                	xor    %eax,%eax
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a68:	80 3a 00             	cmpb   $0x0,(%edx)
80104a6b:	74 0c                	je     80104a79 <strlen+0x19>
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a77:	75 f7                	jne    80104a70 <strlen+0x10>
    ;
  return n;
}
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    

80104a7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a83:	55                   	push   %ebp
  pushl %ebx
80104a84:	53                   	push   %ebx
  pushl %esi
80104a85:	56                   	push   %esi
  pushl %edi
80104a86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a8b:	5f                   	pop    %edi
  popl %esi
80104a8c:	5e                   	pop    %esi
  popl %ebx
80104a8d:	5b                   	pop    %ebx
  popl %ebp
80104a8e:	5d                   	pop    %ebp
  ret
80104a8f:	c3                   	ret    

80104a90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a9a:	e8 f1 f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a9f:	8b 00                	mov    (%eax),%eax
80104aa1:	39 d8                	cmp    %ebx,%eax
80104aa3:	76 1b                	jbe    80104ac0 <fetchint+0x30>
80104aa5:	8d 53 04             	lea    0x4(%ebx),%edx
80104aa8:	39 d0                	cmp    %edx,%eax
80104aaa:	72 14                	jb     80104ac0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aaf:	8b 13                	mov    (%ebx),%edx
80104ab1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ab3:	31 c0                	xor    %eax,%eax
}
80104ab5:	83 c4 04             	add    $0x4,%esp
80104ab8:	5b                   	pop    %ebx
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    
80104abb:	90                   	nop
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb ee                	jmp    80104ab5 <fetchint+0x25>
80104ac7:	89 f6                	mov    %esi,%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104ada:	e8 b1 f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz)
80104adf:	39 18                	cmp    %ebx,(%eax)
80104ae1:	76 29                	jbe    80104b0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ae3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ae6:	89 da                	mov    %ebx,%edx
80104ae8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104aea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104aec:	39 c3                	cmp    %eax,%ebx
80104aee:	73 1c                	jae    80104b0c <fetchstr+0x3c>
    if(*s == 0)
80104af0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104af3:	75 10                	jne    80104b05 <fetchstr+0x35>
80104af5:	eb 39                	jmp    80104b30 <fetchstr+0x60>
80104af7:	89 f6                	mov    %esi,%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b00:	80 3a 00             	cmpb   $0x0,(%edx)
80104b03:	74 1b                	je     80104b20 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104b05:	83 c2 01             	add    $0x1,%edx
80104b08:	39 d0                	cmp    %edx,%eax
80104b0a:	77 f4                	ja     80104b00 <fetchstr+0x30>
    return -1;
80104b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104b11:	83 c4 04             	add    $0x4,%esp
80104b14:	5b                   	pop    %ebx
80104b15:	5d                   	pop    %ebp
80104b16:	c3                   	ret    
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b20:	83 c4 04             	add    $0x4,%esp
80104b23:	89 d0                	mov    %edx,%eax
80104b25:	29 d8                	sub    %ebx,%eax
80104b27:	5b                   	pop    %ebx
80104b28:	5d                   	pop    %ebp
80104b29:	c3                   	ret    
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104b30:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104b32:	eb dd                	jmp    80104b11 <fetchstr+0x41>
80104b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b45:	e8 46 f0 ff ff       	call   80103b90 <myproc>
80104b4a:	8b 40 18             	mov    0x18(%eax),%eax
80104b4d:	8b 55 08             	mov    0x8(%ebp),%edx
80104b50:	8b 40 44             	mov    0x44(%eax),%eax
80104b53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b56:	e8 35 f0 ff ff       	call   80103b90 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b5b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b5d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b60:	39 c6                	cmp    %eax,%esi
80104b62:	73 1c                	jae    80104b80 <argint+0x40>
80104b64:	8d 53 08             	lea    0x8(%ebx),%edx
80104b67:	39 d0                	cmp    %edx,%eax
80104b69:	72 15                	jb     80104b80 <argint+0x40>
  *ip = *(int*)(addr);
80104b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b71:	89 10                	mov    %edx,(%eax)
  return 0;
80104b73:	31 c0                	xor    %eax,%eax
}
80104b75:	5b                   	pop    %ebx
80104b76:	5e                   	pop    %esi
80104b77:	5d                   	pop    %ebp
80104b78:	c3                   	ret    
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b85:	eb ee                	jmp    80104b75 <argint+0x35>
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
80104b95:	83 ec 10             	sub    $0x10,%esp
80104b98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104b9b:	e8 f0 ef ff ff       	call   80103b90 <myproc>
80104ba0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ba2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ba5:	83 ec 08             	sub    $0x8,%esp
80104ba8:	50                   	push   %eax
80104ba9:	ff 75 08             	pushl  0x8(%ebp)
80104bac:	e8 8f ff ff ff       	call   80104b40 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bb1:	83 c4 10             	add    $0x10,%esp
80104bb4:	85 c0                	test   %eax,%eax
80104bb6:	78 28                	js     80104be0 <argptr+0x50>
80104bb8:	85 db                	test   %ebx,%ebx
80104bba:	78 24                	js     80104be0 <argptr+0x50>
80104bbc:	8b 16                	mov    (%esi),%edx
80104bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc1:	39 c2                	cmp    %eax,%edx
80104bc3:	76 1b                	jbe    80104be0 <argptr+0x50>
80104bc5:	01 c3                	add    %eax,%ebx
80104bc7:	39 da                	cmp    %ebx,%edx
80104bc9:	72 15                	jb     80104be0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bce:	89 02                	mov    %eax,(%edx)
  return 0;
80104bd0:	31 c0                	xor    %eax,%eax
}
80104bd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be5:	eb eb                	jmp    80104bd2 <argptr+0x42>
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bf9:	50                   	push   %eax
80104bfa:	ff 75 08             	pushl  0x8(%ebp)
80104bfd:	e8 3e ff ff ff       	call   80104b40 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 17                	js     80104c20 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104c09:	83 ec 08             	sub    $0x8,%esp
80104c0c:	ff 75 0c             	pushl  0xc(%ebp)
80104c0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c12:	e8 b9 fe ff ff       	call   80104ad0 <fetchstr>
80104c17:	83 c4 10             	add    $0x10,%esp
}
80104c1a:	c9                   	leave  
80104c1b:	c3                   	ret    
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c37:	e8 54 ef ff ff       	call   80103b90 <myproc>
80104c3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c3e:	8b 40 18             	mov    0x18(%eax),%eax
80104c41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c47:	83 fa 14             	cmp    $0x14,%edx
80104c4a:	77 1c                	ja     80104c68 <syscall+0x38>
80104c4c:	8b 14 85 80 87 10 80 	mov    -0x7fef7880(,%eax,4),%edx
80104c53:	85 d2                	test   %edx,%edx
80104c55:	74 11                	je     80104c68 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104c57:	ff d2                	call   *%edx
80104c59:	8b 53 18             	mov    0x18(%ebx),%edx
80104c5c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c62:	c9                   	leave  
80104c63:	c3                   	ret    
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c68:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c69:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c6c:	50                   	push   %eax
80104c6d:	ff 73 10             	pushl  0x10(%ebx)
80104c70:	68 61 87 10 80       	push   $0x80108761
80104c75:	e8 e6 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104c7a:	8b 43 18             	mov    0x18(%ebx),%eax
80104c7d:	83 c4 10             	add    $0x10,%esp
80104c80:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c8a:	c9                   	leave  
80104c8b:	c3                   	ret    
80104c8c:	66 90                	xchg   %ax,%ax
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c96:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104c99:	83 ec 44             	sub    $0x44,%esp
80104c9c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ca2:	56                   	push   %esi
80104ca3:	50                   	push   %eax
{
80104ca4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ca7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104caa:	e8 91 d4 ff ff       	call   80102140 <nameiparent>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	0f 84 46 01 00 00    	je     80104e00 <create+0x170>
    return 0;
  ilock(dp);
80104cba:	83 ec 0c             	sub    $0xc,%esp
80104cbd:	89 c3                	mov    %eax,%ebx
80104cbf:	50                   	push   %eax
80104cc0:	e8 6b cb ff ff       	call   80101830 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104cc5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104cc8:	83 c4 0c             	add    $0xc,%esp
80104ccb:	50                   	push   %eax
80104ccc:	56                   	push   %esi
80104ccd:	53                   	push   %ebx
80104cce:	e8 8d d0 ff ff       	call   80101d60 <dirlookup>
80104cd3:	83 c4 10             	add    $0x10,%esp
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	89 c7                	mov    %eax,%edi
80104cda:	74 34                	je     80104d10 <create+0x80>
    iunlockput(dp);
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	53                   	push   %ebx
80104ce0:	e8 db cd ff ff       	call   80101ac0 <iunlockput>
    ilock(ip);
80104ce5:	89 3c 24             	mov    %edi,(%esp)
80104ce8:	e8 43 cb ff ff       	call   80101830 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ced:	83 c4 10             	add    $0x10,%esp
80104cf0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104cf5:	0f 85 95 00 00 00    	jne    80104d90 <create+0x100>
80104cfb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104d00:	0f 85 8a 00 00 00    	jne    80104d90 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d09:	89 f8                	mov    %edi,%eax
80104d0b:	5b                   	pop    %ebx
80104d0c:	5e                   	pop    %esi
80104d0d:	5f                   	pop    %edi
80104d0e:	5d                   	pop    %ebp
80104d0f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104d10:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104d14:	83 ec 08             	sub    $0x8,%esp
80104d17:	50                   	push   %eax
80104d18:	ff 33                	pushl  (%ebx)
80104d1a:	e8 a1 c9 ff ff       	call   801016c0 <ialloc>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	85 c0                	test   %eax,%eax
80104d24:	89 c7                	mov    %eax,%edi
80104d26:	0f 84 e8 00 00 00    	je     80104e14 <create+0x184>
  ilock(ip);
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	50                   	push   %eax
80104d30:	e8 fb ca ff ff       	call   80101830 <ilock>
  ip->major = major;
80104d35:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104d39:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104d3d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104d41:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104d45:	b8 01 00 00 00       	mov    $0x1,%eax
80104d4a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104d4e:	89 3c 24             	mov    %edi,(%esp)
80104d51:	e8 2a ca ff ff       	call   80101780 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104d5e:	74 50                	je     80104db0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d60:	83 ec 04             	sub    $0x4,%esp
80104d63:	ff 77 04             	pushl  0x4(%edi)
80104d66:	56                   	push   %esi
80104d67:	53                   	push   %ebx
80104d68:	e8 f3 d2 ff ff       	call   80102060 <dirlink>
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	0f 88 8f 00 00 00    	js     80104e07 <create+0x177>
  iunlockput(dp);
80104d78:	83 ec 0c             	sub    $0xc,%esp
80104d7b:	53                   	push   %ebx
80104d7c:	e8 3f cd ff ff       	call   80101ac0 <iunlockput>
  return ip;
80104d81:	83 c4 10             	add    $0x10,%esp
}
80104d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d87:	89 f8                	mov    %edi,%eax
80104d89:	5b                   	pop    %ebx
80104d8a:	5e                   	pop    %esi
80104d8b:	5f                   	pop    %edi
80104d8c:	5d                   	pop    %ebp
80104d8d:	c3                   	ret    
80104d8e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d90:	83 ec 0c             	sub    $0xc,%esp
80104d93:	57                   	push   %edi
    return 0;
80104d94:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104d96:	e8 25 cd ff ff       	call   80101ac0 <iunlockput>
    return 0;
80104d9b:	83 c4 10             	add    $0x10,%esp
}
80104d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da1:	89 f8                	mov    %edi,%eax
80104da3:	5b                   	pop    %ebx
80104da4:	5e                   	pop    %esi
80104da5:	5f                   	pop    %edi
80104da6:	5d                   	pop    %ebp
80104da7:	c3                   	ret    
80104da8:	90                   	nop
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104db0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104db5:	83 ec 0c             	sub    $0xc,%esp
80104db8:	53                   	push   %ebx
80104db9:	e8 c2 c9 ff ff       	call   80101780 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dbe:	83 c4 0c             	add    $0xc,%esp
80104dc1:	ff 77 04             	pushl  0x4(%edi)
80104dc4:	68 f4 87 10 80       	push   $0x801087f4
80104dc9:	57                   	push   %edi
80104dca:	e8 91 d2 ff ff       	call   80102060 <dirlink>
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	78 1c                	js     80104df2 <create+0x162>
80104dd6:	83 ec 04             	sub    $0x4,%esp
80104dd9:	ff 73 04             	pushl  0x4(%ebx)
80104ddc:	68 f3 87 10 80       	push   $0x801087f3
80104de1:	57                   	push   %edi
80104de2:	e8 79 d2 ff ff       	call   80102060 <dirlink>
80104de7:	83 c4 10             	add    $0x10,%esp
80104dea:	85 c0                	test   %eax,%eax
80104dec:	0f 89 6e ff ff ff    	jns    80104d60 <create+0xd0>
      panic("create dots");
80104df2:	83 ec 0c             	sub    $0xc,%esp
80104df5:	68 e7 87 10 80       	push   $0x801087e7
80104dfa:	e8 91 b5 ff ff       	call   80100390 <panic>
80104dff:	90                   	nop
    return 0;
80104e00:	31 ff                	xor    %edi,%edi
80104e02:	e9 ff fe ff ff       	jmp    80104d06 <create+0x76>
    panic("create: dirlink");
80104e07:	83 ec 0c             	sub    $0xc,%esp
80104e0a:	68 f6 87 10 80       	push   $0x801087f6
80104e0f:	e8 7c b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	68 d8 87 10 80       	push   $0x801087d8
80104e1c:	e8 6f b5 ff ff       	call   80100390 <panic>
80104e21:	eb 0d                	jmp    80104e30 <argfd.constprop.0>
80104e23:	90                   	nop
80104e24:	90                   	nop
80104e25:	90                   	nop
80104e26:	90                   	nop
80104e27:	90                   	nop
80104e28:	90                   	nop
80104e29:	90                   	nop
80104e2a:	90                   	nop
80104e2b:	90                   	nop
80104e2c:	90                   	nop
80104e2d:	90                   	nop
80104e2e:	90                   	nop
80104e2f:	90                   	nop

80104e30 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
80104e35:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e37:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e3a:	89 d6                	mov    %edx,%esi
80104e3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e3f:	50                   	push   %eax
80104e40:	6a 00                	push   $0x0
80104e42:	e8 f9 fc ff ff       	call   80104b40 <argint>
80104e47:	83 c4 10             	add    $0x10,%esp
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	78 2a                	js     80104e78 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e52:	77 24                	ja     80104e78 <argfd.constprop.0+0x48>
80104e54:	e8 37 ed ff ff       	call   80103b90 <myproc>
80104e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e5c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104e60:	85 c0                	test   %eax,%eax
80104e62:	74 14                	je     80104e78 <argfd.constprop.0+0x48>
  if(pfd)
80104e64:	85 db                	test   %ebx,%ebx
80104e66:	74 02                	je     80104e6a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e68:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104e6a:	89 06                	mov    %eax,(%esi)
  return 0;
80104e6c:	31 c0                	xor    %eax,%eax
}
80104e6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e71:	5b                   	pop    %ebx
80104e72:	5e                   	pop    %esi
80104e73:	5d                   	pop    %ebp
80104e74:	c3                   	ret    
80104e75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7d:	eb ef                	jmp    80104e6e <argfd.constprop.0+0x3e>
80104e7f:	90                   	nop

80104e80 <sys_dup>:
{
80104e80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e81:	31 c0                	xor    %eax,%eax
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	56                   	push   %esi
80104e86:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104e87:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104e8a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e8d:	e8 9e ff ff ff       	call   80104e30 <argfd.constprop.0>
80104e92:	85 c0                	test   %eax,%eax
80104e94:	78 42                	js     80104ed8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104e96:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e99:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e9b:	e8 f0 ec ff ff       	call   80103b90 <myproc>
80104ea0:	eb 0e                	jmp    80104eb0 <sys_dup+0x30>
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ea8:	83 c3 01             	add    $0x1,%ebx
80104eab:	83 fb 10             	cmp    $0x10,%ebx
80104eae:	74 28                	je     80104ed8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104eb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104eb4:	85 d2                	test   %edx,%edx
80104eb6:	75 f0                	jne    80104ea8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104eb8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ec2:	e8 29 bf ff ff       	call   80100df0 <filedup>
  return fd;
80104ec7:	83 c4 10             	add    $0x10,%esp
}
80104eca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ecd:	89 d8                	mov    %ebx,%eax
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret    
80104ed3:	90                   	nop
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ed8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104edb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ee0:	89 d8                	mov    %ebx,%eax
80104ee2:	5b                   	pop    %ebx
80104ee3:	5e                   	pop    %esi
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    
80104ee6:	8d 76 00             	lea    0x0(%esi),%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <sys_read>:
{
80104ef0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef1:	31 c0                	xor    %eax,%eax
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104efb:	e8 30 ff ff ff       	call   80104e30 <argfd.constprop.0>
80104f00:	85 c0                	test   %eax,%eax
80104f02:	78 4c                	js     80104f50 <sys_read+0x60>
80104f04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f07:	83 ec 08             	sub    $0x8,%esp
80104f0a:	50                   	push   %eax
80104f0b:	6a 02                	push   $0x2
80104f0d:	e8 2e fc ff ff       	call   80104b40 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 37                	js     80104f50 <sys_read+0x60>
80104f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1c:	83 ec 04             	sub    $0x4,%esp
80104f1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f22:	50                   	push   %eax
80104f23:	6a 01                	push   $0x1
80104f25:	e8 66 fc ff ff       	call   80104b90 <argptr>
80104f2a:	83 c4 10             	add    $0x10,%esp
80104f2d:	85 c0                	test   %eax,%eax
80104f2f:	78 1f                	js     80104f50 <sys_read+0x60>
  return fileread(f, p, n);
80104f31:	83 ec 04             	sub    $0x4,%esp
80104f34:	ff 75 f0             	pushl  -0x10(%ebp)
80104f37:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f3d:	e8 1e c0 ff ff       	call   80100f60 <fileread>
80104f42:	83 c4 10             	add    $0x10,%esp
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <sys_write>:
{
80104f60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f61:	31 c0                	xor    %eax,%eax
{
80104f63:	89 e5                	mov    %esp,%ebp
80104f65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f6b:	e8 c0 fe ff ff       	call   80104e30 <argfd.constprop.0>
80104f70:	85 c0                	test   %eax,%eax
80104f72:	78 4c                	js     80104fc0 <sys_write+0x60>
80104f74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f77:	83 ec 08             	sub    $0x8,%esp
80104f7a:	50                   	push   %eax
80104f7b:	6a 02                	push   $0x2
80104f7d:	e8 be fb ff ff       	call   80104b40 <argint>
80104f82:	83 c4 10             	add    $0x10,%esp
80104f85:	85 c0                	test   %eax,%eax
80104f87:	78 37                	js     80104fc0 <sys_write+0x60>
80104f89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f8c:	83 ec 04             	sub    $0x4,%esp
80104f8f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f92:	50                   	push   %eax
80104f93:	6a 01                	push   $0x1
80104f95:	e8 f6 fb ff ff       	call   80104b90 <argptr>
80104f9a:	83 c4 10             	add    $0x10,%esp
80104f9d:	85 c0                	test   %eax,%eax
80104f9f:	78 1f                	js     80104fc0 <sys_write+0x60>
  return filewrite(f, p, n);
80104fa1:	83 ec 04             	sub    $0x4,%esp
80104fa4:	ff 75 f0             	pushl  -0x10(%ebp)
80104fa7:	ff 75 f4             	pushl  -0xc(%ebp)
80104faa:	ff 75 ec             	pushl  -0x14(%ebp)
80104fad:	e8 3e c0 ff ff       	call   80100ff0 <filewrite>
80104fb2:	83 c4 10             	add    $0x10,%esp
}
80104fb5:	c9                   	leave  
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <sys_close>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104fd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104fd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fdc:	e8 4f fe ff ff       	call   80104e30 <argfd.constprop.0>
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 2b                	js     80105010 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104fe5:	e8 a6 eb ff ff       	call   80103b90 <myproc>
80104fea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104fed:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ff0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ff7:	00 
  fileclose(f);
80104ff8:	ff 75 f4             	pushl  -0xc(%ebp)
80104ffb:	e8 40 be ff ff       	call   80100e40 <fileclose>
  return 0;
80105000:	83 c4 10             	add    $0x10,%esp
80105003:	31 c0                	xor    %eax,%eax
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_fstat>:
{
80105020:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105021:	31 c0                	xor    %eax,%eax
{
80105023:	89 e5                	mov    %esp,%ebp
80105025:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105028:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010502b:	e8 00 fe ff ff       	call   80104e30 <argfd.constprop.0>
80105030:	85 c0                	test   %eax,%eax
80105032:	78 2c                	js     80105060 <sys_fstat+0x40>
80105034:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105037:	83 ec 04             	sub    $0x4,%esp
8010503a:	6a 14                	push   $0x14
8010503c:	50                   	push   %eax
8010503d:	6a 01                	push   $0x1
8010503f:	e8 4c fb ff ff       	call   80104b90 <argptr>
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	85 c0                	test   %eax,%eax
80105049:	78 15                	js     80105060 <sys_fstat+0x40>
  return filestat(f, st);
8010504b:	83 ec 08             	sub    $0x8,%esp
8010504e:	ff 75 f4             	pushl  -0xc(%ebp)
80105051:	ff 75 f0             	pushl  -0x10(%ebp)
80105054:	e8 b7 be ff ff       	call   80100f10 <filestat>
80105059:	83 c4 10             	add    $0x10,%esp
}
8010505c:	c9                   	leave  
8010505d:	c3                   	ret    
8010505e:	66 90                	xchg   %ax,%ax
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105065:	c9                   	leave  
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <sys_link>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105076:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105079:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 6c fb ff ff       	call   80104bf0 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 fb 00 00 00    	js     8010518a <sys_link+0x11a>
8010508f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105092:	83 ec 08             	sub    $0x8,%esp
80105095:	50                   	push   %eax
80105096:	6a 01                	push   $0x1
80105098:	e8 53 fb ff ff       	call   80104bf0 <argstr>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	0f 88 e2 00 00 00    	js     8010518a <sys_link+0x11a>
  begin_op();
801050a8:	e8 93 de ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
801050ad:	83 ec 0c             	sub    $0xc,%esp
801050b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801050b3:	e8 68 d0 ff ff       	call   80102120 <namei>
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	85 c0                	test   %eax,%eax
801050bd:	89 c3                	mov    %eax,%ebx
801050bf:	0f 84 ea 00 00 00    	je     801051af <sys_link+0x13f>
  ilock(ip);
801050c5:	83 ec 0c             	sub    $0xc,%esp
801050c8:	50                   	push   %eax
801050c9:	e8 62 c7 ff ff       	call   80101830 <ilock>
  if(ip->type == T_DIR){
801050ce:	83 c4 10             	add    $0x10,%esp
801050d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050d6:	0f 84 bb 00 00 00    	je     80105197 <sys_link+0x127>
  ip->nlink++;
801050dc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801050e1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801050e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050e7:	53                   	push   %ebx
801050e8:	e8 93 c6 ff ff       	call   80101780 <iupdate>
  iunlock(ip);
801050ed:	89 1c 24             	mov    %ebx,(%esp)
801050f0:	e8 1b c8 ff ff       	call   80101910 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050f5:	58                   	pop    %eax
801050f6:	5a                   	pop    %edx
801050f7:	57                   	push   %edi
801050f8:	ff 75 d0             	pushl  -0x30(%ebp)
801050fb:	e8 40 d0 ff ff       	call   80102140 <nameiparent>
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	85 c0                	test   %eax,%eax
80105105:	89 c6                	mov    %eax,%esi
80105107:	74 5b                	je     80105164 <sys_link+0xf4>
  ilock(dp);
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	50                   	push   %eax
8010510d:	e8 1e c7 ff ff       	call   80101830 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105112:	83 c4 10             	add    $0x10,%esp
80105115:	8b 03                	mov    (%ebx),%eax
80105117:	39 06                	cmp    %eax,(%esi)
80105119:	75 3d                	jne    80105158 <sys_link+0xe8>
8010511b:	83 ec 04             	sub    $0x4,%esp
8010511e:	ff 73 04             	pushl  0x4(%ebx)
80105121:	57                   	push   %edi
80105122:	56                   	push   %esi
80105123:	e8 38 cf ff ff       	call   80102060 <dirlink>
80105128:	83 c4 10             	add    $0x10,%esp
8010512b:	85 c0                	test   %eax,%eax
8010512d:	78 29                	js     80105158 <sys_link+0xe8>
  iunlockput(dp);
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	56                   	push   %esi
80105133:	e8 88 c9 ff ff       	call   80101ac0 <iunlockput>
  iput(ip);
80105138:	89 1c 24             	mov    %ebx,(%esp)
8010513b:	e8 20 c8 ff ff       	call   80101960 <iput>
  end_op();
80105140:	e8 6b de ff ff       	call   80102fb0 <end_op>
  return 0;
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	31 c0                	xor    %eax,%eax
}
8010514a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010514d:	5b                   	pop    %ebx
8010514e:	5e                   	pop    %esi
8010514f:	5f                   	pop    %edi
80105150:	5d                   	pop    %ebp
80105151:	c3                   	ret    
80105152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	56                   	push   %esi
8010515c:	e8 5f c9 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80105161:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	53                   	push   %ebx
80105168:	e8 c3 c6 ff ff       	call   80101830 <ilock>
  ip->nlink--;
8010516d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105172:	89 1c 24             	mov    %ebx,(%esp)
80105175:	e8 06 c6 ff ff       	call   80101780 <iupdate>
  iunlockput(ip);
8010517a:	89 1c 24             	mov    %ebx,(%esp)
8010517d:	e8 3e c9 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105182:	e8 29 de ff ff       	call   80102fb0 <end_op>
  return -1;
80105187:	83 c4 10             	add    $0x10,%esp
}
8010518a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010518d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105192:	5b                   	pop    %ebx
80105193:	5e                   	pop    %esi
80105194:	5f                   	pop    %edi
80105195:	5d                   	pop    %ebp
80105196:	c3                   	ret    
    iunlockput(ip);
80105197:	83 ec 0c             	sub    $0xc,%esp
8010519a:	53                   	push   %ebx
8010519b:	e8 20 c9 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801051a0:	e8 0b de ff ff       	call   80102fb0 <end_op>
    return -1;
801051a5:	83 c4 10             	add    $0x10,%esp
801051a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ad:	eb 9b                	jmp    8010514a <sys_link+0xda>
    end_op();
801051af:	e8 fc dd ff ff       	call   80102fb0 <end_op>
    return -1;
801051b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b9:	eb 8f                	jmp    8010514a <sys_link+0xda>
801051bb:	90                   	nop
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <sys_unlink>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
801051c5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801051c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051c9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 1c fa ff ff       	call   80104bf0 <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	0f 88 77 01 00 00    	js     80105356 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801051df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801051e2:	e8 59 dd ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	53                   	push   %ebx
801051eb:	ff 75 c0             	pushl  -0x40(%ebp)
801051ee:	e8 4d cf ff ff       	call   80102140 <nameiparent>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	89 c6                	mov    %eax,%esi
801051fa:	0f 84 60 01 00 00    	je     80105360 <sys_unlink+0x1a0>
  ilock(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	50                   	push   %eax
80105204:	e8 27 c6 ff ff       	call   80101830 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105209:	58                   	pop    %eax
8010520a:	5a                   	pop    %edx
8010520b:	68 f4 87 10 80       	push   $0x801087f4
80105210:	53                   	push   %ebx
80105211:	e8 2a cb ff ff       	call   80101d40 <namecmp>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	85 c0                	test   %eax,%eax
8010521b:	0f 84 03 01 00 00    	je     80105324 <sys_unlink+0x164>
80105221:	83 ec 08             	sub    $0x8,%esp
80105224:	68 f3 87 10 80       	push   $0x801087f3
80105229:	53                   	push   %ebx
8010522a:	e8 11 cb ff ff       	call   80101d40 <namecmp>
8010522f:	83 c4 10             	add    $0x10,%esp
80105232:	85 c0                	test   %eax,%eax
80105234:	0f 84 ea 00 00 00    	je     80105324 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010523a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010523d:	83 ec 04             	sub    $0x4,%esp
80105240:	50                   	push   %eax
80105241:	53                   	push   %ebx
80105242:	56                   	push   %esi
80105243:	e8 18 cb ff ff       	call   80101d60 <dirlookup>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	89 c3                	mov    %eax,%ebx
8010524f:	0f 84 cf 00 00 00    	je     80105324 <sys_unlink+0x164>
  ilock(ip);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	50                   	push   %eax
80105259:	e8 d2 c5 ff ff       	call   80101830 <ilock>
  if(ip->nlink < 1)
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105266:	0f 8e 10 01 00 00    	jle    8010537c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010526c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105271:	74 6d                	je     801052e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105273:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105276:	83 ec 04             	sub    $0x4,%esp
80105279:	6a 10                	push   $0x10
8010527b:	6a 00                	push   $0x0
8010527d:	50                   	push   %eax
8010527e:	e8 bd f5 ff ff       	call   80104840 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105283:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105286:	6a 10                	push   $0x10
80105288:	ff 75 c4             	pushl  -0x3c(%ebp)
8010528b:	50                   	push   %eax
8010528c:	56                   	push   %esi
8010528d:	e8 7e c9 ff ff       	call   80101c10 <writei>
80105292:	83 c4 20             	add    $0x20,%esp
80105295:	83 f8 10             	cmp    $0x10,%eax
80105298:	0f 85 eb 00 00 00    	jne    80105389 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010529e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a3:	0f 84 97 00 00 00    	je     80105340 <sys_unlink+0x180>
  iunlockput(dp);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	56                   	push   %esi
801052ad:	e8 0e c8 ff ff       	call   80101ac0 <iunlockput>
  ip->nlink--;
801052b2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b7:	89 1c 24             	mov    %ebx,(%esp)
801052ba:	e8 c1 c4 ff ff       	call   80101780 <iupdate>
  iunlockput(ip);
801052bf:	89 1c 24             	mov    %ebx,(%esp)
801052c2:	e8 f9 c7 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801052c7:	e8 e4 dc ff ff       	call   80102fb0 <end_op>
  return 0;
801052cc:	83 c4 10             	add    $0x10,%esp
801052cf:	31 c0                	xor    %eax,%eax
}
801052d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d4:	5b                   	pop    %ebx
801052d5:	5e                   	pop    %esi
801052d6:	5f                   	pop    %edi
801052d7:	5d                   	pop    %ebp
801052d8:	c3                   	ret    
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052e4:	76 8d                	jbe    80105273 <sys_unlink+0xb3>
801052e6:	bf 20 00 00 00       	mov    $0x20,%edi
801052eb:	eb 0f                	jmp    801052fc <sys_unlink+0x13c>
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
801052f0:	83 c7 10             	add    $0x10,%edi
801052f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801052f6:	0f 83 77 ff ff ff    	jae    80105273 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052ff:	6a 10                	push   $0x10
80105301:	57                   	push   %edi
80105302:	50                   	push   %eax
80105303:	53                   	push   %ebx
80105304:	e8 07 c8 ff ff       	call   80101b10 <readi>
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	83 f8 10             	cmp    $0x10,%eax
8010530f:	75 5e                	jne    8010536f <sys_unlink+0x1af>
    if(de.inum != 0)
80105311:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105316:	74 d8                	je     801052f0 <sys_unlink+0x130>
    iunlockput(ip);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	53                   	push   %ebx
8010531c:	e8 9f c7 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80105321:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105324:	83 ec 0c             	sub    $0xc,%esp
80105327:	56                   	push   %esi
80105328:	e8 93 c7 ff ff       	call   80101ac0 <iunlockput>
  end_op();
8010532d:	e8 7e dc ff ff       	call   80102fb0 <end_op>
  return -1;
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533a:	eb 95                	jmp    801052d1 <sys_unlink+0x111>
8010533c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105340:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105345:	83 ec 0c             	sub    $0xc,%esp
80105348:	56                   	push   %esi
80105349:	e8 32 c4 ff ff       	call   80101780 <iupdate>
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	e9 53 ff ff ff       	jmp    801052a9 <sys_unlink+0xe9>
    return -1;
80105356:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535b:	e9 71 ff ff ff       	jmp    801052d1 <sys_unlink+0x111>
    end_op();
80105360:	e8 4b dc ff ff       	call   80102fb0 <end_op>
    return -1;
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536a:	e9 62 ff ff ff       	jmp    801052d1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	68 18 88 10 80       	push   $0x80108818
80105377:	e8 14 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	68 06 88 10 80       	push   $0x80108806
80105384:	e8 07 b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105389:	83 ec 0c             	sub    $0xc,%esp
8010538c:	68 2a 88 10 80       	push   $0x8010882a
80105391:	e8 fa af ff ff       	call   80100390 <panic>
80105396:	8d 76 00             	lea    0x0(%esi),%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_open>:

int
sys_open(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 3c f8 ff ff       	call   80104bf0 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 1d 01 00 00    	js     801054dc <sys_open+0x13c>
801053bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c2:	83 ec 08             	sub    $0x8,%esp
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 73 f7 ff ff       	call   80104b40 <argint>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	0f 88 04 01 00 00    	js     801054dc <sys_open+0x13c>
    return -1;

  begin_op();
801053d8:	e8 63 db ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801053dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053e1:	0f 85 a9 00 00 00    	jne    80105490 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053e7:	83 ec 0c             	sub    $0xc,%esp
801053ea:	ff 75 e0             	pushl  -0x20(%ebp)
801053ed:	e8 2e cd ff ff       	call   80102120 <namei>
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	85 c0                	test   %eax,%eax
801053f7:	89 c6                	mov    %eax,%esi
801053f9:	0f 84 b2 00 00 00    	je     801054b1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	50                   	push   %eax
80105403:	e8 28 c4 ff ff       	call   80101830 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105410:	0f 84 aa 00 00 00    	je     801054c0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105416:	e8 65 b9 ff ff       	call   80100d80 <filealloc>
8010541b:	85 c0                	test   %eax,%eax
8010541d:	89 c7                	mov    %eax,%edi
8010541f:	0f 84 a6 00 00 00    	je     801054cb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105425:	e8 66 e7 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010542a:	31 db                	xor    %ebx,%ebx
8010542c:	eb 0e                	jmp    8010543c <sys_open+0x9c>
8010542e:	66 90                	xchg   %ax,%ax
80105430:	83 c3 01             	add    $0x1,%ebx
80105433:	83 fb 10             	cmp    $0x10,%ebx
80105436:	0f 84 ac 00 00 00    	je     801054e8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010543c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105440:	85 d2                	test   %edx,%edx
80105442:	75 ec                	jne    80105430 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105444:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105447:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010544b:	56                   	push   %esi
8010544c:	e8 bf c4 ff ff       	call   80101910 <iunlock>
  end_op();
80105451:	e8 5a db ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
80105456:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010545c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010545f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105462:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105465:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010546c:	89 d0                	mov    %edx,%eax
8010546e:	f7 d0                	not    %eax
80105470:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105473:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105476:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105479:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010547d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105480:	89 d8                	mov    %ebx,%eax
80105482:	5b                   	pop    %ebx
80105483:	5e                   	pop    %esi
80105484:	5f                   	pop    %edi
80105485:	5d                   	pop    %ebp
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105496:	31 c9                	xor    %ecx,%ecx
80105498:	6a 00                	push   $0x0
8010549a:	ba 02 00 00 00       	mov    $0x2,%edx
8010549f:	e8 ec f7 ff ff       	call   80104c90 <create>
    if(ip == 0){
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801054a9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054ab:	0f 85 65 ff ff ff    	jne    80105416 <sys_open+0x76>
      end_op();
801054b1:	e8 fa da ff ff       	call   80102fb0 <end_op>
      return -1;
801054b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054bb:	eb c0                	jmp    8010547d <sys_open+0xdd>
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801054c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054c3:	85 c9                	test   %ecx,%ecx
801054c5:	0f 84 4b ff ff ff    	je     80105416 <sys_open+0x76>
    iunlockput(ip);
801054cb:	83 ec 0c             	sub    $0xc,%esp
801054ce:	56                   	push   %esi
801054cf:	e8 ec c5 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801054d4:	e8 d7 da ff ff       	call   80102fb0 <end_op>
    return -1;
801054d9:	83 c4 10             	add    $0x10,%esp
801054dc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054e1:	eb 9a                	jmp    8010547d <sys_open+0xdd>
801054e3:	90                   	nop
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801054e8:	83 ec 0c             	sub    $0xc,%esp
801054eb:	57                   	push   %edi
801054ec:	e8 4f b9 ff ff       	call   80100e40 <fileclose>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	eb d5                	jmp    801054cb <sys_open+0x12b>
801054f6:	8d 76 00             	lea    0x0(%esi),%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_mkdir>:

int
sys_mkdir(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105506:	e8 35 da ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010550b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550e:	83 ec 08             	sub    $0x8,%esp
80105511:	50                   	push   %eax
80105512:	6a 00                	push   $0x0
80105514:	e8 d7 f6 ff ff       	call   80104bf0 <argstr>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	85 c0                	test   %eax,%eax
8010551e:	78 30                	js     80105550 <sys_mkdir+0x50>
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105526:	31 c9                	xor    %ecx,%ecx
80105528:	6a 00                	push   $0x0
8010552a:	ba 01 00 00 00       	mov    $0x1,%edx
8010552f:	e8 5c f7 ff ff       	call   80104c90 <create>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	74 15                	je     80105550 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010553b:	83 ec 0c             	sub    $0xc,%esp
8010553e:	50                   	push   %eax
8010553f:	e8 7c c5 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105544:	e8 67 da ff ff       	call   80102fb0 <end_op>
  return 0;
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	31 c0                	xor    %eax,%eax
}
8010554e:	c9                   	leave  
8010554f:	c3                   	ret    
    end_op();
80105550:	e8 5b da ff ff       	call   80102fb0 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010555a:	c9                   	leave  
8010555b:	c3                   	ret    
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_mknod>:

int
sys_mknod(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105566:	e8 d5 d9 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010556b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010556e:	83 ec 08             	sub    $0x8,%esp
80105571:	50                   	push   %eax
80105572:	6a 00                	push   $0x0
80105574:	e8 77 f6 ff ff       	call   80104bf0 <argstr>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	85 c0                	test   %eax,%eax
8010557e:	78 60                	js     801055e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105580:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105583:	83 ec 08             	sub    $0x8,%esp
80105586:	50                   	push   %eax
80105587:	6a 01                	push   $0x1
80105589:	e8 b2 f5 ff ff       	call   80104b40 <argint>
  if((argstr(0, &path)) < 0 ||
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 4b                	js     801055e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105595:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105598:	83 ec 08             	sub    $0x8,%esp
8010559b:	50                   	push   %eax
8010559c:	6a 02                	push   $0x2
8010559e:	e8 9d f5 ff ff       	call   80104b40 <argint>
     argint(1, &major) < 0 ||
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 36                	js     801055e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801055ae:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801055b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801055b5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ba:	50                   	push   %eax
801055bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055be:	e8 cd f6 ff ff       	call   80104c90 <create>
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 16                	je     801055e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ca:	83 ec 0c             	sub    $0xc,%esp
801055cd:	50                   	push   %eax
801055ce:	e8 ed c4 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801055d3:	e8 d8 d9 ff ff       	call   80102fb0 <end_op>
  return 0;
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	31 c0                	xor    %eax,%eax
}
801055dd:	c9                   	leave  
801055de:	c3                   	ret    
801055df:	90                   	nop
    end_op();
801055e0:	e8 cb d9 ff ff       	call   80102fb0 <end_op>
    return -1;
801055e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ea:	c9                   	leave  
801055eb:	c3                   	ret    
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_chdir>:

int
sys_chdir(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
801055f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055f8:	e8 93 e5 ff ff       	call   80103b90 <myproc>
801055fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055ff:	e8 3c d9 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105604:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105607:	83 ec 08             	sub    $0x8,%esp
8010560a:	50                   	push   %eax
8010560b:	6a 00                	push   $0x0
8010560d:	e8 de f5 ff ff       	call   80104bf0 <argstr>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	78 77                	js     80105690 <sys_chdir+0xa0>
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	ff 75 f4             	pushl  -0xc(%ebp)
8010561f:	e8 fc ca ff ff       	call   80102120 <namei>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	89 c3                	mov    %eax,%ebx
8010562b:	74 63                	je     80105690 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	50                   	push   %eax
80105631:	e8 fa c1 ff ff       	call   80101830 <ilock>
  if(ip->type != T_DIR){
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010563e:	75 30                	jne    80105670 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	53                   	push   %ebx
80105644:	e8 c7 c2 ff ff       	call   80101910 <iunlock>
  iput(curproc->cwd);
80105649:	58                   	pop    %eax
8010564a:	ff 76 68             	pushl  0x68(%esi)
8010564d:	e8 0e c3 ff ff       	call   80101960 <iput>
  end_op();
80105652:	e8 59 d9 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105657:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	31 c0                	xor    %eax,%eax
}
8010565f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105662:	5b                   	pop    %ebx
80105663:	5e                   	pop    %esi
80105664:	5d                   	pop    %ebp
80105665:	c3                   	ret    
80105666:	8d 76 00             	lea    0x0(%esi),%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 47 c4 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80105679:	e8 32 d9 ff ff       	call   80102fb0 <end_op>
    return -1;
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105686:	eb d7                	jmp    8010565f <sys_chdir+0x6f>
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105690:	e8 1b d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569a:	eb c3                	jmp    8010565f <sys_chdir+0x6f>
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_exec>:

int
sys_exec(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056b2:	50                   	push   %eax
801056b3:	6a 00                	push   $0x0
801056b5:	e8 36 f5 ff ff       	call   80104bf0 <argstr>
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	85 c0                	test   %eax,%eax
801056bf:	0f 88 87 00 00 00    	js     8010574c <sys_exec+0xac>
801056c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056cb:	83 ec 08             	sub    $0x8,%esp
801056ce:	50                   	push   %eax
801056cf:	6a 01                	push   $0x1
801056d1:	e8 6a f4 ff ff       	call   80104b40 <argint>
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	85 c0                	test   %eax,%eax
801056db:	78 6f                	js     8010574c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801056e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801056e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056e8:	68 80 00 00 00       	push   $0x80
801056ed:	6a 00                	push   $0x0
801056ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801056f5:	50                   	push   %eax
801056f6:	e8 45 f1 ff ff       	call   80104840 <memset>
801056fb:	83 c4 10             	add    $0x10,%esp
801056fe:	eb 2c                	jmp    8010572c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105700:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105706:	85 c0                	test   %eax,%eax
80105708:	74 56                	je     80105760 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010570a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105716:	52                   	push   %edx
80105717:	50                   	push   %eax
80105718:	e8 b3 f3 ff ff       	call   80104ad0 <fetchstr>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	78 28                	js     8010574c <sys_exec+0xac>
  for(i=0;; i++){
80105724:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105727:	83 fb 20             	cmp    $0x20,%ebx
8010572a:	74 20                	je     8010574c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010572c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105732:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105739:	83 ec 08             	sub    $0x8,%esp
8010573c:	57                   	push   %edi
8010573d:	01 f0                	add    %esi,%eax
8010573f:	50                   	push   %eax
80105740:	e8 4b f3 ff ff       	call   80104a90 <fetchint>
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	85 c0                	test   %eax,%eax
8010574a:	79 b4                	jns    80105700 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010574c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010574f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105754:	5b                   	pop    %ebx
80105755:	5e                   	pop    %esi
80105756:	5f                   	pop    %edi
80105757:	5d                   	pop    %ebp
80105758:	c3                   	ret    
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105760:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105766:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105769:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105770:	00 00 00 00 
  return exec(path, argv);
80105774:	50                   	push   %eax
80105775:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010577b:	e8 90 b2 ff ff       	call   80100a10 <exec>
80105780:	83 c4 10             	add    $0x10,%esp
}
80105783:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105786:	5b                   	pop    %ebx
80105787:	5e                   	pop    %esi
80105788:	5f                   	pop    %edi
80105789:	5d                   	pop    %ebp
8010578a:	c3                   	ret    
8010578b:	90                   	nop
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_pipe>:

int
sys_pipe(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
80105795:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105796:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105799:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010579c:	6a 08                	push   $0x8
8010579e:	50                   	push   %eax
8010579f:	6a 00                	push   $0x0
801057a1:	e8 ea f3 ff ff       	call   80104b90 <argptr>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	0f 88 ae 00 00 00    	js     8010585f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057b4:	83 ec 08             	sub    $0x8,%esp
801057b7:	50                   	push   %eax
801057b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057bb:	50                   	push   %eax
801057bc:	e8 1f de ff ff       	call   801035e0 <pipealloc>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	0f 88 93 00 00 00    	js     8010585f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057d1:	e8 ba e3 ff ff       	call   80103b90 <myproc>
801057d6:	eb 10                	jmp    801057e8 <sys_pipe+0x58>
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057e0:	83 c3 01             	add    $0x1,%ebx
801057e3:	83 fb 10             	cmp    $0x10,%ebx
801057e6:	74 60                	je     80105848 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801057e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057ec:	85 f6                	test   %esi,%esi
801057ee:	75 f0                	jne    801057e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801057f0:	8d 73 08             	lea    0x8(%ebx),%esi
801057f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057fa:	e8 91 e3 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ff:	31 d2                	xor    %edx,%edx
80105801:	eb 0d                	jmp    80105810 <sys_pipe+0x80>
80105803:	90                   	nop
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105808:	83 c2 01             	add    $0x1,%edx
8010580b:	83 fa 10             	cmp    $0x10,%edx
8010580e:	74 28                	je     80105838 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105810:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105814:	85 c9                	test   %ecx,%ecx
80105816:	75 f0                	jne    80105808 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105818:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010581c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010581f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105821:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105824:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105827:	31 c0                	xor    %eax,%eax
}
80105829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010582c:	5b                   	pop    %ebx
8010582d:	5e                   	pop    %esi
8010582e:	5f                   	pop    %edi
8010582f:	5d                   	pop    %ebp
80105830:	c3                   	ret    
80105831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105838:	e8 53 e3 ff ff       	call   80103b90 <myproc>
8010583d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105844:	00 
80105845:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	ff 75 e0             	pushl  -0x20(%ebp)
8010584e:	e8 ed b5 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105853:	58                   	pop    %eax
80105854:	ff 75 e4             	pushl  -0x1c(%ebp)
80105857:	e8 e4 b5 ff ff       	call   80100e40 <fileclose>
    return -1;
8010585c:	83 c4 10             	add    $0x10,%esp
8010585f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105864:	eb c3                	jmp    80105829 <sys_pipe+0x99>
80105866:	66 90                	xchg   %ax,%ax
80105868:	66 90                	xchg   %ax,%ax
8010586a:	66 90                	xchg   %ax,%ax
8010586c:	66 90                	xchg   %ax,%ax
8010586e:	66 90                	xchg   %ax,%ax

80105870 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105873:	5d                   	pop    %ebp
  return fork();
80105874:	e9 b7 e4 ff ff       	jmp    80103d30 <fork>
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_exit>:

int
sys_exit(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 08             	sub    $0x8,%esp
  exit();
80105886:	e8 25 e7 ff ff       	call   80103fb0 <exit>
  return 0;  // not reached
}
8010588b:	31 c0                	xor    %eax,%eax
8010588d:	c9                   	leave  
8010588e:	c3                   	ret    
8010588f:	90                   	nop

80105890 <sys_wait>:

int
sys_wait(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105893:	5d                   	pop    %ebp
  return wait();
80105894:	e9 57 e9 ff ff       	jmp    801041f0 <wait>
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_kill>:

int
sys_kill(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	50                   	push   %eax
801058aa:	6a 00                	push   $0x0
801058ac:	e8 8f f2 ff ff       	call   80104b40 <argint>
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	85 c0                	test   %eax,%eax
801058b6:	78 18                	js     801058d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	ff 75 f4             	pushl  -0xc(%ebp)
801058be:	e8 7d ea ff ff       	call   80104340 <kill>
801058c3:	83 c4 10             	add    $0x10,%esp
}
801058c6:	c9                   	leave  
801058c7:	c3                   	ret    
801058c8:	90                   	nop
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <sys_getpid>:

int
sys_getpid(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058e6:	e8 a5 e2 ff ff       	call   80103b90 <myproc>
801058eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ee:	c9                   	leave  
801058ef:	c3                   	ret    

801058f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058fa:	50                   	push   %eax
801058fb:	6a 00                	push   $0x0
801058fd:	e8 3e f2 ff ff       	call   80104b40 <argint>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	78 27                	js     80105930 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105909:	e8 82 e2 ff ff       	call   80103b90 <myproc>
  if(growproc(n) < 0)
8010590e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105911:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105913:	ff 75 f4             	pushl  -0xc(%ebp)
80105916:	e8 95 e3 ff ff       	call   80103cb0 <growproc>
8010591b:	83 c4 10             	add    $0x10,%esp
8010591e:	85 c0                	test   %eax,%eax
80105920:	78 0e                	js     80105930 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105922:	89 d8                	mov    %ebx,%eax
80105924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105927:	c9                   	leave  
80105928:	c3                   	ret    
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105930:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105935:	eb eb                	jmp    80105922 <sys_sbrk+0x32>
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <sys_sleep>:

int
sys_sleep(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105947:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 ee f1 ff ff       	call   80104b40 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	0f 88 8a 00 00 00    	js     801059e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010595d:	83 ec 0c             	sub    $0xc,%esp
80105960:	68 a0 5d 11 80       	push   $0x80115da0
80105965:	e8 c6 ed ff ff       	call   80104730 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010596a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010596d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105970:	8b 1d e0 65 11 80    	mov    0x801165e0,%ebx
  while(ticks - ticks0 < n){
80105976:	85 d2                	test   %edx,%edx
80105978:	75 27                	jne    801059a1 <sys_sleep+0x61>
8010597a:	eb 54                	jmp    801059d0 <sys_sleep+0x90>
8010597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	68 a0 5d 11 80       	push   $0x80115da0
80105988:	68 e0 65 11 80       	push   $0x801165e0
8010598d:	e8 9e e7 ff ff       	call   80104130 <sleep>
  while(ticks - ticks0 < n){
80105992:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80105997:	83 c4 10             	add    $0x10,%esp
8010599a:	29 d8                	sub    %ebx,%eax
8010599c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010599f:	73 2f                	jae    801059d0 <sys_sleep+0x90>
    if(myproc()->killed){
801059a1:	e8 ea e1 ff ff       	call   80103b90 <myproc>
801059a6:	8b 40 24             	mov    0x24(%eax),%eax
801059a9:	85 c0                	test   %eax,%eax
801059ab:	74 d3                	je     80105980 <sys_sleep+0x40>
      release(&tickslock);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	68 a0 5d 11 80       	push   $0x80115da0
801059b5:	e8 36 ee ff ff       	call   801047f0 <release>
      return -1;
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801059c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 a0 5d 11 80       	push   $0x80115da0
801059d8:	e8 13 ee ff ff       	call   801047f0 <release>
  return 0;
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	31 c0                	xor    %eax,%eax
}
801059e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
    return -1;
801059e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ec:	eb f4                	jmp    801059e2 <sys_sleep+0xa2>
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
801059f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801059f7:	68 a0 5d 11 80       	push   $0x80115da0
801059fc:	e8 2f ed ff ff       	call   80104730 <acquire>
  xticks = ticks;
80105a01:	8b 1d e0 65 11 80    	mov    0x801165e0,%ebx
  release(&tickslock);
80105a07:	c7 04 24 a0 5d 11 80 	movl   $0x80115da0,(%esp)
80105a0e:	e8 dd ed ff ff       	call   801047f0 <release>
  return xticks;
}
80105a13:	89 d8                	mov    %ebx,%eax
80105a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a18:	c9                   	leave  
80105a19:	c3                   	ret    

80105a1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a1a:	1e                   	push   %ds
  pushl %es
80105a1b:	06                   	push   %es
  pushl %fs
80105a1c:	0f a0                	push   %fs
  pushl %gs
80105a1e:	0f a8                	push   %gs
  pushal
80105a20:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a29:	54                   	push   %esp
  call trap
80105a2a:	e8 c1 00 00 00       	call   80105af0 <trap>
  addl $4, %esp
80105a2f:	83 c4 04             	add    $0x4,%esp

80105a32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a32:	61                   	popa   
  popl %gs
80105a33:	0f a9                	pop    %gs
  popl %fs
80105a35:	0f a1                	pop    %fs
  popl %es
80105a37:	07                   	pop    %es
  popl %ds
80105a38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a39:	83 c4 08             	add    $0x8,%esp
  iret
80105a3c:	cf                   	iret   
80105a3d:	66 90                	xchg   %ax,%ax
80105a3f:	90                   	nop

80105a40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a41:	31 c0                	xor    %eax,%eax
{
80105a43:	89 e5                	mov    %esp,%ebp
80105a45:	83 ec 08             	sub    $0x8,%esp
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105a57:	c7 04 c5 e2 5d 11 80 	movl   $0x8e000008,-0x7feea21e(,%eax,8)
80105a5e:	08 00 00 8e 
80105a62:	66 89 14 c5 e0 5d 11 	mov    %dx,-0x7feea220(,%eax,8)
80105a69:	80 
80105a6a:	c1 ea 10             	shr    $0x10,%edx
80105a6d:	66 89 14 c5 e6 5d 11 	mov    %dx,-0x7feea21a(,%eax,8)
80105a74:	80 
  for(i = 0; i < 256; i++)
80105a75:	83 c0 01             	add    $0x1,%eax
80105a78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a7d:	75 d1                	jne    80105a50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a7f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105a84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a87:	c7 05 e2 5f 11 80 08 	movl   $0xef000008,0x80115fe2
80105a8e:	00 00 ef 
  initlock(&tickslock, "time");
80105a91:	68 39 88 10 80       	push   $0x80108839
80105a96:	68 a0 5d 11 80       	push   $0x80115da0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a9b:	66 a3 e0 5f 11 80    	mov    %ax,0x80115fe0
80105aa1:	c1 e8 10             	shr    $0x10,%eax
80105aa4:	66 a3 e6 5f 11 80    	mov    %ax,0x80115fe6
  initlock(&tickslock, "time");
80105aaa:	e8 41 eb ff ff       	call   801045f0 <initlock>
}
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	c9                   	leave  
80105ab3:	c3                   	ret    
80105ab4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105aba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ac0 <idtinit>:

void
idtinit(void)
{
80105ac0:	55                   	push   %ebp
  pd[0] = size-1;
80105ac1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ac6:	89 e5                	mov    %esp,%ebp
80105ac8:	83 ec 10             	sub    $0x10,%esp
80105acb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105acf:	b8 e0 5d 11 80       	mov    $0x80115de0,%eax
80105ad4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ad8:	c1 e8 10             	shr    $0x10,%eax
80105adb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105adf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ae2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105af0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
80105af6:	83 ec 1c             	sub    $0x1c,%esp
80105af9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105afc:	8b 47 30             	mov    0x30(%edi),%eax
80105aff:	83 f8 40             	cmp    $0x40,%eax
80105b02:	0f 84 f0 00 00 00    	je     80105bf8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b08:	83 e8 20             	sub    $0x20,%eax
80105b0b:	83 f8 1f             	cmp    $0x1f,%eax
80105b0e:	77 10                	ja     80105b20 <trap+0x30>
80105b10:	ff 24 85 e0 88 10 80 	jmp    *-0x7fef7720(,%eax,4)
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b20:	e8 6b e0 ff ff       	call   80103b90 <myproc>
80105b25:	85 c0                	test   %eax,%eax
80105b27:	8b 5f 38             	mov    0x38(%edi),%ebx
80105b2a:	0f 84 14 02 00 00    	je     80105d44 <trap+0x254>
80105b30:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105b34:	0f 84 0a 02 00 00    	je     80105d44 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b3a:	0f 20 d1             	mov    %cr2,%ecx
80105b3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b40:	e8 2b e0 ff ff       	call   80103b70 <cpuid>
80105b45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b48:	8b 47 34             	mov    0x34(%edi),%eax
80105b4b:	8b 77 30             	mov    0x30(%edi),%esi
80105b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b51:	e8 3a e0 ff ff       	call   80103b90 <myproc>
80105b56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b59:	e8 32 e0 ff ff       	call   80103b90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b64:	51                   	push   %ecx
80105b65:	53                   	push   %ebx
80105b66:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105b67:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b6d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b6e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b71:	52                   	push   %edx
80105b72:	ff 70 10             	pushl  0x10(%eax)
80105b75:	68 9c 88 10 80       	push   $0x8010889c
80105b7a:	e8 e1 aa ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105b7f:	83 c4 20             	add    $0x20,%esp
80105b82:	e8 09 e0 ff ff       	call   80103b90 <myproc>
80105b87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b8e:	e8 fd df ff ff       	call   80103b90 <myproc>
80105b93:	85 c0                	test   %eax,%eax
80105b95:	74 1d                	je     80105bb4 <trap+0xc4>
80105b97:	e8 f4 df ff ff       	call   80103b90 <myproc>
80105b9c:	8b 50 24             	mov    0x24(%eax),%edx
80105b9f:	85 d2                	test   %edx,%edx
80105ba1:	74 11                	je     80105bb4 <trap+0xc4>
80105ba3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ba7:	83 e0 03             	and    $0x3,%eax
80105baa:	66 83 f8 03          	cmp    $0x3,%ax
80105bae:	0f 84 4c 01 00 00    	je     80105d00 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105bb4:	e8 d7 df ff ff       	call   80103b90 <myproc>
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	74 0b                	je     80105bc8 <trap+0xd8>
80105bbd:	e8 ce df ff ff       	call   80103b90 <myproc>
80105bc2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bc6:	74 68                	je     80105c30 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bc8:	e8 c3 df ff ff       	call   80103b90 <myproc>
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	74 19                	je     80105bea <trap+0xfa>
80105bd1:	e8 ba df ff ff       	call   80103b90 <myproc>
80105bd6:	8b 40 24             	mov    0x24(%eax),%eax
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	74 0d                	je     80105bea <trap+0xfa>
80105bdd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105be1:	83 e0 03             	and    $0x3,%eax
80105be4:	66 83 f8 03          	cmp    $0x3,%ax
80105be8:	74 37                	je     80105c21 <trap+0x131>
    exit();
}
80105bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bed:	5b                   	pop    %ebx
80105bee:	5e                   	pop    %esi
80105bef:	5f                   	pop    %edi
80105bf0:	5d                   	pop    %ebp
80105bf1:	c3                   	ret    
80105bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105bf8:	e8 93 df ff ff       	call   80103b90 <myproc>
80105bfd:	8b 58 24             	mov    0x24(%eax),%ebx
80105c00:	85 db                	test   %ebx,%ebx
80105c02:	0f 85 e8 00 00 00    	jne    80105cf0 <trap+0x200>
    myproc()->tf = tf;
80105c08:	e8 83 df ff ff       	call   80103b90 <myproc>
80105c0d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105c10:	e8 1b f0 ff ff       	call   80104c30 <syscall>
    if(myproc()->killed)
80105c15:	e8 76 df ff ff       	call   80103b90 <myproc>
80105c1a:	8b 48 24             	mov    0x24(%eax),%ecx
80105c1d:	85 c9                	test   %ecx,%ecx
80105c1f:	74 c9                	je     80105bea <trap+0xfa>
}
80105c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c24:	5b                   	pop    %ebx
80105c25:	5e                   	pop    %esi
80105c26:	5f                   	pop    %edi
80105c27:	5d                   	pop    %ebp
      exit();
80105c28:	e9 83 e3 ff ff       	jmp    80103fb0 <exit>
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105c30:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105c34:	75 92                	jne    80105bc8 <trap+0xd8>
    yield();
80105c36:	e8 a5 e4 ff ff       	call   801040e0 <yield>
80105c3b:	eb 8b                	jmp    80105bc8 <trap+0xd8>
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105c40:	e8 2b df ff ff       	call   80103b70 <cpuid>
80105c45:	85 c0                	test   %eax,%eax
80105c47:	0f 84 c3 00 00 00    	je     80105d10 <trap+0x220>
    lapiceoi();
80105c4d:	e8 9e ce ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c52:	e8 39 df ff ff       	call   80103b90 <myproc>
80105c57:	85 c0                	test   %eax,%eax
80105c59:	0f 85 38 ff ff ff    	jne    80105b97 <trap+0xa7>
80105c5f:	e9 50 ff ff ff       	jmp    80105bb4 <trap+0xc4>
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c68:	e8 43 cd ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105c6d:	e8 7e ce ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c72:	e8 19 df ff ff       	call   80103b90 <myproc>
80105c77:	85 c0                	test   %eax,%eax
80105c79:	0f 85 18 ff ff ff    	jne    80105b97 <trap+0xa7>
80105c7f:	e9 30 ff ff ff       	jmp    80105bb4 <trap+0xc4>
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c88:	e8 53 02 00 00       	call   80105ee0 <uartintr>
    lapiceoi();
80105c8d:	e8 5e ce ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c92:	e8 f9 de ff ff       	call   80103b90 <myproc>
80105c97:	85 c0                	test   %eax,%eax
80105c99:	0f 85 f8 fe ff ff    	jne    80105b97 <trap+0xa7>
80105c9f:	e9 10 ff ff ff       	jmp    80105bb4 <trap+0xc4>
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ca8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105cac:	8b 77 38             	mov    0x38(%edi),%esi
80105caf:	e8 bc de ff ff       	call   80103b70 <cpuid>
80105cb4:	56                   	push   %esi
80105cb5:	53                   	push   %ebx
80105cb6:	50                   	push   %eax
80105cb7:	68 44 88 10 80       	push   $0x80108844
80105cbc:	e8 9f a9 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105cc1:	e8 2a ce ff ff       	call   80102af0 <lapiceoi>
    break;
80105cc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cc9:	e8 c2 de ff ff       	call   80103b90 <myproc>
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	0f 85 c1 fe ff ff    	jne    80105b97 <trap+0xa7>
80105cd6:	e9 d9 fe ff ff       	jmp    80105bb4 <trap+0xc4>
80105cdb:	90                   	nop
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105ce0:	e8 db c5 ff ff       	call   801022c0 <ideintr>
80105ce5:	e9 63 ff ff ff       	jmp    80105c4d <trap+0x15d>
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105cf0:	e8 bb e2 ff ff       	call   80103fb0 <exit>
80105cf5:	e9 0e ff ff ff       	jmp    80105c08 <trap+0x118>
80105cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105d00:	e8 ab e2 ff ff       	call   80103fb0 <exit>
80105d05:	e9 aa fe ff ff       	jmp    80105bb4 <trap+0xc4>
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	68 a0 5d 11 80       	push   $0x80115da0
80105d18:	e8 13 ea ff ff       	call   80104730 <acquire>
      wakeup(&ticks);
80105d1d:	c7 04 24 e0 65 11 80 	movl   $0x801165e0,(%esp)
      ticks++;
80105d24:	83 05 e0 65 11 80 01 	addl   $0x1,0x801165e0
      wakeup(&ticks);
80105d2b:	e8 b0 e5 ff ff       	call   801042e0 <wakeup>
      release(&tickslock);
80105d30:	c7 04 24 a0 5d 11 80 	movl   $0x80115da0,(%esp)
80105d37:	e8 b4 ea ff ff       	call   801047f0 <release>
80105d3c:	83 c4 10             	add    $0x10,%esp
80105d3f:	e9 09 ff ff ff       	jmp    80105c4d <trap+0x15d>
80105d44:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d47:	e8 24 de ff ff       	call   80103b70 <cpuid>
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	56                   	push   %esi
80105d50:	53                   	push   %ebx
80105d51:	50                   	push   %eax
80105d52:	ff 77 30             	pushl  0x30(%edi)
80105d55:	68 68 88 10 80       	push   $0x80108868
80105d5a:	e8 01 a9 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105d5f:	83 c4 14             	add    $0x14,%esp
80105d62:	68 3e 88 10 80       	push   $0x8010883e
80105d67:	e8 24 a6 ff ff       	call   80100390 <panic>
80105d6c:	66 90                	xchg   %ax,%ax
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d70:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	74 1c                	je     80105d98 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d82:	a8 01                	test   $0x1,%al
80105d84:	74 12                	je     80105d98 <uartgetc+0x28>
80105d86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d8c:	0f b6 c0             	movzbl %al,%eax
}
80105d8f:	5d                   	pop    %ebp
80105d90:	c3                   	ret    
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d9d:	5d                   	pop    %ebp
80105d9e:	c3                   	ret    
80105d9f:	90                   	nop

80105da0 <uartputc.part.0>:
uartputc(int c)
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
80105da6:	89 c7                	mov    %eax,%edi
80105da8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105db2:	83 ec 0c             	sub    $0xc,%esp
80105db5:	eb 1b                	jmp    80105dd2 <uartputc.part.0+0x32>
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	6a 0a                	push   $0xa
80105dc5:	e8 46 cd ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	83 eb 01             	sub    $0x1,%ebx
80105dd0:	74 07                	je     80105dd9 <uartputc.part.0+0x39>
80105dd2:	89 f2                	mov    %esi,%edx
80105dd4:	ec                   	in     (%dx),%al
80105dd5:	a8 20                	test   $0x20,%al
80105dd7:	74 e7                	je     80105dc0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dd9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dde:	89 f8                	mov    %edi,%eax
80105de0:	ee                   	out    %al,(%dx)
}
80105de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de4:	5b                   	pop    %ebx
80105de5:	5e                   	pop    %esi
80105de6:	5f                   	pop    %edi
80105de7:	5d                   	pop    %ebp
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105df0 <uartinit>:
{
80105df0:	55                   	push   %ebp
80105df1:	31 c9                	xor    %ecx,%ecx
80105df3:	89 c8                	mov    %ecx,%eax
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	57                   	push   %edi
80105df8:	56                   	push   %esi
80105df9:	53                   	push   %ebx
80105dfa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105dff:	89 da                	mov    %ebx,%edx
80105e01:	83 ec 0c             	sub    $0xc,%esp
80105e04:	ee                   	out    %al,(%dx)
80105e05:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e0f:	89 fa                	mov    %edi,%edx
80105e11:	ee                   	out    %al,(%dx)
80105e12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e1c:	ee                   	out    %al,(%dx)
80105e1d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105e22:	89 c8                	mov    %ecx,%eax
80105e24:	89 f2                	mov    %esi,%edx
80105e26:	ee                   	out    %al,(%dx)
80105e27:	b8 03 00 00 00       	mov    $0x3,%eax
80105e2c:	89 fa                	mov    %edi,%edx
80105e2e:	ee                   	out    %al,(%dx)
80105e2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e34:	89 c8                	mov    %ecx,%eax
80105e36:	ee                   	out    %al,(%dx)
80105e37:	b8 01 00 00 00       	mov    $0x1,%eax
80105e3c:	89 f2                	mov    %esi,%edx
80105e3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e44:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e45:	3c ff                	cmp    $0xff,%al
80105e47:	74 5a                	je     80105ea3 <uartinit+0xb3>
  uart = 1;
80105e49:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105e50:	00 00 00 
80105e53:	89 da                	mov    %ebx,%edx
80105e55:	ec                   	in     (%dx),%al
80105e56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e5b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e5c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e5f:	bb 60 89 10 80       	mov    $0x80108960,%ebx
  ioapicenable(IRQ_COM1, 0);
80105e64:	6a 00                	push   $0x0
80105e66:	6a 04                	push   $0x4
80105e68:	e8 03 c8 ff ff       	call   80102670 <ioapicenable>
80105e6d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e70:	b8 78 00 00 00       	mov    $0x78,%eax
80105e75:	eb 13                	jmp    80105e8a <uartinit+0x9a>
80105e77:	89 f6                	mov    %esi,%esi
80105e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e80:	83 c3 01             	add    $0x1,%ebx
80105e83:	0f be 03             	movsbl (%ebx),%eax
80105e86:	84 c0                	test   %al,%al
80105e88:	74 19                	je     80105ea3 <uartinit+0xb3>
  if(!uart)
80105e8a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105e90:	85 d2                	test   %edx,%edx
80105e92:	74 ec                	je     80105e80 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105e94:	83 c3 01             	add    $0x1,%ebx
80105e97:	e8 04 ff ff ff       	call   80105da0 <uartputc.part.0>
80105e9c:	0f be 03             	movsbl (%ebx),%eax
80105e9f:	84 c0                	test   %al,%al
80105ea1:	75 e7                	jne    80105e8a <uartinit+0x9a>
}
80105ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea6:	5b                   	pop    %ebx
80105ea7:	5e                   	pop    %esi
80105ea8:	5f                   	pop    %edi
80105ea9:	5d                   	pop    %ebp
80105eaa:	c3                   	ret    
80105eab:	90                   	nop
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <uartputc>:
  if(!uart)
80105eb0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80105eb6:	55                   	push   %ebp
80105eb7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105eb9:	85 d2                	test   %edx,%edx
{
80105ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ebe:	74 10                	je     80105ed0 <uartputc+0x20>
}
80105ec0:	5d                   	pop    %ebp
80105ec1:	e9 da fe ff ff       	jmp    80105da0 <uartputc.part.0>
80105ec6:	8d 76 00             	lea    0x0(%esi),%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ed0:	5d                   	pop    %ebp
80105ed1:	c3                   	ret    
80105ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ee0 <uartintr>:

void
uartintr(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ee6:	68 70 5d 10 80       	push   $0x80105d70
80105eeb:	e8 20 a9 ff ff       	call   80100810 <consoleintr>
}
80105ef0:	83 c4 10             	add    $0x10,%esp
80105ef3:	c9                   	leave  
80105ef4:	c3                   	ret    

80105ef5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $0
80105ef7:	6a 00                	push   $0x0
  jmp alltraps
80105ef9:	e9 1c fb ff ff       	jmp    80105a1a <alltraps>

80105efe <vector1>:
.globl vector1
vector1:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $1
80105f00:	6a 01                	push   $0x1
  jmp alltraps
80105f02:	e9 13 fb ff ff       	jmp    80105a1a <alltraps>

80105f07 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $2
80105f09:	6a 02                	push   $0x2
  jmp alltraps
80105f0b:	e9 0a fb ff ff       	jmp    80105a1a <alltraps>

80105f10 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $3
80105f12:	6a 03                	push   $0x3
  jmp alltraps
80105f14:	e9 01 fb ff ff       	jmp    80105a1a <alltraps>

80105f19 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $4
80105f1b:	6a 04                	push   $0x4
  jmp alltraps
80105f1d:	e9 f8 fa ff ff       	jmp    80105a1a <alltraps>

80105f22 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $5
80105f24:	6a 05                	push   $0x5
  jmp alltraps
80105f26:	e9 ef fa ff ff       	jmp    80105a1a <alltraps>

80105f2b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $6
80105f2d:	6a 06                	push   $0x6
  jmp alltraps
80105f2f:	e9 e6 fa ff ff       	jmp    80105a1a <alltraps>

80105f34 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $7
80105f36:	6a 07                	push   $0x7
  jmp alltraps
80105f38:	e9 dd fa ff ff       	jmp    80105a1a <alltraps>

80105f3d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f3d:	6a 08                	push   $0x8
  jmp alltraps
80105f3f:	e9 d6 fa ff ff       	jmp    80105a1a <alltraps>

80105f44 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $9
80105f46:	6a 09                	push   $0x9
  jmp alltraps
80105f48:	e9 cd fa ff ff       	jmp    80105a1a <alltraps>

80105f4d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f4d:	6a 0a                	push   $0xa
  jmp alltraps
80105f4f:	e9 c6 fa ff ff       	jmp    80105a1a <alltraps>

80105f54 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f54:	6a 0b                	push   $0xb
  jmp alltraps
80105f56:	e9 bf fa ff ff       	jmp    80105a1a <alltraps>

80105f5b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f5b:	6a 0c                	push   $0xc
  jmp alltraps
80105f5d:	e9 b8 fa ff ff       	jmp    80105a1a <alltraps>

80105f62 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f62:	6a 0d                	push   $0xd
  jmp alltraps
80105f64:	e9 b1 fa ff ff       	jmp    80105a1a <alltraps>

80105f69 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f69:	6a 0e                	push   $0xe
  jmp alltraps
80105f6b:	e9 aa fa ff ff       	jmp    80105a1a <alltraps>

80105f70 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f70:	6a 00                	push   $0x0
  pushl $15
80105f72:	6a 0f                	push   $0xf
  jmp alltraps
80105f74:	e9 a1 fa ff ff       	jmp    80105a1a <alltraps>

80105f79 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f79:	6a 00                	push   $0x0
  pushl $16
80105f7b:	6a 10                	push   $0x10
  jmp alltraps
80105f7d:	e9 98 fa ff ff       	jmp    80105a1a <alltraps>

80105f82 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f82:	6a 11                	push   $0x11
  jmp alltraps
80105f84:	e9 91 fa ff ff       	jmp    80105a1a <alltraps>

80105f89 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $18
80105f8b:	6a 12                	push   $0x12
  jmp alltraps
80105f8d:	e9 88 fa ff ff       	jmp    80105a1a <alltraps>

80105f92 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $19
80105f94:	6a 13                	push   $0x13
  jmp alltraps
80105f96:	e9 7f fa ff ff       	jmp    80105a1a <alltraps>

80105f9b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $20
80105f9d:	6a 14                	push   $0x14
  jmp alltraps
80105f9f:	e9 76 fa ff ff       	jmp    80105a1a <alltraps>

80105fa4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $21
80105fa6:	6a 15                	push   $0x15
  jmp alltraps
80105fa8:	e9 6d fa ff ff       	jmp    80105a1a <alltraps>

80105fad <vector22>:
.globl vector22
vector22:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $22
80105faf:	6a 16                	push   $0x16
  jmp alltraps
80105fb1:	e9 64 fa ff ff       	jmp    80105a1a <alltraps>

80105fb6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $23
80105fb8:	6a 17                	push   $0x17
  jmp alltraps
80105fba:	e9 5b fa ff ff       	jmp    80105a1a <alltraps>

80105fbf <vector24>:
.globl vector24
vector24:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $24
80105fc1:	6a 18                	push   $0x18
  jmp alltraps
80105fc3:	e9 52 fa ff ff       	jmp    80105a1a <alltraps>

80105fc8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $25
80105fca:	6a 19                	push   $0x19
  jmp alltraps
80105fcc:	e9 49 fa ff ff       	jmp    80105a1a <alltraps>

80105fd1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $26
80105fd3:	6a 1a                	push   $0x1a
  jmp alltraps
80105fd5:	e9 40 fa ff ff       	jmp    80105a1a <alltraps>

80105fda <vector27>:
.globl vector27
vector27:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $27
80105fdc:	6a 1b                	push   $0x1b
  jmp alltraps
80105fde:	e9 37 fa ff ff       	jmp    80105a1a <alltraps>

80105fe3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $28
80105fe5:	6a 1c                	push   $0x1c
  jmp alltraps
80105fe7:	e9 2e fa ff ff       	jmp    80105a1a <alltraps>

80105fec <vector29>:
.globl vector29
vector29:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $29
80105fee:	6a 1d                	push   $0x1d
  jmp alltraps
80105ff0:	e9 25 fa ff ff       	jmp    80105a1a <alltraps>

80105ff5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $30
80105ff7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ff9:	e9 1c fa ff ff       	jmp    80105a1a <alltraps>

80105ffe <vector31>:
.globl vector31
vector31:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $31
80106000:	6a 1f                	push   $0x1f
  jmp alltraps
80106002:	e9 13 fa ff ff       	jmp    80105a1a <alltraps>

80106007 <vector32>:
.globl vector32
vector32:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $32
80106009:	6a 20                	push   $0x20
  jmp alltraps
8010600b:	e9 0a fa ff ff       	jmp    80105a1a <alltraps>

80106010 <vector33>:
.globl vector33
vector33:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $33
80106012:	6a 21                	push   $0x21
  jmp alltraps
80106014:	e9 01 fa ff ff       	jmp    80105a1a <alltraps>

80106019 <vector34>:
.globl vector34
vector34:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $34
8010601b:	6a 22                	push   $0x22
  jmp alltraps
8010601d:	e9 f8 f9 ff ff       	jmp    80105a1a <alltraps>

80106022 <vector35>:
.globl vector35
vector35:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $35
80106024:	6a 23                	push   $0x23
  jmp alltraps
80106026:	e9 ef f9 ff ff       	jmp    80105a1a <alltraps>

8010602b <vector36>:
.globl vector36
vector36:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $36
8010602d:	6a 24                	push   $0x24
  jmp alltraps
8010602f:	e9 e6 f9 ff ff       	jmp    80105a1a <alltraps>

80106034 <vector37>:
.globl vector37
vector37:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $37
80106036:	6a 25                	push   $0x25
  jmp alltraps
80106038:	e9 dd f9 ff ff       	jmp    80105a1a <alltraps>

8010603d <vector38>:
.globl vector38
vector38:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $38
8010603f:	6a 26                	push   $0x26
  jmp alltraps
80106041:	e9 d4 f9 ff ff       	jmp    80105a1a <alltraps>

80106046 <vector39>:
.globl vector39
vector39:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $39
80106048:	6a 27                	push   $0x27
  jmp alltraps
8010604a:	e9 cb f9 ff ff       	jmp    80105a1a <alltraps>

8010604f <vector40>:
.globl vector40
vector40:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $40
80106051:	6a 28                	push   $0x28
  jmp alltraps
80106053:	e9 c2 f9 ff ff       	jmp    80105a1a <alltraps>

80106058 <vector41>:
.globl vector41
vector41:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $41
8010605a:	6a 29                	push   $0x29
  jmp alltraps
8010605c:	e9 b9 f9 ff ff       	jmp    80105a1a <alltraps>

80106061 <vector42>:
.globl vector42
vector42:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $42
80106063:	6a 2a                	push   $0x2a
  jmp alltraps
80106065:	e9 b0 f9 ff ff       	jmp    80105a1a <alltraps>

8010606a <vector43>:
.globl vector43
vector43:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $43
8010606c:	6a 2b                	push   $0x2b
  jmp alltraps
8010606e:	e9 a7 f9 ff ff       	jmp    80105a1a <alltraps>

80106073 <vector44>:
.globl vector44
vector44:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $44
80106075:	6a 2c                	push   $0x2c
  jmp alltraps
80106077:	e9 9e f9 ff ff       	jmp    80105a1a <alltraps>

8010607c <vector45>:
.globl vector45
vector45:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $45
8010607e:	6a 2d                	push   $0x2d
  jmp alltraps
80106080:	e9 95 f9 ff ff       	jmp    80105a1a <alltraps>

80106085 <vector46>:
.globl vector46
vector46:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $46
80106087:	6a 2e                	push   $0x2e
  jmp alltraps
80106089:	e9 8c f9 ff ff       	jmp    80105a1a <alltraps>

8010608e <vector47>:
.globl vector47
vector47:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $47
80106090:	6a 2f                	push   $0x2f
  jmp alltraps
80106092:	e9 83 f9 ff ff       	jmp    80105a1a <alltraps>

80106097 <vector48>:
.globl vector48
vector48:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $48
80106099:	6a 30                	push   $0x30
  jmp alltraps
8010609b:	e9 7a f9 ff ff       	jmp    80105a1a <alltraps>

801060a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $49
801060a2:	6a 31                	push   $0x31
  jmp alltraps
801060a4:	e9 71 f9 ff ff       	jmp    80105a1a <alltraps>

801060a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $50
801060ab:	6a 32                	push   $0x32
  jmp alltraps
801060ad:	e9 68 f9 ff ff       	jmp    80105a1a <alltraps>

801060b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $51
801060b4:	6a 33                	push   $0x33
  jmp alltraps
801060b6:	e9 5f f9 ff ff       	jmp    80105a1a <alltraps>

801060bb <vector52>:
.globl vector52
vector52:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $52
801060bd:	6a 34                	push   $0x34
  jmp alltraps
801060bf:	e9 56 f9 ff ff       	jmp    80105a1a <alltraps>

801060c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $53
801060c6:	6a 35                	push   $0x35
  jmp alltraps
801060c8:	e9 4d f9 ff ff       	jmp    80105a1a <alltraps>

801060cd <vector54>:
.globl vector54
vector54:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $54
801060cf:	6a 36                	push   $0x36
  jmp alltraps
801060d1:	e9 44 f9 ff ff       	jmp    80105a1a <alltraps>

801060d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $55
801060d8:	6a 37                	push   $0x37
  jmp alltraps
801060da:	e9 3b f9 ff ff       	jmp    80105a1a <alltraps>

801060df <vector56>:
.globl vector56
vector56:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $56
801060e1:	6a 38                	push   $0x38
  jmp alltraps
801060e3:	e9 32 f9 ff ff       	jmp    80105a1a <alltraps>

801060e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $57
801060ea:	6a 39                	push   $0x39
  jmp alltraps
801060ec:	e9 29 f9 ff ff       	jmp    80105a1a <alltraps>

801060f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $58
801060f3:	6a 3a                	push   $0x3a
  jmp alltraps
801060f5:	e9 20 f9 ff ff       	jmp    80105a1a <alltraps>

801060fa <vector59>:
.globl vector59
vector59:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $59
801060fc:	6a 3b                	push   $0x3b
  jmp alltraps
801060fe:	e9 17 f9 ff ff       	jmp    80105a1a <alltraps>

80106103 <vector60>:
.globl vector60
vector60:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $60
80106105:	6a 3c                	push   $0x3c
  jmp alltraps
80106107:	e9 0e f9 ff ff       	jmp    80105a1a <alltraps>

8010610c <vector61>:
.globl vector61
vector61:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $61
8010610e:	6a 3d                	push   $0x3d
  jmp alltraps
80106110:	e9 05 f9 ff ff       	jmp    80105a1a <alltraps>

80106115 <vector62>:
.globl vector62
vector62:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $62
80106117:	6a 3e                	push   $0x3e
  jmp alltraps
80106119:	e9 fc f8 ff ff       	jmp    80105a1a <alltraps>

8010611e <vector63>:
.globl vector63
vector63:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $63
80106120:	6a 3f                	push   $0x3f
  jmp alltraps
80106122:	e9 f3 f8 ff ff       	jmp    80105a1a <alltraps>

80106127 <vector64>:
.globl vector64
vector64:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $64
80106129:	6a 40                	push   $0x40
  jmp alltraps
8010612b:	e9 ea f8 ff ff       	jmp    80105a1a <alltraps>

80106130 <vector65>:
.globl vector65
vector65:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $65
80106132:	6a 41                	push   $0x41
  jmp alltraps
80106134:	e9 e1 f8 ff ff       	jmp    80105a1a <alltraps>

80106139 <vector66>:
.globl vector66
vector66:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $66
8010613b:	6a 42                	push   $0x42
  jmp alltraps
8010613d:	e9 d8 f8 ff ff       	jmp    80105a1a <alltraps>

80106142 <vector67>:
.globl vector67
vector67:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $67
80106144:	6a 43                	push   $0x43
  jmp alltraps
80106146:	e9 cf f8 ff ff       	jmp    80105a1a <alltraps>

8010614b <vector68>:
.globl vector68
vector68:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $68
8010614d:	6a 44                	push   $0x44
  jmp alltraps
8010614f:	e9 c6 f8 ff ff       	jmp    80105a1a <alltraps>

80106154 <vector69>:
.globl vector69
vector69:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $69
80106156:	6a 45                	push   $0x45
  jmp alltraps
80106158:	e9 bd f8 ff ff       	jmp    80105a1a <alltraps>

8010615d <vector70>:
.globl vector70
vector70:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $70
8010615f:	6a 46                	push   $0x46
  jmp alltraps
80106161:	e9 b4 f8 ff ff       	jmp    80105a1a <alltraps>

80106166 <vector71>:
.globl vector71
vector71:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $71
80106168:	6a 47                	push   $0x47
  jmp alltraps
8010616a:	e9 ab f8 ff ff       	jmp    80105a1a <alltraps>

8010616f <vector72>:
.globl vector72
vector72:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $72
80106171:	6a 48                	push   $0x48
  jmp alltraps
80106173:	e9 a2 f8 ff ff       	jmp    80105a1a <alltraps>

80106178 <vector73>:
.globl vector73
vector73:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $73
8010617a:	6a 49                	push   $0x49
  jmp alltraps
8010617c:	e9 99 f8 ff ff       	jmp    80105a1a <alltraps>

80106181 <vector74>:
.globl vector74
vector74:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $74
80106183:	6a 4a                	push   $0x4a
  jmp alltraps
80106185:	e9 90 f8 ff ff       	jmp    80105a1a <alltraps>

8010618a <vector75>:
.globl vector75
vector75:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $75
8010618c:	6a 4b                	push   $0x4b
  jmp alltraps
8010618e:	e9 87 f8 ff ff       	jmp    80105a1a <alltraps>

80106193 <vector76>:
.globl vector76
vector76:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $76
80106195:	6a 4c                	push   $0x4c
  jmp alltraps
80106197:	e9 7e f8 ff ff       	jmp    80105a1a <alltraps>

8010619c <vector77>:
.globl vector77
vector77:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $77
8010619e:	6a 4d                	push   $0x4d
  jmp alltraps
801061a0:	e9 75 f8 ff ff       	jmp    80105a1a <alltraps>

801061a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $78
801061a7:	6a 4e                	push   $0x4e
  jmp alltraps
801061a9:	e9 6c f8 ff ff       	jmp    80105a1a <alltraps>

801061ae <vector79>:
.globl vector79
vector79:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $79
801061b0:	6a 4f                	push   $0x4f
  jmp alltraps
801061b2:	e9 63 f8 ff ff       	jmp    80105a1a <alltraps>

801061b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $80
801061b9:	6a 50                	push   $0x50
  jmp alltraps
801061bb:	e9 5a f8 ff ff       	jmp    80105a1a <alltraps>

801061c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $81
801061c2:	6a 51                	push   $0x51
  jmp alltraps
801061c4:	e9 51 f8 ff ff       	jmp    80105a1a <alltraps>

801061c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $82
801061cb:	6a 52                	push   $0x52
  jmp alltraps
801061cd:	e9 48 f8 ff ff       	jmp    80105a1a <alltraps>

801061d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $83
801061d4:	6a 53                	push   $0x53
  jmp alltraps
801061d6:	e9 3f f8 ff ff       	jmp    80105a1a <alltraps>

801061db <vector84>:
.globl vector84
vector84:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $84
801061dd:	6a 54                	push   $0x54
  jmp alltraps
801061df:	e9 36 f8 ff ff       	jmp    80105a1a <alltraps>

801061e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $85
801061e6:	6a 55                	push   $0x55
  jmp alltraps
801061e8:	e9 2d f8 ff ff       	jmp    80105a1a <alltraps>

801061ed <vector86>:
.globl vector86
vector86:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $86
801061ef:	6a 56                	push   $0x56
  jmp alltraps
801061f1:	e9 24 f8 ff ff       	jmp    80105a1a <alltraps>

801061f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $87
801061f8:	6a 57                	push   $0x57
  jmp alltraps
801061fa:	e9 1b f8 ff ff       	jmp    80105a1a <alltraps>

801061ff <vector88>:
.globl vector88
vector88:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $88
80106201:	6a 58                	push   $0x58
  jmp alltraps
80106203:	e9 12 f8 ff ff       	jmp    80105a1a <alltraps>

80106208 <vector89>:
.globl vector89
vector89:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $89
8010620a:	6a 59                	push   $0x59
  jmp alltraps
8010620c:	e9 09 f8 ff ff       	jmp    80105a1a <alltraps>

80106211 <vector90>:
.globl vector90
vector90:
  pushl $0
80106211:	6a 00                	push   $0x0
  pushl $90
80106213:	6a 5a                	push   $0x5a
  jmp alltraps
80106215:	e9 00 f8 ff ff       	jmp    80105a1a <alltraps>

8010621a <vector91>:
.globl vector91
vector91:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $91
8010621c:	6a 5b                	push   $0x5b
  jmp alltraps
8010621e:	e9 f7 f7 ff ff       	jmp    80105a1a <alltraps>

80106223 <vector92>:
.globl vector92
vector92:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $92
80106225:	6a 5c                	push   $0x5c
  jmp alltraps
80106227:	e9 ee f7 ff ff       	jmp    80105a1a <alltraps>

8010622c <vector93>:
.globl vector93
vector93:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $93
8010622e:	6a 5d                	push   $0x5d
  jmp alltraps
80106230:	e9 e5 f7 ff ff       	jmp    80105a1a <alltraps>

80106235 <vector94>:
.globl vector94
vector94:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $94
80106237:	6a 5e                	push   $0x5e
  jmp alltraps
80106239:	e9 dc f7 ff ff       	jmp    80105a1a <alltraps>

8010623e <vector95>:
.globl vector95
vector95:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $95
80106240:	6a 5f                	push   $0x5f
  jmp alltraps
80106242:	e9 d3 f7 ff ff       	jmp    80105a1a <alltraps>

80106247 <vector96>:
.globl vector96
vector96:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $96
80106249:	6a 60                	push   $0x60
  jmp alltraps
8010624b:	e9 ca f7 ff ff       	jmp    80105a1a <alltraps>

80106250 <vector97>:
.globl vector97
vector97:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $97
80106252:	6a 61                	push   $0x61
  jmp alltraps
80106254:	e9 c1 f7 ff ff       	jmp    80105a1a <alltraps>

80106259 <vector98>:
.globl vector98
vector98:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $98
8010625b:	6a 62                	push   $0x62
  jmp alltraps
8010625d:	e9 b8 f7 ff ff       	jmp    80105a1a <alltraps>

80106262 <vector99>:
.globl vector99
vector99:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $99
80106264:	6a 63                	push   $0x63
  jmp alltraps
80106266:	e9 af f7 ff ff       	jmp    80105a1a <alltraps>

8010626b <vector100>:
.globl vector100
vector100:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $100
8010626d:	6a 64                	push   $0x64
  jmp alltraps
8010626f:	e9 a6 f7 ff ff       	jmp    80105a1a <alltraps>

80106274 <vector101>:
.globl vector101
vector101:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $101
80106276:	6a 65                	push   $0x65
  jmp alltraps
80106278:	e9 9d f7 ff ff       	jmp    80105a1a <alltraps>

8010627d <vector102>:
.globl vector102
vector102:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $102
8010627f:	6a 66                	push   $0x66
  jmp alltraps
80106281:	e9 94 f7 ff ff       	jmp    80105a1a <alltraps>

80106286 <vector103>:
.globl vector103
vector103:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $103
80106288:	6a 67                	push   $0x67
  jmp alltraps
8010628a:	e9 8b f7 ff ff       	jmp    80105a1a <alltraps>

8010628f <vector104>:
.globl vector104
vector104:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $104
80106291:	6a 68                	push   $0x68
  jmp alltraps
80106293:	e9 82 f7 ff ff       	jmp    80105a1a <alltraps>

80106298 <vector105>:
.globl vector105
vector105:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $105
8010629a:	6a 69                	push   $0x69
  jmp alltraps
8010629c:	e9 79 f7 ff ff       	jmp    80105a1a <alltraps>

801062a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062a1:	6a 00                	push   $0x0
  pushl $106
801062a3:	6a 6a                	push   $0x6a
  jmp alltraps
801062a5:	e9 70 f7 ff ff       	jmp    80105a1a <alltraps>

801062aa <vector107>:
.globl vector107
vector107:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $107
801062ac:	6a 6b                	push   $0x6b
  jmp alltraps
801062ae:	e9 67 f7 ff ff       	jmp    80105a1a <alltraps>

801062b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $108
801062b5:	6a 6c                	push   $0x6c
  jmp alltraps
801062b7:	e9 5e f7 ff ff       	jmp    80105a1a <alltraps>

801062bc <vector109>:
.globl vector109
vector109:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $109
801062be:	6a 6d                	push   $0x6d
  jmp alltraps
801062c0:	e9 55 f7 ff ff       	jmp    80105a1a <alltraps>

801062c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $110
801062c7:	6a 6e                	push   $0x6e
  jmp alltraps
801062c9:	e9 4c f7 ff ff       	jmp    80105a1a <alltraps>

801062ce <vector111>:
.globl vector111
vector111:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $111
801062d0:	6a 6f                	push   $0x6f
  jmp alltraps
801062d2:	e9 43 f7 ff ff       	jmp    80105a1a <alltraps>

801062d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $112
801062d9:	6a 70                	push   $0x70
  jmp alltraps
801062db:	e9 3a f7 ff ff       	jmp    80105a1a <alltraps>

801062e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $113
801062e2:	6a 71                	push   $0x71
  jmp alltraps
801062e4:	e9 31 f7 ff ff       	jmp    80105a1a <alltraps>

801062e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $114
801062eb:	6a 72                	push   $0x72
  jmp alltraps
801062ed:	e9 28 f7 ff ff       	jmp    80105a1a <alltraps>

801062f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $115
801062f4:	6a 73                	push   $0x73
  jmp alltraps
801062f6:	e9 1f f7 ff ff       	jmp    80105a1a <alltraps>

801062fb <vector116>:
.globl vector116
vector116:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $116
801062fd:	6a 74                	push   $0x74
  jmp alltraps
801062ff:	e9 16 f7 ff ff       	jmp    80105a1a <alltraps>

80106304 <vector117>:
.globl vector117
vector117:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $117
80106306:	6a 75                	push   $0x75
  jmp alltraps
80106308:	e9 0d f7 ff ff       	jmp    80105a1a <alltraps>

8010630d <vector118>:
.globl vector118
vector118:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $118
8010630f:	6a 76                	push   $0x76
  jmp alltraps
80106311:	e9 04 f7 ff ff       	jmp    80105a1a <alltraps>

80106316 <vector119>:
.globl vector119
vector119:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $119
80106318:	6a 77                	push   $0x77
  jmp alltraps
8010631a:	e9 fb f6 ff ff       	jmp    80105a1a <alltraps>

8010631f <vector120>:
.globl vector120
vector120:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $120
80106321:	6a 78                	push   $0x78
  jmp alltraps
80106323:	e9 f2 f6 ff ff       	jmp    80105a1a <alltraps>

80106328 <vector121>:
.globl vector121
vector121:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $121
8010632a:	6a 79                	push   $0x79
  jmp alltraps
8010632c:	e9 e9 f6 ff ff       	jmp    80105a1a <alltraps>

80106331 <vector122>:
.globl vector122
vector122:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $122
80106333:	6a 7a                	push   $0x7a
  jmp alltraps
80106335:	e9 e0 f6 ff ff       	jmp    80105a1a <alltraps>

8010633a <vector123>:
.globl vector123
vector123:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $123
8010633c:	6a 7b                	push   $0x7b
  jmp alltraps
8010633e:	e9 d7 f6 ff ff       	jmp    80105a1a <alltraps>

80106343 <vector124>:
.globl vector124
vector124:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $124
80106345:	6a 7c                	push   $0x7c
  jmp alltraps
80106347:	e9 ce f6 ff ff       	jmp    80105a1a <alltraps>

8010634c <vector125>:
.globl vector125
vector125:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $125
8010634e:	6a 7d                	push   $0x7d
  jmp alltraps
80106350:	e9 c5 f6 ff ff       	jmp    80105a1a <alltraps>

80106355 <vector126>:
.globl vector126
vector126:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $126
80106357:	6a 7e                	push   $0x7e
  jmp alltraps
80106359:	e9 bc f6 ff ff       	jmp    80105a1a <alltraps>

8010635e <vector127>:
.globl vector127
vector127:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $127
80106360:	6a 7f                	push   $0x7f
  jmp alltraps
80106362:	e9 b3 f6 ff ff       	jmp    80105a1a <alltraps>

80106367 <vector128>:
.globl vector128
vector128:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $128
80106369:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010636e:	e9 a7 f6 ff ff       	jmp    80105a1a <alltraps>

80106373 <vector129>:
.globl vector129
vector129:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $129
80106375:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010637a:	e9 9b f6 ff ff       	jmp    80105a1a <alltraps>

8010637f <vector130>:
.globl vector130
vector130:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $130
80106381:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106386:	e9 8f f6 ff ff       	jmp    80105a1a <alltraps>

8010638b <vector131>:
.globl vector131
vector131:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $131
8010638d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106392:	e9 83 f6 ff ff       	jmp    80105a1a <alltraps>

80106397 <vector132>:
.globl vector132
vector132:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $132
80106399:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010639e:	e9 77 f6 ff ff       	jmp    80105a1a <alltraps>

801063a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $133
801063a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063aa:	e9 6b f6 ff ff       	jmp    80105a1a <alltraps>

801063af <vector134>:
.globl vector134
vector134:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $134
801063b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063b6:	e9 5f f6 ff ff       	jmp    80105a1a <alltraps>

801063bb <vector135>:
.globl vector135
vector135:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $135
801063bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063c2:	e9 53 f6 ff ff       	jmp    80105a1a <alltraps>

801063c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $136
801063c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063ce:	e9 47 f6 ff ff       	jmp    80105a1a <alltraps>

801063d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $137
801063d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063da:	e9 3b f6 ff ff       	jmp    80105a1a <alltraps>

801063df <vector138>:
.globl vector138
vector138:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $138
801063e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063e6:	e9 2f f6 ff ff       	jmp    80105a1a <alltraps>

801063eb <vector139>:
.globl vector139
vector139:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $139
801063ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063f2:	e9 23 f6 ff ff       	jmp    80105a1a <alltraps>

801063f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $140
801063f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063fe:	e9 17 f6 ff ff       	jmp    80105a1a <alltraps>

80106403 <vector141>:
.globl vector141
vector141:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $141
80106405:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010640a:	e9 0b f6 ff ff       	jmp    80105a1a <alltraps>

8010640f <vector142>:
.globl vector142
vector142:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $142
80106411:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106416:	e9 ff f5 ff ff       	jmp    80105a1a <alltraps>

8010641b <vector143>:
.globl vector143
vector143:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $143
8010641d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106422:	e9 f3 f5 ff ff       	jmp    80105a1a <alltraps>

80106427 <vector144>:
.globl vector144
vector144:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $144
80106429:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010642e:	e9 e7 f5 ff ff       	jmp    80105a1a <alltraps>

80106433 <vector145>:
.globl vector145
vector145:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $145
80106435:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010643a:	e9 db f5 ff ff       	jmp    80105a1a <alltraps>

8010643f <vector146>:
.globl vector146
vector146:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $146
80106441:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106446:	e9 cf f5 ff ff       	jmp    80105a1a <alltraps>

8010644b <vector147>:
.globl vector147
vector147:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $147
8010644d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106452:	e9 c3 f5 ff ff       	jmp    80105a1a <alltraps>

80106457 <vector148>:
.globl vector148
vector148:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $148
80106459:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010645e:	e9 b7 f5 ff ff       	jmp    80105a1a <alltraps>

80106463 <vector149>:
.globl vector149
vector149:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $149
80106465:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010646a:	e9 ab f5 ff ff       	jmp    80105a1a <alltraps>

8010646f <vector150>:
.globl vector150
vector150:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $150
80106471:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106476:	e9 9f f5 ff ff       	jmp    80105a1a <alltraps>

8010647b <vector151>:
.globl vector151
vector151:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $151
8010647d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106482:	e9 93 f5 ff ff       	jmp    80105a1a <alltraps>

80106487 <vector152>:
.globl vector152
vector152:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $152
80106489:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010648e:	e9 87 f5 ff ff       	jmp    80105a1a <alltraps>

80106493 <vector153>:
.globl vector153
vector153:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $153
80106495:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010649a:	e9 7b f5 ff ff       	jmp    80105a1a <alltraps>

8010649f <vector154>:
.globl vector154
vector154:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $154
801064a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064a6:	e9 6f f5 ff ff       	jmp    80105a1a <alltraps>

801064ab <vector155>:
.globl vector155
vector155:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $155
801064ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064b2:	e9 63 f5 ff ff       	jmp    80105a1a <alltraps>

801064b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $156
801064b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064be:	e9 57 f5 ff ff       	jmp    80105a1a <alltraps>

801064c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $157
801064c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064ca:	e9 4b f5 ff ff       	jmp    80105a1a <alltraps>

801064cf <vector158>:
.globl vector158
vector158:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $158
801064d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064d6:	e9 3f f5 ff ff       	jmp    80105a1a <alltraps>

801064db <vector159>:
.globl vector159
vector159:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $159
801064dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064e2:	e9 33 f5 ff ff       	jmp    80105a1a <alltraps>

801064e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $160
801064e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064ee:	e9 27 f5 ff ff       	jmp    80105a1a <alltraps>

801064f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $161
801064f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064fa:	e9 1b f5 ff ff       	jmp    80105a1a <alltraps>

801064ff <vector162>:
.globl vector162
vector162:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $162
80106501:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106506:	e9 0f f5 ff ff       	jmp    80105a1a <alltraps>

8010650b <vector163>:
.globl vector163
vector163:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $163
8010650d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106512:	e9 03 f5 ff ff       	jmp    80105a1a <alltraps>

80106517 <vector164>:
.globl vector164
vector164:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $164
80106519:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010651e:	e9 f7 f4 ff ff       	jmp    80105a1a <alltraps>

80106523 <vector165>:
.globl vector165
vector165:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $165
80106525:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010652a:	e9 eb f4 ff ff       	jmp    80105a1a <alltraps>

8010652f <vector166>:
.globl vector166
vector166:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $166
80106531:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106536:	e9 df f4 ff ff       	jmp    80105a1a <alltraps>

8010653b <vector167>:
.globl vector167
vector167:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $167
8010653d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106542:	e9 d3 f4 ff ff       	jmp    80105a1a <alltraps>

80106547 <vector168>:
.globl vector168
vector168:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $168
80106549:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010654e:	e9 c7 f4 ff ff       	jmp    80105a1a <alltraps>

80106553 <vector169>:
.globl vector169
vector169:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $169
80106555:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010655a:	e9 bb f4 ff ff       	jmp    80105a1a <alltraps>

8010655f <vector170>:
.globl vector170
vector170:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $170
80106561:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106566:	e9 af f4 ff ff       	jmp    80105a1a <alltraps>

8010656b <vector171>:
.globl vector171
vector171:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $171
8010656d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106572:	e9 a3 f4 ff ff       	jmp    80105a1a <alltraps>

80106577 <vector172>:
.globl vector172
vector172:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $172
80106579:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010657e:	e9 97 f4 ff ff       	jmp    80105a1a <alltraps>

80106583 <vector173>:
.globl vector173
vector173:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $173
80106585:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010658a:	e9 8b f4 ff ff       	jmp    80105a1a <alltraps>

8010658f <vector174>:
.globl vector174
vector174:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $174
80106591:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106596:	e9 7f f4 ff ff       	jmp    80105a1a <alltraps>

8010659b <vector175>:
.globl vector175
vector175:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $175
8010659d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065a2:	e9 73 f4 ff ff       	jmp    80105a1a <alltraps>

801065a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $176
801065a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065ae:	e9 67 f4 ff ff       	jmp    80105a1a <alltraps>

801065b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $177
801065b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065ba:	e9 5b f4 ff ff       	jmp    80105a1a <alltraps>

801065bf <vector178>:
.globl vector178
vector178:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $178
801065c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065c6:	e9 4f f4 ff ff       	jmp    80105a1a <alltraps>

801065cb <vector179>:
.globl vector179
vector179:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $179
801065cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065d2:	e9 43 f4 ff ff       	jmp    80105a1a <alltraps>

801065d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $180
801065d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065de:	e9 37 f4 ff ff       	jmp    80105a1a <alltraps>

801065e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $181
801065e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065ea:	e9 2b f4 ff ff       	jmp    80105a1a <alltraps>

801065ef <vector182>:
.globl vector182
vector182:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $182
801065f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065f6:	e9 1f f4 ff ff       	jmp    80105a1a <alltraps>

801065fb <vector183>:
.globl vector183
vector183:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $183
801065fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106602:	e9 13 f4 ff ff       	jmp    80105a1a <alltraps>

80106607 <vector184>:
.globl vector184
vector184:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $184
80106609:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010660e:	e9 07 f4 ff ff       	jmp    80105a1a <alltraps>

80106613 <vector185>:
.globl vector185
vector185:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $185
80106615:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010661a:	e9 fb f3 ff ff       	jmp    80105a1a <alltraps>

8010661f <vector186>:
.globl vector186
vector186:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $186
80106621:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106626:	e9 ef f3 ff ff       	jmp    80105a1a <alltraps>

8010662b <vector187>:
.globl vector187
vector187:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $187
8010662d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106632:	e9 e3 f3 ff ff       	jmp    80105a1a <alltraps>

80106637 <vector188>:
.globl vector188
vector188:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $188
80106639:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010663e:	e9 d7 f3 ff ff       	jmp    80105a1a <alltraps>

80106643 <vector189>:
.globl vector189
vector189:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $189
80106645:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010664a:	e9 cb f3 ff ff       	jmp    80105a1a <alltraps>

8010664f <vector190>:
.globl vector190
vector190:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $190
80106651:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106656:	e9 bf f3 ff ff       	jmp    80105a1a <alltraps>

8010665b <vector191>:
.globl vector191
vector191:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $191
8010665d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106662:	e9 b3 f3 ff ff       	jmp    80105a1a <alltraps>

80106667 <vector192>:
.globl vector192
vector192:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $192
80106669:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010666e:	e9 a7 f3 ff ff       	jmp    80105a1a <alltraps>

80106673 <vector193>:
.globl vector193
vector193:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $193
80106675:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010667a:	e9 9b f3 ff ff       	jmp    80105a1a <alltraps>

8010667f <vector194>:
.globl vector194
vector194:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $194
80106681:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106686:	e9 8f f3 ff ff       	jmp    80105a1a <alltraps>

8010668b <vector195>:
.globl vector195
vector195:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $195
8010668d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106692:	e9 83 f3 ff ff       	jmp    80105a1a <alltraps>

80106697 <vector196>:
.globl vector196
vector196:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $196
80106699:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010669e:	e9 77 f3 ff ff       	jmp    80105a1a <alltraps>

801066a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $197
801066a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066aa:	e9 6b f3 ff ff       	jmp    80105a1a <alltraps>

801066af <vector198>:
.globl vector198
vector198:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $198
801066b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066b6:	e9 5f f3 ff ff       	jmp    80105a1a <alltraps>

801066bb <vector199>:
.globl vector199
vector199:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $199
801066bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066c2:	e9 53 f3 ff ff       	jmp    80105a1a <alltraps>

801066c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $200
801066c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066ce:	e9 47 f3 ff ff       	jmp    80105a1a <alltraps>

801066d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $201
801066d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066da:	e9 3b f3 ff ff       	jmp    80105a1a <alltraps>

801066df <vector202>:
.globl vector202
vector202:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $202
801066e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066e6:	e9 2f f3 ff ff       	jmp    80105a1a <alltraps>

801066eb <vector203>:
.globl vector203
vector203:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $203
801066ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066f2:	e9 23 f3 ff ff       	jmp    80105a1a <alltraps>

801066f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $204
801066f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066fe:	e9 17 f3 ff ff       	jmp    80105a1a <alltraps>

80106703 <vector205>:
.globl vector205
vector205:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $205
80106705:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010670a:	e9 0b f3 ff ff       	jmp    80105a1a <alltraps>

8010670f <vector206>:
.globl vector206
vector206:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $206
80106711:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106716:	e9 ff f2 ff ff       	jmp    80105a1a <alltraps>

8010671b <vector207>:
.globl vector207
vector207:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $207
8010671d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106722:	e9 f3 f2 ff ff       	jmp    80105a1a <alltraps>

80106727 <vector208>:
.globl vector208
vector208:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $208
80106729:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010672e:	e9 e7 f2 ff ff       	jmp    80105a1a <alltraps>

80106733 <vector209>:
.globl vector209
vector209:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $209
80106735:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010673a:	e9 db f2 ff ff       	jmp    80105a1a <alltraps>

8010673f <vector210>:
.globl vector210
vector210:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $210
80106741:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106746:	e9 cf f2 ff ff       	jmp    80105a1a <alltraps>

8010674b <vector211>:
.globl vector211
vector211:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $211
8010674d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106752:	e9 c3 f2 ff ff       	jmp    80105a1a <alltraps>

80106757 <vector212>:
.globl vector212
vector212:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $212
80106759:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010675e:	e9 b7 f2 ff ff       	jmp    80105a1a <alltraps>

80106763 <vector213>:
.globl vector213
vector213:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $213
80106765:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010676a:	e9 ab f2 ff ff       	jmp    80105a1a <alltraps>

8010676f <vector214>:
.globl vector214
vector214:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $214
80106771:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106776:	e9 9f f2 ff ff       	jmp    80105a1a <alltraps>

8010677b <vector215>:
.globl vector215
vector215:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $215
8010677d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106782:	e9 93 f2 ff ff       	jmp    80105a1a <alltraps>

80106787 <vector216>:
.globl vector216
vector216:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $216
80106789:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010678e:	e9 87 f2 ff ff       	jmp    80105a1a <alltraps>

80106793 <vector217>:
.globl vector217
vector217:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $217
80106795:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010679a:	e9 7b f2 ff ff       	jmp    80105a1a <alltraps>

8010679f <vector218>:
.globl vector218
vector218:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $218
801067a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067a6:	e9 6f f2 ff ff       	jmp    80105a1a <alltraps>

801067ab <vector219>:
.globl vector219
vector219:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $219
801067ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067b2:	e9 63 f2 ff ff       	jmp    80105a1a <alltraps>

801067b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $220
801067b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067be:	e9 57 f2 ff ff       	jmp    80105a1a <alltraps>

801067c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $221
801067c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067ca:	e9 4b f2 ff ff       	jmp    80105a1a <alltraps>

801067cf <vector222>:
.globl vector222
vector222:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $222
801067d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067d6:	e9 3f f2 ff ff       	jmp    80105a1a <alltraps>

801067db <vector223>:
.globl vector223
vector223:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $223
801067dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067e2:	e9 33 f2 ff ff       	jmp    80105a1a <alltraps>

801067e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $224
801067e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067ee:	e9 27 f2 ff ff       	jmp    80105a1a <alltraps>

801067f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $225
801067f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067fa:	e9 1b f2 ff ff       	jmp    80105a1a <alltraps>

801067ff <vector226>:
.globl vector226
vector226:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $226
80106801:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106806:	e9 0f f2 ff ff       	jmp    80105a1a <alltraps>

8010680b <vector227>:
.globl vector227
vector227:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $227
8010680d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106812:	e9 03 f2 ff ff       	jmp    80105a1a <alltraps>

80106817 <vector228>:
.globl vector228
vector228:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $228
80106819:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010681e:	e9 f7 f1 ff ff       	jmp    80105a1a <alltraps>

80106823 <vector229>:
.globl vector229
vector229:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $229
80106825:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010682a:	e9 eb f1 ff ff       	jmp    80105a1a <alltraps>

8010682f <vector230>:
.globl vector230
vector230:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $230
80106831:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106836:	e9 df f1 ff ff       	jmp    80105a1a <alltraps>

8010683b <vector231>:
.globl vector231
vector231:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $231
8010683d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106842:	e9 d3 f1 ff ff       	jmp    80105a1a <alltraps>

80106847 <vector232>:
.globl vector232
vector232:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $232
80106849:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010684e:	e9 c7 f1 ff ff       	jmp    80105a1a <alltraps>

80106853 <vector233>:
.globl vector233
vector233:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $233
80106855:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010685a:	e9 bb f1 ff ff       	jmp    80105a1a <alltraps>

8010685f <vector234>:
.globl vector234
vector234:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $234
80106861:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106866:	e9 af f1 ff ff       	jmp    80105a1a <alltraps>

8010686b <vector235>:
.globl vector235
vector235:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $235
8010686d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106872:	e9 a3 f1 ff ff       	jmp    80105a1a <alltraps>

80106877 <vector236>:
.globl vector236
vector236:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $236
80106879:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010687e:	e9 97 f1 ff ff       	jmp    80105a1a <alltraps>

80106883 <vector237>:
.globl vector237
vector237:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $237
80106885:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010688a:	e9 8b f1 ff ff       	jmp    80105a1a <alltraps>

8010688f <vector238>:
.globl vector238
vector238:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $238
80106891:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106896:	e9 7f f1 ff ff       	jmp    80105a1a <alltraps>

8010689b <vector239>:
.globl vector239
vector239:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $239
8010689d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068a2:	e9 73 f1 ff ff       	jmp    80105a1a <alltraps>

801068a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $240
801068a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068ae:	e9 67 f1 ff ff       	jmp    80105a1a <alltraps>

801068b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $241
801068b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068ba:	e9 5b f1 ff ff       	jmp    80105a1a <alltraps>

801068bf <vector242>:
.globl vector242
vector242:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $242
801068c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068c6:	e9 4f f1 ff ff       	jmp    80105a1a <alltraps>

801068cb <vector243>:
.globl vector243
vector243:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $243
801068cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068d2:	e9 43 f1 ff ff       	jmp    80105a1a <alltraps>

801068d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $244
801068d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068de:	e9 37 f1 ff ff       	jmp    80105a1a <alltraps>

801068e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $245
801068e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068ea:	e9 2b f1 ff ff       	jmp    80105a1a <alltraps>

801068ef <vector246>:
.globl vector246
vector246:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $246
801068f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068f6:	e9 1f f1 ff ff       	jmp    80105a1a <alltraps>

801068fb <vector247>:
.globl vector247
vector247:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $247
801068fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106902:	e9 13 f1 ff ff       	jmp    80105a1a <alltraps>

80106907 <vector248>:
.globl vector248
vector248:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $248
80106909:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010690e:	e9 07 f1 ff ff       	jmp    80105a1a <alltraps>

80106913 <vector249>:
.globl vector249
vector249:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $249
80106915:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010691a:	e9 fb f0 ff ff       	jmp    80105a1a <alltraps>

8010691f <vector250>:
.globl vector250
vector250:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $250
80106921:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106926:	e9 ef f0 ff ff       	jmp    80105a1a <alltraps>

8010692b <vector251>:
.globl vector251
vector251:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $251
8010692d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106932:	e9 e3 f0 ff ff       	jmp    80105a1a <alltraps>

80106937 <vector252>:
.globl vector252
vector252:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $252
80106939:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010693e:	e9 d7 f0 ff ff       	jmp    80105a1a <alltraps>

80106943 <vector253>:
.globl vector253
vector253:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $253
80106945:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010694a:	e9 cb f0 ff ff       	jmp    80105a1a <alltraps>

8010694f <vector254>:
.globl vector254
vector254:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $254
80106951:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106956:	e9 bf f0 ff ff       	jmp    80105a1a <alltraps>

8010695b <vector255>:
.globl vector255
vector255:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $255
8010695d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106962:	e9 b3 f0 ff ff       	jmp    80105a1a <alltraps>
80106967:	66 90                	xchg   %ax,%ax
80106969:	66 90                	xchg   %ax,%ax
8010696b:	66 90                	xchg   %ax,%ax
8010696d:	66 90                	xchg   %ax,%ax
8010696f:	90                   	nop

80106970 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106976:	89 d3                	mov    %edx,%ebx
{
80106978:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010697a:	c1 eb 16             	shr    $0x16,%ebx
8010697d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106980:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106983:	8b 06                	mov    (%esi),%eax
80106985:	a8 01                	test   $0x1,%al
80106987:	74 27                	je     801069b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106989:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010698e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106994:	c1 ef 0a             	shr    $0xa,%edi
}
80106997:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010699a:	89 fa                	mov    %edi,%edx
8010699c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801069a2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
801069aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069b0:	85 c9                	test   %ecx,%ecx
801069b2:	74 2c                	je     801069e0 <walkpgdir+0x70>
801069b4:	e8 a7 be ff ff       	call   80102860 <kalloc>
801069b9:	85 c0                	test   %eax,%eax
801069bb:	89 c3                	mov    %eax,%ebx
801069bd:	74 21                	je     801069e0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801069bf:	83 ec 04             	sub    $0x4,%esp
801069c2:	68 00 10 00 00       	push   $0x1000
801069c7:	6a 00                	push   $0x0
801069c9:	50                   	push   %eax
801069ca:	e8 71 de ff ff       	call   80104840 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069cf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069d5:	83 c4 10             	add    $0x10,%esp
801069d8:	83 c8 07             	or     $0x7,%eax
801069db:	89 06                	mov    %eax,(%esi)
801069dd:	eb b5                	jmp    80106994 <walkpgdir+0x24>
801069df:	90                   	nop
}
801069e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801069e3:	31 c0                	xor    %eax,%eax
}
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5f                   	pop    %edi
801069e8:	5d                   	pop    %ebp
801069e9:	c3                   	ret    
801069ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801069f6:	89 d3                	mov    %edx,%ebx
801069f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069fe:	83 ec 1c             	sub    $0x1c,%esp
80106a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a16:	29 df                	sub    %ebx,%edi
80106a18:	83 c8 01             	or     $0x1,%eax
80106a1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a1e:	eb 15                	jmp    80106a35 <mappages+0x45>
    if(*pte & PTE_P)
80106a20:	f6 00 01             	testb  $0x1,(%eax)
80106a23:	75 45                	jne    80106a6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106a25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106a28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106a2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a2d:	74 31                	je     80106a60 <mappages+0x70>
      break;
    a += PGSIZE;
80106a2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a3d:	89 da                	mov    %ebx,%edx
80106a3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a42:	e8 29 ff ff ff       	call   80106970 <walkpgdir>
80106a47:	85 c0                	test   %eax,%eax
80106a49:	75 d5                	jne    80106a20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a53:	5b                   	pop    %ebx
80106a54:	5e                   	pop    %esi
80106a55:	5f                   	pop    %edi
80106a56:	5d                   	pop    %ebp
80106a57:	c3                   	ret    
80106a58:	90                   	nop
80106a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a63:	31 c0                	xor    %eax,%eax
}
80106a65:	5b                   	pop    %ebx
80106a66:	5e                   	pop    %esi
80106a67:	5f                   	pop    %edi
80106a68:	5d                   	pop    %ebp
80106a69:	c3                   	ret    
      panic("remap");
80106a6a:	83 ec 0c             	sub    $0xc,%esp
80106a6d:	68 68 89 10 80       	push   $0x80108968
80106a72:	e8 19 99 ff ff       	call   80100390 <panic>
80106a77:	89 f6                	mov    %esi,%esi
80106a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106a8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a94:	83 ec 1c             	sub    $0x1c,%esp
80106a97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a9a:	39 d3                	cmp    %edx,%ebx
80106a9c:	73 66                	jae    80106b04 <deallocuvm.part.0+0x84>
80106a9e:	89 d6                	mov    %edx,%esi
80106aa0:	eb 3d                	jmp    80106adf <deallocuvm.part.0+0x5f>
80106aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106aa8:	8b 10                	mov    (%eax),%edx
80106aaa:	f6 c2 01             	test   $0x1,%dl
80106aad:	74 26                	je     80106ad5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106aaf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ab5:	74 58                	je     80106b0f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ab7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106aba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ac3:	52                   	push   %edx
80106ac4:	e8 e7 bb ff ff       	call   801026b0 <kfree>
      *pte = 0;
80106ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106acc:	83 c4 10             	add    $0x10,%esp
80106acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ad5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106adb:	39 f3                	cmp    %esi,%ebx
80106add:	73 25                	jae    80106b04 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106adf:	31 c9                	xor    %ecx,%ecx
80106ae1:	89 da                	mov    %ebx,%edx
80106ae3:	89 f8                	mov    %edi,%eax
80106ae5:	e8 86 fe ff ff       	call   80106970 <walkpgdir>
    if(!pte)
80106aea:	85 c0                	test   %eax,%eax
80106aec:	75 ba                	jne    80106aa8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106aee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106af4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106afa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b00:	39 f3                	cmp    %esi,%ebx
80106b02:	72 db                	jb     80106adf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b0a:	5b                   	pop    %ebx
80106b0b:	5e                   	pop    %esi
80106b0c:	5f                   	pop    %edi
80106b0d:	5d                   	pop    %ebp
80106b0e:	c3                   	ret    
        panic("kfree");
80106b0f:	83 ec 0c             	sub    $0xc,%esp
80106b12:	68 02 83 10 80       	push   $0x80108302
80106b17:	e8 74 98 ff ff       	call   80100390 <panic>
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <seginit>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b26:	e8 45 d0 ff ff       	call   80103b70 <cpuid>
80106b2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106b31:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b3a:	c7 80 38 39 11 80 ff 	movl   $0xffff,-0x7feec6c8(%eax)
80106b41:	ff 00 00 
80106b44:	c7 80 3c 39 11 80 00 	movl   $0xcf9a00,-0x7feec6c4(%eax)
80106b4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b4e:	c7 80 40 39 11 80 ff 	movl   $0xffff,-0x7feec6c0(%eax)
80106b55:	ff 00 00 
80106b58:	c7 80 44 39 11 80 00 	movl   $0xcf9200,-0x7feec6bc(%eax)
80106b5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b62:	c7 80 48 39 11 80 ff 	movl   $0xffff,-0x7feec6b8(%eax)
80106b69:	ff 00 00 
80106b6c:	c7 80 4c 39 11 80 00 	movl   $0xcffa00,-0x7feec6b4(%eax)
80106b73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b76:	c7 80 50 39 11 80 ff 	movl   $0xffff,-0x7feec6b0(%eax)
80106b7d:	ff 00 00 
80106b80:	c7 80 54 39 11 80 00 	movl   $0xcff200,-0x7feec6ac(%eax)
80106b87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b8a:	05 30 39 11 80       	add    $0x80113930,%eax
  pd[1] = (uint)p;
80106b8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b93:	c1 e8 10             	shr    $0x10,%eax
80106b96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b9d:	0f 01 10             	lgdtl  (%eax)
}
80106ba0:	c9                   	leave  
80106ba1:	c3                   	ret    
80106ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bb0:	a1 e4 65 11 80       	mov    0x801165e4,%eax
{
80106bb5:	55                   	push   %ebp
80106bb6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bb8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bbd:	0f 22 d8             	mov    %eax,%cr3
}
80106bc0:	5d                   	pop    %ebp
80106bc1:	c3                   	ret    
80106bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bd0 <switchuvm>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
80106bd6:	83 ec 1c             	sub    $0x1c,%esp
80106bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106bdc:	85 db                	test   %ebx,%ebx
80106bde:	0f 84 cb 00 00 00    	je     80106caf <switchuvm+0xdf>
  if(p->kstack == 0)
80106be4:	8b 43 08             	mov    0x8(%ebx),%eax
80106be7:	85 c0                	test   %eax,%eax
80106be9:	0f 84 da 00 00 00    	je     80106cc9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106bef:	8b 43 04             	mov    0x4(%ebx),%eax
80106bf2:	85 c0                	test   %eax,%eax
80106bf4:	0f 84 c2 00 00 00    	je     80106cbc <switchuvm+0xec>
  pushcli();
80106bfa:	e8 61 da ff ff       	call   80104660 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bff:	e8 ec ce ff ff       	call   80103af0 <mycpu>
80106c04:	89 c6                	mov    %eax,%esi
80106c06:	e8 e5 ce ff ff       	call   80103af0 <mycpu>
80106c0b:	89 c7                	mov    %eax,%edi
80106c0d:	e8 de ce ff ff       	call   80103af0 <mycpu>
80106c12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c15:	83 c7 08             	add    $0x8,%edi
80106c18:	e8 d3 ce ff ff       	call   80103af0 <mycpu>
80106c1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c20:	83 c0 08             	add    $0x8,%eax
80106c23:	ba 67 00 00 00       	mov    $0x67,%edx
80106c28:	c1 e8 18             	shr    $0x18,%eax
80106c2b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106c32:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106c39:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c3f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c44:	83 c1 08             	add    $0x8,%ecx
80106c47:	c1 e9 10             	shr    $0x10,%ecx
80106c4a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106c50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c55:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c5c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106c61:	e8 8a ce ff ff       	call   80103af0 <mycpu>
80106c66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c6d:	e8 7e ce ff ff       	call   80103af0 <mycpu>
80106c72:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c76:	8b 73 08             	mov    0x8(%ebx),%esi
80106c79:	e8 72 ce ff ff       	call   80103af0 <mycpu>
80106c7e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c84:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c87:	e8 64 ce ff ff       	call   80103af0 <mycpu>
80106c8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c90:	b8 28 00 00 00       	mov    $0x28,%eax
80106c95:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c98:	8b 43 04             	mov    0x4(%ebx),%eax
80106c9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ca0:	0f 22 d8             	mov    %eax,%cr3
}
80106ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca6:	5b                   	pop    %ebx
80106ca7:	5e                   	pop    %esi
80106ca8:	5f                   	pop    %edi
80106ca9:	5d                   	pop    %ebp
  popcli();
80106caa:	e9 f1 d9 ff ff       	jmp    801046a0 <popcli>
    panic("switchuvm: no process");
80106caf:	83 ec 0c             	sub    $0xc,%esp
80106cb2:	68 6e 89 10 80       	push   $0x8010896e
80106cb7:	e8 d4 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106cbc:	83 ec 0c             	sub    $0xc,%esp
80106cbf:	68 99 89 10 80       	push   $0x80108999
80106cc4:	e8 c7 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106cc9:	83 ec 0c             	sub    $0xc,%esp
80106ccc:	68 84 89 10 80       	push   $0x80108984
80106cd1:	e8 ba 96 ff ff       	call   80100390 <panic>
80106cd6:	8d 76 00             	lea    0x0(%esi),%esi
80106cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ce0 <inituvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
80106ce9:	8b 75 10             	mov    0x10(%ebp),%esi
80106cec:	8b 45 08             	mov    0x8(%ebp),%eax
80106cef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106cf2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106cf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106cfb:	77 49                	ja     80106d46 <inituvm+0x66>
  mem = kalloc();
80106cfd:	e8 5e bb ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80106d02:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106d05:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d07:	68 00 10 00 00       	push   $0x1000
80106d0c:	6a 00                	push   $0x0
80106d0e:	50                   	push   %eax
80106d0f:	e8 2c db ff ff       	call   80104840 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d14:	58                   	pop    %eax
80106d15:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d1b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d20:	5a                   	pop    %edx
80106d21:	6a 06                	push   $0x6
80106d23:	50                   	push   %eax
80106d24:	31 d2                	xor    %edx,%edx
80106d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d29:	e8 c2 fc ff ff       	call   801069f0 <mappages>
  memmove(mem, init, sz);
80106d2e:	89 75 10             	mov    %esi,0x10(%ebp)
80106d31:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d34:	83 c4 10             	add    $0x10,%esp
80106d37:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d3d:	5b                   	pop    %ebx
80106d3e:	5e                   	pop    %esi
80106d3f:	5f                   	pop    %edi
80106d40:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d41:	e9 aa db ff ff       	jmp    801048f0 <memmove>
    panic("inituvm: more than a page");
80106d46:	83 ec 0c             	sub    $0xc,%esp
80106d49:	68 ad 89 10 80       	push   $0x801089ad
80106d4e:	e8 3d 96 ff ff       	call   80100390 <panic>
80106d53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d60 <loaduvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106d69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106d70:	0f 85 91 00 00 00    	jne    80106e07 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106d76:	8b 75 18             	mov    0x18(%ebp),%esi
80106d79:	31 db                	xor    %ebx,%ebx
80106d7b:	85 f6                	test   %esi,%esi
80106d7d:	75 1a                	jne    80106d99 <loaduvm+0x39>
80106d7f:	eb 6f                	jmp    80106df0 <loaduvm+0x90>
80106d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d97:	76 57                	jbe    80106df0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d99:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9f:	31 c9                	xor    %ecx,%ecx
80106da1:	01 da                	add    %ebx,%edx
80106da3:	e8 c8 fb ff ff       	call   80106970 <walkpgdir>
80106da8:	85 c0                	test   %eax,%eax
80106daa:	74 4e                	je     80106dfa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106dac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106db1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106db6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106dbb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dc1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dc4:	01 d9                	add    %ebx,%ecx
80106dc6:	05 00 00 00 80       	add    $0x80000000,%eax
80106dcb:	57                   	push   %edi
80106dcc:	51                   	push   %ecx
80106dcd:	50                   	push   %eax
80106dce:	ff 75 10             	pushl  0x10(%ebp)
80106dd1:	e8 3a ad ff ff       	call   80101b10 <readi>
80106dd6:	83 c4 10             	add    $0x10,%esp
80106dd9:	39 f8                	cmp    %edi,%eax
80106ddb:	74 ab                	je     80106d88 <loaduvm+0x28>
}
80106ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106df3:	31 c0                	xor    %eax,%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106dfa:	83 ec 0c             	sub    $0xc,%esp
80106dfd:	68 c7 89 10 80       	push   $0x801089c7
80106e02:	e8 89 95 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106e07:	83 ec 0c             	sub    $0xc,%esp
80106e0a:	68 68 8a 10 80       	push   $0x80108a68
80106e0f:	e8 7c 95 ff ff       	call   80100390 <panic>
80106e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e20 <allocuvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e29:	8b 7d 10             	mov    0x10(%ebp),%edi
80106e2c:	85 ff                	test   %edi,%edi
80106e2e:	0f 88 8e 00 00 00    	js     80106ec2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106e34:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e37:	0f 82 93 00 00 00    	jb     80106ed0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e40:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e46:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e4c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106e4f:	0f 86 7e 00 00 00    	jbe    80106ed3 <allocuvm+0xb3>
80106e55:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106e58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e5b:	eb 42                	jmp    80106e9f <allocuvm+0x7f>
80106e5d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106e60:	83 ec 04             	sub    $0x4,%esp
80106e63:	68 00 10 00 00       	push   $0x1000
80106e68:	6a 00                	push   $0x0
80106e6a:	50                   	push   %eax
80106e6b:	e8 d0 d9 ff ff       	call   80104840 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e70:	58                   	pop    %eax
80106e71:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e77:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e7c:	5a                   	pop    %edx
80106e7d:	6a 06                	push   $0x6
80106e7f:	50                   	push   %eax
80106e80:	89 da                	mov    %ebx,%edx
80106e82:	89 f8                	mov    %edi,%eax
80106e84:	e8 67 fb ff ff       	call   801069f0 <mappages>
80106e89:	83 c4 10             	add    $0x10,%esp
80106e8c:	85 c0                	test   %eax,%eax
80106e8e:	78 50                	js     80106ee0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106e90:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e96:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106e99:	0f 86 81 00 00 00    	jbe    80106f20 <allocuvm+0x100>
    mem = kalloc();
80106e9f:	e8 bc b9 ff ff       	call   80102860 <kalloc>
    if(mem == 0){
80106ea4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106ea6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ea8:	75 b6                	jne    80106e60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106eaa:	83 ec 0c             	sub    $0xc,%esp
80106ead:	68 e5 89 10 80       	push   $0x801089e5
80106eb2:	e8 a9 97 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106eb7:	83 c4 10             	add    $0x10,%esp
80106eba:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ebd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ec0:	77 6e                	ja     80106f30 <allocuvm+0x110>
}
80106ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106ec5:	31 ff                	xor    %edi,%edi
}
80106ec7:	89 f8                	mov    %edi,%eax
80106ec9:	5b                   	pop    %ebx
80106eca:	5e                   	pop    %esi
80106ecb:	5f                   	pop    %edi
80106ecc:	5d                   	pop    %ebp
80106ecd:	c3                   	ret    
80106ece:	66 90                	xchg   %ax,%ax
    return oldsz;
80106ed0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed6:	89 f8                	mov    %edi,%eax
80106ed8:	5b                   	pop    %ebx
80106ed9:	5e                   	pop    %esi
80106eda:	5f                   	pop    %edi
80106edb:	5d                   	pop    %ebp
80106edc:	c3                   	ret    
80106edd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	68 fd 89 10 80       	push   $0x801089fd
80106ee8:	e8 73 97 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106eed:	83 c4 10             	add    $0x10,%esp
80106ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ef3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ef6:	76 0d                	jbe    80106f05 <allocuvm+0xe5>
80106ef8:	89 c1                	mov    %eax,%ecx
80106efa:	8b 55 10             	mov    0x10(%ebp),%edx
80106efd:	8b 45 08             	mov    0x8(%ebp),%eax
80106f00:	e8 7b fb ff ff       	call   80106a80 <deallocuvm.part.0>
      kfree(mem);
80106f05:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106f08:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106f0a:	56                   	push   %esi
80106f0b:	e8 a0 b7 ff ff       	call   801026b0 <kfree>
      return 0;
80106f10:	83 c4 10             	add    $0x10,%esp
}
80106f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f16:	89 f8                	mov    %edi,%eax
80106f18:	5b                   	pop    %ebx
80106f19:	5e                   	pop    %esi
80106f1a:	5f                   	pop    %edi
80106f1b:	5d                   	pop    %ebp
80106f1c:	c3                   	ret    
80106f1d:	8d 76 00             	lea    0x0(%esi),%esi
80106f20:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f26:	5b                   	pop    %ebx
80106f27:	89 f8                	mov    %edi,%eax
80106f29:	5e                   	pop    %esi
80106f2a:	5f                   	pop    %edi
80106f2b:	5d                   	pop    %ebp
80106f2c:	c3                   	ret    
80106f2d:	8d 76 00             	lea    0x0(%esi),%esi
80106f30:	89 c1                	mov    %eax,%ecx
80106f32:	8b 55 10             	mov    0x10(%ebp),%edx
80106f35:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106f38:	31 ff                	xor    %edi,%edi
80106f3a:	e8 41 fb ff ff       	call   80106a80 <deallocuvm.part.0>
80106f3f:	eb 92                	jmp    80106ed3 <allocuvm+0xb3>
80106f41:	eb 0d                	jmp    80106f50 <deallocuvm>
80106f43:	90                   	nop
80106f44:	90                   	nop
80106f45:	90                   	nop
80106f46:	90                   	nop
80106f47:	90                   	nop
80106f48:	90                   	nop
80106f49:	90                   	nop
80106f4a:	90                   	nop
80106f4b:	90                   	nop
80106f4c:	90                   	nop
80106f4d:	90                   	nop
80106f4e:	90                   	nop
80106f4f:	90                   	nop

80106f50 <deallocuvm>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f5c:	39 d1                	cmp    %edx,%ecx
80106f5e:	73 10                	jae    80106f70 <deallocuvm+0x20>
}
80106f60:	5d                   	pop    %ebp
80106f61:	e9 1a fb ff ff       	jmp    80106a80 <deallocuvm.part.0>
80106f66:	8d 76 00             	lea    0x0(%esi),%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106f70:	89 d0                	mov    %edx,%eax
80106f72:	5d                   	pop    %ebp
80106f73:	c3                   	ret    
80106f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 0c             	sub    $0xc,%esp
80106f89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f8c:	85 f6                	test   %esi,%esi
80106f8e:	74 59                	je     80106fe9 <freevm+0x69>
80106f90:	31 c9                	xor    %ecx,%ecx
80106f92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f97:	89 f0                	mov    %esi,%eax
80106f99:	e8 e2 fa ff ff       	call   80106a80 <deallocuvm.part.0>
80106f9e:	89 f3                	mov    %esi,%ebx
80106fa0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fa6:	eb 0f                	jmp    80106fb7 <freevm+0x37>
80106fa8:	90                   	nop
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fb3:	39 fb                	cmp    %edi,%ebx
80106fb5:	74 23                	je     80106fda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fb7:	8b 03                	mov    (%ebx),%eax
80106fb9:	a8 01                	test   $0x1,%al
80106fbb:	74 f3                	je     80106fb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106fc2:	83 ec 0c             	sub    $0xc,%esp
80106fc5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fc8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106fcd:	50                   	push   %eax
80106fce:	e8 dd b6 ff ff       	call   801026b0 <kfree>
80106fd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106fd6:	39 fb                	cmp    %edi,%ebx
80106fd8:	75 dd                	jne    80106fb7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106fda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe0:	5b                   	pop    %ebx
80106fe1:	5e                   	pop    %esi
80106fe2:	5f                   	pop    %edi
80106fe3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106fe4:	e9 c7 b6 ff ff       	jmp    801026b0 <kfree>
    panic("freevm: no pgdir");
80106fe9:	83 ec 0c             	sub    $0xc,%esp
80106fec:	68 19 8a 10 80       	push   $0x80108a19
80106ff1:	e8 9a 93 ff ff       	call   80100390 <panic>
80106ff6:	8d 76 00             	lea    0x0(%esi),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <setupkvm>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	56                   	push   %esi
80107004:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107005:	e8 56 b8 ff ff       	call   80102860 <kalloc>
8010700a:	85 c0                	test   %eax,%eax
8010700c:	89 c6                	mov    %eax,%esi
8010700e:	74 42                	je     80107052 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107010:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107013:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107018:	68 00 10 00 00       	push   $0x1000
8010701d:	6a 00                	push   $0x0
8010701f:	50                   	push   %eax
80107020:	e8 1b d8 ff ff       	call   80104840 <memset>
80107025:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107028:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010702b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010702e:	83 ec 08             	sub    $0x8,%esp
80107031:	8b 13                	mov    (%ebx),%edx
80107033:	ff 73 0c             	pushl  0xc(%ebx)
80107036:	50                   	push   %eax
80107037:	29 c1                	sub    %eax,%ecx
80107039:	89 f0                	mov    %esi,%eax
8010703b:	e8 b0 f9 ff ff       	call   801069f0 <mappages>
80107040:	83 c4 10             	add    $0x10,%esp
80107043:	85 c0                	test   %eax,%eax
80107045:	78 19                	js     80107060 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107047:	83 c3 10             	add    $0x10,%ebx
8010704a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107050:	75 d6                	jne    80107028 <setupkvm+0x28>
}
80107052:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107055:	89 f0                	mov    %esi,%eax
80107057:	5b                   	pop    %ebx
80107058:	5e                   	pop    %esi
80107059:	5d                   	pop    %ebp
8010705a:	c3                   	ret    
8010705b:	90                   	nop
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	56                   	push   %esi
      return 0;
80107064:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107066:	e8 15 ff ff ff       	call   80106f80 <freevm>
      return 0;
8010706b:	83 c4 10             	add    $0x10,%esp
}
8010706e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107071:	89 f0                	mov    %esi,%eax
80107073:	5b                   	pop    %ebx
80107074:	5e                   	pop    %esi
80107075:	5d                   	pop    %ebp
80107076:	c3                   	ret    
80107077:	89 f6                	mov    %esi,%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <kvmalloc>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107086:	e8 75 ff ff ff       	call   80107000 <setupkvm>
8010708b:	a3 e4 65 11 80       	mov    %eax,0x801165e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107090:	05 00 00 00 80       	add    $0x80000000,%eax
80107095:	0f 22 d8             	mov    %eax,%cr3
}
80107098:	c9                   	leave  
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070a1:	31 c9                	xor    %ecx,%ecx
{
801070a3:	89 e5                	mov    %esp,%ebp
801070a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ab:	8b 45 08             	mov    0x8(%ebp),%eax
801070ae:	e8 bd f8 ff ff       	call   80106970 <walkpgdir>
  if(pte == 0)
801070b3:	85 c0                	test   %eax,%eax
801070b5:	74 05                	je     801070bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070ba:	c9                   	leave  
801070bb:	c3                   	ret    
    panic("clearpteu");
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	68 2a 8a 10 80       	push   $0x80108a2a
801070c4:	e8 c7 92 ff ff       	call   80100390 <panic>
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070d9:	e8 22 ff ff ff       	call   80107000 <setupkvm>
801070de:	85 c0                	test   %eax,%eax
801070e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070e3:	0f 84 9f 00 00 00    	je     80107188 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070ec:	85 c9                	test   %ecx,%ecx
801070ee:	0f 84 94 00 00 00    	je     80107188 <copyuvm+0xb8>
801070f4:	31 ff                	xor    %edi,%edi
801070f6:	eb 4a                	jmp    80107142 <copyuvm+0x72>
801070f8:	90                   	nop
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107100:	83 ec 04             	sub    $0x4,%esp
80107103:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107109:	68 00 10 00 00       	push   $0x1000
8010710e:	53                   	push   %ebx
8010710f:	50                   	push   %eax
80107110:	e8 db d7 ff ff       	call   801048f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107115:	58                   	pop    %eax
80107116:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010711c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107121:	5a                   	pop    %edx
80107122:	ff 75 e4             	pushl  -0x1c(%ebp)
80107125:	50                   	push   %eax
80107126:	89 fa                	mov    %edi,%edx
80107128:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010712b:	e8 c0 f8 ff ff       	call   801069f0 <mappages>
80107130:	83 c4 10             	add    $0x10,%esp
80107133:	85 c0                	test   %eax,%eax
80107135:	78 61                	js     80107198 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107137:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010713d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107140:	76 46                	jbe    80107188 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107142:	8b 45 08             	mov    0x8(%ebp),%eax
80107145:	31 c9                	xor    %ecx,%ecx
80107147:	89 fa                	mov    %edi,%edx
80107149:	e8 22 f8 ff ff       	call   80106970 <walkpgdir>
8010714e:	85 c0                	test   %eax,%eax
80107150:	74 61                	je     801071b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107152:	8b 00                	mov    (%eax),%eax
80107154:	a8 01                	test   $0x1,%al
80107156:	74 4e                	je     801071a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107158:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010715a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010715f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107165:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107168:	e8 f3 b6 ff ff       	call   80102860 <kalloc>
8010716d:	85 c0                	test   %eax,%eax
8010716f:	89 c6                	mov    %eax,%esi
80107171:	75 8d                	jne    80107100 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107173:	83 ec 0c             	sub    $0xc,%esp
80107176:	ff 75 e0             	pushl  -0x20(%ebp)
80107179:	e8 02 fe ff ff       	call   80106f80 <freevm>
  return 0;
8010717e:	83 c4 10             	add    $0x10,%esp
80107181:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107188:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010718b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010718e:	5b                   	pop    %ebx
8010718f:	5e                   	pop    %esi
80107190:	5f                   	pop    %edi
80107191:	5d                   	pop    %ebp
80107192:	c3                   	ret    
80107193:	90                   	nop
80107194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107198:	83 ec 0c             	sub    $0xc,%esp
8010719b:	56                   	push   %esi
8010719c:	e8 0f b5 ff ff       	call   801026b0 <kfree>
      goto bad;
801071a1:	83 c4 10             	add    $0x10,%esp
801071a4:	eb cd                	jmp    80107173 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	68 4e 8a 10 80       	push   $0x80108a4e
801071ae:	e8 dd 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801071b3:	83 ec 0c             	sub    $0xc,%esp
801071b6:	68 34 8a 10 80       	push   $0x80108a34
801071bb:	e8 d0 91 ff ff       	call   80100390 <panic>

801071c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c1:	31 c9                	xor    %ecx,%ecx
{
801071c3:	89 e5                	mov    %esp,%ebp
801071c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071cb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ce:	e8 9d f7 ff ff       	call   80106970 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801071d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801071dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071e0:	05 00 00 00 80       	add    $0x80000000,%eax
801071e5:	83 fa 05             	cmp    $0x5,%edx
801071e8:	ba 00 00 00 00       	mov    $0x0,%edx
801071ed:	0f 45 c2             	cmovne %edx,%eax
}
801071f0:	c3                   	ret    
801071f1:	eb 0d                	jmp    80107200 <copyout>
801071f3:	90                   	nop
801071f4:	90                   	nop
801071f5:	90                   	nop
801071f6:	90                   	nop
801071f7:	90                   	nop
801071f8:	90                   	nop
801071f9:	90                   	nop
801071fa:	90                   	nop
801071fb:	90                   	nop
801071fc:	90                   	nop
801071fd:	90                   	nop
801071fe:	90                   	nop
801071ff:	90                   	nop

80107200 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 1c             	sub    $0x1c,%esp
80107209:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010720c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010720f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107212:	85 db                	test   %ebx,%ebx
80107214:	75 40                	jne    80107256 <copyout+0x56>
80107216:	eb 70                	jmp    80107288 <copyout+0x88>
80107218:	90                   	nop
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107223:	89 f1                	mov    %esi,%ecx
80107225:	29 d1                	sub    %edx,%ecx
80107227:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010722d:	39 d9                	cmp    %ebx,%ecx
8010722f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107232:	29 f2                	sub    %esi,%edx
80107234:	83 ec 04             	sub    $0x4,%esp
80107237:	01 d0                	add    %edx,%eax
80107239:	51                   	push   %ecx
8010723a:	57                   	push   %edi
8010723b:	50                   	push   %eax
8010723c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010723f:	e8 ac d6 ff ff       	call   801048f0 <memmove>
    len -= n;
    buf += n;
80107244:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107247:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010724a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107250:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107252:	29 cb                	sub    %ecx,%ebx
80107254:	74 32                	je     80107288 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107256:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107258:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010725b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010725e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107264:	56                   	push   %esi
80107265:	ff 75 08             	pushl  0x8(%ebp)
80107268:	e8 53 ff ff ff       	call   801071c0 <uva2ka>
    if(pa0 == 0)
8010726d:	83 c4 10             	add    $0x10,%esp
80107270:	85 c0                	test   %eax,%eax
80107272:	75 ac                	jne    80107220 <copyout+0x20>
  }
  return 0;
}
80107274:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010727c:	5b                   	pop    %ebx
8010727d:	5e                   	pop    %esi
8010727e:	5f                   	pop    %edi
8010727f:	5d                   	pop    %ebp
80107280:	c3                   	ret    
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010728b:	31 c0                	xor    %eax,%eax
}
8010728d:	5b                   	pop    %ebx
8010728e:	5e                   	pop    %esi
8010728f:	5f                   	pop    %edi
80107290:	5d                   	pop    %ebp
80107291:	c3                   	ret    
80107292:	66 90                	xchg   %ax,%ax
80107294:	66 90                	xchg   %ax,%ax
80107296:	66 90                	xchg   %ax,%ax
80107298:	66 90                	xchg   %ax,%ax
8010729a:	66 90                	xchg   %ax,%ax
8010729c:	66 90                	xchg   %ax,%ax
8010729e:	66 90                	xchg   %ax,%ax

801072a0 <procfsisdir>:

struct dirent fd_dir_entries[NOFILE];

int 
procfsisdir(struct inode *ip) 
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
  //cprintf("in func procfsisdir: ip->minor=%d ip->inum=%d\n", ip->minor, ip->inum);
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501 || ip->inum != 502)))
801072a3:	8b 45 08             	mov    0x8(%ebp),%eax
		return 1;
	else 
    return 0;
}
801072a6:	5d                   	pop    %ebp
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501 || ip->inum != 502)))
801072a7:	66 83 78 54 01       	cmpw   $0x1,0x54(%eax)
801072ac:	0f 96 c0             	setbe  %al
801072af:	0f b6 c0             	movzbl %al,%eax
}
801072b2:	c3                   	ret    
801072b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072c0 <procfsiread>:

void 
procfsiread(struct inode* dp, struct inode *ip) 
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	53                   	push   %ebx
801072c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801072c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  //cprintf("in func PROCFSIREAD, ip->inum= %d, dp->inum = %d \n",ip->inum,dp->inum);
  if (ip->inum < 500) 
801072ca:	8b 50 04             	mov    0x4(%eax),%edx
801072cd:	81 fa f3 01 00 00    	cmp    $0x1f3,%edx
801072d3:	76 39                	jbe    8010730e <procfsiread+0x4e>
		return;

	ip->major = PROCFS;
	ip->size = 0;
	ip->nlink = 1;
801072d5:	bb 01 00 00 00       	mov    $0x1,%ebx
	ip->size = 0;
801072da:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
	ip->type = T_DEV;
	ip->valid = 1;
801072e1:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
	ip->nlink = 1;
801072e8:	66 89 58 56          	mov    %bx,0x56(%eax)
	ip->valid = 1;
801072ec:	c7 40 50 03 00 02 00 	movl   $0x20003,0x50(%eax)
	ip->minor = dp->minor + 1;
801072f3:	0f b7 59 54          	movzwl 0x54(%ecx),%ebx
801072f7:	83 c3 01             	add    $0x1,%ebx
801072fa:	66 89 58 54          	mov    %bx,0x54(%eax)

	if (dp->inum < ip->inum)
801072fe:	3b 51 04             	cmp    0x4(%ecx),%edx
80107301:	76 0b                	jbe    8010730e <procfsiread+0x4e>
		ip->minor = dp->minor + 1;
80107303:	0f b7 51 54          	movzwl 0x54(%ecx),%edx
80107307:	83 c2 01             	add    $0x1,%edx
8010730a:	66 89 50 54          	mov    %dx,0x54(%eax)
	else if (dp->inum < ip->inum)
		ip->minor = dp->minor - 1;
}
8010730e:	5b                   	pop    %ebx
8010730f:	5d                   	pop    %ebp
80107310:	c3                   	ret    
80107311:	eb 0d                	jmp    80107320 <procfswrite>
80107313:	90                   	nop
80107314:	90                   	nop
80107315:	90                   	nop
80107316:	90                   	nop
80107317:	90                   	nop
80107318:	90                   	nop
80107319:	90                   	nop
8010731a:	90                   	nop
8010731b:	90                   	nop
8010731c:	90                   	nop
8010731d:	90                   	nop
8010731e:	90                   	nop
8010731f:	90                   	nop

80107320 <procfswrite>:
  }
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
80107320:	55                   	push   %ebp
  return 0;
}
80107321:	31 c0                	xor    %eax,%eax
{
80107323:	89 e5                	mov    %esp,%ebp
}
80107325:	5d                   	pop    %ebp
80107326:	c3                   	ret    
80107327:	89 f6                	mov    %esi,%esi
80107329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107330 <procfsinit>:

void
procfsinit(void)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	83 ec 0c             	sub    $0xc,%esp
  devsw[PROCFS].isdir = procfsisdir;
80107336:	c7 05 80 1a 11 80 a0 	movl   $0x801072a0,0x80111a80
8010733d:	72 10 80 
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;

  memset(&process_entries, sizeof(process_entries), 0);
80107340:	6a 00                	push   $0x0
80107342:	68 00 02 00 00       	push   $0x200
80107347:	68 20 66 11 80       	push   $0x80116620
  devsw[PROCFS].iread = procfsiread;
8010734c:	c7 05 84 1a 11 80 c0 	movl   $0x801072c0,0x80111a84
80107353:	72 10 80 
  devsw[PROCFS].write = procfswrite;
80107356:	c7 05 8c 1a 11 80 20 	movl   $0x80107320,0x80111a8c
8010735d:	73 10 80 
  devsw[PROCFS].read = procfsread;
80107360:	c7 05 88 1a 11 80 00 	movl   $0x80108000,0x80111a88
80107367:	80 10 80 
  memset(&process_entries, sizeof(process_entries), 0);
8010736a:	e8 d1 d4 ff ff       	call   80104840 <memset>
  memmove(subdir_entries[0].name, "name", 5);
8010736f:	83 c4 0c             	add    $0xc,%esp
80107372:	6a 05                	push   $0x5
80107374:	68 8b 8a 10 80       	push   $0x80108a8b
80107379:	68 02 66 11 80       	push   $0x80116602
8010737e:	e8 6d d5 ff ff       	call   801048f0 <memmove>
  memmove(subdir_entries[1].name, "status", 7);
80107383:	83 c4 0c             	add    $0xc,%esp
80107386:	6a 07                	push   $0x7
80107388:	68 90 8a 10 80       	push   $0x80108a90
8010738d:	68 12 66 11 80       	push   $0x80116612
80107392:	e8 59 d5 ff ff       	call   801048f0 <memmove>
  subdir_entries[0].inum = 0;
80107397:	31 c0                	xor    %eax,%eax
  subdir_entries[1].inum = 0;
80107399:	31 d2                	xor    %edx,%edx
}
8010739b:	83 c4 10             	add    $0x10,%esp
  subdir_entries[0].inum = 0;
8010739e:	66 a3 00 66 11 80    	mov    %ax,0x80116600
  subdir_entries[1].inum = 0;
801073a4:	66 89 15 10 66 11 80 	mov    %dx,0x80116610
}
801073ab:	c9                   	leave  
801073ac:	c3                   	ret    
801073ad:	8d 76 00             	lea    0x0(%esi),%esi

801073b0 <read_file_inodeinfo>:
801073b0:	55                   	push   %ebp
801073b1:	31 c0                	xor    %eax,%eax
801073b3:	89 e5                	mov    %esp,%ebp
801073b5:	5d                   	pop    %ebp
801073b6:	c3                   	ret    
801073b7:	89 f6                	mov    %esi,%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073c0 <read_procfs_pid_dir>:
  return 0;
}

int 
read_procfs_pid_dir(struct inode* ip, char *dst, int off, int n) 
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
  //cprintf("in func read_procfs_pid_dir, ip->inum=%d \n",ip->inum);
  struct dirent temp_entries[2];
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801073c6:	8d 7d c8             	lea    -0x38(%ebp),%edi

	temp_entries[0].inum = ip->inum + 100;
	temp_entries[1].inum = ip->inum + 200;

	if (off + n > sizeof(temp_entries))
		n = sizeof(temp_entries) - off;
801073c9:	bb 20 00 00 00       	mov    $0x20,%ebx
{
801073ce:	83 ec 30             	sub    $0x30,%esp
801073d1:	8b 75 10             	mov    0x10(%ebp),%esi
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801073d4:	6a 20                	push   $0x20
801073d6:	68 00 66 11 80       	push   $0x80116600
801073db:	57                   	push   %edi
		n = sizeof(temp_entries) - off;
801073dc:	29 f3                	sub    %esi,%ebx
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801073de:	e8 0d d5 ff ff       	call   801048f0 <memmove>
	temp_entries[0].inum = ip->inum + 100;
801073e3:	8b 45 08             	mov    0x8(%ebp),%eax
	if (off + n > sizeof(temp_entries))
801073e6:	83 c4 0c             	add    $0xc,%esp
	temp_entries[0].inum = ip->inum + 100;
801073e9:	8b 40 04             	mov    0x4(%eax),%eax
801073ec:	8d 48 64             	lea    0x64(%eax),%ecx
	temp_entries[1].inum = ip->inum + 200;
801073ef:	66 05 c8 00          	add    $0xc8,%ax
801073f3:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	if (off + n > sizeof(temp_entries))
801073f7:	8b 45 14             	mov    0x14(%ebp),%eax
	temp_entries[0].inum = ip->inum + 100;
801073fa:	66 89 4d c8          	mov    %cx,-0x38(%ebp)
	if (off + n > sizeof(temp_entries))
801073fe:	01 f0                	add    %esi,%eax
		n = sizeof(temp_entries) - off;
80107400:	83 f8 20             	cmp    $0x20,%eax
80107403:	0f 46 5d 14          	cmovbe 0x14(%ebp),%ebx
	memmove(dst, (char*)(&temp_entries) + off, n);
80107407:	01 fe                	add    %edi,%esi
80107409:	53                   	push   %ebx
8010740a:	56                   	push   %esi
8010740b:	ff 75 0c             	pushl  0xc(%ebp)
8010740e:	e8 dd d4 ff ff       	call   801048f0 <memmove>
	return n;
}
80107413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107416:	89 d8                	mov    %ebx,%eax
80107418:	5b                   	pop    %ebx
80107419:	5e                   	pop    %esi
8010741a:	5f                   	pop    %edi
8010741b:	5d                   	pop    %ebp
8010741c:	c3                   	ret    
8010741d:	8d 76 00             	lea    0x0(%esi),%esi

80107420 <read_path_level_3>:
	return 0;
}

int 
read_path_level_3(struct inode *ip, char *dst, int off, int n)
{
80107420:	55                   	push   %ebp
  return 0; 
}
80107421:	31 c0                	xor    %eax,%eax
{
80107423:	89 e5                	mov    %esp,%ebp
}
80107425:	5d                   	pop    %ebp
80107426:	c3                   	ret    
80107427:	89 f6                	mov    %esi,%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <procfs_add_proc>:

void 
procfs_add_proc(int pid, char* cwd) 
{
80107430:	55                   	push   %ebp
  //cprintf("procfs_add_proc: %d\n", pid);
	int i;
	for (i = 0; i < MAX_PROCESSES; i++) {
80107431:	31 c0                	xor    %eax,%eax
{
80107433:	89 e5                	mov    %esp,%ebp
80107435:	83 ec 08             	sub    $0x8,%esp
80107438:	eb 0e                	jmp    80107448 <procfs_add_proc+0x18>
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (i = 0; i < MAX_PROCESSES; i++) {
80107440:	83 c0 01             	add    $0x1,%eax
80107443:	83 f8 40             	cmp    $0x40,%eax
80107446:	74 28                	je     80107470 <procfs_add_proc+0x40>
		if (!process_entries[i].used) {
80107448:	8b 14 c5 24 66 11 80 	mov    -0x7fee99dc(,%eax,8),%edx
8010744f:	85 d2                	test   %edx,%edx
80107451:	75 ed                	jne    80107440 <procfs_add_proc+0x10>
			process_entries[i].used = 1;
			process_entries[i].pid = pid;
80107453:	8b 55 08             	mov    0x8(%ebp),%edx
			process_entries[i].used = 1;
80107456:	c7 04 c5 24 66 11 80 	movl   $0x1,-0x7fee99dc(,%eax,8)
8010745d:	01 00 00 00 
			process_entries[i].pid = pid;
80107461:	89 14 c5 20 66 11 80 	mov    %edx,-0x7fee99e0(,%eax,8)
			return;
		}
	}
	panic("Too many processes in procfs!");
}
80107468:	c9                   	leave  
80107469:	c3                   	ret    
8010746a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	panic("Too many processes in procfs!");
80107470:	83 ec 0c             	sub    $0xc,%esp
80107473:	68 97 8a 10 80       	push   $0x80108a97
80107478:	e8 13 8f ff ff       	call   80100390 <panic>
8010747d:	8d 76 00             	lea    0x0(%esi),%esi

80107480 <procfs_remove_proc>:

void
procfs_remove_proc(int pid) 
{
80107480:	55                   	push   %ebp
	//cprintf("procfs_remove_proc: %d\n", pid);
	int i;
	for (i = 0; i < MAX_PROCESSES; i++) {
80107481:	31 c0                	xor    %eax,%eax
{
80107483:	89 e5                	mov    %esp,%ebp
80107485:	83 ec 08             	sub    $0x8,%esp
80107488:	8b 55 08             	mov    0x8(%ebp),%edx
8010748b:	eb 0b                	jmp    80107498 <procfs_remove_proc+0x18>
8010748d:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < MAX_PROCESSES; i++) {
80107490:	83 c0 01             	add    $0x1,%eax
80107493:	83 f8 40             	cmp    $0x40,%eax
80107496:	74 30                	je     801074c8 <procfs_remove_proc+0x48>
		if (process_entries[i].used && process_entries[i].pid == pid) {
80107498:	8b 0c c5 24 66 11 80 	mov    -0x7fee99dc(,%eax,8),%ecx
8010749f:	85 c9                	test   %ecx,%ecx
801074a1:	74 ed                	je     80107490 <procfs_remove_proc+0x10>
801074a3:	39 14 c5 20 66 11 80 	cmp    %edx,-0x7fee99e0(,%eax,8)
801074aa:	75 e4                	jne    80107490 <procfs_remove_proc+0x10>
			process_entries[i].used = process_entries[i].pid = 0;
801074ac:	c7 04 c5 20 66 11 80 	movl   $0x0,-0x7fee99e0(,%eax,8)
801074b3:	00 00 00 00 
801074b7:	c7 04 c5 24 66 11 80 	movl   $0x0,-0x7fee99dc(,%eax,8)
801074be:	00 00 00 00 
			return;
		}
	}
	panic("Failed to find process in procfs_remove_proc!");
}
801074c2:	c9                   	leave  
801074c3:	c3                   	ret    
801074c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	panic("Failed to find process in procfs_remove_proc!");
801074c8:	83 ec 0c             	sub    $0xc,%esp
801074cb:	68 e8 8b 10 80       	push   $0x80108be8
801074d0:	e8 bb 8e ff ff       	call   80100390 <panic>
801074d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074e0 <strcpy>:

//-------------------------HELPERS---------------------------------------
char*
strcpy(char *s, const char *t)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	53                   	push   %ebx
801074e4:	8b 45 08             	mov    0x8(%ebp),%eax
801074e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
801074ea:	89 c2                	mov    %eax,%edx
801074ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074f0:	83 c1 01             	add    $0x1,%ecx
801074f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
801074f7:	83 c2 01             	add    $0x1,%edx
801074fa:	84 db                	test   %bl,%bl
801074fc:	88 5a ff             	mov    %bl,-0x1(%edx)
801074ff:	75 ef                	jne    801074f0 <strcpy+0x10>
    ;
  return os;
}
80107501:	5b                   	pop    %ebx
80107502:	5d                   	pop    %ebp
80107503:	c3                   	ret    
80107504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010750a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107510 <atoi>:

int
atoi(const char *s)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	53                   	push   %ebx
80107514:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
80107517:	0f be 11             	movsbl (%ecx),%edx
8010751a:	8d 42 d0             	lea    -0x30(%edx),%eax
8010751d:	3c 09                	cmp    $0x9,%al
  n = 0;
8010751f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
80107524:	77 1f                	ja     80107545 <atoi+0x35>
80107526:	8d 76 00             	lea    0x0(%esi),%esi
80107529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
80107530:	8d 04 80             	lea    (%eax,%eax,4),%eax
80107533:	83 c1 01             	add    $0x1,%ecx
80107536:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
8010753a:	0f be 11             	movsbl (%ecx),%edx
8010753d:	8d 5a d0             	lea    -0x30(%edx),%ebx
80107540:	80 fb 09             	cmp    $0x9,%bl
80107543:	76 eb                	jbe    80107530 <atoi+0x20>
  return n;
}
80107545:	5b                   	pop    %ebx
80107546:	5d                   	pop    %ebp
80107547:	c3                   	ret    
80107548:	90                   	nop
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107550 <itoa>:

// convert int to string
void 
itoa(char s[], int n)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	31 ff                	xor    %edi,%edi
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010755e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107561:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107564:	c1 f8 1f             	sar    $0x1f,%eax
80107567:	31 c1                	xor    %eax,%ecx
80107569:	29 c1                	sub    %eax,%ecx
8010756b:	eb 05                	jmp    80107572 <itoa+0x22>
8010756d:	8d 76 00             	lea    0x0(%esi),%esi
  
  if (pm < 0) {
    n = -n;          
  }
  do {       
    s[i++] = n % 10 + '0';   
80107570:	89 f7                	mov    %esi,%edi
80107572:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80107577:	8d 77 01             	lea    0x1(%edi),%esi
8010757a:	f7 e1                	mul    %ecx
8010757c:	c1 ea 03             	shr    $0x3,%edx
8010757f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80107582:	01 c0                	add    %eax,%eax
80107584:	29 c1                	sub    %eax,%ecx
80107586:	83 c1 30             	add    $0x30,%ecx
  } while ((n /= 10) > 0);
80107589:	85 d2                	test   %edx,%edx
    s[i++] = n % 10 + '0';   
8010758b:	88 4c 33 ff          	mov    %cl,-0x1(%ebx,%esi,1)
  } while ((n /= 10) > 0);
8010758f:	89 d1                	mov    %edx,%ecx
80107591:	7f dd                	jg     80107570 <itoa+0x20>
  
  if (pm < 0) {
80107593:	8b 45 0c             	mov    0xc(%ebp),%eax
80107596:	01 de                	add    %ebx,%esi
80107598:	85 c0                	test   %eax,%eax
8010759a:	79 07                	jns    801075a3 <itoa+0x53>
    s[i++] = '-';
8010759c:	c6 06 2d             	movb   $0x2d,(%esi)
8010759f:	8d 74 3b 02          	lea    0x2(%ebx,%edi,1),%esi
  }
  s[i] = '\0';
  
  //reverse
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
801075a3:	83 ec 0c             	sub    $0xc,%esp
  s[i] = '\0';
801075a6:	c6 06 00             	movb   $0x0,(%esi)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
801075a9:	53                   	push   %ebx
801075aa:	e8 b1 d4 ff ff       	call   80104a60 <strlen>
801075af:	83 e8 01             	sub    $0x1,%eax
801075b2:	83 c4 10             	add    $0x10,%esp
801075b5:	85 c0                	test   %eax,%eax
801075b7:	7e 21                	jle    801075da <itoa+0x8a>
801075b9:	31 d2                	xor    %edx,%edx
801075bb:	90                   	nop
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = s[t];
801075c0:	0f b6 3c 13          	movzbl (%ebx,%edx,1),%edi
    s[t] = s[j];
801075c4:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801075c8:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    s[j] = c;
801075cb:	89 f9                	mov    %edi,%ecx
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
801075cd:	83 c2 01             	add    $0x1,%edx
    s[j] = c;
801075d0:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
801075d3:	83 e8 01             	sub    $0x1,%eax
801075d6:	39 c2                	cmp    %eax,%edx
801075d8:	7c e6                	jl     801075c0 <itoa+0x70>
  }
} 
801075da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075dd:	5b                   	pop    %ebx
801075de:	5e                   	pop    %esi
801075df:	5f                   	pop    %edi
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret    
801075e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075f0 <update_dir_entries>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
  dir_entries[2].inum = 502;
801075f6:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  int j = 3;
801075fb:	be 03 00 00 00       	mov    $0x3,%esi
{
80107600:	83 ec 10             	sub    $0x10,%esp
	memset(dir_entries, sizeof(dir_entries), 0);
80107603:	6a 00                	push   $0x0
80107605:	68 20 04 00 00       	push   $0x420
8010760a:	68 20 68 11 80       	push   $0x80116820
8010760f:	e8 2c d2 ff ff       	call   80104840 <memset>
  memmove(&dir_entries[0].name, "ideinfo", 8);
80107614:	83 c4 0c             	add    $0xc,%esp
80107617:	6a 08                	push   $0x8
80107619:	68 b5 8a 10 80       	push   $0x80108ab5
8010761e:	68 22 68 11 80       	push   $0x80116822
80107623:	e8 c8 d2 ff ff       	call   801048f0 <memmove>
  memmove(&dir_entries[1].name, "filestat", 9);
80107628:	83 c4 0c             	add    $0xc,%esp
8010762b:	6a 09                	push   $0x9
8010762d:	68 bd 8a 10 80       	push   $0x80108abd
80107632:	68 32 68 11 80       	push   $0x80116832
80107637:	e8 b4 d2 ff ff       	call   801048f0 <memmove>
  memmove(&dir_entries[2].name, "inodeinfo", 10);
8010763c:	83 c4 0c             	add    $0xc,%esp
8010763f:	6a 0a                	push   $0xa
80107641:	68 c6 8a 10 80       	push   $0x80108ac6
80107646:	68 42 68 11 80       	push   $0x80116842
8010764b:	e8 a0 d2 ff ff       	call   801048f0 <memmove>
  dir_entries[0].inum = 500;
80107650:	ba f4 01 00 00       	mov    $0x1f4,%edx
  dir_entries[1].inum = 501;
80107655:	b9 f5 01 00 00       	mov    $0x1f5,%ecx
  dir_entries[2].inum = 502;
8010765a:	66 89 1d 40 68 11 80 	mov    %bx,0x80116840
  dir_entries[0].inum = 500;
80107661:	66 89 15 20 68 11 80 	mov    %dx,0x80116820
  dir_entries[1].inum = 501;
80107668:	66 89 0d 30 68 11 80 	mov    %cx,0x80116830
8010766f:	bb 20 66 11 80       	mov    $0x80116620,%ebx
80107674:	83 c4 10             	add    $0x10,%esp
80107677:	eb 12                	jmp    8010768b <update_dir_entries+0x9b>
80107679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107680:	83 c3 08             	add    $0x8,%ebx
    for (int i = 0; i < MAX_PROCESSES; i++) {
80107683:	81 fb 20 68 11 80    	cmp    $0x80116820,%ebx
80107689:	74 3d                	je     801076c8 <update_dir_entries+0xd8>
		if (process_entries[i].used) {
8010768b:	8b 43 04             	mov    0x4(%ebx),%eax
8010768e:	85 c0                	test   %eax,%eax
80107690:	74 ee                	je     80107680 <update_dir_entries+0x90>
			itoa(dir_entries[j].name, process_entries[i].pid);
80107692:	89 f7                	mov    %esi,%edi
80107694:	83 ec 08             	sub    $0x8,%esp
80107697:	ff 33                	pushl  (%ebx)
80107699:	c1 e7 04             	shl    $0x4,%edi
8010769c:	83 c3 08             	add    $0x8,%ebx
			j++;
8010769f:	83 c6 01             	add    $0x1,%esi
			itoa(dir_entries[j].name, process_entries[i].pid);
801076a2:	8d 87 22 68 11 80    	lea    -0x7fee97de(%edi),%eax
801076a8:	50                   	push   %eax
801076a9:	e8 a2 fe ff ff       	call   80107550 <itoa>
			dir_entries[j].inum = 600 + process_entries[i].pid;
801076ae:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
			j++;
801076b2:	83 c4 10             	add    $0x10,%esp
			dir_entries[j].inum = 600 + process_entries[i].pid;
801076b5:	66 05 58 02          	add    $0x258,%ax
    for (int i = 0; i < MAX_PROCESSES; i++) {
801076b9:	81 fb 20 68 11 80    	cmp    $0x80116820,%ebx
			dir_entries[j].inum = 600 + process_entries[i].pid;
801076bf:	66 89 87 20 68 11 80 	mov    %ax,-0x7fee97e0(%edi)
    for (int i = 0; i < MAX_PROCESSES; i++) {
801076c6:	75 c3                	jne    8010768b <update_dir_entries+0x9b>
}
801076c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076cb:	5b                   	pop    %ebx
801076cc:	5e                   	pop    %esi
801076cd:	5f                   	pop    %edi
801076ce:	5d                   	pop    %ebp
801076cf:	c3                   	ret    

801076d0 <read_path_level_0>:
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
      n = sizeof(dir_entries) - off;
801076d6:	bb 20 04 00 00       	mov    $0x420,%ebx
{
801076db:	83 ec 18             	sub    $0x18,%esp
  update_dir_entries(ip->inum);
801076de:	8b 45 08             	mov    0x8(%ebp),%eax
{
801076e1:	8b 75 10             	mov    0x10(%ebp),%esi
801076e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  update_dir_entries(ip->inum);
801076e7:	ff 70 04             	pushl  0x4(%eax)
      n = sizeof(dir_entries) - off;
801076ea:	29 f3                	sub    %esi,%ebx
  update_dir_entries(ip->inum);
801076ec:	e8 ff fe ff ff       	call   801075f0 <update_dir_entries>
  if (off + n > sizeof(dir_entries))
801076f1:	8d 04 3e             	lea    (%esi,%edi,1),%eax
801076f4:	83 c4 0c             	add    $0xc,%esp
      n = sizeof(dir_entries) - off;
801076f7:	3d 20 04 00 00       	cmp    $0x420,%eax
801076fc:	0f 46 df             	cmovbe %edi,%ebx
  memmove(dst, (char*)(&dir_entries) + off, n);
801076ff:	81 c6 20 68 11 80    	add    $0x80116820,%esi
80107705:	53                   	push   %ebx
80107706:	56                   	push   %esi
80107707:	ff 75 0c             	pushl  0xc(%ebp)
8010770a:	e8 e1 d1 ff ff       	call   801048f0 <memmove>
}
8010770f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107712:	89 d8                	mov    %ebx,%eax
80107714:	5b                   	pop    %ebx
80107715:	5e                   	pop    %esi
80107716:	5f                   	pop    %edi
80107717:	5d                   	pop    %ebp
80107718:	c3                   	ret    
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107720 <get_string_working_blocks>:
{
80107720:	55                   	push   %ebp
80107721:	31 c0                	xor    %eax,%eax
80107723:	89 e5                	mov    %esp,%ebp
80107725:	56                   	push   %esi
80107726:	53                   	push   %ebx
80107727:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010772a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
80107730:	0f b6 90 d0 8a 10 80 	movzbl -0x7fef7530(%eax),%edx
80107737:	83 c0 01             	add    $0x1,%eax
8010773a:	88 90 bf b5 10 80    	mov    %dl,-0x7fef4a41(%eax)
80107740:	84 d2                	test   %dl,%dl
80107742:	75 ec                	jne    80107730 <get_string_working_blocks+0x10>
  while(temp){
80107744:	85 db                	test   %ebx,%ebx
80107746:	0f 84 d0 00 00 00    	je     8010781c <get_string_working_blocks+0xfc>
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    strcpy(currQueue + strlen(currQueue), "(");
80107750:	83 ec 0c             	sub    $0xc,%esp
80107753:	68 c0 b5 10 80       	push   $0x8010b5c0
80107758:	e8 03 d3 ff ff       	call   80104a60 <strlen>
8010775d:	83 c4 10             	add    $0x10,%esp
80107760:	05 c0 b5 10 80       	add    $0x8010b5c0,%eax
80107765:	31 d2                	xor    %edx,%edx
80107767:	89 f6                	mov    %esi,%esi
80107769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
80107770:	0f b6 8a e1 8a 10 80 	movzbl -0x7fef751f(%edx),%ecx
80107777:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010777a:	83 c2 01             	add    $0x1,%edx
8010777d:	84 c9                	test   %cl,%cl
8010777f:	75 ef                	jne    80107770 <get_string_working_blocks+0x50>
	  itoa(currQueue + strlen(currQueue), temp->device_num);
80107781:	83 ec 0c             	sub    $0xc,%esp
80107784:	8b 33                	mov    (%ebx),%esi
80107786:	68 c0 b5 10 80       	push   $0x8010b5c0
8010778b:	e8 d0 d2 ff ff       	call   80104a60 <strlen>
80107790:	5a                   	pop    %edx
80107791:	59                   	pop    %ecx
80107792:	05 c0 b5 10 80       	add    $0x8010b5c0,%eax
80107797:	56                   	push   %esi
80107798:	50                   	push   %eax
80107799:	e8 b2 fd ff ff       	call   80107550 <itoa>
    strcpy(currQueue + strlen(currQueue), ",");
8010779e:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801077a5:	e8 b6 d2 ff ff       	call   80104a60 <strlen>
801077aa:	83 c4 10             	add    $0x10,%esp
801077ad:	05 c0 b5 10 80       	add    $0x8010b5c0,%eax
801077b2:	31 d2                	xor    %edx,%edx
801077b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801077b8:	0f b6 8a e3 8a 10 80 	movzbl -0x7fef751d(%edx),%ecx
801077bf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801077c2:	83 c2 01             	add    $0x1,%edx
801077c5:	84 c9                	test   %cl,%cl
801077c7:	75 ef                	jne    801077b8 <get_string_working_blocks+0x98>
    itoa(currQueue + strlen(currQueue), temp->block_num);
801077c9:	83 ec 0c             	sub    $0xc,%esp
801077cc:	8b 73 04             	mov    0x4(%ebx),%esi
801077cf:	68 c0 b5 10 80       	push   $0x8010b5c0
801077d4:	e8 87 d2 ff ff       	call   80104a60 <strlen>
801077d9:	5a                   	pop    %edx
801077da:	59                   	pop    %ecx
801077db:	05 c0 b5 10 80       	add    $0x8010b5c0,%eax
801077e0:	56                   	push   %esi
801077e1:	50                   	push   %eax
801077e2:	e8 69 fd ff ff       	call   80107550 <itoa>
    strcpy(currQueue + strlen(currQueue), ");");
801077e7:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801077ee:	e8 6d d2 ff ff       	call   80104a60 <strlen>
801077f3:	83 c4 10             	add    $0x10,%esp
801077f6:	05 c0 b5 10 80       	add    $0x8010b5c0,%eax
801077fb:	31 d2                	xor    %edx,%edx
801077fd:	8d 76 00             	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
80107800:	0f b6 8a e5 8a 10 80 	movzbl -0x7fef751b(%edx),%ecx
80107807:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010780a:	83 c2 01             	add    $0x1,%edx
8010780d:	84 c9                	test   %cl,%cl
8010780f:	75 ef                	jne    80107800 <get_string_working_blocks+0xe0>
    temp = temp->next;
80107811:	8b 5b 08             	mov    0x8(%ebx),%ebx
  while(temp){
80107814:	85 db                	test   %ebx,%ebx
80107816:	0f 85 34 ff ff ff    	jne    80107750 <get_string_working_blocks+0x30>
}
8010781c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010781f:	b8 c0 b5 10 80       	mov    $0x8010b5c0,%eax
80107824:	5b                   	pop    %ebx
80107825:	5e                   	pop    %esi
80107826:	5d                   	pop    %ebp
80107827:	c3                   	ret    
80107828:	90                   	nop
80107829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107830 <read_file_ideinfo.part.0>:
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	57                   	push   %edi
80107834:	56                   	push   %esi
80107835:	53                   	push   %ebx
	char data[256] = {0};
80107836:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
8010783c:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
8010783e:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80107843:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80107849:	89 df                	mov    %ebx,%edi
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
8010784b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
80107851:	31 c0                	xor    %eax,%eax
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80107853:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
80107859:	f3 ab                	rep stos %eax,%es:(%edi)
8010785b:	90                   	nop
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107860:	0f b6 90 e8 8a 10 80 	movzbl -0x7fef7518(%eax),%edx
80107867:	88 14 03             	mov    %dl,(%ebx,%eax,1)
8010786a:	83 c0 01             	add    $0x1,%eax
8010786d:	84 d2                	test   %dl,%dl
8010786f:	75 ef                	jne    80107860 <read_file_ideinfo.part.0+0x30>
	itoa(data + strlen(data), get_waiting_ops());
80107871:	e8 ea ab ff ff       	call   80102460 <get_waiting_ops>
80107876:	83 ec 0c             	sub    $0xc,%esp
80107879:	89 c7                	mov    %eax,%edi
8010787b:	53                   	push   %ebx
8010787c:	e8 df d1 ff ff       	call   80104a60 <strlen>
80107881:	5a                   	pop    %edx
80107882:	59                   	pop    %ecx
80107883:	01 d8                	add    %ebx,%eax
80107885:	57                   	push   %edi
80107886:	50                   	push   %eax
80107887:	e8 c4 fc ff ff       	call   80107550 <itoa>
	strcpy(data + strlen(data), "\nRead waiting operations: ");
8010788c:	89 1c 24             	mov    %ebx,(%esp)
8010788f:	e8 cc d1 ff ff       	call   80104a60 <strlen>
80107894:	83 c4 10             	add    $0x10,%esp
80107897:	01 d8                	add    %ebx,%eax
80107899:	31 d2                	xor    %edx,%edx
8010789b:	90                   	nop
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801078a0:	0f b6 8a fd 8a 10 80 	movzbl -0x7fef7503(%edx),%ecx
801078a7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801078aa:	83 c2 01             	add    $0x1,%edx
801078ad:	84 c9                	test   %cl,%cl
801078af:	75 ef                	jne    801078a0 <read_file_ideinfo.part.0+0x70>
	itoa(data + strlen(data), get_read_wait_ops());
801078b1:	e8 ba ab ff ff       	call   80102470 <get_read_wait_ops>
801078b6:	83 ec 0c             	sub    $0xc,%esp
801078b9:	89 c7                	mov    %eax,%edi
801078bb:	53                   	push   %ebx
801078bc:	e8 9f d1 ff ff       	call   80104a60 <strlen>
801078c1:	5a                   	pop    %edx
801078c2:	59                   	pop    %ecx
801078c3:	01 d8                	add    %ebx,%eax
801078c5:	57                   	push   %edi
801078c6:	50                   	push   %eax
801078c7:	e8 84 fc ff ff       	call   80107550 <itoa>
	strcpy(data + strlen(data), "\nWrite waiting operations: ");
801078cc:	89 1c 24             	mov    %ebx,(%esp)
801078cf:	e8 8c d1 ff ff       	call   80104a60 <strlen>
801078d4:	83 c4 10             	add    $0x10,%esp
801078d7:	01 d8                	add    %ebx,%eax
801078d9:	31 d2                	xor    %edx,%edx
801078db:	90                   	nop
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801078e0:	0f b6 8a 18 8b 10 80 	movzbl -0x7fef74e8(%edx),%ecx
801078e7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801078ea:	83 c2 01             	add    $0x1,%edx
801078ed:	84 c9                	test   %cl,%cl
801078ef:	75 ef                	jne    801078e0 <read_file_ideinfo.part.0+0xb0>
	itoa(data + strlen(data), get_write_wait_ops());
801078f1:	e8 ca ab ff ff       	call   801024c0 <get_write_wait_ops>
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	89 c7                	mov    %eax,%edi
801078fb:	53                   	push   %ebx
801078fc:	e8 5f d1 ff ff       	call   80104a60 <strlen>
80107901:	5a                   	pop    %edx
80107902:	59                   	pop    %ecx
80107903:	01 d8                	add    %ebx,%eax
80107905:	57                   	push   %edi
80107906:	50                   	push   %eax
80107907:	e8 44 fc ff ff       	call   80107550 <itoa>
  strcpy(data + strlen(data), "\n");
8010790c:	89 1c 24             	mov    %ebx,(%esp)
8010790f:	e8 4c d1 ff ff       	call   80104a60 <strlen>
80107914:	83 c4 10             	add    $0x10,%esp
80107917:	01 d8                	add    %ebx,%eax
80107919:	31 d2                	xor    %edx,%edx
8010791b:	90                   	nop
8010791c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107920:	0f b6 8a 17 8a 10 80 	movzbl -0x7fef75e9(%edx),%ecx
80107927:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010792a:	83 c2 01             	add    $0x1,%edx
8010792d:	84 c9                	test   %cl,%cl
8010792f:	75 ef                	jne    80107920 <read_file_ideinfo.part.0+0xf0>
  char* workBlocks = get_string_working_blocks(get_working_blocks());
80107931:	e8 da ab ff ff       	call   80102510 <get_working_blocks>
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	50                   	push   %eax
8010793a:	e8 e1 fd ff ff       	call   80107720 <get_string_working_blocks>
  strcpy(data + strlen(data), workBlocks);
8010793f:	89 1c 24             	mov    %ebx,(%esp)
  char* workBlocks = get_string_working_blocks(get_working_blocks());
80107942:	89 c7                	mov    %eax,%edi
  strcpy(data + strlen(data), workBlocks);
80107944:	e8 17 d1 ff ff       	call   80104a60 <strlen>
80107949:	83 c4 10             	add    $0x10,%esp
8010794c:	01 d8                	add    %ebx,%eax
8010794e:	66 90                	xchg   %ax,%ax
  while((*s++ = *t++) != 0)
80107950:	83 c7 01             	add    $0x1,%edi
80107953:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80107957:	83 c0 01             	add    $0x1,%eax
8010795a:	84 d2                	test   %dl,%dl
8010795c:	88 50 ff             	mov    %dl,-0x1(%eax)
8010795f:	75 ef                	jne    80107950 <read_file_ideinfo.part.0+0x120>
	strcpy(data + strlen(data), "\n");
80107961:	83 ec 0c             	sub    $0xc,%esp
80107964:	53                   	push   %ebx
80107965:	e8 f6 d0 ff ff       	call   80104a60 <strlen>
8010796a:	83 c4 10             	add    $0x10,%esp
8010796d:	01 d8                	add    %ebx,%eax
8010796f:	31 d2                	xor    %edx,%edx
80107971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107978:	0f b6 8a 17 8a 10 80 	movzbl -0x7fef75e9(%edx),%ecx
8010797f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107982:	83 c2 01             	add    $0x1,%edx
80107985:	84 c9                	test   %cl,%cl
80107987:	75 ef                	jne    80107978 <read_file_ideinfo.part.0+0x148>
	if (off + n > strlen(data))
80107989:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
8010798f:	83 ec 0c             	sub    $0xc,%esp
80107992:	53                   	push   %ebx
80107993:	8d 3c 06             	lea    (%esi,%eax,1),%edi
80107996:	e8 c5 d0 ff ff       	call   80104a60 <strlen>
8010799b:	83 c4 10             	add    $0x10,%esp
8010799e:	39 c7                	cmp    %eax,%edi
801079a0:	7f 26                	jg     801079c8 <read_file_ideinfo.part.0+0x198>
	memmove(dst, (char*)(&data) + off, n);
801079a2:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
801079a8:	83 ec 04             	sub    $0x4,%esp
801079ab:	56                   	push   %esi
801079ac:	53                   	push   %ebx
801079ad:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
801079b3:	e8 38 cf ff ff       	call   801048f0 <memmove>
}
801079b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bb:	89 f0                	mov    %esi,%eax
801079bd:	5b                   	pop    %ebx
801079be:	5e                   	pop    %esi
801079bf:	5f                   	pop    %edi
801079c0:	5d                   	pop    %ebp
801079c1:	c3                   	ret    
801079c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
801079c8:	83 ec 0c             	sub    $0xc,%esp
801079cb:	53                   	push   %ebx
801079cc:	e8 8f d0 ff ff       	call   80104a60 <strlen>
801079d1:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
801079d7:	83 c4 10             	add    $0x10,%esp
801079da:	89 c6                	mov    %eax,%esi
801079dc:	eb c4                	jmp    801079a2 <read_file_ideinfo.part.0+0x172>
801079de:	66 90                	xchg   %ax,%ax

801079e0 <read_file_ideinfo>:
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 18             	sub    $0x18,%esp
801079e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801079ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  cprintf("in func read_file_ideinfo\n");
801079ef:	68 34 8b 10 80       	push   $0x80108b34
{
801079f4:	8b 7d 10             	mov    0x10(%ebp),%edi
  cprintf("in func read_file_ideinfo\n");
801079f7:	e8 64 8c ff ff       	call   80100660 <cprintf>
  if (n == sizeof(struct dirent))
801079fc:	83 c4 10             	add    $0x10,%esp
801079ff:	83 fb 10             	cmp    $0x10,%ebx
80107a02:	74 1c                	je     80107a20 <read_file_ideinfo+0x40>
}
80107a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a07:	89 d9                	mov    %ebx,%ecx
80107a09:	89 fa                	mov    %edi,%edx
80107a0b:	89 f0                	mov    %esi,%eax
80107a0d:	5b                   	pop    %ebx
80107a0e:	5e                   	pop    %esi
80107a0f:	5f                   	pop    %edi
80107a10:	5d                   	pop    %ebp
80107a11:	e9 1a fe ff ff       	jmp    80107830 <read_file_ideinfo.part.0>
80107a16:	8d 76 00             	lea    0x0(%esi),%esi
80107a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a23:	31 c0                	xor    %eax,%eax
80107a25:	5b                   	pop    %ebx
80107a26:	5e                   	pop    %esi
80107a27:	5f                   	pop    %edi
80107a28:	5d                   	pop    %ebp
80107a29:	c3                   	ret    
80107a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a30 <read_file_filestat.part.1>:
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	57                   	push   %edi
80107a34:	56                   	push   %esi
80107a35:	53                   	push   %ebx
	char data[256] = {0};
80107a36:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107a3c:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
80107a3e:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107a43:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80107a49:	89 df                	mov    %ebx,%edi
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107a4b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
80107a51:	31 c0                	xor    %eax,%eax
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107a53:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
80107a59:	f3 ab                	rep stos %eax,%es:(%edi)
80107a5b:	90                   	nop
80107a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107a60:	0f b6 90 4f 8b 10 80 	movzbl -0x7fef74b1(%eax),%edx
80107a67:	88 14 03             	mov    %dl,(%ebx,%eax,1)
80107a6a:	83 c0 01             	add    $0x1,%eax
80107a6d:	84 d2                	test   %dl,%dl
80107a6f:	75 ef                	jne    80107a60 <read_file_filestat.part.1+0x30>
	itoa(data + strlen(data), get_free_fds());
80107a71:	e8 9a 96 ff ff       	call   80101110 <get_free_fds>
80107a76:	83 ec 0c             	sub    $0xc,%esp
80107a79:	89 c7                	mov    %eax,%edi
80107a7b:	53                   	push   %ebx
80107a7c:	e8 df cf ff ff       	call   80104a60 <strlen>
80107a81:	5a                   	pop    %edx
80107a82:	59                   	pop    %ecx
80107a83:	01 d8                	add    %ebx,%eax
80107a85:	57                   	push   %edi
80107a86:	50                   	push   %eax
80107a87:	e8 c4 fa ff ff       	call   80107550 <itoa>
	strcpy(data + strlen(data), "\nUnique inode fds: ");
80107a8c:	89 1c 24             	mov    %ebx,(%esp)
80107a8f:	e8 cc cf ff ff       	call   80104a60 <strlen>
80107a94:	83 c4 10             	add    $0x10,%esp
80107a97:	01 d8                	add    %ebx,%eax
80107a99:	31 d2                	xor    %edx,%edx
80107a9b:	90                   	nop
80107a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107aa0:	0f b6 8a 5a 8b 10 80 	movzbl -0x7fef74a6(%edx),%ecx
80107aa7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107aaa:	83 c2 01             	add    $0x1,%edx
80107aad:	84 c9                	test   %cl,%cl
80107aaf:	75 ef                	jne    80107aa0 <read_file_filestat.part.1+0x70>
	itoa(data + strlen(data), get_unique_inode_fds()); // TODO
80107ab1:	e8 aa 96 ff ff       	call   80101160 <get_unique_inode_fds>
80107ab6:	83 ec 0c             	sub    $0xc,%esp
80107ab9:	89 c7                	mov    %eax,%edi
80107abb:	53                   	push   %ebx
80107abc:	e8 9f cf ff ff       	call   80104a60 <strlen>
80107ac1:	5a                   	pop    %edx
80107ac2:	59                   	pop    %ecx
80107ac3:	01 d8                	add    %ebx,%eax
80107ac5:	57                   	push   %edi
80107ac6:	50                   	push   %eax
80107ac7:	e8 84 fa ff ff       	call   80107550 <itoa>
	strcpy(data + strlen(data), "\nWriteable fds: ");
80107acc:	89 1c 24             	mov    %ebx,(%esp)
80107acf:	e8 8c cf ff ff       	call   80104a60 <strlen>
80107ad4:	83 c4 10             	add    $0x10,%esp
80107ad7:	01 d8                	add    %ebx,%eax
80107ad9:	31 d2                	xor    %edx,%edx
80107adb:	90                   	nop
80107adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107ae0:	0f b6 8a 6e 8b 10 80 	movzbl -0x7fef7492(%edx),%ecx
80107ae7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107aea:	83 c2 01             	add    $0x1,%edx
80107aed:	84 c9                	test   %cl,%cl
80107aef:	75 ef                	jne    80107ae0 <read_file_filestat.part.1+0xb0>
	itoa(data + strlen(data), get_writeable_fds());
80107af1:	e8 7a 96 ff ff       	call   80101170 <get_writeable_fds>
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	89 c7                	mov    %eax,%edi
80107afb:	53                   	push   %ebx
80107afc:	e8 5f cf ff ff       	call   80104a60 <strlen>
80107b01:	5a                   	pop    %edx
80107b02:	59                   	pop    %ecx
80107b03:	01 d8                	add    %ebx,%eax
80107b05:	57                   	push   %edi
80107b06:	50                   	push   %eax
80107b07:	e8 44 fa ff ff       	call   80107550 <itoa>
  strcpy(data + strlen(data), "\nReadable fds: ");
80107b0c:	89 1c 24             	mov    %ebx,(%esp)
80107b0f:	e8 4c cf ff ff       	call   80104a60 <strlen>
80107b14:	83 c4 10             	add    $0x10,%esp
80107b17:	01 d8                	add    %ebx,%eax
80107b19:	31 d2                	xor    %edx,%edx
80107b1b:	90                   	nop
80107b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107b20:	0f b6 8a 7f 8b 10 80 	movzbl -0x7fef7481(%edx),%ecx
80107b27:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107b2a:	83 c2 01             	add    $0x1,%edx
80107b2d:	84 c9                	test   %cl,%cl
80107b2f:	75 ef                	jne    80107b20 <read_file_filestat.part.1+0xf0>
	itoa(data + strlen(data), get_readable_fds());
80107b31:	e8 8a 96 ff ff       	call   801011c0 <get_readable_fds>
80107b36:	83 ec 0c             	sub    $0xc,%esp
80107b39:	89 c7                	mov    %eax,%edi
80107b3b:	53                   	push   %ebx
80107b3c:	e8 1f cf ff ff       	call   80104a60 <strlen>
80107b41:	5a                   	pop    %edx
80107b42:	59                   	pop    %ecx
80107b43:	01 d8                	add    %ebx,%eax
80107b45:	57                   	push   %edi
80107b46:	50                   	push   %eax
80107b47:	e8 04 fa ff ff       	call   80107550 <itoa>
  strcpy(data + strlen(data), "\nRefs per fds: ");
80107b4c:	89 1c 24             	mov    %ebx,(%esp)
80107b4f:	e8 0c cf ff ff       	call   80104a60 <strlen>
80107b54:	83 c4 10             	add    $0x10,%esp
80107b57:	01 d8                	add    %ebx,%eax
80107b59:	31 d2                	xor    %edx,%edx
80107b5b:	90                   	nop
80107b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107b60:	0f b6 8a 8f 8b 10 80 	movzbl -0x7fef7471(%edx),%ecx
80107b67:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107b6a:	83 c2 01             	add    $0x1,%edx
80107b6d:	84 c9                	test   %cl,%cl
80107b6f:	75 ef                	jne    80107b60 <read_file_filestat.part.1+0x130>
	itoa(data + strlen(data), get_total_refs());
80107b71:	e8 9a 96 ff ff       	call   80101210 <get_total_refs>
80107b76:	83 ec 0c             	sub    $0xc,%esp
80107b79:	89 c7                	mov    %eax,%edi
80107b7b:	53                   	push   %ebx
80107b7c:	e8 df ce ff ff       	call   80104a60 <strlen>
80107b81:	5a                   	pop    %edx
80107b82:	59                   	pop    %ecx
80107b83:	01 d8                	add    %ebx,%eax
80107b85:	57                   	push   %edi
80107b86:	50                   	push   %eax
80107b87:	e8 c4 f9 ff ff       	call   80107550 <itoa>
	strcpy(data + strlen(data), " / ");
80107b8c:	89 1c 24             	mov    %ebx,(%esp)
80107b8f:	e8 cc ce ff ff       	call   80104a60 <strlen>
80107b94:	83 c4 10             	add    $0x10,%esp
80107b97:	01 d8                	add    %ebx,%eax
80107b99:	31 d2                	xor    %edx,%edx
80107b9b:	90                   	nop
80107b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107ba0:	0f b6 8a 9f 8b 10 80 	movzbl -0x7fef7461(%edx),%ecx
80107ba7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107baa:	83 c2 01             	add    $0x1,%edx
80107bad:	84 c9                	test   %cl,%cl
80107baf:	75 ef                	jne    80107ba0 <read_file_filestat.part.1+0x170>
	itoa(data + strlen(data), get_used_fds());
80107bb1:	e8 aa 96 ff ff       	call   80101260 <get_used_fds>
80107bb6:	83 ec 0c             	sub    $0xc,%esp
80107bb9:	89 c7                	mov    %eax,%edi
80107bbb:	53                   	push   %ebx
80107bbc:	e8 9f ce ff ff       	call   80104a60 <strlen>
80107bc1:	5a                   	pop    %edx
80107bc2:	59                   	pop    %ecx
80107bc3:	01 d8                	add    %ebx,%eax
80107bc5:	57                   	push   %edi
80107bc6:	50                   	push   %eax
80107bc7:	e8 84 f9 ff ff       	call   80107550 <itoa>
	strcpy(data + strlen(data), "\n");
80107bcc:	89 1c 24             	mov    %ebx,(%esp)
80107bcf:	e8 8c ce ff ff       	call   80104a60 <strlen>
80107bd4:	83 c4 10             	add    $0x10,%esp
80107bd7:	01 d8                	add    %ebx,%eax
80107bd9:	31 d2                	xor    %edx,%edx
80107bdb:	90                   	nop
80107bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107be0:	0f b6 8a 17 8a 10 80 	movzbl -0x7fef75e9(%edx),%ecx
80107be7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80107bea:	83 c2 01             	add    $0x1,%edx
80107bed:	84 c9                	test   %cl,%cl
80107bef:	75 ef                	jne    80107be0 <read_file_filestat.part.1+0x1b0>
	if (off + n > strlen(data))
80107bf1:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80107bf7:	83 ec 0c             	sub    $0xc,%esp
80107bfa:	53                   	push   %ebx
80107bfb:	8d 3c 06             	lea    (%esi,%eax,1),%edi
80107bfe:	e8 5d ce ff ff       	call   80104a60 <strlen>
80107c03:	83 c4 10             	add    $0x10,%esp
80107c06:	39 c7                	cmp    %eax,%edi
80107c08:	7f 26                	jg     80107c30 <read_file_filestat.part.1+0x200>
	memmove(dst, (char*)(&data) + off, n);
80107c0a:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
80107c10:	83 ec 04             	sub    $0x4,%esp
80107c13:	56                   	push   %esi
80107c14:	53                   	push   %ebx
80107c15:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
80107c1b:	e8 d0 cc ff ff       	call   801048f0 <memmove>
}
80107c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c23:	89 f0                	mov    %esi,%eax
80107c25:	5b                   	pop    %ebx
80107c26:	5e                   	pop    %esi
80107c27:	5f                   	pop    %edi
80107c28:	5d                   	pop    %ebp
80107c29:	c3                   	ret    
80107c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
80107c30:	83 ec 0c             	sub    $0xc,%esp
80107c33:	53                   	push   %ebx
80107c34:	e8 27 ce ff ff       	call   80104a60 <strlen>
80107c39:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
80107c3f:	83 c4 10             	add    $0x10,%esp
80107c42:	89 c6                	mov    %eax,%esi
80107c44:	eb c4                	jmp    80107c0a <read_file_filestat.part.1+0x1da>
80107c46:	8d 76 00             	lea    0x0(%esi),%esi
80107c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c50 <read_file_filestat>:
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107c56:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c59:	8b 55 10             	mov    0x10(%ebp),%edx
  if (n == sizeof(struct dirent))
80107c5c:	83 f9 10             	cmp    $0x10,%ecx
80107c5f:	74 0f                	je     80107c70 <read_file_filestat+0x20>
}
80107c61:	5d                   	pop    %ebp
80107c62:	e9 c9 fd ff ff       	jmp    80107a30 <read_file_filestat.part.1>
80107c67:	89 f6                	mov    %esi,%esi
80107c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107c70:	31 c0                	xor    %eax,%eax
80107c72:	5d                   	pop    %ebp
80107c73:	c3                   	ret    
80107c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c80 <read_path_level_1>:
{
80107c80:	55                   	push   %ebp
80107c81:	89 e5                	mov    %esp,%ebp
80107c83:	57                   	push   %edi
80107c84:	56                   	push   %esi
80107c85:	53                   	push   %ebx
80107c86:	83 ec 1c             	sub    $0x1c,%esp
  switch (ip->inum) {
80107c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
{
80107c8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107c8f:	8b 55 10             	mov    0x10(%ebp),%edx
80107c92:	8b 75 14             	mov    0x14(%ebp),%esi
  switch (ip->inum) {
80107c95:	8b 5b 04             	mov    0x4(%ebx),%ebx
80107c98:	81 fb f5 01 00 00    	cmp    $0x1f5,%ebx
80107c9e:	74 20                	je     80107cc0 <read_path_level_1+0x40>
80107ca0:	81 fb f6 01 00 00    	cmp    $0x1f6,%ebx
80107ca6:	74 1d                	je     80107cc5 <read_path_level_1+0x45>
80107ca8:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
80107cae:	74 20                	je     80107cd0 <read_path_level_1+0x50>
}
80107cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cb3:	5b                   	pop    %ebx
80107cb4:	5e                   	pop    %esi
80107cb5:	5f                   	pop    %edi
80107cb6:	5d                   	pop    %ebp
      return read_procfs_pid_dir(ip, dst, off, n);
80107cb7:	e9 04 f7 ff ff       	jmp    801073c0 <read_procfs_pid_dir>
80107cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (n == sizeof(struct dirent))
80107cc0:	83 fe 10             	cmp    $0x10,%esi
80107cc3:	75 3b                	jne    80107d00 <read_path_level_1+0x80>
}
80107cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cc8:	31 c0                	xor    %eax,%eax
80107cca:	5b                   	pop    %ebx
80107ccb:	5e                   	pop    %esi
80107ccc:	5f                   	pop    %edi
80107ccd:	5d                   	pop    %ebp
80107cce:	c3                   	ret    
80107ccf:	90                   	nop
  cprintf("in func read_file_ideinfo\n");
80107cd0:	83 ec 0c             	sub    $0xc,%esp
80107cd3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107cd6:	68 34 8b 10 80       	push   $0x80108b34
80107cdb:	e8 80 89 ff ff       	call   80100660 <cprintf>
  if (n == sizeof(struct dirent))
80107ce0:	83 c4 10             	add    $0x10,%esp
80107ce3:	83 fe 10             	cmp    $0x10,%esi
80107ce6:	74 dd                	je     80107cc5 <read_path_level_1+0x45>
80107ce8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80107ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cee:	89 f1                	mov    %esi,%ecx
80107cf0:	89 f8                	mov    %edi,%eax
80107cf2:	5b                   	pop    %ebx
80107cf3:	5e                   	pop    %esi
80107cf4:	5f                   	pop    %edi
80107cf5:	5d                   	pop    %ebp
80107cf6:	e9 35 fb ff ff       	jmp    80107830 <read_file_ideinfo.part.0>
80107cfb:	90                   	nop
80107cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d03:	89 f1                	mov    %esi,%ecx
80107d05:	89 f8                	mov    %edi,%eax
80107d07:	5b                   	pop    %ebx
80107d08:	5e                   	pop    %esi
80107d09:	5f                   	pop    %edi
80107d0a:	5d                   	pop    %ebp
80107d0b:	e9 20 fd ff ff       	jmp    80107a30 <read_file_filestat.part.1>

80107d10 <read_procfs_status>:
{
80107d10:	55                   	push   %ebp
	char status[250] = {0};
80107d11:	31 c0                	xor    %eax,%eax
{
80107d13:	89 e5                	mov    %esp,%ebp
80107d15:	57                   	push   %edi
80107d16:	56                   	push   %esi
80107d17:	53                   	push   %ebx
	char status[250] = {0};
80107d18:	8d 9d ee fe ff ff    	lea    -0x112(%ebp),%ebx
80107d1e:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
	char szBuf[100] = {0};
80107d24:	8d b5 8a fe ff ff    	lea    -0x176(%ebp),%esi
	char status[250] = {0};
80107d2a:	89 d9                	mov    %ebx,%ecx
{
80107d2c:	81 ec a8 01 00 00    	sub    $0x1a8,%esp
	char status[250] = {0};
80107d32:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80107d39:	00 00 00 
80107d3c:	29 f9                	sub    %edi,%ecx
80107d3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107d45:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
80107d4b:	c1 e9 02             	shr    $0x2,%ecx
80107d4e:	f3 ab                	rep stos %eax,%es:(%edi)
	char szBuf[100] = {0};
80107d50:	8d bd 8c fe ff ff    	lea    -0x174(%ebp),%edi
80107d56:	89 f1                	mov    %esi,%ecx
80107d58:	c7 85 8a fe ff ff 00 	movl   $0x0,-0x176(%ebp)
80107d5f:	00 00 00 
80107d62:	c7 85 ea fe ff ff 00 	movl   $0x0,-0x116(%ebp)
80107d69:	00 00 00 
80107d6c:	29 f9                	sub    %edi,%ecx
80107d6e:	83 c1 64             	add    $0x64,%ecx
80107d71:	c1 e9 02             	shr    $0x2,%ecx
80107d74:	f3 ab                	rep stos %eax,%es:(%edi)
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80107d76:	c7 85 70 fe ff ff a3 	movl   $0x80108ba3,-0x190(%ebp)
80107d7d:	8b 10 80 
80107d80:	c7 85 74 fe ff ff aa 	movl   $0x80108baa,-0x18c(%ebp)
80107d87:	8b 10 80 
80107d8a:	c7 85 78 fe ff ff b1 	movl   $0x80108bb1,-0x188(%ebp)
80107d91:	8b 10 80 
80107d94:	c7 85 7c fe ff ff ba 	movl   $0x80108bba,-0x184(%ebp)
80107d9b:	8b 10 80 
	int pid = ip->inum - 800;
80107d9e:	8b 45 08             	mov    0x8(%ebp),%eax
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80107da1:	c7 85 80 fe ff ff c3 	movl   $0x80108bc3,-0x180(%ebp)
80107da8:	8b 10 80 
80107dab:	c7 85 84 fe ff ff cb 	movl   $0x80108bcb,-0x17c(%ebp)
80107db2:	8b 10 80 
	int pid = ip->inum - 800;
80107db5:	8b 40 04             	mov    0x4(%eax),%eax
80107db8:	2d 20 03 00 00       	sub    $0x320,%eax
  struct proc *p = find_proc_by_pid(pid);
80107dbd:	50                   	push   %eax
80107dbe:	e8 bd c6 ff ff       	call   80104480 <find_proc_by_pid>
80107dc3:	89 c7                	mov    %eax,%edi
  int size = strlen(procstate[p->state]);
80107dc5:	58                   	pop    %eax
80107dc6:	8b 47 0c             	mov    0xc(%edi),%eax
80107dc9:	ff b4 85 70 fe ff ff 	pushl  -0x190(%ebp,%eax,4)
80107dd0:	e8 8b cc ff ff       	call   80104a60 <strlen>
80107dd5:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  strcpy(status, procstate[p->state]);
80107ddb:	8b 47 0c             	mov    0xc(%edi),%eax
80107dde:	83 c4 10             	add    $0x10,%esp
80107de1:	8b 8c 85 70 fe ff ff 	mov    -0x190(%ebp,%eax,4),%ecx
80107de8:	31 c0                	xor    %eax,%eax
80107dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
80107df0:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
80107df4:	88 14 03             	mov    %dl,(%ebx,%eax,1)
80107df7:	83 c0 01             	add    $0x1,%eax
80107dfa:	84 d2                	test   %dl,%dl
80107dfc:	75 f2                	jne    80107df0 <read_procfs_status+0xe0>
  status[size] = ' ';
80107dfe:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
  itoa(szBuf, p->sz);
80107e04:	83 ec 08             	sub    $0x8,%esp
  status[size] = ' ';
80107e07:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
80107e0e:	20 
  itoa(szBuf, p->sz);
80107e0f:	ff 37                	pushl  (%edi)
80107e11:	56                   	push   %esi
80107e12:	e8 39 f7 ff ff       	call   80107550 <itoa>
  strcpy(status + size + 1, szBuf);
80107e17:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
80107e1d:	83 c4 10             	add    $0x10,%esp
80107e20:	8d 4c 03 01          	lea    0x1(%ebx,%eax,1),%ecx
80107e24:	31 c0                	xor    %eax,%eax
80107e26:	8d 76 00             	lea    0x0(%esi),%esi
80107e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
80107e30:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80107e34:	88 14 01             	mov    %dl,(%ecx,%eax,1)
80107e37:	83 c0 01             	add    $0x1,%eax
80107e3a:	84 d2                	test   %dl,%dl
80107e3c:	75 f2                	jne    80107e30 <read_procfs_status+0x120>
  status[strlen(status)] = '\n';
80107e3e:	83 ec 0c             	sub    $0xc,%esp
80107e41:	53                   	push   %ebx
80107e42:	e8 19 cc ff ff       	call   80104a60 <strlen>
  int status_size = strlen(status);
80107e47:	89 1c 24             	mov    %ebx,(%esp)
  status[strlen(status)] = '\n';
80107e4a:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
80107e51:	0a 
  int status_size = strlen(status);
80107e52:	e8 09 cc ff ff       	call   80104a60 <strlen>
  if (off + n > status_size)
80107e57:	8b 55 10             	mov    0x10(%ebp),%edx
80107e5a:	03 55 14             	add    0x14(%ebp),%edx
    n = status_size - off;
80107e5d:	89 c6                	mov    %eax,%esi
80107e5f:	2b 75 10             	sub    0x10(%ebp),%esi
  if (off + n > status_size)
80107e62:	83 c4 0c             	add    $0xc,%esp
    n = status_size - off;
80107e65:	39 c2                	cmp    %eax,%edx
80107e67:	0f 4e 75 14          	cmovle 0x14(%ebp),%esi
  memmove(dst, (char*)(&status) + off, n);
80107e6b:	03 5d 10             	add    0x10(%ebp),%ebx
80107e6e:	56                   	push   %esi
80107e6f:	53                   	push   %ebx
80107e70:	ff 75 0c             	pushl  0xc(%ebp)
80107e73:	e8 78 ca ff ff       	call   801048f0 <memmove>
}
80107e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e7b:	89 f0                	mov    %esi,%eax
80107e7d:	5b                   	pop    %ebx
80107e7e:	5e                   	pop    %esi
80107e7f:	5f                   	pop    %edi
80107e80:	5d                   	pop    %ebp
80107e81:	c3                   	ret    
80107e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e90 <read_procfs_name>:
{
80107e90:	55                   	push   %ebp
	char name[250] = {0};
80107e91:	31 c0                	xor    %eax,%eax
{
80107e93:	89 e5                	mov    %esp,%ebp
80107e95:	57                   	push   %edi
80107e96:	56                   	push   %esi
80107e97:	53                   	push   %ebx
	char name[250] = {0};
80107e98:	8d 9d ee fe ff ff    	lea    -0x112(%ebp),%ebx
80107e9e:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
	char szBuf[100] = {0};
80107ea4:	8d b5 8a fe ff ff    	lea    -0x176(%ebp),%esi
	char name[250] = {0};
80107eaa:	89 d9                	mov    %ebx,%ecx
{
80107eac:	81 ec 88 01 00 00    	sub    $0x188,%esp
	char name[250] = {0};
80107eb2:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80107eb9:	00 00 00 
80107ebc:	29 f9                	sub    %edi,%ecx
80107ebe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107ec5:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
80107ecb:	c1 e9 02             	shr    $0x2,%ecx
80107ece:	f3 ab                	rep stos %eax,%es:(%edi)
	char szBuf[100] = {0};
80107ed0:	8d bd 8c fe ff ff    	lea    -0x174(%ebp),%edi
80107ed6:	89 f1                	mov    %esi,%ecx
80107ed8:	c7 85 8a fe ff ff 00 	movl   $0x0,-0x176(%ebp)
80107edf:	00 00 00 
80107ee2:	c7 85 ea fe ff ff 00 	movl   $0x0,-0x116(%ebp)
80107ee9:	00 00 00 
80107eec:	29 f9                	sub    %edi,%ecx
80107eee:	83 c1 64             	add    $0x64,%ecx
80107ef1:	c1 e9 02             	shr    $0x2,%ecx
80107ef4:	f3 ab                	rep stos %eax,%es:(%edi)
	int pid = ip->inum - 700;
80107ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef9:	8b 40 04             	mov    0x4(%eax),%eax
80107efc:	2d bc 02 00 00       	sub    $0x2bc,%eax
  struct proc *p = find_proc_by_pid(pid);
80107f01:	50                   	push   %eax
80107f02:	e8 79 c5 ff ff       	call   80104480 <find_proc_by_pid>
  int size = strlen(p->name);
80107f07:	8d 78 6c             	lea    0x6c(%eax),%edi
  struct proc *p = find_proc_by_pid(pid);
80107f0a:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
  int size = strlen(p->name);
80107f10:	89 3c 24             	mov    %edi,(%esp)
80107f13:	e8 48 cb ff ff       	call   80104a60 <strlen>
80107f18:	83 c4 10             	add    $0x10,%esp
80107f1b:	31 d2                	xor    %edx,%edx
80107f1d:	8d 76 00             	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
80107f20:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
80107f24:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
80107f27:	83 c2 01             	add    $0x1,%edx
80107f2a:	84 c9                	test   %cl,%cl
80107f2c:	75 f2                	jne    80107f20 <read_procfs_name+0x90>
  name[size] = ' ';
80107f2e:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
80107f35:	20 
80107f36:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
  itoa(szBuf, p->sz);
80107f3c:	83 ec 08             	sub    $0x8,%esp
80107f3f:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
80107f45:	ff 30                	pushl  (%eax)
80107f47:	56                   	push   %esi
80107f48:	e8 03 f6 ff ff       	call   80107550 <itoa>
  strcpy(name + size + 1, szBuf);
80107f4d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
80107f53:	83 c4 10             	add    $0x10,%esp
80107f56:	8d 4c 03 01          	lea    0x1(%ebx,%eax,1),%ecx
80107f5a:	31 c0                	xor    %eax,%eax
80107f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107f60:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80107f64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
80107f67:	83 c0 01             	add    $0x1,%eax
80107f6a:	84 d2                	test   %dl,%dl
80107f6c:	75 f2                	jne    80107f60 <read_procfs_name+0xd0>
  name[strlen(name)] = '\n';
80107f6e:	83 ec 0c             	sub    $0xc,%esp
80107f71:	53                   	push   %ebx
80107f72:	e8 e9 ca ff ff       	call   80104a60 <strlen>
  int name_size = strlen(name);
80107f77:	89 1c 24             	mov    %ebx,(%esp)
  name[strlen(name)] = '\n';
80107f7a:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
80107f81:	0a 
  int name_size = strlen(name);
80107f82:	e8 d9 ca ff ff       	call   80104a60 <strlen>
  if (off + n > name_size)
80107f87:	8b 55 10             	mov    0x10(%ebp),%edx
80107f8a:	03 55 14             	add    0x14(%ebp),%edx
    n = name_size - off;
80107f8d:	89 c6                	mov    %eax,%esi
80107f8f:	2b 75 10             	sub    0x10(%ebp),%esi
  if (off + n > name_size)
80107f92:	83 c4 0c             	add    $0xc,%esp
    n = name_size - off;
80107f95:	39 c2                	cmp    %eax,%edx
80107f97:	0f 4e 75 14          	cmovle 0x14(%ebp),%esi
  memmove(dst, (char*)(&name) + off, n);
80107f9b:	03 5d 10             	add    0x10(%ebp),%ebx
80107f9e:	56                   	push   %esi
80107f9f:	53                   	push   %ebx
80107fa0:	ff 75 0c             	pushl  0xc(%ebp)
80107fa3:	e8 48 c9 ff ff       	call   801048f0 <memmove>
}
80107fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fab:	89 f0                	mov    %esi,%eax
80107fad:	5b                   	pop    %ebx
80107fae:	5e                   	pop    %esi
80107faf:	5f                   	pop    %edi
80107fb0:	5d                   	pop    %ebp
80107fb1:	c3                   	ret    
80107fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107fc0 <read_path_level_2>:
{
80107fc0:	55                   	push   %ebp
  switch (ip->inum/100) {
80107fc1:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
{
80107fc6:	89 e5                	mov    %esp,%ebp
  switch (ip->inum/100) {
80107fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fcb:	8b 50 04             	mov    0x4(%eax),%edx
80107fce:	89 d0                	mov    %edx,%eax
80107fd0:	f7 e1                	mul    %ecx
80107fd2:	c1 ea 05             	shr    $0x5,%edx
80107fd5:	83 fa 07             	cmp    $0x7,%edx
80107fd8:	74 16                	je     80107ff0 <read_path_level_2+0x30>
80107fda:	83 fa 08             	cmp    $0x8,%edx
80107fdd:	75 09                	jne    80107fe8 <read_path_level_2+0x28>
}
80107fdf:	5d                   	pop    %ebp
      return read_procfs_status(ip, dst, off, n);
80107fe0:	e9 2b fd ff ff       	jmp    80107d10 <read_procfs_status>
80107fe5:	8d 76 00             	lea    0x0(%esi),%esi
}
80107fe8:	31 c0                	xor    %eax,%eax
80107fea:	5d                   	pop    %ebp
80107feb:	c3                   	ret    
80107fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ff0:	5d                   	pop    %ebp
      return read_procfs_name(ip, dst, off, n);
80107ff1:	e9 9a fe ff ff       	jmp    80107e90 <read_procfs_name>
80107ff6:	8d 76 00             	lea    0x0(%esi),%esi
80107ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108000 <procfsread>:
{
80108000:	55                   	push   %ebp
80108001:	89 e5                	mov    %esp,%ebp
80108003:	83 ec 08             	sub    $0x8,%esp
  switch (ip->minor){
80108006:	8b 45 08             	mov    0x8(%ebp),%eax
80108009:	0f bf 50 54          	movswl 0x54(%eax),%edx
8010800d:	66 83 fa 01          	cmp    $0x1,%dx
80108011:	74 4d                	je     80108060 <procfsread+0x60>
80108013:	7e 3b                	jle    80108050 <procfsread+0x50>
80108015:	66 83 fa 02          	cmp    $0x2,%dx
80108019:	74 0d                	je     80108028 <procfsread+0x28>
      return read_path_level_3(ip,dst,off,n);
8010801b:	31 c0                	xor    %eax,%eax
  switch (ip->minor){
8010801d:	66 83 fa 03          	cmp    $0x3,%dx
80108021:	75 0d                	jne    80108030 <procfsread+0x30>
}
80108023:	c9                   	leave  
80108024:	c3                   	ret    
80108025:	8d 76 00             	lea    0x0(%esi),%esi
80108028:	c9                   	leave  
      return read_path_level_2(ip,dst,off,n);
80108029:	eb 95                	jmp    80107fc0 <read_path_level_2>
8010802b:	90                   	nop
8010802c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("procfsread minor: %d", ip->minor);
80108030:	83 ec 08             	sub    $0x8,%esp
80108033:	52                   	push   %edx
80108034:	68 d2 8b 10 80       	push   $0x80108bd2
80108039:	e8 22 86 ff ff       	call   80100660 <cprintf>
      return -1;
8010803e:	83 c4 10             	add    $0x10,%esp
80108041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108046:	c9                   	leave  
80108047:	c3                   	ret    
80108048:	90                   	nop
80108049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch (ip->minor){
80108050:	66 85 d2             	test   %dx,%dx
80108053:	75 db                	jne    80108030 <procfsread+0x30>
}
80108055:	c9                   	leave  
      return read_path_level_0(ip,dst,off,n);
80108056:	e9 75 f6 ff ff       	jmp    801076d0 <read_path_level_0>
8010805b:	90                   	nop
8010805c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80108060:	c9                   	leave  
      return read_path_level_1(ip,dst,off,n);
80108061:	e9 1a fc ff ff       	jmp    80107c80 <read_path_level_1>
