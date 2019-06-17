
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc d0 da 10 80       	mov    $0x8010dad0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 32 10 80       	mov    $0x801032f0,%eax
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
80100044:	bb 14 db 10 80       	mov    $0x8010db14,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 86 10 80       	push   $0x801086a0
80100051:	68 e0 da 10 80       	push   $0x8010dae0
80100056:	e8 75 59 00 00       	call   801059d0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 22 11 80 dc 	movl   $0x801121dc,0x8011222c
80100062:	21 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 22 11 80 dc 	movl   $0x801121dc,0x80112230
8010006c:	21 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 21 11 80       	mov    $0x801121dc,%edx
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
8010008b:	c7 43 50 dc 21 11 80 	movl   $0x801121dc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 86 10 80       	push   $0x801086a7
80100097:	50                   	push   %eax
80100098:	e8 03 58 00 00       	call   801058a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 22 11 80       	mov    0x80112230,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 22 11 80    	mov    %ebx,0x80112230
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 21 11 80       	cmp    $0x801121dc,%eax
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
801000df:	68 e0 da 10 80       	push   $0x8010dae0
801000e4:	e8 27 5a 00 00       	call   80105b10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 22 11 80    	mov    0x80112230,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 21 11 80    	cmp    $0x801121dc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 21 11 80    	cmp    $0x801121dc,%ebx
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
80100120:	8b 1d 2c 22 11 80    	mov    0x8011222c,%ebx
80100126:	81 fb dc 21 11 80    	cmp    $0x801121dc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 21 11 80    	cmp    $0x801121dc,%ebx
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
8010015d:	68 e0 da 10 80       	push   $0x8010dae0
80100162:	e8 69 5a 00 00       	call   80105bd0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 57 00 00       	call   801058e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 23 00 00       	call   80102490 <iderw>
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
80100193:	68 ae 86 10 80       	push   $0x801086ae
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
801001ae:	e8 cd 57 00 00       	call   80105980 <holdingsleep>
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
801001c4:	e9 c7 22 00 00       	jmp    80102490 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 86 10 80       	push   $0x801086bf
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
801001ef:	e8 8c 57 00 00       	call   80105980 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 57 00 00       	call   80105940 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 da 10 80 	movl   $0x8010dae0,(%esp)
8010020b:	e8 00 59 00 00       	call   80105b10 <acquire>
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
80100232:	a1 30 22 11 80       	mov    0x80112230,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 21 11 80 	movl   $0x801121dc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 22 11 80       	mov    0x80112230,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 22 11 80    	mov    %ebx,0x80112230
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 da 10 80 	movl   $0x8010dae0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 6f 59 00 00       	jmp    80105bd0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 86 10 80       	push   $0x801086c6
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
80100280:	e8 3b 17 00 00       	call   801019c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 7f 58 00 00       	call   80105b10 <acquire>
  while(n > 0){
80100291:	8b 5d 14             	mov    0x14(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 24 11 80    	mov    0x801124c0,%edx
801002a7:	39 15 c4 24 11 80    	cmp    %edx,0x801124c4
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
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 c0 24 11 80       	push   $0x801124c0
801002c5:	e8 16 3f 00 00       	call   801041e0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 24 11 80    	mov    0x801124c0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 24 11 80    	cmp    0x801124c4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 60 39 00 00       	call   80103c40 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 dc 58 00 00       	call   80105bd0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 e4 15 00 00       	call   801018e0 <ilock>
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
80100313:	a3 c0 24 11 80       	mov    %eax,0x801124c0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 24 11 80 	movsbl -0x7feedbc0(%eax),%eax
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
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 7e 58 00 00       	call   80105bd0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 86 15 00 00       	call   801018e0 <ilock>
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
80100372:	89 15 c0 24 11 80    	mov    %edx,0x801124c0
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
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 d2 27 00 00       	call   80102b80 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 86 10 80       	push   $0x801086cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 53 92 10 80 	movl   $0x80109253,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 56 00 00       	call   801059f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 86 10 80       	push   $0x801086e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
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
8010043a:	e8 71 6e 00 00       	call   801072b0 <uartputc>
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
801004ec:	e8 bf 6d 00 00       	call   801072b0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 6d 00 00       	call   801072b0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 6d 00 00       	call   801072b0 <uartputc>
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
80100524:	e8 a7 57 00 00       	call   80105cd0 <memmove>
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
80100541:	e8 da 56 00 00       	call   80105c20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 86 10 80       	push   $0x801086e5
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
801005b1:	0f b6 92 10 87 10 80 	movzbl -0x7fef78f0(%edx),%edx
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
8010060f:	e8 ac 13 00 00       	call   801019c0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 f0 54 00 00       	call   80105b10 <acquire>
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
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 84 55 00 00       	call   80105bd0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 8b 12 00 00       	call   801018e0 <ilock>

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
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 ac 54 00 00       	call   80105bd0 <release>
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
801007d0:	ba f8 86 10 80       	mov    $0x801086f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 1b 53 00 00       	call   80105b10 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 86 10 80       	push   $0x801086ff
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
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 e8 52 00 00       	call   80105b10 <acquire>
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
80100851:	a1 c8 24 11 80       	mov    0x801124c8,%eax
80100856:	3b 05 c4 24 11 80    	cmp    0x801124c4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 24 11 80       	mov    %eax,0x801124c8
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
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 43 53 00 00       	call   80105bd0 <release>
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
801008a9:	a1 c8 24 11 80       	mov    0x801124c8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 24 11 80    	sub    0x801124c0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 24 11 80    	mov    %edx,0x801124c8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 24 11 80    	mov    %cl,-0x7feedbc0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 24 11 80       	mov    0x801124c0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 24 11 80    	cmp    %eax,0x801124c8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 24 11 80       	mov    %eax,0x801124c4
          wakeup(&input.r);
80100911:	68 c0 24 11 80       	push   $0x801124c0
80100916:	e8 75 3a 00 00       	call   80104390 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 24 11 80       	mov    0x801124c8,%eax
8010093d:	39 05 c4 24 11 80    	cmp    %eax,0x801124c4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 24 11 80       	mov    %eax,0x801124c8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 24 11 80       	mov    0x801124c8,%eax
80100964:	3b 05 c4 24 11 80    	cmp    0x801124c4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 24 11 80 0a 	cmpb   $0xa,-0x7feedbc0(%edx)
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
80100997:	e9 d4 3a 00 00       	jmp    80104470 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 24 11 80 0a 	movb   $0xa,-0x7feedbc0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 24 11 80       	mov    0x801124c8,%eax
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
801009c6:	68 08 87 10 80       	push   $0x80108708
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 fb 4f 00 00       	call   801059d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 3c 30 11 80 00 	movl   $0x80100600,0x8011303c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 38 30 11 80 70 	movl   $0x80100270,0x80113038
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 22 1d 00 00       	call   80102720 <ioapicenable>
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
80100a1c:	e8 1f 32 00 00       	call   80103c40 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 c4 25 00 00       	call   80102ff0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 99 17 00 00       	call   801021d0 <namei>
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
80100a48:	e8 93 0e 00 00       	call   801018e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 62 11 00 00       	call   80101bc0 <readi>
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
80100a6a:	e8 01 11 00 00       	call   80101b70 <iunlockput>
    end_op();
80100a6f:	e8 ec 25 00 00       	call   80103060 <end_op>
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
80100a94:	e8 67 79 00 00       	call   80108400 <setupkvm>
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
80100af6:	e8 25 77 00 00       	call   80108220 <allocuvm>
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
80100b28:	e8 33 76 00 00       	call   80108160 <loaduvm>
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
80100b58:	e8 63 10 00 00       	call   80101bc0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 09 78 00 00       	call   80108380 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 d6 0f 00 00       	call   80101b70 <iunlockput>
  end_op();
80100b9a:	e8 c1 24 00 00       	call   80103060 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 71 76 00 00       	call   80108220 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ba 77 00 00       	call   80108380 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 88 24 00 00       	call   80103060 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 87 10 80       	push   $0x80108721
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
80100c06:	e8 95 78 00 00       	call   801084a0 <clearpteu>
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
80100c39:	e8 02 52 00 00       	call   80105e40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 51 00 00       	call   80105e40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 79 00 00       	call   80108600 <copyout>
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
80100cc7:	e8 34 79 00 00       	call   80108600 <copyout>
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
80100d0a:	e8 f1 50 00 00       	call   80105e00 <safestrcpy>
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
80100d34:	e8 97 72 00 00       	call   80107fd0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 3f 76 00 00       	call   80108380 <freevm>
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
80100d66:	68 2d 87 10 80       	push   $0x8010872d
80100d6b:	68 80 26 11 80       	push   $0x80112680
80100d70:	e8 5b 4c 00 00       	call   801059d0 <initlock>
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
80100d84:	bb b4 26 11 80       	mov    $0x801126b4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 80 26 11 80       	push   $0x80112680
80100d91:	e8 7a 4d 00 00       	call   80105b10 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 14 30 11 80    	cmp    $0x80113014,%ebx
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
80100dbc:	68 80 26 11 80       	push   $0x80112680
80100dc1:	e8 0a 4e 00 00       	call   80105bd0 <release>
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
80100dd5:	68 80 26 11 80       	push   $0x80112680
80100dda:	e8 f1 4d 00 00       	call   80105bd0 <release>
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
80100dfa:	68 80 26 11 80       	push   $0x80112680
80100dff:	e8 0c 4d 00 00       	call   80105b10 <acquire>
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
80100e17:	68 80 26 11 80       	push   $0x80112680
80100e1c:	e8 af 4d 00 00       	call   80105bd0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 87 10 80       	push   $0x80108734
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
80100e4c:	68 80 26 11 80       	push   $0x80112680
80100e51:	e8 ba 4c 00 00       	call   80105b10 <acquire>
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
80100e6e:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
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
80100e7c:	e9 4f 4d 00 00       	jmp    80105bd0 <release>
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
80100ea0:	68 80 26 11 80       	push   $0x80112680
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 23 4d 00 00       	call   80105bd0 <release>
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
80100ed1:	e8 ca 28 00 00       	call   801037a0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 0b 21 00 00       	call   80102ff0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 20 0b 00 00       	call   80101a10 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 61 21 00 00       	jmp    80103060 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 87 10 80       	push   $0x8010873c
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
80100f25:	e8 b6 09 00 00       	call   801018e0 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 59 0c 00 00       	call   80101b90 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 80 0a 00 00       	call   801019c0 <iunlock>
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
80100f8a:	e8 51 09 00 00       	call   801018e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 24 0c 00 00       	call   80101bc0 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 0d 0a 00 00       	call   801019c0 <iunlock>
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
80100fcd:	e9 7e 29 00 00       	jmp    80103950 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 87 10 80       	push   $0x80108746
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
80101044:	e8 77 09 00 00       	call   801019c0 <iunlock>
      end_op();
80101049:	e8 12 20 00 00       	call   80103060 <end_op>
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
80101076:	e8 75 1f 00 00       	call   80102ff0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 5a 08 00 00       	call   801018e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 28 0c 00 00       	call   80101cc0 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 13 09 00 00       	call   801019c0 <iunlock>
      end_op();
801010ad:	e8 ae 1f 00 00       	call   80103060 <end_op>
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
801010ed:	e9 4e 27 00 00       	jmp    80103840 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 87 10 80       	push   $0x8010874f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 87 10 80       	push   $0x80108755
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
80101119:	68 80 26 11 80       	push   $0x80112680
8010111e:	e8 ed 49 00 00       	call   80105b10 <acquire>
80101123:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101126:	ba b4 26 11 80       	mov    $0x801126b4,%edx
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->ref == 0){
      counter++;
80101130:	83 7a 04 01          	cmpl   $0x1,0x4(%edx)
80101134:	83 d3 00             	adc    $0x0,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101137:	83 c2 18             	add    $0x18,%edx
8010113a:	81 fa 14 30 11 80    	cmp    $0x80113014,%edx
80101140:	72 ee                	jb     80101130 <get_free_fds+0x20>
    }
  }
  release(&ftable.lock);
80101142:	83 ec 0c             	sub    $0xc,%esp
80101145:	68 80 26 11 80       	push   $0x80112680
8010114a:	e8 81 4a 00 00       	call   80105bd0 <release>
  return counter;
}
8010114f:	89 d8                	mov    %ebx,%eax
80101151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101154:	c9                   	leave  
80101155:	c3                   	ret    
80101156:	8d 76 00             	lea    0x0(%esi),%esi
80101159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101160 <get_unique_inode_fds>:

int uniqueInodes[NFILE];

int
get_unique_inode_fds(void)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	56                   	push   %esi
80101164:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101165:	31 f6                	xor    %esi,%esi

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101167:	bb b4 26 11 80       	mov    $0x801126b4,%ebx
  acquire(&ftable.lock);
8010116c:	83 ec 0c             	sub    $0xc,%esp
8010116f:	68 80 26 11 80       	push   $0x80112680
80101174:	e8 97 49 00 00       	call   80105b10 <acquire>
80101179:	83 c4 10             	add    $0x10,%esp
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int index = inUniqueInodes(f->ip->inum);
80101180:	8b 53 10             	mov    0x10(%ebx),%edx
80101183:	8b 42 04             	mov    0x4(%edx),%eax
// finds the inum in the uniqueInodes array and returmn -1 if it exist
// if not, return the next free index in the array
int
inUniqueInodes(int inum)
{
  for(int i = 0; i < NFILE; i++){
80101186:	31 d2                	xor    %edx,%edx
80101188:	eb 12                	jmp    8010119c <get_unique_inode_fds+0x3c>
8010118a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(uniqueInodes[i] == inum){ // inum found in the array
      return -1;
    }
    if(uniqueInodes[i] == 0){ // empty spot
80101190:	85 c9                	test   %ecx,%ecx
80101192:	74 3c                	je     801011d0 <get_unique_inode_fds+0x70>
  for(int i = 0; i < NFILE; i++){
80101194:	83 c2 01             	add    $0x1,%edx
80101197:	83 fa 64             	cmp    $0x64,%edx
8010119a:	74 0b                	je     801011a7 <get_unique_inode_fds+0x47>
    if(uniqueInodes[i] == inum){ // inum found in the array
8010119c:	8b 0c 95 e0 24 11 80 	mov    -0x7feedb20(,%edx,4),%ecx
801011a3:	39 c8                	cmp    %ecx,%eax
801011a5:	75 e9                	jne    80101190 <get_unique_inode_fds+0x30>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011a7:	83 c3 18             	add    $0x18,%ebx
801011aa:	81 fb 14 30 11 80    	cmp    $0x80113014,%ebx
801011b0:	72 ce                	jb     80101180 <get_unique_inode_fds+0x20>
  release(&ftable.lock);
801011b2:	83 ec 0c             	sub    $0xc,%esp
801011b5:	68 80 26 11 80       	push   $0x80112680
801011ba:	e8 11 4a 00 00       	call   80105bd0 <release>
}
801011bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011c2:	89 f0                	mov    %esi,%eax
801011c4:	5b                   	pop    %ebx
801011c5:	5e                   	pop    %esi
801011c6:	5d                   	pop    %ebp
801011c7:	c3                   	ret    
801011c8:	90                   	nop
801011c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d0:	83 c3 18             	add    $0x18,%ebx
      counter++;
801011d3:	83 c6 01             	add    $0x1,%esi
      uniqueInodes[index] = f->ip->inum;
801011d6:	89 04 95 e0 24 11 80 	mov    %eax,-0x7feedb20(,%edx,4)
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011dd:	81 fb 14 30 11 80    	cmp    $0x80113014,%ebx
801011e3:	72 9b                	jb     80101180 <get_unique_inode_fds+0x20>
801011e5:	eb cb                	jmp    801011b2 <get_unique_inode_fds+0x52>
801011e7:	89 f6                	mov    %esi,%esi
801011e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011f0 <inUniqueInodes>:
{
801011f0:	55                   	push   %ebp
  for(int i = 0; i < NFILE; i++){
801011f1:	31 c0                	xor    %eax,%eax
{
801011f3:	89 e5                	mov    %esp,%ebp
801011f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801011f8:	eb 12                	jmp    8010120c <inUniqueInodes+0x1c>
801011fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(uniqueInodes[i] == 0){ // empty spot
80101200:	85 d2                	test   %edx,%edx
80101202:	74 18                	je     8010121c <inUniqueInodes+0x2c>
  for(int i = 0; i < NFILE; i++){
80101204:	83 c0 01             	add    $0x1,%eax
80101207:	83 f8 64             	cmp    $0x64,%eax
8010120a:	74 0b                	je     80101217 <inUniqueInodes+0x27>
    if(uniqueInodes[i] == inum){ // inum found in the array
8010120c:	8b 14 85 e0 24 11 80 	mov    -0x7feedb20(,%eax,4),%edx
80101213:	39 ca                	cmp    %ecx,%edx
80101215:	75 e9                	jne    80101200 <inUniqueInodes+0x10>
      return -1;
80101217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return i;
    }
  }
  return -1; // no empty spot
}
8010121c:	5d                   	pop    %ebp
8010121d:	c3                   	ret    
8010121e:	66 90                	xchg   %ax,%ax

80101220 <get_writeable_fds>:

int
get_writeable_fds(void)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101224:	31 db                	xor    %ebx,%ebx
{
80101226:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101229:	68 80 26 11 80       	push   $0x80112680
8010122e:	e8 dd 48 00 00       	call   80105b10 <acquire>
80101233:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101236:	ba b4 26 11 80       	mov    $0x801126b4,%edx
8010123b:	90                   	nop
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->writable){
      counter++;
80101240:	80 7a 09 01          	cmpb   $0x1,0x9(%edx)
80101244:	83 db ff             	sbb    $0xffffffff,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101247:	83 c2 18             	add    $0x18,%edx
8010124a:	81 fa 14 30 11 80    	cmp    $0x80113014,%edx
80101250:	72 ee                	jb     80101240 <get_writeable_fds+0x20>
    }
  }
  release(&ftable.lock);
80101252:	83 ec 0c             	sub    $0xc,%esp
80101255:	68 80 26 11 80       	push   $0x80112680
8010125a:	e8 71 49 00 00       	call   80105bd0 <release>
  return counter;
}
8010125f:	89 d8                	mov    %ebx,%eax
80101261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101264:	c9                   	leave  
80101265:	c3                   	ret    
80101266:	8d 76 00             	lea    0x0(%esi),%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101270 <get_readable_fds>:

int
get_readable_fds(void)
{
80101270:	55                   	push   %ebp
80101271:	89 e5                	mov    %esp,%ebp
80101273:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101274:	31 db                	xor    %ebx,%ebx
{
80101276:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101279:	68 80 26 11 80       	push   $0x80112680
8010127e:	e8 8d 48 00 00       	call   80105b10 <acquire>
80101283:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101286:	ba b4 26 11 80       	mov    $0x801126b4,%edx
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->readable){
      counter++;
80101290:	80 7a 08 01          	cmpb   $0x1,0x8(%edx)
80101294:	83 db ff             	sbb    $0xffffffff,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101297:	83 c2 18             	add    $0x18,%edx
8010129a:	81 fa 14 30 11 80    	cmp    $0x80113014,%edx
801012a0:	72 ee                	jb     80101290 <get_readable_fds+0x20>
    }
  }
  release(&ftable.lock);
801012a2:	83 ec 0c             	sub    $0xc,%esp
801012a5:	68 80 26 11 80       	push   $0x80112680
801012aa:	e8 21 49 00 00       	call   80105bd0 <release>
  return counter;
}
801012af:	89 d8                	mov    %ebx,%eax
801012b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012b4:	c9                   	leave  
801012b5:	c3                   	ret    
801012b6:	8d 76 00             	lea    0x0(%esi),%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012c0 <get_total_refs>:

int
get_total_refs(void)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
801012c4:	31 db                	xor    %ebx,%ebx
{
801012c6:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
801012c9:	68 80 26 11 80       	push   $0x80112680
801012ce:	e8 3d 48 00 00       	call   80105b10 <acquire>
801012d3:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012d6:	ba b4 26 11 80       	mov    $0x801126b4,%edx
801012db:	90                   	nop
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    counter = counter + f->ref;
801012e0:	03 5a 04             	add    0x4(%edx),%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012e3:	83 c2 18             	add    $0x18,%edx
801012e6:	81 fa 14 30 11 80    	cmp    $0x80113014,%edx
801012ec:	72 f2                	jb     801012e0 <get_total_refs+0x20>
  }
  release(&ftable.lock);
801012ee:	83 ec 0c             	sub    $0xc,%esp
801012f1:	68 80 26 11 80       	push   $0x80112680
801012f6:	e8 d5 48 00 00       	call   80105bd0 <release>
  return counter;
}
801012fb:	89 d8                	mov    %ebx,%eax
801012fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101300:	c9                   	leave  
80101301:	c3                   	ret    
80101302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101310 <get_used_fds>:

int
get_used_fds(void)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	53                   	push   %ebx
  struct file *f;
  int counter = 0;
80101314:	31 db                	xor    %ebx,%ebx
{
80101316:	83 ec 10             	sub    $0x10,%esp

  acquire(&ftable.lock);
80101319:	68 80 26 11 80       	push   $0x80112680
8010131e:	e8 ed 47 00 00       	call   80105b10 <acquire>
80101323:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101326:	ba b4 26 11 80       	mov    $0x801126b4,%edx
8010132b:	90                   	nop
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->type == FD_INODE){
      counter++;
80101330:	31 c0                	xor    %eax,%eax
80101332:	83 3a 02             	cmpl   $0x2,(%edx)
80101335:	0f 94 c0             	sete   %al
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101338:	83 c2 18             	add    $0x18,%edx
      counter++;
8010133b:	01 c3                	add    %eax,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010133d:	81 fa 14 30 11 80    	cmp    $0x80113014,%edx
80101343:	72 eb                	jb     80101330 <get_used_fds+0x20>
    }
  }
  release(&ftable.lock);
80101345:	83 ec 0c             	sub    $0xc,%esp
80101348:	68 80 26 11 80       	push   $0x80112680
8010134d:	e8 7e 48 00 00       	call   80105bd0 <release>
  return counter;
}
80101352:	89 d8                	mov    %ebx,%eax
80101354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101357:	c9                   	leave  
80101358:	c3                   	ret    
80101359:	66 90                	xchg   %ax,%ax
8010135b:	66 90                	xchg   %ax,%ax
8010135d:	66 90                	xchg   %ax,%ax
8010135f:	90                   	nop

80101360 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101369:	8b 0d c0 30 11 80    	mov    0x801130c0,%ecx
{
8010136f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101372:	85 c9                	test   %ecx,%ecx
80101374:	0f 84 87 00 00 00    	je     80101401 <balloc+0xa1>
8010137a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101381:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101384:	83 ec 08             	sub    $0x8,%esp
80101387:	89 f0                	mov    %esi,%eax
80101389:	c1 f8 0c             	sar    $0xc,%eax
8010138c:	03 05 d8 30 11 80    	add    0x801130d8,%eax
80101392:	50                   	push   %eax
80101393:	ff 75 d8             	pushl  -0x28(%ebp)
80101396:	e8 35 ed ff ff       	call   801000d0 <bread>
8010139b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010139e:	a1 c0 30 11 80       	mov    0x801130c0,%eax
801013a3:	83 c4 10             	add    $0x10,%esp
801013a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013a9:	31 c0                	xor    %eax,%eax
801013ab:	eb 2f                	jmp    801013dc <balloc+0x7c>
801013ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013b0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013b5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013ba:	83 e1 07             	and    $0x7,%ecx
801013bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013bf:	89 c1                	mov    %eax,%ecx
801013c1:	c1 f9 03             	sar    $0x3,%ecx
801013c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013c9:	85 df                	test   %ebx,%edi
801013cb:	89 fa                	mov    %edi,%edx
801013cd:	74 41                	je     80101410 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cf:	83 c0 01             	add    $0x1,%eax
801013d2:	83 c6 01             	add    $0x1,%esi
801013d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013da:	74 05                	je     801013e1 <balloc+0x81>
801013dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013df:	77 cf                	ja     801013b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013e7:	e8 f4 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013f3:	83 c4 10             	add    $0x10,%esp
801013f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013f9:	39 05 c0 30 11 80    	cmp    %eax,0x801130c0
801013ff:	77 80                	ja     80101381 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101401:	83 ec 0c             	sub    $0xc,%esp
80101404:	68 5f 87 10 80       	push   $0x8010875f
80101409:	e8 82 ef ff ff       	call   80100390 <panic>
8010140e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101413:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101416:	09 da                	or     %ebx,%edx
80101418:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010141c:	57                   	push   %edi
8010141d:	e8 9e 1d 00 00       	call   801031c0 <log_write>
        brelse(bp);
80101422:	89 3c 24             	mov    %edi,(%esp)
80101425:	e8 b6 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010142a:	58                   	pop    %eax
8010142b:	5a                   	pop    %edx
8010142c:	56                   	push   %esi
8010142d:	ff 75 d8             	pushl  -0x28(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
80101435:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101437:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143a:	83 c4 0c             	add    $0xc,%esp
8010143d:	68 00 02 00 00       	push   $0x200
80101442:	6a 00                	push   $0x0
80101444:	50                   	push   %eax
80101445:	e8 d6 47 00 00       	call   80105c20 <memset>
  log_write(bp);
8010144a:	89 1c 24             	mov    %ebx,(%esp)
8010144d:	e8 6e 1d 00 00       	call   801031c0 <log_write>
  brelse(bp);
80101452:	89 1c 24             	mov    %ebx,(%esp)
80101455:	e8 86 ed ff ff       	call   801001e0 <brelse>
}
8010145a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145d:	89 f0                	mov    %esi,%eax
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5f                   	pop    %edi
80101462:	5d                   	pop    %ebp
80101463:	c3                   	ret    
80101464:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010146a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101470 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	53                   	push   %ebx
80101476:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101478:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010147a:	bb 14 31 11 80       	mov    $0x80113114,%ebx
{
8010147f:	83 ec 28             	sub    $0x28,%esp
80101482:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101485:	68 e0 30 11 80       	push   $0x801130e0
8010148a:	e8 81 46 00 00       	call   80105b10 <acquire>
8010148f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101492:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101495:	eb 17                	jmp    801014ae <iget+0x3e>
80101497:	89 f6                	mov    %esi,%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801014a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a6:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
801014ac:	73 22                	jae    801014d0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801014b1:	85 c9                	test   %ecx,%ecx
801014b3:	7e 04                	jle    801014b9 <iget+0x49>
801014b5:	39 3b                	cmp    %edi,(%ebx)
801014b7:	74 4f                	je     80101508 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014b9:	85 f6                	test   %esi,%esi
801014bb:	75 e3                	jne    801014a0 <iget+0x30>
801014bd:	85 c9                	test   %ecx,%ecx
801014bf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014c2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014c8:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
801014ce:	72 de                	jb     801014ae <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014d0:	85 f6                	test   %esi,%esi
801014d2:	74 5b                	je     8010152f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014d4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014d7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014d9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014dc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014e3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014ea:	68 e0 30 11 80       	push   $0x801130e0
801014ef:	e8 dc 46 00 00       	call   80105bd0 <release>

  return ip;
801014f4:	83 c4 10             	add    $0x10,%esp
}
801014f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014fa:	89 f0                	mov    %esi,%eax
801014fc:	5b                   	pop    %ebx
801014fd:	5e                   	pop    %esi
801014fe:	5f                   	pop    %edi
801014ff:	5d                   	pop    %ebp
80101500:	c3                   	ret    
80101501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101508:	39 53 04             	cmp    %edx,0x4(%ebx)
8010150b:	75 ac                	jne    801014b9 <iget+0x49>
      release(&icache.lock);
8010150d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101510:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101513:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101515:	68 e0 30 11 80       	push   $0x801130e0
      ip->ref++;
8010151a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010151d:	e8 ae 46 00 00       	call   80105bd0 <release>
      return ip;
80101522:	83 c4 10             	add    $0x10,%esp
}
80101525:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101528:	89 f0                	mov    %esi,%eax
8010152a:	5b                   	pop    %ebx
8010152b:	5e                   	pop    %esi
8010152c:	5f                   	pop    %edi
8010152d:	5d                   	pop    %ebp
8010152e:	c3                   	ret    
    panic("iget: no inodes");
8010152f:	83 ec 0c             	sub    $0xc,%esp
80101532:	68 75 87 10 80       	push   $0x80108775
80101537:	e8 54 ee ff ff       	call   80100390 <panic>
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	89 c6                	mov    %eax,%esi
80101548:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010154b:	83 fa 0b             	cmp    $0xb,%edx
8010154e:	77 18                	ja     80101568 <bmap+0x28>
80101550:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101553:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101556:	85 db                	test   %ebx,%ebx
80101558:	74 76                	je     801015d0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010155a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155d:	89 d8                	mov    %ebx,%eax
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5f                   	pop    %edi
80101562:	5d                   	pop    %ebp
80101563:	c3                   	ret    
80101564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101568:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010156b:	83 fb 7f             	cmp    $0x7f,%ebx
8010156e:	0f 87 90 00 00 00    	ja     80101604 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101574:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010157a:	8b 00                	mov    (%eax),%eax
8010157c:	85 d2                	test   %edx,%edx
8010157e:	74 70                	je     801015f0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	52                   	push   %edx
80101584:	50                   	push   %eax
80101585:	e8 46 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010158a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010158e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101591:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101593:	8b 1a                	mov    (%edx),%ebx
80101595:	85 db                	test   %ebx,%ebx
80101597:	75 1d                	jne    801015b6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101599:	8b 06                	mov    (%esi),%eax
8010159b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010159e:	e8 bd fd ff ff       	call   80101360 <balloc>
801015a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801015a6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015a9:	89 c3                	mov    %eax,%ebx
801015ab:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801015ad:	57                   	push   %edi
801015ae:	e8 0d 1c 00 00       	call   801031c0 <log_write>
801015b3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801015b6:	83 ec 0c             	sub    $0xc,%esp
801015b9:	57                   	push   %edi
801015ba:	e8 21 ec ff ff       	call   801001e0 <brelse>
801015bf:	83 c4 10             	add    $0x10,%esp
}
801015c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015c5:	89 d8                	mov    %ebx,%eax
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
801015cb:	c3                   	ret    
801015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801015d0:	8b 00                	mov    (%eax),%eax
801015d2:	e8 89 fd ff ff       	call   80101360 <balloc>
801015d7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801015da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801015dd:	89 c3                	mov    %eax,%ebx
}
801015df:	89 d8                	mov    %ebx,%eax
801015e1:	5b                   	pop    %ebx
801015e2:	5e                   	pop    %esi
801015e3:	5f                   	pop    %edi
801015e4:	5d                   	pop    %ebp
801015e5:	c3                   	ret    
801015e6:	8d 76 00             	lea    0x0(%esi),%esi
801015e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015f0:	e8 6b fd ff ff       	call   80101360 <balloc>
801015f5:	89 c2                	mov    %eax,%edx
801015f7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015fd:	8b 06                	mov    (%esi),%eax
801015ff:	e9 7c ff ff ff       	jmp    80101580 <bmap+0x40>
  panic("bmap: out of range");
80101604:	83 ec 0c             	sub    $0xc,%esp
80101607:	68 85 87 10 80       	push   $0x80108785
8010160c:	e8 7f ed ff ff       	call   80100390 <panic>
80101611:	eb 0d                	jmp    80101620 <readsb>
80101613:	90                   	nop
80101614:	90                   	nop
80101615:	90                   	nop
80101616:	90                   	nop
80101617:	90                   	nop
80101618:	90                   	nop
80101619:	90                   	nop
8010161a:	90                   	nop
8010161b:	90                   	nop
8010161c:	90                   	nop
8010161d:	90                   	nop
8010161e:	90                   	nop
8010161f:	90                   	nop

80101620 <readsb>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101628:	83 ec 08             	sub    $0x8,%esp
8010162b:	6a 01                	push   $0x1
8010162d:	ff 75 08             	pushl  0x8(%ebp)
80101630:	e8 9b ea ff ff       	call   801000d0 <bread>
80101635:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101637:	8d 40 5c             	lea    0x5c(%eax),%eax
8010163a:	83 c4 0c             	add    $0xc,%esp
8010163d:	6a 1c                	push   $0x1c
8010163f:	50                   	push   %eax
80101640:	56                   	push   %esi
80101641:	e8 8a 46 00 00       	call   80105cd0 <memmove>
  brelse(bp);
80101646:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101649:	83 c4 10             	add    $0x10,%esp
}
8010164c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010164f:	5b                   	pop    %ebx
80101650:	5e                   	pop    %esi
80101651:	5d                   	pop    %ebp
  brelse(bp);
80101652:	e9 89 eb ff ff       	jmp    801001e0 <brelse>
80101657:	89 f6                	mov    %esi,%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101660 <bfree>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	89 d3                	mov    %edx,%ebx
80101667:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	68 c0 30 11 80       	push   $0x801130c0
80101671:	50                   	push   %eax
80101672:	e8 a9 ff ff ff       	call   80101620 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101677:	58                   	pop    %eax
80101678:	5a                   	pop    %edx
80101679:	89 da                	mov    %ebx,%edx
8010167b:	c1 ea 0c             	shr    $0xc,%edx
8010167e:	03 15 d8 30 11 80    	add    0x801130d8,%edx
80101684:	52                   	push   %edx
80101685:	56                   	push   %esi
80101686:	e8 45 ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010168b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010168d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101690:	ba 01 00 00 00       	mov    $0x1,%edx
80101695:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101698:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010169e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801016a1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801016a3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801016a8:	85 d1                	test   %edx,%ecx
801016aa:	74 25                	je     801016d1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801016ac:	f7 d2                	not    %edx
801016ae:	89 c6                	mov    %eax,%esi
  log_write(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801016b3:	21 ca                	and    %ecx,%edx
801016b5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801016b9:	56                   	push   %esi
801016ba:	e8 01 1b 00 00       	call   801031c0 <log_write>
  brelse(bp);
801016bf:	89 34 24             	mov    %esi,(%esp)
801016c2:	e8 19 eb ff ff       	call   801001e0 <brelse>
}
801016c7:	83 c4 10             	add    $0x10,%esp
801016ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016cd:	5b                   	pop    %ebx
801016ce:	5e                   	pop    %esi
801016cf:	5d                   	pop    %ebp
801016d0:	c3                   	ret    
    panic("freeing free block");
801016d1:	83 ec 0c             	sub    $0xc,%esp
801016d4:	68 98 87 10 80       	push   $0x80108798
801016d9:	e8 b2 ec ff ff       	call   80100390 <panic>
801016de:	66 90                	xchg   %ax,%ax

801016e0 <iinit>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	bb 20 31 11 80       	mov    $0x80113120,%ebx
801016e9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801016ec:	68 ab 87 10 80       	push   $0x801087ab
801016f1:	68 e0 30 11 80       	push   $0x801130e0
801016f6:	e8 d5 42 00 00       	call   801059d0 <initlock>
801016fb:	83 c4 10             	add    $0x10,%esp
801016fe:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101700:	83 ec 08             	sub    $0x8,%esp
80101703:	68 b2 87 10 80       	push   $0x801087b2
80101708:	53                   	push   %ebx
80101709:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010170f:	e8 8c 41 00 00       	call   801058a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101714:	83 c4 10             	add    $0x10,%esp
80101717:	81 fb 40 4d 11 80    	cmp    $0x80114d40,%ebx
8010171d:	75 e1                	jne    80101700 <iinit+0x20>
  readsb(dev, &sb);
8010171f:	83 ec 08             	sub    $0x8,%esp
80101722:	68 c0 30 11 80       	push   $0x801130c0
80101727:	ff 75 08             	pushl  0x8(%ebp)
8010172a:	e8 f1 fe ff ff       	call   80101620 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010172f:	ff 35 d8 30 11 80    	pushl  0x801130d8
80101735:	ff 35 d4 30 11 80    	pushl  0x801130d4
8010173b:	ff 35 d0 30 11 80    	pushl  0x801130d0
80101741:	ff 35 cc 30 11 80    	pushl  0x801130cc
80101747:	ff 35 c8 30 11 80    	pushl  0x801130c8
8010174d:	ff 35 c4 30 11 80    	pushl  0x801130c4
80101753:	ff 35 c0 30 11 80    	pushl  0x801130c0
80101759:	68 18 88 10 80       	push   $0x80108818
8010175e:	e8 fd ee ff ff       	call   80100660 <cprintf>
}
80101763:	83 c4 30             	add    $0x30,%esp
80101766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101769:	c9                   	leave  
8010176a:	c3                   	ret    
8010176b:	90                   	nop
8010176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101770 <ialloc>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	57                   	push   %edi
80101774:	56                   	push   %esi
80101775:	53                   	push   %ebx
80101776:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101779:	83 3d c8 30 11 80 01 	cmpl   $0x1,0x801130c8
{
80101780:	8b 45 0c             	mov    0xc(%ebp),%eax
80101783:	8b 75 08             	mov    0x8(%ebp),%esi
80101786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101789:	0f 86 91 00 00 00    	jbe    80101820 <ialloc+0xb0>
8010178f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101794:	eb 21                	jmp    801017b7 <ialloc+0x47>
80101796:	8d 76 00             	lea    0x0(%esi),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801017a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017a3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801017a6:	57                   	push   %edi
801017a7:	e8 34 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801017ac:	83 c4 10             	add    $0x10,%esp
801017af:	39 1d c8 30 11 80    	cmp    %ebx,0x801130c8
801017b5:	76 69                	jbe    80101820 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017b7:	89 d8                	mov    %ebx,%eax
801017b9:	83 ec 08             	sub    $0x8,%esp
801017bc:	c1 e8 03             	shr    $0x3,%eax
801017bf:	03 05 d4 30 11 80    	add    0x801130d4,%eax
801017c5:	50                   	push   %eax
801017c6:	56                   	push   %esi
801017c7:	e8 04 e9 ff ff       	call   801000d0 <bread>
801017cc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801017ce:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801017d0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801017d3:	83 e0 07             	and    $0x7,%eax
801017d6:	c1 e0 06             	shl    $0x6,%eax
801017d9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017e1:	75 bd                	jne    801017a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017e3:	83 ec 04             	sub    $0x4,%esp
801017e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017e9:	6a 40                	push   $0x40
801017eb:	6a 00                	push   $0x0
801017ed:	51                   	push   %ecx
801017ee:	e8 2d 44 00 00       	call   80105c20 <memset>
      dip->type = type;
801017f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017fd:	89 3c 24             	mov    %edi,(%esp)
80101800:	e8 bb 19 00 00       	call   801031c0 <log_write>
      brelse(bp);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 d3 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010180d:	83 c4 10             	add    $0x10,%esp
}
80101810:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101813:	89 da                	mov    %ebx,%edx
80101815:	89 f0                	mov    %esi,%eax
}
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010181b:	e9 50 fc ff ff       	jmp    80101470 <iget>
  panic("ialloc: no inodes");
80101820:	83 ec 0c             	sub    $0xc,%esp
80101823:	68 b8 87 10 80       	push   $0x801087b8
80101828:	e8 63 eb ff ff       	call   80100390 <panic>
8010182d:	8d 76 00             	lea    0x0(%esi),%esi

80101830 <iupdate>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101838:	83 ec 08             	sub    $0x8,%esp
8010183b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101841:	c1 e8 03             	shr    $0x3,%eax
80101844:	03 05 d4 30 11 80    	add    0x801130d4,%eax
8010184a:	50                   	push   %eax
8010184b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010184e:	e8 7d e8 ff ff       	call   801000d0 <bread>
80101853:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101855:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101858:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185f:	83 e0 07             	and    $0x7,%eax
80101862:	c1 e0 06             	shl    $0x6,%eax
80101865:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101869:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010186c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101870:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101873:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101877:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010187b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010187f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101883:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101887:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010188a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010188d:	6a 34                	push   $0x34
8010188f:	53                   	push   %ebx
80101890:	50                   	push   %eax
80101891:	e8 3a 44 00 00       	call   80105cd0 <memmove>
  log_write(bp);
80101896:	89 34 24             	mov    %esi,(%esp)
80101899:	e8 22 19 00 00       	call   801031c0 <log_write>
  brelse(bp);
8010189e:	89 75 08             	mov    %esi,0x8(%ebp)
801018a1:	83 c4 10             	add    $0x10,%esp
}
801018a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a7:	5b                   	pop    %ebx
801018a8:	5e                   	pop    %esi
801018a9:	5d                   	pop    %ebp
  brelse(bp);
801018aa:	e9 31 e9 ff ff       	jmp    801001e0 <brelse>
801018af:	90                   	nop

801018b0 <idup>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	53                   	push   %ebx
801018b4:	83 ec 10             	sub    $0x10,%esp
801018b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018ba:	68 e0 30 11 80       	push   $0x801130e0
801018bf:	e8 4c 42 00 00       	call   80105b10 <acquire>
  ip->ref++;
801018c4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018c8:	c7 04 24 e0 30 11 80 	movl   $0x801130e0,(%esp)
801018cf:	e8 fc 42 00 00       	call   80105bd0 <release>
}
801018d4:	89 d8                	mov    %ebx,%eax
801018d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018d9:	c9                   	leave  
801018da:	c3                   	ret    
801018db:	90                   	nop
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018e0 <ilock>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	56                   	push   %esi
801018e4:	53                   	push   %ebx
801018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018e8:	85 db                	test   %ebx,%ebx
801018ea:	0f 84 b7 00 00 00    	je     801019a7 <ilock+0xc7>
801018f0:	8b 53 08             	mov    0x8(%ebx),%edx
801018f3:	85 d2                	test   %edx,%edx
801018f5:	0f 8e ac 00 00 00    	jle    801019a7 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018fb:	8d 43 0c             	lea    0xc(%ebx),%eax
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	50                   	push   %eax
80101902:	e8 d9 3f 00 00       	call   801058e0 <acquiresleep>
  if(ip->valid == 0){
80101907:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	85 c0                	test   %eax,%eax
8010190f:	74 0f                	je     80101920 <ilock+0x40>
}
80101911:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101914:	5b                   	pop    %ebx
80101915:	5e                   	pop    %esi
80101916:	5d                   	pop    %ebp
80101917:	c3                   	ret    
80101918:	90                   	nop
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101920:	8b 43 04             	mov    0x4(%ebx),%eax
80101923:	83 ec 08             	sub    $0x8,%esp
80101926:	c1 e8 03             	shr    $0x3,%eax
80101929:	03 05 d4 30 11 80    	add    0x801130d4,%eax
8010192f:	50                   	push   %eax
80101930:	ff 33                	pushl  (%ebx)
80101932:	e8 99 e7 ff ff       	call   801000d0 <bread>
80101937:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101939:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010193c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010193f:	83 e0 07             	and    $0x7,%eax
80101942:	c1 e0 06             	shl    $0x6,%eax
80101945:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101949:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010194c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010194f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101953:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101957:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010195b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010195f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101963:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101967:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010196b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010196e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101971:	6a 34                	push   $0x34
80101973:	50                   	push   %eax
80101974:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101977:	50                   	push   %eax
80101978:	e8 53 43 00 00       	call   80105cd0 <memmove>
    brelse(bp);
8010197d:	89 34 24             	mov    %esi,(%esp)
80101980:	e8 5b e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010198d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101994:	0f 85 77 ff ff ff    	jne    80101911 <ilock+0x31>
      panic("ilock: no type");
8010199a:	83 ec 0c             	sub    $0xc,%esp
8010199d:	68 d0 87 10 80       	push   $0x801087d0
801019a2:	e8 e9 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
801019a7:	83 ec 0c             	sub    $0xc,%esp
801019aa:	68 ca 87 10 80       	push   $0x801087ca
801019af:	e8 dc e9 ff ff       	call   80100390 <panic>
801019b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019c0 <iunlock>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	56                   	push   %esi
801019c4:	53                   	push   %ebx
801019c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019c8:	85 db                	test   %ebx,%ebx
801019ca:	74 28                	je     801019f4 <iunlock+0x34>
801019cc:	8d 73 0c             	lea    0xc(%ebx),%esi
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	56                   	push   %esi
801019d3:	e8 a8 3f 00 00       	call   80105980 <holdingsleep>
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	85 c0                	test   %eax,%eax
801019dd:	74 15                	je     801019f4 <iunlock+0x34>
801019df:	8b 43 08             	mov    0x8(%ebx),%eax
801019e2:	85 c0                	test   %eax,%eax
801019e4:	7e 0e                	jle    801019f4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019e6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019ef:	e9 4c 3f 00 00       	jmp    80105940 <releasesleep>
    panic("iunlock");
801019f4:	83 ec 0c             	sub    $0xc,%esp
801019f7:	68 df 87 10 80       	push   $0x801087df
801019fc:	e8 8f e9 ff ff       	call   80100390 <panic>
80101a01:	eb 0d                	jmp    80101a10 <iput>
80101a03:	90                   	nop
80101a04:	90                   	nop
80101a05:	90                   	nop
80101a06:	90                   	nop
80101a07:	90                   	nop
80101a08:	90                   	nop
80101a09:	90                   	nop
80101a0a:	90                   	nop
80101a0b:	90                   	nop
80101a0c:	90                   	nop
80101a0d:	90                   	nop
80101a0e:	90                   	nop
80101a0f:	90                   	nop

80101a10 <iput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 28             	sub    $0x28,%esp
80101a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a1c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a1f:	57                   	push   %edi
80101a20:	e8 bb 3e 00 00       	call   801058e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a25:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 d2                	test   %edx,%edx
80101a2d:	74 07                	je     80101a36 <iput+0x26>
80101a2f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a34:	74 32                	je     80101a68 <iput+0x58>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	57                   	push   %edi
80101a3a:	e8 01 3f 00 00       	call   80105940 <releasesleep>
  acquire(&icache.lock);
80101a3f:	c7 04 24 e0 30 11 80 	movl   $0x801130e0,(%esp)
80101a46:	e8 c5 40 00 00       	call   80105b10 <acquire>
  ip->ref--;
80101a4b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a4f:	83 c4 10             	add    $0x10,%esp
80101a52:	c7 45 08 e0 30 11 80 	movl   $0x801130e0,0x8(%ebp)
}
80101a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5c:	5b                   	pop    %ebx
80101a5d:	5e                   	pop    %esi
80101a5e:	5f                   	pop    %edi
80101a5f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a60:	e9 6b 41 00 00       	jmp    80105bd0 <release>
80101a65:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a68:	83 ec 0c             	sub    $0xc,%esp
80101a6b:	68 e0 30 11 80       	push   $0x801130e0
80101a70:	e8 9b 40 00 00       	call   80105b10 <acquire>
    int r = ip->ref;
80101a75:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a78:	c7 04 24 e0 30 11 80 	movl   $0x801130e0,(%esp)
80101a7f:	e8 4c 41 00 00       	call   80105bd0 <release>
    if(r == 1){
80101a84:	83 c4 10             	add    $0x10,%esp
80101a87:	83 fe 01             	cmp    $0x1,%esi
80101a8a:	75 aa                	jne    80101a36 <iput+0x26>
80101a8c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a92:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a95:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a98:	89 cf                	mov    %ecx,%edi
80101a9a:	eb 0b                	jmp    80101aa7 <iput+0x97>
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aa0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101aa3:	39 fe                	cmp    %edi,%esi
80101aa5:	74 19                	je     80101ac0 <iput+0xb0>
    if(ip->addrs[i]){
80101aa7:	8b 16                	mov    (%esi),%edx
80101aa9:	85 d2                	test   %edx,%edx
80101aab:	74 f3                	je     80101aa0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101aad:	8b 03                	mov    (%ebx),%eax
80101aaf:	e8 ac fb ff ff       	call   80101660 <bfree>
      ip->addrs[i] = 0;
80101ab4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101aba:	eb e4                	jmp    80101aa0 <iput+0x90>
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ac0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101ac6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ac9:	85 c0                	test   %eax,%eax
80101acb:	75 33                	jne    80101b00 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101acd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ad0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ad7:	53                   	push   %ebx
80101ad8:	e8 53 fd ff ff       	call   80101830 <iupdate>
      ip->type = 0;
80101add:	31 c0                	xor    %eax,%eax
80101adf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ae3:	89 1c 24             	mov    %ebx,(%esp)
80101ae6:	e8 45 fd ff ff       	call   80101830 <iupdate>
      ip->valid = 0;
80101aeb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101af2:	83 c4 10             	add    $0x10,%esp
80101af5:	e9 3c ff ff ff       	jmp    80101a36 <iput+0x26>
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b00:	83 ec 08             	sub    $0x8,%esp
80101b03:	50                   	push   %eax
80101b04:	ff 33                	pushl  (%ebx)
80101b06:	e8 c5 e5 ff ff       	call   801000d0 <bread>
80101b0b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b11:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b17:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	89 cf                	mov    %ecx,%edi
80101b1f:	eb 0e                	jmp    80101b2f <iput+0x11f>
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b28:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101b2b:	39 fe                	cmp    %edi,%esi
80101b2d:	74 0f                	je     80101b3e <iput+0x12e>
      if(a[j])
80101b2f:	8b 16                	mov    (%esi),%edx
80101b31:	85 d2                	test   %edx,%edx
80101b33:	74 f3                	je     80101b28 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b35:	8b 03                	mov    (%ebx),%eax
80101b37:	e8 24 fb ff ff       	call   80101660 <bfree>
80101b3c:	eb ea                	jmp    80101b28 <iput+0x118>
    brelse(bp);
80101b3e:	83 ec 0c             	sub    $0xc,%esp
80101b41:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b44:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b47:	e8 94 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b4c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b52:	8b 03                	mov    (%ebx),%eax
80101b54:	e8 07 fb ff ff       	call   80101660 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b59:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b60:	00 00 00 
80101b63:	83 c4 10             	add    $0x10,%esp
80101b66:	e9 62 ff ff ff       	jmp    80101acd <iput+0xbd>
80101b6b:	90                   	nop
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b70 <iunlockput>:
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	53                   	push   %ebx
80101b74:	83 ec 10             	sub    $0x10,%esp
80101b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b7a:	53                   	push   %ebx
80101b7b:	e8 40 fe ff ff       	call   801019c0 <iunlock>
  iput(ip);
80101b80:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b83:	83 c4 10             	add    $0x10,%esp
}
80101b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b89:	c9                   	leave  
  iput(ip);
80101b8a:	e9 81 fe ff ff       	jmp    80101a10 <iput>
80101b8f:	90                   	nop

80101b90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	8b 55 08             	mov    0x8(%ebp),%edx
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b99:	8b 0a                	mov    (%edx),%ecx
80101b9b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b9e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ba1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ba4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ba8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101baf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bb3:	8b 52 58             	mov    0x58(%edx),%edx
80101bb6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bb9:	5d                   	pop    %ebp
80101bba:	c3                   	ret    
80101bbb:	90                   	nop
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bc0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bd7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bdd:	8b 75 10             	mov    0x10(%ebp),%esi
80101be0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101be3:	0f 84 a7 00 00 00    	je     80101c90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, off, n);
  }

  if(off > ip->size || off + n < off)
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	8b 40 58             	mov    0x58(%eax),%eax
80101bef:	39 c6                	cmp    %eax,%esi
80101bf1:	0f 87 b9 00 00 00    	ja     80101cb0 <readi+0xf0>
80101bf7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bfa:	89 f9                	mov    %edi,%ecx
80101bfc:	01 f1                	add    %esi,%ecx
80101bfe:	0f 82 ac 00 00 00    	jb     80101cb0 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c04:	89 c2                	mov    %eax,%edx
80101c06:	29 f2                	sub    %esi,%edx
80101c08:	39 c8                	cmp    %ecx,%eax
80101c0a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c0d:	31 ff                	xor    %edi,%edi
80101c0f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101c11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c14:	74 6c                	je     80101c82 <readi+0xc2>
80101c16:	8d 76 00             	lea    0x0(%esi),%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c23:	89 f2                	mov    %esi,%edx
80101c25:	c1 ea 09             	shr    $0x9,%edx
80101c28:	89 d8                	mov    %ebx,%eax
80101c2a:	e8 11 f9 ff ff       	call   80101540 <bmap>
80101c2f:	83 ec 08             	sub    $0x8,%esp
80101c32:	50                   	push   %eax
80101c33:	ff 33                	pushl  (%ebx)
80101c35:	e8 96 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c3d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3f:	89 f0                	mov    %esi,%eax
80101c41:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c46:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c50:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101c54:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c57:	29 fb                	sub    %edi,%ebx
80101c59:	39 d9                	cmp    %ebx,%ecx
80101c5b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c5e:	53                   	push   %ebx
80101c5f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c60:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c62:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c65:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c67:	e8 64 40 00 00       	call   80105cd0 <memmove>
    brelse(bp);
80101c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c6f:	89 14 24             	mov    %edx,(%esp)
80101c72:	e8 69 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c80:	77 9e                	ja     80101c20 <readi+0x60>
  }
  return n;
80101c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c88:	5b                   	pop    %ebx
80101c89:	5e                   	pop    %esi
80101c8a:	5f                   	pop    %edi
80101c8b:	5d                   	pop    %ebp
80101c8c:	c3                   	ret    
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 16                	ja     80101cb0 <readi+0xf0>
80101c9a:	c1 e0 04             	shl    $0x4,%eax
80101c9d:	8b 80 28 30 11 80    	mov    -0x7feecfd8(%eax),%eax
80101ca3:	85 c0                	test   %eax,%eax
80101ca5:	74 09                	je     80101cb0 <readi+0xf0>
}
80101ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101caa:	5b                   	pop    %ebx
80101cab:	5e                   	pop    %esi
80101cac:	5f                   	pop    %edi
80101cad:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, off, n);
80101cae:	ff e0                	jmp    *%eax
      return -1;
80101cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb5:	eb ce                	jmp    80101c85 <readi+0xc5>
80101cb7:	89 f6                	mov    %esi,%esi
80101cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 1c             	sub    $0x1c,%esp
80101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ccf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cd7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cdd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ce0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ce3:	0f 84 b7 00 00 00    	je     80101da0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	39 70 58             	cmp    %esi,0x58(%eax)
80101cef:	0f 82 eb 00 00 00    	jb     80101de0 <writei+0x120>
80101cf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cf8:	31 d2                	xor    %edx,%edx
80101cfa:	89 f8                	mov    %edi,%eax
80101cfc:	01 f0                	add    %esi,%eax
80101cfe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d01:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d06:	0f 87 d4 00 00 00    	ja     80101de0 <writei+0x120>
80101d0c:	85 d2                	test   %edx,%edx
80101d0e:	0f 85 cc 00 00 00    	jne    80101de0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d14:	85 ff                	test   %edi,%edi
80101d16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d1d:	74 72                	je     80101d91 <writei+0xd1>
80101d1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d23:	89 f2                	mov    %esi,%edx
80101d25:	c1 ea 09             	shr    $0x9,%edx
80101d28:	89 f8                	mov    %edi,%eax
80101d2a:	e8 11 f8 ff ff       	call   80101540 <bmap>
80101d2f:	83 ec 08             	sub    $0x8,%esp
80101d32:	50                   	push   %eax
80101d33:	ff 37                	pushl  (%edi)
80101d35:	e8 96 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d3a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d3d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d40:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d42:	89 f0                	mov    %esi,%eax
80101d44:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d49:	83 c4 0c             	add    $0xc,%esp
80101d4c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d51:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d53:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d57:	39 d9                	cmp    %ebx,%ecx
80101d59:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d5c:	53                   	push   %ebx
80101d5d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d60:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d62:	50                   	push   %eax
80101d63:	e8 68 3f 00 00       	call   80105cd0 <memmove>
    log_write(bp);
80101d68:	89 3c 24             	mov    %edi,(%esp)
80101d6b:	e8 50 14 00 00       	call   801031c0 <log_write>
    brelse(bp);
80101d70:	89 3c 24             	mov    %edi,(%esp)
80101d73:	e8 68 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d7b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d7e:	83 c4 10             	add    $0x10,%esp
80101d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d87:	77 97                	ja     80101d20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d8f:	77 37                	ja     80101dc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	5b                   	pop    %ebx
80101d98:	5e                   	pop    %esi
80101d99:	5f                   	pop    %edi
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret    
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 36                	ja     80101de0 <writei+0x120>
80101daa:	c1 e0 04             	shl    $0x4,%eax
80101dad:	8b 80 2c 30 11 80    	mov    -0x7feecfd4(%eax),%eax
80101db3:	85 c0                	test   %eax,%eax
80101db5:	74 29                	je     80101de0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101db7:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbd:	5b                   	pop    %ebx
80101dbe:	5e                   	pop    %esi
80101dbf:	5f                   	pop    %edi
80101dc0:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101dc1:	ff e0                	jmp    *%eax
80101dc3:	90                   	nop
80101dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101dc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dcb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101dd1:	50                   	push   %eax
80101dd2:	e8 59 fa ff ff       	call   80101830 <iupdate>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	eb b5                	jmp    80101d91 <writei+0xd1>
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de5:	eb ad                	jmp    80101d94 <writei+0xd4>
80101de7:	89 f6                	mov    %esi,%esi
80101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101df0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101df6:	6a 0e                	push   $0xe
80101df8:	ff 75 0c             	pushl  0xc(%ebp)
80101dfb:	ff 75 08             	pushl  0x8(%ebp)
80101dfe:	e8 3d 3f 00 00       	call   80105d40 <strncmp>
}
80101e03:	c9                   	leave  
80101e04:	c3                   	ret    
80101e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 2c             	sub    $0x2c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;
  struct inode *ip;

  if(dp->type != T_DIR && !IS_DEV_DIR(dp))
80101e1c:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80101e20:	66 83 f8 01          	cmp    $0x1,%ax
80101e24:	74 30                	je     80101e56 <dirlookup+0x46>
80101e26:	66 83 f8 03          	cmp    $0x3,%ax
80101e2a:	0f 85 d0 00 00 00    	jne    80101f00 <dirlookup+0xf0>
80101e30:	0f bf 43 52          	movswl 0x52(%ebx),%eax
80101e34:	c1 e0 04             	shl    $0x4,%eax
80101e37:	8b 80 20 30 11 80    	mov    -0x7feecfe0(%eax),%eax
80101e3d:	85 c0                	test   %eax,%eax
80101e3f:	0f 84 bb 00 00 00    	je     80101f00 <dirlookup+0xf0>
80101e45:	83 ec 0c             	sub    $0xc,%esp
80101e48:	53                   	push   %ebx
80101e49:	ff d0                	call   *%eax
80101e4b:	83 c4 10             	add    $0x10,%esp
80101e4e:	85 c0                	test   %eax,%eax
80101e50:	0f 84 aa 00 00 00    	je     80101f00 <dirlookup+0xf0>
{
80101e56:	31 ff                	xor    %edi,%edi
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size || dp->type == T_DEV ; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101e58:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5b:	eb 25                	jmp    80101e82 <dirlookup+0x72>
80101e5d:	8d 76 00             	lea    0x0(%esi),%esi
      if (dp->type == T_DEV)
        return 0;
      panic("dirlookup read");
    }
    if(de.inum == 0)
80101e60:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e65:	74 18                	je     80101e7f <dirlookup+0x6f>
  return strncmp(s, t, DIRSIZ);
80101e67:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e6a:	83 ec 04             	sub    $0x4,%esp
80101e6d:	6a 0e                	push   $0xe
80101e6f:	50                   	push   %eax
80101e70:	ff 75 0c             	pushl  0xc(%ebp)
80101e73:	e8 c8 3e 00 00       	call   80105d40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	85 c0                	test   %eax,%eax
80101e7d:	74 39                	je     80101eb8 <dirlookup+0xa8>
  for(off = 0; off < dp->size || dp->type == T_DEV ; off += sizeof(de)){
80101e7f:	83 c7 10             	add    $0x10,%edi
80101e82:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e85:	77 07                	ja     80101e8e <dirlookup+0x7e>
80101e87:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101e8c:	75 19                	jne    80101ea7 <dirlookup+0x97>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101e8e:	6a 10                	push   $0x10
80101e90:	57                   	push   %edi
80101e91:	56                   	push   %esi
80101e92:	53                   	push   %ebx
80101e93:	e8 28 fd ff ff       	call   80101bc0 <readi>
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	83 f8 10             	cmp    $0x10,%eax
80101e9e:	74 c0                	je     80101e60 <dirlookup+0x50>
      if (dp->type == T_DEV)
80101ea0:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101ea5:	75 66                	jne    80101f0d <dirlookup+0xfd>
        return 0;
80101ea7:	31 c0                	xor    %eax,%eax
      return ip;
    }
  }

  return 0;
}
80101ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eac:	5b                   	pop    %ebx
80101ead:	5e                   	pop    %esi
80101eae:	5f                   	pop    %edi
80101eaf:	5d                   	pop    %ebp
80101eb0:	c3                   	ret    
80101eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101eb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101ebb:	85 c9                	test   %ecx,%ecx
80101ebd:	74 05                	je     80101ec4 <dirlookup+0xb4>
        *poff = off;
80101ebf:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ec4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      ip = iget(dp->dev, inum);
80101ec8:	8b 03                	mov    (%ebx),%eax
80101eca:	e8 a1 f5 ff ff       	call   80101470 <iget>
      if (ip->valid == 0 && dp->type == T_DEV && devsw[dp->major].iread) {
80101ecf:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ed2:	85 d2                	test   %edx,%edx
80101ed4:	75 d3                	jne    80101ea9 <dirlookup+0x99>
80101ed6:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101edb:	75 cc                	jne    80101ea9 <dirlookup+0x99>
80101edd:	0f bf 53 52          	movswl 0x52(%ebx),%edx
80101ee1:	c1 e2 04             	shl    $0x4,%edx
80101ee4:	8b 92 24 30 11 80    	mov    -0x7feecfdc(%edx),%edx
80101eea:	85 d2                	test   %edx,%edx
80101eec:	74 bb                	je     80101ea9 <dirlookup+0x99>
        devsw[dp->major].iread(dp, ip);
80101eee:	83 ec 08             	sub    $0x8,%esp
80101ef1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101ef4:	50                   	push   %eax
80101ef5:	53                   	push   %ebx
80101ef6:	ff d2                	call   *%edx
80101ef8:	83 c4 10             	add    $0x10,%esp
80101efb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101efe:	eb a9                	jmp    80101ea9 <dirlookup+0x99>
    panic("dirlookup not DIR");
80101f00:	83 ec 0c             	sub    $0xc,%esp
80101f03:	68 e7 87 10 80       	push   $0x801087e7
80101f08:	e8 83 e4 ff ff       	call   80100390 <panic>
      panic("dirlookup read");
80101f0d:	83 ec 0c             	sub    $0xc,%esp
80101f10:	68 f9 87 10 80       	push   $0x801087f9
80101f15:	e8 76 e4 ff ff       	call   80100390 <panic>
80101f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	89 cf                	mov    %ecx,%edi
80101f28:	89 c3                	mov    %eax,%ebx
80101f2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f2d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f33:	0f 84 97 01 00 00    	je     801020d0 <namex+0x1b0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f39:	e8 02 1d 00 00       	call   80103c40 <myproc>
  acquire(&icache.lock);
80101f3e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f41:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f44:	68 e0 30 11 80       	push   $0x801130e0
80101f49:	e8 c2 3b 00 00       	call   80105b10 <acquire>
  ip->ref++;
80101f4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f52:	c7 04 24 e0 30 11 80 	movl   $0x801130e0,(%esp)
80101f59:	e8 72 3c 00 00       	call   80105bd0 <release>
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	eb 08                	jmp    80101f6b <namex+0x4b>
80101f63:	90                   	nop
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	0f b6 03             	movzbl (%ebx),%eax
80101f6e:	3c 2f                	cmp    $0x2f,%al
80101f70:	74 f6                	je     80101f68 <namex+0x48>
  if(*path == 0)
80101f72:	84 c0                	test   %al,%al
80101f74:	0f 84 1e 01 00 00    	je     80102098 <namex+0x178>
  while(*path != '/' && *path != 0)
80101f7a:	0f b6 03             	movzbl (%ebx),%eax
80101f7d:	3c 2f                	cmp    $0x2f,%al
80101f7f:	0f 84 e3 00 00 00    	je     80102068 <namex+0x148>
80101f85:	84 c0                	test   %al,%al
80101f87:	89 da                	mov    %ebx,%edx
80101f89:	75 09                	jne    80101f94 <namex+0x74>
80101f8b:	e9 d8 00 00 00       	jmp    80102068 <namex+0x148>
80101f90:	84 c0                	test   %al,%al
80101f92:	74 0a                	je     80101f9e <namex+0x7e>
    path++;
80101f94:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f97:	0f b6 02             	movzbl (%edx),%eax
80101f9a:	3c 2f                	cmp    $0x2f,%al
80101f9c:	75 f2                	jne    80101f90 <namex+0x70>
80101f9e:	89 d1                	mov    %edx,%ecx
80101fa0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101fa2:	83 f9 0d             	cmp    $0xd,%ecx
80101fa5:	0f 8e c1 00 00 00    	jle    8010206c <namex+0x14c>
    memmove(name, s, DIRSIZ);
80101fab:	83 ec 04             	sub    $0x4,%esp
80101fae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fb1:	6a 0e                	push   $0xe
80101fb3:	53                   	push   %ebx
80101fb4:	57                   	push   %edi
80101fb5:	e8 16 3d 00 00       	call   80105cd0 <memmove>
    path++;
80101fba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101fbd:	83 c4 10             	add    $0x10,%esp
    path++;
80101fc0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101fc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101fc5:	75 11                	jne    80101fd8 <namex+0xb8>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101fd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fd6:	74 f8                	je     80101fd0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	56                   	push   %esi
80101fdc:	e8 ff f8 ff ff       	call   801018e0 <ilock>
    if(ip->type != T_DIR && !IS_DEV_DIR(ip)){
80101fe1:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80101fe5:	83 c4 10             	add    $0x10,%esp
80101fe8:	66 83 f8 01          	cmp    $0x1,%ax
80101fec:	74 30                	je     8010201e <namex+0xfe>
80101fee:	66 83 f8 03          	cmp    $0x3,%ax
80101ff2:	0f 85 b8 00 00 00    	jne    801020b0 <namex+0x190>
80101ff8:	0f bf 46 52          	movswl 0x52(%esi),%eax
80101ffc:	c1 e0 04             	shl    $0x4,%eax
80101fff:	8b 80 20 30 11 80    	mov    -0x7feecfe0(%eax),%eax
80102005:	85 c0                	test   %eax,%eax
80102007:	0f 84 a3 00 00 00    	je     801020b0 <namex+0x190>
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	56                   	push   %esi
80102011:	ff d0                	call   *%eax
80102013:	83 c4 10             	add    $0x10,%esp
80102016:	85 c0                	test   %eax,%eax
80102018:	0f 84 92 00 00 00    	je     801020b0 <namex+0x190>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010201e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102021:	85 d2                	test   %edx,%edx
80102023:	74 09                	je     8010202e <namex+0x10e>
80102025:	80 3b 00             	cmpb   $0x0,(%ebx)
80102028:	0f 84 b8 00 00 00    	je     801020e6 <namex+0x1c6>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010202e:	83 ec 04             	sub    $0x4,%esp
80102031:	6a 00                	push   $0x0
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	e8 d6 fd ff ff       	call   80101e10 <dirlookup>
8010203a:	83 c4 10             	add    $0x10,%esp
8010203d:	85 c0                	test   %eax,%eax
8010203f:	74 6f                	je     801020b0 <namex+0x190>
  iunlock(ip);
80102041:	83 ec 0c             	sub    $0xc,%esp
80102044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102047:	56                   	push   %esi
80102048:	e8 73 f9 ff ff       	call   801019c0 <iunlock>
  iput(ip);
8010204d:	89 34 24             	mov    %esi,(%esp)
80102050:	e8 bb f9 ff ff       	call   80101a10 <iput>
80102055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	89 c6                	mov    %eax,%esi
8010205d:	e9 09 ff ff ff       	jmp    80101f6b <namex+0x4b>
80102062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102068:	89 da                	mov    %ebx,%edx
8010206a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010206c:	83 ec 04             	sub    $0x4,%esp
8010206f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102072:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102075:	51                   	push   %ecx
80102076:	53                   	push   %ebx
80102077:	57                   	push   %edi
80102078:	e8 53 3c 00 00       	call   80105cd0 <memmove>
    name[len] = 0;
8010207d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102080:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102083:	83 c4 10             	add    $0x10,%esp
80102086:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010208a:	89 d3                	mov    %edx,%ebx
8010208c:	e9 31 ff ff ff       	jmp    80101fc2 <namex+0xa2>
80102091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102098:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010209b:	85 c0                	test   %eax,%eax
8010209d:	75 5d                	jne    801020fc <namex+0x1dc>
    iput(ip);
    return 0;
  }
  return ip;
}
8010209f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a2:	89 f0                	mov    %esi,%eax
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801020b0:	83 ec 0c             	sub    $0xc,%esp
801020b3:	56                   	push   %esi
801020b4:	e8 07 f9 ff ff       	call   801019c0 <iunlock>
  iput(ip);
801020b9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020bc:	31 f6                	xor    %esi,%esi
  iput(ip);
801020be:	e8 4d f9 ff ff       	call   80101a10 <iput>
      return 0;
801020c3:	83 c4 10             	add    $0x10,%esp
}
801020c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c9:	89 f0                	mov    %esi,%eax
801020cb:	5b                   	pop    %ebx
801020cc:	5e                   	pop    %esi
801020cd:	5f                   	pop    %edi
801020ce:	5d                   	pop    %ebp
801020cf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801020d0:	ba 01 00 00 00       	mov    $0x1,%edx
801020d5:	b8 01 00 00 00       	mov    $0x1,%eax
801020da:	e8 91 f3 ff ff       	call   80101470 <iget>
801020df:	89 c6                	mov    %eax,%esi
801020e1:	e9 85 fe ff ff       	jmp    80101f6b <namex+0x4b>
      iunlock(ip);
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	56                   	push   %esi
801020ea:	e8 d1 f8 ff ff       	call   801019c0 <iunlock>
      return ip;
801020ef:	83 c4 10             	add    $0x10,%esp
}
801020f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f5:	89 f0                	mov    %esi,%eax
801020f7:	5b                   	pop    %ebx
801020f8:	5e                   	pop    %esi
801020f9:	5f                   	pop    %edi
801020fa:	5d                   	pop    %ebp
801020fb:	c3                   	ret    
    iput(ip);
801020fc:	83 ec 0c             	sub    $0xc,%esp
801020ff:	56                   	push   %esi
    return 0;
80102100:	31 f6                	xor    %esi,%esi
    iput(ip);
80102102:	e8 09 f9 ff ff       	call   80101a10 <iput>
    return 0;
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	eb 93                	jmp    8010209f <namex+0x17f>
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102110 <dirlink>:
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 20             	sub    $0x20,%esp
80102119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010211c:	6a 00                	push   $0x0
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	53                   	push   %ebx
80102122:	e8 e9 fc ff ff       	call   80101e10 <dirlookup>
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	85 c0                	test   %eax,%eax
8010212c:	75 67                	jne    80102195 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102131:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102134:	85 ff                	test   %edi,%edi
80102136:	74 29                	je     80102161 <dirlink+0x51>
80102138:	31 ff                	xor    %edi,%edi
8010213a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010213d:	eb 09                	jmp    80102148 <dirlink+0x38>
8010213f:	90                   	nop
80102140:	83 c7 10             	add    $0x10,%edi
80102143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102146:	73 19                	jae    80102161 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102148:	6a 10                	push   $0x10
8010214a:	57                   	push   %edi
8010214b:	56                   	push   %esi
8010214c:	53                   	push   %ebx
8010214d:	e8 6e fa ff ff       	call   80101bc0 <readi>
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	83 f8 10             	cmp    $0x10,%eax
80102158:	75 4e                	jne    801021a8 <dirlink+0x98>
    if(de.inum == 0)
8010215a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010215f:	75 df                	jne    80102140 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102161:	8d 45 da             	lea    -0x26(%ebp),%eax
80102164:	83 ec 04             	sub    $0x4,%esp
80102167:	6a 0e                	push   $0xe
80102169:	ff 75 0c             	pushl  0xc(%ebp)
8010216c:	50                   	push   %eax
8010216d:	e8 2e 3c 00 00       	call   80105da0 <strncpy>
  de.inum = inum;
80102172:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102175:	6a 10                	push   $0x10
80102177:	57                   	push   %edi
80102178:	56                   	push   %esi
80102179:	53                   	push   %ebx
  de.inum = inum;
8010217a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010217e:	e8 3d fb ff ff       	call   80101cc0 <writei>
80102183:	83 c4 20             	add    $0x20,%esp
80102186:	83 f8 10             	cmp    $0x10,%eax
80102189:	75 2a                	jne    801021b5 <dirlink+0xa5>
  return 0;
8010218b:	31 c0                	xor    %eax,%eax
}
8010218d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102190:	5b                   	pop    %ebx
80102191:	5e                   	pop    %esi
80102192:	5f                   	pop    %edi
80102193:	5d                   	pop    %ebp
80102194:	c3                   	ret    
    iput(ip);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	50                   	push   %eax
80102199:	e8 72 f8 ff ff       	call   80101a10 <iput>
    return -1;
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a6:	eb e5                	jmp    8010218d <dirlink+0x7d>
      panic("dirlink read");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 08 88 10 80       	push   $0x80108808
801021b0:	e8 db e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 3b 90 10 80       	push   $0x8010903b
801021bd:	e8 ce e1 ff ff       	call   80100390 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021d0 <namei>:

struct inode*
namei(char *path)
{
801021d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021d1:	31 d2                	xor    %edx,%edx
{
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021de:	e8 3d fd ff ff       	call   80101f20 <namex>
}
801021e3:	c9                   	leave  
801021e4:	c3                   	ret    
801021e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021f0:	55                   	push   %ebp
  return namex(path, 1, name);
801021f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021ff:	e9 1c fd ff ff       	jmp    80101f20 <namex>
80102204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010220a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102210 <get_inode_index>:

int
get_inode_index(uint inum)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	8b 75 08             	mov    0x8(%ebp),%esi
  struct inode *ip;
  int index = -1;
  int i = 0;
80102218:	31 db                	xor    %ebx,%ebx

  acquire(&icache.lock);
8010221a:	83 ec 0c             	sub    $0xc,%esp
8010221d:	68 e0 30 11 80       	push   $0x801130e0
80102222:	e8 e9 38 00 00       	call   80105b10 <acquire>
80102227:	83 c4 10             	add    $0x10,%esp

  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010222a:	ba 14 31 11 80       	mov    $0x80113114,%edx
8010222f:	eb 18                	jmp    80102249 <get_inode_index+0x39>
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	81 c2 90 00 00 00    	add    $0x90,%edx
    if(ip->inum == inum){
      index = i;
      release(&icache.lock);
      return index;
    }
    i++;
8010223e:	83 c3 01             	add    $0x1,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102241:	81 fa 34 4d 11 80    	cmp    $0x80114d34,%edx
80102247:	73 27                	jae    80102270 <get_inode_index+0x60>
    if(ip->inum == inum){
80102249:	39 72 04             	cmp    %esi,0x4(%edx)
8010224c:	75 ea                	jne    80102238 <get_inode_index+0x28>
      release(&icache.lock);
8010224e:	83 ec 0c             	sub    $0xc,%esp
80102251:	68 e0 30 11 80       	push   $0x801130e0
80102256:	e8 75 39 00 00       	call   80105bd0 <release>
      return index;
8010225b:	83 c4 10             	add    $0x10,%esp
  }
  release(&icache.lock);
  return index;
8010225e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102261:	89 d8                	mov    %ebx,%eax
80102263:	5b                   	pop    %ebx
80102264:	5e                   	pop    %esi
80102265:	5d                   	pop    %ebp
80102266:	c3                   	ret    
80102267:	89 f6                	mov    %esi,%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&icache.lock);
80102270:	83 ec 0c             	sub    $0xc,%esp
  return index;
80102273:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&icache.lock);
80102278:	68 e0 30 11 80       	push   $0x801130e0
8010227d:	e8 4e 39 00 00       	call   80105bd0 <release>
  return index;
80102282:	83 c4 10             	add    $0x10,%esp
80102285:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102288:	89 d8                	mov    %ebx,%eax
8010228a:	5b                   	pop    %ebx
8010228b:	5e                   	pop    %esi
8010228c:	5d                   	pop    %ebp
8010228d:	c3                   	ret    
8010228e:	66 90                	xchg   %ax,%ax

80102290 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102299:	85 c0                	test   %eax,%eax
8010229b:	0f 84 b4 00 00 00    	je     80102355 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022a1:	8b 58 08             	mov    0x8(%eax),%ebx
801022a4:	89 c6                	mov    %eax,%esi
801022a6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022ac:	0f 87 96 00 00 00    	ja     80102348 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022c0:	89 ca                	mov    %ecx,%edx
801022c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c3:	83 e0 c0             	and    $0xffffffc0,%eax
801022c6:	3c 40                	cmp    $0x40,%al
801022c8:	75 f6                	jne    801022c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ca:	31 ff                	xor    %edi,%edi
801022cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022d1:	89 f8                	mov    %edi,%eax
801022d3:	ee                   	out    %al,(%dx)
801022d4:	b8 01 00 00 00       	mov    $0x1,%eax
801022d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022de:	ee                   	out    %al,(%dx)
801022df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022e4:	89 d8                	mov    %ebx,%eax
801022e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022e7:	89 d8                	mov    %ebx,%eax
801022e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022ee:	c1 f8 08             	sar    $0x8,%eax
801022f1:	ee                   	out    %al,(%dx)
801022f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022f7:	89 f8                	mov    %edi,%eax
801022f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022fa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801022fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102303:	c1 e0 04             	shl    $0x4,%eax
80102306:	83 e0 10             	and    $0x10,%eax
80102309:	83 c8 e0             	or     $0xffffffe0,%eax
8010230c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010230d:	f6 06 04             	testb  $0x4,(%esi)
80102310:	75 16                	jne    80102328 <idestart+0x98>
80102312:	b8 20 00 00 00       	mov    $0x20,%eax
80102317:	89 ca                	mov    %ecx,%edx
80102319:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010231d:	5b                   	pop    %ebx
8010231e:	5e                   	pop    %esi
8010231f:	5f                   	pop    %edi
80102320:	5d                   	pop    %ebp
80102321:	c3                   	ret    
80102322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102328:	b8 30 00 00 00       	mov    $0x30,%eax
8010232d:	89 ca                	mov    %ecx,%edx
8010232f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102330:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102335:	83 c6 5c             	add    $0x5c,%esi
80102338:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010233d:	fc                   	cld    
8010233e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret    
    panic("incorrect blockno");
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	68 74 88 10 80       	push   $0x80108874
80102350:	e8 3b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102355:	83 ec 0c             	sub    $0xc,%esp
80102358:	68 6b 88 10 80       	push   $0x8010886b
8010235d:	e8 2e e0 ff ff       	call   80100390 <panic>
80102362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <ideinit>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102376:	68 86 88 10 80       	push   $0x80108886
8010237b:	68 80 c9 10 80       	push   $0x8010c980
80102380:	e8 4b 36 00 00       	call   801059d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102385:	58                   	pop    %eax
80102386:	a1 00 54 11 80       	mov    0x80115400,%eax
8010238b:	5a                   	pop    %edx
8010238c:	83 e8 01             	sub    $0x1,%eax
8010238f:	50                   	push   %eax
80102390:	6a 0e                	push   $0xe
80102392:	e8 89 03 00 00       	call   80102720 <ioapicenable>
80102397:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010239a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010239f:	90                   	nop
801023a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023a1:	83 e0 c0             	and    $0xffffffc0,%eax
801023a4:	3c 40                	cmp    $0x40,%al
801023a6:	75 f8                	jne    801023a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023b2:	ee                   	out    %al,(%dx)
801023b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bd:	eb 06                	jmp    801023c5 <ideinit+0x55>
801023bf:	90                   	nop
  for(i=0; i<1000; i++){
801023c0:	83 e9 01             	sub    $0x1,%ecx
801023c3:	74 0f                	je     801023d4 <ideinit+0x64>
801023c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023c6:	84 c0                	test   %al,%al
801023c8:	74 f6                	je     801023c0 <ideinit+0x50>
      havedisk1 = 1;
801023ca:	c7 05 60 c9 10 80 01 	movl   $0x1,0x8010c960
801023d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023de:	ee                   	out    %al,(%dx)
}
801023df:	c9                   	leave  
801023e0:	c3                   	ret    
801023e1:	eb 0d                	jmp    801023f0 <ideintr>
801023e3:	90                   	nop
801023e4:	90                   	nop
801023e5:	90                   	nop
801023e6:	90                   	nop
801023e7:	90                   	nop
801023e8:	90                   	nop
801023e9:	90                   	nop
801023ea:	90                   	nop
801023eb:	90                   	nop
801023ec:	90                   	nop
801023ed:	90                   	nop
801023ee:	90                   	nop
801023ef:	90                   	nop

801023f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023f9:	68 80 c9 10 80       	push   $0x8010c980
801023fe:	e8 0d 37 00 00       	call   80105b10 <acquire>

  if((b = idequeue) == 0){
80102403:	8b 1d 64 c9 10 80    	mov    0x8010c964,%ebx
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	85 db                	test   %ebx,%ebx
8010240e:	74 67                	je     80102477 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102410:	8b 43 58             	mov    0x58(%ebx),%eax
80102413:	a3 64 c9 10 80       	mov    %eax,0x8010c964

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102418:	8b 3b                	mov    (%ebx),%edi
8010241a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102420:	75 31                	jne    80102453 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102422:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102427:	89 f6                	mov    %esi,%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102430:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102431:	89 c6                	mov    %eax,%esi
80102433:	83 e6 c0             	and    $0xffffffc0,%esi
80102436:	89 f1                	mov    %esi,%ecx
80102438:	80 f9 40             	cmp    $0x40,%cl
8010243b:	75 f3                	jne    80102430 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010243d:	a8 21                	test   $0x21,%al
8010243f:	75 12                	jne    80102453 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102441:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102444:	b9 80 00 00 00       	mov    $0x80,%ecx
80102449:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010244e:	fc                   	cld    
8010244f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102451:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102453:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102456:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102459:	89 f9                	mov    %edi,%ecx
8010245b:	83 c9 02             	or     $0x2,%ecx
8010245e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102460:	53                   	push   %ebx
80102461:	e8 2a 1f 00 00       	call   80104390 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102466:	a1 64 c9 10 80       	mov    0x8010c964,%eax
8010246b:	83 c4 10             	add    $0x10,%esp
8010246e:	85 c0                	test   %eax,%eax
80102470:	74 05                	je     80102477 <ideintr+0x87>
    idestart(idequeue);
80102472:	e8 19 fe ff ff       	call   80102290 <idestart>
    release(&idelock);
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 80 c9 10 80       	push   $0x8010c980
8010247f:	e8 4c 37 00 00       	call   80105bd0 <release>

  release(&idelock);
}
80102484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102487:	5b                   	pop    %ebx
80102488:	5e                   	pop    %esi
80102489:	5f                   	pop    %edi
8010248a:	5d                   	pop    %ebp
8010248b:	c3                   	ret    
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 10             	sub    $0x10,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010249a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010249d:	50                   	push   %eax
8010249e:	e8 dd 34 00 00       	call   80105980 <holdingsleep>
801024a3:	83 c4 10             	add    $0x10,%esp
801024a6:	85 c0                	test   %eax,%eax
801024a8:	0f 84 c6 00 00 00    	je     80102574 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ae:	8b 03                	mov    (%ebx),%eax
801024b0:	83 e0 06             	and    $0x6,%eax
801024b3:	83 f8 02             	cmp    $0x2,%eax
801024b6:	0f 84 ab 00 00 00    	je     80102567 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024bc:	8b 53 04             	mov    0x4(%ebx),%edx
801024bf:	85 d2                	test   %edx,%edx
801024c1:	74 0d                	je     801024d0 <iderw+0x40>
801024c3:	a1 60 c9 10 80       	mov    0x8010c960,%eax
801024c8:	85 c0                	test   %eax,%eax
801024ca:	0f 84 b1 00 00 00    	je     80102581 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 80 c9 10 80       	push   $0x8010c980
801024d8:	e8 33 36 00 00       	call   80105b10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024dd:	8b 15 64 c9 10 80    	mov    0x8010c964,%edx
801024e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801024e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024ed:	85 d2                	test   %edx,%edx
801024ef:	75 09                	jne    801024fa <iderw+0x6a>
801024f1:	eb 6d                	jmp    80102560 <iderw+0xd0>
801024f3:	90                   	nop
801024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f8:	89 c2                	mov    %eax,%edx
801024fa:	8b 42 58             	mov    0x58(%edx),%eax
801024fd:	85 c0                	test   %eax,%eax
801024ff:	75 f7                	jne    801024f8 <iderw+0x68>
80102501:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102504:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102506:	39 1d 64 c9 10 80    	cmp    %ebx,0x8010c964
8010250c:	74 42                	je     80102550 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	74 23                	je     8010253b <iderw+0xab>
80102518:	90                   	nop
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102520:	83 ec 08             	sub    $0x8,%esp
80102523:	68 80 c9 10 80       	push   $0x8010c980
80102528:	53                   	push   %ebx
80102529:	e8 b2 1c 00 00       	call   801041e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 c4 10             	add    $0x10,%esp
80102533:	83 e0 06             	and    $0x6,%eax
80102536:	83 f8 02             	cmp    $0x2,%eax
80102539:	75 e5                	jne    80102520 <iderw+0x90>
  }

  release(&idelock);
8010253b:	c7 45 08 80 c9 10 80 	movl   $0x8010c980,0x8(%ebp)
}
80102542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102545:	c9                   	leave  
  release(&idelock);
80102546:	e9 85 36 00 00       	jmp    80105bd0 <release>
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102550:	89 d8                	mov    %ebx,%eax
80102552:	e8 39 fd ff ff       	call   80102290 <idestart>
80102557:	eb b5                	jmp    8010250e <iderw+0x7e>
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102560:	ba 64 c9 10 80       	mov    $0x8010c964,%edx
80102565:	eb 9d                	jmp    80102504 <iderw+0x74>
    panic("iderw: nothing to do");
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 a0 88 10 80       	push   $0x801088a0
8010256f:	e8 1c de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	68 8a 88 10 80       	push   $0x8010888a
8010257c:	e8 0f de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102581:	83 ec 0c             	sub    $0xc,%esp
80102584:	68 b5 88 10 80       	push   $0x801088b5
80102589:	e8 02 de ff ff       	call   80100390 <panic>
8010258e:	66 90                	xchg   %ax,%ax

80102590 <get_read_wait_ops>:
  return get_read_wait_ops() + get_write_wait_ops();
}

int
get_read_wait_ops(void)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	53                   	push   %ebx
  int counter = 0;
80102594:	31 db                	xor    %ebx,%ebx
{
80102596:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&idelock);
80102599:	68 80 c9 10 80       	push   $0x8010c980
8010259e:	e8 6d 35 00 00       	call   80105b10 <acquire>
  for(b = idequeue; b != 0; b = b->qnext){
801025a3:	8b 15 64 c9 10 80    	mov    0x8010c964,%edx
801025a9:	83 c4 10             	add    $0x10,%esp
801025ac:	85 d2                	test   %edx,%edx
801025ae:	74 12                	je     801025c2 <get_read_wait_ops+0x32>
    if(!(b->flags & B_VALID)){ // B_VALID bit is off - waiting to read
801025b0:	8b 0a                	mov    (%edx),%ecx
  for(b = idequeue; b != 0; b = b->qnext){
801025b2:	8b 52 58             	mov    0x58(%edx),%edx
    if(!(b->flags & B_VALID)){ // B_VALID bit is off - waiting to read
801025b5:	83 e1 02             	and    $0x2,%ecx
      counter++;
801025b8:	83 f9 01             	cmp    $0x1,%ecx
801025bb:	83 d3 00             	adc    $0x0,%ebx
  for(b = idequeue; b != 0; b = b->qnext){
801025be:	85 d2                	test   %edx,%edx
801025c0:	75 ee                	jne    801025b0 <get_read_wait_ops+0x20>
    }
  }
  release(&idelock);
801025c2:	83 ec 0c             	sub    $0xc,%esp
801025c5:	68 80 c9 10 80       	push   $0x8010c980
801025ca:	e8 01 36 00 00       	call   80105bd0 <release>
  return counter;
}
801025cf:	89 d8                	mov    %ebx,%eax
801025d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d4:	c9                   	leave  
801025d5:	c3                   	ret    
801025d6:	8d 76 00             	lea    0x0(%esi),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <get_waiting_ops>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	53                   	push   %ebx
801025e4:	83 ec 04             	sub    $0x4,%esp
  return get_read_wait_ops() + get_write_wait_ops();
801025e7:	e8 a4 ff ff ff       	call   80102590 <get_read_wait_ops>
801025ec:	89 c3                	mov    %eax,%ebx
801025ee:	e8 9d ff ff ff       	call   80102590 <get_read_wait_ops>
}
801025f3:	83 c4 04             	add    $0x4,%esp
  return get_read_wait_ops() + get_write_wait_ops();
801025f6:	01 d8                	add    %ebx,%eax
}
801025f8:	5b                   	pop    %ebx
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret    
801025fb:	90                   	nop
801025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102600 <get_write_wait_ops>:
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	5d                   	pop    %ebp
80102604:	eb 8a                	jmp    80102590 <get_read_wait_ops>
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <get_working_blocks>:

uint currQueue[256] = {0};

uint *
get_working_blocks(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
  struct buf *b;

  acquire(&idelock);
80102616:	68 80 c9 10 80       	push   $0x8010c980
8010261b:	e8 f0 34 00 00       	call   80105b10 <acquire>
  for(b = idequeue; b != 0; b = b->qnext){
80102620:	a1 64 c9 10 80       	mov    0x8010c964,%eax
80102625:	83 c4 10             	add    $0x10,%esp
80102628:	85 c0                	test   %eax,%eax
8010262a:	74 22                	je     8010264e <get_working_blocks+0x3e>
8010262c:	ba 60 c5 10 80       	mov    $0x8010c560,%edx
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    currQueue[i] = b->dev;
80102638:	8b 48 04             	mov    0x4(%eax),%ecx
8010263b:	83 c2 08             	add    $0x8,%edx
8010263e:	89 4a f8             	mov    %ecx,-0x8(%edx)
    currQueue[i+1] = b->blockno;
80102641:	8b 48 08             	mov    0x8(%eax),%ecx
80102644:	89 4a fc             	mov    %ecx,-0x4(%edx)
  for(b = idequeue; b != 0; b = b->qnext){
80102647:	8b 40 58             	mov    0x58(%eax),%eax
8010264a:	85 c0                	test   %eax,%eax
8010264c:	75 ea                	jne    80102638 <get_working_blocks+0x28>
    i = i+2;
  }
  release(&idelock);
8010264e:	83 ec 0c             	sub    $0xc,%esp
80102651:	68 80 c9 10 80       	push   $0x8010c980
80102656:	e8 75 35 00 00       	call   80105bd0 <release>

  return currQueue;
}
8010265b:	b8 60 c5 10 80       	mov    $0x8010c560,%eax
80102660:	c9                   	leave  
80102661:	c3                   	ret    
80102662:	66 90                	xchg   %ax,%ax
80102664:	66 90                	xchg   %ax,%ax
80102666:	66 90                	xchg   %ax,%ax
80102668:	66 90                	xchg   %ax,%ax
8010266a:	66 90                	xchg   %ax,%ax
8010266c:	66 90                	xchg   %ax,%ax
8010266e:	66 90                	xchg   %ax,%ax

80102670 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102670:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102671:	c7 05 34 4d 11 80 00 	movl   $0xfec00000,0x80114d34
80102678:	00 c0 fe 
{
8010267b:	89 e5                	mov    %esp,%ebp
8010267d:	56                   	push   %esi
8010267e:	53                   	push   %ebx
  ioapic->reg = reg;
8010267f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102686:	00 00 00 
  return ioapic->data;
80102689:	a1 34 4d 11 80       	mov    0x80114d34,%eax
8010268e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102691:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102697:	8b 0d 34 4d 11 80    	mov    0x80114d34,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010269d:	0f b6 15 60 4e 11 80 	movzbl 0x80114e60,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026a4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801026a7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026aa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801026ad:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801026b0:	39 c2                	cmp    %eax,%edx
801026b2:	74 16                	je     801026ca <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026b4:	83 ec 0c             	sub    $0xc,%esp
801026b7:	68 d4 88 10 80       	push   $0x801088d4
801026bc:	e8 9f df ff ff       	call   80100660 <cprintf>
801026c1:	8b 0d 34 4d 11 80    	mov    0x80114d34,%ecx
801026c7:	83 c4 10             	add    $0x10,%esp
801026ca:	83 c3 21             	add    $0x21,%ebx
{
801026cd:	ba 10 00 00 00       	mov    $0x10,%edx
801026d2:	b8 20 00 00 00       	mov    $0x20,%eax
801026d7:	89 f6                	mov    %esi,%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801026e0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801026e2:	8b 0d 34 4d 11 80    	mov    0x80114d34,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026e8:	89 c6                	mov    %eax,%esi
801026ea:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026f0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026f3:	89 71 10             	mov    %esi,0x10(%ecx)
801026f6:	8d 72 01             	lea    0x1(%edx),%esi
801026f9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801026fc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801026fe:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102700:	8b 0d 34 4d 11 80    	mov    0x80114d34,%ecx
80102706:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010270d:	75 d1                	jne    801026e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010270f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102712:	5b                   	pop    %ebx
80102713:	5e                   	pop    %esi
80102714:	5d                   	pop    %ebp
80102715:	c3                   	ret    
80102716:	8d 76 00             	lea    0x0(%esi),%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102720:	55                   	push   %ebp
  ioapic->reg = reg;
80102721:	8b 0d 34 4d 11 80    	mov    0x80114d34,%ecx
{
80102727:	89 e5                	mov    %esp,%ebp
80102729:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010272c:	8d 50 20             	lea    0x20(%eax),%edx
8010272f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102733:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102735:	8b 0d 34 4d 11 80    	mov    0x80114d34,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010273b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010273e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102741:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102744:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102746:	a1 34 4d 11 80       	mov    0x80114d34,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010274b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010274e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102751:	5d                   	pop    %ebp
80102752:	c3                   	ret    
80102753:	66 90                	xchg   %ax,%ax
80102755:	66 90                	xchg   %ax,%ax
80102757:	66 90                	xchg   %ax,%ax
80102759:	66 90                	xchg   %ax,%ax
8010275b:	66 90                	xchg   %ax,%ax
8010275d:	66 90                	xchg   %ax,%ax
8010275f:	90                   	nop

80102760 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 04             	sub    $0x4,%esp
80102767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010276a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102770:	75 70                	jne    801027e2 <kfree+0x82>
80102772:	81 fb e8 86 11 80    	cmp    $0x801186e8,%ebx
80102778:	72 68                	jb     801027e2 <kfree+0x82>
8010277a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102780:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102785:	77 5b                	ja     801027e2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102787:	83 ec 04             	sub    $0x4,%esp
8010278a:	68 00 10 00 00       	push   $0x1000
8010278f:	6a 01                	push   $0x1
80102791:	53                   	push   %ebx
80102792:	e8 89 34 00 00       	call   80105c20 <memset>

  if(kmem.use_lock)
80102797:	8b 15 74 4d 11 80    	mov    0x80114d74,%edx
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	85 d2                	test   %edx,%edx
801027a2:	75 2c                	jne    801027d0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027a4:	a1 78 4d 11 80       	mov    0x80114d78,%eax
801027a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801027ab:	a1 74 4d 11 80       	mov    0x80114d74,%eax
  kmem.freelist = r;
801027b0:	89 1d 78 4d 11 80    	mov    %ebx,0x80114d78
  if(kmem.use_lock)
801027b6:	85 c0                	test   %eax,%eax
801027b8:	75 06                	jne    801027c0 <kfree+0x60>
    release(&kmem.lock);
}
801027ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027bd:	c9                   	leave  
801027be:	c3                   	ret    
801027bf:	90                   	nop
    release(&kmem.lock);
801027c0:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
801027c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ca:	c9                   	leave  
    release(&kmem.lock);
801027cb:	e9 00 34 00 00       	jmp    80105bd0 <release>
    acquire(&kmem.lock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 40 4d 11 80       	push   $0x80114d40
801027d8:	e8 33 33 00 00       	call   80105b10 <acquire>
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	eb c2                	jmp    801027a4 <kfree+0x44>
    panic("kfree");
801027e2:	83 ec 0c             	sub    $0xc,%esp
801027e5:	68 06 89 10 80       	push   $0x80108906
801027ea:	e8 a1 db ff ff       	call   80100390 <panic>
801027ef:	90                   	nop

801027f0 <freerange>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027f5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102801:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102807:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010280d:	39 de                	cmp    %ebx,%esi
8010280f:	72 23                	jb     80102834 <freerange+0x44>
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102818:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010281e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102821:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102827:	50                   	push   %eax
80102828:	e8 33 ff ff ff       	call   80102760 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	39 f3                	cmp    %esi,%ebx
80102832:	76 e4                	jbe    80102818 <freerange+0x28>
}
80102834:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102837:	5b                   	pop    %ebx
80102838:	5e                   	pop    %esi
80102839:	5d                   	pop    %ebp
8010283a:	c3                   	ret    
8010283b:	90                   	nop
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102840 <kinit1>:
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	56                   	push   %esi
80102844:	53                   	push   %ebx
80102845:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102848:	83 ec 08             	sub    $0x8,%esp
8010284b:	68 0c 89 10 80       	push   $0x8010890c
80102850:	68 40 4d 11 80       	push   $0x80114d40
80102855:	e8 76 31 00 00       	call   801059d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010285a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010285d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102860:	c7 05 74 4d 11 80 00 	movl   $0x0,0x80114d74
80102867:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010286a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102870:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102876:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010287c:	39 de                	cmp    %ebx,%esi
8010287e:	72 1c                	jb     8010289c <kinit1+0x5c>
    kfree(p);
80102880:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102886:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102889:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010288f:	50                   	push   %eax
80102890:	e8 cb fe ff ff       	call   80102760 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102895:	83 c4 10             	add    $0x10,%esp
80102898:	39 de                	cmp    %ebx,%esi
8010289a:	73 e4                	jae    80102880 <kinit1+0x40>
}
8010289c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010289f:	5b                   	pop    %ebx
801028a0:	5e                   	pop    %esi
801028a1:	5d                   	pop    %ebp
801028a2:	c3                   	ret    
801028a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <kinit2>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cd:	39 de                	cmp    %ebx,%esi
801028cf:	72 23                	jb     801028f4 <kinit2+0x44>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028e7:	50                   	push   %eax
801028e8:	e8 73 fe ff ff       	call   80102760 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	39 de                	cmp    %ebx,%esi
801028f2:	73 e4                	jae    801028d8 <kinit2+0x28>
  kmem.use_lock = 1;
801028f4:	c7 05 74 4d 11 80 01 	movl   $0x1,0x80114d74
801028fb:	00 00 00 
}
801028fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102901:	5b                   	pop    %ebx
80102902:	5e                   	pop    %esi
80102903:	5d                   	pop    %ebp
80102904:	c3                   	ret    
80102905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102910 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102910:	a1 74 4d 11 80       	mov    0x80114d74,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	75 1f                	jne    80102938 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102919:	a1 78 4d 11 80       	mov    0x80114d78,%eax
  if(r)
8010291e:	85 c0                	test   %eax,%eax
80102920:	74 0e                	je     80102930 <kalloc+0x20>
    kmem.freelist = r->next;
80102922:	8b 10                	mov    (%eax),%edx
80102924:	89 15 78 4d 11 80    	mov    %edx,0x80114d78
8010292a:	c3                   	ret    
8010292b:	90                   	nop
8010292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102930:	f3 c3                	repz ret 
80102932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102938:	55                   	push   %ebp
80102939:	89 e5                	mov    %esp,%ebp
8010293b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010293e:	68 40 4d 11 80       	push   $0x80114d40
80102943:	e8 c8 31 00 00       	call   80105b10 <acquire>
  r = kmem.freelist;
80102948:	a1 78 4d 11 80       	mov    0x80114d78,%eax
  if(r)
8010294d:	83 c4 10             	add    $0x10,%esp
80102950:	8b 15 74 4d 11 80    	mov    0x80114d74,%edx
80102956:	85 c0                	test   %eax,%eax
80102958:	74 08                	je     80102962 <kalloc+0x52>
    kmem.freelist = r->next;
8010295a:	8b 08                	mov    (%eax),%ecx
8010295c:	89 0d 78 4d 11 80    	mov    %ecx,0x80114d78
  if(kmem.use_lock)
80102962:	85 d2                	test   %edx,%edx
80102964:	74 16                	je     8010297c <kalloc+0x6c>
    release(&kmem.lock);
80102966:	83 ec 0c             	sub    $0xc,%esp
80102969:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010296c:	68 40 4d 11 80       	push   $0x80114d40
80102971:	e8 5a 32 00 00       	call   80105bd0 <release>
  return (char*)r;
80102976:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102979:	83 c4 10             	add    $0x10,%esp
}
8010297c:	c9                   	leave  
8010297d:	c3                   	ret    
8010297e:	66 90                	xchg   %ax,%ax

80102980 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102980:	ba 64 00 00 00       	mov    $0x64,%edx
80102985:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102986:	a8 01                	test   $0x1,%al
80102988:	0f 84 c2 00 00 00    	je     80102a50 <kbdgetc+0xd0>
8010298e:	ba 60 00 00 00       	mov    $0x60,%edx
80102993:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102994:	0f b6 d0             	movzbl %al,%edx
80102997:	8b 0d b4 c9 10 80    	mov    0x8010c9b4,%ecx

  if(data == 0xE0){
8010299d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801029a3:	0f 84 7f 00 00 00    	je     80102a28 <kbdgetc+0xa8>
{
801029a9:	55                   	push   %ebp
801029aa:	89 e5                	mov    %esp,%ebp
801029ac:	53                   	push   %ebx
801029ad:	89 cb                	mov    %ecx,%ebx
801029af:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801029b2:	84 c0                	test   %al,%al
801029b4:	78 4a                	js     80102a00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029b6:	85 db                	test   %ebx,%ebx
801029b8:	74 09                	je     801029c3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029ba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029bd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801029c0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801029c3:	0f b6 82 40 8a 10 80 	movzbl -0x7fef75c0(%edx),%eax
801029ca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801029cc:	0f b6 82 40 89 10 80 	movzbl -0x7fef76c0(%edx),%eax
801029d3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029d5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801029d7:	89 0d b4 c9 10 80    	mov    %ecx,0x8010c9b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029dd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029e0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029e3:	8b 04 85 20 89 10 80 	mov    -0x7fef76e0(,%eax,4),%eax
801029ea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029ee:	74 31                	je     80102a21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801029f0:	8d 50 9f             	lea    -0x61(%eax),%edx
801029f3:	83 fa 19             	cmp    $0x19,%edx
801029f6:	77 40                	ja     80102a38 <kbdgetc+0xb8>
      c += 'A' - 'a';
801029f8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029fb:	5b                   	pop    %ebx
801029fc:	5d                   	pop    %ebp
801029fd:	c3                   	ret    
801029fe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a00:	83 e0 7f             	and    $0x7f,%eax
80102a03:	85 db                	test   %ebx,%ebx
80102a05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a08:	0f b6 82 40 8a 10 80 	movzbl -0x7fef75c0(%edx),%eax
80102a0f:	83 c8 40             	or     $0x40,%eax
80102a12:	0f b6 c0             	movzbl %al,%eax
80102a15:	f7 d0                	not    %eax
80102a17:	21 c1                	and    %eax,%ecx
    return 0;
80102a19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a1b:	89 0d b4 c9 10 80    	mov    %ecx,0x8010c9b4
}
80102a21:	5b                   	pop    %ebx
80102a22:	5d                   	pop    %ebp
80102a23:	c3                   	ret    
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a2d:	89 0d b4 c9 10 80    	mov    %ecx,0x8010c9b4
    return 0;
80102a33:	c3                   	ret    
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102a38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102a3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102a42:	0f 42 c2             	cmovb  %edx,%eax
}
80102a45:	5d                   	pop    %ebp
80102a46:	c3                   	ret    
80102a47:	89 f6                	mov    %esi,%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a55:	c3                   	ret    
80102a56:	8d 76 00             	lea    0x0(%esi),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <kbdintr>:

void
kbdintr(void)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a66:	68 80 29 10 80       	push   $0x80102980
80102a6b:	e8 a0 dd ff ff       	call   80100810 <consoleintr>
}
80102a70:	83 c4 10             	add    $0x10,%esp
80102a73:	c9                   	leave  
80102a74:	c3                   	ret    
80102a75:	66 90                	xchg   %ax,%ax
80102a77:	66 90                	xchg   %ax,%ax
80102a79:	66 90                	xchg   %ax,%ax
80102a7b:	66 90                	xchg   %ax,%ax
80102a7d:	66 90                	xchg   %ax,%ax
80102a7f:	90                   	nop

80102a80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a80:	a1 7c 4d 11 80       	mov    0x80114d7c,%eax
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a88:	85 c0                	test   %eax,%eax
80102a8a:	0f 84 c8 00 00 00    	je     80102b58 <lapicinit+0xd8>
  lapic[index] = value;
80102a90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102aa4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ab1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102abe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102acb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ad8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102adb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ade:	8b 50 30             	mov    0x30(%eax),%edx
80102ae1:	c1 ea 10             	shr    $0x10,%edx
80102ae4:	80 fa 03             	cmp    $0x3,%dl
80102ae7:	77 77                	ja     80102b60 <lapicinit+0xe0>
  lapic[index] = value;
80102ae9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102af0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102afd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b34:	8b 50 20             	mov    0x20(%eax),%edx
80102b37:	89 f6                	mov    %esi,%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b46:	80 e6 10             	and    $0x10,%dh
80102b49:	75 f5                	jne    80102b40 <lapicinit+0xc0>
  lapic[index] = value;
80102b4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b58:	5d                   	pop    %ebp
80102b59:	c3                   	ret    
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102b60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6a:	8b 50 20             	mov    0x20(%eax),%edx
80102b6d:	e9 77 ff ff ff       	jmp    80102ae9 <lapicinit+0x69>
80102b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b80:	8b 15 7c 4d 11 80    	mov    0x80114d7c,%edx
{
80102b86:	55                   	push   %ebp
80102b87:	31 c0                	xor    %eax,%eax
80102b89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b8b:	85 d2                	test   %edx,%edx
80102b8d:	74 06                	je     80102b95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b8f:	8b 42 20             	mov    0x20(%edx),%eax
80102b92:	c1 e8 18             	shr    $0x18,%eax
}
80102b95:	5d                   	pop    %ebp
80102b96:	c3                   	ret    
80102b97:	89 f6                	mov    %esi,%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ba0:	a1 7c 4d 11 80       	mov    0x80114d7c,%eax
{
80102ba5:	55                   	push   %ebp
80102ba6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ba8:	85 c0                	test   %eax,%eax
80102baa:	74 0d                	je     80102bb9 <lapiceoi+0x19>
  lapic[index] = value;
80102bac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bb3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102bb9:	5d                   	pop    %ebp
80102bba:	c3                   	ret    
80102bbb:	90                   	nop
80102bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
}
80102bc3:	5d                   	pop    %ebp
80102bc4:	c3                   	ret    
80102bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102bd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102bd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bdb:	89 e5                	mov    %esp,%ebp
80102bdd:	53                   	push   %ebx
80102bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102be1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102be4:	ee                   	out    %al,(%dx)
80102be5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bea:	ba 71 00 00 00       	mov    $0x71,%edx
80102bef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102bf0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102bf2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102bf5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bfb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bfd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c00:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c03:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c0e:	a1 7c 4d 11 80       	mov    0x80114d7c,%eax
80102c13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c5a:	5b                   	pop    %ebx
80102c5b:	5d                   	pop    %ebp
80102c5c:	c3                   	ret    
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi

80102c60 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102c60:	55                   	push   %ebp
80102c61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c66:	ba 70 00 00 00       	mov    $0x70,%edx
80102c6b:	89 e5                	mov    %esp,%ebp
80102c6d:	57                   	push   %edi
80102c6e:	56                   	push   %esi
80102c6f:	53                   	push   %ebx
80102c70:	83 ec 4c             	sub    $0x4c,%esp
80102c73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c74:	ba 71 00 00 00       	mov    $0x71,%edx
80102c79:	ec                   	in     (%dx),%al
80102c7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c85:	8d 76 00             	lea    0x0(%esi),%esi
80102c88:	31 c0                	xor    %eax,%eax
80102c8a:	89 da                	mov    %ebx,%edx
80102c8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c92:	89 ca                	mov    %ecx,%edx
80102c94:	ec                   	in     (%dx),%al
80102c95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c98:	89 da                	mov    %ebx,%edx
80102c9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca0:	89 ca                	mov    %ecx,%edx
80102ca2:	ec                   	in     (%dx),%al
80102ca3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca6:	89 da                	mov    %ebx,%edx
80102ca8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cae:	89 ca                	mov    %ecx,%edx
80102cb0:	ec                   	in     (%dx),%al
80102cb1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb4:	89 da                	mov    %ebx,%edx
80102cb6:	b8 07 00 00 00       	mov    $0x7,%eax
80102cbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbc:	89 ca                	mov    %ecx,%edx
80102cbe:	ec                   	in     (%dx),%al
80102cbf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc2:	89 da                	mov    %ebx,%edx
80102cc4:	b8 08 00 00 00       	mov    $0x8,%eax
80102cc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cca:	89 ca                	mov    %ecx,%edx
80102ccc:	ec                   	in     (%dx),%al
80102ccd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ccf:	89 da                	mov    %ebx,%edx
80102cd1:	b8 09 00 00 00       	mov    $0x9,%eax
80102cd6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd7:	89 ca                	mov    %ecx,%edx
80102cd9:	ec                   	in     (%dx),%al
80102cda:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdc:	89 da                	mov    %ebx,%edx
80102cde:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ce3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce4:	89 ca                	mov    %ecx,%edx
80102ce6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ce7:	84 c0                	test   %al,%al
80102ce9:	78 9d                	js     80102c88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102ceb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102cef:	89 fa                	mov    %edi,%edx
80102cf1:	0f b6 fa             	movzbl %dl,%edi
80102cf4:	89 f2                	mov    %esi,%edx
80102cf6:	0f b6 f2             	movzbl %dl,%esi
80102cf9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cfc:	89 da                	mov    %ebx,%edx
80102cfe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d01:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d04:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d08:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d0b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d19:	31 c0                	xor    %eax,%eax
80102d1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1c:	89 ca                	mov    %ecx,%edx
80102d1e:	ec                   	in     (%dx),%al
80102d1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d22:	89 da                	mov    %ebx,%edx
80102d24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d27:	b8 02 00 00 00       	mov    $0x2,%eax
80102d2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2d:	89 ca                	mov    %ecx,%edx
80102d2f:	ec                   	in     (%dx),%al
80102d30:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d33:	89 da                	mov    %ebx,%edx
80102d35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d38:	b8 04 00 00 00       	mov    $0x4,%eax
80102d3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3e:	89 ca                	mov    %ecx,%edx
80102d40:	ec                   	in     (%dx),%al
80102d41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d44:	89 da                	mov    %ebx,%edx
80102d46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d49:	b8 07 00 00 00       	mov    $0x7,%eax
80102d4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4f:	89 ca                	mov    %ecx,%edx
80102d51:	ec                   	in     (%dx),%al
80102d52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d55:	89 da                	mov    %ebx,%edx
80102d57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d60:	89 ca                	mov    %ecx,%edx
80102d62:	ec                   	in     (%dx),%al
80102d63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d66:	89 da                	mov    %ebx,%edx
80102d68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d70:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d71:	89 ca                	mov    %ecx,%edx
80102d73:	ec                   	in     (%dx),%al
80102d74:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d77:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d7d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d80:	6a 18                	push   $0x18
80102d82:	50                   	push   %eax
80102d83:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d86:	50                   	push   %eax
80102d87:	e8 e4 2e 00 00       	call   80105c70 <memcmp>
80102d8c:	83 c4 10             	add    $0x10,%esp
80102d8f:	85 c0                	test   %eax,%eax
80102d91:	0f 85 f1 fe ff ff    	jne    80102c88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d97:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d9b:	75 78                	jne    80102e15 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	83 e0 0f             	and    $0xf,%eax
80102da5:	c1 ea 04             	shr    $0x4,%edx
80102da8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102db1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102db4:	89 c2                	mov    %eax,%edx
80102db6:	83 e0 0f             	and    $0xf,%eax
80102db9:	c1 ea 04             	shr    $0x4,%edx
80102dbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dc2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102dc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dc8:	89 c2                	mov    %eax,%edx
80102dca:	83 e0 0f             	and    $0xf,%eax
80102dcd:	c1 ea 04             	shr    $0x4,%edx
80102dd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dd6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102dd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ddc:	89 c2                	mov    %eax,%edx
80102dde:	83 e0 0f             	and    $0xf,%eax
80102de1:	c1 ea 04             	shr    $0x4,%edx
80102de4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102de7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ded:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102df0:	89 c2                	mov    %eax,%edx
80102df2:	83 e0 0f             	and    $0xf,%eax
80102df5:	c1 ea 04             	shr    $0x4,%edx
80102df8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dfe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e01:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e04:	89 c2                	mov    %eax,%edx
80102e06:	83 e0 0f             	and    $0xf,%eax
80102e09:	c1 ea 04             	shr    $0x4,%edx
80102e0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e12:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e15:	8b 75 08             	mov    0x8(%ebp),%esi
80102e18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e1b:	89 06                	mov    %eax,(%esi)
80102e1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e20:	89 46 04             	mov    %eax,0x4(%esi)
80102e23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e26:	89 46 08             	mov    %eax,0x8(%esi)
80102e29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e2c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e32:	89 46 10             	mov    %eax,0x10(%esi)
80102e35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e38:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e3b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e45:	5b                   	pop    %ebx
80102e46:	5e                   	pop    %esi
80102e47:	5f                   	pop    %edi
80102e48:	5d                   	pop    %ebp
80102e49:	c3                   	ret    
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e50:	8b 0d c8 4d 11 80    	mov    0x80114dc8,%ecx
80102e56:	85 c9                	test   %ecx,%ecx
80102e58:	0f 8e 8a 00 00 00    	jle    80102ee8 <install_trans+0x98>
{
80102e5e:	55                   	push   %ebp
80102e5f:	89 e5                	mov    %esp,%ebp
80102e61:	57                   	push   %edi
80102e62:	56                   	push   %esi
80102e63:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e64:	31 db                	xor    %ebx,%ebx
{
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e70:	a1 b4 4d 11 80       	mov    0x80114db4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 c4 4d 11 80    	pushl  0x80114dc4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d cc 4d 11 80 	pushl  -0x7feeb234(,%ebx,4)
80102e94:	ff 35 c4 4d 11 80    	pushl  0x80114dc4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
80102ea2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ea4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ea7:	83 c4 0c             	add    $0xc,%esp
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 17 2e 00 00       	call   80105cd0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 df d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 17 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 0f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	39 1d c8 4d 11 80    	cmp    %ebx,0x80114dc8
80102eda:	7f 94                	jg     80102e70 <install_trans+0x20>
  }
}
80102edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102edf:	5b                   	pop    %ebx
80102ee0:	5e                   	pop    %esi
80102ee1:	5f                   	pop    %edi
80102ee2:	5d                   	pop    %ebp
80102ee3:	c3                   	ret    
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ee8:	f3 c3                	repz ret 
80102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ef0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	56                   	push   %esi
80102ef4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ef5:	83 ec 08             	sub    $0x8,%esp
80102ef8:	ff 35 b4 4d 11 80    	pushl  0x80114db4
80102efe:	ff 35 c4 4d 11 80    	pushl  0x80114dc4
80102f04:	e8 c7 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f09:	8b 1d c8 4d 11 80    	mov    0x80114dc8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f0f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f12:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f14:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f16:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f19:	7e 16                	jle    80102f31 <write_head+0x41>
80102f1b:	c1 e3 02             	shl    $0x2,%ebx
80102f1e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f20:	8b 8a cc 4d 11 80    	mov    -0x7feeb234(%edx),%ecx
80102f26:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f2a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f2d:	39 da                	cmp    %ebx,%edx
80102f2f:	75 ef                	jne    80102f20 <write_head+0x30>
  }
  bwrite(buf);
80102f31:	83 ec 0c             	sub    $0xc,%esp
80102f34:	56                   	push   %esi
80102f35:	e8 66 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f3a:	89 34 24             	mov    %esi,(%esp)
80102f3d:	e8 9e d2 ff ff       	call   801001e0 <brelse>
}
80102f42:	83 c4 10             	add    $0x10,%esp
80102f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f48:	5b                   	pop    %ebx
80102f49:	5e                   	pop    %esi
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    
80102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f50 <initlog>:
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 2c             	sub    $0x2c,%esp
80102f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f5a:	68 40 8b 10 80       	push   $0x80108b40
80102f5f:	68 80 4d 11 80       	push   $0x80114d80
80102f64:	e8 67 2a 00 00       	call   801059d0 <initlock>
  readsb(dev, &sb);
80102f69:	58                   	pop    %eax
80102f6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f6d:	5a                   	pop    %edx
80102f6e:	50                   	push   %eax
80102f6f:	53                   	push   %ebx
80102f70:	e8 ab e6 ff ff       	call   80101620 <readsb>
  log.size = sb.nlog;
80102f75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f7b:	59                   	pop    %ecx
  log.dev = dev;
80102f7c:	89 1d c4 4d 11 80    	mov    %ebx,0x80114dc4
  log.size = sb.nlog;
80102f82:	89 15 b8 4d 11 80    	mov    %edx,0x80114db8
  log.start = sb.logstart;
80102f88:	a3 b4 4d 11 80       	mov    %eax,0x80114db4
  struct buf *buf = bread(log.dev, log.start);
80102f8d:	5a                   	pop    %edx
80102f8e:	50                   	push   %eax
80102f8f:	53                   	push   %ebx
80102f90:	e8 3b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f95:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f98:	83 c4 10             	add    $0x10,%esp
80102f9b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f9d:	89 1d c8 4d 11 80    	mov    %ebx,0x80114dc8
  for (i = 0; i < log.lh.n; i++) {
80102fa3:	7e 1c                	jle    80102fc1 <initlog+0x71>
80102fa5:	c1 e3 02             	shl    $0x2,%ebx
80102fa8:	31 d2                	xor    %edx,%edx
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102fb0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102fb4:	83 c2 04             	add    $0x4,%edx
80102fb7:	89 8a c8 4d 11 80    	mov    %ecx,-0x7feeb238(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102fbd:	39 d3                	cmp    %edx,%ebx
80102fbf:	75 ef                	jne    80102fb0 <initlog+0x60>
  brelse(buf);
80102fc1:	83 ec 0c             	sub    $0xc,%esp
80102fc4:	50                   	push   %eax
80102fc5:	e8 16 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102fca:	e8 81 fe ff ff       	call   80102e50 <install_trans>
  log.lh.n = 0;
80102fcf:	c7 05 c8 4d 11 80 00 	movl   $0x0,0x80114dc8
80102fd6:	00 00 00 
  write_head(); // clear the log
80102fd9:	e8 12 ff ff ff       	call   80102ef0 <write_head>
}
80102fde:	83 c4 10             	add    $0x10,%esp
80102fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fe4:	c9                   	leave  
80102fe5:	c3                   	ret    
80102fe6:	8d 76 00             	lea    0x0(%esi),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ff6:	68 80 4d 11 80       	push   $0x80114d80
80102ffb:	e8 10 2b 00 00       	call   80105b10 <acquire>
80103000:	83 c4 10             	add    $0x10,%esp
80103003:	eb 18                	jmp    8010301d <begin_op+0x2d>
80103005:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103008:	83 ec 08             	sub    $0x8,%esp
8010300b:	68 80 4d 11 80       	push   $0x80114d80
80103010:	68 80 4d 11 80       	push   $0x80114d80
80103015:	e8 c6 11 00 00       	call   801041e0 <sleep>
8010301a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010301d:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80103022:	85 c0                	test   %eax,%eax
80103024:	75 e2                	jne    80103008 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103026:	a1 bc 4d 11 80       	mov    0x80114dbc,%eax
8010302b:	8b 15 c8 4d 11 80    	mov    0x80114dc8,%edx
80103031:	83 c0 01             	add    $0x1,%eax
80103034:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103037:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010303a:	83 fa 1e             	cmp    $0x1e,%edx
8010303d:	7f c9                	jg     80103008 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010303f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103042:	a3 bc 4d 11 80       	mov    %eax,0x80114dbc
      release(&log.lock);
80103047:	68 80 4d 11 80       	push   $0x80114d80
8010304c:	e8 7f 2b 00 00       	call   80105bd0 <release>
      break;
    }
  }
}
80103051:	83 c4 10             	add    $0x10,%esp
80103054:	c9                   	leave  
80103055:	c3                   	ret    
80103056:	8d 76 00             	lea    0x0(%esi),%esi
80103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103060 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103069:	68 80 4d 11 80       	push   $0x80114d80
8010306e:	e8 9d 2a 00 00       	call   80105b10 <acquire>
  log.outstanding -= 1;
80103073:	a1 bc 4d 11 80       	mov    0x80114dbc,%eax
  if(log.committing)
80103078:	8b 35 c0 4d 11 80    	mov    0x80114dc0,%esi
8010307e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103081:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103084:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103086:	89 1d bc 4d 11 80    	mov    %ebx,0x80114dbc
  if(log.committing)
8010308c:	0f 85 1a 01 00 00    	jne    801031ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103092:	85 db                	test   %ebx,%ebx
80103094:	0f 85 ee 00 00 00    	jne    80103188 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010309a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010309d:	c7 05 c0 4d 11 80 01 	movl   $0x1,0x80114dc0
801030a4:	00 00 00 
  release(&log.lock);
801030a7:	68 80 4d 11 80       	push   $0x80114d80
801030ac:	e8 1f 2b 00 00       	call   80105bd0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801030b1:	8b 0d c8 4d 11 80    	mov    0x80114dc8,%ecx
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c9                	test   %ecx,%ecx
801030bc:	0f 8e 85 00 00 00    	jle    80103147 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801030c2:	a1 b4 4d 11 80       	mov    0x80114db4,%eax
801030c7:	83 ec 08             	sub    $0x8,%esp
801030ca:	01 d8                	add    %ebx,%eax
801030cc:	83 c0 01             	add    $0x1,%eax
801030cf:	50                   	push   %eax
801030d0:	ff 35 c4 4d 11 80    	pushl  0x80114dc4
801030d6:	e8 f5 cf ff ff       	call   801000d0 <bread>
801030db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030dd:	58                   	pop    %eax
801030de:	5a                   	pop    %edx
801030df:	ff 34 9d cc 4d 11 80 	pushl  -0x7feeb234(,%ebx,4)
801030e6:	ff 35 c4 4d 11 80    	pushl  0x80114dc4
  for (tail = 0; tail < log.lh.n; tail++) {
801030ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ef:	e8 dc cf ff ff       	call   801000d0 <bread>
801030f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801030f9:	83 c4 0c             	add    $0xc,%esp
801030fc:	68 00 02 00 00       	push   $0x200
80103101:	50                   	push   %eax
80103102:	8d 46 5c             	lea    0x5c(%esi),%eax
80103105:	50                   	push   %eax
80103106:	e8 c5 2b 00 00       	call   80105cd0 <memmove>
    bwrite(to);  // write the log
8010310b:	89 34 24             	mov    %esi,(%esp)
8010310e:	e8 8d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103113:	89 3c 24             	mov    %edi,(%esp)
80103116:	e8 c5 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010311b:	89 34 24             	mov    %esi,(%esp)
8010311e:	e8 bd d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103123:	83 c4 10             	add    $0x10,%esp
80103126:	3b 1d c8 4d 11 80    	cmp    0x80114dc8,%ebx
8010312c:	7c 94                	jl     801030c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010312e:	e8 bd fd ff ff       	call   80102ef0 <write_head>
    install_trans(); // Now install writes to home locations
80103133:	e8 18 fd ff ff       	call   80102e50 <install_trans>
    log.lh.n = 0;
80103138:	c7 05 c8 4d 11 80 00 	movl   $0x0,0x80114dc8
8010313f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103142:	e8 a9 fd ff ff       	call   80102ef0 <write_head>
    acquire(&log.lock);
80103147:	83 ec 0c             	sub    $0xc,%esp
8010314a:	68 80 4d 11 80       	push   $0x80114d80
8010314f:	e8 bc 29 00 00       	call   80105b10 <acquire>
    wakeup(&log);
80103154:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
    log.committing = 0;
8010315b:	c7 05 c0 4d 11 80 00 	movl   $0x0,0x80114dc0
80103162:	00 00 00 
    wakeup(&log);
80103165:	e8 26 12 00 00       	call   80104390 <wakeup>
    release(&log.lock);
8010316a:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103171:	e8 5a 2a 00 00       	call   80105bd0 <release>
80103176:	83 c4 10             	add    $0x10,%esp
}
80103179:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317c:	5b                   	pop    %ebx
8010317d:	5e                   	pop    %esi
8010317e:	5f                   	pop    %edi
8010317f:	5d                   	pop    %ebp
80103180:	c3                   	ret    
80103181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103188:	83 ec 0c             	sub    $0xc,%esp
8010318b:	68 80 4d 11 80       	push   $0x80114d80
80103190:	e8 fb 11 00 00       	call   80104390 <wakeup>
  release(&log.lock);
80103195:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
8010319c:	e8 2f 2a 00 00       	call   80105bd0 <release>
801031a1:	83 c4 10             	add    $0x10,%esp
}
801031a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a7:	5b                   	pop    %ebx
801031a8:	5e                   	pop    %esi
801031a9:	5f                   	pop    %edi
801031aa:	5d                   	pop    %ebp
801031ab:	c3                   	ret    
    panic("log.committing");
801031ac:	83 ec 0c             	sub    $0xc,%esp
801031af:	68 44 8b 10 80       	push   $0x80108b44
801031b4:	e8 d7 d1 ff ff       	call   80100390 <panic>
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031c7:	8b 15 c8 4d 11 80    	mov    0x80114dc8,%edx
{
801031cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031d0:	83 fa 1d             	cmp    $0x1d,%edx
801031d3:	0f 8f 9d 00 00 00    	jg     80103276 <log_write+0xb6>
801031d9:	a1 b8 4d 11 80       	mov    0x80114db8,%eax
801031de:	83 e8 01             	sub    $0x1,%eax
801031e1:	39 c2                	cmp    %eax,%edx
801031e3:	0f 8d 8d 00 00 00    	jge    80103276 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031e9:	a1 bc 4d 11 80       	mov    0x80114dbc,%eax
801031ee:	85 c0                	test   %eax,%eax
801031f0:	0f 8e 8d 00 00 00    	jle    80103283 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	68 80 4d 11 80       	push   $0x80114d80
801031fe:	e8 0d 29 00 00       	call   80105b10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103203:	8b 0d c8 4d 11 80    	mov    0x80114dc8,%ecx
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	83 f9 00             	cmp    $0x0,%ecx
8010320f:	7e 57                	jle    80103268 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103211:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103214:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103216:	3b 15 cc 4d 11 80    	cmp    0x80114dcc,%edx
8010321c:	75 0b                	jne    80103229 <log_write+0x69>
8010321e:	eb 38                	jmp    80103258 <log_write+0x98>
80103220:	39 14 85 cc 4d 11 80 	cmp    %edx,-0x7feeb234(,%eax,4)
80103227:	74 2f                	je     80103258 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103229:	83 c0 01             	add    $0x1,%eax
8010322c:	39 c1                	cmp    %eax,%ecx
8010322e:	75 f0                	jne    80103220 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103230:	89 14 85 cc 4d 11 80 	mov    %edx,-0x7feeb234(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103237:	83 c0 01             	add    $0x1,%eax
8010323a:	a3 c8 4d 11 80       	mov    %eax,0x80114dc8
  b->flags |= B_DIRTY; // prevent eviction
8010323f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103242:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
80103249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010324c:	c9                   	leave  
  release(&log.lock);
8010324d:	e9 7e 29 00 00       	jmp    80105bd0 <release>
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103258:	89 14 85 cc 4d 11 80 	mov    %edx,-0x7feeb234(,%eax,4)
8010325f:	eb de                	jmp    8010323f <log_write+0x7f>
80103261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103268:	8b 43 08             	mov    0x8(%ebx),%eax
8010326b:	a3 cc 4d 11 80       	mov    %eax,0x80114dcc
  if (i == log.lh.n)
80103270:	75 cd                	jne    8010323f <log_write+0x7f>
80103272:	31 c0                	xor    %eax,%eax
80103274:	eb c1                	jmp    80103237 <log_write+0x77>
    panic("too big a transaction");
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	68 53 8b 10 80       	push   $0x80108b53
8010327e:	e8 0d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	68 69 8b 10 80       	push   $0x80108b69
8010328b:	e8 00 d1 ff ff       	call   80100390 <panic>

80103290 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	53                   	push   %ebx
80103294:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103297:	e8 84 09 00 00       	call   80103c20 <cpuid>
8010329c:	89 c3                	mov    %eax,%ebx
8010329e:	e8 7d 09 00 00       	call   80103c20 <cpuid>
801032a3:	83 ec 04             	sub    $0x4,%esp
801032a6:	53                   	push   %ebx
801032a7:	50                   	push   %eax
801032a8:	68 84 8b 10 80       	push   $0x80108b84
801032ad:	e8 ae d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801032b2:	e8 09 3c 00 00       	call   80106ec0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801032b7:	e8 e4 08 00 00       	call   80103ba0 <mycpu>
801032bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801032be:	b8 01 00 00 00       	mov    $0x1,%eax
801032c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801032ca:	e8 31 0c 00 00       	call   80103f00 <scheduler>
801032cf:	90                   	nop

801032d0 <mpenter>:
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032d6:	e8 d5 4c 00 00       	call   80107fb0 <switchkvm>
  seginit();
801032db:	e8 40 4c 00 00       	call   80107f20 <seginit>
  lapicinit();
801032e0:	e8 9b f7 ff ff       	call   80102a80 <lapicinit>
  mpmain();
801032e5:	e8 a6 ff ff ff       	call   80103290 <mpmain>
801032ea:	66 90                	xchg   %ax,%ax
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <main>:
{
801032f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032f4:	83 e4 f0             	and    $0xfffffff0,%esp
801032f7:	ff 71 fc             	pushl  -0x4(%ecx)
801032fa:	55                   	push   %ebp
801032fb:	89 e5                	mov    %esp,%ebp
801032fd:	53                   	push   %ebx
801032fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032ff:	83 ec 08             	sub    $0x8,%esp
80103302:	68 00 00 40 80       	push   $0x80400000
80103307:	68 e8 86 11 80       	push   $0x801186e8
8010330c:	e8 2f f5 ff ff       	call   80102840 <kinit1>
  kvmalloc();      // kernel page table
80103311:	e8 6a 51 00 00       	call   80108480 <kvmalloc>
  mpinit();        // detect other processors
80103316:	e8 75 01 00 00       	call   80103490 <mpinit>
  lapicinit();     // interrupt controller
8010331b:	e8 60 f7 ff ff       	call   80102a80 <lapicinit>
  seginit();       // segment descriptors
80103320:	e8 fb 4b 00 00       	call   80107f20 <seginit>
  picinit();       // disable pic
80103325:	e8 46 03 00 00       	call   80103670 <picinit>
  ioapicinit();    // another interrupt controller
8010332a:	e8 41 f3 ff ff       	call   80102670 <ioapicinit>
  procfsinit();    // procfs file system
8010332f:	e8 cc 12 00 00       	call   80104600 <procfsinit>
  consoleinit();   // console hardware
80103334:	e8 87 d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103339:	e8 b2 3e 00 00       	call   801071f0 <uartinit>
  pinit();         // process table
8010333e:	e8 3d 08 00 00       	call   80103b80 <pinit>
  tvinit();        // trap vectors
80103343:	e8 f8 3a 00 00       	call   80106e40 <tvinit>
  binit();         // buffer cache
80103348:	e8 f3 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010334d:	e8 0e da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80103352:	e8 19 f0 ff ff       	call   80102370 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103357:	83 c4 0c             	add    $0xc,%esp
8010335a:	68 8a 00 00 00       	push   $0x8a
8010335f:	68 8c c4 10 80       	push   $0x8010c48c
80103364:	68 00 70 00 80       	push   $0x80007000
80103369:	e8 62 29 00 00       	call   80105cd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010336e:	69 05 00 54 11 80 b0 	imul   $0xb0,0x80115400,%eax
80103375:	00 00 00 
80103378:	83 c4 10             	add    $0x10,%esp
8010337b:	05 80 4e 11 80       	add    $0x80114e80,%eax
80103380:	3d 80 4e 11 80       	cmp    $0x80114e80,%eax
80103385:	76 6c                	jbe    801033f3 <main+0x103>
80103387:	bb 80 4e 11 80       	mov    $0x80114e80,%ebx
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103390:	e8 0b 08 00 00       	call   80103ba0 <mycpu>
80103395:	39 d8                	cmp    %ebx,%eax
80103397:	74 41                	je     801033da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103399:	e8 72 f5 ff ff       	call   80102910 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010339e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801033a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801032d0,0x80006ff8
801033aa:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801033ad:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801033b4:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801033b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801033bc:	0f b6 03             	movzbl (%ebx),%eax
801033bf:	83 ec 08             	sub    $0x8,%esp
801033c2:	68 00 70 00 00       	push   $0x7000
801033c7:	50                   	push   %eax
801033c8:	e8 03 f8 ff ff       	call   80102bd0 <lapicstartap>
801033cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033d6:	85 c0                	test   %eax,%eax
801033d8:	74 f6                	je     801033d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801033da:	69 05 00 54 11 80 b0 	imul   $0xb0,0x80115400,%eax
801033e1:	00 00 00 
801033e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033ea:	05 80 4e 11 80       	add    $0x80114e80,%eax
801033ef:	39 c3                	cmp    %eax,%ebx
801033f1:	72 9d                	jb     80103390 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033f3:	83 ec 08             	sub    $0x8,%esp
801033f6:	68 00 00 00 8e       	push   $0x8e000000
801033fb:	68 00 00 40 80       	push   $0x80400000
80103400:	e8 ab f4 ff ff       	call   801028b0 <kinit2>
  userinit();      // first user process
80103405:	e8 66 08 00 00       	call   80103c70 <userinit>
  mpmain();        // finish this processor's setup
8010340a:	e8 81 fe ff ff       	call   80103290 <mpmain>
8010340f:	90                   	nop

80103410 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103415:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010341b:	53                   	push   %ebx
  e = addr+len;
8010341c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010341f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103422:	39 de                	cmp    %ebx,%esi
80103424:	72 10                	jb     80103436 <mpsearch1+0x26>
80103426:	eb 50                	jmp    80103478 <mpsearch1+0x68>
80103428:	90                   	nop
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103430:	39 fb                	cmp    %edi,%ebx
80103432:	89 fe                	mov    %edi,%esi
80103434:	76 42                	jbe    80103478 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103436:	83 ec 04             	sub    $0x4,%esp
80103439:	8d 7e 10             	lea    0x10(%esi),%edi
8010343c:	6a 04                	push   $0x4
8010343e:	68 98 8b 10 80       	push   $0x80108b98
80103443:	56                   	push   %esi
80103444:	e8 27 28 00 00       	call   80105c70 <memcmp>
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	85 c0                	test   %eax,%eax
8010344e:	75 e0                	jne    80103430 <mpsearch1+0x20>
80103450:	89 f1                	mov    %esi,%ecx
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103458:	0f b6 11             	movzbl (%ecx),%edx
8010345b:	83 c1 01             	add    $0x1,%ecx
8010345e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103460:	39 f9                	cmp    %edi,%ecx
80103462:	75 f4                	jne    80103458 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103464:	84 c0                	test   %al,%al
80103466:	75 c8                	jne    80103430 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346b:	89 f0                	mov    %esi,%eax
8010346d:	5b                   	pop    %ebx
8010346e:	5e                   	pop    %esi
8010346f:	5f                   	pop    %edi
80103470:	5d                   	pop    %ebp
80103471:	c3                   	ret    
80103472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010347b:	31 f6                	xor    %esi,%esi
}
8010347d:	89 f0                	mov    %esi,%eax
8010347f:	5b                   	pop    %ebx
80103480:	5e                   	pop    %esi
80103481:	5f                   	pop    %edi
80103482:	5d                   	pop    %ebp
80103483:	c3                   	ret    
80103484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010348a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103490 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103499:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801034a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801034a7:	c1 e0 08             	shl    $0x8,%eax
801034aa:	09 d0                	or     %edx,%eax
801034ac:	c1 e0 04             	shl    $0x4,%eax
801034af:	85 c0                	test   %eax,%eax
801034b1:	75 1b                	jne    801034ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034c1:	c1 e0 08             	shl    $0x8,%eax
801034c4:	09 d0                	or     %edx,%eax
801034c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801034c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801034ce:	ba 00 04 00 00       	mov    $0x400,%edx
801034d3:	e8 38 ff ff ff       	call   80103410 <mpsearch1>
801034d8:	85 c0                	test   %eax,%eax
801034da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034dd:	0f 84 3d 01 00 00    	je     80103620 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034e6:	8b 58 04             	mov    0x4(%eax),%ebx
801034e9:	85 db                	test   %ebx,%ebx
801034eb:	0f 84 4f 01 00 00    	je     80103640 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034f7:	83 ec 04             	sub    $0x4,%esp
801034fa:	6a 04                	push   $0x4
801034fc:	68 b5 8b 10 80       	push   $0x80108bb5
80103501:	56                   	push   %esi
80103502:	e8 69 27 00 00       	call   80105c70 <memcmp>
80103507:	83 c4 10             	add    $0x10,%esp
8010350a:	85 c0                	test   %eax,%eax
8010350c:	0f 85 2e 01 00 00    	jne    80103640 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103512:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103519:	3c 01                	cmp    $0x1,%al
8010351b:	0f 95 c2             	setne  %dl
8010351e:	3c 04                	cmp    $0x4,%al
80103520:	0f 95 c0             	setne  %al
80103523:	20 c2                	and    %al,%dl
80103525:	0f 85 15 01 00 00    	jne    80103640 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010352b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103532:	66 85 ff             	test   %di,%di
80103535:	74 1a                	je     80103551 <mpinit+0xc1>
80103537:	89 f0                	mov    %esi,%eax
80103539:	01 f7                	add    %esi,%edi
  sum = 0;
8010353b:	31 d2                	xor    %edx,%edx
8010353d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103540:	0f b6 08             	movzbl (%eax),%ecx
80103543:	83 c0 01             	add    $0x1,%eax
80103546:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103548:	39 c7                	cmp    %eax,%edi
8010354a:	75 f4                	jne    80103540 <mpinit+0xb0>
8010354c:	84 d2                	test   %dl,%dl
8010354e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103551:	85 f6                	test   %esi,%esi
80103553:	0f 84 e7 00 00 00    	je     80103640 <mpinit+0x1b0>
80103559:	84 d2                	test   %dl,%dl
8010355b:	0f 85 df 00 00 00    	jne    80103640 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103561:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103567:	a3 7c 4d 11 80       	mov    %eax,0x80114d7c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010356c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103573:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103579:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010357e:	01 d6                	add    %edx,%esi
80103580:	39 c6                	cmp    %eax,%esi
80103582:	76 23                	jbe    801035a7 <mpinit+0x117>
    switch(*p){
80103584:	0f b6 10             	movzbl (%eax),%edx
80103587:	80 fa 04             	cmp    $0x4,%dl
8010358a:	0f 87 ca 00 00 00    	ja     8010365a <mpinit+0x1ca>
80103590:	ff 24 95 dc 8b 10 80 	jmp    *-0x7fef7424(,%edx,4)
80103597:	89 f6                	mov    %esi,%esi
80103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035a3:	39 c6                	cmp    %eax,%esi
801035a5:	77 dd                	ja     80103584 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801035a7:	85 db                	test   %ebx,%ebx
801035a9:	0f 84 9e 00 00 00    	je     8010364d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801035b6:	74 15                	je     801035cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035b8:	b8 70 00 00 00       	mov    $0x70,%eax
801035bd:	ba 22 00 00 00       	mov    $0x22,%edx
801035c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035c3:	ba 23 00 00 00       	mov    $0x23,%edx
801035c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801035c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035cc:	ee                   	out    %al,(%dx)
  }
}
801035cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035d0:	5b                   	pop    %ebx
801035d1:	5e                   	pop    %esi
801035d2:	5f                   	pop    %edi
801035d3:	5d                   	pop    %ebp
801035d4:	c3                   	ret    
801035d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801035d8:	8b 0d 00 54 11 80    	mov    0x80115400,%ecx
801035de:	83 f9 07             	cmp    $0x7,%ecx
801035e1:	7f 19                	jg     801035fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801035ed:	83 c1 01             	add    $0x1,%ecx
801035f0:	89 0d 00 54 11 80    	mov    %ecx,0x80115400
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035f6:	88 97 80 4e 11 80    	mov    %dl,-0x7feeb180(%edi)
      p += sizeof(struct mpproc);
801035fc:	83 c0 14             	add    $0x14,%eax
      continue;
801035ff:	e9 7c ff ff ff       	jmp    80103580 <mpinit+0xf0>
80103604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103608:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010360c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010360f:	88 15 60 4e 11 80    	mov    %dl,0x80114e60
      continue;
80103615:	e9 66 ff ff ff       	jmp    80103580 <mpinit+0xf0>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103620:	ba 00 00 01 00       	mov    $0x10000,%edx
80103625:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010362a:	e8 e1 fd ff ff       	call   80103410 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010362f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103634:	0f 85 a9 fe ff ff    	jne    801034e3 <mpinit+0x53>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	68 9d 8b 10 80       	push   $0x80108b9d
80103648:	e8 43 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010364d:	83 ec 0c             	sub    $0xc,%esp
80103650:	68 bc 8b 10 80       	push   $0x80108bbc
80103655:	e8 36 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010365a:	31 db                	xor    %ebx,%ebx
8010365c:	e9 26 ff ff ff       	jmp    80103587 <mpinit+0xf7>
80103661:	66 90                	xchg   %ax,%ax
80103663:	66 90                	xchg   %ax,%ax
80103665:	66 90                	xchg   %ax,%ax
80103667:	66 90                	xchg   %ax,%ax
80103669:	66 90                	xchg   %ax,%ax
8010366b:	66 90                	xchg   %ax,%ax
8010366d:	66 90                	xchg   %ax,%ax
8010366f:	90                   	nop

80103670 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103670:	55                   	push   %ebp
80103671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103676:	ba 21 00 00 00       	mov    $0x21,%edx
8010367b:	89 e5                	mov    %esp,%ebp
8010367d:	ee                   	out    %al,(%dx)
8010367e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103683:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103684:	5d                   	pop    %ebp
80103685:	c3                   	ret    
80103686:	66 90                	xchg   %ax,%ax
80103688:	66 90                	xchg   %ax,%ax
8010368a:	66 90                	xchg   %ax,%ax
8010368c:	66 90                	xchg   %ax,%ax
8010368e:	66 90                	xchg   %ax,%ax

80103690 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 0c             	sub    $0xc,%esp
80103699:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010369c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010369f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801036a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801036ab:	e8 d0 d6 ff ff       	call   80100d80 <filealloc>
801036b0:	85 c0                	test   %eax,%eax
801036b2:	89 03                	mov    %eax,(%ebx)
801036b4:	74 22                	je     801036d8 <pipealloc+0x48>
801036b6:	e8 c5 d6 ff ff       	call   80100d80 <filealloc>
801036bb:	85 c0                	test   %eax,%eax
801036bd:	89 06                	mov    %eax,(%esi)
801036bf:	74 3f                	je     80103700 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801036c1:	e8 4a f2 ff ff       	call   80102910 <kalloc>
801036c6:	85 c0                	test   %eax,%eax
801036c8:	89 c7                	mov    %eax,%edi
801036ca:	75 54                	jne    80103720 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036cc:	8b 03                	mov    (%ebx),%eax
801036ce:	85 c0                	test   %eax,%eax
801036d0:	75 34                	jne    80103706 <pipealloc+0x76>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	74 0c                	je     801036ea <pipealloc+0x5a>
    fileclose(*f1);
801036de:	83 ec 0c             	sub    $0xc,%esp
801036e1:	50                   	push   %eax
801036e2:	e8 59 d7 ff ff       	call   80100e40 <fileclose>
801036e7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036f2:	5b                   	pop    %ebx
801036f3:	5e                   	pop    %esi
801036f4:	5f                   	pop    %edi
801036f5:	5d                   	pop    %ebp
801036f6:	c3                   	ret    
801036f7:	89 f6                	mov    %esi,%esi
801036f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103700:	8b 03                	mov    (%ebx),%eax
80103702:	85 c0                	test   %eax,%eax
80103704:	74 e4                	je     801036ea <pipealloc+0x5a>
    fileclose(*f0);
80103706:	83 ec 0c             	sub    $0xc,%esp
80103709:	50                   	push   %eax
8010370a:	e8 31 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010370f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103711:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103714:	85 c0                	test   %eax,%eax
80103716:	75 c6                	jne    801036de <pipealloc+0x4e>
80103718:	eb d0                	jmp    801036ea <pipealloc+0x5a>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103720:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103723:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010372a:	00 00 00 
  p->writeopen = 1;
8010372d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103734:	00 00 00 
  p->nwrite = 0;
80103737:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010373e:	00 00 00 
  p->nread = 0;
80103741:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103748:	00 00 00 
  initlock(&p->lock, "pipe");
8010374b:	68 f0 8b 10 80       	push   $0x80108bf0
80103750:	50                   	push   %eax
80103751:	e8 7a 22 00 00       	call   801059d0 <initlock>
  (*f0)->type = FD_PIPE;
80103756:	8b 03                	mov    (%ebx),%eax
  return 0;
80103758:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010375b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103761:	8b 03                	mov    (%ebx),%eax
80103763:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103767:	8b 03                	mov    (%ebx),%eax
80103769:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010376d:	8b 03                	mov    (%ebx),%eax
8010376f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103772:	8b 06                	mov    (%esi),%eax
80103774:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010377a:	8b 06                	mov    (%esi),%eax
8010377c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103780:	8b 06                	mov    (%esi),%eax
80103782:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103786:	8b 06                	mov    (%esi),%eax
80103788:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010378b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010378e:	31 c0                	xor    %eax,%eax
}
80103790:	5b                   	pop    %ebx
80103791:	5e                   	pop    %esi
80103792:	5f                   	pop    %edi
80103793:	5d                   	pop    %ebp
80103794:	c3                   	ret    
80103795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	56                   	push   %esi
801037a4:	53                   	push   %ebx
801037a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801037ab:	83 ec 0c             	sub    $0xc,%esp
801037ae:	53                   	push   %ebx
801037af:	e8 5c 23 00 00       	call   80105b10 <acquire>
  if(writable){
801037b4:	83 c4 10             	add    $0x10,%esp
801037b7:	85 f6                	test   %esi,%esi
801037b9:	74 45                	je     80103800 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801037bb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801037c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801037cb:	00 00 00 
    wakeup(&p->nread);
801037ce:	50                   	push   %eax
801037cf:	e8 bc 0b 00 00       	call   80104390 <wakeup>
801037d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801037d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801037dd:	85 d2                	test   %edx,%edx
801037df:	75 0a                	jne    801037eb <pipeclose+0x4b>
801037e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037e7:	85 c0                	test   %eax,%eax
801037e9:	74 35                	je     80103820 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801037ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037f1:	5b                   	pop    %ebx
801037f2:	5e                   	pop    %esi
801037f3:	5d                   	pop    %ebp
    release(&p->lock);
801037f4:	e9 d7 23 00 00       	jmp    80105bd0 <release>
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103800:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103806:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103809:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103810:	00 00 00 
    wakeup(&p->nwrite);
80103813:	50                   	push   %eax
80103814:	e8 77 0b 00 00       	call   80104390 <wakeup>
80103819:	83 c4 10             	add    $0x10,%esp
8010381c:	eb b9                	jmp    801037d7 <pipeclose+0x37>
8010381e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	53                   	push   %ebx
80103824:	e8 a7 23 00 00       	call   80105bd0 <release>
    kfree((char*)p);
80103829:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010382c:	83 c4 10             	add    $0x10,%esp
}
8010382f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103832:	5b                   	pop    %ebx
80103833:	5e                   	pop    %esi
80103834:	5d                   	pop    %ebp
    kfree((char*)p);
80103835:	e9 26 ef ff ff       	jmp    80102760 <kfree>
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103840 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 28             	sub    $0x28,%esp
80103849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010384c:	53                   	push   %ebx
8010384d:	e8 be 22 00 00       	call   80105b10 <acquire>
  for(i = 0; i < n; i++){
80103852:	8b 45 10             	mov    0x10(%ebp),%eax
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	85 c0                	test   %eax,%eax
8010385a:	0f 8e c9 00 00 00    	jle    80103929 <pipewrite+0xe9>
80103860:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103863:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103869:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010386f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103872:	03 4d 10             	add    0x10(%ebp),%ecx
80103875:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103878:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010387e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103884:	39 d0                	cmp    %edx,%eax
80103886:	75 71                	jne    801038f9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103888:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010388e:	85 c0                	test   %eax,%eax
80103890:	74 4e                	je     801038e0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103892:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103898:	eb 3a                	jmp    801038d4 <pipewrite+0x94>
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	57                   	push   %edi
801038a4:	e8 e7 0a 00 00       	call   80104390 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038a9:	5a                   	pop    %edx
801038aa:	59                   	pop    %ecx
801038ab:	53                   	push   %ebx
801038ac:	56                   	push   %esi
801038ad:	e8 2e 09 00 00       	call   801041e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038b2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038b8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801038be:	83 c4 10             	add    $0x10,%esp
801038c1:	05 00 02 00 00       	add    $0x200,%eax
801038c6:	39 c2                	cmp    %eax,%edx
801038c8:	75 36                	jne    80103900 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801038ca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038d0:	85 c0                	test   %eax,%eax
801038d2:	74 0c                	je     801038e0 <pipewrite+0xa0>
801038d4:	e8 67 03 00 00       	call   80103c40 <myproc>
801038d9:	8b 40 24             	mov    0x24(%eax),%eax
801038dc:	85 c0                	test   %eax,%eax
801038de:	74 c0                	je     801038a0 <pipewrite+0x60>
        release(&p->lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	53                   	push   %ebx
801038e4:	e8 e7 22 00 00       	call   80105bd0 <release>
        return -1;
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038f4:	5b                   	pop    %ebx
801038f5:	5e                   	pop    %esi
801038f6:	5f                   	pop    %edi
801038f7:	5d                   	pop    %ebp
801038f8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038f9:	89 c2                	mov    %eax,%edx
801038fb:	90                   	nop
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103900:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103903:	8d 42 01             	lea    0x1(%edx),%eax
80103906:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010390c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103912:	83 c6 01             	add    $0x1,%esi
80103915:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103919:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010391c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010391f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103923:	0f 85 4f ff ff ff    	jne    80103878 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103929:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010392f:	83 ec 0c             	sub    $0xc,%esp
80103932:	50                   	push   %eax
80103933:	e8 58 0a 00 00       	call   80104390 <wakeup>
  release(&p->lock);
80103938:	89 1c 24             	mov    %ebx,(%esp)
8010393b:	e8 90 22 00 00       	call   80105bd0 <release>
  return n;
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	8b 45 10             	mov    0x10(%ebp),%eax
80103946:	eb a9                	jmp    801038f1 <pipewrite+0xb1>
80103948:	90                   	nop
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103950 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 18             	sub    $0x18,%esp
80103959:	8b 75 08             	mov    0x8(%ebp),%esi
8010395c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010395f:	56                   	push   %esi
80103960:	e8 ab 21 00 00       	call   80105b10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010396e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103974:	75 6a                	jne    801039e0 <piperead+0x90>
80103976:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010397c:	85 db                	test   %ebx,%ebx
8010397e:	0f 84 c4 00 00 00    	je     80103a48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103984:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010398a:	eb 2d                	jmp    801039b9 <piperead+0x69>
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103990:	83 ec 08             	sub    $0x8,%esp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
80103995:	e8 46 08 00 00       	call   801041e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010399a:	83 c4 10             	add    $0x10,%esp
8010399d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039a3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039a9:	75 35                	jne    801039e0 <piperead+0x90>
801039ab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801039b1:	85 d2                	test   %edx,%edx
801039b3:	0f 84 8f 00 00 00    	je     80103a48 <piperead+0xf8>
    if(myproc()->killed){
801039b9:	e8 82 02 00 00       	call   80103c40 <myproc>
801039be:	8b 48 24             	mov    0x24(%eax),%ecx
801039c1:	85 c9                	test   %ecx,%ecx
801039c3:	74 cb                	je     80103990 <piperead+0x40>
      release(&p->lock);
801039c5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039cd:	56                   	push   %esi
801039ce:	e8 fd 21 00 00       	call   80105bd0 <release>
      return -1;
801039d3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801039d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d9:	89 d8                	mov    %ebx,%eax
801039db:	5b                   	pop    %ebx
801039dc:	5e                   	pop    %esi
801039dd:	5f                   	pop    %edi
801039de:	5d                   	pop    %ebp
801039df:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039e0:	8b 45 10             	mov    0x10(%ebp),%eax
801039e3:	85 c0                	test   %eax,%eax
801039e5:	7e 61                	jle    80103a48 <piperead+0xf8>
    if(p->nread == p->nwrite)
801039e7:	31 db                	xor    %ebx,%ebx
801039e9:	eb 13                	jmp    801039fe <piperead+0xae>
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039f0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039f6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039fc:	74 1f                	je     80103a1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039fe:	8d 41 01             	lea    0x1(%ecx),%eax
80103a01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a15:	83 c3 01             	add    $0x1,%ebx
80103a18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a1b:	75 d3                	jne    801039f0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a23:	83 ec 0c             	sub    $0xc,%esp
80103a26:	50                   	push   %eax
80103a27:	e8 64 09 00 00       	call   80104390 <wakeup>
  release(&p->lock);
80103a2c:	89 34 24             	mov    %esi,(%esp)
80103a2f:	e8 9c 21 00 00       	call   80105bd0 <release>
  return i;
80103a34:	83 c4 10             	add    $0x10,%esp
}
80103a37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a3a:	89 d8                	mov    %ebx,%eax
80103a3c:	5b                   	pop    %ebx
80103a3d:	5e                   	pop    %esi
80103a3e:	5f                   	pop    %edi
80103a3f:	5d                   	pop    %ebp
80103a40:	c3                   	ret    
80103a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a48:	31 db                	xor    %ebx,%ebx
80103a4a:	eb d1                	jmp    80103a1d <piperead+0xcd>
80103a4c:	66 90                	xchg   %ax,%ax
80103a4e:	66 90                	xchg   %ax,%ax

80103a50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a54:	bb 54 54 11 80       	mov    $0x80115454,%ebx
{
80103a59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a5c:	68 20 54 11 80       	push   $0x80115420
80103a61:	e8 aa 20 00 00       	call   80105b10 <acquire>
80103a66:	83 c4 10             	add    $0x10,%esp
80103a69:	eb 14                	jmp    80103a7f <allocproc+0x2f>
80103a6b:	90                   	nop
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a70:	83 c3 7c             	add    $0x7c,%ebx
80103a73:	81 fb 54 73 11 80    	cmp    $0x80117354,%ebx
80103a79:	0f 83 81 00 00 00    	jae    80103b00 <allocproc+0xb0>
    if(p->state == UNUSED)
80103a7f:	8b 53 0c             	mov    0xc(%ebx),%edx
80103a82:	85 d2                	test   %edx,%edx
80103a84:	75 ea                	jne    80103a70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a86:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103a8b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a8e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a95:	8d 50 01             	lea    0x1(%eax),%edx
80103a98:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103a9b:	68 20 54 11 80       	push   $0x80115420
  p->pid = nextpid++;
80103aa0:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103aa6:	e8 25 21 00 00       	call   80105bd0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103aab:	e8 60 ee ff ff       	call   80102910 <kalloc>
80103ab0:	83 c4 10             	add    $0x10,%esp
80103ab3:	85 c0                	test   %eax,%eax
80103ab5:	89 43 08             	mov    %eax,0x8(%ebx)
80103ab8:	74 5f                	je     80103b19 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103aba:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ac0:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103ac3:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ac8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103acb:	c7 40 14 32 6e 10 80 	movl   $0x80106e32,0x14(%eax)
  p->context = (struct context*)sp;
80103ad2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ad5:	6a 14                	push   $0x14
80103ad7:	6a 00                	push   $0x0
80103ad9:	50                   	push   %eax
80103ada:	e8 41 21 00 00       	call   80105c20 <memset>
  p->context->eip = (uint)forkret;
80103adf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ae2:	c7 40 10 30 3b 10 80 	movl   $0x80103b30,0x10(%eax)

  procfs_add_proc(p->pid);
80103ae9:	58                   	pop    %eax
80103aea:	ff 73 10             	pushl  0x10(%ebx)
80103aed:	e8 fe 0d 00 00       	call   801048f0 <procfs_add_proc>

  return p;
80103af2:	83 c4 10             	add    $0x10,%esp
}
80103af5:	89 d8                	mov    %ebx,%eax
80103af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103afa:	c9                   	leave  
80103afb:	c3                   	ret    
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103b00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b05:	68 20 54 11 80       	push   $0x80115420
80103b0a:	e8 c1 20 00 00       	call   80105bd0 <release>
}
80103b0f:	89 d8                	mov    %ebx,%eax
  return 0;
80103b11:	83 c4 10             	add    $0x10,%esp
}
80103b14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b17:	c9                   	leave  
80103b18:	c3                   	ret    
    p->state = UNUSED;
80103b19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b20:	31 db                	xor    %ebx,%ebx
80103b22:	eb d1                	jmp    80103af5 <allocproc+0xa5>
80103b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b36:	68 20 54 11 80       	push   $0x80115420
80103b3b:	e8 90 20 00 00       	call   80105bd0 <release>

  if (first) {
80103b40:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	85 c0                	test   %eax,%eax
80103b4a:	75 04                	jne    80103b50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b4c:	c9                   	leave  
80103b4d:	c3                   	ret    
80103b4e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103b50:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103b53:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103b5a:	00 00 00 
    iinit(ROOTDEV);
80103b5d:	6a 01                	push   $0x1
80103b5f:	e8 7c db ff ff       	call   801016e0 <iinit>
    initlog(ROOTDEV);
80103b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b6b:	e8 e0 f3 ff ff       	call   80102f50 <initlog>
80103b70:	83 c4 10             	add    $0x10,%esp
}
80103b73:	c9                   	leave  
80103b74:	c3                   	ret    
80103b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <pinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b86:	68 f5 8b 10 80       	push   $0x80108bf5
80103b8b:	68 20 54 11 80       	push   $0x80115420
80103b90:	e8 3b 1e 00 00       	call   801059d0 <initlock>
}
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	c9                   	leave  
80103b99:	c3                   	ret    
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <mycpu>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba5:	9c                   	pushf  
80103ba6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ba7:	f6 c4 02             	test   $0x2,%ah
80103baa:	75 5e                	jne    80103c0a <mycpu+0x6a>
  apicid = lapicid();
80103bac:	e8 cf ef ff ff       	call   80102b80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103bb1:	8b 35 00 54 11 80    	mov    0x80115400,%esi
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	7e 42                	jle    80103bfd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bbb:	0f b6 15 80 4e 11 80 	movzbl 0x80114e80,%edx
80103bc2:	39 d0                	cmp    %edx,%eax
80103bc4:	74 30                	je     80103bf6 <mycpu+0x56>
80103bc6:	b9 30 4f 11 80       	mov    $0x80114f30,%ecx
  for (i = 0; i < ncpu; ++i) {
80103bcb:	31 d2                	xor    %edx,%edx
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
80103bd0:	83 c2 01             	add    $0x1,%edx
80103bd3:	39 f2                	cmp    %esi,%edx
80103bd5:	74 26                	je     80103bfd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bd7:	0f b6 19             	movzbl (%ecx),%ebx
80103bda:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103be0:	39 c3                	cmp    %eax,%ebx
80103be2:	75 ec                	jne    80103bd0 <mycpu+0x30>
80103be4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103bea:	05 80 4e 11 80       	add    $0x80114e80,%eax
}
80103bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf2:	5b                   	pop    %ebx
80103bf3:	5e                   	pop    %esi
80103bf4:	5d                   	pop    %ebp
80103bf5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103bf6:	b8 80 4e 11 80       	mov    $0x80114e80,%eax
      return &cpus[i];
80103bfb:	eb f2                	jmp    80103bef <mycpu+0x4f>
  panic("unknown apicid\n");
80103bfd:	83 ec 0c             	sub    $0xc,%esp
80103c00:	68 fc 8b 10 80       	push   $0x80108bfc
80103c05:	e8 86 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 e8 8c 10 80       	push   $0x80108ce8
80103c12:	e8 79 c7 ff ff       	call   80100390 <panic>
80103c17:	89 f6                	mov    %esi,%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <cpuid>:
cpuid() {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c26:	e8 75 ff ff ff       	call   80103ba0 <mycpu>
80103c2b:	2d 80 4e 11 80       	sub    $0x80114e80,%eax
}
80103c30:	c9                   	leave  
  return mycpu()-cpus;
80103c31:	c1 f8 04             	sar    $0x4,%eax
80103c34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c3a:	c3                   	ret    
80103c3b:	90                   	nop
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c40 <myproc>:
myproc(void) {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	53                   	push   %ebx
80103c44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c47:	e8 f4 1d 00 00       	call   80105a40 <pushcli>
  c = mycpu();
80103c4c:	e8 4f ff ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103c51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c57:	e8 24 1e 00 00       	call   80105a80 <popcli>
}
80103c5c:	83 c4 04             	add    $0x4,%esp
80103c5f:	89 d8                	mov    %ebx,%eax
80103c61:	5b                   	pop    %ebx
80103c62:	5d                   	pop    %ebp
80103c63:	c3                   	ret    
80103c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c70 <userinit>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
80103c74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c77:	e8 d4 fd ff ff       	call   80103a50 <allocproc>
80103c7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c7e:	a3 b8 c9 10 80       	mov    %eax,0x8010c9b8
  if((p->pgdir = setupkvm()) == 0)
80103c83:	e8 78 47 00 00       	call   80108400 <setupkvm>
80103c88:	85 c0                	test   %eax,%eax
80103c8a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c8d:	0f 84 bd 00 00 00    	je     80103d50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c93:	83 ec 04             	sub    $0x4,%esp
80103c96:	68 2c 00 00 00       	push   $0x2c
80103c9b:	68 60 c4 10 80       	push   $0x8010c460
80103ca0:	50                   	push   %eax
80103ca1:	e8 3a 44 00 00       	call   801080e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ca6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ca9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103caf:	6a 4c                	push   $0x4c
80103cb1:	6a 00                	push   $0x0
80103cb3:	ff 73 18             	pushl  0x18(%ebx)
80103cb6:	e8 65 1f 00 00       	call   80105c20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cbb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cc3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cc8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ccb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ccf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cdd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ce1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ce8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cec:	8b 43 18             	mov    0x18(%ebx),%eax
80103cef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d00:	8b 43 18             	mov    0x18(%ebx),%eax
80103d03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	68 25 8c 10 80       	push   $0x80108c25
80103d14:	50                   	push   %eax
80103d15:	e8 e6 20 00 00       	call   80105e00 <safestrcpy>
  p->cwd = namei("/");
80103d1a:	c7 04 24 2e 8c 10 80 	movl   $0x80108c2e,(%esp)
80103d21:	e8 aa e4 ff ff       	call   801021d0 <namei>
80103d26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d29:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
80103d30:	e8 db 1d 00 00       	call   80105b10 <acquire>
  p->state = RUNNABLE;
80103d35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d3c:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
80103d43:	e8 88 1e 00 00       	call   80105bd0 <release>
}
80103d48:	83 c4 10             	add    $0x10,%esp
80103d4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d4e:	c9                   	leave  
80103d4f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d50:	83 ec 0c             	sub    $0xc,%esp
80103d53:	68 0c 8c 10 80       	push   $0x80108c0c
80103d58:	e8 33 c6 ff ff       	call   80100390 <panic>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi

80103d60 <growproc>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	56                   	push   %esi
80103d64:	53                   	push   %ebx
80103d65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d68:	e8 d3 1c 00 00       	call   80105a40 <pushcli>
  c = mycpu();
80103d6d:	e8 2e fe ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103d72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d78:	e8 03 1d 00 00       	call   80105a80 <popcli>
  if(n > 0){
80103d7d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d82:	7f 1c                	jg     80103da0 <growproc+0x40>
  } else if(n < 0){
80103d84:	75 3a                	jne    80103dc0 <growproc+0x60>
  switchuvm(curproc);
80103d86:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d89:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d8b:	53                   	push   %ebx
80103d8c:	e8 3f 42 00 00       	call   80107fd0 <switchuvm>
  return 0;
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	31 c0                	xor    %eax,%eax
}
80103d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret    
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103da0:	83 ec 04             	sub    $0x4,%esp
80103da3:	01 c6                	add    %eax,%esi
80103da5:	56                   	push   %esi
80103da6:	50                   	push   %eax
80103da7:	ff 73 04             	pushl  0x4(%ebx)
80103daa:	e8 71 44 00 00       	call   80108220 <allocuvm>
80103daf:	83 c4 10             	add    $0x10,%esp
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 d0                	jne    80103d86 <growproc+0x26>
      return -1;
80103db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dbb:	eb d9                	jmp    80103d96 <growproc+0x36>
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dc0:	83 ec 04             	sub    $0x4,%esp
80103dc3:	01 c6                	add    %eax,%esi
80103dc5:	56                   	push   %esi
80103dc6:	50                   	push   %eax
80103dc7:	ff 73 04             	pushl  0x4(%ebx)
80103dca:	e8 81 45 00 00       	call   80108350 <deallocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 b0                	jne    80103d86 <growproc+0x26>
80103dd6:	eb de                	jmp    80103db6 <growproc+0x56>
80103dd8:	90                   	nop
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <fork>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103de9:	e8 52 1c 00 00       	call   80105a40 <pushcli>
  c = mycpu();
80103dee:	e8 ad fd ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103df3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103df9:	e8 82 1c 00 00       	call   80105a80 <popcli>
  if((np = allocproc()) == 0){
80103dfe:	e8 4d fc ff ff       	call   80103a50 <allocproc>
80103e03:	85 c0                	test   %eax,%eax
80103e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e08:	0f 84 b7 00 00 00    	je     80103ec5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e0e:	83 ec 08             	sub    $0x8,%esp
80103e11:	ff 33                	pushl  (%ebx)
80103e13:	ff 73 04             	pushl  0x4(%ebx)
80103e16:	89 c7                	mov    %eax,%edi
80103e18:	e8 b3 46 00 00       	call   801084d0 <copyuvm>
80103e1d:	83 c4 10             	add    $0x10,%esp
80103e20:	85 c0                	test   %eax,%eax
80103e22:	89 47 04             	mov    %eax,0x4(%edi)
80103e25:	0f 84 a1 00 00 00    	je     80103ecc <fork+0xec>
  np->sz = curproc->sz;
80103e2b:	8b 03                	mov    (%ebx),%eax
80103e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e30:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103e32:	89 59 14             	mov    %ebx,0x14(%ecx)
80103e35:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103e37:	8b 79 18             	mov    0x18(%ecx),%edi
80103e3a:	8b 73 18             	mov    0x18(%ebx),%esi
80103e3d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e46:	8b 40 18             	mov    0x18(%eax),%eax
80103e49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e54:	85 c0                	test   %eax,%eax
80103e56:	74 13                	je     80103e6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e58:	83 ec 0c             	sub    $0xc,%esp
80103e5b:	50                   	push   %eax
80103e5c:	e8 8f cf ff ff       	call   80100df0 <filedup>
80103e61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e6b:	83 c6 01             	add    $0x1,%esi
80103e6e:	83 fe 10             	cmp    $0x10,%esi
80103e71:	75 dd                	jne    80103e50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e7c:	e8 2f da ff ff       	call   801018b0 <idup>
80103e81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e8d:	6a 10                	push   $0x10
80103e8f:	53                   	push   %ebx
80103e90:	50                   	push   %eax
80103e91:	e8 6a 1f 00 00       	call   80105e00 <safestrcpy>
  pid = np->pid;
80103e96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e99:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
80103ea0:	e8 6b 1c 00 00       	call   80105b10 <acquire>
  np->state = RUNNABLE;
80103ea5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103eac:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
80103eb3:	e8 18 1d 00 00       	call   80105bd0 <release>
  return pid;
80103eb8:	83 c4 10             	add    $0x10,%esp
}
80103ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ebe:	89 d8                	mov    %ebx,%eax
80103ec0:	5b                   	pop    %ebx
80103ec1:	5e                   	pop    %esi
80103ec2:	5f                   	pop    %edi
80103ec3:	5d                   	pop    %ebp
80103ec4:	c3                   	ret    
    return -1;
80103ec5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eca:	eb ef                	jmp    80103ebb <fork+0xdb>
    kfree(np->kstack);
80103ecc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ecf:	83 ec 0c             	sub    $0xc,%esp
80103ed2:	ff 73 08             	pushl  0x8(%ebx)
80103ed5:	e8 86 e8 ff ff       	call   80102760 <kfree>
    np->kstack = 0;
80103eda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ee1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ee8:	83 c4 10             	add    $0x10,%esp
80103eeb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ef0:	eb c9                	jmp    80103ebb <fork+0xdb>
80103ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <scheduler>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f09:	e8 92 fc ff ff       	call   80103ba0 <mycpu>
80103f0e:	8d 78 04             	lea    0x4(%eax),%edi
80103f11:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f1a:	00 00 00 
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f20:	fb                   	sti    
    acquire(&ptable.lock);
80103f21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f24:	bb 54 54 11 80       	mov    $0x80115454,%ebx
    acquire(&ptable.lock);
80103f29:	68 20 54 11 80       	push   $0x80115420
80103f2e:	e8 dd 1b 00 00       	call   80105b10 <acquire>
80103f33:	83 c4 10             	add    $0x10,%esp
80103f36:	8d 76 00             	lea    0x0(%esi),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103f40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f44:	75 33                	jne    80103f79 <scheduler+0x79>
      switchuvm(p);
80103f46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f4f:	53                   	push   %ebx
80103f50:	e8 7b 40 00 00       	call   80107fd0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f55:	58                   	pop    %eax
80103f56:	5a                   	pop    %edx
80103f57:	ff 73 1c             	pushl  0x1c(%ebx)
80103f5a:	57                   	push   %edi
      p->state = RUNNING;
80103f5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f62:	e8 f4 1e 00 00       	call   80105e5b <swtch>
      switchkvm();
80103f67:	e8 44 40 00 00       	call   80107fb0 <switchkvm>
      c->proc = 0;
80103f6c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f73:	00 00 00 
80103f76:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f79:	83 c3 7c             	add    $0x7c,%ebx
80103f7c:	81 fb 54 73 11 80    	cmp    $0x80117354,%ebx
80103f82:	72 bc                	jb     80103f40 <scheduler+0x40>
    release(&ptable.lock);
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 20 54 11 80       	push   $0x80115420
80103f8c:	e8 3f 1c 00 00       	call   80105bd0 <release>
    sti();
80103f91:	83 c4 10             	add    $0x10,%esp
80103f94:	eb 8a                	jmp    80103f20 <scheduler+0x20>
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <sched>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
  pushcli();
80103fa5:	e8 96 1a 00 00       	call   80105a40 <pushcli>
  c = mycpu();
80103faa:	e8 f1 fb ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103faf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb5:	e8 c6 1a 00 00       	call   80105a80 <popcli>
  if(!holding(&ptable.lock))
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 20 54 11 80       	push   $0x80115420
80103fc2:	e8 19 1b 00 00       	call   80105ae0 <holding>
80103fc7:	83 c4 10             	add    $0x10,%esp
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 4f                	je     8010401d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fce:	e8 cd fb ff ff       	call   80103ba0 <mycpu>
80103fd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fda:	75 68                	jne    80104044 <sched+0xa4>
  if(p->state == RUNNING)
80103fdc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fe0:	74 55                	je     80104037 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fe2:	9c                   	pushf  
80103fe3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fe4:	f6 c4 02             	test   $0x2,%ah
80103fe7:	75 41                	jne    8010402a <sched+0x8a>
  intena = mycpu()->intena;
80103fe9:	e8 b2 fb ff ff       	call   80103ba0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ff1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ff7:	e8 a4 fb ff ff       	call   80103ba0 <mycpu>
80103ffc:	83 ec 08             	sub    $0x8,%esp
80103fff:	ff 70 04             	pushl  0x4(%eax)
80104002:	53                   	push   %ebx
80104003:	e8 53 1e 00 00       	call   80105e5b <swtch>
  mycpu()->intena = intena;
80104008:	e8 93 fb ff ff       	call   80103ba0 <mycpu>
}
8010400d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104010:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104016:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104019:	5b                   	pop    %ebx
8010401a:	5e                   	pop    %esi
8010401b:	5d                   	pop    %ebp
8010401c:	c3                   	ret    
    panic("sched ptable.lock");
8010401d:	83 ec 0c             	sub    $0xc,%esp
80104020:	68 30 8c 10 80       	push   $0x80108c30
80104025:	e8 66 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 5c 8c 10 80       	push   $0x80108c5c
80104032:	e8 59 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80104037:	83 ec 0c             	sub    $0xc,%esp
8010403a:	68 4e 8c 10 80       	push   $0x80108c4e
8010403f:	e8 4c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	68 42 8c 10 80       	push   $0x80108c42
8010404c:	e8 3f c3 ff ff       	call   80100390 <panic>
80104051:	eb 0d                	jmp    80104060 <exit>
80104053:	90                   	nop
80104054:	90                   	nop
80104055:	90                   	nop
80104056:	90                   	nop
80104057:	90                   	nop
80104058:	90                   	nop
80104059:	90                   	nop
8010405a:	90                   	nop
8010405b:	90                   	nop
8010405c:	90                   	nop
8010405d:	90                   	nop
8010405e:	90                   	nop
8010405f:	90                   	nop

80104060 <exit>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104069:	e8 d2 19 00 00       	call   80105a40 <pushcli>
  c = mycpu();
8010406e:	e8 2d fb ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104073:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104079:	e8 02 1a 00 00       	call   80105a80 <popcli>
  if(curproc == initproc)
8010407e:	39 35 b8 c9 10 80    	cmp    %esi,0x8010c9b8
80104084:	8d 5e 28             	lea    0x28(%esi),%ebx
80104087:	8d 7e 68             	lea    0x68(%esi),%edi
8010408a:	0f 84 f1 00 00 00    	je     80104181 <exit+0x121>
    if(curproc->ofile[fd]){
80104090:	8b 03                	mov    (%ebx),%eax
80104092:	85 c0                	test   %eax,%eax
80104094:	74 12                	je     801040a8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	50                   	push   %eax
8010409a:	e8 a1 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010409f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040a5:	83 c4 10             	add    $0x10,%esp
801040a8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801040ab:	39 fb                	cmp    %edi,%ebx
801040ad:	75 e1                	jne    80104090 <exit+0x30>
  begin_op();
801040af:	e8 3c ef ff ff       	call   80102ff0 <begin_op>
  iput(curproc->cwd);
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	ff 76 68             	pushl  0x68(%esi)
801040ba:	e8 51 d9 ff ff       	call   80101a10 <iput>
  end_op();
801040bf:	e8 9c ef ff ff       	call   80103060 <end_op>
  curproc->cwd = 0;
801040c4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801040cb:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
801040d2:	e8 39 1a 00 00       	call   80105b10 <acquire>
  wakeup1(curproc->parent);
801040d7:	8b 56 14             	mov    0x14(%esi),%edx
801040da:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dd:	b8 54 54 11 80       	mov    $0x80115454,%eax
801040e2:	eb 0e                	jmp    801040f2 <exit+0x92>
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e8:	83 c0 7c             	add    $0x7c,%eax
801040eb:	3d 54 73 11 80       	cmp    $0x80117354,%eax
801040f0:	73 1c                	jae    8010410e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801040f2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040f6:	75 f0                	jne    801040e8 <exit+0x88>
801040f8:	3b 50 20             	cmp    0x20(%eax),%edx
801040fb:	75 eb                	jne    801040e8 <exit+0x88>
      p->state = RUNNABLE;
801040fd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104104:	83 c0 7c             	add    $0x7c,%eax
80104107:	3d 54 73 11 80       	cmp    $0x80117354,%eax
8010410c:	72 e4                	jb     801040f2 <exit+0x92>
      p->parent = initproc;
8010410e:	8b 0d b8 c9 10 80    	mov    0x8010c9b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104114:	ba 54 54 11 80       	mov    $0x80115454,%edx
80104119:	eb 10                	jmp    8010412b <exit+0xcb>
8010411b:	90                   	nop
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104120:	83 c2 7c             	add    $0x7c,%edx
80104123:	81 fa 54 73 11 80    	cmp    $0x80117354,%edx
80104129:	73 33                	jae    8010415e <exit+0xfe>
    if(p->parent == curproc){
8010412b:	39 72 14             	cmp    %esi,0x14(%edx)
8010412e:	75 f0                	jne    80104120 <exit+0xc0>
      if(p->state == ZOMBIE)
80104130:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104134:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104137:	75 e7                	jne    80104120 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104139:	b8 54 54 11 80       	mov    $0x80115454,%eax
8010413e:	eb 0a                	jmp    8010414a <exit+0xea>
80104140:	83 c0 7c             	add    $0x7c,%eax
80104143:	3d 54 73 11 80       	cmp    $0x80117354,%eax
80104148:	73 d6                	jae    80104120 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010414a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010414e:	75 f0                	jne    80104140 <exit+0xe0>
80104150:	3b 48 20             	cmp    0x20(%eax),%ecx
80104153:	75 eb                	jne    80104140 <exit+0xe0>
      p->state = RUNNABLE;
80104155:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010415c:	eb e2                	jmp    80104140 <exit+0xe0>
  procfs_remove_proc(curproc->pid);
8010415e:	83 ec 0c             	sub    $0xc,%esp
  curproc->state = ZOMBIE;
80104161:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  procfs_remove_proc(curproc->pid);
80104168:	ff 76 10             	pushl  0x10(%esi)
8010416b:	e8 d0 07 00 00       	call   80104940 <procfs_remove_proc>
  sched();
80104170:	e8 2b fe ff ff       	call   80103fa0 <sched>
  panic("zombie exit");
80104175:	c7 04 24 7d 8c 10 80 	movl   $0x80108c7d,(%esp)
8010417c:	e8 0f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104181:	83 ec 0c             	sub    $0xc,%esp
80104184:	68 70 8c 10 80       	push   $0x80108c70
80104189:	e8 02 c2 ff ff       	call   80100390 <panic>
8010418e:	66 90                	xchg   %ax,%ax

80104190 <yield>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104197:	68 20 54 11 80       	push   $0x80115420
8010419c:	e8 6f 19 00 00       	call   80105b10 <acquire>
  pushcli();
801041a1:	e8 9a 18 00 00       	call   80105a40 <pushcli>
  c = mycpu();
801041a6:	e8 f5 f9 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801041ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b1:	e8 ca 18 00 00       	call   80105a80 <popcli>
  myproc()->state = RUNNABLE;
801041b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041bd:	e8 de fd ff ff       	call   80103fa0 <sched>
  release(&ptable.lock);
801041c2:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
801041c9:	e8 02 1a 00 00       	call   80105bd0 <release>
}
801041ce:	83 c4 10             	add    $0x10,%esp
801041d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <sleep>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 0c             	sub    $0xc,%esp
801041e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041ef:	e8 4c 18 00 00       	call   80105a40 <pushcli>
  c = mycpu();
801041f4:	e8 a7 f9 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801041f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041ff:	e8 7c 18 00 00       	call   80105a80 <popcli>
  if(p == 0)
80104204:	85 db                	test   %ebx,%ebx
80104206:	0f 84 87 00 00 00    	je     80104293 <sleep+0xb3>
  if(lk == 0)
8010420c:	85 f6                	test   %esi,%esi
8010420e:	74 76                	je     80104286 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104210:	81 fe 20 54 11 80    	cmp    $0x80115420,%esi
80104216:	74 50                	je     80104268 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	68 20 54 11 80       	push   $0x80115420
80104220:	e8 eb 18 00 00       	call   80105b10 <acquire>
    release(lk);
80104225:	89 34 24             	mov    %esi,(%esp)
80104228:	e8 a3 19 00 00       	call   80105bd0 <release>
  p->chan = chan;
8010422d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104230:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104237:	e8 64 fd ff ff       	call   80103fa0 <sched>
  p->chan = 0;
8010423c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104243:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
8010424a:	e8 81 19 00 00       	call   80105bd0 <release>
    acquire(lk);
8010424f:	89 75 08             	mov    %esi,0x8(%ebp)
80104252:	83 c4 10             	add    $0x10,%esp
}
80104255:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104258:	5b                   	pop    %ebx
80104259:	5e                   	pop    %esi
8010425a:	5f                   	pop    %edi
8010425b:	5d                   	pop    %ebp
    acquire(lk);
8010425c:	e9 af 18 00 00       	jmp    80105b10 <acquire>
80104261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104268:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010426b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104272:	e8 29 fd ff ff       	call   80103fa0 <sched>
  p->chan = 0;
80104277:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010427e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104281:	5b                   	pop    %ebx
80104282:	5e                   	pop    %esi
80104283:	5f                   	pop    %edi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
    panic("sleep without lk");
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	68 8f 8c 10 80       	push   $0x80108c8f
8010428e:	e8 fd c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104293:	83 ec 0c             	sub    $0xc,%esp
80104296:	68 89 8c 10 80       	push   $0x80108c89
8010429b:	e8 f0 c0 ff ff       	call   80100390 <panic>

801042a0 <wait>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
801042a4:	53                   	push   %ebx
  pushcli();
801042a5:	e8 96 17 00 00       	call   80105a40 <pushcli>
  c = mycpu();
801042aa:	e8 f1 f8 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801042af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042b5:	e8 c6 17 00 00       	call   80105a80 <popcli>
  acquire(&ptable.lock);
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	68 20 54 11 80       	push   $0x80115420
801042c2:	e8 49 18 00 00       	call   80105b10 <acquire>
801042c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042cc:	bb 54 54 11 80       	mov    $0x80115454,%ebx
801042d1:	eb 10                	jmp    801042e3 <wait+0x43>
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d8:	83 c3 7c             	add    $0x7c,%ebx
801042db:	81 fb 54 73 11 80    	cmp    $0x80117354,%ebx
801042e1:	73 1b                	jae    801042fe <wait+0x5e>
      if(p->parent != curproc)
801042e3:	39 73 14             	cmp    %esi,0x14(%ebx)
801042e6:	75 f0                	jne    801042d8 <wait+0x38>
      if(p->state == ZOMBIE){
801042e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042ec:	74 32                	je     80104320 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801042f1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f6:	81 fb 54 73 11 80    	cmp    $0x80117354,%ebx
801042fc:	72 e5                	jb     801042e3 <wait+0x43>
    if(!havekids || curproc->killed){
801042fe:	85 c0                	test   %eax,%eax
80104300:	74 74                	je     80104376 <wait+0xd6>
80104302:	8b 46 24             	mov    0x24(%esi),%eax
80104305:	85 c0                	test   %eax,%eax
80104307:	75 6d                	jne    80104376 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104309:	83 ec 08             	sub    $0x8,%esp
8010430c:	68 20 54 11 80       	push   $0x80115420
80104311:	56                   	push   %esi
80104312:	e8 c9 fe ff ff       	call   801041e0 <sleep>
    havekids = 0;
80104317:	83 c4 10             	add    $0x10,%esp
8010431a:	eb ae                	jmp    801042ca <wait+0x2a>
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104326:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104329:	e8 32 e4 ff ff       	call   80102760 <kfree>
        freevm(p->pgdir);
8010432e:	5a                   	pop    %edx
8010432f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104332:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104339:	e8 42 40 00 00       	call   80108380 <freevm>
        release(&ptable.lock);
8010433e:	c7 04 24 20 54 11 80 	movl   $0x80115420,(%esp)
        p->pid = 0;
80104345:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010434c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104353:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104357:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010435e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104365:	e8 66 18 00 00       	call   80105bd0 <release>
        return pid;
8010436a:	83 c4 10             	add    $0x10,%esp
}
8010436d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104370:	89 f0                	mov    %esi,%eax
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    
      release(&ptable.lock);
80104376:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104379:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010437e:	68 20 54 11 80       	push   $0x80115420
80104383:	e8 48 18 00 00       	call   80105bd0 <release>
      return -1;
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	eb e0                	jmp    8010436d <wait+0xcd>
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010439a:	68 20 54 11 80       	push   $0x80115420
8010439f:	e8 6c 17 00 00       	call   80105b10 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a7:	b8 54 54 11 80       	mov    $0x80115454,%eax
801043ac:	eb 0c                	jmp    801043ba <wakeup+0x2a>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 c0 7c             	add    $0x7c,%eax
801043b3:	3d 54 73 11 80       	cmp    $0x80117354,%eax
801043b8:	73 1c                	jae    801043d6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801043ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043be:	75 f0                	jne    801043b0 <wakeup+0x20>
801043c0:	3b 58 20             	cmp    0x20(%eax),%ebx
801043c3:	75 eb                	jne    801043b0 <wakeup+0x20>
      p->state = RUNNABLE;
801043c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043cc:	83 c0 7c             	add    $0x7c,%eax
801043cf:	3d 54 73 11 80       	cmp    $0x80117354,%eax
801043d4:	72 e4                	jb     801043ba <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043d6:	c7 45 08 20 54 11 80 	movl   $0x80115420,0x8(%ebp)
}
801043dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e0:	c9                   	leave  
  release(&ptable.lock);
801043e1:	e9 ea 17 00 00       	jmp    80105bd0 <release>
801043e6:	8d 76 00             	lea    0x0(%esi),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 10             	sub    $0x10,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043fa:	68 20 54 11 80       	push   $0x80115420
801043ff:	e8 0c 17 00 00       	call   80105b10 <acquire>
80104404:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104407:	b8 54 54 11 80       	mov    $0x80115454,%eax
8010440c:	eb 0c                	jmp    8010441a <kill+0x2a>
8010440e:	66 90                	xchg   %ax,%ax
80104410:	83 c0 7c             	add    $0x7c,%eax
80104413:	3d 54 73 11 80       	cmp    $0x80117354,%eax
80104418:	73 36                	jae    80104450 <kill+0x60>
    if(p->pid == pid){
8010441a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010441d:	75 f1                	jne    80104410 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010441f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104423:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010442a:	75 07                	jne    80104433 <kill+0x43>
        p->state = RUNNABLE;
8010442c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	68 20 54 11 80       	push   $0x80115420
8010443b:	e8 90 17 00 00       	call   80105bd0 <release>
      return 0;
80104440:	83 c4 10             	add    $0x10,%esp
80104443:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104448:	c9                   	leave  
80104449:	c3                   	ret    
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	68 20 54 11 80       	push   $0x80115420
80104458:	e8 73 17 00 00       	call   80105bd0 <release>
  return -1;
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104468:	c9                   	leave  
80104469:	c3                   	ret    
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104470 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104479:	bb 54 54 11 80       	mov    $0x80115454,%ebx
{
8010447e:	83 ec 3c             	sub    $0x3c,%esp
80104481:	eb 24                	jmp    801044a7 <procdump+0x37>
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	68 53 92 10 80       	push   $0x80109253
80104490:	e8 cb c1 ff ff       	call   80100660 <cprintf>
80104495:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104498:	83 c3 7c             	add    $0x7c,%ebx
8010449b:	81 fb 54 73 11 80    	cmp    $0x80117354,%ebx
801044a1:	0f 83 81 00 00 00    	jae    80104528 <procdump+0xb8>
    if(p->state == UNUSED)
801044a7:	8b 43 0c             	mov    0xc(%ebx),%eax
801044aa:	85 c0                	test   %eax,%eax
801044ac:	74 ea                	je     80104498 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044ae:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801044b1:	ba a0 8c 10 80       	mov    $0x80108ca0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044b6:	77 11                	ja     801044c9 <procdump+0x59>
801044b8:	8b 14 85 10 8d 10 80 	mov    -0x7fef72f0(,%eax,4),%edx
      state = "???";
801044bf:	b8 a0 8c 10 80       	mov    $0x80108ca0,%eax
801044c4:	85 d2                	test   %edx,%edx
801044c6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044cc:	50                   	push   %eax
801044cd:	52                   	push   %edx
801044ce:	ff 73 10             	pushl  0x10(%ebx)
801044d1:	68 a4 8c 10 80       	push   $0x80108ca4
801044d6:	e8 85 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044db:	83 c4 10             	add    $0x10,%esp
801044de:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044e2:	75 a4                	jne    80104488 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044e4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044e7:	83 ec 08             	sub    $0x8,%esp
801044ea:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044ed:	50                   	push   %eax
801044ee:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044f1:	8b 40 0c             	mov    0xc(%eax),%eax
801044f4:	83 c0 08             	add    $0x8,%eax
801044f7:	50                   	push   %eax
801044f8:	e8 f3 14 00 00       	call   801059f0 <getcallerpcs>
801044fd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104500:	8b 17                	mov    (%edi),%edx
80104502:	85 d2                	test   %edx,%edx
80104504:	74 82                	je     80104488 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104506:	83 ec 08             	sub    $0x8,%esp
80104509:	83 c7 04             	add    $0x4,%edi
8010450c:	52                   	push   %edx
8010450d:	68 e1 86 10 80       	push   $0x801086e1
80104512:	e8 49 c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104517:	83 c4 10             	add    $0x10,%esp
8010451a:	39 fe                	cmp    %edi,%esi
8010451c:	75 e2                	jne    80104500 <procdump+0x90>
8010451e:	e9 65 ff ff ff       	jmp    80104488 <procdump+0x18>
80104523:	90                   	nop
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010452b:	5b                   	pop    %ebx
8010452c:	5e                   	pop    %esi
8010452d:	5f                   	pop    %edi
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    

80104530 <find_proc_by_pid>:

struct proc* find_proc_by_pid(int pid) {
80104530:	55                   	push   %ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104531:	b8 54 54 11 80       	mov    $0x80115454,%eax
struct proc* find_proc_by_pid(int pid) {
80104536:	89 e5                	mov    %esp,%ebp
80104538:	83 ec 08             	sub    $0x8,%esp
8010453b:	8b 55 08             	mov    0x8(%ebp),%edx
8010453e:	eb 0a                	jmp    8010454a <find_proc_by_pid+0x1a>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104540:	83 c0 7c             	add    $0x7c,%eax
80104543:	3d 54 73 11 80       	cmp    $0x80117354,%eax
80104548:	73 0e                	jae    80104558 <find_proc_by_pid+0x28>
    if (p->pid == pid)
8010454a:	39 50 10             	cmp    %edx,0x10(%eax)
8010454d:	75 f1                	jne    80104540 <find_proc_by_pid+0x10>
      return p;
  }
  panic("didn't find pid");
}
8010454f:	c9                   	leave  
80104550:	c3                   	ret    
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  panic("didn't find pid");
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 ad 8c 10 80       	push   $0x80108cad
80104560:	e8 2b be ff ff       	call   80100390 <panic>
80104565:	66 90                	xchg   %ax,%ax
80104567:	66 90                	xchg   %ax,%ax
80104569:	66 90                	xchg   %ax,%ax
8010456b:	66 90                	xchg   %ax,%ax
8010456d:	66 90                	xchg   %ax,%ax
8010456f:	90                   	nop

80104570 <procfsisdir>:

struct dirent inodeinfo_dir_entries[NINODE+2];

int 
procfsisdir(struct inode *ip) 
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
  //cprintf("in func procfsisdir: ip->minor=%d ip->inum=%d\n", ip->minor, ip->inum);
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501)))
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
		return 1;
	else 
    return 0;
}
80104576:	5d                   	pop    %ebp
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501)))
80104577:	66 83 78 54 01       	cmpw   $0x1,0x54(%eax)
8010457c:	0f 96 c0             	setbe  %al
8010457f:	0f b6 c0             	movzbl %al,%eax
}
80104582:	c3                   	ret    
80104583:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <procfsiread>:

void 
procfsiread(struct inode* dp, struct inode *ip) 
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	8b 45 0c             	mov    0xc(%ebp),%eax
80104597:	8b 4d 08             	mov    0x8(%ebp),%ecx
  //cprintf("in func PROCFSIREAD, ip->inum= %d, dp->inum = %d \n",ip->inum,dp->inum);
  if (ip->inum < 500) 
8010459a:	8b 50 04             	mov    0x4(%eax),%edx
8010459d:	81 fa f3 01 00 00    	cmp    $0x1f3,%edx
801045a3:	76 39                	jbe    801045de <procfsiread+0x4e>
		return;

	ip->major = PROCFS;
	ip->size = 0;
	ip->nlink = 1;
801045a5:	bb 01 00 00 00       	mov    $0x1,%ebx
	ip->size = 0;
801045aa:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
	ip->type = T_DEV;
	ip->valid = 1;
801045b1:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
	ip->nlink = 1;
801045b8:	66 89 58 56          	mov    %bx,0x56(%eax)
	ip->valid = 1;
801045bc:	c7 40 50 03 00 02 00 	movl   $0x20003,0x50(%eax)
	ip->minor = dp->minor + 1;
801045c3:	0f b7 59 54          	movzwl 0x54(%ecx),%ebx
801045c7:	83 c3 01             	add    $0x1,%ebx
801045ca:	66 89 58 54          	mov    %bx,0x54(%eax)

	if (dp->inum < ip->inum)
801045ce:	3b 51 04             	cmp    0x4(%ecx),%edx
801045d1:	76 0b                	jbe    801045de <procfsiread+0x4e>
		ip->minor = dp->minor + 1;
801045d3:	0f b7 51 54          	movzwl 0x54(%ecx),%edx
801045d7:	83 c2 01             	add    $0x1,%edx
801045da:	66 89 50 54          	mov    %dx,0x54(%eax)
	else if (dp->inum < ip->inum)
		ip->minor = dp->minor - 1;
}
801045de:	5b                   	pop    %ebx
801045df:	5d                   	pop    %ebp
801045e0:	c3                   	ret    
801045e1:	eb 0d                	jmp    801045f0 <procfswrite>
801045e3:	90                   	nop
801045e4:	90                   	nop
801045e5:	90                   	nop
801045e6:	90                   	nop
801045e7:	90                   	nop
801045e8:	90                   	nop
801045e9:	90                   	nop
801045ea:	90                   	nop
801045eb:	90                   	nop
801045ec:	90                   	nop
801045ed:	90                   	nop
801045ee:	90                   	nop
801045ef:	90                   	nop

801045f0 <procfswrite>:
  }
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
801045f0:	55                   	push   %ebp
  return 0;
}
801045f1:	31 c0                	xor    %eax,%eax
{
801045f3:	89 e5                	mov    %esp,%ebp
}
801045f5:	5d                   	pop    %ebp
801045f6:	c3                   	ret    
801045f7:	89 f6                	mov    %esi,%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <procfsinit>:

void
procfsinit(void)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	83 ec 0c             	sub    $0xc,%esp
  devsw[PROCFS].isdir = procfsisdir;
80104606:	c7 05 40 30 11 80 70 	movl   $0x80104570,0x80113040
8010460d:	45 10 80 
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;

  memset(&process_entries, sizeof(process_entries), 0);
80104610:	6a 00                	push   $0x0
80104612:	68 00 02 00 00       	push   $0x200
80104617:	68 e0 76 11 80       	push   $0x801176e0
  devsw[PROCFS].iread = procfsiread;
8010461c:	c7 05 44 30 11 80 90 	movl   $0x80104590,0x80113044
80104623:	45 10 80 
  devsw[PROCFS].write = procfswrite;
80104626:	c7 05 4c 30 11 80 f0 	movl   $0x801045f0,0x8011304c
8010462d:	45 10 80 
  devsw[PROCFS].read = procfsread;
80104630:	c7 05 48 30 11 80 30 	movl   $0x80105830,0x80113048
80104637:	58 10 80 
  memset(&process_entries, sizeof(process_entries), 0);
8010463a:	e8 e1 15 00 00       	call   80105c20 <memset>
  memmove(subdir_entries[0].name, ".", 2);
8010463f:	83 c4 0c             	add    $0xc,%esp
80104642:	6a 02                	push   $0x2
80104644:	68 29 8d 10 80       	push   $0x80108d29
80104649:	68 62 73 11 80       	push   $0x80117362
8010464e:	e8 7d 16 00 00       	call   80105cd0 <memmove>
  memmove(subdir_entries[1].name, "..", 3);
80104653:	83 c4 0c             	add    $0xc,%esp
80104656:	6a 03                	push   $0x3
80104658:	68 28 8d 10 80       	push   $0x80108d28
8010465d:	68 72 73 11 80       	push   $0x80117372
80104662:	e8 69 16 00 00       	call   80105cd0 <memmove>
  memmove(subdir_entries[2].name, "name", 5);
80104667:	83 c4 0c             	add    $0xc,%esp
8010466a:	6a 05                	push   $0x5
8010466c:	68 2b 8d 10 80       	push   $0x80108d2b
80104671:	68 82 73 11 80       	push   $0x80117382
80104676:	e8 55 16 00 00       	call   80105cd0 <memmove>
  memmove(subdir_entries[3].name, "status", 7);
8010467b:	83 c4 0c             	add    $0xc,%esp
8010467e:	6a 07                	push   $0x7
80104680:	68 30 8d 10 80       	push   $0x80108d30
80104685:	68 92 73 11 80       	push   $0x80117392
8010468a:	e8 41 16 00 00       	call   80105cd0 <memmove>
  subdir_entries[0].inum = 2;
8010468f:	b8 02 00 00 00       	mov    $0x2,%eax
  subdir_entries[1].inum = 1;
80104694:	ba 01 00 00 00       	mov    $0x1,%edx
  subdir_entries[2].inum = 0; // temporary init- 
80104699:	31 c9                	xor    %ecx,%ecx
  subdir_entries[0].inum = 2;
8010469b:	66 a3 60 73 11 80    	mov    %ax,0x80117360
  subdir_entries[3].inum = 0; // will be initialized in read_procfs_pid_dir
801046a1:	31 c0                	xor    %eax,%eax
  subdir_entries[1].inum = 1;
801046a3:	66 89 15 70 73 11 80 	mov    %dx,0x80117370
  subdir_entries[2].inum = 0; // temporary init- 
801046aa:	66 89 0d 80 73 11 80 	mov    %cx,0x80117380
  subdir_entries[3].inum = 0; // will be initialized in read_procfs_pid_dir
801046b1:	66 a3 90 73 11 80    	mov    %ax,0x80117390
}
801046b7:	83 c4 10             	add    $0x10,%esp
801046ba:	c9                   	leave  
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <read_procfs_pid_dir>:
  return n;
}

int 
read_procfs_pid_dir(struct inode* ip, char *dst, int off, int n) 
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	56                   	push   %esi
801046c5:	53                   	push   %ebx
  //cprintf("in func read_procfs_pid_dir, ip->inum=%d \n",ip->inum);
  struct dirent temp_entries[4];
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801046c6:	8d 7d a8             	lea    -0x58(%ebp),%edi

	temp_entries[2].inum = ip->inum + 100;
	temp_entries[3].inum = ip->inum + 200;

	if (off + n > sizeof(temp_entries))
		n = sizeof(temp_entries) - off;
801046c9:	bb 40 00 00 00       	mov    $0x40,%ebx
{
801046ce:	83 ec 50             	sub    $0x50,%esp
801046d1:	8b 75 10             	mov    0x10(%ebp),%esi
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801046d4:	6a 40                	push   $0x40
801046d6:	68 60 73 11 80       	push   $0x80117360
801046db:	57                   	push   %edi
		n = sizeof(temp_entries) - off;
801046dc:	29 f3                	sub    %esi,%ebx
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
801046de:	e8 ed 15 00 00       	call   80105cd0 <memmove>
	temp_entries[2].inum = ip->inum + 100;
801046e3:	8b 45 08             	mov    0x8(%ebp),%eax
	if (off + n > sizeof(temp_entries))
801046e6:	83 c4 0c             	add    $0xc,%esp
	temp_entries[2].inum = ip->inum + 100;
801046e9:	8b 40 04             	mov    0x4(%eax),%eax
801046ec:	8d 48 64             	lea    0x64(%eax),%ecx
	temp_entries[3].inum = ip->inum + 200;
801046ef:	66 05 c8 00          	add    $0xc8,%ax
801046f3:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	if (off + n > sizeof(temp_entries))
801046f7:	8b 45 14             	mov    0x14(%ebp),%eax
	temp_entries[2].inum = ip->inum + 100;
801046fa:	66 89 4d c8          	mov    %cx,-0x38(%ebp)
	if (off + n > sizeof(temp_entries))
801046fe:	01 f0                	add    %esi,%eax
		n = sizeof(temp_entries) - off;
80104700:	83 f8 40             	cmp    $0x40,%eax
80104703:	0f 46 5d 14          	cmovbe 0x14(%ebp),%ebx
	memmove(dst, (char*)(&temp_entries) + off, n);
80104707:	01 fe                	add    %edi,%esi
80104709:	53                   	push   %ebx
8010470a:	56                   	push   %esi
8010470b:	ff 75 0c             	pushl  0xc(%ebp)
8010470e:	e8 bd 15 00 00       	call   80105cd0 <memmove>
	return n;
}
80104713:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104716:	89 d8                	mov    %ebx,%eax
80104718:	5b                   	pop    %ebx
80104719:	5e                   	pop    %esi
8010471a:	5f                   	pop    %edi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
8010471d:	8d 76 00             	lea    0x0(%esi),%esi

80104720 <read_procfs_status>:
  }
}

int 
read_procfs_status(struct inode* ip, char *dst, int off, int n) 
{
80104720:	55                   	push   %ebp
  //cprintf("in func read_procfs_status, ip->inum=%d \n",ip->inum);
	char status[250] = {0};
80104721:	31 c0                	xor    %eax,%eax
{
80104723:	89 e5                	mov    %esp,%ebp
80104725:	57                   	push   %edi
80104726:	56                   	push   %esi
	char status[250] = {0};
80104727:	8d b5 ee fe ff ff    	lea    -0x112(%ebp),%esi
8010472d:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
{
80104733:	53                   	push   %ebx
	char status[250] = {0};
80104734:	89 f1                	mov    %esi,%ecx
{
80104736:	81 ec 38 01 00 00    	sub    $0x138,%esp
	char status[250] = {0};
8010473c:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80104743:	00 00 00 
80104746:	29 f9                	sub    %edi,%ecx
80104748:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
{
8010474f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char status[250] = {0};
80104752:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
80104758:	c1 e9 02             	shr    $0x2,%ecx
8010475b:	f3 ab                	rep stos %eax,%es:(%edi)
	//char szBuf[100] = {0};
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
8010475d:	c7 85 d4 fe ff ff 37 	movl   $0x80108d37,-0x12c(%ebp)
80104764:	8d 10 80 
80104767:	c7 85 d8 fe ff ff 3e 	movl   $0x80108d3e,-0x128(%ebp)
8010476e:	8d 10 80 
80104771:	c7 85 dc fe ff ff 45 	movl   $0x80108d45,-0x124(%ebp)
80104778:	8d 10 80 
8010477b:	c7 85 e0 fe ff ff 4e 	movl   $0x80108d4e,-0x120(%ebp)
80104782:	8d 10 80 

	int pid = ip->inum - 800;
80104785:	8b 45 08             	mov    0x8(%ebp),%eax
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
80104788:	c7 85 e4 fe ff ff 57 	movl   $0x80108d57,-0x11c(%ebp)
8010478f:	8d 10 80 
80104792:	c7 85 e8 fe ff ff 5f 	movl   $0x80108d5f,-0x118(%ebp)
80104799:	8d 10 80 
	int pid = ip->inum - 800;
8010479c:	8b 40 04             	mov    0x4(%eax),%eax
8010479f:	2d 20 03 00 00       	sub    $0x320,%eax
  struct proc *p = find_proc_by_pid(pid);
801047a4:	50                   	push   %eax
801047a5:	e8 86 fd ff ff       	call   80104530 <find_proc_by_pid>
801047aa:	89 c7                	mov    %eax,%edi

  int size = strlen(procstate[p->state]);
801047ac:	58                   	pop    %eax
801047ad:	8b 47 0c             	mov    0xc(%edi),%eax
801047b0:	ff b4 85 d4 fe ff ff 	pushl  -0x12c(%ebp,%eax,4)
801047b7:	e8 84 16 00 00       	call   80105e40 <strlen>
  strcpy(status, procstate[p->state]);
801047bc:	8b 57 0c             	mov    0xc(%edi),%edx
801047bf:	83 c4 10             	add    $0x10,%esp
801047c2:	8b bc 95 d4 fe ff ff 	mov    -0x12c(%ebp,%edx,4),%edi
801047c9:	31 d2                	xor    %edx,%edx
801047cb:	90                   	nop
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
801047d0:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
801047d4:	88 0c 16             	mov    %cl,(%esi,%edx,1)
801047d7:	83 c2 01             	add    $0x1,%edx
801047da:	84 c9                	test   %cl,%cl
801047dc:	75 f2                	jne    801047d0 <read_procfs_status+0xb0>
  status[strlen(status)] = '\n';
801047de:	83 ec 0c             	sub    $0xc,%esp
  status[size] = ' ';
801047e1:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
801047e8:	20 
  status[strlen(status)] = '\n';
801047e9:	56                   	push   %esi
801047ea:	e8 51 16 00 00       	call   80105e40 <strlen>
  int status_size = strlen(status);
801047ef:	89 34 24             	mov    %esi,(%esp)
  status[strlen(status)] = '\n';
801047f2:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
801047f9:	0a 
  int status_size = strlen(status);
801047fa:	e8 41 16 00 00       	call   80105e40 <strlen>
  if (off + n > status_size)
801047ff:	8b 55 14             	mov    0x14(%ebp),%edx
    n = status_size - off;
80104802:	89 c7                	mov    %eax,%edi
  if (off + n > status_size)
80104804:	83 c4 0c             	add    $0xc,%esp
    n = status_size - off;
80104807:	29 df                	sub    %ebx,%edi
  if (off + n > status_size)
80104809:	01 da                	add    %ebx,%edx
    n = status_size - off;
8010480b:	39 c2                	cmp    %eax,%edx
8010480d:	0f 4e 7d 14          	cmovle 0x14(%ebp),%edi
  memmove(dst, (char*)(&status) + off, n);
80104811:	01 f3                	add    %esi,%ebx
80104813:	57                   	push   %edi
80104814:	53                   	push   %ebx
80104815:	ff 75 0c             	pushl  0xc(%ebp)
80104818:	e8 b3 14 00 00       	call   80105cd0 <memmove>
}
8010481d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104820:	89 f8                	mov    %edi,%eax
80104822:	5b                   	pop    %ebx
80104823:	5e                   	pop    %esi
80104824:	5f                   	pop    %edi
80104825:	5d                   	pop    %ebp
80104826:	c3                   	ret    
80104827:	89 f6                	mov    %esi,%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <read_procfs_name>:
{
80104830:	55                   	push   %ebp
	char name[250] = {0};
80104831:	31 c0                	xor    %eax,%eax
{
80104833:	89 e5                	mov    %esp,%ebp
80104835:	57                   	push   %edi
80104836:	56                   	push   %esi
	char name[250] = {0};
80104837:	8d b5 ee fe ff ff    	lea    -0x112(%ebp),%esi
8010483d:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
{
80104843:	53                   	push   %ebx
	char name[250] = {0};
80104844:	89 f1                	mov    %esi,%ecx
{
80104846:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char name[250] = {0};
8010484c:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80104853:	00 00 00 
80104856:	29 f9                	sub    %edi,%ecx
80104858:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
{
8010485f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char name[250] = {0};
80104862:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
80104868:	c1 e9 02             	shr    $0x2,%ecx
8010486b:	f3 ab                	rep stos %eax,%es:(%edi)
	int pid = ip->inum - 700;
8010486d:	8b 45 08             	mov    0x8(%ebp),%eax
80104870:	8b 40 04             	mov    0x4(%eax),%eax
80104873:	2d bc 02 00 00       	sub    $0x2bc,%eax
  struct proc *p = find_proc_by_pid(pid);
80104878:	50                   	push   %eax
80104879:	e8 b2 fc ff ff       	call   80104530 <find_proc_by_pid>
  int size = strlen(p->name);
8010487e:	8d 78 6c             	lea    0x6c(%eax),%edi
80104881:	89 3c 24             	mov    %edi,(%esp)
80104884:	e8 b7 15 00 00       	call   80105e40 <strlen>
80104889:	83 c4 10             	add    $0x10,%esp
8010488c:	31 d2                	xor    %edx,%edx
8010488e:	66 90                	xchg   %ax,%ax
  while((*s++ = *t++) != 0)
80104890:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
80104894:	88 0c 16             	mov    %cl,(%esi,%edx,1)
80104897:	83 c2 01             	add    $0x1,%edx
8010489a:	84 c9                	test   %cl,%cl
8010489c:	75 f2                	jne    80104890 <read_procfs_name+0x60>
  name[strlen(name)] = '\n';
8010489e:	83 ec 0c             	sub    $0xc,%esp
  name[size] = ' ';
801048a1:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
801048a8:	20 
  name[strlen(name)] = '\n';
801048a9:	56                   	push   %esi
801048aa:	e8 91 15 00 00       	call   80105e40 <strlen>
  int name_size = strlen(name);
801048af:	89 34 24             	mov    %esi,(%esp)
  name[strlen(name)] = '\n';
801048b2:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
801048b9:	0a 
  int name_size = strlen(name);
801048ba:	e8 81 15 00 00       	call   80105e40 <strlen>
  if (off + n > name_size)
801048bf:	8b 55 14             	mov    0x14(%ebp),%edx
    n = name_size - off;
801048c2:	89 c7                	mov    %eax,%edi
  if (off + n > name_size)
801048c4:	83 c4 0c             	add    $0xc,%esp
    n = name_size - off;
801048c7:	29 df                	sub    %ebx,%edi
  if (off + n > name_size)
801048c9:	01 da                	add    %ebx,%edx
    n = name_size - off;
801048cb:	39 c2                	cmp    %eax,%edx
801048cd:	0f 4e 7d 14          	cmovle 0x14(%ebp),%edi
  memmove(dst, (char*)(&name) + off, n);
801048d1:	01 f3                	add    %esi,%ebx
801048d3:	57                   	push   %edi
801048d4:	53                   	push   %ebx
801048d5:	ff 75 0c             	pushl  0xc(%ebp)
801048d8:	e8 f3 13 00 00       	call   80105cd0 <memmove>
}
801048dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048e0:	89 f8                	mov    %edi,%eax
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5f                   	pop    %edi
801048e5:	5d                   	pop    %ebp
801048e6:	c3                   	ret    
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <procfs_add_proc>:
{
801048f0:	55                   	push   %ebp
	for (int i = 0; i < NPROC; i++) {
801048f1:	31 c0                	xor    %eax,%eax
{
801048f3:	89 e5                	mov    %esp,%ebp
801048f5:	83 ec 08             	sub    $0x8,%esp
801048f8:	eb 0e                	jmp    80104908 <procfs_add_proc+0x18>
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (int i = 0; i < NPROC; i++) {
80104900:	83 c0 01             	add    $0x1,%eax
80104903:	83 f8 40             	cmp    $0x40,%eax
80104906:	74 28                	je     80104930 <procfs_add_proc+0x40>
		if (!process_entries[i].used) {
80104908:	8b 14 c5 e4 76 11 80 	mov    -0x7fee891c(,%eax,8),%edx
8010490f:	85 d2                	test   %edx,%edx
80104911:	75 ed                	jne    80104900 <procfs_add_proc+0x10>
			process_entries[i].pid = pid;
80104913:	8b 55 08             	mov    0x8(%ebp),%edx
			process_entries[i].used = 1;
80104916:	c7 04 c5 e4 76 11 80 	movl   $0x1,-0x7fee891c(,%eax,8)
8010491d:	01 00 00 00 
			process_entries[i].pid = pid;
80104921:	89 14 c5 e0 76 11 80 	mov    %edx,-0x7fee8920(,%eax,8)
}
80104928:	c9                   	leave  
80104929:	c3                   	ret    
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	panic("Too many processes in procfs!");
80104930:	83 ec 0c             	sub    $0xc,%esp
80104933:	68 66 8d 10 80       	push   $0x80108d66
80104938:	e8 53 ba ff ff       	call   80100390 <panic>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <procfs_remove_proc>:
{
80104940:	55                   	push   %ebp
	for (i = 0; i < NPROC; i++) {
80104941:	31 c0                	xor    %eax,%eax
{
80104943:	89 e5                	mov    %esp,%ebp
80104945:	83 ec 08             	sub    $0x8,%esp
80104948:	8b 55 08             	mov    0x8(%ebp),%edx
8010494b:	eb 0b                	jmp    80104958 <procfs_remove_proc+0x18>
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < NPROC; i++) {
80104950:	83 c0 01             	add    $0x1,%eax
80104953:	83 f8 40             	cmp    $0x40,%eax
80104956:	74 30                	je     80104988 <procfs_remove_proc+0x48>
		if (process_entries[i].used && process_entries[i].pid == pid) {
80104958:	8b 0c c5 e4 76 11 80 	mov    -0x7fee891c(,%eax,8),%ecx
8010495f:	85 c9                	test   %ecx,%ecx
80104961:	74 ed                	je     80104950 <procfs_remove_proc+0x10>
80104963:	39 14 c5 e0 76 11 80 	cmp    %edx,-0x7fee8920(,%eax,8)
8010496a:	75 e4                	jne    80104950 <procfs_remove_proc+0x10>
			process_entries[i].used = process_entries[i].pid = 0;
8010496c:	c7 04 c5 e0 76 11 80 	movl   $0x0,-0x7fee8920(,%eax,8)
80104973:	00 00 00 00 
80104977:	c7 04 c5 e4 76 11 80 	movl   $0x0,-0x7fee891c(,%eax,8)
8010497e:	00 00 00 00 
}
80104982:	c9                   	leave  
80104983:	c3                   	ret    
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	panic("Failed to find process in procfs_remove_proc!");
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	68 08 8f 10 80       	push   $0x80108f08
80104990:	e8 fb b9 ff ff       	call   80100390 <panic>
80104995:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <procfs_add_inode>:
{
801049a0:	55                   	push   %ebp
801049a1:	b8 00 7d 11 80       	mov    $0x80117d00,%eax
801049a6:	89 e5                	mov    %esp,%ebp
801049a8:	83 ec 08             	sub    $0x8,%esp
801049ab:	8b 55 08             	mov    0x8(%ebp),%edx
801049ae:	eb 0a                	jmp    801049ba <procfs_add_inode+0x1a>
801049b0:	83 c0 08             	add    $0x8,%eax
  for (int i = 0; i < NINODE; i++) {
801049b3:	3d 90 7e 11 80       	cmp    $0x80117e90,%eax
801049b8:	74 06                	je     801049c0 <procfs_add_inode+0x20>
		if (inode_entries[i].inode == inode) {
801049ba:	39 10                	cmp    %edx,(%eax)
801049bc:	75 f2                	jne    801049b0 <procfs_add_inode+0x10>
}
801049be:	c9                   	leave  
801049bf:	c3                   	ret    
		if (!inode_entries[i].used) {
801049c0:	a1 04 7d 11 80       	mov    0x80117d04,%eax
801049c5:	85 c0                	test   %eax,%eax
801049c7:	74 1a                	je     801049e3 <procfs_add_inode+0x43>
	for (int i = 0; i < NINODE; i++) {
801049c9:	b8 01 00 00 00       	mov    $0x1,%eax
801049ce:	eb 08                	jmp    801049d8 <procfs_add_inode+0x38>
801049d0:	83 c0 01             	add    $0x1,%eax
801049d3:	83 f8 32             	cmp    $0x32,%eax
801049d6:	74 28                	je     80104a00 <procfs_add_inode+0x60>
		if (!inode_entries[i].used) {
801049d8:	8b 0c c5 04 7d 11 80 	mov    -0x7fee82fc(,%eax,8),%ecx
801049df:	85 c9                	test   %ecx,%ecx
801049e1:	75 ed                	jne    801049d0 <procfs_add_inode+0x30>
      inode_entries[i].used = 1;
801049e3:	c7 04 c5 04 7d 11 80 	movl   $0x1,-0x7fee82fc(,%eax,8)
801049ea:	01 00 00 00 
			inode_entries[i].inode = inode;
801049ee:	89 14 c5 00 7d 11 80 	mov    %edx,-0x7fee8300(,%eax,8)
}
801049f5:	c9                   	leave  
801049f6:	c3                   	ret    
801049f7:	89 f6                	mov    %esi,%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	panic("Too many inodes in procfs!");
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	68 84 8d 10 80       	push   $0x80108d84
80104a08:	e8 83 b9 ff ff       	call   80100390 <panic>
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <procfs_remove_inode>:
{
80104a10:	55                   	push   %ebp
	for (i = 0; i < NINODE; i++) {
80104a11:	31 c0                	xor    %eax,%eax
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	83 ec 08             	sub    $0x8,%esp
80104a18:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1b:	eb 0b                	jmp    80104a28 <procfs_remove_inode+0x18>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < NINODE; i++) {
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	83 f8 32             	cmp    $0x32,%eax
80104a26:	74 30                	je     80104a58 <procfs_remove_inode+0x48>
		if (inode_entries[i].used && inode_entries[i].inode == inode) {
80104a28:	8b 0c c5 04 7d 11 80 	mov    -0x7fee82fc(,%eax,8),%ecx
80104a2f:	85 c9                	test   %ecx,%ecx
80104a31:	74 ed                	je     80104a20 <procfs_remove_inode+0x10>
80104a33:	39 14 c5 00 7d 11 80 	cmp    %edx,-0x7fee8300(,%eax,8)
80104a3a:	75 e4                	jne    80104a20 <procfs_remove_inode+0x10>
			inode_entries[i].used = 0;
80104a3c:	c7 04 c5 04 7d 11 80 	movl   $0x0,-0x7fee82fc(,%eax,8)
80104a43:	00 00 00 00 
      inode_entries[i].inode = 0;
80104a47:	c7 04 c5 00 7d 11 80 	movl   $0x0,-0x7fee8300(,%eax,8)
80104a4e:	00 00 00 00 
}
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	panic("Failed to find inode in procfs_remove_inode!");
80104a58:	83 ec 0c             	sub    $0xc,%esp
80104a5b:	68 38 8f 10 80       	push   $0x80108f38
80104a60:	e8 2b b9 ff ff       	call   80100390 <panic>
80104a65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <strcpy>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	8b 45 08             	mov    0x8(%ebp),%eax
80104a77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while((*s++ = *t++) != 0)
80104a7a:	89 c2                	mov    %eax,%edx
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a80:	83 c1 01             	add    $0x1,%ecx
80104a83:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
80104a87:	83 c2 01             	add    $0x1,%edx
80104a8a:	84 db                	test   %bl,%bl
80104a8c:	88 5a ff             	mov    %bl,-0x1(%edx)
80104a8f:	75 ef                	jne    80104a80 <strcpy+0x10>
    ;
  return os;
}
80104a91:	5b                   	pop    %ebx
80104a92:	5d                   	pop    %ebp
80104a93:	c3                   	ret    
80104a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104aa0 <atoi>:

int
atoi(const char *s)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
80104aa7:	0f be 11             	movsbl (%ecx),%edx
80104aaa:	8d 42 d0             	lea    -0x30(%edx),%eax
80104aad:	3c 09                	cmp    $0x9,%al
  n = 0;
80104aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
80104ab4:	77 1f                	ja     80104ad5 <atoi+0x35>
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
80104ac0:	8d 04 80             	lea    (%eax,%eax,4),%eax
80104ac3:	83 c1 01             	add    $0x1,%ecx
80104ac6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
80104aca:	0f be 11             	movsbl (%ecx),%edx
80104acd:	8d 5a d0             	lea    -0x30(%edx),%ebx
80104ad0:	80 fb 09             	cmp    $0x9,%bl
80104ad3:	76 eb                	jbe    80104ac0 <atoi+0x20>
  return n;
}
80104ad5:	5b                   	pop    %ebx
80104ad6:	5d                   	pop    %ebp
80104ad7:	c3                   	ret    
80104ad8:	90                   	nop
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <itoa>:

// convert int to string
void 
itoa(char s[], int n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
80104ae6:	31 ff                	xor    %edi,%edi
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104af4:	c1 f8 1f             	sar    $0x1f,%eax
80104af7:	31 c1                	xor    %eax,%ecx
80104af9:	29 c1                	sub    %eax,%ecx
80104afb:	eb 05                	jmp    80104b02 <itoa+0x22>
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
  
  if (pm < 0) {
    n = -n;          
  }
  do {       
    s[i++] = n % 10 + '0';   
80104b00:	89 f7                	mov    %esi,%edi
80104b02:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80104b07:	8d 77 01             	lea    0x1(%edi),%esi
80104b0a:	f7 e1                	mul    %ecx
80104b0c:	c1 ea 03             	shr    $0x3,%edx
80104b0f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104b12:	01 c0                	add    %eax,%eax
80104b14:	29 c1                	sub    %eax,%ecx
80104b16:	83 c1 30             	add    $0x30,%ecx
  } while ((n /= 10) > 0);
80104b19:	85 d2                	test   %edx,%edx
    s[i++] = n % 10 + '0';   
80104b1b:	88 4c 33 ff          	mov    %cl,-0x1(%ebx,%esi,1)
  } while ((n /= 10) > 0);
80104b1f:	89 d1                	mov    %edx,%ecx
80104b21:	7f dd                	jg     80104b00 <itoa+0x20>
  
  if (pm < 0) {
80104b23:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b26:	01 de                	add    %ebx,%esi
80104b28:	85 c0                	test   %eax,%eax
80104b2a:	79 07                	jns    80104b33 <itoa+0x53>
    s[i++] = '-';
80104b2c:	c6 06 2d             	movb   $0x2d,(%esi)
80104b2f:	8d 74 3b 02          	lea    0x2(%ebx,%edi,1),%esi
  }
  s[i] = '\0';
  
  //reverse
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104b33:	83 ec 0c             	sub    $0xc,%esp
  s[i] = '\0';
80104b36:	c6 06 00             	movb   $0x0,(%esi)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104b39:	53                   	push   %ebx
80104b3a:	e8 01 13 00 00       	call   80105e40 <strlen>
80104b3f:	83 e8 01             	sub    $0x1,%eax
80104b42:	83 c4 10             	add    $0x10,%esp
80104b45:	85 c0                	test   %eax,%eax
80104b47:	7e 21                	jle    80104b6a <itoa+0x8a>
80104b49:	31 d2                	xor    %edx,%edx
80104b4b:	90                   	nop
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = s[t];
80104b50:	0f b6 3c 13          	movzbl (%ebx,%edx,1),%edi
    s[t] = s[j];
80104b54:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
80104b58:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    s[j] = c;
80104b5b:	89 f9                	mov    %edi,%ecx
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104b5d:	83 c2 01             	add    $0x1,%edx
    s[j] = c;
80104b60:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104b63:	83 e8 01             	sub    $0x1,%eax
80104b66:	39 c2                	cmp    %eax,%edx
80104b68:	7c e6                	jl     80104b50 <itoa+0x70>
  }
} 
80104b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b6d:	5b                   	pop    %ebx
80104b6e:	5e                   	pop    %esi
80104b6f:	5f                   	pop    %edi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <update_dir_entries>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	56                   	push   %esi
80104b85:	53                   	push   %ebx
  dir_entries[4].inum = 502;
80104b86:	be f6 01 00 00       	mov    $0x1f6,%esi
  dir_entries[3].inum = 501;
80104b8b:	bb f5 01 00 00       	mov    $0x1f5,%ebx
{
80104b90:	83 ec 10             	sub    $0x10,%esp
	memset(dir_entries, sizeof(dir_entries), 0);
80104b93:	6a 00                	push   $0x0
80104b95:	68 20 04 00 00       	push   $0x420
80104b9a:	68 e0 78 11 80       	push   $0x801178e0
80104b9f:	e8 7c 10 00 00       	call   80105c20 <memset>
  memmove(&dir_entries[0].name, ".", 2);
80104ba4:	83 c4 0c             	add    $0xc,%esp
80104ba7:	6a 02                	push   $0x2
80104ba9:	68 29 8d 10 80       	push   $0x80108d29
80104bae:	68 e2 78 11 80       	push   $0x801178e2
80104bb3:	e8 18 11 00 00       	call   80105cd0 <memmove>
  memmove(&dir_entries[1].name, "..", 3);
80104bb8:	83 c4 0c             	add    $0xc,%esp
80104bbb:	6a 03                	push   $0x3
80104bbd:	68 28 8d 10 80       	push   $0x80108d28
80104bc2:	68 f2 78 11 80       	push   $0x801178f2
80104bc7:	e8 04 11 00 00       	call   80105cd0 <memmove>
  memmove(&dir_entries[2].name, "ideinfo", 8);
80104bcc:	83 c4 0c             	add    $0xc,%esp
80104bcf:	6a 08                	push   $0x8
80104bd1:	68 9f 8d 10 80       	push   $0x80108d9f
80104bd6:	68 02 79 11 80       	push   $0x80117902
80104bdb:	e8 f0 10 00 00       	call   80105cd0 <memmove>
  memmove(&dir_entries[3].name, "filestat", 9);
80104be0:	83 c4 0c             	add    $0xc,%esp
80104be3:	6a 09                	push   $0x9
80104be5:	68 a7 8d 10 80       	push   $0x80108da7
80104bea:	68 12 79 11 80       	push   $0x80117912
80104bef:	e8 dc 10 00 00       	call   80105cd0 <memmove>
  memmove(&dir_entries[4].name, "inodeinfo", 10);
80104bf4:	83 c4 0c             	add    $0xc,%esp
80104bf7:	6a 0a                	push   $0xa
80104bf9:	68 b0 8d 10 80       	push   $0x80108db0
80104bfe:	68 22 79 11 80       	push   $0x80117922
80104c03:	e8 c8 10 00 00       	call   80105cd0 <memmove>
  dir_entries[0].inum = inum;
80104c08:	8b 45 08             	mov    0x8(%ebp),%eax
  dir_entries[1].inum = ROOT_INUM;
80104c0b:	ba 01 00 00 00       	mov    $0x1,%edx
  dir_entries[2].inum = 500;
80104c10:	b9 f4 01 00 00       	mov    $0x1f4,%ecx
  dir_entries[3].inum = 501;
80104c15:	66 89 1d 10 79 11 80 	mov    %bx,0x80117910
  dir_entries[4].inum = 502;
80104c1c:	66 89 35 20 79 11 80 	mov    %si,0x80117920
80104c23:	bb e0 76 11 80       	mov    $0x801176e0,%ebx
  dir_entries[1].inum = ROOT_INUM;
80104c28:	66 89 15 f0 78 11 80 	mov    %dx,0x801178f0
  dir_entries[2].inum = 500;
80104c2f:	66 89 0d 00 79 11 80 	mov    %cx,0x80117900
80104c36:	83 c4 10             	add    $0x10,%esp
  dir_entries[0].inum = inum;
80104c39:	66 a3 e0 78 11 80    	mov    %ax,0x801178e0
  int j = 5;
80104c3f:	be 05 00 00 00       	mov    $0x5,%esi
80104c44:	eb 15                	jmp    80104c5b <update_dir_entries+0xdb>
80104c46:	8d 76 00             	lea    0x0(%esi),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c50:	83 c3 08             	add    $0x8,%ebx
  for (int i = 0; i < NPROC; i++) {
80104c53:	81 fb e0 78 11 80    	cmp    $0x801178e0,%ebx
80104c59:	74 3d                	je     80104c98 <update_dir_entries+0x118>
		if (process_entries[i].used) {
80104c5b:	8b 43 04             	mov    0x4(%ebx),%eax
80104c5e:	85 c0                	test   %eax,%eax
80104c60:	74 ee                	je     80104c50 <update_dir_entries+0xd0>
			itoa(dir_entries[j].name, process_entries[i].pid);
80104c62:	89 f7                	mov    %esi,%edi
80104c64:	83 ec 08             	sub    $0x8,%esp
80104c67:	ff 33                	pushl  (%ebx)
80104c69:	c1 e7 04             	shl    $0x4,%edi
80104c6c:	83 c3 08             	add    $0x8,%ebx
			j++;
80104c6f:	83 c6 01             	add    $0x1,%esi
			itoa(dir_entries[j].name, process_entries[i].pid);
80104c72:	8d 87 e2 78 11 80    	lea    -0x7fee871e(%edi),%eax
80104c78:	50                   	push   %eax
80104c79:	e8 62 fe ff ff       	call   80104ae0 <itoa>
			dir_entries[j].inum = 600 + process_entries[i].pid;
80104c7e:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
			j++;
80104c82:	83 c4 10             	add    $0x10,%esp
			dir_entries[j].inum = 600 + process_entries[i].pid;
80104c85:	66 05 58 02          	add    $0x258,%ax
  for (int i = 0; i < NPROC; i++) {
80104c89:	81 fb e0 78 11 80    	cmp    $0x801178e0,%ebx
			dir_entries[j].inum = 600 + process_entries[i].pid;
80104c8f:	66 89 87 e0 78 11 80 	mov    %ax,-0x7fee8720(%edi)
  for (int i = 0; i < NPROC; i++) {
80104c96:	75 c3                	jne    80104c5b <update_dir_entries+0xdb>
}
80104c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c9b:	5b                   	pop    %ebx
80104c9c:	5e                   	pop    %esi
80104c9d:	5f                   	pop    %edi
80104c9e:	5d                   	pop    %ebp
80104c9f:	c3                   	ret    

80104ca0 <read_path_level_0>:
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
80104ca5:	53                   	push   %ebx
      n = sizeof(dir_entries) - off;
80104ca6:	bb 20 04 00 00       	mov    $0x420,%ebx
{
80104cab:	83 ec 18             	sub    $0x18,%esp
  update_dir_entries(ip->inum);
80104cae:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104cb1:	8b 75 10             	mov    0x10(%ebp),%esi
80104cb4:	8b 7d 14             	mov    0x14(%ebp),%edi
  update_dir_entries(ip->inum);
80104cb7:	ff 70 04             	pushl  0x4(%eax)
      n = sizeof(dir_entries) - off;
80104cba:	29 f3                	sub    %esi,%ebx
  update_dir_entries(ip->inum);
80104cbc:	e8 bf fe ff ff       	call   80104b80 <update_dir_entries>
  if (off + n > sizeof(dir_entries))
80104cc1:	8d 04 3e             	lea    (%esi,%edi,1),%eax
80104cc4:	83 c4 0c             	add    $0xc,%esp
      n = sizeof(dir_entries) - off;
80104cc7:	3d 20 04 00 00       	cmp    $0x420,%eax
80104ccc:	0f 46 df             	cmovbe %edi,%ebx
  memmove(dst, (char*)(&dir_entries) + off, n);
80104ccf:	81 c6 e0 78 11 80    	add    $0x801178e0,%esi
80104cd5:	53                   	push   %ebx
80104cd6:	56                   	push   %esi
80104cd7:	ff 75 0c             	pushl  0xc(%ebp)
80104cda:	e8 f1 0f 00 00       	call   80105cd0 <memmove>
}
80104cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ce2:	89 d8                	mov    %ebx,%eax
80104ce4:	5b                   	pop    %ebx
80104ce5:	5e                   	pop    %esi
80104ce6:	5f                   	pop    %edi
80104ce7:	5d                   	pop    %ebp
80104ce8:	c3                   	ret    
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <update_inode_entries>:
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
  int j = 2;
80104cf6:	bf 02 00 00 00       	mov    $0x2,%edi
80104cfb:	bb 00 7d 11 80       	mov    $0x80117d00,%ebx
{
80104d00:	83 ec 20             	sub    $0x20,%esp
	memset(inodeinfo_dir_entries, sizeof(inodeinfo_dir_entries), 0);
80104d03:	6a 00                	push   $0x0
80104d05:	68 40 03 00 00       	push   $0x340
80104d0a:	68 a0 73 11 80       	push   $0x801173a0
80104d0f:	e8 0c 0f 00 00       	call   80105c20 <memset>
  memmove(&inodeinfo_dir_entries[0].name, ".", 2);
80104d14:	83 c4 0c             	add    $0xc,%esp
80104d17:	6a 02                	push   $0x2
80104d19:	68 29 8d 10 80       	push   $0x80108d29
80104d1e:	68 a2 73 11 80       	push   $0x801173a2
80104d23:	e8 a8 0f 00 00       	call   80105cd0 <memmove>
  memmove(&inodeinfo_dir_entries[1].name, "..", 3);
80104d28:	83 c4 0c             	add    $0xc,%esp
80104d2b:	6a 03                	push   $0x3
80104d2d:	68 28 8d 10 80       	push   $0x80108d28
80104d32:	68 b2 73 11 80       	push   $0x801173b2
80104d37:	e8 94 0f 00 00       	call   80105cd0 <memmove>
  inodeinfo_dir_entries[0].inum = inum;
80104d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  inodeinfo_dir_entries[1].inum = ROOT_INUM;
80104d3f:	ba 01 00 00 00       	mov    $0x1,%edx
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	66 89 15 b0 73 11 80 	mov    %dx,0x801173b0
  inodeinfo_dir_entries[0].inum = inum;
80104d4e:	66 a3 a0 73 11 80    	mov    %ax,0x801173a0
80104d54:	eb 15                	jmp    80104d6b <update_inode_entries+0x7b>
80104d56:	8d 76 00             	lea    0x0(%esi),%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d60:	83 c3 08             	add    $0x8,%ebx
  for (int i = 0; i < NINODE; i++) {
80104d63:	81 fb 90 7e 11 80    	cmp    $0x80117e90,%ebx
80104d69:	74 55                	je     80104dc0 <update_inode_entries+0xd0>
    if (inode_entries[i].used) {
80104d6b:	8b 43 04             	mov    0x4(%ebx),%eax
80104d6e:	85 c0                	test   %eax,%eax
80104d70:	74 ee                	je     80104d60 <update_inode_entries+0x70>
      int index = get_inode_index(inode_entries[i].inode->inum);
80104d72:	8b 03                	mov    (%ebx),%eax
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	ff 70 04             	pushl  0x4(%eax)
80104d7a:	e8 91 d4 ff ff       	call   80102210 <get_inode_index>
      if(index >= 0){ // if index==-1 it is not found in the open inode table (ichache)
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	85 c0                	test   %eax,%eax
      int index = get_inode_index(inode_entries[i].inode->inum);
80104d84:	89 c6                	mov    %eax,%esi
      if(index >= 0){ // if index==-1 it is not found in the open inode table (ichache)
80104d86:	78 2a                	js     80104db2 <update_inode_entries+0xc2>
        itoa(inodeinfo_dir_entries[j].name, index);
80104d88:	83 ec 08             	sub    $0x8,%esp
        inodeinfo_dir_entries[j].inum = 900 + index;
80104d8b:	66 81 c6 84 03       	add    $0x384,%si
        itoa(inodeinfo_dir_entries[j].name, index);
80104d90:	50                   	push   %eax
80104d91:	89 f8                	mov    %edi,%eax
80104d93:	c1 e0 04             	shl    $0x4,%eax
80104d96:	8d 90 a2 73 11 80    	lea    -0x7fee8c5e(%eax),%edx
80104d9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104d9f:	52                   	push   %edx
80104da0:	e8 3b fd ff ff       	call   80104ae0 <itoa>
        inodeinfo_dir_entries[j].inum = 900 + index;
80104da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	66 89 b0 a0 73 11 80 	mov    %si,-0x7fee8c60(%eax)
80104db2:	83 c3 08             	add    $0x8,%ebx
      j++;
80104db5:	83 c7 01             	add    $0x1,%edi
  for (int i = 0; i < NINODE; i++) {
80104db8:	81 fb 90 7e 11 80    	cmp    $0x80117e90,%ebx
80104dbe:	75 ab                	jne    80104d6b <update_inode_entries+0x7b>
}
80104dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc3:	5b                   	pop    %ebx
80104dc4:	5e                   	pop    %esi
80104dc5:	5f                   	pop    %edi
80104dc6:	5d                   	pop    %ebp
80104dc7:	c3                   	ret    
80104dc8:	90                   	nop
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <read_file_inodeinfo>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
      n = sizeof(inodeinfo_dir_entries) - off;
80104dd6:	bb 40 03 00 00       	mov    $0x340,%ebx
{
80104ddb:	83 ec 18             	sub    $0x18,%esp
  update_inode_entries(ip->inum);
80104dde:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104de1:	8b 75 10             	mov    0x10(%ebp),%esi
80104de4:	8b 7d 14             	mov    0x14(%ebp),%edi
  update_inode_entries(ip->inum);
80104de7:	ff 70 04             	pushl  0x4(%eax)
      n = sizeof(inodeinfo_dir_entries) - off;
80104dea:	29 f3                	sub    %esi,%ebx
  update_inode_entries(ip->inum);
80104dec:	e8 ff fe ff ff       	call   80104cf0 <update_inode_entries>
  if (off + n > sizeof(inodeinfo_dir_entries))
80104df1:	8d 04 3e             	lea    (%esi,%edi,1),%eax
80104df4:	83 c4 0c             	add    $0xc,%esp
      n = sizeof(inodeinfo_dir_entries) - off;
80104df7:	3d 40 03 00 00       	cmp    $0x340,%eax
80104dfc:	0f 46 df             	cmovbe %edi,%ebx
  memmove(dst, (char*)(&inodeinfo_dir_entries) + off, n);
80104dff:	81 c6 a0 73 11 80    	add    $0x801173a0,%esi
80104e05:	53                   	push   %ebx
80104e06:	56                   	push   %esi
80104e07:	ff 75 0c             	pushl  0xc(%ebp)
80104e0a:	e8 c1 0e 00 00       	call   80105cd0 <memmove>
}
80104e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e12:	89 d8                	mov    %ebx,%eax
80104e14:	5b                   	pop    %ebx
80104e15:	5e                   	pop    %esi
80104e16:	5f                   	pop    %edi
80104e17:	5d                   	pop    %ebp
80104e18:	c3                   	ret    
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e20 <get_string_working_blocks>:
{
80104e20:	55                   	push   %ebp
80104e21:	31 c0                	xor    %eax,%eax
80104e23:	89 e5                	mov    %esp,%ebp
80104e25:	57                   	push   %edi
80104e26:	56                   	push   %esi
80104e27:	53                   	push   %ebx
80104e28:	83 ec 0c             	sub    $0xc,%esp
80104e2b:	90                   	nop
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104e30:	0f b6 90 ba 8d 10 80 	movzbl -0x7fef7246(%eax),%edx
80104e37:	83 c0 01             	add    $0x1,%eax
80104e3a:	88 90 bf c9 10 80    	mov    %dl,-0x7fef3641(%eax)
80104e40:	84 d2                	test   %dl,%dl
80104e42:	75 ec                	jne    80104e30 <get_string_working_blocks+0x10>
80104e44:	8b 75 08             	mov    0x8(%ebp),%esi
80104e47:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
80104e4d:	eb 0c                	jmp    80104e5b <get_string_working_blocks+0x3b>
80104e4f:	90                   	nop
80104e50:	83 c6 08             	add    $0x8,%esi
  for(int i=0; i < 256; i = i+2){
80104e53:	39 de                	cmp    %ebx,%esi
80104e55:	0f 84 d1 00 00 00    	je     80104f2c <get_string_working_blocks+0x10c>
    if(q[i] != 0){
80104e5b:	8b 3e                	mov    (%esi),%edi
80104e5d:	85 ff                	test   %edi,%edi
80104e5f:	74 ef                	je     80104e50 <get_string_working_blocks+0x30>
      strcpy(currQueueData + strlen(currQueueData), "(");
80104e61:	83 ec 0c             	sub    $0xc,%esp
80104e64:	68 c0 c9 10 80       	push   $0x8010c9c0
80104e69:	e8 d2 0f 00 00       	call   80105e40 <strlen>
80104e6e:	83 c4 10             	add    $0x10,%esp
80104e71:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104e76:	31 d2                	xor    %edx,%edx
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104e80:	0f b6 8a b4 8e 10 80 	movzbl -0x7fef714c(%edx),%ecx
80104e87:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e8a:	83 c2 01             	add    $0x1,%edx
80104e8d:	84 c9                	test   %cl,%cl
80104e8f:	75 ef                	jne    80104e80 <get_string_working_blocks+0x60>
      itoa(currQueueData + strlen(currQueueData), q[i]);
80104e91:	83 ec 0c             	sub    $0xc,%esp
80104e94:	8b 3e                	mov    (%esi),%edi
80104e96:	68 c0 c9 10 80       	push   $0x8010c9c0
80104e9b:	e8 a0 0f 00 00       	call   80105e40 <strlen>
80104ea0:	5a                   	pop    %edx
80104ea1:	59                   	pop    %ecx
80104ea2:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104ea7:	57                   	push   %edi
80104ea8:	50                   	push   %eax
80104ea9:	e8 32 fc ff ff       	call   80104ae0 <itoa>
      strcpy(currQueueData + strlen(currQueueData), ",");
80104eae:	c7 04 24 c0 c9 10 80 	movl   $0x8010c9c0,(%esp)
80104eb5:	e8 86 0f 00 00       	call   80105e40 <strlen>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104ec2:	31 d2                	xor    %edx,%edx
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104ec8:	0f b6 8a cb 8d 10 80 	movzbl -0x7fef7235(%edx),%ecx
80104ecf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ed2:	83 c2 01             	add    $0x1,%edx
80104ed5:	84 c9                	test   %cl,%cl
80104ed7:	75 ef                	jne    80104ec8 <get_string_working_blocks+0xa8>
      itoa(currQueueData + strlen(currQueueData), q[i+1]);
80104ed9:	83 ec 0c             	sub    $0xc,%esp
80104edc:	8b 7e 04             	mov    0x4(%esi),%edi
80104edf:	68 c0 c9 10 80       	push   $0x8010c9c0
80104ee4:	e8 57 0f 00 00       	call   80105e40 <strlen>
80104ee9:	5a                   	pop    %edx
80104eea:	59                   	pop    %ecx
80104eeb:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104ef0:	57                   	push   %edi
80104ef1:	50                   	push   %eax
80104ef2:	e8 e9 fb ff ff       	call   80104ae0 <itoa>
      strcpy(currQueueData + strlen(currQueueData), ");");
80104ef7:	c7 04 24 c0 c9 10 80 	movl   $0x8010c9c0,(%esp)
80104efe:	e8 3d 0f 00 00       	call   80105e40 <strlen>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104f0b:	31 d2                	xor    %edx,%edx
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
80104f10:	0f b6 8a cd 8d 10 80 	movzbl -0x7fef7233(%edx),%ecx
80104f17:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104f1a:	83 c2 01             	add    $0x1,%edx
80104f1d:	84 c9                	test   %cl,%cl
80104f1f:	75 ef                	jne    80104f10 <get_string_working_blocks+0xf0>
80104f21:	83 c6 08             	add    $0x8,%esi
  for(int i=0; i < 256; i = i+2){
80104f24:	39 de                	cmp    %ebx,%esi
80104f26:	0f 85 2f ff ff ff    	jne    80104e5b <get_string_working_blocks+0x3b>
}
80104f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f2f:	b8 c0 c9 10 80       	mov    $0x8010c9c0,%eax
80104f34:	5b                   	pop    %ebx
80104f35:	5e                   	pop    %esi
80104f36:	5f                   	pop    %edi
80104f37:	5d                   	pop    %ebp
80104f38:	c3                   	ret    
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f40 <read_file_ideinfo.part.0>:
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	56                   	push   %esi
80104f45:	53                   	push   %ebx
	char data[256] = {0};
80104f46:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104f4c:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
80104f4e:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104f53:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80104f59:	89 df                	mov    %ebx,%edi
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104f5b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
80104f61:	31 c0                	xor    %eax,%eax
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104f63:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
80104f69:	f3 ab                	rep stos %eax,%es:(%edi)
80104f6b:	90                   	nop
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104f70:	0f b6 90 d0 8d 10 80 	movzbl -0x7fef7230(%eax),%edx
80104f77:	88 14 03             	mov    %dl,(%ebx,%eax,1)
80104f7a:	83 c0 01             	add    $0x1,%eax
80104f7d:	84 d2                	test   %dl,%dl
80104f7f:	75 ef                	jne    80104f70 <read_file_ideinfo.part.0+0x30>
	itoa(data + strlen(data), get_waiting_ops());
80104f81:	e8 5a d6 ff ff       	call   801025e0 <get_waiting_ops>
80104f86:	83 ec 0c             	sub    $0xc,%esp
80104f89:	89 c7                	mov    %eax,%edi
80104f8b:	53                   	push   %ebx
80104f8c:	e8 af 0e 00 00       	call   80105e40 <strlen>
80104f91:	5a                   	pop    %edx
80104f92:	59                   	pop    %ecx
80104f93:	01 d8                	add    %ebx,%eax
80104f95:	57                   	push   %edi
80104f96:	50                   	push   %eax
80104f97:	e8 44 fb ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\nRead waiting operations: ");
80104f9c:	89 1c 24             	mov    %ebx,(%esp)
80104f9f:	e8 9c 0e 00 00       	call   80105e40 <strlen>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	01 d8                	add    %ebx,%eax
80104fa9:	31 d2                	xor    %edx,%edx
80104fab:	90                   	nop
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104fb0:	0f b6 8a e5 8d 10 80 	movzbl -0x7fef721b(%edx),%ecx
80104fb7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104fba:	83 c2 01             	add    $0x1,%edx
80104fbd:	84 c9                	test   %cl,%cl
80104fbf:	75 ef                	jne    80104fb0 <read_file_ideinfo.part.0+0x70>
	itoa(data + strlen(data), get_read_wait_ops());
80104fc1:	e8 ca d5 ff ff       	call   80102590 <get_read_wait_ops>
80104fc6:	83 ec 0c             	sub    $0xc,%esp
80104fc9:	89 c7                	mov    %eax,%edi
80104fcb:	53                   	push   %ebx
80104fcc:	e8 6f 0e 00 00       	call   80105e40 <strlen>
80104fd1:	5a                   	pop    %edx
80104fd2:	59                   	pop    %ecx
80104fd3:	01 d8                	add    %ebx,%eax
80104fd5:	57                   	push   %edi
80104fd6:	50                   	push   %eax
80104fd7:	e8 04 fb ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\nWrite waiting operations: ");
80104fdc:	89 1c 24             	mov    %ebx,(%esp)
80104fdf:	e8 5c 0e 00 00       	call   80105e40 <strlen>
80104fe4:	83 c4 10             	add    $0x10,%esp
80104fe7:	01 d8                	add    %ebx,%eax
80104fe9:	31 d2                	xor    %edx,%edx
80104feb:	90                   	nop
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104ff0:	0f b6 8a 00 8e 10 80 	movzbl -0x7fef7200(%edx),%ecx
80104ff7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ffa:	83 c2 01             	add    $0x1,%edx
80104ffd:	84 c9                	test   %cl,%cl
80104fff:	75 ef                	jne    80104ff0 <read_file_ideinfo.part.0+0xb0>
	itoa(data + strlen(data), get_write_wait_ops());
80105001:	e8 fa d5 ff ff       	call   80102600 <get_write_wait_ops>
80105006:	83 ec 0c             	sub    $0xc,%esp
80105009:	89 c7                	mov    %eax,%edi
8010500b:	53                   	push   %ebx
8010500c:	e8 2f 0e 00 00       	call   80105e40 <strlen>
80105011:	5a                   	pop    %edx
80105012:	59                   	pop    %ecx
80105013:	01 d8                	add    %ebx,%eax
80105015:	57                   	push   %edi
80105016:	50                   	push   %eax
80105017:	e8 c4 fa ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), "\n");
8010501c:	89 1c 24             	mov    %ebx,(%esp)
8010501f:	e8 1c 0e 00 00       	call   80105e40 <strlen>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	01 d8                	add    %ebx,%eax
80105029:	31 d2                	xor    %edx,%edx
8010502b:	90                   	nop
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105030:	0f b6 8a 53 92 10 80 	movzbl -0x7fef6dad(%edx),%ecx
80105037:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010503a:	83 c2 01             	add    $0x1,%edx
8010503d:	84 c9                	test   %cl,%cl
8010503f:	75 ef                	jne    80105030 <read_file_ideinfo.part.0+0xf0>
  char* workBlocks = get_string_working_blocks(get_working_blocks());
80105041:	e8 ca d5 ff ff       	call   80102610 <get_working_blocks>
80105046:	83 ec 0c             	sub    $0xc,%esp
80105049:	50                   	push   %eax
8010504a:	e8 d1 fd ff ff       	call   80104e20 <get_string_working_blocks>
  strcpy(data + strlen(data), workBlocks);
8010504f:	89 1c 24             	mov    %ebx,(%esp)
  char* workBlocks = get_string_working_blocks(get_working_blocks());
80105052:	89 c7                	mov    %eax,%edi
  strcpy(data + strlen(data), workBlocks);
80105054:	e8 e7 0d 00 00       	call   80105e40 <strlen>
80105059:	83 c4 10             	add    $0x10,%esp
8010505c:	01 d8                	add    %ebx,%eax
8010505e:	66 90                	xchg   %ax,%ax
  while((*s++ = *t++) != 0)
80105060:	83 c7 01             	add    $0x1,%edi
80105063:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105067:	83 c0 01             	add    $0x1,%eax
8010506a:	84 d2                	test   %dl,%dl
8010506c:	88 50 ff             	mov    %dl,-0x1(%eax)
8010506f:	75 ef                	jne    80105060 <read_file_ideinfo.part.0+0x120>
	strcpy(data + strlen(data), "\n");
80105071:	83 ec 0c             	sub    $0xc,%esp
80105074:	53                   	push   %ebx
80105075:	e8 c6 0d 00 00       	call   80105e40 <strlen>
8010507a:	83 c4 10             	add    $0x10,%esp
8010507d:	01 d8                	add    %ebx,%eax
8010507f:	31 d2                	xor    %edx,%edx
80105081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105088:	0f b6 8a 53 92 10 80 	movzbl -0x7fef6dad(%edx),%ecx
8010508f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105092:	83 c2 01             	add    $0x1,%edx
80105095:	84 c9                	test   %cl,%cl
80105097:	75 ef                	jne    80105088 <read_file_ideinfo.part.0+0x148>
	if (off + n > strlen(data))
80105099:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
8010509f:	83 ec 0c             	sub    $0xc,%esp
801050a2:	53                   	push   %ebx
801050a3:	8d 3c 06             	lea    (%esi,%eax,1),%edi
801050a6:	e8 95 0d 00 00       	call   80105e40 <strlen>
801050ab:	83 c4 10             	add    $0x10,%esp
801050ae:	39 c7                	cmp    %eax,%edi
801050b0:	7f 26                	jg     801050d8 <read_file_ideinfo.part.0+0x198>
	memmove(dst, (char*)(&data) + off, n);
801050b2:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
801050b8:	83 ec 04             	sub    $0x4,%esp
801050bb:	56                   	push   %esi
801050bc:	53                   	push   %ebx
801050bd:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
801050c3:	e8 08 0c 00 00       	call   80105cd0 <memmove>
}
801050c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cb:	89 f0                	mov    %esi,%eax
801050cd:	5b                   	pop    %ebx
801050ce:	5e                   	pop    %esi
801050cf:	5f                   	pop    %edi
801050d0:	5d                   	pop    %ebp
801050d1:	c3                   	ret    
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	53                   	push   %ebx
801050dc:	e8 5f 0d 00 00       	call   80105e40 <strlen>
801050e1:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	89 c6                	mov    %eax,%esi
801050ec:	eb c4                	jmp    801050b2 <read_file_ideinfo.part.0+0x172>
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <read_file_ideinfo>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
801050f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f9:	8b 55 10             	mov    0x10(%ebp),%edx
  if (n == sizeof(struct dirent))
801050fc:	83 f9 10             	cmp    $0x10,%ecx
801050ff:	74 0f                	je     80105110 <read_file_ideinfo+0x20>
}
80105101:	5d                   	pop    %ebp
80105102:	e9 39 fe ff ff       	jmp    80104f40 <read_file_ideinfo.part.0>
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105110:	31 c0                	xor    %eax,%eax
80105112:	5d                   	pop    %ebp
80105113:	c3                   	ret    
80105114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010511a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105120 <read_file_filestat.part.1>:
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
	char data[256] = {0};
80105126:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
8010512c:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
8010512e:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80105133:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80105139:	89 df                	mov    %ebx,%edi
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
8010513b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
80105141:	31 c0                	xor    %eax,%eax
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80105143:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
80105149:	f3 ab                	rep stos %eax,%es:(%edi)
8010514b:	90                   	nop
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105150:	0f b6 90 1c 8e 10 80 	movzbl -0x7fef71e4(%eax),%edx
80105157:	88 14 03             	mov    %dl,(%ebx,%eax,1)
8010515a:	83 c0 01             	add    $0x1,%eax
8010515d:	84 d2                	test   %dl,%dl
8010515f:	75 ef                	jne    80105150 <read_file_filestat.part.1+0x30>
	itoa(data + strlen(data), get_free_fds());
80105161:	e8 aa bf ff ff       	call   80101110 <get_free_fds>
80105166:	83 ec 0c             	sub    $0xc,%esp
80105169:	89 c7                	mov    %eax,%edi
8010516b:	53                   	push   %ebx
8010516c:	e8 cf 0c 00 00       	call   80105e40 <strlen>
80105171:	5a                   	pop    %edx
80105172:	59                   	pop    %ecx
80105173:	01 d8                	add    %ebx,%eax
80105175:	57                   	push   %edi
80105176:	50                   	push   %eax
80105177:	e8 64 f9 ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\nUnique inode fds: ");
8010517c:	89 1c 24             	mov    %ebx,(%esp)
8010517f:	e8 bc 0c 00 00       	call   80105e40 <strlen>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	01 d8                	add    %ebx,%eax
80105189:	31 d2                	xor    %edx,%edx
8010518b:	90                   	nop
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105190:	0f b6 8a 27 8e 10 80 	movzbl -0x7fef71d9(%edx),%ecx
80105197:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010519a:	83 c2 01             	add    $0x1,%edx
8010519d:	84 c9                	test   %cl,%cl
8010519f:	75 ef                	jne    80105190 <read_file_filestat.part.1+0x70>
	itoa(data + strlen(data), get_unique_inode_fds()); 
801051a1:	e8 ba bf ff ff       	call   80101160 <get_unique_inode_fds>
801051a6:	83 ec 0c             	sub    $0xc,%esp
801051a9:	89 c7                	mov    %eax,%edi
801051ab:	53                   	push   %ebx
801051ac:	e8 8f 0c 00 00       	call   80105e40 <strlen>
801051b1:	5a                   	pop    %edx
801051b2:	59                   	pop    %ecx
801051b3:	01 d8                	add    %ebx,%eax
801051b5:	57                   	push   %edi
801051b6:	50                   	push   %eax
801051b7:	e8 24 f9 ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\nWriteable fds: ");
801051bc:	89 1c 24             	mov    %ebx,(%esp)
801051bf:	e8 7c 0c 00 00       	call   80105e40 <strlen>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	01 d8                	add    %ebx,%eax
801051c9:	31 d2                	xor    %edx,%edx
801051cb:	90                   	nop
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801051d0:	0f b6 8a 3b 8e 10 80 	movzbl -0x7fef71c5(%edx),%ecx
801051d7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801051da:	83 c2 01             	add    $0x1,%edx
801051dd:	84 c9                	test   %cl,%cl
801051df:	75 ef                	jne    801051d0 <read_file_filestat.part.1+0xb0>
	itoa(data + strlen(data), get_writeable_fds());
801051e1:	e8 3a c0 ff ff       	call   80101220 <get_writeable_fds>
801051e6:	83 ec 0c             	sub    $0xc,%esp
801051e9:	89 c7                	mov    %eax,%edi
801051eb:	53                   	push   %ebx
801051ec:	e8 4f 0c 00 00       	call   80105e40 <strlen>
801051f1:	5a                   	pop    %edx
801051f2:	59                   	pop    %ecx
801051f3:	01 d8                	add    %ebx,%eax
801051f5:	57                   	push   %edi
801051f6:	50                   	push   %eax
801051f7:	e8 e4 f8 ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), "\nReadable fds: ");
801051fc:	89 1c 24             	mov    %ebx,(%esp)
801051ff:	e8 3c 0c 00 00       	call   80105e40 <strlen>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	01 d8                	add    %ebx,%eax
80105209:	31 d2                	xor    %edx,%edx
8010520b:	90                   	nop
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105210:	0f b6 8a 4c 8e 10 80 	movzbl -0x7fef71b4(%edx),%ecx
80105217:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010521a:	83 c2 01             	add    $0x1,%edx
8010521d:	84 c9                	test   %cl,%cl
8010521f:	75 ef                	jne    80105210 <read_file_filestat.part.1+0xf0>
	itoa(data + strlen(data), get_readable_fds());
80105221:	e8 4a c0 ff ff       	call   80101270 <get_readable_fds>
80105226:	83 ec 0c             	sub    $0xc,%esp
80105229:	89 c7                	mov    %eax,%edi
8010522b:	53                   	push   %ebx
8010522c:	e8 0f 0c 00 00       	call   80105e40 <strlen>
80105231:	5a                   	pop    %edx
80105232:	59                   	pop    %ecx
80105233:	01 d8                	add    %ebx,%eax
80105235:	57                   	push   %edi
80105236:	50                   	push   %eax
80105237:	e8 a4 f8 ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), "\nRefs per fds: ");
8010523c:	89 1c 24             	mov    %ebx,(%esp)
8010523f:	e8 fc 0b 00 00       	call   80105e40 <strlen>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	01 d8                	add    %ebx,%eax
80105249:	31 d2                	xor    %edx,%edx
8010524b:	90                   	nop
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105250:	0f b6 8a 5c 8e 10 80 	movzbl -0x7fef71a4(%edx),%ecx
80105257:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010525a:	83 c2 01             	add    $0x1,%edx
8010525d:	84 c9                	test   %cl,%cl
8010525f:	75 ef                	jne    80105250 <read_file_filestat.part.1+0x130>
	itoa(data + strlen(data), get_total_refs());
80105261:	e8 5a c0 ff ff       	call   801012c0 <get_total_refs>
80105266:	83 ec 0c             	sub    $0xc,%esp
80105269:	89 c7                	mov    %eax,%edi
8010526b:	53                   	push   %ebx
8010526c:	e8 cf 0b 00 00       	call   80105e40 <strlen>
80105271:	5a                   	pop    %edx
80105272:	59                   	pop    %ecx
80105273:	01 d8                	add    %ebx,%eax
80105275:	57                   	push   %edi
80105276:	50                   	push   %eax
80105277:	e8 64 f8 ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), " / ");
8010527c:	89 1c 24             	mov    %ebx,(%esp)
8010527f:	e8 bc 0b 00 00       	call   80105e40 <strlen>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	01 d8                	add    %ebx,%eax
80105289:	31 d2                	xor    %edx,%edx
8010528b:	90                   	nop
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105290:	0f b6 8a 6c 8e 10 80 	movzbl -0x7fef7194(%edx),%ecx
80105297:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010529a:	83 c2 01             	add    $0x1,%edx
8010529d:	84 c9                	test   %cl,%cl
8010529f:	75 ef                	jne    80105290 <read_file_filestat.part.1+0x170>
	itoa(data + strlen(data), get_used_fds());
801052a1:	e8 6a c0 ff ff       	call   80101310 <get_used_fds>
801052a6:	83 ec 0c             	sub    $0xc,%esp
801052a9:	89 c7                	mov    %eax,%edi
801052ab:	53                   	push   %ebx
801052ac:	e8 8f 0b 00 00       	call   80105e40 <strlen>
801052b1:	5a                   	pop    %edx
801052b2:	59                   	pop    %ecx
801052b3:	01 d8                	add    %ebx,%eax
801052b5:	57                   	push   %edi
801052b6:	50                   	push   %eax
801052b7:	e8 24 f8 ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\n");
801052bc:	89 1c 24             	mov    %ebx,(%esp)
801052bf:	e8 7c 0b 00 00       	call   80105e40 <strlen>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	01 d8                	add    %ebx,%eax
801052c9:	31 d2                	xor    %edx,%edx
801052cb:	90                   	nop
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801052d0:	0f b6 8a 53 92 10 80 	movzbl -0x7fef6dad(%edx),%ecx
801052d7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801052da:	83 c2 01             	add    $0x1,%edx
801052dd:	84 c9                	test   %cl,%cl
801052df:	75 ef                	jne    801052d0 <read_file_filestat.part.1+0x1b0>
	if (off + n > strlen(data))
801052e1:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
801052e7:	83 ec 0c             	sub    $0xc,%esp
801052ea:	53                   	push   %ebx
801052eb:	8d 3c 06             	lea    (%esi,%eax,1),%edi
801052ee:	e8 4d 0b 00 00       	call   80105e40 <strlen>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	39 c7                	cmp    %eax,%edi
801052f8:	7f 26                	jg     80105320 <read_file_filestat.part.1+0x200>
	memmove(dst, (char*)(&data) + off, n);
801052fa:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
80105300:	83 ec 04             	sub    $0x4,%esp
80105303:	56                   	push   %esi
80105304:	53                   	push   %ebx
80105305:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
8010530b:	e8 c0 09 00 00       	call   80105cd0 <memmove>
}
80105310:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105313:	89 f0                	mov    %esi,%eax
80105315:	5b                   	pop    %ebx
80105316:	5e                   	pop    %esi
80105317:	5f                   	pop    %edi
80105318:	5d                   	pop    %ebp
80105319:	c3                   	ret    
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	53                   	push   %ebx
80105324:	e8 17 0b 00 00       	call   80105e40 <strlen>
80105329:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	89 c6                	mov    %eax,%esi
80105334:	eb c4                	jmp    801052fa <read_file_filestat.part.1+0x1da>
80105336:	8d 76 00             	lea    0x0(%esi),%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <read_file_filestat>:
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	8b 4d 14             	mov    0x14(%ebp),%ecx
80105346:	8b 45 0c             	mov    0xc(%ebp),%eax
80105349:	8b 55 10             	mov    0x10(%ebp),%edx
  if (n == sizeof(struct dirent))
8010534c:	83 f9 10             	cmp    $0x10,%ecx
8010534f:	74 0f                	je     80105360 <read_file_filestat+0x20>
}
80105351:	5d                   	pop    %ebp
80105352:	e9 c9 fd ff ff       	jmp    80105120 <read_file_filestat.part.1>
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105360:	31 c0                	xor    %eax,%eax
80105362:	5d                   	pop    %ebp
80105363:	c3                   	ret    
80105364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010536a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105370 <read_path_level_1>:
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	53                   	push   %ebx
  switch (ip->inum) {
80105374:	8b 5d 08             	mov    0x8(%ebp),%ebx
{
80105377:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537a:	8b 55 10             	mov    0x10(%ebp),%edx
8010537d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  switch (ip->inum) {
80105380:	8b 5b 04             	mov    0x4(%ebx),%ebx
80105383:	81 fb f5 01 00 00    	cmp    $0x1f5,%ebx
80105389:	74 35                	je     801053c0 <read_path_level_1+0x50>
8010538b:	81 fb f6 01 00 00    	cmp    $0x1f6,%ebx
80105391:	74 25                	je     801053b8 <read_path_level_1+0x48>
80105393:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
80105399:	74 0d                	je     801053a8 <read_path_level_1+0x38>
}
8010539b:	5b                   	pop    %ebx
8010539c:	5d                   	pop    %ebp
      return read_procfs_pid_dir(ip, dst, off, n);
8010539d:	e9 1e f3 ff ff       	jmp    801046c0 <read_procfs_pid_dir>
801053a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (n == sizeof(struct dirent))
801053a8:	83 f9 10             	cmp    $0x10,%ecx
801053ab:	75 23                	jne    801053d0 <read_path_level_1+0x60>
}
801053ad:	31 c0                	xor    %eax,%eax
801053af:	5b                   	pop    %ebx
801053b0:	5d                   	pop    %ebp
801053b1:	c3                   	ret    
801053b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053b8:	5b                   	pop    %ebx
801053b9:	5d                   	pop    %ebp
      return read_file_inodeinfo(ip, dst, off, n); //should be a directory
801053ba:	e9 11 fa ff ff       	jmp    80104dd0 <read_file_inodeinfo>
801053bf:	90                   	nop
  if (n == sizeof(struct dirent))
801053c0:	83 f9 10             	cmp    $0x10,%ecx
801053c3:	74 e8                	je     801053ad <read_path_level_1+0x3d>
}
801053c5:	5b                   	pop    %ebx
801053c6:	5d                   	pop    %ebp
801053c7:	e9 54 fd ff ff       	jmp    80105120 <read_file_filestat.part.1>
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d0:	5b                   	pop    %ebx
801053d1:	5d                   	pop    %ebp
801053d2:	e9 69 fb ff ff       	jmp    80104f40 <read_file_ideinfo.part.0>
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <read_inodeinfo_file.part.3>:
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
801053e5:	53                   	push   %ebx
	char data[256] = {0};
801053e6:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
801053ec:	89 c6                	mov    %eax,%esi
	char data[256] = {0};
801053ee:	31 c0                	xor    %eax,%eax
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
801053f0:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
801053f6:	89 df                	mov    %ebx,%edi
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
801053f8:	89 8d e4 fe ff ff    	mov    %ecx,-0x11c(%ebp)
	char data[256] = {0};
801053fe:	b9 40 00 00 00       	mov    $0x40,%ecx
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
80105403:	89 95 e0 fe ff ff    	mov    %edx,-0x120(%ebp)
	char data[256] = {0};
80105409:	f3 ab                	rep stos %eax,%es:(%edi)
8010540b:	90                   	nop
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105410:	0f b6 90 70 8e 10 80 	movzbl -0x7fef7190(%eax),%edx
80105417:	88 14 03             	mov    %dl,(%ebx,%eax,1)
8010541a:	83 c0 01             	add    $0x1,%eax
8010541d:	84 d2                	test   %dl,%dl
8010541f:	75 ef                	jne    80105410 <read_inodeinfo_file.part.3+0x30>
	itoa(data + strlen(data), ip->dev);
80105421:	83 ec 0c             	sub    $0xc,%esp
80105424:	8b 3e                	mov    (%esi),%edi
80105426:	53                   	push   %ebx
80105427:	e8 14 0a 00 00       	call   80105e40 <strlen>
8010542c:	5a                   	pop    %edx
8010542d:	59                   	pop    %ecx
8010542e:	01 d8                	add    %ebx,%eax
80105430:	57                   	push   %edi
80105431:	50                   	push   %eax
80105432:	e8 a9 f6 ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\nInode number: ");
80105437:	89 1c 24             	mov    %ebx,(%esp)
8010543a:	e8 01 0a 00 00       	call   80105e40 <strlen>
8010543f:	83 c4 10             	add    $0x10,%esp
80105442:	01 d8                	add    %ebx,%eax
80105444:	31 d2                	xor    %edx,%edx
80105446:	8d 76 00             	lea    0x0(%esi),%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
80105450:	0f b6 8a 79 8e 10 80 	movzbl -0x7fef7187(%edx),%ecx
80105457:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010545a:	83 c2 01             	add    $0x1,%edx
8010545d:	84 c9                	test   %cl,%cl
8010545f:	75 ef                	jne    80105450 <read_inodeinfo_file.part.3+0x70>
	itoa(data + strlen(data), ip->inum); 
80105461:	83 ec 0c             	sub    $0xc,%esp
80105464:	8b 7e 04             	mov    0x4(%esi),%edi
80105467:	53                   	push   %ebx
80105468:	e8 d3 09 00 00       	call   80105e40 <strlen>
8010546d:	5a                   	pop    %edx
8010546e:	59                   	pop    %ecx
8010546f:	01 d8                	add    %ebx,%eax
80105471:	57                   	push   %edi
80105472:	50                   	push   %eax
80105473:	e8 68 f6 ff ff       	call   80104ae0 <itoa>
	strcpy(data + strlen(data), "\nis valid: ");
80105478:	89 1c 24             	mov    %ebx,(%esp)
8010547b:	e8 c0 09 00 00       	call   80105e40 <strlen>
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	01 d8                	add    %ebx,%eax
80105485:	31 d2                	xor    %edx,%edx
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
80105490:	0f b6 8a 89 8e 10 80 	movzbl -0x7fef7177(%edx),%ecx
80105497:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010549a:	83 c2 01             	add    $0x1,%edx
8010549d:	84 c9                	test   %cl,%cl
8010549f:	75 ef                	jne    80105490 <read_inodeinfo_file.part.3+0xb0>
	itoa(data + strlen(data), ip->valid);
801054a1:	83 ec 0c             	sub    $0xc,%esp
801054a4:	8b 7e 4c             	mov    0x4c(%esi),%edi
801054a7:	53                   	push   %ebx
801054a8:	e8 93 09 00 00       	call   80105e40 <strlen>
801054ad:	5a                   	pop    %edx
801054ae:	59                   	pop    %ecx
801054af:	01 d8                	add    %ebx,%eax
801054b1:	57                   	push   %edi
801054b2:	50                   	push   %eax
801054b3:	e8 28 f6 ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), "\ntype: ");
801054b8:	89 1c 24             	mov    %ebx,(%esp)
801054bb:	e8 80 09 00 00       	call   80105e40 <strlen>
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	01 d8                	add    %ebx,%eax
801054c5:	31 d2                	xor    %edx,%edx
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
801054d0:	0f b6 8a 95 8e 10 80 	movzbl -0x7fef716b(%edx),%ecx
801054d7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801054da:	83 c2 01             	add    $0x1,%edx
801054dd:	84 c9                	test   %cl,%cl
801054df:	75 ef                	jne    801054d0 <read_inodeinfo_file.part.3+0xf0>
  if(ip->type == T_DIR)
801054e1:	0f b7 46 50          	movzwl 0x50(%esi),%eax
801054e5:	66 83 f8 01          	cmp    $0x1,%ax
801054e9:	0f 84 e1 01 00 00    	je     801056d0 <read_inodeinfo_file.part.3+0x2f0>
  if(ip->type == T_FILE)
801054ef:	66 83 f8 02          	cmp    $0x2,%ax
801054f3:	0f 84 06 02 00 00    	je     801056ff <read_inodeinfo_file.part.3+0x31f>
  if(ip->type == T_DEV)
801054f9:	66 83 f8 03          	cmp    $0x3,%ax
801054fd:	0f 84 2c 02 00 00    	je     8010572f <read_inodeinfo_file.part.3+0x34f>
  strcpy(data + strlen(data), "\nmajor minor: (");
80105503:	83 ec 0c             	sub    $0xc,%esp
80105506:	53                   	push   %ebx
80105507:	e8 34 09 00 00       	call   80105e40 <strlen>
8010550c:	83 c4 10             	add    $0x10,%esp
8010550f:	01 d8                	add    %ebx,%eax
80105511:	31 d2                	xor    %edx,%edx
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105518:	0f b6 8a a6 8e 10 80 	movzbl -0x7fef715a(%edx),%ecx
8010551f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105522:	83 c2 01             	add    $0x1,%edx
80105525:	84 c9                	test   %cl,%cl
80105527:	75 ef                	jne    80105518 <read_inodeinfo_file.part.3+0x138>
	itoa(data + strlen(data), ip->major);
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	0f bf 7e 52          	movswl 0x52(%esi),%edi
80105530:	53                   	push   %ebx
80105531:	e8 0a 09 00 00       	call   80105e40 <strlen>
80105536:	5a                   	pop    %edx
80105537:	59                   	pop    %ecx
80105538:	01 d8                	add    %ebx,%eax
8010553a:	57                   	push   %edi
8010553b:	50                   	push   %eax
8010553c:	e8 9f f5 ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), ", ");
80105541:	89 1c 24             	mov    %ebx,(%esp)
80105544:	e8 f7 08 00 00       	call   80105e40 <strlen>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	01 d8                	add    %ebx,%eax
8010554e:	31 d2                	xor    %edx,%edx
  while((*s++ = *t++) != 0)
80105550:	0f b6 8a b6 8e 10 80 	movzbl -0x7fef714a(%edx),%ecx
80105557:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010555a:	83 c2 01             	add    $0x1,%edx
8010555d:	84 c9                	test   %cl,%cl
8010555f:	75 ef                	jne    80105550 <read_inodeinfo_file.part.3+0x170>
	itoa(data + strlen(data), ip->minor);
80105561:	83 ec 0c             	sub    $0xc,%esp
80105564:	0f bf 7e 54          	movswl 0x54(%esi),%edi
80105568:	53                   	push   %ebx
80105569:	e8 d2 08 00 00       	call   80105e40 <strlen>
8010556e:	5a                   	pop    %edx
8010556f:	59                   	pop    %ecx
80105570:	01 d8                	add    %ebx,%eax
80105572:	57                   	push   %edi
80105573:	50                   	push   %eax
80105574:	e8 67 f5 ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), ")");
80105579:	89 1c 24             	mov    %ebx,(%esp)
8010557c:	e8 bf 08 00 00       	call   80105e40 <strlen>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	01 d8                	add    %ebx,%eax
80105586:	31 d2                	xor    %edx,%edx
80105588:	90                   	nop
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105590:	0f b6 8a fd 86 10 80 	movzbl -0x7fef7903(%edx),%ecx
80105597:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010559a:	83 c2 01             	add    $0x1,%edx
8010559d:	84 c9                	test   %cl,%cl
8010559f:	75 ef                	jne    80105590 <read_inodeinfo_file.part.3+0x1b0>
	strcpy(data + strlen(data), "\nhard links: ");
801055a1:	83 ec 0c             	sub    $0xc,%esp
801055a4:	53                   	push   %ebx
801055a5:	e8 96 08 00 00       	call   80105e40 <strlen>
801055aa:	83 c4 10             	add    $0x10,%esp
801055ad:	01 d8                	add    %ebx,%eax
801055af:	31 d2                	xor    %edx,%edx
801055b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801055b8:	0f b6 8a b9 8e 10 80 	movzbl -0x7fef7147(%edx),%ecx
801055bf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801055c2:	83 c2 01             	add    $0x1,%edx
801055c5:	84 c9                	test   %cl,%cl
801055c7:	75 ef                	jne    801055b8 <read_inodeinfo_file.part.3+0x1d8>
	itoa(data + strlen(data), ip->ref);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	8b 7e 08             	mov    0x8(%esi),%edi
801055cf:	53                   	push   %ebx
801055d0:	e8 6b 08 00 00       	call   80105e40 <strlen>
801055d5:	5a                   	pop    %edx
801055d6:	59                   	pop    %ecx
801055d7:	01 d8                	add    %ebx,%eax
801055d9:	57                   	push   %edi
801055da:	50                   	push   %eax
801055db:	e8 00 f5 ff ff       	call   80104ae0 <itoa>
  strcpy(data + strlen(data), "\nblocks used: ");
801055e0:	89 1c 24             	mov    %ebx,(%esp)
801055e3:	e8 58 08 00 00       	call   80105e40 <strlen>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	01 d8                	add    %ebx,%eax
801055ed:	31 d2                	xor    %edx,%edx
801055ef:	90                   	nop
  while((*s++ = *t++) != 0)
801055f0:	0f b6 8a c7 8e 10 80 	movzbl -0x7fef7139(%edx),%ecx
801055f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801055fa:	83 c2 01             	add    $0x1,%edx
801055fd:	84 c9                	test   %cl,%cl
801055ff:	75 ef                	jne    801055f0 <read_inodeinfo_file.part.3+0x210>
  if(ip->type == T_DEV){
80105601:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
80105606:	0f 84 84 00 00 00    	je     80105690 <read_inodeinfo_file.part.3+0x2b0>
    itoa(data + strlen(data), usedBlocks);
8010560c:	83 ec 0c             	sub    $0xc,%esp
    int usedBlocks = ip->size / BSIZE;
8010560f:	8b 76 58             	mov    0x58(%esi),%esi
    itoa(data + strlen(data), usedBlocks);
80105612:	53                   	push   %ebx
80105613:	e8 28 08 00 00       	call   80105e40 <strlen>
80105618:	5a                   	pop    %edx
80105619:	59                   	pop    %ecx
8010561a:	01 d8                	add    %ebx,%eax
    int usedBlocks = ip->size / BSIZE;
8010561c:	c1 ee 09             	shr    $0x9,%esi
    itoa(data + strlen(data), usedBlocks);
8010561f:	56                   	push   %esi
80105620:	50                   	push   %eax
80105621:	e8 ba f4 ff ff       	call   80104ae0 <itoa>
80105626:	83 c4 10             	add    $0x10,%esp
	strcpy(data + strlen(data), "\n");
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	53                   	push   %ebx
8010562d:	e8 0e 08 00 00       	call   80105e40 <strlen>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	01 d8                	add    %ebx,%eax
80105637:	31 d2                	xor    %edx,%edx
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105640:	0f b6 8a 53 92 10 80 	movzbl -0x7fef6dad(%edx),%ecx
80105647:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010564a:	83 c2 01             	add    $0x1,%edx
8010564d:	84 c9                	test   %cl,%cl
8010564f:	75 ef                	jne    80105640 <read_inodeinfo_file.part.3+0x260>
	if (off + n > strlen(data))
80105651:	8b b5 e4 fe ff ff    	mov    -0x11c(%ebp),%esi
80105657:	03 75 08             	add    0x8(%ebp),%esi
8010565a:	83 ec 0c             	sub    $0xc,%esp
8010565d:	53                   	push   %ebx
8010565e:	e8 dd 07 00 00       	call   80105e40 <strlen>
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	39 c6                	cmp    %eax,%esi
80105668:	7f 46                	jg     801056b0 <read_inodeinfo_file.part.3+0x2d0>
	memmove(dst, (char*)(&data) + off, n);
8010566a:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
80105670:	83 ec 04             	sub    $0x4,%esp
80105673:	ff 75 08             	pushl  0x8(%ebp)
80105676:	53                   	push   %ebx
80105677:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
8010567d:	e8 4e 06 00 00       	call   80105cd0 <memmove>
}
80105682:	8b 45 08             	mov    0x8(%ebp),%eax
80105685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105688:	5b                   	pop    %ebx
80105689:	5e                   	pop    %esi
8010568a:	5f                   	pop    %edi
8010568b:	5d                   	pop    %ebp
8010568c:	c3                   	ret    
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
    itoa(data + strlen(data), 0);
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	53                   	push   %ebx
80105694:	e8 a7 07 00 00       	call   80105e40 <strlen>
80105699:	5e                   	pop    %esi
8010569a:	5f                   	pop    %edi
8010569b:	01 d8                	add    %ebx,%eax
8010569d:	6a 00                	push   $0x0
8010569f:	50                   	push   %eax
801056a0:	e8 3b f4 ff ff       	call   80104ae0 <itoa>
801056a5:	83 c4 10             	add    $0x10,%esp
801056a8:	e9 7c ff ff ff       	jmp    80105629 <read_inodeinfo_file.part.3+0x249>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
		n = strlen(data) - off;
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	53                   	push   %ebx
801056b4:	e8 87 07 00 00       	call   80105e40 <strlen>
801056b9:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	89 45 08             	mov    %eax,0x8(%ebp)
801056c5:	eb a3                	jmp    8010566a <read_inodeinfo_file.part.3+0x28a>
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    strcpy(data + strlen(data), "DIR");
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 67 07 00 00       	call   80105e40 <strlen>
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	01 d8                	add    %ebx,%eax
801056de:	31 d2                	xor    %edx,%edx
  while((*s++ = *t++) != 0)
801056e0:	0f b6 8a f5 87 10 80 	movzbl -0x7fef780b(%edx),%ecx
801056e7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801056ea:	83 c2 01             	add    $0x1,%edx
801056ed:	84 c9                	test   %cl,%cl
801056ef:	75 ef                	jne    801056e0 <read_inodeinfo_file.part.3+0x300>
801056f1:	0f b7 46 50          	movzwl 0x50(%esi),%eax
  if(ip->type == T_FILE)
801056f5:	66 83 f8 02          	cmp    $0x2,%ax
801056f9:	0f 85 fa fd ff ff    	jne    801054f9 <read_inodeinfo_file.part.3+0x119>
    strcpy(data + strlen(data), "FILE");
801056ff:	83 ec 0c             	sub    $0xc,%esp
80105702:	53                   	push   %ebx
80105703:	e8 38 07 00 00       	call   80105e40 <strlen>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	01 d8                	add    %ebx,%eax
8010570d:	31 d2                	xor    %edx,%edx
8010570f:	90                   	nop
  while((*s++ = *t++) != 0)
80105710:	0f b6 8a 9d 8e 10 80 	movzbl -0x7fef7163(%edx),%ecx
80105717:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010571a:	83 c2 01             	add    $0x1,%edx
8010571d:	84 c9                	test   %cl,%cl
8010571f:	75 ef                	jne    80105710 <read_inodeinfo_file.part.3+0x330>
80105721:	0f b7 46 50          	movzwl 0x50(%esi),%eax
  if(ip->type == T_DEV)
80105725:	66 83 f8 03          	cmp    $0x3,%ax
80105729:	0f 85 d4 fd ff ff    	jne    80105503 <read_inodeinfo_file.part.3+0x123>
    strcpy(data + strlen(data), "DEV");
8010572f:	83 ec 0c             	sub    $0xc,%esp
80105732:	53                   	push   %ebx
80105733:	e8 08 07 00 00       	call   80105e40 <strlen>
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	01 d8                	add    %ebx,%eax
8010573d:	31 d2                	xor    %edx,%edx
8010573f:	90                   	nop
  while((*s++ = *t++) != 0)
80105740:	0f b6 8a a2 8e 10 80 	movzbl -0x7fef715e(%edx),%ecx
80105747:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010574a:	83 c2 01             	add    $0x1,%edx
8010574d:	84 c9                	test   %cl,%cl
8010574f:	75 ef                	jne    80105740 <read_inodeinfo_file.part.3+0x360>
80105751:	e9 ad fd ff ff       	jmp    80105503 <read_inodeinfo_file.part.3+0x123>
80105756:	8d 76 00             	lea    0x0(%esi),%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105760 <read_inodeinfo_file>:
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
80105764:	8b 5d 14             	mov    0x14(%ebp),%ebx
80105767:	8b 45 08             	mov    0x8(%ebp),%eax
8010576a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010576d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if (n == sizeof(struct dirent))
80105770:	83 fb 10             	cmp    $0x10,%ebx
80105773:	74 0b                	je     80105780 <read_inodeinfo_file+0x20>
80105775:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80105778:	5b                   	pop    %ebx
80105779:	5d                   	pop    %ebp
8010577a:	e9 61 fc ff ff       	jmp    801053e0 <read_inodeinfo_file.part.3>
8010577f:	90                   	nop
80105780:	31 c0                	xor    %eax,%eax
80105782:	5b                   	pop    %ebx
80105783:	5d                   	pop    %ebp
80105784:	c3                   	ret    
80105785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <read_path_level_2>:
{
80105790:	55                   	push   %ebp
  switch (ip->inum/100) {
80105791:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
{
80105796:	89 e5                	mov    %esp,%ebp
80105798:	57                   	push   %edi
80105799:	56                   	push   %esi
8010579a:	53                   	push   %ebx
8010579b:	83 ec 1c             	sub    $0x1c,%esp
8010579e:	8b 75 08             	mov    0x8(%ebp),%esi
801057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801057a7:	8b 7d 14             	mov    0x14(%ebp),%edi
  switch (ip->inum/100) {
801057aa:	8b 5e 04             	mov    0x4(%esi),%ebx
{
801057ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  switch (ip->inum/100) {
801057b0:	89 d8                	mov    %ebx,%eax
801057b2:	f7 e2                	mul    %edx
801057b4:	c1 ea 05             	shr    $0x5,%edx
801057b7:	83 fa 08             	cmp    $0x8,%edx
801057ba:	74 5c                	je     80105818 <read_path_level_2+0x88>
801057bc:	83 fa 09             	cmp    $0x9,%edx
801057bf:	74 37                	je     801057f8 <read_path_level_2+0x68>
801057c1:	83 fa 07             	cmp    $0x7,%edx
801057c4:	74 22                	je     801057e8 <read_path_level_2+0x58>
      cprintf("level 2 no case for inum=%d\n", ip->inum);
801057c6:	83 ec 08             	sub    $0x8,%esp
801057c9:	53                   	push   %ebx
801057ca:	68 d6 8e 10 80       	push   $0x80108ed6
801057cf:	e8 8c ae ff ff       	call   80100660 <cprintf>
	return 0;
801057d4:	83 c4 10             	add    $0x10,%esp
}
801057d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057da:	31 c0                	xor    %eax,%eax
801057dc:	5b                   	pop    %ebx
801057dd:	5e                   	pop    %esi
801057de:	5f                   	pop    %edi
801057df:	5d                   	pop    %ebp
801057e0:	c3                   	ret    
801057e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057eb:	5b                   	pop    %ebx
801057ec:	5e                   	pop    %esi
801057ed:	5f                   	pop    %edi
801057ee:	5d                   	pop    %ebp
      return read_procfs_name(ip, dst, off, n);
801057ef:	e9 3c f0 ff ff       	jmp    80104830 <read_procfs_name>
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (n == sizeof(struct dirent))
801057f8:	83 ff 10             	cmp    $0x10,%edi
801057fb:	74 da                	je     801057d7 <read_path_level_2+0x47>
801057fd:	89 7d 08             	mov    %edi,0x8(%ebp)
80105800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80105803:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105806:	89 f0                	mov    %esi,%eax
80105808:	5b                   	pop    %ebx
80105809:	5e                   	pop    %esi
8010580a:	5f                   	pop    %edi
8010580b:	5d                   	pop    %ebp
8010580c:	e9 cf fb ff ff       	jmp    801053e0 <read_inodeinfo_file.part.3>
80105811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105818:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010581b:	5b                   	pop    %ebx
8010581c:	5e                   	pop    %esi
8010581d:	5f                   	pop    %edi
8010581e:	5d                   	pop    %ebp
      return read_procfs_status(ip, dst, off, n);
8010581f:	e9 fc ee ff ff       	jmp    80104720 <read_procfs_status>
80105824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010582a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105830 <procfsread>:
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	83 ec 08             	sub    $0x8,%esp
  switch (ip->minor){
80105836:	8b 45 08             	mov    0x8(%ebp),%eax
80105839:	0f bf 40 54          	movswl 0x54(%eax),%eax
8010583d:	66 83 f8 01          	cmp    $0x1,%ax
80105841:	74 4d                	je     80105890 <procfsread+0x60>
80105843:	66 83 f8 02          	cmp    $0x2,%ax
80105847:	74 37                	je     80105880 <procfsread+0x50>
80105849:	66 85 c0             	test   %ax,%ax
8010584c:	74 22                	je     80105870 <procfsread+0x40>
      cprintf("procfsread minor: %d", ip->minor);
8010584e:	83 ec 08             	sub    $0x8,%esp
80105851:	50                   	push   %eax
80105852:	68 f3 8e 10 80       	push   $0x80108ef3
80105857:	e8 04 ae ff ff       	call   80100660 <cprintf>
      return -1;
8010585c:	83 c4 10             	add    $0x10,%esp
}
8010585f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105864:	c9                   	leave  
80105865:	c3                   	ret    
80105866:	8d 76 00             	lea    0x0(%esi),%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105870:	c9                   	leave  
      return read_path_level_0(ip,dst,off,n);
80105871:	e9 2a f4 ff ff       	jmp    80104ca0 <read_path_level_0>
80105876:	8d 76 00             	lea    0x0(%esi),%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80105880:	c9                   	leave  
      return read_path_level_2(ip,dst,off,n);
80105881:	e9 0a ff ff ff       	jmp    80105790 <read_path_level_2>
80105886:	8d 76 00             	lea    0x0(%esi),%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80105890:	c9                   	leave  
      return read_path_level_1(ip,dst,off,n);
80105891:	e9 da fa ff ff       	jmp    80105370 <read_path_level_1>
80105896:	66 90                	xchg   %ax,%ax
80105898:	66 90                	xchg   %ax,%ax
8010589a:	66 90                	xchg   %ax,%ax
8010589c:	66 90                	xchg   %ax,%ax
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 0c             	sub    $0xc,%esp
801058a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801058aa:	68 65 8f 10 80       	push   $0x80108f65
801058af:	8d 43 04             	lea    0x4(%ebx),%eax
801058b2:	50                   	push   %eax
801058b3:	e8 18 01 00 00       	call   801059d0 <initlock>
  lk->name = name;
801058b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801058bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801058c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801058c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801058cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801058ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058d1:	c9                   	leave  
801058d2:	c3                   	ret    
801058d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	53                   	push   %ebx
801058e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801058e8:	83 ec 0c             	sub    $0xc,%esp
801058eb:	8d 73 04             	lea    0x4(%ebx),%esi
801058ee:	56                   	push   %esi
801058ef:	e8 1c 02 00 00       	call   80105b10 <acquire>
  while (lk->locked) {
801058f4:	8b 13                	mov    (%ebx),%edx
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	85 d2                	test   %edx,%edx
801058fb:	74 16                	je     80105913 <acquiresleep+0x33>
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	56                   	push   %esi
80105904:	53                   	push   %ebx
80105905:	e8 d6 e8 ff ff       	call   801041e0 <sleep>
  while (lk->locked) {
8010590a:	8b 03                	mov    (%ebx),%eax
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	85 c0                	test   %eax,%eax
80105911:	75 ed                	jne    80105900 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105913:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105919:	e8 22 e3 ff ff       	call   80103c40 <myproc>
8010591e:	8b 40 10             	mov    0x10(%eax),%eax
80105921:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105924:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105927:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010592a:	5b                   	pop    %ebx
8010592b:	5e                   	pop    %esi
8010592c:	5d                   	pop    %ebp
  release(&lk->lk);
8010592d:	e9 9e 02 00 00       	jmp    80105bd0 <release>
80105932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	8d 73 04             	lea    0x4(%ebx),%esi
8010594e:	56                   	push   %esi
8010594f:	e8 bc 01 00 00       	call   80105b10 <acquire>
  lk->locked = 0;
80105954:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010595a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105961:	89 1c 24             	mov    %ebx,(%esp)
80105964:	e8 27 ea ff ff       	call   80104390 <wakeup>
  release(&lk->lk);
80105969:	89 75 08             	mov    %esi,0x8(%ebp)
8010596c:	83 c4 10             	add    $0x10,%esp
}
8010596f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105972:	5b                   	pop    %ebx
80105973:	5e                   	pop    %esi
80105974:	5d                   	pop    %ebp
  release(&lk->lk);
80105975:	e9 56 02 00 00       	jmp    80105bd0 <release>
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105980 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
80105985:	53                   	push   %ebx
80105986:	31 ff                	xor    %edi,%edi
80105988:	83 ec 18             	sub    $0x18,%esp
8010598b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010598e:	8d 73 04             	lea    0x4(%ebx),%esi
80105991:	56                   	push   %esi
80105992:	e8 79 01 00 00       	call   80105b10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105997:	8b 03                	mov    (%ebx),%eax
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	85 c0                	test   %eax,%eax
8010599e:	74 13                	je     801059b3 <holdingsleep+0x33>
801059a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801059a3:	e8 98 e2 ff ff       	call   80103c40 <myproc>
801059a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801059ab:	0f 94 c0             	sete   %al
801059ae:	0f b6 c0             	movzbl %al,%eax
801059b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801059b3:	83 ec 0c             	sub    $0xc,%esp
801059b6:	56                   	push   %esi
801059b7:	e8 14 02 00 00       	call   80105bd0 <release>
  return r;
}
801059bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059bf:	89 f8                	mov    %edi,%eax
801059c1:	5b                   	pop    %ebx
801059c2:	5e                   	pop    %esi
801059c3:	5f                   	pop    %edi
801059c4:	5d                   	pop    %ebp
801059c5:	c3                   	ret    
801059c6:	66 90                	xchg   %ax,%ax
801059c8:	66 90                	xchg   %ax,%ax
801059ca:	66 90                	xchg   %ax,%ax
801059cc:	66 90                	xchg   %ax,%ax
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801059d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801059d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801059df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801059e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801059e9:	5d                   	pop    %ebp
801059ea:	c3                   	ret    
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801059f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801059f1:	31 d2                	xor    %edx,%edx
{
801059f3:	89 e5                	mov    %esp,%ebp
801059f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801059f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801059f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801059fc:	83 e8 08             	sub    $0x8,%eax
801059ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105a00:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105a06:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105a0c:	77 1a                	ja     80105a28 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105a0e:	8b 58 04             	mov    0x4(%eax),%ebx
80105a11:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105a14:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105a17:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105a19:	83 fa 0a             	cmp    $0xa,%edx
80105a1c:	75 e2                	jne    80105a00 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105a1e:	5b                   	pop    %ebx
80105a1f:	5d                   	pop    %ebp
80105a20:	c3                   	ret    
80105a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a28:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105a2b:	83 c1 28             	add    $0x28,%ecx
80105a2e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105a36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105a39:	39 c1                	cmp    %eax,%ecx
80105a3b:	75 f3                	jne    80105a30 <getcallerpcs+0x40>
}
80105a3d:	5b                   	pop    %ebx
80105a3e:	5d                   	pop    %ebp
80105a3f:	c3                   	ret    

80105a40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
80105a44:	83 ec 04             	sub    $0x4,%esp
80105a47:	9c                   	pushf  
80105a48:	5b                   	pop    %ebx
  asm volatile("cli");
80105a49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80105a4a:	e8 51 e1 ff ff       	call   80103ba0 <mycpu>
80105a4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105a55:	85 c0                	test   %eax,%eax
80105a57:	75 11                	jne    80105a6a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105a59:	81 e3 00 02 00 00    	and    $0x200,%ebx
80105a5f:	e8 3c e1 ff ff       	call   80103ba0 <mycpu>
80105a64:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80105a6a:	e8 31 e1 ff ff       	call   80103ba0 <mycpu>
80105a6f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105a76:	83 c4 04             	add    $0x4,%esp
80105a79:	5b                   	pop    %ebx
80105a7a:	5d                   	pop    %ebp
80105a7b:	c3                   	ret    
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <popcli>:

void
popcli(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105a86:	9c                   	pushf  
80105a87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105a88:	f6 c4 02             	test   $0x2,%ah
80105a8b:	75 35                	jne    80105ac2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105a8d:	e8 0e e1 ff ff       	call   80103ba0 <mycpu>
80105a92:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105a99:	78 34                	js     80105acf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105a9b:	e8 00 e1 ff ff       	call   80103ba0 <mycpu>
80105aa0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105aa6:	85 d2                	test   %edx,%edx
80105aa8:	74 06                	je     80105ab0 <popcli+0x30>
    sti();
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105ab0:	e8 eb e0 ff ff       	call   80103ba0 <mycpu>
80105ab5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105abb:	85 c0                	test   %eax,%eax
80105abd:	74 eb                	je     80105aaa <popcli+0x2a>
  asm volatile("sti");
80105abf:	fb                   	sti    
}
80105ac0:	c9                   	leave  
80105ac1:	c3                   	ret    
    panic("popcli - interruptible");
80105ac2:	83 ec 0c             	sub    $0xc,%esp
80105ac5:	68 70 8f 10 80       	push   $0x80108f70
80105aca:	e8 c1 a8 ff ff       	call   80100390 <panic>
    panic("popcli");
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	68 87 8f 10 80       	push   $0x80108f87
80105ad7:	e8 b4 a8 ff ff       	call   80100390 <panic>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <holding>:
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
80105ae5:	8b 75 08             	mov    0x8(%ebp),%esi
80105ae8:	31 db                	xor    %ebx,%ebx
  pushcli();
80105aea:	e8 51 ff ff ff       	call   80105a40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105aef:	8b 06                	mov    (%esi),%eax
80105af1:	85 c0                	test   %eax,%eax
80105af3:	74 10                	je     80105b05 <holding+0x25>
80105af5:	8b 5e 08             	mov    0x8(%esi),%ebx
80105af8:	e8 a3 e0 ff ff       	call   80103ba0 <mycpu>
80105afd:	39 c3                	cmp    %eax,%ebx
80105aff:	0f 94 c3             	sete   %bl
80105b02:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105b05:	e8 76 ff ff ff       	call   80105a80 <popcli>
}
80105b0a:	89 d8                	mov    %ebx,%eax
80105b0c:	5b                   	pop    %ebx
80105b0d:	5e                   	pop    %esi
80105b0e:	5d                   	pop    %ebp
80105b0f:	c3                   	ret    

80105b10 <acquire>:
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	56                   	push   %esi
80105b14:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105b15:	e8 26 ff ff ff       	call   80105a40 <pushcli>
  if(holding(lk))
80105b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	53                   	push   %ebx
80105b21:	e8 ba ff ff ff       	call   80105ae0 <holding>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	0f 85 83 00 00 00    	jne    80105bb4 <acquire+0xa4>
80105b31:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105b33:	ba 01 00 00 00       	mov    $0x1,%edx
80105b38:	eb 09                	jmp    80105b43 <acquire+0x33>
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105b43:	89 d0                	mov    %edx,%eax
80105b45:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105b48:	85 c0                	test   %eax,%eax
80105b4a:	75 f4                	jne    80105b40 <acquire+0x30>
  __sync_synchronize();
80105b4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105b54:	e8 47 e0 ff ff       	call   80103ba0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105b59:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80105b5c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80105b5f:	89 e8                	mov    %ebp,%eax
80105b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105b68:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80105b6e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105b74:	77 1a                	ja     80105b90 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105b76:	8b 48 04             	mov    0x4(%eax),%ecx
80105b79:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80105b7c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105b7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105b81:	83 fe 0a             	cmp    $0xa,%esi
80105b84:	75 e2                	jne    80105b68 <acquire+0x58>
}
80105b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b89:	5b                   	pop    %ebx
80105b8a:	5e                   	pop    %esi
80105b8b:	5d                   	pop    %ebp
80105b8c:	c3                   	ret    
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
80105b90:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105b93:	83 c2 28             	add    $0x28,%edx
80105b96:	8d 76 00             	lea    0x0(%esi),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105ba6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105ba9:	39 d0                	cmp    %edx,%eax
80105bab:	75 f3                	jne    80105ba0 <acquire+0x90>
}
80105bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bb0:	5b                   	pop    %ebx
80105bb1:	5e                   	pop    %esi
80105bb2:	5d                   	pop    %ebp
80105bb3:	c3                   	ret    
    panic("acquire");
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	68 8e 8f 10 80       	push   $0x80108f8e
80105bbc:	e8 cf a7 ff ff       	call   80100390 <panic>
80105bc1:	eb 0d                	jmp    80105bd0 <release>
80105bc3:	90                   	nop
80105bc4:	90                   	nop
80105bc5:	90                   	nop
80105bc6:	90                   	nop
80105bc7:	90                   	nop
80105bc8:	90                   	nop
80105bc9:	90                   	nop
80105bca:	90                   	nop
80105bcb:	90                   	nop
80105bcc:	90                   	nop
80105bcd:	90                   	nop
80105bce:	90                   	nop
80105bcf:	90                   	nop

80105bd0 <release>:
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
80105bd4:	83 ec 10             	sub    $0x10,%esp
80105bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80105bda:	53                   	push   %ebx
80105bdb:	e8 00 ff ff ff       	call   80105ae0 <holding>
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	85 c0                	test   %eax,%eax
80105be5:	74 22                	je     80105c09 <release+0x39>
  lk->pcs[0] = 0;
80105be7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105bee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105bf5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105bfa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c03:	c9                   	leave  
  popcli();
80105c04:	e9 77 fe ff ff       	jmp    80105a80 <popcli>
    panic("release");
80105c09:	83 ec 0c             	sub    $0xc,%esp
80105c0c:	68 96 8f 10 80       	push   $0x80108f96
80105c11:	e8 7a a7 ff ff       	call   80100390 <panic>
80105c16:	66 90                	xchg   %ax,%ax
80105c18:	66 90                	xchg   %ax,%ax
80105c1a:	66 90                	xchg   %ax,%ax
80105c1c:	66 90                	xchg   %ax,%ax
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	57                   	push   %edi
80105c24:	53                   	push   %ebx
80105c25:	8b 55 08             	mov    0x8(%ebp),%edx
80105c28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80105c2b:	f6 c2 03             	test   $0x3,%dl
80105c2e:	75 05                	jne    80105c35 <memset+0x15>
80105c30:	f6 c1 03             	test   $0x3,%cl
80105c33:	74 13                	je     80105c48 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105c35:	89 d7                	mov    %edx,%edi
80105c37:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c3a:	fc                   	cld    
80105c3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80105c3d:	5b                   	pop    %ebx
80105c3e:	89 d0                	mov    %edx,%eax
80105c40:	5f                   	pop    %edi
80105c41:	5d                   	pop    %ebp
80105c42:	c3                   	ret    
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105c48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105c4c:	c1 e9 02             	shr    $0x2,%ecx
80105c4f:	89 f8                	mov    %edi,%eax
80105c51:	89 fb                	mov    %edi,%ebx
80105c53:	c1 e0 18             	shl    $0x18,%eax
80105c56:	c1 e3 10             	shl    $0x10,%ebx
80105c59:	09 d8                	or     %ebx,%eax
80105c5b:	09 f8                	or     %edi,%eax
80105c5d:	c1 e7 08             	shl    $0x8,%edi
80105c60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105c62:	89 d7                	mov    %edx,%edi
80105c64:	fc                   	cld    
80105c65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105c67:	5b                   	pop    %ebx
80105c68:	89 d0                	mov    %edx,%eax
80105c6a:	5f                   	pop    %edi
80105c6b:	5d                   	pop    %ebp
80105c6c:	c3                   	ret    
80105c6d:	8d 76 00             	lea    0x0(%esi),%esi

80105c70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105c79:	8b 75 08             	mov    0x8(%ebp),%esi
80105c7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105c7f:	85 db                	test   %ebx,%ebx
80105c81:	74 29                	je     80105cac <memcmp+0x3c>
    if(*s1 != *s2)
80105c83:	0f b6 16             	movzbl (%esi),%edx
80105c86:	0f b6 0f             	movzbl (%edi),%ecx
80105c89:	38 d1                	cmp    %dl,%cl
80105c8b:	75 2b                	jne    80105cb8 <memcmp+0x48>
80105c8d:	b8 01 00 00 00       	mov    $0x1,%eax
80105c92:	eb 14                	jmp    80105ca8 <memcmp+0x38>
80105c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80105c9c:	83 c0 01             	add    $0x1,%eax
80105c9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105ca4:	38 ca                	cmp    %cl,%dl
80105ca6:	75 10                	jne    80105cb8 <memcmp+0x48>
  while(n-- > 0){
80105ca8:	39 d8                	cmp    %ebx,%eax
80105caa:	75 ec                	jne    80105c98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80105cac:	5b                   	pop    %ebx
  return 0;
80105cad:	31 c0                	xor    %eax,%eax
}
80105caf:	5e                   	pop    %esi
80105cb0:	5f                   	pop    %edi
80105cb1:	5d                   	pop    %ebp
80105cb2:	c3                   	ret    
80105cb3:	90                   	nop
80105cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105cb8:	0f b6 c2             	movzbl %dl,%eax
}
80105cbb:	5b                   	pop    %ebx
      return *s1 - *s2;
80105cbc:	29 c8                	sub    %ecx,%eax
}
80105cbe:	5e                   	pop    %esi
80105cbf:	5f                   	pop    %edi
80105cc0:	5d                   	pop    %ebp
80105cc1:	c3                   	ret    
80105cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	56                   	push   %esi
80105cd4:	53                   	push   %ebx
80105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105cdb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105cde:	39 c3                	cmp    %eax,%ebx
80105ce0:	73 26                	jae    80105d08 <memmove+0x38>
80105ce2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105ce5:	39 c8                	cmp    %ecx,%eax
80105ce7:	73 1f                	jae    80105d08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105ce9:	85 f6                	test   %esi,%esi
80105ceb:	8d 56 ff             	lea    -0x1(%esi),%edx
80105cee:	74 0f                	je     80105cff <memmove+0x2f>
      *--d = *--s;
80105cf0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105cf4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105cf7:	83 ea 01             	sub    $0x1,%edx
80105cfa:	83 fa ff             	cmp    $0xffffffff,%edx
80105cfd:	75 f1                	jne    80105cf0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105cff:	5b                   	pop    %ebx
80105d00:	5e                   	pop    %esi
80105d01:	5d                   	pop    %ebp
80105d02:	c3                   	ret    
80105d03:	90                   	nop
80105d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105d08:	31 d2                	xor    %edx,%edx
80105d0a:	85 f6                	test   %esi,%esi
80105d0c:	74 f1                	je     80105cff <memmove+0x2f>
80105d0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105d10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105d14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105d17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80105d1a:	39 d6                	cmp    %edx,%esi
80105d1c:	75 f2                	jne    80105d10 <memmove+0x40>
}
80105d1e:	5b                   	pop    %ebx
80105d1f:	5e                   	pop    %esi
80105d20:	5d                   	pop    %ebp
80105d21:	c3                   	ret    
80105d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105d33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105d34:	eb 9a                	jmp    80105cd0 <memmove>
80105d36:	8d 76 00             	lea    0x0(%esi),%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
80105d45:	8b 7d 10             	mov    0x10(%ebp),%edi
80105d48:	53                   	push   %ebx
80105d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80105d4f:	85 ff                	test   %edi,%edi
80105d51:	74 2f                	je     80105d82 <strncmp+0x42>
80105d53:	0f b6 01             	movzbl (%ecx),%eax
80105d56:	0f b6 1e             	movzbl (%esi),%ebx
80105d59:	84 c0                	test   %al,%al
80105d5b:	74 37                	je     80105d94 <strncmp+0x54>
80105d5d:	38 c3                	cmp    %al,%bl
80105d5f:	75 33                	jne    80105d94 <strncmp+0x54>
80105d61:	01 f7                	add    %esi,%edi
80105d63:	eb 13                	jmp    80105d78 <strncmp+0x38>
80105d65:	8d 76 00             	lea    0x0(%esi),%esi
80105d68:	0f b6 01             	movzbl (%ecx),%eax
80105d6b:	84 c0                	test   %al,%al
80105d6d:	74 21                	je     80105d90 <strncmp+0x50>
80105d6f:	0f b6 1a             	movzbl (%edx),%ebx
80105d72:	89 d6                	mov    %edx,%esi
80105d74:	38 d8                	cmp    %bl,%al
80105d76:	75 1c                	jne    80105d94 <strncmp+0x54>
    n--, p++, q++;
80105d78:	8d 56 01             	lea    0x1(%esi),%edx
80105d7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105d7e:	39 fa                	cmp    %edi,%edx
80105d80:	75 e6                	jne    80105d68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105d82:	5b                   	pop    %ebx
    return 0;
80105d83:	31 c0                	xor    %eax,%eax
}
80105d85:	5e                   	pop    %esi
80105d86:	5f                   	pop    %edi
80105d87:	5d                   	pop    %ebp
80105d88:	c3                   	ret    
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105d94:	29 d8                	sub    %ebx,%eax
}
80105d96:	5b                   	pop    %ebx
80105d97:	5e                   	pop    %esi
80105d98:	5f                   	pop    %edi
80105d99:	5d                   	pop    %ebp
80105d9a:	c3                   	ret    
80105d9b:	90                   	nop
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	56                   	push   %esi
80105da4:	53                   	push   %ebx
80105da5:	8b 45 08             	mov    0x8(%ebp),%eax
80105da8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105dae:	89 c2                	mov    %eax,%edx
80105db0:	eb 19                	jmp    80105dcb <strncpy+0x2b>
80105db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105db8:	83 c3 01             	add    $0x1,%ebx
80105dbb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80105dbf:	83 c2 01             	add    $0x1,%edx
80105dc2:	84 c9                	test   %cl,%cl
80105dc4:	88 4a ff             	mov    %cl,-0x1(%edx)
80105dc7:	74 09                	je     80105dd2 <strncpy+0x32>
80105dc9:	89 f1                	mov    %esi,%ecx
80105dcb:	85 c9                	test   %ecx,%ecx
80105dcd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105dd0:	7f e6                	jg     80105db8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105dd2:	31 c9                	xor    %ecx,%ecx
80105dd4:	85 f6                	test   %esi,%esi
80105dd6:	7e 17                	jle    80105def <strncpy+0x4f>
80105dd8:	90                   	nop
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105de0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105de4:	89 f3                	mov    %esi,%ebx
80105de6:	83 c1 01             	add    $0x1,%ecx
80105de9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80105deb:	85 db                	test   %ebx,%ebx
80105ded:	7f f1                	jg     80105de0 <strncpy+0x40>
  return os;
}
80105def:	5b                   	pop    %ebx
80105df0:	5e                   	pop    %esi
80105df1:	5d                   	pop    %ebp
80105df2:	c3                   	ret    
80105df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	56                   	push   %esi
80105e04:	53                   	push   %ebx
80105e05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105e08:	8b 45 08             	mov    0x8(%ebp),%eax
80105e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80105e0e:	85 c9                	test   %ecx,%ecx
80105e10:	7e 26                	jle    80105e38 <safestrcpy+0x38>
80105e12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105e16:	89 c1                	mov    %eax,%ecx
80105e18:	eb 17                	jmp    80105e31 <safestrcpy+0x31>
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105e20:	83 c2 01             	add    $0x1,%edx
80105e23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105e27:	83 c1 01             	add    $0x1,%ecx
80105e2a:	84 db                	test   %bl,%bl
80105e2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80105e2f:	74 04                	je     80105e35 <safestrcpy+0x35>
80105e31:	39 f2                	cmp    %esi,%edx
80105e33:	75 eb                	jne    80105e20 <safestrcpy+0x20>
    ;
  *s = 0;
80105e35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105e38:	5b                   	pop    %ebx
80105e39:	5e                   	pop    %esi
80105e3a:	5d                   	pop    %ebp
80105e3b:	c3                   	ret    
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e40 <strlen>:

int
strlen(const char *s)
{
80105e40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105e41:	31 c0                	xor    %eax,%eax
{
80105e43:	89 e5                	mov    %esp,%ebp
80105e45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105e48:	80 3a 00             	cmpb   $0x0,(%edx)
80105e4b:	74 0c                	je     80105e59 <strlen+0x19>
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
80105e50:	83 c0 01             	add    $0x1,%eax
80105e53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105e57:	75 f7                	jne    80105e50 <strlen+0x10>
    ;
  return n;
}
80105e59:	5d                   	pop    %ebp
80105e5a:	c3                   	ret    

80105e5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105e5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105e5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105e63:	55                   	push   %ebp
  pushl %ebx
80105e64:	53                   	push   %ebx
  pushl %esi
80105e65:	56                   	push   %esi
  pushl %edi
80105e66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105e67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105e69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105e6b:	5f                   	pop    %edi
  popl %esi
80105e6c:	5e                   	pop    %esi
  popl %ebx
80105e6d:	5b                   	pop    %ebx
  popl %ebp
80105e6e:	5d                   	pop    %ebp
  ret
80105e6f:	c3                   	ret    

80105e70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	53                   	push   %ebx
80105e74:	83 ec 04             	sub    $0x4,%esp
80105e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105e7a:	e8 c1 dd ff ff       	call   80103c40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105e7f:	8b 00                	mov    (%eax),%eax
80105e81:	39 d8                	cmp    %ebx,%eax
80105e83:	76 1b                	jbe    80105ea0 <fetchint+0x30>
80105e85:	8d 53 04             	lea    0x4(%ebx),%edx
80105e88:	39 d0                	cmp    %edx,%eax
80105e8a:	72 14                	jb     80105ea0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e8f:	8b 13                	mov    (%ebx),%edx
80105e91:	89 10                	mov    %edx,(%eax)
  return 0;
80105e93:	31 c0                	xor    %eax,%eax
}
80105e95:	83 c4 04             	add    $0x4,%esp
80105e98:	5b                   	pop    %ebx
80105e99:	5d                   	pop    %ebp
80105e9a:	c3                   	ret    
80105e9b:	90                   	nop
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea5:	eb ee                	jmp    80105e95 <fetchint+0x25>
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105eb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	53                   	push   %ebx
80105eb4:	83 ec 04             	sub    $0x4,%esp
80105eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105eba:	e8 81 dd ff ff       	call   80103c40 <myproc>

  if(addr >= curproc->sz)
80105ebf:	39 18                	cmp    %ebx,(%eax)
80105ec1:	76 29                	jbe    80105eec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ec6:	89 da                	mov    %ebx,%edx
80105ec8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80105eca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80105ecc:	39 c3                	cmp    %eax,%ebx
80105ece:	73 1c                	jae    80105eec <fetchstr+0x3c>
    if(*s == 0)
80105ed0:	80 3b 00             	cmpb   $0x0,(%ebx)
80105ed3:	75 10                	jne    80105ee5 <fetchstr+0x35>
80105ed5:	eb 39                	jmp    80105f10 <fetchstr+0x60>
80105ed7:	89 f6                	mov    %esi,%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ee0:	80 3a 00             	cmpb   $0x0,(%edx)
80105ee3:	74 1b                	je     80105f00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105ee5:	83 c2 01             	add    $0x1,%edx
80105ee8:	39 d0                	cmp    %edx,%eax
80105eea:	77 f4                	ja     80105ee0 <fetchstr+0x30>
    return -1;
80105eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105ef1:	83 c4 04             	add    $0x4,%esp
80105ef4:	5b                   	pop    %ebx
80105ef5:	5d                   	pop    %ebp
80105ef6:	c3                   	ret    
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f00:	83 c4 04             	add    $0x4,%esp
80105f03:	89 d0                	mov    %edx,%eax
80105f05:	29 d8                	sub    %ebx,%eax
80105f07:	5b                   	pop    %ebx
80105f08:	5d                   	pop    %ebp
80105f09:	c3                   	ret    
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105f10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105f12:	eb dd                	jmp    80105ef1 <fetchstr+0x41>
80105f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	56                   	push   %esi
80105f24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f25:	e8 16 dd ff ff       	call   80103c40 <myproc>
80105f2a:	8b 40 18             	mov    0x18(%eax),%eax
80105f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80105f30:	8b 40 44             	mov    0x44(%eax),%eax
80105f33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105f36:	e8 05 dd ff ff       	call   80103c40 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f40:	39 c6                	cmp    %eax,%esi
80105f42:	73 1c                	jae    80105f60 <argint+0x40>
80105f44:	8d 53 08             	lea    0x8(%ebx),%edx
80105f47:	39 d0                	cmp    %edx,%eax
80105f49:	72 15                	jb     80105f60 <argint+0x40>
  *ip = *(int*)(addr);
80105f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f4e:	8b 53 04             	mov    0x4(%ebx),%edx
80105f51:	89 10                	mov    %edx,(%eax)
  return 0;
80105f53:	31 c0                	xor    %eax,%eax
}
80105f55:	5b                   	pop    %ebx
80105f56:	5e                   	pop    %esi
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f65:	eb ee                	jmp    80105f55 <argint+0x35>
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	56                   	push   %esi
80105f74:	53                   	push   %ebx
80105f75:	83 ec 10             	sub    $0x10,%esp
80105f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105f7b:	e8 c0 dc ff ff       	call   80103c40 <myproc>
80105f80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f85:	83 ec 08             	sub    $0x8,%esp
80105f88:	50                   	push   %eax
80105f89:	ff 75 08             	pushl  0x8(%ebp)
80105f8c:	e8 8f ff ff ff       	call   80105f20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105f91:	83 c4 10             	add    $0x10,%esp
80105f94:	85 c0                	test   %eax,%eax
80105f96:	78 28                	js     80105fc0 <argptr+0x50>
80105f98:	85 db                	test   %ebx,%ebx
80105f9a:	78 24                	js     80105fc0 <argptr+0x50>
80105f9c:	8b 16                	mov    (%esi),%edx
80105f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa1:	39 c2                	cmp    %eax,%edx
80105fa3:	76 1b                	jbe    80105fc0 <argptr+0x50>
80105fa5:	01 c3                	add    %eax,%ebx
80105fa7:	39 da                	cmp    %ebx,%edx
80105fa9:	72 15                	jb     80105fc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105fab:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fae:	89 02                	mov    %eax,(%edx)
  return 0;
80105fb0:	31 c0                	xor    %eax,%eax
}
80105fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fb5:	5b                   	pop    %ebx
80105fb6:	5e                   	pop    %esi
80105fb7:	5d                   	pop    %ebp
80105fb8:	c3                   	ret    
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc5:	eb eb                	jmp    80105fb2 <argptr+0x42>
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fd9:	50                   	push   %eax
80105fda:	ff 75 08             	pushl  0x8(%ebp)
80105fdd:	e8 3e ff ff ff       	call   80105f20 <argint>
80105fe2:	83 c4 10             	add    $0x10,%esp
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	78 17                	js     80106000 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105fe9:	83 ec 08             	sub    $0x8,%esp
80105fec:	ff 75 0c             	pushl  0xc(%ebp)
80105fef:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff2:	e8 b9 fe ff ff       	call   80105eb0 <fetchstr>
80105ff7:	83 c4 10             	add    $0x10,%esp
}
80105ffa:	c9                   	leave  
80105ffb:	c3                   	ret    
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106005:	c9                   	leave  
80106006:	c3                   	ret    
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106010 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	53                   	push   %ebx
80106014:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106017:	e8 24 dc ff ff       	call   80103c40 <myproc>
8010601c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010601e:	8b 40 18             	mov    0x18(%eax),%eax
80106021:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106024:	8d 50 ff             	lea    -0x1(%eax),%edx
80106027:	83 fa 14             	cmp    $0x14,%edx
8010602a:	77 1c                	ja     80106048 <syscall+0x38>
8010602c:	8b 14 85 c0 8f 10 80 	mov    -0x7fef7040(,%eax,4),%edx
80106033:	85 d2                	test   %edx,%edx
80106035:	74 11                	je     80106048 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80106037:	ff d2                	call   *%edx
80106039:	8b 53 18             	mov    0x18(%ebx),%edx
8010603c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010603f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106042:	c9                   	leave  
80106043:	c3                   	ret    
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80106048:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106049:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010604c:	50                   	push   %eax
8010604d:	ff 73 10             	pushl  0x10(%ebx)
80106050:	68 9e 8f 10 80       	push   $0x80108f9e
80106055:	e8 06 a6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010605a:	8b 43 18             	mov    0x18(%ebx),%eax
8010605d:	83 c4 10             	add    $0x10,%esp
80106060:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80106067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010606a:	c9                   	leave  
8010606b:	c3                   	ret    
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106076:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80106079:	83 ec 44             	sub    $0x44,%esp
8010607c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010607f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80106082:	56                   	push   %esi
80106083:	50                   	push   %eax
{
80106084:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80106087:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010608a:	e8 61 c1 ff ff       	call   801021f0 <nameiparent>
8010608f:	83 c4 10             	add    $0x10,%esp
80106092:	85 c0                	test   %eax,%eax
80106094:	0f 84 46 01 00 00    	je     801061e0 <create+0x170>
    return 0;
  ilock(dp);
8010609a:	83 ec 0c             	sub    $0xc,%esp
8010609d:	89 c3                	mov    %eax,%ebx
8010609f:	50                   	push   %eax
801060a0:	e8 3b b8 ff ff       	call   801018e0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801060a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801060a8:	83 c4 0c             	add    $0xc,%esp
801060ab:	50                   	push   %eax
801060ac:	56                   	push   %esi
801060ad:	53                   	push   %ebx
801060ae:	e8 5d bd ff ff       	call   80101e10 <dirlookup>
801060b3:	83 c4 10             	add    $0x10,%esp
801060b6:	85 c0                	test   %eax,%eax
801060b8:	89 c7                	mov    %eax,%edi
801060ba:	74 34                	je     801060f0 <create+0x80>
    iunlockput(dp);
801060bc:	83 ec 0c             	sub    $0xc,%esp
801060bf:	53                   	push   %ebx
801060c0:	e8 ab ba ff ff       	call   80101b70 <iunlockput>
    ilock(ip);
801060c5:	89 3c 24             	mov    %edi,(%esp)
801060c8:	e8 13 b8 ff ff       	call   801018e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801060d5:	0f 85 95 00 00 00    	jne    80106170 <create+0x100>
801060db:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801060e0:	0f 85 8a 00 00 00    	jne    80106170 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801060e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e9:	89 f8                	mov    %edi,%eax
801060eb:	5b                   	pop    %ebx
801060ec:	5e                   	pop    %esi
801060ed:	5f                   	pop    %edi
801060ee:	5d                   	pop    %ebp
801060ef:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801060f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801060f4:	83 ec 08             	sub    $0x8,%esp
801060f7:	50                   	push   %eax
801060f8:	ff 33                	pushl  (%ebx)
801060fa:	e8 71 b6 ff ff       	call   80101770 <ialloc>
801060ff:	83 c4 10             	add    $0x10,%esp
80106102:	85 c0                	test   %eax,%eax
80106104:	89 c7                	mov    %eax,%edi
80106106:	0f 84 e8 00 00 00    	je     801061f4 <create+0x184>
  ilock(ip);
8010610c:	83 ec 0c             	sub    $0xc,%esp
8010610f:	50                   	push   %eax
80106110:	e8 cb b7 ff ff       	call   801018e0 <ilock>
  ip->major = major;
80106115:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80106119:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010611d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80106121:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80106125:	b8 01 00 00 00       	mov    $0x1,%eax
8010612a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010612e:	89 3c 24             	mov    %edi,(%esp)
80106131:	e8 fa b6 ff ff       	call   80101830 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106136:	83 c4 10             	add    $0x10,%esp
80106139:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010613e:	74 50                	je     80106190 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106140:	83 ec 04             	sub    $0x4,%esp
80106143:	ff 77 04             	pushl  0x4(%edi)
80106146:	56                   	push   %esi
80106147:	53                   	push   %ebx
80106148:	e8 c3 bf ff ff       	call   80102110 <dirlink>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	0f 88 8f 00 00 00    	js     801061e7 <create+0x177>
  iunlockput(dp);
80106158:	83 ec 0c             	sub    $0xc,%esp
8010615b:	53                   	push   %ebx
8010615c:	e8 0f ba ff ff       	call   80101b70 <iunlockput>
  return ip;
80106161:	83 c4 10             	add    $0x10,%esp
}
80106164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106167:	89 f8                	mov    %edi,%eax
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5f                   	pop    %edi
8010616c:	5d                   	pop    %ebp
8010616d:	c3                   	ret    
8010616e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	57                   	push   %edi
    return 0;
80106174:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80106176:	e8 f5 b9 ff ff       	call   80101b70 <iunlockput>
    return 0;
8010617b:	83 c4 10             	add    $0x10,%esp
}
8010617e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106181:	89 f8                	mov    %edi,%eax
80106183:	5b                   	pop    %ebx
80106184:	5e                   	pop    %esi
80106185:	5f                   	pop    %edi
80106186:	5d                   	pop    %ebp
80106187:	c3                   	ret    
80106188:	90                   	nop
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80106190:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106195:	83 ec 0c             	sub    $0xc,%esp
80106198:	53                   	push   %ebx
80106199:	e8 92 b6 ff ff       	call   80101830 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010619e:	83 c4 0c             	add    $0xc,%esp
801061a1:	ff 77 04             	pushl  0x4(%edi)
801061a4:	68 29 8d 10 80       	push   $0x80108d29
801061a9:	57                   	push   %edi
801061aa:	e8 61 bf ff ff       	call   80102110 <dirlink>
801061af:	83 c4 10             	add    $0x10,%esp
801061b2:	85 c0                	test   %eax,%eax
801061b4:	78 1c                	js     801061d2 <create+0x162>
801061b6:	83 ec 04             	sub    $0x4,%esp
801061b9:	ff 73 04             	pushl  0x4(%ebx)
801061bc:	68 28 8d 10 80       	push   $0x80108d28
801061c1:	57                   	push   %edi
801061c2:	e8 49 bf ff ff       	call   80102110 <dirlink>
801061c7:	83 c4 10             	add    $0x10,%esp
801061ca:	85 c0                	test   %eax,%eax
801061cc:	0f 89 6e ff ff ff    	jns    80106140 <create+0xd0>
      panic("create dots");
801061d2:	83 ec 0c             	sub    $0xc,%esp
801061d5:	68 27 90 10 80       	push   $0x80109027
801061da:	e8 b1 a1 ff ff       	call   80100390 <panic>
801061df:	90                   	nop
    return 0;
801061e0:	31 ff                	xor    %edi,%edi
801061e2:	e9 ff fe ff ff       	jmp    801060e6 <create+0x76>
    panic("create: dirlink");
801061e7:	83 ec 0c             	sub    $0xc,%esp
801061ea:	68 33 90 10 80       	push   $0x80109033
801061ef:	e8 9c a1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801061f4:	83 ec 0c             	sub    $0xc,%esp
801061f7:	68 18 90 10 80       	push   $0x80109018
801061fc:	e8 8f a1 ff ff       	call   80100390 <panic>
80106201:	eb 0d                	jmp    80106210 <argfd.constprop.0>
80106203:	90                   	nop
80106204:	90                   	nop
80106205:	90                   	nop
80106206:	90                   	nop
80106207:	90                   	nop
80106208:	90                   	nop
80106209:	90                   	nop
8010620a:	90                   	nop
8010620b:	90                   	nop
8010620c:	90                   	nop
8010620d:	90                   	nop
8010620e:	90                   	nop
8010620f:	90                   	nop

80106210 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	56                   	push   %esi
80106214:	53                   	push   %ebx
80106215:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80106217:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010621a:	89 d6                	mov    %edx,%esi
8010621c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010621f:	50                   	push   %eax
80106220:	6a 00                	push   $0x0
80106222:	e8 f9 fc ff ff       	call   80105f20 <argint>
80106227:	83 c4 10             	add    $0x10,%esp
8010622a:	85 c0                	test   %eax,%eax
8010622c:	78 2a                	js     80106258 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010622e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106232:	77 24                	ja     80106258 <argfd.constprop.0+0x48>
80106234:	e8 07 da ff ff       	call   80103c40 <myproc>
80106239:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010623c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80106240:	85 c0                	test   %eax,%eax
80106242:	74 14                	je     80106258 <argfd.constprop.0+0x48>
  if(pfd)
80106244:	85 db                	test   %ebx,%ebx
80106246:	74 02                	je     8010624a <argfd.constprop.0+0x3a>
    *pfd = fd;
80106248:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010624a:	89 06                	mov    %eax,(%esi)
  return 0;
8010624c:	31 c0                	xor    %eax,%eax
}
8010624e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106251:	5b                   	pop    %ebx
80106252:	5e                   	pop    %esi
80106253:	5d                   	pop    %ebp
80106254:	c3                   	ret    
80106255:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625d:	eb ef                	jmp    8010624e <argfd.constprop.0+0x3e>
8010625f:	90                   	nop

80106260 <sys_dup>:
{
80106260:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80106261:	31 c0                	xor    %eax,%eax
{
80106263:	89 e5                	mov    %esp,%ebp
80106265:	56                   	push   %esi
80106266:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80106267:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010626a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010626d:	e8 9e ff ff ff       	call   80106210 <argfd.constprop.0>
80106272:	85 c0                	test   %eax,%eax
80106274:	78 42                	js     801062b8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80106276:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106279:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010627b:	e8 c0 d9 ff ff       	call   80103c40 <myproc>
80106280:	eb 0e                	jmp    80106290 <sys_dup+0x30>
80106282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106288:	83 c3 01             	add    $0x1,%ebx
8010628b:	83 fb 10             	cmp    $0x10,%ebx
8010628e:	74 28                	je     801062b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80106290:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106294:	85 d2                	test   %edx,%edx
80106296:	75 f0                	jne    80106288 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80106298:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010629c:	83 ec 0c             	sub    $0xc,%esp
8010629f:	ff 75 f4             	pushl  -0xc(%ebp)
801062a2:	e8 49 ab ff ff       	call   80100df0 <filedup>
  return fd;
801062a7:	83 c4 10             	add    $0x10,%esp
}
801062aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062ad:	89 d8                	mov    %ebx,%eax
801062af:	5b                   	pop    %ebx
801062b0:	5e                   	pop    %esi
801062b1:	5d                   	pop    %ebp
801062b2:	c3                   	ret    
801062b3:	90                   	nop
801062b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801062bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801062c0:	89 d8                	mov    %ebx,%eax
801062c2:	5b                   	pop    %ebx
801062c3:	5e                   	pop    %esi
801062c4:	5d                   	pop    %ebp
801062c5:	c3                   	ret    
801062c6:	8d 76 00             	lea    0x0(%esi),%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062d0 <sys_read>:
{
801062d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801062d1:	31 c0                	xor    %eax,%eax
{
801062d3:	89 e5                	mov    %esp,%ebp
801062d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801062d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801062db:	e8 30 ff ff ff       	call   80106210 <argfd.constprop.0>
801062e0:	85 c0                	test   %eax,%eax
801062e2:	78 4c                	js     80106330 <sys_read+0x60>
801062e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062e7:	83 ec 08             	sub    $0x8,%esp
801062ea:	50                   	push   %eax
801062eb:	6a 02                	push   $0x2
801062ed:	e8 2e fc ff ff       	call   80105f20 <argint>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	85 c0                	test   %eax,%eax
801062f7:	78 37                	js     80106330 <sys_read+0x60>
801062f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062fc:	83 ec 04             	sub    $0x4,%esp
801062ff:	ff 75 f0             	pushl  -0x10(%ebp)
80106302:	50                   	push   %eax
80106303:	6a 01                	push   $0x1
80106305:	e8 66 fc ff ff       	call   80105f70 <argptr>
8010630a:	83 c4 10             	add    $0x10,%esp
8010630d:	85 c0                	test   %eax,%eax
8010630f:	78 1f                	js     80106330 <sys_read+0x60>
  return fileread(f, p, n);
80106311:	83 ec 04             	sub    $0x4,%esp
80106314:	ff 75 f0             	pushl  -0x10(%ebp)
80106317:	ff 75 f4             	pushl  -0xc(%ebp)
8010631a:	ff 75 ec             	pushl  -0x14(%ebp)
8010631d:	e8 3e ac ff ff       	call   80100f60 <fileread>
80106322:	83 c4 10             	add    $0x10,%esp
}
80106325:	c9                   	leave  
80106326:	c3                   	ret    
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106335:	c9                   	leave  
80106336:	c3                   	ret    
80106337:	89 f6                	mov    %esi,%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106340 <sys_write>:
{
80106340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106341:	31 c0                	xor    %eax,%eax
{
80106343:	89 e5                	mov    %esp,%ebp
80106345:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106348:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010634b:	e8 c0 fe ff ff       	call   80106210 <argfd.constprop.0>
80106350:	85 c0                	test   %eax,%eax
80106352:	78 4c                	js     801063a0 <sys_write+0x60>
80106354:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106357:	83 ec 08             	sub    $0x8,%esp
8010635a:	50                   	push   %eax
8010635b:	6a 02                	push   $0x2
8010635d:	e8 be fb ff ff       	call   80105f20 <argint>
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	85 c0                	test   %eax,%eax
80106367:	78 37                	js     801063a0 <sys_write+0x60>
80106369:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010636c:	83 ec 04             	sub    $0x4,%esp
8010636f:	ff 75 f0             	pushl  -0x10(%ebp)
80106372:	50                   	push   %eax
80106373:	6a 01                	push   $0x1
80106375:	e8 f6 fb ff ff       	call   80105f70 <argptr>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	85 c0                	test   %eax,%eax
8010637f:	78 1f                	js     801063a0 <sys_write+0x60>
  return filewrite(f, p, n);
80106381:	83 ec 04             	sub    $0x4,%esp
80106384:	ff 75 f0             	pushl  -0x10(%ebp)
80106387:	ff 75 f4             	pushl  -0xc(%ebp)
8010638a:	ff 75 ec             	pushl  -0x14(%ebp)
8010638d:	e8 5e ac ff ff       	call   80100ff0 <filewrite>
80106392:	83 c4 10             	add    $0x10,%esp
}
80106395:	c9                   	leave  
80106396:	c3                   	ret    
80106397:	89 f6                	mov    %esi,%esi
80106399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801063a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063a5:	c9                   	leave  
801063a6:	c3                   	ret    
801063a7:	89 f6                	mov    %esi,%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <sys_close>:
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801063b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801063b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063bc:	e8 4f fe ff ff       	call   80106210 <argfd.constprop.0>
801063c1:	85 c0                	test   %eax,%eax
801063c3:	78 2b                	js     801063f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801063c5:	e8 76 d8 ff ff       	call   80103c40 <myproc>
801063ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801063cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801063d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801063d7:	00 
  fileclose(f);
801063d8:	ff 75 f4             	pushl  -0xc(%ebp)
801063db:	e8 60 aa ff ff       	call   80100e40 <fileclose>
  return 0;
801063e0:	83 c4 10             	add    $0x10,%esp
801063e3:	31 c0                	xor    %eax,%eax
}
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    
801063e7:	89 f6                	mov    %esi,%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801063f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    
801063f7:	89 f6                	mov    %esi,%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106400 <sys_fstat>:
{
80106400:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106401:	31 c0                	xor    %eax,%eax
{
80106403:	89 e5                	mov    %esp,%ebp
80106405:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106408:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010640b:	e8 00 fe ff ff       	call   80106210 <argfd.constprop.0>
80106410:	85 c0                	test   %eax,%eax
80106412:	78 2c                	js     80106440 <sys_fstat+0x40>
80106414:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106417:	83 ec 04             	sub    $0x4,%esp
8010641a:	6a 14                	push   $0x14
8010641c:	50                   	push   %eax
8010641d:	6a 01                	push   $0x1
8010641f:	e8 4c fb ff ff       	call   80105f70 <argptr>
80106424:	83 c4 10             	add    $0x10,%esp
80106427:	85 c0                	test   %eax,%eax
80106429:	78 15                	js     80106440 <sys_fstat+0x40>
  return filestat(f, st);
8010642b:	83 ec 08             	sub    $0x8,%esp
8010642e:	ff 75 f4             	pushl  -0xc(%ebp)
80106431:	ff 75 f0             	pushl  -0x10(%ebp)
80106434:	e8 d7 aa ff ff       	call   80100f10 <filestat>
80106439:	83 c4 10             	add    $0x10,%esp
}
8010643c:	c9                   	leave  
8010643d:	c3                   	ret    
8010643e:	66 90                	xchg   %ax,%ax
    return -1;
80106440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106445:	c9                   	leave  
80106446:	c3                   	ret    
80106447:	89 f6                	mov    %esi,%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106450 <sys_link>:
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	57                   	push   %edi
80106454:	56                   	push   %esi
80106455:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106456:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106459:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010645c:	50                   	push   %eax
8010645d:	6a 00                	push   $0x0
8010645f:	e8 6c fb ff ff       	call   80105fd0 <argstr>
80106464:	83 c4 10             	add    $0x10,%esp
80106467:	85 c0                	test   %eax,%eax
80106469:	0f 88 fb 00 00 00    	js     8010656a <sys_link+0x11a>
8010646f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106472:	83 ec 08             	sub    $0x8,%esp
80106475:	50                   	push   %eax
80106476:	6a 01                	push   $0x1
80106478:	e8 53 fb ff ff       	call   80105fd0 <argstr>
8010647d:	83 c4 10             	add    $0x10,%esp
80106480:	85 c0                	test   %eax,%eax
80106482:	0f 88 e2 00 00 00    	js     8010656a <sys_link+0x11a>
  begin_op();
80106488:	e8 63 cb ff ff       	call   80102ff0 <begin_op>
  if((ip = namei(old)) == 0){
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	ff 75 d4             	pushl  -0x2c(%ebp)
80106493:	e8 38 bd ff ff       	call   801021d0 <namei>
80106498:	83 c4 10             	add    $0x10,%esp
8010649b:	85 c0                	test   %eax,%eax
8010649d:	89 c3                	mov    %eax,%ebx
8010649f:	0f 84 ea 00 00 00    	je     8010658f <sys_link+0x13f>
  ilock(ip);
801064a5:	83 ec 0c             	sub    $0xc,%esp
801064a8:	50                   	push   %eax
801064a9:	e8 32 b4 ff ff       	call   801018e0 <ilock>
  if(ip->type == T_DIR){
801064ae:	83 c4 10             	add    $0x10,%esp
801064b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801064b6:	0f 84 bb 00 00 00    	je     80106577 <sys_link+0x127>
  ip->nlink++;
801064bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801064c1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801064c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801064c7:	53                   	push   %ebx
801064c8:	e8 63 b3 ff ff       	call   80101830 <iupdate>
  iunlock(ip);
801064cd:	89 1c 24             	mov    %ebx,(%esp)
801064d0:	e8 eb b4 ff ff       	call   801019c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801064d5:	58                   	pop    %eax
801064d6:	5a                   	pop    %edx
801064d7:	57                   	push   %edi
801064d8:	ff 75 d0             	pushl  -0x30(%ebp)
801064db:	e8 10 bd ff ff       	call   801021f0 <nameiparent>
801064e0:	83 c4 10             	add    $0x10,%esp
801064e3:	85 c0                	test   %eax,%eax
801064e5:	89 c6                	mov    %eax,%esi
801064e7:	74 5b                	je     80106544 <sys_link+0xf4>
  ilock(dp);
801064e9:	83 ec 0c             	sub    $0xc,%esp
801064ec:	50                   	push   %eax
801064ed:	e8 ee b3 ff ff       	call   801018e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801064f2:	83 c4 10             	add    $0x10,%esp
801064f5:	8b 03                	mov    (%ebx),%eax
801064f7:	39 06                	cmp    %eax,(%esi)
801064f9:	75 3d                	jne    80106538 <sys_link+0xe8>
801064fb:	83 ec 04             	sub    $0x4,%esp
801064fe:	ff 73 04             	pushl  0x4(%ebx)
80106501:	57                   	push   %edi
80106502:	56                   	push   %esi
80106503:	e8 08 bc ff ff       	call   80102110 <dirlink>
80106508:	83 c4 10             	add    $0x10,%esp
8010650b:	85 c0                	test   %eax,%eax
8010650d:	78 29                	js     80106538 <sys_link+0xe8>
  iunlockput(dp);
8010650f:	83 ec 0c             	sub    $0xc,%esp
80106512:	56                   	push   %esi
80106513:	e8 58 b6 ff ff       	call   80101b70 <iunlockput>
  iput(ip);
80106518:	89 1c 24             	mov    %ebx,(%esp)
8010651b:	e8 f0 b4 ff ff       	call   80101a10 <iput>
  end_op();
80106520:	e8 3b cb ff ff       	call   80103060 <end_op>
  return 0;
80106525:	83 c4 10             	add    $0x10,%esp
80106528:	31 c0                	xor    %eax,%eax
}
8010652a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010652d:	5b                   	pop    %ebx
8010652e:	5e                   	pop    %esi
8010652f:	5f                   	pop    %edi
80106530:	5d                   	pop    %ebp
80106531:	c3                   	ret    
80106532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106538:	83 ec 0c             	sub    $0xc,%esp
8010653b:	56                   	push   %esi
8010653c:	e8 2f b6 ff ff       	call   80101b70 <iunlockput>
    goto bad;
80106541:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106544:	83 ec 0c             	sub    $0xc,%esp
80106547:	53                   	push   %ebx
80106548:	e8 93 b3 ff ff       	call   801018e0 <ilock>
  ip->nlink--;
8010654d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106552:	89 1c 24             	mov    %ebx,(%esp)
80106555:	e8 d6 b2 ff ff       	call   80101830 <iupdate>
  iunlockput(ip);
8010655a:	89 1c 24             	mov    %ebx,(%esp)
8010655d:	e8 0e b6 ff ff       	call   80101b70 <iunlockput>
  end_op();
80106562:	e8 f9 ca ff ff       	call   80103060 <end_op>
  return -1;
80106567:	83 c4 10             	add    $0x10,%esp
}
8010656a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010656d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106572:	5b                   	pop    %ebx
80106573:	5e                   	pop    %esi
80106574:	5f                   	pop    %edi
80106575:	5d                   	pop    %ebp
80106576:	c3                   	ret    
    iunlockput(ip);
80106577:	83 ec 0c             	sub    $0xc,%esp
8010657a:	53                   	push   %ebx
8010657b:	e8 f0 b5 ff ff       	call   80101b70 <iunlockput>
    end_op();
80106580:	e8 db ca ff ff       	call   80103060 <end_op>
    return -1;
80106585:	83 c4 10             	add    $0x10,%esp
80106588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658d:	eb 9b                	jmp    8010652a <sys_link+0xda>
    end_op();
8010658f:	e8 cc ca ff ff       	call   80103060 <end_op>
    return -1;
80106594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106599:	eb 8f                	jmp    8010652a <sys_link+0xda>
8010659b:	90                   	nop
8010659c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_unlink>:
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801065a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801065a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801065ac:	50                   	push   %eax
801065ad:	6a 00                	push   $0x0
801065af:	e8 1c fa ff ff       	call   80105fd0 <argstr>
801065b4:	83 c4 10             	add    $0x10,%esp
801065b7:	85 c0                	test   %eax,%eax
801065b9:	0f 88 77 01 00 00    	js     80106736 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801065bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801065c2:	e8 29 ca ff ff       	call   80102ff0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801065c7:	83 ec 08             	sub    $0x8,%esp
801065ca:	53                   	push   %ebx
801065cb:	ff 75 c0             	pushl  -0x40(%ebp)
801065ce:	e8 1d bc ff ff       	call   801021f0 <nameiparent>
801065d3:	83 c4 10             	add    $0x10,%esp
801065d6:	85 c0                	test   %eax,%eax
801065d8:	89 c6                	mov    %eax,%esi
801065da:	0f 84 60 01 00 00    	je     80106740 <sys_unlink+0x1a0>
  ilock(dp);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	50                   	push   %eax
801065e4:	e8 f7 b2 ff ff       	call   801018e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801065e9:	58                   	pop    %eax
801065ea:	5a                   	pop    %edx
801065eb:	68 29 8d 10 80       	push   $0x80108d29
801065f0:	53                   	push   %ebx
801065f1:	e8 fa b7 ff ff       	call   80101df0 <namecmp>
801065f6:	83 c4 10             	add    $0x10,%esp
801065f9:	85 c0                	test   %eax,%eax
801065fb:	0f 84 03 01 00 00    	je     80106704 <sys_unlink+0x164>
80106601:	83 ec 08             	sub    $0x8,%esp
80106604:	68 28 8d 10 80       	push   $0x80108d28
80106609:	53                   	push   %ebx
8010660a:	e8 e1 b7 ff ff       	call   80101df0 <namecmp>
8010660f:	83 c4 10             	add    $0x10,%esp
80106612:	85 c0                	test   %eax,%eax
80106614:	0f 84 ea 00 00 00    	je     80106704 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010661a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010661d:	83 ec 04             	sub    $0x4,%esp
80106620:	50                   	push   %eax
80106621:	53                   	push   %ebx
80106622:	56                   	push   %esi
80106623:	e8 e8 b7 ff ff       	call   80101e10 <dirlookup>
80106628:	83 c4 10             	add    $0x10,%esp
8010662b:	85 c0                	test   %eax,%eax
8010662d:	89 c3                	mov    %eax,%ebx
8010662f:	0f 84 cf 00 00 00    	je     80106704 <sys_unlink+0x164>
  ilock(ip);
80106635:	83 ec 0c             	sub    $0xc,%esp
80106638:	50                   	push   %eax
80106639:	e8 a2 b2 ff ff       	call   801018e0 <ilock>
  if(ip->nlink < 1)
8010663e:	83 c4 10             	add    $0x10,%esp
80106641:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106646:	0f 8e 10 01 00 00    	jle    8010675c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010664c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106651:	74 6d                	je     801066c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106653:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106656:	83 ec 04             	sub    $0x4,%esp
80106659:	6a 10                	push   $0x10
8010665b:	6a 00                	push   $0x0
8010665d:	50                   	push   %eax
8010665e:	e8 bd f5 ff ff       	call   80105c20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106663:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106666:	6a 10                	push   $0x10
80106668:	ff 75 c4             	pushl  -0x3c(%ebp)
8010666b:	50                   	push   %eax
8010666c:	56                   	push   %esi
8010666d:	e8 4e b6 ff ff       	call   80101cc0 <writei>
80106672:	83 c4 20             	add    $0x20,%esp
80106675:	83 f8 10             	cmp    $0x10,%eax
80106678:	0f 85 eb 00 00 00    	jne    80106769 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010667e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106683:	0f 84 97 00 00 00    	je     80106720 <sys_unlink+0x180>
  iunlockput(dp);
80106689:	83 ec 0c             	sub    $0xc,%esp
8010668c:	56                   	push   %esi
8010668d:	e8 de b4 ff ff       	call   80101b70 <iunlockput>
  ip->nlink--;
80106692:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106697:	89 1c 24             	mov    %ebx,(%esp)
8010669a:	e8 91 b1 ff ff       	call   80101830 <iupdate>
  iunlockput(ip);
8010669f:	89 1c 24             	mov    %ebx,(%esp)
801066a2:	e8 c9 b4 ff ff       	call   80101b70 <iunlockput>
  end_op();
801066a7:	e8 b4 c9 ff ff       	call   80103060 <end_op>
  return 0;
801066ac:	83 c4 10             	add    $0x10,%esp
801066af:	31 c0                	xor    %eax,%eax
}
801066b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066b4:	5b                   	pop    %ebx
801066b5:	5e                   	pop    %esi
801066b6:	5f                   	pop    %edi
801066b7:	5d                   	pop    %ebp
801066b8:	c3                   	ret    
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801066c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801066c4:	76 8d                	jbe    80106653 <sys_unlink+0xb3>
801066c6:	bf 20 00 00 00       	mov    $0x20,%edi
801066cb:	eb 0f                	jmp    801066dc <sys_unlink+0x13c>
801066cd:	8d 76 00             	lea    0x0(%esi),%esi
801066d0:	83 c7 10             	add    $0x10,%edi
801066d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801066d6:	0f 83 77 ff ff ff    	jae    80106653 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801066dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801066df:	6a 10                	push   $0x10
801066e1:	57                   	push   %edi
801066e2:	50                   	push   %eax
801066e3:	53                   	push   %ebx
801066e4:	e8 d7 b4 ff ff       	call   80101bc0 <readi>
801066e9:	83 c4 10             	add    $0x10,%esp
801066ec:	83 f8 10             	cmp    $0x10,%eax
801066ef:	75 5e                	jne    8010674f <sys_unlink+0x1af>
    if(de.inum != 0)
801066f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801066f6:	74 d8                	je     801066d0 <sys_unlink+0x130>
    iunlockput(ip);
801066f8:	83 ec 0c             	sub    $0xc,%esp
801066fb:	53                   	push   %ebx
801066fc:	e8 6f b4 ff ff       	call   80101b70 <iunlockput>
    goto bad;
80106701:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80106704:	83 ec 0c             	sub    $0xc,%esp
80106707:	56                   	push   %esi
80106708:	e8 63 b4 ff ff       	call   80101b70 <iunlockput>
  end_op();
8010670d:	e8 4e c9 ff ff       	call   80103060 <end_op>
  return -1;
80106712:	83 c4 10             	add    $0x10,%esp
80106715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671a:	eb 95                	jmp    801066b1 <sys_unlink+0x111>
8010671c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106720:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106725:	83 ec 0c             	sub    $0xc,%esp
80106728:	56                   	push   %esi
80106729:	e8 02 b1 ff ff       	call   80101830 <iupdate>
8010672e:	83 c4 10             	add    $0x10,%esp
80106731:	e9 53 ff ff ff       	jmp    80106689 <sys_unlink+0xe9>
    return -1;
80106736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673b:	e9 71 ff ff ff       	jmp    801066b1 <sys_unlink+0x111>
    end_op();
80106740:	e8 1b c9 ff ff       	call   80103060 <end_op>
    return -1;
80106745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674a:	e9 62 ff ff ff       	jmp    801066b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010674f:	83 ec 0c             	sub    $0xc,%esp
80106752:	68 55 90 10 80       	push   $0x80109055
80106757:	e8 34 9c ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010675c:	83 ec 0c             	sub    $0xc,%esp
8010675f:	68 43 90 10 80       	push   $0x80109043
80106764:	e8 27 9c ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106769:	83 ec 0c             	sub    $0xc,%esp
8010676c:	68 67 90 10 80       	push   $0x80109067
80106771:	e8 1a 9c ff ff       	call   80100390 <panic>
80106776:	8d 76 00             	lea    0x0(%esi),%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106780 <sys_open>:

int
sys_open(void)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106786:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106789:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010678c:	50                   	push   %eax
8010678d:	6a 00                	push   $0x0
8010678f:	e8 3c f8 ff ff       	call   80105fd0 <argstr>
80106794:	83 c4 10             	add    $0x10,%esp
80106797:	85 c0                	test   %eax,%eax
80106799:	0f 88 1d 01 00 00    	js     801068bc <sys_open+0x13c>
8010679f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067a2:	83 ec 08             	sub    $0x8,%esp
801067a5:	50                   	push   %eax
801067a6:	6a 01                	push   $0x1
801067a8:	e8 73 f7 ff ff       	call   80105f20 <argint>
801067ad:	83 c4 10             	add    $0x10,%esp
801067b0:	85 c0                	test   %eax,%eax
801067b2:	0f 88 04 01 00 00    	js     801068bc <sys_open+0x13c>
    return -1;

  begin_op();
801067b8:	e8 33 c8 ff ff       	call   80102ff0 <begin_op>

  if(omode & O_CREATE){
801067bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801067c1:	0f 85 a9 00 00 00    	jne    80106870 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801067c7:	83 ec 0c             	sub    $0xc,%esp
801067ca:	ff 75 e0             	pushl  -0x20(%ebp)
801067cd:	e8 fe b9 ff ff       	call   801021d0 <namei>
801067d2:	83 c4 10             	add    $0x10,%esp
801067d5:	85 c0                	test   %eax,%eax
801067d7:	89 c6                	mov    %eax,%esi
801067d9:	0f 84 b2 00 00 00    	je     80106891 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801067df:	83 ec 0c             	sub    $0xc,%esp
801067e2:	50                   	push   %eax
801067e3:	e8 f8 b0 ff ff       	call   801018e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801067e8:	83 c4 10             	add    $0x10,%esp
801067eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801067f0:	0f 84 aa 00 00 00    	je     801068a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801067f6:	e8 85 a5 ff ff       	call   80100d80 <filealloc>
801067fb:	85 c0                	test   %eax,%eax
801067fd:	89 c7                	mov    %eax,%edi
801067ff:	0f 84 a6 00 00 00    	je     801068ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80106805:	e8 36 d4 ff ff       	call   80103c40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010680a:	31 db                	xor    %ebx,%ebx
8010680c:	eb 0e                	jmp    8010681c <sys_open+0x9c>
8010680e:	66 90                	xchg   %ax,%ax
80106810:	83 c3 01             	add    $0x1,%ebx
80106813:	83 fb 10             	cmp    $0x10,%ebx
80106816:	0f 84 ac 00 00 00    	je     801068c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010681c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106820:	85 d2                	test   %edx,%edx
80106822:	75 ec                	jne    80106810 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106824:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106827:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010682b:	56                   	push   %esi
8010682c:	e8 8f b1 ff ff       	call   801019c0 <iunlock>
  end_op();
80106831:	e8 2a c8 ff ff       	call   80103060 <end_op>

  f->type = FD_INODE;
80106836:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010683c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->ip = ip;
8010683f:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106842:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106849:	89 d0                	mov    %edx,%eax
8010684b:	f7 d0                	not    %eax
8010684d:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106850:	83 e2 03             	and    $0x3,%edx
80106853:	0f 95 47 09          	setne  0x9(%edi)
  f->readable = !(omode & O_WRONLY);
80106857:	88 47 08             	mov    %al,0x8(%edi)
  procfs_add_inode(ip);
8010685a:	89 34 24             	mov    %esi,(%esp)
8010685d:	e8 3e e1 ff ff       	call   801049a0 <procfs_add_inode>
  return fd;
80106862:	83 c4 10             	add    $0x10,%esp
}
80106865:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106868:	89 d8                	mov    %ebx,%eax
8010686a:	5b                   	pop    %ebx
8010686b:	5e                   	pop    %esi
8010686c:	5f                   	pop    %edi
8010686d:	5d                   	pop    %ebp
8010686e:	c3                   	ret    
8010686f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80106870:	83 ec 0c             	sub    $0xc,%esp
80106873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106876:	31 c9                	xor    %ecx,%ecx
80106878:	6a 00                	push   $0x0
8010687a:	ba 02 00 00 00       	mov    $0x2,%edx
8010687f:	e8 ec f7 ff ff       	call   80106070 <create>
    if(ip == 0){
80106884:	83 c4 10             	add    $0x10,%esp
80106887:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106889:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010688b:	0f 85 65 ff ff ff    	jne    801067f6 <sys_open+0x76>
      end_op();
80106891:	e8 ca c7 ff ff       	call   80103060 <end_op>
      return -1;
80106896:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010689b:	eb c8                	jmp    80106865 <sys_open+0xe5>
8010689d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801068a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801068a3:	85 c9                	test   %ecx,%ecx
801068a5:	0f 84 4b ff ff ff    	je     801067f6 <sys_open+0x76>
    iunlockput(ip);
801068ab:	83 ec 0c             	sub    $0xc,%esp
801068ae:	56                   	push   %esi
801068af:	e8 bc b2 ff ff       	call   80101b70 <iunlockput>
    end_op();
801068b4:	e8 a7 c7 ff ff       	call   80103060 <end_op>
    return -1;
801068b9:	83 c4 10             	add    $0x10,%esp
801068bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801068c1:	eb a2                	jmp    80106865 <sys_open+0xe5>
801068c3:	90                   	nop
801068c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801068c8:	83 ec 0c             	sub    $0xc,%esp
801068cb:	57                   	push   %edi
801068cc:	e8 6f a5 ff ff       	call   80100e40 <fileclose>
801068d1:	83 c4 10             	add    $0x10,%esp
801068d4:	eb d5                	jmp    801068ab <sys_open+0x12b>
801068d6:	8d 76 00             	lea    0x0(%esi),%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801068e6:	e8 05 c7 ff ff       	call   80102ff0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801068eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068ee:	83 ec 08             	sub    $0x8,%esp
801068f1:	50                   	push   %eax
801068f2:	6a 00                	push   $0x0
801068f4:	e8 d7 f6 ff ff       	call   80105fd0 <argstr>
801068f9:	83 c4 10             	add    $0x10,%esp
801068fc:	85 c0                	test   %eax,%eax
801068fe:	78 30                	js     80106930 <sys_mkdir+0x50>
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106906:	31 c9                	xor    %ecx,%ecx
80106908:	6a 00                	push   $0x0
8010690a:	ba 01 00 00 00       	mov    $0x1,%edx
8010690f:	e8 5c f7 ff ff       	call   80106070 <create>
80106914:	83 c4 10             	add    $0x10,%esp
80106917:	85 c0                	test   %eax,%eax
80106919:	74 15                	je     80106930 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010691b:	83 ec 0c             	sub    $0xc,%esp
8010691e:	50                   	push   %eax
8010691f:	e8 4c b2 ff ff       	call   80101b70 <iunlockput>
  end_op();
80106924:	e8 37 c7 ff ff       	call   80103060 <end_op>
  return 0;
80106929:	83 c4 10             	add    $0x10,%esp
8010692c:	31 c0                	xor    %eax,%eax
}
8010692e:	c9                   	leave  
8010692f:	c3                   	ret    
    end_op();
80106930:	e8 2b c7 ff ff       	call   80103060 <end_op>
    return -1;
80106935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010693a:	c9                   	leave  
8010693b:	c3                   	ret    
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106940 <sys_mknod>:

int
sys_mknod(void)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106946:	e8 a5 c6 ff ff       	call   80102ff0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010694b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010694e:	83 ec 08             	sub    $0x8,%esp
80106951:	50                   	push   %eax
80106952:	6a 00                	push   $0x0
80106954:	e8 77 f6 ff ff       	call   80105fd0 <argstr>
80106959:	83 c4 10             	add    $0x10,%esp
8010695c:	85 c0                	test   %eax,%eax
8010695e:	78 60                	js     801069c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106960:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106963:	83 ec 08             	sub    $0x8,%esp
80106966:	50                   	push   %eax
80106967:	6a 01                	push   $0x1
80106969:	e8 b2 f5 ff ff       	call   80105f20 <argint>
  if((argstr(0, &path)) < 0 ||
8010696e:	83 c4 10             	add    $0x10,%esp
80106971:	85 c0                	test   %eax,%eax
80106973:	78 4b                	js     801069c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106975:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106978:	83 ec 08             	sub    $0x8,%esp
8010697b:	50                   	push   %eax
8010697c:	6a 02                	push   $0x2
8010697e:	e8 9d f5 ff ff       	call   80105f20 <argint>
     argint(1, &major) < 0 ||
80106983:	83 c4 10             	add    $0x10,%esp
80106986:	85 c0                	test   %eax,%eax
80106988:	78 36                	js     801069c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010698a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010698e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106991:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106995:	ba 03 00 00 00       	mov    $0x3,%edx
8010699a:	50                   	push   %eax
8010699b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010699e:	e8 cd f6 ff ff       	call   80106070 <create>
801069a3:	83 c4 10             	add    $0x10,%esp
801069a6:	85 c0                	test   %eax,%eax
801069a8:	74 16                	je     801069c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	50                   	push   %eax
801069ae:	e8 bd b1 ff ff       	call   80101b70 <iunlockput>
  end_op();
801069b3:	e8 a8 c6 ff ff       	call   80103060 <end_op>
  return 0;
801069b8:	83 c4 10             	add    $0x10,%esp
801069bb:	31 c0                	xor    %eax,%eax
}
801069bd:	c9                   	leave  
801069be:	c3                   	ret    
801069bf:	90                   	nop
    end_op();
801069c0:	e8 9b c6 ff ff       	call   80103060 <end_op>
    return -1;
801069c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069ca:	c9                   	leave  
801069cb:	c3                   	ret    
801069cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069d0 <sys_chdir>:

int
sys_chdir(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	56                   	push   %esi
801069d4:	53                   	push   %ebx
801069d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801069d8:	e8 63 d2 ff ff       	call   80103c40 <myproc>
801069dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801069df:	e8 0c c6 ff ff       	call   80102ff0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801069e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069e7:	83 ec 08             	sub    $0x8,%esp
801069ea:	50                   	push   %eax
801069eb:	6a 00                	push   $0x0
801069ed:	e8 de f5 ff ff       	call   80105fd0 <argstr>
801069f2:	83 c4 10             	add    $0x10,%esp
801069f5:	85 c0                	test   %eax,%eax
801069f7:	0f 88 93 00 00 00    	js     80106a90 <sys_chdir+0xc0>
801069fd:	83 ec 0c             	sub    $0xc,%esp
80106a00:	ff 75 f4             	pushl  -0xc(%ebp)
80106a03:	e8 c8 b7 ff ff       	call   801021d0 <namei>
80106a08:	83 c4 10             	add    $0x10,%esp
80106a0b:	85 c0                	test   %eax,%eax
80106a0d:	89 c3                	mov    %eax,%ebx
80106a0f:	74 7f                	je     80106a90 <sys_chdir+0xc0>
    end_op();
    return -1;
  }
  ilock(ip);
80106a11:	83 ec 0c             	sub    $0xc,%esp
80106a14:	50                   	push   %eax
80106a15:	e8 c6 ae ff ff       	call   801018e0 <ilock>
  if(ip->type != T_DIR && !(IS_DEV_DIR(ip))){
80106a1a:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80106a1e:	83 c4 10             	add    $0x10,%esp
80106a21:	66 83 f8 01          	cmp    $0x1,%ax
80106a25:	74 24                	je     80106a4b <sys_chdir+0x7b>
80106a27:	66 83 f8 03          	cmp    $0x3,%ax
80106a2b:	75 4b                	jne    80106a78 <sys_chdir+0xa8>
80106a2d:	0f bf 43 52          	movswl 0x52(%ebx),%eax
80106a31:	c1 e0 04             	shl    $0x4,%eax
80106a34:	8b 80 20 30 11 80    	mov    -0x7feecfe0(%eax),%eax
80106a3a:	85 c0                	test   %eax,%eax
80106a3c:	74 3a                	je     80106a78 <sys_chdir+0xa8>
80106a3e:	83 ec 0c             	sub    $0xc,%esp
80106a41:	53                   	push   %ebx
80106a42:	ff d0                	call   *%eax
80106a44:	83 c4 10             	add    $0x10,%esp
80106a47:	85 c0                	test   %eax,%eax
80106a49:	74 2d                	je     80106a78 <sys_chdir+0xa8>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106a4b:	83 ec 0c             	sub    $0xc,%esp
80106a4e:	53                   	push   %ebx
80106a4f:	e8 6c af ff ff       	call   801019c0 <iunlock>
  iput(curproc->cwd);
80106a54:	58                   	pop    %eax
80106a55:	ff 76 68             	pushl  0x68(%esi)
80106a58:	e8 b3 af ff ff       	call   80101a10 <iput>
  end_op();
80106a5d:	e8 fe c5 ff ff       	call   80103060 <end_op>
  curproc->cwd = ip;
80106a62:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80106a65:	83 c4 10             	add    $0x10,%esp
80106a68:	31 c0                	xor    %eax,%eax
}
80106a6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a6d:	5b                   	pop    %ebx
80106a6e:	5e                   	pop    %esi
80106a6f:	5d                   	pop    %ebp
80106a70:	c3                   	ret    
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80106a78:	83 ec 0c             	sub    $0xc,%esp
80106a7b:	53                   	push   %ebx
80106a7c:	e8 ef b0 ff ff       	call   80101b70 <iunlockput>
    end_op();
80106a81:	e8 da c5 ff ff       	call   80103060 <end_op>
    return -1;
80106a86:	83 c4 10             	add    $0x10,%esp
80106a89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a8e:	eb da                	jmp    80106a6a <sys_chdir+0x9a>
    end_op();
80106a90:	e8 cb c5 ff ff       	call   80103060 <end_op>
    return -1;
80106a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9a:	eb ce                	jmp    80106a6a <sys_chdir+0x9a>
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <sys_exec>:

int
sys_exec(void)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106aa6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106aac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106ab2:	50                   	push   %eax
80106ab3:	6a 00                	push   $0x0
80106ab5:	e8 16 f5 ff ff       	call   80105fd0 <argstr>
80106aba:	83 c4 10             	add    $0x10,%esp
80106abd:	85 c0                	test   %eax,%eax
80106abf:	0f 88 87 00 00 00    	js     80106b4c <sys_exec+0xac>
80106ac5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106acb:	83 ec 08             	sub    $0x8,%esp
80106ace:	50                   	push   %eax
80106acf:	6a 01                	push   $0x1
80106ad1:	e8 4a f4 ff ff       	call   80105f20 <argint>
80106ad6:	83 c4 10             	add    $0x10,%esp
80106ad9:	85 c0                	test   %eax,%eax
80106adb:	78 6f                	js     80106b4c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106add:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106ae3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106ae6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106ae8:	68 80 00 00 00       	push   $0x80
80106aed:	6a 00                	push   $0x0
80106aef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106af5:	50                   	push   %eax
80106af6:	e8 25 f1 ff ff       	call   80105c20 <memset>
80106afb:	83 c4 10             	add    $0x10,%esp
80106afe:	eb 2c                	jmp    80106b2c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106b00:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106b06:	85 c0                	test   %eax,%eax
80106b08:	74 56                	je     80106b60 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106b0a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106b10:	83 ec 08             	sub    $0x8,%esp
80106b13:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106b16:	52                   	push   %edx
80106b17:	50                   	push   %eax
80106b18:	e8 93 f3 ff ff       	call   80105eb0 <fetchstr>
80106b1d:	83 c4 10             	add    $0x10,%esp
80106b20:	85 c0                	test   %eax,%eax
80106b22:	78 28                	js     80106b4c <sys_exec+0xac>
  for(i=0;; i++){
80106b24:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106b27:	83 fb 20             	cmp    $0x20,%ebx
80106b2a:	74 20                	je     80106b4c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106b2c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106b32:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106b39:	83 ec 08             	sub    $0x8,%esp
80106b3c:	57                   	push   %edi
80106b3d:	01 f0                	add    %esi,%eax
80106b3f:	50                   	push   %eax
80106b40:	e8 2b f3 ff ff       	call   80105e70 <fetchint>
80106b45:	83 c4 10             	add    $0x10,%esp
80106b48:	85 c0                	test   %eax,%eax
80106b4a:	79 b4                	jns    80106b00 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106b4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b54:	5b                   	pop    %ebx
80106b55:	5e                   	pop    %esi
80106b56:	5f                   	pop    %edi
80106b57:	5d                   	pop    %ebp
80106b58:	c3                   	ret    
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106b60:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106b66:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106b69:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106b70:	00 00 00 00 
  return exec(path, argv);
80106b74:	50                   	push   %eax
80106b75:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106b7b:	e8 90 9e ff ff       	call   80100a10 <exec>
80106b80:	83 c4 10             	add    $0x10,%esp
}
80106b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b86:	5b                   	pop    %ebx
80106b87:	5e                   	pop    %esi
80106b88:	5f                   	pop    %edi
80106b89:	5d                   	pop    %ebp
80106b8a:	c3                   	ret    
80106b8b:	90                   	nop
80106b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b90 <sys_pipe>:

int
sys_pipe(void)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b96:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106b99:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b9c:	6a 08                	push   $0x8
80106b9e:	50                   	push   %eax
80106b9f:	6a 00                	push   $0x0
80106ba1:	e8 ca f3 ff ff       	call   80105f70 <argptr>
80106ba6:	83 c4 10             	add    $0x10,%esp
80106ba9:	85 c0                	test   %eax,%eax
80106bab:	0f 88 ae 00 00 00    	js     80106c5f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106bb1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106bb4:	83 ec 08             	sub    $0x8,%esp
80106bb7:	50                   	push   %eax
80106bb8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106bbb:	50                   	push   %eax
80106bbc:	e8 cf ca ff ff       	call   80103690 <pipealloc>
80106bc1:	83 c4 10             	add    $0x10,%esp
80106bc4:	85 c0                	test   %eax,%eax
80106bc6:	0f 88 93 00 00 00    	js     80106c5f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106bcc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106bcf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106bd1:	e8 6a d0 ff ff       	call   80103c40 <myproc>
80106bd6:	eb 10                	jmp    80106be8 <sys_pipe+0x58>
80106bd8:	90                   	nop
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106be0:	83 c3 01             	add    $0x1,%ebx
80106be3:	83 fb 10             	cmp    $0x10,%ebx
80106be6:	74 60                	je     80106c48 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106be8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106bec:	85 f6                	test   %esi,%esi
80106bee:	75 f0                	jne    80106be0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106bf0:	8d 73 08             	lea    0x8(%ebx),%esi
80106bf3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106bf7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106bfa:	e8 41 d0 ff ff       	call   80103c40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106bff:	31 d2                	xor    %edx,%edx
80106c01:	eb 0d                	jmp    80106c10 <sys_pipe+0x80>
80106c03:	90                   	nop
80106c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c08:	83 c2 01             	add    $0x1,%edx
80106c0b:	83 fa 10             	cmp    $0x10,%edx
80106c0e:	74 28                	je     80106c38 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106c10:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106c14:	85 c9                	test   %ecx,%ecx
80106c16:	75 f0                	jne    80106c08 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106c18:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c1f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c24:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106c27:	31 c0                	xor    %eax,%eax
}
80106c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c2c:	5b                   	pop    %ebx
80106c2d:	5e                   	pop    %esi
80106c2e:	5f                   	pop    %edi
80106c2f:	5d                   	pop    %ebp
80106c30:	c3                   	ret    
80106c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106c38:	e8 03 d0 ff ff       	call   80103c40 <myproc>
80106c3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106c44:	00 
80106c45:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106c48:	83 ec 0c             	sub    $0xc,%esp
80106c4b:	ff 75 e0             	pushl  -0x20(%ebp)
80106c4e:	e8 ed a1 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106c53:	58                   	pop    %eax
80106c54:	ff 75 e4             	pushl  -0x1c(%ebp)
80106c57:	e8 e4 a1 ff ff       	call   80100e40 <fileclose>
    return -1;
80106c5c:	83 c4 10             	add    $0x10,%esp
80106c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c64:	eb c3                	jmp    80106c29 <sys_pipe+0x99>
80106c66:	66 90                	xchg   %ax,%ax
80106c68:	66 90                	xchg   %ax,%ax
80106c6a:	66 90                	xchg   %ax,%ax
80106c6c:	66 90                	xchg   %ax,%ax
80106c6e:	66 90                	xchg   %ax,%ax

80106c70 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106c73:	5d                   	pop    %ebp
  return fork();
80106c74:	e9 67 d1 ff ff       	jmp    80103de0 <fork>
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <sys_exit>:

int
sys_exit(void)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 08             	sub    $0x8,%esp
  exit();
80106c86:	e8 d5 d3 ff ff       	call   80104060 <exit>
  return 0;  // not reached
}
80106c8b:	31 c0                	xor    %eax,%eax
80106c8d:	c9                   	leave  
80106c8e:	c3                   	ret    
80106c8f:	90                   	nop

80106c90 <sys_wait>:

int
sys_wait(void)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106c93:	5d                   	pop    %ebp
  return wait();
80106c94:	e9 07 d6 ff ff       	jmp    801042a0 <wait>
80106c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <sys_kill>:

int
sys_kill(void)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ca9:	50                   	push   %eax
80106caa:	6a 00                	push   $0x0
80106cac:	e8 6f f2 ff ff       	call   80105f20 <argint>
80106cb1:	83 c4 10             	add    $0x10,%esp
80106cb4:	85 c0                	test   %eax,%eax
80106cb6:	78 18                	js     80106cd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106cb8:	83 ec 0c             	sub    $0xc,%esp
80106cbb:	ff 75 f4             	pushl  -0xc(%ebp)
80106cbe:	e8 2d d7 ff ff       	call   801043f0 <kill>
80106cc3:	83 c4 10             	add    $0x10,%esp
}
80106cc6:	c9                   	leave  
80106cc7:	c3                   	ret    
80106cc8:	90                   	nop
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cd5:	c9                   	leave  
80106cd6:	c3                   	ret    
80106cd7:	89 f6                	mov    %esi,%esi
80106cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ce0 <sys_getpid>:

int
sys_getpid(void)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106ce6:	e8 55 cf ff ff       	call   80103c40 <myproc>
80106ceb:	8b 40 10             	mov    0x10(%eax),%eax
}
80106cee:	c9                   	leave  
80106cef:	c3                   	ret    

80106cf0 <sys_sbrk>:

int
sys_sbrk(void)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106cf7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106cfa:	50                   	push   %eax
80106cfb:	6a 00                	push   $0x0
80106cfd:	e8 1e f2 ff ff       	call   80105f20 <argint>
80106d02:	83 c4 10             	add    $0x10,%esp
80106d05:	85 c0                	test   %eax,%eax
80106d07:	78 27                	js     80106d30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106d09:	e8 32 cf ff ff       	call   80103c40 <myproc>
  if(growproc(n) < 0)
80106d0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106d11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106d13:	ff 75 f4             	pushl  -0xc(%ebp)
80106d16:	e8 45 d0 ff ff       	call   80103d60 <growproc>
80106d1b:	83 c4 10             	add    $0x10,%esp
80106d1e:	85 c0                	test   %eax,%eax
80106d20:	78 0e                	js     80106d30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106d22:	89 d8                	mov    %ebx,%eax
80106d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d27:	c9                   	leave  
80106d28:	c3                   	ret    
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106d30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106d35:	eb eb                	jmp    80106d22 <sys_sbrk+0x32>
80106d37:	89 f6                	mov    %esi,%esi
80106d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d40 <sys_sleep>:

int
sys_sleep(void)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106d44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106d47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106d4a:	50                   	push   %eax
80106d4b:	6a 00                	push   $0x0
80106d4d:	e8 ce f1 ff ff       	call   80105f20 <argint>
80106d52:	83 c4 10             	add    $0x10,%esp
80106d55:	85 c0                	test   %eax,%eax
80106d57:	0f 88 8a 00 00 00    	js     80106de7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106d5d:	83 ec 0c             	sub    $0xc,%esp
80106d60:	68 a0 7e 11 80       	push   $0x80117ea0
80106d65:	e8 a6 ed ff ff       	call   80105b10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d6d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106d70:	8b 1d e0 86 11 80    	mov    0x801186e0,%ebx
  while(ticks - ticks0 < n){
80106d76:	85 d2                	test   %edx,%edx
80106d78:	75 27                	jne    80106da1 <sys_sleep+0x61>
80106d7a:	eb 54                	jmp    80106dd0 <sys_sleep+0x90>
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106d80:	83 ec 08             	sub    $0x8,%esp
80106d83:	68 a0 7e 11 80       	push   $0x80117ea0
80106d88:	68 e0 86 11 80       	push   $0x801186e0
80106d8d:	e8 4e d4 ff ff       	call   801041e0 <sleep>
  while(ticks - ticks0 < n){
80106d92:	a1 e0 86 11 80       	mov    0x801186e0,%eax
80106d97:	83 c4 10             	add    $0x10,%esp
80106d9a:	29 d8                	sub    %ebx,%eax
80106d9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106d9f:	73 2f                	jae    80106dd0 <sys_sleep+0x90>
    if(myproc()->killed){
80106da1:	e8 9a ce ff ff       	call   80103c40 <myproc>
80106da6:	8b 40 24             	mov    0x24(%eax),%eax
80106da9:	85 c0                	test   %eax,%eax
80106dab:	74 d3                	je     80106d80 <sys_sleep+0x40>
      release(&tickslock);
80106dad:	83 ec 0c             	sub    $0xc,%esp
80106db0:	68 a0 7e 11 80       	push   $0x80117ea0
80106db5:	e8 16 ee ff ff       	call   80105bd0 <release>
      return -1;
80106dba:	83 c4 10             	add    $0x10,%esp
80106dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106dc5:	c9                   	leave  
80106dc6:	c3                   	ret    
80106dc7:	89 f6                	mov    %esi,%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106dd0:	83 ec 0c             	sub    $0xc,%esp
80106dd3:	68 a0 7e 11 80       	push   $0x80117ea0
80106dd8:	e8 f3 ed ff ff       	call   80105bd0 <release>
  return 0;
80106ddd:	83 c4 10             	add    $0x10,%esp
80106de0:	31 c0                	xor    %eax,%eax
}
80106de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106de5:	c9                   	leave  
80106de6:	c3                   	ret    
    return -1;
80106de7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dec:	eb f4                	jmp    80106de2 <sys_sleep+0xa2>
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	53                   	push   %ebx
80106df4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106df7:	68 a0 7e 11 80       	push   $0x80117ea0
80106dfc:	e8 0f ed ff ff       	call   80105b10 <acquire>
  xticks = ticks;
80106e01:	8b 1d e0 86 11 80    	mov    0x801186e0,%ebx
  release(&tickslock);
80106e07:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
80106e0e:	e8 bd ed ff ff       	call   80105bd0 <release>
  return xticks;
}
80106e13:	89 d8                	mov    %ebx,%eax
80106e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106e18:	c9                   	leave  
80106e19:	c3                   	ret    

80106e1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106e1a:	1e                   	push   %ds
  pushl %es
80106e1b:	06                   	push   %es
  pushl %fs
80106e1c:	0f a0                	push   %fs
  pushl %gs
80106e1e:	0f a8                	push   %gs
  pushal
80106e20:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106e21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106e25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106e27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106e29:	54                   	push   %esp
  call trap
80106e2a:	e8 c1 00 00 00       	call   80106ef0 <trap>
  addl $4, %esp
80106e2f:	83 c4 04             	add    $0x4,%esp

80106e32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106e32:	61                   	popa   
  popl %gs
80106e33:	0f a9                	pop    %gs
  popl %fs
80106e35:	0f a1                	pop    %fs
  popl %es
80106e37:	07                   	pop    %es
  popl %ds
80106e38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106e39:	83 c4 08             	add    $0x8,%esp
  iret
80106e3c:	cf                   	iret   
80106e3d:	66 90                	xchg   %ax,%ax
80106e3f:	90                   	nop

80106e40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106e40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106e41:	31 c0                	xor    %eax,%eax
{
80106e43:	89 e5                	mov    %esp,%ebp
80106e45:	83 ec 08             	sub    $0x8,%esp
80106e48:	90                   	nop
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106e50:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106e57:	c7 04 c5 e2 7e 11 80 	movl   $0x8e000008,-0x7fee811e(,%eax,8)
80106e5e:	08 00 00 8e 
80106e62:	66 89 14 c5 e0 7e 11 	mov    %dx,-0x7fee8120(,%eax,8)
80106e69:	80 
80106e6a:	c1 ea 10             	shr    $0x10,%edx
80106e6d:	66 89 14 c5 e6 7e 11 	mov    %dx,-0x7fee811a(,%eax,8)
80106e74:	80 
  for(i = 0; i < 256; i++)
80106e75:	83 c0 01             	add    $0x1,%eax
80106e78:	3d 00 01 00 00       	cmp    $0x100,%eax
80106e7d:	75 d1                	jne    80106e50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e7f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106e84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e87:	c7 05 e2 80 11 80 08 	movl   $0xef000008,0x801180e2
80106e8e:	00 00 ef 
  initlock(&tickslock, "time");
80106e91:	68 76 90 10 80       	push   $0x80109076
80106e96:	68 a0 7e 11 80       	push   $0x80117ea0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e9b:	66 a3 e0 80 11 80    	mov    %ax,0x801180e0
80106ea1:	c1 e8 10             	shr    $0x10,%eax
80106ea4:	66 a3 e6 80 11 80    	mov    %ax,0x801180e6
  initlock(&tickslock, "time");
80106eaa:	e8 21 eb ff ff       	call   801059d0 <initlock>
}
80106eaf:	83 c4 10             	add    $0x10,%esp
80106eb2:	c9                   	leave  
80106eb3:	c3                   	ret    
80106eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ec0 <idtinit>:

void
idtinit(void)
{
80106ec0:	55                   	push   %ebp
  pd[0] = size-1;
80106ec1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106ec6:	89 e5                	mov    %esp,%ebp
80106ec8:	83 ec 10             	sub    $0x10,%esp
80106ecb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ecf:	b8 e0 7e 11 80       	mov    $0x80117ee0,%eax
80106ed4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ed8:	c1 e8 10             	shr    $0x10,%eax
80106edb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106edf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ee2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106ee5:	c9                   	leave  
80106ee6:	c3                   	ret    
80106ee7:	89 f6                	mov    %esi,%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80106efc:	8b 47 30             	mov    0x30(%edi),%eax
80106eff:	83 f8 40             	cmp    $0x40,%eax
80106f02:	0f 84 f0 00 00 00    	je     80106ff8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106f08:	83 e8 20             	sub    $0x20,%eax
80106f0b:	83 f8 1f             	cmp    $0x1f,%eax
80106f0e:	77 10                	ja     80106f20 <trap+0x30>
80106f10:	ff 24 85 1c 91 10 80 	jmp    *-0x7fef6ee4(,%eax,4)
80106f17:	89 f6                	mov    %esi,%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106f20:	e8 1b cd ff ff       	call   80103c40 <myproc>
80106f25:	85 c0                	test   %eax,%eax
80106f27:	8b 5f 38             	mov    0x38(%edi),%ebx
80106f2a:	0f 84 14 02 00 00    	je     80107144 <trap+0x254>
80106f30:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106f34:	0f 84 0a 02 00 00    	je     80107144 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106f3a:	0f 20 d1             	mov    %cr2,%ecx
80106f3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f40:	e8 db cc ff ff       	call   80103c20 <cpuid>
80106f45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f48:	8b 47 34             	mov    0x34(%edi),%eax
80106f4b:	8b 77 30             	mov    0x30(%edi),%esi
80106f4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106f51:	e8 ea cc ff ff       	call   80103c40 <myproc>
80106f56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f59:	e8 e2 cc ff ff       	call   80103c40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106f64:	51                   	push   %ecx
80106f65:	53                   	push   %ebx
80106f66:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106f67:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f6d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106f6e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f71:	52                   	push   %edx
80106f72:	ff 70 10             	pushl  0x10(%eax)
80106f75:	68 d8 90 10 80       	push   $0x801090d8
80106f7a:	e8 e1 96 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106f7f:	83 c4 20             	add    $0x20,%esp
80106f82:	e8 b9 cc ff ff       	call   80103c40 <myproc>
80106f87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106f8e:	e8 ad cc ff ff       	call   80103c40 <myproc>
80106f93:	85 c0                	test   %eax,%eax
80106f95:	74 1d                	je     80106fb4 <trap+0xc4>
80106f97:	e8 a4 cc ff ff       	call   80103c40 <myproc>
80106f9c:	8b 50 24             	mov    0x24(%eax),%edx
80106f9f:	85 d2                	test   %edx,%edx
80106fa1:	74 11                	je     80106fb4 <trap+0xc4>
80106fa3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106fa7:	83 e0 03             	and    $0x3,%eax
80106faa:	66 83 f8 03          	cmp    $0x3,%ax
80106fae:	0f 84 4c 01 00 00    	je     80107100 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106fb4:	e8 87 cc ff ff       	call   80103c40 <myproc>
80106fb9:	85 c0                	test   %eax,%eax
80106fbb:	74 0b                	je     80106fc8 <trap+0xd8>
80106fbd:	e8 7e cc ff ff       	call   80103c40 <myproc>
80106fc2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106fc6:	74 68                	je     80107030 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106fc8:	e8 73 cc ff ff       	call   80103c40 <myproc>
80106fcd:	85 c0                	test   %eax,%eax
80106fcf:	74 19                	je     80106fea <trap+0xfa>
80106fd1:	e8 6a cc ff ff       	call   80103c40 <myproc>
80106fd6:	8b 40 24             	mov    0x24(%eax),%eax
80106fd9:	85 c0                	test   %eax,%eax
80106fdb:	74 0d                	je     80106fea <trap+0xfa>
80106fdd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106fe1:	83 e0 03             	and    $0x3,%eax
80106fe4:	66 83 f8 03          	cmp    $0x3,%ax
80106fe8:	74 37                	je     80107021 <trap+0x131>
    exit();
}
80106fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fed:	5b                   	pop    %ebx
80106fee:	5e                   	pop    %esi
80106fef:	5f                   	pop    %edi
80106ff0:	5d                   	pop    %ebp
80106ff1:	c3                   	ret    
80106ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106ff8:	e8 43 cc ff ff       	call   80103c40 <myproc>
80106ffd:	8b 58 24             	mov    0x24(%eax),%ebx
80107000:	85 db                	test   %ebx,%ebx
80107002:	0f 85 e8 00 00 00    	jne    801070f0 <trap+0x200>
    myproc()->tf = tf;
80107008:	e8 33 cc ff ff       	call   80103c40 <myproc>
8010700d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80107010:	e8 fb ef ff ff       	call   80106010 <syscall>
    if(myproc()->killed)
80107015:	e8 26 cc ff ff       	call   80103c40 <myproc>
8010701a:	8b 48 24             	mov    0x24(%eax),%ecx
8010701d:	85 c9                	test   %ecx,%ecx
8010701f:	74 c9                	je     80106fea <trap+0xfa>
}
80107021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107024:	5b                   	pop    %ebx
80107025:	5e                   	pop    %esi
80107026:	5f                   	pop    %edi
80107027:	5d                   	pop    %ebp
      exit();
80107028:	e9 33 d0 ff ff       	jmp    80104060 <exit>
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80107030:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80107034:	75 92                	jne    80106fc8 <trap+0xd8>
    yield();
80107036:	e8 55 d1 ff ff       	call   80104190 <yield>
8010703b:	eb 8b                	jmp    80106fc8 <trap+0xd8>
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80107040:	e8 db cb ff ff       	call   80103c20 <cpuid>
80107045:	85 c0                	test   %eax,%eax
80107047:	0f 84 c3 00 00 00    	je     80107110 <trap+0x220>
    lapiceoi();
8010704d:	e8 4e bb ff ff       	call   80102ba0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107052:	e8 e9 cb ff ff       	call   80103c40 <myproc>
80107057:	85 c0                	test   %eax,%eax
80107059:	0f 85 38 ff ff ff    	jne    80106f97 <trap+0xa7>
8010705f:	e9 50 ff ff ff       	jmp    80106fb4 <trap+0xc4>
80107064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107068:	e8 f3 b9 ff ff       	call   80102a60 <kbdintr>
    lapiceoi();
8010706d:	e8 2e bb ff ff       	call   80102ba0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107072:	e8 c9 cb ff ff       	call   80103c40 <myproc>
80107077:	85 c0                	test   %eax,%eax
80107079:	0f 85 18 ff ff ff    	jne    80106f97 <trap+0xa7>
8010707f:	e9 30 ff ff ff       	jmp    80106fb4 <trap+0xc4>
80107084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80107088:	e8 53 02 00 00       	call   801072e0 <uartintr>
    lapiceoi();
8010708d:	e8 0e bb ff ff       	call   80102ba0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107092:	e8 a9 cb ff ff       	call   80103c40 <myproc>
80107097:	85 c0                	test   %eax,%eax
80107099:	0f 85 f8 fe ff ff    	jne    80106f97 <trap+0xa7>
8010709f:	e9 10 ff ff ff       	jmp    80106fb4 <trap+0xc4>
801070a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070a8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801070ac:	8b 77 38             	mov    0x38(%edi),%esi
801070af:	e8 6c cb ff ff       	call   80103c20 <cpuid>
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	50                   	push   %eax
801070b7:	68 80 90 10 80       	push   $0x80109080
801070bc:	e8 9f 95 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801070c1:	e8 da ba ff ff       	call   80102ba0 <lapiceoi>
    break;
801070c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801070c9:	e8 72 cb ff ff       	call   80103c40 <myproc>
801070ce:	85 c0                	test   %eax,%eax
801070d0:	0f 85 c1 fe ff ff    	jne    80106f97 <trap+0xa7>
801070d6:	e9 d9 fe ff ff       	jmp    80106fb4 <trap+0xc4>
801070db:	90                   	nop
801070dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801070e0:	e8 0b b3 ff ff       	call   801023f0 <ideintr>
801070e5:	e9 63 ff ff ff       	jmp    8010704d <trap+0x15d>
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801070f0:	e8 6b cf ff ff       	call   80104060 <exit>
801070f5:	e9 0e ff ff ff       	jmp    80107008 <trap+0x118>
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80107100:	e8 5b cf ff ff       	call   80104060 <exit>
80107105:	e9 aa fe ff ff       	jmp    80106fb4 <trap+0xc4>
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	68 a0 7e 11 80       	push   $0x80117ea0
80107118:	e8 f3 e9 ff ff       	call   80105b10 <acquire>
      wakeup(&ticks);
8010711d:	c7 04 24 e0 86 11 80 	movl   $0x801186e0,(%esp)
      ticks++;
80107124:	83 05 e0 86 11 80 01 	addl   $0x1,0x801186e0
      wakeup(&ticks);
8010712b:	e8 60 d2 ff ff       	call   80104390 <wakeup>
      release(&tickslock);
80107130:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
80107137:	e8 94 ea ff ff       	call   80105bd0 <release>
8010713c:	83 c4 10             	add    $0x10,%esp
8010713f:	e9 09 ff ff ff       	jmp    8010704d <trap+0x15d>
80107144:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107147:	e8 d4 ca ff ff       	call   80103c20 <cpuid>
8010714c:	83 ec 0c             	sub    $0xc,%esp
8010714f:	56                   	push   %esi
80107150:	53                   	push   %ebx
80107151:	50                   	push   %eax
80107152:	ff 77 30             	pushl  0x30(%edi)
80107155:	68 a4 90 10 80       	push   $0x801090a4
8010715a:	e8 01 95 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010715f:	83 c4 14             	add    $0x14,%esp
80107162:	68 7b 90 10 80       	push   $0x8010907b
80107167:	e8 24 92 ff ff       	call   80100390 <panic>
8010716c:	66 90                	xchg   %ax,%ax
8010716e:	66 90                	xchg   %ax,%ax

80107170 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107170:	a1 c0 ca 10 80       	mov    0x8010cac0,%eax
{
80107175:	55                   	push   %ebp
80107176:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107178:	85 c0                	test   %eax,%eax
8010717a:	74 1c                	je     80107198 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010717c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107181:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107182:	a8 01                	test   $0x1,%al
80107184:	74 12                	je     80107198 <uartgetc+0x28>
80107186:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010718b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010718c:	0f b6 c0             	movzbl %al,%eax
}
8010718f:	5d                   	pop    %ebp
80107190:	c3                   	ret    
80107191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010719d:	5d                   	pop    %ebp
8010719e:	c3                   	ret    
8010719f:	90                   	nop

801071a0 <uartputc.part.0>:
uartputc(int c)
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	89 c7                	mov    %eax,%edi
801071a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801071ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801071b2:	83 ec 0c             	sub    $0xc,%esp
801071b5:	eb 1b                	jmp    801071d2 <uartputc.part.0+0x32>
801071b7:	89 f6                	mov    %esi,%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801071c0:	83 ec 0c             	sub    $0xc,%esp
801071c3:	6a 0a                	push   $0xa
801071c5:	e8 f6 b9 ff ff       	call   80102bc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071ca:	83 c4 10             	add    $0x10,%esp
801071cd:	83 eb 01             	sub    $0x1,%ebx
801071d0:	74 07                	je     801071d9 <uartputc.part.0+0x39>
801071d2:	89 f2                	mov    %esi,%edx
801071d4:	ec                   	in     (%dx),%al
801071d5:	a8 20                	test   $0x20,%al
801071d7:	74 e7                	je     801071c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801071d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801071de:	89 f8                	mov    %edi,%eax
801071e0:	ee                   	out    %al,(%dx)
}
801071e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e4:	5b                   	pop    %ebx
801071e5:	5e                   	pop    %esi
801071e6:	5f                   	pop    %edi
801071e7:	5d                   	pop    %ebp
801071e8:	c3                   	ret    
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071f0 <uartinit>:
{
801071f0:	55                   	push   %ebp
801071f1:	31 c9                	xor    %ecx,%ecx
801071f3:	89 c8                	mov    %ecx,%eax
801071f5:	89 e5                	mov    %esp,%ebp
801071f7:	57                   	push   %edi
801071f8:	56                   	push   %esi
801071f9:	53                   	push   %ebx
801071fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801071ff:	89 da                	mov    %ebx,%edx
80107201:	83 ec 0c             	sub    $0xc,%esp
80107204:	ee                   	out    %al,(%dx)
80107205:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010720a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010720f:	89 fa                	mov    %edi,%edx
80107211:	ee                   	out    %al,(%dx)
80107212:	b8 0c 00 00 00       	mov    $0xc,%eax
80107217:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010721c:	ee                   	out    %al,(%dx)
8010721d:	be f9 03 00 00       	mov    $0x3f9,%esi
80107222:	89 c8                	mov    %ecx,%eax
80107224:	89 f2                	mov    %esi,%edx
80107226:	ee                   	out    %al,(%dx)
80107227:	b8 03 00 00 00       	mov    $0x3,%eax
8010722c:	89 fa                	mov    %edi,%edx
8010722e:	ee                   	out    %al,(%dx)
8010722f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107234:	89 c8                	mov    %ecx,%eax
80107236:	ee                   	out    %al,(%dx)
80107237:	b8 01 00 00 00       	mov    $0x1,%eax
8010723c:	89 f2                	mov    %esi,%edx
8010723e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010723f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107244:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107245:	3c ff                	cmp    $0xff,%al
80107247:	74 5a                	je     801072a3 <uartinit+0xb3>
  uart = 1;
80107249:	c7 05 c0 ca 10 80 01 	movl   $0x1,0x8010cac0
80107250:	00 00 00 
80107253:	89 da                	mov    %ebx,%edx
80107255:	ec                   	in     (%dx),%al
80107256:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010725b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010725c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010725f:	bb 9c 91 10 80       	mov    $0x8010919c,%ebx
  ioapicenable(IRQ_COM1, 0);
80107264:	6a 00                	push   $0x0
80107266:	6a 04                	push   $0x4
80107268:	e8 b3 b4 ff ff       	call   80102720 <ioapicenable>
8010726d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107270:	b8 78 00 00 00       	mov    $0x78,%eax
80107275:	eb 13                	jmp    8010728a <uartinit+0x9a>
80107277:	89 f6                	mov    %esi,%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107280:	83 c3 01             	add    $0x1,%ebx
80107283:	0f be 03             	movsbl (%ebx),%eax
80107286:	84 c0                	test   %al,%al
80107288:	74 19                	je     801072a3 <uartinit+0xb3>
  if(!uart)
8010728a:	8b 15 c0 ca 10 80    	mov    0x8010cac0,%edx
80107290:	85 d2                	test   %edx,%edx
80107292:	74 ec                	je     80107280 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80107294:	83 c3 01             	add    $0x1,%ebx
80107297:	e8 04 ff ff ff       	call   801071a0 <uartputc.part.0>
8010729c:	0f be 03             	movsbl (%ebx),%eax
8010729f:	84 c0                	test   %al,%al
801072a1:	75 e7                	jne    8010728a <uartinit+0x9a>
}
801072a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a6:	5b                   	pop    %ebx
801072a7:	5e                   	pop    %esi
801072a8:	5f                   	pop    %edi
801072a9:	5d                   	pop    %ebp
801072aa:	c3                   	ret    
801072ab:	90                   	nop
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072b0 <uartputc>:
  if(!uart)
801072b0:	8b 15 c0 ca 10 80    	mov    0x8010cac0,%edx
{
801072b6:	55                   	push   %ebp
801072b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801072b9:	85 d2                	test   %edx,%edx
{
801072bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801072be:	74 10                	je     801072d0 <uartputc+0x20>
}
801072c0:	5d                   	pop    %ebp
801072c1:	e9 da fe ff ff       	jmp    801071a0 <uartputc.part.0>
801072c6:	8d 76 00             	lea    0x0(%esi),%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801072d0:	5d                   	pop    %ebp
801072d1:	c3                   	ret    
801072d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072e0 <uartintr>:

void
uartintr(void)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801072e6:	68 70 71 10 80       	push   $0x80107170
801072eb:	e8 20 95 ff ff       	call   80100810 <consoleintr>
}
801072f0:	83 c4 10             	add    $0x10,%esp
801072f3:	c9                   	leave  
801072f4:	c3                   	ret    

801072f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $0
801072f7:	6a 00                	push   $0x0
  jmp alltraps
801072f9:	e9 1c fb ff ff       	jmp    80106e1a <alltraps>

801072fe <vector1>:
.globl vector1
vector1:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $1
80107300:	6a 01                	push   $0x1
  jmp alltraps
80107302:	e9 13 fb ff ff       	jmp    80106e1a <alltraps>

80107307 <vector2>:
.globl vector2
vector2:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $2
80107309:	6a 02                	push   $0x2
  jmp alltraps
8010730b:	e9 0a fb ff ff       	jmp    80106e1a <alltraps>

80107310 <vector3>:
.globl vector3
vector3:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $3
80107312:	6a 03                	push   $0x3
  jmp alltraps
80107314:	e9 01 fb ff ff       	jmp    80106e1a <alltraps>

80107319 <vector4>:
.globl vector4
vector4:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $4
8010731b:	6a 04                	push   $0x4
  jmp alltraps
8010731d:	e9 f8 fa ff ff       	jmp    80106e1a <alltraps>

80107322 <vector5>:
.globl vector5
vector5:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $5
80107324:	6a 05                	push   $0x5
  jmp alltraps
80107326:	e9 ef fa ff ff       	jmp    80106e1a <alltraps>

8010732b <vector6>:
.globl vector6
vector6:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $6
8010732d:	6a 06                	push   $0x6
  jmp alltraps
8010732f:	e9 e6 fa ff ff       	jmp    80106e1a <alltraps>

80107334 <vector7>:
.globl vector7
vector7:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $7
80107336:	6a 07                	push   $0x7
  jmp alltraps
80107338:	e9 dd fa ff ff       	jmp    80106e1a <alltraps>

8010733d <vector8>:
.globl vector8
vector8:
  pushl $8
8010733d:	6a 08                	push   $0x8
  jmp alltraps
8010733f:	e9 d6 fa ff ff       	jmp    80106e1a <alltraps>

80107344 <vector9>:
.globl vector9
vector9:
  pushl $0
80107344:	6a 00                	push   $0x0
  pushl $9
80107346:	6a 09                	push   $0x9
  jmp alltraps
80107348:	e9 cd fa ff ff       	jmp    80106e1a <alltraps>

8010734d <vector10>:
.globl vector10
vector10:
  pushl $10
8010734d:	6a 0a                	push   $0xa
  jmp alltraps
8010734f:	e9 c6 fa ff ff       	jmp    80106e1a <alltraps>

80107354 <vector11>:
.globl vector11
vector11:
  pushl $11
80107354:	6a 0b                	push   $0xb
  jmp alltraps
80107356:	e9 bf fa ff ff       	jmp    80106e1a <alltraps>

8010735b <vector12>:
.globl vector12
vector12:
  pushl $12
8010735b:	6a 0c                	push   $0xc
  jmp alltraps
8010735d:	e9 b8 fa ff ff       	jmp    80106e1a <alltraps>

80107362 <vector13>:
.globl vector13
vector13:
  pushl $13
80107362:	6a 0d                	push   $0xd
  jmp alltraps
80107364:	e9 b1 fa ff ff       	jmp    80106e1a <alltraps>

80107369 <vector14>:
.globl vector14
vector14:
  pushl $14
80107369:	6a 0e                	push   $0xe
  jmp alltraps
8010736b:	e9 aa fa ff ff       	jmp    80106e1a <alltraps>

80107370 <vector15>:
.globl vector15
vector15:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $15
80107372:	6a 0f                	push   $0xf
  jmp alltraps
80107374:	e9 a1 fa ff ff       	jmp    80106e1a <alltraps>

80107379 <vector16>:
.globl vector16
vector16:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $16
8010737b:	6a 10                	push   $0x10
  jmp alltraps
8010737d:	e9 98 fa ff ff       	jmp    80106e1a <alltraps>

80107382 <vector17>:
.globl vector17
vector17:
  pushl $17
80107382:	6a 11                	push   $0x11
  jmp alltraps
80107384:	e9 91 fa ff ff       	jmp    80106e1a <alltraps>

80107389 <vector18>:
.globl vector18
vector18:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $18
8010738b:	6a 12                	push   $0x12
  jmp alltraps
8010738d:	e9 88 fa ff ff       	jmp    80106e1a <alltraps>

80107392 <vector19>:
.globl vector19
vector19:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $19
80107394:	6a 13                	push   $0x13
  jmp alltraps
80107396:	e9 7f fa ff ff       	jmp    80106e1a <alltraps>

8010739b <vector20>:
.globl vector20
vector20:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $20
8010739d:	6a 14                	push   $0x14
  jmp alltraps
8010739f:	e9 76 fa ff ff       	jmp    80106e1a <alltraps>

801073a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $21
801073a6:	6a 15                	push   $0x15
  jmp alltraps
801073a8:	e9 6d fa ff ff       	jmp    80106e1a <alltraps>

801073ad <vector22>:
.globl vector22
vector22:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $22
801073af:	6a 16                	push   $0x16
  jmp alltraps
801073b1:	e9 64 fa ff ff       	jmp    80106e1a <alltraps>

801073b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $23
801073b8:	6a 17                	push   $0x17
  jmp alltraps
801073ba:	e9 5b fa ff ff       	jmp    80106e1a <alltraps>

801073bf <vector24>:
.globl vector24
vector24:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $24
801073c1:	6a 18                	push   $0x18
  jmp alltraps
801073c3:	e9 52 fa ff ff       	jmp    80106e1a <alltraps>

801073c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $25
801073ca:	6a 19                	push   $0x19
  jmp alltraps
801073cc:	e9 49 fa ff ff       	jmp    80106e1a <alltraps>

801073d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $26
801073d3:	6a 1a                	push   $0x1a
  jmp alltraps
801073d5:	e9 40 fa ff ff       	jmp    80106e1a <alltraps>

801073da <vector27>:
.globl vector27
vector27:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $27
801073dc:	6a 1b                	push   $0x1b
  jmp alltraps
801073de:	e9 37 fa ff ff       	jmp    80106e1a <alltraps>

801073e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $28
801073e5:	6a 1c                	push   $0x1c
  jmp alltraps
801073e7:	e9 2e fa ff ff       	jmp    80106e1a <alltraps>

801073ec <vector29>:
.globl vector29
vector29:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $29
801073ee:	6a 1d                	push   $0x1d
  jmp alltraps
801073f0:	e9 25 fa ff ff       	jmp    80106e1a <alltraps>

801073f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $30
801073f7:	6a 1e                	push   $0x1e
  jmp alltraps
801073f9:	e9 1c fa ff ff       	jmp    80106e1a <alltraps>

801073fe <vector31>:
.globl vector31
vector31:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $31
80107400:	6a 1f                	push   $0x1f
  jmp alltraps
80107402:	e9 13 fa ff ff       	jmp    80106e1a <alltraps>

80107407 <vector32>:
.globl vector32
vector32:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $32
80107409:	6a 20                	push   $0x20
  jmp alltraps
8010740b:	e9 0a fa ff ff       	jmp    80106e1a <alltraps>

80107410 <vector33>:
.globl vector33
vector33:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $33
80107412:	6a 21                	push   $0x21
  jmp alltraps
80107414:	e9 01 fa ff ff       	jmp    80106e1a <alltraps>

80107419 <vector34>:
.globl vector34
vector34:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $34
8010741b:	6a 22                	push   $0x22
  jmp alltraps
8010741d:	e9 f8 f9 ff ff       	jmp    80106e1a <alltraps>

80107422 <vector35>:
.globl vector35
vector35:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $35
80107424:	6a 23                	push   $0x23
  jmp alltraps
80107426:	e9 ef f9 ff ff       	jmp    80106e1a <alltraps>

8010742b <vector36>:
.globl vector36
vector36:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $36
8010742d:	6a 24                	push   $0x24
  jmp alltraps
8010742f:	e9 e6 f9 ff ff       	jmp    80106e1a <alltraps>

80107434 <vector37>:
.globl vector37
vector37:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $37
80107436:	6a 25                	push   $0x25
  jmp alltraps
80107438:	e9 dd f9 ff ff       	jmp    80106e1a <alltraps>

8010743d <vector38>:
.globl vector38
vector38:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $38
8010743f:	6a 26                	push   $0x26
  jmp alltraps
80107441:	e9 d4 f9 ff ff       	jmp    80106e1a <alltraps>

80107446 <vector39>:
.globl vector39
vector39:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $39
80107448:	6a 27                	push   $0x27
  jmp alltraps
8010744a:	e9 cb f9 ff ff       	jmp    80106e1a <alltraps>

8010744f <vector40>:
.globl vector40
vector40:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $40
80107451:	6a 28                	push   $0x28
  jmp alltraps
80107453:	e9 c2 f9 ff ff       	jmp    80106e1a <alltraps>

80107458 <vector41>:
.globl vector41
vector41:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $41
8010745a:	6a 29                	push   $0x29
  jmp alltraps
8010745c:	e9 b9 f9 ff ff       	jmp    80106e1a <alltraps>

80107461 <vector42>:
.globl vector42
vector42:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $42
80107463:	6a 2a                	push   $0x2a
  jmp alltraps
80107465:	e9 b0 f9 ff ff       	jmp    80106e1a <alltraps>

8010746a <vector43>:
.globl vector43
vector43:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $43
8010746c:	6a 2b                	push   $0x2b
  jmp alltraps
8010746e:	e9 a7 f9 ff ff       	jmp    80106e1a <alltraps>

80107473 <vector44>:
.globl vector44
vector44:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $44
80107475:	6a 2c                	push   $0x2c
  jmp alltraps
80107477:	e9 9e f9 ff ff       	jmp    80106e1a <alltraps>

8010747c <vector45>:
.globl vector45
vector45:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $45
8010747e:	6a 2d                	push   $0x2d
  jmp alltraps
80107480:	e9 95 f9 ff ff       	jmp    80106e1a <alltraps>

80107485 <vector46>:
.globl vector46
vector46:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $46
80107487:	6a 2e                	push   $0x2e
  jmp alltraps
80107489:	e9 8c f9 ff ff       	jmp    80106e1a <alltraps>

8010748e <vector47>:
.globl vector47
vector47:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $47
80107490:	6a 2f                	push   $0x2f
  jmp alltraps
80107492:	e9 83 f9 ff ff       	jmp    80106e1a <alltraps>

80107497 <vector48>:
.globl vector48
vector48:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $48
80107499:	6a 30                	push   $0x30
  jmp alltraps
8010749b:	e9 7a f9 ff ff       	jmp    80106e1a <alltraps>

801074a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801074a0:	6a 00                	push   $0x0
  pushl $49
801074a2:	6a 31                	push   $0x31
  jmp alltraps
801074a4:	e9 71 f9 ff ff       	jmp    80106e1a <alltraps>

801074a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801074a9:	6a 00                	push   $0x0
  pushl $50
801074ab:	6a 32                	push   $0x32
  jmp alltraps
801074ad:	e9 68 f9 ff ff       	jmp    80106e1a <alltraps>

801074b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $51
801074b4:	6a 33                	push   $0x33
  jmp alltraps
801074b6:	e9 5f f9 ff ff       	jmp    80106e1a <alltraps>

801074bb <vector52>:
.globl vector52
vector52:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $52
801074bd:	6a 34                	push   $0x34
  jmp alltraps
801074bf:	e9 56 f9 ff ff       	jmp    80106e1a <alltraps>

801074c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $53
801074c6:	6a 35                	push   $0x35
  jmp alltraps
801074c8:	e9 4d f9 ff ff       	jmp    80106e1a <alltraps>

801074cd <vector54>:
.globl vector54
vector54:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $54
801074cf:	6a 36                	push   $0x36
  jmp alltraps
801074d1:	e9 44 f9 ff ff       	jmp    80106e1a <alltraps>

801074d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $55
801074d8:	6a 37                	push   $0x37
  jmp alltraps
801074da:	e9 3b f9 ff ff       	jmp    80106e1a <alltraps>

801074df <vector56>:
.globl vector56
vector56:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $56
801074e1:	6a 38                	push   $0x38
  jmp alltraps
801074e3:	e9 32 f9 ff ff       	jmp    80106e1a <alltraps>

801074e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $57
801074ea:	6a 39                	push   $0x39
  jmp alltraps
801074ec:	e9 29 f9 ff ff       	jmp    80106e1a <alltraps>

801074f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $58
801074f3:	6a 3a                	push   $0x3a
  jmp alltraps
801074f5:	e9 20 f9 ff ff       	jmp    80106e1a <alltraps>

801074fa <vector59>:
.globl vector59
vector59:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $59
801074fc:	6a 3b                	push   $0x3b
  jmp alltraps
801074fe:	e9 17 f9 ff ff       	jmp    80106e1a <alltraps>

80107503 <vector60>:
.globl vector60
vector60:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $60
80107505:	6a 3c                	push   $0x3c
  jmp alltraps
80107507:	e9 0e f9 ff ff       	jmp    80106e1a <alltraps>

8010750c <vector61>:
.globl vector61
vector61:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $61
8010750e:	6a 3d                	push   $0x3d
  jmp alltraps
80107510:	e9 05 f9 ff ff       	jmp    80106e1a <alltraps>

80107515 <vector62>:
.globl vector62
vector62:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $62
80107517:	6a 3e                	push   $0x3e
  jmp alltraps
80107519:	e9 fc f8 ff ff       	jmp    80106e1a <alltraps>

8010751e <vector63>:
.globl vector63
vector63:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $63
80107520:	6a 3f                	push   $0x3f
  jmp alltraps
80107522:	e9 f3 f8 ff ff       	jmp    80106e1a <alltraps>

80107527 <vector64>:
.globl vector64
vector64:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $64
80107529:	6a 40                	push   $0x40
  jmp alltraps
8010752b:	e9 ea f8 ff ff       	jmp    80106e1a <alltraps>

80107530 <vector65>:
.globl vector65
vector65:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $65
80107532:	6a 41                	push   $0x41
  jmp alltraps
80107534:	e9 e1 f8 ff ff       	jmp    80106e1a <alltraps>

80107539 <vector66>:
.globl vector66
vector66:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $66
8010753b:	6a 42                	push   $0x42
  jmp alltraps
8010753d:	e9 d8 f8 ff ff       	jmp    80106e1a <alltraps>

80107542 <vector67>:
.globl vector67
vector67:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $67
80107544:	6a 43                	push   $0x43
  jmp alltraps
80107546:	e9 cf f8 ff ff       	jmp    80106e1a <alltraps>

8010754b <vector68>:
.globl vector68
vector68:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $68
8010754d:	6a 44                	push   $0x44
  jmp alltraps
8010754f:	e9 c6 f8 ff ff       	jmp    80106e1a <alltraps>

80107554 <vector69>:
.globl vector69
vector69:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $69
80107556:	6a 45                	push   $0x45
  jmp alltraps
80107558:	e9 bd f8 ff ff       	jmp    80106e1a <alltraps>

8010755d <vector70>:
.globl vector70
vector70:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $70
8010755f:	6a 46                	push   $0x46
  jmp alltraps
80107561:	e9 b4 f8 ff ff       	jmp    80106e1a <alltraps>

80107566 <vector71>:
.globl vector71
vector71:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $71
80107568:	6a 47                	push   $0x47
  jmp alltraps
8010756a:	e9 ab f8 ff ff       	jmp    80106e1a <alltraps>

8010756f <vector72>:
.globl vector72
vector72:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $72
80107571:	6a 48                	push   $0x48
  jmp alltraps
80107573:	e9 a2 f8 ff ff       	jmp    80106e1a <alltraps>

80107578 <vector73>:
.globl vector73
vector73:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $73
8010757a:	6a 49                	push   $0x49
  jmp alltraps
8010757c:	e9 99 f8 ff ff       	jmp    80106e1a <alltraps>

80107581 <vector74>:
.globl vector74
vector74:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $74
80107583:	6a 4a                	push   $0x4a
  jmp alltraps
80107585:	e9 90 f8 ff ff       	jmp    80106e1a <alltraps>

8010758a <vector75>:
.globl vector75
vector75:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $75
8010758c:	6a 4b                	push   $0x4b
  jmp alltraps
8010758e:	e9 87 f8 ff ff       	jmp    80106e1a <alltraps>

80107593 <vector76>:
.globl vector76
vector76:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $76
80107595:	6a 4c                	push   $0x4c
  jmp alltraps
80107597:	e9 7e f8 ff ff       	jmp    80106e1a <alltraps>

8010759c <vector77>:
.globl vector77
vector77:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $77
8010759e:	6a 4d                	push   $0x4d
  jmp alltraps
801075a0:	e9 75 f8 ff ff       	jmp    80106e1a <alltraps>

801075a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $78
801075a7:	6a 4e                	push   $0x4e
  jmp alltraps
801075a9:	e9 6c f8 ff ff       	jmp    80106e1a <alltraps>

801075ae <vector79>:
.globl vector79
vector79:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $79
801075b0:	6a 4f                	push   $0x4f
  jmp alltraps
801075b2:	e9 63 f8 ff ff       	jmp    80106e1a <alltraps>

801075b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $80
801075b9:	6a 50                	push   $0x50
  jmp alltraps
801075bb:	e9 5a f8 ff ff       	jmp    80106e1a <alltraps>

801075c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $81
801075c2:	6a 51                	push   $0x51
  jmp alltraps
801075c4:	e9 51 f8 ff ff       	jmp    80106e1a <alltraps>

801075c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $82
801075cb:	6a 52                	push   $0x52
  jmp alltraps
801075cd:	e9 48 f8 ff ff       	jmp    80106e1a <alltraps>

801075d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $83
801075d4:	6a 53                	push   $0x53
  jmp alltraps
801075d6:	e9 3f f8 ff ff       	jmp    80106e1a <alltraps>

801075db <vector84>:
.globl vector84
vector84:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $84
801075dd:	6a 54                	push   $0x54
  jmp alltraps
801075df:	e9 36 f8 ff ff       	jmp    80106e1a <alltraps>

801075e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $85
801075e6:	6a 55                	push   $0x55
  jmp alltraps
801075e8:	e9 2d f8 ff ff       	jmp    80106e1a <alltraps>

801075ed <vector86>:
.globl vector86
vector86:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $86
801075ef:	6a 56                	push   $0x56
  jmp alltraps
801075f1:	e9 24 f8 ff ff       	jmp    80106e1a <alltraps>

801075f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $87
801075f8:	6a 57                	push   $0x57
  jmp alltraps
801075fa:	e9 1b f8 ff ff       	jmp    80106e1a <alltraps>

801075ff <vector88>:
.globl vector88
vector88:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $88
80107601:	6a 58                	push   $0x58
  jmp alltraps
80107603:	e9 12 f8 ff ff       	jmp    80106e1a <alltraps>

80107608 <vector89>:
.globl vector89
vector89:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $89
8010760a:	6a 59                	push   $0x59
  jmp alltraps
8010760c:	e9 09 f8 ff ff       	jmp    80106e1a <alltraps>

80107611 <vector90>:
.globl vector90
vector90:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $90
80107613:	6a 5a                	push   $0x5a
  jmp alltraps
80107615:	e9 00 f8 ff ff       	jmp    80106e1a <alltraps>

8010761a <vector91>:
.globl vector91
vector91:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $91
8010761c:	6a 5b                	push   $0x5b
  jmp alltraps
8010761e:	e9 f7 f7 ff ff       	jmp    80106e1a <alltraps>

80107623 <vector92>:
.globl vector92
vector92:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $92
80107625:	6a 5c                	push   $0x5c
  jmp alltraps
80107627:	e9 ee f7 ff ff       	jmp    80106e1a <alltraps>

8010762c <vector93>:
.globl vector93
vector93:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $93
8010762e:	6a 5d                	push   $0x5d
  jmp alltraps
80107630:	e9 e5 f7 ff ff       	jmp    80106e1a <alltraps>

80107635 <vector94>:
.globl vector94
vector94:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $94
80107637:	6a 5e                	push   $0x5e
  jmp alltraps
80107639:	e9 dc f7 ff ff       	jmp    80106e1a <alltraps>

8010763e <vector95>:
.globl vector95
vector95:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $95
80107640:	6a 5f                	push   $0x5f
  jmp alltraps
80107642:	e9 d3 f7 ff ff       	jmp    80106e1a <alltraps>

80107647 <vector96>:
.globl vector96
vector96:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $96
80107649:	6a 60                	push   $0x60
  jmp alltraps
8010764b:	e9 ca f7 ff ff       	jmp    80106e1a <alltraps>

80107650 <vector97>:
.globl vector97
vector97:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $97
80107652:	6a 61                	push   $0x61
  jmp alltraps
80107654:	e9 c1 f7 ff ff       	jmp    80106e1a <alltraps>

80107659 <vector98>:
.globl vector98
vector98:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $98
8010765b:	6a 62                	push   $0x62
  jmp alltraps
8010765d:	e9 b8 f7 ff ff       	jmp    80106e1a <alltraps>

80107662 <vector99>:
.globl vector99
vector99:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $99
80107664:	6a 63                	push   $0x63
  jmp alltraps
80107666:	e9 af f7 ff ff       	jmp    80106e1a <alltraps>

8010766b <vector100>:
.globl vector100
vector100:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $100
8010766d:	6a 64                	push   $0x64
  jmp alltraps
8010766f:	e9 a6 f7 ff ff       	jmp    80106e1a <alltraps>

80107674 <vector101>:
.globl vector101
vector101:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $101
80107676:	6a 65                	push   $0x65
  jmp alltraps
80107678:	e9 9d f7 ff ff       	jmp    80106e1a <alltraps>

8010767d <vector102>:
.globl vector102
vector102:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $102
8010767f:	6a 66                	push   $0x66
  jmp alltraps
80107681:	e9 94 f7 ff ff       	jmp    80106e1a <alltraps>

80107686 <vector103>:
.globl vector103
vector103:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $103
80107688:	6a 67                	push   $0x67
  jmp alltraps
8010768a:	e9 8b f7 ff ff       	jmp    80106e1a <alltraps>

8010768f <vector104>:
.globl vector104
vector104:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $104
80107691:	6a 68                	push   $0x68
  jmp alltraps
80107693:	e9 82 f7 ff ff       	jmp    80106e1a <alltraps>

80107698 <vector105>:
.globl vector105
vector105:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $105
8010769a:	6a 69                	push   $0x69
  jmp alltraps
8010769c:	e9 79 f7 ff ff       	jmp    80106e1a <alltraps>

801076a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $106
801076a3:	6a 6a                	push   $0x6a
  jmp alltraps
801076a5:	e9 70 f7 ff ff       	jmp    80106e1a <alltraps>

801076aa <vector107>:
.globl vector107
vector107:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $107
801076ac:	6a 6b                	push   $0x6b
  jmp alltraps
801076ae:	e9 67 f7 ff ff       	jmp    80106e1a <alltraps>

801076b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $108
801076b5:	6a 6c                	push   $0x6c
  jmp alltraps
801076b7:	e9 5e f7 ff ff       	jmp    80106e1a <alltraps>

801076bc <vector109>:
.globl vector109
vector109:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $109
801076be:	6a 6d                	push   $0x6d
  jmp alltraps
801076c0:	e9 55 f7 ff ff       	jmp    80106e1a <alltraps>

801076c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $110
801076c7:	6a 6e                	push   $0x6e
  jmp alltraps
801076c9:	e9 4c f7 ff ff       	jmp    80106e1a <alltraps>

801076ce <vector111>:
.globl vector111
vector111:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $111
801076d0:	6a 6f                	push   $0x6f
  jmp alltraps
801076d2:	e9 43 f7 ff ff       	jmp    80106e1a <alltraps>

801076d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $112
801076d9:	6a 70                	push   $0x70
  jmp alltraps
801076db:	e9 3a f7 ff ff       	jmp    80106e1a <alltraps>

801076e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $113
801076e2:	6a 71                	push   $0x71
  jmp alltraps
801076e4:	e9 31 f7 ff ff       	jmp    80106e1a <alltraps>

801076e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $114
801076eb:	6a 72                	push   $0x72
  jmp alltraps
801076ed:	e9 28 f7 ff ff       	jmp    80106e1a <alltraps>

801076f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $115
801076f4:	6a 73                	push   $0x73
  jmp alltraps
801076f6:	e9 1f f7 ff ff       	jmp    80106e1a <alltraps>

801076fb <vector116>:
.globl vector116
vector116:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $116
801076fd:	6a 74                	push   $0x74
  jmp alltraps
801076ff:	e9 16 f7 ff ff       	jmp    80106e1a <alltraps>

80107704 <vector117>:
.globl vector117
vector117:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $117
80107706:	6a 75                	push   $0x75
  jmp alltraps
80107708:	e9 0d f7 ff ff       	jmp    80106e1a <alltraps>

8010770d <vector118>:
.globl vector118
vector118:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $118
8010770f:	6a 76                	push   $0x76
  jmp alltraps
80107711:	e9 04 f7 ff ff       	jmp    80106e1a <alltraps>

80107716 <vector119>:
.globl vector119
vector119:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $119
80107718:	6a 77                	push   $0x77
  jmp alltraps
8010771a:	e9 fb f6 ff ff       	jmp    80106e1a <alltraps>

8010771f <vector120>:
.globl vector120
vector120:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $120
80107721:	6a 78                	push   $0x78
  jmp alltraps
80107723:	e9 f2 f6 ff ff       	jmp    80106e1a <alltraps>

80107728 <vector121>:
.globl vector121
vector121:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $121
8010772a:	6a 79                	push   $0x79
  jmp alltraps
8010772c:	e9 e9 f6 ff ff       	jmp    80106e1a <alltraps>

80107731 <vector122>:
.globl vector122
vector122:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $122
80107733:	6a 7a                	push   $0x7a
  jmp alltraps
80107735:	e9 e0 f6 ff ff       	jmp    80106e1a <alltraps>

8010773a <vector123>:
.globl vector123
vector123:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $123
8010773c:	6a 7b                	push   $0x7b
  jmp alltraps
8010773e:	e9 d7 f6 ff ff       	jmp    80106e1a <alltraps>

80107743 <vector124>:
.globl vector124
vector124:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $124
80107745:	6a 7c                	push   $0x7c
  jmp alltraps
80107747:	e9 ce f6 ff ff       	jmp    80106e1a <alltraps>

8010774c <vector125>:
.globl vector125
vector125:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $125
8010774e:	6a 7d                	push   $0x7d
  jmp alltraps
80107750:	e9 c5 f6 ff ff       	jmp    80106e1a <alltraps>

80107755 <vector126>:
.globl vector126
vector126:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $126
80107757:	6a 7e                	push   $0x7e
  jmp alltraps
80107759:	e9 bc f6 ff ff       	jmp    80106e1a <alltraps>

8010775e <vector127>:
.globl vector127
vector127:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $127
80107760:	6a 7f                	push   $0x7f
  jmp alltraps
80107762:	e9 b3 f6 ff ff       	jmp    80106e1a <alltraps>

80107767 <vector128>:
.globl vector128
vector128:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $128
80107769:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010776e:	e9 a7 f6 ff ff       	jmp    80106e1a <alltraps>

80107773 <vector129>:
.globl vector129
vector129:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $129
80107775:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010777a:	e9 9b f6 ff ff       	jmp    80106e1a <alltraps>

8010777f <vector130>:
.globl vector130
vector130:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $130
80107781:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107786:	e9 8f f6 ff ff       	jmp    80106e1a <alltraps>

8010778b <vector131>:
.globl vector131
vector131:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $131
8010778d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107792:	e9 83 f6 ff ff       	jmp    80106e1a <alltraps>

80107797 <vector132>:
.globl vector132
vector132:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $132
80107799:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010779e:	e9 77 f6 ff ff       	jmp    80106e1a <alltraps>

801077a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $133
801077a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801077aa:	e9 6b f6 ff ff       	jmp    80106e1a <alltraps>

801077af <vector134>:
.globl vector134
vector134:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $134
801077b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801077b6:	e9 5f f6 ff ff       	jmp    80106e1a <alltraps>

801077bb <vector135>:
.globl vector135
vector135:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $135
801077bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801077c2:	e9 53 f6 ff ff       	jmp    80106e1a <alltraps>

801077c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $136
801077c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801077ce:	e9 47 f6 ff ff       	jmp    80106e1a <alltraps>

801077d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $137
801077d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801077da:	e9 3b f6 ff ff       	jmp    80106e1a <alltraps>

801077df <vector138>:
.globl vector138
vector138:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $138
801077e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801077e6:	e9 2f f6 ff ff       	jmp    80106e1a <alltraps>

801077eb <vector139>:
.globl vector139
vector139:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $139
801077ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801077f2:	e9 23 f6 ff ff       	jmp    80106e1a <alltraps>

801077f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $140
801077f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801077fe:	e9 17 f6 ff ff       	jmp    80106e1a <alltraps>

80107803 <vector141>:
.globl vector141
vector141:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $141
80107805:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010780a:	e9 0b f6 ff ff       	jmp    80106e1a <alltraps>

8010780f <vector142>:
.globl vector142
vector142:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $142
80107811:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107816:	e9 ff f5 ff ff       	jmp    80106e1a <alltraps>

8010781b <vector143>:
.globl vector143
vector143:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $143
8010781d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107822:	e9 f3 f5 ff ff       	jmp    80106e1a <alltraps>

80107827 <vector144>:
.globl vector144
vector144:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $144
80107829:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010782e:	e9 e7 f5 ff ff       	jmp    80106e1a <alltraps>

80107833 <vector145>:
.globl vector145
vector145:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $145
80107835:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010783a:	e9 db f5 ff ff       	jmp    80106e1a <alltraps>

8010783f <vector146>:
.globl vector146
vector146:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $146
80107841:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107846:	e9 cf f5 ff ff       	jmp    80106e1a <alltraps>

8010784b <vector147>:
.globl vector147
vector147:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $147
8010784d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107852:	e9 c3 f5 ff ff       	jmp    80106e1a <alltraps>

80107857 <vector148>:
.globl vector148
vector148:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $148
80107859:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010785e:	e9 b7 f5 ff ff       	jmp    80106e1a <alltraps>

80107863 <vector149>:
.globl vector149
vector149:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $149
80107865:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010786a:	e9 ab f5 ff ff       	jmp    80106e1a <alltraps>

8010786f <vector150>:
.globl vector150
vector150:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $150
80107871:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107876:	e9 9f f5 ff ff       	jmp    80106e1a <alltraps>

8010787b <vector151>:
.globl vector151
vector151:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $151
8010787d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107882:	e9 93 f5 ff ff       	jmp    80106e1a <alltraps>

80107887 <vector152>:
.globl vector152
vector152:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $152
80107889:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010788e:	e9 87 f5 ff ff       	jmp    80106e1a <alltraps>

80107893 <vector153>:
.globl vector153
vector153:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $153
80107895:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010789a:	e9 7b f5 ff ff       	jmp    80106e1a <alltraps>

8010789f <vector154>:
.globl vector154
vector154:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $154
801078a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801078a6:	e9 6f f5 ff ff       	jmp    80106e1a <alltraps>

801078ab <vector155>:
.globl vector155
vector155:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $155
801078ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801078b2:	e9 63 f5 ff ff       	jmp    80106e1a <alltraps>

801078b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $156
801078b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801078be:	e9 57 f5 ff ff       	jmp    80106e1a <alltraps>

801078c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $157
801078c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801078ca:	e9 4b f5 ff ff       	jmp    80106e1a <alltraps>

801078cf <vector158>:
.globl vector158
vector158:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $158
801078d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801078d6:	e9 3f f5 ff ff       	jmp    80106e1a <alltraps>

801078db <vector159>:
.globl vector159
vector159:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $159
801078dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801078e2:	e9 33 f5 ff ff       	jmp    80106e1a <alltraps>

801078e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $160
801078e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801078ee:	e9 27 f5 ff ff       	jmp    80106e1a <alltraps>

801078f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $161
801078f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801078fa:	e9 1b f5 ff ff       	jmp    80106e1a <alltraps>

801078ff <vector162>:
.globl vector162
vector162:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $162
80107901:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107906:	e9 0f f5 ff ff       	jmp    80106e1a <alltraps>

8010790b <vector163>:
.globl vector163
vector163:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $163
8010790d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107912:	e9 03 f5 ff ff       	jmp    80106e1a <alltraps>

80107917 <vector164>:
.globl vector164
vector164:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $164
80107919:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010791e:	e9 f7 f4 ff ff       	jmp    80106e1a <alltraps>

80107923 <vector165>:
.globl vector165
vector165:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $165
80107925:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010792a:	e9 eb f4 ff ff       	jmp    80106e1a <alltraps>

8010792f <vector166>:
.globl vector166
vector166:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $166
80107931:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107936:	e9 df f4 ff ff       	jmp    80106e1a <alltraps>

8010793b <vector167>:
.globl vector167
vector167:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $167
8010793d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107942:	e9 d3 f4 ff ff       	jmp    80106e1a <alltraps>

80107947 <vector168>:
.globl vector168
vector168:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $168
80107949:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010794e:	e9 c7 f4 ff ff       	jmp    80106e1a <alltraps>

80107953 <vector169>:
.globl vector169
vector169:
  pushl $0
80107953:	6a 00                	push   $0x0
  pushl $169
80107955:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010795a:	e9 bb f4 ff ff       	jmp    80106e1a <alltraps>

8010795f <vector170>:
.globl vector170
vector170:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $170
80107961:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107966:	e9 af f4 ff ff       	jmp    80106e1a <alltraps>

8010796b <vector171>:
.globl vector171
vector171:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $171
8010796d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107972:	e9 a3 f4 ff ff       	jmp    80106e1a <alltraps>

80107977 <vector172>:
.globl vector172
vector172:
  pushl $0
80107977:	6a 00                	push   $0x0
  pushl $172
80107979:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010797e:	e9 97 f4 ff ff       	jmp    80106e1a <alltraps>

80107983 <vector173>:
.globl vector173
vector173:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $173
80107985:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010798a:	e9 8b f4 ff ff       	jmp    80106e1a <alltraps>

8010798f <vector174>:
.globl vector174
vector174:
  pushl $0
8010798f:	6a 00                	push   $0x0
  pushl $174
80107991:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107996:	e9 7f f4 ff ff       	jmp    80106e1a <alltraps>

8010799b <vector175>:
.globl vector175
vector175:
  pushl $0
8010799b:	6a 00                	push   $0x0
  pushl $175
8010799d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801079a2:	e9 73 f4 ff ff       	jmp    80106e1a <alltraps>

801079a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $176
801079a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801079ae:	e9 67 f4 ff ff       	jmp    80106e1a <alltraps>

801079b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $177
801079b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801079ba:	e9 5b f4 ff ff       	jmp    80106e1a <alltraps>

801079bf <vector178>:
.globl vector178
vector178:
  pushl $0
801079bf:	6a 00                	push   $0x0
  pushl $178
801079c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801079c6:	e9 4f f4 ff ff       	jmp    80106e1a <alltraps>

801079cb <vector179>:
.globl vector179
vector179:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $179
801079cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801079d2:	e9 43 f4 ff ff       	jmp    80106e1a <alltraps>

801079d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $180
801079d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801079de:	e9 37 f4 ff ff       	jmp    80106e1a <alltraps>

801079e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801079e3:	6a 00                	push   $0x0
  pushl $181
801079e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801079ea:	e9 2b f4 ff ff       	jmp    80106e1a <alltraps>

801079ef <vector182>:
.globl vector182
vector182:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $182
801079f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801079f6:	e9 1f f4 ff ff       	jmp    80106e1a <alltraps>

801079fb <vector183>:
.globl vector183
vector183:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $183
801079fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107a02:	e9 13 f4 ff ff       	jmp    80106e1a <alltraps>

80107a07 <vector184>:
.globl vector184
vector184:
  pushl $0
80107a07:	6a 00                	push   $0x0
  pushl $184
80107a09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107a0e:	e9 07 f4 ff ff       	jmp    80106e1a <alltraps>

80107a13 <vector185>:
.globl vector185
vector185:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $185
80107a15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107a1a:	e9 fb f3 ff ff       	jmp    80106e1a <alltraps>

80107a1f <vector186>:
.globl vector186
vector186:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $186
80107a21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107a26:	e9 ef f3 ff ff       	jmp    80106e1a <alltraps>

80107a2b <vector187>:
.globl vector187
vector187:
  pushl $0
80107a2b:	6a 00                	push   $0x0
  pushl $187
80107a2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107a32:	e9 e3 f3 ff ff       	jmp    80106e1a <alltraps>

80107a37 <vector188>:
.globl vector188
vector188:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $188
80107a39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107a3e:	e9 d7 f3 ff ff       	jmp    80106e1a <alltraps>

80107a43 <vector189>:
.globl vector189
vector189:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $189
80107a45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107a4a:	e9 cb f3 ff ff       	jmp    80106e1a <alltraps>

80107a4f <vector190>:
.globl vector190
vector190:
  pushl $0
80107a4f:	6a 00                	push   $0x0
  pushl $190
80107a51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107a56:	e9 bf f3 ff ff       	jmp    80106e1a <alltraps>

80107a5b <vector191>:
.globl vector191
vector191:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $191
80107a5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107a62:	e9 b3 f3 ff ff       	jmp    80106e1a <alltraps>

80107a67 <vector192>:
.globl vector192
vector192:
  pushl $0
80107a67:	6a 00                	push   $0x0
  pushl $192
80107a69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107a6e:	e9 a7 f3 ff ff       	jmp    80106e1a <alltraps>

80107a73 <vector193>:
.globl vector193
vector193:
  pushl $0
80107a73:	6a 00                	push   $0x0
  pushl $193
80107a75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107a7a:	e9 9b f3 ff ff       	jmp    80106e1a <alltraps>

80107a7f <vector194>:
.globl vector194
vector194:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $194
80107a81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107a86:	e9 8f f3 ff ff       	jmp    80106e1a <alltraps>

80107a8b <vector195>:
.globl vector195
vector195:
  pushl $0
80107a8b:	6a 00                	push   $0x0
  pushl $195
80107a8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107a92:	e9 83 f3 ff ff       	jmp    80106e1a <alltraps>

80107a97 <vector196>:
.globl vector196
vector196:
  pushl $0
80107a97:	6a 00                	push   $0x0
  pushl $196
80107a99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107a9e:	e9 77 f3 ff ff       	jmp    80106e1a <alltraps>

80107aa3 <vector197>:
.globl vector197
vector197:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $197
80107aa5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107aaa:	e9 6b f3 ff ff       	jmp    80106e1a <alltraps>

80107aaf <vector198>:
.globl vector198
vector198:
  pushl $0
80107aaf:	6a 00                	push   $0x0
  pushl $198
80107ab1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107ab6:	e9 5f f3 ff ff       	jmp    80106e1a <alltraps>

80107abb <vector199>:
.globl vector199
vector199:
  pushl $0
80107abb:	6a 00                	push   $0x0
  pushl $199
80107abd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107ac2:	e9 53 f3 ff ff       	jmp    80106e1a <alltraps>

80107ac7 <vector200>:
.globl vector200
vector200:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $200
80107ac9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107ace:	e9 47 f3 ff ff       	jmp    80106e1a <alltraps>

80107ad3 <vector201>:
.globl vector201
vector201:
  pushl $0
80107ad3:	6a 00                	push   $0x0
  pushl $201
80107ad5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107ada:	e9 3b f3 ff ff       	jmp    80106e1a <alltraps>

80107adf <vector202>:
.globl vector202
vector202:
  pushl $0
80107adf:	6a 00                	push   $0x0
  pushl $202
80107ae1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107ae6:	e9 2f f3 ff ff       	jmp    80106e1a <alltraps>

80107aeb <vector203>:
.globl vector203
vector203:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $203
80107aed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107af2:	e9 23 f3 ff ff       	jmp    80106e1a <alltraps>

80107af7 <vector204>:
.globl vector204
vector204:
  pushl $0
80107af7:	6a 00                	push   $0x0
  pushl $204
80107af9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107afe:	e9 17 f3 ff ff       	jmp    80106e1a <alltraps>

80107b03 <vector205>:
.globl vector205
vector205:
  pushl $0
80107b03:	6a 00                	push   $0x0
  pushl $205
80107b05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107b0a:	e9 0b f3 ff ff       	jmp    80106e1a <alltraps>

80107b0f <vector206>:
.globl vector206
vector206:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $206
80107b11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107b16:	e9 ff f2 ff ff       	jmp    80106e1a <alltraps>

80107b1b <vector207>:
.globl vector207
vector207:
  pushl $0
80107b1b:	6a 00                	push   $0x0
  pushl $207
80107b1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107b22:	e9 f3 f2 ff ff       	jmp    80106e1a <alltraps>

80107b27 <vector208>:
.globl vector208
vector208:
  pushl $0
80107b27:	6a 00                	push   $0x0
  pushl $208
80107b29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107b2e:	e9 e7 f2 ff ff       	jmp    80106e1a <alltraps>

80107b33 <vector209>:
.globl vector209
vector209:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $209
80107b35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107b3a:	e9 db f2 ff ff       	jmp    80106e1a <alltraps>

80107b3f <vector210>:
.globl vector210
vector210:
  pushl $0
80107b3f:	6a 00                	push   $0x0
  pushl $210
80107b41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107b46:	e9 cf f2 ff ff       	jmp    80106e1a <alltraps>

80107b4b <vector211>:
.globl vector211
vector211:
  pushl $0
80107b4b:	6a 00                	push   $0x0
  pushl $211
80107b4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107b52:	e9 c3 f2 ff ff       	jmp    80106e1a <alltraps>

80107b57 <vector212>:
.globl vector212
vector212:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $212
80107b59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107b5e:	e9 b7 f2 ff ff       	jmp    80106e1a <alltraps>

80107b63 <vector213>:
.globl vector213
vector213:
  pushl $0
80107b63:	6a 00                	push   $0x0
  pushl $213
80107b65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107b6a:	e9 ab f2 ff ff       	jmp    80106e1a <alltraps>

80107b6f <vector214>:
.globl vector214
vector214:
  pushl $0
80107b6f:	6a 00                	push   $0x0
  pushl $214
80107b71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107b76:	e9 9f f2 ff ff       	jmp    80106e1a <alltraps>

80107b7b <vector215>:
.globl vector215
vector215:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $215
80107b7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107b82:	e9 93 f2 ff ff       	jmp    80106e1a <alltraps>

80107b87 <vector216>:
.globl vector216
vector216:
  pushl $0
80107b87:	6a 00                	push   $0x0
  pushl $216
80107b89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107b8e:	e9 87 f2 ff ff       	jmp    80106e1a <alltraps>

80107b93 <vector217>:
.globl vector217
vector217:
  pushl $0
80107b93:	6a 00                	push   $0x0
  pushl $217
80107b95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107b9a:	e9 7b f2 ff ff       	jmp    80106e1a <alltraps>

80107b9f <vector218>:
.globl vector218
vector218:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $218
80107ba1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ba6:	e9 6f f2 ff ff       	jmp    80106e1a <alltraps>

80107bab <vector219>:
.globl vector219
vector219:
  pushl $0
80107bab:	6a 00                	push   $0x0
  pushl $219
80107bad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107bb2:	e9 63 f2 ff ff       	jmp    80106e1a <alltraps>

80107bb7 <vector220>:
.globl vector220
vector220:
  pushl $0
80107bb7:	6a 00                	push   $0x0
  pushl $220
80107bb9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107bbe:	e9 57 f2 ff ff       	jmp    80106e1a <alltraps>

80107bc3 <vector221>:
.globl vector221
vector221:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $221
80107bc5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107bca:	e9 4b f2 ff ff       	jmp    80106e1a <alltraps>

80107bcf <vector222>:
.globl vector222
vector222:
  pushl $0
80107bcf:	6a 00                	push   $0x0
  pushl $222
80107bd1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107bd6:	e9 3f f2 ff ff       	jmp    80106e1a <alltraps>

80107bdb <vector223>:
.globl vector223
vector223:
  pushl $0
80107bdb:	6a 00                	push   $0x0
  pushl $223
80107bdd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107be2:	e9 33 f2 ff ff       	jmp    80106e1a <alltraps>

80107be7 <vector224>:
.globl vector224
vector224:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $224
80107be9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107bee:	e9 27 f2 ff ff       	jmp    80106e1a <alltraps>

80107bf3 <vector225>:
.globl vector225
vector225:
  pushl $0
80107bf3:	6a 00                	push   $0x0
  pushl $225
80107bf5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107bfa:	e9 1b f2 ff ff       	jmp    80106e1a <alltraps>

80107bff <vector226>:
.globl vector226
vector226:
  pushl $0
80107bff:	6a 00                	push   $0x0
  pushl $226
80107c01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107c06:	e9 0f f2 ff ff       	jmp    80106e1a <alltraps>

80107c0b <vector227>:
.globl vector227
vector227:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $227
80107c0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107c12:	e9 03 f2 ff ff       	jmp    80106e1a <alltraps>

80107c17 <vector228>:
.globl vector228
vector228:
  pushl $0
80107c17:	6a 00                	push   $0x0
  pushl $228
80107c19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107c1e:	e9 f7 f1 ff ff       	jmp    80106e1a <alltraps>

80107c23 <vector229>:
.globl vector229
vector229:
  pushl $0
80107c23:	6a 00                	push   $0x0
  pushl $229
80107c25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107c2a:	e9 eb f1 ff ff       	jmp    80106e1a <alltraps>

80107c2f <vector230>:
.globl vector230
vector230:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $230
80107c31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107c36:	e9 df f1 ff ff       	jmp    80106e1a <alltraps>

80107c3b <vector231>:
.globl vector231
vector231:
  pushl $0
80107c3b:	6a 00                	push   $0x0
  pushl $231
80107c3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107c42:	e9 d3 f1 ff ff       	jmp    80106e1a <alltraps>

80107c47 <vector232>:
.globl vector232
vector232:
  pushl $0
80107c47:	6a 00                	push   $0x0
  pushl $232
80107c49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107c4e:	e9 c7 f1 ff ff       	jmp    80106e1a <alltraps>

80107c53 <vector233>:
.globl vector233
vector233:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $233
80107c55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107c5a:	e9 bb f1 ff ff       	jmp    80106e1a <alltraps>

80107c5f <vector234>:
.globl vector234
vector234:
  pushl $0
80107c5f:	6a 00                	push   $0x0
  pushl $234
80107c61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107c66:	e9 af f1 ff ff       	jmp    80106e1a <alltraps>

80107c6b <vector235>:
.globl vector235
vector235:
  pushl $0
80107c6b:	6a 00                	push   $0x0
  pushl $235
80107c6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107c72:	e9 a3 f1 ff ff       	jmp    80106e1a <alltraps>

80107c77 <vector236>:
.globl vector236
vector236:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $236
80107c79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107c7e:	e9 97 f1 ff ff       	jmp    80106e1a <alltraps>

80107c83 <vector237>:
.globl vector237
vector237:
  pushl $0
80107c83:	6a 00                	push   $0x0
  pushl $237
80107c85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107c8a:	e9 8b f1 ff ff       	jmp    80106e1a <alltraps>

80107c8f <vector238>:
.globl vector238
vector238:
  pushl $0
80107c8f:	6a 00                	push   $0x0
  pushl $238
80107c91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c96:	e9 7f f1 ff ff       	jmp    80106e1a <alltraps>

80107c9b <vector239>:
.globl vector239
vector239:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $239
80107c9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ca2:	e9 73 f1 ff ff       	jmp    80106e1a <alltraps>

80107ca7 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ca7:	6a 00                	push   $0x0
  pushl $240
80107ca9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107cae:	e9 67 f1 ff ff       	jmp    80106e1a <alltraps>

80107cb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80107cb3:	6a 00                	push   $0x0
  pushl $241
80107cb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107cba:	e9 5b f1 ff ff       	jmp    80106e1a <alltraps>

80107cbf <vector242>:
.globl vector242
vector242:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $242
80107cc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107cc6:	e9 4f f1 ff ff       	jmp    80106e1a <alltraps>

80107ccb <vector243>:
.globl vector243
vector243:
  pushl $0
80107ccb:	6a 00                	push   $0x0
  pushl $243
80107ccd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107cd2:	e9 43 f1 ff ff       	jmp    80106e1a <alltraps>

80107cd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80107cd7:	6a 00                	push   $0x0
  pushl $244
80107cd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107cde:	e9 37 f1 ff ff       	jmp    80106e1a <alltraps>

80107ce3 <vector245>:
.globl vector245
vector245:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $245
80107ce5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107cea:	e9 2b f1 ff ff       	jmp    80106e1a <alltraps>

80107cef <vector246>:
.globl vector246
vector246:
  pushl $0
80107cef:	6a 00                	push   $0x0
  pushl $246
80107cf1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107cf6:	e9 1f f1 ff ff       	jmp    80106e1a <alltraps>

80107cfb <vector247>:
.globl vector247
vector247:
  pushl $0
80107cfb:	6a 00                	push   $0x0
  pushl $247
80107cfd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107d02:	e9 13 f1 ff ff       	jmp    80106e1a <alltraps>

80107d07 <vector248>:
.globl vector248
vector248:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $248
80107d09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107d0e:	e9 07 f1 ff ff       	jmp    80106e1a <alltraps>

80107d13 <vector249>:
.globl vector249
vector249:
  pushl $0
80107d13:	6a 00                	push   $0x0
  pushl $249
80107d15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107d1a:	e9 fb f0 ff ff       	jmp    80106e1a <alltraps>

80107d1f <vector250>:
.globl vector250
vector250:
  pushl $0
80107d1f:	6a 00                	push   $0x0
  pushl $250
80107d21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107d26:	e9 ef f0 ff ff       	jmp    80106e1a <alltraps>

80107d2b <vector251>:
.globl vector251
vector251:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $251
80107d2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107d32:	e9 e3 f0 ff ff       	jmp    80106e1a <alltraps>

80107d37 <vector252>:
.globl vector252
vector252:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $252
80107d39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107d3e:	e9 d7 f0 ff ff       	jmp    80106e1a <alltraps>

80107d43 <vector253>:
.globl vector253
vector253:
  pushl $0
80107d43:	6a 00                	push   $0x0
  pushl $253
80107d45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107d4a:	e9 cb f0 ff ff       	jmp    80106e1a <alltraps>

80107d4f <vector254>:
.globl vector254
vector254:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $254
80107d51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107d56:	e9 bf f0 ff ff       	jmp    80106e1a <alltraps>

80107d5b <vector255>:
.globl vector255
vector255:
  pushl $0
80107d5b:	6a 00                	push   $0x0
  pushl $255
80107d5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107d62:	e9 b3 f0 ff ff       	jmp    80106e1a <alltraps>
80107d67:	66 90                	xchg   %ax,%ax
80107d69:	66 90                	xchg   %ax,%ax
80107d6b:	66 90                	xchg   %ax,%ax
80107d6d:	66 90                	xchg   %ax,%ax
80107d6f:	90                   	nop

80107d70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107d70:	55                   	push   %ebp
80107d71:	89 e5                	mov    %esp,%ebp
80107d73:	57                   	push   %edi
80107d74:	56                   	push   %esi
80107d75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107d76:	89 d3                	mov    %edx,%ebx
{
80107d78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80107d7a:	c1 eb 16             	shr    $0x16,%ebx
80107d7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107d80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107d83:	8b 06                	mov    (%esi),%eax
80107d85:	a8 01                	test   $0x1,%al
80107d87:	74 27                	je     80107db0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107d94:	c1 ef 0a             	shr    $0xa,%edi
}
80107d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107d9a:	89 fa                	mov    %edi,%edx
80107d9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107da2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107da5:	5b                   	pop    %ebx
80107da6:	5e                   	pop    %esi
80107da7:	5f                   	pop    %edi
80107da8:	5d                   	pop    %ebp
80107da9:	c3                   	ret    
80107daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107db0:	85 c9                	test   %ecx,%ecx
80107db2:	74 2c                	je     80107de0 <walkpgdir+0x70>
80107db4:	e8 57 ab ff ff       	call   80102910 <kalloc>
80107db9:	85 c0                	test   %eax,%eax
80107dbb:	89 c3                	mov    %eax,%ebx
80107dbd:	74 21                	je     80107de0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107dbf:	83 ec 04             	sub    $0x4,%esp
80107dc2:	68 00 10 00 00       	push   $0x1000
80107dc7:	6a 00                	push   $0x0
80107dc9:	50                   	push   %eax
80107dca:	e8 51 de ff ff       	call   80105c20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107dcf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107dd5:	83 c4 10             	add    $0x10,%esp
80107dd8:	83 c8 07             	or     $0x7,%eax
80107ddb:	89 06                	mov    %eax,(%esi)
80107ddd:	eb b5                	jmp    80107d94 <walkpgdir+0x24>
80107ddf:	90                   	nop
}
80107de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107de3:	31 c0                	xor    %eax,%eax
}
80107de5:	5b                   	pop    %ebx
80107de6:	5e                   	pop    %esi
80107de7:	5f                   	pop    %edi
80107de8:	5d                   	pop    %ebp
80107de9:	c3                   	ret    
80107dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107df0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	57                   	push   %edi
80107df4:	56                   	push   %esi
80107df5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107df6:	89 d3                	mov    %edx,%ebx
80107df8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107dfe:	83 ec 1c             	sub    $0x1c,%esp
80107e01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107e04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107e08:	8b 7d 08             	mov    0x8(%ebp),%edi
80107e0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107e13:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e16:	29 df                	sub    %ebx,%edi
80107e18:	83 c8 01             	or     $0x1,%eax
80107e1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e1e:	eb 15                	jmp    80107e35 <mappages+0x45>
    if(*pte & PTE_P)
80107e20:	f6 00 01             	testb  $0x1,(%eax)
80107e23:	75 45                	jne    80107e6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107e25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107e28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107e2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107e2d:	74 31                	je     80107e60 <mappages+0x70>
      break;
    a += PGSIZE;
80107e2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e38:	b9 01 00 00 00       	mov    $0x1,%ecx
80107e3d:	89 da                	mov    %ebx,%edx
80107e3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107e42:	e8 29 ff ff ff       	call   80107d70 <walkpgdir>
80107e47:	85 c0                	test   %eax,%eax
80107e49:	75 d5                	jne    80107e20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e53:	5b                   	pop    %ebx
80107e54:	5e                   	pop    %esi
80107e55:	5f                   	pop    %edi
80107e56:	5d                   	pop    %ebp
80107e57:	c3                   	ret    
80107e58:	90                   	nop
80107e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e63:	31 c0                	xor    %eax,%eax
}
80107e65:	5b                   	pop    %ebx
80107e66:	5e                   	pop    %esi
80107e67:	5f                   	pop    %edi
80107e68:	5d                   	pop    %ebp
80107e69:	c3                   	ret    
      panic("remap");
80107e6a:	83 ec 0c             	sub    $0xc,%esp
80107e6d:	68 a4 91 10 80       	push   $0x801091a4
80107e72:	e8 19 85 ff ff       	call   80100390 <panic>
80107e77:	89 f6                	mov    %esi,%esi
80107e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107e86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107e8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80107e8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107e94:	83 ec 1c             	sub    $0x1c,%esp
80107e97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107e9a:	39 d3                	cmp    %edx,%ebx
80107e9c:	73 66                	jae    80107f04 <deallocuvm.part.0+0x84>
80107e9e:	89 d6                	mov    %edx,%esi
80107ea0:	eb 3d                	jmp    80107edf <deallocuvm.part.0+0x5f>
80107ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107ea8:	8b 10                	mov    (%eax),%edx
80107eaa:	f6 c2 01             	test   $0x1,%dl
80107ead:	74 26                	je     80107ed5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107eaf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107eb5:	74 58                	je     80107f0f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107eb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107eba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107ec3:	52                   	push   %edx
80107ec4:	e8 97 a8 ff ff       	call   80102760 <kfree>
      *pte = 0;
80107ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ecc:	83 c4 10             	add    $0x10,%esp
80107ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107ed5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107edb:	39 f3                	cmp    %esi,%ebx
80107edd:	73 25                	jae    80107f04 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107edf:	31 c9                	xor    %ecx,%ecx
80107ee1:	89 da                	mov    %ebx,%edx
80107ee3:	89 f8                	mov    %edi,%eax
80107ee5:	e8 86 fe ff ff       	call   80107d70 <walkpgdir>
    if(!pte)
80107eea:	85 c0                	test   %eax,%eax
80107eec:	75 ba                	jne    80107ea8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107eee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107ef4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107efa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f00:	39 f3                	cmp    %esi,%ebx
80107f02:	72 db                	jb     80107edf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f0a:	5b                   	pop    %ebx
80107f0b:	5e                   	pop    %esi
80107f0c:	5f                   	pop    %edi
80107f0d:	5d                   	pop    %ebp
80107f0e:	c3                   	ret    
        panic("kfree");
80107f0f:	83 ec 0c             	sub    $0xc,%esp
80107f12:	68 06 89 10 80       	push   $0x80108906
80107f17:	e8 74 84 ff ff       	call   80100390 <panic>
80107f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107f20 <seginit>:
{
80107f20:	55                   	push   %ebp
80107f21:	89 e5                	mov    %esp,%ebp
80107f23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107f26:	e8 f5 bc ff ff       	call   80103c20 <cpuid>
80107f2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107f31:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107f36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f3a:	c7 80 f8 4e 11 80 ff 	movl   $0xffff,-0x7feeb108(%eax)
80107f41:	ff 00 00 
80107f44:	c7 80 fc 4e 11 80 00 	movl   $0xcf9a00,-0x7feeb104(%eax)
80107f4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f4e:	c7 80 00 4f 11 80 ff 	movl   $0xffff,-0x7feeb100(%eax)
80107f55:	ff 00 00 
80107f58:	c7 80 04 4f 11 80 00 	movl   $0xcf9200,-0x7feeb0fc(%eax)
80107f5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107f62:	c7 80 08 4f 11 80 ff 	movl   $0xffff,-0x7feeb0f8(%eax)
80107f69:	ff 00 00 
80107f6c:	c7 80 0c 4f 11 80 00 	movl   $0xcffa00,-0x7feeb0f4(%eax)
80107f73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f76:	c7 80 10 4f 11 80 ff 	movl   $0xffff,-0x7feeb0f0(%eax)
80107f7d:	ff 00 00 
80107f80:	c7 80 14 4f 11 80 00 	movl   $0xcff200,-0x7feeb0ec(%eax)
80107f87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107f8a:	05 f0 4e 11 80       	add    $0x80114ef0,%eax
  pd[1] = (uint)p;
80107f8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107f93:	c1 e8 10             	shr    $0x10,%eax
80107f96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107f9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107f9d:	0f 01 10             	lgdtl  (%eax)
}
80107fa0:	c9                   	leave  
80107fa1:	c3                   	ret    
80107fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107fb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107fb0:	a1 e4 86 11 80       	mov    0x801186e4,%eax
{
80107fb5:	55                   	push   %ebp
80107fb6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107fb8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107fbd:	0f 22 d8             	mov    %eax,%cr3
}
80107fc0:	5d                   	pop    %ebp
80107fc1:	c3                   	ret    
80107fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107fd0 <switchuvm>:
{
80107fd0:	55                   	push   %ebp
80107fd1:	89 e5                	mov    %esp,%ebp
80107fd3:	57                   	push   %edi
80107fd4:	56                   	push   %esi
80107fd5:	53                   	push   %ebx
80107fd6:	83 ec 1c             	sub    $0x1c,%esp
80107fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107fdc:	85 db                	test   %ebx,%ebx
80107fde:	0f 84 cb 00 00 00    	je     801080af <switchuvm+0xdf>
  if(p->kstack == 0)
80107fe4:	8b 43 08             	mov    0x8(%ebx),%eax
80107fe7:	85 c0                	test   %eax,%eax
80107fe9:	0f 84 da 00 00 00    	je     801080c9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107fef:	8b 43 04             	mov    0x4(%ebx),%eax
80107ff2:	85 c0                	test   %eax,%eax
80107ff4:	0f 84 c2 00 00 00    	je     801080bc <switchuvm+0xec>
  pushcli();
80107ffa:	e8 41 da ff ff       	call   80105a40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107fff:	e8 9c bb ff ff       	call   80103ba0 <mycpu>
80108004:	89 c6                	mov    %eax,%esi
80108006:	e8 95 bb ff ff       	call   80103ba0 <mycpu>
8010800b:	89 c7                	mov    %eax,%edi
8010800d:	e8 8e bb ff ff       	call   80103ba0 <mycpu>
80108012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108015:	83 c7 08             	add    $0x8,%edi
80108018:	e8 83 bb ff ff       	call   80103ba0 <mycpu>
8010801d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108020:	83 c0 08             	add    $0x8,%eax
80108023:	ba 67 00 00 00       	mov    $0x67,%edx
80108028:	c1 e8 18             	shr    $0x18,%eax
8010802b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80108032:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80108039:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010803f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108044:	83 c1 08             	add    $0x8,%ecx
80108047:	c1 e9 10             	shr    $0x10,%ecx
8010804a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80108050:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108055:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010805c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80108061:	e8 3a bb ff ff       	call   80103ba0 <mycpu>
80108066:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010806d:	e8 2e bb ff ff       	call   80103ba0 <mycpu>
80108072:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108076:	8b 73 08             	mov    0x8(%ebx),%esi
80108079:	e8 22 bb ff ff       	call   80103ba0 <mycpu>
8010807e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108084:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108087:	e8 14 bb ff ff       	call   80103ba0 <mycpu>
8010808c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108090:	b8 28 00 00 00       	mov    $0x28,%eax
80108095:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108098:	8b 43 04             	mov    0x4(%ebx),%eax
8010809b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801080a0:	0f 22 d8             	mov    %eax,%cr3
}
801080a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080a6:	5b                   	pop    %ebx
801080a7:	5e                   	pop    %esi
801080a8:	5f                   	pop    %edi
801080a9:	5d                   	pop    %ebp
  popcli();
801080aa:	e9 d1 d9 ff ff       	jmp    80105a80 <popcli>
    panic("switchuvm: no process");
801080af:	83 ec 0c             	sub    $0xc,%esp
801080b2:	68 aa 91 10 80       	push   $0x801091aa
801080b7:	e8 d4 82 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801080bc:	83 ec 0c             	sub    $0xc,%esp
801080bf:	68 d5 91 10 80       	push   $0x801091d5
801080c4:	e8 c7 82 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801080c9:	83 ec 0c             	sub    $0xc,%esp
801080cc:	68 c0 91 10 80       	push   $0x801091c0
801080d1:	e8 ba 82 ff ff       	call   80100390 <panic>
801080d6:	8d 76 00             	lea    0x0(%esi),%esi
801080d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080e0 <inituvm>:
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	57                   	push   %edi
801080e4:	56                   	push   %esi
801080e5:	53                   	push   %ebx
801080e6:	83 ec 1c             	sub    $0x1c,%esp
801080e9:	8b 75 10             	mov    0x10(%ebp),%esi
801080ec:	8b 45 08             	mov    0x8(%ebp),%eax
801080ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801080f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801080f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801080fb:	77 49                	ja     80108146 <inituvm+0x66>
  mem = kalloc();
801080fd:	e8 0e a8 ff ff       	call   80102910 <kalloc>
  memset(mem, 0, PGSIZE);
80108102:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80108105:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108107:	68 00 10 00 00       	push   $0x1000
8010810c:	6a 00                	push   $0x0
8010810e:	50                   	push   %eax
8010810f:	e8 0c db ff ff       	call   80105c20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108114:	58                   	pop    %eax
80108115:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010811b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108120:	5a                   	pop    %edx
80108121:	6a 06                	push   $0x6
80108123:	50                   	push   %eax
80108124:	31 d2                	xor    %edx,%edx
80108126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108129:	e8 c2 fc ff ff       	call   80107df0 <mappages>
  memmove(mem, init, sz);
8010812e:	89 75 10             	mov    %esi,0x10(%ebp)
80108131:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108134:	83 c4 10             	add    $0x10,%esp
80108137:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010813a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010813d:	5b                   	pop    %ebx
8010813e:	5e                   	pop    %esi
8010813f:	5f                   	pop    %edi
80108140:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108141:	e9 8a db ff ff       	jmp    80105cd0 <memmove>
    panic("inituvm: more than a page");
80108146:	83 ec 0c             	sub    $0xc,%esp
80108149:	68 e9 91 10 80       	push   $0x801091e9
8010814e:	e8 3d 82 ff ff       	call   80100390 <panic>
80108153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108160 <loaduvm>:
{
80108160:	55                   	push   %ebp
80108161:	89 e5                	mov    %esp,%ebp
80108163:	57                   	push   %edi
80108164:	56                   	push   %esi
80108165:	53                   	push   %ebx
80108166:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108169:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80108170:	0f 85 91 00 00 00    	jne    80108207 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80108176:	8b 75 18             	mov    0x18(%ebp),%esi
80108179:	31 db                	xor    %ebx,%ebx
8010817b:	85 f6                	test   %esi,%esi
8010817d:	75 1a                	jne    80108199 <loaduvm+0x39>
8010817f:	eb 6f                	jmp    801081f0 <loaduvm+0x90>
80108181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108188:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010818e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80108194:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80108197:	76 57                	jbe    801081f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108199:	8b 55 0c             	mov    0xc(%ebp),%edx
8010819c:	8b 45 08             	mov    0x8(%ebp),%eax
8010819f:	31 c9                	xor    %ecx,%ecx
801081a1:	01 da                	add    %ebx,%edx
801081a3:	e8 c8 fb ff ff       	call   80107d70 <walkpgdir>
801081a8:	85 c0                	test   %eax,%eax
801081aa:	74 4e                	je     801081fa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801081ac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801081ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801081b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801081b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801081bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801081c1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801081c4:	01 d9                	add    %ebx,%ecx
801081c6:	05 00 00 00 80       	add    $0x80000000,%eax
801081cb:	57                   	push   %edi
801081cc:	51                   	push   %ecx
801081cd:	50                   	push   %eax
801081ce:	ff 75 10             	pushl  0x10(%ebp)
801081d1:	e8 ea 99 ff ff       	call   80101bc0 <readi>
801081d6:	83 c4 10             	add    $0x10,%esp
801081d9:	39 f8                	cmp    %edi,%eax
801081db:	74 ab                	je     80108188 <loaduvm+0x28>
}
801081dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801081e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081e5:	5b                   	pop    %ebx
801081e6:	5e                   	pop    %esi
801081e7:	5f                   	pop    %edi
801081e8:	5d                   	pop    %ebp
801081e9:	c3                   	ret    
801081ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801081f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801081f3:	31 c0                	xor    %eax,%eax
}
801081f5:	5b                   	pop    %ebx
801081f6:	5e                   	pop    %esi
801081f7:	5f                   	pop    %edi
801081f8:	5d                   	pop    %ebp
801081f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801081fa:	83 ec 0c             	sub    $0xc,%esp
801081fd:	68 03 92 10 80       	push   $0x80109203
80108202:	e8 89 81 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80108207:	83 ec 0c             	sub    $0xc,%esp
8010820a:	68 a4 92 10 80       	push   $0x801092a4
8010820f:	e8 7c 81 ff ff       	call   80100390 <panic>
80108214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010821a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108220 <allocuvm>:
{
80108220:	55                   	push   %ebp
80108221:	89 e5                	mov    %esp,%ebp
80108223:	57                   	push   %edi
80108224:	56                   	push   %esi
80108225:	53                   	push   %ebx
80108226:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108229:	8b 7d 10             	mov    0x10(%ebp),%edi
8010822c:	85 ff                	test   %edi,%edi
8010822e:	0f 88 8e 00 00 00    	js     801082c2 <allocuvm+0xa2>
  if(newsz < oldsz)
80108234:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108237:	0f 82 93 00 00 00    	jb     801082d0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010823d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108240:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108246:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010824c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010824f:	0f 86 7e 00 00 00    	jbe    801082d3 <allocuvm+0xb3>
80108255:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80108258:	8b 7d 08             	mov    0x8(%ebp),%edi
8010825b:	eb 42                	jmp    8010829f <allocuvm+0x7f>
8010825d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80108260:	83 ec 04             	sub    $0x4,%esp
80108263:	68 00 10 00 00       	push   $0x1000
80108268:	6a 00                	push   $0x0
8010826a:	50                   	push   %eax
8010826b:	e8 b0 d9 ff ff       	call   80105c20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108270:	58                   	pop    %eax
80108271:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108277:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010827c:	5a                   	pop    %edx
8010827d:	6a 06                	push   $0x6
8010827f:	50                   	push   %eax
80108280:	89 da                	mov    %ebx,%edx
80108282:	89 f8                	mov    %edi,%eax
80108284:	e8 67 fb ff ff       	call   80107df0 <mappages>
80108289:	83 c4 10             	add    $0x10,%esp
8010828c:	85 c0                	test   %eax,%eax
8010828e:	78 50                	js     801082e0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80108290:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108296:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108299:	0f 86 81 00 00 00    	jbe    80108320 <allocuvm+0x100>
    mem = kalloc();
8010829f:	e8 6c a6 ff ff       	call   80102910 <kalloc>
    if(mem == 0){
801082a4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801082a6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801082a8:	75 b6                	jne    80108260 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801082aa:	83 ec 0c             	sub    $0xc,%esp
801082ad:	68 21 92 10 80       	push   $0x80109221
801082b2:	e8 a9 83 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801082b7:	83 c4 10             	add    $0x10,%esp
801082ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801082bd:	39 45 10             	cmp    %eax,0x10(%ebp)
801082c0:	77 6e                	ja     80108330 <allocuvm+0x110>
}
801082c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801082c5:	31 ff                	xor    %edi,%edi
}
801082c7:	89 f8                	mov    %edi,%eax
801082c9:	5b                   	pop    %ebx
801082ca:	5e                   	pop    %esi
801082cb:	5f                   	pop    %edi
801082cc:	5d                   	pop    %ebp
801082cd:	c3                   	ret    
801082ce:	66 90                	xchg   %ax,%ax
    return oldsz;
801082d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801082d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082d6:	89 f8                	mov    %edi,%eax
801082d8:	5b                   	pop    %ebx
801082d9:	5e                   	pop    %esi
801082da:	5f                   	pop    %edi
801082db:	5d                   	pop    %ebp
801082dc:	c3                   	ret    
801082dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801082e0:	83 ec 0c             	sub    $0xc,%esp
801082e3:	68 39 92 10 80       	push   $0x80109239
801082e8:	e8 73 83 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801082ed:	83 c4 10             	add    $0x10,%esp
801082f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801082f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801082f6:	76 0d                	jbe    80108305 <allocuvm+0xe5>
801082f8:	89 c1                	mov    %eax,%ecx
801082fa:	8b 55 10             	mov    0x10(%ebp),%edx
801082fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108300:	e8 7b fb ff ff       	call   80107e80 <deallocuvm.part.0>
      kfree(mem);
80108305:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108308:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010830a:	56                   	push   %esi
8010830b:	e8 50 a4 ff ff       	call   80102760 <kfree>
      return 0;
80108310:	83 c4 10             	add    $0x10,%esp
}
80108313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108316:	89 f8                	mov    %edi,%eax
80108318:	5b                   	pop    %ebx
80108319:	5e                   	pop    %esi
8010831a:	5f                   	pop    %edi
8010831b:	5d                   	pop    %ebp
8010831c:	c3                   	ret    
8010831d:	8d 76 00             	lea    0x0(%esi),%esi
80108320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80108323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108326:	5b                   	pop    %ebx
80108327:	89 f8                	mov    %edi,%eax
80108329:	5e                   	pop    %esi
8010832a:	5f                   	pop    %edi
8010832b:	5d                   	pop    %ebp
8010832c:	c3                   	ret    
8010832d:	8d 76 00             	lea    0x0(%esi),%esi
80108330:	89 c1                	mov    %eax,%ecx
80108332:	8b 55 10             	mov    0x10(%ebp),%edx
80108335:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80108338:	31 ff                	xor    %edi,%edi
8010833a:	e8 41 fb ff ff       	call   80107e80 <deallocuvm.part.0>
8010833f:	eb 92                	jmp    801082d3 <allocuvm+0xb3>
80108341:	eb 0d                	jmp    80108350 <deallocuvm>
80108343:	90                   	nop
80108344:	90                   	nop
80108345:	90                   	nop
80108346:	90                   	nop
80108347:	90                   	nop
80108348:	90                   	nop
80108349:	90                   	nop
8010834a:	90                   	nop
8010834b:	90                   	nop
8010834c:	90                   	nop
8010834d:	90                   	nop
8010834e:	90                   	nop
8010834f:	90                   	nop

80108350 <deallocuvm>:
{
80108350:	55                   	push   %ebp
80108351:	89 e5                	mov    %esp,%ebp
80108353:	8b 55 0c             	mov    0xc(%ebp),%edx
80108356:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108359:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010835c:	39 d1                	cmp    %edx,%ecx
8010835e:	73 10                	jae    80108370 <deallocuvm+0x20>
}
80108360:	5d                   	pop    %ebp
80108361:	e9 1a fb ff ff       	jmp    80107e80 <deallocuvm.part.0>
80108366:	8d 76 00             	lea    0x0(%esi),%esi
80108369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108370:	89 d0                	mov    %edx,%eax
80108372:	5d                   	pop    %ebp
80108373:	c3                   	ret    
80108374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010837a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108380 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108380:	55                   	push   %ebp
80108381:	89 e5                	mov    %esp,%ebp
80108383:	57                   	push   %edi
80108384:	56                   	push   %esi
80108385:	53                   	push   %ebx
80108386:	83 ec 0c             	sub    $0xc,%esp
80108389:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010838c:	85 f6                	test   %esi,%esi
8010838e:	74 59                	je     801083e9 <freevm+0x69>
80108390:	31 c9                	xor    %ecx,%ecx
80108392:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108397:	89 f0                	mov    %esi,%eax
80108399:	e8 e2 fa ff ff       	call   80107e80 <deallocuvm.part.0>
8010839e:	89 f3                	mov    %esi,%ebx
801083a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801083a6:	eb 0f                	jmp    801083b7 <freevm+0x37>
801083a8:	90                   	nop
801083a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801083b3:	39 fb                	cmp    %edi,%ebx
801083b5:	74 23                	je     801083da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801083b7:	8b 03                	mov    (%ebx),%eax
801083b9:	a8 01                	test   $0x1,%al
801083bb:	74 f3                	je     801083b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801083bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801083c2:	83 ec 0c             	sub    $0xc,%esp
801083c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801083c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801083cd:	50                   	push   %eax
801083ce:	e8 8d a3 ff ff       	call   80102760 <kfree>
801083d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801083d6:	39 fb                	cmp    %edi,%ebx
801083d8:	75 dd                	jne    801083b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801083da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801083dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083e0:	5b                   	pop    %ebx
801083e1:	5e                   	pop    %esi
801083e2:	5f                   	pop    %edi
801083e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801083e4:	e9 77 a3 ff ff       	jmp    80102760 <kfree>
    panic("freevm: no pgdir");
801083e9:	83 ec 0c             	sub    $0xc,%esp
801083ec:	68 55 92 10 80       	push   $0x80109255
801083f1:	e8 9a 7f ff ff       	call   80100390 <panic>
801083f6:	8d 76 00             	lea    0x0(%esi),%esi
801083f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108400 <setupkvm>:
{
80108400:	55                   	push   %ebp
80108401:	89 e5                	mov    %esp,%ebp
80108403:	56                   	push   %esi
80108404:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108405:	e8 06 a5 ff ff       	call   80102910 <kalloc>
8010840a:	85 c0                	test   %eax,%eax
8010840c:	89 c6                	mov    %eax,%esi
8010840e:	74 42                	je     80108452 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108410:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108413:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108418:	68 00 10 00 00       	push   $0x1000
8010841d:	6a 00                	push   $0x0
8010841f:	50                   	push   %eax
80108420:	e8 fb d7 ff ff       	call   80105c20 <memset>
80108425:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108428:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010842b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010842e:	83 ec 08             	sub    $0x8,%esp
80108431:	8b 13                	mov    (%ebx),%edx
80108433:	ff 73 0c             	pushl  0xc(%ebx)
80108436:	50                   	push   %eax
80108437:	29 c1                	sub    %eax,%ecx
80108439:	89 f0                	mov    %esi,%eax
8010843b:	e8 b0 f9 ff ff       	call   80107df0 <mappages>
80108440:	83 c4 10             	add    $0x10,%esp
80108443:	85 c0                	test   %eax,%eax
80108445:	78 19                	js     80108460 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108447:	83 c3 10             	add    $0x10,%ebx
8010844a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108450:	75 d6                	jne    80108428 <setupkvm+0x28>
}
80108452:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108455:	89 f0                	mov    %esi,%eax
80108457:	5b                   	pop    %ebx
80108458:	5e                   	pop    %esi
80108459:	5d                   	pop    %ebp
8010845a:	c3                   	ret    
8010845b:	90                   	nop
8010845c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108460:	83 ec 0c             	sub    $0xc,%esp
80108463:	56                   	push   %esi
      return 0;
80108464:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108466:	e8 15 ff ff ff       	call   80108380 <freevm>
      return 0;
8010846b:	83 c4 10             	add    $0x10,%esp
}
8010846e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108471:	89 f0                	mov    %esi,%eax
80108473:	5b                   	pop    %ebx
80108474:	5e                   	pop    %esi
80108475:	5d                   	pop    %ebp
80108476:	c3                   	ret    
80108477:	89 f6                	mov    %esi,%esi
80108479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108480 <kvmalloc>:
{
80108480:	55                   	push   %ebp
80108481:	89 e5                	mov    %esp,%ebp
80108483:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108486:	e8 75 ff ff ff       	call   80108400 <setupkvm>
8010848b:	a3 e4 86 11 80       	mov    %eax,0x801186e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108490:	05 00 00 00 80       	add    $0x80000000,%eax
80108495:	0f 22 d8             	mov    %eax,%cr3
}
80108498:	c9                   	leave  
80108499:	c3                   	ret    
8010849a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801084a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801084a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801084a1:	31 c9                	xor    %ecx,%ecx
{
801084a3:	89 e5                	mov    %esp,%ebp
801084a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801084a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801084ab:	8b 45 08             	mov    0x8(%ebp),%eax
801084ae:	e8 bd f8 ff ff       	call   80107d70 <walkpgdir>
  if(pte == 0)
801084b3:	85 c0                	test   %eax,%eax
801084b5:	74 05                	je     801084bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801084b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801084ba:	c9                   	leave  
801084bb:	c3                   	ret    
    panic("clearpteu");
801084bc:	83 ec 0c             	sub    $0xc,%esp
801084bf:	68 66 92 10 80       	push   $0x80109266
801084c4:	e8 c7 7e ff ff       	call   80100390 <panic>
801084c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801084d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801084d0:	55                   	push   %ebp
801084d1:	89 e5                	mov    %esp,%ebp
801084d3:	57                   	push   %edi
801084d4:	56                   	push   %esi
801084d5:	53                   	push   %ebx
801084d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801084d9:	e8 22 ff ff ff       	call   80108400 <setupkvm>
801084de:	85 c0                	test   %eax,%eax
801084e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801084e3:	0f 84 9f 00 00 00    	je     80108588 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801084e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801084ec:	85 c9                	test   %ecx,%ecx
801084ee:	0f 84 94 00 00 00    	je     80108588 <copyuvm+0xb8>
801084f4:	31 ff                	xor    %edi,%edi
801084f6:	eb 4a                	jmp    80108542 <copyuvm+0x72>
801084f8:	90                   	nop
801084f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108500:	83 ec 04             	sub    $0x4,%esp
80108503:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80108509:	68 00 10 00 00       	push   $0x1000
8010850e:	53                   	push   %ebx
8010850f:	50                   	push   %eax
80108510:	e8 bb d7 ff ff       	call   80105cd0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108515:	58                   	pop    %eax
80108516:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010851c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108521:	5a                   	pop    %edx
80108522:	ff 75 e4             	pushl  -0x1c(%ebp)
80108525:	50                   	push   %eax
80108526:	89 fa                	mov    %edi,%edx
80108528:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010852b:	e8 c0 f8 ff ff       	call   80107df0 <mappages>
80108530:	83 c4 10             	add    $0x10,%esp
80108533:	85 c0                	test   %eax,%eax
80108535:	78 61                	js     80108598 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108537:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010853d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80108540:	76 46                	jbe    80108588 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108542:	8b 45 08             	mov    0x8(%ebp),%eax
80108545:	31 c9                	xor    %ecx,%ecx
80108547:	89 fa                	mov    %edi,%edx
80108549:	e8 22 f8 ff ff       	call   80107d70 <walkpgdir>
8010854e:	85 c0                	test   %eax,%eax
80108550:	74 61                	je     801085b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108552:	8b 00                	mov    (%eax),%eax
80108554:	a8 01                	test   $0x1,%al
80108556:	74 4e                	je     801085a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108558:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010855a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010855f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80108565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108568:	e8 a3 a3 ff ff       	call   80102910 <kalloc>
8010856d:	85 c0                	test   %eax,%eax
8010856f:	89 c6                	mov    %eax,%esi
80108571:	75 8d                	jne    80108500 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108573:	83 ec 0c             	sub    $0xc,%esp
80108576:	ff 75 e0             	pushl  -0x20(%ebp)
80108579:	e8 02 fe ff ff       	call   80108380 <freevm>
  return 0;
8010857e:	83 c4 10             	add    $0x10,%esp
80108581:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010858b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010858e:	5b                   	pop    %ebx
8010858f:	5e                   	pop    %esi
80108590:	5f                   	pop    %edi
80108591:	5d                   	pop    %ebp
80108592:	c3                   	ret    
80108593:	90                   	nop
80108594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108598:	83 ec 0c             	sub    $0xc,%esp
8010859b:	56                   	push   %esi
8010859c:	e8 bf a1 ff ff       	call   80102760 <kfree>
      goto bad;
801085a1:	83 c4 10             	add    $0x10,%esp
801085a4:	eb cd                	jmp    80108573 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801085a6:	83 ec 0c             	sub    $0xc,%esp
801085a9:	68 8a 92 10 80       	push   $0x8010928a
801085ae:	e8 dd 7d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801085b3:	83 ec 0c             	sub    $0xc,%esp
801085b6:	68 70 92 10 80       	push   $0x80109270
801085bb:	e8 d0 7d ff ff       	call   80100390 <panic>

801085c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801085c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085c1:	31 c9                	xor    %ecx,%ecx
{
801085c3:	89 e5                	mov    %esp,%ebp
801085c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801085c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801085cb:	8b 45 08             	mov    0x8(%ebp),%eax
801085ce:	e8 9d f7 ff ff       	call   80107d70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801085d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801085d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801085d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801085d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801085dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801085e0:	05 00 00 00 80       	add    $0x80000000,%eax
801085e5:	83 fa 05             	cmp    $0x5,%edx
801085e8:	ba 00 00 00 00       	mov    $0x0,%edx
801085ed:	0f 45 c2             	cmovne %edx,%eax
}
801085f0:	c3                   	ret    
801085f1:	eb 0d                	jmp    80108600 <copyout>
801085f3:	90                   	nop
801085f4:	90                   	nop
801085f5:	90                   	nop
801085f6:	90                   	nop
801085f7:	90                   	nop
801085f8:	90                   	nop
801085f9:	90                   	nop
801085fa:	90                   	nop
801085fb:	90                   	nop
801085fc:	90                   	nop
801085fd:	90                   	nop
801085fe:	90                   	nop
801085ff:	90                   	nop

80108600 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108600:	55                   	push   %ebp
80108601:	89 e5                	mov    %esp,%ebp
80108603:	57                   	push   %edi
80108604:	56                   	push   %esi
80108605:	53                   	push   %ebx
80108606:	83 ec 1c             	sub    $0x1c,%esp
80108609:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010860c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010860f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108612:	85 db                	test   %ebx,%ebx
80108614:	75 40                	jne    80108656 <copyout+0x56>
80108616:	eb 70                	jmp    80108688 <copyout+0x88>
80108618:	90                   	nop
80108619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108623:	89 f1                	mov    %esi,%ecx
80108625:	29 d1                	sub    %edx,%ecx
80108627:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010862d:	39 d9                	cmp    %ebx,%ecx
8010862f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108632:	29 f2                	sub    %esi,%edx
80108634:	83 ec 04             	sub    $0x4,%esp
80108637:	01 d0                	add    %edx,%eax
80108639:	51                   	push   %ecx
8010863a:	57                   	push   %edi
8010863b:	50                   	push   %eax
8010863c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010863f:	e8 8c d6 ff ff       	call   80105cd0 <memmove>
    len -= n;
    buf += n;
80108644:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108647:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010864a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108650:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108652:	29 cb                	sub    %ecx,%ebx
80108654:	74 32                	je     80108688 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108656:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108658:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010865b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010865e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108664:	56                   	push   %esi
80108665:	ff 75 08             	pushl  0x8(%ebp)
80108668:	e8 53 ff ff ff       	call   801085c0 <uva2ka>
    if(pa0 == 0)
8010866d:	83 c4 10             	add    $0x10,%esp
80108670:	85 c0                	test   %eax,%eax
80108672:	75 ac                	jne    80108620 <copyout+0x20>
  }
  return 0;
}
80108674:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010867c:	5b                   	pop    %ebx
8010867d:	5e                   	pop    %esi
8010867e:	5f                   	pop    %edi
8010867f:	5d                   	pop    %ebp
80108680:	c3                   	ret    
80108681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108688:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010868b:	31 c0                	xor    %eax,%eax
}
8010868d:	5b                   	pop    %ebx
8010868e:	5e                   	pop    %esi
8010868f:	5f                   	pop    %edi
80108690:	5d                   	pop    %ebp
80108691:	c3                   	ret    
