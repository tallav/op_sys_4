
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 30 10 80       	mov    $0x80103000,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 7a 10 80       	push   $0x80107a40
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 55 43 00 00       	call   801043b0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 7a 10 80       	push   $0x80107a47
80100097:	50                   	push   %eax
80100098:	e8 e3 41 00 00       	call   80104280 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 07 44 00 00       	call   801044f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 49 44 00 00       	call   801045b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 41 00 00       	call   801042c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 fd 20 00 00       	call   80102280 <iderw>
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
80100193:	68 4e 7a 10 80       	push   $0x80107a4e
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
801001ae:	e8 ad 41 00 00       	call   80104360 <holdingsleep>
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
801001c4:	e9 b7 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 7a 10 80       	push   $0x80107a5f
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
801001ef:	e8 6c 41 00 00       	call   80104360 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 41 00 00       	call   80104320 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 e0 42 00 00       	call   801044f0 <acquire>
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
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 4f 43 00 00       	jmp    801045b0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 7a 10 80       	push   $0x80107a66
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
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 5f 42 00 00       	call   801044f0 <acquire>
  while(n > 0){
80100291:	8b 5d 14             	mov    0x14(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
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
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 26 3c 00 00       	call   80103ef0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 36 00 00       	call   80103950 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 bc 42 00 00       	call   801045b0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
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
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
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
8010034d:	e8 5e 42 00 00       	call   801045b0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
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
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
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
801003a9:	e8 e2 24 00 00       	call   80102890 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 7a 10 80       	push   $0x80107a6d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 b7 83 10 80 	movl   $0x801083b7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 3f 00 00       	call   801043d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 7a 10 80       	push   $0x80107a81
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
8010043a:	e8 31 58 00 00       	call   80105c70 <uartputc>
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
801004ec:	e8 7f 57 00 00       	call   80105c70 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 73 57 00 00       	call   80105c70 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 67 57 00 00       	call   80105c70 <uartputc>
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
80100524:	e8 87 41 00 00       	call   801046b0 <memmove>
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
80100541:	e8 ba 40 00 00       	call   80104600 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 7a 10 80       	push   $0x80107a85
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
801005b1:	0f b6 92 b0 7a 10 80 	movzbl -0x7fef8550(%edx),%edx
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
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 d0 3e 00 00       	call   801044f0 <acquire>
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
80100647:	e8 64 3f 00 00       	call   801045b0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

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
8010071f:	e8 8c 3e 00 00       	call   801045b0 <release>
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
801007d0:	ba 98 7a 10 80       	mov    $0x80107a98,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 fb 3c 00 00       	call   801044f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 7a 10 80       	push   $0x80107a9f
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
80100823:	e8 c8 3c 00 00       	call   801044f0 <acquire>
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
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
80100888:	e8 23 3d 00 00       	call   801045b0 <release>
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
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 85 37 00 00       	call   801040a0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
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
80100997:	e9 e4 37 00 00       	jmp    80104180 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
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
801009c6:	68 a8 7a 10 80       	push   $0x80107aa8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 db 39 00 00       	call   801043b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 7c 19 11 80 00 	movl   $0x80100600,0x8011197c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 78 19 11 80 70 	movl   $0x80100270,0x80111978
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 32 1a 00 00       	call   80102430 <ioapicenable>
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
80100a1c:	e8 2f 2f 00 00       	call   80103950 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 d4 22 00 00       	call   80102d00 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 49 15 00 00       	call   80101f80 <namei>
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
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
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
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 fc 22 00 00       	call   80102d70 <end_op>
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
80100a94:	e8 27 63 00 00       	call   80106dc0 <setupkvm>
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
80100af6:	e8 e5 60 00 00       	call   80106be0 <allocuvm>
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
80100b28:	e8 f3 5f 00 00       	call   80106b20 <loaduvm>
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
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 c9 61 00 00       	call   80106d40 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 d1 21 00 00       	call   80102d70 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 31 60 00 00       	call   80106be0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 61 00 00       	call   80106d40 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 98 21 00 00       	call   80102d70 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 c1 7a 10 80       	push   $0x80107ac1
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
80100c06:	e8 55 62 00 00       	call   80106e60 <clearpteu>
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
80100c39:	e8 e2 3b 00 00       	call   80104820 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 cf 3b 00 00       	call   80104820 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 5e 63 00 00       	call   80106fc0 <copyout>
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
80100cc7:	e8 f4 62 00 00       	call   80106fc0 <copyout>
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
80100d0a:	e8 d1 3a 00 00       	call   801047e0 <safestrcpy>
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
80100d34:	e8 57 5c 00 00       	call   80106990 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ff 5f 00 00       	call   80106d40 <freevm>
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
80100d66:	68 cd 7a 10 80       	push   $0x80107acd
80100d6b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d70:	e8 3b 36 00 00       	call   801043b0 <initlock>
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
80100d84:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d91:	e8 5a 37 00 00       	call   801044f0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
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
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 ea 37 00 00       	call   801045b0 <release>
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
80100dd5:	68 c0 0f 11 80       	push   $0x80110fc0
80100dda:	e8 d1 37 00 00       	call   801045b0 <release>
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
80100dfa:	68 c0 0f 11 80       	push   $0x80110fc0
80100dff:	e8 ec 36 00 00       	call   801044f0 <acquire>
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
80100e17:	68 c0 0f 11 80       	push   $0x80110fc0
80100e1c:	e8 8f 37 00 00       	call   801045b0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 d4 7a 10 80       	push   $0x80107ad4
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
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 9a 36 00 00       	call   801044f0 <acquire>
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
80100e6e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
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
80100e7c:	e9 2f 37 00 00       	jmp    801045b0 <release>
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
80100ea0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 03 37 00 00       	call   801045b0 <release>
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
80100ed1:	e8 da 25 00 00       	call   801034b0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 1b 1e 00 00       	call   80102d00 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 71 1e 00 00       	jmp    80102d70 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 dc 7a 10 80       	push   $0x80107adc
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
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
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
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
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
80100fcd:	e9 8e 26 00 00       	jmp    80103660 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 e6 7a 10 80       	push   $0x80107ae6
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
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 22 1d 00 00       	call   80102d70 <end_op>
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
80101076:	e8 85 1c 00 00       	call   80102d00 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 be 1c 00 00       	call   80102d70 <end_op>
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
801010ed:	e9 5e 24 00 00       	jmp    80103550 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 ef 7a 10 80       	push   $0x80107aef
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 f5 7a 10 80       	push   $0x80107af5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d 00 1a 11 80    	mov    0x80111a00,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 18 1a 11 80    	add    0x80111a18,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 00 1a 11 80       	mov    0x80111a00,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 00 1a 11 80    	cmp    %eax,0x80111a00
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 ff 7a 10 80       	push   $0x80107aff
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 fe 1c 00 00       	call   80102ed0 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 06 34 00 00       	call   80104600 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 ce 1c 00 00       	call   80102ed0 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 54 1a 11 80       	mov    $0x80111a54,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 20 1a 11 80       	push   $0x80111a20
8010123a:	e8 b1 32 00 00       	call   801044f0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 74 36 11 80    	cmp    $0x80113674,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 20 1a 11 80       	push   $0x80111a20
8010129f:	e8 0c 33 00 00       	call   801045b0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 20 1a 11 80       	push   $0x80111a20
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 de 32 00 00       	call   801045b0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 15 7b 10 80       	push   $0x80107b15
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 6d 1b 00 00       	call   80102ed0 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 25 7b 10 80       	push   $0x80107b25
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 ba 32 00 00       	call   801046b0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 00 1a 11 80       	push   $0x80111a00
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 18 1a 11 80    	add    0x80111a18,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 61 1a 00 00       	call   80102ed0 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 38 7b 10 80       	push   $0x80107b38
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 60 1a 11 80       	mov    $0x80111a60,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 4b 7b 10 80       	push   $0x80107b4b
801014a1:	68 20 1a 11 80       	push   $0x80111a20
801014a6:	e8 05 2f 00 00       	call   801043b0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 52 7b 10 80       	push   $0x80107b52
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 bc 2d 00 00       	call   80104280 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 80 36 11 80    	cmp    $0x80113680,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 00 1a 11 80       	push   $0x80111a00
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 18 1a 11 80    	pushl  0x80111a18
801014e5:	ff 35 14 1a 11 80    	pushl  0x80111a14
801014eb:	ff 35 10 1a 11 80    	pushl  0x80111a10
801014f1:	ff 35 0c 1a 11 80    	pushl  0x80111a0c
801014f7:	ff 35 08 1a 11 80    	pushl  0x80111a08
801014fd:	ff 35 04 1a 11 80    	pushl  0x80111a04
80101503:	ff 35 00 1a 11 80    	pushl  0x80111a00
80101509:	68 b8 7b 10 80       	push   $0x80107bb8
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d 08 1a 11 80 01 	cmpl   $0x1,0x80111a08
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d 08 1a 11 80    	cmp    %ebx,0x80111a08
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 14 1a 11 80    	add    0x80111a14,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 5d 30 00 00       	call   80104600 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 1b 19 00 00       	call   80102ed0 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 58 7b 10 80       	push   $0x80107b58
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 14 1a 11 80    	add    0x80111a14,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 6a 30 00 00       	call   801046b0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 82 18 00 00       	call   80102ed0 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 20 1a 11 80       	push   $0x80111a20
8010166f:	e8 7c 2e 00 00       	call   801044f0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
8010167f:	e8 2c 2f 00 00       	call   801045b0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 09 2c 00 00       	call   801042c0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 14 1a 11 80    	add    0x80111a14,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 83 2f 00 00       	call   801046b0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 70 7b 10 80       	push   $0x80107b70
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 6a 7b 10 80       	push   $0x80107b6a
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 d8 2b 00 00       	call   80104360 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 7c 2b 00 00       	jmp    80104320 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 7f 7b 10 80       	push   $0x80107b7f
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 eb 2a 00 00       	call   801042c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 31 2b 00 00       	call   80104320 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
801017f6:	e8 f5 2c 00 00       	call   801044f0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 20 1a 11 80 	movl   $0x80111a20,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 9b 2d 00 00       	jmp    801045b0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 20 1a 11 80       	push   $0x80111a20
80101820:	e8 cb 2c 00 00       	call   801044f0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
8010182f:	e8 7c 2d 00 00       	call   801045b0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, off, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 b9 00 00 00    	ja     80101a60 <readi+0xf0>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ac 00 00 00    	jb     80101a60 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 94 2c 00 00       	call   801046b0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 16                	ja     80101a60 <readi+0xf0>
80101a4a:	c1 e0 04             	shl    $0x4,%eax
80101a4d:	8b 80 68 19 11 80    	mov    -0x7feee698(%eax),%eax
80101a53:	85 c0                	test   %eax,%eax
80101a55:	74 09                	je     80101a60 <readi+0xf0>
}
80101a57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5a:	5b                   	pop    %ebx
80101a5b:	5e                   	pop    %esi
80101a5c:	5f                   	pop    %edi
80101a5d:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, off, n);
80101a5e:	ff e0                	jmp    *%eax
      return -1;
80101a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a65:	eb ce                	jmp    80101a35 <readi+0xc5>
80101a67:	89 f6                	mov    %esi,%esi
80101a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 98 2b 00 00       	call   801046b0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 b0 13 00 00       	call   80102ed0 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	c1 e0 04             	shl    $0x4,%eax
80101b5d:	8b 80 6c 19 11 80    	mov    -0x7feee694(%eax),%eax
80101b63:	85 c0                	test   %eax,%eax
80101b65:	74 29                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b67:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6d:	5b                   	pop    %ebx
80101b6e:	5e                   	pop    %esi
80101b6f:	5f                   	pop    %edi
80101b70:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b71:	ff e0                	jmp    *%eax
80101b73:	90                   	nop
80101b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 6d 2b 00 00       	call   80104720 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;
  struct inode *ip;

  if(dp->type != T_DIR && !IS_DEV_DIR(dp))
80101bcc:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80101bd0:	66 83 f8 01          	cmp    $0x1,%ax
80101bd4:	74 30                	je     80101c06 <dirlookup+0x46>
80101bd6:	66 83 f8 03          	cmp    $0x3,%ax
80101bda:	0f 85 d0 00 00 00    	jne    80101cb0 <dirlookup+0xf0>
80101be0:	0f bf 43 52          	movswl 0x52(%ebx),%eax
80101be4:	c1 e0 04             	shl    $0x4,%eax
80101be7:	8b 80 60 19 11 80    	mov    -0x7feee6a0(%eax),%eax
80101bed:	85 c0                	test   %eax,%eax
80101bef:	0f 84 bb 00 00 00    	je     80101cb0 <dirlookup+0xf0>
80101bf5:	83 ec 0c             	sub    $0xc,%esp
80101bf8:	53                   	push   %ebx
80101bf9:	ff d0                	call   *%eax
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	85 c0                	test   %eax,%eax
80101c00:	0f 84 aa 00 00 00    	je     80101cb0 <dirlookup+0xf0>
{
80101c06:	31 ff                	xor    %edi,%edi
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size || dp->type == T_DEV ; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101c08:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0b:	eb 25                	jmp    80101c32 <dirlookup+0x72>
80101c0d:	8d 76 00             	lea    0x0(%esi),%esi
      if (dp->type == T_DEV)
        return 0;
      panic("dirlookup read");
    }
    if(de.inum == 0)
80101c10:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c15:	74 18                	je     80101c2f <dirlookup+0x6f>
  return strncmp(s, t, DIRSIZ);
80101c17:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c1a:	83 ec 04             	sub    $0x4,%esp
80101c1d:	6a 0e                	push   $0xe
80101c1f:	50                   	push   %eax
80101c20:	ff 75 0c             	pushl  0xc(%ebp)
80101c23:	e8 f8 2a 00 00       	call   80104720 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c28:	83 c4 10             	add    $0x10,%esp
80101c2b:	85 c0                	test   %eax,%eax
80101c2d:	74 39                	je     80101c68 <dirlookup+0xa8>
  for(off = 0; off < dp->size || dp->type == T_DEV ; off += sizeof(de)){
80101c2f:	83 c7 10             	add    $0x10,%edi
80101c32:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c35:	77 07                	ja     80101c3e <dirlookup+0x7e>
80101c37:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101c3c:	75 19                	jne    80101c57 <dirlookup+0x97>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101c3e:	6a 10                	push   $0x10
80101c40:	57                   	push   %edi
80101c41:	56                   	push   %esi
80101c42:	53                   	push   %ebx
80101c43:	e8 28 fd ff ff       	call   80101970 <readi>
80101c48:	83 c4 10             	add    $0x10,%esp
80101c4b:	83 f8 10             	cmp    $0x10,%eax
80101c4e:	74 c0                	je     80101c10 <dirlookup+0x50>
      if (dp->type == T_DEV)
80101c50:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101c55:	75 66                	jne    80101cbd <dirlookup+0xfd>
        return 0;
80101c57:	31 c0                	xor    %eax,%eax
      return ip;
    }
  }

  return 0;
}
80101c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c68:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101c6b:	85 c9                	test   %ecx,%ecx
80101c6d:	74 05                	je     80101c74 <dirlookup+0xb4>
        *poff = off;
80101c6f:	8b 45 10             	mov    0x10(%ebp),%eax
80101c72:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c74:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      ip = iget(dp->dev, inum);
80101c78:	8b 03                	mov    (%ebx),%eax
80101c7a:	e8 a1 f5 ff ff       	call   80101220 <iget>
      if (ip->valid == 0 && dp->type == T_DEV && devsw[dp->major].iread) {
80101c7f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c82:	85 d2                	test   %edx,%edx
80101c84:	75 d3                	jne    80101c59 <dirlookup+0x99>
80101c86:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101c8b:	75 cc                	jne    80101c59 <dirlookup+0x99>
80101c8d:	0f bf 53 52          	movswl 0x52(%ebx),%edx
80101c91:	c1 e2 04             	shl    $0x4,%edx
80101c94:	8b 92 64 19 11 80    	mov    -0x7feee69c(%edx),%edx
80101c9a:	85 d2                	test   %edx,%edx
80101c9c:	74 bb                	je     80101c59 <dirlookup+0x99>
        devsw[dp->major].iread(dp, ip);
80101c9e:	83 ec 08             	sub    $0x8,%esp
80101ca1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101ca4:	50                   	push   %eax
80101ca5:	53                   	push   %ebx
80101ca6:	ff d2                	call   *%edx
80101ca8:	83 c4 10             	add    $0x10,%esp
80101cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101cae:	eb a9                	jmp    80101c59 <dirlookup+0x99>
    panic("dirlookup not DIR");
80101cb0:	83 ec 0c             	sub    $0xc,%esp
80101cb3:	68 87 7b 10 80       	push   $0x80107b87
80101cb8:	e8 d3 e6 ff ff       	call   80100390 <panic>
      panic("dirlookup read");
80101cbd:	83 ec 0c             	sub    $0xc,%esp
80101cc0:	68 99 7b 10 80       	push   $0x80107b99
80101cc5:	e8 c6 e6 ff ff       	call   80100390 <panic>
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	56                   	push   %esi
80101cd5:	53                   	push   %ebx
80101cd6:	89 cf                	mov    %ecx,%edi
80101cd8:	89 c3                	mov    %eax,%ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ce3:	0f 84 97 01 00 00    	je     80101e80 <namex+0x1b0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ce9:	e8 62 1c 00 00       	call   80103950 <myproc>
  acquire(&icache.lock);
80101cee:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cf1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cf4:	68 20 1a 11 80       	push   $0x80111a20
80101cf9:	e8 f2 27 00 00       	call   801044f0 <acquire>
  ip->ref++;
80101cfe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d02:	c7 04 24 20 1a 11 80 	movl   $0x80111a20,(%esp)
80101d09:	e8 a2 28 00 00       	call   801045b0 <release>
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	eb 08                	jmp    80101d1b <namex+0x4b>
80101d13:	90                   	nop
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d1b:	0f b6 03             	movzbl (%ebx),%eax
80101d1e:	3c 2f                	cmp    $0x2f,%al
80101d20:	74 f6                	je     80101d18 <namex+0x48>
  if(*path == 0)
80101d22:	84 c0                	test   %al,%al
80101d24:	0f 84 1e 01 00 00    	je     80101e48 <namex+0x178>
  while(*path != '/' && *path != 0)
80101d2a:	0f b6 03             	movzbl (%ebx),%eax
80101d2d:	3c 2f                	cmp    $0x2f,%al
80101d2f:	0f 84 e3 00 00 00    	je     80101e18 <namex+0x148>
80101d35:	84 c0                	test   %al,%al
80101d37:	89 da                	mov    %ebx,%edx
80101d39:	75 09                	jne    80101d44 <namex+0x74>
80101d3b:	e9 d8 00 00 00       	jmp    80101e18 <namex+0x148>
80101d40:	84 c0                	test   %al,%al
80101d42:	74 0a                	je     80101d4e <namex+0x7e>
    path++;
80101d44:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d47:	0f b6 02             	movzbl (%edx),%eax
80101d4a:	3c 2f                	cmp    $0x2f,%al
80101d4c:	75 f2                	jne    80101d40 <namex+0x70>
80101d4e:	89 d1                	mov    %edx,%ecx
80101d50:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d52:	83 f9 0d             	cmp    $0xd,%ecx
80101d55:	0f 8e c1 00 00 00    	jle    80101e1c <namex+0x14c>
    memmove(name, s, DIRSIZ);
80101d5b:	83 ec 04             	sub    $0x4,%esp
80101d5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d61:	6a 0e                	push   $0xe
80101d63:	53                   	push   %ebx
80101d64:	57                   	push   %edi
80101d65:	e8 46 29 00 00       	call   801046b0 <memmove>
    path++;
80101d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d6d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d70:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d72:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d75:	75 11                	jne    80101d88 <namex+0xb8>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d86:	74 f8                	je     80101d80 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d88:	83 ec 0c             	sub    $0xc,%esp
80101d8b:	56                   	push   %esi
80101d8c:	e8 ff f8 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR && !IS_DEV_DIR(ip)){
80101d91:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80101d95:	83 c4 10             	add    $0x10,%esp
80101d98:	66 83 f8 01          	cmp    $0x1,%ax
80101d9c:	74 30                	je     80101dce <namex+0xfe>
80101d9e:	66 83 f8 03          	cmp    $0x3,%ax
80101da2:	0f 85 b8 00 00 00    	jne    80101e60 <namex+0x190>
80101da8:	0f bf 46 52          	movswl 0x52(%esi),%eax
80101dac:	c1 e0 04             	shl    $0x4,%eax
80101daf:	8b 80 60 19 11 80    	mov    -0x7feee6a0(%eax),%eax
80101db5:	85 c0                	test   %eax,%eax
80101db7:	0f 84 a3 00 00 00    	je     80101e60 <namex+0x190>
80101dbd:	83 ec 0c             	sub    $0xc,%esp
80101dc0:	56                   	push   %esi
80101dc1:	ff d0                	call   *%eax
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	85 c0                	test   %eax,%eax
80101dc8:	0f 84 92 00 00 00    	je     80101e60 <namex+0x190>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dce:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dd1:	85 d2                	test   %edx,%edx
80101dd3:	74 09                	je     80101dde <namex+0x10e>
80101dd5:	80 3b 00             	cmpb   $0x0,(%ebx)
80101dd8:	0f 84 b8 00 00 00    	je     80101e96 <namex+0x1c6>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dde:	83 ec 04             	sub    $0x4,%esp
80101de1:	6a 00                	push   $0x0
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	e8 d6 fd ff ff       	call   80101bc0 <dirlookup>
80101dea:	83 c4 10             	add    $0x10,%esp
80101ded:	85 c0                	test   %eax,%eax
80101def:	74 6f                	je     80101e60 <namex+0x190>
  iunlock(ip);
80101df1:	83 ec 0c             	sub    $0xc,%esp
80101df4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101df7:	56                   	push   %esi
80101df8:	e8 73 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dfd:	89 34 24             	mov    %esi,(%esp)
80101e00:	e8 bb f9 ff ff       	call   801017c0 <iput>
80101e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e08:	83 c4 10             	add    $0x10,%esp
80101e0b:	89 c6                	mov    %eax,%esi
80101e0d:	e9 09 ff ff ff       	jmp    80101d1b <namex+0x4b>
80101e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e18:	89 da                	mov    %ebx,%edx
80101e1a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e22:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e25:	51                   	push   %ecx
80101e26:	53                   	push   %ebx
80101e27:	57                   	push   %edi
80101e28:	e8 83 28 00 00       	call   801046b0 <memmove>
    name[len] = 0;
80101e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e30:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e33:	83 c4 10             	add    $0x10,%esp
80101e36:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e3a:	89 d3                	mov    %edx,%ebx
80101e3c:	e9 31 ff ff ff       	jmp    80101d72 <namex+0xa2>
80101e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e4b:	85 c0                	test   %eax,%eax
80101e4d:	75 5d                	jne    80101eac <namex+0x1dc>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e52:	89 f0                	mov    %esi,%eax
80101e54:	5b                   	pop    %ebx
80101e55:	5e                   	pop    %esi
80101e56:	5f                   	pop    %edi
80101e57:	5d                   	pop    %ebp
80101e58:	c3                   	ret    
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 07 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101e69:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e6c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e6e:	e8 4d f9 ff ff       	call   801017c0 <iput>
      return 0;
80101e73:	83 c4 10             	add    $0x10,%esp
}
80101e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e79:	89 f0                	mov    %esi,%eax
80101e7b:	5b                   	pop    %ebx
80101e7c:	5e                   	pop    %esi
80101e7d:	5f                   	pop    %edi
80101e7e:	5d                   	pop    %ebp
80101e7f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e80:	ba 01 00 00 00       	mov    $0x1,%edx
80101e85:	b8 01 00 00 00       	mov    $0x1,%eax
80101e8a:	e8 91 f3 ff ff       	call   80101220 <iget>
80101e8f:	89 c6                	mov    %eax,%esi
80101e91:	e9 85 fe ff ff       	jmp    80101d1b <namex+0x4b>
      iunlock(ip);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	56                   	push   %esi
80101e9a:	e8 d1 f8 ff ff       	call   80101770 <iunlock>
      return ip;
80101e9f:	83 c4 10             	add    $0x10,%esp
}
80101ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea5:	89 f0                	mov    %esi,%eax
80101ea7:	5b                   	pop    %ebx
80101ea8:	5e                   	pop    %esi
80101ea9:	5f                   	pop    %edi
80101eaa:	5d                   	pop    %ebp
80101eab:	c3                   	ret    
    iput(ip);
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	56                   	push   %esi
    return 0;
80101eb0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101eb2:	e8 09 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101eb7:	83 c4 10             	add    $0x10,%esp
80101eba:	eb 93                	jmp    80101e4f <namex+0x17f>
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <dirlink>:
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	83 ec 20             	sub    $0x20,%esp
80101ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ecc:	6a 00                	push   $0x0
80101ece:	ff 75 0c             	pushl  0xc(%ebp)
80101ed1:	53                   	push   %ebx
80101ed2:	e8 e9 fc ff ff       	call   80101bc0 <dirlookup>
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	85 c0                	test   %eax,%eax
80101edc:	75 67                	jne    80101f45 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ede:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ee1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ee4:	85 ff                	test   %edi,%edi
80101ee6:	74 29                	je     80101f11 <dirlink+0x51>
80101ee8:	31 ff                	xor    %edi,%edi
80101eea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eed:	eb 09                	jmp    80101ef8 <dirlink+0x38>
80101eef:	90                   	nop
80101ef0:	83 c7 10             	add    $0x10,%edi
80101ef3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ef6:	73 19                	jae    80101f11 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef8:	6a 10                	push   $0x10
80101efa:	57                   	push   %edi
80101efb:	56                   	push   %esi
80101efc:	53                   	push   %ebx
80101efd:	e8 6e fa ff ff       	call   80101970 <readi>
80101f02:	83 c4 10             	add    $0x10,%esp
80101f05:	83 f8 10             	cmp    $0x10,%eax
80101f08:	75 4e                	jne    80101f58 <dirlink+0x98>
    if(de.inum == 0)
80101f0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f0f:	75 df                	jne    80101ef0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f14:	83 ec 04             	sub    $0x4,%esp
80101f17:	6a 0e                	push   $0xe
80101f19:	ff 75 0c             	pushl  0xc(%ebp)
80101f1c:	50                   	push   %eax
80101f1d:	e8 5e 28 00 00       	call   80104780 <strncpy>
  de.inum = inum;
80101f22:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f25:	6a 10                	push   $0x10
80101f27:	57                   	push   %edi
80101f28:	56                   	push   %esi
80101f29:	53                   	push   %ebx
  de.inum = inum;
80101f2a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f2e:	e8 3d fb ff ff       	call   80101a70 <writei>
80101f33:	83 c4 20             	add    $0x20,%esp
80101f36:	83 f8 10             	cmp    $0x10,%eax
80101f39:	75 2a                	jne    80101f65 <dirlink+0xa5>
  return 0;
80101f3b:	31 c0                	xor    %eax,%eax
}
80101f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f40:	5b                   	pop    %ebx
80101f41:	5e                   	pop    %esi
80101f42:	5f                   	pop    %edi
80101f43:	5d                   	pop    %ebp
80101f44:	c3                   	ret    
    iput(ip);
80101f45:	83 ec 0c             	sub    $0xc,%esp
80101f48:	50                   	push   %eax
80101f49:	e8 72 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101f4e:	83 c4 10             	add    $0x10,%esp
80101f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f56:	eb e5                	jmp    80101f3d <dirlink+0x7d>
      panic("dirlink read");
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	68 a8 7b 10 80       	push   $0x80107ba8
80101f60:	e8 2b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	68 9e 81 10 80       	push   $0x8010819e
80101f6d:	e8 1e e4 ff ff       	call   80100390 <panic>
80101f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f80 <namei>:

struct inode*
namei(char *path)
{
80101f80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f81:	31 d2                	xor    %edx,%edx
{
80101f83:	89 e5                	mov    %esp,%ebp
80101f85:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f8e:	e8 3d fd ff ff       	call   80101cd0 <namex>
}
80101f93:	c9                   	leave  
80101f94:	c3                   	ret    
80101f95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fa0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fa1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fa6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fae:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101faf:	e9 1c fd ff ff       	jmp    80101cd0 <namex>
80101fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fc0 <get_free_inodes>:

int get_free_inodes() {
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	53                   	push   %ebx
  struct inode* ip;
  acquire(&icache.lock); 
  int counter = 0;
80101fc4:	31 db                	xor    %ebx,%ebx
int get_free_inodes() {
80101fc6:	83 ec 10             	sub    $0x10,%esp
  acquire(&icache.lock); 
80101fc9:	68 20 1a 11 80       	push   $0x80111a20
80101fce:	e8 1d 25 00 00       	call   801044f0 <acquire>
80101fd3:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101fd6:	ba 54 1a 11 80       	mov    $0x80111a54,%edx
80101fdb:	90                   	nop
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (ip->ref == 0)
      counter++;
80101fe0:	83 7a 08 01          	cmpl   $0x1,0x8(%edx)
80101fe4:	83 d3 00             	adc    $0x0,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101fe7:	81 c2 90 00 00 00    	add    $0x90,%edx
80101fed:	81 fa 74 36 11 80    	cmp    $0x80113674,%edx
80101ff3:	72 eb                	jb     80101fe0 <get_free_inodes+0x20>
  }
  release(&icache.lock);
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 20 1a 11 80       	push   $0x80111a20
80101ffd:	e8 ae 25 00 00       	call   801045b0 <release>
  return counter;
}
80102002:	89 d8                	mov    %ebx,%eax
80102004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102007:	c9                   	leave  
80102008:	c3                   	ret    
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102010 <get_total_refs>:

int get_total_refs() {
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	53                   	push   %ebx
  struct inode* ip;
  acquire(&icache.lock); 
  int counter = 0;
80102014:	31 db                	xor    %ebx,%ebx
int get_total_refs() {
80102016:	83 ec 10             	sub    $0x10,%esp
  acquire(&icache.lock); 
80102019:	68 20 1a 11 80       	push   $0x80111a20
8010201e:	e8 cd 24 00 00       	call   801044f0 <acquire>
80102023:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80102026:	ba 54 1a 11 80       	mov    $0x80111a54,%edx
8010202b:	90                   	nop
8010202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    counter += ip->ref;
80102030:	03 5a 08             	add    0x8(%edx),%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80102033:	81 c2 90 00 00 00    	add    $0x90,%edx
80102039:	81 fa 74 36 11 80    	cmp    $0x80113674,%edx
8010203f:	72 ef                	jb     80102030 <get_total_refs+0x20>
  }
  release(&icache.lock);
80102041:	83 ec 0c             	sub    $0xc,%esp
80102044:	68 20 1a 11 80       	push   $0x80111a20
80102049:	e8 62 25 00 00       	call   801045b0 <release>
  return counter;
}
8010204e:	89 d8                	mov    %ebx,%eax
80102050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102053:	c9                   	leave  
80102054:	c3                   	ret    
80102055:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102060 <get_used_inodes>:

int get_used_inodes() {
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	83 ec 08             	sub    $0x8,%esp
  return NINODE - get_free_inodes();
80102066:	e8 55 ff ff ff       	call   80101fc0 <get_free_inodes>
8010206b:	ba 32 00 00 00       	mov    $0x32,%edx
80102070:	c9                   	leave  
  return NINODE - get_free_inodes();
80102071:	29 c2                	sub    %eax,%edx
80102073:	89 d0                	mov    %edx,%eax
80102075:	c3                   	ret    
80102076:	66 90                	xchg   %ax,%ax
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
80102091:	8b 58 08             	mov    0x8(%eax),%ebx
80102094:	89 c6                	mov    %eax,%esi
80102096:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	89 f6                	mov    %esi,%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
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
801020d4:	89 d8                	mov    %ebx,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 d8                	mov    %ebx,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 06 04             	testb  $0x4,(%esi)
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
80102125:	83 c6 5c             	add    $0x5c,%esi
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
8010213b:	68 14 7c 10 80       	push   $0x80107c14
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 0b 7c 10 80       	push   $0x80107c0b
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102160 <ideinit>:
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102166:	68 26 7c 10 80       	push   $0x80107c26
8010216b:	68 80 b5 10 80       	push   $0x8010b580
80102170:	e8 3b 22 00 00       	call   801043b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102175:	58                   	pop    %eax
80102176:	a1 40 3d 11 80       	mov    0x80113d40,%eax
8010217b:	5a                   	pop    %edx
8010217c:	83 e8 01             	sub    $0x1,%eax
8010217f:	50                   	push   %eax
80102180:	6a 0e                	push   $0xe
80102182:	e8 a9 02 00 00       	call   80102430 <ioapicenable>
80102187:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010218f:	90                   	nop
80102190:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102191:	83 e0 c0             	and    $0xffffffc0,%eax
80102194:	3c 40                	cmp    $0x40,%al
80102196:	75 f8                	jne    80102190 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102198:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010219d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021a2:	ee                   	out    %al,(%dx)
801021a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ad:	eb 06                	jmp    801021b5 <ideinit+0x55>
801021af:	90                   	nop
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x64>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x50>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	eb 0d                	jmp    801021e0 <ideintr>
801021d3:	90                   	nop
801021d4:	90                   	nop
801021d5:	90                   	nop
801021d6:	90                   	nop
801021d7:	90                   	nop
801021d8:	90                   	nop
801021d9:	90                   	nop
801021da:	90                   	nop
801021db:	90                   	nop
801021dc:	90                   	nop
801021dd:	90                   	nop
801021de:	90                   	nop
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021e9:	68 80 b5 10 80       	push   $0x8010b580
801021ee:	e8 fd 22 00 00       	call   801044f0 <acquire>

  if((b = idequeue) == 0){
801021f3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021f9:	83 c4 10             	add    $0x10,%esp
801021fc:	85 db                	test   %ebx,%ebx
801021fe:	74 67                	je     80102267 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102200:	8b 43 58             	mov    0x58(%ebx),%eax
80102203:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102208:	8b 3b                	mov    (%ebx),%edi
8010220a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102210:	75 31                	jne    80102243 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102212:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102217:	89 f6                	mov    %esi,%esi
80102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c6                	mov    %eax,%esi
80102223:	83 e6 c0             	and    $0xffffffc0,%esi
80102226:	89 f1                	mov    %esi,%ecx
80102228:	80 f9 40             	cmp    $0x40,%cl
8010222b:	75 f3                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222d:	a8 21                	test   $0x21,%al
8010222f:	75 12                	jne    80102243 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102231:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102234:	b9 80 00 00 00       	mov    $0x80,%ecx
80102239:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223e:	fc                   	cld    
8010223f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102241:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102243:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102246:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102249:	89 f9                	mov    %edi,%ecx
8010224b:	83 c9 02             	or     $0x2,%ecx
8010224e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102250:	53                   	push   %ebx
80102251:	e8 4a 1e 00 00       	call   801040a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102256:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010225b:	83 c4 10             	add    $0x10,%esp
8010225e:	85 c0                	test   %eax,%eax
80102260:	74 05                	je     80102267 <ideintr+0x87>
    idestart(idequeue);
80102262:	e8 19 fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102267:	83 ec 0c             	sub    $0xc,%esp
8010226a:	68 80 b5 10 80       	push   $0x8010b580
8010226f:	e8 3c 23 00 00       	call   801045b0 <release>

  release(&idelock);
}
80102274:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102277:	5b                   	pop    %ebx
80102278:	5e                   	pop    %esi
80102279:	5f                   	pop    %edi
8010227a:	5d                   	pop    %ebp
8010227b:	c3                   	ret    
8010227c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	53                   	push   %ebx
80102284:	83 ec 10             	sub    $0x10,%esp
80102287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010228d:	50                   	push   %eax
8010228e:	e8 cd 20 00 00       	call   80104360 <holdingsleep>
80102293:	83 c4 10             	add    $0x10,%esp
80102296:	85 c0                	test   %eax,%eax
80102298:	0f 84 c6 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010229e:	8b 03                	mov    (%ebx),%eax
801022a0:	83 e0 06             	and    $0x6,%eax
801022a3:	83 f8 02             	cmp    $0x2,%eax
801022a6:	0f 84 ab 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022ac:	8b 53 04             	mov    0x4(%ebx),%edx
801022af:	85 d2                	test   %edx,%edx
801022b1:	74 0d                	je     801022c0 <iderw+0x40>
801022b3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022b8:	85 c0                	test   %eax,%eax
801022ba:	0f 84 b1 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c0:	83 ec 0c             	sub    $0xc,%esp
801022c3:	68 80 b5 10 80       	push   $0x8010b580
801022c8:	e8 23 22 00 00       	call   801044f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022cd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801022d3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	85 d2                	test   %edx,%edx
801022df:	75 09                	jne    801022ea <iderw+0x6a>
801022e1:	eb 6d                	jmp    80102350 <iderw+0xd0>
801022e3:	90                   	nop
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 42 58             	mov    0x58(%edx),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	90                   	nop
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 d2 1b 00 00       	call   80103ef0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 75 22 00 00       	jmp    801045b0 <release>
8010233b:	90                   	nop
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 39 fd ff ff       	call   80102080 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: nothing to do");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 40 7c 10 80       	push   $0x80107c40
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 2a 7c 10 80       	push   $0x80107c2a
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 55 7c 10 80       	push   $0x80107c55
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102381:	c7 05 74 36 11 80 00 	movl   $0xfec00000,0x80113674
80102388:	00 c0 fe 
{
8010238b:	89 e5                	mov    %esp,%ebp
8010238d:	56                   	push   %esi
8010238e:	53                   	push   %ebx
  ioapic->reg = reg;
8010238f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102396:	00 00 00 
  return ioapic->data;
80102399:	a1 74 36 11 80       	mov    0x80113674,%eax
8010239e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801023a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801023a7:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ad:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801023b7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023ba:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801023bd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c0:	39 c2                	cmp    %eax,%edx
801023c2:	74 16                	je     801023da <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 74 7c 10 80       	push   $0x80107c74
801023cc:	e8 8f e2 ff ff       	call   80100660 <cprintf>
801023d1:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
801023d7:	83 c4 10             	add    $0x10,%esp
801023da:	83 c3 21             	add    $0x21,%ebx
{
801023dd:	ba 10 00 00 00       	mov    $0x10,%edx
801023e2:	b8 20 00 00 00       	mov    $0x20,%eax
801023e7:	89 f6                	mov    %esi,%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801023f2:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f8:	89 c6                	mov    %eax,%esi
801023fa:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102400:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102403:	89 71 10             	mov    %esi,0x10(%ecx)
80102406:	8d 72 01             	lea    0x1(%edx),%esi
80102409:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010240c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010240e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102410:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
80102416:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d 76 00             	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	55                   	push   %ebp
  ioapic->reg = reg;
80102431:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
{
80102437:	89 e5                	mov    %esp,%ebp
80102439:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010243c:	8d 50 20             	lea    0x20(%eax),%edx
8010243f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102443:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102445:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010244e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102451:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102454:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102456:	a1 74 36 11 80       	mov    0x80113674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010245e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	66 90                	xchg   %ax,%ax
80102465:	66 90                	xchg   %ax,%ax
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	53                   	push   %ebx
80102474:	83 ec 04             	sub    $0x4,%esp
80102477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102480:	75 70                	jne    801024f2 <kfree+0x82>
80102482:	81 fb 40 6c 11 80    	cmp    $0x80116c40,%ebx
80102488:	72 68                	jb     801024f2 <kfree+0x82>
8010248a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102490:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102495:	77 5b                	ja     801024f2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102497:	83 ec 04             	sub    $0x4,%esp
8010249a:	68 00 10 00 00       	push   $0x1000
8010249f:	6a 01                	push   $0x1
801024a1:	53                   	push   %ebx
801024a2:	e8 59 21 00 00       	call   80104600 <memset>

  if(kmem.use_lock)
801024a7:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	85 d2                	test   %edx,%edx
801024b2:	75 2c                	jne    801024e0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b4:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801024b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bb:	a1 b4 36 11 80       	mov    0x801136b4,%eax
  kmem.freelist = r;
801024c0:	89 1d b8 36 11 80    	mov    %ebx,0x801136b8
  if(kmem.use_lock)
801024c6:	85 c0                	test   %eax,%eax
801024c8:	75 06                	jne    801024d0 <kfree+0x60>
    release(&kmem.lock);
}
801024ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cd:	c9                   	leave  
801024ce:	c3                   	ret    
801024cf:	90                   	nop
    release(&kmem.lock);
801024d0:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
801024d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024da:	c9                   	leave  
    release(&kmem.lock);
801024db:	e9 d0 20 00 00       	jmp    801045b0 <release>
    acquire(&kmem.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 80 36 11 80       	push   $0x80113680
801024e8:	e8 03 20 00 00       	call   801044f0 <acquire>
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	eb c2                	jmp    801024b4 <kfree+0x44>
    panic("kfree");
801024f2:	83 ec 0c             	sub    $0xc,%esp
801024f5:	68 a6 7c 10 80       	push   $0x80107ca6
801024fa:	e8 91 de ff ff       	call   80100390 <panic>
801024ff:	90                   	nop

80102500 <freerange>:
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	56                   	push   %esi
80102504:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102505:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102508:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010250b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102511:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102517:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010251d:	39 de                	cmp    %ebx,%esi
8010251f:	72 23                	jb     80102544 <freerange+0x44>
80102521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102528:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010252e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102531:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102537:	50                   	push   %eax
80102538:	e8 33 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	39 f3                	cmp    %esi,%ebx
80102542:	76 e4                	jbe    80102528 <freerange+0x28>
}
80102544:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102547:	5b                   	pop    %ebx
80102548:	5e                   	pop    %esi
80102549:	5d                   	pop    %ebp
8010254a:	c3                   	ret    
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102550 <kinit1>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
80102554:	53                   	push   %ebx
80102555:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102558:	83 ec 08             	sub    $0x8,%esp
8010255b:	68 ac 7c 10 80       	push   $0x80107cac
80102560:	68 80 36 11 80       	push   $0x80113680
80102565:	e8 46 1e 00 00       	call   801043b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010256a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102570:	c7 05 b4 36 11 80 00 	movl   $0x0,0x801136b4
80102577:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010257a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102580:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102586:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258c:	39 de                	cmp    %ebx,%esi
8010258e:	72 1c                	jb     801025ac <kinit1+0x5c>
    kfree(p);
80102590:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102596:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102599:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010259f:	50                   	push   %eax
801025a0:	e8 cb fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a5:	83 c4 10             	add    $0x10,%esp
801025a8:	39 de                	cmp    %ebx,%esi
801025aa:	73 e4                	jae    80102590 <kinit1+0x40>
}
801025ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025af:	5b                   	pop    %ebx
801025b0:	5e                   	pop    %esi
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 73 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 b4 36 11 80 01 	movl   $0x1,0x801136b4
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102620:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102625:	85 c0                	test   %eax,%eax
80102627:	75 1f                	jne    80102648 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102629:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r)
8010262e:	85 c0                	test   %eax,%eax
80102630:	74 0e                	je     80102640 <kalloc+0x20>
    kmem.freelist = r->next;
80102632:	8b 10                	mov    (%eax),%edx
80102634:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
8010263a:	c3                   	ret    
8010263b:	90                   	nop
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102640:	f3 c3                	repz ret 
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102648:	55                   	push   %ebp
80102649:	89 e5                	mov    %esp,%ebp
8010264b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010264e:	68 80 36 11 80       	push   $0x80113680
80102653:	e8 98 1e 00 00       	call   801044f0 <acquire>
  r = kmem.freelist;
80102658:	a1 b8 36 11 80       	mov    0x801136b8,%eax
  if(r)
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
80102666:	85 c0                	test   %eax,%eax
80102668:	74 08                	je     80102672 <kalloc+0x52>
    kmem.freelist = r->next;
8010266a:	8b 08                	mov    (%eax),%ecx
8010266c:	89 0d b8 36 11 80    	mov    %ecx,0x801136b8
  if(kmem.use_lock)
80102672:	85 d2                	test   %edx,%edx
80102674:	74 16                	je     8010268c <kalloc+0x6c>
    release(&kmem.lock);
80102676:	83 ec 0c             	sub    $0xc,%esp
80102679:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010267c:	68 80 36 11 80       	push   $0x80113680
80102681:	e8 2a 1f 00 00       	call   801045b0 <release>
  return (char*)r;
80102686:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102689:	83 c4 10             	add    $0x10,%esp
}
8010268c:	c9                   	leave  
8010268d:	c3                   	ret    
8010268e:	66 90                	xchg   %ax,%ax

80102690 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102690:	ba 64 00 00 00       	mov    $0x64,%edx
80102695:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102696:	a8 01                	test   $0x1,%al
80102698:	0f 84 c2 00 00 00    	je     80102760 <kbdgetc+0xd0>
8010269e:	ba 60 00 00 00       	mov    $0x60,%edx
801026a3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026a4:	0f b6 d0             	movzbl %al,%edx
801026a7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801026ad:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026b3:	0f 84 7f 00 00 00    	je     80102738 <kbdgetc+0xa8>
{
801026b9:	55                   	push   %ebp
801026ba:	89 e5                	mov    %esp,%ebp
801026bc:	53                   	push   %ebx
801026bd:	89 cb                	mov    %ecx,%ebx
801026bf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c2:	84 c0                	test   %al,%al
801026c4:	78 4a                	js     80102710 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026c6:	85 db                	test   %ebx,%ebx
801026c8:	74 09                	je     801026d3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026ca:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026cd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801026d0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026d3:	0f b6 82 e0 7d 10 80 	movzbl -0x7fef8220(%edx),%eax
801026da:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801026dc:	0f b6 82 e0 7c 10 80 	movzbl -0x7fef8320(%edx),%eax
801026e3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026e5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026e7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026ed:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026f0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f3:	8b 04 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%eax
801026fa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026fe:	74 31                	je     80102731 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102700:	8d 50 9f             	lea    -0x61(%eax),%edx
80102703:	83 fa 19             	cmp    $0x19,%edx
80102706:	77 40                	ja     80102748 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102708:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010270b:	5b                   	pop    %ebx
8010270c:	5d                   	pop    %ebp
8010270d:	c3                   	ret    
8010270e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102710:	83 e0 7f             	and    $0x7f,%eax
80102713:	85 db                	test   %ebx,%ebx
80102715:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102718:	0f b6 82 e0 7d 10 80 	movzbl -0x7fef8220(%edx),%eax
8010271f:	83 c8 40             	or     $0x40,%eax
80102722:	0f b6 c0             	movzbl %al,%eax
80102725:	f7 d0                	not    %eax
80102727:	21 c1                	and    %eax,%ecx
    return 0;
80102729:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010272b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102731:	5b                   	pop    %ebx
80102732:	5d                   	pop    %ebp
80102733:	c3                   	ret    
80102734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102738:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010273b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010273d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102743:	c3                   	ret    
80102744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102748:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010274b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010274e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010274f:	83 f9 1a             	cmp    $0x1a,%ecx
80102752:	0f 42 c2             	cmovb  %edx,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102765:	c3                   	ret    
80102766:	8d 76 00             	lea    0x0(%esi),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <kbdintr>:

void
kbdintr(void)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102776:	68 90 26 10 80       	push   $0x80102690
8010277b:	e8 90 e0 ff ff       	call   80100810 <consoleintr>
}
80102780:	83 c4 10             	add    $0x10,%esp
80102783:	c9                   	leave  
80102784:	c3                   	ret    
80102785:	66 90                	xchg   %ax,%ax
80102787:	66 90                	xchg   %ax,%ax
80102789:	66 90                	xchg   %ax,%ax
8010278b:	66 90                	xchg   %ax,%ax
8010278d:	66 90                	xchg   %ax,%ax
8010278f:	90                   	nop

80102790 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102790:	a1 bc 36 11 80       	mov    0x801136bc,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	0f 84 c8 00 00 00    	je     80102868 <lapicinit+0xd8>
  lapic[index] = value;
801027a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ee:	8b 50 30             	mov    0x30(%eax),%edx
801027f1:	c1 ea 10             	shr    $0x10,%edx
801027f4:	80 fa 03             	cmp    $0x3,%dl
801027f7:	77 77                	ja     80102870 <lapicinit+0xe0>
  lapic[index] = value;
801027f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102800:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102806:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010280d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102810:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102813:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010281a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102820:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102827:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102834:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102841:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
80102847:	89 f6                	mov    %esi,%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102850:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102856:	80 e6 10             	and    $0x10,%dh
80102859:	75 f5                	jne    80102850 <lapicinit+0xc0>
  lapic[index] = value;
8010285b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102862:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102865:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102868:	5d                   	pop    %ebp
80102869:	c3                   	ret    
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102870:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102877:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287a:	8b 50 20             	mov    0x20(%eax),%edx
8010287d:	e9 77 ff ff ff       	jmp    801027f9 <lapicinit+0x69>
80102882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102890 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102890:	8b 15 bc 36 11 80    	mov    0x801136bc,%edx
{
80102896:	55                   	push   %ebp
80102897:	31 c0                	xor    %eax,%eax
80102899:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010289b:	85 d2                	test   %edx,%edx
8010289d:	74 06                	je     801028a5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010289f:	8b 42 20             	mov    0x20(%edx),%eax
801028a2:	c1 e8 18             	shr    $0x18,%eax
}
801028a5:	5d                   	pop    %ebp
801028a6:	c3                   	ret    
801028a7:	89 f6                	mov    %esi,%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028b0:	a1 bc 36 11 80       	mov    0x801136bc,%eax
{
801028b5:	55                   	push   %ebp
801028b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028b8:	85 c0                	test   %eax,%eax
801028ba:	74 0d                	je     801028c9 <lapiceoi+0x19>
  lapic[index] = value;
801028bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028c9:	5d                   	pop    %ebp
801028ca:	c3                   	ret    
801028cb:	90                   	nop
801028cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
}
801028d3:	5d                   	pop    %ebp
801028d4:	c3                   	ret    
801028d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e1:	b8 0f 00 00 00       	mov    $0xf,%eax
801028e6:	ba 70 00 00 00       	mov    $0x70,%edx
801028eb:	89 e5                	mov    %esp,%ebp
801028ed:	53                   	push   %ebx
801028ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028f4:	ee                   	out    %al,(%dx)
801028f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028fa:	ba 71 00 00 00       	mov    $0x71,%edx
801028ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102900:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102902:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102905:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010290b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010290d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102910:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102913:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102915:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102918:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010291e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102923:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102929:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010292c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102933:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102936:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102939:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102940:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102946:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102955:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102958:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010295e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102961:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010296a:	5b                   	pop    %ebx
8010296b:	5d                   	pop    %ebp
8010296c:	c3                   	ret    
8010296d:	8d 76 00             	lea    0x0(%esi),%esi

80102970 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102970:	55                   	push   %ebp
80102971:	b8 0b 00 00 00       	mov    $0xb,%eax
80102976:	ba 70 00 00 00       	mov    $0x70,%edx
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	57                   	push   %edi
8010297e:	56                   	push   %esi
8010297f:	53                   	push   %ebx
80102980:	83 ec 4c             	sub    $0x4c,%esp
80102983:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102984:	ba 71 00 00 00       	mov    $0x71,%edx
80102989:	ec                   	in     (%dx),%al
8010298a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010298d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102992:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102995:	8d 76 00             	lea    0x0(%esi),%esi
80102998:	31 c0                	xor    %eax,%eax
8010299a:	89 da                	mov    %ebx,%edx
8010299c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299d:	b9 71 00 00 00       	mov    $0x71,%ecx
801029a2:	89 ca                	mov    %ecx,%edx
801029a4:	ec                   	in     (%dx),%al
801029a5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a8:	89 da                	mov    %ebx,%edx
801029aa:	b8 02 00 00 00       	mov    $0x2,%eax
801029af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b0:	89 ca                	mov    %ecx,%edx
801029b2:	ec                   	in     (%dx),%al
801029b3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b6:	89 da                	mov    %ebx,%edx
801029b8:	b8 04 00 00 00       	mov    $0x4,%eax
801029bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029be:	89 ca                	mov    %ecx,%edx
801029c0:	ec                   	in     (%dx),%al
801029c1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c4:	89 da                	mov    %ebx,%edx
801029c6:	b8 07 00 00 00       	mov    $0x7,%eax
801029cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cc:	89 ca                	mov    %ecx,%edx
801029ce:	ec                   	in     (%dx),%al
801029cf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	b8 08 00 00 00       	mov    $0x8,%eax
801029d9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029df:	89 da                	mov    %ebx,%edx
801029e1:	b8 09 00 00 00       	mov    $0x9,%eax
801029e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e7:	89 ca                	mov    %ecx,%edx
801029e9:	ec                   	in     (%dx),%al
801029ea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 0a 00 00 00       	mov    $0xa,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029f7:	84 c0                	test   %al,%al
801029f9:	78 9d                	js     80102998 <cmostime+0x28>
  return inb(CMOS_RETURN);
801029fb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029ff:	89 fa                	mov    %edi,%edx
80102a01:	0f b6 fa             	movzbl %dl,%edi
80102a04:	89 f2                	mov    %esi,%edx
80102a06:	0f b6 f2             	movzbl %dl,%esi
80102a09:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0c:	89 da                	mov    %ebx,%edx
80102a0e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a11:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a14:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a18:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a1b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a22:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a29:	31 c0                	xor    %eax,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a37:	b8 02 00 00 00       	mov    $0x2,%eax
80102a3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3d:	89 ca                	mov    %ecx,%edx
80102a3f:	ec                   	in     (%dx),%al
80102a40:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a43:	89 da                	mov    %ebx,%edx
80102a45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a48:	b8 04 00 00 00       	mov    $0x4,%eax
80102a4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4e:	89 ca                	mov    %ecx,%edx
80102a50:	ec                   	in     (%dx),%al
80102a51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a54:	89 da                	mov    %ebx,%edx
80102a56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a59:	b8 07 00 00 00       	mov    $0x7,%eax
80102a5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5f:	89 ca                	mov    %ecx,%edx
80102a61:	ec                   	in     (%dx),%al
80102a62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a65:	89 da                	mov    %ebx,%edx
80102a67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a70:	89 ca                	mov    %ecx,%edx
80102a72:	ec                   	in     (%dx),%al
80102a73:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a76:	89 da                	mov    %ebx,%edx
80102a78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a80:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a81:	89 ca                	mov    %ecx,%edx
80102a83:	ec                   	in     (%dx),%al
80102a84:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a87:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a8d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a90:	6a 18                	push   $0x18
80102a92:	50                   	push   %eax
80102a93:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a96:	50                   	push   %eax
80102a97:	e8 b4 1b 00 00       	call   80104650 <memcmp>
80102a9c:	83 c4 10             	add    $0x10,%esp
80102a9f:	85 c0                	test   %eax,%eax
80102aa1:	0f 85 f1 fe ff ff    	jne    80102998 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102aa7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102aab:	75 78                	jne    80102b25 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102aad:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ab0:	89 c2                	mov    %eax,%edx
80102ab2:	83 e0 0f             	and    $0xf,%eax
80102ab5:	c1 ea 04             	shr    $0x4,%edx
80102ab8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102abb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102abe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ac1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ac4:	89 c2                	mov    %eax,%edx
80102ac6:	83 e0 0f             	and    $0xf,%eax
80102ac9:	c1 ea 04             	shr    $0x4,%edx
80102acc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102acf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ad2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ad5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ae9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102afd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b11:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b25:	8b 75 08             	mov    0x8(%ebp),%esi
80102b28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b2b:	89 06                	mov    %eax,(%esi)
80102b2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b30:	89 46 04             	mov    %eax,0x4(%esi)
80102b33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b36:	89 46 08             	mov    %eax,0x8(%esi)
80102b39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b3c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b42:	89 46 10             	mov    %eax,0x10(%esi)
80102b45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b48:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b4b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b55:	5b                   	pop    %ebx
80102b56:	5e                   	pop    %esi
80102b57:	5f                   	pop    %edi
80102b58:	5d                   	pop    %ebp
80102b59:	c3                   	ret    
80102b5a:	66 90                	xchg   %ax,%ax
80102b5c:	66 90                	xchg   %ax,%ax
80102b5e:	66 90                	xchg   %ax,%ax

80102b60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b60:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102b66:	85 c9                	test   %ecx,%ecx
80102b68:	0f 8e 8a 00 00 00    	jle    80102bf8 <install_trans+0x98>
{
80102b6e:	55                   	push   %ebp
80102b6f:	89 e5                	mov    %esp,%ebp
80102b71:	57                   	push   %edi
80102b72:	56                   	push   %esi
80102b73:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b74:	31 db                	xor    %ebx,%ebx
{
80102b76:	83 ec 0c             	sub    $0xc,%esp
80102b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b80:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102b85:	83 ec 08             	sub    $0x8,%esp
80102b88:	01 d8                	add    %ebx,%eax
80102b8a:	83 c0 01             	add    $0x1,%eax
80102b8d:	50                   	push   %eax
80102b8e:	ff 35 04 37 11 80    	pushl  0x80113704
80102b94:	e8 37 d5 ff ff       	call   801000d0 <bread>
80102b99:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b9b:	58                   	pop    %eax
80102b9c:	5a                   	pop    %edx
80102b9d:	ff 34 9d 0c 37 11 80 	pushl  -0x7feec8f4(,%ebx,4)
80102ba4:	ff 35 04 37 11 80    	pushl  0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102baa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bad:	e8 1e d5 ff ff       	call   801000d0 <bread>
80102bb2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bb4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bb7:	83 c4 0c             	add    $0xc,%esp
80102bba:	68 00 02 00 00       	push   $0x200
80102bbf:	50                   	push   %eax
80102bc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bc3:	50                   	push   %eax
80102bc4:	e8 e7 1a 00 00       	call   801046b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bc9:	89 34 24             	mov    %esi,(%esp)
80102bcc:	e8 cf d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bd1:	89 3c 24             	mov    %edi,(%esp)
80102bd4:	e8 07 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102bd9:	89 34 24             	mov    %esi,(%esp)
80102bdc:	e8 ff d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102be1:	83 c4 10             	add    $0x10,%esp
80102be4:	39 1d 08 37 11 80    	cmp    %ebx,0x80113708
80102bea:	7f 94                	jg     80102b80 <install_trans+0x20>
  }
}
80102bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bef:	5b                   	pop    %ebx
80102bf0:	5e                   	pop    %esi
80102bf1:	5f                   	pop    %edi
80102bf2:	5d                   	pop    %ebp
80102bf3:	c3                   	ret    
80102bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bf8:	f3 c3                	repz ret 
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	56                   	push   %esi
80102c04:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	ff 35 f4 36 11 80    	pushl  0x801136f4
80102c0e:	ff 35 04 37 11 80    	pushl  0x80113704
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c19:	8b 1d 08 37 11 80    	mov    0x80113708,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c1f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c22:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c24:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c26:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c29:	7e 16                	jle    80102c41 <write_head+0x41>
80102c2b:	c1 e3 02             	shl    $0x2,%ebx
80102c2e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c30:	8b 8a 0c 37 11 80    	mov    -0x7feec8f4(%edx),%ecx
80102c36:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c3a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c3d:	39 da                	cmp    %ebx,%edx
80102c3f:	75 ef                	jne    80102c30 <write_head+0x30>
  }
  bwrite(buf);
80102c41:	83 ec 0c             	sub    $0xc,%esp
80102c44:	56                   	push   %esi
80102c45:	e8 56 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c4a:	89 34 24             	mov    %esi,(%esp)
80102c4d:	e8 8e d5 ff ff       	call   801001e0 <brelse>
}
80102c52:	83 c4 10             	add    $0x10,%esp
80102c55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c58:	5b                   	pop    %ebx
80102c59:	5e                   	pop    %esi
80102c5a:	5d                   	pop    %ebp
80102c5b:	c3                   	ret    
80102c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c60 <initlog>:
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 2c             	sub    $0x2c,%esp
80102c67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c6a:	68 e0 7e 10 80       	push   $0x80107ee0
80102c6f:	68 c0 36 11 80       	push   $0x801136c0
80102c74:	e8 37 17 00 00       	call   801043b0 <initlock>
  readsb(dev, &sb);
80102c79:	58                   	pop    %eax
80102c7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c7d:	5a                   	pop    %edx
80102c7e:	50                   	push   %eax
80102c7f:	53                   	push   %ebx
80102c80:	e8 4b e7 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	59                   	pop    %ecx
  log.dev = dev;
80102c8c:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102c92:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  log.start = sb.logstart;
80102c98:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  struct buf *buf = bread(log.dev, log.start);
80102c9d:	5a                   	pop    %edx
80102c9e:	50                   	push   %eax
80102c9f:	53                   	push   %ebx
80102ca0:	e8 2b d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ca5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
80102cab:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102cad:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102cb3:	7e 1c                	jle    80102cd1 <initlog+0x71>
80102cb5:	c1 e3 02             	shl    $0x2,%ebx
80102cb8:	31 d2                	xor    %edx,%edx
80102cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102cc0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102cc4:	83 c2 04             	add    $0x4,%edx
80102cc7:	89 8a 08 37 11 80    	mov    %ecx,-0x7feec8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102ccd:	39 d3                	cmp    %edx,%ebx
80102ccf:	75 ef                	jne    80102cc0 <initlog+0x60>
  brelse(buf);
80102cd1:	83 ec 0c             	sub    $0xc,%esp
80102cd4:	50                   	push   %eax
80102cd5:	e8 06 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cda:	e8 81 fe ff ff       	call   80102b60 <install_trans>
  log.lh.n = 0;
80102cdf:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102ce6:	00 00 00 
  write_head(); // clear the log
80102ce9:	e8 12 ff ff ff       	call   80102c00 <write_head>
}
80102cee:	83 c4 10             	add    $0x10,%esp
80102cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cf4:	c9                   	leave  
80102cf5:	c3                   	ret    
80102cf6:	8d 76 00             	lea    0x0(%esi),%esi
80102cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d06:	68 c0 36 11 80       	push   $0x801136c0
80102d0b:	e8 e0 17 00 00       	call   801044f0 <acquire>
80102d10:	83 c4 10             	add    $0x10,%esp
80102d13:	eb 18                	jmp    80102d2d <begin_op+0x2d>
80102d15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d18:	83 ec 08             	sub    $0x8,%esp
80102d1b:	68 c0 36 11 80       	push   $0x801136c0
80102d20:	68 c0 36 11 80       	push   $0x801136c0
80102d25:	e8 c6 11 00 00       	call   80103ef0 <sleep>
80102d2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d2d:	a1 00 37 11 80       	mov    0x80113700,%eax
80102d32:	85 c0                	test   %eax,%eax
80102d34:	75 e2                	jne    80102d18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d36:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102d3b:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80102d41:	83 c0 01             	add    $0x1,%eax
80102d44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d4a:	83 fa 1e             	cmp    $0x1e,%edx
80102d4d:	7f c9                	jg     80102d18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d4f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d52:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102d57:	68 c0 36 11 80       	push   $0x801136c0
80102d5c:	e8 4f 18 00 00       	call   801045b0 <release>
      break;
    }
  }
}
80102d61:	83 c4 10             	add    $0x10,%esp
80102d64:	c9                   	leave  
80102d65:	c3                   	ret    
80102d66:	8d 76 00             	lea    0x0(%esi),%esi
80102d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	57                   	push   %edi
80102d74:	56                   	push   %esi
80102d75:	53                   	push   %ebx
80102d76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d79:	68 c0 36 11 80       	push   $0x801136c0
80102d7e:	e8 6d 17 00 00       	call   801044f0 <acquire>
  log.outstanding -= 1;
80102d83:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102d88:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102d8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d91:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102d94:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102d96:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102d9c:	0f 85 1a 01 00 00    	jne    80102ebc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102da2:	85 db                	test   %ebx,%ebx
80102da4:	0f 85 ee 00 00 00    	jne    80102e98 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102daa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102dad:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102db4:	00 00 00 
  release(&log.lock);
80102db7:	68 c0 36 11 80       	push   $0x801136c0
80102dbc:	e8 ef 17 00 00       	call   801045b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102dc1:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102dc7:	83 c4 10             	add    $0x10,%esp
80102dca:	85 c9                	test   %ecx,%ecx
80102dcc:	0f 8e 85 00 00 00    	jle    80102e57 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102dd2:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102dd7:	83 ec 08             	sub    $0x8,%esp
80102dda:	01 d8                	add    %ebx,%eax
80102ddc:	83 c0 01             	add    $0x1,%eax
80102ddf:	50                   	push   %eax
80102de0:	ff 35 04 37 11 80    	pushl  0x80113704
80102de6:	e8 e5 d2 ff ff       	call   801000d0 <bread>
80102deb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ded:	58                   	pop    %eax
80102dee:	5a                   	pop    %edx
80102def:	ff 34 9d 0c 37 11 80 	pushl  -0x7feec8f4(,%ebx,4)
80102df6:	ff 35 04 37 11 80    	pushl  0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dfc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dff:	e8 cc d2 ff ff       	call   801000d0 <bread>
80102e04:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e06:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e09:	83 c4 0c             	add    $0xc,%esp
80102e0c:	68 00 02 00 00       	push   $0x200
80102e11:	50                   	push   %eax
80102e12:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e15:	50                   	push   %eax
80102e16:	e8 95 18 00 00       	call   801046b0 <memmove>
    bwrite(to);  // write the log
80102e1b:	89 34 24             	mov    %esi,(%esp)
80102e1e:	e8 7d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e23:	89 3c 24             	mov    %edi,(%esp)
80102e26:	e8 b5 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e2b:	89 34 24             	mov    %esi,(%esp)
80102e2e:	e8 ad d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e33:	83 c4 10             	add    $0x10,%esp
80102e36:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
80102e3c:	7c 94                	jl     80102dd2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e3e:	e8 bd fd ff ff       	call   80102c00 <write_head>
    install_trans(); // Now install writes to home locations
80102e43:	e8 18 fd ff ff       	call   80102b60 <install_trans>
    log.lh.n = 0;
80102e48:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102e4f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e52:	e8 a9 fd ff ff       	call   80102c00 <write_head>
    acquire(&log.lock);
80102e57:	83 ec 0c             	sub    $0xc,%esp
80102e5a:	68 c0 36 11 80       	push   $0x801136c0
80102e5f:	e8 8c 16 00 00       	call   801044f0 <acquire>
    wakeup(&log);
80102e64:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
    log.committing = 0;
80102e6b:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80102e72:	00 00 00 
    wakeup(&log);
80102e75:	e8 26 12 00 00       	call   801040a0 <wakeup>
    release(&log.lock);
80102e7a:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102e81:	e8 2a 17 00 00       	call   801045b0 <release>
80102e86:	83 c4 10             	add    $0x10,%esp
}
80102e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e8c:	5b                   	pop    %ebx
80102e8d:	5e                   	pop    %esi
80102e8e:	5f                   	pop    %edi
80102e8f:	5d                   	pop    %ebp
80102e90:	c3                   	ret    
80102e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102e98:	83 ec 0c             	sub    $0xc,%esp
80102e9b:	68 c0 36 11 80       	push   $0x801136c0
80102ea0:	e8 fb 11 00 00       	call   801040a0 <wakeup>
  release(&log.lock);
80102ea5:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102eac:	e8 ff 16 00 00       	call   801045b0 <release>
80102eb1:	83 c4 10             	add    $0x10,%esp
}
80102eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb7:	5b                   	pop    %ebx
80102eb8:	5e                   	pop    %esi
80102eb9:	5f                   	pop    %edi
80102eba:	5d                   	pop    %ebp
80102ebb:	c3                   	ret    
    panic("log.committing");
80102ebc:	83 ec 0c             	sub    $0xc,%esp
80102ebf:	68 e4 7e 10 80       	push   $0x80107ee4
80102ec4:	e8 c7 d4 ff ff       	call   80100390 <panic>
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ed0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ed7:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
80102edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ee0:	83 fa 1d             	cmp    $0x1d,%edx
80102ee3:	0f 8f 9d 00 00 00    	jg     80102f86 <log_write+0xb6>
80102ee9:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102eee:	83 e8 01             	sub    $0x1,%eax
80102ef1:	39 c2                	cmp    %eax,%edx
80102ef3:	0f 8d 8d 00 00 00    	jge    80102f86 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ef9:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102efe:	85 c0                	test   %eax,%eax
80102f00:	0f 8e 8d 00 00 00    	jle    80102f93 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	68 c0 36 11 80       	push   $0x801136c0
80102f0e:	e8 dd 15 00 00       	call   801044f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f13:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102f19:	83 c4 10             	add    $0x10,%esp
80102f1c:	83 f9 00             	cmp    $0x0,%ecx
80102f1f:	7e 57                	jle    80102f78 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f21:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f24:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f26:	3b 15 0c 37 11 80    	cmp    0x8011370c,%edx
80102f2c:	75 0b                	jne    80102f39 <log_write+0x69>
80102f2e:	eb 38                	jmp    80102f68 <log_write+0x98>
80102f30:	39 14 85 0c 37 11 80 	cmp    %edx,-0x7feec8f4(,%eax,4)
80102f37:	74 2f                	je     80102f68 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f39:	83 c0 01             	add    $0x1,%eax
80102f3c:	39 c1                	cmp    %eax,%ecx
80102f3e:	75 f0                	jne    80102f30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f40:	89 14 85 0c 37 11 80 	mov    %edx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f47:	83 c0 01             	add    $0x1,%eax
80102f4a:	a3 08 37 11 80       	mov    %eax,0x80113708
  b->flags |= B_DIRTY; // prevent eviction
80102f4f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f52:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80102f59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f5c:	c9                   	leave  
  release(&log.lock);
80102f5d:	e9 4e 16 00 00       	jmp    801045b0 <release>
80102f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f68:	89 14 85 0c 37 11 80 	mov    %edx,-0x7feec8f4(,%eax,4)
80102f6f:	eb de                	jmp    80102f4f <log_write+0x7f>
80102f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f78:	8b 43 08             	mov    0x8(%ebx),%eax
80102f7b:	a3 0c 37 11 80       	mov    %eax,0x8011370c
  if (i == log.lh.n)
80102f80:	75 cd                	jne    80102f4f <log_write+0x7f>
80102f82:	31 c0                	xor    %eax,%eax
80102f84:	eb c1                	jmp    80102f47 <log_write+0x77>
    panic("too big a transaction");
80102f86:	83 ec 0c             	sub    $0xc,%esp
80102f89:	68 f3 7e 10 80       	push   $0x80107ef3
80102f8e:	e8 fd d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f93:	83 ec 0c             	sub    $0xc,%esp
80102f96:	68 09 7f 10 80       	push   $0x80107f09
80102f9b:	e8 f0 d3 ff ff       	call   80100390 <panic>

80102fa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fa7:	e8 84 09 00 00       	call   80103930 <cpuid>
80102fac:	89 c3                	mov    %eax,%ebx
80102fae:	e8 7d 09 00 00       	call   80103930 <cpuid>
80102fb3:	83 ec 04             	sub    $0x4,%esp
80102fb6:	53                   	push   %ebx
80102fb7:	50                   	push   %eax
80102fb8:	68 24 7f 10 80       	push   $0x80107f24
80102fbd:	e8 9e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102fc2:	e8 b9 28 00 00       	call   80105880 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fc7:	e8 e4 08 00 00       	call   801038b0 <mycpu>
80102fcc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fce:	b8 01 00 00 00       	mov    $0x1,%eax
80102fd3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102fda:	e8 31 0c 00 00       	call   80103c10 <scheduler>
80102fdf:	90                   	nop

80102fe0 <mpenter>:
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fe6:	e8 85 39 00 00       	call   80106970 <switchkvm>
  seginit();
80102feb:	e8 f0 38 00 00       	call   801068e0 <seginit>
  lapicinit();
80102ff0:	e8 9b f7 ff ff       	call   80102790 <lapicinit>
  mpmain();
80102ff5:	e8 a6 ff ff ff       	call   80102fa0 <mpmain>
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <main>:
{
80103000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103004:	83 e4 f0             	and    $0xfffffff0,%esp
80103007:	ff 71 fc             	pushl  -0x4(%ecx)
8010300a:	55                   	push   %ebp
8010300b:	89 e5                	mov    %esp,%ebp
8010300d:	53                   	push   %ebx
8010300e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010300f:	83 ec 08             	sub    $0x8,%esp
80103012:	68 00 00 40 80       	push   $0x80400000
80103017:	68 40 6c 11 80       	push   $0x80116c40
8010301c:	e8 2f f5 ff ff       	call   80102550 <kinit1>
  kvmalloc();      // kernel page table
80103021:	e8 1a 3e 00 00       	call   80106e40 <kvmalloc>
  mpinit();        // detect other processors
80103026:	e8 75 01 00 00       	call   801031a0 <mpinit>
  lapicinit();     // interrupt controller
8010302b:	e8 60 f7 ff ff       	call   80102790 <lapicinit>
  seginit();       // segment descriptors
80103030:	e8 ab 38 00 00       	call   801068e0 <seginit>
  picinit();       // disable pic
80103035:	e8 46 03 00 00       	call   80103380 <picinit>
  ioapicinit();    // another interrupt controller
8010303a:	e8 41 f3 ff ff       	call   80102380 <ioapicinit>
  procfsinit();    // procfs file system
8010303f:	e8 ac 40 00 00       	call   801070f0 <procfsinit>
  consoleinit();   // console hardware
80103044:	e8 77 d9 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103049:	e8 62 2b 00 00       	call   80105bb0 <uartinit>
  pinit();         // process table
8010304e:	e8 3d 08 00 00       	call   80103890 <pinit>
  tvinit();        // trap vectors
80103053:	e8 a8 27 00 00       	call   80105800 <tvinit>
  binit();         // buffer cache
80103058:	e8 e3 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010305d:	e8 fe dc ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80103062:	e8 f9 f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103067:	83 c4 0c             	add    $0xc,%esp
8010306a:	68 8a 00 00 00       	push   $0x8a
8010306f:	68 8c b4 10 80       	push   $0x8010b48c
80103074:	68 00 70 00 80       	push   $0x80007000
80103079:	e8 32 16 00 00       	call   801046b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010307e:	69 05 40 3d 11 80 b0 	imul   $0xb0,0x80113d40,%eax
80103085:	00 00 00 
80103088:	83 c4 10             	add    $0x10,%esp
8010308b:	05 c0 37 11 80       	add    $0x801137c0,%eax
80103090:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
80103095:	76 6c                	jbe    80103103 <main+0x103>
80103097:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
8010309c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801030a0:	e8 0b 08 00 00       	call   801038b0 <mycpu>
801030a5:	39 d8                	cmp    %ebx,%eax
801030a7:	74 41                	je     801030ea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030a9:	e8 72 f5 ff ff       	call   80102620 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ae:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801030b3:	c7 05 f8 6f 00 80 e0 	movl   $0x80102fe0,0x80006ff8
801030ba:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030bd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801030c4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801030c7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801030cc:	0f b6 03             	movzbl (%ebx),%eax
801030cf:	83 ec 08             	sub    $0x8,%esp
801030d2:	68 00 70 00 00       	push   $0x7000
801030d7:	50                   	push   %eax
801030d8:	e8 03 f8 ff ff       	call   801028e0 <lapicstartap>
801030dd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030e6:	85 c0                	test   %eax,%eax
801030e8:	74 f6                	je     801030e0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801030ea:	69 05 40 3d 11 80 b0 	imul   $0xb0,0x80113d40,%eax
801030f1:	00 00 00 
801030f4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030fa:	05 c0 37 11 80       	add    $0x801137c0,%eax
801030ff:	39 c3                	cmp    %eax,%ebx
80103101:	72 9d                	jb     801030a0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103103:	83 ec 08             	sub    $0x8,%esp
80103106:	68 00 00 00 8e       	push   $0x8e000000
8010310b:	68 00 00 40 80       	push   $0x80400000
80103110:	e8 ab f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103115:	e8 66 08 00 00       	call   80103980 <userinit>
  mpmain();        // finish this processor's setup
8010311a:	e8 81 fe ff ff       	call   80102fa0 <mpmain>
8010311f:	90                   	nop

80103120 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103125:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010312b:	53                   	push   %ebx
  e = addr+len;
8010312c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010312f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103132:	39 de                	cmp    %ebx,%esi
80103134:	72 10                	jb     80103146 <mpsearch1+0x26>
80103136:	eb 50                	jmp    80103188 <mpsearch1+0x68>
80103138:	90                   	nop
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	39 fb                	cmp    %edi,%ebx
80103142:	89 fe                	mov    %edi,%esi
80103144:	76 42                	jbe    80103188 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103146:	83 ec 04             	sub    $0x4,%esp
80103149:	8d 7e 10             	lea    0x10(%esi),%edi
8010314c:	6a 04                	push   $0x4
8010314e:	68 38 7f 10 80       	push   $0x80107f38
80103153:	56                   	push   %esi
80103154:	e8 f7 14 00 00       	call   80104650 <memcmp>
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	85 c0                	test   %eax,%eax
8010315e:	75 e0                	jne    80103140 <mpsearch1+0x20>
80103160:	89 f1                	mov    %esi,%ecx
80103162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103168:	0f b6 11             	movzbl (%ecx),%edx
8010316b:	83 c1 01             	add    $0x1,%ecx
8010316e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103170:	39 f9                	cmp    %edi,%ecx
80103172:	75 f4                	jne    80103168 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103174:	84 c0                	test   %al,%al
80103176:	75 c8                	jne    80103140 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317b:	89 f0                	mov    %esi,%eax
8010317d:	5b                   	pop    %ebx
8010317e:	5e                   	pop    %esi
8010317f:	5f                   	pop    %edi
80103180:	5d                   	pop    %ebp
80103181:	c3                   	ret    
80103182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010318b:	31 f6                	xor    %esi,%esi
}
8010318d:	89 f0                	mov    %esi,%eax
8010318f:	5b                   	pop    %ebx
80103190:	5e                   	pop    %esi
80103191:	5f                   	pop    %edi
80103192:	5d                   	pop    %ebp
80103193:	c3                   	ret    
80103194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010319a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801031a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031b7:	c1 e0 08             	shl    $0x8,%eax
801031ba:	09 d0                	or     %edx,%eax
801031bc:	c1 e0 04             	shl    $0x4,%eax
801031bf:	85 c0                	test   %eax,%eax
801031c1:	75 1b                	jne    801031de <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031d1:	c1 e0 08             	shl    $0x8,%eax
801031d4:	09 d0                	or     %edx,%eax
801031d6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031d9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031de:	ba 00 04 00 00       	mov    $0x400,%edx
801031e3:	e8 38 ff ff ff       	call   80103120 <mpsearch1>
801031e8:	85 c0                	test   %eax,%eax
801031ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801031ed:	0f 84 3d 01 00 00    	je     80103330 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031f6:	8b 58 04             	mov    0x4(%eax),%ebx
801031f9:	85 db                	test   %ebx,%ebx
801031fb:	0f 84 4f 01 00 00    	je     80103350 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103201:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103207:	83 ec 04             	sub    $0x4,%esp
8010320a:	6a 04                	push   $0x4
8010320c:	68 55 7f 10 80       	push   $0x80107f55
80103211:	56                   	push   %esi
80103212:	e8 39 14 00 00       	call   80104650 <memcmp>
80103217:	83 c4 10             	add    $0x10,%esp
8010321a:	85 c0                	test   %eax,%eax
8010321c:	0f 85 2e 01 00 00    	jne    80103350 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103222:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103229:	3c 01                	cmp    $0x1,%al
8010322b:	0f 95 c2             	setne  %dl
8010322e:	3c 04                	cmp    $0x4,%al
80103230:	0f 95 c0             	setne  %al
80103233:	20 c2                	and    %al,%dl
80103235:	0f 85 15 01 00 00    	jne    80103350 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010323b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103242:	66 85 ff             	test   %di,%di
80103245:	74 1a                	je     80103261 <mpinit+0xc1>
80103247:	89 f0                	mov    %esi,%eax
80103249:	01 f7                	add    %esi,%edi
  sum = 0;
8010324b:	31 d2                	xor    %edx,%edx
8010324d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103250:	0f b6 08             	movzbl (%eax),%ecx
80103253:	83 c0 01             	add    $0x1,%eax
80103256:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103258:	39 c7                	cmp    %eax,%edi
8010325a:	75 f4                	jne    80103250 <mpinit+0xb0>
8010325c:	84 d2                	test   %dl,%dl
8010325e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103261:	85 f6                	test   %esi,%esi
80103263:	0f 84 e7 00 00 00    	je     80103350 <mpinit+0x1b0>
80103269:	84 d2                	test   %dl,%dl
8010326b:	0f 85 df 00 00 00    	jne    80103350 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103271:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103277:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010327c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103283:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103289:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010328e:	01 d6                	add    %edx,%esi
80103290:	39 c6                	cmp    %eax,%esi
80103292:	76 23                	jbe    801032b7 <mpinit+0x117>
    switch(*p){
80103294:	0f b6 10             	movzbl (%eax),%edx
80103297:	80 fa 04             	cmp    $0x4,%dl
8010329a:	0f 87 ca 00 00 00    	ja     8010336a <mpinit+0x1ca>
801032a0:	ff 24 95 7c 7f 10 80 	jmp    *-0x7fef8084(,%edx,4)
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032b0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b3:	39 c6                	cmp    %eax,%esi
801032b5:	77 dd                	ja     80103294 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032b7:	85 db                	test   %ebx,%ebx
801032b9:	0f 84 9e 00 00 00    	je     8010335d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032c2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801032c6:	74 15                	je     801032dd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c8:	b8 70 00 00 00       	mov    $0x70,%eax
801032cd:	ba 22 00 00 00       	mov    $0x22,%edx
801032d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d3:	ba 23 00 00 00       	mov    $0x23,%edx
801032d8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032d9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032dc:	ee                   	out    %al,(%dx)
  }
}
801032dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032e0:	5b                   	pop    %ebx
801032e1:	5e                   	pop    %esi
801032e2:	5f                   	pop    %edi
801032e3:	5d                   	pop    %ebp
801032e4:	c3                   	ret    
801032e5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801032e8:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
801032ee:	83 f9 07             	cmp    $0x7,%ecx
801032f1:	7f 19                	jg     8010330c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801032fd:	83 c1 01             	add    $0x1,%ecx
80103300:	89 0d 40 3d 11 80    	mov    %ecx,0x80113d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103306:	88 97 c0 37 11 80    	mov    %dl,-0x7feec840(%edi)
      p += sizeof(struct mpproc);
8010330c:	83 c0 14             	add    $0x14,%eax
      continue;
8010330f:	e9 7c ff ff ff       	jmp    80103290 <mpinit+0xf0>
80103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103318:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010331c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010331f:	88 15 a0 37 11 80    	mov    %dl,0x801137a0
      continue;
80103325:	e9 66 ff ff ff       	jmp    80103290 <mpinit+0xf0>
8010332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103330:	ba 00 00 01 00       	mov    $0x10000,%edx
80103335:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010333a:	e8 e1 fd ff ff       	call   80103120 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010333f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103341:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103344:	0f 85 a9 fe ff ff    	jne    801031f3 <mpinit+0x53>
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103350:	83 ec 0c             	sub    $0xc,%esp
80103353:	68 3d 7f 10 80       	push   $0x80107f3d
80103358:	e8 33 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010335d:	83 ec 0c             	sub    $0xc,%esp
80103360:	68 5c 7f 10 80       	push   $0x80107f5c
80103365:	e8 26 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
8010336a:	31 db                	xor    %ebx,%ebx
8010336c:	e9 26 ff ff ff       	jmp    80103297 <mpinit+0xf7>
80103371:	66 90                	xchg   %ax,%ax
80103373:	66 90                	xchg   %ax,%ax
80103375:	66 90                	xchg   %ax,%ax
80103377:	66 90                	xchg   %ax,%ax
80103379:	66 90                	xchg   %ax,%ax
8010337b:	66 90                	xchg   %ax,%ax
8010337d:	66 90                	xchg   %ax,%ax
8010337f:	90                   	nop

80103380 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103380:	55                   	push   %ebp
80103381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103386:	ba 21 00 00 00       	mov    $0x21,%edx
8010338b:	89 e5                	mov    %esp,%ebp
8010338d:	ee                   	out    %al,(%dx)
8010338e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103393:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103394:	5d                   	pop    %ebp
80103395:	c3                   	ret    
80103396:	66 90                	xchg   %ax,%ax
80103398:	66 90                	xchg   %ax,%ax
8010339a:	66 90                	xchg   %ax,%ax
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 0c             	sub    $0xc,%esp
801033a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033bb:	e8 c0 d9 ff ff       	call   80100d80 <filealloc>
801033c0:	85 c0                	test   %eax,%eax
801033c2:	89 03                	mov    %eax,(%ebx)
801033c4:	74 22                	je     801033e8 <pipealloc+0x48>
801033c6:	e8 b5 d9 ff ff       	call   80100d80 <filealloc>
801033cb:	85 c0                	test   %eax,%eax
801033cd:	89 06                	mov    %eax,(%esi)
801033cf:	74 3f                	je     80103410 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033d1:	e8 4a f2 ff ff       	call   80102620 <kalloc>
801033d6:	85 c0                	test   %eax,%eax
801033d8:	89 c7                	mov    %eax,%edi
801033da:	75 54                	jne    80103430 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033dc:	8b 03                	mov    (%ebx),%eax
801033de:	85 c0                	test   %eax,%eax
801033e0:	75 34                	jne    80103416 <pipealloc+0x76>
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801033e8:	8b 06                	mov    (%esi),%eax
801033ea:	85 c0                	test   %eax,%eax
801033ec:	74 0c                	je     801033fa <pipealloc+0x5a>
    fileclose(*f1);
801033ee:	83 ec 0c             	sub    $0xc,%esp
801033f1:	50                   	push   %eax
801033f2:	e8 49 da ff ff       	call   80100e40 <fileclose>
801033f7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801033fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801033fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103402:	5b                   	pop    %ebx
80103403:	5e                   	pop    %esi
80103404:	5f                   	pop    %edi
80103405:	5d                   	pop    %ebp
80103406:	c3                   	ret    
80103407:	89 f6                	mov    %esi,%esi
80103409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103410:	8b 03                	mov    (%ebx),%eax
80103412:	85 c0                	test   %eax,%eax
80103414:	74 e4                	je     801033fa <pipealloc+0x5a>
    fileclose(*f0);
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	50                   	push   %eax
8010341a:	e8 21 da ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010341f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103421:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103424:	85 c0                	test   %eax,%eax
80103426:	75 c6                	jne    801033ee <pipealloc+0x4e>
80103428:	eb d0                	jmp    801033fa <pipealloc+0x5a>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103430:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103433:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010343a:	00 00 00 
  p->writeopen = 1;
8010343d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103444:	00 00 00 
  p->nwrite = 0;
80103447:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010344e:	00 00 00 
  p->nread = 0;
80103451:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103458:	00 00 00 
  initlock(&p->lock, "pipe");
8010345b:	68 90 7f 10 80       	push   $0x80107f90
80103460:	50                   	push   %eax
80103461:	e8 4a 0f 00 00       	call   801043b0 <initlock>
  (*f0)->type = FD_PIPE;
80103466:	8b 03                	mov    (%ebx),%eax
  return 0;
80103468:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010346b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103471:	8b 03                	mov    (%ebx),%eax
80103473:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103477:	8b 03                	mov    (%ebx),%eax
80103479:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103482:	8b 06                	mov    (%esi),%eax
80103484:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010348a:	8b 06                	mov    (%esi),%eax
8010348c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103490:	8b 06                	mov    (%esi),%eax
80103492:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010349b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010349e:	31 c0                	xor    %eax,%eax
}
801034a0:	5b                   	pop    %ebx
801034a1:	5e                   	pop    %esi
801034a2:	5f                   	pop    %edi
801034a3:	5d                   	pop    %ebp
801034a4:	c3                   	ret    
801034a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	56                   	push   %esi
801034b4:	53                   	push   %ebx
801034b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034bb:	83 ec 0c             	sub    $0xc,%esp
801034be:	53                   	push   %ebx
801034bf:	e8 2c 10 00 00       	call   801044f0 <acquire>
  if(writable){
801034c4:	83 c4 10             	add    $0x10,%esp
801034c7:	85 f6                	test   %esi,%esi
801034c9:	74 45                	je     80103510 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801034cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034d1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801034d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034db:	00 00 00 
    wakeup(&p->nread);
801034de:	50                   	push   %eax
801034df:	e8 bc 0b 00 00       	call   801040a0 <wakeup>
801034e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034ed:	85 d2                	test   %edx,%edx
801034ef:	75 0a                	jne    801034fb <pipeclose+0x4b>
801034f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034f7:	85 c0                	test   %eax,%eax
801034f9:	74 35                	je     80103530 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103501:	5b                   	pop    %ebx
80103502:	5e                   	pop    %esi
80103503:	5d                   	pop    %ebp
    release(&p->lock);
80103504:	e9 a7 10 00 00       	jmp    801045b0 <release>
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103510:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103516:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103519:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103520:	00 00 00 
    wakeup(&p->nwrite);
80103523:	50                   	push   %eax
80103524:	e8 77 0b 00 00       	call   801040a0 <wakeup>
80103529:	83 c4 10             	add    $0x10,%esp
8010352c:	eb b9                	jmp    801034e7 <pipeclose+0x37>
8010352e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	53                   	push   %ebx
80103534:	e8 77 10 00 00       	call   801045b0 <release>
    kfree((char*)p);
80103539:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010353c:	83 c4 10             	add    $0x10,%esp
}
8010353f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103542:	5b                   	pop    %ebx
80103543:	5e                   	pop    %esi
80103544:	5d                   	pop    %ebp
    kfree((char*)p);
80103545:	e9 26 ef ff ff       	jmp    80102470 <kfree>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103550 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 28             	sub    $0x28,%esp
80103559:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010355c:	53                   	push   %ebx
8010355d:	e8 8e 0f 00 00       	call   801044f0 <acquire>
  for(i = 0; i < n; i++){
80103562:	8b 45 10             	mov    0x10(%ebp),%eax
80103565:	83 c4 10             	add    $0x10,%esp
80103568:	85 c0                	test   %eax,%eax
8010356a:	0f 8e c9 00 00 00    	jle    80103639 <pipewrite+0xe9>
80103570:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103573:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103579:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010357f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103582:	03 4d 10             	add    0x10(%ebp),%ecx
80103585:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103588:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010358e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103594:	39 d0                	cmp    %edx,%eax
80103596:	75 71                	jne    80103609 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103598:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010359e:	85 c0                	test   %eax,%eax
801035a0:	74 4e                	je     801035f0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035a2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035a8:	eb 3a                	jmp    801035e4 <pipewrite+0x94>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	57                   	push   %edi
801035b4:	e8 e7 0a 00 00       	call   801040a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035b9:	5a                   	pop    %edx
801035ba:	59                   	pop    %ecx
801035bb:	53                   	push   %ebx
801035bc:	56                   	push   %esi
801035bd:	e8 2e 09 00 00       	call   80103ef0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035c8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035ce:	83 c4 10             	add    $0x10,%esp
801035d1:	05 00 02 00 00       	add    $0x200,%eax
801035d6:	39 c2                	cmp    %eax,%edx
801035d8:	75 36                	jne    80103610 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801035da:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035e0:	85 c0                	test   %eax,%eax
801035e2:	74 0c                	je     801035f0 <pipewrite+0xa0>
801035e4:	e8 67 03 00 00       	call   80103950 <myproc>
801035e9:	8b 40 24             	mov    0x24(%eax),%eax
801035ec:	85 c0                	test   %eax,%eax
801035ee:	74 c0                	je     801035b0 <pipewrite+0x60>
        release(&p->lock);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	53                   	push   %ebx
801035f4:	e8 b7 0f 00 00       	call   801045b0 <release>
        return -1;
801035f9:	83 c4 10             	add    $0x10,%esp
801035fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103604:	5b                   	pop    %ebx
80103605:	5e                   	pop    %esi
80103606:	5f                   	pop    %edi
80103607:	5d                   	pop    %ebp
80103608:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103609:	89 c2                	mov    %eax,%edx
8010360b:	90                   	nop
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103610:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103613:	8d 42 01             	lea    0x1(%edx),%eax
80103616:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010361c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103622:	83 c6 01             	add    $0x1,%esi
80103625:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103629:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010362c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010362f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103633:	0f 85 4f ff ff ff    	jne    80103588 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103639:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010363f:	83 ec 0c             	sub    $0xc,%esp
80103642:	50                   	push   %eax
80103643:	e8 58 0a 00 00       	call   801040a0 <wakeup>
  release(&p->lock);
80103648:	89 1c 24             	mov    %ebx,(%esp)
8010364b:	e8 60 0f 00 00       	call   801045b0 <release>
  return n;
80103650:	83 c4 10             	add    $0x10,%esp
80103653:	8b 45 10             	mov    0x10(%ebp),%eax
80103656:	eb a9                	jmp    80103601 <pipewrite+0xb1>
80103658:	90                   	nop
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103660 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 18             	sub    $0x18,%esp
80103669:	8b 75 08             	mov    0x8(%ebp),%esi
8010366c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010366f:	56                   	push   %esi
80103670:	e8 7b 0e 00 00       	call   801044f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010367e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103684:	75 6a                	jne    801036f0 <piperead+0x90>
80103686:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010368c:	85 db                	test   %ebx,%ebx
8010368e:	0f 84 c4 00 00 00    	je     80103758 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103694:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010369a:	eb 2d                	jmp    801036c9 <piperead+0x69>
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036a0:	83 ec 08             	sub    $0x8,%esp
801036a3:	56                   	push   %esi
801036a4:	53                   	push   %ebx
801036a5:	e8 46 08 00 00       	call   80103ef0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036b3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036b9:	75 35                	jne    801036f0 <piperead+0x90>
801036bb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801036c1:	85 d2                	test   %edx,%edx
801036c3:	0f 84 8f 00 00 00    	je     80103758 <piperead+0xf8>
    if(myproc()->killed){
801036c9:	e8 82 02 00 00       	call   80103950 <myproc>
801036ce:	8b 48 24             	mov    0x24(%eax),%ecx
801036d1:	85 c9                	test   %ecx,%ecx
801036d3:	74 cb                	je     801036a0 <piperead+0x40>
      release(&p->lock);
801036d5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801036d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801036dd:	56                   	push   %esi
801036de:	e8 cd 0e 00 00       	call   801045b0 <release>
      return -1;
801036e3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e9:	89 d8                	mov    %ebx,%eax
801036eb:	5b                   	pop    %ebx
801036ec:	5e                   	pop    %esi
801036ed:	5f                   	pop    %edi
801036ee:	5d                   	pop    %ebp
801036ef:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036f0:	8b 45 10             	mov    0x10(%ebp),%eax
801036f3:	85 c0                	test   %eax,%eax
801036f5:	7e 61                	jle    80103758 <piperead+0xf8>
    if(p->nread == p->nwrite)
801036f7:	31 db                	xor    %ebx,%ebx
801036f9:	eb 13                	jmp    8010370e <piperead+0xae>
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103700:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103706:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010370c:	74 1f                	je     8010372d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010370e:	8d 41 01             	lea    0x1(%ecx),%eax
80103711:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103717:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010371d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103722:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103725:	83 c3 01             	add    $0x1,%ebx
80103728:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010372b:	75 d3                	jne    80103700 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010372d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103733:	83 ec 0c             	sub    $0xc,%esp
80103736:	50                   	push   %eax
80103737:	e8 64 09 00 00       	call   801040a0 <wakeup>
  release(&p->lock);
8010373c:	89 34 24             	mov    %esi,(%esp)
8010373f:	e8 6c 0e 00 00       	call   801045b0 <release>
  return i;
80103744:	83 c4 10             	add    $0x10,%esp
}
80103747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010374a:	89 d8                	mov    %ebx,%eax
8010374c:	5b                   	pop    %ebx
8010374d:	5e                   	pop    %esi
8010374e:	5f                   	pop    %edi
8010374f:	5d                   	pop    %ebp
80103750:	c3                   	ret    
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	eb d1                	jmp    8010372d <piperead+0xcd>
8010375c:	66 90                	xchg   %ax,%ax
8010375e:	66 90                	xchg   %ax,%ax

80103760 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103764:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
80103769:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010376c:	68 60 3d 11 80       	push   $0x80113d60
80103771:	e8 7a 0d 00 00       	call   801044f0 <acquire>
80103776:	83 c4 10             	add    $0x10,%esp
80103779:	eb 14                	jmp    8010378f <allocproc+0x2f>
8010377b:	90                   	nop
8010377c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103780:	83 c3 7c             	add    $0x7c,%ebx
80103783:	81 fb 94 5c 11 80    	cmp    $0x80115c94,%ebx
80103789:	0f 83 89 00 00 00    	jae    80103818 <allocproc+0xb8>
    if(p->state == UNUSED)
8010378f:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103792:	85 c9                	test   %ecx,%ecx
80103794:	75 ea                	jne    80103780 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103796:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010379b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010379e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037a5:	8d 50 01             	lea    0x1(%eax),%edx
801037a8:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801037ab:	68 60 3d 11 80       	push   $0x80113d60
  p->pid = nextpid++;
801037b0:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801037b6:	e8 f5 0d 00 00       	call   801045b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037bb:	e8 60 ee ff ff       	call   80102620 <kalloc>
801037c0:	83 c4 10             	add    $0x10,%esp
801037c3:	85 c0                	test   %eax,%eax
801037c5:	89 43 08             	mov    %eax,0x8(%ebx)
801037c8:	74 67                	je     80103831 <allocproc+0xd1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037ca:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037d0:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037d3:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037d8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037db:	c7 40 14 f2 57 10 80 	movl   $0x801057f2,0x14(%eax)
  p->context = (struct context*)sp;
801037e2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037e5:	6a 14                	push   $0x14
801037e7:	6a 00                	push   $0x0
801037e9:	50                   	push   %eax
801037ea:	e8 11 0e 00 00       	call   80104600 <memset>
  p->context->eip = (uint)forkret;
801037ef:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037f2:	c7 40 10 40 38 10 80 	movl   $0x80103840,0x10(%eax)

  procfs_add_proc(p->pid, "/");
801037f9:	58                   	pop    %eax
801037fa:	5a                   	pop    %edx
801037fb:	68 95 7f 10 80       	push   $0x80107f95
80103800:	ff 73 10             	pushl  0x10(%ebx)
80103803:	e8 f8 39 00 00       	call   80107200 <procfs_add_proc>

  return p;
80103808:	83 c4 10             	add    $0x10,%esp
}
8010380b:	89 d8                	mov    %ebx,%eax
8010380d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103810:	c9                   	leave  
80103811:	c3                   	ret    
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103818:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010381b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010381d:	68 60 3d 11 80       	push   $0x80113d60
80103822:	e8 89 0d 00 00       	call   801045b0 <release>
}
80103827:	89 d8                	mov    %ebx,%eax
  return 0;
80103829:	83 c4 10             	add    $0x10,%esp
}
8010382c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010382f:	c9                   	leave  
80103830:	c3                   	ret    
    p->state = UNUSED;
80103831:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103838:	31 db                	xor    %ebx,%ebx
8010383a:	eb cf                	jmp    8010380b <allocproc+0xab>
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103840 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103846:	68 60 3d 11 80       	push   $0x80113d60
8010384b:	e8 60 0d 00 00       	call   801045b0 <release>

  if (first) {
80103850:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	85 c0                	test   %eax,%eax
8010385a:	75 04                	jne    80103860 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010385c:	c9                   	leave  
8010385d:	c3                   	ret    
8010385e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103860:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103863:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010386a:	00 00 00 
    iinit(ROOTDEV);
8010386d:	6a 01                	push   $0x1
8010386f:	e8 1c dc ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103874:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010387b:	e8 e0 f3 ff ff       	call   80102c60 <initlog>
80103880:	83 c4 10             	add    $0x10,%esp
}
80103883:	c9                   	leave  
80103884:	c3                   	ret    
80103885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103890 <pinit>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103896:	68 97 7f 10 80       	push   $0x80107f97
8010389b:	68 60 3d 11 80       	push   $0x80113d60
801038a0:	e8 0b 0b 00 00       	call   801043b0 <initlock>
}
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	c9                   	leave  
801038a9:	c3                   	ret    
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038b0 <mycpu>:
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	56                   	push   %esi
801038b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038b5:	9c                   	pushf  
801038b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038b7:	f6 c4 02             	test   $0x2,%ah
801038ba:	75 5e                	jne    8010391a <mycpu+0x6a>
  apicid = lapicid();
801038bc:	e8 cf ef ff ff       	call   80102890 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038c1:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
801038c7:	85 f6                	test   %esi,%esi
801038c9:	7e 42                	jle    8010390d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038cb:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
801038d2:	39 d0                	cmp    %edx,%eax
801038d4:	74 30                	je     80103906 <mycpu+0x56>
801038d6:	b9 70 38 11 80       	mov    $0x80113870,%ecx
  for (i = 0; i < ncpu; ++i) {
801038db:	31 d2                	xor    %edx,%edx
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
801038e0:	83 c2 01             	add    $0x1,%edx
801038e3:	39 f2                	cmp    %esi,%edx
801038e5:	74 26                	je     8010390d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038e7:	0f b6 19             	movzbl (%ecx),%ebx
801038ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038f0:	39 c3                	cmp    %eax,%ebx
801038f2:	75 ec                	jne    801038e0 <mycpu+0x30>
801038f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038fa:	05 c0 37 11 80       	add    $0x801137c0,%eax
}
801038ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103902:	5b                   	pop    %ebx
80103903:	5e                   	pop    %esi
80103904:	5d                   	pop    %ebp
80103905:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103906:	b8 c0 37 11 80       	mov    $0x801137c0,%eax
      return &cpus[i];
8010390b:	eb f2                	jmp    801038ff <mycpu+0x4f>
  panic("unknown apicid\n");
8010390d:	83 ec 0c             	sub    $0xc,%esp
80103910:	68 9e 7f 10 80       	push   $0x80107f9e
80103915:	e8 76 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	68 88 80 10 80       	push   $0x80108088
80103922:	e8 69 ca ff ff       	call   80100390 <panic>
80103927:	89 f6                	mov    %esi,%esi
80103929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103930 <cpuid>:
cpuid() {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103936:	e8 75 ff ff ff       	call   801038b0 <mycpu>
8010393b:	2d c0 37 11 80       	sub    $0x801137c0,%eax
}
80103940:	c9                   	leave  
  return mycpu()-cpus;
80103941:	c1 f8 04             	sar    $0x4,%eax
80103944:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010394a:	c3                   	ret    
8010394b:	90                   	nop
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103950 <myproc>:
myproc(void) {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	53                   	push   %ebx
80103954:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103957:	e8 c4 0a 00 00       	call   80104420 <pushcli>
  c = mycpu();
8010395c:	e8 4f ff ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103961:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103967:	e8 f4 0a 00 00       	call   80104460 <popcli>
}
8010396c:	83 c4 04             	add    $0x4,%esp
8010396f:	89 d8                	mov    %ebx,%eax
80103971:	5b                   	pop    %ebx
80103972:	5d                   	pop    %ebp
80103973:	c3                   	ret    
80103974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010397a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103980 <userinit>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103987:	e8 d4 fd ff ff       	call   80103760 <allocproc>
8010398c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010398e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103993:	e8 28 34 00 00       	call   80106dc0 <setupkvm>
80103998:	85 c0                	test   %eax,%eax
8010399a:	89 43 04             	mov    %eax,0x4(%ebx)
8010399d:	0f 84 bd 00 00 00    	je     80103a60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039a3:	83 ec 04             	sub    $0x4,%esp
801039a6:	68 2c 00 00 00       	push   $0x2c
801039ab:	68 60 b4 10 80       	push   $0x8010b460
801039b0:	50                   	push   %eax
801039b1:	e8 ea 30 00 00       	call   80106aa0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039b6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039bf:	6a 4c                	push   $0x4c
801039c1:	6a 00                	push   $0x0
801039c3:	ff 73 18             	pushl  0x18(%ebx)
801039c6:	e8 35 0c 00 00       	call   80104600 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039cb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039df:	8b 43 18             	mov    0x18(%ebx),%eax
801039e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039e6:	8b 43 18             	mov    0x18(%ebx),%eax
801039e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039f1:	8b 43 18             	mov    0x18(%ebx),%eax
801039f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039fc:	8b 43 18             	mov    0x18(%ebx),%eax
801039ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a10:	8b 43 18             	mov    0x18(%ebx),%eax
80103a13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a1d:	6a 10                	push   $0x10
80103a1f:	68 c7 7f 10 80       	push   $0x80107fc7
80103a24:	50                   	push   %eax
80103a25:	e8 b6 0d 00 00       	call   801047e0 <safestrcpy>
  p->cwd = namei("/");
80103a2a:	c7 04 24 95 7f 10 80 	movl   $0x80107f95,(%esp)
80103a31:	e8 4a e5 ff ff       	call   80101f80 <namei>
80103a36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a39:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a40:	e8 ab 0a 00 00       	call   801044f0 <acquire>
  p->state = RUNNABLE;
80103a45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a4c:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a53:	e8 58 0b 00 00       	call   801045b0 <release>
}
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5e:	c9                   	leave  
80103a5f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	68 ae 7f 10 80       	push   $0x80107fae
80103a68:	e8 23 c9 ff ff       	call   80100390 <panic>
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi

80103a70 <growproc>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a78:	e8 a3 09 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103a7d:	e8 2e fe ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103a82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a88:	e8 d3 09 00 00       	call   80104460 <popcli>
  if(n > 0){
80103a8d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a90:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a92:	7f 1c                	jg     80103ab0 <growproc+0x40>
  } else if(n < 0){
80103a94:	75 3a                	jne    80103ad0 <growproc+0x60>
  switchuvm(curproc);
80103a96:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a99:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a9b:	53                   	push   %ebx
80103a9c:	e8 ef 2e 00 00       	call   80106990 <switchuvm>
  return 0;
80103aa1:	83 c4 10             	add    $0x10,%esp
80103aa4:	31 c0                	xor    %eax,%eax
}
80103aa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa9:	5b                   	pop    %ebx
80103aaa:	5e                   	pop    %esi
80103aab:	5d                   	pop    %ebp
80103aac:	c3                   	ret    
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ab0:	83 ec 04             	sub    $0x4,%esp
80103ab3:	01 c6                	add    %eax,%esi
80103ab5:	56                   	push   %esi
80103ab6:	50                   	push   %eax
80103ab7:	ff 73 04             	pushl  0x4(%ebx)
80103aba:	e8 21 31 00 00       	call   80106be0 <allocuvm>
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	85 c0                	test   %eax,%eax
80103ac4:	75 d0                	jne    80103a96 <growproc+0x26>
      return -1;
80103ac6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103acb:	eb d9                	jmp    80103aa6 <growproc+0x36>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad0:	83 ec 04             	sub    $0x4,%esp
80103ad3:	01 c6                	add    %eax,%esi
80103ad5:	56                   	push   %esi
80103ad6:	50                   	push   %eax
80103ad7:	ff 73 04             	pushl  0x4(%ebx)
80103ada:	e8 31 32 00 00       	call   80106d10 <deallocuvm>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	75 b0                	jne    80103a96 <growproc+0x26>
80103ae6:	eb de                	jmp    80103ac6 <growproc+0x56>
80103ae8:	90                   	nop
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103af0 <fork>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103af9:	e8 22 09 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103afe:	e8 ad fd ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103b03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b09:	e8 52 09 00 00       	call   80104460 <popcli>
  if((np = allocproc()) == 0){
80103b0e:	e8 4d fc ff ff       	call   80103760 <allocproc>
80103b13:	85 c0                	test   %eax,%eax
80103b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b18:	0f 84 b7 00 00 00    	je     80103bd5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b1e:	83 ec 08             	sub    $0x8,%esp
80103b21:	ff 33                	pushl  (%ebx)
80103b23:	ff 73 04             	pushl  0x4(%ebx)
80103b26:	89 c7                	mov    %eax,%edi
80103b28:	e8 63 33 00 00       	call   80106e90 <copyuvm>
80103b2d:	83 c4 10             	add    $0x10,%esp
80103b30:	85 c0                	test   %eax,%eax
80103b32:	89 47 04             	mov    %eax,0x4(%edi)
80103b35:	0f 84 a1 00 00 00    	je     80103bdc <fork+0xec>
  np->sz = curproc->sz;
80103b3b:	8b 03                	mov    (%ebx),%eax
80103b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b40:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b42:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b45:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b47:	8b 79 18             	mov    0x18(%ecx),%edi
80103b4a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b4d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b56:	8b 40 18             	mov    0x18(%eax),%eax
80103b59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	74 13                	je     80103b7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	50                   	push   %eax
80103b6c:	e8 7f d2 ff ff       	call   80100df0 <filedup>
80103b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b74:	83 c4 10             	add    $0x10,%esp
80103b77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b7b:	83 c6 01             	add    $0x1,%esi
80103b7e:	83 fe 10             	cmp    $0x10,%esi
80103b81:	75 dd                	jne    80103b60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b83:	83 ec 0c             	sub    $0xc,%esp
80103b86:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b8c:	e8 cf da ff ff       	call   80101660 <idup>
80103b91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	53                   	push   %ebx
80103ba0:	50                   	push   %eax
80103ba1:	e8 3a 0c 00 00       	call   801047e0 <safestrcpy>
  pid = np->pid;
80103ba6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ba9:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103bb0:	e8 3b 09 00 00       	call   801044f0 <acquire>
  np->state = RUNNABLE;
80103bb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bbc:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103bc3:	e8 e8 09 00 00       	call   801045b0 <release>
  return pid;
80103bc8:	83 c4 10             	add    $0x10,%esp
}
80103bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bce:	89 d8                	mov    %ebx,%eax
80103bd0:	5b                   	pop    %ebx
80103bd1:	5e                   	pop    %esi
80103bd2:	5f                   	pop    %edi
80103bd3:	5d                   	pop    %ebp
80103bd4:	c3                   	ret    
    return -1;
80103bd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bda:	eb ef                	jmp    80103bcb <fork+0xdb>
    kfree(np->kstack);
80103bdc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bdf:	83 ec 0c             	sub    $0xc,%esp
80103be2:	ff 73 08             	pushl  0x8(%ebx)
80103be5:	e8 86 e8 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103bea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103bf1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c00:	eb c9                	jmp    80103bcb <fork+0xdb>
80103c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <scheduler>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c19:	e8 92 fc ff ff       	call   801038b0 <mycpu>
80103c1e:	8d 78 04             	lea    0x4(%eax),%edi
80103c21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c2a:	00 00 00 
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c30:	fb                   	sti    
    acquire(&ptable.lock);
80103c31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c34:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
    acquire(&ptable.lock);
80103c39:	68 60 3d 11 80       	push   $0x80113d60
80103c3e:	e8 ad 08 00 00       	call   801044f0 <acquire>
80103c43:	83 c4 10             	add    $0x10,%esp
80103c46:	8d 76 00             	lea    0x0(%esi),%esi
80103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103c50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c54:	75 33                	jne    80103c89 <scheduler+0x79>
      switchuvm(p);
80103c56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c5f:	53                   	push   %ebx
80103c60:	e8 2b 2d 00 00       	call   80106990 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c65:	58                   	pop    %eax
80103c66:	5a                   	pop    %edx
80103c67:	ff 73 1c             	pushl  0x1c(%ebx)
80103c6a:	57                   	push   %edi
      p->state = RUNNING;
80103c6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c72:	e8 c4 0b 00 00       	call   8010483b <swtch>
      switchkvm();
80103c77:	e8 f4 2c 00 00       	call   80106970 <switchkvm>
      c->proc = 0;
80103c7c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c83:	00 00 00 
80103c86:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c89:	83 c3 7c             	add    $0x7c,%ebx
80103c8c:	81 fb 94 5c 11 80    	cmp    $0x80115c94,%ebx
80103c92:	72 bc                	jb     80103c50 <scheduler+0x40>
    release(&ptable.lock);
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	68 60 3d 11 80       	push   $0x80113d60
80103c9c:	e8 0f 09 00 00       	call   801045b0 <release>
    sti();
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	eb 8a                	jmp    80103c30 <scheduler+0x20>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <sched>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
  pushcli();
80103cb5:	e8 66 07 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103cba:	e8 f1 fb ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103cbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc5:	e8 96 07 00 00       	call   80104460 <popcli>
  if(!holding(&ptable.lock))
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 60 3d 11 80       	push   $0x80113d60
80103cd2:	e8 e9 07 00 00       	call   801044c0 <holding>
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	85 c0                	test   %eax,%eax
80103cdc:	74 4f                	je     80103d2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cde:	e8 cd fb ff ff       	call   801038b0 <mycpu>
80103ce3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cea:	75 68                	jne    80103d54 <sched+0xa4>
  if(p->state == RUNNING)
80103cec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cf0:	74 55                	je     80103d47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cf2:	9c                   	pushf  
80103cf3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cf4:	f6 c4 02             	test   $0x2,%ah
80103cf7:	75 41                	jne    80103d3a <sched+0x8a>
  intena = mycpu()->intena;
80103cf9:	e8 b2 fb ff ff       	call   801038b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cfe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d07:	e8 a4 fb ff ff       	call   801038b0 <mycpu>
80103d0c:	83 ec 08             	sub    $0x8,%esp
80103d0f:	ff 70 04             	pushl  0x4(%eax)
80103d12:	53                   	push   %ebx
80103d13:	e8 23 0b 00 00       	call   8010483b <swtch>
  mycpu()->intena = intena;
80103d18:	e8 93 fb ff ff       	call   801038b0 <mycpu>
}
80103d1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d29:	5b                   	pop    %ebx
80103d2a:	5e                   	pop    %esi
80103d2b:	5d                   	pop    %ebp
80103d2c:	c3                   	ret    
    panic("sched ptable.lock");
80103d2d:	83 ec 0c             	sub    $0xc,%esp
80103d30:	68 d0 7f 10 80       	push   $0x80107fd0
80103d35:	e8 56 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 fc 7f 10 80       	push   $0x80107ffc
80103d42:	e8 49 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d47:	83 ec 0c             	sub    $0xc,%esp
80103d4a:	68 ee 7f 10 80       	push   $0x80107fee
80103d4f:	e8 3c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	68 e2 7f 10 80       	push   $0x80107fe2
80103d5c:	e8 2f c6 ff ff       	call   80100390 <panic>
80103d61:	eb 0d                	jmp    80103d70 <exit>
80103d63:	90                   	nop
80103d64:	90                   	nop
80103d65:	90                   	nop
80103d66:	90                   	nop
80103d67:	90                   	nop
80103d68:	90                   	nop
80103d69:	90                   	nop
80103d6a:	90                   	nop
80103d6b:	90                   	nop
80103d6c:	90                   	nop
80103d6d:	90                   	nop
80103d6e:	90                   	nop
80103d6f:	90                   	nop

80103d70 <exit>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d79:	e8 a2 06 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103d7e:	e8 2d fb ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103d83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d89:	e8 d2 06 00 00       	call   80104460 <popcli>
  if(curproc == initproc)
80103d8e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103d94:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d97:	8d 7e 68             	lea    0x68(%esi),%edi
80103d9a:	0f 84 f1 00 00 00    	je     80103e91 <exit+0x121>
    if(curproc->ofile[fd]){
80103da0:	8b 03                	mov    (%ebx),%eax
80103da2:	85 c0                	test   %eax,%eax
80103da4:	74 12                	je     80103db8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	50                   	push   %eax
80103daa:	e8 91 d0 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103daf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103db5:	83 c4 10             	add    $0x10,%esp
80103db8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103dbb:	39 fb                	cmp    %edi,%ebx
80103dbd:	75 e1                	jne    80103da0 <exit+0x30>
  begin_op();
80103dbf:	e8 3c ef ff ff       	call   80102d00 <begin_op>
  iput(curproc->cwd);
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	ff 76 68             	pushl  0x68(%esi)
80103dca:	e8 f1 d9 ff ff       	call   801017c0 <iput>
  end_op();
80103dcf:	e8 9c ef ff ff       	call   80102d70 <end_op>
  curproc->cwd = 0;
80103dd4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103ddb:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103de2:	e8 09 07 00 00       	call   801044f0 <acquire>
  wakeup1(curproc->parent);
80103de7:	8b 56 14             	mov    0x14(%esi),%edx
80103dea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ded:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80103df2:	eb 0e                	jmp    80103e02 <exit+0x92>
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df8:	83 c0 7c             	add    $0x7c,%eax
80103dfb:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
80103e00:	73 1c                	jae    80103e1e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103e02:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e06:	75 f0                	jne    80103df8 <exit+0x88>
80103e08:	3b 50 20             	cmp    0x20(%eax),%edx
80103e0b:	75 eb                	jne    80103df8 <exit+0x88>
      p->state = RUNNABLE;
80103e0d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e14:	83 c0 7c             	add    $0x7c,%eax
80103e17:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
80103e1c:	72 e4                	jb     80103e02 <exit+0x92>
      p->parent = initproc;
80103e1e:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e24:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
80103e29:	eb 10                	jmp    80103e3b <exit+0xcb>
80103e2b:	90                   	nop
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e30:	83 c2 7c             	add    $0x7c,%edx
80103e33:	81 fa 94 5c 11 80    	cmp    $0x80115c94,%edx
80103e39:	73 33                	jae    80103e6e <exit+0xfe>
    if(p->parent == curproc){
80103e3b:	39 72 14             	cmp    %esi,0x14(%edx)
80103e3e:	75 f0                	jne    80103e30 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e40:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e44:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e47:	75 e7                	jne    80103e30 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e49:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80103e4e:	eb 0a                	jmp    80103e5a <exit+0xea>
80103e50:	83 c0 7c             	add    $0x7c,%eax
80103e53:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
80103e58:	73 d6                	jae    80103e30 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e5e:	75 f0                	jne    80103e50 <exit+0xe0>
80103e60:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e63:	75 eb                	jne    80103e50 <exit+0xe0>
      p->state = RUNNABLE;
80103e65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e6c:	eb e2                	jmp    80103e50 <exit+0xe0>
  procfs_remove_proc(curproc->pid);
80103e6e:	83 ec 0c             	sub    $0xc,%esp
  curproc->state = ZOMBIE;
80103e71:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  procfs_remove_proc(curproc->pid);
80103e78:	ff 76 10             	pushl  0x10(%esi)
80103e7b:	e8 d0 33 00 00       	call   80107250 <procfs_remove_proc>
  sched();
80103e80:	e8 2b fe ff ff       	call   80103cb0 <sched>
  panic("zombie exit");
80103e85:	c7 04 24 1d 80 10 80 	movl   $0x8010801d,(%esp)
80103e8c:	e8 ff c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e91:	83 ec 0c             	sub    $0xc,%esp
80103e94:	68 10 80 10 80       	push   $0x80108010
80103e99:	e8 f2 c4 ff ff       	call   80100390 <panic>
80103e9e:	66 90                	xchg   %ax,%ax

80103ea0 <yield>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ea7:	68 60 3d 11 80       	push   $0x80113d60
80103eac:	e8 3f 06 00 00       	call   801044f0 <acquire>
  pushcli();
80103eb1:	e8 6a 05 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103eb6:	e8 f5 f9 ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103ebb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec1:	e8 9a 05 00 00       	call   80104460 <popcli>
  myproc()->state = RUNNABLE;
80103ec6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ecd:	e8 de fd ff ff       	call   80103cb0 <sched>
  release(&ptable.lock);
80103ed2:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103ed9:	e8 d2 06 00 00       	call   801045b0 <release>
}
80103ede:	83 c4 10             	add    $0x10,%esp
80103ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee4:	c9                   	leave  
80103ee5:	c3                   	ret    
80103ee6:	8d 76 00             	lea    0x0(%esi),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <sleep>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
80103ef9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103efc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103eff:	e8 1c 05 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103f04:	e8 a7 f9 ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103f09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f0f:	e8 4c 05 00 00       	call   80104460 <popcli>
  if(p == 0)
80103f14:	85 db                	test   %ebx,%ebx
80103f16:	0f 84 87 00 00 00    	je     80103fa3 <sleep+0xb3>
  if(lk == 0)
80103f1c:	85 f6                	test   %esi,%esi
80103f1e:	74 76                	je     80103f96 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f20:	81 fe 60 3d 11 80    	cmp    $0x80113d60,%esi
80103f26:	74 50                	je     80103f78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	68 60 3d 11 80       	push   $0x80113d60
80103f30:	e8 bb 05 00 00       	call   801044f0 <acquire>
    release(lk);
80103f35:	89 34 24             	mov    %esi,(%esp)
80103f38:	e8 73 06 00 00       	call   801045b0 <release>
  p->chan = chan;
80103f3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f47:	e8 64 fd ff ff       	call   80103cb0 <sched>
  p->chan = 0;
80103f4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f53:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103f5a:	e8 51 06 00 00       	call   801045b0 <release>
    acquire(lk);
80103f5f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f62:	83 c4 10             	add    $0x10,%esp
}
80103f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f68:	5b                   	pop    %ebx
80103f69:	5e                   	pop    %esi
80103f6a:	5f                   	pop    %edi
80103f6b:	5d                   	pop    %ebp
    acquire(lk);
80103f6c:	e9 7f 05 00 00       	jmp    801044f0 <acquire>
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f82:	e8 29 fd ff ff       	call   80103cb0 <sched>
  p->chan = 0;
80103f87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f91:	5b                   	pop    %ebx
80103f92:	5e                   	pop    %esi
80103f93:	5f                   	pop    %edi
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    
    panic("sleep without lk");
80103f96:	83 ec 0c             	sub    $0xc,%esp
80103f99:	68 2f 80 10 80       	push   $0x8010802f
80103f9e:	e8 ed c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103fa3:	83 ec 0c             	sub    $0xc,%esp
80103fa6:	68 29 80 10 80       	push   $0x80108029
80103fab:	e8 e0 c3 ff ff       	call   80100390 <panic>

80103fb0 <wait>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
  pushcli();
80103fb5:	e8 66 04 00 00       	call   80104420 <pushcli>
  c = mycpu();
80103fba:	e8 f1 f8 ff ff       	call   801038b0 <mycpu>
  p = c->proc;
80103fbf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fc5:	e8 96 04 00 00       	call   80104460 <popcli>
  acquire(&ptable.lock);
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 60 3d 11 80       	push   $0x80113d60
80103fd2:	e8 19 05 00 00       	call   801044f0 <acquire>
80103fd7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fdc:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
80103fe1:	eb 10                	jmp    80103ff3 <wait+0x43>
80103fe3:	90                   	nop
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe8:	83 c3 7c             	add    $0x7c,%ebx
80103feb:	81 fb 94 5c 11 80    	cmp    $0x80115c94,%ebx
80103ff1:	73 1b                	jae    8010400e <wait+0x5e>
      if(p->parent != curproc)
80103ff3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ff6:	75 f0                	jne    80103fe8 <wait+0x38>
      if(p->state == ZOMBIE){
80103ff8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ffc:	74 32                	je     80104030 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104001:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104006:	81 fb 94 5c 11 80    	cmp    $0x80115c94,%ebx
8010400c:	72 e5                	jb     80103ff3 <wait+0x43>
    if(!havekids || curproc->killed){
8010400e:	85 c0                	test   %eax,%eax
80104010:	74 74                	je     80104086 <wait+0xd6>
80104012:	8b 46 24             	mov    0x24(%esi),%eax
80104015:	85 c0                	test   %eax,%eax
80104017:	75 6d                	jne    80104086 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104019:	83 ec 08             	sub    $0x8,%esp
8010401c:	68 60 3d 11 80       	push   $0x80113d60
80104021:	56                   	push   %esi
80104022:	e8 c9 fe ff ff       	call   80103ef0 <sleep>
    havekids = 0;
80104027:	83 c4 10             	add    $0x10,%esp
8010402a:	eb ae                	jmp    80103fda <wait+0x2a>
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104036:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104039:	e8 32 e4 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
8010403e:	5a                   	pop    %edx
8010403f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104042:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104049:	e8 f2 2c 00 00       	call   80106d40 <freevm>
        release(&ptable.lock);
8010404e:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
        p->pid = 0;
80104055:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010405c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104063:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104067:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010406e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104075:	e8 36 05 00 00       	call   801045b0 <release>
        return pid;
8010407a:	83 c4 10             	add    $0x10,%esp
}
8010407d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104080:	89 f0                	mov    %esi,%eax
80104082:	5b                   	pop    %ebx
80104083:	5e                   	pop    %esi
80104084:	5d                   	pop    %ebp
80104085:	c3                   	ret    
      release(&ptable.lock);
80104086:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104089:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010408e:	68 60 3d 11 80       	push   $0x80113d60
80104093:	e8 18 05 00 00       	call   801045b0 <release>
      return -1;
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	eb e0                	jmp    8010407d <wait+0xcd>
8010409d:	8d 76 00             	lea    0x0(%esi),%esi

801040a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040aa:	68 60 3d 11 80       	push   $0x80113d60
801040af:	e8 3c 04 00 00       	call   801044f0 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b7:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
801040bc:	eb 0c                	jmp    801040ca <wakeup+0x2a>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	83 c0 7c             	add    $0x7c,%eax
801040c3:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
801040c8:	73 1c                	jae    801040e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801040ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ce:	75 f0                	jne    801040c0 <wakeup+0x20>
801040d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801040d3:	75 eb                	jne    801040c0 <wakeup+0x20>
      p->state = RUNNABLE;
801040d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dc:	83 c0 7c             	add    $0x7c,%eax
801040df:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
801040e4:	72 e4                	jb     801040ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801040e6:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
801040ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f0:	c9                   	leave  
  release(&ptable.lock);
801040f1:	e9 ba 04 00 00       	jmp    801045b0 <release>
801040f6:	8d 76 00             	lea    0x0(%esi),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010410a:	68 60 3d 11 80       	push   $0x80113d60
8010410f:	e8 dc 03 00 00       	call   801044f0 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104117:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
8010411c:	eb 0c                	jmp    8010412a <kill+0x2a>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	83 c0 7c             	add    $0x7c,%eax
80104123:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
80104128:	73 36                	jae    80104160 <kill+0x60>
    if(p->pid == pid){
8010412a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010412d:	75 f1                	jne    80104120 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010412f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104133:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010413a:	75 07                	jne    80104143 <kill+0x43>
        p->state = RUNNABLE;
8010413c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 60 3d 11 80       	push   $0x80113d60
8010414b:	e8 60 04 00 00       	call   801045b0 <release>
      return 0;
80104150:	83 c4 10             	add    $0x10,%esp
80104153:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104158:	c9                   	leave  
80104159:	c3                   	ret    
8010415a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104160:	83 ec 0c             	sub    $0xc,%esp
80104163:	68 60 3d 11 80       	push   $0x80113d60
80104168:	e8 43 04 00 00       	call   801045b0 <release>
  return -1;
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104178:	c9                   	leave  
80104179:	c3                   	ret    
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104180 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104189:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
8010418e:	83 ec 3c             	sub    $0x3c,%esp
80104191:	eb 24                	jmp    801041b7 <procdump+0x37>
80104193:	90                   	nop
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 b7 83 10 80       	push   $0x801083b7
801041a0:	e8 bb c4 ff ff       	call   80100660 <cprintf>
801041a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a8:	83 c3 7c             	add    $0x7c,%ebx
801041ab:	81 fb 94 5c 11 80    	cmp    $0x80115c94,%ebx
801041b1:	0f 83 81 00 00 00    	jae    80104238 <procdump+0xb8>
    if(p->state == UNUSED)
801041b7:	8b 43 0c             	mov    0xc(%ebx),%eax
801041ba:	85 c0                	test   %eax,%eax
801041bc:	74 ea                	je     801041a8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041be:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801041c1:	ba 40 80 10 80       	mov    $0x80108040,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041c6:	77 11                	ja     801041d9 <procdump+0x59>
801041c8:	8b 14 85 b0 80 10 80 	mov    -0x7fef7f50(,%eax,4),%edx
      state = "???";
801041cf:	b8 40 80 10 80       	mov    $0x80108040,%eax
801041d4:	85 d2                	test   %edx,%edx
801041d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041d9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041dc:	50                   	push   %eax
801041dd:	52                   	push   %edx
801041de:	ff 73 10             	pushl  0x10(%ebx)
801041e1:	68 44 80 10 80       	push   $0x80108044
801041e6:	e8 75 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801041eb:	83 c4 10             	add    $0x10,%esp
801041ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801041f2:	75 a4                	jne    80104198 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041f7:	83 ec 08             	sub    $0x8,%esp
801041fa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041fd:	50                   	push   %eax
801041fe:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104201:	8b 40 0c             	mov    0xc(%eax),%eax
80104204:	83 c0 08             	add    $0x8,%eax
80104207:	50                   	push   %eax
80104208:	e8 c3 01 00 00       	call   801043d0 <getcallerpcs>
8010420d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104210:	8b 17                	mov    (%edi),%edx
80104212:	85 d2                	test   %edx,%edx
80104214:	74 82                	je     80104198 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104216:	83 ec 08             	sub    $0x8,%esp
80104219:	83 c7 04             	add    $0x4,%edi
8010421c:	52                   	push   %edx
8010421d:	68 81 7a 10 80       	push   $0x80107a81
80104222:	e8 39 c4 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104227:	83 c4 10             	add    $0x10,%esp
8010422a:	39 fe                	cmp    %edi,%esi
8010422c:	75 e2                	jne    80104210 <procdump+0x90>
8010422e:	e9 65 ff ff ff       	jmp    80104198 <procdump+0x18>
80104233:	90                   	nop
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010423b:	5b                   	pop    %ebx
8010423c:	5e                   	pop    %esi
8010423d:	5f                   	pop    %edi
8010423e:	5d                   	pop    %ebp
8010423f:	c3                   	ret    

80104240 <find_proc_by_pid>:

struct proc* find_proc_by_pid(int pid) {
80104240:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104241:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
struct proc* find_proc_by_pid(int pid) {
80104246:	89 e5                	mov    %esp,%ebp
80104248:	83 ec 08             	sub    $0x8,%esp
8010424b:	8b 55 08             	mov    0x8(%ebp),%edx
8010424e:	eb 0a                	jmp    8010425a <find_proc_by_pid+0x1a>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104250:	83 c0 7c             	add    $0x7c,%eax
80104253:	3d 94 5c 11 80       	cmp    $0x80115c94,%eax
80104258:	73 0e                	jae    80104268 <find_proc_by_pid+0x28>
    if (p->pid == pid)
8010425a:	39 50 10             	cmp    %edx,0x10(%eax)
8010425d:	75 f1                	jne    80104250 <find_proc_by_pid+0x10>
      return p;
  }
  panic("didn't find pid");
}
8010425f:	c9                   	leave  
80104260:	c3                   	ret    
80104261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  panic("didn't find pid");
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 4d 80 10 80       	push   $0x8010804d
80104270:	e8 1b c1 ff ff       	call   80100390 <panic>
80104275:	66 90                	xchg   %ax,%ax
80104277:	66 90                	xchg   %ax,%ax
80104279:	66 90                	xchg   %ax,%ax
8010427b:	66 90                	xchg   %ax,%ax
8010427d:	66 90                	xchg   %ax,%ax
8010427f:	90                   	nop

80104280 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 0c             	sub    $0xc,%esp
80104287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010428a:	68 c8 80 10 80       	push   $0x801080c8
8010428f:	8d 43 04             	lea    0x4(%ebx),%eax
80104292:	50                   	push   %eax
80104293:	e8 18 01 00 00       	call   801043b0 <initlock>
  lk->name = name;
80104298:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010429b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b1:	c9                   	leave  
801042b2:	c3                   	ret    
801042b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	8d 73 04             	lea    0x4(%ebx),%esi
801042ce:	56                   	push   %esi
801042cf:	e8 1c 02 00 00       	call   801044f0 <acquire>
  while (lk->locked) {
801042d4:	8b 13                	mov    (%ebx),%edx
801042d6:	83 c4 10             	add    $0x10,%esp
801042d9:	85 d2                	test   %edx,%edx
801042db:	74 16                	je     801042f3 <acquiresleep+0x33>
801042dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801042e0:	83 ec 08             	sub    $0x8,%esp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
801042e5:	e8 06 fc ff ff       	call   80103ef0 <sleep>
  while (lk->locked) {
801042ea:	8b 03                	mov    (%ebx),%eax
801042ec:	83 c4 10             	add    $0x10,%esp
801042ef:	85 c0                	test   %eax,%eax
801042f1:	75 ed                	jne    801042e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801042f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042f9:	e8 52 f6 ff ff       	call   80103950 <myproc>
801042fe:	8b 40 10             	mov    0x10(%eax),%eax
80104301:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104304:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104307:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010430a:	5b                   	pop    %ebx
8010430b:	5e                   	pop    %esi
8010430c:	5d                   	pop    %ebp
  release(&lk->lk);
8010430d:	e9 9e 02 00 00       	jmp    801045b0 <release>
80104312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104320 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	8d 73 04             	lea    0x4(%ebx),%esi
8010432e:	56                   	push   %esi
8010432f:	e8 bc 01 00 00       	call   801044f0 <acquire>
  lk->locked = 0;
80104334:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010433a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104341:	89 1c 24             	mov    %ebx,(%esp)
80104344:	e8 57 fd ff ff       	call   801040a0 <wakeup>
  release(&lk->lk);
80104349:	89 75 08             	mov    %esi,0x8(%ebp)
8010434c:	83 c4 10             	add    $0x10,%esp
}
8010434f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5d                   	pop    %ebp
  release(&lk->lk);
80104355:	e9 56 02 00 00       	jmp    801045b0 <release>
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104360 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	57                   	push   %edi
80104364:	56                   	push   %esi
80104365:	53                   	push   %ebx
80104366:	31 ff                	xor    %edi,%edi
80104368:	83 ec 18             	sub    $0x18,%esp
8010436b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010436e:	8d 73 04             	lea    0x4(%ebx),%esi
80104371:	56                   	push   %esi
80104372:	e8 79 01 00 00       	call   801044f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104377:	8b 03                	mov    (%ebx),%eax
80104379:	83 c4 10             	add    $0x10,%esp
8010437c:	85 c0                	test   %eax,%eax
8010437e:	74 13                	je     80104393 <holdingsleep+0x33>
80104380:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104383:	e8 c8 f5 ff ff       	call   80103950 <myproc>
80104388:	39 58 10             	cmp    %ebx,0x10(%eax)
8010438b:	0f 94 c0             	sete   %al
8010438e:	0f b6 c0             	movzbl %al,%eax
80104391:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104393:	83 ec 0c             	sub    $0xc,%esp
80104396:	56                   	push   %esi
80104397:	e8 14 02 00 00       	call   801045b0 <release>
  return r;
}
8010439c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010439f:	89 f8                	mov    %edi,%eax
801043a1:	5b                   	pop    %ebx
801043a2:	5e                   	pop    %esi
801043a3:	5f                   	pop    %edi
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    
801043a6:	66 90                	xchg   %ax,%ax
801043a8:	66 90                	xchg   %ax,%ax
801043aa:	66 90                	xchg   %ax,%ax
801043ac:	66 90                	xchg   %ax,%ax
801043ae:	66 90                	xchg   %ax,%ax

801043b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	90                   	nop
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043d1:	31 d2                	xor    %edx,%edx
{
801043d3:	89 e5                	mov    %esp,%ebp
801043d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043dc:	83 e8 08             	sub    $0x8,%eax
801043df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043ec:	77 1a                	ja     80104408 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043ee:	8b 58 04             	mov    0x4(%eax),%ebx
801043f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043f9:	83 fa 0a             	cmp    $0xa,%edx
801043fc:	75 e2                	jne    801043e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043fe:	5b                   	pop    %ebx
801043ff:	5d                   	pop    %ebp
80104400:	c3                   	ret    
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104408:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010440b:	83 c1 28             	add    $0x28,%ecx
8010440e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104416:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104419:	39 c1                	cmp    %eax,%ecx
8010441b:	75 f3                	jne    80104410 <getcallerpcs+0x40>
}
8010441d:	5b                   	pop    %ebx
8010441e:	5d                   	pop    %ebp
8010441f:	c3                   	ret    

80104420 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 04             	sub    $0x4,%esp
80104427:	9c                   	pushf  
80104428:	5b                   	pop    %ebx
  asm volatile("cli");
80104429:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010442a:	e8 81 f4 ff ff       	call   801038b0 <mycpu>
8010442f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104435:	85 c0                	test   %eax,%eax
80104437:	75 11                	jne    8010444a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104439:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010443f:	e8 6c f4 ff ff       	call   801038b0 <mycpu>
80104444:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010444a:	e8 61 f4 ff ff       	call   801038b0 <mycpu>
8010444f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104456:	83 c4 04             	add    $0x4,%esp
80104459:	5b                   	pop    %ebx
8010445a:	5d                   	pop    %ebp
8010445b:	c3                   	ret    
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <popcli>:

void
popcli(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104466:	9c                   	pushf  
80104467:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104468:	f6 c4 02             	test   $0x2,%ah
8010446b:	75 35                	jne    801044a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010446d:	e8 3e f4 ff ff       	call   801038b0 <mycpu>
80104472:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104479:	78 34                	js     801044af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010447b:	e8 30 f4 ff ff       	call   801038b0 <mycpu>
80104480:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104486:	85 d2                	test   %edx,%edx
80104488:	74 06                	je     80104490 <popcli+0x30>
    sti();
}
8010448a:	c9                   	leave  
8010448b:	c3                   	ret    
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104490:	e8 1b f4 ff ff       	call   801038b0 <mycpu>
80104495:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010449b:	85 c0                	test   %eax,%eax
8010449d:	74 eb                	je     8010448a <popcli+0x2a>
  asm volatile("sti");
8010449f:	fb                   	sti    
}
801044a0:	c9                   	leave  
801044a1:	c3                   	ret    
    panic("popcli - interruptible");
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	68 d3 80 10 80       	push   $0x801080d3
801044aa:	e8 e1 be ff ff       	call   80100390 <panic>
    panic("popcli");
801044af:	83 ec 0c             	sub    $0xc,%esp
801044b2:	68 ea 80 10 80       	push   $0x801080ea
801044b7:	e8 d4 be ff ff       	call   80100390 <panic>
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <holding>:
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	56                   	push   %esi
801044c4:	53                   	push   %ebx
801044c5:	8b 75 08             	mov    0x8(%ebp),%esi
801044c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801044ca:	e8 51 ff ff ff       	call   80104420 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801044cf:	8b 06                	mov    (%esi),%eax
801044d1:	85 c0                	test   %eax,%eax
801044d3:	74 10                	je     801044e5 <holding+0x25>
801044d5:	8b 5e 08             	mov    0x8(%esi),%ebx
801044d8:	e8 d3 f3 ff ff       	call   801038b0 <mycpu>
801044dd:	39 c3                	cmp    %eax,%ebx
801044df:	0f 94 c3             	sete   %bl
801044e2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801044e5:	e8 76 ff ff ff       	call   80104460 <popcli>
}
801044ea:	89 d8                	mov    %ebx,%eax
801044ec:	5b                   	pop    %ebx
801044ed:	5e                   	pop    %esi
801044ee:	5d                   	pop    %ebp
801044ef:	c3                   	ret    

801044f0 <acquire>:
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044f5:	e8 26 ff ff ff       	call   80104420 <pushcli>
  if(holding(lk))
801044fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044fd:	83 ec 0c             	sub    $0xc,%esp
80104500:	53                   	push   %ebx
80104501:	e8 ba ff ff ff       	call   801044c0 <holding>
80104506:	83 c4 10             	add    $0x10,%esp
80104509:	85 c0                	test   %eax,%eax
8010450b:	0f 85 83 00 00 00    	jne    80104594 <acquire+0xa4>
80104511:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104513:	ba 01 00 00 00       	mov    $0x1,%edx
80104518:	eb 09                	jmp    80104523 <acquire+0x33>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104520:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104523:	89 d0                	mov    %edx,%eax
80104525:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104528:	85 c0                	test   %eax,%eax
8010452a:	75 f4                	jne    80104520 <acquire+0x30>
  __sync_synchronize();
8010452c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104531:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104534:	e8 77 f3 ff ff       	call   801038b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104539:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010453c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010453f:	89 e8                	mov    %ebp,%eax
80104541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104548:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010454e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104554:	77 1a                	ja     80104570 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104556:	8b 48 04             	mov    0x4(%eax),%ecx
80104559:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010455c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010455f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104561:	83 fe 0a             	cmp    $0xa,%esi
80104564:	75 e2                	jne    80104548 <acquire+0x58>
}
80104566:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104569:	5b                   	pop    %ebx
8010456a:	5e                   	pop    %esi
8010456b:	5d                   	pop    %ebp
8010456c:	c3                   	ret    
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
80104570:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104573:	83 c2 28             	add    $0x28,%edx
80104576:	8d 76 00             	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104586:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104589:	39 d0                	cmp    %edx,%eax
8010458b:	75 f3                	jne    80104580 <acquire+0x90>
}
8010458d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104590:	5b                   	pop    %ebx
80104591:	5e                   	pop    %esi
80104592:	5d                   	pop    %ebp
80104593:	c3                   	ret    
    panic("acquire");
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	68 f1 80 10 80       	push   $0x801080f1
8010459c:	e8 ef bd ff ff       	call   80100390 <panic>
801045a1:	eb 0d                	jmp    801045b0 <release>
801045a3:	90                   	nop
801045a4:	90                   	nop
801045a5:	90                   	nop
801045a6:	90                   	nop
801045a7:	90                   	nop
801045a8:	90                   	nop
801045a9:	90                   	nop
801045aa:	90                   	nop
801045ab:	90                   	nop
801045ac:	90                   	nop
801045ad:	90                   	nop
801045ae:	90                   	nop
801045af:	90                   	nop

801045b0 <release>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 10             	sub    $0x10,%esp
801045b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801045ba:	53                   	push   %ebx
801045bb:	e8 00 ff ff ff       	call   801044c0 <holding>
801045c0:	83 c4 10             	add    $0x10,%esp
801045c3:	85 c0                	test   %eax,%eax
801045c5:	74 22                	je     801045e9 <release+0x39>
  lk->pcs[0] = 0;
801045c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045d5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e3:	c9                   	leave  
  popcli();
801045e4:	e9 77 fe ff ff       	jmp    80104460 <popcli>
    panic("release");
801045e9:	83 ec 0c             	sub    $0xc,%esp
801045ec:	68 f9 80 10 80       	push   $0x801080f9
801045f1:	e8 9a bd ff ff       	call   80100390 <panic>
801045f6:	66 90                	xchg   %ax,%ax
801045f8:	66 90                	xchg   %ax,%ax
801045fa:	66 90                	xchg   %ax,%ax
801045fc:	66 90                	xchg   %ax,%ax
801045fe:	66 90                	xchg   %ax,%ax

80104600 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	53                   	push   %ebx
80104605:	8b 55 08             	mov    0x8(%ebp),%edx
80104608:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010460b:	f6 c2 03             	test   $0x3,%dl
8010460e:	75 05                	jne    80104615 <memset+0x15>
80104610:	f6 c1 03             	test   $0x3,%cl
80104613:	74 13                	je     80104628 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104615:	89 d7                	mov    %edx,%edi
80104617:	8b 45 0c             	mov    0xc(%ebp),%eax
8010461a:	fc                   	cld    
8010461b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010461d:	5b                   	pop    %ebx
8010461e:	89 d0                	mov    %edx,%eax
80104620:	5f                   	pop    %edi
80104621:	5d                   	pop    %ebp
80104622:	c3                   	ret    
80104623:	90                   	nop
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104628:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010462c:	c1 e9 02             	shr    $0x2,%ecx
8010462f:	89 f8                	mov    %edi,%eax
80104631:	89 fb                	mov    %edi,%ebx
80104633:	c1 e0 18             	shl    $0x18,%eax
80104636:	c1 e3 10             	shl    $0x10,%ebx
80104639:	09 d8                	or     %ebx,%eax
8010463b:	09 f8                	or     %edi,%eax
8010463d:	c1 e7 08             	shl    $0x8,%edi
80104640:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104642:	89 d7                	mov    %edx,%edi
80104644:	fc                   	cld    
80104645:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104647:	5b                   	pop    %ebx
80104648:	89 d0                	mov    %edx,%eax
8010464a:	5f                   	pop    %edi
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    
8010464d:	8d 76 00             	lea    0x0(%esi),%esi

80104650 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	53                   	push   %ebx
80104656:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104659:	8b 75 08             	mov    0x8(%ebp),%esi
8010465c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010465f:	85 db                	test   %ebx,%ebx
80104661:	74 29                	je     8010468c <memcmp+0x3c>
    if(*s1 != *s2)
80104663:	0f b6 16             	movzbl (%esi),%edx
80104666:	0f b6 0f             	movzbl (%edi),%ecx
80104669:	38 d1                	cmp    %dl,%cl
8010466b:	75 2b                	jne    80104698 <memcmp+0x48>
8010466d:	b8 01 00 00 00       	mov    $0x1,%eax
80104672:	eb 14                	jmp    80104688 <memcmp+0x38>
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104678:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010467c:	83 c0 01             	add    $0x1,%eax
8010467f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104684:	38 ca                	cmp    %cl,%dl
80104686:	75 10                	jne    80104698 <memcmp+0x48>
  while(n-- > 0){
80104688:	39 d8                	cmp    %ebx,%eax
8010468a:	75 ec                	jne    80104678 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010468c:	5b                   	pop    %ebx
  return 0;
8010468d:	31 c0                	xor    %eax,%eax
}
8010468f:	5e                   	pop    %esi
80104690:	5f                   	pop    %edi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104698:	0f b6 c2             	movzbl %dl,%eax
}
8010469b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010469c:	29 c8                	sub    %ecx,%eax
}
8010469e:	5e                   	pop    %esi
8010469f:	5f                   	pop    %edi
801046a0:	5d                   	pop    %ebp
801046a1:	c3                   	ret    
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 45 08             	mov    0x8(%ebp),%eax
801046b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801046bb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046be:	39 c3                	cmp    %eax,%ebx
801046c0:	73 26                	jae    801046e8 <memmove+0x38>
801046c2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801046c5:	39 c8                	cmp    %ecx,%eax
801046c7:	73 1f                	jae    801046e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801046c9:	85 f6                	test   %esi,%esi
801046cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801046ce:	74 0f                	je     801046df <memmove+0x2f>
      *--d = *--s;
801046d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801046d7:	83 ea 01             	sub    $0x1,%edx
801046da:	83 fa ff             	cmp    $0xffffffff,%edx
801046dd:	75 f1                	jne    801046d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046df:	5b                   	pop    %ebx
801046e0:	5e                   	pop    %esi
801046e1:	5d                   	pop    %ebp
801046e2:	c3                   	ret    
801046e3:	90                   	nop
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801046e8:	31 d2                	xor    %edx,%edx
801046ea:	85 f6                	test   %esi,%esi
801046ec:	74 f1                	je     801046df <memmove+0x2f>
801046ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801046f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801046f7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801046fa:	39 d6                	cmp    %edx,%esi
801046fc:	75 f2                	jne    801046f0 <memmove+0x40>
}
801046fe:	5b                   	pop    %ebx
801046ff:	5e                   	pop    %esi
80104700:	5d                   	pop    %ebp
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104713:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104714:	eb 9a                	jmp    801046b0 <memmove>
80104716:	8d 76 00             	lea    0x0(%esi),%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	56                   	push   %esi
80104725:	8b 7d 10             	mov    0x10(%ebp),%edi
80104728:	53                   	push   %ebx
80104729:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010472c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010472f:	85 ff                	test   %edi,%edi
80104731:	74 2f                	je     80104762 <strncmp+0x42>
80104733:	0f b6 01             	movzbl (%ecx),%eax
80104736:	0f b6 1e             	movzbl (%esi),%ebx
80104739:	84 c0                	test   %al,%al
8010473b:	74 37                	je     80104774 <strncmp+0x54>
8010473d:	38 c3                	cmp    %al,%bl
8010473f:	75 33                	jne    80104774 <strncmp+0x54>
80104741:	01 f7                	add    %esi,%edi
80104743:	eb 13                	jmp    80104758 <strncmp+0x38>
80104745:	8d 76 00             	lea    0x0(%esi),%esi
80104748:	0f b6 01             	movzbl (%ecx),%eax
8010474b:	84 c0                	test   %al,%al
8010474d:	74 21                	je     80104770 <strncmp+0x50>
8010474f:	0f b6 1a             	movzbl (%edx),%ebx
80104752:	89 d6                	mov    %edx,%esi
80104754:	38 d8                	cmp    %bl,%al
80104756:	75 1c                	jne    80104774 <strncmp+0x54>
    n--, p++, q++;
80104758:	8d 56 01             	lea    0x1(%esi),%edx
8010475b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010475e:	39 fa                	cmp    %edi,%edx
80104760:	75 e6                	jne    80104748 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104762:	5b                   	pop    %ebx
    return 0;
80104763:	31 c0                	xor    %eax,%eax
}
80104765:	5e                   	pop    %esi
80104766:	5f                   	pop    %edi
80104767:	5d                   	pop    %ebp
80104768:	c3                   	ret    
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104770:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104774:	29 d8                	sub    %ebx,%eax
}
80104776:	5b                   	pop    %ebx
80104777:	5e                   	pop    %esi
80104778:	5f                   	pop    %edi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 45 08             	mov    0x8(%ebp),%eax
80104788:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010478b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010478e:	89 c2                	mov    %eax,%edx
80104790:	eb 19                	jmp    801047ab <strncpy+0x2b>
80104792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104798:	83 c3 01             	add    $0x1,%ebx
8010479b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010479f:	83 c2 01             	add    $0x1,%edx
801047a2:	84 c9                	test   %cl,%cl
801047a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801047a7:	74 09                	je     801047b2 <strncpy+0x32>
801047a9:	89 f1                	mov    %esi,%ecx
801047ab:	85 c9                	test   %ecx,%ecx
801047ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801047b0:	7f e6                	jg     80104798 <strncpy+0x18>
    ;
  while(n-- > 0)
801047b2:	31 c9                	xor    %ecx,%ecx
801047b4:	85 f6                	test   %esi,%esi
801047b6:	7e 17                	jle    801047cf <strncpy+0x4f>
801047b8:	90                   	nop
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801047c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801047c4:	89 f3                	mov    %esi,%ebx
801047c6:	83 c1 01             	add    $0x1,%ecx
801047c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801047cb:	85 db                	test   %ebx,%ebx
801047cd:	7f f1                	jg     801047c0 <strncpy+0x40>
  return os;
}
801047cf:	5b                   	pop    %ebx
801047d0:	5e                   	pop    %esi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret    
801047d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047e8:	8b 45 08             	mov    0x8(%ebp),%eax
801047eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047ee:	85 c9                	test   %ecx,%ecx
801047f0:	7e 26                	jle    80104818 <safestrcpy+0x38>
801047f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047f6:	89 c1                	mov    %eax,%ecx
801047f8:	eb 17                	jmp    80104811 <safestrcpy+0x31>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104800:	83 c2 01             	add    $0x1,%edx
80104803:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104807:	83 c1 01             	add    $0x1,%ecx
8010480a:	84 db                	test   %bl,%bl
8010480c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010480f:	74 04                	je     80104815 <safestrcpy+0x35>
80104811:	39 f2                	cmp    %esi,%edx
80104813:	75 eb                	jne    80104800 <safestrcpy+0x20>
    ;
  *s = 0;
80104815:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104818:	5b                   	pop    %ebx
80104819:	5e                   	pop    %esi
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret    
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104820 <strlen>:

int
strlen(const char *s)
{
80104820:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104821:	31 c0                	xor    %eax,%eax
{
80104823:	89 e5                	mov    %esp,%ebp
80104825:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104828:	80 3a 00             	cmpb   $0x0,(%edx)
8010482b:	74 0c                	je     80104839 <strlen+0x19>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
80104830:	83 c0 01             	add    $0x1,%eax
80104833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104837:	75 f7                	jne    80104830 <strlen+0x10>
    ;
  return n;
}
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    

8010483b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010483b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010483f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104843:	55                   	push   %ebp
  pushl %ebx
80104844:	53                   	push   %ebx
  pushl %esi
80104845:	56                   	push   %esi
  pushl %edi
80104846:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104847:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104849:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010484b:	5f                   	pop    %edi
  popl %esi
8010484c:	5e                   	pop    %esi
  popl %ebx
8010484d:	5b                   	pop    %ebx
  popl %ebp
8010484e:	5d                   	pop    %ebp
  ret
8010484f:	c3                   	ret    

80104850 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 04             	sub    $0x4,%esp
80104857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010485a:	e8 f1 f0 ff ff       	call   80103950 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010485f:	8b 00                	mov    (%eax),%eax
80104861:	39 d8                	cmp    %ebx,%eax
80104863:	76 1b                	jbe    80104880 <fetchint+0x30>
80104865:	8d 53 04             	lea    0x4(%ebx),%edx
80104868:	39 d0                	cmp    %edx,%eax
8010486a:	72 14                	jb     80104880 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010486c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486f:	8b 13                	mov    (%ebx),%edx
80104871:	89 10                	mov    %edx,(%eax)
  return 0;
80104873:	31 c0                	xor    %eax,%eax
}
80104875:	83 c4 04             	add    $0x4,%esp
80104878:	5b                   	pop    %ebx
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	90                   	nop
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104885:	eb ee                	jmp    80104875 <fetchint+0x25>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010489a:	e8 b1 f0 ff ff       	call   80103950 <myproc>

  if(addr >= curproc->sz)
8010489f:	39 18                	cmp    %ebx,(%eax)
801048a1:	76 29                	jbe    801048cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801048a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801048a6:	89 da                	mov    %ebx,%edx
801048a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801048aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801048ac:	39 c3                	cmp    %eax,%ebx
801048ae:	73 1c                	jae    801048cc <fetchstr+0x3c>
    if(*s == 0)
801048b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801048b3:	75 10                	jne    801048c5 <fetchstr+0x35>
801048b5:	eb 39                	jmp    801048f0 <fetchstr+0x60>
801048b7:	89 f6                	mov    %esi,%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048c0:	80 3a 00             	cmpb   $0x0,(%edx)
801048c3:	74 1b                	je     801048e0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801048c5:	83 c2 01             	add    $0x1,%edx
801048c8:	39 d0                	cmp    %edx,%eax
801048ca:	77 f4                	ja     801048c0 <fetchstr+0x30>
    return -1;
801048cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801048d1:	83 c4 04             	add    $0x4,%esp
801048d4:	5b                   	pop    %ebx
801048d5:	5d                   	pop    %ebp
801048d6:	c3                   	ret    
801048d7:	89 f6                	mov    %esi,%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048e0:	83 c4 04             	add    $0x4,%esp
801048e3:	89 d0                	mov    %edx,%eax
801048e5:	29 d8                	sub    %ebx,%eax
801048e7:	5b                   	pop    %ebx
801048e8:	5d                   	pop    %ebp
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801048f0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801048f2:	eb dd                	jmp    801048d1 <fetchstr+0x41>
801048f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104900 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104905:	e8 46 f0 ff ff       	call   80103950 <myproc>
8010490a:	8b 40 18             	mov    0x18(%eax),%eax
8010490d:	8b 55 08             	mov    0x8(%ebp),%edx
80104910:	8b 40 44             	mov    0x44(%eax),%eax
80104913:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104916:	e8 35 f0 ff ff       	call   80103950 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010491b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010491d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104920:	39 c6                	cmp    %eax,%esi
80104922:	73 1c                	jae    80104940 <argint+0x40>
80104924:	8d 53 08             	lea    0x8(%ebx),%edx
80104927:	39 d0                	cmp    %edx,%eax
80104929:	72 15                	jb     80104940 <argint+0x40>
  *ip = *(int*)(addr);
8010492b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010492e:	8b 53 04             	mov    0x4(%ebx),%edx
80104931:	89 10                	mov    %edx,(%eax)
  return 0;
80104933:	31 c0                	xor    %eax,%eax
}
80104935:	5b                   	pop    %ebx
80104936:	5e                   	pop    %esi
80104937:	5d                   	pop    %ebp
80104938:	c3                   	ret    
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104945:	eb ee                	jmp    80104935 <argint+0x35>
80104947:	89 f6                	mov    %esi,%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	83 ec 10             	sub    $0x10,%esp
80104958:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010495b:	e8 f0 ef ff ff       	call   80103950 <myproc>
80104960:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104962:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104965:	83 ec 08             	sub    $0x8,%esp
80104968:	50                   	push   %eax
80104969:	ff 75 08             	pushl  0x8(%ebp)
8010496c:	e8 8f ff ff ff       	call   80104900 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104971:	83 c4 10             	add    $0x10,%esp
80104974:	85 c0                	test   %eax,%eax
80104976:	78 28                	js     801049a0 <argptr+0x50>
80104978:	85 db                	test   %ebx,%ebx
8010497a:	78 24                	js     801049a0 <argptr+0x50>
8010497c:	8b 16                	mov    (%esi),%edx
8010497e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104981:	39 c2                	cmp    %eax,%edx
80104983:	76 1b                	jbe    801049a0 <argptr+0x50>
80104985:	01 c3                	add    %eax,%ebx
80104987:	39 da                	cmp    %ebx,%edx
80104989:	72 15                	jb     801049a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010498b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010498e:	89 02                	mov    %eax,(%edx)
  return 0;
80104990:	31 c0                	xor    %eax,%eax
}
80104992:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104995:	5b                   	pop    %ebx
80104996:	5e                   	pop    %esi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a5:	eb eb                	jmp    80104992 <argptr+0x42>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801049b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049b9:	50                   	push   %eax
801049ba:	ff 75 08             	pushl  0x8(%ebp)
801049bd:	e8 3e ff ff ff       	call   80104900 <argint>
801049c2:	83 c4 10             	add    $0x10,%esp
801049c5:	85 c0                	test   %eax,%eax
801049c7:	78 17                	js     801049e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801049c9:	83 ec 08             	sub    $0x8,%esp
801049cc:	ff 75 0c             	pushl  0xc(%ebp)
801049cf:	ff 75 f4             	pushl  -0xc(%ebp)
801049d2:	e8 b9 fe ff ff       	call   80104890 <fetchstr>
801049d7:	83 c4 10             	add    $0x10,%esp
}
801049da:	c9                   	leave  
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e5:	c9                   	leave  
801049e6:	c3                   	ret    
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049f7:	e8 54 ef ff ff       	call   80103950 <myproc>
801049fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049fe:	8b 40 18             	mov    0x18(%eax),%eax
80104a01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a07:	83 fa 14             	cmp    $0x14,%edx
80104a0a:	77 1c                	ja     80104a28 <syscall+0x38>
80104a0c:	8b 14 85 20 81 10 80 	mov    -0x7fef7ee0(,%eax,4),%edx
80104a13:	85 d2                	test   %edx,%edx
80104a15:	74 11                	je     80104a28 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104a17:	ff d2                	call   *%edx
80104a19:	8b 53 18             	mov    0x18(%ebx),%edx
80104a1c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a22:	c9                   	leave  
80104a23:	c3                   	ret    
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a28:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a29:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a2c:	50                   	push   %eax
80104a2d:	ff 73 10             	pushl  0x10(%ebx)
80104a30:	68 01 81 10 80       	push   $0x80108101
80104a35:	e8 26 bc ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a4a:	c9                   	leave  
80104a4b:	c3                   	ret    
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	56                   	push   %esi
80104a55:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a56:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104a59:	83 ec 44             	sub    $0x44,%esp
80104a5c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a62:	56                   	push   %esi
80104a63:	50                   	push   %eax
{
80104a64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a67:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a6a:	e8 31 d5 ff ff       	call   80101fa0 <nameiparent>
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	0f 84 46 01 00 00    	je     80104bc0 <create+0x170>
    return 0;
  ilock(dp);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	89 c3                	mov    %eax,%ebx
80104a7f:	50                   	push   %eax
80104a80:	e8 0b cc ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a85:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a88:	83 c4 0c             	add    $0xc,%esp
80104a8b:	50                   	push   %eax
80104a8c:	56                   	push   %esi
80104a8d:	53                   	push   %ebx
80104a8e:	e8 2d d1 ff ff       	call   80101bc0 <dirlookup>
80104a93:	83 c4 10             	add    $0x10,%esp
80104a96:	85 c0                	test   %eax,%eax
80104a98:	89 c7                	mov    %eax,%edi
80104a9a:	74 34                	je     80104ad0 <create+0x80>
    iunlockput(dp);
80104a9c:	83 ec 0c             	sub    $0xc,%esp
80104a9f:	53                   	push   %ebx
80104aa0:	e8 7b ce ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104aa5:	89 3c 24             	mov    %edi,(%esp)
80104aa8:	e8 e3 cb ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ab5:	0f 85 95 00 00 00    	jne    80104b50 <create+0x100>
80104abb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104ac0:	0f 85 8a 00 00 00    	jne    80104b50 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac9:	89 f8                	mov    %edi,%eax
80104acb:	5b                   	pop    %ebx
80104acc:	5e                   	pop    %esi
80104acd:	5f                   	pop    %edi
80104ace:	5d                   	pop    %ebp
80104acf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104ad0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ad4:	83 ec 08             	sub    $0x8,%esp
80104ad7:	50                   	push   %eax
80104ad8:	ff 33                	pushl  (%ebx)
80104ada:	e8 41 ca ff ff       	call   80101520 <ialloc>
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	85 c0                	test   %eax,%eax
80104ae4:	89 c7                	mov    %eax,%edi
80104ae6:	0f 84 e8 00 00 00    	je     80104bd4 <create+0x184>
  ilock(ip);
80104aec:	83 ec 0c             	sub    $0xc,%esp
80104aef:	50                   	push   %eax
80104af0:	e8 9b cb ff ff       	call   80101690 <ilock>
  ip->major = major;
80104af5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104af9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104afd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b01:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104b05:	b8 01 00 00 00       	mov    $0x1,%eax
80104b0a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104b0e:	89 3c 24             	mov    %edi,(%esp)
80104b11:	e8 ca ca ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b16:	83 c4 10             	add    $0x10,%esp
80104b19:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b1e:	74 50                	je     80104b70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b20:	83 ec 04             	sub    $0x4,%esp
80104b23:	ff 77 04             	pushl  0x4(%edi)
80104b26:	56                   	push   %esi
80104b27:	53                   	push   %ebx
80104b28:	e8 93 d3 ff ff       	call   80101ec0 <dirlink>
80104b2d:	83 c4 10             	add    $0x10,%esp
80104b30:	85 c0                	test   %eax,%eax
80104b32:	0f 88 8f 00 00 00    	js     80104bc7 <create+0x177>
  iunlockput(dp);
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	53                   	push   %ebx
80104b3c:	e8 df cd ff ff       	call   80101920 <iunlockput>
  return ip;
80104b41:	83 c4 10             	add    $0x10,%esp
}
80104b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b47:	89 f8                	mov    %edi,%eax
80104b49:	5b                   	pop    %ebx
80104b4a:	5e                   	pop    %esi
80104b4b:	5f                   	pop    %edi
80104b4c:	5d                   	pop    %ebp
80104b4d:	c3                   	ret    
80104b4e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	57                   	push   %edi
    return 0;
80104b54:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104b56:	e8 c5 cd ff ff       	call   80101920 <iunlockput>
    return 0;
80104b5b:	83 c4 10             	add    $0x10,%esp
}
80104b5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b61:	89 f8                	mov    %edi,%eax
80104b63:	5b                   	pop    %ebx
80104b64:	5e                   	pop    %esi
80104b65:	5f                   	pop    %edi
80104b66:	5d                   	pop    %ebp
80104b67:	c3                   	ret    
80104b68:	90                   	nop
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104b70:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b75:	83 ec 0c             	sub    $0xc,%esp
80104b78:	53                   	push   %ebx
80104b79:	e8 62 ca ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b7e:	83 c4 0c             	add    $0xc,%esp
80104b81:	ff 77 04             	pushl  0x4(%edi)
80104b84:	68 94 81 10 80       	push   $0x80108194
80104b89:	57                   	push   %edi
80104b8a:	e8 31 d3 ff ff       	call   80101ec0 <dirlink>
80104b8f:	83 c4 10             	add    $0x10,%esp
80104b92:	85 c0                	test   %eax,%eax
80104b94:	78 1c                	js     80104bb2 <create+0x162>
80104b96:	83 ec 04             	sub    $0x4,%esp
80104b99:	ff 73 04             	pushl  0x4(%ebx)
80104b9c:	68 93 81 10 80       	push   $0x80108193
80104ba1:	57                   	push   %edi
80104ba2:	e8 19 d3 ff ff       	call   80101ec0 <dirlink>
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	85 c0                	test   %eax,%eax
80104bac:	0f 89 6e ff ff ff    	jns    80104b20 <create+0xd0>
      panic("create dots");
80104bb2:	83 ec 0c             	sub    $0xc,%esp
80104bb5:	68 87 81 10 80       	push   $0x80108187
80104bba:	e8 d1 b7 ff ff       	call   80100390 <panic>
80104bbf:	90                   	nop
    return 0;
80104bc0:	31 ff                	xor    %edi,%edi
80104bc2:	e9 ff fe ff ff       	jmp    80104ac6 <create+0x76>
    panic("create: dirlink");
80104bc7:	83 ec 0c             	sub    $0xc,%esp
80104bca:	68 96 81 10 80       	push   $0x80108196
80104bcf:	e8 bc b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	68 78 81 10 80       	push   $0x80108178
80104bdc:	e8 af b7 ff ff       	call   80100390 <panic>
80104be1:	eb 0d                	jmp    80104bf0 <argfd.constprop.0>
80104be3:	90                   	nop
80104be4:	90                   	nop
80104be5:	90                   	nop
80104be6:	90                   	nop
80104be7:	90                   	nop
80104be8:	90                   	nop
80104be9:	90                   	nop
80104bea:	90                   	nop
80104beb:	90                   	nop
80104bec:	90                   	nop
80104bed:	90                   	nop
80104bee:	90                   	nop
80104bef:	90                   	nop

80104bf0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bf7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bfa:	89 d6                	mov    %edx,%esi
80104bfc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bff:	50                   	push   %eax
80104c00:	6a 00                	push   $0x0
80104c02:	e8 f9 fc ff ff       	call   80104900 <argint>
80104c07:	83 c4 10             	add    $0x10,%esp
80104c0a:	85 c0                	test   %eax,%eax
80104c0c:	78 2a                	js     80104c38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c12:	77 24                	ja     80104c38 <argfd.constprop.0+0x48>
80104c14:	e8 37 ed ff ff       	call   80103950 <myproc>
80104c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c20:	85 c0                	test   %eax,%eax
80104c22:	74 14                	je     80104c38 <argfd.constprop.0+0x48>
  if(pfd)
80104c24:	85 db                	test   %ebx,%ebx
80104c26:	74 02                	je     80104c2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c2c:	31 c0                	xor    %eax,%eax
}
80104c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5d                   	pop    %ebp
80104c34:	c3                   	ret    
80104c35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3d:	eb ef                	jmp    80104c2e <argfd.constprop.0+0x3e>
80104c3f:	90                   	nop

80104c40 <sys_dup>:
{
80104c40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	56                   	push   %esi
80104c46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c4d:	e8 9e ff ff ff       	call   80104bf0 <argfd.constprop.0>
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 42                	js     80104c98 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104c56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c5b:	e8 f0 ec ff ff       	call   80103950 <myproc>
80104c60:	eb 0e                	jmp    80104c70 <sys_dup+0x30>
80104c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c68:	83 c3 01             	add    $0x1,%ebx
80104c6b:	83 fb 10             	cmp    $0x10,%ebx
80104c6e:	74 28                	je     80104c98 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104c70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c74:	85 d2                	test   %edx,%edx
80104c76:	75 f0                	jne    80104c68 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104c78:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c82:	e8 69 c1 ff ff       	call   80100df0 <filedup>
  return fd;
80104c87:	83 c4 10             	add    $0x10,%esp
}
80104c8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c8d:	89 d8                	mov    %ebx,%eax
80104c8f:	5b                   	pop    %ebx
80104c90:	5e                   	pop    %esi
80104c91:	5d                   	pop    %ebp
80104c92:	c3                   	ret    
80104c93:	90                   	nop
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ca0:	89 d8                	mov    %ebx,%eax
80104ca2:	5b                   	pop    %ebx
80104ca3:	5e                   	pop    %esi
80104ca4:	5d                   	pop    %ebp
80104ca5:	c3                   	ret    
80104ca6:	8d 76 00             	lea    0x0(%esi),%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <sys_read>:
{
80104cb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cb1:	31 c0                	xor    %eax,%eax
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cbb:	e8 30 ff ff ff       	call   80104bf0 <argfd.constprop.0>
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	78 4c                	js     80104d10 <sys_read+0x60>
80104cc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cc7:	83 ec 08             	sub    $0x8,%esp
80104cca:	50                   	push   %eax
80104ccb:	6a 02                	push   $0x2
80104ccd:	e8 2e fc ff ff       	call   80104900 <argint>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	78 37                	js     80104d10 <sys_read+0x60>
80104cd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cdc:	83 ec 04             	sub    $0x4,%esp
80104cdf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce2:	50                   	push   %eax
80104ce3:	6a 01                	push   $0x1
80104ce5:	e8 66 fc ff ff       	call   80104950 <argptr>
80104cea:	83 c4 10             	add    $0x10,%esp
80104ced:	85 c0                	test   %eax,%eax
80104cef:	78 1f                	js     80104d10 <sys_read+0x60>
  return fileread(f, p, n);
80104cf1:	83 ec 04             	sub    $0x4,%esp
80104cf4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104cfd:	e8 5e c2 ff ff       	call   80100f60 <fileread>
80104d02:	83 c4 10             	add    $0x10,%esp
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <sys_write>:
{
80104d20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d21:	31 c0                	xor    %eax,%eax
{
80104d23:	89 e5                	mov    %esp,%ebp
80104d25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d2b:	e8 c0 fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104d30:	85 c0                	test   %eax,%eax
80104d32:	78 4c                	js     80104d80 <sys_write+0x60>
80104d34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d37:	83 ec 08             	sub    $0x8,%esp
80104d3a:	50                   	push   %eax
80104d3b:	6a 02                	push   $0x2
80104d3d:	e8 be fb ff ff       	call   80104900 <argint>
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	85 c0                	test   %eax,%eax
80104d47:	78 37                	js     80104d80 <sys_write+0x60>
80104d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d4c:	83 ec 04             	sub    $0x4,%esp
80104d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d52:	50                   	push   %eax
80104d53:	6a 01                	push   $0x1
80104d55:	e8 f6 fb ff ff       	call   80104950 <argptr>
80104d5a:	83 c4 10             	add    $0x10,%esp
80104d5d:	85 c0                	test   %eax,%eax
80104d5f:	78 1f                	js     80104d80 <sys_write+0x60>
  return filewrite(f, p, n);
80104d61:	83 ec 04             	sub    $0x4,%esp
80104d64:	ff 75 f0             	pushl  -0x10(%ebp)
80104d67:	ff 75 f4             	pushl  -0xc(%ebp)
80104d6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d6d:	e8 7e c2 ff ff       	call   80100ff0 <filewrite>
80104d72:	83 c4 10             	add    $0x10,%esp
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <sys_close>:
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d9c:	e8 4f fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104da1:	85 c0                	test   %eax,%eax
80104da3:	78 2b                	js     80104dd0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104da5:	e8 a6 eb ff ff       	call   80103950 <myproc>
80104daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104dad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104db0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104db7:	00 
  fileclose(f);
80104db8:	ff 75 f4             	pushl  -0xc(%ebp)
80104dbb:	e8 80 c0 ff ff       	call   80100e40 <fileclose>
  return 0;
80104dc0:	83 c4 10             	add    $0x10,%esp
80104dc3:	31 c0                	xor    %eax,%eax
}
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <sys_fstat>:
{
80104de0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104de8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104deb:	e8 00 fe ff ff       	call   80104bf0 <argfd.constprop.0>
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 2c                	js     80104e20 <sys_fstat+0x40>
80104df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104df7:	83 ec 04             	sub    $0x4,%esp
80104dfa:	6a 14                	push   $0x14
80104dfc:	50                   	push   %eax
80104dfd:	6a 01                	push   $0x1
80104dff:	e8 4c fb ff ff       	call   80104950 <argptr>
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	85 c0                	test   %eax,%eax
80104e09:	78 15                	js     80104e20 <sys_fstat+0x40>
  return filestat(f, st);
80104e0b:	83 ec 08             	sub    $0x8,%esp
80104e0e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e11:	ff 75 f0             	pushl  -0x10(%ebp)
80104e14:	e8 f7 c0 ff ff       	call   80100f10 <filestat>
80104e19:	83 c4 10             	add    $0x10,%esp
}
80104e1c:	c9                   	leave  
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <sys_link>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e3c:	50                   	push   %eax
80104e3d:	6a 00                	push   $0x0
80104e3f:	e8 6c fb ff ff       	call   801049b0 <argstr>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	0f 88 fb 00 00 00    	js     80104f4a <sys_link+0x11a>
80104e4f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e52:	83 ec 08             	sub    $0x8,%esp
80104e55:	50                   	push   %eax
80104e56:	6a 01                	push   $0x1
80104e58:	e8 53 fb ff ff       	call   801049b0 <argstr>
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	85 c0                	test   %eax,%eax
80104e62:	0f 88 e2 00 00 00    	js     80104f4a <sys_link+0x11a>
  begin_op();
80104e68:	e8 93 de ff ff       	call   80102d00 <begin_op>
  if((ip = namei(old)) == 0){
80104e6d:	83 ec 0c             	sub    $0xc,%esp
80104e70:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e73:	e8 08 d1 ff ff       	call   80101f80 <namei>
80104e78:	83 c4 10             	add    $0x10,%esp
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	89 c3                	mov    %eax,%ebx
80104e7f:	0f 84 ea 00 00 00    	je     80104f6f <sys_link+0x13f>
  ilock(ip);
80104e85:	83 ec 0c             	sub    $0xc,%esp
80104e88:	50                   	push   %eax
80104e89:	e8 02 c8 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104e8e:	83 c4 10             	add    $0x10,%esp
80104e91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e96:	0f 84 bb 00 00 00    	je     80104f57 <sys_link+0x127>
  ip->nlink++;
80104e9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ea1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104ea4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ea7:	53                   	push   %ebx
80104ea8:	e8 33 c7 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104ead:	89 1c 24             	mov    %ebx,(%esp)
80104eb0:	e8 bb c8 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104eb5:	58                   	pop    %eax
80104eb6:	5a                   	pop    %edx
80104eb7:	57                   	push   %edi
80104eb8:	ff 75 d0             	pushl  -0x30(%ebp)
80104ebb:	e8 e0 d0 ff ff       	call   80101fa0 <nameiparent>
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	85 c0                	test   %eax,%eax
80104ec5:	89 c6                	mov    %eax,%esi
80104ec7:	74 5b                	je     80104f24 <sys_link+0xf4>
  ilock(dp);
80104ec9:	83 ec 0c             	sub    $0xc,%esp
80104ecc:	50                   	push   %eax
80104ecd:	e8 be c7 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ed2:	83 c4 10             	add    $0x10,%esp
80104ed5:	8b 03                	mov    (%ebx),%eax
80104ed7:	39 06                	cmp    %eax,(%esi)
80104ed9:	75 3d                	jne    80104f18 <sys_link+0xe8>
80104edb:	83 ec 04             	sub    $0x4,%esp
80104ede:	ff 73 04             	pushl  0x4(%ebx)
80104ee1:	57                   	push   %edi
80104ee2:	56                   	push   %esi
80104ee3:	e8 d8 cf ff ff       	call   80101ec0 <dirlink>
80104ee8:	83 c4 10             	add    $0x10,%esp
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	78 29                	js     80104f18 <sys_link+0xe8>
  iunlockput(dp);
80104eef:	83 ec 0c             	sub    $0xc,%esp
80104ef2:	56                   	push   %esi
80104ef3:	e8 28 ca ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104ef8:	89 1c 24             	mov    %ebx,(%esp)
80104efb:	e8 c0 c8 ff ff       	call   801017c0 <iput>
  end_op();
80104f00:	e8 6b de ff ff       	call   80102d70 <end_op>
  return 0;
80104f05:	83 c4 10             	add    $0x10,%esp
80104f08:	31 c0                	xor    %eax,%eax
}
80104f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f0d:	5b                   	pop    %ebx
80104f0e:	5e                   	pop    %esi
80104f0f:	5f                   	pop    %edi
80104f10:	5d                   	pop    %ebp
80104f11:	c3                   	ret    
80104f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f18:	83 ec 0c             	sub    $0xc,%esp
80104f1b:	56                   	push   %esi
80104f1c:	e8 ff c9 ff ff       	call   80101920 <iunlockput>
    goto bad;
80104f21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	53                   	push   %ebx
80104f28:	e8 63 c7 ff ff       	call   80101690 <ilock>
  ip->nlink--;
80104f2d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f32:	89 1c 24             	mov    %ebx,(%esp)
80104f35:	e8 a6 c6 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104f3a:	89 1c 24             	mov    %ebx,(%esp)
80104f3d:	e8 de c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104f42:	e8 29 de ff ff       	call   80102d70 <end_op>
  return -1;
80104f47:	83 c4 10             	add    $0x10,%esp
}
80104f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f52:	5b                   	pop    %ebx
80104f53:	5e                   	pop    %esi
80104f54:	5f                   	pop    %edi
80104f55:	5d                   	pop    %ebp
80104f56:	c3                   	ret    
    iunlockput(ip);
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	53                   	push   %ebx
80104f5b:	e8 c0 c9 ff ff       	call   80101920 <iunlockput>
    end_op();
80104f60:	e8 0b de ff ff       	call   80102d70 <end_op>
    return -1;
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb 9b                	jmp    80104f0a <sys_link+0xda>
    end_op();
80104f6f:	e8 fc dd ff ff       	call   80102d70 <end_op>
    return -1;
80104f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f79:	eb 8f                	jmp    80104f0a <sys_link+0xda>
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <sys_unlink>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104f86:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f89:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104f8c:	50                   	push   %eax
80104f8d:	6a 00                	push   $0x0
80104f8f:	e8 1c fa ff ff       	call   801049b0 <argstr>
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	85 c0                	test   %eax,%eax
80104f99:	0f 88 77 01 00 00    	js     80105116 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104f9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104fa2:	e8 59 dd ff ff       	call   80102d00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fa7:	83 ec 08             	sub    $0x8,%esp
80104faa:	53                   	push   %ebx
80104fab:	ff 75 c0             	pushl  -0x40(%ebp)
80104fae:	e8 ed cf ff ff       	call   80101fa0 <nameiparent>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	89 c6                	mov    %eax,%esi
80104fba:	0f 84 60 01 00 00    	je     80105120 <sys_unlink+0x1a0>
  ilock(dp);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	50                   	push   %eax
80104fc4:	e8 c7 c6 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fc9:	58                   	pop    %eax
80104fca:	5a                   	pop    %edx
80104fcb:	68 94 81 10 80       	push   $0x80108194
80104fd0:	53                   	push   %ebx
80104fd1:	e8 ca cb ff ff       	call   80101ba0 <namecmp>
80104fd6:	83 c4 10             	add    $0x10,%esp
80104fd9:	85 c0                	test   %eax,%eax
80104fdb:	0f 84 03 01 00 00    	je     801050e4 <sys_unlink+0x164>
80104fe1:	83 ec 08             	sub    $0x8,%esp
80104fe4:	68 93 81 10 80       	push   $0x80108193
80104fe9:	53                   	push   %ebx
80104fea:	e8 b1 cb ff ff       	call   80101ba0 <namecmp>
80104fef:	83 c4 10             	add    $0x10,%esp
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	0f 84 ea 00 00 00    	je     801050e4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104ffa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ffd:	83 ec 04             	sub    $0x4,%esp
80105000:	50                   	push   %eax
80105001:	53                   	push   %ebx
80105002:	56                   	push   %esi
80105003:	e8 b8 cb ff ff       	call   80101bc0 <dirlookup>
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	85 c0                	test   %eax,%eax
8010500d:	89 c3                	mov    %eax,%ebx
8010500f:	0f 84 cf 00 00 00    	je     801050e4 <sys_unlink+0x164>
  ilock(ip);
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	50                   	push   %eax
80105019:	e8 72 c6 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105026:	0f 8e 10 01 00 00    	jle    8010513c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010502c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105031:	74 6d                	je     801050a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105033:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105036:	83 ec 04             	sub    $0x4,%esp
80105039:	6a 10                	push   $0x10
8010503b:	6a 00                	push   $0x0
8010503d:	50                   	push   %eax
8010503e:	e8 bd f5 ff ff       	call   80104600 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105043:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105046:	6a 10                	push   $0x10
80105048:	ff 75 c4             	pushl  -0x3c(%ebp)
8010504b:	50                   	push   %eax
8010504c:	56                   	push   %esi
8010504d:	e8 1e ca ff ff       	call   80101a70 <writei>
80105052:	83 c4 20             	add    $0x20,%esp
80105055:	83 f8 10             	cmp    $0x10,%eax
80105058:	0f 85 eb 00 00 00    	jne    80105149 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010505e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105063:	0f 84 97 00 00 00    	je     80105100 <sys_unlink+0x180>
  iunlockput(dp);
80105069:	83 ec 0c             	sub    $0xc,%esp
8010506c:	56                   	push   %esi
8010506d:	e8 ae c8 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105072:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105077:	89 1c 24             	mov    %ebx,(%esp)
8010507a:	e8 61 c5 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010507f:	89 1c 24             	mov    %ebx,(%esp)
80105082:	e8 99 c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105087:	e8 e4 dc ff ff       	call   80102d70 <end_op>
  return 0;
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	31 c0                	xor    %eax,%eax
}
80105091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105094:	5b                   	pop    %ebx
80105095:	5e                   	pop    %esi
80105096:	5f                   	pop    %edi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050a4:	76 8d                	jbe    80105033 <sys_unlink+0xb3>
801050a6:	bf 20 00 00 00       	mov    $0x20,%edi
801050ab:	eb 0f                	jmp    801050bc <sys_unlink+0x13c>
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
801050b0:	83 c7 10             	add    $0x10,%edi
801050b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801050b6:	0f 83 77 ff ff ff    	jae    80105033 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050bf:	6a 10                	push   $0x10
801050c1:	57                   	push   %edi
801050c2:	50                   	push   %eax
801050c3:	53                   	push   %ebx
801050c4:	e8 a7 c8 ff ff       	call   80101970 <readi>
801050c9:	83 c4 10             	add    $0x10,%esp
801050cc:	83 f8 10             	cmp    $0x10,%eax
801050cf:	75 5e                	jne    8010512f <sys_unlink+0x1af>
    if(de.inum != 0)
801050d1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050d6:	74 d8                	je     801050b0 <sys_unlink+0x130>
    iunlockput(ip);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	53                   	push   %ebx
801050dc:	e8 3f c8 ff ff       	call   80101920 <iunlockput>
    goto bad;
801050e1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	56                   	push   %esi
801050e8:	e8 33 c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050ed:	e8 7e dc ff ff       	call   80102d70 <end_op>
  return -1;
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fa:	eb 95                	jmp    80105091 <sys_unlink+0x111>
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105100:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	56                   	push   %esi
80105109:	e8 d2 c4 ff ff       	call   801015e0 <iupdate>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	e9 53 ff ff ff       	jmp    80105069 <sys_unlink+0xe9>
    return -1;
80105116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511b:	e9 71 ff ff ff       	jmp    80105091 <sys_unlink+0x111>
    end_op();
80105120:	e8 4b dc ff ff       	call   80102d70 <end_op>
    return -1;
80105125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512a:	e9 62 ff ff ff       	jmp    80105091 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	68 b8 81 10 80       	push   $0x801081b8
80105137:	e8 54 b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	68 a6 81 10 80       	push   $0x801081a6
80105144:	e8 47 b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	68 ca 81 10 80       	push   $0x801081ca
80105151:	e8 3a b2 ff ff       	call   80100390 <panic>
80105156:	8d 76 00             	lea    0x0(%esi),%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_open>:

int
sys_open(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
80105165:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105166:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105169:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 3c f8 ff ff       	call   801049b0 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 1d 01 00 00    	js     8010529c <sys_open+0x13c>
8010517f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105182:	83 ec 08             	sub    $0x8,%esp
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 73 f7 ff ff       	call   80104900 <argint>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	0f 88 04 01 00 00    	js     8010529c <sys_open+0x13c>
    return -1;

  begin_op();
80105198:	e8 63 db ff ff       	call   80102d00 <begin_op>

  if(omode & O_CREATE){
8010519d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051a1:	0f 85 a9 00 00 00    	jne    80105250 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051a7:	83 ec 0c             	sub    $0xc,%esp
801051aa:	ff 75 e0             	pushl  -0x20(%ebp)
801051ad:	e8 ce cd ff ff       	call   80101f80 <namei>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	85 c0                	test   %eax,%eax
801051b7:	89 c6                	mov    %eax,%esi
801051b9:	0f 84 b2 00 00 00    	je     80105271 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	50                   	push   %eax
801051c3:	e8 c8 c4 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051d0:	0f 84 aa 00 00 00    	je     80105280 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051d6:	e8 a5 bb ff ff       	call   80100d80 <filealloc>
801051db:	85 c0                	test   %eax,%eax
801051dd:	89 c7                	mov    %eax,%edi
801051df:	0f 84 a6 00 00 00    	je     8010528b <sys_open+0x12b>
  struct proc *curproc = myproc();
801051e5:	e8 66 e7 ff ff       	call   80103950 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ea:	31 db                	xor    %ebx,%ebx
801051ec:	eb 0e                	jmp    801051fc <sys_open+0x9c>
801051ee:	66 90                	xchg   %ax,%ax
801051f0:	83 c3 01             	add    $0x1,%ebx
801051f3:	83 fb 10             	cmp    $0x10,%ebx
801051f6:	0f 84 ac 00 00 00    	je     801052a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801051fc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105200:	85 d2                	test   %edx,%edx
80105202:	75 ec                	jne    801051f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105204:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105207:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010520b:	56                   	push   %esi
8010520c:	e8 5f c5 ff ff       	call   80101770 <iunlock>
  end_op();
80105211:	e8 5a db ff ff       	call   80102d70 <end_op>

  f->type = FD_INODE;
80105216:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010521c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010521f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105222:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105225:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010522c:	89 d0                	mov    %edx,%eax
8010522e:	f7 d0                	not    %eax
80105230:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105233:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105236:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105239:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010523d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105240:	89 d8                	mov    %ebx,%eax
80105242:	5b                   	pop    %ebx
80105243:	5e                   	pop    %esi
80105244:	5f                   	pop    %edi
80105245:	5d                   	pop    %ebp
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105256:	31 c9                	xor    %ecx,%ecx
80105258:	6a 00                	push   $0x0
8010525a:	ba 02 00 00 00       	mov    $0x2,%edx
8010525f:	e8 ec f7 ff ff       	call   80104a50 <create>
    if(ip == 0){
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105269:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010526b:	0f 85 65 ff ff ff    	jne    801051d6 <sys_open+0x76>
      end_op();
80105271:	e8 fa da ff ff       	call   80102d70 <end_op>
      return -1;
80105276:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010527b:	eb c0                	jmp    8010523d <sys_open+0xdd>
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105280:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105283:	85 c9                	test   %ecx,%ecx
80105285:	0f 84 4b ff ff ff    	je     801051d6 <sys_open+0x76>
    iunlockput(ip);
8010528b:	83 ec 0c             	sub    $0xc,%esp
8010528e:	56                   	push   %esi
8010528f:	e8 8c c6 ff ff       	call   80101920 <iunlockput>
    end_op();
80105294:	e8 d7 da ff ff       	call   80102d70 <end_op>
    return -1;
80105299:	83 c4 10             	add    $0x10,%esp
8010529c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052a1:	eb 9a                	jmp    8010523d <sys_open+0xdd>
801052a3:	90                   	nop
801052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	57                   	push   %edi
801052ac:	e8 8f bb ff ff       	call   80100e40 <fileclose>
801052b1:	83 c4 10             	add    $0x10,%esp
801052b4:	eb d5                	jmp    8010528b <sys_open+0x12b>
801052b6:	8d 76 00             	lea    0x0(%esi),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052c6:	e8 35 da ff ff       	call   80102d00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ce:	83 ec 08             	sub    $0x8,%esp
801052d1:	50                   	push   %eax
801052d2:	6a 00                	push   $0x0
801052d4:	e8 d7 f6 ff ff       	call   801049b0 <argstr>
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	85 c0                	test   %eax,%eax
801052de:	78 30                	js     80105310 <sys_mkdir+0x50>
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e6:	31 c9                	xor    %ecx,%ecx
801052e8:	6a 00                	push   $0x0
801052ea:	ba 01 00 00 00       	mov    $0x1,%edx
801052ef:	e8 5c f7 ff ff       	call   80104a50 <create>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	74 15                	je     80105310 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	50                   	push   %eax
801052ff:	e8 1c c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105304:	e8 67 da ff ff       	call   80102d70 <end_op>
  return 0;
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	31 c0                	xor    %eax,%eax
}
8010530e:	c9                   	leave  
8010530f:	c3                   	ret    
    end_op();
80105310:	e8 5b da ff ff       	call   80102d70 <end_op>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010531a:	c9                   	leave  
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_mknod>:

int
sys_mknod(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105326:	e8 d5 d9 ff ff       	call   80102d00 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010532b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010532e:	83 ec 08             	sub    $0x8,%esp
80105331:	50                   	push   %eax
80105332:	6a 00                	push   $0x0
80105334:	e8 77 f6 ff ff       	call   801049b0 <argstr>
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	85 c0                	test   %eax,%eax
8010533e:	78 60                	js     801053a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105340:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105343:	83 ec 08             	sub    $0x8,%esp
80105346:	50                   	push   %eax
80105347:	6a 01                	push   $0x1
80105349:	e8 b2 f5 ff ff       	call   80104900 <argint>
  if((argstr(0, &path)) < 0 ||
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	85 c0                	test   %eax,%eax
80105353:	78 4b                	js     801053a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105355:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105358:	83 ec 08             	sub    $0x8,%esp
8010535b:	50                   	push   %eax
8010535c:	6a 02                	push   $0x2
8010535e:	e8 9d f5 ff ff       	call   80104900 <argint>
     argint(1, &major) < 0 ||
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	78 36                	js     801053a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010536a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010536e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105371:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105375:	ba 03 00 00 00       	mov    $0x3,%edx
8010537a:	50                   	push   %eax
8010537b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010537e:	e8 cd f6 ff ff       	call   80104a50 <create>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	74 16                	je     801053a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	50                   	push   %eax
8010538e:	e8 8d c5 ff ff       	call   80101920 <iunlockput>
  end_op();
80105393:	e8 d8 d9 ff ff       	call   80102d70 <end_op>
  return 0;
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	31 c0                	xor    %eax,%eax
}
8010539d:	c9                   	leave  
8010539e:	c3                   	ret    
8010539f:	90                   	nop
    end_op();
801053a0:	e8 cb d9 ff ff       	call   80102d70 <end_op>
    return -1;
801053a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053aa:	c9                   	leave  
801053ab:	c3                   	ret    
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_chdir>:

int
sys_chdir(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
801053b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801053b8:	e8 93 e5 ff ff       	call   80103950 <myproc>
801053bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801053bf:	e8 3c d9 ff ff       	call   80102d00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	50                   	push   %eax
801053cb:	6a 00                	push   $0x0
801053cd:	e8 de f5 ff ff       	call   801049b0 <argstr>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	85 c0                	test   %eax,%eax
801053d7:	78 77                	js     80105450 <sys_chdir+0xa0>
801053d9:	83 ec 0c             	sub    $0xc,%esp
801053dc:	ff 75 f4             	pushl  -0xc(%ebp)
801053df:	e8 9c cb ff ff       	call   80101f80 <namei>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	89 c3                	mov    %eax,%ebx
801053eb:	74 63                	je     80105450 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	50                   	push   %eax
801053f1:	e8 9a c2 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053fe:	75 30                	jne    80105430 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	53                   	push   %ebx
80105404:	e8 67 c3 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105409:	58                   	pop    %eax
8010540a:	ff 76 68             	pushl  0x68(%esi)
8010540d:	e8 ae c3 ff ff       	call   801017c0 <iput>
  end_op();
80105412:	e8 59 d9 ff ff       	call   80102d70 <end_op>
  curproc->cwd = ip;
80105417:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	31 c0                	xor    %eax,%eax
}
8010541f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105422:	5b                   	pop    %ebx
80105423:	5e                   	pop    %esi
80105424:	5d                   	pop    %ebp
80105425:	c3                   	ret    
80105426:	8d 76 00             	lea    0x0(%esi),%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	53                   	push   %ebx
80105434:	e8 e7 c4 ff ff       	call   80101920 <iunlockput>
    end_op();
80105439:	e8 32 d9 ff ff       	call   80102d70 <end_op>
    return -1;
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105446:	eb d7                	jmp    8010541f <sys_chdir+0x6f>
80105448:	90                   	nop
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105450:	e8 1b d9 ff ff       	call   80102d70 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	eb c3                	jmp    8010541f <sys_chdir+0x6f>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_exec>:

int
sys_exec(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105466:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010546c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105472:	50                   	push   %eax
80105473:	6a 00                	push   $0x0
80105475:	e8 36 f5 ff ff       	call   801049b0 <argstr>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	85 c0                	test   %eax,%eax
8010547f:	0f 88 87 00 00 00    	js     8010550c <sys_exec+0xac>
80105485:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010548b:	83 ec 08             	sub    $0x8,%esp
8010548e:	50                   	push   %eax
8010548f:	6a 01                	push   $0x1
80105491:	e8 6a f4 ff ff       	call   80104900 <argint>
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	85 c0                	test   %eax,%eax
8010549b:	78 6f                	js     8010550c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010549d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054a3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801054a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801054a8:	68 80 00 00 00       	push   $0x80
801054ad:	6a 00                	push   $0x0
801054af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054b5:	50                   	push   %eax
801054b6:	e8 45 f1 ff ff       	call   80104600 <memset>
801054bb:	83 c4 10             	add    $0x10,%esp
801054be:	eb 2c                	jmp    801054ec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801054c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 56                	je     80105520 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054d6:	52                   	push   %edx
801054d7:	50                   	push   %eax
801054d8:	e8 b3 f3 ff ff       	call   80104890 <fetchstr>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 28                	js     8010550c <sys_exec+0xac>
  for(i=0;; i++){
801054e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054e7:	83 fb 20             	cmp    $0x20,%ebx
801054ea:	74 20                	je     8010550c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054f2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054f9:	83 ec 08             	sub    $0x8,%esp
801054fc:	57                   	push   %edi
801054fd:	01 f0                	add    %esi,%eax
801054ff:	50                   	push   %eax
80105500:	e8 4b f3 ff ff       	call   80104850 <fetchint>
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	85 c0                	test   %eax,%eax
8010550a:	79 b4                	jns    801054c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010550c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010550f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105514:	5b                   	pop    %ebx
80105515:	5e                   	pop    %esi
80105516:	5f                   	pop    %edi
80105517:	5d                   	pop    %ebp
80105518:	c3                   	ret    
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105520:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105526:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105529:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105530:	00 00 00 00 
  return exec(path, argv);
80105534:	50                   	push   %eax
80105535:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010553b:	e8 d0 b4 ff ff       	call   80100a10 <exec>
80105540:	83 c4 10             	add    $0x10,%esp
}
80105543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105546:	5b                   	pop    %ebx
80105547:	5e                   	pop    %esi
80105548:	5f                   	pop    %edi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	90                   	nop
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_pipe>:

int
sys_pipe(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105556:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105559:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010555c:	6a 08                	push   $0x8
8010555e:	50                   	push   %eax
8010555f:	6a 00                	push   $0x0
80105561:	e8 ea f3 ff ff       	call   80104950 <argptr>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	0f 88 ae 00 00 00    	js     8010561f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105571:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105574:	83 ec 08             	sub    $0x8,%esp
80105577:	50                   	push   %eax
80105578:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010557b:	50                   	push   %eax
8010557c:	e8 1f de ff ff       	call   801033a0 <pipealloc>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	85 c0                	test   %eax,%eax
80105586:	0f 88 93 00 00 00    	js     8010561f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010558c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010558f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105591:	e8 ba e3 ff ff       	call   80103950 <myproc>
80105596:	eb 10                	jmp    801055a8 <sys_pipe+0x58>
80105598:	90                   	nop
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055a0:	83 c3 01             	add    $0x1,%ebx
801055a3:	83 fb 10             	cmp    $0x10,%ebx
801055a6:	74 60                	je     80105608 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801055a8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801055ac:	85 f6                	test   %esi,%esi
801055ae:	75 f0                	jne    801055a0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801055b0:	8d 73 08             	lea    0x8(%ebx),%esi
801055b3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801055ba:	e8 91 e3 ff ff       	call   80103950 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055bf:	31 d2                	xor    %edx,%edx
801055c1:	eb 0d                	jmp    801055d0 <sys_pipe+0x80>
801055c3:	90                   	nop
801055c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055c8:	83 c2 01             	add    $0x1,%edx
801055cb:	83 fa 10             	cmp    $0x10,%edx
801055ce:	74 28                	je     801055f8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801055d0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801055d4:	85 c9                	test   %ecx,%ecx
801055d6:	75 f0                	jne    801055c8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801055d8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055df:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055e4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055e7:	31 c0                	xor    %eax,%eax
}
801055e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055ec:	5b                   	pop    %ebx
801055ed:	5e                   	pop    %esi
801055ee:	5f                   	pop    %edi
801055ef:	5d                   	pop    %ebp
801055f0:	c3                   	ret    
801055f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801055f8:	e8 53 e3 ff ff       	call   80103950 <myproc>
801055fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105604:	00 
80105605:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	ff 75 e0             	pushl  -0x20(%ebp)
8010560e:	e8 2d b8 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105613:	58                   	pop    %eax
80105614:	ff 75 e4             	pushl  -0x1c(%ebp)
80105617:	e8 24 b8 ff ff       	call   80100e40 <fileclose>
    return -1;
8010561c:	83 c4 10             	add    $0x10,%esp
8010561f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105624:	eb c3                	jmp    801055e9 <sys_pipe+0x99>
80105626:	66 90                	xchg   %ax,%ax
80105628:	66 90                	xchg   %ax,%ax
8010562a:	66 90                	xchg   %ax,%ax
8010562c:	66 90                	xchg   %ax,%ax
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105633:	5d                   	pop    %ebp
  return fork();
80105634:	e9 b7 e4 ff ff       	jmp    80103af0 <fork>
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_exit>:

int
sys_exit(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 08             	sub    $0x8,%esp
  exit();
80105646:	e8 25 e7 ff ff       	call   80103d70 <exit>
  return 0;  // not reached
}
8010564b:	31 c0                	xor    %eax,%eax
8010564d:	c9                   	leave  
8010564e:	c3                   	ret    
8010564f:	90                   	nop

80105650 <sys_wait>:

int
sys_wait(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105653:	5d                   	pop    %ebp
  return wait();
80105654:	e9 57 e9 ff ff       	jmp    80103fb0 <wait>
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_kill>:

int
sys_kill(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105669:	50                   	push   %eax
8010566a:	6a 00                	push   $0x0
8010566c:	e8 8f f2 ff ff       	call   80104900 <argint>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	78 18                	js     80105690 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	ff 75 f4             	pushl  -0xc(%ebp)
8010567e:	e8 7d ea ff ff       	call   80104100 <kill>
80105683:	83 c4 10             	add    $0x10,%esp
}
80105686:	c9                   	leave  
80105687:	c3                   	ret    
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105695:	c9                   	leave  
80105696:	c3                   	ret    
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <sys_getpid>:

int
sys_getpid(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801056a6:	e8 a5 e2 ff ff       	call   80103950 <myproc>
801056ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801056ae:	c9                   	leave  
801056af:	c3                   	ret    

801056b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801056b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 3e f2 ff ff       	call   80104900 <argint>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 27                	js     801056f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801056c9:	e8 82 e2 ff ff       	call   80103950 <myproc>
  if(growproc(n) < 0)
801056ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801056d3:	ff 75 f4             	pushl  -0xc(%ebp)
801056d6:	e8 95 e3 ff ff       	call   80103a70 <growproc>
801056db:	83 c4 10             	add    $0x10,%esp
801056de:	85 c0                	test   %eax,%eax
801056e0:	78 0e                	js     801056f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801056e2:	89 d8                	mov    %ebx,%eax
801056e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e7:	c9                   	leave  
801056e8:	c3                   	ret    
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056f5:	eb eb                	jmp    801056e2 <sys_sbrk+0x32>
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_sleep>:

int
sys_sleep(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105704:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105707:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010570a:	50                   	push   %eax
8010570b:	6a 00                	push   $0x0
8010570d:	e8 ee f1 ff ff       	call   80104900 <argint>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	0f 88 8a 00 00 00    	js     801057a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	68 a0 5c 11 80       	push   $0x80115ca0
80105725:	e8 c6 ed ff ff       	call   801044f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010572a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010572d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105730:	8b 1d e0 64 11 80    	mov    0x801164e0,%ebx
  while(ticks - ticks0 < n){
80105736:	85 d2                	test   %edx,%edx
80105738:	75 27                	jne    80105761 <sys_sleep+0x61>
8010573a:	eb 54                	jmp    80105790 <sys_sleep+0x90>
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	68 a0 5c 11 80       	push   $0x80115ca0
80105748:	68 e0 64 11 80       	push   $0x801164e0
8010574d:	e8 9e e7 ff ff       	call   80103ef0 <sleep>
  while(ticks - ticks0 < n){
80105752:	a1 e0 64 11 80       	mov    0x801164e0,%eax
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	29 d8                	sub    %ebx,%eax
8010575c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010575f:	73 2f                	jae    80105790 <sys_sleep+0x90>
    if(myproc()->killed){
80105761:	e8 ea e1 ff ff       	call   80103950 <myproc>
80105766:	8b 40 24             	mov    0x24(%eax),%eax
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 d3                	je     80105740 <sys_sleep+0x40>
      release(&tickslock);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	68 a0 5c 11 80       	push   $0x80115ca0
80105775:	e8 36 ee ff ff       	call   801045b0 <release>
      return -1;
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 a0 5c 11 80       	push   $0x80115ca0
80105798:	e8 13 ee ff ff       	call   801045b0 <release>
  return 0;
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	31 c0                	xor    %eax,%eax
}
801057a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
    return -1;
801057a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ac:	eb f4                	jmp    801057a2 <sys_sleep+0xa2>
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	53                   	push   %ebx
801057b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801057b7:	68 a0 5c 11 80       	push   $0x80115ca0
801057bc:	e8 2f ed ff ff       	call   801044f0 <acquire>
  xticks = ticks;
801057c1:	8b 1d e0 64 11 80    	mov    0x801164e0,%ebx
  release(&tickslock);
801057c7:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
801057ce:	e8 dd ed ff ff       	call   801045b0 <release>
  return xticks;
}
801057d3:	89 d8                	mov    %ebx,%eax
801057d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d8:	c9                   	leave  
801057d9:	c3                   	ret    

801057da <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057da:	1e                   	push   %ds
  pushl %es
801057db:	06                   	push   %es
  pushl %fs
801057dc:	0f a0                	push   %fs
  pushl %gs
801057de:	0f a8                	push   %gs
  pushal
801057e0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801057e1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801057e5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801057e7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801057e9:	54                   	push   %esp
  call trap
801057ea:	e8 c1 00 00 00       	call   801058b0 <trap>
  addl $4, %esp
801057ef:	83 c4 04             	add    $0x4,%esp

801057f2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057f2:	61                   	popa   
  popl %gs
801057f3:	0f a9                	pop    %gs
  popl %fs
801057f5:	0f a1                	pop    %fs
  popl %es
801057f7:	07                   	pop    %es
  popl %ds
801057f8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057f9:	83 c4 08             	add    $0x8,%esp
  iret
801057fc:	cf                   	iret   
801057fd:	66 90                	xchg   %ax,%ax
801057ff:	90                   	nop

80105800 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105800:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105801:	31 c0                	xor    %eax,%eax
{
80105803:	89 e5                	mov    %esp,%ebp
80105805:	83 ec 08             	sub    $0x8,%esp
80105808:	90                   	nop
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105810:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105817:	c7 04 c5 e2 5c 11 80 	movl   $0x8e000008,-0x7feea31e(,%eax,8)
8010581e:	08 00 00 8e 
80105822:	66 89 14 c5 e0 5c 11 	mov    %dx,-0x7feea320(,%eax,8)
80105829:	80 
8010582a:	c1 ea 10             	shr    $0x10,%edx
8010582d:	66 89 14 c5 e6 5c 11 	mov    %dx,-0x7feea31a(,%eax,8)
80105834:	80 
  for(i = 0; i < 256; i++)
80105835:	83 c0 01             	add    $0x1,%eax
80105838:	3d 00 01 00 00       	cmp    $0x100,%eax
8010583d:	75 d1                	jne    80105810 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010583f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105844:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105847:	c7 05 e2 5e 11 80 08 	movl   $0xef000008,0x80115ee2
8010584e:	00 00 ef 
  initlock(&tickslock, "time");
80105851:	68 d9 81 10 80       	push   $0x801081d9
80105856:	68 a0 5c 11 80       	push   $0x80115ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010585b:	66 a3 e0 5e 11 80    	mov    %ax,0x80115ee0
80105861:	c1 e8 10             	shr    $0x10,%eax
80105864:	66 a3 e6 5e 11 80    	mov    %ax,0x80115ee6
  initlock(&tickslock, "time");
8010586a:	e8 41 eb ff ff       	call   801043b0 <initlock>
}
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	c9                   	leave  
80105873:	c3                   	ret    
80105874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010587a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105880 <idtinit>:

void
idtinit(void)
{
80105880:	55                   	push   %ebp
  pd[0] = size-1;
80105881:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105886:	89 e5                	mov    %esp,%ebp
80105888:	83 ec 10             	sub    $0x10,%esp
8010588b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010588f:	b8 e0 5c 11 80       	mov    $0x80115ce0,%eax
80105894:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105898:	c1 e8 10             	shr    $0x10,%eax
8010589b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010589f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801058a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
801058b5:	53                   	push   %ebx
801058b6:	83 ec 1c             	sub    $0x1c,%esp
801058b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801058bc:	8b 47 30             	mov    0x30(%edi),%eax
801058bf:	83 f8 40             	cmp    $0x40,%eax
801058c2:	0f 84 f0 00 00 00    	je     801059b8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058c8:	83 e8 20             	sub    $0x20,%eax
801058cb:	83 f8 1f             	cmp    $0x1f,%eax
801058ce:	77 10                	ja     801058e0 <trap+0x30>
801058d0:	ff 24 85 80 82 10 80 	jmp    *-0x7fef7d80(,%eax,4)
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058e0:	e8 6b e0 ff ff       	call   80103950 <myproc>
801058e5:	85 c0                	test   %eax,%eax
801058e7:	8b 5f 38             	mov    0x38(%edi),%ebx
801058ea:	0f 84 14 02 00 00    	je     80105b04 <trap+0x254>
801058f0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058f4:	0f 84 0a 02 00 00    	je     80105b04 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058fa:	0f 20 d1             	mov    %cr2,%ecx
801058fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105900:	e8 2b e0 ff ff       	call   80103930 <cpuid>
80105905:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105908:	8b 47 34             	mov    0x34(%edi),%eax
8010590b:	8b 77 30             	mov    0x30(%edi),%esi
8010590e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105911:	e8 3a e0 ff ff       	call   80103950 <myproc>
80105916:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105919:	e8 32 e0 ff ff       	call   80103950 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010591e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105921:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105924:	51                   	push   %ecx
80105925:	53                   	push   %ebx
80105926:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105927:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010592a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010592d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010592e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105931:	52                   	push   %edx
80105932:	ff 70 10             	pushl  0x10(%eax)
80105935:	68 3c 82 10 80       	push   $0x8010823c
8010593a:	e8 21 ad ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010593f:	83 c4 20             	add    $0x20,%esp
80105942:	e8 09 e0 ff ff       	call   80103950 <myproc>
80105947:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010594e:	e8 fd df ff ff       	call   80103950 <myproc>
80105953:	85 c0                	test   %eax,%eax
80105955:	74 1d                	je     80105974 <trap+0xc4>
80105957:	e8 f4 df ff ff       	call   80103950 <myproc>
8010595c:	8b 50 24             	mov    0x24(%eax),%edx
8010595f:	85 d2                	test   %edx,%edx
80105961:	74 11                	je     80105974 <trap+0xc4>
80105963:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105967:	83 e0 03             	and    $0x3,%eax
8010596a:	66 83 f8 03          	cmp    $0x3,%ax
8010596e:	0f 84 4c 01 00 00    	je     80105ac0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105974:	e8 d7 df ff ff       	call   80103950 <myproc>
80105979:	85 c0                	test   %eax,%eax
8010597b:	74 0b                	je     80105988 <trap+0xd8>
8010597d:	e8 ce df ff ff       	call   80103950 <myproc>
80105982:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105986:	74 68                	je     801059f0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105988:	e8 c3 df ff ff       	call   80103950 <myproc>
8010598d:	85 c0                	test   %eax,%eax
8010598f:	74 19                	je     801059aa <trap+0xfa>
80105991:	e8 ba df ff ff       	call   80103950 <myproc>
80105996:	8b 40 24             	mov    0x24(%eax),%eax
80105999:	85 c0                	test   %eax,%eax
8010599b:	74 0d                	je     801059aa <trap+0xfa>
8010599d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059a1:	83 e0 03             	and    $0x3,%eax
801059a4:	66 83 f8 03          	cmp    $0x3,%ax
801059a8:	74 37                	je     801059e1 <trap+0x131>
    exit();
}
801059aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ad:	5b                   	pop    %ebx
801059ae:	5e                   	pop    %esi
801059af:	5f                   	pop    %edi
801059b0:	5d                   	pop    %ebp
801059b1:	c3                   	ret    
801059b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801059b8:	e8 93 df ff ff       	call   80103950 <myproc>
801059bd:	8b 58 24             	mov    0x24(%eax),%ebx
801059c0:	85 db                	test   %ebx,%ebx
801059c2:	0f 85 e8 00 00 00    	jne    80105ab0 <trap+0x200>
    myproc()->tf = tf;
801059c8:	e8 83 df ff ff       	call   80103950 <myproc>
801059cd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059d0:	e8 1b f0 ff ff       	call   801049f0 <syscall>
    if(myproc()->killed)
801059d5:	e8 76 df ff ff       	call   80103950 <myproc>
801059da:	8b 48 24             	mov    0x24(%eax),%ecx
801059dd:	85 c9                	test   %ecx,%ecx
801059df:	74 c9                	je     801059aa <trap+0xfa>
}
801059e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
      exit();
801059e8:	e9 83 e3 ff ff       	jmp    80103d70 <exit>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801059f0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801059f4:	75 92                	jne    80105988 <trap+0xd8>
    yield();
801059f6:	e8 a5 e4 ff ff       	call   80103ea0 <yield>
801059fb:	eb 8b                	jmp    80105988 <trap+0xd8>
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105a00:	e8 2b df ff ff       	call   80103930 <cpuid>
80105a05:	85 c0                	test   %eax,%eax
80105a07:	0f 84 c3 00 00 00    	je     80105ad0 <trap+0x220>
    lapiceoi();
80105a0d:	e8 9e ce ff ff       	call   801028b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a12:	e8 39 df ff ff       	call   80103950 <myproc>
80105a17:	85 c0                	test   %eax,%eax
80105a19:	0f 85 38 ff ff ff    	jne    80105957 <trap+0xa7>
80105a1f:	e9 50 ff ff ff       	jmp    80105974 <trap+0xc4>
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105a28:	e8 43 cd ff ff       	call   80102770 <kbdintr>
    lapiceoi();
80105a2d:	e8 7e ce ff ff       	call   801028b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a32:	e8 19 df ff ff       	call   80103950 <myproc>
80105a37:	85 c0                	test   %eax,%eax
80105a39:	0f 85 18 ff ff ff    	jne    80105957 <trap+0xa7>
80105a3f:	e9 30 ff ff ff       	jmp    80105974 <trap+0xc4>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105a48:	e8 53 02 00 00       	call   80105ca0 <uartintr>
    lapiceoi();
80105a4d:	e8 5e ce ff ff       	call   801028b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a52:	e8 f9 de ff ff       	call   80103950 <myproc>
80105a57:	85 c0                	test   %eax,%eax
80105a59:	0f 85 f8 fe ff ff    	jne    80105957 <trap+0xa7>
80105a5f:	e9 10 ff ff ff       	jmp    80105974 <trap+0xc4>
80105a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a68:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a6c:	8b 77 38             	mov    0x38(%edi),%esi
80105a6f:	e8 bc de ff ff       	call   80103930 <cpuid>
80105a74:	56                   	push   %esi
80105a75:	53                   	push   %ebx
80105a76:	50                   	push   %eax
80105a77:	68 e4 81 10 80       	push   $0x801081e4
80105a7c:	e8 df ab ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105a81:	e8 2a ce ff ff       	call   801028b0 <lapiceoi>
    break;
80105a86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a89:	e8 c2 de ff ff       	call   80103950 <myproc>
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	0f 85 c1 fe ff ff    	jne    80105957 <trap+0xa7>
80105a96:	e9 d9 fe ff ff       	jmp    80105974 <trap+0xc4>
80105a9b:	90                   	nop
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105aa0:	e8 3b c7 ff ff       	call   801021e0 <ideintr>
80105aa5:	e9 63 ff ff ff       	jmp    80105a0d <trap+0x15d>
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ab0:	e8 bb e2 ff ff       	call   80103d70 <exit>
80105ab5:	e9 0e ff ff ff       	jmp    801059c8 <trap+0x118>
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105ac0:	e8 ab e2 ff ff       	call   80103d70 <exit>
80105ac5:	e9 aa fe ff ff       	jmp    80105974 <trap+0xc4>
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	68 a0 5c 11 80       	push   $0x80115ca0
80105ad8:	e8 13 ea ff ff       	call   801044f0 <acquire>
      wakeup(&ticks);
80105add:	c7 04 24 e0 64 11 80 	movl   $0x801164e0,(%esp)
      ticks++;
80105ae4:	83 05 e0 64 11 80 01 	addl   $0x1,0x801164e0
      wakeup(&ticks);
80105aeb:	e8 b0 e5 ff ff       	call   801040a0 <wakeup>
      release(&tickslock);
80105af0:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
80105af7:	e8 b4 ea ff ff       	call   801045b0 <release>
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	e9 09 ff ff ff       	jmp    80105a0d <trap+0x15d>
80105b04:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b07:	e8 24 de ff ff       	call   80103930 <cpuid>
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	56                   	push   %esi
80105b10:	53                   	push   %ebx
80105b11:	50                   	push   %eax
80105b12:	ff 77 30             	pushl  0x30(%edi)
80105b15:	68 08 82 10 80       	push   $0x80108208
80105b1a:	e8 41 ab ff ff       	call   80100660 <cprintf>
      panic("trap");
80105b1f:	83 c4 14             	add    $0x14,%esp
80105b22:	68 de 81 10 80       	push   $0x801081de
80105b27:	e8 64 a8 ff ff       	call   80100390 <panic>
80105b2c:	66 90                	xchg   %ax,%ax
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b30:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80105b35:	55                   	push   %ebp
80105b36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b38:	85 c0                	test   %eax,%eax
80105b3a:	74 1c                	je     80105b58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b42:	a8 01                	test   $0x1,%al
80105b44:	74 12                	je     80105b58 <uartgetc+0x28>
80105b46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b4c:	0f b6 c0             	movzbl %al,%eax
}
80105b4f:	5d                   	pop    %ebp
80105b50:	c3                   	ret    
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b5d:	5d                   	pop    %ebp
80105b5e:	c3                   	ret    
80105b5f:	90                   	nop

80105b60 <uartputc.part.0>:
uartputc(int c)
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
80105b66:	89 c7                	mov    %eax,%edi
80105b68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b72:	83 ec 0c             	sub    $0xc,%esp
80105b75:	eb 1b                	jmp    80105b92 <uartputc.part.0+0x32>
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	6a 0a                	push   $0xa
80105b85:	e8 46 cd ff ff       	call   801028d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	83 eb 01             	sub    $0x1,%ebx
80105b90:	74 07                	je     80105b99 <uartputc.part.0+0x39>
80105b92:	89 f2                	mov    %esi,%edx
80105b94:	ec                   	in     (%dx),%al
80105b95:	a8 20                	test   $0x20,%al
80105b97:	74 e7                	je     80105b80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9e:	89 f8                	mov    %edi,%eax
80105ba0:	ee                   	out    %al,(%dx)
}
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <uartinit>:
{
80105bb0:	55                   	push   %ebp
80105bb1:	31 c9                	xor    %ecx,%ecx
80105bb3:	89 c8                	mov    %ecx,%eax
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	57                   	push   %edi
80105bb8:	56                   	push   %esi
80105bb9:	53                   	push   %ebx
80105bba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105bbf:	89 da                	mov    %ebx,%edx
80105bc1:	83 ec 0c             	sub    $0xc,%esp
80105bc4:	ee                   	out    %al,(%dx)
80105bc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bcf:	89 fa                	mov    %edi,%edx
80105bd1:	ee                   	out    %al,(%dx)
80105bd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bdc:	ee                   	out    %al,(%dx)
80105bdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105be2:	89 c8                	mov    %ecx,%eax
80105be4:	89 f2                	mov    %esi,%edx
80105be6:	ee                   	out    %al,(%dx)
80105be7:	b8 03 00 00 00       	mov    $0x3,%eax
80105bec:	89 fa                	mov    %edi,%edx
80105bee:	ee                   	out    %al,(%dx)
80105bef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105bf4:	89 c8                	mov    %ecx,%eax
80105bf6:	ee                   	out    %al,(%dx)
80105bf7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bfc:	89 f2                	mov    %esi,%edx
80105bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c05:	3c ff                	cmp    $0xff,%al
80105c07:	74 5a                	je     80105c63 <uartinit+0xb3>
  uart = 1;
80105c09:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105c10:	00 00 00 
80105c13:	89 da                	mov    %ebx,%edx
80105c15:	ec                   	in     (%dx),%al
80105c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105c1f:	bb 00 83 10 80       	mov    $0x80108300,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c24:	6a 00                	push   $0x0
80105c26:	6a 04                	push   $0x4
80105c28:	e8 03 c8 ff ff       	call   80102430 <ioapicenable>
80105c2d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105c30:	b8 78 00 00 00       	mov    $0x78,%eax
80105c35:	eb 13                	jmp    80105c4a <uartinit+0x9a>
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c40:	83 c3 01             	add    $0x1,%ebx
80105c43:	0f be 03             	movsbl (%ebx),%eax
80105c46:	84 c0                	test   %al,%al
80105c48:	74 19                	je     80105c63 <uartinit+0xb3>
  if(!uart)
80105c4a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105c50:	85 d2                	test   %edx,%edx
80105c52:	74 ec                	je     80105c40 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105c54:	83 c3 01             	add    $0x1,%ebx
80105c57:	e8 04 ff ff ff       	call   80105b60 <uartputc.part.0>
80105c5c:	0f be 03             	movsbl (%ebx),%eax
80105c5f:	84 c0                	test   %al,%al
80105c61:	75 e7                	jne    80105c4a <uartinit+0x9a>
}
80105c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c66:	5b                   	pop    %ebx
80105c67:	5e                   	pop    %esi
80105c68:	5f                   	pop    %edi
80105c69:	5d                   	pop    %ebp
80105c6a:	c3                   	ret    
80105c6b:	90                   	nop
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <uartputc>:
  if(!uart)
80105c70:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80105c76:	55                   	push   %ebp
80105c77:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c79:	85 d2                	test   %edx,%edx
{
80105c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c7e:	74 10                	je     80105c90 <uartputc+0x20>
}
80105c80:	5d                   	pop    %ebp
80105c81:	e9 da fe ff ff       	jmp    80105b60 <uartputc.part.0>
80105c86:	8d 76 00             	lea    0x0(%esi),%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c90:	5d                   	pop    %ebp
80105c91:	c3                   	ret    
80105c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ca0 <uartintr>:

void
uartintr(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ca6:	68 30 5b 10 80       	push   $0x80105b30
80105cab:	e8 60 ab ff ff       	call   80100810 <consoleintr>
}
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	c9                   	leave  
80105cb4:	c3                   	ret    

80105cb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $0
80105cb7:	6a 00                	push   $0x0
  jmp alltraps
80105cb9:	e9 1c fb ff ff       	jmp    801057da <alltraps>

80105cbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $1
80105cc0:	6a 01                	push   $0x1
  jmp alltraps
80105cc2:	e9 13 fb ff ff       	jmp    801057da <alltraps>

80105cc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $2
80105cc9:	6a 02                	push   $0x2
  jmp alltraps
80105ccb:	e9 0a fb ff ff       	jmp    801057da <alltraps>

80105cd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $3
80105cd2:	6a 03                	push   $0x3
  jmp alltraps
80105cd4:	e9 01 fb ff ff       	jmp    801057da <alltraps>

80105cd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $4
80105cdb:	6a 04                	push   $0x4
  jmp alltraps
80105cdd:	e9 f8 fa ff ff       	jmp    801057da <alltraps>

80105ce2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $5
80105ce4:	6a 05                	push   $0x5
  jmp alltraps
80105ce6:	e9 ef fa ff ff       	jmp    801057da <alltraps>

80105ceb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $6
80105ced:	6a 06                	push   $0x6
  jmp alltraps
80105cef:	e9 e6 fa ff ff       	jmp    801057da <alltraps>

80105cf4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $7
80105cf6:	6a 07                	push   $0x7
  jmp alltraps
80105cf8:	e9 dd fa ff ff       	jmp    801057da <alltraps>

80105cfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105cfd:	6a 08                	push   $0x8
  jmp alltraps
80105cff:	e9 d6 fa ff ff       	jmp    801057da <alltraps>

80105d04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $9
80105d06:	6a 09                	push   $0x9
  jmp alltraps
80105d08:	e9 cd fa ff ff       	jmp    801057da <alltraps>

80105d0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d0d:	6a 0a                	push   $0xa
  jmp alltraps
80105d0f:	e9 c6 fa ff ff       	jmp    801057da <alltraps>

80105d14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d14:	6a 0b                	push   $0xb
  jmp alltraps
80105d16:	e9 bf fa ff ff       	jmp    801057da <alltraps>

80105d1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d1b:	6a 0c                	push   $0xc
  jmp alltraps
80105d1d:	e9 b8 fa ff ff       	jmp    801057da <alltraps>

80105d22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d22:	6a 0d                	push   $0xd
  jmp alltraps
80105d24:	e9 b1 fa ff ff       	jmp    801057da <alltraps>

80105d29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d29:	6a 0e                	push   $0xe
  jmp alltraps
80105d2b:	e9 aa fa ff ff       	jmp    801057da <alltraps>

80105d30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $15
80105d32:	6a 0f                	push   $0xf
  jmp alltraps
80105d34:	e9 a1 fa ff ff       	jmp    801057da <alltraps>

80105d39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $16
80105d3b:	6a 10                	push   $0x10
  jmp alltraps
80105d3d:	e9 98 fa ff ff       	jmp    801057da <alltraps>

80105d42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d42:	6a 11                	push   $0x11
  jmp alltraps
80105d44:	e9 91 fa ff ff       	jmp    801057da <alltraps>

80105d49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $18
80105d4b:	6a 12                	push   $0x12
  jmp alltraps
80105d4d:	e9 88 fa ff ff       	jmp    801057da <alltraps>

80105d52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $19
80105d54:	6a 13                	push   $0x13
  jmp alltraps
80105d56:	e9 7f fa ff ff       	jmp    801057da <alltraps>

80105d5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $20
80105d5d:	6a 14                	push   $0x14
  jmp alltraps
80105d5f:	e9 76 fa ff ff       	jmp    801057da <alltraps>

80105d64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $21
80105d66:	6a 15                	push   $0x15
  jmp alltraps
80105d68:	e9 6d fa ff ff       	jmp    801057da <alltraps>

80105d6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $22
80105d6f:	6a 16                	push   $0x16
  jmp alltraps
80105d71:	e9 64 fa ff ff       	jmp    801057da <alltraps>

80105d76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $23
80105d78:	6a 17                	push   $0x17
  jmp alltraps
80105d7a:	e9 5b fa ff ff       	jmp    801057da <alltraps>

80105d7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $24
80105d81:	6a 18                	push   $0x18
  jmp alltraps
80105d83:	e9 52 fa ff ff       	jmp    801057da <alltraps>

80105d88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $25
80105d8a:	6a 19                	push   $0x19
  jmp alltraps
80105d8c:	e9 49 fa ff ff       	jmp    801057da <alltraps>

80105d91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $26
80105d93:	6a 1a                	push   $0x1a
  jmp alltraps
80105d95:	e9 40 fa ff ff       	jmp    801057da <alltraps>

80105d9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $27
80105d9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d9e:	e9 37 fa ff ff       	jmp    801057da <alltraps>

80105da3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $28
80105da5:	6a 1c                	push   $0x1c
  jmp alltraps
80105da7:	e9 2e fa ff ff       	jmp    801057da <alltraps>

80105dac <vector29>:
.globl vector29
vector29:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $29
80105dae:	6a 1d                	push   $0x1d
  jmp alltraps
80105db0:	e9 25 fa ff ff       	jmp    801057da <alltraps>

80105db5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $30
80105db7:	6a 1e                	push   $0x1e
  jmp alltraps
80105db9:	e9 1c fa ff ff       	jmp    801057da <alltraps>

80105dbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $31
80105dc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105dc2:	e9 13 fa ff ff       	jmp    801057da <alltraps>

80105dc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $32
80105dc9:	6a 20                	push   $0x20
  jmp alltraps
80105dcb:	e9 0a fa ff ff       	jmp    801057da <alltraps>

80105dd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $33
80105dd2:	6a 21                	push   $0x21
  jmp alltraps
80105dd4:	e9 01 fa ff ff       	jmp    801057da <alltraps>

80105dd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $34
80105ddb:	6a 22                	push   $0x22
  jmp alltraps
80105ddd:	e9 f8 f9 ff ff       	jmp    801057da <alltraps>

80105de2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $35
80105de4:	6a 23                	push   $0x23
  jmp alltraps
80105de6:	e9 ef f9 ff ff       	jmp    801057da <alltraps>

80105deb <vector36>:
.globl vector36
vector36:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $36
80105ded:	6a 24                	push   $0x24
  jmp alltraps
80105def:	e9 e6 f9 ff ff       	jmp    801057da <alltraps>

80105df4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $37
80105df6:	6a 25                	push   $0x25
  jmp alltraps
80105df8:	e9 dd f9 ff ff       	jmp    801057da <alltraps>

80105dfd <vector38>:
.globl vector38
vector38:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $38
80105dff:	6a 26                	push   $0x26
  jmp alltraps
80105e01:	e9 d4 f9 ff ff       	jmp    801057da <alltraps>

80105e06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $39
80105e08:	6a 27                	push   $0x27
  jmp alltraps
80105e0a:	e9 cb f9 ff ff       	jmp    801057da <alltraps>

80105e0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $40
80105e11:	6a 28                	push   $0x28
  jmp alltraps
80105e13:	e9 c2 f9 ff ff       	jmp    801057da <alltraps>

80105e18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $41
80105e1a:	6a 29                	push   $0x29
  jmp alltraps
80105e1c:	e9 b9 f9 ff ff       	jmp    801057da <alltraps>

80105e21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $42
80105e23:	6a 2a                	push   $0x2a
  jmp alltraps
80105e25:	e9 b0 f9 ff ff       	jmp    801057da <alltraps>

80105e2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $43
80105e2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e2e:	e9 a7 f9 ff ff       	jmp    801057da <alltraps>

80105e33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $44
80105e35:	6a 2c                	push   $0x2c
  jmp alltraps
80105e37:	e9 9e f9 ff ff       	jmp    801057da <alltraps>

80105e3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $45
80105e3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e40:	e9 95 f9 ff ff       	jmp    801057da <alltraps>

80105e45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $46
80105e47:	6a 2e                	push   $0x2e
  jmp alltraps
80105e49:	e9 8c f9 ff ff       	jmp    801057da <alltraps>

80105e4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $47
80105e50:	6a 2f                	push   $0x2f
  jmp alltraps
80105e52:	e9 83 f9 ff ff       	jmp    801057da <alltraps>

80105e57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $48
80105e59:	6a 30                	push   $0x30
  jmp alltraps
80105e5b:	e9 7a f9 ff ff       	jmp    801057da <alltraps>

80105e60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $49
80105e62:	6a 31                	push   $0x31
  jmp alltraps
80105e64:	e9 71 f9 ff ff       	jmp    801057da <alltraps>

80105e69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $50
80105e6b:	6a 32                	push   $0x32
  jmp alltraps
80105e6d:	e9 68 f9 ff ff       	jmp    801057da <alltraps>

80105e72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $51
80105e74:	6a 33                	push   $0x33
  jmp alltraps
80105e76:	e9 5f f9 ff ff       	jmp    801057da <alltraps>

80105e7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $52
80105e7d:	6a 34                	push   $0x34
  jmp alltraps
80105e7f:	e9 56 f9 ff ff       	jmp    801057da <alltraps>

80105e84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $53
80105e86:	6a 35                	push   $0x35
  jmp alltraps
80105e88:	e9 4d f9 ff ff       	jmp    801057da <alltraps>

80105e8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $54
80105e8f:	6a 36                	push   $0x36
  jmp alltraps
80105e91:	e9 44 f9 ff ff       	jmp    801057da <alltraps>

80105e96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $55
80105e98:	6a 37                	push   $0x37
  jmp alltraps
80105e9a:	e9 3b f9 ff ff       	jmp    801057da <alltraps>

80105e9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $56
80105ea1:	6a 38                	push   $0x38
  jmp alltraps
80105ea3:	e9 32 f9 ff ff       	jmp    801057da <alltraps>

80105ea8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $57
80105eaa:	6a 39                	push   $0x39
  jmp alltraps
80105eac:	e9 29 f9 ff ff       	jmp    801057da <alltraps>

80105eb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $58
80105eb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105eb5:	e9 20 f9 ff ff       	jmp    801057da <alltraps>

80105eba <vector59>:
.globl vector59
vector59:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $59
80105ebc:	6a 3b                	push   $0x3b
  jmp alltraps
80105ebe:	e9 17 f9 ff ff       	jmp    801057da <alltraps>

80105ec3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $60
80105ec5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ec7:	e9 0e f9 ff ff       	jmp    801057da <alltraps>

80105ecc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $61
80105ece:	6a 3d                	push   $0x3d
  jmp alltraps
80105ed0:	e9 05 f9 ff ff       	jmp    801057da <alltraps>

80105ed5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $62
80105ed7:	6a 3e                	push   $0x3e
  jmp alltraps
80105ed9:	e9 fc f8 ff ff       	jmp    801057da <alltraps>

80105ede <vector63>:
.globl vector63
vector63:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $63
80105ee0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ee2:	e9 f3 f8 ff ff       	jmp    801057da <alltraps>

80105ee7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $64
80105ee9:	6a 40                	push   $0x40
  jmp alltraps
80105eeb:	e9 ea f8 ff ff       	jmp    801057da <alltraps>

80105ef0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $65
80105ef2:	6a 41                	push   $0x41
  jmp alltraps
80105ef4:	e9 e1 f8 ff ff       	jmp    801057da <alltraps>

80105ef9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $66
80105efb:	6a 42                	push   $0x42
  jmp alltraps
80105efd:	e9 d8 f8 ff ff       	jmp    801057da <alltraps>

80105f02 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $67
80105f04:	6a 43                	push   $0x43
  jmp alltraps
80105f06:	e9 cf f8 ff ff       	jmp    801057da <alltraps>

80105f0b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $68
80105f0d:	6a 44                	push   $0x44
  jmp alltraps
80105f0f:	e9 c6 f8 ff ff       	jmp    801057da <alltraps>

80105f14 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $69
80105f16:	6a 45                	push   $0x45
  jmp alltraps
80105f18:	e9 bd f8 ff ff       	jmp    801057da <alltraps>

80105f1d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $70
80105f1f:	6a 46                	push   $0x46
  jmp alltraps
80105f21:	e9 b4 f8 ff ff       	jmp    801057da <alltraps>

80105f26 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $71
80105f28:	6a 47                	push   $0x47
  jmp alltraps
80105f2a:	e9 ab f8 ff ff       	jmp    801057da <alltraps>

80105f2f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $72
80105f31:	6a 48                	push   $0x48
  jmp alltraps
80105f33:	e9 a2 f8 ff ff       	jmp    801057da <alltraps>

80105f38 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $73
80105f3a:	6a 49                	push   $0x49
  jmp alltraps
80105f3c:	e9 99 f8 ff ff       	jmp    801057da <alltraps>

80105f41 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $74
80105f43:	6a 4a                	push   $0x4a
  jmp alltraps
80105f45:	e9 90 f8 ff ff       	jmp    801057da <alltraps>

80105f4a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $75
80105f4c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f4e:	e9 87 f8 ff ff       	jmp    801057da <alltraps>

80105f53 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $76
80105f55:	6a 4c                	push   $0x4c
  jmp alltraps
80105f57:	e9 7e f8 ff ff       	jmp    801057da <alltraps>

80105f5c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $77
80105f5e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f60:	e9 75 f8 ff ff       	jmp    801057da <alltraps>

80105f65 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $78
80105f67:	6a 4e                	push   $0x4e
  jmp alltraps
80105f69:	e9 6c f8 ff ff       	jmp    801057da <alltraps>

80105f6e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $79
80105f70:	6a 4f                	push   $0x4f
  jmp alltraps
80105f72:	e9 63 f8 ff ff       	jmp    801057da <alltraps>

80105f77 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $80
80105f79:	6a 50                	push   $0x50
  jmp alltraps
80105f7b:	e9 5a f8 ff ff       	jmp    801057da <alltraps>

80105f80 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $81
80105f82:	6a 51                	push   $0x51
  jmp alltraps
80105f84:	e9 51 f8 ff ff       	jmp    801057da <alltraps>

80105f89 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $82
80105f8b:	6a 52                	push   $0x52
  jmp alltraps
80105f8d:	e9 48 f8 ff ff       	jmp    801057da <alltraps>

80105f92 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $83
80105f94:	6a 53                	push   $0x53
  jmp alltraps
80105f96:	e9 3f f8 ff ff       	jmp    801057da <alltraps>

80105f9b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $84
80105f9d:	6a 54                	push   $0x54
  jmp alltraps
80105f9f:	e9 36 f8 ff ff       	jmp    801057da <alltraps>

80105fa4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $85
80105fa6:	6a 55                	push   $0x55
  jmp alltraps
80105fa8:	e9 2d f8 ff ff       	jmp    801057da <alltraps>

80105fad <vector86>:
.globl vector86
vector86:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $86
80105faf:	6a 56                	push   $0x56
  jmp alltraps
80105fb1:	e9 24 f8 ff ff       	jmp    801057da <alltraps>

80105fb6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $87
80105fb8:	6a 57                	push   $0x57
  jmp alltraps
80105fba:	e9 1b f8 ff ff       	jmp    801057da <alltraps>

80105fbf <vector88>:
.globl vector88
vector88:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $88
80105fc1:	6a 58                	push   $0x58
  jmp alltraps
80105fc3:	e9 12 f8 ff ff       	jmp    801057da <alltraps>

80105fc8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $89
80105fca:	6a 59                	push   $0x59
  jmp alltraps
80105fcc:	e9 09 f8 ff ff       	jmp    801057da <alltraps>

80105fd1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $90
80105fd3:	6a 5a                	push   $0x5a
  jmp alltraps
80105fd5:	e9 00 f8 ff ff       	jmp    801057da <alltraps>

80105fda <vector91>:
.globl vector91
vector91:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $91
80105fdc:	6a 5b                	push   $0x5b
  jmp alltraps
80105fde:	e9 f7 f7 ff ff       	jmp    801057da <alltraps>

80105fe3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $92
80105fe5:	6a 5c                	push   $0x5c
  jmp alltraps
80105fe7:	e9 ee f7 ff ff       	jmp    801057da <alltraps>

80105fec <vector93>:
.globl vector93
vector93:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $93
80105fee:	6a 5d                	push   $0x5d
  jmp alltraps
80105ff0:	e9 e5 f7 ff ff       	jmp    801057da <alltraps>

80105ff5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $94
80105ff7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ff9:	e9 dc f7 ff ff       	jmp    801057da <alltraps>

80105ffe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $95
80106000:	6a 5f                	push   $0x5f
  jmp alltraps
80106002:	e9 d3 f7 ff ff       	jmp    801057da <alltraps>

80106007 <vector96>:
.globl vector96
vector96:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $96
80106009:	6a 60                	push   $0x60
  jmp alltraps
8010600b:	e9 ca f7 ff ff       	jmp    801057da <alltraps>

80106010 <vector97>:
.globl vector97
vector97:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $97
80106012:	6a 61                	push   $0x61
  jmp alltraps
80106014:	e9 c1 f7 ff ff       	jmp    801057da <alltraps>

80106019 <vector98>:
.globl vector98
vector98:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $98
8010601b:	6a 62                	push   $0x62
  jmp alltraps
8010601d:	e9 b8 f7 ff ff       	jmp    801057da <alltraps>

80106022 <vector99>:
.globl vector99
vector99:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $99
80106024:	6a 63                	push   $0x63
  jmp alltraps
80106026:	e9 af f7 ff ff       	jmp    801057da <alltraps>

8010602b <vector100>:
.globl vector100
vector100:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $100
8010602d:	6a 64                	push   $0x64
  jmp alltraps
8010602f:	e9 a6 f7 ff ff       	jmp    801057da <alltraps>

80106034 <vector101>:
.globl vector101
vector101:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $101
80106036:	6a 65                	push   $0x65
  jmp alltraps
80106038:	e9 9d f7 ff ff       	jmp    801057da <alltraps>

8010603d <vector102>:
.globl vector102
vector102:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $102
8010603f:	6a 66                	push   $0x66
  jmp alltraps
80106041:	e9 94 f7 ff ff       	jmp    801057da <alltraps>

80106046 <vector103>:
.globl vector103
vector103:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $103
80106048:	6a 67                	push   $0x67
  jmp alltraps
8010604a:	e9 8b f7 ff ff       	jmp    801057da <alltraps>

8010604f <vector104>:
.globl vector104
vector104:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $104
80106051:	6a 68                	push   $0x68
  jmp alltraps
80106053:	e9 82 f7 ff ff       	jmp    801057da <alltraps>

80106058 <vector105>:
.globl vector105
vector105:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $105
8010605a:	6a 69                	push   $0x69
  jmp alltraps
8010605c:	e9 79 f7 ff ff       	jmp    801057da <alltraps>

80106061 <vector106>:
.globl vector106
vector106:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $106
80106063:	6a 6a                	push   $0x6a
  jmp alltraps
80106065:	e9 70 f7 ff ff       	jmp    801057da <alltraps>

8010606a <vector107>:
.globl vector107
vector107:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $107
8010606c:	6a 6b                	push   $0x6b
  jmp alltraps
8010606e:	e9 67 f7 ff ff       	jmp    801057da <alltraps>

80106073 <vector108>:
.globl vector108
vector108:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $108
80106075:	6a 6c                	push   $0x6c
  jmp alltraps
80106077:	e9 5e f7 ff ff       	jmp    801057da <alltraps>

8010607c <vector109>:
.globl vector109
vector109:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $109
8010607e:	6a 6d                	push   $0x6d
  jmp alltraps
80106080:	e9 55 f7 ff ff       	jmp    801057da <alltraps>

80106085 <vector110>:
.globl vector110
vector110:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $110
80106087:	6a 6e                	push   $0x6e
  jmp alltraps
80106089:	e9 4c f7 ff ff       	jmp    801057da <alltraps>

8010608e <vector111>:
.globl vector111
vector111:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $111
80106090:	6a 6f                	push   $0x6f
  jmp alltraps
80106092:	e9 43 f7 ff ff       	jmp    801057da <alltraps>

80106097 <vector112>:
.globl vector112
vector112:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $112
80106099:	6a 70                	push   $0x70
  jmp alltraps
8010609b:	e9 3a f7 ff ff       	jmp    801057da <alltraps>

801060a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $113
801060a2:	6a 71                	push   $0x71
  jmp alltraps
801060a4:	e9 31 f7 ff ff       	jmp    801057da <alltraps>

801060a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $114
801060ab:	6a 72                	push   $0x72
  jmp alltraps
801060ad:	e9 28 f7 ff ff       	jmp    801057da <alltraps>

801060b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $115
801060b4:	6a 73                	push   $0x73
  jmp alltraps
801060b6:	e9 1f f7 ff ff       	jmp    801057da <alltraps>

801060bb <vector116>:
.globl vector116
vector116:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $116
801060bd:	6a 74                	push   $0x74
  jmp alltraps
801060bf:	e9 16 f7 ff ff       	jmp    801057da <alltraps>

801060c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $117
801060c6:	6a 75                	push   $0x75
  jmp alltraps
801060c8:	e9 0d f7 ff ff       	jmp    801057da <alltraps>

801060cd <vector118>:
.globl vector118
vector118:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $118
801060cf:	6a 76                	push   $0x76
  jmp alltraps
801060d1:	e9 04 f7 ff ff       	jmp    801057da <alltraps>

801060d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $119
801060d8:	6a 77                	push   $0x77
  jmp alltraps
801060da:	e9 fb f6 ff ff       	jmp    801057da <alltraps>

801060df <vector120>:
.globl vector120
vector120:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $120
801060e1:	6a 78                	push   $0x78
  jmp alltraps
801060e3:	e9 f2 f6 ff ff       	jmp    801057da <alltraps>

801060e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $121
801060ea:	6a 79                	push   $0x79
  jmp alltraps
801060ec:	e9 e9 f6 ff ff       	jmp    801057da <alltraps>

801060f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $122
801060f3:	6a 7a                	push   $0x7a
  jmp alltraps
801060f5:	e9 e0 f6 ff ff       	jmp    801057da <alltraps>

801060fa <vector123>:
.globl vector123
vector123:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $123
801060fc:	6a 7b                	push   $0x7b
  jmp alltraps
801060fe:	e9 d7 f6 ff ff       	jmp    801057da <alltraps>

80106103 <vector124>:
.globl vector124
vector124:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $124
80106105:	6a 7c                	push   $0x7c
  jmp alltraps
80106107:	e9 ce f6 ff ff       	jmp    801057da <alltraps>

8010610c <vector125>:
.globl vector125
vector125:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $125
8010610e:	6a 7d                	push   $0x7d
  jmp alltraps
80106110:	e9 c5 f6 ff ff       	jmp    801057da <alltraps>

80106115 <vector126>:
.globl vector126
vector126:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $126
80106117:	6a 7e                	push   $0x7e
  jmp alltraps
80106119:	e9 bc f6 ff ff       	jmp    801057da <alltraps>

8010611e <vector127>:
.globl vector127
vector127:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $127
80106120:	6a 7f                	push   $0x7f
  jmp alltraps
80106122:	e9 b3 f6 ff ff       	jmp    801057da <alltraps>

80106127 <vector128>:
.globl vector128
vector128:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $128
80106129:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010612e:	e9 a7 f6 ff ff       	jmp    801057da <alltraps>

80106133 <vector129>:
.globl vector129
vector129:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $129
80106135:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010613a:	e9 9b f6 ff ff       	jmp    801057da <alltraps>

8010613f <vector130>:
.globl vector130
vector130:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $130
80106141:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106146:	e9 8f f6 ff ff       	jmp    801057da <alltraps>

8010614b <vector131>:
.globl vector131
vector131:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $131
8010614d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106152:	e9 83 f6 ff ff       	jmp    801057da <alltraps>

80106157 <vector132>:
.globl vector132
vector132:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $132
80106159:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010615e:	e9 77 f6 ff ff       	jmp    801057da <alltraps>

80106163 <vector133>:
.globl vector133
vector133:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $133
80106165:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010616a:	e9 6b f6 ff ff       	jmp    801057da <alltraps>

8010616f <vector134>:
.globl vector134
vector134:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $134
80106171:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106176:	e9 5f f6 ff ff       	jmp    801057da <alltraps>

8010617b <vector135>:
.globl vector135
vector135:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $135
8010617d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106182:	e9 53 f6 ff ff       	jmp    801057da <alltraps>

80106187 <vector136>:
.globl vector136
vector136:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $136
80106189:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010618e:	e9 47 f6 ff ff       	jmp    801057da <alltraps>

80106193 <vector137>:
.globl vector137
vector137:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $137
80106195:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010619a:	e9 3b f6 ff ff       	jmp    801057da <alltraps>

8010619f <vector138>:
.globl vector138
vector138:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $138
801061a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061a6:	e9 2f f6 ff ff       	jmp    801057da <alltraps>

801061ab <vector139>:
.globl vector139
vector139:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $139
801061ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061b2:	e9 23 f6 ff ff       	jmp    801057da <alltraps>

801061b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $140
801061b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061be:	e9 17 f6 ff ff       	jmp    801057da <alltraps>

801061c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $141
801061c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061ca:	e9 0b f6 ff ff       	jmp    801057da <alltraps>

801061cf <vector142>:
.globl vector142
vector142:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $142
801061d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061d6:	e9 ff f5 ff ff       	jmp    801057da <alltraps>

801061db <vector143>:
.globl vector143
vector143:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $143
801061dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061e2:	e9 f3 f5 ff ff       	jmp    801057da <alltraps>

801061e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $144
801061e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061ee:	e9 e7 f5 ff ff       	jmp    801057da <alltraps>

801061f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $145
801061f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061fa:	e9 db f5 ff ff       	jmp    801057da <alltraps>

801061ff <vector146>:
.globl vector146
vector146:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $146
80106201:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106206:	e9 cf f5 ff ff       	jmp    801057da <alltraps>

8010620b <vector147>:
.globl vector147
vector147:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $147
8010620d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106212:	e9 c3 f5 ff ff       	jmp    801057da <alltraps>

80106217 <vector148>:
.globl vector148
vector148:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $148
80106219:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010621e:	e9 b7 f5 ff ff       	jmp    801057da <alltraps>

80106223 <vector149>:
.globl vector149
vector149:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $149
80106225:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010622a:	e9 ab f5 ff ff       	jmp    801057da <alltraps>

8010622f <vector150>:
.globl vector150
vector150:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $150
80106231:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106236:	e9 9f f5 ff ff       	jmp    801057da <alltraps>

8010623b <vector151>:
.globl vector151
vector151:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $151
8010623d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106242:	e9 93 f5 ff ff       	jmp    801057da <alltraps>

80106247 <vector152>:
.globl vector152
vector152:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $152
80106249:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010624e:	e9 87 f5 ff ff       	jmp    801057da <alltraps>

80106253 <vector153>:
.globl vector153
vector153:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $153
80106255:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010625a:	e9 7b f5 ff ff       	jmp    801057da <alltraps>

8010625f <vector154>:
.globl vector154
vector154:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $154
80106261:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106266:	e9 6f f5 ff ff       	jmp    801057da <alltraps>

8010626b <vector155>:
.globl vector155
vector155:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $155
8010626d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106272:	e9 63 f5 ff ff       	jmp    801057da <alltraps>

80106277 <vector156>:
.globl vector156
vector156:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $156
80106279:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010627e:	e9 57 f5 ff ff       	jmp    801057da <alltraps>

80106283 <vector157>:
.globl vector157
vector157:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $157
80106285:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010628a:	e9 4b f5 ff ff       	jmp    801057da <alltraps>

8010628f <vector158>:
.globl vector158
vector158:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $158
80106291:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106296:	e9 3f f5 ff ff       	jmp    801057da <alltraps>

8010629b <vector159>:
.globl vector159
vector159:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $159
8010629d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062a2:	e9 33 f5 ff ff       	jmp    801057da <alltraps>

801062a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $160
801062a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062ae:	e9 27 f5 ff ff       	jmp    801057da <alltraps>

801062b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $161
801062b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062ba:	e9 1b f5 ff ff       	jmp    801057da <alltraps>

801062bf <vector162>:
.globl vector162
vector162:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $162
801062c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062c6:	e9 0f f5 ff ff       	jmp    801057da <alltraps>

801062cb <vector163>:
.globl vector163
vector163:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $163
801062cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062d2:	e9 03 f5 ff ff       	jmp    801057da <alltraps>

801062d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $164
801062d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062de:	e9 f7 f4 ff ff       	jmp    801057da <alltraps>

801062e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $165
801062e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062ea:	e9 eb f4 ff ff       	jmp    801057da <alltraps>

801062ef <vector166>:
.globl vector166
vector166:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $166
801062f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062f6:	e9 df f4 ff ff       	jmp    801057da <alltraps>

801062fb <vector167>:
.globl vector167
vector167:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $167
801062fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106302:	e9 d3 f4 ff ff       	jmp    801057da <alltraps>

80106307 <vector168>:
.globl vector168
vector168:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $168
80106309:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010630e:	e9 c7 f4 ff ff       	jmp    801057da <alltraps>

80106313 <vector169>:
.globl vector169
vector169:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $169
80106315:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010631a:	e9 bb f4 ff ff       	jmp    801057da <alltraps>

8010631f <vector170>:
.globl vector170
vector170:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $170
80106321:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106326:	e9 af f4 ff ff       	jmp    801057da <alltraps>

8010632b <vector171>:
.globl vector171
vector171:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $171
8010632d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106332:	e9 a3 f4 ff ff       	jmp    801057da <alltraps>

80106337 <vector172>:
.globl vector172
vector172:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $172
80106339:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010633e:	e9 97 f4 ff ff       	jmp    801057da <alltraps>

80106343 <vector173>:
.globl vector173
vector173:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $173
80106345:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010634a:	e9 8b f4 ff ff       	jmp    801057da <alltraps>

8010634f <vector174>:
.globl vector174
vector174:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $174
80106351:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106356:	e9 7f f4 ff ff       	jmp    801057da <alltraps>

8010635b <vector175>:
.globl vector175
vector175:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $175
8010635d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106362:	e9 73 f4 ff ff       	jmp    801057da <alltraps>

80106367 <vector176>:
.globl vector176
vector176:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $176
80106369:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010636e:	e9 67 f4 ff ff       	jmp    801057da <alltraps>

80106373 <vector177>:
.globl vector177
vector177:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $177
80106375:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010637a:	e9 5b f4 ff ff       	jmp    801057da <alltraps>

8010637f <vector178>:
.globl vector178
vector178:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $178
80106381:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106386:	e9 4f f4 ff ff       	jmp    801057da <alltraps>

8010638b <vector179>:
.globl vector179
vector179:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $179
8010638d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106392:	e9 43 f4 ff ff       	jmp    801057da <alltraps>

80106397 <vector180>:
.globl vector180
vector180:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $180
80106399:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010639e:	e9 37 f4 ff ff       	jmp    801057da <alltraps>

801063a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $181
801063a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063aa:	e9 2b f4 ff ff       	jmp    801057da <alltraps>

801063af <vector182>:
.globl vector182
vector182:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $182
801063b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063b6:	e9 1f f4 ff ff       	jmp    801057da <alltraps>

801063bb <vector183>:
.globl vector183
vector183:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $183
801063bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063c2:	e9 13 f4 ff ff       	jmp    801057da <alltraps>

801063c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $184
801063c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063ce:	e9 07 f4 ff ff       	jmp    801057da <alltraps>

801063d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $185
801063d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063da:	e9 fb f3 ff ff       	jmp    801057da <alltraps>

801063df <vector186>:
.globl vector186
vector186:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $186
801063e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063e6:	e9 ef f3 ff ff       	jmp    801057da <alltraps>

801063eb <vector187>:
.globl vector187
vector187:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $187
801063ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063f2:	e9 e3 f3 ff ff       	jmp    801057da <alltraps>

801063f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $188
801063f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063fe:	e9 d7 f3 ff ff       	jmp    801057da <alltraps>

80106403 <vector189>:
.globl vector189
vector189:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $189
80106405:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010640a:	e9 cb f3 ff ff       	jmp    801057da <alltraps>

8010640f <vector190>:
.globl vector190
vector190:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $190
80106411:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106416:	e9 bf f3 ff ff       	jmp    801057da <alltraps>

8010641b <vector191>:
.globl vector191
vector191:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $191
8010641d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106422:	e9 b3 f3 ff ff       	jmp    801057da <alltraps>

80106427 <vector192>:
.globl vector192
vector192:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $192
80106429:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010642e:	e9 a7 f3 ff ff       	jmp    801057da <alltraps>

80106433 <vector193>:
.globl vector193
vector193:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $193
80106435:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010643a:	e9 9b f3 ff ff       	jmp    801057da <alltraps>

8010643f <vector194>:
.globl vector194
vector194:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $194
80106441:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106446:	e9 8f f3 ff ff       	jmp    801057da <alltraps>

8010644b <vector195>:
.globl vector195
vector195:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $195
8010644d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106452:	e9 83 f3 ff ff       	jmp    801057da <alltraps>

80106457 <vector196>:
.globl vector196
vector196:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $196
80106459:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010645e:	e9 77 f3 ff ff       	jmp    801057da <alltraps>

80106463 <vector197>:
.globl vector197
vector197:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $197
80106465:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010646a:	e9 6b f3 ff ff       	jmp    801057da <alltraps>

8010646f <vector198>:
.globl vector198
vector198:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $198
80106471:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106476:	e9 5f f3 ff ff       	jmp    801057da <alltraps>

8010647b <vector199>:
.globl vector199
vector199:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $199
8010647d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106482:	e9 53 f3 ff ff       	jmp    801057da <alltraps>

80106487 <vector200>:
.globl vector200
vector200:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $200
80106489:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010648e:	e9 47 f3 ff ff       	jmp    801057da <alltraps>

80106493 <vector201>:
.globl vector201
vector201:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $201
80106495:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010649a:	e9 3b f3 ff ff       	jmp    801057da <alltraps>

8010649f <vector202>:
.globl vector202
vector202:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $202
801064a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064a6:	e9 2f f3 ff ff       	jmp    801057da <alltraps>

801064ab <vector203>:
.globl vector203
vector203:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $203
801064ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064b2:	e9 23 f3 ff ff       	jmp    801057da <alltraps>

801064b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $204
801064b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064be:	e9 17 f3 ff ff       	jmp    801057da <alltraps>

801064c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $205
801064c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064ca:	e9 0b f3 ff ff       	jmp    801057da <alltraps>

801064cf <vector206>:
.globl vector206
vector206:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $206
801064d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064d6:	e9 ff f2 ff ff       	jmp    801057da <alltraps>

801064db <vector207>:
.globl vector207
vector207:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $207
801064dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064e2:	e9 f3 f2 ff ff       	jmp    801057da <alltraps>

801064e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $208
801064e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064ee:	e9 e7 f2 ff ff       	jmp    801057da <alltraps>

801064f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $209
801064f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064fa:	e9 db f2 ff ff       	jmp    801057da <alltraps>

801064ff <vector210>:
.globl vector210
vector210:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $210
80106501:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106506:	e9 cf f2 ff ff       	jmp    801057da <alltraps>

8010650b <vector211>:
.globl vector211
vector211:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $211
8010650d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106512:	e9 c3 f2 ff ff       	jmp    801057da <alltraps>

80106517 <vector212>:
.globl vector212
vector212:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $212
80106519:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010651e:	e9 b7 f2 ff ff       	jmp    801057da <alltraps>

80106523 <vector213>:
.globl vector213
vector213:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $213
80106525:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010652a:	e9 ab f2 ff ff       	jmp    801057da <alltraps>

8010652f <vector214>:
.globl vector214
vector214:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $214
80106531:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106536:	e9 9f f2 ff ff       	jmp    801057da <alltraps>

8010653b <vector215>:
.globl vector215
vector215:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $215
8010653d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106542:	e9 93 f2 ff ff       	jmp    801057da <alltraps>

80106547 <vector216>:
.globl vector216
vector216:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $216
80106549:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010654e:	e9 87 f2 ff ff       	jmp    801057da <alltraps>

80106553 <vector217>:
.globl vector217
vector217:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $217
80106555:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010655a:	e9 7b f2 ff ff       	jmp    801057da <alltraps>

8010655f <vector218>:
.globl vector218
vector218:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $218
80106561:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106566:	e9 6f f2 ff ff       	jmp    801057da <alltraps>

8010656b <vector219>:
.globl vector219
vector219:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $219
8010656d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106572:	e9 63 f2 ff ff       	jmp    801057da <alltraps>

80106577 <vector220>:
.globl vector220
vector220:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $220
80106579:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010657e:	e9 57 f2 ff ff       	jmp    801057da <alltraps>

80106583 <vector221>:
.globl vector221
vector221:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $221
80106585:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010658a:	e9 4b f2 ff ff       	jmp    801057da <alltraps>

8010658f <vector222>:
.globl vector222
vector222:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $222
80106591:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106596:	e9 3f f2 ff ff       	jmp    801057da <alltraps>

8010659b <vector223>:
.globl vector223
vector223:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $223
8010659d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065a2:	e9 33 f2 ff ff       	jmp    801057da <alltraps>

801065a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $224
801065a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065ae:	e9 27 f2 ff ff       	jmp    801057da <alltraps>

801065b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $225
801065b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065ba:	e9 1b f2 ff ff       	jmp    801057da <alltraps>

801065bf <vector226>:
.globl vector226
vector226:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $226
801065c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065c6:	e9 0f f2 ff ff       	jmp    801057da <alltraps>

801065cb <vector227>:
.globl vector227
vector227:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $227
801065cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065d2:	e9 03 f2 ff ff       	jmp    801057da <alltraps>

801065d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $228
801065d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065de:	e9 f7 f1 ff ff       	jmp    801057da <alltraps>

801065e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $229
801065e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065ea:	e9 eb f1 ff ff       	jmp    801057da <alltraps>

801065ef <vector230>:
.globl vector230
vector230:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $230
801065f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065f6:	e9 df f1 ff ff       	jmp    801057da <alltraps>

801065fb <vector231>:
.globl vector231
vector231:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $231
801065fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106602:	e9 d3 f1 ff ff       	jmp    801057da <alltraps>

80106607 <vector232>:
.globl vector232
vector232:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $232
80106609:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010660e:	e9 c7 f1 ff ff       	jmp    801057da <alltraps>

80106613 <vector233>:
.globl vector233
vector233:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $233
80106615:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010661a:	e9 bb f1 ff ff       	jmp    801057da <alltraps>

8010661f <vector234>:
.globl vector234
vector234:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $234
80106621:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106626:	e9 af f1 ff ff       	jmp    801057da <alltraps>

8010662b <vector235>:
.globl vector235
vector235:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $235
8010662d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106632:	e9 a3 f1 ff ff       	jmp    801057da <alltraps>

80106637 <vector236>:
.globl vector236
vector236:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $236
80106639:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010663e:	e9 97 f1 ff ff       	jmp    801057da <alltraps>

80106643 <vector237>:
.globl vector237
vector237:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $237
80106645:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010664a:	e9 8b f1 ff ff       	jmp    801057da <alltraps>

8010664f <vector238>:
.globl vector238
vector238:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $238
80106651:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106656:	e9 7f f1 ff ff       	jmp    801057da <alltraps>

8010665b <vector239>:
.globl vector239
vector239:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $239
8010665d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106662:	e9 73 f1 ff ff       	jmp    801057da <alltraps>

80106667 <vector240>:
.globl vector240
vector240:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $240
80106669:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010666e:	e9 67 f1 ff ff       	jmp    801057da <alltraps>

80106673 <vector241>:
.globl vector241
vector241:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $241
80106675:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010667a:	e9 5b f1 ff ff       	jmp    801057da <alltraps>

8010667f <vector242>:
.globl vector242
vector242:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $242
80106681:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106686:	e9 4f f1 ff ff       	jmp    801057da <alltraps>

8010668b <vector243>:
.globl vector243
vector243:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $243
8010668d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106692:	e9 43 f1 ff ff       	jmp    801057da <alltraps>

80106697 <vector244>:
.globl vector244
vector244:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $244
80106699:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010669e:	e9 37 f1 ff ff       	jmp    801057da <alltraps>

801066a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $245
801066a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066aa:	e9 2b f1 ff ff       	jmp    801057da <alltraps>

801066af <vector246>:
.globl vector246
vector246:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $246
801066b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066b6:	e9 1f f1 ff ff       	jmp    801057da <alltraps>

801066bb <vector247>:
.globl vector247
vector247:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $247
801066bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066c2:	e9 13 f1 ff ff       	jmp    801057da <alltraps>

801066c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $248
801066c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066ce:	e9 07 f1 ff ff       	jmp    801057da <alltraps>

801066d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $249
801066d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066da:	e9 fb f0 ff ff       	jmp    801057da <alltraps>

801066df <vector250>:
.globl vector250
vector250:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $250
801066e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066e6:	e9 ef f0 ff ff       	jmp    801057da <alltraps>

801066eb <vector251>:
.globl vector251
vector251:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $251
801066ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066f2:	e9 e3 f0 ff ff       	jmp    801057da <alltraps>

801066f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $252
801066f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066fe:	e9 d7 f0 ff ff       	jmp    801057da <alltraps>

80106703 <vector253>:
.globl vector253
vector253:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $253
80106705:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010670a:	e9 cb f0 ff ff       	jmp    801057da <alltraps>

8010670f <vector254>:
.globl vector254
vector254:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $254
80106711:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106716:	e9 bf f0 ff ff       	jmp    801057da <alltraps>

8010671b <vector255>:
.globl vector255
vector255:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $255
8010671d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106722:	e9 b3 f0 ff ff       	jmp    801057da <alltraps>
80106727:	66 90                	xchg   %ax,%ax
80106729:	66 90                	xchg   %ax,%ax
8010672b:	66 90                	xchg   %ax,%ax
8010672d:	66 90                	xchg   %ax,%ax
8010672f:	90                   	nop

80106730 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
80106735:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106736:	89 d3                	mov    %edx,%ebx
{
80106738:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010673a:	c1 eb 16             	shr    $0x16,%ebx
8010673d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106740:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106743:	8b 06                	mov    (%esi),%eax
80106745:	a8 01                	test   $0x1,%al
80106747:	74 27                	je     80106770 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106749:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010674e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106754:	c1 ef 0a             	shr    $0xa,%edi
}
80106757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010675a:	89 fa                	mov    %edi,%edx
8010675c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106762:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106765:	5b                   	pop    %ebx
80106766:	5e                   	pop    %esi
80106767:	5f                   	pop    %edi
80106768:	5d                   	pop    %ebp
80106769:	c3                   	ret    
8010676a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106770:	85 c9                	test   %ecx,%ecx
80106772:	74 2c                	je     801067a0 <walkpgdir+0x70>
80106774:	e8 a7 be ff ff       	call   80102620 <kalloc>
80106779:	85 c0                	test   %eax,%eax
8010677b:	89 c3                	mov    %eax,%ebx
8010677d:	74 21                	je     801067a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010677f:	83 ec 04             	sub    $0x4,%esp
80106782:	68 00 10 00 00       	push   $0x1000
80106787:	6a 00                	push   $0x0
80106789:	50                   	push   %eax
8010678a:	e8 71 de ff ff       	call   80104600 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010678f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106795:	83 c4 10             	add    $0x10,%esp
80106798:	83 c8 07             	or     $0x7,%eax
8010679b:	89 06                	mov    %eax,(%esi)
8010679d:	eb b5                	jmp    80106754 <walkpgdir+0x24>
8010679f:	90                   	nop
}
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067b6:	89 d3                	mov    %edx,%ebx
801067b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801067be:	83 ec 1c             	sub    $0x1c,%esp
801067c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801067cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d6:	29 df                	sub    %ebx,%edi
801067d8:	83 c8 01             	or     $0x1,%eax
801067db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067de:	eb 15                	jmp    801067f5 <mappages+0x45>
    if(*pte & PTE_P)
801067e0:	f6 00 01             	testb  $0x1,(%eax)
801067e3:	75 45                	jne    8010682a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801067e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801067e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801067eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801067ed:	74 31                	je     80106820 <mappages+0x70>
      break;
    a += PGSIZE;
801067ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801067fd:	89 da                	mov    %ebx,%edx
801067ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106802:	e8 29 ff ff ff       	call   80106730 <walkpgdir>
80106807:	85 c0                	test   %eax,%eax
80106809:	75 d5                	jne    801067e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010680b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010680e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106813:	5b                   	pop    %ebx
80106814:	5e                   	pop    %esi
80106815:	5f                   	pop    %edi
80106816:	5d                   	pop    %ebp
80106817:	c3                   	ret    
80106818:	90                   	nop
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106823:	31 c0                	xor    %eax,%eax
}
80106825:	5b                   	pop    %ebx
80106826:	5e                   	pop    %esi
80106827:	5f                   	pop    %edi
80106828:	5d                   	pop    %ebp
80106829:	c3                   	ret    
      panic("remap");
8010682a:	83 ec 0c             	sub    $0xc,%esp
8010682d:	68 08 83 10 80       	push   $0x80108308
80106832:	e8 59 9b ff ff       	call   80100390 <panic>
80106837:	89 f6                	mov    %esi,%esi
80106839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106840 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106846:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010684c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010684e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106854:	83 ec 1c             	sub    $0x1c,%esp
80106857:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010685a:	39 d3                	cmp    %edx,%ebx
8010685c:	73 66                	jae    801068c4 <deallocuvm.part.0+0x84>
8010685e:	89 d6                	mov    %edx,%esi
80106860:	eb 3d                	jmp    8010689f <deallocuvm.part.0+0x5f>
80106862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106868:	8b 10                	mov    (%eax),%edx
8010686a:	f6 c2 01             	test   $0x1,%dl
8010686d:	74 26                	je     80106895 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010686f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106875:	74 58                	je     801068cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106877:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010687a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106883:	52                   	push   %edx
80106884:	e8 e7 bb ff ff       	call   80102470 <kfree>
      *pte = 0;
80106889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106895:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010689b:	39 f3                	cmp    %esi,%ebx
8010689d:	73 25                	jae    801068c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010689f:	31 c9                	xor    %ecx,%ecx
801068a1:	89 da                	mov    %ebx,%edx
801068a3:	89 f8                	mov    %edi,%eax
801068a5:	e8 86 fe ff ff       	call   80106730 <walkpgdir>
    if(!pte)
801068aa:	85 c0                	test   %eax,%eax
801068ac:	75 ba                	jne    80106868 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068c0:	39 f3                	cmp    %esi,%ebx
801068c2:	72 db                	jb     8010689f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801068c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ca:	5b                   	pop    %ebx
801068cb:	5e                   	pop    %esi
801068cc:	5f                   	pop    %edi
801068cd:	5d                   	pop    %ebp
801068ce:	c3                   	ret    
        panic("kfree");
801068cf:	83 ec 0c             	sub    $0xc,%esp
801068d2:	68 a6 7c 10 80       	push   $0x80107ca6
801068d7:	e8 b4 9a ff ff       	call   80100390 <panic>
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068e0 <seginit>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068e6:	e8 45 d0 ff ff       	call   80103930 <cpuid>
801068eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801068f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068fa:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80106901:	ff 00 00 
80106904:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
8010690b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010690e:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80106915:	ff 00 00 
80106918:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
8010691f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106922:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
80106929:	ff 00 00 
8010692c:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80106933:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106936:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
8010693d:	ff 00 00 
80106940:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
80106947:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010694a:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
8010694f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106953:	c1 e8 10             	shr    $0x10,%eax
80106956:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010695a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010695d:	0f 01 10             	lgdtl  (%eax)
}
80106960:	c9                   	leave  
80106961:	c3                   	ret    
80106962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106970 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106970:	a1 e4 64 11 80       	mov    0x801164e4,%eax
{
80106975:	55                   	push   %ebp
80106976:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106978:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010697d:	0f 22 d8             	mov    %eax,%cr3
}
80106980:	5d                   	pop    %ebp
80106981:	c3                   	ret    
80106982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106990 <switchuvm>:
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	57                   	push   %edi
80106994:	56                   	push   %esi
80106995:	53                   	push   %ebx
80106996:	83 ec 1c             	sub    $0x1c,%esp
80106999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010699c:	85 db                	test   %ebx,%ebx
8010699e:	0f 84 cb 00 00 00    	je     80106a6f <switchuvm+0xdf>
  if(p->kstack == 0)
801069a4:	8b 43 08             	mov    0x8(%ebx),%eax
801069a7:	85 c0                	test   %eax,%eax
801069a9:	0f 84 da 00 00 00    	je     80106a89 <switchuvm+0xf9>
  if(p->pgdir == 0)
801069af:	8b 43 04             	mov    0x4(%ebx),%eax
801069b2:	85 c0                	test   %eax,%eax
801069b4:	0f 84 c2 00 00 00    	je     80106a7c <switchuvm+0xec>
  pushcli();
801069ba:	e8 61 da ff ff       	call   80104420 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069bf:	e8 ec ce ff ff       	call   801038b0 <mycpu>
801069c4:	89 c6                	mov    %eax,%esi
801069c6:	e8 e5 ce ff ff       	call   801038b0 <mycpu>
801069cb:	89 c7                	mov    %eax,%edi
801069cd:	e8 de ce ff ff       	call   801038b0 <mycpu>
801069d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069d5:	83 c7 08             	add    $0x8,%edi
801069d8:	e8 d3 ce ff ff       	call   801038b0 <mycpu>
801069dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069e0:	83 c0 08             	add    $0x8,%eax
801069e3:	ba 67 00 00 00       	mov    $0x67,%edx
801069e8:	c1 e8 18             	shr    $0x18,%eax
801069eb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801069f2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801069f9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a04:	83 c1 08             	add    $0x8,%ecx
80106a07:	c1 e9 10             	shr    $0x10,%ecx
80106a0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106a10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106a15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106a21:	e8 8a ce ff ff       	call   801038b0 <mycpu>
80106a26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a2d:	e8 7e ce ff ff       	call   801038b0 <mycpu>
80106a32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a36:	8b 73 08             	mov    0x8(%ebx),%esi
80106a39:	e8 72 ce ff ff       	call   801038b0 <mycpu>
80106a3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106a44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a47:	e8 64 ce ff ff       	call   801038b0 <mycpu>
80106a4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a50:	b8 28 00 00 00       	mov    $0x28,%eax
80106a55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a58:	8b 43 04             	mov    0x4(%ebx),%eax
80106a5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a60:	0f 22 d8             	mov    %eax,%cr3
}
80106a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a66:	5b                   	pop    %ebx
80106a67:	5e                   	pop    %esi
80106a68:	5f                   	pop    %edi
80106a69:	5d                   	pop    %ebp
  popcli();
80106a6a:	e9 f1 d9 ff ff       	jmp    80104460 <popcli>
    panic("switchuvm: no process");
80106a6f:	83 ec 0c             	sub    $0xc,%esp
80106a72:	68 0e 83 10 80       	push   $0x8010830e
80106a77:	e8 14 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106a7c:	83 ec 0c             	sub    $0xc,%esp
80106a7f:	68 39 83 10 80       	push   $0x80108339
80106a84:	e8 07 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106a89:	83 ec 0c             	sub    $0xc,%esp
80106a8c:	68 24 83 10 80       	push   $0x80108324
80106a91:	e8 fa 98 ff ff       	call   80100390 <panic>
80106a96:	8d 76 00             	lea    0x0(%esi),%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106aa0 <inituvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 75 10             	mov    0x10(%ebp),%esi
80106aac:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106ab2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106ab8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106abb:	77 49                	ja     80106b06 <inituvm+0x66>
  mem = kalloc();
80106abd:	e8 5e bb ff ff       	call   80102620 <kalloc>
  memset(mem, 0, PGSIZE);
80106ac2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106ac5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ac7:	68 00 10 00 00       	push   $0x1000
80106acc:	6a 00                	push   $0x0
80106ace:	50                   	push   %eax
80106acf:	e8 2c db ff ff       	call   80104600 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ad4:	58                   	pop    %eax
80106ad5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106adb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ae0:	5a                   	pop    %edx
80106ae1:	6a 06                	push   $0x6
80106ae3:	50                   	push   %eax
80106ae4:	31 d2                	xor    %edx,%edx
80106ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ae9:	e8 c2 fc ff ff       	call   801067b0 <mappages>
  memmove(mem, init, sz);
80106aee:	89 75 10             	mov    %esi,0x10(%ebp)
80106af1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106af4:	83 c4 10             	add    $0x10,%esp
80106af7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106afd:	5b                   	pop    %ebx
80106afe:	5e                   	pop    %esi
80106aff:	5f                   	pop    %edi
80106b00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b01:	e9 aa db ff ff       	jmp    801046b0 <memmove>
    panic("inituvm: more than a page");
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	68 4d 83 10 80       	push   $0x8010834d
80106b0e:	e8 7d 98 ff ff       	call   80100390 <panic>
80106b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b20 <loaduvm>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106b29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b30:	0f 85 91 00 00 00    	jne    80106bc7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106b36:	8b 75 18             	mov    0x18(%ebp),%esi
80106b39:	31 db                	xor    %ebx,%ebx
80106b3b:	85 f6                	test   %esi,%esi
80106b3d:	75 1a                	jne    80106b59 <loaduvm+0x39>
80106b3f:	eb 6f                	jmp    80106bb0 <loaduvm+0x90>
80106b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b57:	76 57                	jbe    80106bb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5f:	31 c9                	xor    %ecx,%ecx
80106b61:	01 da                	add    %ebx,%edx
80106b63:	e8 c8 fb ff ff       	call   80106730 <walkpgdir>
80106b68:	85 c0                	test   %eax,%eax
80106b6a:	74 4e                	je     80106bba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106b6c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106b71:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b81:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b84:	01 d9                	add    %ebx,%ecx
80106b86:	05 00 00 00 80       	add    $0x80000000,%eax
80106b8b:	57                   	push   %edi
80106b8c:	51                   	push   %ecx
80106b8d:	50                   	push   %eax
80106b8e:	ff 75 10             	pushl  0x10(%ebp)
80106b91:	e8 da ad ff ff       	call   80101970 <readi>
80106b96:	83 c4 10             	add    $0x10,%esp
80106b99:	39 f8                	cmp    %edi,%eax
80106b9b:	74 ab                	je     80106b48 <loaduvm+0x28>
}
80106b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 67 83 10 80       	push   $0x80108367
80106bc2:	e8 c9 97 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106bc7:	83 ec 0c             	sub    $0xc,%esp
80106bca:	68 08 84 10 80       	push   $0x80108408
80106bcf:	e8 bc 97 ff ff       	call   80100390 <panic>
80106bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106be0 <allocuvm>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106be9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106bec:	85 ff                	test   %edi,%edi
80106bee:	0f 88 8e 00 00 00    	js     80106c82 <allocuvm+0xa2>
  if(newsz < oldsz)
80106bf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bf7:	0f 82 93 00 00 00    	jb     80106c90 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c0c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c0f:	0f 86 7e 00 00 00    	jbe    80106c93 <allocuvm+0xb3>
80106c15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106c18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c1b:	eb 42                	jmp    80106c5f <allocuvm+0x7f>
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106c20:	83 ec 04             	sub    $0x4,%esp
80106c23:	68 00 10 00 00       	push   $0x1000
80106c28:	6a 00                	push   $0x0
80106c2a:	50                   	push   %eax
80106c2b:	e8 d0 d9 ff ff       	call   80104600 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c30:	58                   	pop    %eax
80106c31:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c37:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c3c:	5a                   	pop    %edx
80106c3d:	6a 06                	push   $0x6
80106c3f:	50                   	push   %eax
80106c40:	89 da                	mov    %ebx,%edx
80106c42:	89 f8                	mov    %edi,%eax
80106c44:	e8 67 fb ff ff       	call   801067b0 <mappages>
80106c49:	83 c4 10             	add    $0x10,%esp
80106c4c:	85 c0                	test   %eax,%eax
80106c4e:	78 50                	js     80106ca0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106c50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c56:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c59:	0f 86 81 00 00 00    	jbe    80106ce0 <allocuvm+0x100>
    mem = kalloc();
80106c5f:	e8 bc b9 ff ff       	call   80102620 <kalloc>
    if(mem == 0){
80106c64:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106c66:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c68:	75 b6                	jne    80106c20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106c6a:	83 ec 0c             	sub    $0xc,%esp
80106c6d:	68 85 83 10 80       	push   $0x80108385
80106c72:	e8 e9 99 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106c77:	83 c4 10             	add    $0x10,%esp
80106c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c7d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c80:	77 6e                	ja     80106cf0 <allocuvm+0x110>
}
80106c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c85:	31 ff                	xor    %edi,%edi
}
80106c87:	89 f8                	mov    %edi,%eax
80106c89:	5b                   	pop    %ebx
80106c8a:	5e                   	pop    %esi
80106c8b:	5f                   	pop    %edi
80106c8c:	5d                   	pop    %ebp
80106c8d:	c3                   	ret    
80106c8e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106c90:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c96:	89 f8                	mov    %edi,%eax
80106c98:	5b                   	pop    %ebx
80106c99:	5e                   	pop    %esi
80106c9a:	5f                   	pop    %edi
80106c9b:	5d                   	pop    %ebp
80106c9c:	c3                   	ret    
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 9d 83 10 80       	push   $0x8010839d
80106ca8:	e8 b3 99 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cb6:	76 0d                	jbe    80106cc5 <allocuvm+0xe5>
80106cb8:	89 c1                	mov    %eax,%ecx
80106cba:	8b 55 10             	mov    0x10(%ebp),%edx
80106cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc0:	e8 7b fb ff ff       	call   80106840 <deallocuvm.part.0>
      kfree(mem);
80106cc5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106cc8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106cca:	56                   	push   %esi
80106ccb:	e8 a0 b7 ff ff       	call   80102470 <kfree>
      return 0;
80106cd0:	83 c4 10             	add    $0x10,%esp
}
80106cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cd6:	89 f8                	mov    %edi,%eax
80106cd8:	5b                   	pop    %ebx
80106cd9:	5e                   	pop    %esi
80106cda:	5f                   	pop    %edi
80106cdb:	5d                   	pop    %ebp
80106cdc:	c3                   	ret    
80106cdd:	8d 76 00             	lea    0x0(%esi),%esi
80106ce0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	89 f8                	mov    %edi,%eax
80106ce9:	5e                   	pop    %esi
80106cea:	5f                   	pop    %edi
80106ceb:	5d                   	pop    %ebp
80106cec:	c3                   	ret    
80106ced:	8d 76 00             	lea    0x0(%esi),%esi
80106cf0:	89 c1                	mov    %eax,%ecx
80106cf2:	8b 55 10             	mov    0x10(%ebp),%edx
80106cf5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106cf8:	31 ff                	xor    %edi,%edi
80106cfa:	e8 41 fb ff ff       	call   80106840 <deallocuvm.part.0>
80106cff:	eb 92                	jmp    80106c93 <allocuvm+0xb3>
80106d01:	eb 0d                	jmp    80106d10 <deallocuvm>
80106d03:	90                   	nop
80106d04:	90                   	nop
80106d05:	90                   	nop
80106d06:	90                   	nop
80106d07:	90                   	nop
80106d08:	90                   	nop
80106d09:	90                   	nop
80106d0a:	90                   	nop
80106d0b:	90                   	nop
80106d0c:	90                   	nop
80106d0d:	90                   	nop
80106d0e:	90                   	nop
80106d0f:	90                   	nop

80106d10 <deallocuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d1c:	39 d1                	cmp    %edx,%ecx
80106d1e:	73 10                	jae    80106d30 <deallocuvm+0x20>
}
80106d20:	5d                   	pop    %ebp
80106d21:	e9 1a fb ff ff       	jmp    80106840 <deallocuvm.part.0>
80106d26:	8d 76 00             	lea    0x0(%esi),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d30:	89 d0                	mov    %edx,%eax
80106d32:	5d                   	pop    %ebp
80106d33:	c3                   	ret    
80106d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 0c             	sub    $0xc,%esp
80106d49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d4c:	85 f6                	test   %esi,%esi
80106d4e:	74 59                	je     80106da9 <freevm+0x69>
80106d50:	31 c9                	xor    %ecx,%ecx
80106d52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d57:	89 f0                	mov    %esi,%eax
80106d59:	e8 e2 fa ff ff       	call   80106840 <deallocuvm.part.0>
80106d5e:	89 f3                	mov    %esi,%ebx
80106d60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d66:	eb 0f                	jmp    80106d77 <freevm+0x37>
80106d68:	90                   	nop
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d73:	39 fb                	cmp    %edi,%ebx
80106d75:	74 23                	je     80106d9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d77:	8b 03                	mov    (%ebx),%eax
80106d79:	a8 01                	test   $0x1,%al
80106d7b:	74 f3                	je     80106d70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d8d:	50                   	push   %eax
80106d8e:	e8 dd b6 ff ff       	call   80102470 <kfree>
80106d93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d96:	39 fb                	cmp    %edi,%ebx
80106d98:	75 dd                	jne    80106d77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da0:	5b                   	pop    %ebx
80106da1:	5e                   	pop    %esi
80106da2:	5f                   	pop    %edi
80106da3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106da4:	e9 c7 b6 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80106da9:	83 ec 0c             	sub    $0xc,%esp
80106dac:	68 b9 83 10 80       	push   $0x801083b9
80106db1:	e8 da 95 ff ff       	call   80100390 <panic>
80106db6:	8d 76 00             	lea    0x0(%esi),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dc0 <setupkvm>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	56                   	push   %esi
80106dc4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106dc5:	e8 56 b8 ff ff       	call   80102620 <kalloc>
80106dca:	85 c0                	test   %eax,%eax
80106dcc:	89 c6                	mov    %eax,%esi
80106dce:	74 42                	je     80106e12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106dd0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dd3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80106dd8:	68 00 10 00 00       	push   $0x1000
80106ddd:	6a 00                	push   $0x0
80106ddf:	50                   	push   %eax
80106de0:	e8 1b d8 ff ff       	call   80104600 <memset>
80106de5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106de8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106deb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106dee:	83 ec 08             	sub    $0x8,%esp
80106df1:	8b 13                	mov    (%ebx),%edx
80106df3:	ff 73 0c             	pushl  0xc(%ebx)
80106df6:	50                   	push   %eax
80106df7:	29 c1                	sub    %eax,%ecx
80106df9:	89 f0                	mov    %esi,%eax
80106dfb:	e8 b0 f9 ff ff       	call   801067b0 <mappages>
80106e00:	83 c4 10             	add    $0x10,%esp
80106e03:	85 c0                	test   %eax,%eax
80106e05:	78 19                	js     80106e20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e07:	83 c3 10             	add    $0x10,%ebx
80106e0a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106e10:	75 d6                	jne    80106de8 <setupkvm+0x28>
}
80106e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e15:	89 f0                	mov    %esi,%eax
80106e17:	5b                   	pop    %ebx
80106e18:	5e                   	pop    %esi
80106e19:	5d                   	pop    %ebp
80106e1a:	c3                   	ret    
80106e1b:	90                   	nop
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	56                   	push   %esi
      return 0;
80106e24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e26:	e8 15 ff ff ff       	call   80106d40 <freevm>
      return 0;
80106e2b:	83 c4 10             	add    $0x10,%esp
}
80106e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e31:	89 f0                	mov    %esi,%eax
80106e33:	5b                   	pop    %ebx
80106e34:	5e                   	pop    %esi
80106e35:	5d                   	pop    %ebp
80106e36:	c3                   	ret    
80106e37:	89 f6                	mov    %esi,%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <kvmalloc>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e46:	e8 75 ff ff ff       	call   80106dc0 <setupkvm>
80106e4b:	a3 e4 64 11 80       	mov    %eax,0x801164e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e50:	05 00 00 00 80       	add    $0x80000000,%eax
80106e55:	0f 22 d8             	mov    %eax,%cr3
}
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e61:	31 c9                	xor    %ecx,%ecx
{
80106e63:	89 e5                	mov    %esp,%ebp
80106e65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6e:	e8 bd f8 ff ff       	call   80106730 <walkpgdir>
  if(pte == 0)
80106e73:	85 c0                	test   %eax,%eax
80106e75:	74 05                	je     80106e7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    
    panic("clearpteu");
80106e7c:	83 ec 0c             	sub    $0xc,%esp
80106e7f:	68 ca 83 10 80       	push   $0x801083ca
80106e84:	e8 07 95 ff ff       	call   80100390 <panic>
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e99:	e8 22 ff ff ff       	call   80106dc0 <setupkvm>
80106e9e:	85 c0                	test   %eax,%eax
80106ea0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ea3:	0f 84 9f 00 00 00    	je     80106f48 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106eac:	85 c9                	test   %ecx,%ecx
80106eae:	0f 84 94 00 00 00    	je     80106f48 <copyuvm+0xb8>
80106eb4:	31 ff                	xor    %edi,%edi
80106eb6:	eb 4a                	jmp    80106f02 <copyuvm+0x72>
80106eb8:	90                   	nop
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ec0:	83 ec 04             	sub    $0x4,%esp
80106ec3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106ec9:	68 00 10 00 00       	push   $0x1000
80106ece:	53                   	push   %ebx
80106ecf:	50                   	push   %eax
80106ed0:	e8 db d7 ff ff       	call   801046b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ed5:	58                   	pop    %eax
80106ed6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106edc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ee1:	5a                   	pop    %edx
80106ee2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ee5:	50                   	push   %eax
80106ee6:	89 fa                	mov    %edi,%edx
80106ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106eeb:	e8 c0 f8 ff ff       	call   801067b0 <mappages>
80106ef0:	83 c4 10             	add    $0x10,%esp
80106ef3:	85 c0                	test   %eax,%eax
80106ef5:	78 61                	js     80106f58 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106ef7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106efd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106f00:	76 46                	jbe    80106f48 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f02:	8b 45 08             	mov    0x8(%ebp),%eax
80106f05:	31 c9                	xor    %ecx,%ecx
80106f07:	89 fa                	mov    %edi,%edx
80106f09:	e8 22 f8 ff ff       	call   80106730 <walkpgdir>
80106f0e:	85 c0                	test   %eax,%eax
80106f10:	74 61                	je     80106f73 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106f12:	8b 00                	mov    (%eax),%eax
80106f14:	a8 01                	test   $0x1,%al
80106f16:	74 4e                	je     80106f66 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106f18:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106f1a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80106f1f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106f28:	e8 f3 b6 ff ff       	call   80102620 <kalloc>
80106f2d:	85 c0                	test   %eax,%eax
80106f2f:	89 c6                	mov    %eax,%esi
80106f31:	75 8d                	jne    80106ec0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106f33:	83 ec 0c             	sub    $0xc,%esp
80106f36:	ff 75 e0             	pushl  -0x20(%ebp)
80106f39:	e8 02 fe ff ff       	call   80106d40 <freevm>
  return 0;
80106f3e:	83 c4 10             	add    $0x10,%esp
80106f41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f4e:	5b                   	pop    %ebx
80106f4f:	5e                   	pop    %esi
80106f50:	5f                   	pop    %edi
80106f51:	5d                   	pop    %ebp
80106f52:	c3                   	ret    
80106f53:	90                   	nop
80106f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106f58:	83 ec 0c             	sub    $0xc,%esp
80106f5b:	56                   	push   %esi
80106f5c:	e8 0f b5 ff ff       	call   80102470 <kfree>
      goto bad;
80106f61:	83 c4 10             	add    $0x10,%esp
80106f64:	eb cd                	jmp    80106f33 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106f66:	83 ec 0c             	sub    $0xc,%esp
80106f69:	68 ee 83 10 80       	push   $0x801083ee
80106f6e:	e8 1d 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106f73:	83 ec 0c             	sub    $0xc,%esp
80106f76:	68 d4 83 10 80       	push   $0x801083d4
80106f7b:	e8 10 94 ff ff       	call   80100390 <panic>

80106f80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f81:	31 c9                	xor    %ecx,%ecx
{
80106f83:	89 e5                	mov    %esp,%ebp
80106f85:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8e:	e8 9d f7 ff ff       	call   80106730 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f93:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f95:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f96:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f9d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106fa0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fa5:	83 fa 05             	cmp    $0x5,%edx
80106fa8:	ba 00 00 00 00       	mov    $0x0,%edx
80106fad:	0f 45 c2             	cmovne %edx,%eax
}
80106fb0:	c3                   	ret    
80106fb1:	eb 0d                	jmp    80106fc0 <copyout>
80106fb3:	90                   	nop
80106fb4:	90                   	nop
80106fb5:	90                   	nop
80106fb6:	90                   	nop
80106fb7:	90                   	nop
80106fb8:	90                   	nop
80106fb9:	90                   	nop
80106fba:	90                   	nop
80106fbb:	90                   	nop
80106fbc:	90                   	nop
80106fbd:	90                   	nop
80106fbe:	90                   	nop
80106fbf:	90                   	nop

80106fc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fd2:	85 db                	test   %ebx,%ebx
80106fd4:	75 40                	jne    80107016 <copyout+0x56>
80106fd6:	eb 70                	jmp    80107048 <copyout+0x88>
80106fd8:	90                   	nop
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fe3:	89 f1                	mov    %esi,%ecx
80106fe5:	29 d1                	sub    %edx,%ecx
80106fe7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106fed:	39 d9                	cmp    %ebx,%ecx
80106fef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ff2:	29 f2                	sub    %esi,%edx
80106ff4:	83 ec 04             	sub    $0x4,%esp
80106ff7:	01 d0                	add    %edx,%eax
80106ff9:	51                   	push   %ecx
80106ffa:	57                   	push   %edi
80106ffb:	50                   	push   %eax
80106ffc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106fff:	e8 ac d6 ff ff       	call   801046b0 <memmove>
    len -= n;
    buf += n;
80107004:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107007:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010700a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107010:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107012:	29 cb                	sub    %ecx,%ebx
80107014:	74 32                	je     80107048 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107016:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107018:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010701b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010701e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107024:	56                   	push   %esi
80107025:	ff 75 08             	pushl  0x8(%ebp)
80107028:	e8 53 ff ff ff       	call   80106f80 <uva2ka>
    if(pa0 == 0)
8010702d:	83 c4 10             	add    $0x10,%esp
80107030:	85 c0                	test   %eax,%eax
80107032:	75 ac                	jne    80106fe0 <copyout+0x20>
  }
  return 0;
}
80107034:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010703c:	5b                   	pop    %ebx
8010703d:	5e                   	pop    %esi
8010703e:	5f                   	pop    %edi
8010703f:	5d                   	pop    %ebp
80107040:	c3                   	ret    
80107041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010704b:	31 c0                	xor    %eax,%eax
}
8010704d:	5b                   	pop    %ebx
8010704e:	5e                   	pop    %esi
8010704f:	5f                   	pop    %edi
80107050:	5d                   	pop    %ebp
80107051:	c3                   	ret    
80107052:	66 90                	xchg   %ax,%ax
80107054:	66 90                	xchg   %ax,%ax
80107056:	66 90                	xchg   %ax,%ax
80107058:	66 90                	xchg   %ax,%ax
8010705a:	66 90                	xchg   %ax,%ax
8010705c:	66 90                	xchg   %ax,%ax
8010705e:	66 90                	xchg   %ax,%ax

80107060 <procfsisdir>:

struct dirent fd_dir_entries[NOFILE];

int 
procfsisdir(struct inode *ip) 
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
  //cprintf("in func procfsISDIR: ip->minor=%d ip->inum=%d\n", ip->minor, ip->inum);
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501 || ip->inum != 502)))
80107063:	8b 45 08             	mov    0x8(%ebp),%eax
		return 1;
	else 
    return 0;
}
80107066:	5d                   	pop    %ebp
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501 || ip->inum != 502)))
80107067:	66 83 78 54 01       	cmpw   $0x1,0x54(%eax)
8010706c:	0f 96 c0             	setbe  %al
8010706f:	0f b6 c0             	movzbl %al,%eax
}
80107072:	c3                   	ret    
80107073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <procfsiread>:

void 
procfsiread(struct inode* dp, struct inode *ip) 
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	53                   	push   %ebx
80107084:	8b 45 0c             	mov    0xc(%ebp),%eax
80107087:	8b 4d 08             	mov    0x8(%ebp),%ecx
  //cprintf("in func PROCFSIREAD, ip->inum= %d, dp->inum = %d \n",ip->inum,dp->inum);
  if (ip->inum < 500) 
8010708a:	8b 50 04             	mov    0x4(%eax),%edx
8010708d:	81 fa f3 01 00 00    	cmp    $0x1f3,%edx
80107093:	76 39                	jbe    801070ce <procfsiread+0x4e>
		return;

	ip->major = PROCFS;
	ip->size = 0;
	ip->nlink = 1;
80107095:	bb 01 00 00 00       	mov    $0x1,%ebx
	ip->size = 0;
8010709a:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
	ip->type = T_DEV;
	ip->valid = 1;
801070a1:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
	ip->nlink = 1;
801070a8:	66 89 58 56          	mov    %bx,0x56(%eax)
	ip->valid = 1;
801070ac:	c7 40 50 03 00 02 00 	movl   $0x20003,0x50(%eax)
	ip->minor = dp->minor + 1;
801070b3:	0f b7 59 54          	movzwl 0x54(%ecx),%ebx
801070b7:	83 c3 01             	add    $0x1,%ebx
801070ba:	66 89 58 54          	mov    %bx,0x54(%eax)

	if (dp->inum < ip->inum)
801070be:	3b 51 04             	cmp    0x4(%ecx),%edx
801070c1:	76 0b                	jbe    801070ce <procfsiread+0x4e>
		ip->minor = dp->minor + 1;
801070c3:	0f b7 51 54          	movzwl 0x54(%ecx),%edx
801070c7:	83 c2 01             	add    $0x1,%edx
801070ca:	66 89 50 54          	mov    %dx,0x54(%eax)
	else if (dp->inum < ip->inum)
		ip->minor = dp->minor - 1;
}
801070ce:	5b                   	pop    %ebx
801070cf:	5d                   	pop    %ebp
801070d0:	c3                   	ret    
801070d1:	eb 0d                	jmp    801070e0 <procfswrite>
801070d3:	90                   	nop
801070d4:	90                   	nop
801070d5:	90                   	nop
801070d6:	90                   	nop
801070d7:	90                   	nop
801070d8:	90                   	nop
801070d9:	90                   	nop
801070da:	90                   	nop
801070db:	90                   	nop
801070dc:	90                   	nop
801070dd:	90                   	nop
801070de:	90                   	nop
801070df:	90                   	nop

801070e0 <procfswrite>:
  }
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
801070e0:	55                   	push   %ebp
  return 0;
}
801070e1:	31 c0                	xor    %eax,%eax
{
801070e3:	89 e5                	mov    %esp,%ebp
}
801070e5:	5d                   	pop    %ebp
801070e6:	c3                   	ret    
801070e7:	89 f6                	mov    %esi,%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <procfsinit>:

void
procfsinit(void)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 0c             	sub    $0xc,%esp
  devsw[PROCFS].isdir = procfsisdir;
801070f6:	c7 05 80 19 11 80 60 	movl   $0x80107060,0x80111980
801070fd:	70 10 80 
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;

  memset(&process_entries, sizeof(process_entries), 0);
80107100:	6a 00                	push   $0x0
80107102:	68 00 02 00 00       	push   $0x200
80107107:	68 20 65 11 80       	push   $0x80116520
  devsw[PROCFS].iread = procfsiread;
8010710c:	c7 05 84 19 11 80 80 	movl   $0x80107080,0x80111984
80107113:	70 10 80 
  devsw[PROCFS].write = procfswrite;
80107116:	c7 05 8c 19 11 80 e0 	movl   $0x801070e0,0x8011198c
8010711d:	70 10 80 
  devsw[PROCFS].read = procfsread;
80107120:	c7 05 88 19 11 80 c0 	movl   $0x801079c0,0x80111988
80107127:	79 10 80 
  memset(&process_entries, sizeof(process_entries), 0);
8010712a:	e8 d1 d4 ff ff       	call   80104600 <memset>
  memmove(subdir_entries[0].name, "name", 5);
8010712f:	83 c4 0c             	add    $0xc,%esp
80107132:	6a 05                	push   $0x5
80107134:	68 2b 84 10 80       	push   $0x8010842b
80107139:	68 02 65 11 80       	push   $0x80116502
8010713e:	e8 6d d5 ff ff       	call   801046b0 <memmove>
  memmove(subdir_entries[1].name, "status", 7);
80107143:	83 c4 0c             	add    $0xc,%esp
80107146:	6a 07                	push   $0x7
80107148:	68 30 84 10 80       	push   $0x80108430
8010714d:	68 12 65 11 80       	push   $0x80116512
80107152:	e8 59 d5 ff ff       	call   801046b0 <memmove>
  subdir_entries[0].inum = 0;
80107157:	31 c0                	xor    %eax,%eax
  subdir_entries[1].inum = 0;
80107159:	31 d2                	xor    %edx,%edx
}
8010715b:	83 c4 10             	add    $0x10,%esp
  subdir_entries[0].inum = 0;
8010715e:	66 a3 00 65 11 80    	mov    %ax,0x80116500
  subdir_entries[1].inum = 0;
80107164:	66 89 15 10 65 11 80 	mov    %dx,0x80116510
}
8010716b:	c9                   	leave  
8010716c:	c3                   	ret    
8010716d:	8d 76 00             	lea    0x0(%esi),%esi

80107170 <read_file_ideinfo>:
80107170:	55                   	push   %ebp
80107171:	31 c0                	xor    %eax,%eax
80107173:	89 e5                	mov    %esp,%ebp
80107175:	5d                   	pop    %ebp
80107176:	c3                   	ret    
80107177:	89 f6                	mov    %esi,%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <read_file_inodeinfo>:
80107180:	55                   	push   %ebp
80107181:	31 c0                	xor    %eax,%eax
80107183:	89 e5                	mov    %esp,%ebp
80107185:	5d                   	pop    %ebp
80107186:	c3                   	ret    
80107187:	89 f6                	mov    %esi,%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107190 <read_procfs_pid_dir>:
  return 0;
}

int 
read_procfs_pid_dir(struct inode* ip, char *dst, int off, int n) 
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
  //cprintf("in func read_procfs_pid_dir, ip->inum=%d \n",ip->inum);
  struct dirent temp_entries[2];
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
80107196:	8d 7d c8             	lea    -0x38(%ebp),%edi

	temp_entries[0].inum = ip->inum + 100;
	temp_entries[1].inum = ip->inum + 200;

	if (off + n > sizeof(temp_entries))
		n = sizeof(temp_entries) - off;
80107199:	bb 20 00 00 00       	mov    $0x20,%ebx
{
8010719e:	83 ec 30             	sub    $0x30,%esp
801071a1:	8b 75 10             	mov    0x10(%ebp),%esi
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801071a4:	6a 20                	push   $0x20
801071a6:	68 00 65 11 80       	push   $0x80116500
801071ab:	57                   	push   %edi
		n = sizeof(temp_entries) - off;
801071ac:	29 f3                	sub    %esi,%ebx
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801071ae:	e8 fd d4 ff ff       	call   801046b0 <memmove>
	temp_entries[0].inum = ip->inum + 100;
801071b3:	8b 45 08             	mov    0x8(%ebp),%eax
	if (off + n > sizeof(temp_entries))
801071b6:	83 c4 0c             	add    $0xc,%esp
	temp_entries[0].inum = ip->inum + 100;
801071b9:	8b 40 04             	mov    0x4(%eax),%eax
801071bc:	8d 48 64             	lea    0x64(%eax),%ecx
	temp_entries[1].inum = ip->inum + 200;
801071bf:	66 05 c8 00          	add    $0xc8,%ax
801071c3:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	if (off + n > sizeof(temp_entries))
801071c7:	8b 45 14             	mov    0x14(%ebp),%eax
	temp_entries[0].inum = ip->inum + 100;
801071ca:	66 89 4d c8          	mov    %cx,-0x38(%ebp)
	if (off + n > sizeof(temp_entries))
801071ce:	01 f0                	add    %esi,%eax
		n = sizeof(temp_entries) - off;
801071d0:	83 f8 20             	cmp    $0x20,%eax
801071d3:	0f 46 5d 14          	cmovbe 0x14(%ebp),%ebx
	memmove(dst, (char*)(&temp_entries) + off, n);
801071d7:	01 fe                	add    %edi,%esi
801071d9:	53                   	push   %ebx
801071da:	56                   	push   %esi
801071db:	ff 75 0c             	pushl  0xc(%ebp)
801071de:	e8 cd d4 ff ff       	call   801046b0 <memmove>
	return n;
}
801071e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e6:	89 d8                	mov    %ebx,%eax
801071e8:	5b                   	pop    %ebx
801071e9:	5e                   	pop    %esi
801071ea:	5f                   	pop    %edi
801071eb:	5d                   	pop    %ebp
801071ec:	c3                   	ret    
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <read_path_level_3>:
	return 0;
}

int 
read_path_level_3(struct inode *ip, char *dst, int off, int n)
{
801071f0:	55                   	push   %ebp
  return 0; 
}
801071f1:	31 c0                	xor    %eax,%eax
{
801071f3:	89 e5                	mov    %esp,%ebp
}
801071f5:	5d                   	pop    %ebp
801071f6:	c3                   	ret    
801071f7:	89 f6                	mov    %esi,%esi
801071f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107200 <procfs_add_proc>:

void 
procfs_add_proc(int pid, char* cwd) 
{
80107200:	55                   	push   %ebp
  //cprintf("procfs_add_proc: %d\n", pid);
	int i;
	for (i = 0; i < MAX_PROCESSES; i++) {
80107201:	31 c0                	xor    %eax,%eax
{
80107203:	89 e5                	mov    %esp,%ebp
80107205:	83 ec 08             	sub    $0x8,%esp
80107208:	eb 0e                	jmp    80107218 <procfs_add_proc+0x18>
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (i = 0; i < MAX_PROCESSES; i++) {
80107210:	83 c0 01             	add    $0x1,%eax
80107213:	83 f8 40             	cmp    $0x40,%eax
80107216:	74 28                	je     80107240 <procfs_add_proc+0x40>
		if (!process_entries[i].used) {
80107218:	8b 14 c5 24 65 11 80 	mov    -0x7fee9adc(,%eax,8),%edx
8010721f:	85 d2                	test   %edx,%edx
80107221:	75 ed                	jne    80107210 <procfs_add_proc+0x10>
			process_entries[i].used = 1;
			process_entries[i].pid = pid;
80107223:	8b 55 08             	mov    0x8(%ebp),%edx
			process_entries[i].used = 1;
80107226:	c7 04 c5 24 65 11 80 	movl   $0x1,-0x7fee9adc(,%eax,8)
8010722d:	01 00 00 00 
			process_entries[i].pid = pid;
80107231:	89 14 c5 20 65 11 80 	mov    %edx,-0x7fee9ae0(,%eax,8)
			return;
		}
	}
	panic("Too many processes in procfs!");
}
80107238:	c9                   	leave  
80107239:	c3                   	ret    
8010723a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	panic("Too many processes in procfs!");
80107240:	83 ec 0c             	sub    $0xc,%esp
80107243:	68 37 84 10 80       	push   $0x80108437
80107248:	e8 43 91 ff ff       	call   80100390 <panic>
8010724d:	8d 76 00             	lea    0x0(%esi),%esi

80107250 <procfs_remove_proc>:

void
procfs_remove_proc(int pid) 
{
80107250:	55                   	push   %ebp
	//cprintf("procfs_remove_proc: %d\n", pid);
	int i;
	for (i = 0; i < MAX_PROCESSES; i++) {
80107251:	31 c0                	xor    %eax,%eax
{
80107253:	89 e5                	mov    %esp,%ebp
80107255:	83 ec 08             	sub    $0x8,%esp
80107258:	8b 55 08             	mov    0x8(%ebp),%edx
8010725b:	eb 0b                	jmp    80107268 <procfs_remove_proc+0x18>
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < MAX_PROCESSES; i++) {
80107260:	83 c0 01             	add    $0x1,%eax
80107263:	83 f8 40             	cmp    $0x40,%eax
80107266:	74 30                	je     80107298 <procfs_remove_proc+0x48>
		if (process_entries[i].used && process_entries[i].pid == pid) {
80107268:	8b 0c c5 24 65 11 80 	mov    -0x7fee9adc(,%eax,8),%ecx
8010726f:	85 c9                	test   %ecx,%ecx
80107271:	74 ed                	je     80107260 <procfs_remove_proc+0x10>
80107273:	39 14 c5 20 65 11 80 	cmp    %edx,-0x7fee9ae0(,%eax,8)
8010727a:	75 e4                	jne    80107260 <procfs_remove_proc+0x10>
			process_entries[i].used = process_entries[i].pid = 0;
8010727c:	c7 04 c5 20 65 11 80 	movl   $0x0,-0x7fee9ae0(,%eax,8)
80107283:	00 00 00 00 
80107287:	c7 04 c5 24 65 11 80 	movl   $0x0,-0x7fee9adc(,%eax,8)
8010728e:	00 00 00 00 
			return;
		}
	}
	panic("Failed to find process in procfs_remove_proc!");
}
80107292:	c9                   	leave  
80107293:	c3                   	ret    
80107294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	panic("Failed to find process in procfs_remove_proc!");
80107298:	83 ec 0c             	sub    $0xc,%esp
8010729b:	68 d4 84 10 80       	push   $0x801084d4
801072a0:	e8 eb 90 ff ff       	call   80100390 <panic>
801072a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072b0 <strcpy>:

//-------------------------HELPERS---------------------------------------
char*
strcpy(char *s, const char *t)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	53                   	push   %ebx
801072b4:	8b 45 08             	mov    0x8(%ebp),%eax
801072b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
801072ba:	89 c2                	mov    %eax,%edx
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072c0:	83 c1 01             	add    $0x1,%ecx
801072c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
801072c7:	83 c2 01             	add    $0x1,%edx
801072ca:	84 db                	test   %bl,%bl
801072cc:	88 5a ff             	mov    %bl,-0x1(%edx)
801072cf:	75 ef                	jne    801072c0 <strcpy+0x10>
    ;
  return os;
}
801072d1:	5b                   	pop    %ebx
801072d2:	5d                   	pop    %ebp
801072d3:	c3                   	ret    
801072d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072e0 <atoi>:

int
atoi(const char *s)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	53                   	push   %ebx
801072e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
801072e7:	0f be 11             	movsbl (%ecx),%edx
801072ea:	8d 42 d0             	lea    -0x30(%edx),%eax
801072ed:	3c 09                	cmp    $0x9,%al
  n = 0;
801072ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
801072f4:	77 1f                	ja     80107315 <atoi+0x35>
801072f6:	8d 76 00             	lea    0x0(%esi),%esi
801072f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
80107300:	8d 04 80             	lea    (%eax,%eax,4),%eax
80107303:	83 c1 01             	add    $0x1,%ecx
80107306:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
8010730a:	0f be 11             	movsbl (%ecx),%edx
8010730d:	8d 5a d0             	lea    -0x30(%edx),%ebx
80107310:	80 fb 09             	cmp    $0x9,%bl
80107313:	76 eb                	jbe    80107300 <atoi+0x20>
  return n;
}
80107315:	5b                   	pop    %ebx
80107316:	5d                   	pop    %ebp
80107317:	c3                   	ret    
80107318:	90                   	nop
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <itoa>:

// convert int to string
void 
itoa(char s[], int n)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	31 ff                	xor    %edi,%edi
80107328:	83 ec 0c             	sub    $0xc,%esp
8010732b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010732e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107331:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107334:	c1 f8 1f             	sar    $0x1f,%eax
80107337:	31 c1                	xor    %eax,%ecx
80107339:	29 c1                	sub    %eax,%ecx
8010733b:	eb 05                	jmp    80107342 <itoa+0x22>
8010733d:	8d 76 00             	lea    0x0(%esi),%esi
  
  if (pm < 0) {
    n = -n;          
  }
  do {       
    s[i++] = n % 10 + '0';   
80107340:	89 f7                	mov    %esi,%edi
80107342:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80107347:	8d 77 01             	lea    0x1(%edi),%esi
8010734a:	f7 e1                	mul    %ecx
8010734c:	c1 ea 03             	shr    $0x3,%edx
8010734f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80107352:	01 c0                	add    %eax,%eax
80107354:	29 c1                	sub    %eax,%ecx
80107356:	83 c1 30             	add    $0x30,%ecx
  } while ((n /= 10) > 0);
80107359:	85 d2                	test   %edx,%edx
    s[i++] = n % 10 + '0';   
8010735b:	88 4c 33 ff          	mov    %cl,-0x1(%ebx,%esi,1)
  } while ((n /= 10) > 0);
8010735f:	89 d1                	mov    %edx,%ecx
80107361:	7f dd                	jg     80107340 <itoa+0x20>
  
  if (pm < 0) {
80107363:	8b 45 0c             	mov    0xc(%ebp),%eax
80107366:	01 de                	add    %ebx,%esi
80107368:	85 c0                	test   %eax,%eax
8010736a:	79 07                	jns    80107373 <itoa+0x53>
    s[i++] = '-';
8010736c:	c6 06 2d             	movb   $0x2d,(%esi)
8010736f:	8d 74 3b 02          	lea    0x2(%ebx,%edi,1),%esi
  }
  s[i] = '\0';
  
  //reverse
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80107373:	83 ec 0c             	sub    $0xc,%esp
  s[i] = '\0';
80107376:	c6 06 00             	movb   $0x0,(%esi)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80107379:	53                   	push   %ebx
8010737a:	e8 a1 d4 ff ff       	call   80104820 <strlen>
8010737f:	83 e8 01             	sub    $0x1,%eax
80107382:	83 c4 10             	add    $0x10,%esp
80107385:	85 c0                	test   %eax,%eax
80107387:	7e 21                	jle    801073aa <itoa+0x8a>
80107389:	31 d2                	xor    %edx,%edx
8010738b:	90                   	nop
8010738c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = s[t];
80107390:	0f b6 3c 13          	movzbl (%ebx,%edx,1),%edi
    s[t] = s[j];
80107394:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
80107398:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    s[j] = c;
8010739b:	89 f9                	mov    %edi,%ecx
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
8010739d:	83 c2 01             	add    $0x1,%edx
    s[j] = c;
801073a0:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
801073a3:	83 e8 01             	sub    $0x1,%eax
801073a6:	39 c2                	cmp    %eax,%edx
801073a8:	7c e6                	jl     80107390 <itoa+0x70>
  }
} 
801073aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ad:	5b                   	pop    %ebx
801073ae:	5e                   	pop    %esi
801073af:	5f                   	pop    %edi
801073b0:	5d                   	pop    %ebp
801073b1:	c3                   	ret    
801073b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073c0 <update_dir_entries>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
  dir_entries[2].inum = 502;
801073c6:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  int j = 3;
801073cb:	be 03 00 00 00       	mov    $0x3,%esi
{
801073d0:	83 ec 10             	sub    $0x10,%esp
	memset(dir_entries, sizeof(dir_entries), 0);
801073d3:	6a 00                	push   $0x0
801073d5:	68 20 04 00 00       	push   $0x420
801073da:	68 20 67 11 80       	push   $0x80116720
801073df:	e8 1c d2 ff ff       	call   80104600 <memset>
  memmove(&dir_entries[0].name, "ideinfo", 8);
801073e4:	83 c4 0c             	add    $0xc,%esp
801073e7:	6a 08                	push   $0x8
801073e9:	68 55 84 10 80       	push   $0x80108455
801073ee:	68 22 67 11 80       	push   $0x80116722
801073f3:	e8 b8 d2 ff ff       	call   801046b0 <memmove>
  memmove(&dir_entries[1].name, "filestat", 9);
801073f8:	83 c4 0c             	add    $0xc,%esp
801073fb:	6a 09                	push   $0x9
801073fd:	68 5d 84 10 80       	push   $0x8010845d
80107402:	68 32 67 11 80       	push   $0x80116732
80107407:	e8 a4 d2 ff ff       	call   801046b0 <memmove>
  memmove(&dir_entries[2].name, "inodeinfo", 10);
8010740c:	83 c4 0c             	add    $0xc,%esp
8010740f:	6a 0a                	push   $0xa
80107411:	68 66 84 10 80       	push   $0x80108466
80107416:	68 42 67 11 80       	push   $0x80116742
8010741b:	e8 90 d2 ff ff       	call   801046b0 <memmove>
  dir_entries[0].inum = 500;
80107420:	ba f4 01 00 00       	mov    $0x1f4,%edx
  dir_entries[1].inum = 501;
80107425:	b9 f5 01 00 00       	mov    $0x1f5,%ecx
  dir_entries[2].inum = 502;
8010742a:	66 89 1d 40 67 11 80 	mov    %bx,0x80116740
  dir_entries[0].inum = 500;
80107431:	66 89 15 20 67 11 80 	mov    %dx,0x80116720
  dir_entries[1].inum = 501;
80107438:	66 89 0d 30 67 11 80 	mov    %cx,0x80116730
8010743f:	bb 20 65 11 80       	mov    $0x80116520,%ebx
80107444:	83 c4 10             	add    $0x10,%esp
80107447:	eb 12                	jmp    8010745b <update_dir_entries+0x9b>
80107449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107450:	83 c3 08             	add    $0x8,%ebx
    for (int i = 0; i < MAX_PROCESSES; i++) {
80107453:	81 fb 20 67 11 80    	cmp    $0x80116720,%ebx
80107459:	74 3d                	je     80107498 <update_dir_entries+0xd8>
		if (process_entries[i].used) {
8010745b:	8b 43 04             	mov    0x4(%ebx),%eax
8010745e:	85 c0                	test   %eax,%eax
80107460:	74 ee                	je     80107450 <update_dir_entries+0x90>
			itoa(dir_entries[j].name, process_entries[i].pid);
80107462:	89 f7                	mov    %esi,%edi
80107464:	83 ec 08             	sub    $0x8,%esp
80107467:	ff 33                	pushl  (%ebx)
80107469:	c1 e7 04             	shl    $0x4,%edi
8010746c:	83 c3 08             	add    $0x8,%ebx
			j++;
8010746f:	83 c6 01             	add    $0x1,%esi
			itoa(dir_entries[j].name, process_entries[i].pid);
80107472:	8d 87 22 67 11 80    	lea    -0x7fee98de(%edi),%eax
80107478:	50                   	push   %eax
80107479:	e8 a2 fe ff ff       	call   80107320 <itoa>
			dir_entries[j].inum = 600 + process_entries[i].pid;
8010747e:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
			j++;
80107482:	83 c4 10             	add    $0x10,%esp
			dir_entries[j].inum = 600 + process_entries[i].pid;
80107485:	66 05 58 02          	add    $0x258,%ax
    for (int i = 0; i < MAX_PROCESSES; i++) {
80107489:	81 fb 20 67 11 80    	cmp    $0x80116720,%ebx
			dir_entries[j].inum = 600 + process_entries[i].pid;
8010748f:	66 89 87 20 67 11 80 	mov    %ax,-0x7fee98e0(%edi)
    for (int i = 0; i < MAX_PROCESSES; i++) {
80107496:	75 c3                	jne    8010745b <update_dir_entries+0x9b>
}
80107498:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010749b:	5b                   	pop    %ebx
8010749c:	5e                   	pop    %esi
8010749d:	5f                   	pop    %edi
8010749e:	5d                   	pop    %ebp
8010749f:	c3                   	ret    

801074a0 <read_path_level_0>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
      n = sizeof(dir_entries) - off;
801074a6:	bb 20 04 00 00       	mov    $0x420,%ebx
{
801074ab:	83 ec 18             	sub    $0x18,%esp
  update_dir_entries(ip->inum);
801074ae:	8b 45 08             	mov    0x8(%ebp),%eax
{
801074b1:	8b 75 10             	mov    0x10(%ebp),%esi
801074b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  update_dir_entries(ip->inum);
801074b7:	ff 70 04             	pushl  0x4(%eax)
      n = sizeof(dir_entries) - off;
801074ba:	29 f3                	sub    %esi,%ebx
  update_dir_entries(ip->inum);
801074bc:	e8 ff fe ff ff       	call   801073c0 <update_dir_entries>
  if (off + n > sizeof(dir_entries))
801074c1:	8d 04 3e             	lea    (%esi,%edi,1),%eax
801074c4:	83 c4 0c             	add    $0xc,%esp
      n = sizeof(dir_entries) - off;
801074c7:	3d 20 04 00 00       	cmp    $0x420,%eax
801074cc:	0f 46 df             	cmovbe %edi,%ebx
  memmove(dst, (char*)(&dir_entries) + off, n);
801074cf:	81 c6 20 67 11 80    	add    $0x80116720,%esi
801074d5:	53                   	push   %ebx
801074d6:	56                   	push   %esi
801074d7:	ff 75 0c             	pushl  0xc(%ebp)
801074da:	e8 d1 d1 ff ff       	call   801046b0 <memmove>
}
801074df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e2:	89 d8                	mov    %ebx,%eax
801074e4:	5b                   	pop    %ebx
801074e5:	5e                   	pop    %esi
801074e6:	5f                   	pop    %edi
801074e7:	5d                   	pop    %ebp
801074e8:	c3                   	ret    
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074f0 <read_file_filestat.part.0>:
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
	char data[256] = {0};
801074f6:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
801074fc:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
801074fe:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107503:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80107509:	89 df                	mov    %ebx,%edi
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
8010750b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
80107511:	31 c0                	xor    %eax,%eax
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80107513:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
80107519:	f3 ab                	rep stos %eax,%es:(%edi)
8010751b:	90                   	nop
8010751c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107520:	0f b6 90 70 84 10 80 	movzbl -0x7fef7b90(%eax),%edx
80107527:	88 14 03             	mov    %dl,(%ebx,%eax,1)
8010752a:	83 c0 01             	add    $0x1,%eax
8010752d:	84 d2                	test   %dl,%dl
8010752f:	75 ef                	jne    80107520 <read_file_filestat.part.0+0x30>
	itoa(data + strlen(data), get_free_inodes());
80107531:	e8 8a aa ff ff       	call   80101fc0 <get_free_inodes>
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	89 c7                	mov    %eax,%edi
8010753b:	53                   	push   %ebx
8010753c:	e8 df d2 ff ff       	call   80104820 <strlen>
80107541:	5a                   	pop    %edx
80107542:	59                   	pop    %ecx
80107543:	01 d8                	add    %ebx,%eax
80107545:	57                   	push   %edi
80107546:	50                   	push   %eax
80107547:	e8 d4 fd ff ff       	call   80107320 <itoa>
  strcpy(data + strlen(data), "\nRefs per fds: ");
8010754c:	89 1c 24             	mov    %ebx,(%esp)
8010754f:	e8 cc d2 ff ff       	call   80104820 <strlen>
80107554:	83 c4 10             	add    $0x10,%esp
80107557:	01 d8                	add    %ebx,%eax
80107559:	31 d2                	xor    %edx,%edx
8010755b:	90                   	nop
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107560:	0f b6 8a 7b 84 10 80 	movzbl -0x7fef7b85(%edx),%ecx
80107567:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010756a:	83 c2 01             	add    $0x1,%edx
8010756d:	84 c9                	test   %cl,%cl
8010756f:	75 ef                	jne    80107560 <read_file_filestat.part.0+0x70>
	itoa(data + strlen(data), get_total_refs());
80107571:	e8 9a aa ff ff       	call   80102010 <get_total_refs>
80107576:	83 ec 0c             	sub    $0xc,%esp
80107579:	89 c7                	mov    %eax,%edi
8010757b:	53                   	push   %ebx
8010757c:	e8 9f d2 ff ff       	call   80104820 <strlen>
80107581:	5a                   	pop    %edx
80107582:	59                   	pop    %ecx
80107583:	01 d8                	add    %ebx,%eax
80107585:	57                   	push   %edi
80107586:	50                   	push   %eax
80107587:	e8 94 fd ff ff       	call   80107320 <itoa>
	strcpy(data + strlen(data), " / ");
8010758c:	89 1c 24             	mov    %ebx,(%esp)
8010758f:	e8 8c d2 ff ff       	call   80104820 <strlen>
80107594:	83 c4 10             	add    $0x10,%esp
80107597:	01 d8                	add    %ebx,%eax
80107599:	31 d2                	xor    %edx,%edx
8010759b:	90                   	nop
8010759c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801075a0:	0f b6 8a 8b 84 10 80 	movzbl -0x7fef7b75(%edx),%ecx
801075a7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801075aa:	83 c2 01             	add    $0x1,%edx
801075ad:	84 c9                	test   %cl,%cl
801075af:	75 ef                	jne    801075a0 <read_file_filestat.part.0+0xb0>
	itoa(data + strlen(data), get_used_inodes());
801075b1:	e8 aa aa ff ff       	call   80102060 <get_used_inodes>
801075b6:	83 ec 0c             	sub    $0xc,%esp
801075b9:	89 c7                	mov    %eax,%edi
801075bb:	53                   	push   %ebx
801075bc:	e8 5f d2 ff ff       	call   80104820 <strlen>
801075c1:	5a                   	pop    %edx
801075c2:	59                   	pop    %ecx
801075c3:	01 d8                	add    %ebx,%eax
801075c5:	57                   	push   %edi
801075c6:	50                   	push   %eax
801075c7:	e8 54 fd ff ff       	call   80107320 <itoa>
	strcpy(data + strlen(data), "\n");
801075cc:	89 1c 24             	mov    %ebx,(%esp)
801075cf:	e8 4c d2 ff ff       	call   80104820 <strlen>
801075d4:	83 c4 10             	add    $0x10,%esp
801075d7:	01 d8                	add    %ebx,%eax
801075d9:	31 d2                	xor    %edx,%edx
801075db:	90                   	nop
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801075e0:	0f b6 8a b7 83 10 80 	movzbl -0x7fef7c49(%edx),%ecx
801075e7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801075ea:	83 c2 01             	add    $0x1,%edx
801075ed:	84 c9                	test   %cl,%cl
801075ef:	75 ef                	jne    801075e0 <read_file_filestat.part.0+0xf0>
	if (off + n > strlen(data))
801075f1:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
801075f7:	83 ec 0c             	sub    $0xc,%esp
801075fa:	53                   	push   %ebx
801075fb:	8d 3c 06             	lea    (%esi,%eax,1),%edi
801075fe:	e8 1d d2 ff ff       	call   80104820 <strlen>
80107603:	83 c4 10             	add    $0x10,%esp
80107606:	39 c7                	cmp    %eax,%edi
80107608:	7f 26                	jg     80107630 <read_file_filestat.part.0+0x140>
	memmove(dst, (char*)(&data) + off, n);
8010760a:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
80107610:	83 ec 04             	sub    $0x4,%esp
80107613:	56                   	push   %esi
80107614:	53                   	push   %ebx
80107615:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
8010761b:	e8 90 d0 ff ff       	call   801046b0 <memmove>
}
80107620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107623:	89 f0                	mov    %esi,%eax
80107625:	5b                   	pop    %ebx
80107626:	5e                   	pop    %esi
80107627:	5f                   	pop    %edi
80107628:	5d                   	pop    %ebp
80107629:	c3                   	ret    
8010762a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
80107630:	83 ec 0c             	sub    $0xc,%esp
80107633:	53                   	push   %ebx
80107634:	e8 e7 d1 ff ff       	call   80104820 <strlen>
80107639:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
8010763f:	83 c4 10             	add    $0x10,%esp
80107642:	89 c6                	mov    %eax,%esi
80107644:	eb c4                	jmp    8010760a <read_file_filestat.part.0+0x11a>
80107646:	8d 76 00             	lea    0x0(%esi),%esi
80107649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107650 <read_file_filestat>:
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107656:	8b 45 0c             	mov    0xc(%ebp),%eax
80107659:	8b 55 10             	mov    0x10(%ebp),%edx
  if (n == sizeof(struct dirent))
8010765c:	83 f9 10             	cmp    $0x10,%ecx
8010765f:	74 0f                	je     80107670 <read_file_filestat+0x20>
}
80107661:	5d                   	pop    %ebp
80107662:	e9 89 fe ff ff       	jmp    801074f0 <read_file_filestat.part.0>
80107667:	89 f6                	mov    %esi,%esi
80107669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107670:	31 c0                	xor    %eax,%eax
80107672:	5d                   	pop    %ebp
80107673:	c3                   	ret    
80107674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010767a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107680 <read_path_level_1>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	53                   	push   %ebx
  switch (ip->inum) {
80107684:	8b 5d 08             	mov    0x8(%ebp),%ebx
{
80107687:	8b 45 0c             	mov    0xc(%ebp),%eax
8010768a:	8b 55 10             	mov    0x10(%ebp),%edx
8010768d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  switch (ip->inum) {
80107690:	8b 5b 04             	mov    0x4(%ebx),%ebx
80107693:	81 fb f5 01 00 00    	cmp    $0x1f5,%ebx
80107699:	74 1d                	je     801076b8 <read_path_level_1+0x38>
8010769b:	81 fb f6 01 00 00    	cmp    $0x1f6,%ebx
801076a1:	74 1a                	je     801076bd <read_path_level_1+0x3d>
801076a3:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
801076a9:	74 12                	je     801076bd <read_path_level_1+0x3d>
}
801076ab:	5b                   	pop    %ebx
801076ac:	5d                   	pop    %ebp
      return read_procfs_pid_dir(ip, dst, off, n);
801076ad:	e9 de fa ff ff       	jmp    80107190 <read_procfs_pid_dir>
801076b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (n == sizeof(struct dirent))
801076b8:	83 f9 10             	cmp    $0x10,%ecx
801076bb:	75 0b                	jne    801076c8 <read_path_level_1+0x48>
}
801076bd:	31 c0                	xor    %eax,%eax
801076bf:	5b                   	pop    %ebx
801076c0:	5d                   	pop    %ebp
801076c1:	c3                   	ret    
801076c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076c8:	5b                   	pop    %ebx
801076c9:	5d                   	pop    %ebp
801076ca:	e9 21 fe ff ff       	jmp    801074f0 <read_file_filestat.part.0>
801076cf:	90                   	nop

801076d0 <read_procfs_status>:
{
801076d0:	55                   	push   %ebp
	char status[250] = {0};
801076d1:	31 c0                	xor    %eax,%eax
{
801076d3:	89 e5                	mov    %esp,%ebp
801076d5:	57                   	push   %edi
801076d6:	56                   	push   %esi
801076d7:	53                   	push   %ebx
	char status[250] = {0};
801076d8:	8d 9d ee fe ff ff    	lea    -0x112(%ebp),%ebx
801076de:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
	char szBuf[100] = {0};
801076e4:	8d b5 8a fe ff ff    	lea    -0x176(%ebp),%esi
	char status[250] = {0};
801076ea:	89 d9                	mov    %ebx,%ecx
{
801076ec:	81 ec a8 01 00 00    	sub    $0x1a8,%esp
	char status[250] = {0};
801076f2:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
801076f9:	00 00 00 
801076fc:	29 f9                	sub    %edi,%ecx
801076fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107705:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
8010770b:	c1 e9 02             	shr    $0x2,%ecx
8010770e:	f3 ab                	rep stos %eax,%es:(%edi)
	char szBuf[100] = {0};
80107710:	8d bd 8c fe ff ff    	lea    -0x174(%ebp),%edi
80107716:	89 f1                	mov    %esi,%ecx
80107718:	c7 85 8a fe ff ff 00 	movl   $0x0,-0x176(%ebp)
8010771f:	00 00 00 
80107722:	c7 85 ea fe ff ff 00 	movl   $0x0,-0x116(%ebp)
80107729:	00 00 00 
8010772c:	29 f9                	sub    %edi,%ecx
8010772e:	83 c1 64             	add    $0x64,%ecx
80107731:	c1 e9 02             	shr    $0x2,%ecx
80107734:	f3 ab                	rep stos %eax,%es:(%edi)
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80107736:	c7 85 70 fe ff ff 8f 	movl   $0x8010848f,-0x190(%ebp)
8010773d:	84 10 80 
80107740:	c7 85 74 fe ff ff 96 	movl   $0x80108496,-0x18c(%ebp)
80107747:	84 10 80 
8010774a:	c7 85 78 fe ff ff 9d 	movl   $0x8010849d,-0x188(%ebp)
80107751:	84 10 80 
80107754:	c7 85 7c fe ff ff a6 	movl   $0x801084a6,-0x184(%ebp)
8010775b:	84 10 80 
	int pid = ip->inum - 800;
8010775e:	8b 45 08             	mov    0x8(%ebp),%eax
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80107761:	c7 85 80 fe ff ff af 	movl   $0x801084af,-0x180(%ebp)
80107768:	84 10 80 
8010776b:	c7 85 84 fe ff ff b7 	movl   $0x801084b7,-0x17c(%ebp)
80107772:	84 10 80 
	int pid = ip->inum - 800;
80107775:	8b 40 04             	mov    0x4(%eax),%eax
80107778:	2d 20 03 00 00       	sub    $0x320,%eax
  struct proc *p = find_proc_by_pid(pid);
8010777d:	50                   	push   %eax
8010777e:	e8 bd ca ff ff       	call   80104240 <find_proc_by_pid>
80107783:	89 c7                	mov    %eax,%edi
  int size = strlen(procstate[p->state]);
80107785:	58                   	pop    %eax
80107786:	8b 47 0c             	mov    0xc(%edi),%eax
80107789:	ff b4 85 70 fe ff ff 	pushl  -0x190(%ebp,%eax,4)
80107790:	e8 8b d0 ff ff       	call   80104820 <strlen>
80107795:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  strcpy(status, procstate[p->state]);
8010779b:	8b 47 0c             	mov    0xc(%edi),%eax
8010779e:	83 c4 10             	add    $0x10,%esp
801077a1:	8b 8c 85 70 fe ff ff 	mov    -0x190(%ebp,%eax,4),%ecx
801077a8:	31 c0                	xor    %eax,%eax
801077aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
801077b0:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
801077b4:	88 14 03             	mov    %dl,(%ebx,%eax,1)
801077b7:	83 c0 01             	add    $0x1,%eax
801077ba:	84 d2                	test   %dl,%dl
801077bc:	75 f2                	jne    801077b0 <read_procfs_status+0xe0>
  status[size] = ' ';
801077be:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
  itoa(szBuf, p->sz);
801077c4:	83 ec 08             	sub    $0x8,%esp
  status[size] = ' ';
801077c7:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
801077ce:	20 
  itoa(szBuf, p->sz);
801077cf:	ff 37                	pushl  (%edi)
801077d1:	56                   	push   %esi
801077d2:	e8 49 fb ff ff       	call   80107320 <itoa>
  strcpy(status + size + 1, szBuf);
801077d7:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
801077dd:	83 c4 10             	add    $0x10,%esp
801077e0:	8d 4c 03 01          	lea    0x1(%ebx,%eax,1),%ecx
801077e4:	31 c0                	xor    %eax,%eax
801077e6:	8d 76 00             	lea    0x0(%esi),%esi
801077e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
801077f0:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801077f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
801077f7:	83 c0 01             	add    $0x1,%eax
801077fa:	84 d2                	test   %dl,%dl
801077fc:	75 f2                	jne    801077f0 <read_procfs_status+0x120>
  status[strlen(status)] = '\n';
801077fe:	83 ec 0c             	sub    $0xc,%esp
80107801:	53                   	push   %ebx
80107802:	e8 19 d0 ff ff       	call   80104820 <strlen>
  int status_size = strlen(status);
80107807:	89 1c 24             	mov    %ebx,(%esp)
  status[strlen(status)] = '\n';
8010780a:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
80107811:	0a 
  int status_size = strlen(status);
80107812:	e8 09 d0 ff ff       	call   80104820 <strlen>
  if (off + n > status_size)
80107817:	8b 55 10             	mov    0x10(%ebp),%edx
8010781a:	03 55 14             	add    0x14(%ebp),%edx
    n = status_size - off;
8010781d:	89 c6                	mov    %eax,%esi
8010781f:	2b 75 10             	sub    0x10(%ebp),%esi
  if (off + n > status_size)
80107822:	83 c4 0c             	add    $0xc,%esp
    n = status_size - off;
80107825:	39 c2                	cmp    %eax,%edx
80107827:	0f 4e 75 14          	cmovle 0x14(%ebp),%esi
  memmove(dst, (char*)(&status) + off, n);
8010782b:	03 5d 10             	add    0x10(%ebp),%ebx
8010782e:	56                   	push   %esi
8010782f:	53                   	push   %ebx
80107830:	ff 75 0c             	pushl  0xc(%ebp)
80107833:	e8 78 ce ff ff       	call   801046b0 <memmove>
}
80107838:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010783b:	89 f0                	mov    %esi,%eax
8010783d:	5b                   	pop    %ebx
8010783e:	5e                   	pop    %esi
8010783f:	5f                   	pop    %edi
80107840:	5d                   	pop    %ebp
80107841:	c3                   	ret    
80107842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107850 <read_procfs_name>:
{
80107850:	55                   	push   %ebp
	char name[250] = {0};
80107851:	31 c0                	xor    %eax,%eax
{
80107853:	89 e5                	mov    %esp,%ebp
80107855:	57                   	push   %edi
80107856:	56                   	push   %esi
80107857:	53                   	push   %ebx
	char name[250] = {0};
80107858:	8d 9d ee fe ff ff    	lea    -0x112(%ebp),%ebx
8010785e:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
	char szBuf[100] = {0};
80107864:	8d b5 8a fe ff ff    	lea    -0x176(%ebp),%esi
	char name[250] = {0};
8010786a:	89 d9                	mov    %ebx,%ecx
{
8010786c:	81 ec 88 01 00 00    	sub    $0x188,%esp
	char name[250] = {0};
80107872:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80107879:	00 00 00 
8010787c:	29 f9                	sub    %edi,%ecx
8010787e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107885:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
8010788b:	c1 e9 02             	shr    $0x2,%ecx
8010788e:	f3 ab                	rep stos %eax,%es:(%edi)
	char szBuf[100] = {0};
80107890:	8d bd 8c fe ff ff    	lea    -0x174(%ebp),%edi
80107896:	89 f1                	mov    %esi,%ecx
80107898:	c7 85 8a fe ff ff 00 	movl   $0x0,-0x176(%ebp)
8010789f:	00 00 00 
801078a2:	c7 85 ea fe ff ff 00 	movl   $0x0,-0x116(%ebp)
801078a9:	00 00 00 
801078ac:	29 f9                	sub    %edi,%ecx
801078ae:	83 c1 64             	add    $0x64,%ecx
801078b1:	c1 e9 02             	shr    $0x2,%ecx
801078b4:	f3 ab                	rep stos %eax,%es:(%edi)
	int pid = ip->inum - 700;
801078b6:	8b 45 08             	mov    0x8(%ebp),%eax
801078b9:	8b 40 04             	mov    0x4(%eax),%eax
801078bc:	2d bc 02 00 00       	sub    $0x2bc,%eax
  struct proc *p = find_proc_by_pid(pid);
801078c1:	50                   	push   %eax
801078c2:	e8 79 c9 ff ff       	call   80104240 <find_proc_by_pid>
  int size = strlen(p->name);
801078c7:	8d 78 6c             	lea    0x6c(%eax),%edi
  struct proc *p = find_proc_by_pid(pid);
801078ca:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
  int size = strlen(p->name);
801078d0:	89 3c 24             	mov    %edi,(%esp)
801078d3:	e8 48 cf ff ff       	call   80104820 <strlen>
801078d8:	83 c4 10             	add    $0x10,%esp
801078db:	31 d2                	xor    %edx,%edx
801078dd:	8d 76 00             	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
801078e0:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
801078e4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
801078e7:	83 c2 01             	add    $0x1,%edx
801078ea:	84 c9                	test   %cl,%cl
801078ec:	75 f2                	jne    801078e0 <read_procfs_name+0x90>
  name[size] = ' ';
801078ee:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
801078f5:	20 
801078f6:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
  itoa(szBuf, p->sz);
801078fc:	83 ec 08             	sub    $0x8,%esp
801078ff:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
80107905:	ff 30                	pushl  (%eax)
80107907:	56                   	push   %esi
80107908:	e8 13 fa ff ff       	call   80107320 <itoa>
  strcpy(name + size + 1, szBuf);
8010790d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
80107913:	83 c4 10             	add    $0x10,%esp
80107916:	8d 4c 03 01          	lea    0x1(%ebx,%eax,1),%ecx
8010791a:	31 c0                	xor    %eax,%eax
8010791c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80107920:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80107924:	88 14 01             	mov    %dl,(%ecx,%eax,1)
80107927:	83 c0 01             	add    $0x1,%eax
8010792a:	84 d2                	test   %dl,%dl
8010792c:	75 f2                	jne    80107920 <read_procfs_name+0xd0>
  name[strlen(name)] = '\n';
8010792e:	83 ec 0c             	sub    $0xc,%esp
80107931:	53                   	push   %ebx
80107932:	e8 e9 ce ff ff       	call   80104820 <strlen>
  int name_size = strlen(name);
80107937:	89 1c 24             	mov    %ebx,(%esp)
  name[strlen(name)] = '\n';
8010793a:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
80107941:	0a 
  int name_size = strlen(name);
80107942:	e8 d9 ce ff ff       	call   80104820 <strlen>
  if (off + n > name_size)
80107947:	8b 55 10             	mov    0x10(%ebp),%edx
8010794a:	03 55 14             	add    0x14(%ebp),%edx
    n = name_size - off;
8010794d:	89 c6                	mov    %eax,%esi
8010794f:	2b 75 10             	sub    0x10(%ebp),%esi
  if (off + n > name_size)
80107952:	83 c4 0c             	add    $0xc,%esp
    n = name_size - off;
80107955:	39 c2                	cmp    %eax,%edx
80107957:	0f 4e 75 14          	cmovle 0x14(%ebp),%esi
  memmove(dst, (char*)(&name) + off, n);
8010795b:	03 5d 10             	add    0x10(%ebp),%ebx
8010795e:	56                   	push   %esi
8010795f:	53                   	push   %ebx
80107960:	ff 75 0c             	pushl  0xc(%ebp)
80107963:	e8 48 cd ff ff       	call   801046b0 <memmove>
}
80107968:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010796b:	89 f0                	mov    %esi,%eax
8010796d:	5b                   	pop    %ebx
8010796e:	5e                   	pop    %esi
8010796f:	5f                   	pop    %edi
80107970:	5d                   	pop    %ebp
80107971:	c3                   	ret    
80107972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <read_path_level_2>:
{
80107980:	55                   	push   %ebp
  switch (ip->inum/100) {
80107981:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
{
80107986:	89 e5                	mov    %esp,%ebp
  switch (ip->inum/100) {
80107988:	8b 45 08             	mov    0x8(%ebp),%eax
8010798b:	8b 50 04             	mov    0x4(%eax),%edx
8010798e:	89 d0                	mov    %edx,%eax
80107990:	f7 e1                	mul    %ecx
80107992:	c1 ea 05             	shr    $0x5,%edx
80107995:	83 fa 07             	cmp    $0x7,%edx
80107998:	74 16                	je     801079b0 <read_path_level_2+0x30>
8010799a:	83 fa 08             	cmp    $0x8,%edx
8010799d:	75 09                	jne    801079a8 <read_path_level_2+0x28>
}
8010799f:	5d                   	pop    %ebp
      return read_procfs_status(ip, dst, off, n);
801079a0:	e9 2b fd ff ff       	jmp    801076d0 <read_procfs_status>
801079a5:	8d 76 00             	lea    0x0(%esi),%esi
}
801079a8:	31 c0                	xor    %eax,%eax
801079aa:	5d                   	pop    %ebp
801079ab:	c3                   	ret    
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079b0:	5d                   	pop    %ebp
      return read_procfs_name(ip, dst, off, n);
801079b1:	e9 9a fe ff ff       	jmp    80107850 <read_procfs_name>
801079b6:	8d 76 00             	lea    0x0(%esi),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <procfsread>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	83 ec 08             	sub    $0x8,%esp
  switch (ip->minor){
801079c6:	8b 45 08             	mov    0x8(%ebp),%eax
801079c9:	0f bf 50 54          	movswl 0x54(%eax),%edx
801079cd:	66 83 fa 01          	cmp    $0x1,%dx
801079d1:	74 4d                	je     80107a20 <procfsread+0x60>
801079d3:	7e 3b                	jle    80107a10 <procfsread+0x50>
801079d5:	66 83 fa 02          	cmp    $0x2,%dx
801079d9:	74 0d                	je     801079e8 <procfsread+0x28>
      return read_path_level_3(ip,dst,off,n);
801079db:	31 c0                	xor    %eax,%eax
  switch (ip->minor){
801079dd:	66 83 fa 03          	cmp    $0x3,%dx
801079e1:	75 0d                	jne    801079f0 <procfsread+0x30>
}
801079e3:	c9                   	leave  
801079e4:	c3                   	ret    
801079e5:	8d 76 00             	lea    0x0(%esi),%esi
801079e8:	c9                   	leave  
      return read_path_level_2(ip,dst,off,n);
801079e9:	eb 95                	jmp    80107980 <read_path_level_2>
801079eb:	90                   	nop
801079ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("procfsread minor: %d", ip->minor);
801079f0:	83 ec 08             	sub    $0x8,%esp
801079f3:	52                   	push   %edx
801079f4:	68 be 84 10 80       	push   $0x801084be
801079f9:	e8 62 8c ff ff       	call   80100660 <cprintf>
      return -1;
801079fe:	83 c4 10             	add    $0x10,%esp
80107a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a06:	c9                   	leave  
80107a07:	c3                   	ret    
80107a08:	90                   	nop
80107a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch (ip->minor){
80107a10:	66 85 d2             	test   %dx,%dx
80107a13:	75 db                	jne    801079f0 <procfsread+0x30>
}
80107a15:	c9                   	leave  
      return read_path_level_0(ip,dst,off,n);
80107a16:	e9 85 fa ff ff       	jmp    801074a0 <read_path_level_0>
80107a1b:	90                   	nop
80107a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80107a20:	c9                   	leave  
      return read_path_level_1(ip,dst,off,n);
80107a21:	e9 5a fc ff ff       	jmp    80107680 <read_path_level_1>
